main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_lakeside_park", 0);

	setExpFog(5905.5117, 14517.7158, 1, 0.7765, 0.2706, 0);

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
	ambientPlay("iz_0_52", 2);
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
	level.iz_route[level.iz_route.size] = (3982, -2433, 908);
	level.iz_route[level.iz_route.size] = (3991, -3243, 908);
	level.iz_route[level.iz_route.size] = (3999, -4297, 908);
	level.iz_route[level.iz_route.size] = (4002, -5150, 908);
	level.iz_route[level.iz_route.size] = (4002, -6188, 908);
	level.iz_route[level.iz_route.size] = (3987, -7000, 908);
	level.iz_route[level.iz_route.size] = (3987, -7671, 908);
	level.iz_route[level.iz_route.size] = (3987, -8442, 908);
	level.iz_route[level.iz_route.size] = (3925, -9048, 908);
	level.iz_route[level.iz_route.size] = (3696, -9500, 908);
	level.iz_route[level.iz_route.size] = (3355, -9731, 908);
	level.iz_route[level.iz_route.size] = (2820, -9849, 908);
	level.iz_route[level.iz_route.size] = (2317, -10114, 908);
	level.iz_route[level.iz_route.size] = (1814, -10371, 908);
	level.iz_route[level.iz_route.size] = (1296, -10433, 908);
	level.iz_route[level.iz_route.size] = (761, -10259, 908);
	level.iz_route[level.iz_route.size] = (506, -9914, 908);
	level.iz_route[level.iz_route.size] = (372, -9494, 908);
	level.iz_route[level.iz_route.size] = (369, -8743, 908);
	level.iz_route[level.iz_route.size] = (368, -8107, 908);
	level.iz_route[level.iz_route.size] = (358, -7551, 908);
	level.iz_route[level.iz_route.size] = (285, -7137, 908);
	level.iz_route[level.iz_route.size] = (78, -6854, 908);
	level.iz_route[level.iz_route.size] = (-302, -6694, 908);
	level.iz_route[level.iz_route.size] = (-865, -6672, 908);
	level.iz_route[level.iz_route.size] = (-1504, -6660, 908);
	level.iz_route[level.iz_route.size] = (-2175, -6655, 908);
	level.iz_route[level.iz_route.size] = (-2637, -6640, 908);
	level.iz_route[level.iz_route.size] = (-2973, -6584, 908);
	level.iz_route[level.iz_route.size] = (-3240, -6438, 908);
	level.iz_route[level.iz_route.size] = (-3416, -6190, 908);
	level.iz_route[level.iz_route.size] = (-3468, -5867, 908);
	level.iz_route[level.iz_route.size] = (-3480, -5007, 908);
	level.iz_route[level.iz_route.size] = (-3417, -4766, 908);
	level.iz_route[level.iz_route.size] = (-3185, -4465, 908);
	level.iz_route[level.iz_route.size] = (-2504, -3704, 908);
	level.iz_route[level.iz_route.size] = (-2407, -3532, 908);
	level.iz_route[level.iz_route.size] = (-2333, -3251, 908);
	level.iz_route[level.iz_route.size] = (-2326, -2199, 908);
	level.iz_route[level.iz_route.size] = (-2318, -1688, 908);
	level.iz_route[level.iz_route.size] = (-2392, -1414, 908);
	level.iz_route[level.iz_route.size] = (-2606, -1125, 908);
	level.iz_route[level.iz_route.size] = (-2931, -955, 908);
	level.iz_route[level.iz_route.size] = (-3464, -925, 908);
	level.iz_route[level.iz_route.size] = (-4034, -925, 908);
	level.iz_route[level.iz_route.size] = (-4557, -929, 908);
	level.iz_route[level.iz_route.size] = (-4867, -1003, 908);
	level.iz_route[level.iz_route.size] = (-5199, -1159, 908);
	level.iz_route[level.iz_route.size] = (-5476, -1211, 908);
	level.iz_route[level.iz_route.size] = (-5739, -1204, 908);
	level.iz_route[level.iz_route.size] = (-6001, -1111, 908);
	level.iz_route[level.iz_route.size] = (-6278, -996, 908);
	level.iz_route[level.iz_route.size] = (-6632, -945, 908);
	level.iz_route[level.iz_route.size] = (-7203, -956, 908);
	level.iz_route[level.iz_route.size] = (-7563, -1034, 908);
	level.iz_route[level.iz_route.size] = (-7814, -1256, 908);
	level.iz_route[level.iz_route.size] = (-8340, -1827, 908);
	level.iz_route[level.iz_route.size] = (-8628, -2102, 908);
	level.iz_route[level.iz_route.size] = (-8894, -2191, 908);
	level.iz_route[level.iz_route.size] = (-9731, -2191, 908);
	level.iz_route[level.iz_route.size] = (-10273, -2184, 908);
	level.iz_route[level.iz_route.size] = (-10554, -2074, 908);
	level.iz_route[level.iz_route.size] = (-10761, -1882, 908);
	level.iz_route[level.iz_route.size] = (-10916, -1630, 908);
	level.iz_route[level.iz_route.size] = (-11004, -1037, 908);
	level.iz_route[level.iz_route.size] = (-11122, -719, 908);
	level.iz_route[level.iz_route.size] = (-11449, -430, 908);
	level.iz_route[level.iz_route.size] = (-11891, -283, 908);
	level.iz_route[level.iz_route.size] = (-12300, -126, 908);
	level.iz_route[level.iz_route.size] = (-12675, 164, 908);
	level.iz_route[level.iz_route.size] = (-12812, 458, 908);
	level.iz_route[level.iz_route.size] = (-12866, 840, 908);
	level.iz_route[level.iz_route.size] = (-12782, 1193, 908);
	level.iz_route[level.iz_route.size] = (-12363, 1731, 908);
	level.iz_route[level.iz_route.size] = (-10387, 3717, 908);
	level.iz_route[level.iz_route.size] = (-10037, 4098, 908);
	level.iz_route[level.iz_route.size] = (-9726, 4334, 908);
	level.iz_route[level.iz_route.size] = (-9293, 4553, 908);
	level.iz_route[level.iz_route.size] = (-8649, 4655, 908);
	level.iz_route[level.iz_route.size] = (-3722, 4715, 908);
	level.iz_route[level.iz_route.size] = (-3192, 4723, 908);
	level.iz_route[level.iz_route.size] = (-2807, 4920, 908);
	level.iz_route[level.iz_route.size] = (-2533, 5261, 908);
	level.iz_route[level.iz_route.size] = (-2466, 5616, 908);
	level.iz_route[level.iz_route.size] = (-2450, 6337, 908);
	level.iz_route[level.iz_route.size] = (-2435, 9110, 908);
	level.iz_route[level.iz_route.size] = (-2428, 10505, 908);
	level.iz_route[level.iz_route.size] = (-2533, 10960, 908);
	level.iz_route[level.iz_route.size] = (-2731, 11230, 908);
	level.iz_route[level.iz_route.size] = (-3013, 11423, 908);
	level.iz_route[level.iz_route.size] = (-3467, 11529, 908);
	level.iz_route[level.iz_route.size] = (-4129, 11482, 908);
	level.iz_route[level.iz_route.size] = (-4795, 11300, 908);
	level.iz_route[level.iz_route.size] = (-5934, 10674, 908);
	level.iz_route[level.iz_route.size] = (-6414, 10476, 908);
	level.iz_route[level.iz_route.size] = (-7064, 10309, 908);
	level.iz_route[level.iz_route.size] = (-7857, 10317, 908);
	level.iz_route[level.iz_route.size] = (-9021, 10326, 908);
	level.iz_route[level.iz_route.size] = (-9626, 10292, 908);
	level.iz_route[level.iz_route.size] = (-9987, 10154, 908);
	level.iz_route[level.iz_route.size] = (-10249, 9844, 908);
	level.iz_route[level.iz_route.size] = (-10359, 9316, 908);
	level.iz_route[level.iz_route.size] = (-10361, 8636, 908);
	level.iz_route[level.iz_route.size] = (-10288, 8292, 908);
	level.iz_route[level.iz_route.size] = (-10093, 8034, 908);
	level.iz_route[level.iz_route.size] = (-9744, 7880, 908);
	level.iz_route[level.iz_route.size] = (-9175, 7798, 908);
	level.iz_route[level.iz_route.size] = (-7905, 7786, 908);
	level.iz_route[level.iz_route.size] = (-6815, 7781, 908);
	level.iz_route[level.iz_route.size] = (-5726, 7806, 908);
	level.iz_route[level.iz_route.size] = (-4874, 7782, 908);
	level.iz_route[level.iz_route.size] = (-4298, 7782, 1033);
	level.iz_route[level.iz_route.size] = (-3604, 7800, 1166);
	level.iz_route[level.iz_route.size] = (-2723, 7784, 1166);
	level.iz_route[level.iz_route.size] = (-1288, 7769, 1166);
	level.iz_route[level.iz_route.size] = (-725, 7784, 908);
	level.iz_route[level.iz_route.size] = (-178, 7769, 908);
	level.iz_route[level.iz_route.size] = (355, 7829, 908);
	level.iz_route[level.iz_route.size] = (799, 8051, 908);
	level.iz_route[level.iz_route.size] = (1036, 8376, 908);
	level.iz_route[level.iz_route.size] = (1110, 8835, 908);
	level.iz_route[level.iz_route.size] = (1095, 10256, 908);
	level.iz_route[level.iz_route.size] = (1125, 10774, 908);
	level.iz_route[level.iz_route.size] = (1243, 11025, 908);
	level.iz_route[level.iz_route.size] = (1539, 11351, 908);
	level.iz_route[level.iz_route.size] = (1820, 11469, 908);
	level.iz_route[level.iz_route.size] = (2146, 11513, 908);
	level.iz_route[level.iz_route.size] = (2501, 11513, 908);
	level.iz_route[level.iz_route.size] = (2989, 11567, 908);
	level.iz_route[level.iz_route.size] = (4484, 11543, 908);
	level.iz_route[level.iz_route.size] = (5786, 11543, 908);
	level.iz_route[level.iz_route.size] = (6186, 11454, 908);
	level.iz_route[level.iz_route.size] = (6689, 11144, 908);
	level.iz_route[level.iz_route.size] = (7399, 10389, 908);
	level.iz_route[level.iz_route.size] = (7562, 10078, 908);
	level.iz_route[level.iz_route.size] = (7636, 9530, 908);
	level.iz_route[level.iz_route.size] = (7621, 9012, 908);
	level.iz_route[level.iz_route.size] = (7488, 8687, 908);
	level.iz_route[level.iz_route.size] = (7148, 8391, 908);
	level.iz_route[level.iz_route.size] = (6748, 8273, 908);
	level.iz_route[level.iz_route.size] = (6053, 8258, 908);
	level.iz_route[level.iz_route.size] = (4854, 8243, 908);
	level.iz_route[level.iz_route.size] = (3612, 8238, 908);
	level.iz_route[level.iz_route.size] = (3240, 8122, 908);
	level.iz_route[level.iz_route.size] = (2899, 7964, 908);
	level.iz_route[level.iz_route.size] = (2703, 7524, 908);
	level.iz_route[level.iz_route.size] = (2701, 6701, 908);
	level.iz_route[level.iz_route.size] = (2719, 5652, 908);
	level.iz_route[level.iz_route.size] = (2728, 5040, 908);
	level.iz_route[level.iz_route.size] = (2746, 4543, 908);
	level.iz_route[level.iz_route.size] = (2739, 4136, 908);
	level.iz_route[level.iz_route.size] = (2872, 3759, 908);
	level.iz_route[level.iz_route.size] = (3071, 3492, 908);
	level.iz_route[level.iz_route.size] = (3441, 3196, 908);
	level.iz_route[level.iz_route.size] = (3611, 2989, 908);
	level.iz_route[level.iz_route.size] = (3929, 2523, 908);
	level.iz_route[level.iz_route.size] = (4010, 2076, 908);
	level.iz_route[level.iz_route.size] = (4010, 1399, 908);
	level.iz_route[level.iz_route.size] = (4014, 627, 908);
	level.iz_route[level.iz_route.size] = (4001, -209, 908);
	level.iz_route[level.iz_route.size] = (3982, -1024, 908);
	level.iz_route[level.iz_route.size] = (3993, -1568, 908);
	level.iz_route[level.iz_route.size] = (3993, -2436, 908);
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
	points[0] = (20375.6309, 4818.7007, 5138.7007);
	angles[0] = (0, 71.1273, 0);
	at[0] = 0;
	points[1] = (20375.6309, 4818.7007, 5138.7007);
	angles[1] = (0, 71.1273, 0);
	at[1] = 0.1333;
	points[2] = (20195.7090, 4879.2124, 5279.5669);
	angles[2] = (0, 71.4574, 0);
	at[2] = 0.2667;
	points[3] = (19829.7637, 5009.6064, 5553.2285);
	angles[3] = (0, 68.3165, 0);
	at[3] = 0.4000;
	points[4] = (19447.0078, 5170.2754, 5797.8745);
	angles[4] = (0, 64.8827, 0);
	at[4] = 0.5333;
	points[5] = (19059.6074, 5374.7246, 6002.1260);
	angles[5] = (0, 61.9243, 0);
	at[5] = 0.6667;
	points[6] = (18645.4336, 5573.4253, 6158.0708);
	angles[6] = (0, 66.8727, 0);
	at[6] = 0.8000;
	points[7] = (18204.4492, 5758.4648, 6264.0552);
	angles[7] = (0, 67.4563, 0);
	at[7] = 0.9333;
	points[8] = (17764.2520, 5936.8110, 6383.9766);
	angles[8] = (0, 68.2327, 0);
	at[8] = 1.0667;
	points[9] = (17322.8340, 6119.0947, 6503.7007);
	angles[9] = (0, 65.7213, 0);
	at[9] = 1.2000;
	points[10] = (16880.9453, 6320.2759, 6604.4097);
	angles[10] = (0, 66.2506, 0);
	at[10] = 1.3333;
	points[11] = (16433.2285, 6497.9531, 6717.1265);
	angles[11] = (0, 68.1846, 0);
	at[11] = 1.4667;
	points[12] = (15991.6934, 6709.0942, 6801.4961);
	angles[12] = (0, 62.3867, 0);
	at[12] = 1.6000;
	points[13] = (15554.4092, 6937.0474, 6866.9292);
	angles[13] = (0, 63.5513, 0);
	at[13] = 1.7333;
	points[14] = (15104.6855, 7154.8428, 6912.9531);
	angles[14] = (0, 64.7711, 0);
	at[14] = 1.8667;
	points[15] = (14647.5195, 7351.6143, 6954.3306);
	angles[15] = (0, 67.5617, 0);
	at[15] = 2;
	points[16] = (14186.9287, 7545.3936, 6980.1182);
	angles[16] = (0, 66.0362, 0);
	at[16] = 2.1333;
	points[17] = (13727.9922, 7750.5122, 6960.9448);
	angles[17] = (0, 66.3915, 0);
	at[17] = 2.2667;
	points[18] = (13268.0312, 7943.6616, 6935.9453);
	angles[18] = (0, 67.7021, 0);
	at[18] = 2.4000;
	points[19] = (12802.5986, 8125.7876, 6923.1499);
	angles[19] = (0, 68.9330, 0);
	at[19] = 2.5333;
	points[20] = (12337.5195, 8304.4102, 6895.5513);
	angles[20] = (0, 69.2545, 0);
	at[20] = 2.6667;
	points[21] = (11878.8975, 8486.1025, 6819.4492);
	angles[21] = (0, 65.2041, 0);
	at[21] = 2.8000;
	points[22] = (11431.0234, 8699.3701, 6753.9370);
	angles[22] = (0, 64.8397, 0);
	at[22] = 2.9333;
	points[23] = (10972.0869, 8879.4482, 6700);
	angles[23] = (0, 70.5532, 0);
	at[23] = 3.0667;
	points[24] = (10515.3936, 9054.7637, 6622.2441);
	angles[24] = (0, 65.7524, 0);
	at[24] = 3.2000;
	points[25] = (10083.1104, 9246.2598, 6475.5903);
	angles[25] = (0, 66.7736, 0);
	at[25] = 3.3333;
	points[26] = (9669.8428, 9449.0547, 6304.4883);
	angles[26] = (0, 73.8190, 0);
	at[26] = 3.4667;
	points[27] = (9234.2910, 9613.6221, 6161.9688);
	angles[27] = (0, 60.3486, 0);
	at[27] = 3.6000;
	points[28] = (8849.6465, 9796.1025, 5936.3779);
	angles[28] = (0, 70.7293, 0);
	at[28] = 3.7333;
	points[29] = (8447.0469, 9935.3145, 5706.4565);
	angles[29] = (0, 70, 0);
	at[29] = 3.8667;
	points[30] = (8067.2832, 10100.1182, 5464.8428);
	angles[30] = (0, 69.9114, 0);
	at[30] = 4;
	points[31] = (7680.0396, 10249.6064, 5231.2207);
	angles[31] = (0, 71.6303, 0);
	at[31] = 4.1333;
	points[32] = (7348.3462, 10342.2041, 4911.0234);
	angles[32] = (0, 69.6951, 0);
	at[32] = 4.2667;
	points[33] = (7045.9058, 10452.8350, 4577.4014);
	angles[33] = (0, 70.5829, 0);
	at[33] = 4.4000;
	points[34] = (6761.8896, 10549.4482, 4227.6382);
	angles[34] = (0, 68.8822, 0);
	at[34] = 4.5333;
	points[35] = (6460.9448, 10668.5049, 3908.8896);
	angles[35] = (0, 68.1123, 0);
	at[35] = 4.6667;
	points[36] = (6112.0474, 10807.6777, 3656.7087);
	angles[36] = (0, 68.7274, 0);
	at[36] = 4.8000;
	points[37] = (5768.0708, 10929.1738, 3400.8582);
	angles[37] = (0, 70.9716, 0);
	at[37] = 4.9333;
	points[38] = (5430.0786, 11057.0869, 3148.4331);
	angles[38] = (0, 65.3147, 0);
	at[38] = 5.0667;
	points[39] = (5095.1182, 11215.7480, 2913.5591);
	angles[39] = (0, 64.8015, 0);
	at[39] = 5.2000;
	points[40] = (4879.0947, 11308.3066, 2563.7520);
	angles[40] = (0, 70.2447, 0);
	at[40] = 5.3333;
	points[41] = (4747.9922, 11353.5439, 2156.3662);
	angles[41] = (0, 71.4005, 0);
	at[41] = 5.4667;
	points[42] = (4628.1890, 11393.4258, 1754.6890);
	angles[42] = (0, 71.7462, 0);
	at[42] = 5.6000;
	points[43] = (4512.4805, 11431.4570, 1358.2993);
	angles[43] = (0, 71.8052, 0);
	at[43] = 5.7333;
	points[44] = (4397.4805, 11469.5273, 969.2756);
	angles[44] = (0, 71.4348, 0);
	at[44] = 5.8667;
	points[45] = (4397.4805, 11469.5273, 969.2756);
	angles[45] = (0, 71.4348, 0);
	at[45] = 7.2167;
	points[46] = (20375.6309, 4818.7007, 5138.7007);
	angles[46] = (0, 71.1273, 0);
	at[46] = 7.2167;
	points[47] = (20375.6309, 4818.7007, 5138.7007);
	angles[47] = (0, 71.1273, 0);
	at[47] = 30;
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
	points[0] = (20375.6309, 4818.7007, 5138.7007);
	angles[0] = (0, 71.1273, 0);
	at[0] = 0;
	points[1] = (20375.6309, 4818.7007, 5138.7007);
	angles[1] = (0, 71.1273, 0);
	at[1] = 15.2000;
	points[2] = (20013.9766, 4940.8267, 5420.9839);
	angles[2] = (0, 70.9167, 0);
	at[2] = 15.3333;
	points[3] = (19639.5273, 5086.9287, 5678.3462);
	angles[3] = (0, 67.4387, 0);
	at[3] = 15.4667;
	points[4] = (19255.2363, 5269.8428, 5901.8115);
	angles[4] = (0, 61.8355, 0);
	at[4] = 15.6000;
	points[5] = (18858.7793, 5478.9370, 6095.1182);
	angles[5] = (0, 64.0075, 0);
	at[5] = 15.7333;
	points[6] = (18425.5918, 5666.2603, 6211.7324);
	angles[6] = (0, 67.2676, 0);
	at[6] = 15.8667;
	points[7] = (17984.9609, 5848.5430, 6321.4570);
	angles[7] = (0, 68.0900, 0);
	at[7] = 16;
	points[8] = (17542.4805, 6025.7480, 6446.7319);
	angles[8] = (0, 67.9816, 0);
	at[8] = 16.1333;
	points[9] = (17102.5586, 6219.7246, 6554.0947);
	angles[9] = (0, 65.3549, 0);
	at[9] = 16.2667;
	points[10] = (16658.7402, 6409.6064, 6660.1187);
	angles[10] = (0, 68.7671, 0);
	at[10] = 16.4000;
	points[11] = (16211.8506, 6595.5508, 6765.0786);
	angles[11] = (0, 63.3548, 0);
	at[11] = 16.5333;
	points[12] = (15772.4414, 6824.2129, 6835.5513);
	angles[12] = (0, 62.2931, 0);
	at[12] = 16.6667;
	points[13] = (15330, 7046.9292, 6891.2207);
	angles[13] = (0, 64.1491, 0);
	at[13] = 16.8000;
	points[14] = (14877.9131, 7255.8662, 6933.7402);
	angles[14] = (0, 67.1942, 0);
	at[14] = 16.9333;
	points[15] = (14415.8662, 7447.3232, 6973.1494);
	angles[15] = (0, 67.4768, 0);
	at[15] = 17.0667;
	points[16] = (13957.8740, 7647.9526, 6971.8896);
	angles[16] = (0, 65.8238, 0);
	at[16] = 17.2000;
	points[17] = (13499.5273, 7847.4805, 6948.7793);
	angles[17] = (0, 67.2442, 0);
	at[17] = 17.3333;
	points[18] = (13037.3623, 8035.1182, 6928.1890);
	angles[18] = (0, 68.8025, 0);
	at[18] = 17.4667;
	points[19] = (12569.2920, 8215.5908, 6916.6147);
	angles[19] = (0, 68.9499, 0);
	at[19] = 17.6000;
	points[20] = (12105.8271, 8392.6768, 6856.9292);
	angles[20] = (0, 68.8778, 0);
	at[20] = 17.7333;
	points[21] = (11655.1572, 8592.4414, 6786.3779);
	angles[21] = (0, 64.3541, 0);
	at[21] = 17.8667;
	points[22] = (11205.8262, 8795.5117, 6724.7642);
	angles[22] = (0, 69.6220, 0);
	at[22] = 18;
	points[23] = (10737.7949, 8962.5195, 6673.3071);
	angles[23] = (0, 70.0896, 0);
	at[23] = 18.1333;
	points[24] = (10298.1104, 9153.7012, 6552.0869);
	angles[24] = (0, 65.8866, 0);
	at[24] = 18.2667;
	points[25] = (9871.8506, 9342.9922, 6394.0552);
	angles[25] = (0, 60.6679, 0);
	at[25] = 18.4000;
	points[26] = (9444.1738, 9506.0234, 6223.7798);
	angles[26] = (0, 73.0146, 0);
	at[26] = 18.5333;
	points[27] = (9039.0156, 9717.7959, 6065.7090);
	angles[27] = (0, 64.4072, 0);
	at[27] = 18.6667;
	points[28] = (8644.7246, 9866.7324, 5828.6616);
	angles[28] = (0, 70.8156, 0);
	at[28] = 18.8000;
	points[29] = (8260.9453, 10019.1729, 5579.2915);
	angles[29] = (0, 64.3901, 0);
	at[29] = 18.9333;
	points[30] = (7868.3467, 10174.9609, 5357.2832);
	angles[30] = (0, 67.7963, 0);
	at[30] = 19.0667;
	points[31] = (7518.6616, 10288.3076, 5062.8740);
	angles[31] = (0, 77.1041, 0);
	at[31] = 19.2000;
	points[32] = (7178.2280, 10405.4336, 4764.3701);
	angles[32] = (0, 70.1230, 0);
	at[32] = 19.3333;
	points[33] = (6905.1182, 10499.4492, 4400.2363);
	angles[33] = (0, 71.9285, 0);
	at[33] = 19.4667;
	points[34] = (6619.5278, 10605.3945, 4057.2441);
	angles[34] = (0, 68.3878, 0);
	at[34] = 19.6000;
	points[35] = (6287.0078, 10738.3467, 3781.9529);
	angles[35] = (0, 68.1845, 0);
	at[35] = 19.7333;
	points[36] = (5941.0630, 10869.6455, 3530.1653);
	angles[36] = (0, 70.9533, 0);
	at[36] = 19.8667;
	points[37] = (5597.7954, 10988.8984, 3272.1338);
	angles[37] = (0, 70.1499, 0);
	at[37] = 20;
	points[38] = (5257.7954, 11138.3867, 3037.9568);
	angles[38] = (0, 64.4848, 0);
	at[38] = 20.1333;
	points[39] = (4959.4883, 11277.4805, 2755.5432);
	angles[39] = (0, 67.0377, 0);
	at[39] = 20.2667;
	points[40] = (4811.1421, 11332.0859, 2359.3188);
	angles[40] = (0, 71.0246, 0);
	at[40] = 20.4000;
	points[41] = (4687.3623, 11373.8184, 1954.9763);
	angles[41] = (0, 71.6180, 0);
	at[41] = 20.5333;
	points[42] = (4570, 11412.5596, 1555.6693);
	angles[42] = (0, 71.8083, 0);
	at[42] = 20.6667;
	points[43] = (4455.1968, 11450.3154, 1162.7599);
	angles[43] = (0, 71.7133, 0);
	at[43] = 20.8000;
	points[44] = (4397.4805, 11469.5273, 969.2756);
	angles[44] = (0, 71.4348, 0);
	at[44] = 20.9333;
	points[45] = (4397.4805, 11469.5273, 969.2756);
	angles[45] = (0, 71.4348, 0);
	at[45] = 22.2167;
	points[46] = (20375.6309, 4818.7007, 5138.7007);
	angles[46] = (0, 71.1273, 0);
	at[46] = 22.2167;
	points[47] = (20375.6309, 4818.7007, 5138.7007);
	angles[47] = (0, 71.1273, 0);
	at[47] = 30;
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
	points[0] = (20383.6621, 4528.3071, 5135.7090);
	angles[0] = (0, 99.8446, 0);
	at[0] = 0;
	points[1] = (20337.8730, 4520.3545, 5171.0234);
	angles[1] = (0, 99.8515, 0);
	at[1] = 0.1333;
	points[2] = (19957.6777, 4454.6064, 5445.5903);
	angles[2] = (0, 99.5538, 0);
	at[2] = 0.2667;
	points[3] = (19533.2676, 4380.7876, 5652.9922);
	angles[3] = (0, 101.6489, 0);
	at[3] = 0.4000;
	points[4] = (19112.9922, 4288.0708, 5874.2915);
	angles[4] = (0, 102.1478, 0);
	at[4] = 0.5333;
	points[5] = (18666.5762, 4197.0869, 6040.6304);
	angles[5] = (0, 100.8582, 0);
	at[5] = 0.6667;
	points[6] = (18206.5371, 4141.7715, 6190.7480);
	angles[6] = (0, 94.7834, 0);
	at[6] = 0.8000;
	points[7] = (17743.0312, 4092.1655, 6341.1421);
	angles[7] = (0, 97.3967, 0);
	at[7] = 0.9333;
	points[8] = (17272.8359, 4036.4961, 6475.3154);
	angles[8] = (0, 95.6572, 0);
	at[8] = 1.0667;
	points[9] = (16790.4336, 3985.2756, 6569.3701);
	angles[9] = (0, 96.6970, 0);
	at[9] = 1.2000;
	points[10] = (16305.5898, 3926.3977, 6649.8818);
	angles[10] = (0, 97.1496, 0);
	at[10] = 1.3333;
	points[11] = (15813.7402, 3861.5510, 6712.8740);
	angles[11] = (0, 98.7545, 0);
	at[11] = 1.4667;
	points[12] = (15328.5830, 3761.2480, 6751.1421);
	angles[12] = (0, 100.4916, 0);
	at[12] = 1.6000;
	points[13] = (14837.1660, 3705.3503, 6781.1025);
	angles[13] = (0, 95.2642, 0);
	at[13] = 1.7333;
	points[14] = (14337.7949, 3661.7952, 6802.0474);
	angles[14] = (0, 95.9148, 0);
	at[14] = 1.8667;
	points[15] = (13846.5352, 3583.0278, 6828.3071);
	angles[15] = (0, 100.2395, 0);
	at[15] = 2;
	points[16] = (13360.0400, 3472.4646, 6841.2207);
	angles[16] = (0, 104.2950, 0);
	at[16] = 2.1333;
	points[17] = (12870.1182, 3379.2834, 6825.5513);
	angles[17] = (0, 97.8728, 0);
	at[17] = 2.2667;
	points[18] = (12375.5908, 3319.3149, 6797.2441);
	angles[18] = (0, 95.9731, 0);
	at[18] = 2.4000;
	points[19] = (11883.1104, 3263.7126, 6748.5039);
	angles[19] = (0, 97.2693, 0);
	at[19] = 2.5333;
	points[20] = (11400.1973, 3197.5825, 6648.1499);
	angles[20] = (0, 98.7475, 0);
	at[20] = 2.6667;
	points[21] = (10930.0781, 3124.6970, 6510.2363);
	angles[21] = (0, 98.8253, 0);
	at[21] = 2.8000;
	points[22] = (10481.6543, 3059.9412, 6316.8115);
	angles[22] = (0, 95.3365, 0);
	at[22] = 2.9333;
	points[23] = (10020.7480, 3029.1301, 6143.8975);
	angles[23] = (0, 93.5987, 0);
	at[23] = 3.0667;
	points[24] = (9567.7168, 2996.9133, 5968.2285);
	angles[24] = (0, 94.1714, 0);
	at[24] = 3.2000;
	points[25] = (8668.4248, 2927.3308, 5615.7090);
	angles[25] = (0, 94.3018, 0);
	at[25] = 3.4667;
	points[26] = (8218.9766, 2903.7954, 5457.4800);
	angles[26] = (0, 92.0137, 0);
	at[26] = 3.6000;
	points[27] = (7765.5122, 2886.2324, 5303.2280);
	angles[27] = (0, 92.9357, 0);
	at[27] = 3.7333;
	points[28] = (7359.7642, 2839.7402, 5069.0947);
	angles[28] = (0, 98.4458, 0);
	at[28] = 3.8667;
	points[29] = (6978.3467, 2782.9292, 4796.3779);
	angles[29] = (0, 97.7590, 0);
	at[29] = 4;
	points[30] = (6619.4092, 2741.9607, 4507.0474);
	angles[30] = (0, 96.2153, 0);
	at[30] = 4.1333;
	points[31] = (6267.0474, 2703.1499, 4209.3306);
	angles[31] = (0, 96.5449, 0);
	at[31] = 4.2667;
	points[32] = (5933.3467, 2657.8149, 3906.2480);
	angles[32] = (0, 98.3087, 0);
	at[32] = 4.4000;
	points[33] = (5612.2051, 2610.8779, 3592.1299);
	angles[33] = (0, 98.1478, 0);
	at[33] = 4.5333;
	points[34] = (5364.1733, 2580.7441, 3228.9253);
	angles[34] = (0, 96.0209, 0);
	at[34] = 4.6667;
	points[35] = (5154.3306, 2558.7166, 2844.0195);
	angles[35] = (0, 96.1807, 0);
	at[35] = 4.8000;
	points[36] = (4932.8345, 2531.8269, 2478.0237);
	angles[36] = (0, 97.2508, 0);
	at[36] = 4.9333;
	points[37] = (4702.9922, 2502.0198, 2119.5984);
	angles[37] = (0, 97.5565, 0);
	at[37] = 5.0667;
	points[38] = (4480.3545, 2470.9805, 1767.3229);
	angles[38] = (0, 98.7322, 0);
	at[38] = 5.2000;
	points[39] = (4285.5903, 2429.4685, 1408.0789);
	angles[39] = (0, 104.0438, 0);
	at[39] = 5.3333;
	points[40] = (4105.6299, 2383.0156, 1048.5945);
	angles[40] = (0, 104.5516, 0);
	at[40] = 5.4667;
	points[41] = (4060.6692, 2371.4487, 958.8740);
	angles[41] = (0, 104.2196, 0);
	at[41] = 5.6000;
	points[42] = (4060.6692, 2371.4487, 958.8740);
	angles[42] = (0, 104.2196, 0);
	at[42] = 6.8500;
	points[43] = (20383.6621, 4528.3071, 5135.7090);
	angles[43] = (0, 99.8446, 0);
	at[43] = 6.8500;
	points[44] = (20383.6621, 4528.3071, 5135.7090);
	angles[44] = (0, 99.8446, 0);
	at[44] = 30;
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
	points[0] = (20383.6621, 4528.3071, 5135.7090);
	angles[0] = (0, 99.8446, 0);
	at[0] = 0;
	points[1] = (20383.6621, 4528.3071, 5135.7090);
	angles[1] = (0, 99.8446, 0);
	at[1] = 15.0667;
	points[2] = (20152.4414, 4488.1499, 5315.7871);
	angles[2] = (0, 99.8474, 0);
	at[2] = 15.2000;
	points[3] = (19744.8438, 4418.7402, 5550.1577);
	angles[3] = (0, 99.6636, 0);
	at[3] = 15.3333;
	points[4] = (19323.9766, 4334.9214, 5765.1572);
	angles[4] = (0, 102.6183, 0);
	at[4] = 15.4667;
	points[5] = (18892.5996, 4242.2832, 5960.6694);
	angles[5] = (0, 101.5930, 0);
	at[5] = 15.6000;
	points[6] = (18438.8574, 4162.4014, 6117.3623);
	angles[6] = (0, 95.7115, 0);
	at[6] = 15.7333;
	points[7] = (17974.7637, 4121.1812, 6263.7798);
	angles[7] = (0, 96.3589, 0);
	at[7] = 15.8667;
	points[8] = (17509.6855, 4062.0081, 6417.4805);
	angles[8] = (0, 97.1607, 0);
	at[8] = 16;
	points[9] = (17030.8281, 4012.4805, 6523.8579);
	angles[9] = (0, 95.8457, 0);
	at[9] = 16.1333;
	points[10] = (16547.4004, 3956.3779, 6613.1108);
	angles[10] = (0, 96.8867, 0);
	at[10] = 16.2667;
	points[11] = (16060, 3895.1655, 6682.3232);
	angles[11] = (0, 97.3837, 0);
	at[11] = 16.4000;
	points[12] = (15572.7559, 3813.0159, 6733.7007);
	angles[12] = (0, 102.3128, 0);
	at[12] = 16.5333;
	points[13] = (15083.0703, 3730.2598, 6767.0474);
	angles[13] = (0, 96.0811, 0);
	at[13] = 16.6667;
	points[14] = (14587.3633, 3684.2798, 6791.6929);
	angles[14] = (0, 94.7864, 0);
	at[14] = 16.8000;
	points[15] = (14092.9531, 3625.9685, 6814.7241);
	angles[15] = (0, 99.5114, 0);
	at[15] = 16.9333;
	points[16] = (13603.0713, 3533.9880, 6838.0708);
	angles[16] = (0, 103.6491, 0);
	at[16] = 17.0667;
	points[17] = (13117.6377, 3416.1814, 6839.6064);
	angles[17] = (0, 99.7293, 0);
	at[17] = 17.2000;
	points[18] = (12622.2051, 3346.4097, 6809.6851);
	angles[18] = (0, 97.1728, 0);
	at[18] = 17.3333;
	points[19] = (12126.5752, 3293.1655, 6782.6382);
	angles[19] = (0, 96.1617, 0);
	at[19] = 17.4667;
	points[20] = (11639.1738, 3231.9805, 6702.5591);
	angles[20] = (0, 97.5767, 0);
	at[20] = 17.6000;
	points[21] = (11161.9297, 3160.5237, 6585.4722);
	angles[21] = (0, 98.8734, 0);
	at[21] = 17.7333;
	points[22] = (10704.6846, 3090.0237, 6412.7949);
	angles[22] = (0, 98.5381, 0);
	at[22] = 17.8667;
	points[23] = (10251.1025, 3043.3821, 6229.6851);
	angles[23] = (0, 93.6228, 0);
	at[23] = 18;
	points[24] = (9794.2910, 3013.3425, 6056.7324);
	angles[24] = (0, 94.1231, 0);
	at[24] = 18.1333;
	points[25] = (9341.2207, 2980.2400, 5879.6851);
	angles[25] = (0, 94.2815, 0);
	at[25] = 18.2667;
	points[26] = (8893.2686, 2944.7559, 5703.5430);
	angles[26] = (0, 94.5183, 0);
	at[26] = 18.4000;
	points[27] = (8446.6934, 2912.6182, 5532.3623);
	angles[27] = (0, 92.6914, 0);
	at[27] = 18.5333;
	points[28] = (7991.2598, 2895.7361, 5382.8745);
	angles[28] = (0, 92.1119, 0);
	at[28] = 18.6667;
	points[29] = (7556.7319, 2867.5984, 5198.7793);
	angles[29] = (0, 97.4073, 0);
	at[29] = 18.8000;
	points[30] = (7167.5591, 2810.7520, 4934.4487);
	angles[30] = (0, 98.6131, 0);
	at[30] = 18.9333;
	points[31] = (6798.8979, 2761.6694, 4654.8032);
	angles[31] = (0, 96.3596, 0);
	at[31] = 19.0667;
	points[32] = (6442.0864, 2722.6377, 4358.5825);
	angles[32] = (0, 96.2462, 0);
	at[32] = 19.2000;
	points[33] = (6100.3545, 2681.8464, 4060.4727);
	angles[33] = (0, 97.9891, 0);
	at[33] = 19.3333;
	points[34] = (5770.5903, 2633.9448, 3751.4016);
	angles[34] = (0, 98.3521, 0);
	at[34] = 19.4667;
	points[35] = (5476.5356, 2593.0039, 3420.7205);
	angles[35] = (0, 96.5583, 0);
	at[35] = 19.6000;
	points[36] = (5258.3462, 2569.6970, 3035.7441);
	angles[36] = (0, 95.9434, 0);
	at[36] = 19.7333;
	points[37] = (5048.3462, 2546.3896, 2660.4175);
	angles[37] = (0, 97.1122, 0);
	at[37] = 19.8667;
	points[38] = (4817.2441, 2516.9883, 2297.7363);
	angles[38] = (0, 97.3809, 0);
	at[38] = 20;
	points[39] = (4590.0396, 2486.7676, 1942.5394);
	angles[39] = (0, 97.8613, 0);
	at[39] = 20.1333;
	points[40] = (4379.5273, 2451.9409, 1589.7401);
	angles[40] = (0, 102.6368, 0);
	at[40] = 20.2667;
	points[41] = (4194.8818, 2406.2717, 1227.6260);
	angles[41] = (0, 104.5602, 0);
	at[41] = 20.4000;
	points[42] = (4060.6692, 2371.4487, 958.8740);
	angles[42] = (0, 104.2196, 0);
	at[42] = 20.5333;
	points[43] = (4060.6692, 2371.4487, 958.8740);
	angles[43] = (0, 104.2196, 0);
	at[43] = 21.8500;
	points[44] = (20383.6621, 4528.3071, 5135.7090);
	angles[44] = (0, 99.8446, 0);
	at[44] = 21.8500;
	points[45] = (20383.6621, 4528.3071, 5135.7090);
	angles[45] = (0, 99.8446, 0);
	at[45] = 30;
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
	points[0] = (3012.3584, -22510.5898, 5140.5518);
	angles[0] = (0, -6.5137, 0);
	at[0] = 0;
	points[1] = (3012.3584, -22510.5898, 5140.5518);
	angles[1] = (0, -6.5137, 0);
	at[1] = 0.1333;
	points[2] = (3055.2166, -22142.9141, 5325.9453);
	angles[2] = (0, -6.2044, 0);
	at[2] = 0.2667;
	points[3] = (3088.3032, -21710.3164, 5519.1733);
	angles[3] = (0, -3.9462, 0);
	at[3] = 0.4000;
	points[4] = (3126.2678, -21271.2207, 5698.1890);
	angles[4] = (0, -5.7467, 0);
	at[4] = 0.5333;
	points[5] = (3179.8857, -20820.9453, 5844.9609);
	angles[5] = (0, -8.5559, 0);
	at[5] = 0.6667;
	points[6] = (3248.9961, -20357.0879, 5943.3862);
	angles[6] = (0, -6.8758, 0);
	at[6] = 0.8000;
	points[7] = (3293.0081, -19892.2051, 6057.9526);
	angles[7] = (0, -4.8450, 0);
	at[7] = 0.9333;
	points[8] = (3328.2285, -19420.4336, 6145.9844);
	angles[8] = (0, -4.1076, 0);
	at[8] = 1.0667;
	points[9] = (3362.7561, -18949.6465, 6239.4883);
	angles[9] = (0, -4.2433, 0);
	at[9] = 1.2000;
	points[10] = (3398.3503, -18479.3711, 6340.1182);
	angles[10] = (0, -4.4971, 0);
	at[10] = 1.3333;
	points[11] = (3431.9568, -18005.6289, 6428.1890);
	angles[11] = (0, -3.0105, 0);
	at[11] = 1.4667;
	points[12] = (3455.6536, -17525.9453, 6489.2129);
	angles[12] = (0, -2.7313, 0);
	at[12] = 1.6000;
	points[13] = (3478.1614, -17052.1250, 6596.0239);
	angles[13] = (0, -2.7837, 0);
	at[13] = 1.7333;
	points[14] = (3503.3149, -16576.1816, 6687.4409);
	angles[14] = (0, -2.8694, 0);
	at[14] = 1.8667;
	points[15] = (3509.3779, -16094.4102, 6746.3779);
	angles[15] = (0, 1.0505, 0);
	at[15] = 2;
	points[16] = (3510.2480, -15609.0156, 6779.5273);
	angles[16] = (0, -1.2552, 0);
	at[16] = 2.1333;
	points[17] = (3528.9094, -15122.6377, 6798.3462);
	angles[17] = (0, -3.5519, 0);
	at[17] = 2.2667;
	points[18] = (3559.5789, -14637.0078, 6791.1025);
	angles[18] = (0, -3.0762, 0);
	at[18] = 2.4000;
	points[19] = (3582.1260, -14150.6299, 6749.0161);
	angles[19] = (0, -2.6992, 0);
	at[19] = 2.5333;
	points[20] = (3607.0354, -13667.9521, 6694.9609);
	angles[20] = (0, -3.1320, 0);
	at[20] = 2.6667;
	points[21] = (3645.1575, -13195.3535, 6595.3936);
	angles[21] = (0, -6.0973, 0);
	at[21] = 2.8000;
	points[22] = (3688.2915, -12729.8428, 6468.3467);
	angles[22] = (0, -4.0091, 0);
	at[22] = 2.9333;
	points[23] = (3717.0591, -12265.2754, 6342.1260);
	angles[23] = (0, -2.3589, 0);
	at[23] = 3.0667;
	points[24] = (3733.4094, -11829.9219, 6128.2285);
	angles[24] = (0, -2.4580, 0);
	at[24] = 3.2000;
	points[25] = (3765.1260, -11367.6777, 6005.9448);
	angles[25] = (0, -4.2402, 0);
	at[25] = 3.3333;
	points[26] = (3776.4172, -10931.1816, 5824.4487);
	angles[26] = (0, 0.6658, 0);
	at[26] = 3.4667;
	points[27] = (3777.6772, -10589.3701, 5490.2759);
	angles[27] = (0, -1.8378, 0);
	at[27] = 3.6000;
	points[28] = (3801.9175, -10224.3311, 5189.2129);
	angles[28] = (0, -4.6145, 0);
	at[28] = 3.7333;
	points[29] = (3824.7795, -9840.0391, 4915.9053);
	angles[29] = (0, -3.0528, 0);
	at[29] = 3.8667;
	points[30] = (3840.1653, -9541.2207, 4557.7163);
	angles[30] = (0, -4.2038, 0);
	at[30] = 4;
	points[31] = (3869.0984, -9162.6768, 4287.4019);
	angles[31] = (0, -1.3387, 0);
	at[31] = 4.1333;
	points[32] = (3871.2795, -8814.6064, 3978.0315);
	angles[32] = (0, -1.6312, 0);
	at[32] = 4.2667;
	points[33] = (3909.3860, -8504.1729, 3640.4172);
	angles[33] = (0, -8.2212, 0);
	at[33] = 4.4000;
	points[34] = (3941.4172, -8235.1973, 3273.2244);
	angles[34] = (0, -6.1643, 0);
	at[34] = 4.5333;
	points[35] = (3966.1416, -8005, 2882.1694);
	angles[35] = (0, -6.1647, 0);
	at[35] = 4.6667;
	points[36] = (3980.1970, -7877.1655, 2455.7756);
	angles[36] = (0, -6.3185, 0);
	at[36] = 4.8000;
	points[37] = (3991.5750, -7774.6855, 2019.3427);
	angles[37] = (0, -6.3307, 0);
	at[37] = 4.9333;
	points[38] = (4002.4019, -7677.0469, 1586.2560);
	angles[38] = (0, -6.3346, 0);
	at[38] = 5.0667;
	points[39] = (4013.0708, -7580.9053, 1157.0669);
	angles[39] = (0, -6.3329, 0);
	at[39] = 5.2000;
	points[40] = (4017.1262, -7544.4883, 997.2008);
	angles[40] = (0, -6.3293, 0);
	at[40] = 5.3333;
	points[41] = (4017.1262, -7544.4883, 997.2008);
	angles[41] = (0, -6.3293, 0);
	at[41] = 6.6000;
	points[42] = (3012.3584, -22510.5898, 5140.5518);
	angles[42] = (0, -6.5137, 0);
	at[42] = 6.6000;
	points[43] = (3012.3584, -22510.5898, 5140.5518);
	angles[43] = (0, -6.5137, 0);
	at[43] = 30;
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
	points[0] = (3012.3584, -22510.5898, 5140.5518);
	angles[0] = (0, -6.5137, 0);
	at[0] = 0;
	points[1] = (3012.3584, -22510.5898, 5140.5518);
	angles[1] = (0, -6.5137, 0);
	at[1] = 15.0667;
	points[2] = (3030.8779, -22353.5840, 5220.0786);
	angles[2] = (0, -6.7762, 0);
	at[2] = 15.2000;
	points[3] = (3073.3269, -21928.2285, 5424.3706);
	angles[3] = (0, -4.0086, 0);
	at[3] = 15.3333;
	points[4] = (3104.7561, -21493.0723, 5610.5513);
	angles[4] = (0, -5.2251, 0);
	at[4] = 15.4667;
	points[5] = (3149.6262, -21048.0703, 5781.8501);
	angles[5] = (0, -6.3044, 0);
	at[5] = 15.6000;
	points[6] = (3215.3503, -20588.6211, 5894.4487);
	angles[6] = (0, -8.6800, 0);
	at[6] = 15.7333;
	points[7] = (3272.4329, -20124.8418, 6000.9448);
	angles[7] = (0, -5.2734, 0);
	at[7] = 15.8667;
	points[8] = (3311.0867, -19657.7168, 6103.5435);
	angles[8] = (0, -4.1805, 0);
	at[8] = 16;
	points[9] = (3345.2678, -19185.7480, 6190.0396);
	angles[9] = (0, -4.2291, 0);
	at[9] = 16.1333;
	points[10] = (3416.7520, -18242.6777, 6390.9053);
	angles[10] = (0, -4.3295, 0);
	at[10] = 16.4000;
	points[11] = (3444.0750, -17764.3301, 6452.4409);
	angles[11] = (0, -2.7980, 0);
	at[11] = 16.5333;
	points[12] = (3466.8582, -17289.4883, 6542.6377);
	angles[12] = (0, -2.7077, 0);
	at[12] = 16.6667;
	points[13] = (3490.7126, -16815.8652, 6642.4014);
	angles[13] = (0, -3.0919, 0);
	at[13] = 16.8000;
	points[14] = (3512.2874, -16337.0869, 6726.1812);
	angles[14] = (0, -0.2058, 0);
	at[14] = 16.9333;
	points[15] = (3506.0825, -15851.7324, 6762.5591);
	angles[15] = (0, -0.4020, 0);
	at[15] = 17.0667;
	points[16] = (3516.6104, -15364.7246, 6794.4097);
	angles[16] = (0, -1.8363, 0);
	at[16] = 17.2000;
	points[17] = (3544.4727, -14879.1338, 6796.5356);
	angles[17] = (0, -3.6987, 0);
	at[17] = 17.3333;
	points[18] = (3571.0947, -14393.7793, 6772.3228);
	angles[18] = (0, -2.5791, 0);
	at[18] = 17.4667;
	points[19] = (3594.2520, -13910.1973, 6723.1499);
	angles[19] = (0, -2.9426, 0);
	at[19] = 17.6000;
	points[20] = (3621.6772, -13429.6064, 6660);
	angles[20] = (0, -4.7321, 0);
	at[20] = 17.7333;
	points[21] = (3669.7244, -12962.9531, 6525.3149);
	angles[21] = (0, -5.7179, 0);
	at[21] = 17.8667;
	points[22] = (3704.1853, -12493.4258, 6414.8032);
	angles[22] = (0, -3.6882, 0);
	at[22] = 18;
	points[23] = (3747.7048, -11602.1260, 6058.1104);
	angles[23] = (0, -4.1840, 0);
	at[23] = 18.2667;
	points[24] = (3780.0317, -11136.4570, 5946.4565);
	angles[24] = (0, -1.1865, 0);
	at[24] = 18.4000;
	points[25] = (3774.1970, -10755, 5661.6138);
	angles[25] = (0, 0.2753, 0);
	at[25] = 18.5333;
	points[26] = (3786.2324, -10416.6543, 5328.3071);
	angles[26] = (0, -4.4433, 0);
	at[26] = 18.6667;
	points[27] = (3814.4292, -10031.3779, 5054.4883);
	angles[27] = (0, -3.1750, 0);
	at[27] = 18.8000;
	points[28] = (3832.1182, -9689.9209, 4736.6143);
	angles[28] = (0, -2.7365, 0);
	at[28] = 18.9333;
	points[29] = (3856.0669, -9350.6699, 4421.6929);
	angles[29] = (0, -4.7822, 0);
	at[29] = 19.0667;
	points[30] = (3869.9211, -8986.3779, 4134.4883);
	angles[30] = (0, 0.0060, 0);
	at[30] = 19.2000;
	points[31] = (3887.4922, -8656.0244, 3812.9568);
	angles[31] = (0, -7.8989, 0);
	at[31] = 19.3333;
	points[32] = (3926.9487, -8367.4805, 3460.2678);
	angles[32] = (0, -6.3769, 0);
	at[32] = 19.4667;
	points[33] = (3954.6851, -8111.9292, 3081.8071);
	angles[33] = (0, -6.1214, 0);
	at[33] = 19.6000;
	points[34] = (3974.0945, -7932.4019, 2671.4094);
	angles[34] = (0, -6.3009, 0);
	at[34] = 19.7333;
	points[35] = (3985.9844, -7824.9604, 2237.1812);
	angles[35] = (0, -6.3264, 0);
	at[35] = 19.8667;
	points[36] = (3997.0081, -7725.5117, 1802.3583);
	angles[36] = (0, -6.3333, 0);
	at[36] = 20;
	points[37] = (4007.7559, -7628.9766, 1371.1497);
	angles[37] = (0, -6.3346, 0);
	at[37] = 20.1333;
	points[38] = (4017.1262, -7544.4883, 997.2008);
	angles[38] = (0, -6.3293, 0);
	at[38] = 20.2667;
	points[39] = (4017.1262, -7544.4883, 997.2008);
	angles[39] = (0, -6.3293, 0);
	at[39] = 21.6000;
	points[40] = (3012.3584, -22510.5898, 5140.5518);
	angles[40] = (0, -6.5137, 0);
	at[40] = 21.6000;
	points[41] = (3012.3584, -22510.5898, 5140.5518);
	angles[41] = (0, -6.5137, 0);
	at[41] = 30;
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
	points[0] = (2560.4250, -22424.9219, 5139.1733);
	angles[0] = (0, 18.3756, 0);
	at[0] = 0;
	points[1] = (2560.4250, -22424.9219, 5139.1733);
	angles[1] = (0, 18.3756, 0);
	at[1] = 0.1333;
	points[2] = (2526.1418, -22321.8105, 5182.0078);
	angles[2] = (0, 18.3945, 0);
	at[2] = 0.2667;
	points[3] = (2112.5630, -21065.1992, 5703.0708);
	angles[3] = (0, 18.0152, 0);
	at[3] = 0.6667;
	points[4] = (1980.2482, -20656.8516, 5914.8428);
	angles[4] = (0, 18.0568, 0);
	at[4] = 0.8000;
	points[5] = (1834.9056, -20234.6855, 6077.7163);
	angles[5] = (0, 19.7817, 0);
	at[5] = 0.9333;
	points[6] = (1681.4763, -19799.3320, 6198.9370);
	angles[6] = (0, 17.5218, 0);
	at[6] = 1.0667;
	points[7] = (1553.6141, -19357.0469, 6339.0947);
	angles[7] = (0, 16.0011, 0);
	at[7] = 1.2000;
	points[8] = (1411.8228, -18937.3633, 6519.8818);
	angles[8] = (0, 20.8792, 0);
	at[8] = 1.3333;
	points[9] = (1259.4409, -18515.4727, 6683.8584);
	angles[9] = (0, 17.7884, 0);
	at[9] = 1.4667;
	points[10] = (1111.7875, -18058.2285, 6748.1499);
	angles[10] = (0, 19.2354, 0);
	at[10] = 1.6000;
	points[11] = (936.2835, -17620.1172, 6842.8345);
	angles[11] = (0, 22.0627, 0);
	at[11] = 1.7333;
	points[12] = (770.5040, -17176.0625, 6931.8901);
	angles[12] = (0, 19.7823, 0);
	at[12] = 1.8667;
	points[13] = (620.4803, -16724.1738, 7009.7642);
	angles[13] = (0, 15.5374, 0);
	at[13] = 2;
	points[14] = (494.3071, -16260.8662, 7067.8345);
	angles[14] = (0, 16.1570, 0);
	at[14] = 2.1333;
	points[15] = (357.1807, -15796.8115, 7113.4648);
	angles[15] = (0, 17.1660, 0);
	at[15] = 2.2667;
	points[16] = (184.5650, -15346.7324, 7150.3149);
	angles[16] = (0, 23.2119, 0);
	at[16] = 2.4000;
	points[17] = (-1.4080, -14900.7881, 7181.1421);
	angles[17] = (0, 21.0999, 0);
	at[17] = 2.5333;
	points[18] = (-175.9618, -14447.0469, 7206.7319);
	angles[18] = (0, 21.4135, 0);
	at[18] = 2.6667;
	points[19] = (-367.3362, -14002.5977, 7202.5986);
	angles[19] = (0, 24.0503, 0);
	at[19] = 2.8000;
	points[20] = (-567.1614, -13561.4961, 7189.6064);
	angles[20] = (0, 24.7724, 0);
	at[20] = 2.9333;
	points[21] = (-771.9055, -13123.2676, 7176.9297);
	angles[21] = (0, 25.9436, 0);
	at[21] = 3.0667;
	points[22] = (-990.6536, -12688.4639, 7158.7402);
	angles[22] = (0, 26.3248, 0);
	at[22] = 3.2000;
	points[23] = (-1180.6063, -12246.8506, 7109.1733);
	angles[23] = (0, 21.7304, 0);
	at[23] = 3.3333;
	points[24] = (-1356.9528, -11801.6533, 7038.9370);
	angles[24] = (0, 21.4206, 0);
	at[24] = 3.4667;
	points[25] = (-1540.0315, -11364.8027, 6941.3384);
	angles[25] = (0, 27.2937, 0);
	at[25] = 3.6000;
	points[26] = (-1746.0670, -10955.3936, 6805.7090);
	angles[26] = (0, 24.9622, 0);
	at[26] = 3.7333;
	points[27] = (-1897.0236, -10560.1182, 6575.8657);
	angles[27] = (0, 16.1432, 0);
	at[27] = 3.8667;
	points[28] = (-2025.9529, -10158.5039, 6347.8350);
	angles[28] = (0, 21.8737, 0);
	at[28] = 4;
	points[29] = (-2180.9409, -9778.3076, 6097.6382);
	angles[29] = (0, 21.5035, 0);
	at[29] = 4.1333;
	points[30] = (-2310.6458, -9395.1572, 5843.6616);
	angles[30] = (0, 18.1257, 0);
	at[30] = 4.2667;
	points[31] = (-2434.5867, -9051.9688, 5539.8032);
	angles[31] = (0, 20.9770, 0);
	at[31] = 4.4000;
	points[32] = (-2553.3308, -8725.0391, 5218.6616);
	angles[32] = (0, 18.3083, 0);
	at[32] = 4.5333;
	points[33] = (-2664.9526, -8384.9219, 4907.3232);
	angles[33] = (0, 18.3957, 0);
	at[33] = 4.6667;
	points[34] = (-2765.2600, -8091.0234, 4556.0234);
	angles[34] = (0, 19.0079, 0);
	at[34] = 4.8000;
	points[35] = (-2862.4883, -7815.4331, 4191.9683);
	angles[35] = (0, 20.1088, 0);
	at[35] = 4.9333;
	points[36] = (-2958.4565, -7555.6299, 3815.7048);
	angles[36] = (0, 20.3976, 0);
	at[36] = 5.0667;
	points[37] = (-3058.0237, -7293.1890, 3447.9490);
	angles[37] = (0, 21.1807, 0);
	at[37] = 5.2000;
	points[38] = (-3161.3267, -7025.7090, 3085.6692);
	angles[38] = (0, 20.9115, 0);
	at[38] = 5.3333;
	points[39] = (-3262.1812, -6737.6768, 2745.2676);
	angles[39] = (0, 17.6716, 0);
	at[39] = 5.4667;
	points[40] = (-3353.2598, -6443.6616, 2408.4055);
	angles[40] = (0, 16.6721, 0);
	at[40] = 5.6000;
	points[41] = (-3397.0474, -6287.1655, 1986.5828);
	angles[41] = (0, 14.9861, 0);
	at[41] = 5.7333;
	points[42] = (-3463.5156, -6035.3149, 1120.7008);
	angles[42] = (0, 14.7567, 0);
	at[42] = 6;
	points[43] = (-3476.0039, -5988.0708, 959.2047);
	angles[43] = (0, 14.8802, 0);
	at[43] = 6.1333;
	points[44] = (-3476.0039, -5988.0708, 959.2047);
	angles[44] = (0, 14.8802, 0);
	at[44] = 7.4000;
	points[45] = (2560.4250, -22424.9219, 5139.1733);
	angles[45] = (0, 18.3756, 0);
	at[45] = 7.4000;
	points[46] = (2560.4250, -22424.9219, 5139.1733);
	angles[46] = (0, 18.3756, 0);
	at[46] = 30;
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
	points[0] = (2560.4250, -22424.9219, 5139.1733);
	angles[0] = (0, 18.3756, 0);
	at[0] = 0;
	points[1] = (2560.4250, -22424.9219, 5139.1733);
	angles[1] = (0, 18.3756, 0);
	at[1] = 15.2000;
	points[2] = (2456.3701, -22112.0098, 5269.1733);
	angles[2] = (0, 18.3964, 0);
	at[2] = 15.3333;
	points[3] = (2180.0396, -21272.4805, 5614.3701);
	angles[3] = (0, 18.0240, 0);
	at[3] = 15.6000;
	points[4] = (2046.3622, -20860.6289, 5808.2285);
	angles[4] = (0, 17.9249, 0);
	at[4] = 15.7333;
	points[5] = (1912.4332, -20452.2832, 6010.9844);
	angles[5] = (0, 19.1052, 0);
	at[5] = 15.8667;
	points[6] = (1756.3779, -20015.8672, 6137.9531);
	angles[6] = (0, 19.6236, 0);
	at[6] = 16;
	points[7] = (1616.5237, -19578.0332, 6267.9922);
	angles[7] = (0, 15.9117, 0);
	at[7] = 16.1333;
	points[8] = (1487.7716, -19141.2988, 6417.3228);
	angles[8] = (0, 19.4137, 0);
	at[8] = 16.2667;
	points[9] = (1334.1852, -18733.5039, 6621.7715);
	angles[9] = (0, 20.5626, 0);
	at[9] = 16.4000;
	points[10] = (1186.6024, -18286.9297, 6716.5747);
	angles[10] = (0, 17.7015, 0);
	at[10] = 16.5333;
	points[11] = (1025.9922, -17839.5664, 6793.8979);
	angles[11] = (0, 22.1965, 0);
	at[11] = 16.6667;
	points[12] = (851.8503, -17399.9609, 6888.3857);
	angles[12] = (0, 20.1630, 0);
	at[12] = 16.8000;
	points[13] = (690.7244, -16950.9062, 6974.1733);
	angles[13] = (0, 19.0923, 0);
	at[13] = 16.9333;
	points[14] = (557.4134, -16491.6934, 7040);
	angles[14] = (0, 15.0163, 0);
	at[14] = 17.0667;
	points[15] = (426.6890, -16028.5039, 7091.4170);
	angles[15] = (0, 16.3851, 0);
	at[15] = 17.2000;
	points[16] = (278.8421, -15570.7490, 7133.2285);
	angles[16] = (0, 22.0618, 0);
	at[16] = 17.3333;
	points[17] = (88.9965, -15124.2520, 7166.4565);
	angles[17] = (0, 23.1091, 0);
	at[17] = 17.4667;
	points[18] = (-88.3531, -14674.0557, 7194.8423);
	angles[18] = (0, 20.9556, 0);
	at[18] = 17.6000;
	points[19] = (-268.6638, -14225.4326, 7208.5830);
	angles[19] = (0, 23.6507, 0);
	at[19] = 17.7333;
	points[20] = (-466.6457, -13781.2998, 7195.4727);
	angles[20] = (0, 24.2905, 0);
	at[20] = 17.8667;
	points[21] = (-669.4567, -13340.8662, 7183.7012);
	angles[21] = (0, 24.9764, 0);
	at[21] = 18;
	points[22] = (-881.3386, -12905.6689, 7168.7798);
	angles[22] = (0, 26.9037, 0);
	at[22] = 18.1333;
	points[23] = (-1090.0157, -12471.1416, 7139.5273);
	angles[23] = (0, 22.4528, 0);
	at[23] = 18.2667;
	points[24] = (-1269.5000, -12022.5586, 7076.5747);
	angles[24] = (0, 21.5526, 0);
	at[24] = 18.4000;
	points[25] = (-1443.5669, -11580.7480, 6986.7324);
	angles[25] = (0, 21.6680, 0);
	at[25] = 18.5333;
	points[26] = (-1651.2756, -11152.5586, 6903.8188);
	angles[26] = (0, 27.3148, 0);
	at[26] = 18.6667;
	points[27] = (-1831.8464, -10763.2676, 6686.8110);
	angles[27] = (0, 22.3006, 0);
	at[27] = 18.8000;
	points[28] = (-1956.8110, -10354.1738, 6465.1973);
	angles[28] = (0, 16.6543, 0);
	at[28] = 18.9333;
	points[29] = (-2103.9766, -9967.5195, 6223.0317);
	angles[29] = (0, 22.3607, 0);
	at[29] = 19.0667;
	points[30] = (-2247.7913, -9587.2832, 5971.9688);
	angles[30] = (0, 18.2563, 0);
	at[30] = 19.2000;
	points[31] = (-2372.4685, -9215.1182, 5703.3857);
	angles[31] = (0, 20.4914, 0);
	at[31] = 19.3333;
	points[32] = (-2495.7876, -8891.1426, 5374.4878);
	angles[32] = (0, 20.4775, 0);
	at[32] = 19.4667;
	points[33] = (-2609.6653, -8553.3857, 5065);
	angles[33] = (0, 18.1022, 0);
	at[33] = 19.6000;
	points[34] = (-2715.6812, -8235.5117, 4735);
	angles[34] = (0, 18.8763, 0);
	at[34] = 19.7333;
	points[35] = (-2814.5315, -7948.8584, 4374.7241);
	angles[35] = (0, 19.2852, 0);
	at[35] = 19.8667;
	points[36] = (-2910.4883, -7685.0396, 4003.6614);
	angles[36] = (0, 20.2847, 0);
	at[36] = 20;
	points[37] = (-3006.6655, -7426.6143, 3631.1772);
	angles[37] = (0, 20.7017, 0);
	at[37] = 20.1333;
	points[38] = (-3109.7559, -7159.6851, 3266.2952);
	angles[38] = (0, 21.1482, 0);
	at[38] = 20.2667;
	points[39] = (-3212.0354, -6889.9609, 2906.7678);
	angles[39] = (0, 19.4612, 0);
	at[39] = 20.4000;
	points[40] = (-3311.1377, -6581.6143, 2584.6653);
	angles[40] = (0, 17.1958, 0);
	at[40] = 20.5333;
	points[41] = (-3378.2522, -6356.6138, 2204.1851);
	angles[41] = (0, 15.3671, 0);
	at[41] = 20.6667;
	points[42] = (-3414.2559, -6222.4800, 1770.2599);
	angles[42] = (0, 14.8232, 0);
	at[42] = 20.8000;
	points[43] = (-3447.1299, -6097.6382, 1337.7440);
	angles[43] = (0, 14.7167, 0);
	at[43] = 20.9333;
	points[44] = (-3476.0039, -5988.0708, 959.2047);
	angles[44] = (0, 14.8802, 0);
	at[44] = 21.0667;
	points[45] = (-3476.0039, -5988.0708, 959.2047);
	angles[45] = (0, 14.8802, 0);
	at[45] = 22.4000;
	points[46] = (2560.4250, -22424.9219, 5139.1733);
	angles[46] = (0, 18.3756, 0);
	at[46] = 22.4000;
	points[47] = (2560.4250, -22424.9219, 5139.1733);
	angles[47] = (0, 18.3756, 0);
	at[47] = 30;
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
	points[0] = (-23284.7246, -4007.4412, 5142.7954);
	angles[0] = (0, -80.8683, 0);
	at[0] = 0;
	points[1] = (-23241.0254, -4000.4724, 5181.5747);
	angles[1] = (0, -81.0322, 0);
	at[1] = 0.1333;
	points[2] = (-22886.9688, -3944.5671, 5495.0786);
	angles[2] = (0, -80.6919, 0);
	at[2] = 0.2667;
	points[3] = (-22542.4414, -3877.4685, 5822.8345);
	angles[3] = (0, -78.1488, 0);
	at[3] = 0.4000;
	points[4] = (-22187.0488, -3805.4607, 6147.9531);
	angles[4] = (0, -80.2432, 0);
	at[4] = 0.5333;
	points[5] = (-21764.0547, -3738.1379, 6395.5513);
	angles[5] = (0, -81.1294, 0);
	at[5] = 0.6667;
	points[6] = (-21329.5664, -3668.1262, 6628.9370);
	angles[6] = (0, -80.8513, 0);
	at[6] = 0.8000;
	points[7] = (-20875.4336, -3599.6143, 6831.4961);
	angles[7] = (0, -81.7486, 0);
	at[7] = 0.9333;
	points[8] = (-20404.2148, -3530.4961, 7001.1025);
	angles[8] = (0, -81.5569, 0);
	at[8] = 1.0667;
	points[9] = (-19924.6055, -3456.6494, 7155.4331);
	angles[9] = (0, -80.8387, 0);
	at[9] = 1.2000;
	points[10] = (-19444.2129, -3373.2246, 7310.8662);
	angles[10] = (0, -77.6502, 0);
	at[10] = 1.3333;
	points[11] = (-18957.0078, -3259.8267, 7438.6221);
	angles[11] = (0, -77.2438, 0);
	at[11] = 1.4667;
	points[12] = (-18454.6074, -3165.2676, 7502.5195);
	angles[12] = (0, -80.1721, 0);
	at[12] = 1.6000;
	points[13] = (-17944.5273, -3091.8071, 7548.6221);
	angles[13] = (0, -82.7786, 0);
	at[13] = 1.7333;
	points[14] = (-17432.4414, -3029.4526, 7598.5039);
	angles[14] = (0, -83.6404, 0);
	at[14] = 1.8667;
	points[15] = (-16921.4570, -2958.9844, 7651.2207);
	angles[15] = (0, -78.6877, 0);
	at[15] = 2;
	points[16] = (-16409.1328, -2855.8857, 7676.4961);
	angles[16] = (0, -80.0895, 0);
	at[16] = 2.1333;
	points[17] = (-15894.4092, -2791.3818, 7671.8506);
	angles[17] = (0, -83.4325, 0);
	at[17] = 2.2667;
	points[18] = (-15377.2842, -2729.6025, 7663.4644);
	angles[18] = (0, -82.7133, 0);
	at[18] = 2.4000;
	points[19] = (-14869.7637, -2618.1851, 7654.7241);
	angles[19] = (0, -75.2419, 0);
	at[19] = 2.5333;
	points[20] = (-14356.2988, -2540.6379, 7645.4331);
	angles[20] = (0, -84.9664, 0);
	at[20] = 2.6667;
	points[21] = (-13836.8896, -2510.4055, 7632.1260);
	angles[21] = (0, -86.1926, 0);
	at[21] = 2.8000;
	points[22] = (-13332.7568, -2444.9094, 7538.0317);
	angles[22] = (0, -84.6884, 0);
	at[22] = 2.9333;
	points[23] = (-12828.6221, -2387.5156, 7437.0078);
	angles[23] = (0, -80.8381, 0);
	at[23] = 3.0667;
	points[24] = (-12331.7715, -2293.1418, 7337.6382);
	angles[24] = (0, -77.5925, 0);
	at[24] = 3.2000;
	points[25] = (-11877.7959, -2209.5828, 7114.8818);
	angles[25] = (0, -79.7199, 0);
	at[25] = 3.3333;
	points[26] = (-11422.0869, -2125.8425, 6908.7402);
	angles[26] = (0, -81.5808, 0);
	at[26] = 3.4667;
	points[27] = (-10962.1650, -2043.4685, 6720.1577);
	angles[27] = (0, -76.3600, 0);
	at[27] = 3.6000;
	points[28] = (-10537.7158, -1923.4646, 6481.8110);
	angles[28] = (0, -70.9457, 0);
	at[28] = 3.7333;
	points[29] = (-10119.8828, -1819.1653, 6237.8345);
	angles[29] = (0, -82.5741, 0);
	at[29] = 3.8667;
	points[30] = (-9698.9365, -1750.8032, 5993.8188);
	angles[30] = (0, -79.3860, 0);
	at[30] = 4;
	points[31] = (-9371.8896, -1677.3071, 5656.8506);
	angles[31] = (0, -74.3029, 0);
	at[31] = 4.1333;
	points[32] = (-9147.2842, -1613.9174, 5234.8823);
	angles[32] = (0, -75.1553, 0);
	at[32] = 4.2667;
	points[33] = (-8933.8584, -1561.0789, 4819.3701);
	angles[33] = (0, -76.3282, 0);
	at[33] = 4.4000;
	points[34] = (-8730.9453, -1511.8031, 4407.8740);
	angles[34] = (0, -76.3582, 0);
	at[34] = 4.5333;
	points[35] = (-8524.8027, -1462.6653, 4004.0552);
	angles[35] = (0, -76.5689, 0);
	at[35] = 4.6667;
	points[36] = (-8345.4727, -1419.0591, 3596.5513);
	angles[36] = (0, -75.8771, 0);
	at[36] = 4.8000;
	points[37] = (-8244.4492, -1391.0354, 3179.4922);
	angles[37] = (0, -72.5200, 0);
	at[37] = 4.9333;
	points[38] = (-8181.4175, -1370.4882, 2752.5120);
	angles[38] = (0, -71.5315, 0);
	at[38] = 5.0667;
	points[39] = (-8125.5117, -1351.5826, 2336.4292);
	angles[39] = (0, -71.1455, 0);
	at[39] = 5.2000;
	points[40] = (-8072.7954, -1333.4803, 1929.0040);
	angles[40] = (0, -70.9723, 0);
	at[40] = 5.3333;
	points[41] = (-8021.8896, -1315.8937, 1530);
	angles[41] = (0, -70.9479, 0);
	at[41] = 5.4667;
	points[42] = (-7972.1655, -1298.7836, 1143.8622);
	angles[42] = (0, -71.1265, 0);
	at[42] = 5.6000;
	points[43] = (-7946.5352, -1290.0906, 951.4016);
	angles[43] = (0, -71.3995, 0);
	at[43] = 5.7333;
	points[44] = (-7946.5352, -1290.0906, 951.4016);
	angles[44] = (0, -71.3995, 0);
	at[44] = 7.0167;
	points[45] = (-23284.7246, -4007.4412, 5142.7954);
	angles[45] = (0, -80.8683, 0);
	at[45] = 7.0167;
	points[46] = (-23284.7246, -4007.4412, 5142.7954);
	angles[46] = (0, -80.8683, 0);
	at[46] = 30;
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
	points[0] = (-23284.7246, -4007.4412, 5142.7954);
	angles[0] = (0, -80.8683, 0);
	at[0] = 0;
	points[1] = (-23284.7246, -4007.4412, 5142.7954);
	angles[1] = (0, -80.8683, 0);
	at[1] = 15.0667;
	points[2] = (-23064.6445, -3972.8743, 5337.4019);
	angles[2] = (0, -81.0883, 0);
	at[2] = 15.2000;
	points[3] = (-22714.1348, -3913.1418, 5654.8818);
	angles[3] = (0, -78.5146, 0);
	at[3] = 15.3333;
	points[4] = (-22369.2910, -3841.2283, 5990.1572);
	angles[4] = (0, -78.2768, 0);
	at[4] = 15.4667;
	points[5] = (-21978.6230, -3771.6494, 6275.6299);
	angles[5] = (0, -81.0475, 0);
	at[5] = 15.6000;
	points[6] = (-21548.5430, -3703.5945, 6513.3462);
	angles[6] = (0, -80.7777, 0);
	at[6] = 15.7333;
	points[7] = (-21107.4023, -3633.4568, 6736.0630);
	angles[7] = (0, -81.5891, 0);
	at[7] = 15.8667;
	points[8] = (-20641.1816, -3565.5513, 6922.7559);
	angles[8] = (0, -81.6178, 0);
	at[8] = 16;
	points[9] = (-20163.4258, -3494.4214, 7077.0474);
	angles[9] = (0, -81.3457, 0);
	at[9] = 16.1333;
	points[10] = (-19684.4102, -3417.2322, 7235.5513);
	angles[10] = (0, -80.4646, 0);
	at[10] = 16.2667;
	points[11] = (-19202.0469, -3317.1575, 7377.0083);
	angles[11] = (0, -76.7024, 0);
	at[11] = 16.4000;
	points[12] = (-18708.5820, -3210.6025, 7477.0479);
	angles[12] = (0, -79.5941, 0);
	at[12] = 16.5333;
	points[13] = (-18201.8906, -3125.2559, 7526.1421);
	angles[13] = (0, -82.2658, 0);
	at[13] = 16.6667;
	points[14] = (-17687.0879, -3059.5591, 7571.1812);
	angles[14] = (0, -82.9151, 0);
	at[14] = 16.8000;
	points[15] = (-17175.4336, -2999.9766, 7629.3701);
	angles[15] = (0, -83.0174, 0);
	at[15] = 16.9333;
	points[16] = (-16665.8652, -2906.5789, 7665.4331);
	angles[16] = (0, -78.3661, 0);
	at[16] = 17.0667;
	points[17] = (-16153.4648, -2821.6143, 7676.0630);
	angles[17] = (0, -83.1572, 0);
	at[17] = 17.2000;
	points[18] = (-15636.1416, -2760.8545, 7667.5591);
	angles[18] = (0, -83.2705, 0);
	at[18] = 17.3333;
	points[19] = (-15122.2451, -2684.8149, 7659.2129);
	angles[19] = (0, -75.8574, 0);
	at[19] = 17.4667;
	points[20] = (-14615.6299, -2567.1970, 7650.2363);
	angles[20] = (0, -83.0776, 0);
	at[20] = 17.6000;
	points[21] = (-14097.5986, -2524.6575, 7640.2759);
	angles[21] = (0, -87.0745, 0);
	at[21] = 17.7333;
	points[22] = (-13583.5039, -2479.1101, 7592.1260);
	angles[22] = (0, -81.5687, 0);
	at[22] = 17.8667;
	points[23] = (-13080.6689, -2423.1338, 7478.7407);
	angles[23] = (0, -84.5751, 0);
	at[23] = 18;
	points[24] = (-12575.4326, -2345.0786, 7399.1733);
	angles[24] = (0, -79.7827, 0);
	at[24] = 18.1333;
	points[25] = (-12100.6689, -2248.4409, 7237.0869);
	angles[25] = (0, -80.1195, 0);
	at[25] = 18.2667;
	points[26] = (-11652.5195, -2166.3425, 7005.1973);
	angles[26] = (0, -79.0959, 0);
	at[26] = 18.4000;
	points[27] = (-11182.9922, -2090.1929, 6830.0396);
	angles[27] = (0, -80.9360, 0);
	at[27] = 18.5333;
	points[28] = (-10750.1182, -1990.0985, 6594.6455);
	angles[28] = (0, -75.2885, 0);
	at[28] = 18.6667;
	points[29] = (-10324.4092, -1852.7914, 6371.8896);
	angles[29] = (0, -74.3771, 0);
	at[29] = 18.8000;
	points[30] = (-9915.0791, -1790.1851, 6103.7007);
	angles[30] = (0, -80.0467, 0);
	at[30] = 18.9333;
	points[31] = (-9500.2764, -1711.4725, 5860.3154);
	angles[31] = (0, -76.9724, 0);
	at[31] = 19.0667;
	points[32] = (-9257.6377, -1644.8151, 5445.7876);
	angles[32] = (0, -74.0631, 0);
	at[32] = 19.2000;
	points[33] = (-9039.8428, -1586.9725, 5027.8350);
	angles[33] = (0, -76.1882, 0);
	at[33] = 19.3333;
	points[34] = (-8829.8027, -1535.8190, 4611.5356);
	angles[34] = (0, -76.3696, 0);
	at[34] = 19.4667;
	points[35] = (-8627.0869, -1487.0040, 4205.0786);
	angles[35] = (0, -76.6390, 0);
	at[35] = 19.6000;
	points[36] = (-8429.3311, -1439.7086, 3801.6458);
	angles[36] = (0, -76.3594, 0);
	at[36] = 19.7333;
	points[37] = (-8282.6377, -1402.5787, 3388.5000);
	angles[37] = (0, -74.1347, 0);
	at[37] = 19.8667;
	points[38] = (-8211.6533, -1380.4921, 2965.3386);
	angles[38] = (0, -71.8892, 0);
	at[38] = 20;
	points[39] = (-8152.6772, -1360.8268, 2541.5039);
	angles[39] = (0, -71.3002, 0);
	at[39] = 20.1333;
	points[40] = (-8098.8193, -1342.4370, 2131.3071);
	angles[40] = (0, -71.0390, 0);
	at[40] = 20.2667;
	points[41] = (-8047.2051, -1324.6495, 1728.7479);
	angles[41] = (0, -70.9413, 0);
	at[41] = 20.4000;
	points[42] = (-7997.0474, -1307.3307, 1336.0828);
	angles[42] = (0, -71.0013, 0);
	at[42] = 20.5333;
	points[43] = (-7946.5352, -1290.0906, 951.4016);
	angles[43] = (0, -71.3995, 0);
	at[43] = 20.6667;
	points[44] = (-7946.5352, -1290.0906, 951.4016);
	angles[44] = (0, -71.3995, 0);
	at[44] = 22.0167;
	points[45] = (-23284.7246, -4007.4412, 5142.7954);
	angles[45] = (0, -80.8683, 0);
	at[45] = 22.0167;
	points[46] = (-23284.7246, -4007.4412, 5142.7954);
	angles[46] = (0, -80.8683, 0);
	at[46] = 30;
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
	points[0] = (-23233.7793, -3422.8386, 5142.8740);
	angles[0] = (0, -60.3481, 0);
	at[0] = 0;
	points[1] = (-23233.7793, -3422.8386, 5142.8740);
	angles[1] = (0, -60.3481, 0);
	at[1] = 0.1333;
	points[2] = (-23098.3848, -3347.1733, 5321.1025);
	angles[2] = (0, -60.9235, 0);
	at[2] = 0.2667;
	points[3] = (-22820.4316, -3185.4133, 5675.8667);
	angles[3] = (0, -55.7706, 0);
	at[3] = 0.4000;
	points[4] = (-22517.7168, -2967.3779, 5994.3701);
	angles[4] = (0, -54.1054, 0);
	at[4] = 0.5333;
	points[5] = (-22177.2832, -2739.3779, 6272.1260);
	angles[5] = (0, -57.2724, 0);
	at[5] = 0.6667;
	points[6] = (-21786.0645, -2508.9880, 6483.8584);
	angles[6] = (0, -60.7749, 0);
	at[6] = 0.8000;
	points[7] = (-21371.6133, -2276.4685, 6659.8032);
	angles[7] = (0, -60.6134, 0);
	at[7] = 0.9333;
	points[8] = (-20950.1562, -2037.2521, 6820.8662);
	angles[8] = (0, -59.8742, 0);
	at[8] = 1.0667;
	points[9] = (-20519.8027, -1790.8938, 6960.3940);
	angles[9] = (0, -61.2255, 0);
	at[9] = 1.2000;
	points[10] = (-20076.4570, -1563.6653, 7103.1895);
	angles[10] = (0, -64.7605, 0);
	at[10] = 1.3333;
	points[11] = (-19627.5605, -1326.2402, 7220.1187);
	angles[11] = (0, -60.2357, 0);
	at[11] = 1.4667;
	points[12] = (-19174.2910, -1073.7677, 7289.3701);
	angles[12] = (0, -61.2517, 0);
	at[12] = 1.6000;
	points[13] = (-18714.8828, -827.9449, 7353.6616);
	angles[13] = (0, -62.0615, 0);
	at[13] = 1.7333;
	points[14] = (-18255.9453, -576.7441, 7418.2285);
	angles[14] = (0, -61.0568, 0);
	at[14] = 1.8667;
	points[15] = (-17792.4023, -326.3708, 7413.3462);
	angles[15] = (0, -62.0792, 0);
	at[15] = 2;
	points[16] = (-17323.9375, -87.3673, 7396.1816);
	angles[16] = (0, -64.1492, 0);
	at[16] = 2.1333;
	points[17] = (-16846.2598, 134.5331, 7382.4019);
	angles[17] = (0, -66.8164, 0);
	at[17] = 2.2667;
	points[18] = (-16359.2920, 337.0740, 7369.6455);
	angles[18] = (0, -66.1026, 0);
	at[18] = 2.4000;
	points[19] = (-15886.6533, 558.7638, 7305.7090);
	angles[19] = (0, -62.9301, 0);
	at[19] = 2.5333;
	points[20] = (-15427.1660, 790.1812, 7201.9292);
	angles[20] = (0, -63.7908, 0);
	at[20] = 2.6667;
	points[21] = (-14967.8350, 1020.9330, 7105.2368);
	angles[21] = (0, -62.6755, 0);
	at[21] = 2.8000;
	points[22] = (-14530.9844, 1246.0237, 6945.8267);
	angles[22] = (0, -65.0740, 0);
	at[22] = 2.9333;
	points[23] = (-14108.0312, 1475.9724, 6763.9761);
	angles[23] = (0, -55.4197, 0);
	at[23] = 3.0667;
	points[24] = (-13715.4336, 1705.1692, 6536.6538);
	angles[24] = (0, -66.1841, 0);
	at[24] = 3.2000;
	points[25] = (-13400.1582, 1869.7599, 6189.8428);
	angles[25] = (0, -58.2705, 0);
	at[25] = 3.3333;
	points[26] = (-13075.0791, 2018.4449, 5848.3467);
	angles[26] = (0, -68.2101, 0);
	at[26] = 3.4667;
	points[27] = (-12745.1191, 2165.4724, 5524.1733);
	angles[27] = (0, -61.0392, 0);
	at[27] = 3.6000;
	points[28] = (-12472.5195, 2313.9607, 5159.8423);
	angles[28] = (0, -64.1343, 0);
	at[28] = 3.7333;
	points[29] = (-12166.8506, 2462.0906, 4835.7876);
	angles[29] = (0, -61.6689, 0);
	at[29] = 3.8667;
	points[30] = (-11874.3701, 2627.1968, 4515.0786);
	angles[30] = (0, -60.4697, 0);
	at[30] = 4;
	points[31] = (-11585.9062, 2785.4133, 4212.6377);
	angles[31] = (0, -61.5617, 0);
	at[31] = 4.1333;
	points[32] = (-11493.7793, 2834.7205, 3790.1379);
	angles[32] = (0, -62.3508, 0);
	at[32] = 4.2667;
	points[33] = (-11449.7246, 2857.6694, 3355.4019);
	angles[33] = (0, -62.5595, 0);
	at[33] = 4.4000;
	points[34] = (-11411.3779, 2877.5510, 2936.3110);
	angles[34] = (0, -62.6422, 0);
	at[34] = 4.5333;
	points[35] = (-11375.7090, 2895.9880, 2529.4607);
	angles[35] = (0, -62.6852, 0);
	at[35] = 4.6667;
	points[36] = (-11341.7715, 2913.5117, 2133.9331);
	angles[36] = (0, -62.7062, 0);
	at[36] = 4.8000;
	points[37] = (-11309.0947, 2930.3542, 1750.3228);
	angles[37] = (0, -62.7098, 0);
	at[37] = 4.9333;
	points[38] = (-11277.3232, 2946.7600, 1378.3070);
	angles[38] = (0, -62.6924, 0);
	at[38] = 5.0667;
	points[39] = (-11245.7881, 2963.0510, 1018.1221);
	angles[39] = (0, -62.6332, 0);
	at[39] = 5.2000;
	points[40] = (-11241.9678, 2965.0354, 975.6496);
	angles[40] = (0, -62.6201, 0);
	at[40] = 5.3333;
	points[41] = (-11241.9678, 2965.0354, 975.6496);
	angles[41] = (0, -62.6201, 0);
	at[41] = 6.5667;
	points[42] = (-23233.7793, -3422.8386, 5142.8740);
	angles[42] = (0, -60.3481, 0);
	at[42] = 6.5667;
	points[43] = (-23233.7793, -3422.8386, 5142.8740);
	angles[43] = (0, -60.3481, 0);
	at[43] = 30;
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
	points[0] = (-23233.7793, -3422.8386, 5142.8740);
	angles[0] = (0, -60.3481, 0);
	at[0] = 0;
	points[1] = (-23233.7793, -3422.8386, 5142.8740);
	angles[1] = (0, -60.3481, 0);
	at[1] = 15.2000;
	points[2] = (-22960.8281, -3270.0630, 5501.7324);
	angles[2] = (0, -60.3763, 0);
	at[2] = 15.3333;
	points[3] = (-22670.9453, -3078.9055, 5836.9292);
	angles[3] = (0, -53.9976, 0);
	at[3] = 15.4667;
	points[4] = (-22354.8828, -2855.1262, 6139.4092);
	angles[4] = (0, -56.5393, 0);
	at[4] = 15.6000;
	points[5] = (-21990.5898, -2624.4331, 6389.1338);
	angles[5] = (0, -60.1285, 0);
	at[5] = 15.7333;
	points[6] = (-21578.4238, -2392.9568, 6574.4097);
	angles[6] = (0, -60.6786, 0);
	at[6] = 15.8667;
	points[7] = (-21160.7480, -2157.6023, 6743.9766);
	angles[7] = (0, -60.5491, 0);
	at[7] = 16;
	points[8] = (-20735.5117, -1912.5631, 6890);
	angles[8] = (0, -59.9135, 0);
	at[8] = 16.1333;
	points[9] = (-20300.7090, -1672.3149, 7033.0317);
	angles[9] = (0, -62.1903, 0);
	at[9] = 16.2667;
	points[10] = (-19851.0234, -1452.7834, 7168.2285);
	angles[10] = (0, -61.1832, 0);
	at[10] = 16.4000;
	points[11] = (-19403.3477, -1199.8898, 7261.4565);
	angles[11] = (0, -61.0703, 0);
	at[11] = 16.5333;
	points[12] = (-18945.9062, -950.3229, 7319.6064);
	angles[12] = (0, -62.0445, 0);
	at[12] = 16.6667;
	points[13] = (-18485.5898, -703.9764, 7386.8896);
	angles[13] = (0, -61.0651, 0);
	at[13] = 16.8000;
	points[14] = (-18025.1582, -451.1220, 7423.6221);
	angles[14] = (0, -61.6646, 0);
	at[14] = 16.9333;
	points[15] = (-17558.4258, -205.4752, 7404.6851);
	angles[15] = (0, -62.9377, 0);
	at[15] = 17.0667;
	points[16] = (-17084.6465, 25.7128, 7389.0156);
	angles[16] = (0, -64.9924, 0);
	at[16] = 17.2000;
	points[17] = (-16601.6152, 235.9299, 7377.8740);
	angles[17] = (0, -67.6937, 0);
	at[17] = 17.3333;
	points[18] = (-16119.9219, 445.9370, 7345.1577);
	angles[18] = (0, -65.1992, 0);
	at[18] = 17.4667;
	points[19] = (-15657.2051, 676.5788, 7250.5117);
	angles[19] = (0, -63.1676, 0);
	at[19] = 17.6000;
	points[20] = (-15197.7568, 904.5355, 7154.2910);
	angles[20] = (0, -63.3124, 0);
	at[20] = 17.7333;
	points[21] = (-14747.4404, 1141.6654, 7041.9683);
	angles[21] = (0, -61.3463, 0);
	at[21] = 17.8667;
	points[22] = (-14316.9688, 1355.8032, 6853.1104);
	angles[22] = (0, -61.6473, 0);
	at[22] = 18;
	points[23] = (-13914.8037, 1609.0789, 6661.8901);
	angles[23] = (0, -61.4997, 0);
	at[23] = 18.1333;
	points[24] = (-13524.0947, 1786.9489, 6393.5435);
	angles[24] = (0, -59.8571, 0);
	at[24] = 18.2667;
	points[25] = (-13245.8662, 1945.1299, 6009.8818);
	angles[25] = (0, -65.3165, 0);
	at[25] = 18.4000;
	points[26] = (-12894.8037, 2091.2834, 5698.7007);
	angles[26] = (0, -67.2807, 0);
	at[26] = 18.5333;
	points[27] = (-12611.6533, 2240.2048, 5337.2441);
	angles[27] = (0, -60.7436, 0);
	at[27] = 18.6667;
	points[28] = (-12318.2285, 2387.6104, 4995.7480);
	angles[28] = (0, -64.5232, 0);
	at[28] = 18.8000;
	points[29] = (-12018.7012, 2545.0630, 4675.8267);
	angles[29] = (0, -60.3882, 0);
	at[29] = 18.9333;
	points[30] = (-11720.0791, 2712.4136, 4375.1968);
	angles[30] = (0, -61.3556, 0);
	at[30] = 19.0667;
	points[31] = (-11521.1416, 2820.2756, 4001.6143);
	angles[31] = (0, -61.9822, 0);
	at[31] = 19.2000;
	points[32] = (-11470.6299, 2846.7993, 3570.5354);
	angles[32] = (0, -62.4850, 0);
	at[32] = 19.3333;
	points[33] = (-11430.3936, 2867.7009, 3147.2283);
	angles[33] = (0, -62.6075, 0);
	at[33] = 19.4667;
	points[34] = (-11393.3857, 2886.8503, 2732.6692);
	angles[34] = (0, -62.6669, 0);
	at[34] = 19.6000;
	points[35] = (-11358.5830, 2904.8269, 2330.7441);
	angles[35] = (0, -62.6979, 0);
	at[35] = 19.7333;
	points[36] = (-11325.3545, 2921.9763, 1941.2323);
	angles[36] = (0, -62.7103, 0);
	at[36] = 19.8667;
	points[37] = (-11293.2285, 2938.5396, 1564.1851);
	angles[37] = (0, -62.7045, 0);
	at[37] = 20;
	points[38] = (-11261.9678, 2954.6931, 1201.0630);
	angles[38] = (0, -62.6718, 0);
	at[38] = 20.1333;
	points[39] = (-11241.9678, 2965.0354, 975.6496);
	angles[39] = (0, -62.6201, 0);
	at[39] = 20.2667;
	points[40] = (-11241.9678, 2965.0354, 975.6496);
	angles[40] = (0, -62.6201, 0);
	at[40] = 21.5667;
	points[41] = (-23233.7793, -3422.8386, 5142.8740);
	angles[41] = (0, -60.3481, 0);
	at[41] = 21.5667;
	points[42] = (-23233.7793, -3422.8386, 5142.8740);
	angles[42] = (0, -60.3481, 0);
	at[42] = 30;
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
	points[0] = (-5992.8350, 23561.8887, 5142.5591);
	angles[0] = (0, 167.2203, 0);
	at[0] = 0;
	points[1] = (-5992.8350, 23561.8887, 5142.5591);
	angles[1] = (0, 167.2203, 0);
	at[1] = 0.1333;
	points[2] = (-6061.2993, 23255.1172, 5413.1499);
	angles[2] = (0, 167.4354, 0);
	at[2] = 0.2667;
	points[3] = (-6143.2280, 22897.5195, 5725.3940);
	angles[3] = (0, 166.0035, 0);
	at[3] = 0.4000;
	points[4] = (-6251.2598, 22531.1016, 6022.1655);
	angles[4] = (0, 163.1212, 0);
	at[4] = 0.5333;
	points[5] = (-6359.8423, 22110.4727, 6241.6143);
	angles[5] = (0, 167.1038, 0);
	at[5] = 0.6667;
	points[6] = (-6457.2837, 21655.1172, 6406.8896);
	angles[6] = (0, 169.3169, 0);
	at[6] = 0.8000;
	points[7] = (-6564.4487, 21196.9277, 6565.9058);
	angles[7] = (0, 164.3984, 0);
	at[7] = 0.9333;
	points[8] = (-6690.5903, 20739.5664, 6722.9131);
	angles[8] = (0, 165.1050, 0);
	at[8] = 1.0667;
	points[9] = (-6788.4648, 20272.9531, 6879.5278);
	angles[9] = (0, 171.4091, 0);
	at[9] = 1.2000;
	points[10] = (-6875.1187, 19786.0234, 6985.0791);
	angles[10] = (0, 168.7648, 0);
	at[10] = 1.3333;
	points[11] = (-6979.9609, 19308.0703, 7112.6772);
	angles[11] = (0, 169.4332, 0);
	at[11] = 1.4667;
	points[12] = (-7076.0630, 18886.7324, 7359.6855);
	angles[12] = (0, 163.0910, 0);
	at[12] = 1.6000;
	points[13] = (-7192.0078, 18393.8965, 7443.9375);
	angles[13] = (0, 168.3803, 0);
	at[13] = 1.7333;
	points[14] = (-7319.8032, 17905, 7546.9292);
	angles[14] = (0, 162.0929, 0);
	at[14] = 1.8667;
	points[15] = (-7435.5117, 17403.6621, 7537.4805);
	angles[15] = (0, 170.2742, 0);
	at[15] = 2;
	points[16] = (-7521.5752, 16893.8594, 7518.0708);
	angles[16] = (0, 168.5297, 0);
	at[16] = 2.1333;
	points[17] = (-7640.8267, 16404.7246, 7413.8193);
	angles[17] = (0, 167.8931, 0);
	at[17] = 2.2667;
	points[18] = (-7741.6934, 15915.9844, 7288.3462);
	angles[18] = (0, 166.8986, 0);
	at[18] = 2.4000;
	points[19] = (-7855.7090, 15430.7090, 7176.8110);
	angles[19] = (0, 167.2047, 0);
	at[19] = 2.5333;
	points[20] = (-7969.8818, 14968.6621, 6995.1968);
	angles[20] = (0, 164.2444, 0);
	at[20] = 2.6667;
	points[21] = (-8082.5986, 14514.1738, 6803.4644);
	angles[21] = (0, 168.1792, 0);
	at[21] = 2.8000;
	points[22] = (-8160.9448, 14114.3311, 6520.5122);
	angles[22] = (0, 169.5995, 0);
	at[22] = 2.9333;
	points[23] = (-8242.0479, 13749.9609, 6193.7012);
	angles[23] = (0, 165.8185, 0);
	at[23] = 3.0667;
	points[24] = (-8339.2520, 13410.3535, 5853.9761);
	angles[24] = (0, 163.6509, 0);
	at[24] = 3.2000;
	points[25] = (-8425.5518, 13095.4326, 5497.1655);
	angles[25] = (0, 165.3267, 0);
	at[25] = 3.3333;
	points[26] = (-8499.4092, 12793.0312, 5136.8901);
	angles[26] = (0, 167.8456, 0);
	at[26] = 3.4667;
	points[27] = (-8561.5352, 12492.6768, 4778.9766);
	angles[27] = (0, 168.8206, 0);
	at[27] = 3.6000;
	points[28] = (-8617.9922, 12167.8340, 4454.5669);
	angles[28] = (0, 170.7231, 0);
	at[28] = 3.7333;
	points[29] = (-8672.2051, 11833.7402, 4143.7793);
	angles[29] = (0, 170.7304, 0);
	at[29] = 3.8667;
	points[30] = (-8726.8506, 11499.8818, 3849.2007);
	angles[30] = (0, 170.6671, 0);
	at[30] = 4;
	points[31] = (-8775.0391, 11220.4727, 3512.1338);
	angles[31] = (0, 169.1870, 0);
	at[31] = 4.1333;
	points[32] = (-8813.4248, 11021.4570, 3123.4490);
	angles[32] = (0, 169.1805, 0);
	at[32] = 4.2667;
	points[33] = (-8839.8818, 10873.1104, 2726.9292);
	angles[33] = (0, 171.4185, 0);
	at[33] = 4.4000;
	points[34] = (-8854.1729, 10773.0703, 2317);
	angles[34] = (0, 172.1553, 0);
	at[34] = 4.5333;
	points[35] = (-8866.6143, 10681.4180, 1914.4252);
	angles[35] = (0, 172.3422, 0);
	at[35] = 4.6667;
	points[36] = (-8878.3467, 10593.7402, 1521.2086);
	angles[36] = (0, 172.3996, 0);
	at[36] = 4.8000;
	points[37] = (-8889.8428, 10507.7559, 1135.1851);
	angles[37] = (0, 172.3453, 0);
	at[37] = 4.9333;
	points[38] = (-8894.1738, 10475.5117, 992.3937);
	angles[38] = (0, 172.2627, 0);
	at[38] = 5.0667;
	points[39] = (-8894.1738, 10475.5117, 992.3937);
	angles[39] = (0, 172.2627, 0);
	at[39] = 6.3333;
	points[40] = (-5992.8350, 23561.8887, 5142.5591);
	angles[40] = (0, 167.2203, 0);
	at[40] = 6.3333;
	points[41] = (-5992.8350, 23561.8887, 5142.5591);
	angles[41] = (0, 167.2203, 0);
	at[41] = 30;
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
	points[0] = (-5992.8350, 23561.8887, 5142.5591);
	angles[0] = (0, 167.2203, 0);
	at[0] = 0;
	points[1] = (-5992.8350, 23561.8887, 5142.5591);
	angles[1] = (0, 167.2203, 0);
	at[1] = 15.0667;
	points[2] = (-6022.1655, 23430.9844, 5257.8345);
	angles[2] = (0, 167.4496, 0);
	at[2] = 15.2000;
	points[3] = (-6101.1812, 23077.4824, 5569.4883);
	angles[3] = (0, 167.2239, 0);
	at[3] = 15.3333;
	points[4] = (-6194.6064, 22717.3242, 5874.2520);
	angles[4] = (0, 163.2258, 0);
	at[4] = 15.4667;
	points[5] = (-6307.2837, 22334.3711, 6153.9370);
	angles[5] = (0, 166.1479, 0);
	at[5] = 15.6000;
	points[6] = (-6411.6143, 21881.1426, 6321.1812);
	angles[6] = (0, 167.4789, 0);
	at[6] = 15.7333;
	points[7] = (-6502.8345, 21426.0234, 6493.6611);
	angles[7] = (0, 167.0043, 0);
	at[7] = 15.8667;
	points[8] = (-6629.2129, 20966.0645, 6637.2051);
	angles[8] = (0, 164.3824, 0);
	at[8] = 16;
	points[9] = (-6748.3071, 20512.6758, 6816.7324);
	angles[9] = (0, 167.2326, 0);
	at[9] = 16.1333;
	points[10] = (-6827.5986, 20030.5508, 6934.2524);
	angles[10] = (0, 169.3449, 0);
	at[10] = 16.2667;
	points[11] = (-6926.6533, 19544.6074, 7040.3940);
	angles[11] = (0, 167.0760, 0);
	at[11] = 16.4000;
	points[12] = (-7009.8428, 19119.2129, 7282.6772);
	angles[12] = (0, 169.4620, 0);
	at[12] = 16.5333;
	points[13] = (-7139.6060, 18642.4805, 7405.6694);
	angles[13] = (0, 167.8573, 0);
	at[13] = 16.6667;
	points[14] = (-7244.7246, 18144.9219, 7489.5273);
	angles[14] = (0, 166.6614, 0);
	at[14] = 16.8000;
	points[15] = (-7385.7485, 17656.5742, 7549.4883);
	angles[15] = (0, 166.6256, 0);
	at[15] = 16.9333;
	points[16] = (-7478.4253, 17148.8984, 7528.8975);
	angles[16] = (0, 170.8774, 0);
	at[16] = 17.0667;
	points[17] = (-7581.4170, 16648.1504, 7469.3701);
	angles[17] = (0, 165.8716, 0);
	at[17] = 17.2000;
	points[18] = (-7690.3545, 16159.8428, 7348.0713);
	angles[18] = (0, 168.7416, 0);
	at[18] = 17.3333;
	points[19] = (-7799.9214, 15670.3154, 7243.6226);
	angles[19] = (0, 166.5833, 0);
	at[19] = 17.4667;
	points[20] = (-7909.2524, 15197.0869, 7088.3467);
	angles[20] = (0, 166.7917, 0);
	at[20] = 17.6000;
	points[21] = (-8032.6772, 14741.6152, 6898.3071);
	angles[21] = (0, 165.7186, 0);
	at[21] = 17.7333;
	points[22] = (-8127.6768, 14294.3301, 6692.8740);
	angles[22] = (0, 169.0560, 0);
	at[22] = 17.8667;
	points[23] = (-8196.6543, 13937.0479, 6350.1577);
	angles[23] = (0, 166.9296, 0);
	at[23] = 18;
	points[24] = (-8290.0781, 13577.2441, 6026.6929);
	angles[24] = (0, 163.6353, 0);
	at[24] = 18.1333;
	points[25] = (-8384.5273, 13250.2363, 5679.2915);
	angles[25] = (0, 164.9567, 0);
	at[25] = 18.2667;
	points[26] = (-8464.8027, 12942.9531, 5315.8662);
	angles[26] = (0, 165.9098, 0);
	at[26] = 18.4000;
	points[27] = (-8531.0234, 12642.9922, 4956.1421);
	angles[27] = (0, 168.3107, 0);
	at[27] = 18.5333;
	points[28] = (-8590.3545, 12335, 4613.0708);
	angles[28] = (0, 170.4227, 0);
	at[28] = 18.6667;
	points[29] = (-8645.1973, 12000.4727, 4298.6611);
	angles[29] = (0, 170.8053, 0);
	at[29] = 18.8000;
	points[30] = (-8699.4092, 11667.6777, 3996.2598);
	angles[30] = (0, 170.7201, 0);
	at[30] = 18.9333;
	points[31] = (-8753.1494, 11341.4570, 3693.5789);
	angles[31] = (0, 170.4073, 0);
	at[31] = 19.0667;
	points[32] = (-8795.1182, 11116.4570, 3319.1655);
	angles[32] = (0, 169.0300, 0);
	at[32] = 19.2000;
	points[33] = (-8829.2129, 10937.2041, 2925.0120);
	angles[33] = (0, 169.7589, 0);
	at[33] = 19.3333;
	points[34] = (-8847.4414, 10821.1416, 2520.5315);
	angles[34] = (0, 171.9447, 0);
	at[34] = 19.4667;
	points[35] = (-8860.5117, 10726.6143, 2114.6023);
	angles[35] = (0, 172.2720, 0);
	at[35] = 19.6000;
	points[36] = (-8872.5195, 10637.2842, 1717.0552);
	angles[36] = (0, 172.3828, 0);
	at[36] = 19.7333;
	points[37] = (-8884.0947, 10550.5898, 1327.0670);
	angles[37] = (0, 172.3911, 0);
	at[37] = 19.8667;
	points[38] = (-8894.1738, 10475.5117, 992.3937);
	angles[38] = (0, 172.2627, 0);
	at[38] = 20;
	points[39] = (-8894.1738, 10475.5117, 992.3937);
	angles[39] = (0, 172.2627, 0);
	at[39] = 21.3333;
	points[40] = (-5992.8350, 23561.8887, 5142.5591);
	angles[40] = (0, 167.2203, 0);
	at[40] = 21.3333;
	points[41] = (-5992.8350, 23561.8887, 5142.5591);
	angles[41] = (0, 167.2203, 0);
	at[41] = 30;
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
	points[0] = (-5461.9292, 23525, 5141.1025);
	angles[0] = (0, -170.1509, 0);
	at[0] = 0;
	points[1] = (-5461.9292, 23525, 5141.1025);
	angles[1] = (0, -170.1509, 0);
	at[1] = 0.1333;
	points[2] = (-5447.6772, 23442.9941, 5223.4253);
	angles[2] = (0, -170.1533, 0);
	at[2] = 0.2667;
	points[3] = (-5389.5273, 23107.9531, 5560.0396);
	angles[3] = (0, -170.1497, 0);
	at[3] = 0.4000;
	points[4] = (-5329.7246, 22757.9531, 5887.9131);
	angles[4] = (0, -170.2429, 0);
	at[4] = 0.5333;
	points[5] = (-5252.2441, 22387.0879, 6199.9214);
	angles[5] = (0, -166.8895, 0);
	at[5] = 0.6667;
	points[6] = (-5164.4092, 22004.5684, 6506.3389);
	angles[6] = (0, -167.5070, 0);
	at[6] = 0.8000;
	points[7] = (-5073.7007, 21595.3945, 6782.2837);
	angles[7] = (0, -167.3765, 0);
	at[7] = 0.9333;
	points[8] = (-4969.4097, 21127.1270, 6953.7007);
	angles[8] = (0, -167.8656, 0);
	at[8] = 1.0667;
	points[9] = (-4872.4409, 20673.5840, 7176.5352);
	angles[9] = (0, -167.5167, 0);
	at[9] = 1.2000;
	points[10] = (-4757.2441, 20176.1426, 7249.7637);
	angles[10] = (0, -166.8295, 0);
	at[10] = 1.3333;
	points[11] = (-4638.7402, 19676.6152, 7315.3545);
	angles[11] = (0, -166.4716, 0);
	at[11] = 1.4667;
	points[12] = (-4516.3384, 19175.5117, 7366.9292);
	angles[12] = (0, -165.7983, 0);
	at[12] = 1.6000;
	points[13] = (-4388.1890, 18670.0781, 7346.2202);
	angles[13] = (0, -165.9347, 0);
	at[13] = 1.7333;
	points[14] = (-4270.8662, 18165.9453, 7306.4565);
	angles[14] = (0, -167.2466, 0);
	at[14] = 1.8667;
	points[15] = (-4152.5195, 17668.7012, 7227.2446);
	angles[15] = (0, -165.6868, 0);
	at[15] = 2;
	points[16] = (-4029.4094, 17183.8594, 7099.4492);
	angles[16] = (0, -166.4856, 0);
	at[16] = 2.1333;
	points[17] = (-3914.2402, 16705.1973, 6954.9214);
	angles[17] = (0, -165.4072, 0);
	at[17] = 2.2667;
	points[18] = (-3799.1616, 16265.1963, 6724.2915);
	angles[18] = (0, -166.1200, 0);
	at[18] = 2.4000;
	points[19] = (-3686.6104, 15804.5273, 6547.9922);
	angles[19] = (0, -166.1230, 0);
	at[19] = 2.5333;
	points[20] = (-3578.9292, 15365.0400, 6326.3779);
	angles[20] = (0, -166.8092, 0);
	at[20] = 2.6667;
	points[21] = (-3482.9490, 14914.1338, 6142.4805);
	angles[21] = (0, -168.0741, 0);
	at[21] = 2.8000;
	points[22] = (-3378.3347, 14472.5986, 5950);
	angles[22] = (0, -165.6946, 0);
	at[22] = 2.9333;
	points[23] = (-3265.3818, 14031.6533, 5772.9526);
	angles[23] = (0, -165.5730, 0);
	at[23] = 3.0667;
	points[24] = (-3150.7639, 13582.6777, 5623.9375);
	angles[24] = (0, -166.1595, 0);
	at[24] = 3.2000;
	points[25] = (-3054.7993, 13172.4404, 5392.2837);
	angles[25] = (0, -167.0477, 0);
	at[25] = 3.3333;
	points[26] = (-2960.0039, 12757.9531, 5179.2520);
	angles[26] = (0, -167.1850, 0);
	at[26] = 3.4667;
	points[27] = (-2866.7244, 12340.0400, 4986.0630);
	angles[27] = (0, -168.1425, 0);
	at[27] = 3.6000;
	points[28] = (-2778.2402, 11904.3311, 4832.2441);
	angles[28] = (0, -168.6313, 0);
	at[28] = 3.7333;
	points[29] = (-2697.3191, 11506.8896, 4618.5039);
	angles[29] = (0, -167.7757, 0);
	at[29] = 3.8667;
	points[30] = (-2631.8818, 11208.2676, 4276.4570);
	angles[30] = (0, -167.8517, 0);
	at[30] = 4;
	points[31] = (-2589.1062, 10995.3936, 3884.0945);
	angles[31] = (0, -170.3598, 0);
	at[31] = 4.1333;
	points[32] = (-2571.3267, 10873.5430, 3463.7915);
	angles[32] = (0, -172.3376, 0);
	at[32] = 4.2667;
	points[33] = (-2557.5710, 10768.2686, 3050.0396);
	angles[33] = (0, -172.7187, 0);
	at[33] = 4.4000;
	points[34] = (-2544.9172, 10667.8740, 2640.8818);
	angles[34] = (0, -172.8931, 0);
	at[34] = 4.5333;
	points[35] = (-2533.0042, 10571.6934, 2241.9883);
	angles[35] = (0, -172.9806, 0);
	at[35] = 4.6667;
	points[36] = (-2521.6062, 10478.8584, 1853.8661);
	angles[36] = (0, -173.0123, 0);
	at[36] = 4.8000;
	points[37] = (-2510.5591, 10388.7793, 1477.2244);
	angles[37] = (0, -172.9885, 0);
	at[37] = 4.9333;
	points[38] = (-2499.4961, 10299.4883, 1106.9291);
	angles[38] = (0, -172.8671, 0);
	at[38] = 5.0667;
	points[39] = (-2495.2915, 10266.1025, 970.7363);
	angles[39] = (0, -172.7634, 0);
	at[39] = 5.2000;
	points[40] = (-2495.2915, 10266.1025, 970.7363);
	angles[40] = (0, -172.7634, 0);
	at[40] = 6.4667;
	points[41] = (-5461.9292, 23525, 5141.1025);
	angles[41] = (0, -170.1509, 0);
	at[41] = 6.4667;
	points[42] = (-5461.9292, 23525, 5141.1025);
	angles[42] = (0, -170.1509, 0);
	at[42] = 30;
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
	points[0] = (-5461.9292, 23525, 5141.1025);
	angles[0] = (0, -170.1509, 0);
	at[0] = 0;
	points[1] = (-5461.9292, 23525, 5141.1025);
	angles[1] = (0, -170.1509, 0);
	at[1] = 15.2000;
	points[2] = (-5418.7402, 23276.1816, 5391.3389);
	angles[2] = (0, -170.1532, 0);
	at[2] = 15.3333;
	points[3] = (-5360.0396, 22937.4414, 5725.7876);
	angles[3] = (0, -170.4097, 0);
	at[3] = 15.4667;
	points[4] = (-5295.3154, 22575.0391, 6046.3779);
	angles[4] = (0, -167.5781, 0);
	at[4] = 15.6000;
	points[5] = (-5207.7168, 22196.3008, 6353.5435);
	angles[5] = (0, -166.8938, 0);
	at[5] = 15.7333;
	points[6] = (-5121.1812, 21808.8965, 6658.6221);
	angles[6] = (0, -167.5486, 0);
	at[6] = 15.8667;
	points[7] = (-5021.1421, 21360.5918, 6866.0630);
	angles[7] = (0, -167.3920, 0);
	at[7] = 16;
	points[8] = (-4921.8896, 20903.5449, 7069.6855);
	angles[8] = (0, -168.0181, 0);
	at[8] = 16.1333;
	points[9] = (-4815.9844, 20427.9141, 7220.6304);
	angles[9] = (0, -166.9137, 0);
	at[9] = 16.2667;
	points[10] = (-4698.5830, 19926.5762, 7277.7954);
	angles[10] = (0, -166.6622, 0);
	at[10] = 16.4000;
	points[11] = (-4578.1499, 19425.6309, 7351.4175);
	angles[11] = (0, -166.3596, 0);
	at[11] = 16.5333;
	points[12] = (-4452.0869, 18922.7168, 7358.8579);
	angles[12] = (0, -165.7316, 0);
	at[12] = 16.6667;
	points[13] = (-4328.4253, 18419.6465, 7328.8188);
	angles[13] = (0, -167.1276, 0);
	at[13] = 16.8000;
	points[14] = (-4213.5039, 17914.5273, 7279.1338);
	angles[14] = (0, -166.8908, 0);
	at[14] = 16.9333;
	points[15] = (-4089.9607, 17424.6855, 7163.5430);
	angles[15] = (0, -165.6093, 0);
	at[15] = 17.0667;
	points[16] = (-3971.5747, 16940.3145, 7035.7480);
	angles[16] = (0, -166.6774, 0);
	at[16] = 17.2000;
	points[17] = (-3856.2244, 16485.6699, 6834.7246);
	angles[17] = (0, -165.1434, 0);
	at[17] = 17.3333;
	points[18] = (-3742.2205, 16032.4414, 6638.7798);
	angles[18] = (0, -166.3160, 0);
	at[18] = 17.4667;
	points[19] = (-3632.2087, 15584.6465, 6436.7720);
	angles[19] = (0, -166.1549, 0);
	at[19] = 17.6000;
	points[20] = (-3530.5867, 15141.2607, 6232.7954);
	angles[20] = (0, -168.1566, 0);
	at[20] = 17.7333;
	points[21] = (-3433.4370, 14691.7715, 6050.4727);
	angles[21] = (0, -166.2485, 0);
	at[21] = 17.8667;
	points[22] = (-3322.3701, 14254.0557, 5851.7715);
	angles[22] = (0, -165.6349, 0);
	at[22] = 18;
	points[23] = (-3207.4290, 13806.1416, 5701.6538);
	angles[23] = (0, -165.6256, 0);
	at[23] = 18.1333;
	points[24] = (-3101.8269, 13375.9053, 5512.2832);
	angles[24] = (0, -166.9036, 0);
	at[24] = 18.2667;
	points[25] = (-3008.0825, 12968.6230, 5281.2207);
	angles[25] = (0, -167.1149, 0);
	at[25] = 18.4000;
	points[26] = (-2912.5195, 12548.1094, 5080.1968);
	angles[26] = (0, -167.3363, 0);
	at[26] = 18.5333;
	points[27] = (-2822.0356, 12121.6924, 4908.5830);
	angles[27] = (0, -168.5660, 0);
	at[27] = 18.6667;
	points[28] = (-2735.6851, 11692.7959, 4746.1025);
	angles[28] = (0, -168.5968, 0);
	at[28] = 18.8000;
	points[29] = (-2662.4919, 11348.3857, 4453.8188);
	angles[29] = (0, -167.5693, 0);
	at[29] = 18.9333;
	points[30] = (-2606.7600, 11088.5049, 4086.5750);
	angles[30] = (0, -168.5721, 0);
	at[30] = 19.0667;
	points[31] = (-2579.3113, 10931.3789, 3677.5156);
	angles[31] = (0, -171.8814, 0);
	at[31] = 19.2000;
	points[32] = (-2564.2522, 10820.0781, 3256.3623);
	angles[32] = (0, -172.5708, 0);
	at[32] = 19.3333;
	points[33] = (-2551.0630, 10716.9688, 2842.0669);
	angles[33] = (0, -172.8216, 0);
	at[33] = 19.4667;
	points[34] = (-2538.8699, 10619.2129, 2439.5474);
	angles[34] = (0, -172.9450, 0);
	at[34] = 19.6000;
	points[35] = (-2527.2324, 10524.7246, 2045.8110);
	angles[35] = (0, -173.0029, 0);
	at[35] = 19.7333;
	points[36] = (-2515.9802, 10432.9531, 1661.7559);
	angles[36] = (0, -173.0082, 0);
	at[36] = 19.8667;
	points[37] = (-2504.9490, 10343.3076, 1287.9448);
	angles[37] = (0, -172.9451, 0);
	at[37] = 20;
	points[38] = (-2495.2915, 10266.1025, 970.7363);
	angles[38] = (0, -172.7634, 0);
	at[38] = 20.1333;
	points[39] = (-2495.2915, 10266.1025, 970.7363);
	angles[39] = (0, -172.7634, 0);
	at[39] = 21.4667;
	points[40] = (-5461.9292, 23525, 5141.1025);
	angles[40] = (0, -170.1509, 0);
	at[40] = 21.4667;
	points[41] = (-5461.9292, 23525, 5141.1025);
	angles[41] = (0, -170.1509, 0);
	at[41] = 30;
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
