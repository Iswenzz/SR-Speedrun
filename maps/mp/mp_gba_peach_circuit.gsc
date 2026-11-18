main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_peach_circuit", 0);

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
	ambientPlay("iz_0_36", 2);
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
	level.iz_route[level.iz_route.size] = (291, -6938, 797);
	level.iz_route[level.iz_route.size] = (476, -8410, 797);
	level.iz_route[level.iz_route.size] = (1663, -8939, 797);
	level.iz_route[level.iz_route.size] = (2859, -8142, 797);
	level.iz_route[level.iz_route.size] = (4048, -6841, 813);
	level.iz_route[level.iz_route.size] = (5328, -5615, 785);
	level.iz_route[level.iz_route.size] = (6470, -3976, 757);
	level.iz_route[level.iz_route.size] = (5992, -2623, 757);
	level.iz_route[level.iz_route.size] = (5094, -1513, 757);
	level.iz_route[level.iz_route.size] = (4662, -278, 757);
	level.iz_route[level.iz_route.size] = (5507, 935, 757);
	level.iz_route[level.iz_route.size] = (6480, 1872, 757);
	level.iz_route[level.iz_route.size] = (7150, 3198, 757);
	level.iz_route[level.iz_route.size] = (6332, 4547, 761);
	level.iz_route[level.iz_route.size] = (5121, 5659, 797);
	level.iz_route[level.iz_route.size] = (4012, 6646, 797);
	level.iz_route[level.iz_route.size] = (3578, 7552, 797);
	level.iz_route[level.iz_route.size] = (3199, 8278, 797);
	level.iz_route[level.iz_route.size] = (2393, 8794, 797);
	level.iz_route[level.iz_route.size] = (1320, 8095, 797);
	level.iz_route[level.iz_route.size] = (585, 7006, 797);
	level.iz_route[level.iz_route.size] = (-501, 6319, 797);
	level.iz_route[level.iz_route.size] = (-1841, 6263, 797);
	level.iz_route[level.iz_route.size] = (-2728, 6263, 824);
	level.iz_route[level.iz_route.size] = (-3551, 6262, 801);
	level.iz_route[level.iz_route.size] = (-4918, 6245, 797);
	level.iz_route[level.iz_route.size] = (-6271, 5874, 797);
	level.iz_route[level.iz_route.size] = (-7650, 4491, 797);
	level.iz_route[level.iz_route.size] = (-8187, 2878, 797);
	level.iz_route[level.iz_route.size] = (-7340, 2019, 797);
	level.iz_route[level.iz_route.size] = (-6116, 2016, 797);
	level.iz_route[level.iz_route.size] = (-4833, 2035, 797);
	level.iz_route[level.iz_route.size] = (-3895, 2038, 805);
	level.iz_route[level.iz_route.size] = (-2992, 2052, 816);
	level.iz_route[level.iz_route.size] = (-1671, 2043, 797);
	level.iz_route[level.iz_route.size] = (11, 1890, 797);
	level.iz_route[level.iz_route.size] = (290, 232, 797);
	level.iz_route[level.iz_route.size] = (274, -2184, 797);
	level.iz_route[level.iz_route.size] = (270, -4716, 797);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4684.0552, 6648.3071, 797.2441);
	angles[0] = (0, 177.9664, 0);
	at[0] = 0;
	points[1] = (-4692.2832, 6282.9922, 797.2441);
	angles[1] = (0, 179.4802, 0);
	at[1] = 4.1167;
	points[2] = (-4691.5356, 6167.0864, 797.2441);
	angles[2] = (0, 181.5058, 0);
	at[2] = 5.4167;
	points[3] = (-4687.9922, 6111.3784, 797.2441);
	angles[3] = (0, 186.4308, 0);
	at[3] = 6.0667;
	points[4] = (-4679.7637, 6074.0942, 797.2441);
	angles[4] = (0, 194.7968, 0);
	at[4] = 6.5000;
	points[5] = (-4668.2676, 6037.1650, 797.2441);
	angles[5] = (0, 198.2414, 0);
	at[5] = 6.9333;
	points[6] = (-4608.7007, 5874.3701, 797.2441);
	angles[6] = (0, 199.6660, 0);
	at[6] = 8.8833;
	points[7] = (-4580.5908, 5782.3618, 797.2441);
	angles[7] = (0, 193.5230, 0);
	at[7] = 9.9667;
	points[8] = (-4574.6064, 5744.5669, 797.2441);
	angles[8] = (0, 185.5324, 0);
	at[8] = 10.4000;
	points[9] = (-4575.0396, 5724.8032, 797.2441);
	angles[9] = (0, 176.2678, 0);
	at[9] = 10.6167;
	points[10] = (-4579.8428, 5708.6221, 797.2441);
	angles[10] = (0, 160.0235, 0);
	at[10] = 10.8333;
	points[11] = (-4589.9214, 5690.8267, 797.2441);
	angles[11] = (0, 149.2333, 0);
	at[11] = 11.0500;
	points[12] = (-4600.2759, 5676.1025, 797.2441);
	angles[12] = (0, 144.3122, 0);
	at[12] = 11.2667;
	points[13] = (-4664.2520, 5603.6221, 797.2441);
	angles[13] = (0, 135.7169, 0);
	at[13] = 12.3500;
	points[14] = (-4749.1338, 5524.6460, 797.2441);
	angles[14] = (0, 130.8064, 0);
	at[14] = 13.6500;
	points[15] = (-4824.8032, 5465.0791, 797.2441);
	angles[15] = (0, 125.7925, 0);
	at[15] = 14.7333;
	points[16] = (-4874.0947, 5433.8584, 797.2441);
	angles[16] = (0, 119.2739, 0);
	at[16] = 15.3833;
	points[17] = (-4890.2754, 5425.9844, 797.2441);
	angles[17] = (0, 114.8659, 0);
	at[17] = 15.6000;
	points[18] = (-4909.6851, 5419.6455, 797.2441);
	angles[18] = (0, 105.1184, 0);
	at[18] = 15.8167;
	points[19] = (-4926.1812, 5419.7241, 797.2441);
	angles[19] = (0, 85.7387, 0);
	at[19] = 16.0333;
	points[20] = (-4945.4727, 5425.3149, 797.2441);
	angles[20] = (0, 72.0748, 0);
	at[20] = 16.2500;
	points[21] = (-4980.2363, 5441.7715, 797.2441);
	angles[21] = (0, 62.1799, 0);
	at[21] = 16.6833;
	points[22] = (-5044.9214, 5482.9526, 797.2441);
	angles[22] = (0, 55.0011, 0);
	at[22] = 17.5500;
	points[23] = (-5120.9844, 5542.3623, 797.2441);
	angles[23] = (0, 49.8557, 0);
	at[23] = 18.6333;
	points[24] = (-5177.7559, 5594.3306, 797.2441);
	angles[24] = (0, 45.6831, 0);
	at[24] = 19.5000;
	points[25] = (-5217.0869, 5636.2598, 797.2441);
	angles[25] = (0, 41.1758, 0);
	at[25] = 20.1500;
	points[26] = (-5241.0630, 5666.8506, 797.2441);
	angles[26] = (0, 36.0066, 0);
	at[26] = 20.5833;
	points[27] = (-5259.9604, 5700, 797.2441);
	angles[27] = (0, 24.7485, 0);
	at[27] = 21.0167;
	points[28] = (-5264.8428, 5716.1021, 797.2441);
	angles[28] = (0, 15.1724, 0);
	at[28] = 21.2333;
	points[29] = (-5268.2676, 5736.7324, 797.2441);
	angles[29] = (0, 8.5185, 0);
	at[29] = 21.4500;
	points[30] = (-5269.9604, 5754.6064, 797.2441);
	angles[30] = (0, 5.0278, 0);
	at[30] = 21.6667;
	points[31] = (-5271.1416, 5851.9688, 797.2441);
	angles[31] = (0, -1.2995, 0);
	at[31] = 22.7500;
	points[32] = (-5253.9370, 6159.0552, 797.2441);
	angles[32] = (0, -3.1525, 0);
	at[32] = 26.2167;
	points[33] = (-5250.5122, 6256.0239, 797.2441);
	angles[33] = (0, -0.6230, 0);
	at[33] = 27.3000;
	points[34] = (-5252.6382, 6313.1890, 797.2441);
	angles[34] = (0, 5.0836, 0);
	at[34] = 27.9500;
	points[35] = (-5255.0791, 6329.7241, 797.2441);
	angles[35] = (0, 9.3343, 0);
	at[35] = 28.1667;
	points[36] = (-5264.3701, 6367.7168, 797.2441);
	angles[36] = (0, 15.3407, 0);
	at[36] = 28.6000;
	points[37] = (-5301.2598, 6477.3618, 797.2441);
	angles[37] = (0, 20.0207, 0);
	at[37] = 29.9000;
	points[38] = (-5381.5747, 6694.1343, 797.2441);
	angles[38] = (0, 19.3690, 0);
	at[38] = 32.5000;
	points[39] = (-5415.1973, 6805, 797.2441);
	angles[39] = (0, 13.4067, 0);
	at[39] = 33.8000;
	points[40] = (-5421.3384, 6842.9136, 797.2441);
	angles[40] = (0, 6.1987, 0);
	at[40] = 34.2333;
	points[41] = (-5421.1025, 6861.4570, 797.2441);
	angles[41] = (0, -3.4859, 0);
	at[41] = 34.4500;
	points[42] = (-5416.3784, 6878.1104, 797.2441);
	angles[42] = (0, -18.3317, 0);
	at[42] = 34.6667;
	points[43] = (-5407.2837, 6895.8271, 797.2441);
	angles[43] = (0, -28.7296, 0);
	at[43] = 34.8833;
	points[44] = (-5396.9292, 6911.3779, 797.2441);
	angles[44] = (0, -34.3933, 0);
	at[44] = 35.1000;
	points[45] = (-5345.9053, 6969.4092, 797.2441);
	angles[45] = (0, -44.8384, 0);
	at[45] = 35.9667;
	points[46] = (-5288.6616, 7021.0635, 797.2441);
	angles[46] = (0, -49.9165, 0);
	at[46] = 36.8333;
	points[47] = (-5211.6538, 7079.2910, 797.2441);
	angles[47] = (0, -55.3208, 0);
	at[47] = 37.9167;
	points[48] = (-5145.8267, 7119.2520, 797.2441);
	angles[48] = (0, -61.9180, 0);
	at[48] = 38.7833;
	points[49] = (-5110.2754, 7134.7246, 797.2441);
	angles[49] = (0, -69.7829, 0);
	at[49] = 39.2167;
	points[50] = (-5092.6377, 7138.8584, 797.2441);
	angles[50] = (0, -79.5364, 0);
	at[50] = 39.4333;
	points[51] = (-5074.8818, 7138.5039, 797.2441);
	angles[51] = (0, -93.0885, 0);
	at[51] = 39.6500;
	points[52] = (-5055.5122, 7135.1577, 797.2441);
	angles[52] = (0, -100.8217, 0);
	at[52] = 39.8667;
	points[53] = (-5000.3149, 7118.8584, 797.2441);
	angles[53] = (0, -108.8579, 0);
	at[53] = 40.5167;
	points[54] = (-4928.1104, 7090.3936, 797.2441);
	angles[54] = (0, -113.0580, 0);
	at[54] = 41.3833;
	points[55] = (-4840.7876, 7049.7637, 797.2441);
	angles[55] = (0, -116.3184, 0);
	at[55] = 42.4667;
	points[56] = (-4772.8740, 7013.9375, 797.2441);
	angles[56] = (0, -118.9711, 0);
	at[56] = 43.3333;
	points[57] = (-4706.3389, 6973.3467, 797.2441);
	angles[57] = (0, -123.9102, 0);
	at[57] = 44.2000;
	points[58] = (-4676.6538, 6949.6064, 797.2441);
	angles[58] = (0, -133.2979, 0);
	at[58] = 44.6333;
	points[59] = (-4666.8110, 6934.8032, 797.2441);
	angles[59] = (0, -150.0524, 0);
	at[59] = 44.8500;
	points[60] = (-4661.1812, 6916.5747, 797.2441);
	angles[60] = (0, -164.9946, 0);
	at[60] = 45.0667;
	points[61] = (-4658.6616, 6897.4414, 797.2441);
	angles[61] = (0, -173.6872, 0);
	at[61] = 45.2833;
	points[62] = (-4660.0396, 6839.6460, 797.2441);
	angles[62] = (0, -184.6337, 0);
	at[62] = 45.9333;
	points[63] = (-4675.9448, 6725.1973, 797.2441);
	angles[63] = (0, -188.6340, 0);
	at[63] = 47.2333;
	points[64] = (-4684.0552, 6648.3071, 797.2441);
	angles[64] = (0, -182.0336, 0);
	at[64] = 48.1167;
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
	points[0] = (-8947.6768, 2967.4766, 797.2441);
	angles[0] = (0, -155.3665, 0);
	at[0] = 0;
	points[1] = (-8935.3154, 2950.8701, 797.2441);
	angles[1] = (0, -141.5414, 0);
	at[1] = 0.2333;
	points[2] = (-8921.2207, 2935.9802, 797.2441);
	angles[2] = (0, -135.7313, 0);
	at[2] = 0.4667;
	points[3] = (-8874.0947, 2895.5510, 797.2441);
	angles[3] = (0, -128.0518, 0);
	at[3] = 1.1667;
	points[4] = (-8805.2363, 2849.2283, 797.2441);
	angles[4] = (0, -120.7339, 0);
	at[4] = 2.1000;
	points[5] = (-8768.6221, 2829.8740, 797.2441);
	angles[5] = (0, -116.0710, 0);
	at[5] = 2.5667;
	points[6] = (-8730.3154, 2814.4604, 797.2441);
	angles[6] = (0, -109.1362, 0);
	at[6] = 3.0333;
	points[7] = (-8689.4092, 2806.1458, 797.2441);
	angles[7] = (0, -95.8452, 0);
	at[7] = 3.5000;
	points[8] = (-8670.2363, 2807.1851, 797.2441);
	angles[8] = (0, -83.5696, 0);
	at[8] = 3.7333;
	points[9] = (-8651.0635, 2812.4253, 797.2441);
	angles[9] = (0, -73.3987, 0);
	at[9] = 3.9667;
	points[10] = (-8631.2598, 2819.8818, 797.2441);
	angles[10] = (0, -68.6373, 0);
	at[10] = 4.2000;
	points[11] = (-8500.9844, 2883.8110, 797.2441);
	angles[11] = (0, -62.0489, 0);
	at[11] = 5.8333;
	points[12] = (-8226.4961, 3031.9214, 797.2441);
	angles[12] = (0, -62.8551, 0);
	at[12] = 9.3333;
	points[13] = (-8151.8110, 3067.2915, 797.2441);
	angles[13] = (0, -66.7755, 0);
	at[13] = 10.2667;
	points[14] = (-8131.6143, 3075.1104, 797.2441);
	angles[14] = (0, -69.6800, 0);
	at[14] = 10.5000;
	points[15] = (-8114.4097, 3080.2993, 797.2441);
	angles[15] = (0, -74.3512, 0);
	at[15] = 10.7333;
	points[16] = (-8012.5986, 3097.9487, 797.2441);
	angles[16] = (0, -82.6919, 0);
	at[16] = 11.9000;
	points[17] = (-7867.7563, 3110.1931, 797.2441);
	angles[17] = (0, -87.0897, 0);
	at[17] = 13.5333;
	points[18] = (-7743.5435, 3111.4451, 797.2441);
	angles[18] = (0, -91.8201, 0);
	at[18] = 14.9333;
	points[19] = (-7661.1812, 3103.1733, 797.2441);
	angles[19] = (0, -100.3181, 0);
	at[19] = 15.8667;
	points[20] = (-7640.1973, 3097.6851, 797.2441);
	angles[20] = (0, -106.4240, 0);
	at[20] = 16.1000;
	points[21] = (-7623.7007, 3089.9490, 797.2441);
	angles[21] = (0, -118.3710, 0);
	at[21] = 16.3333;
	points[22] = (-7606.5352, 3076.7048, 797.2441);
	angles[22] = (0, -129.2507, 0);
	at[22] = 16.5667;
	points[23] = (-7592.4019, 3063.0632, 797.2441);
	angles[23] = (0, -134.8087, 0);
	at[23] = 16.8000;
	points[24] = (-7551.9688, 3014.9724, 797.2441);
	angles[24] = (0, -142.3785, 0);
	at[24] = 17.5000;
	points[25] = (-7504.8428, 2946.8818, 797.2441);
	angles[25] = (0, -147.1867, 0);
	at[25] = 18.4333;
	points[26] = (-7443.1895, 2838.6536, 797.2441);
	angles[26] = (0, -153.0781, 0);
	at[26] = 19.8333;
	points[27] = (-7410.1968, 2762.0947, 797.2441);
	angles[27] = (0, -160.4997, 0);
	at[27] = 20.7667;
	points[28] = (-7404.4487, 2742.6694, 797.2441);
	angles[28] = (0, -164.6118, 0);
	at[28] = 21;
	points[29] = (-7401.1816, 2722.4604, 797.2441);
	angles[29] = (0, -173.6634, 0);
	at[29] = 21.2333;
	points[30] = (-7402.9531, 2703.5630, 797.2441);
	angles[30] = (0, -187.7613, 0);
	at[30] = 21.4667;
	points[31] = (-7408.2676, 2683.3386, 797.2441);
	angles[31] = (0, -196.0806, 0);
	at[31] = 21.7000;
	points[32] = (-7423.2285, 2644.5828, 797.2441);
	angles[32] = (0, -203.0607, 0);
	at[32] = 22.1667;
	points[33] = (-7450.7090, 2588.6731, 797.2441);
	angles[33] = (0, -207.8703, 0);
	at[33] = 22.8667;
	points[34] = (-7492.6382, 2516.8149, 797.2441);
	angles[34] = (0, -211.9035, 0);
	at[34] = 23.8000;
	points[35] = (-7564.4487, 2414.9802, 797.2441);
	angles[35] = (0, -218.4811, 0);
	at[35] = 25.2000;
	points[36] = (-7606.4175, 2369.1653, 797.2441);
	angles[36] = (0, -226.4222, 0);
	at[36] = 25.9000;
	points[37] = (-7622.2441, 2356.5906, 797.2441);
	angles[37] = (0, -233.6843, 0);
	at[37] = 26.1333;
	points[38] = (-7638.8979, 2347.7087, 797.2441);
	angles[38] = (0, -243.5632, 0);
	at[38] = 26.3667;
	points[39] = (-7678.1890, 2333.5276, 797.2441);
	angles[39] = (0, -252.4191, 0);
	at[39] = 26.8333;
	points[40] = (-7739.1733, 2317.8545, 797.2441);
	angles[40] = (0, -257.1816, 0);
	at[40] = 27.5333;
	points[41] = (-7840.7876, 2299.3188, 797.2441);
	angles[41] = (0, -261.3732, 0);
	at[41] = 28.7000;
	points[42] = (-7985.6694, 2285.1968, 797.2441);
	angles[42] = (0, -267.6282, 0);
	at[42] = 30.3333;
	points[43] = (-8027.2051, 2285.0078, 797.2441);
	angles[43] = (0, -271.1442, 0);
	at[43] = 30.8000;
	points[44] = (-8068.7402, 2289.0513, 797.2441);
	angles[44] = (0, -279.0927, 0);
	at[44] = 31.2667;
	points[45] = (-8086.3779, 2294.2126, 797.2441);
	angles[45] = (0, -289.1309, 0);
	at[45] = 31.5000;
	points[46] = (-8105.0791, 2303.8896, 797.2441);
	angles[46] = (0, -298.8685, 0);
	at[46] = 31.7333;
	points[47] = (-8121.8506, 2314.9055, 797.2441);
	angles[47] = (0, -304.0962, 0);
	at[47] = 31.9667;
	points[48] = (-8170.7085, 2354.2324, 797.2441);
	angles[48] = (0, -311.1035, 0);
	at[48] = 32.6667;
	points[49] = (-8230.4326, 2411.6062, 797.2441);
	angles[49] = (0, -315.5786, 0);
	at[49] = 33.6000;
	points[50] = (-8325.7881, 2520.9646, 797.2441);
	angles[50] = (0, -321.9630, 0);
	at[50] = 35.2333;
	points[51] = (-8362.2441, 2572.0081, 797.2441);
	angles[51] = (0, -326.5900, 0);
	at[51] = 35.9333;
	points[52] = (-8382.7959, 2608.1536, 797.2441);
	angles[52] = (0, -333.2321, 0);
	at[52] = 36.4000;
	points[53] = (-8389.5674, 2625.2207, 797.2441);
	angles[53] = (0, -340.5190, 0);
	at[53] = 36.6333;
	points[54] = (-8396.5361, 2665.8621, 797.2441);
	angles[54] = (0, -353.5997, 0);
	at[54] = 37.1000;
	points[55] = (-8399.4482, 2727.9292, 797.2441);
	angles[55] = (0, -358.9756, 0);
	at[55] = 37.8000;
	points[56] = (-8398.0312, 2832.2087, 797.2441);
	angles[56] = (0, -361.6826, 0);
	at[56] = 38.9667;
	points[57] = (-8391.6934, 3080.3977, 797.2441);
	angles[57] = (0, -359.0886, 0);
	at[57] = 41.7667;
	points[58] = (-8393.8584, 3121.9016, 797.2441);
	angles[58] = (0, -355.3062, 0);
	at[58] = 42.2333;
	points[59] = (-8396.9287, 3143.8582, 797.2441);
	angles[59] = (0, -350.5376, 0);
	at[59] = 42.4667;
	points[60] = (-8402.2832, 3161.2913, 797.2441);
	angles[60] = (0, -340.1852, 0);
	at[60] = 42.7000;
	points[61] = (-8412.2832, 3180.0356, 797.2441);
	angles[61] = (0, -330.3394, 0);
	at[61] = 42.9333;
	points[62] = (-8436.7324, 3212.9331, 797.2441);
	angles[62] = (0, -320.5912, 0);
	at[62] = 43.4000;
	points[63] = (-8464.9219, 3243.3386, 797.2441);
	angles[63] = (0, -315.5839, 0);
	at[63] = 43.8667;
	points[64] = (-8510.7871, 3285.4097, 797.2441);
	angles[64] = (0, -310.7036, 0);
	at[64] = 44.5667;
	points[65] = (-8594.0947, 3347.5474, 797.2441);
	angles[65] = (0, -303.1331, 0);
	at[65] = 45.7333;
	points[66] = (-8629.7637, 3367.8857, 797.2441);
	angles[66] = (0, -297.0639, 0);
	at[66] = 46.2000;
	points[67] = (-8649.1338, 3375.5750, 797.2441);
	angles[67] = (0, -289.0021, 0);
	at[67] = 46.4333;
	points[68] = (-8668.7793, 3377.4844, 797.2441);
	angles[68] = (0, -272.5528, 0);
	at[68] = 46.6667;
	points[69] = (-8689.0947, 3375.6182, 797.2441);
	angles[69] = (0, -263.5739, 0);
	at[69] = 46.9000;
	points[70] = (-8749.8428, 3361.7124, 797.2441);
	angles[70] = (0, -254.2283, 0);
	at[70] = 47.6000;
	points[71] = (-8808.9365, 3341.7361, 797.2441);
	angles[71] = (0, -249.5354, 0);
	at[71] = 48.3000;
	points[72] = (-8865.8662, 3317.3191, 797.2441);
	angles[72] = (0, -244.6578, 0);
	at[72] = 49;
	points[73] = (-8902.7559, 3297.1538, 797.2441);
	angles[73] = (0, -238.9039, 0);
	at[73] = 49.4667;
	points[74] = (-8919.4883, 3285.1931, 797.2441);
	angles[74] = (0, -232.7791, 0);
	at[74] = 49.7000;
	points[75] = (-8932.1260, 3270.8308, 797.2441);
	angles[75] = (0, -215.8046, 0);
	at[75] = 49.9333;
	points[76] = (-8940.0391, 3251.5435, 797.2441);
	angles[76] = (0, -200.2256, 0);
	at[76] = 50.1667;
	points[77] = (-8945.5508, 3230.9805, 797.2441);
	angles[77] = (0, -194.1357, 0);
	at[77] = 50.4000;
	points[78] = (-8955.5508, 3169.9451, 797.2441);
	angles[78] = (0, -187.0649, 0);
	at[78] = 51.1000;
	points[79] = (-8960.5518, 3107.8188, 797.2441);
	angles[79] = (0, -183.0236, 0);
	at[79] = 51.8000;
	points[80] = (-8961.1025, 3045.8110, 797.2441);
	angles[80] = (0, -178.5670, 0);
	at[80] = 52.5000;
	points[81] = (-8957.7949, 3003.9607, 797.2441);
	angles[81] = (0, -173.2238, 0);
	at[81] = 52.9667;
	points[82] = (-8953.9766, 2983.8899, 797.2441);
	angles[82] = (0, -167.7344, 0);
	at[82] = 53.2000;
	points[83] = (-8947.6768, 2967.4766, 797.2441);
	angles[83] = (0, -155.3665, 0);
	at[83] = 53.4167;
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
	points[0] = (-5368.3857, 1276.9174, 797.2441);
	angles[0] = (0, -35.4428, 0);
	at[0] = 0;
	points[1] = (-5360.3149, 1294.3700, 797.2441);
	angles[1] = (0, -23.0344, 0);
	at[1] = 0.2167;
	points[2] = (-5354.6064, 1312.4489, 797.2441);
	angles[2] = (0, -16.6939, 0);
	at[2] = 0.4333;
	points[3] = (-5343.5435, 1369.2048, 797.2441);
	angles[3] = (0, -8.2917, 0);
	at[3] = 1.0833;
	points[4] = (-5338.5830, 1426.8779, 797.2441);
	angles[4] = (0, -2.7513, 0);
	at[4] = 1.7333;
	points[5] = (-5341.4175, 1503.8385, 797.2441);
	angles[5] = (0, 6.3811, 0);
	at[5] = 2.6000;
	points[6] = (-5355.2759, 1559.7009, 797.2441);
	angles[6] = (0, 20.6535, 0);
	at[6] = 3.2500;
	points[7] = (-5363.9370, 1576.1141, 797.2441);
	angles[7] = (0, 30.1432, 0);
	at[7] = 3.4667;
	points[8] = (-5374.8818, 1589.7008, 797.2441);
	angles[8] = (0, 40.1066, 0);
	at[8] = 3.6833;
	points[9] = (-5389.1729, 1604.1812, 797.2441);
	angles[9] = (0, 45.3281, 0);
	at[9] = 3.9000;
	points[10] = (-5462.6382, 1666.5946, 797.2441);
	angles[10] = (0, 51.2984, 0);
	at[10] = 4.9833;
	points[11] = (-5720.5903, 1868.8701, 797.2441);
	angles[11] = (0, 50.0459, 0);
	at[11] = 8.6667;
	points[12] = (-5776.8110, 1919.9292, 797.2441);
	angles[12] = (0, 45.1272, 0);
	at[12] = 9.5333;
	points[13] = (-5801.6934, 1949.2205, 797.2441);
	angles[13] = (0, 35.9070, 0);
	at[13] = 9.9667;
	points[14] = (-5810.4336, 1964.5000, 797.2441);
	angles[14] = (0, 28.7706, 0);
	at[14] = 10.1833;
	points[15] = (-5825.5908, 2000.0315, 797.2441);
	angles[15] = (0, 21.0018, 0);
	at[15] = 10.6167;
	points[16] = (-5848.3467, 2074.2795, 797.2441);
	angles[16] = (0, 14.9340, 0);
	at[16] = 11.4833;
	points[17] = (-5865.6694, 2149.0867, 797.2441);
	angles[17] = (0, 11.8369, 0);
	at[17] = 12.3500;
	points[18] = (-5890.3545, 2301.3308, 797.2441);
	angles[18] = (0, 6.8290, 0);
	at[18] = 14.0833;
	points[19] = (-5895.5122, 2359.2322, 797.2441);
	angles[19] = (0, 3.5853, 0);
	at[19] = 14.7333;
	points[20] = (-5895.8662, 2397.5828, 797.2441);
	angles[20] = (0, -2.0185, 0);
	at[20] = 15.1667;
	points[21] = (-5893.5044, 2414.6692, 797.2441);
	angles[21] = (0, -9.4558, 0);
	at[21] = 15.3833;
	points[22] = (-5881.7324, 2451.5750, 797.2441);
	angles[22] = (0, -20.7256, 0);
	at[22] = 15.8167;
	points[23] = (-5838.1099, 2537.3425, 797.2441);
	angles[23] = (0, -30.3651, 0);
	at[23] = 16.9000;
	points[24] = (-5772.7954, 2632.7954, 797.2441);
	angles[24] = (0, -37.9040, 0);
	at[24] = 18.2000;
	points[25] = (-5734.2520, 2675.7168, 797.2441);
	angles[25] = (0, -45.7583, 0);
	at[25] = 18.8500;
	points[26] = (-5720.0786, 2687.2166, 797.2441);
	angles[26] = (0, -52.9247, 0);
	at[26] = 19.0667;
	points[27] = (-5703.6221, 2696.6536, 797.2441);
	angles[27] = (0, -61.2342, 0);
	at[27] = 19.2833;
	points[28] = (-5686.6143, 2704.6023, 797.2441);
	angles[28] = (0, -65.4982, 0);
	at[28] = 19.5000;
	points[29] = (-5577.0869, 2742.6340, 797.2441);
	angles[29] = (0, -73.6816, 0);
	at[29] = 20.8000;
	points[30] = (-5483.3462, 2765.6379, 797.2441);
	angles[30] = (0, -78.4105, 0);
	at[30] = 21.8833;
	points[31] = (-5406.8110, 2775.9766, 797.2441);
	angles[31] = (0, -86.5420, 0);
	at[31] = 22.7500;
	points[32] = (-5387.8345, 2775.8149, 797.2441);
	angles[32] = (0, -91.7068, 0);
	at[32] = 22.9667;
	points[33] = (-5369.8823, 2772.5471, 797.2441);
	angles[33] = (0, -104.1541, 0);
	at[33] = 23.1833;
	points[34] = (-5353.0708, 2763.5984, 797.2441);
	angles[34] = (0, -119.9603, 0);
	at[34] = 23.4000;
	points[35] = (-5338.1499, 2752.4373, 797.2441);
	angles[35] = (0, -127.6638, 0);
	at[35] = 23.6167;
	points[36] = (-5309.6064, 2726.2993, 797.2441);
	angles[36] = (0, -134.2865, 0);
	at[36] = 24.0500;
	points[37] = (-5257.8740, 2669.0042, 797.2441);
	angles[37] = (0, -139.9754, 0);
	at[37] = 24.9167;
	points[38] = (-5210.5518, 2608.0356, 797.2441);
	angles[38] = (0, -143.7721, 0);
	at[38] = 25.7833;
	points[39] = (-5177.9136, 2560.1418, 797.2441);
	angles[39] = (0, -147.1738, 0);
	at[39] = 26.4333;
	points[40] = (-5149.6851, 2509.4724, 797.2441);
	angles[40] = (0, -154.5861, 0);
	at[40] = 27.0833;
	points[41] = (-5143.6616, 2492.9646, 797.2441);
	angles[41] = (0, -162.1015, 0);
	at[41] = 27.3000;
	points[42] = (-5140.1572, 2473.7402, 797.2441);
	angles[42] = (0, -170.7110, 0);
	at[42] = 27.5167;
	points[43] = (-5138.4253, 2455.2520, 797.2441);
	angles[43] = (0, -175.2603, 0);
	at[43] = 27.7333;
	points[44] = (-5138.3857, 2378.0276, 797.2441);
	angles[44] = (0, -182.2255, 0);
	at[44] = 28.6000;
	points[45] = (-5148.4644, 2262.7559, 797.2441);
	angles[45] = (0, -187.0637, 0);
	at[45] = 29.9000;
	points[46] = (-5164.9609, 2167.7205, 797.2441);
	angles[46] = (0, -192.8985, 0);
	at[46] = 30.9833;
	points[47] = (-5170, 2148.9370, 797.2441);
	angles[47] = (0, -195.6465, 0);
	at[47] = 31.2000;
	points[48] = (-5184.6851, 2114.9607, 797.2441);
	angles[48] = (0, -207.8138, 0);
	at[48] = 31.6333;
	points[49] = (-5227.8350, 2051.3425, 797.2441);
	angles[49] = (0, -216.6898, 0);
	at[49] = 32.5000;
	points[50] = (-5313.5825, 1947.4055, 797.2441);
	angles[50] = (0, -221.4075, 0);
	at[50] = 34.0167;
	points[51] = (-5393.4648, 1863.5513, 797.2441);
	angles[51] = (0, -226.1785, 0);
	at[51] = 35.3167;
	points[52] = (-5421.4570, 1840.0394, 797.2441);
	angles[52] = (0, -232.5101, 0);
	at[52] = 35.7500;
	points[53] = (-5469.2124, 1807.3820, 797.2441);
	angles[53] = (0, -236.7604, 0);
	at[53] = 36.4000;
	points[54] = (-5632.4409, 1705.0354, 797.2441);
	angles[54] = (0, -237.8195, 0);
	at[54] = 38.5667;
	points[55] = (-5744.2915, 1629.3583, 797.2441);
	angles[55] = (0, -232.4719, 0);
	at[55] = 40.0833;
	points[56] = (-5759.4487, 1616.6062, 797.2441);
	angles[56] = (0, -229.0710, 0);
	at[56] = 40.3000;
	points[57] = (-5771.3384, 1603.9330, 797.2441);
	angles[57] = (0, -220.8877, 0);
	at[57] = 40.5167;
	points[58] = (-5790.6689, 1570.8190, 797.2441);
	angles[58] = (0, -206.4245, 0);
	at[58] = 40.9500;
	points[59] = (-5805.0791, 1534.9094, 797.2441);
	angles[59] = (0, -200.0394, 0);
	at[59] = 41.3833;
	points[60] = (-5821.3389, 1479.6576, 797.2441);
	angles[60] = (0, -194.2600, 0);
	at[60] = 42.0333;
	points[61] = (-5835.0786, 1403.8544, 797.2441);
	angles[61] = (0, -187.0135, 0);
	at[61] = 42.9000;
	points[62] = (-5837.2046, 1365.3190, 797.2441);
	angles[62] = (0, -180.5543, 0);
	at[62] = 43.3333;
	points[63] = (-5835.7090, 1346.0316, 797.2441);
	angles[63] = (0, -173.7530, 0);
	at[63] = 43.5500;
	points[64] = (-5830.7876, 1329.3464, 797.2441);
	angles[64] = (0, -161.1824, 0);
	at[64] = 43.7667;
	points[65] = (-5822.4409, 1311.7756, 797.2441);
	angles[65] = (0, -153.7057, 0);
	at[65] = 43.9833;
	points[66] = (-5792.3228, 1261.8818, 797.2441);
	angles[66] = (0, -146.8572, 0);
	at[66] = 44.6333;
	points[67] = (-5747.4014, 1199.4567, 797.2441);
	angles[67] = (0, -142.5102, 0);
	at[67] = 45.5000;
	points[68] = (-5710.4331, 1154.7086, 797.2441);
	angles[68] = (0, -138.9057, 0);
	at[68] = 46.1500;
	points[69] = (-5669.9604, 1113.8464, 797.2441);
	angles[69] = (0, -131.9112, 0);
	at[69] = 46.8000;
	points[70] = (-5654.7246, 1102.0867, 797.2441);
	angles[70] = (0, -126.1427, 0);
	at[70] = 47.0167;
	points[71] = (-5637.4409, 1093.7441, 797.2441);
	angles[71] = (0, -110.5358, 0);
	at[71] = 47.2333;
	points[72] = (-5619.1338, 1095.3544, 797.2441);
	angles[72] = (0, -81.4638, 0);
	at[72] = 47.4500;
	points[73] = (-5601.6143, 1101.6024, 797.2441);
	angles[73] = (0, -69.3721, 0);
	at[73] = 47.6667;
	points[74] = (-5583.9761, 1109.8386, 797.2441);
	angles[74] = (0, -64.2492, 0);
	at[74] = 47.8833;
	points[75] = (-5517.7559, 1149.4724, 797.2441);
	angles[75] = (0, -56.5579, 0);
	at[75] = 48.7500;
	points[76] = (-5455.2754, 1194.6890, 797.2441);
	angles[76] = (0, -52.3918, 0);
	at[76] = 49.6167;
	points[77] = (-5396.6143, 1244.7834, 797.2441);
	angles[77] = (0, -46.7632, 0);
	at[77] = 50.4833;
	points[78] = (-5383.1494, 1258.4528, 797.2441);
	angles[78] = (0, -43.8269, 0);
	at[78] = 50.7000;
	points[79] = (-5368.3857, 1276.9174, 797.2441);
	angles[79] = (0, -35.4428, 0);
	at[79] = 50.9667;
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
	points[0] = (43.3728, -12830.7090, 2194.6614);
	angles[0] = (0, 44.0408, 0);
	at[0] = 0;
	points[1] = (31.8716, -12823.7402, 2194.6614);
	angles[1] = (0, 59.5780, 0);
	at[1] = 0.1500;
	points[2] = (19.5372, -12818.5830, 2194.6614);
	angles[2] = (0, 66.9331, 0);
	at[2] = 0.3000;
	points[3] = (-40.5110, -12801.9688, 2194.6614);
	angles[3] = (0, 78.9977, 0);
	at[3] = 1;
	points[4] = (-58.2126, -12800.2363, 2194.6614);
	angles[4] = (0, 86.6554, 0);
	at[4] = 1.2000;
	points[5] = (-70.4323, -12803.7402, 2194.6614);
	angles[5] = (0, 108.0267, 0);
	at[5] = 1.3500;
	points[6] = (-78.1035, -12808.3066, 2194.6614);
	angles[6] = (0, 118.0767, 0);
	at[6] = 1.4500;
	points[7] = (-88.9102, -12816.0244, 2194.6614);
	angles[7] = (0, 125.3585, 0);
	at[7] = 1.6000;
	points[8] = (-102.6256, -12827.4023, 2194.6614);
	angles[8] = (0, 130.1891, 0);
	at[8] = 1.8000;
	points[9] = (-132.9835, -12859.7246, 2194.6614);
	angles[9] = (0, 142.3601, 0);
	at[9] = 2.3000;
	points[10] = (-135.4114, -12863.6221, 2194.6614);
	angles[10] = (0, 145.6562, 0);
	at[10] = 2.3500;
	points[11] = (-138.9610, -12875.8262, 2194.6614);
	angles[11] = (0, 164.9017, 0);
	at[11] = 2.5000;
	points[12] = (-139.7854, -12884.7646, 2194.6614);
	angles[12] = (0, 172.6948, 0);
	at[12] = 2.6000;
	points[13] = (-140.1571, -12898.0703, 2194.6614);
	angles[13] = (0, 178.2083, 0);
	at[13] = 2.7500;
	points[14] = (-137.9882, -12937.9922, 2194.6614);
	angles[14] = (0, 185.2216, 0);
	at[14] = 3.2000;
	points[15] = (-132.6842, -12968.5830, 2194.6614);
	angles[15] = (0, 193.1457, 0);
	at[15] = 3.5500;
	points[16] = (-129.5591, -12976.6533, 2194.6614);
	angles[16] = (0, 201.3174, 0);
	at[16] = 3.6500;
	points[17] = (-124.2354, -12983.5820, 2194.6614);
	angles[17] = (0, 214.8020, 0);
	at[17] = 3.7500;
	points[18] = (-111.2039, -12995.7490, 2194.6614);
	angles[18] = (0, 227.5926, 0);
	at[18] = 3.9500;
	points[19] = (-59.8634, -13030.6699, 2194.6614);
	angles[19] = (0, 240.6408, 0);
	at[19] = 4.6500;
	points[20] = (-51.8087, -13034.5674, 2194.6614);
	angles[20] = (0, 243.8218, 0);
	at[20] = 4.7500;
	points[21] = (-43.5717, -13037.4014, 2194.6614);
	angles[21] = (0, 251.0364, 0);
	at[21] = 4.8500;
	points[22] = (-34.9473, -13037.8350, 2194.6614);
	angles[22] = (0, 264.6465, 0);
	at[22] = 4.9500;
	points[23] = (-21.7651, -13036.2998, 2194.6614);
	angles[23] = (0, 276.0844, 0);
	at[23] = 5.1000;
	points[24] = (42.1992, -13017.4814, 2194.6614);
	angles[24] = (0, 292.3015, 0);
	at[24] = 5.8500;
	points[25] = (50.1622, -13013.4248, 2194.6614);
	angles[25] = (0, 296.7520, 0);
	at[25] = 5.9500;
	points[26] = (56.6394, -13008.2285, 2194.6614);
	angles[26] = (0, 307.6448, 0);
	at[26] = 6.0500;
	points[27] = (62.4512, -13001.4170, 2194.6614);
	angles[27] = (0, 317.1510, 0);
	at[27] = 6.1500;
	points[28] = (67.7032, -12994.2910, 2194.6614);
	angles[28] = (0, 322.3870, 0);
	at[28] = 6.2500;
	points[29] = (95.3791, -12943.5430, 2194.6614);
	angles[29] = (0, 336.8743, 0);
	at[29] = 6.9000;
	points[30] = (98.2413, -12935.0791, 2194.6614);
	angles[30] = (0, 340.8879, 0);
	at[30] = 7;
	points[31] = (99.8118, -12926.3779, 2194.6614);
	angles[31] = (0, 349.4567, 0);
	at[31] = 7.1000;
	points[32] = (96.9012, -12914.0156, 2194.6614);
	angles[32] = (0, 373.2987, 0);
	at[32] = 7.2500;
	points[33] = (91.4535, -12901.7715, 2194.6614);
	angles[33] = (0, 383.4386, 0);
	at[33] = 7.4000;
	points[34] = (53.4933, -12841.7715, 2194.6614);
	angles[34] = (0, 397.3503, 0);
	at[34] = 8.2000;
	points[35] = (43.3728, -12830.7090, 2194.6614);
	angles[35] = (0, 404.0408, 0);
	at[35] = 8.3667;
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
	points[0] = (-470.3622, 18907.4004, 3838.5828);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-661.4134, 18906.5742, 3838.5828);
	angles[1] = (0, 0, 0);
	at[1] = 0.5000;
	points[2] = (-870.5315, 18895.0391, 3838.5828);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (-1096.7992, 18873.1504, 3838.5828);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (-1339.2795, 18841.2207, 3838.5828);
	angles[4] = (0, 0, 0);
	at[4] = 2;
	points[5] = (-1560.7678, 18805.8672, 3838.5828);
	angles[5] = (0, 0, 0);
	at[5] = 2.5000;
	points[6] = (-1763.3898, 18769.2520, 3838.5828);
	angles[6] = (0, 0, 0);
	at[6] = 3;
	points[7] = (-1973.8662, 18727.4023, 3838.5828);
	angles[7] = (0, 0, 0);
	at[7] = 3.5000;
	points[8] = (-2191.7954, 18680.5508, 3838.5828);
	angles[8] = (0, 0, 0);
	at[8] = 4;
	points[9] = (-2416.7795, 18628.8184, 3838.5828);
	angles[9] = (0, 0, 0);
	at[9] = 4.5000;
	points[10] = (-2648.4211, 18572.3223, 3838.5828);
	angles[10] = (0, 0, 0);
	at[10] = 5;
	points[11] = (-2861.5513, 18517.7168, 3838.5828);
	angles[11] = (0, 0, 0);
	at[11] = 5.5000;
	points[12] = (-3065.8779, 18463.2285, 3838.5828);
	angles[12] = (0, 0, 0);
	at[12] = 6;
	points[13] = (-3274.1497, 18405.7090, 3838.5828);
	angles[13] = (0, 0, 0);
	at[13] = 6.5000;
	points[14] = (-3486.1299, 18345.1582, 3838.5828);
	angles[14] = (0, 0, 0);
	at[14] = 7;
	points[15] = (-3701.5789, 18281.7715, 3838.5828);
	angles[15] = (0, 0, 0);
	at[15] = 7.5000;
	points[16] = (-3920.2639, 18215.5508, 3838.5828);
	angles[16] = (0, 0, 0);
	at[16] = 8;
	points[17] = (-4141.9292, 18146.6152, 3838.5828);
	angles[17] = (0, 0, 0);
	at[17] = 8.5000;
	points[18] = (-4352.7954, 18079.4492, 3838.5828);
	angles[18] = (0, 0, 0);
	at[18] = 9;
	points[19] = (-4557.8740, 18012.6777, 3838.5828);
	angles[19] = (0, 0, 0);
	at[19] = 9.5000;
	points[20] = (-4973.5830, 17873.1895, 3838.5828);
	angles[20] = (0, 0, 0);
	at[20] = 10.5000;
	points[21] = (-5183.8193, 17800.5918, 3838.5828);
	angles[21] = (0, 0, 0);
	at[21] = 11;
	points[22] = (-5608.2285, 17650.0391, 3838.5828);
	angles[22] = (0, 0, 0);
	at[22] = 12;
	points[23] = (-5822.0864, 17572.2441, 3838.5828);
	angles[23] = (0, 0, 0);
	at[23] = 12.5000;
	points[24] = (-6440.4727, 17339.9219, 3838.5828);
	angles[24] = (0, 0, 0);
	at[24] = 14;
	points[25] = (-6853.7007, 17178.7402, 3838.5828);
	angles[25] = (0, 0, 0);
	at[25] = 15;
	points[26] = (-7473.1494, 16928.2676, 3838.5828);
	angles[26] = (0, 0, 0);
	at[26] = 16.5000;
	points[27] = (-7885.1182, 16755.6699, 3838.5828);
	angles[27] = (0, 0, 0);
	at[27] = 17.5000;
	points[28] = (-8497.0869, 16490.1582, 3838.5828);
	angles[28] = (0, 0, 0);
	at[28] = 19;
	points[29] = (-9097.9141, 16218.1104, 3838.5828);
	angles[29] = (0, 0, 0);
	at[29] = 20.5000;
	points[30] = (-9507.1260, 16025.8271, 3838.5828);
	angles[30] = (0, 0, 0);
	at[30] = 21.5000;
	points[31] = (-9910.9844, 15830, 3838.5828);
	angles[31] = (0, 0, 0);
	at[31] = 22.5000;
	points[32] = (-10304.3701, 15632.8350, 3838.5828);
	angles[32] = (0, 0, 0);
	at[32] = 23.5000;
	points[33] = (-10685.9453, 15434.8428, 3838.5828);
	angles[33] = (0, 0, 0);
	at[33] = 24.5000;
	points[34] = (-11094.0557, 15214.6855, 3838.5828);
	angles[34] = (0, 0, 0);
	at[34] = 25.5000;
	points[35] = (-11291.6543, 15104.4883, 3838.5828);
	angles[35] = (0, 0, 0);
	at[35] = 26;
	points[36] = (-11484.4102, 14994.5273, 3838.5828);
	angles[36] = (0, 0, 0);
	at[36] = 26.5000;
	points[37] = (-11672.0479, 14884.8428, 3838.5828);
	angles[37] = (0, 0, 0);
	at[37] = 27;
	points[38] = (-12032.7949, 14665.6299, 3838.5828);
	angles[38] = (0, 0, 0);
	at[38] = 28;
	points[39] = (-12236.3389, 14536.2607, 3838.5828);
	angles[39] = (0, 0, 0);
	at[39] = 28.5000;
	points[40] = (-12431.0234, 14407.8740, 3838.5828);
	angles[40] = (0, 0, 0);
	at[40] = 29;
	points[41] = (-12616.4971, 14280.5898, 3838.5828);
	angles[41] = (0, 0, 0);
	at[41] = 29.5000;
	points[42] = (-12792.2842, 14154.6465, 3838.5828);
	angles[42] = (0, 0, 0);
	at[42] = 30;
	points[43] = (-12957.9922, 14030.1973, 3838.5828);
	angles[43] = (0, 0, 0);
	at[43] = 30.5000;
	points[44] = (-13126.6133, 13896.3389, 3838.5828);
	angles[44] = (0, 0, 0);
	at[44] = 31;
	points[45] = (-13314.4883, 13736.1025, 3838.5828);
	angles[45] = (0, 0, 0);
	at[45] = 31.5000;
	points[46] = (-13481.9678, 13579.4092, 3838.5828);
	angles[46] = (0, 0, 0);
	at[46] = 32;
	points[47] = (-13628.0713, 13426.6533, 3838.5828);
	angles[47] = (0, 0, 0);
	at[47] = 32.5000;
	points[48] = (-13751.7725, 13278.2285, 3838.5828);
	angles[48] = (0, 0, 0);
	at[48] = 33;
	points[49] = (-13858.9375, 13125.6689, 3838.5828);
	angles[49] = (0, 0, 0);
	at[49] = 33.5000;
	points[50] = (-13965.0400, 12949.1729, 3838.5828);
	angles[50] = (0, 0, 0);
	at[50] = 34;
	points[51] = (-14070.3545, 12749.3711, 3838.5828);
	angles[51] = (0, 0, 0);
	at[51] = 34.5000;
	points[52] = (-14174.7637, 12527.3232, 3838.5828);
	angles[52] = (0, 0, 0);
	at[52] = 35;
	points[53] = (-14265.8262, 12314.3311, 3838.5828);
	angles[53] = (0, 0, 0);
	at[53] = 35.5000;
	points[54] = (-14340.5908, 12126.1816, 3838.5828);
	angles[54] = (0, 0, 0);
	at[54] = 36;
	points[55] = (-14414.7246, 11927.7158, 3838.5828);
	angles[55] = (0, 0, 0);
	at[55] = 36.5000;
	points[56] = (-14488.2285, 11719.4102, 3838.5828);
	angles[56] = (0, 0, 0);
	at[56] = 37;
	points[57] = (-14561.0244, 11501.6533, 3838.5828);
	angles[57] = (0, 0, 0);
	at[57] = 37.5000;
	points[58] = (-14633.0703, 11274.8818, 3838.5828);
	angles[58] = (0, 0, 0);
	at[58] = 38;
	points[59] = (-14700.7480, 11051.6934, 3838.5828);
	angles[59] = (0, 0, 0);
	at[59] = 38.5000;
	points[60] = (-14758.8984, 10852.0078, 3838.5828);
	angles[60] = (0, 0, 0);
	at[60] = 39;
	points[61] = (-14816.4570, 10647.0078, 3838.5828);
	angles[61] = (0, 0, 0);
	at[61] = 39.5000;
	points[62] = (-14873.4648, 10436.9287, 3838.5828);
	angles[62] = (0, 0, 0);
	at[62] = 40;
	points[63] = (-14929.8418, 10221.9688, 3838.5828);
	angles[63] = (0, 0, 0);
	at[63] = 40.5000;
	points[64] = (-14985.6309, 10002.4023, 3838.5828);
	angles[64] = (0, 0, 0);
	at[64] = 41;
	points[65] = (-15040.7090, 9778.4648, 3838.5828);
	angles[65] = (0, 0, 0);
	at[65] = 41.5000;
	points[66] = (-15095.1572, 9550.3545, 3838.5828);
	angles[66] = (0, 0, 0);
	at[66] = 42;
	points[67] = (-15191.5352, 9129.4092, 3838.5828);
	angles[67] = (0, 0, 0);
	at[67] = 43;
	points[68] = (-15284.5273, 8701.8896, 3838.5828);
	angles[68] = (0, 0, 0);
	at[68] = 44;
	points[69] = (-15375.0791, 8264.6455, 3838.5828);
	angles[69] = (0, 0, 0);
	at[69] = 45;
	points[70] = (-15463.0703, 7818.9766, 3838.5828);
	angles[70] = (0, 0, 0);
	at[70] = 46;
	points[71] = (-15505.0400, 7598.8188, 3838.5828);
	angles[71] = (0, 0, 0);
	at[71] = 46.5000;
	points[72] = (-15545.0791, 7384.0547, 3838.5828);
	angles[72] = (0, 0, 0);
	at[72] = 47;
	points[73] = (-15661.4170, 6732.5591, 3838.5828);
	angles[73] = (0, 0, 0);
	at[73] = 48.5000;
	points[74] = (-15771.8115, 6073.2280, 3838.5828);
	angles[74] = (0, 0, 0);
	at[74] = 50;
	points[75] = (-15875.5908, 5411.7319, 3838.5828);
	angles[75] = (0, 0, 0);
	at[75] = 51.5000;
	points[76] = (-15972.5195, 4751.6143, 3838.5828);
	angles[76] = (0, 0, 0);
	at[76] = 53;
	points[77] = (-16033.3467, 4313.3071, 3838.5828);
	angles[77] = (0, 0, 0);
	at[77] = 54;
	points[78] = (-16090.9844, 3877.6377, 3838.5828);
	angles[78] = (0, 0, 0);
	at[78] = 55;
	points[79] = (-16200.5127, 2983.1299, 3838.5828);
	angles[79] = (0, 0, 0);
	at[79] = 57;
	points[80] = (-16249.8428, 2543.6299, 3838.5828);
	angles[80] = (0, 0, 0);
	at[80] = 58;
	points[81] = (-16295.2363, 2112.0906, 3838.5828);
	angles[81] = (0, 0, 0);
	at[81] = 59;
	points[82] = (-16316.7725, 1896.1851, 3838.5828);
	angles[82] = (0, 0, 0);
	at[82] = 59.5000;
	points[83] = (-16360.0400, 1434.7362, 3838.5828);
	angles[83] = (0, 0, 0);
	at[83] = 60.5000;
	points[84] = (-16398.1094, 987.1378, 3838.5828);
	angles[84] = (0, 0, 0);
	at[84] = 61.5000;
	points[85] = (-16415.1973, 769.0748, 3838.5828);
	angles[85] = (0, 0, 0);
	at[85] = 62;
	points[86] = (-16430.9062, 555.1260, 3838.5828);
	angles[86] = (0, 0, 0);
	at[86] = 62.5000;
	points[87] = (-16445.2363, 345.5012, 3838.5828);
	angles[87] = (0, 0, 0);
	at[87] = 63;
	points[88] = (-16459.2910, 121.8165, 3838.5828);
	angles[88] = (0, 0, 0);
	at[88] = 63.5000;
	points[89] = (-16472.7949, -116.8091, 3838.5828);
	angles[89] = (0, 0, 0);
	at[89] = 64;
	points[90] = (-16484.2129, -348.2169, 3838.5828);
	angles[90] = (0, 0, 0);
	at[90] = 64.5000;
	points[91] = (-16493.5430, -572.0355, 3838.5828);
	angles[91] = (0, 0, 0);
	at[91] = 65;
	points[92] = (-16500.7871, -787.8937, 3838.5828);
	angles[92] = (0, 0, 0);
	at[92] = 65.5000;
	points[93] = (-16505.8652, -995.4213, 3838.5828);
	angles[93] = (0, 0, 0);
	at[93] = 66;
	points[94] = (-16508.7793, -1197.2480, 3838.5828);
	angles[94] = (0, 0, 0);
	at[94] = 66.5000;
	points[95] = (-16509.0547, -1452.2716, 3838.5828);
	angles[95] = (0, 0, 0);
	at[95] = 67;
	points[96] = (-16505.1973, -1689.6534, 3838.5828);
	angles[96] = (0, 0, 0);
	at[96] = 67.5000;
	points[97] = (-16497.0859, -1908.4686, 3838.5828);
	angles[97] = (0, 0, 0);
	at[97] = 68;
	points[98] = (-16484.6465, -2107.7874, 3838.5828);
	angles[98] = (0, 0, 0);
	at[98] = 68.5000;
	points[99] = (-16467.1270, -2292.4409, 3838.5828);
	angles[99] = (0, 0, 0);
	at[99] = 69;
	points[100] = (-16440.1562, -2492.0198, 3838.5828);
	angles[100] = (0, 0, 0);
	at[100] = 69.5000;
	points[101] = (-16403.7012, -2705.2559, 3838.5828);
	angles[101] = (0, 0, 0);
	at[101] = 70;
	points[102] = (-16358.0713, -2931.4292, 3838.5828);
	angles[102] = (0, 0, 0);
	at[102] = 70.5000;
	points[103] = (-16303.7012, -3169.8071, 3838.5828);
	angles[103] = (0, 0, 0);
	at[103] = 71;
	points[104] = (-16253.1885, -3372.2480, 3838.5828);
	angles[104] = (0, 0, 0);
	at[104] = 71.5000;
	points[105] = (-16198.7002, -3576.7756, 3838.5828);
	angles[105] = (0, 0, 0);
	at[105] = 72;
	points[106] = (-16139.2129, -3787.8030, 3838.5828);
	angles[106] = (0, 0, 0);
	at[106] = 72.5000;
	points[107] = (-16074.9600, -4004.9607, 3838.5828);
	angles[107] = (0, 0, 0);
	at[107] = 73;
	points[108] = (-16006.1025, -4227.9136, 3838.5828);
	angles[108] = (0, 0, 0);
	at[108] = 73.5000;
	points[109] = (-15936.4180, -4445.0786, 3838.5828);
	angles[109] = (0, 0, 0);
	at[109] = 74;
	points[110] = (-15869.7646, -4646.3779, 3838.5828);
	angles[110] = (0, 0, 0);
	at[110] = 74.5000;
	points[111] = (-15800, -4851.2598, 3838.5828);
	angles[111] = (0, 0, 0);
	at[111] = 75;
	points[112] = (-15727.2832, -5059.4097, 3838.5828);
	angles[112] = (0, 0, 0);
	at[112] = 75.5000;
	points[113] = (-15651.6934, -5270.6694, 3838.5828);
	angles[113] = (0, 0, 0);
	at[113] = 76;
	points[114] = (-15492.4414, -5701.4961, 3838.5828);
	angles[114] = (0, 0, 0);
	at[114] = 77;
	points[115] = (-15336.9688, -6106.3384, 3838.5828);
	angles[115] = (0, 0, 0);
	at[115] = 78;
	points[116] = (-15174.0947, -6516.6929, 3838.5828);
	angles[116] = (0, 0, 0);
	at[116] = 79;
	points[117] = (-14916.7324, -7141.2998, 3838.5828);
	angles[117] = (0, 0, 0);
	at[117] = 80.5000;
	points[118] = (-14656.0635, -7748.8979, 3838.5828);
	angles[118] = (0, 0, 0);
	at[118] = 82;
	points[119] = (-14385.1182, -8357.7949, 3838.5828);
	angles[119] = (0, 0, 0);
	at[119] = 83.5000;
	points[120] = (-14105.1973, -8965.3545, 3838.5828);
	angles[120] = (0, 0, 0);
	at[120] = 85;
	points[121] = (-13818.5039, -9566.8105, 3838.5828);
	angles[121] = (0, 0, 0);
	at[121] = 86.5000;
	points[122] = (-13624.9209, -9961.6533, 3838.5828);
	angles[122] = (0, 0, 0);
	at[122] = 87.5000;
	points[123] = (-13525.5117, -10160.9844, 3838.5828);
	angles[123] = (0, 0, 0);
	at[123] = 88;
	points[124] = (-13423.3066, -10363.5039, 3838.5828);
	angles[124] = (0, 0, 0);
	at[124] = 88.5000;
	points[125] = (-13218.4648, -10761.8896, 3838.5828);
	angles[125] = (0, 0, 0);
	at[125] = 89.5000;
	points[126] = (-13013.7793, -11150.2363, 3838.5828);
	angles[126] = (0, 0, 0);
	at[126] = 90.5000;
	points[127] = (-12911.6934, -11340.1582, 3838.5828);
	angles[127] = (0, 0, 0);
	at[127] = 91;
	points[128] = (-12804.2520, -11537.2441, 3838.5828);
	angles[128] = (0, 0, 0);
	at[128] = 91.5000;
	points[129] = (-12692.6377, -11738.9766, 3838.5828);
	angles[129] = (0, 0, 0);
	at[129] = 92;
	points[130] = (-12581.6143, -11936.4570, 3838.5828);
	angles[130] = (0, 0, 0);
	at[130] = 92.5000;
	points[131] = (-12471.3389, -12129.4492, 3838.5828);
	angles[131] = (0, 0, 0);
	at[131] = 93;
	points[132] = (-12361.8896, -12317.7168, 3838.5828);
	angles[132] = (0, 0, 0);
	at[132] = 93.5000;
	points[133] = (-12253.4258, -12500.9443, 3838.5828);
	angles[133] = (0, 0, 0);
	at[133] = 94;
	points[134] = (-12140.7881, -12687.5195, 3838.5828);
	angles[134] = (0, 0, 0);
	at[134] = 94.5000;
	points[135] = (-12016.2607, -12889.2119, 3838.5828);
	angles[135] = (0, 0, 0);
	at[135] = 95;
	points[136] = (-11893.6221, -13082.9131, 3838.5828);
	angles[136] = (0, 0, 0);
	at[136] = 95.5000;
	points[137] = (-11773.0713, -13268.1494, 3838.5828);
	angles[137] = (0, 0, 0);
	at[137] = 96;
	points[138] = (-11654.7637, -13444.5674, 3838.5828);
	angles[138] = (0, 0, 0);
	at[138] = 96.5000;
	points[139] = (-11538.8984, -13611.7725, 3838.5828);
	angles[139] = (0, 0, 0);
	at[139] = 97;
	points[140] = (-11394.8418, -13811.1807, 3838.5828);
	angles[140] = (0, 0, 0);
	at[140] = 97.5000;
	points[141] = (-11253.7402, -13996.2998, 3838.5828);
	angles[141] = (0, 0, 0);
	at[141] = 98;
	points[142] = (-11117.9131, -14163.5039, 3838.5828);
	angles[142] = (0, 0, 0);
	at[142] = 98.5000;
	points[143] = (-10987.8350, -14311.9297, 3838.5828);
	angles[143] = (0, 0, 0);
	at[143] = 99;
	points[144] = (-10857.3232, -14448.2676, 3838.5828);
	angles[144] = (0, 0, 0);
	at[144] = 99.5000;
	points[145] = (-10708.6611, -14592.6387, 3838.5828);
	angles[145] = (0, 0, 0);
	at[145] = 100;
	points[146] = (-10541.8906, -14745.3555, 3838.5828);
	angles[146] = (0, 0, 0);
	at[146] = 100.5000;
	points[147] = (-10357.8340, -14905.8662, 3838.5828);
	angles[147] = (0, 0, 0);
	at[147] = 101;
	points[148] = (-10187.7568, -15048.5039, 3838.5828);
	angles[148] = (0, 0, 0);
	at[148] = 101.5000;
	points[149] = (-10027.0078, -15179.4492, 3838.5828);
	angles[149] = (0, 0, 0);
	at[149] = 102;
	points[150] = (-9857.5986, -15313.9375, 3838.5828);
	angles[150] = (0, 0, 0);
	at[150] = 102.5000;
	points[151] = (-9679.9609, -15451.7324, 3838.5828);
	angles[151] = (0, 0, 0);
	at[151] = 103;
	points[152] = (-9494.4492, -15592.5586, 3838.5828);
	angles[152] = (0, 0, 0);
	at[152] = 103.5000;
	points[153] = (-9303.2285, -15734.9209, 3838.5828);
	angles[153] = (0, 0, 0);
	at[153] = 104;
	points[154] = (-9134.3301, -15858.4648, 3838.5828);
	angles[154] = (0, 0, 0);
	at[154] = 104.5000;
	points[155] = (-8960.5908, -15983.6611, 3838.5828);
	angles[155] = (0, 0, 0);
	at[155] = 105;
	points[156] = (-8782.2041, -16110.3154, 3838.5828);
	angles[156] = (0, 0, 0);
	at[156] = 105.5000;
	points[157] = (-8599.4482, -16238.3467, 3838.5828);
	angles[157] = (0, 0, 0);
	at[157] = 106;
	points[158] = (-8412.4805, -16367.5195, 3838.5828);
	angles[158] = (0, 0, 0);
	at[158] = 106.5000;
	points[159] = (-8221.6143, -16497.7168, 3838.5828);
	angles[159] = (0, 0, 0);
	at[159] = 107;
	points[160] = (-8036.1025, -16622.7168, 3838.5828);
	angles[160] = (0, 0, 0);
	at[160] = 107.5000;
	points[161] = (-7856.4570, -16742.3223, 3838.5828);
	angles[161] = (0, 0, 0);
	at[161] = 108;
	points[162] = (-7489.2524, -16982.8359, 3838.5828);
	angles[162] = (0, 0, 0);
	at[162] = 109;
	points[163] = (-7112.6377, -17224.2129, 3838.5828);
	angles[163] = (0, 0, 0);
	at[163] = 110;
	points[164] = (-6730.3545, -17464.0156, 3838.5828);
	angles[164] = (0, 0, 0);
	at[164] = 111;
	points[165] = (-6543.5830, -17579.3320, 3838.5828);
	angles[165] = (0, 0, 0);
	at[165] = 111.5000;
	points[166] = (-5975.7480, -17922.8340, 3838.5828);
	angles[166] = (0, 0, 0);
	at[166] = 113;
	points[167] = (-5399.6460, -18260.3164, 3838.5828);
	angles[167] = (0, 0, 0);
	at[167] = 114.5000;
	points[168] = (-4817.0078, -18590.4336, 3838.5828);
	angles[168] = (0, 0, 0);
	at[168] = 116;
	points[169] = (-4428.1890, -18804.2129, 3838.5828);
	angles[169] = (0, 0, 0);
	at[169] = 117;
	points[170] = (-3844.9841, -19114.6855, 3838.5828);
	angles[170] = (0, 0, 0);
	at[170] = 118.5000;
	points[171] = (-3441.3740, -19321.8906, 3838.5828);
	angles[171] = (0, 0, 0);
	at[171] = 119.5000;
	points[172] = (-3241.3267, -19422.0879, 3838.5828);
	angles[172] = (0, 0, 0);
	at[172] = 120;
	points[173] = (-2845.6575, -19615.1582, 3838.5828);
	angles[173] = (0, 0, 0);
	at[173] = 121;
	points[174] = (-2453.7993, -19799.0547, 3838.5828);
	angles[174] = (0, 0, 0);
	at[174] = 122;
	points[175] = (-2241.4685, -19895.3555, 3838.5828);
	angles[175] = (0, 0, 0);
	at[175] = 122.5000;
	points[176] = (-2032.0355, -19987.9141, 3838.5828);
	angles[176] = (0, 0, 0);
	at[176] = 123;
	points[177] = (-1825.7520, -20076.4961, 3838.5828);
	angles[177] = (0, 0, 0);
	at[177] = 123.5000;
	points[178] = (-1622.8583, -20160.9453, 3838.5828);
	angles[178] = (0, 0, 0);
	at[178] = 124;
	points[179] = (-1423.6102, -20241.1426, 3838.5828);
	angles[179] = (0, 0, 0);
	at[179] = 124.5000;
	points[180] = (-1228.2560, -20316.8105, 3838.5828);
	angles[180] = (0, 0, 0);
	at[180] = 125;
	points[181] = (-1009.7126, -20397.7578, 3838.5828);
	angles[181] = (0, 0, 0);
	at[181] = 125.5000;
	points[182] = (-788.3779, -20475.3145, 3838.5828);
	angles[182] = (0, 0, 0);
	at[182] = 126;
	points[183] = (-573.7520, -20545.6699, 3838.5828);
	angles[183] = (0, 0, 0);
	at[183] = 126.5000;
	points[184] = (-366.2599, -20608.5840, 3838.5828);
	angles[184] = (0, 0, 0);
	at[184] = 127;
	points[185] = (-166.3177, -20663.7402, 3838.5828);
	angles[185] = (0, 0, 0);
	at[185] = 127.5000;
	points[186] = (48.4035, -20716.0625, 3838.5828);
	angles[186] = (0, 0, 0);
	at[186] = 128;
	points[187] = (286.5232, -20763.9785, 3838.5828);
	angles[187] = (0, 0, 0);
	at[187] = 128.5000;
	points[188] = (509.0905, -20796.7324, 3838.5828);
	angles[188] = (0, 0, 0);
	at[188] = 129;
	points[189] = (715.1497, -20813.7793, 3838.5828);
	angles[189] = (0, 0, 0);
	at[189] = 129.5000;
	points[190] = (902.6733, -20814.4883, 3838.5828);
	angles[190] = (0, 0, 0);
	at[190] = 130;
	points[191] = (1095.1654, -20799.8027, 3838.5828);
	angles[191] = (0, 0, 0);
	at[191] = 130.5000;
	points[192] = (1307.9174, -20770.4316, 3838.5828);
	angles[192] = (0, 0, 0);
	at[192] = 131;
	points[193] = (1539.8622, -20726.9707, 3838.5828);
	angles[193] = (0, 0, 0);
	at[193] = 131.5000;
	points[194] = (1789.9252, -20670, 3838.5828);
	angles[194] = (0, 0, 0);
	at[194] = 132;
	points[195] = (1982.1221, -20620.4727, 3838.5828);
	angles[195] = (0, 0, 0);
	at[195] = 132.5000;
	points[196] = (2182.5315, -20564.4473, 3838.5828);
	angles[196] = (0, 0, 0);
	at[196] = 133;
	points[197] = (2391.0708, -20502.0859, 3838.5828);
	angles[197] = (0, 0, 0);
	at[197] = 133.5000;
	points[198] = (2607.3347, -20433.5449, 3838.5828);
	angles[198] = (0, 0, 0);
	at[198] = 134;
	points[199] = (2830.9133, -20359.0547, 3838.5828);
	angles[199] = (0, 0, 0);
	at[199] = 134.5000;
	points[200] = (3059.3032, -20279.6055, 3838.5828);
	angles[200] = (0, 0, 0);
	at[200] = 135;
	points[201] = (3253.9727, -20209.4492, 3838.5828);
	angles[201] = (0, 0, 0);
	at[201] = 135.5000;
	points[202] = (3452.8306, -20135.6699, 3838.5828);
	angles[202] = (0, 0, 0);
	at[202] = 136;
	points[203] = (3655.6458, -20058.3867, 3838.5828);
	angles[203] = (0, 0, 0);
	at[203] = 136.5000;
	points[204] = (3862.1892, -19977.7559, 3838.5828);
	angles[204] = (0, 0, 0);
	at[204] = 137;
	points[205] = (4072.2441, -19893.8203, 3838.5828);
	angles[205] = (0, 0, 0);
	at[205] = 137.5000;
	points[206] = (4285.5513, -19806.8105, 3838.5828);
	angles[206] = (0, 0, 0);
	at[206] = 138;
	points[207] = (4501.9292, -19716.7324, 3838.5828);
	angles[207] = (0, 0, 0);
	at[207] = 138.5000;
	points[208] = (5098.8584, -19459.7637, 3838.5828);
	angles[208] = (0, 0, 0);
	at[208] = 140;
	points[209] = (5503.2681, -19279.1738, 3838.5828);
	angles[209] = (0, 0, 0);
	at[209] = 141;
	points[210] = (5707.6772, -19186.0234, 3838.5828);
	angles[210] = (0, 0, 0);
	at[210] = 141.5000;
	points[211] = (6120.2363, -18994.4102, 3838.5828);
	angles[211] = (0, 0, 0);
	at[211] = 142.5000;
	points[212] = (6319.8818, -18899.9609, 3838.5828);
	angles[212] = (0, 0, 0);
	at[212] = 143;
	points[213] = (6914.4487, -18612.5195, 3838.5828);
	angles[213] = (0, 0, 0);
	at[213] = 144.5000;
	points[214] = (7312.5986, -18414.9219, 3838.5828);
	angles[214] = (0, 0, 0);
	at[214] = 145.5000;
	points[215] = (7710.7876, -18213.2676, 3838.5828);
	angles[215] = (0, 0, 0);
	at[215] = 146.5000;
	points[216] = (8305, -17904.9219, 3838.5828);
	angles[216] = (0, 0, 0);
	at[216] = 148;
	points[217] = (8697.8350, -17696.0645, 3838.5828);
	angles[217] = (0, 0, 0);
	at[217] = 149;
	points[218] = (9086.9287, -17485.1973, 3838.5828);
	angles[218] = (0, 0, 0);
	at[218] = 150;
	points[219] = (9471.1807, -17272.8730, 3838.5828);
	angles[219] = (0, 0, 0);
	at[219] = 151;
	points[220] = (9865.2754, -17050.7480, 3838.5828);
	angles[220] = (0, 0, 0);
	at[220] = 152;
	points[221] = (10254.6846, -16826.5352, 3838.5828);
	angles[221] = (0, 0, 0);
	at[221] = 153;
	points[222] = (10446.0625, -16714.5664, 3838.5828);
	angles[222] = (0, 0, 0);
	at[222] = 153.5000;
	points[223] = (10821.3389, -16491.2207, 3838.5828);
	angles[223] = (0, 0, 0);
	at[223] = 154.5000;
	points[224] = (11004.9609, -16380.0400, 3838.5828);
	angles[224] = (0, 0, 0);
	at[224] = 155;
	points[225] = (11196.6934, -16262.4795, 3838.5828);
	angles[225] = (0, 0, 0);
	at[225] = 155.5000;
	points[226] = (11394.1348, -16139.7646, 3838.5828);
	angles[226] = (0, 0, 0);
	at[226] = 156;
	points[227] = (11587.5986, -16017.7949, 3838.5828);
	angles[227] = (0, 0, 0);
	at[227] = 156.5000;
	points[228] = (11776.7725, -15896.6934, 3838.5828);
	angles[228] = (0, 0, 0);
	at[228] = 157;
	points[229] = (11961.4570, -15776.6152, 3838.5828);
	angles[229] = (0, 0, 0);
	at[229] = 157.5000;
	points[230] = (12141.4570, -15657.6387, 3838.5828);
	angles[230] = (0, 0, 0);
	at[230] = 158;
	points[231] = (12316.5752, -15539.8828, 3838.5828);
	angles[231] = (0, 0, 0);
	at[231] = 158.5000;
	points[232] = (12494.6846, -15417.8750, 3838.5828);
	angles[232] = (0, 0, 0);
	at[232] = 159;
	points[233] = (12692.1260, -15279.5674, 3838.5828);
	angles[233] = (0, 0, 0);
	at[233] = 159.5000;
	points[234] = (12881.4170, -15143.5830, 3838.5828);
	angles[234] = (0, 0, 0);
	at[234] = 160;
	points[235] = (13062.1650, -15010.1572, 3838.5828);
	angles[235] = (0, 0, 0);
	at[235] = 160.5000;
	points[236] = (13233.9375, -14879.4883, 3838.5828);
	angles[236] = (0, 0, 0);
	at[236] = 161;
	points[237] = (13396.3779, -14751.7725, 3838.5828);
	angles[237] = (0, 0, 0);
	at[237] = 161.5000;
	points[238] = (13558.7803, -14619.0947, 3838.5828);
	angles[238] = (0, 0, 0);
	at[238] = 162;
	points[239] = (13750.2373, -14454.5674, 3838.5828);
	angles[239] = (0, 0, 0);
	at[239] = 162.5000;
	points[240] = (13921.7725, -14296.8115, 3838.5828);
	angles[240] = (0, 0, 0);
	at[240] = 163;
	points[241] = (14072.3623, -14146.4180, 3838.5828);
	angles[241] = (0, 0, 0);
	at[241] = 163.5000;
	points[242] = (14201.1025, -14003.8584, 3838.5828);
	angles[242] = (0, 0, 0);
	at[242] = 164;
	points[243] = (14318.0703, -13855.3936, 3838.5828);
	angles[243] = (0, 0, 0);
	at[243] = 164.5000;
	points[244] = (14435.4727, -13684.2910, 3838.5828);
	angles[244] = (0, 0, 0);
	at[244] = 165;
	points[245] = (14552.3623, -13492.4414, 3838.5828);
	angles[245] = (0, 0, 0);
	at[245] = 165.5000;
	points[246] = (14668.6221, -13280.9053, 3838.5828);
	angles[246] = (0, 0, 0);
	at[246] = 166;
	points[247] = (14769.4883, -13080.9453, 3838.5828);
	angles[247] = (0, 0, 0);
	at[247] = 166.5000;
	points[248] = (14857.8350, -12893.4639, 3838.5828);
	angles[248] = (0, 0, 0);
	at[248] = 167;
	points[249] = (14945.5908, -12695.9443, 3838.5828);
	angles[249] = (0, 0, 0);
	at[249] = 167.5000;
	points[250] = (15032.7168, -12488.7793, 3838.5828);
	angles[250] = (0, 0, 0);
	at[250] = 168;
	points[251] = (15119.1738, -12272.5195, 3838.5828);
	angles[251] = (0, 0, 0);
	at[251] = 168.5000;
	points[252] = (15203.5820, -12050.9443, 3838.5828);
	angles[252] = (0, 0, 0);
	at[252] = 169;
	points[253] = (15275.3936, -11854.4883, 3838.5828);
	angles[253] = (0, 0, 0);
	at[253] = 169.5000;
	points[254] = (15346.5752, -11652.4404, 3838.5828);
	angles[254] = (0, 0, 0);
	at[254] = 170;
	points[255] = (15417.1260, -11445.0781, 3838.5828);
	angles[255] = (0, 0, 0);
	at[255] = 170.5000;
	points[256] = (15486.9678, -11232.7168, 3838.5828);
	angles[256] = (0, 0, 0);
	at[256] = 171;
	points[257] = (15556.1025, -11015.5898, 3838.5828);
	angles[257] = (0, 0, 0);
	at[257] = 171.5000;
	points[258] = (15624.4883, -10794.0156, 3838.5828);
	angles[258] = (0, 0, 0);
	at[258] = 172;
	points[259] = (15687.8740, -10582.3223, 3838.5828);
	angles[259] = (0, 0, 0);
	at[259] = 172.5000;
	points[260] = (15807.9531, -10165.1582, 3838.5828);
	angles[260] = (0, 0, 0);
	at[260] = 173.5000;
	points[261] = (15925.1182, -9736.8506, 3838.5828);
	angles[261] = (0, 0, 0);
	at[261] = 174.5000;
	points[262] = (16039.1729, -9299.0557, 3838.5828);
	angles[262] = (0, 0, 0);
	at[262] = 175.5000;
	points[263] = (16093.6230, -9082.5195, 3838.5828);
	angles[263] = (0, 0, 0);
	at[263] = 176;
	points[264] = (16197.4014, -8655.7090, 3838.5828);
	angles[264] = (0, 0, 0);
	at[264] = 177;
	points[265] = (16297.9141, -8223.9766, 3838.5828);
	angles[265] = (0, 0, 0);
	at[265] = 178;
	points[266] = (16442.1270, -7570.2759, 3838.5828);
	angles[266] = (0, 0, 0);
	at[266] = 179.5000;
	points[267] = (16577.3633, -6916.4961, 3838.5828);
	angles[267] = (0, 0, 0);
	at[267] = 181;
	points[268] = (16662.6367, -6481.3389, 3838.5828);
	angles[268] = (0, 0, 0);
	at[268] = 182;
	points[269] = (16783.3867, -5829.1733, 3838.5828);
	angles[269] = (0, 0, 0);
	at[269] = 183.5000;
	points[270] = (16897.8340, -5164.3306, 3838.5828);
	angles[270] = (0, 0, 0);
	at[270] = 185;
	points[271] = (16967.8340, -4729.5669, 3838.5828);
	angles[271] = (0, 0, 0);
	at[271] = 186;
	points[272] = (17033.1094, -4299.5669, 3838.5828);
	angles[272] = (0, 0, 0);
	at[272] = 187;
	points[273] = (17066.2598, -4070.2756, 3838.5828);
	angles[273] = (0, 0, 0);
	at[273] = 187.5000;
	points[274] = (17097.7168, -3844.2834, 3838.5828);
	angles[274] = (0, 0, 0);
	at[274] = 188;
	points[275] = (17127.4414, -3621.8818, 3838.5828);
	angles[275] = (0, 0, 0);
	at[275] = 188.5000;
	points[276] = (17155.4727, -3403.3269, 3838.5828);
	angles[276] = (0, 0, 0);
	at[276] = 189;
	points[277] = (17181.6934, -3188.8818, 3838.5828);
	angles[277] = (0, 0, 0);
	at[277] = 189.5000;
	points[278] = (17206.1035, -2978.8071, 3838.5828);
	angles[278] = (0, 0, 0);
	at[278] = 190;
	points[279] = (17230.8262, -2753.2444, 3838.5828);
	angles[279] = (0, 0, 0);
	at[279] = 190.5000;
	points[280] = (17254.6855, -2519.3032, 3838.5828);
	angles[280] = (0, 0, 0);
	at[280] = 191;
	points[281] = (17275.9062, -2292.5354, 3838.5828);
	angles[281] = (0, 0, 0);
	at[281] = 191.5000;
	points[282] = (17294.4492, -2073.3662, 3838.5828);
	angles[282] = (0, 0, 0);
	at[282] = 192;
	points[283] = (17310.2363, -1862.2086, 3838.5828);
	angles[283] = (0, 0, 0);
	at[283] = 192.5000;
	points[284] = (17323.2285, -1659.4883, 3838.5828);
	angles[284] = (0, 0, 0);
	at[284] = 193;
	points[285] = (17335.7090, -1413.1104, 3838.5828);
	angles[285] = (0, 0, 0);
	at[285] = 193.5000;
	points[286] = (17343.5039, -1178.7559, 3838.5828);
	angles[286] = (0, 0, 0);
	at[286] = 194;
	points[287] = (17346.2598, -961.1654, 3838.5828);
	angles[287] = (0, 0, 0);
	at[287] = 194.5000;
	points[288] = (17343.8574, -761.2559, 3838.5828);
	angles[288] = (0, 0, 0);
	at[288] = 195;
	points[289] = (17335.9844, -573.8071, 3838.5828);
	angles[289] = (0, 0, 0);
	at[289] = 195.5000;
	points[290] = (17321.5742, -371.5701, 3838.5828);
	angles[290] = (0, 0, 0);
	at[290] = 196;
	points[291] = (17300.6699, -151.9807, 3838.5828);
	angles[291] = (0, 0, 0);
	at[291] = 196.5000;
	points[292] = (17273.4258, 84.0492, 3838.5828);
	angles[292] = (0, 0, 0);
	at[292] = 197;
	points[293] = (17241.9688, 321.8079, 3838.5828);
	angles[293] = (0, 0, 0);
	at[293] = 197.5000;
	points[294] = (17212.6367, 523.9134, 3838.5828);
	angles[294] = (0, 0, 0);
	at[294] = 198;
	points[295] = (17179.9219, 734.2165, 3838.5828);
	angles[295] = (0, 0, 0);
	at[295] = 198.5000;
	points[296] = (17143.8594, 952.3110, 3838.5828);
	angles[296] = (0, 0, 0);
	at[296] = 199;
	points[297] = (17104.5664, 1177.7875, 3838.5828);
	angles[297] = (0, 0, 0);
	at[297] = 199.5000;
	points[298] = (17062.1250, 1410.2323, 3838.5828);
	angles[298] = (0, 0, 0);
	at[298] = 200;
	points[299] = (17020.3535, 1629.9685, 3838.5828);
	angles[299] = (0, 0, 0);
	at[299] = 200.5000;
	points[300] = (16979.5273, 1837.7756, 3838.5828);
	angles[300] = (0, 0, 0);
	at[300] = 201;
	points[301] = (16936.5742, 2049.8032, 3838.5828);
	angles[301] = (0, 0, 0);
	at[301] = 201.5000;
	points[302] = (16891.5742, 2265.8032, 3838.5828);
	angles[302] = (0, 0, 0);
	at[302] = 202;
	points[303] = (16844.5664, 2485.5195, 3838.5828);
	angles[303] = (0, 0, 0);
	at[303] = 202.5000;
	points[304] = (16744.8027, 2935.0867, 3838.5828);
	angles[304] = (0, 0, 0);
	at[304] = 203.5000;
	points[305] = (16646.7324, 3358.0786, 3838.5828);
	angles[305] = (0, 0, 0);
	at[305] = 204.5000;
	points[306] = (16543.6621, 3786.1062, 3838.5828);
	angles[306] = (0, 0, 0);
	at[306] = 205.5000;
	points[307] = (16378.8975, 4440.3149, 3838.5828);
	angles[307] = (0, 0, 0);
	at[307] = 207;
	points[308] = (16266.3779, 4868.7402, 3838.5828);
	angles[308] = (0, 0, 0);
	at[308] = 208;
	points[309] = (16150.7881, 5295.2759, 3838.5828);
	angles[309] = (0, 0, 0);
	at[309] = 209;
	points[310] = (15969.9609, 5937.2837, 3838.5828);
	angles[310] = (0, 0, 0);
	at[310] = 210.5000;
	points[311] = (15780.6299, 6579.2129, 3838.5828);
	angles[311] = (0, 0, 0);
	at[311] = 212;
	points[312] = (15583.9375, 7215.9453, 3838.5828);
	angles[312] = (0, 0, 0);
	at[312] = 213.5000;
	points[313] = (15380.3545, 7844.0161, 3838.5828);
	angles[313] = (0, 0, 0);
	at[313] = 215;
	points[314] = (15235.1182, 8273.5830, 3838.5828);
	angles[314] = (0, 0, 0);
	at[314] = 216;
	points[315] = (15161.6152, 8485.1182, 3838.5828);
	angles[315] = (0, 0, 0);
	at[315] = 216.5000;
	points[316] = (15013.1104, 8900.5908, 3838.5828);
	angles[316] = (0, 0, 0);
	at[316] = 217.5000;
	points[317] = (14938.1885, 9104.1338, 3838.5828);
	angles[317] = (0, 0, 0);
	at[317] = 218;
	points[318] = (14862.8350, 9304.6855, 3838.5828);
	angles[318] = (0, 0, 0);
	at[318] = 218.5000;
	points[319] = (14695.7881, 9734.5664, 3838.5828);
	angles[319] = (0, 0, 0);
	at[319] = 219.5000;
	points[320] = (14611.3779, 9943.8584, 3838.5828);
	angles[320] = (0, 0, 0);
	at[320] = 220;
	points[321] = (14526.6934, 10148.4248, 3838.5828);
	angles[321] = (0, 0, 0);
	at[321] = 220.5000;
	points[322] = (14441.8105, 10347.9922, 3838.5828);
	angles[322] = (0, 0, 0);
	at[322] = 221;
	points[323] = (14356.7715, 10542.2441, 3838.5828);
	angles[323] = (0, 0, 0);
	at[323] = 221.5000;
	points[324] = (14266.4961, 10742.0469, 3838.5828);
	angles[324] = (0, 0, 0);
	at[324] = 222;
	points[325] = (14165.8271, 10957.1260, 3838.5828);
	angles[325] = (0, 0, 0);
	at[325] = 222.5000;
	points[326] = (14065.1582, 11163.6621, 3838.5828);
	angles[326] = (0, 0, 0);
	at[326] = 223;
	points[327] = (13964.6064, 11361.1416, 3838.5828);
	angles[327] = (0, 0, 0);
	at[327] = 223.5000;
	points[328] = (13864.2529, 11549.1729, 3838.5828);
	angles[328] = (0, 0, 0);
	at[328] = 224;
	points[329] = (13764.2520, 11727.2832, 3838.5828);
	angles[329] = (0, 0, 0);
	at[329] = 224.5000;
	points[330] = (13641.8896, 11931.9688, 3838.5828);
	angles[330] = (0, 0, 0);
	at[330] = 225;
	points[331] = (13513.2676, 12130.6309, 3838.5828);
	angles[331] = (0, 0, 0);
	at[331] = 225.5000;
	points[332] = (13385.7090, 12309.9609, 3838.5828);
	angles[332] = (0, 0, 0);
	at[332] = 226;
	points[333] = (13259.4092, 12468.9375, 3838.5828);
	angles[333] = (0, 0, 0);
	at[333] = 226.5000;
	points[334] = (13134.2910, 12607.2842, 3838.5828);
	angles[334] = (0, 0, 0);
	at[334] = 227;
	points[335] = (12993.1895, 12745.7480, 3838.5828);
	angles[335] = (0, 0, 0);
	at[335] = 227.5000;
	points[336] = (12831.1807, 12890.7090, 3838.5828);
	angles[336] = (0, 0, 0);
	at[336] = 228;
	points[337] = (12649.2129, 13041.7324, 3838.5828);
	angles[337] = (0, 0, 0);
	at[337] = 228.5000;
	points[338] = (12449.1348, 13197.5986, 3838.5828);
	angles[338] = (0, 0, 0);
	at[338] = 229;
	points[339] = (12288.8975, 13316.6543, 3838.5828);
	angles[339] = (0, 0, 0);
	at[339] = 229.5000;
	points[340] = (12119.1338, 13438.3857, 3838.5828);
	angles[340] = (0, 0, 0);
	at[340] = 230;
	points[341] = (11940.2373, 13562.5596, 3838.5828);
	angles[341] = (0, 0, 0);
	at[341] = 230.5000;
	points[342] = (11752.5986, 13688.9766, 3838.5828);
	angles[342] = (0, 0, 0);
	at[342] = 231;
	points[343] = (11556.5361, 13817.4805, 3838.5828);
	angles[343] = (0, 0, 0);
	at[343] = 231.5000;
	points[344] = (11352.5195, 13947.9141, 3838.5828);
	angles[344] = (0, 0, 0);
	at[344] = 232;
	points[345] = (11176.0234, 14058.3066, 3838.5828);
	angles[345] = (0, 0, 0);
	at[345] = 232.5000;
	points[346] = (10995.1182, 14169.4102, 3838.5828);
	angles[346] = (0, 0, 0);
	at[346] = 233;
	points[347] = (10809.3711, 14281.4570, 3838.5828);
	angles[347] = (0, 0, 0);
	at[347] = 233.5000;
	points[348] = (10618.9756, 14394.4102, 3838.5828);
	angles[348] = (0, 0, 0);
	at[348] = 234;
	points[349] = (10424.1729, 14508.1494, 3838.5828);
	angles[349] = (0, 0, 0);
	at[349] = 234.5000;
	points[350] = (10225.1973, 14622.5195, 3838.5828);
	angles[350] = (0, 0, 0);
	at[350] = 235;
	points[351] = (10022.2441, 14737.5205, 3838.5828);
	angles[351] = (0, 0, 0);
	at[351] = 235.5000;
	points[352] = (9642.4023, 14948.4258, 3838.5828);
	angles[352] = (0, 0, 0);
	at[352] = 236.5000;
	points[353] = (9257.2051, 15157.0859, 3838.5828);
	angles[353] = (0, 0, 0);
	at[353] = 237.5000;
	points[354] = (8862.4805, 15366.0635, 3838.5828);
	angles[354] = (0, 0, 0);
	at[354] = 238.5000;
	points[355] = (8459.4102, 15574.7246, 3838.5828);
	angles[355] = (0, 0, 0);
	at[355] = 239.5000;
	points[356] = (7868.9761, 15872.4014, 3838.5828);
	angles[356] = (0, 0, 0);
	at[356] = 241;
	points[357] = (7471.4175, 16067.7959, 3838.5828);
	angles[357] = (0, 0, 0);
	at[357] = 242;
	points[358] = (7070.2363, 16261.0234, 3838.5828);
	angles[358] = (0, 0, 0);
	at[358] = 243;
	points[359] = (6464.2124, 16545.6309, 3838.5828);
	angles[359] = (0, 0, 0);
	at[359] = 244.5000;
	points[360] = (6058.9761, 16731.1035, 3838.5828);
	angles[360] = (0, 0, 0);
	at[360] = 245.5000;
	points[361] = (5653.9761, 16912.5977, 3838.5828);
	angles[361] = (0, 0, 0);
	at[361] = 246.5000;
	points[362] = (5049.2915, 17176.2207, 3838.5828);
	angles[362] = (0, 0, 0);
	at[362] = 248;
	points[363] = (4632.5591, 17352.5996, 3838.5828);
	angles[363] = (0, 0, 0);
	at[363] = 249;
	points[364] = (4217.5195, 17523.7402, 3838.5828);
	angles[364] = (0, 0, 0);
	at[364] = 250;
	points[365] = (3808.3071, 17687.8340, 3838.5828);
	angles[365] = (0, 0, 0);
	at[365] = 251;
	points[366] = (3406.1379, 17844.2910, 3838.5828);
	angles[366] = (0, 0, 0);
	at[366] = 252;
	points[367] = (3193.9607, 17924.7637, 3838.5828);
	angles[367] = (0, 0, 0);
	at[367] = 252.5000;
	points[368] = (2976.7717, 18005.5918, 3838.5828);
	angles[368] = (0, 0, 0);
	at[368] = 253;
	points[369] = (2762.5750, 18083.6621, 3838.5828);
	angles[369] = (0, 0, 0);
	at[369] = 253.5000;
	points[370] = (2551.5906, 18158.8984, 3838.5828);
	angles[370] = (0, 0, 0);
	at[370] = 254;
	points[371] = (2344.0356, 18231.1426, 3838.5828);
	angles[371] = (0, 0, 0);
	at[371] = 254.5000;
	points[372] = (2140.1260, 18300.3555, 3838.5828);
	angles[372] = (0, 0, 0);
	at[372] = 255;
	points[373] = (1940.0787, 18366.3789, 3838.5828);
	angles[373] = (0, 0, 0);
	at[373] = 255.5000;
	points[374] = (1729.6102, 18433.7012, 3838.5828);
	angles[374] = (0, 0, 0);
	at[374] = 256;
	points[375] = (1501.0316, 18504.1348, 3838.5828);
	angles[375] = (0, 0, 0);
	at[375] = 256.5000;
	points[376] = (1279.0118, 18569.5273, 3838.5828);
	angles[376] = (0, 0, 0);
	at[376] = 257;
	points[377] = (1063.9253, 18629.6855, 3838.5828);
	angles[377] = (0, 0, 0);
	at[377] = 257.5000;
	points[378] = (856.1378, 18684.4883, 3838.5828);
	angles[378] = (0, 0, 0);
	at[378] = 258;
	points[379] = (656.0275, 18733.7402, 3838.5828);
	angles[379] = (0, 0, 0);
	at[379] = 258.5000;
	points[380] = (443.9724, 18781.5742, 3838.5828);
	angles[380] = (0, 0, 0);
	at[380] = 259;
	points[381] = (200.3126, 18829.8438, 3838.5828);
	angles[381] = (0, 0, 0);
	at[381] = 259.5000;
	points[382] = (-27.1438, 18867.0078, 3838.5828);
	angles[382] = (0, 0, 0);
	at[382] = 260;
	points[383] = (-237.4910, 18892.5586, 3838.5828);
	angles[383] = (0, 0, 0);
	at[383] = 260.5000;
	points[384] = (-429.8228, 18906.0625, 3838.5828);
	angles[384] = (0, 0, 0);
	at[384] = 261;
	points[385] = (-470.3622, 18907.4004, 3838.5828);
	angles[385] = (0, 0, 0);
	at[385] = 261.1170;
	mover = getEnt("iz_obj_4", "targetname");
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
