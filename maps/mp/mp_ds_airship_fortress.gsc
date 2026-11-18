main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_airship_fortress", 0);

	setExpFog(16240.1572, 20700.0488, 0.8863, 0.3529, 0.3529, 0);

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
	ambientPlay("iz_0_83", 2);
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
	level.iz_route[level.iz_route.size] = (-2711, 3844, 2604);
	level.iz_route[level.iz_route.size] = (-2685, 3074, 2307);
	level.iz_route[level.iz_route.size] = (-2683, 318, 2307);
	level.iz_route[level.iz_route.size] = (-2687, -1382, 2307);
	level.iz_route[level.iz_route.size] = (-2669, -3339, 2158);
	level.iz_route[level.iz_route.size] = (-2666, -4489, 2158);
	level.iz_route[level.iz_route.size] = (-2561, -5070, 2158);
	level.iz_route[level.iz_route.size] = (-2178, -5241, 2158);
	level.iz_route[level.iz_route.size] = (-1626, -5306, 2166);
	level.iz_route[level.iz_route.size] = (-1033, -5285, 2282);
	level.iz_route[level.iz_route.size] = (-408, -5277, 2404);
	level.iz_route[level.iz_route.size] = (150, -5354, 2493);
	level.iz_route[level.iz_route.size] = (535, -5581, 2555);
	level.iz_route[level.iz_route.size] = (816, -6106, 2630);
	level.iz_route[level.iz_route.size] = (855, -6817, 2707);
	level.iz_route[level.iz_route.size] = (855, -7646, 2807);
	level.iz_route[level.iz_route.size] = (831, -8924, 2752);
	level.iz_route[level.iz_route.size] = (816, -10347, 2752);
	level.iz_route[level.iz_route.size] = (815, -11988, 2753);
	level.iz_route[level.iz_route.size] = (363, -12483, 2753);
	level.iz_route[level.iz_route.size] = (-287, -12716, 2753);
	level.iz_route[level.iz_route.size] = (-1100, -12732, 2753);
	level.iz_route[level.iz_route.size] = (-1718, -12745, 2753);
	level.iz_route[level.iz_route.size] = (-2292, -12577, 2753);
	level.iz_route[level.iz_route.size] = (-2802, -12160, 2753);
	level.iz_route[level.iz_route.size] = (-3055, -11118, 2753);
	level.iz_route[level.iz_route.size] = (-3077, -10502, 2753);
	level.iz_route[level.iz_route.size] = (-3185, -9962, 2753);
	level.iz_route[level.iz_route.size] = (-3531, -9555, 2753);
	level.iz_route[level.iz_route.size] = (-4135, -9392, 2753);
	level.iz_route[level.iz_route.size] = (-5435, -9401, 2718);
	level.iz_route[level.iz_route.size] = (-6742, -9406, 2486);
	level.iz_route[level.iz_route.size] = (-7635, -9414, 2316);
	level.iz_route[level.iz_route.size] = (-8199, -9539, 2324);
	level.iz_route[level.iz_route.size] = (-8383, -10008, 2339);
	level.iz_route[level.iz_route.size] = (-8380, -10679, 2348);
	level.iz_route[level.iz_route.size] = (-8285, -11111, 2377);
	level.iz_route[level.iz_route.size] = (-7748, -11288, 2334);
	level.iz_route[level.iz_route.size] = (-7055, -11318, 2228);
	level.iz_route[level.iz_route.size] = (-6079, -11326, 2071);
	level.iz_route[level.iz_route.size] = (-4677, -11337, 1860);
	level.iz_route[level.iz_route.size] = (-3123, -11225, 1860);
	level.iz_route[level.iz_route.size] = (-1856, -11155, 1860);
	level.iz_route[level.iz_route.size] = (-500, -11140, 1860);
	level.iz_route[level.iz_route.size] = (872, -11126, 1860);
	level.iz_route[level.iz_route.size] = (2480, -11116, 1860);
	level.iz_route[level.iz_route.size] = (3905, -11072, 1971);
	level.iz_route[level.iz_route.size] = (4581, -11011, 1999);
	level.iz_route[level.iz_route.size] = (4934, -10794, 2018);
	level.iz_route[level.iz_route.size] = (5066, -10276, 2039);
	level.iz_route[level.iz_route.size] = (5077, -9507, 2075);
	level.iz_route[level.iz_route.size] = (5095, -8784, 2262);
	level.iz_route[level.iz_route.size] = (6165, 7764, 4391);
	level.iz_route[level.iz_route.size] = (6339, 8429, 4357);
	level.iz_route[level.iz_route.size] = (6472, 9090, 4348);
	level.iz_route[level.iz_route.size] = (6415, 9585, 4343);
	level.iz_route[level.iz_route.size] = (6262, 9844, 4329);
	level.iz_route[level.iz_route.size] = (6007, 10127, 4296);
	level.iz_route[level.iz_route.size] = (5649, 10265, 4294);
	level.iz_route[level.iz_route.size] = (5328, 10313, 4267);
	level.iz_route[level.iz_route.size] = (4949, 10198, 4238);
	level.iz_route[level.iz_route.size] = (4655, 10057, 4202);
	level.iz_route[level.iz_route.size] = (4462, 9815, 4159);
	level.iz_route[level.iz_route.size] = (4299, 9462, 4086);
	level.iz_route[level.iz_route.size] = (4233, 9146, 4018);
	level.iz_route[level.iz_route.size] = (4251, 8783, 3942);
	level.iz_route[level.iz_route.size] = (4375, 8512, 3870);
	level.iz_route[level.iz_route.size] = (4562, 8230, 3796);
	level.iz_route[level.iz_route.size] = (4889, 7955, 3713);
	level.iz_route[level.iz_route.size] = (5333, 7930, 3621);
	level.iz_route[level.iz_route.size] = (5768, 8039, 3541);
	level.iz_route[level.iz_route.size] = (6175, 8395, 3426);
	level.iz_route[level.iz_route.size] = (6389, 8966, 3300);
	level.iz_route[level.iz_route.size] = (6420, 9546, 3193);
	level.iz_route[level.iz_route.size] = (6078, 10075, 3052);
	level.iz_route[level.iz_route.size] = (5550, 10378, 2977);
	level.iz_route[level.iz_route.size] = (4789, 10175, 2830);
	level.iz_route[level.iz_route.size] = (4268, 9811, 2759);
	level.iz_route[level.iz_route.size] = (3796, 9299, 2697);
	level.iz_route[level.iz_route.size] = (3587, 9031, 2664);
	level.iz_route[level.iz_route.size] = (3283, 8809, 2635);
	level.iz_route[level.iz_route.size] = (3027, 8700, 2611);
	level.iz_route[level.iz_route.size] = (2633, 8612, 2604);
	level.iz_route[level.iz_route.size] = (1465, 8736, 2604);
	level.iz_route[level.iz_route.size] = (-49, 8808, 2604);
	level.iz_route[level.iz_route.size] = (-1405, 8779, 2604);
	level.iz_route[level.iz_route.size] = (-2134, 8615, 2604);
	level.iz_route[level.iz_route.size] = (-2566, 8275, 2604);
	level.iz_route[level.iz_route.size] = (-2665, 7649, 2604);
	level.iz_route[level.iz_route.size] = (-2680, 7012, 2604);
	level.iz_route[level.iz_route.size] = (-2684, 5580, 2604);
	level.iz_route[level.iz_route.size] = (-2684, 4916, 2604);
	level.iz_route[level.iz_route.size] = (-2683, 4804, 2604);
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
	thread iz_obj_20();
	thread iz_obj_21();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2148.6614, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2148.6614, -8279.6455, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.0833;
	points[2] = (-2148.6614, -8139.3306, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.1667;
	points[3] = (-2148.6614, -7992.0864, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-2148.6614, -7838.2285, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 0.3333;
	points[5] = (-2148.6614, -7678.1494, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 0.4167;
	points[6] = (-2148.6614, -7396.0630, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 0.5833;
	points[7] = (-2148.6614, -7249.4878, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 0.6667;
	points[8] = (-2148.6614, -6793.7793, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 0.9167;
	points[9] = (-2148.6614, -6650.8267, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 1;
	points[10] = (-2148.6614, -6358.6611, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.1667;
	points[11] = (-2148.6614, -5906.9688, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 1.4167;
	points[12] = (-2148.6614, -5319.9604, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-2148.6614, -4872.9136, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 2;
	points[14] = (-2148.6614, -3838.6299, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 2.5833;
	points[15] = (-2148.6614, -3390.8860, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 2.8333;
	points[16] = (-2148.6614, -2952.1455, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 3.0833;
	points[17] = (-2148.6614, -2500.4529, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 3.3333;
	points[18] = (-2148.6614, -1916.5197, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 3.6667;
	points[19] = (-2148.6614, -1609.6339, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 3.8333;
	points[20] = (-2148.6614, -1462.0787, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 3.9167;
	points[21] = (-2148.6614, -1318.7598, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 4;
	points[22] = (-2148.6614, -1179.9213, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 4.0833;
	points[23] = (-2148.6614, -866.9134, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 4.2500;
	points[24] = (-2148.6614, -719.3583, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 4.3333;
	points[25] = (-2148.6614, -580.0551, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 4.4167;
	points[26] = (-2148.6614, -435.8898, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 4.5000;
	points[27] = (-2148.6614, -271.8087, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 4.5833;
	points[28] = (-2148.6614, -126.3476, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 4.6667;
	points[29] = (-2148.6614, -0.6394, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 4.7500;
	points[30] = (-2148.6614, 142.6846, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 4.8333;
	points[31] = (-2148.6614, 440.8268, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 5;
	points[32] = (-2148.6614, 586.5039, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 5.0833;
	points[33] = (-2148.6614, 2954.2126, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 6.4167;
	points[34] = (-2148.6614, 3099.6692, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 6.5000;
	points[35] = (-2148.6614, 3250.4058, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 6.5833;
	points[36] = (-2148.6614, 3543.3662, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 6.7500;
	points[37] = (-2148.6614, 3694.7639, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 6.8333;
	points[38] = (-2148.6614, 4138.4253, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 7.0833;
	points[39] = (-2148.6614, 4223.5825, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 7.1667;
	points[40] = (-2148.6614, 4223.5825, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 7.3500;
	points[41] = (-2148.6614, -8386.6533, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 7.3500;
	points[42] = (-2148.6614, -8386.6533, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 16.8000;
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
	points[0] = (-2148.6614, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2148.6614, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 5.5833;
	points[2] = (-2148.6614, -8306.8506, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 5.6667;
	points[3] = (-2148.6614, -8167.9922, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 5.7500;
	points[4] = (-2148.6614, -8022.0869, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 5.8333;
	points[5] = (-2148.6614, -7869.5278, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 5.9167;
	points[6] = (-2148.6614, -7710.6694, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 6;
	points[7] = (-2148.6614, -7424.9214, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 6.1667;
	points[8] = (-2148.6614, -7279.0947, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 6.2500;
	points[9] = (-2148.6614, -7129.6851, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 6.3333;
	points[10] = (-2148.6614, -6822.0869, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 6.5000;
	points[11] = (-2148.6614, -6679.6064, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 6.5833;
	points[12] = (-2148.6614, -6388.2285, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 6.7500;
	points[13] = (-2148.6614, -5937.5200, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 7;
	points[14] = (-2148.6614, -5349.6064, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 7.3333;
	points[15] = (-2148.6614, -4902.5591, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 7.5833;
	points[16] = (-2148.6614, -3868.7087, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 8.1667;
	points[17] = (-2148.6614, -3420.4961, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 8.4167;
	points[18] = (-2148.6614, -2833.1062, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 8.7500;
	points[19] = (-2148.6614, -2530.3032, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 8.9167;
	points[20] = (-2148.6614, -2381.9175, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 9;
	points[21] = (-2148.6614, -1948.0157, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 9.2500;
	points[22] = (-2148.6614, -1639.6339, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 9.4167;
	points[23] = (-2148.6614, -1491.2559, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 9.5000;
	points[24] = (-2148.6614, -1347.0708, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 9.5833;
	points[25] = (-2148.6614, -1207.3188, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 9.6667;
	points[26] = (-2148.6614, -897.3779, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 9.8333;
	points[27] = (-2148.6614, -748.2244, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 9.9167;
	points[28] = (-2148.6614, -607.2363, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 10;
	points[29] = (-2148.6614, -470.8425, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 10.0833;
	points[30] = (-2148.6614, -303.1717, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 10.1667;
	points[31] = (-2148.6614, -153.8957, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 10.2500;
	points[32] = (-2148.6614, -24.1467, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 10.3333;
	points[33] = (-2148.6614, 113.5760, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 10.4167;
	points[34] = (-2148.6614, 412.1024, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 10.5833;
	points[35] = (-2148.6614, 557.1024, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 10.6667;
	points[36] = (-2148.6614, 854.9173, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 10.8333;
	points[37] = (-2148.6614, 3070.7798, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 12.0833;
	points[38] = (-2148.6614, 3368.7520, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 12.2500;
	points[39] = (-2148.6614, 3513.3071, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 12.3333;
	points[40] = (-2148.6614, 3664.9055, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 12.4167;
	points[41] = (-2148.6614, 3958.5825, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 12.5833;
	points[42] = (-2148.6614, 4109.3306, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 12.6667;
	points[43] = (-2148.6614, 4223.5825, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 12.7500;
	points[44] = (-2148.6614, 4223.5825, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 12.9500;
	points[45] = (-2148.6614, -8386.6533, 2352.7559);
	angles[45] = (0, 0, 0);
	at[45] = 12.9500;
	points[46] = (-2148.6614, -8386.6533, 2352.7559);
	angles[46] = (0, 0, 0);
	at[46] = 16.8000;
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
	points[0] = (-2148.6614, 1504.1260, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2148.6614, 3129.8857, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.9167;
	points[2] = (-2148.6614, 3724.4016, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 1.2500;
	points[3] = (-2148.6614, 3869.1655, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 1.3333;
	points[4] = (-2148.6614, 4167.1655, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 1.5000;
	points[5] = (-2148.6614, 4223.5825, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 1.5833;
	points[6] = (-2148.6614, 4223.5825, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 1.7500;
	points[7] = (-2148.6614, -8386.6533, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 1.7500;
	points[8] = (-2148.6614, -8386.6533, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 11.1667;
	points[9] = (-2148.6614, -8333.7793, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 11.2500;
	points[10] = (-2148.6614, -8196.3389, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 11.3333;
	points[11] = (-2148.6614, -8051.8115, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 11.4167;
	points[12] = (-2148.6614, -7900.5513, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 11.5000;
	points[13] = (-2148.6614, -7742.9136, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 11.5833;
	points[14] = (-2148.6614, -7595, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 11.6667;
	points[15] = (-2148.6614, -7308.5430, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 11.8333;
	points[16] = (-2148.6614, -7159.8428, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 11.9167;
	points[17] = (-2148.6614, -6852.5200, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 12.0833;
	points[18] = (-2148.6614, -6417.7163, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 12.3333;
	points[19] = (-2148.6614, -5819.1338, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 12.6667;
	points[20] = (-2148.6614, -5379.2129, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 12.9167;
	points[21] = (-2148.6614, -4784.3311, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 13.2500;
	points[22] = (-2148.6614, -3898.3740, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 13.7500;
	points[23] = (-2148.6614, -3302.2993, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 14.0833;
	points[24] = (-2148.6614, -2863.7874, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 14.3333;
	points[25] = (-2148.6614, -2560.2322, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 14.5000;
	points[26] = (-2148.6614, -2411.4211, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 14.5833;
	points[27] = (-2148.6614, -2120.5630, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 14.7500;
	points[28] = (-2148.6614, -1978.8464, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 14.8333;
	points[29] = (-2148.6614, -1669.7914, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 15;
	points[30] = (-2148.6614, -1520.6023, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 15.0833;
	points[31] = (-2148.6614, -1375.5630, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 15.1667;
	points[32] = (-2148.6614, -1234.9055, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 15.2500;
	points[33] = (-2148.6614, -1086.5394, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 15.3333;
	points[34] = (-2148.6614, -928.1497, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 15.4167;
	points[35] = (-2148.6614, -777.4134, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 15.5000;
	points[36] = (-2148.6614, -634.7598, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 15.5833;
	points[37] = (-2148.6614, -500.6102, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 15.6667;
	points[38] = (-2148.6614, -335.2705, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 15.7500;
	points[39] = (-2148.6614, -182.2248, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 15.8333;
	points[40] = (-2148.6614, 84.6713, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 16;
	points[41] = (-2148.6614, 231.1976, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 16.0833;
	points[42] = (-2148.6614, 382.4508, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 16.1667;
	points[43] = (-2148.6614, 527.8347, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 16.2500;
	points[44] = (-2148.6614, 825.9449, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 16.4167;
	points[45] = (-2148.6614, 1504.1260, 2352.7559);
	angles[45] = (0, 0, 0);
	at[45] = 16.8000;
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
	points[0] = (-2347.7480, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2347.7480, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 1.6000;
	points[2] = (-2347.7480, -8335.9053, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 1.7000;
	points[3] = (-2347.7480, -8177.0864, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 1.8000;
	points[4] = (-2347.7480, -8008.8975, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 1.9000;
	points[5] = (-2347.7480, -7651.5356, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 2.1000;
	points[6] = (-2347.7480, -7490.2363, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 2.2000;
	points[7] = (-2347.7480, -7323.8188, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 2.3000;
	points[8] = (-2347.7480, -7152.5981, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 2.4000;
	points[9] = (-2347.7480, -6800.5908, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 2.6000;
	points[10] = (-2347.7480, -6635.8662, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 2.7000;
	points[11] = (-2347.7480, -6298.1104, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 2.9000;
	points[12] = (-2347.7480, -5950.9453, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 3.1000;
	points[13] = (-2347.7480, -5443.0708, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 3.4000;
	points[14] = (-2347.7480, -4928.8979, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 3.7000;
	points[15] = (-2347.7480, -3907.7834, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 4.3000;
	points[16] = (-2347.7480, -3392.0786, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 4.6000;
	points[17] = (-2347.7480, -2887.1692, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 4.9000;
	points[18] = (-2347.7480, -2537.4922, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 5.1000;
	points[19] = (-2347.7480, -2366.6260, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-2347.7480, -2034.1064, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 5.4000;
	points[21] = (-2347.7480, -1683.1299, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 5.6000;
	points[22] = (-2347.7480, -1511.2126, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 5.7000;
	points[23] = (-2347.7480, -1344.8190, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 5.8000;
	points[24] = (-2347.7480, -1184.3110, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 5.9000;
	points[25] = (-2347.7480, -826.0079, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 6.1000;
	points[26] = (-2347.7480, -659.2834, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 6.2000;
	points[27] = (-2347.7480, -503.7480, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 6.3000;
	points[28] = (-2347.7480, -314.6693, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 6.4000;
	points[29] = (-2347.7480, -142.8059, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 6.5000;
	points[30] = (-2347.7480, 3.7032, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 6.6000;
	points[31] = (-2347.7480, 169.6158, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 6.7000;
	points[32] = (-2347.7480, 853.7283, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 7.1000;
	points[33] = (-2347.7480, 3066.1260, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 8.4000;
	points[34] = (-2347.7480, 3750.2759, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 8.8000;
	points[35] = (-2347.7480, 3916.1418, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 8.9000;
	points[36] = (-2347.7480, 4091.6536, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 9;
	points[37] = (-2347.7480, 4202.2837, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 9.1000;
	points[38] = (-2347.7480, 4202.2837, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 9.2833;
	points[39] = (-2347.7480, -8386.6533, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 9.2833;
	points[40] = (-2347.7480, -8386.6533, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 20.2500;
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
	points[0] = (-2347.7480, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2347.7480, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 8.4000;
	points[2] = (-2347.7480, -8257.6768, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 8.5000;
	points[3] = (-2347.7480, -8094.1343, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 8.6000;
	points[4] = (-2347.7480, -7921.4961, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 8.7000;
	points[5] = (-2347.7480, -7740.3545, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 8.8000;
	points[6] = (-2347.7480, -7238.7798, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 9.1000;
	points[7] = (-2347.7480, -7065.3149, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 9.2000;
	points[8] = (-2347.7480, -6887.5591, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 9.3000;
	points[9] = (-2347.7480, -6383.5044, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 9.6000;
	points[10] = (-2347.7480, -5864.3701, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 9.9000;
	points[11] = (-2347.7480, -5357.9136, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 10.2000;
	points[12] = (-2347.7480, -4843.3862, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 10.5000;
	points[13] = (-2347.7480, -3821.8032, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 11.1000;
	points[14] = (-2347.7480, -3477.4646, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 11.3000;
	points[15] = (-2347.7480, -2970.6458, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 11.6000;
	points[16] = (-2347.7480, -2451.7009, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 11.9000;
	points[17] = (-2347.7480, -2282.2993, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 12;
	points[18] = (-2347.7480, -1950.5591, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 12.2000;
	points[19] = (-2347.7480, -1771.0433, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 12.3000;
	points[20] = (-2347.7480, -1596.5040, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 12.4000;
	points[21] = (-2347.7480, -1427.3032, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 12.5000;
	points[22] = (-2347.7480, -1263.8071, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 12.6000;
	points[23] = (-2347.7480, -1095.6497, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 12.7000;
	points[24] = (-2347.7480, -913.3661, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 12.8000;
	points[25] = (-2347.7480, -741.2874, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 12.9000;
	points[26] = (-2347.7480, -580.0748, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 13;
	points[27] = (-2347.7480, -409.8228, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 13.1000;
	points[28] = (-2347.7480, -225.5913, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 13.2000;
	points[29] = (-2347.7480, -66.5287, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 13.3000;
	points[30] = (-2347.7480, 85.7980, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 13.4000;
	points[31] = (-2347.7480, 3324.0276, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 15.3000;
	points[32] = (-2347.7480, 3491.5669, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 15.4000;
	points[33] = (-2347.7480, 3664.8818, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 15.5000;
	points[34] = (-2347.7480, 4175.1182, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 15.8000;
	points[35] = (-2347.7480, 4202.2837, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 15.9000;
	points[36] = (-2347.7480, 4202.2837, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 16.0333;
	points[37] = (-2347.7480, -8386.6533, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 16.0333;
	points[38] = (-2347.7480, -8386.6533, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 20.2500;
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
	points[0] = (-2347.7480, 255.0661, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2347.7480, 428.1457, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (-2347.7480, 595.9094, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (-2347.7480, 4175.1182, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 2.3000;
	points[4] = (-2347.7480, 4202.2837, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 2.4000;
	points[5] = (-2347.7480, 4202.2837, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 2.5333;
	points[6] = (-2347.7480, -8386.6533, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 2.5333;
	points[7] = (-2347.7480, -8386.6533, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 15.1000;
	points[8] = (-2347.7480, -8335.9053, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 15.2000;
	points[9] = (-2347.7480, -8177.0864, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 15.3000;
	points[10] = (-2347.7480, -8008.8975, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 15.4000;
	points[11] = (-2347.7480, -7651.5356, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 15.6000;
	points[12] = (-2347.7480, -7490.2363, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 15.7000;
	points[13] = (-2347.7480, -7323.8188, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 15.8000;
	points[14] = (-2347.7480, -7152.5981, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 15.9000;
	points[15] = (-2347.7480, -6800.5908, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 16.1000;
	points[16] = (-2347.7480, -6635.8662, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 16.2000;
	points[17] = (-2347.7480, -6298.1104, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 16.4000;
	points[18] = (-2347.7480, -5950.9453, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 16.6000;
	points[19] = (-2347.7480, -5443.0708, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 16.9000;
	points[20] = (-2347.7480, -4928.8979, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 17.2000;
	points[21] = (-2347.7480, -3907.7834, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 17.8000;
	points[22] = (-2347.7480, -3392.0786, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 18.1000;
	points[23] = (-2347.7480, -2887.1692, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 18.4000;
	points[24] = (-2347.7480, -2537.4922, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 18.6000;
	points[25] = (-2347.7480, -2366.6260, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 18.7000;
	points[26] = (-2347.7480, -2034.1064, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 18.9000;
	points[27] = (-2347.7480, -1683.1299, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 19.1000;
	points[28] = (-2347.7480, -1511.2126, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 19.2000;
	points[29] = (-2347.7480, -1344.8190, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 19.3000;
	points[30] = (-2347.7480, -1184.3110, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 19.4000;
	points[31] = (-2347.7480, -826.0079, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 19.6000;
	points[32] = (-2347.7480, -659.2834, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 19.7000;
	points[33] = (-2347.7480, -503.7480, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 19.8000;
	points[34] = (-2347.7480, -314.6693, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 19.9000;
	points[35] = (-2347.7480, -142.8059, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 20;
	points[36] = (-2347.7480, 3.7032, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 20.1000;
	points[37] = (-2347.7480, 255.0661, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 20.2500;
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
	points[0] = (-2546.8308, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2546.8308, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 3.3333;
	points[2] = (-2546.8308, -8263.1885, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 3.4167;
	points[3] = (-2546.8308, -8133.5830, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 3.5000;
	points[4] = (-2546.8308, -7998.1099, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 3.5833;
	points[5] = (-2546.8308, -7857.0474, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 3.6667;
	points[6] = (-2546.8308, -7710.6694, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 3.7500;
	points[7] = (-2546.8308, -7314.4092, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 4;
	points[8] = (-2546.8308, -7177.8740, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 4.0833;
	points[9] = (-2546.8308, -6896.2993, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 4.2500;
	points[10] = (-2546.8308, -6759.6851, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 4.3333;
	points[11] = (-2546.8308, -6358.6611, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 4.5833;
	points[12] = (-2546.8308, -5943.6221, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 4.8333;
	points[13] = (-2546.8308, -5402.8740, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 5.1667;
	points[14] = (-2546.8308, -4855.1968, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 5.5000;
	points[15] = (-2546.8308, -3904.2520, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 6.0833;
	points[16] = (-2546.8308, -3355.4136, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 6.4167;
	points[17] = (-2546.8308, -2952.1577, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 6.6667;
	points[18] = (-2546.8308, -2399.6260, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 7;
	points[19] = (-2546.8308, -2132.0276, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 7.1667;
	points[20] = (-2546.8308, -2001.3622, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 7.2500;
	points[21] = (-2546.8308, -1579.8149, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 7.5000;
	points[22] = (-2546.8308, -1313.1418, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 7.6667;
	points[23] = (-2546.8308, -1185.4094, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 7.7500;
	points[24] = (-2546.8308, -897.4055, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 7.9167;
	points[25] = (-2546.8308, -759.8898, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 8;
	points[26] = (-2546.8308, -629.2559, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 8.0833;
	points[27] = (-2546.8308, -505.8347, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 8.1667;
	points[28] = (-2546.8308, -354.9153, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 8.2500;
	points[29] = (-2546.8308, -211.3602, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 8.3333;
	points[30] = (-2546.8308, -83.9488, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 8.4167;
	points[31] = (-2546.8308, 33.1345, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 8.5000;
	points[32] = (-2546.8308, 166.0799, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 8.5833;
	points[33] = (-2546.8308, 849.0788, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 9;
	points[34] = (-2546.8308, 3567.9094, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 10.6667;
	points[35] = (-2546.8308, 4115.1577, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 11;
	points[36] = (-2546.8308, 4220.1968, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 11.0833;
	points[37] = (-2546.8308, 4220.1968, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 11.2833;
	points[38] = (-2546.8308, -8386.6533, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 11.2833;
	points[39] = (-2546.8308, -8386.6533, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 18.8000;
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
	points[0] = (-2546.8308, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2546.8308, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 9.5833;
	points[2] = (-2546.8308, -8288.3857, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 9.6667;
	points[3] = (-2546.8308, -8160, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 9.7500;
	points[4] = (-2546.8308, -8025.6694, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 9.8333;
	points[5] = (-2546.8308, -7885.6694, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 9.9167;
	points[6] = (-2546.8308, -7740.3545, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 10;
	points[7] = (-2546.8308, -7603.8979, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 10.0833;
	points[8] = (-2546.8308, -7474.2520, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 10.1667;
	points[9] = (-2546.8308, -7205.3936, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 10.3333;
	points[10] = (-2546.8308, -6785.8267, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 10.5833;
	points[11] = (-2546.8308, -6385.8662, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 10.8333;
	points[12] = (-2546.8308, -5834.2124, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 11.1667;
	points[13] = (-2546.8308, -5430.0786, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 11.4167;
	points[14] = (-2546.8308, -4882.3228, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 11.7500;
	points[15] = (-2546.8308, -3931.2834, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 12.3333;
	points[16] = (-2546.8308, -3382.6062, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 12.6667;
	points[17] = (-2546.8308, -2842.9292, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 13;
	points[18] = (-2546.8308, -2426.8110, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 13.2500;
	points[19] = (-2546.8308, -2158.4211, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 13.4167;
	points[20] = (-2546.8308, -2027.3190, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 13.5000;
	points[21] = (-2546.8308, -1607.2638, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 13.7500;
	points[22] = (-2546.8308, -1339.1497, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 13.9167;
	points[23] = (-2546.8308, -1210.6417, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 14;
	points[24] = (-2546.8308, -1071.0433, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 14.0833;
	points[25] = (-2546.8308, -925.7087, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 14.1667;
	points[26] = (-2546.8308, -786.8543, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 14.2500;
	points[27] = (-2546.8308, -654.8149, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 14.3333;
	points[28] = (-2546.8308, -529.9252, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 14.4167;
	points[29] = (-2546.8308, -238.8079, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 14.5833;
	points[30] = (-2546.8308, -108.0973, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 14.6667;
	points[31] = (-2546.8308, 7.0786, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 14.7500;
	points[32] = (-2546.8308, 139.1453, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 14.8333;
	points[33] = (-2546.8308, 414.3583, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 15;
	points[34] = (-2546.8308, 547.6890, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 15.0833;
	points[35] = (-2546.8308, 822.2874, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 15.2500;
	points[36] = (-2546.8308, 1092.0394, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 15.4167;
	points[37] = (-2546.8308, 3132.2874, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 16.6667;
	points[38] = (-2546.8308, 3270.6575, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 16.7500;
	points[39] = (-2546.8308, 3539.6416, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 16.9167;
	points[40] = (-2546.8308, 3679.2402, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 17;
	points[41] = (-2546.8308, 3948.6221, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 17.1667;
	points[42] = (-2546.8308, 4088.1101, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 17.2500;
	points[43] = (-2546.8308, 4220.1968, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 17.3333;
	points[44] = (-2546.8308, 4220.1968, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 17.5500;
	points[45] = (-2546.8308, -8386.6533, 2352.7559);
	angles[45] = (0, 0, 0);
	at[45] = 17.5500;
	points[46] = (-2546.8308, -8386.6533, 2352.7559);
	angles[46] = (0, 0, 0);
	at[46] = 18.8000;
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
	points[0] = (-2546.8308, -3601.3230, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2546.8308, -3193.0081, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (-2546.8308, -2925.6221, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.4167;
	points[3] = (-2546.8308, -2646.8938, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.5833;
	points[4] = (-2546.8308, -2372.5117, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 0.7500;
	points[5] = (-2546.8308, -2105.7205, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 0.9167;
	points[6] = (-2546.8308, -1975.4961, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 1;
	points[7] = (-2546.8308, -1690.4095, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 1.1667;
	points[8] = (-2546.8308, -1552.5079, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 1.2500;
	points[9] = (-2546.8308, -1287.2875, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 1.4167;
	points[10] = (-2546.8308, -1160.3346, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5000;
	points[11] = (-2546.8308, -1012.1536, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 1.5833;
	points[12] = (-2546.8308, -869.3701, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 1.6667;
	points[13] = (-2546.8308, -733.2008, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 1.7500;
	points[14] = (-2546.8308, -603.9843, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 1.8333;
	points[15] = (-2546.8308, -480.7914, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 1.9167;
	points[16] = (-2546.8308, -324.9551, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 2;
	points[17] = (-2546.8308, -184.5583, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 2.0833;
	points[18] = (-2546.8308, -60.4811, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 2.1667;
	points[19] = (-2546.8308, 59.3720, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 2.2500;
	points[20] = (-2546.8308, 193.1819, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 2.3333;
	points[21] = (-2546.8308, 1284.0946, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 3;
	points[22] = (-2546.8308, 3459.3899, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 4.3333;
	points[23] = (-2546.8308, 3733.8149, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 4.5000;
	points[24] = (-2546.8308, 3866.8740, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 4.5833;
	points[25] = (-2546.8308, 4141.8901, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 4.7500;
	points[26] = (-2546.8308, 4220.1968, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 4.8333;
	points[27] = (-2546.8308, 4220.1968, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 5.0167;
	points[28] = (-2546.8308, -8386.6533, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 5.0167;
	points[29] = (-2546.8308, -8386.6533, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 15.8333;
	points[30] = (-2546.8308, -8313.3467, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 15.9167;
	points[31] = (-2546.8308, -8186.1416, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 16;
	points[32] = (-2546.8308, -8052.9922, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 16.0833;
	points[33] = (-2546.8308, -7914.1338, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 16.1667;
	points[34] = (-2546.8308, -7629.4487, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 16.3333;
	points[35] = (-2546.8308, -7500.4331, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 16.4167;
	points[36] = (-2546.8308, -7232.8350, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 16.5833;
	points[37] = (-2546.8308, -7094.5278, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 16.6667;
	points[38] = (-2546.8308, -6811.8901, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 16.8333;
	points[39] = (-2546.8308, -6413.0317, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 17.0833;
	points[40] = (-2546.8308, -5860.8662, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 17.4167;
	points[41] = (-2546.8308, -5321.1812, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 17.7500;
	points[42] = (-2546.8308, -4909.7246, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 18;
	points[43] = (-2546.8308, -3958.3464, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 18.5833;
	points[44] = (-2546.8308, -3601.3230, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 18.8000;
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
	points[0] = (-2745.9172, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2745.9172, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 5;
	points[2] = (-2745.9172, -8261.8115, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 5.0833;
	points[3] = (-2745.9172, -8130.7090, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 5.1667;
	points[4] = (-2745.9172, -7993.5830, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 5.2500;
	points[5] = (-2745.9172, -7850.7876, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 5.3333;
	points[6] = (-2745.9172, -7702.5591, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 5.4167;
	points[7] = (-2745.9172, -7302.6377, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 5.6667;
	points[8] = (-2745.9172, -7164.3306, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 5.7500;
	points[9] = (-2745.9172, -6879.1338, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 5.9167;
	points[10] = (-2745.9172, -6336.4565, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 6.2500;
	points[11] = (-2745.9172, -5916.1421, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 6.5000;
	points[12] = (-2745.9172, -5370.3545, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 6.8333;
	points[13] = (-2745.9172, -4816.8110, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 7.1667;
	points[14] = (-2745.9172, -3855.1772, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 7.7500;
	points[15] = (-2745.9172, -3300.8347, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 8.0833;
	points[16] = (-2745.9172, -2894.5317, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 8.3333;
	points[17] = (-2745.9172, -2472.1890, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 8.5833;
	points[18] = (-2745.9172, -1930.6891, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 8.9167;
	points[19] = (-2745.9172, -1644.1614, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 9.0833;
	points[20] = (-2745.9172, -1505.9213, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 9.1667;
	points[21] = (-2745.9172, -1240.4568, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 9.3333;
	points[22] = (-2745.9172, -1104.4292, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 9.4167;
	points[23] = (-2745.9172, -956.1260, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 9.5000;
	points[24] = (-2745.9172, -814.3740, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 9.5833;
	points[25] = (-2745.9172, -679.5197, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 9.6667;
	points[26] = (-2745.9172, -551.9055, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 9.7500;
	points[27] = (-2745.9172, -411.8583, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 9.8333;
	points[28] = (-2745.9172, -261.0244, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 9.9167;
	points[29] = (-2745.9172, -126.3638, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 10;
	points[30] = (-2745.9172, -8.7866, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	points[31] = (-2745.9172, 122.2693, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 10.1667;
	points[32] = (-2745.9172, 400.6339, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 10.3333;
	points[33] = (-2745.9172, 672.4410, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 10.5000;
	points[34] = (-2745.9172, 812.2914, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 10.5833;
	points[35] = (-2745.9172, 1085.2401, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 10.7500;
	points[36] = (-2745.9172, 3287.6221, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 12.0833;
	points[37] = (-2745.9172, 3560.2639, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 12.2500;
	points[38] = (-2745.9172, 3700.7009, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 12.3333;
	points[39] = (-2745.9172, 3974.0552, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 12.5000;
	points[40] = (-2745.9172, 4113.7007, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 12.5833;
	points[41] = (-2745.9172, 4219.9214, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 12.6667;
	points[42] = (-2745.9172, 4219.9214, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 12.8667;
	points[43] = (-2745.9172, -8386.6533, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 12.8667;
	points[44] = (-2745.9172, -8386.6533, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 19.2000;
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
	points[0] = (-2745.9172, 4219.9214, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2745.9172, 4219.9214, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.0667;
	points[2] = (-2745.9172, -8386.6533, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.0667;
	points[3] = (-2745.9172, -8386.6533, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 11.3333;
	points[4] = (-2745.9172, -8362.2041, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 11.4167;
	points[5] = (-2745.9172, -8236.1025, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 11.5000;
	points[6] = (-2745.9172, -8103.7407, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 11.5833;
	points[7] = (-2745.9172, -7965.4727, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 11.6667;
	points[8] = (-2745.9172, -7821.5747, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 11.7500;
	points[9] = (-2745.9172, -7672.9531, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 11.8333;
	points[10] = (-2745.9172, -7543.7397, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 11.9167;
	points[11] = (-2745.9172, -7275.2363, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 12.0833;
	points[12] = (-2745.9172, -7136.3389, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 12.1667;
	points[13] = (-2745.9172, -6850, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 12.3333;
	points[14] = (-2745.9172, -6446.2598, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 12.5833;
	points[15] = (-2745.9172, -6169.8428, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 12.7500;
	points[16] = (-2745.9172, -5887.7954, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 12.9167;
	points[17] = (-2745.9172, -5342.7954, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 13.2500;
	points[18] = (-2745.9172, -4927.0869, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 13.5000;
	points[19] = (-2745.9172, -3827.2124, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 14.1667;
	points[20] = (-2745.9172, -3410.7244, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 14.4167;
	points[21] = (-2745.9172, -2865.9487, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 14.7500;
	points[22] = (-2745.9172, -2444.5789, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 15;
	points[23] = (-2745.9172, -2172.7952, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 15.1667;
	points[24] = (-2745.9172, -2040.0433, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 15.2500;
	points[25] = (-2745.9172, -1901.4646, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 15.3333;
	points[26] = (-2745.9172, -1616.2323, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 15.5000;
	points[27] = (-2745.9172, -1478.7007, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 15.5833;
	points[28] = (-2745.9172, -1214.7599, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 15.7500;
	points[29] = (-2745.9172, -1074.2599, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 15.8333;
	points[30] = (-2745.9172, -927.2402, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 15.9167;
	points[31] = (-2745.9172, -786.8386, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 16;
	points[32] = (-2745.9172, -653.4055, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 16.0833;
	points[33] = (-2745.9172, -527.2795, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 16.1667;
	points[34] = (-2745.9172, -232.7697, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 16.3333;
	points[35] = (-2745.9172, -101.4528, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 16.4167;
	points[36] = (-2745.9172, 15.5719, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 16.5000;
	points[37] = (-2745.9172, 149.3898, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 16.5833;
	points[38] = (-2745.9172, 427.2914, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 16.7500;
	points[39] = (-2745.9172, 562.3661, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 16.8333;
	points[40] = (-2745.9172, 839.8228, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 17;
	points[41] = (-2745.9172, 2625.4724, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 18.0833;
	points[42] = (-2745.9172, 3728.2322, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 18.7500;
	points[43] = (-2745.9172, 3862.9133, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 18.8333;
	points[44] = (-2745.9172, 4140.7480, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 19;
	points[45] = (-2745.9172, 4219.9214, 2352.7559);
	angles[45] = (0, 0, 0);
	at[45] = 19.0833;
	points[46] = (-2745.9172, 4219.9214, 2352.7559);
	angles[46] = (0, 0, 0);
	at[46] = 19.2000;
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
	points[0] = (-2745.9172, -6085.7480, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2745.9172, -5944.5273, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.0833;
	points[2] = (-2745.9172, -5397.8740, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.4167;
	points[3] = (-2745.9172, -4844.2520, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (-2745.9172, -3883.1101, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 1.3333;
	points[5] = (-2745.9172, -3328.2559, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 1.6667;
	points[6] = (-2745.9172, -2921.2991, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 1.9167;
	points[7] = (-2745.9172, -2639.3425, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 2.0833;
	points[8] = (-2745.9172, -2362.2126, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 2.2500;
	points[9] = (-2745.9172, -1960.0355, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 2.5000;
	points[10] = (-2745.9172, -1672.2244, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 2.6667;
	points[11] = (-2745.9172, -1533.2874, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 2.7500;
	points[12] = (-2745.9172, -1397.9213, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 2.8333;
	points[13] = (-2745.9172, -1134.8464, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 3;
	points[14] = (-2745.9172, -985.2717, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 3.0833;
	points[15] = (-2745.9172, -842.1851, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 3.1667;
	points[16] = (-2745.9172, -705.9213, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 3.2500;
	points[17] = (-2745.9172, -443.8898, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 3.4167;
	points[18] = (-2745.9172, -289.9268, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 3.5000;
	points[19] = (-2745.9172, -151.9587, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 3.5833;
	points[20] = (-2745.9172, -30.8917, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 3.6667;
	points[21] = (-2745.9172, 95.3240, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 3.7500;
	points[22] = (-2745.9172, 231.7748, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 3.8333;
	points[23] = (-2745.9172, 372.3122, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 3.9167;
	points[24] = (-2745.9172, 644.7638, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 4.0833;
	points[25] = (-2745.9172, 2847.1062, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 5.4167;
	points[26] = (-2745.9172, 3119.8384, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 5.5833;
	points[27] = (-2745.9172, 3259.9448, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 5.6667;
	points[28] = (-2745.9172, 3531.6416, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 5.8333;
	points[29] = (-2745.9172, 3672.9805, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 5.9167;
	points[30] = (-2745.9172, 3945.2363, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 6.0833;
	points[31] = (-2745.9172, 4086.3779, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 6.1667;
	points[32] = (-2745.9172, 4219.9214, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 6.2500;
	points[33] = (-2745.9172, 4219.9214, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 6.4667;
	points[34] = (-2745.9172, -8386.6533, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 6.4667;
	points[35] = (-2745.9172, -8386.6533, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 17.7500;
	points[36] = (-2745.9172, -8337.5195, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 17.8333;
	points[37] = (-2745.9172, -8210.1182, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 17.9167;
	points[38] = (-2745.9172, -8076.5752, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 18;
	points[39] = (-2745.9172, -7937.1260, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 18.0833;
	points[40] = (-2745.9172, -7647.4019, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 18.2500;
	points[41] = (-2745.9172, -7517.4805, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 18.3333;
	points[42] = (-2745.9172, -7247.6772, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 18.5000;
	points[43] = (-2745.9172, -7108.1895, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 18.5833;
	points[44] = (-2745.9172, -6821.8110, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 18.7500;
	points[45] = (-2745.9172, -6418.8975, 2352.7559);
	angles[45] = (0, 0, 0);
	at[45] = 19;
	points[46] = (-2745.9172, -6085.7480, 2352.7559);
	angles[46] = (0, 0, 0);
	at[46] = 19.2000;
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
	points[0] = (-2945, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2945, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 6.6667;
	points[2] = (-2945, -8260.4336, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 6.7500;
	points[3] = (-2945, -8127.8350, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 6.8333;
	points[4] = (-2945, -7989.0552, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 6.9167;
	points[5] = (-2945, -7844.5278, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 7;
	points[6] = (-2945, -7694.4487, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 7.0833;
	points[7] = (-2945, -7427.8350, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 7.2500;
	points[8] = (-2945, -7290.8662, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 7.3333;
	points[9] = (-2945, -7150.7876, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 7.4167;
	points[10] = (-2945, -6861.9292, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 7.5833;
	points[11] = (-2945, -6590.1577, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 7.7500;
	points[12] = (-2945, -6314.1733, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 7.9167;
	points[13] = (-2945, -5888.6616, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 8.1667;
	points[14] = (-2945, -5476.7319, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 8.4167;
	points[15] = (-2945, -4917.5195, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 8.7500;
	points[16] = (-2945, -3945.3936, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 9.3333;
	points[17] = (-2945, -3384.9766, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 9.6667;
	points[18] = (-2945, -2972.3740, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 9.9167;
	points[19] = (-2945, -2408.4724, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 10.2500;
	points[20] = (-2945, -2134.8821, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 10.4167;
	points[21] = (-2945, -2001.3505, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 10.5000;
	points[22] = (-2945, -1712.2797, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 10.6667;
	points[23] = (-2945, -1570.8779, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 10.7500;
	points[24] = (-2945, -1299.0511, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 10.9167;
	points[25] = (-2945, -1169.0157, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 11;
	points[26] = (-2945, -872.9843, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 11.1667;
	points[27] = (-2945, -733.7520, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 11.2500;
	points[28] = (-2945, -601.7717, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 11.3333;
	points[29] = (-2945, -474.3780, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 11.4167;
	points[30] = (-2945, -315.9248, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 11.5000;
	points[31] = (-2945, -173.6457, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 11.5833;
	points[32] = (-2945, 76.0398, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 11.7500;
	points[33] = (-2945, 213.3547, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 11.8333;
	points[34] = (-2945, 354.8965, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 11.9167;
	points[35] = (-2945, 3132.9292, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 13.5833;
	points[36] = (-2945, 3274.2598, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 13.6667;
	points[37] = (-2945, 3549.5276, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 13.8333;
	points[38] = (-2945, 3691.7952, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 13.9167;
	points[39] = (-2945, 3967.8740, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 14.0833;
	points[40] = (-2945, 4109.3306, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 14.1667;
	points[41] = (-2945, 4216.8896, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 14.2500;
	points[42] = (-2945, 4216.8896, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 14.4500;
	points[43] = (-2945, -8386.6533, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 14.4500;
	points[44] = (-2945, -8386.6533, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 20;
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
	points[0] = (-2945, 2716.7402, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2945, 3274.2598, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.3333;
	points[2] = (-2945, 3549.5276, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-2945, 3691.7952, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.5833;
	points[4] = (-2945, 3967.8740, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 0.7500;
	points[5] = (-2945, 4109.3306, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 0.8333;
	points[6] = (-2945, 4216.8896, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 0.9167;
	points[7] = (-2945, 4216.8896, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 1.1167;
	points[8] = (-2945, -8386.6533, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 1.1167;
	points[9] = (-2945, -8386.6533, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 13.3333;
	points[10] = (-2945, -8260.4336, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 13.4167;
	points[11] = (-2945, -8127.8350, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 13.5000;
	points[12] = (-2945, -7989.0552, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 13.5833;
	points[13] = (-2945, -7844.5278, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 13.6667;
	points[14] = (-2945, -7694.4487, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 13.7500;
	points[15] = (-2945, -7427.8350, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 13.9167;
	points[16] = (-2945, -7290.8662, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 14;
	points[17] = (-2945, -7150.7876, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 14.0833;
	points[18] = (-2945, -6861.9292, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 14.2500;
	points[19] = (-2945, -6590.1577, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 14.4167;
	points[20] = (-2945, -6314.1733, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 14.5833;
	points[21] = (-2945, -5888.6616, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 14.8333;
	points[22] = (-2945, -5476.7319, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 15.0833;
	points[23] = (-2945, -4917.5195, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 15.4167;
	points[24] = (-2945, -3945.3936, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 16;
	points[25] = (-2945, -3384.9766, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 16.3333;
	points[26] = (-2945, -2972.3740, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 16.5833;
	points[27] = (-2945, -2408.4724, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 16.9167;
	points[28] = (-2945, -2134.8821, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 17.0833;
	points[29] = (-2945, -2001.3505, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 17.1667;
	points[30] = (-2945, -1712.2797, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 17.3333;
	points[31] = (-2945, -1570.8779, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 17.4167;
	points[32] = (-2945, -1299.0511, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 17.5833;
	points[33] = (-2945, -1169.0157, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 17.6667;
	points[34] = (-2945, -872.9843, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 17.8333;
	points[35] = (-2945, -733.7520, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 17.9167;
	points[36] = (-2945, -601.7717, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 18;
	points[37] = (-2945, -474.3780, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 18.0833;
	points[38] = (-2945, -315.9248, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 18.1667;
	points[39] = (-2945, -173.6457, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 18.2500;
	points[40] = (-2945, 76.0398, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 18.4167;
	points[41] = (-2945, 213.3547, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 18.5000;
	points[42] = (-2945, 354.8965, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 18.5833;
	points[43] = (-2945, 2716.7402, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 20;
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
	points[0] = (-2945, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2945, -8260.4336, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.0833;
	points[2] = (-2945, -8127.8350, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.1667;
	points[3] = (-2945, -7989.0552, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-2945, -7844.5278, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 0.3333;
	points[5] = (-2945, -7694.4487, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 0.4167;
	points[6] = (-2945, -7427.8350, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 0.5833;
	points[7] = (-2945, -7290.8662, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 0.6667;
	points[8] = (-2945, -7150.7876, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 0.7500;
	points[9] = (-2945, -6861.9292, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 0.9167;
	points[10] = (-2945, -6590.1577, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.0833;
	points[11] = (-2945, -6314.1733, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 1.2500;
	points[12] = (-2945, -5888.6616, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 1.5000;
	points[13] = (-2945, -5476.7319, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 1.7500;
	points[14] = (-2945, -4917.5195, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 2.0833;
	points[15] = (-2945, -3945.3936, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 2.6667;
	points[16] = (-2945, -3384.9766, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 3;
	points[17] = (-2945, -2972.3740, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 3.2500;
	points[18] = (-2945, -2408.4724, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 3.5833;
	points[19] = (-2945, -2134.8821, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 3.7500;
	points[20] = (-2945, -2001.3505, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 3.8333;
	points[21] = (-2945, -1712.2797, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 4;
	points[22] = (-2945, -1570.8779, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 4.0833;
	points[23] = (-2945, -1299.0511, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 4.2500;
	points[24] = (-2945, -1169.0157, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 4.3333;
	points[25] = (-2945, -872.9843, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 4.5000;
	points[26] = (-2945, -733.7520, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 4.5833;
	points[27] = (-2945, -601.7717, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 4.6667;
	points[28] = (-2945, -474.3780, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 4.7500;
	points[29] = (-2945, -315.9248, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 4.8333;
	points[30] = (-2945, -173.6457, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 4.9167;
	points[31] = (-2945, 76.0398, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 5.0833;
	points[32] = (-2945, 213.3547, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 5.1667;
	points[33] = (-2945, 354.8965, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 5.2500;
	points[34] = (-2945, 3132.9292, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 6.9167;
	points[35] = (-2945, 3274.2598, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 7;
	points[36] = (-2945, 3549.5276, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 7.1667;
	points[37] = (-2945, 3691.7952, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 7.2500;
	points[38] = (-2945, 3967.8740, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 7.4167;
	points[39] = (-2945, 4109.3306, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 7.5000;
	points[40] = (-2945, 4216.8896, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 7.5833;
	points[41] = (-2945, 4216.8896, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 7.7833;
	points[42] = (-2945, -8386.6533, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 7.7833;
	points[43] = (-2945, -8386.6533, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 20;
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
	points[0] = (-3144.0867, -8386.6533, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3144.0867, -8386.6533, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 8.3333;
	points[2] = (-3144.0867, -8259.0547, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 8.4167;
	points[3] = (-3144.0867, -8124.9214, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 8.5000;
	points[4] = (-3144.0867, -7984.5669, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 8.5833;
	points[5] = (-3144.0867, -7838.2285, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 8.6667;
	points[6] = (-3144.0867, -7686.2993, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 8.7500;
	points[7] = (-3144.0867, -7417.7168, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 8.9167;
	points[8] = (-3144.0867, -7279.0947, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 9;
	points[9] = (-3144.0867, -7137.2441, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 9.0833;
	points[10] = (-3144.0867, -6844.6851, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 9.2500;
	points[11] = (-3144.0867, -6432.4409, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 9.5000;
	points[12] = (-3144.0867, -6149.6851, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 9.6667;
	points[13] = (-3144.0867, -5862.5986, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 9.8333;
	points[14] = (-3144.0867, -5305.1577, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 10.1667;
	points[15] = (-3144.0867, -4880.2759, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 10.4167;
	points[16] = (-3144.0867, -3898.3779, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 11;
	points[17] = (-3144.0867, -3331.7993, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 11.3333;
	points[18] = (-3144.0867, -2916.1179, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 11.5833;
	points[19] = (-3144.0867, -2485.5828, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 11.8333;
	points[20] = (-3144.0867, -2206.8386, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 12;
	points[21] = (-3144.0867, -1932.2756, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 12.1667;
	points[22] = (-3144.0867, -1639.6614, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 12.3333;
	points[23] = (-3144.0867, -1498.6064, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 12.4167;
	points[24] = (-3144.0867, -1361.3228, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 12.5000;
	points[25] = (-3144.0867, -1228.0197, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 12.5833;
	points[26] = (-3144.0867, -1086.5748, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 12.6667;
	points[27] = (-3144.0867, -935.9291, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 12.7500;
	points[28] = (-3144.0867, -792.1693, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 12.8333;
	points[29] = (-3144.0867, -655.6614, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 12.9167;
	points[30] = (-3144.0867, -526.7717, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 13;
	points[31] = (-3144.0867, -226.2047, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 13.1667;
	points[32] = (-3144.0867, -93.0622, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 13.2500;
	points[33] = (-3144.0867, 27.4478, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 13.3333;
	points[34] = (-3144.0867, 164.6047, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 13.4167;
	points[35] = (-3144.0867, 447.9882, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 13.5833;
	points[36] = (-3144.0867, 586.4606, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 13.6667;
	points[37] = (-3144.0867, 2836.0945, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 15;
	points[38] = (-3144.0867, 3114.6340, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 15.1667;
	points[39] = (-3144.0867, 3257.8269, 2352.7559);
	angles[39] = (0, 0, 0);
	at[39] = 15.2500;
	points[40] = (-3144.0867, 3535.6221, 2352.7559);
	angles[40] = (0, 0, 0);
	at[40] = 15.4167;
	points[41] = (-3144.0867, 3679.8228, 2352.7559);
	angles[41] = (0, 0, 0);
	at[41] = 15.5000;
	points[42] = (-3144.0867, 3958.5432, 2352.7559);
	angles[42] = (0, 0, 0);
	at[42] = 15.6667;
	points[43] = (-3144.0867, 4101.9688, 2352.7559);
	angles[43] = (0, 0, 0);
	at[43] = 15.7500;
	points[44] = (-3144.0867, 4210.9844, 2352.7559);
	angles[44] = (0, 0, 0);
	at[44] = 15.8333;
	points[45] = (-3144.0867, 4210.9844, 2352.7559);
	angles[45] = (0, 0, 0);
	at[45] = 16.0333;
	points[46] = (-3144.0867, -8386.6533, 2352.7559);
	angles[46] = (0, 0, 0);
	at[46] = 16.0333;
	points[47] = (-3144.0867, -8386.6533, 2352.7559);
	angles[47] = (0, 0, 0);
	at[47] = 17.0667;
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
	points[0] = (-3144.0867, -8069.4883, 2352.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3144.0867, -7926.7324, 2352.7559);
	angles[1] = (0, 0, 0);
	at[1] = 0.0833;
	points[2] = (-3144.0867, -7632.4805, 2352.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (-3144.0867, -7499.3311, 2352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.3333;
	points[4] = (-3144.0867, -7222.7168, 2352.7559);
	angles[4] = (0, 0, 0);
	at[4] = 0.5000;
	points[5] = (-3144.0867, -6789.5273, 2352.7559);
	angles[5] = (0, 0, 0);
	at[5] = 0.7500;
	points[6] = (-3144.0867, -6376.4175, 2352.7559);
	angles[6] = (0, 0, 0);
	at[6] = 1;
	points[7] = (-3144.0867, -5948.1890, 2352.7559);
	angles[7] = (0, 0, 0);
	at[7] = 1.2500;
	points[8] = (-3144.0867, -5389.5674, 2352.7559);
	angles[8] = (0, 0, 0);
	at[8] = 1.5833;
	points[9] = (-3144.0867, -4824.1733, 2352.7559);
	angles[9] = (0, 0, 0);
	at[9] = 1.9167;
	points[10] = (-3144.0867, -3841.6416, 2352.7559);
	angles[10] = (0, 0, 0);
	at[10] = 2.5000;
	points[11] = (-3144.0867, -3416.0591, 2352.7559);
	angles[11] = (0, 0, 0);
	at[11] = 2.7500;
	points[12] = (-3144.0867, -2859.1968, 2352.7559);
	angles[12] = (0, 0, 0);
	at[12] = 3.0833;
	points[13] = (-3144.0867, -2429.1851, 2352.7559);
	angles[13] = (0, 0, 0);
	at[13] = 3.3333;
	points[14] = (-3144.0867, -2152.1104, 2352.7559);
	angles[14] = (0, 0, 0);
	at[14] = 3.5000;
	points[15] = (-3144.0867, -2016.8740, 2352.7559);
	angles[15] = (0, 0, 0);
	at[15] = 3.5833;
	points[16] = (-3144.0867, -1582.7992, 2352.7559);
	angles[16] = (0, 0, 0);
	at[16] = 3.8333;
	points[17] = (-3144.0867, -1307.5118, 2352.7559);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	points[18] = (-3144.0867, -1175.8583, 2352.7559);
	angles[18] = (0, 0, 0);
	at[18] = 4.0833;
	points[19] = (-3144.0867, -877.5748, 2352.7559);
	angles[19] = (0, 0, 0);
	at[19] = 4.2500;
	points[20] = (-3144.0867, -736.6732, 2352.7559);
	angles[20] = (0, 0, 0);
	at[20] = 4.3333;
	points[21] = (-3144.0867, -603.1693, 2352.7559);
	angles[21] = (0, 0, 0);
	at[21] = 4.4167;
	points[22] = (-3144.0867, -474.4213, 2352.7559);
	angles[22] = (0, 0, 0);
	at[22] = 4.5000;
	points[23] = (-3144.0867, -314.3661, 2352.7559);
	angles[23] = (0, 0, 0);
	at[23] = 4.5833;
	points[24] = (-3144.0867, -170.8398, 2352.7559);
	angles[24] = (0, 0, 0);
	at[24] = 4.6667;
	points[25] = (-3144.0867, 81.7500, 2352.7559);
	angles[25] = (0, 0, 0);
	at[25] = 4.8333;
	points[26] = (-3144.0867, 220.7378, 2352.7559);
	angles[26] = (0, 0, 0);
	at[26] = 4.9167;
	points[27] = (-3144.0867, 364.0212, 2352.7559);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-3144.0867, 642.6614, 2352.7559);
	angles[28] = (0, 0, 0);
	at[28] = 5.1667;
	points[29] = (-3144.0867, 3736.1575, 2352.7559);
	angles[29] = (0, 0, 0);
	at[29] = 7;
	points[30] = (-3144.0867, 3873.3821, 2352.7559);
	angles[30] = (0, 0, 0);
	at[30] = 7.0833;
	points[31] = (-3144.0867, 4157.1260, 2352.7559);
	angles[31] = (0, 0, 0);
	at[31] = 7.2500;
	points[32] = (-3144.0867, 4210.9844, 2352.7559);
	angles[32] = (0, 0, 0);
	at[32] = 7.3333;
	points[33] = (-3144.0867, 4210.9844, 2352.7559);
	angles[33] = (0, 0, 0);
	at[33] = 7.5000;
	points[34] = (-3144.0867, -8386.6533, 2352.7559);
	angles[34] = (0, 0, 0);
	at[34] = 7.5000;
	points[35] = (-3144.0867, -8386.6533, 2352.7559);
	angles[35] = (0, 0, 0);
	at[35] = 16.8333;
	points[36] = (-3144.0867, -8310.9053, 2352.7559);
	angles[36] = (0, 0, 0);
	at[36] = 16.9167;
	points[37] = (-3144.0867, -8179.3701, 2352.7559);
	angles[37] = (0, 0, 0);
	at[37] = 17;
	points[38] = (-3144.0867, -8069.4883, 2352.7559);
	angles[38] = (0, 0, 0);
	at[38] = 17.0667;
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
	points[0] = (173.5126, -11999.9219, 2753);
	angles[0] = (0, -37, 0);
	at[0] = 0;
	points[1] = (173.5126, -11999.9219, 2753);
	angles[1] = (0, -37, 0);
	at[1] = 0.6000;
	points[2] = (173.5126, -11999.9219, 2806.9922);
	angles[2] = (0, -37, 0);
	at[2] = 0.6500;
	points[3] = (173.5126, -11999.9219, 2853.8071);
	angles[3] = (0, -37, 0);
	at[3] = 0.7000;
	points[4] = (173.5126, -11999.9219, 2893.4487);
	angles[4] = (0, -37, 0);
	at[4] = 0.7500;
	points[5] = (173.5126, -11999.9219, 2925.9133);
	angles[5] = (0, -37, 0);
	at[5] = 0.8000;
	points[6] = (173.5126, -11999.9219, 2951.2048);
	angles[6] = (0, -37, 0);
	at[6] = 0.8500;
	points[7] = (173.5126, -11999.9219, 2969.3188);
	angles[7] = (0, -37, 0);
	at[7] = 0.9000;
	points[8] = (173.5126, -11999.9219, 2980.2600);
	angles[8] = (0, -37, 0);
	at[8] = 0.9500;
	points[9] = (173.5126, -11999.9219, 2984.0234);
	angles[9] = (0, -37, 0);
	at[9] = 1;
	points[10] = (173.5126, -11999.9219, 2980.6143);
	angles[10] = (0, -37, 0);
	at[10] = 1.0500;
	points[11] = (173.5126, -11999.9219, 2970.0276);
	angles[11] = (0, -37, 0);
	at[11] = 1.1000;
	points[12] = (173.5126, -11999.9219, 2952.2678);
	angles[12] = (0, -37, 0);
	at[12] = 1.1500;
	points[13] = (173.5126, -11999.9219, 2927.3308);
	angles[13] = (0, -37, 0);
	at[13] = 1.2000;
	points[14] = (173.5126, -11999.9219, 2895.2205);
	angles[14] = (0, -37, 0);
	at[14] = 1.2500;
	points[15] = (173.5126, -11999.9219, 2855.9331);
	angles[15] = (0, -37, 0);
	at[15] = 1.3000;
	points[16] = (173.5126, -11999.9219, 2809.4727);
	angles[16] = (0, -37, 0);
	at[16] = 1.3500;
	points[17] = (173.5126, -11999.9219, 2755.8347);
	angles[17] = (0, -37, 0);
	at[17] = 1.4000;
	points[18] = (173.5126, -11999.9219, 2575.8347);
	angles[18] = (0, -37, 0);
	at[18] = 1.4500;
	points[19] = (173.5126, -11999.9219, 2575.8347);
	angles[19] = (0, -37, 0);
	at[19] = 2.5000;
	points[20] = (173.5126, -11999.9219, 2753);
	angles[20] = (0, -37, 0);
	at[20] = 2.5500;
	points[21] = (173.5126, -11999.9219, 2753);
	angles[21] = (0, -37, 0);
	at[21] = 3.5833;
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
	points[0] = (-924.7363, -12858.3857, 2973.6733);
	angles[0] = (0, -134, 0);
	at[0] = 0;
	points[1] = (-924.7363, -12858.3857, 2982.2205);
	angles[1] = (0, -134, 0);
	at[1] = 0.0500;
	points[2] = (-924.7363, -12858.3857, 2983.5947);
	angles[2] = (0, -134, 0);
	at[2] = 0.1000;
	points[3] = (-924.7363, -12858.3857, 2977.7915);
	angles[3] = (0, -134, 0);
	at[3] = 0.1500;
	points[4] = (-924.7363, -12858.3857, 2964.8149);
	angles[4] = (0, -134, 0);
	at[4] = 0.2000;
	points[5] = (-924.7363, -12858.3857, 2944.6616);
	angles[5] = (0, -134, 0);
	at[5] = 0.2500;
	points[6] = (-924.7363, -12858.3857, 2917.3347);
	angles[6] = (0, -134, 0);
	at[6] = 0.3000;
	points[7] = (-924.7363, -12858.3857, 2882.8308);
	angles[7] = (0, -134, 0);
	at[7] = 0.3500;
	points[8] = (-924.7363, -12858.3857, 2841.1536);
	angles[8] = (0, -134, 0);
	at[8] = 0.4000;
	points[9] = (-924.7363, -12858.3857, 2792.2993);
	angles[9] = (0, -134, 0);
	at[9] = 0.4500;
	points[10] = (-924.7363, -12858.3857, 2575.7439);
	angles[10] = (0, -134, 0);
	at[10] = 0.5000;
	points[11] = (-924.7363, -12858.3857, 2575.7439);
	angles[11] = (0, -134, 0);
	at[11] = 2.5000;
	points[12] = (-924.7363, -12858.3857, 2752.9094);
	angles[12] = (0, -134, 0);
	at[12] = 2.5500;
	points[13] = (-924.7363, -12858.3857, 2752.9094);
	angles[13] = (0, -134, 0);
	at[13] = 4.1500;
	points[14] = (-924.7363, -12858.3857, 2771.7046);
	angles[14] = (0, -134, 0);
	at[14] = 4.2000;
	points[15] = (-924.7363, -12858.3857, 2823.3032);
	angles[15] = (0, -134, 0);
	at[15] = 4.2500;
	points[16] = (-924.7363, -12858.3857, 2867.7285);
	angles[16] = (0, -134, 0);
	at[16] = 4.3000;
	points[17] = (-924.7363, -12858.3857, 2904.9763);
	angles[17] = (0, -134, 0);
	at[17] = 4.3500;
	points[18] = (-924.7363, -12858.3857, 2935.0513);
	angles[18] = (0, -134, 0);
	at[18] = 4.4000;
	points[19] = (-924.7363, -12858.3857, 2957.9487);
	angles[19] = (0, -134, 0);
	at[19] = 4.4500;
	points[20] = (-924.7363, -12858.3857, 2973.6733);
	angles[20] = (0, -134, 0);
	at[20] = 4.5000;
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
	points[0] = (-1627.6378, -12286.4561, 2823.4883);
	angles[0] = (0, -38, 0);
	at[0] = 0;
	points[1] = (-1627.6378, -12286.4561, 2867.9136);
	angles[1] = (0, -38, 0);
	at[1] = 0.0500;
	points[2] = (-1627.6378, -12286.4561, 2905.1614);
	angles[2] = (0, -38, 0);
	at[2] = 0.1000;
	points[3] = (-1627.6378, -12286.4561, 2935.2363);
	angles[3] = (0, -38, 0);
	at[3] = 0.1500;
	points[4] = (-1627.6378, -12286.4561, 2958.1338);
	angles[4] = (0, -38, 0);
	at[4] = 0.2000;
	points[5] = (-1627.6378, -12286.4561, 2973.8584);
	angles[5] = (0, -38, 0);
	at[5] = 0.2500;
	points[6] = (-1627.6378, -12286.4561, 2982.4055);
	angles[6] = (0, -38, 0);
	at[6] = 0.3000;
	points[7] = (-1627.6378, -12286.4561, 2983.7795);
	angles[7] = (0, -38, 0);
	at[7] = 0.3500;
	points[8] = (-1627.6378, -12286.4561, 2977.9766);
	angles[8] = (0, -38, 0);
	at[8] = 0.4000;
	points[9] = (-1627.6378, -12286.4561, 2965);
	angles[9] = (0, -38, 0);
	at[9] = 0.4500;
	points[10] = (-1627.6378, -12286.4561, 2944.8467);
	angles[10] = (0, -38, 0);
	at[10] = 0.5000;
	points[11] = (-1627.6378, -12286.4561, 2917.5198);
	angles[11] = (0, -38, 0);
	at[11] = 0.5500;
	points[12] = (-1627.6378, -12286.4561, 2883.0159);
	angles[12] = (0, -38, 0);
	at[12] = 0.6000;
	points[13] = (-1627.6378, -12286.4561, 2841.3386);
	angles[13] = (0, -38, 0);
	at[13] = 0.6500;
	points[14] = (-1627.6378, -12286.4561, 2792.4844);
	angles[14] = (0, -38, 0);
	at[14] = 0.7000;
	points[15] = (-1627.6378, -12286.4561, 2575.9290);
	angles[15] = (0, -38, 0);
	at[15] = 0.7500;
	points[16] = (-1627.6378, -12286.4561, 2575.9290);
	angles[16] = (0, -38, 0);
	at[16] = 2.5000;
	points[17] = (-1627.6378, -12286.4561, 2753.0945);
	angles[17] = (0, -38, 0);
	at[17] = 2.5500;
	points[18] = (-1627.6378, -12286.4561, 2753.0945);
	angles[18] = (0, -38, 0);
	at[18] = 4.1500;
	points[19] = (-1627.6378, -12286.4561, 2771.8896);
	angles[19] = (0, -38, 0);
	at[19] = 4.2000;
	points[20] = (-1627.6378, -12286.4561, 2823.4883);
	angles[20] = (0, -38, 0);
	at[20] = 4.2500;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2713.9844, -12468.6621, 2753.0471);
	angles[0] = (0, 162, 0);
	at[0] = 0;
	points[1] = (-2713.9844, -12468.6621, 2753.0471);
	angles[1] = (0, 162, 0);
	at[1] = 0.6000;
	points[2] = (-2713.9844, -12468.6621, 2807.0393);
	angles[2] = (0, 162, 0);
	at[2] = 0.6500;
	points[3] = (-2713.9844, -12468.6621, 2853.8542);
	angles[3] = (0, 162, 0);
	at[3] = 0.7000;
	points[4] = (-2713.9844, -12468.6621, 2893.4958);
	angles[4] = (0, 162, 0);
	at[4] = 0.7500;
	points[5] = (-2713.9844, -12468.6621, 2925.9604);
	angles[5] = (0, 162, 0);
	at[5] = 0.8000;
	points[6] = (-2713.9844, -12468.6621, 2951.2520);
	angles[6] = (0, 162, 0);
	at[6] = 0.8500;
	points[7] = (-2713.9844, -12468.6621, 2969.3662);
	angles[7] = (0, 162, 0);
	at[7] = 0.9000;
	points[8] = (-2713.9844, -12468.6621, 2980.3071);
	angles[8] = (0, 162, 0);
	at[8] = 0.9500;
	points[9] = (-2713.9844, -12468.6621, 2984.0710);
	angles[9] = (0, 162, 0);
	at[9] = 1;
	points[10] = (-2713.9844, -12468.6621, 2980.6616);
	angles[10] = (0, 162, 0);
	at[10] = 1.0500;
	points[11] = (-2713.9844, -12468.6621, 2970.0750);
	angles[11] = (0, 162, 0);
	at[11] = 1.1000;
	points[12] = (-2713.9844, -12468.6621, 2952.3149);
	angles[12] = (0, 162, 0);
	at[12] = 1.1500;
	points[13] = (-2713.9844, -12468.6621, 2927.3779);
	angles[13] = (0, 162, 0);
	at[13] = 1.2000;
	points[14] = (-2713.9844, -12468.6621, 2895.2678);
	angles[14] = (0, 162, 0);
	at[14] = 1.2500;
	points[15] = (-2713.9844, -12468.6621, 2855.9805);
	angles[15] = (0, 162, 0);
	at[15] = 1.3000;
	points[16] = (-2713.9844, -12468.6621, 2809.5198);
	angles[16] = (0, 162, 0);
	at[16] = 1.3500;
	points[17] = (-2713.9844, -12468.6621, 2755.8818);
	angles[17] = (0, 162, 0);
	at[17] = 1.4000;
	points[18] = (-2713.9844, -12468.6621, 2575.8818);
	angles[18] = (0, 162, 0);
	at[18] = 1.4500;
	points[19] = (-2713.9844, -12468.6621, 2575.8818);
	angles[19] = (0, 162, 0);
	at[19] = 2.5000;
	points[20] = (-2713.9844, -12468.6621, 2753.0471);
	angles[20] = (0, 162, 0);
	at[20] = 2.5500;
	points[21] = (-2713.9844, -12468.6621, 2753.0471);
	angles[21] = (0, 162, 0);
	at[21] = 3.5833;
	mover = getEnt("iz_obj_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (216.4772, -12909.3311, 2752.5867);
	angles[0] = (0, -48, 0);
	at[0] = 0;
	points[1] = (216.4772, -12909.3311, 2752.5867);
	angles[1] = (0, -48, 0);
	at[1] = 0.3500;
	points[2] = (216.4772, -12909.3311, 2806.5789);
	angles[2] = (0, -48, 0);
	at[2] = 0.4000;
	points[3] = (216.4772, -12909.3311, 2853.3936);
	angles[3] = (0, -48, 0);
	at[3] = 0.4500;
	points[4] = (216.4772, -12909.3311, 2893.0354);
	angles[4] = (0, -48, 0);
	at[4] = 0.5000;
	points[5] = (216.4772, -12909.3311, 2925.5000);
	angles[5] = (0, -48, 0);
	at[5] = 0.5500;
	points[6] = (216.4772, -12909.3311, 2950.7915);
	angles[6] = (0, -48, 0);
	at[6] = 0.6000;
	points[7] = (216.4772, -12909.3311, 2968.9055);
	angles[7] = (0, -48, 0);
	at[7] = 0.6500;
	points[8] = (216.4772, -12909.3311, 2979.8467);
	angles[8] = (0, -48, 0);
	at[8] = 0.7000;
	points[9] = (216.4772, -12909.3311, 2983.6104);
	angles[9] = (0, -48, 0);
	at[9] = 0.7500;
	points[10] = (216.4772, -12909.3311, 2980.2007);
	angles[10] = (0, -48, 0);
	at[10] = 0.8000;
	points[11] = (216.4772, -12909.3311, 2969.6143);
	angles[11] = (0, -48, 0);
	at[11] = 0.8500;
	points[12] = (216.4772, -12909.3311, 2951.8542);
	angles[12] = (0, -48, 0);
	at[12] = 0.9000;
	points[13] = (216.4772, -12909.3311, 2926.9172);
	angles[13] = (0, -48, 0);
	at[13] = 0.9500;
	points[14] = (216.4772, -12909.3311, 2894.8071);
	angles[14] = (0, -48, 0);
	at[14] = 1;
	points[15] = (216.4772, -12909.3311, 2855.5195);
	angles[15] = (0, -48, 0);
	at[15] = 1.0500;
	points[16] = (216.4772, -12909.3311, 2809.0591);
	angles[16] = (0, -48, 0);
	at[16] = 1.1000;
	points[17] = (216.4772, -12909.3311, 2755.4214);
	angles[17] = (0, -48, 0);
	at[17] = 1.1500;
	points[18] = (216.4772, -12909.3311, 2575.4214);
	angles[18] = (0, -48, 0);
	at[18] = 1.2000;
	points[19] = (216.4772, -12909.3311, 2575.4214);
	angles[19] = (0, -48, 0);
	at[19] = 2.5000;
	points[20] = (216.4772, -12909.3311, 2752.5867);
	angles[20] = (0, -48, 0);
	at[20] = 2.5500;
	points[21] = (216.4772, -12909.3311, 2752.5867);
	angles[21] = (0, -48, 0);
	at[21] = 3.8333;
	mover = getEnt("iz_obj_21", "targetname");
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
