main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ct_shyguylumberco", 0);

	setExpFog(0, 5237.6963, 0.2745, 0.4000, 0.4588, 0);

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
	ambientPlay("iz_0_r_64_jungle32", 2);
	iz_emitter("iz_1_se_cn_bdx_lift", (1943.4030, -1335.3381, 5930.9292), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (1152.7262, -925.3435, 5833.4312), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (362.0495, -515.3491, 5735.9331), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-428.6270, -105.3546, 5638.4351), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1008.0062, 723.2188, 5632.6030), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1042.9429, 1185.5767, 5627.9941), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1317.6758, 2240.1401, 5554.8457), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1340.7429, 2970.7805, 5554.8457), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1363.8101, 3701.4211, 5554.8457), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-851.4677, 4159.8252, 5220.9570), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-276.1995, 4212.7114, 5170.2964), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (518.1269, 4601.9526, 4914.2554), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (1312.4532, 4991.1938, 4658.2144), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (2516.4348, 5659.3481, 4685.9604), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (3498.6968, 6211.5059, 4737.1328), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4211.5439, 6965.4429, 4716.3604), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4924.3916, 7719.3799, 4695.5879), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (5637.2388, 8473.3164, 4674.8149), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (6320.2188, 9038.2383, 4898.8599), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (7003.1987, 9603.1592, 5122.9048), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (7627.8379, 10036.1006, 5587.7144), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8252.4775, 10469.0430, 6052.5239), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8444.6016, 11209.3203, 6101.0669), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8636.7256, 11949.5986, 6149.6099), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9409.6240, 12054.1416, 6147.8623), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9636.4004, 11211.9756, 5738.0835), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9790.7158, 10490.9199, 5328.3037), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9984.2959, 9881.2559, 4885.3906), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (10177.8770, 9271.5908, 4442.4775), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (10380.2383, 8496.0234, 4293.6416), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (10582.5996, 7720.4556, 4144.8062), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (10784.9619, 6944.8877, 3995.9702), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (10990.2783, 6116.5249, 3995.9702), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (11164.5312, 5254.6807, 4527.1787), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (11338.7842, 4392.8374, 5058.3877), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (11513.0381, 3530.9941, 5589.5962), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (11544.9473, 2965.6624, 5569.7334), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (12067.4736, 2384.1396, 5154.5464), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (11040.0127, 2009.0205, 5029.8569), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (10185.6826, 1742.7976, 5029.8569), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9190.4404, 1420.5425, 5276.6636), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8195.1992, 1098.2872, 5523.4697), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (7493.5483, 641.6812, 5523.4697), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (6791.8970, 185.0751, 5523.4697), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (5757.8477, -181.9756, 5523.4697), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4926.6021, -445.8812, 5523.4697), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4145.2988, -677.8858, 5581.5532), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (3363.9954, -909.8906, 5639.6372), 0, 12.0104);
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
