main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_shy_guy_falls", 0);

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
	ambientPlay("iz_0_usgf", 2);
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
	level.iz_route[level.iz_route.size] = (1419, 4954, 3046);
	level.iz_route[level.iz_route.size] = (1120, 3637, 2994);
	level.iz_route[level.iz_route.size] = (825, 1583, 2916);
	level.iz_route[level.iz_route.size] = (824, 386, 2884);
	level.iz_route[level.iz_route.size] = (1237, -519, 2792);
	level.iz_route[level.iz_route.size] = (1896, -861, 2641);
	level.iz_route[level.iz_route.size] = (2811, -723, 2407);
	level.iz_route[level.iz_route.size] = (3847, -160, 2250);
	level.iz_route[level.iz_route.size] = (4826, 250, 2248);
	level.iz_route[level.iz_route.size] = (5568, -50, 2179);
	level.iz_route[level.iz_route.size] = (5840, -888, 1894);
	level.iz_route[level.iz_route.size] = (5532, -2025, 1514);
	level.iz_route[level.iz_route.size] = (4705, -3030, 1334);
	level.iz_route[level.iz_route.size] = (3496, -3475, 1110);
	level.iz_route[level.iz_route.size] = (1754, -3635, 820);
	level.iz_route[level.iz_route.size] = (605, -3735, 772);
	level.iz_route[level.iz_route.size] = (-2969, -3755, 502);
	level.iz_route[level.iz_route.size] = (-3830, -3755, 505);
	level.iz_route[level.iz_route.size] = (-4342, -4034, 508);
	level.iz_route[level.iz_route.size] = (-4703, -4709, 502);
	level.iz_route[level.iz_route.size] = (-4762, -5618, 591);
	level.iz_route[level.iz_route.size] = (-4808, -6721, 736);
	level.iz_route[level.iz_route.size] = (-4787, -7875, 1060);
	level.iz_route[level.iz_route.size] = (-4790, -9442, 1616);
	level.iz_route[level.iz_route.size] = (-4729, -10845, 2203);
	level.iz_route[level.iz_route.size] = (-4760, -12644, 2789);
	level.iz_route[level.iz_route.size] = (-4774, -14693, 3508);
	level.iz_route[level.iz_route.size] = (-4693, -15426, 3746);
	level.iz_route[level.iz_route.size] = (-4332, -15994, 3931);
	level.iz_route[level.iz_route.size] = (-3698, -16352, 4087);
	level.iz_route[level.iz_route.size] = (-3035, -16459, 4184);
	level.iz_route[level.iz_route.size] = (-2235, -16254, 4193);
	level.iz_route[level.iz_route.size] = (-1699, -15771, 4110);
	level.iz_route[level.iz_route.size] = (-1498, -15024, 3971);
	level.iz_route[level.iz_route.size] = (-1225, -13453, 3483);
	level.iz_route[level.iz_route.size] = (-1216, -11999, 3322);
	level.iz_route[level.iz_route.size] = (-1245, -11124, 3253);
	level.iz_route[level.iz_route.size] = (-1243, -10580, 3304);
	level.iz_route[level.iz_route.size] = (-1232, -1023, 2493);
	level.iz_route[level.iz_route.size] = (-1364, 816, 2233);
	level.iz_route[level.iz_route.size] = (-2150, 2259, 2465);
	level.iz_route[level.iz_route.size] = (-3425, 3295, 2781);
	level.iz_route[level.iz_route.size] = (-3741, 3803, 2896);
	level.iz_route[level.iz_route.size] = (-3880, 4407, 3004);
	level.iz_route[level.iz_route.size] = (-3846, 5080, 3103);
	level.iz_route[level.iz_route.size] = (-3870, 5711, 3212);
	level.iz_route[level.iz_route.size] = (-4131, 6237, 3326);
	level.iz_route[level.iz_route.size] = (-4901, 7515, 3678);
	level.iz_route[level.iz_route.size] = (-5457, 8538, 4005);
	level.iz_route[level.iz_route.size] = (-5788, 9431, 4249);
	level.iz_route[level.iz_route.size] = (-5749, 9952, 4318);
	level.iz_route[level.iz_route.size] = (-5513, 10360, 4309);
	level.iz_route[level.iz_route.size] = (-5044, 10683, 4212);
	level.iz_route[level.iz_route.size] = (-4035, 10885, 3933);
	level.iz_route[level.iz_route.size] = (-2016, 11138, 3387);
	level.iz_route[level.iz_route.size] = (-1577, 11216, 3285);
	level.iz_route[level.iz_route.size] = (887, 11533, 2845);
	level.iz_route[level.iz_route.size] = (1807, 11387, 2923);
	level.iz_route[level.iz_route.size] = (2294, 10885, 2996);
	level.iz_route[level.iz_route.size] = (2348, 10206, 3012);
	level.iz_route[level.iz_route.size] = (2305, 9612, 3028);
	level.iz_route[level.iz_route.size] = (1975, 8078, 3056);
	level.iz_route[level.iz_route.size] = (1779, 6905, 3067);
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
	points[0] = (1322.3149, -9650.5117, 193.1587);
	angles[0] = (0, 47.5087, 0);
	at[0] = 0;
	points[1] = (1260.9016, -9594.6455, 282.4221);
	angles[1] = (0, 47.9062, 0);
	at[1] = 0.1333;
	points[2] = (1192.6300, -9533.3066, 381.9406);
	angles[2] = (0, 48.1819, 0);
	at[2] = 0.2667;
	points[3] = (1096.0118, -9447.2441, 523.1024);
	angles[3] = (0, 48.4157, 0);
	at[3] = 0.4667;
	points[4] = (995.0866, -9357.9131, 670.7874);
	angles[4] = (0, 48.5499, 0);
	at[4] = 0.6667;
	points[5] = (898.1221, -9272.4014, 812.7992);
	angles[5] = (0, 48.6130, 0);
	at[5] = 0.8667;
	points[6] = (798.1260, -9184.3311, 959.3032);
	angles[6] = (0, 48.6300, 0);
	at[6] = 1.0667;
	points[7] = (304.7607, -8747.4023, 1681.1456);
	angles[7] = (0, 48.1599, 0);
	at[7] = 2.0667;
	points[8] = (207.5752, -8660.0391, 1822.8110);
	angles[8] = (0, 47.9356, 0);
	at[8] = 2.2667;
	points[9] = (107.2150, -8569.0156, 1968.7638);
	angles[9] = (0, 47.6262, 0);
	at[9] = 2.4667;
	points[10] = (11.0348, -8480.6689, 2108.1851);
	angles[10] = (0, 47.2203, 0);
	at[10] = 2.6667;
	points[11] = (-57.2059, -8417.1260, 2206.7441);
	angles[11] = (0, 46.8329, 0);
	at[11] = 2.8000;
	points[12] = (-152.3854, -8326.7324, 2343.4844);
	angles[12] = (0, 46.0569, 0);
	at[12] = 3;
	points[13] = (-187.8500, -8292.3232, 2394.1379);
	angles[13] = (0, 45.6525, 0);
	at[13] = 3.0667;
	points[14] = (-221.2472, -8259.4092, 2441.6299);
	angles[14] = (0, 45.1787, 0);
	at[14] = 3.1333;
	points[15] = (-282.3453, -8197.4404, 2527.7993);
	angles[15] = (0, 43.9171, 0);
	at[15] = 3.2667;
	points[16] = (-318.9587, -8158.6611, 2578.7480);
	angles[16] = (0, 42.6869, 0);
	at[16] = 3.3333;
	points[17] = (-350.2504, -8123.7793, 2621.5867);
	angles[17] = (0, 40.9847, 0);
	at[17] = 3.4000;
	points[18] = (-377.3945, -8091.1816, 2657.7756);
	angles[18] = (0, 38.3274, 0);
	at[18] = 3.4667;
	points[19] = (-407.7598, -8050.4331, 2696.4055);
	angles[19] = (0, 35.2561, 0);
	at[19] = 3.5333;
	points[20] = (-438.6496, -8004.6455, 2733.7837);
	angles[20] = (0, 32.8625, 0);
	at[20] = 3.6000;
	points[21] = (-467.3976, -7958.5039, 2767.0471);
	angles[21] = (0, 31.0911, 0);
	at[21] = 3.6667;
	points[22] = (-524.3819, -7858.5039, 2829.2324);
	angles[22] = (0, 28.4401, 0);
	at[22] = 3.8000;
	points[23] = (-605.1063, -7700.4331, 2910.3188);
	angles[23] = (0, 25.8726, 0);
	at[23] = 4;
	points[24] = (-656.6851, -7591.0234, 2958.6377);
	angles[24] = (0, 24.6704, 0);
	at[24] = 4.1333;
	points[25] = (-706.7874, -7479.4097, 3003.4292);
	angles[25] = (0, 23.7174, 0);
	at[25] = 4.2667;
	points[26] = (-755.7756, -7365.7480, 3045.4961);
	angles[26] = (0, 22.9393, 0);
	at[26] = 4.4000;
	points[27] = (-827.0118, -7193.4253, 3104.2991);
	angles[27] = (0, 22.0216, 0);
	at[27] = 4.6000;
	points[28] = (-873.5315, -7076.9688, 3141.7402);
	angles[28] = (0, 21.5531, 0);
	at[28] = 4.7333;
	points[29] = (-895.4174, -7021.2993, 3159.3032);
	angles[29] = (0, 21.3802, 0);
	at[29] = 4.8000;
	points[30] = (-919.2520, -6960.1968, 3178.6143);
	angles[30] = (0, 21.2520, 0);
	at[30] = 4.8667;
	points[31] = (-963.5276, -6846.6934, 3216.7480);
	angles[31] = (0, 21.6457, 0);
	at[31] = 5;
	points[32] = (-983.1024, -6789.2129, 3236.3660);
	angles[32] = (0, 15.5230, 0);
	at[32] = 5.0667;
	points[33] = (-996.8740, -6727.7954, 3251.8660);
	angles[33] = (0, 10.0852, 0);
	at[33] = 5.1333;
	points[34] = (-1006.0630, -6664.6455, 3263.8662);
	angles[34] = (0, 6.8816, 0);
	at[34] = 5.2000;
	points[35] = (-1029.6732, -6473.7798, 3295.1653);
	angles[35] = (0, 9.8704, 0);
	at[35] = 5.4000;
	points[36] = (-1042.4213, -6411.7715, 3308.4604);
	angles[36] = (0, 13.4787, 0);
	at[36] = 5.4667;
	points[37] = (-1059.0906, -6351.5352, 3324.2717);
	angles[37] = (0, 17.5081, 0);
	at[37] = 5.5333;
	points[38] = (-1079.7756, -6293.2676, 3342.6890);
	angles[38] = (0, 21.5832, 0);
	at[38] = 5.6000;
	points[39] = (-1104.4607, -6236.6533, 3363.7637);
	angles[39] = (0, 25.4963, 0);
	at[39] = 5.6667;
	points[40] = (-1132.3544, -6182.6377, 3386.9016);
	angles[40] = (0, 29.0580, 0);
	at[40] = 5.7333;
	points[41] = (-1157.2284, -6138.1890, 3407.4844);
	angles[41] = (0, 28.5195, 0);
	at[41] = 5.8000;
	points[42] = (-1185.8779, -6084.2915, 3431.9685);
	angles[42] = (0, 27.6211, 0);
	at[42] = 5.8667;
	points[43] = (-1216.7047, -6024.8032, 3458.7361);
	angles[43] = (0, 27.2416, 0);
	at[43] = 5.9333;
	points[44] = (-1241.7284, -5976.0635, 3480.6182);
	angles[44] = (0, 27.1052, 0);
	at[44] = 6;
	points[45] = (-1269.0198, -5922.6377, 3504.5786);
	angles[45] = (0, 27.0460, 0);
	at[45] = 6.0667;
	points[46] = (-1326.7244, -5809.6460, 3555.3464);
	angles[46] = (0, 27.0866, 0);
	at[46] = 6.2000;
	points[47] = (-1379.9135, -5705.9448, 3602.1458);
	angles[47] = (0, 27.2356, 0);
	at[47] = 6.3333;
	points[48] = (-1465.2993, -5541.2988, 3677.0432);
	angles[48] = (0, 27.6056, 0);
	at[48] = 6.5333;
	points[49] = (-1520.3505, -5436.6929, 3725.0945);
	angles[49] = (0, 27.9083, 0);
	at[49] = 6.6667;
	points[50] = (-1607.2520, -5274.4883, 3800.4370);
	angles[50] = (0, 28.4771, 0);
	at[50] = 6.8667;
	points[51] = (-1664.4135, -5170.0396, 3849.6023);
	angles[51] = (0, 28.9136, 0);
	at[51] = 7;
	points[52] = (-1813.2599, -4907.7954, 3975.8662);
	angles[52] = (0, 30.3247, 0);
	at[52] = 7.3333;
	points[53] = (-1968.3347, -4652.5200, 4104.0552);
	angles[53] = (0, 32.3826, 0);
	at[53] = 7.6667;
	points[54] = (-2034.5906, -4550.2759, 4157.5591);
	angles[54] = (0, 33.5365, 0);
	at[54] = 7.8000;
	points[55] = (-2100.5669, -4453.1890, 4209.9604);
	angles[55] = (0, 34.9229, 0);
	at[55] = 7.9333;
	points[56] = (-2133.3464, -4406.9292, 4235.5908);
	angles[56] = (0, 35.7239, 0);
	at[56] = 8;
	points[57] = (-2207.5474, -4307.5986, 4292.6377);
	angles[57] = (0, 37.9055, 0);
	at[57] = 8.1333;
	points[58] = (-2244.1692, -4261.6143, 4320.1968);
	angles[58] = (0, 39.2263, 0);
	at[58] = 8.2000;
	points[59] = (-2317.9844, -4176.1416, 4374.4097);
	angles[59] = (0, 42.5996, 0);
	at[59] = 8.3333;
	points[60] = (-2362.0078, -4130.3149, 4405.7480);
	angles[60] = (0, 45.2526, 0);
	at[60] = 8.4000;
	points[61] = (-2404.9724, -4090, 4435.4727);
	angles[61] = (0, 48.5253, 0);
	at[61] = 8.4667;
	points[62] = (-2446.7441, -4055.5120, 4463.4648);
	angles[62] = (0, 52.6294, 0);
	at[62] = 8.5333;
	points[63] = (-2494.5315, -4022.7954, 4494.2520);
	angles[63] = (0, 58.9847, 0);
	at[63] = 8.6000;
	points[64] = (-2548.8818, -3996.1023, 4527.2046);
	angles[64] = (0, 69.6210, 0);
	at[64] = 8.6667;
	points[65] = (-2599.9055, -3983.9370, 4555.6694);
	angles[65] = (0, 84.7989, 0);
	at[65] = 8.7333;
	points[66] = (-2648.4961, -3986.1025, 4580.1577);
	angles[66] = (0, 98.6281, 0);
	at[66] = 8.8000;
	points[67] = (-2704.7795, -3999.4094, 4606.4961);
	angles[67] = (0, 107.1101, 0);
	at[67] = 8.8667;
	points[68] = (-2769.2561, -4023.1101, 4635);
	angles[68] = (0, 112.7473, 0);
	at[68] = 8.9333;
	points[69] = (-2871.2954, -4071.9685, 4678.0317);
	angles[69] = (0, 117.9006, 0);
	at[69] = 9.0667;
	points[70] = (-2926.1970, -4102.2046, 4700.3936);
	angles[70] = (0, 119.7213, 0);
	at[70] = 9.1333;
	points[71] = (-2984.0789, -4136.3389, 4723.5825);
	angles[71] = (0, 121.2276, 0);
	at[71] = 9.2000;
	points[72] = (-3084.6812, -4199.8428, 4763.0708);
	angles[72] = (0, 123.1892, 0);
	at[72] = 9.3333;
	points[73] = (-3187.6182, -4269.1733, 4802.6772);
	angles[73] = (0, 124.6462, 0);
	at[73] = 9.4667;
	points[74] = (-3293.4724, -4343.9370, 4842.7163);
	angles[74] = (0, 125.7779, 0);
	at[74] = 9.6000;
	points[75] = (-3440.2363, -4452.1260, 4897.4014);
	angles[75] = (0, 126.9489, 0);
	at[75] = 9.8000;
	points[76] = (-3593.0947, -4569.0947, 4953.5039);
	angles[76] = (0, 127.8442, 0);
	at[76] = 10;
	points[77] = (-3738.0432, -4683.0708, 5006.1416);
	angles[77] = (0, 128.4848, 0);
	at[77] = 10.2000;
	points[78] = (-3935.3345, -4841.8110, 5077.1260);
	angles[78] = (0, 129.1256, 0);
	at[78] = 10.4667;
	points[79] = (-4610.9053, -5402.7954, 5316.7720);
	angles[79] = (0, 129.9784, 0);
	at[79] = 11.4000;
	points[80] = (-4757.9136, -5525.9844, 5368.7402);
	angles[80] = (0, 129.9139, 0);
	at[80] = 11.6000;
	points[81] = (-4899.7246, -5644.2915, 5418.9766);
	angles[81] = (0, 129.7390, 0);
	at[81] = 11.8000;
	points[82] = (-5049.0552, -5767.7168, 5472.0474);
	angles[82] = (0, 129.3905, 0);
	at[82] = 12;
	points[83] = (-5190.3545, -5882.6772, 5522.6377);
	angles[83] = (0, 128.8205, 0);
	at[83] = 12.2000;
	points[84] = (-5293.9761, -5965.1187, 5560.0786);
	angles[84] = (0, 128.1549, 0);
	at[84] = 12.3333;
	points[85] = (-5343.7402, -6003.9370, 5578.1895);
	angles[85] = (0, 127.7166, 0);
	at[85] = 12.4000;
	points[86] = (-5391.2202, -6040.3545, 5595.6299);
	angles[86] = (0, 127.1921, 0);
	at[86] = 12.4667;
	points[87] = (-5425.3149, -6065.9844, 5608.2285);
	angles[87] = (0, 126.7303, 0);
	at[87] = 12.5333;
	points[88] = (1322.3149, -9650.5117, 193.1587);
	angles[88] = (0, 47.5087, 0);
	at[88] = 12.5333;
	points[89] = (1322.3149, -9650.5117, 193.1587);
	angles[89] = (0, 47.5087, 0);
	at[89] = 12.5500;
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
	points[0] = (-3294.8188, -8823.8975, -786.1063);
	angles[0] = (0, -23.0226, 0);
	at[0] = 0;
	points[1] = (-3272.7795, -8770.7480, -712.9489);
	angles[1] = (0, -22.0969, 0);
	at[1] = 0.1000;
	points[2] = (-3249.5471, -8712.5986, -634.0079);
	angles[2] = (0, -21.5073, 0);
	at[2] = 0.2000;
	points[3] = (-3227.9648, -8657.2842, -559.5787);
	angles[3] = (0, -21.1636, 0);
	at[3] = 0.3000;
	points[4] = (-3205.4016, -8598.6221, -481.0237);
	angles[4] = (0, -20.9392, 0);
	at[4] = 0.4000;
	points[5] = (-3184.1536, -8542.9141, -406.6378);
	angles[5] = (0, -20.8182, 0);
	at[5] = 0.5000;
	points[6] = (-3042.1890, -8171.6934, 89.4819);
	angles[6] = (0, -21.3882, 0);
	at[6] = 1.1500;
	points[7] = (-2950.8975, -7946.6143, 396.6850);
	angles[7] = (0, -23.0030, 0);
	at[7] = 1.5500;
	points[8] = (-2902.5042, -7836.4961, 551.5748);
	angles[8] = (0, -24.5953, 0);
	at[8] = 1.7500;
	points[9] = (-2878.1575, -7784.6455, 626.4528);
	angles[9] = (0, -25.7562, 0);
	at[9] = 1.8500;
	points[10] = (-2850.7480, -7729.8823, 707.5984);
	angles[10] = (0, -27.5465, 0);
	at[10] = 1.9500;
	points[11] = (-2823.6260, -7680.4331, 783.8071);
	angles[11] = (0, -30.1602, 0);
	at[11] = 2.0500;
	points[12] = (-2807.7400, -7654.2129, 826.0788);
	angles[12] = (0, -32.3508, 0);
	at[12] = 2.1000;
	points[13] = (-2792.4487, -7631.2598, 864.7677);
	angles[13] = (0, -35.2348, 0);
	at[13] = 2.1500;
	points[14] = (-2777.7007, -7611.7324, 899.8622);
	angles[14] = (0, -39.1891, 0);
	at[14] = 2.2000;
	points[15] = (-2761.0710, -7592.7563, 937.2795);
	angles[15] = (0, -42.9774, 0);
	at[15] = 2.2500;
	points[16] = (-2721.1458, -7553.9370, 1022.5787);
	angles[16] = (0, -48.1483, 0);
	at[16] = 2.3500;
	points[17] = (-2702.4409, -7537.6377, 1061.2441);
	angles[17] = (0, -49.6819, 0);
	at[17] = 2.4000;
	points[18] = (-2639.8860, -7487.9131, 1187.0945);
	angles[18] = (0, -53.0328, 0);
	at[18] = 2.5500;
	points[19] = (-2598.7676, -7457.7949, 1267.8307);
	angles[19] = (0, -54.4294, 0);
	at[19] = 2.6500;
	points[20] = (-2554.8740, -7427.0474, 1352.7834);
	angles[20] = (0, -55.5359, 0);
	at[20] = 2.7500;
	points[21] = (-2446.2874, -7355.1973, 1558.7875);
	angles[21] = (0, -57.2863, 0);
	at[21] = 3;
	points[22] = (-2222.6299, -7216.1812, 1968.7795);
	angles[22] = (0, -58.6004, 0);
	at[22] = 3.5000;
	points[23] = (-2175.9451, -7187.6772, 2052.0354);
	angles[23] = (0, -58.5922, 0);
	at[23] = 3.6000;
	points[24] = (-2107.5789, -7145.7876, 2172.2717);
	angles[24] = (0, -58.3760, 0);
	at[24] = 3.7500;
	points[25] = (-2059.4844, -7115.9844, 2255.4409);
	angles[25] = (0, -58.0337, 0);
	at[25] = 3.8500;
	points[26] = (-2014.0787, -7087.4019, 2332.6299);
	angles[26] = (0, -57.4987, 0);
	at[26] = 3.9500;
	points[27] = (-1964.0787, -7055, 2415.6772);
	angles[27] = (0, -56.5252, 0);
	at[27] = 4.0500;
	points[28] = (-1916.5197, -7022.6377, 2491.8896);
	angles[28] = (0, -54.8829, 0);
	at[28] = 4.1500;
	points[29] = (-1890.0984, -7003.5830, 2532.4016);
	angles[29] = (0, -53.3415, 0);
	at[29] = 4.2000;
	points[30] = (-1842.9567, -6965.4727, 2598.6221);
	angles[30] = (0, -48.8218, 0);
	at[30] = 4.3000;
	points[31] = (-1816.3071, -6941.4175, 2632.2363);
	angles[31] = (0, -47.0892, 0);
	at[31] = 4.3500;
	points[32] = (-1762.6456, -6889.4492, 2694.2520);
	angles[32] = (0, -45.0110, 0);
	at[32] = 4.4500;
	points[33] = (-1707.7638, -6833.4253, 2752.1260);
	angles[33] = (0, -43.9346, 0);
	at[33] = 4.5500;
	points[34] = (-1623.9016, -6745.2363, 2833.4055);
	angles[34] = (0, -43.3297, 0);
	at[34] = 4.7000;
	points[35] = (-1509.3347, -6624.0156, 2935.6655);
	angles[35] = (0, -43.6057, 0);
	at[35] = 4.9000;
	points[36] = (-1392.2362, -6503.1890, 3034.0669);
	angles[36] = (0, -44.7100, 0);
	at[36] = 5.1000;
	points[37] = (-1271.8031, -6385.0786, 3131.8779);
	angles[37] = (0, -46.5477, 0);
	at[37] = 5.3000;
	points[38] = (-1178.9410, -6299.8818, 3206.2834);
	angles[38] = (0, -48.4589, 0);
	at[38] = 5.4500;
	points[39] = (-1083.7795, -6219.0156, 3282.4922);
	angles[39] = (0, -50.9300, 0);
	at[39] = 5.6000;
	points[40] = (-1019.0787, -6168.3071, 3334.6260);
	angles[40] = (0, -52.9606, 0);
	at[40] = 5.7000;
	points[41] = (-963.6299, -6126.5752, 3379.3938);
	angles[41] = (0, -52.8367, 0);
	at[41] = 5.8000;
	points[42] = (-930.9174, -6101.6929, 3405.6772);
	angles[42] = (0, -52.7077, 0);
	at[42] = 5.8500;
	points[43] = (-856.7363, -6045.0396, 3465.0750);
	angles[43] = (0, -52.5865, 0);
	at[43] = 5.9500;
	points[44] = (-827.9213, -6022.9922, 3488.0986);
	angles[44] = (0, -52.5707, 0);
	at[44] = 6;
	points[45] = (-765.7205, -5975.3936, 3537.7166);
	angles[45] = (0, -52.5668, 0);
	at[45] = 6.1000;
	points[46] = (-628.0157, -5870.0791, 3647.3110);
	angles[46] = (0, -52.6385, 0);
	at[46] = 6.3000;
	points[47] = (-566.1339, -5822.8740, 3696.4646);
	angles[47] = (0, -52.6915, 0);
	at[47] = 6.4000;
	points[48] = (-468.0709, -5748.3071, 3774.2600);
	angles[48] = (0, -52.7932, 0);
	at[48] = 6.5500;
	points[49] = (-364.4449, -5669.8032, 3856.3545);
	angles[49] = (0, -52.9196, 0);
	at[49] = 6.7000;
	points[50] = (-203.2213, -5548.4648, 3983.8584);
	angles[50] = (0, -53.1505, 0);
	at[50] = 6.9500;
	points[51] = (-35.0685, -5423.0708, 4116.5747);
	angles[51] = (0, -53.4364, 0);
	at[51] = 7.2000;
	points[52] = (263.5464, -5204.0552, 4351.5356);
	angles[52] = (0, -54.0811, 0);
	at[52] = 7.6500;
	points[53] = (465.4528, -5059.2524, 4509.8818);
	angles[53] = (0, -54.6549, 0);
	at[53] = 7.9500;
	points[54] = (632.4331, -4942.0864, 4640.3936);
	angles[54] = (0, -55.2557, 0);
	at[54] = 8.2000;
	points[55] = (736.6812, -4870.3936, 4721.6929);
	angles[55] = (0, -55.7128, 0);
	at[55] = 8.3500;
	points[56] = (838.6181, -4801.5356, 4800.9844);
	angles[56] = (0, -56.2430, 0);
	at[56] = 8.5000;
	points[57] = (937.6614, -4736.1025, 4877.8350);
	angles[57] = (0, -56.8645, 0);
	at[57] = 8.6500;
	points[58] = (1081.3386, -4644.2910, 4988.8584);
	angles[58] = (0, -58.0410, 0);
	at[58] = 8.8500;
	points[59] = (1149.7560, -4602.1650, 5041.5352);
	angles[59] = (0, -58.7715, 0);
	at[59] = 8.9500;
	points[60] = (1215.3820, -4563.0317, 5091.8501);
	angles[60] = (0, -59.6270, 0);
	at[60] = 9.0500;
	points[61] = (1291.3544, -4519.5669, 5149.8823);
	angles[61] = (0, -60.8916, 0);
	at[61] = 9.1500;
	points[62] = (1364.9016, -4479.9214, 5205.7090);
	angles[62] = (0, -62.5532, 0);
	at[62] = 9.2500;
	points[63] = (1466.4213, -4430.8267, 5282.0474);
	angles[63] = (0, -66.2099, 0);
	at[63] = 9.4000;
	points[64] = (1510.9174, -4412.3228, 5315.0791);
	angles[64] = (0, -68.8148, 0);
	at[64] = 9.4500;
	points[65] = (1551.2245, -4397.9922, 5344.7241);
	angles[65] = (0, -72.2797, 0);
	at[65] = 9.5000;
	points[66] = (1587.1141, -4388.0317, 5370.7090);
	angles[66] = (0, -77.0685, 0);
	at[66] = 9.5500;
	points[67] = (1618.3464, -4382.6377, 5392.9131);
	angles[67] = (0, -83.9908, 0);
	at[67] = 9.6000;
	points[68] = (1656.1497, -4381.9688, 5418.9766);
	angles[68] = (0, -93.6890, 0);
	at[68] = 9.6500;
	points[69] = (1696.1576, -4387.6772, 5445.7085);
	angles[69] = (0, -102.2593, 0);
	at[69] = 9.7000;
	points[70] = (1737.3977, -4399.5278, 5472.4409);
	angles[70] = (0, -109.4503, 0);
	at[70] = 9.7500;
	points[71] = (1775.2401, -4415, 5496.3384);
	angles[71] = (0, -114.8065, 0);
	at[71] = 9.8000;
	points[72] = (1812.3268, -4433.9370, 5519.2129);
	angles[72] = (0, -119.1236, 0);
	at[72] = 9.8500;
	points[73] = (1888.2363, -4482.6772, 5564.7241);
	angles[73] = (0, -125.8239, 0);
	at[73] = 9.9500;
	points[74] = (1955.7283, -4535.5908, 5603.8584);
	angles[74] = (0, -130.0987, 0);
	at[74] = 10.0500;
	points[75] = (2024.6102, -4597.2441, 5642.7163);
	angles[75] = (0, -133.3750, 0);
	at[75] = 10.1500;
	points[76] = (2088.0078, -4659.7246, 5677.7559);
	angles[76] = (0, -135.7064, 0);
	at[76] = 10.2500;
	points[77] = (2151.2166, -4726.7324, 5712.0083);
	angles[77] = (0, -137.5504, 0);
	at[77] = 10.3500;
	points[78] = (2242.5039, -4830.3940, 5760.5117);
	angles[78] = (0, -139.5835, 0);
	at[78] = 10.5000;
	points[79] = (2331.8032, -4938.1104, 5807.1265);
	angles[79] = (0, -141.0273, 0);
	at[79] = 10.6500;
	points[80] = (2475.3464, -5120.7871, 5880.7085);
	angles[80] = (0, -142.4870, 0);
	at[80] = 10.9000;
	points[81] = (2785.9604, -5530.2754, 6038.0312);
	angles[81] = (0, -142.2748, 0);
	at[81] = 11.4500;
	points[82] = (2844.5159, -5604.9604, 6068.0317);
	angles[82] = (0, -141.4709, 0);
	at[82] = 11.5500;
	points[83] = (2901.2085, -5674.7246, 6097.4409);
	angles[83] = (0, -140.2373, 0);
	at[83] = 11.6500;
	points[84] = (2963.8464, -5747.4014, 6130.5117);
	angles[84] = (0, -138.0251, 0);
	at[84] = 11.7500;
	points[85] = (2993.4016, -5779.4092, 6146.4565);
	angles[85] = (0, -136.4788, 0);
	at[85] = 11.8000;
	points[86] = (2993.4016, -5779.4092, 6146.4565);
	angles[86] = (0, -136.4788, 0);
	at[86] = 11.8167;
	points[87] = (-3294.8188, -8823.8975, -786.1063);
	angles[87] = (0, -23.0226, 0);
	at[87] = 11.8167;
	points[88] = (-3294.8188, -8823.8975, -786.1063);
	angles[88] = (0, -23.0226, 0);
	at[88] = 11.8333;
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
