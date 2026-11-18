main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_bowser_castle_1", 0);

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
	ambientPlay("iz_0_39", 2);
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
	level.iz_route[level.iz_route.size] = (-6393, -2475, 877);
	level.iz_route[level.iz_route.size] = (-6393, -3123, 877);
	level.iz_route[level.iz_route.size] = (-6374, -4197, 877);
	level.iz_route[level.iz_route.size] = (-6370, -5257, 877);
	level.iz_route[level.iz_route.size] = (-5932, -5619, 877);
	level.iz_route[level.iz_route.size] = (-5055, -5612, 877);
	level.iz_route[level.iz_route.size] = (-4215, -5611, 876);
	level.iz_route[level.iz_route.size] = (-3168, -5603, 877);
	level.iz_route[level.iz_route.size] = (-2444, -5596, 877);
	level.iz_route[level.iz_route.size] = (-1989, -5353, 877);
	level.iz_route[level.iz_route.size] = (-1985, -4606, 877);
	level.iz_route[level.iz_route.size] = (-1992, -3607, 877);
	level.iz_route[level.iz_route.size] = (-1994, -2266, 877);
	level.iz_route[level.iz_route.size] = (-1981, -981, 877);
	level.iz_route[level.iz_route.size] = (-1981, 524, 877);
	level.iz_route[level.iz_route.size] = (-1989, 1529, 876);
	level.iz_route[level.iz_route.size] = (-1966, 2383, 877);
	level.iz_route[level.iz_route.size] = (-1371, 2548, 877);
	level.iz_route[level.iz_route.size] = (-104, 2613, 877);
	level.iz_route[level.iz_route.size] = (1287, 2599, 877);
	level.iz_route[level.iz_route.size] = (2420, 2435, 877);
	level.iz_route[level.iz_route.size] = (2843, 1587, 877);
	level.iz_route[level.iz_route.size] = (3714, 1125, 876);
	level.iz_route[level.iz_route.size] = (4985, 1145, 877);
	level.iz_route[level.iz_route.size] = (5989, 1150, 877);
	level.iz_route[level.iz_route.size] = (6886, 1109, 877);
	level.iz_route[level.iz_route.size] = (7217, 1730, 876);
	level.iz_route[level.iz_route.size] = (7172, 2688, 877);
	level.iz_route[level.iz_route.size] = (7147, 3438, 876);
	level.iz_route[level.iz_route.size] = (7136, 4136, 877);
	level.iz_route[level.iz_route.size] = (6818, 4517, 877);
	level.iz_route[level.iz_route.size] = (5398, 4516, 903);
	level.iz_route[level.iz_route.size] = (4572, 4516, 877);
	level.iz_route[level.iz_route.size] = (3178, 4516, 877);
	level.iz_route[level.iz_route.size] = (843, 4495, 877);
	level.iz_route[level.iz_route.size] = (-998, 4503, 889);
	level.iz_route[level.iz_route.size] = (-2570, 4674, 877);
	level.iz_route[level.iz_route.size] = (-3669, 4705, 877);
	level.iz_route[level.iz_route.size] = (-5001, 4688, 877);
	level.iz_route[level.iz_route.size] = (-5626, 4241, 877);
	level.iz_route[level.iz_route.size] = (-5623, 3149, 877);
	level.iz_route[level.iz_route.size] = (-5625, 1987, 877);
	level.iz_route[level.iz_route.size] = (-5670, 1260, 877);
	level.iz_route[level.iz_route.size] = (-6398, 787, 877);
	level.iz_route[level.iz_route.size] = (-6381, -368, 877);
	level.iz_route[level.iz_route.size] = (-6376, -1277, 877);
	level.iz_route[level.iz_route.size] = (-6372, -1870, 877);
	level.iz_route[level.iz_route.size] = (-6371, -2024, 877);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1753.9370, 1624.0157, 1006.8898);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-1753.9370, 1624.0157, 1006.8898);
	angles[1] = (0, -180, 0);
	at[1] = 3.4500;
	points[2] = (-1753.9370, 1624.0157, 1014.5630);
	angles[2] = (0, -180, 0);
	at[2] = 3.5000;
	points[3] = (-1753.9370, 1624.0157, 1011.3189);
	angles[3] = (0, -180, 0);
	at[3] = 3.5500;
	points[4] = (-1753.9370, 1624.0157, 999.2166);
	angles[4] = (0, -180, 0);
	at[4] = 3.6000;
	points[5] = (-1753.9370, 1624.0157, 1002.4606);
	angles[5] = (0, -180, 0);
	at[5] = 3.6500;
	points[6] = (-1753.9370, 1624.0157, 1014.5630);
	angles[6] = (0, -180, 0);
	at[6] = 3.7000;
	points[7] = (-1753.9370, 1624.0157, 1011.3189);
	angles[7] = (0, -180, 0);
	at[7] = 3.7500;
	points[8] = (-1753.9370, 1624.0157, 999.2166);
	angles[8] = (0, -180, 0);
	at[8] = 3.8000;
	points[9] = (-1753.9370, 1624.0157, 1002.4606);
	angles[9] = (0, -180, 0);
	at[9] = 3.8500;
	points[10] = (-1753.9370, 1624.0157, 1014.5630);
	angles[10] = (0, -180, 0);
	at[10] = 3.9000;
	points[11] = (-1753.9370, 1624.0157, 1011.3189);
	angles[11] = (0, -180, 0);
	at[11] = 3.9500;
	points[12] = (-1753.9370, 1624.0157, 1017.2244);
	angles[12] = (0, -180, 0);
	at[12] = 4;
	points[13] = (-1753.9370, 1624.0157, 1150.0984);
	angles[13] = (0, -180, 0);
	at[13] = 4.1500;
	points[14] = (-1753.9370, 1624.0157, 1119.9803);
	angles[14] = (0, -180, 0);
	at[14] = 4.2000;
	points[15] = (-1753.9370, 1624.0157, 1044.6851);
	angles[15] = (0, -180, 0);
	at[15] = 4.2500;
	points[16] = (-1753.9370, 1624.0157, 924.2126);
	angles[16] = (0, -180, 0);
	at[16] = 4.3000;
	points[17] = (-1753.9370, 1624.0157, 876.9685);
	angles[17] = (0, -180, 0);
	at[17] = 4.3500;
	points[18] = (-1753.9370, 1624.0157, 876.9685);
	angles[18] = (0, -180, 0);
	at[18] = 5.3000;
	points[19] = (-1753.9370, 1624.0157, 882.8740);
	angles[19] = (0, -180, 0);
	at[19] = 5.3500;
	points[20] = (-1753.9370, 1624.0157, 1006.8898);
	angles[20] = (0, -180, 0);
	at[20] = 6.0500;
	points[21] = (-1753.9370, 1624.0157, 1006.8898);
	angles[21] = (0, -180, 0);
	at[21] = 6.0833;
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
	points[0] = (-2208.6614, 714.5669, 1006.8898);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-2208.6614, 714.5669, 1006.8898);
	angles[1] = (0, -180, 0);
	at[1] = 1.3500;
	points[2] = (-2208.6614, 714.5669, 1014.5630);
	angles[2] = (0, -180, 0);
	at[2] = 1.4500;
	points[3] = (-2208.6614, 714.5669, 1002.4606);
	angles[3] = (0, -180, 0);
	at[3] = 1.5000;
	points[4] = (-2208.6614, 714.5669, 999.2166);
	angles[4] = (0, -180, 0);
	at[4] = 1.5500;
	points[5] = (-2208.6614, 714.5669, 1011.3189);
	angles[5] = (0, -180, 0);
	at[5] = 1.6000;
	points[6] = (-2208.6614, 714.5669, 1014.5630);
	angles[6] = (0, -180, 0);
	at[6] = 1.6500;
	points[7] = (-2208.6614, 714.5669, 1002.4606);
	angles[7] = (0, -180, 0);
	at[7] = 1.7000;
	points[8] = (-2208.6614, 714.5669, 999.2166);
	angles[8] = (0, -180, 0);
	at[8] = 1.7500;
	points[9] = (-2208.6614, 714.5669, 1011.3189);
	angles[9] = (0, -180, 0);
	at[9] = 1.8000;
	points[10] = (-2208.6614, 714.5669, 1014.5630);
	angles[10] = (0, -180, 0);
	at[10] = 1.8500;
	points[11] = (-2208.6614, 714.5669, 1002.4606);
	angles[11] = (0, -180, 0);
	at[11] = 1.9000;
	points[12] = (-2208.6614, 714.5669, 1135.3346);
	angles[12] = (0, -180, 0);
	at[12] = 2.0500;
	points[13] = (-2208.6614, 714.5669, 1135.0394);
	angles[13] = (0, -180, 0);
	at[13] = 2.1000;
	points[14] = (-2208.6614, 714.5669, 1074.8031);
	angles[14] = (0, -180, 0);
	at[14] = 2.1500;
	points[15] = (-2208.6614, 714.5669, 969.3898);
	angles[15] = (0, -180, 0);
	at[15] = 2.2000;
	points[16] = (-2208.6614, 714.5669, 876.9685);
	angles[16] = (0, -180, 0);
	at[16] = 2.2500;
	points[17] = (-2208.6614, 714.5669, 876.9685);
	angles[17] = (0, -180, 0);
	at[17] = 3.2000;
	points[18] = (-2208.6614, 714.5669, 879.9213);
	angles[18] = (0, -180, 0);
	at[18] = 3.2500;
	points[19] = (-2208.6614, 714.5669, 1003.9370);
	angles[19] = (0, -180, 0);
	at[19] = 3.9500;
	points[20] = (-2208.6614, 714.5669, 1006.8898);
	angles[20] = (0, -180, 0);
	at[20] = 4;
	points[21] = (-2208.6614, 714.5669, 1006.8898);
	angles[21] = (0, -180, 0);
	at[21] = 6.0833;
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
	points[0] = (6496.0630, 1039.3701, 1006.8898);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (6496.0630, 1039.3701, 1006.8898);
	angles[1] = (0, 90, 0);
	at[1] = 3.4500;
	points[2] = (6496.0630, 1039.3701, 1014.5630);
	angles[2] = (0, 90, 0);
	at[2] = 3.5000;
	points[3] = (6496.0630, 1039.3701, 1011.3189);
	angles[3] = (0, 90, 0);
	at[3] = 3.5500;
	points[4] = (6496.0630, 1039.3701, 999.2166);
	angles[4] = (0, 90, 0);
	at[4] = 3.6000;
	points[5] = (6496.0630, 1039.3701, 1002.4606);
	angles[5] = (0, 90, 0);
	at[5] = 3.6500;
	points[6] = (6496.0630, 1039.3701, 1014.5630);
	angles[6] = (0, 90, 0);
	at[6] = 3.7000;
	points[7] = (6496.0630, 1039.3701, 1011.3189);
	angles[7] = (0, 90, 0);
	at[7] = 3.7500;
	points[8] = (6496.0630, 1039.3701, 999.2166);
	angles[8] = (0, 90, 0);
	at[8] = 3.8000;
	points[9] = (6496.0630, 1039.3701, 1002.4606);
	angles[9] = (0, 90, 0);
	at[9] = 3.8500;
	points[10] = (6496.0630, 1039.3701, 1014.5630);
	angles[10] = (0, 90, 0);
	at[10] = 3.9000;
	points[11] = (6496.0630, 1039.3701, 1011.3189);
	angles[11] = (0, 90, 0);
	at[11] = 3.9500;
	points[12] = (6496.0630, 1039.3701, 1017.2244);
	angles[12] = (0, 90, 0);
	at[12] = 4;
	points[13] = (6496.0630, 1039.3701, 1150.0984);
	angles[13] = (0, 90, 0);
	at[13] = 4.1500;
	points[14] = (6496.0630, 1039.3701, 1119.9803);
	angles[14] = (0, 90, 0);
	at[14] = 4.2000;
	points[15] = (6496.0630, 1039.3701, 1044.6851);
	angles[15] = (0, 90, 0);
	at[15] = 4.2500;
	points[16] = (6496.0630, 1039.3701, 924.2126);
	angles[16] = (0, 90, 0);
	at[16] = 4.3000;
	points[17] = (6496.0630, 1039.3701, 876.9685);
	angles[17] = (0, 90, 0);
	at[17] = 4.3500;
	points[18] = (6496.0630, 1039.3701, 876.9685);
	angles[18] = (0, 90, 0);
	at[18] = 5.3000;
	points[19] = (6496.0630, 1039.3701, 882.8740);
	angles[19] = (0, 90, 0);
	at[19] = 5.3500;
	points[20] = (6496.0630, 1039.3701, 1006.8898);
	angles[20] = (0, 90, 0);
	at[20] = 6.0500;
	points[21] = (6496.0630, 1039.3701, 1006.8898);
	angles[21] = (0, 90, 0);
	at[21] = 6.0833;
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
	points[0] = (5196.8506, 1364.1733, 1091.0433);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (5196.8506, 1364.1733, 1135.3346);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (5196.8506, 1364.1733, 1135.0394);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (5196.8506, 1364.1733, 1074.8031);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (5196.8506, 1364.1733, 969.3898);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (5196.8506, 1364.1733, 876.9685);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (5196.8506, 1364.1733, 876.9685);
	angles[6] = (0, 90, 0);
	at[6] = 1.2000;
	points[7] = (5196.8506, 1364.1733, 879.9213);
	angles[7] = (0, 90, 0);
	at[7] = 1.2500;
	points[8] = (5196.8506, 1364.1733, 1003.9370);
	angles[8] = (0, 90, 0);
	at[8] = 1.9500;
	points[9] = (5196.8506, 1364.1733, 1006.8898);
	angles[9] = (0, 90, 0);
	at[9] = 2;
	points[10] = (5196.8506, 1364.1733, 1006.8898);
	angles[10] = (0, 90, 0);
	at[10] = 5.4500;
	points[11] = (5196.8506, 1364.1733, 1014.5630);
	angles[11] = (0, 90, 0);
	at[11] = 5.5000;
	points[12] = (5196.8506, 1364.1733, 1011.3189);
	angles[12] = (0, 90, 0);
	at[12] = 5.5500;
	points[13] = (5196.8506, 1364.1733, 999.2166);
	angles[13] = (0, 90, 0);
	at[13] = 5.6000;
	points[14] = (5196.8506, 1364.1733, 1002.4606);
	angles[14] = (0, 90, 0);
	at[14] = 5.6500;
	points[15] = (5196.8506, 1364.1733, 1014.5630);
	angles[15] = (0, 90, 0);
	at[15] = 5.7000;
	points[16] = (5196.8506, 1364.1733, 1011.3189);
	angles[16] = (0, 90, 0);
	at[16] = 5.7500;
	points[17] = (5196.8506, 1364.1733, 999.2166);
	angles[17] = (0, 90, 0);
	at[17] = 5.8000;
	points[18] = (5196.8506, 1364.1733, 1002.4606);
	angles[18] = (0, 90, 0);
	at[18] = 5.8500;
	points[19] = (5196.8506, 1364.1733, 1014.5630);
	angles[19] = (0, 90, 0);
	at[19] = 5.9000;
	points[20] = (5196.8506, 1364.1733, 1011.3189);
	angles[20] = (0, 90, 0);
	at[20] = 5.9500;
	points[21] = (5196.8506, 1364.1733, 1017.2244);
	angles[21] = (0, 90, 0);
	at[21] = 6;
	points[22] = (5196.8506, 1364.1733, 1091.0433);
	angles[22] = (0, 90, 0);
	at[22] = 6.0833;
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
	points[0] = (3897.6379, 1039.3583, 1006.8898);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (3897.6379, 1039.3583, 1006.8898);
	angles[1] = (0, 90, 0);
	at[1] = 1.3500;
	points[2] = (3897.6379, 1039.3583, 1014.5630);
	angles[2] = (0, 90, 0);
	at[2] = 1.4500;
	points[3] = (3897.6379, 1039.3583, 1002.4606);
	angles[3] = (0, 90, 0);
	at[3] = 1.5000;
	points[4] = (3897.6379, 1039.3583, 999.2166);
	angles[4] = (0, 90, 0);
	at[4] = 1.5500;
	points[5] = (3897.6379, 1039.3583, 1011.3189);
	angles[5] = (0, 90, 0);
	at[5] = 1.6000;
	points[6] = (3897.6379, 1039.3583, 1014.5630);
	angles[6] = (0, 90, 0);
	at[6] = 1.6500;
	points[7] = (3897.6379, 1039.3583, 1002.4606);
	angles[7] = (0, 90, 0);
	at[7] = 1.7000;
	points[8] = (3897.6379, 1039.3583, 999.2166);
	angles[8] = (0, 90, 0);
	at[8] = 1.7500;
	points[9] = (3897.6379, 1039.3583, 1011.3189);
	angles[9] = (0, 90, 0);
	at[9] = 1.8000;
	points[10] = (3897.6379, 1039.3583, 1014.5630);
	angles[10] = (0, 90, 0);
	at[10] = 1.8500;
	points[11] = (3897.6379, 1039.3583, 1002.4606);
	angles[11] = (0, 90, 0);
	at[11] = 1.9000;
	points[12] = (3897.6379, 1039.3583, 1135.3346);
	angles[12] = (0, 90, 0);
	at[12] = 2.0500;
	points[13] = (3897.6379, 1039.3583, 1135.0394);
	angles[13] = (0, 90, 0);
	at[13] = 2.1000;
	points[14] = (3897.6379, 1039.3583, 1074.8031);
	angles[14] = (0, 90, 0);
	at[14] = 2.1500;
	points[15] = (3897.6379, 1039.3583, 969.3898);
	angles[15] = (0, 90, 0);
	at[15] = 2.2000;
	points[16] = (3897.6379, 1039.3583, 876.9685);
	angles[16] = (0, 90, 0);
	at[16] = 2.2500;
	points[17] = (3897.6379, 1039.3583, 876.9685);
	angles[17] = (0, 90, 0);
	at[17] = 3.2000;
	points[18] = (3897.6379, 1039.3583, 879.9213);
	angles[18] = (0, 90, 0);
	at[18] = 3.2500;
	points[19] = (3897.6379, 1039.3583, 1003.9370);
	angles[19] = (0, 90, 0);
	at[19] = 3.9500;
	points[20] = (3897.6379, 1039.3583, 1006.8898);
	angles[20] = (0, 90, 0);
	at[20] = 4;
	points[21] = (3897.6379, 1039.3583, 1006.8898);
	angles[21] = (0, 90, 0);
	at[21] = 6.0833;
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
	points[0] = (4843.9766, 2969.2874, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4843.9766, 2969.2874, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (4843.9766, 2969.2874, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (4843.9766, 2969.2874, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (4843.9766, 2969.2874, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (4843.9766, 2969.2874, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (4843.9766, 2969.2874, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (4843.9766, 2969.2874, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (4843.9766, 2969.2874, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (4843.9766, 2969.2874, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (4843.9766, 2969.2874, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (4843.9766, 2969.2874, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (4843.9766, 2969.2874, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (4843.9766, 2969.2874, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (4843.9766, 2969.2874, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (4843.9766, 2969.2874, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (4843.9766, 2969.2874, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (4843.9766, 2969.2874, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (4843.9766, 2969.2874, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (4843.9766, 2969.2874, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (4843.9766, 2969.2874, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (4843.9766, 2969.2874, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (4843.9766, 2969.2874, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (4843.9766, 2969.2874, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (4843.9766, 2969.2874, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (4843.9766, 2969.2874, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (806.9370, 926.0433, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (806.9370, 926.0433, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (806.9370, 926.0433, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (806.9370, 926.0433, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (806.9370, 926.0433, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (806.9370, 926.0433, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (806.9370, 926.0433, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (806.9370, 926.0433, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (806.9370, 926.0433, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (806.9370, 926.0433, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (806.9370, 926.0433, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (806.9370, 926.0433, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (806.9370, 926.0433, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (806.9370, 926.0433, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (806.9370, 926.0433, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (806.9370, 926.0433, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (806.9370, 926.0433, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (806.9370, 926.0433, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (806.9370, 926.0433, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (806.9370, 926.0433, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (806.9370, 926.0433, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (806.9370, 926.0433, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (806.9370, 926.0433, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (806.9370, 926.0433, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (806.9370, 926.0433, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (806.9370, 926.0433, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-4331.4961, -3570.8704, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4331.4961, -3570.8704, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-4331.4961, -3570.8704, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-4331.4961, -3570.8704, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-4331.4961, -3570.8704, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-4331.4961, -3570.8704, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-4331.4961, -3570.8704, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-4331.4961, -3570.8704, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-4331.4961, -3570.8704, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-4331.4961, -3570.8704, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-4331.4961, -3570.8704, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-4331.4961, -3570.8704, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-4331.4961, -3570.8704, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-4331.4961, -3570.8704, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-4331.4961, -3570.8704, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-4331.4961, -3570.8704, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-4331.4961, -3570.8704, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-4331.4961, -3570.8704, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-4331.4961, -3570.8704, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-4331.4961, -3570.8704, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-4331.4961, -3570.8704, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-4331.4961, -3570.8704, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-4331.4961, -3570.8704, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-4331.4961, -3570.8704, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-4331.4961, -3570.8704, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-4331.4961, -3570.8704, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-6957.0474, 2450.3623, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6957.0474, 2450.3623, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-6957.0474, 2450.3623, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-6957.0474, 2450.3623, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-6957.0474, 2450.3623, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-6957.0474, 2450.3623, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-6957.0474, 2450.3623, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-6957.0474, 2450.3623, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-6957.0474, 2450.3623, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-6957.0474, 2450.3623, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-6957.0474, 2450.3623, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-6957.0474, 2450.3623, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-6957.0474, 2450.3623, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-6957.0474, 2450.3623, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-6957.0474, 2450.3623, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-6957.0474, 2450.3623, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-6957.0474, 2450.3623, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-6957.0474, 2450.3623, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-6957.0474, 2450.3623, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-6957.0474, 2450.3623, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-6957.0474, 2450.3623, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-6957.0474, 2450.3623, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-6957.0474, 2450.3623, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-6957.0474, 2450.3623, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-6957.0474, 2450.3623, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-6957.0474, 2450.3623, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-3724.1497, 2914.4607, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3724.1497, 2914.4607, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-3724.1497, 2914.4607, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-3724.1497, 2914.4607, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-3724.1497, 2914.4607, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-3724.1497, 2914.4607, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-3724.1497, 2914.4607, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-3724.1497, 2914.4607, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-3724.1497, 2914.4607, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-3724.1497, 2914.4607, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-3724.1497, 2914.4607, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-3724.1497, 2914.4607, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-3724.1497, 2914.4607, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-3724.1497, 2914.4607, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-3724.1497, 2914.4607, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-3724.1497, 2914.4607, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-3724.1497, 2914.4607, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-3724.1497, 2914.4607, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-3724.1497, 2914.4607, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-3724.1497, 2914.4607, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-3724.1497, 2914.4607, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-3724.1497, 2914.4607, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-3724.1497, 2914.4607, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-3724.1497, 2914.4607, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-3724.1497, 2914.4607, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-3724.1497, 2914.4607, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (4933.6221, 5994.4092, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4933.6221, 5994.4092, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (4933.6221, 5994.4092, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (4933.6221, 5994.4092, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (4933.6221, 5994.4092, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (4933.6221, 5994.4092, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (4933.6221, 5994.4092, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (4933.6221, 5994.4092, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (4933.6221, 5994.4092, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (4933.6221, 5994.4092, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (4933.6221, 5994.4092, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (4933.6221, 5994.4092, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (4933.6221, 5994.4092, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (4933.6221, 5994.4092, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (4933.6221, 5994.4092, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (4933.6221, 5994.4092, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (4933.6221, 5994.4092, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (4933.6221, 5994.4092, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (4933.6221, 5994.4092, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (4933.6221, 5994.4092, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (4933.6221, 5994.4092, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (4933.6221, 5994.4092, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (4933.6221, 5994.4092, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (4933.6221, 5994.4092, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (4933.6221, 5994.4092, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (4933.6221, 5994.4092, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-3613.9016, 6067.3228, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3613.9016, 6067.3228, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-3613.9016, 6067.3228, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-3613.9016, 6067.3228, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-3613.9016, 6067.3228, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-3613.9016, 6067.3228, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-3613.9016, 6067.3228, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-3613.9016, 6067.3228, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-3613.9016, 6067.3228, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-3613.9016, 6067.3228, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-3613.9016, 6067.3228, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-3613.9016, 6067.3228, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-3613.9016, 6067.3228, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-3613.9016, 6067.3228, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-3613.9016, 6067.3228, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-3613.9016, 6067.3228, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-3613.9016, 6067.3228, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-3613.9016, 6067.3228, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-3613.9016, 6067.3228, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-3613.9016, 6067.3228, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-3613.9016, 6067.3228, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-3613.9016, 6067.3228, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-3613.9016, 6067.3228, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-3613.9016, 6067.3228, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-3613.9016, 6067.3228, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-3613.9016, 6067.3228, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-695.8661, -4704.1338, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-695.8661, -4704.1338, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-695.8661, -4704.1338, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-695.8661, -4704.1338, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-695.8661, -4704.1338, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-695.8661, -4704.1338, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-695.8661, -4704.1338, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-695.8661, -4704.1338, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-695.8661, -4704.1338, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-695.8661, -4704.1338, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-695.8661, -4704.1338, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-695.8661, -4704.1338, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-695.8661, -4704.1338, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-695.8661, -4704.1338, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-695.8661, -4704.1338, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-695.8661, -4704.1338, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-695.8661, -4704.1338, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-695.8661, -4704.1338, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-695.8661, -4704.1338, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-695.8661, -4704.1338, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-695.8661, -4704.1338, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-695.8661, -4704.1338, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-695.8661, -4704.1338, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-695.8661, -4704.1338, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-695.8661, -4704.1338, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-695.8661, -4704.1338, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-4351.7324, -7431.3784, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4351.7324, -7431.3784, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-4351.7324, -7431.3784, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-4351.7324, -7431.3784, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-4351.7324, -7431.3784, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-4351.7324, -7431.3784, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-4351.7324, -7431.3784, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-4351.7324, -7431.3784, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-4351.7324, -7431.3784, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-4351.7324, -7431.3784, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-4351.7324, -7431.3784, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-4351.7324, -7431.3784, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-4351.7324, -7431.3784, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-4351.7324, -7431.3784, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-4351.7324, -7431.3784, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-4351.7324, -7431.3784, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-4351.7324, -7431.3784, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-4351.7324, -7431.3784, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-4351.7324, -7431.3784, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-4351.7324, -7431.3784, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-4351.7324, -7431.3784, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-4351.7324, -7431.3784, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-4351.7324, -7431.3784, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-4351.7324, -7431.3784, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-4351.7324, -7431.3784, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-4351.7324, -7431.3784, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-7490.4331, -1607.1497, -7324.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7490.4331, -1607.1497, -7324.0947);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-7490.4331, -1607.1497, -6627.4014);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-7490.4331, -1607.1497, -5880);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-7490.4331, -1607.1497, -5172.2837);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-7490.4331, -1607.1497, -4504.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-7490.4331, -1607.1497, -3875.9253);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-7490.4331, -1607.1497, -3287.2637);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-7490.4331, -1607.1497, -2738.2874);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-7490.4331, -1607.1497, -2228.9961);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-7490.4331, -1607.1497, -1759.3898);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-7490.4331, -1607.1497, -1329.4686);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-7490.4331, -1607.1497, -939.2323);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-7490.4331, -1607.1497, -588.6812);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-7490.4331, -1607.1497, -277.8146);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-7490.4331, -1607.1497, -6.6334);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-7490.4331, -1607.1497, 224.8626);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-7490.4331, -1607.1497, 416.6732);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-7490.4331, -1607.1497, 568.7993);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-7490.4331, -1607.1497, 681.2401);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-7490.4331, -1607.1497, 753.9961);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-7490.4331, -1607.1497, 787.0670);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-7490.4331, -1607.1497, 789.2717);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-7490.4331, -1607.1497, -7280);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-7490.4331, -1607.1497, -7324.0947);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-7490.4331, -1607.1497, -7324.0947);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
	mover = getEnt("iz_obj_14", "targetname");
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
