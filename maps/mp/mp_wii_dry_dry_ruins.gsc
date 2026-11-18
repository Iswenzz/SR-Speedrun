main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_dry_dry_ruins", 0);

	setExpFog(4429.1338, 64099.4023, 0.6784, 0.6431, 0.0627, 0);

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
	ambientPlay("iz_0_strm_n_desert", 2);
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
	level.iz_route[level.iz_route.size] = (2399, -2202, 1181);
	level.iz_route[level.iz_route.size] = (2390, -2862, 1181);
	level.iz_route[level.iz_route.size] = (2328, -3685, 1222);
	level.iz_route[level.iz_route.size] = (2177, -4612, 1364);
	level.iz_route[level.iz_route.size] = (1653, -5579, 1547);
	level.iz_route[level.iz_route.size] = (758, -5971, 1652);
	level.iz_route[level.iz_route.size] = (-986, -5904, 1676);
	level.iz_route[level.iz_route.size] = (-2400, -5535, 1646);
	level.iz_route[level.iz_route.size] = (-2847, -5225, 1592);
	level.iz_route[level.iz_route.size] = (-3190, -4763, 1444);
	level.iz_route[level.iz_route.size] = (-3444, -4246, 1213);
	level.iz_route[level.iz_route.size] = (-3593, -3174, 741);
	level.iz_route[level.iz_route.size] = (-3579, -2206, 492);
	level.iz_route[level.iz_route.size] = (-3473, -1517, 522);
	level.iz_route[level.iz_route.size] = (-3374, -831, 384);
	level.iz_route[level.iz_route.size] = (-3326, 329, 551);
	level.iz_route[level.iz_route.size] = (-3721, 1228, 495);
	level.iz_route[level.iz_route.size] = (-4702, 1718, 492);
	level.iz_route[level.iz_route.size] = (-5612, 1906, 637);
	level.iz_route[level.iz_route.size] = (-6352, 2423, 1055);
	level.iz_route[level.iz_route.size] = (-6371, 3187, 1158);
	level.iz_route[level.iz_route.size] = (-6104, 4248, 1255);
	level.iz_route[level.iz_route.size] = (-5822, 4851, 1362);
	level.iz_route[level.iz_route.size] = (-5544, 5817, 1583);
	level.iz_route[level.iz_route.size] = (-5361, 6934, 1671);
	level.iz_route[level.iz_route.size] = (-5238, 9097, 1685);
	level.iz_route[level.iz_route.size] = (-5198, 10335, 1751);
	level.iz_route[level.iz_route.size] = (-5167, 10755, 1797);
	level.iz_route[level.iz_route.size] = (-5179, 12113, 1949);
	level.iz_route[level.iz_route.size] = (-5181, 12546, 1974);
	level.iz_route[level.iz_route.size] = (-5185, 13104, 2016);
	level.iz_route[level.iz_route.size] = (-5188, 13622, 2055);
	level.iz_route[level.iz_route.size] = (-5197, 15020, 2150);
	level.iz_route[level.iz_route.size] = (-5046, 15860, 2158);
	level.iz_route[level.iz_route.size] = (-4294, 16523, 2182);
	level.iz_route[level.iz_route.size] = (-2681, 17061, 2190);
	level.iz_route[level.iz_route.size] = (-2343, 17557, 2156);
	level.iz_route[level.iz_route.size] = (-2256, 18488, 2186);
	level.iz_route[level.iz_route.size] = (-2182, 20145, 2522);
	level.iz_route[level.iz_route.size] = (-1698, 20954, 2644);
	level.iz_route[level.iz_route.size] = (-1033, 21176, 2695);
	level.iz_route[level.iz_route.size] = (-109, 21158, 2748);
	level.iz_route[level.iz_route.size] = (584, 20900, 2772);
	level.iz_route[level.iz_route.size] = (1008, 19781, 2659);
	level.iz_route[level.iz_route.size] = (1233, 16578, 2262);
	level.iz_route[level.iz_route.size] = (1201, 14037, 2466);
	level.iz_route[level.iz_route.size] = (1195, 13226, 2478);
	level.iz_route[level.iz_route.size] = (1188, 12336, 2675);
	level.iz_route[level.iz_route.size] = (1187, 11722, 2909);
	level.iz_route[level.iz_route.size] = (1178, 10602, 2526);
	level.iz_route[level.iz_route.size] = (1178, 9467, 2288);
	level.iz_route[level.iz_route.size] = (1189, 7252, 2039);
	level.iz_route[level.iz_route.size] = (1201, 4801, 1501);
	level.iz_route[level.iz_route.size] = (1936, 3831, 1263);
	level.iz_route[level.iz_route.size] = (2419, 3733, 1146);
	level.iz_route[level.iz_route.size] = (3143, 3435, 975);
	level.iz_route[level.iz_route.size] = (3937, 2826, 893);
	level.iz_route[level.iz_route.size] = (3952, 2041, 979);
	level.iz_route[level.iz_route.size] = (3529, 1341, 1023);
	level.iz_route[level.iz_route.size] = (2725, 302, 1172);
	level.iz_route[level.iz_route.size] = (2593, -743, 1181);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (283.2327, 13337.7178, 2730.0356);
	angles[0] = (0, -132.8888, 0);
	at[0] = 0;
	points[1] = (689.9016, 12960.3545, 2606);
	angles[1] = (0, -133.4743, 0);
	at[1] = 1;
	points[2] = (715.1497, 12936.2197, 2599.5159);
	angles[2] = (0, -133.6592, 0);
	at[2] = 1.0667;
	points[3] = (823.9331, 12832.7158, 2576.5276);
	angles[3] = (0, -134.0549, 0);
	at[3] = 1.3333;
	points[4] = (877.4764, 12779.7637, 2567.4490);
	angles[4] = (0, -135.4668, 0);
	at[4] = 1.4667;
	points[5] = (929.1299, 12724.3701, 2561.4331);
	angles[5] = (0, -139.3441, 0);
	at[5] = 1.6000;
	points[6] = (952.2205, 12694.6855, 2561.5315);
	angles[6] = (0, -146.5679, 0);
	at[6] = 1.6667;
	points[7] = (968.9764, 12662.7559, 2567.7322);
	angles[7] = (0, -155.9922, 0);
	at[7] = 1.7333;
	points[8] = (994.8779, 12594.6074, 2588.9094);
	angles[8] = (0, -161.4121, 0);
	at[8] = 1.8667;
	points[9] = (1034.2047, 12457.2441, 2640.0156);
	angles[9] = (0, -166.5531, 0);
	at[9] = 2.1333;
	points[10] = (1047.6810, 12389.3701, 2666.8071);
	angles[10] = (0, -172.4734, 0);
	at[10] = 2.2667;
	points[11] = (1051.3818, 12354.4492, 2681.0474);
	angles[11] = (0, -174.9727, 0);
	at[11] = 2.3333;
	points[12] = (1058.0118, 12249.3701, 2725.1497);
	angles[12] = (0, -177.4094, 0);
	at[12] = 2.5333;
	points[13] = (1061.7126, 12110.2764, 2785.3662);
	angles[13] = (0, -179.6477, 0);
	at[13] = 2.8000;
	points[14] = (1059.5394, 12007.0479, 2832.3152);
	angles[14] = (0, -183.7675, 0);
	at[14] = 3;
	points[15] = (1053.7953, 11941.4180, 2865.1931);
	angles[15] = (0, -185.6452, 0);
	at[15] = 3.1333;
	points[16] = (1026.4055, 11706.6143, 2987.5510);
	angles[16] = (0, -187.5352, 0);
	at[16] = 3.6000;
	points[17] = (996.0118, 11505.9854, 3090.6104);
	angles[17] = (0, -190.1943, 0);
	at[17] = 4;
	points[18] = (982.4528, 11438.3066, 3123.6140);
	angles[18] = (0, -192.9157, 0);
	at[18] = 4.1333;
	points[19] = (974.7756, 11407.9521, 3137.4766);
	angles[19] = (0, -195.5630, 0);
	at[19] = 4.2000;
	points[20] = (942.7992, 11306.0234, 3180.1575);
	angles[20] = (0, -198.4384, 0);
	at[20] = 4.4000;
	points[21] = (860.5433, 11072.3623, 3273.1536);
	angles[21] = (0, -200.0989, 0);
	at[21] = 4.8667;
	points[22] = (772.0118, 10838.8584, 3364.8389);
	angles[22] = (0, -201.6127, 0);
	at[22] = 5.3333;
	points[23] = (731.1299, 10739.6846, 3404.3347);
	angles[23] = (0, -203.6631, 0);
	at[23] = 5.5333;
	points[24] = (717.4174, 10709.7646, 3416.6536);
	angles[24] = (0, -205.9846, 0);
	at[24] = 5.6000;
	points[25] = (666.8504, 10616.9678, 3457.1968);
	angles[25] = (0, -210.3525, 0);
	at[25] = 5.8000;
	points[26] = (611.2047, 10526.3779, 3498.1023);
	angles[26] = (0, -212.7065, 0);
	at[26] = 6;
	points[27] = (551.9724, 10438.3066, 3538.4883);
	angles[27] = (0, -215.2685, 0);
	at[27] = 6.2000;
	points[28] = (509.4331, 10380.8271, 3565.0513);
	angles[28] = (0, -218.0208, 0);
	at[28] = 6.3333;
	points[29] = (463.1417, 10326.9287, 3590.1101);
	angles[29] = (0, -224.5751, 0);
	at[29] = 6.4667;
	points[30] = (436.9803, 10304.2520, 3600.6694);
	angles[30] = (0, -235.3062, 0);
	at[30] = 6.5333;
	points[31] = (405.1693, 10285.6299, 3609.3071);
	angles[31] = (0, -242.7566, 0);
	at[31] = 6.6000;
	points[32] = (336.6256, 10255.1963, 3623.4253);
	angles[32] = (0, -248.4959, 0);
	at[32] = 6.7333;
	points[33] = (266.4642, 10229.8037, 3635.4094);
	angles[33] = (0, -251.5233, 0);
	at[33] = 6.8667;
	points[34] = (158.4232, 10197.6377, 3651.3860);
	angles[34] = (0, -255.3645, 0);
	at[34] = 7.0667;
	points[35] = (84.9193, 10180.7480, 3660.9094);
	angles[35] = (0, -259.1551, 0);
	at[35] = 7.2000;
	points[36] = (47.6535, 10174.7236, 3665.2324);
	angles[36] = (0, -262.9687, 0);
	at[36] = 7.2667;
	points[37] = (12.5957, 10172.6768, 3668.6260);
	angles[37] = (0, -270.7979, 0);
	at[37] = 7.3333;
	points[38] = (-63.4941, 10178.7402, 3672.8032);
	angles[38] = (0, -276.8183, 0);
	at[38] = 7.4667;
	points[39] = (-176.0394, 10195.5518, 3676.8188);
	angles[39] = (0, -279.8483, 0);
	at[39] = 7.6667;
	points[40] = (-287.5528, 10217.1650, 3680.1694);
	angles[40] = (0, -282.0975, 0);
	at[40] = 7.8667;
	points[41] = (-397.9488, 10243.8184, 3683.7637);
	angles[41] = (0, -285.5094, 0);
	at[41] = 8.0667;
	points[42] = (-469.4134, 10267.6377, 3687.2834);
	angles[42] = (0, -293.8230, 0);
	at[42] = 8.2000;
	points[43] = (-502.4724, 10284.8818, 3689.9490);
	angles[43] = (0, -300.0608, 0);
	at[43] = 8.2667;
	points[44] = (-596.7087, 10346.8506, 3698.7246);
	angles[44] = (0, -305.5135, 0);
	at[44] = 8.4667;
	points[45] = (-745.8819, 10463.0312, 3715.5276);
	angles[45] = (0, -310.3894, 0);
	at[45] = 8.8000;
	points[46] = (-828.2363, 10539.4883, 3728.1025);
	angles[46] = (0, -316.7614, 0);
	at[46] = 9;
	points[47] = (-851.8898, 10567.6777, 3733.7007);
	angles[47] = (0, -324.9377, 0);
	at[47] = 9.0667;
	points[48] = (-887.0079, 10632.5586, 3750.2876);
	angles[48] = (0, -335.4102, 0);
	at[48] = 9.2000;
	points[49] = (-915.1575, 10700, 3768.9055);
	angles[49] = (0, -338.9135, 0);
	at[49] = 9.3333;
	points[50] = (-951.5906, 10803.9375, 3797.7363);
	angles[50] = (0, -342.3339, 0);
	at[50] = 9.5333;
	points[51] = (-981.8189, 10909.9609, 3825.7678);
	angles[51] = (0, -346.1114, 0);
	at[51] = 9.7333;
	points[52] = (-996.9055, 10982.7168, 3842.6536);
	angles[52] = (0, -351.2763, 0);
	at[52] = 9.8667;
	points[53] = (-1000.5906, 11016.6533, 3848.8071);
	angles[53] = (0, -356.4284, 0);
	at[53] = 9.9333;
	points[54] = (-1001.5945, 11129.7646, 3864.6143);
	angles[54] = (0, -361.1351, 0);
	at[54] = 10.1333;
	points[55] = (-986.8267, 11431.3379, 3900.9370);
	angles[55] = (0, -364.0829, 0);
	at[55] = 10.6667;
	points[56] = (-974.0709, 11581.9297, 3918.3267);
	angles[56] = (0, -365.8529, 0);
	at[56] = 10.9333;
	points[57] = (-965.1771, 11654.8818, 3926.8857);
	angles[57] = (0, -368.7951, 0);
	at[57] = 11.0667;
	points[58] = (-950.6063, 11727.4805, 3935.5471);
	angles[58] = (0, -372.9595, 0);
	at[58] = 11.2000;
	points[59] = (-923.0748, 11837.2832, 3948.5039);
	angles[59] = (0, -374.8551, 0);
	at[59] = 11.4000;
	points[60] = (-811.3740, 12236.8115, 3995.2759);
	angles[60] = (0, -375.1363, 0);
	at[60] = 12.1333;
	points[61] = (-809.0275, 12245.5127, 3996.2991);
	angles[61] = (0, -374.9930, 0);
	at[61] = 12.1667;
	points[62] = (283.2327, 13337.7178, 2730.0356);
	angles[62] = (0, -492.8888, 0);
	at[62] = 12.1667;
	points[63] = (283.2327, 13337.7178, 2730.0356);
	angles[63] = (0, -492.8888, 0);
	at[63] = 12.1833;
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
	points[0] = (-3065.0432, -532.8504, 578.9134);
	angles[0] = (0, 170, 0);
	at[0] = 0;
	points[1] = (-3582.5825, -448.2244, 578.5748);
	angles[1] = (0, 170, 0);
	at[1] = 3.7000;
	points[2] = (-3584.9136, -447.8425, 578.5709);
	angles[2] = (0, 170, 0);
	at[2] = 3.7500;
	points[3] = (-3584.9136, -447.8425, 578.5709);
	angles[3] = (0, 170, 0);
	at[3] = 4.2000;
	points[4] = (-3579.4526, -448.7362, 578.5748);
	angles[4] = (0, 170, 0);
	at[4] = 4.2500;
	points[5] = (-3061.9172, -533.3622, 578.9134);
	angles[5] = (0, 170, 0);
	at[5] = 7.9500;
	points[6] = (-3061.9172, -533.3622, 578.9134);
	angles[6] = (0, 170, 0);
	at[6] = 8.4500;
	points[7] = (-3065.0432, -532.8504, 578.9134);
	angles[7] = (0, 170, 0);
	at[7] = 8.4667;
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
	points[0] = (-4141.9292, 13416.7324, 2148.0710);
	angles[0] = (0, 89.7118, 0);
	at[0] = 0;
	points[1] = (-4448.7798, 13418.3076, 2098.7480);
	angles[1] = (0, 89.7335, 0);
	at[1] = 0.7000;
	points[2] = (-4645.9844, 13419.0947, 2074.9763);
	angles[2] = (0, 89.7797, 0);
	at[2] = 1.1500;
	points[3] = (-4932.5986, 13420.1963, 2048.0276);
	angles[3] = (0, 89.7747, 0);
	at[3] = 1.8000;
	points[4] = (-5021.1421, 13420.5508, 2042.2952);
	angles[4] = (0, 89.7742, 0);
	at[4] = 2;
	points[5] = (-5087.1655, 13420.8271, 2041.7047);
	angles[5] = (0, 89.7750, 0);
	at[5] = 2.1500;
	points[6] = (-5352.4805, 13421.8506, 2051.5945);
	angles[6] = (0, 89.7753, 0);
	at[6] = 2.7500;
	points[7] = (-5773.3071, 13423.5439, 2076.5513);
	angles[7] = (0, 89.7716, 0);
	at[7] = 3.7000;
	points[8] = (-6169.8428, 13425.1973, 2113.4292);
	angles[8] = (0, 89.7451, 0);
	at[8] = 4.6000;
	points[9] = (-6279.3306, 13425.3545, 2129.0828);
	angles[9] = (0, 90.2885, 0);
	at[9] = 4.8500;
	points[10] = (-6471.8901, 13423.8193, 2181.7874);
	angles[10] = (0, 90.4869, 0);
	at[10] = 5.3000;
	points[11] = (-6486.2207, 13423.7012, 2185.7756);
	angles[11] = (0, 90.4711, 0);
	at[11] = 5.3500;
	points[12] = (-4141.9292, 13416.7324, 2148.0710);
	angles[12] = (0, 89.7118, 0);
	at[12] = 5.3500;
	points[13] = (-4141.9292, 13416.7324, 2148.0710);
	angles[13] = (0, 89.7118, 0);
	at[13] = 5.3667;
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
	points[0] = (2109.3230, 13355.4336, 2751.3425);
	angles[0] = (0, 130.5684, 0);
	at[0] = 0;
	points[1] = (1800.6261, 13094.9609, 2651.4097);
	angles[1] = (0, 130.4064, 0);
	at[1] = 0.7333;
	points[2] = (1660.8071, 12972.6377, 2609.5159);
	angles[2] = (0, 133.0557, 0);
	at[2] = 1.0667;
	points[3] = (1610.0394, 12920.7090, 2600.4211);
	angles[3] = (0, 137.5483, 0);
	at[3] = 1.2000;
	points[4] = (1535.4213, 12834.8027, 2595.0750);
	angles[4] = (0, 140.1855, 0);
	at[4] = 1.4000;
	points[5] = (1441.6458, 12716.1035, 2595.7285);
	angles[5] = (0, 143.6741, 0);
	at[5] = 1.6667;
	points[6] = (1400.8346, 12653.7002, 2601.4055);
	angles[6] = (0, 152.4174, 0);
	at[6] = 1.8000;
	points[7] = (1369.9921, 12585.9453, 2616.3149);
	angles[7] = (0, 157.5824, 0);
	at[7] = 1.9333;
	points[8] = (1331.3425, 12482.7168, 2644.3899);
	angles[8] = (0, 161.2829, 0);
	at[8] = 2.1333;
	points[9] = (1309.8859, 12413.0703, 2665.7993);
	angles[9] = (0, 165.0032, 0);
	at[9] = 2.2667;
	points[10] = (1302.0748, 12378.9365, 2677.5393);
	angles[10] = (0, 170.2715, 0);
	at[10] = 2.3333;
	points[11] = (1297.7441, 12344.5273, 2691.1575);
	angles[11] = (0, 174.4980, 0);
	at[11] = 2.4000;
	points[12] = (1289.9645, 12170.8271, 2767.1182);
	angles[12] = (0, 179.3520, 0);
	at[12] = 2.7333;
	points[13] = (1292.2794, 12032.7949, 2830.4014);
	angles[13] = (0, 183.2924, 0);
	at[13] = 3;
	points[14] = (1294.6143, 12001.3389, 2845.2480);
	angles[14] = (0, 185.0083, 0);
	at[14] = 3.0667;
	points[15] = (1325.1339, 11729.3301, 2978.5549);
	angles[15] = (0, 187.1271, 0);
	at[15] = 3.6000;
	points[16] = (1362.8386, 11458.2686, 3110.1731);
	angles[16] = (0, 189.2311, 0);
	at[16] = 4.1333;
	points[17] = (1388.9489, 11325.0400, 3169.6064);
	angles[17] = (0, 192.3117, 0);
	at[17] = 4.4000;
	points[18] = (1453.3110, 11050.3535, 3283.0747);
	angles[18] = (0, 194.0668, 0);
	at[18] = 4.9333;
	points[19] = (1498.5276, 10880.1963, 3352.6062);
	angles[19] = (0, 195.9508, 0);
	at[19] = 5.2667;
	points[20] = (1542.1654, 10745.0400, 3408.4016);
	angles[20] = (0, 201.4089, 0);
	at[20] = 5.5333;
	points[21] = (1555.6180, 10714.4492, 3421.4250);
	angles[21] = (0, 207.1586, 0);
	at[21] = 5.6000;
	points[22] = (1573.4133, 10684.2129, 3434.8306);
	angles[22] = (0, 213.0529, 0);
	at[22] = 5.6667;
	points[23] = (1637.8229, 10599.1729, 3474.0513);
	angles[23] = (0, 219.9831, 0);
	at[23] = 5.8667;
	points[24] = (1733.9802, 10493.4248, 3524.1458);
	angles[24] = (0, 224.2881, 0);
	at[24] = 6.1333;
	points[25] = (1838.0393, 10394.0557, 3571.6497);
	angles[25] = (0, 228.7274, 0);
	at[25] = 6.4000;
	points[26] = (1894.9094, 10347.8740, 3593.4919);
	angles[26] = (0, 234.1181, 0);
	at[26] = 6.5333;
	points[27] = (1923.4174, 10329.6064, 3601.7639);
	angles[27] = (0, 241.0170, 0);
	at[27] = 6.6000;
	points[28] = (1991.6812, 10297.4404, 3615.1536);
	angles[28] = (0, 247.1528, 0);
	at[28] = 6.7333;
	points[29] = (2096.8347, 10257.0869, 3631.0474);
	angles[29] = (0, 250.4622, 0);
	at[29] = 6.9333;
	points[30] = (2203.8149, 10221.5742, 3644.8977);
	angles[30] = (0, 252.8243, 0);
	at[30] = 7.1333;
	points[31] = (2312.8110, 10190.8662, 3657.4922);
	angles[31] = (0, 256.0452, 0);
	at[31] = 7.3333;
	points[32] = (2387.2559, 10175.5127, 3665.1497);
	angles[32] = (0, 261.9700, 0);
	at[32] = 7.4667;
	points[33] = (2422.0747, 10173.1885, 3668.0513);
	angles[33] = (0, 270.7984, 0);
	at[33] = 7.5333;
	points[34] = (2459.9883, 10175.5908, 3670.0120);
	angles[34] = (0, 275.8016, 0);
	at[34] = 7.6000;
	points[35] = (2535.5669, 10186.5752, 3672.4094);
	angles[35] = (0, 280.1083, 0);
	at[35] = 7.7333;
	points[36] = (2609.6770, 10201.4570, 3673.9963);
	angles[36] = (0, 282.4673, 0);
	at[36] = 7.8667;
	points[37] = (2720.2795, 10228.8584, 3676.0315);
	angles[37] = (0, 285.3668, 0);
	at[37] = 8.0667;
	points[38] = (2792.3032, 10250.2363, 3677.7007);
	angles[38] = (0, 287.9210, 0);
	at[38] = 8.2000;
	points[39] = (2862.8228, 10276.7715, 3680.8267);
	angles[39] = (0, 295.4843, 0);
	at[39] = 8.3333;
	points[40] = (2959.5042, 10334.4092, 3690.1223);
	angles[40] = (0, 303.5792, 0);
	at[40] = 8.5333;
	points[41] = (3052.0945, 10399.7637, 3700.8308);
	angles[41] = (0, 306.7455, 0);
	at[41] = 8.7333;
	points[42] = (3140.5315, 10470.1182, 3712.7283);
	angles[42] = (0, 310.6072, 0);
	at[42] = 8.9333;
	points[43] = (3196.0867, 10521.7334, 3721.8584);
	angles[43] = (0, 315.9554, 0);
	at[43] = 9.0667;
	points[44] = (3220.9214, 10550, 3727.1418);
	angles[44] = (0, 322.4175, 0);
	at[44] = 9.1333;
	points[45] = (3238.8347, 10579.5273, 3733.1025);
	angles[45] = (0, 334.9292, 0);
	at[45] = 9.2000;
	points[46] = (3264.1260, 10649.8428, 3748.5354);
	angles[46] = (0, 343.4374, 0);
	at[46] = 9.3333;
	points[47] = (3291.6614, 10757.6768, 3772.7993);
	angles[47] = (0, 347.3471, 0);
	at[47] = 9.5333;
	points[48] = (3320.4529, 10903.1494, 3805.3071);
	angles[48] = (0, 350.1022, 0);
	at[48] = 9.8000;
	points[49] = (3342.2124, 11050.5127, 3836.4136);
	angles[49] = (0, 353.7606, 0);
	at[49] = 10.0667;
	points[50] = (3345.2324, 11084.5273, 3842.6023);
	angles[50] = (0, 356.2517, 0);
	at[50] = 10.1333;
	points[51] = (3349.0828, 11272.2842, 3872.1929);
	angles[51] = (0, 360.2656, 0);
	at[51] = 10.4667;
	points[52] = (3346.2246, 11422.4014, 3894.2837);
	angles[52] = (0, 361.9471, 0);
	at[52] = 10.7333;
	points[53] = (3338.0552, 11572.0078, 3915.3110);
	angles[53] = (0, 364.6954, 0);
	at[53] = 11;
	points[54] = (3329.7637, 11647.7959, 3925.3152);
	angles[54] = (0, 368.4623, 0);
	at[54] = 11.1333;
	points[55] = (3323.5393, 11681.6152, 3929.4055);
	angles[55] = (0, 372.6445, 0);
	at[55] = 11.2000;
	points[56] = (3303.7324, 11754.6855, 3937.2439);
	angles[56] = (0, 376.7891, 0);
	at[56] = 11.3333;
	points[57] = (3244.1812, 11933.9756, 3954.6062);
	angles[57] = (0, 379.3298, 0);
	at[57] = 11.6667;
	points[58] = (3116.4292, 12289.5674, 3987.5195);
	angles[58] = (0, 379.3678, 0);
	at[58] = 12.3333;
	points[59] = (3107.0471, 12316.4961, 3990.0393);
	angles[59] = (0, 379.0059, 0);
	at[59] = 12.4000;
	points[60] = (2109.3230, 13355.4336, 2751.3425);
	angles[60] = (0, 490.5684, 0);
	at[60] = 12.4000;
	points[61] = (2109.3230, 13355.4336, 2751.3425);
	angles[61] = (0, 490.5684, 0);
	at[61] = 12.4167;
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
	points[0] = (-222.0976, 16350.7871, 2449.3386);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1.4462, 16227.4414, 2367.3818);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (37.1839, 16208.8193, 2353.0315);
	angles[2] = (0, 0, 0);
	at[2] = 1.1667;
	points[3] = (290.7358, 16089.9609, 2289.6299);
	angles[3] = (0, 0, 0);
	at[3] = 2.2500;
	points[4] = (332.8827, 16077.1270, 2279.9961);
	angles[4] = (0, 0, 0);
	at[4] = 2.4167;
	points[5] = (459.9646, 16040.1963, 2273.9961);
	angles[5] = (0, 0, 0);
	at[5] = 2.9167;
	points[6] = (697.7323, 15988.2295, 2262.7717);
	angles[6] = (0, 0, 0);
	at[6] = 3.8333;
	points[7] = (784.6141, 15971.0635, 2262.4646);
	angles[7] = (0, 0, 0);
	at[7] = 4.1667;
	points[8] = (1115.5000, 15941.7715, 2262.4685);
	angles[8] = (0, 0, 0);
	at[8] = 5.4167;
	points[9] = (1292.4095, 15932.4023, 2262.4685);
	angles[9] = (0, 0, 0);
	at[9] = 6.0833;
	points[10] = (1469.3898, 15940.8672, 2262.4685);
	angles[10] = (0, 0, 0);
	at[10] = 6.7500;
	points[11] = (1643.3228, 15974.5674, 2262.4685);
	angles[11] = (0, 0, 0);
	at[11] = 7.4167;
	points[12] = (1793.9528, 16010.6689, 2268.8857);
	angles[12] = (0, 0, 0);
	at[12] = 8;
	points[13] = (1955.8623, 16082.0859, 2276.5315);
	angles[13] = (0, 0, 0);
	at[13] = 8.6667;
	points[14] = (2031.4409, 16126.8115, 2280.0984);
	angles[14] = (0, 0, 0);
	at[14] = 9;
	points[15] = (2106.7795, 16171.9297, 2298.3506);
	angles[15] = (0, 0, 0);
	at[15] = 9.3333;
	points[16] = (2118.0786, 16178.7012, 2301.1418);
	angles[16] = (0, 0, 0);
	at[16] = 9.4167;
	points[17] = (2118.0786, 16178.7012, 2301.1418);
	angles[17] = (0, 0, 0);
	at[17] = 9.8333;
	points[18] = (2109.3977, 16173.5049, 2299);
	angles[18] = (0, 0, 0);
	at[18] = 9.9167;
	points[19] = (2034.0591, 16128.3867, 2280.3899);
	angles[19] = (0, 0, 0);
	at[19] = 10.2500;
	points[20] = (1958.7244, 16083.2285, 2276.6655);
	angles[20] = (0, 0, 0);
	at[20] = 10.5833;
	points[21] = (1796.9528, 16011.3779, 2269.0276);
	angles[21] = (0, 0, 0);
	at[21] = 11.2500;
	points[22] = (1646.3149, 15975.2764, 2262.4685);
	angles[22] = (0, 0, 0);
	at[22] = 11.8333;
	points[23] = (1472.3898, 15941.6533, 2262.4685);
	angles[23] = (0, 0, 0);
	at[23] = 12.5000;
	points[24] = (1295.4882, 15932.9141, 2262.4685);
	angles[24] = (0, 0, 0);
	at[24] = 13.1667;
	points[25] = (1118.5669, 15941.5361, 2262.4685);
	angles[25] = (0, 0, 0);
	at[25] = 13.8333;
	points[26] = (787.6733, 15970.7490, 2262.4685);
	angles[26] = (0, 0, 0);
	at[26] = 15.0833;
	points[27] = (635.5905, 16000.5117, 2265.7048);
	angles[27] = (0, 0, 0);
	at[27] = 15.6667;
	points[28] = (441.3858, 16044.4102, 2274.8740);
	angles[28] = (0, 0, 0);
	at[28] = 16.4167;
	points[29] = (335.8193, 16076.2607, 2279.8584);
	angles[29] = (0, 0, 0);
	at[29] = 16.8333;
	points[30] = (293.5602, 16088.8975, 2288.9331);
	angles[30] = (0, 0, 0);
	at[30] = 17;
	points[31] = (39.8756, 16207.5195, 2352.0315);
	angles[31] = (0, 0, 0);
	at[31] = 18.0833;
	points[32] = (1.1394, 16226.0635, 2366.4214);
	angles[32] = (0, 0, 0);
	at[32] = 18.2500;
	points[33] = (-219.5421, 16349.3701, 2448.3896);
	angles[33] = (0, 0, 0);
	at[33] = 19.2500;
	points[34] = (-226.8972, 16353.5039, 2451.1221);
	angles[34] = (0, 0, 0);
	at[34] = 19.3333;
	points[35] = (-226.8972, 16353.5039, 2451.1221);
	angles[35] = (0, 0, 0);
	at[35] = 19.7500;
	points[36] = (-222.0976, 16350.7871, 2449.3386);
	angles[36] = (0, 0, 0);
	at[36] = 19.8000;
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
	points[0] = (-1685.8425, -6154.5674, 1858.3110);
	angles[0] = (0, -89, 0);
	at[0] = 0;
	points[1] = (-1577.2441, -6133.7798, 1832.6456);
	angles[1] = (0, -89, 0);
	at[1] = 0.8000;
	points[2] = (-1485.8662, -6081.5352, 1790.9055);
	angles[2] = (0, -89, 0);
	at[2] = 1.6000;
	points[3] = (-1443.0906, -6019.0552, 1750.1418);
	angles[3] = (0, -89, 0);
	at[3] = 2.2000;
	points[4] = (-1421.2794, -5983.2681, 1731.6575);
	angles[4] = (0, -89, 0);
	at[4] = 2.5333;
	points[5] = (-1406.6300, -5890.4722, 1687.2166);
	angles[5] = (0, -89, 0);
	at[5] = 3.2667;
	points[6] = (-1425.6182, -5781.8110, 1633.6182);
	angles[6] = (0, -89, 0);
	at[6] = 4.1333;
	points[7] = (-1478.3503, -5689.4097, 1594.4528);
	angles[7] = (0, -89, 0);
	at[7] = 4.9333;
	points[8] = (-1484.4489, -5682.8740, 1591.8149);
	angles[8] = (0, -89, 0);
	at[8] = 5;
	points[9] = (-1536.0275, -5643.4253, 1576.5118);
	angles[9] = (0, -89, 0);
	at[9] = 5.4667;
	points[10] = (-1565.5040, -5620.8662, 1572.2520);
	angles[10] = (0, -89, 0);
	at[10] = 5.7333;
	points[11] = (-1684.2874, -5589.9209, 1573.7953);
	angles[11] = (0, -89, 0);
	at[11] = 6.6000;
	points[12] = (-1776.9803, -5605, 1585.4292);
	angles[12] = (0, -89, 0);
	at[12] = 7.2667;
	points[13] = (-1863.3347, -5656.0234, 1609.9961);
	angles[13] = (0, -89, 0);
	at[13] = 8;
	points[14] = (-1872.0237, -5670.8267, 1615.8583);
	angles[14] = (0, -89, 0);
	at[14] = 8.1333;
	points[15] = (-1923.0316, -5759.8428, 1665.9213);
	angles[15] = (0, -89, 0);
	at[15] = 8.9333;
	points[16] = (-1939.1694, -5823.1104, 1697.8701);
	angles[16] = (0, -89, 0);
	at[16] = 9.4667;
	points[17] = (-1951.9922, -5878.4648, 1737.9409);
	angles[17] = (0, -89, 0);
	at[17] = 9.9333;
	points[18] = (-1926.2245, -5975.2363, 1790.9174);
	angles[18] = (0, -89, 0);
	at[18] = 10.7333;
	points[19] = (-1864.9094, -6069.4092, 1839.6300);
	angles[19] = (0, -89, 0);
	at[19] = 11.6000;
	points[20] = (-1790.8700, -6124.8037, 1858.9135);
	angles[20] = (0, -89, 0);
	at[20] = 12.2667;
	points[21] = (-1685.8425, -6154.5674, 1858.3110);
	angles[21] = (0, -89, 0);
	at[21] = 13.0333;
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
	points[0] = (2590.3110, 16461.9297, 2451.5710);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2389.1064, 16494.0547, 2376.8347);
	angles[1] = (0, 0, 0);
	at[1] = 0.8167;
	points[2] = (2362.7166, 16507.0078, 2367.0315);
	angles[2] = (0, 0, 0);
	at[2] = 0.9333;
	points[3] = (2311.6812, 16539.1348, 2348.9646);
	angles[3] = (0, 0, 0);
	at[3] = 1.1667;
	points[4] = (2209.6182, 16603.3867, 2325.3269);
	angles[4] = (0, 0, 0);
	at[4] = 1.6333;
	points[5] = (2073.9016, 16771.1426, 2302.4490);
	angles[5] = (0, 0, 0);
	at[5] = 2.4500;
	points[6] = (2041.3544, 16823.8203, 2296.6182);
	angles[6] = (0, 0, 0);
	at[6] = 2.6833;
	points[7] = (1961.6851, 16956.7324, 2306.7480);
	angles[7] = (0, 0, 0);
	at[7] = 3.2667;
	points[8] = (1942.0787, 16980.0801, 2307.9922);
	angles[8] = (0, 0, 0);
	at[8] = 3.3833;
	points[9] = (1820.5709, 17076.1816, 2308.4607);
	angles[9] = (0, 0, 0);
	at[9] = 3.9667;
	points[10] = (1747.6693, 17133.8594, 2317.2046);
	angles[10] = (0, 0, 0);
	at[10] = 4.3167;
	points[11] = (1492.1064, 17243.9375, 2329.9292);
	angles[11] = (0, 0, 0);
	at[11] = 5.3667;
	points[12] = (1463.2362, 17254.4102, 2332.7559);
	angles[12] = (0, 0, 0);
	at[12] = 5.4833;
	points[13] = (1185.5945, 17282.2832, 2340.2717);
	angles[13] = (0, 0, 0);
	at[13] = 6.5333;
	points[14] = (1154.7283, 17282.4805, 2340.3347);
	angles[14] = (0, 0, 0);
	at[14] = 6.6500;
	points[15] = (876.7756, 17258.8184, 2333.9448);
	angles[15] = (0, 0, 0);
	at[15] = 7.7000;
	points[16] = (846.7205, 17251.7715, 2333.1338);
	angles[16] = (0, 0, 0);
	at[16] = 7.8167;
	points[17] = (639.0748, 17188.9375, 2329.2598);
	angles[17] = (0, 0, 0);
	at[17] = 8.6333;
	points[18] = (523.5472, 17143.8594, 2324.2441);
	angles[18] = (0, 0, 0);
	at[18] = 9.1000;
	points[19] = (465.7795, 17121.3379, 2327.1064);
	angles[19] = (0, 0, 0);
	at[19] = 9.3333;
	points[20] = (438.8307, 17106.3789, 2327.9331);
	angles[20] = (0, 0, 0);
	at[20] = 9.4500;
	points[21] = (309.7902, 17020.7090, 2334.9529);
	angles[21] = (0, 0, 0);
	at[21] = 10.0333;
	points[22] = (181.0929, 16886.6152, 2334.6023);
	angles[22] = (0, 0, 0);
	at[22] = 10.7333;
	points[23] = (108.9008, 16786.4961, 2346.6260);
	angles[23] = (0, 0, 0);
	at[23] = 11.2000;
	points[24] = (93.0961, 16760.2754, 2348.6023);
	angles[24] = (0, 0, 0);
	at[24] = 11.3167;
	points[25] = (43.8807, 16613.3066, 2350.7009);
	angles[25] = (0, 0, 0);
	at[25] = 11.9000;
	points[26] = (42.4744, 16609.0957, 2351.0669);
	angles[26] = (0, 0, 0);
	at[26] = 12.0167;
	points[27] = (42.4744, 16609.0957, 2351.0669);
	angles[27] = (0, 0, 0);
	at[27] = 12.3667;
	points[28] = (49.0311, 16628.6621, 2350.4805);
	angles[28] = (0, 0, 0);
	at[28] = 12.4833;
	points[29] = (100.2965, 16774.5664, 2347.8464);
	angles[29] = (0, 0, 0);
	at[29] = 13.0667;
	points[30] = (191.4807, 16898.9766, 2333.3506);
	angles[30] = (0, 0, 0);
	at[30] = 13.6500;
	points[31] = (299.2992, 17010.3535, 2334.8977);
	angles[31] = (0, 0, 0);
	at[31] = 14.2333;
	points[32] = (323.2941, 17029.6855, 2334.1536);
	angles[32] = (0, 0, 0);
	at[32] = 14.3500;
	points[33] = (452.3347, 17115.3555, 2327.7952);
	angles[33] = (0, 0, 0);
	at[33] = 14.9333;
	points[34] = (509.7756, 17138.5039, 2324.3857);
	angles[34] = (0, 0, 0);
	at[34] = 15.1667;
	points[35] = (654.1890, 17194.8418, 2329.9133);
	angles[35] = (0, 0, 0);
	at[35] = 15.7500;
	points[36] = (862.2756, 17256.3398, 2333.2795);
	angles[36] = (0, 0, 0);
	at[36] = 16.5667;
	points[37] = (1170.8898, 17283.8594, 2340.7048);
	angles[37] = (0, 0, 0);
	at[37] = 17.7333;
	points[38] = (1448.5275, 17255.8672, 2333.1536);
	angles[38] = (0, 0, 0);
	at[38] = 18.7833;
	points[39] = (1478.5669, 17249.7637, 2331.5000);
	angles[39] = (0, 0, 0);
	at[39] = 18.9000;
	points[40] = (1734.1614, 17139.7246, 2317.9370);
	angles[40] = (0, 0, 0);
	at[40] = 19.9500;
	points[41] = (1760.3818, 17123.7793, 2315.4211);
	angles[41] = (0, 0, 0);
	at[41] = 20.0667;
	points[42] = (1808.9882, 17085.3535, 2308.6062);
	angles[42] = (0, 0, 0);
	at[42] = 20.3000;
	points[43] = (1954.7953, 16970, 2308.0237);
	angles[43] = (0, 0, 0);
	at[43] = 21;
	points[44] = (2033.7599, 16836.4961, 2297.0039);
	angles[44] = (0, 0, 0);
	at[44] = 21.5833;
	points[45] = (2065.6260, 16783.3066, 2300.9094);
	angles[45] = (0, 0, 0);
	at[45] = 21.8167;
	points[46] = (2200.3110, 16614.7246, 2323.9097);
	angles[46] = (0, 0, 0);
	at[46] = 22.6333;
	points[47] = (2222.9685, 16595, 2327.8464);
	angles[47] = (0, 0, 0);
	at[47] = 22.7500;
	points[48] = (2325.0354, 16530.7480, 2353.0354);
	angles[48] = (0, 0, 0);
	at[48] = 23.2167;
	points[49] = (2376.0669, 16498.6230, 2371.9922);
	angles[49] = (0, 0, 0);
	at[49] = 23.4500;
	points[50] = (2404.1458, 16491.6543, 2382.4214);
	angles[50] = (0, 0, 0);
	at[50] = 23.5667;
	points[51] = (2576.6064, 16464.0938, 2446.4802);
	angles[51] = (0, 0, 0);
	at[51] = 24.2667;
	points[52] = (2597.1379, 16460.8281, 2454.1064);
	angles[52] = (0, 0, 0);
	at[52] = 24.3833;
	points[53] = (2597.1379, 16460.8281, 2454.1064);
	angles[53] = (0, 0, 0);
	at[53] = 24.8500;
	points[54] = (2590.3110, 16461.9297, 2451.5710);
	angles[54] = (0, 0, 0);
	at[54] = 24.8667;
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
	points[0] = (-4091.7717, 12732.4805, 2100.8269);
	angles[0] = (0, 89.7118, 0);
	at[0] = 0;
	points[1] = (-4398.6221, 12734.0156, 2051.5039);
	angles[1] = (0, 89.7343, 0);
	at[1] = 0.7000;
	points[2] = (-4727.2046, 12735.3145, 2013.7520);
	angles[2] = (0, 89.7745, 0);
	at[2] = 1.4500;
	points[3] = (-4992.9526, 12736.3379, 1994.2441);
	angles[3] = (0, 89.7756, 0);
	at[3] = 2.0500;
	points[4] = (-5258.7402, 12737.4014, 1993.9489);
	angles[4] = (0, 89.7761, 0);
	at[4] = 2.6500;
	points[5] = (-5523.2280, 12738.4258, 2007.9528);
	angles[5] = (0, 89.7716, 0);
	at[5] = 3.2500;
	points[6] = (-5745.3936, 12739.3311, 2024.4883);
	angles[6] = (0, 89.7703, 0);
	at[6] = 3.7500;
	points[7] = (-6163.2676, 12741.0625, 2071.2009);
	angles[7] = (0, 89.8083, 0);
	at[7] = 4.7000;
	points[8] = (-6228.4648, 12741.0625, 2081.6772);
	angles[8] = (0, 90.2840, 0);
	at[8] = 4.8500;
	points[9] = (-6421.0630, 12739.5283, 2134.3623);
	angles[9] = (0, 90.4868, 0);
	at[9] = 5.3000;
	points[10] = (-6435.3540, 12739.4092, 2138.3386);
	angles[10] = (0, 90.4713, 0);
	at[10] = 5.3500;
	points[11] = (-4091.7717, 12732.4805, 2100.8269);
	angles[11] = (0, 89.7118, 0);
	at[11] = 5.3500;
	points[12] = (-4091.7717, 12732.4805, 2100.8269);
	angles[12] = (0, 89.7118, 0);
	at[12] = 5.3667;
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
	points[0] = (-4008.1497, 13079.7246, 2127.4016);
	angles[0] = (0, 89.7118, 0);
	at[0] = 0;
	points[1] = (-4315, 13081.2607, 2078.0789);
	angles[1] = (0, 89.7343, 0);
	at[1] = 0.7000;
	points[2] = (-4643.5825, 13082.5596, 2040.3268);
	angles[2] = (0, 89.7747, 0);
	at[2] = 1.4500;
	points[3] = (-4909.3306, 13083.6221, 2020.8190);
	angles[3] = (0, 89.7748, 0);
	at[3] = 2.0500;
	points[4] = (-5175.1182, 13084.6465, 2020.5237);
	angles[4] = (0, 89.7726, 0);
	at[4] = 2.6500;
	points[5] = (-5439.6064, 13085.7090, 2034.5275);
	angles[5] = (0, 89.7718, 0);
	at[5] = 3.2500;
	points[6] = (-5661.7720, 13086.5742, 2051.0630);
	angles[6] = (0, 89.7736, 0);
	at[6] = 3.7500;
	points[7] = (-6079.6460, 13088.3467, 2097.7795);
	angles[7] = (0, 89.8091, 0);
	at[7] = 4.7000;
	points[8] = (-6144.8423, 13088.3467, 2108.2520);
	angles[8] = (0, 90.2843, 0);
	at[8] = 4.8500;
	points[9] = (-6337.4805, 13086.8115, 2160.9370);
	angles[9] = (0, 90.4863, 0);
	at[9] = 5.3000;
	points[10] = (-6351.7324, 13086.6934, 2164.9133);
	angles[10] = (0, 90.4703, 0);
	at[10] = 5.3500;
	points[11] = (-4008.1497, 13079.7246, 2127.4016);
	angles[11] = (0, 89.7118, 0);
	at[11] = 5.3500;
	points[12] = (-4008.1497, 13079.7246, 2127.4016);
	angles[12] = (0, 89.7118, 0);
	at[12] = 5.3667;
	mover = getEnt("iz_obj_8", "targetname");
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
