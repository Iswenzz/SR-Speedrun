main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_rainbow_road_1", 0);

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
	ambientPlay("iz_0_rrr1", 2);
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
	level.iz_route[level.iz_route.size] = (-5378, -2293, 2447);
	level.iz_route[level.iz_route.size] = (-5401, -3589, 2447);
	level.iz_route[level.iz_route.size] = (-5408, -4333, 2447);
	level.iz_route[level.iz_route.size] = (-5501, -4753, 2447);
	level.iz_route[level.iz_route.size] = (-5753, -5156, 2447);
	level.iz_route[level.iz_route.size] = (-6139, -5632, 2447);
	level.iz_route[level.iz_route.size] = (-6336, -6175, 2447);
	level.iz_route[level.iz_route.size] = (-6435, -6858, 2447);
	level.iz_route[level.iz_route.size] = (-6426, -7492, 2447);
	level.iz_route[level.iz_route.size] = (-6214, -7888, 2447);
	level.iz_route[level.iz_route.size] = (-5790, -8077, 2447);
	level.iz_route[level.iz_route.size] = (-5236, -8085, 2447);
	level.iz_route[level.iz_route.size] = (-4455, -8009, 2447);
	level.iz_route[level.iz_route.size] = (-3424, -7984, 2447);
	level.iz_route[level.iz_route.size] = (-2108, -7984, 2447);
	level.iz_route[level.iz_route.size] = (-867, -8011, 2447);
	level.iz_route[level.iz_route.size] = (-117, -8044, 2447);
	level.iz_route[level.iz_route.size] = (513, -8063, 2447);
	level.iz_route[level.iz_route.size] = (895, -8002, 2447);
	level.iz_route[level.iz_route.size] = (1232, -7818, 2447);
	level.iz_route[level.iz_route.size] = (1493, -7584, 2447);
	level.iz_route[level.iz_route.size] = (1582, -7247, 2447);
	level.iz_route[level.iz_route.size] = (1595, -6789, 2447);
	level.iz_route[level.iz_route.size] = (1595, -6156, 2447);
	level.iz_route[level.iz_route.size] = (1595, -5640, 2462);
	level.iz_route[level.iz_route.size] = (1595, -5144, 2558);
	level.iz_route[level.iz_route.size] = (1595, -4199, 2447);
	level.iz_route[level.iz_route.size] = (1595, -3449, 2447);
	level.iz_route[level.iz_route.size] = (1595, -2614, 2447);
	level.iz_route[level.iz_route.size] = (1595, -1937, 2602);
	level.iz_route[level.iz_route.size] = (1594, -1029, 2447);
	level.iz_route[level.iz_route.size] = (1595, -119, 2458);
	level.iz_route[level.iz_route.size] = (1595, 355, 2624);
	level.iz_route[level.iz_route.size] = (1595, 1591, 2447);
	level.iz_route[level.iz_route.size] = (1595, 2695, 2447);
	level.iz_route[level.iz_route.size] = (1595, 4096, 2447);
	level.iz_route[level.iz_route.size] = (1595, 4814, 2447);
	level.iz_route[level.iz_route.size] = (1595, 5506, 2589);
	level.iz_route[level.iz_route.size] = (1595, 6473, 2447);
	level.iz_route[level.iz_route.size] = (1595, 7453, 2447);
	level.iz_route[level.iz_route.size] = (1628, 8499, 2447);
	level.iz_route[level.iz_route.size] = (1761, 8839, 2447);
	level.iz_route[level.iz_route.size] = (2010, 9089, 2447);
	level.iz_route[level.iz_route.size] = (2366, 9225, 2447);
	level.iz_route[level.iz_route.size] = (2800, 9283, 2447);
	level.iz_route[level.iz_route.size] = (3764, 9216, 2447);
	level.iz_route[level.iz_route.size] = (4917, 9214, 2447);
	level.iz_route[level.iz_route.size] = (5940, 9199, 2447);
	level.iz_route[level.iz_route.size] = (6286, 9093, 2447);
	level.iz_route[level.iz_route.size] = (6517, 8956, 2447);
	level.iz_route[level.iz_route.size] = (6691, 8698, 2447);
	level.iz_route[level.iz_route.size] = (6792, 8346, 2447);
	level.iz_route[level.iz_route.size] = (6816, 7940, 2447);
	level.iz_route[level.iz_route.size] = (6770, 6803, 2447);
	level.iz_route[level.iz_route.size] = (6812, 5008, 2447);
	level.iz_route[level.iz_route.size] = (6834, 3367, 2447);
	level.iz_route[level.iz_route.size] = (6827, 2596, 2447);
	level.iz_route[level.iz_route.size] = (6833, 2020, 2447);
	level.iz_route[level.iz_route.size] = (6746, 1640, 2447);
	level.iz_route[level.iz_route.size] = (6486, 1376, 2447);
	level.iz_route[level.iz_route.size] = (6024, 1292, 2447);
	level.iz_route[level.iz_route.size] = (5604, 1308, 2447);
	level.iz_route[level.iz_route.size] = (5061, 1328, 2447);
	level.iz_route[level.iz_route.size] = (3940, 1328, 2447);
	level.iz_route[level.iz_route.size] = (3322, 1328, 2981);
	level.iz_route[level.iz_route.size] = (1850, 1328, 2934);
	level.iz_route[level.iz_route.size] = (193, 1328, 2823);
	level.iz_route[level.iz_route.size] = (-2205, 1328, 2447);
	level.iz_route[level.iz_route.size] = (-3129, 1328, 2447);
	level.iz_route[level.iz_route.size] = (-3895, 1373, 2447);
	level.iz_route[level.iz_route.size] = (-4567, 1339, 2447);
	level.iz_route[level.iz_route.size] = (-4902, 1302, 2447);
	level.iz_route[level.iz_route.size] = (-5227, 1120, 2447);
	level.iz_route[level.iz_route.size] = (-5397, 836, 2447);
	level.iz_route[level.iz_route.size] = (-5481, 462, 2447);
	level.iz_route[level.iz_route.size] = (-5462, -44, 2447);
	level.iz_route[level.iz_route.size] = (-5439, -1111, 2447);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1199.9292, -7811.3389, 2668.2285);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-1199.9292, -7811.3389, 2668.2285);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (-1199.9292, -7811.3389, 2675.9016);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (-1199.9292, -7811.3389, 2672.6575);
	angles[3] = (0, 90, 0);
	at[3] = 0.5500;
	points[4] = (-1199.9292, -7811.3389, 2660.5591);
	angles[4] = (0, 90, 0);
	at[4] = 0.6000;
	points[5] = (-1199.9292, -7811.3389, 2663.7993);
	angles[5] = (0, 90, 0);
	at[5] = 0.6500;
	points[6] = (-1199.9292, -7811.3389, 2675.9016);
	angles[6] = (0, 90, 0);
	at[6] = 0.7000;
	points[7] = (-1199.9292, -7811.3389, 2672.6575);
	angles[7] = (0, 90, 0);
	at[7] = 0.7500;
	points[8] = (-1199.9292, -7811.3389, 2660.5591);
	angles[8] = (0, 90, 0);
	at[8] = 0.8000;
	points[9] = (-1199.9292, -7811.3389, 2663.7993);
	angles[9] = (0, 90, 0);
	at[9] = 0.8500;
	points[10] = (-1199.9292, -7811.3389, 2675.9016);
	angles[10] = (0, 90, 0);
	at[10] = 0.9000;
	points[11] = (-1199.9292, -7811.3389, 2672.6575);
	angles[11] = (0, 90, 0);
	at[11] = 0.9500;
	points[12] = (-1199.9292, -7811.3389, 2678.5630);
	angles[12] = (0, 90, 0);
	at[12] = 1;
	points[13] = (-1199.9292, -7811.3389, 2811.4370);
	angles[13] = (0, 90, 0);
	at[13] = 1.1500;
	points[14] = (-1199.9292, -7811.3389, 2781.3188);
	angles[14] = (0, 90, 0);
	at[14] = 1.2000;
	points[15] = (-1199.9292, -7811.3389, 2706.0237);
	angles[15] = (0, 90, 0);
	at[15] = 1.2500;
	points[16] = (-1199.9292, -7811.3389, 2585.5510);
	angles[16] = (0, 90, 0);
	at[16] = 1.3000;
	points[17] = (-1199.9292, -7811.3389, 2446.7717);
	angles[17] = (0, 90, 0);
	at[17] = 1.3500;
	points[18] = (-1199.9292, -7811.3389, 2446.7717);
	angles[18] = (0, 90, 0);
	at[18] = 2.3500;
	points[19] = (-1199.9292, -7811.3389, 2668.2285);
	angles[19] = (0, 90, 0);
	at[19] = 3.6000;
	points[20] = (-1199.9292, -7811.3389, 2668.2285);
	angles[20] = (0, 90, 0);
	at[20] = 4.1333;
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
	points[0] = (6681.2207, 3041.7246, 2675.9016);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6681.2207, 3041.7246, 2672.6575);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (6681.2207, 3041.7246, 2660.5591);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (6681.2207, 3041.7246, 2663.7993);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (6681.2207, 3041.7246, 2675.9016);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (6681.2207, 3041.7246, 2672.6575);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (6681.2207, 3041.7246, 2660.5591);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (6681.2207, 3041.7246, 2663.7993);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (6681.2207, 3041.7246, 2675.9016);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (6681.2207, 3041.7246, 2672.6575);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (6681.2207, 3041.7246, 2678.5630);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (6681.2207, 3041.7246, 2811.4370);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (6681.2207, 3041.7246, 2781.3188);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (6681.2207, 3041.7246, 2706.0237);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (6681.2207, 3041.7246, 2585.5510);
	angles[14] = (0, 0, 0);
	at[14] = 0.8000;
	points[15] = (6681.2207, 3041.7246, 2446.7717);
	angles[15] = (0, 0, 0);
	at[15] = 0.8500;
	points[16] = (6681.2207, 3041.7246, 2446.7717);
	angles[16] = (0, 0, 0);
	at[16] = 1.8500;
	points[17] = (6681.2207, 3041.7246, 2668.2285);
	angles[17] = (0, 0, 0);
	at[17] = 3.1000;
	points[18] = (6681.2207, 3041.7246, 2668.2285);
	angles[18] = (0, 0, 0);
	at[18] = 4.1000;
	points[19] = (6681.2207, 3041.7246, 2675.9016);
	angles[19] = (0, 0, 0);
	at[19] = 4.1333;
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
	points[0] = (6946.5356, 4453.5435, 2561.9292);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6946.5356, 4453.5435, 2668.2285);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (6946.5356, 4453.5435, 2668.2285);
	angles[2] = (0, 0, 0);
	at[2] = 1.6000;
	points[3] = (6946.5356, 4453.5435, 2677.0867);
	angles[3] = (0, 0, 0);
	at[3] = 1.6500;
	points[4] = (6946.5356, 4453.5435, 2659.3699);
	angles[4] = (0, 0, 0);
	at[4] = 1.7500;
	points[5] = (6946.5356, 4453.5435, 2677.0867);
	angles[5] = (0, 0, 0);
	at[5] = 1.8500;
	points[6] = (6946.5356, 4453.5435, 2659.3699);
	angles[6] = (0, 0, 0);
	at[6] = 1.9500;
	points[7] = (6946.5356, 4453.5435, 2677.0867);
	angles[7] = (0, 0, 0);
	at[7] = 2.0500;
	points[8] = (6946.5356, 4453.5435, 2668.2285);
	angles[8] = (0, 0, 0);
	at[8] = 2.1000;
	points[9] = (6946.5356, 4453.5435, 2693.3269);
	angles[9] = (0, 0, 0);
	at[9] = 2.1500;
	points[10] = (6946.5356, 4453.5435, 2781.9094);
	angles[10] = (0, 0, 0);
	at[10] = 2.2500;
	points[11] = (6946.5356, 4453.5435, 2806.4172);
	angles[11] = (0, 0, 0);
	at[11] = 2.3000;
	points[12] = (6946.5356, 4453.5435, 2761.2402);
	angles[12] = (0, 0, 0);
	at[12] = 2.3500;
	points[13] = (6946.5356, 4453.5435, 2670.8857);
	angles[13] = (0, 0, 0);
	at[13] = 2.4000;
	points[14] = (6946.5356, 4453.5435, 2535.3545);
	angles[14] = (0, 0, 0);
	at[14] = 2.4500;
	points[15] = (6946.5356, 4453.5435, 2446.7717);
	angles[15] = (0, 0, 0);
	at[15] = 2.5000;
	points[16] = (6946.5356, 4453.5435, 2446.7717);
	angles[16] = (0, 0, 0);
	at[16] = 3.4500;
	points[17] = (6946.5356, 4453.5435, 2449.7244);
	angles[17] = (0, 0, 0);
	at[17] = 3.5000;
	points[18] = (6946.5356, 4453.5435, 2561.9292);
	angles[18] = (0, 0, 0);
	at[18] = 4.1333;
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
	points[0] = (-1199.9292, -8166.0630, 2668.2285);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-1199.9292, -8166.0630, 2668.2285);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (-1199.9292, -8166.0630, 2675.9016);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (-1199.9292, -8166.0630, 2672.6575);
	angles[3] = (0, 90, 0);
	at[3] = 0.5500;
	points[4] = (-1199.9292, -8166.0630, 2660.5591);
	angles[4] = (0, 90, 0);
	at[4] = 0.6000;
	points[5] = (-1199.9292, -8166.0630, 2663.7993);
	angles[5] = (0, 90, 0);
	at[5] = 0.6500;
	points[6] = (-1199.9292, -8166.0630, 2675.9016);
	angles[6] = (0, 90, 0);
	at[6] = 0.7000;
	points[7] = (-1199.9292, -8166.0630, 2672.6575);
	angles[7] = (0, 90, 0);
	at[7] = 0.7500;
	points[8] = (-1199.9292, -8166.0630, 2660.5591);
	angles[8] = (0, 90, 0);
	at[8] = 0.8000;
	points[9] = (-1199.9292, -8166.0630, 2663.7993);
	angles[9] = (0, 90, 0);
	at[9] = 0.8500;
	points[10] = (-1199.9292, -8166.0630, 2675.9016);
	angles[10] = (0, 90, 0);
	at[10] = 0.9000;
	points[11] = (-1199.9292, -8166.0630, 2672.6575);
	angles[11] = (0, 90, 0);
	at[11] = 0.9500;
	points[12] = (-1199.9292, -8166.0630, 2678.5630);
	angles[12] = (0, 90, 0);
	at[12] = 1;
	points[13] = (-1199.9292, -8166.0630, 2811.4370);
	angles[13] = (0, 90, 0);
	at[13] = 1.1500;
	points[14] = (-1199.9292, -8166.0630, 2781.3188);
	angles[14] = (0, 90, 0);
	at[14] = 1.2000;
	points[15] = (-1199.9292, -8166.0630, 2706.0237);
	angles[15] = (0, 90, 0);
	at[15] = 1.2500;
	points[16] = (-1199.9292, -8166.0630, 2585.5510);
	angles[16] = (0, 90, 0);
	at[16] = 1.3000;
	points[17] = (-1199.9292, -8166.0630, 2446.7717);
	angles[17] = (0, 90, 0);
	at[17] = 1.3500;
	points[18] = (-1199.9292, -8166.0630, 2446.7717);
	angles[18] = (0, 90, 0);
	at[18] = 2.3500;
	points[19] = (-1199.9292, -8166.0630, 2668.2285);
	angles[19] = (0, 90, 0);
	at[19] = 3.6000;
	points[20] = (-1199.9292, -8166.0630, 2668.2285);
	angles[20] = (0, 90, 0);
	at[20] = 4.1333;
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
	points[0] = (1632.5078, 2728.2441, 2585.5510);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (1632.5078, 2728.2441, 2665.2756);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (1632.5078, 2728.2441, 2668.2285);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (1632.5078, 2728.2441, 2668.2285);
	angles[3] = (0, -180, 0);
	at[3] = 1.4500;
	points[4] = (1632.5078, 2728.2441, 2675.9016);
	angles[4] = (0, -180, 0);
	at[4] = 1.5000;
	points[5] = (1632.5078, 2728.2441, 2672.6575);
	angles[5] = (0, -180, 0);
	at[5] = 1.5500;
	points[6] = (1632.5078, 2728.2441, 2660.5591);
	angles[6] = (0, -180, 0);
	at[6] = 1.6000;
	points[7] = (1632.5078, 2728.2441, 2663.7993);
	angles[7] = (0, -180, 0);
	at[7] = 1.6500;
	points[8] = (1632.5078, 2728.2441, 2675.9016);
	angles[8] = (0, -180, 0);
	at[8] = 1.7000;
	points[9] = (1632.5078, 2728.2441, 2672.6575);
	angles[9] = (0, -180, 0);
	at[9] = 1.7500;
	points[10] = (1632.5078, 2728.2441, 2660.5591);
	angles[10] = (0, -180, 0);
	at[10] = 1.8000;
	points[11] = (1632.5078, 2728.2441, 2663.7993);
	angles[11] = (0, -180, 0);
	at[11] = 1.8500;
	points[12] = (1632.5078, 2728.2441, 2675.9016);
	angles[12] = (0, -180, 0);
	at[12] = 1.9000;
	points[13] = (1632.5078, 2728.2441, 2672.6575);
	angles[13] = (0, -180, 0);
	at[13] = 1.9500;
	points[14] = (1632.5078, 2728.2441, 2678.5630);
	angles[14] = (0, -180, 0);
	at[14] = 2;
	points[15] = (1632.5078, 2728.2441, 2811.4370);
	angles[15] = (0, -180, 0);
	at[15] = 2.1500;
	points[16] = (1632.5078, 2728.2441, 2781.3188);
	angles[16] = (0, -180, 0);
	at[16] = 2.2000;
	points[17] = (1632.5078, 2728.2441, 2706.0237);
	angles[17] = (0, -180, 0);
	at[17] = 2.2500;
	points[18] = (1632.5078, 2728.2441, 2585.5510);
	angles[18] = (0, -180, 0);
	at[18] = 2.3000;
	points[19] = (1632.5078, 2728.2441, 2446.7717);
	angles[19] = (0, -180, 0);
	at[19] = 2.3500;
	points[20] = (1632.5078, 2728.2441, 2446.7717);
	angles[20] = (0, -180, 0);
	at[20] = 3.3500;
	points[21] = (1632.5078, 2728.2441, 2585.5510);
	angles[21] = (0, -180, 0);
	at[21] = 4.1333;
	mover = getEnt("iz_obj_4", "targetname");
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
