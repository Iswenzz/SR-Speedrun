main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_choco_mountain", 0);

	setExpFog(0, 5237.6963, 0.9255, 1, 1, 0);

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
	ambientPlay("iz_0_trcm", 2);
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
	level.iz_route[level.iz_route.size] = (3278, -4308, 2185);
	level.iz_route[level.iz_route.size] = (3271, -4667, 2182);
	level.iz_route[level.iz_route.size] = (3271, -5262, 2155);
	level.iz_route[level.iz_route.size] = (3265, -5857, 2115);
	level.iz_route[level.iz_route.size] = (3194, -6446, 2084);
	level.iz_route[level.iz_route.size] = (2976, -7006, 2063);
	level.iz_route[level.iz_route.size] = (2682, -7518, 2058);
	level.iz_route[level.iz_route.size] = (2228, -7848, 2052);
	level.iz_route[level.iz_route.size] = (1668, -8043, 2038);
	level.iz_route[level.iz_route.size] = (1073, -8002, 2015);
	level.iz_route[level.iz_route.size] = (496, -7854, 1981);
	level.iz_route[level.iz_route.size] = (42, -7471, 1937);
	level.iz_route[level.iz_route.size] = (-323, -7006, 1898);
	level.iz_route[level.iz_route.size] = (-748, -6632, 1867);
	level.iz_route[level.iz_route.size] = (-1264, -6402, 1846);
	level.iz_route[level.iz_route.size] = (-1831, -6328, 1837);
	level.iz_route[level.iz_route.size] = (-2438, -6399, 1829);
	level.iz_route[level.iz_route.size] = (-3027, -6322, 1823);
	level.iz_route[level.iz_route.size] = (-3499, -6004, 1807);
	level.iz_route[level.iz_route.size] = (-3761, -5520, 1784);
	level.iz_route[level.iz_route.size] = (-3822, -4951, 1764);
	level.iz_route[level.iz_route.size] = (-3709, -4388, 1753);
	level.iz_route[level.iz_route.size] = (-3493, -3942, 1745);
	level.iz_route[level.iz_route.size] = (-3092, -3506, 1731);
	level.iz_route[level.iz_route.size] = (-2568, -3206, 1707);
	level.iz_route[level.iz_route.size] = (-1974, -3038, 1662);
	level.iz_route[level.iz_route.size] = (-1409, -2944, 1595);
	level.iz_route[level.iz_route.size] = (-817, -2885, 1497);
	level.iz_route[level.iz_route.size] = (-225, -2826, 1377);
	level.iz_route[level.iz_route.size] = (398, -2777, 1223);
	level.iz_route[level.iz_route.size] = (1021, -2718, 1073);
	level.iz_route[level.iz_route.size] = (1601, -2668, 969);
	level.iz_route[level.iz_route.size] = (2197, -2655, 904);
	level.iz_route[level.iz_route.size] = (2728, -2656, 900);
	level.iz_route[level.iz_route.size] = (3278, -2644, 924);
	level.iz_route[level.iz_route.size] = (4016, -2620, 995);
	level.iz_route[level.iz_route.size] = (4696, -2503, 1088);
	level.iz_route[level.iz_route.size] = (5271, -2195, 1181);
	level.iz_route[level.iz_route.size] = (5767, -1790, 1282);
	level.iz_route[level.iz_route.size] = (6156, -1260, 1373);
	level.iz_route[level.iz_route.size] = (6472, -671, 1457);
	level.iz_route[level.iz_route.size] = (6670, 35, 1540);
	level.iz_route[level.iz_route.size] = (6720, 714, 1605);
	level.iz_route[level.iz_route.size] = (6487, 1321, 1659);
	level.iz_route[level.iz_route.size] = (6141, 1788, 1708);
	level.iz_route[level.iz_route.size] = (5861, 2245, 1770);
	level.iz_route[level.iz_route.size] = (5665, 2712, 1838);
	level.iz_route[level.iz_route.size] = (5675, 3207, 1902);
	level.iz_route[level.iz_route.size] = (5777, 3683, 1960);
	level.iz_route[level.iz_route.size] = (6057, 4187, 2034);
	level.iz_route[level.iz_route.size] = (6244, 4906, 2155);
	level.iz_route[level.iz_route.size] = (6104, 5635, 2273);
	level.iz_route[level.iz_route.size] = (5600, 6176, 2350);
	level.iz_route[level.iz_route.size] = (5086, 6335, 2306);
	level.iz_route[level.iz_route.size] = (4386, 6587, 2200);
	level.iz_route[level.iz_route.size] = (3648, 6774, 2027);
	level.iz_route[level.iz_route.size] = (2892, 6858, 1876);
	level.iz_route[level.iz_route.size] = (1781, 6951, 1890);
	level.iz_route[level.iz_route.size] = (302, 7066, 1707);
	level.iz_route[level.iz_route.size] = (-554, 7101, 1515);
	level.iz_route[level.iz_route.size] = (-1375, 7119, 1343);
	level.iz_route[level.iz_route.size] = (-2113, 7054, 1277);
	level.iz_route[level.iz_route.size] = (-2851, 6942, 1290);
	level.iz_route[level.iz_route.size] = (-3569, 6755, 1302);
	level.iz_route[level.iz_route.size] = (-4298, 6466, 1301);
	level.iz_route[level.iz_route.size] = (-4923, 6064, 1305);
	level.iz_route[level.iz_route.size] = (-5502, 5495, 1322);
	level.iz_route[level.iz_route.size] = (-5923, 4869, 1345);
	level.iz_route[level.iz_route.size] = (-6305, 4206, 1380);
	level.iz_route[level.iz_route.size] = (-6539, 3496, 1416);
	level.iz_route[level.iz_route.size] = (-6585, 2759, 1454);
	level.iz_route[level.iz_route.size] = (-6520, 2021, 1517);
	level.iz_route[level.iz_route.size] = (-6137, 1386, 1596);
	level.iz_route[level.iz_route.size] = (-5456, 994, 1693);
	level.iz_route[level.iz_route.size] = (-4778, 951, 1777);
	level.iz_route[level.iz_route.size] = (-4183, 1129, 1857);
	level.iz_route[level.iz_route.size] = (-3697, 1621, 1910);
	level.iz_route[level.iz_route.size] = (-3510, 2329, 1920);
	level.iz_route[level.iz_route.size] = (-3651, 3067, 1928);
	level.iz_route[level.iz_route.size] = (-3870, 3744, 1976);
	level.iz_route[level.iz_route.size] = (-3811, 4329, 2021);
	level.iz_route[level.iz_route.size] = (-3590, 4834, 2065);
	level.iz_route[level.iz_route.size] = (-3121, 5224, 2122);
	level.iz_route[level.iz_route.size] = (-2356, 5495, 2192);
	level.iz_route[level.iz_route.size] = (-1553, 5644, 2259);
	level.iz_route[level.iz_route.size] = (-619, 5737, 2341);
	level.iz_route[level.iz_route.size] = (165, 5784, 2438);
	level.iz_route[level.iz_route.size] = (884, 5775, 2555);
	level.iz_route[level.iz_route.size] = (1538, 5747, 2680);
	level.iz_route[level.iz_route.size] = (2304, 5653, 2857);
	level.iz_route[level.iz_route.size] = (3032, 5327, 2990);
	level.iz_route[level.iz_route.size] = (3546, 4776, 2998);
	level.iz_route[level.iz_route.size] = (3723, 3982, 2870);
	level.iz_route[level.iz_route.size] = (3658, 3263, 2717);
	level.iz_route[level.iz_route.size] = (3508, 2535, 2609);
	level.iz_route[level.iz_route.size] = (3396, 1993, 2554);
	level.iz_route[level.iz_route.size] = (3331, 1452, 2553);
	level.iz_route[level.iz_route.size] = (3284, 957, 2699);
	level.iz_route[level.iz_route.size] = (3247, 191, 2490);
	level.iz_route[level.iz_route.size] = (3256, -481, 2442);
	level.iz_route[level.iz_route.size] = (3284, -1051, 2533);
	level.iz_route[level.iz_route.size] = (3303, -1910, 2455);
	level.iz_route[level.iz_route.size] = (3294, -2993, 2251);
	level.iz_route[level.iz_route.size] = (3270, -3742, 2185);
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
	points[0] = (3686.0120, 8087.3228, 2625.7834);
	angles[0] = (0, 109.4852, 0);
	at[0] = 0;
	points[1] = (3237.3857, 7933.8584, 2510.4766);
	angles[1] = (0, 109.3304, 0);
	at[1] = 0.5000;
	points[2] = (3058.8267, 7867.2441, 2464.1614);
	angles[2] = (0, 113.1023, 0);
	at[2] = 0.7000;
	points[3] = (2976.6143, 7824.7246, 2442.4568);
	angles[3] = (0, 120.3004, 0);
	at[3] = 0.8000;
	points[4] = (2895.7993, 7774.1733, 2421.1260);
	angles[4] = (0, 123.5408, 0);
	at[4] = 0.9000;
	points[5] = (2817.8347, 7719.5278, 2399.8662);
	angles[5] = (0, 126.6898, 0);
	at[5] = 1;
	points[6] = (2743.9133, 7659.1343, 2377.7915);
	angles[6] = (0, 132.9854, 0);
	at[6] = 1.1000;
	points[7] = (2694.2324, 7582.4409, 2352.6023);
	angles[7] = (0, 162.8122, 0);
	at[7] = 1.2000;
	points[8] = (2674.8032, 7490.5513, 2325.1104);
	angles[8] = (0, 171.8943, 0);
	at[8] = 1.3000;
	points[9] = (2666.5081, 7396.7720, 2298.4724);
	angles[9] = (0, 178.1785, 0);
	at[9] = 1.4000;
	points[10] = (2672.8071, 7302.2046, 2274.3308);
	angles[10] = (0, 193.8086, 0);
	at[10] = 1.5000;
	points[11] = (2718.5828, 7219.6855, 2260.8740);
	angles[11] = (0, 215.3575, 0);
	at[11] = 1.6000;
	points[12] = (2778.0474, 7142.4805, 2251.1890);
	angles[12] = (0, 219.3863, 0);
	at[12] = 1.7000;
	points[13] = (2841.9373, 7068.6221, 2243.6812);
	angles[13] = (0, 222.3502, 0);
	at[13] = 1.8000;
	points[14] = (2910.1929, 6998.5039, 2239.0630);
	angles[14] = (0, 226.6534, 0);
	at[14] = 1.9000;
	points[15] = (2985.6536, 6939.1338, 2242.0825);
	angles[15] = (0, 236.7066, 0);
	at[15] = 2;
	points[16] = (3067.6812, 6888.3071, 2251.9607);
	angles[16] = (0, 239.2876, 0);
	at[16] = 2.1000;
	points[17] = (3236.9292, 6792.8740, 2275.7126);
	angles[17] = (0, 241.7571, 0);
	at[17] = 2.3000;
	points[18] = (3409.9292, 6705.5513, 2301.5630);
	angles[18] = (0, 245.2133, 0);
	at[18] = 2.5000;
	points[19] = (3498.3623, 6668.9375, 2314.9490);
	angles[19] = (0, 251.3661, 0);
	at[19] = 2.6000;
	points[20] = (3590.2166, 6644.8818, 2329.1575);
	angles[20] = (0, 257.4107, 0);
	at[20] = 2.7000;
	points[21] = (3780.4331, 6607.4805, 2359.3071);
	angles[21] = (0, 259.7714, 0);
	at[21] = 2.9000;
	points[22] = (4161.5747, 6542.0869, 2420.3149);
	angles[22] = (0, 260.1004, 0);
	at[22] = 3.3000;
	points[23] = (4252.9136, 6525.1973, 2434.9214);
	angles[23] = (0, 259.1497, 0);
	at[23] = 3.4000;
	points[24] = (4633.0708, 6456.5356, 2499.7637);
	angles[24] = (0, 259.2965, 0);
	at[24] = 3.8000;
	points[25] = (4822.7168, 6417.9531, 2530.2754);
	angles[25] = (0, 257.3548, 0);
	at[25] = 4;
	points[26] = (4916.4175, 6395, 2543.5276);
	angles[26] = (0, 254.6993, 0);
	at[26] = 4.1000;
	points[27] = (5005.1973, 6364.6851, 2551.9370);
	angles[27] = (0, 247.0060, 0);
	at[27] = 4.2000;
	points[28] = (5095.1577, 6323.1099, 2554.3149);
	angles[28] = (0, 243.9103, 0);
	at[28] = 4.3000;
	points[29] = (5267.9927, 6232.8345, 2553.5195);
	angles[29] = (0, 241.1482, 0);
	at[29] = 4.5000;
	points[30] = (5437.2832, 6134.5278, 2549.2520);
	angles[30] = (0, 238.3467, 0);
	at[30] = 4.7000;
	points[31] = (5519.3306, 6081.7720, 2546.0120);
	angles[31] = (0, 235.9794, 0);
	at[31] = 4.8000;
	points[32] = (5598.3467, 6023.8584, 2541.6260);
	angles[32] = (0, 230.4936, 0);
	at[32] = 4.9000;
	points[33] = (5663.4253, 5954.9604, 2534.3230);
	angles[33] = (0, 217.5592, 0);
	at[33] = 5;
	points[34] = (5718.9370, 5876.2603, 2523.9448);
	angles[34] = (0, 213.4232, 0);
	at[34] = 5.1000;
	points[35] = (5770.8662, 5793.9370, 2512.4922);
	angles[35] = (0, 211.2418, 0);
	at[35] = 5.2000;
	points[36] = (5866.9292, 5625.1572, 2488.4292);
	angles[36] = (0, 208.1268, 0);
	at[36] = 5.4000;
	points[37] = (5952.8740, 5451.1021, 2463.8071);
	angles[37] = (0, 203.8375, 0);
	at[37] = 5.6000;
	points[38] = (5987.9526, 5360.6689, 2451.7915);
	angles[38] = (0, 196.9791, 0);
	at[38] = 5.7000;
	points[39] = (6005.4331, 5268.5044, 2441.4016);
	angles[39] = (0, 187.0268, 0);
	at[39] = 5.8000;
	points[40] = (6014.4883, 5171.0234, 2431.2087);
	angles[40] = (0, 183.9508, 0);
	at[40] = 5.9000;
	points[41] = (6022.4409, 4976.6533, 2411.3545);
	angles[41] = (0, 181.0716, 0);
	at[41] = 6.1000;
	points[42] = (6022.5195, 4782.0474, 2391.1536);
	angles[42] = (0, 178.9411, 0);
	at[42] = 6.3000;
	points[43] = (6019.5273, 4684.4097, 2380.4685);
	angles[43] = (0, 177.4165, 0);
	at[43] = 6.4000;
	points[44] = (6012.8345, 4590.9448, 2369.0237);
	angles[44] = (0, 173.2296, 0);
	at[44] = 6.5000;
	points[45] = (5997.3618, 4495.5513, 2354.8071);
	angles[45] = (0, 169.2642, 0);
	at[45] = 6.6000;
	points[46] = (5956.8110, 4306.2993, 2324.3506);
	angles[46] = (0, 166.9360, 0);
	at[46] = 6.8000;
	points[47] = (5910.9849, 4118.8584, 2293.3584);
	angles[47] = (0, 165.5942, 0);
	at[47] = 7;
	points[48] = (5860.1182, 3932.0630, 2262.5708);
	angles[48] = (0, 163.6557, 0);
	at[48] = 7.2000;
	points[49] = (5831.6143, 3843.4802, 2248.6575);
	angles[49] = (0, 158.7887, 0);
	at[49] = 7.3000;
	points[50] = (5791.1807, 3753.9724, 2235.1851);
	angles[50] = (0, 153.8576, 0);
	at[50] = 7.4000;
	points[51] = (5747.7168, 3668.2795, 2222.4370);
	angles[51] = (0, 152.5880, 0);
	at[51] = 7.5000;
	points[52] = (5614.8428, 3409.5315, 2185.2363);
	angles[52] = (0, 154.2588, 0);
	at[52] = 7.8000;
	points[53] = (5574.7637, 3321.1143, 2173.3149);
	angles[53] = (0, 157.4209, 0);
	at[53] = 7.9000;
	points[54] = (5543.9370, 3229.5042, 2162.1101);
	angles[54] = (0, 168.2142, 0);
	at[54] = 8;
	points[55] = (5536.1025, 3135.2913, 2153.2007);
	angles[55] = (0, 178.9783, 0);
	at[55] = 8.1000;
	points[56] = (5537.1655, 3037.0549, 2145.0315);
	angles[56] = (0, 181.8611, 0);
	at[56] = 8.2000;
	points[57] = (5547.9526, 2842.5039, 2129.9133);
	angles[57] = (0, 184.0927, 0);
	at[57] = 8.4000;
	points[58] = (5633.7798, 1776.7953, 2051.1260);
	angles[58] = (0, 183.9680, 0);
	at[58] = 9.5000;
	points[59] = (5639.1338, 1682.0040, 2042.0433);
	angles[59] = (0, 182.4987, 0);
	at[59] = 9.6000;
	points[60] = (5648.9370, 1390.1378, 2009.0433);
	angles[60] = (0, 181.6408, 0);
	at[60] = 9.9000;
	points[61] = (5659.0552, 1001.6299, 1960.5197);
	angles[61] = (0, 181.3682, 0);
	at[61] = 10.3000;
	points[62] = (5661.1816, 908.4173, 1946.8898);
	angles[62] = (0, 181.1135, 0);
	at[62] = 10.4000;
	points[63] = (5666.9683, 332.0539, 1834.8464);
	angles[63] = (0, 181.0898, 0);
	at[63] = 11;
	points[64] = (5669.3701, 235.8921, 1816.0197);
	angles[64] = (0, 181.8923, 0);
	at[64] = 11.1000;
	points[65] = (5674.0552, 143.4358, 1799.0551);
	angles[65] = (0, 184.5212, 0);
	at[65] = 11.2000;
	points[66] = (5706.2207, -145.2413, 1753.5237);
	angles[66] = (0, 187.1143, 0);
	at[66] = 11.5000;
	points[67] = (5756.4961, -529.3071, 1695.2716);
	angles[67] = (0, 187.6926, 0);
	at[67] = 11.9000;
	points[68] = (5769.1338, -621.8976, 1680.9055);
	angles[68] = (0, 188.6662, 0);
	at[68] = 12;
	points[69] = (5824.2524, -906.3701, 1634.5039);
	angles[69] = (0, 190.5223, 0);
	at[69] = 12.3000;
	points[70] = (5840.1572, -1001.0788, 1618.8859);
	angles[70] = (0, 188.2486, 0);
	at[70] = 12.4000;
	points[71] = (5850.1572, -1097.2560, 1603.0118);
	angles[71] = (0, 182.6336, 0);
	at[71] = 12.5000;
	points[72] = (5843.6221, -1191.7875, 1587.4922);
	angles[72] = (0, 170.6257, 0);
	at[72] = 12.6000;
	points[73] = (5803.6611, -1379.8464, 1556.9135);
	angles[73] = (0, 166.3713, 0);
	at[73] = 12.8000;
	points[74] = (5754.4097, -1566.9489, 1526.3938);
	angles[74] = (0, 164.1338, 0);
	at[74] = 13;
	points[75] = (5697.0474, -1750.6497, 1496.0669);
	angles[75] = (0, 160.6909, 0);
	at[75] = 13.2000;
	points[76] = (5661.2993, -1842.1261, 1480.5708);
	angles[76] = (0, 155.6158, 0);
	at[76] = 13.3000;
	points[77] = (5615.3545, -1922.9961, 1466.2086);
	angles[77] = (0, 146.9329, 0);
	at[77] = 13.4000;
	points[78] = (5560.7876, -2002.2126, 1451.9174);
	angles[78] = (0, 144.2839, 0);
	at[78] = 13.5000;
	points[79] = (5503.0708, -2080.0984, 1437.6969);
	angles[79] = (0, 142.7181, 0);
	at[79] = 13.6000;
	points[80] = (5382.2046, -2231.7046, 1409.3937);
	angles[80] = (0, 140.1646, 0);
	at[80] = 13.8000;
	points[81] = (5253.9766, -2376.7913, 1380.9172);
	angles[81] = (0, 136.4096, 0);
	at[81] = 14;
	points[82] = (5186.0239, -2443.5828, 1366.5985);
	angles[82] = (0, 131.8845, 0);
	at[82] = 14.1000;
	points[83] = (5108.7798, -2498.2244, 1351.7954);
	angles[83] = (0, 117.6827, 0);
	at[83] = 14.2000;
	points[84] = (5020.5513, -2538.0039, 1336.7362);
	angles[84] = (0, 111.8891, 0);
	at[84] = 14.3000;
	points[85] = (4838.4253, -2602.3977, 1307.1063);
	angles[85] = (0, 107.6856, 0);
	at[85] = 14.5000;
	points[86] = (4652.7168, -2657.1379, 1277.6062);
	angles[86] = (0, 105.2257, 0);
	at[86] = 14.7000;
	points[87] = (4559.1733, -2681.4844, 1262.8622);
	angles[87] = (0, 103.8964, 0);
	at[87] = 14.8000;
	points[88] = (4466.0234, -2702.9331, 1248.1890);
	angles[88] = (0, 101.7803, 0);
	at[88] = 14.9000;
	points[89] = (4372.2837, -2717.5828, 1233.2245);
	angles[89] = (0, 95.1794, 0);
	at[89] = 15;
	points[90] = (4276.1416, -2723.1221, 1217.5513);
	angles[90] = (0, 91.9639, 0);
	at[90] = 15.1000;
	points[91] = (3986.5750, -2723.8779, 1170.6063);
	angles[91] = (0, 88.9367, 0);
	at[91] = 15.4000;
	points[92] = (3696.1497, -2714.2087, 1126.4213);
	angles[92] = (0, 87.1341, 0);
	at[92] = 15.7000;
	points[93] = (3506.2717, -2697.8662, 1102.3701);
	angles[93] = (0, 83.7742, 0);
	at[93] = 15.9000;
	points[94] = (3023.8306, -2641.8110, 1048.2992);
	angles[94] = (0, 83.5947, 0);
	at[94] = 16.4000;
	points[95] = (2830.2913, -2622.2520, 1034.1851);
	angles[95] = (0, 85.3955, 0);
	at[95] = 16.6000;
	points[96] = (2735.4844, -2617.5828, 1035.7402);
	angles[96] = (0, 88.9487, 0);
	at[96] = 16.7000;
	points[97] = (2637.3267, -2617.1025, 1047.1812);
	angles[97] = (0, 90.2910, 0);
	at[97] = 16.8000;
	points[98] = (2444.7874, -2620.3743, 1078.6299);
	angles[98] = (0, 91.5509, 0);
	at[98] = 17;
	points[99] = (2252.4961, -2627.4409, 1115.0867);
	angles[99] = (0, 92.7243, 0);
	at[99] = 17.2000;
	points[100] = (2062.4133, -2640.1772, 1153.5591);
	angles[100] = (0, 95.7742, 0);
	at[100] = 17.4000;
	points[101] = (1969.2717, -2657.0593, 1172.5826);
	angles[101] = (0, 106.1009, 0);
	at[101] = 17.5000;
	points[102] = (1878.8544, -2688.5669, 1192.0276);
	angles[102] = (0, 111.5080, 0);
	at[102] = 17.6000;
	points[103] = (1790.9844, -2725.8152, 1212.3110);
	angles[103] = (0, 114.2226, 0);
	at[103] = 17.7000;
	points[104] = (1704.7875, -2766.4448, 1234.2834);
	angles[104] = (0, 116.2114, 0);
	at[104] = 17.8000;
	points[105] = (1621.1615, -2809.6182, 1260.4449);
	angles[105] = (0, 118.7419, 0);
	at[105] = 17.9000;
	points[106] = (1549.6732, -2856.9016, 1303.9015);
	angles[106] = (0, 128.0162, 0);
	at[106] = 18;
	points[107] = (1488.7284, -2909.1770, 1359.6654);
	angles[107] = (0, 133.0446, 0);
	at[107] = 18.1000;
	points[108] = (1436.1102, -2962.9409, 1421.7954);
	angles[108] = (0, 138.7341, 0);
	at[108] = 18.2000;
	points[109] = (1397.7245, -3016.0117, 1490.9645);
	angles[109] = (0, 150.5352, 0);
	at[109] = 18.3000;
	points[110] = (1345.5001, -3121.3069, 1648.3032);
	angles[110] = (0, 155.7369, 0);
	at[110] = 18.5000;
	points[111] = (1302.3071, -3226.4802, 1807.3031);
	angles[111] = (0, 159.8960, 0);
	at[111] = 18.7000;
	points[112] = (1284.3308, -3280.0159, 1887.1653);
	angles[112] = (0, 163.2489, 0);
	at[112] = 18.8000;
	points[113] = (1270.7166, -3334.4922, 1966.5159);
	angles[113] = (0, 169.5087, 0);
	at[113] = 18.9000;
	points[114] = (1266.6417, -3389.9919, 2042.9843);
	angles[114] = (0, 181.5445, 0);
	at[114] = 19;
	points[115] = (1270.5669, -3449.8071, 2122.1970);
	angles[115] = (0, 185.2266, 0);
	at[115] = 19.1000;
	points[116] = (1292.1260, -3627.0789, 2353.4370);
	angles[116] = (0, 187.9223, 0);
	at[116] = 19.4000;
	points[117] = (1343.7834, -3984.1731, 2816.3506);
	angles[117] = (0, 187.3413, 0);
	at[117] = 20;
	points[118] = (1343.7834, -3984.1731, 2816.3506);
	angles[118] = (0, 187.3413, 0);
	at[118] = 20.0167;
	points[119] = (3686.0120, 8087.3228, 2625.7834);
	angles[119] = (0, 109.4852, 0);
	at[119] = 20.0167;
	points[120] = (3686.0120, 8087.3228, 2625.7834);
	angles[120] = (0, 109.4852, 0);
	at[120] = 20.0333;
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
	points[0] = (-5944.8423, 3890.1260, 1444.8542);
	angles[0] = (0, -117.5127, -158.9092);
	at[0] = 0;
	points[1] = (-5924.1733, 3879.3542, 1424.4133);
	angles[1] = (0, -117.5126, -27.1864);
	at[1] = 0.0500;
	points[2] = (-5903.5044, 3868.5828, 1398.6536);
	angles[2] = (0, -117.5126, 104.5361);
	at[2] = 0.1000;
	points[3] = (-5882.7954, 3857.8113, 1367.5826);
	angles[3] = (0, -117.5127, 236.2587);
	at[3] = 0.1500;
	points[4] = (-5862.1260, 3847.0393, 1331.1969);
	angles[4] = (0, -117.5126, 367.9813);
	at[4] = 0.2000;
	points[5] = (-5841.4570, 3836.2678, 1289.4922);
	angles[5] = (0, -117.5126, 499.7040);
	at[5] = 0.2500;
	points[6] = (-5820.7480, 3825.4922, 1242.4764);
	angles[6] = (0, -114.8726, 631.4265);
	at[6] = 0.3000;
	points[7] = (-5809.2915, 3820.3110, 1190.1456);
	angles[7] = (0, -114.8726, 763.1493);
	at[7] = 0.3500;
	points[8] = (-5796.8110, 3814.5393, 1132.4961);
	angles[8] = (0, -114.8726, 894.8718);
	at[8] = 0.4000;
	points[9] = (-5784.3701, 3808.7639, 1069.5355);
	angles[9] = (0, -114.8726, 1026.5944);
	at[9] = 0.4500;
	points[10] = (-5771.9292, 3802.9883, 1001.2598);
	angles[10] = (0, -114.8725, 1158.3170);
	at[10] = 0.5000;
	points[11] = (-5759.4487, 3797.2129, 927.6654);
	angles[11] = (0, -114.8725, 1290.0397);
	at[11] = 0.5500;
	points[12] = (-5747.0078, 3791.4370, 848.7599);
	angles[12] = (0, -114.8725, 1421.7623);
	at[12] = 0.6000;
	points[13] = (-5734.5273, 3785.6614, 764.5394);
	angles[13] = (0, -114.8726, 1553.4850);
	at[13] = 0.6500;
	points[14] = (-5722.0869, 3779.8860, 675.0039);
	angles[14] = (0, -114.8725, 1685.2076);
	at[14] = 0.7000;
	points[15] = (-5709.6064, 3774.1101, 580.1496);
	angles[15] = (0, -114.8726, 1816.9302);
	at[15] = 0.7500;
	points[16] = (-5697.1650, 3768.3386, 479.9843);
	angles[16] = (0, -114.8725, 1948.6528);
	at[16] = 0.8000;
	points[17] = (-5693.0312, 3766.4136, 445.4134);
	angles[17] = (0, -114.8726, 1872.5603);
	at[17] = 0.8333;
	points[18] = (-7538.9370, 4651.2598, 2174.8269);
	angles[18] = (0, -114.8726, 1872.5603);
	at[18] = 0.8333;
	points[19] = (-7538.9370, 4651.2598, 2174.8269);
	angles[19] = (0, -114.8726, 1872.5603);
	at[19] = 4.7500;
	points[20] = (-7521.6929, 4643.5435, 2282.8464);
	angles[20] = (0, -114.1082, 1926.8789);
	at[20] = 4.8000;
	points[21] = (-7495.8267, 4631.9688, 2283.3740);
	angles[21] = (0, -114.1082, 1905.5996);
	at[21] = 4.8500;
	points[22] = (-7470, 4620.4331, 2284.2756);
	angles[22] = (0, -114.1082, 1875.3218);
	at[22] = 4.9000;
	points[23] = (-7444.1338, 4608.8584, 2285.1812);
	angles[23] = (0, -114.1082, 1836.0430);
	at[23] = 4.9500;
	points[24] = (-7418.3071, 4597.2837, 2286.0828);
	angles[24] = (0, -114.1082, 1787.7626);
	at[24] = 5;
	points[25] = (-7392.4414, 4585.7085, 2286.9844);
	angles[25] = (0, -114.1082, 1730.4843);
	at[25] = 5.0500;
	points[26] = (-7366.6143, 4574.1338, 2287.8860);
	angles[26] = (0, -114.1082, 1664.2063);
	at[26] = 5.1000;
	points[27] = (-7340.7480, 4562.5986, 2288.7913);
	angles[27] = (0, -114.1081, 1588.9269);
	at[27] = 5.1500;
	points[28] = (-7314.9214, 4551.0239, 2289.6929);
	angles[28] = (0, -114.1081, 1504.6461);
	at[28] = 5.2000;
	points[29] = (-7289.0552, 4539.4487, 2290.5945);
	angles[29] = (0, -114.1082, 1411.3691);
	at[29] = 5.2500;
	points[30] = (-7263.2280, 4527.8740, 2291.4961);
	angles[30] = (0, -114.1082, 1309.0906);
	at[30] = 5.3000;
	points[31] = (-7237.3623, 4516.3384, 2292.4016);
	angles[31] = (0, -114.1083, 1197.8126);
	at[31] = 5.3500;
	points[32] = (-7211.5356, 4504.7637, 2291.2007);
	angles[32] = (0, -114.1081, 1080.5317);
	at[32] = 5.4000;
	points[33] = (-7185.6694, 4493.1890, 2284.5237);
	angles[33] = (0, -114.1082, 963.2511);
	at[33] = 5.4500;
	points[34] = (-7159.8428, 4481.6143, 2273.2324);
	angles[34] = (0, -114.1082, 844.9700);
	at[34] = 5.5000;
	points[35] = (-7133.9766, 4470.0396, 2273.8188);
	angles[35] = (0, -114.1082, 724.6888);
	at[35] = 5.5500;
	points[36] = (-7108.1494, 4458.5039, 2269.0906);
	angles[36] = (0, -117.9563, 604.4075);
	at[36] = 5.6000;
	points[37] = (-7096.4966, 4452.0869, 2259.0471);
	angles[37] = (0, -117.9563, 484.1262);
	at[37] = 5.6500;
	points[38] = (-7083.5435, 4445.2363, 2253.3308);
	angles[38] = (0, -117.9563, 361.8446);
	at[38] = 5.7000;
	points[39] = (-7070.6299, 4438.3467, 2252.6260);
	angles[39] = (0, -117.9563, 238.5628);
	at[39] = 5.7500;
	points[40] = (-7057.6772, 4431.4961, 2246.6025);
	angles[40] = (0, -117.9563, 115.2811);
	at[40] = 5.8000;
	points[41] = (-7044.7637, 4424.6460, 2241.6023);
	angles[41] = (0, -117.9563, -10);
	at[41] = 5.8500;
	points[42] = (-7031.8110, 4417.7559, 2239.6890);
	angles[42] = (0, -117.9563, -136.2831);
	at[42] = 5.9000;
	points[43] = (-7018.8584, 4410.9058, 2232.4607);
	angles[43] = (0, -117.9563, -262.5654);
	at[43] = 5.9500;
	points[44] = (-7005.9453, 4404.0156, 2231.3779);
	angles[44] = (0, -117.9564, -391.8481);
	at[44] = 6;
	points[45] = (-6992.9922, 4397.1655, 2227.5237);
	angles[45] = (0, -117.9563, -521.1308);
	at[45] = 6.0500;
	points[46] = (-6980.0791, 4390.3149, 2218.3503);
	angles[46] = (0, -117.9562, -650.4135);
	at[46] = 6.1000;
	points[47] = (-6967.1260, 4383.4253, 2203.8662);
	angles[47] = (0, -117.9563, -779.6962);
	at[47] = 6.1500;
	points[48] = (-6954.1733, 4376.5747, 2184.0669);
	angles[48] = (0, -117.9562, -908.9789);
	at[48] = 6.2000;
	points[49] = (-6941.2598, 4369.6851, 2158.9526);
	angles[49] = (0, -117.9563, -1038.2616);
	at[49] = 6.2500;
	points[50] = (-6928.3071, 4362.8350, 2128.5198);
	angles[50] = (0, -117.9563, -1167.5441);
	at[50] = 6.3000;
	points[51] = (-6915.3940, 4355.9844, 2092.7756);
	angles[51] = (0, -117.9562, -1296.8269);
	at[51] = 6.3500;
	points[52] = (-6902.4414, 4349.0947, 2051.7166);
	angles[52] = (0, -117.9564, -1426.1096);
	at[52] = 6.4000;
	points[53] = (-6889.4883, 4342.2441, 2005.3425);
	angles[53] = (0, -117.9563, -1555.3923);
	at[53] = 6.4500;
	points[54] = (-6876.5747, 4335.3540, 1953.6536);
	angles[54] = (0, -117.9563, -1684.6749);
	at[54] = 6.5000;
	points[55] = (-6863.6221, 4328.5039, 1896.6458);
	angles[55] = (0, -117.9563, -1813.9578);
	at[55] = 6.5500;
	points[56] = (-6850.7085, 4321.6533, 1834.3268);
	angles[56] = (0, -117.9562, -1943.2404);
	at[56] = 6.6000;
	points[57] = (-6837.7559, 4314.7637, 1766.6930);
	angles[57] = (0, -117.9563, -2072.5229);
	at[57] = 6.6500;
	points[58] = (-6824.8037, 4307.9136, 1693.7440);
	angles[58] = (0, -117.9563, -2201.8059);
	at[58] = 6.7000;
	points[59] = (-6811.8901, 4301.0239, 1615.4803);
	angles[59] = (0, -117.9564, -2331.0886);
	at[59] = 6.7500;
	points[60] = (-6798.9370, 4294.1733, 1531.8976);
	angles[60] = (0, -117.9562, -2460.3713);
	at[60] = 6.8000;
	points[61] = (-6786.0239, 4287.3228, 1531.3268);
	angles[61] = (0, -117.9563, -2592.6545);
	at[61] = 6.8500;
	points[62] = (-6773.0708, 4280.4331, 1550.3781);
	angles[62] = (0, -117.9563, -2724.9375);
	at[62] = 6.9000;
	points[63] = (-6760.1182, 4273.5830, 1564.1104);
	angles[63] = (0, -117.9562, -2857.2207);
	at[63] = 6.9500;
	points[64] = (-6747.2046, 4266.6929, 1572.5315);
	angles[64] = (0, -117.9564, -2989.5039);
	at[64] = 7;
	points[65] = (-6734.2520, 4259.8423, 1575.6377);
	angles[65] = (0, -117.9563, -3121.7871);
	at[65] = 7.0500;
	points[66] = (-6721.3389, 4252.9922, 1573.4291);
	angles[66] = (0, -117.9563, -3254.0703);
	at[66] = 7.1000;
	points[67] = (-6708.3862, 4246.1025, 1565.9016);
	angles[67] = (0, -113.8735, -3386.3535);
	at[67] = 7.1500;
	points[68] = (-6678.8188, 4233.3467, 1553.0630);
	angles[68] = (0, -113.8735, -3518.6365);
	at[68] = 7.2000;
	points[69] = (-6652.9131, 4221.8896, 1534.9094);
	angles[69] = (0, -113.8735, -3650.9197);
	at[69] = 7.2500;
	points[70] = (-6627.0474, 4210.4331, 1511.4370);
	angles[70] = (0, -113.8734, -3783.2029);
	at[70] = 7.3000;
	points[71] = (-6601.1421, 4198.9766, 1510.3188);
	angles[71] = (0, -113.8735, -3918.4866);
	at[71] = 7.3500;
	points[72] = (-6575.2363, 4187.5195, 1511.3347);
	angles[72] = (0, -113.8735, -4053.7703);
	at[72] = 7.4000;
	points[73] = (-6549.3701, 4176.0630, 1507.0394);
	angles[73] = (0, -113.8734, -4189.0537);
	at[73] = 7.4500;
	points[74] = (-6523.4648, 4164.6064, 1502.2362);
	angles[74] = (0, -113.8734, -4326.3306);
	at[74] = 7.5000;
	points[75] = (-6497.5986, 4153.1494, 1500.0040);
	angles[75] = (0, -113.8735, -4465.6045);
	at[75] = 7.5500;
	points[76] = (-6471.6929, 4141.6929, 1498.7125);
	angles[76] = (0, -113.8734, -4608.8789);
	at[76] = 7.6000;
	points[77] = (-6445.7876, 4130.2363, 1497.2126);
	angles[77] = (0, -113.8735, -4757.1543);
	at[77] = 7.6500;
	points[78] = (-6419.9209, 4118.7793, 1495.9646);
	angles[78] = (0, -113.8734, -4909.4302);
	at[78] = 7.7000;
	points[79] = (-6394.0161, 4107.3228, 1494.4214);
	angles[79] = (0, -113.8735, -5066.7065);
	at[79] = 7.7500;
	points[80] = (-6368.1499, 4095.8267, 1493.1733);
	angles[80] = (0, -113.8734, -5227.9839);
	at[80] = 7.8000;
	points[81] = (-6342.4019, 4084.0552, 1491.6497);
	angles[81] = (0, -115.3224, -5394.2622);
	at[81] = 7.8500;
	points[82] = (-6316.8115, 4071.9685, 1490.3976);
	angles[82] = (0, -115.3224, -5564.5405);
	at[82] = 7.9000;
	points[83] = (-6291.2202, 4059.8428, 1488.5787);
	angles[83] = (0, -115.3223, -5739.8203);
	at[83] = 7.9500;
	points[84] = (-6265.5903, 4047.7166, 1487.2755);
	angles[84] = (0, -115.3224, -5919.1001);
	at[84] = 8;
	points[85] = (-6240, 4035.6299, 1485.7284);
	angles[85] = (0, -115.3224, -5743.3813);
	at[85] = 8.0500;
	points[86] = (-6214.4092, 4023.5039, 1484.5118);
	angles[86] = (0, -115.3223, -5571.6626);
	at[86] = 8.1000;
	points[87] = (-6188.8188, 4011.3779, 1483.1536);
	angles[87] = (0, -115.3224, -5404.9453);
	at[87] = 8.1500;
	points[88] = (-6163.2285, 3999.2915, 1481.9961);
	angles[88] = (0, -115.3224, -5242.2280);
	at[88] = 8.2000;
	points[89] = (-6137.6377, 3987.1655, 1480.6378);
	angles[89] = (0, -115.3224, -5084.5117);
	at[89] = 8.2500;
	points[90] = (-6112.0474, 3975.0789, 1479.4803);
	angles[90] = (0, -115.3223, -4930.7891);
	at[90] = 8.3000;
	points[91] = (-6086.4565, 3962.9526, 1478.1221);
	angles[91] = (0, -115.3224, -4782.0640);
	at[91] = 8.3500;
	points[92] = (-6060.8271, 3950.8267, 1476.9646);
	angles[92] = (0, -117.5126, -4637.3394);
	at[92] = 8.4000;
	points[93] = (-6041.3784, 3940.3938, 1475.9370);
	angles[93] = (0, -117.5126, -4497.6152);
	at[93] = 8.4500;
	points[94] = (-6020.6694, 3929.6260, 1474.9528);
	angles[94] = (0, -117.5127, -4361.8921);
	at[94] = 8.5000;
	points[95] = (-6000, 3918.8545, 1473.3820);
	angles[95] = (0, -117.5127, -4230.1694);
	at[95] = 8.5500;
	points[96] = (-5979.3306, 3908.0825, 1467.1143);
	angles[96] = (0, -117.5126, -4098.4468);
	at[96] = 8.6000;
	points[97] = (-5958.6221, 3897.3071, 1455.5315);
	angles[97] = (0, -117.5127, -3966.7241);
	at[97] = 8.6500;
	points[98] = (-5944.8423, 3890.1260, 1444.8542);
	angles[98] = (0, -117.5127, -4118.9092);
	at[98] = 8.6833;
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
	points[0] = (-7017.3232, 3144.0828, 1652.0513);
	angles[0] = (0, -95.1675, 156.7473);
	at[0] = 0;
	points[1] = (-6988.9370, 3141.4529, 1641.9922);
	angles[1] = (0, -95.3041, 43.5582);
	at[1] = 0.0500;
	points[2] = (-6957.3232, 3138.5198, 1626.6143);
	angles[2] = (0, -95.3040, -69.6311);
	at[2] = 0.1000;
	points[3] = (-6925.7085, 3135.5867, 1605.9214);
	angles[3] = (0, -95.3040, -182.8204);
	at[3] = 0.1500;
	points[4] = (-6894.1338, 3132.6536, 1579.9174);
	angles[4] = (0, -95.3040, -296.0096);
	at[4] = 0.2000;
	points[5] = (-6862.5195, 3129.7207, 1576.0945);
	angles[5] = (0, -95.3040, -412.1993);
	at[5] = 0.2500;
	points[6] = (-6830.9058, 3126.7837, 1577.8701);
	angles[6] = (0, -95.3039, -528.3890);
	at[6] = 0.3000;
	points[7] = (-6799.2910, 3123.8506, 1574.3346);
	angles[7] = (0, -95.3040, -644.5787);
	at[7] = 0.3500;
	points[8] = (-6767.7163, 3120.9175, 1565.4844);
	angles[8] = (0, -95.3040, -760.7684);
	at[8] = 0.4000;
	points[9] = (-6736.1025, 3117.9844, 1559.8151);
	angles[9] = (0, -95.3039, -878.9585);
	at[9] = 0.4500;
	points[10] = (-6704.4883, 3115.0513, 1558.7520);
	angles[10] = (0, -95.3040, -998.1487);
	at[10] = 0.5000;
	points[11] = (-6672.9136, 3112.1182, 1552.3700);
	angles[11] = (0, -95.3040, -1117.3389);
	at[11] = 0.5500;
	points[12] = (-6641.2993, 3109.1812, 1550.2993);
	angles[12] = (0, -95.3040, -1239.5295);
	at[12] = 0.6000;
	points[13] = (-6609.6851, 3106.4373, 1546.1891);
	angles[13] = (0, -94.8297, -1361.7202);
	at[13] = 0.6500;
	points[14] = (-6578.0317, 3103.7639, 1542.6300);
	angles[14] = (0, -94.8297, -1485.9111);
	at[14] = 0.7000;
	points[15] = (-6546.3779, 3101.0867, 1540.1417);
	angles[15] = (0, -94.8297, -1611.1023);
	at[15] = 0.7500;
	points[16] = (-6514.7246, 3098.4133, 1536.1772);
	angles[16] = (0, -94.8296, -1738.2904);
	at[16] = 0.8000;
	points[17] = (-6483.0708, 3095.7400, 1533.2007);
	angles[17] = (0, -94.8298, -1866.4767);
	at[17] = 0.8500;
	points[18] = (-6451.4570, 3093.0671, 1530.6575);
	angles[18] = (0, -94.8297, -1997.6635);
	at[18] = 0.9000;
	points[19] = (-6419.8032, 3090.3938, 1526.2677);
	angles[19] = (0, -94.8296, -2129.8506);
	at[19] = 0.9500;
	points[20] = (-6388.1499, 3087.7205, 1524.7953);
	angles[20] = (0, -94.8297, -2264.0378);
	at[20] = 1;
	points[21] = (-6356.4961, 3085.0435, 1521.4961);
	angles[21] = (0, -94.8297, -2400.2253);
	at[21] = 1.0500;
	points[22] = (-6324.8428, 3082.3701, 1518.2206);
	angles[22] = (0, -94.8297, -2537.4131);
	at[22] = 1.1000;
	points[23] = (-6293.2285, 3079.6968, 1516.1458);
	angles[23] = (0, -94.8297, -2677.6016);
	at[23] = 1.1500;
	points[24] = (-6266.8501, 3077.9136, 1512.6930);
	angles[24] = (0, -93.2596, -2818.7900);
	at[24] = 1.2000;
	points[25] = (-6242.9526, 3076.5552, 1511.1930);
	angles[25] = (0, -93.2596, -2961.9785);
	at[25] = 1.2500;
	points[26] = (-6219.0552, 3075.1931, 1504.3781);
	angles[26] = (0, -93.2597, -3105.1675);
	at[26] = 1.3000;
	points[27] = (-6195.1572, 3073.8347, 1492.2480);
	angles[27] = (0, -93.2596, -3248.3562);
	at[27] = 1.3500;
	points[28] = (-6171.2998, 3072.4727, 1474.8031);
	angles[28] = (0, -93.2596, -3391.5449);
	at[28] = 1.4000;
	points[29] = (-6147.4014, 3071.1143, 1452.0433);
	angles[29] = (0, -93.2596, -3534.7336);
	at[29] = 1.4500;
	points[30] = (-6123.5039, 3069.7522, 1423.9685);
	angles[30] = (0, -93.2596, -3677.9224);
	at[30] = 1.5000;
	points[31] = (-6099.6455, 3068.3938, 1390.5789);
	angles[31] = (0, -93.2596, -3821.1111);
	at[31] = 1.5500;
	points[32] = (-6075.7485, 3067.0317, 1351.8740);
	angles[32] = (0, -93.2596, -3964.2998);
	at[32] = 1.6000;
	points[33] = (-6051.8501, 3065.6692, 1307.8544);
	angles[33] = (0, -93.2597, -4107.4883);
	at[33] = 1.6500;
	points[34] = (-6027.9526, 3064.3113, 1258.5197);
	angles[34] = (0, -93.2596, -4250.6772);
	at[34] = 1.7000;
	points[35] = (-6009.2520, 3062.6616, 1203.8701);
	angles[35] = (0, -95.2077, -4393.8662);
	at[35] = 1.7500;
	points[36] = (-5990.9058, 3060.9883, 1143.9055);
	angles[36] = (0, -95.2078, -4537.0547);
	at[36] = 1.8000;
	points[37] = (-5972.5591, 3059.3149, 1078.6260);
	angles[37] = (0, -95.2077, -4680.2437);
	at[37] = 1.8500;
	points[38] = (-5954.2129, 3057.6458, 1008.0315);
	angles[38] = (0, -95.2078, -4823.4321);
	at[38] = 1.9000;
	points[39] = (-5935.8662, 3055.9724, 932.1220);
	angles[39] = (0, -95.2078, -4966.6177);
	at[39] = 1.9500;
	points[40] = (-5917.5195, 3054.2993, 850.9016);
	angles[40] = (0, -95.2078, -5109.8013);
	at[40] = 2;
	points[41] = (-5899.1733, 3052.6299, 764.3622);
	angles[41] = (0, -95.2078, -5252.9844);
	at[41] = 2.0500;
	points[42] = (-5880.8267, 3050.9568, 672.5079);
	angles[42] = (0, -95.2077, -5396.1680);
	at[42] = 2.1000;
	points[43] = (-5862.4805, 3049.2834, 575.3386);
	angles[43] = (0, -95.2078, -5539.3516);
	at[43] = 2.1500;
	points[44] = (-5844.1338, 3047.6143, 472.8543);
	angles[44] = (0, -95.2078, -5682.5352);
	at[44] = 2.2000;
	points[45] = (-5825.7876, 3045.9409, 365.0543);
	angles[45] = (0, -95.2077, -5825.7188);
	at[45] = 2.2500;
	points[46] = (-5819.6855, 3045.3857, 327.9402);
	angles[46] = (0, -95.2078, -5873.4463);
	at[46] = 2.2833;
	points[47] = (-7890.7480, 3225.0510, 2317.1968);
	angles[47] = (0, -95.2078, -5873.4463);
	at[47] = 2.2833;
	points[48] = (-7890.7480, 3225.0510, 2317.1968);
	angles[48] = (0, -95.2078, -5873.4463);
	at[48] = 6.6500;
	points[49] = (-7890.7480, 3225.0510, 2424.4922);
	angles[49] = (0, -95.3909, -5752.1362);
	at[49] = 6.7000;
	points[50] = (-7827.6382, 3219.0945, 2423.5276);
	angles[50] = (0, -95.3910, -5795.5171);
	at[50] = 6.8000;
	points[51] = (-7796.0635, 3216.1143, 2423.0471);
	angles[51] = (0, -95.3909, -5827.7041);
	at[51] = 6.8500;
	points[52] = (-7764.4883, 3213.1379, 2422.5630);
	angles[52] = (0, -95.3909, -5868.8926);
	at[52] = 6.9000;
	points[53] = (-7732.9531, 3210.1577, 2422.0828);
	angles[53] = (0, -95.3909, -5919.0825);
	at[53] = 6.9500;
	points[54] = (-7701.3784, 3207.1812, 2421.6025);
	angles[54] = (0, -95.3910, -5978.2715);
	at[54] = 7;
	points[55] = (-7669.8423, 3204.2048, 2421.1182);
	angles[55] = (0, -95.3910, -6046.4590);
	at[55] = 7.0500;
	points[56] = (-7638.2676, 3201.2244, 2420.6377);
	angles[56] = (0, -95.3909, -6123.6479);
	at[56] = 7.1000;
	points[57] = (-7606.7324, 3198.2480, 2420.1653);
	angles[57] = (0, -95.3909, -6209.8379);
	at[57] = 7.1500;
	points[58] = (-7575.1572, 3195.2715, 2419.7480);
	angles[58] = (0, -95.3910, -6305.0264);
	at[58] = 7.2000;
	points[59] = (-7543.6221, 3192.2913, 2419.0159);
	angles[59] = (0, -95.3910, -6408.2139);
	at[59] = 7.2500;
	points[60] = (-7512.0474, 3189.3149, 2414.1104);
	angles[60] = (0, -95.3909, -6512.4019);
	at[60] = 7.3000;
	points[61] = (-7480.5122, 3186.3347, 2403.8899);
	angles[61] = (0, -95.3909, -6616.5894);
	at[61] = 7.3500;
	points[62] = (-7448.9370, 3183.3584, 2388.3542);
	angles[62] = (0, -95.3910, -6720.7773);
	at[62] = 7.4000;
	points[63] = (-7417.3623, 3180.3779, 2385.6968);
	angles[63] = (0, -95.3909, -6827.9658);
	at[63] = 7.4500;
	points[64] = (-7385.8271, 3177.4016, 2384.3308);
	angles[64] = (0, -95.1676, -6935.1538);
	at[64] = 7.5000;
	points[65] = (-7373.4644, 3176.2954, 2377.6536);
	angles[65] = (0, -95.1675, -7042.3423);
	at[65] = 7.5500;
	points[66] = (-7359.8032, 3175.0552, 2365.6614);
	angles[66] = (0, -95.1676, -7149.5303);
	at[66] = 7.6000;
	points[67] = (-7346.1025, 3173.8188, 2356.8503);
	angles[67] = (0, -95.1676, -7258.7192);
	at[67] = 7.6500;
	points[68] = (-7332.4014, 3172.5789, 2356.7285);
	angles[68] = (0, -95.1676, -7368.9077);
	at[68] = 7.7000;
	points[69] = (-7318.7012, 3171.3386, 2351.2915);
	angles[69] = (0, -95.1676, -7479.0967);
	at[69] = 7.7500;
	points[70] = (-7305, 3170.1023, 2340.5393);
	angles[70] = (0, -95.1675, -7589.2852);
	at[70] = 7.8000;
	points[71] = (-7291.2993, 3168.8621, 2324.4724);
	angles[71] = (0, -95.1676, -7699.4741);
	at[71] = 7.8500;
	points[72] = (-7277.5986, 3167.6223, 2303.0867);
	angles[72] = (0, -95.1676, -7809.6631);
	at[72] = 7.9000;
	points[73] = (-7263.8979, 3166.3860, 2276.3899);
	angles[73] = (0, -95.1676, -7919.8516);
	at[73] = 7.9500;
	points[74] = (-7250.1968, 3165.1458, 2244.3779);
	angles[74] = (0, -95.1675, -8030.0405);
	at[74] = 8;
	points[75] = (-7236.4966, 3163.9055, 2207.0513);
	angles[75] = (0, -95.1676, -8140.2290);
	at[75] = 8.0500;
	points[76] = (-7222.7954, 3162.6655, 2164.4094);
	angles[76] = (0, -95.1676, -8250.4180);
	at[76] = 8.1000;
	points[77] = (-7209.0942, 3161.4292, 2116.4490);
	angles[77] = (0, -95.1676, -8360.6074);
	at[77] = 8.1500;
	points[78] = (-7195.3940, 3160.1890, 2063.1772);
	angles[78] = (0, -95.1676, -8470.7959);
	at[78] = 8.2000;
	points[79] = (-7181.6929, 3158.9487, 2004.5906);
	angles[79] = (0, -95.1676, -8580.9844);
	at[79] = 8.2500;
	points[80] = (-7167.9922, 3157.7126, 1940.6890);
	angles[80] = (0, -95.1676, -8691.1729);
	at[80] = 8.3000;
	points[81] = (-7154.2910, 3156.4724, 1871.4725);
	angles[81] = (0, -95.1676, -8801.3623);
	at[81] = 8.3500;
	points[82] = (-7140.5908, 3155.2322, 1796.9370);
	angles[82] = (0, -95.1676, -8911.5508);
	at[82] = 8.4000;
	points[83] = (-7126.8896, 3153.9963, 1717.0906);
	angles[83] = (0, -95.1676, -9021.7393);
	at[83] = 8.4500;
	points[84] = (-7113.1890, 3152.7561, 1631.9292);
	angles[84] = (0, -95.1676, -9131.9277);
	at[84] = 8.5000;
	points[85] = (-7099.4883, 3151.5159, 1600.8071);
	angles[85] = (0, -95.1676, -9244.1172);
	at[85] = 8.5500;
	points[86] = (-7085.7876, 3150.2795, 1622.6339);
	angles[86] = (0, -95.1675, -9357.3066);
	at[86] = 8.6000;
	points[87] = (-7072.0864, 3149.0396, 1639.1497);
	angles[87] = (0, -95.1676, -9470.4961);
	at[87] = 8.6500;
	points[88] = (-7058.3862, 3147.7993, 1650.3464);
	angles[88] = (0, -95.1676, -9583.6846);
	at[88] = 8.7000;
	points[89] = (-7044.6851, 3146.5630, 1656.2284);
	angles[89] = (0, -95.1677, -9696.8740);
	at[89] = 8.7500;
	points[90] = (-7031.0234, 3145.3228, 1656.7992);
	angles[90] = (0, -95.1676, -9810.0635);
	at[90] = 8.8000;
	points[91] = (-7017.3232, 3144.0828, 1652.0513);
	angles[91] = (0, -95.1675, -9923.2529);
	at[91] = 8.8500;
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
	points[0] = (-6260.9448, 2083.6614, 1598.1456);
	angles[0] = (0, -66.6398, -179.2691);
	at[0] = 0;
	points[1] = (-6232.6772, 2095.8701, 1591.9763);
	angles[1] = (0, -66.6398, -253.9802);
	at[1] = 0.0500;
	points[2] = (-6204.4092, 2108.0789, 1591.2953);
	angles[2] = (0, -66.6398, -330.6916);
	at[2] = 0.1000;
	points[3] = (-6176.1416, 2120.2834, 1585.3032);
	angles[3] = (0, -64.5197, -407.4030);
	at[3] = 0.1500;
	points[4] = (-6139.9609, 2137.7402, 1580.0432);
	angles[4] = (0, -64.5198, -566.8270);
	at[4] = 0.2500;
	points[5] = (-6121.1025, 2146.7285, 1570.5001);
	angles[5] = (0, -64.5197, -646.5388);
	at[5] = 0.3000;
	points[6] = (-6102.2051, 2155.7205, 1555.6458);
	angles[6] = (0, -64.5197, -726.2507);
	at[6] = 0.3500;
	points[7] = (-6083.3467, 2164.7087, 1535.4763);
	angles[7] = (0, -64.5197, -805.9626);
	at[7] = 0.4000;
	points[8] = (-6064.4883, 2173.7009, 1509.9922);
	angles[8] = (0, -64.5196, -885.6746);
	at[8] = 0.4500;
	points[9] = (-6045.6304, 2182.6890, 1479.1890);
	angles[9] = (0, -64.5198, -965.3864);
	at[9] = 0.5000;
	points[10] = (-6026.7720, 2191.6812, 1443.0747);
	angles[10] = (0, -64.5196, -1045.0977);
	at[10] = 0.5500;
	points[11] = (-6007.9136, 2200.6692, 1401.6456);
	angles[11] = (0, -64.5197, -1124.8094);
	at[11] = 0.6000;
	points[12] = (-5989.0161, 2209.6614, 1354.8976);
	angles[12] = (0, -64.5196, -1204.5214);
	at[12] = 0.6500;
	points[13] = (-5970.1577, 2218.6497, 1302.8385);
	angles[13] = (0, -64.5197, -1284.2333);
	at[13] = 0.7000;
	points[14] = (-5951.2988, 2227.6379, 1245.4646);
	angles[14] = (0, -64.5197, -1363.9452);
	at[14] = 0.7500;
	points[15] = (-5932.4414, 2236.6299, 1182.7717);
	angles[15] = (0, -67.4882, -1443.6571);
	at[15] = 0.8000;
	points[16] = (-5922.3618, 2240.6221, 1114.7677);
	angles[16] = (0, -67.4882, -1523.3690);
	at[16] = 0.8500;
	points[17] = (-5911.1421, 2245.2717, 1041.4489);
	angles[17] = (0, -67.4882, -1603.0808);
	at[17] = 0.9000;
	points[18] = (-5899.9604, 2249.9211, 962.8110);
	angles[18] = (0, -67.4883, -1682.7928);
	at[18] = 0.9500;
	points[19] = (-5888.7402, 2254.5710, 878.8622);
	angles[19] = (0, -67.4883, -1762.5048);
	at[19] = 1;
	points[20] = (-5877.5200, 2259.2205, 789.5984);
	angles[20] = (0, -67.4883, -1842.2167);
	at[20] = 1.0500;
	points[21] = (-5866.2993, 2263.8662, 695.0157);
	angles[21] = (0, -67.4882, -1921.9286);
	at[21] = 1.1000;
	points[22] = (-5855.0786, 2268.5159, 595.1221);
	angles[22] = (0, -67.4882, -2001.6405);
	at[22] = 1.1500;
	points[23] = (-5843.8584, 2273.1653, 489.9134);
	angles[23] = (0, -67.4883, -2081.3525);
	at[23] = 1.2000;
	points[24] = (-5832.6382, 2277.8149, 379.3878);
	angles[24] = (0, -67.4882, -2161.0642);
	at[24] = 1.2500;
	points[25] = (-5832.6382, 2277.8149, 379.3878);
	angles[25] = (0, -67.4882, -2161.0642);
	at[25] = 1.2667;
	points[26] = (-7632.7954, 1509.7125, 2476.6536);
	angles[26] = (0, -67.4882, -2161.0642);
	at[26] = 1.2667;
	points[27] = (-7632.7954, 1509.7125, 2476.6536);
	angles[27] = (0, -67.4882, -2161.0642);
	at[27] = 5;
	points[28] = (-7623.3462, 1513.5198, 2583.5198);
	angles[28] = (0, -68.1138, -2236.3196);
	at[28] = 5.0500;
	points[29] = (-7566.4961, 1536.3505, 2580.2874);
	angles[29] = (0, -68.1139, -2276.7402);
	at[29] = 5.1500;
	points[30] = (-7509.6851, 1559.1771, 2577.3662);
	angles[30] = (0, -68.1138, -2325.1624);
	at[30] = 5.2500;
	points[31] = (-7452.8350, 1582.0078, 2573.9568);
	angles[31] = (0, -68.1138, -2385.5862);
	at[31] = 5.3500;
	points[32] = (-7396.0234, 1604.8386, 2570.7046);
	angles[32] = (0, -68.1139, -2458.0068);
	at[32] = 5.4500;
	points[33] = (-7339.1729, 1627.6654, 2566.9844);
	angles[33] = (0, -68.1139, -2542.4292);
	at[33] = 5.5500;
	points[34] = (-7310.7876, 1639.0828, 2561.1260);
	angles[34] = (0, -68.1138, -2586.1406);
	at[34] = 5.6000;
	points[35] = (-7282.3623, 1650.4961, 2549.9526);
	angles[35] = (0, -68.1139, -2629.8523);
	at[35] = 5.6500;
	points[36] = (-7253.9370, 1661.9095, 2533.4607);
	angles[36] = (0, -68.1138, -2673.5637);
	at[36] = 5.7000;
	points[37] = (-7225.5518, 1673.3268, 2522.4685);
	angles[37] = (0, -68.1138, -2719.2754);
	at[37] = 5.7500;
	points[38] = (-7203.5039, 1682.3229, 2523.6968);
	angles[38] = (0, -66.3072, -2765.9873);
	at[38] = 5.8000;
	points[39] = (-7192.7559, 1687.0355, 2519.6064);
	angles[39] = (0, -66.3072, -2812.6992);
	at[39] = 5.8500;
	points[40] = (-7182.0083, 1691.7482, 2510.2048);
	angles[40] = (0, -66.3072, -2859.4111);
	at[40] = 5.9000;
	points[41] = (-7171.2598, 1696.4606, 2496.1536);
	angles[41] = (0, -66.3072, -2907.1233);
	at[41] = 5.9500;
	points[42] = (-7160.5513, 1701.1771, 2497.5591);
	angles[42] = (0, -66.3071, -2956.8357);
	at[42] = 6;
	points[43] = (-7149.8032, 1705.8899, 2493.6458);
	angles[43] = (0, -66.3073, -3006.5481);
	at[43] = 6.0500;
	points[44] = (-7139.0552, 1710.6023, 2484.4214);
	angles[44] = (0, -66.3072, -3056.2605);
	at[44] = 6.1000;
	points[45] = (-7128.3076, 1715.3149, 2469.8779);
	angles[45] = (0, -66.3072, -3105.9729);
	at[45] = 6.1500;
	points[46] = (-7117.5591, 1720.0315, 2450.0237);
	angles[46] = (0, -66.3072, -3155.6855);
	at[46] = 6.2000;
	points[47] = (-7106.8110, 1724.7440, 2424.8545);
	angles[47] = (0, -66.3073, -3205.3977);
	at[47] = 6.2500;
	points[48] = (-7096.1025, 1729.4567, 2394.3662);
	angles[48] = (0, -66.3072, -3255.1104);
	at[48] = 6.3000;
	points[49] = (-7085.3545, 1734.1693, 2358.5669);
	angles[49] = (0, -66.3072, -3304.8228);
	at[49] = 6.3500;
	points[50] = (-7074.6064, 1738.8859, 2317.4490);
	angles[50] = (0, -66.3071, -3354.5352);
	at[50] = 6.4000;
	points[51] = (-7063.8584, 1743.5984, 2271.0198);
	angles[51] = (0, -66.3072, -3404.2476);
	at[51] = 6.4500;
	points[52] = (-7053.1104, 1748.3110, 2219.2717);
	angles[52] = (0, -66.3072, -3453.9600);
	at[52] = 6.5000;
	points[53] = (-7042.3628, 1753.0236, 2162.2126);
	angles[53] = (0, -66.3072, -3503.6724);
	at[53] = 6.5500;
	points[54] = (-7031.6538, 1757.7362, 2099.8347);
	angles[54] = (0, -66.3072, -3553.3848);
	at[54] = 6.6000;
	points[55] = (-7020.9053, 1762.4528, 2032.1458);
	angles[55] = (0, -66.3073, -3603.0972);
	at[55] = 6.6500;
	points[56] = (-7010.1577, 1767.1654, 1959.1378);
	angles[56] = (0, -66.3071, -3652.8096);
	at[56] = 6.7000;
	points[57] = (-6999.4097, 1771.8779, 1880.8190);
	angles[57] = (0, -66.3072, -3702.5220);
	at[57] = 6.7500;
	points[58] = (-6988.6611, 1776.5906, 1797.1812);
	angles[58] = (0, -66.3072, -3752.2344);
	at[58] = 6.8000;
	points[59] = (-6977.9136, 1781.3071, 1708.2323);
	angles[59] = (0, -66.3072, -3801.9468);
	at[59] = 6.8500;
	points[60] = (-6967.2046, 1786.0197, 1704.9922);
	angles[60] = (0, -66.3073, -3854.6570);
	at[60] = 6.9000;
	points[61] = (-6956.4565, 1790.7323, 1725.6536);
	angles[61] = (0, -66.3072, -3907.3672);
	at[61] = 6.9500;
	points[62] = (-6945.7090, 1795.4449, 1741);
	angles[62] = (0, -66.3072, -3960.0776);
	at[62] = 7;
	points[63] = (-6934.9604, 1800.1614, 1751.0315);
	angles[63] = (0, -66.3072, -4012.7878);
	at[63] = 7.0500;
	points[64] = (-6924.2129, 1804.8740, 1755.7480);
	angles[64] = (0, -66.3072, -4065.4980);
	at[64] = 7.1000;
	points[65] = (-6913.4648, 1809.5867, 1755.1495);
	angles[65] = (0, -66.3071, -4118.2085);
	at[65] = 7.1500;
	points[66] = (-6902.7559, 1814.2992, 1749.2362);
	angles[66] = (0, -66.3072, -4170.9185);
	at[66] = 7.2000;
	points[67] = (-6885.3940, 1821.6063, 1738.0079);
	angles[67] = (0, -67.7099, -4223.6289);
	at[67] = 7.2500;
	points[68] = (-6856.9292, 1833.2834, 1721.4646);
	angles[68] = (0, -67.7099, -4276.3394);
	at[68] = 7.3000;
	points[69] = (-6828.4253, 1844.9568, 1699.6062);
	angles[69] = (0, -67.7099, -4329.0493);
	at[69] = 7.3500;
	points[70] = (-6799.9604, 1856.6300, 1672.4331);
	angles[70] = (0, -67.7099, -4381.7598);
	at[70] = 7.4000;
	points[71] = (-6771.4565, 1868.3071, 1669.3070);
	angles[71] = (0, -67.7099, -4437.4702);
	at[71] = 7.4500;
	points[72] = (-6742.9922, 1879.9803, 1671.4331);
	angles[72] = (0, -67.7099, -4493.1812);
	at[72] = 7.5000;
	points[73] = (-6714.5273, 1891.6536, 1668.2480);
	angles[73] = (0, -67.7099, -4548.8921);
	at[73] = 7.5500;
	points[74] = (-6686.0234, 1903.3308, 1659.7441);
	angles[74] = (0, -67.7099, -4604.6025);
	at[74] = 7.6000;
	points[75] = (-6657.5596, 1915.0040, 1647.4172);
	angles[75] = (0, -67.7100, -4661.3135);
	at[75] = 7.6500;
	points[76] = (-6629.0557, 1926.6771, 1648.5511);
	angles[76] = (0, -67.7100, -4720.0249);
	at[76] = 7.7000;
	points[77] = (-6600.5908, 1938.3544, 1644.3700);
	angles[77] = (0, -67.7100, -4778.7358);
	at[77] = 7.7500;
	points[78] = (-6572.1265, 1950.0276, 1635.9370);
	angles[78] = (0, -67.7099, -4838.4473);
	at[78] = 7.8000;
	points[79] = (-6543.6221, 1961.7009, 1635.7755);
	angles[79] = (0, -67.7099, -4900.1592);
	at[79] = 7.8500;
	points[80] = (-6515.3149, 1973.7914, 1630.2953);
	angles[80] = (0, -66.6398, -4961.8706);
	at[80] = 7.9000;
	points[81] = (-6458.7793, 1998.2047, 1624.0787);
	angles[81] = (0, -66.6398, -5090.2949);
	at[81] = 8;
	points[82] = (-6430.5122, 2010.4133, 1616.7953);
	angles[82] = (0, -66.6398, -5156.0063);
	at[82] = 8.0500;
	points[83] = (-6402.2441, 2022.6221, 1616);
	angles[83] = (0, -66.6399, -5223.7163);
	at[83] = 8.1000;
	points[84] = (-6374.0156, 2034.8307, 1609.8937);
	angles[84] = (0, -66.6399, -5291.4263);
	at[84] = 8.1500;
	points[85] = (-6345.7485, 2047.0394, 1608.6812);
	angles[85] = (0, -66.6398, -5362.1367);
	at[85] = 8.2000;
	points[86] = (-6317.4805, 2059.2441, 1604.4883);
	angles[86] = (0, -66.6398, -5432.8472);
	at[86] = 8.2500;
	points[87] = (-6260.9448, 2083.6614, 1598.1456);
	angles[87] = (0, -66.6398, -5579.2690);
	at[87] = 8.3500;
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
