main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_warios_shipyard", 0);

	setExpFog(13287.4014, 52875.9805, 1, 1, 1, 0);

	level.iz_cue = [];
	level.iz_cue["iz_cue_boost"] = true;
	level.iz_cue["iz_cue_bounce"] = true;
	level.iz_cue["iz_cue_cannon"] = true;
	level.iz_cue["iz_cue_finish"] = true;
	level.iz_cue["iz_cue_item"] = true;
	level.iz_cue["iz_cue_jump"] = true;
	thread iz_sounds();

	thread iz_course();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_113", 2);
}

iz_course()
{
	iz_course_route();
	level.iz_course_gates = 0;
	gates = getEntArray("iz_gate", "targetname");
	for (i = 0; i < gates.size; i++)
	{
		gates[i].iz_order = int(gates[i].script_noteworthy);
		if (gates[i].iz_order > level.iz_course_gates)
			level.iz_course_gates = gates[i].iz_order;
	}
	iz_course_each("iz_gate", ::iz_course_gate);
	iz_course_each("iz_finish", ::iz_course_finish);
	iz_course_each("iz_boost", ::iz_course_boost);
	iz_course_each("iz_cannon", ::iz_course_cannon);
	iz_course_each("iz_jump", ::iz_course_jump);
	iz_course_each("iz_fall", ::iz_course_fall);
	iz_course_each("iz_itembox", ::iz_course_itembox);
	gone = 0;
	for (i = 0; gone < 16; i++)
	{
		mover = getEnt("iz_obj_" + i, "targetname");
		if (!isDefined(mover))
		{
			gone++;
			continue;
		}
		gone = 0;
		mover notSolid();
		if (isDefined(mover.radius))
			mover thread iz_course_hazard();
	}

	for (;;)
	{
		level waittill("player_spawn", player);
		player.iz_gate = 0;
	}
}

// One of the course's own sounds from whoever makes it, no sooner than
// rest milliseconds after they last made it.
iz_course_cue(name, rest)
{
	alias = "iz_cue_" + name;
	if (!isDefined(level.iz_cue) || !isDefined(level.iz_cue[alias]))
		return;
	if (rest > 0)
	{
		if (!isDefined(self.iz_cued))
			self.iz_cued = [];
		if (isDefined(self.iz_cued[name]) && getTime() - self.iz_cued[name] < rest)
			return;
		self.iz_cued[name] = getTime();
	}
	self playSound(alias);
}

iz_course_each(name, run)
{
	ents = getEntArray(name, "targetname");
	for (i = 0; i < ents.size; i++)
		ents[i] thread [[run]]();
}

iz_course_gate()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (isDefined(player.iz_gate) && player.iz_gate == self.iz_order - 1)
			player.iz_gate = self.iz_order;
	}
}

iz_course_finish()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (!isDefined(player.iz_gate) || player.iz_gate < level.iz_course_gates)
			continue;
		player.iz_gate = 0;
		player iz_course_cue("finish", 0);
		player sr\api\_speedrun::finishWay("normal_0");
	}
}

iz_course_boost()
{
	speed = int(self.script_noteworthy);
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player))
			continue;

		velocity = player getVelocity();
		way = (velocity[0], velocity[1], 0);
		player iz_course_cue("boost", 1000);
		if (length(way) >= speed)
			continue;
		if (length(way) < 50)
			way = anglesToForward((0, player getPlayerAngles()[1], 0));
		else
			way = vectorNormalize(way);
		player setVelocity((way[0] * speed, way[1] * speed, velocity[2]));
	}
}

iz_course_jump()
{
	toss = strTok(self.script_noteworthy, " ");
	if (toss.size != 4)
		return;
	speed = int(toss[0]);
	rise = int(toss[1]);
	rest = int(toss[2]);
	cue = toss[3];
	for (;;)
	{
		self waittill("trigger", player);
		now = getTime();
		if (!isPlayer(player) || !isAlive(player))
			continue;
		if (rest > 0)
		{
			if (isDefined(player.iz_thrown) && now - player.iz_thrown < rest)
				continue;
			player.iz_thrown = now;
		}

		velocity = player getVelocity();
		if (rest > 0)
		{
			player setVelocity((velocity[0], velocity[1], rise));
			player iz_course_cue(cue, 0);
			continue;
		}
		player iz_course_cue(cue, 1000);
		way = (velocity[0], velocity[1], 0);
		pace = length(way);
		if (pace < 50)
			way = anglesToForward((0, player getPlayerAngles()[1], 0));
		else
			way = vectorNormalize(way);
		if (pace < speed)
			pace = speed;
		player setVelocity((way[0] * pace, way[1] * pace, rise));
	}
}

iz_course_cannon()
{
	ends = getEntArray("iz_cannon_end", "targetname");
	for (i = 0; i < ends.size; i++)
	{
		flight = strTok(ends[i].script_noteworthy, " ");
		if (flight.size == 3 && flight[0] == self.script_noteworthy)
			self.iz_end = ends[i].origin;
	}
	if (!isDefined(self.iz_end))
		return;
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player))
			continue;

		velocity = player getVelocity();
		speed = length((velocity[0], velocity[1], 0));
		way = vectorNormalize((self.iz_end[0] - player.origin[0], self.iz_end[1] - player.origin[1], 0));
		player setOrigin(self.iz_end);
		player iz_course_cue("cannon", 0);
		player setPlayerAngles((0, vectorToAngles(way)[1], 0));
		player setVelocity((way[0] * speed, way[1] * speed, velocity[2]));
	}
}

iz_course_fall()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (isPlayer(player) && isAlive(player))
			player suicide();
	}
}

iz_course_itembox()
{
	self notSolid();
	reach = 60;
	if (isDefined(self.radius))
		reach = self.radius;
	marks = getEntArray("iz_itembox_mark", "targetname");
	for (i = 0; i < marks.size; i++)
		if (distance(marks[i].origin, self.origin) < 4)
			self.iz_mark = marks[i];
	if (isDefined(self.iz_mark))
	{
		self.iz_mark notSolid();
		self.iz_mark thread iz_course_turn();
		self.iz_mark thread iz_course_slide();
	}
	self thread iz_course_spin();
	self thread iz_course_slide();
	for (;;)
	{
		wait 0.05;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isAlive(players[i]) || distance(players[i].origin + (0, 0, 35), self.origin) > reach)
				continue;
			self.iz_taken = true;
			self iz_course_cue("item", 0);
			self hide();
			if (isDefined(self.iz_mark))
				self.iz_mark hide();
			wait 3;
			self show();
			if (isDefined(self.iz_mark))
				self.iz_mark show();
			self.iz_taken = undefined;
			break;
		}
	}
}

iz_course_hazard()
{
	reach = self.radius;
	for (;;)
	{
		wait 0.05;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!isAlive(player))
				continue;
			away = (player.origin[0] - self.origin[0], player.origin[1] - self.origin[1], 0);
			if (length(away) > reach || player.origin[2] > self.origin[2] + reach * 2 || player.origin[2] + 72 < self.origin[2])
				continue;
			now = getTime();
			if (isDefined(player.iz_struck) && now - player.iz_struck < 1500)
				continue;
			player.iz_struck = now;
			if (length(away) < 1)
				away = anglesToForward((0, randomInt(360), 0));
			away = vectorNormalize(away);
			player setVelocity((away[0] * 320, away[1] * 320, 240));
			player notify("iz_hit", self);
		}
	}
}

iz_course_slide()
{
	if (!isDefined(self.script_noteworthy))
		return;
	path = strTok(self.script_noteworthy, " ");
	if (path.size != 8)
		return;
	from = (int(path[0]), int(path[1]), int(path[2]));
	to = (int(path[3]), int(path[4]), int(path[5]));
	way = int(path[6]) / 2000;
	if (way < 0.1)
		return;
	if (int(path[7]) > 0)
		wait int(path[7]) / 1000;
	for (;;)
	{
		self moveTo(to, way, way / 2, way / 2);
		wait way;
		self moveTo(from, way, way / 2, way / 2);
		wait way;
	}
}

iz_course_spin()
{
	for (;;)
	{
		self rotateVelocity((40, 110, 25), 10);
		wait 10;
	}
}

iz_course_turn()
{
	for (;;)
	{
		self rotateYaw(360, 8);
		wait 8;
	}
}

iz_course_route()
{
	level.iz_route = [];
	level.iz_route[level.iz_route.size] = (-3839, 6169, 4509);
	level.iz_route[level.iz_route.size] = (-4807, 6189, 4447);
	level.iz_route[level.iz_route.size] = (-5847, 6210, 4381);
	level.iz_route[level.iz_route.size] = (-6574, 6225, 4342);
	level.iz_route[level.iz_route.size] = (-8009, 6425, 4351);
	level.iz_route[level.iz_route.size] = (-9176, 6552, 4479);
	level.iz_route[level.iz_route.size] = (-9660, 5717, 4364);
	level.iz_route[level.iz_route.size] = (-9498, 4676, 4073);
	level.iz_route[level.iz_route.size] = (-9243, 3766, 3920);
	level.iz_route[level.iz_route.size] = (-8793, 2122, 4166);
	level.iz_route[level.iz_route.size] = (-8662, 1439, 3521);
	level.iz_route[level.iz_route.size] = (-8221, -419, 3566);
	level.iz_route[level.iz_route.size] = (-8164, -2284, 3742);
	level.iz_route[level.iz_route.size] = (-8807, -3179, 3774);
	level.iz_route[level.iz_route.size] = (-10042, -3488, 3880);
	level.iz_route[level.iz_route.size] = (-11824, -3272, 3768);
	level.iz_route[level.iz_route.size] = (-13916, -3233, 4177);
	level.iz_route[level.iz_route.size] = (-16000, -3150, 3887);
	level.iz_route[level.iz_route.size] = (-17267, -3047, 3887);
	level.iz_route[level.iz_route.size] = (-18270, -3016, 3908);
	level.iz_route[level.iz_route.size] = (-19073, -2772, 3939);
	level.iz_route[level.iz_route.size] = (-19789, -2385, 3961);
	level.iz_route[level.iz_route.size] = (-20214, -1832, 3951);
	level.iz_route[level.iz_route.size] = (-20342, -895, 3904);
	level.iz_route[level.iz_route.size] = (-20304, -163, 3872);
	level.iz_route[level.iz_route.size] = (-19837, 603, 3812);
	level.iz_route[level.iz_route.size] = (-18721, 1232, 3693);
	level.iz_route[level.iz_route.size] = (-16947, 1445, 3513);
	level.iz_route[level.iz_route.size] = (-15374, 1618, 3417);
	level.iz_route[level.iz_route.size] = (-14125, 2119, 3374);
	level.iz_route[level.iz_route.size] = (-13398, 3118, 3104);
	level.iz_route[level.iz_route.size] = (-13221, 4545, 2853);
	level.iz_route[level.iz_route.size] = (-13039, 5931, 2975);
	level.iz_route[level.iz_route.size] = (-12682, 8180, 2825);
	level.iz_route[level.iz_route.size] = (-12004, 9297, 2700);
	level.iz_route[level.iz_route.size] = (-12053, 10458, 2655);
	level.iz_route[level.iz_route.size] = (-12891, 11401, 2648);
	level.iz_route[level.iz_route.size] = (-13442, 11583, 2698);
	level.iz_route[level.iz_route.size] = (-14859, 11663, 3302);
	level.iz_route[level.iz_route.size] = (-16255, 11727, 4208);
	level.iz_route[level.iz_route.size] = (-17018, 11733, 4710);
	level.iz_route[level.iz_route.size] = (-17545, 11773, 5087);
	level.iz_route[level.iz_route.size] = (-18013, 11841, 5448);
	level.iz_route[level.iz_route.size] = (-18458, 12048, 5799);
	level.iz_route[level.iz_route.size] = (-18696, 12321, 5981);
	level.iz_route[level.iz_route.size] = (-18850, 12942, 6103);
	level.iz_route[level.iz_route.size] = (-18874, 13498, 6176);
	level.iz_route[level.iz_route.size] = (-18462, 14161, 5913);
	level.iz_route[level.iz_route.size] = (-17990, 14498, 5589);
	level.iz_route[level.iz_route.size] = (-17270, 14551, 5171);
	level.iz_route[level.iz_route.size] = (-16557, 14399, 4793);
	level.iz_route[level.iz_route.size] = (-15628, 13921, 4296);
	level.iz_route[level.iz_route.size] = (-14547, 13373, 3785);
	level.iz_route[level.iz_route.size] = (-13206, 12901, 3679);
	level.iz_route[level.iz_route.size] = (-11657, 12678, 3697);
	level.iz_route[level.iz_route.size] = (-10136, 12545, 4128);
	level.iz_route[level.iz_route.size] = (-8966, 12285, 3626);
	level.iz_route[level.iz_route.size] = (-6578, 11830, 3898);
	level.iz_route[level.iz_route.size] = (-4185, 11026, 4153);
	level.iz_route[level.iz_route.size] = (-1913, 10629, 4301);
	level.iz_route[level.iz_route.size] = (-589, 10509, 4488);
	level.iz_route[level.iz_route.size] = (314, 9586, 4755);
	level.iz_route[level.iz_route.size] = (504, 8585, 4891);
	level.iz_route[level.iz_route.size] = (453, 6998, 4990);
	level.iz_route[level.iz_route.size] = (-585, 6129, 4779);
	level.iz_route[level.iz_route.size] = (-2441, 6132, 4598);
	level.iz_route[level.iz_route.size] = (-3290, 6134, 4544);
	level.iz_route[level.iz_route.size] = (-3473, 6134, 4532);
}

iz_move(origin, angles, frames)
{
	if (!isDefined(self.iz_step))
	{
		self.iz_step = (0, 0, 0);
		self.iz_turn = (0, 0, 0);
	}
	time = frames * 0.05 + 0.0005;
	if (isDefined(origin))
	{
		to = origin - self.iz_step;
		self.iz_step = (to - self.origin) * (1.0 / frames);
		self moveTo(to, time);
	}
	if (isDefined(angles))
	{
		turn = angles - self.iz_turn - self.angles;
		turn = (iz_wrap(turn[0]), iz_wrap(turn[1]), iz_wrap(turn[2]));
		self.iz_turn = turn * (1.0 / frames);
		self rotateTo(self.angles + turn, time);
	}
}

iz_wrap(angle)
{
	return angle - 360 * floor(angle / 360 + 0.5);
}

iz_place(origin, angles)
{
	self.origin = origin;
	if (isDefined(angles))
		self.angles = angles;
	self.iz_step = (0, 0, 0);
	self.iz_turn = (0, 0, 0);
}

iz_stop(origin, angles)
{
	self iz_move(origin, angles, 1);
	wait 0.05;
	self iz_move(origin, angles, 1);
}

iz_anims()
{
	thread iz_obj_0();
	thread iz_obj_1();
	thread iz_obj_2();
	thread iz_obj_3();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-10602.7158, 5779.6455, 3068.3662);
	angles[0] = (0, 96.4740, 0);
	at[0] = 0;
	points[1] = (-10669.7236, 5772.4409, 3068.3662);
	angles[1] = (0, 95.8358, 0);
	at[1] = 0.1333;
	points[2] = (-10743.0703, 5765.2363, 3068.3662);
	angles[2] = (0, 95.4281, 0);
	at[2] = 0.2667;
	points[3] = (-10811.6934, 5758.8579, 3068.3662);
	angles[3] = (0, 95.1923, 0);
	at[3] = 0.4000;
	points[4] = (-10884.6064, 5752.3623, 3068.3662);
	angles[4] = (0, 95.0361, 0);
	at[4] = 0.5333;
	points[5] = (-11414.4092, 5706.0234, 3068.3662);
	angles[5] = (0, 95.2843, 0);
	at[5] = 1.5333;
	points[6] = (-11733.1895, 5673.6611, 3068.3662);
	angles[6] = (0, 96.5108, 0);
	at[6] = 2.1333;
	points[7] = (-11943.3857, 5646.4175, 3068.3662);
	angles[7] = (0, 98.5669, 0);
	at[7] = 2.5333;
	points[8] = (-12015.7871, 5634.6455, 3068.3662);
	angles[8] = (0, 99.9935, 0);
	at[8] = 2.6667;
	points[9] = (-12048.5049, 5628.6221, 3068.3662);
	angles[9] = (0, 100.9338, 0);
	at[9] = 2.7333;
	points[10] = (-12120.5518, 5612.6772, 3068.3662);
	angles[10] = (0, 104.5472, 0);
	at[10] = 2.8667;
	points[11] = (-12150.7080, 5604.0552, 3068.3662);
	angles[11] = (0, 107.6539, 0);
	at[11] = 2.9333;
	points[12] = (-12181.6143, 5592.4414, 3068.3662);
	angles[12] = (0, 113.1778, 0);
	at[12] = 3;
	points[13] = (-12245.7080, 5559.6064, 3068.3662);
	angles[13] = (0, 120.2353, 0);
	at[13] = 3.1333;
	points[14] = (-12363.3467, 5480.9053, 3068.3662);
	angles[14] = (0, 126.3622, 0);
	at[14] = 3.4000;
	points[15] = (-12475.9453, 5393.6221, 3068.3662);
	angles[15] = (0, 128.8370, 0);
	at[15] = 3.6667;
	points[16] = (-12751.8506, 5168.1494, 3068.3662);
	angles[16] = (0, 128.2022, 0);
	at[16] = 4.3333;
	points[17] = (-12866.2207, 5083.2681, 3068.3662);
	angles[17] = (0, 124.2989, 0);
	at[17] = 4.6000;
	points[18] = (-12926.3389, 5045.1968, 3068.3662);
	angles[18] = (0, 119.9720, 0);
	at[18] = 4.7333;
	points[19] = (-12989.3301, 5014.2915, 3068.3662);
	angles[19] = (0, 110.9990, 0);
	at[19] = 4.8667;
	points[20] = (-13024.0557, 5003.8975, 3068.3662);
	angles[20] = (0, 101.3323, 0);
	at[20] = 4.9333;
	points[21] = (-13054.7246, 5001.2207, 3068.3662);
	angles[21] = (0, 89.0450, 0);
	at[21] = 5;
	points[22] = (-13089.4482, 5004.2520, 3068.3662);
	angles[22] = (0, 81.8734, 0);
	at[22] = 5.0667;
	points[23] = (-13125.9844, 5010.9448, 3068.3662);
	angles[23] = (0, 77.7420, 0);
	at[23] = 5.1333;
	points[24] = (-13194.4492, 5028.8979, 3068.3662);
	angles[24] = (0, 73.3451, 0);
	at[24] = 5.2667;
	points[25] = (-13295.1191, 5062.7954, 3068.3662);
	angles[25] = (0, 69.7553, 0);
	at[25] = 5.4667;
	points[26] = (-13427.5195, 5115.8267, 3068.3662);
	angles[26] = (0, 66.8031, 0);
	at[26] = 5.7333;
	points[27] = (-13557.2051, 5174.4883, 3068.3662);
	angles[27] = (0, 64.5597, 0);
	at[27] = 6;
	points[28] = (-13684.6455, 5238.0317, 3068.3662);
	angles[28] = (0, 62.4064, 0);
	at[28] = 6.2667;
	points[29] = (-13809.2520, 5306.6143, 3068.3662);
	angles[29] = (0, 59.8226, 0);
	at[29] = 6.5333;
	points[30] = (-13900.9062, 5362.7954, 3068.3662);
	angles[30] = (0, 56.9286, 0);
	at[30] = 6.7333;
	points[31] = (-13928.6611, 5381.2993, 3068.3662);
	angles[31] = (0, 55.6477, 0);
	at[31] = 6.8000;
	points[32] = (-13987.8740, 5424.8027, 3068.3662);
	angles[32] = (0, 51.2609, 0);
	at[32] = 6.9333;
	points[33] = (-14014.4102, 5447.4414, 3068.3662);
	angles[33] = (0, 47.4368, 0);
	at[33] = 7;
	points[34] = (-14040, 5473.9370, 3068.3662);
	angles[34] = (0, 39.4887, 0);
	at[34] = 7.0667;
	points[35] = (-14056.2217, 5499.2520, 3068.3662);
	angles[35] = (0, 25.1098, 0);
	at[35] = 7.1333;
	points[36] = (-14067.9922, 5533.5039, 3068.3662);
	angles[36] = (0, 14.1262, 0);
	at[36] = 7.2000;
	points[37] = (-14074.6455, 5567.5195, 3068.3662);
	angles[37] = (0, 8.4297, 0);
	at[37] = 7.2667;
	points[38] = (-14080.6309, 5639.2520, 3068.3662);
	angles[38] = (0, 1.8943, 0);
	at[38] = 7.4000;
	points[39] = (-14080.5117, 5710.5117, 3068.3662);
	angles[39] = (0, -1.8185, 0);
	at[39] = 7.5333;
	points[40] = (-14073.5430, 5816.7720, 3068.3662);
	angles[40] = (0, -5.4646, 0);
	at[40] = 7.7333;
	points[41] = (-14060.7881, 5922.5591, 3068.3662);
	angles[41] = (0, -8.1767, 0);
	at[41] = 7.9333;
	points[42] = (-14036.6543, 6062.5200, 3068.3662);
	angles[42] = (0, -11.4034, 0);
	at[42] = 8.2000;
	points[43] = (-14003.9766, 6201.7715, 3068.3662);
	angles[43] = (0, -15.2269, 0);
	at[43] = 8.4667;
	points[44] = (-13984.1729, 6268.6616, 3068.3662);
	angles[44] = (0, -17.9391, 0);
	at[44] = 8.6000;
	points[45] = (-13959.4492, 6336.5356, 3068.3662);
	angles[45] = (0, -22.5763, 0);
	at[45] = 8.7333;
	points[46] = (-13944.3311, 6369.6851, 3068.3662);
	angles[46] = (0, -26.8343, 0);
	at[46] = 8.8000;
	points[47] = (-13927.1260, 6399.2520, 3068.3662);
	angles[47] = (0, -34.5898, 0);
	at[47] = 8.8667;
	points[48] = (-13907.2051, 6423.1494, 3068.3662);
	angles[48] = (0, -43.9741, 0);
	at[48] = 8.9333;
	points[49] = (-13879.1338, 6449.2915, 3068.3662);
	angles[49] = (0, -49.4778, 0);
	at[49] = 9;
	points[50] = (-13853.3867, 6470.1572, 3068.3662);
	angles[50] = (0, -52.2806, 0);
	at[50] = 9.0667;
	points[51] = (-13794.8428, 6512.1655, 3068.3662);
	angles[51] = (0, -56.0498, 0);
	at[51] = 9.2000;
	points[52] = (-13674.0166, 6586.6143, 3068.3662);
	angles[52] = (0, -60.3031, 0);
	at[52] = 9.4667;
	points[53] = (-13548.2285, 6653.8193, 3068.3662);
	angles[53] = (0, -63.4154, 0);
	at[53] = 9.7333;
	points[54] = (-13419.5273, 6713.9766, 3068.3662);
	angles[54] = (0, -66.5667, 0);
	at[54] = 10;
	points[55] = (-13286.7725, 6766.1416, 3068.3662);
	angles[55] = (0, -70.8517, 0);
	at[55] = 10.2667;
	points[56] = (-13184.1729, 6796.7720, 3068.3662);
	angles[56] = (0, -76.5018, 0);
	at[56] = 10.4667;
	points[57] = (-13115.1572, 6809.2124, 3068.3662);
	angles[57] = (0, -84.0207, 0);
	at[57] = 10.6000;
	points[58] = (-13078.2285, 6810.7876, 3068.3662);
	angles[58] = (0, -91.8467, 0);
	at[58] = 10.6667;
	points[59] = (-13047.5205, 6806.7324, 3068.3662);
	angles[59] = (0, -104.2315, 0);
	at[59] = 10.7333;
	points[60] = (-13014.8428, 6795, 3068.3662);
	angles[60] = (0, -114.1376, 0);
	at[60] = 10.8000;
	points[61] = (-12982.2041, 6778.3076, 3068.3662);
	angles[61] = (0, -119.5211, 0);
	at[61] = 10.8667;
	points[62] = (-12921.8105, 6739.7642, 3068.3662);
	angles[62] = (0, -124.8669, 0);
	at[62] = 11;
	points[63] = (-12865.8662, 6698.6221, 3068.3662);
	angles[63] = (0, -127.5096, 0);
	at[63] = 11.1333;
	points[64] = (-12782.2441, 6631.6138, 3068.3662);
	angles[64] = (0, -129.6619, 0);
	at[64] = 11.3333;
	points[65] = (-12458.1104, 6352.7559, 3068.3662);
	angles[65] = (0, -130.2776, 0);
	at[65] = 12.1333;
	points[66] = (-12320.2363, 6240.5122, 3068.3662);
	angles[66] = (0, -127.5961, 0);
	at[66] = 12.4667;
	points[67] = (-12205.0791, 6159.0156, 3068.3662);
	angles[67] = (0, -122.0918, 0);
	at[67] = 12.7333;
	points[68] = (-12141.5352, 6123.5039, 3068.3662);
	angles[68] = (0, -115.4844, 0);
	at[68] = 12.8667;
	points[69] = (-12112.1270, 6110.9839, 3068.3662);
	angles[69] = (0, -110.5577, 0);
	at[69] = 12.9333;
	points[70] = (-12081.7725, 6100.5513, 3068.3662);
	angles[70] = (0, -107.6013, 0);
	at[70] = 13;
	points[71] = (-12010.9053, 6080.7480, 3068.3662);
	angles[71] = (0, -104.0471, 0);
	at[71] = 13.1333;
	points[72] = (-11978.2676, 6072.9136, 3068.3662);
	angles[72] = (0, -103.0747, 0);
	at[72] = 13.2000;
	points[73] = (-11906.4180, 6057.2832, 3068.3662);
	angles[73] = (0, -101.5838, 0);
	at[73] = 13.3333;
	points[74] = (-11698.1895, 6019.3311, 3068.3662);
	angles[74] = (0, -99.3964, 0);
	at[74] = 13.7333;
	points[75] = (-11416.6143, 5976.2993, 3068.3662);
	angles[75] = (0, -98.1621, 0);
	at[75] = 14.2667;
	points[76] = (-10782.0479, 5889.2124, 3068.3662);
	angles[76] = (0, -98.0397, 0);
	at[76] = 15.4667;
	points[77] = (-10607.7568, 5863.1890, 3068.3662);
	angles[77] = (0, -99.1867, 0);
	at[77] = 15.8000;
	points[78] = (-10602.7158, 5779.6455, 3068.3662);
	angles[78] = (0, -263.5260, 0);
	at[78] = 15.8333;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-16715.9453, 4546.1025, 1467.7954);
	angles[0] = (0, 142.5185, 0);
	at[0] = 0;
	points[1] = (-16745.2363, 4507.8740, 1524.1339);
	angles[1] = (0, 142.5186, 0);
	at[1] = 0.1500;
	points[2] = (-16902.9141, 4302.2441, 1833.6536);
	angles[2] = (0, 142.5189, 0);
	at[2] = 0.9000;
	points[3] = (-16964.0156, 4222.5591, 1954.8229);
	angles[3] = (0, 142.5189, 0);
	at[3] = 1.2000;
	points[4] = (-17369.4492, 3693.8582, 2753.8464);
	angles[4] = (0, 142.5186, 0);
	at[4] = 3.1500;
	points[5] = (-17433.1094, 3610.8267, 2876.2480);
	angles[5] = (0, 142.5184, 0);
	at[5] = 3.4500;
	points[6] = (-17463.7402, 3570.8821, 2934.5117);
	angles[6] = (0, 142.5182, 0);
	at[6] = 3.6000;
	points[7] = (-17529.4492, 3485.1892, 3057.6614);
	angles[7] = (0, 142.5179, 0);
	at[7] = 3.9000;
	points[8] = (-17560.1582, 3445.1536, 3114.0591);
	angles[8] = (0, 142.5178, 0);
	at[8] = 4.0500;
	points[9] = (-17595.0801, 3399.5867, 3177.0354);
	angles[9] = (0, 142.5174, 0);
	at[9] = 4.2000;
	points[10] = (-17662.2051, 3312.0591, 3292.3152);
	angles[10] = (0, 142.5163, 0);
	at[10] = 4.5000;
	points[11] = (-17696.6543, 3267.1338, 3346.1104);
	angles[11] = (0, 142.5150, 0);
	at[11] = 4.6500;
	points[12] = (-17731.5742, 3221.4763, 3392.7717);
	angles[12] = (0, 142.7090, 0);
	at[12] = 4.8000;
	points[13] = (-17771.8105, 3168.4961, 3437.9448);
	angles[13] = (0, 142.8805, 0);
	at[13] = 4.9500;
	points[14] = (-17813.3066, 3113.5239, 3478.3149);
	angles[14] = (0, 142.9747, 0);
	at[14] = 5.1000;
	points[15] = (-17855.8262, 3057.1221, 3514.9685);
	angles[15] = (0, 143.0208, 0);
	at[15] = 5.2500;
	points[16] = (-17943.5820, 2940.5159, 3580.2598);
	angles[16] = (0, 143.0165, 0);
	at[16] = 5.5500;
	points[17] = (-18079.3711, 2760.7676, 3662.9136);
	angles[17] = (0, 142.8138, 0);
	at[17] = 6;
	points[18] = (-18171.8906, 2639.3977, 3710.4604);
	angles[18] = (0, 142.5120, 0);
	at[18] = 6.3000;
	points[19] = (-18314.0957, 2456.9136, 3773.2166);
	angles[19] = (0, 141.4222, 0);
	at[19] = 6.7500;
	points[20] = (-18363.3086, 2396.1143, 3792.3857);
	angles[20] = (0, 140.4990, 0);
	at[20] = 6.9000;
	points[21] = (-18409.7246, 2341.4211, 3808.3384);
	angles[21] = (0, 138.8158, 0);
	at[21] = 7.0500;
	points[22] = (-18462.9141, 2281.7559, 3822.0276);
	angles[22] = (0, 137.8946, 0);
	at[22] = 7.2000;
	points[23] = (-18625, 2105.6143, 3853.2048);
	angles[23] = (0, 137.0838, 0);
	at[23] = 7.6500;
	points[24] = (-18841.5742, 1873.2836, 3885.7126);
	angles[24] = (0, 137.0429, 0);
	at[24] = 8.2500;
	points[25] = (-19057.0859, 1639.9174, 3913.6458);
	angles[25] = (0, 137.6483, 0);
	at[25] = 8.8500;
	points[26] = (-19164.1348, 1521.0513, 3926.6458);
	angles[26] = (0, 138.4427, 0);
	at[26] = 9.1500;
	points[27] = (-19269.6074, 1398.4922, 3939.2913);
	angles[27] = (0, 140.5471, 0);
	at[27] = 9.4500;
	points[28] = (-19314.6855, 1341.5748, 3944.8425);
	angles[28] = (0, 142.4910, 0);
	at[28] = 9.6000;
	points[29] = (-19364.1738, 1276.2283, 3950.4727);
	angles[29] = (0, 143.1434, 0);
	at[29] = 9.7500;
	points[30] = (-19410.5527, 1213.9094, 3955.3545);
	angles[30] = (0, 143.5483, 0);
	at[30] = 9.9000;
	points[31] = (-19551.6133, 1019.5158, 3969.1340);
	angles[31] = (0, 144.4832, 0);
	at[31] = 10.3500;
	points[32] = (-19689.3691, 823.2834, 3981.6538);
	angles[32] = (0, 145.4067, 0);
	at[32] = 10.8000;
	points[33] = (-19823.5840, 624.4528, 3993.2285);
	angles[33] = (0, 146.6349, 0);
	at[33] = 11.2500;
	points[34] = (-19910.1191, 490.0906, 4000.3152);
	angles[34] = (0, 147.8782, 0);
	at[34] = 11.5500;
	points[35] = (-19993.2285, 352.7059, 4006.7717);
	angles[35] = (0, 150.0190, 0);
	at[35] = 11.8500;
	points[36] = (-20031.1406, 284.6748, 4009.5278);
	angles[36] = (0, 151.8681, 0);
	at[36] = 12;
	points[37] = (-20067.7949, 211.2358, 4011.9292);
	angles[37] = (0, 155.5205, 0);
	at[37] = 12.1500;
	points[38] = (-20094.8418, 144.3098, 4013.1104);
	angles[38] = (0, 159.9089, 0);
	at[38] = 12.3000;
	points[39] = (-20145.0781, -9.4130, 4013.3074);
	angles[39] = (0, 163.2850, 0);
	at[39] = 12.6000;
	points[40] = (-20209.2910, -240.7106, 4011.3779);
	angles[40] = (0, 165.4884, 0);
	at[40] = 13.0500;
	points[41] = (-20266.1426, -474.0039, 4008.4646);
	angles[41] = (0, 167.0971, 0);
	at[41] = 13.5000;
	points[42] = (-20300.4727, -630.6614, 4006.2207);
	angles[42] = (0, 168.2068, 0);
	at[42] = 13.8000;
	points[43] = (-20345.1973, -865.3937, 4002.7952);
	angles[43] = (0, 170.3778, 0);
	at[43] = 14.2500;
	points[44] = (-20358.1484, -946.2205, 4001.6536);
	angles[44] = (0, 171.4581, 0);
	at[44] = 14.4000;
	points[45] = (-20368.7793, -1022.9882, 4000.6299);
	angles[45] = (0, 172.8227, 0);
	at[45] = 14.5500;
	points[46] = (-20377.7168, -1105.4055, 3999.6458);
	angles[46] = (0, 174.9880, 0);
	at[46] = 14.7000;
	points[47] = (-20382.4023, -1184.9725, 3998.8977);
	angles[47] = (0, 178.7043, 0);
	at[47] = 14.8500;
	points[48] = (-20379.4102, -1259.7126, 3998.5828);
	angles[48] = (0, 187.3549, 0);
	at[48] = 15;
	points[49] = (-20362.6758, -1339, 3998.9763);
	angles[49] = (0, 195.2921, 0);
	at[49] = 15.1500;
	points[50] = (-20339.6465, -1412.9803, 3999.6458);
	angles[50] = (0, 198.9850, 0);
	at[50] = 15.3000;
	points[51] = (-20281.1035, -1563.1339, 4001.4175);
	angles[51] = (0, 203.1522, 0);
	at[51] = 15.6000;
	points[52] = (-20214.8027, -1708.8031, 4003.4648);
	angles[52] = (0, 205.6416, 0);
	at[52] = 15.9000;
	points[53] = (-20105.6309, -1922.2166, 4006.6929);
	angles[53] = (0, 208.4646, 0);
	at[53] = 16.3500;
	points[54] = (-19986.0234, -2130.2561, 4009.8032);
	angles[54] = (0, 211.4821, 0);
	at[54] = 16.8000;
	points[55] = (-19898.2676, -2265.4016, 4011.6538);
	angles[55] = (0, 214.9161, 0);
	at[55] = 17.1000;
	points[56] = (-19850.7480, -2329.6692, 4012.2837);
	angles[56] = (0, 218.5270, 0);
	at[56] = 17.2500;
	points[57] = (-19800.6309, -2384.5708, 4012.4409);
	angles[57] = (0, 227.8511, 0);
	at[57] = 17.4000;
	points[58] = (-19737.3223, -2433.5828, 4012.0078);
	angles[58] = (0, 235.5897, 0);
	at[58] = 17.5500;
	points[59] = (-19669.0957, -2476.6418, 4011.2993);
	angles[59] = (0, 239.5268, 0);
	at[59] = 17.7000;
	points[60] = (-19599.2520, -2515.6299, 4010.3938);
	angles[60] = (0, 241.9836, 0);
	at[60] = 17.8500;
	points[61] = (-19456.2598, -2586.4373, 4008.3860);
	angles[61] = (0, 245.0579, 0);
	at[61] = 18.1500;
	points[62] = (-19236.1426, -2681.8425, 4004.9211);
	angles[62] = (0, 247.8709, 0);
	at[62] = 18.6000;
	points[63] = (-19011.9688, -2767.9805, 4001.1416);
	angles[63] = (0, 250.0909, 0);
	at[63] = 19.0500;
	points[64] = (-18862.7168, -2819.3899, 3998.5828);
	angles[64] = (0, 252.1690, 0);
	at[64] = 19.3500;
	points[65] = (-18712.0488, -2858.8386, 3995.3545);
	angles[65] = (0, 256.9492, 0);
	at[65] = 19.6500;
	points[66] = (-18631.3789, -2876.9529, 3993.4253);
	angles[66] = (0, 257.6742, 0);
	at[66] = 19.8000;
	points[67] = (-18555.1973, -2893.2915, 3991.5750);
	angles[67] = (0, 258.0859, 0);
	at[67] = 19.9500;
	points[68] = (-17926.8887, -3020.8032, 3976.9685);
	angles[68] = (0, 258.3413, 0);
	at[68] = 21.1500;
	points[69] = (-17691.2988, -3071.2678, 3972.5984);
	angles[69] = (0, 257.2996, 0);
	at[69] = 21.6000;
	points[70] = (-17614.7637, -3088.9646, 3971.4961);
	angles[70] = (0, 256.6078, 0);
	at[70] = 21.7500;
	points[71] = (-17457.4414, -3130.3977, 3970.4331);
	angles[71] = (0, 253.0693, 0);
	at[71] = 22.0500;
	points[72] = (-17388.6211, -3154.6023, 3971.2993);
	angles[72] = (0, 247.4939, 0);
	at[72] = 22.2000;
	points[73] = (-17315.5918, -3188.6851, 3974.2913);
	angles[73] = (0, 243.0033, 0);
	at[73] = 22.3500;
	points[74] = (-17176.8105, -3266.3110, 3983.0708);
	angles[74] = (0, 239.1624, 0);
	at[74] = 22.6500;
	points[75] = (-17040.6699, -3350.5825, 3993.7402);
	angles[75] = (0, 237.5423, 0);
	at[75] = 22.9500;
	points[76] = (-16638.2676, -3609.9490, 4027.8740);
	angles[76] = (0, 238.1854, 0);
	at[76] = 23.8500;
	points[77] = (-16500.2754, -3690.5906, 4037.6772);
	angles[77] = (0, 242.0389, 0);
	at[77] = 24.1500;
	points[78] = (-16432.6777, -3723.0710, 4040.8269);
	angles[78] = (0, 246.7550, 0);
	at[78] = 24.3000;
	points[79] = (-16283.1504, -3781.6536, 4044.6851);
	angles[79] = (0, 249.7300, 0);
	at[79] = 24.6000;
	points[80] = (-15981.1416, -3887.2205, 4049.4490);
	angles[80] = (0, 251.4686, 0);
	at[80] = 25.2000;
	points[81] = (-15676.6543, -3986.0632, 4052.5984);
	angles[81] = (0, 252.5551, 0);
	at[81] = 25.8000;
	points[82] = (-15370.1582, -4078.1497, 4054.2913);
	angles[82] = (0, 254.2883, 0);
	at[82] = 26.4000;
	points[83] = (-15291.9297, -4099.4487, 4054.2520);
	angles[83] = (0, 255.4139, 0);
	at[83] = 26.5500;
	points[84] = (-15221.2598, -4116.5352, 4054.0552);
	angles[84] = (0, 257.4638, 0);
	at[84] = 26.7000;
	points[85] = (-15141.7725, -4133.1890, 4054.3308);
	angles[85] = (0, 258.7295, 0);
	at[85] = 26.8500;
	points[86] = (-14826.9688, -4190.0396, 4056.3386);
	angles[86] = (0, 260.4352, 0);
	at[86] = 27.4500;
	points[87] = (-14510.6309, -4241.0234, 4055.5120);
	angles[87] = (0, 261.2094, 0);
	at[87] = 28.0500;
	points[88] = (-14272.9521, -4276.6533, 4050.2756);
	angles[88] = (0, 261.7689, 0);
	at[88] = 28.5000;
	points[89] = (-14114.0557, -4298.8979, 4042.0078);
	angles[89] = (0, 262.3382, 0);
	at[89] = 28.8000;
	points[90] = (-14035.2363, -4309.1733, 4034.8818);
	angles[90] = (0, 262.8551, 0);
	at[90] = 28.9500;
	points[91] = (-13961.7324, -4317.7954, 4023.8584);
	angles[91] = (0, 264.0710, 0);
	at[91] = 29.1000;
	points[92] = (-13883.1895, -4324.8032, 4004.6458);
	angles[92] = (0, 265.4832, 0);
	at[92] = 29.2500;
	points[93] = (-13808.2285, -4330.2754, 3982.5198);
	angles[93] = (0, 266.1462, 0);
	at[93] = 29.4000;
	points[94] = (-13655.3936, -4339.4883, 3931.7205);
	angles[94] = (0, 266.8415, 0);
	at[94] = 29.7000;
	points[95] = (-13431.0625, -4350.8662, 3850.3977);
	angles[95] = (0, 267.2794, 0);
	at[95] = 30.1500;
	points[96] = (-12983.6621, -4371.6143, 3680.8386);
	angles[96] = (0, 267.1930, 0);
	at[96] = 31.0500;
	points[97] = (-12830.9854, -4379.8428, 3625.3938);
	angles[97] = (0, 266.4565, 0);
	at[97] = 31.3500;
	points[98] = (-12761.2207, -4384.6851, 3602.6575);
	angles[98] = (0, 265.6590, 0);
	at[98] = 31.5000;
	points[99] = (-12531.6924, -4403.7007, 3534.0750);
	angles[99] = (0, 265.0474, 0);
	at[99] = 31.9500;
	points[100] = (-11612.4014, -4486.3779, 3271.9724);
	angles[100] = (0, 264.9422, 0);
	at[100] = 33.7500;
	points[101] = (-11612.4014, -4486.3779, 3271.9724);
	angles[101] = (0, 264.9422, 0);
	at[101] = 33.7667;
	points[102] = (-16715.9453, 4546.1025, 1467.7954);
	angles[102] = (0, 142.5185, 0);
	at[102] = 33.7667;
	points[103] = (-16715.9453, 4546.1025, 1467.7954);
	angles[103] = (0, 142.5185, 0);
	at[103] = 33.7833;
	mover = getEnt("iz_obj_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-11889.8818, 13004.3701, 3679.2717);
	angles[0] = (0, 84.9662, 0);
	at[0] = 0;
	points[1] = (-11931.8506, 12527.8740, 3680.2837);
	angles[1] = (0, 84.9662, 0);
	at[1] = 1.8000;
	points[2] = (-11931.2598, 12534.5664, 3680.2715);
	angles[2] = (0, 84.9662, 0);
	at[2] = 1.8500;
	points[3] = (-11889.2920, 13011.0625, 3679.2561);
	angles[3] = (0, 84.9662, 0);
	at[3] = 3.6500;
	points[4] = (-11889.8818, 13004.3701, 3679.2717);
	angles[4] = (0, 84.9662, 0);
	at[4] = 3.6667;
	mover = getEnt("iz_obj_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-12613.0312, 12612.2451, 3679.2600);
	angles[0] = (0, 84.9661, 0);
	at[0] = 0;
	points[1] = (-12571.0625, 13088.7402, 3679.2600);
	angles[1] = (0, 84.9661, 0);
	at[1] = 1.8000;
	points[2] = (-12571.6543, 13082.0469, 3679.2600);
	angles[2] = (0, 84.9661, 0);
	at[2] = 1.8500;
	points[3] = (-12613.6221, 12605.5518, 3679.2600);
	angles[3] = (0, 84.9661, 0);
	at[3] = 3.6500;
	points[4] = (-12613.0312, 12612.2451, 3679.2600);
	angles[4] = (0, 84.9661, 0);
	at[4] = 3.6667;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover_loop(points, angles, at, once, closed)
{
	wait 0.05;
	self iz_place(points[0], iz_pose(angles, 0));
	period = at[at.size - 1];
	if (period < 0.05)
		return;
	done = 0;
	for (pass = 0; !once || pass < 1; pass++)
	{
		if (pass && !closed)
			self iz_place(points[0], iz_pose(angles, 0));
		for (i = 1; i < points.size; i++)
		{
			if (at[i] == at[i - 1])
			{
				self iz_place(points[i], iz_pose(angles, i));
				continue;
			}
			due = int((pass * period + at[i]) * 20 + 0.5);
			if (due <= done)
				continue;
			self iz_move(points[i], iz_pose(angles, i), due - done);
			wait 0.05 * (due - done);
			done = due;
		}
	}
	last = points.size - 1;
	self iz_stop(points[last], iz_pose(angles, last));
}

iz_pose(angles, i)
{
	if (isDefined(angles))
		return angles[i];
}
