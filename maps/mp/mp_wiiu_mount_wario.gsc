main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_mount_wario", 0);

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
	ambientPlay("iz_0_umw", 2);
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
	level.iz_route[level.iz_route.size] = (13962, 20937, 32119);
	level.iz_route[level.iz_route.size] = (14020, 19463, 31153);
	level.iz_route[level.iz_route.size] = (13983, 18120, 30971);
	level.iz_route[level.iz_route.size] = (13623, 16227, 30772);
	level.iz_route[level.iz_route.size] = (12876, 15139, 30688);
	level.iz_route[level.iz_route.size] = (11830, 14389, 30683);
	level.iz_route[level.iz_route.size] = (11348, 13688, 30680);
	level.iz_route[level.iz_route.size] = (11521, 12922, 30686);
	level.iz_route[level.iz_route.size] = (12170, 11996, 30707);
	level.iz_route[level.iz_route.size] = (12191, 10726, 30787);
	level.iz_route[level.iz_route.size] = (11685, 9379, 30693);
	level.iz_route[level.iz_route.size] = (10980, 7642, 30641);
	level.iz_route[level.iz_route.size] = (10681, 6626, 30622);
	level.iz_route[level.iz_route.size] = (9948, 5851, 30575);
	level.iz_route[level.iz_route.size] = (8978, 6025, 30449);
	level.iz_route[level.iz_route.size] = (8451, 6960, 30248);
	level.iz_route[level.iz_route.size] = (8355, 8478, 29963);
	level.iz_route[level.iz_route.size] = (8004, 9619, 29776);
	level.iz_route[level.iz_route.size] = (7144, 10550, 29534);
	level.iz_route[level.iz_route.size] = (6291, 11277, 29335);
	level.iz_route[level.iz_route.size] = (5523, 11860, 29201);
	level.iz_route[level.iz_route.size] = (4781, 11956, 29097);
	level.iz_route[level.iz_route.size] = (4299, 11537, 28970);
	level.iz_route[level.iz_route.size] = (4277, 10773, 28796);
	level.iz_route[level.iz_route.size] = (4493, 9920, 28632);
	level.iz_route[level.iz_route.size] = (4804, 9057, 28474);
	level.iz_route[level.iz_route.size] = (4856, 8205, 28374);
	level.iz_route[level.iz_route.size] = (4198, 6908, 28112);
	level.iz_route[level.iz_route.size] = (3284, 5407, 27792);
	level.iz_route[level.iz_route.size] = (2680, 4250, 27660);
	level.iz_route[level.iz_route.size] = (1949, 3803, 27627);
	level.iz_route[level.iz_route.size] = (1215, 4125, 27497);
	level.iz_route[level.iz_route.size] = (948, 5001, 27287);
	level.iz_route[level.iz_route.size] = (725, 6069, 27096);
	level.iz_route[level.iz_route.size] = (216, 7774, 26835);
	level.iz_route[level.iz_route.size] = (-223, 9441, 26708);
	level.iz_route[level.iz_route.size] = (-141, 10699, 26703);
	level.iz_route[level.iz_route.size] = (686, 11818, 26693);
	level.iz_route[level.iz_route.size] = (1142, 12079, 26645);
	level.iz_route[level.iz_route.size] = (2254, 12274, 26208);
	level.iz_route[level.iz_route.size] = (3252, 13119, 26214);
	level.iz_route[level.iz_route.size] = (4117, 14520, 26156);
	level.iz_route[level.iz_route.size] = (4249, 15950, 26010);
	level.iz_route[level.iz_route.size] = (4139, 16787, 25902);
	level.iz_route[level.iz_route.size] = (3225, 19360, 24772);
	level.iz_route[level.iz_route.size] = (1759, 20789, 24624);
	level.iz_route[level.iz_route.size] = (-284, 21932, 24517);
	level.iz_route[level.iz_route.size] = (-2477, 22238, 24517);
	level.iz_route[level.iz_route.size] = (-4649, 22069, 24392);
	level.iz_route[level.iz_route.size] = (-6004, 21800, 24414);
	level.iz_route[level.iz_route.size] = (-7820, 21386, 24487);
	level.iz_route[level.iz_route.size] = (-9167, 21123, 24429);
	level.iz_route[level.iz_route.size] = (-10116, 20994, 24424);
	level.iz_route[level.iz_route.size] = (-10589, 21946, 24424);
	level.iz_route[level.iz_route.size] = (-10751, 23006, 24294);
	level.iz_route[level.iz_route.size] = (-11006, 23949, 24275);
	level.iz_route[level.iz_route.size] = (-11341, 24692, 24276);
	level.iz_route[level.iz_route.size] = (-12221, 25054, 24276);
	level.iz_route[level.iz_route.size] = (-13159, 24636, 24278);
	level.iz_route[level.iz_route.size] = (-13956, 23822, 24078);
	level.iz_route[level.iz_route.size] = (-15099, 22195, 23003);
	level.iz_route[level.iz_route.size] = (-16540, 19537, 22980);
	level.iz_route[level.iz_route.size] = (-17285, 16929, 22968);
	level.iz_route[level.iz_route.size] = (-17321, 14666, 22863);
	level.iz_route[level.iz_route.size] = (-17255, 13288, 22854);
	level.iz_route[level.iz_route.size] = (-17294, 12534, 22938);
	level.iz_route[level.iz_route.size] = (-17077, 10904, 22186);
	level.iz_route[level.iz_route.size] = (-16865, 9445, 21790);
	level.iz_route[level.iz_route.size] = (-16684, 8498, 21497);
	level.iz_route[level.iz_route.size] = (-16148, 8095, 21389);
	level.iz_route[level.iz_route.size] = (-16003, 7625, 21333);
	level.iz_route[level.iz_route.size] = (-15691, 7139, 21282);
	level.iz_route[level.iz_route.size] = (-15024, 6831, 21231);
	level.iz_route[level.iz_route.size] = (-14355, 6633, 21188);
	level.iz_route[level.iz_route.size] = (-13643, 6364, 21138);
	level.iz_route[level.iz_route.size] = (-13145, 5855, 21059);
	level.iz_route[level.iz_route.size] = (-12855, 5296, 20966);
	level.iz_route[level.iz_route.size] = (-13082, 4705, 20847);
	level.iz_route[level.iz_route.size] = (-13518, 4190, 20726);
	level.iz_route[level.iz_route.size] = (-13924, 3690, 20605);
	level.iz_route[level.iz_route.size] = (-13623, 2967, 20429);
	level.iz_route[level.iz_route.size] = (-13293, 2356, 20353);
	level.iz_route[level.iz_route.size] = (-12907, 1699, 20273);
	level.iz_route[level.iz_route.size] = (-12041, 962, 20117);
	level.iz_route[level.iz_route.size] = (-10504, -576, 19725);
	level.iz_route[level.iz_route.size] = (-9059, -2211, 19269);
	level.iz_route[level.iz_route.size] = (-7634, -3603, 18806);
	level.iz_route[level.iz_route.size] = (-6996, -4975, 18450);
	level.iz_route[level.iz_route.size] = (-7020, -6422, 18163);
	level.iz_route[level.iz_route.size] = (-8087, -7299, 18049);
	level.iz_route[level.iz_route.size] = (-9411, -7609, 18033);
	level.iz_route[level.iz_route.size] = (-10998, -7704, 18045);
	level.iz_route[level.iz_route.size] = (-12323, -8267, 18074);
	level.iz_route[level.iz_route.size] = (-12723, -9173, 18011);
	level.iz_route[level.iz_route.size] = (-12775, -10443, 17717);
	level.iz_route[level.iz_route.size] = (-12768, -12008, 17202);
	level.iz_route[level.iz_route.size] = (-12736, -13825, 16557);
	level.iz_route[level.iz_route.size] = (-12784, -15598, 15971);
	level.iz_route[level.iz_route.size] = (-13243, -16586, 15700);
	level.iz_route[level.iz_route.size] = (-14059, -17198, 15484);
	level.iz_route[level.iz_route.size] = (-14043, -18223, 15241);
	level.iz_route[level.iz_route.size] = (-13168, -18681, 15015);
	level.iz_route[level.iz_route.size] = (-12201, -19304, 14792);
	level.iz_route[level.iz_route.size] = (-12516, -20234, 14498);
	level.iz_route[level.iz_route.size] = (-13432, -20825, 14285);
	level.iz_route[level.iz_route.size] = (-14496, -21538, 14064);
	level.iz_route[level.iz_route.size] = (-14599, -22593, 13734);
	level.iz_route[level.iz_route.size] = (-13812, -23253, 13402);
	level.iz_route[level.iz_route.size] = (-13089, -24148, 13027);
	level.iz_route[level.iz_route.size] = (-12749, -25409, 12610);
	level.iz_route[level.iz_route.size] = (-12815, -27214, 12059);
	level.iz_route[level.iz_route.size] = (-12796, -28718, 11515);
	level.iz_route[level.iz_route.size] = (-12765, -30382, 10921);
	level.iz_route[level.iz_route.size] = (-12748, -32001, 10716);
	level.iz_route[level.iz_route.size] = (-12590, -32880, 10653);
	level.iz_route[level.iz_route.size] = (-11933, -33472, 10590);
	level.iz_route[level.iz_route.size] = (-10891, -33591, 10503);
	level.iz_route[level.iz_route.size] = (-9687, -33608, 10424);
	level.iz_route[level.iz_route.size] = (-7959, -33591, 9941);
	level.iz_route[level.iz_route.size] = (-6108, -33596, 9019);
	level.iz_route[level.iz_route.size] = (-3815, -33572, 7858);
	level.iz_route[level.iz_route.size] = (-1314, -33596, 6599);
	level.iz_route[level.iz_route.size] = (5, -33593, 6087);
	level.iz_route[level.iz_route.size] = (8386, -33559, 2238);
	level.iz_route[level.iz_route.size] = (9942, -33540, 1772);
	level.iz_route[level.iz_route.size] = (11550, -33658, 1487);
	level.iz_route[level.iz_route.size] = (12442, -34455, 1360);
	level.iz_route[level.iz_route.size] = (12979, -35569, 1279);
	level.iz_route[level.iz_route.size] = (13861, -36012, 1189);
	level.iz_route[level.iz_route.size] = (14901, -35797, 1088);
	level.iz_route[level.iz_route.size] = (15964, -35267, 1007);
	level.iz_route[level.iz_route.size] = (17194, -34663, 938);
	level.iz_route[level.iz_route.size] = (18837, -33938, 936);
	level.iz_route[level.iz_route.size] = (19543, -32861, 936);
	level.iz_route[level.iz_route.size] = (20818, -32113, 936);
	level.iz_route[level.iz_route.size] = (21934, -32175, 936);
	level.iz_route[level.iz_route.size] = (22105, -33104, 936);
	level.iz_route[level.iz_route.size] = (21126, -33885, 936);
	level.iz_route[level.iz_route.size] = (19665, -34138, 936);
	level.iz_route[level.iz_route.size] = (19815, -33304, 936);
	level.iz_route[level.iz_route.size] = (21144, -32908, 936);
}
