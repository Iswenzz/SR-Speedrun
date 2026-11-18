main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_rosalinas_ice", 0);

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
	ambientPlay("iz_0_117", 2);
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
	level.iz_route[level.iz_route.size] = (3234, -64, 9696);
	level.iz_route[level.iz_route.size] = (3237, -1263, 9657);
	level.iz_route[level.iz_route.size] = (3272, -2464, 9628);
	level.iz_route[level.iz_route.size] = (3049, -3477, 9650);
	level.iz_route[level.iz_route.size] = (2251, -4004, 9641);
	level.iz_route[level.iz_route.size] = (1398, -4357, 9630);
	level.iz_route[level.iz_route.size] = (817, -4800, 9629);
	level.iz_route[level.iz_route.size] = (607, -5639, 9625);
	level.iz_route[level.iz_route.size] = (443, -6628, 9558);
	level.iz_route[level.iz_route.size] = (267, -7741, 9393);
	level.iz_route[level.iz_route.size] = (50, -8775, 9259);
	level.iz_route[level.iz_route.size] = (-230, -9406, 9241);
	level.iz_route[level.iz_route.size] = (-855, -9843, 9223);
	level.iz_route[level.iz_route.size] = (-1448, -9885, 9194);
	level.iz_route[level.iz_route.size] = (-2100, -9661, 9161);
	level.iz_route[level.iz_route.size] = (-2581, -9135, 9121);
	level.iz_route[level.iz_route.size] = (-2737, -8523, 9088);
	level.iz_route[level.iz_route.size] = (-2601, -7980, 9057);
	level.iz_route[level.iz_route.size] = (-2238, -7549, 9029);
	level.iz_route[level.iz_route.size] = (-1613, -7212, 9008);
	level.iz_route[level.iz_route.size] = (-885, -7264, 8958);
	level.iz_route[level.iz_route.size] = (-322, -7764, 8885);
	level.iz_route[level.iz_route.size] = (267, -8382, 8830);
	level.iz_route[level.iz_route.size] = (653, -8776, 8800);
	level.iz_route[level.iz_route.size] = (1188, -8919, 8768);
	level.iz_route[level.iz_route.size] = (1643, -8796, 8748);
	level.iz_route[level.iz_route.size] = (1926, -8457, 8737);
	level.iz_route[level.iz_route.size] = (2116, -8121, 8726);
	level.iz_route[level.iz_route.size] = (2493, -7599, 8713);
	level.iz_route[level.iz_route.size] = (3079, -7119, 8681);
	level.iz_route[level.iz_route.size] = (3978, -6489, 8550);
	level.iz_route[level.iz_route.size] = (5041, -5837, 8320);
	level.iz_route[level.iz_route.size] = (5864, -5318, 8169);
	level.iz_route[level.iz_route.size] = (7814, -3935, 7938);
	level.iz_route[level.iz_route.size] = (8412, -3391, 7938);
	level.iz_route[level.iz_route.size] = (9020, -2717, 7938);
	level.iz_route[level.iz_route.size] = (9721, -2348, 7938);
	level.iz_route[level.iz_route.size] = (10322, -2108, 7938);
	level.iz_route[level.iz_route.size] = (10879, -1910, 7938);
	level.iz_route[level.iz_route.size] = (11558, -1370, 7938);
	level.iz_route[level.iz_route.size] = (12329, -721, 7938);
	level.iz_route[level.iz_route.size] = (12768, -122, 7938);
	level.iz_route[level.iz_route.size] = (13098, 759, 7938);
	level.iz_route[level.iz_route.size] = (13468, 1340, 7938);
	level.iz_route[level.iz_route.size] = (14076, 1812, 7938);
	level.iz_route[level.iz_route.size] = (14626, 2159, 7938);
	level.iz_route[level.iz_route.size] = (15115, 2390, 7938);
	level.iz_route[level.iz_route.size] = (15548, 2550, 7937);
	level.iz_route[level.iz_route.size] = (16603, 2955, 7808);
	level.iz_route[level.iz_route.size] = (17280, 3460, 7940);
	level.iz_route[level.iz_route.size] = (18009, 3934, 7910);
	level.iz_route[level.iz_route.size] = (18654, 4110, 7894);
	level.iz_route[level.iz_route.size] = (19345, 3863, 7964);
	level.iz_route[level.iz_route.size] = (19961, 3585, 8070);
	level.iz_route[level.iz_route.size] = (20742, 3539, 8179);
	level.iz_route[level.iz_route.size] = (21277, 3937, 8272);
	level.iz_route[level.iz_route.size] = (21434, 4527, 8327);
	level.iz_route[level.iz_route.size] = (21263, 5088, 8333);
	level.iz_route[level.iz_route.size] = (20864, 5833, 8335);
	level.iz_route[level.iz_route.size] = (20105, 6475, 8339);
	level.iz_route[level.iz_route.size] = (19260, 7130, 8399);
	level.iz_route[level.iz_route.size] = (18459, 7424, 8496);
	level.iz_route[level.iz_route.size] = (17743, 7309, 8575);
	level.iz_route[level.iz_route.size] = (17140, 6892, 8640);
	level.iz_route[level.iz_route.size] = (16499, 6319, 8721);
	level.iz_route[level.iz_route.size] = (15920, 5890, 8790);
	level.iz_route[level.iz_route.size] = (15264, 5544, 8850);
	level.iz_route[level.iz_route.size] = (14502, 5549, 8906);
	level.iz_route[level.iz_route.size] = (13825, 5904, 8949);
	level.iz_route[level.iz_route.size] = (12761, 6492, 9018);
	level.iz_route[level.iz_route.size] = (12012, 6715, 9062);
	level.iz_route[level.iz_route.size] = (10909, 6548, 9124);
	level.iz_route[level.iz_route.size] = (9204, 6258, 9230);
	level.iz_route[level.iz_route.size] = (8125, 6098, 9345);
	level.iz_route[level.iz_route.size] = (6784, 6065, 9518);
	level.iz_route[level.iz_route.size] = (5718, 6179, 9719);
	level.iz_route[level.iz_route.size] = (4963, 6143, 9853);
	level.iz_route[level.iz_route.size] = (4246, 6001, 9962);
	level.iz_route[level.iz_route.size] = (3546, 5505, 10002);
	level.iz_route[level.iz_route.size] = (3190, 4825, 9969);
	level.iz_route[level.iz_route.size] = (3152, 4128, 9893);
	level.iz_route[level.iz_route.size] = (3171, 3299, 9811);
	level.iz_route[level.iz_route.size] = (3193, 2034, 9743);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (15145.7881, 2806.9805, 7938.4253);
	angles[0] = (0, -157.3472, 0);
	at[0] = 0;
	points[1] = (15149.2520, 2798.7717, 7938.4253);
	angles[1] = (0, -157.1224, 0);
	at[1] = 0.1667;
	points[2] = (15151.0234, 2793.2559, 7938.4253);
	angles[2] = (0, -161.0370, 0);
	at[2] = 0.2500;
	points[3] = (15158.2295, 2777.1931, 7938.4253);
	angles[3] = (0, -154.8268, 0);
	at[3] = 0.5000;
	points[4] = (15165.9453, 2761.6062, 7938.4253);
	angles[4] = (0, -153.4863, 0);
	at[4] = 0.7500;
	points[5] = (15168.7412, 2756.1221, 7938.4253);
	angles[5] = (0, -153.3152, 0);
	at[5] = 0.8333;
	points[6] = (15173.7402, 2746.2520, 7938.4253);
	angles[6] = (0, -153.1691, 0);
	at[6] = 0.9167;
	points[7] = (15385.3145, 2332.2756, 7938.4253);
	angles[7] = (0, -152.9162, 0);
	at[7] = 3.0833;
	points[8] = (15422.1260, 2260.1772, 7938.4253);
	angles[8] = (0, -152.9812, 0);
	at[8] = 3.5833;
	points[9] = (15454.3701, 2196.9763, 7938.4253);
	angles[9] = (0, -152.9705, 0);
	at[9] = 4.2500;
	points[10] = (15484.0166, 2138.8347, 7938.4253);
	angles[10] = (0, -152.4629, 0);
	at[10] = 5.1667;
	points[11] = (15504.4482, 2104.6143, 7938.4253);
	angles[11] = (0, -146.4579, 0);
	at[11] = 5.9167;
	points[12] = (15516.8896, 2087.9490, 7938.4253);
	angles[12] = (0, -141.2328, 0);
	at[12] = 6.5000;
	points[13] = (15520.9053, 2083.6536, 7938.4253);
	angles[13] = (0, -135.0559, 0);
	at[13] = 6.6667;
	points[14] = (15523.2285, 2084.0237, 7938.4253);
	angles[14] = (0, -89.6538, 0);
	at[14] = 6.7500;
	points[15] = (15524.4883, 2086.7205, 7938.4253);
	angles[15] = (0, -46.6113, 0);
	at[15] = 6.8333;
	points[16] = (15525.4336, 2089.5276, 7938.4253);
	angles[16] = (0, -27.0189, 0);
	at[16] = 6.9167;
	points[17] = (15526.1426, 2092.4055, 7938.4253);
	angles[17] = (0, -18.0798, 0);
	at[17] = 7;
	points[18] = (15527.3232, 2101.2126, 7938.4253);
	angles[18] = (0, -4.7290, 0);
	at[18] = 7.2500;
	points[19] = (15527.1270, 2104.0552, 7938.4253);
	angles[19] = (0, 2.8195, 0);
	at[19] = 7.3333;
	points[20] = (15525.9453, 2108.2913, 7938.4253);
	angles[20] = (0, 11.9676, 0);
	at[20] = 7.4167;
	points[21] = (15524.5273, 2112.5237, 7938.4253);
	angles[21] = (0, 16.7449, 0);
	at[21] = 7.5000;
	points[22] = (15513.2285, 2141.5078, 7938.4253);
	angles[22] = (0, 21.9135, 0);
	at[22] = 8.0833;
	points[23] = (15511.5361, 2145.9448, 7938.4253);
	angles[23] = (0, 20.7212, 0);
	at[23] = 8.1667;
	points[24] = (15510.3936, 2151.6182, 7938.4253);
	angles[24] = (0, 15.1146, 0);
	at[24] = 8.2500;
	points[25] = (15503.4648, 2167.6614, 7938.4253);
	angles[25] = (0, 24.5277, 0);
	at[25] = 8.5000;
	points[26] = (15495.6299, 2183.5276, 7938.4253);
	angles[26] = (0, 26.5028, 0);
	at[26] = 8.7500;
	points[27] = (15491.4971, 2191.6338, 7938.4253);
	angles[27] = (0, 26.8032, 0);
	at[27] = 8.8333;
	points[28] = (15294.8818, 2572.8662, 7938.4253);
	angles[28] = (0, 27.3068, 0);
	at[28] = 10.8333;
	points[29] = (15287.9531, 2586.3071, 7938.4253);
	angles[29] = (0, 27.2909, 0);
	at[29] = 10.9167;
	points[30] = (15252.4404, 2655.2126, 7938.4253);
	angles[30] = (0, 27.2720, 0);
	at[30] = 11.4167;
	points[31] = (15215.6689, 2726.4883, 7938.4253);
	angles[31] = (0, 27.2728, 0);
	at[31] = 12.1667;
	points[32] = (15180.3145, 2794.9172, 7938.4253);
	angles[32] = (0, 28.4595, 0);
	at[32] = 13.2500;
	points[33] = (15157.7559, 2832.6731, 7938.4253);
	angles[33] = (0, 32.3722, 0);
	at[33] = 14.0833;
	points[34] = (15142.8340, 2854.8308, 7938.4253);
	angles[34] = (0, 35.2132, 0);
	at[34] = 14.8333;
	points[35] = (15137.4014, 2861.8506, 7938.4253);
	angles[35] = (0, 39.3818, 0);
	at[35] = 15.0833;
	points[36] = (15135.0391, 2863.0825, 7938.4253);
	angles[36] = (0, 64.7690, 0);
	at[36] = 15.1667;
	points[37] = (15133.1895, 2860.8269, 7938.4253);
	angles[37] = (0, 116.5023, 0);
	at[37] = 15.2500;
	points[38] = (15132.0479, 2858.0945, 7938.4253);
	angles[38] = (0, 144.5778, 0);
	at[38] = 15.3333;
	points[39] = (15131.2207, 2855.2363, 7938.4253);
	angles[39] = (0, 158.3401, 0);
	at[39] = 15.4167;
	points[40] = (15131.6934, 2842.4922, 7938.4253);
	angles[40] = (0, 191.6339, 0);
	at[40] = 15.7500;
	points[41] = (15133.1895, 2838.2913, 7938.4253);
	angles[41] = (0, 197.0855, 0);
	at[41] = 15.8333;
	points[42] = (15136.3779, 2829.9648, 7938.4253);
	angles[42] = (0, 200.7963, 0);
	at[42] = 16;
	points[43] = (15145.7881, 2806.9805, 7938.4253);
	angles[43] = (0, 202.6528, 0);
	at[43] = 16.4667;
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
	points[0] = (12352.5986, -1192.0826, 7938.4253);
	angles[0] = (0, 58.9003, 0);
	at[0] = 0;
	points[1] = (12340.1582, -1183.6615, 7938.4253);
	angles[1] = (0, 55.5806, 0);
	at[1] = 0.2500;
	points[2] = (12329.7637, -1178.1929, 7938.4253);
	angles[2] = (0, 62.1142, 0);
	at[2] = 0.4167;
	points[3] = (12308.5039, -1167.9489, 7938.4253);
	angles[3] = (0, 64.5686, 0);
	at[3] = 0.7500;
	points[4] = (12300.3535, -1164.1182, 7938.4253);
	angles[4] = (0, 64.7631, 0);
	at[4] = 0.8333;
	points[5] = (11878.8584, -968.5512, 7938.4253);
	angles[5] = (0, 65.1272, 0);
	at[5] = 3;
	points[6] = (11805.4336, -934.4370, 7938.4253);
	angles[6] = (0, 65.0457, 0);
	at[6] = 3.5000;
	points[7] = (11741.6543, -904.7874, 7938.4253);
	angles[7] = (0, 65.0563, 0);
	at[7] = 4.1667;
	points[8] = (11682.5596, -877.2953, 7938.4253);
	angles[8] = (0, 65.8766, 0);
	at[8] = 5.0833;
	points[9] = (11645.0391, -863.3504, 7938.4253);
	angles[9] = (0, 72.1234, 0);
	at[9] = 5.8333;
	points[10] = (11616.2607, -856.2834, 7938.4253);
	angles[10] = (0, 79.3350, 0);
	at[10] = 6.6667;
	points[11] = (11613.3066, -855.8779, 7938.4253);
	angles[11] = (0, 81.7722, 0);
	at[11] = 6.7500;
	points[12] = (11610.4727, -855.9055, 7938.4253);
	angles[12] = (0, 90.8139, 0);
	at[12] = 6.8333;
	points[13] = (11608.1104, -857.6221, 7938.4253);
	angles[13] = (0, 117.6172, 0);
	at[13] = 6.9167;
	points[14] = (11606.4180, -860.0197, 7938.4253);
	angles[14] = (0, 137.1796, 0);
	at[14] = 7;
	points[15] = (11605.1182, -862.6811, 7938.4253);
	angles[15] = (0, 149.1872, 0);
	at[15] = 7.0833;
	points[16] = (11603.5039, -868.3819, 7938.4253);
	angles[16] = (0, 165.7231, 0);
	at[16] = 7.2500;
	points[17] = (11603.5039, -871.3228, 7938.4253);
	angles[17] = (0, 177.3199, 0);
	at[17] = 7.3333;
	points[18] = (11605.2363, -874.2716, 7938.4253);
	angles[18] = (0, 202.6879, 0);
	at[18] = 7.4167;
	points[19] = (11608.6221, -877.0472, 7938.4253);
	angles[19] = (0, 221.9874, 0);
	at[19] = 7.5000;
	points[20] = (11612.2441, -879.6614, 7938.4253);
	angles[20] = (0, 230.3642, 0);
	at[20] = 7.5833;
	points[21] = (11619.6064, -884.6417, 7938.4253);
	angles[21] = (0, 235.7487, 0);
	at[21] = 7.7500;
	points[22] = (11634.6455, -894.2087, 7938.4253);
	angles[22] = (0, 237.6581, 0);
	at[22] = 8.0833;
	points[23] = (11638.2285, -898.1457, 7938.4253);
	angles[23] = (0, 225.6953, 0);
	at[23] = 8.1667;
	points[24] = (11647.9922, -904.3622, 7938.4253);
	angles[24] = (0, 238.5471, 0);
	at[24] = 8.3333;
	points[25] = (11653.2285, -907.0906, 7938.4253);
	angles[25] = (0, 241.4485, 0);
	at[25] = 8.4167;
	points[26] = (11669.2129, -914.8465, 7938.4253);
	angles[26] = (0, 244.3813, 0);
	at[26] = 8.6667;
	points[27] = (11679.4102, -919.5984, 7938.4253);
	angles[27] = (0, 244.7976, 0);
	at[27] = 8.7500;
	points[28] = (12069.4492, -1098.3466, 7938.4253);
	angles[28] = (0, 245.4078, 0);
	at[28] = 10.7500;
	points[29] = (12142.6377, -1131.8818, 7938.4253);
	angles[29] = (0, 245.3722, 0);
	at[29] = 11.2500;
	points[30] = (12224.8037, -1169.5591, 7938.4253);
	angles[30] = (0, 245.3705, 0);
	at[30] = 12.0833;
	points[31] = (12289.7246, -1199.3188, 7938.4253);
	angles[31] = (0, 246.3503, 0);
	at[31] = 13.0833;
	points[32] = (12331.2598, -1214.9252, 7938.4253);
	angles[32] = (0, 250.6195, 0);
	at[32] = 13.9167;
	points[33] = (12366.5352, -1225.7205, 7938.4253);
	angles[33] = (0, 254.6993, 0);
	at[33] = 14.9167;
	points[34] = (12375.1582, -1227.7008, 7938.4253);
	angles[34] = (0, 258.5883, 0);
	at[34] = 15.1667;
	points[35] = (12378.0322, -1227.8386, 7938.4253);
	angles[35] = (0, 267.5229, 0);
	at[35] = 15.2500;
	points[36] = (12382.7168, -1224.3779, 7938.4253);
	angles[36] = (0, 309.3167, 0);
	at[36] = 15.4167;
	points[37] = (12385.7480, -1216.1969, 7938.4253);
	angles[37] = (0, 348.5638, 0);
	at[37] = 15.6667;
	points[38] = (12381.8896, -1210.7756, 7938.4253);
	angles[38] = (0, 397.6295, 0);
	at[38] = 15.8333;
	points[39] = (12378.2676, -1208.1772, 7938.4253);
	angles[39] = (0, 409.2523, 0);
	at[39] = 15.9167;
	points[40] = (12370.8271, -1203.2795, 7938.4253);
	angles[40] = (0, 416.2314, 0);
	at[40] = 16.0833;
	points[41] = (12352.5986, -1192.0826, 7938.4253);
	angles[41] = (0, 418.9003, 0);
	at[41] = 16.4833;
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
	points[0] = (8738.7793, -3631.3857, 7938.4253);
	angles[0] = (0, 40.3826, -0.0014);
	at[0] = 0;
	points[1] = (8736.4961, -3628.6064, 7938.4253);
	angles[1] = (0, 39.9621, -0.0022);
	at[1] = 0.0667;
	points[2] = (8729.6846, -3623.8228, 7938.4253);
	angles[2] = (0, 53.6263, -0.0014);
	at[2] = 0.2000;
	points[3] = (8721.4570, -3612.5554, 7938.4253);
	angles[3] = (0, 34.1913, -0.0011);
	at[3] = 0.4000;
	points[4] = (8714.6455, -3600.0552, 7938.4253);
	angles[4] = (0, 28.3715, 0);
	at[4] = 0.6000;
	points[5] = (8710.9844, -3592.8464, 7938.4253);
	angles[5] = (0, 27.4854, 0);
	at[5] = 0.6667;
	points[6] = (8566.4961, -3297.9841, 7938.4253);
	angles[6] = (0, 26.0663, 0);
	at[6] = 2.2000;
	points[7] = (8538.7012, -3241.7009, 7938.4253);
	angles[7] = (0, 26.3508, 0);
	at[7] = 2.6000;
	points[8] = (8516.6143, -3196.9805, 7938.4253);
	angles[8] = (0, 26.2902, -0.0014);
	at[8] = 3.0667;
	points[9] = (8495.0400, -3153.7559, 7938.4253);
	angles[9] = (0, 26.1036, 0);
	at[9] = 3.7333;
	points[10] = (8487.3232, -3135.2637, 7938.4253);
	angles[10] = (0, 20.3630, 0);
	at[10] = 4.0667;
	points[11] = (8479.7637, -3112.0393, 7938.4253);
	angles[11] = (0, 16.8261, -0.0017);
	at[11] = 4.5333;
	points[12] = (8474.2520, -3093.8662, 7938.4253);
	angles[12] = (0, 16.1249, 0);
	at[12] = 5.0667;
	points[13] = (8471.5352, -3082.3269, 7938.4253);
	angles[13] = (0, 10.8809, -0.0014);
	at[13] = 5.4000;
	points[14] = (8471.2207, -3077.5552, 7938.4253);
	angles[14] = (0, 2.6702, -0.0027);
	at[14] = 5.5333;
	points[15] = (8473.0312, -3073.4646, 7938.4253);
	angles[15] = (0, -23.9565, -0.0010);
	at[15] = 5.6667;
	points[16] = (8476.1025, -3069.7954, 7938.4253);
	angles[16] = (0, -38.1612, 0);
	at[16] = 5.8000;
	points[17] = (8490.6689, -3057.6575, 7938.4253);
	angles[17] = (0, -56.1264, -0.0012);
	at[17] = 6.3333;
	points[18] = (8494.8818, -3055.5984, 7938.4253);
	angles[18] = (0, -64.9764, -0.0022);
	at[18] = 6.4667;
	points[19] = (8497.1660, -3055.2480, 7938.4253);
	angles[19] = (0, -77.9876, -0.0038);
	at[19] = 6.5333;
	points[20] = (8500.0391, -3056.5039, 7938.4253);
	angles[20] = (0, -100.4375, -0.0017);
	at[20] = 6.6000;
	points[21] = (8502.9531, -3058.5747, 7938.4253);
	angles[21] = (0, -115.7800, 0);
	at[21] = 6.6667;
	points[22] = (8508.3467, -3063.2205, 7938.4253);
	angles[22] = (0, -128.8774, 0);
	at[22] = 6.8000;
	points[23] = (8516.0244, -3070.6575, 7938.4253);
	angles[23] = (0, -134.3723, 0);
	at[23] = 7;
	points[24] = (8528.1504, -3083.5632, 7938.4253);
	angles[24] = (0, -137.4663, -0.0026);
	at[24] = 7.3333;
	points[25] = (8531.7324, -3086.0198, 7938.4253);
	angles[25] = (0, -127.2075, -0.0013);
	at[25] = 7.4000;
	points[26] = (8540.4336, -3096.9763, 7938.4253);
	angles[26] = (0, -145.7508, -0.0011);
	at[26] = 7.6000;
	points[27] = (8549.8818, -3114.8818, 7938.4253);
	angles[27] = (0, -152.6102, 0);
	at[27] = 7.8667;
	points[28] = (8699.7637, -3422.1851, 7938.4253);
	angles[28] = (0, -154.0378, 0);
	at[28] = 9.4667;
	points[29] = (8727.8740, -3479.4919, 7938.4253);
	angles[29] = (0, -153.8078, -0.0013);
	at[29] = 9.8667;
	points[30] = (8749.5283, -3523.5237, 7938.4253);
	angles[30] = (0, -153.6689, -0.0012);
	at[30] = 10.3333;
	points[31] = (8766.4570, -3557.4766, 7938.4253);
	angles[31] = (0, -154.8095, -0.0014);
	at[31] = 10.8667;
	points[32] = (8771.0635, -3571.9922, 7938.4253);
	angles[32] = (0, -164.8793, 0);
	at[32] = 11.1333;
	points[33] = (8777.0469, -3599.6379, 7938.4253);
	angles[33] = (0, -168.2805, -0.0022);
	at[33] = 11.6667;
	points[34] = (8780.3936, -3613.4844, 7938.4253);
	angles[34] = (0, -166.8494, 0);
	at[34] = 12.0667;
	points[35] = (8782.3623, -3625.1299, 7938.4253);
	angles[35] = (0, -173.4359, -0.0017);
	at[35] = 12.4000;
	points[36] = (8782.3623, -3627.5159, 7938.4253);
	angles[36] = (0, -177.7965, -0.0024);
	at[36] = 12.4667;
	points[37] = (8781.9297, -3629.7715, 7938.4253);
	angles[37] = (0, -188.3921, -0.0029);
	at[37] = 12.5333;
	points[38] = (8780.6699, -3631.7363, 7938.4253);
	angles[38] = (0, -204.0746, -0.0013);
	at[38] = 12.6000;
	points[39] = (8779.0557, -3633.5474, 7938.4253);
	angles[39] = (0, -214.6384, 0);
	at[39] = 12.6667;
	points[40] = (8777.4414, -3635.1851, 7938.4253);
	angles[40] = (0, -220.9543, 0);
	at[40] = 12.7333;
	points[41] = (8773.8975, -3638.3743, 7938.4253);
	angles[41] = (0, -227.4731, 0);
	at[41] = 12.8667;
	points[42] = (8762.3232, -3646.6812, 7938.4253);
	angles[42] = (0, -237.8985, -0.0013);
	at[42] = 13.2667;
	points[43] = (8757.9922, -3648.6262, 7938.4253);
	angles[43] = (0, -247.1200, -0.0029);
	at[43] = 13.4000;
	points[44] = (8752.6377, -3646.3899, 7938.4253);
	angles[44] = (0, -290.0889, -0.0014);
	at[44] = 13.5333;
	points[45] = (8750, -3644, 7938.4253);
	angles[45] = (0, -303.6470, 0);
	at[45] = 13.6000;
	points[46] = (8745.1182, -3638.8110, 7938.4253);
	angles[46] = (0, -315.1307, 0);
	at[46] = 13.7333;
	points[47] = (8738.7793, -3631.3857, 7938.4253);
	angles[47] = (0, -319.6174, -0.0014);
	at[47] = 13.9167;
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
	points[0] = (10419.9600, -2605.4094, 7252.5591);
	angles[0] = (0, 126.1687, 0);
	at[0] = 0;
	points[1] = (10245.1973, -2726.4490, 7252.5591);
	angles[1] = (0, 124.7437, 0);
	at[1] = 0.5000;
	points[2] = (10207.3223, -2745.7402, 7252.5591);
	angles[2] = (0, 118.6410, 0);
	at[2] = 0.6000;
	points[3] = (10169.2529, -2764.6929, 7252.5591);
	angles[3] = (0, 117.0390, 0);
	at[3] = 0.7000;
	points[4] = (9940.8662, -2878.4058, 7252.5591);
	angles[4] = (0, 116.4699, 0);
	at[4] = 1.3000;
	points[5] = (9860.1973, -2904.9331, 7252.5591);
	angles[5] = (0, 107.9803, 0);
	at[5] = 1.5000;
	points[6] = (9657.0869, -2967.7324, 7252.5591);
	angles[6] = (0, 107.1823, 0);
	at[6] = 2;
	points[7] = (9636.7715, -2974.0120, 7252.5591);
	angles[7] = (0, 98.9536, 0);
	at[7] = 2.0500;
	points[8] = (9618.0322, -2959.8228, 7252.5591);
	angles[8] = (0, 82.1913, 0);
	at[8] = 2.1000;
	points[9] = (9598.9375, -2950.5120, 7252.5591);
	angles[9] = (0, 73.3676, 0);
	at[9] = 2.1500;
	points[10] = (9579.8027, -2941.2046, 7252.5591);
	angles[10] = (0, 68.8164, 0);
	at[10] = 2.2000;
	points[11] = (9484.2520, -2894.6575, 7252.5591);
	angles[11] = (0, 64.1993, 0);
	at[11] = 2.4500;
	points[12] = (9465.1182, -2885.3467, 7252.5591);
	angles[12] = (0, 58.3523, 0);
	at[12] = 2.5000;
	points[13] = (9454.5283, -2866.1377, 7252.5591);
	angles[13] = (0, 46.8335, 0);
	at[13] = 2.5500;
	points[14] = (9430.3936, -2831.1260, 7252.5591);
	angles[14] = (0, 37.7921, 0);
	at[14] = 2.6500;
	points[15] = (9345.9844, -2708.5825, 7252.5591);
	angles[15] = (0, 34.5993, 0);
	at[15] = 3;
	points[16] = (9345.4326, -2687.7363, 7252.5591);
	angles[16] = (0, 16.9372, 0);
	at[16] = 3.0500;
	points[17] = (9346.2598, -2666.4919, 7252.5591);
	angles[17] = (0, 7.6094, 0);
	at[17] = 3.1000;
	points[18] = (9347.1260, -2645.2480, 7252.5591);
	angles[18] = (0, 2.7940, 0);
	at[18] = 3.1500;
	points[19] = (9349.6455, -2581.5198, 7252.5591);
	angles[19] = (0, -1.5907, 0);
	at[19] = 3.3000;
	points[20] = (9354.6846, -2454.0591, 7252.5591);
	angles[20] = (0, -2.2585, 0);
	at[20] = 3.6000;
	points[21] = (9355.5508, -2432.8188, 7252.5591);
	angles[21] = (0, -8.3229, 0);
	at[21] = 3.6500;
	points[22] = (9369.5273, -2415.7834, 7252.5591);
	angles[22] = (0, -20.4113, 0);
	at[22] = 3.7000;
	points[23] = (9392.8740, -2380.2480, 7252.5591);
	angles[23] = (0, -29.9134, 0);
	at[23] = 3.8000;
	points[24] = (9427.8740, -2326.9409, 7252.5591);
	angles[24] = (0, -32.8465, 0);
	at[24] = 3.9500;
	points[25] = (9521.2598, -2184.7874, 7252.5591);
	angles[25] = (0, -33.2992, 0);
	at[25] = 4.3500;
	points[26] = (9534.2520, -2168.1143, 7252.5591);
	angles[26] = (0, -37.8983, 0);
	at[26] = 4.4000;
	points[27] = (9580.1973, -2123.8977, 7252.5591);
	angles[27] = (0, -45.0075, 0);
	at[27] = 4.5500;
	points[28] = (9825.3545, -1888.0787, 7252.5591);
	angles[28] = (0, -46.1111, 0);
	at[28] = 5.3500;
	points[29] = (9840.6699, -1873.3386, 7252.5591);
	angles[29] = (0, -50.1401, 0);
	at[29] = 5.4000;
	points[30] = (9860.5117, -1865.3701, 7252.5591);
	angles[30] = (0, -58.0776, 0);
	at[30] = 5.4500;
	points[31] = (9899.4883, -1848.3898, 7252.5591);
	angles[31] = (0, -64.2621, 0);
	at[31] = 5.5500;
	points[32] = (10094.4102, -1763.4922, 7252.5591);
	angles[32] = (0, -66.4601, 0);
	at[32] = 6.0500;
	points[33] = (10114.5674, -1757.8149, 7252.5591);
	angles[33] = (0, -73.5109, 0);
	at[33] = 6.1000;
	points[34] = (10135.7881, -1756.3976, 7252.5591);
	angles[34] = (0, -79.6814, 0);
	at[34] = 6.1500;
	points[35] = (10178.2285, -1753.5669, 7252.5591);
	angles[35] = (0, -84.4767, 0);
	at[35] = 6.2500;
	points[36] = (10432.7559, -1736.5787, 7252.5591);
	angles[36] = (0, -86.1814, 0);
	at[36] = 6.8500;
	points[37] = (10453.9766, -1735.1615, 7252.5591);
	angles[37] = (0, -92.7570, 0);
	at[37] = 6.9000;
	points[38] = (10471.6543, -1749.0591, 7252.5591);
	angles[38] = (0, -105.9283, 0);
	at[38] = 6.9500;
	points[39] = (10508.4648, -1770.3307, 7252.5591);
	angles[39] = (0, -116.3125, 0);
	at[39] = 7.0500;
	points[40] = (10618.8975, -1834.1417, 7252.5591);
	angles[40] = (0, -119.9508, 0);
	at[40] = 7.3500;
	points[41] = (10637.3223, -1844.7795, 7252.5591);
	angles[41] = (0, -125.8818, 0);
	at[41] = 7.4000;
	points[42] = (10647.7959, -1863.2913, 7252.5591);
	angles[42] = (0, -137.6512, 0);
	at[42] = 7.4500;
	points[43] = (10658.3857, -1881.7401, 7252.5591);
	angles[43] = (0, -143.7577, 0);
	at[43] = 7.5000;
	points[44] = (10679.5283, -1918.6339, 7252.5591);
	angles[44] = (0, -148.5029, 0);
	at[44] = 7.6000;
	points[45] = (10721.7725, -1992.4213, 7252.5591);
	angles[45] = (0, -150.0744, 0);
	at[45] = 7.8000;
	points[46] = (10732.3623, -2010.8662, 7252.5591);
	angles[46] = (0, -154.2174, 0);
	at[46] = 7.8500;
	points[47] = (10738.5039, -2053.0630, 7252.5591);
	angles[47] = (0, -166.4638, 0);
	at[47] = 7.9500;
	points[48] = (10752.0469, -2137.0198, 7252.5591);
	angles[48] = (0, -170.5397, 0);
	at[48] = 8.1500;
	points[49] = (10749.6846, -2157.7756, 7252.5591);
	angles[49] = (0, -181.8197, 0);
	at[49] = 8.2000;
	points[50] = (10744.6064, -2178.4172, 7252.5591);
	angles[50] = (0, -187.6657, 0);
	at[50] = 8.2500;
	points[51] = (10734.4492, -2219.7087, 7252.5591);
	angles[51] = (0, -192.2071, 0);
	at[51] = 8.3500;
	points[52] = (10719.2129, -2281.6418, 7252.5591);
	angles[52] = (0, -193.6052, 0);
	at[52] = 8.5000;
	points[53] = (10714.1348, -2302.2834, 7252.5591);
	angles[53] = (0, -198.0940, 0);
	at[53] = 8.5500;
	points[54] = (10700.1182, -2318.7876, 7252.5591);
	angles[54] = (0, -206.8003, 0);
	at[54] = 8.6000;
	points[55] = (10675.1182, -2353.1812, 7252.5591);
	angles[55] = (0, -213.5930, 0);
	at[55] = 8.7000;
	points[56] = (10600.1191, -2456.3662, 7252.5591);
	angles[56] = (0, -218.4975, 0);
	at[56] = 9;
	points[57] = (10568.1494, -2484.3701, 7252.5591);
	angles[57] = (0, -226.0313, 0);
	at[57] = 9.1000;
	points[58] = (10488.2686, -2554.5117, 7252.5591);
	angles[58] = (0, -228.6194, 0);
	at[58] = 9.3500;
	points[59] = (10419.9600, -2605.4094, 7252.5591);
	angles[59] = (0, -233.8313, 0);
	at[59] = 9.5500;
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
	points[0] = (11699.2529, -55.8854, 7252.5591);
	angles[0] = (0, 155.0282, 0);
	at[0] = 0;
	points[1] = (11680.8662, -109.5177, 7252.5591);
	angles[1] = (0, 160.0704, 0);
	at[1] = 0.1333;
	points[2] = (11653.3066, -189.9661, 7252.5591);
	angles[2] = (0, 161.0177, 0);
	at[2] = 0.3333;
	points[3] = (11663.5430, -214.6323, 7252.5591);
	angles[3] = (0, 190.0584, 0);
	at[3] = 0.4000;
	points[4] = (11678.3867, -238.7882, 7252.5591);
	angles[4] = (0, 202.6897, 0);
	at[4] = 0.4667;
	points[5] = (11693.1885, -262.9445, 7252.5591);
	angles[5] = (0, 207.9174, 0);
	at[5] = 0.5333;
	points[6] = (11767.3623, -383.7248, 7252.5591);
	angles[6] = (0, 211.5092, 0);
	at[6] = 0.8667;
	points[7] = (11802.2441, -428.3622, 7252.5591);
	angles[7] = (0, 217.4804, 0);
	at[7] = 1;
	points[8] = (11926.2998, -583.2520, 7252.5591);
	angles[8] = (0, 218.6831, 0);
	at[8] = 1.4667;
	points[9] = (11935.9053, -608.9725, 7252.5591);
	angles[9] = (0, 204.4324, 0);
	at[9] = 1.5333;
	points[10] = (11940.3945, -636.9606, 7252.5591);
	angles[10] = (0, 195.4219, 0);
	at[10] = 1.6000;
	points[11] = (11944.8818, -664.9489, 7252.5591);
	angles[11] = (0, 191.7118, 0);
	at[11] = 1.6667;
	points[12] = (11962.8740, -776.8937, 7252.5591);
	angles[12] = (0, 189.2081, 0);
	at[12] = 1.9333;
	points[13] = (11963.5830, -804.7401, 7252.5591);
	angles[13] = (0, 181.1212, 0);
	at[13] = 2;
	points[14] = (11957.0088, -832.3110, 7252.5591);
	angles[14] = (0, 172.5562, 0);
	at[14] = 2.0667;
	points[15] = (11950.4326, -859.8859, 7252.5591);
	angles[15] = (0, 169.0313, 0);
	at[15] = 2.1333;
	points[16] = (11910.9443, -1025.3229, 7252.5591);
	angles[16] = (0, 166.5954, 0);
	at[16] = 2.5333;
	points[17] = (11902.6777, -1052.2953, 7252.5591);
	angles[17] = (0, 162.3698, 0);
	at[17] = 2.6000;
	points[18] = (11878.5430, -1103.6063, 7252.5591);
	angles[18] = (0, 156.1012, 0);
	at[18] = 2.7333;
	points[19] = (11794.1729, -1283.2008, 7252.5591);
	angles[19] = (0, 154.8385, 0);
	at[19] = 3.2000;
	points[20] = (11757.6387, -1325.8544, 7252.5591);
	angles[20] = (0, 139.6016, 0);
	at[20] = 3.3333;
	points[21] = (11717.9141, -1366.3071, 7252.5591);
	angles[21] = (0, 136.2107, 0);
	at[21] = 3.4667;
	points[22] = (11618.6221, -1467.4449, 7252.5591);
	angles[22] = (0, 135.5349, 0);
	at[22] = 3.8000;
	points[23] = (11597.2842, -1485.7125, 7252.5591);
	angles[23] = (0, 129.1266, 0);
	at[23] = 3.8667;
	points[24] = (11547.0859, -1512.0118, 7252.5591);
	angles[24] = (0, 119.5687, 0);
	at[24] = 4;
	points[25] = (11421.4961, -1577.7560, 7252.5591);
	angles[25] = (0, 117.6591, 0);
	at[25] = 4.3333;
	points[26] = (11394.9609, -1582.9844, 7252.5591);
	angles[26] = (0, 105.4841, 0);
	at[26] = 4.4000;
	points[27] = (11366.8115, -1579.5787, 7252.5591);
	angles[27] = (0, 92.3367, 0);
	at[27] = 4.4667;
	points[28] = (11338.6621, -1576.1772, 7252.5591);
	angles[28] = (0, 86.8906, 0);
	at[28] = 4.5333;
	points[29] = (11282.4014, -1569.3701, 7252.5591);
	angles[29] = (0, 83.7399, 0);
	at[29] = 4.6667;
	points[30] = (11254.2520, -1565.9685, 7252.5591);
	angles[30] = (0, 75.2272, 0);
	at[30] = 4.7333;
	points[31] = (11235.9453, -1544.2323, 7252.5591);
	angles[31] = (0, 54.9322, 0);
	at[31] = 4.8000;
	points[32] = (11217.5586, -1522.6536, 7252.5591);
	angles[32] = (0, 46.3867, 0);
	at[32] = 4.8667;
	points[33] = (11162.4014, -1457.9213, 7252.5591);
	angles[33] = (0, 40.8376, 0);
	at[33] = 5.0667;
	points[34] = (11158.7803, -1430.3503, 7252.5591);
	angles[34] = (0, 19.2620, 0);
	at[34] = 5.1333;
	points[35] = (11156.9287, -1402.0669, 7252.5591);
	angles[35] = (0, 10.1422, 0);
	at[35] = 5.2000;
	points[36] = (11151.2998, -1317.2125, 7252.5591);
	angles[36] = (0, 4.2163, 0);
	at[36] = 5.4000;
	points[37] = (11149.4492, -1288.9292, 7252.5591);
	angles[37] = (0, -3.0625, 0);
	at[37] = 5.4667;
	points[38] = (11167.2451, -1265.6890, 7252.5591);
	angles[38] = (0, -20.3117, 0);
	at[38] = 5.5333;
	points[39] = (11182.5205, -1241.7914, 7252.5591);
	angles[39] = (0, -27.5173, 0);
	at[39] = 5.6000;
	points[40] = (11228.2285, -1170.0985, 7252.5591);
	angles[40] = (0, -32.1893, 0);
	at[40] = 5.8000;
	points[41] = (11246.2598, -1148.5079, 7252.5591);
	angles[41] = (0, -37.6862, 0);
	at[41] = 5.8667;
	points[42] = (11287.9141, -1110.0591, 7252.5591);
	angles[42] = (0, -45.6829, 0);
	at[42] = 6;
	points[43] = (11392.0479, -1013.9370, 7252.5591);
	angles[43] = (0, -47.2793, 0);
	at[43] = 6.3333;
	points[44] = (11437.6377, -980.4764, 7252.5591);
	angles[44] = (0, -53.9804, 0);
	at[44] = 6.4667;
	points[45] = (11484.8428, -949.0709, 7252.5591);
	angles[45] = (0, -55.9632, 0);
	at[45] = 6.6000;
	points[46] = (11815.2363, -729.2441, 7252.5591);
	angles[46] = (0, -56.3630, 0);
	at[46] = 7.5333;
	points[47] = (11837.9922, -712.3583, 7252.5591);
	angles[47] = (0, -53.6962, 0);
	at[47] = 7.6000;
	points[48] = (12145.9443, -462.0551, 7252.5591);
	angles[48] = (0, -48.5890, 0);
	at[48] = 8.5333;
	points[49] = (12181.8115, -418.1653, 7252.5591);
	angles[49] = (0, -40.8797, 0);
	at[49] = 8.6667;
	points[50] = (12289.6064, -286.5953, 7252.5591);
	angles[50] = (0, -39.3302, 0);
	at[50] = 9.0667;
	points[51] = (12302.5586, -261.8823, 7252.5591);
	angles[51] = (0, -29.3970, 0);
	at[51] = 9.1333;
	points[52] = (12311.7314, -235.0583, 7252.5591);
	angles[52] = (0, -23.1847, 0);
	at[52] = 9.2000;
	points[53] = (12357.5586, -100.9382, 7252.5591);
	angles[53] = (0, -18.9133, 0);
	at[53] = 9.5333;
	points[54] = (12364.2920, -73.7280, 7252.5591);
	angles[54] = (0, -11.8534, 0);
	at[54] = 9.6000;
	points[55] = (12363.8975, -45.3843, 7252.5591);
	angles[55] = (0, -4.3932, 0);
	at[55] = 9.6667;
	points[56] = (12363.5039, -17.0406, 7252.5591);
	angles[56] = (0, -1.3265, 0);
	at[56] = 9.7333;
	points[57] = (12360.7090, 181.3654, 7252.5591);
	angles[57] = (0, 0.7983, 0);
	at[57] = 10.2000;
	points[58] = (12360.3154, 209.7087, 7252.5591);
	angles[58] = (0, 8.8384, 0);
	at[58] = 10.2667;
	points[59] = (12337.2041, 228.9528, 7252.5591);
	angles[59] = (0, 28.6840, 0);
	at[59] = 10.3333;
	points[60] = (12317.9131, 249.7354, 7252.5591);
	angles[60] = (0, 37.0299, 0);
	at[60] = 10.4000;
	points[61] = (12279.3701, 291.3004, 7252.5591);
	angles[61] = (0, 45.3023, 0);
	at[61] = 10.5333;
	points[62] = (12253.8193, 304.2043, 7252.5591);
	angles[62] = (0, 54.0547, 0);
	at[62] = 10.6000;
	points[63] = (12229.2520, 318.3091, 7252.5591);
	angles[63] = (0, 57.6575, 0);
	at[63] = 10.6667;
	points[64] = (12130.9053, 374.7288, 7252.5591);
	angles[64] = (0, 60.0888, 0);
	at[64] = 10.9333;
	points[65] = (12106.0625, 377.2764, 7252.5591);
	angles[65] = (0, 79.5388, 0);
	at[65] = 11;
	points[66] = (12080.9844, 364.1047, 7252.5591);
	angles[66] = (0, 101.7300, 0);
	at[66] = 11.0667;
	points[67] = (12055.8662, 350.9331, 7252.5591);
	angles[67] = (0, 111.1281, 0);
	at[67] = 11.1333;
	points[68] = (12005.6699, 324.5901, 7252.5591);
	angles[68] = (0, 116.5869, 0);
	at[68] = 11.2667;
	points[69] = (11880.1582, 258.7331, 7252.5591);
	angles[69] = (0, 117.6755, 0);
	at[69] = 11.6000;
	points[70] = (11858.4258, 242.1764, 7252.5591);
	angles[70] = (0, 129.6191, 0);
	at[70] = 11.6667;
	points[71] = (11844.9209, 217.2531, 7252.5591);
	angles[71] = (0, 142.5056, 0);
	at[71] = 11.7333;
	points[72] = (11817.9131, 167.4071, 7252.5591);
	angles[72] = (0, 150.0304, 0);
	at[72] = 11.8667;
	points[73] = (11710, -32.0512, 7252.5591);
	angles[73] = (0, 151.6273, 0);
	at[73] = 12.4000;
	points[74] = (11699.2529, -55.8854, 7252.5591);
	angles[74] = (0, 155.0282, 0);
	at[74] = 12.4667;
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
	points[0] = (10600.6309, -779.6772, 7252.5591);
	angles[0] = (0, -46.6077, 0);
	at[0] = 0;
	points[1] = (10651.4570, -746.9330, 7252.5591);
	angles[1] = (0, -55.5675, 0);
	at[1] = 0.1333;
	points[2] = (10723.0713, -701.0866, 7252.5591);
	angles[2] = (0, -57.2517, 0);
	at[2] = 0.3333;
	points[3] = (10748.7012, -691.3386, 7252.5591);
	angles[3] = (0, -67.8439, 0);
	at[3] = 0.4000;
	points[4] = (10777.0078, -689.8897, 7252.5591);
	angles[4] = (0, -79.1546, 0);
	at[4] = 0.4667;
	points[5] = (10833.6230, -686.9921, 7252.5591);
	angles[5] = (0, -85.7422, 0);
	at[5] = 0.6000;
	points[6] = (11116.6934, -671.4764, 7252.5591);
	angles[6] = (0, -85.2799, 0);
	at[6] = 1.2667;
	points[7] = (11200.2363, -655.6024, 7252.5591);
	angles[7] = (0, -79.6770, 0);
	at[7] = 1.4667;
	points[8] = (11478.7402, -602.7913, 7252.5591);
	angles[8] = (0, -79.2634, 0);
	at[8] = 2.1333;
	points[9] = (12006.1016, -493.4724, 7252.5591);
	angles[9] = (0, -78.2759, 0);
	at[9] = 3.4000;
	points[10] = (12033.8584, -487.7126, 7252.5591);
	angles[10] = (0, -74.7436, 0);
	at[10] = 3.4667;
	points[11] = (12058.3857, -473.4095, 7252.5591);
	angles[11] = (0, -66.3370, 0);
	at[11] = 3.5333;
	points[12] = (12083.0713, -459.4409, 7252.5591);
	angles[12] = (0, -62.8779, 0);
	at[12] = 3.6000;
	points[13] = (12231.0635, -375.6280, 7252.5591);
	angles[13] = (0, -60.4875, 0);
	at[13] = 4;
	points[14] = (12255.7090, -361.6591, 7252.5591);
	angles[14] = (0, -54.5002, 0);
	at[14] = 4.0667;
	points[15] = (12267.2832, -334.5051, 7252.5591);
	angles[15] = (0, -40.0427, 0);
	at[15] = 4.1333;
	points[16] = (12281.3779, -309.9228, 7252.5591);
	angles[16] = (0, -34.0393, 0);
	at[16] = 4.2000;
	points[17] = (12351.9688, -187.0114, 7252.5591);
	angles[17] = (0, -29.9124, 0);
	at[17] = 4.5333;
	points[18] = (12357.2441, -159.2917, 7252.5591);
	angles[18] = (0, -17.7778, 0);
	at[18] = 4.6000;
	points[19] = (12361.8105, -131.3158, 7252.5591);
	angles[19] = (0, -12.7599, 0);
	at[19] = 4.6667;
	points[20] = (12389.2129, 36.5405, 7252.5591);
	angles[20] = (0, -9.2890, 0);
	at[20] = 5.0667;
	points[21] = (12379.3311, 62.9516, 7252.5591);
	angles[21] = (0, 8.7875, 0);
	at[21] = 5.1333;
	points[22] = (12368.8984, 89.3032, 7252.5591);
	angles[22] = (0, 16.3538, 0);
	at[22] = 5.2000;
	points[23] = (12327.0869, 194.7095, 7252.5591);
	angles[23] = (0, 21.4755, 0);
	at[23] = 5.4667;
	points[24] = (12316.6533, 221.0610, 7252.5591);
	angles[24] = (0, 29.1820, 0);
	at[24] = 5.5333;
	points[25] = (12291.3389, 234.2831, 7252.5591);
	angles[25] = (0, 47.9373, 0);
	at[25] = 5.6000;
	points[26] = (12266.4961, 247.9039, 7252.5591);
	angles[26] = (0, 55.8016, 0);
	at[26] = 5.6667;
	points[27] = (12216.7715, 275.1461, 7252.5591);
	angles[27] = (0, 60.3610, 0);
	at[27] = 5.8000;
	points[28] = (12142.2041, 316.0087, 7252.5591);
	angles[28] = (0, 61.2175, 0);
	at[28] = 6;
	points[29] = (12114.5283, 312.0370, 7252.5591);
	angles[29] = (0, 84.1063, 0);
	at[29] = 6.0667;
	points[30] = (12086.6543, 306.8193, 7252.5591);
	angles[30] = (0, 93.8221, 0);
	at[30] = 6.1333;
	points[31] = (12030.9453, 296.3842, 7252.5591);
	angles[31] = (0, 99.4675, 0);
	at[31] = 6.2667;
	points[32] = (11919.4883, 275.5138, 7252.5591);
	angles[32] = (0, 100.5746, 0);
	at[32] = 6.5333;
	points[33] = (11900.6299, 255.1567, 7252.5591);
	angles[33] = (0, 124.0106, 0);
	at[33] = 6.6000;
	points[34] = (11882.7949, 233.1465, 7252.5591);
	angles[34] = (0, 133.9769, 0);
	at[34] = 6.6667;
	points[35] = (11847.0479, 189.1256, 7252.5591);
	angles[35] = (0, 139.7702, 0);
	at[35] = 6.8000;
	points[36] = (11775.5908, 101.0843, 7252.5591);
	angles[36] = (0, 140.9062, 0);
	at[36] = 7.0667;
	points[37] = (11763.5439, 75.4634, 7252.5591);
	angles[37] = (0, 149.3361, 0);
	at[37] = 7.1333;
	points[38] = (11739.7637, 23.9935, 7252.5591);
	angles[38] = (0, 154.2266, 0);
	at[38] = 7.2667;
	points[39] = (11597.1650, -284.8264, 7252.5591);
	angles[39] = (0, 155.2131, 0);
	at[39] = 8.0667;
	points[40] = (11565.7480, -363.8417, 7252.5591);
	angles[40] = (0, 158.3469, 0);
	at[40] = 8.2667;
	points[41] = (11410.9062, -759.8347, 7252.5591);
	angles[41] = (0, 158.6415, 0);
	at[41] = 9.2667;
	points[42] = (11391.3779, -779.9803, 7252.5591);
	angles[42] = (0, 143.5915, 0);
	at[42] = 9.3333;
	points[43] = (11349.8818, -818.6339, 7252.5591);
	angles[43] = (0, 134.7657, 0);
	at[43] = 9.4667;
	points[44] = (11121.7725, -1031.2166, 7252.5591);
	angles[44] = (0, 132.9825, 0);
	at[44] = 10.2000;
	points[45] = (11101.0635, -1050.5433, 7252.5591);
	angles[45] = (0, 129.2489, 0);
	at[45] = 10.2667;
	points[46] = (11074.6074, -1061.2914, 7252.5591);
	angles[46] = (0, 120.3550, 0);
	at[46] = 10.3333;
	points[47] = (11048.7402, -1072.8898, 7252.5591);
	angles[47] = (0, 116.6936, 0);
	at[47] = 10.4000;
	points[48] = (10867.7168, -1154.0748, 7252.5591);
	angles[48] = (0, 114.1559, 0);
	at[48] = 10.8667;
	points[49] = (10840.9443, -1159.9370, 7252.5591);
	angles[49] = (0, 103.2075, 0);
	at[49] = 10.9333;
	points[50] = (10812.7949, -1156.5867, 7252.5591);
	angles[50] = (0, 91.4480, 0);
	at[50] = 11;
	points[51] = (10784.6455, -1153.2362, 7252.5591);
	angles[51] = (0, 86.5878, 0);
	at[51] = 11.0667;
	points[52] = (10700.2363, -1143.1812, 7252.5591);
	angles[52] = (0, 83.4428, 0);
	at[52] = 11.2667;
	points[53] = (10676.3779, -1128.3661, 7252.5591);
	angles[53] = (0, 67.1262, 0);
	at[53] = 11.3333;
	points[54] = (10652.9922, -1112.3464, 7252.5591);
	angles[54] = (0, 60.3247, 0);
	at[54] = 11.4000;
	points[55] = (10582.8340, -1064.2914, 7252.5591);
	angles[55] = (0, 55.9164, 0);
	at[55] = 11.6000;
	points[56] = (10570.4336, -1038.8977, 7252.5591);
	angles[56] = (0, 38.0120, 0);
	at[56] = 11.6667;
	points[57] = (10558.3467, -1013.2717, 7252.5591);
	angles[57] = (0, 30.5208, 0);
	at[57] = 11.7333;
	points[58] = (10534.0947, -962.0157, 7252.5591);
	angles[58] = (0, 26.1793, 0);
	at[58] = 11.8667;
	points[59] = (10535.3545, -933.7913, 7252.5591);
	angles[59] = (0, 8.9342, 0);
	at[59] = 11.9333;
	points[60] = (10536.9688, -905.4882, 7252.5591);
	angles[60] = (0, 1.7303, 0);
	at[60] = 12;
	points[61] = (10538.5820, -877.1890, 7252.5591);
	angles[61] = (0, -1.2302, 0);
	at[61] = 12.0667;
	points[62] = (10546.0234, -850.4134, 7252.5591);
	angles[62] = (0, -13.5437, 0);
	at[62] = 12.1333;
	points[63] = (10571.0635, -799.5591, 7252.5591);
	angles[63] = (0, -29.6911, 0);
	at[63] = 12.2667;
	points[64] = (10600.6309, -779.6772, 7252.5591);
	angles[64] = (0, -46.6077, 0);
	at[64] = 12.3500;
	mover = getEnt("iz_obj_5", "targetname");
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
