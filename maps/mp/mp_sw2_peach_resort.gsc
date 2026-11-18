main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_peach_resort", 0);

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
	ambientPlay("iz_0_sw2pr", 2);
	iz_emitter("iz_1_se_cc_env_sea", (3986.2205, -9274.6064, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (1993.1102, -9274.6064, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (0, -9274.6064, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-1993.1102, -9274.6064, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-3986.2205, -9274.6064, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-4517.7168, -7419.6855, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-5049.2129, -5564.7637, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-5580.7085, -3709.8423, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6112.2046, -1854.9211, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6643.7007, 0, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6510.8267, 1793.7992, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6377.9526, 3587.5984, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6245.0786, 5381.3975, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6112.2046, 7175.1968, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-4185.5317, 7906.0039, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2258.8584, 8636.8115, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-332.1851, 9367.6182, 2697.3425), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (1594.4882, 10098.4258, 2697.3425), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-948, -3687, 2657);
	level.iz_route[level.iz_route.size] = (-816, -5303, 2657);
	level.iz_route[level.iz_route.size] = (-138, -7057, 2696);
	level.iz_route[level.iz_route.size] = (136, -8758, 2974);
	level.iz_route[level.iz_route.size] = (416, -10854, 3344);
	level.iz_route[level.iz_route.size] = (637, -12521, 3626);
	level.iz_route[level.iz_route.size] = (1088, -13044, 3689);
	level.iz_route[level.iz_route.size] = (1907, -12917, 3743);
	level.iz_route[level.iz_route.size] = (2357, -12224, 3792);
	level.iz_route[level.iz_route.size] = (2333, -10775, 4051);
	level.iz_route[level.iz_route.size] = (2107, -9183, 4394);
	level.iz_route[level.iz_route.size] = (2093, -7839, 4657);
	level.iz_route[level.iz_route.size] = (2522, -7288, 4740);
	level.iz_route[level.iz_route.size] = (3293, -7169, 4794);
	level.iz_route[level.iz_route.size] = (3883, -7794, 4863);
	level.iz_route[level.iz_route.size] = (4119, -8678, 4890);
	level.iz_route[level.iz_route.size] = (4389, -9714, 4890);
	level.iz_route[level.iz_route.size] = (5074, -11381, 4890);
	level.iz_route[level.iz_route.size] = (5538, -12597, 4890);
	level.iz_route[level.iz_route.size] = (6193, -14192, 4757);
	level.iz_route[level.iz_route.size] = (6762, -15592, 4690);
	level.iz_route[level.iz_route.size] = (7234, -16652, 4624);
	level.iz_route[level.iz_route.size] = (7683, -18226, 4624);
	level.iz_route[level.iz_route.size] = (8447, -19786, 4624);
	level.iz_route[level.iz_route.size] = (9046, -20713, 4624);
	level.iz_route[level.iz_route.size] = (10015, -21094, 4624);
	level.iz_route[level.iz_route.size] = (10912, -20688, 4624);
	level.iz_route[level.iz_route.size] = (11329, -19742, 4624);
	level.iz_route[level.iz_route.size] = (11539, -18694, 4634);
	level.iz_route[level.iz_route.size] = (11216, -17883, 4912);
	level.iz_route[level.iz_route.size] = (10767, -16832, 4916);
	level.iz_route[level.iz_route.size] = (10266, -15524, 5018);
	level.iz_route[level.iz_route.size] = (9788, -14103, 5023);
	level.iz_route[level.iz_route.size] = (9257, -12933, 5023);
	level.iz_route[level.iz_route.size] = (8378, -8626, 3614);
	level.iz_route[level.iz_route.size] = (8204, -7799, 3199);
	level.iz_route[level.iz_route.size] = (6392, -4188, 3189);
	level.iz_route[level.iz_route.size] = (6050, -3423, 2773);
	level.iz_route[level.iz_route.size] = (5407, -1999, 2764);
	level.iz_route[level.iz_route.size] = (4985, -905, 2478);
	level.iz_route[level.iz_route.size] = (3914, 1232, 2178);
	level.iz_route[level.iz_route.size] = (3328, 2311, 1946);
	level.iz_route[level.iz_route.size] = (2861, 3278, 1705);
	level.iz_route[level.iz_route.size] = (2094, 6206, 1701);
	level.iz_route[level.iz_route.size] = (866, 9905, 1701);
	level.iz_route[level.iz_route.size] = (773, 12907, 1701);
	level.iz_route[level.iz_route.size] = (-986, 14381, 1701);
	level.iz_route[level.iz_route.size] = (-4239, 17316, 1825);
	level.iz_route[level.iz_route.size] = (-5474, 19220, 1701);
	level.iz_route[level.iz_route.size] = (-7839, 20534, 1701);
	level.iz_route[level.iz_route.size] = (-10322, 19445, 1701);
	level.iz_route[level.iz_route.size] = (-10454, 16601, 1701);
	level.iz_route[level.iz_route.size] = (-8688, 13680, 1701);
	level.iz_route[level.iz_route.size] = (-7768, 10331, 1701);
	level.iz_route[level.iz_route.size] = (-5796, 7662, 1701);
	level.iz_route[level.iz_route.size] = (-3153, 5759, 1860);
	level.iz_route[level.iz_route.size] = (-2317, 5323, 1860);
	level.iz_route[level.iz_route.size] = (-1543, 4787, 1860);
	level.iz_route[level.iz_route.size] = (-1126, 3999, 1860);
	level.iz_route[level.iz_route.size] = (-1035, 3088, 1863);
	level.iz_route[level.iz_route.size] = (-1016, 973, 2215);
	level.iz_route[level.iz_route.size] = (-1007, -861, 2488);
	level.iz_route[level.iz_route.size] = (-1055, -2481, 2640);
}
