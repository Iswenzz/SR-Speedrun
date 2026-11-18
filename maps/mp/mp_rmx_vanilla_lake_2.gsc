main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_vanilla_lake_2", 0);

	setExpFog(1594.4882, 16807.3320, 0.7843, 0.7843, 0.7843, 0);

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
	ambientPlay("iz_0_rvl2", 2);
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
	level.iz_route[level.iz_route.size] = (6, -1037, 524);
	level.iz_route[level.iz_route.size] = (17, -2398, 524);
	level.iz_route[level.iz_route.size] = (42, -3935, 524);
	level.iz_route[level.iz_route.size] = (22, -5796, 524);
	level.iz_route[level.iz_route.size] = (-10, -7550, 524);
	level.iz_route[level.iz_route.size] = (-9, -9503, 524);
	level.iz_route[level.iz_route.size] = (-270, -10379, 524);
	level.iz_route[level.iz_route.size] = (-866, -10919, 524);
	level.iz_route[level.iz_route.size] = (-1739, -11060, 524);
	level.iz_route[level.iz_route.size] = (-2501, -10960, 524);
	level.iz_route[level.iz_route.size] = (-3089, -10569, 524);
	level.iz_route[level.iz_route.size] = (-3589, -9664, 524);
	level.iz_route[level.iz_route.size] = (-3858, -8629, 524);
	level.iz_route[level.iz_route.size] = (-4181, -7842, 524);
	level.iz_route[level.iz_route.size] = (-4536, -7535, 524);
	level.iz_route[level.iz_route.size] = (-5107, -7560, 524);
	level.iz_route[level.iz_route.size] = (-6119, -7970, 524);
	level.iz_route[level.iz_route.size] = (-7074, -8400, 524);
	level.iz_route[level.iz_route.size] = (-7852, -8582, 524);
	level.iz_route[level.iz_route.size] = (-8624, -8547, 524);
	level.iz_route[level.iz_route.size] = (-9179, -8320, 524);
	level.iz_route[level.iz_route.size] = (-9684, -7884, 524);
	level.iz_route[level.iz_route.size] = (-9926, -7169, 524);
	level.iz_route[level.iz_route.size] = (-9927, -6261, 524);
	level.iz_route[level.iz_route.size] = (-9632, -5746, 524);
	level.iz_route[level.iz_route.size] = (-8913, -5464, 524);
	level.iz_route[level.iz_route.size] = (-7972, -5254, 524);
	level.iz_route[level.iz_route.size] = (-6873, -5127, 529);
	level.iz_route[level.iz_route.size] = (-6118, -5099, 551);
	level.iz_route[level.iz_route.size] = (-5193, -5069, 630);
	level.iz_route[level.iz_route.size] = (-4296, -5080, 787);
	level.iz_route[level.iz_route.size] = (-3862, -5082, 888);
	level.iz_route[level.iz_route.size] = (-302, -5069, 1853);
	level.iz_route[level.iz_route.size] = (3414, -5098, 524);
	level.iz_route[level.iz_route.size] = (5407, -5076, 524);
	level.iz_route[level.iz_route.size] = (6882, -4741, 524);
	level.iz_route[level.iz_route.size] = (7463, -4345, 524);
	level.iz_route[level.iz_route.size] = (7638, -3664, 524);
	level.iz_route[level.iz_route.size] = (7523, -2993, 524);
	level.iz_route[level.iz_route.size] = (7027, -2207, 524);
	level.iz_route[level.iz_route.size] = (6706, -1842, 524);
	level.iz_route[level.iz_route.size] = (6522, -1591, 524);
	level.iz_route[level.iz_route.size] = (6533, -1324, 524);
	level.iz_route[level.iz_route.size] = (6706, -846, 524);
	level.iz_route[level.iz_route.size] = (6628, -22, 524);
	level.iz_route[level.iz_route.size] = (6327, 836, 524);
	level.iz_route[level.iz_route.size] = (5790, 1652, 524);
	level.iz_route[level.iz_route.size] = (5111, 2350, 524);
	level.iz_route[level.iz_route.size] = (4414, 2964, 524);
	level.iz_route[level.iz_route.size] = (3861, 3400, 524);
	level.iz_route[level.iz_route.size] = (3245, 3726, 524);
	level.iz_route[level.iz_route.size] = (2300, 3995, 524);
	level.iz_route[level.iz_route.size] = (1467, 3995, 524);
	level.iz_route[level.iz_route.size] = (763, 3805, 524);
	level.iz_route[level.iz_route.size] = (345, 3314, 524);
	level.iz_route[level.iz_route.size] = (203, 2708, 524);
	level.iz_route[level.iz_route.size] = (104, 2058, 524);
	level.iz_route[level.iz_route.size] = (63, 1585, 524);
	level.iz_route[level.iz_route.size] = (52, 880, 524);
	level.iz_route[level.iz_route.size] = (33, 237, 524);
	level.iz_route[level.iz_route.size] = (14, -91, 524);
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
	thread iz_obj_4();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (386.1256, -5935.8271, 523.9213);
	angles[0] = (0, -83.6919, 0);
	at[0] = 0;
	points[1] = (425.5157, -5931.3779, 523.9213);
	angles[1] = (0, -83.4070, 0);
	at[1] = 1.0500;
	points[2] = (459.6418, -5927.2832, 523.9213);
	angles[2] = (0, -82.9709, 0);
	at[2] = 2.1000;
	points[3] = (487.9724, -5923.6226, 523.9213);
	angles[3] = (0, -82.1778, 0);
	at[3] = 2.8000;
	points[4] = (521.2559, -5917.9136, 523.9213);
	angles[4] = (0, -78.0086, 0);
	at[4] = 3.8500;
	points[5] = (567.6732, -5901.6533, 523.9213);
	angles[5] = (0, -62.6044, 0);
	at[5] = 5.2500;
	points[6] = (595.6535, -5878.0708, 523.9213);
	angles[6] = (0, -38.0176, 0);
	at[6] = 6.3000;
	points[7] = (606.9725, -5856.0234, 523.9213);
	angles[7] = (0, -21.3955, 0);
	at[7] = 7;
	points[8] = (611.3110, -5844.4883, 523.9213);
	angles[8] = (0, -21.6138, 0);
	at[8] = 7.3500;
	points[9] = (617.2283, -5834.0161, 523.9213);
	angles[9] = (0, -31.9034, 0);
	at[9] = 7.7000;
	points[10] = (622.7717, -5822.7559, 523.9213);
	angles[10] = (0, -24.1483, 0);
	at[10] = 8.0500;
	points[11] = (631.1536, -5799.3306, 523.9213);
	angles[11] = (0, -17.4894, 0);
	at[11] = 8.7500;
	points[12] = (642.3543, -5750.7876, 523.9213);
	angles[12] = (0, -8.8208, 0);
	at[12] = 10.1500;
	points[13] = (643.6693, -5738.4648, 523.9213);
	angles[13] = (0, -4.4869, 0);
	at[13] = 10.5000;
	points[14] = (643.2520, -5726.4565, 523.9213);
	angles[14] = (0, 6.1243, 0);
	at[14] = 10.8500;
	points[15] = (635.4252, -5689.9214, 523.9213);
	angles[15] = (0, 16.6117, 0);
	at[15] = 11.9000;
	points[16] = (626.2520, -5666.9292, 523.9213);
	angles[16] = (0, 25.5456, 0);
	at[16] = 12.6000;
	points[17] = (604.8071, -5636.7324, 523.9213);
	angles[17] = (0, 43.9752, 0);
	at[17] = 13.6500;
	points[18] = (585.6536, -5622.0864, 523.9213);
	angles[18] = (0, 58.5691, 0);
	at[18] = 14.3500;
	points[19] = (563.8780, -5610.1577, 523.9213);
	angles[19] = (0, 62.1537, 0);
	at[19] = 15.0500;
	points[20] = (474.8465, -5566.2207, 523.9213);
	angles[20] = (0, 64.6703, 0);
	at[20] = 17.8500;
	points[21] = (349.6418, -5510.1182, 523.9213);
	angles[21] = (0, 67.1310, 0);
	at[21] = 21.7000;
	points[22] = (244.6067, -5470, 523.9213);
	angles[22] = (0, 71.8183, 0);
	at[22] = 24.8500;
	points[23] = (197.4185, -5457.6377, 523.9213);
	angles[23] = (0, 80.2419, 0);
	at[23] = 26.2500;
	points[24] = (149.2437, -5454.1343, 523.9213);
	angles[24] = (0, 88.4436, 0);
	at[24] = 27.6500;
	points[25] = (-0.3852, -5458.8584, 523.9213);
	angles[25] = (0, 93.9449, 0);
	at[25] = 31.8500;
	points[26] = (-124.3961, -5470.9453, 523.9213);
	angles[26] = (0, 97.2527, 0);
	at[26] = 35.3500;
	points[27] = (-222.1067, -5487.8350, 523.9213);
	angles[27] = (0, 103.5115, 0);
	at[27] = 38.1500;
	points[28] = (-246.6291, -5495, 523.9213);
	angles[28] = (0, 108.8842, 0);
	at[28] = 38.8500;
	points[29] = (-267.0217, -5504.7246, 523.9213);
	angles[29] = (0, 119.9651, 0);
	at[29] = 39.5500;
	points[30] = (-287.6673, -5518.8188, 523.9213);
	angles[30] = (0, 126.6440, 0);
	at[30] = 40.2500;
	points[31] = (-316.5449, -5542.6772, 523.9213);
	angles[31] = (0, 131.3115, 0);
	at[31] = 41.3000;
	points[32] = (-387.7591, -5612.4805, 523.9213);
	angles[32] = (0, 136.4399, 0);
	at[32] = 44.1000;
	points[33] = (-471.0945, -5705.3545, 523.9213);
	angles[33] = (0, 139.4208, 0);
	at[33] = 47.6000;
	points[34] = (-518.3228, -5762.3232, 523.9213);
	angles[34] = (0, 141.5466, 0);
	at[34] = 49.7000;
	points[35] = (-538.1221, -5793.3857, 523.9213);
	angles[35] = (0, 151.6761, 0);
	at[35] = 50.7500;
	points[36] = (-562.0866, -5850.6689, 523.9213);
	angles[36] = (0, 161.4297, 0);
	at[36] = 52.5000;
	points[37] = (-574.0276, -5898.8579, 523.9213);
	angles[37] = (0, 171.9203, 0);
	at[37] = 53.9000;
	points[38] = (-570.8740, -5922.9136, 523.9213);
	angles[38] = (0, 197.5137, 0);
	at[38] = 54.6000;
	points[39] = (-566.2992, -5934.4878, 523.9213);
	angles[39] = (0, 202.9411, 0);
	at[39] = 54.9500;
	points[40] = (-542.0315, -5977.7954, 523.9213);
	angles[40] = (0, 213.7338, 0);
	at[40] = 56.3500;
	points[41] = (-517.4882, -6005.5117, 523.9213);
	angles[41] = (0, 225.1234, 0);
	at[41] = 57.4000;
	points[42] = (-508.4134, -6013.3862, 523.9213);
	angles[42] = (0, 239.6826, 0);
	at[42] = 57.7500;
	points[43] = (-496.3071, -6016.1025, 523.9213);
	angles[43] = (0, 261.8003, 0);
	at[43] = 58.1000;
	points[44] = (-471.5118, -6016.7324, 523.9213);
	angles[44] = (0, 270.8529, 0);
	at[44] = 58.8000;
	points[45] = (-422.3740, -6013.9766, 523.9213);
	angles[45] = (0, 274.3571, 0);
	at[45] = 60.2000;
	points[46] = (-413.1063, -6013.2280, 523.9213);
	angles[46] = (0, 274.6523, 0);
	at[46] = 60.5500;
	points[47] = (-401.7717, -6012.2837, 523.9213);
	angles[47] = (0, 274.8163, 0);
	at[47] = 60.9000;
	points[48] = (-373.0063, -6009.8032, 523.9213);
	angles[48] = (0, 275.0070, 0);
	at[48] = 61.6000;
	points[49] = (-339.0756, -6006.7720, 523.9213);
	angles[49] = (0, 275.1172, 0);
	at[49] = 62.6500;
	points[50] = (-299.2370, -6003.1890, 523.9213);
	angles[50] = (0, 275.1948, 0);
	at[50] = 63.7000;
	points[51] = (-251.6921, -5998.8188, 523.9213);
	angles[51] = (0, 275.2620, 0);
	at[51] = 65.1000;
	points[52] = (386.1256, -5935.8271, 523.9213);
	angles[52] = (0, 276.3081, 0);
	at[52] = 83.1000;
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
	points[0] = (-2549.3428, -10922.6777, 523.9213);
	angles[0] = (0, 105.9194, 0);
	at[0] = 0;
	points[1] = (-2618.3110, -10940.2363, 523.9213);
	angles[1] = (0, 101.8145, 0);
	at[1] = 2;
	points[2] = (-2633.3938, -10942.9141, 523.9213);
	angles[2] = (0, 98.9506, 0);
	at[2] = 2.5000;
	points[3] = (-2704.5000, -10948.0312, 523.9213);
	angles[3] = (0, 91.3812, 0);
	at[3] = 4.5000;
	points[4] = (-2828.5435, -10945.5117, 523.9213);
	angles[4] = (0, 87.1575, 0);
	at[4] = 8;
	points[5] = (-2988.1536, -10933.7402, 523.9213);
	angles[5] = (0, 84.6881, 0);
	at[5] = 12.5000;
	points[6] = (-3127.1260, -10918.3076, 523.9213);
	angles[6] = (0, 82.2278, 0);
	at[6] = 16.5000;
	points[7] = (-3373.3701, -10878.8584, 523.9213);
	angles[7] = (0, 79.9957, 0);
	at[7] = 23.5000;
	points[8] = (-3582.8506, -10837.2051, 523.9213);
	angles[8] = (0, 76.6784, 0);
	at[8] = 29.5000;
	points[9] = (-3616.4529, -10828.6221, 523.9213);
	angles[9] = (0, 74.5785, 0);
	at[9] = 30.5000;
	points[10] = (-3635.1497, -10822.9531, 523.9213);
	angles[10] = (0, 72.0195, 0);
	at[10] = 31;
	points[11] = (-3649.6770, -10817.3613, 523.9213);
	angles[11] = (0, 66.5123, 0);
	at[11] = 31.5000;
	points[12] = (-3693.2520, -10787.2441, 523.9213);
	angles[12] = (0, 48.2640, 0);
	at[12] = 33;
	points[13] = (-3729.4409, -10748.1895, 523.9213);
	angles[13] = (0, 38.9166, 0);
	at[13] = 34.5000;
	points[14] = (-3768.9685, -10689.1338, 523.9213);
	angles[14] = (0, 29.3073, 0);
	at[14] = 36.5000;
	points[15] = (-3790.3269, -10640.8271, 523.9213);
	angles[15] = (0, 17.3868, 0);
	at[15] = 38;
	points[16] = (-3793.7048, -10623.8193, 523.9213);
	angles[16] = (0, 6.0918, 0);
	at[16] = 38.5000;
	points[17] = (-3794.1497, -10605.9844, 523.9213);
	angles[17] = (0, -0.2771, 0);
	at[17] = 39;
	points[18] = (-3787.1694, -10535.5508, 523.9213);
	angles[18] = (0, -9.5859, 0);
	at[18] = 41;
	points[19] = (-3769.4292, -10466.6934, 523.9213);
	angles[19] = (0, -19.3261, 0);
	at[19] = 43;
	points[20] = (-3746.6497, -10418.5439, 523.9213);
	angles[20] = (0, -31.3258, 0);
	at[20] = 44.5000;
	points[21] = (-3724.7285, -10390.7480, 523.9213);
	angles[21] = (0, -44.3922, 0);
	at[21] = 45.5000;
	points[22] = (-3696, -10370.4727, 523.9213);
	angles[22] = (0, -63.5627, 0);
	at[22] = 46.5000;
	points[23] = (-3681.6812, -10365.1182, 523.9213);
	angles[23] = (0, -72.3626, 0);
	at[23] = 47;
	points[24] = (-3664.9055, -10360.6299, 523.9213);
	angles[24] = (0, -76.1944, 0);
	at[24] = 47.5000;
	points[25] = (-3645.3506, -10356.3779, 523.9213);
	angles[25] = (0, -78.3485, 0);
	at[25] = 48;
	points[26] = (-3612.4136, -10350.2363, 523.9213);
	angles[26] = (0, -80.1710, 0);
	at[26] = 49;
	points[27] = (-3505.1694, -10334.4883, 523.9213);
	angles[27] = (0, -82.5516, 0);
	at[27] = 52;
	points[28] = (-3275.8152, -10308.9365, 523.9213);
	angles[28] = (0, -84.4536, 0);
	at[28] = 58.5000;
	points[29] = (-2973.5513, -10284.9209, 523.9213);
	angles[29] = (0, -86.7523, 0);
	at[29] = 67;
	points[30] = (-2901.9802, -10281.8105, 523.9213);
	angles[30] = (0, -88.4273, 0);
	at[30] = 69;
	points[31] = (-2853.3542, -10282.0078, 523.9213);
	angles[31] = (0, -92.1836, 0);
	at[31] = 70.5000;
	points[32] = (-2729.0474, -10293.0312, 523.9213);
	angles[32] = (0, -96.7374, 0);
	at[32] = 74;
	points[33] = (-2570.3386, -10315.2363, 523.9213);
	angles[33] = (0, -98.9198, 0);
	at[33] = 78.5000;
	points[34] = (-2413.0747, -10342.4014, 523.9213);
	angles[34] = (0, -100.6835, 0);
	at[34] = 83;
	points[35] = (-2273.3779, -10372.8350, 523.9213);
	angles[35] = (0, -105.5326, 0);
	at[35] = 87;
	points[36] = (-2258.3269, -10377.5586, 523.9213);
	angles[36] = (0, -108.7536, 0);
	at[36] = 87.5000;
	points[37] = (-2209.2480, -10399.1338, 523.9213);
	angles[37] = (0, -116.8197, 0);
	at[37] = 89;
	points[38] = (-2132.8149, -10444.0547, 523.9213);
	angles[38] = (0, -123.0927, 0);
	at[38] = 91.5000;
	points[39] = (-2074.6694, -10485.0791, 523.9213);
	angles[39] = (0, -127.1109, 0);
	at[39] = 93.5000;
	points[40] = (-2033.7520, -10518.5830, 523.9213);
	angles[40] = (0, -131.6998, 0);
	at[40] = 95;
	points[41] = (-2020.6260, -10531.0635, 523.9213);
	angles[41] = (0, -134.8810, 0);
	at[41] = 95.5000;
	points[42] = (-2008.8584, -10544.4873, 523.9213);
	angles[42] = (0, -142.2848, 0);
	at[42] = 96;
	points[43] = (-2000.8661, -10559.4482, 523.9213);
	angles[43] = (0, -156.4423, 0);
	at[43] = 96.5000;
	points[44] = (-1991.8071, -10593.6221, 523.9213);
	angles[44] = (0, -170.1869, 0);
	at[44] = 97.5000;
	points[45] = (-1989.0670, -10628.9766, 523.9213);
	angles[45] = (0, -179.5736, 0);
	at[45] = 98.5000;
	points[46] = (-1992.2677, -10664.2910, 523.9213);
	angles[46] = (0, -189.7954, 0);
	at[46] = 99.5000;
	points[47] = (-2002.7875, -10698.1494, 523.9213);
	angles[47] = (0, -203.7671, 0);
	at[47] = 100.5000;
	points[48] = (-2011.5079, -10713.5430, 523.9213);
	angles[48] = (0, -213.1189, 0);
	at[48] = 101;
	points[49] = (-2036.4568, -10737.6777, 523.9213);
	angles[49] = (0, -236.6957, 0);
	at[49] = 102;
	points[50] = (-2050.2637, -10745.2354, 523.9213);
	angles[50] = (0, -242.8494, 0);
	at[50] = 102.5000;
	points[51] = (-2082.8623, -10760.1963, 523.9213);
	angles[51] = (0, -246.5531, 0);
	at[51] = 103.5000;
	points[52] = (-2249.8071, -10824.4873, 523.9213);
	angles[52] = (0, -250.2103, 0);
	at[52] = 108.5000;
	points[53] = (-2401.0315, -10876.6143, 523.9213);
	angles[53] = (0, -251.7178, 0);
	at[53] = 113;
	points[54] = (-2549.3428, -10922.6777, 523.9213);
	angles[54] = (0, -254.0806, 0);
	at[54] = 117.3500;
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
	points[0] = (-9318.2676, -6525.0786, 523.9213);
	angles[0] = (0, -28.9662, 0);
	at[0] = 0;
	points[1] = (-9276.9297, -6442.8345, 523.9213);
	angles[1] = (0, -23.5486, 0);
	at[1] = 1.3000;
	points[2] = (-9266.6533, -6414.4092, 523.9213);
	angles[2] = (0, -18.3741, 0);
	at[2] = 1.7333;
	points[3] = (-9249.8037, -6355.7480, 523.9213);
	angles[3] = (0, -14.9221, 0);
	at[3] = 2.6000;
	points[4] = (-9202.7168, -6144.8032, 523.9213);
	angles[4] = (0, -10.7025, 0);
	at[4] = 5.6333;
	points[5] = (-9192.5986, -6084.7637, 523.9213);
	angles[5] = (0, -8.3739, 0);
	at[5] = 6.5000;
	points[6] = (-9189.1729, -6039.0161, 523.9213);
	angles[6] = (0, -0.4769, 0);
	at[6] = 7.1500;
	points[7] = (-9192.8740, -5977.7954, 523.9213);
	angles[7] = (0, 5.3965, 0);
	at[7] = 8.0167;
	points[8] = (-9200.5908, -5916.6929, 523.9213);
	angles[8] = (0, 8.4480, 0);
	at[8] = 8.8833;
	points[9] = (-9214.9219, -5841.1812, 523.9213);
	angles[9] = (0, 13.0300, 0);
	at[9] = 9.9667;
	points[10] = (-9223.3857, -5811.1416, 523.9213);
	angles[10] = (0, 17.8271, 0);
	at[10] = 10.4000;
	points[11] = (-9245.6689, -5771.9292, 523.9213);
	angles[11] = (0, 35.5385, 0);
	at[11] = 11.0500;
	points[12] = (-9275.1973, -5736.5352, 523.9213);
	angles[12] = (0, 42.1503, 0);
	at[12] = 11.7000;
	points[13] = (-9307.9531, -5703.9761, 523.9213);
	angles[13] = (0, 47.0886, 0);
	at[13] = 12.3500;
	points[14] = (-9343.7012, -5674.7246, 523.9213);
	angles[14] = (0, 53.6184, 0);
	at[14] = 13;
	points[15] = (-9369.8428, -5658.8584, 523.9213);
	angles[15] = (0, 62.4182, 0);
	at[15] = 13.4333;
	points[16] = (-9397.4014, -5647.4805, 523.9213);
	angles[16] = (0, 68.8335, 0);
	at[16] = 13.8667;
	points[17] = (-9470.3545, -5622.4409, 523.9213);
	angles[17] = (0, 72.3430, 0);
	at[17] = 14.9500;
	points[18] = (-9544.5273, -5600.9058, 523.9213);
	angles[18] = (0, 75.0166, 0);
	at[18] = 16.0333;
	points[19] = (-9619.4883, -5583.7012, 523.9213);
	angles[19] = (0, 79.0185, 0);
	at[19] = 17.1167;
	points[20] = (-9680.6299, -5575.7876, 523.9213);
	angles[20] = (0, 86.4794, 0);
	at[20] = 17.9833;
	points[21] = (-9710.9844, -5577.0869, 523.9213);
	angles[21] = (0, 97.1894, 0);
	at[21] = 18.4167;
	points[22] = (-9740.3545, -5585.0786, 523.9213);
	angles[22] = (0, 107.6110, 0);
	at[22] = 18.8500;
	points[23] = (-9768.5830, -5595.4326, 523.9213);
	angles[23] = (0, 111.0576, 0);
	at[23] = 19.2833;
	points[24] = (-9853.1494, -5632.7563, 523.9213);
	angles[24] = (0, 115.4489, 0);
	at[24] = 20.5833;
	points[25] = (-9935.7090, -5674.8818, 523.9213);
	angles[25] = (0, 118.3430, 0);
	at[25] = 21.8833;
	points[26] = (-10041.5752, -5738.3862, 523.9213);
	angles[26] = (0, 123.8946, 0);
	at[26] = 23.6167;
	points[27] = (-10078.7002, -5765.8662, 523.9213);
	angles[27] = (0, 128.7725, 0);
	at[27] = 24.2667;
	points[28] = (-10101.2988, -5787.1260, 523.9213);
	angles[28] = (0, 136.6703, 0);
	at[28] = 24.7000;
	points[29] = (-10116.5752, -5810.9453, 523.9213);
	angles[29] = (0, 152.4168, 0);
	at[29] = 25.1333;
	points[30] = (-10128.0703, -5839.4097, 523.9213);
	angles[30] = (0, 160, 0);
	at[30] = 25.5667;
	points[31] = (-10145.4336, -5899.2124, 523.9213);
	angles[31] = (0, 165.8033, 0);
	at[31] = 26.4333;
	points[32] = (-10164.3311, -5989.5278, 523.9213);
	angles[32] = (0, 169.7433, 0);
	at[32] = 27.7333;
	points[33] = (-10181.9688, -6111.6143, 523.9213);
	angles[33] = (0, 173.5831, 0);
	at[33] = 29.4667;
	points[34] = (-10188.3857, -6203.5435, 523.9213);
	angles[34] = (0, 179.0186, 0);
	at[34] = 30.7667;
	points[35] = (-10186.8906, -6233.7402, 523.9213);
	angles[35] = (0, 186.5741, 0);
	at[35] = 31.2000;
	points[36] = (-10183.1104, -6248.1890, 523.9213);
	angles[36] = (0, 196.4355, 0);
	at[36] = 31.4167;
	points[37] = (-10177.1260, -6262.3623, 523.9213);
	angles[37] = (0, 204.2378, 0);
	at[37] = 31.6333;
	points[38] = (-10161.5752, -6288.8979, 523.9213);
	angles[38] = (0, 212.7647, 0);
	at[38] = 32.0667;
	points[39] = (-10113.9756, -6349.4878, 523.9213);
	angles[39] = (0, 220.9116, 0);
	at[39] = 33.1500;
	points[40] = (-10051.2598, -6417.6377, 523.9213);
	angles[40] = (0, 223.1899, 0);
	at[40] = 34.4500;
	points[41] = (-10010.1973, -6463.5830, 523.9213);
	angles[41] = (0, 219.3694, 0);
	at[41] = 35.3167;
	points[42] = (-9984.7246, -6500.1968, 523.9213);
	angles[42] = (0, 213.2935, 0);
	at[42] = 35.9667;
	points[43] = (-9917.8350, -6604.1733, 523.9213);
	angles[43] = (0, 213.2540, 0);
	at[43] = 37.7000;
	points[44] = (-9845.9053, -6704.0942, 523.9213);
	angles[44] = (0, 219.5901, 0);
	at[44] = 39.4333;
	points[45] = (-9825, -6726.6143, 523.9213);
	angles[45] = (0, 225.2352, 0);
	at[45] = 39.8667;
	points[46] = (-9812.7559, -6736.9688, 523.9213);
	angles[46] = (0, 231.4521, 0);
	at[46] = 40.0833;
	points[47] = (-9785.8662, -6748.8975, 523.9213);
	angles[47] = (0, 252.1307, 0);
	at[47] = 40.5167;
	points[48] = (-9771.5752, -6752.4019, 523.9213);
	angles[48] = (0, 256.7887, 0);
	at[48] = 40.7333;
	points[49] = (-9725.5117, -6759.5669, 523.9213);
	angles[49] = (0, 263.1841, 0);
	at[49] = 41.3833;
	points[50] = (-9664.0947, -6764.0557, 523.9213);
	angles[50] = (0, 267.4942, 0);
	at[50] = 42.2500;
	points[51] = (-9556.4180, -6762.1260, 523.9213);
	angles[51] = (0, 274.4327, 0);
	at[51] = 43.7667;
	points[52] = (-9510.1182, -6755.9448, 523.9213);
	angles[52] = (0, 280.3388, 0);
	at[52] = 44.4167;
	points[53] = (-9480.5518, -6747.4019, 523.9213);
	angles[53] = (0, 290.6353, 0);
	at[53] = 44.8500;
	points[54] = (-9469.2920, -6741.0239, 523.9213);
	angles[54] = (0, 302.0011, 0);
	at[54] = 45.0667;
	points[55] = (-9456.8896, -6730.4331, 523.9213);
	angles[55] = (0, 311.7238, 0);
	at[55] = 45.2833;
	points[56] = (-9436.2207, -6707.7168, 523.9213);
	angles[56] = (0, 319.6363, 0);
	at[56] = 45.7167;
	points[57] = (-9382.6377, -6633.0317, 523.9213);
	angles[57] = (0, 326.7976, 0);
	at[57] = 47.0167;
	points[58] = (-9318.2676, -6525.0786, 523.9213);
	angles[58] = (0, 331.0338, 0);
	at[58] = 48.7833;
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
	points[0] = (7319.2129, -3731.8899, 523.9213);
	angles[0] = (0, -4.9351, 0);
	at[0] = 0;
	points[1] = (7343.2285, -3499.3425, 523.9213);
	angles[1] = (0, -7.7188, 0);
	at[1] = 3.3000;
	points[2] = (7349.4487, -3460.3623, 523.9213);
	angles[2] = (0, -10.2641, 0);
	at[2] = 3.8500;
	points[3] = (7355.4331, -3435.7561, 523.9213);
	angles[3] = (0, -16.6002, 0);
	at[3] = 4.2167;
	points[4] = (7365.5518, -3412.1221, 523.9213);
	angles[4] = (0, -25.0982, 0);
	at[4] = 4.5833;
	points[5] = (7397.7163, -3355.3701, 523.9213);
	angles[5] = (0, -32.0854, 0);
	at[5] = 5.5000;
	points[6] = (7427.7168, -3312.6892, 523.9213);
	angles[6] = (0, -37.6920, 0);
	at[6] = 6.2333;
	points[7] = (7445, -3293.1499, 523.9213);
	angles[7] = (0, -44.0255, 0);
	at[7] = 6.6000;
	points[8] = (7455.0396, -3284.8071, 523.9213);
	angles[8] = (0, -52.0718, 0);
	at[8] = 6.7833;
	points[9] = (7466.3389, -3279.8584, 523.9213);
	angles[9] = (0, -68.2987, 0);
	at[9] = 6.9667;
	points[10] = (7478.9370, -3277.0750, 523.9213);
	angles[10] = (0, -78.0386, 0);
	at[10] = 7.1500;
	points[11] = (7505, -3274.1812, 523.9213);
	angles[11] = (0, -85.2685, 0);
	at[11] = 7.5167;
	points[12] = (7583.1895, -3273.2522, 523.9213);
	angles[12] = (0, -91.2684, 0);
	at[12] = 8.6167;
	points[13] = (7686.6533, -3278.0903, 523.9213);
	angles[13] = (0, -93.5003, 0);
	at[13] = 10.0833;
	points[14] = (7751.5747, -3283.9412, 523.9213);
	angles[14] = (0, -96.7705, 0);
	at[14] = 11;
	points[15] = (7802.9136, -3293.0867, 523.9213);
	angles[15] = (0, -103.4467, 0);
	at[15] = 11.7333;
	points[16] = (7827.3623, -3301.7283, 523.9213);
	angles[16] = (0, -113.7667, 0);
	at[16] = 12.1000;
	points[17] = (7848.3071, -3315.6614, 523.9213);
	angles[17] = (0, -126.1131, 0);
	at[17] = 12.4667;
	points[18] = (7927.0078, -3384.3662, 523.9213);
	angles[18] = (0, -133.4115, 0);
	at[18] = 13.9333;
	points[19] = (7999.6064, -3459.5708, 523.9213);
	angles[19] = (0, -139.1019, 0);
	at[19] = 15.4000;
	points[20] = (8021.7720, -3489.9883, 523.9213);
	angles[20] = (0, -149.2153, 0);
	at[20] = 15.9500;
	points[21] = (8032.9131, -3513.6299, 523.9213);
	angles[21] = (0, -156.4519, 0);
	at[21] = 16.3167;
	points[22] = (8070.5513, -3624.8938, 523.9213);
	angles[22] = (0, -163.7410, 0);
	at[22] = 17.9667;
	points[23] = (8090.2754, -3700.7637, 523.9213);
	angles[23] = (0, -167.0502, 0);
	at[23] = 19.0667;
	points[24] = (8097.2051, -3737.8936, 523.9213);
	angles[24] = (0, -171.8610, 0);
	at[24] = 19.6167;
	points[25] = (8103.1104, -3816.0708, 523.9213);
	angles[25] = (0, -177.2382, 0);
	at[25] = 20.7167;
	points[26] = (8104.8032, -3907.2205, 523.9213);
	angles[26] = (0, -180.4198, 0);
	at[26] = 22;
	points[27] = (8101.8110, -3972.4016, 523.9213);
	angles[27] = (0, -185.0055, 0);
	at[27] = 22.9167;
	points[28] = (8098.1104, -3998.4646, 523.9213);
	angles[28] = (0, -190.0624, 0);
	at[28] = 23.2833;
	points[29] = (8094.9209, -4010.4331, 523.9213);
	angles[29] = (0, -196.2240, 0);
	at[29] = 23.4667;
	points[30] = (8089.9609, -4021.7717, 523.9213);
	angles[30] = (0, -204.4793, 0);
	at[30] = 23.6500;
	points[31] = (8076.4565, -4044.4094, 523.9213);
	angles[31] = (0, -212.6557, 0);
	at[31] = 24.0167;
	points[32] = (8011.8896, -4126.1416, 523.9213);
	angles[32] = (0, -221.3241, 0);
	at[32] = 25.4833;
	points[33] = (7947.8745, -4191.2207, 523.9213);
	angles[33] = (0, -228.3843, 0);
	at[33] = 26.7667;
	points[34] = (7937.5200, -4199.6455, 523.9213);
	angles[34] = (0, -231.4151, 0);
	at[34] = 26.9500;
	points[35] = (7915.5908, -4211.3389, 523.9213);
	angles[35] = (0, -247.3025, 0);
	at[35] = 27.3167;
	points[36] = (7890.7085, -4218.6221, 523.9213);
	angles[36] = (0, -255.6699, 0);
	at[36] = 27.6833;
	points[37] = (7865.1182, -4223.8584, 523.9213);
	angles[37] = (0, -259.4499, 0);
	at[37] = 28.0500;
	points[38] = (7800.4331, -4232.5195, 523.9213);
	angles[38] = (0, -264, 0);
	at[38] = 28.9667;
	points[39] = (7723.3467, -4237.9526, 523.9213);
	angles[39] = (0, -268.0280, 0);
	at[39] = 30.0667;
	points[40] = (7644.9609, -4237.5591, 523.9213);
	angles[40] = (0, -271.4903, 0);
	at[40] = 31.1667;
	points[41] = (7566.8506, -4233.0708, 523.9213);
	angles[41] = (0, -275.1814, 0);
	at[41] = 32.2667;
	points[42] = (7528.2681, -4227.5591, 523.9213);
	angles[42] = (0, -280.9079, 0);
	at[42] = 32.8167;
	points[43] = (7516.0635, -4224.1733, 523.9213);
	angles[43] = (0, -287.0624, 0);
	at[43] = 33;
	points[44] = (7504.2910, -4218.8979, 523.9213);
	angles[44] = (0, -294.7436, 0);
	at[44] = 33.1833;
	points[45] = (7481.8896, -4205.9844, 523.9213);
	angles[45] = (0, -301.4436, 0);
	at[45] = 33.5500;
	points[46] = (7408.3462, -4151.9688, 523.9213);
	angles[46] = (0, -309.4809, 0);
	at[46] = 34.8333;
	points[47] = (7370, -4116.4175, 523.9213);
	angles[47] = (0, -316.0954, 0);
	at[47] = 35.5667;
	points[48] = (7361.4570, -4106.4565, 523.9213);
	angles[48] = (0, -320.1944, 0);
	at[48] = 35.7500;
	points[49] = (7349.7246, -4084.4097, 523.9213);
	angles[49] = (0, -337.0094, 0);
	at[49] = 36.1167;
	points[50] = (7341.6533, -4059.6851, 523.9213);
	angles[50] = (0, -343.3905, 0);
	at[50] = 36.4833;
	points[51] = (7326.7324, -3996.1023, 523.9213);
	angles[51] = (0, -348.4837, 0);
	at[51] = 37.4000;
	points[52] = (7310.9844, -3893.6812, 523.9213);
	angles[52] = (0, -354.9287, 0);
	at[52] = 38.8667;
	points[53] = (7310.8662, -3854.8386, 523.9213);
	angles[53] = (0, -361.5794, 0);
	at[53] = 39.4167;
	points[54] = (7319.2129, -3731.8899, 523.9213);
	angles[54] = (0, -364.9351, 0);
	at[54] = 41.1500;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (909.2363, 3495.4136, 523.9213);
	angles[0] = (0, 92.9054, 0);
	at[0] = 0;
	points[1] = (769.4843, 3492.2048, 523.9213);
	angles[1] = (0, 88.6660, 0);
	at[1] = 1.9500;
	points[2] = (742.0827, 3493.8938, 523.9213);
	angles[2] = (0, 85.2451, 0);
	at[2] = 2.3833;
	points[3] = (664.5984, 3503.9526, 523.9213);
	angles[3] = (0, 81.3543, 0);
	at[3] = 3.4667;
	points[4] = (543.4410, 3525.0669, 523.9213);
	angles[4] = (0, 79.2754, 0);
	at[4] = 5.2000;
	points[5] = (407.6024, 3553.0750, 523.9213);
	angles[5] = (0, 77.4996, 0);
	at[5] = 7.1500;
	points[6] = (287.4256, 3582.9055, 523.9213);
	angles[6] = (0, 74.0896, 0);
	at[6] = 8.8833;
	points[7] = (257.7862, 3592.3896, 523.9213);
	angles[7] = (0, 70.8351, 0);
	at[7] = 9.3167;
	points[8] = (245.3626, 3597.5356, 523.9213);
	angles[8] = (0, 66.1203, 0);
	at[8] = 9.5333;
	points[9] = (221.0508, 3615.9529, 523.9213);
	angles[9] = (0, 46.1341, 0);
	at[9] = 9.9667;
	points[10] = (202.6000, 3640.6260, 523.9213);
	angles[10] = (0, 32.7584, 0);
	at[10] = 10.4000;
	points[11] = (182.8571, 3682.2087, 523.9213);
	angles[11] = (0, 21.5429, 0);
	at[11] = 11.0500;
	points[12] = (165.4575, 3741.1221, 523.9213);
	angles[12] = (0, 13.3902, 0);
	at[12] = 11.9167;
	points[13] = (159.2850, 3770.9841, 523.9213);
	angles[13] = (0, 10.8973, 0);
	at[13] = 12.3500;
	points[14] = (157.2984, 3786.0786, 523.9213);
	angles[14] = (0, 6.6020, 0);
	at[14] = 12.5667;
	points[15] = (156.2181, 3832.3662, 523.9213);
	angles[15] = (0, -1.5477, 0);
	at[15] = 13.2167;
	points[16] = (161.4201, 3878.2324, 523.9213);
	angles[16] = (0, -10.3631, 0);
	at[16] = 13.8667;
	points[17] = (170.4776, 3907.6143, 523.9213);
	angles[17] = (0, -21.8323, 0);
	at[17] = 14.3000;
	points[18] = (178.2193, 3920.8660, 523.9213);
	angles[18] = (0, -32.9602, 0);
	at[18] = 14.5167;
	points[19] = (188.3882, 3930.7205, 523.9213);
	angles[19] = (0, -48.8171, 0);
	at[19] = 14.7333;
	points[20] = (201.2996, 3939.6851, 523.9213);
	angles[20] = (0, -55.9773, 0);
	at[20] = 14.9500;
	points[21] = (214.6433, 3947.8740, 523.9213);
	angles[21] = (0, -58.7669, 0);
	at[21] = 15.1667;
	points[22] = (282.5819, 3983.8191, 523.9213);
	angles[22] = (0, -63.8919, 0);
	at[22] = 16.2500;
	points[23] = (367.0216, 4021.4172, 523.9213);
	angles[23] = (0, -67.7677, 0);
	at[23] = 17.5500;
	points[24] = (439.4410, 4047.2837, 523.9213);
	angles[24] = (0, -72.9802, 0);
	at[24] = 18.6333;
	points[25] = (482.2244, 4057.2834, 523.9213);
	angles[25] = (0, -80.1929, 0);
	at[25] = 19.2833;
	points[26] = (651.4213, 4074.0947, 523.9213);
	angles[26] = (0, -85.6660, 0);
	at[26] = 21.6667;
	points[27] = (913.5906, 4089.6064, 523.9213);
	angles[27] = (0, -87.4703, 0);
	at[27] = 25.3500;
	points[28] = (1021.9606, 4092.9922, 523.9213);
	angles[28] = (0, -89.2348, 0);
	at[28] = 26.8667;
	points[29] = (1049.9843, 4092.8347, 523.9213);
	angles[29] = (0, -91.0197, 0);
	at[29] = 27.3000;
	points[30] = (1157.9607, 4086.9685, 523.9213);
	angles[30] = (0, -94.2616, 0);
	at[30] = 28.8167;
	points[31] = (1295.8188, 4073.3071, 523.9213);
	angles[31] = (0, -96.9943, 0);
	at[31] = 30.7667;
	points[32] = (1402.3937, 4056.2993, 523.9213);
	angles[32] = (0, -101.6933, 0);
	at[32] = 32.2833;
	points[33] = (1432.2087, 4048.8584, 523.9213);
	angles[33] = (0, -105.6061, 0);
	at[33] = 32.7167;
	points[34] = (1459.1968, 4037.7952, 523.9213);
	angles[34] = (0, -117.6221, 0);
	at[34] = 33.1500;
	points[35] = (1472.5945, 4029.0552, 523.9213);
	angles[35] = (0, -124.1213, 0);
	at[35] = 33.3667;
	points[36] = (1496.5237, 4009.8032, 523.9213);
	angles[36] = (0, -130.6060, 0);
	at[36] = 33.8000;
	points[37] = (1561.2598, 3944.1338, 523.9213);
	angles[37] = (0, -138.2240, 0);
	at[37] = 35.1000;
	points[38] = (1619.4922, 3872.2837, 523.9213);
	angles[38] = (0, -143.3742, 0);
	at[38] = 36.4000;
	points[39] = (1645.3544, 3833.9685, 523.9213);
	angles[39] = (0, -148.4404, 0);
	at[39] = 37.0500;
	points[40] = (1652.8503, 3820.0237, 523.9213);
	angles[40] = (0, -153.0031, 0);
	at[40] = 37.2667;
	points[41] = (1658.4370, 3791.4448, 523.9213);
	angles[41] = (0, -176.7781, 0);
	at[41] = 37.7000;
	points[42] = (1657.7913, 3775.9409, 523.9213);
	angles[42] = (0, -183.3629, 0);
	at[42] = 37.9167;
	points[43] = (1649.7795, 3730.4331, 523.9213);
	angles[43] = (0, -193.3233, 0);
	at[43] = 38.5667;
	points[44] = (1635.9528, 3686.3428, 523.9213);
	angles[44] = (0, -200.0695, 0);
	at[44] = 39.2167;
	points[45] = (1623.6497, 3657.9922, 523.9213);
	angles[45] = (0, -205.4986, 0);
	at[45] = 39.6500;
	points[46] = (1607.7599, 3631.8071, 523.9213);
	angles[46] = (0, -215.4138, 0);
	at[46] = 40.0833;
	points[47] = (1584.5276, 3612.7520, 523.9213);
	angles[47] = (0, -238.1380, 0);
	at[47] = 40.5167;
	points[48] = (1571.1339, 3605.7324, 523.9213);
	angles[48] = (0, -242.8714, 0);
	at[48] = 40.7333;
	points[49] = (1514.0748, 3581.9844, 523.9213);
	angles[49] = (0, -249.4955, 0);
	at[49] = 41.6000;
	points[50] = (1455.8937, 3562.3308, 523.9213);
	angles[50] = (0, -252.5298, 0);
	at[50] = 42.4667;
	points[51] = (1336.3740, 3531.9961, 523.9213);
	angles[51] = (0, -259.4411, 0);
	at[51] = 44.2000;
	points[52] = (1290.9489, 3525.6968, 523.9213);
	angles[52] = (0, -263.1888, 0);
	at[52] = 44.8500;
	points[53] = (1153.9291, 3512.3582, 523.9213);
	angles[53] = (0, -265.0841, 0);
	at[53] = 46.8000;
	points[54] = (909.2363, 3495.4136, 523.9213);
	angles[54] = (0, -267.0946, 0);
	at[54] = 50.2500;
	mover = getEnt("iz_obj_4", "targetname");
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
