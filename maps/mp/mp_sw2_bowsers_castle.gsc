main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_bowsers_castle", 0);

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
	ambientPlay("iz_0_sw2bc", 2);
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
	level.iz_route[level.iz_route.size] = (-45, 3618, 2044);
	level.iz_route[level.iz_route.size] = (-29, 2241, 1786);
	level.iz_route[level.iz_route.size] = (-13, 1383, 1601);
	level.iz_route[level.iz_route.size] = (-6, 319, 1326);
	level.iz_route[level.iz_route.size] = (2, -296, 1276);
	level.iz_route[level.iz_route.size] = (-189, -995, 1276);
	level.iz_route[level.iz_route.size] = (-286, -1487, 1276);
	level.iz_route[level.iz_route.size] = (-778, -1781, 1276);
	level.iz_route[level.iz_route.size] = (-1175, -2006, 1276);
	level.iz_route[level.iz_route.size] = (-1623, -2259, 1276);
	level.iz_route[level.iz_route.size] = (-1607, -3089, 1276);
	level.iz_route[level.iz_route.size] = (-1601, -3533, 1276);
	level.iz_route[level.iz_route.size] = (-1592, -4113, 1276);
	level.iz_route[level.iz_route.size] = (-1163, -4393, 1276);
	level.iz_route[level.iz_route.size] = (-710, -4687, 1276);
	level.iz_route[level.iz_route.size] = (-362, -4939, 1276);
	level.iz_route[level.iz_route.size] = (-14, -5547, 1276);
	level.iz_route[level.iz_route.size] = (-5, -6003, 1276);
	level.iz_route[level.iz_route.size] = (-3, -6502, 1359);
	level.iz_route[level.iz_route.size] = (8, -7542, 1397);
	level.iz_route[level.iz_route.size] = (21, -8077, 1707);
	level.iz_route[level.iz_route.size] = (363, -8377, 1881);
	level.iz_route[level.iz_route.size] = (941, -8443, 1931);
	level.iz_route[level.iz_route.size] = (1526, -8355, 1956);
	level.iz_route[level.iz_route.size] = (2236, -8086, 1986);
	level.iz_route[level.iz_route.size] = (2801, -7717, 1972);
	level.iz_route[level.iz_route.size] = (2824, -7166, 1719);
	level.iz_route[level.iz_route.size] = (2583, -6648, 1396);
	level.iz_route[level.iz_route.size] = (2519, -6169, 1150);
	level.iz_route[level.iz_route.size] = (2979, -5611, 1090);
	level.iz_route[level.iz_route.size] = (3460, -4914, 1103);
	level.iz_route[level.iz_route.size] = (3706, -4152, 1099);
	level.iz_route[level.iz_route.size] = (3634, -3481, 1030);
	level.iz_route[level.iz_route.size] = (3295, -3197, 843);
	level.iz_route[level.iz_route.size] = (2597, -3220, 596);
	level.iz_route[level.iz_route.size] = (1294, -3247, 119);
	level.iz_route[level.iz_route.size] = (221, -3234, 411);
	level.iz_route[level.iz_route.size] = (67, -3245, 936);
	level.iz_route[level.iz_route.size] = (-72, -3186, 5280);
	level.iz_route[level.iz_route.size] = (-907, -2696, 10059);
	level.iz_route[level.iz_route.size] = (-1371, -2077, 10469);
	level.iz_route[level.iz_route.size] = (-1803, -1720, 10296);
	level.iz_route[level.iz_route.size] = (-2548, -1125, 9840);
	level.iz_route[level.iz_route.size] = (-3245, -440, 9531);
	level.iz_route[level.iz_route.size] = (-3976, 209, 9256);
	level.iz_route[level.iz_route.size] = (-4486, 838, 9098);
	level.iz_route[level.iz_route.size] = (-4980, 1452, 8941);
	level.iz_route[level.iz_route.size] = (-5312, 2097, 8743);
	level.iz_route[level.iz_route.size] = (-5514, 2814, 8536);
	level.iz_route[level.iz_route.size] = (-5555, 3463, 8374);
	level.iz_route[level.iz_route.size] = (-5362, 4226, 8181);
	level.iz_route[level.iz_route.size] = (-4971, 4819, 8009);
	level.iz_route[level.iz_route.size] = (-4403, 5231, 7859);
	level.iz_route[level.iz_route.size] = (-3767, 5375, 7775);
	level.iz_route[level.iz_route.size] = (-3293, 5401, 7742);
	level.iz_route[level.iz_route.size] = (-2848, 5406, 7729);
	level.iz_route[level.iz_route.size] = (-2375, 5380, 7788);
	level.iz_route[level.iz_route.size] = (-1072, 5178, 7643);
	level.iz_route[level.iz_route.size] = (-250, 5062, 7392);
	level.iz_route[level.iz_route.size] = (702, 4935, 7395);
	level.iz_route[level.iz_route.size] = (1512, 4808, 7593);
	level.iz_route[level.iz_route.size] = (2779, 4497, 7667);
	level.iz_route[level.iz_route.size] = (3422, 4371, 7791);
	level.iz_route[level.iz_route.size] = (4113, 4202, 8080);
	level.iz_route[level.iz_route.size] = (4753, 4044, 8293);
	level.iz_route[level.iz_route.size] = (5348, 3942, 8415);
	level.iz_route[level.iz_route.size] = (6026, 4126, 8521);
	level.iz_route[level.iz_route.size] = (6483, 4696, 8559);
	level.iz_route[level.iz_route.size] = (6618, 5400, 8533);
	level.iz_route[level.iz_route.size] = (6500, 5973, 8459);
	level.iz_route[level.iz_route.size] = (6129, 6383, 8307);
	level.iz_route[level.iz_route.size] = (5607, 6709, 8129);
	level.iz_route[level.iz_route.size] = (4850, 7123, 7904);
	level.iz_route[level.iz_route.size] = (4395, 7315, 7757);
	level.iz_route[level.iz_route.size] = (3947, 7497, 7622);
	level.iz_route[level.iz_route.size] = (3390, 7771, 7628);
	level.iz_route[level.iz_route.size] = (2839, 8003, 7321);
	level.iz_route[level.iz_route.size] = (2225, 8299, 7234);
	level.iz_route[level.iz_route.size] = (1605, 8584, 6878);
	level.iz_route[level.iz_route.size] = (835, 8917, 6880);
	level.iz_route[level.iz_route.size] = (-556, 9565, 6286);
	level.iz_route[level.iz_route.size] = (-1205, 9857, 6067);
	level.iz_route[level.iz_route.size] = (-1647, 10105, 6062);
	level.iz_route[level.iz_route.size] = (-2208, 10497, 6102);
	level.iz_route[level.iz_route.size] = (-2682, 10936, 6169);
	level.iz_route[level.iz_route.size] = (-3041, 11401, 6229);
	level.iz_route[level.iz_route.size] = (-3276, 11963, 6282);
	level.iz_route[level.iz_route.size] = (-3323, 12569, 6318);
	level.iz_route[level.iz_route.size] = (-3141, 13121, 6326);
	level.iz_route[level.iz_route.size] = (-2801, 13565, 6325);
	level.iz_route[level.iz_route.size] = (-2355, 13844, 6332);
	level.iz_route[level.iz_route.size] = (-1841, 13920, 6322);
	level.iz_route[level.iz_route.size] = (-1326, 13769, 6272);
	level.iz_route[level.iz_route.size] = (-836, 13470, 6180);
	level.iz_route[level.iz_route.size] = (-485, 13045, 6033);
	level.iz_route[level.iz_route.size] = (-267, 12454, 5781);
	level.iz_route[level.iz_route.size] = (-203, 11762, 5555);
	level.iz_route[level.iz_route.size] = (35, 10188, 4962);
	level.iz_route[level.iz_route.size] = (-13, 8199, 3072);
	level.iz_route[level.iz_route.size] = (-30, 6945, 2470);
	level.iz_route[level.iz_route.size] = (-16, 5725, 2143);
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
	thread iz_obj_11();
	thread iz_obj_12();
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-719.9174, 7551.4961, 9349.1729);
	angles[0] = (0, 2.1998, 0);
	at[0] = 0;
	points[1] = (-728.1732, 7739.4092, 9211.9297);
	angles[1] = (0, 3.2153, 0);
	at[1] = 0.2667;
	points[2] = (-752.9764, 8116.4570, 8935.8662);
	angles[2] = (0, 4.2731, 0);
	at[2] = 0.8000;
	points[3] = (-794.3662, 8586.6533, 8597.4414);
	angles[3] = (0, 5.9366, 0);
	at[3] = 1.4667;
	points[4] = (-805.2441, 8677.6377, 8528.9365);
	angles[4] = (0, 7.2605, 0);
	at[4] = 1.6000;
	points[5] = (-840.9843, 8952.2832, 8315.7090);
	angles[5] = (0, 6.8850, 0);
	at[5] = 2;
	points[6] = (-858.7480, 9125.5117, 8165.3540);
	angles[6] = (0, 5.5594, 0);
	at[6] = 2.2667;
	points[7] = (-875.5945, 9295.8271, 8008.8188);
	angles[7] = (0, 6.0870, 0);
	at[7] = 2.5333;
	points[8] = (-884.1457, 9374.4883, 7926.9688);
	angles[8] = (0, 6.2506, 0);
	at[8] = 2.6667;
	points[9] = (-911.1811, 9608.7793, 7671.4175);
	angles[9] = (0, 7.2986, 0);
	at[9] = 3.0667;
	points[10] = (-922.5472, 9684.0947, 7588.0312);
	angles[10] = (0, 10.0105, 0);
	at[10] = 3.2000;
	points[11] = (-979.6772, 9986.7324, 7246.4961);
	angles[11] = (0, 9.5963, 0);
	at[11] = 3.7333;
	points[12] = (-1025.8937, 10283.3467, 6900.0396);
	angles[12] = (0, 9.9594, 0);
	at[12] = 4.2667;
	points[13] = (-1067.3188, 10510, 6644.9604);
	angles[13] = (0, 10.6508, 0);
	at[13] = 4.6667;
	points[14] = (-1168.0118, 11025.9443, 6046.7324);
	angles[14] = (0, 10.6843, 0);
	at[14] = 5.6000;
	points[15] = (-1169.8425, 11035.6299, 6035.5117);
	angles[15] = (0, 10.6974, 0);
	at[15] = 5.7333;
	points[16] = (-1169.8425, 11035.6299, 6035.5117);
	angles[16] = (0, 10.6974, 0);
	at[16] = 7.3000;
	points[17] = (-542.0236, 3919.3936, 10722.9131);
	angles[17] = (0, 4.0980, 0);
	at[17] = 7.3000;
	points[18] = (-542.0236, 3919.3936, 10722.9131);
	angles[18] = (0, 4.0980, 0);
	at[18] = 25.3333;
	points[19] = (-549.4449, 4025.5906, 10774.2520);
	angles[19] = (0, 4.0413, 0);
	at[19] = 25.4667;
	points[20] = (-558.4528, 4136.0239, 10812.9521);
	angles[20] = (0, 5.5504, 0);
	at[20] = 25.6000;
	points[21] = (-569.8425, 4252.7163, 10831.2988);
	angles[21] = (0, 5.3431, 0);
	at[21] = 25.7333;
	points[22] = (-586.0512, 4486.2598, 10860.2764);
	angles[22] = (0, 5.4223, 0);
	at[22] = 26;
	points[23] = (-597.5630, 4603.2285, 10876.8506);
	angles[23] = (0, 5.4813, 0);
	at[23] = 26.1333;
	points[24] = (-613.3110, 4838.0317, 10899.2129);
	angles[24] = (0, 3.5007, 0);
	at[24] = 26.4000;
	points[25] = (-621.9567, 4955.5908, 10897.8350);
	angles[25] = (0, 5.0976, 0);
	at[25] = 26.5333;
	points[26] = (-632.7953, 5072.4805, 10882.1260);
	angles[26] = (0, 5.4377, 0);
	at[26] = 26.6667;
	points[27] = (-644.1811, 5188.8979, 10861.0635);
	angles[27] = (0, 5.8384, 0);
	at[27] = 26.8000;
	points[28] = (-656.8347, 5300.7876, 10828.5439);
	angles[28] = (0, 6.6573, 0);
	at[28] = 26.9333;
	points[29] = (-669.8188, 5412.6772, 10790.9453);
	angles[29] = (0, 6.5152, 0);
	at[29] = 27.0667;
	points[30] = (-681.2362, 5519.8818, 10746.2598);
	angles[30] = (0, 5.0534, 0);
	at[30] = 27.2000;
	points[31] = (-689.2795, 5620.0786, 10682.9141);
	angles[31] = (0, 4.3544, 0);
	at[31] = 27.3333;
	points[32] = (-708.3583, 5910.4727, 10481.5352);
	angles[32] = (0, 2.2002, 0);
	at[32] = 27.7333;
	points[33] = (-715.4331, 6196.4565, 10274.6846);
	angles[33] = (0, 0.1886, 0);
	at[33] = 28.1333;
	points[34] = (-714.8622, 6478.3857, 10060.4727);
	angles[34] = (0, -0.0105, 0);
	at[34] = 28.5333;
	points[35] = (-715.5511, 6574.9604, 9995.1973);
	angles[35] = (0, 0.6736, 0);
	at[35] = 28.6667;
	points[36] = (-718.8425, 6873.6616, 9807.4805);
	angles[36] = (0, 0.2046, 0);
	at[36] = 29.0667;
	points[37] = (-711.8386, 7267.0469, 9553.1494);
	angles[37] = (0, -0.2789, 0);
	at[37] = 29.6000;
	points[38] = (-719.9174, 7551.4961, 9349.1729);
	angles[38] = (0, 2.1998, 0);
	at[38] = 30;
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
	points[0] = (-542.0236, 3919.3936, 10722.9131);
	angles[0] = (0, 4.0980, 0);
	at[0] = 0;
	points[1] = (-542.0236, 3919.3936, 10722.9131);
	angles[1] = (0, 4.0980, 0);
	at[1] = 10.2667;
	points[2] = (-545.7323, 3972.4412, 10748.5039);
	angles[2] = (0, 3.9699, 0);
	at[2] = 10.4000;
	points[3] = (-553.3780, 4079.5278, 10798.2676);
	angles[3] = (0, 4.4064, 0);
	at[3] = 10.5333;
	points[4] = (-564.1851, 4194.3311, 10822.6768);
	angles[4] = (0, 5.6252, 0);
	at[4] = 10.6667;
	points[5] = (-574.3701, 4310.7480, 10839.1738);
	angles[5] = (0, 3.6421, 0);
	at[5] = 10.8000;
	points[6] = (-581.5157, 4428.2285, 10852.8340);
	angles[6] = (0, 3.6422, 0);
	at[6] = 10.9333;
	points[7] = (-602.5512, 4660.8271, 10883.7012);
	angles[7] = (0, 3.9619, 0);
	at[7] = 11.2000;
	points[8] = (-609.7795, 4779.0947, 10894.7637);
	angles[8] = (0, 3.3880, 0);
	at[8] = 11.3333;
	points[9] = (-617.1417, 4897.4014, 10901.7715);
	angles[9] = (0, 4.0326, 0);
	at[9] = 11.4667;
	points[10] = (-627.2953, 5014.0161, 10890.5908);
	angles[10] = (0, 5.3108, 0);
	at[10] = 11.6000;
	points[11] = (-638.4173, 5130.8662, 10872.5195);
	angles[11] = (0, 5.5656, 0);
	at[11] = 11.7333;
	points[12] = (-650.3425, 5244.8423, 10845.6699);
	angles[12] = (0, 6.5468, 0);
	at[12] = 11.8667;
	points[13] = (-663.3859, 5356.9688, 10810.2354);
	angles[13] = (0, 6.6365, 0);
	at[13] = 12;
	points[14] = (-675.9882, 5467.8345, 10770.0391);
	angles[14] = (0, 6.1993, 0);
	at[14] = 12.1333;
	points[15] = (-685.4724, 5571.0635, 10715.0791);
	angles[15] = (0, 4.5388, 0);
	at[15] = 12.2667;
	points[16] = (-706.2402, 5863.2681, 10514.6455);
	angles[16] = (0, 3.1665, 0);
	at[16] = 12.6667;
	points[17] = (-712.8425, 6054.6455, 10378.4648);
	angles[17] = (0, 1.4878, 0);
	at[17] = 12.9333;
	points[18] = (-714.9843, 6150.4727, 10308.9766);
	angles[18] = (0, 0.9806, 0);
	at[18] = 13.0667;
	points[19] = (-714.9371, 6431.2993, 10095.4717);
	angles[19] = (0, -0.1479, 0);
	at[19] = 13.4667;
	points[20] = (-715.0275, 6525.0391, 10027.7168);
	angles[20] = (0, 0.4801, 0);
	at[20] = 13.6000;
	points[21] = (-718.6103, 6922.2441, 9776.4570);
	angles[21] = (0, -0.8099, 0);
	at[21] = 14.1333;
	points[22] = (-712.3898, 7218.1890, 9585.5117);
	angles[22] = (0, -0.9016, 0);
	at[22] = 14.5333;
	points[23] = (-712.2283, 7314.0161, 9520.8662);
	angles[23] = (0, 1.1498, 0);
	at[23] = 14.6667;
	points[24] = (-718.1457, 7504.3311, 9383.5830);
	angles[24] = (0, 2.0997, 0);
	at[24] = 14.9333;
	points[25] = (-725.8346, 7693.7402, 9245.2363);
	angles[25] = (0, 2.6605, 0);
	at[25] = 15.2000;
	points[26] = (-749.5276, 8068.8584, 8970.5908);
	angles[26] = (0, 4.0471, 0);
	at[26] = 15.7333;
	points[27] = (-789.7874, 8540.1973, 8631.3779);
	angles[27] = (0, 5.4370, 0);
	at[27] = 16.4000;
	points[28] = (-799.4803, 8631.4570, 8563.8975);
	angles[28] = (0, 6.9098, 0);
	at[28] = 16.5333;
	points[29] = (-823.2795, 8815.5508, 8423.2676);
	angles[29] = (0, 7.5334, 0);
	at[29] = 16.8000;
	points[30] = (-845.7441, 8995, 8279.8428);
	angles[30] = (0, 5.9879, 0);
	at[30] = 17.0667;
	points[31] = (-871.3110, 9254.0156, 8048.5830);
	angles[31] = (0, 5.7003, 0);
	at[31] = 17.4667;
	points[32] = (-879.8189, 9334.8428, 7968.9766);
	angles[32] = (0, 6.2007, 0);
	at[32] = 17.6000;
	points[33] = (-916.3503, 9646.7715, 7629.4883);
	angles[33] = (0, 8.4812, 0);
	at[33] = 18.1333;
	points[34] = (-973.1102, 9950.3545, 7287.9526);
	angles[34] = (0, 10.6151, 0);
	at[34] = 18.6667;
	points[35] = (-985.7166, 10024.0947, 7203.1104);
	angles[35] = (0, 8.9134, 0);
	at[35] = 18.8000;
	points[36] = (-1019.7126, 10246.9297, 6941.7324);
	angles[36] = (0, 9.1399, 0);
	at[36] = 19.2000;
	points[37] = (-1060.3190, 10472.5586, 6687.2046);
	angles[37] = (0, 10.5272, 0);
	at[37] = 19.6000;
	points[38] = (-1161.1141, 10989.3311, 6089.0552);
	angles[38] = (0, 10.6639, 0);
	at[38] = 20.5333;
	points[39] = (-1169.8425, 11035.6299, 6035.5117);
	angles[39] = (0, 10.6974, 0);
	at[39] = 20.6667;
	points[40] = (-1169.8425, 11035.6299, 6035.5117);
	angles[40] = (0, 10.6974, 0);
	at[40] = 22.3000;
	points[41] = (-542.0236, 3919.3936, 10722.9131);
	angles[41] = (0, 4.0980, 0);
	at[41] = 22.3000;
	points[42] = (-542.0236, 3919.3936, 10722.9131);
	angles[42] = (0, 4.0980, 0);
	at[42] = 30;
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
	points[0] = (231.1886, 4655.6694, 11945);
	angles[0] = (0, -8.9491, 0);
	at[0] = 0;
	points[1] = (231.1886, 4655.6694, 11945);
	angles[1] = (0, -8.9491, 0);
	at[1] = 28.6000;
	points[2] = (249.7823, 4767.3623, 11978.5039);
	angles[2] = (0, -9.4687, 0);
	at[2] = 28.8000;
	points[3] = (272.4051, 4936.7715, 12023.5439);
	angles[3] = (0, -3.6627, 0);
	at[3] = 29;
	points[4] = (280.0071, 5111.7720, 12053.6611);
	angles[4] = (0, -1.3628, 0);
	at[4] = 29.2000;
	points[5] = (271.7469, 5287.9526, 12064.4883);
	angles[5] = (0, 4.8006, 0);
	at[5] = 29.4000;
	points[6] = (258.3323, 5463.9370, 12057.3623);
	angles[6] = (0, 3.2637, 0);
	at[6] = 29.6000;
	points[7] = (248.4146, 5639.1733, 12028.9375);
	angles[7] = (0, 3.5124, 0);
	at[7] = 29.8000;
	points[8] = (235.3185, 5803.7798, 11965.6699);
	angles[8] = (0, 4.8512, 0);
	at[8] = 30;
	points[9] = (222.1972, 5962.9131, 11889.8818);
	angles[9] = (0, 4.6186, 0);
	at[9] = 30.2000;
	points[10] = (209.7532, 6120.8267, 11808.7012);
	angles[10] = (0, 4.1684, 0);
	at[10] = 30.4000;
	points[11] = (191.4673, 6429.2129, 11637.1660);
	angles[11] = (0, 2.2491, 0);
	at[11] = 30.8000;
	points[12] = (176.9071, 6890.2759, 11375.1182);
	angles[12] = (0, 3.4922, 0);
	at[12] = 31.4000;
	points[13] = (155.7339, 7196.6934, 11197.1650);
	angles[13] = (0, 3.5162, 0);
	at[13] = 31.8000;
	points[14] = (140.8787, 7499.4097, 11017.1650);
	angles[14] = (0, 2.3428, 0);
	at[14] = 32.2000;
	points[15] = (137.8221, 7651.8110, 10928.7803);
	angles[15] = (0, 0.1973, 0);
	at[15] = 32.4000;
	points[16] = (135.6524, 7958.9766, 10755.7490);
	angles[16] = (0, 1.9915, 0);
	at[16] = 32.8000;
	points[17] = (122.5051, 8271.0635, 10588.9766);
	angles[17] = (0, 2.2870, 0);
	at[17] = 33.2000;
	points[18] = (105.1059, 8729.2520, 10329.1338);
	angles[18] = (0, 1.8137, 0);
	at[18] = 33.8000;
	points[19] = (91.4598, 9189.1729, 10064.8027);
	angles[19] = (0, 2.1645, 0);
	at[19] = 34.4000;
	points[20] = (77.9406, 9485.7480, 9876.2998);
	angles[20] = (0, 2.7345, 0);
	at[20] = 34.8000;
	points[21] = (63.9283, 9778.6221, 9684.2520);
	angles[21] = (0, 2.7178, 0);
	at[21] = 35.2000;
	points[22] = (42.9154, 10215.9844, 9385);
	angles[22] = (0, 2.8429, 0);
	at[22] = 35.8000;
	points[23] = (12.6588, 10796.1025, 8995);
	angles[23] = (0, 2.4620, 0);
	at[23] = 36.6000;
	points[24] = (-12.4733, 11367.9922, 8588.6611);
	angles[24] = (0, 3.6392, 0);
	at[24] = 37.4000;
	points[25] = (-42.6961, 11795.5117, 8283.0713);
	angles[25] = (0, 4.0312, 0);
	at[25] = 38;
	points[26] = (-51.6693, 11935.5908, 8180.1577);
	angles[26] = (0, 3.0925, 0);
	at[26] = 38.2000;
	points[27] = (-73.1433, 12353.6230, 7861.2993);
	angles[27] = (0, 3.2396, 0);
	at[27] = 38.8000;
	points[28] = (-82.8335, 12489.8428, 7753.8193);
	angles[28] = (0, 5.4223, 0);
	at[28] = 39;
	points[29] = (-127.0453, 12891.7334, 7418.2676);
	angles[29] = (0, 6.5004, 0);
	at[29] = 39.6000;
	points[30] = (-141.2083, 13020.9453, 7303.1895);
	angles[30] = (0, 6.0835, 0);
	at[30] = 39.8000;
	points[31] = (-168.9126, 13276.8506, 7066.8896);
	angles[31] = (0, 6.4056, 0);
	at[31] = 40.2000;
	points[32] = (-183.9220, 13404.4482, 6947.3232);
	angles[32] = (0, 7.1970, 0);
	at[32] = 40.4000;
	points[33] = (-203.3319, 13527.9922, 6829.3306);
	angles[33] = (0, 10.5082, 0);
	at[33] = 40.6000;
	points[34] = (-252.8823, 13775.6299, 6587.4409);
	angles[34] = (0, 11.8451, 0);
	at[34] = 41;
	points[35] = (-278.3933, 13894.3701, 6461.4570);
	angles[35] = (0, 12.5458, 0);
	at[35] = 41.2000;
	points[36] = (-302.5736, 13993.5039, 6323.7793);
	angles[36] = (0, 14.4992, 0);
	at[36] = 41.4000;
	points[37] = (-375.9500, 14268.6221, 5883.8979);
	angles[37] = (0, 14.8502, 0);
	at[37] = 42;
	points[38] = (-377.9449, 14276.1426, 5871.9683);
	angles[38] = (0, 14.7910, 0);
	at[38] = 42.2000;
	points[39] = (-377.9449, 14276.1426, 5871.9683);
	angles[39] = (0, 14.7910, 0);
	at[39] = 43.7000;
	points[40] = (231.1886, 4655.6694, 11945);
	angles[40] = (0, -8.9491, 0);
	at[40] = 43.7000;
	points[41] = (231.1886, 4655.6694, 11945);
	angles[41] = (0, -8.9491, 0);
	at[41] = 45;
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
	points[0] = (235.3185, 5803.7798, 11965.6699);
	angles[0] = (0, 4.8512, 0);
	at[0] = 0;
	points[1] = (222.1972, 5962.9131, 11889.8818);
	angles[1] = (0, 4.6186, 0);
	at[1] = 0.2000;
	points[2] = (209.7532, 6120.8267, 11808.7012);
	angles[2] = (0, 4.1684, 0);
	at[2] = 0.4000;
	points[3] = (191.4673, 6429.2129, 11637.1660);
	angles[3] = (0, 2.2491, 0);
	at[3] = 0.8000;
	points[4] = (176.9071, 6890.2759, 11375.1182);
	angles[4] = (0, 3.4922, 0);
	at[4] = 1.4000;
	points[5] = (155.7339, 7196.6934, 11197.1650);
	angles[5] = (0, 3.5162, 0);
	at[5] = 1.8000;
	points[6] = (140.8787, 7499.4097, 11017.1650);
	angles[6] = (0, 2.3428, 0);
	at[6] = 2.2000;
	points[7] = (137.8221, 7651.8110, 10928.7803);
	angles[7] = (0, 0.1973, 0);
	at[7] = 2.4000;
	points[8] = (135.6524, 7958.9766, 10755.7490);
	angles[8] = (0, 1.9915, 0);
	at[8] = 2.8000;
	points[9] = (122.5051, 8271.0635, 10588.9766);
	angles[9] = (0, 2.2870, 0);
	at[9] = 3.2000;
	points[10] = (105.1059, 8729.2520, 10329.1338);
	angles[10] = (0, 1.8137, 0);
	at[10] = 3.8000;
	points[11] = (91.4598, 9189.1729, 10064.8027);
	angles[11] = (0, 2.1645, 0);
	at[11] = 4.4000;
	points[12] = (77.9406, 9485.7480, 9876.2998);
	angles[12] = (0, 2.7345, 0);
	at[12] = 4.8000;
	points[13] = (63.9283, 9778.6221, 9684.2520);
	angles[13] = (0, 2.7178, 0);
	at[13] = 5.2000;
	points[14] = (42.9154, 10215.9844, 9385);
	angles[14] = (0, 2.8429, 0);
	at[14] = 5.8000;
	points[15] = (19.6484, 10652.6777, 9093.2676);
	angles[15] = (0, 3.0034, 0);
	at[15] = 6.4000;
	points[16] = (12.6588, 10796.1025, 8995);
	angles[16] = (0, 2.4620, 0);
	at[16] = 6.6000;
	points[17] = (-12.4733, 11367.9922, 8588.6611);
	angles[17] = (0, 3.6392, 0);
	at[17] = 7.4000;
	points[18] = (-42.6961, 11795.5117, 8283.0713);
	angles[18] = (0, 4.0312, 0);
	at[18] = 8;
	points[19] = (-51.6693, 11935.5908, 8180.1577);
	angles[19] = (0, 3.0925, 0);
	at[19] = 8.2000;
	points[20] = (-73.1433, 12353.6230, 7861.2993);
	angles[20] = (0, 3.2396, 0);
	at[20] = 8.8000;
	points[21] = (-82.8335, 12489.8428, 7753.8193);
	angles[21] = (0, 5.4223, 0);
	at[21] = 9;
	points[22] = (-96.8256, 12624.4492, 7643.1499);
	angles[22] = (0, 6.2429, 0);
	at[22] = 9.2000;
	points[23] = (-127.0453, 12891.7334, 7418.2676);
	angles[23] = (0, 6.5004, 0);
	at[23] = 9.6000;
	points[24] = (-141.2083, 13020.9453, 7303.1895);
	angles[24] = (0, 6.0835, 0);
	at[24] = 9.8000;
	points[25] = (-183.9220, 13404.4482, 6947.3232);
	angles[25] = (0, 7.1970, 0);
	at[25] = 10.4000;
	points[26] = (-203.3319, 13527.9922, 6829.3306);
	angles[26] = (0, 10.5082, 0);
	at[26] = 10.6000;
	points[27] = (-252.8823, 13775.6299, 6587.4409);
	angles[27] = (0, 11.8451, 0);
	at[27] = 11;
	points[28] = (-278.3933, 13894.3701, 6461.4570);
	angles[28] = (0, 12.5458, 0);
	at[28] = 11.2000;
	points[29] = (-302.5736, 13993.5039, 6323.7793);
	angles[29] = (0, 14.4992, 0);
	at[29] = 11.4000;
	points[30] = (-375.9500, 14268.6221, 5883.8979);
	angles[30] = (0, 14.8502, 0);
	at[30] = 12;
	points[31] = (-377.9449, 14276.1426, 5871.9683);
	angles[31] = (0, 14.7910, 0);
	at[31] = 12.2000;
	points[32] = (-377.9449, 14276.1426, 5871.9683);
	angles[32] = (0, 14.7910, 0);
	at[32] = 13.7000;
	points[33] = (231.1886, 4655.6694, 11945);
	angles[33] = (0, -8.9491, 0);
	at[33] = 13.7000;
	points[34] = (231.1886, 4655.6694, 11945);
	angles[34] = (0, -8.9491, 0);
	at[34] = 43.6000;
	points[35] = (249.7823, 4767.3623, 11978.5039);
	angles[35] = (0, -9.4687, 0);
	at[35] = 43.8000;
	points[36] = (272.4051, 4936.7715, 12023.5439);
	angles[36] = (0, -3.6627, 0);
	at[36] = 44;
	points[37] = (280.0071, 5111.7720, 12053.6611);
	angles[37] = (0, -1.3628, 0);
	at[37] = 44.2000;
	points[38] = (271.7469, 5287.9526, 12064.4883);
	angles[38] = (0, 4.8006, 0);
	at[38] = 44.4000;
	points[39] = (258.3323, 5463.9370, 12057.3623);
	angles[39] = (0, 3.2637, 0);
	at[39] = 44.6000;
	points[40] = (248.4146, 5639.1733, 12028.9375);
	angles[40] = (0, 3.5124, 0);
	at[40] = 44.8000;
	points[41] = (235.3185, 5803.7798, 11965.6699);
	angles[41] = (0, 4.8512, 0);
	at[41] = 45;
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
	points[0] = (231.1886, 4655.6694, 11945);
	angles[0] = (0, -8.9491, 0);
	at[0] = 0;
	points[1] = (231.1886, 4655.6694, 11945);
	angles[1] = (0, -8.9491, 0);
	at[1] = 13.6000;
	points[2] = (249.7823, 4767.3623, 11978.5039);
	angles[2] = (0, -9.4687, 0);
	at[2] = 13.8000;
	points[3] = (272.4051, 4936.7715, 12023.5439);
	angles[3] = (0, -3.6627, 0);
	at[3] = 14;
	points[4] = (280.0071, 5111.7720, 12053.6611);
	angles[4] = (0, -1.3628, 0);
	at[4] = 14.2000;
	points[5] = (271.7469, 5287.9526, 12064.4883);
	angles[5] = (0, 4.8006, 0);
	at[5] = 14.4000;
	points[6] = (258.3323, 5463.9370, 12057.3623);
	angles[6] = (0, 3.2637, 0);
	at[6] = 14.6000;
	points[7] = (248.4146, 5639.1733, 12028.9375);
	angles[7] = (0, 3.5124, 0);
	at[7] = 14.8000;
	points[8] = (235.3185, 5803.7798, 11965.6699);
	angles[8] = (0, 4.8512, 0);
	at[8] = 15;
	points[9] = (222.1972, 5962.9131, 11889.8818);
	angles[9] = (0, 4.6186, 0);
	at[9] = 15.2000;
	points[10] = (209.7532, 6120.8267, 11808.7012);
	angles[10] = (0, 4.1684, 0);
	at[10] = 15.4000;
	points[11] = (191.4673, 6429.2129, 11637.1660);
	angles[11] = (0, 2.2491, 0);
	at[11] = 15.8000;
	points[12] = (176.9071, 6890.2759, 11375.1182);
	angles[12] = (0, 3.4922, 0);
	at[12] = 16.4000;
	points[13] = (155.7339, 7196.6934, 11197.1650);
	angles[13] = (0, 3.5162, 0);
	at[13] = 16.8000;
	points[14] = (140.8787, 7499.4097, 11017.1650);
	angles[14] = (0, 2.3428, 0);
	at[14] = 17.2000;
	points[15] = (137.8221, 7651.8110, 10928.7803);
	angles[15] = (0, 0.1973, 0);
	at[15] = 17.4000;
	points[16] = (135.6524, 7958.9766, 10755.7490);
	angles[16] = (0, 1.9915, 0);
	at[16] = 17.8000;
	points[17] = (122.5051, 8271.0635, 10588.9766);
	angles[17] = (0, 2.2870, 0);
	at[17] = 18.2000;
	points[18] = (105.1059, 8729.2520, 10329.1338);
	angles[18] = (0, 1.8137, 0);
	at[18] = 18.8000;
	points[19] = (91.4598, 9189.1729, 10064.8027);
	angles[19] = (0, 2.1645, 0);
	at[19] = 19.4000;
	points[20] = (77.9406, 9485.7480, 9876.2998);
	angles[20] = (0, 2.7345, 0);
	at[20] = 19.8000;
	points[21] = (63.9283, 9778.6221, 9684.2520);
	angles[21] = (0, 2.7178, 0);
	at[21] = 20.2000;
	points[22] = (42.9154, 10215.9844, 9385);
	angles[22] = (0, 2.8429, 0);
	at[22] = 20.8000;
	points[23] = (12.6588, 10796.1025, 8995);
	angles[23] = (0, 2.4620, 0);
	at[23] = 21.6000;
	points[24] = (-12.4733, 11367.9922, 8588.6611);
	angles[24] = (0, 3.6392, 0);
	at[24] = 22.4000;
	points[25] = (-42.6961, 11795.5117, 8283.0713);
	angles[25] = (0, 4.0312, 0);
	at[25] = 23;
	points[26] = (-51.6693, 11935.5908, 8180.1577);
	angles[26] = (0, 3.0925, 0);
	at[26] = 23.2000;
	points[27] = (-73.1433, 12353.6230, 7861.2993);
	angles[27] = (0, 3.2396, 0);
	at[27] = 23.8000;
	points[28] = (-82.8335, 12489.8428, 7753.8193);
	angles[28] = (0, 5.4223, 0);
	at[28] = 24;
	points[29] = (-127.0453, 12891.7334, 7418.2676);
	angles[29] = (0, 6.5004, 0);
	at[29] = 24.6000;
	points[30] = (-141.2083, 13020.9453, 7303.1895);
	angles[30] = (0, 6.0835, 0);
	at[30] = 24.8000;
	points[31] = (-168.9126, 13276.8506, 7066.8896);
	angles[31] = (0, 6.4056, 0);
	at[31] = 25.2000;
	points[32] = (-183.9220, 13404.4482, 6947.3232);
	angles[32] = (0, 7.1970, 0);
	at[32] = 25.4000;
	points[33] = (-203.3319, 13527.9922, 6829.3306);
	angles[33] = (0, 10.5082, 0);
	at[33] = 25.6000;
	points[34] = (-252.8823, 13775.6299, 6587.4409);
	angles[34] = (0, 11.8451, 0);
	at[34] = 26;
	points[35] = (-278.3933, 13894.3701, 6461.4570);
	angles[35] = (0, 12.5458, 0);
	at[35] = 26.2000;
	points[36] = (-302.5736, 13993.5039, 6323.7793);
	angles[36] = (0, 14.4992, 0);
	at[36] = 26.4000;
	points[37] = (-375.9500, 14268.6221, 5883.8979);
	angles[37] = (0, 14.8502, 0);
	at[37] = 27;
	points[38] = (-377.9449, 14276.1426, 5871.9683);
	angles[38] = (0, 14.7910, 0);
	at[38] = 27.2000;
	points[39] = (-377.9449, 14276.1426, 5871.9683);
	angles[39] = (0, 14.7910, 0);
	at[39] = 28.7000;
	points[40] = (231.1886, 4655.6694, 11945);
	angles[40] = (0, -8.9491, 0);
	at[40] = 28.7000;
	points[41] = (231.1886, 4655.6694, 11945);
	angles[41] = (0, -8.9491, 0);
	at[41] = 45;
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
	points[0] = (2924.8818, -6154.4097, 1009.9252);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2924.8818, -6154.4097, 947.9174);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (2924.8818, -6155.1968, 943.5709);
	angles[2] = (0, -180, -84.0138);
	at[2] = 0.7500;
	points[3] = (2924.8818, -6157.0864, 934.9174);
	angles[3] = (0, -180, -79.3627);
	at[3] = 0.8500;
	points[4] = (2924.8818, -6158.0317, 936.5394);
	angles[4] = (0, -180, -51.6107);
	at[4] = 0.9000;
	points[5] = (2924.8818, -6159.0156, 940.8583);
	angles[5] = (0, -180, -9.9911);
	at[5] = 0.9500;
	points[6] = (2924.8818, -6160, 945.1812);
	angles[6] = (0, -180, 27.4962);
	at[6] = 1;
	points[7] = (2924.8818, -6160.3149, 949.5709);
	angles[7] = (0, -180, 54.9605);
	at[7] = 1.0500;
	points[8] = (2924.8818, -6160.3149, 954);
	angles[8] = (0, -180, 71.7769);
	at[8] = 1.1000;
	points[9] = (2924.8818, -6160.3149, 958.4292);
	angles[9] = (0, -180, 80.6308);
	at[9] = 1.1500;
	points[10] = (2924.8818, -6160.3149, 967.6693);
	angles[10] = (0, -180, 87.5406);
	at[10] = 1.2500;
	points[11] = (2924.8818, -6160.3149, 987.1969);
	angles[11] = (0, -180, 89.6699);
	at[11] = 1.4000;
	points[12] = (2924.8818, -6160.3149, 1005.9489);
	angles[12] = (0, -180, 89.9135);
	at[12] = 1.5000;
	points[13] = (2924.8818, -6160.3149, 1031.1456);
	angles[13] = (0, -180, 89.9774);
	at[13] = 1.6000;
	points[14] = (2924.8818, -6160.3149, 1065.0079);
	angles[14] = (0, -180, 89.9940);
	at[14] = 1.7000;
	points[15] = (2924.8818, -6160.3149, 1086.0826);
	angles[15] = (0, -180, 0);
	at[15] = 1.7500;
	points[16] = (2924.8818, -6160.3149, 1138.8307);
	angles[16] = (0, -180, 0);
	at[16] = 1.8500;
	points[17] = (2924.8818, -6160.3149, 1171.6575);
	angles[17] = (0, -360, 0);
	at[17] = 1.9000;
	points[18] = (2924.8818, -6160.3149, 1287.2756);
	angles[18] = (0, -360, 0);
	at[18] = 2.0500;
	points[19] = (2924.8818, -6160.3149, 1397.1891);
	angles[19] = (0, -360, 0);
	at[19] = 2.2000;
	points[20] = (2924.8818, -6160.3149, 1460.2992);
	angles[20] = (0, -360, 0);
	at[20] = 2.3000;
	points[21] = (2924.8818, -6160.3149, 1486.4055);
	angles[21] = (0, -360, 0);
	at[21] = 2.3500;
	points[22] = (2924.8818, -6160.3149, 1505.9529);
	angles[22] = (0, -360, 0);
	at[22] = 2.4000;
	points[23] = (2924.8818, -6160.3149, 1519.7441);
	angles[23] = (0, -360, 0);
	at[23] = 2.4500;
	points[24] = (2924.8818, -6159.7246, 1529.3070);
	angles[24] = (0, -360, 86.9301);
	at[24] = 2.5000;
	points[25] = (2924.8818, -6157.8740, 1541.6299);
	angles[25] = (0, -360, 82.8957);
	at[25] = 2.6000;
	points[26] = (2924.8818, -6157.2837, 1545.6417);
	angles[26] = (0, -360, 77.2001);
	at[26] = 2.6500;
	points[27] = (2924.8818, -6156.6934, 1540.2284);
	angles[27] = (0, -360, 51.4266);
	at[27] = 2.7000;
	points[28] = (2924.8818, -6154.9214, 1528.4213);
	angles[28] = (0, -360, -28.1620);
	at[28] = 2.8000;
	points[29] = (2924.8818, -6154.4097, 1519.7875);
	angles[29] = (0, -360, -55.8286);
	at[29] = 2.8500;
	points[30] = (2924.8818, -6154.4097, 1508.0867);
	angles[30] = (0, -360, -72.2422);
	at[30] = 2.9000;
	points[31] = (2924.8818, -6154.4097, 1492.1378);
	angles[31] = (0, -360, -80.8720);
	at[31] = 2.9500;
	points[32] = (2924.8818, -6154.4097, 1470.6497);
	angles[32] = (0, -360, -85.3217);
	at[32] = 3;
	points[33] = (2924.8818, -6154.4097, 1442.9725);
	angles[33] = (0, -360, -87.6039);
	at[33] = 3.0500;
	points[34] = (2924.8818, -6154.4097, 1410.3190);
	angles[34] = (0, -360, -88.7732);
	at[34] = 3.1000;
	points[35] = (2924.8818, -6154.4097, 1337.0984);
	angles[35] = (0, -360, -89.6783);
	at[35] = 3.2000;
	points[36] = (2924.8818, -6154.4097, 1307.1812);
	angles[36] = (0, -360, -89.8353);
	at[36] = 3.2500;
	points[37] = (2924.8818, -6154.4097, 1260.1771);
	angles[37] = (0, -360, -89.9568);
	at[37] = 3.3500;
	points[38] = (2924.8818, -6154.4097, 1241.8464);
	angles[38] = (0, -360, -89.9778);
	at[38] = 3.4000;
	points[39] = (2924.8818, -6154.4097, 1213.0472);
	angles[39] = (0, -360, -89.9942);
	at[39] = 3.5000;
	points[40] = (2924.8818, -6154.4097, 1201.8110);
	angles[40] = (0, -360, 0);
	at[40] = 3.5500;
	points[41] = (2924.8818, -6154.4097, 1192.2677);
	angles[41] = (0, -360, 0);
	at[41] = 3.6000;
	points[42] = (2924.8818, -6154.4097, 1177.2795);
	angles[42] = (0, -360, 0);
	at[42] = 3.7000;
	points[43] = (2924.8818, -6154.4097, 1166.4685);
	angles[43] = (0, -360, 0);
	at[43] = 3.8000;
	points[44] = (2924.8818, -6154.4097, 1009.9252);
	angles[44] = (0, -360, 0);
	at[44] = 5.5667;
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
	points[0] = (3308.7402, -5741.0239, 985.6890);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3308.7402, -5741.0239, 919.2520);
	angles[1] = (0, 0, 0);
	at[1] = 0.7500;
	points[2] = (3308.7402, -5741.6143, 914.8859);
	angles[2] = (0, -180, -85.5872);
	at[2] = 0.8000;
	points[3] = (3308.7402, -5743.5039, 906.2322);
	angles[3] = (0, -180, -79.7760);
	at[3] = 0.9000;
	points[4] = (3308.7402, -5744.4487, 906.1693);
	angles[4] = (0, -180, -62.8248);
	at[4] = 0.9500;
	points[5] = (3308.7402, -5746.4175, 914.8110);
	angles[5] = (0, -180, 16.4839);
	at[5] = 1.0500;
	points[6] = (3308.7402, -5746.9292, 919.1812);
	angles[6] = (0, -180, 48.3117);
	at[6] = 1.1000;
	points[7] = (3308.7402, -5746.9292, 923.6102);
	angles[7] = (0, -180, 68.1736);
	at[7] = 1.1500;
	points[8] = (3308.7402, -5746.9292, 928.0394);
	angles[8] = (0, -180, 78.7577);
	at[8] = 1.2000;
	points[9] = (3308.7402, -5746.9292, 937.1417);
	angles[9] = (0, -180, 87.0470);
	at[9] = 1.3000;
	points[10] = (3308.7402, -5746.9292, 956.1141);
	angles[10] = (0, -180, 89.6035);
	at[10] = 1.4500;
	points[11] = (3308.7402, -5746.9292, 974.3268);
	angles[11] = (0, -180, 89.8961);
	at[11] = 1.5500;
	points[12] = (3308.7402, -5746.9292, 998.8071);
	angles[12] = (0, -180, 89.9728);
	at[12] = 1.6500;
	points[13] = (3308.7402, -5746.9292, 1031.7008);
	angles[13] = (0, -180, 89.9929);
	at[13] = 1.7500;
	points[14] = (3308.7402, -5746.9292, 1052.1732);
	angles[14] = (0, -180, 0);
	at[14] = 1.8000;
	points[15] = (3308.7402, -5746.9292, 1103.4133);
	angles[15] = (0, -180, 0);
	at[15] = 1.9000;
	points[16] = (3308.7402, -5746.9292, 1135.3032);
	angles[16] = (0, -360, 0);
	at[16] = 1.9500;
	points[17] = (3308.7402, -5746.9292, 1287.8741);
	angles[17] = (0, -360, 0);
	at[17] = 2.1500;
	points[18] = (3308.7402, -5746.9292, 1360.6339);
	angles[18] = (0, -360, 0);
	at[18] = 2.2500;
	points[19] = (3308.7402, -5746.9292, 1394.6969);
	angles[19] = (0, -360, 0);
	at[19] = 2.3000;
	points[20] = (3308.7402, -5746.9292, 1452.1852);
	angles[20] = (0, -360, 0);
	at[20] = 2.4000;
	points[21] = (3308.7402, -5746.9292, 1473.0118);
	angles[21] = (0, -360, 0);
	at[21] = 2.4500;
	points[22] = (3308.7402, -5746.9292, 1487.8505);
	angles[22] = (0, -360, 0);
	at[22] = 2.5000;
	points[23] = (3308.7402, -5746.9292, 1498.1497);
	angles[23] = (0, -360, 88.2953);
	at[23] = 2.5500;
	points[24] = (3308.7402, -5743.9766, 1515.3977);
	angles[24] = (0, -360, 82.3794);
	at[24] = 2.7000;
	points[25] = (3308.7402, -5743.4253, 1511.6182);
	angles[25] = (0, -360, 61.9515);
	at[25] = 2.7500;
	points[26] = (3308.7402, -5742.7168, 1506.7126);
	angles[26] = (0, -360, 25.1573);
	at[26] = 2.8000;
	points[27] = (3308.7402, -5741.7720, 1500.4055);
	angles[27] = (0, -360, -16.5731);
	at[27] = 2.8500;
	points[28] = (3308.7402, -5741.0239, 1492.2638);
	angles[28] = (0, -360, -48.7938);
	at[28] = 2.9000;
	points[29] = (3308.7402, -5741.0239, 1481.2914);
	angles[29] = (0, -360, -68.4374);
	at[29] = 2.9500;
	points[30] = (3308.7402, -5741.0239, 1466.3346);
	angles[30] = (0, -360, -78.8952);
	at[30] = 3;
	points[31] = (3308.7402, -5741.0239, 1446.1104);
	angles[31] = (0, -360, -84.3056);
	at[31] = 3.0500;
	points[32] = (3308.7402, -5741.0239, 1419.1891);
	angles[32] = (0, -360, -87.0834);
	at[32] = 3.1000;
	points[33] = (3308.7402, -5741.0239, 1347.3071);
	angles[33] = (0, -360, -89.2352);
	at[33] = 3.2000;
	points[34] = (3308.7402, -5741.0239, 1315.8503);
	angles[34] = (0, -360, -89.6085);
	at[34] = 3.2500;
	points[35] = (3308.7402, -5741.0239, 1289.1300);
	angles[35] = (0, -360, -89.7996);
	at[35] = 3.3000;
	points[36] = (3308.7402, -5741.0239, 1247.1575);
	angles[36] = (0, -360, -89.9474);
	at[36] = 3.4000;
	points[37] = (3308.7402, -5741.0239, 1230.7834);
	angles[37] = (0, -360, -89.9731);
	at[37] = 3.4500;
	points[38] = (3308.7402, -5741.0239, 1205.0669);
	angles[38] = (0, -360, -89.9929);
	at[38] = 3.5500;
	points[39] = (3308.7402, -5741.0239, 1195.0355);
	angles[39] = (0, -360, 0);
	at[39] = 3.6000;
	points[40] = (3308.7402, -5741.0239, 1186.5118);
	angles[40] = (0, -360, 0);
	at[40] = 3.6500;
	points[41] = (3308.7402, -5741.0239, 1167.9055);
	angles[41] = (0, -360, 0);
	at[41] = 3.8000;
	points[42] = (3308.7402, -5741.0239, 985.6890);
	angles[42] = (0, -360, 0);
	at[42] = 5.8667;
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
	points[0] = (3205.3938, -4441.8110, 491.4606);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3205.3938, -4441.8110, 447.1653);
	angles[1] = (0, 0, 0);
	at[1] = 0.5000;
	points[2] = (3205.3938, -4442.3228, 442.7953);
	angles[2] = (0, -180, -85.5872);
	at[2] = 0.5500;
	points[3] = (3205.3938, -4444.2129, 434.1378);
	angles[3] = (0, -180, -79.7760);
	at[3] = 0.6500;
	points[4] = (3205.3938, -4445.1572, 433.3819);
	angles[4] = (0, -180, -62.8248);
	at[4] = 0.7000;
	points[5] = (3205.3938, -4447.1260, 442.0236);
	angles[5] = (0, -180, 16.4839);
	at[5] = 0.8000;
	points[6] = (3205.3938, -4447.7168, 446.3858);
	angles[6] = (0, -180, 48.3117);
	at[6] = 0.8500;
	points[7] = (3205.3938, -4447.7168, 450.8150);
	angles[7] = (0, -180, 68.1736);
	at[7] = 0.9000;
	points[8] = (3205.3938, -4447.7168, 455.2441);
	angles[8] = (0, -180, 78.7577);
	at[8] = 0.9500;
	points[9] = (3205.3938, -4447.7168, 464.3031);
	angles[9] = (0, -180, 87.0470);
	at[9] = 1.0500;
	points[10] = (3205.3938, -4447.7168, 483.0512);
	angles[10] = (0, -180, 89.6035);
	at[10] = 1.2000;
	points[11] = (3205.3938, -4447.7168, 512.2599);
	angles[11] = (0, -180, 89.9467);
	at[11] = 1.3500;
	points[12] = (3205.3938, -4447.7168, 540.3071);
	angles[12] = (0, -180, 89.9861);
	at[12] = 1.4500;
	points[13] = (3205.3938, -4447.7168, 557.7598);
	angles[13] = (0, -180, 89.9929);
	at[13] = 1.5000;
	points[14] = (3205.3938, -4447.7168, 577.9921);
	angles[14] = (0, -180, 0);
	at[14] = 1.5500;
	points[15] = (3205.3938, -4447.7168, 628.6339);
	angles[15] = (0, -180, 0);
	at[15] = 1.6500;
	points[16] = (3205.3938, -4447.7168, 660.1496);
	angles[16] = (0, -360, 0);
	at[16] = 1.7000;
	points[17] = (3205.3938, -4447.7168, 812.5001);
	angles[17] = (0, -360, 0);
	at[17] = 1.9000;
	points[18] = (3205.3938, -4447.7168, 885.3898);
	angles[18] = (0, -360, 0);
	at[18] = 2;
	points[19] = (3205.3938, -4447.7168, 919.6968);
	angles[19] = (0, -360, 0);
	at[19] = 2.0500;
	points[20] = (3205.3938, -4447.7168, 977.8347);
	angles[20] = (0, -360, 0);
	at[20] = 2.1500;
	points[21] = (3205.3938, -4447.7168, 999.1772);
	angles[21] = (0, -360, 0);
	at[21] = 2.2000;
	points[22] = (3205.3938, -4447.7168, 1014.4410);
	angles[22] = (0, -360, 0);
	at[22] = 2.2500;
	points[23] = (3205.3938, -4447.7168, 1025.0354);
	angles[23] = (0, -360, 88.2953);
	at[23] = 2.3000;
	points[24] = (3205.3938, -4444.8032, 1042.6693);
	angles[24] = (0, -360, 82.3794);
	at[24] = 2.4500;
	points[25] = (3205.3938, -4444.2520, 1039.4843);
	angles[25] = (0, -360, 61.9516);
	at[25] = 2.5000;
	points[26] = (3205.3938, -4443.5435, 1034.6693);
	angles[26] = (0, -360, 25.1576);
	at[26] = 2.5500;
	points[27] = (3205.3938, -4442.6382, 1028.4764);
	angles[27] = (0, -360, -16.5730);
	at[27] = 2.6000;
	points[28] = (3205.3938, -4441.4570, 1020.5158);
	angles[28] = (0, -360, -47.7564);
	at[28] = 2.6500;
	points[29] = (3205.3938, -4441.8110, 1009.7559);
	angles[29] = (0, -360, -67.8692);
	at[29] = 2.7000;
	points[30] = (3205.3938, -4441.8110, 995.1299);
	angles[30] = (0, -360, -78.5990);
	at[30] = 2.7500;
	points[31] = (3205.3938, -4441.8110, 975.3268);
	angles[31] = (0, -360, -84.1531);
	at[31] = 2.8000;
	points[32] = (3205.3938, -4441.8110, 949.3898);
	angles[32] = (0, -360, -87.0051);
	at[32] = 2.8500;
	points[33] = (3205.3938, -4441.8110, 888.1733);
	angles[33] = (0, -360, -89.2148);
	at[33] = 2.9500;
	points[34] = (3205.3938, -4441.8110, 778.6221);
	angles[34] = (0, -360, -89.8946);
	at[34] = 3.1000;
	points[35] = (3205.3938, -4441.8110, 748.3189);
	angles[35] = (0, -360, -89.9461);
	at[35] = 3.1500;
	points[36] = (3205.3938, -4441.8110, 722.5787);
	angles[36] = (0, -360, -89.9723);
	at[36] = 3.2000;
	points[37] = (3205.3938, -4441.8110, 682.1457);
	angles[37] = (0, -360, -89.9928);
	at[37] = 3.3000;
	points[38] = (3205.3938, -4441.8110, 666.3740);
	angles[38] = (0, -360, 0);
	at[38] = 3.3500;
	points[39] = (3205.3938, -4441.8110, 641.5984);
	angles[39] = (0, -360, 0);
	at[39] = 3.4500;
	points[40] = (3205.3938, -4441.8110, 623.7283);
	angles[40] = (0, -360, 0);
	at[40] = 3.5500;
	points[41] = (3205.3938, -4441.8110, 605.8032);
	angles[41] = (0, -360, 0);
	at[41] = 3.7000;
	points[42] = (3205.3938, -4441.8110, 491.4606);
	angles[42] = (0, -360, 0);
	at[42] = 5;
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
	points[0] = (3397.3228, -3939.8425, 507.4134);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3397.3228, -3939.8425, 476.4094);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (3397.3228, -3940.4331, 472.0394);
	angles[2] = (0, -180, -85.5872);
	at[2] = 0.4000;
	points[3] = (3397.3228, -3942.3230, 463.3859);
	angles[3] = (0, -180, -79.7760);
	at[3] = 0.5000;
	points[4] = (3397.3228, -3943.2676, 463.1890);
	angles[4] = (0, -180, -62.8248);
	at[4] = 0.5500;
	points[5] = (3397.3228, -3945.1970, 471.8307);
	angles[5] = (0, -180, 16.4839);
	at[5] = 0.6500;
	points[6] = (3397.3228, -3945.7480, 476.2008);
	angles[6] = (0, -180, 48.3117);
	at[6] = 0.7000;
	points[7] = (3397.3228, -3945.7480, 480.6299);
	angles[7] = (0, -180, 68.1736);
	at[7] = 0.7500;
	points[8] = (3397.3228, -3945.7480, 485.0591);
	angles[8] = (0, -180, 78.7577);
	at[8] = 0.8000;
	points[9] = (3397.3228, -3945.7480, 494.1496);
	angles[9] = (0, -180, 87.0470);
	at[9] = 0.9000;
	points[10] = (3397.3228, -3945.7480, 513.0748);
	angles[10] = (0, -180, 89.6035);
	at[10] = 1.0500;
	points[11] = (3397.3228, -3945.7480, 542.5591);
	angles[11] = (0, -180, 89.9467);
	at[11] = 1.2000;
	points[12] = (3397.3228, -3945.7480, 570.8701);
	angles[12] = (0, -180, 89.9861);
	at[12] = 1.3000;
	points[13] = (3397.3228, -3945.7480, 588.4882);
	angles[13] = (0, -180, 89.9929);
	at[13] = 1.3500;
	points[14] = (3397.3228, -3945.7480, 608.9134);
	angles[14] = (0, -180, 0);
	at[14] = 1.4000;
	points[15] = (3397.3228, -3945.7480, 660.0355);
	angles[15] = (0, -180, 0);
	at[15] = 1.5000;
	points[16] = (3397.3228, -3945.7480, 691.8504);
	angles[16] = (0, -360, 0);
	at[16] = 1.5500;
	points[17] = (3397.3228, -3945.7480, 844.3780);
	angles[17] = (0, -360, 0);
	at[17] = 1.7500;
	points[18] = (3397.3228, -3945.7480, 917.1653);
	angles[18] = (0, -360, 0);
	at[18] = 1.8500;
	points[19] = (3397.3228, -3945.7480, 951.2874);
	angles[19] = (0, -360, 0);
	at[19] = 1.9000;
	points[20] = (3397.3228, -3945.7480, 1008.9016);
	angles[20] = (0, -360, 0);
	at[20] = 2;
	points[21] = (3397.3228, -3945.7480, 1029.8268);
	angles[21] = (0, -360, 0);
	at[21] = 2.0500;
	points[22] = (3397.3228, -3945.7480, 1044.7480);
	angles[22] = (0, -360, 0);
	at[22] = 2.1000;
	points[23] = (3397.3228, -3945.7480, 1055.1063);
	angles[23] = (0, -360, 88.2953);
	at[23] = 2.1500;
	points[24] = (3397.3228, -3942.7954, 1072.4292);
	angles[24] = (0, -360, 82.3794);
	at[24] = 2.3000;
	points[25] = (3397.3228, -3942.2444, 1068.7638);
	angles[25] = (0, -360, 61.9516);
	at[25] = 2.3500;
	points[26] = (3397.3228, -3941.5354, 1063.8740);
	angles[26] = (0, -360, 25.1576);
	at[26] = 2.4000;
	points[27] = (3397.3228, -3940.5908, 1057.5906);
	angles[27] = (0, -360, -16.5730);
	at[27] = 2.4500;
	points[28] = (3397.3228, -3939.4094, 1049.5157);
	angles[28] = (0, -360, -47.7564);
	at[28] = 2.5000;
	points[29] = (3397.3228, -3939.8425, 1038.5591);
	angles[29] = (0, -360, -67.8692);
	at[29] = 2.5500;
	points[30] = (3397.3228, -3939.8425, 1023.6654);
	angles[30] = (0, -360, -78.5990);
	at[30] = 2.6000;
	points[31] = (3397.3228, -3939.8425, 1003.5275);
	angles[31] = (0, -360, -84.1531);
	at[31] = 2.6500;
	points[32] = (3397.3228, -3939.8425, 977.4330);
	angles[32] = (0, -360, -87.0051);
	at[32] = 2.7000;
	points[33] = (3397.3228, -3939.8425, 918.5118);
	angles[33] = (0, -360, -89.2148);
	at[33] = 2.8000;
	points[34] = (3397.3228, -3939.8425, 851.2165);
	angles[34] = (0, -360, -89.7943);
	at[34] = 2.9000;
	points[35] = (3397.3228, -3939.8425, 775.1693);
	angles[35] = (0, -360, -89.9461);
	at[35] = 3;
	points[36] = (3397.3228, -3939.8425, 740.9370);
	angles[36] = (0, -360, -89.9723);
	at[36] = 3.0500;
	points[37] = (3397.3228, -3939.8425, 711.8583);
	angles[37] = (0, -360, -89.9859);
	at[37] = 3.1000;
	points[38] = (3397.3228, -3939.8425, 687.1654);
	angles[38] = (0, -360, -89.9927);
	at[38] = 3.1500;
	points[39] = (3397.3228, -3939.8425, 666.1890);
	angles[39] = (0, -360, 0);
	at[39] = 3.2000;
	points[40] = (3397.3228, -3939.8425, 633.2401);
	angles[40] = (0, -360, 0);
	at[40] = 3.3000;
	points[41] = (3397.3228, -3939.8425, 600.1968);
	angles[41] = (0, -360, 0);
	at[41] = 3.4500;
	points[42] = (3397.3228, -3939.8425, 579.9488);
	angles[42] = (0, -360, 0);
	at[42] = 3.6000;
	points[43] = (3397.3228, -3939.8425, 507.4134);
	angles[43] = (0, -360, 0);
	at[43] = 4.4167;
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
	points[0] = (2154.5276, -7399.7246, 1748.1458);
	angles[0] = (0, 90, -28.1619);
	at[0] = 0;
	points[1] = (2154.0354, -7399.7246, 1739.4449);
	angles[1] = (0, 90, -55.8285);
	at[1] = 0.0500;
	points[2] = (2154.0354, -7399.7246, 1727.6456);
	angles[2] = (0, 90, -72.2422);
	at[2] = 0.1000;
	points[3] = (2154.0354, -7399.7246, 1711.5670);
	angles[3] = (0, 90, -80.8719);
	at[3] = 0.1500;
	points[4] = (2154.0354, -7399.7246, 1689.9135);
	angles[4] = (0, 90, -85.3217);
	at[4] = 0.2000;
	points[5] = (2154.0354, -7399.7246, 1662.0826);
	angles[5] = (0, 90, -87.6040);
	at[5] = 0.2500;
	points[6] = (2154.0354, -7399.7246, 1629.2874);
	angles[6] = (0, 90, -88.7731);
	at[6] = 0.3000;
	points[7] = (2154.0354, -7399.7246, 1555.3859);
	angles[7] = (0, 90, -89.6785);
	at[7] = 0.4000;
	points[8] = (2154.0354, -7399.7246, 1524.1378);
	angles[8] = (0, 90, -89.8353);
	at[8] = 0.4500;
	points[9] = (2154.0354, -7399.7246, 1496.8701);
	angles[9] = (0, 90, -89.9157);
	at[9] = 0.5000;
	points[10] = (2154.0354, -7399.7246, 1452.3268);
	angles[10] = (0, 90, -89.9780);
	at[10] = 0.6000;
	points[11] = (2154.0354, -7399.7246, 1418.4174);
	angles[11] = (0, 90, -89.9943);
	at[11] = 0.7000;
	points[12] = (2154.0354, -7399.7246, 1404.6300);
	angles[12] = (0, 90, 0);
	at[12] = 0.7500;
	points[13] = (2154.0354, -7399.7246, 1382.1063);
	angles[13] = (0, 90, 0);
	at[13] = 0.8500;
	points[14] = (2154.0354, -7399.7246, 1372.9487);
	angles[14] = (0, 0, 0);
	at[14] = 0.9000;
	points[15] = (2154.0354, -7399.7246, 1357.9883);
	angles[15] = (0, 0, 0);
	at[15] = 1;
	points[16] = (2154.0354, -7399.7246, 1341.9685);
	angles[16] = (0, 0, 0);
	at[16] = 1.1500;
	points[17] = (2154.0354, -7399.7246, 1169.2323);
	angles[17] = (0, 0, 0);
	at[17] = 3.1000;
	points[18] = (2154.5120, -7399.7246, 1164.8544);
	angles[18] = (0, -90, -85.5873);
	at[18] = 3.1500;
	points[19] = (2156.3977, -7399.7246, 1156.2008);
	angles[19] = (0, -90, -79.7763);
	at[19] = 3.2500;
	points[20] = (2157.3503, -7399.7246, 1155.1102);
	angles[20] = (0, -90, -62.8254);
	at[20] = 3.3000;
	points[21] = (2159.2954, -7399.7246, 1163.7520);
	angles[21] = (0, -90, 16.4832);
	at[21] = 3.4000;
	points[22] = (2159.9409, -7399.7246, 1168.1102);
	angles[22] = (0, -90, 48.3113);
	at[22] = 3.4500;
	points[23] = (2159.9409, -7399.7246, 1172.5393);
	angles[23] = (0, -90, 68.1735);
	at[23] = 3.5000;
	points[24] = (2159.9409, -7399.7246, 1176.9685);
	angles[24] = (0, -90, 78.7576);
	at[24] = 3.5500;
	points[25] = (2159.9409, -7399.7246, 1181.3976);
	angles[25] = (0, -90, 84.2347);
	at[25] = 3.6000;
	points[26] = (2159.9409, -7399.7246, 1191.7126);
	angles[26] = (0, -90, 88.4879);
	at[26] = 3.7000;
	points[27] = (2159.9409, -7399.7246, 1217.0039);
	angles[27] = (0, -90, 89.7971);
	at[27] = 3.8500;
	points[28] = (2159.9409, -7399.7246, 1244.1969);
	angles[28] = (0, -90, 89.9468);
	at[28] = 3.9500;
	points[29] = (2159.9409, -7399.7246, 1262.3110);
	angles[29] = (0, -90, 89.9727);
	at[29] = 4;
	points[30] = (2159.9409, -7399.7246, 1284.3151);
	angles[30] = (0, -90, 89.9860);
	at[30] = 4.0500;
	points[31] = (2159.9409, -7399.7246, 1311.0355);
	angles[31] = (0, -90, 89.9929);
	at[31] = 4.1000;
	points[32] = (2159.9409, -7399.7246, 1343.4921);
	angles[32] = (0, -90, 0);
	at[32] = 4.1500;
	points[33] = (2159.9409, -7399.7246, 1421.1930);
	angles[33] = (0, -90, 0);
	at[33] = 4.2500;
	points[34] = (2159.9409, -7399.7246, 1459.4331);
	angles[34] = (0, 0, 0);
	at[34] = 4.3000;
	points[35] = (2159.9409, -7399.7246, 1603.6378);
	angles[35] = (0, 0, 0);
	at[35] = 4.5000;
	points[36] = (2159.9409, -7399.7246, 1665.2756);
	angles[36] = (0, 0, 0);
	at[36] = 4.6000;
	points[37] = (2159.9409, -7399.7246, 1692.9331);
	angles[37] = (0, 0, 0);
	at[37] = 4.6500;
	points[38] = (2159.9409, -7399.7246, 1716.1182);
	angles[38] = (0, 0, 0);
	at[38] = 4.7000;
	points[39] = (2159.9409, -7399.7246, 1732.8583);
	angles[39] = (0, 0, 0);
	at[39] = 4.7500;
	points[40] = (2159.9409, -7399.7246, 1744.5197);
	angles[40] = (0, 0, 0);
	at[40] = 4.8000;
	points[41] = (2158.8149, -7399.7246, 1752.7086);
	angles[41] = (0, 90, 85.8371);
	at[41] = 4.8500;
	points[42] = (2157.1890, -7399.7246, 1763.5433);
	angles[42] = (0, 90, 82.6089);
	at[42] = 4.9500;
	points[43] = (2156.6890, -7399.7246, 1762.8425);
	angles[43] = (0, 90, 70.4863);
	at[43] = 5;
	points[44] = (2156.0435, -7399.7246, 1758.4409);
	angles[44] = (0, 90, 39.0052);
	at[44] = 5.0500;
	points[45] = (2155.2085, -7399.7246, 1752.7875);
	angles[45] = (0, 90, -3.4710);
	at[45] = 5.1000;
	points[46] = (2154.5276, -7399.7246, 1748.1458);
	angles[46] = (0, 90, -28.1619);
	at[46] = 5.1333;
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
	points[0] = (668.8032, -7936.2598, 1198.3307);
	angles[0] = (0, -90, 48.3113);
	at[0] = 0;
	points[1] = (668.8032, -7936.2598, 1202.7599);
	angles[1] = (0, -90, 68.1734);
	at[1] = 0.0500;
	points[2] = (668.8032, -7936.2598, 1207.1890);
	angles[2] = (0, -90, 78.7576);
	at[2] = 0.1000;
	points[3] = (668.8032, -7936.2598, 1211.6182);
	angles[3] = (0, -90, 84.2347);
	at[3] = 0.1500;
	points[4] = (668.8032, -7936.2598, 1229.2834);
	angles[4] = (0, -90, 89.2257);
	at[4] = 0.3000;
	points[5] = (668.8032, -7936.2598, 1248.2874);
	angles[5] = (0, -90, 89.7971);
	at[5] = 0.4000;
	points[6] = (668.8032, -7936.2598, 1276.3149);
	angles[6] = (0, -90, 89.9468);
	at[6] = 0.5000;
	points[7] = (668.8032, -7936.2598, 1294.9843);
	angles[7] = (0, -90, 89.9727);
	at[7] = 0.5500;
	points[8] = (668.8032, -7936.2598, 1317.6615);
	angles[8] = (0, -90, 89.9860);
	at[8] = 0.6000;
	points[9] = (668.8032, -7936.2598, 1345.2048);
	angles[9] = (0, -90, 89.9929);
	at[9] = 0.6500;
	points[10] = (668.8032, -7936.2598, 1378.6575);
	angles[10] = (0, -90, 0);
	at[10] = 0.7000;
	points[11] = (668.8032, -7936.2598, 1456.7007);
	angles[11] = (0, -90, 0);
	at[11] = 0.8000;
	points[12] = (668.8032, -7936.2598, 1494.8149);
	angles[12] = (0, 0, 0);
	at[12] = 0.8500;
	points[13] = (668.8032, -7936.2598, 1604.3542);
	angles[13] = (0, 0, 0);
	at[13] = 1;
	points[14] = (668.8032, -7936.2598, 1669.8427);
	angles[14] = (0, 0, 0);
	at[14] = 1.1000;
	points[15] = (668.8032, -7936.2598, 1726.5787);
	angles[15] = (0, 0, 0);
	at[15] = 1.2000;
	points[16] = (668.8032, -7936.2598, 1748.6495);
	angles[16] = (0, 0, 0);
	at[16] = 1.2500;
	points[17] = (668.8032, -7936.2598, 1764.5079);
	angles[17] = (0, 0, 0);
	at[17] = 1.3000;
	points[18] = (668.8032, -7936.2598, 1775.5157);
	angles[18] = (0, 90, 88.2953);
	at[18] = 1.3500;
	points[19] = (665.9567, -7936.2598, 1793.6890);
	angles[19] = (0, 90, 82.3794);
	at[19] = 1.5000;
	points[20] = (665.4016, -7936.2598, 1791.3386);
	angles[20] = (0, 90, 61.9514);
	at[20] = 1.5500;
	points[21] = (664.7126, -7936.2598, 1786.6456);
	angles[21] = (0, 90, 25.1574);
	at[21] = 1.6000;
	points[22] = (663.8228, -7936.2598, 1780.6143);
	angles[22] = (0, 90, -16.5731);
	at[22] = 1.6500;
	points[23] = (662.6850, -7936.2598, 1772.8584);
	angles[23] = (0, 90, -47.7565);
	at[23] = 1.7000;
	points[24] = (662.9016, -7936.2598, 1762.4489);
	angles[24] = (0, 90, -67.8693);
	at[24] = 1.7500;
	points[25] = (662.9016, -7936.2598, 1748.2795);
	angles[25] = (0, 90, -78.5990);
	at[25] = 1.8000;
	points[26] = (662.9016, -7936.2598, 1729.0748);
	angles[26] = (0, 90, -84.1532);
	at[26] = 1.8500;
	points[27] = (662.9016, -7936.2598, 1703.5946);
	angles[27] = (0, 90, -87.0051);
	at[27] = 1.9000;
	points[28] = (662.9016, -7936.2598, 1672.9135);
	angles[28] = (0, 90, -88.4664);
	at[28] = 1.9500;
	points[29] = (662.9016, -7936.2598, 1598.9489);
	angles[29] = (0, 90, -89.5980);
	at[29] = 2.0500;
	points[30] = (662.9016, -7936.2598, 1565.9135);
	angles[30] = (0, 90, -89.7942);
	at[30] = 2.1000;
	points[31] = (662.9016, -7936.2598, 1537.0867);
	angles[31] = (0, 90, -89.8946);
	at[31] = 2.1500;
	points[32] = (662.9016, -7936.2598, 1489.9882);
	angles[32] = (0, 90, -89.9723);
	at[32] = 2.2500;
	points[33] = (662.9016, -7936.2598, 1454.1378);
	angles[33] = (0, 90, -89.9927);
	at[33] = 2.3500;
	points[34] = (662.9016, -7936.2598, 1439.5591);
	angles[34] = (0, 90, 0);
	at[34] = 2.4000;
	points[35] = (662.9016, -7936.2598, 1415.7480);
	angles[35] = (0, 90, 0);
	at[35] = 2.5000;
	points[36] = (662.9016, -7936.2598, 1406.0669);
	angles[36] = (0, 0, 0);
	at[36] = 2.5500;
	points[37] = (662.9016, -7936.2598, 1397.6182);
	angles[37] = (0, 0, 0);
	at[37] = 2.6000;
	points[38] = (662.9016, -7936.2598, 1373.3149);
	angles[38] = (0, 0, 0);
	at[38] = 2.8000;
	points[39] = (662.9016, -7936.2598, 1200.5630);
	angles[39] = (0, 0, 0);
	at[39] = 4.7500;
	points[40] = (662.9016, -7936.2598, 1196.1339);
	angles[40] = (0, -90, -87.5508);
	at[40] = 4.8000;
	points[41] = (665.8228, -7936.2598, 1183.1614);
	angles[41] = (0, -90, -79.0321);
	at[41] = 4.9500;
	points[42] = (666.6929, -7936.2598, 1186.7520);
	angles[42] = (0, -90, -51.6115);
	at[42] = 5;
	points[43] = (667.6653, -7936.2598, 1191.0748);
	angles[43] = (0, -90, -9.9921);
	at[43] = 5.0500;
	points[44] = (668.6378, -7936.2598, 1195.3938);
	angles[44] = (0, -90, 27.4956);
	at[44] = 5.1000;
	points[45] = (668.8032, -7936.2598, 1198.3307);
	angles[45] = (0, -90, 48.3113);
	at[45] = 5.1333;
	mover = getEnt("iz_obj_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3209.3701, -23.9486, 8904.2920);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3209.3701, -23.9486, 8904.2920);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-3209.3701, -23.9486, 8936.7324);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-3209.3701, -23.9486, 8979.4092);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-3209.3701, -23.9486, 9058.0322);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-3209.3701, -23.9486, 9127.5986);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-3209.3701, -23.9486, 9158.9365);
	angles[6] = (0, 0, 0);
	at[6] = 1.2000;
	points[7] = (-3209.3701, -23.9486, 9214.8818);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-3209.3701, -23.9486, 9261.7715);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-3209.3701, -23.9486, 9299.5674);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-3209.3701, -23.9486, 9315.0400);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (-3209.3701, -23.9486, 9339.2520);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-3209.3701, -23.9486, 9354.3701);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-3209.3701, -23.9486, 9363.5830);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-3209.3701, -23.9486, 9371.4961);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-3209.3701, -23.9486, 9375.1973);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-3209.3701, -23.9486, 9373.3076);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-3209.3701, -23.9486, 9349.5674);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (-3209.3701, -23.9486, 9345.8662);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (-3209.3701, -23.9486, 9347.7559);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (-3209.3701, -23.9486, 9371.4961);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (-3209.3701, -23.9486, 9375.1973);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (-3209.3701, -23.9486, 9373.3076);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (-3209.3701, -23.9486, 9349.5674);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (-3209.3701, -23.9486, 9345.8662);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (-3209.3701, -23.9486, 9347.7559);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (-3209.3701, -23.9486, 9371.4961);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (-3209.3701, -23.9486, 9375.1973);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (-3209.3701, -23.9486, 9373.3076);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (-3209.3701, -23.9486, 9349.5674);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (-3209.3701, -23.9486, 9345.8662);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (-3209.3701, -23.9486, 9347.7559);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (-3209.3701, -23.9486, 9371.4961);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (-3209.3701, -23.9486, 9375.1973);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (-3209.3701, -23.9486, 9373.3076);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (-3209.3701, -23.9486, 9349.5674);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (-3209.3701, -23.9486, 9345.2363);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (-3209.3701, -23.9486, 8906.8115);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (-3209.3701, -23.9486, 8904.2920);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (-3209.3701, -23.9486, 8904.2920);
	angles[39] = (0, 0, 0);
	at[39] = 10.0167;
	mover = getEnt("iz_obj_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4900.9844, 318.4724, 8804.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4900.9844, 318.4724, 8804.0947);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (-4900.9844, 318.4724, 8844.6064);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (-4900.9844, 318.4724, 8948.5430);
	angles[3] = (0, 0, 0);
	at[3] = 3.5000;
	points[4] = (-4900.9844, 318.4724, 8996.2598);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (-4900.9844, 318.4724, 9083.1895);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (-4900.9844, 318.4724, 9158.7793);
	angles[6] = (0, 0, 0);
	at[6] = 3.7500;
	points[7] = (-4900.9844, 318.4724, 9192.3232);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (-4900.9844, 318.4724, 9250.9062);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (-4900.9844, 318.4724, 9298.1494);
	angles[9] = (0, 0, 0);
	at[9] = 4;
	points[10] = (-4900.9844, 318.4724, 9317.5195);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (-4900.9844, 318.4724, 9347.7559);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (-4900.9844, 318.4724, 9366.6533);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (-4900.9844, 318.4724, 9377.4414);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (-4900.9844, 318.4724, 9385.3545);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (-4900.9844, 318.4724, 9389.0547);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (-4900.9844, 318.4724, 9387.1660);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (-4900.9844, 318.4724, 9363.4248);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (-4900.9844, 318.4724, 9359.6846);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (-4900.9844, 318.4724, 9361.5752);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (-4900.9844, 318.4724, 9385.3545);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (-4900.9844, 318.4724, 9389.0547);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (-4900.9844, 318.4724, 9387.1660);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (-4900.9844, 318.4724, 9363.4248);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (-4900.9844, 318.4724, 9359.6846);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (-4900.9844, 318.4724, 9361.5752);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (-4900.9844, 318.4724, 9385.3545);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (-4900.9844, 318.4724, 9389.0547);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (-4900.9844, 318.4724, 9387.1660);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (-4900.9844, 318.4724, 9363.4248);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (-4900.9844, 318.4724, 9359.6846);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (-4900.9844, 318.4724, 9361.5752);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (-4900.9844, 318.4724, 9385.3545);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (-4900.9844, 318.4724, 9389.0547);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (-4900.9844, 318.4724, 9387.1660);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (-4900.9844, 318.4724, 9363.4248);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (-4900.9844, 318.4724, 9358.4248);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (-4900.9844, 318.4724, 8810.3936);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (-4900.9844, 318.4724, 8804.0947);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (-4900.9844, 318.4724, 8804.0947);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4589.5669, 4705.1182, 7729.2129);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4589.5669, 4705.1182, 7355.0391);
	angles[1] = (0, 0, 0);
	at[1] = 1.6500;
	points[2] = (-4589.5669, 4705.1182, 7355.0391);
	angles[2] = (0, 0, 0);
	at[2] = 5.8500;
	points[3] = (-4589.5669, 4705.1182, 7404.8818);
	angles[3] = (0, 0, 0);
	at[3] = 5.9000;
	points[4] = (-4589.5669, 4705.1182, 7468.9370);
	angles[4] = (0, 0, 0);
	at[4] = 5.9500;
	points[5] = (-4589.5669, 4705.1182, 7586.8501);
	angles[5] = (0, 0, 0);
	at[5] = 6.0500;
	points[6] = (-4589.5669, 4705.1182, 7691.1812);
	angles[6] = (0, 0, 0);
	at[6] = 6.1500;
	points[7] = (-4589.5669, 4705.1182, 7781.8901);
	angles[7] = (0, 0, 0);
	at[7] = 6.2500;
	points[8] = (-4589.5669, 4705.1182, 7822.1265);
	angles[8] = (0, 0, 0);
	at[8] = 6.3000;
	points[9] = (-4589.5669, 4705.1182, 7892.4409);
	angles[9] = (0, 0, 0);
	at[9] = 6.4000;
	points[10] = (-4589.5669, 4705.1182, 7949.1343);
	angles[10] = (0, 0, 0);
	at[10] = 6.5000;
	points[11] = (-4589.5669, 4705.1182, 7972.3623);
	angles[11] = (0, 0, 0);
	at[11] = 6.5500;
	points[12] = (-4589.5669, 4705.1182, 8008.6616);
	angles[12] = (0, 0, 0);
	at[12] = 6.6500;
	points[13] = (-4589.5669, 4705.1182, 8031.3389);
	angles[13] = (0, 0, 0);
	at[13] = 6.7500;
	points[14] = (-4589.5669, 4705.1182, 8037.5596);
	angles[14] = (0, 0, 0);
	at[14] = 6.8000;
	points[15] = (-4589.5669, 4705.1182, 8043.6616);
	angles[15] = (0, 0, 0);
	at[15] = 6.9000;
	points[16] = (-4589.5669, 4705.1182, 8051.5356);
	angles[16] = (0, 0, 0);
	at[16] = 6.9500;
	points[17] = (-4589.5669, 4705.1182, 8055.2759);
	angles[17] = (0, 0, 0);
	at[17] = 7;
	points[18] = (-4589.5669, 4705.1182, 8053.3857);
	angles[18] = (0, 0, 0);
	at[18] = 7.0500;
	points[19] = (-4589.5669, 4705.1182, 8029.6064);
	angles[19] = (0, 0, 0);
	at[19] = 7.2000;
	points[20] = (-4589.5669, 4705.1182, 8025.9058);
	angles[20] = (0, 0, 0);
	at[20] = 7.2500;
	points[21] = (-4589.5669, 4705.1182, 8027.7954);
	angles[21] = (0, 0, 0);
	at[21] = 7.3000;
	points[22] = (-4589.5669, 4705.1182, 8051.5356);
	angles[22] = (0, 0, 0);
	at[22] = 7.4500;
	points[23] = (-4589.5669, 4705.1182, 8055.2759);
	angles[23] = (0, 0, 0);
	at[23] = 7.5000;
	points[24] = (-4589.5669, 4705.1182, 8053.3857);
	angles[24] = (0, 0, 0);
	at[24] = 7.5500;
	points[25] = (-4589.5669, 4705.1182, 8029.6064);
	angles[25] = (0, 0, 0);
	at[25] = 7.7000;
	points[26] = (-4589.5669, 4705.1182, 8025.9058);
	angles[26] = (0, 0, 0);
	at[26] = 7.7500;
	points[27] = (-4589.5669, 4705.1182, 8027.7954);
	angles[27] = (0, 0, 0);
	at[27] = 7.8000;
	points[28] = (-4589.5669, 4705.1182, 8051.5356);
	angles[28] = (0, 0, 0);
	at[28] = 7.9500;
	points[29] = (-4589.5669, 4705.1182, 8055.2759);
	angles[29] = (0, 0, 0);
	at[29] = 8;
	points[30] = (-4589.5669, 4705.1182, 8053.3857);
	angles[30] = (0, 0, 0);
	at[30] = 8.0500;
	points[31] = (-4589.5669, 4705.1182, 8029.6064);
	angles[31] = (0, 0, 0);
	at[31] = 8.2000;
	points[32] = (-4589.5669, 4705.1182, 8025.9058);
	angles[32] = (0, 0, 0);
	at[32] = 8.2500;
	points[33] = (-4589.5669, 4705.1182, 8027.7954);
	angles[33] = (0, 0, 0);
	at[33] = 8.3000;
	points[34] = (-4589.5669, 4705.1182, 8051.5356);
	angles[34] = (0, 0, 0);
	at[34] = 8.4500;
	points[35] = (-4589.5669, 4705.1182, 8055.2759);
	angles[35] = (0, 0, 0);
	at[35] = 8.5000;
	points[36] = (-4589.5669, 4705.1182, 8053.3857);
	angles[36] = (0, 0, 0);
	at[36] = 8.5500;
	points[37] = (-4589.5669, 4705.1182, 8024.0156);
	angles[37] = (0, 0, 0);
	at[37] = 8.7500;
	points[38] = (-4589.5669, 4705.1182, 7729.2129);
	angles[38] = (0, 0, 0);
	at[38] = 10.0500;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (714.1929, 4111.8896, 10910.2754);
	angles[0] = (0, -0.3171, 0);
	at[0] = 0;
	points[1] = (714.1929, 4111.8896, 10910.2754);
	angles[1] = (0, -0.3171, 0);
	at[1] = 2;
	points[2] = (715.7677, 4340, 10973.1104);
	angles[2] = (0, -0.3356, 0);
	at[2] = 2.2667;
	points[3] = (715.9645, 4453.8975, 11000.5908);
	angles[3] = (0, 0.5381, 0);
	at[3] = 2.4000;
	points[4] = (713.9803, 4571.7324, 11014.4492);
	angles[4] = (0, 1.2243, 0);
	at[4] = 2.5333;
	points[5] = (710.8937, 4690.0786, 11021.3379);
	angles[5] = (0, 1.9427, 0);
	at[5] = 2.6667;
	points[6] = (704.9645, 4807.0078, 11012.6768);
	angles[6] = (0, 3.2584, 0);
	at[6] = 2.8000;
	points[7] = (698.2638, 4924.4097, 10998.5830);
	angles[7] = (0, 3.1998, 0);
	at[7] = 2.9333;
	points[8] = (692.8307, 5040.2754, 10980.5117);
	angles[8] = (0, 1.8540, 0);
	at[8] = 3.0667;
	points[9] = (686.5236, 5272.2051, 10930.3545);
	angles[9] = (0, 1.4237, 0);
	at[9] = 3.3333;
	points[10] = (683.9567, 5383.8584, 10894.9609);
	angles[10] = (0, 1.1134, 0);
	at[10] = 3.4667;
	points[11] = (679.7677, 5601.1416, 10800.5518);
	angles[11] = (0, 1.2576, 0);
	at[11] = 3.7333;
	points[12] = (666.7717, 5922.2441, 10651.5742);
	angles[12] = (0, 2.6628, 0);
	at[12] = 4.1333;
	points[13] = (662.0355, 6026.0239, 10597.4404);
	angles[13] = (0, 2.5365, 0);
	at[13] = 4.2667;
	points[14] = (653.0827, 6227.9922, 10474.4492);
	angles[14] = (0, 2.5558, 0);
	at[14] = 4.5333;
	points[15] = (648.5827, 6327.4805, 10409.8027);
	angles[15] = (0, 2.6623, 0);
	at[15] = 4.6667;
	points[16] = (644.1299, 6419.8032, 10338.7803);
	angles[16] = (0, 2.8107, 0);
	at[16] = 4.8000;
	points[17] = (634.9094, 6600.9448, 10187.6377);
	angles[17] = (0, 3.1140, 0);
	at[17] = 5.0667;
	points[18] = (612.4449, 6954.4492, 9877.0869);
	angles[18] = (0, 3.2843, 0);
	at[18] = 5.6000;
	points[19] = (590.5394, 7410.5122, 9506.0625);
	angles[19] = (0, 1.8937, 0);
	at[19] = 6.2667;
	points[20] = (582.8307, 7685.2363, 9286.3779);
	angles[20] = (0, 0.8953, 0);
	at[20] = 6.6667;
	points[21] = (576.9960, 8336.7715, 8782.6377);
	angles[21] = (0, 0.6555, 0);
	at[21] = 7.6000;
	points[22] = (575.3898, 8427.3623, 8711.4180);
	angles[22] = (0, 1.7155, 0);
	at[22] = 7.7333;
	points[23] = (561.3228, 8792.0078, 8412.5986);
	angles[23] = (0, 2.0173, 0);
	at[23] = 8.2667;
	points[24] = (553.1929, 9158.5039, 8124.0161);
	angles[24] = (0, 1.9251, 0);
	at[24] = 8.8000;
	points[25] = (541.6063, 9436.6934, 7908.0713);
	angles[25] = (0, 2.5888, 0);
	at[25] = 9.2000;
	points[26] = (526.0118, 9719.4883, 7700.8662);
	angles[26] = (0, 3.2001, 0);
	at[26] = 9.6000;
	points[27] = (518.9134, 9910.8271, 7567.1650);
	angles[27] = (0, 1.2122, 0);
	at[27] = 9.8667;
	points[28] = (513.4528, 10200, 7370.9849);
	angles[28] = (0, 1.1966, 0);
	at[28] = 10.2667;
	points[29] = (506.0197, 10590.8262, 7111.5352);
	angles[29] = (0, 0.2798, 0);
	at[29] = 10.8000;
	points[30] = (511.0669, 10979.5283, 6852.4409);
	angles[30] = (0, -0.4794, 0);
	at[30] = 11.3333;
	points[31] = (510.4646, 11073.2285, 6785.6299);
	angles[31] = (0, 0.8453, 0);
	at[31] = 11.4667;
	points[32] = (507.3504, 11260.7490, 6645.9453);
	angles[32] = (0, 0.7906, 0);
	at[32] = 11.7333;
	points[33] = (507.2205, 11350.3154, 6573.2285);
	angles[33] = (0, -0.7976, 0);
	at[33] = 11.8667;
	points[34] = (510.4764, 11525.6299, 6417.9531);
	angles[34] = (0, -1.0851, 0);
	at[34] = 12.1333;
	points[35] = (511.8701, 11611.6934, 6338.5039);
	angles[35] = (0, -0.6280, 0);
	at[35] = 12.2667;
	points[36] = (511.1063, 11691.4570, 6255.3936);
	angles[36] = (0, 1.5025, 0);
	at[36] = 12.4000;
	points[37] = (503.8898, 11917.7959, 5989.9609);
	angles[37] = (0, 1.2779, 0);
	at[37] = 12.8000;
	points[38] = (499.6614, 12138.5439, 5719.0947);
	angles[38] = (0, 1.0758, 0);
	at[38] = 13.2000;
	points[39] = (499.4764, 12148.1885, 5707.2046);
	angles[39] = (0, 1.0874, 0);
	at[39] = 13.3333;
	points[40] = (499.4764, 12148.1885, 5707.2046);
	angles[40] = (0, 1.0874, 0);
	at[40] = 14.9000;
	points[41] = (714.1929, 4111.8896, 10910.2754);
	angles[41] = (0, -0.3171, 0);
	at[41] = 14.9000;
	points[42] = (714.1929, 4111.8896, 10910.2754);
	angles[42] = (0, -0.3171, 0);
	at[42] = 30;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (714.1929, 4111.8896, 10910.2754);
	angles[0] = (0, -0.3171, 0);
	at[0] = 0;
	points[1] = (714.1929, 4111.8896, 10910.2754);
	angles[1] = (0, -0.3171, 0);
	at[1] = 16.9333;
	points[2] = (714.5709, 4168.6616, 10925.7881);
	angles[2] = (0, -0.4121, 0);
	at[2] = 17.0667;
	points[3] = (716.0394, 4396.9292, 10987.9922);
	angles[3] = (0, -0.1838, 0);
	at[3] = 17.3333;
	points[4] = (715.1260, 4512.8740, 11008.5439);
	angles[4] = (0, 0.9972, 0);
	at[4] = 17.4667;
	points[5] = (712.6063, 4630.7480, 11018.8984);
	angles[5] = (0, 1.4571, 0);
	at[5] = 17.6000;
	points[6] = (708.2284, 4748.3467, 11018.4258);
	angles[6] = (0, 3.0592, 0);
	at[6] = 17.7333;
	points[7] = (701.5906, 4865.9058, 11005.9443);
	angles[7] = (0, 3.2854, 0);
	at[7] = 17.8667;
	points[8] = (695.1220, 4983.0317, 10990.3945);
	angles[8] = (0, 2.8520, 0);
	at[8] = 18;
	points[9] = (687.9803, 5214.4097, 10944.0156);
	angles[9] = (0, 1.4675, 0);
	at[9] = 18.2667;
	points[10] = (685.1182, 5329.5273, 10914.9219);
	angles[10] = (0, 1.3851, 0);
	at[10] = 18.4000;
	points[11] = (682.9291, 5438.3857, 10872.2842);
	angles[11] = (0, 1.0616, 0);
	at[11] = 18.5333;
	points[12] = (678.4213, 5655.3154, 10776.0234);
	angles[12] = (0, 1.7137, 0);
	at[12] = 18.8000;
	points[13] = (669.2599, 5868.6611, 10677.2842);
	angles[13] = (0, 2.6505, 0);
	at[13] = 19.0667;
	points[14] = (664.3425, 5974.6064, 10625.5518);
	angles[14] = (0, 2.6300, 0);
	at[14] = 19.2000;
	points[15] = (659.7992, 6076.5747, 10567.5586);
	angles[15] = (0, 2.5321, 0);
	at[15] = 19.3333;
	points[16] = (650.8505, 6277.7559, 10442.7168);
	angles[16] = (0, 2.5816, 0);
	at[16] = 19.6000;
	points[17] = (646.3977, 6373.3462, 10375.8262);
	angles[17] = (0, 2.7689, 0);
	at[17] = 19.7333;
	points[18] = (641.8740, 6465.4331, 10301.4180);
	angles[18] = (0, 2.8494, 0);
	at[18] = 19.8667;
	points[19] = (632.3229, 6645.4727, 10149.4883);
	angles[19] = (0, 3.5547, 0);
	at[19] = 20.1333;
	points[20] = (615.1221, 6910.5513, 9915.0391);
	angles[20] = (0, 3.6122, 0);
	at[20] = 20.5333;
	points[21] = (609.9764, 6998.8979, 9840.0791);
	angles[21] = (0, 3.1161, 0);
	at[21] = 20.6667;
	points[22] = (595.8150, 7274.0942, 9616.2207);
	angles[22] = (0, 2.7119, 0);
	at[22] = 21.0667;
	points[23] = (589.0591, 7456.2603, 9469.2520);
	angles[23] = (0, 1.8136, 0);
	at[23] = 21.3333;
	points[24] = (582.2047, 7731.8896, 9250);
	angles[24] = (0, 0.6754, 0);
	at[24] = 21.7333;
	points[25] = (576.3780, 8382.7168, 8746.8115);
	angles[25] = (0, 0.9201, 0);
	at[25] = 22.6667;
	points[26] = (560, 8836.7715, 8376.6533);
	angles[26] = (0, 1.4025, 0);
	at[26] = 23.3333;
	points[27] = (551.4646, 9205.2363, 8087.5986);
	angles[27] = (0, 2.2386, 0);
	at[27] = 23.8667;
	points[28] = (539.4213, 9483.9766, 7871.9688);
	angles[28] = (0, 2.7187, 0);
	at[28] = 24.2667;
	points[29] = (523.4331, 9767.4805, 7666.6538);
	angles[29] = (0, 2.9134, 0);
	at[29] = 24.6667;
	points[30] = (520.0040, 9862.3232, 7600.4331);
	angles[30] = (0, 1.3880, 0);
	at[30] = 24.8000;
	points[31] = (514.3701, 10152.9141, 7402.6772);
	angles[31] = (0, 1.0514, 0);
	at[31] = 25.2000;
	points[32] = (506.5472, 10542.4414, 7143.6616);
	angles[32] = (0, 0.8330, 0);
	at[32] = 25.7333;
	points[33] = (506.2008, 10638.0312, 7080.1973);
	angles[33] = (0, -0.5169, 0);
	at[33] = 25.8667;
	points[34] = (510.4922, 10930.7090, 6885.5513);
	angles[34] = (0, -0.7957, 0);
	at[34] = 26.2667;
	points[35] = (509.7047, 11120.6299, 6750.9448);
	angles[35] = (0, 0.9763, 0);
	at[35] = 26.5333;
	points[36] = (506.8937, 11307.1650, 6609.5278);
	angles[36] = (0, 0.1808, 0);
	at[36] = 26.8000;
	points[37] = (509.6339, 11482.2441, 6457.0474);
	angles[37] = (0, -1.1285, 0);
	at[37] = 27.0667;
	points[38] = (511.2559, 11568.9375, 6378.3857);
	angles[38] = (0, -0.9601, 0);
	at[38] = 27.2000;
	points[39] = (511.9370, 11651.7715, 6298.8979);
	angles[39] = (0, 0.7370, 0);
	at[39] = 27.3333;
	points[40] = (509.9921, 11729.8818, 6211.6538);
	angles[40] = (0, 1.7886, 0);
	at[40] = 27.4667;
	points[41] = (504.8701, 11881.1816, 6033.7007);
	angles[41] = (0, 1.8170, 0);
	at[41] = 27.7333;
	points[42] = (500.3386, 12102.1650, 5763.8975);
	angles[42] = (0, 1.0573, 0);
	at[42] = 28.1333;
	points[43] = (499.4764, 12148.1885, 5707.2046);
	angles[43] = (0, 1.0874, 0);
	at[43] = 28.2667;
	points[44] = (499.4764, 12148.1885, 5707.2046);
	angles[44] = (0, 1.0874, 0);
	at[44] = 29.9000;
	points[45] = (714.1929, 4111.8896, 10910.2754);
	angles[45] = (0, -0.3171, 0);
	at[45] = 29.9000;
	points[46] = (714.1929, 4111.8896, 10910.2754);
	angles[46] = (0, -0.3171, 0);
	at[46] = 30;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1725.5198, 7044.9609, 10625.3545);
	angles[0] = (0, 11.3225, 0);
	at[0] = 0;
	points[1] = (-1746.8425, 7146.4570, 10568.6221);
	angles[1] = (0, 12.1070, 0);
	at[1] = 0.1333;
	points[2] = (-1789.5394, 7345.9844, 10449.8428);
	angles[2] = (0, 11.5650, 0);
	at[2] = 0.4000;
	points[3] = (-1826.1810, 7540.2754, 10325.0400);
	angles[3] = (0, 10.4814, 0);
	at[3] = 0.6667;
	points[4] = (-1844.1300, 7636.6929, 10259.3711);
	angles[4] = (0, 10.7428, 0);
	at[4] = 0.8000;
	points[5] = (-1879.6141, 7817.0869, 10115.2363);
	angles[5] = (0, 11.1893, 0);
	at[5] = 1.0667;
	points[6] = (-1897.0984, 7905.8667, 10039.7246);
	angles[6] = (0, 11.0448, 0);
	at[6] = 1.2000;
	points[7] = (-1912.4448, 7987.8350, 9959.4883);
	angles[7] = (0, 10.2239, 0);
	at[7] = 1.3333;
	points[8] = (-1955.5748, 8221.4180, 9700.9844);
	angles[8] = (0, 12.1385, 0);
	at[8] = 1.7333;
	points[9] = (-2005.9172, 8447.4014, 9436.8115);
	angles[9] = (0, 11.7252, 0);
	at[9] = 2.1333;
	points[10] = (-2030.4448, 8580.8271, 9247.3232);
	angles[10] = (0, 10.2816, 0);
	at[10] = 2.4000;
	points[11] = (-2058.2834, 8710.9844, 9056.2598);
	angles[11] = (0, 15.4734, 0);
	at[11] = 2.6667;
	points[12] = (-2113.3701, 8903.7803, 8771.8506);
	angles[12] = (0, 14.6416, 0);
	at[12] = 3.0667;
	points[13] = (-2180.4565, 9168.6621, 8392.9531);
	angles[13] = (0, 14.9182, 0);
	at[13] = 3.6000;
	points[14] = (-2197.0276, 9228.5039, 8296.9688);
	angles[14] = (0, 15.7205, 0);
	at[14] = 3.7333;
	points[15] = (-2247.9961, 9406.4961, 8000.4727);
	angles[15] = (0, 16.2313, 0);
	at[15] = 4.1333;
	points[16] = (-2337.8149, 9699.6064, 7509.8823);
	angles[16] = (0, 17.4985, 0);
	at[16] = 4.8000;
	points[17] = (-2431.5552, 9985.9844, 7017.9526);
	angles[17] = (0, 18.5443, 0);
	at[17] = 5.4667;
	points[18] = (-2511.8740, 10218.5430, 6629.5674);
	angles[18] = (0, 19.0836, 0);
	at[18] = 6;
	points[19] = (-2530.2678, 10272.0869, 6530.2759);
	angles[19] = (0, 18.8776, 0);
	at[19] = 6.1333;
	points[20] = (-2582.3662, 10424.7637, 6225.3149);
	angles[20] = (0, 18.8351, 0);
	at[20] = 6.5333;
	points[21] = (-2591.0867, 10450.3145, 6174.0552);
	angles[21] = (0, 18.8437, 0);
	at[21] = 6.6667;
	points[22] = (-2591.0867, 10450.3145, 6174.0552);
	angles[22] = (0, 18.8437, 0);
	at[22] = 8.2833;
	points[23] = (-1267.3820, 4641.2207, 11639.3311);
	angles[23] = (0, 12.3967, 0);
	at[23] = 8.2833;
	points[24] = (-1267.3820, 4641.2207, 11639.3311);
	angles[24] = (0, 12.3967, 0);
	at[24] = 26.9333;
	points[25] = (-1279.2875, 4694.8428, 11618.9375);
	angles[25] = (0, 12.5955, 0);
	at[25] = 27.0667;
	points[26] = (-1349.7441, 5018.6616, 11494.7246);
	angles[26] = (0, 10.5347, 0);
	at[26] = 27.4667;
	points[27] = (-1406.0551, 5342.9922, 11361.1416);
	angles[27] = (0, 9.8112, 0);
	at[27] = 27.8667;
	points[28] = (-1483.2480, 5769.5669, 11177.7949);
	angles[28] = (0, 10.2294, 0);
	at[28] = 28.4000;
	points[29] = (-1542.0708, 6091.3779, 11045.3145);
	angles[29] = (0, 10.9406, 0);
	at[29] = 28.8000;
	points[30] = (-1584.0159, 6304.8428, 10952.2051);
	angles[30] = (0, 11.2187, 0);
	at[30] = 29.0667;
	points[31] = (-1668.7126, 6725.2759, 10760.2363);
	angles[31] = (0, 10.2752, 0);
	at[31] = 29.6000;
	points[32] = (-1706.4253, 6940.3149, 10672.1650);
	angles[32] = (0, 9.9650, 0);
	at[32] = 29.8667;
	points[33] = (-1725.5198, 7044.9609, 10625.3545);
	angles[33] = (0, 11.3225, 0);
	at[33] = 30;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1267.3820, 4641.2207, 11639.3311);
	angles[0] = (0, 12.3967, 0);
	at[0] = 0;
	points[1] = (-1267.3820, 4641.2207, 11639.3311);
	angles[1] = (0, 12.3967, 0);
	at[1] = 12;
	points[2] = (-1339.2206, 4965.8662, 11515.6309);
	angles[2] = (0, 11.8826, 0);
	at[2] = 12.4000;
	points[3] = (-1359.4922, 5072.7168, 11472.7949);
	angles[3] = (0, 10.0271, 0);
	at[3] = 12.5333;
	points[4] = (-1415.3425, 5395.6299, 11338.8975);
	angles[4] = (0, 10.1826, 0);
	at[4] = 12.9333;
	points[5] = (-1473.6260, 5716.3779, 11199.8428);
	angles[5] = (0, 10.2940, 0);
	at[5] = 13.3333;
	points[6] = (-1532.1654, 6039.2520, 11067.4414);
	angles[6] = (0, 10.5047, 0);
	at[6] = 13.7333;
	points[7] = (-1594.6104, 6358.1104, 10928.5830);
	angles[7] = (0, 11.2790, 0);
	at[7] = 14.1333;
	points[8] = (-1658.7086, 6672.7168, 10783.3066);
	angles[8] = (0, 11.2165, 0);
	at[8] = 14.5333;
	points[9] = (-1715.9764, 6994.0942, 10649.2520);
	angles[9] = (0, 10.2163, 0);
	at[9] = 14.9333;
	points[10] = (-1736.1260, 7096.1812, 10597.3623);
	angles[10] = (0, 11.9315, 0);
	at[10] = 15.0667;
	points[11] = (-1779.0513, 7296.1421, 10480.1182);
	angles[11] = (0, 12.0503, 0);
	at[11] = 15.3333;
	points[12] = (-1798.8662, 7393.7402, 10419.9209);
	angles[12] = (0, 10.7661, 0);
	at[12] = 15.4667;
	points[13] = (-1835.1536, 7588.7402, 10292.6768);
	angles[13] = (0, 10.5206, 0);
	at[13] = 15.7333;
	points[14] = (-1852.8112, 7681.4175, 10225.2754);
	angles[14] = (0, 11.1061, 0);
	at[14] = 15.8667;
	points[15] = (-1870.7363, 7772.2441, 10152.2441);
	angles[15] = (0, 11.1970, 0);
	at[15] = 16;
	points[16] = (-1888.3740, 7861.4170, 10078.0312);
	angles[16] = (0, 11.1522, 0);
	at[16] = 16.1333;
	points[17] = (-1905.0117, 7947.0869, 10001.6543);
	angles[17] = (0, 10.5298, 0);
	at[17] = 16.2667;
	points[18] = (-1933.6300, 8105.9844, 9830.4727);
	angles[18] = (0, 10.2146, 0);
	at[18] = 16.5333;
	points[19] = (-1963.9528, 8259.5674, 9657.5986);
	angles[19] = (0, 12.5519, 0);
	at[19] = 16.8000;
	points[20] = (-1997.9568, 8410.7090, 9481.9297);
	angles[20] = (0, 12.5180, 0);
	at[20] = 17.0667;
	points[21] = (-2012.4370, 8481.1807, 9390.9062);
	angles[21] = (0, 10.4879, 0);
	at[21] = 17.2000;
	points[22] = (-2036.4410, 8613.5039, 9199.4492);
	angles[22] = (0, 10.5585, 0);
	at[22] = 17.4667;
	points[23] = (-2049.5984, 8678.1885, 9104.5283);
	angles[23] = (0, 13.7848, 0);
	at[23] = 17.6000;
	points[24] = (-2104.7913, 8872.4014, 8817.5596);
	angles[24] = (0, 15.8107, 0);
	at[24] = 18;
	points[25] = (-2172.1064, 9136.5352, 8440.5908);
	angles[25] = (0, 14.3610, 0);
	at[25] = 18.5333;
	points[26] = (-2188.5984, 9198.3867, 8346.0234);
	angles[26] = (0, 15.5256, 0);
	at[26] = 18.6667;
	points[27] = (-2256.6575, 9436.0625, 7950.9448);
	angles[27] = (0, 16.4503, 0);
	at[27] = 19.2000;
	points[28] = (-2328.5237, 9670, 7559.7642);
	angles[28] = (0, 17.3569, 0);
	at[28] = 19.7333;
	points[29] = (-2422.0435, 9957.4414, 7066.8110);
	angles[29] = (0, 18.3612, 0);
	at[29] = 20.4000;
	points[30] = (-2441.0984, 10014.0547, 6970.7085);
	angles[30] = (0, 18.8963, 0);
	at[30] = 20.5333;
	points[31] = (-2502.0198, 10190.0791, 6678.1895);
	angles[31] = (0, 19.1338, 0);
	at[31] = 20.9333;
	points[32] = (-2521.1221, 10245.3936, 6581.4175);
	angles[32] = (0, 18.9277, 0);
	at[32] = 21.0667;
	points[33] = (-2591.0867, 10450.3145, 6174.0552);
	angles[33] = (0, 18.8437, 0);
	at[33] = 21.6000;
	points[34] = (-2591.0867, 10450.3145, 6174.0552);
	angles[34] = (0, 18.8437, 0);
	at[34] = 23.2833;
	points[35] = (-1267.3820, 4641.2207, 11639.3311);
	angles[35] = (0, 12.3967, 0);
	at[35] = 23.2833;
	points[36] = (-1267.3820, 4641.2207, 11639.3311);
	angles[36] = (0, 12.3967, 0);
	at[36] = 30;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-833.2913, 5384.7246, 12694.2520);
	angles[0] = (0, 11.2177, 0);
	at[0] = 0;
	points[1] = (-833.2913, 5384.7246, 12694.2520);
	angles[1] = (0, 11.2177, 0);
	at[1] = 0.2667;
	points[2] = (-844.8741, 5442.5986, 12696.1416);
	angles[2] = (0, 11.3272, 0);
	at[2] = 0.4000;
	points[3] = (-866.7441, 5558.5830, 12695.7871);
	angles[3] = (0, 9.5894, 0);
	at[3] = 0.5333;
	points[4] = (-883.8071, 5671.4565, 12670);
	angles[4] = (0, 7.4264, 0);
	at[4] = 0.6667;
	points[5] = (-895.4843, 5775.5117, 12615.7480);
	angles[5] = (0, 5.1385, 0);
	at[5] = 0.8000;
	points[6] = (-904.0433, 5874.4487, 12551.8896);
	angles[6] = (0, 4.6060, 0);
	at[6] = 0.9333;
	points[7] = (-917.2914, 5966.6533, 12480.2354);
	angles[7] = (0, 15.5353, 0);
	at[7] = 1.0667;
	points[8] = (-941.5866, 6045.5518, 12395.3154);
	angles[8] = (0, 18.3888, 0);
	at[8] = 1.2000;
	points[9] = (-998.7047, 6192.3623, 12218.9365);
	angles[9] = (0, 22.3638, 0);
	at[9] = 1.4667;
	points[10] = (-1031.5985, 6266.7715, 12134.5283);
	angles[10] = (0, 25.4869, 0);
	at[10] = 1.6000;
	points[11] = (-1068.8622, 6344.5278, 12052.9922);
	angles[11] = (0, 25.4521, 0);
	at[11] = 1.7333;
	points[12] = (-1103.1497, 6420.9058, 11971.1025);
	angles[12] = (0, 21.2313, 0);
	at[12] = 1.8667;
	points[13] = (-1185.4843, 6648.1499, 11711.6543);
	angles[13] = (0, 20.1918, 0);
	at[13] = 2.2667;
	points[14] = (-1273.7284, 6885.3545, 11463.7012);
	angles[14] = (0, 20.8970, 0);
	at[14] = 2.6667;
	points[15] = (-1363.6299, 7116.7324, 11208.7793);
	angles[15] = (0, 22.0923, 0);
	at[15] = 3.0667;
	points[16] = (-1465.7323, 7347.1655, 10960.2373);
	angles[16] = (0, 24.0167, 0);
	at[16] = 3.4667;
	points[17] = (-1499.7717, 7425.8662, 10880);
	angles[17] = (0, 22.4616, 0);
	at[17] = 3.6000;
	points[18] = (-1600.5747, 7675.8662, 10648.6621);
	angles[18] = (0, 21.6729, 0);
	at[18] = 4;
	points[19] = (-1633.9410, 7760.8667, 10575.5908);
	angles[19] = (0, 21.2138, 0);
	at[19] = 4.1333;
	points[20] = (-1735.3466, 8024.4487, 10360.6299);
	angles[20] = (0, 20.8559, 0);
	at[20] = 4.5333;
	points[21] = (-1864.8503, 8370.1582, 10066.1025);
	angles[21] = (0, 20.0754, 0);
	at[21] = 5.0667;
	points[22] = (-1895.9016, 8457.9531, 9994.3701);
	angles[22] = (0, 18.6947, 0);
	at[22] = 5.2000;
	points[23] = (-2014.4646, 8822.9141, 9717.2051);
	angles[23] = (0, 17.2129, 0);
	at[23] = 5.7333;
	points[24] = (-2117.6064, 9194.2520, 9443.6621);
	angles[24] = (0, 14.8122, 0);
	at[24] = 6.2667;
	points[25] = (-2254.8386, 9757.7959, 9040.3545);
	angles[25] = (0, 13.3692, 0);
	at[25] = 7.0667;
	points[26] = (-2343.4175, 10136.1426, 8768.2676);
	angles[26] = (0, 12.6671, 0);
	at[26] = 7.6000;
	points[27] = (-2362.6260, 10227.3623, 8698.5039);
	angles[27] = (0, 11.2143, 0);
	at[27] = 7.7333;
	points[28] = (-2432.8230, 10591.8115, 8405.9844);
	angles[28] = (0, 11.4511, 0);
	at[28] = 8.2667;
	points[29] = (-2509.1143, 10955.9453, 8113.5830);
	angles[29] = (0, 11.7306, 0);
	at[29] = 8.8000;
	points[30] = (-2580.9841, 11318.3467, 7818.0317);
	angles[30] = (0, 11.1249, 0);
	at[30] = 9.3333;
	points[31] = (-2598.4055, 11406.6143, 7744.5674);
	angles[31] = (0, 11.1924, 0);
	at[31] = 9.4667;
	points[32] = (-2651.6101, 11675.8271, 7517.4805);
	angles[32] = (0, 11.1353, 0);
	at[32] = 9.8667;
	points[33] = (-2685.4094, 11851.3779, 7364.5278);
	angles[33] = (0, 10.5985, 0);
	at[33] = 10.1333;
	points[34] = (-2732.8464, 12109.1729, 7127.4409);
	angles[34] = (0, 10.1546, 0);
	at[34] = 10.5333;
	points[35] = (-2762.9412, 12278.4258, 6963.7798);
	angles[35] = (0, 10.0285, 0);
	at[35] = 10.8000;
	points[36] = (-2791.7441, 12443.5820, 6798.0317);
	angles[36] = (0, 9.6428, 0);
	at[36] = 11.0667;
	points[37] = (-2832.0039, 12683.4648, 6538.6221);
	angles[37] = (0, 9.3768, 0);
	at[37] = 11.4667;
	points[38] = (-2867.6575, 12905.6689, 6266.2993);
	angles[38] = (0, 9.0604, 0);
	at[38] = 11.8667;
	points[39] = (-2872.1025, 12933.5430, 6231.6934);
	angles[39] = (0, 9.0768, 0);
	at[39] = 12;
	points[40] = (-2872.1025, 12933.5430, 6231.6934);
	angles[40] = (0, 9.0768, 0);
	at[40] = 13.6000;
	points[41] = (-833.2913, 5384.7246, 12694.2520);
	angles[41] = (0, 11.2177, 0);
	at[41] = 13.6000;
	points[42] = (-833.2913, 5384.7246, 12694.2520);
	angles[42] = (0, 11.2177, 0);
	at[42] = 30;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-833.2913, 5384.7246, 12694.2520);
	angles[0] = (0, 11.2177, 0);
	at[0] = 0;
	points[1] = (-833.2913, 5384.7246, 12694.2520);
	angles[1] = (0, 11.2177, 0);
	at[1] = 15.3333;
	points[2] = (-856.4174, 5500.7480, 12697.7168);
	angles[2] = (0, 11.0132, 0);
	at[2] = 15.4667;
	points[3] = (-876.2520, 5616.6143, 12689.9219);
	angles[3] = (0, 8.8297, 0);
	at[3] = 15.6000;
	points[4] = (-890.5315, 5724.9209, 12645.3535);
	angles[4] = (0, 6.7333, 0);
	at[4] = 15.7333;
	points[5] = (-899.9330, 5825.3545, 12583.9365);
	angles[5] = (0, 5.1941, 0);
	at[5] = 15.8667;
	points[6] = (-908.5787, 5923.2285, 12518.5039);
	angles[6] = (0, 6.5956, 0);
	at[6] = 16;
	points[7] = (-929.1102, 6006.5747, 12438.0312);
	angles[7] = (0, 17.1830, 0);
	at[7] = 16.1333;
	points[8] = (-954.9055, 6082.7559, 12352.4414);
	angles[8] = (0, 21.0078, 0);
	at[8] = 16.2667;
	points[9] = (-1014.1024, 6229.0552, 12175.3936);
	angles[9] = (0, 23.4772, 0);
	at[9] = 16.5333;
	points[10] = (-1087.0552, 6383.3071, 12012.0869);
	angles[10] = (0, 24.5998, 0);
	at[10] = 16.8000;
	points[11] = (-1117.3661, 6458.8188, 11927.7559);
	angles[11] = (0, 20.1494, 0);
	at[11] = 16.9333;
	points[12] = (-1171.8149, 6610.5513, 11753.2285);
	angles[12] = (0, 19.7268, 0);
	at[12] = 17.2000;
	points[13] = (-1259.0945, 6846.8110, 11505.1191);
	angles[13] = (0, 20.6119, 0);
	at[13] = 17.6000;
	points[14] = (-1379.4370, 7154.1338, 11168.1113);
	angles[14] = (0, 23.5723, 0);
	at[14] = 18.1333;
	points[15] = (-1482.8503, 7385.9448, 10919.7246);
	angles[15] = (0, 23.5710, 0);
	at[15] = 18.5333;
	points[16] = (-1550.0945, 7549.7246, 10763.7402);
	angles[16] = (0, 21.9283, 0);
	at[16] = 18.8000;
	points[17] = (-1616.7992, 7716.8901, 10612.4805);
	angles[17] = (0, 21.4097, 0);
	at[17] = 19.0667;
	points[18] = (-1718.6849, 7980.8267, 10396.2998);
	angles[18] = (0, 20.9481, 0);
	at[18] = 19.4667;
	points[19] = (-1751.3898, 8066.7715, 10325.4326);
	angles[19] = (0, 20.7076, 0);
	at[19] = 19.6000;
	points[20] = (-1880.9370, 8414.6855, 10028.9766);
	angles[20] = (0, 19.5842, 0);
	at[20] = 20.1333;
	points[21] = (-1941.0197, 8594.0557, 9889.8818);
	angles[21] = (0, 18.1195, 0);
	at[21] = 20.4000;
	points[22] = (-2027.9175, 8867.5986, 9683.7793);
	angles[22] = (0, 16.2325, 0);
	at[22] = 20.8000;
	points[23] = (-2129.8701, 9241.1025, 9409.5674);
	angles[23] = (0, 14.4738, 0);
	at[23] = 21.3333;
	points[24] = (-2310.8149, 9994.7637, 8870.7871);
	angles[24] = (0, 13.1669, 0);
	at[24] = 22.4000;
	points[25] = (-2353.2637, 10181.1807, 8734.5674);
	angles[25] = (0, 11.8213, 0);
	at[25] = 22.6667;
	points[26] = (-2424.1299, 10547.7158, 8441.4180);
	angles[26] = (0, 10.9613, 0);
	at[26] = 23.2000;
	points[27] = (-2518.2205, 11000.4336, 8077.5591);
	angles[27] = (0, 11.3804, 0);
	at[27] = 23.8667;
	points[28] = (-2572.1062, 11273.1885, 7855.1572);
	angles[28] = (0, 11.1153, 0);
	at[28] = 24.2667;
	points[29] = (-2589.5237, 11361.6934, 7782.1260);
	angles[29] = (0, 11.1740, 0);
	at[29] = 24.4000;
	points[30] = (-2660.4175, 11720.6689, 7479.3311);
	angles[30] = (0, 11.0885, 0);
	at[30] = 24.9333;
	points[31] = (-2693.5278, 11894.9219, 7325.2754);
	angles[31] = (0, 10.5394, 0);
	at[31] = 25.2000;
	points[32] = (-2725.4058, 12067.8350, 7166.6929);
	angles[32] = (0, 10.2986, 0);
	at[32] = 25.4667;
	points[33] = (-2784.7324, 12402.5195, 6840.8662);
	angles[33] = (0, 9.7749, 0);
	at[33] = 26;
	points[34] = (-2825.3743, 12643.5430, 6583.0317);
	angles[34] = (0, 9.4642, 0);
	at[34] = 26.4000;
	points[35] = (-2838.0159, 12720.3154, 6495.3149);
	angles[35] = (0, 9.1814, 0);
	at[35] = 26.5333;
	points[36] = (-2861.7952, 12868.8975, 6312.0864);
	angles[36] = (0, 9.0563, 0);
	at[36] = 26.8000;
	points[37] = (-2872.1025, 12933.5430, 6231.6934);
	angles[37] = (0, 9.0768, 0);
	at[37] = 26.9333;
	points[38] = (-2872.1025, 12933.5430, 6231.6934);
	angles[38] = (0, 9.0768, 0);
	at[38] = 28.6000;
	points[39] = (-833.2913, 5384.7246, 12694.2520);
	angles[39] = (0, 11.2177, 0);
	at[39] = 28.6000;
	points[40] = (-833.2913, 5384.7246, 12694.2520);
	angles[40] = (0, 11.2177, 0);
	at[40] = 30;
	mover = getEnt("iz_obj_19", "targetname");
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
