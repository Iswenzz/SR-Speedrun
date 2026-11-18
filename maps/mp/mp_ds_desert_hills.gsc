main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_desert_hills", 0);

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
	ambientPlay("iz_0_r_ds_desert32", 2);
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
	level.iz_route[level.iz_route.size] = (4577, -3331, 1724);
	level.iz_route[level.iz_route.size] = (4577, -4924, 1700);
	level.iz_route[level.iz_route.size] = (4577, -6736, 1673);
	level.iz_route[level.iz_route.size] = (4577, -8329, 1679);
	level.iz_route[level.iz_route.size] = (4564, -9730, 1734);
	level.iz_route[level.iz_route.size] = (4226, -10784, 1754);
	level.iz_route[level.iz_route.size] = (3604, -11784, 1763);
	level.iz_route[level.iz_route.size] = (2451, -12456, 1716);
	level.iz_route[level.iz_route.size] = (1083, -12237, 1674);
	level.iz_route[level.iz_route.size] = (114, -11529, 1632);
	level.iz_route[level.iz_route.size] = (-518, -10736, 1591);
	level.iz_route[level.iz_route.size] = (-805, -9663, 1569);
	level.iz_route[level.iz_route.size] = (-891, -8822, 1551);
	level.iz_route[level.iz_route.size] = (-1145, -7630, 1523);
	level.iz_route[level.iz_route.size] = (-1872, -6838, 1518);
	level.iz_route[level.iz_route.size] = (-3190, -6595, 1512);
	level.iz_route[level.iz_route.size] = (-4345, -6961, 1500);
	level.iz_route[level.iz_route.size] = (-5386, -7175, 1565);
	level.iz_route[level.iz_route.size] = (-6319, -6872, 1653);
	level.iz_route[level.iz_route.size] = (-7184, -6202, 1695);
	level.iz_route[level.iz_route.size] = (-7419, -4910, 1638);
	level.iz_route[level.iz_route.size] = (-7535, -3823, 1665);
	level.iz_route[level.iz_route.size] = (-7618, -2811, 1741);
	level.iz_route[level.iz_route.size] = (-7618, -1500, 2209);
	level.iz_route[level.iz_route.size] = (-7618, 260, 2008);
	level.iz_route[level.iz_route.size] = (-7618, 2465, 1869);
	level.iz_route[level.iz_route.size] = (-7618, 4469, 1677);
	level.iz_route[level.iz_route.size] = (-7333, 5583, 1664);
	level.iz_route[level.iz_route.size] = (-6846, 6509, 1693);
	level.iz_route[level.iz_route.size] = (-5803, 7141, 1787);
	level.iz_route[level.iz_route.size] = (-4655, 6999, 1821);
	level.iz_route[level.iz_route.size] = (-4350, 6423, 1817);
	level.iz_route[level.iz_route.size] = (-4054, 5785, 1822);
	level.iz_route[level.iz_route.size] = (-4085, 4881, 1802);
	level.iz_route[level.iz_route.size] = (-3782, 4055, 1847);
	level.iz_route[level.iz_route.size] = (-3075, 3477, 1834);
	level.iz_route[level.iz_route.size] = (-2259, 3401, 1791);
	level.iz_route[level.iz_route.size] = (-1623, 3772, 1711);
	level.iz_route[level.iz_route.size] = (-1212, 4046, 1650);
	level.iz_route[level.iz_route.size] = (-657, 4464, 1691);
	level.iz_route[level.iz_route.size] = (17, 4516, 1767);
	level.iz_route[level.iz_route.size] = (543, 4099, 1798);
	level.iz_route[level.iz_route.size] = (743, 3634, 1773);
	level.iz_route[level.iz_route.size] = (829, 3144, 1731);
	level.iz_route[level.iz_route.size] = (928, 2619, 1695);
	level.iz_route[level.iz_route.size] = (1205, 2199, 1687);
	level.iz_route[level.iz_route.size] = (1852, 1923, 1695);
	level.iz_route[level.iz_route.size] = (2449, 1665, 1640);
	level.iz_route[level.iz_route.size] = (2993, 1350, 1557);
	level.iz_route[level.iz_route.size] = (3853, 882, 1571);
	level.iz_route[level.iz_route.size] = (4400, 39, 1669);
	level.iz_route[level.iz_route.size] = (4577, -900, 1715);
	level.iz_route[level.iz_route.size] = (4577, -2850, 1729);
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
	points[0] = (-8006.0234, -3872.0549, 1753.3583);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-7899.0552, -3862.1458, 1711.5985);
	angles[1] = (0, -180, 0);
	at[1] = 0.6500;
	points[2] = (-7848.3467, -3855.5356, 1694.0631);
	angles[2] = (0, -180, 0);
	at[2] = 0.9500;
	points[3] = (-7381.8501, -3828.0945, 1655.3464);
	angles[3] = (0, -180, 0);
	at[3] = 3.6000;
	points[4] = (-7277.4805, -3827.7717, 1678.5000);
	angles[4] = (0, -180, 0);
	at[4] = 4.2000;
	points[5] = (-7271.7324, -3827.8152, 1679.7756);
	angles[5] = (0, -180, 0);
	at[5] = 4.2500;
	points[6] = (-7271.7324, -3827.8152, 1679.7756);
	angles[6] = (0, -180, 0);
	at[6] = 4.7000;
	points[7] = (-7277.2441, -3827.7756, 1678.5513);
	angles[7] = (0, -180, 0);
	at[7] = 4.7500;
	points[8] = (-7381.6143, -3828.0867, 1655.4016);
	angles[8] = (0, -180, 0);
	at[8] = 5.3500;
	points[9] = (-7856.5752, -3856.6064, 1695.1104);
	angles[9] = (0, -180, 0);
	at[9] = 8.0500;
	points[10] = (-8005.8271, -3872.0354, 1753.2717);
	angles[10] = (0, -180, 0);
	at[10] = 8.9500;
	points[11] = (-8011.2993, -3872.5354, 1755.4094);
	angles[11] = (0, -180, 0);
	at[11] = 9;
	points[12] = (-8011.2993, -3872.5354, 1755.4094);
	angles[12] = (0, -180, 0);
	at[12] = 9.4500;
	points[13] = (-8006.0234, -3872.0549, 1753.3583);
	angles[13] = (0, -180, 0);
	at[13] = 9.5000;
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
	points[0] = (-7715.3936, 1672.0432, 1974.2087);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-7756.1812, 1485.2913, 2001.7875);
	angles[1] = (0, -170, 0);
	at[1] = 1.0833;
	points[2] = (-7771.5747, 1413.4489, 2000.5708);
	angles[2] = (0, -170, 0);
	at[2] = 1.5000;
	points[3] = (-7864.0947, 1213.1495, 2017.0394);
	angles[3] = (0, -170, 0);
	at[3] = 2.7500;
	points[4] = (-7921.8506, 1168.7205, 2033.5511);
	angles[4] = (0, -170, 0);
	at[4] = 3.1667;
	points[5] = (-8052.8350, 1074.2362, 2042.4803);
	angles[5] = (0, -170, 0);
	at[5] = 4.0833;
	points[6] = (-8065.9849, 1069.5472, 2044.0315);
	angles[6] = (0, -170, 0);
	at[6] = 4.1667;
	points[7] = (-8211.9688, 1070.1143, 2068.9565);
	angles[7] = (0, -170, 0);
	at[7] = 5;
	points[8] = (-8284.5664, 1072.0552, 2076.6064);
	angles[8] = (0, -170, 0);
	at[8] = 5.4167;
	points[9] = (-8477.5986, 1175.4685, 2109.6023);
	angles[9] = (0, -170, 0);
	at[9] = 6.6667;
	points[10] = (-8520.9053, 1251.9961, 2124.0786);
	angles[10] = (0, -170, 0);
	at[10] = 7.1667;
	points[11] = (-8601.2207, 1391.3779, 2144.1614);
	angles[11] = (0, -170, 0);
	at[11] = 8.0833;
	points[12] = (-8613.8584, 1463.6851, 2153.9211);
	angles[12] = (0, -170, 0);
	at[12] = 8.5000;
	points[13] = (-8648.1104, 1697.3622, 2151.6340);
	angles[13] = (0, -170, 0);
	at[13] = 9.8333;
	points[14] = (-8635.1572, 1769.6339, 2152.7283);
	angles[14] = (0, -170, 0);
	at[14] = 10.2500;
	points[15] = (-8618.3076, 1856.3149, 2148.8938);
	angles[15] = (0, -170, 0);
	at[15] = 10.7500;
	points[16] = (-8584.6846, 2029.6812, 2123.9805);
	angles[16] = (0, -170, 0);
	at[16] = 11.7500;
	points[17] = (-8519.8037, 2108.8149, 2116.5000);
	angles[17] = (0, -170, 0);
	at[17] = 12.3333;
	points[18] = (-8455.3545, 2188.1299, 2097.6770);
	angles[18] = (0, -170, 0);
	at[18] = 12.9167;
	points[19] = (-8426.1025, 2219.7520, 2086.8386);
	angles[19] = (0, -170, 0);
	at[19] = 13.1667;
	points[20] = (-8303.1895, 2261.9802, 2065.4724);
	angles[20] = (0, -170, 0);
	at[20] = 13.9167;
	points[21] = (-8234.8818, 2285.4448, 2050.3149);
	angles[21] = (0, -170, 0);
	at[21] = 14.3333;
	points[22] = (-8180.2759, 2304.2126, 2032.4094);
	angles[22] = (0, -170, 0);
	at[22] = 14.6667;
	points[23] = (-8166.6147, 2305.0591, 2028.9331);
	angles[23] = (0, -170, 0);
	at[23] = 14.7500;
	points[24] = (-7934.8823, 2213.1299, 2004.1497);
	angles[24] = (0, -170, 0);
	at[24] = 16.1667;
	points[25] = (-7895.2754, 2195.2441, 1994.6654);
	angles[25] = (0, -170, 0);
	at[25] = 16.4167;
	points[26] = (-7755.7480, 2007.7677, 1960.2441);
	angles[26] = (0, -170, 0);
	at[26] = 17.7500;
	points[27] = (-7749.6460, 1994.9803, 1959.2993);
	angles[27] = (0, -170, 0);
	at[27] = 17.8333;
	points[28] = (-7730.9844, 1818.9961, 1974.8701);
	angles[28] = (0, -170, 0);
	at[28] = 18.8333;
	points[29] = (-7715.3936, 1672.0432, 1974.2087);
	angles[29] = (0, -170, 0);
	at[29] = 19.6667;
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
	points[0] = (-6600.1973, 3075.2441, 1950.7480);
	angles[0] = (0, 170, 0);
	at[0] = 0;
	points[1] = (-6605.0786, 3029.7639, 1952.2244);
	angles[1] = (0, 170, 0);
	at[1] = 0.2500;
	points[2] = (-6631.3389, 2810.4094, 1971.9686);
	angles[2] = (0, 170, 0);
	at[2] = 1.5000;
	points[3] = (-6638.3076, 2751.9172, 1973.5631);
	angles[3] = (0, 170, 0);
	at[3] = 1.8333;
	points[4] = (-6736.1421, 2642.2717, 1986.9409);
	angles[4] = (0, 170, 0);
	at[4] = 2.6667;
	points[5] = (-6805.9839, 2566.1418, 1980.1536);
	angles[5] = (0, 170, 0);
	at[5] = 3.2500;
	points[6] = (-6818.2285, 2558.9055, 1978.6694);
	angles[6] = (0, 170, 0);
	at[6] = 3.3333;
	points[7] = (-6972.2046, 2510.5315, 1959.4921);
	angles[7] = (0, 170, 0);
	at[7] = 4.2500;
	points[8] = (-7028.1895, 2492.9409, 1955.9764);
	angles[8] = (0, 170, 0);
	at[8] = 4.5833;
	points[9] = (-7070.1577, 2479.7480, 1949.2953);
	angles[9] = (0, 170, 0);
	at[9] = 4.8333;
	points[10] = (-7084.1338, 2478.4568, 1947.3229);
	angles[10] = (0, 170, 0);
	at[10] = 4.9167;
	points[11] = (-7292.2446, 2550.3621, 1923.8229);
	angles[11] = (0, 170, 0);
	at[11] = 6.1667;
	points[12] = (-7304.5278, 2557.1890, 1922.2402);
	angles[12] = (0, 170, 0);
	at[12] = 6.2500;
	points[13] = (-7431.8506, 2754.7129, 1898.1104);
	angles[13] = (0, 170, 0);
	at[13] = 7.5833;
	points[14] = (-7440.8267, 2812.8464, 1899.2992);
	angles[14] = (0, 170, 0);
	at[14] = 7.9167;
	points[15] = (-7464.3701, 2973.1301, 1881.9174);
	angles[15] = (0, 170, 0);
	at[15] = 8.8333;
	points[16] = (-7475.0791, 3045.9883, 1877.4725);
	angles[16] = (0, 170, 0);
	at[16] = 9.2500;
	points[17] = (-7474.8423, 3060.5273, 1877.3662);
	angles[17] = (0, 170, 0);
	at[17] = 9.3333;
	points[18] = (-7458.9761, 3147.5356, 1880.9292);
	angles[18] = (0, 170, 0);
	at[18] = 9.8333;
	points[19] = (-7419.2124, 3365.0671, 1860.2953);
	angles[19] = (0, 170, 0);
	at[19] = 11.0833;
	points[20] = (-7413.4648, 3378.1458, 1859.8623);
	angles[20] = (0, 170, 0);
	at[20] = 11.1667;
	points[21] = (-7320.0786, 3492.4409, 1871.5669);
	angles[21] = (0, 170, 0);
	at[21] = 12;
	points[22] = (-7264.0156, 3561.0195, 1863.7245);
	angles[22] = (0, 170, 0);
	at[22] = 12.5000;
	points[23] = (-7031.2598, 3601.8704, 1879.7678);
	angles[23] = (0, 170, 0);
	at[23] = 13.8333;
	points[24] = (-7002.2441, 3607.1179, 1878.8740);
	angles[24] = (0, 170, 0);
	at[24] = 14;
	points[25] = (-6749.7637, 3525.0159, 1892.8662);
	angles[25] = (0, 170, 0);
	at[25] = 15.5000;
	points[26] = (-6715.6299, 3460.2756, 1909.6023);
	angles[26] = (0, 170, 0);
	at[26] = 15.9167;
	points[27] = (-6639.8818, 3318.5513, 1927.3898);
	angles[27] = (0, 170, 0);
	at[27] = 16.8333;
	points[28] = (-6635.4331, 3304.8149, 1929.2047);
	angles[28] = (0, 170, 0);
	at[28] = 16.9167;
	points[29] = (-6613.1108, 3159.5159, 1948.8229);
	angles[29] = (0, 170, 0);
	at[29] = 17.7500;
	points[30] = (-6600.1973, 3075.2441, 1950.7480);
	angles[30] = (0, 170, 0);
	at[30] = 18.2333;
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
	points[0] = (-7941.7324, 6205.3545, 1767.7086);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-7677.0078, 6177.7559, 1700.2795);
	angles[1] = (0, -180, 0);
	at[1] = 1.5500;
	points[2] = (-7521.6143, 6147.3623, 1683.8151);
	angles[2] = (0, -180, 0);
	at[2] = 2.4500;
	points[3] = (-7436.6929, 6123.2285, 1675.0750);
	angles[3] = (0, -180, 0);
	at[3] = 2.9500;
	points[4] = (-7253.9766, 6058.1104, 1655.8937);
	angles[4] = (0, -180, 0);
	at[4] = 4.0500;
	points[5] = (-7171.1421, 6027.1650, 1650.5511);
	angles[5] = (0, -180, 0);
	at[5] = 4.5500;
	points[6] = (-7001.0239, 5952.4800, 1659.7048);
	angles[6] = (0, -180, 0);
	at[6] = 5.6000;
	points[7] = (-6998.3071, 5951.2603, 1659.8583);
	angles[7] = (0, -180, 0);
	at[7] = 5.7000;
	points[8] = (-6998.3071, 5951.2603, 1659.8583);
	angles[8] = (0, -180, 0);
	at[8] = 5.8500;
	points[9] = (-7004.2124, 5953.9370, 1659.5237);
	angles[9] = (0, -180, 0);
	at[9] = 5.9000;
	points[10] = (-7166.2207, 6025.1182, 1650.3977);
	angles[10] = (0, -180, 0);
	at[10] = 6.9000;
	points[11] = (-7257.2837, 6059.2915, 1656.2245);
	angles[11] = (0, -180, 0);
	at[11] = 7.4500;
	points[12] = (-7440, 6124.3706, 1675.4213);
	angles[12] = (0, -180, 0);
	at[12] = 8.5500;
	points[13] = (-7525, 6148.3076, 1684.1654);
	angles[13] = (0, -180, 0);
	at[13] = 9.0500;
	points[14] = (-7671.8896, 6176.9292, 1699.0237);
	angles[14] = (0, -180, 0);
	at[14] = 9.9000;
	points[15] = (-7783.0312, 6190.1182, 1725.8386);
	angles[15] = (0, -180, 0);
	at[15] = 10.5500;
	points[16] = (-7945.1182, 6205.7085, 1768.6024);
	angles[16] = (0, -180, 0);
	at[16] = 11.5000;
	points[17] = (-7945.1182, 6205.7085, 1768.6024);
	angles[17] = (0, -180, 0);
	at[17] = 11.7500;
	points[18] = (-7941.7324, 6205.3545, 1767.7086);
	angles[18] = (0, -180, 0);
	at[18] = 11.7667;
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
