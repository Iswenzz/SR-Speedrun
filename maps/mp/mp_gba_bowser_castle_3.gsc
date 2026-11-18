main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_bowser_castle_3", 0);

	setExpFog(16240.1572, 29927.4102, 0.5294, 0.4314, 0.6510, 0);

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
	ambientPlay("iz_0_r_agb_kuppa32", 2);
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
	level.iz_route[level.iz_route.size] = (-7539, -5210, 1063);
	level.iz_route[level.iz_route.size] = (-7540, -6568, 1063);
	level.iz_route[level.iz_route.size] = (-7019, -7399, 1063);
	level.iz_route[level.iz_route.size] = (-5677, -7395, 1063);
	level.iz_route[level.iz_route.size] = (-4640, -7470, 1063);
	level.iz_route[level.iz_route.size] = (-3992, -7562, 1063);
	level.iz_route[level.iz_route.size] = (-2884, -7562, 1063);
	level.iz_route[level.iz_route.size] = (-1668, -7561, 1063);
	level.iz_route[level.iz_route.size] = (-687, -7562, 1063);
	level.iz_route[level.iz_route.size] = (-196, -7329, 1063);
	level.iz_route[level.iz_route.size] = (-194, -6237, 1063);
	level.iz_route[level.iz_route.size] = (-192, -4620, 1063);
	level.iz_route[level.iz_route.size] = (-175, -3089, 1063);
	level.iz_route[level.iz_route.size] = (290, -2697, 1063);
	level.iz_route[level.iz_route.size] = (1561, -2699, 1063);
	level.iz_route[level.iz_route.size] = (2975, -2700, 1063);
	level.iz_route[level.iz_route.size] = (4294, -2702, 1063);
	level.iz_route[level.iz_route.size] = (4724, -3081, 1063);
	level.iz_route[level.iz_route.size] = (4727, -4271, 1063);
	level.iz_route[level.iz_route.size] = (4729, -5628, 1063);
	level.iz_route[level.iz_route.size] = (5148, -6183, 1063);
	level.iz_route[level.iz_route.size] = (5859, -6207, 1063);
	level.iz_route[level.iz_route.size] = (6644, -6232, 1063);
	level.iz_route[level.iz_route.size] = (7445, -6214, 1063);
	level.iz_route[level.iz_route.size] = (8285, -6212, 1063);
	level.iz_route[level.iz_route.size] = (8675, -5621, 1063);
	level.iz_route[level.iz_route.size] = (8676, -4687, 1063);
	level.iz_route[level.iz_route.size] = (8677, -3259, 1088);
	level.iz_route[level.iz_route.size] = (8677, -1777, 1093);
	level.iz_route[level.iz_route.size] = (8995, -979, 1063);
	level.iz_route[level.iz_route.size] = (8996, -58, 1093);
	level.iz_route[level.iz_route.size] = (9397, 585, 1063);
	level.iz_route[level.iz_route.size] = (9397, 1327, 1093);
	level.iz_route[level.iz_route.size] = (9784, 2083, 1063);
	level.iz_route[level.iz_route.size] = (9782, 2775, 1093);
	level.iz_route[level.iz_route.size] = (9918, 3720, 1063);
	level.iz_route[level.iz_route.size] = (9924, 5502, 1063);
	level.iz_route[level.iz_route.size] = (9924, 7253, 1063);
	level.iz_route[level.iz_route.size] = (9916, 8622, 1063);
	level.iz_route[level.iz_route.size] = (9907, 9752, 1063);
	level.iz_route[level.iz_route.size] = (9454, 10394, 1063);
	level.iz_route[level.iz_route.size] = (8713, 10379, 1063);
	level.iz_route[level.iz_route.size] = (7943, 10010, 1063);
	level.iz_route[level.iz_route.size] = (7943, 8841, 1063);
	level.iz_route[level.iz_route.size] = (7943, 7352, 1063);
	level.iz_route[level.iz_route.size] = (7943, 6276, 1063);
	level.iz_route[level.iz_route.size] = (7943, 4872, 1063);
	level.iz_route[level.iz_route.size] = (7485, 4115, 1063);
	level.iz_route[level.iz_route.size] = (6817, 3741, 1063);
	level.iz_route[level.iz_route.size] = (5018, 3747, 1063);
	level.iz_route[level.iz_route.size] = (3539, 3746, 1063);
	level.iz_route[level.iz_route.size] = (2332, 3894, 1063);
	level.iz_route[level.iz_route.size] = (1627, 3752, 1063);
	level.iz_route[level.iz_route.size] = (856, 3596, 1063);
	level.iz_route[level.iz_route.size] = (179, 3741, 1063);
	level.iz_route[level.iz_route.size] = (-543, 3895, 1063);
	level.iz_route[level.iz_route.size] = (-1671, 3756, 1063);
	level.iz_route[level.iz_route.size] = (-2394, 4114, 1063);
	level.iz_route[level.iz_route.size] = (-3042, 5527, 1063);
	level.iz_route[level.iz_route.size] = (-3767, 6632, 1063);
	level.iz_route[level.iz_route.size] = (-4021, 7088, 1063);
	level.iz_route[level.iz_route.size] = (-4338, 7585, 1063);
	level.iz_route[level.iz_route.size] = (-5044, 7588, 1063);
	level.iz_route[level.iz_route.size] = (-5566, 8062, 1063);
	level.iz_route[level.iz_route.size] = (-5571, 8609, 1063);
	level.iz_route[level.iz_route.size] = (-6072, 8987, 1063);
	level.iz_route[level.iz_route.size] = (-7174, 8986, 1063);
	level.iz_route[level.iz_route.size] = (-7586, 8611, 1063);
	level.iz_route[level.iz_route.size] = (-7567, 7504, 1063);
	level.iz_route[level.iz_route.size] = (-7576, 6367, 1063);
	level.iz_route[level.iz_route.size] = (-7583, 5191, 1063);
	level.iz_route[level.iz_route.size] = (-7539, 4527, 1063);
	level.iz_route[level.iz_route.size] = (-7447, 3972, 1063);
	level.iz_route[level.iz_route.size] = (-7543, 3304, 1063);
	level.iz_route[level.iz_route.size] = (-7636, 2656, 1063);
	level.iz_route[level.iz_route.size] = (-7534, 1979, 1063);
	level.iz_route[level.iz_route.size] = (-7557, 1341, 1063);
	level.iz_route[level.iz_route.size] = (-7496, 823, 1063);
	level.iz_route[level.iz_route.size] = (-7493, 288, 1063);
	level.iz_route[level.iz_route.size] = (-7565, -77, 1063);
	level.iz_route[level.iz_route.size] = (-7683, -447, 1063);
	level.iz_route[level.iz_route.size] = (-7549, -1954, 1063);
	level.iz_route[level.iz_route.size] = (-7557, -3295, 1063);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (10157.4805, 5905.5117, 1358.2677);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (10157.4805, 5905.5117, 1358.2677);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (10157.4805, 5905.5117, 1365.9410);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (10157.4805, 5905.5117, 1362.6968);
	angles[3] = (0, -180, 0);
	at[3] = 0.5500;
	points[4] = (10157.4805, 5905.5117, 1350.5945);
	angles[4] = (0, -180, 0);
	at[4] = 0.6000;
	points[5] = (10157.4805, 5905.5117, 1353.8386);
	angles[5] = (0, -180, 0);
	at[5] = 0.6500;
	points[6] = (10157.4805, 5905.5117, 1365.9410);
	angles[6] = (0, -180, 0);
	at[6] = 0.7000;
	points[7] = (10157.4805, 5905.5117, 1362.6968);
	angles[7] = (0, -180, 0);
	at[7] = 0.7500;
	points[8] = (10157.4805, 5905.5117, 1350.5945);
	angles[8] = (0, -180, 0);
	at[8] = 0.8000;
	points[9] = (10157.4805, 5905.5117, 1353.8386);
	angles[9] = (0, -180, 0);
	at[9] = 0.8500;
	points[10] = (10157.4805, 5905.5117, 1365.9410);
	angles[10] = (0, -180, 0);
	at[10] = 0.9000;
	points[11] = (10157.4805, 5905.5117, 1362.6968);
	angles[11] = (0, -180, 0);
	at[11] = 0.9500;
	points[12] = (10157.4805, 5905.5117, 1368.6024);
	angles[12] = (0, -180, 0);
	at[12] = 1;
	points[13] = (10157.4805, 5905.5117, 1501.4764);
	angles[13] = (0, -180, 0);
	at[13] = 1.1500;
	points[14] = (10157.4805, 5905.5117, 1471.3584);
	angles[14] = (0, -180, 0);
	at[14] = 1.2000;
	points[15] = (10157.4805, 5905.5117, 1396.0630);
	angles[15] = (0, -180, 0);
	at[15] = 1.2500;
	points[16] = (10157.4805, 5905.5117, 1275.5906);
	angles[16] = (0, -180, 0);
	at[16] = 1.3000;
	points[17] = (10157.4805, 5905.5117, 1109.9409);
	angles[17] = (0, -180, 0);
	at[17] = 1.3500;
	points[18] = (10157.4805, 5905.5117, 1062.9922);
	angles[18] = (0, -180, 0);
	at[18] = 1.4000;
	points[19] = (10157.4805, 5905.5117, 1062.9922);
	angles[19] = (0, -180, 0);
	at[19] = 2.3500;
	points[20] = (10157.4805, 5905.5117, 1068.8976);
	angles[20] = (0, -180, 0);
	at[20] = 2.4000;
	points[21] = (10157.4805, 5905.5117, 1352.3622);
	angles[21] = (0, -180, 0);
	at[21] = 4;
	points[22] = (10157.4805, 5905.5117, 1358.2677);
	angles[22] = (0, -180, 0);
	at[22] = 4.0500;
	points[23] = (10157.4805, 5905.5117, 1358.2677);
	angles[23] = (0, -180, 0);
	at[23] = 4.5500;
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
	points[0] = (-497.9685, -4000.0393, 1358.2677);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-497.9685, -4000.0393, 1358.2677);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (-497.9685, -4000.0393, 1365.9410);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (-497.9685, -4000.0393, 1362.6968);
	angles[3] = (0, -180, 0);
	at[3] = 0.5500;
	points[4] = (-497.9685, -4000.0393, 1350.5945);
	angles[4] = (0, -180, 0);
	at[4] = 0.6000;
	points[5] = (-497.9685, -4000.0393, 1353.8386);
	angles[5] = (0, -180, 0);
	at[5] = 0.6500;
	points[6] = (-497.9685, -4000.0393, 1365.9410);
	angles[6] = (0, -180, 0);
	at[6] = 0.7000;
	points[7] = (-497.9685, -4000.0393, 1362.6968);
	angles[7] = (0, -180, 0);
	at[7] = 0.7500;
	points[8] = (-497.9685, -4000.0393, 1350.5945);
	angles[8] = (0, -180, 0);
	at[8] = 0.8000;
	points[9] = (-497.9685, -4000.0393, 1353.8386);
	angles[9] = (0, -180, 0);
	at[9] = 0.8500;
	points[10] = (-497.9685, -4000.0393, 1365.9410);
	angles[10] = (0, -180, 0);
	at[10] = 0.9000;
	points[11] = (-497.9685, -4000.0393, 1362.6968);
	angles[11] = (0, -180, 0);
	at[11] = 0.9500;
	points[12] = (-497.9685, -4000.0393, 1368.6024);
	angles[12] = (0, -180, 0);
	at[12] = 1;
	points[13] = (-497.9685, -4000.0393, 1501.4764);
	angles[13] = (0, -180, 0);
	at[13] = 1.1500;
	points[14] = (-497.9685, -4000.0393, 1471.3584);
	angles[14] = (0, -180, 0);
	at[14] = 1.2000;
	points[15] = (-497.9685, -4000.0393, 1396.0630);
	angles[15] = (0, -180, 0);
	at[15] = 1.2500;
	points[16] = (-497.9685, -4000.0393, 1275.5906);
	angles[16] = (0, -180, 0);
	at[16] = 1.3000;
	points[17] = (-497.9685, -4000.0393, 1109.9409);
	angles[17] = (0, -180, 0);
	at[17] = 1.3500;
	points[18] = (-497.9685, -4000.0393, 1062.9922);
	angles[18] = (0, -180, 0);
	at[18] = 1.4000;
	points[19] = (-497.9685, -4000.0393, 1062.9922);
	angles[19] = (0, -180, 0);
	at[19] = 2.3500;
	points[20] = (-497.9685, -4000.0393, 1068.8976);
	angles[20] = (0, -180, 0);
	at[20] = 2.4000;
	points[21] = (-497.9685, -4000.0393, 1352.3622);
	angles[21] = (0, -180, 0);
	at[21] = 4;
	points[22] = (-497.9685, -4000.0393, 1358.2677);
	angles[22] = (0, -180, 0);
	at[22] = 4.0500;
	points[23] = (-497.9685, -4000.0393, 1358.2677);
	angles[23] = (0, -180, 0);
	at[23] = 4.5500;
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
	points[0] = (28.5052, -3247.3584, 1365.9410);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (28.5052, -3247.3584, 1362.6968);
	angles[1] = (0, -180, 0);
	at[1] = 0.0500;
	points[2] = (28.5052, -3247.3584, 1350.5945);
	angles[2] = (0, -180, 0);
	at[2] = 0.1000;
	points[3] = (28.5052, -3247.3584, 1353.8386);
	angles[3] = (0, -180, 0);
	at[3] = 0.1500;
	points[4] = (28.5052, -3247.3584, 1365.9410);
	angles[4] = (0, -180, 0);
	at[4] = 0.2000;
	points[5] = (28.5052, -3247.3584, 1362.6968);
	angles[5] = (0, -180, 0);
	at[5] = 0.2500;
	points[6] = (28.5052, -3247.3584, 1350.5945);
	angles[6] = (0, -180, 0);
	at[6] = 0.3000;
	points[7] = (28.5052, -3247.3584, 1353.8386);
	angles[7] = (0, -180, 0);
	at[7] = 0.3500;
	points[8] = (28.5052, -3247.3584, 1365.9410);
	angles[8] = (0, -180, 0);
	at[8] = 0.4000;
	points[9] = (28.5052, -3247.3584, 1362.6968);
	angles[9] = (0, -180, 0);
	at[9] = 0.4500;
	points[10] = (28.5052, -3247.3584, 1368.6024);
	angles[10] = (0, -180, 0);
	at[10] = 0.5000;
	points[11] = (28.5052, -3247.3584, 1501.4764);
	angles[11] = (0, -180, 0);
	at[11] = 0.6500;
	points[12] = (28.5052, -3247.3584, 1471.3584);
	angles[12] = (0, -180, 0);
	at[12] = 0.7000;
	points[13] = (28.5052, -3247.3584, 1396.0630);
	angles[13] = (0, -180, 0);
	at[13] = 0.7500;
	points[14] = (28.5052, -3247.3584, 1275.5906);
	angles[14] = (0, -180, 0);
	at[14] = 0.8000;
	points[15] = (28.5052, -3247.3584, 1109.9409);
	angles[15] = (0, -180, 0);
	at[15] = 0.8500;
	points[16] = (28.5052, -3247.3584, 1062.9922);
	angles[16] = (0, -180, 0);
	at[16] = 0.9000;
	points[17] = (28.5052, -3247.3584, 1062.9922);
	angles[17] = (0, -180, 0);
	at[17] = 1.8500;
	points[18] = (28.5052, -3247.3584, 1068.8976);
	angles[18] = (0, -180, 0);
	at[18] = 1.9000;
	points[19] = (28.5052, -3247.3584, 1352.3622);
	angles[19] = (0, -180, 0);
	at[19] = 3.5000;
	points[20] = (28.5052, -3247.3584, 1358.2677);
	angles[20] = (0, -180, 0);
	at[20] = 3.5500;
	points[21] = (28.5052, -3247.3584, 1358.2677);
	angles[21] = (0, -180, 0);
	at[21] = 4.5000;
	points[22] = (28.5052, -3247.3584, 1365.9410);
	angles[22] = (0, -180, 0);
	at[22] = 4.5500;
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
	points[0] = (8415.3545, -5610.2363, 1358.2677);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (8415.3545, -5610.2363, 1358.2677);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (8415.3545, -5610.2363, 1365.9410);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (8415.3545, -5610.2363, 1362.6968);
	angles[3] = (0, -180, 0);
	at[3] = 0.5500;
	points[4] = (8415.3545, -5610.2363, 1350.5945);
	angles[4] = (0, -180, 0);
	at[4] = 0.6000;
	points[5] = (8415.3545, -5610.2363, 1353.8386);
	angles[5] = (0, -180, 0);
	at[5] = 0.6500;
	points[6] = (8415.3545, -5610.2363, 1365.9410);
	angles[6] = (0, -180, 0);
	at[6] = 0.7000;
	points[7] = (8415.3545, -5610.2363, 1362.6968);
	angles[7] = (0, -180, 0);
	at[7] = 0.7500;
	points[8] = (8415.3545, -5610.2363, 1350.5945);
	angles[8] = (0, -180, 0);
	at[8] = 0.8000;
	points[9] = (8415.3545, -5610.2363, 1353.8386);
	angles[9] = (0, -180, 0);
	at[9] = 0.8500;
	points[10] = (8415.3545, -5610.2363, 1365.9410);
	angles[10] = (0, -180, 0);
	at[10] = 0.9000;
	points[11] = (8415.3545, -5610.2363, 1362.6968);
	angles[11] = (0, -180, 0);
	at[11] = 0.9500;
	points[12] = (8415.3545, -5610.2363, 1368.6024);
	angles[12] = (0, -180, 0);
	at[12] = 1;
	points[13] = (8415.3545, -5610.2363, 1501.4764);
	angles[13] = (0, -180, 0);
	at[13] = 1.1500;
	points[14] = (8415.3545, -5610.2363, 1471.3584);
	angles[14] = (0, -180, 0);
	at[14] = 1.2000;
	points[15] = (8415.3545, -5610.2363, 1396.0630);
	angles[15] = (0, -180, 0);
	at[15] = 1.2500;
	points[16] = (8415.3545, -5610.2363, 1275.5906);
	angles[16] = (0, -180, 0);
	at[16] = 1.3000;
	points[17] = (8415.3545, -5610.2363, 1109.9409);
	angles[17] = (0, -180, 0);
	at[17] = 1.3500;
	points[18] = (8415.3545, -5610.2363, 1062.9922);
	angles[18] = (0, -180, 0);
	at[18] = 1.4000;
	points[19] = (8415.3545, -5610.2363, 1062.9922);
	angles[19] = (0, -180, 0);
	at[19] = 2.3500;
	points[20] = (8415.3545, -5610.2363, 1068.8976);
	angles[20] = (0, -180, 0);
	at[20] = 2.4000;
	points[21] = (8415.3545, -5610.2363, 1352.3622);
	angles[21] = (0, -180, 0);
	at[21] = 4;
	points[22] = (8415.3545, -5610.2363, 1358.2677);
	angles[22] = (0, -180, 0);
	at[22] = 4.0500;
	points[23] = (8415.3545, -5610.2363, 1358.2677);
	angles[23] = (0, -180, 0);
	at[23] = 4.5500;
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
	points[0] = (7973.0713, -6490.7485, 1365.9410);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (7973.0713, -6490.7485, 1362.6968);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (7973.0713, -6490.7485, 1350.5945);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (7973.0713, -6490.7485, 1353.8386);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (7973.0713, -6490.7485, 1365.9410);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (7973.0713, -6490.7485, 1362.6968);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (7973.0713, -6490.7485, 1350.5945);
	angles[6] = (0, 90, 0);
	at[6] = 0.3000;
	points[7] = (7973.0713, -6490.7485, 1353.8386);
	angles[7] = (0, 90, 0);
	at[7] = 0.3500;
	points[8] = (7973.0713, -6490.7485, 1365.9410);
	angles[8] = (0, 90, 0);
	at[8] = 0.4000;
	points[9] = (7973.0713, -6490.7485, 1362.6968);
	angles[9] = (0, 90, 0);
	at[9] = 0.4500;
	points[10] = (7973.0713, -6490.7485, 1368.6024);
	angles[10] = (0, 90, 0);
	at[10] = 0.5000;
	points[11] = (7973.0713, -6490.7485, 1501.4764);
	angles[11] = (0, 90, 0);
	at[11] = 0.6500;
	points[12] = (7973.0713, -6490.7485, 1471.3584);
	angles[12] = (0, 90, 0);
	at[12] = 0.7000;
	points[13] = (7973.0713, -6490.7485, 1396.0630);
	angles[13] = (0, 90, 0);
	at[13] = 0.7500;
	points[14] = (7973.0713, -6490.7485, 1275.5906);
	angles[14] = (0, 90, 0);
	at[14] = 0.8000;
	points[15] = (7973.0713, -6490.7485, 1109.9409);
	angles[15] = (0, 90, 0);
	at[15] = 0.8500;
	points[16] = (7973.0713, -6490.7485, 1062.9922);
	angles[16] = (0, 90, 0);
	at[16] = 0.9000;
	points[17] = (7973.0713, -6490.7485, 1062.9922);
	angles[17] = (0, 90, 0);
	at[17] = 1.8500;
	points[18] = (7973.0713, -6490.7485, 1068.8976);
	angles[18] = (0, 90, 0);
	at[18] = 1.9000;
	points[19] = (7973.0713, -6490.7485, 1352.3622);
	angles[19] = (0, 90, 0);
	at[19] = 3.5000;
	points[20] = (7973.0713, -6490.7485, 1358.2677);
	angles[20] = (0, 90, 0);
	at[20] = 3.5500;
	points[21] = (7973.0713, -6490.7485, 1358.2677);
	angles[21] = (0, 90, 0);
	at[21] = 4.5000;
	points[22] = (7973.0713, -6490.7485, 1365.9410);
	angles[22] = (0, 90, 0);
	at[22] = 4.5500;
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
	points[0] = (10079.8818, 10025.9062, 1358.2677);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (10079.8818, 10025.9062, 1358.2677);
	angles[1] = (0, -180, 0);
	at[1] = 0.9500;
	points[2] = (10079.8818, 10025.9062, 1365.9410);
	angles[2] = (0, -180, 0);
	at[2] = 1;
	points[3] = (10079.8818, 10025.9062, 1362.6968);
	angles[3] = (0, -180, 0);
	at[3] = 1.0500;
	points[4] = (10079.8818, 10025.9062, 1350.5945);
	angles[4] = (0, -180, 0);
	at[4] = 1.1000;
	points[5] = (10079.8818, 10025.9062, 1353.8386);
	angles[5] = (0, -180, 0);
	at[5] = 1.1500;
	points[6] = (10079.8818, 10025.9062, 1365.9410);
	angles[6] = (0, -180, 0);
	at[6] = 1.2000;
	points[7] = (10079.8818, 10025.9062, 1362.6968);
	angles[7] = (0, -180, 0);
	at[7] = 1.2500;
	points[8] = (10079.8818, 10025.9062, 1350.5945);
	angles[8] = (0, -180, 0);
	at[8] = 1.3000;
	points[9] = (10079.8818, 10025.9062, 1353.8386);
	angles[9] = (0, -180, 0);
	at[9] = 1.3500;
	points[10] = (10079.8818, 10025.9062, 1365.9410);
	angles[10] = (0, -180, 0);
	at[10] = 1.4000;
	points[11] = (10079.8818, 10025.9062, 1362.6968);
	angles[11] = (0, -180, 0);
	at[11] = 1.4500;
	points[12] = (10079.8818, 10025.9062, 1368.6024);
	angles[12] = (0, -180, 0);
	at[12] = 1.5000;
	points[13] = (10079.8818, 10025.9062, 1501.4764);
	angles[13] = (0, -180, 0);
	at[13] = 1.6500;
	points[14] = (10079.8818, 10025.9062, 1471.3584);
	angles[14] = (0, -180, 0);
	at[14] = 1.7000;
	points[15] = (10079.8818, 10025.9062, 1396.0630);
	angles[15] = (0, -180, 0);
	at[15] = 1.7500;
	points[16] = (10079.8818, 10025.9062, 1275.5906);
	angles[16] = (0, -180, 0);
	at[16] = 1.8000;
	points[17] = (10079.8818, 10025.9062, 1109.9409);
	angles[17] = (0, -180, 0);
	at[17] = 1.8500;
	points[18] = (10079.8818, 10025.9062, 1062.9922);
	angles[18] = (0, -180, 0);
	at[18] = 1.9000;
	points[19] = (10079.8818, 10025.9062, 1062.9922);
	angles[19] = (0, -180, 0);
	at[19] = 2.8500;
	points[20] = (10079.8818, 10025.9062, 1068.8976);
	angles[20] = (0, -180, 0);
	at[20] = 2.9000;
	points[21] = (10079.8818, 10025.9062, 1352.3622);
	angles[21] = (0, -180, 0);
	at[21] = 4.5000;
	points[22] = (10079.8818, 10025.9062, 1358.2677);
	angles[22] = (0, -180, 0);
	at[22] = 4.5500;
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
	points[0] = (7421.2998, 9733.6611, 1365.9410);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (7421.2998, 9733.6611, 1362.6968);
	angles[1] = (0, -90, 0);
	at[1] = 0.0500;
	points[2] = (7421.2998, 9733.6611, 1350.5945);
	angles[2] = (0, -90, 0);
	at[2] = 0.1000;
	points[3] = (7421.2998, 9733.6611, 1353.8386);
	angles[3] = (0, -90, 0);
	at[3] = 0.1500;
	points[4] = (7421.2998, 9733.6611, 1365.9410);
	angles[4] = (0, -90, 0);
	at[4] = 0.2000;
	points[5] = (7421.2998, 9733.6611, 1362.6968);
	angles[5] = (0, -90, 0);
	at[5] = 0.2500;
	points[6] = (7421.2998, 9733.6611, 1350.5945);
	angles[6] = (0, -90, 0);
	at[6] = 0.3000;
	points[7] = (7421.2998, 9733.6611, 1353.8386);
	angles[7] = (0, -90, 0);
	at[7] = 0.3500;
	points[8] = (7421.2998, 9733.6611, 1365.9410);
	angles[8] = (0, -90, 0);
	at[8] = 0.4000;
	points[9] = (7421.2998, 9733.6611, 1362.6968);
	angles[9] = (0, -90, 0);
	at[9] = 0.4500;
	points[10] = (7421.2998, 9733.6611, 1368.6024);
	angles[10] = (0, -90, 0);
	at[10] = 0.5000;
	points[11] = (7421.2998, 9733.6611, 1501.4764);
	angles[11] = (0, -90, 0);
	at[11] = 0.6500;
	points[12] = (7421.2998, 9733.6611, 1471.3584);
	angles[12] = (0, -90, 0);
	at[12] = 0.7000;
	points[13] = (7421.2998, 9733.6611, 1396.0630);
	angles[13] = (0, -90, 0);
	at[13] = 0.7500;
	points[14] = (7421.2998, 9733.6611, 1275.5906);
	angles[14] = (0, -90, 0);
	at[14] = 0.8000;
	points[15] = (7421.2998, 9733.6611, 1109.9409);
	angles[15] = (0, -90, 0);
	at[15] = 0.8500;
	points[16] = (7421.2998, 9733.6611, 1062.9922);
	angles[16] = (0, -90, 0);
	at[16] = 0.9000;
	points[17] = (7421.2998, 9733.6611, 1062.9922);
	angles[17] = (0, -90, 0);
	at[17] = 1.8500;
	points[18] = (7421.2998, 9733.6611, 1068.8976);
	angles[18] = (0, -90, 0);
	at[18] = 1.9000;
	points[19] = (7421.2998, 9733.6611, 1352.3622);
	angles[19] = (0, -90, 0);
	at[19] = 3.5000;
	points[20] = (7421.2998, 9733.6611, 1358.2677);
	angles[20] = (0, -90, 0);
	at[20] = 3.5500;
	points[21] = (7421.2998, 9733.6611, 1358.2677);
	angles[21] = (0, -90, 0);
	at[21] = 4.5000;
	points[22] = (7421.2998, 9733.6611, 1365.9410);
	angles[22] = (0, -90, 0);
	at[22] = 4.5500;
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
	points[0] = (7234.2520, 6496.0630, 1358.2677);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7234.2520, 6496.0630, 1358.2677);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (7234.2520, 6496.0630, 1365.9410);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (7234.2520, 6496.0630, 1362.6968);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (7234.2520, 6496.0630, 1350.5945);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (7234.2520, 6496.0630, 1353.8386);
	angles[5] = (0, 0, 0);
	at[5] = 0.6500;
	points[6] = (7234.2520, 6496.0630, 1365.9410);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (7234.2520, 6496.0630, 1362.6968);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (7234.2520, 6496.0630, 1350.5945);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (7234.2520, 6496.0630, 1353.8386);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (7234.2520, 6496.0630, 1365.9410);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (7234.2520, 6496.0630, 1362.6968);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (7234.2520, 6496.0630, 1368.6024);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (7234.2520, 6496.0630, 1501.4764);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (7234.2520, 6496.0630, 1471.3584);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (7234.2520, 6496.0630, 1396.0630);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (7234.2520, 6496.0630, 1275.5906);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (7234.2520, 6496.0630, 1109.9409);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (7234.2520, 6496.0630, 1062.9922);
	angles[18] = (0, 0, 0);
	at[18] = 1.4000;
	points[19] = (7234.2520, 6496.0630, 1062.9922);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (7234.2520, 6496.0630, 1068.8976);
	angles[20] = (0, 0, 0);
	at[20] = 2.4000;
	points[21] = (7234.2520, 6496.0630, 1352.3622);
	angles[21] = (0, 0, 0);
	at[21] = 4;
	points[22] = (7234.2520, 6496.0630, 1358.2677);
	angles[22] = (0, 0, 0);
	at[22] = 4.0500;
	points[23] = (7234.2520, 6496.0630, 1358.2677);
	angles[23] = (0, 0, 0);
	at[23] = 4.5500;
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
	points[0] = (7677.1655, 6496.0630, 1358.2677);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7677.1655, 6496.0630, 1358.2677);
	angles[1] = (0, 0, 0);
	at[1] = 0.9500;
	points[2] = (7677.1655, 6496.0630, 1365.9410);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (7677.1655, 6496.0630, 1362.6968);
	angles[3] = (0, 0, 0);
	at[3] = 1.0500;
	points[4] = (7677.1655, 6496.0630, 1350.5945);
	angles[4] = (0, 0, 0);
	at[4] = 1.1000;
	points[5] = (7677.1655, 6496.0630, 1353.8386);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (7677.1655, 6496.0630, 1365.9410);
	angles[6] = (0, 0, 0);
	at[6] = 1.2000;
	points[7] = (7677.1655, 6496.0630, 1362.6968);
	angles[7] = (0, 0, 0);
	at[7] = 1.2500;
	points[8] = (7677.1655, 6496.0630, 1350.5945);
	angles[8] = (0, 0, 0);
	at[8] = 1.3000;
	points[9] = (7677.1655, 6496.0630, 1353.8386);
	angles[9] = (0, 0, 0);
	at[9] = 1.3500;
	points[10] = (7677.1655, 6496.0630, 1365.9410);
	angles[10] = (0, 0, 0);
	at[10] = 1.4000;
	points[11] = (7677.1655, 6496.0630, 1362.6968);
	angles[11] = (0, 0, 0);
	at[11] = 1.4500;
	points[12] = (7677.1655, 6496.0630, 1368.6024);
	angles[12] = (0, 0, 0);
	at[12] = 1.5000;
	points[13] = (7677.1655, 6496.0630, 1501.4764);
	angles[13] = (0, 0, 0);
	at[13] = 1.6500;
	points[14] = (7677.1655, 6496.0630, 1471.3584);
	angles[14] = (0, 0, 0);
	at[14] = 1.7000;
	points[15] = (7677.1655, 6496.0630, 1396.0630);
	angles[15] = (0, 0, 0);
	at[15] = 1.7500;
	points[16] = (7677.1655, 6496.0630, 1275.5906);
	angles[16] = (0, 0, 0);
	at[16] = 1.8000;
	points[17] = (7677.1655, 6496.0630, 1109.9409);
	angles[17] = (0, 0, 0);
	at[17] = 1.8500;
	points[18] = (7677.1655, 6496.0630, 1062.9922);
	angles[18] = (0, 0, 0);
	at[18] = 1.9000;
	points[19] = (7677.1655, 6496.0630, 1062.9922);
	angles[19] = (0, 0, 0);
	at[19] = 2.8500;
	points[20] = (7677.1655, 6496.0630, 1068.8976);
	angles[20] = (0, 0, 0);
	at[20] = 2.9000;
	points[21] = (7677.1655, 6496.0630, 1352.3622);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (7677.1655, 6496.0630, 1358.2677);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
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
	points[0] = (-7381.8896, 4650.5908, 1358.2677);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7381.8896, 4650.5908, 1358.2677);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-7381.8896, 4650.5908, 1365.9410);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-7381.8896, 4650.5908, 1362.6968);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (-7381.8896, 4650.5908, 1350.5945);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (-7381.8896, 4650.5908, 1353.8386);
	angles[5] = (0, 0, 0);
	at[5] = 0.6500;
	points[6] = (-7381.8896, 4650.5908, 1365.9410);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (-7381.8896, 4650.5908, 1362.6968);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (-7381.8896, 4650.5908, 1350.5945);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (-7381.8896, 4650.5908, 1353.8386);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (-7381.8896, 4650.5908, 1365.9410);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (-7381.8896, 4650.5908, 1362.6968);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (-7381.8896, 4650.5908, 1368.6024);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (-7381.8896, 4650.5908, 1501.4764);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (-7381.8896, 4650.5908, 1471.3584);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (-7381.8896, 4650.5908, 1396.0630);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (-7381.8896, 4650.5908, 1275.5906);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (-7381.8896, 4650.5908, 1109.9409);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (-7381.8896, 4650.5908, 1062.9922);
	angles[18] = (0, 0, 0);
	at[18] = 1.4000;
	points[19] = (-7381.8896, 4650.5908, 1062.9922);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (-7381.8896, 4650.5908, 1068.8976);
	angles[20] = (0, 0, 0);
	at[20] = 2.4000;
	points[21] = (-7381.8896, 4650.5908, 1352.3622);
	angles[21] = (0, 0, 0);
	at[21] = 4;
	points[22] = (-7381.8896, 4650.5908, 1358.2677);
	angles[22] = (0, 0, 0);
	at[22] = 4.0500;
	points[23] = (-7381.8896, 4650.5908, 1358.2677);
	angles[23] = (0, 0, 0);
	at[23] = 4.5500;
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
	points[0] = (-7687.9922, -1826.1063, 1353.8386);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7687.9922, -1826.1063, 1365.9410);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-7687.9922, -1826.1063, 1362.6968);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-7687.9922, -1826.1063, 1350.5945);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-7687.9922, -1826.1063, 1353.8386);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-7687.9922, -1826.1063, 1365.9410);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-7687.9922, -1826.1063, 1362.6968);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-7687.9922, -1826.1063, 1368.6024);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-7687.9922, -1826.1063, 1501.4764);
	angles[8] = (0, 0, 0);
	at[8] = 0.5000;
	points[9] = (-7687.9922, -1826.1063, 1471.3584);
	angles[9] = (0, 0, 0);
	at[9] = 0.5500;
	points[10] = (-7687.9922, -1826.1063, 1396.0630);
	angles[10] = (0, 0, 0);
	at[10] = 0.6000;
	points[11] = (-7687.9922, -1826.1063, 1275.5906);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (-7687.9922, -1826.1063, 1109.9409);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (-7687.9922, -1826.1063, 1062.9922);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (-7687.9922, -1826.1063, 1062.9922);
	angles[14] = (0, 0, 0);
	at[14] = 1.7000;
	points[15] = (-7687.9922, -1826.1063, 1068.8976);
	angles[15] = (0, 0, 0);
	at[15] = 1.7500;
	points[16] = (-7687.9922, -1826.1063, 1352.3622);
	angles[16] = (0, 0, 0);
	at[16] = 3.3500;
	points[17] = (-7687.9922, -1826.1063, 1358.2677);
	angles[17] = (0, 0, 0);
	at[17] = 3.4000;
	points[18] = (-7687.9922, -1826.1063, 1358.2677);
	angles[18] = (0, 0, 0);
	at[18] = 4.3500;
	points[19] = (-7687.9922, -1826.1063, 1365.9410);
	angles[19] = (0, 0, 0);
	at[19] = 4.4000;
	points[20] = (-7687.9922, -1826.1063, 1362.6968);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-7687.9922, -1826.1063, 1350.5945);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-7687.9922, -1826.1063, 1353.8386);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
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
	points[0] = (2334.3308, 3530.6223, 744.1812);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2334.3308, 3530.6223, 682.1732);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (2334.3308, 3529.8506, 677.8268);
	angles[2] = (0, -180, -84.0139);
	at[2] = 0.7500;
	points[3] = (2334.3308, 3527.9646, 669.1693);
	angles[3] = (0, -180, -79.3628);
	at[3] = 0.8500;
	points[4] = (2334.3308, 3527, 670.7874);
	angles[4] = (0, -180, -51.6111);
	at[4] = 0.9000;
	points[5] = (2334.3308, 3526.0273, 675.1103);
	angles[5] = (0, -180, -9.9915);
	at[5] = 0.9500;
	points[6] = (2334.3308, 3525.0552, 679.4291);
	angles[6] = (0, -180, 27.4960);
	at[6] = 1;
	points[7] = (2334.3308, 3524.7166, 683.8229);
	angles[7] = (0, -180, 54.9604);
	at[7] = 1.0500;
	points[8] = (2334.3308, 3524.7166, 688.2520);
	angles[8] = (0, -180, 71.7769);
	at[8] = 1.1000;
	points[9] = (2334.3308, 3524.7166, 692.6812);
	angles[9] = (0, -180, 80.6309);
	at[9] = 1.1500;
	points[10] = (2334.3308, 3524.7166, 701.9173);
	angles[10] = (0, -180, 87.5404);
	at[10] = 1.2500;
	points[11] = (2334.3308, 3524.7166, 721.4449);
	angles[11] = (0, -180, 89.6699);
	at[11] = 1.4000;
	points[12] = (2334.3308, 3524.7166, 740.1969);
	angles[12] = (0, -180, 89.9135);
	at[12] = 1.5000;
	points[13] = (2334.3308, 3524.7166, 765.3937);
	angles[13] = (0, -180, 89.9774);
	at[13] = 1.6000;
	points[14] = (2334.3308, 3524.7166, 799.2520);
	angles[14] = (0, -180, 89.9940);
	at[14] = 1.7000;
	points[15] = (2334.3308, 3524.7166, 820.3229);
	angles[15] = (0, -180, 0);
	at[15] = 1.7500;
	points[16] = (2334.3308, 3524.7166, 873.0669);
	angles[16] = (0, -180, 0);
	at[16] = 1.8500;
	points[17] = (2334.3308, 3524.7166, 905.8898);
	angles[17] = (0, -360, 0);
	at[17] = 1.9000;
	points[18] = (2334.3308, 3524.7166, 1021.5118);
	angles[18] = (0, -360, 0);
	at[18] = 2.0500;
	points[19] = (2334.3308, 3524.7166, 1131.4213);
	angles[19] = (0, -360, 0);
	at[19] = 2.2000;
	points[20] = (2334.3308, 3524.7166, 1194.5393);
	angles[20] = (0, -360, 0);
	at[20] = 2.3000;
	points[21] = (2334.3308, 3524.7166, 1220.6458);
	angles[21] = (0, -360, 0);
	at[21] = 2.3500;
	points[22] = (2334.3308, 3524.7166, 1240.1969);
	angles[22] = (0, -360, 0);
	at[22] = 2.4000;
	points[23] = (2334.3308, 3524.7166, 1253.9922);
	angles[23] = (0, -360, 0);
	at[23] = 2.4500;
	points[24] = (2334.3308, 3525.3228, 1263.5551);
	angles[24] = (0, -360, 86.9301);
	at[24] = 2.5000;
	points[25] = (2334.3308, 3527.1733, 1275.8818);
	angles[25] = (0, -360, 82.8957);
	at[25] = 2.6000;
	points[26] = (2334.3308, 3527.7756, 1279.8937);
	angles[26] = (0, -360, 77.2001);
	at[26] = 2.6500;
	points[27] = (2334.3308, 3528.3623, 1274.4843);
	angles[27] = (0, -360, 51.4267);
	at[27] = 2.7000;
	points[28] = (2334.3308, 3530.0984, 1262.6771);
	angles[28] = (0, -360, -28.1618);
	at[28] = 2.8000;
	points[29] = (2334.3308, 3530.6223, 1254.0433);
	angles[29] = (0, -360, -55.8284);
	at[29] = 2.8500;
	points[30] = (2334.3308, 3530.6223, 1242.3425);
	angles[30] = (0, -360, -72.2422);
	at[30] = 2.9000;
	points[31] = (2334.3308, 3530.6223, 1226.3976);
	angles[31] = (0, -360, -80.8720);
	at[31] = 2.9500;
	points[32] = (2334.3308, 3530.6223, 1204.9133);
	angles[32] = (0, -360, -85.3217);
	at[32] = 3;
	points[33] = (2334.3308, 3530.6223, 1177.2401);
	angles[33] = (0, -360, -87.6039);
	at[33] = 3.0500;
	points[34] = (2334.3308, 3530.6223, 1144.5906);
	angles[34] = (0, -360, -88.7732);
	at[34] = 3.1000;
	points[35] = (2334.3308, 3530.6223, 1071.3700);
	angles[35] = (0, -360, -89.6783);
	at[35] = 3.2000;
	points[36] = (2334.3308, 3530.6223, 1041.4448);
	angles[36] = (0, -360, -89.8353);
	at[36] = 3.2500;
	points[37] = (2334.3308, 3530.6223, 994.4410);
	angles[37] = (0, -360, -89.9568);
	at[37] = 3.3500;
	points[38] = (2334.3308, 3530.6223, 976.1063);
	angles[38] = (0, -360, -89.9778);
	at[38] = 3.4000;
	points[39] = (2334.3308, 3530.6223, 947.3032);
	angles[39] = (0, -360, -89.9942);
	at[39] = 3.5000;
	points[40] = (2334.3308, 3530.6223, 936.0670);
	angles[40] = (0, -360, 0);
	at[40] = 3.5500;
	points[41] = (2334.3308, 3530.6223, 926.5276);
	angles[41] = (0, -360, 0);
	at[41] = 3.6000;
	points[42] = (2334.3308, 3530.6223, 911.5355);
	angles[42] = (0, -360, 0);
	at[42] = 3.7000;
	points[43] = (2334.3308, 3530.6223, 900.7205);
	angles[43] = (0, -360, 0);
	at[43] = 3.8000;
	points[44] = (2334.3308, 3530.6223, 744.1812);
	angles[44] = (0, -360, 0);
	at[44] = 5.5667;
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
	points[0] = (846.1693, 3973.3464, 682.1496);
	angles[0] = (0, 180, 39.1853);
	at[0] = 0;
	points[1] = (846.1693, 3973.6221, 686.6102);
	angles[1] = (0, 180, 63.0925);
	at[1] = 0.0500;
	points[2] = (846.1693, 3973.6221, 691.0394);
	angles[2] = (0, 180, 76.0968);
	at[2] = 0.1000;
	points[3] = (846.1693, 3973.6221, 695.4685);
	angles[3] = (0, 180, 82.8643);
	at[3] = 0.1500;
	points[4] = (846.1693, 3973.6221, 711.4489);
	angles[4] = (0, 180, 89.0414);
	at[4] = 0.3000;
	points[5] = (846.1693, 3973.6221, 736.2953);
	angles[5] = (0, 180, 89.8713);
	at[5] = 0.4500;
	points[6] = (846.1693, 3973.6221, 760.1496);
	angles[6] = (0, 180, 89.9663);
	at[6] = 0.5500;
	points[7] = (846.1693, 3973.6221, 792.2047);
	angles[7] = (0, 180, 89.9911);
	at[7] = 0.6500;
	points[8] = (846.1693, 3973.6221, 812.1536);
	angles[8] = (0, 180, 0);
	at[8] = 0.7000;
	points[9] = (846.1693, 3973.6221, 862.0906);
	angles[9] = (0, 180, 0);
	at[9] = 0.8000;
	points[10] = (846.1693, 3973.6221, 893.1653);
	angles[10] = (0, 180, 0);
	at[10] = 0.8500;
	points[11] = (846.1693, 3973.6221, 929.1890);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (846.1693, 3973.6221, 1007.3976);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (846.1693, 3973.6221, 1118.2520);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (846.1693, 3973.6221, 1152.8229);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (846.1693, 3973.6221, 1211.6497);
	angles[15] = (0, 0, 0);
	at[15] = 1.3000;
	points[16] = (846.1693, 3973.6221, 1233.6458);
	angles[16] = (0, 0, 0);
	at[16] = 1.3500;
	points[17] = (846.1693, 3973.6221, 1249.4449);
	angles[17] = (0, 0, 0);
	at[17] = 1.4000;
	points[18] = (846.1693, 3973.6221, 1260.4094);
	angles[18] = (0, 0, 88.2953);
	at[18] = 1.4500;
	points[19] = (846.1693, 3976.4961, 1278.5315);
	angles[19] = (0, 0, 82.3794);
	at[19] = 1.6000;
	points[20] = (846.1693, 3977.0471, 1276.0945);
	angles[20] = (0, 0, 61.9516);
	at[20] = 1.6500;
	points[21] = (846.1693, 3977.7166, 1271.3898);
	angles[21] = (0, 0, 25.1576);
	at[21] = 1.7000;
	points[22] = (846.1693, 3978.6221, 1265.3385);
	angles[22] = (0, 0, -16.5730);
	at[22] = 1.7500;
	points[23] = (846.1693, 3979.7637, 1257.5630);
	angles[23] = (0, 0, -47.7564);
	at[23] = 1.8000;
	points[24] = (846.1693, 3979.5276, 1247.1182);
	angles[24] = (0, 0, -67.8693);
	at[24] = 1.8500;
	points[25] = (846.1693, 3979.5276, 1232.9055);
	angles[25] = (0, 0, -78.5990);
	at[25] = 1.9000;
	points[26] = (846.1693, 3979.5276, 1213.6378);
	angles[26] = (0, 0, -84.1531);
	at[26] = 1.9500;
	points[27] = (846.1693, 3979.5276, 1188.0906);
	angles[27] = (0, 0, -87.0051);
	at[27] = 2;
	points[28] = (846.1693, 3979.5276, 1157.3542);
	angles[28] = (0, 0, -88.4665);
	at[28] = 2.0500;
	points[29] = (846.1693, 3979.5276, 1083.7677);
	angles[29] = (0, 0, -89.5980);
	at[29] = 2.1500;
	points[30] = (846.1693, 3979.5276, 1051.9763);
	angles[30] = (0, 0, -89.7943);
	at[30] = 2.2000;
	points[31] = (846.1693, 3979.5276, 1024.9724);
	angles[31] = (0, 0, -89.8946);
	at[31] = 2.2500;
	points[32] = (846.1693, 3979.5276, 982.5591);
	angles[32] = (0, 0, -89.9723);
	at[32] = 2.3500;
	points[33] = (846.1693, 3979.5276, 951.9606);
	angles[33] = (0, 0, -89.9927);
	at[33] = 2.4500;
	points[34] = (846.1693, 3979.5276, 940.0236);
	angles[34] = (0, 0, 0);
	at[34] = 2.5000;
	points[35] = (846.1693, 3979.5276, 921.2716);
	angles[35] = (0, 0, 0);
	at[35] = 2.6000;
	points[36] = (846.1693, 3979.5276, 897.9252);
	angles[36] = (0, 0, 0);
	at[36] = 2.8000;
	points[37] = (846.1693, 3979.5276, 685.3268);
	angles[37] = (0, 0, 0);
	at[37] = 5.2000;
	points[38] = (846.1693, 3979.5276, 680.8976);
	angles[38] = (0, -180, -87.5509);
	at[38] = 5.2500;
	points[39] = (846.1693, 3976.6140, 667.9252);
	angles[39] = (0, -180, -79.0321);
	at[39] = 5.4000;
	points[40] = (846.1693, 3975.6301, 672.0669);
	angles[40] = (0, -180, -50.9884);
	at[40] = 5.4500;
	points[41] = (846.1693, 3974.6458, 676.3898);
	angles[41] = (0, -180, -9.2637);
	at[41] = 5.5000;
	points[42] = (846.1693, 3973.3464, 682.1496);
	angles[42] = (0, -180, 39.1853);
	at[42] = 5.5667;
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
	points[0] = (-543.1339, 3524.7166, 782.6929);
	angles[0] = (0, 180, 89.9889);
	at[0] = 0;
	points[1] = (-543.1339, 3524.7166, 801.1260);
	angles[1] = (0, 180, 0);
	at[1] = 0.0500;
	points[2] = (-543.1339, 3524.7166, 847.2717);
	angles[2] = (0, 180, 0);
	at[2] = 0.1500;
	points[3] = (-543.1339, 3524.7166, 875.9882);
	angles[3] = (0, 180, 0);
	at[3] = 0.2000;
	points[4] = (-543.1339, 3524.7166, 909.2756);
	angles[4] = (0, 0, 0);
	at[4] = 0.2500;
	points[5] = (-543.1339, 3524.7166, 1025.7323);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (-543.1339, 3524.7166, 1135.3622);
	angles[6] = (0, 0, 0);
	at[6] = 0.5500;
	points[7] = (-543.1339, 3524.7166, 1197.6890);
	angles[7] = (0, 0, 0);
	at[7] = 0.6500;
	points[8] = (-543.1339, 3524.7166, 1223.1339);
	angles[8] = (0, 0, 0);
	at[8] = 0.7000;
	points[9] = (-543.1339, 3524.7166, 1241.9803);
	angles[9] = (0, 0, 0);
	at[9] = 0.7500;
	points[10] = (-543.1339, 3524.7166, 1255.2283);
	angles[10] = (0, 0, 0);
	at[10] = 0.8000;
	points[11] = (-543.1339, 3525.4529, 1264.4292);
	angles[11] = (0, 0, 86.9301);
	at[11] = 0.8500;
	points[12] = (-543.1339, 3527.2480, 1276.3820);
	angles[12] = (0, 0, 82.8957);
	at[12] = 0.9500;
	points[13] = (-543.1339, 3527.8308, 1280.2677);
	angles[13] = (0, 0, 77.2001);
	at[13] = 1;
	points[14] = (-543.1339, 3528.4331, 1273.9961);
	angles[14] = (0, 0, 51.4267);
	at[14] = 1.0500;
	points[15] = (-543.1339, 3530.2168, 1261.8741);
	angles[15] = (0, 0, -28.1618);
	at[15] = 1.1500;
	points[16] = (-543.1339, 3530.6223, 1252.9803);
	angles[16] = (0, 0, -55.8284);
	at[16] = 1.2000;
	points[17] = (-543.1339, 3530.6223, 1240.8977);
	angles[17] = (0, 0, -72.2422);
	at[17] = 1.2500;
	points[18] = (-543.1339, 3530.6223, 1224.4331);
	angles[18] = (0, 0, -80.8720);
	at[18] = 1.3000;
	points[19] = (-543.1339, 3530.6223, 1202.2795);
	angles[19] = (0, 0, -85.3217);
	at[19] = 1.3500;
	points[20] = (-543.1339, 3530.6223, 1174.0511);
	angles[20] = (0, 0, -87.6039);
	at[20] = 1.4000;
	points[21] = (-543.1339, 3530.6223, 1140.8386);
	angles[21] = (0, 0, -88.7732);
	at[21] = 1.4500;
	points[22] = (-543.1339, 3530.6223, 1068.0039);
	angles[22] = (0, 0, -89.6783);
	at[22] = 1.5500;
	points[23] = (-543.1339, 3530.6223, 1038.5867);
	angles[23] = (0, 0, -89.8353);
	at[23] = 1.6000;
	points[24] = (-543.1339, 3530.6223, 992.3780);
	angles[24] = (0, 0, -89.9568);
	at[24] = 1.7000;
	points[25] = (-543.1339, 3530.6223, 974.3544);
	angles[25] = (0, 0, -89.9778);
	at[25] = 1.7500;
	points[26] = (-543.1339, 3530.6223, 946.0394);
	angles[26] = (0, 0, -89.9942);
	at[26] = 1.8500;
	points[27] = (-543.1339, 3530.6223, 934.9960);
	angles[27] = (0, 0, 0);
	at[27] = 1.9000;
	points[28] = (-543.1339, 3530.6223, 917.6457);
	angles[28] = (0, 0, 0);
	at[28] = 2;
	points[29] = (-543.1339, 3530.6223, 905.1299);
	angles[29] = (0, 0, 0);
	at[29] = 2.1000;
	points[30] = (-543.1339, 3530.6223, 683.2205);
	angles[30] = (0, 0, 0);
	at[30] = 4.6000;
	points[31] = (-543.1339, 3530.0750, 678.8504);
	angles[31] = (0, -180, -85.5872);
	at[31] = 4.6500;
	points[32] = (-543.1339, 3528.1890, 670.1969);
	angles[32] = (0, -180, -79.7762);
	at[32] = 4.7500;
	points[33] = (-543.1339, 3527.2322, 669.7637);
	angles[33] = (0, -180, -62.8249);
	at[33] = 4.8000;
	points[34] = (-543.1339, 3525.2874, 678.4055);
	angles[34] = (0, -180, 16.4836);
	at[34] = 4.9000;
	points[35] = (-543.1339, 3524.7166, 682.7717);
	angles[35] = (0, -180, 48.3116);
	at[35] = 4.9500;
	points[36] = (-543.1339, 3524.7166, 687.2008);
	angles[36] = (0, -180, 68.1736);
	at[36] = 5;
	points[37] = (-543.1339, 3524.7166, 691.6299);
	angles[37] = (0, -180, 78.7577);
	at[37] = 5.0500;
	points[38] = (-543.1339, 3524.7166, 700.7087);
	angles[38] = (0, -180, 87.0470);
	at[38] = 5.1500;
	points[39] = (-543.1339, 3524.7166, 712.3268);
	angles[39] = (0, -180, 89.2257);
	at[39] = 5.2500;
	points[40] = (-543.1339, 3524.7166, 727.9449);
	angles[40] = (0, -180, 89.7970);
	at[40] = 5.3500;
	points[41] = (-543.1339, 3524.7166, 748.9291);
	angles[41] = (0, -180, 89.9467);
	at[41] = 5.4500;
	points[42] = (-543.1339, 3524.7166, 782.6929);
	angles[42] = (0, -180, 89.9889);
	at[42] = 5.5667;
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
	points[0] = (8857.2842, -1464.6890, 1305.2284);
	angles[0] = (0, 90, -28.1619);
	at[0] = 0;
	points[1] = (8856.7725, -1464.6890, 1296.5315);
	angles[1] = (0, 90, -55.8285);
	at[1] = 0.0500;
	points[2] = (8856.7725, -1464.6890, 1284.7322);
	angles[2] = (0, 90, -72.2422);
	at[2] = 0.1000;
	points[3] = (8856.7725, -1464.6890, 1268.6536);
	angles[3] = (0, 90, -80.8719);
	at[3] = 0.1500;
	points[4] = (8856.7725, -1464.6890, 1246.9961);
	angles[4] = (0, 90, -85.3217);
	at[4] = 0.2000;
	points[5] = (8856.7725, -1464.6890, 1219.1693);
	angles[5] = (0, 90, -87.6040);
	at[5] = 0.2500;
	points[6] = (8856.7725, -1464.6890, 1186.3701);
	angles[6] = (0, 90, -88.7731);
	at[6] = 0.3000;
	points[7] = (8856.7725, -1464.6890, 1112.4685);
	angles[7] = (0, 90, -89.6785);
	at[7] = 0.4000;
	points[8] = (8856.7725, -1464.6890, 1081.2205);
	angles[8] = (0, 90, -89.8353);
	at[8] = 0.4500;
	points[9] = (8856.7725, -1464.6890, 1053.9567);
	angles[9] = (0, 90, -89.9157);
	at[9] = 0.5000;
	points[10] = (8856.7725, -1464.6890, 1009.4095);
	angles[10] = (0, 90, -89.9780);
	at[10] = 0.6000;
	points[11] = (8856.7725, -1464.6890, 975.5000);
	angles[11] = (0, 90, -89.9943);
	at[11] = 0.7000;
	points[12] = (8856.7725, -1464.6890, 961.7166);
	angles[12] = (0, 90, 0);
	at[12] = 0.7500;
	points[13] = (8856.7725, -1464.6890, 939.1929);
	angles[13] = (0, 90, 0);
	at[13] = 0.8500;
	points[14] = (8856.7725, -1464.6890, 930.0355);
	angles[14] = (0, 0, 0);
	at[14] = 0.9000;
	points[15] = (8856.7725, -1464.6890, 915.0748);
	angles[15] = (0, 0, 0);
	at[15] = 1;
	points[16] = (8856.7725, -1464.6890, 899.0552);
	angles[16] = (0, 0, 0);
	at[16] = 1.1500;
	points[17] = (8856.7725, -1464.6890, 726.3189);
	angles[17] = (0, 0, 0);
	at[17] = 3.1000;
	points[18] = (8857.2842, -1464.6890, 721.9409);
	angles[18] = (0, -90, -85.5871);
	at[18] = 3.1500;
	points[19] = (8859.1729, -1464.6890, 713.2834);
	angles[19] = (0, -90, -79.7761);
	at[19] = 3.2500;
	points[20] = (8860.1182, -1464.6890, 712.1968);
	angles[20] = (0, -90, -62.8250);
	at[20] = 3.3000;
	points[21] = (8862.0469, -1464.6890, 720.8386);
	angles[21] = (0, -90, 16.4837);
	at[21] = 3.4000;
	points[22] = (8862.7168, -1464.6890, 725.1968);
	angles[22] = (0, -90, 48.3115);
	at[22] = 3.4500;
	points[23] = (8862.6777, -1464.6890, 729.6260);
	angles[23] = (0, -90, 68.1735);
	at[23] = 3.5000;
	points[24] = (8862.6777, -1464.6890, 734.0551);
	angles[24] = (0, -90, 78.7576);
	at[24] = 3.5500;
	points[25] = (8862.6777, -1464.6890, 738.4843);
	angles[25] = (0, -90, 84.2349);
	at[25] = 3.6000;
	points[26] = (8862.6777, -1464.6890, 748.7993);
	angles[26] = (0, -90, 88.4879);
	at[26] = 3.7000;
	points[27] = (8862.6777, -1464.6890, 774.0905);
	angles[27] = (0, -90, 89.7971);
	at[27] = 3.8500;
	points[28] = (8862.6777, -1464.6890, 801.2874);
	angles[28] = (0, -90, 89.9468);
	at[28] = 3.9500;
	points[29] = (8862.6777, -1464.6890, 819.4016);
	angles[29] = (0, -90, 89.9727);
	at[29] = 4;
	points[30] = (8862.6777, -1464.6890, 841.4016);
	angles[30] = (0, -90, 89.9860);
	at[30] = 4.0500;
	points[31] = (8862.6777, -1464.6890, 868.1260);
	angles[31] = (0, -90, 89.9929);
	at[31] = 4.1000;
	points[32] = (8862.6777, -1464.6890, 900.5827);
	angles[32] = (0, -90, 0);
	at[32] = 4.1500;
	points[33] = (8862.6777, -1464.6890, 978.2874);
	angles[33] = (0, -90, 0);
	at[33] = 4.2500;
	points[34] = (8862.6777, -1464.6890, 1016.5236);
	angles[34] = (0, 0, 0);
	at[34] = 4.3000;
	points[35] = (8862.6777, -1464.6890, 1160.7284);
	angles[35] = (0, 0, 0);
	at[35] = 4.5000;
	points[36] = (8862.6777, -1464.6890, 1222.3661);
	angles[36] = (0, 0, 0);
	at[36] = 4.6000;
	points[37] = (8862.6777, -1464.6890, 1250.0237);
	angles[37] = (0, 0, 0);
	at[37] = 4.6500;
	points[38] = (8862.6777, -1464.6890, 1273.2087);
	angles[38] = (0, 0, 0);
	at[38] = 4.7000;
	points[39] = (8862.6777, -1464.6890, 1289.9489);
	angles[39] = (0, 0, 0);
	at[39] = 4.7500;
	points[40] = (8862.6777, -1464.6890, 1301.6062);
	angles[40] = (0, 0, 0);
	at[40] = 4.8000;
	points[41] = (8861.5752, -1464.6890, 1309.7953);
	angles[41] = (0, 90, 85.8371);
	at[41] = 4.8500;
	points[42] = (8859.9609, -1464.6890, 1320.6299);
	angles[42] = (0, 90, 82.6089);
	at[42] = 4.9500;
	points[43] = (8859.4492, -1464.6890, 1319.9291);
	angles[43] = (0, 90, 70.4862);
	at[43] = 5;
	points[44] = (8858.7793, -1464.6890, 1315.5275);
	angles[44] = (0, 90, 39.0053);
	at[44] = 5.0500;
	points[45] = (8857.9531, -1464.6890, 1309.8700);
	angles[45] = (0, 90, -3.4709);
	at[45] = 5.1000;
	points[46] = (8857.2842, -1464.6890, 1305.2284);
	angles[46] = (0, 90, -28.1619);
	at[46] = 5.1333;
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
	points[0] = (9586.1426, 1630.6772, 725.8898);
	angles[0] = (0, -90, 48.3115);
	at[0] = 0;
	points[1] = (9586.1426, 1630.6772, 730.3189);
	angles[1] = (0, -90, 68.1735);
	at[1] = 0.0500;
	points[2] = (9586.1426, 1630.6772, 734.7480);
	angles[2] = (0, -90, 78.7576);
	at[2] = 0.1000;
	points[3] = (9586.1426, 1630.6772, 739.1772);
	angles[3] = (0, -90, 84.2349);
	at[3] = 0.1500;
	points[4] = (9586.1426, 1630.6772, 756.8464);
	angles[4] = (0, -90, 89.2257);
	at[4] = 0.3000;
	points[5] = (9586.1426, 1630.6772, 775.8464);
	angles[5] = (0, -90, 89.7971);
	at[5] = 0.4000;
	points[6] = (9586.1426, 1630.6772, 803.8780);
	angles[6] = (0, -90, 89.9468);
	at[6] = 0.5000;
	points[7] = (9586.1426, 1630.6772, 822.5472);
	angles[7] = (0, -90, 89.9727);
	at[7] = 0.5500;
	points[8] = (9586.1426, 1630.6772, 845.2244);
	angles[8] = (0, -90, 89.9860);
	at[8] = 0.6000;
	points[9] = (9586.1426, 1630.6772, 872.7678);
	angles[9] = (0, -90, 89.9929);
	at[9] = 0.6500;
	points[10] = (9586.1426, 1630.6772, 906.2205);
	angles[10] = (0, -90, 0);
	at[10] = 0.7000;
	points[11] = (9586.1426, 1630.6772, 984.2678);
	angles[11] = (0, -90, 0);
	at[11] = 0.8000;
	points[12] = (9586.1426, 1630.6772, 1022.3819);
	angles[12] = (0, 0, 0);
	at[12] = 0.8500;
	points[13] = (9586.1426, 1630.6772, 1131.9213);
	angles[13] = (0, 0, 0);
	at[13] = 1;
	points[14] = (9586.1426, 1630.6772, 1197.4094);
	angles[14] = (0, 0, 0);
	at[14] = 1.1000;
	points[15] = (9586.1426, 1630.6772, 1254.1458);
	angles[15] = (0, 0, 0);
	at[15] = 1.2000;
	points[16] = (9586.1426, 1630.6772, 1276.2125);
	angles[16] = (0, 0, 0);
	at[16] = 1.2500;
	points[17] = (9586.1426, 1630.6772, 1292.0670);
	angles[17] = (0, 0, 0);
	at[17] = 1.3000;
	points[18] = (9586.1426, 1630.6772, 1303.0789);
	angles[18] = (0, 90, 88.2953);
	at[18] = 1.3500;
	points[19] = (9583.2676, 1630.6772, 1321.2520);
	angles[19] = (0, 90, 82.3794);
	at[19] = 1.5000;
	points[20] = (9582.7168, 1630.6772, 1318.8977);
	angles[20] = (0, 90, 61.9516);
	at[20] = 1.5500;
	points[21] = (9582.0479, 1630.6772, 1314.2047);
	angles[21] = (0, 90, 25.1575);
	at[21] = 1.6000;
	points[22] = (9581.1416, 1630.6772, 1308.1693);
	angles[22] = (0, 90, -16.5729);
	at[22] = 1.6500;
	points[23] = (9580, 1630.6772, 1300.4133);
	angles[23] = (0, 90, -47.7563);
	at[23] = 1.7000;
	points[24] = (9580.2363, 1630.6772, 1290.0040);
	angles[24] = (0, 90, -67.8693);
	at[24] = 1.7500;
	points[25] = (9580.2363, 1630.6772, 1275.8347);
	angles[25] = (0, 90, -78.5990);
	at[25] = 1.8000;
	points[26] = (9580.2363, 1630.6772, 1256.6299);
	angles[26] = (0, 90, -84.1532);
	at[26] = 1.8500;
	points[27] = (9580.2363, 1630.6772, 1231.1497);
	angles[27] = (0, 90, -87.0051);
	at[27] = 1.9000;
	points[28] = (9580.2363, 1630.6772, 1200.4685);
	angles[28] = (0, 90, -88.4664);
	at[28] = 1.9500;
	points[29] = (9580.2363, 1630.6772, 1126.5039);
	angles[29] = (0, 90, -89.5980);
	at[29] = 2.0500;
	points[30] = (9580.2363, 1630.6772, 1093.4646);
	angles[30] = (0, 90, -89.7942);
	at[30] = 2.1000;
	points[31] = (9580.2363, 1630.6772, 1064.6378);
	angles[31] = (0, 90, -89.8946);
	at[31] = 2.1500;
	points[32] = (9580.2363, 1630.6772, 1017.5433);
	angles[32] = (0, 90, -89.9723);
	at[32] = 2.2500;
	points[33] = (9580.2363, 1630.6772, 981.6929);
	angles[33] = (0, 90, -89.9927);
	at[33] = 2.3500;
	points[34] = (9580.2363, 1630.6772, 967.1181);
	angles[34] = (0, 90, 0);
	at[34] = 2.4000;
	points[35] = (9580.2363, 1630.6772, 943.3032);
	angles[35] = (0, 90, 0);
	at[35] = 2.5000;
	points[36] = (9580.2363, 1630.6772, 933.6221);
	angles[36] = (0, 0, 0);
	at[36] = 2.5500;
	points[37] = (9580.2363, 1630.6772, 925.1772);
	angles[37] = (0, 0, 0);
	at[37] = 2.6000;
	points[38] = (9580.2363, 1630.6772, 900.8701);
	angles[38] = (0, 0, 0);
	at[38] = 2.8000;
	points[39] = (9580.2363, 1630.6772, 728.1221);
	angles[39] = (0, 0, 0);
	at[39] = 4.7500;
	points[40] = (9580.2363, 1630.6772, 723.6929);
	angles[40] = (0, -90, -87.5508);
	at[40] = 4.8000;
	points[41] = (9583.1494, 1630.6772, 710.7205);
	angles[41] = (0, -90, -79.0321);
	at[41] = 4.9500;
	points[42] = (9584.0156, 1630.6772, 714.3110);
	angles[42] = (0, -90, -51.6110);
	at[42] = 5;
	points[43] = (9585, 1630.6772, 718.6339);
	angles[43] = (0, -90, -9.9915);
	at[43] = 5.0500;
	points[44] = (9585.9453, 1630.6772, 722.9528);
	angles[44] = (0, -90, 27.4960);
	at[44] = 5.1000;
	points[45] = (9586.1426, 1630.6772, 725.8898);
	angles[45] = (0, -90, 48.3115);
	at[45] = 5.1333;
	mover = getEnt("iz_obj_15", "targetname");
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
