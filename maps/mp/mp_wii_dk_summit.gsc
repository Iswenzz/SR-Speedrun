main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_dk_summit", 0);

	setExpFog(0, 5237.6963, 0.9255, 1, 1, 0);

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
	ambientPlay("iz_0_n_snowboard32", 2);
	iz_emitter("iz_1_se_cn_bdx_lift", (-6980.1001, -956.9681, 1315.5903), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7125.1309, 40.9138, 1392.1617), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7270.1621, 1038.7955, 1468.7335), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7415.1929, 2036.6772, 1545.3052), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7550.5801, 2968.4080, 1913.4381), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7685.9673, 3900.1387, 2281.5708), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7836.4712, 4972.1211, 2675.7729), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-7986.9751, 6044.1030, 3069.9751), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8137.4795, 7116.0854, 3464.1770), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8287.9834, 8188.0669, 3858.3792), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8438.4863, 9260.0488, 4252.5815), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8588.9902, 10332.0312, 4646.7832), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8739.4941, 11404.0127, 5040.9849), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-8889.9980, 12475.9961, 5435.1875), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9040.5010, 13547.9775, 5829.3896), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9191.0059, 14619.9600, 6223.5918), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9341.5088, 15691.9414, 6617.7939), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9492.0127, 16763.9238, 7011.9956), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9642.5166, 17835.9062, 7406.1978), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9793.0205, 18907.8887, 7800.3999), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-9943.5244, 19979.8711, 8194.6016), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10053.1533, 20971.1113, 8313.5215), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10162.7842, 21962.3496, 8432.4414), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10248.1562, 22833.3008, 8640.0586), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10333.5283, 23704.2520, 8847.6758), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-10418.9004, 24575.2051, 9055.2930), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (9099.4404, 2487.8628, 1202.4357), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8557.5322, 3266.1663, 1384.7898), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (8015.6250, 4044.4700, 1567.1440), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (7473.7173, 4822.7739, 1749.4983), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (6931.8096, 5601.0776, 1931.8524), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (6389.2632, 6339.6899, 2523.1987), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (5846.7163, 7078.3022, 3114.5457), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (5304.1704, 7816.9146, 3705.8923), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4761.6240, 8555.5264, 4297.2388), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (4219.0776, 9294.1396, 4888.5854), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (3676.5310, 10032.7510, 5479.9321), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (3133.9846, 10771.3643, 6071.2788), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (2591.4382, 11509.9766, 6662.6255), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (1991.4797, 12418.4385, 7055.9785), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (1391.5211, 13326.9014, 7449.3311), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (791.5624, 14235.3643, 7842.6841), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (231.0659, 14984.8457, 8017.0063), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-329.4305, 15734.3271, 8191.3276), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-889.9269, 16483.8105, 8365.6494), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-1540.0480, 17373.2637, 8298.9238), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-2190.1692, 18262.7188, 8232.1982), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-2840.2903, 19152.1719, 8165.4727), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-3490.4114, 20041.6250, 8098.7471), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-4140.5322, 20931.0762, 8032.0210), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-4790.6533, 21820.5332, 7965.2959), 0, 12.0104);
	iz_emitter("iz_1_se_cn_bdx_lift", (-5440.7744, 22709.9844, 7898.5698), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-1099, 28, 153);
	level.iz_route[level.iz_route.size] = (-3757, 60, 153);
	level.iz_route[level.iz_route.size] = (-4285, 233, 153);
	level.iz_route[level.iz_route.size] = (-4611, 563, 153);
	level.iz_route[level.iz_route.size] = (-4824, 1168, 153);
	level.iz_route[level.iz_route.size] = (-5027, 2457, 259);
	level.iz_route[level.iz_route.size] = (-5046, 3406, 380);
	level.iz_route[level.iz_route.size] = (-5040, 4124, 619);
	level.iz_route[level.iz_route.size] = (-5038, 5599, 1232);
	level.iz_route[level.iz_route.size] = (-5035, 7613, 2262);
	level.iz_route[level.iz_route.size] = (-5032, 9626, 3292);
	level.iz_route[level.iz_route.size] = (-5028, 12016, 4515);
	level.iz_route[level.iz_route.size] = (-5026, 13815, 5436);
	level.iz_route[level.iz_route.size] = (-5022, 16204, 6658);
	level.iz_route[level.iz_route.size] = (-5019, 18245, 7702);
	level.iz_route[level.iz_route.size] = (-5017, 19829, 8513);
	level.iz_route[level.iz_route.size] = (-5014, 21735, 9488);
	level.iz_route[level.iz_route.size] = (-5012, 23427, 10354);
	level.iz_route[level.iz_route.size] = (-5003, 25239, 11633);
	level.iz_route[level.iz_route.size] = (-5007, 26627, 12374);
	level.iz_route[level.iz_route.size] = (-5007, 27306, 12374);
	level.iz_route[level.iz_route.size] = (-5028, 28630, 12000);
	level.iz_route[level.iz_route.size] = (-5165, 29264, 11783);
	level.iz_route[level.iz_route.size] = (-5905, 30028, 11359);
	level.iz_route[level.iz_route.size] = (-7009, 30247, 10846);
	level.iz_route[level.iz_route.size] = (-7991, 29761, 10321);
	level.iz_route[level.iz_route.size] = (-8465, 28730, 9807);
	level.iz_route[level.iz_route.size] = (-8564, 28051, 9643);
	level.iz_route[level.iz_route.size] = (-8828, 26824, 9398);
	level.iz_route[level.iz_route.size] = (-8891, 26300, 9281);
	level.iz_route[level.iz_route.size] = (-8880, 25662, 9277);
	level.iz_route[level.iz_route.size] = (-8865, 24837, 9346);
	level.iz_route[level.iz_route.size] = (-8895, 24140, 9080);
	level.iz_route[level.iz_route.size] = (-8834, 23167, 8720);
	level.iz_route[level.iz_route.size] = (-8650, 22587, 8600);
	level.iz_route[level.iz_route.size] = (-8636, 20894, 8257);
	level.iz_route[level.iz_route.size] = (-8590, 20528, 8202);
	level.iz_route[level.iz_route.size] = (-8335, 20099, 8134);
	level.iz_route[level.iz_route.size] = (-6960, 18874, 7756);
	level.iz_route[level.iz_route.size] = (-5777, 17809, 7333);
	level.iz_route[level.iz_route.size] = (-4232, 16423, 6783);
	level.iz_route[level.iz_route.size] = (-2447, 14822, 6180);
	level.iz_route[level.iz_route.size] = (-1246, 13815, 5713);
	level.iz_route[level.iz_route.size] = (-441, 13246, 5450);
	level.iz_route[level.iz_route.size] = (368, 12674, 5311);
	level.iz_route[level.iz_route.size] = (780, 12055, 5299);
	level.iz_route[level.iz_route.size] = (877, 11449, 5229);
	level.iz_route[level.iz_route.size] = (659, 10951, 5101);
	level.iz_route[level.iz_route.size] = (271, 10806, 4933);
	level.iz_route[level.iz_route.size] = (-300, 10745, 4722);
	level.iz_route[level.iz_route.size] = (-749, 10891, 4554);
	level.iz_route[level.iz_route.size] = (-1185, 11218, 4323);
	level.iz_route[level.iz_route.size] = (-1593, 11879, 4046);
	level.iz_route[level.iz_route.size] = (-2127, 12424, 3839);
	level.iz_route[level.iz_route.size] = (-2716, 12628, 3729);
	level.iz_route[level.iz_route.size] = (-3369, 12504, 3633);
	level.iz_route[level.iz_route.size] = (-3915, 12165, 3624);
	level.iz_route[level.iz_route.size] = (-4194, 11643, 3556);
	level.iz_route[level.iz_route.size] = (-4267, 11036, 3402);
	level.iz_route[level.iz_route.size] = (-4097, 10405, 3211);
	level.iz_route[level.iz_route.size] = (-3660, 9641, 2969);
	level.iz_route[level.iz_route.size] = (-2775, 8925, 2532);
	level.iz_route[level.iz_route.size] = (-2031, 8723, 2335);
	level.iz_route[level.iz_route.size] = (-923, 8128, 1805);
	level.iz_route[level.iz_route.size] = (-159, 7431, 1358);
	level.iz_route[level.iz_route.size] = (632, 6710, 1188);
	level.iz_route[level.iz_route.size] = (1575, 5850, 986);
	level.iz_route[level.iz_route.size] = (2249, 5235, 841);
	level.iz_route[level.iz_route.size] = (2958, 4589, 689);
	level.iz_route[level.iz_route.size] = (3749, 3867, 519);
	level.iz_route[level.iz_route.size] = (4463, 3216, 373);
	level.iz_route[level.iz_route.size] = (5368, 1989, 180);
	level.iz_route[level.iz_route.size] = (5380, 1237, 172);
	level.iz_route[level.iz_route.size] = (5138, 545, 172);
	level.iz_route[level.iz_route.size] = (4701, 254, 172);
	level.iz_route[level.iz_route.size] = (4131, 169, 172);
	level.iz_route[level.iz_route.size] = (3413, 117, 171);
	level.iz_route[level.iz_route.size] = (2338, 113, 166);
	level.iz_route[level.iz_route.size] = (1050, 109, 160);
	level.iz_route[level.iz_route.size] = (-239, 105, 153);
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
	points[0] = (4705.7876, 3109.5078, 320.7976);
	angles[0] = (0, -49.1446, 0.0905);
	at[0] = 0;
	points[1] = (4867.2832, 3249.6653, 318.6327);
	angles[1] = (0, -49.1446, 0.0905);
	at[1] = 0.1500;
	points[2] = (4920.1577, 3295.0393, 323.2157);
	angles[2] = (0, -50.4638, 17.0392);
	at[2] = 0.2000;
	points[3] = (4973.9761, 3339.5669, 337.3708);
	angles[3] = (0, -50.4638, 17.0392);
	at[3] = 0.2500;
	points[4] = (5077.6377, 3424.5554, 375.5551);
	angles[4] = (0, -50.4638, 17.0392);
	at[4] = 0.3500;
	points[5] = (5126.2202, 3464.8191, 402.2205);
	angles[5] = (0, -48, 49.6804);
	at[5] = 0.4000;
	points[6] = (5164.5278, 3498.2087, 443.4095);
	angles[6] = (0, -48, 49.6804);
	at[6] = 0.4500;
	points[7] = (5197.8345, 3528.0747, 489.6772);
	angles[7] = (0, -48, 49.6804);
	at[7] = 0.5000;
	points[8] = (5256.5356, 3581.2244, 581.4921);
	angles[8] = (0, -48, 49.6804);
	at[8] = 0.6000;
	points[9] = (5282.0078, 3604.3936, 626.1536);
	angles[9] = (0, -48, 49.6804);
	at[9] = 0.6500;
	points[10] = (5303.9370, 3624.3030, 670.4606);
	angles[10] = (0, -48, 49.6804);
	at[10] = 0.7000;
	points[11] = (5316.3389, 3635.5039, 715.8780);
	angles[11] = (0, -47.9302, 85.4651);
	at[11] = 0.7500;
	points[12] = (5321.2603, 3639.9487, 762.2362);
	angles[12] = (0, -47.9302, 85.4651);
	at[12] = 0.8000;
	points[13] = (5323.7007, 3642.1655, 805.2047);
	angles[13] = (0, -47.9302, 85.4651);
	at[13] = 0.8500;
	points[14] = (5325.0791, 3643.3936, 844.2126);
	angles[14] = (0, -47.9302, 85.4651);
	at[14] = 0.9000;
	points[15] = (5326.4570, 3644.6655, 910.9488);
	angles[15] = (0, -47.9302, 85.4651);
	at[15] = 1;
	points[16] = (5326.9292, 3645.0947, 938.6851);
	angles[16] = (0, -47.9302, 85.4651);
	at[16] = 1.0500;
	points[17] = (5327.4014, 3645.5159, 962.2520);
	angles[17] = (0, -47.9302, 85.4651);
	at[17] = 1.1000;
	points[18] = (5328.4253, 3646.4448, 997.8071);
	angles[18] = (0, -47.9302, 85.4651);
	at[18] = 1.2000;
	points[19] = (5328.9370, 3646.8938, 1009.0945);
	angles[19] = (0, -47.9302, 85.4651);
	at[19] = 1.2500;
	points[20] = (5329.2915, 3647.2009, 1015.4410);
	angles[20] = (0, -49.2305, 38.0126);
	at[20] = 1.3000;
	points[21] = (5329.2915, 3647.2009, 1017.3071);
	angles[21] = (0, -49.2305, 38.0126);
	at[21] = 1.3500;
	points[22] = (5329.2915, 3647.2009, 1016.5157);
	angles[22] = (7.3564, -58.7374, 37.4001);
	at[22] = 1.4000;
	points[23] = (5329.2915, 3647.2126, 1015.6299);
	angles[23] = (180, -47.9303, 94.5349);
	at[23] = 1.4500;
	points[24] = (5329.1729, 3647.1182, 1013.8032);
	angles[24] = (180, -47.9303, 94.5349);
	at[24] = 1.5500;
	points[25] = (5328.7007, 3646.6929, 1004.4410);
	angles[25] = (180, -47.9303, 94.5349);
	at[25] = 1.6500;
	points[26] = (5328.3462, 3646.3545, 995.2480);
	angles[26] = (180, -47.9303, 94.5349);
	at[26] = 1.7000;
	points[27] = (5327.5195, 3645.6260, 967.6693);
	angles[27] = (180, -47.9303, 94.5349);
	at[27] = 1.8000;
	points[28] = (5326.7324, 3644.9097, 926.7638);
	angles[28] = (180, -47.9303, 94.5349);
	at[28] = 1.9000;
	points[29] = (5326.2988, 3644.5159, 901.3740);
	angles[29] = (180, -47.9303, 94.5349);
	at[29] = 1.9500;
	points[30] = (5324.9604, 3643.2913, 840.2284);
	angles[30] = (180, -47.9303, 94.5349);
	at[30] = 2.0500;
	points[31] = (5323.7007, 3642.1458, 804.6653);
	angles[31] = (180, -47.9303, 94.5349);
	at[31] = 2.1000;
	points[32] = (5321.4961, 3640.1653, 765.5433);
	angles[32] = (180, -47.9303, 94.5349);
	at[32] = 2.1500;
	points[33] = (5317.3228, 3636.4016, 722.8740);
	angles[33] = (180, -47.9303, 94.5349);
	at[33] = 2.2000;
	points[34] = (5307.9136, 3627.9175, 680.4095);
	angles[34] = (180, -48, 130.3196);
	at[34] = 2.2500;
	points[35] = (5288.2285, 3610.0432, 637.8386);
	angles[35] = (180, -48, 130.3196);
	at[35] = 2.3000;
	points[36] = (5265.2363, 3589.1140, 596.2480);
	angles[36] = (180, -48, 130.3196);
	at[36] = 2.3500;
	points[37] = (5211.1812, 3540.1260, 509.4843);
	angles[37] = (180, -48, 130.3196);
	at[37] = 2.4500;
	points[38] = (5180.3540, 3512.3582, 464.7559);
	angles[38] = (180, -48, 130.3196);
	at[38] = 2.5000;
	points[39] = (5146.2207, 3482.0198, 420.8858);
	angles[39] = (180, -50.4638, 162.9608);
	at[39] = 2.5500;
	points[40] = (5103.8188, 3446.1260, 388.4335);
	angles[40] = (180, -50.4638, 162.9608);
	at[40] = 2.6000;
	points[41] = (5054.7246, 3405.7402, 365.7386);
	angles[41] = (180, -50.4638, 162.9608);
	at[41] = 2.6500;
	points[42] = (5003.7007, 3363.9487, 346.8886);
	angles[42] = (180, -50.4638, 162.9608);
	at[42] = 2.7000;
	points[43] = (4951.2993, 3320.9016, 330.8217);
	angles[43] = (180, -50.4638, 162.9608);
	at[43] = 2.7500;
	points[44] = (4898.1890, 3276.3228, 320.1685);
	angles[44] = (180, -49.1446, 179.9095);
	at[44] = 2.8000;
	points[45] = (4844.6460, 3230.0510, 318.2858);
	angles[45] = (180, -49.1446, 179.9095);
	at[45] = 2.8500;
	points[46] = (4630.1182, 3044.8899, 321.2890);
	angles[46] = (180, -50.1945, 180.0582);
	at[46] = 3.0500;
	points[47] = (4465.7876, 2908.0474, 317.8283);
	angles[47] = (180, -50.1945, 180.0582);
	at[47] = 3.2000;
	points[48] = (4410.8271, 2862.3779, 321.1587);
	angles[48] = (180, -50.1944, 197.7774);
	at[48] = 3.2500;
	points[49] = (4358.4253, 2818.7480, 334.9957);
	angles[49] = (180, -50.1944, 197.7774);
	at[49] = 3.3000;
	points[50] = (4306.0239, 2775.1614, 353.1728);
	angles[50] = (180, -50.1944, 197.7774);
	at[50] = 3.3500;
	points[51] = (4255.0396, 2732.7007, 373.7417);
	angles[51] = (180, -50.1944, 197.7774);
	at[51] = 3.4000;
	points[52] = (4205.8271, 2691.6772, 397.6339);
	angles[52] = (180, -50.1944, 197.7774);
	at[52] = 3.4500;
	points[53] = (4162.3228, 2655.1731, 430.8937);
	angles[53] = (180, -49.5580, 228.7573);
	at[53] = 3.5000;
	points[54] = (4126.1025, 2624.3621, 475.3701);
	angles[54] = (180, -49.5580, 228.7573);
	at[54] = 3.5500;
	points[55] = (4093.2285, 2596.2954, 520.8110);
	angles[55] = (180, -49.5580, 228.7573);
	at[55] = 3.6000;
	points[56] = (4035.4331, 2546.8977, 610.1339);
	angles[56] = (180, -49.5580, 228.7573);
	at[56] = 3.7000;
	points[57] = (4011.1025, 2526.1418, 654.2559);
	angles[57] = (180, -49.5580, 228.7573);
	at[57] = 3.7500;
	points[58] = (3995, 2512.5393, 699.5867);
	angles[58] = (180, -53.1126, 265.9500);
	at[58] = 3.8000;
	points[59] = (3989.1338, 2507.7717, 746.5591);
	angles[59] = (180, -53.1126, 265.9500);
	at[59] = 3.8500;
	points[60] = (3986.4565, 2505.7402, 790.8701);
	angles[60] = (180, -53.1126, 265.9500);
	at[60] = 3.9000;
	points[61] = (3985.1182, 2504.8269, 831.2953);
	angles[61] = (180, -53.1126, 265.9500);
	at[61] = 3.9500;
	points[62] = (3984.3704, 2504.4175, 867.8465);
	angles[62] = (180, -53.1126, 265.9500);
	at[62] = 4;
	points[63] = (3983.5039, 2504.0710, 929.7126);
	angles[63] = (180, -53.1126, 265.9500);
	at[63] = 4.1000;
	points[64] = (3983.1101, 2503.8701, 954.7913);
	angles[64] = (180, -53.1126, 265.9500);
	at[64] = 4.1500;
	points[65] = (3981.9685, 2503.1340, 992.9370);
	angles[65] = (180, -53.1126, 265.9500);
	at[65] = 4.2500;
	points[66] = (3981.5354, 2502.8230, 1004.8622);
	angles[66] = (180, -50.1034, 217.6683);
	at[66] = 4.3000;
	points[67] = (3981.5354, 2502.8230, 1013.6929);
	angles[67] = (180, -50.1034, 217.6683);
	at[67] = 4.3500;
	points[68] = (3981.5354, 2502.8230, 1019.8661);
	angles[68] = (165.6082, -69.5172, 215.1938);
	at[68] = 4.4000;
	points[69] = (3981.5354, 2502.8230, 1024.2401);
	angles[69] = (142.5736, -147.6669, 175.3864);
	at[69] = 4.5000;
	points[70] = (3981.5354, 2502.8230, 1022.4409);
	angles[70] = (152.9911, -188.7840, 152.6804);
	at[70] = 4.5500;
	points[71] = (3981.5354, 2502.8230, 1010.8701);
	angles[71] = (194.3918, -249.5170, 144.8062);
	at[71] = 4.6500;
	points[72] = (3981.5354, 2502.8230, 1001.0984);
	angles[72] = (180, -233.1125, 94.0500);
	at[72] = 4.7000;
	points[73] = (3981.8503, 2503.0591, 995.1535);
	angles[73] = (180, -233.1125, 94.0500);
	at[73] = 4.7500;
	points[74] = (3982.3623, 2503.4094, 983);
	angles[74] = (180, -233.1125, 94.0500);
	at[74] = 4.8000;
	points[75] = (3982.7954, 2503.7087, 967.4489);
	angles[75] = (180, -233.1125, 94.0500);
	at[75] = 4.8500;
	points[76] = (3983.5432, 2504.0906, 926.7047);
	angles[76] = (180, -233.1125, 94.0500);
	at[76] = 4.9500;
	points[77] = (3984.2913, 2504.3860, 872.2126);
	angles[77] = (180, -233.1125, 94.0500);
	at[77] = 5.0500;
	points[78] = (3984.8821, 2504.7009, 839.9725);
	angles[78] = (180, -233.1125, 94.0500);
	at[78] = 5.1000;
	points[79] = (3987.7954, 2506.7402, 765.1299);
	angles[79] = (180, -233.1125, 94.0500);
	at[79] = 5.2000;
	points[80] = (3991.5356, 2509.6812, 722.5472);
	angles[80] = (180, -233.1125, 94.0500);
	at[80] = 5.2500;
	points[81] = (4000.3545, 2516.9961, 678.8976);
	angles[81] = (180, -229.5580, 131.2427);
	at[81] = 5.3000;
	points[82] = (4020.1968, 2533.8938, 636.8229);
	angles[82] = (180, -229.5580, 131.2427);
	at[82] = 5.3500;
	points[83] = (4044.3306, 2554.5237, 595.3425);
	angles[83] = (180, -229.5580, 131.2427);
	at[83] = 5.4000;
	points[84] = (4071.4175, 2577.6655, 552.9370);
	angles[84] = (180, -229.5580, 131.2427);
	at[84] = 5.4500;
	points[85] = (4133.3071, 2630.4805, 465.9882);
	angles[85] = (180, -229.5580, 131.2427);
	at[85] = 5.5500;
	points[86] = (4169.2915, 2661.0549, 423.5827);
	angles[86] = (180, -230.1944, 162.2226);
	at[86] = 5.6000;
	points[87] = (4212.7163, 2697.4292, 393.9016);
	angles[87] = (180, -230.1944, 162.2226);
	at[87] = 5.6500;
	points[88] = (4261.2993, 2737.9292, 371.0334);
	angles[88] = (180, -230.1944, 162.2226);
	at[88] = 5.7000;
	points[89] = (4363.2681, 2822.8032, 333.4638);
	angles[89] = (180, -230.1944, 162.2226);
	at[89] = 5.8000;
	points[90] = (4415.4727, 2866.2439, 320.5232);
	angles[90] = (180, -230.1945, 179.9418);
	at[90] = 5.8500;
	points[91] = (4470.5513, 2912.0120, 317.7721);
	angles[91] = (180, -230.1945, 179.9418);
	at[91] = 5.9000;
	points[92] = (4634.6460, 3048.6733, 321.4083);
	angles[92] = (180, -230.1945, 179.9418);
	at[92] = 6.0500;
	points[93] = (4705.7876, 3109.5078, 320.7976);
	angles[93] = (180, -229.1446, 180.0905);
	at[93] = 6.1167;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4176.9292, 3384.4724, 407.3858);
	angles[0] = (0, -45.5596, 0.2331);
	at[0] = 0;
	points[1] = (4215.4331, 3422.8425, 408.4409);
	angles[1] = (0, -44.2311, -0.3705);
	at[1] = 0.0500;
	points[2] = (4413.7402, 3627.2876, 404.4370);
	angles[2] = (0, -44.2311, -0.3705);
	at[2] = 0.2500;
	points[3] = (4463.9370, 3675.4370, 412.1929);
	angles[3] = (0, -47.7097, 13.4220);
	at[3] = 0.3000;
	points[4] = (4566.8110, 3769.0081, 437.8819);
	angles[4] = (0, -47.7097, 13.4220);
	at[4] = 0.4000;
	points[5] = (4617.0078, 3814.2046, 454.8661);
	angles[5] = (0, -47.7097, 13.4220);
	at[5] = 0.4500;
	points[6] = (4664.8818, 3857.3110, 478.7323);
	angles[6] = (0, -47.9256, 47.1195);
	at[6] = 0.5000;
	points[7] = (4703.7007, 3892.4058, 518.7166);
	angles[7] = (0, -47.9256, 47.1195);
	at[7] = 0.5500;
	points[8] = (4738.6221, 3923.9331, 563.3307);
	angles[8] = (0, -47.9256, 47.1195);
	at[8] = 0.6000;
	points[9] = (4771.1416, 3953.2678, 608.1890);
	angles[9] = (0, -47.9256, 47.1195);
	at[9] = 0.6500;
	points[10] = (4828.9766, 4005.4331, 695.5197);
	angles[10] = (0, -47.9256, 47.1195);
	at[10] = 0.7500;
	points[11] = (4854.0552, 4028.0315, 738.5511);
	angles[11] = (0, -47.9256, 47.1195);
	at[11] = 0.8000;
	points[12] = (4872.5200, 4044.8425, 781.0670);
	angles[12] = (0, -42.1849, 86.7496);
	at[12] = 0.8500;
	points[13] = (4879.7246, 4051.6143, 828.1299);
	angles[13] = (0, -42.1849, 86.7496);
	at[13] = 0.9000;
	points[14] = (4882.0864, 4054.0945, 872.2283);
	angles[14] = (0, -42.1849, 86.7496);
	at[14] = 0.9500;
	points[15] = (4882.7559, 4055, 912.7520);
	angles[15] = (0, -42.1849, 86.7496);
	at[15] = 1;
	points[16] = (4882.2051, 4055.0789, 982.1693);
	angles[16] = (0, -42.1849, 86.7496);
	at[16] = 1.1000;
	points[17] = (4881.7720, 4054.9607, 1011.0630);
	angles[17] = (0, -42.1849, 86.7496);
	at[17] = 1.1500;
	points[18] = (4881.4961, 4054.8821, 1035.8386);
	angles[18] = (0, -42.1849, 86.7496);
	at[18] = 1.2000;
	points[19] = (4881.5747, 4055.2756, 1073.7441);
	angles[19] = (0, -42.1849, 86.7496);
	at[19] = 1.3000;
	points[20] = (4881.8896, 4055.6299, 1085.6456);
	angles[20] = (0, -46.4778, 36.3172);
	at[20] = 1.3500;
	points[21] = (4881.8896, 4055.6299, 1093.5472);
	angles[21] = (0, -46.4778, 36.3172);
	at[21] = 1.4000;
	points[22] = (4881.8896, 4055.6299, 1101.3779);
	angles[22] = (0, -46.4778, 36.3172);
	at[22] = 1.5000;
	points[23] = (4881.8896, 4055.6299, 1101.3071);
	angles[23] = (0, -46.4778, 36.3172);
	at[23] = 1.5500;
	points[24] = (4881.8896, 4055.6299, 1093.1929);
	angles[24] = (0, -46.4778, 36.3172);
	at[24] = 1.6500;
	points[25] = (4881.9292, 4055.6694, 1086.1693);
	angles[25] = (-180, -42.1850, 93.2504);
	at[25] = 1.7000;
	points[26] = (4881.4961, 4055.1575, 1067.6732);
	angles[26] = (-180, -42.1850, 93.2504);
	at[26] = 1.8000;
	points[27] = (4881.4961, 4054.8821, 1035.8346);
	angles[27] = (-180, -42.1850, 93.2504);
	at[27] = 1.9000;
	points[28] = (4881.7324, 4054.9214, 1015.0355);
	angles[28] = (-180, -42.1850, 93.2504);
	at[28] = 1.9500;
	points[29] = (4882.4805, 4055.1575, 962.9331);
	angles[29] = (-180, -42.1850, 93.2504);
	at[29] = 2.0500;
	points[30] = (4882.7168, 4055.1575, 931.7953);
	angles[30] = (-180, -42.1850, 93.2504);
	at[30] = 2.1000;
	points[31] = (4881.6143, 4053.5828, 859.0197);
	angles[31] = (-180, -42.1850, 93.2504);
	at[31] = 2.2000;
	points[32] = (4878.7007, 4050.6301, 817.6693);
	angles[32] = (-180, -42.1850, 93.2504);
	at[32] = 2.2500;
	points[33] = (4870.5117, 4042.9529, 774.1378);
	angles[33] = (-180, -47.9257, 132.8806);
	at[33] = 2.3000;
	points[34] = (4851.7720, 4025.9844, 734.3229);
	angles[34] = (-180, -47.9257, 132.8806);
	at[34] = 2.3500;
	points[35] = (4827.7168, 4004.2913, 693.4803);
	angles[35] = (-180, -47.9257, 132.8806);
	at[35] = 2.4000;
	points[36] = (4772.6772, 3954.6062, 610.3622);
	angles[36] = (-180, -47.9257, 132.8806);
	at[36] = 2.5000;
	points[37] = (4708.4253, 3896.7007, 524.5040);
	angles[37] = (-180, -47.9257, 132.8806);
	at[37] = 2.6000;
	points[38] = (4671.2598, 3863.1143, 483.7244);
	angles[38] = (-180, -47.7096, 166.5780);
	at[38] = 2.6500;
	points[39] = (4626.0630, 3822.3542, 458.5118);
	angles[39] = (-180, -47.7096, 166.5780);
	at[39] = 2.7000;
	points[40] = (4576.7715, 3778.0120, 440.9331);
	angles[40] = (-180, -47.7096, 166.5780);
	at[40] = 2.7500;
	points[41] = (4475.3940, 3685.9961, 414.6103);
	angles[41] = (-180, -47.7096, 166.5780);
	at[41] = 2.8500;
	points[42] = (4425.3545, 3638.8662, 405.3780);
	angles[42] = (-180, -44.2312, 180.3705);
	at[42] = 2.9000;
	points[43] = (4374.9609, 3587.7991, 403.5512);
	angles[43] = (-180, -44.2312, 180.3705);
	at[43] = 2.9500;
	points[44] = (4226.6143, 3434.2007, 408.2323);
	angles[44] = (-180, -45.5596, 179.7669);
	at[44] = 3.1000;
	points[45] = (4075.4724, 3284.6497, 403.5984);
	angles[45] = (-180, -45.5596, 179.7669);
	at[45] = 3.2500;
	points[46] = (4024.2915, 3234.8701, 404.6024);
	angles[46] = (-180, -45.5596, 179.7669);
	at[46] = 3.3000;
	points[47] = (3973.8582, 3187.4802, 415.3661);
	angles[47] = (-180, -47.4776, 198.0178);
	at[47] = 3.3500;
	points[48] = (3873.5789, 3096.3699, 452.4528);
	angles[48] = (-180, -47.4776, 198.0178);
	at[48] = 3.4500;
	points[49] = (3826.1416, 3053.0237, 476.2953);
	angles[49] = (-180, -47.4776, 198.0178);
	at[49] = 3.5000;
	points[50] = (3785.0315, 3014.0356, 509.5748);
	angles[50] = (-180, -43.9745, 229.2109);
	at[50] = 3.5500;
	points[51] = (3751.6614, 2980.0867, 555.1024);
	angles[51] = (-180, -43.9745, 229.2109);
	at[51] = 3.6000;
	points[52] = (3693.6970, 2919.8821, 646.2875);
	angles[52] = (-180, -43.9745, 229.2109);
	at[52] = 3.7000;
	points[53] = (3644.3188, 2868.1497, 733.0118);
	angles[53] = (-180, -43.9745, 229.2109);
	at[53] = 3.8000;
	points[54] = (3623.3662, 2846.1616, 774.7205);
	angles[54] = (-180, -43.9745, 229.2109);
	at[54] = 3.8500;
	points[55] = (3608.4370, 2830.5864, 816.3347);
	angles[55] = (-180, -44.3373, 268.7906);
	at[55] = 3.9000;
	points[56] = (3603.4136, 2825.3860, 860.9410);
	angles[56] = (-180, -44.3373, 268.7906);
	at[56] = 3.9500;
	points[57] = (3602.3740, 2824.3152, 902.4567);
	angles[57] = (-180, -44.3373, 268.7906);
	at[57] = 4;
	points[58] = (3602.8032, 2824.7678, 940.1221);
	angles[58] = (-180, -44.3373, 268.7906);
	at[58] = 4.0500;
	points[59] = (3603.7954, 2825.8032, 973.8189);
	angles[59] = (-180, -44.3373, 268.7906);
	at[59] = 4.1000;
	points[60] = (3605.9331, 2828.0315, 1029.6456);
	angles[60] = (-180, -44.3373, 268.7906);
	at[60] = 4.2000;
	points[61] = (3606.7046, 2828.8386, 1051.5670);
	angles[61] = (-180, -44.3373, 268.7906);
	at[61] = 4.2500;
	points[62] = (3607.3701, 2829.5354, 1083.3307);
	angles[62] = (-180, -44.3373, 268.7906);
	at[62] = 4.3500;
	points[63] = (3607.3623, 2829.5237, 1092.2755);
	angles[63] = (-180, -44.3373, 268.7906);
	at[63] = 4.4000;
	points[64] = (3607.3428, 2829.5039, 1096.2834);
	angles[64] = (-180, -45.7074, 219.0404);
	at[64] = 4.4500;
	points[65] = (3607.3428, 2829.5039, 1097.2520);
	angles[65] = (-180, -45.7074, 219.0404);
	at[65] = 4.5000;
	points[66] = (3607.3428, 2829.5039, 1095.5591);
	angles[66] = (-180, -45.7074, 219.0404);
	at[66] = 4.5500;
	points[67] = (3607.3389, 2829.5000, 1094.3977);
	angles[67] = (0, -44.3374, 271.2094);
	at[67] = 4.6000;
	points[68] = (3607.3782, 2829.5432, 1089.4252);
	angles[68] = (0, -44.3374, 271.2094);
	at[68] = 4.7000;
	points[69] = (3607.3701, 2829.5315, 1083.1299);
	angles[69] = (0, -44.3374, 271.2094);
	at[69] = 4.7500;
	points[70] = (3606.9805, 2829.1262, 1061.0472);
	angles[70] = (0, -44.3374, 271.2094);
	at[70] = 4.8500;
	points[71] = (3606.4880, 2828.6104, 1045);
	angles[71] = (0, -44.3374, 271.2094);
	at[71] = 4.9000;
	points[72] = (3605.7952, 2827.8899, 1026.0709);
	angles[72] = (0, -44.3374, 271.2094);
	at[72] = 4.9500;
	points[73] = (3603.9253, 2825.9370, 977.4921);
	angles[73] = (0, -44.3374, 271.2094);
	at[73] = 5.0500;
	points[74] = (3602.4133, 2824.3584, 915.3701);
	angles[74] = (0, -44.3374, 271.2094);
	at[74] = 5.1500;
	points[75] = (3602.6929, 2824.6418, 879.1732);
	angles[75] = (0, -44.3374, 271.2094);
	at[75] = 5.2000;
	points[76] = (3605.0945, 2827.1260, 839.1182);
	angles[76] = (0, -44.3374, 271.2094);
	at[76] = 5.2500;
	points[77] = (3613.1418, 2835.4646, 799.1221);
	angles[77] = (0, -43.9746, 310.7891);
	at[77] = 5.3000;
	points[78] = (3630.5825, 2853.7324, 759.6969);
	angles[78] = (0, -43.9746, 310.7891);
	at[78] = 5.3500;
	points[79] = (3674.3269, 2899.6182, 679.1299);
	angles[79] = (0, -43.9746, 310.7891);
	at[79] = 5.4500;
	points[80] = (3699.2048, 2925.6338, 637.1693);
	angles[80] = (0, -43.9746, 310.7891);
	at[80] = 5.5000;
	points[81] = (3755.2717, 2983.7991, 549.8268);
	angles[81] = (0, -43.9746, 310.7891);
	at[81] = 5.6000;
	points[82] = (3787.9370, 3016.9250, 506.1496);
	angles[82] = (0, -47.4775, 341.9822);
	at[82] = 5.6500;
	points[83] = (3828.4688, 3055.1694, 474.9449);
	angles[83] = (0, -47.4775, 341.9822);
	at[83] = 5.7000;
	points[84] = (3875.2246, 3097.8623, 451.7283);
	angles[84] = (0, -47.4775, 341.9822);
	at[84] = 5.7500;
	points[85] = (3974.2126, 3187.7993, 415.2598);
	angles[85] = (0, -47.4775, 341.9822);
	at[85] = 5.8500;
	points[86] = (4024.2124, 3234.8188, 404.6063);
	angles[86] = (0, -45.5596, 360.2331);
	at[86] = 5.9000;
	points[87] = (4176.9292, 3384.4724, 407.3858);
	angles[87] = (0, -45.5596, 360.2331);
	at[87] = 6.0500;
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
	points[0] = (1943.7520, 5421.2207, 881.8307);
	angles[0] = (0, -46.6077, -0.8093);
	at[0] = 0;
	points[1] = (1983.1182, 5458.3076, 881.0079);
	angles[1] = (0, -46.7483, -0.8316);
	at[1] = 0.0500;
	points[2] = (2139.0789, 5604.3311, 874.7323);
	angles[2] = (0, -46.7483, -0.8316);
	at[2] = 0.2000;
	points[3] = (2191.0708, 5653.8188, 876.3268);
	angles[3] = (0, -44.3221, 13.9219);
	at[3] = 0.2500;
	points[4] = (2288.5237, 5752.7954, 899.1024);
	angles[4] = (0, -44.3221, 13.9219);
	at[4] = 0.3500;
	points[5] = (2336.1653, 5802.0078, 914.8740);
	angles[5] = (0, -44.3221, 13.9219);
	at[5] = 0.4000;
	points[6] = (2382.4448, 5849.6851, 935.1733);
	angles[6] = (0, -44.3221, 13.9219);
	at[6] = 0.4500;
	points[7] = (2423.1299, 5890.6694, 968.5394);
	angles[7] = (0, -45.6682, 47.6124);
	at[7] = 0.5000;
	points[8] = (2458.0354, 5924.9609, 1013.3149);
	angles[8] = (0, -45.6682, 47.6124);
	at[8] = 0.5500;
	points[9] = (2490.0906, 5956.2202, 1058.8307);
	angles[9] = (0, -45.6682, 47.6124);
	at[9] = 0.6000;
	points[10] = (2519.8740, 5985.2358, 1103.9448);
	angles[10] = (0, -45.6682, 47.6124);
	at[10] = 0.6500;
	points[11] = (2572.1143, 6036.0239, 1192.1891);
	angles[11] = (0, -45.6682, 47.6124);
	at[11] = 0.7500;
	points[12] = (2591.2756, 6054.6851, 1235.7362);
	angles[12] = (0, -44.1023, 85.9055);
	at[12] = 0.8000;
	points[13] = (2599.2678, 6062.5986, 1283.9292);
	angles[13] = (0, -44.1023, 85.9055);
	at[13] = 0.8500;
	points[14] = (2602.3149, 6065.7090, 1329.3386);
	angles[14] = (0, -44.1023, 85.9055);
	at[14] = 0.9000;
	points[15] = (2603.6140, 6067.0869, 1371.3740);
	angles[15] = (0, -44.1023, 85.9055);
	at[15] = 0.9500;
	points[16] = (2604.3110, 6067.9922, 1443.9331);
	angles[16] = (0, -44.1023, 85.9055);
	at[16] = 1.0500;
	points[17] = (2604.4094, 6068.1890, 1474.4449);
	angles[17] = (0, -44.1023, 85.9055);
	at[17] = 1.1000;
	points[18] = (2604.5828, 6068.4253, 1500.9489);
	angles[18] = (0, -44.1023, 85.9055);
	at[18] = 1.1500;
	points[19] = (2605.4646, 6069.4092, 1541.9528);
	angles[19] = (0, -44.1023, 85.9055);
	at[19] = 1.2500;
	points[20] = (2605.6770, 6069.6064, 1555.4764);
	angles[20] = (0, -45.5614, 36.5342);
	at[20] = 1.3000;
	points[21] = (2605.6770, 6069.6064, 1566.2560);
	angles[21] = (0, -45.5614, 36.5342);
	at[21] = 1.3500;
	points[22] = (2605.6770, 6069.6064, 1579.8386);
	angles[22] = (0, -45.5614, 36.5342);
	at[22] = 1.4500;
	points[23] = (2605.6770, 6069.6064, 1582.7953);
	angles[23] = (0, -45.5614, 36.5342);
	at[23] = 1.5500;
	points[24] = (2605.6770, 6069.6064, 1575.1182);
	angles[24] = (0, -45.5614, 36.5342);
	at[24] = 1.6500;
	points[25] = (2605.6770, 6069.6064, 1556.8149);
	angles[25] = (0, -45.5614, 36.5342);
	at[25] = 1.7500;
	points[26] = (2605.7520, 6069.6851, 1548.3503);
	angles[26] = (180, -44.1023, 94.0945);
	at[26] = 1.8000;
	points[27] = (2605.2559, 6069.1733, 1536.0826);
	angles[27] = (180, -44.1023, 94.0945);
	at[27] = 1.8500;
	points[28] = (2604.8464, 6068.7402, 1519.8149);
	angles[28] = (180, -44.1023, 94.0945);
	at[28] = 1.9000;
	points[29] = (2604.4290, 6068.1890, 1478.4174);
	angles[29] = (180, -44.1023, 94.0945);
	at[29] = 2;
	points[30] = (2604.2205, 6067.8350, 1422.9803);
	angles[30] = (180, -44.1023, 94.0945);
	at[30] = 2.1000;
	points[31] = (2603.9253, 6067.4414, 1390.1772);
	angles[31] = (180, -44.1023, 94.0945);
	at[31] = 2.1500;
	points[32] = (2601.5474, 6064.9214, 1314.2166);
	angles[32] = (180, -44.1023, 94.0945);
	at[32] = 2.2500;
	points[33] = (2597.8425, 6061.1812, 1270.9370);
	angles[33] = (180, -44.1023, 94.0945);
	at[33] = 2.3000;
	points[34] = (2588.5867, 6052.0474, 1227.5826);
	angles[34] = (180, -45.6682, 132.3876);
	at[34] = 2.3500;
	points[35] = (2568.5708, 6032.5591, 1185.5354);
	angles[35] = (180, -45.6682, 132.3876);
	at[35] = 2.4000;
	points[36] = (2544.8740, 6009.5273, 1144.1851);
	angles[36] = (180, -45.6682, 132.3876);
	at[36] = 2.4500;
	points[37] = (2490.0789, 5956.2202, 1058.8188);
	angles[37] = (180, -45.6682, 132.3876);
	at[37] = 2.5500;
	points[38] = (2459.4607, 5926.3389, 1015.2677);
	angles[38] = (180, -45.6682, 132.3876);
	at[38] = 2.6000;
	points[39] = (2425.7756, 5893.3071, 971.6614);
	angles[39] = (180, -45.6682, 132.3876);
	at[39] = 2.6500;
	points[40] = (2387.1418, 5854.4883, 937.7756);
	angles[40] = (180, -44.3221, 166.0781);
	at[40] = 2.7000;
	points[41] = (2341.9016, 5807.9131, 917.0433);
	angles[41] = (180, -44.3221, 166.0781);
	at[41] = 2.7500;
	points[42] = (2246.9175, 5710.0396, 887.7677);
	angles[42] = (180, -44.3221, 166.0781);
	at[42] = 2.8500;
	points[43] = (2197.9055, 5660.4727, 877.2717);
	angles[43] = (180, -46.7482, 180.8315);
	at[43] = 2.9000;
	points[44] = (2147.1968, 5612.0078, 874.6772);
	angles[44] = (180, -46.7482, 180.8315);
	at[44] = 2.9500;
	points[45] = (1990.6180, 5465.3545, 880.6733);
	angles[45] = (180, -46.7482, 180.8315);
	at[45] = 3.1000;
	points[46] = (1784.8070, 5270.6299, 882.3307);
	angles[46] = (180, -46.6077, 180.8093);
	at[46] = 3.3000;
	points[47] = (1733.9646, 5222.9922, 886.6536);
	angles[47] = (180, -47.9820, 195.1835);
	at[47] = 3.3500;
	points[48] = (1631.1024, 5130.4722, 914.0748);
	angles[48] = (180, -47.9820, 195.1835);
	at[48] = 3.4500;
	points[49] = (1581.5276, 5086.0234, 933.6890);
	angles[49] = (180, -47.9820, 195.1835);
	at[49] = 3.5000;
	points[50] = (1537.6339, 5045.9058, 963.0394);
	angles[50] = (180, -46.1909, 225.7614);
	at[50] = 3.5500;
	points[51] = (1500.3818, 5010.4727, 1006.0552);
	angles[51] = (180, -46.1909, 225.7614);
	at[51] = 3.6000;
	points[52] = (1466.1615, 4977.6377, 1050.1693);
	angles[52] = (180, -46.1909, 225.7614);
	at[52] = 3.6500;
	points[53] = (1405.1969, 4918.8979, 1136.5472);
	angles[53] = (180, -46.1909, 225.7614);
	at[53] = 3.7500;
	points[54] = (1378.7363, 4893.3857, 1178.8188);
	angles[54] = (180, -46.1909, 225.7614);
	at[54] = 3.8000;
	points[55] = (1356.3229, 4871.8110, 1222.7677);
	angles[55] = (180, -47.5479, 264.0475);
	at[55] = 3.8500;
	points[56] = (1345.7638, 4861.8110, 1269.6458);
	angles[56] = (180, -47.5479, 264.0475);
	at[56] = 3.9000;
	points[57] = (1340.7559, 4857.1655, 1316.2480);
	angles[57] = (180, -47.5479, 264.0475);
	at[57] = 3.9500;
	points[58] = (1337.8346, 4854.4883, 1359.1418);
	angles[58] = (180, -47.5479, 264.0475);
	at[58] = 4;
	points[59] = (1335.9016, 4852.7954, 1398.4214);
	angles[59] = (180, -47.5479, 264.0475);
	at[59] = 4.0500;
	points[60] = (1333.4016, 4850.6299, 1465.3386);
	angles[60] = (180, -47.5479, 264.0475);
	at[60] = 4.1500;
	points[61] = (1332.4370, 4849.8032, 1493.2166);
	angles[61] = (180, -47.5479, 264.0475);
	at[61] = 4.2000;
	points[62] = (1331.5472, 4849.0552, 1516.9487);
	angles[62] = (180, -47.5479, 264.0475);
	at[62] = 4.2500;
	points[63] = (1329.8701, 4847.5591, 1552.4685);
	angles[63] = (180, -47.5479, 264.0475);
	at[63] = 4.3500;
	points[64] = (1329.1693, 4846.9292, 1563.6378);
	angles[64] = (180, -47.5479, 264.0475);
	at[64] = 4.4000;
	points[65] = (1328.7166, 4846.5352, 1569.9095);
	angles[65] = (180, -46.9307, 218.3959);
	at[65] = 4.4500;
	points[66] = (1328.7166, 4846.5352, 1570.8347);
	angles[66] = (180, -46.9307, 218.3959);
	at[66] = 4.5500;
	points[67] = (1328.7244, 4846.5352, 1569.7992);
	angles[67] = (0, -47.5479, 275.9525);
	at[67] = 4.6000;
	points[68] = (1328.9843, 4846.7720, 1566.2992);
	angles[68] = (0, -47.5479, 275.9525);
	at[68] = 4.7000;
	points[69] = (1329.3229, 4847.0864, 1561.3425);
	angles[69] = (0, -47.5479, 275.9525);
	at[69] = 4.7500;
	points[70] = (1330.4410, 4848.0708, 1541.7836);
	angles[70] = (0, -47.5479, 275.9525);
	at[70] = 4.8500;
	points[71] = (1331.0867, 4848.6616, 1527.9646);
	angles[71] = (0, -47.5479, 275.9525);
	at[71] = 4.9000;
	points[72] = (1332.5709, 4849.9214, 1489.4095);
	angles[72] = (0, -47.5479, 275.9525);
	at[72] = 5;
	points[73] = (1334.3857, 4851.4961, 1437.2362);
	angles[73] = (0, -47.5479, 275.9525);
	at[73] = 5.1000;
	points[74] = (1337.1771, 4853.9370, 1371.3425);
	angles[74] = (0, -47.5479, 275.9525);
	at[74] = 5.2000;
	points[75] = (1339.4646, 4855.9844, 1333.2283);
	angles[75] = (0, -47.5479, 275.9525);
	at[75] = 5.2500;
	points[76] = (1343.0472, 4859.2915, 1291.7717);
	angles[76] = (0, -47.5479, 275.9525);
	at[76] = 5.3000;
	points[77] = (1349.3700, 4865.1968, 1248.1182);
	angles[77] = (0, -47.5479, 275.9525);
	at[77] = 5.3500;
	points[78] = (1364.4883, 4879.6460, 1204.7323);
	angles[78] = (0, -46.1909, 314.2386);
	at[78] = 5.4000;
	points[79] = (1387.2206, 4901.5747, 1164.7166);
	angles[79] = (0, -46.1909, 314.2386);
	at[79] = 5.4500;
	points[80] = (1413.5591, 4926.9683, 1123.9961);
	angles[80] = (0, -46.1909, 314.2386);
	at[80] = 5.5000;
	points[81] = (1473.1576, 4984.3701, 1040.8977);
	angles[81] = (0, -46.1909, 314.2386);
	at[81] = 5.6000;
	points[82] = (1506.3661, 5016.1812, 998.6929);
	angles[82] = (0, -46.1909, 314.2386);
	at[82] = 5.6500;
	points[83] = (1542.7638, 5050.7085, 958.0197);
	angles[83] = (0, -47.9820, 344.8165);
	at[83] = 5.7000;
	points[84] = (1587.0670, 5091.0234, 931.1339);
	angles[84] = (0, -47.9820, 344.8165);
	at[84] = 5.7500;
	points[85] = (1636.1693, 5135, 912.3780);
	angles[85] = (0, -47.9820, 344.8165);
	at[85] = 5.8000;
	points[86] = (1686.6929, 5180.1968, 897.5040);
	angles[86] = (0, -47.9820, 344.8165);
	at[86] = 5.8500;
	points[87] = (1737.6576, 5226.3779, 885.9803);
	angles[87] = (0, -46.6077, 359.1907);
	at[87] = 5.9000;
	points[88] = (1788.8857, 5274.4883, 882.1969);
	angles[88] = (0, -46.6077, 359.1907);
	at[88] = 5.9500;
	points[89] = (1943.7520, 5421.2207, 881.8307);
	angles[89] = (0, -46.6077, 359.1907);
	at[89] = 6.1000;
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
