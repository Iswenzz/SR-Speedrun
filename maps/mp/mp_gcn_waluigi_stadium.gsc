main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_waluigi_stadium", 0);

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
	ambientPlay("iz_0_r_gc_stadium32", 2);
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
	level.iz_route[level.iz_route.size] = (-14, 705, 425);
	level.iz_route[level.iz_route.size] = (-22, -397, 553);
	level.iz_route[level.iz_route.size] = (30, -1440, 425);
	level.iz_route[level.iz_route.size] = (64, -2618, 425);
	level.iz_route[level.iz_route.size] = (-663, -3429, 430);
	level.iz_route[level.iz_route.size] = (-1835, -3508, 446);
	level.iz_route[level.iz_route.size] = (-2954, -3504, 425);
	level.iz_route[level.iz_route.size] = (-3980, -3252, 425);
	level.iz_route[level.iz_route.size] = (-4473, -2265, 425);
	level.iz_route[level.iz_route.size] = (-4451, -1214, 597);
	level.iz_route[level.iz_route.size] = (-4452, 40, 596);
	level.iz_route[level.iz_route.size] = (-4355, 1349, 430);
	level.iz_route[level.iz_route.size] = (-3380, 2045, 431);
	level.iz_route[level.iz_route.size] = (-2208, 1594, 419);
	level.iz_route[level.iz_route.size] = (-2117, 330, 416);
	level.iz_route[level.iz_route.size] = (-2117, -737, 420);
	level.iz_route[level.iz_route.size] = (-2116, -1759, 468);
	level.iz_route[level.iz_route.size] = (-2117, -2513, 874);
	level.iz_route[level.iz_route.size] = (-2112, -4060, 874);
	level.iz_route[level.iz_route.size] = (-2119, -5020, 489);
	level.iz_route[level.iz_route.size] = (-2125, -6114, 425);
	level.iz_route[level.iz_route.size] = (-2444, -7157, 426);
	level.iz_route[level.iz_route.size] = (-2249, -8496, 430);
	level.iz_route[level.iz_route.size] = (-986, -9061, 449);
	level.iz_route[level.iz_route.size] = (210, -8873, 441);
	level.iz_route[level.iz_route.size] = (1222, -8808, 429);
	level.iz_route[level.iz_route.size] = (2128, -8728, 425);
	level.iz_route[level.iz_route.size] = (2930, -8643, 431);
	level.iz_route[level.iz_route.size] = (3731, -8298, 425);
	level.iz_route[level.iz_route.size] = (4275, -6960, 425);
	level.iz_route[level.iz_route.size] = (4298, -5358, 425);
	level.iz_route[level.iz_route.size] = (3801, -3908, 425);
	level.iz_route[level.iz_route.size] = (3810, -2704, 425);
	level.iz_route[level.iz_route.size] = (4823, -1275, 425);
	level.iz_route[level.iz_route.size] = (4822, 226, 425);
	level.iz_route[level.iz_route.size] = (3809, 1658, 425);
	level.iz_route[level.iz_route.size] = (3811, 3007, 425);
	level.iz_route[level.iz_route.size] = (4221, 4614, 425);
	level.iz_route[level.iz_route.size] = (3083, 5569, 425);
	level.iz_route[level.iz_route.size] = (1629, 5554, 421);
	level.iz_route[level.iz_route.size] = (295, 5537, 361);
	level.iz_route[level.iz_route.size] = (-1152, 5492, 230);
	level.iz_route[level.iz_route.size] = (-2566, 5491, 467);
	level.iz_route[level.iz_route.size] = (-3789, 5419, 496);
	level.iz_route[level.iz_route.size] = (-4700, 5497, 554);
	level.iz_route[level.iz_route.size] = (-5047, 6085, 617);
	level.iz_route[level.iz_route.size] = (-4632, 6727, 560);
	level.iz_route[level.iz_route.size] = (-3677, 7052, 480);
	level.iz_route[level.iz_route.size] = (-2595, 7753, 425);
	level.iz_route[level.iz_route.size] = (-2001, 8819, 425);
	level.iz_route[level.iz_route.size] = (-1675, 9997, 425);
	level.iz_route[level.iz_route.size] = (-685, 10227, 425);
	level.iz_route[level.iz_route.size] = (82, 9546, 425);
	level.iz_route[level.iz_route.size] = (0, 8385, 425);
	level.iz_route[level.iz_route.size] = (13, 7447, 444);
	level.iz_route[level.iz_route.size] = (-18, 6542, 687);
	level.iz_route[level.iz_route.size] = (-20, 5562, 1388);
	level.iz_route[level.iz_route.size] = (-20, 4696, 967);
	level.iz_route[level.iz_route.size] = (-31, 3399, 449);
	level.iz_route[level.iz_route.size] = (-31, 2436, 425);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2125.9844, -3277.5591, 1564.9607);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2125.9844, -3277.5591, 1564.9607);
	angles[1] = (-90, 0, 0);
	at[1] = 1.5000;
	points[2] = (-2125.9844, -3277.5591, 1564.9607);
	angles[2] = (-180, 0, 0);
	at[2] = 3;
	points[3] = (-2125.9844, -3277.5591, 1564.9607);
	angles[3] = (-360, 0, 0);
	at[3] = 6;
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
	points[0] = (-44.2913, 5447.8345, 1505.9055);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-44.2913, 5447.8345, 1505.9055);
	angles[1] = (-90, 0, 0);
	at[1] = 1.5000;
	points[2] = (-44.2913, 5447.8345, 1505.9055);
	angles[2] = (-180, 0, 0);
	at[2] = 3;
	points[3] = (-44.2913, 5447.8345, 1505.9055);
	angles[3] = (-360, 0, 0);
	at[3] = 6;
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
	points[0] = (4361.2207, -1837.7953, 1083.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4361.2207, -1837.7953, 1083.6614);
	angles[1] = (-90, 0, 0);
	at[1] = 1.8000;
	points[2] = (4361.2207, -1837.7953, 1083.6614);
	angles[2] = (-180, 0, 0);
	at[2] = 3.6000;
	points[3] = (4361.2207, -1837.7953, 1083.6614);
	angles[3] = (-360, 0, 0);
	at[3] = 7.2000;
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
	points[0] = (4361.2207, -5167.3228, 1083.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4361.2207, -5167.3228, 1083.6614);
	angles[1] = (90, 0, 0);
	at[1] = 1.8000;
	points[2] = (4361.2207, -5167.3228, 1083.6614);
	angles[2] = (180, 0, 0);
	at[2] = 3.6000;
	points[3] = (4361.2207, -5167.3228, 1083.6614);
	angles[3] = (0, 0, 0);
	at[3] = 7.2000;
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
	points[0] = (4361.2207, 1488.7795, 1083.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4361.2207, 1488.7795, 1083.6614);
	angles[1] = (90, 0, 0);
	at[1] = 1.8000;
	points[2] = (4361.2207, 1488.7795, 1083.6614);
	angles[2] = (180, 0, 0);
	at[2] = 3.6000;
	points[3] = (4361.2207, 1488.7795, 1083.6614);
	angles[3] = (0, 0, 0);
	at[3] = 7.2000;
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
	points[0] = (-4458.6616, -620.0787, 1092.5197);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4458.6616, -620.0787, 1092.5197);
	angles[1] = (90, 0, 0);
	at[1] = 1.5000;
	points[2] = (-4458.6616, -620.0787, 1092.5197);
	angles[2] = (180, 0, 0);
	at[2] = 3;
	points[3] = (-4458.6616, -620.0787, 1092.5197);
	angles[3] = (0, 0, 0);
	at[3] = 6;
	mover = getEnt("iz_obj_5", "targetname");
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
