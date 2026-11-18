main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_beta_dry_dry_ruins", 0);

	setExpFog(4429.1338, 64099.4023, 0.6784, 0.6431, 0.0627, 0);

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
	ambientPlay("iz_0_wddr", 2);
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
	level.iz_route[level.iz_route.size] = (-14, 447, 1567);
	level.iz_route[level.iz_route.size] = (1, -1111, 1567);
	level.iz_route[level.iz_route.size] = (60, -2659, 1566);
	level.iz_route[level.iz_route.size] = (-486, -3695, 1518);
	level.iz_route[level.iz_route.size] = (-1120, -4681, 1614);
	level.iz_route[level.iz_route.size] = (-1384, -5307, 1657);
	level.iz_route[level.iz_route.size] = (-1135, -6039, 1505);
	level.iz_route[level.iz_route.size] = (212, -6551, 1423);
	level.iz_route[level.iz_route.size] = (1213, -6941, 1458);
	level.iz_route[level.iz_route.size] = (1641, -7792, 1393);
	level.iz_route[level.iz_route.size] = (1598, -9281, 1334);
	level.iz_route[level.iz_route.size] = (1671, -10320, 1476);
	level.iz_route[level.iz_route.size] = (1723, -13500, 1621);
	level.iz_route[level.iz_route.size] = (1742, -15178, 1741);
	level.iz_route[level.iz_route.size] = (1072, -16931, 1998);
	level.iz_route[level.iz_route.size] = (662, -17499, 2084);
	level.iz_route[level.iz_route.size] = (-118, -17788, 2124);
	level.iz_route[level.iz_route.size] = (-2501, -17781, 2128);
	level.iz_route[level.iz_route.size] = (-3113, -18779, 2173);
	level.iz_route[level.iz_route.size] = (-3026, -20164, 2186);
	level.iz_route[level.iz_route.size] = (-2104, -20313, 2187);
	level.iz_route[level.iz_route.size] = (1454, -19766, 2119);
	level.iz_route[level.iz_route.size] = (4208, -19937, 2020);
	level.iz_route[level.iz_route.size] = (5406, -19993, 2083);
	level.iz_route[level.iz_route.size] = (6814, -19974, 2184);
	level.iz_route[level.iz_route.size] = (6758, -17720, 2109);
	level.iz_route[level.iz_route.size] = (6673, -16969, 2078);
	level.iz_route[level.iz_route.size] = (6606, -15761, 2030);
	level.iz_route[level.iz_route.size] = (6747, -15111, 2032);
	level.iz_route[level.iz_route.size] = (6759, -12643, 1667);
	level.iz_route[level.iz_route.size] = (7163, -11540, 1693);
	level.iz_route[level.iz_route.size] = (8281, -11248, 1787);
	level.iz_route[level.iz_route.size] = (8974, -10575, 1876);
	level.iz_route[level.iz_route.size] = (9046, -9628, 1755);
	level.iz_route[level.iz_route.size] = (8042, -7556, 1579);
	level.iz_route[level.iz_route.size] = (7497, -6127, 1537);
	level.iz_route[level.iz_route.size] = (6784, -5011, 1263);
	level.iz_route[level.iz_route.size] = (6199, -4417, 1123);
	level.iz_route[level.iz_route.size] = (6292, -3849, 1096);
	level.iz_route[level.iz_route.size] = (5618, -3483, 1079);
	level.iz_route[level.iz_route.size] = (5024, -2381, 1145);
	level.iz_route[level.iz_route.size] = (4686, -1567, 1151);
	level.iz_route[level.iz_route.size] = (4351, -566, 1181);
	level.iz_route[level.iz_route.size] = (4001, 1203, 1459);
	level.iz_route[level.iz_route.size] = (4192, 2944, 1777);
	level.iz_route[level.iz_route.size] = (3442, 3884, 1866);
	level.iz_route[level.iz_route.size] = (2579, 3838, 1830);
	level.iz_route[level.iz_route.size] = (1424, 3716, 1878);
	level.iz_route[level.iz_route.size] = (307, 2808, 1831);
	level.iz_route[level.iz_route.size] = (203, 1463, 1612);
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
	thread iz_obj_5();
	thread iz_obj_6();
	thread iz_obj_7();
	thread iz_obj_8();
	thread iz_obj_9();
	thread iz_obj_10();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5165.5117, -15587.1260, 2209.5747);
	angles[0] = (0, -64.1503, 0);
	at[0] = 0;
	points[1] = (5184.4097, -15575.9053, 2209.5747);
	angles[1] = (0, -55.6788, 0);
	at[1] = 0.0500;
	points[2] = (5220.1968, -15549.5283, 2209.5747);
	angles[2] = (0, -53.8200, 0);
	at[2] = 0.1500;
	points[3] = (5277.3232, -15516.1416, 2209.5747);
	angles[3] = (0, -68.0806, 0);
	at[3] = 0.3000;
	points[4] = (5320.0396, -15505.1182, 2209.5747);
	angles[4] = (0, -83.2783, 0);
	at[4] = 0.4000;
	points[5] = (5341.0239, -15504.0156, 2209.5867);
	angles[5] = (0, -90.3256, 0);
	at[5] = 0.4500;
	points[6] = (5430.3149, -15509.8428, 2211.0789);
	angles[6] = (0, -95.1216, 0);
	at[6] = 0.6500;
	points[7] = (5672.9531, -15535.6689, 2215.3623);
	angles[7] = (0, -96.6244, 0);
	at[7] = 1.2000;
	points[8] = (5850, -15556.9688, 2215.8425);
	angles[8] = (0, -97.0800, 0);
	at[8] = 1.6000;
	points[9] = (5960.0791, -15570.9844, 2212.5237);
	angles[9] = (0, -97.4576, 0);
	at[9] = 1.8500;
	points[10] = (6001.3779, -15576.5361, 2208.3701);
	angles[10] = (0, -98.3267, 0);
	at[10] = 1.9500;
	points[11] = (6065.1572, -15587.2832, 2192.8032);
	angles[11] = (0, -100.3802, 0);
	at[11] = 2.1000;
	points[12] = (6375.5513, -15646.4570, 2085.6614);
	angles[12] = (0, -99.6133, 0);
	at[12] = 2.8500;
	points[13] = (6439.2915, -15656.2207, 2068.5354);
	angles[13] = (0, -97.4981, 0);
	at[13] = 3;
	points[14] = (6482.7559, -15660.7480, 2062.1260);
	angles[14] = (0, -93.7607, 0);
	at[14] = 3.1000;
	points[15] = (6502.4409, -15661.4961, 2062.5276);
	angles[15] = (0, -90.7581, 0);
	at[15] = 3.1500;
	points[16] = (6525.7090, -15661.3789, 2065.6653);
	angles[16] = (0, -88.8664, 0);
	at[16] = 3.2000;
	points[17] = (6589.8428, -15658.6221, 2080.5945);
	angles[17] = (0, -86.6500, 0);
	at[17] = 3.3500;
	points[18] = (6928.1499, -15630.5127, 2187.7324);
	angles[18] = (0, -85.0048, 0);
	at[18] = 4.1500;
	points[19] = (6991.9292, -15625.2373, 2203.8977);
	angles[19] = (0, -85.6956, 0);
	at[19] = 4.3000;
	points[20] = (7035, -15622.5205, 2209.6104);
	angles[20] = (0, -87.4066, 0);
	at[20] = 4.4000;
	points[21] = (7078.5830, -15620.7480, 2205.7598);
	angles[21] = (0, -87.8053, 0);
	at[21] = 4.5000;
	points[22] = (7143.5044, -15618.4258, 2192.2324);
	angles[22] = (0, -88.1096, 0);
	at[22] = 4.6500;
	points[23] = (7442.9922, -15612.1660, 2106.6182);
	angles[23] = (0, -89.9649, 0);
	at[23] = 5.3500;
	points[24] = (7508.8188, -15613.1504, 2092.4883);
	angles[24] = (0, -92.3559, 0);
	at[24] = 5.5000;
	points[25] = (7528.8188, -15614.4092, 2091.6536);
	angles[25] = (0, -95.5588, 0);
	at[25] = 5.5500;
	points[26] = (7571.7324, -15620.9453, 2101.0867);
	angles[26] = (0, -100.8902, 0);
	at[26] = 5.6500;
	points[27] = (7612.1655, -15629.6846, 2117.1968);
	angles[27] = (0, -103.2654, 0);
	at[27] = 5.7500;
	points[28] = (7784.8818, -15677.4014, 2206.6890);
	angles[28] = (0, -105.8941, 0);
	at[28] = 6.2000;
	points[29] = (7825.6694, -15689.5283, 2214.0828);
	angles[29] = (0, -107.7810, 0);
	at[29] = 6.3000;
	points[30] = (7952.3228, -15730.8262, 2210.1497);
	angles[30] = (0, -105.8118, 0);
	at[30] = 6.6000;
	points[31] = (7973.5435, -15734.9609, 2209.5747);
	angles[31] = (0, -91.4535, 0);
	at[31] = 6.6500;
	points[32] = (7995.3936, -15731.6924, 2209.5747);
	angles[32] = (0, -74.0593, 0);
	at[32] = 6.7000;
	points[33] = (8016.4175, -15724.8037, 2209.5747);
	angles[33] = (0, -72.3424, 0);
	at[33] = 6.7500;
	points[34] = (8037.5200, -15720.0400, 2209.5747);
	angles[34] = (0, -82.8246, 0);
	at[34] = 6.8000;
	points[35] = (8192.2832, -15703.6611, 2209.5747);
	angles[35] = (0, -84.0556, 0);
	at[35] = 7.1500;
	points[36] = (8192.2832, -15703.6611, 2209.5747);
	angles[36] = (0, -84.0556, 0);
	at[36] = 7.1667;
	points[37] = (5165.5117, -15587.1260, 2209.5747);
	angles[37] = (0, -64.1503, 0);
	at[37] = 7.1667;
	points[38] = (5165.5117, -15587.1260, 2209.5747);
	angles[38] = (0, -64.1503, 0);
	at[38] = 7.1833;
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
	points[0] = (8293.5439, -16365.9854, 2191.1260);
	angles[0] = (0, 77.1855, 0);
	at[0] = 0;
	points[1] = (8186.7720, -16337.2051, 2191.1260);
	angles[1] = (0, 74.3279, 0);
	at[1] = 0.2500;
	points[2] = (8057.5981, -16304.0166, 2191.1260);
	angles[2] = (0, 78.3080, 0);
	at[2] = 0.5500;
	points[3] = (8013.7798, -16297.1260, 2191.1260);
	angles[3] = (0, 85.5214, 0);
	at[3] = 0.6500;
	points[4] = (7992.2046, -16297.7568, 2191.1260);
	angles[4] = (0, 102.9948, 0);
	at[4] = 0.7000;
	points[5] = (7973.1104, -16308.0713, 2191.1299);
	angles[5] = (0, 128.7722, 0);
	at[5] = 0.7500;
	points[6] = (7957.1260, -16323.5039, 2191.1260);
	angles[6] = (0, 137.8683, 0);
	at[6] = 0.8000;
	points[7] = (7929.5278, -16358.4648, 2191.1260);
	angles[7] = (0, 144.1973, 0);
	at[7] = 0.9000;
	points[8] = (7904.0156, -16394.8809, 2191.1299);
	angles[8] = (0, 145.0671, 0);
	at[8] = 1;
	points[9] = (7877.7163, -16430.5918, 2191.1260);
	angles[9] = (0, 141.0198, 0);
	at[9] = 1.1000;
	points[10] = (7862.9136, -16447.0078, 2191.1260);
	angles[10] = (0, 133.6981, 0);
	at[10] = 1.1500;
	points[11] = (7845.4722, -16459.1738, 2191.1614);
	angles[11] = (0, 116.1000, 0);
	at[11] = 1.2000;
	points[12] = (7803.9370, -16475.2754, 2191.9607);
	angles[12] = (0, 108.4245, 0);
	at[12] = 1.3000;
	points[13] = (7718.3071, -16499.6855, 2193.5471);
	angles[13] = (0, 103.8799, 0);
	at[13] = 1.5000;
	points[14] = (7653.2285, -16513.8984, 2193.5000);
	angles[14] = (0, 100.3987, 0);
	at[14] = 1.6500;
	points[15] = (7609.1733, -16520.0781, 2191.5552);
	angles[15] = (0, 94.0511, 0);
	at[15] = 1.7500;
	points[16] = (7588.1494, -16520.1172, 2188.6418);
	angles[16] = (0, 87.0912, 0);
	at[16] = 1.8000;
	points[17] = (7523.3857, -16513.0723, 2174.5354);
	angles[17] = (0, 82.0062, 0);
	at[17] = 1.9500;
	points[18] = (7373.3467, -16489.6465, 2140.9172);
	angles[18] = (0, 81.3475, 0);
	at[18] = 2.3000;
	points[19] = (7307.7954, -16480.9844, 2132.2717);
	angles[19] = (0, 84.5028, 0);
	at[19] = 2.4500;
	points[20] = (7287.6772, -16479.4102, 2132.4448);
	angles[20] = (0, 86.0540, 0);
	at[20] = 2.5000;
	points[21] = (7221.1812, -16475.4336, 2140.0789);
	angles[21] = (0, 86.8902, 0);
	at[21] = 2.6500;
	points[22] = (6957.6772, -16464.3711, 2181.9448);
	angles[22] = (0, 88.4091, 0);
	at[22] = 3.2500;
	points[23] = (6869.0947, -16462.8750, 2190.8503);
	angles[23] = (0, 89.9955, 0);
	at[23] = 3.4500;
	points[24] = (6849.3701, -16463.0312, 2191.0552);
	angles[24] = (0, 91.0259, 0);
	at[24] = 3.5000;
	points[25] = (6716.4961, -16468.4258, 2180.0906);
	angles[25] = (0, 92.8740, 0);
	at[25] = 3.8000;
	points[26] = (6340.9844, -16488.3848, 2136.6890);
	angles[26] = (0, 92.6672, 0);
	at[26] = 4.6500;
	points[27] = (6296.5747, -16490.2363, 2132.9922);
	angles[27] = (0, 91.9939, 0);
	at[27] = 4.7500;
	points[28] = (6254.1733, -16490.9453, 2132.9331);
	angles[28] = (0, 89.9464, 0);
	at[28] = 4.8500;
	points[29] = (6210.3154, -16490.3555, 2139.7874);
	angles[29] = (0, 88.5857, 0);
	at[29] = 4.9500;
	points[30] = (6167.2837, -16488.8984, 2150.4448);
	angles[30] = (0, 87.4551, 0);
	at[30] = 5.0500;
	points[31] = (6060.9448, -16481.1816, 2181.7244);
	angles[31] = (0, 83.8184, 0);
	at[31] = 5.3000;
	points[32] = (6017.8345, -16475.3145, 2190.5708);
	angles[32] = (0, 79.9468, 0);
	at[32] = 5.4000;
	points[33] = (5976.4570, -16464.4492, 2187.6299);
	angles[33] = (0, 72.0637, 0);
	at[33] = 5.5000;
	points[34] = (5914.6851, -16442.6777, 2174.0513);
	angles[34] = (0, 69.6714, 0);
	at[34] = 5.6500;
	points[35] = (5772.9526, -16389.4883, 2138.6497);
	angles[35] = (0, 70.2706, 0);
	at[35] = 6;
	points[36] = (5731.0234, -16375.7480, 2132.1143);
	angles[36] = (0, 75.3309, 0);
	at[36] = 6.1000;
	points[37] = (5688.6221, -16369.0166, 2138.7756);
	angles[37] = (0, 84.1508, 0);
	at[37] = 6.2000;
	points[38] = (5604.4883, -16363.2686, 2166.5513);
	angles[38] = (0, 86.9061, 0);
	at[38] = 6.4000;
	points[39] = (5541.8110, -16358.8975, 2188.2756);
	angles[39] = (0, 83.4233, 0);
	at[39] = 6.5500;
	points[40] = (5520.7871, -16354.8428, 2192.3425);
	angles[40] = (0, 73.8673, 0);
	at[40] = 6.6000;
	points[41] = (5499.8428, -16347.7168, 2193.5630);
	angles[41] = (0, 69.3732, 0);
	at[41] = 6.6500;
	points[42] = (5458.5825, -16331.1816, 2193.3779);
	angles[42] = (0, 67.8669, 0);
	at[42] = 6.7500;
	points[43] = (5417.0474, -16315.3154, 2191.9646);
	angles[43] = (0, 71.3193, 0);
	at[43] = 6.8500;
	points[44] = (5395.9453, -16309.2129, 2191.2954);
	angles[44] = (0, 77.3242, 0);
	at[44] = 6.9000;
	points[45] = (5374.4092, -16307.2451, 2191.1260);
	angles[45] = (0, 92.6436, 0);
	at[45] = 6.9500;
	points[46] = (5330.1577, -16312.7158, 2191.1260);
	angles[46] = (0, 99.1187, 0);
	at[46] = 7.0500;
	points[47] = (5220.3545, -16329.5674, 2191.1260);
	angles[47] = (0, 95.7378, 0);
	at[47] = 7.3000;
	points[48] = (5198.1890, -16331.1025, 2191.1260);
	angles[48] = (0, 91.8843, 0);
	at[48] = 7.3500;
	points[49] = (5176.3389, -16330.3535, 2191.1260);
	angles[49] = (0, 82.5247, 0);
	at[49] = 7.4000;
	points[50] = (5155.0396, -16326.0635, 2191.1260);
	angles[50] = (0, 76.1649, 0);
	at[50] = 7.4500;
	points[51] = (5112.3623, -16313.9766, 2191.1260);
	angles[51] = (0, 72.8972, 0);
	at[51] = 7.5500;
	points[52] = (4901.6533, -16243.1113, 2191.1260);
	angles[52] = (0, 71.9919, 0);
	at[52] = 8.0500;
	points[53] = (4901.6533, -16243.1113, 2191.1260);
	angles[53] = (0, 71.9919, 0);
	at[53] = 8.0667;
	points[54] = (8293.5439, -16365.9854, 2191.1260);
	angles[54] = (0, 77.1855, 0);
	at[54] = 8.0667;
	points[55] = (8293.5439, -16365.9854, 2191.1260);
	angles[55] = (0, 77.1855, 0);
	at[55] = 8.0833;
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
	points[0] = (5033.0312, -17294.4102, 2275.8425);
	angles[0] = (0, -86.4286, 0);
	at[0] = 0;
	points[1] = (5276.3784, -17281.1035, 2282.4055);
	angles[1] = (0, -86.4410, 0);
	at[1] = 0.5500;
	points[2] = (5342.9136, -17276.4570, 2280.7048);
	angles[2] = (0, -85.4267, 0);
	at[2] = 0.7000;
	points[3] = (5386.4565, -17272.4414, 2276.1575);
	angles[3] = (0, -83.7473, 0);
	at[3] = 0.8000;
	points[4] = (5448.7012, -17263.2285, 2259.6851);
	angles[4] = (0, -80.5314, 0);
	at[4] = 0.9500;
	points[5] = (5761.2993, -17210.6309, 2155.3464);
	angles[5] = (0, -81.8695, 0);
	at[5] = 1.7000;
	points[6] = (5847.0083, -17200.3945, 2133.5237);
	angles[6] = (0, -85.1642, 0);
	at[6] = 1.9000;
	points[7] = (5890.3936, -17198.4258, 2128.2205);
	angles[7] = (0, -90.8272, 0);
	at[7] = 2;
	points[8] = (5933.3857, -17201.8105, 2133.1772);
	angles[8] = (0, -96.8706, 0);
	at[8] = 2.1000;
	points[9] = (5996.6929, -17211.2988, 2149.3818);
	angles[9] = (0, -99.6899, 0);
	at[9] = 2.2500;
	points[10] = (6307.2837, -17275, 2254.2048);
	angles[10] = (0, -102.1613, 0);
	at[10] = 3;
	points[11] = (6369.4487, -17288.1113, 2270.8347);
	angles[11] = (0, -101.4729, 0);
	at[11] = 3.1500;
	points[12] = (6392.3232, -17292.6387, 2274.7834);
	angles[12] = (0, -100.7073, 0);
	at[12] = 3.2000;
	points[13] = (6411.8896, -17296.1816, 2275.8623);
	angles[13] = (0, -100.2861, 0);
	at[13] = 3.2500;
	points[14] = (6454.7642, -17304.6055, 2269.9565);
	angles[14] = (0, -101.6549, 0);
	at[14] = 3.3500;
	points[15] = (6496.8896, -17313.4258, 2258.7600);
	angles[15] = (0, -101.9365, 0);
	at[15] = 3.4500;
	points[16] = (6641.4175, -17342.4805, 2208.8740);
	angles[16] = (0, -100.2958, 0);
	at[16] = 3.8000;
	points[17] = (6724.8032, -17356.0234, 2181.6221);
	angles[17] = (0, -97.9105, 0);
	at[17] = 4;
	points[18] = (6789.1738, -17363.3457, 2165.4805);
	angles[18] = (0, -94.8616, 0);
	at[18] = 4.1500;
	points[19] = (6854.7246, -17366.1426, 2157.7598);
	angles[19] = (0, -89.4331, 0);
	at[19] = 4.3000;
	points[20] = (6895.7090, -17364.2910, 2159.2598);
	angles[20] = (0, -86.1393, 0);
	at[20] = 4.4000;
	points[21] = (6920.0396, -17362.4805, 2161.1104);
	angles[21] = (0, -85.4077, 0);
	at[21] = 4.4500;
	points[22] = (7050.2754, -17350, 2174.8584);
	angles[22] = (0, -83.9809, 0);
	at[22] = 4.7500;
	points[23] = (7621.4961, -17285.5898, 2252.5000);
	angles[23] = (0, -83.9255, 0);
	at[23] = 6.0500;
	points[24] = (7663.3467, -17281.2207, 2258.3857);
	angles[24] = (0, -84.2027, 0);
	at[24] = 6.1500;
	points[25] = (7709.6455, -17276.7324, 2264.8032);
	angles[25] = (0, -84.7183, 0);
	at[25] = 6.2500;
	points[26] = (7751.5747, -17273.1504, 2270.4448);
	angles[26] = (0, -85.6745, 0);
	at[26] = 6.3500;
	points[27] = (7776.1421, -17271.5352, 2273.5708);
	angles[27] = (0, -86.9347, 0);
	at[27] = 6.4000;
	points[28] = (7816.6934, -17271.7324, 2277.8149);
	angles[28] = (0, -95.2960, 0);
	at[28] = 6.5000;
	points[29] = (7859.6064, -17280.7090, 2280.5276);
	angles[29] = (0, -108.5214, 0);
	at[29] = 6.6000;
	points[30] = (7899.6460, -17299.3691, 2280.9961);
	angles[30] = (0, -120.8975, 0);
	at[30] = 6.7000;
	points[31] = (7935.9448, -17324.7246, 2279.4370);
	angles[31] = (0, -127.5844, 0);
	at[31] = 6.8000;
	points[32] = (7953.4648, -17338.1504, 2278.1694);
	angles[32] = (0, -126.6754, 0);
	at[32] = 6.8500;
	points[33] = (7971.8110, -17350.5117, 2276.8308);
	angles[33] = (0, -119.9303, 0);
	at[33] = 6.9000;
	points[34] = (7992.2446, -17358.7793, 2275.9133);
	angles[34] = (0, -101.7487, 0);
	at[34] = 6.9500;
	points[35] = (8013.8584, -17359.4492, 2275.8425);
	angles[35] = (0, -86.0485, 0);
	at[35] = 7;
	points[36] = (8057.6768, -17353.5430, 2275.8464);
	angles[36] = (0, -80.0343, 0);
	at[36] = 7.1000;
	points[37] = (8274.8027, -17305.2363, 2275.8425);
	angles[37] = (0, -77.7077, 0);
	at[37] = 7.6000;
	points[38] = (8282.2051, -17303.6621, 2275.8425);
	angles[38] = (0, -78.0529, 0);
	at[38] = 7.6333;
	points[39] = (5033.0312, -17294.4102, 2275.8425);
	angles[39] = (0, -86.4286, 0);
	at[39] = 7.6333;
	points[40] = (5033.0312, -17294.4102, 2275.8425);
	angles[40] = (0, -86.4286, 0);
	at[40] = 7.6500;
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
	points[0] = (1018.4134, -15100.7090, 2086.5906);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1018.4134, -15100.7090, 2086.5906);
	angles[1] = (0, 0, 0);
	at[1] = 1.1000;
	points[2] = (1018.4134, -15100.7090, 2094.2639);
	angles[2] = (0, 0, 0);
	at[2] = 1.2000;
	points[3] = (1018.4134, -15100.7090, 2082.1616);
	angles[3] = (0, 0, 0);
	at[3] = 1.2500;
	points[4] = (1018.4134, -15100.7090, 2078.9175);
	angles[4] = (0, 0, 0);
	at[4] = 1.3000;
	points[5] = (1018.4134, -15100.7090, 2091.0198);
	angles[5] = (0, 0, 0);
	at[5] = 1.3500;
	points[6] = (1018.4134, -15100.7090, 2094.2639);
	angles[6] = (0, 0, 0);
	at[6] = 1.4000;
	points[7] = (1018.4134, -15100.7090, 2082.1616);
	angles[7] = (0, 0, 0);
	at[7] = 1.4500;
	points[8] = (1018.4134, -15100.7090, 2078.9175);
	angles[8] = (0, 0, 0);
	at[8] = 1.5000;
	points[9] = (1018.4134, -15100.7090, 2091.0198);
	angles[9] = (0, 0, 0);
	at[9] = 1.5500;
	points[10] = (1018.4134, -15100.7090, 2094.2639);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (1018.4134, -15100.7090, 2082.1616);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (1018.4134, -15100.7090, 2215.0356);
	angles[12] = (0, 0, 0);
	at[12] = 1.8000;
	points[13] = (1018.4134, -15100.7090, 2214.7402);
	angles[13] = (0, 0, 0);
	at[13] = 1.8500;
	points[14] = (1018.4134, -15100.7090, 2154.5039);
	angles[14] = (0, 0, 0);
	at[14] = 1.9000;
	points[15] = (1018.4134, -15100.7090, 2049.0906);
	angles[15] = (0, 0, 0);
	at[15] = 1.9500;
	points[16] = (1018.4134, -15100.7090, 1898.5000);
	angles[16] = (0, 0, 0);
	at[16] = 2;
	points[17] = (1018.4134, -15100.7090, 1732.2559);
	angles[17] = (0, 0, 0);
	at[17] = 2.0500;
	points[18] = (1018.4134, -15100.7090, 1732.2559);
	angles[18] = (0, 0, 0);
	at[18] = 3.0500;
	points[19] = (1018.4134, -15100.7090, 2086.5867);
	angles[19] = (0, 0, 0);
	at[19] = 5.0500;
	points[20] = (1018.4134, -15100.7090, 2086.5906);
	angles[20] = (0, 0, 0);
	at[20] = 5.4167;
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
	points[0] = (1923.1693, -14052.5986, 1944.8583);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1923.1693, -14052.5986, 1944.8583);
	angles[1] = (0, 0, 0);
	at[1] = 1.1000;
	points[2] = (1923.1693, -14052.5986, 1952.5315);
	angles[2] = (0, 0, 0);
	at[2] = 1.2000;
	points[3] = (1923.1693, -14052.5986, 1940.4292);
	angles[3] = (0, 0, 0);
	at[3] = 1.2500;
	points[4] = (1923.1693, -14052.5986, 1937.1849);
	angles[4] = (0, 0, 0);
	at[4] = 1.3000;
	points[5] = (1923.1693, -14052.5986, 1949.2875);
	angles[5] = (0, 0, 0);
	at[5] = 1.3500;
	points[6] = (1923.1693, -14052.5986, 1952.5315);
	angles[6] = (0, 0, 0);
	at[6] = 1.4000;
	points[7] = (1923.1693, -14052.5986, 1940.4292);
	angles[7] = (0, 0, 0);
	at[7] = 1.4500;
	points[8] = (1923.1693, -14052.5986, 1937.1849);
	angles[8] = (0, 0, 0);
	at[8] = 1.5000;
	points[9] = (1923.1693, -14052.5986, 1949.2875);
	angles[9] = (0, 0, 0);
	at[9] = 1.5500;
	points[10] = (1923.1693, -14052.5986, 1952.5315);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (1923.1693, -14052.5986, 1940.4292);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (1923.1693, -14052.5986, 2073.3032);
	angles[12] = (0, 0, 0);
	at[12] = 1.8000;
	points[13] = (1923.1693, -14052.5986, 2073.0078);
	angles[13] = (0, 0, 0);
	at[13] = 1.8500;
	points[14] = (1923.1693, -14052.5986, 2012.7717);
	angles[14] = (0, 0, 0);
	at[14] = 1.9000;
	points[15] = (1923.1693, -14052.5986, 1907.3583);
	angles[15] = (0, 0, 0);
	at[15] = 1.9500;
	points[16] = (1923.1693, -14052.5986, 1756.7677);
	angles[16] = (0, 0, 0);
	at[16] = 2;
	points[17] = (1923.1693, -14052.5986, 1650.3584);
	angles[17] = (0, 0, 0);
	at[17] = 2.0500;
	points[18] = (1923.1693, -14052.5986, 1650.3584);
	angles[18] = (0, 0, 0);
	at[18] = 3;
	points[19] = (1923.1693, -14052.5986, 1653.3110);
	angles[19] = (0, 0, 0);
	at[19] = 3.0500;
	points[20] = (1923.1693, -14052.5986, 1944.8583);
	angles[20] = (0, 0, 0);
	at[20] = 4.7000;
	points[21] = (1923.1693, -14052.5986, 1944.8583);
	angles[21] = (0, 0, 0);
	at[21] = 5.0500;
	mover = getEnt("iz_obj_4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6894.8037, -1840.2323, 628.0709);
	angles[0] = (0, -115.9756, 0);
	at[0] = 0;
	points[1] = (6943.0713, -1915.0592, 628.0709);
	angles[1] = (0, -131.8132, 0);
	at[1] = 0.0500;
	points[2] = (6989.3311, -1990.8505, 628.0709);
	angles[2] = (0, -139.3102, 0);
	at[2] = 0.1000;
	points[3] = (7051.9292, -2052.2441, 628.0709);
	angles[3] = (0, -133.7879, 0);
	at[3] = 0.1500;
	points[4] = (7137.0078, -2061.1733, 628.0709);
	angles[4] = (0, -112.9982, 0);
	at[4] = 0.2000;
	points[5] = (7225.2363, -2051.2678, 628.0709);
	angles[5] = (0, -98.5084, 0);
	at[5] = 0.2500;
	points[6] = (7313.5435, -2038.2992, 628.0709);
	angles[6] = (0, -90.2004, 0);
	at[6] = 0.3000;
	points[7] = (7489.6855, -2009.7756, 628.0709);
	angles[7] = (0, -83.2177, 0);
	at[7] = 0.4000;
	points[8] = (7665.4727, -1982.1299, 628.0709);
	angles[8] = (0, -81.7924, 0);
	at[8] = 0.5000;
	points[9] = (7754.0552, -1970.5118, 628.0709);
	angles[9] = (0, -82.3579, 0);
	at[9] = 0.5500;
	points[10] = (7842.9136, -1964.4331, 628.0709);
	angles[10] = (0, -85.0266, 0);
	at[10] = 0.6000;
	points[11] = (7927.3623, -1975.1536, 628.0709);
	angles[11] = (0, -91.8255, 0);
	at[11] = 0.6500;
	points[12] = (8014.7246, -1994.9410, 628.0709);
	angles[12] = (0, -97.5011, 0);
	at[12] = 0.7000;
	points[13] = (8100.1968, -2018.6851, 628.0709);
	angles[13] = (0, -101.6505, 0);
	at[13] = 0.7500;
	points[14] = (8268.1885, -2076.5354, 628.0709);
	angles[14] = (0, -107.8133, 0);
	at[14] = 0.8500;
	points[15] = (8349.7246, -2113.4016, 628.0709);
	angles[15] = (0, -111.6766, 0);
	at[15] = 0.9000;
	points[16] = (8413.8975, -2169.3740, 628.0709);
	angles[16] = (0, -124.8947, 0);
	at[16] = 0.9500;
	points[17] = (8441.3389, -2253.6143, 628.0709);
	angles[17] = (0, -143.8489, 0);
	at[17] = 1;
	points[18] = (8456.2988, -2341.0789, 628.0709);
	angles[18] = (0, -157.1690, 0);
	at[18] = 1.0500;
	points[19] = (8464.0947, -2429.5276, 628.0709);
	angles[19] = (0, -166.2859, 0);
	at[19] = 1.1000;
	points[20] = (8464.0947, -2518.7087, 628.0709);
	angles[20] = (0, -173.6680, 0);
	at[20] = 1.1500;
	points[21] = (8441.7715, -2601.1262, 628.0709);
	angles[21] = (0, -188.9595, 0);
	at[21] = 1.2000;
	points[22] = (8364.2920, -2644.9724, 628.0709);
	angles[22] = (0, -214.9043, 0);
	at[22] = 1.2500;
	points[23] = (8280.6689, -2674.2007, 628.0709);
	angles[23] = (0, -232.5209, 0);
	at[23] = 1.3000;
	points[24] = (8195.3545, -2698.9766, 628.0709);
	angles[24] = (0, -243.0307, 0);
	at[24] = 1.3500;
	points[25] = (8109.3701, -2722.0278, 628.0709);
	angles[25] = (0, -248.8935, 0);
	at[25] = 1.4000;
	points[26] = (8026.7324, -2744.8821, 627.7047);
	angles[26] = (0, -251.5350, -0.5273);
	at[26] = 1.4500;
	points[27] = (7769.7246, -2814.9214, 598.7598);
	angles[27] = (0, -254.5009, -5.5997);
	at[27] = 1.6000;
	points[28] = (7598.6616, -2859.2087, 585.0433);
	angles[28] = (0, -255.3128, -4.2232);
	at[28] = 1.7000;
	points[29] = (7512.4805, -2880.7048, 583.5630);
	angles[29] = (0, -255.6903, -2.2832);
	at[29] = 1.7500;
	points[30] = (7426.2598, -2901.4172, 588.2244);
	angles[30] = (0, -256.1465, 0.8502);
	at[30] = 1.8000;
	points[31] = (7341.3779, -2920.5789, 603);
	angles[31] = (0, -256.8097, 6.1268);
	at[31] = 1.8500;
	points[32] = (7264.5273, -2935.6970, 635.1102);
	angles[32] = (0, -258.0887, 16.0935);
	at[32] = 1.9000;
	points[33] = (7194.3306, -2945.1812, 690.1142);
	angles[33] = (0, -260.1190, 27.4144);
	at[33] = 1.9500;
	points[34] = (7129.0552, -2952.2166, 750.5355);
	angles[34] = (0, -261.8243, 35.0743);
	at[34] = 2;
	points[35] = (7067.0864, -2958.2400, 811.6929);
	angles[35] = (0, -263.0477, 39.8023);
	at[35] = 2.0500;
	points[36] = (7003.1890, -2964.1340, 876.9449);
	angles[36] = (0, -263.8445, 42.6509);
	at[36] = 2.1000;
	points[37] = (6943.1104, -2969.5671, 939.5315);
	angles[37] = (0, -264.3161, 44.3505);
	at[37] = 2.1500;
	points[38] = (6574.6060, -3006.2834, 1325.8976);
	angles[38] = (0, -263.7736, 45.7919);
	at[38] = 2.4500;
	points[39] = (6513.2285, -3013.9172, 1387.5945);
	angles[39] = (0, -263.2748, 45.2814);
	at[39] = 2.5000;
	points[40] = (6448.2676, -3022.9253, 1450.7795);
	angles[40] = (0, -262.5921, 44.4870);
	at[40] = 2.5500;
	points[41] = (6385.3149, -3032.9055, 1508.9724);
	angles[41] = (0, -261.6461, 43.2707);
	at[41] = 2.6000;
	points[42] = (6316.5356, -3045.9448, 1567.3662);
	angles[42] = (0, -260.1794, 41.1810);
	at[42] = 2.6500;
	points[43] = (6244.2124, -3063.8977, 1618.0433);
	angles[43] = (0, -257.5173, 36.8343);
	at[43] = 2.7000;
	points[44] = (6173.3462, -3089.8306, 1644.8818);
	angles[44] = (0, -252.9136, 26.8612);
	at[44] = 2.7500;
	points[45] = (6092.2441, -3125.0039, 1656.3031);
	angles[45] = (0, -249.4363, 16.6570);
	at[45] = 2.8000;
	points[46] = (6010.4727, -3163.0234, 1659.4645);
	angles[46] = (0, -247.1370, 9.1406);
	at[46] = 2.8500;
	points[47] = (5851.7324, -3241.6536, 1652.9448);
	angles[47] = (0, -244.3364, 0.2805);
	at[47] = 2.9500;
	points[48] = (5772.3232, -3283.0159, 1645.4252);
	angles[48] = (0, -243.3535, -2.3518);
	at[48] = 3;
	points[49] = (5617.7168, -3367.6182, 1624.4409);
	angles[49] = (0, -241.6254, -5.9632);
	at[49] = 3.1000;
	points[50] = (5466.2202, -3456.9802, 1596.0551);
	angles[50] = (0, -239.7313, -8.6608);
	at[50] = 3.2000;
	points[51] = (5393.4253, -3503.1853, 1579.2323);
	angles[51] = (0, -238.5285, -9.9715);
	at[51] = 3.2500;
	points[52] = (5320.3936, -3552.8467, 1559.5511);
	angles[52] = (0, -236.9567, -11.4262);
	at[52] = 3.3000;
	points[53] = (5251.6533, -3604.5669, 1537.1849);
	angles[53] = (0, -234.7004, -13.2221);
	at[53] = 3.3500;
	points[54] = (5189.3311, -3660.3782, 1510.4803);
	angles[54] = (0, -230.7764, -15.9066);
	at[54] = 3.4000;
	points[55] = (5145.2759, -3721.9409, 1476.3071);
	angles[55] = (0, -221.0397, -21.6033);
	at[55] = 3.4500;
	points[56] = (5130.9453, -3794.3308, 1425.8899);
	angles[56] = (0, -206.1520, -29.2517);
	at[56] = 3.5000;
	points[57] = (5130.1973, -3866.2207, 1371.4489);
	angles[57] = (0, -193.8224, -33.9134);
	at[57] = 3.5500;
	points[58] = (5134.9604, -3934.3467, 1318.1141);
	angles[58] = (0, -185.0740, -36.3049);
	at[58] = 3.6000;
	points[59] = (5143.1890, -4005.1970, 1261.6141);
	angles[59] = (0, -179.2325, -37.5013);
	at[59] = 3.6500;
	points[60] = (5153.1494, -4072.9136, 1207.0039);
	angles[60] = (0, -175.4218, -38.1127);
	at[60] = 3.7000;
	points[61] = (5190.1182, -4278.3857, 1039.4685);
	angles[61] = (0, -170.2298, -38.6941);
	at[61] = 3.8500;
	points[62] = (5253.9766, -4620.7871, 762.0040);
	angles[62] = (0, -170.2278, -38.3225);
	at[62] = 4.1000;
	points[63] = (5263.0713, -4691.8110, 706.7007);
	angles[63] = (0, -171.7402, -37.9478);
	at[63] = 4.1500;
	points[64] = (5266.4175, -4763.1499, 653.9330);
	angles[64] = (0, -175.3388, -37.0340);
	at[64] = 4.2000;
	points[65] = (5247.8745, -4832.5986, 613.4213);
	angles[65] = (0, -188.5682, -32.2590);
	at[65] = 4.2500;
	points[66] = (5194.0156, -4900.6694, 594.6063);
	angles[66] = (0, -205.5590, -22.1858);
	at[66] = 4.3000;
	points[67] = (5127.9131, -4959.0156, 590.0236);
	angles[67] = (0, -217.7889, -12.6039);
	at[67] = 4.3500;
	points[68] = (5056.1812, -5011.3779, 592.4488);
	angles[68] = (0, -226.1084, -5.4602);
	at[68] = 4.4000;
	points[69] = (4981.4175, -5059.2524, 598.8386);
	angles[69] = (0, -231.9041, -0.6114);
	at[69] = 4.4500;
	points[70] = (4904.5669, -5103.4253, 607.4725);
	angles[70] = (0, -236.1531, 2.5031);
	at[70] = 4.5000;
	points[71] = (4825.9844, -5144.1338, 617);
	angles[71] = (0, -239.5575, 4.2889);
	at[71] = 4.5500;
	points[72] = (4746.3779, -5180.4727, 625.4843);
	angles[72] = (0, -242.8203, 4.7084);
	at[72] = 4.6000;
	points[73] = (4665.0786, -5207.9136, 628.0748);
	angles[73] = (0, -248.0903, 2.7710);
	at[73] = 4.6500;
	points[74] = (4575.7876, -5224.0947, 628.1024);
	angles[74] = (0, -254.2132, 1.4393);
	at[74] = 4.7000;
	points[75] = (4399.6851, -5243.5435, 628.1654);
	angles[75] = (0, -261.6790, 0.3945);
	at[75] = 4.8000;
	points[76] = (4222.5591, -5253.7007, 628.2087);
	angles[76] = (0, -265.7928, 0.1118);
	at[76] = 4.9000;
	points[77] = (4133.7007, -5255.1182, 628.2087);
	angles[77] = (0, -267.6105, 0.0562);
	at[77] = 4.9500;
	points[78] = (4045.4331, -5252.7954, 628.1851);
	angles[78] = (0, -269.8759, 0.0177);
	at[78] = 5;
	points[79] = (3955.1968, -5241.8506, 628.0866);
	angles[79] = (0, -274.4854, -0.0313);
	at[79] = 5.0500;
	points[80] = (3881.2205, -5201.9688, 627.6929);
	angles[80] = (0, -288.3489, -0.1734);
	at[80] = 5.1000;
	points[81] = (3815.7913, -5140.6694, 627.0670);
	angles[81] = (0, -301.1255, -0.2970);
	at[81] = 5.1500;
	points[82] = (3757.8623, -5073.5830, 626.3976);
	angles[82] = (0, -310.3984, -0.3687);
	at[82] = 5.2000;
	points[83] = (3705.3347, -5001.7715, 625.7244);
	angles[83] = (0, -317.4122, -0.4033);
	at[83] = 5.2500;
	points[84] = (3659.4331, -4925.7876, 625.0748);
	angles[84] = (0, -323.6219, -0.4103);
	at[84] = 5.3000;
	points[85] = (3624.0393, -4844.1338, 624.5000);
	angles[85] = (0, -331.1064, -0.3842);
	at[85] = 5.3500;
	points[86] = (3617.9133, -4759.9604, 624.2283);
	angles[86] = (0, -347.2559, -0.2551);
	at[86] = 5.4000;
	points[87] = (3661.7598, -4683.9766, 624.4606);
	angles[87] = (0, -368.8878, -0.0542);
	at[87] = 5.4500;
	points[88] = (3715.9724, -4612.9136, 624.7914);
	angles[88] = (0, -382.9687, 0.0802);
	at[88] = 5.5000;
	points[89] = (3773.1340, -4544.0552, 625.1536);
	angles[89] = (0, -391.2559, 0.1574);
	at[89] = 5.5500;
	points[90] = (3950, -4343.3071, 626.3149);
	angles[90] = (0, -400.2496, 0.2397);
	at[90] = 5.7000;
	points[91] = (4125.5513, -4144.1338, 627.5118);
	angles[91] = (0, -400.8542, 0.2562);
	at[91] = 5.8500;
	points[92] = (4181.7720, -4072.9922, 627.9173);
	angles[92] = (0, -399.0112, 0.2546);
	at[92] = 5.9000;
	points[93] = (4201.0630, -3993.1497, 628.2087);
	angles[93] = (0, -380.7199, 0.2259);
	at[93] = 5.9500;
	points[94] = (4143.4648, -3926.7915, 628.2283);
	angles[94] = (0, -350.1888, 0.1402);
	at[94] = 6;
	points[95] = (4073.6221, -3871.6851, 628.1496);
	angles[95] = (0, -330.4694, 0.0497);
	at[95] = 6.0500;
	points[96] = (4023.5825, -3800.9448, 628.0709);
	angles[96] = (0, -333.1867, 0.0077);
	at[96] = 6.1000;
	points[97] = (4044.3701, -3715.8542, 628.0709);
	angles[97] = (0, -353.9895, 0.0043);
	at[97] = 6.1500;
	points[98] = (4075.6301, -3633.0120, 628.0709);
	angles[98] = (0, -367.0926, 0.0023);
	at[98] = 6.2000;
	points[99] = (4108.7793, -3550.4841, 628.0709);
	angles[99] = (0, -374.3304, 0.0012);
	at[99] = 6.2500;
	points[100] = (4174.1733, -3384.5945, 628.0709);
	angles[100] = (0, -379.3635, 0);
	at[100] = 6.3500;
	points[101] = (4202.8740, -3300.9568, 628.0709);
	angles[101] = (0, -378.7682, 0);
	at[101] = 6.4000;
	points[102] = (4220, -3213.2009, 628.0709);
	angles[102] = (0, -372.5518, 0);
	at[102] = 6.4500;
	points[103] = (4171.8110, -3144.4568, 628.0709);
	angles[103] = (0, -346.4787, 0);
	at[103] = 6.5000;
	points[104] = (4098.1104, -3094.2798, 628.0709);
	angles[104] = (0, -325.7486, 0);
	at[104] = 6.5500;
	points[105] = (4022.0078, -3048.7048, 628.0709);
	angles[105] = (0, -313.7078, 0);
	at[105] = 6.6000;
	points[106] = (3946.8503, -3000.9607, 628.0709);
	angles[106] = (0, -308.6567, 0);
	at[106] = 6.6500;
	points[107] = (3879.2207, -2944.1143, 628.0709);
	angles[107] = (0, -310.9029, 0);
	at[107] = 6.7000;
	points[108] = (3834.8464, -2868.7639, 628.0709);
	angles[108] = (0, -321.2410, 0);
	at[108] = 6.7500;
	points[109] = (3796.9292, -2789.4922, 628.0709);
	angles[109] = (0, -327.8223, 0);
	at[109] = 6.8000;
	points[110] = (3726.2954, -2625.7834, 628.0709);
	angles[110] = (0, -334.7699, 0);
	at[110] = 6.9000;
	points[111] = (3666.4133, -2458.6104, 628.0709);
	angles[111] = (0, -339.4941, 0);
	at[111] = 7;
	points[112] = (3642.5945, -2372.6338, 628.0709);
	angles[112] = (0, -342.3563, 0);
	at[112] = 7.0500;
	points[113] = (3626.2441, -2285.0669, 628.0709);
	angles[113] = (0, -346.5063, 0);
	at[113] = 7.1000;
	points[114] = (3624.6104, -2197.0669, 628.0709);
	angles[114] = (0, -354.1653, 0);
	at[114] = 7.1500;
	points[115] = (3658.0789, -2122.1064, 628.0709);
	angles[115] = (0, -372.8145, 0);
	at[115] = 7.2000;
	points[116] = (3729.0552, -2068.3347, 628.0709);
	angles[116] = (0, -393.0078, 0);
	at[116] = 7.2500;
	points[117] = (3807.6338, -2021.8937, 628.0709);
	angles[117] = (0, -406.1240, 0);
	at[117] = 7.3000;
	points[118] = (3964.6458, -1940.8544, 628.0709);
	angles[118] = (0, -418.7089, 0);
	at[118] = 7.4000;
	points[119] = (4288.1890, -1791.2677, 628.0709);
	angles[119] = (0, -425.1567, 0);
	at[119] = 7.6000;
	points[120] = (4694.3306, -1612.6851, 628.0709);
	angles[120] = (0, -426.1837, 0);
	at[120] = 7.8500;
	points[121] = (4858.1499, -1536.6182, 628.0709);
	angles[121] = (0, -424.9214, 0);
	at[121] = 7.9500;
	points[122] = (4930.3940, -1495.3464, 628.0709);
	angles[122] = (0, -422.1794, 0);
	at[122] = 8;
	points[123] = (5004.7246, -1446.3267, 628.0709);
	angles[123] = (0, -419.2245, 0);
	at[123] = 8.0500;
	points[124] = (5294.1338, -1240.2520, 628.0709);
	angles[124] = (0, -414.9371, 0);
	at[124] = 8.2500;
	points[125] = (5443.2280, -1143.0906, 628.0709);
	angles[125] = (0, -417.0636, 0);
	at[125] = 8.3500;
	points[126] = (5521.6138, -1102.2086, 628.0709);
	angles[126] = (0, -420.4455, 0);
	at[126] = 8.4000;
	points[127] = (5603.1890, -1080.4213, 628.0709);
	angles[127] = (0, -430.0493, 0);
	at[127] = 8.4500;
	points[128] = (5692.1650, -1086.8347, 628.0709);
	angles[128] = (0, -442.6796, 0);
	at[128] = 8.5000;
	points[129] = (5779.9214, -1102.7126, 628.0709);
	angles[129] = (0, -451.5983, 0);
	at[129] = 8.5500;
	points[130] = (5952.8740, -1145.8859, 628.0709);
	angles[130] = (0, -461.2568, 0);
	at[130] = 8.6500;
	points[131] = (6122.8740, -1198.0748, 628.0709);
	angles[131] = (0, -465.9114, 0);
	at[131] = 8.7500;
	points[132] = (6206.2993, -1227.0039, 628.0709);
	angles[132] = (0, -467.6473, 0);
	at[132] = 8.8000;
	points[133] = (6289.4883, -1258.8898, 628.0709);
	angles[133] = (0, -469.5378, 0);
	at[133] = 8.8500;
	points[134] = (6371.9688, -1297.3898, 628.0709);
	angles[134] = (0, -473.1690, 0);
	at[134] = 8.9000;
	points[135] = (6415.5903, -1367.0826, 628.0709);
	angles[135] = (0, -494.2835, 0);
	at[135] = 8.9500;
	points[136] = (6417.4805, -1455.6654, 628.0709);
	angles[136] = (0, -516.5143, 0);
	at[136] = 9;
	points[137] = (6408.8188, -1543.9883, 628.0709);
	angles[137] = (0, -530.7421, 0);
	at[137] = 9.0500;
	points[138] = (6401.8501, -1632.7166, 628.0709);
	angles[138] = (0, -536.7143, 0);
	at[138] = 9.1000;
	points[139] = (6434.5674, -1707.5789, 628.0709);
	angles[139] = (0, -520.2090, 0);
	at[139] = 9.1500;
	points[140] = (6518.9370, -1735.6812, 628.0709);
	angles[140] = (0, -494.9097, 0);
	at[140] = 9.2000;
	points[141] = (6605.3545, -1754.9330, 628.0709);
	angles[141] = (0, -479.1046, 0);
	at[141] = 9.2500;
	points[142] = (6692.5591, -1772.0826, 628.0709);
	angles[142] = (0, -470.3314, 0);
	at[142] = 9.3000;
	points[143] = (6780.2754, -1789.9764, 628.0709);
	angles[143] = (0, -466.2224, 0);
	at[143] = 9.3500;
	points[144] = (6848.3467, -1808.0789, 628.0709);
	angles[144] = (0, -466.4750, 0);
	at[144] = 9.4000;
	points[145] = (6894.8037, -1840.2323, 628.0709);
	angles[145] = (0, -475.9756, 0);
	at[145] = 9.4333;
	mover = getEnt("iz_obj_5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (7695.8267, -3908.6614, 613.9843);
	angles[0] = (0, 138.7237, 8.3983);
	at[0] = 0;
	points[1] = (7640.0396, -3974.2520, 653.6378);
	angles[1] = (0, 139.1575, 18.9076);
	at[1] = 0.0500;
	points[2] = (7591.2207, -4029.5276, 704.9370);
	angles[2] = (0, 138.8052, 27.1479);
	at[2] = 0.1000;
	points[3] = (7542.3228, -4083.6221, 762.0748);
	angles[3] = (0, 138.3483, 32.6914);
	at[3] = 0.1500;
	points[4] = (7497.9136, -4132.1260, 816.7677);
	angles[4] = (0, 137.9213, 36.2535);
	at[4] = 0.2000;
	points[5] = (7450.7480, -4183.0317, 876.6181);
	angles[5] = (0, 137.5518, 38.5449);
	at[5] = 0.2500;
	points[6] = (7360.3545, -4279.4097, 994.4489);
	angles[6] = (0, 136.9732, 41.0207);
	at[6] = 0.3500;
	points[7] = (7087.5591, -4561.9292, 1356.1810);
	angles[7] = (0, 135.6256, 42.6640);
	at[7] = 0.6500;
	points[8] = (6945.9053, -4701.8896, 1534.8071);
	angles[8] = (0, 134.5051, 41.6291);
	at[8] = 0.8000;
	points[9] = (6898.0317, -4746.9683, 1589.4843);
	angles[9] = (0, 133.7401, 40.4540);
	at[9] = 0.8500;
	points[10] = (6843.8979, -4794.1343, 1640.3229);
	angles[10] = (0, 131.7719, 36.6047);
	at[10] = 0.9000;
	points[11] = (6775, -4838.8188, 1672.1772);
	angles[11] = (0, 126.0472, 27.7219);
	at[11] = 0.9500;
	points[12] = (6695.5903, -4876.1416, 1684.1614);
	angles[12] = (0, 119.8259, 16.9377);
	at[12] = 1;
	points[13] = (6612.8740, -4907.1655, 1679.9607);
	angles[13] = (0, 114.9054, 6.4971);
	at[13] = 1.0500;
	points[14] = (6530.1572, -4934.2520, 1663.0236);
	angles[14] = (0, 111.4872, -2.7926);
	at[14] = 1.1000;
	points[15] = (6449.6855, -4959.3311, 1635.2440);
	angles[15] = (0, 109.5379, -11.0438);
	at[15] = 1.1500;
	points[16] = (6373.7793, -4984.5278, 1597.1615);
	angles[16] = (0, 109.2478, -18.8745);
	at[16] = 1.2000;
	points[17] = (6309.8428, -5011.0234, 1550.0197);
	angles[17] = (0, 111.3995, -27.7526);
	at[17] = 1.2500;
	points[18] = (6254.3306, -5040.7480, 1486.6733);
	angles[18] = (0, 114.5046, -36.8492);
	at[18] = 1.3000;
	points[19] = (6202.2046, -5070.4722, 1418.7953);
	angles[19] = (0, 116.8517, -42.7438);
	at[19] = 1.3500;
	points[20] = (6103.9370, -5127.5981, 1282.8188);
	angles[20] = (0, 119.2065, -48.3579);
	at[20] = 1.4500;
	points[21] = (5907.9526, -5237.5986, 1006.0433);
	angles[21] = (0, 118.7832, -50.7428);
	at[21] = 1.6500;
	points[22] = (5807.0869, -5288.7007, 869.1378);
	angles[22] = (0, 116.9970, -50.3974);
	at[22] = 1.7500;
	points[23] = (5753.6616, -5313.0317, 800.4095);
	angles[23] = (0, 115.5200, -49.8584);
	at[23] = 1.8000;
	points[24] = (5699.0947, -5334.8818, 734.7599);
	angles[24] = (0, 113.3162, -48.8705);
	at[24] = 1.8500;
	points[25] = (5641.0635, -5352.9526, 672.9133);
	angles[25] = (0, 109.4897, -46.7929);
	at[25] = 1.9000;
	points[26] = (5572.3232, -5360.3940, 621.8701);
	angles[26] = (0, 99.7175, -39.6829);
	at[26] = 1.9500;
	points[27] = (5488.9766, -5344.0161, 598.9567);
	angles[27] = (0, 87.3659, -26.8918);
	at[27] = 2;
	points[28] = (5404.0156, -5317.8745, 589.6772);
	angles[28] = (0, 79.5729, -16.3466);
	at[28] = 2.0500;
	points[29] = (5319.5674, -5287.5981, 586.6496);
	angles[29] = (0, 74.7678, -9.0790);
	at[29] = 2.1000;
	points[30] = (5236.9683, -5255.5122, 587.2520);
	angles[30] = (0, 71.7037, -4.2897);
	at[30] = 2.1500;
	points[31] = (4992.0474, -5151.6929, 600.7441);
	angles[31] = (0, 67.2971, 2.4223);
	at[31] = 2.3000;
	points[32] = (4748.4253, -5040.4727, 622.2283);
	angles[32] = (0, 65.4943, 4.3419);
	at[32] = 2.4500;
	points[33] = (4668.3862, -5002.7168, 627.8819);
	angles[33] = (0, 65.1090, 3.6560);
	at[33] = 2.5000;
	points[34] = (4593.4648, -4961.6538, 628.0709);
	angles[34] = (0, 62.3959, 1.8755);
	at[34] = 2.5500;
	points[35] = (4522.4409, -4908.5039, 628.0709);
	angles[35] = (0, 57.1713, 0.9657);
	at[35] = 2.6000;
	points[36] = (4391.2207, -4790.4727, 628.0709);
	angles[36] = (0, 51.1747, 0.2547);
	at[36] = 2.7000;
	points[37] = (4247.6772, -4686.0239, 628.0709);
	angles[37] = (0, 52.8759, 0.0668);
	at[37] = 2.8000;
	points[38] = (4179.8818, -4628.5830, 628.0709);
	angles[38] = (0, 50.7278, 0.0342);
	at[38] = 2.8500;
	points[39] = (4122.2441, -4561.3779, 628.0709);
	angles[39] = (0, 44.0638, 0.0177);
	at[39] = 2.9000;
	points[40] = (4103.8584, -4477.6377, 628.0709);
	angles[40] = (0, 25.8584, 0.0097);
	at[40] = 2.9500;
	points[41] = (4109.6851, -4389.7246, 628.0709);
	angles[41] = (0, 11.1287, 0.0052);
	at[41] = 3;
	points[42] = (4120, -4301.0630, 628.0709);
	angles[42] = (0, 2.3268, 0.0027);
	at[42] = 3.0500;
	points[43] = (4145.3936, -4124.4883, 628.0709);
	angles[43] = (0, -5.5956, 0);
	at[43] = 3.1500;
	points[44] = (4184.8032, -3861.4175, 628.0709);
	angles[44] = (0, -7.7280, 0);
	at[44] = 3.3000;
	points[45] = (4187.4019, -3773.6458, 628.0709);
	angles[45] = (0, -3.5683, 0);
	at[45] = 3.3500;
	points[46] = (4175.3149, -3685.8386, 628.0709);
	angles[46] = (0, 2.6129, 0);
	at[46] = 3.4000;
	points[47] = (4139.7246, -3513.1025, 628.0709);
	angles[47] = (0, 10.6401, 0);
	at[47] = 3.5000;
	points[48] = (4100.7480, -3433.1062, 628.0709);
	angles[48] = (0, 18.3297, 0);
	at[48] = 3.5500;
	points[49] = (4064.0156, -3352.4487, 628.0709);
	angles[49] = (0, 20.7654, 0);
	at[49] = 3.6000;
	points[50] = (4039.0552, -3267.2205, 628.0709);
	angles[50] = (0, 17.2460, 0);
	at[50] = 3.6500;
	points[51] = (4042.1260, -3179.4214, 628.0709);
	angles[51] = (0, 5.0945, 0);
	at[51] = 3.7000;
	points[52] = (4090.6299, -3108.2126, 628.0709);
	angles[52] = (0, -17, 0);
	at[52] = 3.7500;
	points[53] = (4161.4175, -3067.6577, 628.0709);
	angles[53] = (0, -38.7666, 0);
	at[53] = 3.8000;
	points[54] = (4245.0786, -3031.1143, 628.0709);
	angles[54] = (0, -52.3718, 0);
	at[54] = 3.8500;
	points[55] = (4328.7007, -2997.3032, 628.0709);
	angles[55] = (0, -60.0651, 0);
	at[55] = 3.9000;
	points[56] = (4493.9370, -2933.9883, 628.0709);
	angles[56] = (0, -66.8175, 0);
	at[56] = 4;
	points[57] = (4580.2363, -2902, 628.0709);
	angles[57] = (0, -68.2399, 0);
	at[57] = 4.0500;
	points[58] = (4661.3389, -2872.3938, 628.0709);
	angles[58] = (0, -69.0987, 0);
	at[58] = 4.1000;
	points[59] = (5166.2603, -2694.6575, 628.0709);
	angles[59] = (0, -70.8483, 0);
	at[59] = 4.4000;
	points[60] = (5673.8193, -2524.3267, 628.0709);
	angles[60] = (0, -71.6854, 0);
	at[60] = 4.7000;
	points[61] = (5754.8032, -2497.9961, 628.0709);
	angles[61] = (0, -71.8570, 0);
	at[61] = 4.7500;
	points[62] = (5843.9761, -2469.4133, 628.0709);
	angles[62] = (0, -72.0694, 0);
	at[62] = 4.8000;
	points[63] = (5925.2363, -2443.8779, 628.0709);
	angles[63] = (0, -72.3522, 0);
	at[63] = 4.8500;
	points[64] = (6015.3540, -2416.5393, 628.0709);
	angles[64] = (0, -72.8218, 0);
	at[64] = 4.9000;
	points[65] = (6091.7324, -2395.2363, 628.0709);
	angles[65] = (0, -73.7613, 0);
	at[65] = 4.9500;
	points[66] = (6351.1416, -2334.2087, 628.0709);
	angles[66] = (0, -76.9491, 0);
	at[66] = 5.1000;
	points[67] = (6525.7876, -2302.2087, 628.0709);
	angles[67] = (0, -79.2773, 0);
	at[67] = 5.2000;
	points[68] = (6701.4961, -2279.4331, 628.0709);
	angles[68] = (0, -82.2543, 0);
	at[68] = 5.3000;
	points[69] = (6789.8032, -2272.8860, 628.0709);
	angles[69] = (0, -84.2462, 0);
	at[69] = 5.3500;
	points[70] = (6878.7402, -2271.0198, 628.0709);
	angles[70] = (0, -86.8643, 0);
	at[70] = 5.4000;
	points[71] = (6967.2832, -2276.0552, 628.0709);
	angles[71] = (0, -90.5947, 0);
	at[71] = 5.4500;
	points[72] = (7053.4253, -2292.2126, 628.0709);
	angles[72] = (0, -96.6006, 0);
	at[72] = 5.5000;
	points[73] = (7136.0630, -2322.3938, 628.0709);
	angles[73] = (0, -103.6382, 0);
	at[73] = 5.5500;
	points[74] = (7214.3701, -2356.5669, 628.0709);
	angles[74] = (0, -108.6854, 0);
	at[74] = 5.6000;
	points[75] = (7296.0239, -2395.0237, 628.0709);
	angles[75] = (0, -112.0114, 0);
	at[75] = 5.6500;
	points[76] = (7533.6611, -2516.7402, 628.0709);
	angles[76] = (0, -116.8545, 0);
	at[76] = 5.8000;
	points[77] = (7766.9688, -2647.2717, 628.0709);
	angles[77] = (0, -119.2764, 0);
	at[77] = 5.9500;
	points[78] = (7994.9609, -2787.0710, 628.0709);
	angles[78] = (0, -121.7373, 0);
	at[78] = 6.1000;
	points[79] = (8141.1812, -2887.9331, 628.0709);
	angles[79] = (0, -124.3681, 0);
	at[79] = 6.2000;
	points[80] = (8212.4014, -2944.1653, 628.0709);
	angles[80] = (0, -126.6890, 0);
	at[80] = 6.2500;
	points[81] = (8275.9453, -3006.3110, 628.0709);
	angles[81] = (0, -131.4950, 0);
	at[81] = 6.3000;
	points[82] = (8303.3857, -3081.0354, 626.7834);
	angles[82] = (0, -149.5931, -0.8805);
	at[82] = 6.3500;
	points[83] = (8278.5830, -3166.2520, 619.8898);
	angles[83] = (0, -173.3090, -2.9820);
	at[83] = 6.4000;
	points[84] = (8237.4805, -3243.9412, 612.1575);
	angles[84] = (0, -190.5377, -4.1650);
	at[84] = 6.4500;
	points[85] = (8189.3311, -3318.4646, 604.6536);
	angles[85] = (0, -201.7415, -4.5419);
	at[85] = 6.5000;
	points[86] = (8082.9136, -3460.9922, 591.9764);
	angles[86] = (0, -213.3183, -4.0509);
	at[86] = 6.6000;
	points[87] = (7969.6851, -3597.9529, 584.2323);
	angles[87] = (0, -218.2103, -2.6236);
	at[87] = 6.7000;
	points[88] = (7852.2446, -3732.5237, 584.5394);
	angles[88] = (0, -220.4901, -0.1243);
	at[88] = 6.8000;
	points[89] = (7794.1733, -3797.7126, 589.6024);
	angles[89] = (0, -221.0977, 1.8723);
	at[89] = 6.8500;
	points[90] = (7735.0396, -3864.0591, 600.6536);
	angles[90] = (0, -221.3740, 4.9900);
	at[90] = 6.9000;
	points[91] = (7695.8267, -3908.6614, 613.9843);
	angles[91] = (0, -221.2763, 8.3983);
	at[91] = 6.9333;
	mover = getEnt("iz_obj_6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (8755.4727, -3516.9214, 628.0709);
	angles[0] = (0, -130.8145, 0);
	at[0] = 0;
	points[1] = (8716.5752, -3610.7756, 628.0709);
	angles[1] = (0, -159.8094, 0);
	at[1] = 0.0500;
	points[2] = (8695.3945, -3696.7913, 628.0709);
	angles[2] = (0, -176.1518, 0);
	at[2] = 0.1000;
	points[3] = (8653.0703, -3868.8228, 628.0709);
	angles[3] = (0, -193.9681, 0);
	at[3] = 0.2000;
	points[4] = (8593.6621, -3936.0474, 628.0709);
	angles[4] = (0, -205.8483, 0);
	at[4] = 0.2500;
	points[5] = (8538.5039, -4005.3545, 628.0709);
	angles[5] = (0, -212.0139, 0);
	at[5] = 0.3000;
	points[6] = (8489.4883, -4078.8582, 628.0709);
	angles[6] = (0, -212.0626, 0);
	at[6] = 0.3500;
	points[7] = (8357.2441, -4309.3701, 628.0709);
	angles[7] = (0, -210.1396, 0);
	at[7] = 0.5000;
	points[8] = (8348.1494, -4395.9448, 628.0709);
	angles[8] = (0, -196.2127, 0);
	at[8] = 0.5500;
	points[9] = (8346.1807, -4484.4883, 628.0709);
	angles[9] = (0, -188.9470, 0);
	at[9] = 0.6000;
	points[10] = (8330.7090, -4571.2598, 628.0709);
	angles[10] = (0, -191.4040, 0);
	at[10] = 0.6500;
	points[11] = (8287.8740, -4743.1494, 628.0709);
	angles[11] = (0, -193.3073, 0);
	at[11] = 0.7500;
	points[12] = (8266.4961, -4829.1343, 628.0709);
	angles[12] = (0, -201.4203, 10.0669);
	at[12] = 0.8000;
	points[13] = (8205.8262, -4829.8032, 704.4528);
	angles[13] = (0, -221.8017, 31.5388);
	at[13] = 0.8500;
	points[14] = (8149.6064, -4840.2363, 772.1299);
	angles[14] = (0, -237.2352, 41.8461);
	at[14] = 0.9000;
	points[15] = (8093.4253, -4850.6299, 839.8071);
	angles[15] = (0, -247.2508, 46.2601);
	at[15] = 0.9500;
	points[16] = (8037.2051, -4861.0630, 907.4843);
	angles[16] = (0, -253.0115, 48.1569);
	at[16] = 1;
	points[17] = (7868.6226, -4892.2837, 1110.5118);
	angles[17] = (0, -258.6069, 49.6162);
	at[17] = 1.1500;
	points[18] = (7250.4331, -5006.8110, 1854.9567);
	angles[18] = (0, -259.5029, 49.8176);
	at[18] = 1.7000;
	points[19] = (7198.5039, -5056.8110, 1885.2087);
	angles[19] = (0, -239.0359, 36.7955);
	at[19] = 1.7500;
	points[20] = (7149.0552, -5129.8032, 1893.6417);
	angles[20] = (0, -225.7289, 22.2814);
	at[20] = 1.8000;
	points[21] = (7099.6064, -5202.8345, 1902.0789);
	angles[21] = (0, -219.8734, 14.1886);
	at[21] = 1.8500;
	points[22] = (7050.1577, -5275.8267, 1910.5157);
	angles[22] = (0, -217.0248, 9.9498);
	at[22] = 1.9000;
	points[23] = (6990.9453, -5340.6299, 1916.0591);
	angles[23] = (0, -220.5779, 6.6767);
	at[23] = 1.9500;
	points[24] = (6859.6460, -5459.3311, 1923.3268);
	angles[24] = (0, -225.9757, 3.4928);
	at[24] = 2.0500;
	points[25] = (6793.9766, -5518.6611, 1926.9607);
	angles[25] = (0, -228.1495, -6.0681);
	at[25] = 2.1000;
	points[26] = (6742.9922, -5551.2207, 1859.5157);
	angles[26] = (0, -231.4832, -24.9479);
	at[26] = 2.1500;
	points[27] = (6691.1421, -5585.3545, 1796.3347);
	angles[27] = (0, -233.6600, -34.9448);
	at[27] = 2.2000;
	points[28] = (6587.4019, -5653.6221, 1669.9764);
	angles[28] = (0, -235.7668, -42.7344);
	at[28] = 2.3000;
	points[29] = (5757.5981, -6199.8032, 659.0984);
	angles[29] = (0, -236.6465, -45.4982);
	at[29] = 3.1000;
	points[30] = (5697.9922, -6187.1260, 628.0709);
	angles[30] = (0, -267.2964, -36.0610);
	at[30] = 3.1500;
	points[31] = (5630.9448, -6129.2520, 628.0709);
	angles[31] = (0, -290.1240, -20.4809);
	at[31] = 3.2000;
	points[32] = (5563.8975, -6071.3389, 628.0709);
	angles[32] = (0, -300.4483, -10.7638);
	at[32] = 3.2500;
	points[33] = (5496.8110, -6013.4648, 628.0709);
	angles[33] = (0, -305.5327, -5.5485);
	at[33] = 3.3000;
	points[34] = (5362.7163, -5897.7168, 628.0709);
	angles[34] = (0, -313.1793, -1.4729);
	at[34] = 3.4000;
	points[35] = (5274.4883, -5743.8584, 628.0709);
	angles[35] = (0, -325.4177, -0.3929);
	at[35] = 3.5000;
	points[36] = (5185.3540, -5590.7485, 628.0709);
	angles[36] = (0, -328.6439, -0.1031);
	at[36] = 3.6000;
	points[37] = (5051.6143, -5361.0635, 628.0709);
	angles[37] = (0, -328.2558, -0.0139);
	at[37] = 3.7500;
	points[38] = (4995.3149, -5292.3232, 628.0709);
	angles[38] = (0, -325.6329, -0.0071);
	at[38] = 3.8000;
	points[39] = (4621.1025, -4797.9131, 628.0709);
	angles[39] = (0, -322.9045, 0);
	at[39] = 4.1500;
	points[40] = (4652.6772, -4732.0078, 628.0709);
	angles[40] = (0, -358.3260, 0);
	at[40] = 4.2000;
	points[41] = (4713.6611, -4667.7954, 628.0709);
	angles[41] = (0, -379.7573, 0);
	at[41] = 4.2500;
	points[42] = (4774.6460, -4603.5435, 628.0709);
	angles[42] = (0, -391.2614, 0);
	at[42] = 4.3000;
	points[43] = (4835.6299, -4539.2910, 628.0709);
	angles[43] = (0, -397.2263, 0);
	at[43] = 4.3500;
	points[44] = (4957.5981, -4410.7871, 628.0709);
	angles[44] = (0, -401.8608, 0);
	at[44] = 4.4500;
	points[45] = (5012.3623, -4341.5356, 628.0709);
	angles[45] = (0, -399.2875, 0);
	at[45] = 4.5000;
	points[46] = (5161.4175, -4121.5352, 628.0709);
	angles[46] = (0, -394.8116, 0);
	at[46] = 4.6500;
	points[47] = (5205.3149, -4149.3701, 628.0709);
	angles[47] = (0, -423.2086, 0);
	at[47] = 4.7000;
	points[48] = (5246.3779, -4227.8740, 628.0709);
	angles[48] = (0, -461.2234, 0);
	at[48] = 4.7500;
	points[49] = (5287.4409, -4306.3384, 628.0709);
	angles[49] = (0, -485.2811, 0);
	at[49] = 4.8000;
	points[50] = (5328.5039, -4384.8428, 628.0709);
	angles[50] = (0, -498.3788, 0);
	at[50] = 4.8500;
	points[51] = (5410.6299, -4541.8110, 628.0709);
	angles[51] = (0, -508.7024, 0);
	at[51] = 4.9500;
	points[52] = (5492.7563, -4698.8188, 628.0709);
	angles[52] = (0, -511.4200, 0);
	at[52] = 5.0500;
	points[53] = (5549.1733, -4708.7402, 628.0709);
	angles[53] = (0, -483.5619, 0);
	at[53] = 5.1000;
	points[54] = (5619.8032, -4655.3149, 628.0709);
	angles[54] = (0, -451.6101, 0);
	at[54] = 5.1500;
	points[55] = (5690.4331, -4601.8506, 628.0709);
	angles[55] = (0, -433.0945, 0);
	at[55] = 5.2000;
	points[56] = (5761.0630, -4548.3857, 628.0709);
	angles[56] = (0, -423.2834, 0);
	at[56] = 5.2500;
	points[57] = (5831.6929, -4494.9214, 628.0709);
	angles[57] = (0, -418.2140, 0);
	at[57] = 5.3000;
	points[58] = (6114.2520, -4281.1025, 628.0709);
	angles[58] = (0, -413.2473, 0);
	at[58] = 5.5000;
	points[59] = (7103.1104, -3532.6890, 628.0709);
	angles[59] = (0, -412.8806, 0);
	at[59] = 6.2000;
	points[60] = (7173.7402, -3479.2322, 628.0709);
	angles[60] = (0, -418.3590, 0);
	at[60] = 6.2500;
	points[61] = (7262.7559, -3468.7520, 628.0709);
	angles[61] = (0, -429.2414, 0);
	at[61] = 6.3000;
	points[62] = (7350.2363, -3454.6025, 628.0709);
	angles[62] = (0, -434.8765, 0);
	at[62] = 6.3500;
	points[63] = (7700, -3398.0081, 628.0709);
	angles[63] = (0, -440.4011, 0);
	at[63] = 6.5500;
	points[64] = (7785.2759, -3375.1970, 628.0709);
	angles[64] = (0, -437.0160, 0);
	at[64] = 6.6000;
	points[65] = (7952.5986, -3317.0393, 628.0709);
	angles[65] = (0, -432.4579, 0);
	at[65] = 6.7000;
	points[66] = (8203.6221, -3229.8071, 628.0709);
	angles[66] = (0, -431.0547, 0);
	at[66] = 6.8500;
	points[67] = (8282.4404, -3259.9607, 628.0709);
	angles[67] = (0, -453.4940, 0);
	at[67] = 6.9000;
	points[68] = (8360.3154, -3302.2441, 628.0709);
	angles[68] = (0, -465.6012, 0);
	at[68] = 6.9500;
	points[69] = (8515.9844, -3386.8110, 628.0709);
	angles[69] = (0, -475.1184, 0);
	at[69] = 7.0500;
	points[70] = (8671.6533, -3471.3821, 628.0709);
	angles[70] = (0, -477.6220, 0);
	at[70] = 7.1500;
	points[71] = (8755.4727, -3516.9214, 628.0709);
	angles[71] = (0, -490.8145, 0);
	at[71] = 7.2000;
	mover = getEnt("iz_obj_7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4095.1575, -20460.5508, 2174.7559);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (4100.4727, -20226.4570, 2126.0630);
	angles[1] = (0, 90, 0);
	at[1] = 0.9000;
	points[2] = (4084.7244, -20044.8027, 2088.7480);
	angles[2] = (0, 90, 0);
	at[2] = 1.6000;
	points[3] = (4071.7322, -19809.6465, 2135.0513);
	angles[3] = (0, 90, 0);
	at[3] = 2.5000;
	points[4] = (4071.4961, -19805.3145, 2135.9097);
	angles[4] = (0, 90, 0);
	at[4] = 2.5500;
	points[5] = (4071.4961, -19805.3145, 2135.9097);
	angles[5] = (0, 90, 0);
	at[5] = 3;
	points[6] = (4084.4097, -20039.0957, 2089.4529);
	angles[6] = (0, 90, 0);
	at[6] = 3.9000;
	points[7] = (4085.1575, -20052.1660, 2090.2639);
	angles[7] = (0, 90, 0);
	at[7] = 3.9500;
	points[8] = (4100.6694, -20233.7793, 2127.5708);
	angles[8] = (0, 90, 0);
	at[8] = 4.6500;
	points[9] = (4095, -20467.8730, 2176.2954);
	angles[9] = (0, 90, 0);
	at[9] = 5.5500;
	points[10] = (4095, -20467.8730, 2176.2954);
	angles[10] = (0, 90, 0);
	at[10] = 6.0500;
	points[11] = (4095.1575, -20460.5508, 2174.7559);
	angles[11] = (0, 90, 0);
	at[11] = 6.0667;
	mover = getEnt("iz_obj_8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1828.7520, -20316.3789, 2125.6299);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1819.3544, -20132.6777, 2088.6575);
	angles[1] = (0, 90, 0);
	at[1] = 0.7000;
	points[2] = (1813.1929, -19870.7480, 2140.8899);
	angles[2] = (0, 90, 0);
	at[2] = 1.7000;
	points[3] = (1805.3505, -19688.1504, 2175.5750);
	angles[3] = (0, 90, 0);
	at[3] = 2.4000;
	points[4] = (1804.9803, -19679.4492, 2177.2285);
	angles[4] = (0, 90, 0);
	at[4] = 2.4500;
	points[5] = (1804.9803, -19679.4492, 2177.2285);
	angles[5] = (0, 90, 0);
	at[5] = 2.9000;
	points[6] = (1805.2324, -19685.3535, 2176.1104);
	angles[6] = (0, 90, 0);
	at[6] = 2.9500;
	points[7] = (1813.0355, -19867.9531, 2141.4253);
	angles[7] = (0, 90, 0);
	at[7] = 3.6500;
	points[8] = (1819.2441, -20129.8027, 2089.2283);
	angles[8] = (0, 90, 0);
	at[8] = 4.6500;
	points[9] = (1828.5787, -20313.5840, 2125.0630);
	angles[9] = (0, 90, 0);
	at[9] = 5.3500;
	points[10] = (1829.1102, -20322.2441, 2126.8230);
	angles[10] = (0, 90, 0);
	at[10] = 5.4000;
	points[11] = (1829.1102, -20322.2441, 2126.8230);
	angles[11] = (0, 90, 0);
	at[11] = 5.8500;
	points[12] = (1828.7520, -20316.3789, 2125.6299);
	angles[12] = (0, 90, 0);
	at[12] = 5.9000;
	mover = getEnt("iz_obj_9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-674.4252, -20677.1660, 2177.5867);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-658.9567, -20560.8652, 2154.3818);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (-676.3701, -20327.0098, 2107.4922);
	angles[2] = (0, 90, 0);
	at[2] = 1.3500;
	points[3] = (-673.9528, -20234.8828, 2089.1338);
	angles[3] = (0, 90, 0);
	at[3] = 1.7000;
	points[4] = (-661.5040, -20091.8516, 2116.7954);
	angles[4] = (0, 90, 0);
	at[4] = 2.2500;
	points[5] = (-658.0826, -20013.8203, 2132.5945);
	angles[5] = (0, 90, 0);
	at[5] = 2.5500;
	points[6] = (-657.8859, -20009.4492, 2133.4724);
	angles[6] = (0, 90, 0);
	at[6] = 2.6000;
	points[7] = (-657.8859, -20009.4492, 2133.4724);
	angles[7] = (0, 90, 0);
	at[7] = 3.0500;
	points[8] = (-662.2874, -20099.9219, 2115.1655);
	angles[8] = (0, 90, 0);
	at[8] = 3.4000;
	points[9] = (-673.7795, -20229.8809, 2088.9292);
	angles[9] = (0, 90, 0);
	at[9] = 3.9000;
	points[10] = (-676.9646, -20322.1270, 2106.5159);
	angles[10] = (0, 90, 0);
	at[10] = 4.2500;
	points[11] = (-659.2480, -20555.9434, 2153.3977);
	angles[11] = (0, 90, 0);
	at[11] = 5.1500;
	points[12] = (-675.4961, -20685.1973, 2179.1890);
	angles[12] = (0, 90, 0);
	at[12] = 5.6500;
	points[13] = (-675.4961, -20685.1973, 2179.1890);
	angles[13] = (0, 90, 0);
	at[13] = 6.1500;
	points[14] = (-674.4252, -20677.1660, 2177.5867);
	angles[14] = (0, 90, 0);
	at[14] = 6.1667;
	mover = getEnt("iz_obj_10", "targetname");
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
