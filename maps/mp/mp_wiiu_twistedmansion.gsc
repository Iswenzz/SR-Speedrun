main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_twistedmansion", 0);

	setExpFog(0, 12303.1484, 0.1529, 0.2431, 0.5647, 0);

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
	ambientPlay("iz_0_utm", 2);
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
	level.iz_route[level.iz_route.size] = (4169, 5994, 8436);
	level.iz_route[level.iz_route.size] = (4171, 4688, 8588);
	level.iz_route[level.iz_route.size] = (4177, 3714, 8815);
	level.iz_route[level.iz_route.size] = (4199, 1948, 8824);
	level.iz_route[level.iz_route.size] = (3772, 1138, 8852);
	level.iz_route[level.iz_route.size] = (3762, -338, 9147);
	level.iz_route[level.iz_route.size] = (3791, -1810, 9467);
	level.iz_route[level.iz_route.size] = (3795, -6931, 9476);
	level.iz_route[level.iz_route.size] = (3789, -9730, 9087);
	level.iz_route[level.iz_route.size] = (4216, -10624, 9020);
	level.iz_route[level.iz_route.size] = (4193, -11526, 9036);
	level.iz_route[level.iz_route.size] = (4222, -12407, 9135);
	level.iz_route[level.iz_route.size] = (4509, -12990, 9325);
	level.iz_route[level.iz_route.size] = (5054, -13354, 9475);
	level.iz_route[level.iz_route.size] = (5658, -13523, 9550);
	level.iz_route[level.iz_route.size] = (6468, -13374, 9479);
	level.iz_route[level.iz_route.size] = (7139, -12860, 9249);
	level.iz_route[level.iz_route.size] = (7436, -12307, 9035);
	level.iz_route[level.iz_route.size] = (7625, -11613, 8786);
	level.iz_route[level.iz_route.size] = (7806, -11084, 8646);
	level.iz_route[level.iz_route.size] = (8102, -10224, 8636);
	level.iz_route[level.iz_route.size] = (8505, -6642, 7731);
	level.iz_route[level.iz_route.size] = (9610, -4485, 5671);
	level.iz_route[level.iz_route.size] = (10336, -4019, 5580);
	level.iz_route[level.iz_route.size] = (10696, -3510, 5705);
	level.iz_route[level.iz_route.size] = (10725, -2734, 5783);
	level.iz_route[level.iz_route.size] = (10433, -2081, 5838);
	level.iz_route[level.iz_route.size] = (9431, -1380, 5826);
	level.iz_route[level.iz_route.size] = (7095, 188, 5745);
	level.iz_route[level.iz_route.size] = (6842, 546, 5757);
	level.iz_route[level.iz_route.size] = (6761, 978, 5771);
	level.iz_route[level.iz_route.size] = (6819, 1556, 5801);
	level.iz_route[level.iz_route.size] = (7545, 3129, 5862);
	level.iz_route[level.iz_route.size] = (8132, 3442, 5879);
	level.iz_route[level.iz_route.size] = (9233, 3155, 5888);
	level.iz_route[level.iz_route.size] = (10068, 2821, 5889);
	level.iz_route[level.iz_route.size] = (11462, 2299, 5893);
	level.iz_route[level.iz_route.size] = (11902, 2587, 5915);
	level.iz_route[level.iz_route.size] = (12806, 4646, 6005);
	level.iz_route[level.iz_route.size] = (12984, 5103, 6023);
	level.iz_route[level.iz_route.size] = (13013, 6058, 6060);
	level.iz_route[level.iz_route.size] = (13476, 7436, 6109);
	level.iz_route[level.iz_route.size] = (13801, 8591, 6145);
	level.iz_route[level.iz_route.size] = (13610, 9256, 6149);
	level.iz_route[level.iz_route.size] = (12519, 10238, 6176);
	level.iz_route[level.iz_route.size] = (10885, 11329, 6348);
	level.iz_route[level.iz_route.size] = (9574, 12227, 6665);
	level.iz_route[level.iz_route.size] = (9013, 12550, 7030);
	level.iz_route[level.iz_route.size] = (7188, 13318, 6799);
	level.iz_route[level.iz_route.size] = (6478, 13640, 6799);
	level.iz_route[level.iz_route.size] = (5788, 13943, 6799);
	level.iz_route[level.iz_route.size] = (5260, 14152, 6973);
	level.iz_route[level.iz_route.size] = (4594, 14451, 6799);
	level.iz_route[level.iz_route.size] = (3128, 15066, 6798);
	level.iz_route[level.iz_route.size] = (2625, 15350, 6874);
	level.iz_route[level.iz_route.size] = (1768, 15738, 6882);
	level.iz_route[level.iz_route.size] = (1289, 16007, 6898);
	level.iz_route[level.iz_route.size] = (853, 16114, 6904);
	level.iz_route[level.iz_route.size] = (395, 16192, 6916);
	level.iz_route[level.iz_route.size] = (-130, 16168, 6932);
	level.iz_route[level.iz_route.size] = (-524, 15880, 6976);
	level.iz_route[level.iz_route.size] = (-809, 15410, 7098);
	level.iz_route[level.iz_route.size] = (-1393, 13643, 7732);
	level.iz_route[level.iz_route.size] = (-1020, 13003, 7888);
	level.iz_route[level.iz_route.size] = (135, 12319, 7950);
	level.iz_route[level.iz_route.size] = (2046, 11402, 8051);
	level.iz_route[level.iz_route.size] = (3106, 10892, 8207);
	level.iz_route[level.iz_route.size] = (3863, 10304, 8328);
	level.iz_route[level.iz_route.size] = (4157, 9304, 8320);
	level.iz_route[level.iz_route.size] = (4195, 7851, 8332);
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
	points[0] = (2292.2717, 9655.9844, 8192.1650);
	angles[0] = (0, -83.0586, 0.1633);
	at[0] = 0;
	points[1] = (2424.7520, 9675.5908, 8193.5830);
	angles[1] = (0, -79.6211, 1.2496);
	at[1] = 2.5000;
	points[2] = (2497.7244, 9693.6611, 8196.7324);
	angles[2] = (0, -72.5530, 3.4341);
	at[2] = 4;
	points[3] = (2622.3425, 9740.7871, 8206.6934);
	angles[3] = (0, -67.4637, 4.7350);
	at[3] = 6.5000;
	points[4] = (2816.7715, 9827.5586, 8225.5908);
	angles[4] = (0, -64.8956, 5.2675);
	at[4] = 10.5000;
	points[5] = (3055.9805, 9944.4883, 8250.4727);
	angles[5] = (0, -63.1107, 5.3144);
	at[5] = 15.5000;
	points[6] = (3174.3428, 10006.1416, 8262.4023);
	angles[6] = (0, -61.6552, 4.7077);
	at[6] = 18;
	points[7] = (3217.7915, 10030.4727, 8265.9053);
	angles[7] = (0, -60.0717, 3.3737);
	at[7] = 19;
	points[8] = (3308.8188, 10086.1416, 8270.4336);
	angles[8] = (0, -57.1907, 1.9285);
	at[8] = 21;
	points[9] = (3374.7717, 10130.9443, 8272.8740);
	angles[9] = (0, -54.5436, 1.6598);
	at[9] = 22.5000;
	points[10] = (3438.2717, 10179.4883, 8275.2754);
	angles[10] = (0, -50.7299, 1.8201);
	at[10] = 24;
	points[11] = (3478.2678, 10214.6855, 8277.1660);
	angles[11] = (0, -46.7996, 2.2349);
	at[11] = 25;
	points[12] = (3514.7363, 10253.1494, 8279.6455);
	angles[12] = (0, -40.3420, 3.1086);
	at[12] = 26;
	points[13] = (3543.2324, 10295.1963, 8283.1895);
	angles[13] = (0, -27.9511, 4.9467);
	at[13] = 27;
	points[14] = (3564.3660, 10343.7012, 8288.3857);
	angles[14] = (0, -21.5560, 5.8585);
	at[14] = 28;
	points[15] = (3591.3818, 10418.6221, 8296.8115);
	angles[15] = (0, -18.7709, 6.1486);
	at[15] = 29.5000;
	points[16] = (3631.5237, 10545.7480, 8311.3389);
	angles[16] = (0, -16.6014, 6.2242);
	at[16] = 32;
	points[17] = (3674.1653, 10698.6621, 8328.4648);
	angles[17] = (0, -14.6327, 6.0690);
	at[17] = 35;
	points[18] = (3710.4844, 10853.0312, 8344.6455);
	angles[18] = (0, -11.5129, 5.4617);
	at[18] = 38;
	points[19] = (3723.7087, 10933.7793, 8351.6924);
	angles[19] = (0, -6.3523, 4.1355);
	at[19] = 39.5000;
	points[20] = (3725.1023, 10957.6777, 8353.0713);
	angles[20] = (0, -0.8444, 2.6148);
	at[20] = 40;
	points[21] = (3723.0789, 10983.7803, 8353.7402);
	angles[21] = (0, 7.0444, 0.9033);
	at[21] = 40.5000;
	points[22] = (3711.4880, 11036.1016, 8353.4648);
	angles[22] = (0, 15.6227, -0.9675);
	at[22] = 41.5000;
	points[23] = (3694.8347, 11086.4951, 8352.0078);
	angles[23] = (0, 19.9935, -1.9571);
	at[23] = 42.5000;
	points[24] = (3642.2637, 11208.6221, 8345.5908);
	angles[24] = (0, 25.5553, -3.3679);
	at[24] = 45;
	points[25] = (3581.2952, 11326.8896, 8336.3389);
	angles[25] = (0, 28.6256, -4.5914);
	at[25] = 47.5000;
	points[26] = (3515.8542, 11439.3301, 8322.5986);
	angles[26] = (0, 31.7169, -7.4022);
	at[26] = 50;
	points[27] = (3414.8857, 11594.7637, 8296.5752);
	angles[27] = (0, 34.1391, -8.3321);
	at[27] = 53.5000;
	points[28] = (3322.9766, 11723.7012, 8272.7559);
	angles[28] = (0, 37, -8.7709);
	at[28] = 56.5000;
	points[29] = (3239.2480, 11824.8818, 8251.8906);
	angles[29] = (0, 43.2133, -9.3161);
	at[29] = 59;
	points[30] = (3201.5315, 11859.9219, 8243.2285);
	angles[30] = (0, 51.5926, -9.7687);
	at[30] = 60;
	points[31] = (3137.0750, 11902.5596, 8229.5273);
	angles[31] = (0, 58.8267, -10.1337);
	at[31] = 61.5000;
	points[32] = (3044.8506, 11954.3701, 8210.5117);
	angles[32] = (0, 61.9213, -10.2508);
	at[32] = 63.5000;
	points[33] = (2927.9646, 12013.2676, 8186.7319);
	angles[33] = (0, 64.3949, -10.3277);
	at[33] = 66;
	points[34] = (2832.6458, 12056.8115, 8167.5591);
	angles[34] = (0, 66.4219, -10.3795);
	at[34] = 68;
	points[35] = (2735.0513, 12096.6543, 8148.2285);
	angles[35] = (0, 69.2091, -10.4326);
	at[35] = 70;
	points[36] = (2660.4646, 12122.3623, 8133.6616);
	angles[36] = (0, 72.7909, -10.4674);
	at[36] = 71.5000;
	points[37] = (2584.8977, 12140.2764, 8119.3311);
	angles[37] = (0, 81.5140, -10.3878);
	at[37] = 73;
	points[38] = (2562.0708, 12142.4014, 8115.1182);
	angles[38] = (0, 86.3026, -10.4775);
	at[38] = 73.5000;
	points[39] = (2483.2205, 12141.9297, 8100.3540);
	angles[39] = (0, 92.4580, -10.5986);
	at[39] = 75;
	points[40] = (2377.7756, 12134.2910, 8080.6689);
	angles[40] = (0, 95.2849, -10.4998);
	at[40] = 77;
	points[41] = (2247.2913, 12119.8027, 8056.5747);
	angles[41] = (0, 97.1207, -10.2829);
	at[41] = 79.5000;
	points[42] = (1962.2795, 12076.6924, 8006.4175);
	angles[42] = (0, 100.0353, -9.3079);
	at[42] = 85;
	points[43] = (1779.9292, 12039.0947, 7979.1338);
	angles[43] = (0, 104.0491, -6.7011);
	at[43] = 88.5000;
	points[44] = (1707.4370, 12016.3779, 7973.5435);
	angles[44] = (0, 110.4278, -2.0737);
	at[44] = 90;
	points[45] = (1584.9528, 11963.5430, 7973.1104);
	angles[45] = (0, 115.1431, 0.9617);
	at[45] = 92.5000;
	points[46] = (1442.1812, 11891.4570, 7978.3462);
	angles[46] = (0, 118.1895, 2.5936);
	at[46] = 95.5000;
	points[47] = (1303.5237, 11811.9678, 7987.6382);
	angles[47] = (0, 121.5211, 4.0240);
	at[47] = 98.5000;
	points[48] = (1214.9016, 11753.6611, 7996.3384);
	angles[48] = (0, 125.3178, 5.4100);
	at[48] = 100.5000;
	points[49] = (1152.0748, 11703.8594, 8005.4331);
	angles[49] = (0, 132.0723, 7.6154);
	at[49] = 102;
	points[50] = (1119.0945, 11668.6621, 8013.4648);
	angles[50] = (0, 139.8687, 11.1402);
	at[50] = 103;
	points[51] = (1101.4370, 11646.6543, 8019.4888);
	angles[51] = (0, 141.9331, 12.4249);
	at[51] = 103.5000;
	points[52] = (1041.6023, 11563.8193, 8044.1338);
	angles[52] = (0, 145.6293, 14.2020);
	at[52] = 105.5000;
	points[53] = (931.6929, 11388.7012, 8098.4648);
	angles[53] = (0, 149.8464, 14.9210);
	at[53] = 109.5000;
	points[54] = (846.6063, 11229.0947, 8146.1812);
	angles[54] = (0, 154.2075, 14.5084);
	at[54] = 113;
	points[55] = (796.2283, 11110.9443, 8178.1499);
	angles[55] = (0, 160.0251, 13.2407);
	at[55] = 115.5000;
	points[56] = (780.2914, 11060.5508, 8189.9604);
	angles[56] = (0, 164.6575, 11.9680);
	at[56] = 116.5000;
	points[57] = (770.2637, 11008.5830, 8199.8818);
	angles[57] = (0, 173.5414, 9.1494);
	at[57] = 117.5000;
	points[58] = (771.8976, 10961.1016, 8205.0791);
	angles[58] = (0, 187.7356, 4.3033);
	at[58] = 118.5000;
	points[59] = (777.2520, 10932.4023, 8206.8115);
	angles[59] = (0, 191.8923, 2.8969);
	at[59] = 119;
	points[60] = (783.0984, 10908.0312, 8207.8350);
	angles[60] = (0, 194.2305, 2.1034);
	at[60] = 119.5000;
	points[61] = (806.2637, 10830.5898, 8209.6455);
	angles[61] = (0, 198.2214, 0.7637);
	at[61] = 121;
	points[62] = (851.6811, 10705.8271, 8210.0791);
	angles[62] = (0, 201.2595, -0.2070);
	at[62] = 123.5000;
	points[63] = (902.2126, 10582.1650, 8208.9375);
	angles[63] = (0, 202.9822, -0.6976);
	at[63] = 126;
	points[64] = (966.8150, 10435.5508, 8206.4570);
	angles[64] = (0, 204.4529, -1.0266);
	at[64] = 129;
	points[65] = (1034.5000, 10291.2988, 8203.3467);
	angles[65] = (0, 205.7742, -1.1797);
	at[65] = 132;
	points[66] = (1107.0748, 10146.7324, 8200.0791);
	angles[66] = (0, 207.6910, -1.0741);
	at[66] = 135;
	points[67] = (1118.6260, 10125, 8199.6064);
	angles[67] = (0, 208.2070, -0.9919);
	at[67] = 135.5000;
	points[68] = (1145.5198, 10076.8896, 8198.8584);
	angles[68] = (0, 210.3195, -0.5342);
	at[68] = 136.5000;
	points[69] = (1157.6023, 10057.2441, 8198.7402);
	angles[69] = (0, 212.3384, -0.2108);
	at[69] = 137;
	points[70] = (1236.6890, 9950.1973, 8198.2676);
	angles[70] = (0, 219.1517, -0.1966);
	at[70] = 139.5000;
	points[71] = (1343.3070, 9830.8662, 8197.7559);
	angles[71] = (0, 224.1105, -0.1921);
	at[71] = 142.5000;
	points[72] = (1440.2166, 9739.1738, 8197.2832);
	angles[72] = (0, 229.1436, -0.1898);
	at[72] = 145;
	points[73] = (1502.6890, 9689.6064, 8197.0479);
	angles[73] = (0, 234.0202, -0.1878);
	at[73] = 146.5000;
	points[74] = (1547.4607, 9660.4336, 8196.8506);
	angles[74] = (0, 239.5244, -0.1848);
	at[74] = 147.5000;
	points[75] = (1595.3859, 9637.8740, 8196.6934);
	angles[75] = (0, 250.1629, -0.1751);
	at[75] = 148.5000;
	points[76] = (1617.9016, 9631.8896, 8196.6143);
	angles[76] = (0, 257.7975, -0.3026);
	at[76] = 149;
	points[77] = (1645.4568, 9627.5986, 8196.4170);
	angles[77] = (0, 262.6013, -0.4413);
	at[77] = 149.5000;
	points[78] = (1751.4292, 9621.6934, 8195.4336);
	angles[78] = (0, 269.1154, -0.5627);
	at[78] = 151.5000;
	points[79] = (1912.1576, 9624.6846, 8193.8975);
	angles[79] = (0, 272.4226, -0.5103);
	at[79] = 154.5000;
	points[80] = (2124.4331, 9638.6621, 8192.4023);
	angles[80] = (0, 274.8922, -0.2747);
	at[80] = 158.5000;
	points[81] = (2292.2717, 9655.9844, 8192.1650);
	angles[81] = (0, 276.9414, 0.1633);
	at[81] = 161.6500;
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
	points[0] = (8090.7485, -12429.1348, 9143.3467);
	angles[0] = (0, 53.2481, -15.7599);
	at[0] = 0;
	points[1] = (8029.9604, -12384.3311, 9121.6924);
	angles[1] = (0, 53.9248, -16.5662);
	at[1] = 1.5000;
	points[2] = (7945, -12327.5986, 9091.1025);
	angles[2] = (0, 57.4068, -16.6214);
	at[2] = 3.5000;
	points[3] = (7835.7876, -12260.7090, 9053.4258);
	angles[3] = (0, 59.6174, -16.0865);
	at[3] = 6;
	points[4] = (7768.5435, -12223.2686, 9031.8896);
	angles[4] = (0, 62.4255, -15.0164);
	at[4] = 7.5000;
	points[5] = (7698.3462, -12193.1895, 9013.7793);
	angles[5] = (0, 69.6779, -12.3618);
	at[5] = 9;
	points[6] = (7574.2124, -12151.9287, 8987.0078);
	angles[6] = (0, 73.0241, -10.8787);
	at[6] = 11.5000;
	points[7] = (7447.6377, -12117.5977, 8964.4092);
	angles[7] = (0, 76.9323, -8.3613);
	at[7] = 14;
	points[8] = (7395.4727, -12107.3232, 8957.9141);
	angles[8] = (0, 80.8196, -5.5766);
	at[8] = 15;
	points[9] = (7371.6929, -12104.2920, 8956.1816);
	angles[9] = (0, 83.7620, -3.2876);
	at[9] = 15.5000;
	points[10] = (7237.4409, -12094.9609, 8952.7559);
	angles[10] = (0, 87.0108, -0.7366);
	at[10] = 18;
	points[11] = (7024.7241, -12087.1260, 8951.8115);
	angles[11] = (0, 88.6538, 0.0900);
	at[11] = 22;
	points[12] = (6864.1733, -12085.9844, 8952.7959);
	angles[12] = (0, 90.8891, 0.6552);
	at[12] = 25;
	points[13] = (6811.3384, -12087.9131, 8953.6221);
	angles[13] = (0, 93.5402, 1.1416);
	at[13] = 26;
	points[14] = (6760.1572, -12093.9375, 8955.2754);
	angles[14] = (0, 98.5167, 2.2976);
	at[14] = 27;
	points[15] = (6525.4331, -12141.2998, 8967.9531);
	angles[15] = (0, 102.5624, 3.3403);
	at[15] = 31.5000;
	points[16] = (6291.2202, -12192.1260, 8981.9688);
	angles[16] = (0, 100.6188, 3.1194);
	at[16] = 36;
	points[17] = (6268.0708, -12196.2598, 8983.2285);
	angles[17] = (0, 100.0594, 3.0331);
	at[17] = 36.5000;
	points[18] = (5847.1655, -12269.1338, 9005.9844);
	angles[18] = (0, 98.9309, 2.9752);
	at[18] = 44.5000;
	points[19] = (5715.8271, -12287.8740, 9012.6768);
	angles[19] = (0, 97.0921, 2.7949);
	at[19] = 47;
	points[20] = (5635.0786, -12295.1572, 9016.3779);
	angles[20] = (0, 92.1534, 2.2899);
	at[20] = 48.5000;
	points[21] = (5610.9844, -12294.4883, 9017.1650);
	angles[21] = (0, 85.7354, 1.5572);
	at[21] = 49;
	points[22] = (5558.3857, -12284.3311, 9017.8350);
	angles[22] = (0, 75.2228, 0.2714);
	at[22] = 50;
	points[23] = (5458.2676, -12248.8193, 9017.3623);
	angles[23] = (0, 67.9135, -0.5270);
	at[23] = 52;
	points[24] = (5335.3149, -12198.1104, 9016.4170);
	angles[24] = (0, 69.0383, -0.0186);
	at[24] = 54.5000;
	points[25] = (5284.3306, -12181.3789, 9016.8906);
	angles[25] = (0, 74.9859, 1.1355);
	at[25] = 55.5000;
	points[26] = (5260.5908, -12176.3779, 9017.6377);
	angles[26] = (0, 79.1160, 1.9683);
	at[26] = 56;
	points[27] = (5075.6694, -12145.3945, 9025.5508);
	angles[27] = (0, 81.5134, 2.6643);
	at[27] = 59.5000;
	points[28] = (4944.0552, -12128.0312, 9032.1660);
	angles[28] = (0, 83.5130, 3.0469);
	at[28] = 62;
	points[29] = (4837.6772, -12118.7402, 9038.3467);
	angles[29] = (0, 86.7755, 3.6211);
	at[29] = 64;
	points[30] = (4757.3228, -12118.7793, 9044.2129);
	angles[30] = (0, 94.3615, 4.8737);
	at[30] = 65.5000;
	points[31] = (4733.7402, -12122.3232, 9046.4961);
	angles[31] = (0, 101.5789, 5.9296);
	at[31] = 66;
	points[32] = (4708.0708, -12129.3301, 9049.4492);
	angles[32] = (0, 106.7570, 6.4510);
	at[32] = 66.5000;
	points[33] = (4633.8584, -12156.6533, 9058.8975);
	angles[33] = (0, 112.1378, 7.0090);
	at[33] = 68;
	points[34] = (4536.6538, -12199.8428, 9072.4014);
	angles[34] = (0, 115.3032, 7.4361);
	at[34] = 70;
	points[35] = (4419.3306, -12259.7646, 9090.3154);
	angles[35] = (0, 118.7493, 8.0662);
	at[35] = 72.5000;
	points[36] = (4350.5903, -12300, 9102.0869);
	angles[36] = (0, 121.9683, 8.7523);
	at[36] = 74;
	points[37] = (4286.8110, -12345.7090, 9115.3154);
	angles[37] = (0, 130.6350, 10.6245);
	at[37] = 75.5000;
	points[38] = (4268.4644, -12365.1963, 9120.9062);
	angles[38] = (0, 142.5435, 12.8614);
	at[38] = 76;
	points[39] = (4261.6929, -12387.5596, 9127.2041);
	angles[39] = (0, 174.8766, 15.3478);
	at[39] = 76.5000;
	points[40] = (4264.8032, -12412.7959, 9133.9766);
	angles[40] = (0, 191.6912, 14.6687);
	at[40] = 77;
	points[41] = (4272.2837, -12437.6377, 9140.5908);
	angles[41] = (0, 198.9254, 14.0357);
	at[41] = 77.5000;
	points[42] = (4316.4961, -12531.6143, 9165.3145);
	angles[42] = (0, 208.4913, 13.0646);
	at[42] = 79.5000;
	points[43] = (4395.8267, -12666.1416, 9201.7324);
	angles[43] = (0, 211.2911, 13.5065);
	at[43] = 82.5000;
	points[44] = (4434.9214, -12733.3066, 9221.7324);
	angles[44] = (0, 207.9888, 15.8993);
	at[44] = 84;
	points[45] = (4455.5903, -12777.3633, 9237.5195);
	angles[45] = (0, 204.2140, 18.8751);
	at[45] = 85;
	points[46] = (4496.2993, -12869.2520, 9273.3857);
	angles[46] = (0, 204.0075, 20.0370);
	at[46] = 87;
	points[47] = (4559.9214, -13005.4336, 9328.9375);
	angles[47] = (0, 206.5089, 20.3642);
	at[47] = 90;
	points[48] = (4608.2681, -13092.9131, 9365.7881);
	angles[48] = (0, 212.0942, 19.9426);
	at[48] = 92;
	points[49] = (4636.9688, -13131.7715, 9382.7559);
	angles[49] = (0, 221.3211, 18.6924);
	at[49] = 93;
	points[50] = (4672.4409, -13167.4014, 9399.4492);
	angles[50] = (0, 226.5076, 18.1901);
	at[50] = 94;
	points[51] = (4748.6611, -13235.2754, 9432.4805);
	angles[51] = (0, 229.4212, 17.7608);
	at[51] = 96;
	points[52] = (4866.6533, -13332.2051, 9480.6699);
	angles[52] = (0, 231.5710, 17.2416);
	at[52] = 99;
	points[53] = (4988.3857, -13424.5674, 9526.8115);
	angles[53] = (0, 234.2794, 16.2400);
	at[53] = 102;
	points[54] = (5053.3462, -13468.1104, 9548.3467);
	angles[54] = (0, 238.8590, 14.1545);
	at[54] = 103.5000;
	points[55] = (5073.8975, -13479.1338, 9553.6221);
	angles[55] = (0, 243.8198, 11.7797);
	at[55] = 104;
	points[56] = (5147.9136, -13506.8115, 9566.2598);
	angles[56] = (0, 252.3961, 7.6432);
	at[56] = 105.5000;
	points[57] = (5301.9297, -13546.8105, 9583.3467);
	angles[57] = (0, 257.4442, 5.1381);
	at[57] = 108.5000;
	points[58] = (5458.9766, -13576.6533, 9595.3545);
	angles[58] = (0, 261.3354, 3.3743);
	at[58] = 111.5000;
	points[59] = (5562.9526, -13587.2041, 9598.8975);
	angles[59] = (0, 265.8174, 1.0940);
	at[59] = 113.5000;
	points[60] = (5722.8350, -13594.8428, 9600.1572);
	angles[60] = (0, 268.5052, -0.0631);
	at[60] = 116.5000;
	points[61] = (5829.5278, -13595.5908, 9599.2920);
	angles[61] = (0, 270.6995, -0.8511);
	at[61] = 118.5000;
	points[62] = (5909.2124, -13592.6768, 9597.4404);
	angles[62] = (0, 273.5663, -1.8104);
	at[62] = 120;
	points[63] = (5958.8584, -13587.9922, 9595.3545);
	angles[63] = (0, 276.9810, -2.9151);
	at[63] = 121;
	points[64] = (6038.0713, -13576.4570, 9590.7090);
	angles[64] = (0, 278.9297, -3.5457);
	at[64] = 122.5000;
	points[65] = (6275.4727, -13535.9844, 9574.6855);
	angles[65] = (0, 280.0957, -3.9518);
	at[65] = 127;
	points[66] = (6616.0635, -13473.1104, 9549.7637);
	angles[66] = (0, 280.7996, -4.2954);
	at[66] = 133.5000;
	points[67] = (6744.8428, -13448.0312, 9539.6064);
	angles[67] = (0, 281.2919, -4.6337);
	at[67] = 136;
	points[68] = (6773.5435, -13442.2051, 9537.1660);
	angles[68] = (0, 281.5479, -4.8257);
	at[68] = 136.5000;
	points[69] = (6821.4565, -13431.8506, 9532.5986);
	angles[69] = (0, 282.9346, -5.8410);
	at[69] = 137.5000;
	points[70] = (6898.8188, -13412.4805, 9523.3467);
	angles[70] = (0, 284.7845, -7.0999);
	at[70] = 139;
	points[71] = (7277.2837, -13301.7334, 9469.6465);
	angles[71] = (0, 286.6920, -6.6382);
	at[71] = 146.5000;
	points[72] = (7505.5518, -13231.7725, 9444.1738);
	angles[72] = (0, 287.8484, -6.0233);
	at[72] = 151;
	points[73] = (7630.7876, -13188.3857, 9429.6855);
	angles[73] = (0, 290.9440, -6.5726);
	at[73] = 153.5000;
	points[74] = (7677.3623, -13168.9375, 9423.6611);
	angles[74] = (0, 293.5893, -6.8324);
	at[74] = 154.5000;
	points[75] = (7774.2910, -13125.3545, 9411.0234);
	angles[75] = (0, 294.5921, -6.7808);
	at[75] = 156.5000;
	points[76] = (7989.7642, -13022.9922, 9381.7715);
	angles[76] = (0, 296.3209, -7.2972);
	at[76] = 161;
	points[77] = (8107.0864, -12962.3623, 9363.9365);
	angles[77] = (0, 298.6716, -8.2297);
	at[77] = 163.5000;
	points[78] = (8175.6299, -12920.9062, 9350.9053);
	angles[78] = (0, 305.1573, -10.8270);
	at[78] = 165;
	points[79] = (8193.3857, -12905.7881, 9345.5908);
	angles[79] = (0, 313.7529, -14.0117);
	at[79] = 165.5000;
	points[80] = (8210.4727, -12886.4961, 9338.4248);
	angles[80] = (0, 320.7567, -16.3112);
	at[80] = 166;
	points[81] = (8239.2910, -12844.5674, 9322.1660);
	angles[81] = (0, 328.4237, -18.4791);
	at[81] = 167;
	points[82] = (8263.4648, -12800.3545, 9304.6455);
	angles[82] = (0, 333.3793, -19.6570);
	at[82] = 168;
	points[83] = (8283.9766, -12754.6455, 9286.2207);
	angles[83] = (0, 337.7596, -20.5343);
	at[83] = 169;
	points[84] = (8300.4727, -12707.8740, 9267.2041);
	angles[84] = (0, 342.9646, -21.3736);
	at[84] = 170;
	points[85] = (8311.0635, -12659.2529, 9247.1260);
	angles[85] = (0, 352.6566, -22.4041);
	at[85] = 171;
	points[86] = (8311.1816, -12634.7246, 9236.8506);
	angles[86] = (0, 365.6075, -22.8067);
	at[86] = 171.5000;
	points[87] = (8302.0078, -12613.2285, 9227.5596);
	angles[87] = (0, 391.4329, -20.4676);
	at[87] = 172;
	points[88] = (8286.5352, -12593.7012, 9218.8975);
	angles[88] = (0, 400.8989, -18.6031);
	at[88] = 172.5000;
	points[89] = (8269.0947, -12575.4326, 9210.7090);
	angles[89] = (0, 404.8898, -17.6702);
	at[89] = 173;
	points[90] = (8192.2051, -12507.7559, 9179.8818);
	angles[90] = (0, 410.7272, -16.2120);
	at[90] = 175;
	points[91] = (8090.7485, -12429.1348, 9143.3467);
	angles[91] = (0, 413.2481, -15.7599);
	at[91] = 177.5000;
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
	points[0] = (7626.1812, 2096, 5822.1650);
	angles[0] = (0, -22.8726, 2.1564);
	at[0] = 0;
	points[1] = (7859.7637, 2621.9409, 5843.8188);
	angles[1] = (0, -24.2787, 2.1771);
	at[1] = 10.8500;
	points[2] = (7963.2285, 2861.5786, 5853.8188);
	angles[2] = (0, -20.7392, 2.2282);
	at[2] = 15.7500;
	points[3] = (7973.8979, 2896.3621, 5855.2754);
	angles[3] = (0, -13.1225, 2.3179);
	at[3] = 16.4500;
	points[4] = (7980.8267, 2951.8896, 5857.5986);
	angles[4] = (0, -3.6927, 2.3833);
	at[4] = 17.5000;
	points[5] = (7981.4175, 3007.8188, 5859.9214);
	angles[5] = (0, 1.6665, 2.3669);
	at[5] = 18.5500;
	points[6] = (7976.4961, 3063.4604, 5862.1655);
	angles[6] = (0, 8.4731, 2.2569);
	at[6] = 19.6000;
	points[7] = (7972.4409, 3081.8582, 5862.8745);
	angles[7] = (0, 15.0405, 2.0787);
	at[7] = 19.9500;
	points[8] = (7963.2676, 3096.9448, 5863.3467);
	angles[8] = (0, 39.7094, 1.2523);
	at[8] = 20.3000;
	points[9] = (7948.9370, 3108.9333, 5863.6221);
	angles[9] = (0, 53.0204, 0.7222);
	at[9] = 20.6500;
	points[10] = (7933.1499, 3119.0669, 5863.8188);
	angles[10] = (0, 58.6686, 0.4810);
	at[10] = 21;
	points[11] = (7883.3467, 3144.6536, 5864.0942);
	angles[11] = (0, 64.5799, 0.2017);
	at[11] = 22.0500;
	points[12] = (7731.6929, 3214.5471, 5864.1733);
	angles[12] = (0, 65.3089, 0.8505);
	at[12] = 25.2000;
	points[13] = (7698.2285, 3231.1851, 5865.1577);
	angles[13] = (0, 63.2009, 1.6875);
	at[13] = 25.9000;
	points[14] = (7631.1416, 3263.8860, 5867.7163);
	angles[14] = (0, 65.6186, 2.2310);
	at[14] = 27.3000;
	points[15] = (7614.1338, 3270.9604, 5868.5039);
	angles[15] = (0, 68.6799, 2.5732);
	at[15] = 27.6500;
	points[16] = (7596.2993, 3275.3267, 5869.6460);
	angles[16] = (0, 80.9406, 4.1143);
	at[16] = 28;
	points[17] = (7559.2524, 3276.0867, 5872.9922);
	angles[17] = (0, 91.9938, 5.4638);
	at[17] = 28.7000;
	points[18] = (7522.2832, 3272.3936, 5876.4961);
	angles[18] = (0, 98.5205, 5.2065);
	at[18] = 29.4000;
	points[19] = (7504.0947, 3268.3662, 5878.0317);
	angles[19] = (0, 105.0314, 4.2566);
	at[19] = 29.7500;
	points[20] = (7468.6221, 3258.3660, 5880.5122);
	angles[20] = (0, 105.8326, 3.8226);
	at[20] = 30.4500;
	points[21] = (7417.4805, 3236.6340, 5883.4648);
	angles[21] = (0, 120.4619, 2.1790);
	at[21] = 31.5000;
	points[22] = (7388.9370, 3212.9568, 5884.1338);
	angles[22] = (0, 136.5755, 0.2127);
	at[22] = 32.2000;
	points[23] = (7377.7563, 3198.1575, 5883.9766);
	angles[23] = (0, 145.7963, -0.9299);
	at[23] = 32.5500;
	points[24] = (7369.7642, 3183.5588, 5883.5039);
	angles[24] = (0, 153.1498, -1.8265);
	at[24] = 32.9000;
	points[25] = (7354.4487, 3149.2559, 5882.0864);
	angles[25] = (0, 156.8707, -2.2701);
	at[25] = 33.6000;
	points[26] = (7180.1968, 2694.7361, 5860.6299);
	angles[26] = (0, 158.9185, -2.5019);
	at[26] = 42.7000;
	points[27] = (7167.5986, 2662.8425, 5859.1733);
	angles[27] = (0, 158.2465, -2.4155);
	at[27] = 43.4000;
	points[28] = (7020.7876, 2298.8071, 5842.8740);
	angles[28] = (0, 158.6558, -2.4537);
	at[28] = 50.7500;
	points[29] = (6922.5986, 2019.4646, 5828.9766);
	angles[29] = (0, 160.9084, -2.7206);
	at[29] = 56.3500;
	points[30] = (6894.3306, 1950.8110, 5825.9053);
	angles[30] = (0, 155.3227, -2.0724);
	at[30] = 57.7500;
	points[31] = (6879.3696, 1916.7560, 5824.4883);
	angles[31] = (0, 157.5334, -2.3302);
	at[31] = 58.4500;
	points[32] = (6867.9136, 1881.2677, 5822.6382);
	angles[32] = (0, 166.9921, -3.3896);
	at[32] = 59.1500;
	points[33] = (6866.4570, 1863.4213, 5821.2988);
	angles[33] = (0, 180.8120, -4.7743);
	at[33] = 59.5000;
	points[34] = (6869.3311, 1845.2953, 5819.5273);
	angles[34] = (0, 190.9173, -5.7623);
	at[34] = 59.8500;
	points[35] = (6894.3701, 1755.6536, 5809.5674);
	angles[35] = (0, 197.5782, -6.1864);
	at[35] = 61.6000;
	points[36] = (6925.3149, 1668.4370, 5799.7246);
	angles[36] = (0, 202.4128, -5.7555);
	at[36] = 63.3500;
	points[37] = (6933.7402, 1652.1890, 5798.1104);
	angles[37] = (0, 212.0964, -4.3793);
	at[37] = 63.7000;
	points[38] = (6946.3384, 1638.5315, 5797.1260);
	angles[38] = (0, 226.2758, -2.4870);
	at[38] = 64.0500;
	points[39] = (6960.9844, 1626.9922, 5796.5747);
	angles[39] = (0, 233.7286, -1.4468);
	at[39] = 64.4000;
	points[40] = (7009.2124, 1598.7716, 5795.9058);
	angles[40] = (0, 241.7878, -0.5770);
	at[40] = 65.4500;
	points[41] = (7025.9053, 1591.1654, 5795.7876);
	angles[41] = (0, 247.2740, -0.1355);
	at[41] = 65.8000;
	points[42] = (7096.2598, 1567.1534, 5796.1021);
	angles[42] = (0, 254.1518, 0.3892);
	at[42] = 67.2000;
	points[43] = (7150.8267, 1554.7008, 5796.6929);
	angles[43] = (0, 260.1754, 0.7365);
	at[43] = 68.2500;
	points[44] = (7169.3306, 1552.6378, 5796.9683);
	angles[44] = (0, 265.9017, 0.9165);
	at[44] = 68.6000;
	points[45] = (7187.5200, 1553.7875, 5797.3228);
	angles[45] = (0, 275.9701, 1.2167);
	at[45] = 68.9500;
	points[46] = (7242.9136, 1562.7875, 5798.5825);
	angles[46] = (0, 280.9946, 1.3526);
	at[46] = 70;
	points[47] = (7297.0474, 1577.0355, 5800);
	angles[47] = (0, 289.9557, 1.5133);
	at[47] = 71.0500;
	points[48] = (7313.1494, 1585.5394, 5800.5117);
	angles[48] = (0, 300.8706, 1.6355);
	at[48] = 71.4000;
	points[49] = (7343.6221, 1606.7323, 5801.5747);
	angles[49] = (0, 306.2281, 1.6738);
	at[49] = 72.1000;
	points[50] = (7416.1025, 1665.2047, 5804.3701);
	angles[50] = (0, 311.5367, 1.7624);
	at[50] = 73.8500;
	points[51] = (7429.9214, 1678.2441, 5804.9604);
	angles[51] = (0, 314.4213, 1.8291);
	at[51] = 74.2000;
	points[52] = (7451.8110, 1707.4528, 5806.2202);
	angles[52] = (0, 327.6273, 2.0520);
	at[52] = 74.9000;
	points[53] = (7478.8193, 1756.4174, 5808.2676);
	angles[53] = (0, 332.8768, 2.1072);
	at[53] = 75.9500;
	points[54] = (7510.1572, 1822.1064, 5810.9844);
	angles[54] = (0, 335.8053, 2.1438);
	at[54] = 77.3500;
	points[55] = (7626.1812, 2096, 5822.1650);
	angles[55] = (0, 337.1274, 2.1564);
	at[55] = 82.9167;
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
	points[0] = (5626.2598, 13379.7246, 6796.0239);
	angles[0] = (0, -58.8899, -0.0121);
	at[0] = 0;
	points[1] = (5667.9131, 13406.5752, 6796.0630);
	angles[1] = (0, -55.5232, 0.0345);
	at[1] = 0.9333;
	points[2] = (5688.4248, 13421.8115, 6796.0630);
	angles[2] = (0, -51.8806, 0.0860);
	at[2] = 1.4000;
	points[3] = (5704.9609, 13436.7725, 6796.1416);
	angles[3] = (0, -45.3011, 0.1972);
	at[3] = 1.8667;
	points[4] = (5722.1655, 13455.7881, 6796.2598);
	angles[4] = (0, -40.8275, 0.2948);
	at[4] = 2.3333;
	points[5] = (5767.5981, 13514.4092, 6796.6929);
	angles[5] = (0, -36.0892, 0.3787);
	at[5] = 3.7333;
	points[6] = (5824.0947, 13596.4570, 6797.4019);
	angles[6] = (0, -33.4592, 0.3936);
	at[6] = 5.6000;
	points[7] = (5890.4331, 13701.7314, 6798.2285);
	angles[7] = (0, -31.1316, 0.3500);
	at[7] = 7.9333;
	points[8] = (5951.7324, 13810.6689, 6798.7793);
	angles[8] = (0, -26.9256, 0.1158);
	at[8] = 10.2667;
	points[9] = (5971.1025, 13854.1338, 6798.7402);
	angles[9] = (0, -22.0453, -0.1721);
	at[9] = 11.2000;
	points[10] = (6005.2754, 13947.3623, 6798.2676);
	angles[10] = (0, -19.1237, -0.3109);
	at[10] = 13.0667;
	points[11] = (6052.0078, 14089.3701, 6797.3623);
	angles[11] = (0, -17.5221, -0.3605);
	at[11] = 15.8667;
	points[12] = (6095.2363, 14232.8750, 6796.4175);
	angles[12] = (0, -15.9452, -0.3620);
	at[12] = 18.6667;
	points[13] = (6120.1572, 14329.4482, 6795.8267);
	angles[13] = (0, -11.7484, -0.2648);
	at[13] = 20.5333;
	points[14] = (6124.0161, 14377.1260, 6795.7480);
	angles[14] = (0, 0.5840, -0.0241);
	at[14] = 21.4667;
	points[15] = (6118.9766, 14426.4971, 6795.7876);
	angles[15] = (0, 9.1954, 0.1135);
	at[15] = 22.4000;
	points[16] = (6108.0713, 14474.9209, 6795.9453);
	angles[16] = (0, 15.0888, 0.1852);
	at[16] = 23.3333;
	points[17] = (6083.6611, 14545.4717, 6796.1812);
	angles[17] = (0, 22.4353, 0.1762);
	at[17] = 24.7333;
	points[18] = (6061.4966, 14588.7793, 6796.3384);
	angles[18] = (0, 29.6974, 0.1571);
	at[18] = 25.6667;
	points[19] = (6009.0942, 14673.5439, 6796.6143);
	angles[19] = (0, 32.8809, 0.1643);
	at[19] = 27.5333;
	points[20] = (5939.0156, 14776.1816, 6796.9688);
	angles[20] = (0, 36.0051, 0.1706);
	at[20] = 29.8667;
	points[21] = (5908.5435, 14815, 6797.1260);
	angles[21] = (0, 41.1253, 0.1801);
	at[21] = 30.8000;
	points[22] = (5855.7876, 14867.4414, 6797.4019);
	angles[22] = (0, 47.1728, 0.2169);
	at[22] = 32.2000;
	points[23] = (5780.1572, 14931.8896, 6797.7559);
	angles[23] = (0, 51.7781, 0.2029);
	at[23] = 34.0667;
	points[24] = (5719.3306, 14975.0791, 6797.9927);
	angles[24] = (0, 57.6111, 0.1603);
	at[24] = 35.4667;
	points[25] = (5677.5596, 14997.4414, 6798.1104);
	angles[25] = (0, 65.3515, 0.0987);
	at[25] = 36.4000;
	points[26] = (5561.2207, 15044.9609, 6798.3071);
	angles[26] = (0, 68.8613, 0.0788);
	at[26] = 38.7333;
	points[27] = (5397.7559, 15104.6074, 6798.5044);
	angles[27] = (0, 71.0221, 0.0572);
	at[27] = 42;
	points[28] = (5279.2124, 15142.3623, 6798.5830);
	angles[28] = (0, 73.9981, 0.0220);
	at[28] = 44.3333;
	points[29] = (5205.6304, 15159.5674, 6798.5830);
	angles[29] = (0, 80.9639, -0.0638);
	at[29] = 45.7333;
	points[30] = (5183.4648, 15161.1416, 6798.5435);
	angles[30] = (0, 89.3357, -0.1829);
	at[30] = 46.2000;
	points[31] = (5158.3071, 15159.2910, 6798.4248);
	angles[31] = (0, 96.3692, -0.3021);
	at[31] = 46.6667;
	points[32] = (5085.1968, 15144.0947, 6797.9136);
	angles[32] = (0, 104.7432, -0.4179);
	at[32] = 48.0667;
	points[33] = (4990.3936, 15114.2129, 6797.1650);
	angles[33] = (0, 109.4516, -0.4370);
	at[33] = 49.9333;
	points[34] = (4897.5200, 15077.9531, 6796.4570);
	angles[34] = (0, 113.0121, -0.3691);
	at[34] = 51.8000;
	points[35] = (4830.5117, 15046.2598, 6796.1025);
	angles[35] = (0, 118.4177, -0.0625);
	at[35] = 53.2000;
	points[36] = (4770.1182, 15004.3701, 6796.4570);
	angles[36] = (0, 127.6937, 0.3936);
	at[36] = 54.6000;
	points[37] = (4656.6929, 14907.2451, 6797.6382);
	angles[37] = (0, 132.6871, 0.4750);
	at[37] = 57.4000;
	points[38] = (4569.0156, 14818.9766, 6798.5435);
	angles[38] = (0, 138.5885, 0.2759);
	at[38] = 59.7333;
	points[39] = (4539.6851, 14780.3154, 6798.6221);
	angles[39] = (0, 145.8961, -0.0453);
	at[39] = 60.6667;
	points[40] = (4487.7559, 14695.4736, 6798.3857);
	angles[40] = (0, 149.8505, -0.1763);
	at[40] = 62.5333;
	points[41] = (4427.3228, 14586.7324, 6797.9526);
	angles[41] = (0, 151.8321, -0.2137);
	at[41] = 64.8667;
	points[42] = (4370.8662, 14476.1025, 6797.4805);
	angles[42] = (0, 154.2209, -0.2182);
	at[42] = 67.2000;
	points[43] = (4340.5513, 14407.7168, 6797.2051);
	angles[43] = (0, 158.6982, -0.1836);
	at[43] = 68.6000;
	points[44] = (4332.9526, 14386.2207, 6797.1260);
	angles[44] = (0, 161.2240, -0.1767);
	at[44] = 69.0667;
	points[45] = (4304.0942, 14290.2754, 6796.8115);
	angles[45] = (0, 164.4720, -0.1817);
	at[45] = 70.9333;
	points[46] = (4268.1104, 14145.3936, 6796.3384);
	angles[46] = (0, 167.5747, -0.1685);
	at[46] = 73.7333;
	points[47] = (4246.1416, 14023.3857, 6796.0239);
	angles[47] = (0, 172.5875, -0.1331);
	at[47] = 76.0667;
	points[48] = (4242.0474, 13973.3467, 6795.9453);
	angles[48] = (0, 178.2061, -0.0885);
	at[48] = 77;
	points[49] = (4247.5591, 13926.1025, 6795.9053);
	angles[49] = (0, 193.5558, 0.0395);
	at[49] = 77.9333;
	points[50] = (4263.0312, 13877.9922, 6795.9844);
	angles[50] = (0, 200, 0.0919);
	at[50] = 78.8667;
	points[51] = (4291.1421, 13809.3701, 6796.1025);
	angles[51] = (0, 203.7178, 0.1202);
	at[51] = 80.2667;
	points[52] = (4356.5747, 13675.1572, 6796.4570);
	angles[52] = (0, 207.8391, 0.1465);
	at[52] = 83.0667;
	points[53] = (4419.1733, 13566.8105, 6796.8115);
	angles[53] = (0, 212.7403, 0.1679);
	at[53] = 85.4000;
	points[54] = (4448.0708, 13527.1650, 6796.9688);
	angles[54] = (0, 220.4917, 0.1920);
	at[54] = 86.3333;
	points[55] = (4465.7090, 13511.3379, 6797.0474);
	angles[55] = (0, 232.0253, 0.2517);
	at[55] = 86.8000;
	points[56] = (4486.3779, 13497.8740, 6797.1650);
	angles[56] = (0, 239.0721, 0.2861);
	at[56] = 87.2667;
	points[57] = (4553.8188, 13465.7881, 6797.5591);
	angles[57] = (0, 247.5859, 0.3090);
	at[57] = 88.6667;
	points[58] = (4647.4014, 13431.6533, 6798.1104);
	angles[58] = (0, 251.3193, 0.2849);
	at[58] = 90.5333;
	points[59] = (4787.6382, 13382.9531, 6798.5435);
	angles[59] = (0, 248.8441, -0.0750);
	at[59] = 93.3333;
	points[60] = (5044.0552, 13287.2051, 6797.6382);
	angles[60] = (0, 250.1609, -0.2253);
	at[60] = 98.4667;
	points[61] = (5113.9766, 13262.9531, 6797.3228);
	angles[61] = (0, 252.2615, -0.2155);
	at[61] = 99.8667;
	points[62] = (5160.4331, 13246.8906, 6797.1260);
	angles[62] = (0, 250.2749, -0.2782);
	at[62] = 100.8000;
	points[63] = (5207.5981, 13231.1807, 6796.8901);
	angles[63] = (0, 253.3113, -0.2923);
	at[63] = 101.7330;
	points[64] = (5256.1025, 13220.6299, 6796.6143);
	angles[64] = (0, 262.1031, -0.2624);
	at[64] = 102.6670;
	points[65] = (5280.9053, 13219.3311, 6796.5356);
	angles[65] = (0, 270.1042, -0.2199);
	at[65] = 103.1330;
	points[66] = (5305.4331, 13222.4814, 6796.4570);
	angles[66] = (0, 281.9801, -0.1442);
	at[66] = 103.6000;
	points[67] = (5328.4648, 13230.2363, 6796.4175);
	angles[67] = (0, 290.4224, -0.1029);
	at[67] = 104.0670;
	points[68] = (5486.5356, 13303.1104, 6796.1416);
	angles[68] = (0, 296.7881, -0.0657);
	at[68] = 107.3330;
	points[69] = (5626.2598, 13379.7246, 6796.0239);
	angles[69] = (0, 301.1101, -0.0121);
	at[69] = 110.3170;
	mover = getEnt("iz_obj_3", "targetname");
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
