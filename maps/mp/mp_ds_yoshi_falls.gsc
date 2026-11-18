main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_yoshi_falls", 0);

	setExpFog(8858.2676, 23314.4688, 0.5882, 0.8314, 1, 0);

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
	ambientPlay("iz_0_r_ds_jungle32", 2);
	level thread iz_music("iz_9_se_cr_dsy_env_birds");
	iz_emitter("iz_1_se_cc_env_river", (4665.3545, -10644.6855, 3845.8384), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4062.9924, -9897.6387, 3646.4490), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3460.6304, -9150.5918, 3447.0593), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (2858.2676, -8403.5430, 3247.6697), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (2255.9058, -7656.4966, 3048.2803), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1653.5433, -6909.4487, 2848.8904), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_river_l", (-5610.2363, -3366.1418, 3618.6750), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_river_l", (-3757.3818, -3366.1418, 3199.4185), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_river_l", (-1904.5276, -3366.1418, 2780.1621), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-8932.0869, 8267.7168, 4218.7847), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-8090.5513, 7549.2129, 4026.5374), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-7249.0151, 6830.7080, 3834.2905), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-6407.4805, 6112.2046, 3642.0435), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-5565.9448, 5393.7007, 3449.7959), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-4724.4097, 4675.1968, 3257.5491), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (-3882.8740, 3956.6929, 3065.3018), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (3730, -3972, 3368);
	level.iz_route[level.iz_route.size] = (3720, -4961, 3366);
	level.iz_route[level.iz_route.size] = (3519, -6984, 3368);
	level.iz_route[level.iz_route.size] = (3120, -7629, 3395);
	level.iz_route[level.iz_route.size] = (2456, -8448, 3395);
	level.iz_route[level.iz_route.size] = (1475, -9050, 3368);
	level.iz_route[level.iz_route.size] = (99, -8844, 3368);
	level.iz_route[level.iz_route.size] = (-1501, -8265, 3355);
	level.iz_route[level.iz_route.size] = (-2739, -6739, 3338);
	level.iz_route[level.iz_route.size] = (-3460, -5307, 3368);
	level.iz_route[level.iz_route.size] = (-3500, -4786, 3395);
	level.iz_route[level.iz_route.size] = (-3462, -3728, 3395);
	level.iz_route[level.iz_route.size] = (-3460, -2565, 3395);
	level.iz_route[level.iz_route.size] = (-3464, -1439, 3368);
	level.iz_route[level.iz_route.size] = (-3518, -72, 3357);
	level.iz_route[level.iz_route.size] = (-4649, 736, 3345);
	level.iz_route[level.iz_route.size] = (-5432, 1656, 3344);
	level.iz_route[level.iz_route.size] = (-6307, 3123, 3519);
	level.iz_route[level.iz_route.size] = (-6277, 3611, 3602);
	level.iz_route[level.iz_route.size] = (-5793, 4500, 3872);
	level.iz_route[level.iz_route.size] = (-4997, 5313, 3899);
	level.iz_route[level.iz_route.size] = (-4056, 6015, 3712);
	level.iz_route[level.iz_route.size] = (-2909, 6096, 3478);
	level.iz_route[level.iz_route.size] = (-1873, 5703, 3396);
	level.iz_route[level.iz_route.size] = (-411, 4930, 3391);
	level.iz_route[level.iz_route.size] = (1305, 5037, 3373);
	level.iz_route[level.iz_route.size] = (2874, 4127, 3385);
	level.iz_route[level.iz_route.size] = (3318, 2167, 3373);
	level.iz_route[level.iz_route.size] = (3641, 257, 3368);
	level.iz_route[level.iz_route.size] = (3733, -1461, 3368);
}
