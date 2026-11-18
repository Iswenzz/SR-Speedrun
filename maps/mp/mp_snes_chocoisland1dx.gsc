main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_chocoisland1dx", 0);

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
	ambientPlay("iz_0_5_1", 2);
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
	level.iz_route[level.iz_route.size] = (5334, 3141, 1763);
	level.iz_route[level.iz_route.size] = (5342, 2566, 1763);
	level.iz_route[level.iz_route.size] = (5442, 2089, 1763);
	level.iz_route[level.iz_route.size] = (5667, 1562, 1763);
	level.iz_route[level.iz_route.size] = (6026, 1107, 1763);
	level.iz_route[level.iz_route.size] = (6396, 611, 1763);
	level.iz_route[level.iz_route.size] = (6695, 45, 1763);
	level.iz_route[level.iz_route.size] = (6878, -549, 1763);
	level.iz_route[level.iz_route.size] = (6868, -1208, 1763);
	level.iz_route[level.iz_route.size] = (6567, -1764, 1763);
	level.iz_route[level.iz_route.size] = (6212, -2311, 1763);
	level.iz_route[level.iz_route.size] = (6049, -2735, 1763);
	level.iz_route[level.iz_route.size] = (6077, -3226, 1763);
	level.iz_route[level.iz_route.size] = (6442, -3514, 1763);
	level.iz_route[level.iz_route.size] = (6989, -3608, 1763);
	level.iz_route[level.iz_route.size] = (7512, -3519, 1763);
	level.iz_route[level.iz_route.size] = (8145, -3297, 1777);
	level.iz_route[level.iz_route.size] = (8859, -3013, 1763);
	level.iz_route[level.iz_route.size] = (9580, -2789, 1764);
	level.iz_route[level.iz_route.size] = (10277, -2661, 1772);
	level.iz_route[level.iz_route.size] = (10941, -2531, 1796);
	level.iz_route[level.iz_route.size] = (11470, -2338, 1823);
	level.iz_route[level.iz_route.size] = (11943, -2005, 1841);
	level.iz_route[level.iz_route.size] = (12302, -1566, 1842);
	level.iz_route[level.iz_route.size] = (12354, -1020, 1810);
	level.iz_route[level.iz_route.size] = (12173, -419, 1792);
	level.iz_route[level.iz_route.size] = (12043, -55, 1815);
	level.iz_route[level.iz_route.size] = (11932, 280, 1853);
	level.iz_route[level.iz_route.size] = (11899, 742, 1933);
	level.iz_route[level.iz_route.size] = (12055, 1144, 2021);
	level.iz_route[level.iz_route.size] = (12400, 1427, 2078);
	level.iz_route[level.iz_route.size] = (12816, 1625, 2099);
	level.iz_route[level.iz_route.size] = (13332, 1819, 2112);
	level.iz_route[level.iz_route.size] = (13750, 2064, 2131);
	level.iz_route[level.iz_route.size] = (13975, 2467, 2142);
	level.iz_route[level.iz_route.size] = (14123, 2955, 2153);
	level.iz_route[level.iz_route.size] = (14179, 3400, 2178);
	level.iz_route[level.iz_route.size] = (14219, 3846, 2253);
	level.iz_route[level.iz_route.size] = (14253, 4405, 2425);
	level.iz_route[level.iz_route.size] = (14239, 5089, 2644);
	level.iz_route[level.iz_route.size] = (14201, 5866, 2814);
	level.iz_route[level.iz_route.size] = (14120, 6425, 2883);
	level.iz_route[level.iz_route.size] = (13932, 7020, 2918);
	level.iz_route[level.iz_route.size] = (13647, 7560, 2944);
	level.iz_route[level.iz_route.size] = (13202, 7956, 2950);
	level.iz_route[level.iz_route.size] = (12681, 8056, 2921);
	level.iz_route[level.iz_route.size] = (12187, 7909, 2895);
	level.iz_route[level.iz_route.size] = (11702, 7710, 2886);
	level.iz_route[level.iz_route.size] = (11184, 7517, 2870);
	level.iz_route[level.iz_route.size] = (10629, 7405, 2871);
	level.iz_route[level.iz_route.size] = (10063, 7389, 2839);
	level.iz_route[level.iz_route.size] = (9457, 7525, 2791);
	level.iz_route[level.iz_route.size] = (8784, 7763, 2730);
	level.iz_route[level.iz_route.size] = (8270, 7977, 2694);
	level.iz_route[level.iz_route.size] = (7760, 8085, 2645);
	level.iz_route[level.iz_route.size] = (7165, 8088, 2558);
	level.iz_route[level.iz_route.size] = (6640, 8009, 2472);
	level.iz_route[level.iz_route.size] = (6087, 7776, 2362);
	level.iz_route[level.iz_route.size] = (5740, 7369, 2265);
	level.iz_route[level.iz_route.size] = (5492, 6806, 2152);
	level.iz_route[level.iz_route.size] = (5417, 6072, 1988);
	level.iz_route[level.iz_route.size] = (5382, 5300, 1853);
	level.iz_route[level.iz_route.size] = (5365, 4563, 1775);
	level.iz_route[level.iz_route.size] = (5354, 3831, 1764);
}
