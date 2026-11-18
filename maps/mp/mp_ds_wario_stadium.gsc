main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_wario_stadium", 0);

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
	ambientPlay("iz_0_84", 2);
	level thread iz_music("iz_7_se_cr_gcw_env_aud");
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
	level.iz_route[level.iz_route.size] = (-1174, 57, 623);
	level.iz_route[level.iz_route.size] = (1266, 101, 637);
	level.iz_route[level.iz_route.size] = (2048, 266, 651);
	level.iz_route[level.iz_route.size] = (2669, 626, 675);
	level.iz_route[level.iz_route.size] = (2861, 1242, 673);
	level.iz_route[level.iz_route.size] = (2870, 1972, 662);
	level.iz_route[level.iz_route.size] = (2303, 2524, 645);
	level.iz_route[level.iz_route.size] = (1319, 2828, 657);
	level.iz_route[level.iz_route.size] = (991, 3212, 661);
	level.iz_route[level.iz_route.size] = (939, 3817, 659);
	level.iz_route[level.iz_route.size] = (866, 4606, 713);
	level.iz_route[level.iz_route.size] = (601, 5010, 758);
	level.iz_route[level.iz_route.size] = (183, 5234, 795);
	level.iz_route[level.iz_route.size] = (-297, 5269, 806);
	level.iz_route[level.iz_route.size] = (-848, 5142, 804);
	level.iz_route[level.iz_route.size] = (-1283, 4794, 791);
	level.iz_route[level.iz_route.size] = (-1758, 4153, 782);
	level.iz_route[level.iz_route.size] = (-1932, 3351, 774);
	level.iz_route[level.iz_route.size] = (-2030, 2414, 813);
	level.iz_route[level.iz_route.size] = (-2069, 1190, 1065);
	level.iz_route[level.iz_route.size] = (-2078, 572, 1303);
	level.iz_route[level.iz_route.size] = (-2093, -74, 1255);
	level.iz_route[level.iz_route.size] = (-2098, -431, 1246);
	level.iz_route[level.iz_route.size] = (-2057, -1747, 1039);
	level.iz_route[level.iz_route.size] = (-1986, -2363, 1009);
	level.iz_route[level.iz_route.size] = (-1829, -3175, 995);
	level.iz_route[level.iz_route.size] = (-1605, -3744, 986);
	level.iz_route[level.iz_route.size] = (-1318, -4178, 955);
	level.iz_route[level.iz_route.size] = (-859, -4601, 876);
	level.iz_route[level.iz_route.size] = (-189, -4932, 760);
	level.iz_route[level.iz_route.size] = (360, -5085, 670);
	level.iz_route[level.iz_route.size] = (1122, -5235, 533);
	level.iz_route[level.iz_route.size] = (1562, -5231, 521);
	level.iz_route[level.iz_route.size] = (2738, -4903, 513);
	level.iz_route[level.iz_route.size] = (2994, -4882, 513);
	level.iz_route[level.iz_route.size] = (3193, -4893, 513);
	level.iz_route[level.iz_route.size] = (4340, -4952, 513);
	level.iz_route[level.iz_route.size] = (4647, -4968, 513);
	level.iz_route[level.iz_route.size] = (4839, -4984, 513);
	level.iz_route[level.iz_route.size] = (5963, -5295, 513);
	level.iz_route[level.iz_route.size] = (6249, -5330, 513);
	level.iz_route[level.iz_route.size] = (6509, -5308, 513);
	level.iz_route[level.iz_route.size] = (7644, -5257, 562);
	level.iz_route[level.iz_route.size] = (8210, -5157, 651);
	level.iz_route[level.iz_route.size] = (8706, -5023, 712);
	level.iz_route[level.iz_route.size] = (9108, -4812, 752);
	level.iz_route[level.iz_route.size] = (9489, -4562, 787);
	level.iz_route[level.iz_route.size] = (9734, -4190, 819);
	level.iz_route[level.iz_route.size] = (9858, -3702, 858);
	level.iz_route[level.iz_route.size] = (9873, -3197, 897);
	level.iz_route[level.iz_route.size] = (9806, -2680, 936);
	level.iz_route[level.iz_route.size] = (9594, -2234, 965);
	level.iz_route[level.iz_route.size] = (9155, -1646, 1026);
	level.iz_route[level.iz_route.size] = (8777, -1198, 1140);
	level.iz_route[level.iz_route.size] = (8474, -868, 1134);
	level.iz_route[level.iz_route.size] = (8194, -582, 1043);
	level.iz_route[level.iz_route.size] = (7942, -328, 1007);
	level.iz_route[level.iz_route.size] = (7641, -21, 987);
	level.iz_route[level.iz_route.size] = (7273, 355, 992);
	level.iz_route[level.iz_route.size] = (7013, 600, 1042);
	level.iz_route[level.iz_route.size] = (6754, 856, 1118);
	level.iz_route[level.iz_route.size] = (6568, 1046, 1108);
	level.iz_route[level.iz_route.size] = (6122, 1482, 984);
	level.iz_route[level.iz_route.size] = (5657, 1931, 891);
	level.iz_route[level.iz_route.size] = (5095, 2492, 828);
	level.iz_route[level.iz_route.size] = (4778, 2830, 789);
	level.iz_route[level.iz_route.size] = (4550, 3250, 734);
	level.iz_route[level.iz_route.size] = (4404, 3820, 659);
	level.iz_route[level.iz_route.size] = (4316, 4514, 581);
	level.iz_route[level.iz_route.size] = (4350, 5159, 551);
	level.iz_route[level.iz_route.size] = (4493, 5966, 548);
	level.iz_route[level.iz_route.size] = (4540, 6374, 549);
	level.iz_route[level.iz_route.size] = (4516, 6681, 550);
	level.iz_route[level.iz_route.size] = (4414, 7005, 550);
	level.iz_route[level.iz_route.size] = (4218, 7219, 547);
	level.iz_route[level.iz_route.size] = (3864, 7408, 540);
	level.iz_route[level.iz_route.size] = (3331, 7669, 529);
	level.iz_route[level.iz_route.size] = (3131, 7944, 518);
	level.iz_route[level.iz_route.size] = (3032, 8302, 506);
	level.iz_route[level.iz_route.size] = (3099, 8682, 495);
	level.iz_route[level.iz_route.size] = (3369, 9111, 492);
	level.iz_route[level.iz_route.size] = (3604, 9395, 495);
	level.iz_route[level.iz_route.size] = (3735, 9664, 503);
	level.iz_route[level.iz_route.size] = (3644, 10029, 510);
	level.iz_route[level.iz_route.size] = (3467, 10338, 501);
	level.iz_route[level.iz_route.size] = (2994, 10724, 474);
	level.iz_route[level.iz_route.size] = (2211, 11337, 483);
	level.iz_route[level.iz_route.size] = (1495, 11812, 530);
	level.iz_route[level.iz_route.size] = (883, 12149, 569);
	level.iz_route[level.iz_route.size] = (318, 12178, 601);
	level.iz_route[level.iz_route.size] = (-292, 11897, 645);
	level.iz_route[level.iz_route.size] = (-752, 11476, 686);
	level.iz_route[level.iz_route.size] = (-1061, 11055, 722);
	level.iz_route[level.iz_route.size] = (-1269, 10591, 805);
	level.iz_route[level.iz_route.size] = (-1397, 10251, 877);
	level.iz_route[level.iz_route.size] = (-1521, 9884, 910);
	level.iz_route[level.iz_route.size] = (-1825, 9058, 1016);
	level.iz_route[level.iz_route.size] = (-1918, 8790, 1006);
	level.iz_route[level.iz_route.size] = (-2077, 8325, 893);
	level.iz_route[level.iz_route.size] = (-2249, 7837, 747);
	level.iz_route[level.iz_route.size] = (-2559, 6928, 656);
	level.iz_route[level.iz_route.size] = (-2960, 5805, 650);
	level.iz_route[level.iz_route.size] = (-3162, 5214, 712);
	level.iz_route[level.iz_route.size] = (-3319, 4707, 673);
	level.iz_route[level.iz_route.size] = (-3571, 4269, 645);
	level.iz_route[level.iz_route.size] = (-3853, 3716, 717);
	level.iz_route[level.iz_route.size] = (-4122, 3209, 623);
	level.iz_route[level.iz_route.size] = (-4362, 2884, 622);
	level.iz_route[level.iz_route.size] = (-4785, 2657, 623);
	level.iz_route[level.iz_route.size] = (-5323, 2568, 629);
	level.iz_route[level.iz_route.size] = (-6025, 2528, 629);
	level.iz_route[level.iz_route.size] = (-7014, 2449, 629);
	level.iz_route[level.iz_route.size] = (-7830, 2301, 615);
	level.iz_route[level.iz_route.size] = (-8314, 2046, 602);
	level.iz_route[level.iz_route.size] = (-8541, 1673, 601);
	level.iz_route[level.iz_route.size] = (-8611, 1191, 602);
	level.iz_route[level.iz_route.size] = (-8465, 579, 599);
	level.iz_route[level.iz_route.size] = (-8135, 312, 600);
	level.iz_route[level.iz_route.size] = (-7570, 187, 606);
	level.iz_route[level.iz_route.size] = (-7045, 163, 614);
	level.iz_route[level.iz_route.size] = (-6361, 106, 624);
	level.iz_route[level.iz_route.size] = (-5470, 74, 776);
	level.iz_route[level.iz_route.size] = (-5110, 78, 823);
	level.iz_route[level.iz_route.size] = (-3876, 56, 623);
	level.iz_route[level.iz_route.size] = (-2249, 61, 622);
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
	points[0] = (4144.4883, 6841.0234, 812.0079);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4144.4883, 6841.0234, 812.0079);
	angles[1] = (70, -70, -90);
	at[1] = 1.8000;
	points[2] = (4144.4883, 6841.0234, 812.0079);
	angles[2] = (0, -140, -180);
	at[2] = 3.6000;
	points[3] = (4144.4883, 6841.0234, 812.0079);
	angles[3] = (-180, -180, -180);
	at[3] = 7.2000;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3308.1536, 9762.8350, 812.0079);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3308.1536, 9762.8350, 812.0079);
	angles[1] = (70, -70, -90);
	at[1] = 1.8000;
	points[2] = (3308.1536, 9762.8350, 812.0079);
	angles[2] = (0, -140, -180);
	at[2] = 3.6000;
	points[3] = (3308.1536, 9762.8350, 812.0079);
	angles[3] = (-180, -180, -180);
	at[3] = 7.2000;
	mover = getEnt("iz_obj_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (8817.0869, -1002.9016, 1054.1654);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (8817.0869, -1002.9016, 1054.1654);
	angles[1] = (45, -45, -90);
	at[1] = 1.5000;
	points[2] = (8817.0869, -1002.9016, 1054.1654);
	angles[2] = (0, -90, -180);
	at[2] = 3;
	points[3] = (8817.0869, -1002.9016, 1054.1654);
	angles[3] = (-180, -180, -180);
	at[3] = 6;
	mover = getEnt("iz_obj_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6624.2520, 849.8464, 1025.5276);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6624.2520, 849.8464, 1025.5276);
	angles[1] = (45, -45, -90);
	at[1] = 1.5000;
	points[2] = (6624.2520, 849.8464, 1025.5276);
	angles[2] = (0, -90, -180);
	at[2] = 3;
	points[3] = (6624.2520, 849.8464, 1025.5276);
	angles[3] = (-180, -180, -180);
	at[3] = 6;
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
