main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_sky_garden", 0);

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
	ambientPlay("iz_0_45", 2);
	level thread iz_music("iz_7_se_cn_knk_env_wind");
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
	level.iz_route[level.iz_route.size] = (-6697, -2732, 4360);
	level.iz_route[level.iz_route.size] = (-6712, -4593, 4378);
	level.iz_route[level.iz_route.size] = (-6665, -6198, 4397);
	level.iz_route[level.iz_route.size] = (-6503, -6445, 4398);
	level.iz_route[level.iz_route.size] = (-6237, -6597, 4398);
	level.iz_route[level.iz_route.size] = (-5899, -6718, 4398);
	level.iz_route[level.iz_route.size] = (-4546, -6791, 4398);
	level.iz_route[level.iz_route.size] = (-3211, -6787, 4398);
	level.iz_route[level.iz_route.size] = (-2822, -6725, 4398);
	level.iz_route[level.iz_route.size] = (-2452, -6438, 4398);
	level.iz_route[level.iz_route.size] = (-1859, -5747, 4398);
	level.iz_route[level.iz_route.size] = (-1581, -5421, 4398);
	level.iz_route[level.iz_route.size] = (-1302, -5337, 4398);
	level.iz_route[level.iz_route.size] = (-844, -5262, 4398);
	level.iz_route[level.iz_route.size] = (-118, -5153, 4496);
	level.iz_route[level.iz_route.size] = (1068, -5149, 4398);
	level.iz_route[level.iz_route.size] = (2292, -5163, 4398);
	level.iz_route[level.iz_route.size] = (2581, -5260, 4398);
	level.iz_route[level.iz_route.size] = (3457, -6175, 4398);
	level.iz_route[level.iz_route.size] = (4624, -7418, 4398);
	level.iz_route[level.iz_route.size] = (4979, -7575, 4398);
	level.iz_route[level.iz_route.size] = (5287, -7638, 4398);
	level.iz_route[level.iz_route.size] = (6308, -7606, 4398);
	level.iz_route[level.iz_route.size] = (6602, -7386, 4398);
	level.iz_route[level.iz_route.size] = (6676, -6984, 4398);
	level.iz_route[level.iz_route.size] = (6675, -6133, 4389);
	level.iz_route[level.iz_route.size] = (6649, -5052, 4362);
	level.iz_route[level.iz_route.size] = (6647, -3230, 4383);
	level.iz_route[level.iz_route.size] = (6619, -1061, 4398);
	level.iz_route[level.iz_route.size] = (6526, -442, 4398);
	level.iz_route[level.iz_route.size] = (6212, 36, 4398);
	level.iz_route[level.iz_route.size] = (5627, 594, 4398);
	level.iz_route[level.iz_route.size] = (5283, 884, 4398);
	level.iz_route[level.iz_route.size] = (4897, 1276, 4398);
	level.iz_route[level.iz_route.size] = (4805, 1695, 4398);
	level.iz_route[level.iz_route.size] = (4802, 2038, 4398);
	level.iz_route[level.iz_route.size] = (4983, 2352, 4398);
	level.iz_route[level.iz_route.size] = (5372, 2491, 4398);
	level.iz_route[level.iz_route.size] = (6239, 2604, 4398);
	level.iz_route[level.iz_route.size] = (7390, 2636, 4398);
	level.iz_route[level.iz_route.size] = (8143, 2723, 4398);
	level.iz_route[level.iz_route.size] = (8429, 2880, 4398);
	level.iz_route[level.iz_route.size] = (8589, 3243, 4398);
	level.iz_route[level.iz_route.size] = (8586, 3671, 4398);
	level.iz_route[level.iz_route.size] = (8612, 5066, 4398);
	level.iz_route[level.iz_route.size] = (8563, 6662, 4398);
	level.iz_route[level.iz_route.size] = (8485, 7262, 4398);
	level.iz_route[level.iz_route.size] = (8233, 7601, 4398);
	level.iz_route[level.iz_route.size] = (7919, 7691, 4398);
	level.iz_route[level.iz_route.size] = (7541, 7651, 4398);
	level.iz_route[level.iz_route.size] = (7173, 7529, 4398);
	level.iz_route[level.iz_route.size] = (6504, 6850, 4398);
	level.iz_route[level.iz_route.size] = (5845, 6158, 4398);
	level.iz_route[level.iz_route.size] = (5185, 5563, 4398);
	level.iz_route[level.iz_route.size] = (4890, 5494, 4398);
	level.iz_route[level.iz_route.size] = (4462, 5469, 4398);
	level.iz_route[level.iz_route.size] = (2845, 5421, 4398);
	level.iz_route[level.iz_route.size] = (2184, 5357, 4398);
	level.iz_route[level.iz_route.size] = (1677, 5182, 4398);
	level.iz_route[level.iz_route.size] = (1261, 4713, 4398);
	level.iz_route[level.iz_route.size] = (817, 3971, 4398);
	level.iz_route[level.iz_route.size] = (-172, 2083, 4398);
	level.iz_route[level.iz_route.size] = (-981, 670, 4398);
	level.iz_route[level.iz_route.size] = (-1302, 414, 4398);
	level.iz_route[level.iz_route.size] = (-1647, 273, 4398);
	level.iz_route[level.iz_route.size] = (-2027, 247, 4398);
	level.iz_route[level.iz_route.size] = (-2524, 289, 4398);
	level.iz_route[level.iz_route.size] = (-2860, 529, 4398);
	level.iz_route[level.iz_route.size] = (-3070, 839, 4398);
	level.iz_route[level.iz_route.size] = (-3119, 1231, 4398);
	level.iz_route[level.iz_route.size] = (-3088, 1692, 4398);
	level.iz_route[level.iz_route.size] = (-2964, 2166, 4398);
	level.iz_route[level.iz_route.size] = (-2749, 2652, 4398);
	level.iz_route[level.iz_route.size] = (-2427, 2985, 4398);
	level.iz_route[level.iz_route.size] = (-1840, 3380, 4398);
	level.iz_route[level.iz_route.size] = (-1388, 3814, 4398);
	level.iz_route[level.iz_route.size] = (-1220, 4252, 4398);
	level.iz_route[level.iz_route.size] = (-1182, 4719, 4398);
	level.iz_route[level.iz_route.size] = (-1166, 5747, 4398);
	level.iz_route[level.iz_route.size] = (-1193, 6892, 4398);
	level.iz_route[level.iz_route.size] = (-1367, 7476, 4398);
	level.iz_route[level.iz_route.size] = (-1605, 7764, 4398);
	level.iz_route[level.iz_route.size] = (-2059, 7942, 4398);
	level.iz_route[level.iz_route.size] = (-2619, 7998, 4398);
	level.iz_route[level.iz_route.size] = (-3171, 7722, 4398);
	level.iz_route[level.iz_route.size] = (-3932, 6904, 4398);
	level.iz_route[level.iz_route.size] = (-4394, 6495, 4398);
	level.iz_route[level.iz_route.size] = (-4688, 6330, 4398);
	level.iz_route[level.iz_route.size] = (-5005, 6239, 4398);
	level.iz_route[level.iz_route.size] = (-5662, 6197, 4398);
	level.iz_route[level.iz_route.size] = (-6709, 6101, 4398);
	level.iz_route[level.iz_route.size] = (-7106, 5862, 4398);
	level.iz_route[level.iz_route.size] = (-7442, 5387, 4398);
	level.iz_route[level.iz_route.size] = (-7548, 4758, 4398);
	level.iz_route[level.iz_route.size] = (-7403, 4058, 4398);
	level.iz_route[level.iz_route.size] = (-6796, 2896, 4398);
	level.iz_route[level.iz_route.size] = (-6741, 2439, 4398);
	level.iz_route[level.iz_route.size] = (-6760, 2099, 4398);
	level.iz_route[level.iz_route.size] = (-6853, 1656, 4395);
	level.iz_route[level.iz_route.size] = (-6872, 1301, 4389);
	level.iz_route[level.iz_route.size] = (-6877, 954, 4389);
	level.iz_route[level.iz_route.size] = (-6853, 674, 4388);
	level.iz_route[level.iz_route.size] = (-6807, 386, 4385);
	level.iz_route[level.iz_route.size] = (-6716, 77, 4384);
	level.iz_route[level.iz_route.size] = (-6706, -270, 4383);
	level.iz_route[level.iz_route.size] = (-6694, -816, 4379);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-13643.2285, 5108.1104, 8858.2676);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-13035.2363, -350.6417, 8858.2676);
	angles[1] = (0, 0, 0);
	at[1] = 31;
	points[2] = (-13017.3232, -437.1142, 8858.2676);
	angles[2] = (0, 0, 0);
	at[2] = 31.5000;
	points[3] = (-11855.5117, -4619.2520, 8858.2676);
	angles[3] = (0, 0, 0);
	at[3] = 56;
	points[4] = (-10787.5596, -8183.1104, 8858.2676);
	angles[4] = (0, 0, 0);
	at[4] = 77;
	points[5] = (-10734.4092, -8245.8271, 8858.2676);
	angles[5] = (0, 0, 0);
	at[5] = 77.5000;
	points[6] = (-6492.9531, -10643.1494, 8858.2676);
	angles[6] = (0, 0, 0);
	at[6] = 105;
	points[7] = (-6410.3545, -10669.7637, 8858.2676);
	angles[7] = (0, 0, 0);
	at[7] = 105.5000;
	points[8] = (-246.1756, -11343.4248, 8858.2676);
	angles[8] = (0, 0, 0);
	at[8] = 140.5000;
	points[9] = (7341.4961, -12026.5752, 8858.2676);
	angles[9] = (0, 0, 0);
	at[9] = 183.5000;
	points[10] = (7424.3311, -12009.7246, 8858.2676);
	angles[10] = (0, 0, 0);
	at[10] = 184;
	points[11] = (13041.4961, -8805.8271, 8858.2676);
	angles[11] = (0, 0, 0);
	at[11] = 220.5000;
	points[12] = (13081.6924, -8731.6533, 8858.2676);
	angles[12] = (0, 0, 0);
	at[12] = 221;
	points[13] = (15631.2207, -1178.0985, 8858.2676);
	angles[13] = (0, 0, 0);
	at[13] = 266;
	points[14] = (15646.4180, -1091.1497, 8858.2676);
	angles[14] = (0, 0, 0);
	at[14] = 266.5000;
	points[15] = (16704.1738, 7257.6377, 8858.2676);
	angles[15] = (0, 0, 0);
	at[15] = 314;
	points[16] = (16688.5840, 7339.9604, 8858.2676);
	angles[16] = (0, 0, 0);
	at[16] = 314.5000;
	points[17] = (13879.4092, 12059.4492, 8858.2676);
	angles[17] = (0, 0, 0);
	at[17] = 345.5000;
	points[18] = (4380.7876, 15485.7490, 8858.2676);
	angles[18] = (0, 0, 0);
	at[18] = 402.5000;
	points[19] = (-8752.2051, 14168.8584, 8858.2676);
	angles[19] = (0, 0, 0);
	at[19] = 477;
	points[20] = (-8822.4805, 14133.3066, 8858.2676);
	angles[20] = (0, 0, 0);
	at[20] = 477.5000;
	points[21] = (-13643.2285, 5108.1104, 8858.2676);
	angles[21] = (0, 0, 0);
	at[21] = 535.2500;
	mover = getEnt("iz_obj_0", "targetname");
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
