main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_mario_circuit", 0);

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
	ambientPlay("iz_0_109", 2);
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
	level.iz_route[level.iz_route.size] = (-744, -6375, 1223);
	level.iz_route[level.iz_route.size] = (164, -6384, 1232);
	level.iz_route[level.iz_route.size] = (2458, -6407, 1255);
	level.iz_route[level.iz_route.size] = (5092, -6576, 1420);
	level.iz_route[level.iz_route.size] = (6687, -6395, 1574);
	level.iz_route[level.iz_route.size] = (7572, -5891, 1674);
	level.iz_route[level.iz_route.size] = (8004, -4906, 1709);
	level.iz_route[level.iz_route.size] = (7946, -4224, 1685);
	level.iz_route[level.iz_route.size] = (7320, -3648, 1565);
	level.iz_route[level.iz_route.size] = (6695, -3489, 1491);
	level.iz_route[level.iz_route.size] = (6309, -3464, 1456);
	level.iz_route[level.iz_route.size] = (5634, -3498, 1408);
	level.iz_route[level.iz_route.size] = (4808, -3283, 1365);
	level.iz_route[level.iz_route.size] = (4154, -2241, 1365);
	level.iz_route[level.iz_route.size] = (4267, -1029, 1462);
	level.iz_route[level.iz_route.size] = (4969, -258, 1589);
	level.iz_route[level.iz_route.size] = (5930, 326, 1727);
	level.iz_route[level.iz_route.size] = (6593, 640, 1823);
	level.iz_route[level.iz_route.size] = (7303, 1044, 1940);
	level.iz_route[level.iz_route.size] = (8000, 1769, 2082);
	level.iz_route[level.iz_route.size] = (8721, 3089, 2267);
	level.iz_route[level.iz_route.size] = (9053, 5183, 2474);
	level.iz_route[level.iz_route.size] = (8808, 7121, 2613);
	level.iz_route[level.iz_route.size] = (8168, 8554, 2708);
	level.iz_route[level.iz_route.size] = (7283, 9242, 2709);
	level.iz_route[level.iz_route.size] = (6295, 9359, 2645);
	level.iz_route[level.iz_route.size] = (5588, 9077, 2559);
	level.iz_route[level.iz_route.size] = (4775, 8028, 2425);
	level.iz_route[level.iz_route.size] = (4302, 7032, 2561);
	level.iz_route[level.iz_route.size] = (3832, 6043, 2315);
	level.iz_route[level.iz_route.size] = (3163, 4707, 1927);
	level.iz_route[level.iz_route.size] = (2500, 3653, 1594);
	level.iz_route[level.iz_route.size] = (1663, 2968, 1286);
	level.iz_route[level.iz_route.size] = (1443, 2672, 1180);
	level.iz_route[level.iz_route.size] = (1460, 2359, 1116);
	level.iz_route[level.iz_route.size] = (1646, 1641, 1005);
	level.iz_route[level.iz_route.size] = (1612, 1277, 964);
	level.iz_route[level.iz_route.size] = (1392, 1007, 939);
	level.iz_route[level.iz_route.size] = (1027, 619, 914);
	level.iz_route[level.iz_route.size] = (511, -4, 909);
	level.iz_route[level.iz_route.size] = (139, -821, 1000);
	level.iz_route[level.iz_route.size] = (-229, -1579, 1000);
	level.iz_route[level.iz_route.size] = (-556, -2152, 1011);
	level.iz_route[level.iz_route.size] = (-1047, -2349, 1044);
	level.iz_route[level.iz_route.size] = (-1497, -2567, 1123);
	level.iz_route[level.iz_route.size] = (-1800, -2885, 1204);
	level.iz_route[level.iz_route.size] = (-1786, -3270, 1263);
	level.iz_route[level.iz_route.size] = (-1604, -3728, 1328);
	level.iz_route[level.iz_route.size] = (-1152, -3980, 1393);
	level.iz_route[level.iz_route.size] = (-524, -3883, 1478);
	level.iz_route[level.iz_route.size] = (-156, -3336, 1564);
	level.iz_route[level.iz_route.size] = (-230, -2746, 1630);
	level.iz_route[level.iz_route.size] = (-777, -2359, 1666);
	level.iz_route[level.iz_route.size] = (-2072, -1809, 1725);
	level.iz_route[level.iz_route.size] = (-3983, -937, 1606);
	level.iz_route[level.iz_route.size] = (-5299, -488, 1341);
	level.iz_route[level.iz_route.size] = (-5605, -419, 1329);
	level.iz_route[level.iz_route.size] = (-6832, -193, 1292);
	level.iz_route[level.iz_route.size] = (-7579, -245, 1276);
	level.iz_route[level.iz_route.size] = (-8196, -570, 1255);
	level.iz_route[level.iz_route.size] = (-8713, -1058, 1238);
	level.iz_route[level.iz_route.size] = (-9058, -1541, 1228);
	level.iz_route[level.iz_route.size] = (-9681, -2559, 1215);
	level.iz_route[level.iz_route.size] = (-10306, -3887, 1212);
	level.iz_route[level.iz_route.size] = (-10864, -5368, 1212);
	level.iz_route[level.iz_route.size] = (-10763, -5789, 1212);
	level.iz_route[level.iz_route.size] = (-10499, -6084, 1212);
	level.iz_route[level.iz_route.size] = (-10162, -6270, 1212);
	level.iz_route[level.iz_route.size] = (-9596, -6372, 1212);
	level.iz_route[level.iz_route.size] = (-8023, -6380, 1212);
	level.iz_route[level.iz_route.size] = (-6096, -6372, 1213);
	level.iz_route[level.iz_route.size] = (-5025, -6371, 1254);
	level.iz_route[level.iz_route.size] = (-4517, -6371, 1350);
	level.iz_route[level.iz_route.size] = (-3979, -6371, 1238);
	level.iz_route[level.iz_route.size] = (-1267, -6370, 1214);
	level.iz_route[level.iz_route.size] = (-1113, -6364, 1214);
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
	points[0] = (-7913.1104, -539.5670, 1251.9331);
	angles[0] = (0, -81.7840, 0);
	at[0] = 0;
	points[1] = (-7914.8032, -532.7087, 1252.5591);
	angles[1] = (0, -81.7840, 0);
	at[1] = 0.5000;
	points[2] = (-7914.8032, -532.7087, 1252.5591);
	angles[2] = (0, -81.7840, 0);
	at[2] = 1;
	points[3] = (-7920.2759, -510.7874, 1254.6536);
	angles[3] = (0, -81.7840, 0);
	at[3] = 3;
	points[4] = (-7920.2759, -510.7874, 1254.6536);
	angles[4] = (0, -81.7840, 0);
	at[4] = 3.5000;
	points[5] = (-7925.7480, -488.8701, 1256.7834);
	angles[5] = (0, -81.7840, 0);
	at[5] = 5.5000;
	points[6] = (-7925.7480, -488.8701, 1256.7834);
	angles[6] = (0, -81.7840, 0);
	at[6] = 6;
	points[7] = (-7931.2207, -466.9489, 1258.7992);
	angles[7] = (0, -81.7840, 0);
	at[7] = 8;
	points[8] = (-7931.2207, -466.9489, 1258.7992);
	angles[8] = (0, -81.7840, 0);
	at[8] = 8.5000;
	points[9] = (-7936.6929, -445.0276, 1260.7874);
	angles[9] = (0, -81.7840, 0);
	at[9] = 10.5000;
	points[10] = (-7936.6929, -445.0276, 1260.7874);
	angles[10] = (0, -81.7840, 0);
	at[10] = 11;
	points[11] = (-7942.1260, -423.1063, 1262.7756);
	angles[11] = (0, -81.7840, 0);
	at[11] = 13;
	points[12] = (-7942.1260, -423.1063, 1262.7756);
	angles[12] = (0, -81.7840, 0);
	at[12] = 13.5000;
	points[13] = (-7947.5986, -401.1850, 1264.7638);
	angles[13] = (0, -81.7840, 0);
	at[13] = 15.5000;
	points[14] = (-7947.5986, -401.1850, 1264.7638);
	angles[14] = (0, -81.7840, 0);
	at[14] = 16;
	points[15] = (-7953.0708, -379.2661, 1266.7520);
	angles[15] = (0, -81.7840, 0);
	at[15] = 18;
	points[16] = (-7953.0708, -379.2661, 1266.7520);
	angles[16] = (0, -81.7840, 0);
	at[16] = 18.5000;
	points[17] = (-7958.5435, -357.3457, 1268.7402);
	angles[17] = (0, -81.7840, 0);
	at[17] = 20.5000;
	points[18] = (-7958.5435, -357.3457, 1268.7402);
	angles[18] = (0, -81.7840, 0);
	at[18] = 21;
	points[19] = (-7964.0156, -335.4252, 1270.7284);
	angles[19] = (0, -81.7840, 0);
	at[19] = 23;
	points[20] = (-7964.0156, -335.4252, 1270.7284);
	angles[20] = (0, -81.7840, 0);
	at[20] = 23.5000;
	points[21] = (-7969.4487, -313.5047, 1272.7166);
	angles[21] = (0, -81.7840, 0);
	at[21] = 25.5000;
	points[22] = (-7969.4487, -313.5047, 1272.7166);
	angles[22] = (0, -81.7840, 0);
	at[22] = 26;
	points[23] = (-7974.9214, -291.5843, 1274.7087);
	angles[23] = (0, -81.7840, 0);
	at[23] = 28;
	points[24] = (-7974.9214, -291.5843, 1274.7087);
	angles[24] = (0, -81.7840, 0);
	at[24] = 28.5000;
	points[25] = (-7980.3936, -269.6638, 1276.6969);
	angles[25] = (0, -81.7840, 0);
	at[25] = 30.5000;
	points[26] = (-7980.3936, -269.6638, 1276.6969);
	angles[26] = (0, -81.7840, 0);
	at[26] = 31;
	points[27] = (-7985.8662, -247.7433, 1278.7323);
	angles[27] = (0, -81.7840, 0);
	at[27] = 33;
	points[28] = (-7985.8662, -247.7433, 1278.7323);
	angles[28] = (0, -81.7840, 0);
	at[28] = 33.5000;
	points[29] = (-7991.3384, -225.8228, 1280.7560);
	angles[29] = (0, -81.7840, 0);
	at[29] = 35.5000;
	points[30] = (-7991.3384, -225.8228, 1280.7560);
	angles[30] = (0, -81.7840, 0);
	at[30] = 36;
	points[31] = (-7996.8110, -203.9024, 1282.7363);
	angles[31] = (0, -81.7840, 0);
	at[31] = 38;
	points[32] = (-7996.8110, -203.9024, 1282.7363);
	angles[32] = (0, -81.7840, 0);
	at[32] = 38.5000;
	points[33] = (-8002.2441, -181.9819, 1284.7125);
	angles[33] = (0, -81.7840, 0);
	at[33] = 40.5000;
	points[34] = (-8002.2441, -181.9819, 1284.7125);
	angles[34] = (0, -81.7840, 0);
	at[34] = 41;
	points[35] = (-8007.7163, -160.0618, 1286.6890);
	angles[35] = (0, -81.7840, 0);
	at[35] = 43;
	points[36] = (-8007.7163, -160.0618, 1286.6890);
	angles[36] = (0, -81.7840, 0);
	at[36] = 43.5000;
	points[37] = (-8013.1895, -138.1413, 1288.6693);
	angles[37] = (0, -81.7840, 0);
	at[37] = 45.5000;
	points[38] = (-8013.1895, -138.1413, 1288.6693);
	angles[38] = (0, -81.7840, 0);
	at[38] = 46;
	points[39] = (-8018.6611, -116.2209, 1290.6456);
	angles[39] = (0, -81.7840, 0);
	at[39] = 48;
	points[40] = (-8018.6611, -116.2209, 1290.6456);
	angles[40] = (0, -81.7840, 0);
	at[40] = 48.5000;
	points[41] = (-8024.1343, -94.3004, 1292.6260);
	angles[41] = (0, -81.7840, 0);
	at[41] = 50.5000;
	points[42] = (-8024.1343, -94.3004, 1292.6260);
	angles[42] = (0, -81.7840, 0);
	at[42] = 51;
	points[43] = (-8029.5674, -72.3799, 1294.6024);
	angles[43] = (0, -81.7840, 0);
	at[43] = 53;
	points[44] = (-8029.5674, -72.3799, 1294.6024);
	angles[44] = (0, -81.7840, 0);
	at[44] = 53.5000;
	points[45] = (-8035.0396, -50.4614, 1296.5789);
	angles[45] = (0, -81.7840, 0);
	at[45] = 55.5000;
	points[46] = (-8035.0396, -50.4614, 1296.5789);
	angles[46] = (0, -81.7840, 0);
	at[46] = 56;
	points[47] = (-8040.5122, -28.5426, 1298.5828);
	angles[47] = (0, -81.7840, 0);
	at[47] = 58;
	points[48] = (-8040.5122, -28.5426, 1298.5828);
	angles[48] = (0, -81.7840, 0);
	at[48] = 58.5000;
	points[49] = (-8045.9844, -6.6239, 1300.5867);
	angles[49] = (0, -81.7840, 0);
	at[49] = 60.5000;
	points[50] = (-8045.9844, -6.6239, 1300.5867);
	angles[50] = (0, -81.7840, 0);
	at[50] = 61;
	points[51] = (-8051.4570, 15.2948, 1302.5748);
	angles[51] = (0, -81.7840, 0);
	at[51] = 63;
	points[52] = (-8051.4570, 15.2948, 1302.5748);
	angles[52] = (0, -81.7840, 0);
	at[52] = 63.5000;
	points[53] = (-8056.8901, 37.2134, 1304.5552);
	angles[53] = (0, -81.7840, 0);
	at[53] = 65.5000;
	points[54] = (-8056.8901, 37.2134, 1304.5552);
	angles[54] = (0, -81.7840, 0);
	at[54] = 66;
	points[55] = (-8062.3623, 59.1323, 1306.5513);
	angles[55] = (0, -81.7840, 0);
	at[55] = 68;
	points[56] = (-8062.3623, 59.1323, 1306.5513);
	angles[56] = (0, -81.7840, 0);
	at[56] = 68.5000;
	points[57] = (-8067.7954, 80.8165, 1308.5237);
	angles[57] = (0, -81.7840, 0);
	at[57] = 70.5000;
	points[58] = (-8065.9448, 73.5102, 1307.8583);
	angles[58] = (0, -81.7840, 0);
	at[58] = 71;
	points[59] = (-8065.8662, 73.1677, 1307.8268);
	angles[59] = (0, -81.7840, 0);
	at[59] = 71.5000;
	points[60] = (-8062.4805, 59.5827, 1306.5906);
	angles[60] = (0, -81.7840, 0);
	at[60] = 72.5000;
	points[61] = (-8062.3232, 58.8980, 1306.5275);
	angles[61] = (0, -81.7840, 0);
	at[61] = 73;
	points[62] = (-8060.5117, 51.5917, 1305.8622);
	angles[62] = (0, -81.7840, 0);
	at[62] = 73.5000;
	points[63] = (-8060.3936, 51.2492, 1305.8307);
	angles[63] = (0, -81.7840, 0);
	at[63] = 74;
	points[64] = (-8057.0078, 37.6641, 1304.5945);
	angles[64] = (0, -81.7840, 0);
	at[64] = 75;
	points[65] = (-8056.8506, 36.9792, 1304.5355);
	angles[65] = (0, -81.7840, 0);
	at[65] = 75.5000;
	points[66] = (-8055.0396, 29.6730, 1303.8701);
	angles[66] = (0, -81.7840, 0);
	at[66] = 76;
	points[67] = (-8054.9604, 29.3305, 1303.8386);
	angles[67] = (0, -81.7840, 0);
	at[67] = 76.5000;
	points[68] = (-8051.5747, 15.7455, 1302.6141);
	angles[68] = (0, -81.7840, 0);
	at[68] = 77.5000;
	points[69] = (-8051.3784, 15.0605, 1302.5552);
	angles[69] = (0, -81.7840, 0);
	at[69] = 78;
	points[70] = (-8049.5669, 7.7543, 1301.9015);
	angles[70] = (0, -81.7840, 0);
	at[70] = 78.5000;
	points[71] = (-8049.4883, 7.4118, 1301.8701);
	angles[71] = (0, -81.7840, 0);
	at[71] = 79;
	points[72] = (-8046.1025, -6.1732, 1300.6260);
	angles[72] = (0, -81.7840, 0);
	at[72] = 80;
	points[73] = (-8045.9053, -6.8582, 1300.5631);
	angles[73] = (0, -81.7840, 0);
	at[73] = 80.5000;
	points[74] = (-8044.0947, -14.1644, 1299.8976);
	angles[74] = (0, -81.7840, 0);
	at[74] = 81;
	points[75] = (-8044.0156, -14.5069, 1299.8662);
	angles[75] = (0, -81.7840, 0);
	at[75] = 81.5000;
	points[76] = (-8040.6299, -28.0919, 1298.6221);
	angles[76] = (0, -81.7840, 0);
	at[76] = 82.5000;
	points[77] = (-8040.4727, -28.7769, 1298.5590);
	angles[77] = (0, -81.7840, 0);
	at[77] = 83;
	points[78] = (-8038.6221, -36.0831, 1297.8898);
	angles[78] = (0, -81.7840, 0);
	at[78] = 83.5000;
	points[79] = (-8038.5435, -36.4256, 1297.8583);
	angles[79] = (0, -81.7840, 0);
	at[79] = 84;
	points[80] = (-8035.1577, -50.0106, 1296.6221);
	angles[80] = (0, -81.7840, 0);
	at[80] = 85;
	points[81] = (-8035, -50.6957, 1296.5590);
	angles[81] = (0, -81.7840, 0);
	at[81] = 85.5000;
	points[82] = (-8033.1890, -58.0020, 1295.9016);
	angles[82] = (0, -81.7840, 0);
	at[82] = 86;
	points[83] = (-8033.0708, -58.3441, 1295.8701);
	angles[83] = (0, -81.7840, 0);
	at[83] = 86.5000;
	points[84] = (-8029.6851, -71.9291, 1294.6417);
	angles[84] = (0, -81.7840, 0);
	at[84] = 87.5000;
	points[85] = (-8029.5273, -72.6142, 1294.5828);
	angles[85] = (0, -81.7840, 0);
	at[85] = 88;
	points[86] = (-8027.7168, -79.9209, 1293.9213);
	angles[86] = (0, -81.7840, 0);
	at[86] = 88.5000;
	points[87] = (-8027.6377, -80.2634, 1293.8898);
	angles[87] = (0, -81.7840, 0);
	at[87] = 89;
	points[88] = (-8024.2520, -93.8496, 1292.6653);
	angles[88] = (0, -81.7840, 0);
	at[88] = 90;
	points[89] = (-8024.0552, -94.5346, 1292.6024);
	angles[89] = (0, -81.7840, 0);
	at[89] = 90.5000;
	points[90] = (-8022.2441, -101.8413, 1291.9448);
	angles[90] = (0, -81.7840, 0);
	at[90] = 91;
	points[91] = (-8022.1655, -102.1839, 1291.9135);
	angles[91] = (0, -81.7840, 0);
	at[91] = 91.5000;
	points[92] = (-8018.7798, -115.7701, 1290.6890);
	angles[92] = (0, -81.7840, 0);
	at[92] = 92.5000;
	points[93] = (-8018.5825, -116.4547, 1290.6260);
	angles[93] = (0, -81.7840, 0);
	at[93] = 93;
	points[94] = (-8016.7720, -123.7618, 1289.9645);
	angles[94] = (0, -81.7840, 0);
	at[94] = 93.5000;
	points[95] = (-8016.6929, -124.1043, 1289.9370);
	angles[95] = (0, -81.7840, 0);
	at[95] = 94;
	points[96] = (-8013.3071, -137.6902, 1288.7087);
	angles[96] = (0, -81.7840, 0);
	at[96] = 95;
	points[97] = (-8013.1494, -138.3752, 1288.6458);
	angles[97] = (0, -81.7840, 0);
	at[97] = 95.5000;
	points[98] = (-8011.2993, -145.6819, 1287.9883);
	angles[98] = (0, -81.7840, 0);
	at[98] = 96;
	points[99] = (-8011.2207, -146.0244, 1287.9567);
	angles[99] = (0, -81.7840, 0);
	at[99] = 96.5000;
	points[100] = (-8007.8350, -159.6106, 1286.7323);
	angles[100] = (0, -81.7840, 0);
	at[100] = 97.5000;
	points[101] = (-8007.6772, -160.2957, 1286.6693);
	angles[101] = (0, -81.7840, 0);
	at[101] = 98;
	points[102] = (-8005.8271, -167.6024, 1286.0118);
	angles[102] = (0, -81.7840, 0);
	at[102] = 98.5000;
	points[103] = (-8005.7480, -167.9449, 1285.9802);
	angles[103] = (0, -81.7840, 0);
	at[103] = 99;
	points[104] = (-8002.3623, -181.5311, 1284.7521);
	angles[104] = (0, -81.7840, 0);
	at[104] = 100;
	points[105] = (-8002.2046, -182.2162, 1284.6929);
	angles[105] = (0, -81.7840, 0);
	at[105] = 100.5000;
	points[106] = (-8000.3940, -189.5228, 1284.0315);
	angles[106] = (0, -81.7840, 0);
	at[106] = 101;
	points[107] = (-8000.2759, -189.8654, 1284);
	angles[107] = (0, -81.7840, 0);
	at[107] = 101.5000;
	points[108] = (-7996.8901, -203.4516, 1282.7756);
	angles[108] = (0, -81.7840, 0);
	at[108] = 102.5000;
	points[109] = (-7996.7324, -204.1366, 1282.7125);
	angles[109] = (0, -81.7840, 0);
	at[109] = 103;
	points[110] = (-7994.9214, -211.4433, 1282.0552);
	angles[110] = (0, -81.7840, 0);
	at[110] = 103.5000;
	points[111] = (-7994.8428, -211.7858, 1282.0237);
	angles[111] = (0, -81.7840, 0);
	at[111] = 104;
	points[112] = (-7991.4570, -225.3721, 1280.7992);
	angles[112] = (0, -81.7840, 0);
	at[112] = 105;
	points[113] = (-7991.2598, -226.0571, 1280.7362);
	angles[113] = (0, -81.7840, 0);
	at[113] = 105.5000;
	points[114] = (-7989.4492, -233.3638, 1280.0748);
	angles[114] = (0, -81.7840, 0);
	at[114] = 106;
	points[115] = (-7989.3701, -233.7063, 1280.0472);
	angles[115] = (0, -81.7840, 0);
	at[115] = 106.5000;
	points[116] = (-7985.9839, -247.2925, 1278.7756);
	angles[116] = (0, -81.7840, 0);
	at[116] = 107.5000;
	points[117] = (-7985.7876, -247.9776, 1278.7086);
	angles[117] = (0, -81.7840, 0);
	at[117] = 108;
	points[118] = (-7983.9766, -255.2843, 1278.0078);
	angles[118] = (0, -81.7840, 0);
	at[118] = 108.5000;
	points[119] = (-7983.8979, -255.6268, 1277.9764);
	angles[119] = (0, -81.7840, 0);
	at[119] = 109;
	points[120] = (-7980.5122, -269.2130, 1276.7362);
	angles[120] = (0, -81.7840, 0);
	at[120] = 110;
	points[121] = (-7980.3545, -269.8980, 1276.6733);
	angles[121] = (0, -81.7840, 0);
	at[121] = 110.5000;
	points[122] = (-7978.5044, -277.2047, 1276.0118);
	angles[122] = (0, -81.7840, 0);
	at[122] = 111;
	points[123] = (-7978.4248, -277.5472, 1275.9803);
	angles[123] = (0, -81.7840, 0);
	at[123] = 111.5000;
	points[124] = (-7975.0391, -291.1335, 1274.7480);
	angles[124] = (0, -81.7840, 0);
	at[124] = 112.5000;
	points[125] = (-7974.8818, -291.8185, 1274.6851);
	angles[125] = (0, -81.7840, 0);
	at[125] = 113;
	points[126] = (-7973.0317, -299.1252, 1274.0236);
	angles[126] = (0, -81.7840, 0);
	at[126] = 113.5000;
	points[127] = (-7972.9526, -299.4677, 1273.9922);
	angles[127] = (0, -81.7840, 0);
	at[127] = 114;
	points[128] = (-7969.5669, -313.0540, 1272.7598);
	angles[128] = (0, -81.7840, 0);
	at[128] = 115;
	points[129] = (-7969.4097, -313.7390, 1272.6969);
	angles[129] = (0, -81.7840, 0);
	at[129] = 115.5000;
	points[130] = (-7967.5986, -321.0457, 1272.0354);
	angles[130] = (0, -81.7840, 0);
	at[130] = 116;
	points[131] = (-7967.4800, -321.3882, 1272.0039);
	angles[131] = (0, -81.7840, 0);
	at[131] = 116.5000;
	points[132] = (-7964.0942, -334.9744, 1270.7716);
	angles[132] = (0, -81.7840, 0);
	at[132] = 117.5000;
	points[133] = (-7963.9370, -335.6595, 1270.7087);
	angles[133] = (0, -81.7840, 0);
	at[133] = 118;
	points[134] = (-7962.1265, -342.9662, 1270.0472);
	angles[134] = (0, -81.7840, 0);
	at[134] = 118.5000;
	points[135] = (-7962.0469, -343.3087, 1270.0157);
	angles[135] = (0, -81.7840, 0);
	at[135] = 119;
	points[136] = (-7958.6611, -356.8949, 1268.7834);
	angles[136] = (0, -81.7840, 0);
	at[136] = 120;
	points[137] = (-7958.4648, -357.5799, 1268.7205);
	angles[137] = (0, -81.7840, 0);
	at[137] = 120.5000;
	points[138] = (-7956.6538, -364.8866, 1268.0551);
	angles[138] = (0, -81.7840, 0);
	at[138] = 121;
	points[139] = (-7956.5747, -365.2292, 1268.0276);
	angles[139] = (0, -81.7840, 0);
	at[139] = 121.5000;
	points[140] = (-7953.1890, -378.8154, 1266.7953);
	angles[140] = (0, -81.7840, 0);
	at[140] = 122.5000;
	points[141] = (-7953.0317, -379.5004, 1266.7323);
	angles[141] = (0, -81.7840, 0);
	at[141] = 123;
	points[142] = (-7951.1816, -386.8071, 1266.0669);
	angles[142] = (0, -81.7840, 0);
	at[142] = 123.5000;
	points[143] = (-7951.1021, -387.1496, 1266.0393);
	angles[143] = (0, -81.7840, 0);
	at[143] = 124;
	points[144] = (-7947.7163, -400.7362, 1264.8031);
	angles[144] = (0, -81.7840, 0);
	at[144] = 125;
	points[145] = (-7947.5591, -401.4213, 1264.7441);
	angles[145] = (0, -81.7840, 0);
	at[145] = 125.5000;
	points[146] = (-7945.7085, -408.7283, 1264.0789);
	angles[146] = (0, -81.7840, 0);
	at[146] = 126;
	points[147] = (-7945.6299, -409.0709, 1264.0472);
	angles[147] = (0, -81.7840, 0);
	at[147] = 126.5000;
	points[148] = (-7942.2441, -422.6575, 1262.8149);
	angles[148] = (0, -81.7840, 0);
	at[148] = 127.5000;
	points[149] = (-7942.0869, -423.3425, 1262.7560);
	angles[149] = (0, -81.7840, 0);
	at[149] = 128;
	points[150] = (-7940.2754, -430.6496, 1262.0905);
	angles[150] = (0, -81.7840, 0);
	at[150] = 128.5000;
	points[151] = (-7940.1572, -430.9921, 1262.0591);
	angles[151] = (0, -81.7840, 0);
	at[151] = 129;
	points[152] = (-7936.7715, -444.5748, 1260.8269);
	angles[152] = (0, -81.7840, 0);
	at[152] = 130;
	points[153] = (-7936.6143, -445.2599, 1260.7638);
	angles[153] = (0, -81.7840, 0);
	at[153] = 130.5000;
	points[154] = (-7934.8037, -452.5670, 1260.1023);
	angles[154] = (0, -81.7840, 0);
	at[154] = 131;
	points[155] = (-7934.7246, -452.9094, 1260.0708);
	angles[155] = (0, -81.7840, 0);
	at[155] = 131.5000;
	points[156] = (-7931.3384, -466.4961, 1258.8386);
	angles[156] = (0, -81.7840, 0);
	at[156] = 132.5000;
	points[157] = (-7931.1421, -467.1811, 1258.7756);
	angles[157] = (0, -81.7840, 0);
	at[157] = 133;
	points[158] = (-7929.3306, -474.4882, 1258.1143);
	angles[158] = (0, -81.7840, 0);
	at[158] = 133.5000;
	points[159] = (-7929.2520, -474.8307, 1258.0826);
	angles[159] = (0, -81.7840, 0);
	at[159] = 134;
	points[160] = (-7925.8662, -488.4173, 1256.8268);
	angles[160] = (0, -81.7840, 0);
	at[160] = 135;
	points[161] = (-7925.6694, -489.1024, 1256.7599);
	angles[161] = (0, -81.7840, 0);
	at[161] = 135.5000;
	points[162] = (-7923.8584, -496.4095, 1256.0511);
	angles[162] = (0, -81.7840, 0);
	at[162] = 136;
	points[163] = (-7923.7798, -496.7520, 1256.0198);
	angles[163] = (0, -81.7840, 0);
	at[163] = 136.5000;
	points[164] = (-7920.3936, -510.3386, 1254.6969);
	angles[164] = (0, -81.7840, 0);
	at[164] = 137.5000;
	points[165] = (-7920.2363, -511.0236, 1254.6339);
	angles[165] = (0, -81.7840, 0);
	at[165] = 138;
	points[166] = (-7918.3857, -518.3307, 1253.9213);
	angles[166] = (0, -81.7840, 0);
	at[166] = 138.5000;
	points[167] = (-7918.3071, -518.6732, 1253.8898);
	angles[167] = (0, -81.7840, 0);
	at[167] = 139;
	points[168] = (-7914.9214, -532.2598, 1252.5984);
	angles[168] = (0, -81.7840, 0);
	at[168] = 140;
	points[169] = (-7914.7642, -532.9449, 1252.5354);
	angles[169] = (0, -81.7840, 0);
	at[169] = 140.5000;
	points[170] = (-7913.1104, -539.5670, 1251.9331);
	angles[170] = (0, -81.7840, 0);
	at[170] = 140.8330;
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
	points[0] = (-9433.2676, -1459.0157, 1246.6221);
	angles[0] = (0, -29.9740, 0);
	at[0] = 0;
	points[1] = (-9427.5986, -1463.7914, 1246.0906);
	angles[1] = (0, -29.9740, 0);
	at[1] = 0.4500;
	points[2] = (-9427.4805, -1463.8662, 1246.0826);
	angles[2] = (0, -29.9740, 0);
	at[2] = 0.9000;
	points[3] = (-9421.7324, -1468.7205, 1245.5433);
	angles[3] = (0, -29.9740, 0);
	at[3] = 1.3500;
	points[4] = (-9421.7324, -1468.7205, 1245.5433);
	angles[4] = (0, -29.9740, 0);
	at[4] = 1.8000;
	points[5] = (-9415.9443, -1473.5709, 1245.0472);
	angles[5] = (0, -29.9740, 0);
	at[5] = 2.2500;
	points[6] = (-9415.9443, -1473.5709, 1245.0472);
	angles[6] = (0, -29.9740, 0);
	at[6] = 2.7000;
	points[7] = (-9410.1582, -1478.4213, 1244.6182);
	angles[7] = (0, -29.9740, 0);
	at[7] = 3.1500;
	points[8] = (-9409.6064, -1478.8779, 1244.5748);
	angles[8] = (0, -29.9740, 0);
	at[8] = 3.6000;
	points[9] = (-9393.7012, -1492.2167, 1243.3859);
	angles[9] = (0, -29.9740, 0);
	at[9] = 5.4000;
	points[10] = (-9392.7949, -1492.9764, 1243.3188);
	angles[10] = (0, -29.9740, 0);
	at[10] = 5.8500;
	points[11] = (-9387.0078, -1497.8268, 1242.8859);
	angles[11] = (0, -29.9740, 0);
	at[11] = 6.3000;
	points[12] = (-9387.0078, -1497.8268, 1242.8859);
	angles[12] = (0, -29.9740, 0);
	at[12] = 6.7500;
	points[13] = (-9381.2598, -1502.6810, 1242.4528);
	angles[13] = (0, -29.9740, 0);
	at[13] = 7.2000;
	points[14] = (-9381.2598, -1502.6810, 1242.4528);
	angles[14] = (0, -29.9740, 0);
	at[14] = 7.6500;
	points[15] = (-9375.4727, -1507.5316, 1242.0197);
	angles[15] = (0, -29.9740, 0);
	at[15] = 8.1000;
	points[16] = (-9375.4727, -1507.5316, 1242.0197);
	angles[16] = (0, -29.9740, 0);
	at[16] = 8.5500;
	points[17] = (-9369.6855, -1512.3820, 1241.5867);
	angles[17] = (0, -29.9740, 0);
	at[17] = 9;
	points[18] = (-9368.7793, -1513.1417, 1241.5197);
	angles[18] = (0, -29.9740, 0);
	at[18] = 9.4500;
	points[19] = (-9352.8740, -1526.4802, 1240.3307);
	angles[19] = (0, -29.9740, 0);
	at[19] = 11.2500;
	points[20] = (-9352.3232, -1526.9370, 1240.2914);
	angles[20] = (0, -29.9740, 0);
	at[20] = 11.7000;
	points[21] = (-9346.5352, -1531.7874, 1239.8583);
	angles[21] = (0, -29.9740, 0);
	at[21] = 12.1500;
	points[22] = (-9346.5352, -1531.7874, 1239.8583);
	angles[22] = (0, -29.9740, 0);
	at[22] = 12.6000;
	points[23] = (-9340.7871, -1536.6417, 1239.4252);
	angles[23] = (0, -29.9740, 0);
	at[23] = 13.0500;
	points[24] = (-9340.7871, -1536.6417, 1239.4252);
	angles[24] = (0, -29.9740, 0);
	at[24] = 13.5000;
	points[25] = (-9334.9209, -1541.4292, 1238.9922);
	angles[25] = (0, -29.9740, 0);
	at[25] = 13.9500;
	points[26] = (-9334.8428, -1541.5040, 1238.9883);
	angles[26] = (0, -29.9740, 0);
	at[26] = 14.4000;
	points[27] = (-9329.0947, -1546.2166, 1238.5630);
	angles[27] = (0, -29.9740, 0);
	at[27] = 14.8500;
	points[28] = (-9327.7168, -1547.3385, 1238.4606);
	angles[28] = (0, -29.9740, 0);
	at[28] = 15.3000;
	points[29] = (-9317.4404, -1555.7914, 1237.7008);
	angles[29] = (0, -29.9740, 0);
	at[29] = 16.6500;
	points[30] = (-9311.8506, -1560.3544, 1237.2874);
	angles[30] = (0, -29.9740, 0);
	at[30] = 17.1000;
	points[31] = (-9311.6143, -1560.5787, 1237.2677);
	angles[31] = (0, -29.9740, 0);
	at[31] = 17.5500;
	points[32] = (-9305.7480, -1565.3661, 1236.8386);
	angles[32] = (0, -29.9740, 0);
	at[32] = 18;
	points[33] = (-9305.7480, -1565.3661, 1236.8386);
	angles[33] = (0, -29.9740, 0);
	at[33] = 18.4500;
	points[34] = (-9299.9219, -1570.1497, 1236.4055);
	angles[34] = (0, -29.9740, 0);
	at[34] = 18.9000;
	points[35] = (-9299.9219, -1570.1497, 1236.4055);
	angles[35] = (0, -29.9740, 0);
	at[35] = 19.3500;
	points[36] = (-9294.0947, -1574.9370, 1235.9724);
	angles[36] = (0, -29.9740, 0);
	at[36] = 19.8000;
	points[37] = (-9293.8193, -1575.1615, 1235.9528);
	angles[37] = (0, -29.9740, 0);
	at[37] = 20.2500;
	points[38] = (-9288.2676, -1579.7245, 1235.5433);
	angles[38] = (0, -29.9740, 0);
	at[38] = 20.7000;
	points[39] = (-9286.3389, -1581.2954, 1235.4016);
	angles[39] = (0, -29.9740, 0);
	at[39] = 21.1500;
	points[40] = (-9277.9531, -1588.1771, 1234.7363);
	angles[40] = (0, -29.9740, 0);
	at[40] = 22.0500;
	points[41] = (-9276.5752, -1589.2992, 1234.6102);
	angles[41] = (0, -29.9740, 0);
	at[41] = 22.5000;
	points[42] = (-9270.8271, -1594.0118, 1234.0826);
	angles[42] = (0, -29.9740, 0);
	at[42] = 22.9500;
	points[43] = (-9270.7480, -1594.0867, 1234.0748);
	angles[43] = (0, -29.9740, 0);
	at[43] = 23.4000;
	points[44] = (-9264.9209, -1598.8701, 1233.5826);
	angles[44] = (0, -29.9740, 0);
	at[44] = 23.8500;
	points[45] = (-9264.9209, -1598.8701, 1233.5826);
	angles[45] = (0, -29.9740, 0);
	at[45] = 24.3000;
	points[46] = (-9259.0947, -1603.6575, 1233.1575);
	angles[46] = (0, -29.9740, 0);
	at[46] = 24.7500;
	points[47] = (-9259.0947, -1603.6575, 1233.1575);
	angles[47] = (0, -29.9740, 0);
	at[47] = 25.2000;
	points[48] = (-9253.2285, -1608.4449, 1232.7362);
	angles[48] = (0, -29.9740, 0);
	at[48] = 25.6500;
	points[49] = (-9252.6777, -1608.8937, 1232.6929);
	angles[49] = (0, -29.9740, 0);
	at[49] = 26.1000;
	points[50] = (-9236.6533, -1622.0590, 1231.5276);
	angles[50] = (0, -29.9740, 0);
	at[50] = 27.9000;
	points[51] = (-9235.7480, -1622.8071, 1231.4607);
	angles[51] = (0, -29.9740, 0);
	at[51] = 28.3500;
	points[52] = (-9229.8818, -1627.5945, 1231.0354);
	angles[52] = (0, -29.9740, 0);
	at[52] = 28.8000;
	points[53] = (-9229.8818, -1627.5945, 1231.0354);
	angles[53] = (0, -29.9740, 0);
	at[53] = 29.2500;
	points[54] = (-9224.0557, -1632.3779, 1230.6143);
	angles[54] = (0, -29.9740, 0);
	at[54] = 29.7000;
	points[55] = (-9224.0557, -1632.3779, 1230.6143);
	angles[55] = (0, -29.9740, 0);
	at[55] = 30.1500;
	points[56] = (-9218.3467, -1637.2992, 1230.1890);
	angles[56] = (0, -29.9740, 0);
	at[56] = 30.6000;
	points[57] = (-9218.3467, -1637.2992, 1230.1890);
	angles[57] = (0, -29.9740, 0);
	at[57] = 31.0500;
	points[58] = (-9212.6387, -1642.2599, 1229.7599);
	angles[58] = (0, -29.9740, 0);
	at[58] = 31.5000;
	points[59] = (-9211.7715, -1643.0355, 1229.6969);
	angles[59] = (0, -29.9740, 0);
	at[59] = 31.9500;
	points[60] = (-9196.1025, -1656.6732, 1228.5237);
	angles[60] = (0, -29.9740, 0);
	at[60] = 33.7500;
	points[61] = (-9195.5908, -1657.1378, 1228.4843);
	angles[61] = (0, -29.9740, 0);
	at[61] = 34.2000;
	points[62] = (-9189.8818, -1662.0985, 1228.0591);
	angles[62] = (0, -29.9740, 0);
	at[62] = 34.6500;
	points[63] = (-9189.8818, -1662.0985, 1228.0591);
	angles[63] = (0, -29.9740, 0);
	at[63] = 35.1000;
	points[64] = (-9184.2129, -1667.0591, 1227.6339);
	angles[64] = (0, -29.9740, 0);
	at[64] = 35.5500;
	points[65] = (-9184.2129, -1667.0591, 1227.6339);
	angles[65] = (0, -29.9740, 0);
	at[65] = 36;
	points[66] = (-9178.5039, -1672.0157, 1227.2047);
	angles[66] = (0, -29.9740, 0);
	at[66] = 36.4500;
	points[67] = (-9178.4258, -1672.0945, 1227.2008);
	angles[67] = (0, -29.9740, 0);
	at[67] = 36.9000;
	points[68] = (-9172.8350, -1676.9764, 1226.7795);
	angles[68] = (0, -29.9740, 0);
	at[68] = 37.3500;
	points[69] = (-9171.4961, -1678.1378, 1226.6812);
	angles[69] = (0, -29.9740, 0);
	at[69] = 37.8000;
	points[70] = (-9163.3076, -1685.2678, 1226.0669);
	angles[70] = (0, -29.9740, 0);
	at[70] = 38.7000;
	points[71] = (-9161.4570, -1686.8937, 1225.9291);
	angles[71] = (0, -29.9740, 0);
	at[71] = 39.1500;
	points[72] = (-9156.0234, -1691.6221, 1225.5237);
	angles[72] = (0, -29.9740, 0);
	at[72] = 39.6000;
	points[73] = (-9155.7480, -1691.8542, 1225.5039);
	angles[73] = (0, -29.9740, 0);
	at[73] = 40.0500;
	points[74] = (-9150, -1696.7245, 1225.0787);
	angles[74] = (0, -29.9740, 0);
	at[74] = 40.5000;
	points[75] = (-9150, -1696.7245, 1225.0787);
	angles[75] = (0, -29.9740, 0);
	at[75] = 40.9500;
	points[76] = (-9144.2129, -1701.5748, 1224.6536);
	angles[76] = (0, -29.9740, 0);
	at[76] = 41.4000;
	points[77] = (-9144.2129, -1701.5748, 1224.6536);
	angles[77] = (0, -29.9740, 0);
	at[77] = 41.8500;
	points[78] = (-9138.4248, -1706.4253, 1224.2284);
	angles[78] = (0, -29.9740, 0);
	at[78] = 42.3000;
	points[79] = (-9138.1494, -1706.6536, 1224.2087);
	angles[79] = (0, -29.9740, 0);
	at[79] = 42.7500;
	points[80] = (-9132.6377, -1711.2795, 1223.8032);
	angles[80] = (0, -29.9740, 0);
	at[80] = 43.2000;
	points[81] = (-9130.7480, -1712.8701, 1223.6654);
	angles[81] = (0, -29.9740, 0);
	at[81] = 43.6500;
	points[82] = (-9122.4414, -1719.8424, 1223.0394);
	angles[82] = (0, -29.9740, 0);
	at[82] = 44.5500;
	points[83] = (-9121.1025, -1720.9802, 1222.9135);
	angles[83] = (0, -29.9740, 0);
	at[83] = 45;
	points[84] = (-9115.3936, -1725.7560, 1222.5039);
	angles[84] = (0, -29.9740, 0);
	at[84] = 45.4500;
	points[85] = (-9115.3154, -1725.8308, 1222.5000);
	angles[85] = (0, -29.9740, 0);
	at[85] = 45.9000;
	points[86] = (-9109.5273, -1730.6851, 1222.0826);
	angles[86] = (0, -29.9740, 0);
	at[86] = 46.3500;
	points[87] = (-9109.5273, -1730.6851, 1222.0826);
	angles[87] = (0, -29.9740, 0);
	at[87] = 46.8000;
	points[88] = (-9103.7402, -1735.5354, 1221.6654);
	angles[88] = (0, -29.9740, 0);
	at[88] = 47.2500;
	points[89] = (-9103.7402, -1735.5354, 1221.6654);
	angles[89] = (0, -29.9740, 0);
	at[89] = 47.7000;
	points[90] = (-9097.9531, -1740.3859, 1221.2520);
	angles[90] = (0, -29.9740, 0);
	at[90] = 48.1500;
	points[91] = (-9097.4023, -1740.8425, 1221.2126);
	angles[91] = (0, -29.9740, 0);
	at[91] = 48.6000;
	points[92] = (-9081.5361, -1754.1810, 1220.0591);
	angles[92] = (0, -29.9740, 0);
	at[92] = 50.4000;
	points[93] = (-9080.6299, -1754.9410, 1219.9922);
	angles[93] = (0, -29.9740, 0);
	at[93] = 50.8500;
	points[94] = (-9074.8428, -1759.7914, 1219.5748);
	angles[94] = (0, -29.9740, 0);
	at[94] = 51.3000;
	points[95] = (-9074.8428, -1759.7914, 1219.5748);
	angles[95] = (0, -29.9740, 0);
	at[95] = 51.7500;
	points[96] = (-9069.0557, -1764.6417, 1219.1536);
	angles[96] = (0, -29.9740, 0);
	at[96] = 52.2000;
	points[97] = (-9069.0557, -1764.6417, 1219.1536);
	angles[97] = (0, -29.9740, 0);
	at[97] = 52.6500;
	points[98] = (-9063.2676, -1769.4962, 1218.7362);
	angles[98] = (0, -29.9740, 0);
	at[98] = 53.1000;
	points[99] = (-9062.2441, -1770.3662, 1218.6615);
	angles[99] = (0, -29.9740, 0);
	at[99] = 54;
	points[100] = (-9067.7559, -1765.7402, 1219.0591);
	angles[100] = (0, -29.9740, 0);
	at[100] = 54.4500;
	points[101] = (-9077.9531, -1757.1772, 1219.7992);
	angles[101] = (0, -29.9740, 0);
	at[101] = 55.8000;
	points[102] = (-9079.2910, -1756.0394, 1219.8976);
	angles[102] = (0, -29.9740, 0);
	at[102] = 56.2500;
	points[103] = (-9085, -1751.2639, 1220.3110);
	angles[103] = (0, -29.9740, 0);
	at[103] = 56.7000;
	points[104] = (-9085.0791, -1751.1891, 1220.3188);
	angles[104] = (0, -29.9740, 0);
	at[104] = 57.1500;
	points[105] = (-9090.8662, -1746.3385, 1220.7362);
	angles[105] = (0, -29.9740, 0);
	at[105] = 57.6000;
	points[106] = (-9090.8662, -1746.3385, 1220.7362);
	angles[106] = (0, -29.9740, 0);
	at[106] = 58.0500;
	points[107] = (-9096.6533, -1741.4843, 1221.1575);
	angles[107] = (0, -29.9740, 0);
	at[107] = 58.5000;
	points[108] = (-9096.6533, -1741.4843, 1221.1575);
	angles[108] = (0, -29.9740, 0);
	at[108] = 58.9500;
	points[109] = (-9102.4404, -1736.6339, 1221.5709);
	angles[109] = (0, -29.9740, 0);
	at[109] = 59.4000;
	points[110] = (-9102.9531, -1736.1810, 1221.6102);
	angles[110] = (0, -29.9740, 0);
	at[110] = 59.8500;
	points[111] = (-9118.8584, -1722.8386, 1222.7560);
	angles[111] = (0, -29.9740, 0);
	at[111] = 61.6500;
	points[112] = (-9119.7637, -1722.0787, 1222.8190);
	angles[112] = (0, -29.9740, 0);
	at[112] = 62.1000;
	points[113] = (-9125.5518, -1717.2284, 1223.2834);
	angles[113] = (0, -29.9740, 0);
	at[113] = 62.5500;
	points[114] = (-9125.5518, -1717.2284, 1223.2834);
	angles[114] = (0, -29.9740, 0);
	at[114] = 63;
	points[115] = (-9131.3389, -1712.3779, 1223.7086);
	angles[115] = (0, -29.9740, 0);
	at[115] = 63.4500;
	points[116] = (-9131.3389, -1712.3779, 1223.7086);
	angles[116] = (0, -29.9740, 0);
	at[116] = 63.9000;
	points[117] = (-9137.1260, -1707.5276, 1224.1299);
	angles[117] = (0, -29.9740, 0);
	at[117] = 64.3500;
	points[118] = (-9137.1260, -1707.5276, 1224.1299);
	angles[118] = (0, -29.9740, 0);
	at[118] = 64.8000;
	points[119] = (-9142.9131, -1702.6732, 1224.5552);
	angles[119] = (0, -29.9740, 0);
	at[119] = 65.2500;
	points[120] = (-9143.8193, -1701.9172, 1224.6221);
	angles[120] = (0, -29.9740, 0);
	at[120] = 65.7000;
	points[121] = (-9159.6064, -1688.4843, 1225.7914);
	angles[121] = (0, -29.9740, 0);
	at[121] = 67.5000;
	points[122] = (-9160.1572, -1688.0198, 1225.8308);
	angles[122] = (0, -29.9740, 0);
	at[122] = 67.9500;
	points[123] = (-9165.8271, -1683.0591, 1226.2599);
	angles[123] = (0, -29.9740, 0);
	at[123] = 68.4000;
	points[124] = (-9165.8271, -1683.0591, 1226.2599);
	angles[124] = (0, -29.9740, 0);
	at[124] = 68.8500;
	points[125] = (-9171.5352, -1678.0984, 1226.6851);
	angles[125] = (0, -29.9740, 0);
	at[125] = 69.3000;
	points[126] = (-9171.5352, -1678.0984, 1226.6851);
	angles[126] = (0, -29.9740, 0);
	at[126] = 69.7500;
	points[127] = (-9177.2441, -1673.1417, 1227.1102);
	angles[127] = (0, -29.9740, 0);
	at[127] = 70.2000;
	points[128] = (-9177.3232, -1673.0630, 1227.1182);
	angles[128] = (0, -29.9740, 0);
	at[128] = 70.6500;
	points[129] = (-9182.9141, -1668.1812, 1227.5354);
	angles[129] = (0, -29.9740, 0);
	at[129] = 71.1000;
	points[130] = (-9184.2520, -1667.0198, 1227.6339);
	angles[130] = (0, -29.9740, 0);
	at[130] = 71.5500;
	points[131] = (-9192.4414, -1659.8899, 1228.2480);
	angles[131] = (0, -29.9740, 0);
	at[131] = 72.4500;
	points[132] = (-9194.2920, -1658.2638, 1228.3859);
	angles[132] = (0, -29.9740, 0);
	at[132] = 72.9000;
	points[133] = (-9199.7246, -1653.5355, 1228.7953);
	angles[133] = (0, -29.9740, 0);
	at[133] = 73.3500;
	points[134] = (-9200, -1653.3032, 1228.8151);
	angles[134] = (0, -29.9740, 0);
	at[134] = 73.8000;
	points[135] = (-9205.6699, -1648.3425, 1229.2402);
	angles[135] = (0, -29.9740, 0);
	at[135] = 74.2500;
	points[136] = (-9205.6699, -1648.3425, 1229.2402);
	angles[136] = (0, -29.9740, 0);
	at[136] = 74.7000;
	points[137] = (-9211.3779, -1643.3859, 1229.6654);
	angles[137] = (0, -29.9740, 0);
	at[137] = 75.1500;
	points[138] = (-9211.3779, -1643.3859, 1229.6654);
	angles[138] = (0, -29.9740, 0);
	at[138] = 75.6000;
	points[139] = (-9217.0479, -1638.4253, 1230.0906);
	angles[139] = (0, -29.9740, 0);
	at[139] = 76.0500;
	points[140] = (-9217.3223, -1638.1929, 1230.1102);
	angles[140] = (0, -29.9740, 0);
	at[140] = 76.5000;
	points[141] = (-9222.7559, -1633.4646, 1230.5157);
	angles[141] = (0, -29.9740, 0);
	at[141] = 76.9500;
	points[142] = (-9233.0312, -1625.0118, 1231.2677);
	angles[142] = (0, -29.9740, 0);
	at[142] = 78.3000;
	points[143] = (-9234.4092, -1623.8898, 1231.3661);
	angles[143] = (0, -29.9740, 0);
	at[143] = 78.7500;
	points[144] = (-9240.1572, -1619.1772, 1231.7834);
	angles[144] = (0, -29.9740, 0);
	at[144] = 79.2000;
	points[145] = (-9240.2363, -1619.1023, 1231.7914);
	angles[145] = (0, -29.9740, 0);
	at[145] = 79.6500;
	points[146] = (-9246.1025, -1614.3190, 1232.2126);
	angles[146] = (0, -29.9740, 0);
	at[146] = 80.1000;
	points[147] = (-9246.1025, -1614.3190, 1232.2126);
	angles[147] = (0, -29.9740, 0);
	at[147] = 80.5500;
	points[148] = (-9251.9287, -1609.5315, 1232.6378);
	angles[148] = (0, -29.9740, 0);
	at[148] = 81;
	points[149] = (-9251.9287, -1609.5315, 1232.6378);
	angles[149] = (0, -29.9740, 0);
	at[149] = 81.4500;
	points[150] = (-9257.7559, -1604.7441, 1233.0630);
	angles[150] = (0, -29.9740, 0);
	at[150] = 81.9000;
	points[151] = (-9258.3066, -1604.2953, 1233.1024);
	angles[151] = (0, -29.9740, 0);
	at[151] = 82.3500;
	points[152] = (-9274.3301, -1591.1299, 1234.4055);
	angles[152] = (0, -29.9740, 0);
	at[152] = 84.1500;
	points[153] = (-9275.2754, -1590.3818, 1234.4883);
	angles[153] = (0, -29.9740, 0);
	at[153] = 84.6000;
	points[154] = (-9281.1025, -1585.5946, 1235.0157);
	angles[154] = (0, -29.9740, 0);
	at[154] = 85.0500;
	points[155] = (-9281.1025, -1585.5946, 1235.0157);
	angles[155] = (0, -29.9740, 0);
	at[155] = 85.5000;
	points[156] = (-9286.9297, -1580.8110, 1235.4449);
	angles[156] = (0, -29.9740, 0);
	at[156] = 85.9500;
	points[157] = (-9286.9297, -1580.8110, 1235.4449);
	angles[157] = (0, -29.9740, 0);
	at[157] = 86.4000;
	points[158] = (-9292.7559, -1576.0236, 1235.8779);
	angles[158] = (0, -29.9740, 0);
	at[158] = 86.8500;
	points[159] = (-9292.7559, -1576.0236, 1235.8779);
	angles[159] = (0, -29.9740, 0);
	at[159] = 87.3000;
	points[160] = (-9298.5830, -1571.2363, 1236.3071);
	angles[160] = (0, -29.9740, 0);
	at[160] = 87.7500;
	points[161] = (-9299.5273, -1570.4882, 1236.3740);
	angles[161] = (0, -29.9740, 0);
	at[161] = 88.2000;
	points[162] = (-9315.5518, -1557.3229, 1237.5630);
	angles[162] = (0, -29.9740, 0);
	at[162] = 90;
	points[163] = (-9316.1025, -1556.8741, 1237.6024);
	angles[163] = (0, -29.9740, 0);
	at[163] = 90.4500;
	points[164] = (-9321.9287, -1552.0867, 1238.0315);
	angles[164] = (0, -29.9740, 0);
	at[164] = 90.9000;
	points[165] = (-9321.9287, -1552.0867, 1238.0315);
	angles[165] = (0, -29.9740, 0);
	at[165] = 91.3500;
	points[166] = (-9327.7949, -1547.3031, 1238.4646);
	angles[166] = (0, -29.9740, 0);
	at[166] = 91.8000;
	points[167] = (-9327.7949, -1547.3031, 1238.4646);
	angles[167] = (0, -29.9740, 0);
	at[167] = 92.2500;
	points[168] = (-9333.6221, -1542.5159, 1238.8937);
	angles[168] = (0, -29.9740, 0);
	at[168] = 92.7000;
	points[169] = (-9333.7012, -1542.4410, 1238.9016);
	angles[169] = (0, -29.9740, 0);
	at[169] = 93.1500;
	points[170] = (-9339.4492, -1537.7284, 1239.3268);
	angles[170] = (0, -29.9740, 0);
	at[170] = 93.6000;
	points[171] = (-9340.8271, -1536.6063, 1239.4292);
	angles[171] = (0, -29.9740, 0);
	at[171] = 94.0500;
	points[172] = (-9349.1338, -1529.6261, 1240.0511);
	angles[172] = (0, -29.9740, 0);
	at[172] = 94.9500;
	points[173] = (-9351.0244, -1528.0354, 1240.1930);
	angles[173] = (0, -29.9740, 0);
	at[173] = 95.4000;
	points[174] = (-9356.5361, -1523.4133, 1240.6023);
	angles[174] = (0, -29.9740, 0);
	at[174] = 95.8500;
	points[175] = (-9356.8105, -1523.1851, 1240.6260);
	angles[175] = (0, -29.9740, 0);
	at[175] = 96.3000;
	points[176] = (-9362.5986, -1518.3347, 1241.0591);
	angles[176] = (0, -29.9740, 0);
	at[176] = 96.7500;
	points[177] = (-9362.5986, -1518.3347, 1241.0591);
	angles[177] = (0, -29.9740, 0);
	at[177] = 97.2000;
	points[178] = (-9368.3857, -1513.4803, 1241.4882);
	angles[178] = (0, -29.9740, 0);
	at[178] = 97.6500;
	points[179] = (-9368.3857, -1513.4803, 1241.4882);
	angles[179] = (0, -29.9740, 0);
	at[179] = 98.1000;
	points[180] = (-9374.1338, -1508.6299, 1241.9213);
	angles[180] = (0, -29.9740, 0);
	at[180] = 98.5500;
	points[181] = (-9374.4092, -1508.4016, 1241.9409);
	angles[181] = (0, -29.9740, 0);
	at[181] = 99;
	points[182] = (-9379.9209, -1503.7795, 1242.3544);
	angles[182] = (0, -29.9740, 0);
	at[182] = 99.4500;
	points[183] = (-9381.8115, -1502.1851, 1242.4961);
	angles[183] = (0, -29.9740, 0);
	at[183] = 99.9000;
	points[184] = (-9390.1572, -1495.2126, 1243.1180);
	angles[184] = (0, -29.9740, 0);
	at[184] = 100.8000;
	points[185] = (-9391.4961, -1494.0748, 1243.2205);
	angles[185] = (0, -29.9740, 0);
	at[185] = 101.2500;
	points[186] = (-9397.2051, -1489.2993, 1243.6456);
	angles[186] = (0, -29.9740, 0);
	at[186] = 101.7000;
	points[187] = (-9397.2832, -1489.2245, 1243.6536);
	angles[187] = (0, -29.9740, 0);
	at[187] = 102.1500;
	points[188] = (-9403.0713, -1484.3740, 1244.0867);
	angles[188] = (0, -29.9740, 0);
	at[188] = 102.6000;
	points[189] = (-9403.0713, -1484.3740, 1244.0867);
	angles[189] = (0, -29.9740, 0);
	at[189] = 103.0500;
	points[190] = (-9408.8584, -1479.5197, 1244.5197);
	angles[190] = (0, -29.9740, 0);
	at[190] = 103.5000;
	points[191] = (-9408.8584, -1479.5197, 1244.5197);
	angles[191] = (0, -29.9740, 0);
	at[191] = 103.9500;
	points[192] = (-9414.6064, -1474.6693, 1244.9528);
	angles[192] = (0, -29.9740, 0);
	at[192] = 104.4000;
	points[193] = (-9415.1582, -1474.2126, 1244.9922);
	angles[193] = (0, -29.9740, 0);
	at[193] = 104.8500;
	points[194] = (-9431.0625, -1460.8740, 1246.4133);
	angles[194] = (0, -29.9740, 0);
	at[194] = 106.6500;
	points[195] = (-9433.2676, -1459.0157, 1246.6221);
	angles[195] = (0, -29.9740, 0);
	at[195] = 107.5000;
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
