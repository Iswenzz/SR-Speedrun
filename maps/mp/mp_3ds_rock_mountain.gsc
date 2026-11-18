main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_rock_mountain", 0);

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
	ambientPlay("iz_0_111", 2);
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
	level.iz_route[level.iz_route.size] = (7543, -2113, 6997);
	level.iz_route[level.iz_route.size] = (7523, -2543, 6880);
	level.iz_route[level.iz_route.size] = (7469, -3721, 6560);
	level.iz_route[level.iz_route.size] = (6903, -4429, 6351);
	level.iz_route[level.iz_route.size] = (5806, -4916, 6185);
	level.iz_route[level.iz_route.size] = (4792, -5231, 6099);
	level.iz_route[level.iz_route.size] = (4273, -5671, 6061);
	level.iz_route[level.iz_route.size] = (4343, -6158, 6054);
	level.iz_route[level.iz_route.size] = (4874, -6756, 6084);
	level.iz_route[level.iz_route.size] = (5346, -7291, 6141);
	level.iz_route[level.iz_route.size] = (5381, -8108, 6219);
	level.iz_route[level.iz_route.size] = (5452, -8541, 6256);
	level.iz_route[level.iz_route.size] = (6018, -9154, 6287);
	level.iz_route[level.iz_route.size] = (6183, -9547, 6294);
	level.iz_route[level.iz_route.size] = (6101, -10326, 6317);
	level.iz_route[level.iz_route.size] = (5664, -10876, 6313);
	level.iz_route[level.iz_route.size] = (4768, -11198, 6265);
	level.iz_route[level.iz_route.size] = (3341, -11112, 6133);
	level.iz_route[level.iz_route.size] = (3058, -10893, 6112);
	level.iz_route[level.iz_route.size] = (2350, -10203, 6087);
	level.iz_route[level.iz_route.size] = (1591, -9723, 6090);
	level.iz_route[level.iz_route.size] = (820, -9422, 6093);
	level.iz_route[level.iz_route.size] = (214, -9313, 6094);
	level.iz_route[level.iz_route.size] = (-407, -9372, 6092);
	level.iz_route[level.iz_route.size] = (-1193, -9703, 6094);
	level.iz_route[level.iz_route.size] = (-1834, -9944, 6112);
	level.iz_route[level.iz_route.size] = (-2750, -10343, 6181);
	level.iz_route[level.iz_route.size] = (-3216, -10359, 6212);
	level.iz_route[level.iz_route.size] = (-3637, -10183, 6219);
	level.iz_route[level.iz_route.size] = (-3974, -9941, 6208);
	level.iz_route[level.iz_route.size] = (-4264, -9429, 6131);
	level.iz_route[level.iz_route.size] = (-4377, -8773, 5948);
	level.iz_route[level.iz_route.size] = (-4393, -8293, 5672);
	level.iz_route[level.iz_route.size] = (-4405, -7918, 5430);
	level.iz_route[level.iz_route.size] = (-4387, -7490, 5133);
	level.iz_route[level.iz_route.size] = (-4367, -7032, 4814);
	level.iz_route[level.iz_route.size] = (-4360, -6710, 4590);
	level.iz_route[level.iz_route.size] = (-4354, -6469, 4449);
	level.iz_route[level.iz_route.size] = (-4365, -6308, 4391);
	level.iz_route[level.iz_route.size] = (-4350, -5855, 4423);
	level.iz_route[level.iz_route.size] = (-4351, -5619, 4426);
	level.iz_route[level.iz_route.size] = (-4352, -5313, 4442);
	level.iz_route[level.iz_route.size] = (-4354, -4925, 4393);
	level.iz_route[level.iz_route.size] = (-4355, -4627, 4345);
	level.iz_route[level.iz_route.size] = (-4350, -4369, 4293);
	level.iz_route[level.iz_route.size] = (-4309, -3120, 3989);
	level.iz_route[level.iz_route.size] = (-4199, -2212, 3717);
	level.iz_route[level.iz_route.size] = (-4272, -1232, 3482);
	level.iz_route[level.iz_route.size] = (-4245, -528, 3296);
	level.iz_route[level.iz_route.size] = (-4158, 384, 2959);
	level.iz_route[level.iz_route.size] = (-3909, 1208, 2516);
	level.iz_route[level.iz_route.size] = (-4020, 1945, 2330);
	level.iz_route[level.iz_route.size] = (-4366, 2594, 2084);
	level.iz_route[level.iz_route.size] = (-4990, 3499, 1769);
	level.iz_route[level.iz_route.size] = (-5024, 3638, 1814);
	level.iz_route[level.iz_route.size] = (-5117, 4136, 1938);
	level.iz_route[level.iz_route.size] = (-4911, 4847, 2073);
	level.iz_route[level.iz_route.size] = (-4124, 6177, 2237);
	level.iz_route[level.iz_route.size] = (-3047, 7494, 1452);
	level.iz_route[level.iz_route.size] = (-2036, 8736, 1304);
	level.iz_route[level.iz_route.size] = (-884, 9311, 1288);
	level.iz_route[level.iz_route.size] = (932, 9617, 1308);
	level.iz_route[level.iz_route.size] = (2047, 9904, 1400);
	level.iz_route[level.iz_route.size] = (3535, 10634, 1650);
	level.iz_route[level.iz_route.size] = (4977, 10984, 1884);
	level.iz_route[level.iz_route.size] = (6485, 10871, 1992);
	level.iz_route[level.iz_route.size] = (7328, 10147, 1884);
	level.iz_route[level.iz_route.size] = (7568, 8952, 1646);
	level.iz_route[level.iz_route.size] = (7562, 7769, 1589);
	level.iz_route[level.iz_route.size] = (7552, 7511, 1627);
	level.iz_route[level.iz_route.size] = (7538, 6733, 1895);
	level.iz_route[level.iz_route.size] = (7522, 5750, 2572);
	level.iz_route[level.iz_route.size] = (7510, 5068, 3349);
	level.iz_route[level.iz_route.size] = (7539, 4872, 3616);
	level.iz_route[level.iz_route.size] = (7541, 3986, 4891);
	level.iz_route[level.iz_route.size] = (7535, 3284, 5899);
	level.iz_route[level.iz_route.size] = (7549, 3160, 6070);
	level.iz_route[level.iz_route.size] = (7533, 2203, 7326);
	level.iz_route[level.iz_route.size] = (7531, 2046, 7510);
	level.iz_route[level.iz_route.size] = (7528, 1712, 7645);
	level.iz_route[level.iz_route.size] = (7524, 1369, 7658);
	level.iz_route[level.iz_route.size] = (7522, 1102, 7547);
	level.iz_route[level.iz_route.size] = (7522, 735, 7594);
	level.iz_route[level.iz_route.size] = (7523, 331, 7579);
	level.iz_route[level.iz_route.size] = (7524, -271, 7472);
	level.iz_route[level.iz_route.size] = (7520, -1079, 7264);
	level.iz_route[level.iz_route.size] = (7516, -1677, 7110);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (999.1693, -11202.4014, 6621.6538);
	angles[0] = (0, -86.0064, 0);
	at[0] = 0;
	points[1] = (1228.1851, -11185.7871, 6440.5513);
	angles[1] = (0, -85.9393, 0);
	at[1] = 0.3000;
	points[2] = (1347.1417, -11177.9922, 6354.4092);
	angles[2] = (0, -86.9306, 0);
	at[2] = 0.4500;
	points[3] = (1389.1221, -11176.2607, 6333.3467);
	angles[3] = (0, -88.1233, 0);
	at[3] = 0.5000;
	points[4] = (1480.7205, -11173.8193, 6298.5825);
	angles[4] = (0, -88.6754, 0);
	at[4] = 0.6000;
	points[5] = (1667.4252, -11169.4492, 6241.2998);
	angles[5] = (0, -88.3005, 0);
	at[5] = 0.8000;
	points[6] = (1761.4133, -11165.3154, 6220.4331);
	angles[6] = (0, -87.0549, 0);
	at[6] = 0.9000;
	points[7] = (1857.6654, -11160.2764, 6203.1895);
	angles[7] = (0, -87.0223, 0);
	at[7] = 1;
	points[8] = (2002.3188, -11153.3467, 6179.7642);
	angles[8] = (0, -87.6705, 0);
	at[8] = 1.1500;
	points[9] = (2146.0669, -11149.8027, 6159.2915);
	angles[9] = (0, -89.0037, 0);
	at[9] = 1.3000;
	points[10] = (2388.2363, -11147.0479, 6127.9922);
	angles[10] = (0, -89.7999, 0);
	at[10] = 1.5500;
	points[11] = (2534.5000, -11148.0322, 6112.2837);
	angles[11] = (0, -91.3110, 0);
	at[11] = 1.7000;
	points[12] = (2630.4373, -11153.5830, 6107.7559);
	angles[12] = (0, -95.6673, 0);
	at[12] = 1.8000;
	points[13] = (2726.8228, -11164.6064, 6109.2910);
	angles[13] = (0, -97.0801, 0);
	at[13] = 1.9000;
	points[14] = (3113.4094, -11216.6543, 6126.4966);
	angles[14] = (0, -97.5532, 0);
	at[14] = 2.3000;
	points[15] = (3305.2834, -11241.5361, 6140.1577);
	angles[15] = (0, -97.4886, 0);
	at[15] = 2.5000;
	points[16] = (3644.1064, -11284.2119, 6168.6221);
	angles[16] = (0, -96.5220, 0);
	at[16] = 2.8500;
	points[17] = (3740.1536, -11294.2910, 6176.8506);
	angles[17] = (0, -95.2113, 0);
	at[17] = 2.9500;
	points[18] = (3836.0237, -11298.9756, 6185);
	angles[18] = (0, -90.2445, 0);
	at[18] = 3.0500;
	points[19] = (3982.0864, -11296.0635, 6197.6772);
	angles[19] = (0, -87.9926, 0);
	at[19] = 3.2000;
	points[20] = (4320.4331, -11280.9453, 6227.0479);
	angles[20] = (0, -88.0335, 0);
	at[20] = 3.5500;
	points[21] = (4710.2754, -11270.7090, 6260.0786);
	angles[21] = (0, -87.7406, 0);
	at[21] = 3.9500;
	points[22] = (4905.3545, -11257.5986, 6275.9844);
	angles[22] = (0, -82.7808, 0);
	at[22] = 4.1500;
	points[23] = (4950.1182, -11249.7246, 6279.2915);
	angles[23] = (0, -77.1940, 0);
	at[23] = 4.2000;
	points[24] = (5044.4487, -11223.7402, 6285.6299);
	angles[24] = (0, -72.9379, 0);
	at[24] = 4.3000;
	points[25] = (5275.6304, -11144.6465, 6300.0391);
	angles[25] = (0, -69.7402, 0);
	at[25] = 4.5500;
	points[26] = (5456.2202, -11073.1895, 6310.0786);
	angles[26] = (0, -65.7808, 0);
	at[26] = 4.7500;
	points[27] = (5586.6929, -11007.6777, 6314.4487);
	angles[27] = (0, -62.0572, 0);
	at[27] = 4.9000;
	points[28] = (5715.0396, -10937.0869, 6317.7559);
	angles[28] = (0, -60.2933, 0);
	at[28] = 5.0500;
	points[29] = (5840.0396, -10861.8115, 6320.6304);
	angles[29] = (0, -56.9299, 0);
	at[29] = 5.2000;
	points[30] = (5880.7871, -10833.7402, 6321.4570);
	angles[30] = (0, -53.2596, 0);
	at[30] = 5.2500;
	points[31] = (5915.5903, -10801.6934, 6322.0078);
	angles[31] = (0, -39.9879, 0);
	at[31] = 5.3000;
	points[32] = (5944.1343, -10762.0088, 6322.1260);
	angles[32] = (0, -32.6216, 0);
	at[32] = 5.3500;
	points[33] = (5991.9297, -10676.8115, 6321.7715);
	angles[33] = (0, -26.8260, 0);
	at[33] = 5.4500;
	points[34] = (6033.4648, -10588.5439, 6321.1421);
	angles[34] = (0, -23.7533, 0);
	at[34] = 5.5500;
	points[35] = (6069.7246, -10499.1348, 6320.4722);
	angles[35] = (0, -18.1475, 0);
	at[35] = 5.6500;
	points[36] = (6092.9131, -10403.9375, 6318.3857);
	angles[36] = (0, -11.5550, 0);
	at[36] = 5.7500;
	points[37] = (6127.0869, -10211.0625, 6317.3623);
	angles[37] = (0, -8.9344, 0);
	at[37] = 5.9500;
	points[38] = (6132.9526, -10164.4492, 6325.9053);
	angles[38] = (0, -5.0315, 0);
	at[38] = 6;
	points[39] = (6136.1812, -10118.3076, 6341.2993);
	angles[39] = (0, -3.2133, 0);
	at[39] = 6.0500;
	points[40] = (6140.3940, -10029.6465, 6380.9053);
	angles[40] = (0, -3.6260, 0);
	at[40] = 6.1500;
	points[41] = (6142.6377, -9990.9844, 6410.5117);
	angles[41] = (0, -3.1948, 0);
	at[41] = 6.2000;
	points[42] = (6146.8110, -9921.7715, 6479.1343);
	angles[42] = (0, -4.6402, 0);
	at[42] = 6.3000;
	points[43] = (6152.3623, -9872.0479, 6562.5200);
	angles[43] = (0, -7.0592, 0);
	at[43] = 6.4000;
	points[44] = (6154.8818, -9851.9287, 6606.9292);
	angles[44] = (0, -7.3289, 0);
	at[44] = 6.4500;
	points[45] = (6156.6143, -9839.0557, 6652.8740);
	angles[45] = (0, -8.0521, 0);
	at[45] = 6.5000;
	points[46] = (6163.0713, -9795.7480, 6893.7798);
	angles[46] = (0, -8.5829, 0);
	at[46] = 6.7500;
	points[47] = (6163.5039, -9793.0312, 6909.5674);
	angles[47] = (0, -8.5508, 0);
	at[47] = 6.7833;
	points[48] = (999.1693, -11202.4014, 6621.6538);
	angles[48] = (0, -86.0064, 0);
	at[48] = 6.7833;
	points[49] = (999.1693, -11202.4014, 6621.6538);
	angles[49] = (0, -86.0064, 0);
	at[49] = 6.8000;
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
	points[0] = (7014.9214, 2216.0039, 9855.9844);
	angles[0] = (0, 8.8389, 61.8980);
	at[0] = 0;
	points[1] = (7012.7559, 2229.9172, 9939.8428);
	angles[1] = (0, 8.8389, 49.8961);
	at[1] = 0.0667;
	points[2] = (7010.5908, 2243.8308, 10014.2520);
	angles[2] = (0, 8.8389, 37.8943);
	at[2] = 0.1333;
	points[3] = (7008.4258, 2257.7402, 10079.2129);
	angles[3] = (0, 8.8389, 25.8923);
	at[3] = 0.2000;
	points[4] = (7006.2998, 2271.6536, 10134.7246);
	angles[4] = (0, 8.8389, 13.8905);
	at[4] = 0.2667;
	points[5] = (7004.1338, 2285.5669, 10180.7881);
	angles[5] = (0, 8.8389, 1.8885);
	at[5] = 0.3333;
	points[6] = (7001.9688, 2299.4763, 10217.4014);
	angles[6] = (0, 8.8389, -10.1134);
	at[6] = 0.4000;
	points[7] = (6999.8032, 2313.3899, 10244.5674);
	angles[7] = (0, 8.8389, -22.1153);
	at[7] = 0.4667;
	points[8] = (6997.6382, 2327.3032, 10262.2832);
	angles[8] = (0, 8.8389, -34.1172);
	at[8] = 0.5333;
	points[9] = (6995.4727, 2341.2126, 10270.5518);
	angles[9] = (0, 8.8389, -46.1191);
	at[9] = 0.6000;
	points[10] = (6993.3071, 2355.1260, 10269.3711);
	angles[10] = (0, 8.8389, -58.1210);
	at[10] = 0.6667;
	points[11] = (6991.1416, 2369.0354, 10258.7402);
	angles[11] = (0, 8.8389, -70.1230);
	at[11] = 0.7333;
	points[12] = (6988.9766, 2382.9490, 10238.6621);
	angles[12] = (0, 8.8389, -82.1247);
	at[12] = 0.8000;
	points[13] = (6986.8110, 2396.8621, 10209.1348);
	angles[13] = (0, 8.8389, -94.1266);
	at[13] = 0.8667;
	points[14] = (6984.6460, 2410.7717, 10170.1572);
	angles[14] = (0, 8.8389, -106.1286);
	at[14] = 0.9333;
	points[15] = (6982.4805, 2424.6851, 10121.7324);
	angles[15] = (0, 8.8389, -118.1305);
	at[15] = 1;
	points[16] = (6980.3149, 2438.5984, 10063.8584);
	angles[16] = (0, 8.8389, -130.1323);
	at[16] = 1.0667;
	points[17] = (6978.1494, 2452.5081, 9996.5361);
	angles[17] = (0, 8.8389, -142.1343);
	at[17] = 1.1333;
	points[18] = (6975.9844, 2466.4211, 9919.7637);
	angles[18] = (0, 8.8389, -154.1362);
	at[18] = 1.2000;
	points[19] = (6973.8188, 2480.3347, 9833.5439);
	angles[19] = (0, 8.8389, -166.1382);
	at[19] = 1.2667;
	points[20] = (6971.6538, 2494.2441, 9737.8740);
	angles[20] = (0, 8.8389, -178.1400);
	at[20] = 1.3333;
	points[21] = (6969.4878, 2508.1575, 9632.7559);
	angles[21] = (0, 8.8389, -190.1419);
	at[21] = 1.4000;
	points[22] = (6967.3228, 2522.0669, 9518.1885);
	angles[22] = (0, 8.8389, -202.1437);
	at[22] = 1.4667;
	points[23] = (6965.1968, 2535.9805, 9394.1729);
	angles[23] = (0, 8.8389, -214.1457);
	at[23] = 1.5333;
	points[24] = (6963.0312, 2549.8938, 9260.7090);
	angles[24] = (0, 8.8389, -226.1476);
	at[24] = 1.6000;
	points[25] = (6960.8662, 2563.8030, 9117.7949);
	angles[25] = (0, 8.8389, -238.1494);
	at[25] = 1.6667;
	points[26] = (6958.7012, 2577.7166, 8965.4336);
	angles[26] = (0, 8.8389, -250.1514);
	at[26] = 1.7333;
	points[27] = (6956.5356, 2591.6299, 8803.6221);
	angles[27] = (0, 8.8389, -262.1532);
	at[27] = 1.8000;
	points[28] = (6954.3706, 2605.5396, 8632.3623);
	angles[28] = (0, 8.8389, -274.1551);
	at[28] = 1.8667;
	points[29] = (6952.2046, 2619.4529, 8451.6533);
	angles[29] = (0, 8.8389, -286.1570);
	at[29] = 1.9333;
	points[30] = (6950.0396, 2633.3660, 8261.4961);
	angles[30] = (0, 8.8389, -298.1589);
	at[30] = 2;
	points[31] = (6947.8740, 2647.2756, 8061.8901);
	angles[31] = (0, 8.8389, -310.1609);
	at[31] = 2.0667;
	points[32] = (6945.7090, 2661.1890, 7852.8350);
	angles[32] = (0, 8.8389, -322.1628);
	at[32] = 2.1333;
	points[33] = (6943.5435, 2675.1025, 7634.3311);
	angles[33] = (0, 8.8389, -334.1647);
	at[33] = 2.2000;
	points[34] = (6941.3784, 2689.0120, 7406.3779);
	angles[34] = (0, 8.8389, -346.1666);
	at[34] = 2.2667;
	points[35] = (6939.2124, 2702.9250, 7168.9761);
	angles[35] = (0, 8.8389, -358.1684);
	at[35] = 2.3333;
	points[36] = (6937.0474, 2716.8386, 6922.1265);
	angles[36] = (0, 8.8389, -370.1704);
	at[36] = 2.4000;
	points[37] = (6934.8818, 2730.7480, 6754.0552);
	angles[37] = (0, 8.8389, -388.9041);
	at[37] = 2.4667;
	points[38] = (6932.7168, 2744.6616, 6823.0312);
	angles[38] = (0, 8.8389, -414.3696);
	at[38] = 2.5333;
	points[39] = (6930.5513, 2758.5710, 6882.5591);
	angles[39] = (0, 8.8389, -439.8353);
	at[39] = 2.6000;
	points[40] = (6928.3862, 2772.4841, 6932.6382);
	angles[40] = (0, 8.8389, -465.3008);
	at[40] = 2.6667;
	points[41] = (6926.2202, 2786.3977, 6973.2681);
	angles[41] = (0, 8.8389, -490.7664);
	at[41] = 2.7333;
	points[42] = (6924.0552, 2800.3110, 7004.4487);
	angles[42] = (0, 8.8389, -516.2319);
	at[42] = 2.8000;
	points[43] = (6921.9292, 2814.2205, 7026.1812);
	angles[43] = (0, 8.8389, -541.6975);
	at[43] = 2.8667;
	points[44] = (6919.7637, 2828.1340, 7038.4644);
	angles[44] = (0, 8.8389, -567.1631);
	at[44] = 2.9333;
	points[45] = (6917.5986, 2842.0474, 7041.2993);
	angles[45] = (0, 8.8389, -592.6287);
	at[45] = 3;
	points[46] = (6915.4331, 2855.9565, 7034.6851);
	angles[46] = (0, 8.8389, -618.0942);
	at[46] = 3.0667;
	points[47] = (6913.2676, 2869.8701, 7018.6221);
	angles[47] = (0, 8.8389, -643.5597);
	at[47] = 3.1333;
	points[48] = (6911.1025, 2883.7795, 6993.1104);
	angles[48] = (0, 8.8389, -669.0253);
	at[48] = 3.2000;
	points[49] = (6908.9370, 2897.6931, 6958.1499);
	angles[49] = (0, 8.8389, -694.4910);
	at[49] = 3.2667;
	points[50] = (6906.7720, 2911.6064, 6913.7397);
	angles[50] = (0, 8.8389, -719.9565);
	at[50] = 3.3333;
	points[51] = (6904.6064, 2925.5156, 6859.8818);
	angles[51] = (0, 8.8389, -745.4221);
	at[51] = 3.4000;
	points[52] = (6902.4414, 2939.4292, 6796.5747);
	angles[52] = (0, 8.8389, -770.8876);
	at[52] = 3.4667;
	points[53] = (6900.2754, 2953.3425, 6723.8193);
	angles[53] = (0, 8.8389, -796.3533);
	at[53] = 3.5333;
	points[54] = (6898.1104, 2967.2522, 6641.6143);
	angles[54] = (0, 8.8389, -821.8188);
	at[54] = 3.6000;
	points[55] = (6895.9448, 2981.1655, 6549.9609);
	angles[55] = (0, 8.8389, -847.2844);
	at[55] = 3.6667;
	points[56] = (6893.7798, 2995.0747, 6448.8579);
	angles[56] = (0, 8.8389, -872.7498);
	at[56] = 3.7333;
	points[57] = (6891.6143, 3008.9883, 6359.9604);
	angles[57] = (0, 8.8389, -899.2156);
	at[57] = 3.8000;
	points[58] = (6889.4492, 3022.9016, 6388.2676);
	angles[58] = (0, 8.8389, -928.6818);
	at[58] = 3.8667;
	points[59] = (6887.2832, 3036.8110, 6407.1655);
	angles[59] = (0, 8.8389, -958.1480);
	at[59] = 3.9333;
	points[60] = (6885.1182, 3050.7246, 6416.5752);
	angles[60] = (0, 8.8389, -987.6142);
	at[60] = 4;
	points[61] = (6882.9526, 3064.6377, 6416.5752);
	angles[61] = (0, 8.8389, -1017.0805);
	at[61] = 4.0667;
	points[62] = (6880.7876, 3078.5471, 6407.0869);
	angles[62] = (0, 8.8389, -1046.5466);
	at[62] = 4.1333;
	points[63] = (6878.6616, 3092.4607, 6388.1890);
	angles[63] = (0, 8.8389, -1076.0128);
	at[63] = 4.2000;
	points[64] = (6876.4961, 3106.3701, 6359.8032);
	angles[64] = (0, 8.8389, -1105.4790);
	at[64] = 4.2667;
	points[65] = (6874.3311, 3120.2837, 6321.9688);
	angles[65] = (0, 8.8389, -1134.9452);
	at[65] = 4.3333;
	points[66] = (6872.1650, 3134.1968, 6274.7246);
	angles[66] = (0, 8.8389, -1164.4114);
	at[66] = 4.4000;
	points[67] = (6870, 3148.1062, 6217.9922);
	angles[67] = (0, 8.8389, -1193.8777);
	at[67] = 4.4667;
	points[68] = (6867.8345, 3162.0198, 6155.7871);
	angles[68] = (0, 8.8389, -1224.3440);
	at[68] = 4.5333;
	points[69] = (6865.6694, 3175.9292, 6170.7876);
	angles[69] = (0, 8.8389, -1257.8108);
	at[69] = 4.6000;
	points[70] = (6863.5039, 3189.8428, 6176.3384);
	angles[70] = (0, 8.8389, -1291.2776);
	at[70] = 4.6667;
	points[71] = (6861.3389, 3203.7559, 6172.4409);
	angles[71] = (0, 8.8389, -1324.7445);
	at[71] = 4.7333;
	points[72] = (6859.1738, 3217.6653, 6159.0942);
	angles[72] = (0, 8.8389, -1358.2113);
	at[72] = 4.8000;
	points[73] = (6857.0078, 3231.5789, 6136.3389);
	angles[73] = (0, 8.8389, -1391.6781);
	at[73] = 4.8667;
	points[74] = (6854.8428, 3245.4883, 6104.0947);
	angles[74] = (0, 8.8389, -1425.1450);
	at[74] = 4.9333;
	points[75] = (6852.6772, 3259.4019, 6062.4019);
	angles[75] = (0, 8.8389, -1458.6118);
	at[75] = 5;
	points[76] = (6850.5122, 3273.3149, 6011.2603);
	angles[76] = (0, 8.8389, -1492.0787);
	at[76] = 5.0667;
	points[77] = (6848.3467, 3287.2244, 5995.4727);
	angles[77] = (0, 8.8389, -1528.5459);
	at[77] = 5.1333;
	points[78] = (6846.1816, 3301.1379, 6002.6377);
	angles[78] = (0, 8.8389, -1566.0134);
	at[78] = 5.2000;
	points[79] = (6844.0156, 3315.0513, 6000.3940);
	angles[79] = (0, 8.8389, -1603.4810);
	at[79] = 5.2667;
	points[80] = (6841.8506, 3328.9607, 5988.7012);
	angles[80] = (0, 8.8389, -1640.9484);
	at[80] = 5.3333;
	points[81] = (6839.6851, 3342.8740, 5967.5195);
	angles[81] = (0, 8.8389, -1678.4159);
	at[81] = 5.4000;
	points[82] = (6837.5591, 3356.7874, 5936.9292);
	angles[82] = (0, 8.8389, -1715.8833);
	at[82] = 5.4667;
	points[83] = (6835.3940, 3370.6968, 5896.8506);
	angles[83] = (0, 8.8389, -1753.3507);
	at[83] = 5.5333;
	points[84] = (6833.2280, 3384.6104, 5847.3623);
	angles[84] = (0, 8.8389, -1790.8182);
	at[84] = 5.6000;
	points[85] = (6831.0630, 3398.5198, 5844.5669);
	angles[85] = (0, 8.8389, -1832.2864);
	at[85] = 5.6667;
	points[86] = (6828.8975, 3412.4329, 5848.1895);
	angles[86] = (0, 8.8389, -1873.7544);
	at[86] = 5.7333;
	points[87] = (6826.7324, 3426.3464, 5842.3623);
	angles[87] = (0, 8.8389, -1915.2227);
	at[87] = 5.8000;
	points[88] = (6824.5669, 3440.2559, 5827.1260);
	angles[88] = (0, 8.8389, -1956.6907);
	at[88] = 5.8667;
	points[89] = (6822.4019, 3454.1694, 5802.4014);
	angles[89] = (0, 8.8389, -1998.1587);
	at[89] = 5.9333;
	points[90] = (6820.2358, 3468.0789, 5768.2285);
	angles[90] = (0, 8.8389, -2039.6270);
	at[90] = 6;
	points[91] = (6818.0708, 3481.9919, 5724.6064);
	angles[91] = (0, 8.8389, -2081.0950);
	at[91] = 6.0667;
	points[92] = (6815.9053, 3495.9055, 5691.3784);
	angles[92] = (0, 8.8389, -2124.5598);
	at[92] = 6.1333;
	points[93] = (6813.7402, 3509.8149, 5699.3706);
	angles[93] = (0, 8.8389, -2170.0215);
	at[93] = 6.2000;
	points[94] = (6811.5752, 3523.7285, 5697.9136);
	angles[94] = (0, 8.8389, -2215.4834);
	at[94] = 6.2667;
	points[95] = (6809.4097, 3537.6379, 5687.0474);
	angles[95] = (0, 5.1557, -2260.9451);
	at[95] = 6.3333;
	points[96] = (6806.9688, 3565.9646, 5666.6934);
	angles[96] = (0, 5.1557, -2306.4070);
	at[96] = 6.4000;
	points[97] = (6804.5278, 3592.9607, 5636.8901);
	angles[97] = (0, 5.1557, -2351.8687);
	at[97] = 6.4667;
	points[98] = (6802.0864, 3619.9568, 5597.6377);
	angles[98] = (0, 5.1557, -2397.3303);
	at[98] = 6.5333;
	points[99] = (6799.6455, 3646.9565, 5548.9766);
	angles[99] = (0, 5.1557, -2442.7920);
	at[99] = 6.6000;
	points[100] = (6797.2051, 3673.9526, 5490.8267);
	angles[100] = (0, 5.1557, -2488.2539);
	at[100] = 6.6667;
	points[101] = (6794.7642, 3700.9487, 5423.2285);
	angles[101] = (0, 5.1557, -2533.7156);
	at[101] = 6.7333;
	points[102] = (6792.3228, 3727.9448, 5351.4961);
	angles[102] = (0, 5.1557, -2580.1775);
	at[102] = 6.8000;
	points[103] = (6789.9214, 3754.9412, 5369.7637);
	angles[103] = (0, 5.1557, -2629.6399);
	at[103] = 6.8667;
	points[104] = (6787.4800, 3781.9373, 5378.5825);
	angles[104] = (0, 5.1557, -2679.1023);
	at[104] = 6.9333;
	points[105] = (6785.0396, 3808.9331, 5377.9531);
	angles[105] = (0, 5.1557, -2728.5645);
	at[105] = 7;
	points[106] = (6782.5986, 3835.9292, 5367.8740);
	angles[106] = (0, 5.1557, -2778.0269);
	at[106] = 7.0667;
	points[107] = (6780.1577, 3862.9253, 5348.3467);
	angles[107] = (0, 5.1557, -2827.4893);
	at[107] = 7.1333;
	points[108] = (6777.7168, 3889.9214, 5319.3701);
	angles[108] = (0, 5.1557, -2876.9517);
	at[108] = 7.2000;
	points[109] = (6775.2754, 3916.9214, 5280.9448);
	angles[109] = (0, 5.1557, -2926.4141);
	at[109] = 7.2667;
	points[110] = (6772.8345, 3943.8977, 5233.0708);
	angles[110] = (0, 5.1557, -2975.8765);
	at[110] = 7.3333;
	points[111] = (6770.4331, 3970.9055, 5175.7480);
	angles[111] = (0, 5.1557, -3025.3389);
	at[111] = 7.4000;
	points[112] = (6767.9922, 3997.9133, 5108.9766);
	angles[112] = (0, 5.1557, -3074.8010);
	at[112] = 7.4667;
	points[113] = (6765.5513, 4024.9214, 5032.7559);
	angles[113] = (0, 5.1557, -3124.2637);
	at[113] = 7.5333;
	points[114] = (6763.1104, 4051.8899, 4947.0864);
	angles[114] = (0, 5.1557, -3173.7258);
	at[114] = 7.6000;
	points[115] = (6760.6689, 4078.8975, 4851.9683);
	angles[115] = (0, 5.1557, -3223.1882);
	at[115] = 7.6667;
	points[116] = (6758.2285, 4105.9058, 4856.8110);
	angles[116] = (0, 5.1557, -3276.6514);
	at[116] = 7.7333;
	points[117] = (6755.7876, 4132.8740, 4874.1338);
	angles[117] = (0, 5.1557, -3330.1143);
	at[117] = 7.8000;
	points[118] = (6753.3467, 4159.8818, 4882.0078);
	angles[118] = (0, 5.1557, -3383.5774);
	at[118] = 7.8667;
	points[119] = (6750.9448, 4186.8896, 4880.4331);
	angles[119] = (0, 5.1557, -3437.0403);
	at[119] = 7.9333;
	points[120] = (6748.5039, 4213.8975, 4869.4097);
	angles[120] = (0, 5.1557, -3490.5032);
	at[120] = 8;
	points[121] = (6746.0635, 4240.8662, 4848.8979);
	angles[121] = (0, 5.1557, -3543.9663);
	at[121] = 8.0667;
	points[122] = (6743.6221, 4267.8740, 4818.9766);
	angles[122] = (0, 5.1557, -3597.4292);
	at[122] = 8.1333;
	points[123] = (6741.1812, 4294.8818, 4779.6064);
	angles[123] = (0, 5.1557, -3650.8923);
	at[123] = 8.2000;
	points[124] = (6738.7402, 4321.8506, 4730.7876);
	angles[124] = (0, 5.1557, -3704.3555);
	at[124] = 8.2667;
	points[125] = (6736.2993, 4348.8584, 4672.5195);
	angles[125] = (0, 5.1557, -3757.8184);
	at[125] = 8.3333;
	points[126] = (6733.8979, 4375.8662, 4604.7637);
	angles[126] = (0, 5.1557, -3811.2812);
	at[126] = 8.4000;
	points[127] = (6731.4570, 4402.8740, 4527.5986);
	angles[127] = (0, 5.1557, -3864.7444);
	at[127] = 8.4667;
	points[128] = (6729.0161, 4429.8423, 4440.9844);
	angles[128] = (0, 5.1557, -3918.2073);
	at[128] = 8.5333;
	points[129] = (6726.5747, 4456.8506, 4344.9214);
	angles[129] = (0, 5.1557, -3971.6704);
	at[129] = 8.6000;
	points[130] = (6724.1338, 4483.8584, 4284.6460);
	angles[130] = (0, 5.1557, -4027.1338);
	at[130] = 8.6667;
	points[131] = (6722.3228, 4511.4961, 4308.3857);
	angles[131] = (0, 0.4621, -4084.5972);
	at[131] = 8.7333;
	points[132] = (6722.0864, 4540.8662, 4322.6772);
	angles[132] = (0, 0.4621, -4142.0610);
	at[132] = 8.8000;
	points[133] = (6721.8506, 4570.1968, 4327.5195);
	angles[133] = (0, 0.4621, -4199.5244);
	at[133] = 8.8667;
	points[134] = (6721.6143, 4599.5278, 4322.9136);
	angles[134] = (0, 0.4621, -4256.9883);
	at[134] = 8.9333;
	points[135] = (6721.3784, 4628.8975, 4308.8584);
	angles[135] = (0, 0.4621, -4314.4517);
	at[135] = 9;
	points[136] = (6721.1416, 4658.2285, 4285.3936);
	angles[136] = (0, 0.4621, -4371.9155);
	at[136] = 9.0667;
	points[137] = (6720.9058, 4687.5591, 4252.4409);
	angles[137] = (0, 0.4621, -4429.3794);
	at[137] = 9.1333;
	points[138] = (6720.6694, 4716.9292, 4210.0396);
	angles[138] = (0, 0.4621, -4486.8428);
	at[138] = 9.2000;
	points[139] = (6720.4336, 4746.2598, 4158.1890);
	angles[139] = (0, 0.4621, -4544.3066);
	at[139] = 9.2667;
	points[140] = (6720.1968, 4775.5908, 4096.8896);
	angles[140] = (0, 0.4621, -4601.7700);
	at[140] = 9.3333;
	points[141] = (6719.9604, 4804.9604, 4026.1418);
	angles[141] = (0, 0.4621, -4659.2334);
	at[141] = 9.4000;
	points[142] = (6719.7246, 4834.2915, 3945.9448);
	angles[142] = (0, 0.4621, -4716.6973);
	at[142] = 9.4667;
	points[143] = (6719.4883, 4863.6616, 3856.2913);
	angles[143] = (0, 0.4621, -4774.1611);
	at[143] = 9.5333;
	points[144] = (6719.2524, 4892.9922, 3757.2009);
	angles[144] = (0, 0.4621, -4831.6245);
	at[144] = 9.6000;
	points[145] = (6719.0156, 4922.3228, 3648.6577);
	angles[145] = (0, 0.4621, -4889.0884);
	at[145] = 9.6667;
	points[146] = (6718.7793, 4951.6929, 3649.0867);
	angles[146] = (0, 0.4621, -4950.5522);
	at[146] = 9.7333;
	points[147] = (6718.5435, 4981.0234, 3670.4290);
	angles[147] = (0, 0.4621, -5012.0166);
	at[147] = 9.8000;
	points[148] = (6718.3071, 5010.3545, 3682.3188);
	angles[148] = (0, 0.4621, -5073.4810);
	at[148] = 9.8667;
	points[149] = (6718.0713, 5039.7246, 3684.7639);
	angles[149] = (0, 0.4621, -5134.9453);
	at[149] = 9.9333;
	points[150] = (6717.8345, 5069.0552, 3677.7600);
	angles[150] = (0, 0.4621, -5196.4097);
	at[150] = 10;
	points[151] = (6717.5986, 5098.3857, 3661.3071);
	angles[151] = (0, 0.4621, -5257.8735);
	at[151] = 10.0667;
	points[152] = (6717.3623, 5127.7559, 3635.4055);
	angles[152] = (0, 0.4621, -5319.3384);
	at[152] = 10.1333;
	points[153] = (6717.1265, 5157.0869, 3600.0513);
	angles[153] = (0, 0.4621, -5380.8022);
	at[153] = 10.2000;
	points[154] = (6716.8896, 5186.4175, 3555.2520);
	angles[154] = (0, 0.4621, -5442.2666);
	at[154] = 10.2667;
	points[155] = (6716.6533, 5215.7876, 3501.0039);
	angles[155] = (0, 0.4621, -5503.7310);
	at[155] = 10.3333;
	points[156] = (6716.4175, 5245.1182, 3437.3071);
	angles[156] = (0, 0.4621, -5565.1953);
	at[156] = 10.4000;
	points[157] = (6716.1812, 5274.4487, 3364.1614);
	angles[157] = (0, 0.4621, -5626.6597);
	at[157] = 10.4667;
	points[158] = (6715.9453, 5303.8188, 3281.5630);
	angles[158] = (0, 0.4621, -5688.1235);
	at[158] = 10.5333;
	points[159] = (6715.7085, 5333.1499, 3189.5198);
	angles[159] = (0, 0.4621, -5749.5879);
	at[159] = 10.6000;
	points[160] = (6715.4727, 5362.5195, 3088.0276);
	angles[160] = (0, 0.4621, -5811.0522);
	at[160] = 10.6667;
	points[161] = (6715.2363, 5391.8506, 3082.0669);
	angles[161] = (0, 0.4621, -5876.5171);
	at[161] = 10.7333;
	points[162] = (6715, 5421.1812, 3101.2913);
	angles[162] = (0, 0.4621, -5941.9819);
	at[162] = 10.8000;
	points[163] = (6714.7637, 5450.5513, 3111.0710);
	angles[163] = (0, 0.4621, -6007.4468);
	at[163] = 10.8667;
	points[164] = (6714.5273, 5479.8818, 3111.4016);
	angles[164] = (0, 0.4621, -6072.9116);
	at[164] = 10.9333;
	points[165] = (6714.2915, 5509.2129, 3102.2834);
	angles[165] = (0, 0.4621, -6138.3770);
	at[165] = 11;
	points[166] = (6714.0552, 5538.5825, 3083.7126);
	angles[166] = (0, 0.4621, -6203.8418);
	at[166] = 11.0667;
	points[167] = (6713.8193, 5567.9136, 3055.6970);
	angles[167] = (0, 0.4621, -6269.3066);
	at[167] = 11.1333;
	points[168] = (6713.5825, 5597.2441, 3018.2324);
	angles[168] = (0, 0.4621, -6334.7715);
	at[168] = 11.2000;
	points[169] = (6713.3462, 5626.6143, 2971.3188);
	angles[169] = (0, 0.4621, -6400.2363);
	at[169] = 11.2667;
	points[170] = (6713.1104, 5655.9448, 2914.9568);
	angles[170] = (0, 0.4621, -6465.7012);
	at[170] = 11.3333;
	points[171] = (6712.8740, 5685.3149, 2849.1418);
	angles[171] = (0, 0.4621, -6531.1660);
	at[171] = 11.4000;
	points[172] = (6712.6382, 5714.6455, 2773.8818);
	angles[172] = (0, 0.4621, -6596.6313);
	at[172] = 11.4667;
	points[173] = (6712.3623, 5743.9766, 2689.1733);
	angles[173] = (0, 0.4621, -6662.0962);
	at[173] = 11.5333;
	points[174] = (6712.1265, 5773.3467, 2664.6379);
	angles[174] = (0, 8.8521, -6730.5615);
	at[174] = 11.6000;
	points[175] = (6703.7402, 5822.8345, 2681.8977);
	angles[175] = (0, 8.8521, -6800.0269);
	at[175] = 11.6667;
	points[176] = (6696.4565, 5869.5273, 2689.7126);
	angles[176] = (0, 8.8521, -6869.4927);
	at[176] = 11.7333;
	points[177] = (6689.2129, 5916.1812, 2688.0786);
	angles[177] = (0, 8.8521, -6938.9580);
	at[177] = 11.8000;
	points[178] = (6681.9287, 5962.8740, 2676.9961);
	angles[178] = (0, 8.8521, -7008.4233);
	at[178] = 11.8667;
	points[179] = (6674.6455, 6009.5674, 2656.4646);
	angles[179] = (0, 8.8521, -7077.8892);
	at[179] = 11.9333;
	points[180] = (6667.4019, 6056.2207, 2626.4844);
	angles[180] = (0, 8.8521, -7147.3545);
	at[180] = 12;
	points[181] = (6660.1187, 6102.9136, 2587.0549);
	angles[181] = (0, 8.8521, -7216.8203);
	at[181] = 12.0667;
	points[182] = (6652.8345, 6149.6064, 2538.1772);
	angles[182] = (0, 8.8521, -7286.2856);
	at[182] = 12.1333;
	points[183] = (6645.5908, 6196.2598, 2479.8464);
	angles[183] = (0, 8.8521, -7355.7515);
	at[183] = 12.2000;
	points[184] = (6638.3076, 6242.9526, 2412.0710);
	angles[184] = (0, 8.8521, -7425.2168);
	at[184] = 12.2667;
	points[185] = (6631.0234, 6289.6460, 2334.8464);
	angles[185] = (0, 8.8521, -7494.6826);
	at[185] = 12.3333;
	points[186] = (6623.7798, 6336.3384, 2248.1733);
	angles[186] = (0, 8.8521, -7564.1479);
	at[186] = 12.4000;
	points[187] = (6616.4966, 6382.9927, 2152.0513);
	angles[187] = (0, 8.8521, -7633.6133);
	at[187] = 12.4667;
	points[188] = (6609.2124, 6429.6851, 2046.4802);
	angles[188] = (0, 8.8521, -7703.0791);
	at[188] = 12.5333;
	points[189] = (6601.9688, 6476.3779, 1931.4607);
	angles[189] = (0, 8.8521, -7772.5444);
	at[189] = 12.6000;
	points[190] = (6594.6855, 6523.0312, 1806.9882);
	angles[190] = (0, 8.8521, -7842.0098);
	at[190] = 12.6667;
	points[191] = (6587.4019, 6569.7246, 1673.0708);
	angles[191] = (0, 8.8521, -7911.4756);
	at[191] = 12.7333;
	points[192] = (6580.1577, 6616.4175, 1529.7047);
	angles[192] = (0, 8.8521, -7980.9409);
	at[192] = 12.8000;
	points[193] = (6572.8740, 6663.0713, 1376.8898);
	angles[193] = (0, 8.8521, -8050.4067);
	at[193] = 12.8667;
	points[194] = (6565.5908, 6709.7637, 1214.6260);
	angles[194] = (0, 8.8521, -8119.8726);
	at[194] = 12.9333;
	points[195] = (6558.3467, 6756.4565, 1042.9133);
	angles[195] = (0, 8.8521, -8189.3374);
	at[195] = 13;
	points[196] = (6551.0630, 6803.1499, 861.7520);
	angles[196] = (0, 8.8521, -8258.8027);
	at[196] = 13.0667;
	points[197] = (6543.7798, 6849.8032, 671.1378);
	angles[197] = (0, 8.8521, -8328.2686);
	at[197] = 13.1333;
	points[198] = (6536.5356, 6896.4966, 471.0787);
	angles[198] = (0, 8.8521, -8397.7344);
	at[198] = 13.2000;
	points[199] = (6529.2520, 6943.1890, 261.5717);
	angles[199] = (0, 8.8521, -8467.2002);
	at[199] = 13.2667;
	points[200] = (6521.9688, 6989.8428, 42.6142);
	angles[200] = (0, 8.8521, -8536.6650);
	at[200] = 13.3333;
	points[201] = (6514.7246, 7036.5352, -185.7917);
	angles[201] = (0, 8.8521, -8606.1309);
	at[201] = 13.4000;
	points[202] = (6507.4409, 7083.2285, -423.6457);
	angles[202] = (0, 8.8521, -8675.5967);
	at[202] = 13.4667;
	points[203] = (6500.1577, 7129.9214, -670.9489);
	angles[203] = (0, 8.8521, -8745.0625);
	at[203] = 13.5333;
	points[204] = (6492.9136, 7176.5752, -927.7047);
	angles[204] = (0, 8.8521, -8814.5273);
	at[204] = 13.6000;
	points[205] = (6485.6299, 7223.2676, -1193.9055);
	angles[205] = (0, 8.8521, -8883.9932);
	at[205] = 13.6667;
	points[206] = (6478.3467, 7269.9604, -1469.5551);
	angles[206] = (0, 8.8521, -8953.4590);
	at[206] = 13.7333;
	points[207] = (6471.1025, 7316.6143, -1754.6536);
	angles[207] = (0, 8.8521, -9022.9238);
	at[207] = 13.8000;
	points[208] = (6463.8188, 7363.3071, -2049.2009);
	angles[208] = (0, 8.8521, -9092.3896);
	at[208] = 13.8667;
	points[209] = (6456.5356, 7410, -2353.1968);
	angles[209] = (0, 8.8521, -9161.8555);
	at[209] = 13.9333;
	points[210] = (6449.2915, 7456.6538, -2666.6416);
	angles[210] = (0, 8.8521, -9231.3203);
	at[210] = 14;
	points[211] = (6442.0078, 7503.3467, -2989.5354);
	angles[211] = (0, 8.8521, -9300.7861);
	at[211] = 14.0667;
	points[212] = (6434.7246, 7550.0396, -3321.8821);
	angles[212] = (0, 8.8521, -9370.2520);
	at[212] = 14.1333;
	points[213] = (6427.4800, 7596.7324, -3663.6731);
	angles[213] = (0, 8.8521, -9439.7178);
	at[213] = 14.2000;
	points[214] = (6425.6694, 7608.3862, -3750.5945);
	angles[214] = (0, 8.8521, -9457.0840);
	at[214] = 14.2333;
	points[215] = (7015.4722, 2212.5276, 9810.5117);
	angles[215] = (0, 8.8521, -9457.0840);
	at[215] = 14.2333;
	points[216] = (7015.4722, 2212.5276, 9833.5439);
	angles[216] = (0, 8.8389, -9295.1016);
	at[216] = 14.2667;
	points[217] = (7014.9214, 2216.0039, 9855.9844);
	angles[217] = (0, 8.8389, -9298.1016);
	at[217] = 14.2833;
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
	points[0] = (8039.2129, 2220.8386, 9925);
	angles[0] = (0, -1.6941, 102.2840);
	at[0] = 0;
	points[1] = (8039.5273, 2231.9724, 10008.8584);
	angles[1] = (0, -1.6941, 90.2820);
	at[1] = 0.0667;
	points[2] = (8039.8428, 2243.1062, 10083.2676);
	angles[2] = (0, -1.6941, 78.2801);
	at[2] = 0.1333;
	points[3] = (8040.1968, 2254.2402, 10148.2295);
	angles[3] = (0, -1.6941, 66.2782);
	at[3] = 0.2000;
	points[4] = (8040.5122, 2265.3740, 10203.7402);
	angles[4] = (0, -1.6941, 54.2763);
	at[4] = 0.2667;
	points[5] = (8040.8267, 2276.5078, 10249.8037);
	angles[5] = (0, -1.6941, 42.2744);
	at[5] = 0.3333;
	points[6] = (8041.1812, 2287.6458, 10286.4170);
	angles[6] = (0, -1.6941, 30.2725);
	at[6] = 0.4000;
	points[7] = (8041.4961, 2298.7795, 10313.5830);
	angles[7] = (0, -1.6941, 18.2706);
	at[7] = 0.4667;
	points[8] = (8041.8110, 2309.9133, 10331.2998);
	angles[8] = (0, -1.6941, 6.2687);
	at[8] = 0.5333;
	points[9] = (8042.1655, 2321.0474, 10339.5674);
	angles[9] = (0, -1.6941, -5.7332);
	at[9] = 0.6000;
	points[10] = (8042.4805, 2332.1812, 10338.3857);
	angles[10] = (0, -1.6941, -17.7351);
	at[10] = 0.6667;
	points[11] = (8042.8345, 2343.3149, 10327.7568);
	angles[11] = (0, -1.6941, -29.7370);
	at[11] = 0.7333;
	points[12] = (8043.1499, 2354.4490, 10307.6777);
	angles[12] = (0, -1.6941, -41.7389);
	at[12] = 0.8000;
	points[13] = (8043.4648, 2365.5828, 10278.1494);
	angles[13] = (0, -1.6941, -53.7407);
	at[13] = 0.8667;
	points[14] = (8043.8193, 2376.7166, 10239.1738);
	angles[14] = (0, -1.6941, -65.7427);
	at[14] = 0.9333;
	points[15] = (8044.1338, 2387.8506, 10190.7480);
	angles[15] = (0, -1.6941, -77.7446);
	at[15] = 1;
	points[16] = (8044.4487, 2398.9844, 10132.8740);
	angles[16] = (0, -1.6941, -89.7466);
	at[16] = 1.0667;
	points[17] = (8044.8032, 2410.1182, 10065.5508);
	angles[17] = (0, -1.6941, -101.7483);
	at[17] = 1.1333;
	points[18] = (8045.1182, 2421.2520, 9988.7793);
	angles[18] = (0, -1.6941, -113.7502);
	at[18] = 1.2000;
	points[19] = (8045.4331, 2432.3860, 9902.5586);
	angles[19] = (0, -1.6941, -125.7521);
	at[19] = 1.2667;
	points[20] = (8045.7876, 2443.5198, 9806.8896);
	angles[20] = (0, -1.6941, -137.7541);
	at[20] = 1.3333;
	points[21] = (8046.1025, 2454.6536, 9701.7715);
	angles[21] = (0, -1.6941, -149.7560);
	at[21] = 1.4000;
	points[22] = (8046.4570, 2465.7874, 9587.2051);
	angles[22] = (0, -1.6941, -161.7579);
	at[22] = 1.4667;
	points[23] = (8046.7720, 2476.9211, 9463.1895);
	angles[23] = (0, -1.6941, -173.7598);
	at[23] = 1.5333;
	points[24] = (8047.0864, 2488.0552, 9329.7246);
	angles[24] = (0, -1.6941, -185.7617);
	at[24] = 1.6000;
	points[25] = (8047.4409, 2499.1890, 9186.8115);
	angles[25] = (0, -1.6941, -197.7635);
	at[25] = 1.6667;
	points[26] = (8047.7559, 2510.3228, 9034.4492);
	angles[26] = (0, -1.6941, -209.7655);
	at[26] = 1.7333;
	points[27] = (8048.0713, 2521.4565, 8872.6377);
	angles[27] = (0, -1.6941, -221.7673);
	at[27] = 1.8000;
	points[28] = (8048.4248, 2532.5906, 8701.3779);
	angles[28] = (0, -1.6941, -233.7693);
	at[28] = 1.8667;
	points[29] = (8048.7402, 2543.7246, 8520.6699);
	angles[29] = (0, -1.6941, -245.7711);
	at[29] = 1.9333;
	points[30] = (8049.0947, 2554.8584, 8330.5117);
	angles[30] = (0, -1.6941, -257.7730);
	at[30] = 2;
	points[31] = (8049.4097, 2565.9922, 8130.9053);
	angles[31] = (0, -1.6941, -269.7749);
	at[31] = 2.0667;
	points[32] = (8049.7246, 2577.1260, 7921.8506);
	angles[32] = (0, -1.6941, -281.7768);
	at[32] = 2.1333;
	points[33] = (8050.0786, 2588.2598, 7703.3462);
	angles[33] = (0, -1.6941, -293.7789);
	at[33] = 2.2000;
	points[34] = (8050.3936, 2599.3936, 7475.3936);
	angles[34] = (0, -1.6941, -305.7807);
	at[34] = 2.2667;
	points[35] = (8050.7090, 2610.5278, 7237.9922);
	angles[35] = (0, -1.6941, -317.7827);
	at[35] = 2.3333;
	points[36] = (8051.0630, 2621.6616, 6991.1416);
	angles[36] = (0, -1.6941, -329.7845);
	at[36] = 2.4000;
	points[37] = (8051.3784, 2632.7954, 6905.1577);
	angles[37] = (0, -1.6941, -351.8841);
	at[37] = 2.4667;
	points[38] = (8051.6929, 2643.9292, 6971.0630);
	angles[38] = (0, -1.6941, -377.3497);
	at[38] = 2.5333;
	points[39] = (8052.0474, 2655.0630, 7027.5195);
	angles[39] = (0, -1.6941, -402.8153);
	at[39] = 2.6000;
	points[40] = (8052.3623, 2666.1968, 7074.5273);
	angles[40] = (0, -1.6941, -428.2809);
	at[40] = 2.6667;
	points[41] = (8052.6772, 2677.3308, 7112.0869);
	angles[41] = (0, -1.6941, -453.7464);
	at[41] = 2.7333;
	points[42] = (8053.0312, 2688.4646, 7140.1968);
	angles[42] = (0, -1.6941, -479.2120);
	at[42] = 2.8000;
	points[43] = (8053.3462, 2699.5984, 7158.8584);
	angles[43] = (0, -1.6941, -504.6776);
	at[43] = 2.8667;
	points[44] = (8053.7007, 2710.7324, 7168.0708);
	angles[44] = (0, -1.6941, -530.1431);
	at[44] = 2.9333;
	points[45] = (8054.0161, 2721.8662, 7167.8350);
	angles[45] = (0, -1.6941, -555.6087);
	at[45] = 3;
	points[46] = (8054.3311, 2733, 7158.1499);
	angles[46] = (0, -1.6941, -581.0742);
	at[46] = 3.0667;
	points[47] = (8054.6855, 2744.1338, 7139.0156);
	angles[47] = (0, -1.6941, -606.5399);
	at[47] = 3.1333;
	points[48] = (8055, 2755.2678, 7110.4331);
	angles[48] = (0, -1.6941, -632.0053);
	at[48] = 3.2000;
	points[49] = (8055.3149, 2766.4016, 7072.4019);
	angles[49] = (0, -1.6941, -657.4710);
	at[49] = 3.2667;
	points[50] = (8055.6694, 2777.5354, 7024.9214);
	angles[50] = (0, -1.6941, -682.9365);
	at[50] = 3.3333;
	points[51] = (8055.9839, 2788.6692, 6967.9922);
	angles[51] = (0, -1.6941, -708.4021);
	at[51] = 3.4000;
	points[52] = (8056.3384, 2799.8030, 6901.6143);
	angles[52] = (0, -1.6941, -733.8677);
	at[52] = 3.4667;
	points[53] = (8056.6538, 2810.9370, 6825.7876);
	angles[53] = (0, -1.6941, -759.3333);
	at[53] = 3.5333;
	points[54] = (8056.9688, 2822.0710, 6740.5117);
	angles[54] = (0, -1.6941, -784.7987);
	at[54] = 3.6000;
	points[55] = (8057.3232, 2833.2048, 6645.7871);
	angles[55] = (0, -1.6941, -810.2644);
	at[55] = 3.6667;
	points[56] = (8057.6382, 2844.3386, 6590.3545);
	angles[56] = (0, -1.6941, -837.7302);
	at[56] = 3.7333;
	points[57] = (8057.9526, 2855.4724, 6613.7012);
	angles[57] = (0, -1.6941, -867.1964);
	at[57] = 3.8000;
	points[58] = (8058.3071, 2866.6062, 6627.5986);
	angles[58] = (0, -1.6941, -896.6627);
	at[58] = 3.8667;
	points[59] = (8058.6221, 2877.7400, 6632.0469);
	angles[59] = (0, -1.6941, -926.1288);
	at[59] = 3.9333;
	points[60] = (8058.9375, 2888.8743, 6627.0474);
	angles[60] = (0, -1.6941, -955.5949);
	at[60] = 4;
	points[61] = (8059.2910, 2900.0081, 6612.5591);
	angles[61] = (0, -1.6941, -985.0612);
	at[61] = 4.0667;
	points[62] = (8059.6064, 2911.1418, 6588.6616);
	angles[62] = (0, -1.6941, -1014.5274);
	at[62] = 4.1333;
	points[63] = (8059.9609, 2922.2756, 6555.3154);
	angles[63] = (0, -1.6941, -1043.9937);
	at[63] = 4.2000;
	points[64] = (8060.2759, 2933.4094, 6512.5195);
	angles[64] = (0, -1.6941, -1073.4598);
	at[64] = 4.2667;
	points[65] = (8060.5908, 2944.5432, 6460.2759);
	angles[65] = (0, -1.6941, -1102.9260);
	at[65] = 4.3333;
	points[66] = (8060.9448, 2955.6772, 6445.7085);
	angles[66] = (0, -1.6941, -1135.3927);
	at[66] = 4.4000;
	points[67] = (8061.2598, 2966.8110, 6453.2285);
	angles[67] = (0, -1.6941, -1168.8595);
	at[67] = 4.4667;
	points[68] = (8061.5752, 2977.9451, 6451.3384);
	angles[68] = (0, -1.6941, -1202.3263);
	at[68] = 4.5333;
	points[69] = (8061.9292, 2989.0789, 6439.9604);
	angles[69] = (0, -1.6941, -1235.7932);
	at[69] = 4.6000;
	points[70] = (8062.2446, 3000.2126, 6419.1343);
	angles[70] = (0, -1.6941, -1269.2600);
	at[70] = 4.6667;
	points[71] = (8062.5591, 3011.3464, 6388.8579);
	angles[71] = (0, -1.6941, -1302.7268);
	at[71] = 4.7333;
	points[72] = (8062.9136, 3022.4805, 6349.1343);
	angles[72] = (0, -1.6941, -1336.1937);
	at[72] = 4.8000;
	points[73] = (8063.2285, 3033.6143, 6345);
	angles[73] = (0, -1.6941, -1373.6611);
	at[73] = 4.8667;
	points[74] = (8063.5830, 3044.7480, 6345.7085);
	angles[74] = (0, -1.6941, -1411.1287);
	at[74] = 4.9333;
	points[75] = (8063.8975, 3055.8818, 6336.9287);
	angles[75] = (0, -1.6941, -1448.5961);
	at[75] = 5;
	points[76] = (8064.2124, 3067.0156, 6318.7402);
	angles[76] = (0, -1.6941, -1486.0636);
	at[76] = 5.0667;
	points[77] = (8064.5669, 3078.1497, 6291.0630);
	angles[77] = (0, -1.6941, -1523.5310);
	at[77] = 5.1333;
	points[78] = (8064.8823, 3089.2834, 6253.9766);
	angles[78] = (0, -1.6941, -1560.9985);
	at[78] = 5.2000;
	points[79] = (8065.5513, 3111.5513, 6255.3149);
	angles[79] = (0, -1.6941, -1643.9347);
	at[79] = 5.3333;
	points[80] = (8065.8662, 3122.6851, 6245.7480);
	angles[80] = (0, -1.6941, -1685.4027);
	at[80] = 5.4000;
	points[81] = (8066.1812, 3133.8188, 6226.7720);
	angles[81] = (0, -1.6941, -1726.8708);
	at[81] = 5.4667;
	points[82] = (8067.9922, 3152.7166, 6198.3467);
	angles[82] = (0, -7.0135, -1768.3391);
	at[82] = 5.5333;
	points[83] = (8071.3384, 3179.8425, 6160.4336);
	angles[83] = (0, -7.0135, -1809.8071);
	at[83] = 5.6000;
	points[84] = (8074.6455, 3206.9646, 6113.1104);
	angles[84] = (0, -7.0135, -1851.2751);
	at[84] = 5.6667;
	points[85] = (8077.9922, 3234.0906, 6056.3384);
	angles[85] = (0, -7.0135, -1892.7433);
	at[85] = 5.7333;
	points[86] = (8081.3389, 3261.2126, 6056.7715);
	angles[86] = (0, -7.0135, -1938.2051);
	at[86] = 5.8000;
	points[87] = (8084.6851, 3288.3389, 6062.5591);
	angles[87] = (0, -7.0135, -1983.6667);
	at[87] = 5.8667;
	points[88] = (8087.9922, 3315.4646, 6058.9370);
	angles[88] = (0, -7.0135, -2029.1284);
	at[88] = 5.9333;
	points[89] = (8091.3389, 3342.5867, 6045.8662);
	angles[89] = (0, -7.0135, -2074.5903);
	at[89] = 6;
	points[90] = (8094.6851, 3369.7126, 6023.3462);
	angles[90] = (0, -7.0135, -2120.0520);
	at[90] = 6.0667;
	points[91] = (8098.0317, 3396.8347, 5991.3384);
	angles[91] = (0, -7.0135, -2165.5137);
	at[91] = 6.1333;
	points[92] = (8101.3389, 3423.9604, 5949.9214);
	angles[92] = (0, -7.0135, -2210.9753);
	at[92] = 6.2000;
	points[93] = (8104.6851, 3451.0828, 5899.0552);
	angles[93] = (0, -7.0135, -2256.4373);
	at[93] = 6.2667;
	points[94] = (8108.0317, 3478.2085, 5838.7007);
	angles[94] = (0, -7.0135, -2301.8989);
	at[94] = 6.3333;
	points[95] = (8111.3784, 3505.3308, 5768.9375);
	angles[95] = (0, -7.0135, -2347.3606);
	at[95] = 6.4000;
	points[96] = (8114.6855, 3532.4568, 5689.7246);
	angles[96] = (0, -7.0135, -2392.8225);
	at[96] = 6.4667;
	points[97] = (8118.0317, 3559.5789, 5601.0630);
	angles[97] = (0, -7.0135, -2438.2842);
	at[97] = 6.5333;
	points[98] = (8121.3784, 3586.7048, 5600.9058);
	angles[98] = (0, -7.0135, -2487.7466);
	at[98] = 6.6000;
	points[99] = (8124.7241, 3613.8267, 5616.2993);
	angles[99] = (0, -7.0135, -2537.2090);
	at[99] = 6.6667;
	points[100] = (8128.0713, 3640.9529, 5622.2046);
	angles[100] = (0, -7.0135, -2586.6714);
	at[100] = 6.7333;
	points[101] = (8131.3779, 3668.0747, 5618.7007);
	angles[101] = (0, -7.0135, -2636.1338);
	at[101] = 6.8000;
	points[102] = (8134.7241, 3695.2009, 5605.7480);
	angles[102] = (0, -7.0135, -2685.5959);
	at[102] = 6.8667;
	points[103] = (8138.0708, 3722.3228, 5583.3467);
	angles[103] = (0, -7.0135, -2735.0583);
	at[103] = 6.9333;
	points[104] = (8141.4175, 3749.4490, 5551.4570);
	angles[104] = (0, -7.0135, -2784.5208);
	at[104] = 7;
	points[105] = (8144.7246, 3776.5708, 5510.1572);
	angles[105] = (0, -7.0135, -2833.9832);
	at[105] = 7.0667;
	points[106] = (8148.0708, 3803.6968, 5459.4097);
	angles[106] = (0, -7.0135, -2883.4456);
	at[106] = 7.1333;
	points[107] = (8151.4175, 3830.8191, 5399.1738);
	angles[107] = (0, -7.0135, -2932.9080);
	at[107] = 7.2000;
	points[108] = (8153.8584, 3857.8977, 5329.5273);
	angles[108] = (0, -1.2891, -2982.3704);
	at[108] = 7.2667;
	points[109] = (8154.4878, 3884.8821, 5250.4326);
	angles[109] = (0, -1.2891, -3031.8328);
	at[109] = 7.3333;
	points[110] = (8155.0791, 3911.8660, 5161.8501);
	angles[110] = (0, -1.2891, -3081.2952);
	at[110] = 7.4000;
	points[111] = (8155.7085, 3938.8582, 5063.8579);
	angles[111] = (0, -1.2891, -3130.7576);
	at[111] = 7.4667;
	points[112] = (8156.2993, 3965.8269, 5058.5039);
	angles[112] = (0, -1.2891, -3184.2205);
	at[112] = 7.5333;
	points[113] = (8156.8896, 3992.8347, 5076.6538);
	angles[113] = (0, -1.2891, -3237.6833);
	at[113] = 7.6000;
	points[114] = (8157.5200, 4019.8030, 5085.3940);
	angles[114] = (0, -1.2891, -3291.1465);
	at[114] = 7.6667;
	points[115] = (8158.1104, 4046.7717, 5084.6851);
	angles[115] = (0, -1.2891, -3344.6094);
	at[115] = 7.7333;
	points[116] = (8158.7402, 4073.7795, 5074.5278);
	angles[116] = (0, -1.2891, -3398.0723);
	at[116] = 7.8000;
	points[117] = (8159.3306, 4100.7480, 5054.9214);
	angles[117] = (0, -1.2891, -3451.5354);
	at[117] = 7.8667;
	points[118] = (8159.9609, 4127.7168, 5025.8267);
	angles[118] = (0, -1.2891, -3504.9983);
	at[118] = 7.9333;
	points[119] = (8160.5513, 4154.7246, 4987.3228);
	angles[119] = (0, -1.2891, -3558.4614);
	at[119] = 8;
	points[120] = (8161.1416, 4181.6929, 4939.3701);
	angles[120] = (0, -1.2891, -3611.9243);
	at[120] = 8.0667;
	points[121] = (8161.7720, 4208.7007, 4881.9688);
	angles[121] = (0, -1.2891, -3665.3875);
	at[121] = 8.1333;
	points[122] = (8162.3623, 4235.6694, 4815.0786);
	angles[122] = (0, -1.2891, -3718.8506);
	at[122] = 8.2000;
	points[123] = (8162.9922, 4262.6382, 4738.7793);
	angles[123] = (0, -1.2891, -3772.3135);
	at[123] = 8.2667;
	points[124] = (8163.5825, 4289.6455, 4653.0312);
	angles[124] = (0, -1.2891, -3825.7764);
	at[124] = 8.3333;
	points[125] = (8164.1733, 4316.6143, 4557.8345);
	angles[125] = (0, -1.2891, -3879.2395);
	at[125] = 8.4000;
	points[126] = (8164.8032, 4343.5830, 4467.9922);
	angles[126] = (0, -1.2891, -3933.7026);
	at[126] = 8.4667;
	points[127] = (8165.3940, 4370.5908, 4494.5278);
	angles[127] = (0, -1.2891, -3991.1663);
	at[127] = 8.5333;
	points[128] = (8166.0239, 4397.5591, 4511.6538);
	angles[128] = (0, -1.2891, -4048.6299);
	at[128] = 8.6000;
	points[129] = (8166.6147, 4424.5669, 4519.2915);
	angles[129] = (0, -1.2891, -4106.0938);
	at[129] = 8.6667;
	points[130] = (8167.2441, 4451.5356, 4517.5200);
	angles[130] = (0, -1.2891, -4163.5571);
	at[130] = 8.7333;
	points[131] = (8167.8345, 4478.5039, 4506.2598);
	angles[131] = (0, -1.2891, -4221.0210);
	at[131] = 8.8000;
	points[132] = (8168.4253, 4505.5117, 4485.5903);
	angles[132] = (0, -1.2891, -4278.4844);
	at[132] = 8.8667;
	points[133] = (8169.0552, 4532.4805, 4455.4331);
	angles[133] = (0, -1.2891, -4335.9482);
	at[133] = 8.9333;
	points[134] = (8169.6460, 4559.4883, 4415.8662);
	angles[134] = (0, -1.2891, -4393.4116);
	at[134] = 9;
	points[135] = (8170.2754, 4586.4570, 4366.8110);
	angles[135] = (0, -1.2891, -4450.8755);
	at[135] = 9.0667;
	points[136] = (8170.8662, 4613.4253, 4308.3071);
	angles[136] = (0, -1.2891, -4508.3389);
	at[136] = 9.1333;
	points[137] = (8171.4961, 4640.4331, 4240.3940);
	angles[137] = (0, -1.2891, -4565.8027);
	at[137] = 9.2000;
	points[138] = (8172.0869, 4667.4019, 4162.9922);
	angles[138] = (0, -1.2891, -4623.2661);
	at[138] = 9.2667;
	points[139] = (8172.6772, 4694.3701, 4076.1814);
	angles[139] = (0, -1.2891, -4680.7300);
	at[139] = 9.3333;
	points[140] = (8173.8979, 4748.3467, 3885.6770);
	angles[140] = (0, -1.2891, -4796.6572);
	at[140] = 9.4667;
	points[141] = (8174.5273, 4775.3545, 3912.5552);
	angles[141] = (0, -1.2891, -4858.1216);
	at[141] = 9.5333;
	points[142] = (8175.1182, 4802.3228, 3929.9805);
	angles[142] = (0, -1.2891, -4919.5859);
	at[142] = 9.6000;
	points[143] = (8175.5122, 4830.1572, 3937.9529);
	angles[143] = (0, 0.3593, -4981.0503);
	at[143] = 9.6667;
	points[144] = (8175.3149, 4860.0396, 3936.4922);
	angles[144] = (0, 0.3593, -5042.5146);
	at[144] = 9.7333;
	points[145] = (8175.1182, 4889.9214, 3925.5750);
	angles[145] = (0, 0.3593, -5103.9785);
	at[145] = 9.8000;
	points[146] = (8174.9214, 4919.8032, 3905.2048);
	angles[146] = (0, 0.3593, -5165.4429);
	at[146] = 9.8667;
	points[147] = (8174.7642, 4949.6851, 3875.3896);
	angles[147] = (0, 0.3593, -5226.9072);
	at[147] = 9.9333;
	points[148] = (8174.5669, 4979.5669, 3836.1260);
	angles[148] = (0, 0.3593, -5288.3716);
	at[148] = 10;
	points[149] = (8174.3701, 5009.4487, 3787.4136);
	angles[149] = (0, 0.3593, -5349.8359);
	at[149] = 10.0667;
	points[150] = (8174.1729, 5039.3306, 3729.2480);
	angles[150] = (0, 0.3593, -5411.3003);
	at[150] = 10.1333;
	points[151] = (8174.0156, 5069.2124, 3661.6379);
	angles[151] = (0, 0.3593, -5472.7646);
	at[151] = 10.2000;
	points[152] = (8173.8193, 5099.0947, 3584.5789);
	angles[152] = (0, 0.3593, -5534.2285);
	at[152] = 10.2667;
	points[153] = (8173.6221, 5128.9766, 3498.0708);
	angles[153] = (0, 0.3593, -5595.6929);
	at[153] = 10.3333;
	points[154] = (8173.4253, 5158.8584, 3402.1140);
	angles[154] = (0, 0.3593, -5657.1572);
	at[154] = 10.4000;
	points[155] = (8173.2285, 5188.7402, 3296.7046);
	angles[155] = (0, 0.3593, -5718.6216);
	at[155] = 10.4667;
	points[156] = (8173.0708, 5218.6221, 3299.9529);
	angles[156] = (0, 0.3593, -5784.0864);
	at[156] = 10.5333;
	points[157] = (8172.8740, 5248.4648, 3320.3542);
	angles[157] = (0, 0.3593, -5849.5513);
	at[157] = 10.6000;
	points[158] = (8172.6772, 5278.3467, 3331.3069);
	angles[158] = (0, 0.3593, -5915.0161);
	at[158] = 10.6667;
	points[159] = (8172.4800, 5308.2280, 3332.8110);
	angles[159] = (0, 0.3593, -5980.4810);
	at[159] = 10.7333;
	points[160] = (8172.3228, 5338.1104, 3324.8662);
	angles[160] = (0, 0.3593, -6045.9458);
	at[160] = 10.8000;
	points[161] = (8172.1265, 5367.9922, 3307.4727);
	angles[161] = (0, 0.3593, -6111.4106);
	at[161] = 10.8667;
	points[162] = (8171.9292, 5397.8740, 3280.6301);
	angles[162] = (0, 0.3593, -6176.8755);
	at[162] = 10.9333;
	points[163] = (8171.7324, 5427.7563, 3244.3384);
	angles[163] = (0, 0.3593, -6242.3408);
	at[163] = 11;
	points[164] = (8171.5747, 5457.6377, 3198.5984);
	angles[164] = (0, 0.3593, -6307.8057);
	at[164] = 11.0667;
	points[165] = (8171.3779, 5487.5195, 3143.4094);
	angles[165] = (0, 0.3593, -6373.2705);
	at[165] = 11.1333;
	points[166] = (8171.1812, 5517.4014, 3078.7717);
	angles[166] = (0, 0.3593, -6438.7354);
	at[166] = 11.2000;
	points[167] = (8170.9844, 5547.2837, 3004.6851);
	angles[167] = (0, 0.3593, -6504.2002);
	at[167] = 11.2667;
	points[168] = (8170.8271, 5577.1655, 2921.1494);
	angles[168] = (0, 0.3593, -6569.6650);
	at[168] = 11.3333;
	points[169] = (8170.6299, 5607.0474, 2828.1655);
	angles[169] = (0, 0.3593, -6635.1299);
	at[169] = 11.4000;
	points[170] = (8170.4336, 5636.9292, 2797.5435);
	angles[170] = (0, 0.3593, -6703.5952);
	at[170] = 11.4667;
	points[171] = (8170.2363, 5666.8110, 2817.2874);
	angles[171] = (0, 0.3593, -6773.0610);
	at[171] = 11.5333;
	points[172] = (8170.0791, 5696.6929, 2827.5828);
	angles[172] = (0, -2.7522, -6842.5264);
	at[172] = 11.6000;
	points[173] = (8172.1265, 5736.0630, 2828.4331);
	angles[173] = (0, -2.7522, -6911.9922);
	at[173] = 11.6667;
	points[174] = (8173.9766, 5774.6064, 2819.8308);
	angles[174] = (0, -2.7522, -6981.4575);
	at[174] = 11.7333;
	points[175] = (8175.8267, 5813.1104, 2801.7795);
	angles[175] = (0, -2.7522, -7050.9233);
	at[175] = 11.8000;
	points[176] = (8177.6772, 5851.6538, 2774.2834);
	angles[176] = (0, -2.7522, -7120.3887);
	at[176] = 11.8667;
	points[177] = (8179.5273, 5890.1968, 2737.3345);
	angles[177] = (0, -2.7522, -7189.8540);
	at[177] = 11.9333;
	points[178] = (8181.3784, 5928.7012, 2690.9370);
	angles[178] = (0, -2.7522, -7259.3198);
	at[178] = 12;
	points[179] = (8183.2285, 5967.2441, 2635.0945);
	angles[179] = (0, -2.7522, -7328.7852);
	at[179] = 12.0667;
	points[180] = (8185.0791, 6005.7876, 2569.7993);
	angles[180] = (0, -2.7522, -7398.2510);
	at[180] = 12.1333;
	points[181] = (8186.9292, 6044.2910, 2495.0552);
	angles[181] = (0, -2.7522, -7467.7163);
	at[181] = 12.2000;
	points[182] = (8188.7793, 6082.8345, 2410.8662);
	angles[182] = (0, -2.7522, -7537.1821);
	at[182] = 12.2667;
	points[183] = (8190.6304, 6121.3779, 2383.7009);
	angles[183] = (0, -2.7522, -7609.6479);
	at[183] = 12.3333;
	points[184] = (8192.4805, 6159.8818, 2400.8071);
	angles[184] = (0, -2.7522, -7683.1143);
	at[184] = 12.4000;
	points[185] = (8194.3311, 6198.4253, 2408.4646);
	angles[185] = (0, -2.7522, -7756.5801);
	at[185] = 12.4667;
	points[186] = (8196.1807, 6236.9688, 2406.6772);
	angles[186] = (0, -2.7522, -7830.0464);
	at[186] = 12.5333;
	points[187] = (8198.0312, 6275.4727, 2395.4370);
	angles[187] = (0, -2.7522, -7903.5127);
	at[187] = 12.6000;
	points[188] = (8199.8818, 6314.0161, 2374.7480);
	angles[188] = (0, -2.7522, -7976.9785);
	at[188] = 12.6667;
	points[189] = (8201.7324, 6352.5591, 2344.6104);
	angles[189] = (0, -2.7522, -8050.4448);
	at[189] = 12.7333;
	points[190] = (8203.5830, 6391.0630, 2305.0276);
	angles[190] = (0, -2.7522, -8123.9116);
	at[190] = 12.8000;
	points[191] = (8205.4336, 6429.6064, 2255.9922);
	angles[191] = (0, -2.7522, -8197.3770);
	at[191] = 12.8667;
	points[192] = (8207.3232, 6468.1499, 2197.5078);
	angles[192] = (0, -2.7522, -8270.8438);
	at[192] = 12.9333;
	points[193] = (8209.1738, 6506.6533, 2129.5789);
	angles[193] = (0, -2.7522, -8344.3096);
	at[193] = 13;
	points[194] = (8211.0234, 6545.1968, 2105.0747);
	angles[194] = (0, -2.7522, -8420.7764);
	at[194] = 13.0667;
	points[195] = (8212.8740, 6583.7402, 2117.3032);
	angles[195] = (0, -2.7522, -8498.2432);
	at[195] = 13.1333;
	points[196] = (8214.7246, 6622.2441, 2120.0867);
	angles[196] = (0, -2.7522, -8575.7100);
	at[196] = 13.2000;
	points[197] = (8216.5752, 6660.7876, 2113.4175);
	angles[197] = (0, -2.7522, -8653.1768);
	at[197] = 13.2667;
	points[198] = (8218.4258, 6699.3306, 2097.2993);
	angles[198] = (0, -18.5613, -8730.6436);
	at[198] = 13.3333;
	points[199] = (8235.1182, 6743.2681, 2071.7363);
	angles[199] = (0, -18.5613, -8808.1104);
	at[199] = 13.4000;
	points[200] = (8249.6064, 6786.4570, 2036.7205);
	angles[200] = (0, -18.5613, -8885.5771);
	at[200] = 13.4667;
	points[201] = (8264.0947, 6829.6064, 1992.2599);
	angles[201] = (0, -18.5613, -8963.0439);
	at[201] = 13.5333;
	points[202] = (8278.5830, 6872.7559, 1938.3466);
	angles[202] = (0, -18.5612, -9040.5107);
	at[202] = 13.6000;
	points[203] = (8293.0713, 6915.9058, 1874.9843);
	angles[203] = (0, -18.5612, -9117.9775);
	at[203] = 13.6667;
	points[204] = (8307.5986, 6959.0552, 1802.1771);
	angles[204] = (0, -18.5613, -9195.4443);
	at[204] = 13.7333;
	points[205] = (8322.0869, 7002.2051, 1719.9174);
	angles[205] = (0, -18.5613, -9272.9111);
	at[205] = 13.8000;
	points[206] = (8336.5742, 7045.3940, 1628.2086);
	angles[206] = (0, -18.5613, -9350.3779);
	at[206] = 13.8667;
	points[207] = (8351.0635, 7088.5435, 1527.0552);
	angles[207] = (0, -18.5612, -9427.8447);
	at[207] = 13.9333;
	points[208] = (8365.5518, 7131.6934, 1416.4487);
	angles[208] = (0, -18.5612, -9505.3115);
	at[208] = 14;
	points[209] = (8380.0391, 7174.8423, 1296.3937);
	angles[209] = (0, -18.5613, -9582.7783);
	at[209] = 14.0667;
	points[210] = (8394.5273, 7217.9927, 1166.8937);
	angles[210] = (0, -18.5612, -9660.2451);
	at[210] = 14.1333;
	points[211] = (8409.0156, 7261.1816, 1027.9409);
	angles[211] = (0, -18.5612, -9737.7119);
	at[211] = 14.2000;
	points[212] = (8423.5039, 7304.3306, 879.5433);
	angles[212] = (0, -18.5613, -9815.1787);
	at[212] = 14.2667;
	points[213] = (8437.9922, 7347.4805, 721.6929);
	angles[213] = (0, -18.5612, -9892.6455);
	at[213] = 14.3333;
	points[214] = (8452.4805, 7390.6299, 554.3937);
	angles[214] = (0, -18.5612, -9970.1123);
	at[214] = 14.4000;
	points[215] = (8466.9688, 7433.7793, 377.6480);
	angles[215] = (0, -18.5612, -10047.5791);
	at[215] = 14.4667;
	points[216] = (8481.4961, 7476.9683, 191.4527);
	angles[216] = (0, -18.5612, -10125.0459);
	at[216] = 14.5333;
	points[217] = (8495.9844, 7520.1182, -4.1913);
	angles[217] = (0, -18.5612, -10202.5127);
	at[217] = 14.6000;
	points[218] = (8510.4727, 7563.2676, -209.2843);
	angles[218] = (0, -18.5612, -10279.9795);
	at[218] = 14.6667;
	points[219] = (8514.0947, 7574.0552, -262.0339);
	angles[219] = (0, -18.5612, -10299.3467);
	at[219] = 14.7000;
	points[220] = (8039.0942, 2218.0552, 9879.5273);
	angles[220] = (0, -18.5612, -10299.3467);
	at[220] = 14.7000;
	points[221] = (8039.0942, 2218.0552, 9902.5586);
	angles[221] = (0, -1.6941, -10334.7158);
	at[221] = 14.7333;
	points[222] = (8039.2129, 2220.8386, 9925);
	angles[222] = (0, -1.6941, -10337.7158);
	at[222] = 14.7500;
	mover = getEnt("iz_obj_2", "targetname");
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
