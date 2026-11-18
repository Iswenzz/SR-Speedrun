main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gp_snow_panic", 0);

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
	ambientPlay("iz_0_gpsp", 2);
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
	level.iz_route[level.iz_route.size] = (13, -1339, 295);
	level.iz_route[level.iz_route.size] = (13, -2615, 295);
	level.iz_route[level.iz_route.size] = (120, -4268, 326);
	level.iz_route[level.iz_route.size] = (501, -5620, 455);
	level.iz_route[level.iz_route.size] = (405, -6411, 432);
	level.iz_route[level.iz_route.size] = (18, -7534, 310);
	level.iz_route[level.iz_route.size] = (-18, -9237, 295);
	level.iz_route[level.iz_route.size] = (0, -10672, 295);
	level.iz_route[level.iz_route.size] = (7, -11992, 295);
	level.iz_route[level.iz_route.size] = (12, -13086, 295);
	level.iz_route[level.iz_route.size] = (0, -14473, 309);
	level.iz_route[level.iz_route.size] = (185, -15495, 387);
	level.iz_route[level.iz_route.size] = (464, -15861, 464);
	level.iz_route[level.iz_route.size] = (1070, -16121, 520);
	level.iz_route[level.iz_route.size] = (1989, -16026, 680);
	level.iz_route[level.iz_route.size] = (2647, -15418, 835);
	level.iz_route[level.iz_route.size] = (2925, -14444, 1008);
	level.iz_route[level.iz_route.size] = (2602, -13505, 1088);
	level.iz_route[level.iz_route.size] = (1863, -12936, 1113);
	level.iz_route[level.iz_route.size] = (804, -12326, 1344);
	level.iz_route[level.iz_route.size] = (-307, -11715, 1642);
	level.iz_route[level.iz_route.size] = (-826, -11453, 1744);
	level.iz_route[level.iz_route.size] = (-1317, -11154, 1756);
	level.iz_route[level.iz_route.size] = (-2278, -10661, 1741);
	level.iz_route[level.iz_route.size] = (-3376, -10154, 1777);
	level.iz_route[level.iz_route.size] = (-4994, -10265, 1905);
	level.iz_route[level.iz_route.size] = (-6133, -10487, 1850);
	level.iz_route[level.iz_route.size] = (-6582, -10655, 1793);
	level.iz_route[level.iz_route.size] = (-7916, -11090, 1429);
	level.iz_route[level.iz_route.size] = (-9220, -11477, 1122);
	level.iz_route[level.iz_route.size] = (-10337, -11612, 795);
	level.iz_route[level.iz_route.size] = (-11278, -11308, 723);
	level.iz_route[level.iz_route.size] = (-11722, -10442, 565);
	level.iz_route[level.iz_route.size] = (-11566, -9517, 420);
	level.iz_route[level.iz_route.size] = (-10825, -8730, 320);
	level.iz_route[level.iz_route.size] = (-9887, -8159, 295);
	level.iz_route[level.iz_route.size] = (-8812, -7541, 299);
	level.iz_route[level.iz_route.size] = (-8126, -6890, 299);
	level.iz_route[level.iz_route.size] = (-7686, -6182, 299);
	level.iz_route[level.iz_route.size] = (-7349, -5231, 299);
	level.iz_route[level.iz_route.size] = (-7226, -4380, 299);
	level.iz_route[level.iz_route.size] = (-7097, -3143, 295);
	level.iz_route[level.iz_route.size] = (-6512, -2556, 295);
	level.iz_route[level.iz_route.size] = (-5908, -2106, 295);
	level.iz_route[level.iz_route.size] = (-5462, -1452, 295);
	level.iz_route[level.iz_route.size] = (-5293, -799, 295);
	level.iz_route[level.iz_route.size] = (-5215, -20, 295);
	level.iz_route[level.iz_route.size] = (-5008, 529, 340);
	level.iz_route[level.iz_route.size] = (-4424, 1173, 522);
	level.iz_route[level.iz_route.size] = (-3899, 1684, 600);
	level.iz_route[level.iz_route.size] = (-3168, 2354, 620);
	level.iz_route[level.iz_route.size] = (-2356, 3149, 620);
	level.iz_route[level.iz_route.size] = (-1704, 4031, 608);
	level.iz_route[level.iz_route.size] = (-1265, 4880, 586);
	level.iz_route[level.iz_route.size] = (-670, 5374, 572);
	level.iz_route[level.iz_route.size] = (-70, 5308, 535);
	level.iz_route[level.iz_route.size] = (283, 4923, 479);
	level.iz_route[level.iz_route.size] = (381, 4359, 435);
	level.iz_route[level.iz_route.size] = (238, 3556, 389);
	level.iz_route[level.iz_route.size] = (55, 2697, 355);
	level.iz_route[level.iz_route.size] = (3, 1712, 323);
	level.iz_route[level.iz_route.size] = (-11, 736, 295);
	level.iz_route[level.iz_route.size] = (15, -219, 295);
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
	points[0] = (-8023.3862, 22.6809, 733.7599);
	angles[0] = (0, 170.9502, 0.0021);
	at[0] = 0;
	points[1] = (-8026.4565, -191.4087, 733.7599);
	angles[1] = (0, 178.6262, 0);
	at[1] = 0.4833;
	points[2] = (-8002.9922, -403.8268, 733.7599);
	angles[2] = (0, 188.4345, 0);
	at[2] = 0.9667;
	points[3] = (-7885.2754, -557.7244, 733.7599);
	angles[3] = (0, 235.9557, 0);
	at[3] = 1.4500;
	points[4] = (-7671.2207, -561.3819, 733.7599);
	angles[4] = (0, 267.4634, 0);
	at[4] = 1.9333;
	points[5] = (-7467.0083, -556.6457, 675.8858);
	angles[5] = (0, 271.5185, -17.6137);
	at[5] = 2.4167;
	points[6] = (-6658.5044, -530.7048, 394.9567);
	angles[6] = (0, 271.8377, -19.1519);
	at[6] = 4.3500;
	points[7] = (-6376.8110, -531.7717, 307.3248);
	angles[7] = (0, 269.2321, -16.7669);
	at[7] = 4.8333;
	points[8] = (-5954.4487, -472.8819, 296.7740);
	angles[8] = (0, 278.1466, -1.2150);
	at[8] = 5.3167;
	points[9] = (-5541.6143, -377.9772, 295.2815);
	angles[9] = (0, 289.3639, -0.1684);
	at[9] = 5.8000;
	points[10] = (-5222.4805, -104.2835, 295.2953);
	angles[10] = (0, 316.1267, -0.0077);
	at[10] = 6.2833;
	points[11] = (-5047.2051, 279.9713, 317.3315);
	angles[11] = (0, 330.0563, 4.5923);
	at[11] = 6.7667;
	points[12] = (-4785.7480, 608.8701, 386.5244);
	angles[12] = (0, 318.5828, 11.2755);
	at[12] = 7.2500;
	points[13] = (-4495.8662, 909.2835, 481.5945);
	angles[13] = (0, 316.1443, 12.7567);
	at[13] = 7.7333;
	points[14] = (-4210.6694, 1221.7284, 547.1536);
	angles[14] = (0, 317.5894, 8.8687);
	at[14] = 8.2167;
	points[15] = (-3905.2166, 1517.4567, 592.0472);
	angles[15] = (0, 312.9401, 5.2017);
	at[15] = 8.7000;
	points[16] = (-3588.4487, 1804.5394, 611.7678);
	angles[16] = (0, 312.1686, 1.7467);
	at[16] = 9.1833;
	points[17] = (-3270.8977, 2091.5786, 620.7047);
	angles[17] = (0, 311.9009, 1.1003);
	at[17] = 9.6667;
	points[18] = (-2614.4568, 2641.4448, 620.0866);
	angles[18] = (0, 309.9891, -0.0195);
	at[18] = 10.6333;
	points[19] = (-2286.4016, 2916.5671, 619.9213);
	angles[19] = (0, 312.3408, -0.0566);
	at[19] = 11.1167;
	points[20] = (-2100.8701, 3302.9568, 617.1653);
	angles[20] = (0, 333.0187, -0.3506);
	at[20] = 11.6000;
	points[21] = (-1913.5315, 3687.9370, 614.4410);
	angles[21] = (0, 334.0031, -0.3638);
	at[21] = 12.0833;
	points[22] = (-1498.0198, 4436.3779, 593.9134);
	angles[22] = (0, 330.9441, -1.3795);
	at[22] = 13.0500;
	points[23] = (-1253.3229, 4784.5278, 586.7834);
	angles[23] = (0, 321.2928, -0.7027);
	at[23] = 13.5333;
	points[24] = (-969.1890, 5104.7637, 583.0787);
	angles[24] = (0, 316.5856, -0.6756);
	at[24] = 14.0167;
	points[25] = (-592.8544, 5308.3071, 566.9567);
	angles[25] = (0, 299.2699, -2.0913);
	at[25] = 14.5000;
	points[26] = (-186.9524, 5307.7163, 543.0118);
	angles[26] = (0, 262.8852, -3.5572);
	at[26] = 14.9833;
	points[27] = (126.4882, 5033.3071, 499.2284);
	angles[27] = (0, 226.7886, -6.1278);
	at[27] = 15.4667;
	points[28] = (281.3401, 4644.6064, 459.6260);
	angles[28] = (0, 198.6837, -5.2175);
	at[28] = 15.9500;
	points[29] = (317.3858, 4228.7798, 427.5315);
	angles[29] = (0, 177.7053, -3.8753);
	at[29] = 16.4333;
	points[30] = (253.0390, 3806.3071, 403.2008);
	angles[30] = (0, 170.7896, -3.0743);
	at[30] = 16.9167;
	points[31] = (172.8736, 3386.2168, 382.9075);
	angles[31] = (0, 169.2712, -2.7338);
	at[31] = 17.4000;
	points[32] = (107.9728, 2964.0747, 364.4878);
	angles[32] = (0, 173.3733, -2.2138);
	at[32] = 17.8833;
	points[33] = (18.6800, 1683.4292, 322.1779);
	angles[33] = (0, 176.0112, -1.8877);
	at[33] = 19.3333;
	points[34] = (7.0509, 1255.7993, 313.0807);
	angles[34] = (0, 179.4015, -0.9533);
	at[34] = 19.8167;
	points[35] = (7.0553, -28.5299, 295.4217);
	angles[35] = (0, 180, -0.7878);
	at[35] = 21.2667;
	points[36] = (5.9052, -249.9823, 295.2760);
	angles[36] = (0, 179.7021, -0.0371);
	at[36] = 21.7500;
	points[37] = (2.4017, -892.1969, 295.2760);
	angles[37] = (0, 179.6874, 0);
	at[37] = 23.2000;
	points[38] = (-5.4175, -1534.3740, 295.2760);
	angles[38] = (0, 179.2677, 0);
	at[38] = 24.6500;
	points[39] = (-19.9414, -1746.0945, 295.2760);
	angles[39] = (0, 170.7624, 0);
	at[39] = 25.1333;
	points[40] = (-99.0528, -1945.0157, 295.2760);
	angles[40] = (0, 158.9005, 0);
	at[40] = 25.6167;
	points[41] = (-230.7906, -2091.4526, 295.2760);
	angles[41] = (0, 124.2271, 0);
	at[41] = 26.1000;
	points[42] = (-429.5000, -2171.0945, 295.2760);
	angles[42] = (0, 112.4267, 0);
	at[42] = 26.5833;
	points[43] = (-639.7756, -2189.7876, 295.2760);
	angles[43] = (0, 91.8935, 0);
	at[43] = 27.0667;
	points[44] = (-1067.9095, -2189.1694, 295.2760);
	angles[44] = (0, 90.5286, 0);
	at[44] = 28.0333;
	points[45] = (-3850.5828, -2228.9370, 295.2760);
	angles[45] = (0, 90.8188, 0);
	at[45] = 34.3167;
	points[46] = (-4492.5986, -2244.9016, 295.2760);
	angles[46] = (0, 91.4276, 0);
	at[46] = 35.7667;
	points[47] = (-4706.2207, -2246.4724, 295.2760);
	angles[47] = (0, 87.5527, 0);
	at[47] = 36.2500;
	points[48] = (-4914.8818, -2198.4922, 295.2760);
	angles[48] = (0, 77.5446, 0);
	at[48] = 36.7333;
	points[49] = (-5080.7876, -2083.3977, 295.2874);
	angles[49] = (0, 44.7626, 0.0047);
	at[49] = 37.2167;
	points[50] = (-5203.3462, -1909.5826, 295.3043);
	angles[50] = (0, 31.0409, 0.0027);
	at[50] = 37.7000;
	points[51] = (-5276.8901, -1708.5276, 295.2984);
	angles[51] = (0, 20.6034, -0.0013);
	at[51] = 38.1833;
	points[52] = (-5354.6455, -1509.1536, 295.2949);
	angles[52] = (0, 22.2416, 0);
	at[52] = 38.6667;
	points[53] = (-5521.5747, -1114.8779, 295.2933);
	angles[53] = (0, 22.9421, 0);
	at[53] = 39.6333;
	points[54] = (-5594.8818, -913.9371, 295.4232);
	angles[54] = (0, 18.8573, 0.0492);
	at[54] = 40.1167;
	points[55] = (-5661.4961, -710.4961, 295.6398);
	angles[55] = (0, 18.1692, 0.0575);
	at[55] = 40.6000;
	points[56] = (-5740.1968, -512.3779, 295.7697);
	angles[56] = (0, 25.5143, 0.0098);
	at[56] = 41.0833;
	points[57] = (-5950.8657, -139.6512, 295.6488);
	angles[57] = (0, 29.4679, -0.0161);
	at[57] = 42.0500;
	points[58] = (-6126.0234, -17.0762, 295.5232);
	angles[58] = (0, 54.1196, -0.0332);
	at[58] = 42.5333;
	points[59] = (-6322.4805, 60.1307, 295.4977);
	angles[59] = (0, 72.7316, 0.0020);
	at[59] = 43.0167;
	points[60] = (-6532.8740, 89.8618, 295.5756);
	angles[60] = (0, 86.1613, 0.0295);
	at[60] = 43.5000;
	points[61] = (-6746.9688, 91.7244, 295.7106);
	angles[61] = (0, 89.3441, 0.0359);
	at[61] = 43.9833;
	points[62] = (-7175.0786, 95.4496, 295.9811);
	angles[62] = (0, 89.5012, 0.0362);
	at[62] = 44.9500;
	points[63] = (-7388.8584, 86.6354, 296.0921);
	angles[63] = (0, 93.3317, 0.0275);
	at[63] = 45.4333;
	points[64] = (-7816.0234, 57.7969, 296.2890);
	angles[64] = (0, 93.8608, 0.0263);
	at[64] = 46.4000;
	points[65] = (-7940.4331, -77.6512, 296.3547);
	angles[65] = (0, 149.2206, 0.0166);
	at[65] = 46.8833;
	points[66] = (-7970.2759, -287.6764, 296.4398);
	angles[66] = (0, 174.2784, 0.0252);
	at[66] = 47.3667;
	points[67] = (-7972.4805, -501.5355, 296.5449);
	angles[67] = (0, 180.6103, 0.0291);
	at[67] = 47.8500;
	points[68] = (-7966.6533, -715.5315, 296.6559);
	angles[68] = (0, 181.5159, 0.0297);
	at[68] = 48.3333;
	points[69] = (-7911.1812, -915.2678, 296.7929);
	angles[69] = (0, 204.4251, 0.0419);
	at[69] = 48.8167;
	points[70] = (-7802.5591, -1099.7441, 296.9575);
	angles[70] = (0, 210.2017, 0.0440);
	at[70] = 49.3000;
	points[71] = (-7693.9370, -1284.2206, 297.1220);
	angles[71] = (0, 210.4741, 0.0441);
	at[71] = 49.7833;
	points[72] = (-7542.3228, -1432.0079, 296.8594);
	angles[72] = (0, 228.6468, -0.0927);
	at[72] = 50.2667;
	points[73] = (-7047.2441, -1841.1143, 295.6732);
	angles[73] = (0, 230.4298, -0.1058);
	at[73] = 51.7167;
	points[74] = (-6870.2759, -1959.2480, 295.4433);
	angles[74] = (0, 240.1306, -0.0327);
	at[74] = 52.2000;
	points[75] = (-6679.4883, -2056.3701, 295.4032);
	angles[75] = (0, 242.8839, -0.0117);
	at[75] = 52.6833;
	points[76] = (-6107.1650, -2347.7285, 295.2838);
	angles[76] = (0, 243.0202, -0.0107);
	at[76] = 54.1333;
	points[77] = (-5900.3545, -2396.7126, 295.2760);
	angles[77] = (0, 258.7582, 0);
	at[77] = 54.6167;
	points[78] = (-5267.6382, -2506.7795, 295.2760);
	angles[78] = (0, 260.1316, 0);
	at[78] = 56.0667;
	points[79] = (-5056.3389, -2539.2754, 295.2760);
	angles[79] = (0, 263.2538, 0);
	at[79] = 56.5500;
	points[80] = (-4842.2837, -2542.1614, 295.2760);
	angles[80] = (0, 268.9461, 0);
	at[80] = 57.0333;
	points[81] = (-3986.0632, -2553.7007, 295.2760);
	angles[81] = (0, 269.2278, 0);
	at[81] = 58.9667;
	points[82] = (-2487.5552, -2554.5471, 295.2760);
	angles[82] = (0, 270.7900, 0);
	at[82] = 62.3500;
	points[83] = (-776.4567, -2483.0081, 295.2760);
	angles[83] = (0, 272.3942, 0);
	at[83] = 66.2167;
	points[84] = (-564.7047, -2452.1260, 295.2760);
	angles[84] = (0, 278.3687, 0);
	at[84] = 66.7000;
	points[85] = (-141.5252, -2387.0828, 295.2760);
	angles[85] = (0, 278.7372, 0);
	at[85] = 67.6667;
	points[86] = (2.0524, -2233.7324, 295.2760);
	angles[86] = (0, 317.5185, 0);
	at[86] = 68.1500;
	points[87] = (139.6280, -2069.7166, 295.2760);
	angles[87] = (0, 319.8928, 0);
	at[87] = 68.6333;
	points[88] = (185.4433, -1869.3741, 295.2760);
	angles[88] = (0, 353.0573, 0);
	at[88] = 69.1167;
	points[89] = (209.3909, -1441.8937, 295.2760);
	angles[89] = (0, 356.7853, 0);
	at[89] = 70.0833;
	points[90] = (216.7331, -1228.0394, 295.2760);
	angles[90] = (0, 359.2106, 0);
	at[90] = 70.5667;
	points[91] = (209.6276, 56.3894, 295.2756);
	angles[91] = (0, 360.3170, 0);
	at[91] = 73.4667;
	points[92] = (212.0284, 270.4071, 297.0563);
	angles[92] = (0, 358.8171, 0.7449);
	at[92] = 73.9500;
	points[93] = (247.2571, 1554.2008, 318.0835);
	angles[93] = (0, 358.4281, 0.9380);
	at[93] = 76.8500;
	points[94] = (285.0295, 1764.2362, 324.8827);
	angles[94] = (0, 348.6704, 1.9388);
	at[94] = 77.3333;
	points[95] = (510.6851, 2809.8701, 362.6776);
	angles[95] = (0, 347.8218, 2.0235);
	at[95] = 79.7500;
	points[96] = (665.7796, 3651.2678, 397.2480);
	angles[96] = (0, 349.6782, 2.3343);
	at[96] = 81.6833;
	points[97] = (698.1339, 3862.1497, 406.7756);
	angles[97] = (0, 354.2594, 2.9646);
	at[97] = 82.1667;
	points[98] = (694.7678, 4075.7087, 421.1220);
	angles[98] = (0, 360.5898, 3.8024);
	at[98] = 82.6500;
	points[99] = (684.6653, 4716.4175, 464.1614);
	angles[99] = (0, 360.9033, 3.8427);
	at[99] = 84.1000;
	points[100] = (681.2993, 4930, 478.5079);
	angles[100] = (0, 364.3093, 3.9930);
	at[100] = 84.5833;
	points[101] = (550.0827, 5099.8423, 496.0118);
	angles[101] = (0, 395.1115, 4.6653);
	at[101] = 85.0667;
	points[102] = (295.2260, 5442.0869, 530.8268);
	angles[102] = (0, 396.6681, 4.6645);
	at[102] = 86.0333;
	points[103] = (153.2232, 5592.5200, 547.2087);
	angles[103] = (0, 413.4529, 4.2035);
	at[103] = 86.5167;
	points[104] = (-51.5335, 5653.8584, 559.1536);
	angles[104] = (0, 432.3858, 3.2571);
	at[104] = 87;
	points[105] = (-461.0472, 5776.4966, 583.0511);
	angles[105] = (0, 433.3268, 3.1998);
	at[105] = 87.9667;
	points[106] = (-662.2323, 5761.3784, 590.1575);
	angles[106] = (0, 464.8188, 1.3095);
	at[106] = 88.4500;
	points[107] = (-860.3347, 5680.3149, 593.0748);
	angles[107] = (0, 471.9105, 0.8066);
	at[107] = 88.9333;
	points[108] = (-1256.5355, 5518.1104, 598.9134);
	angles[108] = (0, 472.2606, 0.7814);
	at[108] = 89.9000;
	points[109] = (-1389.1104, 5354.4492, 600.1024);
	angles[109] = (0, 502.4839, 0.2960);
	at[109] = 90.3833;
	points[110] = (-1760.9292, 4830.8271, 602.9803);
	angles[110] = (0, 504.6226, 0.2569);
	at[110] = 91.8333;
	points[111] = (-1868.0039, 4645.9053, 606.7047);
	angles[111] = (0, 511.2208, 1.1783);
	at[111] = 92.3167;
	points[112] = (-2170, 4079.2913, 621.0354);
	angles[112] = (0, 511.9426, 1.2783);
	at[112] = 93.7667;
	points[113] = (-2250.6299, 3881.3269, 621.6457);
	angles[113] = (0, 518.7747, -0.0137);
	at[113] = 94.2500;
	points[114] = (-2476.1731, 3280.0120, 620.0787);
	angles[114] = (0, 519.4398, -0.1398);
	at[114] = 95.7000;
	points[115] = (-2619.5317, 3121.3467, 620.0709);
	angles[115] = (0, 498.6103, -0.0062);
	at[115] = 96.1833;
	points[116] = (-2908.4016, 2805.3308, 620.0748);
	angles[116] = (0, 497.5718, 0);
	at[116] = 97.1500;
	points[117] = (-3056.6614, 2651.1377, 619.9174);
	angles[117] = (0, 494.4901, -0.0921);
	at[117] = 97.6333;
	points[118] = (-3687.5747, 2072.1812, 617.6653);
	angles[118] = (0, 492.5408, -0.1507);
	at[118] = 99.5667;
	points[119] = (-3843.1577, 1925.7756, 605.3149);
	angles[119] = (0, 493.3582, -3.7424);
	at[119] = 100.0500;
	points[120] = (-4308.3857, 1485.3779, 559.9134);
	angles[120] = (0, 493.4292, -4.0538);
	at[120] = 101.5000;
	points[121] = (-4462.7163, 1340.1024, 531.5866);
	angles[121] = (0, 493.2103, -8.9967);
	at[121] = 101.9830;
	points[122] = (-4770.3936, 1051.3937, 458.9370);
	angles[122] = (0, 493.1758, -9.7675);
	at[122] = 102.9500;
	points[123] = (-4906.8110, 891.7205, 418.3268);
	angles[123] = (0, 499.9029, -11.0172);
	at[123] = 103.4330;
	points[124] = (-5040.7871, 729.9291, 377.1169);
	angles[124] = (0, 500.3481, -11.0945);
	at[124] = 103.9170;
	points[125] = (-5167.6772, 563.7520, 338.4024);
	angles[125] = (0, 507.4821, -9.1325);
	at[125] = 104.4000;
	points[126] = (-5236.8896, 362.0229, 319.8902);
	angles[126] = (0, 520.4238, -5.1662);
	at[126] = 104.8830;
	points[127] = (-5306.1021, 160.2957, 301.3784);
	angles[127] = (0, 521.0311, -4.9705);
	at[127] = 105.3670;
	points[128] = (-5368.1895, -44.5295, 297.9347);
	angles[128] = (0, 523.1150, -0.9769);
	at[128] = 105.8500;
	points[129] = (-5509.5669, -182.5075, 295.9551);
	angles[129] = (0, 483.9569, -0.4828);
	at[129] = 106.3330;
	points[130] = (-5692.5591, -162.4689, 295.2756);
	angles[130] = (0, 427.9518, -0.1026);
	at[130] = 106.8170;
	points[131] = (-5835.2759, -12.3012, 295.2756);
	angles[131] = (0, 394.4202, -0.0052);
	at[131] = 107.3000;
	points[132] = (-5935.1182, 176.4146, 295.2756);
	angles[132] = (0, 391.2906, 0);
	at[132] = 107.7830;
	points[133] = (-6059.8423, 349.4366, 295.2756);
	angles[133] = (0, 399.4175, 0);
	at[133] = 108.2670;
	points[134] = (-6231.9688, 476.7480, 295.2756);
	angles[134] = (0, 412.8416, 0);
	at[134] = 108.7500;
	points[135] = (-6426.4961, 551.3898, 328.0150);
	angles[135] = (0, 431.9468, 10.5543);
	at[135] = 109.2330;
	points[136] = (-6629.2129, 550.6181, 395.0197);
	angles[136] = (0, 450.1682, 18.2668);
	at[136] = 109.7170;
	points[137] = (-7440.3545, 533.4488, 668.7914);
	angles[137] = (0, 451.2127, 18.6456);
	at[137] = 111.6500;
	points[138] = (-7642.1260, 519.5630, 730.2126);
	angles[138] = (0, 459.7430, 12.9433);
	at[138] = 112.1330;
	points[139] = (-7829.0156, 419.3268, 733.7599);
	angles[139] = (0, 483.3423, 1.3070);
	at[139] = 112.6170;
	points[140] = (-7964.5273, 253.6059, 733.7599);
	angles[140] = (0, 499.9025, 0.0629);
	at[140] = 113.1000;
	points[141] = (-8019.3306, 52.9091, 733.7599);
	angles[141] = (0, 529.1829, 0.0032);
	at[141] = 113.5830;
	points[142] = (-8023.3862, 22.6809, 733.7599);
	angles[142] = (0, 530.9502, 0.0021);
	at[142] = 113.6500;
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
