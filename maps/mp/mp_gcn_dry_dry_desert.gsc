main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_dry_dry_desert", 0);

	setExpFog(3207.9502, 17314.0703, 1, 0.9294, 0.4941, 0);

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
	ambientPlay("iz_0_59", 2);
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
	level.iz_route[level.iz_route.size] = (8995, -2852, 1920);
	level.iz_route[level.iz_route.size] = (8995, -4424, 1929);
	level.iz_route[level.iz_route.size] = (8984, -5963, 1927);
	level.iz_route[level.iz_route.size] = (8922, -7427, 1923);
	level.iz_route[level.iz_route.size] = (8439, -8917, 1901);
	level.iz_route[level.iz_route.size] = (7434, -9736, 1908);
	level.iz_route[level.iz_route.size] = (6412, -10153, 1929);
	level.iz_route[level.iz_route.size] = (5275, -10100, 1888);
	level.iz_route[level.iz_route.size] = (4202, -9600, 1749);
	level.iz_route[level.iz_route.size] = (3460, -8769, 1643);
	level.iz_route[level.iz_route.size] = (2834, -8311, 1610);
	level.iz_route[level.iz_route.size] = (2115, -8394, 1556);
	level.iz_route[level.iz_route.size] = (1603, -8922, 1509);
	level.iz_route[level.iz_route.size] = (985, -9400, 1468);
	level.iz_route[level.iz_route.size] = (342, -9520, 1457);
	level.iz_route[level.iz_route.size] = (-331, -9217, 1469);
	level.iz_route[level.iz_route.size] = (-787, -8467, 1511);
	level.iz_route[level.iz_route.size] = (-1290, -8206, 1561);
	level.iz_route[level.iz_route.size] = (-1923, -8266, 1614);
	level.iz_route[level.iz_route.size] = (-2552, -8802, 1653);
	level.iz_route[level.iz_route.size] = (-3175, -9474, 1697);
	level.iz_route[level.iz_route.size] = (-3890, -10026, 1773);
	level.iz_route[level.iz_route.size] = (-4483, -10125, 1841);
	level.iz_route[level.iz_route.size] = (-5195, -10020, 1931);
	level.iz_route[level.iz_route.size] = (-5866, -9614, 2006);
	level.iz_route[level.iz_route.size] = (-6452, -8739, 2070);
	level.iz_route[level.iz_route.size] = (-6621, -6615, 1990);
	level.iz_route[level.iz_route.size] = (-7282, -4915, 1825);
	level.iz_route[level.iz_route.size] = (-8384, -3766, 1782);
	level.iz_route[level.iz_route.size] = (-8496, -1937, 1779);
	level.iz_route[level.iz_route.size] = (-7535, -752, 1784);
	level.iz_route[level.iz_route.size] = (-6464, 560, 1805);
	level.iz_route[level.iz_route.size] = (-6132, 2644, 1918);
	level.iz_route[level.iz_route.size] = (-5464, 4419, 2053);
	level.iz_route[level.iz_route.size] = (-4218, 5855, 2070);
	level.iz_route[level.iz_route.size] = (-2733, 6400, 1791);
	level.iz_route[level.iz_route.size] = (-1148, 6448, 1418);
	level.iz_route[level.iz_route.size] = (4039, 6085, 1562);
	level.iz_route[level.iz_route.size] = (6834, 5838, 1536);
	level.iz_route[level.iz_route.size] = (8391, 5394, 1780);
	level.iz_route[level.iz_route.size] = (9245, 4468, 2001);
	level.iz_route[level.iz_route.size] = (9219, 3025, 2004);
	level.iz_route[level.iz_route.size] = (8521, 1594, 1916);
	level.iz_route[level.iz_route.size] = (8435, 748, 1888);
	level.iz_route[level.iz_route.size] = (8641, -55, 1885);
	level.iz_route[level.iz_route.size] = (8920, -1404, 1920);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5713.8975, 1568.7323, 1858.6693);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5259.5669, -233.5264, 1781.8898);
	angles[1] = (0, 0, 0);
	at[1] = 3.5000;
	points[2] = (-5183.2676, -486.4646, 1772.8110);
	angles[2] = (0, 0, 0);
	at[2] = 4;
	points[3] = (-4263.0708, -2103.1536, 1773.5511);
	angles[3] = (0, 0, 0);
	at[3] = 7.5000;
	points[4] = (-4232.5986, -2355.3779, 1776.1023);
	angles[4] = (0, 0, 0);
	at[4] = 8;
	points[5] = (-4394.8818, -3941.4172, 1799.7755);
	angles[5] = (0, 0, 0);
	at[5] = 11;
	points[6] = (-4566.3389, -4142.9136, 1811.0591);
	angles[6] = (0, 0, 0);
	at[6] = 11.5000;
	points[7] = (-5612.1650, -5344.5669, 1879.6299);
	angles[7] = (0, 0, 0);
	at[7] = 14.5000;
	points[8] = (-5773.1099, -5551.1416, 1891.7559);
	angles[8] = (0, 0, 0);
	at[8] = 15;
	points[9] = (-6092.0864, -7379.4092, 2018.8544);
	angles[9] = (0, 0, 0);
	at[9] = 18.5000;
	points[10] = (-6054.1338, -7636.0630, 2014.3779);
	angles[10] = (0, 0, 0);
	at[10] = 19;
	points[11] = (-5680.9453, -8909.2920, 1942.2834);
	angles[11] = (0, 0, 0);
	at[11] = 21.5000;
	points[12] = (-5596.6147, -9156.2598, 1927.0709);
	angles[12] = (0, 0, 0);
	at[12] = 22;
	points[13] = (-4685, -9692.2842, 1819.1339);
	angles[13] = (0, 0, 0);
	at[13] = 24;
	points[14] = (-4436.1416, -9655.6299, 1793.4253);
	angles[14] = (0, 0, 0);
	at[14] = 24.5000;
	points[15] = (-3675.2756, -9430.0791, 1717.1771);
	angles[15] = (0, 0, 0);
	at[15] = 26;
	points[16] = (-3490.3782, -9251.6934, 1711.4685);
	angles[16] = (0, 0, 0);
	at[16] = 26.5000;
	points[17] = (-2336.1221, -7792.8740, 1711.6615);
	angles[17] = (0, 0, 0);
	at[17] = 30;
	points[18] = (-2145.6497, -7619.3701, 1705.9685);
	angles[18] = (0, 0, 0);
	at[18] = 30.5000;
	points[19] = (-1651.7363, -7426.4961, 1669.3110);
	angles[19] = (0, 0, 0);
	at[19] = 31.5000;
	points[20] = (-1405.0867, -7350.4722, 1649.7638);
	angles[20] = (0, 0, 0);
	at[20] = 32;
	points[21] = (-917.1693, -7552.4800, 1589.5315);
	angles[21] = (0, 0, 0);
	at[21] = 33;
	points[22] = (-724.6181, -7713.0312, 1561.9685);
	angles[22] = (0, 0, 0);
	at[22] = 33.5000;
	points[23] = (-321.1846, -8396.6533, 1487.9292);
	angles[23] = (0, 0, 0);
	at[23] = 35;
	points[24] = (-163.3638, -8603.7012, 1468.9174);
	angles[24] = (0, 0, 0);
	at[24] = 35.5000;
	points[25] = (267.5650, -8914.6465, 1458.8938);
	angles[25] = (0, 0, 0);
	at[25] = 36.5000;
	points[26] = (485.2441, -8974.5664, 1459.8307);
	angles[26] = (0, 0, 0);
	at[26] = 37;
	points[27] = (930.0827, -8684.9609, 1487.2087);
	angles[27] = (0, 0, 0);
	at[27] = 38;
	points[28] = (1116.6812, -8504.0156, 1514.3623);
	angles[28] = (0, 0, 0);
	at[28] = 38.5000;
	points[29] = (1586.6732, -7870.4331, 1629.5748);
	angles[29] = (0, 0, 0);
	at[29] = 40;
	points[30] = (1831.0120, -7772.7559, 1657.1102);
	angles[30] = (0, 0, 0);
	at[30] = 40.5000;
	points[31] = (2324.9370, -7584.1338, 1711.5315);
	angles[31] = (0, 0, 0);
	at[31] = 41.5000;
	points[32] = (2570.3191, -7571.0630, 1727.8661);
	angles[32] = (0, 0, 0);
	at[32] = 42;
	points[33] = (3299.4172, -7893.5825, 1728.4371);
	angles[33] = (0, 0, 0);
	at[33] = 43.5000;
	points[34] = (3533.6064, -8012.7163, 1728.9174);
	angles[34] = (0, 0, 0);
	at[34] = 44;
	points[35] = (4544.7241, -9245.5117, 1744.6930);
	angles[35] = (0, 0, 0);
	at[35] = 47;
	points[36] = (4793.7798, -9320.6299, 1756.4607);
	angles[36] = (0, 0, 0);
	at[36] = 47.5000;
	points[37] = (6345.7485, -9678.1494, 1833.5787);
	angles[37] = (0, 0, 0);
	at[37] = 50.5000;
	points[38] = (6596.6929, -9632.4014, 1843.0237);
	angles[38] = (0, 0, 0);
	at[38] = 51;
	points[39] = (8326.7715, -8950.9844, 1897.4645);
	angles[39] = (0, 0, 0);
	at[39] = 54.5000;
	points[40] = (8507.1260, -8760.8662, 1899.7993);
	angles[40] = (0, 0, 0);
	at[40] = 55;
	points[41] = (9699.6064, -7333.1890, 1910.4409);
	angles[41] = (0, 0, 0);
	at[41] = 58.5000;
	points[42] = (9875.9844, -7134.5669, 1915.7874);
	angles[42] = (0, 0, 0);
	at[42] = 59;
	points[43] = (11307.5986, -5563.8584, 1971.7166);
	angles[43] = (0, 0, 0);
	at[43] = 63;
	points[44] = (11315.1182, -5299.3701, 1976.5198);
	angles[44] = (0, 0, 0);
	at[44] = 63.5000;
	points[45] = (11355.6309, -2908.3660, 2019.4174);
	angles[45] = (0, 0, 0);
	at[45] = 68;
	points[46] = (11220.7090, -2683.0549, 2004.3307);
	angles[46] = (0, 0, 0);
	at[46] = 68.5000;
	points[47] = (10499.7246, -1569.9606, 1922.2913);
	angles[47] = (0, 0, 0);
	at[47] = 71;
	points[48] = (10433.5430, -1321.2087, 1911.4843);
	angles[48] = (0, 0, 0);
	at[48] = 71.5000;
	points[49] = (10363.5439, -260.9232, 1882.2520);
	angles[49] = (0, 0, 0);
	at[49] = 73.5000;
	points[50] = (10260.0781, -23.5651, 1883.9016);
	angles[50] = (0, 0, 0);
	at[50] = 74;
	points[51] = (9556.1025, 1103.0315, 1911.6143);
	angles[51] = (0, 0, 0);
	at[51] = 76.5000;
	points[52] = (9442.5986, 1342.2323, 1919.8347);
	angles[52] = (0, 0, 0);
	at[52] = 77;
	points[53] = (8839.1729, 2817.0435, 1976.7795);
	angles[53] = (0, 0, 0);
	at[53] = 80;
	points[54] = (8759.9209, 3067.8899, 1980.7284);
	angles[54] = (0, 0, 0);
	at[54] = 80.5000;
	points[55] = (8676.6934, 4126.6538, 1935.6890);
	angles[55] = (0, 0, 0);
	at[55] = 82.5000;
	points[56] = (8592.8740, 4348.3462, 1911.4095);
	angles[56] = (0, 0, 0);
	at[56] = 83;
	points[57] = (7674.4092, 4837.2832, 1693.8268);
	angles[57] = (0, 0, 0);
	at[57] = 85;
	points[58] = (7432.9922, 4738.1890, 1658.5867);
	angles[58] = (0, 0, 0);
	at[58] = 85.5000;
	points[59] = (6465.9839, 4319.1733, 1519.5906);
	angles[59] = (0, 0, 0);
	at[59] = 87.5000;
	points[60] = (6207.9922, 4302.0083, 1504.5433);
	angles[60] = (0, 0, 0);
	at[60] = 88;
	points[61] = (4883.5039, 4402.6382, 1471.2047);
	angles[61] = (0, 0, 0);
	at[61] = 90.5000;
	points[62] = (4640.1182, 4493.3462, 1486.1615);
	angles[62] = (0, 0, 0);
	at[62] = 91;
	points[63] = (3709.4136, 4996.4961, 1589.0039);
	angles[63] = (0, 0, 0);
	at[63] = 93;
	points[64] = (3509.1182, 5157.5591, 1601.3031);
	angles[64] = (0, 0, 0);
	at[64] = 93.5000;
	points[65] = (2654.4253, 6501.8110, 1531.2992);
	angles[65] = (0, 0, 0);
	at[65] = 96.5000;
	points[66] = (2493.6614, 6693.1494, 1521.3307);
	angles[66] = (0, 0, 0);
	at[66] = 97;
	points[67] = (1165.0709, 6712.9131, 1520.2323);
	angles[67] = (0, 0, 0);
	at[67] = 99.5000;
	points[68] = (903.8741, 6702.0083, 1518.5709);
	angles[68] = (0, 0, 0);
	at[68] = 100;
	points[69] = (-629.0236, 5653.4253, 1412.9449);
	angles[69] = (0, 0, 0);
	at[69] = 103.5000;
	points[70] = (-858.5511, 5549.5273, 1415.9882);
	angles[70] = (0, 0, 0);
	at[70] = 104;
	points[71] = (-2412.9253, 5697.9136, 1738.9646);
	angles[71] = (0, 0, 0);
	at[71] = 107;
	points[72] = (-2671.9172, 5719.8032, 1792.5157);
	angles[72] = (0, 0, 0);
	at[72] = 107.5000;
	points[73] = (-3958.2285, 5482.8740, 2026.6536);
	angles[73] = (0, 0, 0);
	at[73] = 110;
	points[74] = (-4188.7402, 5390.3936, 2059.0393);
	angles[74] = (0, 0, 0);
	at[74] = 110.5000;
	points[75] = (-5304.6064, 3902.5747, 2016.7206);
	angles[75] = (0, 0, 0);
	at[75] = 114;
	points[76] = (-5404.9604, 3665.6379, 2004.6614);
	angles[76] = (0, 0, 0);
	at[76] = 114.5000;
	points[77] = (-5678.8193, 1830.1378, 1876.6378);
	angles[77] = (0, 0, 0);
	at[77] = 118;
	points[78] = (-5713.8975, 1568.7323, 1858.6693);
	angles[78] = (0, 0, 0);
	at[78] = 118.5000;
	mover = getEnt("iz_obj_0", "targetname");
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
