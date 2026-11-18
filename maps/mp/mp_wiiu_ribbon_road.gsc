main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_ribbon_road", 0);

	setExpFog(2952.7559, 19484.2500, 0.5490, 0.8431, 1, 0);

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
	ambientPlay("iz_0_urrir", 2);
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
	level.iz_route[level.iz_route.size] = (-5832, -4783, 1885);
	level.iz_route[level.iz_route.size] = (-8230, -4827, 1865);
	level.iz_route[level.iz_route.size] = (-9196, -4701, 1886);
	level.iz_route[level.iz_route.size] = (-9752, -4309, 1929);
	level.iz_route[level.iz_route.size] = (-10037, -3495, 1891);
	level.iz_route[level.iz_route.size] = (-9953, -701, 1900);
	level.iz_route[level.iz_route.size] = (-9541, -25, 1953);
	level.iz_route[level.iz_route.size] = (-8526, 195, 2032);
	level.iz_route[level.iz_route.size] = (-7461, -251, 1988);
	level.iz_route[level.iz_route.size] = (-7180, -1446, 1915);
	level.iz_route[level.iz_route.size] = (-7135, -2286, 2047);
	level.iz_route[level.iz_route.size] = (-7156, -4027, 2272);
	level.iz_route[level.iz_route.size] = (-7114, -5803, 2345);
	level.iz_route[level.iz_route.size] = (-7143, -6911, 1403);
	level.iz_route[level.iz_route.size] = (-7133, -8667, 1424);
	level.iz_route[level.iz_route.size] = (-6979, -9385, 1477);
	level.iz_route[level.iz_route.size] = (-6600, -9837, 1537);
	level.iz_route[level.iz_route.size] = (-3940, -10000, 1402);
	level.iz_route[level.iz_route.size] = (-3206, -10330, 1404);
	level.iz_route[level.iz_route.size] = (-2598, -10521, 1452);
	level.iz_route[level.iz_route.size] = (-1970, -10462, 1514);
	level.iz_route[level.iz_route.size] = (-1348, -9934, 1583);
	level.iz_route[level.iz_route.size] = (-1337, -9104, 1505);
	level.iz_route[level.iz_route.size] = (-1623, -8443, 1433);
	level.iz_route[level.iz_route.size] = (-2241, -7547, 1372);
	level.iz_route[level.iz_route.size] = (-2761, -7258, 1423);
	level.iz_route[level.iz_route.size] = (-4210, -7120, 1307);
	level.iz_route[level.iz_route.size] = (-5887, -7123, 1490);
	level.iz_route[level.iz_route.size] = (-6395, -7171, 2069);
	level.iz_route[level.iz_route.size] = (-8361, -7144, 2259);
	level.iz_route[level.iz_route.size] = (-10518, -7197, 1959);
	level.iz_route[level.iz_route.size] = (-12153, -7190, 1999);
	level.iz_route[level.iz_route.size] = (-13065, -6940, 2019);
	level.iz_route[level.iz_route.size] = (-13657, -6319, 2060);
	level.iz_route[level.iz_route.size] = (-13760, -4359, 2439);
	level.iz_route[level.iz_route.size] = (-13786, -1796, 2389);
	level.iz_route[level.iz_route.size] = (-13790, 1603, 2232);
	level.iz_route[level.iz_route.size] = (-13666, 3866, 2328);
	level.iz_route[level.iz_route.size] = (-13219, 4619, 2329);
	level.iz_route[level.iz_route.size] = (-12463, 4892, 2329);
	level.iz_route[level.iz_route.size] = (-11357, 4360, 2316);
	level.iz_route[level.iz_route.size] = (-10495, 3875, 2275);
	level.iz_route[level.iz_route.size] = (-9261, 3621, 2231);
	level.iz_route[level.iz_route.size] = (-8265, 3902, 2259);
	level.iz_route[level.iz_route.size] = (-7085, 4986, 2282);
	level.iz_route[level.iz_route.size] = (-6445, 5340, 2253);
	level.iz_route[level.iz_route.size] = (-5620, 5310, 2197);
	level.iz_route[level.iz_route.size] = (-5145, 4936, 2163);
	level.iz_route[level.iz_route.size] = (-4484, 3928, 2135);
	level.iz_route[level.iz_route.size] = (-3554, 2062, 2093);
	level.iz_route[level.iz_route.size] = (-2493, 786, 1986);
	level.iz_route[level.iz_route.size] = (-1616, 101, 2223);
	level.iz_route[level.iz_route.size] = (33, -1644, 1961);
	level.iz_route[level.iz_route.size] = (1388, -3076, 1838);
	level.iz_route[level.iz_route.size] = (1971, -3729, 1860);
	level.iz_route[level.iz_route.size] = (2405, -4524, 1901);
	level.iz_route[level.iz_route.size] = (2338, -5308, 1939);
	level.iz_route[level.iz_route.size] = (1810, -5847, 1954);
	level.iz_route[level.iz_route.size] = (1006, -6214, 1922);
	level.iz_route[level.iz_route.size] = (70, -5736, 1883);
	level.iz_route[level.iz_route.size] = (-956, -5096, 1866);
	level.iz_route[level.iz_route.size] = (-2714, -4760, 1864);
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
	points[0] = (-5734.5674, -10758.9375, 1554.8977);
	angles[0] = (0, 54.8687, 4.0521);
	at[0] = 0;
	points[1] = (-5764.3701, -10736.3789, 1557.2993);
	angles[1] = (0, 50.8364, 3.2750);
	at[1] = 0.7000;
	points[2] = (-5789.0156, -10709.8428, 1558.5157);
	angles[2] = (0, 38.0652, 1.1879);
	at[2] = 1.4000;
	points[3] = (-5829.1733, -10647.0469, 1558.7087);
	angles[3] = (0, 29.5770, -0.5821);
	at[3] = 2.8000;
	points[4] = (-5862.6377, -10580.5908, 1556.5472);
	angles[4] = (0, 24.0956, -2.8691);
	at[4] = 4.2000;
	points[5] = (-5882.0864, -10529.5283, 1552.1851);
	angles[5] = (0, 19.2670, -5.3193);
	at[5] = 5.2500;
	points[6] = (-5922.6772, -10405.5908, 1539.0354);
	angles[6] = (0, 17.3985, -6);
	at[6] = 7.7000;
	points[7] = (-5959.3311, -10281.2607, 1524.8583);
	angles[7] = (0, 15.1789, -6.5264);
	at[7] = 10.1500;
	points[8] = (-5972.3232, -10226.9688, 1518.1182);
	angles[8] = (0, 10.8950, -7.3801);
	at[8] = 11.2000;
	points[9] = (-5978.0312, -10172.7168, 1509.8544);
	angles[9] = (0, 3.8604, -9.1607);
	at[9] = 12.2500;
	points[10] = (-5981.1421, -10081.0244, 1494.4646);
	angles[10] = (0, 0.7628, -9.6870);
	at[10] = 14;
	points[11] = (-5980.5903, -9988.8975, 1478.7638);
	angles[11] = (0, -1.3710, -9.5673);
	at[11] = 15.7500;
	points[12] = (-5976.6143, -9916.4961, 1467.1733);
	angles[12] = (0, -5.9346, -8.1431);
	at[12] = 17.1500;
	points[13] = (-5953.5825, -9788.8975, 1450.8386);
	angles[13] = (0, -11.8020, -6.8586);
	at[13] = 19.6000;
	points[14] = (-5919.5278, -9644.1338, 1433.5355);
	angles[14] = (0, -15.2727, -6.3689);
	at[14] = 22.4000;
	points[15] = (-5914.3306, -9626.4180, 1431.5118);
	angles[15] = (0, -16.8657, -6.1817);
	at[15] = 22.7500;
	points[16] = (-5900.0391, -9593.3857, 1428.2441);
	angles[16] = (0, -28.6658, -4.2406);
	at[16] = 23.4500;
	points[17] = (-5855.9844, -9533.4258, 1424.3818);
	angles[17] = (0, -40.9492, -2.3574);
	at[17] = 24.8500;
	points[18] = (-5815.9844, -9494.2910, 1422.1497);
	angles[18] = (0, -50.8716, -2.5128);
	at[18] = 25.9000;
	points[19] = (-5800.8271, -9484.5273, 1421.2875);
	angles[19] = (0, -59.8601, -2.6770);
	at[19] = 26.2500;
	points[20] = (-5784.2915, -9476.1025, 1420.4528);
	angles[20] = (0, -63.8977, -2.5484);
	at[20] = 26.6000;
	points[21] = (-5715.4727, -9447.4404, 1417.2205);
	angles[21] = (0, -69.5237, -2.4742);
	at[21] = 28;
	points[22] = (-5644.5278, -9425.5508, 1413.8779);
	angles[22] = (0, -77.7130, -2.7756);
	at[22] = 29.4000;
	points[23] = (-5607.9131, -9420.4727, 1411.9607);
	angles[23] = (0, -83.5376, -3.0200);
	at[23] = 30.1000;
	points[24] = (-5440.5903, -9407.6777, 1403.1299);
	angles[24] = (0, -86.7487, -2.9141);
	at[24] = 33.2500;
	points[25] = (-5217.8740, -9401.1807, 1395.8701);
	angles[25] = (0, -91.2758, -1.4925);
	at[25] = 37.4500;
	points[26] = (-5161.9297, -9405.4326, 1394.2480);
	angles[26] = (0, -97.8695, -1.8580);
	at[26] = 38.5000;
	points[27] = (-5143.7007, -9409.1729, 1393.5709);
	angles[27] = (0, -103.7283, -2.2042);
	at[27] = 38.8500;
	points[28] = (-5127.7168, -9415.6299, 1392.7639);
	angles[28] = (0, -116.7860, -2.9262);
	at[28] = 39.2000;
	points[29] = (-5112.0469, -9425.9844, 1391.7008);
	angles[29] = (0, -125.3745, -3.3352);
	at[29] = 39.5500;
	points[30] = (-5097.0474, -9437.7168, 1390.5551);
	angles[30] = (0, -128.9722, -3.4725);
	at[30] = 39.9000;
	points[31] = (-5029.1338, -9501.1025, 1384.7599);
	angles[31] = (0, -135.2704, -3.5827);
	at[31] = 41.6500;
	points[32] = (-4953.7007, -9583.9375, 1377.9567);
	angles[32] = (0, -140.3071, -3.2602);
	at[32] = 43.7500;
	points[33] = (-4932.2441, -9612.6777, 1376.1378);
	angles[33] = (0, -146.8535, -2.5180);
	at[33] = 44.4500;
	points[34] = (-4914.1733, -9645.7090, 1374.6654);
	angles[34] = (0, -153.1891, -2.1113);
	at[34] = 45.1500;
	points[35] = (-4876.2993, -9730.7881, 1371.6654);
	angles[35] = (0, -157.7665, -1.6327);
	at[35] = 46.9000;
	points[36] = (-4843.8188, -9818.3467, 1369.5865);
	angles[36] = (0, -161.6584, -0.8153);
	at[36] = 48.6500;
	points[37] = (-4833.8188, -9852.7559, 1369.4331);
	angles[37] = (0, -165.9650, 0.3096);
	at[37] = 49.3500;
	points[38] = (-4801.6929, -10036.9297, 1373.2166);
	angles[38] = (0, -171.8481, 1.5563);
	at[38] = 52.8500;
	points[39] = (-4788.6221, -10148.3467, 1377.0118);
	angles[39] = (0, -175.3550, 2.4907);
	at[39] = 54.9500;
	points[40] = (-4787.3228, -10184.2520, 1379.0236);
	angles[40] = (0, -180.9644, 4.0386);
	at[40] = 55.6500;
	points[41] = (-4795.3545, -10258.2676, 1386.3781);
	angles[41] = (0, -188.5074, 6.2945);
	at[41] = 57.0500;
	points[42] = (-4812.1650, -10349.1729, 1397.2480);
	angles[42] = (0, -192.0766, 6.9706);
	at[42] = 58.8000;
	points[43] = (-4835.4727, -10438.7412, 1408.9449);
	angles[43] = (0, -197.7457, 7.3944);
	at[43] = 60.5500;
	points[44] = (-4848.5825, -10471.6543, 1413.6219);
	angles[44] = (0, -205.5684, 7.6504);
	at[44] = 61.2500;
	points[45] = (-4876.0630, -10520.2363, 1421.3149);
	angles[45] = (0, -211.1020, 7.9204);
	at[45] = 62.3000;
	points[46] = (-4936.2993, -10613.5439, 1436.9055);
	angles[46] = (0, -214.0489, 8.0305);
	at[46] = 64.4000;
	points[47] = (-5000.5513, -10703.9375, 1452.6300);
	angles[47] = (0, -216.9093, 8.1065);
	at[47] = 66.5000;
	points[48] = (-5035.5908, -10747.1260, 1460.5906);
	angles[48] = (0, -222.0792, 8.1821);
	at[48] = 67.5500;
	points[49] = (-5061.8115, -10771.1025, 1465.6417);
	angles[49] = (0, -230.1859, 8.0014);
	at[49] = 68.2500;
	points[50] = (-5136.9688, -10825.0791, 1478.4802);
	angles[50] = (0, -237.0032, 7.8614);
	at[50] = 70;
	points[51] = (-5200.6299, -10862.5586, 1488.7205);
	angles[51] = (0, -241.9641, 7.9297);
	at[51] = 71.4000;
	points[52] = (-5251.6143, -10884.9209, 1496.5787);
	angles[52] = (0, -251.6620, 8.1296);
	at[52] = 72.4500;
	points[53] = (-5286.8110, -10889.8037, 1501.6378);
	angles[53] = (0, -267.4075, 7.9688);
	at[53] = 73.1500;
	points[54] = (-5305.7485, -10889.9609, 1504.2598);
	angles[54] = (0, -270.2047, 7.8612);
	at[54] = 73.5000;
	points[55] = (-5434.5669, -10880.2363, 1521.6182);
	angles[55] = (0, -276.6824, 7.4983);
	at[55] = 75.9500;
	points[56] = (-5544.2915, -10862.7559, 1535.8308);
	angles[56] = (0, -282.4176, 6.9440);
	at[56] = 78.0500;
	points[57] = (-5578.6226, -10851.4961, 1539.8229);
	angles[57] = (0, -292.8018, 5.7694);
	at[57] = 78.7500;
	points[58] = (-5611.6929, -10835.2363, 1543.2836);
	angles[58] = (0, -297.7525, 5.1699);
	at[58] = 79.4500;
	points[59] = (-5676.1025, -10797.7168, 1549.5867);
	angles[59] = (0, -301.8406, 4.6039);
	at[59] = 80.8500;
	points[60] = (-5734.5674, -10758.9375, 1554.8977);
	angles[60] = (0, -305.1313, 4.0521);
	at[60] = 82.1667;
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
	points[0] = (-2320.0906, -10004.4492, 1435.0709);
	angles[0] = (0, -137.3347, 6.4844);
	at[0] = 0;
	points[1] = (-2283.8623, -10049.3701, 1441.4292);
	angles[1] = (0, -146.0785, 5.8866);
	at[1] = 1.1000;
	points[2] = (-2266.6536, -10083.1895, 1444.9961);
	angles[2] = (0, -155.8976, 5.1654);
	at[2] = 1.8333;
	points[3] = (-2232, -10174.6064, 1453.5118);
	angles[3] = (0, -160.9660, 4.9225);
	at[3] = 3.6667;
	points[4] = (-2190.8032, -10304.7637, 1465.5630);
	angles[4] = (0, -163.6140, 5.2840);
	at[4] = 6.2333;
	points[5] = (-2170.6812, -10378.5430, 1473.4370);
	angles[5] = (0, -166.3791, 6.9796);
	at[5] = 7.7000;
	points[6] = (-2154.9487, -10454.2119, 1484.5000);
	angles[6] = (0, -169.1857, 8.5851);
	at[6] = 9.1667;
	points[7] = (-2135.5393, -10568.6611, 1502.5276);
	angles[7] = (0, -171.5158, 8.9386);
	at[7] = 11.3667;
	points[8] = (-2124.3740, -10664.7646, 1517.6891);
	angles[8] = (0, -175.8271, 8.7787);
	at[8] = 13.2000;
	points[9] = (-2123.8071, -10703.2285, 1523.4331);
	angles[9] = (0, -183.0164, 8.1173);
	at[9] = 13.9333;
	points[10] = (-2126.5669, -10721.2207, 1525.8820);
	angles[10] = (0, -190.8660, 7.5218);
	at[10] = 14.3000;
	points[11] = (-2150.1851, -10795.1191, 1535.4054);
	angles[11] = (0, -200.9438, 6.6715);
	at[11] = 15.7667;
	points[12] = (-2206.7639, -10918.9766, 1549.8781);
	angles[12] = (0, -207.8357, 5.3248);
	at[12] = 18.3333;
	points[13] = (-2226.1221, -10952.8350, 1553.1221);
	angles[13] = (0, -211.5141, 4.2120);
	at[13] = 19.0667;
	points[14] = (-2248.8936, -10983.5830, 1554.8425);
	angles[14] = (0, -219.7039, 1.5411);
	at[14] = 19.8000;
	points[15] = (-2301.6260, -11040.7080, 1555.7125);
	angles[15] = (0, -224.3042, 0.1962);
	at[15] = 21.2667;
	points[16] = (-2371.9646, -11108.5820, 1555.3505);
	angles[16] = (0, -227.5316, -0.5429);
	at[16] = 23.1000;
	points[17] = (-2431.6812, -11159.4102, 1554.0670);
	angles[17] = (0, -231.9707, -1.3658);
	at[17] = 24.5667;
	points[18] = (-2463.8977, -11181.7324, 1552.7480);
	angles[18] = (0, -238.7996, -2.5119);
	at[18] = 25.3000;
	points[19] = (-2498.1064, -11197.0078, 1550.2480);
	angles[19] = (0, -249.0114, -4.4165);
	at[19] = 26.0333;
	points[20] = (-2591.4133, -11225.8262, 1541.5472);
	angles[20] = (0, -255.0707, -5.4369);
	at[20] = 27.8667;
	points[21] = (-2666.9607, -11243.6611, 1533.8859);
	angles[21] = (0, -258.1494, -5.7907);
	at[21] = 29.3333;
	points[22] = (-2743.4019, -11256.6143, 1525.7637);
	angles[22] = (0, -262.7485, -6.1522);
	at[22] = 30.8000;
	points[23] = (-2782.5947, -11259.7637, 1521.4135);
	angles[23] = (0, -267.8599, -6.4387);
	at[23] = 31.5333;
	points[24] = (-2819.3977, -11256.9688, 1517.0631);
	angles[24] = (0, -278.7832, -6.9142);
	at[24] = 32.2667;
	points[25] = (-2951.4607, -11223.3467, 1500.0354);
	angles[25] = (0, -286.7481, -7.1862);
	at[25] = 34.8333;
	points[26] = (-3043.6497, -11193.3467, 1487.7756);
	angles[26] = (0, -289.1217, -7.2174);
	at[26] = 36.6667;
	points[27] = (-3134.5081, -11159.0156, 1475.4685);
	angles[27] = (0, -292.4403, -7.2179);
	at[27] = 38.5000;
	points[28] = (-3187.5156, -11134.4883, 1468.0945);
	angles[28] = (0, -297.5217, -7.1537);
	at[28] = 39.6000;
	points[29] = (-3218, -11114.2520, 1463.6143);
	angles[29] = (0, -308.7116, -6.7590);
	at[29] = 40.3333;
	points[30] = (-3246.6733, -11087.5986, 1459.1339);
	angles[30] = (0, -314.9232, -6.4076);
	at[30] = 41.0667;
	points[31] = (-3311.6655, -11014.9609, 1448.5159);
	angles[31] = (0, -320.1205, -6.1074);
	at[31] = 42.9000;
	points[32] = (-3371.7876, -10938.9766, 1438.2521);
	angles[32] = (0, -322.9002, -6.0043);
	at[32] = 44.7333;
	points[33] = (-3428.4055, -10859.2529, 1427.9883);
	angles[33] = (0, -326.5370, -6.0070);
	at[33] = 46.5667;
	points[34] = (-3448.7009, -10825.9453, 1423.8503);
	angles[34] = (0, -330.8905, -6.1055);
	at[34] = 47.3000;
	points[35] = (-3456.1377, -10809.9209, 1421.9331);
	angles[35] = (0, -337.5400, -6.2218);
	at[35] = 47.6667;
	points[36] = (-3466.9175, -10772.2441, 1417.6654);
	angles[36] = (0, -347.1212, -6.1708);
	at[36] = 48.4000;
	points[37] = (-3473.8030, -10734.2119, 1413.5394);
	angles[37] = (0, -351.1875, -6.0308);
	at[37] = 49.1333;
	points[38] = (-3483.8464, -10637.4014, 1403.6653);
	angles[38] = (0, -355.9354, -5.5408);
	at[38] = 50.9667;
	points[39] = (-3488.5237, -10521.5361, 1394.3188);
	angles[39] = (0, -359.2912, -3.0179);
	at[39] = 53.1667;
	points[40] = (-3486.0945, -10365.3945, 1388.0709);
	angles[40] = (0, -362.3455, -1.9382);
	at[40] = 56.1000;
	points[41] = (-3476.7244, -10248.5049, 1384.7007);
	angles[41] = (0, -367.7451, -1.2838);
	at[41] = 58.3000;
	points[42] = (-3469, -10209.8037, 1384.0708);
	angles[42] = (0, -375.0847, -0.5266);
	at[42] = 59.0333;
	points[43] = (-3453.4448, -10175.7871, 1384.4882);
	angles[43] = (0, -389.1225, 1.2797);
	at[43] = 59.7667;
	points[44] = (-3421.3582, -10126.4570, 1386.3346);
	angles[44] = (0, -395.1530, 2.0530);
	at[44] = 60.8667;
	points[45] = (-3373.9844, -10064.4482, 1389.4094);
	angles[45] = (0, -399.0329, 2.3747);
	at[45] = 62.3333;
	points[46] = (-3295.1653, -9977.5195, 1394.4133);
	angles[46] = (0, -405.9539, 2.4148);
	at[46] = 64.5333;
	points[47] = (-3265.6890, -9952.3232, 1395.9646);
	angles[47] = (0, -413.1168, 2.1371);
	at[47] = 65.2667;
	points[48] = (-3233.0828, -9933.4258, 1397.2755);
	angles[48] = (0, -422.8344, 1.9660);
	at[48] = 66;
	points[49] = (-3143.3860, -9894.1338, 1400.5513);
	angles[49] = (0, -428.2884, 1.8767);
	at[49] = 67.8333;
	points[50] = (-3033.0195, -9854.1338, 1404.2755);
	angles[50] = (0, -431.6301, 1.7548);
	at[50] = 70.0333;
	points[51] = (-2939.4097, -9826.9297, 1407.0709);
	angles[51] = (0, -436.5399, 1.4805);
	at[51] = 71.8667;
	points[52] = (-2882.3032, -9819.0557, 1408.1143);
	angles[52] = (0, -447.2281, 0.5087);
	at[52] = 72.9667;
	points[53] = (-2804.2993, -9819.4883, 1408.3583);
	angles[53] = (0, -451.9196, 0.0496);
	at[53] = 74.4333;
	points[54] = (-2687.2400, -9826.8115, 1408.4016);
	angles[54] = (0, -454.8798, 0.0573);
	at[54] = 76.6333;
	points[55] = (-2570.8425, -9840.3154, 1408.9331);
	angles[55] = (0, -458.6883, 0.5744);
	at[55] = 78.8333;
	points[56] = (-2512.9133, -9852.2832, 1410.1260);
	angles[56] = (0, -465.8344, 2.0025);
	at[56] = 79.9333;
	points[57] = (-2479.3818, -9867.7949, 1412.5591);
	angles[57] = (0, -479.8139, 4.6695);
	at[57] = 80.6667;
	points[58] = (-2431.4292, -9901.2207, 1418.1693);
	angles[58] = (0, -487.6984, 5.8915);
	at[58] = 81.7667;
	points[59] = (-2372.4409, -9951.8506, 1426.6417);
	angles[59] = (0, -492.7600, 6.4028);
	at[59] = 83.2333;
	points[60] = (-2320.0906, -10004.4492, 1435.0709);
	angles[60] = (0, -497.3347, 6.4844);
	at[60] = 84.6333;
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
