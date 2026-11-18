main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_wario_stadium", 0);

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
	ambientPlay("iz_0_uws", 2);
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
	level.iz_route[level.iz_route.size] = (-835, -1053, 1605);
	level.iz_route[level.iz_route.size] = (1111, -1059, 1605);
	level.iz_route[level.iz_route.size] = (2118, -784, 1643);
	level.iz_route[level.iz_route.size] = (2800, -5, 1738);
	level.iz_route[level.iz_route.size] = (2652, 788, 1733);
	level.iz_route[level.iz_route.size] = (2001, 1330, 1684);
	level.iz_route[level.iz_route.size] = (1296, 1535, 1675);
	level.iz_route[level.iz_route.size] = (623, 1907, 1692);
	level.iz_route[level.iz_route.size] = (287, 2903, 1684);
	level.iz_route[level.iz_route.size] = (-264, 3342, 1739);
	level.iz_route[level.iz_route.size] = (-949, 3454, 1771);
	level.iz_route[level.iz_route.size] = (-1645, 3243, 1756);
	level.iz_route[level.iz_route.size] = (-2157, 2367, 1713);
	level.iz_route[level.iz_route.size] = (-2169, 618, 1764);
	level.iz_route[level.iz_route.size] = (-2175, -618, 2385);
	level.iz_route[level.iz_route.size] = (-2144, -2467, 2148);
	level.iz_route[level.iz_route.size] = (-2122, -3258, 1902);
	level.iz_route[level.iz_route.size] = (-2041, -3930, 1925);
	level.iz_route[level.iz_route.size] = (-1770, -4377, 1907);
	level.iz_route[level.iz_route.size] = (-766, -4819, 1654);
	level.iz_route[level.iz_route.size] = (302, -4941, 1659);
	level.iz_route[level.iz_route.size] = (3921, -5271, 1644);
	level.iz_route[level.iz_route.size] = (5186, -5243, 1595);
	level.iz_route[level.iz_route.size] = (6014, -5120, 1728);
	level.iz_route[level.iz_route.size] = (6605, -4866, 1890);
	level.iz_route[level.iz_route.size] = (6961, -4311, 1965);
	level.iz_route[level.iz_route.size] = (7144, -3682, 1974);
	level.iz_route[level.iz_route.size] = (7049, -2411, 1900);
	level.iz_route[level.iz_route.size] = (6952, -1284, 2142);
	level.iz_route[level.iz_route.size] = (6173, 836, 2364);
	level.iz_route[level.iz_route.size] = (5796, 2299, 2092);
	level.iz_route[level.iz_route.size] = (5737, 3261, 2046);
	level.iz_route[level.iz_route.size] = (5661, 4070, 2104);
	level.iz_route[level.iz_route.size] = (5430, 4910, 2174);
	level.iz_route[level.iz_route.size] = (4972, 5647, 2236);
	level.iz_route[level.iz_route.size] = (4453, 6129, 2281);
	level.iz_route[level.iz_route.size] = (2455, 7178, 2162);
	level.iz_route[level.iz_route.size] = (3033, 8813, 3762);
	level.iz_route[level.iz_route.size] = (742, 9643, 3944);
	level.iz_route[level.iz_route.size] = (-934, 9704, 2997);
	level.iz_route[level.iz_route.size] = (-2368, 10184, 2796);
	level.iz_route[level.iz_route.size] = (-3119, 10121, 2664);
	level.iz_route[level.iz_route.size] = (-3747, 9619, 2391);
	level.iz_route[level.iz_route.size] = (-4124, 8937, 2484);
	level.iz_route[level.iz_route.size] = (-5837, 5932, 2533);
	level.iz_route[level.iz_route.size] = (-6699, 4411, 1069);
	level.iz_route[level.iz_route.size] = (-7351, 3246, 1154);
	level.iz_route[level.iz_route.size] = (-8385, 1538, 1045);
	level.iz_route[level.iz_route.size] = (-8659, 790, 1082);
	level.iz_route[level.iz_route.size] = (-8668, -1, 1121);
	level.iz_route[level.iz_route.size] = (-8080, -909, 1129);
	level.iz_route[level.iz_route.size] = (-6891, -1086, 1202);
	level.iz_route[level.iz_route.size] = (-5968, -1085, 1757);
	level.iz_route[level.iz_route.size] = (-3133, -1016, 1795);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1663.8464, 8676.2598, 3347.5789);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1663.8464, 8676.2598, 3347.5789);
	angles[1] = (90, 0, 0);
	at[1] = 1.8000;
	points[2] = (1663.8464, 8676.2598, 3347.5789);
	angles[2] = (180, 0, 0);
	at[2] = 3.6000;
	points[3] = (1663.8464, 8676.2598, 3347.5789);
	angles[3] = (0, 0, 0);
	at[3] = 7.2000;
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
	points[0] = (6907.0474, -1154.0945, 2173.9961);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6907.0474, -1154.0945, 2173.9961);
	angles[1] = (-90, 0, 0);
	at[1] = 1.5000;
	points[2] = (6907.0474, -1154.0945, 2173.9961);
	angles[2] = (-180, 0, 0);
	at[2] = 3;
	points[3] = (6907.0474, -1154.0945, 2173.9961);
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
	points[0] = (6146.3389, 1021.1418, 2379.5789);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6146.3389, 1021.1418, 2379.5789);
	angles[1] = (90, 0, 0);
	at[1] = 1.5000;
	points[2] = (6146.3389, 1021.1418, 2379.5789);
	angles[2] = (180, 0, 0);
	at[2] = 3;
	points[3] = (6146.3389, 1021.1418, 2379.5789);
	angles[3] = (0, 0, 0);
	at[3] = 6;
	mover = getEnt("iz_obj_2", "targetname");
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
