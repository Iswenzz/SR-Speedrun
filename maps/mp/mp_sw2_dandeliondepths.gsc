main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_dandeliondepths", 0);

	setExpFog(8858.2676, 49751.9609, 1, 1, 1, 0);

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

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_sw2dd", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (1446.1979, -7719.1162, 5166.4102), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (1105.7003, -7762.9077, 4006.2610), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (1052.0254, -7767.4434, 3320.7979), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (998.3505, -7771.9785, 2635.3347), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (1873.7904, 5317.7690, 3582.4011), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (2978.8542, 7315.3682, 3540.6299), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (2849.1833, 8470.5605, 3507.1057), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (1938.4460, 9499.6689, 3423.9849), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (390.0980, 9538.5762, 3350.9685), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (-596.8234, 8752.8408, 3284.7212), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (-1583.7448, 7967.1060, 3218.4739), 0, 12.0104);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (8206, 1449, 5969);
	level.iz_route[level.iz_route.size] = (8214, 20, 5976);
	level.iz_route[level.iz_route.size] = (7923, -1149, 5974);
	level.iz_route[level.iz_route.size] = (6918, -1774, 5752);
	level.iz_route[level.iz_route.size] = (5620, -1691, 5562);
	level.iz_route[level.iz_route.size] = (1554, -768, 4947);
	level.iz_route[level.iz_route.size] = (233, -920, 4709);
	level.iz_route[level.iz_route.size] = (-700, -1787, 4542);
	level.iz_route[level.iz_route.size] = (-1115, -2923, 4391);
	level.iz_route[level.iz_route.size] = (-894, -4182, 4235);
	level.iz_route[level.iz_route.size] = (-359, -5187, 4068);
	level.iz_route[level.iz_route.size] = (789, -5711, 3881);
	level.iz_route[level.iz_route.size] = (1811, -5616, 3719);
	level.iz_route[level.iz_route.size] = (2601, -5080, 3597);
	level.iz_route[level.iz_route.size] = (3160, -4085, 3426);
	level.iz_route[level.iz_route.size] = (3320, -3059, 3270);
	level.iz_route[level.iz_route.size] = (2979, -2102, 3176);
	level.iz_route[level.iz_route.size] = (1961, -1007, 3158);
	level.iz_route[level.iz_route.size] = (508, 278, 3158);
	level.iz_route[level.iz_route.size] = (-662, 1152, 3159);
	level.iz_route[level.iz_route.size] = (-1673, 1408, 3159);
	level.iz_route[level.iz_route.size] = (-2640, 1224, 3137);
	level.iz_route[level.iz_route.size] = (-4526, 771, 3028);
	level.iz_route[level.iz_route.size] = (-5167, 928, 2999);
	level.iz_route[level.iz_route.size] = (-5594, 1361, 2966);
	level.iz_route[level.iz_route.size] = (-6099, 2238, 2922);
	level.iz_route[level.iz_route.size] = (-6571, 3218, 2898);
	level.iz_route[level.iz_route.size] = (-6967, 4620, 2883);
	level.iz_route[level.iz_route.size] = (-7640, 5566, 2911);
	level.iz_route[level.iz_route.size] = (-8503, 6268, 3042);
	level.iz_route[level.iz_route.size] = (-9524, 6397, 3180);
	level.iz_route[level.iz_route.size] = (-10169, 5879, 3183);
	level.iz_route[level.iz_route.size] = (-10422, 5093, 3126);
	level.iz_route[level.iz_route.size] = (-10294, 4145, 3055);
	level.iz_route[level.iz_route.size] = (-9974, 3252, 2987);
	level.iz_route[level.iz_route.size] = (-9467, 2477, 2928);
	level.iz_route[level.iz_route.size] = (-9193, 2143, 2895);
	level.iz_route[level.iz_route.size] = (-8134, 558, 2594);
	level.iz_route[level.iz_route.size] = (-5730, -1444, 2326);
	level.iz_route[level.iz_route.size] = (-2130, -4654, 1824);
	level.iz_route[level.iz_route.size] = (-604, -6213, 1523);
	level.iz_route[level.iz_route.size] = (1899, -6250, 1331);
	level.iz_route[level.iz_route.size] = (4753, -5696, 1339);
	level.iz_route[level.iz_route.size] = (5446, -4573, 1380);
	level.iz_route[level.iz_route.size] = (6995, -3561, 2161);
	level.iz_route[level.iz_route.size] = (7375, -2862, 2604);
	level.iz_route[level.iz_route.size] = (7022, -1914, 2956);
	level.iz_route[level.iz_route.size] = (7424, -1302, 3375);
	level.iz_route[level.iz_route.size] = (8538, -867, 3928);
	level.iz_route[level.iz_route.size] = (8945, -118, 4422);
	level.iz_route[level.iz_route.size] = (9080, 1299, 5157);
	level.iz_route[level.iz_route.size] = (9479, 1944, 5546);
	level.iz_route[level.iz_route.size] = (10485, 3575, 5755);
	level.iz_route[level.iz_route.size] = (11143, 4821, 5894);
	level.iz_route[level.iz_route.size] = (11212, 6174, 6020);
	level.iz_route[level.iz_route.size] = (10466, 7221, 6133);
	level.iz_route[level.iz_route.size] = (9222, 7607, 6193);
	level.iz_route[level.iz_route.size] = (8089, 7133, 6183);
	level.iz_route[level.iz_route.size] = (7710, 6022, 6099);
	level.iz_route[level.iz_route.size] = (7805, 4901, 6027);
	level.iz_route[level.iz_route.size] = (8052, 3504, 5977);
}
