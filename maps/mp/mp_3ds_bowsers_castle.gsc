main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_bowsers_castle", 0);

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
	ambientPlay("iz_0_118", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
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
	level.iz_route[level.iz_route.size] = (-5672, 3569, 1740);
	level.iz_route[level.iz_route.size] = (-5032, 1070, 1740);
	level.iz_route[level.iz_route.size] = (-4529, -833, 2104);
	level.iz_route[level.iz_route.size] = (-3824, -3263, 1439);
	level.iz_route[level.iz_route.size] = (-3522, -4612, 1439);
	level.iz_route[level.iz_route.size] = (-3238, -5801, 1435);
	level.iz_route[level.iz_route.size] = (-2745, -7461, 1297);
	level.iz_route[level.iz_route.size] = (-2491, -8431, 864);
	level.iz_route[level.iz_route.size] = (-2149, -8996, 868);
	level.iz_route[level.iz_route.size] = (-1140, -10960, 1154);
	level.iz_route[level.iz_route.size] = (-1255, -11904, 1357);
	level.iz_route[level.iz_route.size] = (-1189, -13304, 1427);
	level.iz_route[level.iz_route.size] = (-681, -15157, 1470);
	level.iz_route[level.iz_route.size] = (-197, -15852, 1518);
	level.iz_route[level.iz_route.size] = (600, -16197, 1569);
	level.iz_route[level.iz_route.size] = (1349, -16194, 1612);
	level.iz_route[level.iz_route.size] = (2473, -15962, 1612);
	level.iz_route[level.iz_route.size] = (2803, -15601, 1612);
	level.iz_route[level.iz_route.size] = (3090, -15059, 1612);
	level.iz_route[level.iz_route.size] = (3108, -14451, 1612);
	level.iz_route[level.iz_route.size] = (2668, -13461, 1612);
	level.iz_route[level.iz_route.size] = (2227, -12487, 1612);
	level.iz_route[level.iz_route.size] = (2075, -11585, 1612);
	level.iz_route[level.iz_route.size] = (2414, -11017, 1612);
	level.iz_route[level.iz_route.size] = (3059, -10692, 1612);
	level.iz_route[level.iz_route.size] = (4090, -10411, 1612);
	level.iz_route[level.iz_route.size] = (5494, -10037, 1612);
	level.iz_route[level.iz_route.size] = (5952, -9932, 1612);
	level.iz_route[level.iz_route.size] = (7254, -9618, 1612);
	level.iz_route[level.iz_route.size] = (7577, -9371, 1612);
	level.iz_route[level.iz_route.size] = (7641, -9016, 1612);
	level.iz_route[level.iz_route.size] = (7443, -8046, 1612);
	level.iz_route[level.iz_route.size] = (7394, -7575, 1560);
	level.iz_route[level.iz_route.size] = (7412, -6204, 1187);
	level.iz_route[level.iz_route.size] = (7437, -3880, 1290);
	level.iz_route[level.iz_route.size] = (7463, -3314, 1188);
	level.iz_route[level.iz_route.size] = (7472, -2802, 625);
	level.iz_route[level.iz_route.size] = (7508, -1901, 454);
	level.iz_route[level.iz_route.size] = (7752, -636, 339);
	level.iz_route[level.iz_route.size] = (8005, -115, 306);
	level.iz_route[level.iz_route.size] = (8552, 472, 286);
	level.iz_route[level.iz_route.size] = (9574, 768, 290);
	level.iz_route[level.iz_route.size] = (10654, 1210, 340);
	level.iz_route[level.iz_route.size] = (11305, 1737, 391);
	level.iz_route[level.iz_route.size] = (11367, 2450, 431);
	level.iz_route[level.iz_route.size] = (11119, 3195, 339);
	level.iz_route[level.iz_route.size] = (10778, 3846, 319);
	level.iz_route[level.iz_route.size] = (10189, 4218, 300);
	level.iz_route[level.iz_route.size] = (9444, 4218, 271);
	level.iz_route[level.iz_route.size] = (8669, 3815, 276);
	level.iz_route[level.iz_route.size] = (7583, 3319, 341);
	level.iz_route[level.iz_route.size] = (6932, 3381, 398);
	level.iz_route[level.iz_route.size] = (6312, 3784, 549);
	level.iz_route[level.iz_route.size] = (5991, 4134, 673);
	level.iz_route[level.iz_route.size] = (5683, 4442, 718);
	level.iz_route[level.iz_route.size] = (4250, 5364, 706);
	level.iz_route[level.iz_route.size] = (3092, 6074, 605);
	level.iz_route[level.iz_route.size] = (2644, 6577, 543);
	level.iz_route[level.iz_route.size] = (2543, 7391, 490);
	level.iz_route[level.iz_route.size] = (2596, 7792, 472);
	level.iz_route[level.iz_route.size] = (2554, 8339, 450);
	level.iz_route[level.iz_route.size] = (2372, 8841, 419);
	level.iz_route[level.iz_route.size] = (2092, 9469, 414);
	level.iz_route[level.iz_route.size] = (1434, 9650, 384);
	level.iz_route[level.iz_route.size] = (798, 9844, 381);
	level.iz_route[level.iz_route.size] = (69, 9978, 383);
	level.iz_route[level.iz_route.size] = (-621, 9959, 398);
	level.iz_route[level.iz_route.size] = (-1111, 9743, 411);
	level.iz_route[level.iz_route.size] = (-1500, 9349, 432);
	level.iz_route[level.iz_route.size] = (-1915, 9006, 453);
	level.iz_route[level.iz_route.size] = (-2434, 8617, 486);
	level.iz_route[level.iz_route.size] = (-3239, 8261, 528);
	level.iz_route[level.iz_route.size] = (-3980, 8171, 553);
	level.iz_route[level.iz_route.size] = (-4800, 8547, 567);
	level.iz_route[level.iz_route.size] = (-5848, 9023, 655);
	level.iz_route[level.iz_route.size] = (-6866, 8953, 764);
	level.iz_route[level.iz_route.size] = (-7835, 8739, 873);
	level.iz_route[level.iz_route.size] = (-8766, 8895, 1016);
	level.iz_route[level.iz_route.size] = (-9685, 9420, 1238);
	level.iz_route[level.iz_route.size] = (-10107, 9997, 1381);
	level.iz_route[level.iz_route.size] = (-10375, 10981, 1609);
	level.iz_route[level.iz_route.size] = (-10204, 11773, 1759);
	level.iz_route[level.iz_route.size] = (-9493, 12283, 1877);
	level.iz_route[level.iz_route.size] = (-8617, 12163, 1933);
	level.iz_route[level.iz_route.size] = (-7970, 11525, 1941);
	level.iz_route[level.iz_route.size] = (-7638, 10823, 1935);
	level.iz_route[level.iz_route.size] = (-7440, 10019, 1961);
	level.iz_route[level.iz_route.size] = (-7137, 8856, 1940);
	level.iz_route[level.iz_route.size] = (-6763, 7527, 1740);
	level.iz_route[level.iz_route.size] = (-6534, 6686, 1740);
	level.iz_route[level.iz_route.size] = (-6364, 6058, 1740);
	level.iz_route[level.iz_route.size] = (-6273, 5688, 1740);
	level.iz_route[level.iz_route.size] = (-6087, 4997, 1740);
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
	thread iz_obj_4();
	thread iz_obj_5();
	thread iz_obj_6();
	thread iz_obj_7();
	thread iz_obj_8();
	thread iz_obj_9();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6619.3701, -9749.2129, 1796.4568);
	angles[0] = (0, 105, 0);
	at[0] = 0;
	points[1] = (6619.3701, -9749.2129, 1796.4568);
	angles[1] = (0, 105, 0);
	at[1] = 2.4500;
	points[2] = (6619.3701, -9749.2129, 1804.1300);
	angles[2] = (0, 105, 0);
	at[2] = 2.5000;
	points[3] = (6619.3701, -9749.2129, 1800.8859);
	angles[3] = (0, 105, 0);
	at[3] = 2.5500;
	points[4] = (6619.3701, -9749.2129, 1788.7834);
	angles[4] = (0, 105, 0);
	at[4] = 2.6000;
	points[5] = (6619.3701, -9749.2129, 1792.0277);
	angles[5] = (0, 105, 0);
	at[5] = 2.6500;
	points[6] = (6619.3701, -9749.2129, 1804.1300);
	angles[6] = (0, 105, 0);
	at[6] = 2.7000;
	points[7] = (6619.3701, -9749.2129, 1800.8859);
	angles[7] = (0, 105, 0);
	at[7] = 2.7500;
	points[8] = (6619.3701, -9749.2129, 1788.7834);
	angles[8] = (0, 105, 0);
	at[8] = 2.8000;
	points[9] = (6619.3701, -9749.2129, 1792.0277);
	angles[9] = (0, 105, 0);
	at[9] = 2.8500;
	points[10] = (6619.3701, -9749.2129, 1804.1300);
	angles[10] = (0, 105, 0);
	at[10] = 2.9000;
	points[11] = (6619.3701, -9749.2129, 1800.8859);
	angles[11] = (0, 105, 0);
	at[11] = 2.9500;
	points[12] = (6619.3701, -9749.2129, 1806.7914);
	angles[12] = (0, 105, 0);
	at[12] = 3;
	points[13] = (6619.3701, -9749.2129, 1939.6654);
	angles[13] = (0, 105, 0);
	at[13] = 3.1500;
	points[14] = (6619.3701, -9749.2129, 1909.5472);
	angles[14] = (0, 105, 0);
	at[14] = 3.2000;
	points[15] = (6619.3701, -9749.2129, 1834.2520);
	angles[15] = (0, 105, 0);
	at[15] = 3.2500;
	points[16] = (6619.3701, -9749.2129, 1713.7795);
	angles[16] = (0, 105, 0);
	at[16] = 3.3000;
	points[17] = (6619.3701, -9749.2129, 1612.1968);
	angles[17] = (0, 105, 0);
	at[17] = 3.3500;
	points[18] = (6619.3701, -9749.2129, 1612.1968);
	angles[18] = (0, 105, 0);
	at[18] = 4.3000;
	points[19] = (6619.3701, -9749.2129, 1615.1497);
	angles[19] = (0, 105, 0);
	at[19] = 4.3500;
	points[20] = (6619.3701, -9749.2129, 1792.3149);
	angles[20] = (0, 105, 0);
	at[20] = 5.3500;
	points[21] = (6619.3701, -9749.2129, 1796.4568);
	angles[21] = (0, 105, 0);
	at[21] = 5.4000;
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
	points[0] = (2561.9766, -12493.7012, 1796.4568);
	angles[0] = (0, -165, 0);
	at[0] = 0;
	points[1] = (2561.9766, -12493.7012, 1796.4568);
	angles[1] = (0, -165, 0);
	at[1] = 2.2500;
	points[2] = (2561.9766, -12493.7012, 1804.1300);
	angles[2] = (0, -165, 0);
	at[2] = 2.3000;
	points[3] = (2561.9766, -12493.7012, 1800.8859);
	angles[3] = (0, -165, 0);
	at[3] = 2.3500;
	points[4] = (2561.9766, -12493.7012, 1788.7834);
	angles[4] = (0, -165, 0);
	at[4] = 2.4000;
	points[5] = (2561.9766, -12493.7012, 1792.0277);
	angles[5] = (0, -165, 0);
	at[5] = 2.4500;
	points[6] = (2561.9766, -12493.7012, 1804.1300);
	angles[6] = (0, -165, 0);
	at[6] = 2.5000;
	points[7] = (2561.9766, -12493.7012, 1800.8859);
	angles[7] = (0, -165, 0);
	at[7] = 2.5500;
	points[8] = (2561.9766, -12493.7012, 1788.7834);
	angles[8] = (0, -165, 0);
	at[8] = 2.6000;
	points[9] = (2561.9766, -12493.7012, 1792.0277);
	angles[9] = (0, -165, 0);
	at[9] = 2.6500;
	points[10] = (2561.9766, -12493.7012, 1804.1300);
	angles[10] = (0, -165, 0);
	at[10] = 2.7000;
	points[11] = (2561.9766, -12493.7012, 1800.8859);
	angles[11] = (0, -165, 0);
	at[11] = 2.7500;
	points[12] = (2561.9766, -12493.7012, 1806.7914);
	angles[12] = (0, -165, 0);
	at[12] = 2.8000;
	points[13] = (2561.9766, -12493.7012, 1939.6654);
	angles[13] = (0, -165, 0);
	at[13] = 2.9500;
	points[14] = (2561.9766, -12493.7012, 1909.5472);
	angles[14] = (0, -165, 0);
	at[14] = 3;
	points[15] = (2561.9766, -12493.7012, 1834.2520);
	angles[15] = (0, -165, 0);
	at[15] = 3.0500;
	points[16] = (2561.9766, -12493.7012, 1713.7795);
	angles[16] = (0, -165, 0);
	at[16] = 3.1000;
	points[17] = (2561.9766, -12493.7012, 1612.1968);
	angles[17] = (0, -165, 0);
	at[17] = 3.1500;
	points[18] = (2561.9766, -12493.7012, 1612.1968);
	angles[18] = (0, -165, 0);
	at[18] = 4.1000;
	points[19] = (2561.9766, -12493.7012, 1615.1497);
	angles[19] = (0, -165, 0);
	at[19] = 4.1500;
	points[20] = (2561.9766, -12493.7012, 1792.3149);
	angles[20] = (0, -165, 0);
	at[20] = 5.1500;
	points[21] = (2561.9766, -12493.7012, 1796.4568);
	angles[21] = (0, -165, 0);
	at[21] = 5.2000;
	points[22] = (2561.9766, -12493.7012, 1796.4568);
	angles[22] = (0, -165, 0);
	at[22] = 5.4000;
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
	points[0] = (10088.5830, 755.4449, -480.7638);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (10088.5830, 755.4449, -480.7638);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (10088.5830, 755.4449, -437.4882);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (10088.5830, 755.4449, -333.5516);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (10088.5830, 755.4449, -285.8351);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (10088.5830, 755.4449, -198.9059);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (10088.5830, 755.4449, -123.3154);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (10088.5830, 755.4449, -89.7720);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (10088.5830, 755.4449, -31.1893);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (10088.5830, 755.4449, 16.0547);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (10088.5830, 755.4449, 51.9602);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (10088.5830, 755.4449, 65.6610);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (10088.5830, 755.4449, 84.5587);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (10088.5830, 755.4449, 95.3449);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (10088.5830, 755.4449, 103.2468);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (10088.5830, 755.4449, 106.9583);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (10088.5830, 755.4449, 105.0610);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (10088.5830, 755.4449, 98.7618);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (10088.5830, 755.4449, -477.6142);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (10088.5830, 755.4449, -480.7638);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (10088.5830, 755.4449, -480.7638);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (10642.0078, 2066.8938, -458.8268);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (10642.0078, 2066.8938, -458.8268);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (10642.0078, 2066.8938, -415.5512);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (10642.0078, 2066.8938, -311.6146);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (10642.0078, 2066.8938, -263.8980);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (10642.0078, 2066.8938, -176.9689);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (10642.0078, 2066.8938, -101.3783);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (10642.0078, 2066.8938, -37.1262);
	angles[7] = (0, 0, 0);
	at[7] = 1.3500;
	points[8] = (10642.0078, 2066.8938, -9.2522);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (10642.0078, 2066.8938, 37.9919);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (10642.0078, 2066.8938, 73.8972);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (10642.0078, 2066.8938, 87.5980);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (10642.0078, 2066.8938, 106.4957);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (10642.0078, 2066.8938, 117.2819);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (10642.0078, 2066.8938, 125.1839);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (10642.0078, 2066.8938, 128.8953);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (10642.0078, 2066.8938, 126.9980);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (10642.0078, 2066.8938, 120.6988);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (10642.0078, 2066.8938, -455.6772);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (10642.0078, 2066.8938, -458.8268);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (10642.0078, 2066.8938, -458.8268);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (10096.1025, 3784.3896, -527.7441);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (10096.1025, 3784.3896, -527.7441);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (10096.1025, 3784.3896, -484.4685);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (10096.1025, 3784.3896, -380.5315);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (10096.1025, 3784.3896, -332.8149);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (10096.1025, 3784.3896, -245.8858);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (10096.1025, 3784.3896, -170.2953);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (10096.1025, 3784.3896, -136.7520);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (10096.1025, 3784.3896, -78.1693);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (10096.1025, 3784.3896, -30.9252);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (10096.1025, 3784.3896, 4.9804);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (10096.1025, 3784.3896, 18.6811);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (10096.1025, 3784.3896, 37.5788);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (10096.1025, 3784.3896, 48.3650);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (10096.1025, 3784.3896, 56.2669);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (10096.1025, 3784.3896, 59.9783);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (10096.1025, 3784.3896, 58.0811);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (10096.1025, 3784.3896, 51.7819);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (10096.1025, 3784.3896, -524.5945);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (10096.1025, 3784.3896, -527.7441);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (10096.1025, 3784.3896, -527.7441);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (7387.1655, 3794.2205, -433.2008);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7387.1655, 3794.2205, -433.2008);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (7387.1655, 3794.2205, -389.9221);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (7387.1655, 3794.2205, -285.9850);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (7387.1655, 3794.2205, -238.2685);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (7387.1655, 3794.2205, -151.3394);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (7387.1655, 3794.2205, -75.7488);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (7387.1655, 3794.2205, -42.2055);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (7387.1655, 3794.2205, 16.3774);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (7387.1655, 3794.2205, 63.6213);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (7387.1655, 3794.2205, 99.5268);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (7387.1655, 3794.2205, 113.2276);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (7387.1655, 3794.2205, 132.1252);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (7387.1655, 3794.2205, 142.9114);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (7387.1655, 3794.2205, 150.8134);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (7387.1655, 3794.2205, 154.5248);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (7387.1655, 3794.2205, 152.6276);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (7387.1655, 3794.2205, 146.3283);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (7387.1655, 3794.2205, -430.0512);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (7387.1655, 3794.2205, -433.2008);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (7387.1655, 3794.2205, -433.2008);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2427.6338, -15191.1025, 1027.7323);
	angles[0] = (0, 150, 0);
	at[0] = 0;
	points[1] = (2427.6338, -15191.1025, 1027.7323);
	angles[1] = (0, 150, 0);
	at[1] = 0.8500;
	points[2] = (2427.6338, -15191.1025, 1068.0472);
	angles[2] = (0, 150, 0);
	at[2] = 0.9000;
	points[3] = (2427.6338, -15191.1025, 1121.4331);
	angles[3] = (0, 150, 0);
	at[3] = 0.9500;
	points[4] = (2427.6338, -15191.1025, 1219.7008);
	angles[4] = (0, 150, 0);
	at[4] = 1.0500;
	points[5] = (2427.6338, -15191.1025, 1306.6300);
	angles[5] = (0, 150, 0);
	at[5] = 1.1500;
	points[6] = (2427.6338, -15191.1025, 1382.2205);
	angles[6] = (0, 150, 0);
	at[6] = 1.2500;
	points[7] = (2427.6338, -15191.1025, 1415.7638);
	angles[7] = (0, 150, 0);
	at[7] = 1.3000;
	points[8] = (2427.6338, -15191.1025, 1474.3464);
	angles[8] = (0, 150, 0);
	at[8] = 1.4000;
	points[9] = (2427.6338, -15191.1025, 1521.5906);
	angles[9] = (0, 150, 0);
	at[9] = 1.5000;
	points[10] = (2427.6338, -15191.1025, 1540.9607);
	angles[10] = (0, 150, 0);
	at[10] = 1.5500;
	points[11] = (2427.6338, -15191.1025, 1571.1969);
	angles[11] = (0, 150, 0);
	at[11] = 1.6500;
	points[12] = (2427.6338, -15191.1025, 1590.0946);
	angles[12] = (0, 150, 0);
	at[12] = 1.7500;
	points[13] = (2427.6338, -15191.1025, 1595.2914);
	angles[13] = (0, 150, 0);
	at[13] = 1.8000;
	points[14] = (2427.6338, -15191.1025, 1597.8110);
	angles[14] = (0, 150, 0);
	at[14] = 1.9000;
	points[15] = (2427.6338, -15191.1025, 1030.8820);
	angles[15] = (0, 150, 0);
	at[15] = 4.9000;
	points[16] = (2427.6338, -15191.1025, 1027.7323);
	angles[16] = (0, 150, 0);
	at[16] = 4.9500;
	points[17] = (2427.6338, -15191.1025, 1027.7323);
	angles[17] = (0, 150, 0);
	at[17] = 8.2667;
	mover = getEnt("iz_obj_6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2094.5078, -14997.4805, 1027.7323);
	angles[0] = (0, 150, 0);
	at[0] = 0;
	points[1] = (2094.5078, -14997.4805, 1027.7323);
	angles[1] = (0, 150, 0);
	at[1] = 0.8500;
	points[2] = (2094.5078, -14997.4805, 1068.0472);
	angles[2] = (0, 150, 0);
	at[2] = 0.9000;
	points[3] = (2094.5078, -14997.4805, 1121.4331);
	angles[3] = (0, 150, 0);
	at[3] = 0.9500;
	points[4] = (2094.5078, -14997.4805, 1219.7008);
	angles[4] = (0, 150, 0);
	at[4] = 1.0500;
	points[5] = (2094.5078, -14997.4805, 1306.6300);
	angles[5] = (0, 150, 0);
	at[5] = 1.1500;
	points[6] = (2094.5078, -14997.4805, 1382.2205);
	angles[6] = (0, 150, 0);
	at[6] = 1.2500;
	points[7] = (2094.5078, -14997.4805, 1415.7638);
	angles[7] = (0, 150, 0);
	at[7] = 1.3000;
	points[8] = (2094.5078, -14997.4805, 1474.3464);
	angles[8] = (0, 150, 0);
	at[8] = 1.4000;
	points[9] = (2094.5078, -14997.4805, 1521.5906);
	angles[9] = (0, 150, 0);
	at[9] = 1.5000;
	points[10] = (2094.5078, -14997.4805, 1540.9607);
	angles[10] = (0, 150, 0);
	at[10] = 1.5500;
	points[11] = (2094.5078, -14997.4805, 1571.1969);
	angles[11] = (0, 150, 0);
	at[11] = 1.6500;
	points[12] = (2094.5078, -14997.4805, 1590.0946);
	angles[12] = (0, 150, 0);
	at[12] = 1.7500;
	points[13] = (2094.5078, -14997.4805, 1595.2914);
	angles[13] = (0, 150, 0);
	at[13] = 1.8000;
	points[14] = (2094.5078, -14997.4805, 1597.8110);
	angles[14] = (0, 150, 0);
	at[14] = 1.9000;
	points[15] = (2094.5078, -14997.4805, 1030.8820);
	angles[15] = (0, 150, 0);
	at[15] = 4.9000;
	points[16] = (2094.5078, -14997.4805, 1027.7323);
	angles[16] = (0, 150, 0);
	at[16] = 4.9500;
	points[17] = (2094.5078, -14997.4805, 1027.7323);
	angles[17] = (0, 150, 0);
	at[17] = 8.2667;
	mover = getEnt("iz_obj_7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2282.1536, 8027.4414, -282.1878);
	angles[0] = (0, -165, 0);
	at[0] = 0;
	points[1] = (2282.1536, 8027.4414, -282.1878);
	angles[1] = (0, -165, 0);
	at[1] = 0.8500;
	points[2] = (2282.1536, 8027.4414, -241.8728);
	angles[2] = (0, -165, 0);
	at[2] = 0.9000;
	points[3] = (2282.1536, 8027.4414, -137.9358);
	angles[3] = (0, -165, 0);
	at[3] = 1;
	points[4] = (2282.1536, 8027.4414, -45.3374);
	angles[4] = (0, -165, 0);
	at[4] = 1.1000;
	points[5] = (2282.1536, 8027.4414, -3.2901);
	angles[5] = (0, -165, 0);
	at[5] = 1.1500;
	points[6] = (2282.1536, 8027.4414, 72.3004);
	angles[6] = (0, -165, 0);
	at[6] = 1.2500;
	points[7] = (2282.1536, 8027.4414, 105.8437);
	angles[7] = (0, -165, 0);
	at[7] = 1.3000;
	points[8] = (2282.1536, 8027.4414, 164.4264);
	angles[8] = (0, -165, 0);
	at[8] = 1.4000;
	points[9] = (2282.1536, 8027.4414, 211.6705);
	angles[9] = (0, -165, 0);
	at[9] = 1.5000;
	points[10] = (2282.1536, 8027.4414, 247.5760);
	angles[10] = (0, -165, 0);
	at[10] = 1.6000;
	points[11] = (2282.1536, 8027.4414, 261.2768);
	angles[11] = (0, -165, 0);
	at[11] = 1.6500;
	points[12] = (2282.1536, 8027.4414, 280.1744);
	angles[12] = (0, -165, 0);
	at[12] = 1.7500;
	points[13] = (2282.1536, 8027.4414, 285.3712);
	angles[13] = (0, -165, 0);
	at[13] = 1.8000;
	points[14] = (2282.1536, 8027.4414, 287.8909);
	angles[14] = (0, -165, 0);
	at[14] = 1.9000;
	points[15] = (2282.1536, 8027.4414, -279.0382);
	angles[15] = (0, -165, 0);
	at[15] = 4.9000;
	points[16] = (2282.1536, 8027.4414, -282.1878);
	angles[16] = (0, -165, 0);
	at[16] = 4.9500;
	points[17] = (2282.1536, 8027.4414, -282.1878);
	angles[17] = (0, -165, 0);
	at[17] = 8.2667;
	mover = getEnt("iz_obj_8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2252.0435, 9354.2520, -282.1878);
	angles[0] = (0, -52, 0);
	at[0] = 0;
	points[1] = (-2252.0435, 9354.2520, -282.1878);
	angles[1] = (0, -52, 0);
	at[1] = 0.8500;
	points[2] = (-2252.0435, 9354.2520, -241.8728);
	angles[2] = (0, -52, 0);
	at[2] = 0.9000;
	points[3] = (-2252.0435, 9354.2520, -137.9358);
	angles[3] = (0, -52, 0);
	at[3] = 1;
	points[4] = (-2252.0435, 9354.2520, -45.3374);
	angles[4] = (0, -52, 0);
	at[4] = 1.1000;
	points[5] = (-2252.0435, 9354.2520, -3.2901);
	angles[5] = (0, -52, 0);
	at[5] = 1.1500;
	points[6] = (-2252.0435, 9354.2520, 72.3004);
	angles[6] = (0, -52, 0);
	at[6] = 1.2500;
	points[7] = (-2252.0435, 9354.2520, 105.8437);
	angles[7] = (0, -52, 0);
	at[7] = 1.3000;
	points[8] = (-2252.0435, 9354.2520, 164.4264);
	angles[8] = (0, -52, 0);
	at[8] = 1.4000;
	points[9] = (-2252.0435, 9354.2520, 211.6705);
	angles[9] = (0, -52, 0);
	at[9] = 1.5000;
	points[10] = (-2252.0435, 9354.2520, 247.5760);
	angles[10] = (0, -52, 0);
	at[10] = 1.6000;
	points[11] = (-2252.0435, 9354.2520, 261.2768);
	angles[11] = (0, -52, 0);
	at[11] = 1.6500;
	points[12] = (-2252.0435, 9354.2520, 280.1744);
	angles[12] = (0, -52, 0);
	at[12] = 1.7500;
	points[13] = (-2252.0435, 9354.2520, 285.3712);
	angles[13] = (0, -52, 0);
	at[13] = 1.8000;
	points[14] = (-2252.0435, 9354.2520, 287.8909);
	angles[14] = (0, -52, 0);
	at[14] = 1.9000;
	points[15] = (-2252.0435, 9354.2520, -279.0382);
	angles[15] = (0, -52, 0);
	at[15] = 4.9000;
	points[16] = (-2252.0435, 9354.2520, -282.1878);
	angles[16] = (0, -52, 0);
	at[16] = 4.9500;
	points[17] = (-2252.0435, 9354.2520, -282.1878);
	angles[17] = (0, -52, 0);
	at[17] = 8.2667;
	mover = getEnt("iz_obj_9", "targetname");
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
