main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_rainbow_road", 0);

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
	ambientPlay("iz_0_urr", 2);
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
	level.iz_route[level.iz_route.size] = (8198, 2469, 11442);
	level.iz_route[level.iz_route.size] = (8173, 994, 11455);
	level.iz_route[level.iz_route.size] = (8072, -531, 11484);
	level.iz_route[level.iz_route.size] = (7935, -1059, 11511);
	level.iz_route[level.iz_route.size] = (7715, -1455, 11557);
	level.iz_route[level.iz_route.size] = (7393, -1873, 11657);
	level.iz_route[level.iz_route.size] = (6458, -2812, 12033);
	level.iz_route[level.iz_route.size] = (5541, -3816, 12430);
	level.iz_route[level.iz_route.size] = (5227, -4303, 12588);
	level.iz_route[level.iz_route.size] = (5046, -4819, 12729);
	level.iz_route[level.iz_route.size] = (4914, -5462, 12891);
	level.iz_route[level.iz_route.size] = (4783, -6364, 13113);
	level.iz_route[level.iz_route.size] = (4638, -7140, 13319);
	level.iz_route[level.iz_route.size] = (4365, -7914, 13515);
	level.iz_route[level.iz_route.size] = (3977, -8499, 13629);
	level.iz_route[level.iz_route.size] = (3326, -8707, 13554);
	level.iz_route[level.iz_route.size] = (2756, -8544, 13371);
	level.iz_route[level.iz_route.size] = (2348, -8178, 13170);
	level.iz_route[level.iz_route.size] = (2216, -7553, 12914);
	level.iz_route[level.iz_route.size] = (2417, -6997, 12720);
	level.iz_route[level.iz_route.size] = (2816, -6628, 12598);
	level.iz_route[level.iz_route.size] = (3373, -6509, 12518);
	level.iz_route[level.iz_route.size] = (3995, -6494, 12469);
	level.iz_route[level.iz_route.size] = (4713, -6587, 12452);
	level.iz_route[level.iz_route.size] = (5563, -6650, 12509);
	level.iz_route[level.iz_route.size] = (6121, -6614, 12611);
	level.iz_route[level.iz_route.size] = (6695, -6354, 12746);
	level.iz_route[level.iz_route.size] = (7003, -5805, 12755);
	level.iz_route[level.iz_route.size] = (6992, -5237, 12611);
	level.iz_route[level.iz_route.size] = (6695, -4651, 12296);
	level.iz_route[level.iz_route.size] = (6224, -4420, 12005);
	level.iz_route[level.iz_route.size] = (5614, -4366, 11785);
	level.iz_route[level.iz_route.size] = (5048, -4328, 11698);
	level.iz_route[level.iz_route.size] = (4486, -4298, 11770);
	level.iz_route[level.iz_route.size] = (2078, -4171, 11204);
	level.iz_route[level.iz_route.size] = (1765, -4166, 10793);
	level.iz_route[level.iz_route.size] = (1245, -4155, 10600);
	level.iz_route[level.iz_route.size] = (658, -4152, 10354);
	level.iz_route[level.iz_route.size] = (28, -4164, 10073);
	level.iz_route[level.iz_route.size] = (-509, -4361, 9896);
	level.iz_route[level.iz_route.size] = (-1019, -4826, 9772);
	level.iz_route[level.iz_route.size] = (-1438, -5585, 9762);
	level.iz_route[level.iz_route.size] = (-2100, -6173, 9760);
	level.iz_route[level.iz_route.size] = (-2961, -6531, 9772);
	level.iz_route[level.iz_route.size] = (-3855, -6518, 9775);
	level.iz_route[level.iz_route.size] = (-4761, -6086, 9769);
	level.iz_route[level.iz_route.size] = (-5363, -5243, 9741);
	level.iz_route[level.iz_route.size] = (-5687, -4390, 9840);
	level.iz_route[level.iz_route.size] = (-5845, -3443, 10214);
	level.iz_route[level.iz_route.size] = (-5942, -2580, 10532);
	level.iz_route[level.iz_route.size] = (-6417, -1803, 10952);
	level.iz_route[level.iz_route.size] = (-6482, -1212, 11169);
	level.iz_route[level.iz_route.size] = (-6504, -858, 11357);
	level.iz_route[level.iz_route.size] = (-7144, 6845, 17487);
	level.iz_route[level.iz_route.size] = (-7149, 7311, 17799);
	level.iz_route[level.iz_route.size] = (-7121, 7710, 18114);
	level.iz_route[level.iz_route.size] = (-7073, 8074, 18391);
	level.iz_route[level.iz_route.size] = (-6987, 8406, 18624);
	level.iz_route[level.iz_route.size] = (-6872, 8694, 18809);
	level.iz_route[level.iz_route.size] = (-6712, 9029, 19024);
	level.iz_route[level.iz_route.size] = (-6389, 9333, 19122);
	level.iz_route[level.iz_route.size] = (-6039, 9479, 19068);
	level.iz_route[level.iz_route.size] = (-5700, 9560, 18977);
	level.iz_route[level.iz_route.size] = (-5386, 9539, 18815);
	level.iz_route[level.iz_route.size] = (-5094, 9476, 18637);
	level.iz_route[level.iz_route.size] = (-4729, 9295, 18347);
	level.iz_route[level.iz_route.size] = (-4249, 9045, 18005);
	level.iz_route[level.iz_route.size] = (-3830, 8770, 17708);
	level.iz_route[level.iz_route.size] = (-3503, 8503, 17469);
	level.iz_route[level.iz_route.size] = (-3253, 8204, 17260);
	level.iz_route[level.iz_route.size] = (-3008, 7877, 17046);
	level.iz_route[level.iz_route.size] = (-2749, 7548, 16828);
	level.iz_route[level.iz_route.size] = (-2394, 7201, 16578);
	level.iz_route[level.iz_route.size] = (-1977, 7092, 16355);
	level.iz_route[level.iz_route.size] = (-1552, 7195, 16150);
	level.iz_route[level.iz_route.size] = (-1180, 7403, 16002);
	level.iz_route[level.iz_route.size] = (-798, 7745, 15885);
	level.iz_route[level.iz_route.size] = (-341, 8176, 15788);
	level.iz_route[level.iz_route.size] = (223, 8725, 15722);
	level.iz_route[level.iz_route.size] = (477, 9005, 15725);
	level.iz_route[level.iz_route.size] = (776, 9241, 15757);
	level.iz_route[level.iz_route.size] = (1104, 9458, 15814);
	level.iz_route[level.iz_route.size] = (1507, 9637, 15878);
	level.iz_route[level.iz_route.size] = (1863, 9670, 15877);
	level.iz_route[level.iz_route.size] = (2261, 9559, 15787);
	level.iz_route[level.iz_route.size] = (2572, 9363, 15650);
	level.iz_route[level.iz_route.size] = (2890, 9043, 15459);
	level.iz_route[level.iz_route.size] = (3231, 8687, 15266);
	level.iz_route[level.iz_route.size] = (3500, 8397, 15121);
	level.iz_route[level.iz_route.size] = (3802, 8058, 14963);
	level.iz_route[level.iz_route.size] = (4083, 7790, 14825);
	level.iz_route[level.iz_route.size] = (4440, 7517, 14655);
	level.iz_route[level.iz_route.size] = (4720, 7378, 14519);
	level.iz_route[level.iz_route.size] = (5030, 7302, 14355);
	level.iz_route[level.iz_route.size] = (5433, 7303, 14116);
	level.iz_route[level.iz_route.size] = (5904, 7370, 13812);
	level.iz_route[level.iz_route.size] = (6379, 7491, 13483);
	level.iz_route[level.iz_route.size] = (6956, 7605, 13100);
	level.iz_route[level.iz_route.size] = (7697, 7747, 12652);
	level.iz_route[level.iz_route.size] = (8487, 7783, 12284);
	level.iz_route[level.iz_route.size] = (9191, 8160, 12053);
	level.iz_route[level.iz_route.size] = (9488, 8690, 11886);
	level.iz_route[level.iz_route.size] = (9448, 9319, 11729);
	level.iz_route[level.iz_route.size] = (9214, 9802, 11658);
	level.iz_route[level.iz_route.size] = (8753, 10125, 11650);
	level.iz_route[level.iz_route.size] = (8182, 10271, 11703);
	level.iz_route[level.iz_route.size] = (7673, 10098, 11777);
	level.iz_route[level.iz_route.size] = (7169, 9540, 11883);
	level.iz_route[level.iz_route.size] = (7113, 8745, 11862);
	level.iz_route[level.iz_route.size] = (7400, 8048, 11739);
	level.iz_route[level.iz_route.size] = (7717, 7405, 11599);
	level.iz_route[level.iz_route.size] = (8027, 6749, 11490);
	level.iz_route[level.iz_route.size] = (8125, 6241, 11457);
	level.iz_route[level.iz_route.size] = (8185, 5651, 11446);
	level.iz_route[level.iz_route.size] = (8208, 5041, 11443);
	level.iz_route[level.iz_route.size] = (8202, 3766, 11442);
}
