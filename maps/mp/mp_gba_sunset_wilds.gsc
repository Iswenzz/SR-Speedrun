main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_sunset_wilds", 0);

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

	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_47", 2);
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
	level.iz_route[level.iz_route.size] = (19, -536, 628);
	level.iz_route[level.iz_route.size] = (24, -3285, 628);
	level.iz_route[level.iz_route.size] = (155, -4804, 628);
	level.iz_route[level.iz_route.size] = (559, -5320, 628);
	level.iz_route[level.iz_route.size] = (1154, -5527, 628);
	level.iz_route[level.iz_route.size] = (1794, -5496, 628);
	level.iz_route[level.iz_route.size] = (2296, -5186, 628);
	level.iz_route[level.iz_route.size] = (2474, -4667, 628);
	level.iz_route[level.iz_route.size] = (2542, -3862, 628);
	level.iz_route[level.iz_route.size] = (2668, -2557, 628);
	level.iz_route[level.iz_route.size] = (2819, -1857, 628);
	level.iz_route[level.iz_route.size] = (3027, -1549, 628);
	level.iz_route[level.iz_route.size] = (3370, -1367, 628);
	level.iz_route[level.iz_route.size] = (3803, -1290, 628);
	level.iz_route[level.iz_route.size] = (4150, -1314, 628);
	level.iz_route[level.iz_route.size] = (4484, -1442, 628);
	level.iz_route[level.iz_route.size] = (4820, -1819, 628);
	level.iz_route[level.iz_route.size] = (5354, -2853, 628);
	level.iz_route[level.iz_route.size] = (6105, -4221, 628);
	level.iz_route[level.iz_route.size] = (7118, -5843, 628);
	level.iz_route[level.iz_route.size] = (7814, -6428, 628);
	level.iz_route[level.iz_route.size] = (8887, -6804, 628);
	level.iz_route[level.iz_route.size] = (10820, -6911, 628);
	level.iz_route[level.iz_route.size] = (12395, -6770, 628);
	level.iz_route[level.iz_route.size] = (13395, -6304, 628);
	level.iz_route[level.iz_route.size] = (14099, -5661, 628);
	level.iz_route[level.iz_route.size] = (14475, -4874, 628);
	level.iz_route[level.iz_route.size] = (14532, -4473, 628);
	level.iz_route[level.iz_route.size] = (14493, -4106, 628);
	level.iz_route[level.iz_route.size] = (14271, -3758, 628);
	level.iz_route[level.iz_route.size] = (13704, -3322, 628);
	level.iz_route[level.iz_route.size] = (13032, -2726, 628);
	level.iz_route[level.iz_route.size] = (12472, -2042, 628);
	level.iz_route[level.iz_route.size] = (12160, -1369, 628);
	level.iz_route[level.iz_route.size] = (11649, -701, 628);
	level.iz_route[level.iz_route.size] = (10981, -188, 628);
	level.iz_route[level.iz_route.size] = (10069, 80, 628);
	level.iz_route[level.iz_route.size] = (9196, 238, 628);
	level.iz_route[level.iz_route.size] = (8178, 398, 628);
	level.iz_route[level.iz_route.size] = (7651, 637, 628);
	level.iz_route[level.iz_route.size] = (7400, 891, 628);
	level.iz_route[level.iz_route.size] = (7343, 1228, 628);
	level.iz_route[level.iz_route.size] = (7380, 1536, 628);
	level.iz_route[level.iz_route.size] = (7556, 1837, 628);
	level.iz_route[level.iz_route.size] = (8294, 2251, 628);
	level.iz_route[level.iz_route.size] = (10290, 2826, 628);
	level.iz_route[level.iz_route.size] = (11594, 3274, 628);
	level.iz_route[level.iz_route.size] = (12567, 3803, 628);
	level.iz_route[level.iz_route.size] = (14089, 4607, 628);
	level.iz_route[level.iz_route.size] = (14780, 5042, 628);
	level.iz_route[level.iz_route.size] = (15021, 5257, 628);
	level.iz_route[level.iz_route.size] = (15188, 5514, 628);
	level.iz_route[level.iz_route.size] = (15285, 5830, 628);
	level.iz_route[level.iz_route.size] = (15321, 6106, 628);
	level.iz_route[level.iz_route.size] = (15253, 6509, 628);
	level.iz_route[level.iz_route.size] = (15027, 6880, 628);
	level.iz_route[level.iz_route.size] = (14472, 7222, 628);
	level.iz_route[level.iz_route.size] = (13241, 7592, 628);
	level.iz_route[level.iz_route.size] = (11903, 7787, 628);
	level.iz_route[level.iz_route.size] = (10518, 7788, 628);
	level.iz_route[level.iz_route.size] = (8752, 7498, 628);
	level.iz_route[level.iz_route.size] = (7840, 7139, 628);
	level.iz_route[level.iz_route.size] = (7023, 6398, 628);
	level.iz_route[level.iz_route.size] = (6747, 5950, 628);
	level.iz_route[level.iz_route.size] = (6271, 5599, 628);
	level.iz_route[level.iz_route.size] = (5720, 5443, 628);
	level.iz_route[level.iz_route.size] = (5366, 5251, 628);
	level.iz_route[level.iz_route.size] = (4897, 4942, 628);
	level.iz_route[level.iz_route.size] = (4540, 4450, 628);
	level.iz_route[level.iz_route.size] = (4200, 3619, 628);
	level.iz_route[level.iz_route.size] = (3841, 2947, 628);
	level.iz_route[level.iz_route.size] = (3442, 2482, 628);
	level.iz_route[level.iz_route.size] = (2957, 2192, 628);
	level.iz_route[level.iz_route.size] = (2544, 2230, 628);
	level.iz_route[level.iz_route.size] = (2247, 2512, 628);
	level.iz_route[level.iz_route.size] = (1979, 3002, 628);
	level.iz_route[level.iz_route.size] = (1957, 3572, 628);
	level.iz_route[level.iz_route.size] = (1948, 5140, 628);
	level.iz_route[level.iz_route.size] = (1942, 6330, 628);
	level.iz_route[level.iz_route.size] = (1811, 7290, 628);
	level.iz_route[level.iz_route.size] = (1372, 7894, 628);
	level.iz_route[level.iz_route.size] = (857, 8175, 628);
	level.iz_route[level.iz_route.size] = (158, 8152, 628);
	level.iz_route[level.iz_route.size] = (-340, 7725, 628);
	level.iz_route[level.iz_route.size] = (-468, 7084, 628);
	level.iz_route[level.iz_route.size] = (-393, 6651, 628);
	level.iz_route[level.iz_route.size] = (-282, 6107, 628);
	level.iz_route[level.iz_route.size] = (-62, 4981, 628);
	level.iz_route[level.iz_route.size] = (34, 4184, 628);
	level.iz_route[level.iz_route.size] = (54, 3004, 628);
	level.iz_route[level.iz_route.size] = (66, 1006, 628);
}

iz_move(origin, angles, frames)
{
	if (!isDefined(self.iz_step))
	{
		self.iz_step = (0, 0, 0);
		self.iz_turn = (0, 0, 0);
	}
	time = frames * 0.05 + 0.0005;
	if (isDefined(origin))
	{
		to = origin - self.iz_step;
		self.iz_step = (to - self.origin) * (1.0 / frames);
		self moveTo(to, time);
	}
	if (isDefined(angles))
	{
		turn = angles - self.iz_turn - self.angles;
		turn = (iz_wrap(turn[0]), iz_wrap(turn[1]), iz_wrap(turn[2]));
		self.iz_turn = turn * (1.0 / frames);
		self rotateTo(self.angles + turn, time);
	}
}

iz_wrap(angle)
{
	return angle - 360 * floor(angle / 360 + 0.5);
}

iz_place(origin, angles)
{
	self.origin = origin;
	if (isDefined(angles))
		self.angles = angles;
	self.iz_step = (0, 0, 0);
	self.iz_turn = (0, 0, 0);
}

iz_stop(origin, angles)
{
	self iz_move(origin, angles, 1);
	wait 0.05;
	self iz_move(origin, angles, 1);
}

iz_anims()
{
	thread iz_obj_0();
	thread iz_obj_1();
	thread iz_obj_2();
	thread iz_obj_3();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (13094.0547, 6951.9292, 628.4331);
	angles[0] = (0, -162.1301, 0);
	at[0] = 0;
	points[1] = (13098.3467, 6943.7402, 628.4331);
	angles[1] = (0, -148.5235, 0);
	at[1] = 0.5333;
	points[2] = (13103.7793, 6935.9453, 628.4331);
	angles[2] = (0, -143.6822, 0);
	at[2] = 1.0667;
	points[3] = (13155.5117, 6880.4727, 628.4331);
	angles[3] = (0, -131.3820, 0);
	at[3] = 5.3333;
	points[4] = (13170.7480, 6869.7642, 628.4331);
	angles[4] = (0, -121.1253, 0);
	at[4] = 6.4000;
	points[5] = (13213.1504, 6848.9370, 628.4331);
	angles[5] = (0, -111.7562, 0);
	at[5] = 9.0667;
	points[6] = (13226.6143, 6844.3306, 628.4331);
	angles[6] = (0, -105.8468, 0);
	at[6] = 9.8667;
	points[7] = (13240.5117, 6842.7559, 628.4331);
	angles[7] = (0, -89.5394, 0);
	at[7] = 10.6667;
	points[8] = (13245.0400, 6842.9531, 628.4331);
	angles[8] = (0, -87.1678, 0);
	at[8] = 10.9333;
	points[9] = (13310.6699, 6853.5039, 628.4331);
	angles[9] = (0, -75.7626, 0);
	at[9] = 14.6667;
	points[10] = (13324.1729, 6857.6772, 628.4331);
	angles[10] = (0, -70.0993, 0);
	at[10] = 15.4667;
	points[11] = (13328.5439, 6859.5273, 628.4331);
	angles[11] = (0, -65.1003, 0);
	at[11] = 15.7333;
	points[12] = (13336.1426, 6864.6455, 628.4331);
	angles[12] = (0, -52.2561, 0);
	at[12] = 16.2667;
	points[13] = (13343.2686, 6870.8267, 628.4331);
	angles[13] = (0, -47.6717, 0);
	at[13] = 16.8000;
	points[14] = (13390.6689, 6923.8584, 628.4331);
	angles[14] = (0, -37.1934, 0);
	at[14] = 20.8000;
	points[15] = (13402.4014, 6944.0161, 628.4331);
	angles[15] = (0, -24.2524, 0);
	at[15] = 22.1333;
	points[16] = (13414.4102, 6974.8818, 628.4331);
	angles[16] = (0, -19.5445, 0);
	at[16] = 24;
	points[17] = (13424.7246, 7006.4175, 628.4331);
	angles[17] = (0, -16.7328, 0);
	at[17] = 25.8667;
	points[18] = (13428.2285, 7019.9214, 628.4331);
	angles[18] = (0, -12.1274, 0);
	at[18] = 26.6667;
	points[19] = (13436.5352, 7080.8662, 628.4331);
	angles[19] = (0, -2.9021, 0);
	at[19] = 30.1333;
	points[20] = (13435.2363, 7094.8823, 628.4331);
	angles[20] = (0, 10.8174, 0);
	at[20] = 30.9333;
	points[21] = (13423.4248, 7130.8267, 628.4331);
	angles[21] = (0, 25.7000, 0);
	at[21] = 33.0667;
	points[22] = (13421.1025, 7134.9214, 628.4331);
	angles[22] = (0, 31.9559, 0);
	at[22] = 33.3333;
	points[23] = (13418.0713, 7138.4253, 628.4331);
	angles[23] = (0, 42.9360, 0);
	at[23] = 33.6000;
	points[24] = (13411.0244, 7144.6064, 628.4331);
	angles[24] = (0, 50.5649, 0);
	at[24] = 34.1333;
	points[25] = (13383.7402, 7163.4253, 628.4331);
	angles[25] = (0, 59.4375, 0);
	at[25] = 36;
	points[26] = (13375.3154, 7167.7954, 628.4331);
	angles[26] = (0, 65.6973, 0);
	at[26] = 36.5333;
	points[27] = (13370.9834, 7169.3306, 628.4331);
	angles[27] = (0, 71.6692, 0);
	at[27] = 36.8000;
	points[28] = (13361.9297, 7171.7715, 628.4331);
	angles[28] = (0, 75.9081, 0);
	at[28] = 37.3333;
	points[29] = (13310.4727, 7180.8662, 628.4331);
	angles[29] = (0, 85.0673, 0);
	at[29] = 40.2667;
	points[30] = (13296.5352, 7180.7485, 628.4331);
	angles[30] = (0, 92.6579, 0);
	at[30] = 41.0667;
	points[31] = (13254.1738, 7176.2993, 628.4331);
	angles[31] = (0, 99.0538, 0);
	at[31] = 43.4667;
	points[32] = (13240.2363, 7173.4253, 628.4331);
	angles[32] = (0, 104.5767, 0);
	at[32] = 44.2667;
	points[33] = (13227.1260, 7168.8188, 628.4331);
	angles[33] = (0, 110.8391, 0);
	at[33] = 45.0667;
	points[34] = (13166.7725, 7141.3784, 628.4331);
	angles[34] = (0, 118.7908, 0);
	at[34] = 48.8000;
	points[35] = (13158.5430, 7136.4570, 628.4331);
	angles[35] = (0, 122.6871, 0);
	at[35] = 49.3333;
	points[36] = (13148.0312, 7127.5200, 628.4331);
	angles[36] = (0, 134.7922, 0);
	at[36] = 50.1333;
	points[37] = (13103.7012, 7071.9688, 628.4331);
	angles[37] = (0, 147.0147, 0);
	at[37] = 54.1333;
	points[38] = (13096.6533, 7059.6064, 628.4331);
	angles[38] = (0, 153.5378, 0);
	at[38] = 54.9333;
	points[39] = (13094.8818, 7055.3940, 628.4331);
	angles[39] = (0, 159.2615, 0);
	at[39] = 55.2000;
	points[40] = (13093.7402, 7051.1416, 628.4331);
	angles[40] = (0, 165.9706, 0);
	at[40] = 55.4667;
	points[41] = (13092.1270, 7041.7324, 628.4331);
	angles[41] = (0, 172.0217, 0);
	at[41] = 56;
	points[42] = (13090.7881, 6970.6689, 628.4331);
	angles[42] = (0, 184.7332, 0);
	at[42] = 60;
	points[43] = (13092.7559, 6956.5356, 628.4331);
	angles[43] = (0, 191.3152, 0);
	at[43] = 60.8000;
	points[44] = (13094.0547, 6951.9292, 628.4331);
	angles[44] = (0, 197.8699, 0);
	at[44] = 61.0833;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (11610.0391, 7620.8667, 628.4331);
	angles[0] = (0, -50.9331, 0);
	at[0] = 0;
	points[1] = (11613.8984, 7625.0391, 628.4331);
	angles[1] = (0, -40.1054, 0);
	at[1] = 0.3500;
	points[2] = (11617.6768, 7630.3149, 628.4331);
	angles[2] = (0, -33.9262, 0);
	at[2] = 0.7000;
	points[3] = (11624.0557, 7641.1812, 628.4331);
	angles[3] = (0, -28.5035, 0);
	at[3] = 1.4000;
	points[4] = (11644.2920, 7686.4175, 628.4331);
	angles[4] = (0, -21.5956, 0);
	at[4] = 4.2000;
	points[5] = (11666.8896, 7751.1812, 628.4331);
	angles[5] = (0, -16.8832, 0);
	at[5] = 8.0500;
	points[6] = (11672.8740, 7774.6064, 628.4331);
	angles[6] = (0, -9.9722, 0);
	at[6] = 9.4500;
	points[7] = (11675.1182, 7811.8896, 628.4331);
	angles[7] = (0, -0.0242, 0);
	at[7] = 11.5500;
	points[8] = (11671.6152, 7867.7163, 628.4331);
	angles[8] = (0, 7.1961, 0);
	at[8] = 14.7000;
	points[9] = (11667.0088, 7891.6147, 628.4331);
	angles[9] = (0, 16.2710, 0);
	at[9] = 16.1000;
	points[10] = (11658.2275, 7915, 628.4331);
	angles[10] = (0, 22.3390, 0);
	at[10] = 17.5000;
	points[11] = (11608.5830, 8015.4727, 628.4331);
	angles[11] = (0, 31.9462, 0);
	at[11] = 23.8000;
	points[12] = (11601.4961, 8025.5513, 628.4331);
	angles[12] = (0, 38.4832, 0);
	at[12] = 24.5000;
	points[13] = (11592.7158, 8033.6611, 628.4331);
	angles[13] = (0, 51.8632, 0);
	at[13] = 25.2000;
	points[14] = (11582.4805, 8040.6694, 628.4331);
	angles[14] = (0, 57.6792, 0);
	at[14] = 25.9000;
	points[15] = (11509.2520, 8074.8823, 628.4331);
	angles[15] = (0, 70.2379, 0);
	at[15] = 30.4500;
	points[16] = (11491.7715, 8079.9609, 628.4331);
	angles[16] = (0, 77.9882, 0);
	at[16] = 31.5000;
	points[17] = (11392.5986, 8089.3306, 628.4331);
	angles[17] = (0, 89.4897, 0);
	at[17] = 37.1000;
	points[18] = (11386.5352, 8089.2520, 628.4331);
	angles[18] = (0, 91.3841, 0);
	at[18] = 37.4500;
	points[19] = (11368.5830, 8085.5513, 628.4331);
	angles[19] = (0, 109.4999, 0);
	at[19] = 38.5000;
	points[20] = (11346.2607, 8074.7637, 628.4331);
	angles[20] = (0, 119.9133, 0);
	at[20] = 39.9000;
	points[21] = (11330.7080, 8064.4492, 628.4331);
	angles[21] = (0, 126.5865, 0);
	at[21] = 40.9500;
	points[22] = (11321.2998, 8056.2993, 628.4331);
	angles[22] = (0, 135.1897, 0);
	at[22] = 41.6500;
	points[23] = (11317.6768, 8051.7715, 628.4331);
	angles[23] = (0, 143.7263, 0);
	at[23] = 42;
	points[24] = (11314.2910, 8046.5747, 628.4331);
	angles[24] = (0, 148.0729, 0);
	at[24] = 42.3500;
	points[25] = (11308.0713, 8035.6694, 628.4331);
	angles[25] = (0, 151.3671, 0);
	at[25] = 43.0500;
	points[26] = (11282.2441, 7979.0161, 628.4331);
	angles[26] = (0, 159.9688, 0);
	at[26] = 46.5500;
	points[27] = (11277.6377, 7961.4175, 628.4331);
	angles[27] = (0, 171.4542, 0);
	at[27] = 47.6000;
	points[28] = (11275.9453, 7942.8740, 628.4331);
	angles[28] = (0, 176.3922, 0);
	at[28] = 48.6500;
	points[29] = (11276.0244, 7874.4492, 628.4331);
	angles[29] = (0, 183.8596, 0);
	at[29] = 52.5000;
	points[30] = (11278.2285, 7856.3384, 628.4331);
	angles[30] = (0, 190.8189, 0);
	at[30] = 53.5500;
	points[31] = (11284.7236, 7832.3623, 628.4331);
	angles[31] = (0, 196.8560, 0);
	at[31] = 54.9500;
	points[32] = (11318.1885, 7738.3857, 628.4331);
	angles[32] = (0, 202.7062, 0);
	at[32] = 60.5500;
	points[33] = (11323.3076, 7727.0869, 628.4331);
	angles[33] = (0, 206.1868, 0);
	at[33] = 61.2500;
	points[34] = (11326.1035, 7722.1655, 628.4331);
	angles[34] = (0, 211.2108, 0);
	at[34] = 61.6000;
	points[35] = (11337.4014, 7707.2837, 628.4331);
	angles[35] = (0, 220.2677, 0);
	at[35] = 62.6500;
	points[36] = (11354.3311, 7689.0552, 628.4331);
	angles[36] = (0, 224.4720, 0);
	at[36] = 64.0500;
	points[37] = (11381.1016, 7663.1104, 628.4331);
	angles[37] = (0, 226.5434, 0);
	at[37] = 66.1500;
	points[38] = (11402.5596, 7641.0630, 628.4331);
	angles[38] = (0, 223.2488, 0);
	at[38] = 67.9000;
	points[39] = (11433.3076, 7610.1968, 628.4331);
	angles[39] = (0, 227.4922, 0);
	at[39] = 70.3500;
	points[40] = (11452.7158, 7594.6460, 628.4331);
	angles[40] = (0, 235.8395, 0);
	at[40] = 71.7500;
	points[41] = (11463.8584, 7588.8584, 628.4331);
	angles[41] = (0, 249.0158, 0);
	at[41] = 72.4500;
	points[42] = (11469.2520, 7587.7163, 628.4331);
	angles[42] = (0, 262.4271, 0);
	at[42] = 72.8000;
	points[43] = (11475.8262, 7587.4805, 628.4331);
	angles[43] = (0, 269.5539, 0);
	at[43] = 73.1500;
	points[44] = (11481.6533, 7587.6772, 628.4331);
	angles[44] = (0, 272.6544, 0);
	at[44] = 73.5000;
	points[45] = (11537.2441, 7595.7485, 628.4331);
	angles[45] = (0, 281.5995, 0);
	at[45] = 76.6500;
	points[46] = (11585.3545, 7608.6221, 628.4331);
	angles[46] = (0, 289.1435, 0);
	at[46] = 79.4500;
	points[47] = (11602.3633, 7615.7871, 628.4331);
	angles[47] = (0, 297.1201, 0);
	at[47] = 80.5000;
	points[48] = (11610.0391, 7620.8667, 628.4331);
	angles[48] = (0, 309.0669, 0);
	at[48] = 81.0167;
	mover = getEnt("iz_obj_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (9322.6377, 7127.4409, 628.4331);
	angles[0] = (0, 2.5702, 0);
	at[0] = 0;
	points[1] = (9319.4092, 7153.3467, 628.4331);
	angles[1] = (0, 8.9682, 0);
	at[1] = 1.5000;
	points[2] = (9302.0479, 7240.7090, 628.4331);
	angles[2] = (0, 12.5814, 0);
	at[2] = 6.5000;
	points[3] = (9270.7090, 7359.6455, 628.4331);
	angles[3] = (0, 19.0271, 0);
	at[3] = 13.5000;
	points[4] = (9222.8740, 7484.5669, 628.4331);
	angles[4] = (0, 22.2272, 0);
	at[4] = 21;
	points[5] = (9179.8037, 7582.0869, 628.4331);
	angles[5] = (0, 26.3015, 0);
	at[5] = 27;
	points[6] = (9167.1260, 7605.8662, 628.4331);
	angles[6] = (0, 30.1976, 0);
	at[6] = 28.5000;
	points[7] = (9145.6699, 7632.7168, 628.4331);
	angles[7] = (0, 45.4456, 0);
	at[7] = 30.5000;
	points[8] = (9083.1895, 7682.5986, 628.4331);
	angles[8] = (0, 55.0507, 0);
	at[8] = 35;
	points[9] = (9015.3154, 7724.4883, 628.4331);
	angles[9] = (0, 62.2868, 0);
	at[9] = 39.5000;
	points[10] = (8999.2910, 7732.2046, 628.4331);
	angles[10] = (0, 66.3091, 0);
	at[10] = 40.5000;
	points[11] = (8990.5908, 7735.5903, 628.4331);
	angles[11] = (0, 70.6467, 0);
	at[11] = 41;
	points[12] = (8982.9531, 7737.5591, 628.4331);
	angles[12] = (0, 79.3469, 0);
	at[12] = 41.5000;
	points[13] = (8973.7803, 7738.3071, 628.4331);
	angles[13] = (0, 87.8839, 0);
	at[13] = 42;
	points[14] = (8956.1816, 7737.4805, 628.4331);
	angles[14] = (0, 95.4722, 0);
	at[14] = 43;
	points[15] = (8886.6934, 7723.1895, 628.4331);
	angles[15] = (0, 105.6034, 0);
	at[15] = 47;
	points[16] = (8827.9922, 7702.4019, 628.4331);
	angles[16] = (0, 115.1934, 0);
	at[16] = 50.5000;
	points[17] = (8806.9297, 7687.5986, 628.4331);
	angles[17] = (0, 132.4552, 0);
	at[17] = 52;
	points[18] = (8788.2676, 7668.3071, 628.4331);
	angles[18] = (0, 138.0150, 0);
	at[18] = 53.5000;
	points[19] = (8754.6455, 7627.0474, 628.4331);
	angles[19] = (0, 143.0405, 0);
	at[19] = 56.5000;
	points[20] = (8729.2520, 7590.3545, 628.4331);
	angles[20] = (0, 147.8915, 0);
	at[20] = 59;
	points[21] = (8717.2842, 7567.6382, 628.4331);
	angles[21] = (0, 157.8252, 0);
	at[21] = 60.5000;
	points[22] = (8696.8506, 7499.3311, 628.4331);
	angles[22] = (0, 165.9938, 0);
	at[22] = 64.5000;
	points[23] = (8682.7168, 7429.7642, 628.4331);
	angles[23] = (0, 171.8253, 0);
	at[23] = 68.5000;
	points[24] = (8680.8271, 7412.1655, 628.4331);
	angles[24] = (0, 176.0826, 0);
	at[24] = 69.5000;
	points[25] = (8680.6689, 7403.0317, 628.4331);
	angles[25] = (0, 181.5004, 0);
	at[25] = 70;
	points[26] = (8681.7715, 7395, 628.4331);
	angles[26] = (0, 191.2365, 0);
	at[26] = 70.5000;
	points[27] = (8684.1738, 7386.3389, 628.4331);
	angles[27] = (0, 197.3695, 0);
	at[27] = 71;
	points[28] = (8690.4727, 7369.7642, 628.4331);
	angles[28] = (0, 202.7735, 0);
	at[28] = 72;
	points[29] = (8709.8037, 7329.6460, 628.4331);
	angles[29] = (0, 207.4415, 0);
	at[29] = 74.5000;
	points[30] = (8735.0391, 7282.7168, 628.4331);
	angles[30] = (0, 208.3557, 0);
	at[30] = 77.5000;
	points[31] = (8747.0078, 7259.2129, 628.4331);
	angles[31] = (0, 204.2239, 0);
	at[31] = 79;
	points[32] = (8773.9375, 7193.5435, 628.4331);
	angles[32] = (0, 202.0684, 0);
	at[32] = 83;
	points[33] = (8794.7246, 7144.6455, 628.4331);
	angles[33] = (0, 205.5595, 0);
	at[33] = 86;
	points[34] = (8836.7715, 7066.6143, 628.4331);
	angles[34] = (0, 209.7519, 0);
	at[34] = 91;
	points[35] = (8855.1973, 7036.0630, 628.4331);
	angles[35] = (0, 213.2996, 0);
	at[35] = 93;
	points[36] = (8882.0078, 7001.3784, 628.4331);
	angles[36] = (0, 219.5051, 0);
	at[36] = 95.5000;
	points[37] = (8917.4805, 6961.4966, 628.4331);
	angles[37] = (0, 224.4251, 0);
	at[37] = 98.5000;
	points[38] = (8930.3936, 6949.3311, 628.4331);
	angles[38] = (0, 229.1375, 0);
	at[38] = 99.5000;
	points[39] = (8937.0869, 6944.2124, 628.4331);
	angles[39] = (0, 235.1509, 0);
	at[39] = 100;
	points[40] = (8960.1973, 6931.1025, 628.4331);
	angles[40] = (0, 242.6234, 0);
	at[40] = 101.5000;
	points[41] = (9049.8428, 6891.5752, 628.4331);
	angles[41] = (0, 250.4182, 0);
	at[41] = 107;
	points[42] = (9066.3389, 6886.7715, 628.4331);
	angles[42] = (0, 258.3303, 0);
	at[42] = 108;
	points[43] = (9084.0947, 6884.6851, 628.4331);
	angles[43] = (0, 265.6396, 0);
	at[43] = 109;
	points[44] = (9128.4248, 6884.1733, 628.4331);
	angles[44] = (0, 272.1984, 0);
	at[44] = 111.5000;
	points[45] = (9163.6621, 6887.4805, 628.4331);
	angles[45] = (0, 279, 0);
	at[45] = 113.5000;
	points[46] = (9180.9844, 6891.7715, 628.4331);
	angles[46] = (0, 289.8209, 0);
	at[46] = 114.5000;
	points[47] = (9188.5439, 6895.4331, 628.4331);
	angles[47] = (0, 298.4023, 0);
	at[47] = 115;
	points[48] = (9203.6611, 6904.8818, 628.4331);
	angles[48] = (0, 303.8167, 0);
	at[48] = 116;
	points[49] = (9246.2598, 6937.0078, 628.4331);
	angles[49] = (0, 309.3741, 0);
	at[49] = 119;
	points[50] = (9279.1729, 6966.6538, 628.4331);
	angles[50] = (0, 315.1979, 0);
	at[50] = 121.5000;
	points[51] = (9291.1025, 6980.2363, 628.4331);
	angles[51] = (0, 322.7622, 0);
	at[51] = 122.5000;
	points[52] = (9295.3154, 6987.0869, 628.4331);
	angles[52] = (0, 332.1798, 0);
	at[52] = 123;
	points[53] = (9302.0078, 7003.8584, 628.4331);
	angles[53] = (0, 341.1329, 0);
	at[53] = 124;
	points[54] = (9315.0400, 7055.3940, 628.4331);
	angles[54] = (0, 348.8794, 0);
	at[54] = 127;
	points[55] = (9321.6143, 7099.2129, 628.4331);
	angles[55] = (0, 354.2895, 0);
	at[55] = 129.5000;
	points[56] = (9322.6377, 7127.4409, 628.4331);
	angles[56] = (0, 362.5702, 0);
	at[56] = 131.1000;
	mover = getEnt("iz_obj_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6639.7246, 6564.1733, 628.4331);
	angles[0] = (0, -156.0785, 0);
	at[0] = 0;
	points[1] = (6687.3228, 6467.6777, 628.4331);
	angles[1] = (0, -151.3433, 0);
	at[1] = 6.0667;
	points[2] = (6707.4409, 6434.7637, 628.4331);
	angles[2] = (0, -143.9887, 0);
	at[2] = 8.2333;
	points[3] = (6717.7168, 6423.9370, 628.4331);
	angles[3] = (0, -131.4821, 0);
	at[3] = 9.1000;
	points[4] = (6723.5039, 6419.1733, 628.4331);
	angles[4] = (0, -128.2883, 0);
	at[4] = 9.5333;
	points[5] = (6755.6299, 6397.8740, 628.4331);
	angles[5] = (0, -120.3174, 0);
	at[5] = 11.7000;
	points[6] = (6790.1182, 6380.6694, 628.4331);
	angles[6] = (0, -112.3377, 0);
	at[6] = 13.8667;
	points[7] = (6804.6455, 6375.7085, 628.4331);
	angles[7] = (0, -105.5155, 0);
	at[7] = 14.7333;
	points[8] = (6812.2837, 6374.1733, 628.4331);
	angles[8] = (0, -98.5984, 0);
	at[8] = 15.1667;
	points[9] = (6819.1733, 6373.9766, 628.4331);
	angles[9] = (0, -87.9372, 0);
	at[9] = 15.6000;
	points[10] = (6834.5674, 6376.1416, 628.4331);
	angles[10] = (0, -79.4827, 0);
	at[10] = 16.4667;
	points[11] = (6886.7715, 6389.8818, 628.4331);
	angles[11] = (0, -72.6842, 0);
	at[11] = 19.5000;
	points[12] = (6944.6455, 6411.1021, 628.4331);
	angles[12] = (0, -66.5182, 0);
	at[12] = 22.9667;
	points[13] = (6958.6221, 6417.7559, 628.4331);
	angles[13] = (0, -62.6535, 0);
	at[13] = 23.8333;
	points[14] = (6970.8662, 6425.3940, 628.4331);
	angles[14] = (0, -54.1994, 0);
	at[14] = 24.7000;
	points[15] = (6989.1729, 6440.2754, 628.4331);
	angles[15] = (0, -49.1958, 0);
	at[15] = 26;
	points[16] = (7033.9370, 6482.3228, 628.4331);
	angles[16] = (0, -45.0561, 0);
	at[16] = 29.4667;
	points[17] = (7070.9844, 6521.6143, 628.4331);
	angles[17] = (0, -41.4276, 0);
	at[17] = 32.5000;
	points[18] = (7090.2363, 6545.3154, 628.4331);
	angles[18] = (0, -36.0872, 0);
	at[18] = 34.2333;
	points[19] = (7103.1104, 6572.5591, 628.4331);
	angles[19] = (0, -16.1357, 0);
	at[19] = 35.9667;
	points[20] = (7111.7324, 6618.0317, 628.4331);
	angles[20] = (0, -7.4471, 0);
	at[20] = 38.5667;
	points[21] = (7115.8662, 6687.0474, 628.4331);
	angles[21] = (0, 0.9808, 0);
	at[21] = 42.4667;
	points[22] = (7115.0396, 6702.4805, 628.4331);
	angles[22] = (0, 4.9009, 0);
	at[22] = 43.3333;
	points[23] = (7110.5117, 6724.7642, 628.4331);
	angles[23] = (0, 16.3844, 0);
	at[23] = 44.6333;
	points[24] = (7082.9526, 6796.4175, 628.4331);
	angles[24] = (0, 23.4828, 0);
	at[24] = 48.9667;
	points[25] = (7049.4888, 6865.7876, 628.4331);
	angles[25] = (0, 28.5942, 0);
	at[25] = 53.3000;
	points[26] = (7037.8350, 6885.5903, 628.4331);
	angles[26] = (0, 32.6835, 0);
	at[26] = 54.6000;
	points[27] = (7028.9761, 6897.5591, 628.4331);
	angles[27] = (0, 40.5831, 0);
	at[27] = 55.4667;
	points[28] = (7012.6382, 6913.6221, 628.4331);
	angles[28] = (0, 47.9065, 0);
	at[28] = 56.7667;
	points[29] = (6964.4092, 6952.2446, 628.4331);
	angles[29] = (0, 53.6796, 0);
	at[29] = 60.2333;
	points[30] = (6893.0312, 6997.6382, 628.4331);
	angles[30] = (0, 63.2073, 0);
	at[30] = 65;
	points[31] = (6879.0947, 7003.7793, 628.4331);
	angles[31] = (0, 68.9202, 0);
	at[31] = 65.8667;
	points[32] = (6871.2993, 7006.2202, 628.4331);
	angles[32] = (0, 75.3845, 0);
	at[32] = 66.3000;
	points[33] = (6864.6455, 7007.1260, 628.4331);
	angles[33] = (0, 86.8133, 0);
	at[33] = 66.7333;
	points[34] = (6856.7720, 7006.6143, 628.4331);
	angles[34] = (0, 96.5576, 0);
	at[34] = 67.1667;
	points[35] = (6849.4097, 7005.2759, 628.4331);
	angles[35] = (0, 101.6346, 0);
	at[35] = 67.6000;
	points[36] = (6827.1655, 6998.8584, 628.4331);
	angles[36] = (0, 108.6960, 0);
	at[36] = 68.9000;
	points[37] = (6742.4805, 6961.5752, 628.4331);
	angles[37] = (0, 116.8851, 0);
	at[37] = 74.1000;
	points[38] = (6701.6538, 6939.4883, 628.4331);
	angles[38] = (0, 120.3238, 0);
	at[38] = 76.7000;
	points[39] = (6677.2441, 6922.0864, 628.4331);
	angles[39] = (0, 129.5823, 0);
	at[39] = 78.4333;
	points[40] = (6632.3228, 6879.8428, 628.4331);
	angles[40] = (0, 135.8217, 0);
	at[40] = 81.9000;
	points[41] = (6597.1260, 6839.1343, 628.4331);
	angles[41] = (0, 144.6476, 0);
	at[41] = 84.9333;
	points[42] = (6587.9927, 6818.5430, 628.4331);
	angles[42] = (0, 164.3140, 0);
	at[42] = 86.2333;
	points[43] = (6582.4014, 6788.2285, 628.4331);
	angles[43] = (0, 172.7412, 0);
	at[43] = 87.9667;
	points[44] = (6580.0791, 6734.3701, 628.4331);
	angles[44] = (0, 182.7124, 0);
	at[44] = 91;
	points[45] = (6583.4648, 6712.0869, 628.4331);
	angles[45] = (0, 194.6479, 0);
	at[45] = 92.3000;
	points[46] = (6595.4331, 6675.5513, 628.4331);
	angles[46] = (0, 199.6973, 0);
	at[46] = 94.4667;
	points[47] = (6639.7246, 6564.1733, 628.4331);
	angles[47] = (0, 203.9215, 0);
	at[47] = 101.2170;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover_loop(points, angles, at, once, closed)
{
	wait 0.05;
	self iz_place(points[0], iz_pose(angles, 0));
	period = at[at.size - 1];
	if (period < 0.05)
		return;
	done = 0;
	for (pass = 0; !once || pass < 1; pass++)
	{
		if (pass && !closed)
			self iz_place(points[0], iz_pose(angles, 0));
		for (i = 1; i < points.size; i++)
		{
			if (at[i] == at[i - 1])
			{
				self iz_place(points[i], iz_pose(angles, i));
				continue;
			}
			due = int((pass * period + at[i]) * 20 + 0.5);
			if (due <= done)
				continue;
			self iz_move(points[i], iz_pose(angles, i), due - done);
			wait 0.05 * (due - done);
			done = due;
		}
	}
	last = points.size - 1;
	self iz_stop(points[last], iz_pose(angles, last));
}

iz_pose(angles, i)
{
	if (isDefined(angles))
		return angles[i];
}
