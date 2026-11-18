main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_bowsercastle_3", 0);

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
	ambientPlay("iz_0_trbc3", 2);
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
	level.iz_route[level.iz_route.size] = (-14316, -8000, 3401);
	level.iz_route[level.iz_route.size] = (-14296, -9233, 3401);
	level.iz_route[level.iz_route.size] = (-14209, -10799, 3401);
	level.iz_route[level.iz_route.size] = (-14116, -10959, 3401);
	level.iz_route[level.iz_route.size] = (-13914, -11079, 3401);
	level.iz_route[level.iz_route.size] = (-13525, -11171, 3401);
	level.iz_route[level.iz_route.size] = (-12537, -11217, 3401);
	level.iz_route[level.iz_route.size] = (-10820, -11235, 3401);
	level.iz_route[level.iz_route.size] = (-8920, -11239, 3307);
	level.iz_route[level.iz_route.size] = (-7799, -11237, 3333);
	level.iz_route[level.iz_route.size] = (-6860, -11192, 3355);
	level.iz_route[level.iz_route.size] = (-5199, -11254, 3331);
	level.iz_route[level.iz_route.size] = (-3356, -11220, 3331);
	level.iz_route[level.iz_route.size] = (-2920, -11127, 3331);
	level.iz_route[level.iz_route.size] = (-2719, -10825, 3331);
	level.iz_route[level.iz_route.size] = (-2593, -10357, 3356);
	level.iz_route[level.iz_route.size] = (-2584, -9699, 3413);
	level.iz_route[level.iz_route.size] = (-2731, -8753, 3513);
	level.iz_route[level.iz_route.size] = (-2567, -8201, 3588);
	level.iz_route[level.iz_route.size] = (-2455, -7833, 3638);
	level.iz_route[level.iz_route.size] = (-2434, -6798, 3800);
	level.iz_route[level.iz_route.size] = (-2466, -6087, 4013);
	level.iz_route[level.iz_route.size] = (-2382, -5058, 4153);
	level.iz_route[level.iz_route.size] = (-2390, -4751, 4293);
	level.iz_route[level.iz_route.size] = (-2376, -4240, 4526);
	level.iz_route[level.iz_route.size] = (-2450, -3284, 4832);
	level.iz_route[level.iz_route.size] = (-2533, -3041, 4928);
	level.iz_route[level.iz_route.size] = (-2652, -2795, 5025);
	level.iz_route[level.iz_route.size] = (-2346, -2498, 5142);
	level.iz_route[level.iz_route.size] = (-2254, -2253, 5238);
	level.iz_route[level.iz_route.size] = (-2243, -2027, 5334);
	level.iz_route[level.iz_route.size] = (-2255, -1640, 5496);
	level.iz_route[level.iz_route.size] = (-2265, -1160, 5669);
	level.iz_route[level.iz_route.size] = (-2268, -786, 5831);
	level.iz_route[level.iz_route.size] = (-2264, 4, 6243);
	level.iz_route[level.iz_route.size] = (-2240, 866, 6693);
	level.iz_route[level.iz_route.size] = (-2255, 1125, 6856);
	level.iz_route[level.iz_route.size] = (-2412, 1346, 7011);
	level.iz_route[level.iz_route.size] = (-2852, 1493, 7113);
	level.iz_route[level.iz_route.size] = (-3422, 1529, 7139);
	level.iz_route[level.iz_route.size] = (-4860, 1549, 7153);
	level.iz_route[level.iz_route.size] = (-6209, 1675, 7240);
	level.iz_route[level.iz_route.size] = (-6816, 1526, 7136);
	level.iz_route[level.iz_route.size] = (-7212, 1213, 6918);
	level.iz_route[level.iz_route.size] = (-7250, 758, 6631);
	level.iz_route[level.iz_route.size] = (-7272, -680, 6332);
	level.iz_route[level.iz_route.size] = (-7288, -2580, 6376);
	level.iz_route[level.iz_route.size] = (-7291, -2881, 6380);
	level.iz_route[level.iz_route.size] = (-7169, -3217, 6380);
	level.iz_route[level.iz_route.size] = (-6739, -3428, 6380);
	level.iz_route[level.iz_route.size] = (-6269, -3716, 6380);
	level.iz_route[level.iz_route.size] = (-6055, -4252, 6380);
	level.iz_route[level.iz_route.size] = (-6034, -5047, 6380);
	level.iz_route[level.iz_route.size] = (-6058, -6976, 6380);
	level.iz_route[level.iz_route.size] = (-6094, -8207, 6495);
	level.iz_route[level.iz_route.size] = (-6276, -8645, 6571);
	level.iz_route[level.iz_route.size] = (-6751, -8848, 6606);
	level.iz_route[level.iz_route.size] = (-7437, -8969, 6628);
	level.iz_route[level.iz_route.size] = (-8348, -9003, 6636);
	level.iz_route[level.iz_route.size] = (-9025, -8892, 6617);
	level.iz_route[level.iz_route.size] = (-9374, -8540, 6557);
	level.iz_route[level.iz_route.size] = (-9524, -7909, 6448);
	level.iz_route[level.iz_route.size] = (-9513, -6876, 6275);
	level.iz_route[level.iz_route.size] = (-9573, -5400, 6029);
	level.iz_route[level.iz_route.size] = (-9568, -3903, 5975);
	level.iz_route[level.iz_route.size] = (-9552, -2046, 5684);
	level.iz_route[level.iz_route.size] = (-9565, -441, 5490);
	level.iz_route[level.iz_route.size] = (-9584, 867, 5344);
	level.iz_route[level.iz_route.size] = (-9594, 2301, 5236);
	level.iz_route[level.iz_route.size] = (-9648, 2739, 5210);
	level.iz_route[level.iz_route.size] = (-9984, 3094, 5122);
	level.iz_route[level.iz_route.size] = (-10627, 3393, 4956);
	level.iz_route[level.iz_route.size] = (-11486, 3510, 4745);
	level.iz_route[level.iz_route.size] = (-12284, 3405, 4559);
	level.iz_route[level.iz_route.size] = (-12731, 2996, 4431);
	level.iz_route[level.iz_route.size] = (-13023, 2388, 4348);
	level.iz_route[level.iz_route.size] = (-13020, 1551, 4316);
	level.iz_route[level.iz_route.size] = (-12972, -465, 4173);
	level.iz_route[level.iz_route.size] = (-13092, -1635, 4084);
	level.iz_route[level.iz_route.size] = (-13439, -1970, 4048);
	level.iz_route[level.iz_route.size] = (-13767, -2166, 4027);
	level.iz_route[level.iz_route.size] = (-14245, -2653, 3975);
	level.iz_route[level.iz_route.size] = (-14315, -3407, 3894);
	level.iz_route[level.iz_route.size] = (-14296, -4398, 3786);
	level.iz_route[level.iz_route.size] = (-14270, -5553, 3401);
	level.iz_route[level.iz_route.size] = (-14309, -6978, 3401);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-12050.8672, -7241.6538, 2625.5000);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-12050.8672, -7241.6538, 2625.5000);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (-12050.8672, -7241.6538, 2666);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (-12050.8672, -7241.6538, 2719.3860);
	angles[3] = (0, 0, 0);
	at[3] = 3.4500;
	points[4] = (-12050.8672, -7241.6538, 2817.6536);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (-12050.8672, -7241.6538, 2904.5825);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (-12050.8672, -7241.6538, 2943.7954);
	angles[6] = (0, 0, 0);
	at[6] = 3.7000;
	points[7] = (-12050.8672, -7241.6538, 3013.7166);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (-12050.8672, -7241.6538, 3072.2993);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (-12050.8672, -7241.6538, 3119.5432);
	angles[9] = (0, 0, 0);
	at[9] = 4;
	points[10] = (-12050.8672, -7241.6538, 3138.9136);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (-12050.8672, -7241.6538, 3169.1497);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (-12050.8672, -7241.6538, 3188.0474);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (-12050.8672, -7241.6538, 3198.8345);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (-12050.8672, -7241.6538, 3206.7363);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (-12050.8672, -7241.6538, 3210.4490);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (-12050.8672, -7241.6538, 3208.5513);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (-12050.8672, -7241.6538, 3184.7952);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (-12050.8672, -7241.6538, 3181.0828);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (-12050.8672, -7241.6538, 3182.9805);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (-12050.8672, -7241.6538, 3206.7363);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (-12050.8672, -7241.6538, 3210.4490);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (-12050.8672, -7241.6538, 3208.5513);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (-12050.8672, -7241.6538, 3184.7952);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (-12050.8672, -7241.6538, 3181.0828);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (-12050.8672, -7241.6538, 3182.9805);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (-12050.8672, -7241.6538, 3206.7363);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (-12050.8672, -7241.6538, 3210.4490);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (-12050.8672, -7241.6538, 3208.5513);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (-12050.8672, -7241.6538, 3184.7952);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (-12050.8672, -7241.6538, 3181.0828);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (-12050.8672, -7241.6538, 3182.9805);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (-12050.8672, -7241.6538, 3206.7363);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (-12050.8672, -7241.6538, 3210.4490);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (-12050.8672, -7241.6538, 3208.5513);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (-12050.8672, -7241.6538, 3184.7952);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (-12050.8672, -7241.6538, 3179.8308);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (-12050.8672, -7241.6538, 2631.7993);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (-12050.8672, -7241.6538, 2625.5000);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (-12050.8672, -7241.6538, 2625.5000);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-17150.3535, -5109.6460, 2634.1458);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-17150.3535, -5109.6460, 2634.1458);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (-17150.3535, -5109.6460, 2674.6494);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (-17150.3535, -5109.6460, 2778.5825);
	angles[3] = (0, 0, 0);
	at[3] = 3;
	points[4] = (-17150.3535, -5109.6460, 2826.2993);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (-17150.3535, -5109.6460, 2913.2285);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (-17150.3535, -5109.6460, 2988.8228);
	angles[6] = (0, 0, 0);
	at[6] = 3.2500;
	points[7] = (-17150.3535, -5109.6460, 3053.0708);
	angles[7] = (0, 0, 0);
	at[7] = 3.3500;
	points[8] = (-17150.3535, -5109.6460, 3080.9490);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (-17150.3535, -5109.6460, 3105.9880);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (-17150.3535, -5109.6460, 3147.5630);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-17150.3535, -5109.6460, 3177.7954);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (-17150.3535, -5109.6460, 3196.6929);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (-17150.3535, -5109.6460, 3207.4805);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (-17150.3535, -5109.6460, 3215.3818);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (-17150.3535, -5109.6460, 3219.0945);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (-17150.3535, -5109.6460, 3217.1968);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (-17150.3535, -5109.6460, 3193.4412);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-17150.3535, -5109.6460, 3189.7283);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (-17150.3535, -5109.6460, 3191.6260);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-17150.3535, -5109.6460, 3215.3818);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-17150.3535, -5109.6460, 3219.0945);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-17150.3535, -5109.6460, 3217.1968);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (-17150.3535, -5109.6460, 3193.4412);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-17150.3535, -5109.6460, 3189.7283);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (-17150.3535, -5109.6460, 3191.6260);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (-17150.3535, -5109.6460, 3215.3818);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-17150.3535, -5109.6460, 3219.0945);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-17150.3535, -5109.6460, 3217.1968);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (-17150.3535, -5109.6460, 3193.4412);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-17150.3535, -5109.6460, 3189.7283);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (-17150.3535, -5109.6460, 3191.6260);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (-17150.3535, -5109.6460, 3215.3818);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-17150.3535, -5109.6460, 3219.0945);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (-17150.3535, -5109.6460, 3217.1968);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (-17150.3535, -5109.6460, 3193.4412);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (-17150.3535, -5109.6460, 3188.4763);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (-17150.3535, -5109.6460, 2640.4448);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (-17150.3535, -5109.6460, 2634.1458);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (-17150.3535, -5109.6460, 2634.1458);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-16339.2129, -11301.4971, 2606.4136);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-16339.2129, -11301.4971, 2606.4136);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (-16339.2129, -11301.4971, 2646.9172);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (-16339.2129, -11301.4971, 2700.3032);
	angles[3] = (0, 0, 0);
	at[3] = 3.4500;
	points[4] = (-16339.2129, -11301.4971, 2798.5671);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (-16339.2129, -11301.4971, 2885.4963);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (-16339.2129, -11301.4971, 2961.0906);
	angles[6] = (0, 0, 0);
	at[6] = 3.7500;
	points[7] = (-16339.2129, -11301.4971, 2994.6338);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (-16339.2129, -11301.4971, 3053.2166);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (-16339.2129, -11301.4971, 3078.2559);
	angles[9] = (0, 0, 0);
	at[9] = 3.9500;
	points[10] = (-16339.2129, -11301.4971, 3119.8306);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (-16339.2129, -11301.4971, 3150.0630);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (-16339.2129, -11301.4971, 3168.9607);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (-16339.2129, -11301.4971, 3179.7480);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (-16339.2129, -11301.4971, 3187.6497);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (-16339.2129, -11301.4971, 3191.3623);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (-16339.2129, -11301.4971, 3189.4646);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (-16339.2129, -11301.4971, 3165.7085);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (-16339.2129, -11301.4971, 3161.9961);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (-16339.2129, -11301.4971, 3163.8938);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (-16339.2129, -11301.4971, 3187.6497);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (-16339.2129, -11301.4971, 3191.3623);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (-16339.2129, -11301.4971, 3189.4646);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (-16339.2129, -11301.4971, 3165.7085);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (-16339.2129, -11301.4971, 3161.9961);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (-16339.2129, -11301.4971, 3163.8938);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (-16339.2129, -11301.4971, 3187.6497);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (-16339.2129, -11301.4971, 3191.3623);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (-16339.2129, -11301.4971, 3189.4646);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (-16339.2129, -11301.4971, 3165.7085);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (-16339.2129, -11301.4971, 3161.9961);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (-16339.2129, -11301.4971, 3163.8938);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (-16339.2129, -11301.4971, 3187.6497);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (-16339.2129, -11301.4971, 3191.3623);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (-16339.2129, -11301.4971, 3189.4646);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (-16339.2129, -11301.4971, 3165.7085);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (-16339.2129, -11301.4971, 3160.7441);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (-16339.2129, -11301.4971, 2612.7126);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (-16339.2129, -11301.4971, 2606.4136);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (-16339.2129, -11301.4971, 2606.4136);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-3354.0120, -14073.1504, 2595.9331);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3354.0120, -14073.1504, 2595.9331);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (-3354.0120, -14073.1504, 2636.4331);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (-3354.0120, -14073.1504, 2689.8230);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (-3354.0120, -14073.1504, 2788.0906);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (-3354.0120, -14073.1504, 2875.0156);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (-3354.0120, -14073.1504, 2950.6062);
	angles[6] = (0, 0, 0);
	at[6] = 3.2500;
	points[7] = (-3354.0120, -14073.1504, 2984.1536);
	angles[7] = (0, 0, 0);
	at[7] = 3.3000;
	points[8] = (-3354.0120, -14073.1504, 3042.7324);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (-3354.0120, -14073.1504, 3067.7756);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (-3354.0120, -14073.1504, 3109.3506);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-3354.0120, -14073.1504, 3139.5828);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (-3354.0120, -14073.1504, 3158.4805);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (-3354.0120, -14073.1504, 3169.2676);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (-3354.0120, -14073.1504, 3177.1694);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (-3354.0120, -14073.1504, 3180.8821);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (-3354.0120, -14073.1504, 3178.9844);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (-3354.0120, -14073.1504, 3155.2283);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-3354.0120, -14073.1504, 3151.5159);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (-3354.0120, -14073.1504, 3153.4136);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-3354.0120, -14073.1504, 3177.1694);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-3354.0120, -14073.1504, 3180.8821);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-3354.0120, -14073.1504, 3178.9844);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (-3354.0120, -14073.1504, 3155.2283);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-3354.0120, -14073.1504, 3151.5159);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (-3354.0120, -14073.1504, 3153.4136);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (-3354.0120, -14073.1504, 3177.1694);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-3354.0120, -14073.1504, 3180.8821);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-3354.0120, -14073.1504, 3178.9844);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (-3354.0120, -14073.1504, 3155.2283);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-3354.0120, -14073.1504, 3151.5159);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (-3354.0120, -14073.1504, 3153.4136);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (-3354.0120, -14073.1504, 3177.1694);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-3354.0120, -14073.1504, 3180.8821);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (-3354.0120, -14073.1504, 3178.9844);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (-3354.0120, -14073.1504, 3155.2283);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (-3354.0120, -14073.1504, 3150.2639);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (-3354.0120, -14073.1504, 2602.2324);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (-3354.0120, -14073.1504, 2595.9331);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (-3354.0120, -14073.1504, 2595.9331);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (395.1024, -11594.4883, 2607.7676);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (395.1024, -11594.4883, 2607.7676);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (395.1024, -11594.4883, 2648.2678);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (395.1024, -11594.4883, 2701.6536);
	angles[3] = (0, 0, 0);
	at[3] = 3.4500;
	points[4] = (395.1024, -11594.4883, 2799.9211);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (395.1024, -11594.4883, 2886.8503);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (395.1024, -11594.4883, 2926.0630);
	angles[6] = (0, 0, 0);
	at[6] = 3.7000;
	points[7] = (395.1024, -11594.4883, 2995.9844);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (395.1024, -11594.4883, 3054.5669);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (395.1024, -11594.4883, 3101.8113);
	angles[9] = (0, 0, 0);
	at[9] = 4;
	points[10] = (395.1024, -11594.4883, 3121.1812);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (395.1024, -11594.4883, 3151.4172);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (395.1024, -11594.4883, 3170.3149);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (395.1024, -11594.4883, 3181.1025);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (395.1024, -11594.4883, 3189.0042);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (395.1024, -11594.4883, 3192.7166);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (395.1024, -11594.4883, 3190.8188);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (395.1024, -11594.4883, 3167.0591);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (395.1024, -11594.4883, 3163.3503);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (395.1024, -11594.4883, 3165.2480);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (395.1024, -11594.4883, 3189.0042);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (395.1024, -11594.4883, 3192.7166);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (395.1024, -11594.4883, 3190.8188);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (395.1024, -11594.4883, 3167.0591);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (395.1024, -11594.4883, 3163.3503);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (395.1024, -11594.4883, 3165.2480);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (395.1024, -11594.4883, 3189.0042);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (395.1024, -11594.4883, 3192.7166);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (395.1024, -11594.4883, 3190.8188);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (395.1024, -11594.4883, 3167.0591);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (395.1024, -11594.4883, 3163.3503);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (395.1024, -11594.4883, 3165.2480);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (395.1024, -11594.4883, 3189.0042);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (395.1024, -11594.4883, 3192.7166);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (395.1024, -11594.4883, 3190.8188);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (395.1024, -11594.4883, 3167.0591);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (395.1024, -11594.4883, 3162.0984);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (395.1024, -11594.4883, 2614.0669);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (395.1024, -11594.4883, 2607.7676);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (395.1024, -11594.4883, 2607.7676);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (1872.2245, -6991.1416, 2628.8662);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1872.2245, -6991.1416, 2628.8662);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (1872.2245, -6991.1416, 2669.3662);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (1872.2245, -6991.1416, 2722.7520);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (1872.2245, -6991.1416, 2821.0198);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (1872.2245, -6991.1416, 2907.9490);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (1872.2245, -6991.1416, 2983.5393);
	angles[6] = (0, 0, 0);
	at[6] = 3.2500;
	points[7] = (1872.2245, -6991.1416, 3017.0828);
	angles[7] = (0, 0, 0);
	at[7] = 3.3000;
	points[8] = (1872.2245, -6991.1416, 3075.6655);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (1872.2245, -6991.1416, 3100.7046);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (1872.2245, -6991.1416, 3142.2798);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (1872.2245, -6991.1416, 3172.5159);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (1872.2245, -6991.1416, 3191.4133);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (1872.2245, -6991.1416, 3202.2007);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (1872.2245, -6991.1416, 3210.1023);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (1872.2245, -6991.1416, 3213.8149);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (1872.2245, -6991.1416, 3211.9175);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (1872.2245, -6991.1416, 3188.1577);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (1872.2245, -6991.1416, 3184.4490);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (1872.2245, -6991.1416, 3186.3464);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (1872.2245, -6991.1416, 3210.1023);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (1872.2245, -6991.1416, 3213.8149);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (1872.2245, -6991.1416, 3211.9175);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (1872.2245, -6991.1416, 3188.1577);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (1872.2245, -6991.1416, 3184.4490);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (1872.2245, -6991.1416, 3186.3464);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (1872.2245, -6991.1416, 3210.1023);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (1872.2245, -6991.1416, 3213.8149);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (1872.2245, -6991.1416, 3211.9175);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (1872.2245, -6991.1416, 3188.1577);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (1872.2245, -6991.1416, 3184.4490);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (1872.2245, -6991.1416, 3186.3464);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (1872.2245, -6991.1416, 3210.1023);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (1872.2245, -6991.1416, 3213.8149);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (1872.2245, -6991.1416, 3211.9175);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (1872.2245, -6991.1416, 3188.1577);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (1872.2245, -6991.1416, 3183.1970);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (1872.2245, -6991.1416, 2635.1653);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (1872.2245, -6991.1416, 2628.8662);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (1872.2245, -6991.1416, 2628.8662);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-4712.8740, -10151.5752, 2613.4883);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4712.8740, -10151.5752, 2613.4883);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (-4712.8740, -10151.5752, 2653.9883);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (-4712.8740, -10151.5752, 2707.3743);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (-4712.8740, -10151.5752, 2805.6416);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (-4712.8740, -10151.5752, 2892.5708);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (-4712.8740, -10151.5752, 2968.1614);
	angles[6] = (0, 0, 0);
	at[6] = 3.2500;
	points[7] = (-4712.8740, -10151.5752, 3001.7048);
	angles[7] = (0, 0, 0);
	at[7] = 3.3000;
	points[8] = (-4712.8740, -10151.5752, 3060.2874);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (-4712.8740, -10151.5752, 3085.3269);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (-4712.8740, -10151.5752, 3126.9016);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-4712.8740, -10151.5752, 3157.1377);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (-4712.8740, -10151.5752, 3176.0356);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (-4712.8740, -10151.5752, 3186.8228);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (-4712.8740, -10151.5752, 3194.7246);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (-4712.8740, -10151.5752, 3198.4373);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (-4712.8740, -10151.5752, 3196.5396);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (-4712.8740, -10151.5752, 3172.7795);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-4712.8740, -10151.5752, 3169.0708);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (-4712.8740, -10151.5752, 3170.9688);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-4712.8740, -10151.5752, 3194.7246);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-4712.8740, -10151.5752, 3198.4373);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-4712.8740, -10151.5752, 3196.5396);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (-4712.8740, -10151.5752, 3172.7795);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-4712.8740, -10151.5752, 3169.0708);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (-4712.8740, -10151.5752, 3170.9688);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (-4712.8740, -10151.5752, 3194.7246);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-4712.8740, -10151.5752, 3198.4373);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-4712.8740, -10151.5752, 3196.5396);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (-4712.8740, -10151.5752, 3172.7795);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-4712.8740, -10151.5752, 3169.0708);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (-4712.8740, -10151.5752, 3170.9688);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (-4712.8740, -10151.5752, 3194.7246);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-4712.8740, -10151.5752, 3198.4373);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (-4712.8740, -10151.5752, 3196.5396);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (-4712.8740, -10151.5752, 3172.7795);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (-4712.8740, -10151.5752, 3167.8188);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (-4712.8740, -10151.5752, 2619.7876);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (-4712.8740, -10151.5752, 2613.4883);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (-4712.8740, -10151.5752, 2613.4883);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-12890.9844, -4521.8901, 2637.6890);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-12890.9844, -4521.8901, 2637.6890);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (-12890.9844, -4521.8901, 2678.1929);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (-12890.9844, -4521.8901, 2731.5789);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (-12890.9844, -4521.8901, 2829.8464);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (-12890.9844, -4521.8901, 2916.7756);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (-12890.9844, -4521.8901, 2955.9883);
	angles[6] = (0, 0, 0);
	at[6] = 3.2000;
	points[7] = (-12890.9844, -4521.8901, 3025.9094);
	angles[7] = (0, 0, 0);
	at[7] = 3.3000;
	points[8] = (-12890.9844, -4521.8901, 3084.4922);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (-12890.9844, -4521.8901, 3109.5315);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (-12890.9844, -4521.8901, 3151.1064);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-12890.9844, -4521.8901, 3181.3425);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (-12890.9844, -4521.8901, 3200.2402);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (-12890.9844, -4521.8901, 3211.0276);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (-12890.9844, -4521.8901, 3218.9292);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (-12890.9844, -4521.8901, 3222.6379);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (-12890.9844, -4521.8901, 3220.7402);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (-12890.9844, -4521.8901, 3196.9844);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-12890.9844, -4521.8901, 3193.2717);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (-12890.9844, -4521.8901, 3195.1694);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-12890.9844, -4521.8901, 3218.9292);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-12890.9844, -4521.8901, 3222.6379);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-12890.9844, -4521.8901, 3220.7402);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (-12890.9844, -4521.8901, 3196.9844);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-12890.9844, -4521.8901, 3193.2717);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (-12890.9844, -4521.8901, 3195.1694);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (-12890.9844, -4521.8901, 3218.9292);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-12890.9844, -4521.8901, 3222.6379);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-12890.9844, -4521.8901, 3220.7402);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (-12890.9844, -4521.8901, 3196.9844);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-12890.9844, -4521.8901, 3193.2717);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (-12890.9844, -4521.8901, 3195.1694);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (-12890.9844, -4521.8901, 3218.9292);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-12890.9844, -4521.8901, 3222.6379);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (-12890.9844, -4521.8901, 3220.7402);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (-12890.9844, -4521.8901, 3196.9844);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (-12890.9844, -4521.8901, 3192.0198);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (-12890.9844, -4521.8901, 2643.9883);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (-12890.9844, -4521.8901, 2637.6890);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (-12890.9844, -4521.8901, 2637.6890);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-11077.2041, -4303.1499, 2638.9724);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-11077.2041, -4303.1499, 2638.9724);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (-11077.2041, -4303.1499, 2679.4724);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (-11077.2041, -4303.1499, 2732.8582);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (-11077.2041, -4303.1499, 2831.1260);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (-11077.2041, -4303.1499, 2918.0552);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (-11077.2041, -4303.1499, 2993.6455);
	angles[6] = (0, 0, 0);
	at[6] = 3.2500;
	points[7] = (-11077.2041, -4303.1499, 3027.1892);
	angles[7] = (0, 0, 0);
	at[7] = 3.3000;
	points[8] = (-11077.2041, -4303.1499, 3085.7717);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (-11077.2041, -4303.1499, 3110.8113);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (-11077.2041, -4303.1499, 3152.3860);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-11077.2041, -4303.1499, 3182.6221);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (-11077.2041, -4303.1499, 3201.5198);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (-11077.2041, -4303.1499, 3212.3071);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (-11077.2041, -4303.1499, 3220.2085);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (-11077.2041, -4303.1499, 3223.9214);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (-11077.2041, -4303.1499, 3222.0237);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (-11077.2041, -4303.1499, 3198.2678);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-11077.2041, -4303.1499, 3194.5552);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (-11077.2041, -4303.1499, 3196.4529);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-11077.2041, -4303.1499, 3220.2085);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-11077.2041, -4303.1499, 3223.9214);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-11077.2041, -4303.1499, 3222.0237);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (-11077.2041, -4303.1499, 3198.2678);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-11077.2041, -4303.1499, 3194.5552);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (-11077.2041, -4303.1499, 3196.4529);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (-11077.2041, -4303.1499, 3220.2085);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-11077.2041, -4303.1499, 3223.9214);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-11077.2041, -4303.1499, 3222.0237);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (-11077.2041, -4303.1499, 3198.2678);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-11077.2041, -4303.1499, 3194.5552);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (-11077.2041, -4303.1499, 3196.4529);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (-11077.2041, -4303.1499, 3220.2085);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-11077.2041, -4303.1499, 3223.9214);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (-11077.2041, -4303.1499, 3222.0237);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (-11077.2041, -4303.1499, 3198.2678);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (-11077.2041, -4303.1499, 3193.3032);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (-11077.2041, -4303.1499, 2645.2717);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (-11077.2041, -4303.1499, 2638.9724);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (-11077.2041, -4303.1499, 2638.9724);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-13676.7725, -13715.5518, 2595.8977);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-13676.7725, -13715.5518, 2595.8977);
	angles[1] = (0, 0, 0);
	at[1] = 2.8500;
	points[2] = (-13676.7725, -13715.5518, 2636.4016);
	angles[2] = (0, 0, 0);
	at[2] = 2.9000;
	points[3] = (-13676.7725, -13715.5518, 2689.7876);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (-13676.7725, -13715.5518, 2788.0549);
	angles[4] = (0, 0, 0);
	at[4] = 3.0500;
	points[5] = (-13676.7725, -13715.5518, 2874.9841);
	angles[5] = (0, 0, 0);
	at[5] = 3.1500;
	points[6] = (-13676.7725, -13715.5518, 2914.1968);
	angles[6] = (0, 0, 0);
	at[6] = 3.2000;
	points[7] = (-13676.7725, -13715.5518, 2984.1182);
	angles[7] = (0, 0, 0);
	at[7] = 3.3000;
	points[8] = (-13676.7725, -13715.5518, 3042.7007);
	angles[8] = (0, 0, 0);
	at[8] = 3.4000;
	points[9] = (-13676.7725, -13715.5518, 3089.9448);
	angles[9] = (0, 0, 0);
	at[9] = 3.5000;
	points[10] = (-13676.7725, -13715.5518, 3109.3149);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-13676.7725, -13715.5518, 3139.5513);
	angles[11] = (0, 0, 0);
	at[11] = 3.6500;
	points[12] = (-13676.7725, -13715.5518, 3158.4490);
	angles[12] = (0, 0, 0);
	at[12] = 3.7500;
	points[13] = (-13676.7725, -13715.5518, 3169.2361);
	angles[13] = (0, 0, 0);
	at[13] = 3.9000;
	points[14] = (-13676.7725, -13715.5518, 3177.1379);
	angles[14] = (0, 0, 0);
	at[14] = 3.9500;
	points[15] = (-13676.7725, -13715.5518, 3180.8467);
	angles[15] = (0, 0, 0);
	at[15] = 4;
	points[16] = (-13676.7725, -13715.5518, 3178.9529);
	angles[16] = (0, 0, 0);
	at[16] = 4.0500;
	points[17] = (-13676.7725, -13715.5518, 3155.1929);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-13676.7725, -13715.5518, 3151.4841);
	angles[18] = (0, 0, 0);
	at[18] = 4.2500;
	points[19] = (-13676.7725, -13715.5518, 3153.3782);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-13676.7725, -13715.5518, 3177.1379);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-13676.7725, -13715.5518, 3180.8467);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-13676.7725, -13715.5518, 3178.9529);
	angles[22] = (0, 0, 0);
	at[22] = 4.5500;
	points[23] = (-13676.7725, -13715.5518, 3155.1929);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-13676.7725, -13715.5518, 3151.4841);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (-13676.7725, -13715.5518, 3153.3782);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (-13676.7725, -13715.5518, 3177.1379);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-13676.7725, -13715.5518, 3180.8467);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-13676.7725, -13715.5518, 3178.9529);
	angles[28] = (0, 0, 0);
	at[28] = 5.0500;
	points[29] = (-13676.7725, -13715.5518, 3155.1929);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-13676.7725, -13715.5518, 3151.4841);
	angles[30] = (0, 0, 0);
	at[30] = 5.2500;
	points[31] = (-13676.7725, -13715.5518, 3153.3782);
	angles[31] = (0, 0, 0);
	at[31] = 5.3000;
	points[32] = (-13676.7725, -13715.5518, 3177.1379);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-13676.7725, -13715.5518, 3180.8467);
	angles[33] = (0, 0, 0);
	at[33] = 5.5000;
	points[34] = (-13676.7725, -13715.5518, 3178.9529);
	angles[34] = (0, 0, 0);
	at[34] = 5.5500;
	points[35] = (-13676.7725, -13715.5518, 3155.1929);
	angles[35] = (0, 0, 0);
	at[35] = 5.7000;
	points[36] = (-13676.7725, -13715.5518, 3150.2285);
	angles[36] = (0, 0, 0);
	at[36] = 5.7500;
	points[37] = (-13676.7725, -13715.5518, 2602.1970);
	angles[37] = (0, 0, 0);
	at[37] = 8.6500;
	points[38] = (-13676.7725, -13715.5518, 2595.8977);
	angles[38] = (0, 0, 0);
	at[38] = 8.7000;
	points[39] = (-13676.7725, -13715.5518, 2595.8977);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-4670.7090, -11297.9141, 3604.4019);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-4670.7090, -11297.9141, 3601.1614);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (-4670.7090, -11297.9141, 3589.0591);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (-4670.7090, -11297.9141, 3592.3032);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (-4670.7090, -11297.9141, 3604.4019);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (-4670.7090, -11297.9141, 3601.1614);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (-4670.7090, -11297.9141, 3589.0591);
	angles[6] = (0, 90, 0);
	at[6] = 0.3000;
	points[7] = (-4670.7090, -11297.9141, 3592.3032);
	angles[7] = (0, 90, 0);
	at[7] = 0.3500;
	points[8] = (-4670.7090, -11297.9141, 3604.4019);
	angles[8] = (0, 90, 0);
	at[8] = 0.4000;
	points[9] = (-4670.7090, -11297.9141, 3601.1614);
	angles[9] = (0, 90, 0);
	at[9] = 0.4500;
	points[10] = (-4670.7090, -11297.9141, 3607.0669);
	angles[10] = (0, 90, 0);
	at[10] = 0.5000;
	points[11] = (-4670.7090, -11297.9141, 3739.9409);
	angles[11] = (0, 90, 0);
	at[11] = 0.6500;
	points[12] = (-4670.7090, -11297.9141, 3709.8228);
	angles[12] = (0, 90, 0);
	at[12] = 0.7000;
	points[13] = (-4670.7090, -11297.9141, 3634.5276);
	angles[13] = (0, 90, 0);
	at[13] = 0.7500;
	points[14] = (-4670.7090, -11297.9141, 3514.0554);
	angles[14] = (0, 90, 0);
	at[14] = 0.8000;
	points[15] = (-4670.7090, -11297.9141, 3348.4055);
	angles[15] = (0, 90, 0);
	at[15] = 0.8500;
	points[16] = (-4670.7090, -11297.9141, 3330.9844);
	angles[16] = (0, 90, 0);
	at[16] = 0.9000;
	points[17] = (-4670.7090, -11297.9141, 3330.9844);
	angles[17] = (0, 90, 0);
	at[17] = 1.8500;
	points[18] = (-4670.7090, -11297.9141, 3336.8899);
	angles[18] = (0, 90, 0);
	at[18] = 1.9000;
	points[19] = (-4670.7090, -11297.9141, 3593.7795);
	angles[19] = (0, 90, 0);
	at[19] = 3.3500;
	points[20] = (-4670.7090, -11297.9141, 3596.7324);
	angles[20] = (0, 90, 0);
	at[20] = 3.4000;
	points[21] = (-4670.7090, -11297.9141, 3596.7324);
	angles[21] = (0, 90, 0);
	at[21] = 4.3500;
	points[22] = (-4670.7090, -11297.9141, 3604.4019);
	angles[22] = (0, 90, 0);
	at[22] = 4.3833;
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
	points[0] = (-3594.2402, -2695.0356, 3935.2874);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3594.2402, -2695.0356, 3935.2874);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (-3594.2402, -2695.0356, 3975.7874);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (-3594.2402, -2695.0356, 4029.1733);
	angles[3] = (0, 0, 0);
	at[3] = 3.4500;
	points[4] = (-3594.2402, -2695.0356, 4127.4409);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (-3594.2402, -2695.0356, 4214.3701);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (-3594.2402, -2695.0356, 4289.9604);
	angles[6] = (0, 0, 0);
	at[6] = 3.7500;
	points[7] = (-3594.2402, -2695.0356, 4323.5039);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (-3594.2402, -2695.0356, 4382.0869);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (-3594.2402, -2695.0356, 4407.1260);
	angles[9] = (0, 0, 0);
	at[9] = 3.9500;
	points[10] = (-3594.2402, -2695.0356, 4448.7007);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (-3594.2402, -2695.0356, 4478.9370);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (-3594.2402, -2695.0356, 4497.8350);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (-3594.2402, -2695.0356, 4508.6221);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (-3594.2402, -2695.0356, 4516.5356);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (-3594.2402, -2695.0356, 4520.2363);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (-3594.2402, -2695.0356, 4518.3467);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (-3594.2402, -2695.0356, 4494.5669);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (-3594.2402, -2695.0356, 4490.8662);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (-3594.2402, -2695.0356, 4492.7559);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (-3594.2402, -2695.0356, 4516.5356);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (-3594.2402, -2695.0356, 4520.2363);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (-3594.2402, -2695.0356, 4518.3467);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (-3594.2402, -2695.0356, 4494.5669);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (-3594.2402, -2695.0356, 4490.8662);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (-3594.2402, -2695.0356, 4492.7559);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (-3594.2402, -2695.0356, 4516.5356);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (-3594.2402, -2695.0356, 4520.2363);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (-3594.2402, -2695.0356, 4518.3467);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (-3594.2402, -2695.0356, 4494.5669);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (-3594.2402, -2695.0356, 4490.8662);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (-3594.2402, -2695.0356, 4492.7559);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (-3594.2402, -2695.0356, 4516.5356);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (-3594.2402, -2695.0356, 4520.2363);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (-3594.2402, -2695.0356, 4518.3467);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (-3594.2402, -2695.0356, 4494.5669);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (-3594.2402, -2695.0356, 4489.6064);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (-3594.2402, -2695.0356, 3941.5747);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (-3594.2402, -2695.0356, 3935.2874);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (-3594.2402, -2695.0356, 3935.2874);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
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
	points[0] = (-6052.9922, -7165.9058, 6653.3071);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6052.9922, -7165.9058, 6650.0791);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-6052.9922, -7165.9058, 6637.9922);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-6052.9922, -7165.9058, 6641.2202);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-6052.9922, -7165.9058, 6653.3071);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-6052.9922, -7165.9058, 6650.0791);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-6052.9922, -7165.9058, 6637.9922);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-6052.9922, -7165.9058, 6641.2202);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-6052.9922, -7165.9058, 6653.3071);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-6052.9922, -7165.9058, 6650.0791);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-6052.9922, -7165.9058, 6655.9844);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-6052.9922, -7165.9058, 6788.8584);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (-6052.9922, -7165.9058, 6758.7402);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (-6052.9922, -7165.9058, 6683.4253);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (-6052.9922, -7165.9058, 6562.9531);
	angles[14] = (0, 0, 0);
	at[14] = 0.8000;
	points[15] = (-6052.9922, -7165.9058, 6397.3232);
	angles[15] = (0, 0, 0);
	at[15] = 0.8500;
	points[16] = (-6052.9922, -7165.9058, 6379.8818);
	angles[16] = (0, 0, 0);
	at[16] = 0.9000;
	points[17] = (-6052.9922, -7165.9058, 6379.8818);
	angles[17] = (0, 0, 0);
	at[17] = 1.8500;
	points[18] = (-6052.9922, -7165.9058, 6385.7876);
	angles[18] = (0, 0, 0);
	at[18] = 1.9000;
	points[19] = (-6052.9922, -7165.9058, 6642.6772);
	angles[19] = (0, 0, 0);
	at[19] = 3.3500;
	points[20] = (-6052.9922, -7165.9058, 6645.6299);
	angles[20] = (0, 0, 0);
	at[20] = 3.4000;
	points[21] = (-6052.9922, -7165.9058, 6645.6299);
	angles[21] = (0, 0, 0);
	at[21] = 5.3500;
	points[22] = (-6052.9922, -7165.9058, 6653.3071);
	angles[22] = (0, 0, 0);
	at[22] = 5.3833;
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
	points[0] = (-6049.2910, -4830.7085, 6653.3071);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6049.2910, -4830.7085, 6650.0791);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-6049.2910, -4830.7085, 6637.9922);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-6049.2910, -4830.7085, 6641.2202);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-6049.2910, -4830.7085, 6653.3071);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-6049.2910, -4830.7085, 6650.0791);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-6049.2910, -4830.7085, 6637.9922);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-6049.2910, -4830.7085, 6641.2202);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-6049.2910, -4830.7085, 6653.3071);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-6049.2910, -4830.7085, 6650.0791);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-6049.2910, -4830.7085, 6655.9844);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-6049.2910, -4830.7085, 6788.8584);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (-6049.2910, -4830.7085, 6758.7402);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (-6049.2910, -4830.7085, 6683.4253);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (-6049.2910, -4830.7085, 6562.9531);
	angles[14] = (0, 0, 0);
	at[14] = 0.8000;
	points[15] = (-6049.2910, -4830.7085, 6397.3232);
	angles[15] = (0, 0, 0);
	at[15] = 0.8500;
	points[16] = (-6049.2910, -4830.7085, 6379.8818);
	angles[16] = (0, 0, 0);
	at[16] = 0.9000;
	points[17] = (-6049.2910, -4830.7085, 6379.8818);
	angles[17] = (0, 0, 0);
	at[17] = 1.8500;
	points[18] = (-6049.2910, -4830.7085, 6385.7876);
	angles[18] = (0, 0, 0);
	at[18] = 1.9000;
	points[19] = (-6049.2910, -4830.7085, 6642.6772);
	angles[19] = (0, 0, 0);
	at[19] = 3.3500;
	points[20] = (-6049.2910, -4830.7085, 6645.6299);
	angles[20] = (0, 0, 0);
	at[20] = 3.4000;
	points[21] = (-6049.2910, -4830.7085, 6645.6299);
	angles[21] = (0, 0, 0);
	at[21] = 4.8500;
	points[22] = (-6049.2910, -4830.7085, 6653.3071);
	angles[22] = (0, 0, 0);
	at[22] = 4.8833;
	mover = getEnt("iz_obj_13", "targetname");
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
