main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_cheep_beach", 0);

	setExpFog(0, 61515.7461, 1, 1, 1, 0);

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
	ambientPlay("iz_0_74", 2);
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
	level.iz_route[level.iz_route.size] = (6644, -2019, 756);
	level.iz_route[level.iz_route.size] = (6641, -3592, 756);
	level.iz_route[level.iz_route.size] = (6642, -4601, 859);
	level.iz_route[level.iz_route.size] = (6635, -5715, 871);
	level.iz_route[level.iz_route.size] = (6617, -7632, 871);
	level.iz_route[level.iz_route.size] = (6586, -8011, 871);
	level.iz_route[level.iz_route.size] = (6490, -8236, 871);
	level.iz_route[level.iz_route.size] = (6350, -8387, 871);
	level.iz_route[level.iz_route.size] = (6144, -8489, 871);
	level.iz_route[level.iz_route.size] = (5745, -8534, 871);
	level.iz_route[level.iz_route.size] = (4479, -8577, 871);
	level.iz_route[level.iz_route.size] = (4273, -8673, 871);
	level.iz_route[level.iz_route.size] = (4004, -8778, 871);
	level.iz_route[level.iz_route.size] = (3687, -8858, 871);
	level.iz_route[level.iz_route.size] = (2756, -8846, 871);
	level.iz_route[level.iz_route.size] = (2014, -8875, 926);
	level.iz_route[level.iz_route.size] = (99, -8897, 756);
	level.iz_route[level.iz_route.size] = (-1919, -8871, 756);
	level.iz_route[level.iz_route.size] = (-3368, -8983, 756);
	level.iz_route[level.iz_route.size] = (-4898, -9195, 756);
	level.iz_route[level.iz_route.size] = (-5361, -9264, 756);
	level.iz_route[level.iz_route.size] = (-5814, -9215, 756);
	level.iz_route[level.iz_route.size] = (-6187, -9150, 756);
	level.iz_route[level.iz_route.size] = (-6800, -8778, 756);
	level.iz_route[level.iz_route.size] = (-7323, -8148, 756);
	level.iz_route[level.iz_route.size] = (-7805, -7690, 756);
	level.iz_route[level.iz_route.size] = (-8194, -6930, 756);
	level.iz_route[level.iz_route.size] = (-8269, -6613, 756);
	level.iz_route[level.iz_route.size] = (-8305, -6294, 756);
	level.iz_route[level.iz_route.size] = (-8269, -5383, 756);
	level.iz_route[level.iz_route.size] = (-8052, -4814, 756);
	level.iz_route[level.iz_route.size] = (-7642, -4357, 756);
	level.iz_route[level.iz_route.size] = (-7046, -3903, 756);
	level.iz_route[level.iz_route.size] = (-6454, -3501, 836);
	level.iz_route[level.iz_route.size] = (-4842, -2472, 756);
	level.iz_route[level.iz_route.size] = (-3749, -1845, 756);
	level.iz_route[level.iz_route.size] = (-2990, -1327, 756);
	level.iz_route[level.iz_route.size] = (-2640, -904, 756);
	level.iz_route[level.iz_route.size] = (-2496, -379, 756);
	level.iz_route[level.iz_route.size] = (-2699, 452, 756);
	level.iz_route[level.iz_route.size] = (-3203, 1158, 756);
	level.iz_route[level.iz_route.size] = (-4159, 1643, 756);
	level.iz_route[level.iz_route.size] = (-5251, 2172, 756);
	level.iz_route[level.iz_route.size] = (-5974, 2665, 756);
	level.iz_route[level.iz_route.size] = (-6274, 3029, 756);
	level.iz_route[level.iz_route.size] = (-6397, 3513, 756);
	level.iz_route[level.iz_route.size] = (-6345, 4005, 756);
	level.iz_route[level.iz_route.size] = (-6162, 4352, 756);
	level.iz_route[level.iz_route.size] = (-5820, 4834, 756);
	level.iz_route[level.iz_route.size] = (-5338, 5094, 756);
	level.iz_route[level.iz_route.size] = (-4444, 5302, 756);
	level.iz_route[level.iz_route.size] = (-3574, 5529, 756);
	level.iz_route[level.iz_route.size] = (-2498, 5794, 756);
	level.iz_route[level.iz_route.size] = (-1853, 6001, 781);
	level.iz_route[level.iz_route.size] = (-788, 6546, 756);
	level.iz_route[level.iz_route.size] = (-158, 7027, 781);
	level.iz_route[level.iz_route.size] = (1549, 8597, 756);
	level.iz_route[level.iz_route.size] = (1994, 8864, 756);
	level.iz_route[level.iz_route.size] = (2644, 8826, 756);
	level.iz_route[level.iz_route.size] = (3565, 8620, 741);
	level.iz_route[level.iz_route.size] = (4087, 8553, 755);
	level.iz_route[level.iz_route.size] = (4566, 8676, 756);
	level.iz_route[level.iz_route.size] = (5083, 9165, 756);
	level.iz_route[level.iz_route.size] = (5578, 9523, 756);
	level.iz_route[level.iz_route.size] = (6218, 9667, 756);
	level.iz_route[level.iz_route.size] = (6816, 9692, 756);
	level.iz_route[level.iz_route.size] = (7549, 9694, 765);
	level.iz_route[level.iz_route.size] = (8161, 9557, 802);
	level.iz_route[level.iz_route.size] = (8841, 9289, 850);
	level.iz_route[level.iz_route.size] = (9452, 8858, 913);
	level.iz_route[level.iz_route.size] = (9750, 8416, 960);
	level.iz_route[level.iz_route.size] = (9796, 7760, 1017);
	level.iz_route[level.iz_route.size] = (9588, 7178, 1069);
	level.iz_route[level.iz_route.size] = (9146, 6597, 1133);
	level.iz_route[level.iz_route.size] = (8953, 6105, 1179);
	level.iz_route[level.iz_route.size] = (8779, 5458, 1226);
	level.iz_route[level.iz_route.size] = (8582, 4925, 1251);
	level.iz_route[level.iz_route.size] = (8247, 4476, 1239);
	level.iz_route[level.iz_route.size] = (7761, 4245, 1197);
	level.iz_route[level.iz_route.size] = (7248, 4043, 1144);
	level.iz_route[level.iz_route.size] = (6880, 3751, 1099);
	level.iz_route[level.iz_route.size] = (6663, 3223, 1039);
	level.iz_route[level.iz_route.size] = (6613, 2427, 952);
	level.iz_route[level.iz_route.size] = (6587, 1384, 851);
	level.iz_route[level.iz_route.size] = (6583, -132, 756);
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
	points[0] = (-2728.9526, -247.5925, 756.0906);
	angles[0] = (0, 138.4063, 0);
	at[0] = 0;
	points[1] = (-2714.0750, -260.7992, 756.0906);
	angles[1] = (0, 138.4063, 0);
	at[1] = 0.0500;
	points[2] = (-2256.9607, -666.5551, 756.0906);
	angles[2] = (0, 138.4063, 0);
	at[2] = 2.3500;
	points[3] = (-2247.0237, -675.3740, 756.0906);
	angles[3] = (0, -41.5936, 0);
	at[3] = 2.4000;
	points[4] = (-2261.4805, -662.5394, 756.0906);
	angles[4] = (0, -41.5936, 0);
	at[4] = 2.4500;
	points[5] = (-2718.5945, -256.7870, 756.0906);
	angles[5] = (0, -41.5936, 0);
	at[5] = 4.7500;
	points[6] = (-2728.9526, -247.5925, 756.0906);
	angles[6] = (0, 138.4063, 0);
	at[6] = 4.8000;
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
	points[0] = (-3518.3701, -2133.2402, 756.0906);
	angles[0] = (0, -59.3209, 0);
	at[0] = 0;
	points[1] = (-3527.2798, -2118.2244, 756.0906);
	angles[1] = (0, -59.3209, 0);
	at[1] = 0.0500;
	points[2] = (-3852.7007, -1569.6930, 756.0906);
	angles[2] = (0, -59.3209, 0);
	at[2] = 2.4500;
	points[3] = (-3859.4805, -1558.2678, 756.0906);
	angles[3] = (0, 120.6790, 0);
	at[3] = 2.5000;
	points[4] = (-3848.9094, -1576.0828, 756.0866);
	angles[4] = (0, 120.6790, 0);
	at[4] = 2.5500;
	points[5] = (-3523.4880, -2124.6143, 756.0906);
	angles[5] = (0, 120.6790, 0);
	at[5] = 4.9500;
	points[6] = (-3518.3701, -2133.2402, 756.0906);
	angles[6] = (0, -59.3209, 0);
	at[6] = 4.9833;
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
	points[0] = (-3150.8782, 5978.6616, 756.0906);
	angles[0] = (0, 109.7756, 0);
	at[0] = 0;
	points[1] = (-2890.1340, 5253.4253, 756.0906);
	angles[1] = (0, 109.7756, 0);
	at[1] = 2.9000;
	points[2] = (-2893.5354, 5262.9131, 756.0906);
	angles[2] = (0, -70.2243, 0);
	at[2] = 2.9500;
	points[3] = (-3154.2834, 5988.1104, 756.0906);
	angles[3] = (0, -70.2243, 0);
	at[3] = 5.8500;
	points[4] = (-3150.8782, 5978.6616, 756.0906);
	angles[4] = (0, 109.7756, 0);
	at[4] = 5.9000;
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
	points[0] = (-328.5315, 6160.5908, 756.0906);
	angles[0] = (0, -64.5251, 0);
	at[0] = 0;
	points[1] = (-336.8469, 6178.0713, 756.0906);
	angles[1] = (0, -64.5251, 0);
	at[1] = 0.0500;
	points[2] = (-782.6260, 7113.7012, 756.0906);
	angles[2] = (0, -64.5251, 0);
	at[2] = 3.9500;
	points[3] = (-782.2323, 7112.8745, 756.0906);
	angles[3] = (0, -244.5251, 0);
	at[3] = 4;
	points[4] = (-330.7393, 6165.2363, 756.0906);
	angles[4] = (0, -244.5251, 0);
	at[4] = 7.9500;
	points[5] = (-328.5315, 6160.5908, 756.0906);
	angles[5] = (0, -64.5251, 0);
	at[5] = 7.9667;
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
