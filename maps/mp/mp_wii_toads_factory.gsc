main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_toads_factory", 0);

	setExpFog(0, 61515.7461, 1, 0.7451, 0, 0);

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
	level.iz_route[level.iz_route.size] = (8150, -6806, 591);
	level.iz_route[level.iz_route.size] = (8120, -8548, 591);
	level.iz_route[level.iz_route.size] = (7928, -10128, 824);
	level.iz_route[level.iz_route.size] = (7382, -11058, 1000);
	level.iz_route[level.iz_route.size] = (6348, -11339, 1030);
	level.iz_route[level.iz_route.size] = (5271, -11383, 1037);
	level.iz_route[level.iz_route.size] = (4532, -11383, 1033);
	level.iz_route[level.iz_route.size] = (3322, -11102, 1033);
	level.iz_route[level.iz_route.size] = (1432, -11102, 1033);
	level.iz_route[level.iz_route.size] = (89, -11102, 1033);
	level.iz_route[level.iz_route.size] = (-1801, -11102, 1033);
	level.iz_route[level.iz_route.size] = (-3012, -11102, 1033);
	level.iz_route[level.iz_route.size] = (-4311, -11102, 1060);
	level.iz_route[level.iz_route.size] = (-4843, -10837, 1075);
	level.iz_route[level.iz_route.size] = (-5138, -10305, 1039);
	level.iz_route[level.iz_route.size] = (-5167, -8976, 939);
	level.iz_route[level.iz_route.size] = (-5167, -8415, 1033);
	level.iz_route[level.iz_route.size] = (-5167, -8041, 986);
	level.iz_route[level.iz_route.size] = (-5167, -7441, 620);
	level.iz_route[level.iz_route.size] = (-5167, -5020, 502);
	level.iz_route[level.iz_route.size] = (-5153, -2923, 502);
	level.iz_route[level.iz_route.size] = (-5153, -1225, 502);
	level.iz_route[level.iz_route.size] = (-5182, 738, 443);
	level.iz_route[level.iz_route.size] = (-5197, 2200, 384);
	level.iz_route[level.iz_route.size] = (-5153, 3588, 499);
	level.iz_route[level.iz_route.size] = (-4813, 4532, 676);
	level.iz_route[level.iz_route.size] = (-4016, 5049, 788);
	level.iz_route[level.iz_route.size] = (-3115, 4946, 761);
	level.iz_route[level.iz_route.size] = (-2229, 4090, 562);
	level.iz_route[level.iz_route.size] = (-2111, 2982, 304);
	level.iz_route[level.iz_route.size] = (-2096, 2082, 304);
	level.iz_route[level.iz_route.size] = (-1978, 1107, 304);
	level.iz_route[level.iz_route.size] = (-1255, 340, 304);
	level.iz_route[level.iz_route.size] = (-295, 221, 304);
	level.iz_route[level.iz_route.size] = (635, 709, 304);
	level.iz_route[level.iz_route.size] = (989, 1801, 304);
	level.iz_route[level.iz_route.size] = (458, 2953, 305);
	level.iz_route[level.iz_route.size] = (-472, 3720, 403);
	level.iz_route[level.iz_route.size] = (-1211, 4592, 663);
	level.iz_route[level.iz_route.size] = (-1240, 5832, 850);
	level.iz_route[level.iz_route.size] = (-236, 6526, 985);
	level.iz_route[level.iz_route.size] = (1137, 6526, 1215);
	level.iz_route[level.iz_route.size] = (2229, 6511, 1561);
	level.iz_route[level.iz_route.size] = (3514, 6511, 865);
	level.iz_route[level.iz_route.size] = (4769, 6511, 675);
	level.iz_route[level.iz_route.size] = (5846, 6496, 698);
	level.iz_route[level.iz_route.size] = (6895, 6481, 728);
	level.iz_route[level.iz_route.size] = (7899, 6156, 833);
	level.iz_route[level.iz_route.size] = (8091, 5167, 715);
	level.iz_route[level.iz_route.size] = (8120, 4119, 591);
	level.iz_route[level.iz_route.size] = (8120, 2628, 586);
	level.iz_route[level.iz_route.size] = (8120, 1388, 586);
	level.iz_route[level.iz_route.size] = (8120, -325, 586);
	level.iz_route[level.iz_route.size] = (8120, -4090, 591);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3661.4568, -3517.9214, 717.5157);
	angles[0] = (0, 178.2838, 0);
	at[0] = 0;
	points[1] = (-3657.7285, -3671.8857, 716.1929);
	angles[1] = (0, 181.0885, 0);
	at[1] = 0.2500;
	points[2] = (-3635.4373, -4086.2205, 709.8898);
	angles[2] = (0, 182.8918, 0);
	at[2] = 0.9167;
	points[3] = (-3630.7756, -4242.2046, 708.6772);
	angles[3] = (0, 181.7161, 0);
	at[3] = 1.1667;
	points[4] = (-3633.9526, -4396.4961, 709.6929);
	angles[4] = (0, 178.8329, 0);
	at[4] = 1.4167;
	points[5] = (-3638.7715, -4449.6064, 711.0866);
	angles[5] = (0, 177.0025, 0);
	at[5] = 1.5000;
	points[6] = (-3646.9644, -4499.9214, 713.4291);
	angles[6] = (0, 174.1550, 0);
	at[6] = 1.5833;
	points[7] = (-3661.5828, -4547.6377, 717.5630);
	angles[7] = (0, 168.8109, 0);
	at[7] = 1.6667;
	points[8] = (-3685.8623, -4590.9448, 725.0433);
	angles[8] = (0, 161.0718, 0);
	at[8] = 1.7500;
	points[9] = (-3715.2954, -4631.5747, 734.6536);
	angles[9] = (0, 153.9276, 0);
	at[9] = 1.8333;
	points[10] = (-3748.6379, -4671.6929, 745.7008);
	angles[10] = (0, 148.2330, 0);
	at[10] = 1.9167;
	points[11] = (-3853.3228, -4780.0396, 780.2677);
	angles[11] = (0, 137.9063, 0);
	at[11] = 2.1667;
	points[12] = (-3927.9924, -4848.1494, 804.3543);
	angles[12] = (0, 134.0957, 0);
	at[12] = 2.3333;
	points[13] = (-4005.3545, -4913.2285, 828.5236);
	angles[13] = (0, 131.2726, 0);
	at[13] = 2.5000;
	points[14] = (-4125.9844, -5004.6064, 863.9291);
	angles[14] = (0, 127.5213, 0);
	at[14] = 2.7500;
	points[15] = (-4254.6064, -5086.7324, 896.8071);
	angles[15] = (0, 122.8194, 0);
	at[15] = 3;
	points[16] = (-4298.6611, -5109.8032, 906.1142);
	angles[16] = (0, 120.4719, 0);
	at[16] = 3.0833;
	points[17] = (-4347.1260, -5130.4722, 914.3780);
	angles[17] = (0, 117.0747, 0);
	at[17] = 3.1667;
	points[18] = (-4390.7876, -5142.6377, 918.9921);
	angles[18] = (0, 111.8355, 0);
	at[18] = 3.2500;
	points[19] = (-4445.1968, -5151.1812, 921.9567);
	angles[19] = (0, 106.3120, 0);
	at[19] = 3.3333;
	points[20] = (-4493.5435, -5156.1021, 923.5512);
	angles[20] = (0, 101.9112, 0);
	at[20] = 3.4167;
	points[21] = (-4597.9531, -5162.5200, 925.3937);
	angles[21] = (0, 96.2171, 0);
	at[21] = 3.5833;
	points[22] = (-4753.6611, -5165.8662, 926.0670);
	angles[22] = (0, 91.9832, 0);
	at[22] = 3.8333;
	points[23] = (-4961.5356, -5162.7559, 925.0236);
	angles[23] = (0, 89.1462, 0);
	at[23] = 4.1667;
	points[24] = (-5168.6611, -5152.2046, 922.7874);
	angles[24] = (0, 86.9768, 0);
	at[24] = 4.5000;
	points[25] = (-5323.8193, -5138.4644, 920.6851);
	angles[25] = (0, 85.0652, 0);
	at[25] = 4.7500;
	points[26] = (-5425.7876, -5125.2759, 919.2322);
	angles[26] = (0, 83.2620, 0);
	at[26] = 4.9167;
	points[27] = (-5479.3701, -5116.2988, 918.4921);
	angles[27] = (0, 82, 0);
	at[27] = 5;
	points[28] = (-5528.1890, -5106.0234, 917.8662);
	angles[28] = (0, 80.2464, 0);
	at[28] = 5.0833;
	points[29] = (-5580.5903, -5091.1421, 917.3307);
	angles[29] = (0, 77.4023, 0);
	at[29] = 5.1667;
	points[30] = (-5622.6772, -5071.8901, 917.1969);
	angles[30] = (0, 71.8506, 0);
	at[30] = 5.2500;
	points[31] = (-5666.1025, -5042.2441, 917.1969);
	angles[31] = (0, 64.8580, 0);
	at[31] = 5.3333;
	points[32] = (-5704.7241, -5009.2915, 917.1969);
	angles[32] = (0, 58.3575, 0);
	at[32] = 5.4167;
	points[33] = (-5776.5356, -4933.7402, 917.1969);
	angles[33] = (0, 48.1401, 0);
	at[33] = 5.5833;
	points[34] = (-5808.5825, -4894.1733, 917.1969);
	angles[34] = (0, 44.2601, 0);
	at[34] = 5.6667;
	points[35] = (-5868.6221, -4809.7637, 917.1969);
	angles[35] = (0, 38.1066, 0);
	at[35] = 5.8333;
	points[36] = (-5946.8506, -4675.1182, 917.1969);
	angles[36] = (0, 31.0340, 0);
	at[36] = 6.0833;
	points[37] = (-6010.2363, -4533.7793, 917.1969);
	angles[37] = (0, 24.8001, 0);
	at[37] = 6.3333;
	points[38] = (-6043.7007, -4435.8267, 917.1969);
	angles[38] = (0, 20.5497, 0);
	at[38] = 6.5000;
	points[39] = (-6069.0156, -4335.5513, 917.1969);
	angles[39] = (0, 15.9431, 0);
	at[39] = 6.6667;
	points[40] = (-6078.1890, -4284.6460, 917.1969);
	angles[40] = (0, 13.4336, 0);
	at[40] = 6.7500;
	points[41] = (-6088.0708, -4193.7007, 917.1969);
	angles[41] = (0, 8.3125, 0);
	at[41] = 6.9167;
	points[42] = (-6094.2524, -4080.8662, 917.1969);
	angles[42] = (0, 4.7838, 0);
	at[42] = 7.0833;
	points[43] = (-6097.5195, -3984.7244, 917.1969);
	angles[43] = (0, 2.8890, 0);
	at[43] = 7.2500;
	points[44] = (-6101.0239, -3822.8584, 917.1969);
	angles[44] = (0, 1.4872, 0);
	at[44] = 7.5000;
	points[45] = (-6102.3228, -3723.6655, 917.1969);
	angles[45] = (0, 0.9900, 0);
	at[45] = 7.6667;
	points[46] = (-6103.5435, -3563.6497, 917.1969);
	angles[46] = (0, 0.5060, 0);
	at[46] = 7.9167;
	points[47] = (-6103.8579, -3359.3110, 917.1969);
	angles[47] = (0, 0.0836, 0);
	at[47] = 8.2500;
	points[48] = (-6103.3462, -3200.7085, 917.1969);
	angles[48] = (0, -0.1552, 0);
	at[48] = 8.5000;
	points[49] = (-6101.3784, -2943.0237, 917.1969);
	angles[49] = (0, -0.4806, 0);
	at[49] = 8.9167;
	points[50] = (-6094.5669, -2476.6929, 917.1969);
	angles[50] = (0, -0.9895, 0);
	at[50] = 9.6667;
	points[51] = (-6090.0791, -2266.3347, 917.1969);
	angles[51] = (0, -1.2298, 0);
	at[51] = 10;
	points[52] = (-6086.2603, -2115.1851, 917.1969);
	angles[52] = (0, -1.4316, 0);
	at[52] = 10.2500;
	points[53] = (-6081.4961, -1953.7638, 917.1969);
	angles[53] = (0, -1.6787, 0);
	at[53] = 10.5000;
	points[54] = (-6076.2603, -1805.3110, 917.1969);
	angles[54] = (0, -1.9933, 0);
	at[54] = 10.7500;
	points[55] = (-6071.5752, -1693.1023, 917.1969);
	angles[55] = (0, -2.2919, 0);
	at[55] = 10.9167;
	points[56] = (-6066.6538, -1594.8386, 917.1969);
	angles[56] = (0, -2.7156, 0);
	at[56] = 11.0833;
	points[57] = (-6063.5435, -1541.7599, 917.1969);
	angles[57] = (0, -3.0067, 0);
	at[57] = 11.1667;
	points[58] = (-6059.4883, -1483.9685, 917.1969);
	angles[58] = (0, -3.4703, 0);
	at[58] = 11.2500;
	points[59] = (-6049.8428, -1392.3268, 917.2008);
	angles[59] = (0, -5.4585, 0);
	at[59] = 11.4167;
	points[60] = (-6030.2363, -1290.8190, 917.2283);
	angles[60] = (0, -9.5157, 0);
	at[60] = 11.5833;
	points[61] = (-5999.7246, -1192.1141, 917.2952);
	angles[61] = (0, -15.1078, 0);
	at[61] = 11.7500;
	points[62] = (-5979.9609, -1144.8425, 917.3386);
	angles[62] = (0, -18.4253, 0);
	at[62] = 11.8333;
	points[63] = (-5956.6533, -1098.6929, 917.3858);
	angles[63] = (0, -22.1180, 0);
	at[63] = 11.9167;
	points[64] = (-5929.6064, -1054.3977, 917.4330);
	angles[64] = (0, -26.1877, 0);
	at[64] = 12;
	points[65] = (-5899.0552, -1012.9449, 917.4725);
	angles[65] = (0, -30.6545, 0);
	at[65] = 12.0833;
	points[66] = (-5864.8032, -974.6536, 917.5001);
	angles[66] = (0, -35.5343, 0);
	at[66] = 12.1667;
	points[67] = (-5826.5747, -939.7756, 917.5040);
	angles[67] = (0, -40.8251, 0);
	at[67] = 12.2500;
	points[68] = (-5784.8032, -909.2205, 917.4803);
	angles[68] = (0, -46.5059, 0);
	at[68] = 12.3333;
	points[69] = (-5739.8428, -883.6772, 917.4095);
	angles[69] = (0, -52.5451, 0);
	at[69] = 12.4167;
	points[70] = (-5692.2437, -863.6378, 917.2795);
	angles[70] = (0, -58.9004, 0);
	at[70] = 12.5000;
	points[71] = (-5647.4019, -851.1536, 917.1772);
	angles[71] = (0, -65.7814, 0);
	at[71] = 12.5833;
	points[72] = (-5591.8506, -843.0748, 917.3898);
	angles[72] = (0, -72.5029, 0);
	at[72] = 12.6667;
	points[73] = (-5544.1338, -838.6614, 917.6811);
	angles[73] = (0, -77.5849, 0);
	at[73] = 12.7500;
	points[74] = (-5489.3696, -835.1142, 918.0669);
	angles[74] = (0, -81.2175, 0);
	at[74] = 12.8333;
	points[75] = (-5439.4092, -832.8347, 918.4330);
	angles[75] = (0, -83.7959, 0);
	at[75] = 12.9167;
	points[76] = (-5333.6221, -830.1181, 919.2008);
	angles[76] = (0, -86.9881, 0);
	at[76] = 13.0833;
	points[77] = (-5178.5435, -829.8504, 920.1890);
	angles[77] = (0, -89.4702, 0);
	at[77] = 13.3333;
	points[78] = (-4919.7246, -837.0158, 921.1378);
	angles[78] = (0, -91.8360, 0);
	at[78] = 13.7500;
	points[79] = (-4662.3228, -853.9567, 920.4528);
	angles[79] = (0, -94.1579, 0);
	at[79] = 14.1667;
	points[80] = (-4608.4648, -859.1536, 919.9607);
	angles[80] = (0, -94.7595, 0);
	at[80] = 14.2500;
	points[81] = (-4507.6772, -871.2205, 918.4803);
	angles[81] = (0, -96.2857, 0);
	at[81] = 14.4167;
	points[82] = (-4453.3857, -879.4764, 917.2480);
	angles[82] = (0, -97.3552, 0);
	at[82] = 14.5000;
	points[83] = (-4404.9214, -888.4724, 915.7284);
	angles[83] = (0, -98.7836, 0);
	at[83] = 14.5833;
	points[84] = (-4351.4961, -901.3307, 913.2795);
	angles[84] = (0, -100.9682, 0);
	at[84] = 14.6667;
	points[85] = (-4307.8345, -916.7559, 909.9567);
	angles[85] = (0, -104.9973, 0);
	at[85] = 14.7500;
	points[86] = (-4263.9766, -940.3347, 903.9843);
	angles[86] = (0, -110.7493, 0);
	at[86] = 14.8333;
	points[87] = (-4221.4565, -968.9528, 896.1299);
	angles[87] = (0, -116.3701, 0);
	at[87] = 14.9167;
	points[88] = (-4180.4331, -1000.5040, 887.2284);
	angles[88] = (0, -121.0918, 0);
	at[88] = 15;
	points[89] = (-4104.0156, -1067.4883, 868.1378);
	angles[89] = (0, -128.0211, 0);
	at[89] = 15.1667;
	points[90] = (-4031.8899, -1138.8583, 847.9725);
	angles[90] = (0, -132.6149, 0);
	at[90] = 15.3333;
	points[91] = (-3962.9924, -1213.7244, 827.2914);
	angles[91] = (0, -135.9377, 0);
	at[91] = 15.5000;
	points[92] = (-3897.2480, -1291.4489, 806.5433);
	angles[92] = (0, -138.6425, 0);
	at[92] = 15.6667;
	points[93] = (-3834.9922, -1371.5079, 786.1732);
	angles[93] = (0, -141.1271, 0);
	at[93] = 15.8333;
	points[94] = (-3776.2520, -1454.4135, 766.4371);
	angles[94] = (0, -143.6907, 0);
	at[94] = 16;
	points[95] = (-3721.6340, -1540.9607, 747.7677);
	angles[95] = (0, -146.6498, 0);
	at[95] = 16.1667;
	points[96] = (-3673.3389, -1631.4409, 731.1890);
	angles[96] = (0, -150.5341, 0);
	at[96] = 16.3333;
	points[97] = (-3652.8308, -1678.3820, 724.2480);
	angles[97] = (0, -153.1438, 0);
	at[97] = 16.4167;
	points[98] = (-3636.0354, -1726.8307, 718.7795);
	angles[98] = (0, -156.6583, 0);
	at[98] = 16.5000;
	points[99] = (-3626.0669, -1770.3346, 715.7638);
	angles[99] = (0, -161.3263, 0);
	at[99] = 16.5833;
	points[100] = (-3614.7795, -1875.2205, 712.1221);
	angles[100] = (0, -169.9887, 0);
	at[100] = 16.7500;
	points[101] = (-3612.0747, -1925.2205, 711.1260);
	angles[101] = (0, -172.8885, 0);
	at[101] = 16.8333;
	points[102] = (-3610.1929, -1979.8898, 710.3347);
	angles[102] = (0, -175.0462, 0);
	at[102] = 16.9167;
	points[103] = (-3608.7126, -2081.5354, 709.4292);
	angles[103] = (0, -177.8406, 0);
	at[103] = 17.0833;
	points[104] = (-3609.0828, -2188.4529, 709.0118);
	angles[104] = (0, -179.4484, 0);
	at[104] = 17.2500;
	points[105] = (-3610.6892, -2289.6377, 708.9646);
	angles[105] = (0, -180.4482, 0);
	at[105] = 17.4167;
	points[106] = (-3622.5552, -2653.6377, 710.5079);
	angles[106] = (0, -182.1242, 0);
	at[106] = 18;
	points[107] = (-3649.7993, -3222.8623, 715.4449);
	angles[107] = (0, -182.8503, 0);
	at[107] = 18.9167;
	points[108] = (-3660.8899, -3484.8425, 717.4606);
	angles[108] = (0, -182.1594, 0);
	at[108] = 19.3333;
	points[109] = (-3661.4568, -3517.9214, 717.5157);
	angles[109] = (0, -181.7161, 0);
	at[109] = 19.4000;
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
	points[0] = (-6200.8662, -11043.8584, 1484.4567);
	angles[0] = (0, -15.9584, 0);
	at[0] = 0;
	points[1] = (-6197.6772, -11009.3311, 1483.1417);
	angles[1] = (0, -12.1307, 0);
	at[1] = 0.0667;
	points[2] = (-6195.6299, -10964.9609, 1481.9529);
	angles[2] = (0, -8.7742, 0);
	at[2] = 0.1333;
	points[3] = (-6194.5278, -10884.0547, 1480.4213);
	angles[3] = (0, -4.0821, 0);
	at[3] = 0.2667;
	points[4] = (-6195.3149, -10796.4570, 1479.2441);
	angles[4] = (0, -1.3962, 0);
	at[4] = 0.4000;
	points[5] = (-6197.0869, -10717.2051, 1478.4409);
	angles[5] = (0, 0.1610, 0);
	at[5] = 0.5333;
	points[6] = (-6199.7246, -10631.7324, 1477.7717);
	angles[6] = (0, 1.1143, 0);
	at[6] = 0.6667;
	points[7] = (-6204.5669, -10509.0947, 1477.0787);
	angles[7] = (0, 1.9807, 0);
	at[7] = 0.8667;
	points[8] = (-6234.9214, -9970.0391, 1476.7441);
	angles[8] = (0, 3.6541, 0);
	at[8] = 1.7333;
	points[9] = (-6249.8428, -9763.4648, 1477.7520);
	angles[9] = (0, 4.1623, 0);
	at[9] = 2.0667;
	points[10] = (-6256.6538, -9677.9131, 1478.4292);
	angles[10] = (0, 4.4034, 0);
	at[10] = 2.2000;
	points[11] = (-6263.3467, -9599.0156, 1479.2402);
	angles[11] = (0, 4.6880, 0);
	at[11] = 2.3333;
	points[12] = (-6271.4175, -9511.7324, 1480.4370);
	angles[12] = (0, 5.0738, 0);
	at[12] = 2.4667;
	points[13] = (-6275.3545, -9472.9531, 1481.1261);
	angles[13] = (0, 5.3323, 0);
	at[13] = 2.5333;
	points[14] = (-6285.3149, -9387.4404, 1483.3031);
	angles[14] = (0, 6.2252, 0);
	at[14] = 2.6667;
	points[15] = (-6290.6299, -9352.9922, 1484.8190);
	angles[15] = (0, 7.2153, 0);
	at[15] = 2.7333;
	points[16] = (-6309.3311, -9272.7559, 1492.4803);
	angles[16] = (0, 11.0300, 0);
	at[16] = 2.8667;
	points[17] = (-6336.0635, -9195.5518, 1505.2363);
	angles[17] = (0, 16.0186, 0);
	at[17] = 3;
	points[18] = (-6370.0791, -9122.1660, 1521.8898);
	angles[18] = (0, 21.4573, 0);
	at[18] = 3.1333;
	points[19] = (-6389.8818, -9086.9287, 1531.3937);
	angles[19] = (0, 24.3149, 0);
	at[19] = 3.2000;
	points[20] = (-6435.1182, -9020.6689, 1551.9055);
	angles[20] = (0, 30.4937, 0);
	at[20] = 3.3333;
	points[21] = (-6460.6694, -8990.3154, 1562.5000);
	angles[21] = (0, 34.0107, 0);
	at[21] = 3.4000;
	points[22] = (-6488.9370, -8962.0078, 1573.0945);
	angles[22] = (0, 38.0660, 0);
	at[22] = 3.4667;
	points[23] = (-6520.3149, -8936.9297, 1583.1497);
	angles[23] = (0, 43.0500, 0);
	at[23] = 3.5333;
	points[24] = (-6555.3154, -8917.2441, 1591.5709);
	angles[24] = (0, 49.7688, 0);
	at[24] = 3.6000;
	points[25] = (-6593.8979, -8906.2207, 1597.4607);
	angles[25] = (0, 58.5222, 0);
	at[25] = 3.6667;
	points[26] = (-6633.0317, -8899.6064, 1602.3110);
	angles[26] = (0, 66.2092, 0);
	at[26] = 3.7333;
	points[27] = (-6715.5122, -8890.9453, 1611.3781);
	angles[27] = (0, 76.6067, 0);
	at[27] = 3.8667;
	points[28] = (-6840.1182, -8884.4883, 1624.0552);
	angles[28] = (0, 84.3699, 0);
	at[28] = 4.0667;
	points[29] = (-7004.9604, -8883.5430, 1640.6143);
	angles[29] = (0, 89.0535, 0);
	at[29] = 4.3333;
	points[30] = (-7128.0708, -8888.2676, 1653.6732);
	angles[30] = (0, 91.5705, 0);
	at[30] = 4.5333;
	points[31] = (-7209.8818, -8895.0791, 1663.2638);
	angles[31] = (0, 93.6049, 0);
	at[31] = 4.6667;
	points[32] = (-7292.8350, -8908.1895, 1674.9922);
	angles[32] = (0, 97.2066, 0);
	at[32] = 4.8000;
	points[33] = (-7328.6611, -8919.8037, 1682.2086);
	angles[33] = (0, 101.5193, 0);
	at[33] = 4.8667;
	points[34] = (-7364.2910, -8938.5039, 1693.1104);
	angles[34] = (0, 107.2779, 0);
	at[34] = 4.9333;
	points[35] = (-7397.2441, -8959.9219, 1705.4922);
	angles[35] = (0, 112.7521, 0);
	at[35] = 5;
	points[36] = (-7458.8975, -9008.2285, 1732.1890);
	angles[36] = (0, 121.7771, 0);
	at[36] = 5.1333;
	points[37] = (-7542.7168, -9090.5908, 1772.9686);
	angles[37] = (0, 131.5903, 0);
	at[37] = 5.3333;
	points[38] = (-7615.7480, -9183.3857, 1811.0669);
	angles[38] = (0, 139.7087, 0);
	at[38] = 5.5333;
	points[39] = (-7656.9688, -9251.6143, 1833.1693);
	angles[39] = (0, 145.4427, 0);
	at[39] = 5.6667;
	points[40] = (-7689.4883, -9325.4326, 1850.5591);
	angles[40] = (0, 152.2815, 0);
	at[40] = 5.8000;
	points[41] = (-7701.3384, -9364.9609, 1856.7048);
	angles[41] = (0, 156.3931, 0);
	at[41] = 5.8667;
	points[42] = (-7713.3467, -9439.8027, 1862.3898);
	angles[42] = (0, 165.2499, 0);
	at[42] = 6;
	points[43] = (-7717.5195, -9486.3389, 1864.2953);
	angles[43] = (0, 168.6581, 0);
	at[43] = 6.0667;
	points[44] = (-7722.5986, -9564.8428, 1866.6102);
	angles[44] = (0, 173.0917, 0);
	at[44] = 6.2000;
	points[45] = (-7724.8428, -9609.5273, 1867.6260);
	angles[45] = (0, 174.4985, 0);
	at[45] = 6.2667;
	points[46] = (-7728.1494, -9689.8428, 1869.0985);
	angles[46] = (0, 176.3438, 0);
	at[46] = 6.4000;
	points[47] = (-7734.9609, -9982.2441, 1872.0708);
	angles[47] = (0, 178.8098, 0);
	at[47] = 6.8667;
	points[48] = (-7735.8662, -10396.6143, 1872.2874);
	angles[48] = (0, 180.2195, 0);
	at[48] = 7.5333;
	points[49] = (-7729.1343, -10730.4336, 1869.1692);
	angles[49] = (0, 181.4889, 0);
	at[49] = 8.0667;
	points[50] = (-7725.9844, -10810.0781, 1867.7599);
	angles[50] = (0, 181.9738, 0);
	at[50] = 8.2000;
	points[51] = (-7721.3779, -10896.8896, 1865.7087);
	angles[51] = (0, 182.6722, 0);
	at[51] = 8.3333;
	points[52] = (-7718.7402, -10935.1191, 1864.5472);
	angles[52] = (0, 183.1495, 0);
	at[52] = 8.4000;
	points[53] = (-7710.1973, -11020.8662, 1860.8229);
	angles[53] = (0, 184.8826, 0);
	at[53] = 8.5333;
	points[54] = (-7704.2910, -11055.5117, 1858.2480);
	angles[54] = (0, 186.7511, 0);
	at[54] = 8.6000;
	points[55] = (-7681.1812, -11134.0547, 1847.3661);
	angles[55] = (0, 192.8064, 0);
	at[55] = 8.7333;
	points[56] = (-7631.3384, -11245.2363, 1823.2284);
	angles[56] = (0, 201.6247, 0);
	at[56] = 8.9333;
	points[57] = (-7591.8110, -11315.6299, 1804.1930);
	angles[57] = (0, 206.2327, 0);
	at[57] = 9.0667;
	points[58] = (-7548.5825, -11383.4648, 1783.6772);
	angles[58] = (0, 210.0033, 0);
	at[58] = 9.2000;
	points[59] = (-7502.1650, -11448.8975, 1762.1653);
	angles[59] = (0, 213.2403, 0);
	at[59] = 9.3333;
	points[60] = (-7452.7163, -11511.8506, 1740.0276);
	angles[60] = (0, 216.2544, 0);
	at[60] = 9.4667;
	points[61] = (-7399.8423, -11571.8896, 1717.6377);
	angles[61] = (0, 219.4281, 0);
	at[61] = 9.6000;
	points[62] = (-7342.5596, -11627.4014, 1695.7638);
	angles[62] = (0, 223.5416, 0);
	at[62] = 9.7333;
	points[63] = (-7310.5903, -11652.5596, 1685.4016);
	angles[63] = (0, 226.7269, 0);
	at[63] = 9.8000;
	points[64] = (-7278.7007, -11670.2754, 1677.6300);
	angles[64] = (0, 232.3333, 0);
	at[64] = 9.8667;
	points[65] = (-7238.8975, -11682.7959, 1670.6653);
	angles[65] = (0, 239.7186, 0);
	at[65] = 9.9333;
	points[66] = (-7198.7407, -11691.1807, 1664.7284);
	angles[66] = (0, 246.2830, 0);
	at[66] = 10;
	points[67] = (-7116.7324, -11701.9688, 1654.0709);
	angles[67] = (0, 255.8550, 0);
	at[67] = 10.1333;
	points[68] = (-7034.7637, -11707.6777, 1644.3700);
	angles[68] = (0, 261.8398, 0);
	at[68] = 10.2667;
	points[69] = (-6911.1025, -11709.7246, 1630.5354);
	angles[69] = (0, 267.3602, 0);
	at[69] = 10.4667;
	points[70] = (-6746.2993, -11700.6309, 1612.3466);
	angles[70] = (0, 272.8058, 0);
	at[70] = 10.7333;
	points[71] = (-6664.2520, -11688.6221, 1602.7362);
	angles[71] = (0, 276.3209, 0);
	at[71] = 10.8667;
	points[72] = (-6625.6694, -11679.4482, 1597.7678);
	angles[72] = (0, 279.0178, 0);
	at[72] = 10.9333;
	points[73] = (-6587.1650, -11664.7637, 1591.9802);
	angles[73] = (0, 283.8546, 0);
	at[73] = 11;
	points[74] = (-6554.8423, -11642.6377, 1585.5354);
	angles[74] = (0, 291.2493, 0);
	at[74] = 11.0667;
	points[75] = (-6524.6064, -11616.0635, 1578.5708);
	angles[75] = (0, 298.3441, 0);
	at[75] = 11.1333;
	points[76] = (-6442.1655, -11525.0391, 1557.1536);
	angles[76] = (0, 313.0134, 0);
	at[76] = 11.3333;
	points[77] = (-6369.2915, -11426.1025, 1536.5197);
	angles[77] = (0, 321.1172, 0);
	at[77] = 11.5333;
	points[78] = (-6304.8428, -11321.5352, 1517.3661);
	angles[78] = (0, 326.8075, 0);
	at[78] = 11.7333;
	points[79] = (-6250.1973, -11211.1816, 1500.5237);
	angles[79] = (0, 332.3613, 0);
	at[79] = 11.9333;
	points[80] = (-6221.4175, -11134.0156, 1491.3503);
	angles[80] = (0, 336.8939, 0);
	at[80] = 12.0667;
	points[81] = (-6210.3154, -11094.1729, 1487.7047);
	angles[81] = (0, 339.6871, 0);
	at[81] = 12.1333;
	points[82] = (-6200.8662, -11043.8584, 1484.4567);
	angles[82] = (0, 344.0416, 0);
	at[82] = 12.2167;
	mover = getEnt("iz_obj_1", "targetname");
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
