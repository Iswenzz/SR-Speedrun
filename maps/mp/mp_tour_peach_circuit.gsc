main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_peach_circuit", 0);

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
	ambientPlay("iz_0_trpc", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4665.8501, -2721.2949, 2055.4690), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4729.4521, -1674.4664, 2055.5298), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4971.6279, -918.8449, 2227.3032), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-5213.8032, -163.2234, 2399.0767), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-5823.9126, -189.6886, 2633.9307), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-6434.0225, -216.1538, 2868.7852), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-7112.5654, -162.6685, 3137.3369), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-7812.8799, -140.3025, 3350.9160), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-3731.9558, 4272.7876, 1652.0936), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4280.4453, 4275.0400, 1762.6144), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4858.4131, 4185.0444, 1928.5884), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-5237.6611, 3950.9736, 2091.9197), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-5733.6479, 3549.5962, 2312.7620), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-6083.2842, 3205.6992, 2474.5520), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-6315.2168, 2905.5903, 2583.0303), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-6309.6504, 2337.7800, 2605.4045), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-5670.3623, 2046.1606, 2419.6248), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-5192.2197, 1967.3195, 2305.5212), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-4457.1699, 1881.2343, 2174.8555), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-3831.7559, 1881.1538, 2084.9722), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-6377.4121, 5708.0596, 2600.6958), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-7214.4536, 5390.2363, 3039.4089), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-7747.2397, 5275.4087, 3277.4521), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-8385.1494, 5224.0518, 3410.2522), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-1364, -3097, 1938);
	level.iz_route[level.iz_route.size] = (-1373, -4102, 1936);
	level.iz_route[level.iz_route.size] = (-1385, -5021, 1934);
	level.iz_route[level.iz_route.size] = (-1349, -5995, 1958);
	level.iz_route[level.iz_route.size] = (-1059, -6811, 2007);
	level.iz_route[level.iz_route.size] = (-317, -7018, 2002);
	level.iz_route[level.iz_route.size] = (441, -6808, 1961);
	level.iz_route[level.iz_route.size] = (1043, -6041, 1887);
	level.iz_route[level.iz_route.size] = (1534, -5327, 1823);
	level.iz_route[level.iz_route.size] = (2116, -4604, 1753);
	level.iz_route[level.iz_route.size] = (2651, -3991, 1692);
	level.iz_route[level.iz_route.size] = (3213, -3384, 1642);
	level.iz_route[level.iz_route.size] = (3636, -2694, 1595);
	level.iz_route[level.iz_route.size] = (3739, -1918, 1527);
	level.iz_route[level.iz_route.size] = (3537, -1243, 1447);
	level.iz_route[level.iz_route.size] = (3448, -468, 1391);
	level.iz_route[level.iz_route.size] = (3642, 226, 1344);
	level.iz_route[level.iz_route.size] = (4099, 849, 1317);
	level.iz_route[level.iz_route.size] = (4605, 1332, 1325);
	level.iz_route[level.iz_route.size] = (5004, 1903, 1330);
	level.iz_route[level.iz_route.size] = (4987, 2616, 1301);
	level.iz_route[level.iz_route.size] = (4644, 3269, 1234);
	level.iz_route[level.iz_route.size] = (4085, 3749, 1154);
	level.iz_route[level.iz_route.size] = (3497, 4277, 1099);
	level.iz_route[level.iz_route.size] = (2926, 4784, 1071);
	level.iz_route[level.iz_route.size] = (2445, 5279, 1065);
	level.iz_route[level.iz_route.size] = (2201, 5912, 1068);
	level.iz_route[level.iz_route.size] = (1875, 6553, 1082);
	level.iz_route[level.iz_route.size] = (1315, 6917, 1111);
	level.iz_route[level.iz_route.size] = (562, 6804, 1127);
	level.iz_route[level.iz_route.size] = (41, 6257, 1149);
	level.iz_route[level.iz_route.size] = (-416, 5539, 1216);
	level.iz_route[level.iz_route.size] = (-1052, 5002, 1310);
	level.iz_route[level.iz_route.size] = (-1819, 4905, 1374);
	level.iz_route[level.iz_route.size] = (-2634, 4935, 1484);
	level.iz_route[level.iz_route.size] = (-3470, 4923, 1593);
	level.iz_route[level.iz_route.size] = (-4286, 4895, 1748);
	level.iz_route[level.iz_route.size] = (-5124, 4723, 2037);
	level.iz_route[level.iz_route.size] = (-5880, 4230, 2391);
	level.iz_route[level.iz_route.size] = (-6368, 3733, 2627);
	level.iz_route[level.iz_route.size] = (-6852, 3108, 2862);
	level.iz_route[level.iz_route.size] = (-7112, 2409, 2995);
	level.iz_route[level.iz_route.size] = (-6862, 1747, 2905);
	level.iz_route[level.iz_route.size] = (-6225, 1265, 2654);
	level.iz_route[level.iz_route.size] = (-5546, 1221, 2422);
	level.iz_route[level.iz_route.size] = (-4653, 1296, 2197);
	level.iz_route[level.iz_route.size] = (-3796, 1311, 2071);
	level.iz_route[level.iz_route.size] = (-2974, 1311, 2001);
	level.iz_route[level.iz_route.size] = (-2192, 1205, 1974);
	level.iz_route[level.iz_route.size] = (-1604, 797, 1976);
	level.iz_route[level.iz_route.size] = (-1345, -22, 1957);
	level.iz_route[level.iz_route.size] = (-1314, -980, 1942);
	level.iz_route[level.iz_route.size] = (-1336, -2032, 1940);
}
