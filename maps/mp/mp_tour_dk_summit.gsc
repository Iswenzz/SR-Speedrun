main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_dk_summit", 0);

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
	ambientPlay("iz_0_tdks", 2);
	iz_emitter("iz_1_se_cn_bdx_lift", (-6980.0996, -956.9680, 1315.5903), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7125.1309, 40.9138, 1392.1619), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7270.1626, 1038.7955, 1468.7338), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7415.1938, 2036.6772, 1545.3053), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7550.5806, 2968.4080, 1913.4381), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7685.9673, 3900.1387, 2281.5708), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7836.4707, 4972.1211, 2675.7729), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7986.9751, 6044.1025, 3069.9751), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8137.4785, 7116.0850, 3464.1768), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8287.9824, 8188.0669, 3858.3789), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8438.4854, 9260.0488, 4252.5806), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8588.9902, 10332.0312, 4646.7827), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8739.4932, 11404.0117, 5040.9849), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8889.9971, 12475.9941, 5435.1865), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9040.5010, 13547.9766, 5829.3892), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9191.0039, 14619.9590, 6223.5903), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9341.5078, 15691.9404, 6617.7930), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9492.0117, 16763.9238, 7011.9946), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9642.5156, 17835.9043, 7406.1963), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9793.0195, 18907.8867, 7800.3989), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9943.5225, 19979.8691, 8194.6006), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10053.1533, 20971.1074, 8313.5215), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10162.7842, 21962.3496, 8432.4414), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10248.1562, 22833.3008, 8640.0586), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10333.5273, 23704.2520, 8847.6758), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10418.8994, 24575.2051, 9055.2930), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9099.4395, 2487.8628, 1202.4357), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8557.5322, 3266.1660, 1384.7898), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8015.6245, 4044.4697, 1567.1440), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (7473.7178, 4822.7734, 1749.4983), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (6931.8101, 5601.0767, 1931.8524), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (6389.2637, 6339.6895, 2523.1987), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (5846.7168, 7078.3013, 3114.5454), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (5304.1709, 7816.9131, 3705.8918), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4761.6240, 8555.5264, 4297.2383), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4219.0776, 9294.1377, 4888.5850), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (3676.5315, 10032.7500, 5479.9316), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (3133.9846, 10771.3633, 6071.2783), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (2591.4382, 11509.9746, 6662.6250), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (1991.4795, 12418.4375, 7055.9775), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (1391.5211, 13326.9004, 7449.3311), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (791.5624, 14235.3633, 7842.6851), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (231.0659, 14984.8447, 8017.0063), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-329.4306, 15734.3271, 8191.3291), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-889.9270, 16483.8105, 8365.6504), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1540.0480, 17373.2637, 8298.9248), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-2190.1692, 18262.7188, 8232.1992), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-2840.2903, 19152.1719, 8165.4722), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-3490.4114, 20041.6250, 8098.7466), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-4140.5322, 20931.0762, 8032.0210), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-4790.6533, 21820.5332, 7965.2944), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-5440.7744, 22709.9844, 7898.5688), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-1374, -269, 154);
	level.iz_route[level.iz_route.size] = (-3989, -267, 154);
	level.iz_route[level.iz_route.size] = (-4625, 52, 154);
	level.iz_route[level.iz_route.size] = (-4830, 519, 154);
	level.iz_route[level.iz_route.size] = (-5026, 1222, 154);
	level.iz_route[level.iz_route.size] = (-5027, 2457, 259);
	level.iz_route[level.iz_route.size] = (-5046, 3406, 380);
	level.iz_route[level.iz_route.size] = (-5040, 4124, 619);
	level.iz_route[level.iz_route.size] = (-5824, 25879, 11942);
	level.iz_route[level.iz_route.size] = (-5847, 26626, 11947);
	level.iz_route[level.iz_route.size] = (-5911, 27506, 11949);
	level.iz_route[level.iz_route.size] = (-5947, 28349, 11858);
	level.iz_route[level.iz_route.size] = (-6153, 28934, 11679);
	level.iz_route[level.iz_route.size] = (-6568, 29569, 11376);
	level.iz_route[level.iz_route.size] = (-7198, 29837, 11120);
	level.iz_route[level.iz_route.size] = (-7954, 29888, 10804);
	level.iz_route[level.iz_route.size] = (-8792, 29481, 10424);
	level.iz_route[level.iz_route.size] = (-9322, 28595, 9949);
	level.iz_route[level.iz_route.size] = (-9748, 27170, 9578);
	level.iz_route[level.iz_route.size] = (-9829, 26169, 9356);
	level.iz_route[level.iz_route.size] = (-9777, 25473, 9224);
	level.iz_route[level.iz_route.size] = (-9720, 24375, 9334);
	level.iz_route[level.iz_route.size] = (-9703, 23756, 9225);
	level.iz_route[level.iz_route.size] = (-9702, 22957, 8771);
	level.iz_route[level.iz_route.size] = (-9341, 22237, 8616);
	level.iz_route[level.iz_route.size] = (-9578, 20873, 8352);
	level.iz_route[level.iz_route.size] = (-9424, 20052, 8232);
	level.iz_route[level.iz_route.size] = (-8617, 19590, 8040);
	level.iz_route[level.iz_route.size] = (-7606, 18303, 7722);
	level.iz_route[level.iz_route.size] = (-6243, 17323, 7279);
	level.iz_route[level.iz_route.size] = (-4595, 16050, 6800);
	level.iz_route[level.iz_route.size] = (-2761, 14494, 6098);
	level.iz_route[level.iz_route.size] = (-1522, 13455, 5642);
	level.iz_route[level.iz_route.size] = (-666, 13082, 5405);
	level.iz_route[level.iz_route.size] = (348, 12698, 5480);
	level.iz_route[level.iz_route.size] = (697, 12282, 5543);
	level.iz_route[level.iz_route.size] = (893, 11594, 5491);
	level.iz_route[level.iz_route.size] = (802, 11046, 5383);
	level.iz_route[level.iz_route.size] = (497, 10610, 5222);
	level.iz_route[level.iz_route.size] = (99, 10308, 5121);
	level.iz_route[level.iz_route.size] = (-425, 10245, 4909);
	level.iz_route[level.iz_route.size] = (-988, 10422, 4677);
	level.iz_route[level.iz_route.size] = (-2164, 11933, 3945);
	level.iz_route[level.iz_route.size] = (-2562, 12381, 3889);
	level.iz_route[level.iz_route.size] = (-2871, 12608, 3971);
	level.iz_route[level.iz_route.size] = (-3415, 12574, 3905);
	level.iz_route[level.iz_route.size] = (-4087, 12285, 3866);
	level.iz_route[level.iz_route.size] = (-4545, 11682, 3766);
	level.iz_route[level.iz_route.size] = (-4730, 10874, 3622);
	level.iz_route[level.iz_route.size] = (-4552, 10064, 3401);
	level.iz_route[level.iz_route.size] = (-3940, 9230, 2986);
	level.iz_route[level.iz_route.size] = (-2812, 8718, 2452);
	level.iz_route[level.iz_route.size] = (-1961, 8245, 2109);
	level.iz_route[level.iz_route.size] = (-1085, 7719, 1707);
	level.iz_route[level.iz_route.size] = (-168, 6987, 1307);
	level.iz_route[level.iz_route.size] = (455, 6536, 1188);
	level.iz_route[level.iz_route.size] = (1507, 5777, 979);
	level.iz_route[level.iz_route.size] = (2219, 5201, 834);
	level.iz_route[level.iz_route.size] = (2958, 4589, 689);
	level.iz_route[level.iz_route.size] = (3749, 3867, 519);
	level.iz_route[level.iz_route.size] = (4471, 3224, 368);
	level.iz_route[level.iz_route.size] = (5368, 1989, 180);
	level.iz_route[level.iz_route.size] = (5380, 1237, 172);
	level.iz_route[level.iz_route.size] = (5138, 545, 172);
	level.iz_route[level.iz_route.size] = (4701, 254, 172);
	level.iz_route[level.iz_route.size] = (4200, 77, 172);
	level.iz_route[level.iz_route.size] = (3416, -19, 171);
	level.iz_route[level.iz_route.size] = (2335, -147, 164);
	level.iz_route[level.iz_route.size] = (1127, -174, 154);
	level.iz_route[level.iz_route.size] = (-141, -174, 154);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4693.6221, 3094.3977, 329.5468);
	angles[0] = (0, -49.0328, -0.1692);
	at[0] = 0;
	points[1] = (4854.4487, 3235.0354, 324.6898);
	angles[1] = (0, -49.0328, -0.1692);
	at[1] = 0.1500;
	points[2] = (4908.8584, 3281.8345, 327.2232);
	angles[2] = (0, -52.4434, 21.1173);
	at[2] = 0.2000;
	points[3] = (4962.2046, 3324.7009, 341.7976);
	angles[3] = (0, -52.4434, 21.1173);
	at[3] = 0.2500;
	points[4] = (5067.4019, 3405.1929, 387.2520);
	angles[4] = (0, -52.4434, 21.1173);
	at[4] = 0.3500;
	points[5] = (5117.1655, 3442.9646, 415.6654);
	angles[5] = (0, -52.4434, 21.1173);
	at[5] = 0.4000;
	points[6] = (5159.6851, 3475.7678, 454.0551);
	angles[6] = (0, -51.9540, 53.3957);
	at[6] = 0.4500;
	points[7] = (5193.9766, 3503.2600, 502.1654);
	angles[7] = (0, -51.9540, 53.3957);
	at[7] = 0.5000;
	points[8] = (5254.2129, 3551.6614, 599.4764);
	angles[8] = (0, -51.9540, 53.3957);
	at[8] = 0.6000;
	points[9] = (5304.6851, 3591.1143, 693.4528);
	angles[9] = (0, -51.9540, 53.3957);
	at[9] = 0.7000;
	points[10] = (5325.0791, 3605.5867, 740.9645);
	angles[10] = (0, -119.2611, 83.8691);
	at[10] = 0.7500;
	points[11] = (5335.8267, 3609.7205, 787.9173);
	angles[11] = (0, -119.2611, 83.8691);
	at[11] = 0.8000;
	points[12] = (5346.2207, 3606.8542, 879.0315);
	angles[12] = (0, -119.2611, 83.8691);
	at[12] = 0.9000;
	points[13] = (5352.1260, 3601.2205, 957.6181);
	angles[13] = (0, -119.2611, 83.8691);
	at[13] = 1;
	points[14] = (5354.3706, 3598.3740, 992.0827);
	angles[14] = (0, -119.2611, 83.8691);
	at[14] = 1.0500;
	points[15] = (5358.0312, 3593.2676, 1051.6614);
	angles[15] = (0, -119.2611, 83.8691);
	at[15] = 1.1500;
	points[16] = (5361.0234, 3589.3662, 1098.3149);
	angles[16] = (0, -119.2611, 83.8691);
	at[16] = 1.2500;
	points[17] = (5363.4253, 3586.8545, 1131.7323);
	angles[17] = (0, -119.2611, 83.8691);
	at[17] = 1.3500;
	points[18] = (5364.3701, 3586.1062, 1143.2441);
	angles[18] = (0, -119.2611, 83.8691);
	at[18] = 1.4000;
	points[19] = (5365, 3585.6692, 1150.6851);
	angles[19] = (0, -119.2611, 83.8691);
	at[19] = 1.4500;
	points[20] = (5365.2759, 3585.5117, 1154.2441);
	angles[20] = (0, -53.6178, 43.3857);
	at[20] = 1.5000;
	points[21] = (5365.2759, 3585.5117, 1154.3779);
	angles[21] = (0, -53.6178, 43.3857);
	at[21] = 1.5500;
	points[22] = (5365.2759, 3585.5117, 1153.6182);
	angles[22] = (0, 60.7388, -83.8691);
	at[22] = 1.6000;
	points[23] = (5365.1572, 3585.5710, 1152.4685);
	angles[23] = (0, 60.7388, -83.8691);
	at[23] = 1.7000;
	points[24] = (5364.5669, 3585.9565, 1145.6969);
	angles[24] = (0, 60.7388, -83.8691);
	at[24] = 1.8000;
	points[25] = (5363.2285, 3587.0198, 1129.3661);
	angles[25] = (0, 60.7388, -83.8691);
	at[25] = 1.9000;
	points[26] = (5362.2832, 3587.9292, 1116.7677);
	angles[26] = (0, 60.7388, -83.8691);
	at[26] = 1.9500;
	points[27] = (5361.2993, 3589.0432, 1102.3308);
	angles[27] = (0, 60.7388, -83.8691);
	at[27] = 2;
	points[28] = (5358.8188, 3592.2087, 1064.0433);
	angles[28] = (0, 60.7388, -83.8691);
	at[28] = 2.1000;
	points[29] = (5355.7480, 3596.4646, 1014.4882);
	angles[29] = (0, 60.7388, -83.8691);
	at[29] = 2.2000;
	points[30] = (5351.8501, 3601.5552, 953.4174);
	angles[30] = (0, 60.7388, -83.8691);
	at[30] = 2.3000;
	points[31] = (5349.3696, 3604.2246, 918.4606);
	angles[31] = (0, 60.7388, -83.8691);
	at[31] = 2.3500;
	points[32] = (5342.5195, 3608.8386, 840.0748);
	angles[32] = (0, 60.7388, -83.8691);
	at[32] = 2.4500;
	points[33] = (5337.1260, 3609.7913, 796.3347);
	angles[33] = (0, 60.7388, -83.8691);
	at[33] = 2.5000;
	points[34] = (5328.1890, 3607.3506, 750.8071);
	angles[34] = (0, 128.0460, -53.3957);
	at[34] = 2.5500;
	points[35] = (5311.2207, 3595.9724, 707.3071);
	angles[35] = (0, 128.0460, -53.3957);
	at[35] = 2.6000;
	points[36] = (5264.4097, 3559.7754, 617.2953);
	angles[36] = (0, 128.0460, -53.3957);
	at[36] = 2.7000;
	points[37] = (5237.5986, 3538.3743, 571.3347);
	angles[37] = (0, 128.0460, -53.3957);
	at[37] = 2.7500;
	points[38] = (5177.1260, 3489.7046, 477.5709);
	angles[38] = (0, 128.0460, -53.3957);
	at[38] = 2.8500;
	points[39] = (5141.4170, 3461.4805, 433.8740);
	angles[39] = (0, 127.5566, -21.1173);
	at[39] = 2.9000;
	points[40] = (5094.8823, 3426.0396, 402.0472);
	angles[40] = (0, 127.5566, -21.1173);
	at[40] = 2.9500;
	points[41] = (5044.8428, 3388.0630, 376.1984);
	angles[41] = (0, 127.5566, -21.1173);
	at[41] = 3;
	points[42] = (4992.9136, 3348.4172, 353.5079);
	angles[42] = (0, 127.5566, -21.1173);
	at[42] = 3.0500;
	points[43] = (4939.9604, 3307.2561, 334.3401);
	angles[43] = (0, 127.5566, -21.1173);
	at[43] = 3.1000;
	points[44] = (4886.7324, 3262.9487, 325.4654);
	angles[44] = (0, 130.9673, 0.1692);
	at[44] = 3.1500;
	points[45] = (4671.4961, 3075.2441, 330.2244);
	angles[45] = (0, 129.9473, 0.3195);
	at[45] = 3.3500;
	points[46] = (4454.9214, 2893.0671, 328.9350);
	angles[46] = (0, 129.9473, 0.3195);
	at[46] = 3.5500;
	points[47] = (4401.1416, 2848.9448, 333.5866);
	angles[47] = (0, 127.9348, 13.8801);
	at[47] = 3.6000;
	points[48] = (4345.8662, 2805.2678, 345.6154);
	angles[48] = (0, 127.9348, 13.8801);
	at[48] = 3.6500;
	points[49] = (4238.1890, 2721.4883, 376.9055);
	angles[49] = (0, 127.9348, 13.8801);
	at[49] = 3.7500;
	points[50] = (4186.2598, 2681.4607, 398.4291);
	angles[50] = (0, 126.4319, 43.0505);
	at[50] = 3.8000;
	points[51] = (4141.8110, 2647.2007, 434.7402);
	angles[51] = (0, 126.4319, 43.0505);
	at[51] = 3.8500;
	points[52] = (4102.3623, 2616.4922, 478.2520);
	angles[52] = (0, 126.4319, 43.0505);
	at[52] = 3.9000;
	points[53] = (4065.0786, 2587.8503, 522.5079);
	angles[53] = (0, 126.4319, 43.0505);
	at[53] = 3.9500;
	points[54] = (3995.4331, 2537.4331, 609.9488);
	angles[54] = (0, 126.4319, 43.0505);
	at[54] = 4.0500;
	points[55] = (3963.3071, 2523.3306, 653.8307);
	angles[55] = (0, 84.5222, 58.6736);
	at[55] = 4.1000;
	points[56] = (3934.1458, 2524.3267, 700.9370);
	angles[56] = (0, 84.5222, 58.6736);
	at[56] = 4.1500;
	points[57] = (3882.8938, 2535.4919, 789.1929);
	angles[57] = (0, 84.5222, 58.6736);
	at[57] = 4.2500;
	points[58] = (3874.7480, 2536.9409, 833.5787);
	angles[58] = (0, 123.8291, 26.6414);
	at[58] = 4.3000;
	points[59] = (3874.7480, 2536.9409, 877.1811);
	angles[59] = (0, 123.8291, 26.6414);
	at[59] = 4.3500;
	points[60] = (3874.7480, 2536.9409, 918.1299);
	angles[60] = (15.2818, 90.8293, 22.0902);
	at[60] = 4.4000;
	points[61] = (3874.7480, 2536.9409, 992.0551);
	angles[61] = (25.2431, 13.8522, -8.8121);
	at[61] = 4.5000;
	points[62] = (3874.7480, 2536.9409, 1025.0276);
	angles[62] = (15.2818, -23.1710, -22.0901);
	at[62] = 4.5500;
	points[63] = (3874.7480, 2536.9409, 1083.0079);
	angles[63] = (-15.2818, -89.1707, -22.0902);
	at[63] = 4.6500;
	points[64] = (3874.7480, 2536.9409, 1108.0079);
	angles[64] = (-25.2431, -126.1938, -8.8121);
	at[64] = 4.7000;
	points[65] = (3874.7480, 2536.9409, 1150.0433);
	angles[65] = (-15.2818, -203.1710, 22.0901);
	at[65] = 4.8000;
	points[66] = (3874.7480, 2536.9409, 1167.0709);
	angles[66] = (0, -236.1709, 26.6414);
	at[66] = 4.8500;
	points[67] = (3874.7480, 2536.9409, 1193.1614);
	angles[67] = (25.2431, -306.1939, 8.8121);
	at[67] = 4.9500;
	points[68] = (3874.7480, 2536.9409, 1208.6182);
	angles[68] = (15.2818, -383.1710, -22.0901);
	at[68] = 5.0500;
	points[69] = (3874.7480, 2536.9409, 1213.4489);
	angles[69] = (-15.2818, -449.1707, -22.0902);
	at[69] = 5.1500;
	points[70] = (3874.7480, 2536.9409, 1207.6456);
	angles[70] = (-25.2431, -526.1477, 8.8121);
	at[70] = 5.2500;
	points[71] = (3874.7480, 2536.9409, 1191.2166);
	angles[71] = (0, -596.1709, 26.6414);
	at[71] = 5.3500;
	points[72] = (3874.7480, 2536.9409, 1179.0118);
	angles[72] = (0, -596.1709, 26.6414);
	at[72] = 5.4000;
	points[73] = (3874.7480, 2536.9409, 1146.6378);
	angles[73] = (0, -596.1709, 26.6414);
	at[73] = 5.5000;
	points[74] = (3874.7480, 2536.9409, 1103.6299);
	angles[74] = (0, -596.1709, 26.6414);
	at[74] = 5.6000;
	points[75] = (3874.7480, 2536.9409, 1049.9961);
	angles[75] = (0, -596.1709, 26.6414);
	at[75] = 5.7000;
	points[76] = (3874.7480, 2536.9409, 1019.1890);
	angles[76] = (0, -596.1709, 26.6414);
	at[76] = 5.7500;
	points[77] = (3874.7480, 2536.9409, 949.6102);
	angles[77] = (0, -596.1709, 26.6414);
	at[77] = 5.8500;
	points[78] = (3874.7480, 2536.9409, 910.8307);
	angles[78] = (0, -596.1709, 26.6414);
	at[78] = 5.9000;
	points[79] = (3874.7480, 2536.9409, 825.3071);
	angles[79] = (0, -596.1709, 26.6414);
	at[79] = 6;
	points[80] = (3878.7600, 2536.2913, 796.2520);
	angles[80] = (0, -455.4778, -58.6736);
	at[80] = 6.0500;
	points[81] = (3926.6458, 2525.5906, 713.6299);
	angles[81] = (0, -455.4778, -58.6736);
	at[81] = 6.1500;
	points[82] = (3953.4646, 2522.7363, 669.2244);
	angles[82] = (0, -455.4778, -58.6736);
	at[82] = 6.2000;
	points[83] = (3983.0315, 2529.8740, 626.1102);
	angles[83] = (0, -413.5682, -43.0505);
	at[83] = 6.2500;
	points[84] = (4049.3306, 2575.9412, 541.8228);
	angles[84] = (0, -413.5682, -43.0505);
	at[84] = 6.3500;
	points[85] = (4121.4565, 2631.3269, 456.6181);
	angles[85] = (0, -413.5682, -43.0505);
	at[85] = 6.4500;
	points[86] = (4161.7324, 2662.6653, 415.4370);
	angles[86] = (0, -412.0652, -13.8801);
	at[86] = 6.5000;
	points[87] = (4209.3306, 2699.2048, 387.8102);
	angles[87] = (0, -412.0652, -13.8801);
	at[87] = 6.5500;
	points[88] = (4261.3779, 2739.4250, 369.1929);
	angles[88] = (0, -412.0652, -13.8801);
	at[88] = 6.6000;
	points[89] = (4368.6221, 2823.1575, 340.2642);
	angles[89] = (0, -412.0652, -13.8801);
	at[89] = 6.7000;
	points[90] = (4422.4805, 2866.2522, 330.6725);
	angles[90] = (0, -410.0528, -0.3195);
	at[90] = 6.7500;
	points[91] = (4477.4409, 2911.8188, 328.4724);
	angles[91] = (0, -410.0528, -0.3195);
	at[91] = 6.8000;
	points[92] = (4693.6221, 3094.3977, 329.5468);
	angles[92] = (0, -409.0328, -0.1692);
	at[92] = 7;
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
	points[0] = (4251.9688, 3454.1458, 416.1378);
	angles[0] = (0, -44.5059, 0.1084);
	at[0] = 0;
	points[1] = (4401.4175, 3607.2952, 414.5669);
	angles[1] = (0, -44.5059, 0.1084);
	at[1] = 0.1500;
	points[2] = (4451.7324, 3654.5396, 423.6063);
	angles[2] = (0, -49.8180, 16.8018);
	at[2] = 0.2000;
	points[3] = (4555.1973, 3743.7954, 458.8031);
	angles[3] = (0, -49.8180, 16.8018);
	at[3] = 0.3000;
	points[4] = (4605.9053, 3786.2874, 479.3465);
	angles[4] = (0, -49.8180, 16.8018);
	at[4] = 0.3500;
	points[5] = (4655.5117, 3826.6614, 503.1929);
	angles[5] = (0, -49.8180, 16.8018);
	at[5] = 0.4000;
	points[6] = (4702.0864, 3859.0906, 537.3228);
	angles[6] = (0, -59.0602, 45.2407);
	at[6] = 0.4500;
	points[7] = (4747.2051, 3885.0549, 577.8465);
	angles[7] = (0, -59.0602, 45.2407);
	at[7] = 0.5000;
	points[8] = (4789.0156, 3908.2834, 620.5157);
	angles[8] = (0, -59.0602, 45.2407);
	at[8] = 0.5500;
	points[9] = (4826.1416, 3929.2798, 665.4291);
	angles[9] = (0, -59.0602, 45.2407);
	at[9] = 0.6000;
	points[10] = (4855.1577, 3947.4802, 714.0157);
	angles[10] = (0, -59.0602, 45.2407);
	at[10] = 0.6500;
	points[11] = (4865.3940, 3959.6062, 768.2520);
	angles[11] = (0, 33.6054, 82.1669);
	at[11] = 0.7000;
	points[12] = (4864.5273, 3967.0867, 821.5079);
	angles[12] = (0, 33.6054, 82.1669);
	at[12] = 0.7500;
	points[13] = (4857.4409, 3978.7007, 921.0630);
	angles[13] = (0, 33.6054, 82.1669);
	at[13] = 0.8500;
	points[14] = (4849.0156, 3987.8347, 1007.7953);
	angles[14] = (0, 33.6054, 82.1669);
	at[14] = 0.9500;
	points[15] = (4841.0234, 3995.4724, 1082.8032);
	angles[15] = (0, 33.6054, 82.1669);
	at[15] = 1.0500;
	points[16] = (4834.1733, 4001.8113, 1145.6929);
	angles[16] = (0, 33.6054, 82.1669);
	at[16] = 1.1500;
	points[17] = (4828.8188, 4006.9685, 1196.4094);
	angles[17] = (0, 33.6054, 82.1669);
	at[17] = 1.2500;
	points[18] = (4825.0786, 4010.9448, 1234.2678);
	angles[18] = (0, 33.6054, 82.1669);
	at[18] = 1.3500;
	points[19] = (4823.7402, 4012.5198, 1248.9489);
	angles[19] = (0, 33.6054, 82.1669);
	at[19] = 1.4000;
	points[20] = (4822.2441, 4014.4490, 1266.3938);
	angles[20] = (0, 33.6054, 82.1669);
	at[20] = 1.5000;
	points[21] = (4822.0474, 4014.7637, 1269.7992);
	angles[21] = (0, -45.3959, 44.6902);
	at[21] = 1.5500;
	points[22] = (4822.0474, 4014.7637, 1269.9055);
	angles[22] = (0, -45.3959, 44.6902);
	at[22] = 1.6000;
	points[23] = (4822.0474, 4014.8032, 1269.2560);
	angles[23] = (0, -146.3946, -82.1669);
	at[23] = 1.6500;
	points[24] = (4822.2837, 4014.4097, 1265.8938);
	angles[24] = (0, -146.3946, -82.1669);
	at[24] = 1.8000;
	points[25] = (4823.1499, 4013.2676, 1255.6495);
	angles[25] = (0, -146.3946, -82.1669);
	at[25] = 1.9000;
	points[26] = (4825, 4011.0237, 1235.1299);
	angles[26] = (0, -146.3946, -82.1669);
	at[26] = 2;
	points[27] = (4827.9922, 4007.7952, 1204.3346);
	angles[27] = (0, -146.3946, -82.1669);
	at[27] = 2.1000;
	points[28] = (4830.0396, 4005.7876, 1184.7717);
	angles[28] = (0, -146.3946, -82.1669);
	at[28] = 2.1500;
	points[29] = (4835.0396, 4000.9844, 1137.7362);
	angles[29] = (0, -146.3946, -82.1669);
	at[29] = 2.2500;
	points[30] = (4841.3779, 3995.1182, 1079.5393);
	angles[30] = (0, -146.3946, -82.1669);
	at[30] = 2.3500;
	points[31] = (4844.9604, 3991.7717, 1046.1772);
	angles[31] = (0, -146.3946, -82.1669);
	at[31] = 2.4000;
	points[32] = (4848.7402, 3988.1101, 1010.2402);
	angles[32] = (0, -146.3946, -82.1669);
	at[32] = 2.4500;
	points[33] = (4856.6538, 3979.6458, 929.9016);
	angles[33] = (0, -146.3946, -82.1669);
	at[33] = 2.5500;
	points[34] = (4863.7007, 3969.0947, 837.7166);
	angles[34] = (0, -146.3946, -82.1669);
	at[34] = 2.6500;
	points[35] = (4865.5117, 3962.4805, 787.4134);
	angles[35] = (0, -146.3946, -82.1669);
	at[35] = 2.7000;
	points[36] = (4862.4805, 3953.7009, 736.4488);
	angles[36] = (0, -239.0602, -45.2407);
	at[36] = 2.7500;
	points[37] = (4840.9844, 3938.1497, 687.2874);
	angles[37] = (0, -239.0602, -45.2407);
	at[37] = 2.8000;
	points[38] = (4808.3862, 3919.1182, 642.7480);
	angles[38] = (0, -239.0602, -45.2407);
	at[38] = 2.8500;
	points[39] = (4770, 3897.7441, 600.3858);
	angles[39] = (0, -239.0602, -45.2407);
	at[39] = 2.9000;
	points[40] = (4727.9922, 3874.2244, 559.9921);
	angles[40] = (0, -239.0602, -45.2407);
	at[40] = 2.9500;
	points[41] = (4682.8740, 3846.9961, 521.6339);
	angles[41] = (0, -229.8180, -16.8018);
	at[41] = 3;
	points[42] = (4636.1421, 3811.1260, 493.1653);
	angles[42] = (0, -229.8180, -16.8018);
	at[42] = 3.0500;
	points[43] = (4586.8901, 3770.4607, 471.3425);
	angles[43] = (0, -229.8180, -16.8018);
	at[43] = 3.1000;
	points[44] = (4485.2759, 3683.9292, 433.9606);
	angles[44] = (0, -229.8180, -16.8018);
	at[44] = 3.2000;
	points[45] = (4433.6616, 3638.3188, 418.8464);
	angles[45] = (0, -224.5058, -0.1084);
	at[45] = 3.2500;
	points[46] = (4384.0947, 3589.9607, 413.7795);
	angles[46] = (0, -224.5058, -0.1084);
	at[46] = 3.3000;
	points[47] = (4234.8428, 3436.5000, 416.7362);
	angles[47] = (0, -224.5058, -0.1084);
	at[47] = 3.4500;
	points[48] = (4034.5276, 3236.5903, 414.9961);
	angles[48] = (0, -225.4078, 0.0314);
	at[48] = 3.6500;
	points[49] = (3982.5591, 3189.0984, 420.2323);
	angles[49] = (0, -230.8186, 12.2149);
	at[49] = 3.7000;
	points[50] = (3874.1931, 3100.9766, 442.2205);
	angles[50] = (0, -230.8186, 12.2149);
	at[50] = 3.8000;
	points[51] = (3820.8582, 3058.2246, 457.9803);
	angles[51] = (0, -230.8186, 12.2149);
	at[51] = 3.8500;
	points[52] = (3771.8306, 3018.1770, 482.4055);
	angles[52] = (0, -228.8558, 44.4018);
	at[52] = 3.9000;
	points[53] = (3731.8977, 2982.1340, 524.1063);
	angles[53] = (0, -228.8558, 44.4018);
	at[53] = 3.9500;
	points[54] = (3695.5000, 2948.3896, 568.6339);
	angles[54] = (0, -228.8558, 44.4018);
	at[54] = 4;
	points[55] = (3628.5591, 2887.3347, 657.7835);
	angles[55] = (0, -228.8558, 44.4018);
	at[55] = 4.1000;
	points[56] = (3597.7795, 2860.9724, 701.7441);
	angles[56] = (0, -228.8558, 44.4018);
	at[56] = 4.1500;
	points[57] = (3568.5671, 2840.1260, 747.3543);
	angles[57] = (0, -298.7870, 68.2386);
	at[57] = 4.2000;
	points[58] = (3546.2834, 2839.5432, 797.0157);
	angles[58] = (0, -298.7870, 68.2386);
	at[58] = 4.2500;
	points[59] = (3528.7283, 2848.3188, 846.2480);
	angles[59] = (0, -298.7870, 68.2386);
	at[59] = 4.3000;
	points[60] = (3513.5945, 2859.4409, 892.5709);
	angles[60] = (0, -298.7870, 68.2386);
	at[60] = 4.3500;
	points[61] = (3486.8977, 2881.9451, 977.4606);
	angles[61] = (0, -298.7870, 68.2386);
	at[61] = 4.4500;
	points[62] = (3474.2993, 2890.9448, 1015.7362);
	angles[62] = (0, -234.7928, 33.7060);
	at[62] = 4.5000;
	points[63] = (3474.2993, 2890.9448, 1053.5433);
	angles[63] = (0, -234.7928, 33.7060);
	at[63] = 4.5500;
	points[64] = (3474.2993, 2890.9448, 1121.1851);
	angles[64] = (0, -234.7928, 33.7060);
	at[64] = 4.6500;
	points[65] = (3474.2993, 2890.9448, 1178.1969);
	angles[65] = (0, -234.7928, 33.7060);
	at[65] = 4.7500;
	points[66] = (3474.2993, 2890.9448, 1224.5787);
	angles[66] = (0, -234.7928, 33.7060);
	at[66] = 4.8500;
	points[67] = (3474.2993, 2890.9448, 1260.3308);
	angles[67] = (0, -234.7928, 33.7060);
	at[67] = 4.9500;
	points[68] = (3474.2993, 2890.9448, 1285.4529);
	angles[68] = (0, -234.7928, 33.7060);
	at[68] = 5.0500;
	points[69] = (3474.2993, 2890.9448, 1299.9449);
	angles[69] = (0, -234.7928, 33.7060);
	at[69] = 5.1500;
	points[70] = (3474.2993, 2890.9448, 1303.8071);
	angles[70] = (0, -234.7928, 33.7060);
	at[70] = 5.2500;
	points[71] = (3474.2993, 2890.9448, 1297.0433);
	angles[71] = (0, -234.7928, 33.7060);
	at[71] = 5.3500;
	points[72] = (3474.2993, 2890.9448, 1289.6733);
	angles[72] = (0, -234.7928, 33.7060);
	at[72] = 5.4000;
	points[73] = (3474.2993, 2890.9448, 1266.9607);
	angles[73] = (0, -234.7928, 33.7060);
	at[73] = 5.5000;
	points[74] = (3474.2993, 2890.9448, 1251.6182);
	angles[74] = (0, -234.7928, 33.7060);
	at[74] = 5.5500;
	points[75] = (3474.2993, 2890.9448, 1212.9607);
	angles[75] = (0, -234.7928, 33.7060);
	at[75] = 5.6500;
	points[76] = (3474.2993, 2890.9448, 1163.6732);
	angles[76] = (0, -234.7928, 33.7060);
	at[76] = 5.7500;
	points[77] = (3474.2993, 2890.9448, 1103.7560);
	angles[77] = (0, -234.7928, 33.7060);
	at[77] = 5.8500;
	points[78] = (3474.2993, 2890.9448, 1033.2086);
	angles[78] = (0, -234.7928, 33.7060);
	at[78] = 5.9500;
	points[79] = (3477.5591, 2888.9253, 1006.1693);
	angles[79] = (0, -118.7870, -68.2386);
	at[79] = 6;
	points[80] = (3501.6770, 2869.4214, 930.3937);
	angles[80] = (0, -118.7870, -68.2386);
	at[80] = 6.1000;
	points[81] = (3514.7600, 2858.5081, 888.9213);
	angles[81] = (0, -118.7870, -68.2386);
	at[81] = 6.1500;
	points[82] = (3529.1616, 2848.0396, 844.9645);
	angles[82] = (0, -118.7870, -68.2386);
	at[82] = 6.2000;
	points[83] = (3545.7993, 2839.7009, 798.2795);
	angles[83] = (0, -118.7870, -68.2386);
	at[83] = 6.2500;
	points[84] = (3566.8821, 2839.3936, 750.3622);
	angles[84] = (0, -48.8557, -44.4018);
	at[84] = 6.3000;
	points[85] = (3594.2480, 2858.1104, 706.9606);
	angles[85] = (0, -48.8557, -44.4018);
	at[85] = 6.3500;
	points[86] = (3655.0474, 2911.1458, 621.5472);
	angles[86] = (0, -48.8557, -44.4018);
	at[86] = 6.4500;
	points[87] = (3722.6655, 2973.5906, 535.0433);
	angles[87] = (0, -48.8557, -44.4018);
	at[87] = 6.5500;
	points[88] = (3759.9883, 3007.7756, 493.3071);
	angles[88] = (0, -48.8557, -44.4018);
	at[88] = 6.6000;
	points[89] = (3805.6733, 3045.9883, 463.7520);
	angles[89] = (0, -50.8186, -12.2149);
	at[89] = 6.6500;
	points[90] = (3857.8977, 3087.9250, 446.5079);
	angles[90] = (0, -50.8186, -12.2149);
	at[90] = 6.7000;
	points[91] = (3965.1970, 3174.6221, 423.1496);
	angles[91] = (0, -50.8186, -12.2149);
	at[91] = 6.8000;
	points[92] = (4017.7954, 3220.6221, 415.7638);
	angles[92] = (0, -45.4078, -0.0314);
	at[92] = 6.8500;
	points[93] = (4251.9688, 3454.1458, 416.1378);
	angles[93] = (0, -44.5059, 0.1084);
	at[93] = 7.0833;
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
	points[0] = (1987.1182, 5450.9844, 885.5000);
	angles[0] = (0, -45.6481, -1.0268);
	at[0] = 0;
	points[1] = (2088.7441, 5551.6143, 880.2756);
	angles[1] = (0, -45.6481, -1.0268);
	at[1] = 0.1000;
	points[2] = (2140.2952, 5601.4175, 880.6339);
	angles[2] = (0, -45.6481, -1.0268);
	at[2] = 0.1500;
	points[3] = (2193.0396, 5646.4565, 893.9724);
	angles[3] = (0, -52.9722, 21.5249);
	at[3] = 0.2000;
	points[4] = (2245.7559, 5686.7319, 917.6063);
	angles[4] = (0, -52.9722, 21.5249);
	at[4] = 0.2500;
	points[5] = (2296.7441, 5724.3701, 944.1182);
	angles[5] = (0, -52.9722, 21.5249);
	at[5] = 0.3000;
	points[6] = (2345.2402, 5759.2910, 973.6299);
	angles[6] = (0, -57.2608, 42.7317);
	at[6] = 0.3500;
	points[7] = (2386.1143, 5787.9531, 1011.1497);
	angles[7] = (0, -57.2608, 42.7317);
	at[7] = 0.4000;
	points[8] = (2423.3701, 5813.4648, 1051.3190);
	angles[8] = (0, -57.2608, 42.7317);
	at[8] = 0.4500;
	points[9] = (2457.5630, 5835.8662, 1090.2362);
	angles[9] = (0, -57.2608, 42.7317);
	at[9] = 0.5000;
	points[10] = (2489.0159, 5854.6851, 1127.5748);
	angles[10] = (0, -57.2608, 42.7317);
	at[10] = 0.5500;
	points[11] = (2516.6301, 5864.3701, 1163.7953);
	angles[11] = (0, -93.5308, 57.4026);
	at[11] = 0.6000;
	points[12] = (2540.3545, 5864.4487, 1199.9409);
	angles[12] = (0, -93.5308, 57.4026);
	at[12] = 0.6500;
	points[13] = (2560.6221, 5862.4414, 1232.2047);
	angles[13] = (0, -93.5308, 57.4026);
	at[13] = 0.7000;
	points[14] = (2577.8467, 5860.0396, 1260.0708);
	angles[14] = (0, -93.5308, 57.4026);
	at[14] = 0.7500;
	points[15] = (2592.2322, 5857.9136, 1283.4448);
	angles[15] = (0, -93.5308, 57.4026);
	at[15] = 0.8000;
	points[16] = (2603.8030, 5856.2993, 1302.1812);
	angles[16] = (0, -93.5308, 57.4026);
	at[16] = 0.8500;
	points[17] = (2612.4961, 5855.2754, 1316.1182);
	angles[17] = (0, -93.5308, 57.4026);
	at[17] = 0.9000;
	points[18] = (2616.4529, 5854.9214, 1324.8071);
	angles[18] = (0, -56.2035, 27.7542);
	at[18] = 0.9500;
	points[19] = (2616.4529, 5854.9214, 1333.2008);
	angles[19] = (0, -56.2035, 27.7542);
	at[19] = 1.0500;
	points[20] = (2616.4529, 5854.9214, 1333.4094);
	angles[20] = (0, -56.2035, 27.7542);
	at[20] = 1.1000;
	points[21] = (2616.4529, 5854.9214, 1325.8583);
	angles[21] = (0, -56.2035, 27.7542);
	at[21] = 1.2000;
	points[22] = (2616.8821, 5854.9214, 1323.0511);
	angles[22] = (0, 86.4692, -57.4026);
	at[22] = 1.2500;
	points[23] = (2614.3191, 5855.1182, 1319.0079);
	angles[23] = (0, 86.4692, -57.4026);
	at[23] = 1.3000;
	points[24] = (2603.0396, 5856.3779, 1300.9528);
	angles[24] = (0, 86.4692, -57.4026);
	at[24] = 1.4000;
	points[25] = (2594.1692, 5857.6377, 1286.5906);
	angles[25] = (0, 86.4692, -57.4026);
	at[25] = 1.4500;
	points[26] = (2583.0669, 5859.2915, 1268.5472);
	angles[26] = (0, 86.4692, -57.4026);
	at[26] = 1.5000;
	points[27] = (2569.6494, 5861.2207, 1246.7795);
	angles[27] = (0, 86.4692, -57.4026);
	at[27] = 1.5500;
	points[28] = (2553.7639, 5863.2280, 1221.2008);
	angles[28] = (0, 86.4692, -57.4026);
	at[28] = 1.6000;
	points[29] = (2535.3069, 5864.7246, 1192.0552);
	angles[29] = (0, 86.4692, -57.4026);
	at[29] = 1.6500;
	points[30] = (2513.5906, 5864.0156, 1159.4016);
	angles[30] = (0, 86.4692, -57.4026);
	at[30] = 1.7000;
	points[31] = (2488.0396, 5854.1343, 1126.3818);
	angles[31] = (0, 122.7390, -42.7317);
	at[31] = 1.7500;
	points[32] = (2459.0828, 5836.8501, 1092);
	angles[32] = (0, 122.7390, -42.7317);
	at[32] = 1.8000;
	points[33] = (2427.5591, 5816.2598, 1055.9961);
	angles[33] = (0, 122.7390, -42.7317);
	at[33] = 1.8500;
	points[34] = (2393.3896, 5793.0317, 1018.7520);
	angles[34] = (0, 122.7390, -42.7317);
	at[34] = 1.9000;
	points[35] = (2354.9763, 5766.1812, 981.1654);
	angles[35] = (0, 127.0277, -21.5249);
	at[35] = 1.9500;
	points[36] = (2310.7520, 5734.5273, 952.0316);
	angles[36] = (0, 127.0277, -21.5249);
	at[36] = 2;
	points[37] = (2211.3503, 5660.6694, 901.6378);
	angles[37] = (0, 127.0277, -21.5249);
	at[37] = 2.1000;
	points[38] = (2159.1377, 5618.7007, 882.8622);
	angles[38] = (0, 134.3518, 1.0268);
	at[38] = 2.1500;
	points[39] = (2107.7007, 5570.1182, 879.9371);
	angles[39] = (0, 134.3518, 1.0268);
	at[39] = 2.2000;
	points[40] = (1954.6260, 5418.7793, 887.5040);
	angles[40] = (0, 134.3518, 1.0268);
	at[40] = 2.3500;
	points[41] = (1750.9370, 5222.4019, 892.4607);
	angles[41] = (0, 133.6181, 1.1383);
	at[41] = 2.5500;
	points[42] = (1699.6693, 5175.7085, 895.2953);
	angles[42] = (0, 127.9520, 6.8033);
	at[42] = 2.6000;
	points[43] = (1589.6143, 5088.1494, 905.1063);
	angles[43] = (0, 127.9520, 6.8033);
	at[43] = 2.7000;
	points[44] = (1534.6378, 5046.0630, 913.8583);
	angles[44] = (0, 127.9520, 6.8033);
	at[44] = 2.7500;
	points[45] = (1482.8425, 5007.5200, 932.0866);
	angles[45] = (0, 124.7706, 33.4415);
	at[45] = 2.8000;
	points[46] = (1434.4135, 4973.5830, 965.1653);
	angles[46] = (0, 124.7706, 33.4415);
	at[46] = 2.8500;
	points[47] = (1347.0708, 4913.4648, 1033.5906);
	angles[47] = (0, 124.7706, 33.4415);
	at[47] = 2.9500;
	points[48] = (1271.5552, 4861.3779, 1099.7205);
	angles[48] = (0, 124.7706, 33.4415);
	at[48] = 3.0500;
	points[49] = (1242.2205, 4840.1182, 1134.1182);
	angles[49] = (0, 129.7213, 59.7806);
	at[49] = 3.1000;
	points[50] = (1221.8386, 4823.8188, 1173.0394);
	angles[50] = (0, 129.7213, 59.7806);
	at[50] = 3.1500;
	points[51] = (1206.1458, 4810.6694, 1209.5157);
	angles[51] = (0, 129.7213, 59.7806);
	at[51] = 3.2000;
	points[52] = (1193.3229, 4799.6460, 1241.9331);
	angles[52] = (0, 129.7213, 59.7806);
	at[52] = 3.2500;
	points[53] = (1182.6851, 4790.4331, 1269.6575);
	angles[53] = (0, 129.7213, 59.7806);
	at[53] = 3.3000;
	points[54] = (1173.9646, 4782.8740, 1292.2836);
	angles[54] = (0, 129.7213, 59.7806);
	at[54] = 3.3500;
	points[55] = (1167.1221, 4777.0078, 1309.4686);
	angles[55] = (0, 129.7213, 59.7806);
	at[55] = 3.4000;
	points[56] = (1162.0787, 4772.7559, 1321.4763);
	angles[56] = (0, 129.7213, 59.7806);
	at[56] = 3.4500;
	points[57] = (1160.9961, 4771.8506, 1327.5591);
	angles[57] = (0, 129.0029, 23.8035);
	at[57] = 3.5000;
	points[58] = (1160.9961, 4771.8506, 1331.3071);
	angles[58] = (0, 129.0029, 23.8035);
	at[58] = 3.6000;
	points[59] = (1160.9961, 4771.8506, 1329.1930);
	angles[59] = (0, 129.0029, 23.8035);
	at[59] = 3.6500;
	points[60] = (1160.9961, 4771.8506, 1324.4252);
	angles[60] = (0, -50.2787, -59.7806);
	at[60] = 3.7000;
	points[61] = (1160.7401, 4771.6143, 1324.5276);
	angles[61] = (0, -50.2787, -59.7806);
	at[61] = 3.7500;
	points[62] = (1164.5039, 4774.7637, 1315.7992);
	angles[62] = (0, -50.2787, -59.7806);
	at[62] = 3.8500;
	points[63] = (1173.6024, 4782.5591, 1293.2164);
	angles[63] = (0, -50.2787, -59.7806);
	at[63] = 3.9500;
	points[64] = (1180.2362, 4788.3071, 1276.0552);
	angles[64] = (0, -50.2787, -59.7806);
	at[64] = 4;
	points[65] = (1188.4094, 4795.3940, 1254.7008);
	angles[65] = (0, -50.2787, -59.7806);
	at[65] = 4.0500;
	points[66] = (1198.2755, 4803.8975, 1229.2126);
	angles[66] = (0, -50.2787, -59.7806);
	at[66] = 4.1000;
	points[67] = (1210.1693, 4814.0552, 1199.7599);
	angles[67] = (0, -50.2787, -59.7806);
	at[67] = 4.1500;
	points[68] = (1224.7953, 4826.2598, 1166.7166);
	angles[68] = (0, -50.2787, -59.7806);
	at[68] = 4.2000;
	points[69] = (1243.8110, 4841.3779, 1131.6141);
	angles[69] = (0, -50.2787, -59.7806);
	at[69] = 4.2500;
	points[70] = (1271.1497, 4861.1025, 1100.1102);
	angles[70] = (0, -55.2294, -33.4415);
	at[70] = 4.3000;
	points[71] = (1304.8427, 4884.4487, 1069.3977);
	angles[71] = (0, -55.2294, -33.4415);
	at[71] = 4.3500;
	points[72] = (1381.1929, 4936.9292, 1005.9803);
	angles[72] = (0, -55.2294, -33.4415);
	at[72] = 4.4500;
	points[73] = (1423.3307, 4965.9058, 973.4016);
	angles[73] = (0, -55.2294, -33.4415);
	at[73] = 4.5000;
	points[74] = (1468.8229, 4997.5591, 940.9370);
	angles[74] = (0, -55.2294, -33.4415);
	at[74] = 4.5500;
	points[75] = (1517.8071, 5033.3857, 917.8583);
	angles[75] = (0, -52.0479, -6.8033);
	at[75] = 4.6000;
	points[76] = (1571.9686, 5074.5669, 907.4252);
	angles[76] = (0, -52.0479, -6.8033);
	at[76] = 4.6500;
	points[77] = (1681.4961, 5160.5903, 896.6890);
	angles[77] = (0, -52.0479, -6.8033);
	at[77] = 4.7500;
	points[78] = (1733.4055, 5206.0239, 893.1418);
	angles[78] = (0, -46.3819, -1.1384);
	at[78] = 4.8000;
	points[79] = (1987.1182, 5450.9844, 885.5000);
	angles[79] = (0, -45.6481, -1.0268);
	at[79] = 5.0500;
	mover = getEnt("iz_obj_2", "targetname");
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
