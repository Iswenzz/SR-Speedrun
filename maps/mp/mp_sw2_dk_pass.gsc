main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_dk_pass", 0);

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
	ambientPlay("iz_0_sw2dkp", 2);
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
	level.iz_route[level.iz_route.size] = (3792, 7125, 620);
	level.iz_route[level.iz_route.size] = (3750, 5868, 620);
	level.iz_route[level.iz_route.size] = (3351, 5024, 620);
	level.iz_route[level.iz_route.size] = (2519, 4621, 651);
	level.iz_route[level.iz_route.size] = (1292, 4311, 749);
	level.iz_route[level.iz_route.size] = (-1265, 3788, 988);
	level.iz_route[level.iz_route.size] = (-2399, 3455, 1111);
	level.iz_route[level.iz_route.size] = (-3237, 3015, 1221);
	level.iz_route[level.iz_route.size] = (-3613, 2210, 1290);
	level.iz_route[level.iz_route.size] = (-3608, 817, 1440);
	level.iz_route[level.iz_route.size] = (-3966, -50, 1578);
	level.iz_route[level.iz_route.size] = (-4601, -739, 1663);
	level.iz_route[level.iz_route.size] = (-5275, -1347, 1711);
	level.iz_route[level.iz_route.size] = (-5632, -1873, 1725);
	level.iz_route[level.iz_route.size] = (-5303, -2465, 1731);
	level.iz_route[level.iz_route.size] = (-4687, -3053, 1793);
	level.iz_route[level.iz_route.size] = (-4889, -3919, 1899);
	level.iz_route[level.iz_route.size] = (-5625, -4447, 1993);
	level.iz_route[level.iz_route.size] = (-6552, -4773, 2060);
	level.iz_route[level.iz_route.size] = (-7868, -5252, 2146);
	level.iz_route[level.iz_route.size] = (-8696, -5658, 2218);
	level.iz_route[level.iz_route.size] = (-9040, -6563, 2304);
	level.iz_route[level.iz_route.size] = (-9000, -7512, 2399);
	level.iz_route[level.iz_route.size] = (-8279, -8119, 2480);
	level.iz_route[level.iz_route.size] = (-7324, -8335, 2549);
	level.iz_route[level.iz_route.size] = (-6381, -8124, 2618);
	level.iz_route[level.iz_route.size] = (-5551, -7620, 2679);
	level.iz_route[level.iz_route.size] = (-4914, -6826, 2784);
	level.iz_route[level.iz_route.size] = (-3961, -6144, 2952);
	level.iz_route[level.iz_route.size] = (-3016, -6298, 3085);
	level.iz_route[level.iz_route.size] = (-2311, -6928, 3154);
	level.iz_route[level.iz_route.size] = (-2247, -7848, 3182);
	level.iz_route[level.iz_route.size] = (-2944, -8565, 3189);
	level.iz_route[level.iz_route.size] = (-3697, -9306, 3193);
	level.iz_route[level.iz_route.size] = (-4169, -10156, 3197);
	level.iz_route[level.iz_route.size] = (-4225, -11079, 3169);
	level.iz_route[level.iz_route.size] = (-3592, -11960, 3149);
	level.iz_route[level.iz_route.size] = (-2423, -12297, 3149);
	level.iz_route[level.iz_route.size] = (-1298, -11994, 3175);
	level.iz_route[level.iz_route.size] = (-510, -11266, 3280);
	level.iz_route[level.iz_route.size] = (344, -10200, 3529);
	level.iz_route[level.iz_route.size] = (1081, -9089, 3348);
	level.iz_route[level.iz_route.size] = (3201, -7047, 2947);
	level.iz_route[level.iz_route.size] = (4298, -6085, 2802);
	level.iz_route[level.iz_route.size] = (4230, -4858, 2663);
	level.iz_route[level.iz_route.size] = (4293, -3835, 2541);
	level.iz_route[level.iz_route.size] = (4082, -2863, 2412);
	level.iz_route[level.iz_route.size] = (3133, -2723, 2392);
	level.iz_route[level.iz_route.size] = (2142, -2962, 2393);
	level.iz_route[level.iz_route.size] = (915, -3393, 2474);
	level.iz_route[level.iz_route.size] = (27, -3291, 2541);
	level.iz_route[level.iz_route.size] = (-365, -2441, 2407);
	level.iz_route[level.iz_route.size] = (-175, -1449, 2264);
	level.iz_route[level.iz_route.size] = (23, -147, 2136);
	level.iz_route[level.iz_route.size] = (-15, 1604, 2116);
	level.iz_route[level.iz_route.size] = (51, 3119, 1548);
	level.iz_route[level.iz_route.size] = (55, 4514, 1499);
	level.iz_route[level.iz_route.size] = (29, 5723, 1662);
	level.iz_route[level.iz_route.size] = (24, 7443, 924);
	level.iz_route[level.iz_route.size] = (29, 10053, 915);
	level.iz_route[level.iz_route.size] = (199, 11469, 876);
	level.iz_route[level.iz_route.size] = (751, 12702, 704);
	level.iz_route[level.iz_route.size] = (1757, 13303, 627);
	level.iz_route[level.iz_route.size] = (2983, 13055, 561);
	level.iz_route[level.iz_route.size] = (3628, 12293, 621);
	level.iz_route[level.iz_route.size] = (3741, 11243, 620);
	level.iz_route[level.iz_route.size] = (3774, 10092, 620);
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
	points[0] = (-6428.7007, -15354.5283, 3395.3779);
	angles[0] = (0, 74.0521, -63.0550);
	at[0] = 0;
	points[1] = (-6434.4097, -15352.8750, 3435.5356);
	angles[1] = (0, 74.0603, -75.0552);
	at[1] = 0.0667;
	points[2] = (-6440.4727, -15351.1426, 3466.2441);
	angles[2] = (0, 74.0670, -87.0552);
	at[2] = 0.1333;
	points[3] = (-6446.8110, -15349.3301, 3487.5042);
	angles[3] = (0, 74.0727, -99.0555);
	at[3] = 0.2000;
	points[4] = (-6453.4648, -15347.4414, 3499.3149);
	angles[4] = (0, 74.0773, -111.0556);
	at[4] = 0.2667;
	points[5] = (-6459.2520, -15345.7871, 3501.6770);
	angles[5] = (0, 74.0807, -123.0557);
	at[5] = 0.3333;
	points[6] = (-6465.1182, -15344.0947, 3494.5908);
	angles[6] = (0, 74.0835, -135.0559);
	at[6] = 0.4000;
	points[7] = (-6471.1421, -15342.4014, 3478.0552);
	angles[7] = (0, 74.0858, -147.0561);
	at[7] = 0.4667;
	points[8] = (-6477.3228, -15340.6309, 3452.0710);
	angles[8] = (0, 74.0878, -159.0562);
	at[8] = 0.5333;
	points[9] = (-6483.6226, -15338.8584, 3416.6379);
	angles[9] = (0, 74.0894, -171.0564);
	at[9] = 0.6000;
	points[10] = (-6489.6064, -15337.1260, 3371.7561);
	angles[10] = (0, 74.0907, -183.0565);
	at[10] = 0.6667;
	points[11] = (-6495.4727, -15335.4727, 3317.4253);
	angles[11] = (0, 74.0917, -195.0566);
	at[11] = 0.7333;
	points[12] = (-6501.3779, -15333.7793, 3253.6458);
	angles[12] = (0, 74.0924, -207.0569);
	at[12] = 0.8000;
	points[13] = (-6507.4014, -15332.0469, 3180.4175);
	angles[13] = (0, 74.0929, -219.0570);
	at[13] = 0.8667;
	points[14] = (-6513.5039, -15330.3154, 3097.7402);
	angles[14] = (0, 74.0933, -231.0570);
	at[14] = 0.9333;
	points[15] = (-6519.6455, -15328.5830, 3005.6140);
	angles[15] = (0, 74.0935, -243.0573);
	at[15] = 1;
	points[16] = (-6525.6304, -15326.8506, 2904.0396);
	angles[16] = (0, 74.0935, -255.0574);
	at[16] = 1.0667;
	points[17] = (-6531.5356, -15325.1973, 2793.0156);
	angles[17] = (0, 74.0932, -267.0576);
	at[17] = 1.1333;
	points[18] = (-6537.5195, -15323.4648, 2672.5432);
	angles[18] = (0, 74.0930, -279.0577);
	at[18] = 1.2000;
	points[19] = (-6543.5430, -15321.7725, 2542.6223);
	angles[19] = (0, 74.0925, -291.0580);
	at[19] = 1.2667;
	points[20] = (-6549.5669, -15320.0391, 2403.2520);
	angles[20] = (0, 74.0920, -303.0580);
	at[20] = 1.3333;
	points[21] = (-6555.6299, -15318.3066, 2254.4331);
	angles[21] = (0, 74.0911, -315.0582);
	at[21] = 1.4000;
	points[22] = (-6561.6538, -15316.6143, 2096.1653);
	angles[22] = (0, 74.0902, -327.0583);
	at[22] = 1.4667;
	points[23] = (-6567.7168, -15314.8818, 1928.4489);
	angles[23] = (0, 74.0893, -339.0584);
	at[23] = 1.5333;
	points[24] = (-6573.7407, -15313.1504, 1751.2836);
	angles[24] = (0, 74.0880, -351.0586);
	at[24] = 1.6000;
	points[25] = (-6579.7642, -15311.4180, 1564.6693);
	angles[25] = (0, 74.0866, -363.0587);
	at[25] = 1.6667;
	points[26] = (-6585.8267, -15309.7246, 1368.6063);
	angles[26] = (0, 74.0851, -375.0589);
	at[26] = 1.7333;
	points[27] = (-6591.8506, -15307.9922, 1163.0945);
	angles[27] = (0, 74.0835, -387.0592);
	at[27] = 1.8000;
	points[28] = (-6597.8740, -15306.2598, 948.1339);
	angles[28] = (0, 74.0816, -399.0592);
	at[28] = 1.8667;
	points[29] = (-6604.0947, -15304.4883, 723.7244);
	angles[29] = (0, 74.0795, -411.0594);
	at[29] = 1.9333;
	points[30] = (-6610.2358, -15302.7559, 489.8661);
	angles[30] = (0, 74.0771, -423.0595);
	at[30] = 2;
	points[31] = (-6616.3779, -15300.9844, 246.5594);
	angles[31] = (0, 74.0747, -435.0596);
	at[31] = 2.0667;
	points[32] = (-6622.4805, -15299.2529, -6.1965);
	angles[32] = (0, 74.0719, -447.0598);
	at[32] = 2.1333;
	points[33] = (-6628.5435, -15297.5205, -268.4012);
	angles[33] = (0, 74.0690, -459.0600);
	at[33] = 2.2000;
	points[34] = (-6634.5674, -15295.7881, -540.0551);
	angles[34] = (0, 74.0658, -471.0602);
	at[34] = 2.2667;
	points[35] = (-6641.0239, -15293.9766, -821.1575);
	angles[35] = (0, 74.0618, -483.0603);
	at[35] = 2.3333;
	points[36] = (-6647.4014, -15292.1270, -1111.7086);
	angles[36] = (0, 74.0576, -495.0604);
	at[36] = 2.4000;
	points[37] = (-6653.7007, -15290.3545, -1411.7086);
	angles[37] = (0, 74.0531, -507.0605);
	at[37] = 2.4667;
	points[38] = (-6659.8818, -15288.5820, -1721.1575);
	angles[38] = (0, 74.0481, -519.0608);
	at[38] = 2.5333;
	points[39] = (-6665.9448, -15286.8506, -2040.0552);
	angles[39] = (0, 74.0426, -531.0609);
	at[39] = 2.6000;
	points[40] = (-6672.4019, -15285, -2368.4016);
	angles[40] = (0, 74.0361, -543.0610);
	at[40] = 2.6667;
	points[41] = (-6679.2124, -15283.0312, -2706.1968);
	angles[41] = (0, 74.0285, -555.0612);
	at[41] = 2.7333;
	points[42] = (-6685.7876, -15281.1416, -3053.4412);
	angles[42] = (0, 74.0198, -567.0613);
	at[42] = 2.8000;
	points[43] = (-6692.1655, -15279.3311, -3410.1340);
	angles[43] = (0, 74.0102, -579.0614);
	at[43] = 2.8667;
	points[44] = (-6698.3467, -15277.5586, -3776.2754);
	angles[44] = (0, 74, -591.0616);
	at[44] = 2.9333;
	points[45] = (-6705.5908, -15275.4727, -4151.8506);
	angles[45] = (0, 73.9842, -603.0617);
	at[45] = 3;
	points[46] = (-6712.8740, -15273.3857, -4536.8896);
	angles[46] = (0, 73.9651, -615.0620);
	at[46] = 3.0667;
	points[47] = (-6719.6851, -15271.4180, -4931.3779);
	angles[47] = (0, 73.9424, -627.0620);
	at[47] = 3.1333;
	points[48] = (-6726.2598, -15269.5283, -5335.3149);
	angles[48] = (0, 73.9140, -639.0621);
	at[48] = 3.2000;
	points[49] = (-6735.3149, -15266.9297, -5748.7007);
	angles[49] = (0, 73.8554, -651.0624);
	at[49] = 3.2667;
	points[50] = (-6743.0312, -15264.6846, -6171.5356);
	angles[50] = (0, 73.7675, -663.0625);
	at[50] = 3.3333;
	points[51] = (-6754.1733, -15261.4180, -6603.8188);
	angles[51] = (0, 73.4728, -675.0626);
	at[51] = 3.4000;
	points[52] = (-6772.8345, -15255.7881, -7045.5513);
	angles[52] = (0, 73.1254, -687.0629);
	at[52] = 3.4667;
	points[53] = (-6805.0396, -15245.9453, -7496.7329);
	angles[53] = (0, 72.8729, -699.0630);
	at[53] = 3.5333;
	points[54] = (-6832.8350, -15237.3623, -7957.3623);
	angles[54] = (0, 72.8777, -711.0631);
	at[54] = 3.6000;
	points[55] = (-6858.1104, -15229.6064, -8427.4414);
	angles[55] = (0, 73.0101, -723.0633);
	at[55] = 3.6667;
	points[56] = (-6886.8501, -15220.9053, -8906.9688);
	angles[56] = (0, 73.2866, -735.0634);
	at[56] = 3.7333;
	points[57] = (-6920.5513, -15210.9053, -9395.9453);
	angles[57] = (0, 73.7766, -747.0636);
	at[57] = 3.8000;
	points[58] = (-6943.4258, -15204.3311, -9894.3701);
	angles[58] = (0, 73.9035, -759.0638);
	at[58] = 3.8667;
	points[59] = (-6963.0312, -15198.6230, -10402.2451);
	angles[59] = (0, 73.6644, -771.0638);
	at[59] = 3.9333;
	points[60] = (-6978.7012, -15194.0166, -10919.5664);
	angles[60] = (0, 73.5977, -783.0641);
	at[60] = 4;
	points[61] = (-6995.5513, -15189.0557, -11446.3389);
	angles[61] = (0, 73.5702, -795.0642);
	at[61] = 4.0667;
	points[62] = (-7011.7715, -15184.2920, -11982.5586);
	angles[62] = (0, 73.5665, -807.0643);
	at[62] = 4.1333;
	points[63] = (-7027.0869, -15179.7646, -12528.2285);
	angles[63] = (0, 73.5755, -819.0645);
	at[63] = 4.2000;
	points[64] = (-7043.2280, -15175, -13083.3457);
	angles[64] = (0, 73.5945, -831.0647);
	at[64] = 4.2667;
	points[65] = (-7059.0552, -15170.3545, -13647.9141);
	angles[65] = (0, 73.6202, -843.0648);
	at[65] = 4.3333;
	points[66] = (-7074.2524, -15165.9053, -14221.9297);
	angles[66] = (0, 73.6504, -855.0649);
	at[66] = 4.4000;
	points[67] = (-7089.8818, -15161.2988, -14805.3945);
	angles[67] = (0, 73.6864, -867.0651);
	at[67] = 4.4667;
	points[68] = (-7105.9448, -15156.6143, -15398.3076);
	angles[68] = (0, 73.7280, -879.0652);
	at[68] = 4.5333;
	points[69] = (-7121.3779, -15152.1270, -16000.6689);
	angles[69] = (0, 73.7724, -891.0654);
	at[69] = 4.6000;
	points[70] = (-7136.9688, -15147.5986, -16612.4805);
	angles[70] = (0, 73.8216, -903.0656);
	at[70] = 4.6667;
	points[71] = (-7152.7954, -15142.9922, -17233.7402);
	angles[71] = (0, 73.8760, -915.0657);
	at[71] = 4.7333;
	points[72] = (-7168.7798, -15138.3867, -17864.4492);
	angles[72] = (0, 73.9358, -927.0659);
	at[72] = 4.8000;
	points[73] = (-7184.8032, -15133.7803, -18504.6074);
	angles[73] = (0, 74, -939.0660);
	at[73] = 4.8667;
	points[74] = (-7200.9058, -15129.1738, -19154.2129);
	angles[74] = (0, 74.0723, -951.0662);
	at[74] = 4.9333;
	points[75] = (-7217.0864, -15124.5674, -19813.2676);
	angles[75] = (0, 74.1501, -963.0663);
	at[75] = 5;
	points[76] = (-7233.5430, -15119.9209, -20481.7715);
	angles[76] = (0, 74.2365, -975.0665);
	at[76] = 5.0667;
	points[77] = (-7250.5117, -15115.1191, -21159.7227);
	angles[77] = (0, 74.3344, -987.0667);
	at[77] = 5.1333;
	points[78] = (-7267.4014, -15110.4326, -21847.1250);
	angles[78] = (0, 74.4421, -999.0667);
	at[78] = 5.2000;
	points[79] = (-7284.2124, -15105.7480, -22543.9766);
	angles[79] = (0, 74.5605, -1011.0669);
	at[79] = 5.2667;
	points[80] = (-7302.1260, -15100.8271, -23250.2754);
	angles[80] = (0, 74.7023, -1023.0671);
	at[80] = 5.3333;
	points[81] = (-7320.5117, -15095.8262, -23966.0234);
	angles[81] = (0, 74.8673, -1035.0671);
	at[81] = 5.4000;
	points[82] = (-7338.5039, -15090.9844, -24691.2207);
	angles[82] = (0, 75.0529, -1047.0674);
	at[82] = 5.4667;
	points[83] = (-7357.7559, -15085.9062, -25425.8672);
	angles[83] = (0, 75.2845, -1059.0675);
	at[83] = 5.5333;
	points[84] = (-7378.6616, -15080.4727, -26169.9609);
	angles[84] = (0, 75.5878, -1071.0676);
	at[84] = 5.6000;
	points[85] = (-7398.6611, -15075.3945, -26923.5039);
	angles[85] = (0, 75.9484, -1083.0677);
	at[85] = 5.6667;
	points[86] = (-7423.7793, -15069.2520, -27686.4961);
	angles[86] = (0, 76.5501, -1095.0680);
	at[86] = 5.7333;
	points[87] = (-7448.2285, -15063.5820, -28458.9375);
	angles[87] = (0, 77.4136, -1107.0681);
	at[87] = 5.8000;
	points[88] = (-7478.1104, -15057.0869, -29240.8262);
	angles[88] = (0, 78.0701, -1119.0682);
	at[88] = 5.8667;
	points[89] = (-7513.3071, -15049.8037, -30032.1660);
	angles[89] = (0, 78.4200, -1131.0685);
	at[89] = 5.9333;
	points[90] = (-7548.4253, -15042.6777, -30832.9531);
	angles[90] = (0, 78.6262, -1143.0685);
	at[90] = 6;
	points[91] = (-7585.5117, -15035.2754, -31643.1895);
	angles[91] = (0, 78.7751, -1155.0687);
	at[91] = 6.0667;
	points[92] = (-7621.3779, -15028.1895, -32462.8750);
	angles[92] = (0, 78.8828, -1167.0690);
	at[92] = 6.1333;
	points[93] = (-7659.4883, -15020.7090, -33292.0078);
	angles[93] = (0, 78.9734, -1179.0690);
	at[93] = 6.2000;
	points[94] = (-7695.5122, -15013.7402, -34130.5898);
	angles[94] = (0, 79.0445, -1191.0692);
	at[94] = 6.2667;
	points[95] = (-7732.7163, -15006.5352, -34978.6211);
	angles[95] = (0, 79.1078, -1203.0693);
	at[95] = 6.3333;
	points[96] = (-7770.2759, -14999.3311, -35836.1016);
	angles[96] = (0, 79.1641, -1215.0695);
	at[96] = 6.4000;
	points[97] = (-7807.0083, -14992.3223, -36703.0312);
	angles[97] = (0, 79.2142, -1227.0696);
	at[97] = 6.4667;
	points[98] = (-7844.3701, -14985.2363, -37579.4102);
	angles[98] = (0, 79.2614, -1239.0697);
	at[98] = 6.5333;
	points[99] = (-7881.7324, -14978.1504, -38465.2383);
	angles[99] = (0, 79.3059, -1251.0699);
	at[99] = 6.6000;
	points[100] = (-7918.8589, -14971.1416, -39360.5117);
	angles[100] = (0, 79.3484, -1263.0701);
	at[100] = 6.6667;
	points[101] = (-7956.0630, -14964.1729, -40265.3555);
	angles[101] = (0, 79.3903, -1275.0702);
	at[101] = 6.7333;
	points[102] = (-7993.5044, -14957.1650, -41179.5273);
	angles[102] = (0, 79.4322, -1287.0703);
	at[102] = 6.8000;
	points[103] = (-8030.7871, -14950.2363, -42103.1523);
	angles[103] = (0, 79.4749, -1299.0706);
	at[103] = 6.8667;
	points[104] = (-8067.6777, -14943.3867, -43036.2227);
	angles[104] = (0, 79.5185, -1311.0707);
	at[104] = 6.9333;
	points[105] = (-8105.4336, -14936.4180, -43978.7422);
	angles[105] = (0, 79.5656, -1323.0708);
	at[105] = 7;
	points[106] = (-8142.7563, -14929.5674, -44930.7070);
	angles[106] = (0, 79.6160, -1335.0710);
	at[106] = 7.0667;
	points[107] = (-8179.2129, -14922.9131, -45892.1289);
	angles[107] = (0, 79.6709, -1347.0712);
	at[107] = 7.1333;
	points[108] = (-8217.6377, -14915.9062, -46862.9922);
	angles[108] = (0, 79.7372, -1359.0713);
	at[108] = 7.2000;
	points[109] = (-8254.2129, -14909.3301, -47843.3047);
	angles[109] = (0, 79.8122, -1371.0714);
	at[109] = 7.2667;
	points[110] = (-8292.1660, -14902.5195, -48833.0703);
	angles[110] = (0, 79.9099, -1383.0715);
	at[110] = 7.3333;
	points[111] = (-8329.1338, -14895.9844, -49832.2852);
	angles[111] = (0, 80.0375, -1395.0718);
	at[111] = 7.4000;
	points[112] = (-8361.5752, -14890.3545, -50840.9453);
	angles[112] = (0, 80.1091, -1407.0719);
	at[112] = 7.4667;
	points[113] = (-8397.5986, -14884.0547, -51859.0547);
	angles[113] = (0, 80.1148, -1419.0720);
	at[113] = 7.5333;
	points[114] = (-8438.5830, -14876.8896, -52886.6133);
	angles[114] = (0, 80.1261, -1431.0721);
	at[114] = 7.6000;
	points[115] = (-8472.8350, -14870.9443, -53923.6250);
	angles[115] = (0, 80.1373, -1443.0724);
	at[115] = 7.6667;
	points[116] = (-8509.8818, -14864.5273, -54970.0781);
	angles[116] = (0, 80.1505, -1455.0724);
	at[116] = 7.7333;
	points[117] = (-8549.5283, -14857.6377, -56025.9883);
	angles[117] = (0, 80.1655, -1467.0726);
	at[117] = 7.8000;
	points[118] = (-8585.8271, -14851.3389, -57091.3398);
	angles[118] = (0, 80.1798, -1479.0728);
	at[118] = 7.8667;
	points[119] = (-8622.0078, -14845.0791, -58166.1445);
	angles[119] = (0, 80.1947, -1491.0729);
	at[119] = 7.9333;
	points[120] = (-8659.5674, -14838.6221, -59250.3945);
	angles[120] = (0, 80.2107, -1503.0731);
	at[120] = 8;
	points[121] = (-8698.3467, -14831.9287, -60344.0938);
	angles[121] = (0, 80.2280, -1515.0731);
	at[121] = 8.0667;
	points[122] = (-8735.0791, -14825.5908, -61447.2461);
	angles[122] = (0, 80.2451, -1527.0735);
	at[122] = 8.1333;
	points[123] = (-8771.5752, -14819.3311, -62559.8438);
	angles[123] = (0, 80.2627, -1539.0735);
	at[123] = 8.2000;
	points[124] = (-8808.7793, -14812.9531, -63681.8906);
	angles[124] = (0, 80.2815, -1551.0736);
	at[124] = 8.2667;
	points[125] = (-8846.6143, -14806.4961, -64813.3867);
	angles[125] = (0, 80.3017, -1563.0739);
	at[125] = 8.3333;
	points[126] = (-8884.4482, -14800.0391, -65954.3281);
	angles[126] = (0, 80.3227, -1575.0740);
	at[126] = 8.4000;
	points[127] = (-8921.2207, -14793.7793, -67104.7266);
	angles[127] = (0, 80.3441, -1587.0741);
	at[127] = 8.4667;
	points[128] = (-8958.2676, -14787.4805, -68264.5703);
	angles[128] = (0, 80.3671, -1599.0742);
	at[128] = 8.5333;
	points[129] = (-8995.5518, -14781.1426, -69433.8594);
	angles[129] = (0, 80.3915, -1611.0745);
	at[129] = 8.6000;
	points[130] = (-9032.9922, -14774.8037, -70612.6016);
	angles[130] = (0, 80.4175, -1623.0746);
	at[130] = 8.6667;
	points[131] = (-9070.4336, -14768.5039, -71800.7891);
	angles[131] = (0, 80.4452, -1635.0747);
	at[131] = 8.7333;
	points[132] = (-9107.7949, -14762.2041, -72998.4297);
	angles[132] = (0, 80.4749, -1647.0748);
	at[132] = 8.8000;
	points[133] = (-9145.0791, -14755.9844, -74205.5078);
	angles[133] = (0, 80.5066, -1659.0751);
	at[133] = 8.8667;
	points[134] = (-9182.2051, -14749.7646, -75422.0469);
	angles[134] = (0, 80.5406, -1671.0752);
	at[134] = 8.9333;
	points[135] = (-9219.0947, -14743.6621, -76648.0312);
	angles[135] = (0, 80.5772, -1683.0754);
	at[135] = 9;
	points[136] = (-9256.8896, -14737.4014, -77883.4688);
	angles[136] = (0, 80.6181, -1695.0754);
	at[136] = 9.0667;
	points[137] = (-9294.6855, -14731.1416, -79128.3438);
	angles[137] = (0, 80.6629, -1707.0757);
	at[137] = 9.1333;
	points[138] = (-9331.9688, -14725.0391, -80382.6797);
	angles[138] = (0, 80.7117, -1719.0758);
	at[138] = 9.2000;
	points[139] = (-9368.6221, -14719.0557, -81646.4609);
	angles[139] = (0, 80.7652, -1731.0759);
	at[139] = 9.2667;
	points[140] = (-9405.2754, -14713.1113, -82919.6797);
	angles[140] = (0, 80.8250, -1743.0760);
	at[140] = 9.3333;
	points[141] = (-9444.0947, -14706.8896, -84202.3594);
	angles[141] = (0, 80.8967, -1755.0762);
	at[141] = 9.4000;
	points[142] = (-9481.8115, -14700.8662, -85494.4922);
	angles[142] = (0, 80.9771, -1767.0764);
	at[142] = 9.4667;
	points[143] = (-9518.3467, -14695.0791, -86796.0703);
	angles[143] = (0, 81.0678, -1779.0765);
	at[143] = 9.5333;
	points[144] = (-9553.9766, -14689.5283, -88107.0859);
	angles[144] = (0, 81.1720, -1791.0767);
	at[144] = 9.6000;
	points[145] = (-9593.9375, -14683.3467, -89427.5625);
	angles[145] = (0, 81.3144, -1803.0769);
	at[145] = 9.6667;
	points[146] = (-9631.6934, -14677.6387, -90757.4844);
	angles[146] = (0, 81.4840, -1815.0770);
	at[146] = 9.7333;
	points[147] = (-9667.0469, -14672.4404, -92096.8516);
	angles[147] = (0, 81.6896, -1827.0771);
	at[147] = 9.8000;
	points[148] = (-9705.9844, -14666.8506, -93445.6719);
	angles[148] = (0, 82.0028, -1839.0773);
	at[148] = 9.8667;
	points[149] = (-9744.5664, -14661.5742, -94803.9375);
	angles[149] = (0, 82.4804, -1851.0775);
	at[149] = 9.9333;
	points[150] = (-9777.4805, -14657.4023, -96171.6562);
	angles[150] = (0, 83.1874, -1863.0776);
	at[150] = 10;
	points[151] = (-9812.3623, -14653.4648, -97548.8203);
	angles[151] = (0, 83.9130, -1875.0778);
	at[151] = 10.0667;
	points[152] = (-9851.1416, -14649.5273, -98935.4297);
	angles[152] = (0, 84.4620, -1887.0779);
	at[152] = 10.1333;
	points[153] = (-9888.5439, -14646.0635, -100331.4922);
	angles[153] = (0, 84.8486, -1899.0781);
	at[153] = 10.2000;
	points[154] = (-9925.5908, -14642.7959, -101737.0156);
	angles[154] = (0, 85.1464, -1911.0782);
	at[154] = 10.2667;
	points[155] = (-9964.6064, -14639.6064, -103151.9688);
	angles[155] = (0, 85.3989, -1923.0784);
	at[155] = 10.3333;
	points[156] = (-10001.6543, -14636.6533, -104576.3750);
	angles[156] = (0, 85.5977, -1935.0785);
	at[156] = 10.4000;
	points[157] = (-10038.9375, -14633.8594, -106010.2344);
	angles[157] = (0, 85.7680, -1947.0769);
	at[157] = 10.4667;
	points[158] = (-10077.2832, -14631.0635, -107453.5469);
	angles[158] = (0, 85.9196, -1959.0753);
	at[158] = 10.5333;
	points[159] = (-10115.0791, -14628.4258, -108906.2969);
	angles[159] = (0, 86.0506, -1971.0737);
	at[159] = 10.6000;
	points[160] = (-10152.3623, -14625.9053, -110368.5078);
	angles[160] = (0, 86.1656, -1983.0720);
	at[160] = 10.6667;
	points[161] = (-10190.1963, -14623.3857, -111840.1562);
	angles[161] = (0, 86.2708, -1995.0706);
	at[161] = 10.7333;
	points[162] = (-10228.4258, -14620.9453, -113321.2656);
	angles[162] = (0, 86.3672, -2007.0691);
	at[162] = 10.8000;
	points[163] = (-10265.8662, -14618.5830, -114811.8125);
	angles[163] = (0, 86.4537, -2019.0674);
	at[163] = 10.8667;
	points[164] = (-10303.5049, -14616.2598, -116311.8125);
	angles[164] = (0, 86.5341, -2031.0657);
	at[164] = 10.9333;
	points[165] = (-10341.2598, -14614.0166, -117821.2578);
	angles[165] = (0, 86.6092, -2043.0642);
	at[165] = 11;
	points[166] = (-10379.1338, -14611.7725, -119340.1562);
	angles[166] = (0, 86.6797, -2055.0625);
	at[166] = 11.0667;
	points[167] = (-10416.9688, -14609.6074, -120868.5078);
	angles[167] = (0, 86.7465, -2067.0608);
	at[167] = 11.1333;
	points[168] = (-10454.6455, -14607.4805, -122406.3047);
	angles[168] = (0, 86.8094, -2079.0593);
	at[168] = 11.2000;
	points[169] = (-10491.9688, -14605.4336, -123953.5391);
	angles[169] = (0, 86.8693, -2091.0576);
	at[169] = 11.2667;
	points[170] = (-10530.3154, -14603.3457, -125510.2344);
	angles[170] = (0, 86.9285, -2103.0562);
	at[170] = 11.3333;
	points[171] = (-10568.1895, -14601.3389, -127076.3828);
	angles[171] = (0, 86.9856, -2115.0544);
	at[171] = 11.4000;
	points[172] = (-10605.4326, -14599.4102, -128651.9688);
	angles[172] = (0, 87.0405, -2127.0530);
	at[172] = 11.4667;
	points[173] = (-10643.3066, -14597.4805, -130237.0078);
	angles[173] = (0, 87.0959, -2139.0513);
	at[173] = 11.5333;
	points[174] = (-10681.7324, -14595.5508, -131831.5000);
	angles[174] = (0, 87.1525, -2151.0498);
	at[174] = 11.6000;
	points[175] = (-10718.9365, -14593.7002, -133435.4375);
	angles[175] = (0, 87.2081, -2163.0481);
	at[175] = 11.6667;
	points[176] = (-10756.3389, -14591.8896, -135048.8125);
	angles[176] = (0, 87.2662, -2175.0466);
	at[176] = 11.7333;
	points[177] = (-10795.2764, -14590.0400, -136671.6562);
	angles[177] = (0, 87.3306, -2187.0449);
	at[177] = 11.8000;
	points[178] = (-10831.9297, -14588.3867, -138303.9375);
	angles[178] = (0, 87.3971, -2199.0432);
	at[178] = 11.8667;
	points[179] = (-10870.4336, -14586.6543, -139945.6719);
	angles[179] = (0, 87.4777, -2211.0417);
	at[179] = 11.9333;
	points[180] = (-10908.3467, -14585, -141596.8594);
	angles[180] = (0, 87.5766, -2223.0400);
	at[180] = 12;
	points[181] = (-10941.5361, -14583.6230, -143257.4844);
	angles[181] = (0, 87.7566, -2235.0386);
	at[181] = 12.0667;
	points[182] = (-10977.2441, -14582.3223, -144927.5625);
	angles[182] = (0, 87.9892, -2247.0371);
	at[182] = 12.1333;
	points[183] = (-11018.5830, -14580.9443, -146607.0938);
	angles[183] = (0, 88.1529, -2259.0354);
	at[183] = 12.2000;
	points[184] = (-11053.5820, -14579.8428, -148296.0625);
	angles[184] = (0, 88.2495, -2271.0337);
	at[184] = 12.2667;
	points[185] = (-11091.0244, -14578.7012, -149994.5000);
	angles[185] = (0, 88.3296, -2283.0322);
	at[185] = 12.3333;
	points[186] = (-11130.9062, -14577.5986, -151702.3594);
	angles[186] = (0, 88.3980, -2295.0305);
	at[186] = 12.4000;
	points[187] = (-11167.3223, -14576.5752, -153419.6875);
	angles[187] = (0, 88.4503, -2307.0291);
	at[187] = 12.4667;
	points[188] = (-11204.3311, -14575.5908, -155146.4531);
	angles[188] = (0, 88.4964, -2319.0273);
	at[188] = 12.5333;
	points[189] = (-11242.6377, -14574.6064, -156882.6875);
	angles[189] = (0, 88.5389, -2331.0259);
	at[189] = 12.6000;
	points[190] = (-11281.2207, -14573.6230, -158628.3438);
	angles[190] = (0, 88.5776, -2343.0242);
	at[190] = 12.6667;
	points[191] = (-11317.9922, -14572.7168, -160383.4688);
	angles[191] = (0, 88.6116, -2355.0227);
	at[191] = 12.7333;
	points[192] = (-11355.4336, -14571.8506, -162148.0312);
	angles[192] = (0, 88.6443, -2367.0210);
	at[192] = 12.8000;
	points[193] = (-11393.4258, -14570.9443, -163922.0469);
	angles[193] = (0, 88.6757, -2379.0193);
	at[193] = 12.8667;
	points[194] = (-11431.5352, -14570.0781, -165705.5156);
	angles[194] = (0, 88.7060, -2391.0178);
	at[194] = 12.9333;
	points[195] = (-11468.8975, -14569.2520, -167498.4219);
	angles[195] = (0, 88.7351, -2403.0164);
	at[195] = 13;
	points[196] = (-11506.4570, -14568.4248, -169300.7969);
	angles[196] = (0, 88.7640, -2415.0144);
	at[196] = 13.0667;
	points[197] = (-11544.0947, -14567.5986, -171112.5938);
	angles[197] = (0, 88.7928, -2427.0129);
	at[197] = 13.1333;
	points[198] = (-11581.7324, -14566.8496, -172933.8594);
	angles[198] = (0, 88.8220, -2439.0115);
	at[198] = 13.2000;
	points[199] = (-11619.7246, -14566.0635, -174764.5625);
	angles[199] = (0, 88.8520, -2451.0098);
	at[199] = 13.2667;
	points[200] = (-11657.4414, -14565.3154, -176604.7188);
	angles[200] = (0, 88.8829, -2463.0083);
	at[200] = 13.3333;
	points[201] = (-11694.8428, -14564.6064, -178454.3438);
	angles[201] = (0, 88.9149, -2475.0066);
	at[201] = 13.4000;
	points[202] = (-11731.8115, -14563.8984, -180313.3906);
	angles[202] = (0, 88.9483, -2487.0051);
	at[202] = 13.4667;
	points[203] = (-11770.4727, -14563.2285, -182181.8906);
	angles[203] = (0, 88.9857, -2499.0034);
	at[203] = 13.5333;
	points[204] = (-11808.4648, -14562.5596, -184059.8438);
	angles[204] = (0, 89.0257, -2511.0017);
	at[204] = 13.6000;
	points[205] = (-11845.5518, -14561.9287, -185947.2500);
	angles[205] = (0, 89.0690, -2523);
	at[205] = 13.6667;
	points[206] = (-11882.1660, -14561.3389, -187844.1094);
	angles[206] = (0, 89.1167, -2534.9985);
	at[206] = 13.7333;
	points[207] = (-11921.5752, -14560.7480, -189750.4062);
	angles[207] = (0, 89.1759, -2546.9971);
	at[207] = 13.8000;
	points[208] = (-11959.3311, -14560.2363, -191666.1406);
	angles[208] = (0, 89.2429, -2558.9954);
	at[208] = 13.8667;
	points[209] = (-11995.1572, -14559.8037, -193591.3438);
	angles[209] = (0, 89.3202, -2570.9939);
	at[209] = 13.9333;
	points[210] = (-12034.5674, -14559.3711, -195525.9844);
	angles[210] = (0, 89.4281, -2582.9922);
	at[210] = 14;
	points[211] = (-12072.7168, -14559.0166, -197470.0938);
	angles[211] = (0, 89.5705, -2594.9907);
	at[211] = 14.0667;
	points[212] = (-12107.0078, -14558.8193, -199423.6250);
	angles[212] = (0, 89.7569, -2606.9890);
	at[212] = 14.1333;
	points[213] = (-12148.8584, -14558.7793, -201386.6250);
	angles[213] = (0, 90.1615, -2618.9873);
	at[213] = 14.2000;
	points[214] = (-12181.8506, -14559.0547, -203359.0469);
	angles[214] = (0, 90.9673, -2630.9858);
	at[214] = 14.2667;
	points[215] = (-12219.2520, -14560.1582, -205340.9531);
	angles[215] = (0, 92.3293, -2642.9841);
	at[215] = 14.3333;
	points[216] = (-12256.6934, -14562.0479, -207332.2969);
	angles[216] = (0, 93.4724, -2654.9827);
	at[216] = 14.4000;
	points[217] = (-12294.1338, -14564.6455, -209333.0781);
	angles[217] = (0, 94.4348, -2666.9810);
	at[217] = 14.4667;
	points[218] = (-12331.4170, -14567.8350, -211343.3125);
	angles[218] = (0, 95.2417, -2678.9795);
	at[218] = 14.5333;
	points[219] = (-12368.7393, -14571.4561, -213362.9844);
	angles[219] = (0, 95.9157, -2690.9778);
	at[219] = 14.6000;
	points[220] = (-12405.9443, -14575.5117, -215392.1250);
	angles[220] = (0, 96.4677, -2702.9763);
	at[220] = 14.6667;
	points[221] = (-12443.0322, -14579.8428, -217430.7188);
	angles[221] = (0, 96.9039, -2714.9746);
	at[221] = 14.7333;
	points[222] = (-12480.2754, -14584.4893, -219478.7344);
	angles[222] = (0, 97.2264, -2726.9729);
	at[222] = 14.8000;
	points[223] = (-12517.4014, -14589.2520, -221536.2188);
	angles[223] = (0, 97.4248, -2738.9714);
	at[223] = 14.8667;
	points[224] = (-12554.2910, -14594.0947, -223603.1562);
	angles[224] = (0, 97.4818, -2750.9700);
	at[224] = 14.9333;
	points[225] = (-12591.4570, -14598.9365, -225679.5156);
	angles[225] = (0, 97.3624, -2762.9683);
	at[225] = 15;
	points[226] = (-12628.7402, -14603.6621, -227765.3594);
	angles[226] = (0, 96.9961, -2774.9668);
	at[226] = 15.0667;
	points[227] = (-12666.0244, -14608.0322, -229860.6250);
	angles[227] = (0, 96.2471, -2786.9651);
	at[227] = 15.1333;
	points[228] = (-12666.0244, -14608.0322, -229860.6250);
	angles[228] = (0, 96.2471, -2786.9651);
	at[228] = 15.1500;
	points[229] = (-6427.3228, -15354.9219, 3371.7561);
	angles[229] = (0, 96.2471, -2786.9651);
	at[229] = 15.1500;
	points[230] = (-6428.7007, -15354.5283, 3395.3779);
	angles[230] = (0, 74.0521, -2943.0549);
	at[230] = 15.2000;
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
	points[0] = (-1028.7323, -6323.0713, 4211.9688);
	angles[0] = (0, 116.1088, 146.9386);
	at[0] = 0;
	points[1] = (-1051.1930, -6335.1182, 4260.7085);
	angles[1] = (0, 119.9845, 131.9384);
	at[1] = 0.0833;
	points[2] = (-1072.4292, -6348.0317, 4294.6455);
	angles[2] = (0, 122.4572, 116.9382);
	at[2] = 0.1667;
	points[3] = (-1092.5118, -6361.2202, 4313.8584);
	angles[3] = (0, 123.9976, 101.9381);
	at[3] = 0.2500;
	points[4] = (-1112.0118, -6374.6060, 4318.2676);
	angles[4] = (0, 124.9143, 86.9378);
	at[4] = 0.3333;
	points[5] = (-1131.0433, -6388.0312, 4307.9526);
	angles[5] = (0, 125.3643, 71.9377);
	at[5] = 0.4167;
	points[6] = (-1150.1969, -6401.6538, 4282.8345);
	angles[6] = (0, 125.4473, 56.9374);
	at[6] = 0.5000;
	points[7] = (-1169.0709, -6415.0396, 4242.9922);
	angles[7] = (0, 125.2173, 41.9373);
	at[7] = 0.5833;
	points[8] = (-1188.3977, -6428.5825, 4188.3467);
	angles[8] = (0, 124.6999, 26.9371);
	at[8] = 0.6667;
	points[9] = (-1207.8937, -6441.8896, 4118.9766);
	angles[9] = (0, 123.9179, 11.9369);
	at[9] = 0.7500;
	points[10] = (-1227.8347, -6455.0391, 4034.8032);
	angles[10] = (0, 122.8701, -3.0633);
	at[10] = 0.8333;
	points[11] = (-1248.5591, -6468.1099, 3935.8938);
	angles[11] = (0, 121.5334, -18.0635);
	at[11] = 0.9167;
	points[12] = (-1269.9725, -6480.8271, 3822.2126);
	angles[12] = (0, 119.9017, -33.0638);
	at[12] = 1;
	points[13] = (-1292.3346, -6493.1890, 3693.7678);
	angles[13] = (0, 117.9384, -48.0639);
	at[13] = 1.0833;
	points[14] = (-1316.3307, -6505.3149, 3550.5588);
	angles[14] = (0, 115.5495, -63.0640);
	at[14] = 1.1667;
	points[15] = (-1341.2953, -6516.5356, 3392.5867);
	angles[15] = (0, 112.7692, -78.0642);
	at[15] = 1.2500;
	points[16] = (-1369.5472, -6527.4019, 3219.8506);
	angles[16] = (0, 109.2802, -93.0644);
	at[16] = 1.3333;
	points[17] = (-1399.5867, -6536.7324, 3032.3503);
	angles[17] = (0, 105.2076, -108.0647);
	at[17] = 1.4167;
	points[18] = (-1434.8779, -6544.6851, 2830.0867);
	angles[18] = (0, 100.0147, -123.0648);
	at[18] = 1.5000;
	points[19] = (-1476.0946, -6549.6064, 2613.0588);
	angles[19] = (0, 93.5350, -138.0650);
	at[19] = 1.5833;
	points[20] = (-1521.5118, -6549.4492, 2381.2678);
	angles[20] = (0, 86.2241, -153.0652);
	at[20] = 1.6667;
	points[21] = (-1576.2520, -6543.7402, 2134.7126);
	angles[21] = (0, 82.6029, -168.0654);
	at[21] = 1.7500;
	points[22] = (-1633.5826, -6535.4727, 1873.3938);
	angles[22] = (0, 81.1685, -183.0656);
	at[22] = 1.8333;
	points[23] = (-1691.2086, -6526.1025, 1597.3110);
	angles[23] = (0, 80.3720, -198.0657);
	at[23] = 1.9167;
	points[24] = (-1751.5276, -6515.5513, 1306.4646);
	angles[24] = (0, 79.8322, -213.0660);
	at[24] = 2;
	points[25] = (-1807.2795, -6505.3540, 1000.8543);
	angles[25] = (0, 79.4756, -228.0661);
	at[25] = 2.0833;
	points[26] = (-1866.4843, -6494.2129, 680.4803);
	angles[26] = (0, 79.1879, -243.0663);
	at[26] = 2.1667;
	points[27] = (-1925.5787, -6482.7949, 345.3409);
	angles[27] = (0, 78.9626, -258.0665);
	at[27] = 2.2500;
	points[28] = (-1982.2914, -6471.6143, -4.5606);
	angles[28] = (0, 78.7874, -273.0668);
	at[28] = 2.3333;
	points[29] = (-2040.6890, -6459.9604, -369.2260);
	angles[29] = (0, 78.6380, -288.0669);
	at[29] = 2.4167;
	points[30] = (-2100.1025, -6447.9526, -748.6536);
	angles[30] = (0, 78.5108, -303.0671);
	at[30] = 2.5000;
	points[31] = (-2157.2756, -6436.2993, -1142.8464);
	angles[31] = (0, 78.4071, -318.0672);
	at[31] = 2.5833;
	points[32] = (-2215.1377, -6424.3701, -1551.8031);
	angles[32] = (0, 78.3176, -333.0674);
	at[32] = 2.6667;
	points[33] = (-2273.4370, -6412.2832, -1975.5236);
	angles[33] = (0, 78.2406, -348.0676);
	at[33] = 2.7500;
	points[34] = (-2331.7402, -6400.1182, -2414.0078);
	angles[34] = (0, 78.1749, -363.0678);
	at[34] = 2.8333;
	points[35] = (-2389.8425, -6387.9136, -2867.2559);
	angles[35] = (0, 78.1197, -378.0681);
	at[35] = 2.9167;
	points[36] = (-2447.6221, -6375.7085, -3335.2676);
	angles[36] = (0, 78.0741, -393.0682);
	at[36] = 3;
	points[37] = (-2504.9685, -6363.5825, -3818.0435);
	angles[37] = (0, 78.0374, -408.0683);
	at[37] = 3.0833;
	points[38] = (-2564.2441, -6351.0234, -4315.5903);
	angles[38] = (0, 78.0090, -423.0685);
	at[38] = 3.1667;
	points[39] = (-2622.3191, -6338.6616, -4827.8740);
	angles[39] = (0, 77.9907, -438.0687);
	at[39] = 3.2500;
	points[40] = (-2678.9055, -6326.6143, -5354.9609);
	angles[40] = (0, 77.9829, -453.0690);
	at[40] = 3.3333;
	points[41] = (-2738.2009, -6314.0161, -5896.7715);
	angles[41] = (0, 77.9873, -468.0691);
	at[41] = 3.4167;
	points[42] = (-2797.0237, -6301.4961, -6453.3857);
	angles[42] = (0, 78.0081, -483.0693);
	at[42] = 3.5000;
	points[43] = (-2852.7913, -6289.6851, -7024.7241);
	angles[43] = (0, 78.0479, -498.0695);
	at[43] = 3.5833;
	points[44] = (-2913.0081, -6276.9683, -7610.8662);
	angles[44] = (0, 78.1246, -513.0696);
	at[44] = 3.6667;
	points[45] = (-2971.1692, -6264.8037, -8211.7324);
	angles[45] = (0, 78.2552, -528.0699);
	at[45] = 3.7500;
	points[46] = (-3027.9016, -6253.1099, -8827.4014);
	angles[46] = (0, 78.4927, -543.0701);
	at[46] = 3.8333;
	points[47] = (-3087.5195, -6241.2202, -9457.7949);
	angles[47] = (0, 79.0858, -558.0703);
	at[47] = 3.9167;
	points[48] = (-3139.3384, -6231.4961, -10102.9922);
	angles[48] = (0, 79.2360, -573.0705);
	at[48] = 4;
	points[49] = (-3197.7441, -6220.1968, -10762.9131);
	angles[49] = (0, 78.8868, -588.0706);
	at[49] = 4.0833;
	points[50] = (-3255.2168, -6208.8188, -11437.6377);
	angles[50] = (0, 78.7289, -603.0707);
	at[50] = 4.1667;
	points[51] = (-3312.5669, -6197.3618, -12127.0869);
	angles[51] = (0, 78.6940, -618.0710);
	at[51] = 4.2500;
	points[52] = (-3370.3545, -6185.8267, -12831.3379);
	angles[52] = (0, 78.7560, -633.0712);
	at[52] = 4.3333;
	points[53] = (-3427.5828, -6174.4883, -13550.3154);
	angles[53] = (0, 78.9037, -648.0714);
	at[53] = 4.4167;
	points[54] = (-3485.1260, -6163.3462, -14284.0947);
	angles[54] = (0, 79.1408, -663.0715);
	at[54] = 4.5000;
	points[55] = (-3542.3228, -6152.5200, -15032.5986);
	angles[55] = (0, 79.4764, -678.0717);
	at[55] = 4.5833;
	points[56] = (-3600.1418, -6142.0083, -15795.9062);
	angles[56] = (0, 79.9424, -693.0719);
	at[56] = 4.6667;
	points[57] = (-3657.5081, -6132.1655, -16573.9375);
	angles[57] = (0, 80.5773, -708.0721);
	at[57] = 4.7500;
	points[58] = (-3714.8660, -6123.0708, -17366.7715);
	angles[58] = (0, 81.4712, -723.0723);
	at[58] = 4.8333;
	points[59] = (-3773.3071, -6114.9609, -18174.3301);
	angles[59] = (0, 82.8341, -738.0724);
	at[59] = 4.9167;
	points[60] = (-3831.5276, -6108.7007, -18996.6934);
	angles[60] = (0, 85.1107, -753.0728);
	at[60] = 5;
	points[61] = (-3889.9646, -6105.7876, -19833.7812);
	angles[61] = (0, 89.9836, -768.0729);
	at[61] = 5.0833;
	points[62] = (-3944.7244, -6110.7090, -20685.6699);
	angles[62] = (0, 100.1155, -783.0731);
	at[62] = 5.1667;
	points[63] = (-4001.8506, -6124.0552, -21552.2832);
	angles[63] = (0, 105.5440, -798.0732);
	at[63] = 5.2500;
	points[64] = (-4057.7166, -6141.2993, -22433.7012);
	angles[64] = (0, 108.5568, -813.0734);
	at[64] = 5.3333;
	points[65] = (-4112.8740, -6161.0239, -23329.8438);
	angles[65] = (0, 110.6550, -828.0736);
	at[65] = 5.4167;
	points[66] = (-4167.4800, -6182.5591, -24240.7871);
	angles[66] = (0, 112.3251, -843.0739);
	at[66] = 5.5000;
	points[67] = (-4221.3389, -6205.4727, -25166.4590);
	angles[67] = (0, 113.7913, -858.0741);
	at[67] = 5.5833;
	points[68] = (-4274.4883, -6229.6851, -26106.9297);
	angles[68] = (0, 115.2039, -873.0742);
	at[68] = 5.6667;
	points[69] = (-4327.2837, -6255.3936, -27062.1250);
	angles[69] = (0, 116.7134, -888.0744);
	at[69] = 5.7500;
	points[70] = (-4379.3701, -6282.5986, -28032.1270);
	angles[70] = (0, 118.5170, -903.0746);
	at[70] = 5.8333;
	points[71] = (-4430.3936, -6311.6929, -29016.8516);
	angles[71] = (0, 121.0535, -918.0748);
	at[71] = 5.9167;
	points[72] = (-4479.4883, -6343.7012, -30016.3789);
	angles[72] = (0, 125.8596, -933.0750);
	at[72] = 6;
	points[73] = (-4522.0474, -6380.2363, -31030.6289);
	angles[73] = (0, 134.6683, -948.0751);
	at[73] = 6.0833;
	points[74] = (-4562.1655, -6422.7559, -32059.6855);
	angles[74] = (0, 138.1521, -963.0754);
	at[74] = 6.1667;
	points[75] = (-4600.3936, -6466.8901, -33103.4648);
	angles[75] = (0, 139.8613, -978.0756);
	at[75] = 6.2500;
	points[76] = (-4637.9526, -6512.3623, -34162.0469);
	angles[76] = (0, 140.8993, -993.0756);
	at[76] = 6.3333;
	points[77] = (-4675.0396, -6558.5825, -35235.3555);
	angles[77] = (0, 141.5828, -1008.0760);
	at[77] = 6.4167;
	points[78] = (-4711.1421, -6604.4883, -36323.4648);
	angles[78] = (0, 142.0392, -1023.0760);
	at[78] = 6.5000;
	points[79] = (-4747.2837, -6651.0630, -37426.3008);
	angles[79] = (0, 142.3442, -1038.0764);
	at[79] = 6.5833;
	points[80] = (-4782.9526, -6697.4805, -38543.9375);
	angles[80] = (0, 142.5203, -1053.0765);
	at[80] = 6.6667;
	points[81] = (-4818.8979, -6744.4097, -39676.3789);
	angles[81] = (0, 142.5742, -1068.0767);
	at[81] = 6.7500;
	points[82] = (-4854.8428, -6791.2988, -40823.6250);
	angles[82] = (0, 142.4832, -1083.0769);
	at[82] = 6.8333;
	points[83] = (-4890.4331, -6837.4805, -41985.4375);
	angles[83] = (0, 142.1875, -1098.0770);
	at[83] = 6.9167;
	points[84] = (-4926.4961, -6883.4253, -43162.2031);
	angles[84] = (0, 141.5049, -1113.0773);
	at[84] = 7;
	points[85] = (-4963.6616, -6928.9370, -44353.5430);
	angles[85] = (0, 139.7110, -1128.0775);
	at[85] = 7.0833;
	points[86] = (-5000.7085, -6973.1104, -45559.8438);
	angles[86] = (0, 140.2642, -1143.0775);
	at[86] = 7.1667;
	points[87] = (-5037.5591, -7017.5981, -46780.7070);
	angles[87] = (0, 140.4493, -1158.0778);
	at[87] = 7.2500;
	points[88] = (-5075.1973, -7063.2285, -48016.5352);
	angles[88] = (0, 140.4679, -1173.0780);
	at[88] = 7.3333;
	points[89] = (-5113.5039, -7109.6064, -49266.9297);
	angles[89] = (0, 140.3998, -1188.0781);
	at[89] = 7.4167;
	points[90] = (-5150.5117, -7154.2520, -50532.2852);
	angles[90] = (0, 140.2786, -1203.0784);
	at[90] = 7.5000;
	points[91] = (-5188.6221, -7199.9604, -51812.2070);
	angles[91] = (0, 140.1063, -1218.0781);
	at[91] = 7.5833;
	points[92] = (-5226.3779, -7244.9609, -53107.0898);
	angles[92] = (0, 139.8889, -1233.0760);
	at[92] = 7.6667;
	points[93] = (-5264.6455, -7290.1577, -54416.5391);
	angles[93] = (0, 139.6163, -1248.0741);
	at[93] = 7.7500;
	points[94] = (-5302.9531, -7334.9604, -55740.9453);
	angles[94] = (0, 139.2803, -1263.0721);
	at[94] = 7.8333;
	points[95] = (-5341.7715, -7379.7246, -57079.9219);
	angles[95] = (0, 138.8570, -1278.0701);
	at[95] = 7.9167;
	points[96] = (-5380.5513, -7423.7007, -58433.8594);
	angles[96] = (0, 138.3204, -1293.0681);
	at[96] = 8;
	points[97] = (-5420.5518, -7468.1104, -59802.3633);
	angles[97] = (0, 137.5919, -1308.0660);
	at[97] = 8.0833;
	points[98] = (-5460.0396, -7510.6304, -61185.8281);
	angles[98] = (0, 136.5943, -1323.0642);
	at[98] = 8.1667;
	points[99] = (-5501.6143, -7553.5039, -62583.8594);
	angles[99] = (0, 135, -1338.0620);
	at[99] = 8.2500;
	points[100] = (-5544.9214, -7594.8423, -63996.8516);
	angles[100] = (0, 131.9850, -1353.0602);
	at[100] = 8.3333;
	points[101] = (-5586.1416, -7628.9766, -65424.4102);
	angles[101] = (0, 127.6103, -1368.0582);
	at[101] = 8.4167;
	points[102] = (-5634.6064, -7664.7246, -66866.9297);
	angles[102] = (0, 125.5215, -1383.0560);
	at[102] = 8.5000;
	points[103] = (-5683.5039, -7698.8979, -68324.0156);
	angles[103] = (0, 124.4182, -1398.0541);
	at[103] = 8.5833;
	points[104] = (-5731.7720, -7731.4966, -69796.0625);
	angles[104] = (0, 123.6957, -1413.0521);
	at[104] = 8.6667;
	points[105] = (-5782.3228, -7764.8428, -71282.6797);
	angles[105] = (0, 123.1306, -1428.0502);
	at[105] = 8.7500;
	points[106] = (-5831.0239, -7796.3384, -72784.2500);
	angles[106] = (0, 122.6895, -1443.0481);
	at[106] = 8.8333;
	points[107] = (-5881.5356, -7828.5039, -74300.3906);
	angles[107] = (0, 122.2961, -1458.0461);
	at[107] = 8.9167;
	points[108] = (-5931.2603, -7859.7241, -75831.5000);
	angles[108] = (0, 121.9466, -1473.0441);
	at[108] = 9;
	points[109] = (-5981.6143, -7890.9058, -77377.1641);
	angles[109] = (0, 121.6130, -1488.0421);
	at[109] = 9.0833;
	points[110] = (-6032.2441, -7921.8901, -78937.7969);
	angles[110] = (0, 121.2839, -1503.0402);
	at[110] = 9.1667;
	points[111] = (-6082.5591, -7952.2837, -80512.9922);
	angles[111] = (0, 120.9494, -1518.0382);
	at[111] = 9.2500;
	points[112] = (-6133.8975, -7982.8350, -82103.1484);
	angles[112] = (0, 120.5854, -1533.0361);
	at[112] = 9.3333;
	points[113] = (-6184.3311, -8012.4019, -83707.8750);
	angles[113] = (0, 120.1847, -1548.0342);
	at[113] = 9.4167;
	points[114] = (-6236.4570, -8042.4409, -85327.5625);
	angles[114] = (0, 119.6928, -1563.0321);
	at[114] = 9.5000;
	points[115] = (-6286.5352, -8070.6694, -86961.8125);
	angles[115] = (0, 119.0880, -1578.0302);
	at[115] = 9.5833;
	points[116] = (-6340.1182, -8099.9214, -88611.0234);
	angles[116] = (0, 118.1572, -1593.0282);
	at[116] = 9.6667;
	points[117] = (-6392.8740, -8127.3232, -90274.8047);
	angles[117] = (0, 116.5249, -1608.0262);
	at[117] = 9.7500;
	points[118] = (-6442.3623, -8150.3154, -91953.5469);
	angles[118] = (0, 112.7376, -1623.0242);
	at[118] = 9.8333;
	points[119] = (-6497.9531, -8171.5747, -93646.8438);
	angles[119] = (0, 109.5174, -1638.0222);
	at[119] = 9.9167;
	points[120] = (-6554.4092, -8190.5508, -95355.1172);
	angles[120] = (0, 107.7653, -1653.0201);
	at[120] = 10;
	points[121] = (-6610.0396, -8207.7168, -97077.9531);
	angles[121] = (0, 106.6191, -1668.0182);
	at[121] = 10.0833;
	points[122] = (-6667.0078, -8224.2520, -98815.7500);
	angles[122] = (0, 105.7447, -1683.0161);
	at[122] = 10.1667;
	points[123] = (-6724.2524, -8239.9609, -100568.1094);
	angles[123] = (0, 105.0389, -1698.0143);
	at[123] = 10.2500;
	points[124] = (-6781.1812, -8254.9609, -102335.4375);
	angles[124] = (0, 104.4389, -1713.0122);
	at[124] = 10.3333;
	points[125] = (-6838.5825, -8269.4492, -104117.3281);
	angles[125] = (0, 103.8937, -1728.0101);
	at[125] = 10.4167;
	points[126] = (-6895.8662, -8283.3467, -105914.1719);
	angles[126] = (0, 103.3769, -1743.0082);
	at[126] = 10.5000;
	points[127] = (-6953.7402, -8296.8115, -107725.5938);
	angles[127] = (0, 102.8533, -1758.0062);
	at[127] = 10.5833;
	points[128] = (-7010.9053, -8309.5674, -109551.9766);
	angles[128] = (0, 102.2991, -1773.0042);
	at[128] = 10.6667;
	points[129] = (-7068.9370, -8321.8906, -111392.9062);
	angles[129] = (0, 101.6432, -1788.0022);
	at[129] = 10.7500;
	points[130] = (-7127.5200, -8333.5039, -113248.8203);
	angles[130] = (0, 100.7664, -1803);
	at[130] = 10.8333;
	points[131] = (-7185.9448, -8343.9375, -115119.2969);
	angles[131] = (0, 99.3149, -1817.9983);
	at[131] = 10.9167;
	points[132] = (-7239.9214, -8351.4570, -117004.7266);
	angles[132] = (0, 96.1951, -1832.9962);
	at[132] = 11;
	points[133] = (-7299.1733, -8356.6924, -118904.7266);
	angles[133] = (0, 94.2364, -1847.9941);
	at[133] = 11.0833;
	points[134] = (-7359.0161, -8360.5518, -120819.6875);
	angles[134] = (0, 93.2355, -1862.9922);
	at[134] = 11.1667;
	points[135] = (-7417.7168, -8363.5439, -122749.2188);
	angles[135] = (0, 92.6105, -1877.9902);
	at[135] = 11.2500;
	points[136] = (-7476.5747, -8365.9844, -124693.7031);
	angles[136] = (0, 92.1615, -1892.9883);
	at[136] = 11.3333;
	points[137] = (-7536.1416, -8368.0322, -126652.7578);
	angles[137] = (0, 91.8115, -1907.9862);
	at[137] = 11.4167;
	points[138] = (-7594.8423, -8369.7637, -128626.7812);
	angles[138] = (0, 91.5319, -1922.9843);
	at[138] = 11.5000;
	points[139] = (-7654.0947, -8371.2207, -130615.3516);
	angles[139] = (0, 91.2934, -1937.9823);
	at[139] = 11.5833;
	points[140] = (-7713.0312, -8372.4414, -132618.9062);
	angles[140] = (0, 91.0852, -1952.9802);
	at[140] = 11.6667;
	points[141] = (-7772.4409, -8373.4648, -134637.0156);
	angles[141] = (0, 90.8947, -1967.9783);
	at[141] = 11.7500;
	points[142] = (-7830.5908, -8374.2910, -136670.0781);
	angles[142] = (0, 90.7179, -1982.9763);
	at[142] = 11.8333;
	points[143] = (-7890.7085, -8374.9219, -138717.7188);
	angles[143] = (0, 90.5353, -1997.9744);
	at[143] = 11.9167;
	points[144] = (-7950.1577, -8375.3936, -140780.3125);
	angles[144] = (0, 90.3391, -2012.9722);
	at[144] = 12;
	points[145] = (-8008.8975, -8375.6299, -142857.4844);
	angles[145] = (0, 90.0909, -2027.9702);
	at[145] = 12.0833;
	points[146] = (-8064.7241, -8375.4727, -144949.6094);
	angles[146] = (0, 89.3115, -2042.9683);
	at[146] = 12.1667;
	points[147] = (-8124.0552, -8374.0557, -147056.2969);
	angles[147] = (0, 88.0991, -2057.9663);
	at[147] = 12.2500;
	points[148] = (-8183.8193, -8371.7324, -149177.9531);
	angles[148] = (0, 87.5538, -2072.9641);
	at[148] = 12.3333;
	points[149] = (-8242.2441, -8369.0947, -151314.1719);
	angles[149] = (0, 87.2555, -2087.9622);
	at[149] = 12.4167;
	points[150] = (-8301.2207, -8366.1416, -153465.3594);
	angles[150] = (0, 87.0740, -2102.9602);
	at[150] = 12.5000;
	points[151] = (-8360.6299, -8363.0713, -155631.1094);
	angles[151] = (0, 86.9674, -2117.9583);
	at[151] = 12.5833;
	points[152] = (-8419.5273, -8359.9209, -157811.8125);
	angles[152] = (0, 86.9178, -2132.9563);
	at[152] = 12.6667;
	points[153] = (-8478.7402, -8356.7324, -160007.0781);
	angles[153] = (0, 86.9168, -2147.9543);
	at[153] = 12.7500;
	points[154] = (-8537.5596, -8353.5830, -162217.3125);
	angles[154] = (0, 86.9659, -2162.9521);
	at[154] = 12.8333;
	points[155] = (-8596.8506, -8350.4727, -164442.1250);
	angles[155] = (0, 87.0764, -2177.9502);
	at[155] = 12.9167;
	points[156] = (-8656.3389, -8347.5195, -166681.9062);
	angles[156] = (0, 87.2766, -2192.9482);
	at[156] = 13;
	points[157] = (-8715.2363, -8344.8818, -168936.2188);
	angles[157] = (0, 87.6292, -2207.9463);
	at[157] = 13.0833;
	points[158] = (-8773.8975, -8342.7949, -171205.5156);
	angles[158] = (0, 88.3312, -2222.9443);
	at[158] = 13.1667;
	points[159] = (-8830.7090, -8341.8896, -173489.3750);
	angles[159] = (0, 90.2668, -2237.9421);
	at[159] = 13.2500;
	points[160] = (-8889.8027, -8343.1494, -175788.1875);
	angles[160] = (0, 91.8753, -2252.9402);
	at[160] = 13.3333;
	points[161] = (-8949.2129, -8345.4727, -178101.5625);
	angles[161] = (0, 92.5259, -2267.9382);
	at[161] = 13.4167;
	points[162] = (-9007.8350, -8348.2285, -180429.9219);
	angles[162] = (0, 92.8412, -2282.9363);
	at[162] = 13.5000;
	points[163] = (-9066.2207, -8351.2207, -182772.8438);
	angles[163] = (0, 92.9889, -2297.9343);
	at[163] = 13.5833;
	points[164] = (-9125.2754, -8354.3311, -185130.7031);
	angles[164] = (0, 93.0270, -2312.9324);
	at[164] = 13.6667;
	points[165] = (-9184.1729, -8357.4014, -187503.1562);
	angles[165] = (0, 92.9753, -2327.9304);
	at[165] = 13.7500;
	points[166] = (-9243.3076, -8360.4326, -189890.5625);
	angles[166] = (0, 92.8357, -2342.9282);
	at[166] = 13.8333;
	points[167] = (-9302.5195, -8363.2676, -192292.5156);
	angles[167] = (0, 92.5945, -2357.9263);
	at[167] = 13.9167;
	points[168] = (-9361.0234, -8365.7090, -194709.4531);
	angles[168] = (0, 92.2225, -2372.9243);
	at[168] = 14;
	points[169] = (-9420.3154, -8367.7559, -197140.9375);
	angles[169] = (0, 91.6331, -2387.9224);
	at[169] = 14.0833;
	points[170] = (-9477.9922, -8368.9375, -199587.4062);
	angles[170] = (0, 90.6758, -2402.9204);
	at[170] = 14.1667;
	points[171] = (-9531.7715, -8368.8984, -202048.4219);
	angles[171] = (0, 88.9716, -2417.9185);
	at[171] = 14.2500;
	points[172] = (-9574.6064, -8367.1650, -204524.4062);
	angles[172] = (0, 86.2683, -2432.9165);
	at[172] = 14.3333;
	points[173] = (-9614.9609, -8363.9375, -207014.9688);
	angles[173] = (0, 84.7744, -2447.9143);
	at[173] = 14.4167;
	points[174] = (-9648.3857, -8360.6689, -209520.4688);
	angles[174] = (0, 84.0801, -2462.9124);
	at[174] = 14.5000;
	points[175] = (-9683.8184, -8356.8115, -212040.5625);
	angles[175] = (0, 83.5818, -2477.9104);
	at[175] = 14.5833;
	points[176] = (-9715.5117, -8353.1494, -214575.6094);
	angles[176] = (0, 83.2554, -2492.9082);
	at[176] = 14.6667;
	points[177] = (-9747.4805, -8349.2920, -217125.2031);
	angles[177] = (0, 82.9987, -2507.9062);
	at[177] = 14.7500;
	points[178] = (-9779.8818, -8345.2363, -219689.7656);
	angles[178] = (0, 82.7909, -2522.9043);
	at[178] = 14.8333;
	points[179] = (-9809.9209, -8341.4170, -222268.8906);
	angles[179] = (0, 82.6331, -2537.9023);
	at[179] = 14.9167;
	points[180] = (-9840.7090, -8337.4014, -224863);
	angles[180] = (0, 82.4979, -2552.9001);
	at[180] = 15;
	points[181] = (-9871.6143, -8333.3076, -227471.6406);
	angles[181] = (0, 82.3837, -2567.8984);
	at[181] = 15.0833;
	points[182] = (-9901.1816, -8329.3311, -230095.2812);
	angles[182] = (0, 82.2913, -2582.8965);
	at[182] = 15.1667;
	points[183] = (-9931.0625, -8325.2363, -232733.4688);
	angles[183] = (0, 82.2120, -2597.8945);
	at[183] = 15.2500;
	points[184] = (-9961.1816, -8321.1025, -235386.6094);
	angles[184] = (0, 82.1442, -2612.8923);
	at[184] = 15.3333;
	points[185] = (-9990.5908, -8317.0479, -238054.3438);
	angles[185] = (0, 82.0889, -2627.8904);
	at[185] = 15.4167;
	points[186] = (-10020, -8312.9531, -240737.0156);
	angles[186] = (0, 82.0432, -2642.8884);
	at[186] = 15.5000;
	points[187] = (-10049.3701, -8308.8193, -243434.2500);
	angles[187] = (0, 82.0064, -2657.8865);
	at[187] = 15.5833;
	points[188] = (-10078.8193, -8304.6846, -246146.4688);
	angles[188] = (0, 81.9784, -2672.8843);
	at[188] = 15.6667;
	points[189] = (-10108.1885, -8300.5508, -248873.2344);
	angles[189] = (0, 81.9594, -2687.8823);
	at[189] = 15.7500;
	points[190] = (-10137.2041, -8296.4180, -251614.9688);
	angles[190] = (0, 81.9492, -2702.8804);
	at[190] = 15.8333;
	points[191] = (-10166.3389, -8292.3232, -254371.2500);
	angles[191] = (0, 81.9483, -2717.8784);
	at[191] = 15.9167;
	points[192] = (-10196.0635, -8288.1104, -257142.5156);
	angles[192] = (0, 81.9581, -2732.8762);
	at[192] = 16;
	points[193] = (-10225.0791, -8284.0156, -259928.3594);
	angles[193] = (0, 81.9796, -2747.8745);
	at[193] = 16.0833;
	points[194] = (-10253.8984, -8279.9609, -262729.1250);
	angles[194] = (0, 82.0152, -2762.8723);
	at[194] = 16.1667;
	points[195] = (-10284.2920, -8275.7090, -265544.5000);
	angles[195] = (0, 82.0716, -2777.8704);
	at[195] = 16.2500;
	points[196] = (-10313.3857, -8271.6934, -268374.8125);
	angles[196] = (0, 82.1498, -2792.8684);
	at[196] = 16.3333;
	points[197] = (-10343.1104, -8267.5986, -271219.6875);
	angles[197] = (0, 82.2640, -2807.8665);
	at[197] = 16.4167;
	points[198] = (-10374.0156, -8263.4648, -274079.5312);
	angles[198] = (0, 82.4388, -2822.8645);
	at[198] = 16.5000;
	points[199] = (-10391.2988, -8261.1816, -275802.3750);
	angles[199] = (0, 82.5748, -2831.8633);
	at[199] = 16.5667;
	points[200] = (-1024.3307, -6320.9448, 4188.3467);
	angles[200] = (0, 82.5748, -2831.8633);
	at[200] = 16.5667;
	points[201] = (-1024.3307, -6320.9448, 4188.3467);
	angles[201] = (0, 82.5748, -2831.8633);
	at[201] = 16.5833;
	points[202] = (-1028.7323, -6323.0713, 4211.9688);
	angles[202] = (0, 116.1088, -2733.0613);
	at[202] = 16.6167;
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
	points[0] = (49.7748, 7972.4409, 829.9055);
	angles[0] = (0, -90, 6.1863);
	at[0] = 0;
	points[1] = (260.7607, 7972.4409, 853.0630);
	angles[1] = (0, -90, 6.1863);
	at[1] = 0.1500;
	points[2] = (328.9114, 7972.4409, 864);
	angles[2] = (0, -90, 12.5319);
	at[2] = 0.2000;
	points[3] = (530.8858, 7972.4409, 908.6811);
	angles[3] = (0, -90, 12.5319);
	at[3] = 0.3500;
	points[4] = (594.3347, 7972.4409, 927.1969);
	angles[4] = (0, -90, 19.8501);
	at[4] = 0.4000;
	points[5] = (780.6181, 7972.4409, 991.3820);
	angles[5] = (0, -90, 19.8501);
	at[5] = 0.5500;
	points[6] = (838.9882, 7972.4409, 1016.4685);
	angles[6] = (0, -90, 37.9056);
	at[6] = 0.6000;
	points[7] = (942.7678, 7972.4409, 1079.4291);
	angles[7] = (0, -90, 37.9056);
	at[7] = 0.7000;
	points[8] = (991.2047, 7972.4409, 1112.9409);
	angles[8] = (0, -90, 37.9056);
	at[8] = 0.7500;
	points[9] = (1035.9961, 7972.4409, 1147.8779);
	angles[9] = (0, -90, 37.9056);
	at[9] = 0.8000;
	points[10] = (1075.6143, 7972.4409, 1186.4174);
	angles[10] = (0, -90, 37.9056);
	at[10] = 0.8500;
	points[11] = (1097.8740, 7972.4409, 1232.0748);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (1102.7205, 7972.4409, 1281.4174);
	angles[12] = (0, 0, 0);
	at[12] = 0.9500;
	points[13] = (1102.8110, 7972.4409, 1371.5630);
	angles[13] = (0, 0, 0);
	at[13] = 1.0500;
	points[14] = (1099.8347, 7972.4409, 1448.3308);
	angles[14] = (0, 0, 0);
	at[14] = 1.1500;
	points[15] = (1096.6575, 7972.4409, 1511.8425);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (1094.2401, 7972.4409, 1561.9803);
	angles[16] = (0, 0, 0);
	at[16] = 1.3500;
	points[17] = (1092.9135, 7972.4409, 1598.2008);
	angles[17] = (0, 0, 0);
	at[17] = 1.4500;
	points[18] = (1092.6299, 7972.4409, 1611.2126);
	angles[18] = (0, 0, 0);
	at[18] = 1.5000;
	points[19] = (1092.5315, 7972.4409, 1619.7401);
	angles[19] = (0, 0, 0);
	at[19] = 1.5500;
	points[20] = (1092.5197, 7972.4409, 1624.2401);
	angles[20] = (0, -90, 36.6452);
	at[20] = 1.6000;
	points[21] = (1092.5197, 7972.4409, 1625.3976);
	angles[21] = (0, -90, 36.6452);
	at[21] = 1.6500;
	points[22] = (1092.5197, 7972.4409, 1623.8977);
	angles[22] = (0, 0, 0);
	at[22] = 1.7000;
	points[23] = (1092.5197, 7972.4409, 1623.7521);
	angles[23] = (0, 0, 0);
	at[23] = 1.7500;
	points[24] = (1092.5826, 7972.4409, 1614.4607);
	angles[24] = (0, 0, 0);
	at[24] = 1.9000;
	points[25] = (1092.9764, 7972.4409, 1595.9961);
	angles[25] = (0, 0, 0);
	at[25] = 2;
	points[26] = (1094.0394, 7972.4409, 1566.6575);
	angles[26] = (0, 0, 0);
	at[26] = 2.1000;
	points[27] = (1095.9724, 7972.4409, 1525.3859);
	angles[27] = (0, 0, 0);
	at[27] = 2.2000;
	points[28] = (1098.6693, 7972.4409, 1472.2441);
	angles[28] = (0, 0, 0);
	at[28] = 2.3000;
	points[29] = (1101.6260, 7972.4409, 1407.1300);
	angles[29] = (0, 0, 0);
	at[29] = 2.4000;
	points[30] = (1103.5157, 7972.4409, 1329.5630);
	angles[30] = (0, 0, 0);
	at[30] = 2.5000;
	points[31] = (1099.2402, 7972.4409, 1240.4292);
	angles[31] = (0, 0, 0);
	at[31] = 2.6000;
	points[32] = (1082.6969, 7972.4409, 1195.4567);
	angles[32] = (0, 90, -37.9056);
	at[32] = 2.6500;
	points[33] = (1047.2638, 7972.4409, 1157.7008);
	angles[33] = (0, 90, -37.9056);
	at[33] = 2.7000;
	points[34] = (1004.9528, 7972.4409, 1123.1338);
	angles[34] = (0, 90, -37.9056);
	at[34] = 2.7500;
	points[35] = (959.0591, 7972.4409, 1090.3425);
	angles[35] = (0, 90, -37.9056);
	at[35] = 2.8000;
	points[36] = (910.2165, 7972.4409, 1058.4803);
	angles[36] = (0, 90, -37.9056);
	at[36] = 2.8500;
	points[37] = (858.7598, 7972.4409, 1027.4646);
	angles[37] = (0, 90, -19.8501);
	at[37] = 2.9000;
	points[38] = (804.6142, 7972.4409, 1000.9645);
	angles[38] = (0, 90, -19.8501);
	at[38] = 2.9500;
	points[39] = (745.9291, 7972.4409, 978.3661);
	angles[39] = (0, 90, -19.8501);
	at[39] = 3;
	points[40] = (623.4764, 7972.4409, 936.5079);
	angles[40] = (0, 90, -19.8501);
	at[40] = 3.1000;
	points[41] = (560.6457, 7972.4409, 916.8307);
	angles[41] = (0, 90, -12.5319);
	at[41] = 3.1500;
	points[42] = (496.5984, 7972.4409, 900.2126);
	angles[42] = (0, 90, -12.5319);
	at[42] = 3.2000;
	points[43] = (363.3323, 7972.4409, 870.8032);
	angles[43] = (0, 90, -12.5319);
	at[43] = 3.3000;
	points[44] = (296.4713, 7972.4409, 858.2834);
	angles[44] = (0, 90, -6.1863);
	at[44] = 3.3500;
	points[45] = (87.0850, 7972.4409, 832.7677);
	angles[45] = (0, 90, -6.1863);
	at[45] = 3.5000;
	points[46] = (17.5956, 7972.4409, 829.0906);
	angles[46] = (0, 90, 6.6417);
	at[46] = 3.5500;
	points[47] = (-53.5732, 7972.4409, 834.6614);
	angles[47] = (0, 90, 6.6417);
	at[47] = 3.6000;
	points[48] = (-193.8559, 7972.4409, 852.3229);
	angles[48] = (0, 90, 6.6417);
	at[48] = 3.7000;
	points[49] = (-261.8291, 7972.4409, 863.0236);
	angles[49] = (0, 90, 12.6675);
	at[49] = 3.7500;
	points[50] = (-330.0953, 7972.4409, 876.9646);
	angles[50] = (0, 90, 12.6675);
	at[50] = 3.8000;
	points[51] = (-463.6968, 7972.4409, 907.5276);
	angles[51] = (0, 90, 12.6675);
	at[51] = 3.9000;
	points[52] = (-528.3819, 7972.4409, 924.6614);
	angles[52] = (0, 90, 18.5547);
	at[52] = 3.9500;
	points[53] = (-655.1968, 7972.4409, 962.4252);
	angles[53] = (0, 90, 18.5547);
	at[53] = 4.0500;
	points[54] = (-716.5866, 7972.4409, 983.5709);
	angles[54] = (0, 90, 18.5547);
	at[54] = 4.1000;
	points[55] = (-773.4056, 7972.4409, 1009.1378);
	angles[55] = (0, 90, 38.4786);
	at[55] = 4.1500;
	points[56] = (-877.5512, 7972.4409, 1075.9803);
	angles[56] = (0, 90, 38.4786);
	at[56] = 4.2500;
	points[57] = (-925.4055, 7972.4409, 1110.4292);
	angles[57] = (0, 90, 38.4786);
	at[57] = 4.3000;
	points[58] = (-970.0394, 7972.4409, 1145.9370);
	angles[58] = (0, 90, 38.4786);
	at[58] = 4.3500;
	points[59] = (-1010.3189, 7972.4409, 1184.0748);
	angles[59] = (0, 90, 38.4786);
	at[59] = 4.4000;
	points[60] = (-1036.9094, 7972.4409, 1226.9410);
	angles[60] = (0, 0, 0);
	at[60] = 4.4500;
	points[61] = (-1043.8976, 7972.4409, 1277.2245);
	angles[61] = (0, 0, 0);
	at[61] = 4.5000;
	points[62] = (-1045.2245, 7972.4409, 1323.9253);
	angles[62] = (0, 0, 0);
	at[62] = 4.5500;
	points[63] = (-1043.2795, 7972.4409, 1408.0708);
	angles[63] = (0, 0, 0);
	at[63] = 4.6500;
	points[64] = (-1039.7953, 7972.4409, 1478.7795);
	angles[64] = (0, 0, 0);
	at[64] = 4.7500;
	points[65] = (-1036.6536, 7972.4409, 1536.1063);
	angles[65] = (0, 0, 0);
	at[65] = 4.8500;
	points[66] = (-1035.4489, 7972.4409, 1559.7913);
	angles[66] = (0, 0, 0);
	at[66] = 4.9000;
	points[67] = (-1033.9448, 7972.4409, 1596.6378);
	angles[67] = (0, 0, 0);
	at[67] = 5;
	points[68] = (-1033.6063, 7972.4409, 1610.1536);
	angles[68] = (0, 0, 0);
	at[68] = 5.0500;
	points[69] = (-1033.4843, 7972.4409, 1619.0984);
	angles[69] = (0, 0, 0);
	at[69] = 5.1000;
	points[70] = (-1033.4646, 7972.4409, 1623.9803);
	angles[70] = (0, 90, 36.9424);
	at[70] = 5.1500;
	points[71] = (-1033.4646, 7972.4409, 1625.5472);
	angles[71] = (0, 90, 36.9424);
	at[71] = 5.2000;
	points[72] = (-1033.4646, 7972.4409, 1624.4567);
	angles[72] = (14.1495, 70.4122, 34.4878);
	at[72] = 5.2500;
	points[73] = (-1033.4646, 7972.4409, 1623.4803);
	angles[73] = (0, 0, 0);
	at[73] = 5.3000;
	points[74] = (-1033.4843, 7972.4409, 1619.4133);
	angles[74] = (0, 0, 0);
	at[74] = 5.4000;
	points[75] = (-1033.6771, 7972.4409, 1606.6338);
	angles[75] = (0, 0, 0);
	at[75] = 5.5000;
	points[76] = (-1034.4528, 7972.4409, 1582.2875);
	angles[76] = (0, 0, 0);
	at[76] = 5.6000;
	points[77] = (-1036.1023, 7972.4409, 1546.6143);
	angles[77] = (0, 0, 0);
	at[77] = 5.7000;
	points[78] = (-1037.2521, 7972.4409, 1524.9253);
	angles[78] = (0, 0, 0);
	at[78] = 5.7500;
	points[79] = (-1040.1771, 7972.4409, 1471.6771);
	angles[79] = (0, 0, 0);
	at[79] = 5.8500;
	points[80] = (-1043.3464, 7972.4409, 1406.4960);
	angles[80] = (0, 0, 0);
	at[80] = 5.9500;
	points[81] = (-1045.2284, 7972.4409, 1328.8466);
	angles[81] = (0, 0, 0);
	at[81] = 6.0500;
	points[82] = (-1044.3464, 7972.4409, 1285.5039);
	angles[82] = (0, 0, 0);
	at[82] = 6.1000;
	points[83] = (-1039.8268, 7972.4409, 1240.1221);
	angles[83] = (0, 0, 0);
	at[83] = 6.1500;
	points[84] = (-1020.2244, 7972.4409, 1195.7166);
	angles[84] = (0, -90, -38.4786);
	at[84] = 6.2000;
	points[85] = (-984.4528, 7972.4409, 1158.5748);
	angles[85] = (0, -90, -38.4786);
	at[85] = 6.2500;
	points[86] = (-942.4646, 7972.4409, 1123.5079);
	angles[86] = (0, -90, -38.4786);
	at[86] = 6.3000;
	points[87] = (-849.3504, 7972.4409, 1056.8503);
	angles[87] = (0, -90, -38.4786);
	at[87] = 6.4000;
	points[88] = (-798.4606, 7972.4409, 1024.1890);
	angles[88] = (0, -90, -38.4786);
	at[88] = 6.4500;
	points[89] = (-745.5748, 7972.4409, 995.1890);
	angles[89] = (0, -90, -18.5547);
	at[89] = 6.5000;
	points[90] = (-686.5354, 7972.4409, 972.8268);
	angles[90] = (0, -90, -18.5547);
	at[90] = 6.5500;
	points[91] = (-562.5079, 7972.4409, 934.3622);
	angles[91] = (0, -90, -18.5547);
	at[91] = 6.6500;
	points[92] = (-500.0472, 7972.4409, 916.7639);
	angles[92] = (0, -90, -12.6675);
	at[92] = 6.7000;
	points[93] = (-301.4862, 7972.4409, 870.9094);
	angles[93] = (0, -90, -12.6675);
	at[93] = 6.8500;
	points[94] = (-234.5236, 7972.4409, 858.3858);
	angles[94] = (0, -90, -6.6417);
	at[94] = 6.9000;
	points[95] = (-25.5621, 7972.4409, 831.9291);
	angles[95] = (0, -90, -6.6417);
	at[95] = 7.0500;
	points[96] = (26.2698, 7972.4409, 828.9960);
	angles[96] = (0, -90, 6.1862);
	at[96] = 7.1000;
	points[97] = (49.7748, 7972.4409, 829.9055);
	angles[97] = (0, -90, 6.1863);
	at[97] = 7.1167;
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
	points[0] = (4.6926, 9448.8193, 827.8110);
	angles[0] = (0, -90, 6.1956);
	at[0] = 0;
	points[1] = (74.8847, 9448.8193, 829.6732);
	angles[1] = (0, -90, 6.1956);
	at[1] = 0.0500;
	points[2] = (145.4661, 9448.8193, 836.6260);
	angles[2] = (0, -90, 6.1956);
	at[2] = 0.1000;
	points[3] = (215.6933, 9448.8193, 845.0236);
	angles[3] = (0, -90, 6.1956);
	at[3] = 0.1500;
	points[4] = (285.6087, 9448.8193, 854.6929);
	angles[4] = (0, -90, 12.5191);
	at[4] = 0.2000;
	points[5] = (352.9291, 9448.8193, 867.2953);
	angles[5] = (0, -90, 12.5191);
	at[5] = 0.2500;
	points[6] = (487.5905, 9448.8193, 897.0158);
	angles[6] = (0, -90, 12.5191);
	at[6] = 0.3500;
	points[7] = (553.8937, 9448.8193, 913.3307);
	angles[7] = (0, -90, 18.3990);
	at[7] = 0.4000;
	points[8] = (743.2874, 9448.8193, 970.0039);
	angles[8] = (0, -90, 18.3990);
	at[8] = 0.5500;
	points[9] = (803.4173, 9448.8193, 992.6418);
	angles[9] = (0, -90, 18.3990);
	at[9] = 0.6000;
	points[10] = (857.8229, 9448.8193, 1022.1457);
	angles[10] = (0, -90, 37.9050);
	at[10] = 0.6500;
	points[11] = (910.4252, 9448.8193, 1055.1930);
	angles[11] = (0, -90, 37.9050);
	at[11] = 0.7000;
	points[12] = (1007.1535, 9448.8193, 1123.3859);
	angles[12] = (0, -90, 37.9050);
	at[12] = 0.8000;
	points[13] = (1050.4764, 9448.8193, 1159.7284);
	angles[13] = (0, -90, 37.9050);
	at[13] = 0.8500;
	points[14] = (1086.7480, 9448.8193, 1200.1497);
	angles[14] = (0, -90, 89.9872);
	at[14] = 0.9000;
	points[15] = (1101.2520, 9448.8193, 1247.4646);
	angles[15] = (0, -90, 89.9872);
	at[15] = 0.9500;
	points[16] = (1104.5157, 9448.8193, 1296.3740);
	angles[16] = (0, -90, 89.9872);
	at[16] = 1;
	points[17] = (1103.6812, 9448.8193, 1384.2953);
	angles[17] = (0, -90, 89.9872);
	at[17] = 1.1000;
	points[18] = (1100.3386, 9448.8193, 1458.9803);
	angles[18] = (0, -90, 89.9872);
	at[18] = 1.2000;
	points[19] = (1097.0079, 9448.8193, 1520.4213);
	angles[19] = (0, -90, 89.9872);
	at[19] = 1.3000;
	points[20] = (1094.5867, 9448.8193, 1568.3937);
	angles[20] = (0, -90, 89.9872);
	at[20] = 1.4000;
	points[21] = (1093.8425, 9448.8193, 1586.5748);
	angles[21] = (0, -90, 89.9872);
	at[21] = 1.4500;
	points[22] = (1093.3425, 9448.8193, 1602.5945);
	angles[22] = (0, -90, 89.9872);
	at[22] = 1.5000;
	points[23] = (1093.1102, 9448.8193, 1614.1693);
	angles[23] = (0, -90, 89.9872);
	at[23] = 1.5500;
	points[24] = (1093.0433, 9448.8193, 1621.5078);
	angles[24] = (0, -90, 89.9872);
	at[24] = 1.6000;
	points[25] = (1093.0394, 9448.8193, 1624.8701);
	angles[25] = (0, -90, 36.7688);
	at[25] = 1.6500;
	points[26] = (1093.0394, 9448.8193, 1625.3031);
	angles[26] = (0, -90, 36.7688);
	at[26] = 1.7000;
	points[27] = (1093.0394, 9448.8193, 1623.0826);
	angles[27] = (-180, -90, 90.0128);
	at[27] = 1.7500;
	points[28] = (1093.0472, 9448.8193, 1621.1300);
	angles[28] = (-180, -90, 90.0128);
	at[28] = 1.8500;
	points[29] = (1093.1615, 9448.8193, 1610.8937);
	angles[29] = (-180, -90, 90.0128);
	at[29] = 1.9500;
	points[30] = (1093.7560, 9448.8193, 1589.0039);
	angles[30] = (-180, -90, 90.0128);
	at[30] = 2.0500;
	points[31] = (1095.1143, 9448.8193, 1557.0905);
	angles[31] = (-180, -90, 90.0128);
	at[31] = 2.1500;
	points[32] = (1097.4135, 9448.8193, 1512.9686);
	angles[32] = (-180, -90, 90.0128);
	at[32] = 2.2500;
	points[33] = (1100.4489, 9448.8193, 1456.8740);
	angles[33] = (-180, -90, 90.0128);
	at[33] = 2.3500;
	points[34] = (1103.5276, 9448.8193, 1388.7480);
	angles[34] = (-180, -90, 90.0128);
	at[34] = 2.4500;
	points[35] = (1104.7599, 9448.8193, 1308.9055);
	angles[35] = (-180, -90, 90.0128);
	at[35] = 2.5500;
	points[36] = (1102.9016, 9448.8193, 1263.9883);
	angles[36] = (-180, -90, 90.0128);
	at[36] = 2.6000;
	points[37] = (1094.9055, 9448.8193, 1216.6023);
	angles[37] = (-180, -90, 142.0950);
	at[37] = 2.6500;
	points[38] = (1067.3661, 9448.8193, 1176.3268);
	angles[38] = (-180, -90, 142.0950);
	at[38] = 2.7000;
	points[39] = (1027.9724, 9448.8193, 1140.0906);
	angles[39] = (-180, -90, 142.0950);
	at[39] = 2.7500;
	points[40] = (984.3032, 9448.8193, 1106.1299);
	angles[40] = (-180, -90, 142.0950);
	at[40] = 2.8000;
	points[41] = (887.6969, 9448.8193, 1040.6182);
	angles[41] = (-180, -90, 142.0950);
	at[41] = 2.9000;
	points[42] = (835.4646, 9448.8193, 1008.9134);
	angles[42] = (-180, -90, 161.6010);
	at[42] = 2.9500;
	points[43] = (780.1733, 9448.8193, 983.2480);
	angles[43] = (-180, -90, 161.6010);
	at[43] = 3;
	points[44] = (720.0984, 9448.8193, 962.2874);
	angles[44] = (-180, -90, 161.6010);
	at[44] = 3.0500;
	points[45] = (595.0118, 9448.8193, 924.7677);
	angles[45] = (-180, -90, 161.6010);
	at[45] = 3.1500;
	points[46] = (531.9370, 9448.8193, 907.6890);
	angles[46] = (-180, -90, 167.4810);
	at[46] = 3.2000;
	points[47] = (466.1969, 9448.8193, 892.0591);
	angles[47] = (-180, -90, 167.4810);
	at[47] = 3.2500;
	points[48] = (332.2201, 9448.8193, 863.0984);
	angles[48] = (-180, -90, 167.4810);
	at[48] = 3.3500;
	points[49] = (264.9394, 9448.8193, 851.6457);
	angles[49] = (-180, -90, 173.8044);
	at[49] = 3.4000;
	points[50] = (54.6720, 9448.8193, 828.1851);
	angles[50] = (-180, -90, 173.8044);
	at[50] = 3.5500;
	points[51] = (-15.4352, 9448.8193, 829.1968);
	angles[51] = (-180, -90, 186.3383);
	at[51] = 3.6000;
	points[52] = (-156.0594, 9448.8193, 844.7087);
	angles[52] = (-180, -90, 186.3383);
	at[52] = 3.7000;
	points[53] = (-225.9039, 9448.8193, 854.6024);
	angles[53] = (-180, -90, 192.5684);
	at[53] = 3.7500;
	points[54] = (-427.9646, 9448.8193, 897.1496);
	angles[54] = (-180, -90, 192.5684);
	at[54] = 3.9000;
	points[55] = (-494.2795, 9448.8193, 913.3661);
	angles[55] = (-180, -90, 198.4363);
	at[55] = 3.9500;
	points[56] = (-621.3071, 9448.8193, 949.8661);
	angles[56] = (-180, -90, 198.4363);
	at[56] = 4.0500;
	points[57] = (-743.7283, 9448.8193, 992.6102);
	angles[57] = (-180, -90, 198.4363);
	at[57] = 4.1500;
	points[58] = (-798.1221, 9448.8193, 1022.1890);
	angles[58] = (-180, -90, 217.8056);
	at[58] = 4.2000;
	points[59] = (-900.6063, 9448.8193, 1088.7205);
	angles[59] = (-180, -90, 217.8056);
	at[59] = 4.3000;
	points[60] = (-947.6260, 9448.8193, 1123.2008);
	angles[60] = (-180, -90, 217.8056);
	at[60] = 4.3500;
	points[61] = (-991.0197, 9448.8193, 1159.4607);
	angles[61] = (-180, -90, 217.8056);
	at[61] = 4.4000;
	points[62] = (-1027.3622, 9448.8193, 1199.8466);
	angles[62] = (-180, -90, 180);
	at[62] = 4.4500;
	points[63] = (-1041.8425, 9448.8193, 1247.1812);
	angles[63] = (-180, -90, 180);
	at[63] = 4.5000;
	points[64] = (-1045.0984, 9448.8193, 1296.1102);
	angles[64] = (-180, -90, 180);
	at[64] = 4.5500;
	points[65] = (-1044.2441, 9448.8193, 1384.0669);
	angles[65] = (-180, -90, 180);
	at[65] = 4.6500;
	points[66] = (-1040.8820, 9448.8193, 1458.7913);
	angles[66] = (-180, -90, 180);
	at[66] = 4.7500;
	points[67] = (-1037.5315, 9448.8193, 1520.2638);
	angles[67] = (-180, -90, 180);
	at[67] = 4.8500;
	points[68] = (-1035.0945, 9448.8193, 1568.2756);
	angles[68] = (-180, -90, 180);
	at[68] = 4.9500;
	points[69] = (-1034.3425, 9448.8193, 1586.4803);
	angles[69] = (-180, -90, 180);
	at[69] = 5;
	points[70] = (-1033.8386, 9448.8193, 1602.5157);
	angles[70] = (-180, -90, 180);
	at[70] = 5.0500;
	points[71] = (-1033.6024, 9448.8193, 1614.1143);
	angles[71] = (-180, -90, 180);
	at[71] = 5.1000;
	points[72] = (-1033.5355, 9448.8193, 1621.4764);
	angles[72] = (-180, -90, 180);
	at[72] = 5.1500;
	points[73] = (-1033.5315, 9448.8193, 1624.8622);
	angles[73] = (-180, -90, 216.9354);
	at[73] = 5.2000;
	points[74] = (-1033.5315, 9448.8193, 1625.3229);
	angles[74] = (-180, -90, 216.9354);
	at[74] = 5.2500;
	points[75] = (-1033.5315, 9448.8193, 1623.1221);
	angles[75] = (-180, 90, 180);
	at[75] = 5.3000;
	points[76] = (-1033.5315, 9448.8193, 1623.3070);
	angles[76] = (-180, 90, 180);
	at[76] = 5.3500;
	points[77] = (-1033.5669, 9448.8193, 1617.2599);
	angles[77] = (-180, 90, 180);
	at[77] = 5.4500;
	points[78] = (-1033.8544, 9448.8193, 1601.8544);
	angles[78] = (-180, 90, 180);
	at[78] = 5.5500;
	points[79] = (-1034.7953, 9448.8193, 1575.0865);
	angles[79] = (-180, 90, 180);
	at[79] = 5.6500;
	points[80] = (-1036.6497, 9448.8193, 1536.7520);
	angles[80] = (-180, 90, 180);
	at[80] = 5.7500;
	points[81] = (-1039.3701, 9448.8193, 1486.7953);
	angles[81] = (-180, 90, 180);
	at[81] = 5.8500;
	points[82] = (-1042.5709, 9448.8193, 1424.8268);
	angles[82] = (-180, 90, 180);
	at[82] = 5.9500;
	points[83] = (-1045.1417, 9448.8193, 1350.9213);
	angles[83] = (-180, 90, 180);
	at[83] = 6.0500;
	points[84] = (-1043.5669, 9448.8193, 1264.7164);
	angles[84] = (-180, 90, 180);
	at[84] = 6.1500;
	points[85] = (-1035.7913, 9448.8193, 1217.1497);
	angles[85] = (-180, 90, 142.1944);
	at[85] = 6.2000;
	points[86] = (-1008.6812, 9448.8193, 1176.8110);
	angles[86] = (-180, 90, 142.1944);
	at[86] = 6.2500;
	points[87] = (-969.2756, 9448.8193, 1140.5197);
	angles[87] = (-180, 90, 142.1944);
	at[87] = 6.3000;
	points[88] = (-925.6260, 9448.8193, 1106.6339);
	angles[88] = (-180, 90, 142.1944);
	at[88] = 6.3500;
	points[89] = (-829.0118, 9448.8193, 1041.2560);
	angles[89] = (-180, 90, 142.1944);
	at[89] = 6.4500;
	points[90] = (-776.8347, 9448.8193, 1009.5827);
	angles[90] = (-180, 90, 161.5637);
	at[90] = 6.5000;
	points[91] = (-721.6142, 9448.8193, 983.6142);
	angles[91] = (-180, 90, 161.5637);
	at[91] = 6.5500;
	points[92] = (-661.6339, 9448.8193, 962.5866);
	angles[92] = (-180, 90, 161.5637);
	at[92] = 6.6000;
	points[93] = (-536.5315, 9448.8193, 925.0591);
	angles[93] = (-180, 90, 161.5637);
	at[93] = 6.7000;
	points[94] = (-473.5315, 9448.8193, 908.0866);
	angles[94] = (-180, 90, 167.4316);
	at[94] = 6.7500;
	points[95] = (-341.3236, 9448.8193, 877.5984);
	angles[95] = (-180, 90, 167.4316);
	at[95] = 6.8500;
	points[96] = (-273.8945, 9448.8193, 863.3898);
	angles[96] = (-180, 90, 167.4316);
	at[96] = 6.9000;
	points[97] = (-206.5992, 9448.8193, 851.6811);
	angles[97] = (-180, 90, 173.6617);
	at[97] = 6.9500;
	points[98] = (-67.0756, 9448.8193, 834.0787);
	angles[98] = (-180, 90, 173.6617);
	at[98] = 7.0500;
	points[99] = (4.6926, 9448.8193, 827.8110);
	angles[99] = (-180, 90, 186.1956);
	at[99] = 7.1000;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
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
