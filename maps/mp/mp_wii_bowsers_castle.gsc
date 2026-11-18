main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_bowsers_castle", 0);

	setExpFog(5905.5117, 64960.6250, 1, 0.4314, 0, 0);

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
	ambientPlay("iz_0_strm_n_koopa", 2);
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
	level.iz_route[level.iz_route.size] = (-4861, 7479, 2953);
	level.iz_route[level.iz_route.size] = (-4867, 6417, 2876);
	level.iz_route[level.iz_route.size] = (-4874, 5239, 2790);
	level.iz_route[level.iz_route.size] = (-4872, 3802, 2543);
	level.iz_route[level.iz_route.size] = (-4872, 3141, 2350);
	level.iz_route[level.iz_route.size] = (-4872, 2353, 2921);
	level.iz_route[level.iz_route.size] = (-4872, 1782, 3371);
	level.iz_route[level.iz_route.size] = (-4872, 1149, 3519);
	level.iz_route[level.iz_route.size] = (-4872, 501, 3445);
	level.iz_route[level.iz_route.size] = (-4872, -119, 3159);
	level.iz_route[level.iz_route.size] = (-4872, -1491, 3221);
	level.iz_route[level.iz_route.size] = (-4584, -3165, 3248);
	level.iz_route[level.iz_route.size] = (-4495, -4418, 3189);
	level.iz_route[level.iz_route.size] = (-4460, -5573, 3189);
	level.iz_route[level.iz_route.size] = (-4451, -6500, 3189);
	level.iz_route[level.iz_route.size] = (-4443, -7558, 3248);
	level.iz_route[level.iz_route.size] = (-4684, -9666, 2899);
	level.iz_route[level.iz_route.size] = (-4275, -10450, 2899);
	level.iz_route[level.iz_route.size] = (-3702, -10768, 2899);
	level.iz_route[level.iz_route.size] = (-2656, -11039, 2899);
	level.iz_route[level.iz_route.size] = (-1328, -11115, 2899);
	level.iz_route[level.iz_route.size] = (-818, -11342, 2899);
	level.iz_route[level.iz_route.size] = (-571, -11845, 2899);
	level.iz_route[level.iz_route.size] = (-433, -12627, 2780);
	level.iz_route[level.iz_route.size] = (-381, -13410, 2655);
	level.iz_route[level.iz_route.size] = (-279, -14083, 2655);
	level.iz_route[level.iz_route.size] = (92, -14489, 2655);
	level.iz_route[level.iz_route.size] = (387, -14646, 2630);
	level.iz_route[level.iz_route.size] = (987, -14620, 2484);
	level.iz_route[level.iz_route.size] = (1446, -14355, 2478);
	level.iz_route[level.iz_route.size] = (1931, -14258, 2478);
	level.iz_route[level.iz_route.size] = (2512, -14219, 2305);
	level.iz_route[level.iz_route.size] = (3145, -14000, 2257);
	level.iz_route[level.iz_route.size] = (3633, -13526, 2257);
	level.iz_route[level.iz_route.size] = (3842, -12843, 2257);
	level.iz_route[level.iz_route.size] = (3852, -12078, 2158);
	level.iz_route[level.iz_route.size] = (3858, -11559, 2066);
	level.iz_route[level.iz_route.size] = (3862, -11233, 2083);
	level.iz_route[level.iz_route.size] = (3843, -10705, 2414);
	level.iz_route[level.iz_route.size] = (3860, -10222, 2498);
	level.iz_route[level.iz_route.size] = (3856, -9691, 2264);
	level.iz_route[level.iz_route.size] = (3861, -9009, 1796);
	level.iz_route[level.iz_route.size] = (3861, -8246, 1709);
	level.iz_route[level.iz_route.size] = (3861, -7137, 1569);
	level.iz_route[level.iz_route.size] = (3861, -5820, 1557);
	level.iz_route[level.iz_route.size] = (3861, -4762, 1557);
	level.iz_route[level.iz_route.size] = (3861, -3661, 1557);
	level.iz_route[level.iz_route.size] = (3861, -2370, 1557);
	level.iz_route[level.iz_route.size] = (3861, -1365, 1557);
	level.iz_route[level.iz_route.size] = (3861, -850, 1580);
	level.iz_route[level.iz_route.size] = (3876, -14, 1809);
	level.iz_route[level.iz_route.size] = (3858, 776, 1421);
	level.iz_route[level.iz_route.size] = (4255, 1949, 1616);
	level.iz_route[level.iz_route.size] = (5013, 3096, 1770);
	level.iz_route[level.iz_route.size] = (5622, 3854, 1905);
	level.iz_route[level.iz_route.size] = (5834, 4886, 2121);
	level.iz_route[level.iz_route.size] = (5604, 5707, 2342);
	level.iz_route[level.iz_route.size] = (5146, 6633, 2568);
	level.iz_route[level.iz_route.size] = (4228, 7833, 2809);
	level.iz_route[level.iz_route.size] = (3822, 9103, 2911);
	level.iz_route[level.iz_route.size] = (3814, 10355, 3002);
	level.iz_route[level.iz_route.size] = (3969, 11421, 3119);
	level.iz_route[level.iz_route.size] = (4559, 11981, 3218);
	level.iz_route[level.iz_route.size] = (5350, 12008, 3290);
	level.iz_route[level.iz_route.size] = (6301, 11352, 3418);
	level.iz_route[level.iz_route.size] = (6592, 10567, 3461);
	level.iz_route[level.iz_route.size] = (6351, 9102, 3490);
	level.iz_route[level.iz_route.size] = (5535, 8233, 3622);
	level.iz_route[level.iz_route.size] = (4793, 7976, 3622);
	level.iz_route[level.iz_route.size] = (4150, 8063, 3626);
	level.iz_route[level.iz_route.size] = (3404, 8886, 3755);
	level.iz_route[level.iz_route.size] = (3215, 10703, 3755);
	level.iz_route[level.iz_route.size] = (2977, 11171, 3755);
	level.iz_route[level.iz_route.size] = (2596, 11767, 3766);
	level.iz_route[level.iz_route.size] = (2085, 12292, 3857);
	level.iz_route[level.iz_route.size] = (1535, 12857, 4065);
	level.iz_route[level.iz_route.size] = (1180, 13184, 4264);
	level.iz_route[level.iz_route.size] = (892, 13480, 4246);
	level.iz_route[level.iz_route.size] = (594, 13824, 3881);
	level.iz_route[level.iz_route.size] = (-177, 14691, 3777);
	level.iz_route[level.iz_route.size] = (-1092, 15631, 3593);
	level.iz_route[level.iz_route.size] = (-1937, 16424, 3370);
	level.iz_route[level.iz_route.size] = (-2606, 16842, 3370);
	level.iz_route[level.iz_route.size] = (-3179, 16974, 3370);
	level.iz_route[level.iz_route.size] = (-3796, 16789, 3306);
	level.iz_route[level.iz_route.size] = (-4480, 15895, 3074);
	level.iz_route[level.iz_route.size] = (-4797, 15181, 3009);
	level.iz_route[level.iz_route.size] = (-4892, 14373, 2953);
	level.iz_route[level.iz_route.size] = (-4882, 13506, 2953);
	level.iz_route[level.iz_route.size] = (-4869, 12241, 2953);
	level.iz_route[level.iz_route.size] = (-4857, 11218, 2953);
	level.iz_route[level.iz_route.size] = (-4847, 10300, 2953);
	level.iz_route[level.iz_route.size] = (-4831, 8776, 2953);
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
	thread iz_obj_10();
	thread iz_obj_11();
	thread iz_obj_12();
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
	thread iz_obj_20();
	thread iz_obj_21();
	thread iz_obj_22();
	thread iz_obj_23();
	thread iz_obj_24();
	thread iz_obj_25();
	thread iz_obj_26();
	thread iz_obj_27();
	thread iz_obj_28();
	thread iz_obj_29();
	thread iz_obj_30();
	thread iz_obj_31();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3944.9607, 4975.2759, 2362.2795);
	angles[0] = (0, 180, -68.9573);
	at[0] = 0;
	points[1] = (3944.9607, 4975.2759, 2362.2795);
	angles[1] = (0, 180, -68.9573);
	at[1] = 0.2000;
	points[2] = (3860.1379, 2975.8467, 2352.8308);
	angles[2] = (0, 180, -222.9643);
	at[2] = 0.2000;
	points[3] = (3860.1379, 2630.5513, 2320.9409);
	angles[3] = (0, 180, -213.9642);
	at[3] = 0.2500;
	points[4] = (3860.1379, 2285.2520, 2283.7363);
	angles[4] = (0, 180, -204.9641);
	at[4] = 0.3000;
	points[5] = (3860.1379, 1939.9567, 2241.2166);
	angles[5] = (0, 180, -195.9640);
	at[5] = 0.3500;
	points[6] = (3860.1379, 1594.6614, 2193.3818);
	angles[6] = (0, 180, -186.9639);
	at[6] = 0.4000;
	points[7] = (3860.1379, 1249.3623, 2140.2324);
	angles[7] = (0, 180, -177.9638);
	at[7] = 0.4500;
	points[8] = (3860.1379, 904.0670, 2081.7678);
	angles[8] = (0, 180, -168.9637);
	at[8] = 0.5000;
	points[9] = (3860.1379, 558.7717, 2017.9883);
	angles[9] = (0, 180, -159.9635);
	at[9] = 0.5500;
	points[10] = (3860.1379, 213.4736, 1948.8937);
	angles[10] = (0, 180, -150.9635);
	at[10] = 0.6000;
	points[11] = (3860.1379, -131.8228, 1874.4843);
	angles[11] = (0, 180, -141.9633);
	at[11] = 0.6500;
	points[12] = (3860.1379, -477.1181, 1856.3110);
	angles[12] = (0, 180, -118.9632);
	at[12] = 0.7000;
	points[13] = (3860.1379, -673.2047, 1905.9174);
	angles[13] = (0, 180, -88.9630);
	at[13] = 0.7500;
	points[14] = (3860.1379, -791.3149, 1950.2087);
	angles[14] = (0, 180, -58.9628);
	at[14] = 0.8000;
	points[15] = (3860.1379, -909.4252, 1989.1851);
	angles[15] = (0, 180, -28.9627);
	at[15] = 0.8500;
	points[16] = (3860.1379, -1027.5354, 2022.8464);
	angles[16] = (0, 180, 1.0375);
	at[16] = 0.9000;
	points[17] = (3860.1379, -1145.6456, 2051.1929);
	angles[17] = (0, 180, 31.0377);
	at[17] = 0.9500;
	points[18] = (3860.1379, -1263.7559, 2074.2244);
	angles[18] = (0, 180, 61.0377);
	at[18] = 1;
	points[19] = (3860.1379, -1381.8661, 2091.9409);
	angles[19] = (0, 180, 91.0379);
	at[19] = 1.0500;
	points[20] = (3860.1379, -1499.9763, 2104.3425);
	angles[20] = (0, 180, 121.0381);
	at[20] = 1.1000;
	points[21] = (3860.1379, -1618.0867, 2111.4292);
	angles[21] = (0, 180, 151.0382);
	at[21] = 1.1500;
	points[22] = (3860.1379, -1736.1969, 2113.2009);
	angles[22] = (0, 180, 181.0384);
	at[22] = 1.2000;
	points[23] = (3860.1379, -1854.3071, 2109.6575);
	angles[23] = (0, 180, 211.0386);
	at[23] = 1.2500;
	points[24] = (3860.1379, -1972.4174, 2100.7991);
	angles[24] = (0, 180, 241.0387);
	at[24] = 1.3000;
	points[25] = (3860.1379, -2090.5276, 2086.6260);
	angles[25] = (0, 180, 271.0389);
	at[25] = 1.3500;
	points[26] = (3860.1379, -2208.6377, 2067.1377);
	angles[26] = (0, 180, 301.0391);
	at[26] = 1.4000;
	points[27] = (3860.1379, -2326.7480, 2042.3347);
	angles[27] = (0, 180, 331.0392);
	at[27] = 1.4500;
	points[28] = (3860.1379, -2444.8584, 2012.2164);
	angles[28] = (0, 180, 361.0394);
	at[28] = 1.5000;
	points[29] = (3860.1379, -2562.9688, 1976.7834);
	angles[29] = (0, 180, 391.0394);
	at[29] = 1.5500;
	points[30] = (3860.1379, -2681.0789, 1936.0355);
	angles[30] = (0, 180, 421.0396);
	at[30] = 1.6000;
	points[31] = (3860.1379, -2799.1892, 1889.9724);
	angles[31] = (0, 180, 451.0397);
	at[31] = 1.6500;
	points[32] = (3860.1379, -2917.2993, 1852.4607);
	angles[32] = (0, 180, 481.0399);
	at[32] = 1.7000;
	points[33] = (3860.1379, -3035.4097, 1870.1771);
	angles[33] = (0, 180, 511.0400);
	at[33] = 1.7500;
	points[34] = (3860.1379, -3153.5198, 1882.5789);
	angles[34] = (0, 180, 541.0402);
	at[34] = 1.8000;
	points[35] = (3860.1379, -3271.6301, 1889.6654);
	angles[35] = (0, 180, 571.0404);
	at[35] = 1.8500;
	points[36] = (3860.1379, -3389.7402, 1891.4370);
	angles[36] = (0, 180, 601.0405);
	at[36] = 1.9000;
	points[37] = (3860.1379, -3507.8506, 1887.8937);
	angles[37] = (0, 180, 631.0407);
	at[37] = 1.9500;
	points[38] = (3860.1379, -3625.9607, 1879.0355);
	angles[38] = (0, 180, 661.0409);
	at[38] = 2;
	points[39] = (3860.1379, -3862.1814, 1854.4685);
	angles[39] = (0, 180, 721.0411);
	at[39] = 2.1000;
	points[40] = (3860.1379, -3980.2756, 1856.9489);
	angles[40] = (0, 180, 751.0413);
	at[40] = 2.1500;
	points[41] = (3860.1379, -4098.3857, 1854.1143);
	angles[41] = (0, 180, 781.0414);
	at[41] = 2.2000;
	points[42] = (3860.1379, -4216.4961, 1846.2717);
	angles[42] = (0, 180, 811.0416);
	at[42] = 2.2500;
	points[43] = (3860.1379, -4570.8267, 1852.4646);
	angles[43] = (0, 180, 901.0421);
	at[43] = 2.4000;
	points[44] = (3860.1379, -4925.1577, 1852.4646);
	angles[44] = (0, 180, 991.0426);
	at[44] = 2.5500;
	points[45] = (3860.1379, -4964.5273, 1852.4646);
	angles[45] = (0, 180, 1001.0426);
	at[45] = 2.5833;
	points[46] = (3944.9607, 4975.2759, 2362.2795);
	angles[46] = (0, 180, 1011.0427);
	at[46] = 2.5833;
	points[47] = (3944.9607, 4975.2759, 2362.2795);
	angles[47] = (0, 180, 1011.0427);
	at[47] = 3.5167;
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
	points[0] = (2982.9016, -4210.9448, 2391.7324);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2982.9016, -4210.9448, 2391.7324);
	angles[1] = (90, 0, 0);
	at[1] = 3;
	points[2] = (2982.9016, -4210.9448, 2391.7324);
	angles[2] = (180, 0, 0);
	at[2] = 6;
	points[3] = (2982.9016, -4210.9448, 2391.7324);
	angles[3] = (0, 0, 0);
	at[3] = 12;
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
	points[0] = (4732.2046, -4217.1655, 2391.7324);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4732.2046, -4217.1655, 2391.7324);
	angles[1] = (-90, 0, 0);
	at[1] = 3;
	points[2] = (4732.2046, -4217.1655, 2391.7324);
	angles[2] = (-180, 0, 0);
	at[2] = 6;
	points[3] = (4732.2046, -4217.1655, 2391.7324);
	angles[3] = (-360, 0, 0);
	at[3] = 12;
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
	points[0] = (2982.2952, -216.8528, 2391.7324);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2982.2952, -216.8528, 2391.7324);
	angles[1] = (-90, 0, 0);
	at[1] = 3;
	points[2] = (2982.2952, -216.8528, 2391.7324);
	angles[2] = (-180, 0, 0);
	at[2] = 6;
	points[3] = (2982.2952, -216.8528, 2391.7324);
	angles[3] = (-360, 0, 0);
	at[3] = 12;
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
	points[0] = (4739.1733, -232.0161, 2391.7324);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4739.1733, -232.0161, 2391.7324);
	angles[1] = (90, 0, 0);
	at[1] = 3;
	points[2] = (4739.1733, -232.0161, 2391.7324);
	angles[2] = (180, 0, 0);
	at[2] = 6;
	points[3] = (4739.1733, -232.0161, 2391.7324);
	angles[3] = (0, 0, 0);
	at[3] = 12;
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
	points[0] = (2156.3818, 3696.2954, 2309.0552);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2156.3818, 3696.2954, 2309.0552);
	angles[1] = (66.6208, -37.5106, -83.7459);
	at[1] = 3;
	points[2] = (2156.3818, 3696.2954, 2309.0552);
	angles[2] = (13.4911, -112.3942, -200.0374);
	at[2] = 6;
	points[3] = (2156.3818, 3696.2954, 2309.0552);
	angles[3] = (180, -180, -180);
	at[3] = 12;
	mover = getEnt("iz_obj_5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5565.0786, 3685.9133, 2309.0552);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5565.0786, 3685.9133, 2309.0552);
	angles[1] = (-66.6208, 37.5106, -83.7459);
	at[1] = 3;
	points[2] = (5565.0786, 3685.9133, 2309.0552);
	angles[2] = (-13.4911, 112.3942, -200.0374);
	at[2] = 6;
	points[3] = (5565.0786, 3685.9133, 2309.0552);
	angles[3] = (-180, 180, -180);
	at[3] = 12;
	mover = getEnt("iz_obj_6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1094.8464, 13316.8115, 3838.5828);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1094.8464, 13316.8115, 3838.5828);
	angles[1] = (45, -45, -90);
	at[1] = 4.5000;
	points[2] = (1094.8464, 13316.8115, 3838.5828);
	angles[2] = (0, -90, -180);
	at[2] = 9;
	points[3] = (1094.8464, 13316.8115, 3838.5828);
	angles[3] = (-180, -180, -180);
	at[3] = 18;
	mover = getEnt("iz_obj_7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-909.1693, -11001.6533, 3142.9097);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-909.1693, -11001.6533, 3139.6653);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (-909.1693, -11001.6533, 3127.5669);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (-909.1693, -11001.6533, 3130.8071);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (-909.1693, -11001.6533, 3142.9097);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (-909.1693, -11001.6533, 3139.6653);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (-909.1693, -11001.6533, 3127.5669);
	angles[6] = (0, 90, 0);
	at[6] = 0.3000;
	points[7] = (-909.1693, -11001.6533, 3130.8071);
	angles[7] = (0, 90, 0);
	at[7] = 0.3500;
	points[8] = (-909.1693, -11001.6533, 3142.9097);
	angles[8] = (0, 90, 0);
	at[8] = 0.4000;
	points[9] = (-909.1693, -11001.6533, 3139.6653);
	angles[9] = (0, 90, 0);
	at[9] = 0.4500;
	points[10] = (-909.1693, -11001.6533, 3145.5708);
	angles[10] = (0, 90, 0);
	at[10] = 0.5000;
	points[11] = (-909.1693, -11001.6533, 3278.4448);
	angles[11] = (0, 90, 0);
	at[11] = 0.6500;
	points[12] = (-909.1693, -11001.6533, 3248.3269);
	angles[12] = (0, 90, 0);
	at[12] = 0.7000;
	points[13] = (-909.1693, -11001.6533, 3173.0315);
	angles[13] = (0, 90, 0);
	at[13] = 0.7500;
	points[14] = (-909.1693, -11001.6533, 3052.5593);
	angles[14] = (0, 90, 0);
	at[14] = 0.8000;
	points[15] = (-909.1693, -11001.6533, 2899.0159);
	angles[15] = (0, 90, 0);
	at[15] = 0.8500;
	points[16] = (-909.1693, -11001.6533, 2899.0159);
	angles[16] = (0, 90, 0);
	at[16] = 1.8500;
	points[17] = (-909.1693, -11001.6533, 3129.3308);
	angles[17] = (0, 90, 0);
	at[17] = 3.1500;
	points[18] = (-909.1693, -11001.6533, 3135.2363);
	angles[18] = (0, 90, 0);
	at[18] = 3.2000;
	points[19] = (-909.1693, -11001.6533, 3135.2363);
	angles[19] = (0, 90, 0);
	at[19] = 4.6500;
	points[20] = (-909.1693, -11001.6533, 3142.9097);
	angles[20] = (0, 90, 0);
	at[20] = 4.7167;
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
	points[0] = (3113.1497, -14263.3467, 2687.0078);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (3113.1497, -14263.3467, 2687.0078);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (3113.1497, -14263.3467, 2694.6812);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (3113.1497, -14263.3467, 2691.4373);
	angles[3] = (0, 90, 0);
	at[3] = 0.5500;
	points[4] = (3113.1497, -14263.3467, 2679.3347);
	angles[4] = (0, 90, 0);
	at[4] = 0.6000;
	points[5] = (3113.1497, -14263.3467, 2682.5786);
	angles[5] = (0, 90, 0);
	at[5] = 0.6500;
	points[6] = (3113.1497, -14263.3467, 2694.6812);
	angles[6] = (0, 90, 0);
	at[6] = 0.7000;
	points[7] = (3113.1497, -14263.3467, 2691.4373);
	angles[7] = (0, 90, 0);
	at[7] = 0.7500;
	points[8] = (3113.1497, -14263.3467, 2679.3347);
	angles[8] = (0, 90, 0);
	at[8] = 0.8000;
	points[9] = (3113.1497, -14263.3467, 2682.5786);
	angles[9] = (0, 90, 0);
	at[9] = 0.8500;
	points[10] = (3113.1497, -14263.3467, 2694.6812);
	angles[10] = (0, 90, 0);
	at[10] = 0.9000;
	points[11] = (3113.1497, -14263.3467, 2691.4373);
	angles[11] = (0, 90, 0);
	at[11] = 0.9500;
	points[12] = (3113.1497, -14263.3467, 2697.3425);
	angles[12] = (0, 90, 0);
	at[12] = 1;
	points[13] = (3113.1497, -14263.3467, 2830.2166);
	angles[13] = (0, 90, 0);
	at[13] = 1.1500;
	points[14] = (3113.1497, -14263.3467, 2800.0984);
	angles[14] = (0, 90, 0);
	at[14] = 1.2000;
	points[15] = (3113.1497, -14263.3467, 2724.8032);
	angles[15] = (0, 90, 0);
	at[15] = 1.2500;
	points[16] = (3113.1497, -14263.3467, 2604.3308);
	angles[16] = (0, 90, 0);
	at[16] = 1.3000;
	points[17] = (3113.1497, -14263.3467, 2438.6812);
	angles[17] = (0, 90, 0);
	at[17] = 1.3500;
	points[18] = (3113.1497, -14263.3467, 2256.7913);
	angles[18] = (0, 90, 0);
	at[18] = 1.4000;
	points[19] = (3113.1497, -14263.3467, 2256.7913);
	angles[19] = (0, 90, 0);
	at[19] = 2.4000;
	points[20] = (3113.1497, -14263.3467, 2681.9880);
	angles[20] = (0, 90, 0);
	at[20] = 4.8000;
	points[21] = (3113.1497, -14263.3467, 2687.0078);
	angles[21] = (0, 90, 0);
	at[21] = 4.8500;
	points[22] = (3113.1497, -14263.3467, 2687.0078);
	angles[22] = (0, 90, 0);
	at[22] = 5.8500;
	mover = getEnt("iz_obj_9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-432.1614, -14458.1494, 2868.0120);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-432.1614, -14458.1494, 2947.7361);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-432.1614, -14458.1494, 2952.7559);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-432.1614, -14458.1494, 2952.7559);
	angles[3] = (0, 0, 0);
	at[3] = 1.9500;
	points[4] = (-432.1614, -14458.1494, 2960.4292);
	angles[4] = (0, 0, 0);
	at[4] = 2;
	points[5] = (-432.1614, -14458.1494, 2957.1853);
	angles[5] = (0, 0, 0);
	at[5] = 2.0500;
	points[6] = (-432.1614, -14458.1494, 2945.0828);
	angles[6] = (0, 0, 0);
	at[6] = 2.1000;
	points[7] = (-432.1614, -14458.1494, 2948.3267);
	angles[7] = (0, 0, 0);
	at[7] = 2.1500;
	points[8] = (-432.1614, -14458.1494, 2960.4292);
	angles[8] = (0, 0, 0);
	at[8] = 2.2000;
	points[9] = (-432.1614, -14458.1494, 2957.1853);
	angles[9] = (0, 0, 0);
	at[9] = 2.2500;
	points[10] = (-432.1614, -14458.1494, 2945.0828);
	angles[10] = (0, 0, 0);
	at[10] = 2.3000;
	points[11] = (-432.1614, -14458.1494, 2948.3267);
	angles[11] = (0, 0, 0);
	at[11] = 2.3500;
	points[12] = (-432.1614, -14458.1494, 2960.4292);
	angles[12] = (0, 0, 0);
	at[12] = 2.4000;
	points[13] = (-432.1614, -14458.1494, 2957.1853);
	angles[13] = (0, 0, 0);
	at[13] = 2.4500;
	points[14] = (-432.1614, -14458.1494, 2963.0906);
	angles[14] = (0, 0, 0);
	at[14] = 2.5000;
	points[15] = (-432.1614, -14458.1494, 3095.9646);
	angles[15] = (0, 0, 0);
	at[15] = 2.6500;
	points[16] = (-432.1614, -14458.1494, 3065.8464);
	angles[16] = (0, 0, 0);
	at[16] = 2.7000;
	points[17] = (-432.1614, -14458.1494, 2990.5513);
	angles[17] = (0, 0, 0);
	at[17] = 2.7500;
	points[18] = (-432.1614, -14458.1494, 2870.0789);
	angles[18] = (0, 0, 0);
	at[18] = 2.8000;
	points[19] = (-432.1614, -14458.1494, 2704.4290);
	angles[19] = (0, 0, 0);
	at[19] = 2.8500;
	points[20] = (-432.1614, -14458.1494, 2655.4136);
	angles[20] = (0, 0, 0);
	at[20] = 2.9000;
	points[21] = (-432.1614, -14458.1494, 2655.4136);
	angles[21] = (0, 0, 0);
	at[21] = 3.8500;
	points[22] = (-432.1614, -14458.1494, 2661.3191);
	angles[22] = (0, 0, 0);
	at[22] = 3.9000;
	points[23] = (-432.1614, -14458.1494, 2868.0120);
	angles[23] = (0, 0, 0);
	at[23] = 5.0667;
	mover = getEnt("iz_obj_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3059.0549, 10629.9219, 3991.5750);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (3059.0549, 10629.9219, 3991.5750);
	angles[1] = (0, 180, 0);
	at[1] = 2.4500;
	points[2] = (3059.0549, 10629.9219, 3999.2520);
	angles[2] = (0, 180, 0);
	at[2] = 2.5000;
	points[3] = (3059.0549, 10629.9219, 3996.0237);
	angles[3] = (0, 180, 0);
	at[3] = 2.5500;
	points[4] = (3059.0549, 10629.9219, 3983.8977);
	angles[4] = (0, 180, 0);
	at[4] = 2.6000;
	points[5] = (3059.0549, 10629.9219, 3987.1655);
	angles[5] = (0, 180, 0);
	at[5] = 2.6500;
	points[6] = (3059.0549, 10629.9219, 3999.2520);
	angles[6] = (0, 180, 0);
	at[6] = 2.7000;
	points[7] = (3059.0549, 10629.9219, 3996.0237);
	angles[7] = (0, 180, 0);
	at[7] = 2.7500;
	points[8] = (3059.0549, 10629.9219, 3983.8977);
	angles[8] = (0, 180, 0);
	at[8] = 2.8000;
	points[9] = (3059.0549, 10629.9219, 3987.1655);
	angles[9] = (0, 180, 0);
	at[9] = 2.8500;
	points[10] = (3059.0549, 10629.9219, 3999.2520);
	angles[10] = (0, 180, 0);
	at[10] = 2.9000;
	points[11] = (3059.0549, 10629.9219, 3996.0237);
	angles[11] = (0, 180, 0);
	at[11] = 2.9500;
	points[12] = (3059.0549, 10629.9219, 4001.9292);
	angles[12] = (0, 180, 0);
	at[12] = 3;
	points[13] = (3059.0549, 10629.9219, 4134.8032);
	angles[13] = (0, 180, 0);
	at[13] = 3.1500;
	points[14] = (3059.0549, 10629.9219, 4104.6851);
	angles[14] = (0, 180, 0);
	at[14] = 3.2000;
	points[15] = (3059.0549, 10629.9219, 4029.3701);
	angles[15] = (0, 180, 0);
	at[15] = 3.2500;
	points[16] = (3059.0549, 10629.9219, 3908.8977);
	angles[16] = (0, 180, 0);
	at[16] = 3.3000;
	points[17] = (3059.0549, 10629.9219, 3755.3425);
	angles[17] = (0, 180, 0);
	at[17] = 3.3500;
	points[18] = (3059.0549, 10629.9219, 3755.3425);
	angles[18] = (0, 180, 0);
	at[18] = 3.5500;
	points[19] = (3059.0549, 10629.9219, 3755.3425);
	angles[19] = (0, 180, 0);
	at[19] = 4.3500;
	points[20] = (3059.0549, 10629.9219, 3985.6694);
	angles[20] = (0, 180, 0);
	at[20] = 5.6500;
	points[21] = (3059.0549, 10629.9219, 3991.5750);
	angles[21] = (0, 180, 0);
	at[21] = 5.7167;
	mover = getEnt("iz_obj_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3307.0867, 10629.9219, 4000.4331);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (3307.0867, 10629.9219, 3982.7168);
	angles[1] = (0, 180, 0);
	at[1] = 0.1000;
	points[2] = (3307.0867, 10629.9219, 4000.4331);
	angles[2] = (0, 180, 0);
	at[2] = 0.2000;
	points[3] = (3307.0867, 10629.9219, 3991.5750);
	angles[3] = (0, 180, 0);
	at[3] = 0.2500;
	points[4] = (3307.0867, 10629.9219, 4016.6931);
	angles[4] = (0, 180, 0);
	at[4] = 0.3000;
	points[5] = (3307.0867, 10629.9219, 4105.2759);
	angles[5] = (0, 180, 0);
	at[5] = 0.4000;
	points[6] = (3307.0867, 10629.9219, 4129.7642);
	angles[6] = (0, 180, 0);
	at[6] = 0.4500;
	points[7] = (3307.0867, 10629.9219, 4084.6064);
	angles[7] = (0, 180, 0);
	at[7] = 0.5000;
	points[8] = (3307.0867, 10629.9219, 3994.2522);
	angles[8] = (0, 180, 0);
	at[8] = 0.5500;
	points[9] = (3307.0867, 10629.9219, 3858.7009);
	angles[9] = (0, 180, 0);
	at[9] = 0.6000;
	points[10] = (3307.0867, 10629.9219, 3755.3425);
	angles[10] = (0, 180, 0);
	at[10] = 0.6500;
	points[11] = (3307.0867, 10629.9219, 3755.3425);
	angles[11] = (0, 180, 0);
	at[11] = 1.6000;
	points[12] = (3307.0867, 10629.9219, 3758.2954);
	angles[12] = (0, 180, 0);
	at[12] = 1.6500;
	points[13] = (3307.0867, 10629.9219, 3988.6221);
	angles[13] = (0, 180, 0);
	at[13] = 2.9500;
	points[14] = (3307.0867, 10629.9219, 3991.5750);
	angles[14] = (0, 180, 0);
	at[14] = 3;
	points[15] = (3307.0867, 10629.9219, 3991.5750);
	angles[15] = (0, 180, 0);
	at[15] = 5.4500;
	points[16] = (3307.0867, 10629.9219, 3999.2520);
	angles[16] = (0, 180, 0);
	at[16] = 5.5000;
	points[17] = (3307.0867, 10629.9219, 3996.0237);
	angles[17] = (0, 180, 0);
	at[17] = 5.5500;
	points[18] = (3307.0867, 10629.9219, 3983.8977);
	angles[18] = (0, 180, 0);
	at[18] = 5.6000;
	points[19] = (3307.0867, 10629.9219, 3987.1655);
	angles[19] = (0, 180, 0);
	at[19] = 5.6500;
	points[20] = (3307.0867, 10629.9219, 3999.2520);
	angles[20] = (0, 180, 0);
	at[20] = 5.7000;
	points[21] = (3307.0867, 10629.9219, 4000.4331);
	angles[21] = (0, 180, 0);
	at[21] = 5.7167;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3552.1653, 10629.9219, 3991.5750);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (3552.1653, 10629.9219, 3991.5750);
	angles[1] = (0, 180, 0);
	at[1] = 2.4500;
	points[2] = (3552.1653, 10629.9219, 3999.2520);
	angles[2] = (0, 180, 0);
	at[2] = 2.5000;
	points[3] = (3552.1653, 10629.9219, 3996.0237);
	angles[3] = (0, 180, 0);
	at[3] = 2.5500;
	points[4] = (3552.1653, 10629.9219, 3983.8977);
	angles[4] = (0, 180, 0);
	at[4] = 2.6000;
	points[5] = (3552.1653, 10629.9219, 3987.1655);
	angles[5] = (0, 180, 0);
	at[5] = 2.6500;
	points[6] = (3552.1653, 10629.9219, 3999.2520);
	angles[6] = (0, 180, 0);
	at[6] = 2.7000;
	points[7] = (3552.1653, 10629.9219, 3996.0237);
	angles[7] = (0, 180, 0);
	at[7] = 2.7500;
	points[8] = (3552.1653, 10629.9219, 3983.8977);
	angles[8] = (0, 180, 0);
	at[8] = 2.8000;
	points[9] = (3552.1653, 10629.9219, 3987.1655);
	angles[9] = (0, 180, 0);
	at[9] = 2.8500;
	points[10] = (3552.1653, 10629.9219, 3999.2520);
	angles[10] = (0, 180, 0);
	at[10] = 2.9000;
	points[11] = (3552.1653, 10629.9219, 3996.0237);
	angles[11] = (0, 180, 0);
	at[11] = 2.9500;
	points[12] = (3552.1653, 10629.9219, 4001.9292);
	angles[12] = (0, 180, 0);
	at[12] = 3;
	points[13] = (3552.1653, 10629.9219, 4134.8032);
	angles[13] = (0, 180, 0);
	at[13] = 3.1500;
	points[14] = (3552.1653, 10629.9219, 4104.6851);
	angles[14] = (0, 180, 0);
	at[14] = 3.2000;
	points[15] = (3552.1653, 10629.9219, 4029.3701);
	angles[15] = (0, 180, 0);
	at[15] = 3.2500;
	points[16] = (3552.1653, 10629.9219, 3908.8977);
	angles[16] = (0, 180, 0);
	at[16] = 3.3000;
	points[17] = (3552.1653, 10629.9219, 3755.3425);
	angles[17] = (0, 180, 0);
	at[17] = 3.3500;
	points[18] = (3552.1653, 10629.9219, 3755.3425);
	angles[18] = (0, 180, 0);
	at[18] = 3.5500;
	points[19] = (3552.1653, 10629.9219, 3755.3425);
	angles[19] = (0, 180, 0);
	at[19] = 4.3500;
	points[20] = (3552.1653, 10629.9219, 3985.6694);
	angles[20] = (0, 180, 0);
	at[20] = 5.6500;
	points[21] = (3552.1653, 10629.9219, 3991.5750);
	angles[21] = (0, 180, 0);
	at[21] = 5.7167;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5438.3467, 7827.0078, 3622.4685);
	angles[0] = (0, -45, 0);
	at[0] = 0;
	points[1] = (5438.3467, 7827.0078, 3622.4685);
	angles[1] = (0, -45, 0);
	at[1] = 0.6000;
	points[2] = (5438.3467, 7827.0078, 3625.4214);
	angles[2] = (0, -45, 0);
	at[2] = 0.6500;
	points[3] = (5438.3467, 7827.0078, 3855.7363);
	angles[3] = (0, -45, 0);
	at[3] = 1.9500;
	points[4] = (5438.3467, 7827.0078, 3858.7009);
	angles[4] = (0, -45, 0);
	at[4] = 2;
	points[5] = (5438.3467, 7827.0078, 3858.7009);
	angles[5] = (0, -45, 0);
	at[5] = 3.4500;
	points[6] = (5438.3467, 7827.0078, 3866.3740);
	angles[6] = (0, -45, 0);
	at[6] = 3.5000;
	points[7] = (5438.3467, 7827.0078, 3863.1299);
	angles[7] = (0, -45, 0);
	at[7] = 3.5500;
	points[8] = (5438.3467, 7827.0078, 3851.0315);
	angles[8] = (0, -45, 0);
	at[8] = 3.6000;
	points[9] = (5438.3467, 7827.0078, 3854.2717);
	angles[9] = (0, -45, 0);
	at[9] = 3.6500;
	points[10] = (5438.3467, 7827.0078, 3866.3740);
	angles[10] = (0, -45, 0);
	at[10] = 3.7000;
	points[11] = (5438.3467, 7827.0078, 3863.1299);
	angles[11] = (0, -45, 0);
	at[11] = 3.7500;
	points[12] = (5438.3467, 7827.0078, 3851.0315);
	angles[12] = (0, -45, 0);
	at[12] = 3.8000;
	points[13] = (5438.3467, 7827.0078, 3854.2717);
	angles[13] = (0, -45, 0);
	at[13] = 3.8500;
	points[14] = (5438.3467, 7827.0078, 3866.3740);
	angles[14] = (0, -45, 0);
	at[14] = 3.9000;
	points[15] = (5438.3467, 7827.0078, 3863.1299);
	angles[15] = (0, -45, 0);
	at[15] = 3.9500;
	points[16] = (5438.3467, 7827.0078, 3869.0354);
	angles[16] = (0, -45, 0);
	at[16] = 4;
	points[17] = (5438.3467, 7827.0078, 4001.9292);
	angles[17] = (0, -45, 0);
	at[17] = 4.1500;
	points[18] = (5438.3467, 7827.0078, 3971.8113);
	angles[18] = (0, -45, 0);
	at[18] = 4.2000;
	points[19] = (5438.3467, 7827.0078, 3896.4961);
	angles[19] = (0, -45, 0);
	at[19] = 4.2500;
	points[20] = (5438.3467, 7827.0078, 3776.0237);
	angles[20] = (0, -45, 0);
	at[20] = 4.3000;
	points[21] = (5438.3467, 7827.0078, 3622.4685);
	angles[21] = (0, -45, 0);
	at[21] = 4.3500;
	points[22] = (5438.3467, 7827.0078, 3622.4685);
	angles[22] = (0, -45, 0);
	at[22] = 4.7167;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4344.1733, 10165.5508, 2860.1616);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4344.1733, 10165.5508, 2900.6694);
	angles[1] = (0, -170, 0);
	at[1] = 0.1000;
	points[2] = (-4344.1733, 10165.5508, 2929.6064);
	angles[2] = (0, -170, 0);
	at[2] = 0.2000;
	points[3] = (-4344.1733, 10165.5508, 2946.9685);
	angles[3] = (0, -170, 0);
	at[3] = 0.3000;
	points[4] = (-4344.1733, 10165.5508, 2952.7559);
	angles[4] = (0, -170, 0);
	at[4] = 0.4000;
	points[5] = (-4344.1733, 10165.5508, 2966.7952);
	angles[5] = (0, -170, 0);
	at[5] = 0.5000;
	points[6] = (-4344.1733, 10165.5508, 2966.7952);
	angles[6] = (0, -170, 0);
	at[6] = 0.5500;
	points[7] = (-4344.1733, 10165.5508, 2961.4331);
	angles[7] = (0, -170, 0);
	at[7] = 0.6000;
	points[8] = (-4344.1733, 10165.5508, 2944.0789);
	angles[8] = (0, -170, 0);
	at[8] = 0.7000;
	points[9] = (-4344.1733, 10165.5508, 2938.7126);
	angles[9] = (0, -170, 0);
	at[9] = 0.7500;
	points[10] = (-4344.1733, 10165.5508, 2938.7126);
	angles[10] = (0, -170, 0);
	at[10] = 0.8000;
	points[11] = (-4344.1733, 10165.5508, 2944.0789);
	angles[11] = (0, -170, 0);
	at[11] = 0.8500;
	points[12] = (-4344.1733, 10165.5508, 2961.4331);
	angles[12] = (0, -170, 0);
	at[12] = 0.9500;
	points[13] = (-4344.1733, 10165.5508, 2966.7952);
	angles[13] = (0, -170, 0);
	at[13] = 1;
	points[14] = (-4344.1733, 10165.5508, 2966.7952);
	angles[14] = (0, -170, 0);
	at[14] = 1.0500;
	points[15] = (-4344.1733, 10165.5508, 2961.4331);
	angles[15] = (0, -170, 0);
	at[15] = 1.1000;
	points[16] = (-4344.1733, 10165.5508, 2944.0789);
	angles[16] = (0, -170, 0);
	at[16] = 1.2000;
	points[17] = (-4344.1733, 10165.5508, 2938.7126);
	angles[17] = (0, -170, 0);
	at[17] = 1.2500;
	points[18] = (-4344.1733, 10165.5508, 2938.7126);
	angles[18] = (0, -170, 0);
	at[18] = 1.3000;
	points[19] = (-4344.1733, 10165.5508, 2944.0789);
	angles[19] = (0, -170, 0);
	at[19] = 1.3500;
	points[20] = (-4344.1733, 10165.5508, 2961.4331);
	angles[20] = (0, -170, 0);
	at[20] = 1.4500;
	points[21] = (-4344.1733, 10165.5508, 2966.7952);
	angles[21] = (0, -170, 0);
	at[21] = 1.5000;
	points[22] = (-4344.1733, 10165.5508, 2966.7952);
	angles[22] = (0, -170, 0);
	at[22] = 1.5500;
	points[23] = (-4344.1733, 10165.5508, 2945.0234);
	angles[23] = (0, -170, 0);
	at[23] = 1.7000;
	points[24] = (-4344.1733, 10165.5508, 2525.6062);
	angles[24] = (0, -170, 0);
	at[24] = 3.2000;
	points[25] = (-4344.1733, 10165.5508, 2524.0159);
	angles[25] = (0, -170, 0);
	at[25] = 4;
	points[26] = (-4344.1733, 10165.5508, 2524.0159);
	angles[26] = (0, -170, 0);
	at[26] = 6.3000;
	points[27] = (-4344.1733, 10165.5508, 2612.5984);
	angles[27] = (0, -170, 0);
	at[27] = 6.3500;
	points[28] = (-4344.1733, 10165.5508, 2612.5984);
	angles[28] = (0, -170, 0);
	at[28] = 8.6000;
	points[29] = (-4344.1733, 10165.5508, 2627.2283);
	angles[29] = (0, -170, 0);
	at[29] = 8.6500;
	points[30] = (-4344.1733, 10165.5508, 2708.2480);
	angles[30] = (0, -170, 0);
	at[30] = 8.7500;
	points[31] = (-4344.1733, 10165.5508, 2777.6929);
	angles[31] = (0, -170, 0);
	at[31] = 8.8500;
	points[32] = (-4344.1733, 10165.5508, 2835.5669);
	angles[32] = (0, -170, 0);
	at[32] = 8.9500;
	points[33] = (-4344.1733, 10165.5508, 2860.1616);
	angles[33] = (0, -170, 0);
	at[33] = 9;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5110.3936, 9902.8740, 2385.8267);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-5110.3936, 9902.8740, 2385.8267);
	angles[1] = (0, -170, 0);
	at[1] = 0.3000;
	points[2] = (-5110.3936, 9902.8740, 2457.3623);
	angles[2] = (0, -170, 0);
	at[2] = 0.3500;
	points[3] = (-5110.3936, 9902.8740, 2524.0750);
	angles[3] = (0, -170, 0);
	at[3] = 0.4000;
	points[4] = (-5110.3936, 9902.8740, 2585.9646);
	angles[4] = (0, -170, 0);
	at[4] = 0.4500;
	points[5] = (-5110.3936, 9902.8740, 2643.0356);
	angles[5] = (0, -170, 0);
	at[5] = 0.5000;
	points[6] = (-5110.3936, 9902.8740, 2695.2795);
	angles[6] = (0, -170, 0);
	at[6] = 0.5500;
	points[7] = (-5110.3936, 9902.8740, 2742.7007);
	angles[7] = (0, -170, 0);
	at[7] = 0.6000;
	points[8] = (-5110.3936, 9902.8740, 2785.3030);
	angles[8] = (0, -170, 0);
	at[8] = 0.6500;
	points[9] = (-5110.3936, 9902.8740, 2823.0789);
	angles[9] = (0, -170, 0);
	at[9] = 0.7000;
	points[10] = (-5110.3936, 9902.8740, 2856.0354);
	angles[10] = (0, -170, 0);
	at[10] = 0.7500;
	points[11] = (-5110.3936, 9902.8740, 2884.1653);
	angles[11] = (0, -170, 0);
	at[11] = 0.8000;
	points[12] = (-5110.3936, 9902.8740, 2907.4763);
	angles[12] = (0, -170, 0);
	at[12] = 0.8500;
	points[13] = (-5110.3936, 9902.8740, 2925.9648);
	angles[13] = (0, -170, 0);
	at[13] = 0.9000;
	points[14] = (-5110.3936, 9902.8740, 2939.6260);
	angles[14] = (0, -170, 0);
	at[14] = 0.9500;
	points[15] = (-5110.3936, 9902.8740, 2948.4685);
	angles[15] = (0, -170, 0);
	at[15] = 1;
	points[16] = (-5110.3936, 9902.8740, 2965.5432);
	angles[16] = (0, -170, 0);
	at[16] = 1.1500;
	points[17] = (-5110.3936, 9902.8740, 2967.4370);
	angles[17] = (0, -170, 0);
	at[17] = 1.2000;
	points[18] = (-5110.3936, 9902.8740, 2963.7285);
	angles[18] = (0, -170, 0);
	at[18] = 1.2500;
	points[19] = (-5110.3936, 9902.8740, 2939.9685);
	angles[19] = (0, -170, 0);
	at[19] = 1.4000;
	points[20] = (-5110.3936, 9902.8740, 2938.0747);
	angles[20] = (0, -170, 0);
	at[20] = 1.4500;
	points[21] = (-5110.3936, 9902.8740, 2941.7834);
	angles[21] = (0, -170, 0);
	at[21] = 1.5000;
	points[22] = (-5110.3936, 9902.8740, 2965.5432);
	angles[22] = (0, -170, 0);
	at[22] = 1.6500;
	points[23] = (-5110.3936, 9902.8740, 2967.4370);
	angles[23] = (0, -170, 0);
	at[23] = 1.7000;
	points[24] = (-5110.3936, 9902.8740, 2963.7285);
	angles[24] = (0, -170, 0);
	at[24] = 1.7500;
	points[25] = (-5110.3936, 9902.8740, 2939.9685);
	angles[25] = (0, -170, 0);
	at[25] = 1.9000;
	points[26] = (-5110.3936, 9902.8740, 2938.0747);
	angles[26] = (0, -170, 0);
	at[26] = 1.9500;
	points[27] = (-5110.3936, 9902.8740, 2941.7834);
	angles[27] = (0, -170, 0);
	at[27] = 2;
	points[28] = (-5110.3936, 9902.8740, 2965.5432);
	angles[28] = (0, -170, 0);
	at[28] = 2.1500;
	points[29] = (-5110.3936, 9902.8740, 2967.4370);
	angles[29] = (0, -170, 0);
	at[29] = 2.2000;
	points[30] = (-5110.3936, 9902.8740, 2963.7285);
	angles[30] = (0, -170, 0);
	at[30] = 2.2500;
	points[31] = (-5110.3936, 9902.8740, 2949.6851);
	angles[31] = (0, -170, 0);
	at[31] = 2.3500;
	points[32] = (-5110.3936, 9902.8740, 2308.4253);
	angles[32] = (0, -170, 0);
	at[32] = 3.8500;
	points[33] = (-5110.3936, 9902.8740, 2297.2441);
	angles[33] = (0, -170, 0);
	at[33] = 3.9000;
	points[34] = (-5110.3936, 9902.8740, 2297.2441);
	angles[34] = (0, -170, 0);
	at[34] = 6.9500;
	points[35] = (-5110.3936, 9902.8740, 2385.8267);
	angles[35] = (0, -170, 0);
	at[35] = 7;
	points[36] = (-5110.3936, 9902.8740, 2385.8267);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4638.7402, 10668.9766, 2612.5984);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4638.7402, 10668.9766, 2612.5984);
	angles[1] = (0, -170, 0);
	at[1] = 0.9500;
	points[2] = (-4638.7402, 10668.9766, 2641.5354);
	angles[2] = (0, -170, 0);
	at[2] = 1;
	points[3] = (-4638.7402, 10668.9766, 2720.6260);
	angles[3] = (0, -170, 0);
	at[3] = 1.1000;
	points[4] = (-4638.7402, 10668.9766, 2788.1418);
	angles[4] = (0, -170, 0);
	at[4] = 1.2000;
	points[5] = (-4638.7402, 10668.9766, 2844.0867);
	angles[5] = (0, -170, 0);
	at[5] = 1.3000;
	points[6] = (-4638.7402, 10668.9766, 2888.4529);
	angles[6] = (0, -170, 0);
	at[6] = 1.4000;
	points[7] = (-4638.7402, 10668.9766, 2921.2480);
	angles[7] = (0, -170, 0);
	at[7] = 1.5000;
	points[8] = (-4638.7402, 10668.9766, 2942.4685);
	angles[8] = (0, -170, 0);
	at[8] = 1.6000;
	points[9] = (-4638.7402, 10668.9766, 2967.4370);
	angles[9] = (0, -170, 0);
	at[9] = 1.8500;
	points[10] = (-4638.7402, 10668.9766, 2965.5432);
	angles[10] = (0, -170, 0);
	at[10] = 1.9000;
	points[11] = (-4638.7402, 10668.9766, 2941.7834);
	angles[11] = (0, -170, 0);
	at[11] = 2.0500;
	points[12] = (-4638.7402, 10668.9766, 2938.0747);
	angles[12] = (0, -170, 0);
	at[12] = 2.1000;
	points[13] = (-4638.7402, 10668.9766, 2939.9685);
	angles[13] = (0, -170, 0);
	at[13] = 2.1500;
	points[14] = (-4638.7402, 10668.9766, 2963.7285);
	angles[14] = (0, -170, 0);
	at[14] = 2.3000;
	points[15] = (-4638.7402, 10668.9766, 2967.4370);
	angles[15] = (0, -170, 0);
	at[15] = 2.3500;
	points[16] = (-4638.7402, 10668.9766, 2965.5432);
	angles[16] = (0, -170, 0);
	at[16] = 2.4000;
	points[17] = (-4638.7402, 10668.9766, 2941.7834);
	angles[17] = (0, -170, 0);
	at[17] = 2.5500;
	points[18] = (-4638.7402, 10668.9766, 2938.0747);
	angles[18] = (0, -170, 0);
	at[18] = 2.6000;
	points[19] = (-4638.7402, 10668.9766, 2939.9685);
	angles[19] = (0, -170, 0);
	at[19] = 2.6500;
	points[20] = (-4638.7402, 10668.9766, 2963.7285);
	angles[20] = (0, -170, 0);
	at[20] = 2.8000;
	points[21] = (-4638.7402, 10668.9766, 2967.4370);
	angles[21] = (0, -170, 0);
	at[21] = 2.8500;
	points[22] = (-4638.7402, 10668.9766, 2965.5432);
	angles[22] = (0, -170, 0);
	at[22] = 2.9000;
	points[23] = (-4638.7402, 10668.9766, 2958.7598);
	angles[23] = (0, -170, 0);
	at[23] = 2.9500;
	points[24] = (-4638.7402, 10668.9766, 2940.3662);
	angles[24] = (0, -170, 0);
	at[24] = 3.0500;
	points[25] = (-4638.7402, 10668.9766, 2534.9253);
	angles[25] = (0, -170, 0);
	at[25] = 4.5000;
	points[26] = (-4638.7402, 10668.9766, 2524.0159);
	angles[26] = (0, -170, 0);
	at[26] = 4.5500;
	points[27] = (-4638.7402, 10668.9766, 2524.0159);
	angles[27] = (0, -170, 0);
	at[27] = 7.6500;
	points[28] = (-4638.7402, 10668.9766, 2612.5984);
	angles[28] = (0, -170, 0);
	at[28] = 7.7000;
	points[29] = (-4638.7402, 10668.9766, 2612.5984);
	angles[29] = (0, -170, 0);
	at[29] = 9;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4478.6221, 11299.2129, 2499.2126);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4478.6221, 11299.2129, 2499.2126);
	angles[1] = (0, -170, 0);
	at[1] = 2.3000;
	points[2] = (-4478.6221, 11299.2129, 2556.4409);
	angles[2] = (0, -170, 0);
	at[2] = 2.3500;
	points[3] = (-4478.6221, 11299.2129, 2659.3228);
	angles[3] = (0, -170, 0);
	at[3] = 2.4500;
	points[4] = (-4478.6221, 11299.2129, 2704.9802);
	angles[4] = (0, -170, 0);
	at[4] = 2.5000;
	points[5] = (-4478.6221, 11299.2129, 2784.7124);
	angles[5] = (0, -170, 0);
	at[5] = 2.6000;
	points[6] = (-4478.6221, 11299.2129, 2818.7913);
	angles[6] = (0, -170, 0);
	at[6] = 2.6500;
	points[7] = (-4478.6221, 11299.2129, 2875.3779);
	angles[7] = (0, -170, 0);
	at[7] = 2.7500;
	points[8] = (-4478.6221, 11299.2129, 2897.8860);
	angles[8] = (0, -170, 0);
	at[8] = 2.8000;
	points[9] = (-4478.6221, 11299.2129, 2931.3228);
	angles[9] = (0, -170, 0);
	at[9] = 2.9000;
	points[10] = (-4478.6221, 11299.2129, 2949.3269);
	angles[10] = (0, -170, 0);
	at[10] = 3;
	points[11] = (-4478.6221, 11299.2129, 2952.5432);
	angles[11] = (0, -170, 0);
	at[11] = 3.0500;
	points[12] = (-4478.6221, 11299.2129, 2965.5432);
	angles[12] = (0, -170, 0);
	at[12] = 3.1500;
	points[13] = (-4478.6221, 11299.2129, 2967.4370);
	angles[13] = (0, -170, 0);
	at[13] = 3.2000;
	points[14] = (-4478.6221, 11299.2129, 2963.7285);
	angles[14] = (0, -170, 0);
	at[14] = 3.2500;
	points[15] = (-4478.6221, 11299.2129, 2939.9685);
	angles[15] = (0, -170, 0);
	at[15] = 3.4000;
	points[16] = (-4478.6221, 11299.2129, 2938.0747);
	angles[16] = (0, -170, 0);
	at[16] = 3.4500;
	points[17] = (-4478.6221, 11299.2129, 2941.7834);
	angles[17] = (0, -170, 0);
	at[17] = 3.5000;
	points[18] = (-4478.6221, 11299.2129, 2965.5432);
	angles[18] = (0, -170, 0);
	at[18] = 3.6500;
	points[19] = (-4478.6221, 11299.2129, 2967.4370);
	angles[19] = (0, -170, 0);
	at[19] = 3.7000;
	points[20] = (-4478.6221, 11299.2129, 2963.7285);
	angles[20] = (0, -170, 0);
	at[20] = 3.7500;
	points[21] = (-4478.6221, 11299.2129, 2939.9685);
	angles[21] = (0, -170, 0);
	at[21] = 3.9000;
	points[22] = (-4478.6221, 11299.2129, 2938.0747);
	angles[22] = (0, -170, 0);
	at[22] = 3.9500;
	points[23] = (-4478.6221, 11299.2129, 2941.7834);
	angles[23] = (0, -170, 0);
	at[23] = 4;
	points[24] = (-4478.6221, 11299.2129, 2965.5432);
	angles[24] = (0, -170, 0);
	at[24] = 4.1500;
	points[25] = (-4478.6221, 11299.2129, 2967.4370);
	angles[25] = (0, -170, 0);
	at[25] = 4.2000;
	points[26] = (-4478.6221, 11299.2129, 2963.7285);
	angles[26] = (0, -170, 0);
	at[26] = 4.2500;
	points[27] = (-4478.6221, 11299.2129, 2949.6851);
	angles[27] = (0, -170, 0);
	at[27] = 4.3500;
	points[28] = (-4478.6221, 11299.2129, 2419.3464);
	angles[28] = (0, -170, 0);
	at[28] = 5.8500;
	points[29] = (-4478.6221, 11299.2129, 2410.6299);
	angles[29] = (0, -170, 0);
	at[29] = 5.9000;
	points[30] = (-4478.6221, 11299.2129, 2410.6299);
	angles[30] = (0, -170, 0);
	at[30] = 8.9500;
	points[31] = (-4478.6221, 11299.2129, 2499.2126);
	angles[31] = (0, -170, 0);
	at[31] = 9;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5132.2837, 11127.1260, 2410.6299);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-5132.2837, 11127.1260, 2410.6299);
	angles[1] = (0, -170, 0);
	at[1] = 0.6500;
	points[2] = (-5132.2837, 11127.1260, 2499.2126);
	angles[2] = (0, -170, 0);
	at[2] = 0.7000;
	points[3] = (-5132.2837, 11127.1260, 2499.2126);
	angles[3] = (0, -170, 0);
	at[3] = 2.9500;
	points[4] = (-5132.2837, 11127.1260, 2537.7952);
	angles[4] = (0, -170, 0);
	at[4] = 3;
	points[5] = (-5132.2837, 11127.1260, 2643.2478);
	angles[5] = (0, -170, 0);
	at[5] = 3.1000;
	points[6] = (-5132.2837, 11127.1260, 2733.2717);
	angles[6] = (0, -170, 0);
	at[6] = 3.2000;
	points[7] = (-5132.2837, 11127.1260, 2807.8623);
	angles[7] = (0, -170, 0);
	at[7] = 3.3000;
	points[8] = (-5132.2837, 11127.1260, 2867.0198);
	angles[8] = (0, -170, 0);
	at[8] = 3.4000;
	points[9] = (-5132.2837, 11127.1260, 2910.7441);
	angles[9] = (0, -170, 0);
	at[9] = 3.5000;
	points[10] = (-5132.2837, 11127.1260, 2939.0396);
	angles[10] = (0, -170, 0);
	at[10] = 3.6000;
	points[11] = (-5132.2837, 11127.1260, 2947.3977);
	angles[11] = (0, -170, 0);
	at[11] = 3.6500;
	points[12] = (-5132.2837, 11127.1260, 2967.4370);
	angles[12] = (0, -170, 0);
	at[12] = 3.8500;
	points[13] = (-5132.2837, 11127.1260, 2965.5432);
	angles[13] = (0, -170, 0);
	at[13] = 3.9000;
	points[14] = (-5132.2837, 11127.1260, 2941.7834);
	angles[14] = (0, -170, 0);
	at[14] = 4.0500;
	points[15] = (-5132.2837, 11127.1260, 2938.0747);
	angles[15] = (0, -170, 0);
	at[15] = 4.1000;
	points[16] = (-5132.2837, 11127.1260, 2939.9685);
	angles[16] = (0, -170, 0);
	at[16] = 4.1500;
	points[17] = (-5132.2837, 11127.1260, 2963.7285);
	angles[17] = (0, -170, 0);
	at[17] = 4.3000;
	points[18] = (-5132.2837, 11127.1260, 2967.4370);
	angles[18] = (0, -170, 0);
	at[18] = 4.3500;
	points[19] = (-5132.2837, 11127.1260, 2965.5432);
	angles[19] = (0, -170, 0);
	at[19] = 4.4000;
	points[20] = (-5132.2837, 11127.1260, 2941.7834);
	angles[20] = (0, -170, 0);
	at[20] = 4.5500;
	points[21] = (-5132.2837, 11127.1260, 2938.0747);
	angles[21] = (0, -170, 0);
	at[21] = 4.6000;
	points[22] = (-5132.2837, 11127.1260, 2939.9685);
	angles[22] = (0, -170, 0);
	at[22] = 4.6500;
	points[23] = (-5132.2837, 11127.1260, 2963.7285);
	angles[23] = (0, -170, 0);
	at[23] = 4.8000;
	points[24] = (-5132.2837, 11127.1260, 2967.4370);
	angles[24] = (0, -170, 0);
	at[24] = 4.8500;
	points[25] = (-5132.2837, 11127.1260, 2965.5432);
	angles[25] = (0, -170, 0);
	at[25] = 4.9000;
	points[26] = (-5132.2837, 11127.1260, 2949.6851);
	angles[26] = (0, -170, 0);
	at[26] = 5;
	points[27] = (-5132.2837, 11127.1260, 2937.9019);
	angles[27] = (0, -170, 0);
	at[27] = 5.0500;
	points[28] = (-5132.2837, 11127.1260, 2425.2363);
	angles[28] = (0, -170, 0);
	at[28] = 6.5000;
	points[29] = (-5132.2837, 11127.1260, 2410.6299);
	angles[29] = (0, -170, 0);
	at[29] = 6.5500;
	points[30] = (-5132.2837, 11127.1260, 2410.6299);
	angles[30] = (0, -170, 0);
	at[30] = 9;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4134.1343, 12076.1426, 2297.2441);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4134.1343, 12076.1426, 2297.2441);
	angles[1] = (0, -170, 0);
	at[1] = 1.3000;
	points[2] = (-4134.1343, 12076.1426, 2385.8267);
	angles[2] = (0, -170, 0);
	at[2] = 1.3500;
	points[3] = (-4134.1343, 12076.1426, 2385.8267);
	angles[3] = (0, -170, 0);
	at[3] = 3.6000;
	points[4] = (-4134.1343, 12076.1426, 2410.2087);
	angles[4] = (0, -170, 0);
	at[4] = 3.6500;
	points[5] = (-4134.1343, 12076.1426, 2480.1377);
	angles[5] = (0, -170, 0);
	at[5] = 3.7000;
	points[6] = (-4134.1343, 12076.1426, 2545.2402);
	angles[6] = (0, -170, 0);
	at[6] = 3.7500;
	points[7] = (-4134.1343, 12076.1426, 2605.5237);
	angles[7] = (0, -170, 0);
	at[7] = 3.8000;
	points[8] = (-4134.1343, 12076.1426, 2660.9841);
	angles[8] = (0, -170, 0);
	at[8] = 3.8500;
	points[9] = (-4134.1343, 12076.1426, 2711.6221);
	angles[9] = (0, -170, 0);
	at[9] = 3.9000;
	points[10] = (-4134.1343, 12076.1426, 2757.4370);
	angles[10] = (0, -170, 0);
	at[10] = 3.9500;
	points[11] = (-4134.1343, 12076.1426, 2798.4292);
	angles[11] = (0, -170, 0);
	at[11] = 4;
	points[12] = (-4134.1343, 12076.1426, 2834.6025);
	angles[12] = (0, -170, 0);
	at[12] = 4.0500;
	points[13] = (-4134.1343, 12076.1426, 2865.9487);
	angles[13] = (0, -170, 0);
	at[13] = 4.1000;
	points[14] = (-4134.1343, 12076.1426, 2892.4727);
	angles[14] = (0, -170, 0);
	at[14] = 4.1500;
	points[15] = (-4134.1343, 12076.1426, 2914.1731);
	angles[15] = (0, -170, 0);
	at[15] = 4.2000;
	points[16] = (-4134.1343, 12076.1426, 2931.0552);
	angles[16] = (0, -170, 0);
	at[16] = 4.2500;
	points[17] = (-4134.1343, 12076.1426, 2943.1101);
	angles[17] = (0, -170, 0);
	at[17] = 4.3000;
	points[18] = (-4134.1343, 12076.1426, 2950.3425);
	angles[18] = (0, -170, 0);
	at[18] = 4.3500;
	points[19] = (-4134.1343, 12076.1426, 2952.7559);
	angles[19] = (0, -170, 0);
	at[19] = 4.4000;
	points[20] = (-4134.1343, 12076.1426, 2966.7952);
	angles[20] = (0, -170, 0);
	at[20] = 4.5000;
	points[21] = (-4134.1343, 12076.1426, 2966.7952);
	angles[21] = (0, -170, 0);
	at[21] = 4.5500;
	points[22] = (-4134.1343, 12076.1426, 2961.4331);
	angles[22] = (0, -170, 0);
	at[22] = 4.6000;
	points[23] = (-4134.1343, 12076.1426, 2944.0789);
	angles[23] = (0, -170, 0);
	at[23] = 4.7000;
	points[24] = (-4134.1343, 12076.1426, 2938.7126);
	angles[24] = (0, -170, 0);
	at[24] = 4.7500;
	points[25] = (-4134.1343, 12076.1426, 2938.7126);
	angles[25] = (0, -170, 0);
	at[25] = 4.8000;
	points[26] = (-4134.1343, 12076.1426, 2944.0789);
	angles[26] = (0, -170, 0);
	at[26] = 4.8500;
	points[27] = (-4134.1343, 12076.1426, 2961.4331);
	angles[27] = (0, -170, 0);
	at[27] = 4.9500;
	points[28] = (-4134.1343, 12076.1426, 2966.7952);
	angles[28] = (0, -170, 0);
	at[28] = 5;
	points[29] = (-4134.1343, 12076.1426, 2966.7952);
	angles[29] = (0, -170, 0);
	at[29] = 5.0500;
	points[30] = (-4134.1343, 12076.1426, 2961.4331);
	angles[30] = (0, -170, 0);
	at[30] = 5.1000;
	points[31] = (-4134.1343, 12076.1426, 2944.0789);
	angles[31] = (0, -170, 0);
	at[31] = 5.2000;
	points[32] = (-4134.1343, 12076.1426, 2938.7126);
	angles[32] = (0, -170, 0);
	at[32] = 5.2500;
	points[33] = (-4134.1343, 12076.1426, 2938.7126);
	angles[33] = (0, -170, 0);
	at[33] = 5.3000;
	points[34] = (-4134.1343, 12076.1426, 2944.0789);
	angles[34] = (0, -170, 0);
	at[34] = 5.3500;
	points[35] = (-4134.1343, 12076.1426, 2961.4331);
	angles[35] = (0, -170, 0);
	at[35] = 5.4500;
	points[36] = (-4134.1343, 12076.1426, 2966.7952);
	angles[36] = (0, -170, 0);
	at[36] = 5.5000;
	points[37] = (-4134.1343, 12076.1426, 2966.7952);
	angles[37] = (0, -170, 0);
	at[37] = 5.5500;
	points[38] = (-4134.1343, 12076.1426, 2961.4331);
	angles[38] = (0, -170, 0);
	at[38] = 5.6000;
	points[39] = (-4134.1343, 12076.1426, 2942.5591);
	angles[39] = (0, -170, 0);
	at[39] = 5.7000;
	points[40] = (-4134.1343, 12076.1426, 2301.2993);
	angles[40] = (0, -170, 0);
	at[40] = 7.2000;
	points[41] = (-4134.1343, 12076.1426, 2297.2441);
	angles[41] = (0, -170, 0);
	at[41] = 7.2500;
	points[42] = (-4134.1343, 12076.1426, 2297.2441);
	angles[42] = (0, -170, 0);
	at[42] = 9;
	mover = getEnt("iz_obj_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4930.9844, 11893.2285, 2410.6299);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4930.9844, 11893.2285, 2410.6299);
	angles[1] = (0, -170, 0);
	at[1] = 1.9500;
	points[2] = (-4930.9844, 11893.2285, 2499.2126);
	angles[2] = (0, -170, 0);
	at[2] = 2;
	points[3] = (-4930.9844, 11893.2285, 2499.2126);
	angles[3] = (0, -170, 0);
	at[3] = 4.3000;
	points[4] = (-4930.9844, 11893.2285, 2609.8110);
	angles[4] = (0, -170, 0);
	at[4] = 4.4000;
	points[5] = (-4930.9844, 11893.2285, 2704.9802);
	angles[5] = (0, -170, 0);
	at[5] = 4.5000;
	points[6] = (-4930.9844, 11893.2285, 2784.7124);
	angles[6] = (0, -170, 0);
	at[6] = 4.6000;
	points[7] = (-4930.9844, 11893.2285, 2818.7913);
	angles[7] = (0, -170, 0);
	at[7] = 4.6500;
	points[8] = (-4930.9844, 11893.2285, 2875.3779);
	angles[8] = (0, -170, 0);
	at[8] = 4.7500;
	points[9] = (-4930.9844, 11893.2285, 2916.5317);
	angles[9] = (0, -170, 0);
	at[9] = 4.8500;
	points[10] = (-4930.9844, 11893.2285, 2942.2520);
	angles[10] = (0, -170, 0);
	at[10] = 4.9500;
	points[11] = (-4930.9844, 11893.2285, 2965.5432);
	angles[11] = (0, -170, 0);
	at[11] = 5.1500;
	points[12] = (-4930.9844, 11893.2285, 2967.4370);
	angles[12] = (0, -170, 0);
	at[12] = 5.2000;
	points[13] = (-4930.9844, 11893.2285, 2963.7285);
	angles[13] = (0, -170, 0);
	at[13] = 5.2500;
	points[14] = (-4930.9844, 11893.2285, 2939.9685);
	angles[14] = (0, -170, 0);
	at[14] = 5.4000;
	points[15] = (-4930.9844, 11893.2285, 2938.0747);
	angles[15] = (0, -170, 0);
	at[15] = 5.4500;
	points[16] = (-4930.9844, 11893.2285, 2941.7834);
	angles[16] = (0, -170, 0);
	at[16] = 5.5000;
	points[17] = (-4930.9844, 11893.2285, 2965.5432);
	angles[17] = (0, -170, 0);
	at[17] = 5.6500;
	points[18] = (-4930.9844, 11893.2285, 2967.4370);
	angles[18] = (0, -170, 0);
	at[18] = 5.7000;
	points[19] = (-4930.9844, 11893.2285, 2963.7285);
	angles[19] = (0, -170, 0);
	at[19] = 5.7500;
	points[20] = (-4930.9844, 11893.2285, 2939.9685);
	angles[20] = (0, -170, 0);
	at[20] = 5.9000;
	points[21] = (-4930.9844, 11893.2285, 2938.0747);
	angles[21] = (0, -170, 0);
	at[21] = 5.9500;
	points[22] = (-4930.9844, 11893.2285, 2941.7834);
	angles[22] = (0, -170, 0);
	at[22] = 6;
	points[23] = (-4930.9844, 11893.2285, 2965.5432);
	angles[23] = (0, -170, 0);
	at[23] = 6.1500;
	points[24] = (-4930.9844, 11893.2285, 2967.4370);
	angles[24] = (0, -170, 0);
	at[24] = 6.2000;
	points[25] = (-4930.9844, 11893.2285, 2963.7285);
	angles[25] = (0, -170, 0);
	at[25] = 6.2500;
	points[26] = (-4930.9844, 11893.2285, 2949.6851);
	angles[26] = (0, -170, 0);
	at[26] = 6.3500;
	points[27] = (-4930.9844, 11893.2285, 2419.3464);
	angles[27] = (0, -170, 0);
	at[27] = 7.8500;
	points[28] = (-4930.9844, 11893.2285, 2410.6299);
	angles[28] = (0, -170, 0);
	at[28] = 7.9000;
	points[29] = (-4930.9844, 11893.2285, 2410.6299);
	angles[29] = (0, -170, 0);
	at[29] = 9;
	mover = getEnt("iz_obj_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5672.3228, 11710.2764, 2297.2441);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-5672.3228, 11710.2764, 2297.2441);
	angles[1] = (0, -170, 0);
	at[1] = 2.6500;
	points[2] = (-5672.3228, 11710.2764, 2385.8267);
	angles[2] = (0, -170, 0);
	at[2] = 2.7000;
	points[3] = (-5672.3228, 11710.2764, 2385.8267);
	angles[3] = (0, -170, 0);
	at[3] = 4.9500;
	points[4] = (-5672.3228, 11710.2764, 2434.0513);
	angles[4] = (0, -170, 0);
	at[4] = 5;
	points[5] = (-5672.3228, 11710.2764, 2502.3740);
	angles[5] = (0, -170, 0);
	at[5] = 5.0500;
	points[6] = (-5672.3228, 11710.2764, 2565.8704);
	angles[6] = (0, -170, 0);
	at[6] = 5.1000;
	points[7] = (-5672.3228, 11710.2764, 2624.5471);
	angles[7] = (0, -170, 0);
	at[7] = 5.1500;
	points[8] = (-5672.3228, 11710.2764, 2678.4016);
	angles[8] = (0, -170, 0);
	at[8] = 5.2000;
	points[9] = (-5672.3228, 11710.2764, 2727.4292);
	angles[9] = (0, -170, 0);
	at[9] = 5.2500;
	points[10] = (-5672.3228, 11710.2764, 2771.6377);
	angles[10] = (0, -170, 0);
	at[10] = 5.3000;
	points[11] = (-5672.3228, 11710.2764, 2811.0237);
	angles[11] = (0, -170, 0);
	at[11] = 5.3500;
	points[12] = (-5672.3228, 11710.2764, 2845.5867);
	angles[12] = (0, -170, 0);
	at[12] = 5.4000;
	points[13] = (-5672.3228, 11710.2764, 2875.3269);
	angles[13] = (0, -170, 0);
	at[13] = 5.4500;
	points[14] = (-5672.3228, 11710.2764, 2900.2441);
	angles[14] = (0, -170, 0);
	at[14] = 5.5000;
	points[15] = (-5672.3228, 11710.2764, 2920.3386);
	angles[15] = (0, -170, 0);
	at[15] = 5.5500;
	points[16] = (-5672.3228, 11710.2764, 2935.6064);
	angles[16] = (0, -170, 0);
	at[16] = 5.6000;
	points[17] = (-5672.3228, 11710.2764, 2946.0591);
	angles[17] = (0, -170, 0);
	at[17] = 5.6500;
	points[18] = (-5672.3228, 11710.2764, 2967.4370);
	angles[18] = (0, -170, 0);
	at[18] = 5.8500;
	points[19] = (-5672.3228, 11710.2764, 2965.5432);
	angles[19] = (0, -170, 0);
	at[19] = 5.9000;
	points[20] = (-5672.3228, 11710.2764, 2941.7834);
	angles[20] = (0, -170, 0);
	at[20] = 6.0500;
	points[21] = (-5672.3228, 11710.2764, 2938.0747);
	angles[21] = (0, -170, 0);
	at[21] = 6.1000;
	points[22] = (-5672.3228, 11710.2764, 2939.9685);
	angles[22] = (0, -170, 0);
	at[22] = 6.1500;
	points[23] = (-5672.3228, 11710.2764, 2963.7285);
	angles[23] = (0, -170, 0);
	at[23] = 6.3000;
	points[24] = (-5672.3228, 11710.2764, 2967.4370);
	angles[24] = (0, -170, 0);
	at[24] = 6.3500;
	points[25] = (-5672.3228, 11710.2764, 2965.5432);
	angles[25] = (0, -170, 0);
	at[25] = 6.4000;
	points[26] = (-5672.3228, 11710.2764, 2941.7834);
	angles[26] = (0, -170, 0);
	at[26] = 6.5500;
	points[27] = (-5672.3228, 11710.2764, 2938.0747);
	angles[27] = (0, -170, 0);
	at[27] = 6.6000;
	points[28] = (-5672.3228, 11710.2764, 2939.9685);
	angles[28] = (0, -170, 0);
	at[28] = 6.6500;
	points[29] = (-5672.3228, 11710.2764, 2963.7285);
	angles[29] = (0, -170, 0);
	at[29] = 6.8000;
	points[30] = (-5672.3228, 11710.2764, 2967.4370);
	angles[30] = (0, -170, 0);
	at[30] = 6.8500;
	points[31] = (-5672.3228, 11710.2764, 2965.5432);
	angles[31] = (0, -170, 0);
	at[31] = 6.9000;
	points[32] = (-5672.3228, 11710.2764, 2949.6851);
	angles[32] = (0, -170, 0);
	at[32] = 7;
	points[33] = (-5672.3228, 11710.2764, 2935.4370);
	angles[33] = (0, -170, 0);
	at[33] = 7.0500;
	points[34] = (-5672.3228, 11710.2764, 2315.5513);
	angles[34] = (0, -170, 0);
	at[34] = 8.5000;
	points[35] = (-5672.3228, 11710.2764, 2297.2441);
	angles[35] = (0, -170, 0);
	at[35] = 8.5500;
	points[36] = (-5672.3228, 11710.2764, 2297.2441);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_22", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_23()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4654.4487, 12622.2832, 2484.1655);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4654.4487, 12622.2832, 2413.4529);
	angles[1] = (0, -170, 0);
	at[1] = 0.2000;
	points[2] = (-4654.4487, 12622.2832, 2410.6299);
	angles[2] = (0, -170, 0);
	at[2] = 0.2500;
	points[3] = (-4654.4487, 12622.2832, 2410.6299);
	angles[3] = (0, -170, 0);
	at[3] = 3.3000;
	points[4] = (-4654.4487, 12622.2832, 2499.2126);
	angles[4] = (0, -170, 0);
	at[4] = 3.3500;
	points[5] = (-4654.4487, 12622.2832, 2499.2126);
	angles[5] = (0, -170, 0);
	at[5] = 5.6000;
	points[6] = (-4654.4487, 12622.2832, 2518.7166);
	angles[6] = (0, -170, 0);
	at[6] = 5.6500;
	points[7] = (-4654.4487, 12622.2832, 2626.7441);
	angles[7] = (0, -170, 0);
	at[7] = 5.7500;
	points[8] = (-4654.4487, 12622.2832, 2674.9724);
	angles[8] = (0, -170, 0);
	at[8] = 5.8000;
	points[9] = (-4654.4487, 12622.2832, 2759.8503);
	angles[9] = (0, -170, 0);
	at[9] = 5.9000;
	points[10] = (-4654.4487, 12622.2832, 2829.2952);
	angles[10] = (0, -170, 0);
	at[10] = 6;
	points[11] = (-4654.4487, 12622.2832, 2858.2322);
	angles[11] = (0, -170, 0);
	at[11] = 6.0500;
	points[12] = (-4654.4487, 12622.2832, 2904.5276);
	angles[12] = (0, -170, 0);
	at[12] = 6.1500;
	points[13] = (-4654.4487, 12622.2832, 2935.3936);
	angles[13] = (0, -170, 0);
	at[13] = 6.2500;
	points[14] = (-4654.4487, 12622.2832, 2945.0396);
	angles[14] = (0, -170, 0);
	at[14] = 6.3000;
	points[15] = (-4654.4487, 12622.2832, 2952.7559);
	angles[15] = (0, -170, 0);
	at[15] = 6.4000;
	points[16] = (-4654.4487, 12622.2832, 2966.7952);
	angles[16] = (0, -170, 0);
	at[16] = 6.5000;
	points[17] = (-4654.4487, 12622.2832, 2966.7952);
	angles[17] = (0, -170, 0);
	at[17] = 6.5500;
	points[18] = (-4654.4487, 12622.2832, 2961.4331);
	angles[18] = (0, -170, 0);
	at[18] = 6.6000;
	points[19] = (-4654.4487, 12622.2832, 2944.0789);
	angles[19] = (0, -170, 0);
	at[19] = 6.7000;
	points[20] = (-4654.4487, 12622.2832, 2938.7126);
	angles[20] = (0, -170, 0);
	at[20] = 6.7500;
	points[21] = (-4654.4487, 12622.2832, 2938.7126);
	angles[21] = (0, -170, 0);
	at[21] = 6.8000;
	points[22] = (-4654.4487, 12622.2832, 2944.0789);
	angles[22] = (0, -170, 0);
	at[22] = 6.8500;
	points[23] = (-4654.4487, 12622.2832, 2961.4331);
	angles[23] = (0, -170, 0);
	at[23] = 6.9500;
	points[24] = (-4654.4487, 12622.2832, 2966.7952);
	angles[24] = (0, -170, 0);
	at[24] = 7;
	points[25] = (-4654.4487, 12622.2832, 2966.7952);
	angles[25] = (0, -170, 0);
	at[25] = 7.0500;
	points[26] = (-4654.4487, 12622.2832, 2961.4331);
	angles[26] = (0, -170, 0);
	at[26] = 7.1000;
	points[27] = (-4654.4487, 12622.2832, 2944.0789);
	angles[27] = (0, -170, 0);
	at[27] = 7.2000;
	points[28] = (-4654.4487, 12622.2832, 2938.7126);
	angles[28] = (0, -170, 0);
	at[28] = 7.2500;
	points[29] = (-4654.4487, 12622.2832, 2938.7126);
	angles[29] = (0, -170, 0);
	at[29] = 7.3000;
	points[30] = (-4654.4487, 12622.2832, 2944.0789);
	angles[30] = (0, -170, 0);
	at[30] = 7.3500;
	points[31] = (-4654.4487, 12622.2832, 2961.4331);
	angles[31] = (0, -170, 0);
	at[31] = 7.4500;
	points[32] = (-4654.4487, 12622.2832, 2966.7952);
	angles[32] = (0, -170, 0);
	at[32] = 7.5000;
	points[33] = (-4654.4487, 12622.2832, 2966.7952);
	angles[33] = (0, -170, 0);
	at[33] = 7.5500;
	points[34] = (-4654.4487, 12622.2832, 2961.4331);
	angles[34] = (0, -170, 0);
	at[34] = 7.6000;
	points[35] = (-4654.4487, 12622.2832, 2943.7915);
	angles[35] = (0, -170, 0);
	at[35] = 7.7000;
	points[36] = (-4654.4487, 12622.2832, 2484.1655);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_23", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_24()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5403.6221, 12457.5195, 2719.8701);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-5403.6221, 12457.5195, 2419.3464);
	angles[1] = (0, -170, 0);
	at[1] = 0.8500;
	points[2] = (-5403.6221, 12457.5195, 2410.6299);
	angles[2] = (0, -170, 0);
	at[2] = 0.9000;
	points[3] = (-5403.6221, 12457.5195, 2410.6299);
	angles[3] = (0, -170, 0);
	at[3] = 3.9500;
	points[4] = (-5403.6221, 12457.5195, 2499.2126);
	angles[4] = (0, -170, 0);
	at[4] = 4;
	points[5] = (-5403.6221, 12457.5195, 2499.2126);
	angles[5] = (0, -170, 0);
	at[5] = 6.3000;
	points[6] = (-5403.6221, 12457.5195, 2609.8110);
	angles[6] = (0, -170, 0);
	at[6] = 6.4000;
	points[7] = (-5403.6221, 12457.5195, 2704.9802);
	angles[7] = (0, -170, 0);
	at[7] = 6.5000;
	points[8] = (-5403.6221, 12457.5195, 2784.7124);
	angles[8] = (0, -170, 0);
	at[8] = 6.6000;
	points[9] = (-5403.6221, 12457.5195, 2849.0156);
	angles[9] = (0, -170, 0);
	at[9] = 6.7000;
	points[10] = (-5403.6221, 12457.5195, 2897.8860);
	angles[10] = (0, -170, 0);
	at[10] = 6.8000;
	points[11] = (-5403.6221, 12457.5195, 2931.3228);
	angles[11] = (0, -170, 0);
	at[11] = 6.9000;
	points[12] = (-5403.6221, 12457.5195, 2949.3269);
	angles[12] = (0, -170, 0);
	at[12] = 7;
	points[13] = (-5403.6221, 12457.5195, 2952.5432);
	angles[13] = (0, -170, 0);
	at[13] = 7.0500;
	points[14] = (-5403.6221, 12457.5195, 2965.5432);
	angles[14] = (0, -170, 0);
	at[14] = 7.1500;
	points[15] = (-5403.6221, 12457.5195, 2967.4370);
	angles[15] = (0, -170, 0);
	at[15] = 7.2000;
	points[16] = (-5403.6221, 12457.5195, 2963.7285);
	angles[16] = (0, -170, 0);
	at[16] = 7.2500;
	points[17] = (-5403.6221, 12457.5195, 2939.9685);
	angles[17] = (0, -170, 0);
	at[17] = 7.4000;
	points[18] = (-5403.6221, 12457.5195, 2938.0747);
	angles[18] = (0, -170, 0);
	at[18] = 7.4500;
	points[19] = (-5403.6221, 12457.5195, 2941.7834);
	angles[19] = (0, -170, 0);
	at[19] = 7.5000;
	points[20] = (-5403.6221, 12457.5195, 2965.5432);
	angles[20] = (0, -170, 0);
	at[20] = 7.6500;
	points[21] = (-5403.6221, 12457.5195, 2967.4370);
	angles[21] = (0, -170, 0);
	at[21] = 7.7000;
	points[22] = (-5403.6221, 12457.5195, 2963.7285);
	angles[22] = (0, -170, 0);
	at[22] = 7.7500;
	points[23] = (-5403.6221, 12457.5195, 2939.9685);
	angles[23] = (0, -170, 0);
	at[23] = 7.9000;
	points[24] = (-5403.6221, 12457.5195, 2938.0747);
	angles[24] = (0, -170, 0);
	at[24] = 7.9500;
	points[25] = (-5403.6221, 12457.5195, 2941.7834);
	angles[25] = (0, -170, 0);
	at[25] = 8;
	points[26] = (-5403.6221, 12457.5195, 2965.5432);
	angles[26] = (0, -170, 0);
	at[26] = 8.1500;
	points[27] = (-5403.6221, 12457.5195, 2967.4370);
	angles[27] = (0, -170, 0);
	at[27] = 8.2000;
	points[28] = (-5403.6221, 12457.5195, 2963.7285);
	angles[28] = (0, -170, 0);
	at[28] = 8.2500;
	points[29] = (-5403.6221, 12457.5195, 2949.6851);
	angles[29] = (0, -170, 0);
	at[29] = 8.3500;
	points[30] = (-5403.6221, 12457.5195, 2719.8701);
	angles[30] = (0, -170, 0);
	at[30] = 9;
	mover = getEnt("iz_obj_24", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_25()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4414.0156, 13350.6689, 2949.7402);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4414.0156, 13350.6689, 2937.9568);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (-4414.0156, 13350.6689, 2425.2915);
	angles[2] = (0, -170, 0);
	at[2] = 1.5000;
	points[3] = (-4414.0156, 13350.6689, 2410.6851);
	angles[3] = (0, -170, 0);
	at[3] = 1.5500;
	points[4] = (-4414.0156, 13350.6689, 2410.6851);
	angles[4] = (0, -170, 0);
	at[4] = 4.6500;
	points[5] = (-4414.0156, 13350.6689, 2499.2678);
	angles[5] = (0, -170, 0);
	at[5] = 4.7000;
	points[6] = (-4414.0156, 13350.6689, 2499.2678);
	angles[6] = (0, -170, 0);
	at[6] = 6.9500;
	points[7] = (-4414.0156, 13350.6689, 2537.8467);
	angles[7] = (0, -170, 0);
	at[7] = 7;
	points[8] = (-4414.0156, 13350.6689, 2592.5042);
	angles[8] = (0, -170, 0);
	at[8] = 7.0500;
	points[9] = (-4414.0156, 13350.6689, 2690.2441);
	angles[9] = (0, -170, 0);
	at[9] = 7.1500;
	points[10] = (-4414.0156, 13350.6689, 2733.3267);
	angles[10] = (0, -170, 0);
	at[10] = 7.2000;
	points[11] = (-4414.0156, 13350.6689, 2807.9172);
	angles[11] = (0, -170, 0);
	at[11] = 7.3000;
	points[12] = (-4414.0156, 13350.6689, 2839.4253);
	angles[12] = (0, -170, 0);
	at[12] = 7.3500;
	points[13] = (-4414.0156, 13350.6689, 2890.8662);
	angles[13] = (0, -170, 0);
	at[13] = 7.4500;
	points[14] = (-4414.0156, 13350.6689, 2910.7993);
	angles[14] = (0, -170, 0);
	at[14] = 7.5000;
	points[15] = (-4414.0156, 13350.6689, 2939.0906);
	angles[15] = (0, -170, 0);
	at[15] = 7.6000;
	points[16] = (-4414.0156, 13350.6689, 2947.4529);
	angles[16] = (0, -170, 0);
	at[16] = 7.6500;
	points[17] = (-4414.0156, 13350.6689, 2967.4922);
	angles[17] = (0, -170, 0);
	at[17] = 7.8500;
	points[18] = (-4414.0156, 13350.6689, 2965.5947);
	angles[18] = (0, -170, 0);
	at[18] = 7.9000;
	points[19] = (-4414.0156, 13350.6689, 2941.8386);
	angles[19] = (0, -170, 0);
	at[19] = 8.0500;
	points[20] = (-4414.0156, 13350.6689, 2938.1262);
	angles[20] = (0, -170, 0);
	at[20] = 8.1000;
	points[21] = (-4414.0156, 13350.6689, 2940.0237);
	angles[21] = (0, -170, 0);
	at[21] = 8.1500;
	points[22] = (-4414.0156, 13350.6689, 2963.7834);
	angles[22] = (0, -170, 0);
	at[22] = 8.3000;
	points[23] = (-4414.0156, 13350.6689, 2967.4922);
	angles[23] = (0, -170, 0);
	at[23] = 8.3500;
	points[24] = (-4414.0156, 13350.6689, 2965.5947);
	angles[24] = (0, -170, 0);
	at[24] = 8.4000;
	points[25] = (-4414.0156, 13350.6689, 2941.8386);
	angles[25] = (0, -170, 0);
	at[25] = 8.5500;
	points[26] = (-4414.0156, 13350.6689, 2938.1262);
	angles[26] = (0, -170, 0);
	at[26] = 8.6000;
	points[27] = (-4414.0156, 13350.6689, 2940.0237);
	angles[27] = (0, -170, 0);
	at[27] = 8.6500;
	points[28] = (-4414.0156, 13350.6689, 2963.7834);
	angles[28] = (0, -170, 0);
	at[28] = 8.8000;
	points[29] = (-4414.0156, 13350.6689, 2967.4922);
	angles[29] = (0, -170, 0);
	at[29] = 8.8500;
	points[30] = (-4414.0156, 13350.6689, 2965.5947);
	angles[30] = (0, -170, 0);
	at[30] = 8.9000;
	points[31] = (-4414.0156, 13350.6689, 2949.7402);
	angles[31] = (0, -170, 0);
	at[31] = 9;
	mover = getEnt("iz_obj_25", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_26()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5176.1816, 13264.8428, 2966.8306);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-5176.1816, 13264.8428, 2966.8306);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (-5176.1816, 13264.8428, 2961.4685);
	angles[2] = (0, -170, 0);
	at[2] = 0.1000;
	points[3] = (-5176.1816, 13264.8428, 2944.1104);
	angles[3] = (0, -170, 0);
	at[3] = 0.2000;
	points[4] = (-5176.1816, 13264.8428, 2938.7483);
	angles[4] = (0, -170, 0);
	at[4] = 0.2500;
	points[5] = (-5176.1816, 13264.8428, 2938.7483);
	angles[5] = (0, -170, 0);
	at[5] = 0.3000;
	points[6] = (-5176.1816, 13264.8428, 2944.1104);
	angles[6] = (0, -170, 0);
	at[6] = 0.3500;
	points[7] = (-5176.1816, 13264.8428, 2961.4685);
	angles[7] = (0, -170, 0);
	at[7] = 0.4500;
	points[8] = (-5176.1816, 13264.8428, 2966.8306);
	angles[8] = (0, -170, 0);
	at[8] = 0.5000;
	points[9] = (-5176.1816, 13264.8428, 2966.8306);
	angles[9] = (0, -170, 0);
	at[9] = 0.5500;
	points[10] = (-5176.1816, 13264.8428, 2961.4685);
	angles[10] = (0, -170, 0);
	at[10] = 0.6000;
	points[11] = (-5176.1816, 13264.8428, 2942.5945);
	angles[11] = (0, -170, 0);
	at[11] = 0.7000;
	points[12] = (-5176.1816, 13264.8428, 2301.3347);
	angles[12] = (0, -170, 0);
	at[12] = 2.2000;
	points[13] = (-5176.1816, 13264.8428, 2297.2795);
	angles[13] = (0, -170, 0);
	at[13] = 2.2500;
	points[14] = (-5176.1816, 13264.8428, 2297.2795);
	angles[14] = (0, -170, 0);
	at[14] = 5.3000;
	points[15] = (-5176.1816, 13264.8428, 2385.8623);
	angles[15] = (0, -170, 0);
	at[15] = 5.3500;
	points[16] = (-5176.1816, 13264.8428, 2385.8623);
	angles[16] = (0, -170, 0);
	at[16] = 7.6000;
	points[17] = (-5176.1816, 13264.8428, 2410.2402);
	angles[17] = (0, -170, 0);
	at[17] = 7.6500;
	points[18] = (-5176.1816, 13264.8428, 2480.1692);
	angles[18] = (0, -170, 0);
	at[18] = 7.7000;
	points[19] = (-5176.1816, 13264.8428, 2545.2756);
	angles[19] = (0, -170, 0);
	at[19] = 7.7500;
	points[20] = (-5176.1816, 13264.8428, 2605.5591);
	angles[20] = (0, -170, 0);
	at[20] = 7.8000;
	points[21] = (-5176.1816, 13264.8428, 2661.0195);
	angles[21] = (0, -170, 0);
	at[21] = 7.8500;
	points[22] = (-5176.1816, 13264.8428, 2711.6575);
	angles[22] = (0, -170, 0);
	at[22] = 7.9000;
	points[23] = (-5176.1816, 13264.8428, 2757.4727);
	angles[23] = (0, -170, 0);
	at[23] = 7.9500;
	points[24] = (-5176.1816, 13264.8428, 2798.4646);
	angles[24] = (0, -170, 0);
	at[24] = 8;
	points[25] = (-5176.1816, 13264.8428, 2834.6340);
	angles[25] = (0, -170, 0);
	at[25] = 8.0500;
	points[26] = (-5176.1816, 13264.8428, 2865.9841);
	angles[26] = (0, -170, 0);
	at[26] = 8.1000;
	points[27] = (-5176.1816, 13264.8428, 2892.5081);
	angles[27] = (0, -170, 0);
	at[27] = 8.1500;
	points[28] = (-5176.1816, 13264.8428, 2914.2085);
	angles[28] = (0, -170, 0);
	at[28] = 8.2000;
	points[29] = (-5176.1816, 13264.8428, 2931.0867);
	angles[29] = (0, -170, 0);
	at[29] = 8.2500;
	points[30] = (-5176.1816, 13264.8428, 2943.1455);
	angles[30] = (0, -170, 0);
	at[30] = 8.3000;
	points[31] = (-5176.1816, 13264.8428, 2950.3779);
	angles[31] = (0, -170, 0);
	at[31] = 8.3500;
	points[32] = (-5176.1816, 13264.8428, 2952.7915);
	angles[32] = (0, -170, 0);
	at[32] = 8.4000;
	points[33] = (-5176.1816, 13264.8428, 2966.8306);
	angles[33] = (0, -170, 0);
	at[33] = 8.5000;
	points[34] = (-5176.1816, 13264.8428, 2966.8306);
	angles[34] = (0, -170, 0);
	at[34] = 8.5500;
	points[35] = (-5176.1816, 13264.8428, 2961.4685);
	angles[35] = (0, -170, 0);
	at[35] = 8.6000;
	points[36] = (-5176.1816, 13264.8428, 2944.1104);
	angles[36] = (0, -170, 0);
	at[36] = 8.7000;
	points[37] = (-5176.1816, 13264.8428, 2938.7483);
	angles[37] = (0, -170, 0);
	at[37] = 8.7500;
	points[38] = (-5176.1816, 13264.8428, 2938.7483);
	angles[38] = (0, -170, 0);
	at[38] = 8.8000;
	points[39] = (-5176.1816, 13264.8428, 2944.1104);
	angles[39] = (0, -170, 0);
	at[39] = 8.8500;
	points[40] = (-5176.1816, 13264.8428, 2961.4685);
	angles[40] = (0, -170, 0);
	at[40] = 8.9500;
	points[41] = (-5176.1816, 13264.8428, 2966.8306);
	angles[41] = (0, -170, 0);
	at[41] = 9;
	mover = getEnt("iz_obj_26", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_27()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4290.2754, 14079.0557, 2949.4883);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-4290.2754, 14079.0557, 2952.7048);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (-4290.2754, 14079.0557, 2965.7048);
	angles[2] = (0, -170, 0);
	at[2] = 0.1500;
	points[3] = (-4290.2754, 14079.0557, 2967.6023);
	angles[3] = (0, -170, 0);
	at[3] = 0.2000;
	points[4] = (-4290.2754, 14079.0557, 2963.8896);
	angles[4] = (0, -170, 0);
	at[4] = 0.2500;
	points[5] = (-4290.2754, 14079.0557, 2940.1338);
	angles[5] = (0, -170, 0);
	at[5] = 0.4000;
	points[6] = (-4290.2754, 14079.0557, 2938.2363);
	angles[6] = (0, -170, 0);
	at[6] = 0.4500;
	points[7] = (-4290.2754, 14079.0557, 2941.9451);
	angles[7] = (0, -170, 0);
	at[7] = 0.5000;
	points[8] = (-4290.2754, 14079.0557, 2965.7048);
	angles[8] = (0, -170, 0);
	at[8] = 0.6500;
	points[9] = (-4290.2754, 14079.0557, 2967.6023);
	angles[9] = (0, -170, 0);
	at[9] = 0.7000;
	points[10] = (-4290.2754, 14079.0557, 2963.8896);
	angles[10] = (0, -170, 0);
	at[10] = 0.7500;
	points[11] = (-4290.2754, 14079.0557, 2940.1338);
	angles[11] = (0, -170, 0);
	at[11] = 0.9000;
	points[12] = (-4290.2754, 14079.0557, 2938.2363);
	angles[12] = (0, -170, 0);
	at[12] = 0.9500;
	points[13] = (-4290.2754, 14079.0557, 2941.9451);
	angles[13] = (0, -170, 0);
	at[13] = 1;
	points[14] = (-4290.2754, 14079.0557, 2965.7048);
	angles[14] = (0, -170, 0);
	at[14] = 1.1500;
	points[15] = (-4290.2754, 14079.0557, 2967.6023);
	angles[15] = (0, -170, 0);
	at[15] = 1.2000;
	points[16] = (-4290.2754, 14079.0557, 2963.8896);
	angles[16] = (0, -170, 0);
	at[16] = 1.2500;
	points[17] = (-4290.2754, 14079.0557, 2949.8503);
	angles[17] = (0, -170, 0);
	at[17] = 1.3500;
	points[18] = (-4290.2754, 14079.0557, 2419.5081);
	angles[18] = (0, -170, 0);
	at[18] = 2.8500;
	points[19] = (-4290.2754, 14079.0557, 2410.7913);
	angles[19] = (0, -170, 0);
	at[19] = 2.9000;
	points[20] = (-4290.2754, 14079.0557, 2410.7913);
	angles[20] = (0, -170, 0);
	at[20] = 5.9500;
	points[21] = (-4290.2754, 14079.0557, 2499.3740);
	angles[21] = (0, -170, 0);
	at[21] = 6;
	points[22] = (-4290.2754, 14079.0557, 2499.3740);
	angles[22] = (0, -170, 0);
	at[22] = 8.3000;
	points[23] = (-4290.2754, 14079.0557, 2556.6023);
	angles[23] = (0, -170, 0);
	at[23] = 8.3500;
	points[24] = (-4290.2754, 14079.0557, 2659.4883);
	angles[24] = (0, -170, 0);
	at[24] = 8.4500;
	points[25] = (-4290.2754, 14079.0557, 2746.9370);
	angles[25] = (0, -170, 0);
	at[25] = 8.5500;
	points[26] = (-4290.2754, 14079.0557, 2818.9568);
	angles[26] = (0, -170, 0);
	at[26] = 8.6500;
	points[27] = (-4290.2754, 14079.0557, 2875.5435);
	angles[27] = (0, -170, 0);
	at[27] = 8.7500;
	points[28] = (-4290.2754, 14079.0557, 2898.0471);
	angles[28] = (0, -170, 0);
	at[28] = 8.8000;
	points[29] = (-4290.2754, 14079.0557, 2931.4844);
	angles[29] = (0, -170, 0);
	at[29] = 8.9000;
	points[30] = (-4290.2754, 14079.0557, 2949.4883);
	angles[30] = (0, -170, 0);
	at[30] = 9;
	mover = getEnt("iz_obj_27", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_28()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5567.0869, 13962.0088, 2499.2600);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-5567.0869, 13962.0088, 2499.2600);
	angles[1] = (0, -170, 0);
	at[1] = 0.6000;
	points[2] = (-5567.0869, 13962.0088, 2518.7639);
	angles[2] = (0, -170, 0);
	at[2] = 0.6500;
	points[3] = (-5567.0869, 13962.0088, 2574.7087);
	angles[3] = (0, -170, 0);
	at[3] = 0.7000;
	points[4] = (-5567.0869, 13962.0088, 2675.0198);
	angles[4] = (0, -170, 0);
	at[4] = 0.8000;
	points[5] = (-5567.0869, 13962.0088, 2759.8977);
	angles[5] = (0, -170, 0);
	at[5] = 0.9000;
	points[6] = (-5567.0869, 13962.0088, 2829.3428);
	angles[6] = (0, -170, 0);
	at[6] = 1;
	points[7] = (-5567.0869, 13962.0088, 2883.3582);
	angles[7] = (0, -170, 0);
	at[7] = 1.1000;
	points[8] = (-5567.0869, 13962.0088, 2921.9370);
	angles[8] = (0, -170, 0);
	at[8] = 1.2000;
	points[9] = (-5567.0869, 13962.0088, 2945.0867);
	angles[9] = (0, -170, 0);
	at[9] = 1.3000;
	points[10] = (-5567.0869, 13962.0088, 2952.8030);
	angles[10] = (0, -170, 0);
	at[10] = 1.4000;
	points[11] = (-5567.0869, 13962.0088, 2966.8428);
	angles[11] = (0, -170, 0);
	at[11] = 1.5000;
	points[12] = (-5567.0869, 13962.0088, 2966.8428);
	angles[12] = (0, -170, 0);
	at[12] = 1.5500;
	points[13] = (-5567.0869, 13962.0088, 2938.7600);
	angles[13] = (0, -170, 0);
	at[13] = 1.7500;
	points[14] = (-5567.0869, 13962.0088, 2938.7600);
	angles[14] = (0, -170, 0);
	at[14] = 1.8000;
	points[15] = (-5567.0869, 13962.0088, 2944.1260);
	angles[15] = (0, -170, 0);
	at[15] = 1.8500;
	points[16] = (-5567.0869, 13962.0088, 2961.4805);
	angles[16] = (0, -170, 0);
	at[16] = 1.9500;
	points[17] = (-5567.0869, 13962.0088, 2966.8428);
	angles[17] = (0, -170, 0);
	at[17] = 2;
	points[18] = (-5567.0869, 13962.0088, 2966.8428);
	angles[18] = (0, -170, 0);
	at[18] = 2.0500;
	points[19] = (-5567.0869, 13962.0088, 2961.4805);
	angles[19] = (0, -170, 0);
	at[19] = 2.1000;
	points[20] = (-5567.0869, 13962.0088, 2944.1260);
	angles[20] = (0, -170, 0);
	at[20] = 2.2000;
	points[21] = (-5567.0869, 13962.0088, 2938.7600);
	angles[21] = (0, -170, 0);
	at[21] = 2.2500;
	points[22] = (-5567.0869, 13962.0088, 2938.7600);
	angles[22] = (0, -170, 0);
	at[22] = 2.3000;
	points[23] = (-5567.0869, 13962.0088, 2944.1260);
	angles[23] = (0, -170, 0);
	at[23] = 2.3500;
	points[24] = (-5567.0869, 13962.0088, 2961.4805);
	angles[24] = (0, -170, 0);
	at[24] = 2.4500;
	points[25] = (-5567.0869, 13962.0088, 2966.8428);
	angles[25] = (0, -170, 0);
	at[25] = 2.5000;
	points[26] = (-5567.0869, 13962.0088, 2966.8428);
	angles[26] = (0, -170, 0);
	at[26] = 2.5500;
	points[27] = (-5567.0869, 13962.0088, 2961.4805);
	angles[27] = (0, -170, 0);
	at[27] = 2.6000;
	points[28] = (-5567.0869, 13962.0088, 2943.8425);
	angles[28] = (0, -170, 0);
	at[28] = 2.7000;
	points[29] = (-5567.0869, 13962.0088, 2413.5000);
	angles[29] = (0, -170, 0);
	at[29] = 4.2000;
	points[30] = (-5567.0869, 13962.0088, 2410.6772);
	angles[30] = (0, -170, 0);
	at[30] = 4.2500;
	points[31] = (-5567.0869, 13962.0088, 2410.6772);
	angles[31] = (0, -170, 0);
	at[31] = 7.3000;
	points[32] = (-5567.0869, 13962.0088, 2499.2600);
	angles[32] = (0, -170, 0);
	at[32] = 7.3500;
	points[33] = (-5567.0869, 13962.0088, 2499.2600);
	angles[33] = (0, -170, 0);
	at[33] = 9;
	mover = getEnt("iz_obj_28", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_29()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5108.2676, 11633.8584, 2145.8582);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5108.2676, 11633.8584, 2145.8582);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (5108.2676, 11633.8584, 2186.3623);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (5108.2676, 11633.8584, 2239.7480);
	angles[3] = (0, 0, 0);
	at[3] = 3.4500;
	points[4] = (5108.2676, 11633.8584, 2338.0159);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (5108.2676, 11633.8584, 2424.9451);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (5108.2676, 11633.8584, 2500.5354);
	angles[6] = (0, 0, 0);
	at[6] = 3.7500;
	points[7] = (5108.2676, 11633.8584, 2534.0789);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (5108.2676, 11633.8584, 2592.6614);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (5108.2676, 11633.8584, 2617.7009);
	angles[9] = (0, 0, 0);
	at[9] = 3.9500;
	points[10] = (5108.2676, 11633.8584, 2659.2756);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (5108.2676, 11633.8584, 2689.5117);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (5108.2676, 11633.8584, 2708.4097);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (5108.2676, 11633.8584, 2719.1929);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (5108.2676, 11633.8584, 2727.0947);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (5108.2676, 11633.8584, 2730.8071);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (5108.2676, 11633.8584, 2728.9094);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (5108.2676, 11633.8584, 2705.1536);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (5108.2676, 11633.8584, 2701.4409);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (5108.2676, 11633.8584, 2703.3386);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (5108.2676, 11633.8584, 2727.0947);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (5108.2676, 11633.8584, 2730.8071);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (5108.2676, 11633.8584, 2728.9094);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (5108.2676, 11633.8584, 2705.1536);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (5108.2676, 11633.8584, 2701.4409);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (5108.2676, 11633.8584, 2703.3386);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (5108.2676, 11633.8584, 2727.0947);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (5108.2676, 11633.8584, 2730.8071);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (5108.2676, 11633.8584, 2728.9094);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (5108.2676, 11633.8584, 2705.1536);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (5108.2676, 11633.8584, 2701.4409);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (5108.2676, 11633.8584, 2703.3386);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (5108.2676, 11633.8584, 2727.0947);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (5108.2676, 11633.8584, 2730.8071);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (5108.2676, 11633.8584, 2728.9094);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (5108.2676, 11633.8584, 2705.1536);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (5108.2676, 11633.8584, 2700.1890);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (5108.2676, 11633.8584, 2152.1575);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (5108.2676, 11633.8584, 2145.8582);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (5108.2676, 11633.8584, 2145.8582);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_29", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_30()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4456.3389, 11337.4414, 2259.8740);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4456.3389, 11337.4414, 2259.8740);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (4456.3389, 11337.4414, 2292.3149);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (4456.3389, 11337.4414, 2335.0237);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (4456.3389, 11337.4414, 2413.6379);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (4456.3389, 11337.4414, 2483.1812);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (4456.3389, 11337.4414, 2543.6536);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (4456.3389, 11337.4414, 2570.4880);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (4456.3389, 11337.4414, 2617.3542);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (4456.3389, 11337.4414, 2655.1497);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (4456.3389, 11337.4414, 2670.6455);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (4456.3389, 11337.4414, 2694.8347);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (4456.3389, 11337.4414, 2709.9529);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (4456.3389, 11337.4414, 2719.1929);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (4456.3389, 11337.4414, 2727.0947);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (4456.3389, 11337.4414, 2730.8071);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (4456.3389, 11337.4414, 2728.9094);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (4456.3389, 11337.4414, 2705.1536);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (4456.3389, 11337.4414, 2701.4409);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (4456.3389, 11337.4414, 2703.3386);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (4456.3389, 11337.4414, 2727.0947);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (4456.3389, 11337.4414, 2730.8071);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (4456.3389, 11337.4414, 2728.9094);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (4456.3389, 11337.4414, 2705.1536);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (4456.3389, 11337.4414, 2701.4409);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (4456.3389, 11337.4414, 2703.3386);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (4456.3389, 11337.4414, 2727.0947);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (4456.3389, 11337.4414, 2730.8071);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (4456.3389, 11337.4414, 2728.9094);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (4456.3389, 11337.4414, 2705.1536);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (4456.3389, 11337.4414, 2701.4409);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (4456.3389, 11337.4414, 2703.3386);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (4456.3389, 11337.4414, 2727.0947);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (4456.3389, 11337.4414, 2730.8071);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (4456.3389, 11337.4414, 2728.9094);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (4456.3389, 11337.4414, 2705.1536);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (4456.3389, 11337.4414, 2700.8188);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (4456.3389, 11337.4414, 2262.3938);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (4456.3389, 11337.4414, 2259.8740);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (4456.3389, 11337.4414, 2259.8740);
	angles[39] = (0, 0, 0);
	at[39] = 10.0167;
	mover = getEnt("iz_obj_30", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_31()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5949.8032, 11294.2910, 2404.7559);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5949.8032, 11294.2910, 2030.5828);
	angles[1] = (0, 0, 0);
	at[1] = 1.6500;
	points[2] = (5949.8032, 11294.2910, 2030.5828);
	angles[2] = (0, 0, 0);
	at[2] = 5.8500;
	points[3] = (5949.8032, 11294.2910, 2080.4094);
	angles[3] = (0, 0, 0);
	at[3] = 5.9000;
	points[4] = (5949.8032, 11294.2910, 2144.4724);
	angles[4] = (0, 0, 0);
	at[4] = 5.9500;
	points[5] = (5949.8032, 11294.2910, 2262.3938);
	angles[5] = (0, 0, 0);
	at[5] = 6.0500;
	points[6] = (5949.8032, 11294.2910, 2366.7087);
	angles[6] = (0, 0, 0);
	at[6] = 6.1500;
	points[7] = (5949.8032, 11294.2910, 2413.7639);
	angles[7] = (0, 0, 0);
	at[7] = 6.2000;
	points[8] = (5949.8032, 11294.2910, 2497.6692);
	angles[8] = (0, 0, 0);
	at[8] = 6.3000;
	points[9] = (5949.8032, 11294.2910, 2567.9685);
	angles[9] = (0, 0, 0);
	at[9] = 6.4000;
	points[10] = (5949.8032, 11294.2910, 2624.6614);
	angles[10] = (0, 0, 0);
	at[10] = 6.5000;
	points[11] = (5949.8032, 11294.2910, 2647.9055);
	angles[11] = (0, 0, 0);
	at[11] = 6.5500;
	points[12] = (5949.8032, 11294.2910, 2684.1890);
	angles[12] = (0, 0, 0);
	at[12] = 6.6500;
	points[13] = (5949.8032, 11294.2910, 2706.8662);
	angles[13] = (0, 0, 0);
	at[13] = 6.7500;
	points[14] = (5949.8032, 11294.2910, 2713.1025);
	angles[14] = (0, 0, 0);
	at[14] = 6.8000;
	points[15] = (5949.8032, 11294.2910, 2719.1929);
	angles[15] = (0, 0, 0);
	at[15] = 6.9000;
	points[16] = (5949.8032, 11294.2910, 2727.0947);
	angles[16] = (0, 0, 0);
	at[16] = 6.9500;
	points[17] = (5949.8032, 11294.2910, 2730.8071);
	angles[17] = (0, 0, 0);
	at[17] = 7;
	points[18] = (5949.8032, 11294.2910, 2728.9094);
	angles[18] = (0, 0, 0);
	at[18] = 7.0500;
	points[19] = (5949.8032, 11294.2910, 2705.1536);
	angles[19] = (0, 0, 0);
	at[19] = 7.2000;
	points[20] = (5949.8032, 11294.2910, 2701.4409);
	angles[20] = (0, 0, 0);
	at[20] = 7.2500;
	points[21] = (5949.8032, 11294.2910, 2703.3386);
	angles[21] = (0, 0, 0);
	at[21] = 7.3000;
	points[22] = (5949.8032, 11294.2910, 2727.0947);
	angles[22] = (0, 0, 0);
	at[22] = 7.4500;
	points[23] = (5949.8032, 11294.2910, 2730.8071);
	angles[23] = (0, 0, 0);
	at[23] = 7.5000;
	points[24] = (5949.8032, 11294.2910, 2728.9094);
	angles[24] = (0, 0, 0);
	at[24] = 7.5500;
	points[25] = (5949.8032, 11294.2910, 2705.1536);
	angles[25] = (0, 0, 0);
	at[25] = 7.7000;
	points[26] = (5949.8032, 11294.2910, 2701.4409);
	angles[26] = (0, 0, 0);
	at[26] = 7.7500;
	points[27] = (5949.8032, 11294.2910, 2703.3386);
	angles[27] = (0, 0, 0);
	at[27] = 7.8000;
	points[28] = (5949.8032, 11294.2910, 2727.0947);
	angles[28] = (0, 0, 0);
	at[28] = 7.9500;
	points[29] = (5949.8032, 11294.2910, 2730.8071);
	angles[29] = (0, 0, 0);
	at[29] = 8;
	points[30] = (5949.8032, 11294.2910, 2728.9094);
	angles[30] = (0, 0, 0);
	at[30] = 8.0500;
	points[31] = (5949.8032, 11294.2910, 2705.1536);
	angles[31] = (0, 0, 0);
	at[31] = 8.2000;
	points[32] = (5949.8032, 11294.2910, 2701.4409);
	angles[32] = (0, 0, 0);
	at[32] = 8.2500;
	points[33] = (5949.8032, 11294.2910, 2703.3386);
	angles[33] = (0, 0, 0);
	at[33] = 8.3000;
	points[34] = (5949.8032, 11294.2910, 2727.0947);
	angles[34] = (0, 0, 0);
	at[34] = 8.4500;
	points[35] = (5949.8032, 11294.2910, 2730.8071);
	angles[35] = (0, 0, 0);
	at[35] = 8.5000;
	points[36] = (5949.8032, 11294.2910, 2728.9094);
	angles[36] = (0, 0, 0);
	at[36] = 8.5500;
	points[37] = (5949.8032, 11294.2910, 2699.5591);
	angles[37] = (0, 0, 0);
	at[37] = 8.7500;
	points[38] = (5949.8032, 11294.2910, 2404.7559);
	angles[38] = (0, 0, 0);
	at[38] = 10.0500;
	mover = getEnt("iz_obj_31", "targetname");
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
