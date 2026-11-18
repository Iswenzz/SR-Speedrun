main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ct_skyline_avenue", 0);

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
	ambientPlay("iz_0_strm_n_ridgehighway", 2);
	level thread iz_music("iz_9_se_cn_tge_env_buildi");
	iz_emitter("iz_1_se_cc_env_river", (-723.1287, 24846.7949, 2047.0308), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-716.6152, 25656.2012, 2049.5413), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-982.7035, 26347.9570, 2078.8860), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-1554.5687, 26829.1719, 2149.4961), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-2210.9397, 26985.8496, 2233.1238), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-2911.5122, 26789.6719, 2321.8066), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-3455.7578, 26319.9512, 2388.9646), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-3706.4172, 25567.3672, 2418.3948), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-3702.4280, 24800.5684, 2521.1062), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-1815.1818, 15060.3779, 4720.4736), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-1415.4349, 14784.6924, 4937.2559), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-1026.9762, 14508.8232, 5149.8984), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-512.5034, 14122.1221, 5236.5444), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (115.2111, 13714.7070, 5236.5444), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (744.9720, 13183.1250, 5236.5444), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1049.4331, 12521.9785, 5236.5444), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1084.6606, 11754.7793, 5236.5444), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1062.9922, 3419.9614, 3206.9763), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1062.9922, 2561.8994, 2968.2048), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1062.9922, 1737.7015, 2551.4270), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1062.9922, 958.4681, 1778.6953), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1062.9922, 54.8842, 1778.6953), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1062.9922, -770.4293, 1778.6953), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (593.2119, -1181.1024, 1778.6953), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-355.8953, -1181.1024, 1778.6953), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (671.1251, 3347.9702, 2340.2007), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (1403.3572, 3443.3208, 2355.3040), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (2110.6733, 3813.6143, 2399.2361), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (2504.6353, 4453.9194, 2475.3103), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (2618.8767, 5174.5244, 2571.7900), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (2475.5857, 5901.6021, 2665.9153), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (1858.4276, 6532.3579, 2747.3496), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (1006.2903, 6803.4297, 2776.7646), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (406.1014, 6818.5171, 2776.7686), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (-194.0876, 6833.6045, 2776.7725), 0, 12.0104);
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
