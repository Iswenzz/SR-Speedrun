main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw_kalimari_desert", 0);

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
	ambientPlay("iz_0_tkd", 2);
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
	level.iz_route[level.iz_route.size] = (-7352, -6936, 3396);
	level.iz_route[level.iz_route.size] = (-7352, -7834, 3400);
	level.iz_route[level.iz_route.size] = (-7352, -8791, 3419);
	level.iz_route[level.iz_route.size] = (-7365, -9582, 3446);
	level.iz_route[level.iz_route.size] = (-7291, -10406, 3510);
	level.iz_route[level.iz_route.size] = (-7058, -11288, 3569);
	level.iz_route[level.iz_route.size] = (-6571, -11962, 3560);
	level.iz_route[level.iz_route.size] = (-5938, -12619, 3511);
	level.iz_route[level.iz_route.size] = (-5335, -13060, 3470);
	level.iz_route[level.iz_route.size] = (-4387, -13335, 3442);
	level.iz_route[level.iz_route.size] = (-3495, -13398, 3466);
	level.iz_route[level.iz_route.size] = (-2723, -13300, 3498);
	level.iz_route[level.iz_route.size] = (-2154, -13188, 3512);
	level.iz_route[level.iz_route.size] = (-1747, -13049, 3505);
	level.iz_route[level.iz_route.size] = (-1301, -12810, 3481);
	level.iz_route[level.iz_route.size] = (-867, -12490, 3444);
	level.iz_route[level.iz_route.size] = (-526, -12095, 3417);
	level.iz_route[level.iz_route.size] = (-248, -11587, 3411);
	level.iz_route[level.iz_route.size] = (-58, -11074, 3407);
	level.iz_route[level.iz_route.size] = (88, -10332, 3400);
	level.iz_route[level.iz_route.size] = (214, -9619, 3389);
	level.iz_route[level.iz_route.size] = (253, -8873, 3388);
	level.iz_route[level.iz_route.size] = (266, -8213, 3398);
	level.iz_route[level.iz_route.size] = (266, -7200, 3396);
	level.iz_route[level.iz_route.size] = (253, -6324, 3396);
	level.iz_route[level.iz_route.size] = (266, -5190, 3401);
	level.iz_route[level.iz_route.size] = (266, -4126, 3437);
	level.iz_route[level.iz_route.size] = (266, -3038, 3458);
	level.iz_route[level.iz_route.size] = (446, -2133, 3471);
	level.iz_route[level.iz_route.size] = (900, -1303, 3462);
	level.iz_route[level.iz_route.size] = (1593, -511, 3438);
	level.iz_route[level.iz_route.size] = (2260, 199, 3410);
	level.iz_route[level.iz_route.size] = (2887, 783, 3398);
	level.iz_route[level.iz_route.size] = (3546, 1400, 3396);
	level.iz_route[level.iz_route.size] = (4271, 2105, 3395);
	level.iz_route[level.iz_route.size] = (4896, 2755, 3392);
	level.iz_route[level.iz_route.size] = (5531, 3507, 3382);
	level.iz_route[level.iz_route.size] = (6069, 4345, 3423);
	level.iz_route[level.iz_route.size] = (6399, 5146, 3470);
	level.iz_route[level.iz_route.size] = (6531, 5505, 3489);
	level.iz_route[level.iz_route.size] = (6620, 5897, 3501);
	level.iz_route[level.iz_route.size] = (6639, 6260, 3502);
	level.iz_route[level.iz_route.size] = (6557, 6707, 3493);
	level.iz_route[level.iz_route.size] = (6396, 7161, 3484);
	level.iz_route[level.iz_route.size] = (6142, 7582, 3473);
	level.iz_route[level.iz_route.size] = (5769, 8028, 3456);
	level.iz_route[level.iz_route.size] = (5135, 8591, 3449);
	level.iz_route[level.iz_route.size] = (4396, 8987, 3459);
	level.iz_route[level.iz_route.size] = (3604, 9250, 3472);
	level.iz_route[level.iz_route.size] = (2773, 9370, 3470);
	level.iz_route[level.iz_route.size] = (1880, 9388, 3439);
	level.iz_route[level.iz_route.size] = (1013, 9280, 3407);
	level.iz_route[level.iz_route.size] = (133, 9108, 3401);
	level.iz_route[level.iz_route.size] = (-679, 8883, 3401);
	level.iz_route[level.iz_route.size] = (-1543, 8616, 3401);
	level.iz_route[level.iz_route.size] = (-2290, 8282, 3405);
	level.iz_route[level.iz_route.size] = (-2987, 7835, 3420);
	level.iz_route[level.iz_route.size] = (-3629, 7230, 3439);
	level.iz_route[level.iz_route.size] = (-4088, 6580, 3449);
	level.iz_route[level.iz_route.size] = (-4475, 5762, 3446);
	level.iz_route[level.iz_route.size] = (-4738, 4896, 3429);
	level.iz_route[level.iz_route.size] = (-4864, 4491, 3422);
	level.iz_route[level.iz_route.size] = (-4934, 4084, 3415);
	level.iz_route[level.iz_route.size] = (-4956, 3646, 3408);
	level.iz_route[level.iz_route.size] = (-4924, 3090, 3400);
	level.iz_route[level.iz_route.size] = (-4865, 2377, 3394);
	level.iz_route[level.iz_route.size] = (-4776, 1709, 3389);
	level.iz_route[level.iz_route.size] = (-4733, 1187, 3386);
	level.iz_route[level.iz_route.size] = (-4734, 745, 3384);
	level.iz_route[level.iz_route.size] = (-4750, -439, 3377);
	level.iz_route[level.iz_route.size] = (-4837, -1081, 3377);
	level.iz_route[level.iz_route.size] = (-5109, -1536, 3382);
	level.iz_route[level.iz_route.size] = (-5447, -1845, 3392);
	level.iz_route[level.iz_route.size] = (-6147, -2341, 3437);
	level.iz_route[level.iz_route.size] = (-6770, -2819, 3479);
	level.iz_route[level.iz_route.size] = (-7011, -3225, 3477);
	level.iz_route[level.iz_route.size] = (-7219, -3705, 3457);
	level.iz_route[level.iz_route.size] = (-7328, -4364, 3417);
	level.iz_route[level.iz_route.size] = (-7352, -5252, 3396);
	level.iz_route[level.iz_route.size] = (-7352, -6166, 3396);
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
	points[0] = (3868.1104, 896.9449, 3399.0671);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (3868.1104, -4223.7007, 3399.0671);
	angles[1] = (0, -180, 0);
	at[1] = 6.2833;
	points[2] = (3863.5276, -4400.1182, 3399.0671);
	angles[2] = (0, -181.8006, 0);
	at[2] = 6.5000;
	points[3] = (3849.9841, -4576.1812, 3399.0671);
	angles[3] = (0, -183.7382, 0);
	at[3] = 6.7167;
	points[4] = (3832.3110, -4751.5752, 3399.0671);
	angles[4] = (0, -186.5553, 0);
	at[4] = 6.9333;
	points[5] = (3752.9016, -5095.7085, 3399.0671);
	angles[5] = (0, -192.5782, 0);
	at[5] = 7.3667;
	points[6] = (3642.4016, -5431.0635, 3399.0671);
	angles[6] = (0, -198.0562, 0);
	at[6] = 7.8000;
	points[7] = (3508.8506, -5757.9136, 3399.0671);
	angles[7] = (0, -202.2614, 0);
	at[7] = 8.2333;
	points[8] = (3432.1577, -5916.7715, 3399.0671);
	angles[8] = (0, -205.5496, 0);
	at[8] = 8.4500;
	points[9] = (3350.4805, -6073.3071, 3399.0671);
	angles[9] = (0, -207.0436, 0);
	at[9] = 8.6667;
	points[10] = (3264.0552, -6227.2051, 3399.0671);
	angles[10] = (0, -209.3928, 0);
	at[10] = 8.8833;
	points[11] = (3172.2439, -6378.0317, 3399.0671);
	angles[11] = (0, -210.8365, 0);
	at[11] = 9.1000;
	points[12] = (3074.8899, -6524.7642, 3399.0671);
	angles[12] = (0, -213.9878, 0);
	at[12] = 9.3167;
	points[13] = (2838.7322, -6787.2441, 3399.0671);
	angles[13] = (0, -222.0507, 0);
	at[13] = 9.7500;
	points[14] = (2589.0198, -7036.9688, 3399.0671);
	angles[14] = (0, -225.4424, 0);
	at[14] = 10.1833;
	points[15] = (2312.2717, -7256.4961, 3399.0671);
	angles[15] = (0, -230.9589, 0);
	at[15] = 10.6167;
	points[16] = (2029.9764, -7468.6611, 3399.0671);
	angles[16] = (0, -232.9898, 0);
	at[16] = 11.0500;
	points[17] = (1876.9055, -7556.1812, 3399.0671);
	angles[17] = (0, -238.8732, 0);
	at[17] = 11.2667;
	points[18] = (1721.6458, -7640.2759, 3399.0671);
	angles[18] = (0, -240.8748, 0);
	at[18] = 11.4833;
	points[19] = (1562.0472, -7715.2759, 3399.0671);
	angles[19] = (0, -244.6983, 0);
	at[19] = 11.7000;
	points[20] = (1399.0551, -7783.1890, 3399.0671);
	angles[20] = (0, -246.6983, 0);
	at[20] = 11.9167;
	points[21] = (1233.5355, -7843.9766, 3399.0671);
	angles[21] = (0, -250.1842, 0);
	at[21] = 12.1333;
	points[22] = (1064.0236, -7893.3862, 3399.0671);
	angles[22] = (0, -252.8358, 0);
	at[22] = 12.3500;
	points[23] = (893.1260, -7936.7715, 3399.0671);
	angles[23] = (0, -255.8450, 0);
	at[23] = 12.5667;
	points[24] = (718.9528, -7965.7871, 3399.0671);
	angles[24] = (0, -259.3443, 0);
	at[24] = 12.7833;
	points[25] = (544.2992, -7990.9053, 3399.0671);
	angles[25] = (0, -261.9141, 0);
	at[25] = 13;
	points[26] = (-159.7516, -8047.2441, 3399.0671);
	angles[26] = (0, -266.4759, 0);
	at[26] = 13.8667;
	points[27] = (-335.2914, -8026.1416, 3399.0671);
	angles[27] = (0, -273.6607, 0);
	at[27] = 14.0833;
	points[28] = (-510.8622, -8007.3618, 3399.0671);
	angles[28] = (0, -275.4915, 0);
	at[28] = 14.3000;
	points[29] = (-683.9174, -7973.6221, 3399.0671);
	angles[29] = (0, -280.4348, 0);
	at[29] = 14.5167;
	points[30] = (-855.9724, -7933.8975, 3399.0671);
	angles[30] = (0, -282.3439, 0);
	at[30] = 14.7333;
	points[31] = (-1197.5552, -7844.4883, 3399.0671);
	angles[31] = (0, -284.9382, 0);
	at[31] = 15.1667;
	points[32] = (-1363.6654, -7785.6304, 3399.0671);
	angles[32] = (0, -289.3658, 0);
	at[32] = 15.3833;
	points[33] = (-1526.6575, -7717.7168, 3399.0671);
	angles[33] = (0, -291.7925, 0);
	at[33] = 15.6000;
	points[34] = (-1687.6102, -7645.3545, 3399.0671);
	angles[34] = (0, -294.2575, 0);
	at[34] = 15.8167;
	points[35] = (-1845.5472, -7566.4175, 3399.0671);
	angles[35] = (0, -295.9785, 0);
	at[35] = 16.0333;
	points[36] = (-2001.0709, -7483.4648, 3399.0671);
	angles[36] = (0, -298.9736, 0);
	at[36] = 16.2500;
	points[37] = (-2286.6772, -7275.7480, 3399.0671);
	angles[37] = (0, -305.5711, 0);
	at[37] = 16.6833;
	points[38] = (-2425.1260, -7166.1812, 3399.0671);
	angles[38] = (0, -307.8001, 0);
	at[38] = 16.9000;
	points[39] = (-2563.0081, -7055.9058, 3399.0671);
	angles[39] = (0, -308.4412, 0);
	at[39] = 17.1167;
	points[40] = (-2691.2085, -6934.7642, 3399.0671);
	angles[40] = (0, -312.7320, 0);
	at[40] = 17.3333;
	points[41] = (-2816.0669, -6809.9214, 3399.0671);
	angles[41] = (0, -314.4235, 0);
	at[41] = 17.5500;
	points[42] = (-2936.2834, -6680.6689, 3399.0671);
	angles[42] = (0, -316.7704, 0);
	at[42] = 17.7667;
	points[43] = (-3053.5947, -6548.7012, 3399.0671);
	angles[43] = (0, -317.9607, 0);
	at[43] = 17.9833;
	points[44] = (-3155.5789, -6405.3940, 3399.0671);
	angles[44] = (0, -324.1235, 0);
	at[44] = 18.2000;
	points[45] = (-3247.3857, -6254.5669, 3399.0671);
	angles[45] = (0, -327.5148, 0);
	at[45] = 18.4167;
	points[46] = (-3335.6536, -6101.7319, 3399.0671);
	angles[46] = (0, -329.9230, 0);
	at[46] = 18.6333;
	points[47] = (-3496.5198, -5787.4805, 3399.0671);
	angles[47] = (0, -333.6199, 0);
	at[47] = 19.0667;
	points[48] = (-3632.3464, -5461.4961, 3399.0671);
	angles[48] = (0, -337.5553, 0);
	at[48] = 19.5000;
	points[49] = (-3743.9409, -5126.4570, 3399.0671);
	angles[49] = (0, -341.3059, 0);
	at[49] = 19.9333;
	points[50] = (-3825.1025, -4782.8350, 3399.0671);
	angles[50] = (0, -346.5978, 0);
	at[50] = 20.3667;
	points[51] = (-3847.5278, -4608.1494, 3399.0671);
	angles[51] = (0, -352.1625, 0);
	at[51] = 20.5833;
	points[52] = (-3861.0708, -4432.0864, 3399.0671);
	angles[52] = (0, -354.7270, 0);
	at[52] = 20.8000;
	points[53] = (-3868.1104, -4255.7876, 3399.0630);
	angles[53] = (0, -357.6730, 0);
	at[53] = 21.0167;
	points[54] = (-3868.1104, -3726.0474, 3399.0671);
	angles[54] = (0, -359.9618, 0);
	at[54] = 21.6667;
	points[55] = (-3868.1104, 4219.7637, 3399.0671);
	angles[55] = (0, -360, 0);
	at[55] = 31.4167;
	points[56] = (-3861.8860, 4396.1421, 3399.0671);
	angles[56] = (0, -362.1937, 0);
	at[56] = 31.6333;
	points[57] = (-3848.9331, 4572.2051, 3399.0671);
	angles[57] = (0, -363.6945, 0);
	at[57] = 31.8500;
	points[58] = (-3830.3740, 4747.4409, 3399.0630);
	angles[58] = (0, -366.5591, 0);
	at[58] = 32.0667;
	points[59] = (-3748.5869, 5090.9844, 3399.0671);
	angles[59] = (0, -373.4183, 0);
	at[59] = 32.5000;
	points[60] = (-3638.4646, 5426.5752, 3399.0671);
	angles[60] = (0, -377.7852, 0);
	at[60] = 32.9333;
	points[61] = (-3509.4565, 5755.2759, 3399.0671);
	angles[61] = (0, -381.3672, 0);
	at[61] = 33.3667;
	points[62] = (-3431.5435, 5913.3071, 3399.0671);
	angles[62] = (0, -385.8409, 0);
	at[62] = 33.5833;
	points[63] = (-3345.5510, 6067.5591, 3399.0671);
	angles[63] = (0, -388.3036, 0);
	at[63] = 33.8000;
	points[64] = (-3252.8740, 6217.6772, 3399.0671);
	angles[64] = (0, -391.5505, 0);
	at[64] = 34.0167;
	points[65] = (-3154.7834, 6364.4883, 3399.0671);
	angles[65] = (0, -393.1884, 0);
	at[65] = 34.2333;
	points[66] = (-3050.5513, 6506.7720, 3399.0671);
	angles[66] = (0, -396.2113, 0);
	at[66] = 34.4500;
	points[67] = (-2938.6812, 6643.3862, 3399.0671);
	angles[67] = (0, -398.5243, 0);
	at[67] = 34.6667;
	points[68] = (-2823.7480, 6777.3228, 3399.0671);
	angles[68] = (0, -400.7363, 0);
	at[68] = 34.8833;
	points[69] = (-2579.5710, 7032.2046, 3399.0671);
	angles[69] = (0, -404.4595, 0);
	at[69] = 35.3167;
	points[70] = (-2307.5984, 7257.4805, 3399.0671);
	angles[70] = (0, -409.9835, 0);
	at[70] = 35.7500;
	points[71] = (-2157.8503, 7350.9453, 3399.0671);
	angles[71] = (0, -416.1758, 0);
	at[71] = 35.9667;
	points[72] = (-2007.6339, 7443.7402, 3399.0671);
	angles[72] = (0, -417.7529, 0);
	at[72] = 36.1833;
	points[73] = (-1690.1102, 7597.8740, 3399.0671);
	angles[73] = (0, -424.1849, 0);
	at[73] = 36.6167;
	points[74] = (-1365.1575, 7735.9844, 3399.0671);
	angles[74] = (0, -427.2161, 0);
	at[74] = 37.0500;
	points[75] = (-1200.4646, 7799.4492, 3399.0671);
	angles[75] = (0, -429.0075, 0);
	at[75] = 37.2667;
	points[76] = (-1033.6771, 7857.4019, 3399.0671);
	angles[76] = (0, -430.3709, 0);
	at[76] = 37.4833;
	points[77] = (-863.8544, 7904.1733, 3399.0671);
	angles[77] = (0, -434.9244, 0);
	at[77] = 37.7000;
	points[78] = (-516.7402, 7968.4648, 3399.0671);
	angles[78] = (0, -440.2809, 0);
	at[78] = 38.1333;
	points[79] = (-165.7579, 8007.5200, 3399.0671);
	angles[79] = (0, -443.4340, 0);
	at[79] = 38.5667;
	points[80] = (187.2740, 8007.5591, 3399.0671);
	angles[80] = (0, -449.8434, 0);
	at[80] = 39;
	points[81] = (538.2638, 7969.5273, 3399.0671);
	angles[81] = (0, -456.0477, 0);
	at[81] = 39.4333;
	points[82] = (712.2126, 7939.8423, 3399.0671);
	angles[82] = (0, -459.3284, 0);
	at[82] = 39.6500;
	points[83] = (885.5315, 7906.1025, 3399.0671);
	angles[83] = (0, -460.5875, 0);
	at[83] = 39.8667;
	points[84] = (1055.8859, 7860.5117, 3399.0671);
	angles[84] = (0, -464.6046, 0);
	at[84] = 40.0833;
	points[85] = (1224.6969, 7808.7012, 3399.0671);
	angles[85] = (0, -466.4319, 0);
	at[85] = 40.3000;
	points[86] = (1389.2126, 7745.5117, 3399.0671);
	angles[86] = (0, -470.9342, 0);
	at[86] = 40.5167;
	points[87] = (1871.1141, 7525.5903, 3399.0671);
	angles[87] = (0, -474.8099, 0);
	at[87] = 41.1667;
	points[88] = (2029.0511, 7447.2832, 3399.0671);
	angles[88] = (0, -476.7410, 0);
	at[88] = 41.3833;
	points[89] = (2319.3818, 7246.2993, 3399.0671);
	angles[89] = (0, -484.6766, 0);
	at[89] = 41.8167;
	points[90] = (2597.0552, 7028.1108, 3399.0671);
	angles[90] = (0, -487.9357, 0);
	at[90] = 42.2500;
	points[91] = (2721.6301, 6902.9922, 3399.0671);
	angles[91] = (0, -493.3484, 0);
	at[91] = 42.4667;
	points[92] = (2846.0591, 6777.7168, 3399.0671);
	angles[92] = (0, -494.7261, 0);
	at[92] = 42.6833;
	points[93] = (3071.6262, 6506.1025, 3399.0671);
	angles[93] = (0, -500.2623, 0);
	at[93] = 43.1167;
	points[94] = (3173.6023, 6362.1655, 3399.0671);
	angles[94] = (0, -504.0864, 0);
	at[94] = 43.3333;
	points[95] = (3272.1536, 6215.6299, 3399.0671);
	angles[95] = (0, -505.5685, 0);
	at[95] = 43.5500;
	points[96] = (3358.1851, 6061.8110, 3399.0671);
	angles[96] = (0, -510.4097, 0);
	at[96] = 43.7667;
	points[97] = (3437.3386, 5903.9766, 3399.0671);
	angles[97] = (0, -512.6149, 0);
	at[97] = 43.9833;
	points[98] = (3511.4370, 5743.8584, 3399.0671);
	angles[98] = (0, -515.2484, 0);
	at[98] = 44.2000;
	points[99] = (3643.3621, 5416.2993, 3399.0671);
	angles[99] = (0, -518.3752, 0);
	at[99] = 44.6333;
	points[100] = (3757.2363, 5082.2441, 3399.0671);
	angles[100] = (0, -522.2357, 0);
	at[100] = 45.0667;
	points[101] = (3834.8896, 4737.7163, 3399.0671);
	angles[101] = (0, -526.9703, 0);
	at[101] = 45.5000;
	points[102] = (3841.7834, 4561.5747, 3399.0671);
	angles[102] = (0, -535.4962, 0);
	at[102] = 45.7167;
	points[103] = (3845.3230, 4385.0396, 3399.0671);
	angles[103] = (0, -537.9987, 0);
	at[103] = 45.9333;
	points[104] = (3868.1104, 3149.2520, 3399.0671);
	angles[104] = (0, -539.5057, 0);
	at[104] = 47.4500;
	points[105] = (3868.1104, 1030.3583, 3399.0671);
	angles[105] = (0, -540, 0);
	at[105] = 50.0500;
	points[106] = (3868.1104, 896.9449, 3399.0671);
	angles[106] = (0, -540, 0);
	at[106] = 50.2167;
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
	points[0] = (3868.1104, 3229.6221, 3399.0671);
	angles[0] = (0, -179.0699, 0);
	at[0] = 0;
	points[1] = (3868.1104, -4186.4961, 3399.0671);
	angles[1] = (0, -180, 0);
	at[1] = 9.1000;
	points[2] = (3866.3818, -4363.0317, 3399.0671);
	angles[2] = (0, -180.8352, 0);
	at[2] = 9.3167;
	points[3] = (3839.2952, -4715.1182, 3399.0671);
	angles[3] = (0, -184.1684, 0);
	at[3] = 9.7500;
	points[4] = (3800.9685, -4887.4014, 3399.0671);
	angles[4] = (0, -190.7476, 0);
	at[4] = 9.9667;
	points[5] = (3761.2639, -5059.4487, 3399.0671);
	angles[5] = (0, -192.4233, 0);
	at[5] = 10.1833;
	points[6] = (3710.0039, -5228.2681, 3399.0671);
	angles[6] = (0, -196.3915, 0);
	at[6] = 10.4000;
	points[7] = (3654.1694, -5395.7480, 3399.0671);
	angles[7] = (0, -197.9155, 0);
	at[7] = 10.6167;
	points[8] = (3591.0710, -5560.5513, 3399.0671);
	angles[8] = (0, -200.6857, 0);
	at[8] = 10.8333;
	points[9] = (3523.1575, -5723.5435, 3399.0671);
	angles[9] = (0, -202.1282, 0);
	at[9] = 11.0500;
	points[10] = (3449.3662, -5883.7793, 3399.0671);
	angles[10] = (0, -204.8051, 0);
	at[10] = 11.2667;
	points[11] = (3367.6890, -6040.3545, 3399.0671);
	angles[11] = (0, -206.8543, 0);
	at[11] = 11.4833;
	points[12] = (3283.3977, -6195.4331, 3399.0671);
	angles[12] = (0, -208.6732, 0);
	at[12] = 11.7000;
	points[13] = (3099.7795, -6497.0869, 3399.0671);
	angles[13] = (0, -212.1834, 0);
	at[13] = 12.1333;
	points[14] = (2982.2991, -6628.9370, 3399.0671);
	angles[14] = (0, -219.2272, 0);
	at[14] = 12.3500;
	points[15] = (2864.9883, -6760.9058, 3399.0671);
	angles[15] = (0, -221.0218, 0);
	at[15] = 12.5667;
	points[16] = (2615.3267, -7010.6694, 3399.0671);
	angles[16] = (0, -224.7429, 0);
	at[16] = 13;
	points[17] = (2341.3269, -7233.2285, 3399.0671);
	angles[17] = (0, -230.8679, 0);
	at[17] = 13.4333;
	points[18] = (2059.7402, -7446.3384, 3399.0671);
	angles[18] = (0, -232.9409, 0);
	at[18] = 13.8667;
	points[19] = (1909.6219, -7538.4648, 3399.0671);
	angles[19] = (0, -238.2399, 0);
	at[19] = 14.0833;
	points[20] = (1754.3583, -7622.5596, 3399.0671);
	angles[20] = (0, -240.7136, 0);
	at[20] = 14.3000;
	points[21] = (1596.3899, -7700.9844, 3399.0671);
	angles[21] = (0, -243.7253, 0);
	at[21] = 14.5167;
	points[22] = (1269.2520, -7833.5435, 3399.0671);
	angles[22] = (0, -248.8652, 0);
	at[22] = 14.9500;
	points[23] = (929.8229, -7930.6694, 3399.0671);
	angles[23] = (0, -254.7141, 0);
	at[23] = 15.3833;
	points[24] = (581.4803, -7988.7007, 3399.0671);
	angles[24] = (0, -260.6495, 0);
	at[24] = 15.8167;
	points[25] = (405.3701, -8002.0083, 3399.0671);
	angles[25] = (0, -264.2114, 0);
	at[25] = 16.0333;
	points[26] = (-122.6657, -8044.2524, 3399.0671);
	angles[26] = (0, -265.4062, 0);
	at[26] = 16.6833;
	points[27] = (-298.2988, -8030.1182, 3399.0671);
	angles[27] = (0, -273.0846, 0);
	at[27] = 16.9000;
	points[28] = (-473.8701, -8011.2993, 3399.0671);
	angles[28] = (0, -275.3449, 0);
	at[28] = 17.1167;
	points[29] = (-647.6693, -7981.9688, 3399.0671);
	angles[29] = (0, -279.5054, 0);
	at[29] = 17.3333;
	points[30] = (-991.3110, -7900.7085, 3399.0671);
	angles[30] = (0, -283.5464, 0);
	at[30] = 17.7667;
	points[31] = (-1161.6615, -7854.2520, 3399.0671);
	angles[31] = (0, -284.8207, 0);
	at[31] = 17.9833;
	points[32] = (-1329.3229, -7799.9609, 3399.0671);
	angles[32] = (0, -288.1570, 0);
	at[32] = 18.2000;
	points[33] = (-1654.3346, -7662.0083, 3399.0671);
	angles[33] = (0, -293.4000, 0);
	at[33] = 18.6333;
	points[34] = (-1970.2008, -7504.0552, 3399.0671);
	angles[34] = (0, -296.3605, 0);
	at[34] = 19.0667;
	points[35] = (-2113.7834, -7401.4961, 3399.0671);
	angles[35] = (0, -303.5657, 0);
	at[35] = 19.2833;
	points[36] = (-2256.5867, -7297.6377, 3399.0671);
	angles[36] = (0, -305.4015, 0);
	at[36] = 19.5000;
	points[37] = (-2396.0747, -7189.4487, 3399.0671);
	angles[37] = (0, -307.4807, 0);
	at[37] = 19.7167;
	points[38] = (-2533.9568, -7079.1338, 3399.0671);
	angles[38] = (0, -308.3600, 0);
	at[38] = 19.9333;
	points[39] = (-2664.9016, -6961.0635, 3399.0671);
	angles[39] = (0, -311.8892, 0);
	at[39] = 20.1500;
	points[40] = (-2789.7600, -6836.2207, 3399.0671);
	angles[40] = (0, -314.2091, 0);
	at[40] = 20.3667;
	points[41] = (-2911.5669, -6708.5039, 3399.0671);
	angles[41] = (0, -316.3759, 0);
	at[41] = 20.5833;
	points[42] = (-3028.8782, -6576.5356, 3399.0671);
	angles[42] = (0, -317.8604, 0);
	at[42] = 20.8000;
	points[43] = (-3136.2324, -6437.1655, 3399.0671);
	angles[43] = (0, -323.0566, 0);
	at[43] = 21.0167;
	points[44] = (-3318.4448, -6134.7246, 3399.0630);
	angles[44] = (0, -329.0253, 0);
	at[44] = 21.4500;
	points[45] = (-3481.7991, -5821.6143, 3399.0671);
	angles[45] = (0, -332.2261, 0);
	at[45] = 21.8833;
	points[46] = (-3618.0396, -5495.8267, 3399.0671);
	angles[46] = (0, -337.0469, 0);
	at[46] = 22.3167;
	points[47] = (-3732.1772, -5161.7324, 3399.0671);
	angles[47] = (0, -341.2095, 0);
	at[47] = 22.7500;
	points[48] = (-3777.0315, -4991.1421, 3399.0671);
	angles[48] = (0, -344.8060, 0);
	at[48] = 22.9667;
	points[49] = (-3816.7363, -4819.0947, 3399.0671);
	angles[49] = (0, -346.4463, 0);
	at[49] = 23.1833;
	points[50] = (-3844.6733, -4645.2363, 3399.0671);
	angles[50] = (0, -350.8853, 0);
	at[50] = 23.4000;
	points[51] = (-3858.2168, -4469.1733, 3399.0671);
	angles[51] = (0, -354.4020, 0);
	at[51] = 23.6167;
	points[52] = (-3868.1104, -4292.9922, 3399.0671);
	angles[52] = (0, -356.8082, 0);
	at[52] = 23.8333;
	points[53] = (-3868.1104, -3763.2520, 3399.0671);
	angles[53] = (0, -359.9476, 0);
	at[53] = 24.4833;
	points[54] = (-3868.1104, 4182.5591, 3399.0671);
	angles[54] = (0, -360, 0);
	at[54] = 34.2333;
	points[55] = (-3864.6143, 4359.0161, 3399.0671);
	angles[55] = (0, -361.4459, 0);
	at[55] = 34.4500;
	points[56] = (-3838.7129, 4711.2207, 3399.0671);
	angles[56] = (0, -364.0276, 0);
	at[56] = 34.8833;
	points[57] = (-3798.0947, 4883.0317, 3399.0671);
	angles[57] = (0, -371.0068, 0);
	at[57] = 35.1000;
	points[58] = (-3757.2009, 5054.8032, 3399.0671);
	angles[58] = (0, -372.7849, 0);
	at[58] = 35.3167;
	points[59] = (-3650.0159, 5391.1812, 3399.0671);
	angles[59] = (0, -377.6731, 0);
	at[59] = 35.7500;
	points[60] = (-3523.1772, 5720.6689, 3399.0671);
	angles[60] = (0, -381.2651, 0);
	at[60] = 36.1833;
	points[61] = (-3449.6614, 5880.8267, 3399.0671);
	angles[61] = (0, -385.0573, 0);
	at[61] = 36.4000;
	points[62] = (-3363.6694, 6035.0391, 3399.0671);
	angles[62] = (0, -388.1042, 0);
	at[62] = 36.6167;
	points[63] = (-3273.5435, 6186.7324, 3399.0671);
	angles[63] = (0, -390.7631, 0);
	at[63] = 36.8333;
	points[64] = (-3175.4529, 6333.5430, 3399.0671);
	angles[64] = (0, -392.9881, 0);
	at[64] = 37.0500;
	points[65] = (-3074.1260, 6477.9922, 3399.0671);
	angles[65] = (0, -395.4664, 0);
	at[65] = 37.2667;
	points[66] = (-2849.2522, 6750.2358, 3399.0671);
	angles[66] = (0, -399.8176, 0);
	at[66] = 37.7000;
	points[67] = (-2607.1455, 7007.3228, 3399.0671);
	angles[67] = (0, -403.0560, 0);
	at[67] = 38.1333;
	points[68] = (-2472.2363, 7121.1025, 3399.0671);
	angles[68] = (0, -408.5056, 0);
	at[68] = 38.3500;
	points[69] = (-2336.2520, 7233.7402, 3399.0671);
	angles[69] = (0, -409.8926, 0);
	at[69] = 38.5667;
	points[70] = (-2189.5000, 7331.3779, 3399.0671);
	angles[70] = (0, -415.4033, 0);
	at[70] = 38.7833;
	points[71] = (-2039.2834, 7424.1733, 3399.0671);
	angles[71] = (0, -417.5563, 0);
	at[71] = 39;
	points[72] = (-1883.4410, 7506.6143, 3399.0630);
	angles[72] = (0, -421.7714, 0);
	at[72] = 39.2167;
	points[73] = (-1562.7521, 7654.3706, 3399.0671);
	angles[73] = (0, -425.7001, 0);
	at[73] = 39.6500;
	points[74] = (-1235.6102, 7787.2446, 3399.0671);
	angles[74] = (0, -428.3279, 0);
	at[74] = 40.0833;
	points[75] = (-1068.8190, 7845.1973, 3399.0671);
	angles[75] = (0, -430.1981, 0);
	at[75] = 40.3000;
	points[76] = (-900.3622, 7897.0078, 3399.0671);
	angles[76] = (0, -433.4451, 0);
	at[76] = 40.5167;
	points[77] = (-553.8110, 7964.9604, 3399.0671);
	angles[77] = (0, -439.0287, 0);
	at[77] = 40.9500;
	points[78] = (-202.7346, 8003.3857, 3399.0671);
	angles[78] = (0, -443.3531, 0);
	at[78] = 41.3833;
	points[79] = (-26.5020, 8008.8188, 3399.0671);
	angles[79] = (0, -447.6696, 0);
	at[79] = 41.6000;
	points[80] = (150.0697, 8007.7563, 3399.0671);
	angles[80] = (0, -449.6595, 0);
	at[80] = 41.8167;
	points[81] = (325.8665, 7993.8188, 3399.0671);
	angles[81] = (0, -453.9530, 0);
	at[81] = 42.0333;
	points[82] = (501.2992, 7973.7402, 3399.0671);
	angles[82] = (0, -455.8705, 0);
	at[82] = 42.2500;
	points[83] = (675.6929, 7946.9683, 3399.0671);
	angles[83] = (0, -458.7009, 0);
	at[83] = 42.4667;
	points[84] = (849.0118, 7913.2285, 3399.0671);
	angles[84] = (0, -460.4280, 0);
	at[84] = 42.6833;
	points[85] = (1020.3189, 7871.4175, 3399.0671);
	angles[85] = (0, -463.6942, 0);
	at[85] = 42.9000;
	points[86] = (1189.1299, 7819.6064, 3399.0671);
	angles[86] = (0, -466.2003, 0);
	at[86] = 43.1167;
	points[87] = (1355.2638, 7760.7085, 3399.0671);
	angles[87] = (0, -469.7397, 0);
	at[87] = 43.3333;
	points[88] = (1677.3464, 7615.8657, 3399.0671);
	angles[88] = (0, -474.0242, 0);
	at[88] = 43.7667;
	points[89] = (1997.4371, 7466.6934, 3399.0671);
	angles[89] = (0, -474.9263, 0);
	at[89] = 44.2000;
	points[90] = (2143.9409, 7368.3857, 3399.0671);
	angles[90] = (0, -482.0455, 0);
	at[90] = 44.4167;
	points[91] = (2289.5000, 7268.4253, 3399.0671);
	angles[91] = (0, -483.8594, 0);
	at[91] = 44.6333;
	points[92] = (2567.8032, 7051.1025, 3399.0671);
	angles[92] = (0, -487.8564, 0);
	at[92] = 45.0667;
	points[93] = (2695.4097, 6929.3701, 3399.0671);
	angles[93] = (0, -492.9084, 0);
	at[93] = 45.2833;
	points[94] = (2819.8425, 6804.0947, 3399.0671);
	angles[94] = (0, -494.6143, 0);
	at[94] = 45.5000;
	points[95] = (2936.1851, 6671.5356, 3399.0671);
	angles[95] = (0, -498.4104, 0);
	at[95] = 45.7167;
	points[96] = (3048.0552, 6534.9214, 3399.0671);
	angles[96] = (0, -500.1085, 0);
	at[96] = 45.9333;
	points[97] = (3152.8386, 6393.0312, 3399.0671);
	angles[97] = (0, -503.3488, 0);
	at[97] = 46.1500;
	points[98] = (3251.3896, 6246.4961, 3399.0671);
	angles[98] = (0, -505.3810, 0);
	at[98] = 46.3667;
	points[99] = (3341.5039, 6095.0791, 3399.0671);
	angles[99] = (0, -509.3112, 0);
	at[99] = 46.5833;
	points[100] = (3497.3740, 5778.2681, 3399.0671);
	angles[100] = (0, -514.3031, 0);
	at[100] = 47.0167;
	points[101] = (3630.8506, 5451.3389, 3399.0671);
	angles[101] = (0, -517.5669, 0);
	at[101] = 47.4500;
	points[102] = (3748.5669, 5118.3862, 3399.0671);
	angles[102] = (0, -520.3572, 0);
	at[102] = 47.8833;
	points[103] = (3826.7087, 4774.0161, 3399.0671);
	angles[103] = (0, -526.8487, 0);
	at[103] = 48.3167;
	points[104] = (3841.0396, 4598.7793, 3399.0671);
	angles[104] = (0, -534.6980, 0);
	at[104] = 48.5333;
	points[105] = (3848.1143, 4245.7090, 3399.0671);
	angles[105] = (0, -538.5834, 0);
	at[105] = 48.9667;
	points[106] = (3865.8071, 3363.0120, 3399.0671);
	angles[106] = (0, -538.8516, 0);
	at[106] = 50.0500;
	points[107] = (3868.1104, 3229.6221, 3399.0671);
	angles[107] = (0, -539.0699, 0);
	at[107] = 50.2167;
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
	points[0] = (3868.1104, 2786.7087, 3399.0671);
	angles[0] = (0, -179.9681, 0);
	at[0] = 0;
	points[1] = (3868.1104, -4276.2598, 3399.0671);
	angles[1] = (0, -180, 0);
	at[1] = 8.6667;
	points[2] = (3859.4961, -4452.5200, 3399.0671);
	angles[2] = (0, -182.6940, 0);
	at[2] = 8.8833;
	points[3] = (3845.9529, -4628.5830, 3399.0671);
	angles[3] = (0, -183.9653, 0);
	at[3] = 9.1000;
	points[4] = (3820.4919, -4802.7954, 3399.0671);
	angles[4] = (0, -188.3107, 0);
	at[4] = 9.3167;
	points[5] = (3737.4565, -5145.9053, 3399.0630);
	angles[5] = (0, -194.1647, 0);
	at[5] = 9.7500;
	points[6] = (3624.4607, -5480.4331, 3399.0671);
	angles[6] = (0, -198.9534, 0);
	at[6] = 10.1833;
	points[7] = (3488.6338, -5806.4175, 3399.0671);
	angles[7] = (0, -202.3829, 0);
	at[7] = 10.6167;
	points[8] = (3326.1694, -6119.9214, 3399.0671);
	angles[8] = (0, -207.2186, 0);
	at[8] = 11.0500;
	points[9] = (3144.9172, -6422.9136, 3399.0671);
	angles[9] = (0, -210.9724, 0);
	at[9] = 11.4833;
	points[10] = (3039.9727, -6564.0552, 3399.0671);
	angles[10] = (0, -216.6050, 0);
	at[10] = 11.7000;
	points[11] = (2922.6616, -6696.0234, 3399.0671);
	angles[11] = (0, -220.3547, 0);
	at[11] = 11.9167;
	points[12] = (2801.5669, -6824.4092, 3399.0671);
	angles[12] = (0, -223.0643, 0);
	at[12] = 12.1333;
	points[13] = (2676.7087, -6949.2910, 3399.0671);
	angles[13] = (0, -224.5080, 0);
	at[13] = 12.3500;
	points[14] = (2546.9961, -7068.7007, 3399.0671);
	angles[14] = (0, -227.4691, 0);
	at[14] = 12.5667;
	points[15] = (2409.1143, -7179.0156, 3399.0671);
	angles[15] = (0, -230.3559, 0);
	at[15] = 12.7833;
	points[16] = (2270.4487, -7288.3071, 3399.0671);
	angles[16] = (0, -231.7055, 0);
	at[16] = 13;
	points[17] = (1985.9528, -7497.1260, 3399.0671);
	angles[17] = (0, -234.6356, 0);
	at[17] = 13.4333;
	points[18] = (1675.4331, -7665.3154, 3399.0671);
	angles[18] = (0, -241.1094, 0);
	at[18] = 13.8667;
	points[19] = (1513.5315, -7735.5117, 3399.0671);
	angles[19] = (0, -245.6204, 0);
	at[19] = 14.0833;
	points[20] = (1350.5355, -7803.4253, 3399.0671);
	angles[20] = (0, -246.9329, 0);
	at[20] = 14.3000;
	points[21] = (1183.0787, -7858.6616, 3399.0671);
	angles[21] = (0, -251.1602, 0);
	at[21] = 14.5167;
	points[22] = (1013.5670, -7908.1104, 3399.0671);
	angles[22] = (0, -253.0839, 0);
	at[22] = 14.7333;
	points[23] = (841.2835, -7945.4331, 3399.0671);
	angles[23] = (0, -257.4418, 0);
	at[23] = 14.9500;
	points[24] = (667.1102, -7974.4487, 3399.0671);
	angles[24] = (0, -259.7507, 0);
	at[24] = 15.1667;
	points[25] = (491.9055, -7995.0786, 3399.0671);
	angles[25] = (0, -263.1206, 0);
	at[25] = 15.3833;
	points[26] = (-36.1304, -8037.3228, 3399.0671);
	angles[26] = (0, -265.3883, 0);
	at[26] = 16.0333;
	points[27] = (-211.9807, -8039.3701, 3399.0671);
	angles[27] = (0, -269.7837, 0);
	at[27] = 16.2500;
	points[28] = (-563.1221, -8001.7324, 3399.0671);
	angles[28] = (0, -276.3926, 0);
	at[28] = 16.6833;
	points[29] = (-907.1851, -7922.0864, 3399.0671);
	angles[29] = (0, -282.5676, 0);
	at[29] = 17.1167;
	points[30] = (-1248.2638, -7830.6299, 3399.0671);
	angles[30] = (0, -285.0471, 0);
	at[30] = 17.5500;
	points[31] = (-1575.1732, -7697.5195, 3399.0671);
	angles[31] = (0, -292.0771, 0);
	at[31] = 17.9833;
	points[32] = (-1892.5552, -7542.9136, 3399.0671);
	angles[32] = (0, -296.1802, 0);
	at[32] = 18.4167;
	points[33] = (-2043.5787, -7452.5591, 3399.0671);
	angles[33] = (0, -300.8936, 0);
	at[33] = 18.6333;
	points[34] = (-2186.3779, -7348.7007, 3399.0671);
	angles[34] = (0, -304.7218, 0);
	at[34] = 18.8500;
	points[35] = (-2328.2834, -7243.6616, 3399.0671);
	angles[35] = (0, -306.4087, 0);
	at[35] = 19.0667;
	points[36] = (-2604.0474, -7023.0708, 3399.0671);
	angles[36] = (0, -309.1473, 0);
	at[36] = 19.5000;
	points[37] = (-2853.2322, -6772.7559, 3399.0671);
	angles[37] = (0, -314.6216, 0);
	at[37] = 19.9333;
	points[38] = (-3088.5117, -6509.4097, 3399.0671);
	angles[38] = (0, -318.1002, 0);
	at[38] = 20.3667;
	points[39] = (-3182.9058, -6360.5122, 3399.0671);
	angles[39] = (0, -325.6867, 0);
	at[39] = 20.5833;
	points[40] = (-3274.7124, -6209.6851, 3399.0671);
	angles[40] = (0, -327.9125, 0);
	at[40] = 20.8000;
	points[41] = (-3359.9646, -6055.1572, 3399.0671);
	angles[41] = (0, -330.7910, 0);
	at[41] = 21.0167;
	points[42] = (-3441.6418, -5898.5830, 3399.0671);
	angles[42] = (0, -332.0262, 0);
	at[42] = 21.2333;
	points[43] = (-3516.7363, -5738.9766, 3399.0671);
	angles[43] = (0, -334.9127, 0);
	at[43] = 21.4500;
	points[44] = (-3648.8860, -5411.6143, 3399.0671);
	angles[44] = (0, -338.6592, 0);
	at[44] = 21.8833;
	points[45] = (-3757.5120, -5075.7090, 3399.0671);
	angles[45] = (0, -342.8502, 0);
	at[45] = 22.3167;
	points[46] = (-3836.9214, -4731.6143, 3399.0671);
	angles[46] = (0, -346.7368, 0);
	at[46] = 22.7500;
	points[47] = (-3851.5591, -4555.7085, 3399.0671);
	angles[47] = (0, -353.3445, 0);
	at[47] = 22.9667;
	points[48] = (-3865.1023, -4379.6851, 3399.0671);
	angles[48] = (0, -355.0276, 0);
	at[48] = 23.1833;
	points[49] = (-3868.1104, -4203.2285, 3399.0671);
	angles[49] = (0, -358.4731, 0);
	at[49] = 23.4000;
	points[50] = (-3868.1104, -3850.0632, 3399.0671);
	angles[50] = (0, -359.9014, 0);
	at[50] = 23.8333;
	points[51] = (-3868.1104, 4272.3228, 3399.0671);
	angles[51] = (0, -360, 0);
	at[51] = 33.8000;
	points[52] = (-3845.0789, 4624.6460, 3399.0671);
	angles[52] = (0, -363.8704, 0);
	at[52] = 34.2333;
	points[53] = (-3818.2009, 4798.5830, 3399.0671);
	angles[53] = (0, -368.9061, 0);
	at[53] = 34.4500;
	points[54] = (-3777.3074, 4970.3545, 3399.0671);
	angles[54] = (0, -372.2505, 0);
	at[54] = 34.6667;
	points[55] = (-3731.7874, 5140.8267, 3399.0671);
	angles[55] = (0, -375.0231, 0);
	at[55] = 34.8833;
	points[56] = (-3620.3149, 5475.8662, 3399.0671);
	angles[56] = (0, -378.8521, 0);
	at[56] = 35.3167;
	points[57] = (-3490.0708, 5804.1343, 3399.0671);
	angles[57] = (0, -381.4619, 0);
	at[57] = 35.7500;
	points[58] = (-3319.9565, 6113.4644, 3399.0671);
	angles[58] = (0, -388.5923, 0);
	at[58] = 36.1833;
	points[59] = (-3125.5867, 6408.1895, 3399.0671);
	angles[59] = (0, -393.3803, 0);
	at[59] = 36.6167;
	points[60] = (-3017.2559, 6547.4409, 3399.0671);
	angles[60] = (0, -397.2777, 0);
	at[60] = 36.8333;
	points[61] = (-2905.3857, 6684.0552, 3399.0671);
	angles[61] = (0, -398.7957, 0);
	at[61] = 37.0500;
	points[62] = (-2787.7126, 6815.5903, 3399.0671);
	angles[62] = (0, -401.6110, 0);
	at[62] = 37.2667;
	points[63] = (-2666.6614, 6944.1338, 3399.0671);
	angles[63] = (0, -402.8556, 0);
	at[63] = 37.4833;
	points[64] = (-2539.0945, 7065.7085, 3399.0671);
	angles[64] = (0, -406.4888, 0);
	at[64] = 37.7000;
	points[65] = (-2403.1062, 7178.3467, 3399.0671);
	angles[65] = (0, -409.3798, 0);
	at[65] = 37.9167;
	points[66] = (-2263.3506, 7285.7480, 3399.0671);
	angles[66] = (0, -412.8356, 0);
	at[66] = 38.1333;
	points[67] = (-1961.9489, 7469.5674, 3399.0671);
	angles[67] = (0, -419.1601, 0);
	at[67] = 38.5667;
	points[68] = (-1642.5826, 7620.3149, 3399.0671);
	angles[68] = (0, -424.3738, 0);
	at[68] = 39;
	points[69] = (-1316.5789, 7756.0239, 3399.0671);
	angles[69] = (0, -427.3347, 0);
	at[69] = 39.4333;
	points[70] = (-984.0315, 7874.6851, 3399.0671);
	angles[70] = (0, -430.5308, 0);
	at[70] = 39.8667;
	points[71] = (-812.2756, 7914.2910, 3399.0671);
	angles[71] = (0, -436.0121, 0);
	at[71] = 40.0833;
	points[72] = (-639, 7948.2280, 3399.0671);
	angles[72] = (0, -438.1718, 0);
	at[72] = 40.3000;
	points[73] = (-464.5039, 7974.2524, 3399.0671);
	angles[73] = (0, -441.4217, 0);
	at[73] = 40.5167;
	points[74] = (-289.0134, 7993.7798, 3399.0671);
	angles[74] = (0, -443.0849, 0);
	at[74] = 40.7333;
	points[75] = (-113.3114, 8009.3306, 3399.0671);
	angles[75] = (0, -445.3174, 0);
	at[75] = 40.9500;
	points[76] = (239.6181, 8003.6616, 3399.0671);
	angles[76] = (0, -451.6877, 0);
	at[76] = 41.3833;
	points[77] = (590.4803, 7963.5435, 3399.0671);
	angles[77] = (0, -456.2114, 0);
	at[77] = 41.8167;
	points[78] = (937.1221, 7896.0630, 3399.0671);
	angles[78] = (0, -460.7061, 0);
	at[78] = 42.2500;
	points[79] = (1274.9448, 7793.3071, 3399.0671);
	angles[79] = (0, -466.6442, 0);
	at[79] = 42.6833;
	points[80] = (1598.2914, 7651.7324, 3399.0671);
	angles[80] = (0, -473.6133, 0);
	at[80] = 43.1167;
	points[81] = (1918.7521, 7503.3857, 3399.0671);
	angles[81] = (0, -474.8714, 0);
	at[81] = 43.5500;
	points[82] = (2072.3779, 7417.5596, 3399.0671);
	angles[82] = (0, -479.3980, 0);
	at[82] = 43.7667;
	points[83] = (2217.9370, 7317.5986, 3399.0671);
	angles[83] = (0, -483.1859, 0);
	at[83] = 43.9833;
	points[84] = (2360.7087, 7213.8193, 3399.0671);
	angles[84] = (0, -485.8745, 0);
	at[84] = 44.2000;
	points[85] = (2499.5432, 7104.7246, 3399.0671);
	angles[85] = (0, -487.5797, 0);
	at[85] = 44.4167;
	points[86] = (2634.2363, 6990.9844, 3399.0671);
	angles[86] = (0, -490.4294, 0);
	at[86] = 44.6333;
	points[87] = (2881.1851, 6738.7007, 3399.0671);
	angles[87] = (0, -495.9297, 0);
	at[87] = 45.0667;
	points[88] = (3104.9250, 6465.4727, 3399.0671);
	angles[88] = (0, -500.9175, 0);
	at[88] = 45.5000;
	points[89] = (3301.4883, 6172.0474, 3399.0671);
	angles[89] = (0, -505.7404, 0);
	at[89] = 45.9333;
	points[90] = (3381.7441, 6014.8423, 3399.0671);
	angles[90] = (0, -511.4260, 0);
	at[90] = 46.1500;
	points[91] = (3460.9016, 5857.0083, 3399.0671);
	angles[91] = (0, -512.8732, 0);
	at[91] = 46.3667;
	points[92] = (3531.3032, 5695.1973, 3399.0671);
	angles[92] = (0, -516.1230, 0);
	at[92] = 46.5833;
	points[93] = (3598.0393, 5531.6934, 3399.0671);
	angles[93] = (0, -517.3681, 0);
	at[93] = 46.8000;
	points[94] = (3660.8662, 5366.7324, 3399.0671);
	angles[94] = (0, -519.1230, 0);
	at[94] = 47.0167;
	points[95] = (3719.6614, 5200.2363, 3399.0671);
	angles[95] = (0, -520.1873, 0);
	at[95] = 47.2333;
	points[96] = (3768.7915, 5030.9448, 3399.0671);
	angles[96] = (0, -523.9753, 0);
	at[96] = 47.4500;
	points[97] = (3807.6182, 4858.7012, 3399.0671);
	angles[97] = (0, -526.4529, 0);
	at[97] = 47.6667;
	points[98] = (3839.2993, 4685.5908, 3399.0671);
	angles[98] = (0, -530.2019, 0);
	at[98] = 47.8833;
	points[99] = (3842.8386, 4509.0552, 3399.0671);
	angles[99] = (0, -536.6498, 0);
	at[99] = 48.1000;
	points[100] = (3846.3740, 4332.5195, 3399.0671);
	angles[100] = (0, -538.2921, 0);
	at[100] = 48.3167;
	points[101] = (3867.6062, 3273.2639, 3399.0671);
	angles[101] = (0, -538.8517, 0);
	at[101] = 49.6167;
	points[102] = (3868.1104, 2786.7087, 3399.0671);
	angles[102] = (0, -539.9681, 0);
	at[102] = 50.2167;
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
	points[0] = (3868.1104, 2343.7952, 3399.0671);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (3868.1104, -4189.4487, 3399.0671);
	angles[1] = (0, -180, 0);
	at[1] = 8.0167;
	points[2] = (3866.1536, -4365.9844, 3399.0671);
	angles[2] = (0, -180.8352, 0);
	at[2] = 8.2333;
	points[3] = (3839.0708, -4718.0708, 3399.0671);
	angles[3] = (0, -184.1684, 0);
	at[3] = 8.6667;
	points[4] = (3800.3071, -4890.2754, 3399.0671);
	angles[4] = (0, -190.7476, 0);
	at[4] = 8.8833;
	points[5] = (3760.6025, -5062.3228, 3399.0671);
	angles[5] = (0, -192.4233, 0);
	at[5] = 9.1000;
	points[6] = (3709.0710, -5231.0630, 3399.0671);
	angles[6] = (0, -196.3915, 0);
	at[6] = 9.3167;
	points[7] = (3653.2361, -5398.5825, 3399.0671);
	angles[7] = (0, -197.9155, 0);
	at[7] = 9.5333;
	points[8] = (3589.9373, -5563.2681, 3399.0671);
	angles[8] = (0, -200.8658, 0);
	at[8] = 9.7500;
	points[9] = (3522.0234, -5726.2603, 3399.0671);
	angles[9] = (0, -202.1740, 0);
	at[9] = 9.9667;
	points[10] = (3448, -5886.4175, 3399.0671);
	angles[10] = (0, -204.8167, 0);
	at[10] = 10.1833;
	points[11] = (3366.3230, -6042.9526, 3399.0671);
	angles[11] = (0, -206.8572, 0);
	at[11] = 10.4000;
	points[12] = (3281.8623, -6197.9526, 3399.0671);
	angles[12] = (0, -208.6740, 0);
	at[12] = 10.6167;
	points[13] = (3098.2439, -6499.6064, 3399.0671);
	angles[13] = (0, -212.1835, 0);
	at[13] = 11.0500;
	points[14] = (2980.3347, -6631.1416, 3399.0671);
	angles[14] = (0, -219.2272, 0);
	at[14] = 11.2667;
	points[15] = (2863.0276, -6763.1104, 3399.0671);
	angles[15] = (0, -221.3582, 0);
	at[15] = 11.4833;
	points[16] = (2613.2400, -7012.7559, 3399.0671);
	angles[16] = (0, -224.7646, 0);
	at[16] = 11.9167;
	points[17] = (2339.0198, -7235.0786, 3399.0671);
	angles[17] = (0, -230.8694, 0);
	at[17] = 12.3500;
	points[18] = (2057.3779, -7448.1104, 3399.0671);
	angles[18] = (0, -232.9410, 0);
	at[18] = 12.7833;
	points[19] = (1907.0237, -7539.8818, 3399.0671);
	angles[19] = (0, -238.2398, 0);
	at[19] = 13;
	points[20] = (1751.7638, -7623.9766, 3399.0671);
	angles[20] = (0, -240.7136, 0);
	at[20] = 13.2167;
	points[21] = (1593.6615, -7702.1260, 3399.0671);
	angles[21] = (0, -243.7253, 0);
	at[21] = 13.4333;
	points[22] = (1266.4174, -7834.3701, 3399.0671);
	angles[22] = (0, -248.8652, 0);
	at[22] = 13.8667;
	points[23] = (926.9134, -7931.1421, 3399.0671);
	angles[23] = (0, -254.7141, 0);
	at[23] = 14.3000;
	points[24] = (578.5669, -7989.2124, 3399.0671);
	angles[24] = (0, -260.6495, 0);
	at[24] = 14.7333;
	points[25] = (402.4291, -8002.2441, 3399.0671);
	angles[25] = (0, -264.2114, 0);
	at[25] = 14.9500;
	points[26] = (-125.6083, -8044.4883, 3399.0671);
	angles[26] = (0, -265.4062, 0);
	at[26] = 15.6000;
	points[27] = (-301.2335, -8029.8032, 3399.0671);
	angles[27] = (0, -273.0846, 0);
	at[27] = 15.8167;
	points[28] = (-476.8032, -8010.9844, 3399.0671);
	angles[28] = (0, -275.3449, 0);
	at[28] = 16.0333;
	points[29] = (-650.5433, -7981.2993, 3399.0671);
	angles[29] = (0, -279.5054, 0);
	at[29] = 16.2500;
	points[30] = (-994.1575, -7899.9604, 3399.0671);
	angles[30] = (0, -283.5464, 0);
	at[30] = 16.6833;
	points[31] = (-1164.5118, -7853.5044, 3399.0671);
	angles[31] = (0, -284.8207, 0);
	at[31] = 16.9000;
	points[32] = (-1332.0472, -7798.8188, 3399.0671);
	angles[32] = (0, -288.1570, 0);
	at[32] = 17.1167;
	points[33] = (-1656.9764, -7660.6689, 3399.0671);
	angles[33] = (0, -293.4000, 0);
	at[33] = 17.5500;
	points[34] = (-1972.8425, -7502.7563, 3399.0671);
	angles[34] = (0, -296.3605, 0);
	at[34] = 17.9833;
	points[35] = (-2116.1733, -7399.7637, 3399.0671);
	angles[35] = (0, -303.5657, 0);
	at[35] = 18.2000;
	points[36] = (-2258.9724, -7295.9053, 3399.0671);
	angles[36] = (0, -305.4015, 0);
	at[36] = 18.4167;
	points[37] = (-2536.2598, -7077.2837, 3399.0671);
	angles[37] = (0, -308.3600, 0);
	at[37] = 18.8500;
	points[38] = (-2666.9883, -6958.9761, 3399.0671);
	angles[38] = (0, -312.1924, 0);
	at[38] = 19.0667;
	points[39] = (-2791.8467, -6834.1343, 3399.0671);
	angles[39] = (0, -314.2863, 0);
	at[39] = 19.2833;
	points[40] = (-2913.5276, -6706.2993, 3399.0671);
	angles[40] = (0, -316.3956, 0);
	at[40] = 19.5000;
	points[41] = (-3030.8386, -6574.3311, 3399.0671);
	angles[41] = (0, -317.8654, 0);
	at[41] = 19.7167;
	points[42] = (-3137.7678, -6434.6460, 3399.0671);
	angles[42] = (0, -323.0579, 0);
	at[42] = 19.9333;
	points[43] = (-3319.8071, -6132.1260, 3399.0671);
	angles[43] = (0, -329.3311, 0);
	at[43] = 20.3667;
	points[44] = (-3483.1653, -5819.0156, 3399.0671);
	angles[44] = (0, -332.2458, 0);
	at[44] = 20.8000;
	points[45] = (-3619.1733, -5493.1099, 3399.0671);
	angles[45] = (0, -337.0482, 0);
	at[45] = 21.2333;
	points[46] = (-3733.1104, -5158.9370, 3399.0671);
	angles[46] = (0, -341.2097, 0);
	at[46] = 21.6667;
	points[47] = (-3777.6968, -4988.2681, 3399.0671);
	angles[47] = (0, -345.0169, 0);
	at[47] = 21.8833;
	points[48] = (-3817.3977, -4816.2207, 3399.0671);
	angles[48] = (0, -346.4999, 0);
	at[48] = 22.1000;
	points[49] = (-3844.9016, -4642.2837, 3399.0671);
	angles[49] = (0, -351.3559, 0);
	at[49] = 22.3167;
	points[50] = (-3868.1104, -4290.0396, 3399.0630);
	angles[50] = (0, -356.8387, 0);
	at[50] = 22.7500;
	points[51] = (-3868.1104, -3760.2991, 3399.0671);
	angles[51] = (0, -359.9481, 0);
	at[51] = 23.4000;
	points[52] = (-3868.1104, 4185.5117, 3399.0671);
	angles[52] = (0, -360, 0);
	at[52] = 33.1500;
	points[53] = (-3864.3977, 4361.9688, 3399.0671);
	angles[53] = (0, -361.4459, 0);
	at[53] = 33.3667;
	points[54] = (-3838.4963, 4714.1733, 3399.0671);
	angles[54] = (0, -364.9431, 0);
	at[54] = 33.8000;
	points[55] = (-3797.4133, 4885.9053, 3399.0671);
	angles[55] = (0, -371.2406, 0);
	at[55] = 34.0167;
	points[56] = (-3756.5198, 5057.6772, 3399.0671);
	angles[56] = (0, -372.8444, 0);
	at[56] = 34.2333;
	points[57] = (-3649.0986, 5394.0156, 3399.0671);
	angles[57] = (0, -377.6769, 0);
	at[57] = 34.6667;
	points[58] = (-3587.2124, 5559.2910, 3399.0671);
	angles[58] = (0, -380.1601, 0);
	at[58] = 34.8833;
	points[59] = (-3522.0906, 5723.4253, 3399.0671);
	angles[59] = (0, -381.2653, 0);
	at[59] = 35.1000;
	points[60] = (-3448.2244, 5883.3862, 3399.0671);
	angles[60] = (0, -385.0573, 0);
	at[60] = 35.3167;
	points[61] = (-3362.2324, 6037.6382, 3399.0671);
	angles[61] = (0, -388.1042, 0);
	at[61] = 35.5333;
	points[62] = (-3271.9016, 6189.2124, 3399.0671);
	angles[62] = (0, -390.7631, 0);
	at[62] = 35.7500;
	points[63] = (-3173.8110, 6336.0234, 3399.0671);
	angles[63] = (0, -392.9881, 0);
	at[63] = 35.9667;
	points[64] = (-3072.2561, 6480.2754, 3399.0630);
	angles[64] = (0, -395.4664, 0);
	at[64] = 36.1833;
	points[65] = (-2847.2285, 6752.3623, 3399.0671);
	angles[65] = (0, -399.8176, 0);
	at[65] = 36.6167;
	points[66] = (-2605.1221, 7009.4883, 3399.0671);
	angles[66] = (0, -403.0560, 0);
	at[66] = 37.0500;
	points[67] = (-2469.9646, 7122.9922, 3399.0671);
	angles[67] = (0, -408.5056, 0);
	at[67] = 37.2667;
	points[68] = (-2333.9805, 7235.6304, 3399.0671);
	angles[68] = (0, -409.8926, 0);
	at[68] = 37.4833;
	points[69] = (-2186.9883, 7332.9136, 3399.0671);
	angles[69] = (0, -415.6797, 0);
	at[69] = 37.7000;
	points[70] = (-2036.7717, 7425.7480, 3399.0671);
	angles[70] = (0, -417.6266, 0);
	at[70] = 37.9167;
	points[71] = (-1880.7716, 7507.8740, 3399.0630);
	angles[71] = (0, -421.7893, 0);
	at[71] = 38.1333;
	points[72] = (-1560.0236, 7655.5117, 3399.0671);
	angles[72] = (0, -425.8682, 0);
	at[72] = 38.5667;
	points[73] = (-1232.8229, 7788.1895, 3399.0671);
	angles[73] = (0, -428.3387, 0);
	at[73] = 39;
	points[74] = (-1066.0315, 7846.1812, 3399.0671);
	angles[74] = (0, -430.2009, 0);
	at[74] = 39.2167;
	points[75] = (-897.4685, 7897.5596, 3399.0671);
	angles[75] = (0, -433.4459, 0);
	at[75] = 39.4333;
	points[76] = (-550.9134, 7965.5122, 3399.0671);
	angles[76] = (0, -439.0287, 0);
	at[76] = 39.8667;
	points[77] = (-199.8012, 8003.7012, 3399.0671);
	angles[77] = (0, -443.3531, 0);
	at[77] = 40.3000;
	points[78] = (-23.5502, 8008.7798, 3399.0671);
	angles[78] = (0, -447.9286, 0);
	at[78] = 40.5167;
	points[79] = (153.0213, 8007.7563, 3399.0671);
	angles[79] = (0, -449.7255, 0);
	at[79] = 40.7333;
	points[80] = (328.7992, 7993.4644, 3399.0671);
	angles[80] = (0, -454.2096, 0);
	at[80] = 40.9500;
	points[81] = (504.2323, 7973.3862, 3399.0671);
	angles[81] = (0, -455.9357, 0);
	at[81] = 41.1667;
	points[82] = (678.5906, 7946.3779, 3399.0671);
	angles[82] = (0, -458.7175, 0);
	at[82] = 41.3833;
	points[83] = (851.9095, 7912.6382, 3399.0671);
	angles[83] = (0, -460.4323, 0);
	at[83] = 41.6000;
	points[84] = (1023.1418, 7870.5513, 3399.0671);
	angles[84] = (0, -464.0162, 0);
	at[84] = 41.8167;
	points[85] = (1191.9489, 7818.7397, 3399.0671);
	angles[85] = (0, -466.2822, 0);
	at[85] = 42.0333;
	points[86] = (1357.9567, 7759.5273, 3399.0671);
	angles[86] = (0, -469.7606, 0);
	at[86] = 42.2500;
	points[87] = (1680.0198, 7614.6460, 3399.0671);
	angles[87] = (0, -474.0936, 0);
	at[87] = 42.6833;
	points[88] = (2000.1102, 7465.4727, 3399.0671);
	angles[88] = (0, -474.9308, 0);
	at[88] = 43.1167;
	points[89] = (2146.3740, 7366.7324, 3399.0671);
	angles[89] = (0, -482.0467, 0);
	at[89] = 43.3333;
	points[90] = (2291.9331, 7266.7720, 3399.0671);
	angles[90] = (0, -483.8597, 0);
	at[90] = 43.5500;
	points[91] = (2570.1260, 7049.2915, 3399.0671);
	angles[91] = (0, -487.8564, 0);
	at[91] = 43.9833;
	points[92] = (2697.4919, 6927.2837, 3399.0671);
	angles[92] = (0, -492.9084, 0);
	at[92] = 44.2000;
	points[93] = (2821.9214, 6802.0078, 3399.0671);
	angles[93] = (0, -494.6143, 0);
	at[93] = 44.4167;
	points[94] = (2938.0552, 6669.2520, 3399.0671);
	angles[94] = (0, -498.4104, 0);
	at[94] = 44.6333;
	points[95] = (3049.9253, 6532.6377, 3399.0671);
	angles[95] = (0, -500.1085, 0);
	at[95] = 44.8500;
	points[96] = (3154.4844, 6390.5908, 3399.0671);
	angles[96] = (0, -503.6065, 0);
	at[96] = 45.0667;
	points[97] = (3253.0354, 6244.0552, 3399.0671);
	angles[97] = (0, -505.4465, 0);
	at[97] = 45.2833;
	points[98] = (3342.8267, 6092.4409, 3399.0671);
	angles[98] = (0, -509.3279, 0);
	at[98] = 45.5000;
	points[99] = (3498.4883, 5775.5513, 3399.0671);
	angles[99] = (0, -514.3042, 0);
	at[99] = 45.9333;
	points[100] = (3631.9685, 5448.5825, 3399.0671);
	angles[100] = (0, -517.8427, 0);
	at[100] = 46.3667;
	points[101] = (3749.5513, 5115.5908, 3399.0671);
	angles[101] = (0, -520.3752, 0);
	at[101] = 46.8000;
	points[102] = (3827.3582, 4771.1416, 3399.0671);
	angles[102] = (0, -526.8499, 0);
	at[102] = 47.2333;
	points[103] = (3841.0986, 4595.8267, 3399.0671);
	angles[103] = (0, -534.6983, 0);
	at[103] = 47.4500;
	points[104] = (3848.1733, 4242.7559, 3399.0671);
	angles[104] = (0, -538.5834, 0);
	at[104] = 47.8833;
	points[105] = (3868.1104, 3183.5078, 3399.0671);
	angles[105] = (0, -539.3220, 0);
	at[105] = 49.1833;
	points[106] = (3868.1104, 2477.2087, 3399.0671);
	angles[106] = (0, -539.9971, 0);
	at[106] = 50.0500;
	points[107] = (3868.1104, 2343.7952, 3399.0671);
	angles[107] = (0, -540, 0);
	at[107] = 50.2167;
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
	points[0] = (3868.1104, 1900.8818, 3399.0671);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (3868.1104, -4279.2129, 3399.0671);
	angles[1] = (0, -180, 0);
	at[1] = 7.5833;
	points[2] = (3859.2715, -4455.4727, 3399.0671);
	angles[2] = (0, -182.6940, 0);
	at[2] = 7.8000;
	points[3] = (3845.7285, -4631.5356, 3399.0671);
	angles[3] = (0, -183.9653, 0);
	at[3] = 8.0167;
	points[4] = (3819.8267, -4805.6694, 3399.0671);
	angles[4] = (0, -188.7676, 0);
	at[4] = 8.2333;
	points[5] = (3780.1221, -4977.7559, 3399.0671);
	angles[5] = (0, -191.9197, 0);
	at[5] = 8.4500;
	points[6] = (3736.5237, -5148.7007, 3399.0671);
	angles[6] = (0, -194.5906, 0);
	at[6] = 8.6667;
	points[7] = (3623.3269, -5483.1499, 3399.0671);
	angles[7] = (0, -198.9811, 0);
	at[7] = 9.1000;
	points[8] = (3487.5000, -5809.1338, 3399.0671);
	angles[8] = (0, -202.3847, 0);
	at[8] = 9.5333;
	points[9] = (3324.8030, -6122.5591, 3399.0671);
	angles[9] = (0, -207.2187, 0);
	at[9] = 9.9667;
	points[10] = (3143.3821, -6425.4331, 3399.0671);
	angles[10] = (0, -211.0058, 0);
	at[10] = 10.4000;
	points[11] = (3038.0117, -6566.2603, 3399.0671);
	angles[11] = (0, -216.6136, 0);
	at[11] = 10.6167;
	points[12] = (2920.7007, -6698.2280, 3399.0671);
	angles[12] = (0, -220.3569, 0);
	at[12] = 10.8333;
	points[13] = (2799.4802, -6826.4966, 3399.0671);
	angles[13] = (0, -223.0648, 0);
	at[13] = 11.0500;
	points[14] = (2674.6221, -6951.3779, 3399.0671);
	angles[14] = (0, -224.5081, 0);
	at[14] = 11.2667;
	points[15] = (2544.6890, -7070.5513, 3399.0671);
	angles[15] = (0, -227.8435, 0);
	at[15] = 11.4833;
	points[16] = (2406.8071, -7180.8662, 3399.0671);
	angles[16] = (0, -230.4511, 0);
	at[16] = 11.7000;
	points[17] = (2268.0867, -7290.0786, 3399.0630);
	angles[17] = (0, -231.7297, 0);
	at[17] = 11.9167;
	points[18] = (2126.8269, -7396.0234, 3399.0671);
	angles[18] = (0, -232.7741, 0);
	at[18] = 12.1333;
	points[19] = (1983.3583, -7498.5044, 3399.0671);
	angles[19] = (0, -235.3187, 0);
	at[19] = 12.3500;
	points[20] = (1672.8347, -7666.7324, 3399.0671);
	angles[20] = (0, -241.1536, 0);
	at[20] = 12.7833;
	points[21] = (1347.8112, -7804.5669, 3399.0671);
	angles[21] = (0, -246.9356, 0);
	at[21] = 13.2167;
	points[22] = (1180.2441, -7859.4883, 3399.0671);
	angles[22] = (0, -251.4074, 0);
	at[22] = 13.4333;
	points[23] = (1010.7323, -7908.9370, 3399.0671);
	angles[23] = (0, -253.1469, 0);
	at[23] = 13.6500;
	points[24] = (838.3701, -7945.9058, 3399.0671);
	angles[24] = (0, -257.4579, 0);
	at[24] = 13.8667;
	points[25] = (664.1968, -7974.9214, 3399.0671);
	angles[25] = (0, -259.7546, 0);
	at[25] = 14.0833;
	points[26] = (488.9646, -7995.3149, 3399.0671);
	angles[26] = (0, -263.1216, 0);
	at[26] = 14.3000;
	points[27] = (-39.0736, -8037.5596, 3399.0671);
	angles[27] = (0, -265.3882, 0);
	at[27] = 14.9500;
	points[28] = (-214.9165, -8039.0552, 3399.0671);
	angles[28] = (0, -269.7838, 0);
	at[28] = 15.1667;
	points[29] = (-566.0551, -8001.4170, 3399.0671);
	angles[29] = (0, -276.3925, 0);
	at[29] = 15.6000;
	points[30] = (-910.0630, -7921.4170, 3399.0671);
	angles[30] = (0, -282.5676, 0);
	at[30] = 16.0333;
	points[31] = (-1251.1102, -7829.8818, 3399.0671);
	angles[31] = (0, -285.0471, 0);
	at[31] = 16.4667;
	points[32] = (-1577.8977, -7696.3784, 3399.0671);
	angles[32] = (0, -292.0771, 0);
	at[32] = 16.9000;
	points[33] = (-1737.2638, -7620.5513, 3399.0671);
	angles[33] = (0, -295.0509, 0);
	at[33] = 17.1167;
	points[34] = (-1895.1969, -7541.5747, 3399.0671);
	angles[34] = (0, -296.1802, 0);
	at[34] = 17.3333;
	points[35] = (-2045.9646, -7450.8271, 3399.0671);
	angles[35] = (0, -301.3966, 0);
	at[35] = 17.5500;
	points[36] = (-2330.5906, -7241.8110, 3399.0671);
	angles[36] = (0, -306.4413, 0);
	at[36] = 17.9833;
	points[37] = (-2606.3545, -7021.2207, 3399.0671);
	angles[37] = (0, -309.1494, 0);
	at[37] = 18.4167;
	points[38] = (-2855.3188, -6770.6694, 3399.0671);
	angles[38] = (0, -314.6218, 0);
	at[38] = 18.8500;
	points[39] = (-3090.4724, -6507.2051, 3399.0671);
	angles[39] = (0, -318.1245, 0);
	at[39] = 19.2833;
	points[40] = (-3184.4412, -6357.9922, 3399.0671);
	angles[40] = (0, -325.6929, 0);
	at[40] = 19.5000;
	points[41] = (-3276.2480, -6207.1655, 3399.0671);
	angles[41] = (0, -327.9141, 0);
	at[41] = 19.7167;
	points[42] = (-3443.0078, -5895.9844, 3399.0671);
	angles[42] = (0, -332.0264, 0);
	at[42] = 20.1500;
	points[43] = (-3517.8701, -5736.2603, 3399.0671);
	angles[43] = (0, -334.9126, 0);
	at[43] = 20.3667;
	points[44] = (-3585.7837, -5573.2681, 3399.0671);
	angles[44] = (0, -336.7529, 0);
	at[44] = 20.5833;
	points[45] = (-3649.8188, -5408.8188, 3399.0630);
	angles[45] = (0, -338.9338, 0);
	at[45] = 20.8000;
	points[46] = (-3705.6577, -5241.2993, 3399.0671);
	angles[46] = (0, -340.8961, 0);
	at[46] = 21.0167;
	points[47] = (-3758.1733, -5072.8350, 3399.0671);
	angles[47] = (0, -342.8681, 0);
	at[47] = 21.2333;
	points[48] = (-3837.5828, -4728.7402, 3399.0671);
	angles[48] = (0, -346.7380, 0);
	at[48] = 21.6667;
	points[49] = (-3851.7834, -4552.7954, 3399.0671);
	angles[49] = (0, -353.3448, 0);
	at[49] = 21.8833;
	points[50] = (-3865.3267, -4376.7324, 3399.0671);
	angles[50] = (0, -355.0276, 0);
	at[50] = 22.1000;
	points[51] = (-3868.1104, -3847.1101, 3399.0671);
	angles[51] = (0, -359.9013, 0);
	at[51] = 22.7500;
	points[52] = (-3868.1104, 4275.2759, 3399.0671);
	angles[52] = (0, -360, 0);
	at[52] = 32.7167;
	points[53] = (-3844.8623, 4627.5986, 3399.0671);
	angles[53] = (0, -363.8704, 0);
	at[53] = 33.1500;
	points[54] = (-3817.5195, 4801.4565, 3399.0671);
	angles[54] = (0, -368.9061, 0);
	at[54] = 33.3667;
	points[55] = (-3776.6221, 4973.2285, 3399.0671);
	angles[55] = (0, -372.2505, 0);
	at[55] = 33.5833;
	points[56] = (-3730.8701, 5143.6221, 3399.0671);
	angles[56] = (0, -375.0231, 0);
	at[56] = 33.8000;
	points[57] = (-3619.2283, 5478.6221, 3399.0671);
	angles[57] = (0, -378.8521, 0);
	at[57] = 34.2333;
	points[58] = (-3488.9844, 5806.8506, 3399.0671);
	angles[58] = (0, -381.4619, 0);
	at[58] = 34.6667;
	points[59] = (-3404.5081, 5961.8110, 3399.0671);
	angles[59] = (0, -387.1883, 0);
	at[59] = 34.8833;
	points[60] = (-3318.5195, 6116.0239, 3399.0671);
	angles[60] = (0, -388.6462, 0);
	at[60] = 35.1000;
	points[61] = (-3123.9448, 6410.6689, 3399.0671);
	angles[61] = (0, -393.3838, 0);
	at[61] = 35.5333;
	points[62] = (-3015.3857, 6549.7246, 3399.0671);
	angles[62] = (0, -397.2786, 0);
	at[62] = 35.7500;
	points[63] = (-2903.5156, 6686.3384, 3399.0671);
	angles[63] = (0, -398.7957, 0);
	at[63] = 35.9667;
	points[64] = (-2785.6890, 6817.7163, 3399.0671);
	angles[64] = (0, -401.6109, 0);
	at[64] = 36.1833;
	points[65] = (-2664.6379, 6946.2598, 3399.0671);
	angles[65] = (0, -402.8555, 0);
	at[65] = 36.4000;
	points[66] = (-2536.8191, 7067.5986, 3399.0671);
	angles[66] = (0, -406.4888, 0);
	at[66] = 36.6167;
	points[67] = (-2400.8347, 7180.2363, 3399.0671);
	angles[67] = (0, -409.3798, 0);
	at[67] = 36.8333;
	points[68] = (-2260.8425, 7287.2837, 3399.0671);
	angles[68] = (0, -412.8356, 0);
	at[68] = 37.0500;
	points[69] = (-1959.2797, 7470.8271, 3399.0630);
	angles[69] = (0, -419.1601, 0);
	at[69] = 37.4833;
	points[70] = (-1639.9135, 7621.5747, 3399.0671);
	angles[70] = (0, -424.3738, 0);
	at[70] = 37.9167;
	points[71] = (-1313.8503, 7757.1655, 3399.0671);
	angles[71] = (0, -427.3347, 0);
	at[71] = 38.3500;
	points[72] = (-981.2441, 7875.6299, 3399.0671);
	angles[72] = (0, -430.5308, 0);
	at[72] = 38.7833;
	points[73] = (-809.3819, 7914.8428, 3399.0671);
	angles[73] = (0, -436.2940, 0);
	at[73] = 39;
	points[74] = (-636.1024, 7948.8188, 3399.0671);
	angles[74] = (0, -438.2435, 0);
	at[74] = 39.2167;
	points[75] = (-461.5709, 7974.6060, 3399.0671);
	angles[75] = (0, -441.4400, 0);
	at[75] = 39.4333;
	points[76] = (-286.0795, 7994.1338, 3399.0671);
	angles[76] = (0, -443.0897, 0);
	at[76] = 39.6500;
	points[77] = (-110.3594, 8009.2915, 3399.0671);
	angles[77] = (0, -445.3185, 0);
	at[77] = 39.8667;
	points[78] = (242.5508, 8003.3467, 3399.0671);
	angles[78] = (0, -451.6879, 0);
	at[78] = 40.3000;
	points[79] = (593.4134, 7963.1890, 3399.0671);
	angles[79] = (0, -456.6603, 0);
	at[79] = 40.7333;
	points[80] = (940.0197, 7895.5122, 3399.0671);
	angles[80] = (0, -460.7352, 0);
	at[80] = 41.1667;
	points[81] = (1277.7677, 7792.4409, 3399.0671);
	angles[81] = (0, -466.6459, 0);
	at[81] = 41.6000;
	points[82] = (1600.9843, 7650.5513, 3399.0671);
	angles[82] = (0, -473.6135, 0);
	at[82] = 42.0333;
	points[83] = (1921.4291, 7502.1260, 3399.0671);
	angles[83] = (0, -474.8714, 0);
	at[83] = 42.4667;
	points[84] = (2074.8110, 7415.8667, 3399.0671);
	angles[84] = (0, -479.3980, 0);
	at[84] = 42.6833;
	points[85] = (2220.3701, 7315.9058, 3399.0671);
	angles[85] = (0, -483.1859, 0);
	at[85] = 42.9000;
	points[86] = (2363.0315, 7212.0078, 3399.0671);
	angles[86] = (0, -485.8745, 0);
	at[86] = 43.1167;
	points[87] = (2501.8662, 7102.9136, 3399.0671);
	angles[87] = (0, -487.5797, 0);
	at[87] = 43.3333;
	points[88] = (2636.3152, 6988.8979, 3399.0671);
	angles[88] = (0, -490.4294, 0);
	at[88] = 43.5500;
	points[89] = (2883.0552, 6736.4170, 3399.0671);
	angles[89] = (0, -496.3743, 0);
	at[89] = 43.9833;
	points[90] = (3106.7952, 6463.1890, 3399.0671);
	angles[90] = (0, -500.9464, 0);
	at[90] = 44.4167;
	points[91] = (3303.1338, 6169.5669, 3399.0671);
	angles[91] = (0, -505.7422, 0);
	at[91] = 44.8500;
	points[92] = (3383.0669, 6012.2051, 3399.0671);
	angles[92] = (0, -511.4265, 0);
	at[92] = 45.0667;
	points[93] = (3462.2244, 5854.3701, 3399.0671);
	angles[93] = (0, -512.8734, 0);
	at[93] = 45.2833;
	points[94] = (3532.4172, 5692.4409, 3399.0671);
	angles[94] = (0, -516.1232, 0);
	at[94] = 45.5000;
	points[95] = (3599.1577, 5528.9766, 3399.0671);
	angles[95] = (0, -517.3681, 0);
	at[95] = 45.7167;
	points[96] = (3661.8467, 5363.9370, 3399.0671);
	angles[96] = (0, -519.1230, 0);
	at[96] = 45.9333;
	points[97] = (3720.6458, 5197.4409, 3399.0671);
	angles[97] = (0, -520.1873, 0);
	at[97] = 46.1500;
	points[98] = (3769.4409, 5028.0708, 3399.0671);
	angles[98] = (0, -523.9753, 0);
	at[98] = 46.3667;
	points[99] = (3808.2678, 4855.8267, 3399.0671);
	angles[99] = (0, -526.4529, 0);
	at[99] = 46.5833;
	points[100] = (3839.3584, 4682.6382, 3399.0671);
	angles[100] = (0, -530.2019, 0);
	at[100] = 46.8000;
	points[101] = (3842.8975, 4506.1025, 3399.0671);
	angles[101] = (0, -536.6498, 0);
	at[101] = 47.0167;
	points[102] = (3846.4331, 4329.5669, 3399.0671);
	angles[102] = (0, -538.2921, 0);
	at[102] = 47.2333;
	points[103] = (3867.6655, 3270.3152, 3399.0671);
	angles[103] = (0, -538.8517, 0);
	at[103] = 48.5333;
	points[104] = (3868.1104, 2034.2953, 3399.0671);
	angles[104] = (0, -540, 0);
	at[104] = 50.0500;
	points[105] = (3868.1104, 1900.8818, 3399.0671);
	angles[105] = (0, -540, 0);
	at[105] = 50.2167;
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
	points[0] = (3868.1104, 1457.9685, 3399.0671);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (3868.1104, -4192.4014, 3399.0671);
	angles[1] = (0, -180, 0);
	at[1] = 6.9333;
	points[2] = (3865.9292, -4368.8979, 3399.0671);
	angles[2] = (0, -181.1914, 0);
	at[2] = 7.1500;
	points[3] = (3838.8425, -4721.0239, 3399.0671);
	angles[3] = (0, -184.1914, 0);
	at[3] = 7.5833;
	points[4] = (3799.6418, -4893.1499, 3399.0671);
	angles[4] = (0, -190.7535, 0);
	at[4] = 7.8000;
	points[5] = (3759.9373, -5065.1973, 3399.0671);
	angles[5] = (0, -192.4249, 0);
	at[5] = 8.0167;
	points[6] = (3708.1377, -5233.8584, 3399.0671);
	angles[6] = (0, -196.3919, 0);
	at[6] = 8.2333;
	points[7] = (3652.2993, -5401.3784, 3399.0671);
	angles[7] = (0, -197.9156, 0);
	at[7] = 8.4500;
	points[8] = (3588.8032, -5566.0234, 3399.0671);
	angles[8] = (0, -200.8658, 0);
	at[8] = 8.6667;
	points[9] = (3520.8899, -5729.0156, 3399.0671);
	angles[9] = (0, -202.1740, 0);
	at[9] = 8.8833;
	points[10] = (3446.6340, -5889.0156, 3399.0671);
	angles[10] = (0, -204.8167, 0);
	at[10] = 9.1000;
	points[11] = (3364.9568, -6045.5903, 3399.0671);
	angles[11] = (0, -206.8572, 0);
	at[11] = 9.3167;
	points[12] = (3280.3267, -6200.4727, 3399.0630);
	angles[12] = (0, -208.6740, 0);
	at[12] = 9.5333;
	points[13] = (3096.7087, -6502.1265, 3399.0671);
	angles[13] = (0, -212.1835, 0);
	at[13] = 9.9667;
	points[14] = (2978.3743, -6633.3467, 3399.0671);
	angles[14] = (0, -219.2272, 0);
	at[14] = 10.1833;
	points[15] = (2861.0669, -6765.3154, 3399.0671);
	angles[15] = (0, -221.3582, 0);
	at[15] = 10.4000;
	points[16] = (2611.1494, -7014.8428, 3399.0671);
	angles[16] = (0, -224.7646, 0);
	at[16] = 10.8333;
	points[17] = (2336.7126, -7236.9287, 3399.0671);
	angles[17] = (0, -230.8694, 0);
	at[17] = 11.2667;
	points[18] = (2055.0156, -7449.8823, 3399.0671);
	angles[18] = (0, -232.9410, 0);
	at[18] = 11.7000;
	points[19] = (1904.4292, -7541.2603, 3399.0671);
	angles[19] = (0, -238.2398, 0);
	at[19] = 11.9167;
	points[20] = (1749.1694, -7625.3545, 3399.0671);
	angles[20] = (0, -240.7136, 0);
	at[20] = 12.1333;
	points[21] = (1590.9371, -7703.2676, 3399.0671);
	angles[21] = (0, -243.7253, 0);
	at[21] = 12.3500;
	points[22] = (1427.9448, -7771.1812, 3399.0671);
	angles[22] = (0, -246.4509, 0);
	at[22] = 12.5667;
	points[23] = (1263.5828, -7835.1973, 3399.0671);
	angles[23] = (0, -248.8652, 0);
	at[23] = 12.7833;
	points[24] = (924, -7931.6143, 3399.0671);
	angles[24] = (0, -254.7141, 0);
	at[24] = 13.2167;
	points[25] = (575.5000, -7988.4253, 3399.0671);
	angles[25] = (0, -261.0891, 0);
	at[25] = 13.6500;
	points[26] = (399.4843, -8002.4805, 3399.0671);
	angles[26] = (0, -264.3233, 0);
	at[26] = 13.8667;
	points[27] = (-128.5520, -8044.7246, 3399.0671);
	angles[27] = (0, -265.4079, 0);
	at[27] = 14.5167;
	points[28] = (-304.1697, -8029.4883, 3399.0671);
	angles[28] = (0, -273.0850, 0);
	at[28] = 14.7333;
	points[29] = (-479.7402, -8010.6689, 3399.0671);
	angles[29] = (0, -275.3450, 0);
	at[29] = 14.9500;
	points[30] = (-653.4213, -7980.6299, 3399.0671);
	angles[30] = (0, -279.5054, 0);
	at[30] = 15.1667;
	points[31] = (-997.0079, -7899.1738, 3399.0671);
	angles[31] = (0, -283.5464, 0);
	at[31] = 15.6000;
	points[32] = (-1167.3583, -7852.7168, 3399.0671);
	angles[32] = (0, -284.8207, 0);
	at[32] = 15.8167;
	points[33] = (-1334.7716, -7797.6772, 3399.0671);
	angles[33] = (0, -288.5920, 0);
	at[33] = 16.0333;
	points[34] = (-1659.6182, -7659.3701, 3399.0671);
	angles[34] = (0, -293.4280, 0);
	at[34] = 16.4667;
	points[35] = (-1975.4843, -7501.4170, 3399.0671);
	angles[35] = (0, -296.3624, 0);
	at[35] = 16.9000;
	points[36] = (-2118.5591, -7398.0317, 3399.0671);
	angles[36] = (0, -303.5660, 0);
	at[36] = 17.1167;
	points[37] = (-2261.3621, -7294.1733, 3399.0671);
	angles[37] = (0, -305.4016, 0);
	at[37] = 17.3333;
	points[38] = (-2538.5669, -7075.4331, 3399.0671);
	angles[38] = (0, -308.3860, 0);
	at[38] = 17.7667;
	points[39] = (-2669.0789, -6956.8901, 3399.0671);
	angles[39] = (0, -312.1991, 0);
	at[39] = 17.9833;
	points[40] = (-2793.9373, -6832.0474, 3399.0671);
	angles[40] = (0, -314.2879, 0);
	at[40] = 18.2000;
	points[41] = (-2915.4919, -6704.0942, 3399.0671);
	angles[41] = (0, -316.3961, 0);
	at[41] = 18.4167;
	points[42] = (-3032.7991, -6572.0869, 3399.0671);
	angles[42] = (0, -317.8655, 0);
	at[42] = 18.6333;
	points[43] = (-3139.3030, -6432.1265, 3399.0630);
	angles[43] = (0, -323.0579, 0);
	at[43] = 18.8500;
	points[44] = (-3321.1733, -6129.4883, 3399.0671);
	angles[44] = (0, -329.3311, 0);
	at[44] = 19.2833;
	points[45] = (-3484.5278, -5816.3779, 3399.0671);
	angles[45] = (0, -332.7386, 0);
	at[45] = 19.7167;
	points[46] = (-3620.3110, -5490.3936, 3399.0671);
	angles[46] = (0, -337.0801, 0);
	at[46] = 20.1500;
	points[47] = (-3734.0435, -5156.1421, 3399.0671);
	angles[47] = (0, -341.2117, 0);
	at[47] = 20.5833;
	points[48] = (-3778.3582, -4985.3936, 3399.0671);
	angles[48] = (0, -345.0175, 0);
	at[48] = 20.8000;
	points[49] = (-3818.0630, -4813.3071, 3399.0671);
	angles[49] = (0, -346.5001, 0);
	at[49] = 21.0167;
	points[50] = (-3845.1260, -4639.3306, 3399.0671);
	angles[50] = (0, -351.3559, 0);
	at[50] = 21.2333;
	points[51] = (-3858.6694, -4463.2676, 3399.0671);
	angles[51] = (0, -354.5218, 0);
	at[51] = 21.4500;
	points[52] = (-3868.1104, -4287.0864, 3399.0671);
	angles[52] = (0, -356.8387, 0);
	at[52] = 21.6667;
	points[53] = (-3868.1104, -3757.3464, 3399.0671);
	angles[53] = (0, -359.9481, 0);
	at[53] = 22.3167;
	points[54] = (-3868.1104, 4188.4648, 3399.0671);
	angles[54] = (0, -360, 0);
	at[54] = 32.0667;
	points[55] = (-3864.1812, 4364.9214, 3399.0671);
	angles[55] = (0, -361.4459, 0);
	at[55] = 32.2833;
	points[56] = (-3838.2795, 4717.0869, 3399.0671);
	angles[56] = (0, -364.9431, 0);
	at[56] = 32.7167;
	points[57] = (-3796.7283, 4888.7798, 3399.0671);
	angles[57] = (0, -371.2406, 0);
	at[57] = 32.9333;
	points[58] = (-3755.8347, 5060.5508, 3399.0671);
	angles[58] = (0, -372.8444, 0);
	at[58] = 33.1500;
	points[59] = (-3648.1812, 5396.8110, 3399.0671);
	angles[59] = (0, -377.7144, 0);
	at[59] = 33.5833;
	points[60] = (-3586.1221, 5562.0474, 3399.0671);
	angles[60] = (0, -380.3075, 0);
	at[60] = 33.8000;
	points[61] = (-3521, 5726.1816, 3399.0671);
	angles[61] = (0, -381.3028, 0);
	at[61] = 34.0167;
	points[62] = (-3446.7876, 5885.9844, 3399.0671);
	angles[62] = (0, -385.0668, 0);
	at[62] = 34.2333;
	points[63] = (-3360.7952, 6040.1973, 3399.0671);
	angles[63] = (0, -388.1066, 0);
	at[63] = 34.4500;
	points[64] = (-3270.2637, 6191.6538, 3399.0671);
	angles[64] = (0, -390.7637, 0);
	at[64] = 34.6667;
	points[65] = (-3172.1692, 6338.4644, 3399.0671);
	angles[65] = (0, -392.9882, 0);
	at[65] = 34.8833;
	points[66] = (-3070.3821, 6482.5591, 3399.0671);
	angles[66] = (0, -395.4665, 0);
	at[66] = 35.1000;
	points[67] = (-2845.2048, 6754.5278, 3399.0671);
	angles[67] = (0, -400.1388, 0);
	at[67] = 35.5333;
	points[68] = (-2603.0984, 7011.6143, 3399.0671);
	angles[68] = (0, -403.0768, 0);
	at[68] = 35.9667;
	points[69] = (-2467.6890, 7124.8818, 3399.0671);
	angles[69] = (0, -408.5108, 0);
	at[69] = 36.1833;
	points[70] = (-2331.7048, 7237.5195, 3399.0671);
	angles[70] = (0, -409.8939, 0);
	at[70] = 36.4000;
	points[71] = (-2184.4763, 7334.4883, 3399.0671);
	angles[71] = (0, -415.6801, 0);
	at[71] = 36.6167;
	points[72] = (-2034.2599, 7427.2837, 3399.0671);
	angles[72] = (0, -417.6267, 0);
	at[72] = 36.8333;
	points[73] = (-1878.1024, 7509.1338, 3399.0671);
	angles[73] = (0, -422.0669, 0);
	at[73] = 37.0500;
	points[74] = (-1557.2954, 7656.6143, 3399.0630);
	angles[74] = (0, -425.8860, 0);
	at[74] = 37.4833;
	points[75] = (-1230.0315, 7789.1733, 3399.0671);
	angles[75] = (0, -428.5786, 0);
	at[75] = 37.9167;
	points[76] = (-1063.2440, 7847.1260, 3399.0671);
	angles[76] = (0, -430.2620, 0);
	at[76] = 38.1333;
	points[77] = (-894.5709, 7898.1499, 3399.0671);
	angles[77] = (0, -433.4615, 0);
	at[77] = 38.3500;
	points[78] = (-548.0157, 7966.0630, 3399.0671);
	angles[78] = (0, -439.0298, 0);
	at[78] = 38.7833;
	points[79] = (-196.8661, 8004.0552, 3399.0671);
	angles[79] = (0, -443.3531, 0);
	at[79] = 39.2167;
	points[80] = (-20.5974, 8008.7798, 3399.0671);
	angles[80] = (0, -447.9286, 0);
	at[80] = 39.4333;
	points[81] = (155.9744, 8007.7163, 3399.0671);
	angles[81] = (0, -449.7255, 0);
	at[81] = 39.6500;
	points[82] = (331.7331, 7993.1099, 3399.0671);
	angles[82] = (0, -454.2096, 0);
	at[82] = 39.8667;
	points[83] = (507.1653, 7973.0713, 3399.0671);
	angles[83] = (0, -455.9357, 0);
	at[83] = 40.0833;
	points[84] = (681.4882, 7945.8271, 3399.0671);
	angles[84] = (0, -458.7175, 0);
	at[84] = 40.3000;
	points[85] = (854.8110, 7912.0864, 3399.0671);
	angles[85] = (0, -460.4323, 0);
	at[85] = 40.5167;
	points[86] = (1025.9646, 7869.6851, 3399.0671);
	angles[86] = (0, -464.0162, 0);
	at[86] = 40.7333;
	points[87] = (1194.7717, 7817.8745, 3399.0671);
	angles[87] = (0, -466.2822, 0);
	at[87] = 40.9500;
	points[88] = (1360.6497, 7758.3071, 3399.0671);
	angles[88] = (0, -469.7606, 0);
	at[88] = 41.1667;
	points[89] = (1682.6969, 7613.3862, 3399.0671);
	angles[89] = (0, -474.0936, 0);
	at[89] = 41.6000;
	points[90] = (2002.7875, 7464.2129, 3399.0671);
	angles[90] = (0, -474.9308, 0);
	at[90] = 42.0333;
	points[91] = (2148.8071, 7365.0396, 3399.0671);
	angles[91] = (0, -482.0467, 0);
	at[91] = 42.2500;
	points[92] = (2294.3662, 7265.0791, 3399.0671);
	angles[92] = (0, -483.8597, 0);
	at[92] = 42.4667;
	points[93] = (2572.4451, 7047.4414, 3399.0671);
	angles[93] = (0, -487.8830, 0);
	at[93] = 42.9000;
	points[94] = (2699.5708, 6925.1968, 3399.0671);
	angles[94] = (0, -492.9152, 0);
	at[94] = 43.1167;
	points[95] = (2824, 6799.9214, 3399.0671);
	angles[95] = (0, -494.6159, 0);
	at[95] = 43.3333;
	points[96] = (2939.9253, 6666.9688, 3399.0671);
	angles[96] = (0, -498.4108, 0);
	at[96] = 43.5500;
	points[97] = (3051.7954, 6530.3545, 3399.0671);
	angles[97] = (0, -500.1085, 0);
	at[97] = 43.7667;
	points[98] = (3156.1340, 6388.1104, 3399.0671);
	angles[98] = (0, -503.6065, 0);
	at[98] = 43.9833;
	points[99] = (3254.6851, 6241.6143, 3399.0671);
	angles[99] = (0, -505.4465, 0);
	at[99] = 44.2000;
	points[100] = (3344.1536, 6089.8032, 3399.0671);
	angles[100] = (0, -509.7155, 0);
	at[100] = 44.4167;
	points[101] = (3499.6062, 5772.8350, 3399.0671);
	angles[101] = (0, -514.3292, 0);
	at[101] = 44.8500;
	points[102] = (3633.0825, 5445.8662, 3399.0671);
	angles[102] = (0, -517.8442, 0);
	at[102] = 45.2833;
	points[103] = (3750.5356, 5112.7954, 3399.0671);
	angles[103] = (0, -521.0488, 0);
	at[103] = 45.7167;
	points[104] = (3828.0078, 4768.2676, 3399.0671);
	angles[104] = (0, -526.8934, 0);
	at[104] = 46.1500;
	points[105] = (3841.1575, 4592.8740, 3399.0671);
	angles[105] = (0, -534.7095, 0);
	at[105] = 46.3667;
	points[106] = (3848.2324, 4239.8032, 3399.0671);
	angles[106] = (0, -538.5841, 0);
	at[106] = 46.8000;
	points[107] = (3868.1104, 3180.5552, 3399.0671);
	angles[107] = (0, -539.3220, 0);
	at[107] = 48.1000;
	points[108] = (3868.1104, 1591.3820, 3399.0671);
	angles[108] = (0, -540, 0);
	at[108] = 50.0500;
	points[109] = (3868.1104, 1457.9685, 3399.0671);
	angles[109] = (0, -540, 0);
	at[109] = 50.2167;
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
