main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_mute_city", 0);

	setExpFog(14763.7793, 19377.4609, 0.0275, 0.0980, 0.2471, 0);

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
	ambientPlay("iz_0_umuc", 2);
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
	level.iz_route[level.iz_route.size] = (-946, -5009, 4490);
	level.iz_route[level.iz_route.size] = (-1014, -5814, 4482);
	level.iz_route[level.iz_route.size] = (-1620, -6523, 4461);
	level.iz_route[level.iz_route.size] = (-2065, -7240, 4459);
	level.iz_route[level.iz_route.size] = (-2120, -7919, 4471);
	level.iz_route[level.iz_route.size] = (-1727, -8643, 4488);
	level.iz_route[level.iz_route.size] = (-1662, -9194, 4513);
	level.iz_route[level.iz_route.size] = (-1982, -9867, 4536);
	level.iz_route[level.iz_route.size] = (-2537, -10317, 4564);
	level.iz_route[level.iz_route.size] = (-3239, -10549, 4612);
	level.iz_route[level.iz_route.size] = (-3867, -10469, 4659);
	level.iz_route[level.iz_route.size] = (-4551, -10112, 4728);
	level.iz_route[level.iz_route.size] = (-5088, -9481, 4810);
	level.iz_route[level.iz_route.size] = (-5280, -8699, 4895);
	level.iz_route[level.iz_route.size] = (-5282, -7968, 4999);
	level.iz_route[level.iz_route.size] = (-4915, -7158, 5123);
	level.iz_route[level.iz_route.size] = (-4332, -6443, 5262);
	level.iz_route[level.iz_route.size] = (-3678, -5951, 5360);
	level.iz_route[level.iz_route.size] = (-2992, -5682, 5422);
	level.iz_route[level.iz_route.size] = (-2172, -5502, 5481);
	level.iz_route[level.iz_route.size] = (-1455, -5464, 5524);
	level.iz_route[level.iz_route.size] = (-542, -5335, 5587);
	level.iz_route[level.iz_route.size] = (469, -5096, 5661);
	level.iz_route[level.iz_route.size] = (1406, -4754, 5728);
	level.iz_route[level.iz_route.size] = (2246, -4045, 5740);
	level.iz_route[level.iz_route.size] = (2941, -2943, 5704);
	level.iz_route[level.iz_route.size] = (3470, -1687, 5699);
	level.iz_route[level.iz_route.size] = (3567, -999, 5730);
	level.iz_route[level.iz_route.size] = (3774, 793, 5729);
	level.iz_route[level.iz_route.size] = (3714, 1550, 5751);
	level.iz_route[level.iz_route.size] = (3504, 2304, 5786);
	level.iz_route[level.iz_route.size] = (3155, 3114, 5857);
	level.iz_route[level.iz_route.size] = (2753, 3733, 5931);
	level.iz_route[level.iz_route.size] = (2456, 4533, 6039);
	level.iz_route[level.iz_route.size] = (2532, 5459, 6119);
	level.iz_route[level.iz_route.size] = (2975, 6192, 6151);
	level.iz_route[level.iz_route.size] = (3629, 6891, 6246);
	level.iz_route[level.iz_route.size] = (4314, 7471, 6377);
	level.iz_route[level.iz_route.size] = (4954, 8024, 6476);
	level.iz_route[level.iz_route.size] = (5363, 8657, 6583);
	level.iz_route[level.iz_route.size] = (5502, 9343, 6650);
	level.iz_route[level.iz_route.size] = (5375, 10046, 6700);
	level.iz_route[level.iz_route.size] = (4908, 10643, 6705);
	level.iz_route[level.iz_route.size] = (4381, 11028, 6705);
	level.iz_route[level.iz_route.size] = (3716, 11150, 6694);
	level.iz_route[level.iz_route.size] = (3060, 11147, 6738);
	level.iz_route[level.iz_route.size] = (2528, 11099, 6821);
	level.iz_route[level.iz_route.size] = (1304, 11027, 6870);
	level.iz_route[level.iz_route.size] = (763, 11005, 6896);
	level.iz_route[level.iz_route.size] = (48, 10951, 6943);
	level.iz_route[level.iz_route.size] = (-587, 10923, 6995);
	level.iz_route[level.iz_route.size] = (-1424, 10912, 7052);
	level.iz_route[level.iz_route.size] = (-2202, 10943, 7086);
	level.iz_route[level.iz_route.size] = (-2866, 11088, 7110);
	level.iz_route[level.iz_route.size] = (-3525, 11225, 7131);
	level.iz_route[level.iz_route.size] = (-4207, 11359, 7160);
	level.iz_route[level.iz_route.size] = (-4798, 11266, 7207);
	level.iz_route[level.iz_route.size] = (-5297, 11019, 7258);
	level.iz_route[level.iz_route.size] = (-5798, 10922, 7307);
	level.iz_route[level.iz_route.size] = (-6409, 10965, 7371);
	level.iz_route[level.iz_route.size] = (-6927, 11134, 7422);
	level.iz_route[level.iz_route.size] = (-7469, 11397, 7484);
	level.iz_route[level.iz_route.size] = (-7918, 11873, 7549);
	level.iz_route[level.iz_route.size] = (-8221, 12399, 7614);
	level.iz_route[level.iz_route.size] = (-8376, 13096, 7684);
	level.iz_route[level.iz_route.size] = (-8323, 13685, 7738);
	level.iz_route[level.iz_route.size] = (-7999, 14248, 7792);
	level.iz_route[level.iz_route.size] = (-7476, 14712, 7868);
	level.iz_route[level.iz_route.size] = (-6873, 14936, 7943);
	level.iz_route[level.iz_route.size] = (-6277, 14935, 8020);
	level.iz_route[level.iz_route.size] = (-5643, 14571, 8098);
	level.iz_route[level.iz_route.size] = (-5221, 13991, 8197);
	level.iz_route[level.iz_route.size] = (-5054, 13425, 8285);
	level.iz_route[level.iz_route.size] = (-5088, 12696, 8426);
	level.iz_route[level.iz_route.size] = (-5055, 12142, 8542);
	level.iz_route[level.iz_route.size] = (-4787, 11703, 8614);
	level.iz_route[level.iz_route.size] = (-4380, 11498, 8648);
	level.iz_route[level.iz_route.size] = (-3928, 11426, 8661);
	level.iz_route[level.iz_route.size] = (-3364, 11485, 8665);
	level.iz_route[level.iz_route.size] = (-2889, 11527, 8667);
	level.iz_route[level.iz_route.size] = (-2206, 11531, 8670);
	level.iz_route[level.iz_route.size] = (-1574, 11479, 8693);
	level.iz_route[level.iz_route.size] = (-1169, 11219, 8701);
	level.iz_route[level.iz_route.size] = (-988, 10929, 8694);
	level.iz_route[level.iz_route.size] = (-897, 10291, 8694);
	level.iz_route[level.iz_route.size] = (-926, 9064, 7853);
	level.iz_route[level.iz_route.size] = (-872, 8490, 7541);
	level.iz_route[level.iz_route.size] = (-894, 8013, 7287);
	level.iz_route[level.iz_route.size] = (-934, 7472, 7005);
	level.iz_route[level.iz_route.size] = (-1134, 6971, 6754);
	level.iz_route[level.iz_route.size] = (-1474, 6491, 6526);
	level.iz_route[level.iz_route.size] = (-1928, 6066, 6334);
	level.iz_route[level.iz_route.size] = (-2316, 5534, 6101);
	level.iz_route[level.iz_route.size] = (-2447, 4909, 5851);
	level.iz_route[level.iz_route.size] = (-2394, 4348, 5660);
	level.iz_route[level.iz_route.size] = (-2099, 3859, 5517);
	level.iz_route[level.iz_route.size] = (-1586, 3541, 5431);
	level.iz_route[level.iz_route.size] = (-966, 3285, 5367);
	level.iz_route[level.iz_route.size] = (-553, 2995, 5297);
	level.iz_route[level.iz_route.size] = (-171, 2499, 5182);
	level.iz_route[level.iz_route.size] = (-154, 1967, 5070);
	level.iz_route[level.iz_route.size] = (-346, 1475, 4974);
	level.iz_route[level.iz_route.size] = (-688, 1048, 4895);
	level.iz_route[level.iz_route.size] = (-867, 620, 4828);
	level.iz_route[level.iz_route.size] = (-919, 183, 4772);
	level.iz_route[level.iz_route.size] = (-942, -364, 4494);
	level.iz_route[level.iz_route.size] = (-941, -1016, 4494);
	level.iz_route[level.iz_route.size] = (-922, -2021, 4493);
	level.iz_route[level.iz_route.size] = (-897, -2978, 4492);
	level.iz_route[level.iz_route.size] = (-924, -4004, 4491);
}
