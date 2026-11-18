main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_merry_mountain", 0);

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
	ambientPlay("iz_0_tmm", 2);
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
	level.iz_route[level.iz_route.size] = (-449, 1778, 1478);
	level.iz_route[level.iz_route.size] = (889, 1778, 1482);
	level.iz_route[level.iz_route.size] = (1866, 1778, 1506);
	level.iz_route[level.iz_route.size] = (2472, 1749, 1551);
	level.iz_route[level.iz_route.size] = (2899, 1593, 1602);
	level.iz_route[level.iz_route.size] = (3156, 1302, 1693);
	level.iz_route[level.iz_route.size] = (3296, 818, 1830);
	level.iz_route[level.iz_route.size] = (3441, 80, 2046);
	level.iz_route[level.iz_route.size] = (3675, -494, 2265);
	level.iz_route[level.iz_route.size] = (4024, -907, 2496);
	level.iz_route[level.iz_route.size] = (4583, -1403, 2841);
	level.iz_route[level.iz_route.size] = (5141, -2370, 3316);
	level.iz_route[level.iz_route.size] = (5491, -3136, 3657);
	level.iz_route[level.iz_route.size] = (5681, -3771, 3911);
	level.iz_route[level.iz_route.size] = (5690, -4403, 4165);
	level.iz_route[level.iz_route.size] = (5497, -4951, 4381);
	level.iz_route[level.iz_route.size] = (4996, -5308, 4524);
	level.iz_route[level.iz_route.size] = (4274, -5436, 4635);
	level.iz_route[level.iz_route.size] = (3622, -5332, 4677);
	level.iz_route[level.iz_route.size] = (2833, -5069, 4701);
	level.iz_route[level.iz_route.size] = (1980, -4730, 4749);
	level.iz_route[level.iz_route.size] = (822, -4360, 4838);
	level.iz_route[level.iz_route.size] = (-213, -3985, 4959);
	level.iz_route[level.iz_route.size] = (-880, -3599, 5059);
	level.iz_route[level.iz_route.size] = (-1402, -3276, 5167);
	level.iz_route[level.iz_route.size] = (-1807, -3127, 5238);
	level.iz_route[level.iz_route.size] = (-2165, -3099, 5285);
	level.iz_route[level.iz_route.size] = (-2574, -3140, 5322);
	level.iz_route[level.iz_route.size] = (-2916, -3252, 5339);
	level.iz_route[level.iz_route.size] = (-3321, -3431, 5371);
	level.iz_route[level.iz_route.size] = (-3725, -3659, 5425);
	level.iz_route[level.iz_route.size] = (-5171, -4651, 5909);
	level.iz_route[level.iz_route.size] = (-6427, -5517, 6302);
	level.iz_route[level.iz_route.size] = (-6968, -5955, 6524);
	level.iz_route[level.iz_route.size] = (-7456, -6269, 6748);
	level.iz_route[level.iz_route.size] = (-7912, -6447, 6958);
	level.iz_route[level.iz_route.size] = (-8394, -6488, 7179);
	level.iz_route[level.iz_route.size] = (-8895, -6434, 7419);
	level.iz_route[level.iz_route.size] = (-9345, -6208, 7654);
	level.iz_route[level.iz_route.size] = (-9581, -5881, 7820);
	level.iz_route[level.iz_route.size] = (-9711, -5469, 7963);
	level.iz_route[level.iz_route.size] = (-9671, -5081, 8051);
	level.iz_route[level.iz_route.size] = (-9534, -4747, 8109);
	level.iz_route[level.iz_route.size] = (-9180, -4123, 8227);
	level.iz_route[level.iz_route.size] = (-9127, -3886, 8301);
	level.iz_route[level.iz_route.size] = (-9182, -3679, 8388);
	level.iz_route[level.iz_route.size] = (-9425, -3344, 8553);
	level.iz_route[level.iz_route.size] = (-9740, -3047, 8708);
	level.iz_route[level.iz_route.size] = (-10517, -2396, 9088);
	level.iz_route[level.iz_route.size] = (-11693, -1592, 9649);
	level.iz_route[level.iz_route.size] = (-13344, -462, 10929);
	level.iz_route[level.iz_route.size] = (-13818, -52, 11374);
	level.iz_route[level.iz_route.size] = (-14005, 154, 11553);
	level.iz_route[level.iz_route.size] = (-14141, 391, 11692);
	level.iz_route[level.iz_route.size] = (-14197, 598, 11756);
	level.iz_route[level.iz_route.size] = (-14199, 818, 11777);
	level.iz_route[level.iz_route.size] = (-14163, 1052, 11768);
	level.iz_route[level.iz_route.size] = (-14078, 1244, 11720);
	level.iz_route[level.iz_route.size] = (-13928, 1419, 11621);
	level.iz_route[level.iz_route.size] = (-13745, 1559, 11499);
	level.iz_route[level.iz_route.size] = (-13538, 1654, 11355);
	level.iz_route[level.iz_route.size] = (-13118, 1717, 11057);
	level.iz_route[level.iz_route.size] = (-12571, 1790, 10671);
	level.iz_route[level.iz_route.size] = (-11839, 1778, 10168);
	level.iz_route[level.iz_route.size] = (-11005, 1778, 9479);
	level.iz_route[level.iz_route.size] = (-10555, 1778, 8984);
	level.iz_route[level.iz_route.size] = (-9814, 1778, 7898);
	level.iz_route[level.iz_route.size] = (-9096, 1778, 6813);
	level.iz_route[level.iz_route.size] = (-8473, 1778, 5921);
	level.iz_route[level.iz_route.size] = (-7837, 1778, 5076);
	level.iz_route[level.iz_route.size] = (-5696, 1778, 2924);
	level.iz_route[level.iz_route.size] = (-4245, 1778, 2223);
	level.iz_route[level.iz_route.size] = (-3192, 1778, 1956);
	level.iz_route[level.iz_route.size] = (-1714, 1762, 1476);
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
	points[0] = (10496.8105, 7821.7324, 3763.1221);
	angles[0] = (0, 169.0430, -0.0059);
	at[0] = 0;
	points[1] = (9691.3389, 3646.3467, 3763.1221);
	angles[1] = (0, 168.9363, 0);
	at[1] = 3;
	points[2] = (8931.9297, 185.3689, 3763.1221);
	angles[2] = (0, 167.6275, 0);
	at[2] = 5.5000;
	points[3] = (8631.0635, -1199.6536, 3763.1221);
	angles[3] = (0, 167.7812, 0);
	at[3] = 6.5000;
	points[4] = (8149.6851, -1282.4882, 3761.9724);
	angles[4] = (0, 84.6473, -0.1443);
	at[4] = 7;
	points[5] = (7488.8979, -1027.6732, 3739.0984);
	angles[5] = (0, 69.5256, -2.0595);
	at[5] = 7.5000;
	points[6] = (6811.0239, -844.0354, 3672.6772);
	angles[6] = (0, 78.5956, -7.2235);
	at[6] = 8;
	points[7] = (6138.0317, -926.7953, 3573.0828);
	angles[7] = (0, 105.7111, -7.6199);
	at[7] = 8.5000;
	points[8] = (5770.7480, -1486.5551, 3496.2600);
	angles[8] = (0, 156.1626, -4.8031);
	at[8] = 9;
	points[9] = (5703.4253, -2170.0393, 3618.3347);
	angles[9] = (0, 177.3533, 15.2506);
	at[9] = 9.5000;
	points[10] = (5985.0396, -2738.2913, 3934.2322);
	angles[10] = (0, 204.4239, 28.3426);
	at[10] = 10;
	points[11] = (6091.7324, -3339.4526, 4284.4092);
	angles[11] = (0, 185.2177, 29.1603);
	at[11] = 10.5000;
	points[12] = (5980.5513, -3950.1968, 4620.4331);
	angles[12] = (0, 165.9442, 28.3521);
	at[12] = 11;
	points[13] = (5664.6460, -4486.6533, 4951.0630);
	angles[13] = (0, 145.0115, 27.9744);
	at[13] = 11.5000;
	points[14] = (5143.6221, -4856.9292, 5248.1494);
	angles[14] = (0, 121.4546, 23.7298);
	at[14] = 12;
	points[15] = (4494.6460, -4992.4409, 5476.6929);
	angles[15] = (0, 96.4594, 17.0466);
	at[15] = 12.5000;
	points[16] = (3805.8074, -4904.0947, 5592.3228);
	angles[16] = (0, 79.0090, 7.3491);
	at[16] = 13;
	points[17] = (3134.3030, -4683.5435, 5635.8267);
	angles[17] = (0, 71.2562, 3.8393);
	at[17] = 13.5000;
	points[18] = (1801.2717, -4214.0552, 5742.6382);
	angles[18] = (0, 70.5990, 4.3207);
	at[18] = 14.5000;
	points[19] = (1129.9882, -4015, 5849.8823);
	angles[19] = (0, 73.6355, 8.9347);
	at[19] = 15;
	points[20] = (465.0551, -3806.2795, 5977.3232);
	angles[20] = (0, 72.1091, 10.7838);
	at[20] = 15.5000;
	points[21] = (-186.5799, -3573.4097, 6128.8188);
	angles[21] = (0, 69.6935, 12.8940);
	at[21] = 16;
	points[22] = (-823.3779, -3321.3779, 6309.4487);
	angles[22] = (0, 67.8138, 15.7793);
	at[22] = 16.5000;
	points[23] = (-1435.1339, -3056.2637, 6545.8662);
	angles[23] = (0, 66.0163, 21.5554);
	at[23] = 17;
	points[24] = (-2028.5789, -2786.6301, 6823.9370);
	angles[24] = (0, 65.7747, 23.4169);
	at[24] = 17.5000;
	points[25] = (-2617.9409, -2584.1616, 7158.7793);
	angles[25] = (0, 73.5977, 28.1839);
	at[25] = 18;
	points[26] = (-3241.8230, -2550.2600, 7478.3862);
	angles[26] = (0, 93.0240, 25.5551);
	at[26] = 18.5000;
	points[27] = (-3849.4214, -2758.6770, 7773.0312);
	angles[27] = (0, 111.0161, 25.8826);
	at[27] = 19;
	points[28] = (-4437.2837, -3023.2561, 8067.2441);
	angles[28] = (0, 114.1053, 24.6874);
	at[28] = 19.5000;
	points[29] = (-5018.5435, -3282.9961, 8378.5039);
	angles[29] = (0, 114.0812, 25.9718);
	at[29] = 20;
	points[30] = (-5600.9844, -3533.3977, 8694.6855);
	angles[30] = (0, 112.2116, 27.1151);
	at[30] = 20.5000;
	points[31] = (-6188.7402, -3745.0906, 9028.9375);
	angles[31] = (0, 109.1003, 28.3361);
	at[31] = 21;
	points[32] = (-6778.7798, -3936.8113, 9371.2598);
	angles[32] = (0, 107.5654, 29.2019);
	at[32] = 21.5000;
	points[33] = (-7957.7559, -4300.5513, 10068.8193);
	angles[33] = (0, 107.1468, 29.4825);
	at[33] = 22.5000;
	points[34] = (-8545.7480, -4475.7480, 10423.3857);
	angles[34] = (0, 106.4188, 30.1879);
	at[34] = 23;
	points[35] = (-9134.5674, -4633.8188, 10784.4482);
	angles[35] = (0, 104.2500, 30.7747);
	at[35] = 23.5000;
	points[36] = (-9727.1260, -4765.3149, 11150.1973);
	angles[36] = (0, 102.5849, 31.0593);
	at[36] = 24;
	points[37] = (-10325.0781, -4869.1338, 11515.8662);
	angles[37] = (0, 99.5349, 31.0630);
	at[37] = 24.5000;
	points[38] = (-10929.6855, -4937.0474, 11878.2285);
	angles[38] = (0, 95.0111, 30.6212);
	at[38] = 25;
	points[39] = (-11541.1416, -4965.9448, 12233.5039);
	angles[39] = (0, 90.2209, 29.4172);
	at[39] = 25.5000;
	points[40] = (-12168.1885, -4909.0947, 12557.7168);
	angles[40] = (0, 83.6808, 26.2322);
	at[40] = 26;
	points[41] = (-12806.0625, -4805.0791, 12846.4961);
	angles[41] = (0, 79.2392, 23.1299);
	at[41] = 26.5000;
	points[42] = (-13446.8896, -4625.3936, 13087.7949);
	angles[42] = (0, 72.7060, 19.0011);
	at[42] = 27;
	points[43] = (-14081.1807, -4386.0630, 13294.1729);
	angles[43] = (0, 69.4706, 17.0178);
	at[43] = 27.5000;
	points[44] = (-14705.7090, -4113.0317, 13484.2520);
	angles[44] = (0, 64.5800, 14.7325);
	at[44] = 28;
	points[45] = (-15320.5518, -3806.5747, 13658.2686);
	angles[45] = (0, 63.5510, 14.2358);
	at[45] = 28.5000;
	points[46] = (-15913.9365, -3455.3032, 13819.7246);
	angles[46] = (0, 58.7539, 13.0168);
	at[46] = 29;
	points[47] = (-16502.1250, -3093.2363, 13978.1885);
	angles[47] = (0, 58.0427, 12.8587);
	at[47] = 29.5000;
	points[48] = (-17067.8730, -2693.7834, 14128.4648);
	angles[48] = (0, 54.9395, 12.2751);
	at[48] = 30;
	points[49] = (-17613.1504, -2268.7480, 14275.8262);
	angles[49] = (0, 49.0012, 11.7617);
	at[49] = 30.5000;
	points[50] = (-18111.8496, -1785.2992, 14416.5352);
	angles[50] = (0, 46.0208, 11.4640);
	at[50] = 31;
	points[51] = (-18566.1035, -1256.8976, 14543.7412);
	angles[51] = (0, 40.4375, 10.2937);
	at[51] = 31.5000;
	points[52] = (-18989.1348, -700.5512, 14650.3936);
	angles[52] = (0, 34.8376, 7.3322);
	at[52] = 32;
	points[53] = (-19373.1504, -110.1083, 14728.4648);
	angles[53] = (0, 33.1160, 6.3699);
	at[53] = 32.5000;
	points[54] = (-19680.3926, 524.6339, 14762.6768);
	angles[54] = (0, 24.0751, 1.9025);
	at[54] = 33;
	points[55] = (-19870.9062, 1204.1614, 14769.0557);
	angles[55] = (0, 13.3396, 0.2514);
	at[55] = 33.5000;
	points[56] = (-19976.3008, 1904.0631, 14769.4883);
	angles[56] = (0, 7.1200, 0.0189);
	at[56] = 34;
	points[57] = (-19979.6465, 2611.4961, 14769.4883);
	angles[57] = (0, -2.0901, 0);
	at[57] = 34.5000;
	points[58] = (-19770.9453, 3286.6101, 14769.4883);
	angles[58] = (0, -19.7928, 0);
	at[58] = 35;
	points[59] = (-19379.9219, 3866.7559, 14769.4883);
	angles[59] = (0, -39.0894, 0);
	at[59] = 35.5000;
	points[60] = (-18780.7480, 4235.2754, 14769.6064);
	angles[60] = (0, -61.6003, 0.0436);
	at[60] = 36;
	points[61] = (-18100.5918, 4434.1733, 14772.3232);
	angles[61] = (0, -73.1830, 0.2123);
	at[61] = 36.5000;
	points[62] = (-17403.9375, 4555.6694, 14784.0166);
	angles[62] = (0, -82.4432, 1.2605);
	at[62] = 37;
	points[63] = (-16697.6777, 4550.8662, 14812.2441);
	angles[63] = (0, -92.5041, 2.5554);
	at[63] = 37.5000;
	points[64] = (-15997.9922, 4451.1416, 14852.2451);
	angles[64] = (0, -99.1390, 3.3592);
	at[64] = 38;
	points[65] = (-15314.8428, 4273.8975, 14894.7246);
	angles[65] = (0, -106.9923, 3.2221);
	at[65] = 38.5000;
	points[66] = (-14661.1816, 4005.1577, 14927.2842);
	angles[66] = (0, -114.2012, 2.3912);
	at[66] = 39;
	points[67] = (-14035.6299, 3674.5630, 14945.6299);
	angles[67] = (0, -119.5226, 0.9706);
	at[67] = 39.5000;
	points[68] = (-13765.4336, 3151.5945, 14983.9756);
	angles[68] = (0, -172.6614, 5.1981);
	at[68] = 40;
	points[69] = (-13479.0557, 2632.9055, 14866.6143);
	angles[69] = (0, -136.1370, -16.5046);
	at[69] = 40.5000;
	points[70] = (-13002.9131, 2301.4331, 14468.5830);
	angles[70] = (0, -122.4700, -37.4203);
	at[70] = 41;
	points[71] = (-12579.2520, 2089.1299, 13952.9531);
	angles[71] = (0, -113.7528, -52.9266);
	at[71] = 41.5000;
	points[72] = (-12250.1973, 1979.3976, 13337.3232);
	angles[72] = (0, -106.4158, -63.1748);
	at[72] = 42;
	points[73] = (-11967.0479, 1909.2284, 12691.4971);
	angles[73] = (0, -104.0328, -65.5845);
	at[73] = 42.5000;
	points[74] = (-11659.9209, 1859.0237, 12054.9609);
	angles[74] = (0, -98.8831, -63.7710);
	at[74] = 43;
	points[75] = (-11349.5664, 1830.2126, 11418.6611);
	angles[75] = (0, -94.4294, -63.9687);
	at[75] = 43.5000;
	points[76] = (-11039.5674, 1808.7560, 10781.7715);
	angles[76] = (0, -93.9787, -63.9901);
	at[76] = 44;
	points[77] = (-10672.6768, 1794.3662, 10177.4805);
	angles[77] = (0, -91.7931, -56.9769);
	at[77] = 44.5000;
	points[78] = (-10276.6934, 1787.1968, 9589.8428);
	angles[78] = (0, -90.6537, -56.0725);
	at[78] = 45;
	points[79] = (-7901.4175, 1771.6851, 6063.1895);
	angles[79] = (0, -90.3742, -56.0385);
	at[79] = 48;
	points[80] = (-7367.0864, 1772.1851, 5608.8979);
	angles[80] = (0, -89.8938, -37.6706);
	at[80] = 48.5000;
	points[81] = (-5648.5039, 1776.2560, 4357.3623);
	angles[81] = (0, -89.8642, -36.0637);
	at[81] = 50;
	points[82] = (-5051.9688, 1779.2836, 3980.6694);
	angles[82] = (0, -89.5591, -28.2596);
	at[82] = 50.5000;
	points[83] = (-3764.1340, 1792, 3388.9055);
	angles[83] = (0, -89.4344, -24.6839);
	at[83] = 51.5000;
	points[84] = (-3116.7009, 1798.9094, 3104.4880);
	angles[84] = (0, -89.3010, -21.8355);
	at[84] = 52;
	points[85] = (-2418.1418, 1813.8228, 2986.1812);
	angles[85] = (0, -88.7984, -10.1302);
	at[85] = 52.5000;
	points[86] = (-1718.7401, 1828.1614, 2875.0906);
	angles[86] = (0, -88.9126, -7.9913);
	at[86] = 53;
	points[87] = (-1011.4960, 1837.1810, 2831.2285);
	angles[87] = (0, -89.2543, -3.7370);
	at[87] = 53.5000;
	points[88] = (-306.9268, 1854.3661, 2842.8191);
	angles[88] = (0, -87.9759, 5.1449);
	at[88] = 54;
	points[89] = (364.7914, 1919.3149, 3043.8230);
	angles[89] = (0, -83.3616, 19.3391);
	at[89] = 54.5000;
	points[90] = (1010.8622, 2004.5631, 3319.4490);
	angles[90] = (0, -82.3038, 25.0474);
	at[90] = 55;
	points[91] = (2241.1890, 2179.5117, 4000.9844);
	angles[91] = (0, -81.9077, 28.7351);
	at[91] = 56;
	points[92] = (2862.5435, 2274.7205, 4325.9053);
	angles[92] = (0, -80.4182, 25.2856);
	at[92] = 56.5000;
	points[93] = (3510.0986, 2402.6379, 4583.8188);
	angles[93] = (0, -78.8915, 21.5088);
	at[93] = 57;
	points[94] = (4166.8896, 2529.0945, 4812.4019);
	angles[94] = (0, -79.4085, 16.0578);
	at[94] = 57.5000;
	points[95] = (5531.2202, 2773.9724, 5108.0317);
	angles[95] = (0, -79.8239, 12.0475);
	at[95] = 58.5000;
	points[96] = (6215.2754, 2895.9565, 5246.8110);
	angles[96] = (0, -79.9430, 10.6660);
	at[96] = 59;
	points[97] = (8963.2686, 3381.0276, 5745.1182);
	angles[97] = (0, -79.9894, 10.1247);
	at[97] = 61;
	points[98] = (9653.1885, 3503.0276, 5850.6299);
	angles[98] = (0, -79.9659, 8.0361);
	at[98] = 61.5000;
	points[99] = (11727.5195, 3870.1892, 6137.2046);
	angles[99] = (0, -79.9626, 7.7470);
	at[99] = 63;
	points[100] = (12420.5908, 3996.3782, 6213.7402);
	angles[100] = (0, -79.6333, 5.9506);
	at[100] = 63.5000;
	points[101] = (14500.9854, 4378.0317, 6428.4253);
	angles[101] = (0, -79.6049, 5.7949);
	at[101] = 65;
	points[102] = (15195, 4506.9292, 6490.1182);
	angles[102] = (0, -79.4006, 4.4873);
	at[102] = 65.5000;
	points[103] = (17278.8984, 4898.8975, 6643.8979);
	angles[103] = (0, -79.3476, 4.1483);
	at[103] = 67;
	points[104] = (17974.0938, 5026.8896, 6693.1890);
	angles[104] = (0, -79.9568, 3.7051);
	at[104] = 67.5000;
	points[105] = (19371.3398, 5252.3228, 6768.9766);
	angles[105] = (0, -80.8326, 3.0666);
	at[105] = 68.5000;
	points[106] = (20068.0703, 5378.6221, 6795.6299);
	angles[106] = (0, -79.5479, 2.0098);
	at[106] = 69;
	points[107] = (24245.6289, 6157.6772, 6937.9526);
	angles[107] = (0, -79.4366, 1.9181);
	at[107] = 72;
	points[108] = (24941.6934, 6289.0156, 6958.1499);
	angles[108] = (0, -79.1621, 1.2826);
	at[108] = 72.5000;
	points[109] = (29114.4883, 7103.5430, 7017.6768);
	angles[109] = (0, -78.9548, 0.8023);
	at[109] = 75.5000;
	points[110] = (31878.7402, 7731.1421, 7031.4175);
	angles[110] = (0, -77.1908, 0.2728);
	at[110] = 77.5000;
	points[111] = (32427.9531, 7858.8188, 7033.9761);
	angles[111] = (0, -74.8725, 0.1426);
	at[111] = 78;
	points[112] = (34970.9453, 8630.5117, 7035.9844);
	angles[112] = (0, -73.1194, 0.0439);
	at[112] = 93;
	points[113] = (35053.3477, 8662.7959, 7036.0234);
	angles[113] = (0, -67.8107, 0.0036);
	at[113] = 93.5000;
	points[114] = (35135.1172, 8696.8896, 7036.0234);
	angles[114] = (0, -67.3698, 0);
	at[114] = 94;
	points[115] = (36606.6133, 9310.9453, 7036.0234);
	angles[115] = (0, -67.3502, 0);
	at[115] = 103;
	points[116] = (36687.5195, 9346.7715, 7036.0234);
	angles[116] = (0, -64.3260, 0);
	at[116] = 103.5000;
	points[117] = (36764.9219, 9389.8818, 7036.0234);
	angles[117] = (0, -61.0368, 0);
	at[117] = 104;
	points[118] = (38390.2383, 10294.8428, 7036.0234);
	angles[118] = (0, -60.8912, 0);
	at[118] = 114.5000;
	points[119] = (38458.0312, 10350.6299, 7036.0234);
	angles[119] = (0, -47.0382, 0);
	at[119] = 115;
	points[120] = (38520.7852, 10413.1494, 7036.0234);
	angles[120] = (0, -45.1911, 0);
	at[120] = 115.5000;
	points[121] = (39462.2070, 11350.9053, 7036.0234);
	angles[121] = (0, -45.1095, 0);
	at[121] = 123;
	points[122] = (39518.1094, 11418.9766, 7035.9448);
	angles[122] = (0, -36.2470, -0.0617);
	at[122] = 123.5000;
	points[123] = (39568.1133, 11492.2451, 7035.8271);
	angles[123] = (0, -34.3109, -0.0750);
	at[123] = 124;
	points[124] = (40514.5664, 12883.8584, 7033.6226);
	angles[124] = (0, -34.2251, -0.0756);
	at[124] = 133.5000;
	points[125] = (40561.4180, 12958.3857, 7033.3071);
	angles[125] = (0, -28.7132, -0.4469);
	at[125] = 134;
	points[126] = (40582.6797, 13044.4102, 7031.0635);
	angles[126] = (0, -14.2869, -1.3901);
	at[126] = 134.5000;
	points[127] = (40979.5273, 14679.4883, 6989.0552);
	angles[127] = (0, -13.6448, -1.4304);
	at[127] = 144;
	points[128] = (40977.9531, 14767.6377, 6981.2993);
	angles[128] = (0, 0.4622, -4.9366);
	at[128] = 144.5000;
	points[129] = (40959.4492, 15738.0713, 6894.9214);
	angles[129] = (0, 1.0926, -5.0872);
	at[129] = 150;
	points[130] = (40953.5430, 15825.4336, 6885.4727);
	angles[130] = (0, 8.4664, -7.7236);
	at[130] = 150.5000;
	points[131] = (40930.3164, 15909.5273, 6870.0391);
	angles[131] = (0, 15.0604, -9.9497);
	at[131] = 151;
	points[132] = (40653.1484, 16918.8594, 6684.6064);
	angles[132] = (0, 15.3545, -10.0456);
	at[132] = 157;
	points[133] = (40628.3438, 17002.0859, 6668.4253);
	angles[133] = (0, 19.2160, -11.6454);
	at[133] = 157.5000;
	points[134] = (40585.8281, 17076.0234, 6644.4487);
	angles[134] = (0, 29.4656, -15.5389);
	at[134] = 158;
	points[135] = (39522.4414, 18923.6230, 6045.1182);
	angles[135] = (0, 29.9287, -15.7015);
	at[135] = 170.5000;
	points[136] = (39476.7734, 18996.2207, 6022.7168);
	angles[136] = (0, 33.5063, -13.8945);
	at[136] = 171;
	points[137] = (37227.9922, 22261.4180, 5082.0078);
	angles[137] = (0, 34.5571, -13.3480);
	at[137] = 194;
	points[138] = (37180.1992, 22334.4902, 5069.0161);
	angles[138] = (0, 32.4617, -5.8156);
	at[138] = 194.5000;
	points[139] = (34511.7344, 26605.8281, 4708.3071);
	angles[139] = (0, 31.9945, -4.0969);
	at[139] = 223;
	points[140] = (34468.3867, 26682.8359, 4704.5278);
	angles[140] = (0, 27.5137, -1.2518);
	at[140] = 223.5000;
	points[141] = (32553.3867, 30577.8730, 4673.9766);
	angles[141] = (0, 25.5114, -0.2397);
	at[141] = 248;
	points[142] = (30677.0859, 34687.5977, 4673.8188);
	angles[142] = (0, 24.5390, -0.0020);
	at[142] = 273.5000;
	points[143] = (30631.6934, 34763.5430, 4673.8188);
	angles[143] = (0, 31.5120, 0);
	at[143] = 274;
	points[144] = (29270.5918, 36942.2461, 4673.8188);
	angles[144] = (0, 31.9942, 0);
	at[144] = 288.5000;
	points[145] = (29221.5352, 37015.8672, 4673.8188);
	angles[145] = (0, 35.5847, 0);
	at[145] = 289;
	points[146] = (29111.7324, 37154.8828, 4673.8188);
	angles[146] = (0, 38.2969, 0);
	at[146] = 290;
	points[147] = (27848.9355, 38753.7383, 4673.8188);
	angles[147] = (0, 38.3018, 0);
	at[147] = 301.5000;
	points[148] = (27781.3770, 38810.1172, 4673.8188);
	angles[148] = (0, 52.4622, 0);
	at[148] = 302;
	points[149] = (27709.8438, 38862.3633, 4673.8188);
	angles[149] = (0, 53.7884, 0);
	at[149] = 302.5000;
	points[150] = (26136.2988, 40012.2070, 4673.8188);
	angles[150] = (0, 53.8471, 0);
	at[150] = 313.5000;
	points[151] = (26056.6543, 40048.0312, 4673.8188);
	angles[151] = (0, 70.5438, 0);
	at[151] = 314;
	points[152] = (25971.8516, 40073.6211, 4673.8188);
	angles[152] = (0, 73.0639, 0);
	at[152] = 314.5000;
	points[153] = (23936.8906, 40688.9766, 4673.8188);
	angles[153] = (0, 73.1755, 0);
	at[153] = 326.5000;
	points[154] = (23850.2754, 40700, 4673.8188);
	angles[154] = (0, 88.7573, 0);
	at[154] = 327;
	points[155] = (23673.3457, 40691.3398, 4673.8188);
	angles[155] = (0, 92.8306, 0);
	at[155] = 328;
	points[156] = (21549.9609, 40585.8281, 4673.7793);
	angles[156] = (0, 92.8379, 0);
	at[156] = 340;
	points[157] = (21476.1426, 40540.1562, 4672.7559);
	angles[157] = (0, 124.0805, -0.7325);
	at[157] = 340.5000;
	points[158] = (18826.8105, 38611.0625, 4628.5039);
	angles[158] = (0, 126.0595, -0.7737);
	at[158] = 359;
	points[159] = (18768.2285, 38548.5039, 4625.7876);
	angles[159] = (0, 146.5901, -2.6897);
	at[159] = 359.5000;
	points[160] = (18732.5996, 38467.5586, 4620.3940);
	angles[160] = (0, 155.8370, -3.4530);
	at[160] = 360;
	points[161] = (18696.9688, 38386.6523, 4615);
	angles[161] = (0, 156.2301, -3.4835);
	at[161] = 360.5000;
	points[162] = (16061.5361, 32397.8750, 4216.5747);
	angles[162] = (0, 156.2476, -3.4849);
	at[162] = 397.5000;
	points[163] = (15986.7715, 32156.0625, 4204.8428);
	angles[163] = (0, 161.6145, -2.8077);
	at[163] = 398;
	points[164] = (15803.6611, 31472.0859, 4175.5903);
	angles[164] = (0, 164.8694, -2.3842);
	at[164] = 398.5000;
	points[165] = (13423.3867, 22580.4727, 3795.3782);
	angles[165] = (0, 165.0947, -2.1913);
	at[165] = 405;
	points[166] = (13249.8818, 21893.4258, 3787.6812);
	angles[166] = (0, 165.7945, -0.6914);
	at[166] = 405.5000;
	points[167] = (13112.7158, 21198.1895, 3786.2363);
	angles[167] = (0, 168.7962, -0.1269);
	at[167] = 406;
	points[168] = (10496.8105, 7821.7324, 3763.1221);
	angles[168] = (0, 169.0430, -0.0059);
	at[168] = 415.6170;
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
	points[0] = (10608.7402, 8400.3936, 3763.1221);
	angles[0] = (0, 168.9521, -0.0825);
	at[0] = 0;
	points[1] = (9803.0312, 4225.4331, 3763.1221);
	angles[1] = (0, 169.0817, 0);
	at[1] = 3;
	points[2] = (9665.6689, 3530.2717, 3763.1221);
	angles[2] = (0, 168.4004, 0);
	at[2] = 3.5000;
	points[3] = (8906.4570, 69.2524, 3763.1221);
	angles[3] = (0, 167.6275, 0);
	at[3] = 6;
	points[4] = (8605.9053, -1315.8385, 3763.1221);
	angles[4] = (0, 167.7817, 0);
	at[4] = 7;
	points[5] = (8038.5039, -1240.3976, 3761.6733);
	angles[5] = (0, 78.3774, -0.1453);
	at[5] = 7.5000;
	points[6] = (7378.1108, -984.7914, 3734.5195);
	angles[6] = (0, 69.2443, -2.1196);
	at[6] = 8;
	points[7] = (6694.6460, -828.4055, 3654.0471);
	angles[7] = (0, 80.1283, -7.9618);
	at[7] = 8.5000;
	points[8] = (6037.8345, -984.1339, 3557.0396);
	angles[8] = (0, 112.8268, -7.9594);
	at[8] = 9;
	points[9] = (5744.6060, -1602.1221, 3490.8230);
	angles[9] = (0, 160.9950, -3.8660);
	at[9] = 9.5000;
	points[10] = (5748.3862, -2272.6260, 3661.5315);
	angles[10] = (0, 187.0058, 18.3555);
	at[10] = 10;
	points[11] = (6019.0552, -2834.5276, 3995.3152);
	angles[11] = (0, 202.7539, 29.3451);
	at[11] = 10.5000;
	points[12] = (6083.6221, -3443.9253, 4340.5513);
	angles[12] = (0, 181.2474, 28.8416);
	at[12] = 11;
	points[13] = (5945.5908, -4049.5276, 4675.6299);
	angles[13] = (0, 163.7497, 28.0967);
	at[13] = 11.5000;
	points[14] = (5585.5513, -4557.9531, 5003.9766);
	angles[14] = (0, 139.7194, 27.4993);
	at[14] = 12;
	points[15] = (5040.5908, -4897.4409, 5290.9058);
	angles[15] = (0, 116.8998, 22.6609);
	at[15] = 12.5000;
	points[16] = (4378.8584, -4990.3545, 5503.4644);
	angles[16] = (0, 93.3557, 15.4232);
	at[16] = 13;
	points[17] = (3691.2480, -4874.2915, 5603.1890);
	angles[17] = (0, 77.5299, 6.4896);
	at[17] = 13.5000;
	points[18] = (3022.4961, -4644.1733, 5644.8032);
	angles[18] = (0, 70.9867, 4.0369);
	at[18] = 14;
	points[19] = (2355.9802, -4409.4097, 5698.1890);
	angles[19] = (0, 70.6143, 4.3095);
	at[19] = 14.5000;
	points[20] = (1689.1023, -4177.4019, 5755.7090);
	angles[20] = (0, 71.4610, 5.6409);
	at[20] = 15;
	points[21] = (1017.2953, -3982.2837, 5868.8584);
	angles[21] = (0, 73.7050, 9.0389);
	at[21] = 15.5000;
	points[22] = (354.1858, -3769.9370, 6000.0786);
	angles[22] = (0, 72.0035, 10.8906);
	at[22] = 16;
	points[23] = (-294.8760, -3532.5750, 6155.9448);
	angles[23] = (0, 69.5491, 13.0169);
	at[23] = 16.5000;
	points[24] = (-928.6182, -3277.5513, 6343.1494);
	angles[24] = (0, 67.6416, 16.0598);
	at[24] = 17;
	points[25] = (-1534.6812, -3011.0315, 6592.5195);
	angles[25] = (0, 65.8327, 22.1891);
	at[25] = 17.5000;
	points[26] = (-2126.2676, -2746.9211, 6878.9375);
	angles[26] = (0, 66.4781, 24.8416);
	at[26] = 18;
	points[27] = (-2720.7954, -2561.0710, 7213.7402);
	angles[27] = (0, 75.1376, 27.9287);
	at[27] = 18.5000;
	points[28] = (-3347.7952, -2578.6614, 7524.2915);
	angles[28] = (0, 97.8130, 24.5314);
	at[28] = 19;
	points[29] = (-3947.8740, -2802.6418, 7823.0708);
	angles[29] = (0, 112.2936, 25.4375);
	at[29] = 19.5000;
	points[30] = (-4534.7246, -3066.7598, 8119.6855);
	angles[30] = (0, 114.0951, 25.2367);
	at[30] = 20;
	points[31] = (-5116.1025, -3326.5789, 8430.6699);
	angles[31] = (0, 114.0809, 25.9951);
	at[31] = 20.5000;
	points[32] = (-5699.1338, -3571.1025, 8750.1182);
	angles[32] = (0, 111.7217, 27.3941);
	at[32] = 21;
	points[33] = (-6287.7954, -3778.2993, 9085.6699);
	angles[33] = (0, 108.8696, 28.4065);
	at[33] = 21.5000;
	points[34] = (-6877.6768, -3967.3228, 9429.7637);
	angles[34] = (0, 107.3940, 29.3172);
	at[34] = 22;
	points[35] = (-8056.6143, -4331.0630, 10127.3232);
	angles[35] = (0, 107.1465, 29.4828);
	at[35] = 23;
	points[36] = (-8644.3701, -4503.6616, 10483.5820);
	angles[36] = (0, 106.1193, 30.3094);
	at[36] = 23.5000;
	points[37] = (-9233.9766, -4655.8662, 10845.8271);
	angles[37] = (0, 103.5392, 30.8990);
	at[37] = 24;
	points[38] = (-9826.5352, -4787.3623, 11211.5742);
	angles[38] = (0, 102.5544, 31.0642);
	at[38] = 24.5000;
	points[39] = (-10425.5908, -4885.6299, 11577.1650);
	angles[39] = (0, 99.4393, 31.0618);
	at[39] = 25;
	points[40] = (-11031.8115, -4944.4487, 11938.5820);
	angles[40] = (0, 94.6564, 30.5788);
	at[40] = 25.5000;
	points[41] = (-11645.7881, -4958.2285, 12289.3701);
	angles[41] = (0, 88.3938, 28.8619);
	at[41] = 26;
	points[42] = (-12275.0400, -4893.7012, 12607.4805);
	angles[42] = (0, 82.9106, 25.6253);
	at[42] = 26.5000;
	points[43] = (-12913.8184, -4777.1260, 12888.2676);
	angles[43] = (0, 77.6716, 22.0908);
	at[43] = 27;
	points[44] = (-13553.2676, -4585.2363, 13122.4014);
	angles[44] = (0, 71.3139, 18.1599);
	at[44] = 27.5000;
	points[45] = (-14187.5986, -4345.9058, 13328.7793);
	angles[45] = (0, 69.4125, 16.9814);
	at[45] = 28;
	points[46] = (-14808.8584, -4061.6143, 13513.4648);
	angles[46] = (0, 64.1395, 14.5207);
	at[46] = 28.5000;
	points[47] = (-15423.6611, -3755.1655, 13687.4414);
	angles[47] = (0, 63.5323, 14.2267);
	at[47] = 29;
	points[48] = (-16012.5986, -3394.5669, 13846.2998);
	angles[48] = (0, 58.6033, 12.9770);
	at[48] = 29.5000;
	points[49] = (-16596.8906, -3025.9961, 14003.3467);
	angles[49] = (0, 56.7142, 12.6135);
	at[49] = 30;
	points[50] = (-17162.8359, -2626.8228, 14153.7012);
	angles[50] = (0, 54.8833, 12.2642);
	at[50] = 30.5000;
	points[51] = (-17696.8105, -2187.6497, 14299.4492);
	angles[51] = (0, 47.7262, 11.6382);
	at[51] = 31;
	points[52] = (-18192.2441, -1700.9055, 14439.1338);
	angles[52] = (0, 44.8636, 11.2333);
	at[52] = 31.5000;
	points[53] = (-18641.4570, -1167.4016, 14564.8428);
	angles[53] = (0, 40.2977, 10.2629);
	at[53] = 32;
	points[54] = (-19053.5430, -601.5079, 14663.4648);
	angles[54] = (0, 34.1005, 6.9215);
	at[54] = 32.5000;
	points[55] = (-19437.5977, -11.0619, 14741.5752);
	angles[55] = (0, 33.0850, 6.3524);
	at[55] = 33;
	points[56] = (-19727.0078, 633.9489, 14765.6299);
	angles[56] = (0, 23.6733, 1.7013);
	at[56] = 33.5000;
	points[57] = (-19895.8281, 1320.3977, 14769.2529);
	angles[57] = (0, 12.8283, 0.1828);
	at[57] = 34;
	points[58] = (-19989.2910, 2022.2244, 14769.4883);
	angles[58] = (0, 6.7767, 0.0114);
	at[58] = 34.5000;
	points[59] = (-19948.4648, 2726.5354, 14769.4883);
	angles[59] = (0, -6.9109, 0);
	at[59] = 35;
	points[60] = (-19721.8906, 3394.9016, 14769.4883);
	angles[60] = (0, -21.6625, 0);
	at[60] = 35.5000;
	points[61] = (-19299.2910, 3954.0945, 14769.4883);
	angles[61] = (0, -42.3119, 0);
	at[61] = 36;
	points[62] = (-18666.6543, 4268.6221, 14770.0791);
	angles[62] = (0, -66.5396, 0.1162);
	at[62] = 36.5000;
	points[63] = (-17985.5918, 4463.7793, 14773.1895);
	angles[63] = (0, -74.4061, 0.3216);
	at[63] = 37;
	points[64] = (-17285.4727, 4564.7637, 14787.4805);
	angles[64] = (0, -83.7402, 1.4324);
	at[64] = 37.5000;
	points[65] = (-16579.2129, 4542.7954, 14817.9131);
	angles[65] = (0, -93.0688, 2.6258);
	at[65] = 38;
	points[66] = (-15881.5752, 4428.4253, 14859.9609);
	angles[66] = (0, -99.9250, 3.5084);
	at[66] = 38.5000;
	points[67] = (-15202.5205, 4235.5513, 14901.1025);
	angles[67] = (0, -107.7571, 3.1666);
	at[67] = 39;
	points[68] = (-14553.8584, 3954.2915, 14931.9287);
	angles[68] = (0, -114.6783, 2.3301);
	at[68] = 39.5000;
	points[69] = (-13933.5430, 3613.6616, 14946.8506);
	angles[69] = (0, -120.0540, 0.8121);
	at[69] = 40;
	points[70] = (-13782.1650, 3034.5317, 14996.1025);
	angles[70] = (0, -178.9660, 5.5170);
	at[70] = 40.5000;
	points[71] = (-13395.5898, 2567.8503, 14813.8984);
	angles[71] = (0, -132.9739, -20.9932);
	at[71] = 41;
	points[72] = (-12924.1348, 2256.7166, 14391.5742);
	angles[72] = (0, -121.3167, -38.6350);
	at[72] = 41.5000;
	points[73] = (-12519.1338, 2066.5000, 13852.9141);
	angles[73] = (0, -112.5599, -54.7292);
	at[73] = 42;
	points[74] = (-12202.7168, 1967.6260, 13229.0156);
	angles[74] = (0, -105.4476, -64.2099);
	at[74] = 42.5000;
	points[75] = (-11919.5283, 1897.4567, 12583.1895);
	angles[75] = (0, -103.4132, -65.4319);
	at[75] = 43;
	points[76] = (-11607.7168, 1851.1693, 11948.4648);
	angles[76] = (0, -98.7484, -63.7162);
	at[76] = 43.5000;
	points[77] = (-11297.5596, 1826.6141, 11311.8115);
	angles[77] = (0, -94.2367, -63.9780);
	at[77] = 44;
	points[78] = (-10987.5596, 1805.1576, 10674.9219);
	angles[78] = (0, -93.9706, -63.9905);
	at[78] = 44.5000;
	points[79] = (-10606.2207, 1792.5590, 10078.8975);
	angles[79] = (0, -91.6946, -56.5777);
	at[79] = 45;
	points[80] = (-10210.2754, 1786.7638, 9491.2207);
	angles[80] = (0, -90.5392, -56.0587);
	at[80] = 45.5000;
	points[81] = (-7835, 1771.2520, 5964.6064);
	angles[81] = (0, -90.3742, -56.0385);
	at[81] = 48.5000;
	points[82] = (-7270.9844, 1772.4133, 5538.8979);
	angles[82] = (0, -89.8815, -37.0124);
	at[82] = 49;
	points[83] = (-5552.4019, 1776.4843, 4287.4019);
	angles[83] = (0, -89.8642, -36.0636);
	at[83] = 50.5000;
	points[84] = (-4943.9370, 1780.3505, 3931.0198);
	angles[84] = (0, -89.5070, -26.7930);
	at[84] = 51;
	points[85] = (-3656.1182, 1793.0669, 3339.2754);
	angles[85] = (0, -89.4343, -24.6812);
	at[85] = 52;
	points[86] = (-2999.5156, 1801.4135, 3084.6418);
	angles[86] = (0, -89.0794, -16.8444);
	at[86] = 52.5000;
	points[87] = (-2300.9607, 1816.3229, 2966.3347);
	angles[87] = (0, -88.7896, -9.9173);
	at[87] = 53;
	points[88] = (-1600.1024, 1829.6772, 2867.7324);
	angles[88] = (0, -89.0593, -6.1727);
	at[88] = 53.5000;
	points[89] = (-892.8583, 1838.6930, 2823.8701);
	angles[89] = (0, -89.2606, -3.6598);
	at[89] = 54;
	points[90] = (-189.5000, 1859.5748, 2860.5789);
	angles[90] = (0, -87.7652, 6.5561);
	at[90] = 54.5000;
	points[91] = (474.7205, 1933.5039, 3086.7915);
	angles[91] = (0, -83.0298, 20.1970);
	at[91] = 55;
	points[92] = (1114.0552, 2019.2363, 3376.6104);
	angles[92] = (0, -82.1425, 26.5643);
	at[92] = 55.5000;
	points[93] = (2344.3779, 2194.1851, 4058.1499);
	angles[93] = (0, -81.9074, 28.7379);
	at[93] = 56.5000;
	points[94] = (2971.1692, 2296.1772, 4369.1733);
	angles[94] = (0, -79.7547, 23.6728);
	at[94] = 57;
	points[95] = (3618.7246, 2424.0945, 4627.0474);
	angles[95] = (0, -78.8644, 21.4400);
	at[95] = 57.5000;
	points[96] = (4281.2993, 2549.6338, 4837.2046);
	angles[96] = (0, -79.6055, 14.1764);
	at[96] = 58;
	points[97] = (5645.6299, 2794.5117, 5132.8345);
	angles[97] = (0, -79.8242, 12.0441);
	at[97] = 59;
	points[98] = (6330.5117, 2916.2991, 5267.7168);
	angles[98] = (0, -79.9621, 10.4443);
	at[98] = 59.5000;
	points[99] = (9078.5439, 3401.3701, 5766.0239);
	angles[99] = (0, -79.9894, 10.1247);
	at[99] = 61.5000;
	points[100] = (9769.1729, 3523.5591, 5866.6538);
	angles[100] = (0, -79.9645, 7.9177);
	at[100] = 62;
	points[101] = (11843.5430, 3890.7168, 6153.2285);
	angles[101] = (0, -79.9626, 7.7470);
	at[101] = 63.5000;
	points[102] = (14617.3232, 4399.3701, 6440.4336);
	angles[102] = (0, -79.6049, 5.7949);
	at[102] = 65.5000;
	points[103] = (15311.5352, 4528.8584, 6498.7007);
	angles[103] = (0, -79.3788, 4.3484);
	at[103] = 66;
	points[104] = (17395.3926, 4920.7876, 6652.5195);
	angles[104] = (0, -79.3477, 4.1482);
	at[104] = 67.5000;
	points[105] = (18091.3008, 5045.7871, 6699.5278);
	angles[105] = (0, -80.3162, 3.4433);
	at[105] = 68;
	points[106] = (19488.5039, 5271.2207, 6775.3540);
	angles[106] = (0, -80.8331, 3.0661);
	at[106] = 69;
	points[107] = (24362.4434, 6179.4487, 6941.9292);
	angles[107] = (0, -79.4366, 1.9181);
	at[107] = 72.5000;
	points[108] = (25058.3457, 6311.8115, 6959.8037);
	angles[108] = (0, -79.0771, 1.0859);
	at[108] = 73;
	points[109] = (28535.6699, 6990.5908, 7009.4097);
	angles[109] = (0, -78.9548, 0.8023);
	at[109] = 75.5000;
	points[110] = (29230.5898, 7129.0156, 7018.5044);
	angles[110] = (0, -78.3481, 0.6203);
	at[110] = 76;
	points[111] = (31994.6465, 7757.4800, 7032.0083);
	angles[111] = (0, -77.1908, 0.2728);
	at[111] = 78;
	points[112] = (32442.8340, 7863.3071, 7033.9761);
	angles[112] = (0, -74.1546, 0.1022);
	at[112] = 78.5000;
	points[113] = (34985.8281, 8635, 7036.0234);
	angles[113] = (0, -73.1194, 0.0439);
	at[113] = 93.5000;
	points[114] = (35067.6758, 8668.7793, 7036.0234);
	angles[114] = (0, -67.6221, 0.0022);
	at[114] = 94;
	points[115] = (36620.9453, 9316.9287, 7036.0234);
	angles[115] = (0, -67.3502, 0);
	at[115] = 103.5000;
	points[116] = (36701.1016, 9354.3311, 7036.0234);
	angles[116] = (0, -62.7170, 0);
	at[116] = 104;
	points[117] = (38403.7812, 10302.4014, 7036.0234);
	angles[117] = (0, -60.8912, 0);
	at[117] = 115;
	points[118] = (38469.0547, 10361.5742, 7036.0234);
	angles[118] = (0, -46.2485, 0);
	at[118] = 115.5000;
	points[119] = (38531.8125, 10424.0947, 7036.0234);
	angles[119] = (0, -45.1576, 0);
	at[119] = 116;
	points[120] = (39473.2305, 11361.8906, 7036.0234);
	angles[120] = (0, -45.1095, 0);
	at[120] = 123.5000;
	points[121] = (39526.7695, 11431.8496, 7035.9448);
	angles[121] = (0, -35.4191, -0.0674);
	at[121] = 124;
	points[122] = (39576.7734, 11505.0791, 7035.8271);
	angles[122] = (0, -34.2757, -0.0753);
	at[122] = 124.5000;
	points[123] = (40523.2305, 12896.6924, 7033.5825);
	angles[123] = (0, -34.2251, -0.0756);
	at[123] = 134;
	points[124] = (40565.3555, 12973.4648, 7032.9136);
	angles[124] = (0, -21.6820, -0.9139);
	at[124] = 134.5000;
	points[125] = (40586.2227, 13059.5283, 7030.7090);
	angles[125] = (0, -13.9860, -1.4090);
	at[125] = 135;
	points[126] = (40962.2031, 14608.5039, 6990.9058);
	angles[126] = (0, -13.6448, -1.4304);
	at[126] = 144;
	points[127] = (40979.5273, 14694.9219, 6987.7954);
	angles[127] = (0, -7.6502, -2.9462);
	at[127] = 144.5000;
	points[128] = (40977.9531, 14783.1104, 6979.9209);
	angles[128] = (0, 0.7203, -4.9983);
	at[128] = 145;
	points[129] = (40959.4492, 15753.5049, 6893.5430);
	angles[129] = (0, 1.0926, -5.0872);
	at[129] = 150.5000;
	points[130] = (40949.6055, 15840.1572, 6882.7563);
	angles[130] = (0, 11.2737, -8.6887);
	at[130] = 151;
	points[131] = (40926.3789, 15924.2910, 6867.3228);
	angles[131] = (0, 15.1808, -9.9890);
	at[131] = 151.5000;
	points[132] = (40649.2109, 16933.6230, 6681.8901);
	angles[132] = (0, 15.3545, -10.0456);
	at[132] = 157.5000;
	points[133] = (40620.8672, 17015.0801, 6664.2124);
	angles[133] = (0, 23.5475, -13.3573);
	at[133] = 158;
	points[134] = (40578.3438, 17088.9766, 6640.2363);
	angles[134] = (0, 29.6552, -15.6056);
	at[134] = 158.5000;
	points[135] = (40535.8281, 17162.8750, 6616.2598);
	angles[135] = (0, 29.9171, -15.6974);
	at[135] = 159;
	points[136] = (39514.9609, 18936.5762, 6040.9448);
	angles[136] = (0, 29.9287, -15.7015);
	at[136] = 171;
	points[137] = (39419.2930, 19079.6445, 5998.7012);
	angles[137] = (0, 34.5309, -13.3616);
	at[137] = 172;
	points[138] = (37219.4102, 22273.8203, 5078.4253);
	angles[138] = (0, 34.5571, -13.3480);
	at[138] = 194.5000;
	points[139] = (37172.0078, 22347.5996, 5067.9136);
	angles[139] = (0, 32.2424, -5.0104);
	at[139] = 195;
	points[140] = (34503.5430, 26618.9766, 4707.1650);
	angles[140] = (0, 31.9945, -4.0969);
	at[140] = 223.5000;
	points[141] = (34461.5352, 26696.7324, 4704.4092);
	angles[141] = (0, 26.9699, -0.9049);
	at[141] = 224;
	points[142] = (32546.9297, 30592.0078, 4673.9766);
	angles[142] = (0, 25.1132, -0.1423);
	at[142] = 248.5000;
	points[143] = (30670.6309, 34701.7344, 4673.8188);
	angles[143] = (0, 25.2830, -0.0018);
	at[143] = 274;
	points[144] = (30623.4648, 34776.6953, 4673.8188);
	angles[144] = (0, 31.7095, 0);
	at[144] = 274.5000;
	points[145] = (29262.3613, 36955.3945, 4673.8188);
	angles[145] = (0, 31.9942, 0);
	at[145] = 289;
	points[146] = (29211.8906, 37028.0703, 4673.8188);
	angles[146] = (0, 36.8576, 0);
	at[146] = 289.5000;
	points[147] = (27839.3320, 38765.9453, 4673.8188);
	angles[147] = (0, 38.3018, 0);
	at[147] = 302;
	points[148] = (27768.8203, 38819.2500, 4673.8188);
	angles[148] = (0, 53.1111, 0);
	at[148] = 302.5000;
	points[149] = (27697.2832, 38871.5352, 4673.8188);
	angles[149] = (0, 53.8159, 0);
	at[149] = 303;
	points[150] = (26123.7422, 40021.2578, 4673.8188);
	angles[150] = (0, 53.8471, 0);
	at[150] = 314;
	points[151] = (26041.7715, 40052.3633, 4673.8188);
	angles[151] = (0, 71.6212, 0);
	at[151] = 314.5000;
	points[152] = (25956.9688, 40078.3477, 4673.8188);
	angles[152] = (0, 73.1095, 0);
	at[152] = 315;
	points[153] = (23922.0098, 40693.6992, 4673.8188);
	angles[153] = (0, 73.1755, 0);
	at[153] = 327;
	points[154] = (23834.8027, 40699.2148, 4673.8188);
	angles[154] = (0, 90.4277, 0);
	at[154] = 327.5000;
	points[155] = (23746.2988, 40694.8828, 4673.8188);
	angles[155] = (0, 92.7357, 0);
	at[155] = 328;
	points[156] = (21622.9121, 40589.7617, 4673.7793);
	angles[156] = (0, 92.8379, 0);
	at[156] = 340;
	points[157] = (21535.1562, 40583.0742, 4673.7402);
	angles[157] = (0, 98.9297, -0.1505);
	at[157] = 340.5000;
	points[158] = (21463.5820, 40531.1016, 4672.5591);
	angles[158] = (0, 124.8909, -0.7495);
	at[158] = 341;
	points[159] = (21391.9688, 40478.7422, 4671.3389);
	angles[159] = (0, 126.0100, -0.7727);
	at[159] = 341.5000;
	points[160] = (18814.2520, 38601.9297, 4628.2676);
	angles[160] = (0, 126.0595, -0.7737);
	at[160] = 359.5000;
	points[161] = (18761.9688, 38534.3320, 4624.8428);
	angles[161] = (0, 151.1060, -3.0726);
	at[161] = 360;
	points[162] = (18726.3379, 38453.3867, 4619.4487);
	angles[162] = (0, 156.0294, -3.4679);
	at[162] = 360.5000;
	points[163] = (16055.3145, 32383.6621, 4215.6299);
	angles[163] = (0, 156.2476, -3.4849);
	at[163] = 398;
	points[164] = (15956.0234, 32041.3379, 4199.9214);
	angles[164] = (0, 163.0064, -2.6277);
	at[164] = 398.5000;
	points[165] = (13575.7480, 23149.6855, 3819.7205);
	angles[165] = (0, 165.0135, -2.3653);
	at[165] = 405;
	points[166] = (13394.2910, 22465.1973, 3794.1143);
	angles[166] = (0, 165.3940, -1.5499);
	at[166] = 405.5000;
	points[167] = (13225.9844, 21776.9688, 3787.2874);
	angles[167] = (0, 167.0779, -0.4502);
	at[167] = 406;
	points[168] = (10608.7402, 8400.3936, 3763.1221);
	angles[168] = (0, 168.9521, -0.0825);
	at[168] = 415.6170;
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
