main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_donut_plains_1", 0);

	setExpFog(32480.3145, 44475.8867, 0.7020, 0.8980, 1, 0);

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
	ambientPlay("iz_0_rdp1", 2);
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
	level.iz_route[level.iz_route.size] = (4907, -682, 1063);
	level.iz_route[level.iz_route.size] = (4906, -2006, 1063);
	level.iz_route[level.iz_route.size] = (4876, -3207, 1063);
	level.iz_route[level.iz_route.size] = (4860, -4230, 1063);
	level.iz_route[level.iz_route.size] = (4608, -4903, 1063);
	level.iz_route[level.iz_route.size] = (4135, -5310, 1063);
	level.iz_route[level.iz_route.size] = (3517, -5561, 1063);
	level.iz_route[level.iz_route.size] = (2741, -5626, 1063);
	level.iz_route[level.iz_route.size] = (2067, -5631, 1063);
	level.iz_route[level.iz_route.size] = (-1127, -5665, 1052);
	level.iz_route[level.iz_route.size] = (-2317, -5615, 1063);
	level.iz_route[level.iz_route.size] = (-3398, -5555, 1063);
	level.iz_route[level.iz_route.size] = (-4121, -5420, 1063);
	level.iz_route[level.iz_route.size] = (-4813, -5186, 1063);
	level.iz_route[level.iz_route.size] = (-5174, -4804, 1063);
	level.iz_route[level.iz_route.size] = (-5265, -4277, 1063);
	level.iz_route[level.iz_route.size] = (-5132, -3852, 1063);
	level.iz_route[level.iz_route.size] = (-4854, -3485, 1063);
	level.iz_route[level.iz_route.size] = (-4560, -3256, 1063);
	level.iz_route[level.iz_route.size] = (-4162, -3039, 1063);
	level.iz_route[level.iz_route.size] = (-3732, -2930, 1063);
	level.iz_route[level.iz_route.size] = (-3169, -2764, 1063);
	level.iz_route[level.iz_route.size] = (-2578, -2634, 1063);
	level.iz_route[level.iz_route.size] = (-2093, -2549, 1063);
	level.iz_route[level.iz_route.size] = (117, -2195, 1058);
	level.iz_route[level.iz_route.size] = (840, -2067, 1063);
	level.iz_route[level.iz_route.size] = (1395, -1834, 1063);
	level.iz_route[level.iz_route.size] = (1819, -1515, 1063);
	level.iz_route[level.iz_route.size] = (2093, -1050, 1063);
	level.iz_route[level.iz_route.size] = (2251, -560, 1063);
	level.iz_route[level.iz_route.size] = (2138, -44, 1063);
	level.iz_route[level.iz_route.size] = (1903, 273, 1063);
	level.iz_route[level.iz_route.size] = (1473, 545, 1063);
	level.iz_route[level.iz_route.size] = (877, 723, 1063);
	level.iz_route[level.iz_route.size] = (155, 981, 1063);
	level.iz_route[level.iz_route.size] = (-1009, 1226, 1058);
	level.iz_route[level.iz_route.size] = (-2182, 1457, 1051);
	level.iz_route[level.iz_route.size] = (-3187, 1528, 1063);
	level.iz_route[level.iz_route.size] = (-3983, 1462, 1063);
	level.iz_route[level.iz_route.size] = (-4743, 1510, 1063);
	level.iz_route[level.iz_route.size] = (-5360, 1611, 1063);
	level.iz_route[level.iz_route.size] = (-5909, 1862, 1063);
	level.iz_route[level.iz_route.size] = (-6224, 2321, 1063);
	level.iz_route[level.iz_route.size] = (-6354, 2863, 1063);
	level.iz_route[level.iz_route.size] = (-6272, 3353, 1063);
	level.iz_route[level.iz_route.size] = (-5953, 3724, 1063);
	level.iz_route[level.iz_route.size] = (-5442, 4051, 1063);
	level.iz_route[level.iz_route.size] = (-4816, 4309, 1063);
	level.iz_route[level.iz_route.size] = (-4162, 4517, 1063);
	level.iz_route[level.iz_route.size] = (-3664, 4680, 1063);
	level.iz_route[level.iz_route.size] = (-3195, 4871, 1063);
	level.iz_route[level.iz_route.size] = (377, 6189, 1299);
	level.iz_route[level.iz_route.size] = (3194, 7306, 1063);
	level.iz_route[level.iz_route.size] = (4524, 7799, 1063);
	level.iz_route[level.iz_route.size] = (5180, 7996, 1063);
	level.iz_route[level.iz_route.size] = (5996, 8194, 1063);
	level.iz_route[level.iz_route.size] = (6696, 8107, 1063);
	level.iz_route[level.iz_route.size] = (7260, 7797, 1063);
	level.iz_route[level.iz_route.size] = (7626, 7242, 1063);
	level.iz_route[level.iz_route.size] = (7734, 6644, 1063);
	level.iz_route[level.iz_route.size] = (7672, 6027, 1063);
	level.iz_route[level.iz_route.size] = (7395, 5319, 1063);
	level.iz_route[level.iz_route.size] = (6807, 4777, 1063);
	level.iz_route[level.iz_route.size] = (6078, 4270, 1063);
	level.iz_route[level.iz_route.size] = (5612, 3796, 1063);
	level.iz_route[level.iz_route.size] = (5211, 3191, 1063);
	level.iz_route[level.iz_route.size] = (5078, 2483, 1063);
	level.iz_route[level.iz_route.size] = (4979, 1741, 1063);
	level.iz_route[level.iz_route.size] = (4916, 695, 1063);
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
	points[0] = (-992.2638, -613.7205, 472.4409);
	angles[0] = (0, 88.3420, 0);
	at[0] = 0;
	points[1] = (-1035.4528, -613.0118, 472.4409);
	angles[1] = (0, 88.7853, 0);
	at[1] = 0.0667;
	points[2] = (-1088.9094, -612.2638, 472.4409);
	angles[2] = (0, 89.0403, 0);
	at[2] = 0.1333;
	points[3] = (-1131.6732, -611.7126, 472.4409);
	angles[3] = (0, 89.1738, 0);
	at[3] = 0.2000;
	points[4] = (-1179.3622, -611.1221, 472.4409);
	angles[4] = (0, 89.2457, 0);
	at[4] = 0.2667;
	points[5] = (-1231.5669, -610.4961, 472.4409);
	angles[5] = (0, 89.2874, 0);
	at[5] = 0.3333;
	points[6] = (-1322.1221, -609.4410, 472.4409);
	angles[6] = (0, 89.3267, 0);
	at[6] = 0.4667;
	points[7] = (-1419.9528, -608.3189, 472.4409);
	angles[7] = (0, 89.3420, 0);
	at[7] = 0.6000;
	points[8] = (-1560.2244, -606.7205, 472.4409);
	angles[8] = (0, 89.3467, 0);
	at[8] = 0.8000;
	points[9] = (-2274.3464, -597.9174, 472.4409);
	angles[9] = (0, 89.2146, 0);
	at[9] = 1.8000;
	points[10] = (-2366.8308, -596.5827, 472.4409);
	angles[10] = (0, 89.1699, 0);
	at[10] = 1.9333;
	points[11] = (-2464.8662, -595.0591, 472.4409);
	angles[11] = (0, 89.1086, 0);
	at[11] = 2.0667;
	points[12] = (-2605.1458, -592.5984, 472.4409);
	angles[12] = (0, 88.9643, 0);
	at[12] = 2.2667;
	points[13] = (-2655.8269, -591.5827, 472.4409);
	angles[13] = (0, 88.8831, 0);
	at[13] = 2.3333;
	points[14] = (-2746.6104, -589.4291, 472.4409);
	angles[14] = (0, 88.6214, 0);
	at[14] = 2.4667;
	points[15] = (-2799.2441, -587.7795, 472.4409);
	angles[15] = (0, 88.3001, 0);
	at[15] = 2.5333;
	points[16] = (-2839.4136, -585.8583, 472.4409);
	angles[16] = (0, 87.5060, 0);
	at[16] = 2.6000;
	points[17] = (-2886.0237, -581.4095, 472.4409);
	angles[17] = (0, 85.2685, 0);
	at[17] = 2.6667;
	points[18] = (-2932.7913, -571.6221, 472.4409);
	angles[18] = (0, 79.8119, 0);
	at[18] = 2.7333;
	points[19] = (-2966.9802, -543.7913, 472.4409);
	angles[19] = (0, 55.7836, 0);
	at[19] = 2.8000;
	points[20] = (-2970.3267, -499.0669, 472.4409);
	angles[20] = (0, 30.8273, 0);
	at[20] = 2.8667;
	points[21] = (-2985.8071, -454.5433, 472.4409);
	angles[21] = (0, 22.4920, 0);
	at[21] = 2.9333;
	points[22] = (-2996.8506, -408.5512, 472.4409);
	angles[22] = (0, 17.4347, 0);
	at[22] = 3;
	points[23] = (-3031.1338, -320.8059, 472.4409);
	angles[23] = (0, 20.8582, 0);
	at[23] = 3.1333;
	points[24] = (-3059.6536, -232.7728, 472.4409);
	angles[24] = (0, 17.6490, 0);
	at[24] = 3.2667;
	points[25] = (-3211.6418, 317.3232, 472.4409);
	angles[25] = (0, 14.7557, 0);
	at[25] = 4.0667;
	points[26] = (-3221.7795, 361.8004, 472.4409);
	angles[26] = (0, 13.1515, 0);
	at[26] = 4.1333;
	points[27] = (-3228.1653, 408.6693, 472.4409);
	angles[27] = (0, 9.3125, 0);
	at[27] = 4.2000;
	points[28] = (-3229.4766, 455.8189, 472.4409);
	angles[28] = (0, 3.9593, 0);
	at[28] = 4.2667;
	points[29] = (-3223.4409, 502.2717, 472.4409);
	angles[29] = (0, -5.1095, 0);
	at[29] = 4.3333;
	points[30] = (-3198.3149, 542.3228, 472.4409);
	angles[30] = (0, -22.5995, 0);
	at[30] = 4.4000;
	points[31] = (-3167.7834, 578.3898, 472.4409);
	angles[31] = (0, -33.3156, 0);
	at[31] = 4.4667;
	points[32] = (-3101.9370, 646.2008, 472.4409);
	angles[32] = (0, -43.2229, 0);
	at[32] = 4.6000;
	points[33] = (-3065.4409, 674.9921, 468.8110);
	angles[33] = (0, -49.5771, 0);
	at[33] = 4.6667;
	points[34] = (-3026.1062, 697.7166, 455.1496);
	angles[34] = (0, -55.9844, 0);
	at[34] = 4.7333;
	points[35] = (-2985.3230, 717.7756, 460.3701);
	angles[35] = (0, -61.1307, 0);
	at[35] = 4.8000;
	points[36] = (-2967.7324, 722.5355, 501.8937);
	angles[36] = (0, -65.9757, 0);
	at[36] = 4.8667;
	points[37] = (-2930.9646, 723.6339, 688.3976);
	angles[37] = (0, -87.5890, 0);
	at[37] = 5.1333;
	points[38] = (-2890.9766, 722.0787, 874.7008);
	angles[38] = (0, -92.3786, 0);
	at[38] = 5.4000;
	points[39] = (-2874.1653, 721.4449, 916.9961);
	angles[39] = (0, -92.0957, 0);
	at[39] = 5.4667;
	points[40] = (-2830.7402, 719.6181, 931.0394);
	angles[40] = (0, -92.4177, 0);
	at[40] = 5.5333;
	points[41] = (-2783.5198, 717.3977, 926.3110);
	angles[41] = (0, -92.6020, 0);
	at[41] = 5.6000;
	points[42] = (-2689.7561, 712.9528, 910.9488);
	angles[42] = (0, -92.6635, 0);
	at[42] = 5.7333;
	points[43] = (-2655.3425, 711.8701, 934.6850);
	angles[43] = (0, -92.0421, 0);
	at[43] = 5.8000;
	points[44] = (-2641.6458, 712.1890, 980.2165);
	angles[44] = (0, -90.9842, 0);
	at[44] = 5.8667;
	points[45] = (-2613.8306, 713.3110, 1119.9843);
	angles[45] = (0, -89.1575, 0);
	at[45] = 6.0667;
	points[46] = (-2598.9763, 711.9016, 1164.0472);
	angles[46] = (0, -94.0703, 0);
	at[46] = 6.1333;
	points[47] = (-2562.9331, 706.6417, 1251.7717);
	angles[47] = (0, -97.8779, 0);
	at[47] = 6.2667;
	points[48] = (-2538.6221, 703.5276, 1291.1771);
	angles[48] = (0, -97.1001, 0);
	at[48] = 6.3333;
	points[49] = (-2495.8857, 700.1496, 1309.5867);
	angles[49] = (0, -94.5656, 0);
	at[49] = 6.4000;
	points[50] = (-2449.5198, 699.2086, 1310.2559);
	angles[50] = (0, -92.7291, 0);
	at[50] = 6.4667;
	points[51] = (-2415.2480, 696.6890, 1309.5315);
	angles[51] = (0, -93.6081, 0);
	at[51] = 6.5333;
	points[52] = (-2404.2402, 695.5394, 1266.6968);
	angles[52] = (0, -94.1660, 0);
	at[52] = 6.6000;
	points[53] = (-2388.5630, 693.4882, 1169.9331);
	angles[53] = (0, -95.8956, 0);
	at[53] = 6.7333;
	points[54] = (-2381.7244, 692.5590, 1125.2244);
	angles[54] = (0, -96.7344, 0);
	at[54] = 6.8000;
	points[55] = (-2291.0984, 681.0709, 515.1732);
	angles[55] = (0, -95.6933, 0);
	at[55] = 7.6667;
	points[56] = (-2283.3779, 680.7126, 468.5354);
	angles[56] = (0, -92.6001, 0);
	at[56] = 7.7333;
	points[57] = (-2268.3623, 689.9252, 445.7717);
	angles[57] = (0, -59.2518, 0);
	at[57] = 7.8000;
	points[58] = (-2241.3464, 696.3504, 472.4409);
	angles[58] = (0, -71.0561, 0);
	at[58] = 7.8667;
	points[59] = (-2194.5669, 688.8661, 472.4409);
	angles[59] = (0, -88.9608, 0);
	at[59] = 7.9333;
	points[60] = (-2104.3386, 661.4449, 472.4409);
	angles[60] = (0, -105.3404, 0);
	at[60] = 8.0667;
	points[61] = (-2062.5984, 640.5867, 472.4409);
	angles[61] = (0, -113.2691, 0);
	at[61] = 8.1333;
	points[62] = (-2024.8347, 612.2047, 472.4409);
	angles[62] = (0, -121.8177, 0);
	at[62] = 8.2000;
	points[63] = (-1951.1219, 552.3583, 472.4409);
	angles[63] = (0, -127.8525, 0);
	at[63] = 8.3333;
	points[64] = (-1876.7125, 493.9724, 472.4409);
	angles[64] = (0, -127.7339, 0);
	at[64] = 8.4667;
	points[65] = (-1799.1969, 439.6417, 472.4409);
	angles[65] = (0, -124.6423, 0);
	at[65] = 8.6000;
	points[66] = (-1758.3857, 416.1417, 472.4409);
	angles[66] = (0, -121.1949, 0);
	at[66] = 8.6667;
	points[67] = (-1716.4370, 399.5197, 472.4409);
	angles[67] = (0, -113.9374, 0);
	at[67] = 8.7333;
	points[68] = (-1621.9370, 383.0193, 472.4409);
	angles[68] = (0, -101.2944, 0);
	at[68] = 8.8667;
	points[69] = (-1480.5708, 367.1236, 472.4409);
	angles[69] = (0, -96.4203, 0);
	at[69] = 9.0667;
	points[70] = (-1197.2716, 337.3626, 472.4409);
	angles[70] = (0, -96.6482, 0);
	at[70] = 9.4667;
	points[71] = (-1104.5000, 322.7248, 472.4409);
	angles[71] = (0, -99.4124, 0);
	at[71] = 9.6000;
	points[72] = (-1060.6851, 309.5220, 472.4409);
	angles[72] = (0, -105.4974, 0);
	at[72] = 9.6667;
	points[73] = (-1020.3189, 284.8366, 472.4409);
	angles[73] = (0, -116.1259, 0);
	at[73] = 9.7333;
	points[74] = (-983.5984, 254.6677, 472.4409);
	angles[74] = (0, -124.5454, 0);
	at[74] = 9.8000;
	points[75] = (-916.1890, 188.1595, 472.4409);
	angles[75] = (0, -133.6394, 0);
	at[75] = 9.9333;
	points[76] = (-818.5394, 84.3610, 472.4409);
	angles[76] = (0, -135.9804, 0);
	at[76] = 10.1333;
	points[77] = (-783.5157, 54.2579, 472.4409);
	angles[77] = (0, -131.3431, 0);
	at[77] = 10.2000;
	points[78] = (-742.0551, 31.9306, 472.4409);
	angles[78] = (0, -122.8953, 0);
	at[78] = 10.2667;
	points[79] = (-654.9724, -5.4857, 472.4409);
	angles[79] = (0, -114.3899, 0);
	at[79] = 10.4000;
	points[80] = (-523.0040, -59.3150, 472.4409);
	angles[80] = (0, -112.8737, 0);
	at[80] = 10.6000;
	points[81] = (-482.3819, -80.5283, 472.4409);
	angles[81] = (0, -116.7123, 0);
	at[81] = 10.6667;
	points[82] = (-366.8914, -163.9217, 472.4409);
	angles[82] = (0, -126.5013, 0);
	at[82] = 10.8667;
	points[83] = (-330.5295, -194.4910, 472.4409);
	angles[83] = (0, -128.9645, 0);
	at[83] = 10.9333;
	points[84] = (-297.3351, -228.5055, 472.4409);
	angles[84] = (0, -134.4405, 0);
	at[84] = 11;
	points[85] = (-281.8268, -271.6839, 472.4409);
	angles[85] = (0, -151.9101, 0);
	at[85] = 11.0667;
	points[86] = (-275.8917, -318.7764, 472.4409);
	angles[86] = (0, -164.9430, 0);
	at[86] = 11.1333;
	points[87] = (-274.7500, -366.2374, 472.4409);
	angles[87] = (0, -173.6459, 0);
	at[87] = 11.2000;
	points[88] = (-279.6181, -413.0039, 472.4409);
	angles[88] = (0, -182.3144, 0);
	at[88] = 11.2667;
	points[89] = (-303.1248, -453.2835, 472.4409);
	angles[89] = (0, -201.4443, 0);
	at[89] = 11.3333;
	points[90] = (-335.5079, -487.5591, 472.4409);
	angles[90] = (0, -214.8211, 0);
	at[90] = 11.4000;
	points[91] = (-406.0236, -551.0472, 472.4409);
	angles[91] = (0, -226.6407, 0);
	at[91] = 11.5333;
	points[92] = (-444.0866, -579.7480, 472.4409);
	angles[92] = (0, -231.1956, 0);
	at[92] = 11.6000;
	points[93] = (-486.7047, -597.3504, 472.4409);
	angles[93] = (0, -242.4248, 0);
	at[93] = 11.6667;
	points[94] = (-532.6536, -609.1772, 472.4409);
	angles[94] = (0, -250.5491, 0);
	at[94] = 11.7333;
	points[95] = (-625.8701, -627.5984, 472.4409);
	angles[95] = (0, -257.9349, 0);
	at[95] = 11.8667;
	points[96] = (-672.1929, -633.0040, 472.4409);
	angles[96] = (0, -262.2377, 0);
	at[96] = 11.9333;
	points[97] = (-766.5315, -627.5039, 472.4409);
	angles[97] = (0, -272.6395, 0);
	at[97] = 12.0667;
	points[98] = (-812.6063, -621.3583, 472.4409);
	angles[98] = (0, -275.0757, 0);
	at[98] = 12.1333;
	points[99] = (-953.3701, -614.5787, 472.4409);
	angles[99] = (0, -272.2214, 0);
	at[99] = 12.3333;
	points[100] = (-992.2638, -613.7205, 472.4409);
	angles[100] = (0, -271.6580, 0);
	at[100] = 12.4000;
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
	points[0] = (1157.0472, 2939.6418, 472.4409);
	angles[0] = (0, -91.6824, 0);
	at[0] = 0;
	points[1] = (1187.9448, 2939.0354, 472.4409);
	angles[1] = (0, -91.3805, 0);
	at[1] = 0.0500;
	points[2] = (1226.9961, 2938.4175, 472.4409);
	angles[2] = (0, -91.1385, 0);
	at[2] = 0.1000;
	points[3] = (1259.8346, 2937.9412, 472.4409);
	angles[3] = (0, -90.9805, 0);
	at[3] = 0.1500;
	points[4] = (2152.7283, 2924.3230, 472.4409);
	angles[4] = (0, -91.3371, 0);
	at[4] = 1.4000;
	points[5] = (2185.4880, 2923.3779, 472.4409);
	angles[5] = (0, -91.5227, 0);
	at[5] = 1.4500;
	points[6] = (2224.5906, 2921.9487, 472.4409);
	angles[6] = (0, -91.8823, 0);
	at[6] = 1.5000;
	points[7] = (2255.8977, 2920.0947, 472.4409);
	angles[7] = (0, -92.8685, 0);
	at[7] = 1.5500;
	points[8] = (2291.1101, 2915.7285, 472.4409);
	angles[8] = (0, -95.4639, 0);
	at[8] = 1.6000;
	points[9] = (2325.1182, 2907.3506, 472.4409);
	angles[9] = (0, -100.5466, 0);
	at[9] = 1.6500;
	points[10] = (2356.3464, 2891.4370, 472.4409);
	angles[10] = (0, -110.5593, 0);
	at[10] = 1.7000;
	points[11] = (2380.4646, 2865.5864, 472.4409);
	angles[11] = (0, -124.3221, 0);
	at[11] = 1.7500;
	points[12] = (2455.7678, 2790.7876, 472.4409);
	angles[12] = (0, -134.7928, 0);
	at[12] = 1.9000;
	points[13] = (2478.5393, 2763.2834, 472.4409);
	angles[13] = (0, -137.9216, 0);
	at[13] = 1.9500;
	points[14] = (2496.0276, 2733.1494, 472.4409);
	angles[14] = (0, -145.3938, 0);
	at[14] = 2;
	points[15] = (2507.9331, 2699.6929, 472.4409);
	angles[15] = (0, -153.1177, 0);
	at[15] = 2.0500;
	points[16] = (2527.1379, 2631.4763, 472.4409);
	angles[16] = (0, -161.9591, 0);
	at[16] = 2.1500;
	points[17] = (2544.7678, 2526.4487, 472.4409);
	angles[17] = (0, -170.1123, 0);
	at[17] = 2.3000;
	points[18] = (2547.9883, 2491.5906, 472.4409);
	angles[18] = (0, -173.0520, 0);
	at[18] = 2.3500;
	points[19] = (2544.7639, 2384.9490, 472.4409);
	angles[19] = (0, -181.4565, 0);
	at[19] = 2.5000;
	points[20] = (2532.1494, 2315.5708, 472.4409);
	angles[20] = (0, -189.1912, 0);
	at[20] = 2.6000;
	points[21] = (2512.1968, 2248.0393, 472.4409);
	angles[21] = (0, -195.8064, 0);
	at[21] = 2.7000;
	points[22] = (2482.5747, 2183.1692, 472.4409);
	angles[22] = (0, -202.7374, 0);
	at[22] = 2.8000;
	points[23] = (2447.8936, 2121.5789, 472.4409);
	angles[23] = (0, -209.5976, 0);
	at[23] = 2.9000;
	points[24] = (2396.2520, 2073.0552, 472.4409);
	angles[24] = (0, -223.4013, 0);
	at[24] = 3;
	points[25] = (2339.4568, 2030.3623, 472.4409);
	angles[25] = (0, -231.9079, 0);
	at[25] = 3.1000;
	points[26] = (2276.3071, 2003.0118, 457.3583);
	angles[26] = (0, -243.6176, 0);
	at[26] = 3.2000;
	points[27] = (2243.0474, 1991.2678, 452.7716);
	angles[27] = (0, -247.2522, 0);
	at[27] = 3.2500;
	points[28] = (2210.3779, 1981.6221, 460.3976);
	angles[28] = (0, -250.6877, 0);
	at[28] = 3.3000;
	points[29] = (2192.2283, 1978.9331, 488.3347);
	angles[29] = (0, -254.5030, 0);
	at[29] = 3.3500;
	points[30] = (2174.5237, 1979.9213, 557.1260);
	angles[30] = (0, -262.9200, 0);
	at[30] = 3.4500;
	points[31] = (2144.5156, 1984.6417, 696.7520);
	angles[31] = (0, -277.6482, 0);
	at[31] = 3.6500;
	points[32] = (2110.0396, 1991.1772, 835.1496);
	angles[32] = (0, -280.5033, 0);
	at[32] = 3.8500;
	points[33] = (2084.0356, 1995.6378, 901.1221);
	angles[33] = (0, -279.5840, 0);
	at[33] = 3.9500;
	points[34] = (2059.9529, 1998.9763, 922.6575);
	angles[34] = (0, -278.3192, 0);
	at[34] = 4;
	points[35] = (2025.1261, 2003.5906, 929.2362);
	angles[35] = (0, -277.8599, 0);
	at[35] = 4.0500;
	points[36] = (1954.7008, 2012.8859, 928.6063);
	angles[36] = (0, -277.5988, 0);
	at[36] = 4.1500;
	points[37] = (1743.9055, 2040.6417, 909.1929);
	angles[37] = (0, -277.5005, 0);
	at[37] = 4.4500;
	points[38] = (1709.0236, 2045.2363, 909.7993);
	angles[38] = (0, -277.5018, 0);
	at[38] = 4.5000;
	points[39] = (1679.4449, 2049.1458, 925.2323);
	angles[39] = (0, -277.5208, 0);
	at[39] = 4.5500;
	points[40] = (1667.1536, 2050.7993, 958.3071);
	angles[40] = (0, -277.5585, 0);
	at[40] = 4.6000;
	points[41] = (1661.0552, 2051.6377, 993.3149);
	angles[41] = (0, -277.6095, 0);
	at[41] = 4.6500;
	points[42] = (1650.8741, 2053.0945, 1171.0118);
	angles[42] = (0, -277.7616, 0);
	at[42] = 4.9000;
	points[43] = (1643.2008, 2054.0159, 1204.8740);
	angles[43] = (0, -276.9224, 0);
	at[43] = 4.9500;
	points[44] = (1626.4291, 2055.9055, 1236.0787);
	angles[44] = (0, -276.5391, 0);
	at[44] = 5;
	points[45] = (1605.4803, 2058.2205, 1264.7047);
	angles[45] = (0, -276.3848, 0);
	at[45] = 5.0500;
	points[46] = (1580.1615, 2060.9802, 1288.7048);
	angles[46] = (0, -276.2667, 0);
	at[46] = 5.1000;
	points[47] = (1548.5708, 2064.3740, 1304.6260);
	angles[47] = (0, -276.1845, 0);
	at[47] = 5.1500;
	points[48] = (1514.9094, 2068.0354, 1302.1929);
	angles[48] = (0, -276.2159, 0);
	at[48] = 5.2000;
	points[49] = (1483.9764, 2071.3818, 1285.0315);
	angles[49] = (0, -276.1567, 0);
	at[49] = 5.2500;
	points[50] = (1460.0552, 2073.3938, 1259.3307);
	angles[50] = (0, -275.5067, 0);
	at[50] = 5.3000;
	points[51] = (1439.5669, 2074.8386, 1230.4291);
	angles[51] = (0, -274.9605, 0);
	at[51] = 5.3500;
	points[52] = (1421.7716, 2076.2166, 1199.8149);
	angles[52] = (0, -274.8467, 0);
	at[52] = 5.4000;
	points[53] = (1409.4410, 2077.6694, 1166.9646);
	angles[53] = (0, -275.6853, 0);
	at[53] = 5.4500;
	points[54] = (1371.7874, 2083.3191, 1030.2047);
	angles[54] = (0, -278.1813, 0);
	at[54] = 5.6500;
	points[55] = (1360.4960, 2084.8740, 961.8898);
	angles[55] = (0, -277.8818, 0);
	at[55] = 5.7500;
	points[56] = (1354.3308, 2085.7795, 712.3189);
	angles[56] = (0, -277.0834, 0);
	at[56] = 6.1000;
	points[57] = (1349.7638, 2086.2717, 641.2520);
	angles[57] = (0, -276.2267, 0);
	at[57] = 6.2000;
	points[58] = (1341.0865, 2087.1575, 570.2638);
	angles[58] = (0, -275.8497, 0);
	at[58] = 6.3000;
	points[59] = (1334.1497, 2087.8503, 536.4174);
	angles[59] = (0, -275.7432, 0);
	at[59] = 6.3500;
	points[60] = (1323.0669, 2088.9448, 502.1969);
	angles[60] = (0, -275.6638, 0);
	at[60] = 6.4000;
	points[61] = (1303.4331, 2090.8621, 473.3819);
	angles[61] = (0, -275.6023, 0);
	at[61] = 6.4500;
	points[62] = (1271.3464, 2093.7678, 460.4882);
	angles[62] = (0, -275.2666, 0);
	at[62] = 6.5000;
	points[63] = (1237.9883, 2096.6379, 454.9331);
	angles[63] = (0, -275.0634, 0);
	at[63] = 6.5500;
	points[64] = (1166.7441, 2102.6890, 450.2914);
	angles[64] = (0, -274.9073, 0);
	at[64] = 6.6500;
	points[65] = (1095.8188, 2108.7520, 449.9213);
	angles[65] = (0, -274.8989, 0);
	at[65] = 6.7500;
	points[66] = (918.4921, 2124.4568, 456.7756);
	angles[66] = (0, -275.1492, 0);
	at[66] = 7;
	points[67] = (669.9094, 2150.9529, 472.0787);
	angles[67] = (0, -277.1243, 0);
	at[67] = 7.3500;
	points[68] = (638.1102, 2156.8032, 472.4409);
	angles[68] = (0, -279.1636, 0);
	at[68] = 7.4000;
	points[69] = (535.8701, 2187.2205, 472.4409);
	angles[69] = (0, -286.7213, 0);
	at[69] = 7.5500;
	points[70] = (404.2874, 2241.2559, 472.4409);
	angles[70] = (0, -293.3169, 0);
	at[70] = 7.7500;
	points[71] = (372.9815, 2257.2598, 472.4409);
	angles[71] = (0, -295.5294, 0);
	at[71] = 7.8000;
	points[72] = (344.1807, 2276.6064, 472.4409);
	angles[72] = (0, -301.0228, 0);
	at[72] = 7.8500;
	points[73] = (296.7358, 2329.5078, 472.4409);
	angles[73] = (0, -314.8937, 0);
	at[73] = 7.9500;
	points[74] = (255.0673, 2387.1733, 472.4409);
	angles[74] = (0, -322.2347, 0);
	at[74] = 8.0500;
	points[75] = (217.1260, 2447.5000, 472.4409);
	angles[75] = (0, -327.0452, 0);
	at[75] = 8.1500;
	points[76] = (202.9102, 2478.9844, 472.4409);
	angles[76] = (0, -332.2679, 0);
	at[76] = 8.2000;
	points[77] = (183.6252, 2547.4844, 472.4409);
	angles[77] = (0, -341.9599, 0);
	at[77] = 8.3000;
	points[78] = (171.2173, 2617.2046, 472.4409);
	angles[78] = (0, -348.8891, 0);
	at[78] = 8.4000;
	points[79] = (171.6193, 2652.0867, 472.4409);
	angles[79] = (0, -355.7785, 0);
	at[79] = 8.4500;
	points[80] = (176.2201, 2687.5198, 472.4409);
	angles[80] = (0, -361.7327, 0);
	at[80] = 8.5000;
	points[81] = (197.1957, 2791.8779, 472.4409);
	angles[81] = (0, -371.1970, 0);
	at[81] = 8.6500;
	points[82] = (208.8988, 2824.9333, 472.4409);
	angles[82] = (0, -376.8641, 0);
	at[82] = 8.7000;
	points[83] = (228.6748, 2854.5081, 472.4409);
	angles[83] = (0, -385.9576, 0);
	at[83] = 8.7500;
	points[84] = (251.7677, 2881.5156, 472.4409);
	angles[84] = (0, -393.6576, 0);
	at[84] = 8.8000;
	points[85] = (277.7323, 2905.7048, 472.4409);
	angles[85] = (0, -401.0424, 0);
	at[85] = 8.8500;
	points[86] = (307.5772, 2922.7717, 472.4409);
	angles[86] = (0, -412.7416, 0);
	at[86] = 8.9000;
	points[87] = (342.3752, 2930.8860, 472.4409);
	angles[87] = (0, -425.0071, 0);
	at[87] = 8.9500;
	points[88] = (377.5626, 2936.9175, 472.4409);
	angles[88] = (0, -432.6216, 0);
	at[88] = 9;
	points[89] = (483.4803, 2950.7087, 472.4409);
	angles[89] = (0, -441.7159, 0);
	at[89] = 9.1500;
	points[90] = (553.6536, 2956.1733, 472.4409);
	angles[90] = (0, -445.2552, 0);
	at[90] = 9.2500;
	points[91] = (802.1733, 2953.2954, 472.4409);
	angles[91] = (0, -451.1996, 0);
	at[91] = 9.6000;
	points[92] = (1157.0472, 2939.6418, 472.4409);
	angles[92] = (0, -451.6824, 0);
	at[92] = 10.1000;
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
	points[0] = (-2197.8545, 5929.2915, 903.0275);
	angles[0] = (0, -163.0439, 0);
	at[0] = 0;
	points[1] = (-2187.1616, 5899.0552, 925.6614);
	angles[1] = (0, -161.0375, 0);
	at[1] = 0.0500;
	points[2] = (-2174.3701, 5866.8110, 930.5118);
	angles[2] = (0, -159.4565, 0);
	at[2] = 0.1000;
	points[3] = (-2160.8582, 5833.9375, 929.2362);
	angles[3] = (0, -158.4983, 0);
	at[3] = 0.1500;
	points[4] = (-2106.0198, 5703.9761, 910.4410);
	angles[4] = (0, -157.1659, 0);
	at[4] = 0.3500;
	points[5] = (-2092.2639, 5671.0239, 912.4055);
	angles[5] = (0, -157.3414, 0);
	at[5] = 0.4000;
	points[6] = (-2083.3977, 5647.9526, 934.8977);
	angles[6] = (0, -158.1066, 0);
	at[6] = 0.4500;
	points[7] = (-2077.3779, 5631.1025, 965.8937);
	angles[7] = (0, -158.8784, 0);
	at[7] = 0.5000;
	points[8] = (-2050.0276, 5551.4570, 1161.3188);
	angles[8] = (0, -160.4134, 0);
	at[8] = 0.8000;
	points[9] = (-2042.5198, 5532.6772, 1190.3425);
	angles[9] = (0, -159.0270, 0);
	at[9] = 0.8500;
	points[10] = (-2025.0276, 5490.6694, 1245.0237);
	angles[10] = (0, -157.7059, 0);
	at[10] = 0.9500;
	points[11] = (-2015.5748, 5467.8740, 1270.6221);
	angles[11] = (0, -157.6399, 0);
	at[11] = 1;
	points[12] = (-2005.0198, 5440.4727, 1289.2677);
	angles[12] = (0, -158.5545, 0);
	at[12] = 1.0500;
	points[13] = (-1993.3584, 5408.8188, 1300.5157);
	angles[13] = (0, -159.2437, 0);
	at[13] = 1.1000;
	points[14] = (-1981.4528, 5376.2603, 1307.6143);
	angles[14] = (0, -159.5830, 0);
	at[14] = 1.1500;
	points[15] = (-1969.3662, 5343.5830, 1303.2794);
	angles[15] = (0, -159.6267, 0);
	at[15] = 1.2000;
	points[16] = (-1935.2323, 5249.8032, 1267.4371);
	angles[16] = (0, -160.1637, 0);
	at[16] = 1.3500;
	points[17] = (-1924.7716, 5220.1182, 1251.3071);
	angles[17] = (0, -160.3492, 0);
	at[17] = 1.4000;
	points[18] = (-1916.2245, 5196.1025, 1226.8898);
	angles[18] = (0, -160.3439, 0);
	at[18] = 1.4500;
	points[19] = (-1909.7323, 5178.1890, 1197.3386);
	angles[19] = (0, -160.2171, 0);
	at[19] = 1.5000;
	points[20] = (-1900.9961, 5154.7241, 1133.2284);
	angles[20] = (0, -159.8126, 0);
	at[20] = 1.6000;
	points[21] = (-1858.1576, 5040.9058, 760.0512);
	angles[21] = (0, -159.3988, 0);
	at[21] = 2.1500;
	points[22] = (-1836.1024, 4981.9292, 593.0355);
	angles[22] = (0, -159.5506, 0);
	at[22] = 2.4000;
	points[23] = (-1825.5708, 4953.4648, 528.2480);
	angles[23] = (0, -159.6741, 0);
	at[23] = 2.5000;
	points[24] = (-1819.4685, 4936.8506, 497.9882);
	angles[24] = (0, -159.7725, 0);
	at[24] = 2.5500;
	points[25] = (-1812.1182, 4916.6538, 472.2874);
	angles[25] = (0, -159.9485, 0);
	at[25] = 2.6000;
	points[26] = (-1801.8779, 4887.3228, 456.1890);
	angles[26] = (0, -160.5284, 0);
	at[26] = 2.6500;
	points[27] = (-1791.1104, 4855.5513, 447.9409);
	angles[27] = (0, -160.9560, 0);
	at[27] = 2.7000;
	points[28] = (-1779.7520, 4821.7324, 443.3347);
	angles[28] = (0, -161.2070, 0);
	at[28] = 2.7500;
	points[29] = (-1745.7953, 4720.4727, 441.0905);
	angles[29] = (0, -161.4139, 0);
	at[29] = 2.9000;
	points[30] = (-1700.0394, 4586.0630, 450.1693);
	angles[30] = (0, -161.0968, 0);
	at[30] = 3.1000;
	points[31] = (-1652.4252, 4452.9531, 464.7165);
	angles[31] = (0, -160.0127, 0);
	at[31] = 3.3000;
	points[32] = (-1625.6615, 4386.1416, 471.6102);
	angles[32] = (0, -158.1470, 0);
	at[32] = 3.4000;
	points[33] = (-1610.4253, 4356.8506, 472.4409);
	angles[33] = (0, -154.5289, 0);
	at[33] = 3.4500;
	points[34] = (-1589.8818, 4327.7954, 472.4409);
	angles[34] = (0, -149.1209, 0);
	at[34] = 3.5000;
	points[35] = (-1542.0984, 4275.2363, 472.4409);
	angles[35] = (0, -139.6813, 0);
	at[35] = 3.6000;
	points[36] = (-1488.4448, 4228.5825, 472.4409);
	angles[36] = (0, -132.3848, 0);
	at[36] = 3.7000;
	points[37] = (-1459.5867, 4207.9131, 472.4409);
	angles[37] = (0, -128.5889, 0);
	at[37] = 3.7500;
	points[38] = (-1428.5355, 4190.4727, 472.4409);
	angles[38] = (0, -123.0217, 0);
	at[38] = 3.8000;
	points[39] = (-1395.1536, 4183.0317, 472.4409);
	angles[39] = (0, -111.2557, 0);
	at[39] = 3.8500;
	points[40] = (-1324.1458, 4184.4883, 472.4409);
	angles[40] = (0, -93.7213, 0);
	at[40] = 3.9500;
	points[41] = (-1253.2874, 4192.4805, 472.4409);
	angles[41] = (0, -85.7129, 0);
	at[41] = 4.0500;
	points[42] = (-1183.3110, 4205.4727, 472.4409);
	angles[42] = (0, -80.3654, 0);
	at[42] = 4.1500;
	points[43] = (-1149.1732, 4215.5513, 472.4409);
	angles[43] = (0, -76.1109, 0);
	at[43] = 4.2000;
	points[44] = (-1122.4646, 4236.3384, 472.4409);
	angles[44] = (0, -61.3684, 0);
	at[44] = 4.2500;
	points[45] = (-1104.0472, 4267.0474, 472.4409);
	angles[45] = (0, -45.7641, 0);
	at[45] = 4.3000;
	points[46] = (-1077.0118, 4332.5981, 472.4409);
	angles[46] = (0, -27.5838, 0);
	at[46] = 4.4000;
	points[47] = (-1057.7126, 4400.9053, 472.4409);
	angles[47] = (0, -17.7677, 0);
	at[47] = 4.5000;
	points[48] = (-1054.7362, 4435.7876, 472.4409);
	angles[48] = (0, -10.0160, 0);
	at[48] = 4.5500;
	points[49] = (-1058.9685, 4470.9053, 472.4409);
	angles[49] = (0, -1.0042, 0);
	at[49] = 4.6000;
	points[50] = (-1076.1693, 4539.6851, 472.4409);
	angles[50] = (0, 10.8174, 0);
	at[50] = 4.7000;
	points[51] = (-1097.2362, 4607.0864, 472.4409);
	angles[51] = (0, 15.8575, 0);
	at[51] = 4.8000;
	points[52] = (-1107.3976, 4637.7163, 472.4409);
	angles[52] = (0, 17.1509, 0);
	at[52] = 4.8500;
	points[53] = (-1143.2245, 4741.0630, 472.4409);
	angles[53] = (0, 18.9408, 0);
	at[53] = 5;
	points[54] = (-1392.2953, 5445.0396, 472.4409);
	angles[54] = (0, 19.4146, 0);
	at[54] = 6.0500;
	points[55] = (-1403.9922, 5478.4648, 472.4409);
	angles[55] = (0, 19.3372, 0);
	at[55] = 6.1000;
	points[56] = (-1414.1969, 5507.9136, 472.4409);
	angles[56] = (0, 19.2071, 0);
	at[56] = 6.1500;
	points[57] = (-1655.3544, 6216.8896, 472.4409);
	angles[57] = (0, 19.1149, 0);
	at[57] = 7.2000;
	points[58] = (-1666.4174, 6247.7559, 472.4409);
	angles[58] = (0, 19.4365, 0);
	at[58] = 7.2500;
	points[59] = (-1716.4055, 6380.5513, 472.4409);
	angles[59] = (0, 21.2149, 0);
	at[59] = 7.4500;
	points[60] = (-1746.5157, 6444.7642, 472.4409);
	angles[60] = (0, 25.1083, 0);
	at[60] = 7.5500;
	points[61] = (-1765.6458, 6473.1494, 472.4409);
	angles[61] = (0, 30.6201, 0);
	at[61] = 7.6000;
	points[62] = (-1815.4410, 6524.4487, 472.4409);
	angles[62] = (0, 41.3632, 0);
	at[62] = 7.7000;
	points[63] = (-1868.1812, 6572.2441, 472.4409);
	angles[63] = (0, 46.4659, 0);
	at[63] = 7.8000;
	points[64] = (-1951.7875, 6638.0708, 472.4409);
	angles[64] = (0, 52.6861, 0);
	at[64] = 7.9500;
	points[65] = (-1983.9253, 6650.8267, 472.4409);
	angles[65] = (0, 62.7227, 0);
	at[65] = 8;
	points[66] = (-2019.4174, 6653.7402, 472.4409);
	angles[66] = (0, 74.5449, 0);
	at[66] = 8.0500;
	points[67] = (-2090.3779, 6649.1338, 472.4409);
	angles[67] = (0, 89.7784, 0);
	at[67] = 8.1500;
	points[68] = (-2125.3425, 6642.7954, 472.4409);
	angles[68] = (0, 95.6193, 0);
	at[68] = 8.2000;
	points[69] = (-2156.0669, 6626.7324, 472.4409);
	angles[69] = (0, 109.0031, 0);
	at[69] = 8.2500;
	points[70] = (-2202.9448, 6573.5825, 472.4409);
	angles[70] = (0, 132.3006, 0);
	at[70] = 8.3500;
	points[71] = (-2222.4961, 6544.1338, 472.4409);
	angles[71] = (0, 139.8428, 0);
	at[71] = 8.4000;
	points[72] = (-2236.5039, 6512.1265, 472.4409);
	angles[72] = (0, 148.9457, 0);
	at[72] = 8.4500;
	points[73] = (-2257.3386, 6443.9766, 472.4409);
	angles[73] = (0, 159.7687, 0);
	at[73] = 8.5500;
	points[74] = (-2274.5591, 6375.0791, 472.4409);
	angles[74] = (0, 164.8433, 0);
	at[74] = 8.6500;
	points[75] = (-2279.9922, 6340.6689, 472.1535);
	angles[75] = (0, 168.9501, 0);
	at[75] = 8.7000;
	points[76] = (-2277.1025, 6271.0630, 457.5276);
	angles[76] = (0, 179.7051, 0);
	at[76] = 8.8000;
	points[77] = (-2273.3977, 6236.0239, 452.9567);
	angles[77] = (0, 182.9740, 0);
	at[77] = 8.8500;
	points[78] = (-2268.7166, 6201.1812, 455.9291);
	angles[78] = (0, 185.4283, 0);
	at[78] = 8.9000;
	points[79] = (-2263.6182, 6171.4570, 473.0669);
	angles[79] = (0, 187.5274, 0);
	at[79] = 8.9500;
	points[80] = (-2259.1890, 6151.6934, 501.1378);
	angles[80] = (0, 189.4417, 0);
	at[80] = 9;
	points[81] = (-2241.8860, 6083.7397, 625.2126);
	angles[81] = (0, 194.0113, 0);
	at[81] = 9.2000;
	points[82] = (-2214.6379, 5985.1182, 812.3622);
	angles[82] = (0, 195.7681, 0);
	at[82] = 9.5000;
	points[83] = (-2197.8545, 5929.2915, 903.0275);
	angles[83] = (0, 196.9561, 0);
	at[83] = 9.6500;
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
	points[0] = (2068.8308, 5715.7480, 914.4843);
	angles[0] = (0, 20.1034, 0);
	at[0] = 0;
	points[1] = (2056.4724, 5746.4961, 925.2520);
	angles[1] = (0, 21.2124, 0);
	at[1] = 0.0500;
	points[2] = (2029.3505, 5810.8267, 930.3032);
	angles[2] = (0, 22.5439, 0);
	at[2] = 0.1500;
	points[3] = (2001.1536, 5876.3779, 927.9252);
	angles[3] = (0, 23.1235, 0);
	at[3] = 0.2500;
	points[4] = (1902.0276, 6103.5044, 909.4252);
	angles[4] = (0, 23.6336, 0);
	at[4] = 0.6000;
	points[5] = (1887.5552, 6136.6143, 909.7244);
	angles[5] = (0, 23.6198, 0);
	at[5] = 0.6500;
	points[6] = (1874.0552, 6167.6772, 915.8818);
	angles[6] = (0, 23.5034, 0);
	at[6] = 0.7000;
	points[7] = (1863.2874, 6192.9136, 937.3307);
	angles[7] = (0, 23.3355, 0);
	at[7] = 0.7500;
	points[8] = (1854.8347, 6212.8345, 965.5827);
	angles[8] = (0, 23.1962, 0);
	at[8] = 0.8000;
	points[9] = (1841.1456, 6245.2759, 1027.5078);
	angles[9] = (0, 22.9868, 0);
	at[9] = 0.9000;
	points[10] = (1817.3583, 6301.5747, 1156.3937);
	angles[10] = (0, 22.9890, 0);
	at[10] = 1.1000;
	points[11] = (1810.0551, 6318.4253, 1185.2559);
	angles[11] = (0, 23.3073, 0);
	at[11] = 1.1500;
	points[12] = (1799.7362, 6341.5752, 1210.2245);
	angles[12] = (0, 23.7672, 0);
	at[12] = 1.2000;
	points[13] = (1776.8662, 6392.1650, 1254.6221);
	angles[13] = (0, 24.2255, 0);
	at[13] = 1.3000;
	points[14] = (1752.8385, 6445.1182, 1295.7992);
	angles[14] = (0, 24.3643, 0);
	at[14] = 1.4000;
	points[15] = (1715.8032, 6527.2046, 1351.4802);
	angles[15] = (0, 24.3006, 0);
	at[15] = 1.5500;
	points[16] = (1689.7047, 6584.6060, 1384.3386);
	angles[16] = (0, 24.4660, 0);
	at[16] = 1.6500;
	points[17] = (1675.6575, 6614.7637, 1394.2875);
	angles[17] = (0, 24.7738, 0);
	at[17] = 1.7000;
	points[18] = (1645.7875, 6678.1099, 1407.0945);
	angles[18] = (0, 25.1508, 0);
	at[18] = 1.8000;
	points[19] = (1615.4055, 6741.9292, 1416.0197);
	angles[19] = (0, 25.4221, 0);
	at[19] = 1.9000;
	points[20] = (1600.0787, 6773.3076, 1416.9292);
	angles[20] = (0, 25.8341, 0);
	at[20] = 1.9500;
	points[21] = (1584.1300, 6804.7241, 1413.4253);
	angles[21] = (0, 26.3971, 0);
	at[21] = 2;
	points[22] = (1536.3662, 6897.7163, 1393.2126);
	angles[22] = (0, 27.0670, 0);
	at[22] = 2.1500;
	points[23] = (1506.8268, 6956.1421, 1367.9252);
	angles[23] = (0, 26.8455, 0);
	at[23] = 2.2500;
	points[24] = (1477.6890, 7014.0947, 1338.2755);
	angles[24] = (0, 26.7356, 0);
	at[24] = 2.3500;
	points[25] = (1449.2126, 7070.7480, 1306.1023);
	angles[25] = (0, 26.7079, 0);
	at[25] = 2.4500;
	points[26] = (1422.3149, 7124.1343, 1269.0552);
	angles[26] = (0, 26.7436, 0);
	at[26] = 2.5500;
	points[27] = (1362.0945, 7242.8740, 1152.1772);
	angles[27] = (0, 26.8951, 0);
	at[27] = 2.8000;
	points[28] = (1305.2440, 7355.0786, 1026.1615);
	angles[28] = (0, 26.8496, 0);
	at[28] = 3.0500;
	points[29] = (1286.1260, 7393.2280, 973.1102);
	angles[29] = (0, 26.4444, 0);
	at[29] = 3.1500;
	points[30] = (1278.3385, 7410.5908, 942.1851);
	angles[30] = (0, 25.2754, 0);
	at[30] = 3.2000;
	points[31] = (1245.6969, 7488.8979, 785.4449);
	angles[31] = (0, 22.7018, 0);
	at[31] = 3.4500;
	points[32] = (1204.5826, 7579.8823, 597.2480);
	angles[32] = (0, 25.6277, 0);
	at[32] = 3.7500;
	points[33] = (1187.7126, 7610.6299, 535.8622);
	angles[33] = (0, 28.5772, 0);
	at[33] = 3.8500;
	points[34] = (1177.1182, 7627.0078, 504.9922);
	angles[34] = (0, 31.3358, 0);
	at[34] = 3.9000;
	points[35] = (1163.2756, 7643.7793, 476.6575);
	angles[35] = (0, 37.0665, 0);
	at[35] = 3.9500;
	points[36] = (1140.1497, 7660.7480, 459.4252);
	angles[36] = (0, 48.1614, 0);
	at[36] = 4;
	points[37] = (1110.0039, 7677.5591, 452.1181);
	angles[37] = (0, 55.5920, 0);
	at[37] = 4.0500;
	points[38] = (1078.0906, 7693.1890, 449.8268);
	angles[38] = (0, 60.0413, 0);
	at[38] = 4.1000;
	points[39] = (1013.1969, 7721.6538, 452.4409);
	angles[39] = (0, 65.0665, 0);
	at[39] = 4.2000;
	points[40] = (947.0355, 7747.2837, 459.8071);
	angles[40] = (0, 68.1806, 0);
	at[40] = 4.3000;
	points[41] = (879.8110, 7769.2124, 468.8268);
	angles[41] = (0, 71.5828, 0);
	at[41] = 4.4000;
	points[42] = (845.1536, 7776.9292, 472.2795);
	angles[42] = (0, 75.3473, 0);
	at[42] = 4.4500;
	points[43] = (811.4174, 7775.5908, 472.4409);
	angles[43] = (0, 85.1310, 0);
	at[43] = 4.5000;
	points[44] = (742.5945, 7757.3228, 472.4409);
	angles[44] = (0, 100.8557, 0);
	at[44] = 4.6000;
	points[45] = (676.5394, 7731.2598, 472.4409);
	angles[45] = (0, 109.5059, 0);
	at[45] = 4.7000;
	points[46] = (613.7756, 7697.4409, 472.4409);
	angles[46] = (0, 117.5062, 0);
	at[46] = 4.8000;
	points[47] = (589.5157, 7673.6221, 472.4409);
	angles[47] = (0, 128.4351, 0);
	at[47] = 4.8500;
	points[48] = (574.1339, 7641.4570, 472.4409);
	angles[48] = (0, 141.9466, 0);
	at[48] = 4.9000;
	points[49] = (552.9252, 7573.5830, 472.4409);
	angles[49] = (0, 158.1585, 0);
	at[49] = 5;
	points[50] = (539.2559, 7503.9766, 472.4409);
	angles[50] = (0, 166.9458, 0);
	at[50] = 5.1000;
	points[51] = (535.6929, 7468.3862, 472.4409);
	angles[51] = (0, 171.0380, 0);
	at[51] = 5.1500;
	points[52] = (536.2087, 7432.8350, 472.4409);
	angles[52] = (0, 176.8713, 0);
	at[52] = 5.2000;
	points[53] = (544.0472, 7399.2129, 472.4409);
	angles[53] = (0, 185.7176, 0);
	at[53] = 5.2500;
	points[54] = (568.4488, 7332.3623, 472.4409);
	angles[54] = (0, 196.8155, 0);
	at[54] = 5.3500;
	points[55] = (624.1929, 7201.9683, 472.4409);
	angles[55] = (0, 203.1575, 0);
	at[55] = 5.5500;
	points[56] = (697.9174, 7039.8423, 472.4409);
	angles[56] = (0, 204.4889, 0);
	at[56] = 5.8000;
	points[57] = (711.5275, 7010.1187, 472.4409);
	angles[57] = (0, 204.6041, 0);
	at[57] = 5.8500;
	points[58] = (972.7717, 6463.8584, 472.4409);
	angles[58] = (0, 204.7681, 0);
	at[58] = 6.7000;
	points[59] = (999.1536, 6403.5039, 472.4409);
	angles[59] = (0, 203.6982, 0);
	at[59] = 6.8000;
	points[60] = (1013.9331, 6368.1104, 472.4409);
	angles[60] = (0, 203.1616, 0);
	at[60] = 6.8500;
	points[61] = (1026.6339, 6337.3232, 472.4409);
	angles[61] = (0, 202.7784, 0);
	at[61] = 6.9000;
	points[62] = (1281.0157, 5710.8662, 472.4409);
	angles[62] = (0, 202.3579, 0);
	at[62] = 7.8500;
	points[63] = (1365.3976, 5513.1104, 472.4409);
	angles[63] = (0, 203.6956, 0);
	at[63] = 8.1500;
	points[64] = (1395.2520, 5452.3623, 472.4409);
	angles[64] = (0, 206.2112, 0);
	at[64] = 8.2500;
	points[65] = (1471.8977, 5332.4014, 472.4409);
	angles[65] = (0, 213.4500, 0);
	at[65] = 8.4500;
	points[66] = (1557.1771, 5218.7007, 472.4409);
	angles[66] = (0, 217.2751, 0);
	at[66] = 8.6500;
	points[67] = (1647.5513, 5108.6611, 472.4409);
	angles[67] = (0, 219.7723, 0);
	at[67] = 8.8500;
	points[68] = (1694.2914, 5056.9688, 472.4409);
	angles[68] = (0, 222.2066, 0);
	at[68] = 8.9500;
	points[69] = (1773.8268, 4986.2598, 472.4409);
	angles[69] = (0, 228.4933, 0);
	at[69] = 9.1000;
	points[70] = (1830.2638, 4943.0317, 472.4409);
	angles[70] = (0, 232.0123, 0);
	at[70] = 9.2000;
	points[71] = (1859.5984, 4923.3467, 472.4409);
	angles[71] = (0, 234.4274, 0);
	at[71] = 9.2500;
	points[72] = (1890.9055, 4907.4019, 472.4409);
	angles[72] = (0, 240.5876, 0);
	at[72] = 9.3000;
	points[73] = (1925.9803, 4906.2603, 472.4409);
	angles[73] = (0, 255.8800, 0);
	at[73] = 9.3500;
	points[74] = (1960.9725, 4912.9136, 472.4409);
	angles[74] = (0, 268.6542, 0);
	at[74] = 9.4000;
	points[75] = (2028.3542, 4935.4727, 472.4409);
	angles[75] = (0, 284.4355, 0);
	at[75] = 9.5000;
	points[76] = (2060.4844, 4950.9053, 472.4409);
	angles[76] = (0, 290.6802, 0);
	at[76] = 9.5500;
	points[77] = (2088.2913, 4971.1025, 472.4409);
	angles[77] = (0, 299.0265, 0);
	at[77] = 9.6000;
	points[78] = (2141.1104, 5019.0552, 472.4409);
	angles[78] = (0, 309.3919, 0);
	at[78] = 9.7000;
	points[79] = (2189.8228, 5070.8267, 472.4409);
	angles[79] = (0, 315.5820, 0);
	at[79] = 9.8000;
	points[80] = (2211.6731, 5099.0947, 472.4409);
	angles[80] = (0, 319.5524, 0);
	at[80] = 9.8500;
	points[81] = (2226.2834, 5129.9604, 472.3268);
	angles[81] = (0, 329.9122, 0);
	at[81] = 9.9000;
	points[82] = (2226.0315, 5165.5117, 467.8465);
	angles[82] = (0, 345.7833, 0);
	at[82] = 9.9500;
	points[83] = (2221.1968, 5200, 462.3386);
	angles[83] = (0, 356.8752, 0);
	at[83] = 10;
	points[84] = (2214.5435, 5234.6460, 457.4173);
	angles[84] = (0, 363.8982, 0);
	at[84] = 10.0500;
	points[85] = (2198.4568, 5303.7012, 452.7835);
	angles[85] = (0, 370.9974, 0);
	at[85] = 10.1500;
	points[86] = (2189.6812, 5337.8345, 455.4803);
	angles[86] = (0, 372.7280, 0);
	at[86] = 10.2000;
	points[87] = (2180.8701, 5370.9844, 465.2677);
	angles[87] = (0, 373.7700, 0);
	at[87] = 10.2500;
	points[88] = (2173.9409, 5396.4570, 485.2244);
	angles[88] = (0, 374.4601, 0);
	at[88] = 10.3000;
	points[89] = (2161.0513, 5439.8423, 541.0197);
	angles[89] = (0, 375.9410, 0);
	at[89] = 10.4000;
	points[90] = (2117.3071, 5576.8110, 744.3976);
	angles[90] = (0, 378.0749, 0);
	at[90] = 10.7500;
	points[91] = (2096.8071, 5637.7163, 830.3229);
	angles[91] = (0, 378.6528, 0);
	at[91] = 10.9000;
	points[92] = (2081.4568, 5681.5747, 884.0945);
	angles[92] = (0, 379.2480, 0);
	at[92] = 11;
	points[93] = (2068.8308, 5715.7480, 914.4843);
	angles[93] = (0, 380.1035, 0);
	at[93] = 11.0667;
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
	points[0] = (715.1063, 2888.1497, 915.9016);
	angles[0] = (0, -91.2749, 0);
	at[0] = 0;
	points[1] = (748.8307, 2887.0120, 924.6653);
	angles[1] = (0, -91.6637, 0);
	at[1] = 0.0500;
	points[2] = (782.9606, 2885.7363, 928.5472);
	angles[2] = (0, -91.9189, 0);
	at[2] = 0.1000;
	points[3] = (854.3347, 2882.9331, 931.0276);
	angles[3] = (0, -92.1807, 0);
	at[3] = 0.2000;
	points[4] = (997.1299, 2877.0867, 927.2402);
	angles[4] = (0, -92.3490, 0);
	at[4] = 0.4000;
	points[5] = (1281.6771, 2865.1416, 912.0276);
	angles[5] = (0, -92.4117, 0);
	at[5] = 0.8000;
	points[6] = (1352.1890, 2862.1851, 911.0787);
	angles[6] = (0, -92.3986, 0);
	at[6] = 0.9000;
	points[7] = (1388.3149, 2860.7048, 913.9843);
	angles[7] = (0, -92.3629, 0);
	at[7] = 0.9500;
	points[8] = (1417.8976, 2859.5984, 928.5984);
	angles[8] = (0, -92.2345, 0);
	at[8] = 1;
	points[9] = (1438.1024, 2858.9883, 957.3898);
	angles[9] = (0, -92.0330, 0);
	at[9] = 1.0500;
	points[10] = (1449.6063, 2858.7639, 991.1024);
	angles[10] = (0, -91.7601, 0);
	at[10] = 1.1000;
	points[11] = (1456.2598, 2858.7402, 1025.9646);
	angles[11] = (0, -91.3761, 0);
	at[11] = 1.1500;
	points[12] = (1463.8583, 2858.8857, 1096.3898);
	angles[12] = (0, -90.3413, 0);
	at[12] = 1.2500;
	points[13] = (1470.5591, 2858.7559, 1131.0630);
	angles[13] = (0, -91.1632, 0);
	at[13] = 1.3000;
	points[14] = (1535.1693, 2855.2717, 1257.3661);
	angles[14] = (0, -93.1832, 0);
	at[14] = 1.5000;
	points[15] = (1556.3464, 2853.9214, 1285.0709);
	angles[15] = (0, -93.5719, 0);
	at[15] = 1.5500;
	points[16] = (1588.0906, 2851.4841, 1300.5906);
	angles[16] = (0, -94.0772, 0);
	at[16] = 1.6000;
	points[17] = (1622.4646, 2849.0828, 1308.0708);
	angles[17] = (0, -93.7416, 0);
	at[17] = 1.6500;
	points[18] = (1657.4922, 2848.4214, 1304.2717);
	angles[18] = (0, -92.2649, 0);
	at[18] = 1.7000;
	points[19] = (1684.4292, 2848.2046, 1282.5355);
	angles[19] = (0, -91.5758, 0);
	at[19] = 1.7500;
	points[20] = (1698.2047, 2848.1692, 1250.5591);
	angles[20] = (0, -91.1683, 0);
	at[20] = 1.8000;
	points[21] = (1733.6102, 2848.2561, 1149.5669);
	angles[21] = (0, -90.2369, 0);
	at[21] = 1.9500;
	points[22] = (1775.7520, 2847.9331, 1013.9921);
	angles[22] = (0, -90.7667, 0);
	at[22] = 2.1500;
	points[23] = (1791.5630, 2847.1970, 945.8819);
	angles[23] = (0, -92.2954, 0);
	at[23] = 2.2500;
	points[24] = (1830.9331, 2844.1182, 700.1182);
	angles[24] = (0, -94.9667, 0);
	at[24] = 2.6000;
	points[25] = (1857.8427, 2841.3545, 559.9645);
	angles[25] = (0, -96.0766, 0);
	at[25] = 2.8000;
	points[26] = (1877.4843, 2838.9604, 492.2047);
	angles[26] = (0, -96.9516, 0);
	at[26] = 2.9000;
	points[27] = (1896.4961, 2836.3857, 464.8150);
	angles[27] = (0, -97.4385, 0);
	at[27] = 2.9500;
	points[28] = (1930.0631, 2832.2441, 453.1221);
	angles[28] = (0, -97.1348, 0);
	at[28] = 3;
	points[29] = (2000.3464, 2823.5591, 450.2834);
	angles[29] = (0, -97.1217, 0);
	at[29] = 3.1000;
	points[30] = (2070.4961, 2814.0986, 456.3858);
	angles[30] = (0, -97.6670, 0);
	at[30] = 3.2000;
	points[31] = (2174.4448, 2795.5708, 470.7480);
	angles[31] = (0, -100.9900, 0);
	at[31] = 3.3500;
	points[32] = (2205.8230, 2781.1023, 472.4409);
	angles[32] = (0, -110.7590, 0);
	at[32] = 3.4000;
	points[33] = (2228.2993, 2753.8740, 472.4409);
	angles[33] = (0, -126.6387, 0);
	at[33] = 3.4500;
	points[34] = (2245.2126, 2722.6299, 472.4409);
	angles[34] = (0, -139.4542, 0);
	at[34] = 3.5000;
	points[35] = (2269.3308, 2655.8269, 472.4409);
	angles[35] = (0, -156.1890, 0);
	at[35] = 3.6000;
	points[36] = (2274.3506, 2621.2285, 472.4409);
	angles[36] = (0, -164.5368, 0);
	at[36] = 3.6500;
	points[37] = (2277.7402, 2550.2600, 472.4409);
	angles[37] = (0, -174.4634, 0);
	at[37] = 3.7500;
	points[38] = (2276.1614, 2479.0396, 472.4409);
	angles[38] = (0, -180.2482, 0);
	at[38] = 3.8500;
	points[39] = (2271.0393, 2445.0315, 472.4409);
	angles[39] = (0, -185.3058, 0);
	at[39] = 3.9000;
	points[40] = (2239.9370, 2342.8071, 472.4409);
	angles[40] = (0, -196.4214, 0);
	at[40] = 4.0500;
	points[41] = (2212.8110, 2277.0237, 472.4409);
	angles[41] = (0, -201.7772, 0);
	at[41] = 4.1500;
	points[42] = (2194.8347, 2246.2441, 472.4409);
	angles[42] = (0, -207.1354, 0);
	at[42] = 4.2000;
	points[43] = (2169.3506, 2223.5315, 472.4409);
	angles[43] = (0, -219.1321, 0);
	at[43] = 4.2500;
	points[44] = (2139.1221, 2204.7676, 472.4409);
	angles[44] = (0, -228.8154, 0);
	at[44] = 4.3000;
	points[45] = (2043.9291, 2156.5039, 472.4409);
	angles[45] = (0, -242.1113, 0);
	at[45] = 4.4500;
	points[46] = (1978.3268, 2128.9529, 472.4409);
	angles[46] = (0, -246.4306, 0);
	at[46] = 4.5500;
	points[47] = (1944.3898, 2117.4805, 472.4409);
	angles[47] = (0, -249.3680, 0);
	at[47] = 4.6000;
	points[48] = (1910.8229, 2110.8621, 472.4409);
	angles[48] = (0, -254.7167, 0);
	at[48] = 4.6500;
	points[49] = (1840.1458, 2104.1772, 472.4409);
	angles[49] = (0, -262.5162, 0);
	at[49] = 4.7500;
	points[50] = (1698.0039, 2098.5789, 472.4409);
	angles[50] = (0, -267.9267, 0);
	at[50] = 4.9500;
	points[51] = (1594.0985, 2097.8032, 472.4409);
	angles[51] = (0, -269.6729, 0);
	at[51] = 5.1000;
	points[52] = (1486.8938, 2099.7795, 472.4409);
	angles[52] = (0, -270.9893, 0);
	at[52] = 5.2500;
	points[53] = (988.4489, 2115.5039, 472.4409);
	angles[53] = (0, -272.2758, 0);
	at[53] = 5.9500;
	points[54] = (884.9370, 2120.7952, 472.4409);
	angles[54] = (0, -272.9228, 0);
	at[54] = 6.1000;
	points[55] = (635.9921, 2135.7480, 472.4409);
	angles[55] = (0, -273.6970, 0);
	at[55] = 6.4500;
	points[56] = (388.8394, 2157.4607, 472.4409);
	angles[56] = (0, -276.2551, 0);
	at[56] = 6.8000;
	points[57] = (353.3469, 2163.0117, 472.4409);
	angles[57] = (0, -277.9791, 0);
	at[57] = 6.8500;
	points[58] = (286.0449, 2181.5435, 472.4409);
	angles[58] = (0, -284.2852, 0);
	at[58] = 6.9500;
	points[59] = (153.1681, 2231.8938, 472.4409);
	angles[59] = (0, -291.2675, 0);
	at[59] = 7.1500;
	points[60] = (24.0517, 2291.8032, 472.4409);
	angles[60] = (0, -295.8317, 0);
	at[60] = 7.3500;
	points[61] = (-7.1569, 2309.7915, 472.4409);
	angles[61] = (0, -298.4313, 0);
	at[61] = 7.4000;
	points[62] = (-31.7485, 2332.9016, 472.4409);
	angles[62] = (0, -307.6284, 0);
	at[62] = 7.4500;
	points[63] = (-49.8787, 2363.5315, 472.4409);
	angles[63] = (0, -319.1899, 0);
	at[63] = 7.5000;
	points[64] = (-63.7709, 2396.1694, 472.4409);
	angles[64] = (0, -328.3663, 0);
	at[64] = 7.5500;
	points[65] = (-75.0949, 2429.8386, 472.4409);
	angles[65] = (0, -335.0934, 0);
	at[65] = 7.6000;
	points[66] = (-92.0453, 2499.0867, 472.4409);
	angles[66] = (0, -344.2484, 0);
	at[66] = 7.7000;
	points[67] = (-94.2228, 2533.7205, 472.4409);
	angles[67] = (0, -351.4218, 0);
	at[67] = 7.7500;
	points[68] = (-91.2992, 2569.0710, 472.4409);
	angles[68] = (0, -358.3495, 0);
	at[68] = 7.8000;
	points[69] = (-78.9839, 2639.1772, 472.4409);
	angles[69] = (0, -367.8723, 0);
	at[69] = 7.9000;
	points[70] = (-68.2185, 2672.5671, 472.4409);
	angles[70] = (0, -374.3429, 0);
	at[70] = 7.9500;
	points[71] = (-47.7783, 2701.1929, 472.4409);
	angles[71] = (0, -385.7463, 0);
	at[71] = 8;
	points[72] = (1.6545, 2752.3779, 472.4409);
	angles[72] = (0, -400.1569, 0);
	at[72] = 8.1000;
	points[73] = (28.7269, 2775.5002, 472.4409);
	angles[73] = (0, -405.2366, 0);
	at[73] = 8.1500;
	points[74] = (58.4039, 2794.0276, 472.4409);
	angles[74] = (0, -412.7640, 0);
	at[74] = 8.2000;
	points[75] = (123.8181, 2821.3228, 472.4409);
	angles[75] = (0, -424.0203, 0);
	at[75] = 8.3000;
	points[76] = (258.2531, 2868.5632, 472.4409);
	angles[76] = (0, -431.2338, 0);
	at[76] = 8.5000;
	points[77] = (291.5673, 2875.9451, 467.4843);
	angles[77] = (0, -434.8544, 0);
	at[77] = 8.5500;
	points[78] = (360.3787, 2884.6770, 452.9213);
	angles[78] = (0, -441.2392, 0);
	at[78] = 8.6500;
	points[79] = (395.1299, 2887.4370, 457.4213);
	angles[79] = (0, -443.4346, 0);
	at[79] = 8.7000;
	points[80] = (422.5945, 2888.8542, 476.6102);
	angles[80] = (0, -445.0677, 0);
	at[80] = 8.7500;
	points[81] = (460.9016, 2889.6812, 537.3976);
	angles[81] = (0, -447.3674, 0);
	at[81] = 8.8500;
	points[82] = (563.9252, 2890.1772, 724.2402);
	angles[82] = (0, -449.9119, 0);
	at[82] = 9.1500;
	points[83] = (619.9134, 2889.8542, 814.9095);
	angles[83] = (0, -450.3549, 0);
	at[83] = 9.3000;
	points[84] = (662.9960, 2889.3032, 872.2480);
	angles[84] = (0, -450.6985, 0);
	at[84] = 9.4000;
	points[85] = (687.3268, 2888.8464, 897.2126);
	angles[85] = (0, -450.9343, 0);
	at[85] = 9.4500;
	points[86] = (715.1063, 2888.1497, 915.9016);
	angles[86] = (0, -451.2750, 0);
	at[86] = 9.5000;
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
