main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_rainbow_road_2", 0);

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
	ambientPlay("iz_0_rrr2", 2);
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
	level.iz_route[level.iz_route.size] = (5366, -9280, 781);
	level.iz_route[level.iz_route.size] = (5080, -9326, 781);
	level.iz_route[level.iz_route.size] = (4793, -9497, 781);
	level.iz_route[level.iz_route.size] = (4581, -9678, 781);
	level.iz_route[level.iz_route.size] = (4235, -9929, 781);
	level.iz_route[level.iz_route.size] = (3919, -10109, 781);
	level.iz_route[level.iz_route.size] = (3505, -10147, 781);
	level.iz_route[level.iz_route.size] = (3277, -10161, 781);
	level.iz_route[level.iz_route.size] = (2237, -10166, 773);
	level.iz_route[level.iz_route.size] = (925, -10161, 781);
	level.iz_route[level.iz_route.size] = (226, -10136, 781);
	level.iz_route[level.iz_route.size] = (-72, -10010, 781);
	level.iz_route[level.iz_route.size] = (-310, -9811, 781);
	level.iz_route[level.iz_route.size] = (-552, -9581, 781);
	level.iz_route[level.iz_route.size] = (-778, -9444, 781);
	level.iz_route[level.iz_route.size] = (-1104, -9292, 781);
	level.iz_route[level.iz_route.size] = (-1698, -9285, 781);
	level.iz_route[level.iz_route.size] = (-2546, -9272, 781);
	level.iz_route[level.iz_route.size] = (-2851, -9235, 781);
	level.iz_route[level.iz_route.size] = (-3123, -9090, 781);
	level.iz_route[level.iz_route.size] = (-3317, -8849, 781);
	level.iz_route[level.iz_route.size] = (-3366, -8586, 781);
	level.iz_route[level.iz_route.size] = (-3385, -7983, 781);
	level.iz_route[level.iz_route.size] = (-3425, -6911, 773);
	level.iz_route[level.iz_route.size] = (-3407, -5554, 781);
	level.iz_route[level.iz_route.size] = (-3401, -4359, 781);
	level.iz_route[level.iz_route.size] = (-3451, -3604, 781);
	level.iz_route[level.iz_route.size] = (-3605, -3305, 781);
	level.iz_route[level.iz_route.size] = (-3754, -3125, 781);
	level.iz_route[level.iz_route.size] = (-4006, -3039, 781);
	level.iz_route[level.iz_route.size] = (-4475, -3032, 781);
	level.iz_route[level.iz_route.size] = (-6015, -3049, 781);
	level.iz_route[level.iz_route.size] = (-7428, -3052, 781);
	level.iz_route[level.iz_route.size] = (-8137, -3024, 781);
	level.iz_route[level.iz_route.size] = (-8409, -2978, 781);
	level.iz_route[level.iz_route.size] = (-8637, -2824, 781);
	level.iz_route[level.iz_route.size] = (-8790, -2561, 781);
	level.iz_route[level.iz_route.size] = (-8885, -2202, 781);
	level.iz_route[level.iz_route.size] = (-8884, -1715, 781);
	level.iz_route[level.iz_route.size] = (-8883, -909, 781);
	level.iz_route[level.iz_route.size] = (-8878, 333, 781);
	level.iz_route[level.iz_route.size] = (-8862, 1623, 781);
	level.iz_route[level.iz_route.size] = (-8846, 3106, 781);
	level.iz_route[level.iz_route.size] = (-8852, 6038, 781);
	level.iz_route[level.iz_route.size] = (-8789, 6822, 781);
	level.iz_route[level.iz_route.size] = (-8493, 7189, 781);
	level.iz_route[level.iz_route.size] = (-8129, 7375, 804);
	level.iz_route[level.iz_route.size] = (-7614, 7401, 917);
	level.iz_route[level.iz_route.size] = (-7065, 7408, 1037);
	level.iz_route[level.iz_route.size] = (-5640, 7420, 966);
	level.iz_route[level.iz_route.size] = (-4386, 7418, 930);
	level.iz_route[level.iz_route.size] = (-2918, 7366, 878);
	level.iz_route[level.iz_route.size] = (-1321, 7374, 821);
	level.iz_route[level.iz_route.size] = (152, 7384, 774);
	level.iz_route[level.iz_route.size] = (1528, 7377, 781);
	level.iz_route[level.iz_route.size] = (3684, 7386, 781);
	level.iz_route[level.iz_route.size] = (5186, 7440, 781);
	level.iz_route[level.iz_route.size] = (5707, 7601, 781);
	level.iz_route[level.iz_route.size] = (6184, 8106, 781);
	level.iz_route[level.iz_route.size] = (6597, 8515, 781);
	level.iz_route[level.iz_route.size] = (7215, 8781, 781);
	level.iz_route[level.iz_route.size] = (7927, 8892, 781);
	level.iz_route[level.iz_route.size] = (8393, 8708, 781);
	level.iz_route[level.iz_route.size] = (8621, 8133, 781);
	level.iz_route[level.iz_route.size] = (8704, 7111, 781);
	level.iz_route[level.iz_route.size] = (8688, 5644, 774);
	level.iz_route[level.iz_route.size] = (8660, 3559, 782);
	level.iz_route[level.iz_route.size] = (8734, 392, 782);
	level.iz_route[level.iz_route.size] = (8725, -1725, 782);
	level.iz_route[level.iz_route.size] = (8712, -2500, 782);
	level.iz_route[level.iz_route.size] = (8689, -3667, 773);
	level.iz_route[level.iz_route.size] = (8672, -5142, 781);
	level.iz_route[level.iz_route.size] = (8711, -7342, 781);
	level.iz_route[level.iz_route.size] = (8734, -8293, 781);
	level.iz_route[level.iz_route.size] = (8605, -8861, 781);
	level.iz_route[level.iz_route.size] = (8352, -9108, 781);
	level.iz_route[level.iz_route.size] = (8043, -9171, 781);
	level.iz_route[level.iz_route.size] = (6726, -9241, 781);
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
	points[0] = (-3171.3188, -3360.0513, 845.9370);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-3171.3188, -3360.0513, 925.6614);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (-3171.3188, -3360.0513, 930.1181);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (-3171.3188, -3360.0513, 930.1181);
	angles[3] = (0, -180, 0);
	at[3] = 1.9500;
	points[4] = (-3171.3188, -3360.0513, 937.7914);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (-3171.3188, -3360.0513, 934.5472);
	angles[5] = (0, -180, 0);
	at[5] = 2.0500;
	points[6] = (-3171.3188, -3360.0513, 922.4449);
	angles[6] = (0, -180, 0);
	at[6] = 2.1000;
	points[7] = (-3171.3188, -3360.0513, 925.6890);
	angles[7] = (0, -180, 0);
	at[7] = 2.1500;
	points[8] = (-3171.3188, -3360.0513, 937.7914);
	angles[8] = (0, -180, 0);
	at[8] = 2.2000;
	points[9] = (-3171.3188, -3360.0513, 934.5472);
	angles[9] = (0, -180, 0);
	at[9] = 2.2500;
	points[10] = (-3171.3188, -3360.0513, 922.4449);
	angles[10] = (0, -180, 0);
	at[10] = 2.3000;
	points[11] = (-3171.3188, -3360.0513, 925.6890);
	angles[11] = (0, -180, 0);
	at[11] = 2.3500;
	points[12] = (-3171.3188, -3360.0513, 937.7914);
	angles[12] = (0, -180, 0);
	at[12] = 2.4000;
	points[13] = (-3171.3188, -3360.0513, 934.5472);
	angles[13] = (0, -180, 0);
	at[13] = 2.4500;
	points[14] = (-3171.3188, -3360.0513, 940.4528);
	angles[14] = (0, -180, 0);
	at[14] = 2.5000;
	points[15] = (-3171.3188, -3360.0513, 1073.3268);
	angles[15] = (0, -180, 0);
	at[15] = 2.6500;
	points[16] = (-3171.3188, -3360.0513, 1043.2086);
	angles[16] = (0, -180, 0);
	at[16] = 2.7000;
	points[17] = (-3171.3188, -3360.0513, 967.9134);
	angles[17] = (0, -180, 0);
	at[17] = 2.7500;
	points[18] = (-3171.3188, -3360.0513, 847.4409);
	angles[18] = (0, -180, 0);
	at[18] = 2.8000;
	points[19] = (-3171.3188, -3360.0513, 780.9764);
	angles[19] = (0, -180, 0);
	at[19] = 2.8500;
	points[20] = (-3171.3188, -3360.0513, 780.9764);
	angles[20] = (0, -180, 0);
	at[20] = 3.8000;
	points[21] = (-3171.3188, -3360.0513, 783.9291);
	angles[21] = (0, -180, 0);
	at[21] = 3.8500;
	points[22] = (-3171.3188, -3360.0513, 845.9370);
	angles[22] = (0, -180, 0);
	at[22] = 4.2000;
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
	points[0] = (-8634.4092, 1432.5552, 845.9292);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-8634.4092, 1432.5552, 925.6536);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (-8634.4092, 1432.5552, 930.1181);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (-8634.4092, 1432.5552, 930.1181);
	angles[3] = (0, -180, 0);
	at[3] = 1.9500;
	points[4] = (-8634.4092, 1432.5552, 937.7914);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (-8634.4092, 1432.5552, 934.5472);
	angles[5] = (0, -180, 0);
	at[5] = 2.0500;
	points[6] = (-8634.4092, 1432.5552, 922.4449);
	angles[6] = (0, -180, 0);
	at[6] = 2.1000;
	points[7] = (-8634.4092, 1432.5552, 925.6890);
	angles[7] = (0, -180, 0);
	at[7] = 2.1500;
	points[8] = (-8634.4092, 1432.5552, 937.7914);
	angles[8] = (0, -180, 0);
	at[8] = 2.2000;
	points[9] = (-8634.4092, 1432.5552, 934.5472);
	angles[9] = (0, -180, 0);
	at[9] = 2.2500;
	points[10] = (-8634.4092, 1432.5552, 922.4449);
	angles[10] = (0, -180, 0);
	at[10] = 2.3000;
	points[11] = (-8634.4092, 1432.5552, 925.6890);
	angles[11] = (0, -180, 0);
	at[11] = 2.3500;
	points[12] = (-8634.4092, 1432.5552, 937.7914);
	angles[12] = (0, -180, 0);
	at[12] = 2.4000;
	points[13] = (-8634.4092, 1432.5552, 934.5472);
	angles[13] = (0, -180, 0);
	at[13] = 2.4500;
	points[14] = (-8634.4092, 1432.5552, 940.4528);
	angles[14] = (0, -180, 0);
	at[14] = 2.5000;
	points[15] = (-8634.4092, 1432.5552, 1073.3268);
	angles[15] = (0, -180, 0);
	at[15] = 2.6500;
	points[16] = (-8634.4092, 1432.5552, 1043.2086);
	angles[16] = (0, -180, 0);
	at[16] = 2.7000;
	points[17] = (-8634.4092, 1432.5552, 967.9134);
	angles[17] = (0, -180, 0);
	at[17] = 2.7500;
	points[18] = (-8634.4092, 1432.5552, 847.4409);
	angles[18] = (0, -180, 0);
	at[18] = 2.8000;
	points[19] = (-8634.4092, 1432.5552, 780.9685);
	angles[19] = (0, -180, 0);
	at[19] = 2.8500;
	points[20] = (-8634.4092, 1432.5552, 780.9685);
	angles[20] = (0, -180, 0);
	at[20] = 3.8000;
	points[21] = (-8634.4092, 1432.5552, 783.9213);
	angles[21] = (0, -180, 0);
	at[21] = 3.8500;
	points[22] = (-8634.4092, 1432.5552, 845.9292);
	angles[22] = (0, -180, 0);
	at[22] = 4.2000;
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
	points[0] = (-9071.8896, 3116.5042, 845.9292);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-9071.8896, 3116.5042, 925.6536);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (-9071.8896, 3116.5042, 930.1181);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (-9071.8896, 3116.5042, 930.1181);
	angles[3] = (0, -180, 0);
	at[3] = 1.9500;
	points[4] = (-9071.8896, 3116.5042, 937.7914);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (-9071.8896, 3116.5042, 934.5472);
	angles[5] = (0, -180, 0);
	at[5] = 2.0500;
	points[6] = (-9071.8896, 3116.5042, 922.4449);
	angles[6] = (0, -180, 0);
	at[6] = 2.1000;
	points[7] = (-9071.8896, 3116.5042, 925.6890);
	angles[7] = (0, -180, 0);
	at[7] = 2.1500;
	points[8] = (-9071.8896, 3116.5042, 937.7914);
	angles[8] = (0, -180, 0);
	at[8] = 2.2000;
	points[9] = (-9071.8896, 3116.5042, 934.5472);
	angles[9] = (0, -180, 0);
	at[9] = 2.2500;
	points[10] = (-9071.8896, 3116.5042, 922.4449);
	angles[10] = (0, -180, 0);
	at[10] = 2.3000;
	points[11] = (-9071.8896, 3116.5042, 925.6890);
	angles[11] = (0, -180, 0);
	at[11] = 2.3500;
	points[12] = (-9071.8896, 3116.5042, 937.7914);
	angles[12] = (0, -180, 0);
	at[12] = 2.4000;
	points[13] = (-9071.8896, 3116.5042, 934.5472);
	angles[13] = (0, -180, 0);
	at[13] = 2.4500;
	points[14] = (-9071.8896, 3116.5042, 940.4528);
	angles[14] = (0, -180, 0);
	at[14] = 2.5000;
	points[15] = (-9071.8896, 3116.5042, 1073.3268);
	angles[15] = (0, -180, 0);
	at[15] = 2.6500;
	points[16] = (-9071.8896, 3116.5042, 1043.2086);
	angles[16] = (0, -180, 0);
	at[16] = 2.7000;
	points[17] = (-9071.8896, 3116.5042, 967.9134);
	angles[17] = (0, -180, 0);
	at[17] = 2.7500;
	points[18] = (-9071.8896, 3116.5042, 847.4409);
	angles[18] = (0, -180, 0);
	at[18] = 2.8000;
	points[19] = (-9071.8896, 3116.5042, 780.9685);
	angles[19] = (0, -180, 0);
	at[19] = 2.8500;
	points[20] = (-9071.8896, 3116.5042, 780.9685);
	angles[20] = (0, -180, 0);
	at[20] = 3.8000;
	points[21] = (-9071.8896, 3116.5042, 783.9213);
	angles[21] = (0, -180, 0);
	at[21] = 3.8500;
	points[22] = (-9071.8896, 3116.5042, 845.9292);
	angles[22] = (0, -180, 0);
	at[22] = 4.2000;
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
	points[0] = (5710.5513, 7254.2520, 845.9331);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (5710.5513, 7254.2520, 925.6575);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (5710.5513, 7254.2520, 930.1181);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (5710.5513, 7254.2520, 930.1181);
	angles[3] = (0, 90, 0);
	at[3] = 1.9500;
	points[4] = (5710.5513, 7254.2520, 937.7914);
	angles[4] = (0, 90, 0);
	at[4] = 2;
	points[5] = (5710.5513, 7254.2520, 934.5472);
	angles[5] = (0, 90, 0);
	at[5] = 2.0500;
	points[6] = (5710.5513, 7254.2520, 922.4449);
	angles[6] = (0, 90, 0);
	at[6] = 2.1000;
	points[7] = (5710.5513, 7254.2520, 925.6890);
	angles[7] = (0, 90, 0);
	at[7] = 2.1500;
	points[8] = (5710.5513, 7254.2520, 937.7914);
	angles[8] = (0, 90, 0);
	at[8] = 2.2000;
	points[9] = (5710.5513, 7254.2520, 934.5472);
	angles[9] = (0, 90, 0);
	at[9] = 2.2500;
	points[10] = (5710.5513, 7254.2520, 922.4449);
	angles[10] = (0, 90, 0);
	at[10] = 2.3000;
	points[11] = (5710.5513, 7254.2520, 925.6890);
	angles[11] = (0, 90, 0);
	at[11] = 2.3500;
	points[12] = (5710.5513, 7254.2520, 937.7914);
	angles[12] = (0, 90, 0);
	at[12] = 2.4000;
	points[13] = (5710.5513, 7254.2520, 934.5472);
	angles[13] = (0, 90, 0);
	at[13] = 2.4500;
	points[14] = (5710.5513, 7254.2520, 940.4528);
	angles[14] = (0, 90, 0);
	at[14] = 2.5000;
	points[15] = (5710.5513, 7254.2520, 1073.3268);
	angles[15] = (0, 90, 0);
	at[15] = 2.6500;
	points[16] = (5710.5513, 7254.2520, 1043.2086);
	angles[16] = (0, 90, 0);
	at[16] = 2.7000;
	points[17] = (5710.5513, 7254.2520, 967.9134);
	angles[17] = (0, 90, 0);
	at[17] = 2.7500;
	points[18] = (5710.5513, 7254.2520, 847.4409);
	angles[18] = (0, 90, 0);
	at[18] = 2.8000;
	points[19] = (5710.5513, 7254.2520, 780.9725);
	angles[19] = (0, 90, 0);
	at[19] = 2.8500;
	points[20] = (5710.5513, 7254.2520, 780.9725);
	angles[20] = (0, 90, 0);
	at[20] = 3.8000;
	points[21] = (5710.5513, 7254.2520, 783.9252);
	angles[21] = (0, 90, 0);
	at[21] = 3.8500;
	points[22] = (5710.5513, 7254.2520, 845.9331);
	angles[22] = (0, 90, 0);
	at[22] = 4.2000;
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
