main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_singapore", 0);

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
	ambientPlay("iz_0_tsings", 2);
	level thread iz_music("iz_7_se_cn_tge_env_buildi");
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
	level.iz_route[level.iz_route.size] = (4055, 6459, 1159);
	level.iz_route[level.iz_route.size] = (2316, 6464, 1142);
	level.iz_route[level.iz_route.size] = (1249, 6468, 918);
	level.iz_route[level.iz_route.size] = (263, 6460, 760);
	level.iz_route[level.iz_route.size] = (-996, 6453, 751);
	level.iz_route[level.iz_route.size] = (-1855, 6214, 751);
	level.iz_route[level.iz_route.size] = (-2973, 6207, 751);
	level.iz_route[level.iz_route.size] = (-4156, 6237, 751);
	level.iz_route[level.iz_route.size] = (-5031, 6687, 751);
	level.iz_route[level.iz_route.size] = (-5935, 7250, 751);
	level.iz_route[level.iz_route.size] = (-6622, 7731, 751);
	level.iz_route[level.iz_route.size] = (-7197, 7946, 751);
	level.iz_route[level.iz_route.size] = (-7525, 7865, 751);
	level.iz_route[level.iz_route.size] = (-8104, 7587, 751);
	level.iz_route[level.iz_route.size] = (-9012, 6661, 751);
	level.iz_route[level.iz_route.size] = (-9853, 5546, 751);
	level.iz_route[level.iz_route.size] = (-9954, 4964, 751);
	level.iz_route[level.iz_route.size] = (-9729, 4437, 751);
	level.iz_route[level.iz_route.size] = (-8195, 1858, 1076);
	level.iz_route[level.iz_route.size] = (-5128, -4648, 4967);
	level.iz_route[level.iz_route.size] = (-4253, -5038, 4926);
	level.iz_route[level.iz_route.size] = (-2707, -5344, 4926);
	level.iz_route[level.iz_route.size] = (-1488, -5378, 4926);
	level.iz_route[level.iz_route.size] = (179, -5190, 4926);
	level.iz_route[level.iz_route.size] = (1577, -4886, 4967);
	level.iz_route[level.iz_route.size] = (2411, -4537, 4932);
	level.iz_route[level.iz_route.size] = (7558, 373, 732);
	level.iz_route[level.iz_route.size] = (8946, 1685, 754);
	level.iz_route[level.iz_route.size] = (10485, 3293, 792);
	level.iz_route[level.iz_route.size] = (10829, 4033, 875);
	level.iz_route[level.iz_route.size] = (10797, 4872, 930);
	level.iz_route[level.iz_route.size] = (10340, 5873, 1011);
	level.iz_route[level.iz_route.size] = (9627, 6347, 1055);
	level.iz_route[level.iz_route.size] = (8734, 6475, 1082);
	level.iz_route[level.iz_route.size] = (6455, 6502, 1142);
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
	points[0] = (7358.7402, 4046.0630, 6363.6611);
	angles[0] = (0, 87.3168, 0);
	at[0] = 0;
	points[1] = (7243.1895, 4023.1101, 6363.6611);
	angles[1] = (0, 95.9702, 0);
	at[1] = 0.3167;
	points[2] = (7127.6382, 4000.1179, 6363.6611);
	angles[2] = (0, 99.2551, 0);
	at[2] = 0.6333;
	points[3] = (6549.8823, 3885.2205, 6363.6611);
	angles[3] = (0, 101.2326, 0);
	at[3] = 2.2167;
	points[4] = (6330.2358, 3800.3071, 6363.6611);
	angles[4] = (0, 109.9433, 0);
	at[4] = 2.8500;
	points[5] = (5782.0869, 3584.5710, 6363.6611);
	angles[5] = (0, 111.4716, 0);
	at[5] = 4.4333;
	points[6] = (5693.8979, 3512.3386, 6363.6611);
	angles[6] = (0, 124.9701, 0);
	at[6] = 4.7500;
	points[7] = (5620.3545, 3420.3110, 6363.6611);
	angles[7] = (0, 135.1441, 0);
	at[7] = 5.0667;
	points[8] = (5546.7720, 3328.2834, 6363.6611);
	angles[8] = (0, 139.0153, 0);
	at[8] = 5.3833;
	points[9] = (5252.5200, 2960.1694, 6363.6611);
	angles[9] = (0, 141.3166, 0);
	at[9] = 6.6500;
	points[10] = (5201.1025, 2854.3347, 6363.6611);
	angles[10] = (0, 149.6282, 0);
	at[10] = 6.9667;
	points[11] = (5150.7480, 2747.8230, 6363.6611);
	angles[11] = (0, 152.7819, 0);
	at[11] = 7.2833;
	points[12] = (4898.9370, 2215.2756, 6363.6611);
	angles[12] = (0, 154.6801, 0);
	at[12] = 8.8667;
	points[13] = (4852.9136, 2107.1575, 6363.6611);
	angles[13] = (0, 156.9050, 0);
	at[13] = 9.1833;
	points[14] = (4790, 1880.0748, 6363.6611);
	angles[14] = (0, 163.4349, 0);
	at[14] = 9.8167;
	points[15] = (4601.3389, 1198.8268, 6363.6611);
	angles[15] = (0, 164.5176, 0);
	at[15] = 11.7167;
	points[16] = (4572.2051, 1084.8149, 6363.6611);
	angles[16] = (0, 165.6318, 0);
	at[16] = 12.0333;
	points[17] = (4540.7876, 851.2914, 6363.6611);
	angles[17] = (0, 171.3814, 0);
	at[17] = 12.6667;
	points[18] = (4430.8267, 33.9489, 6363.6611);
	angles[18] = (0, 172.3362, 0);
	at[18] = 14.8833;
	points[19] = (4418.4253, -83.1760, 6363.6611);
	angles[19] = (0, 173.5658, 0);
	at[19] = 15.2000;
	points[20] = (4339.3311, -1022.3740, 6363.6611);
	angles[20] = (0, 175.1872, 0);
	at[20] = 17.7333;
	points[21] = (4357.0474, -1257.1653, 6363.6611);
	angles[21] = (0, 183.3092, 0);
	at[21] = 18.3667;
	points[22] = (4426.5747, -2078.9370, 6363.6611);
	angles[22] = (0, 184.8329, 0);
	at[22] = 20.5833;
	points[23] = (4441.3779, -2195.5510, 6363.6611);
	angles[23] = (0, 187.0942, 0);
	at[23] = 20.9000;
	points[24] = (4495.9058, -2424.7795, 6363.6611);
	angles[24] = (0, 192.4890, 0);
	at[24] = 21.5333;
	points[25] = (4632.2837, -2997.8506, 6363.6611);
	angles[25] = (0, 193.3788, 0);
	at[25] = 23.1167;
	points[26] = (4665.9844, -3110.2166, 6363.6611);
	angles[26] = (0, 196.4797, 0);
	at[26] = 23.4333;
	points[27] = (4766.0630, -3323.5549, 6363.6611);
	angles[27] = (0, 203.8906, 0);
	at[27] = 24.0667;
	points[28] = (5066.1812, -3963.5828, 6363.6611);
	angles[28] = (0, 205.1201, 0);
	at[28] = 25.9667;
	points[29] = (5148.9375, -4047.2444, 6363.6611);
	angles[29] = (0, 217.4354, 0);
	at[29] = 26.2833;
	points[30] = (5232.2441, -4130.5513, 6363.6611);
	angles[30] = (0, 222.1394, 0);
	at[30] = 26.6000;
	points[31] = (5815.3545, -4713.7798, 6363.6611);
	angles[31] = (0, 224.9925, 0);
	at[31] = 28.8167;
	points[32] = (5905.9053, -4786.6143, 6363.6611);
	angles[32] = (0, 230.3690, 0);
	at[32] = 29.1333;
	points[33] = (6013.1494, -4835.3545, 6363.6611);
	angles[33] = (0, 239.7912, 0);
	at[33] = 29.4500;
	points[34] = (6120.3936, -4884.1338, 6363.6611);
	angles[34] = (0, 243.3719, 0);
	at[34] = 29.7667;
	points[35] = (6763.8975, -5176.7720, 6363.6611);
	angles[35] = (0, 245.5381, 0);
	at[35] = 31.6667;
	points[36] = (6873.5044, -5217.0078, 6363.6611);
	angles[36] = (0, 249.5792, 0);
	at[36] = 31.9833;
	points[37] = (6990.5513, -5230.1968, 6363.6611);
	angles[37] = (0, 258.2758, 0);
	at[37] = 32.3000;
	points[38] = (7107.6377, -5243.3467, 6363.6611);
	angles[38] = (0, 261.5774, 0);
	at[38] = 32.6167;
	points[39] = (8044.2524, -5348.7402, 6363.6611);
	angles[39] = (0, 264.3458, 0);
	at[39] = 35.1500;
	points[40] = (8160.5908, -5329.6851, 6363.6611);
	angles[40] = (0, 273.4921, 0);
	at[40] = 35.4667;
	points[41] = (8276.9287, -5311.1021, 6363.6611);
	angles[41] = (0, 276.9666, 0);
	at[41] = 35.7833;
	points[42] = (9207.6377, -5162.4414, 6363.6611);
	angles[42] = (0, 279.0735, 0);
	at[42] = 38.3167;
	points[43] = (9311.1416, -5109.8032, 6363.6611);
	angles[43] = (0, 291.4198, 0);
	at[43] = 38.6333;
	points[44] = (9410.7480, -5046.8896, 6363.6611);
	angles[44] = (0, 298.1709, 0);
	at[44] = 38.9500;
	points[45] = (9510.3545, -4983.9766, 6363.6611);
	angles[45] = (0, 300.7276, 0);
	at[45] = 39.2667;
	points[46] = (10107.9932, -4606.4565, 6363.6611);
	angles[46] = (0, 302.2735, 0);
	at[46] = 41.1667;
	points[47] = (10202.7959, -4537.8740, 6363.6611);
	angles[47] = (0, 305.8113, 0);
	at[47] = 41.4833;
	points[48] = (10281.6152, -4450.2759, 6363.6611);
	angles[48] = (0, 313.4057, 0);
	at[48] = 41.8000;
	points[49] = (10360.3936, -4362.6772, 6363.6611);
	angles[49] = (0, 316.2846, 0);
	at[49] = 42.1167;
	points[50] = (10833.1104, -3837.0986, 6363.6611);
	angles[50] = (0, 318.0255, 0);
	at[50] = 44.0167;
	points[51] = (10903.9766, -3743.5510, 6363.6611);
	angles[51] = (0, 322.0313, 0);
	at[51] = 44.3333;
	points[52] = (11028.7402, -3543.6616, 6363.6611);
	angles[52] = (0, 327.1734, 0);
	at[52] = 44.9667;
	points[53] = (11403.0312, -2944.0042, 6363.6611);
	angles[53] = (0, 328.0255, 0);
	at[53] = 46.8667;
	points[54] = (11459.6846, -2841.4841, 6363.6611);
	angles[54] = (0, 330.9078, 0);
	at[54] = 47.1833;
	points[55] = (11492.7559, -2728.4094, 6363.6611);
	angles[55] = (0, 338.8511, 0);
	at[55] = 47.5000;
	points[56] = (11525.8662, -2615.3345, 6363.6611);
	angles[56] = (0, 341.8636, 0);
	at[56] = 47.8167;
	points[57] = (11691.2607, -2049.9646, 6363.6611);
	angles[57] = (0, 343.6768, 0);
	at[57] = 49.4000;
	points[58] = (11716.6533, -1935.2993, 6363.6611);
	angles[58] = (0, 346.7888, 0);
	at[58] = 49.7167;
	points[59] = (11745.6689, -1701.4606, 6363.6611);
	angles[59] = (0, 352.0560, 0);
	at[59] = 50.3500;
	points[60] = (11832.6387, -999.9410, 6363.6611);
	angles[60] = (0, 352.9290, 0);
	at[60] = 52.2500;
	points[61] = (11839.2910, -882.6811, 6363.6611);
	angles[61] = (0, 356.0177, 0);
	at[61] = 52.5667;
	points[62] = (11830.5518, -647.2126, 6363.6611);
	angles[62] = (0, 361.2536, 0);
	at[62] = 53.2000;
	points[63] = (11813.0713, -176.2772, 6363.6611);
	angles[63] = (0, 362.1062, 0);
	at[63] = 54.4667;
	points[64] = (11802.9922, -59.2000, 6363.6611);
	angles[64] = (0, 364.7803, 0);
	at[64] = 54.7833;
	points[65] = (11758.1504, 172.1232, 6363.6611);
	angles[65] = (0, 370.0891, 0);
	at[65] = 55.4167;
	points[66] = (11646.0234, 750.4331, 6363.6611);
	angles[66] = (0, 370.9648, 0);
	at[66] = 57;
	points[67] = (11611.5742, 862.6693, 6363.6611);
	angles[67] = (0, 375.4531, 0);
	at[67] = 57.3167;
	points[68] = (11528.1104, 1083.0237, 6363.6611);
	angles[68] = (0, 379.9913, 0);
	at[68] = 57.9500;
	points[69] = (11319.4492, 1633.9015, 6363.6611);
	angles[69] = (0, 380.7397, 0);
	at[69] = 59.5333;
	points[70] = (11266.2197, 1738.0867, 6363.6611);
	angles[70] = (0, 385.7655, 0);
	at[70] = 59.8500;
	points[71] = (11133.1504, 1932.5315, 6363.6611);
	angles[71] = (0, 393.1593, 0);
	at[71] = 60.4833;
	points[72] = (10733.8594, 2515.8740, 6363.6611);
	angles[72] = (0, 394.3859, 0);
	at[72] = 62.3833;
	points[73] = (10650.4727, 2598.8425, 6363.6611);
	angles[73] = (0, 401.4296, 0);
	at[73] = 62.7000;
	points[74] = (10565.5908, 2680.5474, 6363.6611);
	angles[74] = (0, 404.3317, 0);
	at[74] = 63.0167;
	points[75] = (10141.2207, 3089.0710, 6363.6611);
	angles[75] = (0, 406.0782, 0);
	at[75] = 64.6000;
	points[76] = (10055.0391, 3169.2166, 6363.6611);
	angles[76] = (0, 407.3854, 0);
	at[76] = 64.9167;
	points[77] = (9861.4961, 3303.6101, 6363.6611);
	angles[77] = (0, 414.1075, 0);
	at[77] = 65.5500;
	points[78] = (9377.6377, 3639.5867, 6363.6611);
	angles[78] = (0, 415.2168, 0);
	at[78] = 67.1333;
	points[79] = (9268.8184, 3682.3306, 6363.6611);
	angles[79] = (0, 424.3329, 0);
	at[79] = 67.4500;
	points[80] = (9044.3311, 3754.0471, 6363.6611);
	angles[80] = (0, 431.1469, 0);
	at[80] = 68.0833;
	points[81] = (8370.9844, 3969.2126, 6363.6611);
	angles[81] = (0, 432.2769, 0);
	at[81] = 69.9833;
	points[82] = (8254.4883, 3982.9133, 6363.6611);
	angles[82] = (0, 439.8452, 0);
	at[82] = 70.3000;
	points[83] = (8137.0078, 3991.4963, 6363.6611);
	angles[83] = (0, 443.5710, 0);
	at[83] = 70.6167;
	points[84] = (7431.9688, 4042.8743, 6363.6611);
	angles[84] = (0, 445.8251, 0);
	at[84] = 72.5167;
	points[85] = (7358.7402, 4046.0630, 6363.6611);
	angles[85] = (0, 447.3168, 0);
	at[85] = 72.7167;
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
