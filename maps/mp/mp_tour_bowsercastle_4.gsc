main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_bowsercastle_4", 0);

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
	ambientPlay("iz_0_tbc4", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
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
	level.iz_route[level.iz_route.size] = (-8343, -6336, 3088);
	level.iz_route[level.iz_route.size] = (-8268, -10831, 3031);
	level.iz_route[level.iz_route.size] = (-4608, -10827, 3031);
	level.iz_route[level.iz_route.size] = (-3628, -10226, 3031);
	level.iz_route[level.iz_route.size] = (-3441, -9494, 3027);
	level.iz_route[level.iz_route.size] = (-3942, -8385, 3220);
	level.iz_route[level.iz_route.size] = (-3938, -5783, 3283);
	level.iz_route[level.iz_route.size] = (-3187, -4046, 2561);
	level.iz_route[level.iz_route.size] = (-3454, -3134, 2385);
	level.iz_route[level.iz_route.size] = (-4143, -2509, 2321);
	level.iz_route[level.iz_route.size] = (-5015, -2147, 2271);
	level.iz_route[level.iz_route.size] = (-6110, -1296, 2235);
	level.iz_route[level.iz_route.size] = (-6553, -264, 2188);
	level.iz_route[level.iz_route.size] = (-6499, 823, 2159);
	level.iz_route[level.iz_route.size] = (-5936, 1649, 2123);
	level.iz_route[level.iz_route.size] = (-4738, 2000, 2093);
	level.iz_route[level.iz_route.size] = (-4078, 2046, 2090);
	level.iz_route[level.iz_route.size] = (-131, 2068, 2098);
	level.iz_route[level.iz_route.size] = (613, 1726, 2199);
	level.iz_route[level.iz_route.size] = (1346, 1301, 2275);
	level.iz_route[level.iz_route.size] = (2167, 947, 2362);
	level.iz_route[level.iz_route.size] = (3138, 1273, 2475);
	level.iz_route[level.iz_route.size] = (4166, 1829, 2595);
	level.iz_route[level.iz_route.size] = (6100, 1864, 2732);
	level.iz_route[level.iz_route.size] = (8785, 1850, 2732);
	level.iz_route[level.iz_route.size] = (8792, 621, 2732);
	level.iz_route[level.iz_route.size] = (8790, -172, 2732);
	level.iz_route[level.iz_route.size] = (8848, -3554, 3407);
	level.iz_route[level.iz_route.size] = (8840, -6349, 3975);
	level.iz_route[level.iz_route.size] = (8922, -7732, 3986);
	level.iz_route[level.iz_route.size] = (8922, -8951, 3986);
	level.iz_route[level.iz_route.size] = (8946, -9765, 3986);
	level.iz_route[level.iz_route.size] = (7510, -9765, 3986);
	level.iz_route[level.iz_route.size] = (6100, -9765, 3986);
	level.iz_route[level.iz_route.size] = (3856, -9765, 3986);
	level.iz_route[level.iz_route.size] = (3176, -9765, 3986);
	level.iz_route[level.iz_route.size] = (3176, -8981, 3986);
	level.iz_route[level.iz_route.size] = (3168, -8223, 3986);
	level.iz_route[level.iz_route.size] = (3170, -7737, 3986);
	level.iz_route[level.iz_route.size] = (3247, -2747, 4935);
	level.iz_route[level.iz_route.size] = (3180, 765, 4536);
	level.iz_route[level.iz_route.size] = (3205, 3283, 3380);
	level.iz_route[level.iz_route.size] = (3224, 4590, 3494);
	level.iz_route[level.iz_route.size] = (3944, 5848, 3604);
	level.iz_route[level.iz_route.size] = (4318, 6630, 3673);
	level.iz_route[level.iz_route.size] = (4046, 7760, 3772);
	level.iz_route[level.iz_route.size] = (2873, 7911, 3785);
	level.iz_route[level.iz_route.size] = (1035, 7998, 3519);
	level.iz_route[level.iz_route.size] = (-2014, 7914, 3301);
	level.iz_route[level.iz_route.size] = (-3161, 7496, 3301);
	level.iz_route[level.iz_route.size] = (-6356, 7448, 3301);
	level.iz_route[level.iz_route.size] = (-7309, 7938, 3301);
	level.iz_route[level.iz_route.size] = (-7602, 9190, 3301);
	level.iz_route[level.iz_route.size] = (-7872, 9739, 3301);
	level.iz_route[level.iz_route.size] = (-8635, 10085, 3301);
	level.iz_route[level.iz_route.size] = (-9679, 10032, 3301);
	level.iz_route[level.iz_route.size] = (-9739, 9564, 3301);
	level.iz_route[level.iz_route.size] = (-10037, 6268, 3301);
	level.iz_route[level.iz_route.size] = (-9954, 5540, 4150);
	level.iz_route[level.iz_route.size] = (-9941, 3223, 3487);
	level.iz_route[level.iz_route.size] = (-9688, 699, 3374);
	level.iz_route[level.iz_route.size] = (-8582, -2132, 3211);
	level.iz_route[level.iz_route.size] = (-8380, -2968, 3186);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-6317.9922, 7600.9448, 3300.5669);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-6317.9922, 7600.9448, 3300.5669);
	angles[1] = (0, -90, 0);
	at[1] = 0.7500;
	points[2] = (-6317.9922, 7600.9448, 3303.5198);
	angles[2] = (0, -90, 0);
	at[2] = 0.8000;
	points[3] = (-6317.9922, 7600.9448, 3507.2598);
	angles[3] = (0, -90, 0);
	at[3] = 1.9500;
	points[4] = (-6317.9922, 7600.9448, 3513.1653);
	angles[4] = (0, -90, 0);
	at[4] = 2;
	points[5] = (-6317.9922, 7600.9448, 3513.1653);
	angles[5] = (0, -90, 0);
	at[5] = 3.4500;
	points[6] = (-6317.9922, 7600.9448, 3520.8347);
	angles[6] = (0, -90, 0);
	at[6] = 3.5000;
	points[7] = (-6317.9922, 7600.9448, 3517.5945);
	angles[7] = (0, -90, 0);
	at[7] = 3.5500;
	points[8] = (-6317.9922, 7600.9448, 3505.4919);
	angles[8] = (0, -90, 0);
	at[8] = 3.6000;
	points[9] = (-6317.9922, 7600.9448, 3508.7363);
	angles[9] = (0, -90, 0);
	at[9] = 3.6500;
	points[10] = (-6317.9922, 7600.9448, 3520.8347);
	angles[10] = (0, -90, 0);
	at[10] = 3.7000;
	points[11] = (-6317.9922, 7600.9448, 3517.5945);
	angles[11] = (0, -90, 0);
	at[11] = 3.7500;
	points[12] = (-6317.9922, 7600.9448, 3505.4919);
	angles[12] = (0, -90, 0);
	at[12] = 3.8000;
	points[13] = (-6317.9922, 7600.9448, 3508.7363);
	angles[13] = (0, -90, 0);
	at[13] = 3.8500;
	points[14] = (-6317.9922, 7600.9448, 3520.8347);
	angles[14] = (0, -90, 0);
	at[14] = 3.9000;
	points[15] = (-6317.9922, 7600.9448, 3517.5945);
	angles[15] = (0, -90, 0);
	at[15] = 3.9500;
	points[16] = (-6317.9922, 7600.9448, 3523.5002);
	angles[16] = (0, -90, 0);
	at[16] = 4;
	points[17] = (-6317.9922, 7600.9448, 3656.3743);
	angles[17] = (0, -90, 0);
	at[17] = 4.1500;
	points[18] = (-6317.9922, 7600.9448, 3626.2561);
	angles[18] = (0, -90, 0);
	at[18] = 4.2000;
	points[19] = (-6317.9922, 7600.9448, 3550.9604);
	angles[19] = (0, -90, 0);
	at[19] = 4.2500;
	points[20] = (-6317.9922, 7600.9448, 3430.4883);
	angles[20] = (0, -90, 0);
	at[20] = 4.3000;
	points[21] = (-6317.9922, 7600.9448, 3300.5669);
	angles[21] = (0, -90, 0);
	at[21] = 4.3500;
	points[22] = (-6317.9922, 7600.9448, 3300.5669);
	angles[22] = (0, -90, 0);
	at[22] = 4.5667;
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
	points[0] = (-10263.1113, 9823.9766, 3513.1653);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10263.1113, 9823.9766, 3513.1653);
	angles[1] = (0, 0, 0);
	at[1] = 2.4500;
	points[2] = (-10263.1113, 9823.9766, 3520.8347);
	angles[2] = (0, 0, 0);
	at[2] = 2.5000;
	points[3] = (-10263.1113, 9823.9766, 3517.5945);
	angles[3] = (0, 0, 0);
	at[3] = 2.5500;
	points[4] = (-10263.1113, 9823.9766, 3505.4919);
	angles[4] = (0, 0, 0);
	at[4] = 2.6000;
	points[5] = (-10263.1113, 9823.9766, 3508.7363);
	angles[5] = (0, 0, 0);
	at[5] = 2.6500;
	points[6] = (-10263.1113, 9823.9766, 3520.8347);
	angles[6] = (0, 0, 0);
	at[6] = 2.7000;
	points[7] = (-10263.1113, 9823.9766, 3517.5945);
	angles[7] = (0, 0, 0);
	at[7] = 2.7500;
	points[8] = (-10263.1113, 9823.9766, 3505.4919);
	angles[8] = (0, 0, 0);
	at[8] = 2.8000;
	points[9] = (-10263.1113, 9823.9766, 3508.7363);
	angles[9] = (0, 0, 0);
	at[9] = 2.8500;
	points[10] = (-10263.1113, 9823.9766, 3520.8347);
	angles[10] = (0, 0, 0);
	at[10] = 2.9000;
	points[11] = (-10263.1113, 9823.9766, 3517.5945);
	angles[11] = (0, 0, 0);
	at[11] = 2.9500;
	points[12] = (-10263.1113, 9823.9766, 3523.5002);
	angles[12] = (0, 0, 0);
	at[12] = 3;
	points[13] = (-10263.1113, 9823.9766, 3656.3743);
	angles[13] = (0, 0, 0);
	at[13] = 3.1500;
	points[14] = (-10263.1113, 9823.9766, 3626.2561);
	angles[14] = (0, 0, 0);
	at[14] = 3.2000;
	points[15] = (-10263.1113, 9823.9766, 3550.9604);
	angles[15] = (0, 0, 0);
	at[15] = 3.2500;
	points[16] = (-10263.1113, 9823.9766, 3430.4883);
	angles[16] = (0, 0, 0);
	at[16] = 3.3000;
	points[17] = (-10263.1113, 9823.9766, 3300.5669);
	angles[17] = (0, 0, 0);
	at[17] = 3.3500;
	points[18] = (-10263.1113, 9823.9766, 3300.5669);
	angles[18] = (0, 0, 0);
	at[18] = 4.3500;
	points[19] = (-10263.1113, 9823.9766, 3513.1653);
	angles[19] = (0, 0, 0);
	at[19] = 5.5500;
	points[20] = (-10263.1113, 9823.9766, 3513.1653);
	angles[20] = (0, 0, 0);
	at[20] = 5.5667;
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
	points[0] = (8823.4648, -3789.8896, 3405.0864);
	angles[0] = (0, 63.4350, 89.6536);
	at[0] = 0;
	points[1] = (8823.4648, -3789.8896, 3505.4565);
	angles[1] = (0, 63.4350, 89.9935);
	at[1] = 0.3000;
	points[2] = (8823.4648, -3789.8896, 3521.2124);
	angles[2] = (0, 63.4350, 0);
	at[2] = 0.3500;
	points[3] = (8823.4648, -3789.8896, 3568.9211);
	angles[3] = (0, 63.4350, 0);
	at[3] = 0.5000;
	points[4] = (8823.4648, -3789.8896, 3584.8779);
	angles[4] = (0, 0, 0);
	at[4] = 0.5500;
	points[5] = (8823.4648, -3789.8896, 3706.1104);
	angles[5] = (0, 0, 0);
	at[5] = 0.9500;
	points[6] = (8823.4648, -3789.8896, 3720.0393);
	angles[6] = (0, 63.4349, 0);
	at[6] = 1;
	points[7] = (8823.4648, -3789.8896, 3713.2285);
	angles[7] = (0, 63.4349, 0);
	at[7] = 1.0500;
	points[8] = (8823.4648, -3789.8896, 3699.0828);
	angles[8] = (0, 63.4349, 0);
	at[8] = 1.1000;
	points[9] = (8823.4648, -3789.8896, 3684.4844);
	angles[9] = (0, 63.4349, 89.9911);
	at[9] = 1.1500;
	points[10] = (8823.4648, -3789.8896, 3593.8623);
	angles[10] = (0, 63.4350, 88.3910);
	at[10] = 1.4500;
	points[11] = (8823.4648, -3789.8896, 3562.4211);
	angles[11] = (0, 63.4350, 80.9836);
	at[11] = 1.5500;
	points[12] = (8823.4648, -3789.8896, 3548.9883);
	angles[12] = (0, 63.4349, 68.9101);
	at[12] = 1.6000;
	points[13] = (8823.4648, -3789.8896, 3530.4685);
	angles[13] = (0, 63.4350, 43.2105);
	at[13] = 1.6500;
	points[14] = (8823.4648, -3789.8896, 3500.1890);
	angles[14] = (0, 63.4349, -36.3877);
	at[14] = 1.7500;
	points[15] = (8823.4648, -3789.8896, 3482.6301);
	angles[15] = (0, 63.4349, -61.4975);
	at[15] = 1.8000;
	points[16] = (8823.4648, -3789.8896, 3467.2678);
	angles[16] = (0, 63.4350, -75.2561);
	at[16] = 1.8500;
	points[17] = (8823.4648, -3789.8896, 3435.0510);
	angles[17] = (0, 63.4350, -86.1216);
	at[17] = 1.9500;
	points[18] = (8823.4648, -3789.8896, 3386.2324);
	angles[18] = (0, 63.4349, -89.4794);
	at[18] = 2.1000;
	points[19] = (8823.4648, -3789.8896, 3287.7246);
	angles[19] = (0, 63.4350, -89.9906);
	at[19] = 2.4000;
	points[20] = (8823.4648, -3789.8896, 3271.2717);
	angles[20] = (0, 63.4350, 0);
	at[20] = 2.4500;
	points[21] = (8823.4648, -3789.8896, 3221.4841);
	angles[21] = (0, 63.4350, 0);
	at[21] = 2.6000;
	points[22] = (8823.4648, -3789.8896, 3205.2126);
	angles[22] = (0, 0, 0);
	at[22] = 2.6500;
	points[23] = (8823.4648, -3789.8896, 3072.3623);
	angles[23] = (0, 0, 0);
	at[23] = 3.0500;
	points[24] = (8823.4648, -3789.8896, 3019.2915);
	angles[24] = (0, 0, 0);
	at[24] = 3.2000;
	points[25] = (8823.4648, -3789.8896, 3014.2124);
	angles[25] = (0, 63.4349, 0);
	at[25] = 3.2500;
	points[26] = (8823.4648, -3789.8896, 3049.1221);
	angles[26] = (0, 63.4349, 0);
	at[26] = 3.3500;
	points[27] = (8823.4648, -3789.8896, 3065.7444);
	angles[27] = (0, 63.4349, -89.9873);
	at[27] = 3.4000;
	points[28] = (8823.4648, -3789.8896, 3152.2244);
	angles[28] = (0, 63.4349, -89.0450);
	at[28] = 3.6500;
	points[29] = (8823.4648, -3789.8896, 3186.9922);
	angles[29] = (0, 63.4349, -84.6388);
	at[29] = 3.7500;
	points[30] = (8823.4648, -3789.8896, 3204.8542);
	angles[30] = (0, 63.4349, -77.3524);
	at[30] = 3.8000;
	points[31] = (8823.4648, -3789.8896, 3222.0708);
	angles[31] = (0, 63.4350, -60.7778);
	at[31] = 3.8500;
	points[32] = (8823.4648, -3789.8896, 3240.2637);
	angles[32] = (0, 63.4349, -28.3218);
	at[32] = 3.9000;
	points[33] = (8823.4648, -3789.8896, 3257.2913);
	angles[33] = (0, 63.4349, 14.2010);
	at[33] = 3.9500;
	points[34] = (8823.4648, -3789.8896, 3273.0471);
	angles[34] = (0, 63.4350, 34.5038);
	at[34] = 4;
	points[35] = (8823.4648, -3789.8896, 3289.0354);
	angles[35] = (0, 63.4350, 60.4123);
	at[35] = 4.0500;
	points[36] = (8823.4648, -3789.8896, 3306.8071);
	angles[36] = (0, 63.4350, 74.6823);
	at[36] = 4.1000;
	points[37] = (8823.4648, -3789.8896, 3341.8818);
	angles[37] = (0, 63.4350, 85.9696);
	at[37] = 4.2000;
	points[38] = (8823.4648, -3789.8896, 3405.0864);
	angles[38] = (0, 63.4350, 89.6537);
	at[38] = 4.3833;
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
	points[0] = (8401.4170, -3079.8584, 3192.4763);
	angles[0] = (0, 0, 84.7976);
	at[0] = 0;
	points[1] = (8401.4170, -3079.8584, 3243.1968);
	angles[1] = (0, 0, 89.3014);
	at[1] = 0.1500;
	points[2] = (8401.4170, -3079.8623, 3356.1221);
	angles[2] = (0, 0, 89.9936);
	at[2] = 0.5000;
	points[3] = (8401.4170, -3079.8584, 3372.2639);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (8401.4170, -3079.8584, 3537.4685);
	angles[4] = (0, 0, 0);
	at[4] = 1.1000;
	points[5] = (8401.4170, -3079.8584, 3527.7561);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (8401.4170, -3079.8584, 3498.8623);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (8401.4170, -3079.8584, 3483.9490);
	angles[7] = (0, 0, 89.9889);
	at[7] = 1.3000;
	points[8] = (8401.4170, -3079.8584, 3409.0947);
	angles[8] = (0, 0, 89.1675);
	at[8] = 1.5500;
	points[9] = (8401.4170, -3079.8623, 3378.2007);
	angles[9] = (0, 0, 85.3253);
	at[9] = 1.6500;
	points[10] = (8401.4170, -3079.8584, 3362.4724);
	angles[10] = (0, 0, 78.9591);
	at[10] = 1.7000;
	points[11] = (8401.4170, -3079.8584, 3346.5747);
	angles[11] = (0, 0, 64.3399);
	at[11] = 1.7500;
	points[12] = (8401.4170, -3079.8584, 3331.5828);
	angles[12] = (0, 0, 34.5927);
	at[12] = 1.8000;
	points[13] = (8401.4170, -3079.8584, 3317.2676);
	angles[13] = (0, 0, -7.6172);
	at[13] = 1.8500;
	points[14] = (8401.4170, -3079.8584, 3299.6494);
	angles[14] = (0, 0, -43.6106);
	at[14] = 1.9000;
	points[15] = (8401.4170, -3079.8584, 3284.7954);
	angles[15] = (0, 0, -65.5782);
	at[15] = 1.9500;
	points[16] = (8401.4170, -3079.8623, 3268.2168);
	angles[16] = (0, 0, -77.4017);
	at[16] = 2;
	points[17] = (8401.4170, -3079.8584, 3251.4805);
	angles[17] = (0, 0, -83.5368);
	at[17] = 2.0500;
	points[18] = (8401.4170, -3079.8584, 3219.7756);
	angles[18] = (0, 0, -88.3046);
	at[18] = 2.1500;
	points[19] = (8401.4170, -3079.8623, 3088.7363);
	angles[19] = (0, 0, -89.9919);
	at[19] = 2.5500;
	points[20] = (8401.4170, -3079.8623, 3072.2993);
	angles[20] = (0, 0, 0);
	at[20] = 2.6000;
	points[21] = (8401.4170, -3079.8584, 2871.2561);
	angles[21] = (0, 0, 0);
	at[21] = 3.2000;
	points[22] = (8401.4170, -3079.8623, 2841.7834);
	angles[22] = (0, 0, 0);
	at[22] = 3.3000;
	points[23] = (8401.4170, -3079.8584, 2891.9802);
	angles[23] = (0, 0, 0);
	at[23] = 3.4500;
	points[24] = (8401.4170, -3079.8623, 2909.7166);
	angles[24] = (0, 0, -89.9919);
	at[24] = 3.5000;
	points[25] = (8401.4170, -3079.8584, 3030.8977);
	angles[25] = (0, 0, -86.5669);
	at[25] = 3.8500;
	points[26] = (8401.4170, -3079.8623, 3048.5078);
	angles[26] = (0, 0, -81.8781);
	at[26] = 3.9000;
	points[27] = (8401.4170, -3079.8584, 3066.2559);
	angles[27] = (0, 0, -70.9557);
	at[27] = 3.9500;
	points[28] = (8401.4170, -3079.8584, 3083.5632);
	angles[28] = (0, 0, -47.2760);
	at[28] = 4;
	points[29] = (8401.4170, -3079.8584, 3105.7798);
	angles[29] = (0, 0, -21.4759);
	at[29] = 4.0500;
	points[30] = (8401.4170, -3079.8584, 3123.1221);
	angles[30] = (0, 0, 20.7657);
	at[30] = 4.1000;
	points[31] = (8401.4170, -3079.8584, 3140.4607);
	angles[31] = (0, 0, 52.1764);
	at[31] = 4.1500;
	points[32] = (8401.4170, -3079.8584, 3157.8308);
	angles[32] = (0, 0, 70.2769);
	at[32] = 4.2000;
	points[33] = (8401.4170, -3079.8584, 3175.2600);
	angles[33] = (0, 0, 79.8522);
	at[33] = 4.2500;
	points[34] = (8401.4170, -3079.8584, 3192.4763);
	angles[34] = (0, 0, 84.7976);
	at[34] = 4.3000;
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
	points[0] = (6436.2202, -9632.7168, 3900.4292);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6436.2202, -9632.7168, 3983.0315);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (6436.2202, -9632.7168, 4168.2285);
	angles[2] = (0, 0, 0);
	at[2] = 0.8500;
	points[3] = (6436.2202, -9632.7168, 4270);
	angles[3] = (0, 0, 0);
	at[3] = 1.2000;
	points[4] = (6436.2202, -9632.7168, 4272.0869);
	angles[4] = (0, 0, 0);
	at[4] = 1.2500;
	points[5] = (6436.2202, -9632.7168, 4140.6694);
	angles[5] = (0, 0, 0);
	at[5] = 1.7000;
	points[6] = (6436.2202, -9632.7168, 3971.7717);
	angles[6] = (0, 0, 0);
	at[6] = 2.2500;
	points[7] = (6436.2202, -9632.7168, 3759.4919);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (6436.2202, -9632.7168, 3575.1772);
	angles[8] = (0, 0, 0);
	at[8] = 3.4500;
	points[9] = (6436.2202, -9632.7168, 3586.6301);
	angles[9] = (0, 0, 0);
	at[9] = 3.5000;
	points[10] = (6436.2202, -9632.7168, 3603.5510);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (6436.2202, -9632.7168, 3900.4292);
	angles[11] = (0, 0, 0);
	at[11] = 4.4000;
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
	points[0] = (5492.4409, -10058.5039, 4136.9292);
	angles[0] = (0, 90, 87.4682);
	at[0] = 0;
	points[1] = (5492.4409, -10058.5039, 4121.7720);
	angles[1] = (0, 90, 84.0053);
	at[1] = 0.0500;
	points[2] = (5492.4409, -10058.5039, 4106.4961);
	angles[2] = (0, 90, 75.8748);
	at[2] = 0.1000;
	points[3] = (5492.4409, -10058.5039, 4091.2205);
	angles[3] = (0, 90, 57.5589);
	at[3] = 0.1500;
	points[4] = (5492.4409, -10058.5039, 4075.8662);
	angles[4] = (0, 90, 22.9803);
	at[4] = 0.2000;
	points[5] = (5492.4409, -10058.5039, 4060.1575);
	angles[5] = (0, 90, -19.3730);
	at[5] = 0.2500;
	points[6] = (5492.4409, -10058.5039, 4044.9604);
	angles[6] = (0, 90, -51.3046);
	at[6] = 0.3000;
	points[7] = (5492.4409, -10058.5039, 4028.7795);
	angles[7] = (0, 90, -69.8047);
	at[7] = 0.3500;
	points[8] = (5492.4409, -10058.5039, 4013.5039);
	angles[8] = (0, 90, -79.6068);
	at[8] = 0.4000;
	points[9] = (5492.4409, -10058.5039, 3982.7954);
	angles[9] = (0, 90, -87.2706);
	at[9] = 0.5000;
	points[10] = (5492.4409, -10058.5039, 3837.5354);
	angles[10] = (0, 90, -89.9934);
	at[10] = 0.9500;
	points[11] = (5492.4409, -10058.5039, 3821.0120);
	angles[11] = (0, 90, 0);
	at[11] = 1;
	points[12] = (5492.4409, -10058.5039, 3788.2007);
	angles[12] = (0, 90, 0);
	at[12] = 1.1000;
	points[13] = (5492.4409, -10058.5039, 3771.7913);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (5492.4409, -10058.5039, 3573.3347);
	angles[14] = (0, 0, 0);
	at[14] = 1.7500;
	points[15] = (5492.4409, -10058.5039, 3591.9055);
	angles[15] = (0, 90, 0);
	at[15] = 1.8000;
	points[16] = (5492.4409, -10058.5039, 3607.9211);
	angles[16] = (0, 90, 0);
	at[16] = 1.8500;
	points[17] = (5492.4409, -10058.5039, 3625.2048);
	angles[17] = (0, 90, -89.9924);
	at[17] = 1.9000;
	points[18] = (5492.4409, -10058.5039, 3746.4568);
	angles[18] = (0, 90, -86.8274);
	at[18] = 2.2500;
	points[19] = (5492.4409, -10058.5039, 3763.7363);
	angles[19] = (0, 90, -82.4921);
	at[19] = 2.3000;
	points[20] = (5492.4409, -10058.5039, 3781.6890);
	angles[20] = (0, 90, -72.3676);
	at[20] = 2.3500;
	points[21] = (5492.4409, -10058.5039, 3799.0708);
	angles[21] = (0, 90, -50.1559);
	at[21] = 2.4000;
	points[22] = (5492.4409, -10058.5039, 3835.0198);
	angles[22] = (0, 90, 29.1511);
	at[22] = 2.5000;
	points[23] = (5492.4409, -10058.5039, 3851.5159);
	angles[23] = (0, 90, 57.2749);
	at[23] = 2.5500;
	points[24] = (5492.4409, -10058.5039, 3868.9961);
	angles[24] = (0, 90, 73.0153);
	at[24] = 2.6000;
	points[25] = (5492.4409, -10058.5039, 3886.2874);
	angles[25] = (0, 90, 81.2722);
	at[25] = 2.6500;
	points[26] = (5492.4409, -10058.5039, 3920.2915);
	angles[26] = (0, 90, 87.7091);
	at[26] = 2.7500;
	points[27] = (5492.4409, -10058.5039, 4048.1497);
	angles[27] = (0, 90, 89.9892);
	at[27] = 3.1500;
	points[28] = (5492.4409, -10058.5039, 4064.1338);
	angles[28] = (0, 90, 0);
	at[28] = 3.2000;
	points[29] = (5492.4409, -10058.5039, 4110.3936);
	angles[29] = (0, 90, 0);
	at[29] = 3.3500;
	points[30] = (5492.4409, -10058.5039, 4125.5513);
	angles[30] = (0, 0, 0);
	at[30] = 3.4000;
	points[31] = (5492.4409, -10058.5039, 4273.1890);
	angles[31] = (0, 0, 0);
	at[31] = 3.9000;
	points[32] = (5492.4409, -10058.5039, 4274.1343);
	angles[32] = (0, 90, 0);
	at[32] = 3.9500;
	points[33] = (5492.4409, -10058.5039, 4245.3936);
	angles[33] = (0, 90, 0);
	at[33] = 4.0500;
	points[34] = (5492.4409, -10058.5039, 4230.3540);
	angles[34] = (0, 90, 89.9892);
	at[34] = 4.1000;
	points[35] = (5492.4409, -10058.5039, 4136.9292);
	angles[35] = (0, 90, 87.4683);
	at[35] = 4.4167;
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
	points[0] = (9142.5195, -6205.3545, 4785.7085);
	angles[0] = (0, 0, -20.2615);
	at[0] = 0;
	points[1] = (9142.5195, -6156.1416, 4889.0552);
	angles[1] = (0, 0, -35.2289);
	at[1] = 0.0833;
	points[2] = (9142.5195, -6106.9292, 4977.6377);
	angles[2] = (0, 0, -50.1963);
	at[2] = 0.1667;
	points[3] = (9142.5195, -6057.7163, 5051.4570);
	angles[3] = (0, 0, -65.1637);
	at[3] = 0.2500;
	points[4] = (9142.5195, -6008.5039, 5110.5122);
	angles[4] = (0, 0, -80.1311);
	at[4] = 0.3333;
	points[5] = (9142.5195, -5959.2915, 5154.8037);
	angles[5] = (0, 0, -95.0985);
	at[5] = 0.4167;
	points[6] = (9142.5195, -5910.0786, 5184.3311);
	angles[6] = (0, 0, -110.0659);
	at[6] = 0.5000;
	points[7] = (9142.5195, -5860.8662, 5199.0947);
	angles[7] = (0, 0, -125.0333);
	at[7] = 0.5833;
	points[8] = (9142.5195, -5811.6934, 5199.0947);
	angles[8] = (0, 0, -140);
	at[8] = 0.6667;
	points[9] = (9142.5195, -5762.4805, 5184.3311);
	angles[9] = (0, 0, -154.9682);
	at[9] = 0.7500;
	points[10] = (9142.5195, -5713.2681, 5154.8037);
	angles[10] = (0, 0, -169.9356);
	at[10] = 0.8333;
	points[11] = (9142.5195, -5664.0552, 5110.5122);
	angles[11] = (0, 0, -184.9030);
	at[11] = 0.9167;
	points[12] = (9142.5195, -5614.8428, 5051.4570);
	angles[12] = (0, 0, -199.8703);
	at[12] = 1;
	points[13] = (9142.5195, -5565.6304, 4977.6377);
	angles[13] = (0, 0, -214.8377);
	at[13] = 1.0833;
	points[14] = (9142.5195, -5516.4175, 4889.0552);
	angles[14] = (0, 0, -229.8052);
	at[14] = 1.1667;
	points[15] = (9142.5195, -5467.2051, 4785.7085);
	angles[15] = (0, 0, -244.7726);
	at[15] = 1.2500;
	points[16] = (9142.5195, -5417.9922, 4667.5986);
	angles[16] = (0, 0, -259.7400);
	at[16] = 1.3333;
	points[17] = (9142.5195, -5368.7798, 4534.7246);
	angles[17] = (0, 0, -274.7073);
	at[17] = 1.4167;
	points[18] = (9142.5195, -5319.5674, 4387.0864);
	angles[18] = (0, 0, -289.6748);
	at[18] = 1.5000;
	points[19] = (9142.5195, -5270.3545, 4224.6851);
	angles[19] = (0, 0, -304.6422);
	at[19] = 1.5833;
	points[20] = (9142.5195, -5221.1421, 4047.5198);
	angles[20] = (0, 0, -319.6095);
	at[20] = 1.6667;
	points[21] = (9142.5195, -5171.9292, 3863.0945);
	angles[21] = (0, 0, -336.8850);
	at[21] = 1.7500;
	points[22] = (9142.5195, -5122.7168, 3913.5867);
	angles[22] = (0, 0, -363.3927);
	at[22] = 1.8333;
	points[23] = (9142.5195, -5073.5044, 3949.3308);
	angles[23] = (0, 0, -389.9004);
	at[23] = 1.9167;
	points[24] = (9142.5195, -5024.2915, 3970.2756);
	angles[24] = (0, 0, -416.4081);
	at[24] = 2;
	points[25] = (9142.5195, -4975.0786, 3976.4961);
	angles[25] = (0, 0, -442.9159);
	at[25] = 2.0833;
	points[26] = (9142.5195, -4925.8662, 3967.9136);
	angles[26] = (0, 0, -469.4235);
	at[26] = 2.1667;
	points[27] = (9142.5195, -4876.6533, 3944.6064);
	angles[27] = (0, 0, -495.9312);
	at[27] = 2.2500;
	points[28] = (9142.5195, -4827.4409, 3906.5000);
	angles[28] = (0, 0, -522.4388);
	at[28] = 2.3333;
	points[29] = (9142.5195, -4778.2285, 3853.6458);
	angles[29] = (0, 0, -548.9465);
	at[29] = 2.4167;
	points[30] = (9142.5195, -4729.0156, 3786.0276);
	angles[30] = (0, 0, -575.4543);
	at[30] = 2.5000;
	points[31] = (9142.5195, -4679.8032, 3783.5393);
	angles[31] = (0, 0, -606.9977);
	at[31] = 2.5833;
	points[32] = (9142.5195, -4630.5903, 3785.8149);
	angles[32] = (0, 0, -638.5411);
	at[32] = 2.6667;
	points[33] = (9142.5195, -4581.3779, 3773.3228);
	angles[33] = (0, 0, -670.0846);
	at[33] = 2.7500;
	points[34] = (9142.5195, -4532.1650, 3746.0708);
	angles[34] = (0, 0, -701.6281);
	at[34] = 2.8333;
	points[35] = (9142.5195, -4482.9526, 3730.3621);
	angles[35] = (0, 0, -736.1510);
	at[35] = 2.9167;
	points[36] = (9142.5195, -4423.4253, 3728.2007);
	angles[36] = (0, 0, -772.6603);
	at[36] = 3;
	points[37] = (9142.5195, -4307.6772, 3691.3071);
	angles[37] = (0, 0, -847.6932);
	at[37] = 3.1667;
	points[38] = (9142.5195, -4249.8032, 3689.8857);
	angles[38] = (0, 0, -889.2382);
	at[38] = 3.2500;
	points[39] = (9142.5195, -4134.0552, 3655.9805);
	angles[39] = (0, 0, -974.3146);
	at[39] = 3.4167;
	points[40] = (9142.5195, -4076.1814, 3654.3386);
	angles[40] = (0, 0, -1020.8254);
	at[40] = 3.5000;
	points[41] = (9142.5195, -3960.4331, 3623.5789);
	angles[41] = (0, 0, -1116.8687);
	at[41] = 3.6667;
	points[42] = (9142.5195, -3902.5591, 3618.1653);
	angles[42] = (0, 0, -1168.4152);
	at[42] = 3.7500;
	points[43] = (9142.5195, -3844.6890, 3597.9844);
	angles[43] = (0, 0, -1219.9619);
	at[43] = 3.8333;
	points[44] = (9142.5195, -3728.9412, 3582.7756);
	angles[44] = (0, 0, -1331.9935);
	at[44] = 4;
	points[45] = (9142.5195, -3671.0710, 3559.8899);
	angles[45] = (0, 0, -1388.5060);
	at[45] = 4.0833;
	points[46] = (9142.5195, -3613.1968, 3557.4644);
	angles[46] = (0, 0, -1450.0542);
	at[46] = 4.1667;
	points[47] = (9142.5195, -3555.3267, 3546.3188);
	angles[47] = (0, 0, -1511.6024);
	at[47] = 4.2500;
	points[48] = (9142.5195, -3497.4526, 3522.8228);
	angles[48] = (0, 0, -1574.1437);
	at[48] = 4.3333;
	points[49] = (9142.5195, -3439.5828, 3523.5081);
	angles[49] = (0, 0, -1640.6577);
	at[49] = 4.4167;
	points[50] = (9142.5195, -3381.7087, 3509.4331);
	angles[50] = (0, 0, -1707.1718);
	at[50] = 4.5000;
	points[51] = (9142.5195, -3323.8386, 3491.2129);
	angles[51] = (0, 0, -1775.7001);
	at[51] = 4.5833;
	points[52] = (9142.5195, -3265.9646, 3488.9412);
	angles[52] = (0, 0, -1847.2499);
	at[52] = 4.6667;
	points[53] = (9142.5195, -3208.0903, 3471.9016);
	angles[53] = (0, 0, -1918.7997);
	at[53] = 4.7500;
	points[54] = (9142.5195, -3150.2207, 3459.0120);
	angles[54] = (0, 0, -1993.3290);
	at[54] = 4.8333;
	points[55] = (9142.5195, -3092.3503, 3453.7874);
	angles[55] = (0, 0, -2069.8447);
	at[55] = 4.9167;
	points[56] = (9142.5195, -3034.4763, 3433.7991);
	angles[56] = (0, 0, -2146.3601);
	at[56] = 5;
	points[57] = (9142.5195, -2976.6062, 3426.2166);
	angles[57] = (0, 0, -2226.9043);
	at[57] = 5.0833;
	points[58] = (9142.5195, -2918.7324, 3418.0432);
	angles[58] = (0, 0, -2308.4558);
	at[58] = 5.1667;
	points[59] = (9142.5195, -2860.8584, 3395.1025);
	angles[59] = (0, 0, -2390.0071);
	at[59] = 5.2500;
	points[60] = (9142.5195, -2802.9883, 3392.8347);
	angles[60] = (0, 0, -2476.5244);
	at[60] = 5.3333;
	points[61] = (9142.5195, -2745.1143, 3381.7048);
	angles[61] = (0, 0, -2563.0415);
	at[61] = 5.4167;
	points[62] = (9142.5195, -2687.2439, 3358.1812);
	angles[62] = (0, 0, -2650.5659);
	at[62] = 5.5000;
	points[63] = (9142.5195, -2629.3701, 3358.8623);
	angles[63] = (0, 0, -2742.1189);
	at[63] = 5.5833;
	points[64] = (9142.5195, -2571.5000, 3344.7795);
	angles[64] = (0, 0, -2833.6719);
	at[64] = 5.6667;
	points[65] = (9142.5195, -2513.6260, 3326.5669);
	angles[65] = (0, 0, -2927.2109);
	at[65] = 5.7500;
	points[66] = (9142.5195, -2455.7561, 3324.2993);
	angles[66] = (0, 0, -3023.7297);
	at[66] = 5.8333;
	points[67] = (9142.5195, -2397.8818, 3307.2639);
	angles[67] = (0, 0, -3120.2485);
	at[67] = 5.9167;
	points[68] = (9142.5195, -2340.0117, 3294.3662);
	angles[68] = (0, 0, -3219.7888);
	at[68] = 6;
	points[69] = (9142.5195, -2282.1379, 3289.1416);
	angles[69] = (0, 0, -3321.3433);
	at[69] = 6.0833;
	points[70] = (9142.5195, -2224.2639, 3269.1575);
	angles[70] = (0, 0, -3422.8979);
	at[70] = 6.1667;
	points[71] = (9142.5195, -2166.3896, 3261.5750);
	angles[71] = (0, 0, -3528.4250);
	at[71] = 6.2500;
	points[72] = (9142.5195, -2108.5198, 3253.3977);
	angles[72] = (0, 0, -3634.9453);
	at[72] = 6.3333;
	points[73] = (9142.5195, -2050.6458, 3230.4565);
	angles[73] = (0, 0, -3741.4658);
	at[73] = 6.4167;
	points[74] = (9142.5195, -1992.7756, 3228.1931);
	angles[74] = (0, 0, -3853.0220);
	at[74] = 6.5000;
	points[75] = (9142.5195, -1934.9016, 3217.0630);
	angles[75] = (0, 0, -3964.5779);
	at[75] = 6.5833;
	points[76] = (9142.5195, -1877.0275, 3193.5354);
	angles[76] = (0, 0, -4077.1272);
	at[76] = 6.6667;
	points[77] = (9142.5195, -1819.1575, 3194.2166);
	angles[77] = (0, 0, -4193.6494);
	at[77] = 6.7500;
	points[78] = (9142.5195, -1761.2834, 3180.1338);
	angles[78] = (0, 0, -4310.1709);
	at[78] = 6.8333;
	points[79] = (9142.5195, -1703.4095, 3161.9250);
	angles[79] = (0, 0, -4428.7075);
	at[79] = 6.9167;
	points[80] = (9142.5195, -1645.5355, 3159.6538);
	angles[80] = (0, 0, -4550.2651);
	at[80] = 7;
	points[81] = (9142.5195, -1587.6653, 3142.6182);
	angles[81] = (0, 0, -4671.8228);
	at[81] = 7.0833;
	points[82] = (9142.5195, -1529.7914, 3129.7207);
	angles[82] = (0, 0, -4796.3599);
	at[82] = 7.1667;
	points[83] = (9142.5195, -1471.9174, 3124.5000);
	angles[83] = (0, 0, -4922.8833);
	at[83] = 7.2500;
	points[84] = (9142.5195, -1414.0474, 3104.5117);
	angles[84] = (0, 0, -5049.4067);
	at[84] = 7.3333;
	points[85] = (9142.5195, -1356.1732, 3096.9292);
	angles[85] = (0, 0, -5179.9590);
	at[85] = 7.4167;
	points[86] = (9142.5195, -1298.2992, 3088.7520);
	angles[86] = (0, 0, -5311.5181);
	at[86] = 7.5000;
	points[87] = (9142.5195, -1240.4292, 3065.8149);
	angles[87] = (0, 0, -5443.0776);
	at[87] = 7.5833;
	points[88] = (9142.5195, -1182.5552, 3063.5474);
	angles[88] = (0, 0, -5579.6025);
	at[88] = 7.6667;
	points[89] = (9142.5195, -1124.6812, 3052.4175);
	angles[89] = (0, 0, -5716.1279);
	at[89] = 7.7500;
	points[90] = (9142.5195, -1066.8110, 3028.8899);
	angles[90] = (0, 0, -5853.6460);
	at[90] = 7.8333;
	points[91] = (9142.5195, -1008.9371, 3029.5710);
	angles[91] = (0, 0, -5995.1372);
	at[91] = 7.9167;
	points[92] = (9142.5195, -951.0630, 3015.4922);
	angles[92] = (0, 0, -6136.6279);
	at[92] = 8;
	points[93] = (9142.5195, -893.1929, 2997.2795);
	angles[93] = (0, 0, -6280.1333);
	at[93] = 8.0833;
	points[94] = (9142.5195, -835.3189, 2995.0078);
	angles[94] = (0, 0, -6426.6597);
	at[94] = 8.1667;
	points[95] = (9142.5195, -777.4449, 2977.9727);
	angles[95] = (0, 0, -6573.1865);
	at[95] = 8.2500;
	points[96] = (9142.5195, -719.5748, 2965.0789);
	angles[96] = (0, 0, -6722.6929);
	at[96] = 8.3333;
	points[97] = (9142.5195, -661.7007, 2959.8542);
	angles[97] = (0, 0, -6874.1851);
	at[97] = 8.4167;
	points[98] = (9142.5195, -603.8268, 2939.8662);
	angles[98] = (0, 0, -7025.6777);
	at[98] = 8.5000;
	points[99] = (9142.5195, -545.9567, 2932.2837);
	angles[99] = (0, 0, -7181.1987);
	at[99] = 8.5833;
	points[100] = (9142.5195, -488.0827, 2924.1064);
	angles[100] = (0, 0, -7337.7271);
	at[100] = 8.6667;
	points[101] = (9142.5195, -430.2087, 2901.1692);
	angles[101] = (0, 0, -7494.2554);
	at[101] = 8.7500;
	points[102] = (9142.5195, -372.0398, 2898.9016);
	angles[102] = (0, 0, -7655.7495);
	at[102] = 8.8333;
	points[103] = (9142.5195, -312.9890, 2887.7717);
	angles[103] = (0, 0, -7817.2437);
	at[103] = 8.9167;
	points[104] = (9142.5195, -253.9378, 2863.7046);
	angles[104] = (0, 0, -7979.7446);
	at[104] = 9;
	points[105] = (9142.5195, -194.8870, 2864.3899);
	angles[105] = (0, 0, -8146.2739);
	at[105] = 9.0833;
	points[106] = (9142.5195, -135.8362, 2860);
	angles[106] = (0, 0, -8316.7910);
	at[106] = 9.1667;
	points[107] = (9142.5195, -76.7854, 2860);
	angles[107] = (0, 0, -8148.3037);
	at[107] = 9.2500;
	points[108] = (9142.5195, -17.7348, 2860);
	angles[108] = (0, 0, -8004.8271);
	at[108] = 9.3333;
	points[109] = (9142.5195, 41.3161, 2860);
	angles[109] = (0, 0, -7886.3486);
	at[109] = 9.4167;
	points[110] = (9142.5195, 100.3669, 2860);
	angles[110] = (0, 0, -7792.8799);
	at[110] = 9.5000;
	points[111] = (9142.5195, 159.4177, 2860);
	angles[111] = (0, 0, -7724.4087);
	at[111] = 9.5833;
	points[112] = (9142.5195, 218.4685, 2860);
	angles[112] = (0, 0, -7680.9482);
	at[112] = 9.6667;
	points[113] = (9142.5195, 277.5193, 2860);
	angles[113] = (0, 0, -7662.4849);
	at[113] = 9.7500;
	points[114] = (9142.5195, 336.5701, 2860);
	angles[114] = (0, 0, -7669.0044);
	at[114] = 9.8333;
	points[115] = (9142.5195, 395.6221, 2860);
	angles[115] = (0, 0, -7700.5210);
	at[115] = 9.9167;
	points[116] = (9142.5195, 454.6732, 2860);
	angles[116] = (0, 0, -7757.0342);
	at[116] = 10;
	points[117] = (9142.5195, 513.7205, 2860);
	angles[117] = (0, 0, -7838.5586);
	at[117] = 10.0833;
	points[118] = (9142.5195, 572.7717, 2860);
	angles[118] = (0, 0, -7945.0801);
	at[118] = 10.1667;
	points[119] = (9142.5195, 631.8228, 2860);
	angles[119] = (0, 0, -8076.6123);
	at[119] = 10.2500;
	points[120] = (9142.5195, 690.8740, 2860);
	angles[120] = (0, 0, -8233.1416);
	at[120] = 10.3333;
	points[121] = (9142.5195, 749.9252, 2860);
	angles[121] = (0, 0, -8054.6826);
	at[121] = 10.4167;
	points[122] = (9142.5195, 808.9764, 2860);
	angles[122] = (0, 0, -7901.2197);
	at[122] = 10.5000;
	points[123] = (9142.5195, 868.0275, 2860);
	angles[123] = (0, 0, -7772.7393);
	at[123] = 10.5833;
	points[124] = (9142.5195, 927.0787, 2860);
	angles[124] = (0, 0, -7669.2568);
	at[124] = 10.6667;
	points[125] = (9142.5195, 986.1299, 2860);
	angles[125] = (0, 0, -7590.7705);
	at[125] = 10.7500;
	points[126] = (9142.5195, 1045.1812, 2860);
	angles[126] = (0, 0, -7537.2954);
	at[126] = 10.8333;
	points[127] = (9142.5195, 1104.2284, 2860);
	angles[127] = (0, 0, -7508.8179);
	at[127] = 10.9167;
	points[128] = (9142.5195, 1163.2795, 2860);
	angles[128] = (0, 0, -7505.3506);
	at[128] = 11;
	points[129] = (9142.5195, 1222.3307, 2860);
	angles[129] = (0, 0, -7526.8809);
	at[129] = 11.0833;
	points[130] = (9142.5195, 1281.3820, 2860);
	angles[130] = (0, 0, -7573.4214);
	at[130] = 11.1667;
	points[131] = (9142.5195, 1340.4331, 2860);
	angles[131] = (0, 0, -7644.9595);
	at[131] = 11.2500;
	points[132] = (9142.5195, 1399.4844, 2860);
	angles[132] = (0, 0, -7741.4663);
	at[132] = 11.3333;
	points[133] = (9142.5195, 1458.5354, 2860);
	angles[133] = (0, 0, -7862.9839);
	at[133] = 11.4167;
	points[134] = (9142.5195, 1517.5867, 2860);
	angles[134] = (0, 0, -8009.4985);
	at[134] = 11.5000;
	points[135] = (9142.5195, 1576.6378, 2860);
	angles[135] = (0, 0, -8181.0239);
	at[135] = 11.5833;
	points[136] = (9142.5195, 1635.6891, 2860);
	angles[136] = (0, 0, -8017.5474);
	at[136] = 11.6667;
	points[137] = (9142.5195, 1694.7362, 2860);
	angles[137] = (0, 0, -7879.0806);
	at[137] = 11.7500;
	points[138] = (9142.5195, 1753.7875, 2860);
	angles[138] = (0, 0, -7765.6118);
	at[138] = 11.8333;
	points[139] = (9142.5195, 1812.8386, 2860);
	angles[139] = (0, 0, -7677.1528);
	at[139] = 11.9167;
	points[140] = (9142.5195, 1871.8899, 2860);
	angles[140] = (0, 0, -7613.6909);
	at[140] = 12;
	points[141] = (9142.5195, 1930.9409, 2860);
	angles[141] = (0, 0, -7575.1987);
	at[141] = 12.0833;
	points[142] = (9142.5195, 1989.9921, 2860);
	angles[142] = (0, 0, -7561.7168);
	at[142] = 12.1667;
	points[143] = (9142.5195, 2049.0432, 2860);
	angles[143] = (0, 0, -7573.2324);
	at[143] = 12.2500;
	points[144] = (9142.5195, 2108.0945, 2860);
	angles[144] = (0, 0, -7609.7588);
	at[144] = 12.3333;
	points[145] = (9142.5195, 2167.1458, 2860);
	angles[145] = (0, 0, -7671.2817);
	at[145] = 12.4167;
	points[146] = (9142.5195, 2201.2166, 2860);
	angles[146] = (0, 0, -7757.8164);
	at[146] = 12.5000;
	points[147] = (9142.5195, 2237.9214, 2860);
	angles[147] = (0, 0, -7869.3472);
	at[147] = 12.5833;
	points[148] = (9142.5195, 2274.6299, 2858.5042);
	angles[148] = (0, 0, -8002.8960);
	at[148] = 12.6667;
	points[149] = (9142.5195, 2311.3347, 2844.4211);
	angles[149] = (0, 0, -8139.4526);
	at[149] = 12.7500;
	points[150] = (9142.5195, 2348.0396, 2815.5750);
	angles[150] = (0, 0, -8276.0078);
	at[150] = 12.8333;
	points[151] = (9142.5195, 2384.7480, 2771.9646);
	angles[151] = (0, 0, -8412.5645);
	at[151] = 12.9167;
	points[152] = (9142.5195, 2421.4529, 2713.5945);
	angles[152] = (0, 0, -8549.1211);
	at[152] = 13;
	points[153] = (9142.5195, 2458.1575, 2640.4565);
	angles[153] = (0, 0, -8685.6768);
	at[153] = 13.0833;
	points[154] = (9142.5195, 2494.8662, 2552.5552);
	angles[154] = (0, 0, -8822.2334);
	at[154] = 13.1667;
	points[155] = (9142.5195, 2531.5710, 2449.8899);
	angles[155] = (0, 0, -8958.7891);
	at[155] = 13.2500;
	points[156] = (9142.5195, 2568.2756, 2332.4607);
	angles[156] = (0, 0, -9095.3447);
	at[156] = 13.3333;
	points[157] = (9142.5195, 2604.9844, 2200.2676);
	angles[157] = (0, 0, -9231.9014);
	at[157] = 13.4167;
	points[158] = (9142.5195, 2641.6890, 2053.3110);
	angles[158] = (0, 0, -9368.4570);
	at[158] = 13.5000;
	points[159] = (9142.5195, 2678.3936, 1891.5905);
	angles[159] = (0, 0, -9505.0137);
	at[159] = 13.5833;
	points[160] = (9142.5195, 2715.1023, 1715.1063);
	angles[160] = (0, 0, -9641.5693);
	at[160] = 13.6667;
	points[161] = (9142.5195, 2751.8069, 1523.8622);
	angles[161] = (0, 0, -9778.1260);
	at[161] = 13.7500;
	points[162] = (9142.5195, 2788.5159, 1317.8505);
	angles[162] = (0, 0, -9914.6816);
	at[162] = 13.8333;
	points[163] = (9142.5195, 2825.2205, 1097.0748);
	angles[163] = (0, 0, -10051.2383);
	at[163] = 13.9167;
	points[164] = (9142.5195, 2861.9253, 861.5354);
	angles[164] = (0, 0, -10187.7939);
	at[164] = 14;
	points[165] = (9142.5195, 2898.6338, 611.2323);
	angles[165] = (0, 0, -10324.3506);
	at[165] = 14.0833;
	points[166] = (9142.5195, 2935.3386, 346.1642);
	angles[166] = (0, 0, -10460.8926);
	at[166] = 14.1667;
	points[167] = (9142.5195, 2972.0471, 66.3339);
	angles[167] = (0, 0, -10597.4492);
	at[167] = 14.2500;
	points[168] = (9142.5195, 3008.7522, -228.2602);
	angles[168] = (0, 0, -10734.0049);
	at[168] = 14.3333;
	points[169] = (9142.5195, 3045.4568, -537.6181);
	angles[169] = (0, 0, -10870.5605);
	at[169] = 14.4167;
	points[170] = (9142.5195, 3082.1655, -861.7402);
	angles[170] = (0, 0, -11007.1172);
	at[170] = 14.5000;
	points[171] = (9142.5195, 3118.8701, -1200.6260);
	angles[171] = (0, 0, -11143.6729);
	at[171] = 14.5833;
	points[172] = (9142.5195, 3155.5750, -1554.2756);
	angles[172] = (0, 0, -11280.2295);
	at[172] = 14.6667;
	points[173] = (9142.5195, 3192.2834, -1922.6890);
	angles[173] = (0, 0, -11416.7852);
	at[173] = 14.7500;
	points[174] = (9142.5195, 3228.9880, -2305.8662);
	angles[174] = (0, 0, -11553.3418);
	at[174] = 14.8333;
	points[175] = (9142.5195, 3265.6968, -2703.8069);
	angles[175] = (0, 0, -11689.8975);
	at[175] = 14.9167;
	points[176] = (9142.5195, 3302.4014, -3116.5081);
	angles[176] = (0, 0, -11826.4541);
	at[176] = 15;
	points[177] = (9142.5195, 3339.1064, -3543.9763);
	angles[177] = (0, 0, -11963.0098);
	at[177] = 15.0833;
	points[178] = (9142.5195, 3375.8149, -3986.2205);
	angles[178] = (0, 0, -12099.5664);
	at[178] = 15.1667;
	points[179] = (9142.5195, 3412.5198, -4443.1890);
	angles[179] = (0, 0, -12236.1221);
	at[179] = 15.2500;
	points[180] = (9142.5195, 3449.2244, -4914.9604);
	angles[180] = (0, 0, -12372.6787);
	at[180] = 15.3333;
	points[181] = (9142.5195, 3485.9331, -5401.4961);
	angles[181] = (0, 0, -12509.2344);
	at[181] = 15.4167;
	points[182] = (9142.5195, 3522.6377, -5902.7559);
	angles[182] = (0, 0, -12645.7910);
	at[182] = 15.5000;
	points[183] = (9142.5195, 3559.3467, -6418.8188);
	angles[183] = (0, 0, -12782.3467);
	at[183] = 15.5833;
	points[184] = (9142.5195, 3596.0513, -6949.6455);
	angles[184] = (0, 0, -12918.9033);
	at[184] = 15.6667;
	points[185] = (9142.5195, 3632.7561, -7495.2363);
	angles[185] = (0, 0, -13055.4590);
	at[185] = 15.7500;
	points[186] = (9142.5195, 3669.4646, -8055.5508);
	angles[186] = (0, 0, -13192.0156);
	at[186] = 15.8333;
	points[187] = (9142.5195, 3706.1694, -8630.6689);
	angles[187] = (0, 0, -13328.5713);
	at[187] = 15.9167;
	points[188] = (9142.5195, 3742.8740, -9220.5508);
	angles[188] = (0, 0, -13465.1279);
	at[188] = 16;
	points[189] = (9142.5195, 3772.2402, -9703.0703);
	angles[189] = (0, 0, -13358.3721);
	at[189] = 16.0833;
	points[190] = (9142.5195, -6215.1968, 4740.2363);
	angles[190] = (0, 0, -13358.3721);
	at[190] = 16.0833;
	points[191] = (9142.5195, -6205.3545, 4785.7085);
	angles[191] = (0, 0, -13340.2617);
	at[191] = 16.1333;
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
	points[0] = (8521.7715, -6207.8350, 4780.6299);
	angles[0] = (0, 0, 27.7111);
	at[0] = 0;
	points[1] = (8521.7715, -6164.7642, 4869.2129);
	angles[1] = (0, 0, 12.7437);
	at[1] = 0.0833;
	points[2] = (8521.7715, -6121.6929, 4943.0317);
	angles[2] = (0, 0, -2.2237);
	at[2] = 0.1667;
	points[3] = (8521.7715, -6078.6611, 5002.0869);
	angles[3] = (0, 0, -17.1912);
	at[3] = 0.2500;
	points[4] = (8521.7715, -6035.5908, 5046.3779);
	angles[4] = (0, 0, -32.1585);
	at[4] = 0.3333;
	points[5] = (8521.7715, -5992.5200, 5075.9053);
	angles[5] = (0, 0, -47.1260);
	at[5] = 0.4167;
	points[6] = (8521.7715, -5949.4487, 5090.6689);
	angles[6] = (0, 0, -62.0933);
	at[6] = 0.5000;
	points[7] = (8521.7715, -5906.4170, 5090.6689);
	angles[7] = (0, 0, -77.0607);
	at[7] = 0.5833;
	points[8] = (8521.7715, -5863.3467, 5075.9053);
	angles[8] = (0, 0, -92.0281);
	at[8] = 0.6667;
	points[9] = (8521.7715, -5820.2759, 5046.3779);
	angles[9] = (0, 0, -106.9956);
	at[9] = 0.7500;
	points[10] = (8521.7715, -5777.2441, 5002.0869);
	angles[10] = (0, 0, -121.9630);
	at[10] = 0.8333;
	points[11] = (8521.7715, -5734.1733, 4943.0317);
	angles[11] = (0, 0, -136.9304);
	at[11] = 0.9167;
	points[12] = (8521.7715, -5691.1025, 4869.2129);
	angles[12] = (0, 0, -151.8977);
	at[12] = 1;
	points[13] = (8521.7715, -5648.0317, 4780.6299);
	angles[13] = (0, 0, -166.8652);
	at[13] = 1.0833;
	points[14] = (8521.7715, -5605, 4677.2837);
	angles[14] = (0, 0, -181.8326);
	at[14] = 1.1667;
	points[15] = (8521.7715, -5561.9292, 4559.1733);
	angles[15] = (0, 0, -196.8000);
	at[15] = 1.2500;
	points[16] = (8521.7715, -5518.8584, 4426.2993);
	angles[16] = (0, 0, -211.7674);
	at[16] = 1.3333;
	points[17] = (8521.7715, -5475.7876, 4278.6616);
	angles[17] = (0, 0, -226.7347);
	at[17] = 1.4167;
	points[18] = (8521.7715, -5432.7563, 4116.2598);
	angles[18] = (0, 0, -241.7022);
	at[18] = 1.5000;
	points[19] = (8521.7715, -5389.6851, 3939.0945);
	angles[19] = (0, 0, -256.6695);
	at[19] = 1.5833;
	points[20] = (8521.7715, -5346.6143, 3944.3306);
	angles[20] = (0, 0, -279.8901);
	at[20] = 1.6667;
	points[21] = (8521.7715, -5303.5825, 3979.4883);
	angles[21] = (0, 0, -303.1105);
	at[21] = 1.7500;
	points[22] = (8521.7715, -5260.5122, 3999.8425);
	angles[22] = (0, 0, -326.3309);
	at[22] = 1.8333;
	points[23] = (8521.7715, -5217.4409, 4005.4724);
	angles[23] = (0, 0, -349.5514);
	at[23] = 1.9167;
	points[24] = (8521.7715, -5174.3701, 3996.2991);
	angles[24] = (0, 0, -372.7719);
	at[24] = 2;
	points[25] = (8521.7715, -5131.3384, 3972.4016);
	angles[25] = (0, 0, -395.9923);
	at[25] = 2.0833;
	points[26] = (8521.7715, -5088.2681, 3933.7048);
	angles[26] = (0, 0, -419.2128);
	at[26] = 2.1667;
	points[27] = (8521.7715, -5045.1968, 3880.2561);
	angles[27] = (0, 0, -442.4333);
	at[27] = 2.2500;
	points[28] = (8521.7715, -5002.1260, 3834.0198);
	angles[28] = (0, 0, -467.6681);
	at[28] = 2.3333;
	points[29] = (8521.7715, -4959.0947, 3843.5593);
	angles[29] = (0, 0, -495.9242);
	at[29] = 2.4167;
	points[30] = (8521.7715, -4916.0234, 3838.3308);
	angles[30] = (0, 0, -524.1804);
	at[30] = 2.5000;
	points[31] = (8521.7715, -4872.9531, 3818.3425);
	angles[31] = (0, 0, -552.4366);
	at[31] = 2.5833;
	points[32] = (8521.7715, -4829.9214, 3797.0117);
	angles[32] = (0, 0, -582.6512);
	at[32] = 2.6667;
	points[33] = (8521.7715, -4786.8506, 3796.5117);
	angles[33] = (0, 0, -615.8033);
	at[33] = 2.7500;
	points[34] = (8521.7715, -4743.7793, 3781.2520);
	angles[34] = (0, 0, -648.9553);
	at[34] = 2.8333;
	points[35] = (8521.7715, -4657.6772, 3764.3269);
	angles[35] = (0, 0, -724.3240);
	at[35] = 3;
	points[36] = (8521.7715, -4571.5352, 3747.0354);
	angles[36] = (0, 0, -808.7570);
	at[36] = 3.1667;
	points[37] = (8521.7715, -4485.4331, 3728.6338);
	angles[37] = (0, 0, -903.2614);
	at[37] = 3.3333;
	points[38] = (8521.7715, -4382.8740, 3710.2244);
	angles[38] = (0, 0, -1007.6136);
	at[38] = 3.5000;
	points[39] = (8521.7715, -4332.2441, 3695.4685);
	angles[39] = (0, 0, -1062.7831);
	at[39] = 3.5833;
	points[40] = (8521.7715, -4281.6143, 3691.3425);
	angles[40] = (0, 0, -1120.9741);
	at[40] = 3.6667;
	points[41] = (8521.7715, -4230.9844, 3672.4526);
	angles[41] = (0, 0, -1179.1652);
	at[41] = 3.7500;
	points[42] = (8521.7715, -4180.3545, 3670.5786);
	angles[42] = (0, 0, -1242.3920);
	at[42] = 3.8333;
	points[43] = (8521.7715, -4079.0552, 3646.6104);
	angles[43] = (0, 0, -1371.8669);
	at[43] = 4;
	points[44] = (8521.7715, -4028.4253, 3639.9802);
	angles[44] = (0, 0, -1440.1295);
	at[44] = 4.0833;
	points[45] = (8521.7715, -3977.7954, 3620.4331);
	angles[45] = (0, 0, -1509.3713);
	at[45] = 4.1667;
	points[46] = (8521.7715, -3927.1455, 3619.7639);
	angles[46] = (0, 0, -1582.5297);
	at[46] = 4.2500;
	points[47] = (8521.7715, -3876.5081, 3604.3308);
	angles[47] = (0, 0, -1655.6881);
	at[47] = 4.3333;
	points[48] = (8521.7715, -3825.8701, 3597.0947);
	angles[48] = (0, 0, -1732.8751);
	at[48] = 4.4167;
	points[49] = (8521.7715, -3775.2324, 3587.5513);
	angles[49] = (0, 0, -1811.0693);
	at[49] = 4.5000;
	points[50] = (8521.7715, -3724.5945, 3572.0828);
	angles[50] = (0, 0, -1891.2778);
	at[50] = 4.5833;
	points[51] = (8521.7715, -3673.9565, 3568.4490);
	angles[51] = (0, 0, -1974.5078);
	at[51] = 4.6667;
	points[52] = (8521.7715, -3623.3191, 3550.0552);
	angles[52] = (0, 0, -2057.7378);
	at[52] = 4.7500;
	points[53] = (8521.7715, -3572.6812, 3546.9766);
	angles[53] = (0, 0, -2146.0034);
	at[53] = 4.8333;
	points[54] = (8521.7715, -3471.4055, 3523.1458);
	angles[54] = (0, 0, -2325.4727);
	at[54] = 5;
	points[55] = (8521.7715, -3420.7637, 3516.5552);
	angles[55] = (0, 0, -2418.6340);
	at[55] = 5.0833;
	points[56] = (8521.7715, -3370.1260, 3496.9490);
	angles[56] = (0, 0, -2512.8027);
	at[56] = 5.1667;
	points[57] = (8521.7715, -3319.4883, 3496.2678);
	angles[57] = (0, 0, -2611);
	at[57] = 5.2500;
	points[58] = (8521.7715, -3268.8506, 3480.8230);
	angles[58] = (0, 0, -2709.1975);
	at[58] = 5.3333;
	points[59] = (8521.7715, -3218.2126, 3473.6140);
	angles[59] = (0, 0, -2811.4233);
	at[59] = 5.4167;
	points[60] = (8521.7715, -3167.5747, 3464.0750);
	angles[60] = (0, 0, -2914.6565);
	at[60] = 5.5000;
	points[61] = (8521.7715, -3116.9331, 3448.5984);
	angles[61] = (0, 0, -3019.9041);
	at[61] = 5.5833;
	points[62] = (8521.7715, -3066.2954, 3444.9646);
	angles[62] = (0, 0, -3128.1729);
	at[62] = 5.6667;
	points[63] = (8521.7715, -3015.6577, 3426.5669);
	angles[63] = (0, 0, -3236.4419);
	at[63] = 5.7500;
	points[64] = (8521.7715, -2965.0198, 3423.4961);
	angles[64] = (0, 0, -3349.6064);
	at[64] = 5.8333;
	points[65] = (8521.7715, -2914.3818, 3411);
	angles[65] = (0, 0, -3462.7712);
	at[65] = 5.9167;
	points[66] = (8521.7715, -2863.7441, 3399.6616);
	angles[66] = (0, 0, -3578.9575);
	at[66] = 6;
	points[67] = (8521.7715, -2813.1023, 3393.0747);
	angles[67] = (0, 0, -3697.1580);
	at[67] = 6.0833;
	points[68] = (8521.7715, -2762.4648, 3373.4646);
	angles[68] = (0, 0, -3816.3657);
	at[68] = 6.1667;
	points[69] = (8521.7715, -2711.8269, 3372.7834);
	angles[69] = (0, 0, -3939.6021);
	at[69] = 6.2500;
	points[70] = (8521.7715, -2661.1890, 3357.3386);
	angles[70] = (0, 0, -4062.8384);
	at[70] = 6.3333;
	points[71] = (8521.7715, -2610.5513, 3350.1299);
	angles[71] = (0, 0, -4190.1030);
	at[71] = 6.4167;
	points[72] = (8521.7715, -2559.9133, 3340.5906);
	angles[72] = (0, 0, -4318.3750);
	at[72] = 6.5000;
	points[73] = (8521.7715, -2509.2717, 3325.1182);
	angles[73] = (0, 0, -4448.6055);
	at[73] = 6.5833;
	points[74] = (8521.7715, -2458.6338, 3321.4844);
	angles[74] = (0, 0, -4581.7734);
	at[74] = 6.6667;
	points[75] = (8521.7715, -2407.9961, 3303.0828);
	angles[75] = (0, 0, -4714.9414);
	at[75] = 6.7500;
	points[76] = (8521.7715, -2357.3584, 3300.0117);
	angles[76] = (0, 0, -4853.1450);
	at[76] = 6.8333;
	points[77] = (8521.7715, -2306.7205, 3287.5198);
	angles[77] = (0, 0, -4991.3491);
	at[77] = 6.9167;
	points[78] = (8521.7715, -2256.0828, 3276.1770);
	angles[78] = (0, 0, -5132.5737);
	at[78] = 7;
	points[79] = (8521.7715, -2205.4448, 3269.5906);
	angles[79] = (0, 0, -5275.8135);
	at[79] = 7.0833;
	points[80] = (8521.7715, -2154.8071, 3249.9841);
	angles[80] = (0, 0, -5420.0601);
	at[80] = 7.1667;
	points[81] = (8521.7715, -2104.1694, 3249.2993);
	angles[81] = (0, 0, -5568.3354);
	at[81] = 7.2500;
	points[82] = (8521.7715, -2053.5315, 3233.8545);
	angles[82] = (0, 0, -5716.6104);
	at[82] = 7.3333;
	points[83] = (8521.7715, -2002.8938, 3226.6497);
	angles[83] = (0, 0, -5868.8022);
	at[83] = 7.4167;
	points[84] = (8521.7715, -1952.2559, 3217.1104);
	angles[84] = (0, 0, -6021.9731);
	at[84] = 7.5000;
	points[85] = (8521.7715, -1901.6182, 3201.6340);
	angles[85] = (0, 0, -6177.1587);
	at[85] = 7.5833;
	points[86] = (8521.7715, -1850.9803, 3198);
	angles[86] = (0, 0, -6335.3657);
	at[86] = 7.6667;
	points[87] = (8521.7715, -1800.3425, 3179.6025);
	angles[87] = (0, 0, -6493.5728);
	at[87] = 7.7500;
	points[88] = (8521.7715, -1749.7048, 3176.5276);
	angles[88] = (0, 0, -6656.8149);
	at[88] = 7.8333;
	points[89] = (8521.7715, -1699.0669, 3164.0354);
	angles[89] = (0, 0, -6820.0576);
	at[89] = 7.9167;
	points[90] = (8521.7715, -1648.4291, 3152.6968);
	angles[90] = (0, 0, -6986.3218);
	at[90] = 8;
	points[91] = (8521.7715, -1597.7914, 3146.1104);
	angles[91] = (0, 0, -7154.6001);
	at[91] = 8.0833;
	points[92] = (8521.7715, -1547.1536, 3126.5000);
	angles[92] = (0, 0, -7323.8579);
	at[92] = 8.1667;
	points[93] = (8521.7715, -1496.5159, 3125.8188);
	angles[93] = (0, 0, -7497.0322);
	at[93] = 8.2500;
	points[94] = (8521.7715, -1445.8779, 3110.3740);
	angles[94] = (0, 0, -7670.2061);
	at[94] = 8.3333;
	points[95] = (8521.7715, -1395.2401, 3103.1653);
	angles[95] = (0, 0, -7847.4092);
	at[95] = 8.4167;
	points[96] = (8521.7715, -1344.6024, 3093.6262);
	angles[96] = (0, 0, -8025.6191);
	at[96] = 8.5000;
	points[97] = (8521.7715, -1293.9646, 3078.1536);
	angles[97] = (0, 0, -7845.8438);
	at[97] = 8.5833;
	points[98] = (8521.7715, -1243.3268, 3074.5195);
	angles[98] = (0, 0, -7669.0894);
	at[98] = 8.6667;
	points[99] = (8521.7715, -1192.6890, 3056.1179);
	angles[99] = (0, 0, -7492.3350);
	at[99] = 8.7500;
	points[100] = (8521.7715, -1142.0513, 3053.0474);
	angles[100] = (0, 0, -7320.4766);
	at[100] = 8.8333;
	points[101] = (8521.7715, -1091.4135, 3040.5552);
	angles[101] = (0, 0, -7148.6182);
	at[101] = 8.9167;
	points[102] = (8521.7715, -1040.7756, 3029.2166);
	angles[102] = (0, 0, -6979.7817);
	at[102] = 9;
	points[103] = (8521.7715, -990.1378, 3022.6260);
	angles[103] = (0, 0, -6812.9590);
	at[103] = 9.0833;
	points[104] = (8521.7715, -939.5000, 3003.0198);
	angles[104] = (0, 0, -6647.1436);
	at[104] = 9.1667;
	points[105] = (8521.7715, -888.8622, 3002.3386);
	angles[105] = (0, 0, -6485.3564);
	at[105] = 9.2500;
	points[106] = (8521.7715, -838.2244, 2986.8938);
	angles[106] = (0, 0, -6323.5698);
	at[106] = 9.3333;
	points[107] = (8521.7715, -787.5866, 2979.6851);
	angles[107] = (0, 0, -6165.8115);
	at[107] = 9.4167;
	points[108] = (8521.7715, -736.9489, 2970.1458);
	angles[108] = (0, 0, -6009.0605);
	at[108] = 9.5000;
	points[109] = (8521.7715, -686.3110, 2954.6731);
	angles[109] = (0, 0, -5854.2681);
	at[109] = 9.5833;
	points[110] = (8521.7715, -635.6732, 2951.0354);
	angles[110] = (0, 0, -5702.4126);
	at[110] = 9.6667;
	points[111] = (8521.7715, -585.0355, 2932.6377);
	angles[111] = (0, 0, -5550.5576);
	at[111] = 9.7500;
	points[112] = (8521.7715, -534.3937, 2929.5671);
	angles[112] = (0, 0, -5403.7383);
	at[112] = 9.8333;
	points[113] = (8521.7715, -483.7559, 2917.0747);
	angles[113] = (0, 0, -5256.9189);
	at[113] = 9.9167;
	points[114] = (8521.7715, -433.1181, 2905.7324);
	angles[114] = (0, 0, -5113.1206);
	at[114] = 10;
	points[115] = (8521.7715, -382.4819, 2899.1455);
	angles[115] = (0, 0, -4971.3369);
	at[115] = 10.0833;
	points[116] = (8521.7715, -330.7205, 2879.3110);
	angles[116] = (0, 0, -4830.5605);
	at[116] = 10.1667;
	points[117] = (8521.7715, -279.0512, 2878.6262);
	angles[117] = (0, 0, -4693.8125);
	at[117] = 10.2500;
	points[118] = (8521.7715, -227.3815, 2863.1812);
	angles[118] = (0, 0, -4557.0649);
	at[118] = 10.3333;
	points[119] = (8521.7715, -175.7122, 2860);
	angles[119] = (0, 0, -4426.2197);
	at[119] = 10.4167;
	points[120] = (8521.7715, -124.0429, 2860);
	angles[120] = (0, 0, -4314.4272);
	at[120] = 10.5000;
	points[121] = (8521.7715, -72.3732, 2860);
	angles[121] = (0, 0, -4227.6450);
	at[121] = 10.5833;
	points[122] = (8521.7715, -20.7038, 2860);
	angles[122] = (0, 0, -4165.8462);
	at[122] = 10.6667;
	points[123] = (8521.7715, 30.9657, 2860);
	angles[123] = (0, 0, -4129.0581);
	at[123] = 10.7500;
	points[124] = (8521.7715, 82.6354, 2860);
	angles[124] = (0, 0, -4117.2808);
	at[124] = 10.8333;
	points[125] = (8521.7715, 134.3047, 2860);
	angles[125] = (0, 0, -4130.5151);
	at[125] = 10.9167;
	points[126] = (8521.7715, 185.9744, 2860);
	angles[126] = (0, 0, -4168.7036);
	at[126] = 11;
	points[127] = (8521.7715, 237.6437, 2860);
	angles[127] = (0, 0, -4231.9038);
	at[127] = 11.0833;
	points[128] = (8521.7715, 289.3134, 2860);
	angles[128] = (0, 0, -4320.1143);
	at[128] = 11.1667;
	points[129] = (8521.7715, 340.9831, 2860);
	angles[129] = (0, 0, -4433.3081);
	at[129] = 11.2500;
	points[130] = (8521.7715, 392.6523, 2860);
	angles[130] = (0, 0, -4571.5127);
	at[130] = 11.3333;
	points[131] = (8521.7715, 444.3228, 2860);
	angles[131] = (0, 0, -4734.7285);
	at[131] = 11.4167;
	points[132] = (8521.7715, 495.9921, 2860);
	angles[132] = (0, 0, -4562.9551);
	at[132] = 11.5000;
	points[133] = (8521.7715, 547.6614, 2860);
	angles[133] = (0, 0, -4416.1646);
	at[133] = 11.5833;
	points[134] = (8521.7715, 599.3307, 2860);
	angles[134] = (0, 0, -4294.3853);
	at[134] = 11.6667;
	points[135] = (8521.7715, 651, 2860);
	angles[135] = (0, 0, -4197.6167);
	at[135] = 11.7500;
	points[136] = (8521.7715, 702.6693, 2860);
	angles[136] = (0, 0, -4125.8032);
	at[136] = 11.8333;
	points[137] = (8521.7715, 754.3386, 2860);
	angles[137] = (0, 0, -4079);
	at[137] = 11.9167;
	points[138] = (8521.7715, 806.0079, 2860);
	angles[138] = (0, 0, -4057.2090);
	at[138] = 12;
	points[139] = (8521.7715, 857.6772, 2860);
	angles[139] = (0, 0, -4060.4287);
	at[139] = 12.0833;
	points[140] = (8521.7715, 909.3465, 2860);
	angles[140] = (0, 0, -4088.6309);
	at[140] = 12.1667;
	points[141] = (8521.7715, 961.0157, 2860);
	angles[141] = (0, 0, -4141.8438);
	at[141] = 12.2500;
	points[142] = (8521.7715, 1012.6851, 2860);
	angles[142] = (0, 0, -4220.0684);
	at[142] = 12.3333;
	points[143] = (8521.7715, 1064.3544, 2860);
	angles[143] = (0, 0, -4323.3032);
	at[143] = 12.4167;
	points[144] = (8521.7715, 1116.0237, 2860);
	angles[144] = (0, 0, -4451.4937);
	at[144] = 12.5000;
	points[145] = (8521.7715, 1167.6930, 2860);
	angles[145] = (0, 0, -4604.6943);
	at[145] = 12.5833;
	points[146] = (8521.7715, 1219.3622, 2860);
	angles[146] = (0, 0, -4782.9067);
	at[146] = 12.6667;
	points[147] = (8521.7715, 1271.0315, 2860);
	angles[147] = (0, 0, -4626.1016);
	at[147] = 12.7500;
	points[148] = (8521.7715, 1322.7008, 2860);
	angles[148] = (0, 0, -4494.3076);
	at[148] = 12.8333;
	points[149] = (8521.7715, 1374.3701, 2860);
	angles[149] = (0, 0, -4387.5244);
	at[149] = 12.9167;
	points[150] = (8521.7715, 1426.0394, 2860);
	angles[150] = (0, 0, -4305.7524);
	at[150] = 13;
	points[151] = (8521.7715, 1477.7086, 2860);
	angles[151] = (0, 0, -4248.9634);
	at[151] = 13.0833;
	points[152] = (8521.7715, 1529.3779, 2860);
	angles[152] = (0, 0, -4217.1851);
	at[152] = 13.1667;
	points[153] = (8521.7715, 1581.0472, 2860);
	angles[153] = (0, 0, -4210.3901);
	at[153] = 13.2500;
	points[154] = (8521.7715, 1632.7166, 2860);
	angles[154] = (0, 0, -4228.5776);
	at[154] = 13.3333;
	points[155] = (8521.7715, 1684.3859, 2860);
	angles[155] = (0, 0, -4271.7764);
	at[155] = 13.4167;
	points[156] = (8521.7715, 1736.0551, 2860);
	angles[156] = (0, 0, -4339.9863);
	at[156] = 13.5000;
	points[157] = (8521.7715, 1787.7244, 2860);
	angles[157] = (0, 0, -4433.2065);
	at[157] = 13.5833;
	points[158] = (8521.7715, 1839.3937, 2860);
	angles[158] = (0, 0, -4551.4102);
	at[158] = 13.6667;
	points[159] = (8521.7715, 1891.0631, 2860);
	angles[159] = (0, 0, -4694.6250);
	at[159] = 13.7500;
	points[160] = (8521.7715, 1942.7324, 2860);
	angles[160] = (0, 0, -4862.8501);
	at[160] = 13.8333;
	points[161] = (8521.7715, 1994.4016, 2860);
	angles[161] = (0, 0, -4696.0869);
	at[161] = 13.9167;
	points[162] = (8521.7715, 2046.0709, 2860);
	angles[162] = (0, 0, -4554.2783);
	at[162] = 14;
	points[163] = (8521.7715, 2097.7402, 2860);
	angles[163] = (0, 0, -4437.4805);
	at[163] = 14.0833;
	points[164] = (8521.7715, 2149.4055, 2860);
	angles[164] = (0, 0, -4345.6938);
	at[164] = 14.1667;
	points[165] = (8521.7715, 2185.6025, 2860);
	angles[165] = (0, 0, -4278.8901);
	at[165] = 14.2500;
	points[166] = (8521.7715, 2217.7205, 2860);
	angles[166] = (0, 0, -4237.0977);
	at[166] = 14.3333;
	points[167] = (8521.7715, 2249.8386, 2860);
	angles[167] = (0, 0, -4220.3154);
	at[167] = 14.4167;
	points[168] = (8521.7715, 2281.9568, 2854.6416);
	angles[168] = (0, 0, -4218.5850);
	at[168] = 14.5000;
	points[169] = (8521.7715, 2314.0750, 2834.6536);
	angles[169] = (0, 0, -4216.8550);
	at[169] = 14.5833;
	points[170] = (8521.7715, 2346.1929, 2799.9016);
	angles[170] = (0, 0, -4215.1245);
	at[170] = 14.6667;
	points[171] = (8521.7715, 2378.3110, 2750.3899);
	angles[171] = (0, 0, -4213.3940);
	at[171] = 14.7500;
	points[172] = (8521.7715, 2410.4292, 2686.1104);
	angles[172] = (0, 0, -4211.6636);
	at[172] = 14.8333;
	points[173] = (8521.7715, 2442.5432, 2607.0669);
	angles[173] = (0, 0, -4209.9331);
	at[173] = 14.9167;
	points[174] = (8521.7715, 2474.6614, 2513.2598);
	angles[174] = (0, 0, -4208.2026);
	at[174] = 15;
	points[175] = (8521.7715, 2506.7795, 2404.6929);
	angles[175] = (0, 0, -4206.4722);
	at[175] = 15.0833;
	points[176] = (8521.7715, 2538.8977, 2281.3582);
	angles[176] = (0, 0, -4204.7417);
	at[176] = 15.1667;
	points[177] = (8521.7715, 2571.0159, 2143.2600);
	angles[177] = (0, 0, -4203.0112);
	at[177] = 15.2500;
	points[178] = (8521.7715, 2603.1338, 1990.3976);
	angles[178] = (0, 0, -4201.2808);
	at[178] = 15.3333;
	points[179] = (8521.7715, 2635.2522, 1822.7717);
	angles[179] = (0, 0, -4199.5503);
	at[179] = 15.4167;
	points[180] = (8521.7715, 2667.3701, 1640.3818);
	angles[180] = (0, 0, -4197.8198);
	at[180] = 15.5000;
	points[181] = (8521.7715, 2699.4883, 1443.2284);
	angles[181] = (0, 0, -4196.0894);
	at[181] = 15.5833;
	points[182] = (8521.7715, 2731.6062, 1231.3110);
	angles[182] = (0, 0, -4194.3589);
	at[182] = 15.6667;
	points[183] = (8521.7715, 2763.7244, 1004.6299);
	angles[183] = (0, 0, -4192.6284);
	at[183] = 15.7500;
	points[184] = (8521.7715, 2795.8425, 763.1850);
	angles[184] = (0, 0, -4190.8979);
	at[184] = 15.8333;
	points[185] = (8521.7715, 2827.9607, 506.9764);
	angles[185] = (0, 0, -4189.1675);
	at[185] = 15.9167;
	points[186] = (8521.7715, 2860.0789, 236.0040);
	angles[186] = (0, 0, -4187.4370);
	at[186] = 16;
	points[187] = (8521.7715, 2892.1968, -49.7319);
	angles[187] = (0, 0, -4185.7065);
	at[187] = 16.0833;
	points[188] = (8521.7715, 2924.3110, -350.2319);
	angles[188] = (0, 0, -4183.9761);
	at[188] = 16.1667;
	points[189] = (8521.7715, 2956.4331, -665.4961);
	angles[189] = (0, 0, -4182.2456);
	at[189] = 16.2500;
	points[190] = (8521.7715, 2988.5474, -995.5237);
	angles[190] = (0, 0, -4180.5151);
	at[190] = 16.3333;
	points[191] = (8521.7715, 3020.6653, -1340.3149);
	angles[191] = (0, 0, -4178.7847);
	at[191] = 16.4167;
	points[192] = (8521.7715, 3052.7837, -1699.8701);
	angles[192] = (0, 0, -4177.0542);
	at[192] = 16.5000;
	points[193] = (8521.7715, 3084.9016, -2074.1890);
	angles[193] = (0, 0, -4175.3237);
	at[193] = 16.5833;
	points[194] = (8521.7715, 3117.0198, -2463.2717);
	angles[194] = (0, 0, -4173.5933);
	at[194] = 16.6667;
	points[195] = (8521.7715, 3149.1377, -2867.1143);
	angles[195] = (0, 0, -4171.8628);
	at[195] = 16.7500;
	points[196] = (8521.7715, 3181.2561, -3285.7244);
	angles[196] = (0, 0, -4170.1323);
	at[196] = 16.8333;
	points[197] = (8521.7715, 3213.3740, -3719.0986);
	angles[197] = (0, 0, -4168.4019);
	at[197] = 16.9167;
	points[198] = (8521.7715, 3245.4922, -4167.2441);
	angles[198] = (0, 0, -4166.6714);
	at[198] = 17;
	points[199] = (8521.7715, 3277.6101, -4630.1182);
	angles[199] = (0, 0, -4164.9409);
	at[199] = 17.0833;
	points[200] = (8521.7715, 3309.7285, -5107.7954);
	angles[200] = (0, 0, -4163.2104);
	at[200] = 17.1667;
	points[201] = (8521.7715, 3341.8464, -5600.2363);
	angles[201] = (0, 0, -4161.4800);
	at[201] = 17.2500;
	points[202] = (8521.7715, 3373.9646, -6107.4409);
	angles[202] = (0, 0, -4159.7495);
	at[202] = 17.3333;
	points[203] = (8521.7715, 3406.0828, -6629.3701);
	angles[203] = (0, 0, -4158.0190);
	at[203] = 17.4167;
	points[204] = (8521.7715, 3438.2007, -7166.1025);
	angles[204] = (0, 0, -4156.2886);
	at[204] = 17.5000;
	points[205] = (8521.7715, 3470.3191, -7717.5981);
	angles[205] = (0, 0, -4154.5581);
	at[205] = 17.5833;
	points[206] = (8521.7715, 3502.4331, -8283.8193);
	angles[206] = (0, 0, -4152.8281);
	at[206] = 17.6667;
	points[207] = (8521.7715, 3534.5513, -8864.8428);
	angles[207] = (0, 0, -4151.0977);
	at[207] = 17.7500;
	points[208] = (8521.7715, 3566.6692, -9460.6299);
	angles[208] = (0, 0, -4149.3672);
	at[208] = 17.8333;
	points[209] = (8521.7715, 3598.7876, -10071.1816);
	angles[209] = (0, 0, -4147.6367);
	at[209] = 17.9167;
	points[210] = (8521.7715, 3630.9055, -10696.4570);
	angles[210] = (0, 0, -4145.9062);
	at[210] = 18;
	points[211] = (8521.7715, 3663.0237, -11336.5352);
	angles[211] = (0, 0, -4144.1758);
	at[211] = 18.0833;
	points[212] = (8521.7715, 3695.1416, -11991.3779);
	angles[212] = (0, 0, -4142.4453);
	at[212] = 18.1667;
	points[213] = (8521.7715, 3727.2600, -12660.9453);
	angles[213] = (0, 0, -4140.7148);
	at[213] = 18.2500;
	points[214] = (8521.7715, 3759.3779, -13345.3154);
	angles[214] = (0, 0, -4138.9844);
	at[214] = 18.3333;
	points[215] = (8521.7715, 3772.2244, -13623.1885);
	angles[215] = (0, 0, -3994.2920);
	at[215] = 18.3833;
	points[216] = (8521.7715, -6216.4175, 4741.0630);
	angles[216] = (0, 0, -3994.2920);
	at[216] = 18.3833;
	points[217] = (8521.7715, -6216.4175, 4761.1416);
	angles[217] = (0, 0, -3929.2954);
	at[217] = 18.4167;
	points[218] = (8521.7715, -6207.8350, 4780.6299);
	angles[218] = (0, 0, -3932.2886);
	at[218] = 18.4333;
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
	points[0] = (1225.2795, 1270.7126, 1677.8308);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (1225.2795, 1270.7126, 1677.8308);
	angles[1] = (0, -170, 0);
	at[1] = 0.6000;
	points[2] = (1225.2795, 1270.7126, 1702.2086);
	angles[2] = (0, -170, 0);
	at[2] = 0.6500;
	points[3] = (1225.2795, 1270.7126, 1772.1378);
	angles[3] = (0, -170, 0);
	at[3] = 0.7000;
	points[4] = (1225.2795, 1270.7126, 1837.2441);
	angles[4] = (0, -170, 0);
	at[4] = 0.7500;
	points[5] = (1225.2795, 1270.7126, 1897.5276);
	angles[5] = (0, -170, 0);
	at[5] = 0.8000;
	points[6] = (1225.2795, 1270.7126, 1952.9882);
	angles[6] = (0, -170, 0);
	at[6] = 0.8500;
	points[7] = (1225.2795, 1270.7126, 2003.6261);
	angles[7] = (0, -170, 0);
	at[7] = 0.9000;
	points[8] = (1225.2795, 1270.7126, 2049.4409);
	angles[8] = (0, -170, 0);
	at[8] = 0.9500;
	points[9] = (1225.2795, 1270.7126, 2090.4331);
	angles[9] = (0, -170, 0);
	at[9] = 1;
	points[10] = (1225.2795, 1270.7126, 2126.6025);
	angles[10] = (0, -170, 0);
	at[10] = 1.0500;
	points[11] = (1225.2795, 1270.7126, 2157.9529);
	angles[11] = (0, -170, 0);
	at[11] = 1.1000;
	points[12] = (1225.2795, 1270.7126, 2184.4763);
	angles[12] = (0, -170, 0);
	at[12] = 1.1500;
	points[13] = (1225.2795, 1270.7126, 2206.1772);
	angles[13] = (0, -170, 0);
	at[13] = 1.2000;
	points[14] = (1225.2795, 1270.7126, 2223.0552);
	angles[14] = (0, -170, 0);
	at[14] = 1.2500;
	points[15] = (1225.2795, 1270.7126, 2235.1143);
	angles[15] = (0, -170, 0);
	at[15] = 1.3000;
	points[16] = (1225.2795, 1270.7126, 2242.3464);
	angles[16] = (0, -170, 0);
	at[16] = 1.3500;
	points[17] = (1225.2795, 1270.7126, 2244.7598);
	angles[17] = (0, -170, 0);
	at[17] = 1.4000;
	points[18] = (1225.2795, 1270.7126, 2258.7993);
	angles[18] = (0, -170, 0);
	at[18] = 1.5000;
	points[19] = (1225.2795, 1270.7126, 2258.7993);
	angles[19] = (0, -170, 0);
	at[19] = 1.5500;
	points[20] = (1225.2795, 1270.7126, 2230.7166);
	angles[20] = (0, -170, 0);
	at[20] = 1.7500;
	points[21] = (1225.2795, 1270.7126, 2230.7166);
	angles[21] = (0, -170, 0);
	at[21] = 1.8000;
	points[22] = (1225.2795, 1270.7126, 2236.0786);
	angles[22] = (0, -170, 0);
	at[22] = 1.8500;
	points[23] = (1225.2795, 1270.7126, 2253.4370);
	angles[23] = (0, -170, 0);
	at[23] = 1.9500;
	points[24] = (1225.2795, 1270.7126, 2258.7993);
	angles[24] = (0, -170, 0);
	at[24] = 2;
	points[25] = (1225.2795, 1270.7126, 2258.7993);
	angles[25] = (0, -170, 0);
	at[25] = 2.0500;
	points[26] = (1225.2795, 1270.7126, 2253.4370);
	angles[26] = (0, -170, 0);
	at[26] = 2.1000;
	points[27] = (1225.2795, 1270.7126, 2236.0786);
	angles[27] = (0, -170, 0);
	at[27] = 2.2000;
	points[28] = (1225.2795, 1270.7126, 2230.7166);
	angles[28] = (0, -170, 0);
	at[28] = 2.2500;
	points[29] = (1225.2795, 1270.7126, 2230.7166);
	angles[29] = (0, -170, 0);
	at[29] = 2.3000;
	points[30] = (1225.2795, 1270.7126, 2236.0786);
	angles[30] = (0, -170, 0);
	at[30] = 2.3500;
	points[31] = (1225.2795, 1270.7126, 2253.4370);
	angles[31] = (0, -170, 0);
	at[31] = 2.4500;
	points[32] = (1225.2795, 1270.7126, 2258.7993);
	angles[32] = (0, -170, 0);
	at[32] = 2.5000;
	points[33] = (1225.2795, 1270.7126, 2258.7993);
	angles[33] = (0, -170, 0);
	at[33] = 2.5500;
	points[34] = (1225.2795, 1270.7126, 2253.4370);
	angles[34] = (0, -170, 0);
	at[34] = 2.6000;
	points[35] = (1225.2795, 1270.7126, 2234.5630);
	angles[35] = (0, -170, 0);
	at[35] = 2.7000;
	points[36] = (1225.2795, 1270.7126, 1593.3031);
	angles[36] = (0, -170, 0);
	at[36] = 4.2000;
	points[37] = (1225.2795, 1270.7126, 1589.2480);
	angles[37] = (0, -170, 0);
	at[37] = 4.2500;
	points[38] = (1225.2795, 1270.7126, 1589.2480);
	angles[38] = (0, -170, 0);
	at[38] = 7.3000;
	points[39] = (1225.2795, 1270.7126, 1677.8308);
	angles[39] = (0, -170, 0);
	at[39] = 7.3500;
	points[40] = (1225.2795, 1270.7126, 1677.8308);
	angles[40] = (0, -170, 0);
	at[40] = 9;
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
	points[0] = (3562.0078, 1505.8228, 1961.0669);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (3562.0078, 1505.8228, 1961.0669);
	angles[1] = (0, -170, 0);
	at[1] = 0.6500;
	points[2] = (3562.0078, 1505.8228, 2049.6497);
	angles[2] = (0, -170, 0);
	at[2] = 0.7000;
	points[3] = (3562.0078, 1505.8228, 2049.6497);
	angles[3] = (0, -170, 0);
	at[3] = 2.9500;
	points[4] = (3562.0078, 1505.8228, 2088.2283);
	angles[4] = (0, -170, 0);
	at[4] = 3;
	points[5] = (3562.0078, 1505.8228, 2193.6851);
	angles[5] = (0, -170, 0);
	at[5] = 3.1000;
	points[6] = (3562.0078, 1505.8228, 2283.7087);
	angles[6] = (0, -170, 0);
	at[6] = 3.2000;
	points[7] = (3562.0078, 1505.8228, 2358.2991);
	angles[7] = (0, -170, 0);
	at[7] = 3.3000;
	points[8] = (3562.0078, 1505.8228, 2417.4568);
	angles[8] = (0, -170, 0);
	at[8] = 3.4000;
	points[9] = (3562.0078, 1505.8228, 2461.1812);
	angles[9] = (0, -170, 0);
	at[9] = 3.5000;
	points[10] = (3562.0078, 1505.8228, 2489.4724);
	angles[10] = (0, -170, 0);
	at[10] = 3.6000;
	points[11] = (3562.0078, 1505.8228, 2497.8347);
	angles[11] = (0, -170, 0);
	at[11] = 3.6500;
	points[12] = (3562.0078, 1505.8228, 2517.8740);
	angles[12] = (0, -170, 0);
	at[12] = 3.8500;
	points[13] = (3562.0078, 1505.8228, 2515.9763);
	angles[13] = (0, -170, 0);
	at[13] = 3.9000;
	points[14] = (3562.0078, 1505.8228, 2492.2205);
	angles[14] = (0, -170, 0);
	at[14] = 4.0500;
	points[15] = (3562.0078, 1505.8228, 2488.5078);
	angles[15] = (0, -170, 0);
	at[15] = 4.1000;
	points[16] = (3562.0078, 1505.8228, 2490.4055);
	angles[16] = (0, -170, 0);
	at[16] = 4.1500;
	points[17] = (3562.0078, 1505.8228, 2514.1653);
	angles[17] = (0, -170, 0);
	at[17] = 4.3000;
	points[18] = (3562.0078, 1505.8228, 2517.8740);
	angles[18] = (0, -170, 0);
	at[18] = 4.3500;
	points[19] = (3562.0078, 1505.8228, 2515.9763);
	angles[19] = (0, -170, 0);
	at[19] = 4.4000;
	points[20] = (3562.0078, 1505.8228, 2492.2205);
	angles[20] = (0, -170, 0);
	at[20] = 4.5500;
	points[21] = (3562.0078, 1505.8228, 2488.5078);
	angles[21] = (0, -170, 0);
	at[21] = 4.6000;
	points[22] = (3562.0078, 1505.8228, 2490.4055);
	angles[22] = (0, -170, 0);
	at[22] = 4.6500;
	points[23] = (3562.0078, 1505.8228, 2514.1653);
	angles[23] = (0, -170, 0);
	at[23] = 4.8000;
	points[24] = (3562.0078, 1505.8228, 2517.8740);
	angles[24] = (0, -170, 0);
	at[24] = 4.8500;
	points[25] = (3562.0078, 1505.8228, 2515.9763);
	angles[25] = (0, -170, 0);
	at[25] = 4.9000;
	points[26] = (3562.0078, 1505.8228, 2500.1221);
	angles[26] = (0, -170, 0);
	at[26] = 5;
	points[27] = (3562.0078, 1505.8228, 2488.3386);
	angles[27] = (0, -170, 0);
	at[27] = 5.0500;
	points[28] = (3562.0078, 1505.8228, 1975.6732);
	angles[28] = (0, -170, 0);
	at[28] = 6.5000;
	points[29] = (3562.0078, 1505.8228, 1961.0669);
	angles[29] = (0, -170, 0);
	at[29] = 6.5500;
	points[30] = (3562.0078, 1505.8228, 1961.0669);
	angles[30] = (0, -170, 0);
	at[30] = 9;
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
	points[0] = (-2860.4370, -6714.1338, 2090.0474);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2860.4370, -6714.1338, 2090.0474);
	angles[1] = (0, 0, 0);
	at[1] = 0.7500;
	points[2] = (-2860.4370, -6714.1338, 2107.7441);
	angles[2] = (0, 0, 0);
	at[2] = 0.8000;
	points[3] = (-2860.4370, -6714.1338, 2151.2087);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (-2860.4370, -6714.1338, 2231.3347);
	angles[4] = (0, 0, 0);
	at[4] = 0.9500;
	points[5] = (-2860.4370, -6714.1338, 2267.9961);
	angles[5] = (0, 0, 0);
	at[5] = 1;
	points[6] = (-2860.4370, -6714.1338, 2334.5159);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-2860.4370, -6714.1338, 2391.9646);
	angles[7] = (0, 0, 0);
	at[7] = 1.2000;
	points[8] = (-2860.4370, -6714.1338, 2417.2876);
	angles[8] = (0, 0, 0);
	at[8] = 1.2500;
	points[9] = (-2860.4370, -6714.1338, 2461.1299);
	angles[9] = (0, 0, 0);
	at[9] = 1.3500;
	points[10] = (-2860.4370, -6714.1338, 2479.6497);
	angles[10] = (0, 0, 0);
	at[10] = 1.4000;
	points[11] = (-2860.4370, -6714.1338, 2509.8857);
	angles[11] = (0, 0, 0);
	at[11] = 1.5000;
	points[12] = (-2860.4370, -6714.1338, 2531.0510);
	angles[12] = (0, 0, 0);
	at[12] = 1.6000;
	points[13] = (-2860.4370, -6714.1338, 2543.1458);
	angles[13] = (0, 0, 0);
	at[13] = 1.7000;
	points[14] = (-2860.4370, -6714.1338, 2546.2954);
	angles[14] = (0, 0, 0);
	at[14] = 1.8000;
	points[15] = (-2860.4370, -6714.1338, 2560.3386);
	angles[15] = (0, 0, 0);
	at[15] = 1.9000;
	points[16] = (-2860.4370, -6714.1338, 2560.3386);
	angles[16] = (0, 0, 0);
	at[16] = 1.9500;
	points[17] = (-2860.4370, -6714.1338, 2532.2559);
	angles[17] = (0, 0, 0);
	at[17] = 2.1500;
	points[18] = (-2860.4370, -6714.1338, 2532.2559);
	angles[18] = (0, 0, 0);
	at[18] = 2.2000;
	points[19] = (-2860.4370, -6714.1338, 2537.6182);
	angles[19] = (0, 0, 0);
	at[19] = 2.2500;
	points[20] = (-2860.4370, -6714.1338, 2554.9763);
	angles[20] = (0, 0, 0);
	at[20] = 2.3500;
	points[21] = (-2860.4370, -6714.1338, 2560.3386);
	angles[21] = (0, 0, 0);
	at[21] = 2.4000;
	points[22] = (-2860.4370, -6714.1338, 2560.3386);
	angles[22] = (0, 0, 0);
	at[22] = 2.4500;
	points[23] = (-2860.4370, -6714.1338, 2554.9763);
	angles[23] = (0, 0, 0);
	at[23] = 2.5000;
	points[24] = (-2860.4370, -6714.1338, 2537.6182);
	angles[24] = (0, 0, 0);
	at[24] = 2.6000;
	points[25] = (-2860.4370, -6714.1338, 2532.2559);
	angles[25] = (0, 0, 0);
	at[25] = 2.6500;
	points[26] = (-2860.4370, -6714.1338, 2532.2559);
	angles[26] = (0, 0, 0);
	at[26] = 2.7000;
	points[27] = (-2860.4370, -6714.1338, 2537.6182);
	angles[27] = (0, 0, 0);
	at[27] = 2.7500;
	points[28] = (-2860.4370, -6714.1338, 2554.9763);
	angles[28] = (0, 0, 0);
	at[28] = 2.8500;
	points[29] = (-2860.4370, -6714.1338, 2560.3386);
	angles[29] = (0, 0, 0);
	at[29] = 2.9000;
	points[30] = (-2860.4370, -6714.1338, 2560.3386);
	angles[30] = (0, 0, 0);
	at[30] = 2.9500;
	points[31] = (-2860.4370, -6714.1338, 2554.9763);
	angles[31] = (0, 0, 0);
	at[31] = 3;
	points[32] = (-2860.4370, -6714.1338, 2537.6182);
	angles[32] = (0, 0, 0);
	at[32] = 3.1000;
	points[33] = (-2860.4370, -6714.1338, 2532.2559);
	angles[33] = (0, 0, 0);
	at[33] = 3.1500;
	points[34] = (-2860.4370, -6714.1338, 2532.2559);
	angles[34] = (0, 0, 0);
	at[34] = 3.2000;
	points[35] = (-2860.4370, -6714.1338, 2537.6182);
	angles[35] = (0, 0, 0);
	at[35] = 3.2500;
	points[36] = (-2860.4370, -6714.1338, 2554.9763);
	angles[36] = (0, 0, 0);
	at[36] = 3.3500;
	points[37] = (-2860.4370, -6714.1338, 2560.3386);
	angles[37] = (0, 0, 0);
	at[37] = 3.4000;
	points[38] = (-2860.4370, -6714.1338, 2560.3386);
	angles[38] = (0, 0, 0);
	at[38] = 3.4500;
	points[39] = (-2860.4370, -6714.1338, 2554.9763);
	angles[39] = (0, 0, 0);
	at[39] = 3.5000;
	points[40] = (-2860.4370, -6714.1338, 2537.6182);
	angles[40] = (0, 0, 0);
	at[40] = 3.6000;
	points[41] = (-2860.4370, -6714.1338, 2533.5117);
	angles[41] = (0, 0, 0);
	at[41] = 3.6500;
	points[42] = (-2860.4370, -6714.1338, 2095.0867);
	angles[42] = (0, 0, 0);
	at[42] = 6.5500;
	points[43] = (-2860.4370, -6714.1338, 2090.0474);
	angles[43] = (0, 0, 0);
	at[43] = 6.6000;
	points[44] = (-2860.4370, -6714.1338, 2090.0474);
	angles[44] = (0, 0, 0);
	at[44] = 10.0167;
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
	points[0] = (-3635.0906, -5110.1968, 1889.4370);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3635.0906, -5110.1968, 1889.4370);
	angles[1] = (0, 0, 0);
	at[1] = 3.1500;
	points[2] = (-3635.0906, -5110.1968, 1892.7756);
	angles[2] = (0, 0, 0);
	at[2] = 3.2000;
	points[3] = (-3635.0906, -5110.1968, 2000.4922);
	angles[3] = (0, 0, 0);
	at[3] = 3.3000;
	points[4] = (-3635.0906, -5110.1968, 2050.0984);
	angles[4] = (0, 0, 0);
	at[4] = 3.3500;
	points[5] = (-3635.0906, -5110.1968, 2140.8071);
	angles[5] = (0, 0, 0);
	at[5] = 3.4500;
	points[6] = (-3635.0906, -5110.1968, 2181.9094);
	angles[6] = (0, 0, 0);
	at[6] = 3.5000;
	points[7] = (-3635.0906, -5110.1968, 2255.6104);
	angles[7] = (0, 0, 0);
	at[7] = 3.6000;
	points[8] = (-3635.0906, -5110.1968, 2288.2087);
	angles[8] = (0, 0, 0);
	at[8] = 3.6500;
	points[9] = (-3635.0906, -5110.1968, 2344.9016);
	angles[9] = (0, 0, 0);
	at[9] = 3.7500;
	points[10] = (-3635.0906, -5110.1968, 2368.9961);
	angles[10] = (0, 0, 0);
	at[10] = 3.8000;
	points[11] = (-3635.0906, -5110.1968, 2408.6812);
	angles[11] = (0, 0, 0);
	at[11] = 3.9000;
	points[12] = (-3635.0906, -5110.1968, 2437.0276);
	angles[12] = (0, 0, 0);
	at[12] = 4;
	points[13] = (-3635.0906, -5110.1968, 2454.0354);
	angles[13] = (0, 0, 0);
	at[13] = 4.1000;
	points[14] = (-3635.0906, -5110.1968, 2459.7048);
	angles[14] = (0, 0, 0);
	at[14] = 4.2000;
	points[15] = (-3635.0906, -5110.1968, 2472.4922);
	angles[15] = (0, 0, 0);
	at[15] = 4.3000;
	points[16] = (-3635.0906, -5110.1968, 2474.3857);
	angles[16] = (0, 0, 0);
	at[16] = 4.3500;
	points[17] = (-3635.0906, -5110.1968, 2470.6772);
	angles[17] = (0, 0, 0);
	at[17] = 4.4000;
	points[18] = (-3635.0906, -5110.1968, 2446.9172);
	angles[18] = (0, 0, 0);
	at[18] = 4.5500;
	points[19] = (-3635.0906, -5110.1968, 2445.0198);
	angles[19] = (0, 0, 0);
	at[19] = 4.6000;
	points[20] = (-3635.0906, -5110.1968, 2448.7324);
	angles[20] = (0, 0, 0);
	at[20] = 4.6500;
	points[21] = (-3635.0906, -5110.1968, 2472.4922);
	angles[21] = (0, 0, 0);
	at[21] = 4.8000;
	points[22] = (-3635.0906, -5110.1968, 2474.3857);
	angles[22] = (0, 0, 0);
	at[22] = 4.8500;
	points[23] = (-3635.0906, -5110.1968, 2470.6772);
	angles[23] = (0, 0, 0);
	at[23] = 4.9000;
	points[24] = (-3635.0906, -5110.1968, 2446.9172);
	angles[24] = (0, 0, 0);
	at[24] = 5.0500;
	points[25] = (-3635.0906, -5110.1968, 2445.0198);
	angles[25] = (0, 0, 0);
	at[25] = 5.1000;
	points[26] = (-3635.0906, -5110.1968, 2448.7324);
	angles[26] = (0, 0, 0);
	at[26] = 5.1500;
	points[27] = (-3635.0906, -5110.1968, 2472.4922);
	angles[27] = (0, 0, 0);
	at[27] = 5.3000;
	points[28] = (-3635.0906, -5110.1968, 2474.3857);
	angles[28] = (0, 0, 0);
	at[28] = 5.3500;
	points[29] = (-3635.0906, -5110.1968, 2470.6772);
	angles[29] = (0, 0, 0);
	at[29] = 5.4000;
	points[30] = (-3635.0906, -5110.1968, 2446.9172);
	angles[30] = (0, 0, 0);
	at[30] = 5.5500;
	points[31] = (-3635.0906, -5110.1968, 2445.0198);
	angles[31] = (0, 0, 0);
	at[31] = 5.6000;
	points[32] = (-3635.0906, -5110.1968, 2448.7324);
	angles[32] = (0, 0, 0);
	at[32] = 5.6500;
	points[33] = (-3635.0906, -5110.1968, 2472.4922);
	angles[33] = (0, 0, 0);
	at[33] = 5.8000;
	points[34] = (-3635.0906, -5110.1968, 2474.3857);
	angles[34] = (0, 0, 0);
	at[34] = 5.8500;
	points[35] = (-3635.0906, -5110.1968, 2470.6772);
	angles[35] = (0, 0, 0);
	at[35] = 5.9000;
	points[36] = (-3635.0906, -5110.1968, 2440.6182);
	angles[36] = (0, 0, 0);
	at[36] = 6.1000;
	points[37] = (-3635.0906, -5110.1968, 1892.5867);
	angles[37] = (0, 0, 0);
	at[37] = 9;
	points[38] = (-3635.0906, -5110.1968, 1889.4370);
	angles[38] = (0, 0, 0);
	at[38] = 9.0500;
	points[39] = (-3635.0906, -5110.1968, 1889.4370);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-3792.3621, -8161.8896, 2054.1929);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3792.3621, -8161.8896, 2054.1929);
	angles[1] = (0, 0, 0);
	at[1] = 3.1500;
	points[2] = (-3792.3621, -8161.8896, 2057.5276);
	angles[2] = (0, 0, 0);
	at[2] = 3.2000;
	points[3] = (-3792.3621, -8161.8896, 2165.2441);
	angles[3] = (0, 0, 0);
	at[3] = 3.3000;
	points[4] = (-3792.3621, -8161.8896, 2261.6221);
	angles[4] = (0, 0, 0);
	at[4] = 3.4000;
	points[5] = (-3792.3621, -8161.8896, 2305.5591);
	angles[5] = (0, 0, 0);
	at[5] = 3.4500;
	points[6] = (-3792.3621, -8161.8896, 2346.6616);
	angles[6] = (0, 0, 0);
	at[6] = 3.5000;
	points[7] = (-3792.3621, -8161.8896, 2420.3623);
	angles[7] = (0, 0, 0);
	at[7] = 3.6000;
	points[8] = (-3792.3621, -8161.8896, 2452.9607);
	angles[8] = (0, 0, 0);
	at[8] = 3.6500;
	points[9] = (-3792.3621, -8161.8896, 2509.6536);
	angles[9] = (0, 0, 0);
	at[9] = 3.7500;
	points[10] = (-3792.3621, -8161.8896, 2555.0081);
	angles[10] = (0, 0, 0);
	at[10] = 3.8500;
	points[11] = (-3792.3621, -8161.8896, 2573.4329);
	angles[11] = (0, 0, 0);
	at[11] = 3.9000;
	points[12] = (-3792.3621, -8161.8896, 2601.7795);
	angles[12] = (0, 0, 0);
	at[12] = 4;
	points[13] = (-3792.3621, -8161.8896, 2618.7874);
	angles[13] = (0, 0, 0);
	at[13] = 4.1000;
	points[14] = (-3792.3621, -8161.8896, 2624.4568);
	angles[14] = (0, 0, 0);
	at[14] = 4.2000;
	points[15] = (-3792.3621, -8161.8896, 2637.2441);
	angles[15] = (0, 0, 0);
	at[15] = 4.3000;
	points[16] = (-3792.3621, -8161.8896, 2639.1418);
	angles[16] = (0, 0, 0);
	at[16] = 4.3500;
	points[17] = (-3792.3621, -8161.8896, 2635.4292);
	angles[17] = (0, 0, 0);
	at[17] = 4.4000;
	points[18] = (-3792.3621, -8161.8896, 2611.6733);
	angles[18] = (0, 0, 0);
	at[18] = 4.5500;
	points[19] = (-3792.3621, -8161.8896, 2609.7756);
	angles[19] = (0, 0, 0);
	at[19] = 4.6000;
	points[20] = (-3792.3621, -8161.8896, 2613.4844);
	angles[20] = (0, 0, 0);
	at[20] = 4.6500;
	points[21] = (-3792.3621, -8161.8896, 2637.2441);
	angles[21] = (0, 0, 0);
	at[21] = 4.8000;
	points[22] = (-3792.3621, -8161.8896, 2639.1418);
	angles[22] = (0, 0, 0);
	at[22] = 4.8500;
	points[23] = (-3792.3621, -8161.8896, 2635.4292);
	angles[23] = (0, 0, 0);
	at[23] = 4.9000;
	points[24] = (-3792.3621, -8161.8896, 2611.6733);
	angles[24] = (0, 0, 0);
	at[24] = 5.0500;
	points[25] = (-3792.3621, -8161.8896, 2609.7756);
	angles[25] = (0, 0, 0);
	at[25] = 5.1000;
	points[26] = (-3792.3621, -8161.8896, 2613.4844);
	angles[26] = (0, 0, 0);
	at[26] = 5.1500;
	points[27] = (-3792.3621, -8161.8896, 2637.2441);
	angles[27] = (0, 0, 0);
	at[27] = 5.3000;
	points[28] = (-3792.3621, -8161.8896, 2639.1418);
	angles[28] = (0, 0, 0);
	at[28] = 5.3500;
	points[29] = (-3792.3621, -8161.8896, 2635.4292);
	angles[29] = (0, 0, 0);
	at[29] = 5.4000;
	points[30] = (-3792.3621, -8161.8896, 2611.6733);
	angles[30] = (0, 0, 0);
	at[30] = 5.5500;
	points[31] = (-3792.3621, -8161.8896, 2609.7756);
	angles[31] = (0, 0, 0);
	at[31] = 5.6000;
	points[32] = (-3792.3621, -8161.8896, 2613.4844);
	angles[32] = (0, 0, 0);
	at[32] = 5.6500;
	points[33] = (-3792.3621, -8161.8896, 2637.2441);
	angles[33] = (0, 0, 0);
	at[33] = 5.8000;
	points[34] = (-3792.3621, -8161.8896, 2639.1418);
	angles[34] = (0, 0, 0);
	at[34] = 5.8500;
	points[35] = (-3792.3621, -8161.8896, 2635.4292);
	angles[35] = (0, 0, 0);
	at[35] = 5.9000;
	points[36] = (-3792.3621, -8161.8896, 2605.3740);
	angles[36] = (0, 0, 0);
	at[36] = 6.1000;
	points[37] = (-3792.3621, -8161.8896, 2057.3425);
	angles[37] = (0, 0, 0);
	at[37] = 9;
	points[38] = (-3792.3621, -8161.8896, 2054.1929);
	angles[38] = (0, 0, 0);
	at[38] = 9.0500;
	points[39] = (-3792.3621, -8161.8896, 2054.1929);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_12", "targetname");
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
