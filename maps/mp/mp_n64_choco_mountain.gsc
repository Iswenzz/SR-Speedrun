main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_choco_mountain", 0);

	setExpFog(8858.2676, 49751.9609, 1, 1, 1, 0);

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
	ambientPlay("iz_0_26", 2);
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
	level.iz_route[level.iz_route.size] = (2803, -3689, 906);
	level.iz_route[level.iz_route.size] = (2837, -4568, 875);
	level.iz_route[level.iz_route.size] = (2826, -5330, 844);
	level.iz_route[level.iz_route.size] = (2719, -5916, 833);
	level.iz_route[level.iz_route.size] = (2427, -6577, 833);
	level.iz_route[level.iz_route.size] = (1947, -7002, 833);
	level.iz_route[level.iz_route.size] = (1219, -7310, 833);
	level.iz_route[level.iz_route.size] = (797, -7472, 833);
	level.iz_route[level.iz_route.size] = (495, -7483, 833);
	level.iz_route[level.iz_route.size] = (292, -7400, 833);
	level.iz_route[level.iz_route.size] = (151, -7219, 833);
	level.iz_route[level.iz_route.size] = (-180, -6881, 833);
	level.iz_route[level.iz_route.size] = (-583, -6560, 833);
	level.iz_route[level.iz_route.size] = (-1014, -6384, 833);
	level.iz_route[level.iz_route.size] = (-1483, -6345, 833);
	level.iz_route[level.iz_route.size] = (-1996, -6344, 833);
	level.iz_route[level.iz_route.size] = (-2630, -6327, 833);
	level.iz_route[level.iz_route.size] = (-3069, -6154, 833);
	level.iz_route[level.iz_route.size] = (-3368, -5860, 833);
	level.iz_route[level.iz_route.size] = (-3548, -5571, 833);
	level.iz_route[level.iz_route.size] = (-3664, -5242, 833);
	level.iz_route[level.iz_route.size] = (-3720, -4888, 833);
	level.iz_route[level.iz_route.size] = (-3706, -4593, 833);
	level.iz_route[level.iz_route.size] = (-3606, -4163, 833);
	level.iz_route[level.iz_route.size] = (-3378, -3654, 833);
	level.iz_route[level.iz_route.size] = (-3013, -3262, 833);
	level.iz_route[level.iz_route.size] = (-2335, -2974, 833);
	level.iz_route[level.iz_route.size] = (-1843, -2870, 831);
	level.iz_route[level.iz_route.size] = (-1138, -2840, 810);
	level.iz_route[level.iz_route.size] = (783, -2793, 705);
	level.iz_route[level.iz_route.size] = (2359, -2795, 649);
	level.iz_route[level.iz_route.size] = (4271, -2781, 682);
	level.iz_route[level.iz_route.size] = (5177, -2549, 761);
	level.iz_route[level.iz_route.size] = (5845, -2129, 794);
	level.iz_route[level.iz_route.size] = (6237, -1697, 796);
	level.iz_route[level.iz_route.size] = (6576, -1120, 796);
	level.iz_route[level.iz_route.size] = (6852, -274, 796);
	level.iz_route[level.iz_route.size] = (7036, 445, 796);
	level.iz_route[level.iz_route.size] = (7079, 797, 796);
	level.iz_route[level.iz_route.size] = (6998, 1069, 796);
	level.iz_route[level.iz_route.size] = (6828, 1328, 796);
	level.iz_route[level.iz_route.size] = (6536, 1725, 796);
	level.iz_route[level.iz_route.size] = (6344, 2062, 796);
	level.iz_route[level.iz_route.size] = (6232, 2457, 796);
	level.iz_route[level.iz_route.size] = (6209, 2908, 796);
	level.iz_route[level.iz_route.size] = (6176, 3370, 796);
	level.iz_route[level.iz_route.size] = (6074, 3790, 796);
	level.iz_route[level.iz_route.size] = (5920, 4190, 796);
	level.iz_route[level.iz_route.size] = (5666, 4711, 796);
	level.iz_route[level.iz_route.size] = (5373, 5432, 796);
	level.iz_route[level.iz_route.size] = (4686, 6611, 796);
	level.iz_route[level.iz_route.size] = (4188, 7075, 796);
	level.iz_route[level.iz_route.size] = (3686, 7313, 796);
	level.iz_route[level.iz_route.size] = (3170, 7372, 801);
	level.iz_route[level.iz_route.size] = (2629, 7404, 817);
	level.iz_route[level.iz_route.size] = (2152, 7442, 863);
	level.iz_route[level.iz_route.size] = (1754, 7438, 920);
	level.iz_route[level.iz_route.size] = (1367, 7432, 888);
	level.iz_route[level.iz_route.size] = (924, 7445, 820);
	level.iz_route[level.iz_route.size] = (-22, 7457, 796);
	level.iz_route[level.iz_route.size] = (-2118, 7318, 796);
	level.iz_route[level.iz_route.size] = (-3196, 6954, 796);
	level.iz_route[level.iz_route.size] = (-4368, 6263, 796);
	level.iz_route[level.iz_route.size] = (-5322, 5550, 796);
	level.iz_route[level.iz_route.size] = (-6207, 4368, 796);
	level.iz_route[level.iz_route.size] = (-6852, 3208, 796);
	level.iz_route[level.iz_route.size] = (-6985, 2547, 800);
	level.iz_route[level.iz_route.size] = (-6938, 1981, 805);
	level.iz_route[level.iz_route.size] = (-6822, 1527, 806);
	level.iz_route[level.iz_route.size] = (-6634, 1189, 810);
	level.iz_route[level.iz_route.size] = (-6111, 802, 834);
	level.iz_route[level.iz_route.size] = (-5516, 819, 856);
	level.iz_route[level.iz_route.size] = (-5035, 1031, 876);
	level.iz_route[level.iz_route.size] = (-4776, 1454, 890);
	level.iz_route[level.iz_route.size] = (-4620, 1996, 899);
	level.iz_route[level.iz_route.size] = (-4637, 2792, 905);
	level.iz_route[level.iz_route.size] = (-4617, 3721, 906);
	level.iz_route[level.iz_route.size] = (-4373, 4754, 906);
	level.iz_route[level.iz_route.size] = (-3742, 5394, 906);
	level.iz_route[level.iz_route.size] = (-3080, 5818, 906);
	level.iz_route[level.iz_route.size] = (-1884, 6226, 906);
	level.iz_route[level.iz_route.size] = (-1168, 6422, 906);
	level.iz_route[level.iz_route.size] = (-361, 6434, 906);
	level.iz_route[level.iz_route.size] = (253, 6266, 906);
	level.iz_route[level.iz_route.size] = (794, 5728, 899);
	level.iz_route[level.iz_route.size] = (1558, 4619, 877);
	level.iz_route[level.iz_route.size] = (2429, 3165, 862);
	level.iz_route[level.iz_route.size] = (2699, 2535, 877);
	level.iz_route[level.iz_route.size] = (2819, 2130, 924);
	level.iz_route[level.iz_route.size] = (2827, 1527, 1022);
	level.iz_route[level.iz_route.size] = (2828, 495, 940);
	level.iz_route[level.iz_route.size] = (2819, -96, 1017);
	level.iz_route[level.iz_route.size] = (2835, -653, 975);
	level.iz_route[level.iz_route.size] = (2851, -1279, 966);
	level.iz_route[level.iz_route.size] = (2850, -1695, 1025);
	level.iz_route[level.iz_route.size] = (2863, -2166, 963);
	level.iz_route[level.iz_route.size] = (2842, -2692, 909);
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
	points[0] = (-4345.5117, 1002.5236, 1317.9370);
	angles[0] = (0, 47.2812, 88.1274);
	at[0] = 0;
	points[1] = (-4345.5117, 1002.5236, 1317.9370);
	angles[1] = (0, 47.2812, 88.1274);
	at[1] = 6.6667;
	points[2] = (-4360.9844, 1015.9016, 1385.2599);
	angles[2] = (0, 49.1803, 52.3029);
	at[2] = 6.7333;
	points[3] = (-4391.9688, 1042.6575, 1466.7560);
	angles[3] = (0, 49.1803, 40.3026);
	at[3] = 6.8000;
	points[4] = (-4422.9531, 1069.4133, 1538.8032);
	angles[4] = (0, 49.1803, 28.3025);
	at[4] = 6.8667;
	points[5] = (-4453.8975, 1096.1654, 1601.4015);
	angles[5] = (0, 49.1804, 16.3024);
	at[5] = 6.9333;
	points[6] = (-4484.8818, 1122.9213, 1654.5513);
	angles[6] = (0, 49.1803, 4.3022);
	at[6] = 7;
	points[7] = (-4515.8662, 1149.6771, 1698.2521);
	angles[7] = (0, 49.1803, -7.6979);
	at[7] = 7.0667;
	points[8] = (-4546.8506, 1176.4331, 1732.5039);
	angles[8] = (0, 49.1804, -19.6981);
	at[8] = 7.1333;
	points[9] = (-4577.7954, 1203.1890, 1757.3071);
	angles[9] = (0, 49.1803, -31.6982);
	at[9] = 7.2000;
	points[10] = (-4608.7798, 1229.9449, 1772.6615);
	angles[10] = (0, 49.1803, -43.6983);
	at[10] = 7.2667;
	points[11] = (-4639.7637, 1256.6968, 1778.5669);
	angles[11] = (0, 49.1803, -55.6985);
	at[11] = 7.3333;
	points[12] = (-4670.7480, 1283.4528, 1775.0237);
	angles[12] = (0, 49.1804, -67.6986);
	at[12] = 7.4000;
	points[13] = (-4701.6929, 1310.2087, 1762.0315);
	angles[13] = (0, 49.1803, -79.6989);
	at[13] = 7.4667;
	points[14] = (-4732.6772, 1336.9646, 1739.5906);
	angles[14] = (0, 49.1804, -91.6991);
	at[14] = 7.5333;
	points[15] = (-4763.6616, 1363.7205, 1707.7008);
	angles[15] = (0, 49.1803, -103.6992);
	at[15] = 7.6000;
	points[16] = (-4794.6455, 1390.4764, 1666.3622);
	angles[16] = (0, 49.1804, -115.6992);
	at[16] = 7.6667;
	points[17] = (-4825.5908, 1417.2284, 1615.5748);
	angles[17] = (0, 49.1803, -127.6995);
	at[17] = 7.7333;
	points[18] = (-4856.5747, 1443.9843, 1555.3386);
	angles[18] = (0, 49.1803, -139.6996);
	at[18] = 7.8000;
	points[19] = (-4887.5591, 1470.7402, 1485.6536);
	angles[19] = (0, 49.1803, -151.6998);
	at[19] = 7.8667;
	points[20] = (-4918.5435, 1497.4961, 1406.5198);
	angles[20] = (0, 47.2812, -163.6999);
	at[20] = 7.9333;
	points[21] = (-4947.2046, 1524.1143, 1317.9370);
	angles[21] = (0, 47.2811, -175.7000);
	at[21] = 8;
	points[22] = (-4976.0630, 1550.7441, 1219.9055);
	angles[22] = (0, 47.2812, -187.7001);
	at[22] = 8.0667;
	points[23] = (-5004.8818, 1577.3740, 1112.4252);
	angles[23] = (0, 47.2811, -199.7003);
	at[23] = 8.1333;
	points[24] = (-5033.7402, 1604.0039, 995.4961);
	angles[24] = (0, 47.2811, -211.7005);
	at[24] = 8.2000;
	points[25] = (-5062.5591, 1630.6378, 990.0315);
	angles[25] = (0, 47.2811, -242.2582);
	at[25] = 8.2667;
	points[26] = (-5091.4175, 1657.2678, 1013.8898);
	angles[26] = (0, 47.2811, -272.8159);
	at[26] = 8.3333;
	points[27] = (-5120.2363, 1683.8977, 1028.2992);
	angles[27] = (0, 47.2811, -303.3736);
	at[27] = 8.4000;
	points[28] = (-5149.0947, 1710.5276, 1033.2599);
	angles[28] = (0, 47.2811, -333.9314);
	at[28] = 8.4667;
	points[29] = (-5177.9136, 1737.1575, 1028.7717);
	angles[29] = (0, 47.2811, -364.4891);
	at[29] = 8.5333;
	points[30] = (-5206.7715, 1763.7875, 1014.8347);
	angles[30] = (0, 47.2811, -395.0469);
	at[30] = 8.6000;
	points[31] = (-5235.5903, 1790.4174, 991.4489);
	angles[31] = (0, 47.2812, -425.6051);
	at[31] = 8.6667;
	points[32] = (-5264.4487, 1817.0472, 958.6142);
	angles[32] = (0, 47.2811, -456.1632);
	at[32] = 8.7333;
	points[33] = (-5293.2681, 1843.6771, 916.3307);
	angles[33] = (0, 47.2812, -486.7214);
	at[33] = 8.8000;
	points[34] = (-5322.1265, 1870.3070, 864.5984);
	angles[34] = (0, 47.2811, -517.2795);
	at[34] = 8.8667;
	points[35] = (-5350.9448, 1896.9371, 803.4173);
	angles[35] = (0, 47.2811, -547.8377);
	at[35] = 8.9333;
	points[36] = (-5379.8032, 1923.5670, 732.7874);
	angles[36] = (0, 47.2811, -578.3959);
	at[36] = 9;
	points[37] = (-5408.6221, 1950.1969, 652.7087);
	angles[37] = (0, 47.2812, -608.9540);
	at[37] = 9.0667;
	points[38] = (-5430.2759, 1970.1693, 586.4488);
	angles[38] = (0, 47.2812, -631.8726);
	at[38] = 9.1333;
	points[39] = (-4345.5117, 1002.5236, 1317.9370);
	angles[39] = (0, 47.2812, -631.8726);
	at[39] = 9.1333;
	points[40] = (-4345.5117, 1002.5236, 1317.9370);
	angles[40] = (0, 47.2812, -631.8726);
	at[40] = 12.5167;
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
	points[0] = (-5740.0396, -369.5697, 1269.4133);
	angles[0] = (0, 1.2261, -141.5170);
	at[0] = 0;
	points[1] = (-5740.0396, -369.5697, 1269.4133);
	angles[1] = (0, 1.2261, -141.5170);
	at[1] = 6.6667;
	points[2] = (-5739.6460, -347.0965, 1336.7362);
	angles[2] = (0, -0.9919, -203.1383);
	at[2] = 6.7333;
	points[3] = (-5738.8584, -302.1500, 1418.2324);
	angles[3] = (0, -0.9919, -215.1385);
	at[3] = 6.8000;
	points[4] = (-5738.1104, -257.2036, 1490.2795);
	angles[4] = (0, -0.9919, -227.1385);
	at[4] = 6.8667;
	points[5] = (-5737.3228, -212.2571, 1552.8779);
	angles[5] = (0, -0.9919, -239.1388);
	at[5] = 6.9333;
	points[6] = (-5736.5352, -167.3106, 1606.0275);
	angles[6] = (0, -0.9919, -251.1390);
	at[6] = 7;
	points[7] = (-5735.7480, -122.3642, 1649.7283);
	angles[7] = (0, -0.9919, -263.1390);
	at[7] = 7.0667;
	points[8] = (-5735, -77.4177, 1683.9803);
	angles[8] = (0, -0.9919, -275.1393);
	at[8] = 7.1333;
	points[9] = (-5734.2129, -32.4711, 1708.7834);
	angles[9] = (0, -0.9919, -287.1395);
	at[9] = 7.2000;
	points[10] = (-5733.4253, 12.4754, 1724.1377);
	angles[10] = (0, -0.9919, -299.1395);
	at[10] = 7.2667;
	points[11] = (-5732.6377, 57.4217, 1730.0433);
	angles[11] = (0, -0.9919, -311.1397);
	at[11] = 7.3333;
	points[12] = (-5731.8896, 102.3681, 1726.5000);
	angles[12] = (0, -0.9919, -323.1398);
	at[12] = 7.4000;
	points[13] = (-5731.1025, 147.3146, 1713.5079);
	angles[13] = (0, -0.9919, -335.1401);
	at[13] = 7.4667;
	points[14] = (-5730.3149, 192.2610, 1691.0669);
	angles[14] = (0, -0.9919, -347.1401);
	at[14] = 7.5333;
	points[15] = (-5729.5273, 237.2075, 1659.1772);
	angles[15] = (0, -0.9919, -359.1403);
	at[15] = 7.6000;
	points[16] = (-5728.7402, 282.1539, 1617.8386);
	angles[16] = (0, -0.9919, -371.1404);
	at[16] = 7.6667;
	points[17] = (-5727.9922, 327.1004, 1567.0513);
	angles[17] = (0, -0.9919, -383.1407);
	at[17] = 7.7333;
	points[18] = (-5727.2046, 372.0469, 1506.8151);
	angles[18] = (0, -0.9919, -395.1408);
	at[18] = 7.8000;
	points[19] = (-5726.4175, 416.9922, 1437.1300);
	angles[19] = (0, -0.9919, -407.1410);
	at[19] = 7.8667;
	points[20] = (-5725.6299, 461.9409, 1357.9961);
	angles[20] = (0, -0.9919, -419.1411);
	at[20] = 7.9333;
	points[21] = (-5724.8818, 506.8858, 1269.4133);
	angles[21] = (0, -0.9919, -431.1412);
	at[21] = 8;
	points[22] = (-5724.0947, 551.8307, 1171.3818);
	angles[22] = (0, -0.9919, -443.1414);
	at[22] = 8.0667;
	points[23] = (-5723.3071, 596.7795, 1063.9016);
	angles[23] = (0, -0.9919, -455.1414);
	at[23] = 8.1333;
	points[24] = (-5722.5200, 641.7244, 946.9725);
	angles[24] = (0, -0.9919, -467.1416);
	at[24] = 8.2000;
	points[25] = (-5721.7715, 686.6732, 964.0945);
	angles[25] = (0, -0.9919, -497.6990);
	at[25] = 8.2667;
	points[26] = (-5720.9844, 731.6181, 987.9528);
	angles[26] = (0, -0.9919, -528.2562);
	at[26] = 8.3333;
	points[27] = (-5720.1968, 776.5630, 1002.3622);
	angles[27] = (0, -0.9919, -558.8135);
	at[27] = 8.4000;
	points[28] = (-5719.4092, 821.5118, 1007.3229);
	angles[28] = (0, -0.9919, -589.3707);
	at[28] = 8.4667;
	points[29] = (-5718.6616, 866.4567, 1002.8347);
	angles[29] = (0, -0.9919, -619.9281);
	at[29] = 8.5333;
	points[30] = (-5717.8740, 911.4055, 988.8976);
	angles[30] = (0, -0.9919, -650.4854);
	at[30] = 8.6000;
	points[31] = (-5717.5591, 954.9803, 965.5118);
	angles[31] = (0, 1.2261, -681.0426);
	at[31] = 8.6667;
	points[32] = (-5718.4253, 995.2086, 932.6772);
	angles[32] = (0, 1.2261, -711.5999);
	at[32] = 8.7333;
	points[33] = (-5719.2915, 1035.4370, 936.7008);
	angles[33] = (0, 1.2261, -746.1578);
	at[33] = 8.8000;
	points[34] = (-5720.1577, 1075.6615, 935.3307);
	angles[34] = (0, 1.2261, -780.7158);
	at[34] = 8.8667;
	points[35] = (-5721.0234, 1115.8898, 929.3228);
	angles[35] = (0, 1.2261, -817.2740);
	at[35] = 8.9333;
	points[36] = (-5721.8506, 1156.1141, 927.8976);
	angles[36] = (0, 1.2261, -861.8317);
	at[36] = 9;
	points[37] = (-5722.7163, 1196.3425, 927.0040);
	angles[37] = (0, 1.2261, -922.3895);
	at[37] = 9.0667;
	points[38] = (-5723.5825, 1236.5669, 926.1102);
	angles[38] = (0, 1.2261, -998.9473);
	at[38] = 9.1333;
	points[39] = (-5724.4487, 1276.7953, 924.9882);
	angles[39] = (0, 1.2261, -1090.5046);
	at[39] = 9.2000;
	points[40] = (-5725.3154, 1317.0198, 917.2638);
	angles[40] = (0, 1.2261, -1185.0615);
	at[40] = 9.2667;
	points[41] = (-5726.1816, 1357.2479, 900.0945);
	angles[41] = (0, 1.2261, -1279.6185);
	at[41] = 9.3333;
	points[42] = (-5727.0474, 1397.4724, 873.4724);
	angles[42] = (0, 1.2261, -1374.1754);
	at[42] = 9.4000;
	points[43] = (-5727.8745, 1437.7008, 837.4016);
	angles[43] = (0, 1.2261, -1468.7324);
	at[43] = 9.4667;
	points[44] = (-5728.7402, 1477.9291, 791.8858);
	angles[44] = (0, 1.2261, -1563.2894);
	at[44] = 9.5333;
	points[45] = (-5729.6064, 1518.1536, 736.9173);
	angles[45] = (0, 1.2261, -1657.8463);
	at[45] = 9.6000;
	points[46] = (-5730.4727, 1558.3820, 672.5040);
	angles[46] = (0, 1.2261, -1752.4032);
	at[46] = 9.6667;
	points[47] = (-5731.3389, 1598.6063, 598.6378);
	angles[47] = (0, 1.2261, -1846.9601);
	at[47] = 9.7333;
	points[48] = (-5732.2051, 1638.8347, 515.3268);
	angles[48] = (0, 1.2261, -1941.5170);
	at[48] = 9.8000;
	points[49] = (-5732.2051, 1638.8347, 515.3268);
	angles[49] = (0, 1.2261, -1941.5170);
	at[49] = 9.8167;
	points[50] = (-5740.0396, -369.5697, 1269.4133);
	angles[50] = (0, 1.2261, -1941.5170);
	at[50] = 9.8167;
	points[51] = (-5740.0396, -369.5697, 1269.4133);
	angles[51] = (0, 1.2261, -1941.5170);
	at[51] = 12.5167;
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
	points[0] = (-7560.3936, 1241.0669, 1234.1614);
	angles[0] = (0, -67.2070, 150.1838);
	at[0] = 0;
	points[1] = (-7560.3936, 1241.0669, 1234.1614);
	angles[1] = (0, -67.2070, 150.1838);
	at[1] = 6.6667;
	points[2] = (-7540.7085, 1248.2205, 1301.4843);
	angles[2] = (0, -70.0294, 213.6758);
	at[2] = 6.7333;
	points[3] = (-7501.3384, 1262.5276, 1382.9803);
	angles[3] = (0, -70.0294, 201.6756);
	at[3] = 6.8000;
	points[4] = (-7461.9683, 1276.8346, 1455.0276);
	angles[4] = (0, -70.0293, 189.6755);
	at[4] = 6.8667;
	points[5] = (-7422.5981, 1291.1417, 1517.6260);
	angles[5] = (0, -70.0293, 177.6753);
	at[5] = 6.9333;
	points[6] = (-7383.2285, 1305.4489, 1570.7756);
	angles[6] = (0, -70.0294, 165.6752);
	at[6] = 7;
	points[7] = (-7343.8584, 1319.7560, 1614.4764);
	angles[7] = (0, -70.0294, 153.6750);
	at[7] = 7.0667;
	points[8] = (-7304.4883, 1334.0630, 1648.7284);
	angles[8] = (0, -70.0294, 141.6749);
	at[8] = 7.1333;
	points[9] = (-7265.1182, 1348.3701, 1673.5316);
	angles[9] = (0, -70.0294, 129.6747);
	at[9] = 7.2000;
	points[10] = (-7225.7480, 1362.6771, 1688.8859);
	angles[10] = (0, -70.0294, 117.6747);
	at[10] = 7.2667;
	points[11] = (-7186.3779, 1376.9843, 1694.7913);
	angles[11] = (0, -70.0294, 105.6743);
	at[11] = 7.3333;
	points[12] = (-7147.0078, 1391.2913, 1691.2480);
	angles[12] = (0, -70.0294, 93.6743);
	at[12] = 7.4000;
	points[13] = (-7107.6377, 1405.5985, 1678.2560);
	angles[13] = (0, -70.0294, 81.6742);
	at[13] = 7.4667;
	points[14] = (-7068.2676, 1419.9056, 1655.8151);
	angles[14] = (0, -70.0294, 69.6740);
	at[14] = 7.5333;
	points[15] = (-7028.8975, 1434.2126, 1623.9252);
	angles[15] = (0, -70.0294, 57.6739);
	at[15] = 7.6000;
	points[16] = (-6989.5273, 1448.5198, 1582.5867);
	angles[16] = (0, -70.0294, 45.6737);
	at[16] = 7.6667;
	points[17] = (-6950.1572, 1462.8268, 1531.7992);
	angles[17] = (0, -70.0294, 33.6735);
	at[17] = 7.7333;
	points[18] = (-6910.7871, 1477.1339, 1471.5630);
	angles[18] = (0, -70.0294, 21.6734);
	at[18] = 7.8000;
	points[19] = (-6871.4175, 1491.4409, 1401.8779);
	angles[19] = (0, -70.0293, 9.6732);
	at[19] = 7.8667;
	points[20] = (-6832.0474, 1505.7480, 1322.7440);
	angles[20] = (0, -70.0294, -2.3269);
	at[20] = 7.9333;
	points[21] = (-6792.6772, 1520.0552, 1234.1614);
	angles[21] = (0, -70.0294, -14.3270);
	at[21] = 8;
	points[22] = (-6753.1104, 1536.3427, 1136.1300);
	angles[22] = (0, -67.2069, -26.3273);
	at[22] = 8.0667;
	points[23] = (-6713.5039, 1552.9843, 1028.6497);
	angles[23] = (0, -67.2068, -38.3274);
	at[23] = 8.1333;
	points[24] = (-6673.8975, 1569.6299, 911.7205);
	angles[24] = (0, -67.2069, -50.3275);
	at[24] = 8.2000;
	points[25] = (-6634.2915, 1586.2717, 913.2205);
	angles[25] = (0, -67.2070, -80.8857);
	at[25] = 8.2667;
	points[26] = (-6594.6855, 1602.9135, 937.0787);
	angles[26] = (0, -67.2069, -111.4438);
	at[26] = 8.3333;
	points[27] = (-6555.0786, 1619.5591, 951.4882);
	angles[27] = (0, -67.2068, -142.0020);
	at[27] = 8.4000;
	points[28] = (-6515.4722, 1636.2009, 956.4489);
	angles[28] = (0, -67.2070, -172.5602);
	at[28] = 8.4667;
	points[29] = (-6475.8662, 1652.8425, 951.9606);
	angles[29] = (0, -67.2069, -203.1183);
	at[29] = 8.5333;
	points[30] = (-6436.2603, 1669.4882, 938.0236);
	angles[30] = (0, -67.2068, -233.6766);
	at[30] = 8.6000;
	points[31] = (-6396.6538, 1686.1300, 914.6378);
	angles[31] = (0, -67.2069, -264.2346);
	at[31] = 8.6667;
	points[32] = (-6357.0469, 1702.7717, 881.8032);
	angles[32] = (0, -67.2069, -294.7927);
	at[32] = 8.7333;
	points[33] = (-6317.4409, 1719.4172, 839.5197);
	angles[33] = (0, -67.2069, -325.3510);
	at[33] = 8.8000;
	points[34] = (-6277.8350, 1736.0591, 787.7874);
	angles[34] = (0, -67.2069, -355.9091);
	at[34] = 8.8667;
	points[35] = (-6238.2285, 1752.7008, 726.6063);
	angles[35] = (0, -67.2069, -386.4673);
	at[35] = 8.9333;
	points[36] = (-6198.6226, 1769.3464, 655.9764);
	angles[36] = (0, -67.2068, -417.0254);
	at[36] = 9;
	points[37] = (-6159.0156, 1785.9883, 575.8976);
	angles[37] = (0, -67.2069, -447.5837);
	at[37] = 9.0667;
	points[38] = (-6119.4097, 1802.6300, 486.3701);
	angles[38] = (0, -67.2069, -478.1417);
	at[38] = 9.1333;
	points[39] = (-6079.8032, 1819.2716, 387.3918);
	angles[39] = (0, -67.2069, -508.6999);
	at[39] = 9.2000;
	points[40] = (-6040.1973, 1835.9174, 278.9666);
	angles[40] = (0, -67.2069, -539.2581);
	at[40] = 9.2667;
	points[41] = (-6000.5903, 1852.5591, 161.0925);
	angles[41] = (0, -67.2070, -569.8162);
	at[41] = 9.3333;
	points[42] = (-6000.5903, 1852.5591, 161.0925);
	angles[42] = (0, -67.2070, -569.8162);
	at[42] = 9.3500;
	points[43] = (-7560.3936, 1241.0669, 1234.1614);
	angles[43] = (0, -67.2070, -569.8162);
	at[43] = 9.3500;
	points[44] = (-7560.3936, 1241.0669, 1234.1614);
	angles[44] = (0, -67.2070, -569.8162);
	at[44] = 12.5167;
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
