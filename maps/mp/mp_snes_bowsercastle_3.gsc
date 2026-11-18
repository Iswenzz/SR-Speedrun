main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_bowsercastle_3", 0);

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
	ambientPlay("iz_0_13", 2);
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
	level.iz_route[level.iz_route.size] = (-7495, -6503, 439);
	level.iz_route[level.iz_route.size] = (-7406, -6946, 439);
	level.iz_route[level.iz_route.size] = (-7140, -7315, 439);
	level.iz_route[level.iz_route.size] = (-6638, -7655, 439);
	level.iz_route[level.iz_route.size] = (-5930, -7802, 439);
	level.iz_route[level.iz_route.size] = (-2682, -7802, 439);
	level.iz_route[level.iz_route.size] = (-759, -7802, 439);
	level.iz_route[level.iz_route.size] = (492, -7799, 439);
	level.iz_route[level.iz_route.size] = (1198, -7805, 452);
	level.iz_route[level.iz_route.size] = (2195, -7791, 439);
	level.iz_route[level.iz_route.size] = (2576, -7802, 439);
	level.iz_route[level.iz_route.size] = (2867, -7794, 449);
	level.iz_route[level.iz_route.size] = (3710, -7812, 439);
	level.iz_route[level.iz_route.size] = (4118, -7791, 439);
	level.iz_route[level.iz_route.size] = (4612, -7773, 439);
	level.iz_route[level.iz_route.size] = (5025, -7596, 439);
	level.iz_route[level.iz_route.size] = (5335, -7271, 439);
	level.iz_route[level.iz_route.size] = (5430, -6735, 439);
	level.iz_route[level.iz_route.size] = (5423, -5912, 439);
	level.iz_route[level.iz_route.size] = (5448, -4733, 439);
	level.iz_route[level.iz_route.size] = (5487, -4074, 439);
	level.iz_route[level.iz_route.size] = (5507, -3550, 498);
	level.iz_route[level.iz_route.size] = (5873, -2450, 439);
	level.iz_route[level.iz_route.size] = (6013, -2189, 439);
	level.iz_route[level.iz_route.size] = (6093, -1869, 439);
	level.iz_route[level.iz_route.size] = (6099, -1514, 439);
	level.iz_route[level.iz_route.size] = (6086, -1021, 453);
	level.iz_route[level.iz_route.size] = (6185, -253, 439);
	level.iz_route[level.iz_route.size] = (6254, 85, 439);
	level.iz_route[level.iz_route.size] = (6362, 378, 439);
	level.iz_route[level.iz_route.size] = (6441, 691, 439);
	level.iz_route[level.iz_route.size] = (6464, 974, 439);
	level.iz_route[level.iz_route.size] = (6468, 1229, 456);
	level.iz_route[level.iz_route.size] = (6535, 1970, 439);
	level.iz_route[level.iz_route.size] = (6577, 2191, 439);
	level.iz_route[level.iz_route.size] = (6622, 2448, 439);
	level.iz_route[level.iz_route.size] = (6651, 2724, 439);
	level.iz_route[level.iz_route.size] = (6648, 2908, 458);
	level.iz_route[level.iz_route.size] = (6757, 3535, 439);
	level.iz_route[level.iz_route.size] = (6742, 4043, 439);
	level.iz_route[level.iz_route.size] = (6729, 4405, 450);
	level.iz_route[level.iz_route.size] = (6772, 5325, 439);
	level.iz_route[level.iz_route.size] = (6763, 5615, 439);
	level.iz_route[level.iz_route.size] = (6713, 5928, 439);
	level.iz_route[level.iz_route.size] = (6652, 6264, 439);
	level.iz_route[level.iz_route.size] = (6507, 6596, 439);
	level.iz_route[level.iz_route.size] = (6243, 6915, 439);
	level.iz_route[level.iz_route.size] = (5760, 7091, 439);
	level.iz_route[level.iz_route.size] = (5408, 7106, 439);
	level.iz_route[level.iz_route.size] = (2264, 7079, 439);
	level.iz_route[level.iz_route.size] = (1866, 7020, 439);
	level.iz_route[level.iz_route.size] = (1482, 6902, 439);
	level.iz_route[level.iz_route.size] = (1172, 6696, 439);
	level.iz_route[level.iz_route.size] = (1068, 6341, 439);
	level.iz_route[level.iz_route.size] = (1039, 3831, 439);
	level.iz_route[level.iz_route.size] = (1039, 1336, 439);
	level.iz_route[level.iz_route.size] = (1039, -1867, 439);
	level.iz_route[level.iz_route.size] = (1039, -2606, 439);
	level.iz_route[level.iz_route.size] = (921, -3019, 439);
	level.iz_route[level.iz_route.size] = (537, -3285, 439);
	level.iz_route[level.iz_route.size] = (-24, -3491, 439);
	level.iz_route[level.iz_route.size] = (-1766, -3196, 439);
	level.iz_route[level.iz_route.size] = (-2061, -3078, 439);
	level.iz_route[level.iz_route.size] = (-2209, -2812, 439);
	level.iz_route[level.iz_route.size] = (-2239, -2369, 439);
	level.iz_route[level.iz_route.size] = (-2239, -1011, 439);
	level.iz_route[level.iz_route.size] = (-2239, 495, 439);
	level.iz_route[level.iz_route.size] = (-2239, 2001, 439);
	level.iz_route[level.iz_route.size] = (-2239, 3418, 439);
	level.iz_route[level.iz_route.size] = (-2239, 4865, 439);
	level.iz_route[level.iz_route.size] = (-2239, 6046, 439);
	level.iz_route[level.iz_route.size] = (-2268, 6577, 439);
	level.iz_route[level.iz_route.size] = (-2534, 7020, 439);
	level.iz_route[level.iz_route.size] = (-3036, 7198, 439);
	level.iz_route[level.iz_route.size] = (-5379, 6791, 439);
	level.iz_route[level.iz_route.size] = (-5675, 6791, 439);
	level.iz_route[level.iz_route.size] = (-5926, 6733, 439);
	level.iz_route[level.iz_route.size] = (-6169, 6604, 439);
	level.iz_route[level.iz_route.size] = (-6432, 6276, 439);
	level.iz_route[level.iz_route.size] = (-6535, 5633, 439);
	level.iz_route[level.iz_route.size] = (-6579, 5160, 439);
	level.iz_route[level.iz_route.size] = (-6579, 4717, 439);
	level.iz_route[level.iz_route.size] = (-6579, 4245, 439);
	level.iz_route[level.iz_route.size] = (-6579, 3329, 439);
	level.iz_route[level.iz_route.size] = (-6934, 2798, 439);
	level.iz_route[level.iz_route.size] = (-7260, 2466, 439);
	level.iz_route[level.iz_route.size] = (-7369, 1976, 439);
	level.iz_route[level.iz_route.size] = (-7407, 1349, 439);
	level.iz_route[level.iz_route.size] = (-7465, -1138, 439);
	level.iz_route[level.iz_route.size] = (-7477, -3326, 439);
	level.iz_route[level.iz_route.size] = (-7517, -5314, 439);
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
	thread iz_obj_22();
	thread iz_obj_23();
	thread iz_obj_24();
	thread iz_obj_25();
	thread iz_obj_26();
	thread iz_obj_27();
	thread iz_obj_28();
	thread iz_obj_29();
	thread iz_obj_30();
	thread iz_obj_31();
	thread iz_obj_32();
	thread iz_obj_33();
	thread iz_obj_34();
	thread iz_obj_35();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2660.9529, -8242.4014, 664.3701);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (2660.9529, -8242.4014, 664.3701);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (2660.9529, -8242.4014, 672.0433);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (2660.9529, -8242.4014, 668.7992);
	angles[3] = (0, 90, 0);
	at[3] = 0.5500;
	points[4] = (2660.9529, -8242.4014, 656.6968);
	angles[4] = (0, 90, 0);
	at[4] = 0.6000;
	points[5] = (2660.9529, -8242.4014, 659.9410);
	angles[5] = (0, 90, 0);
	at[5] = 0.6500;
	points[6] = (2660.9529, -8242.4014, 672.0433);
	angles[6] = (0, 90, 0);
	at[6] = 0.7000;
	points[7] = (2660.9529, -8242.4014, 668.7992);
	angles[7] = (0, 90, 0);
	at[7] = 0.7500;
	points[8] = (2660.9529, -8242.4014, 656.6968);
	angles[8] = (0, 90, 0);
	at[8] = 0.8000;
	points[9] = (2660.9529, -8242.4014, 659.9410);
	angles[9] = (0, 90, 0);
	at[9] = 0.8500;
	points[10] = (2660.9529, -8242.4014, 672.0433);
	angles[10] = (0, 90, 0);
	at[10] = 0.9000;
	points[11] = (2660.9529, -8242.4014, 668.7992);
	angles[11] = (0, 90, 0);
	at[11] = 0.9500;
	points[12] = (2660.9529, -8242.4014, 674.7048);
	angles[12] = (0, 90, 0);
	at[12] = 1;
	points[13] = (2660.9529, -8242.4014, 807.5788);
	angles[13] = (0, 90, 0);
	at[13] = 1.1500;
	points[14] = (2660.9529, -8242.4014, 777.4606);
	angles[14] = (0, 90, 0);
	at[14] = 1.2000;
	points[15] = (2660.9529, -8242.4014, 702.1653);
	angles[15] = (0, 90, 0);
	at[15] = 1.2500;
	points[16] = (2660.9529, -8242.4014, 581.6929);
	angles[16] = (0, 90, 0);
	at[16] = 1.3000;
	points[17] = (2660.9529, -8242.4014, 439.3661);
	angles[17] = (0, 90, 0);
	at[17] = 1.3500;
	points[18] = (2660.9529, -8242.4014, 439.3661);
	angles[18] = (0, 90, 0);
	at[18] = 2.3500;
	points[19] = (2660.9529, -8242.4014, 660.8229);
	angles[19] = (0, 90, 0);
	at[19] = 3.6000;
	points[20] = (2660.9529, -8242.4014, 664.3701);
	angles[20] = (0, 90, 0);
	at[20] = 3.6500;
	points[21] = (2660.9529, -8242.4014, 664.3701);
	angles[21] = (0, 90, 0);
	at[21] = 4.1500;
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
	points[0] = (2660.9529, -7947.1260, 672.0433);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (2660.9529, -7947.1260, 659.9410);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (2660.9529, -7947.1260, 656.6968);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (2660.9529, -7947.1260, 668.7992);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (2660.9529, -7947.1260, 672.0433);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (2660.9529, -7947.1260, 659.9410);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (2660.9529, -7947.1260, 656.6968);
	angles[6] = (0, 90, 0);
	at[6] = 0.3000;
	points[7] = (2660.9529, -7947.1260, 668.7992);
	angles[7] = (0, 90, 0);
	at[7] = 0.3500;
	points[8] = (2660.9529, -7947.1260, 672.0433);
	angles[8] = (0, 90, 0);
	at[8] = 0.4000;
	points[9] = (2660.9529, -7947.1260, 659.9410);
	angles[9] = (0, 90, 0);
	at[9] = 0.4500;
	points[10] = (2660.9529, -7947.1260, 792.8150);
	angles[10] = (0, 90, 0);
	at[10] = 0.6000;
	points[11] = (2660.9529, -7947.1260, 792.5197);
	angles[11] = (0, 90, 0);
	at[11] = 0.6500;
	points[12] = (2660.9529, -7947.1260, 732.2835);
	angles[12] = (0, 90, 0);
	at[12] = 0.7000;
	points[13] = (2660.9529, -7947.1260, 626.8701);
	angles[13] = (0, 90, 0);
	at[13] = 0.7500;
	points[14] = (2660.9529, -7947.1260, 476.2795);
	angles[14] = (0, 90, 0);
	at[14] = 0.8000;
	points[15] = (2660.9529, -7947.1260, 439.3661);
	angles[15] = (0, 90, 0);
	at[15] = 0.8500;
	points[16] = (2660.9529, -7947.1260, 439.3661);
	angles[16] = (0, 90, 0);
	at[16] = 1.8000;
	points[17] = (2660.9529, -7947.1260, 445.2717);
	angles[17] = (0, 90, 0);
	at[17] = 1.8500;
	points[18] = (2660.9529, -7947.1260, 657.8701);
	angles[18] = (0, 90, 0);
	at[18] = 3.0500;
	points[19] = (2660.9529, -7947.1260, 664.3701);
	angles[19] = (0, 90, 0);
	at[19] = 3.1000;
	points[20] = (2660.9529, -7947.1260, 664.3701);
	angles[20] = (0, 90, 0);
	at[20] = 3.6000;
	points[21] = (2660.9529, -7947.1260, 672.0433);
	angles[21] = (0, 90, 0);
	at[21] = 3.7000;
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
	points[0] = (2660.9529, -7651.8501, 664.3701);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (2660.9529, -7651.8501, 664.3701);
	angles[1] = (0, 90, 0);
	at[1] = 0.6000;
	points[2] = (2660.9529, -7651.8501, 672.0433);
	angles[2] = (0, 90, 0);
	at[2] = 0.6500;
	points[3] = (2660.9529, -7651.8501, 668.7992);
	angles[3] = (0, 90, 0);
	at[3] = 0.7000;
	points[4] = (2660.9529, -7651.8501, 656.6968);
	angles[4] = (0, 90, 0);
	at[4] = 0.7500;
	points[5] = (2660.9529, -7651.8501, 659.9410);
	angles[5] = (0, 90, 0);
	at[5] = 0.8000;
	points[6] = (2660.9529, -7651.8501, 672.0433);
	angles[6] = (0, 90, 0);
	at[6] = 0.8500;
	points[7] = (2660.9529, -7651.8501, 668.7992);
	angles[7] = (0, 90, 0);
	at[7] = 0.9000;
	points[8] = (2660.9529, -7651.8501, 656.6968);
	angles[8] = (0, 90, 0);
	at[8] = 0.9500;
	points[9] = (2660.9529, -7651.8501, 659.9410);
	angles[9] = (0, 90, 0);
	at[9] = 1;
	points[10] = (2660.9529, -7651.8501, 672.0433);
	angles[10] = (0, 90, 0);
	at[10] = 1.0500;
	points[11] = (2660.9529, -7651.8501, 668.7992);
	angles[11] = (0, 90, 0);
	at[11] = 1.1000;
	points[12] = (2660.9529, -7651.8501, 674.7048);
	angles[12] = (0, 90, 0);
	at[12] = 1.1500;
	points[13] = (2660.9529, -7651.8501, 807.5788);
	angles[13] = (0, 90, 0);
	at[13] = 1.3000;
	points[14] = (2660.9529, -7651.8501, 777.4606);
	angles[14] = (0, 90, 0);
	at[14] = 1.3500;
	points[15] = (2660.9529, -7651.8501, 702.1653);
	angles[15] = (0, 90, 0);
	at[15] = 1.4000;
	points[16] = (2660.9529, -7651.8501, 581.6929);
	angles[16] = (0, 90, 0);
	at[16] = 1.4500;
	points[17] = (2660.9529, -7651.8501, 439.3661);
	angles[17] = (0, 90, 0);
	at[17] = 1.5000;
	points[18] = (2660.9529, -7651.8501, 439.3661);
	angles[18] = (0, 90, 0);
	at[18] = 2.5000;
	points[19] = (2660.9529, -7651.8501, 660.8229);
	angles[19] = (0, 90, 0);
	at[19] = 3.7500;
	points[20] = (2660.9529, -7651.8501, 664.3701);
	angles[20] = (0, 90, 0);
	at[20] = 3.8000;
	points[21] = (2660.9529, -7651.8501, 664.3701);
	angles[21] = (0, 90, 0);
	at[21] = 4.2833;
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
	points[0] = (2660.9529, -7356.5747, 527.9488);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (2660.9529, -7356.5747, 660.8229);
	angles[1] = (0, 90, 0);
	at[1] = 0.7500;
	points[2] = (2660.9529, -7356.5747, 664.3701);
	angles[2] = (0, 90, 0);
	at[2] = 0.8000;
	points[3] = (2660.9529, -7356.5747, 664.3701);
	angles[3] = (0, 90, 0);
	at[3] = 0.9500;
	points[4] = (2660.9529, -7356.5747, 672.0433);
	angles[4] = (0, 90, 0);
	at[4] = 1;
	points[5] = (2660.9529, -7356.5747, 668.7992);
	angles[5] = (0, 90, 0);
	at[5] = 1.0500;
	points[6] = (2660.9529, -7356.5747, 656.6968);
	angles[6] = (0, 90, 0);
	at[6] = 1.1000;
	points[7] = (2660.9529, -7356.5747, 659.9410);
	angles[7] = (0, 90, 0);
	at[7] = 1.1500;
	points[8] = (2660.9529, -7356.5747, 672.0433);
	angles[8] = (0, 90, 0);
	at[8] = 1.2000;
	points[9] = (2660.9529, -7356.5747, 668.7992);
	angles[9] = (0, 90, 0);
	at[9] = 1.2500;
	points[10] = (2660.9529, -7356.5747, 656.6968);
	angles[10] = (0, 90, 0);
	at[10] = 1.3000;
	points[11] = (2660.9529, -7356.5747, 659.9410);
	angles[11] = (0, 90, 0);
	at[11] = 1.3500;
	points[12] = (2660.9529, -7356.5747, 672.0433);
	angles[12] = (0, 90, 0);
	at[12] = 1.4000;
	points[13] = (2660.9529, -7356.5747, 668.7992);
	angles[13] = (0, 90, 0);
	at[13] = 1.4500;
	points[14] = (2660.9529, -7356.5747, 674.7048);
	angles[14] = (0, 90, 0);
	at[14] = 1.5000;
	points[15] = (2660.9529, -7356.5747, 807.5788);
	angles[15] = (0, 90, 0);
	at[15] = 1.6500;
	points[16] = (2660.9529, -7356.5747, 777.4606);
	angles[16] = (0, 90, 0);
	at[16] = 1.7000;
	points[17] = (2660.9529, -7356.5747, 702.1653);
	angles[17] = (0, 90, 0);
	at[17] = 1.7500;
	points[18] = (2660.9529, -7356.5747, 581.6929);
	angles[18] = (0, 90, 0);
	at[18] = 1.8000;
	points[19] = (2660.9529, -7356.5747, 439.3661);
	angles[19] = (0, 90, 0);
	at[19] = 1.8500;
	points[20] = (2660.9529, -7356.5747, 439.3661);
	angles[20] = (0, 90, 0);
	at[20] = 2.8500;
	points[21] = (2660.9529, -7356.5747, 527.9488);
	angles[21] = (0, 90, 0);
	at[21] = 3.3500;
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
	points[0] = (5023.1494, -1761.0945, 664.3701);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (5023.1494, -1761.0945, 664.3701);
	angles[1] = (0, -180, 0);
	at[1] = 0.6000;
	points[2] = (5023.1494, -1761.0945, 673.2284);
	angles[2] = (0, -180, 0);
	at[2] = 0.6500;
	points[3] = (5023.1494, -1761.0945, 655.5118);
	angles[3] = (0, -180, 0);
	at[3] = 0.7500;
	points[4] = (5023.1494, -1761.0945, 673.2284);
	angles[4] = (0, -180, 0);
	at[4] = 0.8500;
	points[5] = (5023.1494, -1761.0945, 655.5118);
	angles[5] = (0, -180, 0);
	at[5] = 0.9500;
	points[6] = (5023.1494, -1761.0945, 673.2284);
	angles[6] = (0, -180, 0);
	at[6] = 1.0500;
	points[7] = (5023.1494, -1761.0945, 664.3701);
	angles[7] = (0, -180, 0);
	at[7] = 1.1000;
	points[8] = (5023.1494, -1761.0945, 689.4686);
	angles[8] = (0, -180, 0);
	at[8] = 1.1500;
	points[9] = (5023.1494, -1761.0945, 778.0512);
	angles[9] = (0, -180, 0);
	at[9] = 1.2500;
	points[10] = (5023.1494, -1761.0945, 802.5591);
	angles[10] = (0, -180, 0);
	at[10] = 1.3000;
	points[11] = (5023.1494, -1761.0945, 757.3819);
	angles[11] = (0, -180, 0);
	at[11] = 1.3500;
	points[12] = (5023.1494, -1761.0945, 667.0275);
	angles[12] = (0, -180, 0);
	at[12] = 1.4000;
	points[13] = (5023.1494, -1761.0945, 531.4961);
	angles[13] = (0, -180, 0);
	at[13] = 1.4500;
	points[14] = (5023.1494, -1761.0945, 439.3701);
	angles[14] = (0, -180, 0);
	at[14] = 1.5000;
	points[15] = (5023.1494, -1761.0945, 439.3701);
	angles[15] = (0, -180, 0);
	at[15] = 2.4500;
	points[16] = (5023.1494, -1761.0945, 442.3228);
	angles[16] = (0, -180, 0);
	at[16] = 2.5000;
	points[17] = (5023.1494, -1761.0945, 663.7795);
	angles[17] = (0, -180, 0);
	at[17] = 3.7500;
	points[18] = (5023.1494, -1761.0945, 664.3701);
	angles[18] = (0, -180, 0);
	at[18] = 3.7833;
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
	points[0] = (6145.1968, -1185.3071, 664.3701);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (6145.1968, -1185.3071, 664.3701);
	angles[1] = (0, -180, 0);
	at[1] = 0.1500;
	points[2] = (6145.1968, -1185.3071, 672.0433);
	angles[2] = (0, -180, 0);
	at[2] = 0.2500;
	points[3] = (6145.1968, -1185.3071, 659.9410);
	angles[3] = (0, -180, 0);
	at[3] = 0.3000;
	points[4] = (6145.1968, -1185.3071, 656.6968);
	angles[4] = (0, -180, 0);
	at[4] = 0.3500;
	points[5] = (6145.1968, -1185.3071, 668.7992);
	angles[5] = (0, -180, 0);
	at[5] = 0.4000;
	points[6] = (6145.1968, -1185.3071, 672.0433);
	angles[6] = (0, -180, 0);
	at[6] = 0.4500;
	points[7] = (6145.1968, -1185.3071, 659.9410);
	angles[7] = (0, -180, 0);
	at[7] = 0.5000;
	points[8] = (6145.1968, -1185.3071, 656.6968);
	angles[8] = (0, -180, 0);
	at[8] = 0.5500;
	points[9] = (6145.1968, -1185.3071, 668.7992);
	angles[9] = (0, -180, 0);
	at[9] = 0.6000;
	points[10] = (6145.1968, -1185.3071, 672.0433);
	angles[10] = (0, -180, 0);
	at[10] = 0.6500;
	points[11] = (6145.1968, -1185.3071, 659.9410);
	angles[11] = (0, -180, 0);
	at[11] = 0.7000;
	points[12] = (6145.1968, -1185.3071, 792.8150);
	angles[12] = (0, -180, 0);
	at[12] = 0.8500;
	points[13] = (6145.1968, -1185.3071, 792.5197);
	angles[13] = (0, -180, 0);
	at[13] = 0.9000;
	points[14] = (6145.1968, -1185.3071, 732.2835);
	angles[14] = (0, -180, 0);
	at[14] = 0.9500;
	points[15] = (6145.1968, -1185.3071, 626.8701);
	angles[15] = (0, -180, 0);
	at[15] = 1;
	points[16] = (6145.1968, -1185.3071, 476.2795);
	angles[16] = (0, -180, 0);
	at[16] = 1.0500;
	points[17] = (6145.1968, -1185.3071, 439.3701);
	angles[17] = (0, -180, 0);
	at[17] = 1.1000;
	points[18] = (6145.1968, -1185.3071, 439.3701);
	angles[18] = (0, -180, 0);
	at[18] = 2.0500;
	points[19] = (6145.1968, -1185.3071, 445.2756);
	angles[19] = (0, -180, 0);
	at[19] = 2.1000;
	points[20] = (6145.1968, -1185.3071, 657.8740);
	angles[20] = (0, -180, 0);
	at[20] = 3.3000;
	points[21] = (6145.1968, -1185.3071, 664.3701);
	angles[21] = (0, -180, 0);
	at[21] = 3.3500;
	points[22] = (6145.1968, -1185.3071, 664.3701);
	angles[22] = (0, -180, 0);
	at[22] = 3.9000;
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
	points[0] = (4919.8032, 1678.8662, 569.2874);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (4919.8032, 1678.8662, 657.8701);
	angles[1] = (0, -180, 0);
	at[1] = 0.5000;
	points[2] = (4919.8032, 1678.8662, 664.3701);
	angles[2] = (0, -180, 0);
	at[2] = 0.5500;
	points[3] = (4919.8032, 1678.8662, 664.3701);
	angles[3] = (0, -180, 0);
	at[3] = 0.8500;
	points[4] = (4919.8032, 1678.8662, 672.0433);
	angles[4] = (0, -180, 0);
	at[4] = 0.9500;
	points[5] = (4919.8032, 1678.8662, 659.9410);
	angles[5] = (0, -180, 0);
	at[5] = 1;
	points[6] = (4919.8032, 1678.8662, 656.6968);
	angles[6] = (0, -180, 0);
	at[6] = 1.0500;
	points[7] = (4919.8032, 1678.8662, 668.7992);
	angles[7] = (0, -180, 0);
	at[7] = 1.1000;
	points[8] = (4919.8032, 1678.8662, 672.0433);
	angles[8] = (0, -180, 0);
	at[8] = 1.1500;
	points[9] = (4919.8032, 1678.8662, 659.9410);
	angles[9] = (0, -180, 0);
	at[9] = 1.2000;
	points[10] = (4919.8032, 1678.8662, 656.6968);
	angles[10] = (0, -180, 0);
	at[10] = 1.2500;
	points[11] = (4919.8032, 1678.8662, 668.7992);
	angles[11] = (0, -180, 0);
	at[11] = 1.3000;
	points[12] = (4919.8032, 1678.8662, 672.0433);
	angles[12] = (0, -180, 0);
	at[12] = 1.3500;
	points[13] = (4919.8032, 1678.8662, 659.9410);
	angles[13] = (0, -180, 0);
	at[13] = 1.4000;
	points[14] = (4919.8032, 1678.8662, 792.8150);
	angles[14] = (0, -180, 0);
	at[14] = 1.5500;
	points[15] = (4919.8032, 1678.8662, 792.5197);
	angles[15] = (0, -180, 0);
	at[15] = 1.6000;
	points[16] = (4919.8032, 1678.8662, 732.2835);
	angles[16] = (0, -180, 0);
	at[16] = 1.6500;
	points[17] = (4919.8032, 1678.8662, 626.8701);
	angles[17] = (0, -180, 0);
	at[17] = 1.7000;
	points[18] = (4919.8032, 1678.8662, 476.2795);
	angles[18] = (0, -180, 0);
	at[18] = 1.7500;
	points[19] = (4919.8032, 1678.8662, 439.3661);
	angles[19] = (0, -180, 0);
	at[19] = 1.8000;
	points[20] = (4919.8032, 1678.8662, 439.3661);
	angles[20] = (0, -180, 0);
	at[20] = 2.7500;
	points[21] = (4919.8032, 1678.8662, 445.2717);
	angles[21] = (0, -180, 0);
	at[21] = 2.8000;
	points[22] = (4919.8032, 1678.8662, 569.2874);
	angles[22] = (0, -180, 0);
	at[22] = 3.5000;
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
	points[0] = (5525.1182, 4188.7007, 664.3701);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (5525.1182, 4188.7007, 664.3701);
	angles[1] = (0, -180, 0);
	at[1] = 0.2500;
	points[2] = (5525.1182, 4188.7007, 672.0433);
	angles[2] = (0, -180, 0);
	at[2] = 0.3500;
	points[3] = (5525.1182, 4188.7007, 659.9410);
	angles[3] = (0, -180, 0);
	at[3] = 0.4000;
	points[4] = (5525.1182, 4188.7007, 656.6968);
	angles[4] = (0, -180, 0);
	at[4] = 0.4500;
	points[5] = (5525.1182, 4188.7007, 668.7992);
	angles[5] = (0, -180, 0);
	at[5] = 0.5000;
	points[6] = (5525.1182, 4188.7007, 672.0433);
	angles[6] = (0, -180, 0);
	at[6] = 0.5500;
	points[7] = (5525.1182, 4188.7007, 659.9410);
	angles[7] = (0, -180, 0);
	at[7] = 0.6000;
	points[8] = (5525.1182, 4188.7007, 656.6968);
	angles[8] = (0, -180, 0);
	at[8] = 0.6500;
	points[9] = (5525.1182, 4188.7007, 668.7992);
	angles[9] = (0, -180, 0);
	at[9] = 0.7000;
	points[10] = (5525.1182, 4188.7007, 672.0433);
	angles[10] = (0, -180, 0);
	at[10] = 0.7500;
	points[11] = (5525.1182, 4188.7007, 659.9410);
	angles[11] = (0, -180, 0);
	at[11] = 0.8000;
	points[12] = (5525.1182, 4188.7007, 792.8150);
	angles[12] = (0, -180, 0);
	at[12] = 0.9500;
	points[13] = (5525.1182, 4188.7007, 792.5197);
	angles[13] = (0, -180, 0);
	at[13] = 1;
	points[14] = (5525.1182, 4188.7007, 732.2835);
	angles[14] = (0, -180, 0);
	at[14] = 1.0500;
	points[15] = (5525.1182, 4188.7007, 626.8701);
	angles[15] = (0, -180, 0);
	at[15] = 1.1000;
	points[16] = (5525.1182, 4188.7007, 476.2795);
	angles[16] = (0, -180, 0);
	at[16] = 1.1500;
	points[17] = (5525.1182, 4188.7007, 439.3661);
	angles[17] = (0, -180, 0);
	at[17] = 1.2000;
	points[18] = (5525.1182, 4188.7007, 439.3661);
	angles[18] = (0, -180, 0);
	at[18] = 2.1500;
	points[19] = (5525.1182, 4188.7007, 445.2717);
	angles[19] = (0, -180, 0);
	at[19] = 2.2000;
	points[20] = (5525.1182, 4188.7007, 657.8701);
	angles[20] = (0, -180, 0);
	at[20] = 3.4000;
	points[21] = (5525.1182, 4188.7007, 664.3701);
	angles[21] = (0, -180, 0);
	at[21] = 3.4500;
	points[22] = (5525.1182, 4188.7007, 664.3701);
	angles[22] = (0, -180, 0);
	at[22] = 4.1500;
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
	points[0] = (1125.5197, -2602.6299, 664.3701);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1125.5197, -2602.6299, 664.3701);
	angles[1] = (0, 0, 0);
	at[1] = 0.7500;
	points[2] = (1125.5197, -2602.6299, 672.0433);
	angles[2] = (0, 0, 0);
	at[2] = 0.8000;
	points[3] = (1125.5197, -2602.6299, 668.7992);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (1125.5197, -2602.6299, 656.6968);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (1125.5197, -2602.6299, 659.9410);
	angles[5] = (0, 0, 0);
	at[5] = 0.9500;
	points[6] = (1125.5197, -2602.6299, 672.0433);
	angles[6] = (0, 0, 0);
	at[6] = 1;
	points[7] = (1125.5197, -2602.6299, 668.7992);
	angles[7] = (0, 0, 0);
	at[7] = 1.0500;
	points[8] = (1125.5197, -2602.6299, 656.6968);
	angles[8] = (0, 0, 0);
	at[8] = 1.1000;
	points[9] = (1125.5197, -2602.6299, 659.9410);
	angles[9] = (0, 0, 0);
	at[9] = 1.1500;
	points[10] = (1125.5197, -2602.6299, 672.0433);
	angles[10] = (0, 0, 0);
	at[10] = 1.2000;
	points[11] = (1125.5197, -2602.6299, 668.7992);
	angles[11] = (0, 0, 0);
	at[11] = 1.2500;
	points[12] = (1125.5197, -2602.6299, 674.7048);
	angles[12] = (0, 0, 0);
	at[12] = 1.3000;
	points[13] = (1125.5197, -2602.6299, 807.5788);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (1125.5197, -2602.6299, 777.4606);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (1125.5197, -2602.6299, 702.1653);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (1125.5197, -2602.6299, 581.6929);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (1125.5197, -2602.6299, 439.3740);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (1125.5197, -2602.6299, 439.3740);
	angles[18] = (0, 0, 0);
	at[18] = 2.6500;
	points[19] = (1125.5197, -2602.6299, 660.8307);
	angles[19] = (0, 0, 0);
	at[19] = 3.9000;
	points[20] = (1125.5197, -2602.6299, 664.3701);
	angles[20] = (0, 0, 0);
	at[20] = 3.9500;
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
	points[0] = (889.2992, -2602.6299, 664.3701);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (889.2992, -2602.6299, 664.3701);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (889.2992, -2602.6299, 673.2284);
	angles[2] = (0, 0, 0);
	at[2] = 0.3000;
	points[3] = (889.2992, -2602.6299, 655.5118);
	angles[3] = (0, 0, 0);
	at[3] = 0.4000;
	points[4] = (889.2992, -2602.6299, 673.2284);
	angles[4] = (0, 0, 0);
	at[4] = 0.5000;
	points[5] = (889.2992, -2602.6299, 655.5118);
	angles[5] = (0, 0, 0);
	at[5] = 0.6000;
	points[6] = (889.2992, -2602.6299, 673.2284);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (889.2992, -2602.6299, 664.3701);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (889.2992, -2602.6299, 689.4686);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (889.2992, -2602.6299, 778.0512);
	angles[9] = (0, 0, 0);
	at[9] = 0.9000;
	points[10] = (889.2992, -2602.6299, 802.5591);
	angles[10] = (0, 0, 0);
	at[10] = 0.9500;
	points[11] = (889.2992, -2602.6299, 757.3819);
	angles[11] = (0, 0, 0);
	at[11] = 1;
	points[12] = (889.2992, -2602.6299, 667.0275);
	angles[12] = (0, 0, 0);
	at[12] = 1.0500;
	points[13] = (889.2992, -2602.6299, 531.4961);
	angles[13] = (0, 0, 0);
	at[13] = 1.1000;
	points[14] = (889.2992, -2602.6299, 439.3740);
	angles[14] = (0, 0, 0);
	at[14] = 1.1500;
	points[15] = (889.2992, -2602.6299, 439.3740);
	angles[15] = (0, 0, 0);
	at[15] = 2.1000;
	points[16] = (889.2992, -2602.6299, 442.3268);
	angles[16] = (0, 0, 0);
	at[16] = 2.1500;
	points[17] = (889.2992, -2602.6299, 663.7834);
	angles[17] = (0, 0, 0);
	at[17] = 3.4000;
	points[18] = (889.2992, -2602.6299, 664.3701);
	angles[18] = (0, 0, 0);
	at[18] = 3.5500;
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
	points[0] = (-3805.5825, 5384.5674, 616.4803);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-3805.5825, 5384.5674, 660.7717);
	angles[1] = (0, -180, 0);
	at[1] = 0.2500;
	points[2] = (-3805.5825, 5384.5674, 664.3701);
	angles[2] = (0, -180, 0);
	at[2] = 0.3000;
	points[3] = (-3805.5825, 5384.5674, 664.3701);
	angles[3] = (0, -180, 0);
	at[3] = 0.9000;
	points[4] = (-3805.5825, 5384.5674, 672.0433);
	angles[4] = (0, -180, 0);
	at[4] = 0.9500;
	points[5] = (-3805.5825, 5384.5674, 668.7992);
	angles[5] = (0, -180, 0);
	at[5] = 1;
	points[6] = (-3805.5825, 5384.5674, 656.6968);
	angles[6] = (0, -180, 0);
	at[6] = 1.0500;
	points[7] = (-3805.5825, 5384.5674, 659.9410);
	angles[7] = (0, -180, 0);
	at[7] = 1.1000;
	points[8] = (-3805.5825, 5384.5674, 672.0433);
	angles[8] = (0, -180, 0);
	at[8] = 1.1500;
	points[9] = (-3805.5825, 5384.5674, 668.7992);
	angles[9] = (0, -180, 0);
	at[9] = 1.2000;
	points[10] = (-3805.5825, 5384.5674, 656.6968);
	angles[10] = (0, -180, 0);
	at[10] = 1.2500;
	points[11] = (-3805.5825, 5384.5674, 659.9410);
	angles[11] = (0, -180, 0);
	at[11] = 1.3000;
	points[12] = (-3805.5825, 5384.5674, 672.0433);
	angles[12] = (0, -180, 0);
	at[12] = 1.3500;
	points[13] = (-3805.5825, 5384.5674, 668.7992);
	angles[13] = (0, -180, 0);
	at[13] = 1.4000;
	points[14] = (-3805.5825, 5384.5674, 674.7048);
	angles[14] = (0, -180, 0);
	at[14] = 1.4500;
	points[15] = (-3805.5825, 5384.5674, 807.5788);
	angles[15] = (0, -180, 0);
	at[15] = 1.6000;
	points[16] = (-3805.5825, 5384.5674, 777.4606);
	angles[16] = (0, -180, 0);
	at[16] = 1.6500;
	points[17] = (-3805.5825, 5384.5674, 702.1653);
	angles[17] = (0, -180, 0);
	at[17] = 1.7000;
	points[18] = (-3805.5825, 5384.5674, 581.6929);
	angles[18] = (0, -180, 0);
	at[18] = 1.7500;
	points[19] = (-3805.5825, 5384.5674, 439.3150);
	angles[19] = (0, -180, 0);
	at[19] = 1.8000;
	points[20] = (-3805.5825, 5384.5674, 439.3150);
	angles[20] = (0, -180, 0);
	at[20] = 2.8000;
	points[21] = (-3805.5825, 5384.5674, 616.4803);
	angles[21] = (0, -180, 0);
	at[21] = 3.8000;
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
	points[0] = (-2284.9133, 6565.6694, 660.7638);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-2284.9133, 6565.6694, 664.3701);
	angles[1] = (0, -180, 0);
	at[1] = 0.0500;
	points[2] = (-2284.9133, 6565.6694, 664.3701);
	angles[2] = (0, -180, 0);
	at[2] = 0.3000;
	points[3] = (-2284.9133, 6565.6694, 673.2284);
	angles[3] = (0, -180, 0);
	at[3] = 0.3500;
	points[4] = (-2284.9133, 6565.6694, 655.5118);
	angles[4] = (0, -180, 0);
	at[4] = 0.4500;
	points[5] = (-2284.9133, 6565.6694, 673.2284);
	angles[5] = (0, -180, 0);
	at[5] = 0.5500;
	points[6] = (-2284.9133, 6565.6694, 655.5118);
	angles[6] = (0, -180, 0);
	at[6] = 0.6500;
	points[7] = (-2284.9133, 6565.6694, 673.2284);
	angles[7] = (0, -180, 0);
	at[7] = 0.7500;
	points[8] = (-2284.9133, 6565.6694, 664.3701);
	angles[8] = (0, -180, 0);
	at[8] = 0.8000;
	points[9] = (-2284.9133, 6565.6694, 689.4686);
	angles[9] = (0, -180, 0);
	at[9] = 0.8500;
	points[10] = (-2284.9133, 6565.6694, 778.0512);
	angles[10] = (0, -180, 0);
	at[10] = 0.9500;
	points[11] = (-2284.9133, 6565.6694, 802.5591);
	angles[11] = (0, -180, 0);
	at[11] = 1;
	points[12] = (-2284.9133, 6565.6694, 757.3819);
	angles[12] = (0, -180, 0);
	at[12] = 1.0500;
	points[13] = (-2284.9133, 6565.6694, 667.0275);
	angles[13] = (0, -180, 0);
	at[13] = 1.1000;
	points[14] = (-2284.9133, 6565.6694, 531.4961);
	angles[14] = (0, -180, 0);
	at[14] = 1.1500;
	points[15] = (-2284.9133, 6565.6694, 439.3071);
	angles[15] = (0, -180, 0);
	at[15] = 1.2000;
	points[16] = (-2284.9133, 6565.6694, 439.3071);
	angles[16] = (0, -180, 0);
	at[16] = 2.1500;
	points[17] = (-2284.9133, 6565.6694, 442.2599);
	angles[17] = (0, -180, 0);
	at[17] = 2.2000;
	points[18] = (-2284.9133, 6565.6694, 660.7638);
	angles[18] = (0, -180, 0);
	at[18] = 3.4333;
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
	points[0] = (-7083.1499, 2062.7244, 610.5670);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7083.1499, 2062.7244, 663.7166);
	angles[1] = (0, 0, 0);
	at[1] = 0.3000;
	points[2] = (-7083.1499, 2062.7244, 664.3701);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-7083.1499, 2062.7244, 672.0433);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (-7083.1499, 2062.7244, 659.9410);
	angles[4] = (0, 0, 0);
	at[4] = 0.8000;
	points[5] = (-7083.1499, 2062.7244, 656.6968);
	angles[5] = (0, 0, 0);
	at[5] = 0.8500;
	points[6] = (-7083.1499, 2062.7244, 668.7992);
	angles[6] = (0, 0, 0);
	at[6] = 0.9000;
	points[7] = (-7083.1499, 2062.7244, 672.0433);
	angles[7] = (0, 0, 0);
	at[7] = 0.9500;
	points[8] = (-7083.1499, 2062.7244, 659.9410);
	angles[8] = (0, 0, 0);
	at[8] = 1;
	points[9] = (-7083.1499, 2062.7244, 656.6968);
	angles[9] = (0, 0, 0);
	at[9] = 1.0500;
	points[10] = (-7083.1499, 2062.7244, 668.7992);
	angles[10] = (0, 0, 0);
	at[10] = 1.1000;
	points[11] = (-7083.1499, 2062.7244, 672.0433);
	angles[11] = (0, 0, 0);
	at[11] = 1.1500;
	points[12] = (-7083.1499, 2062.7244, 659.9410);
	angles[12] = (0, 0, 0);
	at[12] = 1.2000;
	points[13] = (-7083.1499, 2062.7244, 792.8150);
	angles[13] = (0, 0, 0);
	at[13] = 1.3500;
	points[14] = (-7083.1499, 2062.7244, 792.5197);
	angles[14] = (0, 0, 0);
	at[14] = 1.4000;
	points[15] = (-7083.1499, 2062.7244, 732.2835);
	angles[15] = (0, 0, 0);
	at[15] = 1.4500;
	points[16] = (-7083.1499, 2062.7244, 626.8701);
	angles[16] = (0, 0, 0);
	at[16] = 1.5000;
	points[17] = (-7083.1499, 2062.7244, 476.2795);
	angles[17] = (0, 0, 0);
	at[17] = 1.5500;
	points[18] = (-7083.1499, 2062.7244, 439.3071);
	angles[18] = (0, 0, 0);
	at[18] = 1.6000;
	points[19] = (-7083.1499, 2062.7244, 439.3071);
	angles[19] = (0, 0, 0);
	at[19] = 2.5500;
	points[20] = (-7083.1499, 2062.7244, 445.2126);
	angles[20] = (0, 0, 0);
	at[20] = 2.6000;
	points[21] = (-7083.1499, 2062.7244, 610.5670);
	angles[21] = (0, 0, 0);
	at[21] = 3.5333;
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
	points[0] = (-7304.6064, 2062.7244, 673.2284);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7304.6064, 2062.7244, 655.5118);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (-7304.6064, 2062.7244, 673.2284);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (-7304.6064, 2062.7244, 664.3701);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-7304.6064, 2062.7244, 689.4686);
	angles[4] = (0, 0, 0);
	at[4] = 0.3000;
	points[5] = (-7304.6064, 2062.7244, 778.0512);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (-7304.6064, 2062.7244, 802.5591);
	angles[6] = (0, 0, 0);
	at[6] = 0.4500;
	points[7] = (-7304.6064, 2062.7244, 757.3819);
	angles[7] = (0, 0, 0);
	at[7] = 0.5000;
	points[8] = (-7304.6064, 2062.7244, 667.0275);
	angles[8] = (0, 0, 0);
	at[8] = 0.5500;
	points[9] = (-7304.6064, 2062.7244, 531.4961);
	angles[9] = (0, 0, 0);
	at[9] = 0.6000;
	points[10] = (-7304.6064, 2062.7244, 439.3701);
	angles[10] = (0, 0, 0);
	at[10] = 0.6500;
	points[11] = (-7304.6064, 2062.7244, 439.3701);
	angles[11] = (0, 0, 0);
	at[11] = 1.6000;
	points[12] = (-7304.6064, 2062.7244, 442.3228);
	angles[12] = (0, 0, 0);
	at[12] = 1.6500;
	points[13] = (-7304.6064, 2062.7244, 663.7795);
	angles[13] = (0, 0, 0);
	at[13] = 2.9000;
	points[14] = (-7304.6064, 2062.7244, 664.3701);
	angles[14] = (0, 0, 0);
	at[14] = 3;
	points[15] = (-7304.6064, 2062.7244, 672.0433);
	angles[15] = (0, 0, 0);
	at[15] = 3.0500;
	points[16] = (-7304.6064, 2062.7244, 668.7992);
	angles[16] = (0, 0, 0);
	at[16] = 3.1000;
	points[17] = (-7304.6064, 2062.7244, 656.6968);
	angles[17] = (0, 0, 0);
	at[17] = 3.1500;
	points[18] = (-7304.6064, 2062.7244, 659.9410);
	angles[18] = (0, 0, 0);
	at[18] = 3.2000;
	points[19] = (-7304.6064, 2062.7244, 672.0433);
	angles[19] = (0, 0, 0);
	at[19] = 3.2500;
	points[20] = (-7304.6064, 2062.7244, 673.2284);
	angles[20] = (0, 0, 0);
	at[20] = 3.2667;
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
	points[0] = (5455.8271, -3159.4490, 291.4370);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (5989.9609, -3159.4490, 291.4370);
	angles[1] = (0, -90, 0);
	at[1] = 3.3500;
	points[2] = (5991.2598, -3159.4490, 292.9382);
	angles[2] = (0, -90, 19.1587);
	at[2] = 3.4000;
	points[3] = (5984.1733, -3159.4490, 296.7370);
	angles[3] = (0, -90, 59.9666);
	at[3] = 3.4500;
	points[4] = (5976.9292, -3159.4490, 300.6000);
	angles[4] = (0, 90, 81.2728);
	at[4] = 3.5000;
	points[5] = (5969.5278, -3159.4490, 304.5291);
	angles[5] = (0, 90, 56.3388);
	at[5] = 3.5500;
	points[6] = (5962.0474, -3159.4490, 308.5252);
	angles[6] = (0, 90, 42.6920);
	at[6] = 3.6000;
	points[7] = (5946.6934, -3159.4490, 316.7224);
	angles[7] = (0, 90, 31.9179);
	at[7] = 3.7000;
	points[8] = (5897.3232, -3159.4490, 343.0441);
	angles[8] = (0, 90, 28.1417);
	at[8] = 4;
	points[9] = (5852.2046, -3159.4490, 367.1114);
	angles[9] = (0, 90, 28.0749);
	at[9] = 4.2500;
	points[10] = (5792.7559, -3159.4490, 398.8071);
	angles[10] = (0, 90, 28.0726);
	at[10] = 4.5500;
	points[11] = (5738.4253, -3159.4490, 427.7914);
	angles[11] = (0, 90, 28.0726);
	at[11] = 4.8000;
	points[12] = (5666.8506, -3159.4490, 465.9606);
	angles[12] = (0, 90, 28.0726);
	at[12] = 5.1000;
	points[13] = (5601.4175, -3159.4490, 500.8622);
	angles[13] = (0, 90, 28.0726);
	at[13] = 5.3500;
	points[14] = (5530.2363, -3159.4490, 538.8386);
	angles[14] = (0, 90, 28.0726);
	at[14] = 5.6000;
	points[15] = (5452.7163, -3159.4490, 580.1614);
	angles[15] = (0, 90, 28.0726);
	at[15] = 5.8500;
	points[16] = (5436.4565, -3159.4490, 588.8543);
	angles[16] = (0, 90, 17.7446);
	at[16] = 5.9000;
	points[17] = (5420.1973, -3159.4490, 575.9016);
	angles[17] = (0, 90, -3.9688);
	at[17] = 5.9500;
	points[18] = (5404.2124, -3159.4490, 567.3819);
	angles[18] = (0, 90, -15.6407);
	at[18] = 6;
	points[19] = (5373.0317, -3159.4490, 550.7638);
	angles[19] = (0, 90, -24.8057);
	at[19] = 6.1000;
	points[20] = (5299.6455, -3159.4490, 511.6102);
	angles[20] = (0, 90, -27.9575);
	at[20] = 6.3500;
	points[21] = (5232.2046, -3159.4490, 475.6457);
	angles[21] = (0, 90, -28.0684);
	at[21] = 6.6000;
	points[22] = (5170.2363, -3159.4490, 442.6063);
	angles[22] = (0, 90, -28.0724);
	at[22] = 6.8500;
	points[23] = (5113.3462, -3159.4490, 412.2599);
	angles[23] = (0, 90, -28.0726);
	at[23] = 7.1000;
	points[24] = (5051.1416, -3159.4490, 379.0905);
	angles[24] = (0, 90, -28.0726);
	at[24] = 7.4000;
	points[25] = (4995, -3159.4490, 349.1339);
	angles[25] = (0, 90, -28.0726);
	at[25] = 7.7000;
	points[26] = (4944.2520, -3159.4490, 322.0807);
	angles[26] = (0, 90, -28.0726);
	at[26] = 8;
	points[27] = (4891.2598, -3159.4490, 293.8138);
	angles[27] = (0, 90, -28.0726);
	at[27] = 8.3500;
	points[28] = (4889.7637, -3159.4490, 291.4370);
	angles[28] = (0, 90, -47.2312);
	at[28] = 8.4000;
	points[29] = (4897.7559, -3159.4490, 291.4370);
	angles[29] = (0, 90, -88.0393);
	at[29] = 8.4500;
	points[30] = (4905.7090, -3159.4490, 291.4370);
	angles[30] = (0, 270, -53.2004);
	at[30] = 8.5000;
	points[31] = (4913.7007, -3159.4490, 291.4370);
	angles[31] = (0, 270, -28.2664);
	at[31] = 8.5500;
	points[32] = (4921.6538, -3159.4490, 291.4370);
	angles[32] = (0, 270, -14.6194);
	at[32] = 8.6000;
	points[33] = (4937.5986, -3159.4490, 291.4370);
	angles[33] = (0, 270, -3.8454);
	at[33] = 8.7000;
	points[34] = (4953.5435, -3159.4490, 291.4370);
	angles[34] = (0, 270, -1.0083);
	at[34] = 8.8000;
	points[35] = (5455.8271, -3159.4490, 291.4370);
	angles[35] = (0, 270, 0);
	at[35] = 11.9500;
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
	points[0] = (5585.3154, -3159.4490, 354.9087);
	angles[0] = (0, 90, 58.6588);
	at[0] = 0;
	points[1] = (5556.1421, -3159.4490, 401.6378);
	angles[1] = (0, 90, 58.0179);
	at[1] = 0.2500;
	points[2] = (5522.1260, -3159.4490, 456.0354);
	angles[2] = (0, 90, 57.9955);
	at[2] = 0.5000;
	points[3] = (5482.5591, -3159.4490, 519.3504);
	angles[3] = (0, 90, 57.9946);
	at[3] = 0.7500;
	points[4] = (5446.2603, -3159.4490, 577.4016);
	angles[4] = (0, 90, 57.9946);
	at[4] = 0.9500;
	points[5] = (5436.4966, -3159.4490, 580.3976);
	angles[5] = (0, 90, 29.3690);
	at[5] = 1;
	points[6] = (5426.8501, -3159.4490, 564.9764);
	angles[6] = (0, 90, -8.1331);
	at[6] = 1.0500;
	points[7] = (5417.5195, -3159.4490, 550.0157);
	angles[7] = (0, 90, -31.6263);
	at[7] = 1.1000;
	points[8] = (5408.4648, -3159.4490, 535.5118);
	angles[8] = (0, 90, -44.3750);
	at[8] = 1.1500;
	points[9] = (5391.1416, -3159.4490, 507.7992);
	angles[9] = (0, 90, -54.4138);
	at[9] = 1.2500;
	points[10] = (5352.2046, -3159.4490, 445.5276);
	angles[10] = (0, 90, -57.8686);
	at[10] = 1.5000;
	points[11] = (5318.8193, -3159.4490, 392.1138);
	angles[11] = (0, 90, -57.9902);
	at[11] = 1.7500;
	points[12] = (5284.9609, -3159.4490, 337.9461);
	angles[12] = (0, 90, -57.9946);
	at[12] = 2.0500;
	points[13] = (5256.8110, -3159.4490, 292.8870);
	angles[13] = (0, 90, -57.9946);
	at[13] = 2.3500;
	points[14] = (5262.1655, -3159.4490, 291.4370);
	angles[14] = (0, 270, -79.5939);
	at[14] = 2.4000;
	points[15] = (5270.1577, -3159.4490, 291.4370);
	angles[15] = (0, 270, -44.5044);
	at[15] = 2.4500;
	points[16] = (5278.1104, -3159.4490, 291.4370);
	angles[16] = (0, 270, -23.3759);
	at[16] = 2.5000;
	points[17] = (5286.1025, -3159.4490, 291.4370);
	angles[17] = (0, 270, -12.0512);
	at[17] = 2.5500;
	points[18] = (5302.0474, -3159.4490, 291.4370);
	angles[18] = (0, 270, -3.1664);
	at[18] = 2.6500;
	points[19] = (5341.9292, -3159.4490, 291.4370);
	angles[19] = (0, 270, -0.1114);
	at[19] = 2.9000;
	points[20] = (5620.9453, -3159.4490, 291.4370);
	angles[20] = (0, 270, 0);
	at[20] = 4.6500;
	points[21] = (5622.3232, -3159.4490, 295.7181);
	angles[21] = (0, 270, 28.1773);
	at[21] = 4.7000;
	points[22] = (5617.9927, -3159.4490, 302.6795);
	angles[22] = (0, 270, 67.4083);
	at[22] = 4.7500;
	points[23] = (5613.5039, -3159.4490, 309.8559);
	angles[23] = (0, 90, 87.0632);
	at[23] = 4.8000;
	points[24] = (5608.8584, -3159.4490, 317.2540);
	angles[24] = (0, 90, 73.0379);
	at[24] = 4.8500;
	points[25] = (5604.0942, -3159.4490, 324.8795);
	angles[25] = (0, 90, 65.7187);
	at[25] = 4.9000;
	points[26] = (5585.3154, -3159.4490, 354.9087);
	angles[26] = (0, 90, 58.6588);
	at[26] = 5.0833;
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
	points[0] = (5557.3623, -3159.4490, 291.4370);
	angles[0] = (0, 90, -0.5313);
	at[0] = 0;
	points[1] = (5262.3623, -3159.4490, 291.4370);
	angles[1] = (0, 90, 0);
	at[1] = 1.8500;
	points[2] = (5253.2676, -3159.4490, 291.4370);
	angles[2] = (0, 90, 13.7328);
	at[2] = 1.9000;
	points[3] = (5261.6143, -3159.4490, 300.5567);
	angles[3] = (0, 90, 55.6506);
	at[3] = 1.9500;
	points[4] = (5266.0630, -3159.4490, 307.6677);
	angles[4] = (0, 90, 85.9602);
	at[4] = 2;
	points[5] = (5270.6299, -3159.4490, 314.9977);
	angles[5] = (0, -90, 76.7581);
	at[5] = 2.0500;
	points[6] = (5275.3545, -3159.4490, 322.5540);
	angles[6] = (0, -90, 67.6442);
	at[6] = 2.1000;
	points[7] = (5285.2363, -3159.4490, 338.3729);
	angles[7] = (0, -90, 60.5280);
	at[7] = 2.2000;
	points[8] = (5312.7559, -3159.4490, 382.3910);
	angles[8] = (0, -90, 58.0837);
	at[8] = 2.4500;
	points[9] = (5344.7642, -3159.4490, 433.6299);
	angles[9] = (0, -90, 57.9977);
	at[9] = 2.7000;
	points[10] = (5390.1968, -3159.4490, 506.3228);
	angles[10] = (0, -90, 57.9946);
	at[10] = 3;
	points[11] = (5434.9214, -3159.4490, 577.8858);
	angles[11] = (0, -90, 57.9946);
	at[11] = 3.2500;
	points[12] = (5444.7246, -3159.4490, 579.9055);
	angles[12] = (0, -90, 29.3690);
	at[12] = 3.3000;
	points[13] = (5454.3306, -3159.4490, 564.4960);
	angles[13] = (0, -90, -8.1331);
	at[13] = 3.3500;
	points[14] = (5463.6611, -3159.4490, 549.5551);
	angles[14] = (0, -90, -31.6263);
	at[14] = 3.4000;
	points[15] = (5472.7168, -3159.4490, 535.0630);
	angles[15] = (0, -90, -44.3750);
	at[15] = 3.4500;
	points[16] = (5481.5356, -3159.4490, 521.0079);
	angles[16] = (0, -90, -51.0052);
	at[16] = 3.5000;
	points[17] = (5498.3071, -3159.4490, 494.1614);
	angles[17] = (0, -90, -56.1609);
	at[17] = 3.6000;
	points[18] = (5521.6138, -3159.4490, 456.8583);
	angles[18] = (0, -90, -57.7485);
	at[18] = 3.7500;
	points[19] = (5562.2832, -3159.4490, 391.8032);
	angles[19] = (0, -90, -57.9901);
	at[19] = 4.0500;
	points[20] = (5596.1025, -3159.4490, 337.6878);
	angles[20] = (0, -90, -57.9946);
	at[20] = 4.3500;
	points[21] = (5624.2124, -3159.4490, 292.6721);
	angles[21] = (0, -90, -57.9946);
	at[21] = 4.6500;
	points[22] = (5618.4648, -3159.4490, 291.4370);
	angles[22] = (0, -270, -79.5939);
	at[22] = 4.7000;
	points[23] = (5610.5122, -3159.4490, 291.4370);
	angles[23] = (0, -270, -44.5044);
	at[23] = 4.7500;
	points[24] = (5602.5200, -3159.4490, 291.4370);
	angles[24] = (0, -270, -23.3759);
	at[24] = 4.8000;
	points[25] = (5594.5674, -3159.4490, 291.4370);
	angles[25] = (0, -270, -12.0512);
	at[25] = 4.8500;
	points[26] = (5578.6226, -3159.4490, 291.4370);
	angles[26] = (0, -270, -3.1664);
	at[26] = 4.9500;
	points[27] = (5557.3623, -3159.4490, 291.4370);
	angles[27] = (0, -270, -0.5313);
	at[27] = 5.0833;
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
	points[0] = (6422.0869, -930.1181, 428.9922);
	angles[0] = (0, 90, 89.8942);
	at[0] = 0;
	points[1] = (6422.0083, -930.1181, 507.4055);
	angles[1] = (0, 90, 89.9503);
	at[1] = 0.2500;
	points[2] = (6421.9683, -930.1181, 581.0551);
	angles[2] = (0, 90, 89.9521);
	at[2] = 0.5000;
	points[3] = (6424.1343, -930.1181, 584.5276);
	angles[3] = (0, -90, 73.9711);
	at[3] = 0.5500;
	points[4] = (6422.2441, -930.1181, 575.4685);
	angles[4] = (0, -90, 53.4678);
	at[4] = 0.6000;
	points[5] = (6422.2441, -930.1181, 566.7284);
	angles[5] = (0, -90, 16.6016);
	at[5] = 0.6500;
	points[6] = (6422.2441, -930.1181, 557.4882);
	angles[6] = (0, -90, -25.0996);
	at[6] = 0.7000;
	points[7] = (6422.2441, -930.1181, 547.7244);
	angles[7] = (0, -90, -54.8311);
	at[7] = 0.7500;
	points[8] = (6422.2837, -930.1181, 537.4055);
	angles[8] = (0, -90, -71.6948);
	at[8] = 0.8000;
	points[9] = (6422.2837, -930.1181, 526.5000);
	angles[9] = (0, -90, -80.5750);
	at[9] = 0.8500;
	points[10] = (6422.2837, -930.1181, 502.7992);
	angles[10] = (0, -90, -87.5057);
	at[10] = 0.9500;
	points[11] = (6422.2837, -930.1181, 476.3268);
	angles[11] = (0, -90, -89.3259);
	at[11] = 1.0500;
	points[12] = (6422.3228, -930.1181, 430.7165);
	angles[12] = (0, -90, -89.8859);
	at[12] = 1.2000;
	points[13] = (6422.3623, -930.1181, 376.8827);
	angles[13] = (0, -90, -89.9611);
	at[13] = 1.3500;
	points[14] = (6422.3623, -930.1181, 313.3496);
	angles[14] = (0, -90, -89.9711);
	at[14] = 1.5000;
	points[15] = (6422.4014, -930.1181, 238.3673);
	angles[15] = (0, -90, -89.9725);
	at[15] = 1.6500;
	points[16] = (6422.4414, -930.1181, 149.8728);
	angles[16] = (0, -90, -89.9727);
	at[16] = 1.8000;
	points[17] = (6422.5200, -930.1181, 45.4315);
	angles[17] = (0, -90, -89.9727);
	at[17] = 1.9500;
	points[18] = (6422.5591, -930.1181, -34.4545);
	angles[18] = (0, -90, -89.9849);
	at[18] = 2.0500;
	points[19] = (6422.4805, -930.1181, 8.8840);
	angles[19] = (0, -270, -89.9487);
	at[19] = 2.1000;
	points[20] = (6422.4414, -930.1181, 46.4512);
	angles[20] = (0, -270, -89.7912);
	at[20] = 2.1500;
	points[21] = (6422.3623, -930.1181, 112.0303);
	angles[21] = (0, -270, -88.5332);
	at[21] = 2.2500;
	points[22] = (6422.3228, -930.1181, 166.6559);
	angles[22] = (0, -270, -81.4863);
	at[22] = 2.3500;
	points[23] = (6422.2837, -930.1181, 190.4453);
	angles[23] = (0, -270, -69.9761);
	at[23] = 2.4000;
	points[24] = (6422.2837, -930.1181, 212.1575);
	angles[24] = (0, -270, -45.2506);
	at[24] = 2.4500;
	points[25] = (6422.2441, -930.1181, 250.5138);
	angles[25] = (0, -270, 34.4202);
	at[25] = 2.5500;
	points[26] = (6422.2046, -930.1181, 268.8134);
	angles[26] = (0, -270, 60.3438);
	at[26] = 2.6000;
	points[27] = (6422.2046, -930.1181, 286.8846);
	angles[27] = (0, -270, 74.6236);
	at[27] = 2.6500;
	points[28] = (6422.1655, -930.1181, 304.7311);
	angles[28] = (0, -270, 82.0808);
	at[28] = 2.7000;
	points[29] = (6422.1655, -930.1181, 339.7606);
	angles[29] = (0, -270, 87.8868);
	at[29] = 2.8000;
	points[30] = (6422.0869, -930.1181, 428.9922);
	angles[30] = (0, -270, 89.8942);
	at[30] = 3.0667;
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
	points[0] = (4650.5908, -1461.6141, 547.7244);
	angles[0] = (0, -90, -54.8312);
	at[0] = 0;
	points[1] = (4650.6299, -1461.6141, 537.4055);
	angles[1] = (0, -90, -71.6948);
	at[1] = 0.0500;
	points[2] = (4650.6299, -1461.6141, 526.5000);
	angles[2] = (0, -90, -80.5751);
	at[2] = 0.1000;
	points[3] = (4650.6299, -1461.6141, 514.9764);
	angles[3] = (0, -90, -85.1558);
	at[3] = 0.1500;
	points[4] = (4650.6299, -1461.6141, 476.3268);
	angles[4] = (0, -90, -89.3259);
	at[4] = 0.3000;
	points[5] = (4650.6694, -1461.6141, 446.7677);
	angles[5] = (0, -90, -89.8031);
	at[5] = 0.4000;
	points[6] = (4650.7085, -1461.6141, 376.8827);
	angles[6] = (0, -90, -89.9611);
	at[6] = 0.6000;
	points[7] = (4650.7085, -1461.6141, 313.3496);
	angles[7] = (0, -90, -89.9711);
	at[7] = 0.7500;
	points[8] = (4650.7480, -1461.6141, 238.3673);
	angles[8] = (0, -90, -89.9725);
	at[8] = 0.9000;
	points[9] = (4650.7871, -1461.6141, 149.8728);
	angles[9] = (0, -90, -89.9727);
	at[9] = 1.0500;
	points[10] = (4650.8662, -1461.6141, 45.4315);
	angles[10] = (0, -90, -89.9727);
	at[10] = 1.2000;
	points[11] = (4650.9058, -1461.6141, -34.4545);
	angles[11] = (0, -90, -89.9849);
	at[11] = 1.3000;
	points[12] = (4650.8267, -1461.6141, 8.8840);
	angles[12] = (0, -270, -89.9487);
	at[12] = 1.3500;
	points[13] = (4650.7871, -1461.6141, 46.4512);
	angles[13] = (0, -270, -89.7912);
	at[13] = 1.4000;
	points[14] = (4650.7085, -1461.6141, 112.0303);
	angles[14] = (0, -270, -88.5332);
	at[14] = 1.5000;
	points[15] = (4650.6694, -1461.6141, 166.6559);
	angles[15] = (0, -270, -81.4863);
	at[15] = 1.6000;
	points[16] = (4650.6299, -1461.6141, 190.4453);
	angles[16] = (0, -270, -69.9761);
	at[16] = 1.6500;
	points[17] = (4650.6299, -1461.6141, 212.1575);
	angles[17] = (0, -270, -45.2506);
	at[17] = 1.7000;
	points[18] = (4650.5908, -1461.6141, 250.5138);
	angles[18] = (0, -270, 34.4202);
	at[18] = 1.8000;
	points[19] = (4650.5513, -1461.6141, 268.8134);
	angles[19] = (0, -270, 60.3438);
	at[19] = 1.8500;
	points[20] = (4650.5513, -1461.6141, 286.8846);
	angles[20] = (0, -270, 74.6236);
	at[20] = 1.9000;
	points[21] = (4650.5117, -1461.6141, 304.7311);
	angles[21] = (0, -270, 82.0808);
	at[21] = 1.9500;
	points[22] = (4650.4727, -1461.6141, 356.9488);
	angles[22] = (0, -270, 88.8947);
	at[22] = 2.1000;
	points[23] = (4650.4331, -1461.6141, 439.7323);
	angles[23] = (0, -270, 89.9150);
	at[23] = 2.3500;
	points[24] = (4650.3149, -1461.6141, 576.2874);
	angles[24] = (0, -270, 89.9521);
	at[24] = 2.8000;
	points[25] = (4650.2754, -1461.6141, 590.5315);
	angles[25] = (0, -90, 77.9361);
	at[25] = 2.8500;
	points[26] = (4650.5908, -1461.6141, 578.2795);
	angles[26] = (0, -90, 62.0318);
	at[26] = 2.9000;
	points[27] = (4650.5908, -1461.6141, 569.6968);
	angles[27] = (0, -90, 30.4654);
	at[27] = 2.9500;
	points[28] = (4650.5908, -1461.6141, 560.6260);
	angles[28] = (0, -90, -12.0179);
	at[28] = 3;
	points[29] = (4650.5908, -1461.6141, 551.0394);
	angles[29] = (0, -90, -46.5577);
	at[29] = 3.0500;
	points[30] = (4650.5908, -1461.6141, 547.7244);
	angles[30] = (0, -90, -54.8311);
	at[30] = 3.0667;
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
	points[0] = (4724.6851, 265.7480, 6.5911);
	angles[0] = (0, -90, -89.9727);
	at[0] = 0;
	points[1] = (4724.7246, 265.7480, -34.4545);
	angles[1] = (0, -90, -89.9849);
	at[1] = 0.0500;
	points[2] = (4724.6455, 265.7480, 8.8840);
	angles[2] = (0, -270, -89.9487);
	at[2] = 0.1000;
	points[3] = (4724.6064, 265.7480, 46.4512);
	angles[3] = (0, -270, -89.7912);
	at[3] = 0.1500;
	points[4] = (4724.5273, 265.7480, 112.0303);
	angles[4] = (0, -270, -88.5332);
	at[4] = 0.2500;
	points[5] = (4724.4883, 265.7480, 166.6559);
	angles[5] = (0, -270, -81.4863);
	at[5] = 0.3500;
	points[6] = (4724.4487, 265.7480, 190.4453);
	angles[6] = (0, -270, -69.9761);
	at[6] = 0.4000;
	points[7] = (4724.4487, 265.7480, 212.1575);
	angles[7] = (0, -270, -45.2506);
	at[7] = 0.4500;
	points[8] = (4724.4097, 265.7480, 250.5138);
	angles[8] = (0, -270, 34.4202);
	at[8] = 0.5500;
	points[9] = (4724.3701, 265.7480, 268.8134);
	angles[9] = (0, -270, 60.3438);
	at[9] = 0.6000;
	points[10] = (4724.3701, 265.7480, 286.8846);
	angles[10] = (0, -270, 74.6236);
	at[10] = 0.6500;
	points[11] = (4724.3306, 265.7480, 304.7311);
	angles[11] = (0, -270, 82.0808);
	at[11] = 0.7000;
	points[12] = (4724.2915, 265.7480, 356.9488);
	angles[12] = (0, -270, 88.8947);
	at[12] = 0.8500;
	points[13] = (4724.2520, 265.7480, 439.7323);
	angles[13] = (0, -270, 89.9150);
	at[13] = 1.1000;
	points[14] = (4724.1338, 265.7480, 576.2874);
	angles[14] = (0, -270, 89.9521);
	at[14] = 1.5500;
	points[15] = (4724.0942, 265.7480, 590.5315);
	angles[15] = (0, -90, 77.9361);
	at[15] = 1.6000;
	points[16] = (4724.4097, 265.7480, 578.2795);
	angles[16] = (0, -90, 62.0318);
	at[16] = 1.6500;
	points[17] = (4724.4097, 265.7480, 569.6968);
	angles[17] = (0, -90, 30.4654);
	at[17] = 1.7000;
	points[18] = (4724.4097, 265.7480, 560.6260);
	angles[18] = (0, -90, -12.0179);
	at[18] = 1.7500;
	points[19] = (4724.4097, 265.7480, 551.0394);
	angles[19] = (0, -90, -46.5577);
	at[19] = 1.8000;
	points[20] = (4724.4487, 265.7480, 540.9095);
	angles[20] = (0, -90, -67.1979);
	at[20] = 1.8500;
	points[21] = (4724.4487, 265.7480, 530.2008);
	angles[21] = (0, -90, -78.2357);
	at[21] = 1.9000;
	points[22] = (4724.4487, 265.7480, 506.9331);
	angles[22] = (0, -90, -86.8892);
	at[22] = 2;
	points[23] = (4724.4487, 265.7480, 466.8347);
	angles[23] = (0, -90, -89.5588);
	at[23] = 2.1500;
	points[24] = (4724.4883, 265.7480, 436.1653);
	angles[24] = (0, -90, -89.8642);
	at[24] = 2.2500;
	points[25] = (4724.4883, 265.7480, 383.3138);
	angles[25] = (0, -90, -89.9581);
	at[25] = 2.4000;
	points[26] = (4724.5273, 265.7480, 320.9398);
	angles[26] = (0, -90, -89.9707);
	at[26] = 2.5500;
	points[27] = (4724.5669, 265.7480, 247.3252);
	angles[27] = (0, -90, -89.9725);
	at[27] = 2.7000;
	points[28] = (4724.6064, 265.7480, 191.0185);
	angles[28] = (0, -90, -89.9727);
	at[28] = 2.8000;
	points[29] = (4724.6455, 265.7480, 93.9913);
	angles[29] = (0, -90, -89.9727);
	at[29] = 2.9500;
	points[30] = (4724.6851, 265.7480, 6.5911);
	angles[30] = (0, -90, -89.9727);
	at[30] = 3.0667;
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
	points[0] = (6223.6611, 1313.9764, 312.3650);
	angles[0] = (0, -90, 58.5163);
	at[0] = 0;
	points[1] = (6230.3149, 1313.9764, 318.4409);
	angles[1] = (0, -90, 50.6960);
	at[1] = 0.0500;
	points[2] = (6244.2124, 1313.9764, 331.1579);
	angles[2] = (0, -90, 44.6039);
	at[2] = 0.1500;
	points[3] = (6282.9136, 1313.9764, 366.5248);
	angles[3] = (0, -90, 42.5125);
	at[3] = 0.4000;
	points[4] = (6327.9136, 1313.9764, 407.6575);
	angles[4] = (0, -90, 42.4389);
	at[4] = 0.6500;
	points[5] = (6391.6929, 1313.9764, 465.9685);
	angles[5] = (0, -90, 42.4363);
	at[5] = 0.9500;
	points[6] = (6454.4097, 1313.9764, 523.3149);
	angles[6] = (0, -90, 42.4363);
	at[6] = 1.2000;
	points[7] = (6468.0312, 1313.9764, 519.5315);
	angles[7] = (0, -90, 16.3961);
	at[7] = 1.2500;
	points[8] = (6481.3779, 1313.9764, 507.3504);
	angles[8] = (0, -90, -10.9030);
	at[8] = 1.3000;
	points[9] = (6494.2915, 1313.9764, 495.5355);
	angles[9] = (0, -90, -26.0861);
	at[9] = 1.3500;
	points[10] = (6518.9766, 1313.9764, 472.9606);
	angles[10] = (0, -90, -38.1319);
	at[10] = 1.4500;
	points[11] = (6574.4883, 1313.9764, 422.1968);
	angles[11] = (0, -90, -42.2847);
	at[11] = 1.7000;
	points[12] = (6630.8662, 1313.9764, 370.6720);
	angles[12] = (0, -90, -42.4335);
	at[12] = 2;
	points[13] = (6677.7954, 1313.9764, 327.7689);
	angles[13] = (0, -90, -42.4361);
	at[13] = 2.3000;
	points[14] = (6716.8506, 1313.9764, 292.0449);
	angles[14] = (0, -90, -42.4363);
	at[14] = 2.6000;
	points[15] = (6710.4336, 1313.9764, 291.4370);
	angles[15] = (0, -90, -81.8018);
	at[15] = 2.6500;
	points[16] = (6702.4805, 1313.9764, 291.4370);
	angles[16] = (0, -270, -57.9666);
	at[16] = 2.7000;
	points[17] = (6694.4878, 1313.9764, 291.4370);
	angles[17] = (0, -270, -31.0254);
	at[17] = 2.7500;
	points[18] = (6686.5356, 1313.9764, 291.4370);
	angles[18] = (0, -270, -16.0801);
	at[18] = 2.8000;
	points[19] = (6670.5908, 1313.9764, 291.4370);
	angles[19] = (0, -270, -4.2326);
	at[19] = 2.9000;
	points[20] = (6654.6455, 1313.9764, 291.4370);
	angles[20] = (0, -270, -1.1099);
	at[20] = 3;
	points[21] = (6208.1890, 1313.9764, 291.4370);
	angles[21] = (0, -270, 0);
	at[21] = 5.8000;
	points[22] = (6200.5513, 1313.9764, 291.4370);
	angles[22] = (0, -270, 11.6873);
	at[22] = 5.8500;
	points[23] = (6206.8896, 1313.9764, 297.0315);
	angles[23] = (0, -270, 53.7566);
	at[23] = 5.9000;
	points[24] = (6213.0317, 1313.9764, 302.6370);
	angles[24] = (0, -450, 89.8040);
	at[24] = 5.9500;
	points[25] = (6219.3701, 1313.9764, 308.4150);
	angles[25] = (0, -450, 67.4041);
	at[25] = 6;
	points[26] = (6223.6611, 1313.9764, 312.3650);
	angles[26] = (0, -450, 58.5163);
	at[26] = 6.0333;
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
	points[0] = (6694.6460, 1313.9764, 312.3650);
	angles[0] = (0, 90, 58.5163);
	at[0] = 0;
	points[1] = (6687.9922, 1313.9764, 318.4409);
	angles[1] = (0, 90, 50.6960);
	at[1] = 0.0500;
	points[2] = (6674.0552, 1313.9764, 331.1579);
	angles[2] = (0, 90, 44.6039);
	at[2] = 0.1500;
	points[3] = (6635.3940, 1313.9764, 366.5248);
	angles[3] = (0, 90, 42.5125);
	at[3] = 0.4000;
	points[4] = (6590.3936, 1313.9764, 407.6575);
	angles[4] = (0, 90, 42.4389);
	at[4] = 0.6500;
	points[5] = (6526.6143, 1313.9764, 465.9685);
	angles[5] = (0, 90, 42.4363);
	at[5] = 0.9500;
	points[6] = (6463.8975, 1313.9764, 523.3149);
	angles[6] = (0, 90, 42.4363);
	at[6] = 1.2000;
	points[7] = (6450.2759, 1313.9764, 519.5315);
	angles[7] = (0, 90, 16.3961);
	at[7] = 1.2500;
	points[8] = (6436.9292, 1313.9764, 507.3504);
	angles[8] = (0, 90, -10.9030);
	at[8] = 1.3000;
	points[9] = (6424.0156, 1313.9764, 495.5355);
	angles[9] = (0, 90, -26.0861);
	at[9] = 1.3500;
	points[10] = (6399.3306, 1313.9764, 472.9606);
	angles[10] = (0, 90, -38.1319);
	at[10] = 1.4500;
	points[11] = (6343.8188, 1313.9764, 422.1968);
	angles[11] = (0, 90, -42.2847);
	at[11] = 1.7000;
	points[12] = (6287.4414, 1313.9764, 370.6720);
	angles[12] = (0, 90, -42.4335);
	at[12] = 2;
	points[13] = (6240.5122, 1313.9764, 327.7689);
	angles[13] = (0, 90, -42.4361);
	at[13] = 2.3000;
	points[14] = (6201.4565, 1313.9764, 292.0449);
	angles[14] = (0, 90, -42.4363);
	at[14] = 2.6000;
	points[15] = (6207.8740, 1313.9764, 291.4370);
	angles[15] = (0, 90, -81.8018);
	at[15] = 2.6500;
	points[16] = (6215.8271, 1313.9764, 291.4370);
	angles[16] = (0, 270, -57.9666);
	at[16] = 2.7000;
	points[17] = (6223.8193, 1313.9764, 291.4370);
	angles[17] = (0, 270, -31.0254);
	at[17] = 2.7500;
	points[18] = (6231.7720, 1313.9764, 291.4370);
	angles[18] = (0, 270, -16.0801);
	at[18] = 2.8000;
	points[19] = (6247.7168, 1313.9764, 291.4370);
	angles[19] = (0, 270, -4.2326);
	at[19] = 2.9000;
	points[20] = (6263.6616, 1313.9764, 291.4370);
	angles[20] = (0, 270, -1.1099);
	at[20] = 3;
	points[21] = (6710.1182, 1313.9764, 291.4370);
	angles[21] = (0, 270, 0);
	at[21] = 5.8000;
	points[22] = (6717.7559, 1313.9764, 291.4370);
	angles[22] = (0, 270, 11.6873);
	at[22] = 5.8500;
	points[23] = (6711.4175, 1313.9764, 297.0315);
	angles[23] = (0, 270, 53.7566);
	at[23] = 5.9000;
	points[24] = (6705.2754, 1313.9764, 302.6370);
	angles[24] = (0, 450, 89.8040);
	at[24] = 5.9500;
	points[25] = (6698.9370, 1313.9764, 308.4150);
	angles[25] = (0, 450, 67.4041);
	at[25] = 6;
	points[26] = (6694.6460, 1313.9764, 312.3650);
	angles[26] = (0, 450, 58.5163);
	at[26] = 6.0333;
	mover = getEnt("iz_obj_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4547.2046, 2096.4568, 339.0661);
	angles[0] = (0, 90, 83.1621);
	at[0] = 0;
	points[1] = (4547.1655, 2096.4568, 374.3980);
	angles[1] = (0, 90, 88.1640);
	at[1] = 0.1000;
	points[2] = (4547.0869, 2096.4568, 458.2165);
	angles[2] = (0, 90, 89.8802);
	at[2] = 0.3500;
	points[3] = (4546.9683, 2096.4568, 579.8779);
	angles[3] = (0, 90, 89.9425);
	at[3] = 0.7500;
	points[4] = (4549.1338, 2096.4568, 584.5276);
	angles[4] = (0, -90, 73.9861);
	at[4] = 0.8000;
	points[5] = (4547.2441, 2096.4568, 575.4685);
	angles[5] = (0, -90, 53.4992);
	at[5] = 0.8500;
	points[6] = (4547.2441, 2096.4568, 566.7284);
	angles[6] = (0, -90, 16.6488);
	at[6] = 0.9000;
	points[7] = (4547.2441, 2096.4568, 557.4882);
	angles[7] = (0, -90, -25.0591);
	at[7] = 0.9500;
	points[8] = (4547.2441, 2096.4568, 547.7244);
	angles[8] = (0, -90, -54.8065);
	at[8] = 1;
	points[9] = (4547.2837, 2096.4568, 537.4055);
	angles[9] = (0, -90, -71.6816);
	at[9] = 1.0500;
	points[10] = (4547.2837, 2096.4568, 526.5000);
	angles[10] = (0, -90, -80.5683);
	at[10] = 1.1000;
	points[11] = (4547.2837, 2096.4568, 514.9764);
	angles[11] = (0, -90, -85.1523);
	at[11] = 1.1500;
	points[12] = (4547.3228, 2096.4568, 461.9567);
	angles[12] = (0, -90, -89.6413);
	at[12] = 1.3500;
	points[13] = (4547.3228, 2096.4568, 413.7520);
	angles[13] = (0, -90, -89.9283);
	at[13] = 1.5000;
	points[14] = (4547.3623, 2096.4568, 356.8634);
	angles[14] = (0, -90, -89.9668);
	at[14] = 1.6500;
	points[15] = (4547.3623, 2096.4568, 313.3496);
	angles[15] = (0, -90, -89.9711);
	at[15] = 1.7500;
	points[16] = (4547.4014, 2096.4568, 264.7535);
	angles[16] = (0, -90, -89.9723);
	at[16] = 1.8500;
	points[17] = (4547.4409, 2096.4568, 181.0142);
	angles[17] = (0, -90, -89.9727);
	at[17] = 2;
	points[18] = (4547.4805, 2096.4568, 82.1846);
	angles[18] = (0, -90, -89.9727);
	at[18] = 2.1500;
	points[19] = (4547.5200, 2096.4568, 6.5911);
	angles[19] = (0, -90, -89.9727);
	at[19] = 2.2500;
	points[20] = (4547.5591, 2096.4568, -34.4545);
	angles[20] = (0, -90, -89.9810);
	at[20] = 2.3000;
	points[21] = (4547.5200, 2096.4568, 9.1286);
	angles[21] = (0, -270, -89.9736);
	at[21] = 2.3500;
	points[22] = (4547.4805, 2096.4568, 47.5602);
	angles[22] = (0, -270, -89.8665);
	at[22] = 2.4000;
	points[23] = (4547.4014, 2096.4568, 116.3386);
	angles[23] = (0, -270, -89.0087);
	at[23] = 2.5000;
	points[24] = (4547.3623, 2096.4568, 175.5890);
	angles[24] = (0, -270, -84.1967);
	at[24] = 2.6000;
	points[25] = (4547.3228, 2096.4568, 202.0614);
	angles[25] = (0, -270, -76.2512);
	at[25] = 2.6500;
	points[26] = (4547.2837, 2096.4568, 226.6323);
	angles[26] = (0, -270, -58.3131);
	at[26] = 2.7000;
	points[27] = (4547.2837, 2096.4568, 249.4374);
	angles[27] = (0, -270, -24.1722);
	at[27] = 2.7500;
	points[28] = (4547.2441, 2096.4568, 270.6043);
	angles[28] = (0, -270, 18.2480);
	at[28] = 2.8000;
	points[29] = (4547.2441, 2096.4568, 290.2504);
	angles[29] = (0, -270, 50.5759);
	at[29] = 2.8500;
	points[30] = (4547.2441, 2096.4568, 308.8008);
	angles[30] = (0, -270, 69.3828);
	at[30] = 2.9000;
	points[31] = (4547.2046, 2096.4568, 339.0661);
	angles[31] = (0, -270, 83.1622);
	at[31] = 2.9833;
	mover = getEnt("iz_obj_22", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_23()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6584.9214, 2967.5198, 303.4539);
	angles[0] = (0, 90, -38.6598);
	at[0] = 0;
	points[1] = (6571.9292, 2967.5198, 293.0638);
	angles[1] = (0, 90, -38.6598);
	at[1] = 0.1000;
	points[2] = (6575.2754, 2967.5198, 291.4370);
	angles[2] = (0, 90, -76.5181);
	at[2] = 0.1500;
	points[3] = (6583.2285, 2967.5198, 291.4370);
	angles[3] = (0, -90, -62.2486);
	at[3] = 0.2000;
	points[4] = (6591.2207, 2967.5198, 291.4370);
	angles[4] = (0, -90, -33.5596);
	at[4] = 0.2500;
	points[5] = (6599.1733, 2967.5198, 291.4370);
	angles[5] = (0, -90, -17.4304);
	at[5] = 0.3000;
	points[6] = (6607.1655, 2967.5198, 291.4370);
	angles[6] = (0, -90, -8.9585);
	at[6] = 0.3500;
	points[7] = (6615.1182, 2967.5198, 291.4370);
	angles[7] = (0, -90, -4.5913);
	at[7] = 0.4000;
	points[8] = (6631.0630, 2967.5198, 291.4370);
	angles[8] = (0, -90, -1.2040);
	at[8] = 0.5000;
	points[9] = (7157.2446, 2967.5198, 291.4370);
	angles[9] = (0, -90, 0);
	at[9] = 3.8000;
	points[10] = (7156.5356, 2967.5198, 294.5594);
	angles[10] = (0, -90, 23.7880);
	at[10] = 3.8500;
	points[11] = (7150.1187, 2967.5198, 299.6752);
	angles[11] = (0, -90, 66.3094);
	at[11] = 3.9000;
	points[12] = (7143.5435, 2967.5198, 304.9362);
	angles[12] = (0, 90, 80.1631);
	at[12] = 3.9500;
	points[13] = (7136.8110, 2967.5198, 310.3465);
	angles[13] = (0, 90, 60.3848);
	at[13] = 4;
	points[14] = (7129.8428, 2967.5198, 315.9099);
	angles[14] = (0, 90, 49.8493);
	at[14] = 4.0500;
	points[15] = (7122.6772, 2967.5198, 321.6315);
	angles[15] = (0, 90, 44.3977);
	at[15] = 4.1000;
	points[16] = (7107.7559, 2967.5198, 333.5666);
	angles[16] = (0, 90, 40.1648);
	at[16] = 4.2000;
	points[17] = (7075.3149, 2967.5198, 359.5366);
	angles[17] = (0, 90, 38.7631);
	at[17] = 4.4000;
	points[18] = (7029.2915, 2967.5198, 396.3661);
	angles[18] = (0, 90, 38.6634);
	at[18] = 4.6500;
	points[19] = (6987.5200, 2967.5198, 429.7716);
	angles[19] = (0, 90, 38.6601);
	at[19] = 4.8500;
	points[20] = (6952.9922, 2967.5198, 457.3976);
	angles[20] = (0, 90, 38.6598);
	at[20] = 5;
	points[21] = (6915.4331, 2967.5198, 487.4449);
	angles[21] = (0, 90, 38.6598);
	at[21] = 5.1500;
	points[22] = (6874.5669, 2967.5198, 520.1220);
	angles[22] = (0, 90, 38.6598);
	at[22] = 5.3000;
	points[23] = (6860.1968, 2967.5198, 523.6772);
	angles[23] = (0, 90, 14.1528);
	at[23] = 5.3500;
	points[24] = (6845.9448, 2967.5198, 512.2756);
	angles[24] = (0, 90, -10.6152);
	at[24] = 5.4000;
	points[25] = (6832.0869, 2967.5198, 501.1929);
	angles[25] = (0, 90, -24.1575);
	at[25] = 5.4500;
	points[26] = (6805.5117, 2967.5198, 479.9409);
	angles[26] = (0, 90, -34.8454);
	at[26] = 5.5500;
	points[27] = (6745.3149, 2967.5198, 431.7835);
	angles[27] = (0, 90, -38.5255);
	at[27] = 5.8000;
	points[28] = (6683.4644, 2967.5198, 382.2890);
	angles[28] = (0, 90, -38.6574);
	at[28] = 6.1000;
	points[29] = (6631.2207, 2967.5198, 340.5098);
	angles[29] = (0, 90, -38.6598);
	at[29] = 6.4000;
	points[30] = (6584.9214, 2967.5198, 303.4539);
	angles[30] = (0, 90, -38.6598);
	at[30] = 6.7167;
	mover = getEnt("iz_obj_23", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_24()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (7145.3936, 2967.5198, 303.4539);
	angles[0] = (0, -90, -38.6598);
	at[0] = 0;
	points[1] = (7158.3857, 2967.5198, 293.0638);
	angles[1] = (0, -90, -38.6598);
	at[1] = 0.1000;
	points[2] = (7155.0396, 2967.5198, 291.4370);
	angles[2] = (0, -90, -76.5181);
	at[2] = 0.1500;
	points[3] = (7147.0864, 2967.5198, 291.4370);
	angles[3] = (0, 90, -62.2486);
	at[3] = 0.2000;
	points[4] = (7139.0942, 2967.5198, 291.4370);
	angles[4] = (0, 90, -33.5596);
	at[4] = 0.2500;
	points[5] = (7131.1416, 2967.5198, 291.4370);
	angles[5] = (0, 90, -17.4304);
	at[5] = 0.3000;
	points[6] = (7123.1494, 2967.5198, 291.4370);
	angles[6] = (0, 90, -8.9585);
	at[6] = 0.3500;
	points[7] = (7115.1968, 2967.5198, 291.4370);
	angles[7] = (0, 90, -4.5913);
	at[7] = 0.4000;
	points[8] = (7099.2520, 2967.5198, 291.4370);
	angles[8] = (0, 90, -1.2040);
	at[8] = 0.5000;
	points[9] = (6573.0708, 2967.5198, 291.4370);
	angles[9] = (0, 90, 0);
	at[9] = 3.8000;
	points[10] = (6573.7798, 2967.5198, 294.5594);
	angles[10] = (0, 90, 23.7880);
	at[10] = 3.8500;
	points[11] = (6580.1968, 2967.5198, 299.6752);
	angles[11] = (0, 90, 66.3094);
	at[11] = 3.9000;
	points[12] = (6586.7720, 2967.5198, 304.9362);
	angles[12] = (0, -90, 80.1631);
	at[12] = 3.9500;
	points[13] = (6593.5044, 2967.5198, 310.3465);
	angles[13] = (0, -90, 60.3848);
	at[13] = 4;
	points[14] = (6600.4722, 2967.5198, 315.9099);
	angles[14] = (0, -90, 49.8493);
	at[14] = 4.0500;
	points[15] = (6607.6377, 2967.5198, 321.6315);
	angles[15] = (0, -90, 44.3977);
	at[15] = 4.1000;
	points[16] = (6622.5591, 2967.5198, 333.5666);
	angles[16] = (0, -90, 40.1648);
	at[16] = 4.2000;
	points[17] = (6655, 2967.5198, 359.5366);
	angles[17] = (0, -90, 38.7631);
	at[17] = 4.4000;
	points[18] = (6701.0234, 2967.5198, 396.3661);
	angles[18] = (0, -90, 38.6634);
	at[18] = 4.6500;
	points[19] = (6742.7954, 2967.5198, 429.7716);
	angles[19] = (0, -90, 38.6601);
	at[19] = 4.8500;
	points[20] = (6777.3228, 2967.5198, 457.3976);
	angles[20] = (0, -90, 38.6598);
	at[20] = 5;
	points[21] = (6814.8823, 2967.5198, 487.4449);
	angles[21] = (0, -90, 38.6598);
	at[21] = 5.1500;
	points[22] = (6855.7480, 2967.5198, 520.1220);
	angles[22] = (0, -90, 38.6598);
	at[22] = 5.3000;
	points[23] = (6870.1187, 2967.5198, 523.6772);
	angles[23] = (0, -90, 14.1528);
	at[23] = 5.3500;
	points[24] = (6884.3706, 2967.5198, 512.2756);
	angles[24] = (0, -90, -10.6152);
	at[24] = 5.4000;
	points[25] = (6898.2285, 2967.5198, 501.1929);
	angles[25] = (0, -90, -24.1575);
	at[25] = 5.4500;
	points[26] = (6924.8032, 2967.5198, 479.9409);
	angles[26] = (0, -90, -34.8454);
	at[26] = 5.5500;
	points[27] = (6985, 2967.5198, 431.7835);
	angles[27] = (0, -90, -38.5255);
	at[27] = 5.8000;
	points[28] = (7046.8506, 2967.5198, 382.2890);
	angles[28] = (0, -90, -38.6574);
	at[28] = 6.1000;
	points[29] = (7099.0947, 2967.5198, 340.5098);
	angles[29] = (0, -90, -38.6598);
	at[29] = 6.4000;
	points[30] = (7145.3936, 2967.5198, 303.4539);
	angles[30] = (0, -90, -38.6598);
	at[30] = 6.7167;
	mover = getEnt("iz_obj_24", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_25()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4247.9922, 3720.4724, 327.1587);
	angles[0] = (0, 90, 51.6895);
	at[0] = 0;
	points[1] = (4204.8032, 3720.4724, 373.2299);
	angles[1] = (0, 90, 46.9350);
	at[1] = 0.3000;
	points[2] = (4161.7715, 3720.4724, 419.1535);
	angles[2] = (0, 90, 46.8507);
	at[2] = 0.5500;
	points[3] = (4111.0630, 3720.4724, 473.2205);
	angles[3] = (0, 90, 46.8477);
	at[3] = 0.8000;
	points[4] = (4064.1338, 3720.4724, 523.2992);
	angles[4] = (0, 90, 46.8477);
	at[4] = 1;
	points[5] = (4051.4961, 3720.4724, 518.5472);
	angles[5] = (0, 90, 7.6493);
	at[5] = 1.0500;
	points[6] = (4039.1733, 3720.4724, 505.4173);
	angles[6] = (0, 90, -17.8368);
	at[6] = 1.1000;
	points[7] = (4027.2834, 3720.4724, 492.7166);
	angles[7] = (0, 90, -31.8350);
	at[7] = 1.1500;
	points[8] = (4015.7480, 3720.4724, 480.4291);
	angles[8] = (0, 90, -39.1395);
	at[8] = 1.2000;
	points[9] = (3993.8191, 3720.4724, 457.0354);
	angles[9] = (0, 90, -44.8250);
	at[9] = 1.3000;
	points[10] = (3963.5435, 3720.4724, 424.7205);
	angles[10] = (0, 90, -46.5762);
	at[10] = 1.4500;
	points[11] = (3919.2522, 3720.4724, 377.4843);
	angles[11] = (0, 90, -46.8382);
	at[11] = 1.7000;
	points[12] = (3881.7087, 3720.4724, 337.4366);
	angles[12] = (0, 90, -46.8474);
	at[12] = 1.9500;
	points[13] = (3844.1143, 3720.4724, 297.3386);
	angles[13] = (0, 90, -46.8477);
	at[13] = 2.2500;
	points[14] = (3838.5435, 3720.4724, 291.3941);
	angles[14] = (0, 90, -59.2551);
	at[14] = 2.3000;
	points[15] = (3846.6143, 3720.4724, 291.4370);
	angles[15] = (0, -90, -78.2729);
	at[15] = 2.3500;
	points[16] = (3854.5867, 3720.4724, 291.4370);
	angles[16] = (0, -90, -43.6253);
	at[16] = 2.4000;
	points[17] = (3862.5591, 3720.4724, 291.4370);
	angles[17] = (0, -90, -22.8906);
	at[17] = 2.4500;
	points[18] = (3870.5315, 3720.4724, 291.4370);
	angles[18] = (0, -90, -11.7976);
	at[18] = 2.5000;
	points[19] = (3878.5039, 3720.4724, 291.4370);
	angles[19] = (0, -90, -6.0509);
	at[19] = 2.5500;
	points[20] = (3894.4487, 3720.4724, 291.4370);
	angles[20] = (0, -90, -1.5871);
	at[20] = 2.6500;
	points[21] = (4277.1260, 3720.4724, 291.4370);
	angles[21] = (0, -90, 0);
	at[21] = 5.0500;
	points[22] = (4278.0708, 3720.4724, 295.0925);
	angles[22] = (0, -90, 26.2467);
	at[22] = 5.1000;
	points[23] = (4272.4409, 3720.4724, 301.0941);
	angles[23] = (0, -90, 67.9926);
	at[23] = 5.1500;
	points[24] = (4266.6143, 3720.4724, 307.2945);
	angles[24] = (0, -270, 82.1636);
	at[24] = 5.2000;
	points[25] = (4260.6299, 3720.4724, 313.7008);
	angles[25] = (0, -270, 65.2189);
	at[25] = 5.2500;
	points[26] = (4254.4092, 3720.4724, 320.3201);
	angles[26] = (0, -270, 56.2938);
	at[26] = 5.3000;
	points[27] = (4247.9922, 3720.4724, 327.1587);
	angles[27] = (0, -270, 51.6895);
	at[27] = 5.3500;
	mover = getEnt("iz_obj_25", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_26()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3872.0710, 3720.4724, 327.1587);
	angles[0] = (0, -90, 51.6895);
	at[0] = 0;
	points[1] = (3915.2639, 3720.4724, 373.2299);
	angles[1] = (0, -90, 46.9350);
	at[1] = 0.3000;
	points[2] = (3958.3071, 3720.4724, 419.1535);
	angles[2] = (0, -90, 46.8507);
	at[2] = 0.5500;
	points[3] = (4009.0159, 3720.4724, 473.2205);
	angles[3] = (0, -90, 46.8477);
	at[3] = 0.8000;
	points[4] = (4055.9451, 3720.4724, 523.2992);
	angles[4] = (0, -90, 46.8477);
	at[4] = 1;
	points[5] = (4068.5828, 3720.4724, 518.5472);
	angles[5] = (0, -90, 7.6493);
	at[5] = 1.0500;
	points[6] = (4080.9055, 3720.4724, 505.4173);
	angles[6] = (0, -90, -17.8368);
	at[6] = 1.1000;
	points[7] = (4092.7954, 3720.4724, 492.7166);
	angles[7] = (0, -90, -31.8350);
	at[7] = 1.1500;
	points[8] = (4104.3306, 3720.4724, 480.4291);
	angles[8] = (0, -90, -39.1395);
	at[8] = 1.2000;
	points[9] = (4126.2598, 3720.4724, 457.0354);
	angles[9] = (0, -90, -44.8250);
	at[9] = 1.3000;
	points[10] = (4156.5352, 3720.4724, 424.7205);
	angles[10] = (0, -90, -46.5762);
	at[10] = 1.4500;
	points[11] = (4200.8267, 3720.4724, 377.4843);
	angles[11] = (0, -90, -46.8382);
	at[11] = 1.7000;
	points[12] = (4238.3857, 3720.4724, 337.4366);
	angles[12] = (0, -90, -46.8474);
	at[12] = 1.9500;
	points[13] = (4275.9448, 3720.4724, 297.3386);
	angles[13] = (0, -90, -46.8477);
	at[13] = 2.2500;
	points[14] = (4281.5356, 3720.4724, 291.3941);
	angles[14] = (0, -90, -59.2551);
	at[14] = 2.3000;
	points[15] = (4273.4644, 3720.4724, 291.4370);
	angles[15] = (0, -270, -78.2729);
	at[15] = 2.3500;
	points[16] = (4265.5117, 3720.4724, 291.4370);
	angles[16] = (0, -270, -43.6253);
	at[16] = 2.4000;
	points[17] = (4257.5195, 3720.4724, 291.4370);
	angles[17] = (0, -270, -22.8906);
	at[17] = 2.4500;
	points[18] = (4249.5669, 3720.4724, 291.4370);
	angles[18] = (0, -270, -11.7976);
	at[18] = 2.5000;
	points[19] = (4241.5747, 3720.4724, 291.4370);
	angles[19] = (0, -270, -6.0509);
	at[19] = 2.5500;
	points[20] = (4225.6299, 3720.4724, 291.4370);
	angles[20] = (0, -270, -1.5871);
	at[20] = 2.6500;
	points[21] = (3842.9529, 3720.4724, 291.4370);
	angles[21] = (0, -270, 0);
	at[21] = 5.0500;
	points[22] = (3842.0078, 3720.4724, 295.0925);
	angles[22] = (0, -270, 26.2467);
	at[22] = 5.1000;
	points[23] = (3847.6379, 3720.4724, 301.0941);
	angles[23] = (0, -270, 67.9926);
	at[23] = 5.1500;
	points[24] = (3853.4490, 3720.4724, 307.2945);
	angles[24] = (0, -90, 82.1636);
	at[24] = 5.2000;
	points[25] = (3859.4565, 3720.4724, 313.7008);
	angles[25] = (0, -90, 65.2189);
	at[25] = 5.2500;
	points[26] = (3865.6614, 3720.4724, 320.3201);
	angles[26] = (0, -90, 56.2938);
	at[26] = 5.3000;
	points[27] = (3872.0710, 3720.4724, 327.1587);
	angles[27] = (0, -90, 51.6895);
	at[27] = 5.3500;
	mover = getEnt("iz_obj_26", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_27()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6893.0708, 4532.4805, 370.6516);
	angles[0] = (0, 90, 16.5043);
	at[0] = 0;
	points[1] = (6806.7324, 4532.4805, 396.2401);
	angles[1] = (0, 90, 16.5043);
	at[1] = 0.4000;
	points[2] = (6737.1650, 4532.4805, 416.8504);
	angles[2] = (0, 90, 16.5043);
	at[2] = 0.7000;
	points[3] = (6637.5200, 4532.4805, 446.3740);
	angles[3] = (0, 90, 16.5043);
	at[3] = 1.1000;
	points[4] = (6557.2832, 4532.4805, 470.1496);
	angles[4] = (0, 90, 16.5043);
	at[4] = 1.4000;
	points[5] = (6471.9688, 4532.4805, 495.4331);
	angles[5] = (0, 90, 16.5043);
	at[5] = 1.7000;
	points[6] = (6381.2598, 4532.4805, 522.3071);
	angles[6] = (0, 90, 16.5043);
	at[6] = 2;
	points[7] = (6284.8032, 4532.4805, 550.8859);
	angles[7] = (0, 90, 16.5043);
	at[7] = 2.3000;
	points[8] = (6182.2837, 4532.4805, 581.2638);
	angles[8] = (0, 90, 16.5043);
	at[8] = 2.6000;
	points[9] = (6146.7720, 4532.4805, 581.6457);
	angles[9] = (0, 90, 0.6318);
	at[9] = 2.7000;
	points[10] = (6111.7715, 4532.4805, 571.2677);
	angles[10] = (0, 90, -11.9913);
	at[10] = 2.8000;
	points[11] = (6077.4414, 4532.4805, 561.1024);
	angles[11] = (0, 90, -15.3209);
	at[11] = 2.9000;
	points[12] = (5978.6221, 4532.4805, 531.8228);
	angles[12] = (0, 90, -16.4830);
	at[12] = 3.2000;
	points[13] = (5855.9844, 4532.4805, 495.4803);
	angles[13] = (0, 90, -16.5043);
	at[13] = 3.6000;
	points[14] = (5716.1421, 4532.4805, 454.0472);
	angles[14] = (0, 90, -16.5043);
	at[14] = 4.1000;
	points[15] = (5589.9209, 4532.4805, 416.6496);
	angles[15] = (0, 90, -16.5043);
	at[15] = 4.6000;
	points[16] = (5475.9844, 4532.4805, 382.8945);
	angles[16] = (0, 90, -16.5043);
	at[16] = 5.1000;
	points[17] = (5353.8188, 4532.4805, 346.6965);
	angles[17] = (0, 90, -16.5043);
	at[17] = 5.7000;
	points[18] = (5262.8740, 4532.4805, 319.7516);
	angles[18] = (0, 90, -16.5043);
	at[18] = 6.2000;
	points[19] = (5180.7871, 4532.4805, 295.4307);
	angles[19] = (0, 90, -16.5043);
	at[19] = 6.7000;
	points[20] = (5165.3545, 4532.4805, 290.8583);
	angles[20] = (0, 90, -21.8410);
	at[20] = 6.8000;
	points[21] = (5185.3149, 4532.4805, 291.4370);
	angles[21] = (0, 90, -89.3020);
	at[21] = 6.9000;
	points[22] = (5201.2598, 4532.4805, 291.4370);
	angles[22] = (0, -90, -27.7344);
	at[22] = 7;
	points[23] = (5217.2046, 4532.4805, 291.4370);
	angles[23] = (0, -90, -7.3604);
	at[23] = 7.1000;
	points[24] = (5233.1494, 4532.4805, 291.4370);
	angles[24] = (0, -90, -1.9311);
	at[24] = 7.2000;
	points[25] = (5265.0391, 4532.4805, 291.4370);
	angles[25] = (0, -90, -0.1327);
	at[25] = 7.4000;
	points[26] = (7146.5356, 4532.4805, 291.4370);
	angles[26] = (0, -90, 0);
	at[26] = 19.2000;
	points[27] = (7162.6777, 4532.4805, 291.4370);
	angles[27] = (0, -90, 5.3367);
	at[27] = 19.3000;
	points[28] = (7142.7954, 4532.4805, 296.6618);
	angles[28] = (0, -90, 72.7975);
	at[28] = 19.4000;
	points[29] = (7127.0078, 4532.4805, 301.3382);
	angles[29] = (0, 90, 44.2389);
	at[29] = 19.5000;
	points[30] = (7110.9058, 4532.4805, 306.1110);
	angles[30] = (0, 90, 23.8649);
	at[30] = 19.6000;
	points[31] = (7094.4492, 4532.4805, 310.9823);
	angles[31] = (0, 90, 18.4355);
	at[31] = 19.7000;
	points[32] = (6988.4648, 4532.4805, 342.3941);
	angles[32] = (0, 90, 16.5050);
	at[32] = 20.3000;
	points[33] = (6893.0708, 4532.4805, 370.6516);
	angles[33] = (0, 90, 16.5043);
	at[33] = 20.7833;
	mover = getEnt("iz_obj_27", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_28()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5840.2759, 4532.4805, 291.4370);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (5170.5903, 4532.4805, 291.4370);
	angles[1] = (0, 90, 0);
	at[1] = 4.2000;
	points[2] = (5179.7637, 4532.4805, 295.1228);
	angles[2] = (0, 90, 44.3589);
	at[2] = 4.3000;
	points[3] = (5195.4331, 4532.4805, 299.7677);
	angles[3] = (0, 270, 59.0430);
	at[3] = 4.4000;
	points[4] = (5211.4570, 4532.4805, 304.5079);
	angles[4] = (0, 270, 27.9899);
	at[4] = 4.5000;
	points[5] = (5227.7563, 4532.4805, 309.3461);
	angles[5] = (0, 270, 19.5215);
	at[5] = 4.6000;
	points[6] = (5244.4487, 4532.4805, 314.2843);
	angles[6] = (0, 270, 17.2953);
	at[6] = 4.7000;
	points[7] = (5333.0713, 4532.4805, 340.5449);
	angles[7] = (0, 270, 16.5053);
	at[7] = 5.2000;
	points[8] = (5410.7876, 4532.4805, 363.5717);
	angles[8] = (0, 270, 16.5043);
	at[8] = 5.6000;
	points[9] = (5517.2837, 4532.4805, 395.1299);
	angles[9] = (0, 270, 16.5043);
	at[9] = 6.1000;
	points[10] = (5610.6694, 4532.4805, 422.8031);
	angles[10] = (0, 270, 16.5043);
	at[10] = 6.5000;
	points[11] = (5738.6611, 4532.4805, 460.7284);
	angles[11] = (0, 270, 16.5043);
	at[11] = 7;
	points[12] = (5880.4336, 4532.4805, 502.7323);
	angles[12] = (0, 270, 16.5043);
	at[12] = 7.5000;
	points[13] = (6004.7246, 4532.4805, 539.5590);
	angles[13] = (0, 270, 16.5043);
	at[13] = 7.9000;
	points[14] = (6139.6064, 4532.4805, 579.5236);
	angles[14] = (0, 270, 16.5043);
	at[14] = 8.3000;
	points[15] = (6175.0786, 4532.4805, 583.3976);
	angles[15] = (0, 270, 4.8561);
	at[15] = 8.4000;
	points[16] = (6210.1968, 4532.4805, 572.9882);
	angles[16] = (0, 270, -10.8641);
	at[16] = 8.5000;
	points[17] = (6244.6455, 4532.4805, 562.7834);
	angles[17] = (0, 270, -15.0251);
	at[17] = 8.6000;
	points[18] = (6343.7798, 4532.4805, 533.4055);
	angles[18] = (0, 270, -16.4776);
	at[18] = 8.9000;
	points[19] = (6466.8501, 4532.4805, 496.9409);
	angles[19] = (0, 270, -16.5042);
	at[19] = 9.3000;
	points[20] = (6607.1655, 4532.4805, 455.3661);
	angles[20] = (0, 270, -16.5043);
	at[20] = 9.8000;
	points[21] = (6733.8188, 4532.4805, 417.8386);
	angles[21] = (0, 270, -16.5043);
	at[21] = 10.3000;
	points[22] = (6848.1494, 4532.4805, 383.9666);
	angles[22] = (0, 270, -16.5043);
	at[22] = 10.8000;
	points[23] = (6970.7485, 4532.4805, 347.6445);
	angles[23] = (0, 270, -16.5043);
	at[23] = 11.4000;
	points[24] = (7061.9683, 4532.4805, 320.6075);
	angles[24] = (0, 270, -16.5043);
	at[24] = 11.9000;
	points[25] = (7159.8428, 4532.4805, 291.6150);
	angles[25] = (0, 270, -16.5043);
	at[25] = 12.5000;
	points[26] = (7145.1177, 4532.4805, 291.4370);
	angles[26] = (0, 270, -74.8256);
	at[26] = 12.6000;
	points[27] = (7129.1729, 4532.4805, 291.4370);
	angles[27] = (0, 450, -34.4156);
	at[27] = 12.7000;
	points[28] = (7113.2280, 4532.4805, 291.4370);
	angles[28] = (0, 450, -9.1958);
	at[28] = 12.8000;
	points[29] = (7097.2832, 4532.4805, 291.4370);
	angles[29] = (0, 450, -2.4138);
	at[29] = 12.9000;
	points[30] = (7065.3936, 4532.4805, 291.4370);
	angles[30] = (0, 450, -0.1659);
	at[30] = 13.1000;
	points[31] = (5840.2759, 4532.4805, 291.4370);
	angles[31] = (0, 450, 0);
	at[31] = 20.7833;
	mover = getEnt("iz_obj_28", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_29()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6281.4961, 4532.4805, 291.4370);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (6656.2202, 4532.4805, 291.4370);
	angles[1] = (0, -90, 0);
	at[1] = 2.3500;
	points[2] = (6651.9292, 4532.4805, 295.3500);
	angles[2] = (0, -90, 33.5590);
	at[2] = 2.4000;
	points[3] = (6644.8818, 4532.4805, 299.5346);
	angles[3] = (0, -90, 76.0417);
	at[3] = 2.4500;
	points[4] = (6637.7559, 4532.4805, 303.7969);
	angles[4] = (0, 90, 71.1131);
	at[4] = 2.5000;
	points[5] = (6630.4727, 4532.4805, 308.1382);
	angles[5] = (0, 90, 51.8922);
	at[5] = 2.5500;
	points[6] = (6623.0708, 4532.4805, 312.5602);
	angles[6] = (0, 90, 41.6779);
	at[6] = 2.6000;
	points[7] = (6607.8350, 4532.4805, 321.6523);
	angles[7] = (0, 90, 33.6848);
	at[7] = 2.7000;
	points[8] = (6567.2441, 4532.4805, 345.9012);
	angles[8] = (0, 90, 30.9379);
	at[8] = 2.9500;
	points[9] = (6522.7168, 4532.4805, 372.4862);
	angles[9] = (0, 90, 30.8414);
	at[9] = 3.2000;
	points[10] = (6473.8975, 4532.4805, 401.6339);
	angles[10] = (0, 90, 30.8379);
	at[10] = 3.4500;
	points[11] = (6431.4565, 4532.4805, 426.9606);
	angles[11] = (0, 90, 30.8379);
	at[11] = 3.6500;
	points[12] = (6373.8584, 4532.4805, 461.3543);
	angles[12] = (0, 90, 30.8379);
	at[12] = 3.9000;
	points[13] = (6310.7090, 4532.4805, 499.0630);
	angles[13] = (0, 90, 30.8379);
	at[13] = 4.1500;
	points[14] = (6241.4570, 4532.4805, 540.4055);
	angles[14] = (0, 90, 30.8379);
	at[14] = 4.4000;
	points[15] = (6165.5122, 4532.4805, 585.7323);
	angles[15] = (0, 90, 30.8379);
	at[15] = 4.6500;
	points[16] = (6149.6460, 4532.4805, 578.2087);
	angles[16] = (0, 90, 2.3794);
	at[16] = 4.7000;
	points[17] = (6134.0156, 4532.4805, 568.8898);
	angles[17] = (0, 90, -13.5903);
	at[17] = 4.7500;
	points[18] = (6118.7007, 4532.4805, 559.7363);
	angles[18] = (0, 90, -21.9740);
	at[18] = 4.8000;
	points[19] = (6103.6616, 4532.4805, 550.7559);
	angles[19] = (0, 90, -26.2951);
	at[19] = 4.8500;
	points[20] = (6046.1812, 4532.4805, 516.4410);
	angles[20] = (0, 90, -30.5255);
	at[20] = 5.0500;
	points[21] = (5992.7949, 4532.4805, 484.5787);
	angles[21] = (0, 90, -30.8164);
	at[21] = 5.2500;
	points[22] = (5943.2280, 4532.4805, 454.9882);
	angles[22] = (0, 90, -30.8364);
	at[22] = 5.4500;
	points[23] = (5886.2202, 4532.4805, 420.9528);
	angles[23] = (0, 90, -30.8377);
	at[23] = 5.7000;
	points[24] = (5824.4487, 4532.4805, 384.0602);
	angles[24] = (0, 90, -30.8379);
	at[24] = 6;
	points[25] = (5769.1338, 4532.4805, 351.0441);
	angles[25] = (0, 90, -30.8379);
	at[25] = 6.3000;
	points[26] = (5719.6460, 4532.4805, 321.4988);
	angles[26] = (0, 90, -30.8379);
	at[26] = 6.6000;
	points[27] = (5675.3545, 4532.4805, 295.0591);
	angles[27] = (0, 90, -30.8379);
	at[27] = 6.9000;
	points[28] = (5668.4253, 4532.4805, 290.9311);
	angles[28] = (0, 90, -40.1056);
	at[28] = 6.9500;
	points[29] = (5678.2676, 4532.4805, 291.4370);
	angles[29] = (0, 90, -78.5818);
	at[29] = 7;
	points[30] = (5686.2202, 4532.4805, 291.4370);
	angles[30] = (0, 270, -60.5471);
	at[30] = 7.0500;
	points[31] = (5694.2124, 4532.4805, 291.4370);
	angles[31] = (0, 270, -32.5459);
	at[31] = 7.1000;
	points[32] = (5702.1655, 4532.4805, 291.4370);
	angles[32] = (0, 270, -16.8892);
	at[32] = 7.1500;
	points[33] = (5718.1104, 4532.4805, 291.4370);
	angles[33] = (0, 270, -4.4475);
	at[33] = 7.2500;
	points[34] = (5734.0552, 4532.4805, 291.4370);
	angles[34] = (0, 270, -1.1662);
	at[34] = 7.3500;
	points[35] = (6281.4961, 4532.4805, 291.4370);
	angles[35] = (0, 270, 0);
	at[35] = 10.7833;
	mover = getEnt("iz_obj_29", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_30()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5805.7871, 4532.4805, 372.9272);
	angles[0] = (0, -90, 30.8406);
	at[0] = 0;
	points[1] = (5886.2598, 4532.4805, 420.9646);
	angles[1] = (0, -90, 30.8379);
	at[1] = 0.4000;
	points[2] = (5967.0474, 4532.4805, 469.2047);
	angles[2] = (0, -90, 30.8379);
	at[2] = 0.7500;
	points[3] = (6058.9761, 4532.4805, 524.0748);
	angles[3] = (0, -90, 30.8379);
	at[3] = 1.1000;
	points[4] = (6163.5039, 4532.4805, 586.4843);
	angles[4] = (0, -90, 30.8379);
	at[4] = 1.4500;
	points[5] = (6179.3701, 4532.4805, 577.4606);
	angles[5] = (0, -90, 2.3794);
	at[5] = 1.5000;
	points[6] = (6194.9609, 4532.4805, 568.1536);
	angles[6] = (0, -90, -13.5903);
	at[6] = 1.5500;
	points[7] = (6210.2754, 4532.4805, 559.0157);
	angles[7] = (0, -90, -21.9740);
	at[7] = 1.6000;
	points[8] = (6225.2754, 4532.4805, 550.0472);
	angles[8] = (0, -90, -26.2951);
	at[8] = 1.6500;
	points[9] = (6282.6772, 4532.4805, 515.7874);
	angles[9] = (0, -90, -30.5255);
	at[9] = 1.8500;
	points[10] = (6335.9844, 4532.4805, 483.9685);
	angles[10] = (0, -90, -30.8164);
	at[10] = 2.0500;
	points[11] = (6385.4722, 4532.4805, 454.4252);
	angles[11] = (0, -90, -30.8364);
	at[11] = 2.2500;
	points[12] = (6442.4014, 4532.4805, 420.4370);
	angles[12] = (0, -90, -30.8377);
	at[12] = 2.5000;
	points[13] = (6504.0942, 4532.4805, 383.5984);
	angles[13] = (0, -90, -30.8379);
	at[13] = 2.8000;
	points[14] = (6559.3306, 4532.4805, 350.6307);
	angles[14] = (0, -90, -30.8379);
	at[14] = 3.1000;
	points[15] = (6608.7402, 4532.4805, 321.1287);
	angles[15] = (0, -90, -30.8379);
	at[15] = 3.4000;
	points[16] = (6652.9526, 4532.4805, 294.7280);
	angles[16] = (0, -90, -30.8379);
	at[16] = 3.7000;
	points[17] = (6659.8428, 4532.4805, 290.6059);
	angles[17] = (0, -90, -40.1056);
	at[17] = 3.7500;
	points[18] = (6648.8584, 4532.4805, 291.4370);
	angles[18] = (0, -90, -78.5818);
	at[18] = 3.8000;
	points[19] = (6640.9058, 4532.4805, 291.4370);
	angles[19] = (0, -270, -60.5471);
	at[19] = 3.8500;
	points[20] = (6632.9136, 4532.4805, 291.4370);
	angles[20] = (0, -270, -32.5459);
	at[20] = 3.9000;
	points[21] = (6624.9609, 4532.4805, 291.4370);
	angles[21] = (0, -270, -16.8892);
	at[21] = 3.9500;
	points[22] = (6609.0161, 4532.4805, 291.4370);
	angles[22] = (0, -270, -4.4475);
	at[22] = 4.0500;
	points[23] = (6593.0713, 4532.4805, 291.4370);
	angles[23] = (0, -270, -1.1662);
	at[23] = 4.1500;
	points[24] = (5676.2202, 4532.4805, 291.4370);
	angles[24] = (0, -270, 0);
	at[24] = 9.9000;
	points[25] = (5669.0552, 4532.4805, 291.4370);
	angles[25] = (0, -270, 9.2678);
	at[25] = 9.9500;
	points[26] = (5683.4248, 4532.4805, 299.8693);
	angles[26] = (0, -270, 88.6151);
	at[26] = 10.0500;
	points[27] = (5690.5508, 4532.4805, 304.1378);
	angles[27] = (0, -450, 63.3837);
	at[27] = 10.1000;
	points[28] = (5697.8350, 4532.4805, 308.4854);
	angles[28] = (0, -450, 47.7271);
	at[28] = 10.1500;
	points[29] = (5712.8350, 4532.4805, 317.4248);
	angles[29] = (0, -450, 35.2852);
	at[29] = 10.2500;
	points[30] = (5761.1812, 4532.4805, 346.3036);
	angles[30] = (0, -450, 30.9179);
	at[30] = 10.5500;
	points[31] = (5805.7871, 4532.4805, 372.9272);
	angles[31] = (0, -450, 30.8406);
	at[31] = 10.8000;
	mover = getEnt("iz_obj_30", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_31()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1373.0315, -8196.2598, 335.4075);
	angles[0] = (0, 0, 32.0756);
	at[0] = 0;
	points[1] = (1373.0315, -8116.6929, 384.3650);
	angles[1] = (0, 0, 31.6087);
	at[1] = 0.4500;
	points[2] = (1373.0315, -8066.3384, 415.3661);
	angles[2] = (0, 0, 31.6076);
	at[2] = 0.7000;
	points[3] = (1373.0315, -8022.4805, 442.3504);
	angles[3] = (0, 0, 31.6075);
	at[3] = 0.9000;
	points[4] = (1373.0315, -7962.7954, 479.0709);
	angles[4] = (0, 0, 31.6075);
	at[4] = 1.1500;
	points[5] = (1373.0315, -7910.8662, 511.0354);
	angles[5] = (0, 0, 31.6075);
	at[5] = 1.3500;
	points[6] = (1373.0315, -7854.8823, 545.4961);
	angles[6] = (0, 0, 31.6075);
	at[6] = 1.5500;
	points[7] = (1373.0315, -7794.4883, 582.6536);
	angles[7] = (0, 0, 31.6075);
	at[7] = 1.7500;
	points[8] = (1373.0315, -7778.7402, 581.0709);
	angles[8] = (0, 0, 10.5973);
	at[8] = 1.8000;
	points[9] = (1373.0315, -7763.1499, 571.4882);
	angles[9] = (0, 0, -9.4980);
	at[9] = 1.8500;
	points[10] = (1373.0315, -7747.8745, 562.0827);
	angles[10] = (0, 0, -20.2176);
	at[10] = 1.9000;
	points[11] = (1373.0315, -7732.8740, 552.8583);
	angles[11] = (0, 0, -25.7664);
	at[11] = 1.9500;
	points[12] = (1373.0315, -7689.5669, 526.2047);
	angles[12] = (0, 0, -30.8230);
	at[12] = 2.1000;
	points[13] = (1373.0315, -7622.6382, 485.0079);
	angles[13] = (0, 0, -31.5800);
	at[13] = 2.3500;
	points[14] = (1373.0315, -7573.4644, 454.7480);
	angles[14] = (0, 0, -31.6056);
	at[14] = 2.5500;
	points[15] = (1373.0315, -7517.0083, 420.0040);
	angles[15] = (0, 0, -31.6075);
	at[15] = 2.8000;
	points[16] = (1373.0315, -7455.9448, 382.4291);
	angles[16] = (0, 0, -31.6075);
	at[16] = 3.1000;
	points[17] = (1373.0315, -7401.4175, 348.8870);
	angles[17] = (0, 0, -31.6075);
	at[17] = 3.4000;
	points[18] = (1373.0315, -7352.7559, 318.9460);
	angles[18] = (0, 0, -31.6075);
	at[18] = 3.7000;
	points[19] = (1373.0315, -7309.3306, 292.2193);
	angles[19] = (0, 0, -31.6075);
	at[19] = 4;
	points[20] = (1373.0315, -7314.5669, 291.4370);
	angles[20] = (0, 0, -65.6651);
	at[20] = 4.0500;
	points[21] = (1373.0315, -7322.5200, 291.4370);
	angles[21] = (0, -180, -71.9039);
	at[21] = 4.1000;
	points[22] = (1373.0315, -7330.5122, 291.4370);
	angles[22] = (0, -180, -39.5012);
	at[22] = 4.1500;
	points[23] = (1373.0315, -7338.4648, 291.4370);
	angles[23] = (0, -180, -20.6329);
	at[23] = 4.2000;
	points[24] = (1373.0315, -7346.4570, 291.4370);
	angles[24] = (0, -180, -10.6208);
	at[24] = 4.2500;
	points[25] = (1373.0315, -7354.4097, 291.4370);
	angles[25] = (0, -180, -5.4455);
	at[25] = 4.3000;
	points[26] = (1373.0315, -7370.3545, 291.4370);
	angles[26] = (0, -180, -1.4282);
	at[26] = 4.4000;
	points[27] = (1373.0315, -8263.2676, 291.4370);
	angles[27] = (0, -180, 0);
	at[27] = 10;
	points[28] = (1373.0315, -8263.4258, 294.0740);
	angles[28] = (0, -180, 20.8907);
	at[28] = 10.0500;
	points[29] = (1373.0315, -8256.5361, 298.3287);
	angles[29] = (0, -180, 62.7417);
	at[29] = 10.1000;
	points[30] = (1373.0315, -8249.4883, 302.6646);
	angles[30] = (0, -360, 80.2589);
	at[30] = 10.1500;
	points[31] = (1373.0315, -8242.2842, 307.0823);
	angles[31] = (0, -360, 57.2945);
	at[31] = 10.2000;
	points[32] = (1373.0315, -8234.9609, 311.5839);
	angles[32] = (0, -360, 44.8692);
	at[32] = 10.2500;
	points[33] = (1373.0315, -8219.9209, 320.8453);
	angles[33] = (0, -360, 35.0936);
	at[33] = 10.3500;
	points[34] = (1373.0315, -8196.2598, 335.4075);
	angles[34] = (0, -360, 32.0755);
	at[34] = 10.5000;
	mover = getEnt("iz_obj_31", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_32()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1373.0315, -7379.5278, 335.4075);
	angles[0] = (0, 180, 32.0756);
	at[0] = 0;
	points[1] = (1373.0315, -7459.0947, 384.3650);
	angles[1] = (0, 180, 31.6087);
	at[1] = 0.4500;
	points[2] = (1373.0315, -7509.4492, 415.3661);
	angles[2] = (0, 180, 31.6076);
	at[2] = 0.7000;
	points[3] = (1373.0315, -7553.3071, 442.3504);
	angles[3] = (0, 180, 31.6075);
	at[3] = 0.9000;
	points[4] = (1373.0315, -7612.9922, 479.0709);
	angles[4] = (0, 180, 31.6075);
	at[4] = 1.1500;
	points[5] = (1373.0315, -7664.9214, 511.0354);
	angles[5] = (0, 180, 31.6075);
	at[5] = 1.3500;
	points[6] = (1373.0315, -7720.9053, 545.4961);
	angles[6] = (0, 180, 31.6075);
	at[6] = 1.5500;
	points[7] = (1373.0315, -7781.2993, 582.6536);
	angles[7] = (0, 180, 31.6075);
	at[7] = 1.7500;
	points[8] = (1373.0315, -7797.0474, 581.0709);
	angles[8] = (0, 180, 10.5973);
	at[8] = 1.8000;
	points[9] = (1373.0315, -7812.6377, 571.4882);
	angles[9] = (0, 180, -9.4980);
	at[9] = 1.8500;
	points[10] = (1373.0315, -7827.9131, 562.0827);
	angles[10] = (0, 180, -20.2176);
	at[10] = 1.9000;
	points[11] = (1373.0315, -7842.9136, 552.8583);
	angles[11] = (0, 180, -25.7664);
	at[11] = 1.9500;
	points[12] = (1373.0315, -7886.2207, 526.2047);
	angles[12] = (0, 180, -30.8230);
	at[12] = 2.1000;
	points[13] = (1373.0315, -7953.1494, 485.0079);
	angles[13] = (0, 180, -31.5800);
	at[13] = 2.3500;
	points[14] = (1373.0315, -8002.3232, 454.7480);
	angles[14] = (0, 180, -31.6056);
	at[14] = 2.5500;
	points[15] = (1373.0315, -8058.7793, 420.0040);
	angles[15] = (0, 180, -31.6075);
	at[15] = 2.8000;
	points[16] = (1373.0315, -8119.8428, 382.4291);
	angles[16] = (0, 180, -31.6075);
	at[16] = 3.1000;
	points[17] = (1373.0315, -8174.3701, 348.8870);
	angles[17] = (0, 180, -31.6075);
	at[17] = 3.4000;
	points[18] = (1373.0315, -8223.0322, 318.9460);
	angles[18] = (0, 180, -31.6075);
	at[18] = 3.7000;
	points[19] = (1373.0315, -8266.4570, 292.2193);
	angles[19] = (0, 180, -31.6075);
	at[19] = 4;
	points[20] = (1373.0315, -8261.2207, 291.4370);
	angles[20] = (0, 180, -65.6651);
	at[20] = 4.0500;
	points[21] = (1373.0315, -8253.2676, 291.4370);
	angles[21] = (0, 0, -71.9039);
	at[21] = 4.1000;
	points[22] = (1373.0315, -8245.2754, 291.4370);
	angles[22] = (0, 0, -39.5012);
	at[22] = 4.1500;
	points[23] = (1373.0315, -8237.3232, 291.4370);
	angles[23] = (0, 0, -20.6329);
	at[23] = 4.2000;
	points[24] = (1373.0315, -8229.3311, 291.4370);
	angles[24] = (0, 0, -10.6208);
	at[24] = 4.2500;
	points[25] = (1373.0315, -8221.3779, 291.4370);
	angles[25] = (0, 0, -5.4455);
	at[25] = 4.3000;
	points[26] = (1373.0315, -8205.4336, 291.4370);
	angles[26] = (0, 0, -1.4282);
	at[26] = 4.4000;
	points[27] = (1373.0315, -7312.5200, 291.4370);
	angles[27] = (0, 0, 0);
	at[27] = 10;
	points[28] = (1373.0315, -7312.3618, 294.0740);
	angles[28] = (0, 0, 20.8907);
	at[28] = 10.0500;
	points[29] = (1373.0315, -7319.2520, 298.3287);
	angles[29] = (0, 0, 62.7417);
	at[29] = 10.1000;
	points[30] = (1373.0315, -7326.2993, 302.6646);
	angles[30] = (0, -180, 80.2589);
	at[30] = 10.1500;
	points[31] = (1373.0315, -7333.5039, 307.0823);
	angles[31] = (0, -180, 57.2945);
	at[31] = 10.2000;
	points[32] = (1373.0315, -7340.8267, 311.5839);
	angles[32] = (0, -180, 44.8692);
	at[32] = 10.2500;
	points[33] = (1373.0315, -7355.8662, 320.8453);
	angles[33] = (0, -180, 35.0936);
	at[33] = 10.3500;
	points[34] = (1373.0315, -7379.5278, 335.4075);
	angles[34] = (0, -180, 32.0755);
	at[34] = 10.5000;
	mover = getEnt("iz_obj_32", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_33()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3070.8662, -8122.4805, 380.8189);
	angles[0] = (0, 0, 31.6089);
	at[0] = 0;
	points[1] = (3070.8662, -8051.3784, 424.5591);
	angles[1] = (0, 0, 31.6075);
	at[1] = 0.3500;
	points[2] = (3070.8662, -7970.3149, 474.4567);
	angles[2] = (0, 0, 31.6075);
	at[2] = 0.7000;
	points[3] = (3070.8662, -7877.8350, 531.3740);
	angles[3] = (0, 0, 31.6075);
	at[3] = 1.0500;
	points[4] = (3070.8662, -7788.2681, 586.4921);
	angles[4] = (0, 0, 31.6075);
	at[4] = 1.3500;
	points[5] = (3070.8662, -7772.5195, 577.2402);
	angles[5] = (0, 0, 2.5320);
	at[5] = 1.4000;
	points[6] = (3070.8662, -7757.0479, 567.7323);
	angles[6] = (0, 0, -13.8669);
	at[6] = 1.4500;
	points[7] = (3070.8662, -7741.8896, 558.3976);
	angles[7] = (0, 0, -22.4884);
	at[7] = 1.5000;
	points[8] = (3070.8662, -7727.0083, 549.2402);
	angles[8] = (0, 0, -26.9336);
	at[8] = 1.5500;
	points[9] = (3070.8662, -7670.2363, 514.2953);
	angles[9] = (0, 0, -31.2862);
	at[9] = 1.7500;
	points[10] = (3070.8662, -7617.5591, 481.9016);
	angles[10] = (0, 0, -31.5854);
	at[10] = 1.9500;
	points[11] = (3070.8662, -7568.7793, 451.8661);
	angles[11] = (0, 0, -31.6060);
	at[11] = 2.1500;
	points[12] = (3070.8662, -7512.7163, 417.3819);
	angles[12] = (0, 0, -31.6075);
	at[12] = 2.4000;
	points[13] = (3070.8662, -7452.1260, 380.0890);
	angles[13] = (0, 0, -31.6075);
	at[13] = 2.7000;
	points[14] = (3070.8662, -7398.0317, 346.7980);
	angles[14] = (0, 0, -31.6075);
	at[14] = 3;
	points[15] = (3070.8662, -7357.4019, 321.8028);
	angles[15] = (0, 0, -31.6075);
	at[15] = 3.2500;
	points[16] = (3070.8662, -7313.5039, 294.7693);
	angles[16] = (0, 0, -31.6075);
	at[16] = 3.5500;
	points[17] = (3070.8662, -7306.6538, 290.5547);
	angles[17] = (0, 0, -41.0587);
	at[17] = 3.6000;
	points[18] = (3070.8662, -7317.7163, 291.4370);
	angles[18] = (0, 0, -79.9142);
	at[18] = 3.6500;
	points[19] = (3070.8662, -7325.7085, 291.4370);
	angles[19] = (0, -180, -59.4687);
	at[19] = 3.7000;
	points[20] = (3070.8662, -7333.6611, 291.4370);
	angles[20] = (0, -180, -31.9079);
	at[20] = 3.7500;
	points[21] = (3070.8662, -7341.6533, 291.4370);
	angles[21] = (0, -180, -16.5495);
	at[21] = 3.8000;
	points[22] = (3070.8662, -7357.5981, 291.4370);
	angles[22] = (0, -180, -4.3572);
	at[22] = 3.9000;
	points[23] = (3070.8662, -7381.4966, 291.4370);
	angles[23] = (0, -180, -0.5850);
	at[23] = 4.0500;
	points[24] = (3070.8662, -8266.4570, 291.4370);
	angles[24] = (0, -180, 0);
	at[24] = 9.6000;
	points[25] = (3070.8662, -8262.9922, 294.3425);
	angles[25] = (0, -180, 34.0577);
	at[25] = 9.6500;
	points[26] = (3070.8662, -8256.0625, 298.6024);
	angles[26] = (0, -180, 76.4886);
	at[26] = 9.7000;
	points[27] = (3070.8662, -8249.0156, 302.9429);
	angles[27] = (0, -360, 71.1087);
	at[27] = 9.7500;
	points[28] = (3070.8662, -8241.8506, 307.3661);
	angles[28] = (0, -360, 52.2404);
	at[28] = 9.8000;
	points[29] = (3070.8662, -8234.4883, 311.8732);
	angles[29] = (0, -360, 42.2283);
	at[29] = 9.8500;
	points[30] = (3070.8662, -8219.4492, 321.1457);
	angles[30] = (0, -360, 34.3966);
	at[30] = 9.9500;
	points[31] = (3070.8662, -8170.6694, 351.1512);
	angles[31] = (0, -360, 31.6577);
	at[31] = 10.2500;
	points[32] = (3070.8662, -8122.4805, 380.8189);
	angles[32] = (0, -360, 31.6089);
	at[32] = 10.5167;
	mover = getEnt("iz_obj_33", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_34()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3070.8662, -7453.3071, 380.8189);
	angles[0] = (0, 180, 31.6089);
	at[0] = 0;
	points[1] = (3070.8662, -7524.4092, 424.5591);
	angles[1] = (0, 180, 31.6075);
	at[1] = 0.3500;
	points[2] = (3070.8662, -7605.4727, 474.4567);
	angles[2] = (0, 180, 31.6075);
	at[2] = 0.7000;
	points[3] = (3070.8662, -7697.9526, 531.3740);
	angles[3] = (0, 180, 31.6075);
	at[3] = 1.0500;
	points[4] = (3070.8662, -7787.5195, 586.4921);
	angles[4] = (0, 180, 31.6075);
	at[4] = 1.3500;
	points[5] = (3070.8662, -7803.2681, 577.2402);
	angles[5] = (0, 180, 2.5320);
	at[5] = 1.4000;
	points[6] = (3070.8662, -7818.7397, 567.7323);
	angles[6] = (0, 180, -13.8669);
	at[6] = 1.4500;
	points[7] = (3070.8662, -7833.8979, 558.3976);
	angles[7] = (0, 180, -22.4884);
	at[7] = 1.5000;
	points[8] = (3070.8662, -7848.7793, 549.2402);
	angles[8] = (0, 180, -26.9336);
	at[8] = 1.5500;
	points[9] = (3070.8662, -7905.5513, 514.2953);
	angles[9] = (0, 180, -31.2862);
	at[9] = 1.7500;
	points[10] = (3070.8662, -7958.2285, 481.9016);
	angles[10] = (0, 180, -31.5854);
	at[10] = 1.9500;
	points[11] = (3070.8662, -8007.0083, 451.8661);
	angles[11] = (0, 180, -31.6060);
	at[11] = 2.1500;
	points[12] = (3070.8662, -8063.0708, 417.3819);
	angles[12] = (0, 180, -31.6075);
	at[12] = 2.4000;
	points[13] = (3070.8662, -8123.6616, 380.0890);
	angles[13] = (0, 180, -31.6075);
	at[13] = 2.7000;
	points[14] = (3070.8662, -8177.7559, 346.7980);
	angles[14] = (0, 180, -31.6075);
	at[14] = 3;
	points[15] = (3070.8662, -8218.3857, 321.8028);
	angles[15] = (0, 180, -31.6075);
	at[15] = 3.2500;
	points[16] = (3070.8662, -8262.2832, 294.7693);
	angles[16] = (0, 180, -31.6075);
	at[16] = 3.5500;
	points[17] = (3070.8662, -8269.1338, 290.5547);
	angles[17] = (0, 180, -41.0587);
	at[17] = 3.6000;
	points[18] = (3070.8662, -8258.0713, 291.4370);
	angles[18] = (0, 180, -79.9142);
	at[18] = 3.6500;
	points[19] = (3070.8662, -8250.0791, 291.4370);
	angles[19] = (0, 0, -59.4687);
	at[19] = 3.7000;
	points[20] = (3070.8662, -8242.1260, 291.4370);
	angles[20] = (0, 0, -31.9079);
	at[20] = 3.7500;
	points[21] = (3070.8662, -8234.1338, 291.4370);
	angles[21] = (0, 0, -16.5495);
	at[21] = 3.8000;
	points[22] = (3070.8662, -8218.1895, 291.4370);
	angles[22] = (0, 0, -4.3572);
	at[22] = 3.9000;
	points[23] = (3070.8662, -8194.2910, 291.4370);
	angles[23] = (0, 0, -0.5850);
	at[23] = 4.0500;
	points[24] = (3070.8662, -7309.3306, 291.4370);
	angles[24] = (0, 0, 0);
	at[24] = 9.6000;
	points[25] = (3070.8662, -7312.7954, 294.3425);
	angles[25] = (0, 0, 34.0577);
	at[25] = 9.6500;
	points[26] = (3070.8662, -7319.7246, 298.6024);
	angles[26] = (0, 0, 76.4886);
	at[26] = 9.7000;
	points[27] = (3070.8662, -7326.7720, 302.9429);
	angles[27] = (0, -180, 71.1087);
	at[27] = 9.7500;
	points[28] = (3070.8662, -7333.9370, 307.3661);
	angles[28] = (0, -180, 52.2404);
	at[28] = 9.8000;
	points[29] = (3070.8662, -7341.2603, 311.8732);
	angles[29] = (0, -180, 42.2283);
	at[29] = 9.8500;
	points[30] = (3070.8662, -7356.3384, 321.1457);
	angles[30] = (0, -180, 34.3966);
	at[30] = 9.9500;
	points[31] = (3070.8662, -7405.1182, 351.1512);
	angles[31] = (0, -180, 31.6577);
	at[31] = 10.2500;
	points[32] = (3070.8662, -7453.3071, 380.8189);
	angles[32] = (0, -180, 31.6089);
	at[32] = 10.5167;
	mover = getEnt("iz_obj_34", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_35()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5008.6221, -3159.4490, 356.3965);
	angles[0] = (0, -90, 28.0841);
	at[0] = 0;
	points[1] = (5096.8110, -3159.4490, 403.4291);
	angles[1] = (0, -90, 28.0725);
	at[1] = 0.4500;
	points[2] = (5151.8901, -3159.4490, 432.8189);
	angles[2] = (0, -90, 28.0726);
	at[2] = 0.7000;
	points[3] = (5199.4487, -3159.4490, 458.1851);
	angles[3] = (0, -90, 28.0726);
	at[3] = 0.9000;
	points[4] = (5263.6221, -3159.4490, 492.3976);
	angles[4] = (0, -90, 28.0726);
	at[4] = 1.1500;
	points[5] = (5318.9766, -3159.4490, 521.9291);
	angles[5] = (0, -90, 28.0726);
	at[5] = 1.3500;
	points[6] = (5425.3545, -3159.4490, 578.6653);
	angles[6] = (0, -90, 28.0726);
	at[6] = 1.7000;
	points[7] = (5441.6143, -3159.4490, 587.3307);
	angles[7] = (0, -90, 17.7446);
	at[7] = 1.7500;
	points[8] = (5457.9131, -3159.4490, 577.4016);
	angles[8] = (0, -90, -3.9688);
	at[8] = 1.8000;
	points[9] = (5473.9370, -3159.4490, 568.8544);
	angles[9] = (0, -90, -15.6407);
	at[9] = 1.8500;
	points[10] = (5505.1968, -3159.4490, 552.1851);
	angles[10] = (0, -90, -24.8057);
	at[10] = 1.9500;
	points[11] = (5564.6064, -3159.4490, 520.5079);
	angles[11] = (0, -90, -27.8479);
	at[11] = 2.1500;
	points[12] = (5633.3857, -3159.4490, 483.8150);
	angles[12] = (0, -90, -28.0645);
	at[12] = 2.4000;
	points[13] = (5696.5747, -3159.4490, 450.1142);
	angles[13] = (0, -90, -28.0722);
	at[13] = 2.6500;
	points[14] = (5754.6064, -3159.4490, 419.1575);
	angles[14] = (0, -90, -28.0726);
	at[14] = 2.9000;
	points[15] = (5818.0713, -3159.4490, 385.3177);
	angles[15] = (0, -90, -28.0726);
	at[15] = 3.2000;
	points[16] = (5884.3701, -3159.4490, 349.9606);
	angles[16] = (0, -90, -28.0726);
	at[16] = 3.5500;
	points[17] = (5935.2363, -3159.4490, 322.8272);
	angles[17] = (0, -90, -28.0726);
	at[17] = 3.8500;
	points[18] = (5988.3857, -3159.4490, 294.4768);
	angles[18] = (0, -90, -28.0726);
	at[18] = 4.2000;
	points[19] = (5995.4727, -3159.4490, 290.6949);
	angles[19] = (0, -90, -36.6561);
	at[19] = 4.2500;
	points[20] = (5984.5278, -3159.4490, 291.4370);
	angles[20] = (0, -90, -73.5703);
	at[20] = 4.3000;
	points[21] = (5976.5747, -3159.4490, 291.4370);
	angles[21] = (0, -270, -64.7480);
	at[21] = 4.3500;
	points[22] = (5968.5830, -3159.4490, 291.4370);
	angles[22] = (0, -270, -35.0658);
	at[22] = 4.4000;
	points[23] = (5960.6299, -3159.4490, 291.4370);
	angles[23] = (0, -270, -18.2372);
	at[23] = 4.4500;
	points[24] = (5952.6382, -3159.4490, 291.4370);
	angles[24] = (0, -270, -9.3765);
	at[24] = 4.5000;
	points[25] = (5944.6851, -3159.4490, 291.4370);
	angles[25] = (0, -270, -4.8060);
	at[25] = 4.5500;
	points[26] = (5920.7480, -3159.4490, 291.4370);
	angles[26] = (0, -270, -0.6453);
	at[26] = 4.7000;
	points[27] = (4892.3228, -3159.4490, 291.4370);
	angles[27] = (0, -270, 0);
	at[27] = 11.1500;
	points[28] = (4885, -3159.4490, 291.4370);
	angles[28] = (0, -270, 8.5836);
	at[28] = 11.2000;
	points[29] = (4895.5117, -3159.4490, 296.0713);
	angles[29] = (0, -270, 45.4979);
	at[29] = 11.2500;
	points[30] = (4902.7168, -3159.4490, 299.9229);
	angles[30] = (0, -270, 87.1795);
	at[30] = 11.3000;
	points[31] = (4910.0791, -3159.4490, 303.8405);
	angles[31] = (0, -90, 63.1382);
	at[31] = 11.3500;
	points[32] = (4917.5195, -3159.4490, 307.8248);
	angles[32] = (0, -90, 46.3095);
	at[32] = 11.4000;
	points[33] = (4925.1182, -3159.4490, 311.8772);
	angles[33] = (0, -90, 37.4490);
	at[33] = 11.4500;
	points[34] = (4932.8740, -3159.4490, 315.9980);
	angles[34] = (0, -90, 32.8784);
	at[34] = 11.5000;
	points[35] = (4956.8506, -3159.4490, 328.7878);
	angles[35] = (0, -90, 28.7178);
	at[35] = 11.6500;
	points[36] = (5008.6221, -3159.4490, 356.3965);
	angles[36] = (0, -90, 28.0841);
	at[36] = 11.9500;
	mover = getEnt("iz_obj_35", "targetname");
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
