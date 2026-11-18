main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ct_coolcastlecanyon", 0);

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
	ambientPlay("iz_0_strm_n_water", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4643.2441, -3533.2146, 1413.5669), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4750.8276, -2923.0044, 1320.1830), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4858.4116, -2312.7937, 1226.7992), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4718.4785, -1684.2560, 1156.7494), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4578.5459, -1055.7183, 1086.6998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-3962.1143, -329.0182, 834.7382), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-3436.7019, 205.3661, 608.6929), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-2911.2896, 739.7504, 382.6476), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-2752.5547, 1480.5309, 193.1442), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-2593.8193, 2221.3113, 3.6407), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-793.9045, -4039.3289, 2876.6221), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-830.9891, -3319.8809, 2766.0032), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-163.4607, -2385.3398, 2622.1091), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (764.8149, -6882.3364, 2764.3318), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (83.8249, -6861.3838, 2196.9685), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-762.9611, -6982.2632, 1609.1929), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4783.5679, 11790.8555, 1907.1586), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4303.9165, 12249.6523, 1741.9753), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-3824.2646, 12708.4492, 1576.7922), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-3031.7979, 13042.1201, 1378.9265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-2239.3313, 13375.7900, 1181.0610), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (6026.0400, -11201.2822, 2743.2104), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (5168.9790, -11723.8818, 2558.6130), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (4458.2466, -11901.5635, 2572.6565), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (3747.5139, -12079.2461, 2586.6997), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (2806.8374, -11912.0127, 2576.3032), 0, 12.0104);
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
