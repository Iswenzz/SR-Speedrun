main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_sky_garden", 0);

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
	ambientPlay("iz_0_trsg", 2);
	level thread iz_music("iz_7_se_cn_knk_env_wind");
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
	level.iz_route[level.iz_route.size] = (-4659, -970, 532);
	level.iz_route[level.iz_route.size] = (-4669, -2189, 532);
	level.iz_route[level.iz_route.size] = (-4669, -3259, 532);
	level.iz_route[level.iz_route.size] = (-4690, -4242, 539);
	level.iz_route[level.iz_route.size] = (-4590, -4678, 547);
	level.iz_route[level.iz_route.size] = (-4392, -5003, 555);
	level.iz_route[level.iz_route.size] = (-4053, -5254, 558);
	level.iz_route[level.iz_route.size] = (-3501, -5377, 553);
	level.iz_route[level.iz_route.size] = (-2781, -5426, 550);
	level.iz_route[level.iz_route.size] = (-2018, -5440, 549);
	level.iz_route[level.iz_route.size] = (-1456, -5320, 545);
	level.iz_route[level.iz_route.size] = (-1202, -5129, 539);
	level.iz_route[level.iz_route.size] = (-826, -4734, 529);
	level.iz_route[level.iz_route.size] = (-257, -4056, 522);
	level.iz_route[level.iz_route.size] = (216, -3415, 528);
	level.iz_route[level.iz_route.size] = (493, -3113, 532);
	level.iz_route[level.iz_route.size] = (833, -2924, 529);
	level.iz_route[level.iz_route.size] = (1086, -2885, 526);
	level.iz_route[level.iz_route.size] = (1429, -2975, 522);
	level.iz_route[level.iz_route.size] = (1896, -3161, 519);
	level.iz_route[level.iz_route.size] = (2748, -3072, 519);
	level.iz_route[level.iz_route.size] = (3405, -2906, 525);
	level.iz_route[level.iz_route.size] = (4200, -2587, 533);
	level.iz_route[level.iz_route.size] = (4856, -1973, 546);
	level.iz_route[level.iz_route.size] = (5381, -1208, 533);
	level.iz_route[level.iz_route.size] = (5375, -638, 505);
	level.iz_route[level.iz_route.size] = (5372, -10, 500);
	level.iz_route[level.iz_route.size] = (5379, 1547, 808);
	level.iz_route[level.iz_route.size] = (5338, 3041, 618);
	level.iz_route[level.iz_route.size] = (5354, 3485, 675);
	level.iz_route[level.iz_route.size] = (5363, 4201, 764);
	level.iz_route[level.iz_route.size] = (5365, 4646, 830);
	level.iz_route[level.iz_route.size] = (5331, 5075, 904);
	level.iz_route[level.iz_route.size] = (5194, 5420, 969);
	level.iz_route[level.iz_route.size] = (4931, 5633, 1006);
	level.iz_route[level.iz_route.size] = (4575, 5733, 1019);
	level.iz_route[level.iz_route.size] = (4254, 5643, 995);
	level.iz_route[level.iz_route.size] = (3910, 5461, 962);
	level.iz_route[level.iz_route.size] = (3372, 5041, 943);
	level.iz_route[level.iz_route.size] = (2765, 4486, 1014);
	level.iz_route[level.iz_route.size] = (2208, 3936, 1094);
	level.iz_route[level.iz_route.size] = (1882, 3549, 1152);
	level.iz_route[level.iz_route.size] = (1655, 3113, 1222);
	level.iz_route[level.iz_route.size] = (1564, 2645, 1303);
	level.iz_route[level.iz_route.size] = (1525, 1988, 1426);
	level.iz_route[level.iz_route.size] = (1427, 1366, 1553);
	level.iz_route[level.iz_route.size] = (1210, 810, 1695);
	level.iz_route[level.iz_route.size] = (834, 403, 1830);
	level.iz_route[level.iz_route.size] = (391, 188, 1930);
	level.iz_route[level.iz_route.size] = (-130, 122, 2003);
	level.iz_route[level.iz_route.size] = (-685, 158, 2065);
	level.iz_route[level.iz_route.size] = (-1235, 369, 2113);
	level.iz_route[level.iz_route.size] = (-1643, 751, 2142);
	level.iz_route[level.iz_route.size] = (-1872, 1095, 2168);
	level.iz_route[level.iz_route.size] = (-1984, 1497, 2180);
	level.iz_route[level.iz_route.size] = (-2026, 2077, 2197);
	level.iz_route[level.iz_route.size] = (-2025, 2908, 2243);
	level.iz_route[level.iz_route.size] = (-2025, 3965, 2325);
	level.iz_route[level.iz_route.size] = (-2030, 5160, 2436);
	level.iz_route[level.iz_route.size] = (-2058, 6026, 2569);
	level.iz_route[level.iz_route.size] = (-2036, 6814, 2737);
	level.iz_route[level.iz_route.size] = (-2014, 7659, 2982);
	level.iz_route[level.iz_route.size] = (-2058, 8328, 3209);
	level.iz_route[level.iz_route.size] = (-2205, 8956, 3475);
	level.iz_route[level.iz_route.size] = (-2482, 9367, 3688);
	level.iz_route[level.iz_route.size] = (-2858, 9620, 3823);
	level.iz_route[level.iz_route.size] = (-3305, 9725, 3880);
	level.iz_route[level.iz_route.size] = (-3800, 9635, 3836);
	level.iz_route[level.iz_route.size] = (-4179, 9381, 3707);
	level.iz_route[level.iz_route.size] = (-4405, 9071, 3542);
	level.iz_route[level.iz_route.size] = (-4558, 8718, 3350);
	level.iz_route[level.iz_route.size] = (-4614, 8427, 3190);
	level.iz_route[level.iz_route.size] = (-4654, 8000, 2964);
	level.iz_route[level.iz_route.size] = (-4659, 7346, 2634);
	level.iz_route[level.iz_route.size] = (-4670, 6888, 2430);
	level.iz_route[level.iz_route.size] = (-4659, 6201, 2302);
	level.iz_route[level.iz_route.size] = (-4609, 1641, 532);
	level.iz_route[level.iz_route.size] = (-4614, 1153, 532);
	level.iz_route[level.iz_route.size] = (-4594, 221, 532);
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
	points[0] = (-5547.9927, -15863.3857, 2657.4805);
	angles[0] = (0, -117.1490, 0);
	at[0] = 0;
	points[1] = (-5104.2915, -15864.9609, 2657.4805);
	angles[1] = (0, -96.4019, 0);
	at[1] = 0.5000;
	points[2] = (-4218.5039, -15874.4492, 2657.4805);
	angles[2] = (0, -90.8821, 0);
	at[2] = 1.5000;
	points[3] = (9068.0312, -16017.1650, 2657.4805);
	angles[3] = (0, -90.6154, 0);
	at[3] = 16.5000;
	points[4] = (9479.6846, -15856.4961, 2657.4805);
	angles[4] = (0, -72.9197, 0);
	at[4] = 17;
	points[5] = (9890.3936, -15690.6699, 2657.4805);
	angles[5] = (0, -69.0659, 0);
	at[5] = 17.5000;
	points[6] = (12765.2363, -14529.8428, 2657.4805);
	angles[6] = (0, -68.0119, 0);
	at[6] = 21;
	points[7] = (13094.0947, -14250.5127, 2657.4805);
	angles[7] = (0, -50.4397, 0);
	at[7] = 21.5000;
	points[8] = (13380.9854, -13913.1104, 2657.4805);
	angles[8] = (0, -42.5399, 0);
	at[8] = 22;
	points[9] = (13667.9141, -13575.6689, 2657.4805);
	angles[9] = (0, -40.8396, 0);
	at[9] = 22.5000;
	points[10] = (15389.3711, -11551.1416, 2657.4805);
	angles[10] = (0, -40.3748, 0);
	at[10] = 25.5000;
	points[11] = (15637.5195, -11195.9453, 2657.4805);
	angles[11] = (0, -32.2924, 0);
	at[11] = 26;
	points[12] = (15706.2598, -10758.3857, 2657.4805);
	angles[12] = (0, -14.0047, 0);
	at[12] = 26.5000;
	points[13] = (15775, -10320.8662, 2657.4805);
	angles[13] = (0, -10.0179, 0);
	at[13] = 27;
	points[14] = (16462.3242, -5945.3936, 2657.4805);
	angles[14] = (0, -8.9276, 0);
	at[14] = 32;
	points[15] = (16488.8203, -5504.3306, 2657.4805);
	angles[15] = (0, -3.5700, 0);
	at[15] = 32.5000;
	points[16] = (16502.0469, -4175.6694, 2657.4805);
	angles[16] = (0, -0.5992, 0);
	at[16] = 34;
	points[17] = (16642.9141, 9996.7324, 2657.4805);
	angles[17] = (0, -0.5695, 0);
	at[17] = 50;
	points[18] = (16486.9688, 10409.2520, 2657.4805);
	angles[18] = (0, 16.8568, 0);
	at[18] = 50.5000;
	points[19] = (16320.9053, 10819.8428, 2657.4805);
	angles[19] = (0, 20.9104, 0);
	at[19] = 51;
	points[20] = (15324.5664, 13283.5039, 2657.4805);
	angles[20] = (0, 22.0190, 0);
	at[20] = 54;
	points[21] = (15112.7568, 13661.6543, 2657.4805);
	angles[21] = (0, 31.7066, 0);
	at[21] = 54.5000;
	points[22] = (14780.1182, 13954.0947, 2657.4805);
	angles[22] = (0, 45.0132, 0);
	at[22] = 55;
	points[23] = (14447.4805, 14246.5352, 2657.4805);
	angles[23] = (0, 47.8927, 0);
	at[23] = 55.5000;
	points[24] = (12451.6143, 16001.1807, 2657.4805);
	angles[24] = (0, 48.6799, 0);
	at[24] = 58.5000;
	points[25] = (12101.0234, 16266.1025, 2657.4805);
	angles[25] = (0, 54.1526, 0);
	at[25] = 59;
	points[26] = (11699.4102, 16452.9141, 2657.4805);
	angles[26] = (0, 62.7075, 0);
	at[26] = 59.5000;
	points[27] = (11297.8350, 16639.7246, 2657.4805);
	angles[27] = (0, 64.5498, 0);
	at[27] = 60;
	points[28] = (9691.4570, 17386.9688, 2657.4805);
	angles[28] = (0, 65.0522, 0);
	at[28] = 62;
	points[29] = (9283.3857, 17551.6543, 2657.4805);
	angles[29] = (0, 69.5572, 0);
	at[29] = 62.5000;
	points[30] = (8844.5664, 17611.6934, 2657.4805);
	angles[30] = (0, 79.4823, 0);
	at[30] = 63;
	points[31] = (8405.7480, 17671.7715, 2657.4805);
	angles[31] = (0, 81.6222, 0);
	at[31] = 63.5000;
	points[32] = (3139.8464, 18392.4414, 2657.4805);
	angles[32] = (0, 82.2071, 0);
	at[32] = 69.5000;
	points[33] = (2700.6377, 18446.2207, 2657.4805);
	angles[33] = (0, 83.4357, 0);
	at[33] = 70;
	points[34] = (2257.7717, 18439.6855, 2657.4805);
	angles[34] = (0, 89.2528, 0);
	at[34] = 70.5000;
	points[35] = (1814.9095, 18433.1504, 2657.4805);
	angles[35] = (0, 90.5034, 0);
	at[35] = 71;
	points[36] = (-5270.9453, 18328.6230, 2657.4805);
	angles[36] = (0, 90.8452, 0);
	at[36] = 79;
	points[37] = (-5708.3857, 18290.9453, 2657.4805);
	angles[37] = (0, 96.2605, 0);
	at[37] = 79.5000;
	points[38] = (-6127.2832, 18147.0078, 2657.4805);
	angles[38] = (0, 106.2266, 0);
	at[38] = 80;
	points[39] = (-6546.1421, 18003.1094, 2657.4805);
	angles[39] = (0, 108.3755, 0);
	at[39] = 80.5000;
	points[40] = (-9897.1260, 16851.6934, 2657.4805);
	angles[40] = (0, 108.9628, 0);
	at[40] = 84.5000;
	points[41] = (-10222.2051, 16575.2754, 2657.4805);
	angles[41] = (0, 129.6711, 0);
	at[41] = 85;
	points[42] = (-10496.9678, 16227.9131, 2657.4805);
	angles[42] = (0, 139.0724, 0);
	at[42] = 85.5000;
	points[43] = (-10771.7715, 15880.5508, 2657.4805);
	angles[43] = (0, 141.0985, 0);
	at[43] = 86;
	points[44] = (-12420.5508, 13796.3789, 2657.4805);
	angles[44] = (0, 141.6524, 0);
	at[44] = 89;
	points[45] = (-12554.7256, 13380.2764, 2657.4805);
	angles[45] = (0, 159.3348, 0);
	at[45] = 89.5000;
	points[46] = (-12660, 12950.0791, 2657.4805);
	angles[46] = (0, 164.7627, 0);
	at[46] = 90;
	points[47] = (-12765.2764, 12519.8428, 2657.4805);
	angles[47] = (0, 165.9293, 0);
	at[47] = 90.5000;
	points[48] = (-13397.0078, 9938.5430, 2657.4805);
	angles[48] = (0, 166.2481, 0);
	at[48] = 93.5000;
	points[49] = (-13408.6230, 9497.1260, 2657.4805);
	angles[49] = (0, 176.6326, 0);
	at[49] = 94;
	points[50] = (-13405.8271, 8168.3862, 2657.4805);
	angles[50] = (0, 180.0856, 0);
	at[50] = 95.5000;
	points[51] = (-13377.9922, -5119.0942, 2657.4805);
	angles[51] = (0, 180.1201, 0);
	at[51] = 110.5000;
	points[52] = (-13355.3154, -5559.6064, 2657.4805);
	angles[52] = (0, 183.8123, 0);
	at[52] = 111;
	points[53] = (-13260.1182, -5992.1655, 2657.4805);
	angles[53] = (0, 190.5624, 0);
	at[53] = 111.5000;
	points[54] = (-13164.9219, -6424.7637, 2657.4805);
	angles[54] = (0, 192.0143, 0);
	at[54] = 112;
	points[55] = (-12403.3857, -9885.2363, 2657.4805);
	angles[55] = (0, 193.4979, 0);
	at[55] = 116;
	points[56] = (-12148.2686, -10248.2285, 2657.4805);
	angles[56] = (0, 210.0403, 0);
	at[56] = 116.5000;
	points[57] = (-11896.6533, -10612.7158, 2657.4805);
	angles[57] = (0, 213.6364, 0);
	at[57] = 117;
	points[58] = (-10135.2363, -13164.1338, 2657.4805);
	angles[58] = (0, 214.6197, 0);
	at[58] = 120.5000;
	points[59] = (-9872.1660, -13515.9053, 2657.4805);
	angles[59] = (0, 218.3506, 0);
	at[59] = 121;
	points[60] = (-9482.9131, -13727.2441, 2657.4805);
	angles[60] = (0, 236.4738, 0);
	at[60] = 121.5000;
	points[61] = (-9093.6621, -13938.5439, 2657.4805);
	angles[61] = (0, 240.4236, 0);
	at[61] = 122;
	points[62] = (-5590.3940, -15840.3545, 2657.4805);
	angles[62] = (0, 241.5037, 0);
	at[62] = 126.5000;
	points[63] = (-5547.9927, -15863.3857, 2657.4805);
	angles[63] = (0, 242.8510, 0);
	at[63] = 126.5500;
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
