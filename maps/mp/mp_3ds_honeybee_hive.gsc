main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_honeybee_hive", 0);

	setExpFog(-11072.8350, 101193.3984, 0.8667, 0.9529, 1, 0);

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
	ambientPlay("iz_0_3dshh", 2);
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
	level.iz_route[level.iz_route.size] = (-1804, -1279, 3912);
	level.iz_route[level.iz_route.size] = (-1339, -1291, 3912);
	level.iz_route[level.iz_route.size] = (-1038, -1460, 3912);
	level.iz_route[level.iz_route.size] = (-710, -2090, 3912);
	level.iz_route[level.iz_route.size] = (77, -2255, 3912);
	level.iz_route[level.iz_route.size] = (610, -1696, 3912);
	level.iz_route[level.iz_route.size] = (935, -1501, 3912);
	level.iz_route[level.iz_route.size] = (1563, -1284, 3912);
	level.iz_route[level.iz_route.size] = (1842, -213, 3912);
	level.iz_route[level.iz_route.size] = (1842, 33, 3912);
	level.iz_route[level.iz_route.size] = (1844, 411, 3912);
	level.iz_route[level.iz_route.size] = (1844, 656, 3912);
	level.iz_route[level.iz_route.size] = (1292, 1727, 3912);
	level.iz_route[level.iz_route.size] = (777, 1717, 3912);
	level.iz_route[level.iz_route.size] = (408, 1932, 3927);
	level.iz_route[level.iz_route.size] = (-160, 2280, 3945);
	level.iz_route[level.iz_route.size] = (-852, 2413, 3912);
	level.iz_route[level.iz_route.size] = (-1167, 2151, 3912);
	level.iz_route[level.iz_route.size] = (-1516, 1934, 3912);
	level.iz_route[level.iz_route.size] = (-1796, 1769, 3912);
	level.iz_route[level.iz_route.size] = (-2007, 721, 3912);
	level.iz_route[level.iz_route.size] = (-1935, 351, 3912);
	level.iz_route[level.iz_route.size] = (-1936, 66, 3912);
	level.iz_route[level.iz_route.size] = (-2158, -335, 3912);
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
	points[0] = (-1344.9606, -4381.8110, 5982.8350);
	angles[0] = (0, 4.4197, 0);
	at[0] = 0;
	points[1] = (-1359.8739, -4213.2676, 5839.9214);
	angles[1] = (0, 5.4626, 0);
	at[1] = 0.3167;
	points[2] = (-1443.8976, -3355.5000, 5115.9058);
	angles[2] = (0, 4.9047, 0);
	at[2] = 1.9000;
	points[3] = (-1457.3188, -3184.4214, 4970.0786);
	angles[3] = (0, 3.9622, 0);
	at[3] = 2.2167;
	points[4] = (-1466.4449, -3011.9961, 4821.2207);
	angles[4] = (0, 1.6877, 0);
	at[4] = 2.5333;
	points[5] = (-1457.9370, -2849.6497, 4673.7402);
	angles[5] = (0, -16.0413, 0);
	at[5] = 2.8500;
	points[6] = (-1354.5078, -2727.5042, 4520.9844);
	angles[6] = (0, -59.2928, 0);
	at[6] = 3.1667;
	points[7] = (-1182.8701, -2664.6655, 4391.6533);
	angles[7] = (0, -77.3547, 0);
	at[7] = 3.4833;
	points[8] = (-990.8386, -2637.0984, 4285.9058);
	angles[8] = (0, -88.6800, 0);
	at[8] = 3.8000;
	points[9] = (-779.5197, -2644.7402, 4203.3467);
	angles[9] = (0, -93.6469, 0);
	at[9] = 4.1167;
	points[10] = (-568.3386, -2660.3779, 4128.2285);
	angles[10] = (0, -94.6516, 0);
	at[10] = 4.4333;
	points[11] = (-142.9878, -2696.0156, 3984.9607);
	angles[11] = (0, -93.9460, 0);
	at[11] = 5.0667;
	points[12] = (51.1398, -2639.4526, 3971.3779);
	angles[12] = (0, -23.2578, 0);
	at[12] = 5.3833;
	points[13] = (32.5395, -2431.7205, 3971.3779);
	angles[13] = (0, 40.4061, 0);
	at[13] = 5.7000;
	points[14] = (-122.3027, -2272.2244, 3971.3779);
	angles[14] = (0, 45.0837, 0);
	at[14] = 6.0167;
	points[15] = (-601.1772, -1795.2048, 3971.3779);
	angles[15] = (0, 44.7711, 0);
	at[15] = 6.9667;
	points[16] = (-758.2244, -1634.0276, 3971.3779);
	angles[16] = (0, 43.2390, 0);
	at[16] = 7.2833;
	points[17] = (-840.3583, -1439.0708, 3971.3779);
	angles[17] = (0, -15.8399, 0);
	at[17] = 7.6000;
	points[18] = (-758.6536, -1233.6338, 3971.3779);
	angles[18] = (0, -39.6412, 0);
	at[18] = 7.9167;
	points[19] = (-606.4528, -1067.6102, 3971.3779);
	angles[19] = (0, -45.8617, 0);
	at[19] = 8.2333;
	points[20] = (-406.8583, -978.2953, 3971.3779);
	angles[20] = (0, -81.0832, 0);
	at[20] = 8.5500;
	points[21] = (-187.3217, -996.0354, 3971.3779);
	angles[21] = (0, -112.6797, 0);
	at[21] = 8.8667;
	points[22] = (15.6456, -1092.9803, 3971.3779);
	angles[22] = (0, -117.6272, 0);
	at[22] = 9.1833;
	points[23] = (177.8173, -1234.3937, 3971.3779);
	angles[23] = (0, -167.0401, 0);
	at[23] = 9.5000;
	points[24] = (163.3047, -1456.0157, 3971.3779);
	angles[24] = (0, -191.2561, 0);
	at[24] = 9.8167;
	points[25] = (117.6437, -1677.1182, 3971.3779);
	angles[25] = (0, -191.6381, 0);
	at[25] = 10.1333;
	points[26] = (105.3764, -1895.2362, 3971.3779);
	angles[26] = (0, -147.1883, 0);
	at[26] = 10.4500;
	points[27] = (308.9047, -1922.4292, 3971.3779);
	angles[27] = (0, -64.8434, 0);
	at[27] = 10.7667;
	points[28] = (494.0512, -1796.3583, 3971.3779);
	angles[28] = (0, -53.6805, 0);
	at[28] = 11.0833;
	points[29] = (675.6418, -1665.3779, 3971.3779);
	angles[29] = (0, -56.7287, 0);
	at[29] = 11.4000;
	points[30] = (868.0748, -1548.5001, 3971.3779);
	angles[30] = (0, -61.2950, 0);
	at[30] = 11.7167;
	points[31] = (1080.2205, -1503.9448, 3971.7324);
	angles[31] = (0, -100.6518, 0);
	at[31] = 12.0333;
	points[32] = (1519.2521, -1609.9331, 3972.9136);
	angles[32] = (0, -103.7831, 0);
	at[32] = 12.6667;
	points[33] = (1739.3505, -1647.9961, 3973.3860);
	angles[33] = (0, -84.7613, 0);
	at[33] = 12.9833;
	points[34] = (1863.9253, -1493.1299, 3973.1104);
	angles[34] = (0, -11.3085, 0);
	at[34] = 13.3000;
	points[35] = (1905.7678, -1274.4607, 3972.9529);
	angles[35] = (0, -10.6835, 0);
	at[35] = 13.6167;
	points[36] = (2028.8503, -608.3779, 3972.4805);
	angles[36] = (0, -10.2077, 0);
	at[36] = 14.5667;
	points[37] = (2068.1379, -386.3709, 3972.3230);
	angles[37] = (0, -9.7971, 0);
	at[37] = 14.8833;
	points[38] = (2102.5159, -166.5280, 3972.2046);
	angles[38] = (0, -5.0715, 0);
	at[38] = 15.2000;
	points[39] = (1992.0157, 3.7232, 3972.1260);
	angles[39] = (0, 47.0740, 0);
	at[39] = 15.5167;
	points[40] = (1777.9135, 7.7069, 3972.0474);
	angles[40] = (0, 102.4017, 0);
	at[40] = 15.8333;
	points[41] = (1559.7992, -44.0858, 3971.9292);
	angles[41] = (0, 104.4082, 0);
	at[41] = 16.1500;
	points[42] = (1342.8977, -106.1106, 3971.8113);
	angles[42] = (0, 108.0092, 0);
	at[42] = 16.4667;
	points[43] = (1136.3977, -196.2252, 3971.7324);
	angles[43] = (0, 126.7812, 0);
	at[43] = 16.7833;
	points[44] = (1022.0709, -383.6224, 3971.6140);
	angles[44] = (0, 156.2364, 0);
	at[44] = 17.1000;
	points[45] = (939.2244, -593.1496, 3971.5354);
	angles[45] = (0, 159.9985, 0);
	at[45] = 17.4167;
	points[46] = (865.5945, -806.4213, 3971.4568);
	angles[46] = (0, 161.7390, 0);
	at[46] = 17.7333;
	points[47] = (800.4960, -1019.8820, 3971.3779);
	angles[47] = (0, 173.2440, 0);
	at[47] = 18.0500;
	points[48] = (935.9567, -1147.8898, 3971.3779);
	angles[48] = (0, 271.7433, 0);
	at[48] = 18.3667;
	points[49] = (1157.7245, -1133.6456, 3971.3779);
	angles[49] = (0, 274.1432, 0);
	at[49] = 18.6833;
	points[50] = (1833.7166, -1080.8898, 3971.3779);
	angles[50] = (0, 274.7209, 0);
	at[50] = 19.6333;
	points[51] = (2055.8584, -1062.0393, 3971.3779);
	angles[51] = (0, 275.0274, 0);
	at[51] = 19.9500;
	points[52] = (2279.3228, -1037.4252, 3971.3779);
	angles[52] = (0, 281.5765, 0);
	at[52] = 20.2667;
	points[53] = (2387.1023, -867.9330, 3971.3779);
	angles[53] = (0, 356.4885, 0);
	at[53] = 20.5833;
	points[54] = (2290.8740, -673.5512, 3971.3779);
	angles[54] = (0, 398.0595, 0);
	at[54] = 20.9000;
	points[55] = (2255.7795, -470.1024, 3971.3779);
	angles[55] = (0, 330.2881, 0);
	at[55] = 21.2167;
	points[56] = (2428.1851, -329.2504, 3971.3779);
	angles[56] = (0, 305.0037, 0);
	at[56] = 21.5333;
	points[57] = (2617.6772, -222.1740, 3973.3860);
	angles[57] = (0, 272.6148, 0);
	at[57] = 21.8500;
	points[58] = (2842.8308, -218.9961, 3973.3464);
	angles[58] = (0, 271.6898, 0);
	at[58] = 22.1667;
	points[59] = (3000.1062, -111.8783, 3973.3464);
	angles[59] = (0, 361.9690, 0);
	at[59] = 22.4833;
	points[60] = (2979.8074, 114.3949, 3973.3464);
	angles[60] = (0, 366.2535, 0);
	at[60] = 22.8000;
	points[61] = (2953.1182, 338.1898, 3973.3464);
	angles[61] = (0, 367.3688, 0);
	at[61] = 23.1167;
	points[62] = (2909.2561, 555.6772, 3973.3464);
	angles[62] = (0, 401.4711, 0);
	at[62] = 23.4333;
	points[63] = (2704.3542, 512.5472, 3973.3464);
	angles[63] = (0, 454.4711, 0);
	at[63] = 23.7500;
	points[64] = (2504.3821, 582.4370, 3973.4253);
	angles[64] = (0, 403.8511, 0);
	at[64] = 24.0667;
	points[65] = (2331.3386, 723.4882, 3971.4568);
	angles[65] = (0, 406.7916, 0);
	at[65] = 24.3833;
	points[66] = (2005.2677, 1032.3071, 3972.4412);
	angles[66] = (0, 407.0513, 0);
	at[66] = 25.0167;
	points[67] = (1836.5789, 1184.0157, 3973.7402);
	angles[67] = (0, 409.9958, 0);
	at[67] = 25.3333;
	points[68] = (1632.9409, 1226.7206, 3987.0078);
	angles[68] = (0, 465.8878, 0);
	at[68] = 25.6500;
	points[69] = (1461.6929, 1287.6772, 3998.5039);
	angles[69] = (0, 363.8543, 0);
	at[69] = 25.9667;
	points[70] = (1636.1575, 1225.1417, 3998.8584);
	angles[70] = (0, 195.1113, 0);
	at[70] = 26.2833;
	points[71] = (1521.1338, 1040.2323, 3982.7561);
	angles[71] = (0, 135.0112, 0);
	at[71] = 26.6000;
	points[72] = (1316.7874, 960.3504, 3975.9448);
	angles[72] = (0, 101.5211, 0);
	at[72] = 26.9167;
	points[73] = (1095.1299, 922.5512, 3973.5042);
	angles[73] = (0, 97.4352, 0);
	at[73] = 27.2333;
	points[74] = (876.4134, 953.7520, 3972.1260);
	angles[74] = (0, 67.8714, 0);
	at[74] = 27.5500;
	points[75] = (732.5787, 1113.2914, 3971.5747);
	angles[75] = (0, 18.3085, 0);
	at[75] = 27.8667;
	points[76] = (760.0591, 1326.6458, 3971.3779);
	angles[76] = (0, -24.0562, 0);
	at[76] = 28.1833;
	points[77] = (857.2323, 1531.2756, 3971.3779);
	angles[77] = (0, -26.3055, 0);
	at[77] = 28.5000;
	points[78] = (959.6063, 1732.0985, 3971.3779);
	angles[78] = (0, -27.7772, 0);
	at[78] = 28.8167;
	points[79] = (1069.3898, 1928.3700, 3971.3779);
	angles[79] = (0, -32.0041, 0);
	at[79] = 29.1333;
	points[80] = (1254.6143, 2029.0630, 3971.3779);
	angles[80] = (0, -88.1732, 0);
	at[80] = 29.4500;
	points[81] = (1477.2363, 2018.8347, 3971.3779);
	angles[81] = (0, -95, 0);
	at[81] = 29.7667;
	points[82] = (1701.8070, 1995.6930, 3971.3779);
	angles[82] = (0, -96.4664, 0);
	at[82] = 30.0833;
	points[83] = (1926.2401, 1968.2007, 3971.3779);
	angles[83] = (0, -97.6555, 0);
	at[83] = 30.4000;
	points[84] = (2137.9763, 1908.9213, 3971.3779);
	angles[84] = (0, -131.7093, 0);
	at[84] = 30.7167;
	points[85] = (2237.9094, 1710.7756, 3971.3779);
	angles[85] = (0, -159.5318, 0);
	at[85] = 31.0333;
	points[86] = (2314.5591, 1498.5630, 3971.3779);
	angles[86] = (0, -160.5571, 0);
	at[86] = 31.3500;
	points[87] = (2386.7795, 1286.6693, 3971.3779);
	angles[87] = (0, -163.1793, 0);
	at[87] = 31.6667;
	points[88] = (2359.4133, 1075.1771, 3971.3779);
	angles[88] = (0, -215.5145, 0);
	at[88] = 31.9833;
	points[89] = (2217.8860, 901.8701, 3971.3779);
	angles[89] = (0, -220.1022, 0);
	at[89] = 32.3000;
	points[90] = (2069.6653, 731.5354, 3971.3779);
	angles[90] = (0, -222.2870, 0);
	at[90] = 32.6167;
	points[91] = (1906.4606, 581.8268, 3971.3779);
	angles[91] = (0, -244.5393, 0);
	at[91] = 32.9333;
	points[92] = (1689.7482, 520.5709, 3971.3779);
	angles[92] = (0, -258.5137, 0);
	at[92] = 33.2500;
	points[93] = (1466.9803, 481.2717, 3971.3779);
	angles[93] = (0, -260.2602, 0);
	at[93] = 33.5667;
	points[94] = (1267.2599, 539.0670, 3971.3779);
	angles[94] = (0, -322.4967, 0);
	at[94] = 33.8833;
	points[95] = (1005.9134, 908.1378, 3971.3779);
	angles[95] = (0, -325.6091, 0);
	at[95] = 34.5167;
	points[96] = (923.7441, 1109.1890, 3971.3779);
	angles[96] = (0, -348.5029, 0);
	at[96] = 34.8333;
	points[97] = (837.9528, 1552.1182, 3971.3779);
	angles[97] = (0, -347.9522, 0);
	at[97] = 35.4667;
	points[98] = (705.6614, 1716.7795, 3971.4175);
	angles[98] = (0, -303.2058, 0);
	at[98] = 35.7833;
	points[99] = (507.3386, 1821.0511, 3971.9292);
	angles[99] = (0, -290.7348, 0);
	at[99] = 36.1000;
	points[100] = (290.2917, 1821.1851, 3972.5591);
	angles[100] = (0, -255.1103, 0);
	at[100] = 36.4167;
	points[101] = (-359.0370, 1631.3071, 3973.2283);
	angles[101] = (0, -254.0357, 0);
	at[101] = 37.3667;
	points[102] = (-577.4725, 1603.2323, 3973.1890);
	angles[102] = (0, -293.6222, 0);
	at[102] = 37.6833;
	points[103] = (-700.6693, 1785.6693, 3972.2439);
	angles[103] = (0, -335.6044, 0);
	at[103] = 38;
	points[104] = (-754.5079, 1998.1102, 3971.5354);
	angles[104] = (0, -373.5534, 0);
	at[104] = 38.3167;
	points[105] = (-619.4016, 2162.5117, 3971.3779);
	angles[105] = (0, -429.3195, 0);
	at[105] = 38.6333;
	points[106] = (-404.1378, 2219.4646, 3971.3779);
	angles[106] = (0, -436.6885, 0);
	at[106] = 38.9500;
	points[107] = (255.6579, 2374.6377, 3971.3779);
	angles[107] = (0, -436.2864, 0);
	at[107] = 39.9000;
	points[108] = (467.3780, 2440.0789, 3971.3779);
	angles[108] = (0, -414.2234, 0);
	at[108] = 40.2167;
	points[109] = (477.1339, 2651.9880, 3971.3779);
	angles[109] = (0, -340.5787, 0);
	at[109] = 40.5333;
	points[110] = (385.9039, 2856.6536, 3971.3779);
	angles[110] = (0, -335.1339, 0);
	at[110] = 40.8500;
	points[111] = (290.1496, 3060.6377, 3971.3779);
	angles[111] = (0, -334.5380, 0);
	at[111] = 41.1667;
	points[112] = (168.6476, 3231.6340, 3971.3779);
	angles[112] = (0, -254.3333, 0);
	at[112] = 41.4833;
	points[113] = (-46.2591, 3182.2954, 3971.3779);
	angles[113] = (0, -253.8913, 0);
	at[113] = 41.8000;
	points[114] = (-479.2677, 3055.4370, 3971.3779);
	angles[114] = (0, -253.3380, 0);
	at[114] = 42.4333;
	points[115] = (-693.2874, 2988.3347, 3971.3779);
	angles[115] = (0, -253.7125, 0);
	at[115] = 42.7500;
	points[116] = (-745.1102, 2784.0710, 3971.3779);
	angles[116] = (0, -185.0110, 0);
	at[116] = 43.0667;
	points[117] = (-783.4135, 2333.4646, 3971.3779);
	angles[117] = (0, -185.8849, 0);
	at[117] = 43.7000;
	points[118] = (-904.3425, 2178.5393, 3971.3779);
	angles[118] = (0, -268.1236, 0);
	at[118] = 44.0167;
	points[119] = (-1123.6772, 2141.5786, 3971.3779);
	angles[119] = (0, -252.0530, 0);
	at[119] = 44.3333;
	points[120] = (-1331.2166, 2057.5435, 3971.3779);
	angles[120] = (0, -242.1685, 0);
	at[120] = 44.6500;
	points[121] = (-1537.6063, 1973.1812, 3971.3779);
	angles[121] = (0, -261.8578, 0);
	at[121] = 44.9667;
	points[122] = (-1758.2480, 2000.8190, 3971.3779);
	angles[122] = (0, -282.6689, 0);
	at[122] = 45.2833;
	points[123] = (-1978.7677, 2050.5315, 3971.3779);
	angles[123] = (0, -282.2732, 0);
	at[123] = 45.6000;
	points[124] = (-2193.8228, 2051.8860, 3971.3779);
	angles[124] = (0, -241.4871, 0);
	at[124] = 45.9167;
	points[125] = (-2385.2600, 1933.7599, 3971.3779);
	angles[125] = (0, -237.5480, 0);
	at[125] = 46.2333;
	points[126] = (-2762.3308, 1689.2363, 3971.3779);
	angles[126] = (0, -236.4313, 0);
	at[126] = 46.8667;
	points[127] = (-2945.5081, 1559.6851, 3971.3779);
	angles[127] = (0, -224.6488, 0);
	at[127] = 47.1833;
	points[128] = (-2930.0828, 1352.1929, 3972.8347);
	angles[128] = (0, -145.7722, 0);
	at[128] = 47.5000;
	points[129] = (-2760.9370, 1206.2362, 3975.3149);
	angles[129] = (0, -127.9434, 0);
	at[129] = 47.8167;
	points[130] = (-2582.3857, 1068.7205, 3977.5984);
	angles[130] = (0, -127.3004, 0);
	at[130] = 48.1333;
	points[131] = (-2397.5039, 943.2166, 3978.5828);
	angles[131] = (0, -112.4529, 0);
	at[131] = 48.4500;
	points[132] = (-2197.1062, 968.5354, 3977.5984);
	angles[132] = (0, -52.8715, 0);
	at[132] = 48.7667;
	points[133] = (-1668.1378, 1386.4763, 3973.1497);
	angles[133] = (0, -51.8790, 0);
	at[133] = 49.7167;
	points[134] = (-1486.8268, 1524.3779, 3971.6536);
	angles[134] = (0, -55.1001, 0);
	at[134] = 50.0333;
	points[135] = (-1299.4095, 1491.0867, 3971.4961);
	angles[135] = (0, -140.3260, 0);
	at[135] = 50.3500;
	points[136] = (-1230, 1280.8149, 3971.4961);
	angles[136] = (0, -180.3309, 0);
	at[136] = 50.6667;
	points[137] = (-1316.7795, 1081.0867, 3971.4568);
	angles[137] = (0, -216.2491, 0);
	at[137] = 50.9833;
	points[138] = (-1590.9291, 721.7244, 3971.4175);
	angles[138] = (0, -217.9864, 0);
	at[138] = 51.6167;
	points[139] = (-1730.4133, 547.2441, 3971.3779);
	angles[139] = (0, -221.3935, 0);
	at[139] = 51.9333;
	points[140] = (-1936.7756, 507.0039, 3971.3779);
	angles[140] = (0, -277.7290, 0);
	at[140] = 52.2500;
	points[141] = (-2606.4724, 601.3268, 3971.3779);
	angles[141] = (0, -277.8069, 0);
	at[141] = 53.2000;
	points[142] = (-2800.9724, 557.7087, 3971.3779);
	angles[142] = (0, -238.3660, 0);
	at[142] = 53.5167;
	points[143] = (-2993.7756, 440.5433, 3971.3779);
	angles[143] = (0, -240.9659, 0);
	at[143] = 53.8333;
	points[144] = (-3170.3345, 538.3386, 3971.3779);
	angles[144] = (0, -312.9595, 0);
	at[144] = 54.1500;
	points[145] = (-3339.1418, 686.0906, 3971.4175);
	angles[145] = (0, -295.8168, 0);
	at[145] = 54.4667;
	points[146] = (-3515.8386, 591.0433, 3971.4175);
	angles[146] = (0, -187.9615, 0);
	at[146] = 54.7833;
	points[147] = (-3504.0906, 367.9386, 3971.4568);
	angles[147] = (0, -175.3142, 0);
	at[147] = 55.1000;
	points[148] = (-3461.6497, -82.9051, 3971.5747);
	angles[148] = (0, -173.2225, 0);
	at[148] = 55.7333;
	points[149] = (-3301.1340, -198.7020, 3971.6536);
	angles[149] = (0, -111.5443, 0);
	at[149] = 56.0500;
	points[150] = (-3092.2913, -280.9087, 3971.6929);
	angles[150] = (0, -113.7684, 0);
	at[150] = 56.3667;
	points[151] = (-2881.8308, -302.3221, 3971.6536);
	angles[151] = (0, -70, 0);
	at[151] = 56.6833;
	points[152] = (-2460.5828, -142.7425, 3971.4961);
	angles[152] = (0, -69.1933, 0);
	at[152] = 57.3167;
	points[153] = (-2252.5000, -61.0291, 3971.3779);
	angles[153] = (0, -52.3119, 0);
	at[153] = 57.6333;
	points[154] = (-2048.0393, -145.5658, 3971.3779);
	angles[154] = (0, -114.1313, 0);
	at[154] = 57.9500;
	points[155] = (-1636.9489, -332.8693, 3971.3779);
	angles[155] = (0, -114.8821, 0);
	at[155] = 58.5833;
	points[156] = (-1497.6930, -413.0827, 3971.3779);
	angles[156] = (0, -188.7397, 0);
	at[156] = 58.9000;
	points[157] = (-1517.0157, -634.8071, 3971.3779);
	angles[157] = (0, -185.0050, 0);
	at[157] = 59.2167;
	points[158] = (-1557.7953, -1085.1968, 3971.3779);
	angles[158] = (0, -185.3479, 0);
	at[158] = 59.8500;
	points[159] = (-1603.9016, -1535.4253, 3971.3779);
	angles[159] = (0, -187.8694, 0);
	at[159] = 60.4833;
	points[160] = (-1755.5000, -1643.5748, 3971.3386);
	angles[160] = (0, -271.1899, 0);
	at[160] = 60.8000;
	points[161] = (-1938.0984, -1522.4056, 3971.9292);
	angles[161] = (0, -311.7233, 0);
	at[161] = 61.1167;
	points[162] = (-2106.1377, -1371.1299, 3972.7559);
	angles[162] = (0, -311.9311, 0);
	at[162] = 61.4333;
	points[163] = (-2296.9175, -1294.1654, 3973.3860);
	angles[163] = (0, -269.2700, 0);
	at[163] = 61.7500;
	points[164] = (-2749.2598, -1299.9253, 3973.6221);
	angles[164] = (0, -270.8475, 0);
	at[164] = 62.3833;
	points[165] = (-2826.1614, -1131.7716, 3973.3071);
	angles[165] = (0, -359.9721, 0);
	at[165] = 62.7000;
	points[166] = (-2825.6340, -905.3898, 3972.7166);
	angles[166] = (0, -360.2798, 0);
	at[166] = 63.0167;
	points[167] = (-2823.6809, -679.6496, 3972.1260);
	angles[167] = (0, -360.8172, 0);
	at[167] = 63.3333;
	points[168] = (-2773.3267, -486.0354, 3971.5354);
	angles[168] = (0, -456.0483, 0);
	at[168] = 63.6500;
	points[169] = (-2565.4016, -524.1339, 3986.4963);
	angles[169] = (0, -474.1287, 0);
	at[169] = 63.9667;
	points[170] = (-2360.2166, -613.3543, 4006.4175);
	angles[170] = (0, -462.5325, 0);
	at[170] = 64.2833;
	points[171] = (-2152.8936, -530.2008, 4006.3779);
	angles[171] = (0, -432.1811, 0);
	at[171] = 64.6000;
	points[172] = (-1971.0787, -654.6181, 4009.3306);
	angles[172] = (0, -491.9304, 0);
	at[172] = 64.9167;
	points[173] = (-1992.5945, -859.6654, 4013.5435);
	angles[173] = (0, -574.6661, 0);
	at[173] = 65.2333;
	points[174] = (-2159.5552, -953.7637, 4013.2283);
	angles[174] = (0, -657.0762, 0);
	at[174] = 65.5500;
	points[175] = (-2324.2795, -828.3071, 4010.8662);
	angles[175] = (0, -744.6202, 0);
	at[175] = 65.8667;
	points[176] = (-2145.7874, -711.9330, 4014.0945);
	angles[176] = (0, -792.0677, 0);
	at[176] = 66.1833;
	points[177] = (-1931.9922, -775.3622, 4010.5908);
	angles[177] = (0, -831.8844, 0);
	at[177] = 66.5000;
	points[178] = (-1859.2992, -974.6693, 4006.6536);
	angles[178] = (0, -798.6994, 0);
	at[178] = 66.8167;
	points[179] = (-1416.3071, -901.7363, 3973.7795);
	angles[179] = (0, -802.1890, 0);
	at[179] = 67.4500;
	points[180] = (-1286.8544, -1023.3937, 3971.3779);
	angles[180] = (0, -896.0707, 0);
	at[180] = 67.7667;
	points[181] = (-1268.9567, -1247.1890, 3971.3779);
	angles[181] = (0, -881.7177, 0);
	at[181] = 68.0833;
	points[182] = (-1096.1929, -1376.0826, 3971.3779);
	angles[182] = (0, -829.2020, 0);
	at[182] = 68.4000;
	points[183] = (-877.4645, -1426.0826, 3971.3779);
	angles[183] = (0, -824.6520, 0);
	at[183] = 68.7167;
	points[184] = (-691.8661, -1535.1299, 3971.3779);
	angles[184] = (0, -869.1636, 0);
	at[184] = 69.0333;
	points[185] = (-591.5630, -1737.4330, 3971.3779);
	angles[185] = (0, -875.8290, 0);
	at[185] = 69.3500;
	points[186] = (-503.2992, -1944.0946, 3971.3779);
	angles[186] = (0, -877.8425, 0);
	at[186] = 69.6667;
	points[187] = (-482.3504, -2158.0117, 3969.7639);
	angles[187] = (0, -924.1460, 0);
	at[187] = 69.9833;
	points[188] = (-643.9724, -2261.0828, 4022.9922);
	angles[188] = (0, -973.4863, 0);
	at[188] = 70.3000;
	points[189] = (-991.0866, -2357.7244, 4293.9370);
	angles[189] = (0, -974.9978, 0);
	at[189] = 70.9333;
	points[190] = (-1171.7323, -2404.9370, 4421.7720);
	angles[190] = (0, -975.9536, 0);
	at[190] = 71.2500;
	points[191] = (-1380.6182, -2420.6812, 4488.5830);
	angles[191] = (0, -989.3521, 0);
	at[191] = 71.5667;
	points[192] = (-1600.4174, -2428.5039, 4537.0474);
	angles[192] = (0, -985.2238, 0);
	at[192] = 71.8833;
	points[193] = (-1808.6536, -2471.8896, 4606.2207);
	angles[193] = (0, -966.4688, 0);
	at[193] = 72.2000;
	points[194] = (-1913.0511, -2607.2600, 4725.2363);
	angles[194] = (0, -907.5197, 0);
	at[194] = 72.5167;
	points[195] = (-1919.8190, -2791.5276, 4863.0713);
	angles[195] = (0, -899.2383, 0);
	at[195] = 72.8333;
	points[196] = (-1913.6062, -2972.2876, 4995.6299);
	angles[196] = (0, -897.1206, 0);
	at[196] = 73.1500;
	points[197] = (-1902.6143, -3154.4607, 5128.3071);
	angles[197] = (0, -896.0782, 0);
	at[197] = 73.4667;
	points[198] = (-1874.1968, -3517.3740, 5391.2603);
	angles[198] = (0, -895.1328, 0);
	at[198] = 74.1000;
	points[199] = (-1812.1851, -4247.5200, 5919.2915);
	angles[199] = (0, -895.9822, 0);
	at[199] = 75.3667;
	points[200] = (-1344.9606, -4381.8110, 5982.8350);
	angles[200] = (0, -1075.5803, 0);
	at[200] = 75.5333;
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
