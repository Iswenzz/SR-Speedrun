main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_dks_jungle", 0);

	setExpFog(5905.5117, 14517.7158, 1, 0.7765, 0.2706, 0);

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
	ambientPlay("iz_0_r_64_jungle32", 2);
	iz_emitter("iz_1_se_cc_env_river", (2066.9292, -10378.9375, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (2583.6614, -9570.6201, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3100.3938, -8762.3037, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3617.1260, -7953.9863, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4133.8584, -7145.6694, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4111.7129, -6230.3149, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4089.5669, -5314.9609, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4067.4214, -4399.6064, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4045.2756, -3484.2520, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3568.6162, -2509.8428, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3091.9575, -1535.4331, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (2615.2979, -561.0235, 1175.4915), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (2138.6389, 413.3860, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1661.9799, 1387.7954, 1175.4915), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (1185.3207, 2362.2048, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (708.6614, 3336.6143, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4311.0234, -12194.8818, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4835.1377, -11375.4922, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (5359.2520, -10556.1025, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (5883.3662, -9736.7129, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6407.4805, -8917.3232, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6363.1890, -7805.1182, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6318.8979, -6692.9131, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6274.6064, -5580.7085, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6230.3149, -4468.5039, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6186.0239, -3356.2993, 1175.4918), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6141.7324, -2244.0945, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (5684.0552, -1161.4174, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (5226.3779, -78.7400, 1175.4916), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4768.7007, 1003.9370, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (4311.0234, 2086.6143, 1175.4917), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3853.3464, 3169.2913, 1175.4918), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (3395.6694, 4251.9688, 1175.4917), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (147.6378, 4251.9688, 295.2756), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_water_fall", (679.1339, 5639.7637, 295.2756), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-1728, 1666, 1294);
	level.iz_route[level.iz_route.size] = (-738, 1550, 1294);
	level.iz_route[level.iz_route.size] = (-15, 1225, 1294);
	level.iz_route[level.iz_route.size] = (591, 517, 1294);
	level.iz_route[level.iz_route.size] = (1122, -325, 1294);
	level.iz_route[level.iz_route.size] = (1698, -1403, 1293);
	level.iz_route[level.iz_route.size] = (2170, -2274, 1294);
	level.iz_route[level.iz_route.size] = (2584, -3263, 1294);
	level.iz_route[level.iz_route.size] = (2894, -4163, 1294);
	level.iz_route[level.iz_route.size] = (3056, -5226, 1294);
	level.iz_route[level.iz_route.size] = (2953, -6555, 1294);
	level.iz_route[level.iz_route.size] = (2717, -7352, 1294);
	level.iz_route[level.iz_route.size] = (2510, -7618, 1299);
	level.iz_route[level.iz_route.size] = (1978, -8268, 1294);
	level.iz_route[level.iz_route.size] = (1594, -8504, 1294);
	level.iz_route[level.iz_route.size] = (1270, -8652, 1294);
	level.iz_route[level.iz_route.size] = (605, -8725, 1299);
	level.iz_route[level.iz_route.size] = (-325, -8415, 1324);
	level.iz_route[level.iz_route.size] = (-797, -7766, 1334);
	level.iz_route[level.iz_route.size] = (-768, -6998, 1354);
	level.iz_route[level.iz_route.size] = (-561, -6585, 1369);
	level.iz_route[level.iz_route.size] = (-89, -6230, 1382);
	level.iz_route[level.iz_route.size] = (413, -6142, 1394);
	level.iz_route[level.iz_route.size] = (915, -6260, 1414);
	level.iz_route[level.iz_route.size] = (1757, -6850, 1504);
	level.iz_route[level.iz_route.size] = (2333, -7323, 1589);
	level.iz_route[level.iz_route.size] = (3255, -8099, 1525);
	level.iz_route[level.iz_route.size] = (4370, -9050, 1446);
	level.iz_route[level.iz_route.size] = (5501, -9991, 1416);
	level.iz_route[level.iz_route.size] = (6614, -10615, 1299);
	level.iz_route[level.iz_route.size] = (7500, -10571, 1294);
	level.iz_route[level.iz_route.size] = (7943, -9980, 1294);
	level.iz_route[level.iz_route.size] = (7840, -8681, 1294);
	level.iz_route[level.iz_route.size] = (7736, -7662, 1294);
	level.iz_route[level.iz_route.size] = (7677, -6201, 1294);
	level.iz_route[level.iz_route.size] = (7559, -4665, 1294);
	level.iz_route[level.iz_route.size] = (7470, -3573, 1294);
	level.iz_route[level.iz_route.size] = (7515, -2717, 1294);
	level.iz_route[level.iz_route.size] = (8342, -2406, 1335);
	level.iz_route[level.iz_route.size] = (9611, -2436, 1443);
	level.iz_route[level.iz_route.size] = (10379, -2259, 1480);
	level.iz_route[level.iz_route.size] = (10763, -1742, 1480);
	level.iz_route[level.iz_route.size] = (10822, -709, 1480);
	level.iz_route[level.iz_route.size] = (10807, 251, 1480);
	level.iz_route[level.iz_route.size] = (10792, 1166, 1480);
	level.iz_route[level.iz_route.size] = (10748, 2096, 1480);
	level.iz_route[level.iz_route.size] = (10600, 2997, 1480);
	level.iz_route[level.iz_route.size] = (10364, 3617, 1480);
	level.iz_route[level.iz_route.size] = (9523, 3942, 1480);
	level.iz_route[level.iz_route.size] = (8489, 3706, 1480);
	level.iz_route[level.iz_route.size] = (7544, 3337, 1480);
	level.iz_route[level.iz_route.size] = (6644, 3027, 1480);
	level.iz_route[level.iz_route.size] = (5640, 3012, 1480);
	level.iz_route[level.iz_route.size] = (4975, 3514, 1480);
	level.iz_route[level.iz_route.size] = (4961, 4473, 1480);
	level.iz_route[level.iz_route.size] = (5404, 5285, 1480);
	level.iz_route[level.iz_route.size] = (6289, 6112, 1480);
	level.iz_route[level.iz_route.size] = (7279, 6998, 1480);
	level.iz_route[level.iz_route.size] = (7707, 8046, 1480);
	level.iz_route[level.iz_route.size] = (7146, 9124, 1480);
	level.iz_route[level.iz_route.size] = (6068, 9449, 1432);
	level.iz_route[level.iz_route.size] = (4857, 9537, 1310);
	level.iz_route[level.iz_route.size] = (3602, 9626, 1155);
	level.iz_route[level.iz_route.size] = (2672, 9641, 1014);
	level.iz_route[level.iz_route.size] = (1654, 9478, 808);
	level.iz_route[level.iz_route.size] = (915, 9094, 624);
	level.iz_route[level.iz_route.size] = (192, 8342, 415);
	level.iz_route[level.iz_route.size] = (-148, 7840, 361);
	level.iz_route[level.iz_route.size] = (-340, 7397, 358);
	level.iz_route[level.iz_route.size] = (-428, 7131, 358);
	level.iz_route[level.iz_route.size] = (-531, 6526, 268);
	level.iz_route[level.iz_route.size] = (-635, 5935, 224);
	level.iz_route[level.iz_route.size] = (-753, 5330, 224);
	level.iz_route[level.iz_route.size] = (-871, 4739, 268);
	level.iz_route[level.iz_route.size] = (-974, 4163, 354);
	level.iz_route[level.iz_route.size] = (-1048, 3735, 362);
	level.iz_route[level.iz_route.size] = (-1314, 3292, 393);
	level.iz_route[level.iz_route.size] = (-1831, 2953, 445);
	level.iz_route[level.iz_route.size] = (-2598, 2894, 509);
	level.iz_route[level.iz_route.size] = (-3219, 3189, 501);
	level.iz_route[level.iz_route.size] = (-3661, 3484, 509);
	level.iz_route[level.iz_route.size] = (-4341, 4060, 559);
	level.iz_route[level.iz_route.size] = (-4975, 4400, 611);
	level.iz_route[level.iz_route.size] = (-5802, 4459, 711);
	level.iz_route[level.iz_route.size] = (-6393, 3853, 810);
	level.iz_route[level.iz_route.size] = (-6319, 3115, 874);
	level.iz_route[level.iz_route.size] = (-5950, 2525, 970);
	level.iz_route[level.iz_route.size] = (-4931, 1801, 1204);
	level.iz_route[level.iz_route.size] = (-4606, 1698, 1250);
	level.iz_route[level.iz_route.size] = (-3647, 1654, 1286);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1816.5079, 869.6890, 1175.4922);
	angles[0] = (0, -158.4684, 0);
	at[0] = 0;
	points[1] = (1832.1456, 832.4764, 1175.4922);
	angles[1] = (0, -157.3873, 0);
	at[1] = 0.5000;
	points[2] = (1851.0591, 789.0906, 1175.4922);
	angles[2] = (0, -156.5861, 0);
	at[2] = 1;
	points[3] = (1873.1102, 739.7835, 1175.4922);
	angles[3] = (0, -156.0051, 0);
	at[3] = 1.5000;
	points[4] = (1924.6654, 627.4646, 1175.4922);
	angles[4] = (0, -155.2440, 0);
	at[4] = 2.5000;
	points[5] = (1964.7953, 541.7166, 1175.4922);
	angles[5] = (0, -154.8745, 0);
	at[5] = 3.5000;
	points[6] = (2009.2284, 447.8425, 1175.4922);
	angles[6] = (0, -154.6344, 0);
	at[6] = 4.5000;
	points[7] = (2032.9606, 398.0354, 1175.4922);
	angles[7] = (0, -154.5361, 0);
	at[7] = 5;
	points[8] = (2083.2717, 293.0402, 1175.4922);
	angles[8] = (0, -154.3714, 0);
	at[8] = 6;
	points[9] = (2195.4172, 61.0224, 1175.4922);
	angles[9] = (0, -154.1256, 0);
	at[9] = 8.5000;
	points[10] = (2242.7087, -36.2374, 1175.4922);
	angles[10] = (0, -154.0579, 0);
	at[10] = 9.5000;
	points[11] = (2316.6221, -187.7622, 1175.4922);
	angles[11] = (0, -153.9756, 0);
	at[11] = 11;
	points[12] = (2430.5315, -420.4567, 1175.4922);
	angles[12] = (0, -153.8882, 0);
	at[12] = 13.5000;
	points[13] = (2574.0078, -712.6457, 1175.4922);
	angles[13] = (0, -153.8269, 0);
	at[13] = 16.5000;
	points[14] = (2690.2639, -949.0276, 1175.4922);
	angles[14] = (0, -153.8050, 0);
	at[14] = 19;
	points[15] = (2973.6614, -1525.2717, 1175.4922);
	angles[15] = (0, -153.8351, 0);
	at[15] = 25;
	points[16] = (3113.3267, -1809.9646, 1175.4922);
	angles[16] = (0, -153.8943, 0);
	at[16] = 28;
	points[17] = (3232.7283, -2054.1458, 1175.4922);
	angles[17] = (0, -153.9740, 0);
	at[17] = 30.5000;
	points[18] = (3302.2207, -2196.7402, 1175.4922);
	angles[18] = (0, -154.0370, 0);
	at[18] = 32;
	points[19] = (3369.6733, -2335.5828, 1175.4922);
	angles[19] = (0, -154.1131, 0);
	at[19] = 33.5000;
	points[20] = (3442.8191, -2486.7717, 1175.4922);
	angles[20] = (0, -154.2148, 0);
	at[20] = 35;
	points[21] = (3489.7798, -2584.2717, 1175.4922);
	angles[21] = (0, -154.2973, 0);
	at[21] = 36;
	points[22] = (3535.0435, -2678.6338, 1175.4922);
	angles[22] = (0, -154.3923, 0);
	at[22] = 37;
	points[23] = (3600.4133, -2815.7480, 1175.4922);
	angles[23] = (0, -154.5634, 0);
	at[23] = 38.5000;
	points[24] = (3650.2913, -2921.2363, 1175.4922);
	angles[24] = (0, -154.7294, 0);
	at[24] = 39.5000;
	points[25] = (3696.7205, -3020.3308, 1175.4922);
	angles[25] = (0, -154.9394, 0);
	at[25] = 40.5000;
	points[26] = (3739.4214, -3112.5198, 1175.4922);
	angles[26] = (0, -155.1994, 0);
	at[26] = 41.5000;
	points[27] = (3759.2954, -3155.8660, 1175.4922);
	angles[27] = (0, -155.3535, 0);
	at[27] = 42;
	points[28] = (3781.2834, -3204.2637, 1175.4922);
	angles[28] = (0, -155.5358, 0);
	at[28] = 42.5000;
	points[29] = (3807.0156, -3261.6182, 1175.4922);
	angles[29] = (0, -155.8133, 0);
	at[29] = 43;
	points[30] = (3830.2637, -3314.3701, 1175.4922);
	angles[30] = (0, -156.1768, 0);
	at[30] = 43.5000;
	points[31] = (3850.9253, -3362.3074, 1175.4922);
	angles[31] = (0, -156.6383, 0);
	at[31] = 44;
	points[32] = (3868.8818, -3405.2205, 1175.4922);
	angles[32] = (0, -157.2349, 0);
	at[32] = 44.5000;
	points[33] = (3884.4412, -3443.9490, 1175.4922);
	angles[33] = (0, -158.0329, 0);
	at[33] = 45;
	points[34] = (3920.3032, -3540.7166, 1175.4922);
	angles[34] = (0, -160.0277, 0);
	at[34] = 46;
	points[35] = (3953.1892, -3639.0315, 1175.4922);
	angles[35] = (0, -161.8093, 0);
	at[35] = 47;
	points[36] = (4020.4333, -3872.5396, 1175.4922);
	angles[36] = (0, -165.0400, 0);
	at[36] = 49.5000;
	points[37] = (4073.6614, -4093.7798, 1175.4922);
	angles[37] = (0, -167.2473, 0);
	at[37] = 52;
	points[38] = (4100.5513, -4220.2363, 1175.4922);
	angles[38] = (0, -168.2783, 0);
	at[38] = 53.5000;
	points[39] = (4124.4883, -4342.3228, 1175.4922);
	angles[39] = (0, -169.1561, 0);
	at[39] = 55;
	points[40] = (4145.7876, -4459.5669, 1175.4922);
	angles[40] = (0, -169.9180, 0);
	at[40] = 56.5000;
	points[41] = (4170.9058, -4609.7637, 1175.4922);
	angles[41] = (0, -170.7940, 0);
	at[41] = 58.5000;
	points[42] = (4202.5200, -4820.4331, 1175.4922);
	angles[42] = (0, -171.8881, 0);
	at[42] = 61.5000;
	points[43] = (4228.3071, -5015.1577, 1175.4922);
	angles[43] = (0, -172.8006, 0);
	at[43] = 64.5000;
	points[44] = (4246.2603, -5166.1416, 1175.4922);
	angles[44] = (0, -173.4651, 0);
	at[44] = 67;
	points[45] = (4255.3545, -5248.7397, 1175.4922);
	angles[45] = (0, -173.8232, 0);
	at[45] = 68.5000;
	points[46] = (4261.5352, -5307.5591, 1175.4922);
	angles[46] = (0, -174.0660, 0);
	at[46] = 69.5000;
	points[47] = (4271.6143, -5407.7168, 1175.4922);
	angles[47] = (0, -174.2442, 0);
	at[47] = 71.5000;
	points[48] = (4289.6851, -5594.5273, 1175.4922);
	angles[48] = (0, -174.8318, 0);
	at[48] = 75;
	points[49] = (4305.0786, -5806.1025, 1175.4922);
	angles[49] = (0, -176.7171, 0);
	at[49] = 79;
	points[50] = (4311.4570, -6019.2915, 1175.4922);
	angles[50] = (0, -179.5486, 0);
	at[50] = 83;
	points[51] = (4306.7715, -6205.3940, 1175.4922);
	angles[51] = (0, -182.9086, 0);
	at[51] = 86.5000;
	points[52] = (4292.5195, -6364.4883, 1175.4922);
	angles[52] = (0, -186.6906, 0);
	at[52] = 89.5000;
	points[53] = (4265.9448, -6521.8901, 1175.4922);
	angles[53] = (0, -191.6589, 0);
	at[53] = 92.5000;
	points[54] = (4247.0078, -6599.0161, 1175.4922);
	angles[54] = (0, -194.7269, 0);
	at[54] = 94;
	points[55] = (4223.2280, -6675.5117, 1175.4922);
	angles[55] = (0, -198.3445, 0);
	at[55] = 95.5000;
	points[56] = (4205.5513, -6722.8345, 1175.4922);
	angles[56] = (0, -201.0418, 0);
	at[56] = 96.5000;
	points[57] = (4187.5591, -6765.1577, 1175.4922);
	angles[57] = (0, -203.3345, 0);
	at[57] = 97.5000;
	points[58] = (4162.8345, -6818.9370, 1175.4922);
	angles[58] = (0, -204.9205, 0);
	at[58] = 98.5000;
	points[59] = (4130.4727, -6885.5513, 1175.4922);
	angles[59] = (0, -206.0588, 0);
	at[59] = 99.5000;
	points[60] = (4103.2285, -6939.8428, 1175.4922);
	angles[60] = (0, -206.7550, 0);
	at[60] = 100.5000;
	points[61] = (4071.5747, -7001.4570, 1175.4922);
	angles[61] = (0, -207.2570, 0);
	at[61] = 101.5000;
	points[62] = (4034.5669, -7072.2051, 1175.4922);
	angles[62] = (0, -207.6866, 0);
	at[62] = 102.5000;
	points[63] = (3993.4253, -7149.6064, 1175.4922);
	angles[63] = (0, -208.0574, 0);
	at[63] = 103.5000;
	points[64] = (3954.2124, -7222.4805, 1175.4922);
	angles[64] = (0, -208.3370, 0);
	at[64] = 104.5000;
	points[65] = (3909.9409, -7303.8584, 1175.4922);
	angles[65] = (0, -208.5818, 0);
	at[65] = 105.5000;
	points[66] = (3860.2205, -7394.4092, 1175.4922);
	angles[66] = (0, -208.8057, 0);
	at[66] = 106.5000;
	points[67] = (3781.5552, -7536.2207, 1175.4922);
	angles[67] = (0, -209.0928, 0);
	at[67] = 108;
	points[68] = (3724.4292, -7638.3467, 1175.4922);
	angles[68] = (0, -209.2569, 0);
	at[68] = 109;
	points[69] = (3661.5906, -7749.9219, 1175.4922);
	angles[69] = (0, -209.4103, 0);
	at[69] = 110;
	points[70] = (3595.5078, -7866.6143, 1175.4922);
	angles[70] = (0, -209.5511, 0);
	at[70] = 111;
	points[71] = (3524.8899, -7990.6304, 1175.4922);
	angles[71] = (0, -209.6798, 0);
	at[71] = 112;
	points[72] = (3487.4448, -8056.1421, 1175.4922);
	angles[72] = (0, -209.7413, 0);
	at[72] = 112.5000;
	points[73] = (3408.3503, -8194.0156, 1175.4922);
	angles[73] = (0, -209.8597, 0);
	at[73] = 113.5000;
	points[74] = (3323.8740, -8340.6299, 1175.4922);
	angles[74] = (0, -209.9719, 0);
	at[74] = 114.5000;
	points[75] = (3234.5081, -8495.0400, 1175.4922);
	angles[75] = (0, -210.0786, 0);
	at[75] = 115.5000;
	points[76] = (3136.2246, -8664.1338, 1175.4922);
	angles[76] = (0, -210.1843, 0);
	at[76] = 116.5000;
	points[77] = (3034.8503, -8837.8350, 1175.4922);
	angles[77] = (0, -210.2876, 0);
	at[77] = 117.5000;
	points[78] = (2865.4058, -9126.6143, 1175.4922);
	angles[78] = (0, -210.4523, 0);
	at[78] = 119;
	points[79] = (2740.2637, -9338.5830, 1175.4922);
	angles[79] = (0, -210.5849, 0);
	at[79] = 120;
	points[80] = (2674.0474, -9450.1572, 1175.4922);
	angles[80] = (0, -210.6710, 0);
	at[80] = 120.5000;
	points[81] = (2612.6616, -9553.0312, 1175.4922);
	angles[81] = (0, -210.8191, 0);
	at[81] = 121;
	points[82] = (2541.4844, -9668.0713, 1175.4922);
	angles[82] = (0, -211.7079, 0);
	at[82] = 121.5000;
	points[83] = (2464.9016, -9785.5508, 1175.4922);
	angles[83] = (0, -212.9299, 0);
	at[83] = 122;
	points[84] = (2383.1851, -9905.8271, 1175.4922);
	angles[84] = (0, -214.0260, 0);
	at[84] = 122.5000;
	points[85] = (2296.4370, -10029.2920, 1175.4922);
	angles[85] = (0, -214.9481, 0);
	at[85] = 123;
	points[86] = (2204.6575, -10156.4170, 1175.4922);
	angles[86] = (0, -215.7143, 0);
	at[86] = 123.5000;
	points[87] = (2108.0984, -10287.2051, 1175.4922);
	angles[87] = (0, -216.3351, 0);
	at[87] = 124;
	points[88] = (2007.9764, -10420.7490, 1175.4922);
	angles[88] = (0, -216.7777, 0);
	at[88] = 124.5000;
	points[89] = (1903.9843, -10559.4482, 1175.4922);
	angles[89] = (0, -216.7837, 0);
	at[89] = 125;
	points[90] = (1788.4528, -10714.3701, 1175.4922);
	angles[90] = (0, -216.7757, 0);
	at[90] = 125.5000;
	points[91] = (1648.9489, -10897.7949, 1175.4922);
	angles[91] = (0, -217.2135, 0);
	at[91] = 126;
	points[92] = (1480.4213, -11113.0312, 1175.4922);
	angles[92] = (0, -217.9837, 0);
	at[92] = 126.5000;
	points[93] = (1274.3307, -11362.7168, 1175.4922);
	angles[93] = (0, -219.4140, 0);
	at[93] = 127;
	points[94] = (1033.3740, -11621.9688, 1175.4922);
	angles[94] = (0, -222.3806, 0);
	at[94] = 127.5000;
	points[95] = (790.2166, -11875.5908, 1175.4922);
	angles[95] = (0, -223.4985, 0);
	at[95] = 128;
	points[96] = (544.4055, -12133.1104, 1175.4922);
	angles[96] = (0, -223.5916, 0);
	at[96] = 128.5000;
	points[97] = (300.6870, -12392.7559, 1175.4922);
	angles[97] = (0, -223.2060, 0);
	at[97] = 129;
	points[98] = (61.6315, -12654.9609, 1175.4922);
	angles[98] = (0, -222.4119, 0);
	at[98] = 129.5000;
	points[99] = (-171.6555, -12925, 1175.4922);
	angles[99] = (0, -220.9285, 0);
	at[99] = 130;
	points[100] = (-385.5854, -13207.7559, 1175.4922);
	angles[100] = (0, -217.1639, 0);
	at[100] = 130.5000;
	points[101] = (-554.7874, -13507.1260, 1175.4922);
	angles[101] = (0, -210.6938, 0);
	at[101] = 131;
	points[102] = (-716.3503, -13826.1035, 1175.4922);
	angles[102] = (0, -207.5078, 0);
	at[102] = 131.5000;
	points[103] = (-869.9528, -14147.5986, 1175.4922);
	angles[103] = (0, -205.8372, 0);
	at[103] = 132;
	points[104] = (-1017.1614, -14471.1025, 1175.4922);
	angles[104] = (0, -204.6470, 0);
	at[104] = 132.5000;
	points[105] = (-1158.1378, -14797.1650, 1175.4922);
	angles[105] = (0, -203.5240, 0);
	at[105] = 133;
	points[106] = (-1291.4882, -15125.9854, 1175.4922);
	angles[106] = (0, -202.2142, 0);
	at[106] = 133.5000;
	points[107] = (-1413.8662, -15458.7402, 1175.4922);
	angles[107] = (0, -200.3511, 0);
	at[107] = 134;
	points[108] = (-1516.4764, -15804.9219, 1175.4922);
	angles[108] = (0, -196.6968, 0);
	at[108] = 134.5000;
	points[109] = (-1561.1063, -16149.2910, 1175.4922);
	angles[109] = (0, -188.5406, 0);
	at[109] = 135;
	points[110] = (-1576.6299, -16526.3398, 1175.4922);
	angles[110] = (0, -183.4077, 0);
	at[110] = 135.5000;
	points[111] = (-1578.2126, -16929.4102, 1175.4922);
	angles[111] = (0, -180.7183, 0);
	at[111] = 136;
	points[112] = (-1567.4409, -17356.0625, 1175.4922);
	angles[112] = (0, -178.8420, 0);
	at[112] = 136.5000;
	points[113] = (-1542.2087, -17806.2988, 1175.4922);
	angles[113] = (0, -177.0218, 0);
	at[113] = 137;
	points[114] = (-1495.7953, -18278.9375, 1175.4922);
	angles[114] = (0, -174.6236, 0);
	at[114] = 137.5000;
	points[115] = (-1403.6614, -18777.7949, 1175.4922);
	angles[115] = (0, -169.7379, 0);
	at[115] = 138;
	points[116] = (-1108.0433, -19179.7246, 1175.4922);
	angles[116] = (0, -144.2858, 0);
	at[116] = 138.5000;
	points[117] = (-627.8740, -19417.4414, 1175.4922);
	angles[117] = (0, -121.4656, 0);
	at[117] = 139;
	points[118] = (-128.3961, -19605.9062, 1175.4922);
	angles[118] = (0, -112.6295, 0);
	at[118] = 139.5000;
	points[119] = (380.7236, -19772.4805, 1175.4922);
	angles[119] = (0, -108.8820, 0);
	at[119] = 140;
	points[120] = (892.8819, -19925.2363, 1175.4922);
	angles[120] = (0, -106.9758, 0);
	at[120] = 140.5000;
	points[121] = (1400.7008, -20006.1035, 1175.4922);
	angles[121] = (0, -96.3149, 0);
	at[121] = 141;
	points[122] = (1041.5000, -19748.7793, 1175.4922);
	angles[122] = (0, -14.9612, 0);
	at[122] = 141.5000;
	points[123] = (524.0472, -19612.6777, 1175.4922);
	angles[123] = (0, 51.3449, 0);
	at[123] = 142;
	points[124] = (7.5847, -19470.0391, 1175.4922);
	angles[124] = (0, 69.3587, 0);
	at[124] = 142.5000;
	points[125] = (-501.6339, -19309.0938, 1175.4922);
	angles[125] = (0, 71.4587, 0);
	at[125] = 143;
	points[126] = (-996.5827, -19103.5449, 1175.4922);
	angles[126] = (0, 67.3946, 0);
	at[126] = 143.5000;
	points[127] = (-1348.7126, -18739.7246, 1175.4922);
	angles[127] = (0, 44.5326, 0);
	at[127] = 144;
	points[128] = (-1521.1299, -18265.6289, 1175.4922);
	angles[128] = (0, 24.5306, 0);
	at[128] = 144.5000;
	points[129] = (-1646.5354, -17801.9688, 1175.4922);
	angles[129] = (0, 16.8005, 0);
	at[129] = 145;
	points[130] = (-1744.2756, -17360.0391, 1175.4922);
	angles[130] = (0, 13.1431, 0);
	at[130] = 145.5000;
	points[131] = (-1820.5945, -16937.9531, 1175.4922);
	angles[131] = (0, 10.6198, 0);
	at[131] = 146;
	points[132] = (-1875.6653, -16536.0625, 1175.4922);
	angles[132] = (0, 8.0946, 0);
	at[132] = 146.5000;
	points[133] = (-1903.4843, -16156.1416, 1175.4922);
	angles[133] = (0, 4.4566, 0);
	at[133] = 147;
	points[134] = (-1872.3268, -15812.2451, 1175.4922);
	angles[134] = (0, -5.4068, 0);
	at[134] = 147.5000;
	points[135] = (-1732.6929, -15481.5352, 1175.4922);
	angles[135] = (0, -20.2009, 0);
	at[135] = 148;
	points[136] = (-1558.3307, -15169.6074, 1175.4922);
	angles[136] = (0, -27.6541, 0);
	at[136] = 148.5000;
	points[137] = (-1370.6812, -14868.8584, 1175.4922);
	angles[137] = (0, -31.2487, 0);
	at[137] = 149;
	points[138] = (-1174.5355, -14573.6230, 1175.4922);
	angles[138] = (0, -33.2343, 0);
	at[138] = 149.5000;
	points[139] = (-972.2559, -14281.5361, 1175.4922);
	angles[139] = (0, -34.4895, 0);
	at[139] = 150;
	points[140] = (-765.7205, -13991.9287, 1175.4922);
	angles[140] = (0, -35.3526, 0);
	at[140] = 150.5000;
	points[141] = (-345.0413, -13416.6934, 1175.4922);
	angles[141] = (0, -36.2337, 0);
	at[141] = 151.5000;
	points[142] = (-138.1602, -13137.2842, 1175.4922);
	angles[142] = (0, -36.6496, 0);
	at[142] = 152;
	points[143] = (81.8579, -12862.9531, 1175.4922);
	angles[143] = (0, -38.4367, 0);
	at[143] = 152.5000;
	points[144] = (539.5787, -12317.5195, 1175.4922);
	angles[144] = (0, -40.1518, 0);
	at[144] = 153.5000;
	points[145] = (770.0787, -12048.3857, 1175.4922);
	angles[145] = (0, -40.5095, 0);
	at[145] = 154;
	points[146] = (1004.0276, -11776.7725, 1175.4922);
	angles[146] = (0, -40.7028, 0);
	at[146] = 154.5000;
	points[147] = (1233.2166, -11510.4727, 1175.4922);
	angles[147] = (0, -40.6833, 0);
	at[147] = 155;
	points[148] = (1453.7953, -11247.0869, 1175.4922);
	angles[148] = (0, -40.0088, 0);
	at[148] = 155.5000;
	points[149] = (1643.2244, -11018.4258, 1175.4922);
	angles[149] = (0, -39.6949, 0);
	at[149] = 156;
	points[150] = (1802.3308, -10824.5674, 1175.4922);
	angles[150] = (0, -39.4019, 0);
	at[150] = 156.5000;
	points[151] = (1934.9528, -10659.9609, 1175.4922);
	angles[151] = (0, -38.8819, 0);
	at[151] = 157;
	points[152] = (2044.1143, -10517.6768, 1175.4763);
	angles[152] = (0, -37.5521, 0);
	at[152] = 157.5000;
	points[153] = (2143.9841, -10380.7090, 1175.4094);
	angles[153] = (0, -36.3459, 0);
	at[153] = 158;
	points[154] = (2240.9607, -10245.9834, 1175.3386);
	angles[154] = (0, -35.8546, 0);
	at[154] = 158.5000;
	points[155] = (2333.8582, -10116.4170, 1175.2834);
	angles[155] = (0, -35.6852, 0);
	at[155] = 159;
	points[156] = (2423.1851, -9991.9287, 1175.2480);
	angles[156] = (0, -35.6699, 0);
	at[156] = 159.5000;
	points[157] = (2509.6812, -9871.8506, 1175.2441);
	angles[157] = (0, -35.7641, 0);
	at[157] = 160;
	points[158] = (2593.9055, -9755.9443, 1175.2875);
	angles[158] = (0, -35.9917, 0);
	at[158] = 160.5000;
	points[159] = (2676.4214, -9644.5273, 1175.4174);
	angles[159] = (0, -36.5049, 0);
	at[159] = 161;
	points[160] = (2829.9922, -9444.8818, 1176.1654);
	angles[160] = (0, -37.5951, 0);
	at[160] = 162;
	points[161] = (2901.9685, -9351.9688, 1176.6182);
	angles[161] = (0, -37.7393, 0);
	at[161] = 162.5000;
	points[162] = (2971.1890, -9262.9922, 1177.0709);
	angles[162] = (0, -37.8618, 0);
	at[162] = 163;
	points[163] = (3037.1221, -9178.5830, 1177.5157);
	angles[163] = (0, -37.9862, 0);
	at[163] = 163.5000;
	points[164] = (3098.9097, -9099.8818, 1177.9331);
	angles[164] = (0, -38.1195, 0);
	at[164] = 164;
	points[165] = (3158.0750, -9024.9219, 1178.3347);
	angles[165] = (0, -38.2650, 0);
	at[165] = 164.5000;
	points[166] = (3214.2795, -8954.1338, 1178.7166);
	angles[166] = (0, -38.4268, 0);
	at[166] = 165;
	points[167] = (3318.6025, -8824.0947, 1179.4135);
	angles[167] = (0, -38.8160, 0);
	at[167] = 166;
	points[168] = (3365.8975, -8765.8262, 1179.7245);
	angles[168] = (0, -39.0560, 0);
	at[168] = 166.5000;
	points[169] = (3413.1458, -8708.2676, 1180.0237);
	angles[169] = (0, -39.3448, 0);
	at[169] = 167;
	points[170] = (3499.1575, -8605.6299, 1180.5394);
	angles[170] = (0, -40.1460, 0);
	at[170] = 168;
	points[171] = (3578.5945, -8515.1582, 1180.9528);
	angles[171] = (0, -41.6553, 0);
	at[171] = 169;
	points[172] = (3650.1616, -8442.6377, 1181.1851);
	angles[172] = (0, -45.6622, 0);
	at[172] = 170;
	points[173] = (3735.8740, -8368.1104, 1181.2992);
	angles[173] = (0, -49.4521, 0);
	at[173] = 171;
	points[174] = (3829.7561, -8292.4014, 1181.3425);
	angles[174] = (0, -51.3752, 0);
	at[174] = 172;
	points[175] = (3931.2717, -8214.0547, 1181.3505);
	angles[175] = (0, -52.4985, 0);
	at[175] = 173;
	points[176] = (4040.4331, -8132.1655, 1181.3229);
	angles[176] = (0, -53.2229, 0);
	at[176] = 174;
	points[177] = (4097.9922, -8089.6064, 1181.3032);
	angles[177] = (0, -53.4840, 0);
	at[177] = 174.5000;
	points[178] = (4157.2441, -8046.1416, 1181.2756);
	angles[178] = (0, -53.6884, 0);
	at[178] = 175;
	points[179] = (4281.4175, -7955.5908, 1181.2087);
	angles[179] = (0, -53.9184, 0);
	at[179] = 176;
	points[180] = (4415.5117, -7857.5981, 1181.1378);
	angles[180] = (0, -53.7693, 0);
	at[180] = 177;
	points[181] = (4484.7637, -7805.9448, 1181.1063);
	angles[181] = (0, -53.3022, 0);
	at[181] = 177.5000;
	points[182] = (4550.0396, -7755.0791, 1181.1024);
	angles[182] = (0, -52.2314, 0);
	at[182] = 178;
	points[183] = (5107.0078, -7311.4565, 1181.1024);
	angles[183] = (0, -50.9141, 0);
	at[183] = 182;
	points[184] = (5243.2676, -7197.7168, 1181.1024);
	angles[184] = (0, -49.8343, 0);
	at[184] = 183;
	points[185] = (5368.9370, -7081.6929, 1181.1024);
	angles[185] = (0, -46.7553, 0);
	at[185] = 184;
	points[186] = (5484.8818, -6968.1104, 1181.1024);
	angles[186] = (0, -45.4254, 0);
	at[186] = 185;
	points[187] = (5590, -6862.0078, 1181.1024);
	angles[187] = (0, -44.5970, 0);
	at[187] = 186;
	points[188] = (5685.3936, -6762.9531, 1181.1024);
	angles[188] = (0, -43.7331, 0);
	at[188] = 187;
	points[189] = (5772.2046, -6669.2520, 1181.1024);
	angles[189] = (0, -42.5499, 0);
	at[189] = 188;
	points[190] = (5848.6221, -6581.1416, 1181.1024);
	angles[190] = (0, -40.3566, 0);
	at[190] = 189;
	points[191] = (5882.7954, -6537.0474, 1181.1024);
	angles[191] = (0, -37.9017, 0);
	at[191] = 189.5000;
	points[192] = (5909.6064, -6494.9209, 1181.1024);
	angles[192] = (0, -33.0621, 0);
	at[192] = 190;
	points[193] = (5934.6851, -6447.9927, 1181.1024);
	angles[193] = (0, -28.8438, 0);
	at[193] = 190.5000;
	points[194] = (5979.7637, -6350.7485, 1181.1024);
	angles[194] = (0, -24.3468, 0);
	at[194] = 191.5000;
	points[195] = (6039.2124, -6202.4805, 1181.1024);
	angles[195] = (0, -21.0610, 0);
	at[195] = 193;
	points[196] = (6092.0078, -6051.6538, 1181.1024);
	angles[196] = (0, -18.5668, 0);
	at[196] = 194.5000;
	points[197] = (6123.1099, -5949.4097, 1181.1024);
	angles[197] = (0, -16.4778, 0);
	at[197] = 195.5000;
	points[198] = (6136.7324, -5897.5981, 1181.1024);
	angles[198] = (0, -14.8812, 0);
	at[198] = 196;
	points[199] = (6147.3228, -5849.3306, 1181.1063);
	angles[199] = (0, -12.6700, 0);
	at[199] = 196.5000;
	points[200] = (6157.5200, -5796.4961, 1181.1260);
	angles[200] = (0, -11.1649, 0);
	at[200] = 197;
	points[201] = (6184.0161, -5638.2285, 1181.2166);
	angles[201] = (0, -9.0391, 0);
	at[201] = 198.5000;
	points[202] = (6206.2993, -5480.3149, 1181.2992);
	angles[202] = (0, -7.6333, 0);
	at[202] = 200;
	points[203] = (6234.4487, -5215.3936, 1181.3505);
	angles[203] = (0, -5.0212, 0);
	at[203] = 202.5000;
	points[204] = (6245.6304, -5003.1104, 1181.2401);
	angles[204] = (0, -1.7313, 0);
	at[204] = 204.5000;
	points[205] = (6244.9604, -4898.0317, 1181.0945);
	angles[205] = (0, 0.9867, 0);
	at[205] = 205.5000;
	points[206] = (6243.0317, -4851.5352, 1181);
	angles[206] = (0, 2.1648, 0);
	at[206] = 206;
	points[207] = (6240, -4794.0942, 1180.8701);
	angles[207] = (0, 2.8628, 0);
	at[207] = 206.5000;
	points[208] = (6233.7402, -4690.7480, 1180.6143);
	angles[208] = (0, 3.5445, 0);
	at[208] = 207.5000;
	points[209] = (6226.2603, -4579.6064, 1180.3229);
	angles[209] = (0, 3.8992, 0);
	at[209] = 208.5000;
	points[210] = (6218.8979, -4476.9683, 1180.0472);
	angles[210] = (0, 4.1320, 0);
	at[210] = 209.5000;
	points[211] = (6210.6299, -4366.5356, 1179.7480);
	angles[211] = (0, 4.3229, 0);
	at[211] = 210.5000;
	points[212] = (6202.5986, -4263.3467, 1179.4646);
	angles[212] = (0, 4.4829, 0);
	at[212] = 211.5000;
	points[213] = (6152.1655, -3677.5671, 1177.8425);
	angles[213] = (0, 5.2751, 0);
	at[213] = 217;
	points[214] = (6126.2993, -3411.4724, 1177.1182);
	angles[214] = (0, 5.7263, 0);
	at[214] = 219.5000;
	points[215] = (6115.5903, -3307.8188, 1176.8464);
	angles[215] = (0, 5.9506, 0);
	at[215] = 220.5000;
	points[216] = (6103.7402, -3198.4607, 1176.5630);
	angles[216] = (0, 6.2293, 0);
	at[216] = 221.5000;
	points[217] = (6091.9683, -3094.9136, 1176.2992);
	angles[217] = (0, 6.5715, 0);
	at[217] = 222.5000;
	points[218] = (6078.7012, -2985.9331, 1176.0354);
	angles[218] = (0, 7.0353, 0);
	at[218] = 223.5000;
	points[219] = (6065.1572, -2883.7991, 1175.8032);
	angles[219] = (0, 7.7017, 0);
	at[219] = 224.5000;
	points[220] = (6048.5430, -2773.6340, 1175.5828);
	angles[220] = (0, 8.8784, 0);
	at[220] = 225.5000;
	points[221] = (6031.1025, -2679.3899, 1175.4449);
	angles[221] = (0, 10.8495, 0);
	at[221] = 226.5000;
	points[222] = (5996.5752, -2516.4646, 1175.3188);
	angles[222] = (0, 12.2733, 0);
	at[222] = 228;
	points[223] = (5943.0317, -2285.7283, 1175.2520);
	angles[223] = (0, 13.4341, 0);
	at[223] = 230;
	points[224] = (5897.2837, -2102.1614, 1175.2441);
	angles[224] = (0, 14.2283, 0);
	at[224] = 231.5000;
	points[225] = (5846.1421, -1908.9922, 1175.2599);
	angles[225] = (0, 15.0779, 0);
	at[225] = 233;
	points[226] = (5808.6611, -1774.7401, 1175.2834);
	angles[226] = (0, 15.7186, 0);
	at[226] = 234;
	points[227] = (5768.1890, -1636.4921, 1175.3110);
	angles[227] = (0, 16.4601, 0);
	at[227] = 235;
	points[228] = (5746.7720, -1566.1104, 1175.3307);
	angles[228] = (0, 16.8815, 0);
	at[228] = 235.5000;
	points[229] = (5675.8267, -1347.4449, 1175.3859);
	angles[229] = (0, 18.4767, 0);
	at[229] = 237;
	points[230] = (5621.4961, -1195.4291, 1175.4292);
	angles[230] = (0, 20.0029, 0);
	at[230] = 238;
	points[231] = (5559.4492, -1039.9724, 1175.4646);
	angles[231] = (0, 22.2522, 0);
	at[231] = 239;
	points[232] = (5525.1182, -963.0236, 1175.4803);
	angles[232] = (0, 23.8481, 0);
	at[232] = 239.5000;
	points[233] = (5485.8267, -883.6732, 1175.4883);
	angles[233] = (0, 26.1362, 0);
	at[233] = 240;
	points[234] = (5447.1260, -815.6811, 1175.4922);
	angles[234] = (0, 29.3706, 0);
	at[234] = 240.5000;
	points[235] = (5399.7642, -743.5079, 1175.4922);
	angles[235] = (0, 32.6958, 0);
	at[235] = 241;
	points[236] = (5345.1577, -666.5630, 1175.4922);
	angles[236] = (0, 34.9854, 0);
	at[236] = 241.5000;
	points[237] = (5295.2759, -599.2598, 1175.4922);
	angles[237] = (0, 36.3093, 0);
	at[237] = 242;
	points[238] = (5183.6221, -454.4370, 1175.4922);
	angles[238] = (0, 37.8231, 0);
	at[238] = 243;
	points[239] = (5074.9214, -317.8543, 1175.4922);
	angles[239] = (0, 38.6271, 0);
	at[239] = 244;
	points[240] = (5016.7324, -245.9004, 1175.4922);
	angles[240] = (0, 38.9163, 0);
	at[240] = 244.5000;
	points[241] = (4906.0630, -110.5980, 1175.4922);
	angles[241] = (0, 39.3358, 0);
	at[241] = 245.5000;
	points[242] = (4791.2993, 28.2440, 1175.4922);
	angles[242] = (0, 39.6227, 0);
	at[242] = 246.5000;
	points[243] = (4335.8267, 572.4567, 1175.4922);
	angles[243] = (0, 40, 0);
	at[243] = 250.5000;
	points[244] = (4220.1577, 710.5433, 1175.4922);
	angles[244] = (0, 39.9346, 0);
	at[244] = 251.5000;
	points[245] = (4108.2285, 844.7874, 1175.4922);
	angles[245] = (0, 39.7886, 0);
	at[245] = 252.5000;
	points[246] = (3992.1655, 985.1456, 1175.4922);
	angles[246] = (0, 39.5196, 0);
	at[246] = 253.5000;
	points[247] = (3882.5278, 1119.7480, 1175.4922);
	angles[247] = (0, 39.0625, 0);
	at[247] = 254.5000;
	points[248] = (3823.5906, 1193.4646, 1175.4922);
	angles[248] = (0, 38.6785, 0);
	at[248] = 255;
	points[249] = (3770.7283, 1260.9094, 1175.4922);
	angles[249] = (0, 38.1381, 0);
	at[249] = 255.5000;
	points[250] = (3664.1455, 1405.4843, 1175.4922);
	angles[250] = (0, 35.6224, 0);
	at[250] = 256.5000;
	points[251] = (3622.2795, 1472.9252, 1175.4922);
	angles[251] = (0, 32.1896, 0);
	at[251] = 257;
	points[252] = (3581.3623, 1552.7126, 1175.4922);
	angles[252] = (0, 27.7673, 0);
	at[252] = 257.5000;
	points[253] = (3546.3623, 1633.3977, 1175.4922);
	angles[253] = (0, 24.0421, 0);
	at[253] = 258;
	points[254] = (3486.7283, 1800.9568, 1175.4922);
	angles[254] = (0, 18.8700, 0);
	at[254] = 259;
	points[255] = (3414.8662, 2057.3191, 1175.4922);
	angles[255] = (0, 14.7467, 0);
	at[255] = 260.5000;
	points[256] = (3308.7402, 2487.0630, 1175.4922);
	angles[256] = (0, 14.7063, 0);
	at[256] = 263;
	points[257] = (3282.7207, 2572.7795, 1175.4922);
	angles[257] = (0, 16.8044, 0);
	at[257] = 263.5000;
	points[258] = (3249.6418, 2654.3740, 1175.4922);
	angles[258] = (0, 21.9788, 0);
	at[258] = 264;
	points[259] = (3205.9805, 2730.4412, 1175.4922);
	angles[259] = (0, 28.5289, 0);
	at[259] = 264.5000;
	points[260] = (3158.5000, 2804.6733, 1175.4922);
	angles[260] = (0, 31.9171, 0);
	at[260] = 265;
	points[261] = (3057.3782, 2950.1614, 1175.4922);
	angles[261] = (0, 35.1992, 0);
	at[261] = 266;
	points[262] = (2950.1890, 3092.2126, 1175.4922);
	angles[262] = (0, 37.4344, 0);
	at[262] = 267;
	points[263] = (2837.1812, 3229.6538, 1175.4922);
	angles[263] = (0, 39.9533, 0);
	at[263] = 268;
	points[264] = (2778.3269, 3295.3347, 1175.4922);
	angles[264] = (0, 41.6885, 0);
	at[264] = 268.5000;
	points[265] = (2715.5278, 3359.4292, 1175.4922);
	angles[265] = (0, 44.2097, 0);
	at[265] = 269;
	points[266] = (2648.3938, 3417.7756, 1175.4922);
	angles[266] = (0, 48.7389, 0);
	at[266] = 269.5000;
	points[267] = (2573.6616, 3457.1221, 1175.4922);
	angles[267] = (0, 62.7523, 0);
	at[267] = 270;
	points[268] = (2485.8662, 3454.7837, 1175.4922);
	angles[268] = (0, 87.1577, 0);
	at[268] = 270.5000;
	points[269] = (2398.7559, 3435.6614, 1175.4922);
	angles[269] = (0, 99.8012, 0);
	at[269] = 271;
	points[270] = (2313.4844, 3409.3938, 1175.4922);
	angles[270] = (0, 105.9546, 0);
	at[270] = 271.5000;
	points[271] = (2229.6025, 3378.5630, 1175.4922);
	angles[271] = (0, 109.5645, 0);
	at[271] = 272;
	points[272] = (2066.8149, 3307.1929, 1175.4922);
	angles[272] = (0, 114.4479, 0);
	at[272] = 273;
	points[273] = (1987.2166, 3266.6104, 1175.4922);
	angles[273] = (0, 116.7274, 0);
	at[273] = 273.5000;
	points[274] = (1909.6536, 3222.3938, 1175.4922);
	angles[274] = (0, 119.3792, 0);
	at[274] = 274;
	points[275] = (1835.2756, 3173.1733, 1175.4922);
	angles[275] = (0, 123.1212, 0);
	at[275] = 274.5000;
	points[276] = (1768.3268, 3114.8152, 1175.4922);
	angles[276] = (0, 130.7001, 0);
	at[276] = 275;
	points[277] = (1728.0276, 3039.9292, 1175.4922);
	angles[277] = (0, 149.0887, 0);
	at[277] = 275.5000;
	points[278] = (1703.6536, 2954.7913, 1175.4922);
	angles[278] = (0, 161.4197, 0);
	at[278] = 276;
	points[279] = (1671.7560, 2780.9250, 1175.4922);
	angles[279] = (0, 170.2466, 0);
	at[279] = 277;
	points[280] = (1650.2875, 2604.0278, 1175.4922);
	angles[280] = (0, 173.4885, 0);
	at[280] = 278;
	points[281] = (1629.9292, 2337.8386, 1175.4922);
	angles[281] = (0, 176.3882, 0);
	at[281] = 279.5000;
	points[282] = (1623.7244, 2161.8977, 1175.4922);
	angles[282] = (0, 178.4315, 0);
	at[282] = 280.5000;
	points[283] = (1624.5906, 1902.6339, 1175.4922);
	angles[283] = (0, 180.0242, 0);
	at[283] = 282;
	points[284] = (1625.5117, 1819.7087, 1175.4922);
	angles[284] = (0, 180.6189, 0);
	at[284] = 282.5000;
	points[285] = (1632.3701, 1663.2283, 1175.4922);
	angles[285] = (0, 183.0622, 0);
	at[285] = 283.5000;
	points[286] = (1638.6890, 1587.1653, 1175.4922);
	angles[286] = (0, 184.5676, 0);
	at[286] = 284;
	points[287] = (1656.5709, 1444.0315, 1175.4922);
	angles[287] = (0, 187.7241, 0);
	at[287] = 285;
	points[288] = (1680.9725, 1309.5789, 1175.4922);
	angles[288] = (0, 190.8760, 0);
	at[288] = 286;
	points[289] = (1695.1300, 1246.2677, 1175.4922);
	angles[289] = (0, 192.3971, 0);
	at[289] = 286.5000;
	points[290] = (1710.8859, 1183.5276, 1175.4922);
	angles[290] = (0, 193.8999, 0);
	at[290] = 287;
	points[291] = (1744.6851, 1067.4094, 1175.4922);
	angles[291] = (0, 196.7337, 0);
	at[291] = 288;
	points[292] = (1781.7520, 959.1417, 1175.4922);
	angles[292] = (0, 199.3794, 0);
	at[292] = 289;
	points[293] = (1816.5079, 869.6890, 1175.4922);
	angles[293] = (0, 201.5316, 0);
	at[293] = 289.8830;
	mover = getEnt("iz_obj_0", "targetname");
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
