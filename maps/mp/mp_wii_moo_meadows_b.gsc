main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_moo_meadows_b", 0);

	setExpFog(15463.0410, 29231.2422, 0.7176, 0.7333, 0.7451, 0);

	level.iz_cue = [];
	level.iz_cue["iz_cue_boost"] = true;
	level.iz_cue["iz_cue_bounce"] = true;
	level.iz_cue["iz_cue_cannon"] = true;
	level.iz_cue["iz_cue_finish"] = true;
	level.iz_cue["iz_cue_item"] = true;
	level.iz_cue["iz_cue_jump"] = true;
	thread iz_sounds();

	thread iz_course();

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
	ambientPlay("iz_0_wmmm", 2);
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
	level.iz_route[level.iz_route.size] = (2817, -2592, 2006);
	level.iz_route[level.iz_route.size] = (2183, -2846, 2001);
	level.iz_route[level.iz_route.size] = (1712, -3009, 2013);
	level.iz_route[level.iz_route.size] = (-1, -3742, 2044);
	level.iz_route[level.iz_route.size] = (-426, -3904, 2075);
	level.iz_route[level.iz_route.size] = (-819, -3929, 2127);
	level.iz_route[level.iz_route.size] = (-1732, -4098, 2217);
	level.iz_route[level.iz_route.size] = (-1953, -4518, 2240);
	level.iz_route[level.iz_route.size] = (-2077, -5001, 2250);
	level.iz_route[level.iz_route.size] = (-2424, -5391, 2287);
	level.iz_route[level.iz_route.size] = (-2890, -5524, 2346);
	level.iz_route[level.iz_route.size] = (-3539, -5779, 2315);
	level.iz_route[level.iz_route.size] = (-3949, -6144, 2321);
	level.iz_route[level.iz_route.size] = (-4012, -6664, 2319);
	level.iz_route[level.iz_route.size] = (-4081, -7397, 2318);
	level.iz_route[level.iz_route.size] = (-4067, -8125, 2315);
	level.iz_route[level.iz_route.size] = (-4053, -9398, 2311);
	level.iz_route[level.iz_route.size] = (-2215, -4163, 2245);
	level.iz_route[level.iz_route.size] = (-2902, -4270, 2330);
	level.iz_route[level.iz_route.size] = (-3411, -4590, 2334);
	level.iz_route[level.iz_route.size] = (-3715, -4997, 2347);
	level.iz_route[level.iz_route.size] = (-3773, -5498, 2327);
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
	points[0] = (-1935.7323, -4035.5906, 2222.4214);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1935.7323, -4035.5906, 2222.4214);
	angles[1] = (0, 0, 0);
	at[1] = 0.2333;
	points[2] = (-1935.7323, -4035.5906, 2259.2126);
	angles[2] = (0, 0, 0);
	at[2] = 0.3500;
	points[3] = (-1935.7323, -4035.5906, 2362.8701);
	angles[3] = (0, 0, 0);
	at[3] = 0.4667;
	points[4] = (-1935.7323, -4035.5906, 2427.4607);
	angles[4] = (0, 0, 0);
	at[4] = 0.5833;
	points[5] = (-1935.7323, -4035.5906, 2452.9883);
	angles[5] = (0, 0, 0);
	at[5] = 0.7000;
	points[6] = (-1935.7323, -4035.5906, 2439.4490);
	angles[6] = (0, 0, 0);
	at[6] = 0.8167;
	points[7] = (-1935.7323, -4035.5906, 2386.8464);
	angles[7] = (0, 0, 0);
	at[7] = 0.9333;
	points[8] = (-1935.7323, -4035.5906, 2295.1772);
	angles[8] = (0, 0, 0);
	at[8] = 1.0500;
	points[9] = (-1933.0669, -4048.5039, 2045.2323);
	angles[9] = (0, 0, 0);
	at[9] = 1.1667;
	points[10] = (-1929.7756, -4100.9058, 2046.0315);
	angles[10] = (0, 0, 0);
	at[10] = 1.2833;
	points[11] = (-1930.9646, -4152.9922, 2047.3740);
	angles[11] = (0, 0, 0);
	at[11] = 1.4000;
	points[12] = (-1957.4567, -4463.1104, 2058.4172);
	angles[12] = (0, 0, 0);
	at[12] = 2.1000;
	points[13] = (-1957.6143, -4668.0708, 2070.9490);
	angles[13] = (0, 0, 0);
	at[13] = 2.5667;
	points[14] = (-1949.7401, -4769.9214, 2073.4883);
	angles[14] = (0, 0, 0);
	at[14] = 2.8000;
	points[15] = (-1929.7166, -4976.6533, 2071.7205);
	angles[15] = (0, 0, 0);
	at[15] = 3.2667;
	points[16] = (-1915.2401, -5079.1338, 2070.5276);
	angles[16] = (0, 0, 0);
	at[16] = 3.5000;
	points[17] = (-1892.3701, -5179.6851, 2069.4016);
	angles[17] = (0, 0, 0);
	at[17] = 3.7333;
	points[18] = (-1870.8505, -5224.7241, 2069.1260);
	angles[18] = (0, 0, 0);
	at[18] = 3.8500;
	points[19] = (-1837.7086, -5265.0791, 2069.5669);
	angles[19] = (0, 0, 0);
	at[19] = 3.9667;
	points[20] = (-1801.6694, -5302.4019, 2070.2244);
	angles[20] = (0, 0, 0);
	at[20] = 4.0833;
	points[21] = (-1647.9371, -5441.7715, 2072.4016);
	angles[21] = (0, 0, 0);
	at[21] = 4.5500;
	points[22] = (-1488.4409, -5574.5669, 2068.4172);
	angles[22] = (0, 0, 0);
	at[22] = 5.0167;
	points[23] = (-1405.5354, -5632.3232, 2052.3269);
	angles[23] = (0, 0, 0);
	at[23] = 5.2500;
	points[24] = (-1234.4646, -5741.9292, 2009.3503);
	angles[24] = (0, 0, 0);
	at[24] = 5.7167;
	points[25] = (-1152.4843, -5802.0078, 1987.3544);
	angles[25] = (0, 0, 0);
	at[25] = 5.9500;
	points[26] = (-1117.4174, -5838.1890, 2155.0708);
	angles[26] = (0, 0, 0);
	at[26] = 6.0667;
	points[27] = (-1117.4174, -5838.1890, 2155.0708);
	angles[27] = (0, 0, 0);
	at[27] = 7.7000;
	points[28] = (-1117.4174, -5838.1890, 2327.9841);
	angles[28] = (0, 0, 0);
	at[28] = 7.9333;
	points[29] = (-1117.4174, -5838.1890, 2375.8308);
	angles[29] = (0, 0, 0);
	at[29] = 8.0500;
	points[30] = (-1117.4174, -5838.1890, 2384.6182);
	angles[30] = (0, 0, 0);
	at[30] = 8.1667;
	points[31] = (-1117.4174, -5838.1890, 2354.3347);
	angles[31] = (0, 0, 0);
	at[31] = 8.2833;
	points[32] = (-1117.4174, -5838.1890, 2284.9922);
	angles[32] = (0, 0, 0);
	at[32] = 8.4000;
	points[33] = (-1117.4174, -5838.1890, 2176.5786);
	angles[33] = (0, 0, 0);
	at[33] = 8.5167;
	points[34] = (-1103.8859, -5871.0234, 1974.2559);
	angles[34] = (0, 0, 0);
	at[34] = 8.6333;
	points[35] = (-1093.7756, -5921.3779, 1971.2363);
	angles[35] = (0, 0, 0);
	at[35] = 8.7500;
	points[36] = (-1085.0669, -6024.9214, 1967.8190);
	angles[36] = (0, 0, 0);
	at[36] = 8.9833;
	points[37] = (-1085.5394, -6128.6616, 1966.3190);
	angles[37] = (0, 0, 0);
	at[37] = 9.2167;
	points[38] = (-1089.8110, -6180.1973, 1966.2914);
	angles[38] = (0, 0, 0);
	at[38] = 9.3333;
	points[39] = (-1101.9922, -6229.5273, 1967.5040);
	angles[39] = (0, 0, 0);
	at[39] = 9.4500;
	points[40] = (-1142.4133, -6259.9214, 1973.4843);
	angles[40] = (0, 0, 0);
	at[40] = 9.5667;
	points[41] = (-1190.4174, -6278.8188, 1980.9252);
	angles[41] = (0, 0, 0);
	at[41] = 9.6833;
	points[42] = (-1239.8505, -6292.0078, 1988.7008);
	angles[42] = (0, 0, 0);
	at[42] = 9.8000;
	points[43] = (-1290.2677, -6300.4336, 1996.7126);
	angles[43] = (0, 0, 0);
	at[43] = 9.9167;
	points[44] = (-1341.4133, -6302.2837, 2004.9331);
	angles[44] = (0, 0, 0);
	at[44] = 10.0333;
	points[45] = (-1389.1575, -6286.9292, 2012.9094);
	angles[45] = (0, 0, 0);
	at[45] = 10.1500;
	points[46] = (-1431.0945, -6259.0947, 2020.3425);
	angles[46] = (0, 0, 0);
	at[46] = 10.2667;
	points[47] = (-1512.2953, -6195.8662, 2034.8937);
	angles[47] = (0, 0, 0);
	at[47] = 10.5000;
	points[48] = (-1629.5040, -6094.9604, 2055.4094);
	angles[48] = (0, 0, 0);
	at[48] = 10.8500;
	points[49] = (-1703.0511, -6025.5122, 2066.5078);
	angles[49] = (0, 0, 0);
	at[49] = 11.0833;
	points[50] = (-1768.2756, -5944.8423, 2070.7361);
	angles[50] = (0, 0, 0);
	at[50] = 11.3167;
	points[51] = (-1921.3937, -5737.7168, 2074.8308);
	angles[51] = (0, 0, 0);
	at[51] = 11.9000;
	points[52] = (-2097.1260, -5546.6929, 2077.7283);
	angles[52] = (0, 0, 0);
	at[52] = 12.4833;
	points[53] = (-2162.5552, -5465.9058, 2079.4961);
	angles[53] = (0, 0, 0);
	at[53] = 12.7167;
	points[54] = (-2185.4292, -5428.4644, 2257.9763);
	angles[54] = (0, 0, 0);
	at[54] = 12.8333;
	points[55] = (-2185.4292, -5428.4644, 2257.9763);
	angles[55] = (0, 0, 0);
	at[55] = 14.4667;
	points[56] = (-2185.4292, -5428.4644, 2358.7834);
	angles[56] = (0, 0, 0);
	at[56] = 14.5833;
	points[57] = (-2185.4292, -5428.4644, 2440.1182);
	angles[57] = (0, 0, 0);
	at[57] = 14.7000;
	points[58] = (-2185.4292, -5428.4644, 2482.3860);
	angles[58] = (0, 0, 0);
	at[58] = 14.8167;
	points[59] = (-2185.4292, -5428.4644, 2485.5906);
	angles[59] = (0, 0, 0);
	at[59] = 14.9333;
	points[60] = (-2185.4292, -5428.4644, 2449.7283);
	angles[60] = (0, 0, 0);
	at[60] = 15.0500;
	points[61] = (-2185.4292, -5428.4644, 2374.8032);
	angles[61] = (0, 0, 0);
	at[61] = 15.1667;
	points[62] = (-2185.4292, -5428.4644, 2260.8110);
	angles[62] = (0, 0, 0);
	at[62] = 15.2833;
	points[63] = (-2199.1221, -5387.7559, 2083.0630);
	angles[63] = (0, 0, 0);
	at[63] = 15.4000;
	points[64] = (-2227.1182, -5235.0786, 2093.3269);
	angles[64] = (0, 0, 0);
	at[64] = 15.7500;
	points[65] = (-2260.9094, -4978.0708, 2110.2795);
	angles[65] = (0, 0, 0);
	at[65] = 16.3333;
	points[66] = (-2300.4331, -4724.0552, 2113.1614);
	angles[66] = (0, 0, 0);
	at[66] = 16.9167;
	points[67] = (-2323.7007, -4622.7954, 2113.5039);
	angles[67] = (0, 0, 0);
	at[67] = 17.1500;
	points[68] = (-2345.5042, -4577.7559, 2114.6968);
	angles[68] = (0, 0, 0);
	at[68] = 17.2667;
	points[69] = (-2380.0198, -4539.0947, 2117.1182);
	angles[69] = (0, 0, 0);
	at[69] = 17.3833;
	points[70] = (-2417.5354, -4503.3857, 2119.8032);
	angles[70] = (0, 0, 0);
	at[70] = 17.5000;
	points[71] = (-2572.9055, -4365.7876, 2130.2087);
	angles[71] = (0, 0, 0);
	at[71] = 17.9667;
	points[72] = (-2606.6497, -4328.9370, 2131.4685);
	angles[72] = (0, 0, 0);
	at[72] = 18.0833;
	points[73] = (-2668.9055, -4245.6694, 2130.3347);
	angles[73] = (0, 0, 0);
	at[73] = 18.3167;
	points[74] = (-2726.5828, -4159.3701, 2128.1260);
	angles[74] = (0, 0, 0);
	at[74] = 18.5500;
	points[75] = (-2752.6301, -4114.5669, 2126.9214);
	angles[75] = (0, 0, 0);
	at[75] = 18.6667;
	points[76] = (-2773.9214, -4067.0867, 2125.7954);
	angles[76] = (0, 0, 0);
	at[76] = 18.7833;
	points[77] = (-2775.8347, -4060.3545, 2302.8386);
	angles[77] = (0, 0, 0);
	at[77] = 18.9000;
	points[78] = (-2775.8347, -4060.3545, 2302.8386);
	angles[78] = (0, 0, 0);
	at[78] = 20.4167;
	points[79] = (-2775.8347, -4060.3545, 2373.2324);
	angles[79] = (0, 0, 0);
	at[79] = 20.5333;
	points[80] = (-2775.8347, -4060.3545, 2465.7285);
	angles[80] = (0, 0, 0);
	at[80] = 20.6500;
	points[81] = (-2775.8347, -4060.3545, 2519.1575);
	angles[81] = (0, 0, 0);
	at[81] = 20.7667;
	points[82] = (-2775.8347, -4060.3545, 2533.5237);
	angles[82] = (0, 0, 0);
	at[82] = 20.8833;
	points[83] = (-2775.8347, -4060.3545, 2508.8228);
	angles[83] = (0, 0, 0);
	at[83] = 21;
	points[84] = (-2775.8347, -4060.3545, 2445.0591);
	angles[84] = (0, 0, 0);
	at[84] = 21.1167;
	points[85] = (-2775.8347, -4060.3545, 2342.2283);
	angles[85] = (0, 0, 0);
	at[85] = 21.2333;
	points[86] = (-2779.5435, -4031.7322, 2125.3545);
	angles[86] = (0, 0, 0);
	at[86] = 21.3500;
	points[87] = (-2776.9250, -3928.5354, 2124.7756);
	angles[87] = (0, 0, 0);
	at[87] = 21.5833;
	points[88] = (-2765.5000, -3825.4685, 2124.1064);
	angles[88] = (0, 0, 0);
	at[88] = 21.8167;
	points[89] = (-2745.1340, -3723.7402, 2122.5984);
	angles[89] = (0, 0, 0);
	at[89] = 22.0500;
	points[90] = (-2723.2205, -3678.1809, 2120.1772);
	angles[90] = (0, 0, 0);
	at[90] = 22.1667;
	points[91] = (-2689.8347, -3639.4412, 2116.1536);
	angles[91] = (0, 0, 0);
	at[91] = 22.2833;
	points[92] = (-2652.6143, -3603.1892, 2111.6575);
	angles[92] = (0, 0, 0);
	at[92] = 22.4000;
	points[93] = (-2572.4370, -3538.0906, 2102.0906);
	angles[93] = (0, 0, 0);
	at[93] = 22.6333;
	points[94] = (-2528.9763, -3510.8269, 2097.0669);
	angles[94] = (0, 0, 0);
	at[94] = 22.7500;
	points[95] = (-2481.4844, -3496.1812, 2091.9961);
	angles[95] = (0, 0, 0);
	at[95] = 22.8667;
	points[96] = (-2431.5510, -3510.4963, 2087.5120);
	angles[96] = (0, 0, 0);
	at[96] = 22.9833;
	points[97] = (-2338.8818, -3555.7759, 2079.6575);
	angles[97] = (0, 0, 0);
	at[97] = 23.2167;
	points[98] = (-2250.1023, -3608.9568, 2072.2874);
	angles[98] = (0, 0, 0);
	at[98] = 23.4500;
	points[99] = (-2166.1890, -3670.2046, 2065.3149);
	angles[99] = (0, 0, 0);
	at[99] = 23.6833;
	points[100] = (-2132.7915, -3706.8228, 2062.3899);
	angles[100] = (0, 0, 0);
	at[100] = 23.8000;
	points[101] = (-2101.4253, -3748.0945, 2059.5474);
	angles[101] = (0, 0, 0);
	at[101] = 23.9167;
	points[102] = (-2042.9214, -3833.8071, 2054.2244);
	angles[102] = (0, 0, 0);
	at[102] = 24.1500;
	points[103] = (-1988.9725, -3922.3662, 2049.4094);
	angles[103] = (0, 0, 0);
	at[103] = 24.3833;
	points[104] = (-1942.6575, -4015.0396, 2045.6418);
	angles[104] = (0, 0, 0);
	at[104] = 24.6167;
	points[105] = (-1935.7323, -4035.5906, 2222.4214);
	angles[105] = (0, 0, 0);
	at[105] = 24.7333;
	points[106] = (-1935.7323, -4035.5906, 2222.4214);
	angles[106] = (0, 0, 0);
	at[106] = 26.0167;
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
	points[0] = (-3661.5120, -5164.6460, 2158.9685);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3514.3779, -5146.5752, 2156.2402);
	angles[1] = (0, 0, 0);
	at[1] = 0.3333;
	points[2] = (-3440.0117, -5143.7402, 2155.6812);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-3404.2126, -5147.8740, 2155.6497);
	angles[3] = (0, 0, 0);
	at[3] = 0.5833;
	points[4] = (-3370.9250, -5163.3071, 2156.3506);
	angles[4] = (0, 0, 0);
	at[4] = 0.6667;
	points[5] = (-3339.5552, -5183.0708, 2157.4292);
	angles[5] = (0, 0, 0);
	at[5] = 0.7500;
	points[6] = (-3280.4253, -5227.5591, 2159.8191);
	angles[6] = (0, 0, 0);
	at[6] = 0.9167;
	points[7] = (-3226.1262, -5277.3623, 2162.0315);
	angles[7] = (0, 0, 0);
	at[7] = 1.0833;
	points[8] = (-3202.6262, -5306.4175, 2162.7048);
	angles[8] = (0, 0, 0);
	at[8] = 1.1667;
	points[9] = (-3190.0549, -5339.7642, 2162.1733);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-3171.6143, -5449.4888, 2158.6890);
	angles[10] = (0, 0, 0);
	at[10] = 1.5000;
	points[11] = (-3166.8152, -5523.4648, 2156.3228);
	angles[11] = (0, 0, 0);
	at[11] = 1.6667;
	points[12] = (-3167.3975, -5560.5513, 2155.3464);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-3169.8542, -5582.6772, 2332.1418);
	angles[13] = (0, 0, 0);
	at[13] = 1.8333;
	points[14] = (-3169.8542, -5582.6772, 2332.1418);
	angles[14] = (0, 0, 0);
	at[14] = 3.4167;
	points[15] = (-3169.8542, -5582.6772, 2368.9331);
	angles[15] = (0, 0, 0);
	at[15] = 3.5000;
	points[16] = (-3169.8542, -5582.6772, 2446.9607);
	angles[16] = (0, 0, 0);
	at[16] = 3.5833;
	points[17] = (-3169.8542, -5582.6772, 2505.0552);
	angles[17] = (0, 0, 0);
	at[17] = 3.6667;
	points[18] = (-3169.8542, -5582.6772, 2543.2205);
	angles[18] = (0, 0, 0);
	at[18] = 3.7500;
	points[19] = (-3169.8542, -5582.6772, 2561.4526);
	angles[19] = (0, 0, 0);
	at[19] = 3.8333;
	points[20] = (-3169.8542, -5582.6772, 2559.7559);
	angles[20] = (0, 0, 0);
	at[20] = 3.9167;
	points[21] = (-3169.8542, -5582.6772, 2538.1260);
	angles[21] = (0, 0, 0);
	at[21] = 4;
	points[22] = (-3169.8542, -5582.6772, 2496.5669);
	angles[22] = (0, 0, 0);
	at[22] = 4.0833;
	points[23] = (-3169.8542, -5582.6772, 2435.0747);
	angles[23] = (0, 0, 0);
	at[23] = 4.1667;
	points[24] = (-3169.8542, -5582.6772, 2353.6536);
	angles[24] = (0, 0, 0);
	at[24] = 4.2500;
	points[25] = (-3175.7087, -5602.5586, 2155.0198);
	angles[25] = (0, 0, 0);
	at[25] = 4.3333;
	points[26] = (-3191.8896, -5636.2207, 2155.6497);
	angles[26] = (0, 0, 0);
	at[26] = 4.4167;
	points[27] = (-3229.5828, -5699.8027, 2157.4055);
	angles[27] = (0, 0, 0);
	at[27] = 4.5833;
	points[28] = (-3332.1494, -5854.3306, 2161.6379);
	angles[28] = (0, 0, 0);
	at[28] = 5;
	points[29] = (-3412.8545, -5977.4805, 2160.7834);
	angles[29] = (0, 0, 0);
	at[29] = 5.3333;
	points[30] = (-3517.5513, -6130.6299, 2158.1301);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (-3608.3582, -6245.7876, 2153.7600);
	angles[31] = (0, 0, 0);
	at[31] = 6.0833;
	points[32] = (-3703.6536, -6359.0552, 2148.7126);
	angles[32] = (0, 0, 0);
	at[32] = 6.4167;
	points[33] = (-3754.9292, -6411.1021, 2146.3818);
	angles[33] = (0, 0, 0);
	at[33] = 6.5833;
	points[34] = (-3784.4412, -6433.1494, 2145.2126);
	angles[34] = (0, 0, 0);
	at[34] = 6.6667;
	points[35] = (-3847.1101, -6472.6377, 2143.0630);
	angles[35] = (0, 0, 0);
	at[35] = 6.8333;
	points[36] = (-3913.7717, -6504.3311, 2142.1182);
	angles[36] = (0, 0, 0);
	at[36] = 7;
	points[37] = (-3921.0825, -6506.5747, 2319.4016);
	angles[37] = (0, 0, 0);
	at[37] = 7.0833;
	points[38] = (-3921.0825, -6506.5747, 2319.4016);
	angles[38] = (0, 0, 0);
	at[38] = 8.6667;
	points[39] = (-3921.0825, -6506.5747, 2459.8506);
	angles[39] = (0, 0, 0);
	at[39] = 8.8333;
	points[40] = (-3921.0825, -6506.5747, 2509.9724);
	angles[40] = (0, 0, 0);
	at[40] = 8.9167;
	points[41] = (-3921.0825, -6506.5747, 2540.1655);
	angles[41] = (0, 0, 0);
	at[41] = 9;
	points[42] = (-3921.0825, -6506.5747, 2550.4253);
	angles[42] = (0, 0, 0);
	at[42] = 9.0833;
	points[43] = (-3921.0825, -6506.5747, 2540.7561);
	angles[43] = (0, 0, 0);
	at[43] = 9.1667;
	points[44] = (-3921.0825, -6506.5747, 2511.1536);
	angles[44] = (0, 0, 0);
	at[44] = 9.2500;
	points[45] = (-3921.0825, -6506.5747, 2461.6221);
	angles[45] = (0, 0, 0);
	at[45] = 9.3333;
	points[46] = (-3921.0825, -6506.5747, 2392.1575);
	angles[46] = (0, 0, 0);
	at[46] = 9.4167;
	points[47] = (-3921.0825, -6506.5747, 2142.2363);
	angles[47] = (0, 0, 0);
	at[47] = 9.5000;
	points[48] = (-3993.7795, -6513.8584, 2146.9724);
	angles[48] = (0, 0, 0);
	at[48] = 9.6667;
	points[49] = (-4067.4805, -6513.4253, 2153.1025);
	angles[49] = (0, 0, 0);
	at[49] = 9.8333;
	points[50] = (-4140.5117, -6505.4336, 2159.3071);
	angles[50] = (0, 0, 0);
	at[50] = 10;
	points[51] = (-4175.4727, -6493.2681, 2162.0393);
	angles[51] = (0, 0, 0);
	at[51] = 10.0833;
	points[52] = (-4199.0942, -6466.5356, 2163.1575);
	angles[52] = (0, 0, 0);
	at[52] = 10.1667;
	points[53] = (-4218.5435, -6434.4487, 2163.7166);
	angles[53] = (0, 0, 0);
	at[53] = 10.2500;
	points[54] = (-4251.1416, -6368.1890, 2164.3545);
	angles[54] = (0, 0, 0);
	at[54] = 10.4167;
	points[55] = (-4278.5830, -6299.4097, 2164.7954);
	angles[55] = (0, 0, 0);
	at[55] = 10.5833;
	points[56] = (-4298.1890, -6228.0317, 2165.3662);
	angles[56] = (0, 0, 0);
	at[56] = 10.7500;
	points[57] = (-4298.3071, -6155.2754, 2166.1458);
	angles[57] = (0, 0, 0);
	at[57] = 10.9167;
	points[58] = (-4283.8975, -6007.8745, 2167.6692);
	angles[58] = (0, 0, 0);
	at[58] = 11.2500;
	points[59] = (-4262.2837, -5860.8662, 2169.9409);
	angles[59] = (0, 0, 0);
	at[59] = 11.5833;
	points[60] = (-4245.3149, -5790.4331, 2172.8584);
	angles[60] = (0, 0, 0);
	at[60] = 11.7500;
	points[61] = (-4188.1494, -5654.6851, 2185.4253);
	angles[61] = (0, 0, 0);
	at[61] = 12.0833;
	points[62] = (-4122.2441, -5523.1494, 2196.9136);
	angles[62] = (0, 0, 0);
	at[62] = 12.4167;
	points[63] = (-4025.9844, -5365.6689, 2196.2993);
	angles[63] = (0, 0, 0);
	at[63] = 12.8333;
	points[64] = (-3959.8032, -5276.4961, 2193.1104);
	angles[64] = (0, 0, 0);
	at[64] = 13.0833;
	points[65] = (-3931.5750, -5254.1729, 2190.4529);
	angles[65] = (0, 0, 0);
	at[65] = 13.1667;
	points[66] = (-3899.0947, -5237.7949, 2186.2993);
	angles[66] = (0, 0, 0);
	at[66] = 13.2500;
	points[67] = (-3830.6143, -5210.8662, 2176.8896);
	angles[67] = (0, 0, 0);
	at[67] = 13.4167;
	points[68] = (-3725.1536, -5178.1104, 2163.2126);
	angles[68] = (0, 0, 0);
	at[68] = 13.6667;
	points[69] = (-3697.1064, -5171.2207, 2337.7441);
	angles[69] = (0, 0, 0);
	at[69] = 13.7500;
	points[70] = (-3697.1064, -5171.2207, 2337.7441);
	angles[70] = (0, 0, 0);
	at[70] = 15.3333;
	points[71] = (-3697.1064, -5171.2207, 2356.5354);
	angles[71] = (0, 0, 0);
	at[71] = 15.4167;
	points[72] = (-3697.1064, -5171.2207, 2438.5513);
	angles[72] = (0, 0, 0);
	at[72] = 15.5000;
	points[73] = (-3697.1064, -5171.2207, 2500.6299);
	angles[73] = (0, 0, 0);
	at[73] = 15.5833;
	points[74] = (-3697.1064, -5171.2207, 2542.7834);
	angles[74] = (0, 0, 0);
	at[74] = 15.6667;
	points[75] = (-3697.1064, -5171.2207, 2565);
	angles[75] = (0, 0, 0);
	at[75] = 15.7500;
	points[76] = (-3697.1064, -5171.2207, 2567.2913);
	angles[76] = (0, 0, 0);
	at[76] = 15.8333;
	points[77] = (-3697.1064, -5171.2207, 2549.6458);
	angles[77] = (0, 0, 0);
	at[77] = 15.9167;
	points[78] = (-3697.1064, -5171.2207, 2512.0750);
	angles[78] = (0, 0, 0);
	at[78] = 16;
	points[79] = (-3697.1064, -5171.2207, 2454.5669);
	angles[79] = (0, 0, 0);
	at[79] = 16.0833;
	points[80] = (-3697.1064, -5171.2207, 2377.1338);
	angles[80] = (0, 0, 0);
	at[80] = 16.1667;
	points[81] = (-3683.3740, -5168.4648, 2159.8191);
	angles[81] = (0, 0, 0);
	at[81] = 16.2500;
	points[82] = (-3661.5120, -5164.6460, 2158.9685);
	angles[82] = (0, 0, 0);
	at[82] = 16.3000;
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
	points[0] = (-138.4276, -4056.4172, 1878.8544);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-58.6189, -4122.4409, 1873.0039);
	angles[1] = (0, 0, 0);
	at[1] = 0.1667;
	points[2] = (-24.9146, -4160.1182, 1872.6772);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (70.7437, -4282.7163, 1877.2205);
	angles[3] = (0, 0, 0);
	at[3] = 0.5000;
	points[4] = (107.4012, -4319.2129, 1879.0945);
	angles[4] = (0, 0, 0);
	at[4] = 0.5833;
	points[5] = (149.3646, -4349.3306, 1880.8740);
	angles[5] = (0, 0, 0);
	at[5] = 0.6667;
	points[6] = (195.6677, -4367.5591, 1882.4448);
	angles[6] = (0, 0, 0);
	at[6] = 0.7500;
	points[7] = (295.3213, -4395.1182, 1886.2914);
	angles[7] = (0, 0, 0);
	at[7] = 0.9167;
	points[8] = (548.9330, -4451.4570, 1895.4409);
	angles[8] = (0, 0, 0);
	at[8] = 1.3333;
	points[9] = (650.8819, -4469.6455, 1898.3386);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (753.8150, -4483.9370, 1900.2716);
	angles[10] = (0, 0, 0);
	at[10] = 1.6667;
	points[11] = (804.5197, -4488.1890, 1900.5079);
	angles[11] = (0, 0, 0);
	at[11] = 1.7500;
	points[12] = (856.0354, -4488.2285, 1899.5670);
	angles[12] = (0, 0, 0);
	at[12] = 1.8333;
	points[13] = (906.7283, -4479.7246, 1896.2874);
	angles[13] = (0, 0, 0);
	at[13] = 1.9167;
	points[14] = (955.6339, -4467.2441, 1891.9607);
	angles[14] = (0, 0, 0);
	at[14] = 2;
	points[15] = (1054.5826, -4436.4961, 1881.7479);
	angles[15] = (0, 0, 0);
	at[15] = 2.1667;
	points[16] = (1151.6536, -4402.2837, 1870.7480);
	angles[16] = (0, 0, 0);
	at[16] = 2.3333;
	points[17] = (1391.6141, -4307.3228, 1841.7441);
	angles[17] = (0, 0, 0);
	at[17] = 2.7500;
	points[18] = (1531.3151, -4243.6221, 1824.9094);
	angles[18] = (0, 0, 0);
	at[18] = 3;
	points[19] = (1574.4844, -4217.4805, 1820.2599);
	angles[19] = (0, 0, 0);
	at[19] = 3.0833;
	points[20] = (1656.1693, -4154.3701, 1811.5316);
	angles[20] = (0, 0, 0);
	at[20] = 3.2500;
	points[21] = (1730.7086, -4082.9136, 1803.8820);
	angles[21] = (0, 0, 0);
	at[21] = 3.4167;
	points[22] = (1796.3623, -4003.4648, 1797.8622);
	angles[22] = (0, 0, 0);
	at[22] = 3.5833;
	points[23] = (1815.7638, -3972.8743, 1973.6418);
	angles[23] = (0, 0, 0);
	at[23] = 3.6667;
	points[24] = (1815.7638, -3972.8743, 1973.6418);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (1815.7638, -3972.8743, 2010.4330);
	angles[25] = (0, 0, 0);
	at[25] = 5.3333;
	points[26] = (1815.7638, -3972.8743, 2088.4568);
	angles[26] = (0, 0, 0);
	at[26] = 5.4167;
	points[27] = (1815.7638, -3972.8743, 2146.5552);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (1815.7638, -3972.8743, 2184.7166);
	angles[28] = (0, 0, 0);
	at[28] = 5.5833;
	points[29] = (1815.7638, -3972.8743, 2202.9529);
	angles[29] = (0, 0, 0);
	at[29] = 5.6667;
	points[30] = (1815.7638, -3972.8743, 2201.2520);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (1815.7638, -3972.8743, 2179.6260);
	angles[31] = (0, 0, 0);
	at[31] = 5.8333;
	points[32] = (1815.7638, -3972.8743, 2138.0630);
	angles[32] = (0, 0, 0);
	at[32] = 5.9167;
	points[33] = (1815.7638, -3972.8743, 2076.5747);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (1815.7638, -3972.8743, 1995.1497);
	angles[34] = (0, 0, 0);
	at[34] = 6.0833;
	points[35] = (1828.9882, -3946.9685, 1795.7992);
	angles[35] = (0, 0, 0);
	at[35] = 6.1667;
	points[36] = (1889.6417, -3802.8149, 1793.8779);
	angles[36] = (0, 0, 0);
	at[36] = 6.4167;
	points[37] = (1978.8977, -3559.3032, 1792.6063);
	angles[37] = (0, 0, 0);
	at[37] = 6.8333;
	points[38] = (2026.5079, -3410.6497, 1792.9292);
	angles[38] = (0, 0, 0);
	at[38] = 7.0833;
	points[39] = (2039.8899, -3360.5591, 1793.4803);
	angles[39] = (0, 0, 0);
	at[39] = 7.1667;
	points[40] = (2048.0786, -3312.3308, 1794.8307);
	angles[40] = (0, 0, 0);
	at[40] = 7.2500;
	points[41] = (2048.5789, -3208.5315, 1801.3584);
	angles[41] = (0, 0, 0);
	at[41] = 7.4167;
	points[42] = (2038.5237, -3105.8545, 1809.6418);
	angles[42] = (0, 0, 0);
	at[42] = 7.5833;
	points[43] = (2020.1024, -3004.4214, 1818.6537);
	angles[43] = (0, 0, 0);
	at[43] = 7.7500;
	points[44] = (2006.8386, -2954.7993, 1823.2480);
	angles[44] = (0, 0, 0);
	at[44] = 7.8333;
	points[45] = (1988.3859, -2905.8740, 1827.8503);
	angles[45] = (0, 0, 0);
	at[45] = 7.9167;
	points[46] = (1979.0433, -2888.4333, 2006.6576);
	angles[46] = (0, 0, 0);
	at[46] = 8;
	points[47] = (1979.0433, -2888.4333, 2006.6576);
	angles[47] = (0, 0, 0);
	at[47] = 9.5833;
	points[48] = (1979.0433, -2888.4333, 2060.6458);
	angles[48] = (0, 0, 0);
	at[48] = 9.6667;
	points[49] = (1979.0433, -2888.4333, 2134.6890);
	angles[49] = (0, 0, 0);
	at[49] = 9.7500;
	points[50] = (1979.0433, -2888.4333, 2188.7954);
	angles[50] = (0, 0, 0);
	at[50] = 9.8333;
	points[51] = (1979.0433, -2888.4333, 2222.9763);
	angles[51] = (0, 0, 0);
	at[51] = 9.9167;
	points[52] = (1979.0433, -2888.4333, 2237.2205);
	angles[52] = (0, 0, 0);
	at[52] = 10;
	points[53] = (1979.0433, -2888.4333, 2231.5393);
	angles[53] = (0, 0, 0);
	at[53] = 10.0833;
	points[54] = (1979.0433, -2888.4333, 2205.9211);
	angles[54] = (0, 0, 0);
	at[54] = 10.1667;
	points[55] = (1979.0433, -2888.4333, 2160.3779);
	angles[55] = (0, 0, 0);
	at[55] = 10.2500;
	points[56] = (1979.0433, -2888.4333, 2094.8977);
	angles[56] = (0, 0, 0);
	at[56] = 10.3333;
	points[57] = (1979.0433, -2888.4333, 2009.4922);
	angles[57] = (0, 0, 0);
	at[57] = 10.4167;
	points[58] = (1954.6299, -2855.8662, 1832.6575);
	angles[58] = (0, 0, 0);
	at[58] = 10.5000;
	points[59] = (1883.7363, -2780.7915, 1840.3544);
	angles[59] = (0, 0, 0);
	at[59] = 10.6667;
	points[60] = (1808.5511, -2710.3860, 1847.8268);
	angles[60] = (0, 0, 0);
	at[60] = 10.8333;
	points[61] = (1730.2795, -2642.7520, 1855.2008);
	angles[61] = (0, 0, 0);
	at[61] = 11;
	points[62] = (1648.8661, -2578.2600, 1862.4686);
	angles[62] = (0, 0, 0);
	at[62] = 11.1667;
	points[63] = (1563.6063, -2520.1143, 1869.4646);
	angles[63] = (0, 0, 0);
	at[63] = 11.3333;
	points[64] = (1520.0433, -2498.5867, 1872.5117);
	angles[64] = (0, 0, 0);
	at[64] = 11.4167;
	points[65] = (1470.5078, -2482.8071, 1875.4331);
	angles[65] = (0, 0, 0);
	at[65] = 11.5000;
	points[66] = (1318.6495, -2448.6458, 1883.4843);
	angles[66] = (0, 0, 0);
	at[66] = 11.7500;
	points[67] = (1165.1732, -2421.8623, 1891.0789);
	angles[67] = (0, 0, 0);
	at[67] = 12;
	points[68] = (1011.1614, -2399.3503, 1898.3190);
	angles[68] = (0, 0, 0);
	at[68] = 12.2500;
	points[69] = (858.3228, -2382.6104, 1904.7954);
	angles[69] = (0, 0, 0);
	at[69] = 12.5000;
	points[70] = (755.4961, -2384.4292, 1907.3466);
	angles[70] = (0, 0, 0);
	at[70] = 12.6667;
	points[71] = (652.1299, -2393.8545, 1908.9724);
	angles[71] = (0, 0, 0);
	at[71] = 12.8333;
	points[72] = (549.2480, -2407.5828, 1910.1102);
	angles[72] = (0, 0, 0);
	at[72] = 13;
	points[73] = (447.2441, -2426.0237, 1910.7993);
	angles[73] = (0, 0, 0);
	at[73] = 13.1667;
	points[74] = (407.8858, -2435.9016, 2088.0237);
	angles[74] = (0, 0, 0);
	at[74] = 13.2500;
	points[75] = (407.8858, -2435.9016, 2088.0237);
	angles[75] = (0, 0, 0);
	at[75] = 14.8333;
	points[76] = (407.8858, -2435.9016, 2106.8188);
	angles[76] = (0, 0, 0);
	at[76] = 14.9167;
	points[77] = (407.8858, -2435.9016, 2188.8306);
	angles[77] = (0, 0, 0);
	at[77] = 15;
	points[78] = (407.8858, -2435.9016, 2250.9133);
	angles[78] = (0, 0, 0);
	at[78] = 15.0833;
	points[79] = (407.8858, -2435.9016, 2293.0630);
	angles[79] = (0, 0, 0);
	at[79] = 15.1667;
	points[80] = (407.8858, -2435.9016, 2315.2834);
	angles[80] = (0, 0, 0);
	at[80] = 15.2500;
	points[81] = (407.8858, -2435.9016, 2317.5708);
	angles[81] = (0, 0, 0);
	at[81] = 15.3333;
	points[82] = (407.8858, -2435.9016, 2299.9292);
	angles[82] = (0, 0, 0);
	at[82] = 15.4167;
	points[83] = (407.8858, -2435.9016, 2262.3542);
	angles[83] = (0, 0, 0);
	at[83] = 15.5000;
	points[84] = (407.8858, -2435.9016, 2204.8503);
	angles[84] = (0, 0, 0);
	at[84] = 15.5833;
	points[85] = (407.8858, -2435.9016, 2127.4133);
	angles[85] = (0, 0, 0);
	at[85] = 15.6667;
	points[86] = (388.9984, -2441.8740, 1910.7441);
	angles[86] = (0, 0, 0);
	at[86] = 15.7500;
	points[87] = (244.1169, -2498.7285, 1908.1576);
	angles[87] = (0, 0, 0);
	at[87] = 16;
	points[88] = (151.2402, -2544.8779, 1905.9843);
	angles[88] = (0, 0, 0);
	at[88] = 16.1667;
	points[89] = (106.7508, -2571.4529, 1904.8898);
	angles[89] = (0, 0, 0);
	at[89] = 16.2500;
	points[90] = (64.9894, -2601.6575, 1903.8623);
	angles[90] = (0, 0, 0);
	at[90] = 16.3333;
	points[91] = (30.1170, -2636.7007, 1903.0316);
	angles[91] = (0, 0, 0);
	at[91] = 16.4167;
	points[92] = (0.2294, -2679.0117, 1902.3386);
	angles[92] = (0, 0, 0);
	at[92] = 16.5000;
	points[93] = (-106.1610, -2858.0593, 1899.8110);
	angles[93] = (0, 0, 0);
	at[93] = 16.8333;
	points[94] = (-225.0087, -3087.5593, 1896.8425);
	angles[94] = (0, 0, 0);
	at[94] = 17.2500;
	points[95] = (-267.9858, -3183.3584, 1895.6733);
	angles[95] = (0, 0, 0);
	at[95] = 17.4167;
	points[96] = (-286.4520, -3231.5039, 1895.1182);
	angles[96] = (0, 0, 0);
	at[96] = 17.5000;
	points[97] = (-299.2370, -3278.2520, 1894.6261);
	angles[97] = (0, 0, 0);
	at[97] = 17.5833;
	points[98] = (-304.9977, -3329.9253, 1894.2284);
	angles[98] = (0, 0, 0);
	at[98] = 17.6667;
	points[99] = (-307.0260, -3434.0081, 1893.6143);
	angles[99] = (0, 0, 0);
	at[99] = 17.8333;
	points[100] = (-300.2898, -3589.3506, 1892.7834);
	angles[100] = (0, 0, 0);
	at[100] = 18.0833;
	points[101] = (-286.6035, -3744.3149, 1891.8347);
	angles[101] = (0, 0, 0);
	at[101] = 18.3333;
	points[102] = (-263.5626, -3899.1614, 1890.2283);
	angles[102] = (0, 0, 0);
	at[102] = 18.5833;
	points[103] = (-244.9827, -3944.5276, 1888.5276);
	angles[103] = (0, 0, 0);
	at[103] = 18.6667;
	points[104] = (-213.6677, -3985.7480, 1885.5984);
	angles[104] = (0, 0, 0);
	at[104] = 18.7500;
	points[105] = (-138.4276, -4056.4172, 1878.8544);
	angles[105] = (0, 0, 0);
	at[105] = 18.9167;
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
