main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_beta_waluigipinball", 0);

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
	ambientPlay("iz_0_dswp", 2);
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
	level.iz_route[level.iz_route.size] = (-5629, 12809, 4152);
	level.iz_route[level.iz_route.size] = (-5629, 8763, 4229);
	level.iz_route[level.iz_route.size] = (-5629, -10180, 13226);
	level.iz_route[level.iz_route.size] = (-5629, -10703, 13019);
	level.iz_route[level.iz_route.size] = (-5629, -11267, 12842);
	level.iz_route[level.iz_route.size] = (-5629, -12087, 12665);
	level.iz_route[level.iz_route.size] = (-5627, -12713, 12665);
	level.iz_route[level.iz_route.size] = (-5629, -13183, 12665);
	level.iz_route[level.iz_route.size] = (-5350, -13619, 12665);
	level.iz_route[level.iz_route.size] = (-4766, -14245, 12665);
	level.iz_route[level.iz_route.size] = (-4008, -14655, 12665);
	level.iz_route[level.iz_route.size] = (-3128, -14764, 12665);
	level.iz_route[level.iz_route.size] = (-2295, -14704, 12665);
	level.iz_route[level.iz_route.size] = (-1410, -14474, 12665);
	level.iz_route[level.iz_route.size] = (-724, -14088, 12665);
	level.iz_route[level.iz_route.size] = (-203, -13518, 12665);
	level.iz_route[level.iz_route.size] = (0, -13183, 12665);
	level.iz_route[level.iz_route.size] = (0, -11853, 12665);
	level.iz_route[level.iz_route.size] = (0, -10900, 13016);
	level.iz_route[level.iz_route.size] = (0, -9585, 12244);
	level.iz_route[level.iz_route.size] = (0, -7771, 11192);
	level.iz_route[level.iz_route.size] = (-425, -6915, 10862);
	level.iz_route[level.iz_route.size] = (-1452, -6464, 10689);
	level.iz_route[level.iz_route.size] = (-1980, -6601, 10741);
	level.iz_route[level.iz_route.size] = (-2660, -6522, 10710);
	level.iz_route[level.iz_route.size] = (-3001, -6346, 10643);
	level.iz_route[level.iz_route.size] = (-3254, -6103, 10549);
	level.iz_route[level.iz_route.size] = (-3342, -5757, 10416);
	level.iz_route[level.iz_route.size] = (-3327, -4869, 10074);
	level.iz_route[level.iz_route.size] = (-3234, -4517, 9939);
	level.iz_route[level.iz_route.size] = (-3000, -4066, 9765);
	level.iz_route[level.iz_route.size] = (-2659, -3791, 9659);
	level.iz_route[level.iz_route.size] = (-2075, -3572, 9574);
	level.iz_route[level.iz_route.size] = (-981, -3509, 9550);
	level.iz_route[level.iz_route.size] = (44, -3857, 9679);
	level.iz_route[level.iz_route.size] = (850, -4485, 9926);
	level.iz_route[level.iz_route.size] = (1628, -5271, 10229);
	level.iz_route[level.iz_route.size] = (2038, -5504, 10319);
	level.iz_route[level.iz_route.size] = (2547, -5603, 10357);
	level.iz_route[level.iz_route.size] = (2913, -5430, 10292);
	level.iz_route[level.iz_route.size] = (3176, -5120, 10175);
	level.iz_route[level.iz_route.size] = (3330, -4755, 10030);
	level.iz_route[level.iz_route.size] = (3369, -4284, 9849);
	level.iz_route[level.iz_route.size] = (3369, -3769, 9650);
	level.iz_route[level.iz_route.size] = (3369, -3192, 9443);
	level.iz_route[level.iz_route.size] = (3369, -1918, 9317);
	level.iz_route[level.iz_route.size] = (3369, -531, 9317);
	level.iz_route[level.iz_route.size] = (3369, 549, 9317);
	level.iz_route[level.iz_route.size] = (3369, 1406, 9317);
	level.iz_route[level.iz_route.size] = (3181, 2085, 9317);
	level.iz_route[level.iz_route.size] = (2996, 2433, 9317);
	level.iz_route[level.iz_route.size] = (2735, 2727, 9317);
	level.iz_route[level.iz_route.size] = (2402, 2884, 9316);
	level.iz_route[level.iz_route.size] = (2001, 2877, 9312);
	level.iz_route[level.iz_route.size] = (1685, 2671, 9305);
	level.iz_route[level.iz_route.size] = (1442, 2360, 9290);
	level.iz_route[level.iz_route.size] = (800, 1366, 9153);
	level.iz_route[level.iz_route.size] = (598, 1116, 9114);
	level.iz_route[level.iz_route.size] = (245, 905, 9057);
	level.iz_route[level.iz_route.size] = (-164, 837, 8993);
	level.iz_route[level.iz_route.size] = (-545, 943, 8928);
	level.iz_route[level.iz_route.size] = (-880, 1149, 8869);
	level.iz_route[level.iz_route.size] = (-1213, 1581, 8811);
	level.iz_route[level.iz_route.size] = (-1907, 2556, 8767);
	level.iz_route[level.iz_route.size] = (-2119, 2783, 8762);
	level.iz_route[level.iz_route.size] = (-2398, 2889, 8757);
	level.iz_route[level.iz_route.size] = (-2811, 2837, 8749);
	level.iz_route[level.iz_route.size] = (-3153, 2613, 8742);
	level.iz_route[level.iz_route.size] = (-3319, 2331, 8739);
	level.iz_route[level.iz_route.size] = (-3443, 2013, 8735);
	level.iz_route[level.iz_route.size] = (-3549, 1558, 8709);
	level.iz_route[level.iz_route.size] = (-3549, 716, 8567);
	level.iz_route[level.iz_route.size] = (-3549, -5, 8416);
	level.iz_route[level.iz_route.size] = (-3549, -812, 8329);
	level.iz_route[level.iz_route.size] = (-3447, -1288, 8409);
	level.iz_route[level.iz_route.size] = (-3212, -1583, 8482);
	level.iz_route[level.iz_route.size] = (-2838, -1721, 8516);
	level.iz_route[level.iz_route.size] = (-2153, -1800, 8536);
	level.iz_route[level.iz_route.size] = (-1691, -1800, 8536);
	level.iz_route[level.iz_route.size] = (-1224, -1800, 8536);
	level.iz_route[level.iz_route.size] = (-682, -1800, 8537);
	level.iz_route[level.iz_route.size] = (-330, -1712, 8516);
	level.iz_route[level.iz_route.size] = (0, -1393, 8435);
	level.iz_route[level.iz_route.size] = (0, 78, 8068);
	level.iz_route[level.iz_route.size] = (0, 1020, 7833);
	level.iz_route[level.iz_route.size] = (0, 1871, 7621);
	level.iz_route[level.iz_route.size] = (0, 2604, 7438);
	level.iz_route[level.iz_route.size] = (0, 3327, 7258);
	level.iz_route[level.iz_route.size] = (0, 3711, 7162);
	level.iz_route[level.iz_route.size] = (0, 4080, 7070);
	level.iz_route[level.iz_route.size] = (0, 4386, 7106);
	level.iz_route[level.iz_route.size] = (0, 4709, 7110);
	level.iz_route[level.iz_route.size] = (0, 5013, 6973);
	level.iz_route[level.iz_route.size] = (0, 5258, 6777);
	level.iz_route[level.iz_route.size] = (0, 5659, 6677);
	level.iz_route[level.iz_route.size] = (0, 6058, 6577);
	level.iz_route[level.iz_route.size] = (-21, 6552, 6454);
	level.iz_route[level.iz_route.size] = (-60, 8056, 4900);
	level.iz_route[level.iz_route.size] = (-35, 8797, 4812);
	level.iz_route[level.iz_route.size] = (0, 9310, 4752);
	level.iz_route[level.iz_route.size] = (0, 9982, 4672);
	level.iz_route[level.iz_route.size] = (0, 10525, 4598);
	level.iz_route[level.iz_route.size] = (5, 11028, 4487);
	level.iz_route[level.iz_route.size] = (0, 11447, 4354);
	level.iz_route[level.iz_route.size] = (196, 11887, 4291);
	level.iz_route[level.iz_route.size] = (791, 12102, 4291);
	level.iz_route[level.iz_route.size] = (1357, 12102, 4291);
	level.iz_route[level.iz_route.size] = (2131, 12102, 4291);
	level.iz_route[level.iz_route.size] = (2837, 12102, 4291);
	level.iz_route[level.iz_route.size] = (3559, 12102, 4291);
	level.iz_route[level.iz_route.size] = (4220, 12102, 4291);
	level.iz_route[level.iz_route.size] = (4881, 12153, 4291);
	level.iz_route[level.iz_route.size] = (5266, 12525, 4291);
	level.iz_route[level.iz_route.size] = (5266, 12958, 4291);
	level.iz_route[level.iz_route.size] = (5266, 13413, 4291);
	level.iz_route[level.iz_route.size] = (5266, 13897, 4291);
	level.iz_route[level.iz_route.size] = (5266, 14335, 4291);
	level.iz_route[level.iz_route.size] = (5266, 14757, 4291);
	level.iz_route[level.iz_route.size] = (5266, 15141, 4291);
	level.iz_route[level.iz_route.size] = (5266, 15584, 4291);
	level.iz_route[level.iz_route.size] = (5266, 15950, 4291);
	level.iz_route[level.iz_route.size] = (4881, 16228, 4291);
	level.iz_route[level.iz_route.size] = (4220, 16228, 4291);
	level.iz_route[level.iz_route.size] = (3450, 16228, 4291);
	level.iz_route[level.iz_route.size] = (2575, 16228, 4291);
	level.iz_route[level.iz_route.size] = (1875, 16228, 4291);
	level.iz_route[level.iz_route.size] = (1268, 16412, 4291);
	level.iz_route[level.iz_route.size] = (725, 16539, 4291);
	level.iz_route[level.iz_route.size] = (315, 16594, 4152);
	level.iz_route[level.iz_route.size] = (-557, 16732, 4152);
	level.iz_route[level.iz_route.size] = (-943, 16789, 4152);
	level.iz_route[level.iz_route.size] = (-4692, 16789, 4152);
	level.iz_route[level.iz_route.size] = (-5410, 16477, 4152);
	level.iz_route[level.iz_route.size] = (-5574, 15793, 4152);
}
