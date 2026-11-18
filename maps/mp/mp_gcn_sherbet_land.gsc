main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_sherbet_land", 0);

	setExpFog(0, 15255.9043, 0.4510, 0.6980, 0.9020, 0);

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
	ambientPlay("iz_0_64", 2);
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
	level.iz_route[level.iz_route.size] = (2183, 257, 586);
	level.iz_route[level.iz_route.size] = (2200, -793, 579);
	level.iz_route[level.iz_route.size] = (1998, -1963, 555);
	level.iz_route[level.iz_route.size] = (1294, -2509, 515);
	level.iz_route[level.iz_route.size] = (577, -2940, 511);
	level.iz_route[level.iz_route.size] = (290, -3810, 464);
	level.iz_route[level.iz_route.size] = (177, -4958, 452);
	level.iz_route[level.iz_route.size] = (-148, -6107, 452);
	level.iz_route[level.iz_route.size] = (-876, -6721, 452);
	level.iz_route[level.iz_route.size] = (-1944, -6762, 452);
	level.iz_route[level.iz_route.size] = (-3031, -6531, 452);
	level.iz_route[level.iz_route.size] = (-4037, -6133, 452);
	level.iz_route[level.iz_route.size] = (-4968, -5561, 452);
	level.iz_route[level.iz_route.size] = (-5904, -5305, 460);
	level.iz_route[level.iz_route.size] = (-6904, -5009, 524);
	level.iz_route[level.iz_route.size] = (-7864, -4353, 572);
	level.iz_route[level.iz_route.size] = (-8162, -3409, 614);
	level.iz_route[level.iz_route.size] = (-7945, -2521, 669);
	level.iz_route[level.iz_route.size] = (-7396, -1872, 661);
	level.iz_route[level.iz_route.size] = (-6607, -1652, 615);
	level.iz_route[level.iz_route.size] = (-5877, -1712, 641);
	level.iz_route[level.iz_route.size] = (-5289, -1814, 721);
	level.iz_route[level.iz_route.size] = (-4653, -1756, 810);
	level.iz_route[level.iz_route.size] = (-4211, -1119, 768);
	level.iz_route[level.iz_route.size] = (-4296, -146, 610);
	level.iz_route[level.iz_route.size] = (-4638, 806, 422);
	level.iz_route[level.iz_route.size] = (-4975, 1730, 258);
	level.iz_route[level.iz_route.size] = (-4717, 2519, 227);
	level.iz_route[level.iz_route.size] = (-4241, 3215, 273);
	level.iz_route[level.iz_route.size] = (-3795, 3968, 353);
	level.iz_route[level.iz_route.size] = (-4041, 4793, 385);
	level.iz_route[level.iz_route.size] = (-4846, 5037, 431);
	level.iz_route[level.iz_route.size] = (-5747, 4942, 478);
	level.iz_route[level.iz_route.size] = (-6612, 5044, 526);
	level.iz_route[level.iz_route.size] = (-7147, 5754, 583);
	level.iz_route[level.iz_route.size] = (-7325, 6769, 611);
	level.iz_route[level.iz_route.size] = (-7444, 7756, 599);
	level.iz_route[level.iz_route.size] = (-7630, 8726, 588);
	level.iz_route[level.iz_route.size] = (-7412, 9560, 584);
	level.iz_route[level.iz_route.size] = (-6674, 9895, 584);
	level.iz_route[level.iz_route.size] = (-5567, 9844, 584);
	level.iz_route[level.iz_route.size] = (-4555, 9761, 584);
	level.iz_route[level.iz_route.size] = (-3505, 9536, 584);
	level.iz_route[level.iz_route.size] = (-2231, 9026, 584);
	level.iz_route[level.iz_route.size] = (-1255, 8285, 584);
	level.iz_route[level.iz_route.size] = (-702, 7286, 584);
	level.iz_route[level.iz_route.size] = (110, 6746, 584);
	level.iz_route[level.iz_route.size] = (1107, 6364, 583);
	level.iz_route[level.iz_route.size] = (1777, 5557, 582);
	level.iz_route[level.iz_route.size] = (2141, 4094, 582);
	level.iz_route[level.iz_route.size] = (2188, 2615, 584);
	level.iz_route[level.iz_route.size] = (2184, 1322, 587);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2306.4844, -6677.7168, 451.6890);
	angles[0] = (0, 73.5551, 0);
	at[0] = 0;
	points[1] = (-2353.8662, -6648.6221, 451.6890);
	angles[1] = (0, 60.9017, 0);
	at[1] = 0.1000;
	points[2] = (-2396.3779, -6612.6377, 451.6890);
	angles[2] = (0, 51.8830, 0);
	at[2] = 0.2000;
	points[3] = (-2438.8347, -6570.8271, 451.6890);
	angles[3] = (0, 46.7066, 0);
	at[3] = 0.3000;
	points[4] = (-2476.0393, -6530.8267, 451.6890);
	angles[4] = (0, 43.6743, 0);
	at[4] = 0.4000;
	points[5] = (-2587, -6400.0396, 451.6890);
	angles[5] = (0, 39.5976, 0);
	at[5] = 0.7000;
	points[6] = (-2872.1221, -6044.6851, 451.6890);
	angles[6] = (0, 39.8243, 0);
	at[6] = 1.5000;
	points[7] = (-2948.7637, -5959.9214, 451.6890);
	angles[7] = (0, 42.9023, 0);
	at[7] = 1.7000;
	points[8] = (-2989.6416, -5921.3384, 451.6890);
	angles[8] = (0, 46.4558, 0);
	at[8] = 1.8000;
	points[9] = (-3037.3347, -5888.3862, 451.6890);
	angles[9] = (0, 55.4169, 0);
	at[9] = 1.9000;
	points[10] = (-3088.5237, -5880, 451.6890);
	angles[10] = (0, 77.0698, 0);
	at[10] = 2;
	points[11] = (-3144.3267, -5887.9917, 451.6890);
	angles[11] = (0, 93.9969, 0);
	at[11] = 2.1000;
	points[12] = (-3199.5828, -5903.4253, 451.6890);
	angles[12] = (0, 103.3166, 0);
	at[12] = 2.2000;
	points[13] = (-3254.0042, -5923.1104, 451.6890);
	angles[13] = (0, 108.6215, 0);
	at[13] = 2.3000;
	points[14] = (-3305.6260, -5944.8423, 451.6890);
	angles[14] = (0, 112.0515, 0);
	at[14] = 2.4000;
	points[15] = (-3408.1812, -5994.9214, 451.6890);
	angles[15] = (0, 116.6140, 0);
	at[15] = 2.6000;
	points[16] = (-3507.3032, -6051.2598, 451.6890);
	angles[16] = (0, 120.1678, 0);
	at[16] = 2.8000;
	points[17] = (-3602.2952, -6113.4644, 451.6890);
	angles[17] = (0, 123.9303, 0);
	at[17] = 3;
	points[18] = (-3692.0317, -6184.5278, 451.6890);
	angles[18] = (0, 129.7231, 0);
	at[18] = 3.2000;
	points[19] = (-3730.7441, -6224.7637, 451.6890);
	angles[19] = (0, 135.7195, 0);
	at[19] = 3.3000;
	points[20] = (-3754.9766, -6272.1655, 451.6890);
	angles[20] = (0, 153.6357, 0);
	at[20] = 3.4000;
	points[21] = (-3753.8032, -6328.9375, 451.6890);
	angles[21] = (0, 175.8647, 0);
	at[21] = 3.5000;
	points[22] = (-3743.3503, -6386.3384, 451.6890);
	angles[22] = (0, 187.2286, 0);
	at[22] = 3.6000;
	points[23] = (-3712.9766, -6495.0396, 451.6890);
	angles[23] = (0, 196.1093, 0);
	at[23] = 3.8000;
	points[24] = (-3653.6970, -6655.4722, 451.6890);
	angles[24] = (0, 201.4817, 0);
	at[24] = 4.1000;
	points[25] = (-3582.7363, -6811.1421, 451.6890);
	angles[25] = (0, 205.7061, 0);
	at[25] = 4.4000;
	points[26] = (-3528.1140, -6911.3389, 451.6890);
	angles[26] = (0, 209.3335, 0);
	at[26] = 4.6000;
	points[27] = (-3464.6929, -7004.6064, 451.6890);
	angles[27] = (0, 215.8155, 0);
	at[27] = 4.8000;
	points[28] = (-3424.9331, -7046.4175, 451.6890);
	angles[28] = (0, 223.1954, 0);
	at[28] = 4.9000;
	points[29] = (-3380.7715, -7073.2285, 451.6890);
	angles[29] = (0, 236.5290, 0);
	at[29] = 5;
	points[30] = (-3327.4961, -7093.7402, 451.6890);
	angles[30] = (0, 246.5531, 0);
	at[30] = 5.1000;
	points[31] = (-3270.7126, -7110.6689, 451.6890);
	angles[31] = (0, 252.0121, 0);
	at[31] = 5.2000;
	points[32] = (-3217.6731, -7124.0156, 451.6890);
	angles[32] = (0, 255.1019, 0);
	at[32] = 5.3000;
	points[33] = (-3106.0356, -7147.5591, 451.6890);
	angles[33] = (0, 258.4191, 0);
	at[33] = 5.5000;
	points[34] = (-2824.6143, -7192.3228, 451.6890);
	angles[34] = (0, 262.0109, 0);
	at[34] = 6;
	points[35] = (-2655.9253, -7213.1890, 451.6890);
	angles[35] = (0, 263.2827, 0);
	at[35] = 6.3000;
	points[36] = (-2484.4172, -7230.8267, 451.6890);
	angles[36] = (0, 264.4661, 0);
	at[36] = 6.6000;
	points[37] = (-2429.9331, -7235.5903, 451.6890);
	angles[37] = (0, 264.9223, 0);
	at[37] = 6.7000;
	points[38] = (-2371.2126, -7240.1182, 451.6890);
	angles[38] = (0, 265.5269, 0);
	at[38] = 6.8000;
	points[39] = (-2320.7244, -7243.1895, 451.6890);
	angles[39] = (0, 266.4587, 0);
	at[39] = 6.9000;
	points[40] = (-2261.1536, -7245.5903, 451.6890);
	angles[40] = (0, 267.4872, 0);
	at[40] = 7;
	points[41] = (-2206.6338, -7247.1260, 451.6890);
	angles[41] = (0, 268.2114, 0);
	at[41] = 7.1000;
	points[42] = (-1978.2362, -7249.6851, 451.6890);
	angles[42] = (0, 269.7780, 0);
	at[42] = 7.5000;
	points[43] = (-1636.5670, -7244.8423, 451.6890);
	angles[43] = (0, 271.5058, 0);
	at[43] = 8.1000;
	points[44] = (-1352.0511, -7230.7480, 451.6890);
	angles[44] = (0, 273.8552, 0);
	at[44] = 8.6000;
	points[45] = (-1238.3503, -7220.1187, 451.6890);
	angles[45] = (0, 275.7658, 0);
	at[45] = 8.8000;
	points[46] = (-1127.2716, -7202.5986, 451.6890);
	angles[46] = (0, 280.2131, 0);
	at[46] = 9;
	points[47] = (-1077.2638, -7189.0552, 451.6890);
	angles[47] = (0, 284.3836, 0);
	at[47] = 9.1000;
	points[48] = (-969.2677, -7151.0239, 451.6890);
	angles[48] = (0, 289.9007, 0);
	at[48] = 9.3000;
	points[49] = (-810.7953, -7085, 451.6890);
	angles[49] = (0, 293.3045, 0);
	at[49] = 9.6000;
	points[50] = (-605.0157, -6989.0942, 451.6890);
	angles[50] = (0, 295.7037, 0);
	at[50] = 10;
	points[51] = (-401.9724, -6885.3149, 451.6890);
	angles[51] = (0, 297.7853, 0);
	at[51] = 10.4000;
	points[52] = (-253.1181, -6802.1260, 451.6890);
	angles[52] = (0, 299.8507, 0);
	at[52] = 10.7000;
	points[53] = (-156.3295, -6742.4805, 451.6890);
	angles[53] = (0, 302.1686, 0);
	at[53] = 10.9000;
	points[54] = (-108.4055, -6709.6851, 451.6890);
	angles[54] = (0, 304.1852, 0);
	at[54] = 11;
	points[55] = (-67.5811, -6677.6777, 451.6890);
	angles[55] = (0, 307.8488, 0);
	at[55] = 11.1000;
	points[56] = (12.4970, -6598.7793, 451.6890);
	angles[56] = (0, 315.3251, 0);
	at[56] = 11.3000;
	points[57] = (52.1461, -6555.1182, 451.6890);
	angles[57] = (0, 317.3067, 0);
	at[57] = 11.4000;
	points[58] = (125.6803, -6469.1733, 451.6890);
	angles[58] = (0, 319.6926, 0);
	at[58] = 11.6000;
	points[59] = (266.5500, -6290.9844, 451.6890);
	angles[59] = (0, 322.5103, 0);
	at[59] = 12;
	points[60] = (400.0512, -6106.1416, 451.6890);
	angles[60] = (0, 325.0373, 0);
	at[60] = 12.4000;
	points[61] = (462.9213, -6011.6147, 451.6890);
	angles[61] = (0, 326.7022, 0);
	at[61] = 12.6000;
	points[62] = (522.1339, -5914.1338, 451.6890);
	angles[62] = (0, 329.2863, 0);
	at[62] = 12.8000;
	points[63] = (548.9803, -5864.2520, 451.6890);
	angles[63] = (0, 331.5071, 0);
	at[63] = 12.9000;
	points[64] = (572.8819, -5810.9844, 451.6890);
	angles[64] = (0, 335.5803, 0);
	at[64] = 13;
	points[65] = (585.2520, -5761.9292, 451.6890);
	angles[65] = (0, 345.0432, 0);
	at[65] = 13.1000;
	points[66] = (587.7993, -5704.3706, 451.6890);
	angles[66] = (0, 355.3152, 0);
	at[66] = 13.2000;
	points[67] = (584.4803, -5646.3389, 451.6890);
	angles[67] = (0, 361.7210, 0);
	at[67] = 13.3000;
	points[68] = (578.0866, -5591.1416, 451.6890);
	angles[68] = (0, 365.6801, 0);
	at[68] = 13.4000;
	points[69] = (558.5670, -5478.6616, 451.6890);
	angles[69] = (0, 370.3694, 0);
	at[69] = 13.6000;
	points[70] = (532.8544, -5367.5591, 451.6890);
	angles[70] = (0, 373.4771, 0);
	at[70] = 13.8000;
	points[71] = (501.8780, -5257.9531, 451.6890);
	angles[71] = (0, 376.2527, 0);
	at[71] = 14;
	points[72] = (465.2599, -5150.7876, 451.6890);
	angles[72] = (0, 379.5188, 0);
	at[72] = 14.2000;
	points[73] = (418.4213, -5045.2363, 451.6890);
	angles[73] = (0, 385.4113, 0);
	at[73] = 14.4000;
	points[74] = (386.5642, -4997.8740, 451.6890);
	angles[74] = (0, 393.6763, 0);
	at[74] = 14.5000;
	points[75] = (338.7524, -4980.7876, 451.6890);
	angles[75] = (0, 426.7767, 0);
	at[75] = 14.6000;
	points[76] = (283.1795, -4992.3228, 451.6890);
	angles[76] = (0, 453.8649, 0);
	at[76] = 14.7000;
	points[77] = (230.2118, -5010.9058, 451.6890);
	angles[77] = (0, 465.9031, 0);
	at[77] = 14.8000;
	points[78] = (177.2598, -5033.3857, 451.6890);
	angles[78] = (0, 471.5540, 0);
	at[78] = 14.9000;
	points[79] = (75.2402, -5083.8975, 451.6890);
	angles[79] = (0, 476.8199, 0);
	at[79] = 15.1000;
	points[80] = (-72.5189, -5170.0396, 451.6890);
	angles[80] = (0, 481.4088, 0);
	at[80] = 15.4000;
	points[81] = (-167.2744, -5233.9761, 451.6890);
	angles[81] = (0, 484.6168, 0);
	at[81] = 15.6000;
	points[82] = (-211.8346, -5267.5591, 451.6890);
	angles[82] = (0, 486.7579, 0);
	at[82] = 15.7000;
	points[83] = (-256.3382, -5305.1577, 451.6890);
	angles[83] = (0, 489.8976, 0);
	at[83] = 15.8000;
	points[84] = (-296.0819, -5346.5747, 451.6890);
	angles[84] = (0, 495.8236, 0);
	at[84] = 15.9000;
	points[85] = (-320.0213, -5392.0469, 451.6890);
	angles[85] = (0, 510.6932, 0);
	at[85] = 16;
	points[86] = (-332.1433, -5447.5591, 451.6890);
	angles[86] = (0, 524.4207, 0);
	at[86] = 16.1000;
	points[87] = (-342.3792, -5561.8110, 451.6890);
	angles[87] = (0, 535.3324, 0);
	at[87] = 16.3000;
	points[88] = (-346.8571, -5789.5669, 451.6890);
	angles[88] = (0, 539.4359, 0);
	at[88] = 16.7000;
	points[89] = (-352.1390, -6016.4565, 451.6890);
	angles[89] = (0, 537.6014, 0);
	at[89] = 17.1000;
	points[90] = (-363.0886, -6131.1021, 451.6890);
	angles[90] = (0, 533.4507, 0);
	at[90] = 17.3000;
	points[91] = (-374.2000, -6184.9609, 451.6890);
	angles[91] = (0, 528.6531, 0);
	at[91] = 17.4000;
	points[92] = (-396.4489, -6236.6533, 451.6890);
	angles[92] = (0, 516.4973, 0);
	at[92] = 17.5000;
	points[93] = (-435.6850, -6277.6377, 451.6890);
	angles[93] = (0, 500.0426, 0);
	at[93] = 17.6000;
	points[94] = (-479.5630, -6311.4961, 451.6890);
	angles[94] = (0, 490.2455, 0);
	at[94] = 17.7000;
	points[95] = (-526.6693, -6342.7559, 451.6890);
	angles[95] = (0, 484.8850, 0);
	at[95] = 17.8000;
	points[96] = (-625.3347, -6399.8823, 451.6890);
	angles[96] = (0, 479.6026, 0);
	at[96] = 18;
	points[97] = (-726.7835, -6451.8506, 451.6890);
	angles[97] = (0, 476.7769, 0);
	at[97] = 18.2000;
	points[98] = (-934.5316, -6544.8823, 451.6890);
	angles[98] = (0, 472.9029, 0);
	at[98] = 18.6000;
	points[99] = (-1040.0787, -6585.9844, 451.6890);
	angles[99] = (0, 470.8944, 0);
	at[99] = 18.8000;
	points[100] = (-1149.1141, -6622.5591, 451.6890);
	angles[100] = (0, 467.8444, 0);
	at[100] = 19;
	points[101] = (-1200.6300, -6636.0630, 451.6890);
	angles[101] = (0, 464.8856, 0);
	at[101] = 19.1000;
	points[102] = (-1256.2284, -6646.8506, 451.6890);
	angles[102] = (0, 461.7186, 0);
	at[102] = 19.2000;
	points[103] = (-1424.0787, -6671.1025, 451.6890);
	angles[103] = (0, 457.5167, 0);
	at[103] = 19.5000;
	points[104] = (-1594.6497, -6689.3306, 451.6890);
	angles[104] = (0, 455.6407, 0);
	at[104] = 19.8000;
	points[105] = (-1764.8622, -6702.5591, 451.6890);
	angles[105] = (0, 453.9636, 0);
	at[105] = 20.1000;
	points[106] = (-1935.7677, -6710.0791, 451.6890);
	angles[106] = (0, 451.8970, 0);
	at[106] = 20.4000;
	points[107] = (-2049.5393, -6710.7085, 451.6890);
	angles[107] = (0, 449.9161, 0);
	at[107] = 20.6000;
	points[108] = (-2163.4409, -6705.5513, 451.6890);
	angles[108] = (0, 446.6896, 0);
	at[108] = 20.8000;
	points[109] = (-2219.1101, -6699.3306, 451.6890);
	angles[109] = (0, 443.9301, 0);
	at[109] = 20.9000;
	points[110] = (-2276.5276, -6687.9136, 451.6890);
	angles[110] = (0, 439.1051, 0);
	at[110] = 21;
	points[111] = (-2306.4844, -6677.7168, 451.6890);
	angles[111] = (0, 433.5552, 0);
	at[111] = 21.0667;
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
	points[0] = (-3052.9648, -5882.8345, 451.6890);
	angles[0] = (0, 62.2386, 0);
	at[0] = 0;
	points[1] = (-3109.5354, -5881.7720, 451.6890);
	angles[1] = (0, 84.2447, 0);
	at[1] = 0.1000;
	points[2] = (-3164.9646, -5893.1104, 451.6890);
	angles[2] = (0, 97.9528, 0);
	at[2] = 0.2000;
	points[3] = (-3218.4175, -5909.8027, 451.6890);
	angles[3] = (0, 105.4943, 0);
	at[3] = 0.3000;
	points[4] = (-3272.3503, -5930.5513, 451.6890);
	angles[4] = (0, 109.9936, 0);
	at[4] = 0.4000;
	points[5] = (-3375.6025, -5978.1099, 451.6890);
	angles[5] = (0, 115.3334, 0);
	at[5] = 0.6000;
	points[6] = (-3524.1970, -6061.6538, 451.6890);
	angles[6] = (0, 120.7833, 0);
	at[6] = 0.9000;
	points[7] = (-3618.5945, -6125.1968, 451.6890);
	angles[7] = (0, 124.7077, 0);
	at[7] = 1.1000;
	points[8] = (-3664.1223, -6160.3936, 451.6890);
	angles[8] = (0, 127.4073, 0);
	at[8] = 1.2000;
	points[9] = (-3707.1497, -6198.9370, 451.6890);
	angles[9] = (0, 131.4253, 0);
	at[9] = 1.3000;
	points[10] = (-3743.6418, -6242.7168, 451.6890);
	angles[10] = (0, 139.7744, 0);
	at[10] = 1.4000;
	points[11] = (-3756.3782, -6292.0869, 451.6890);
	angles[11] = (0, 162.7344, 0);
	at[11] = 1.5000;
	points[12] = (-3750.8818, -6348.5435, 451.6890);
	angles[12] = (0, 180.8312, 0);
	at[12] = 1.6000;
	points[13] = (-3738.9688, -6404.8037, 451.6890);
	angles[13] = (0, 189.6468, 0);
	at[13] = 1.7000;
	points[14] = (-3723.6221, -6460.7876, 451.6890);
	angles[14] = (0, 194.1920, 0);
	at[14] = 1.8000;
	points[15] = (-3687.5945, -6568.5435, 451.6890);
	angles[15] = (0, 198.9435, 0);
	at[15] = 2;
	points[16] = (-3623.1458, -6726.2598, 451.6890);
	angles[16] = (0, 203.3501, 0);
	at[16] = 2.3000;
	points[17] = (-3546.7559, -6879.0161, 451.6890);
	angles[17] = (0, 207.9905, 0);
	at[17] = 2.6000;
	points[18] = (-3486.0945, -6976.2603, 451.6890);
	angles[18] = (0, 213.1049, 0);
	at[18] = 2.8000;
	points[19] = (-3451.4766, -7020.1973, 451.6890);
	angles[19] = (0, 217.7441, 0);
	at[19] = 2.9000;
	points[20] = (-3411.1455, -7056.7720, 451.6890);
	angles[20] = (0, 227.6209, 0);
	at[20] = 3;
	points[21] = (-3360.0356, -7082.0078, 451.6890);
	angles[21] = (0, 240.7743, 0);
	at[21] = 3.1000;
	points[22] = (-3308.3779, -7099.8428, 451.6890);
	angles[22] = (0, 248.8484, 0);
	at[22] = 3.2000;
	points[23] = (-3197.6968, -7128.6221, 451.6890);
	angles[23] = (0, 255.8845, 0);
	at[23] = 3.4000;
	points[24] = (-3086.1104, -7151.2993, 451.6890);
	angles[24] = (0, 258.8093, 0);
	at[24] = 3.6000;
	points[25] = (-2917.1494, -7179.2520, 451.6890);
	angles[25] = (0, 261.1411, 0);
	at[25] = 3.9000;
	points[26] = (-2691.5945, -7209.0552, 451.6890);
	angles[26] = (0, 263.0307, 0);
	at[26] = 4.3000;
	points[27] = (-2464.6616, -7232.5981, 451.6890);
	angles[27] = (0, 264.6222, 0);
	at[27] = 4.7000;
	points[28] = (-2407.8464, -7237.4019, 451.6890);
	angles[28] = (0, 265.1128, 0);
	at[28] = 4.8000;
	points[29] = (-2300.4724, -7244.0947, 451.6890);
	angles[29] = (0, 266.8450, 0);
	at[29] = 5;
	points[30] = (-2242.5867, -7246.1421, 451.6890);
	angles[30] = (0, 267.7767, 0);
	at[30] = 5.1000;
	points[31] = (-2014.1458, -7249.6064, 451.6890);
	angles[31] = (0, 269.5874, 0);
	at[31] = 5.5000;
	points[32] = (-1787.2914, -7248.2681, 451.6890);
	angles[32] = (0, 270.7076, 0);
	at[32] = 5.9000;
	points[33] = (-1559.6378, -7242.2046, 451.6890);
	angles[33] = (0, 271.9843, 0);
	at[33] = 6.3000;
	points[34] = (-1388.5118, -7233.3467, 451.6890);
	angles[34] = (0, 273.4238, 0);
	at[34] = 6.6000;
	points[35] = (-1275.0472, -7224.0552, 451.6890);
	angles[35] = (0, 275.0052, 0);
	at[35] = 6.8000;
	points[36] = (-1161.4922, -7209.2915, 451.6890);
	angles[36] = (0, 278.1790, 0);
	at[36] = 7;
	points[37] = (-1110.5984, -7198.5435, 451.6890);
	angles[37] = (0, 281.6748, 0);
	at[37] = 7.1000;
	points[38] = (-1003.8150, -7164.0552, 451.6890);
	angles[38] = (0, 288.6123, 0);
	at[38] = 7.3000;
	points[39] = (-897.6969, -7122.2837, 451.6890);
	angles[39] = (0, 291.7989, 0);
	at[39] = 7.5000;
	points[40] = (-741.1969, -7053.6611, 451.6890);
	angles[40] = (0, 294.2294, 0);
	at[40] = 7.8000;
	points[41] = (-586.9016, -6980.1968, 451.6890);
	angles[41] = (0, 295.8847, 0);
	at[41] = 8.1000;
	points[42] = (-434.8740, -6902.7949, 451.6890);
	angles[42] = (0, 297.4251, 0);
	at[42] = 8.4000;
	points[43] = (-335.3803, -6849.0156, 451.6890);
	angles[43] = (0, 298.6056, 0);
	at[43] = 8.6000;
	points[44] = (-186.5854, -6761.8506, 451.6890);
	angles[44] = (0, 301.2561, 0);
	at[44] = 8.9000;
	points[45] = (-140.9051, -6732.2837, 451.6890);
	angles[45] = (0, 302.7502, 0);
	at[45] = 9;
	points[46] = (-92.5272, -6697.8745, 451.6890);
	angles[46] = (0, 305.2463, 0);
	at[46] = 9.1000;
	points[47] = (-53.7921, -6665.3545, 451.6890);
	angles[47] = (0, 309.4872, 0);
	at[47] = 9.2000;
	points[48] = (-11.4905, -6623.9761, 451.6890);
	angles[48] = (0, 313.5153, 0);
	at[48] = 9.3000;
	points[49] = (64.9937, -6540.5117, 451.6890);
	angles[49] = (0, 317.8465, 0);
	at[49] = 9.5000;
	points[50] = (173.9091, -6410.0396, 451.6890);
	angles[50] = (0, 320.7904, 0);
	at[50] = 9.8000;
	points[51] = (312.6685, -6229.0552, 451.6890);
	angles[51] = (0, 323.3236, 0);
	at[51] = 10.2000;
	points[52] = (442.6811, -6042.7954, 451.6890);
	angles[52] = (0, 326.1082, 0);
	at[52] = 10.6000;
	points[53] = (532.3819, -5895.7480, 451.6890);
	angles[53] = (0, 329.9694, 0);
	at[53] = 10.9000;
	points[54] = (557.2244, -5847.4019, 451.6890);
	angles[54] = (0, 332.5593, 0);
	at[54] = 11;
	points[55] = (578.7205, -5793.8188, 451.6890);
	angles[55] = (0, 338.1284, 0);
	at[55] = 11.1000;
	points[56] = (587.1339, -5741.1025, 451.6890);
	angles[56] = (0, 349.0875, 0);
	at[56] = 11.2000;
	points[57] = (587.1653, -5684.7246, 451.6890);
	angles[57] = (0, 357.9432, 0);
	at[57] = 11.3000;
	points[58] = (575.1457, -5570.8662, 451.6890);
	angles[58] = (0, 366.7330, 0);
	at[58] = 11.5000;
	points[59] = (541.7205, -5403.1499, 451.6890);
	angles[59] = (0, 372.5514, 0);
	at[59] = 11.8000;
	points[60] = (495.9882, -5239.2129, 451.6890);
	angles[60] = (0, 376.7614, 0);
	at[60] = 12.1000;
	points[61] = (457.7480, -5131.4175, 451.6890);
	angles[61] = (0, 380.2439, 0);
	at[61] = 12.3000;
	points[62] = (435.4094, -5079.2124, 451.6890);
	angles[62] = (0, 382.8874, 0);
	at[62] = 12.4000;
	points[63] = (408.4646, -5027.9136, 451.6890);
	angles[63] = (0, 387.4153, 0);
	at[63] = 12.5000;
	points[64] = (372.5414, -4986.0630, 451.6890);
	angles[64] = (0, 401.6379, 0);
	at[64] = 12.6000;
	points[65] = (319.2953, -4983.3862, 451.6890);
	angles[65] = (0, 438.8148, 0);
	at[65] = 12.7000;
	points[66] = (263.6980, -4998.5825, 451.6890);
	angles[66] = (0, 459.3240, 0);
	at[66] = 12.8000;
	points[67] = (210.7374, -5018.8188, 451.6890);
	angles[67] = (0, 468.3493, 0);
	at[67] = 12.9000;
	points[68] = (107.3622, -5067.1650, 451.6890);
	angles[68] = (0, 475.5269, 0);
	at[68] = 13.1000;
	points[69] = (-41.2362, -5150.5513, 451.6890);
	angles[69] = (0, 480.4849, 0);
	at[69] = 13.4000;
	points[70] = (-136.5638, -5212.2837, 451.6890);
	angles[70] = (0, 483.4814, 0);
	at[70] = 13.6000;
	points[71] = (-228.2059, -5280.7876, 451.6890);
	angles[71] = (0, 487.6978, 0);
	at[71] = 13.8000;
	points[72] = (-269.8177, -5317.9131, 451.6890);
	angles[72] = (0, 491.4249, 0);
	at[72] = 13.9000;
	points[73] = (-306.4425, -5361.0635, 451.6890);
	angles[73] = (0, 499.7619, 0);
	at[73] = 14;
	points[74] = (-325.8760, -5413.8979, 451.6890);
	angles[74] = (0, 516.5065, 0);
	at[74] = 14.1000;
	points[75] = (-334.9409, -5468.1104, 451.6890);
	angles[75] = (0, 527.5323, 0);
	at[75] = 14.2000;
	points[76] = (-343.3106, -5582.9531, 451.6890);
	angles[76] = (0, 536.1930, 0);
	at[76] = 14.4000;
	points[77] = (-345.9929, -5696.1812, 451.6890);
	angles[77] = (0, 538.7864, 0);
	at[77] = 14.6000;
	points[78] = (-348.6579, -5923.5430, 451.6890);
	angles[78] = (0, 538.9893, 0);
	at[78] = 15;
	points[79] = (-358.2618, -6093.8979, 451.6890);
	angles[79] = (0, 535.2635, 0);
	at[79] = 15.3000;
	points[80] = (-366.5417, -6151.3779, 451.6890);
	angles[80] = (0, 532.0765, 0);
	at[80] = 15.4000;
	points[81] = (-381.0473, -6206.3389, 451.6890);
	angles[81] = (0, 525.6838, 0);
	at[81] = 15.5000;
	points[82] = (-407.7284, -6250.6694, 451.6890);
	angles[82] = (0, 510.1509, 0);
	at[82] = 15.6000;
	points[83] = (-449.9409, -6289.3701, 451.6890);
	angles[83] = (0, 495.8547, 0);
	at[83] = 15.7000;
	points[84] = (-497.1103, -6323.5830, 451.6890);
	angles[84] = (0, 487.9670, 0);
	at[84] = 15.8000;
	points[85] = (-543.9095, -6353.3862, 451.6890);
	angles[85] = (0, 483.5981, 0);
	at[85] = 15.9000;
	points[86] = (-643.3740, -6409.5278, 451.6890);
	angles[86] = (0, 479.0013, 0);
	at[86] = 16.1000;
	points[87] = (-745.0433, -6460.7090, 451.6890);
	angles[87] = (0, 476.3796, 0);
	at[87] = 16.3000;
	points[88] = (-848.2638, -6508.1890, 451.6890);
	angles[88] = (0, 474.4026, 0);
	at[88] = 16.5000;
	points[89] = (-1006.6260, -6573.4648, 451.6890);
	angles[89] = (0, 471.5915, 0);
	at[89] = 16.8000;
	points[90] = (-1113.3661, -6611.4565, 451.6890);
	angles[90] = (0, 469.0546, 0);
	at[90] = 17;
	points[91] = (-1168.7992, -6628.1494, 451.6890);
	angles[91] = (0, 466.9694, 0);
	at[91] = 17.1000;
	points[92] = (-1218.3149, -6639.8032, 451.6890);
	angles[92] = (0, 463.6590, 0);
	at[92] = 17.2000;
	points[93] = (-1276.3623, -6650.2759, 451.6890);
	angles[93] = (0, 460.8615, 0);
	at[93] = 17.3000;
	points[94] = (-1388.3464, -6666.5747, 451.6890);
	angles[94] = (0, 458.0557, 0);
	at[94] = 17.5000;
	points[95] = (-1557.5865, -6685.7876, 451.6890);
	angles[95] = (0, 456.0016, 0);
	at[95] = 17.8000;
	points[96] = (-1728.0394, -6700.1182, 451.6890);
	angles[96] = (0, 454.3395, 0);
	at[96] = 18.1000;
	points[97] = (-1898.3661, -6709.0156, 451.6890);
	angles[97] = (0, 452.4095, 0);
	at[97] = 18.4000;
	points[98] = (-2011.6575, -6711.0239, 451.6890);
	angles[98] = (0, 450.6439, 0);
	at[98] = 18.6000;
	points[99] = (-2125.4292, -6708.1494, 451.6890);
	angles[99] = (0, 447.9512, 0);
	at[99] = 18.8000;
	points[100] = (-2184.0396, -6703.6221, 451.6890);
	angles[100] = (0, 445.8334, 0);
	at[100] = 18.9000;
	points[101] = (-2238.3938, -6696.2603, 451.6890);
	angles[101] = (0, 442.6324, 0);
	at[101] = 19;
	points[102] = (-2294.2874, -6682.4805, 451.6890);
	angles[102] = (0, 436.3330, 0);
	at[102] = 19.1000;
	points[103] = (-2340.1497, -6658.5435, 451.6890);
	angles[103] = (0, 424.2488, 0);
	at[103] = 19.2000;
	points[104] = (-2385.2048, -6622.7559, 451.6890);
	angles[104] = (0, 413.8529, 0);
	at[104] = 19.3000;
	points[105] = (-2465.6890, -6542.2046, 451.6890);
	angles[105] = (0, 404.3594, 0);
	at[105] = 19.5000;
	points[106] = (-2577, -6412.3228, 451.6890);
	angles[106] = (0, 399.8082, 0);
	at[106] = 19.8000;
	points[107] = (-2789.8662, -6144.7246, 451.6890);
	angles[107] = (0, 398.5309, 0);
	at[107] = 20.4000;
	points[108] = (-2861.3621, -6057.4019, 451.6890);
	angles[108] = (0, 399.5852, 0);
	at[108] = 20.6000;
	points[109] = (-2899.8740, -6012.6772, 451.6890);
	angles[109] = (0, 400.6372, 0);
	at[109] = 20.7000;
	points[110] = (-2936.7520, -5972.3232, 451.6890);
	angles[110] = (0, 402.2668, 0);
	at[110] = 20.8000;
	points[111] = (-2978.9253, -5930.7876, 451.6890);
	angles[111] = (0, 405.2581, 0);
	at[111] = 20.9000;
	points[112] = (-3024.3545, -5895.4331, 451.6890);
	angles[112] = (0, 411.7711, 0);
	at[112] = 21;
	points[113] = (-3052.9648, -5882.8345, 451.6890);
	angles[113] = (0, 422.2386, 0);
	at[113] = 21.0667;
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
	points[0] = (-3753.5081, -6264.8037, 451.6890);
	angles[0] = (0, 149.5834, 0);
	at[0] = 0;
	points[1] = (-3754.7480, -6320.8267, 451.6890);
	angles[1] = (0, 173.2341, 0);
	at[1] = 0.1000;
	points[2] = (-3745.1497, -6378.1890, 451.6890);
	angles[2] = (0, 185.9494, 0);
	at[2] = 0.2000;
	points[3] = (-3731.9724, -6431.6147, 451.6890);
	angles[3] = (0, 192.1888, 0);
	at[3] = 0.3000;
	points[4] = (-3677.9922, -6594.2520, 451.6890);
	angles[4] = (0, 199.7620, 0);
	at[4] = 0.6000;
	points[5] = (-3611.5906, -6751.4966, 451.6890);
	angles[5] = (0, 204.0255, 0);
	at[5] = 0.9000;
	points[6] = (-3560.9133, -6853.1890, 451.6890);
	angles[6] = (0, 207.0717, 0);
	at[6] = 1.1000;
	points[7] = (-3532.6064, -6903.7402, 451.6890);
	angles[7] = (0, 208.9912, 0);
	at[7] = 1.2000;
	points[8] = (-3503.2993, -6951.0635, 451.6890);
	angles[8] = (0, 211.4430, 0);
	at[8] = 1.3000;
	points[9] = (-3469.7991, -6998.1499, 451.6890);
	angles[9] = (0, 215.0921, 0);
	at[9] = 1.4000;
	points[10] = (-3431.1772, -7040.9448, 451.6890);
	angles[10] = (0, 221.6089, 0);
	at[10] = 1.5000;
	points[11] = (-3388.9961, -7069.2915, 451.6890);
	angles[11] = (0, 234.4758, 0);
	at[11] = 1.6000;
	points[12] = (-3335.5042, -7091.0239, 451.6890);
	angles[12] = (0, 245.3755, 0);
	at[12] = 1.7000;
	points[13] = (-3226.2676, -7121.9683, 451.6890);
	angles[13] = (0, 254.7184, 0);
	at[13] = 1.9000;
	points[14] = (-3169.0947, -7134.8818, 451.6890);
	angles[14] = (0, 256.8075, 0);
	at[14] = 2;
	points[15] = (-3002.3071, -7165.9058, 451.6890);
	angles[15] = (0, 260.1397, 0);
	at[15] = 2.3000;
	points[16] = (-2833.3623, -7191.1416, 451.6890);
	angles[16] = (0, 261.9358, 0);
	at[16] = 2.6000;
	points[17] = (-2664.4529, -7212.2051, 451.6890);
	angles[17] = (0, 263.2228, 0);
	at[17] = 2.9000;
	points[18] = (-2438.5078, -7234.8823, 451.6890);
	angles[18] = (0, 264.8473, 0);
	at[18] = 3.3000;
	points[19] = (-2379.5789, -7239.5278, 451.6890);
	angles[19] = (0, 265.4189, 0);
	at[19] = 3.4000;
	points[20] = (-2329.0906, -7242.7563, 451.6890);
	angles[20] = (0, 266.2874, 0);
	at[20] = 3.5000;
	points[21] = (-2269.7559, -7245.2754, 451.6890);
	angles[21] = (0, 267.3446, 0);
	at[21] = 3.6000;
	points[22] = (-2215.5276, -7246.8896, 451.6890);
	angles[22] = (0, 268.1154, 0);
	at[22] = 3.7000;
	points[23] = (-2156.0117, -7248.1494, 451.6890);
	angles[23] = (0, 268.6657, 0);
	at[23] = 3.8000;
	points[24] = (-2101.3267, -7248.9761, 451.6890);
	angles[24] = (0, 269.0810, 0);
	at[24] = 3.9000;
	points[25] = (-1759.3346, -7247.7949, 451.6890);
	angles[25] = (0, 270.8462, 0);
	at[25] = 4.5000;
	points[26] = (-1418.1654, -7235.2358, 451.6890);
	angles[26] = (0, 273.1209, 0);
	at[26] = 5.1000;
	points[27] = (-1305.6891, -7226.9292, 451.6890);
	angles[27] = (0, 274.5115, 0);
	at[27] = 5.3000;
	points[28] = (-1246.9607, -7221.1025, 451.6890);
	angles[28] = (0, 275.5681, 0);
	at[28] = 5.4000;
	points[29] = (-1192.3307, -7214.1733, 451.6890);
	angles[29] = (0, 277.0454, 0);
	at[29] = 5.5000;
	points[30] = (-1134.9922, -7204.2524, 451.6890);
	angles[30] = (0, 279.6497, 0);
	at[30] = 5.6000;
	points[31] = (-1085.7008, -7191.6147, 451.6890);
	angles[31] = (0, 283.7567, 0);
	at[31] = 5.7000;
	points[32] = (-1029.5906, -7173.3071, 451.6890);
	angles[32] = (0, 287.3123, 0);
	at[32] = 5.8000;
	points[33] = (-977.7678, -7154.2910, 451.6890);
	angles[33] = (0, 289.6190, 0);
	at[33] = 5.9000;
	points[34] = (-818.6378, -7088.4644, 451.6890);
	angles[34] = (0, 293.1836, 0);
	at[34] = 6.2000;
	points[35] = (-612.9803, -6992.9922, 451.6890);
	angles[35] = (0, 295.6236, 0);
	at[35] = 6.6000;
	points[36] = (-409.8386, -6889.5278, 451.6890);
	angles[36] = (0, 297.6968, 0);
	at[36] = 7;
	points[37] = (-212.2382, -6777.7168, 451.6890);
	angles[37] = (0, 300.6541, 0);
	at[37] = 7.4000;
	points[38] = (-115.9004, -6715.0396, 451.6890);
	angles[38] = (0, 303.7843, 0);
	at[38] = 7.6000;
	points[39] = (-73.3350, -6682.5986, 451.6890);
	angles[39] = (0, 307.1435, 0);
	at[39] = 7.7000;
	points[40] = (-33.1746, -6645.7871, 451.6890);
	angles[40] = (0, 311.6198, 0);
	at[40] = 7.8000;
	points[41] = (45.7961, -6562.2441, 451.6890);
	angles[41] = (0, 317.0431, 0);
	at[41] = 8;
	points[42] = (119.7984, -6476.2598, 451.6890);
	angles[42] = (0, 319.5467, 0);
	at[42] = 8.2000;
	points[43] = (295.3445, -6252.5195, 451.6890);
	angles[43] = (0, 323.0168, 0);
	at[43] = 8.7000;
	points[44] = (394.9330, -6113.5830, 451.6890);
	angles[44] = (0, 324.9251, 0);
	at[44] = 9;
	points[45] = (457.8898, -6019.4487, 451.6890);
	angles[45] = (0, 326.5497, 0);
	at[45] = 9.2000;
	points[46] = (517.3819, -5922.4409, 451.6890);
	angles[46] = (0, 329.0186, 0);
	at[46] = 9.4000;
	points[47] = (545.2402, -5871.5747, 451.6890);
	angles[47] = (0, 331.0984, 0);
	at[47] = 9.5000;
	points[48] = (569.6851, -5819.1733, 451.6890);
	angles[48] = (0, 334.6887, 0);
	at[48] = 9.6000;
	points[49] = (584.0472, -5770.3545, 451.6890);
	angles[49] = (0, 343.2303, 0);
	at[49] = 9.7000;
	points[50] = (587.8819, -5712.6772, 451.6890);
	angles[50] = (0, 354, 0);
	at[50] = 9.8000;
	points[51] = (585.2992, -5655.8662, 451.6890);
	angles[51] = (0, 360.9100, 0);
	at[51] = 9.9000;
	points[52] = (570.5787, -5542.5596, 451.6890);
	angles[52] = (0, 368.0063, 0);
	at[52] = 10.1000;
	points[53] = (548.3110, -5431.2993, 451.6890);
	angles[53] = (0, 371.7795, 0);
	at[53] = 10.3000;
	points[54] = (504.4410, -5266.2998, 451.6890);
	angles[54] = (0, 376.0323, 0);
	at[54] = 10.6000;
	points[55] = (468.2244, -5158.6616, 451.6890);
	angles[55] = (0, 379.2245, 0);
	at[55] = 10.8000;
	points[56] = (422.8582, -5053.5825, 451.6890);
	angles[56] = (0, 384.6844, 0);
	at[56] = 11;
	points[57] = (393.0268, -5005.4727, 451.6890);
	angles[57] = (0, 391.5111, 0);
	at[57] = 11.1000;
	points[58] = (348.7784, -4980.5117, 451.6890);
	angles[58] = (0, 420.6324, 0);
	at[58] = 11.2000;
	points[59] = (292.4579, -4989.6455, 451.6890);
	angles[59] = (0, 450.9084, 0);
	at[59] = 11.3000;
	points[60] = (238.5335, -5007.6772, 451.6890);
	angles[60] = (0, 464.6117, 0);
	at[60] = 11.4000;
	points[61] = (185.0504, -5029.8818, 451.6890);
	angles[61] = (0, 470.9017, 0);
	at[61] = 11.5000;
	points[62] = (83.0165, -5079.8027, 451.6890);
	angles[62] = (0, 476.5292, 0);
	at[62] = 11.7000;
	points[63] = (-16.4724, -5135.6304, 451.6890);
	angles[63] = (0, 479.7549, 0);
	at[63] = 11.9000;
	points[64] = (-113.0500, -5196.3784, 451.6890);
	angles[64] = (0, 482.6719, 0);
	at[64] = 12.1000;
	points[65] = (-205.2752, -5262.4014, 451.6890);
	angles[65] = (0, 486.3893, 0);
	at[65] = 12.3000;
	points[66] = (-249.9642, -5299.4092, 451.6890);
	angles[66] = (0, 489.3047, 0);
	at[66] = 12.4000;
	points[67] = (-290.4929, -5339.8032, 451.6890);
	angles[67] = (0, 494.4918, 0);
	at[67] = 12.5000;
	points[68] = (-317.0992, -5383.4253, 451.6890);
	angles[68] = (0, 507.9554, 0);
	at[68] = 12.6000;
	points[69] = (-330.7760, -5438.9761, 451.6890);
	angles[69] = (0, 522.8104, 0);
	at[69] = 12.7000;
	points[70] = (-337.9850, -5496.9292, 451.6890);
	angles[70] = (0, 530.8170, 0);
	at[70] = 12.8000;
	points[71] = (-345.5614, -5666.8110, 451.6890);
	angles[71] = (0, 538.3712, 0);
	at[71] = 13.1000;
	points[72] = (-349.4244, -5951.9292, 451.6890);
	angles[72] = (0, 538.6852, 0);
	at[72] = 13.6000;
	points[73] = (-355.5594, -6065.9058, 451.6890);
	angles[73] = (0, 536.3177, 0);
	at[73] = 13.8000;
	points[74] = (-361.7150, -6121.7324, 451.6890);
	angles[74] = (0, 533.9631, 0);
	at[74] = 13.9000;
	points[75] = (-372.1331, -6177.1260, 451.6890);
	angles[75] = (0, 529.6119, 0);
	at[75] = 14;
	points[76] = (-392.3724, -6230.4336, 451.6890);
	angles[76] = (0, 519.2573, 0);
	at[76] = 14.1000;
	points[77] = (-428.3582, -6271.1812, 451.6890);
	angles[77] = (0, 502.2257, 0);
	at[77] = 14.2000;
	points[78] = (-472.0236, -6306.1025, 451.6890);
	angles[78] = (0, 491.4050, 0);
	at[78] = 14.3000;
	points[79] = (-568.8976, -6368.2676, 451.6890);
	angles[79] = (0, 482.1179, 0);
	at[79] = 14.5000;
	points[80] = (-668.3976, -6422.5986, 451.6890);
	angles[80] = (0, 478.2504, 0);
	at[80] = 14.7000;
	points[81] = (-770.3268, -6472.7163, 451.6890);
	angles[81] = (0, 475.8583, 0);
	at[81] = 14.9000;
	points[82] = (-926.4764, -6541.5752, 451.6890);
	angles[82] = (0, 473.0451, 0);
	at[82] = 15.2000;
	points[83] = (-1032.1417, -6583.0713, 451.6890);
	angles[83] = (0, 471.0674, 0);
	at[83] = 15.4000;
	points[84] = (-1140.0079, -6619.8423, 451.6890);
	angles[84] = (0, 468.1776, 0);
	at[84] = 15.6000;
	points[85] = (-1193.5472, -6634.4487, 451.6890);
	angles[85] = (0, 465.4349, 0);
	at[85] = 15.7000;
	points[86] = (-1246.4607, -6645.1182, 451.6890);
	angles[86] = (0, 462.1449, 0);
	at[86] = 15.8000;
	points[87] = (-1360.6732, -6662.8740, 451.6890);
	angles[87] = (0, 458.5708, 0);
	at[87] = 16;
	points[88] = (-1415.3229, -6670, 451.6890);
	angles[88] = (0, 457.6385, 0);
	at[88] = 16.1000;
	points[89] = (-1642.5591, -6693.5435, 451.6890);
	angles[89] = (0, 455.1757, 0);
	at[89] = 16.5000;
	points[90] = (-1869.4135, -6707.9531, 451.6890);
	angles[90] = (0, 452.7781, 0);
	at[90] = 16.9000;
	points[91] = (-2040.3740, -6710.8271, 451.6890);
	angles[91] = (0, 450.1035, 0);
	at[91] = 17.2000;
	points[92] = (-2154.0945, -6706.2603, 451.6890);
	angles[92] = (0, 447.0288, 0);
	at[92] = 17.4000;
	points[93] = (-2210.9724, -6700.4727, 451.6890);
	angles[93] = (0, 444.4330, 0);
	at[93] = 17.5000;
	points[94] = (-2267.9961, -6690.1182, 451.6890);
	angles[94] = (0, 440.1157, 0);
	at[94] = 17.6000;
	points[95] = (-2316.0945, -6673.1099, 451.6890);
	angles[95] = (0, 430.8904, 0);
	at[95] = 17.7000;
	points[96] = (-2365.0474, -6639.8818, 451.6890);
	angles[96] = (0, 418.4747, 0);
	at[96] = 17.8000;
	points[97] = (-2405.3545, -6604.2124, 451.6890);
	angles[97] = (0, 410.5237, 0);
	at[97] = 17.9000;
	points[98] = (-2446.7480, -6562.5200, 451.6890);
	angles[98] = (0, 405.9075, 0);
	at[98] = 18;
	points[99] = (-2484.2834, -6521.6143, 451.6890);
	angles[99] = (0, 403.1904, 0);
	at[99] = 18.1000;
	points[100] = (-2594.9133, -6390.2759, 451.6890);
	angles[100] = (0, 399.4453, 0);
	at[100] = 18.4000;
	points[101] = (-2807.7400, -6122.5195, 451.6890);
	angles[101] = (0, 398.7025, 0);
	at[101] = 19;
	points[102] = (-2917.9685, -5992.5200, 451.6890);
	angles[102] = (0, 401.3498, 0);
	at[102] = 19.3000;
	points[103] = (-2958.0117, -5950.6299, 451.6890);
	angles[103] = (0, 403.4975, 0);
	at[103] = 19.4000;
	points[104] = (-2997.8228, -5914.5278, 451.6890);
	angles[104] = (0, 407.5545, 0);
	at[104] = 19.5000;
	points[105] = (-3046.8308, -5884.5669, 451.6890);
	angles[105] = (0, 419.2843, 0);
	at[105] = 19.6000;
	points[106] = (-3102.4333, -5880.9453, 451.6890);
	angles[106] = (0, 441.6246, 0);
	at[106] = 19.7000;
	points[107] = (-3156.8149, -5890.9844, 451.6890);
	angles[107] = (0, 456.5103, 0);
	at[107] = 19.8000;
	points[108] = (-3211.0317, -5907.2446, 451.6890);
	angles[108] = (0, 464.6953, 0);
	at[108] = 19.9000;
	points[109] = (-3316.9136, -5949.9214, 451.6890);
	angles[109] = (0, 472.6506, 0);
	at[109] = 20.1000;
	points[110] = (-3419.0591, -6000.7485, 451.6890);
	angles[110] = (0, 477.0197, 0);
	at[110] = 20.3000;
	points[111] = (-3566.0986, -6088.6221, 451.6890);
	angles[111] = (0, 482.3571, 0);
	at[111] = 20.6000;
	points[112] = (-3658.2754, -6155.6299, 451.6890);
	angles[112] = (0, 486.9871, 0);
	at[112] = 20.8000;
	points[113] = (-3701.4805, -6193.3857, 451.6890);
	angles[113] = (0, 490.7188, 0);
	at[113] = 20.9000;
	points[114] = (-3739.1731, -6235.9453, 451.6890);
	angles[114] = (0, 497.9682, 0);
	at[114] = 21;
	points[115] = (-3753.5081, -6264.8037, 451.6890);
	angles[115] = (0, 509.5834, 0);
	at[115] = 21.0667;
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
	points[0] = (-4171.7324, -5496.8110, 451.6890);
	angles[0] = (0, -7.8590, 0);
	at[0] = 0;
	points[1] = (-4176.1812, -5469.2524, 451.6890);
	angles[1] = (0, 6.2322, 0);
	at[1] = 0.1000;
	points[2] = (-4184.4883, -5441.7324, 451.6890);
	angles[2] = (0, 14.5840, 0);
	at[2] = 0.2000;
	points[3] = (-4222.7954, -5350.0786, 451.6890);
	angles[3] = (0, 24.5554, 0);
	at[3] = 0.5500;
	points[4] = (-4269.7642, -5262.4409, 451.6890);
	angles[4] = (0, 29.9341, 0);
	at[4] = 0.9000;
	points[5] = (-4310.4331, -5204.4883, 451.6890);
	angles[5] = (0, 37.9017, 0);
	at[5] = 1.1500;
	points[6] = (-4331.4961, -5187.3228, 451.6890);
	angles[6] = (0, 51.2413, 0);
	at[6] = 1.2500;
	points[7] = (-4358.5825, -5178.5435, 451.6890);
	angles[7] = (0, 68.1496, 0);
	at[7] = 1.3500;
	points[8] = (-4401.1812, -5171.6929, 451.6890);
	angles[8] = (0, 80.3101, 0);
	at[8] = 1.5000;
	points[9] = (-4486.2993, -5167.8350, 451.6890);
	angles[9] = (0, 89.1239, 0);
	at[9] = 1.8000;
	points[10] = (-4543.1890, -5170.4331, 451.6890);
	angles[10] = (0, 93.3549, 0);
	at[10] = 2;
	points[11] = (-4599.7246, -5178.7007, 451.6890);
	angles[11] = (0, 99.8864, 0);
	at[11] = 2.2000;
	points[12] = (-4626.6929, -5187.6382, 451.6890);
	angles[12] = (0, 107.9754, 0);
	at[12] = 2.3000;
	points[13] = (-4636.9688, -5194.3701, 451.6890);
	angles[13] = (0, 116.9002, 0);
	at[13] = 2.3500;
	points[14] = (-4647.7168, -5205.0786, 451.6890);
	angles[14] = (0, 126.4156, 0);
	at[14] = 2.4000;
	points[15] = (-4665.0391, -5227.3228, 451.6890);
	angles[15] = (0, 138.6535, 0);
	at[15] = 2.5000;
	points[16] = (-4680.5513, -5250.6299, 451.6890);
	angles[16] = (0, 144.7300, 0);
	at[16] = 2.6000;
	points[17] = (-4735.1182, -5350.7090, 451.6890);
	angles[17] = (0, 153.4486, 0);
	at[17] = 3;
	points[18] = (-4773.3462, -5442.3228, 451.6890);
	angles[18] = (0, 159.6076, 0);
	at[18] = 3.3500;
	points[19] = (-4781.5752, -5469.8428, 451.6890);
	angles[19] = (0, 163.0794, 0);
	at[19] = 3.4500;
	points[20] = (-4785.8662, -5497.3623, 451.6890);
	angles[20] = (0, 171.1322, 0);
	at[20] = 3.5500;
	points[21] = (-4781.8506, -5524.8032, 451.6890);
	angles[21] = (0, 185.4168, 0);
	at[21] = 3.6500;
	points[22] = (-4773.7402, -5552.3232, 451.6890);
	angles[22] = (0, 194.1487, 0);
	at[22] = 3.7500;
	points[23] = (-4758.7798, -5592.0078, 451.6890);
	angles[23] = (0, 200.3846, 0);
	at[23] = 3.9000;
	points[24] = (-4729.4883, -5656.7324, 451.6890);
	angles[24] = (0, 205.2131, 0);
	at[24] = 4.1500;
	points[25] = (-4681.2993, -5744.0156, 451.6890);
	angles[25] = (0, 210.7635, 0);
	at[25] = 4.5000;
	points[26] = (-4656.9688, -5779.4883, 451.6890);
	angles[26] = (0, 215.0077, 0);
	at[26] = 4.6500;
	points[27] = (-4637.9526, -5800.6694, 451.6890);
	angles[27] = (0, 221.7094, 0);
	at[27] = 4.7500;
	points[28] = (-4627.8345, -5807.6772, 451.6890);
	angles[28] = (0, 229.8386, 0);
	at[28] = 4.8000;
	points[29] = (-4613.9370, -5813.2676, 451.6890);
	angles[29] = (0, 239.5237, 0);
	at[29] = 4.8500;
	points[30] = (-4572.9526, -5822.0474, 451.6890);
	angles[30] = (0, 256.9636, 0);
	at[30] = 5;
	points[31] = (-4473.3467, -5828.0312, 451.6890);
	angles[31] = (0, 268.9754, 0);
	at[31] = 5.3500;
	points[32] = (-4402.5981, -5824.2915, 451.6890);
	angles[32] = (0, 274.3952, 0);
	at[32] = 5.6000;
	points[33] = (-4359.9214, -5817.5986, 451.6890);
	angles[33] = (0, 279.5275, 0);
	at[33] = 5.7500;
	points[34] = (-4332.6772, -5809.0552, 451.6890);
	angles[34] = (0, 287.0435, 0);
	at[34] = 5.8500;
	points[35] = (-4311.4961, -5792.5591, 451.6890);
	angles[35] = (0, 305.1589, 0);
	at[35] = 5.9500;
	points[36] = (-4293.8584, -5770.3545, 451.6890);
	angles[36] = (0, 318.0268, 0);
	at[36] = 6.0500;
	points[37] = (-4278.1499, -5746.9688, 451.6890);
	angles[37] = (0, 324.4132, 0);
	at[37] = 6.1500;
	points[38] = (-4249.2520, -5697.5981, 451.6890);
	angles[38] = (0, 330.1408, 0);
	at[38] = 6.3500;
	points[39] = (-4217.2837, -5634.1733, 451.6890);
	angles[39] = (0, 334.0686, 0);
	at[39] = 6.6000;
	points[40] = (-4180.3936, -5541.4961, 451.6890);
	angles[40] = (0, 340.8563, 0);
	at[40] = 6.9500;
	points[41] = (-4173.3857, -5513.8584, 451.6890);
	angles[41] = (0, 345.4583, 0);
	at[41] = 7.0500;
	points[42] = (-4171.7324, -5496.8110, 451.6890);
	angles[42] = (0, 352.1410, 0);
	at[42] = 7.1167;
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
	points[0] = (-4785.8662, -5499.0161, 451.6890);
	angles[0] = (0, 172.1408, 0);
	at[0] = 0;
	points[1] = (-4781.4175, -5526.6147, 451.6890);
	angles[1] = (0, 186.2321, 0);
	at[1] = 0.1000;
	points[2] = (-4773.1104, -5554.1338, 451.6890);
	angles[2] = (0, 194.5840, 0);
	at[2] = 0.2000;
	points[3] = (-4734.8032, -5645.7480, 451.6890);
	angles[3] = (0, 204.5552, 0);
	at[3] = 0.5500;
	points[4] = (-4687.8345, -5733.4253, 451.6890);
	angles[4] = (0, 209.9340, 0);
	at[4] = 0.9000;
	points[5] = (-4647.1655, -5791.3779, 451.6890);
	angles[5] = (0, 217.9016, 0);
	at[5] = 1.1500;
	points[6] = (-4626.1025, -5808.5039, 451.6890);
	angles[6] = (0, 231.2412, 0);
	at[6] = 1.2500;
	points[7] = (-4599.0161, -5817.3228, 451.6890);
	angles[7] = (0, 248.1496, 0);
	at[7] = 1.3500;
	points[8] = (-4556.4175, -5824.1338, 451.6890);
	angles[8] = (0, 260.3101, 0);
	at[8] = 1.5000;
	points[9] = (-4471.2993, -5827.9922, 451.6890);
	angles[9] = (0, 269.1239, 0);
	at[9] = 1.8000;
	points[10] = (-4414.4097, -5825.4331, 451.6890);
	angles[10] = (0, 273.3549, 0);
	at[10] = 2;
	points[11] = (-4357.9136, -5817.1655, 451.6890);
	angles[11] = (0, 279.8865, 0);
	at[11] = 2.2000;
	points[12] = (-4330.9053, -5808.2285, 451.6890);
	angles[12] = (0, 287.9757, 0);
	at[12] = 2.3000;
	points[13] = (-4320.6299, -5801.4961, 451.6890);
	angles[13] = (0, 296.9002, 0);
	at[13] = 2.3500;
	points[14] = (-4309.8818, -5790.7485, 451.6890);
	angles[14] = (0, 306.4153, 0);
	at[14] = 2.4000;
	points[15] = (-4292.5591, -5768.5044, 451.6890);
	angles[15] = (0, 318.6534, 0);
	at[15] = 2.5000;
	points[16] = (-4277.0474, -5745.1968, 451.6890);
	angles[16] = (0, 324.7300, 0);
	at[16] = 2.6000;
	points[17] = (-4222.4805, -5645.1572, 451.6890);
	angles[17] = (0, 333.4486, 0);
	at[17] = 3;
	points[18] = (-4184.2520, -5553.5044, 451.6890);
	angles[18] = (0, 339.6078, 0);
	at[18] = 3.3500;
	points[19] = (-4176.0630, -5525.9844, 451.6890);
	angles[19] = (0, 343.0797, 0);
	at[19] = 3.4500;
	points[20] = (-4171.7324, -5498.4644, 451.6890);
	angles[20] = (0, 351.1326, 0);
	at[20] = 3.5500;
	points[21] = (-4175.7480, -5471.0630, 451.6890);
	angles[21] = (0, 365.4169, 0);
	at[21] = 3.6500;
	points[22] = (-4183.8584, -5443.5435, 451.6890);
	angles[22] = (0, 374.1487, 0);
	at[22] = 3.7500;
	points[23] = (-4198.8188, -5403.8193, 451.6890);
	angles[23] = (0, 380.3845, 0);
	at[23] = 3.9000;
	points[24] = (-4228.1104, -5339.0947, 451.6890);
	angles[24] = (0, 385.2131, 0);
	at[24] = 4.1500;
	points[25] = (-4276.2993, -5251.8110, 451.6890);
	angles[25] = (0, 390.7636, 0);
	at[25] = 4.5000;
	points[26] = (-4300.6299, -5216.3779, 451.6890);
	angles[26] = (0, 395.0078, 0);
	at[26] = 4.6500;
	points[27] = (-4319.6460, -5195.1968, 451.6890);
	angles[27] = (0, 401.7095, 0);
	at[27] = 4.7500;
	points[28] = (-4329.8032, -5188.1890, 451.6890);
	angles[28] = (0, 409.8387, 0);
	at[28] = 4.8000;
	points[29] = (-4343.6616, -5182.5986, 451.6890);
	angles[29] = (0, 419.5238, 0);
	at[29] = 4.8500;
	points[30] = (-4384.6460, -5173.7798, 451.6890);
	angles[30] = (0, 436.9634, 0);
	at[30] = 5;
	points[31] = (-4484.2520, -5167.8350, 451.6890);
	angles[31] = (0, 448.9753, 0);
	at[31] = 5.3500;
	points[32] = (-4555, -5171.5352, 451.6890);
	angles[32] = (0, 454.3953, 0);
	at[32] = 5.6000;
	points[33] = (-4597.6772, -5178.2280, 451.6890);
	angles[33] = (0, 459.5274, 0);
	at[33] = 5.7500;
	points[34] = (-4624.9214, -5186.7720, 451.6890);
	angles[34] = (0, 467.0432, 0);
	at[34] = 5.8500;
	points[35] = (-4646.1025, -5203.3071, 451.6890);
	angles[35] = (0, 485.1593, 0);
	at[35] = 5.9500;
	points[36] = (-4663.7402, -5225.5117, 451.6890);
	angles[36] = (0, 498.0269, 0);
	at[36] = 6.0500;
	points[37] = (-4679.4487, -5248.8584, 451.6890);
	angles[37] = (0, 504.4131, 0);
	at[37] = 6.1500;
	points[38] = (-4708.3467, -5298.2681, 451.6890);
	angles[38] = (0, 510.1407, 0);
	at[38] = 6.3500;
	points[39] = (-4740.3149, -5361.6929, 451.6890);
	angles[39] = (0, 514.0684, 0);
	at[39] = 6.6000;
	points[40] = (-4777.2051, -5454.3701, 451.6890);
	angles[40] = (0, 520.8563, 0);
	at[40] = 6.9500;
	points[41] = (-4784.2124, -5481.9688, 451.6890);
	angles[41] = (0, 525.4581, 0);
	at[41] = 7.0500;
	points[42] = (-4785.8662, -5499.0161, 451.6890);
	angles[42] = (0, 532.1407, 0);
	at[42] = 7.1167;
	mover = getEnt("iz_obj_4", "targetname");
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
