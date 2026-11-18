main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_luigi_circuit", 0);

	setExpFog(7381.8896, 21991.8789, 0.8039, 0.6000, 0.4510, 0);

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
	ambientPlay("iz_0_56", 2);
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
	level.iz_route[level.iz_route.size] = (1697, -5593, 1562);
	level.iz_route[level.iz_route.size] = (1715, -4505, 1563);
	level.iz_route[level.iz_route.size] = (1660, -3175, 1441);
	level.iz_route[level.iz_route.size] = (1435, -2210, 1385);
	level.iz_route[level.iz_route.size] = (1064, -1300, 1259);
	level.iz_route[level.iz_route.size] = (457, -301, 1058);
	level.iz_route[level.iz_route.size] = (-167, 528, 842);
	level.iz_route[level.iz_route.size] = (-772, 1474, 640);
	level.iz_route[level.iz_route.size] = (-1169, 2396, 517);
	level.iz_route[level.iz_route.size] = (-1439, 3417, 421);
	level.iz_route[level.iz_route.size] = (-1481, 4488, 353);
	level.iz_route[level.iz_route.size] = (-1257, 5583, 313);
	level.iz_route[level.iz_route.size] = (-679, 6512, 297);
	level.iz_route[level.iz_route.size] = (149, 7071, 295);
	level.iz_route[level.iz_route.size] = (1139, 7513, 297);
	level.iz_route[level.iz_route.size] = (1803, 8075, 302);
	level.iz_route[level.iz_route.size] = (2247, 8939, 313);
	level.iz_route[level.iz_route.size] = (2263, 9962, 335);
	level.iz_route[level.iz_route.size] = (1834, 10877, 353);
	level.iz_route[level.iz_route.size] = (1008, 11488, 356);
	level.iz_route[level.iz_route.size] = (-11, 11665, 357);
	level.iz_route[level.iz_route.size] = (-962, 11348, 347);
	level.iz_route[level.iz_route.size] = (-1728, 10628, 329);
	level.iz_route[level.iz_route.size] = (-2045, 9758, 327);
	level.iz_route[level.iz_route.size] = (-2091, 8648, 357);
	level.iz_route[level.iz_route.size] = (-2026, 7568, 405);
	level.iz_route[level.iz_route.size] = (-1854, 6106, 306);
	level.iz_route[level.iz_route.size] = (-1724, 4665, 345);
	level.iz_route[level.iz_route.size] = (-1543, 3524, 412);
	level.iz_route[level.iz_route.size] = (-1307, 2586, 495);
	level.iz_route[level.iz_route.size] = (-926, 1612, 615);
	level.iz_route[level.iz_route.size] = (-442, 738, 780);
	level.iz_route[level.iz_route.size] = (209, -243, 1028);
	level.iz_route[level.iz_route.size] = (810, -1301, 1246);
	level.iz_route[level.iz_route.size] = (1156, -2274, 1387);
	level.iz_route[level.iz_route.size] = (1156, -3260, 1441);
	level.iz_route[level.iz_route.size] = (971, -4294, 1447);
	level.iz_route[level.iz_route.size] = (674, -5324, 1447);
	level.iz_route[level.iz_route.size] = (212, -6165, 1447);
	level.iz_route[level.iz_route.size] = (-540, -6995, 1451);
	level.iz_route[level.iz_route.size] = (-998, -7723, 1467);
	level.iz_route[level.iz_route.size] = (-1062, -8416, 1483);
	level.iz_route[level.iz_route.size] = (-693, -9087, 1501);
	level.iz_route[level.iz_route.size] = (-1, -9430, 1519);
	level.iz_route[level.iz_route.size] = (798, -9307, 1537);
	level.iz_route[level.iz_route.size] = (1356, -8768, 1554);
	level.iz_route[level.iz_route.size] = (1638, -7920, 1562);
	level.iz_route[level.iz_route.size] = (1677, -6802, 1562);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2197.6221, -7302.4019, 2873.3228);
	angles[0] = (0, 83.3186, 0);
	at[0] = 0;
	points[1] = (1962.5591, -7280.0791, 2869.6733);
	angles[1] = (0, 84.9836, 0);
	at[1] = 1.3333;
	points[2] = (1548.4055, -7247.1260, 2873.3582);
	angles[2] = (0, 85.4927, 0);
	at[2] = 3.6667;
	points[3] = (1493.3071, -7242.6377, 2873.4331);
	angles[3] = (0, 85.3867, 0);
	at[3] = 4;
	points[4] = (783.5788, -7186.0630, 2873.4331);
	angles[4] = (0, 85.7592, 0);
	at[4] = 8;
	points[5] = (610.1851, -7175, 2873.4331);
	angles[5] = (0, 86.4597, 0);
	at[5] = 9;
	points[6] = (-279.1937, -7125.2363, 2873.4331);
	angles[6] = (0, 86.8875, 0);
	at[6] = 14;
	points[7] = (-332.3922, -7122.2051, 2873.4331);
	angles[7] = (0, 86.7796, 0);
	at[7] = 14.3333;
	points[8] = (-924.7520, -7078.9766, 2873.4331);
	angles[8] = (0, 86.1363, 0);
	at[8] = 17.6667;
	points[9] = (-1219.3425, -7064.8818, 2873.4331);
	angles[9] = (0, 88.0681, 0);
	at[9] = 19.3333;
	points[10] = (-1340.0906, -7065.1577, 2873.4331);
	angles[10] = (0, 90.3950, 0);
	at[10] = 20;
	points[11] = (-1394.8739, -7069.1733, 2873.4331);
	angles[11] = (0, 93.1869, 0);
	at[11] = 20.3333;
	points[12] = (-1571.1812, -7089.9609, 2873.4331);
	angles[12] = (0, 96.8956, 0);
	at[12] = 21.3333;
	points[13] = (-1747.0079, -7116.5352, 2873.4331);
	angles[13] = (0, 99.0275, 0);
	at[13] = 22.3333;
	points[14] = (-1863.4095, -7138.7402, 2873.4331);
	angles[14] = (0, 100.8985, 0);
	at[14] = 23;
	points[15] = (-1978.6456, -7166.0635, 2873.4331);
	angles[15] = (0, 103.4898, 0);
	at[15] = 23.6667;
	points[16] = (-2091.3860, -7200.9453, 2873.4331);
	angles[16] = (0, 107.4840, 0);
	at[16] = 24.3333;
	points[17] = (-2147.6655, -7223.4253, 2873.4331);
	angles[17] = (0, 110.5362, 0);
	at[17] = 24.6667;
	points[18] = (-2200.1416, -7249.8823, 2873.4331);
	angles[18] = (0, 114.9219, 0);
	at[18] = 25;
	points[19] = (-2247.6458, -7282.9131, 2873.4331);
	angles[19] = (0, 122.0921, 0);
	at[19] = 25.3333;
	points[20] = (-2285.5828, -7328.7012, 2873.4331);
	angles[20] = (0, 135.4863, 0);
	at[20] = 25.6667;
	points[21] = (-2301.3936, -7379.3306, 2873.4331);
	angles[21] = (0, 153.5205, 0);
	at[21] = 26;
	points[22] = (-2310.4646, -7439.6851, 2873.4331);
	angles[22] = (0, 165.4198, 0);
	at[22] = 26.3333;
	points[23] = (-2315.5396, -7498.0312, 2873.4331);
	angles[23] = (0, 171.7330, 0);
	at[23] = 26.6667;
	points[24] = (-2318.6731, -7559.4487, 2873.4331);
	angles[24] = (0, 175.2955, 0);
	at[24] = 27;
	points[25] = (-2320.2009, -7616.5747, 2873.4331);
	angles[25] = (0, 177.4052, 0);
	at[25] = 27.3333;
	points[26] = (-2320.7166, -7677.5986, 2873.4331);
	angles[26] = (0, 178.8224, 0);
	at[26] = 27.6667;
	points[27] = (-2319.2087, -7795.1572, 2873.4331);
	angles[27] = (0, 180.7054, 0);
	at[27] = 28.3333;
	points[28] = (-2312.0393, -7973.5830, 2873.4331);
	angles[28] = (0, 182.6013, 0);
	at[28] = 29.3333;
	points[29] = (-2294.8701, -8210.6299, 2873.4331);
	angles[29] = (0, 184.6824, 0);
	at[29] = 30.6667;
	points[30] = (-2268.6731, -8445.5908, 2873.4331);
	angles[30] = (0, 187.0506, 0);
	at[30] = 32;
	points[31] = (-2250.5789, -8564.8428, 2873.4331);
	angles[31] = (0, 188.7269, 0);
	at[31] = 32.6667;
	points[32] = (-2240.5276, -8620.1973, 2873.4331);
	angles[32] = (0, 189.8235, 0);
	at[32] = 33;
	points[33] = (-2227.5315, -8681.9287, 2873.4331);
	angles[33] = (0, 191.2924, 0);
	at[33] = 33.3333;
	points[34] = (-2213.4961, -8737.2051, 2873.4331);
	angles[34] = (0, 193.4083, 0);
	at[34] = 33.6667;
	points[35] = (-2193.8347, -8796.3779, 2873.4331);
	angles[35] = (0, 196.9622, 0);
	at[35] = 34;
	points[36] = (-2169.3584, -8842.4805, 2873.4331);
	angles[36] = (0, 205.2542, 0);
	at[36] = 34.3333;
	points[37] = (-2125.8582, -8883.5039, 2873.4331);
	angles[37] = (0, 219.8508, 0);
	at[37] = 34.6667;
	points[38] = (-2077.2717, -8913.5439, 2873.4331);
	angles[38] = (0, 232.1353, 0);
	at[38] = 35;
	points[39] = (-2022.6614, -8939.5674, 2873.4331);
	angles[39] = (0, 240.4234, 0);
	at[39] = 35.3333;
	points[40] = (-1968.3190, -8961.0234, 2873.4331);
	angles[40] = (0, 245.7831, 0);
	at[40] = 35.6667;
	points[41] = (-1855.3544, -8997.3232, 2873.4331);
	angles[41] = (0, 251.9618, 0);
	at[41] = 36.3333;
	points[42] = (-1740.4135, -9027.3232, 2873.4331);
	angles[42] = (0, 255.3090, 0);
	at[42] = 37;
	points[43] = (-1624.3741, -9053.1895, 2873.4331);
	angles[43] = (0, 257.4167, 0);
	at[43] = 37.6667;
	points[44] = (-1391.6102, -9096.8896, 2873.4331);
	angles[44] = (0, 259.8556, 0);
	at[44] = 39;
	points[45] = (-1156.2441, -9136.3389, 2873.4331);
	angles[45] = (0, 260.4002, 0);
	at[45] = 40.3333;
	points[46] = (-1102.2992, -9146.4170, 2873.4331);
	angles[46] = (0, 259.6565, 0);
	at[46] = 40.6667;
	points[47] = (-986.4449, -9164.6064, 2873.4331);
	angles[47] = (0, 261.3501, 0);
	at[47] = 41.3333;
	points[48] = (-691.4449, -9197.0078, 2873.4331);
	angles[48] = (0, 264.3067, 0);
	at[48] = 43;
	points[49] = (-159.2311, -9242.7168, 2873.4331);
	angles[49] = (0, 265.1948, 0);
	at[49] = 46;
	points[50] = (-105.7185, -9247.4014, 2873.4331);
	angles[50] = (0, 265.0433, 0);
	at[50] = 46.3333;
	points[51] = (841.3898, -9322.1660, 2873.4331);
	angles[51] = (0, 265.6236, 0);
	at[51] = 51.6667;
	points[52] = (898.4567, -9326.5352, 2873.4331);
	angles[52] = (0, 265.6334, 0);
	at[52] = 52;
	points[53] = (959.6220, -9331.1807, 2873.4331);
	angles[53] = (0, 265.6433, 0);
	at[53] = 52.3333;
	points[54] = (1012.6614, -9335.2754, 2873.3860);
	angles[54] = (0, 265.5782, 0);
	at[54] = 52.6667;
	points[55] = (1663.2834, -9390.1572, 2869.6340);
	angles[55] = (0, 265.4319, 0);
	at[55] = 56.3333;
	points[56] = (1899.4487, -9406.6533, 2869.9565);
	angles[56] = (0, 266.3212, 0);
	at[56] = 57.6667;
	points[57] = (2019.1812, -9412.0078, 2871.6970);
	angles[57] = (0, 267.5924, 0);
	at[57] = 58.3333;
	points[58] = (2075.0315, -9412.0078, 2873.7993);
	angles[58] = (0, 269.3997, 0);
	at[58] = 58.6667;
	points[59] = (2192.9370, -9403.5830, 2883.7559);
	angles[59] = (0, 274.0175, 0);
	at[59] = 59.3333;
	points[60] = (2309.2913, -9389.7246, 2897.1025);
	angles[60] = (0, 276.7484, 0);
	at[60] = 60;
	points[61] = (2483.4016, -9361.4961, 2920.5117);
	angles[61] = (0, 279.7376, 0);
	at[61] = 61;
	points[62] = (2598.0315, -9336.9297, 2937.8386);
	angles[62] = (0, 282.2602, 0);
	at[62] = 61.6667;
	points[63] = (2654.2637, -9321.7715, 2947.0552);
	angles[63] = (0, 284.2620, 0);
	at[63] = 62;
	points[64] = (2709.9724, -9302.2832, 2957.0552);
	angles[64] = (0, 287.9222, 0);
	at[64] = 62.3333;
	points[65] = (2756.6418, -9272.4414, 2968.0432);
	angles[65] = (0, 298.6909, 0);
	at[65] = 62.6667;
	points[66] = (2794.6575, -9228.6221, 2981.4919);
	angles[66] = (0, 312.3101, 0);
	at[66] = 63;
	points[67] = (2856.2246, -9131.5752, 3009.1931);
	angles[67] = (0, 326.6560, 0);
	at[67] = 63.6667;
	points[68] = (2909.0120, -9029.4883, 3036.7834);
	angles[68] = (0, 332.4149, 0);
	at[68] = 64.3333;
	points[69] = (2978.6497, -8869.8818, 3075.9961);
	angles[69] = (0, 337.2111, 0);
	at[69] = 65.3333;
	points[70] = (2996.7834, -8816.2207, 3085.9016);
	angles[70] = (0, 340.2233, 0);
	at[70] = 65.6667;
	points[71] = (3010.9646, -8759.9609, 3094.6260);
	angles[71] = (0, 344.0098, 0);
	at[71] = 66;
	points[72] = (3034.7085, -8644.9609, 3110.5552);
	angles[72] = (0, 348.1221, 0);
	at[72] = 66.6667;
	points[73] = (3054.7363, -8529.0156, 3124.6182);
	angles[73] = (0, 350.1732, 0);
	at[73] = 67.3333;
	points[74] = (3071.2285, -8411.9287, 3135.9648);
	angles[74] = (0, 352.0847, 0);
	at[74] = 68;
	points[75] = (3076.9175, -8353.0713, 3139.1062);
	angles[75] = (0, 353.8393, 0);
	at[75] = 68.3333;
	points[76] = (3078.1733, -8296.1416, 3137.2246);
	angles[76] = (0, 357.2029, 0);
	at[76] = 68.6667;
	points[77] = (3077.0903, -8237.1260, 3132.4529);
	angles[77] = (0, 359.7709, 0);
	at[77] = 69;
	points[78] = (3071.4019, -8119.2124, 3119.7637);
	angles[78] = (0, 362.6724, 0);
	at[78] = 69.6667;
	points[79] = (3061.5671, -8001.8501, 3104.7283);
	angles[79] = (0, 364.8610, 0);
	at[79] = 70.3333;
	points[80] = (3045.0750, -7885.8662, 3087.6379);
	angles[80] = (0, 368.4781, 0);
	at[80] = 71;
	points[81] = (3030.3032, -7831.9292, 3078.0276);
	angles[81] = (0, 373.6602, 0);
	at[81] = 71.3333;
	points[82] = (2981.6182, -7726.3384, 3052.7480);
	angles[82] = (0, 384.1549, 0);
	at[82] = 72;
	points[83] = (2896.4175, -7575.5518, 3012.0513);
	angles[83] = (0, 390.2358, 0);
	at[83] = 73;
	points[84] = (2831.8149, -7479.8032, 2984.4016);
	angles[84] = (0, 394.2706, 0);
	at[84] = 73.6667;
	points[85] = (2795.3386, -7435.1182, 2970.7322);
	angles[85] = (0, 397.8470, 0);
	at[85] = 74;
	points[86] = (2753.3938, -7398.8188, 2958.2915);
	angles[86] = (0, 406.5288, 0);
	at[86] = 74.3333;
	points[87] = (2699.7874, -7377.7563, 2947.1497);
	angles[87] = (0, 421.4329, 0);
	at[87] = 74.6667;
	points[88] = (2643.0117, -7363.4644, 2936.7166);
	angles[88] = (0, 430.9985, 0);
	at[88] = 75;
	points[89] = (2585.6104, -7352.2441, 2926.8230);
	angles[89] = (0, 436.2574, 0);
	at[89] = 75.3333;
	points[90] = (2411.5276, -7327.0083, 2899.4370);
	angles[90] = (0, 442.1125, 0);
	at[90] = 76.3333;
	points[91] = (2236.5630, -7307.0474, 2876.7363);
	angles[91] = (0, 443.5206, 0);
	at[91] = 77.3333;
	points[92] = (2197.6221, -7302.4019, 2873.3228);
	angles[92] = (0, 443.3186, 0);
	at[92] = 77.5667;
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
	points[0] = (-2892.3740, 11548.2676, 2895.7441);
	angles[0] = (0, -83.1514, 0);
	at[0] = 0;
	points[1] = (-2797.3230, 11552.5596, 2895.7441);
	angles[1] = (0, -85.0831, 0);
	at[1] = 0.1667;
	points[2] = (-2703.5747, 11549.8818, 2895.7441);
	angles[2] = (0, -87.8136, 0);
	at[2] = 0.3333;
	points[3] = (-2512.9805, 11534.8037, 2895.7441);
	angles[3] = (0, -92.3088, 0);
	at[3] = 0.6667;
	points[4] = (-2231.5513, 11501.2207, 2895.7441);
	angles[4] = (0, -96.0278, 0);
	at[4] = 1.1667;
	points[5] = (-1763.2953, 11434.5283, 2895.7441);
	angles[5] = (0, -98.0375, 0);
	at[5] = 2;
	points[6] = (-1573.1261, 11408.8584, 2895.7441);
	angles[6] = (0, -97.7184, 0);
	at[6] = 2.3333;
	points[7] = (-1487.0157, 11399.5674, 2895.7441);
	angles[7] = (0, -97.0575, 0);
	at[7] = 2.5000;
	points[8] = (-1294.5472, 11379.9209, 2895.7441);
	angles[8] = (0, -96.2634, 0);
	at[8] = 2.8333;
	points[9] = (-1202.7992, 11370.6299, 2895.7441);
	angles[9] = (0, -96.0694, 0);
	at[9] = 3;
	points[10] = (-351.6559, 11284.4492, 2895.7441);
	angles[10] = (0, -95.8144, 0);
	at[10] = 4.5000;
	points[11] = (-68.8941, 11254.8418, 2895.7441);
	angles[11] = (0, -95.9860, 0);
	at[11] = 5;
	points[12] = (20.8809, 11244.6465, 2895.7441);
	angles[12] = (0, -96.1992, 0);
	at[12] = 5.1667;
	points[13] = (115.0205, 11233.4258, 2895.7441);
	angles[13] = (0, -96.4444, 0);
	at[13] = 5.3333;
	points[14] = (866.2244, 11136.7314, 2895.7441);
	angles[14] = (0, -97.5489, 0);
	at[14] = 6.6667;
	points[15] = (1238.2087, 11082.2051, 2895.7441);
	angles[15] = (0, -98.3101, 0);
	at[15] = 7.3333;
	points[16] = (1895.5669, 10983.3857, 2895.7441);
	angles[16] = (0, -98.5205, 0);
	at[16] = 8.5000;
	points[17] = (1984.7440, 10970.2754, 2895.7441);
	angles[17] = (0, -98.4579, 0);
	at[17] = 8.6667;
	points[18] = (2171.7874, 10942.9141, 2895.7441);
	angles[18] = (0, -98.3693, 0);
	at[18] = 9;
	points[19] = (3017.8503, 10819.9209, 2895.7441);
	angles[19] = (0, -98.2405, 0);
	at[19] = 10.5000;
	points[20] = (3104.6812, 10808.4248, 2895.7441);
	angles[20] = (0, -97.8627, 0);
	at[20] = 10.6667;
	points[21] = (3295.9646, 10795.9062, 2895.7441);
	angles[21] = (0, -95.0461, 0);
	at[21] = 11;
	points[22] = (3674.4568, 10775.9453, 2895.7441);
	angles[22] = (0, -93.4644, 0);
	at[22] = 11.6667;
	points[23] = (3863.3269, 10760.1582, 2895.7441);
	angles[23] = (0, -94.4542, 0);
	at[23] = 12;
	points[24] = (4051.2993, 10735.1182, 2895.7441);
	angles[24] = (0, -96.7393, 0);
	at[24] = 12.3333;
	points[25] = (4144.3306, 10716.4961, 2895.7441);
	angles[25] = (0, -98.7123, 0);
	at[25] = 12.5000;
	points[26] = (4236.6143, 10690.3154, 2895.7441);
	angles[26] = (0, -101.7870, 0);
	at[26] = 12.6667;
	points[27] = (4322.7954, 10650.8672, 2895.7441);
	angles[27] = (0, -107.3479, 0);
	at[27] = 12.8333;
	points[28] = (4386.0234, 10592.9531, 2895.7441);
	angles[28] = (0, -117.8879, 0);
	at[28] = 13;
	points[29] = (4442.4014, 10515.6299, 2895.7441);
	angles[29] = (0, -128.4245, 0);
	at[29] = 13.1667;
	points[30] = (4494.3701, 10431.8506, 2895.7441);
	angles[30] = (0, -136.3871, 0);
	at[30] = 13.3333;
	points[31] = (4539.3701, 10352.1660, 2895.7441);
	angles[31] = (0, -142.0971, 0);
	at[31] = 13.5000;
	points[32] = (4584.7642, 10266.3779, 2895.7441);
	angles[32] = (0, -146.1627, 0);
	at[32] = 13.6667;
	points[33] = (4626.5747, 10183.0312, 2895.7441);
	angles[33] = (0, -149.0855, 0);
	at[33] = 13.8333;
	points[34] = (4707.4805, 10010.8262, 2895.7441);
	angles[34] = (0, -152.9082, 0);
	at[34] = 14.1667;
	points[35] = (4783.1104, 9836.2207, 2895.7441);
	angles[35] = (0, -155.3773, 0);
	at[35] = 14.5000;
	points[36] = (4853.4253, 9659.5674, 2895.7441);
	angles[36] = (0, -157.3738, 0);
	at[36] = 14.8333;
	points[37] = (4917.3228, 9480.5117, 2895.7441);
	angles[37] = (0, -159.4505, 0);
	at[37] = 15.1667;
	points[38] = (4945.4727, 9391.4961, 2895.7441);
	angles[38] = (0, -160.7245, 0);
	at[38] = 15.3333;
	points[39] = (4971.3389, 9297.5986, 2895.7441);
	angles[39] = (0, -162.3667, 0);
	at[39] = 15.5000;
	points[40] = (4990.5908, 9206.3389, 2895.7441);
	angles[40] = (0, -164.8163, 0);
	at[40] = 15.6667;
	points[41] = (4996.8506, 9117.0078, 2895.7441);
	angles[41] = (0, -169.9417, 0);
	at[41] = 15.8333;
	points[42] = (4977.9531, 9023.7012, 2895.7441);
	angles[42] = (0, -178.8219, 0);
	at[42] = 16;
	points[43] = (4947.0078, 8935.5908, 2895.7441);
	angles[43] = (0, -187.1430, 0);
	at[43] = 16.1667;
	points[44] = (4909.6460, 8849.2920, 2895.7441);
	angles[44] = (0, -193.7526, 0);
	at[44] = 16.3333;
	points[45] = (4867.2046, 8762.6777, 2895.7441);
	angles[45] = (0, -198.7798, 0);
	at[45] = 16.5000;
	points[46] = (4822.9526, 8680.0400, 2895.7441);
	angles[46] = (0, -202.5958, 0);
	at[46] = 16.6667;
	points[47] = (4775.5117, 8597.2441, 2895.7441);
	angles[47] = (0, -205.5547, 0);
	at[47] = 16.8333;
	points[48] = (4674.8032, 8436.3779, 2895.7441);
	angles[48] = (0, -209.9085, 0);
	at[48] = 17.1667;
	points[49] = (4565.9448, 8280.5117, 2895.7441);
	angles[49] = (0, -213.3395, 0);
	at[49] = 17.5000;
	points[50] = (4509.5278, 8206.6934, 2895.7441);
	angles[50] = (0, -215.0412, 0);
	at[50] = 17.6667;
	points[51] = (4447.7559, 8131.8901, 2895.7441);
	angles[51] = (0, -216.9474, 0);
	at[51] = 17.8333;
	points[52] = (4383.3462, 8061.7324, 2895.7441);
	angles[52] = (0, -219.3161, 0);
	at[52] = 18;
	points[53] = (4314.1338, 7998.3857, 2895.7441);
	angles[53] = (0, -222.8451, 0);
	at[53] = 18.1667;
	points[54] = (4237.9136, 7953.2681, 2895.7441);
	angles[54] = (0, -230.3542, 0);
	at[54] = 18.3333;
	points[55] = (4144.4883, 7936.7324, 2895.7441);
	angles[55] = (0, -242.4766, 0);
	at[55] = 18.5000;
	points[56] = (4047.5198, 7934.6455, 2895.7441);
	angles[56] = (0, -253.0287, 0);
	at[56] = 18.6667;
	points[57] = (3955.2361, 7939.0547, 2895.7441);
	angles[57] = (0, -260.9624, 0);
	at[57] = 18.8333;
	points[58] = (3860.2087, 7947.5200, 2895.7441);
	angles[58] = (0, -266.6785, 0);
	at[58] = 19;
	points[59] = (3671.9805, 7971.4961, 2895.7441);
	angles[59] = (0, -273.6132, 0);
	at[59] = 19.3333;
	points[60] = (3391.4604, 8017.3628, 2895.7441);
	angles[60] = (0, -278.2559, 0);
	at[60] = 19.8333;
	points[61] = (2924.2402, 8101.9683, 2895.7441);
	angles[61] = (0, -279.9634, 0);
	at[61] = 20.6667;
	points[62] = (2834.4883, 8114.7246, 2895.7441);
	angles[62] = (0, -279.0818, 0);
	at[62] = 20.8333;
	points[63] = (1704.9094, 8258.9365, 2895.7441);
	angles[63] = (0, -277.4431, 0);
	at[63] = 22.8333;
	points[64] = (1615.9370, 8270.7881, 2895.7441);
	angles[64] = (0, -277.5099, 0);
	at[64] = 23;
	points[65] = (958.6497, 8362.7559, 2895.7441);
	angles[65] = (0, -278.0779, 0);
	at[65] = 24.1667;
	points[66] = (680.6772, 8405.7480, 2895.7441);
	angles[66] = (0, -278.7614, 0);
	at[66] = 24.6667;
	points[67] = (25.1191, 8513.5039, 2895.7441);
	angles[67] = (0, -279.2633, 0);
	at[67] = 25.8333;
	points[68] = (-158.9634, 8542.1260, 2895.7441);
	angles[68] = (0, -278.9756, 0);
	at[68] = 26.1667;
	points[69] = (-909.1653, 8656.5361, 2895.7441);
	angles[69] = (0, -278.6423, 0);
	at[69] = 27.5000;
	points[70] = (-998.6693, 8670.0791, 2895.7441);
	angles[70] = (0, -278.6240, 0);
	at[70] = 27.6667;
	points[71] = (-1655.7245, 8768.7402, 2895.7441);
	angles[71] = (0, -278.4785, 0);
	at[71] = 28.8333;
	points[72] = (-2028.4529, 8820.7881, 2895.7441);
	angles[72] = (0, -277.8765, 0);
	at[72] = 29.5000;
	points[73] = (-2874.1497, 8930.9844, 2895.7441);
	angles[73] = (0, -277.3671, 0);
	at[73] = 31;
	points[74] = (-2967.5159, 8942.9531, 2895.7441);
	angles[74] = (0, -277.3381, 0);
	at[74] = 31.1667;
	points[75] = (-3056.9727, 8954.0166, 2895.7441);
	angles[75] = (0, -277.1499, 0);
	at[75] = 31.3333;
	points[76] = (-3152.0747, 8958.3467, 2895.7441);
	angles[76] = (0, -275.1814, 0);
	at[76] = 31.5000;
	points[77] = (-3248.5867, 8958.5039, 2895.7441);
	angles[77] = (0, -273.0952, 0);
	at[77] = 31.6667;
	points[78] = (-3626.5039, 8955.4336, 2895.7441);
	angles[78] = (0, -270.2054, 0);
	at[78] = 32.3333;
	points[79] = (-3816.0708, 8961.6143, 2895.7441);
	angles[79] = (0, -271.4814, 0);
	at[79] = 32.6667;
	points[80] = (-3911.3464, 8969.2920, 2895.7441);
	angles[80] = (0, -272.8232, 0);
	at[80] = 32.8333;
	points[81] = (-4004.3308, 8981.6143, 2895.7441);
	angles[81] = (0, -274.8409, 0);
	at[81] = 33;
	points[82] = (-4096.9292, 9001.4180, 2895.7441);
	angles[82] = (0, -277.9796, 0);
	at[82] = 33.1667;
	points[83] = (-4186.5747, 9034.3311, 2895.7441);
	angles[83] = (0, -283.2866, 0);
	at[83] = 33.3333;
	points[84] = (-4260.6694, 9091.1025, 2895.7441);
	angles[84] = (0, -293.7450, 0);
	at[84] = 33.5000;
	points[85] = (-4297.7559, 9169.3311, 2895.7441);
	angles[85] = (0, -309.9575, 0);
	at[85] = 33.6667;
	points[86] = (-4323.5825, 9260.7480, 2895.7441);
	angles[86] = (0, -323.5527, 0);
	at[86] = 33.8333;
	points[87] = (-4344.6064, 9357.1260, 2895.7441);
	angles[87] = (0, -333.1857, 0);
	at[87] = 34;
	points[88] = (-4361.2207, 9447.7559, 2895.7441);
	angles[88] = (0, -339.7963, 0);
	at[88] = 34.1667;
	points[89] = (-4389.8032, 9637.3623, 2895.7441);
	angles[89] = (0, -347.3885, 0);
	at[89] = 34.5000;
	points[90] = (-4412.5200, 9826.1025, 2895.7441);
	angles[90] = (0, -351.1734, 0);
	at[90] = 34.8333;
	points[91] = (-4430.7090, 10014.0947, 2895.7441);
	angles[91] = (0, -353.3785, 0);
	at[91] = 35.1667;
	points[92] = (-4450.5513, 10298.7012, 2895.7441);
	angles[92] = (0, -355.6509, 0);
	at[92] = 35.6667;
	points[93] = (-4458.3071, 10489.3701, 2895.7441);
	angles[93] = (0, -357.0448, 0);
	at[93] = 36;
	points[94] = (-4460.4722, 10678.2285, 2895.7441);
	angles[94] = (0, -358.6511, 0);
	at[94] = 36.3333;
	points[95] = (-4458.7402, 10774.8027, 2895.7441);
	angles[95] = (0, -359.6636, 0);
	at[95] = 36.5000;
	points[96] = (-4454.6460, 10865.1582, 2895.7441);
	angles[96] = (0, -360.9045, 0);
	at[96] = 36.6667;
	points[97] = (-4446.0630, 10965.2363, 2895.7441);
	angles[97] = (0, -362.6341, 0);
	at[97] = 36.8333;
	points[98] = (-4431.8506, 11056.2988, 2895.7441);
	angles[98] = (0, -365.2837, 0);
	at[98] = 37;
	points[99] = (-4403.5435, 11142.9131, 2895.7441);
	angles[99] = (0, -371.2834, 0);
	at[99] = 37.1667;
	points[100] = (-4340, 11210.4326, 2895.7441);
	angles[100] = (0, -384.3651, 0);
	at[100] = 37.3333;
	points[101] = (-4261.2993, 11257.9531, 2895.7441);
	angles[101] = (0, -398.1311, 0);
	at[101] = 37.5000;
	points[102] = (-4174.2915, 11296.8105, 2895.7441);
	angles[102] = (0, -409.3043, 0);
	at[102] = 37.6667;
	points[103] = (-4083.7795, 11329.5674, 2895.7441);
	angles[103] = (0, -417.6807, 0);
	at[103] = 37.8333;
	points[104] = (-3994.4490, 11357.1260, 2895.7441);
	angles[104] = (0, -423.8224, 0);
	at[104] = 38;
	points[105] = (-3810.2600, 11404.4092, 2895.7441);
	angles[105] = (0, -431.5831, 0);
	at[105] = 38.3333;
	points[106] = (-3531.2046, 11460.7080, 2895.7441);
	angles[106] = (0, -437.3989, 0);
	at[106] = 38.8333;
	points[107] = (-3249.0354, 11505.5117, 2895.7441);
	angles[107] = (0, -440.4326, 0);
	at[107] = 39.3333;
	points[108] = (-3156.5042, 11518.0703, 2895.7441);
	angles[108] = (0, -441.1876, 0);
	at[108] = 39.5000;
	points[109] = (-3059.9805, 11530.1572, 2895.7441);
	angles[109] = (0, -441.8828, 0);
	at[109] = 39.6667;
	points[110] = (-2892.3740, 11548.2676, 2895.7441);
	angles[110] = (0, -443.1514, 0);
	at[110] = 39.9667;
	mover = getEnt("iz_obj_1", "targetname");
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
