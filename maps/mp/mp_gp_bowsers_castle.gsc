main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gp_bowsers_castle", 0);

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
	ambientPlay("iz_0_gpbc", 2);
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
	level.iz_route[level.iz_route.size] = (4391, 1934, 2953);
	level.iz_route[level.iz_route.size] = (4590, -5310, 2947);
	level.iz_route[level.iz_route.size] = (4586, -7584, 2947);
	level.iz_route[level.iz_route.size] = (4543, -8974, 2950);
	level.iz_route[level.iz_route.size] = (4092, -9469, 2964);
	level.iz_route[level.iz_route.size] = (1868, -9448, 2963);
	level.iz_route[level.iz_route.size] = (1542, -9092, 2954);
	level.iz_route[level.iz_route.size] = (1414, -6794, 2947);
	level.iz_route[level.iz_route.size] = (718, -6558, 2953);
	level.iz_route[level.iz_route.size] = (-2499, -6560, 2953);
	level.iz_route[level.iz_route.size] = (-3153, -7533, 2953);
	level.iz_route[level.iz_route.size] = (-3234, -12957, 2953);
	level.iz_route[level.iz_route.size] = (-3331, -13789, 3030);
	level.iz_route[level.iz_route.size] = (-3702, -14470, 3164);
	level.iz_route[level.iz_route.size] = (-4273, -14951, 3260);
	level.iz_route[level.iz_route.size] = (-4987, -15028, 3337);
	level.iz_route[level.iz_route.size] = (-7715, -15701, 3337);
	level.iz_route[level.iz_route.size] = (-8524, -15931, 3337);
	level.iz_route[level.iz_route.size] = (-9074, -16008, 3337);
	level.iz_route[level.iz_route.size] = (-9908, -15672, 3337);
	level.iz_route[level.iz_route.size] = (-10473, -15097, 3337);
	level.iz_route[level.iz_route.size] = (-10838, -13832, 3337);
	level.iz_route[level.iz_route.size] = (-10528, -13009, 3337);
	level.iz_route[level.iz_route.size] = (-9570, -11788, 3337);
	level.iz_route[level.iz_route.size] = (-9667, -6456, 3337);
	level.iz_route[level.iz_route.size] = (-10537, -5118, 3337);
	level.iz_route[level.iz_route.size] = (-10654, -4455, 3337);
	level.iz_route[level.iz_route.size] = (-10545, -3458, 3337);
	level.iz_route[level.iz_route.size] = (-9801, -1945, 3337);
	level.iz_route[level.iz_route.size] = (-9821, 165, 3337);
	level.iz_route[level.iz_route.size] = (-10371, 1297, 3337);
	level.iz_route[level.iz_route.size] = (-10656, 2201, 3337);
	level.iz_route[level.iz_route.size] = (-10572, 3086, 3337);
	level.iz_route[level.iz_route.size] = (-9867, 4301, 3337);
	level.iz_route[level.iz_route.size] = (-9541, 5603, 3337);
	level.iz_route[level.iz_route.size] = (-9685, 7640, 3337);
	level.iz_route[level.iz_route.size] = (-9999, 8250, 3337);
	level.iz_route[level.iz_route.size] = (-10660, 9992, 3337);
	level.iz_route[level.iz_route.size] = (-10182, 11111, 3337);
	level.iz_route[level.iz_route.size] = (-9545, 11607, 3337);
	level.iz_route[level.iz_route.size] = (-8158, 11475, 3337);
	level.iz_route[level.iz_route.size] = (-7015, 11080, 3337);
	level.iz_route[level.iz_route.size] = (-6399, 10634, 3337);
	level.iz_route[level.iz_route.size] = (-4611, 10464, 3337);
	level.iz_route[level.iz_route.size] = (-2877, 10395, 3241);
	level.iz_route[level.iz_route.size] = (-2398, 10029, 3164);
	level.iz_route[level.iz_route.size] = (-1646, 8014, 2953);
	level.iz_route[level.iz_route.size] = (248, 8122, 2954);
	level.iz_route[level.iz_route.size] = (1584, 8181, 2857);
	level.iz_route[level.iz_route.size] = (2650, 8176, 2501);
	level.iz_route[level.iz_route.size] = (3678, 7953, 2332);
	level.iz_route[level.iz_route.size] = (4142, 7633, 2338);
	level.iz_route[level.iz_route.size] = (4529, 7024, 2478);
	level.iz_route[level.iz_route.size] = (4537, 6004, 2788);
	level.iz_route[level.iz_route.size] = (4479, 5230, 2938);
	level.iz_route[level.iz_route.size] = (4491, 4479, 2953);
	level.iz_route[level.iz_route.size] = (4510, 3571, 2953);
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
	points[0] = (-10044.8037, 6017.4014, 3336.6064);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-10050.5908, 6017.5591, 3336.6064);
	angles[1] = (0, -180, 0);
	at[1] = 0.5000;
	points[2] = (-10049.8428, 6017.5200, 3336.6064);
	angles[2] = (0, -180, 0);
	at[2] = 1;
	points[3] = (-10047.3623, 6017.4800, 3336.6064);
	angles[3] = (0, -180, 0);
	at[3] = 1.5000;
	points[4] = (-10039.8037, 6017.2837, 3336.6064);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (-10039.8037, 6017.2837, 3336.6064);
	angles[5] = (0, -180, 0);
	at[5] = 2.5000;
	points[6] = (-10017.1260, 6016.6533, 3336.6064);
	angles[6] = (0, -180, 0);
	at[6] = 4.5000;
	points[7] = (-10017.1260, 6016.6533, 3336.6064);
	angles[7] = (0, -180, 0);
	at[7] = 5;
	points[8] = (-9994.4482, 6016.0630, 3336.6064);
	angles[8] = (0, -180, 0);
	at[8] = 7;
	points[9] = (-9994.4482, 6016.0630, 3336.6064);
	angles[9] = (0, -180, 0);
	at[9] = 7.5000;
	points[10] = (-9971.7715, 6015.4727, 3336.6064);
	angles[10] = (0, -180, 0);
	at[10] = 9.5000;
	points[11] = (-9971.7715, 6015.4727, 3336.6064);
	angles[11] = (0, -180, 0);
	at[11] = 10;
	points[12] = (-9949.0947, 6014.8818, 3336.6064);
	angles[12] = (0, -180, 0);
	at[12] = 12;
	points[13] = (-9949.0947, 6014.8818, 3336.6064);
	angles[13] = (0, -180, 0);
	at[13] = 12.5000;
	points[14] = (-9926.4570, 6014.2915, 3336.6064);
	angles[14] = (0, -180, 0);
	at[14] = 14.5000;
	points[15] = (-9926.4570, 6014.2915, 3336.6064);
	angles[15] = (0, -180, 0);
	at[15] = 15;
	points[16] = (-9903.7793, 6013.7007, 3336.6064);
	angles[16] = (0, -180, 0);
	at[16] = 17;
	points[17] = (-9903.7793, 6013.7007, 3336.6064);
	angles[17] = (0, -180, 0);
	at[17] = 17.5000;
	points[18] = (-9881.1025, 6013.1104, 3336.6064);
	angles[18] = (0, -180, 0);
	at[18] = 19.5000;
	points[19] = (-9881.1025, 6013.1104, 3336.6064);
	angles[19] = (0, -180, 0);
	at[19] = 20;
	points[20] = (-9858.4258, 6012.5200, 3336.6064);
	angles[20] = (0, -180, 0);
	at[20] = 22;
	points[21] = (-9858.4258, 6012.5200, 3336.6064);
	angles[21] = (0, -180, 0);
	at[21] = 22.5000;
	points[22] = (-9835.7480, 6011.9292, 3336.6064);
	angles[22] = (0, -180, 0);
	at[22] = 24.5000;
	points[23] = (-9835.7480, 6011.9292, 3336.6064);
	angles[23] = (0, -180, 0);
	at[23] = 25;
	points[24] = (-9813.1104, 6011.3389, 3336.6064);
	angles[24] = (0, -180, 0);
	at[24] = 27;
	points[25] = (-9813.1104, 6011.3389, 3336.6064);
	angles[25] = (0, -180, 0);
	at[25] = 27.5000;
	points[26] = (-9790.4336, 6010.7480, 3336.6064);
	angles[26] = (0, -180, 0);
	at[26] = 29.5000;
	points[27] = (-9790.4336, 6010.7480, 3336.6064);
	angles[27] = (0, -180, 0);
	at[27] = 30;
	points[28] = (-9767.7559, 6010.1577, 3336.6064);
	angles[28] = (0, -180, 0);
	at[28] = 32;
	points[29] = (-9767.7559, 6010.1577, 3336.6064);
	angles[29] = (0, -180, 0);
	at[29] = 32.5000;
	points[30] = (-9745.0791, 6009.5273, 3336.6064);
	angles[30] = (0, -180, 0);
	at[30] = 34.5000;
	points[31] = (-9745.0791, 6009.5273, 3336.6064);
	angles[31] = (0, -180, 0);
	at[31] = 35;
	points[32] = (-9722.4023, 6008.9370, 3336.6064);
	angles[32] = (0, -180, 0);
	at[32] = 37;
	points[33] = (-9722.4023, 6008.9370, 3336.6064);
	angles[33] = (0, -180, 0);
	at[33] = 37.5000;
	points[34] = (-9699.7637, 6008.3467, 3336.6064);
	angles[34] = (0, -180, 0);
	at[34] = 39.5000;
	points[35] = (-9699.7637, 6008.3467, 3336.6064);
	angles[35] = (0, -180, 0);
	at[35] = 40;
	points[36] = (-9677.0869, 6007.7559, 3336.6064);
	angles[36] = (0, -180, 0);
	at[36] = 42;
	points[37] = (-9677.0869, 6007.7559, 3336.6064);
	angles[37] = (0, -180, 0);
	at[37] = 42.5000;
	points[38] = (-9654.4092, 6007.1655, 3336.6064);
	angles[38] = (0, -180, 0);
	at[38] = 44.5000;
	points[39] = (-9654.4092, 6007.1655, 3336.6064);
	angles[39] = (0, -180, 0);
	at[39] = 45;
	points[40] = (-9631.7324, 6006.5747, 3336.6064);
	angles[40] = (0, -180, 0);
	at[40] = 47;
	points[41] = (-9631.7324, 6006.5747, 3336.6064);
	angles[41] = (0, -180, 0);
	at[41] = 47.5000;
	points[42] = (-9609.0557, 6005.9844, 3336.6064);
	angles[42] = (0, -180, 0);
	at[42] = 49.5000;
	points[43] = (-9609.0557, 6005.9844, 3336.6064);
	angles[43] = (0, -180, 0);
	at[43] = 50;
	points[44] = (-9586.4170, 6005.3940, 3336.6064);
	angles[44] = (0, -180, 0);
	at[44] = 52;
	points[45] = (-9586.4170, 6005.3940, 3336.6064);
	angles[45] = (0, -180, 0);
	at[45] = 52.5000;
	points[46] = (-9563.7402, 6004.8032, 3336.6064);
	angles[46] = (0, -180, 0);
	at[46] = 54.5000;
	points[47] = (-9563.7402, 6004.8032, 3336.6064);
	angles[47] = (0, -180, 0);
	at[47] = 55;
	points[48] = (-9541.0635, 6004.2129, 3336.6064);
	angles[48] = (0, -180, 0);
	at[48] = 57;
	points[49] = (-9541.0635, 6004.2129, 3336.6064);
	angles[49] = (0, -180, 0);
	at[49] = 57.5000;
	points[50] = (-9518.3857, 6003.6221, 3336.6064);
	angles[50] = (0, -180, 0);
	at[50] = 59.5000;
	points[51] = (-9518.3857, 6003.6221, 3336.6064);
	angles[51] = (0, -180, 0);
	at[51] = 60;
	points[52] = (-9495.7090, 6003.0317, 3336.6064);
	angles[52] = (0, -180, 0);
	at[52] = 62;
	points[53] = (-9495.7090, 6003.0317, 3336.6064);
	angles[53] = (0, -180, 0);
	at[53] = 62.5000;
	points[54] = (-9473.0713, 6002.4014, 3336.6064);
	angles[54] = (0, -180, 0);
	at[54] = 64.5000;
	points[55] = (-9473.0713, 6002.4014, 3336.6064);
	angles[55] = (0, -180, 0);
	at[55] = 65;
	points[56] = (-9450.3936, 6001.8110, 3336.6064);
	angles[56] = (0, -180, 0);
	at[56] = 67;
	points[57] = (-9450.3936, 6001.8110, 3336.6064);
	angles[57] = (0, -180, 0);
	at[57] = 67.5000;
	points[58] = (-9427.7168, 6001.2207, 3336.6064);
	angles[58] = (0, -180, 0);
	at[58] = 69.5000;
	points[59] = (-9427.7168, 6001.2207, 3336.6064);
	angles[59] = (0, -180, 0);
	at[59] = 70;
	points[60] = (-9405.0391, 6000.6299, 3336.6064);
	angles[60] = (0, -180, 0);
	at[60] = 72;
	points[61] = (-9405.0391, 6000.6299, 3336.6064);
	angles[61] = (0, -180, 0);
	at[61] = 72.5000;
	points[62] = (-9382.3623, 6000.0396, 3336.6064);
	angles[62] = (0, -180, 0);
	at[62] = 74.5000;
	points[63] = (-9382.3623, 6000.0396, 3336.6064);
	angles[63] = (0, -180, 0);
	at[63] = 75;
	points[64] = (-9359.7246, 5999.4487, 3336.6064);
	angles[64] = (0, -180, 0);
	at[64] = 77;
	points[65] = (-9359.7246, 5999.4487, 3336.6064);
	angles[65] = (0, -180, 0);
	at[65] = 77.5000;
	points[66] = (-9337.0469, 5998.8584, 3336.6064);
	angles[66] = (0, -180, 0);
	at[66] = 79.5000;
	points[67] = (-9337.0469, 5998.8584, 3336.6064);
	angles[67] = (0, -180, 0);
	at[67] = 80;
	points[68] = (-9314.3701, 5998.2681, 3336.6064);
	angles[68] = (0, -180, 0);
	at[68] = 82;
	points[69] = (-9314.3701, 5998.2681, 3336.6064);
	angles[69] = (0, -180, 0);
	at[69] = 82.5000;
	points[70] = (-9291.6934, 5997.6772, 3336.6064);
	angles[70] = (0, -180, 0);
	at[70] = 84.5000;
	points[71] = (-9291.6934, 5997.6772, 3336.6064);
	angles[71] = (0, -180, 0);
	at[71] = 85;
	points[72] = (-9269.0156, 5997.0869, 3336.6064);
	angles[72] = (0, -180, 0);
	at[72] = 87;
	points[73] = (-9269.0156, 5997.0869, 3336.6064);
	angles[73] = (0, -180, 0);
	at[73] = 87.5000;
	points[74] = (-9246.3779, 5996.4961, 3336.6064);
	angles[74] = (0, -180, 0);
	at[74] = 89.5000;
	points[75] = (-9246.3779, 5996.4961, 3336.6064);
	angles[75] = (0, -180, 0);
	at[75] = 90;
	points[76] = (-9233.7402, 5996.1421, 3336.6064);
	angles[76] = (0, -180, 0);
	at[76] = 91;
	points[77] = (-9231.2598, 5996.1021, 3336.6064);
	angles[77] = (0, -180, 0);
	at[77] = 91.5000;
	points[78] = (-9234.4883, 5996.1812, 3336.6064);
	angles[78] = (0, -180, 0);
	at[78] = 92.5000;
	points[79] = (-9257.1660, 5996.7715, 3336.6064);
	angles[79] = (0, -180, 0);
	at[79] = 94.5000;
	points[80] = (-9257.1660, 5996.7715, 3336.6064);
	angles[80] = (0, -180, 0);
	at[80] = 95;
	points[81] = (-9279.8428, 5997.3618, 3336.6064);
	angles[81] = (0, -180, 0);
	at[81] = 97;
	points[82] = (-9279.8428, 5997.3618, 3336.6064);
	angles[82] = (0, -180, 0);
	at[82] = 97.5000;
	points[83] = (-9302.4805, 5997.9531, 3336.6064);
	angles[83] = (0, -180, 0);
	at[83] = 99.5000;
	points[84] = (-9302.4805, 5997.9531, 3336.6064);
	angles[84] = (0, -180, 0);
	at[84] = 100;
	points[85] = (-9325.1572, 5998.5435, 3336.6064);
	angles[85] = (0, -180, 0);
	at[85] = 102;
	points[86] = (-9325.1572, 5998.5435, 3336.6064);
	angles[86] = (0, -180, 0);
	at[86] = 102.5000;
	points[87] = (-9347.8350, 5999.1343, 3336.6064);
	angles[87] = (0, -180, 0);
	at[87] = 104.5000;
	points[88] = (-9347.8350, 5999.1343, 3336.6064);
	angles[88] = (0, -180, 0);
	at[88] = 105;
	points[89] = (-9370.5117, 5999.7246, 3336.6064);
	angles[89] = (0, -180, 0);
	at[89] = 107;
	points[90] = (-9370.5117, 5999.7246, 3336.6064);
	angles[90] = (0, -180, 0);
	at[90] = 107.5000;
	points[91] = (-9393.1895, 6000.3154, 3336.6064);
	angles[91] = (0, -180, 0);
	at[91] = 109.5000;
	points[92] = (-9393.1895, 6000.3154, 3336.6064);
	angles[92] = (0, -180, 0);
	at[92] = 110;
	points[93] = (-9415.8271, 6000.9058, 3336.6064);
	angles[93] = (0, -180, 0);
	at[93] = 112;
	points[94] = (-9415.8271, 6000.9058, 3336.6064);
	angles[94] = (0, -180, 0);
	at[94] = 112.5000;
	points[95] = (-9438.5039, 6001.4961, 3336.6064);
	angles[95] = (0, -180, 0);
	at[95] = 114.5000;
	points[96] = (-9438.5039, 6001.4961, 3336.6064);
	angles[96] = (0, -180, 0);
	at[96] = 115;
	points[97] = (-9461.1807, 6002.1260, 3336.6064);
	angles[97] = (0, -180, 0);
	at[97] = 117;
	points[98] = (-9461.1807, 6002.1260, 3336.6064);
	angles[98] = (0, -180, 0);
	at[98] = 117.5000;
	points[99] = (-9483.8584, 6002.7163, 3336.6064);
	angles[99] = (0, -180, 0);
	at[99] = 119.5000;
	points[100] = (-9483.8584, 6002.7163, 3336.6064);
	angles[100] = (0, -180, 0);
	at[100] = 120;
	points[101] = (-9506.5361, 6003.3071, 3336.6064);
	angles[101] = (0, -180, 0);
	at[101] = 122;
	points[102] = (-9506.5361, 6003.3071, 3336.6064);
	angles[102] = (0, -180, 0);
	at[102] = 122.5000;
	points[103] = (-9529.1738, 6003.8975, 3336.6064);
	angles[103] = (0, -180, 0);
	at[103] = 124.5000;
	points[104] = (-9529.1738, 6003.8975, 3336.6064);
	angles[104] = (0, -180, 0);
	at[104] = 125;
	points[105] = (-9551.8506, 6004.4888, 3336.6064);
	angles[105] = (0, -180, 0);
	at[105] = 127;
	points[106] = (-9551.8506, 6004.4888, 3336.6064);
	angles[106] = (0, -180, 0);
	at[106] = 127.5000;
	points[107] = (-9574.5273, 6005.0791, 3336.6064);
	angles[107] = (0, -180, 0);
	at[107] = 129.5000;
	points[108] = (-9574.5273, 6005.0791, 3336.6064);
	angles[108] = (0, -180, 0);
	at[108] = 130;
	points[109] = (-9597.2051, 6005.6694, 3336.6064);
	angles[109] = (0, -180, 0);
	at[109] = 132;
	points[110] = (-9597.2051, 6005.6694, 3336.6064);
	angles[110] = (0, -180, 0);
	at[110] = 132.5000;
	points[111] = (-9619.8818, 6006.2603, 3336.6064);
	angles[111] = (0, -180, 0);
	at[111] = 134.5000;
	points[112] = (-9619.8818, 6006.2603, 3336.6064);
	angles[112] = (0, -180, 0);
	at[112] = 135;
	points[113] = (-9642.5195, 6006.8506, 3336.6064);
	angles[113] = (0, -180, 0);
	at[113] = 137;
	points[114] = (-9642.5195, 6006.8506, 3336.6064);
	angles[114] = (0, -180, 0);
	at[114] = 137.5000;
	points[115] = (-9665.1973, 6007.4414, 3336.6064);
	angles[115] = (0, -180, 0);
	at[115] = 139.5000;
	points[116] = (-9665.1973, 6007.4414, 3336.6064);
	angles[116] = (0, -180, 0);
	at[116] = 140;
	points[117] = (-9687.8740, 6008.0317, 3336.6064);
	angles[117] = (0, -180, 0);
	at[117] = 142;
	points[118] = (-9687.8740, 6008.0317, 3336.6064);
	angles[118] = (0, -180, 0);
	at[118] = 142.5000;
	points[119] = (-9710.5508, 6008.6221, 3336.6064);
	angles[119] = (0, -180, 0);
	at[119] = 144.5000;
	points[120] = (-9710.5508, 6008.6221, 3336.6064);
	angles[120] = (0, -180, 0);
	at[120] = 145;
	points[121] = (-9733.2285, 6009.2520, 3336.6064);
	angles[121] = (0, -180, 0);
	at[121] = 147;
	points[122] = (-9733.2285, 6009.2520, 3336.6064);
	angles[122] = (0, -180, 0);
	at[122] = 147.5000;
	points[123] = (-9755.8662, 6009.8423, 3336.6064);
	angles[123] = (0, -180, 0);
	at[123] = 149.5000;
	points[124] = (-9755.8662, 6009.8423, 3336.6064);
	angles[124] = (0, -180, 0);
	at[124] = 150;
	points[125] = (-9778.5430, 6010.4331, 3336.6064);
	angles[125] = (0, -180, 0);
	at[125] = 152;
	points[126] = (-9778.5430, 6010.4331, 3336.6064);
	angles[126] = (0, -180, 0);
	at[126] = 152.5000;
	points[127] = (-9801.2207, 6011.0234, 3336.6064);
	angles[127] = (0, -180, 0);
	at[127] = 154.5000;
	points[128] = (-9801.2207, 6011.0234, 3336.6064);
	angles[128] = (0, -180, 0);
	at[128] = 155;
	points[129] = (-9823.8975, 6011.6147, 3336.6064);
	angles[129] = (0, -180, 0);
	at[129] = 157;
	points[130] = (-9823.8975, 6011.6147, 3336.6064);
	angles[130] = (0, -180, 0);
	at[130] = 157.5000;
	points[131] = (-9846.5752, 6012.2051, 3336.6064);
	angles[131] = (0, -180, 0);
	at[131] = 159.5000;
	points[132] = (-9846.5752, 6012.2051, 3336.6064);
	angles[132] = (0, -180, 0);
	at[132] = 160;
	points[133] = (-9869.2129, 6012.7954, 3336.6064);
	angles[133] = (0, -180, 0);
	at[133] = 162;
	points[134] = (-9869.2129, 6012.7954, 3336.6064);
	angles[134] = (0, -180, 0);
	at[134] = 162.5000;
	points[135] = (-9891.8896, 6013.3862, 3336.6064);
	angles[135] = (0, -180, 0);
	at[135] = 164.5000;
	points[136] = (-9891.8896, 6013.3862, 3336.6064);
	angles[136] = (0, -180, 0);
	at[136] = 165;
	points[137] = (-9914.5674, 6013.9766, 3336.6064);
	angles[137] = (0, -180, 0);
	at[137] = 167;
	points[138] = (-9914.5674, 6013.9766, 3336.6064);
	angles[138] = (0, -180, 0);
	at[138] = 167.5000;
	points[139] = (-9937.2441, 6014.5674, 3336.6064);
	angles[139] = (0, -180, 0);
	at[139] = 169.5000;
	points[140] = (-9937.2441, 6014.5674, 3336.6064);
	angles[140] = (0, -180, 0);
	at[140] = 170;
	points[141] = (-9959.9209, 6015.1577, 3336.6064);
	angles[141] = (0, -180, 0);
	at[141] = 172;
	points[142] = (-9959.9209, 6015.1577, 3336.6064);
	angles[142] = (0, -180, 0);
	at[142] = 172.5000;
	points[143] = (-9982.5596, 6015.7480, 3336.6064);
	angles[143] = (0, -180, 0);
	at[143] = 174.5000;
	points[144] = (-9982.5596, 6015.7480, 3336.6064);
	angles[144] = (0, -180, 0);
	at[144] = 175;
	points[145] = (-10005.2363, 6016.3779, 3336.6064);
	angles[145] = (0, -180, 0);
	at[145] = 177;
	points[146] = (-10005.2363, 6016.3779, 3336.6064);
	angles[146] = (0, -180, 0);
	at[146] = 177.5000;
	points[147] = (-10027.9131, 6016.9683, 3336.6064);
	angles[147] = (0, -180, 0);
	at[147] = 179.5000;
	points[148] = (-10027.9131, 6016.9683, 3336.6064);
	angles[148] = (0, -180, 0);
	at[148] = 180;
	points[149] = (-10040.5508, 6017.2837, 3336.6064);
	angles[149] = (0, -180, 0);
	at[149] = 181;
	points[150] = (-10044.8037, 6017.4014, 3336.6064);
	angles[150] = (0, -180, 0);
	at[150] = 181.7670;
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
	points[0] = (-10397.4414, 9947.3623, 3336.6064);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-10403.8184, 9947.3232, 3336.6064);
	angles[1] = (0, -180, 0);
	at[1] = 0.5000;
	points[2] = (-10405, 9947.3232, 3336.6064);
	angles[2] = (0, -180, 0);
	at[2] = 1;
	points[3] = (-10412.5596, 9947.2832, 3336.6064);
	angles[3] = (0, -180, 0);
	at[3] = 1.5000;
	points[4] = (-10412.6768, 9947.2832, 3336.6064);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (-10426.4961, 9947.2051, 3336.6064);
	angles[5] = (0, -180, 0);
	at[5] = 3;
	points[6] = (-10427.6777, 9947.2051, 3336.6064);
	angles[6] = (0, -180, 0);
	at[6] = 3.5000;
	points[7] = (-10435.2363, 9947.1660, 3336.6064);
	angles[7] = (0, -180, 0);
	at[7] = 4;
	points[8] = (-10435.3555, 9947.1660, 3336.6064);
	angles[8] = (0, -180, 0);
	at[8] = 4.5000;
	points[9] = (-10449.1729, 9947.0869, 3336.6064);
	angles[9] = (0, -180, 0);
	at[9] = 5.5000;
	points[10] = (-10450.3545, 9947.0869, 3336.6064);
	angles[10] = (0, -180, 0);
	at[10] = 6;
	points[11] = (-10457.9141, 9947.0469, 3336.6064);
	angles[11] = (0, -180, 0);
	at[11] = 6.5000;
	points[12] = (-10458.0312, 9947.0469, 3336.6064);
	angles[12] = (0, -180, 0);
	at[12] = 7;
	points[13] = (-10471.8496, 9946.9688, 3336.6064);
	angles[13] = (0, -180, 0);
	at[13] = 8;
	points[14] = (-10473.0322, 9946.9688, 3336.6064);
	angles[14] = (0, -180, 0);
	at[14] = 8.5000;
	points[15] = (-10480.5908, 9946.9287, 3336.6064);
	angles[15] = (0, -180, 0);
	at[15] = 9;
	points[16] = (-10480.7080, 9946.9287, 3336.6064);
	angles[16] = (0, -180, 0);
	at[16] = 9.5000;
	points[17] = (-10494.5283, 9946.8506, 3336.6064);
	angles[17] = (0, -180, 0);
	at[17] = 10.5000;
	points[18] = (-10495.7090, 9946.8506, 3336.6064);
	angles[18] = (0, -180, 0);
	at[18] = 11;
	points[19] = (-10503.2676, 9946.8115, 3336.6064);
	angles[19] = (0, -180, 0);
	at[19] = 11.5000;
	points[20] = (-10503.3867, 9946.8115, 3336.6064);
	angles[20] = (0, -180, 0);
	at[20] = 12;
	points[21] = (-10517.2051, 9946.7324, 3336.6064);
	angles[21] = (0, -180, 0);
	at[21] = 13;
	points[22] = (-10518.3857, 9946.7324, 3336.6064);
	angles[22] = (0, -180, 0);
	at[22] = 13.5000;
	points[23] = (-10525.9453, 9946.6934, 3336.6064);
	angles[23] = (0, -180, 0);
	at[23] = 14;
	points[24] = (-10526.0635, 9946.6934, 3336.6064);
	angles[24] = (0, -180, 0);
	at[24] = 14.5000;
	points[25] = (-10539.8828, 9946.6143, 3336.6064);
	angles[25] = (0, -180, 0);
	at[25] = 15.5000;
	points[26] = (-10541.0635, 9946.6143, 3336.6064);
	angles[26] = (0, -180, 0);
	at[26] = 16;
	points[27] = (-10548.6221, 9946.5752, 3336.6064);
	angles[27] = (0, -180, 0);
	at[27] = 16.5000;
	points[28] = (-10548.7402, 9946.5752, 3336.6064);
	angles[28] = (0, -180, 0);
	at[28] = 17;
	points[29] = (-10562.5596, 9946.4961, 3336.6064);
	angles[29] = (0, -180, 0);
	at[29] = 18;
	points[30] = (-10563.7402, 9946.4961, 3336.6064);
	angles[30] = (0, -180, 0);
	at[30] = 18.5000;
	points[31] = (-10571.2988, 9946.4570, 3336.6064);
	angles[31] = (0, -180, 0);
	at[31] = 19;
	points[32] = (-10571.4180, 9946.4570, 3336.6064);
	angles[32] = (0, -180, 0);
	at[32] = 19.5000;
	points[33] = (-10585.2363, 9946.3779, 3336.6064);
	angles[33] = (0, -180, 0);
	at[33] = 20.5000;
	points[34] = (-10586.4170, 9946.3779, 3336.6064);
	angles[34] = (0, -180, 0);
	at[34] = 21;
	points[35] = (-10593.9766, 9946.3389, 3336.6064);
	angles[35] = (0, -180, 0);
	at[35] = 21.5000;
	points[36] = (-10594.0947, 9946.3389, 3336.6064);
	angles[36] = (0, -180, 0);
	at[36] = 22;
	points[37] = (-10607.9141, 9946.2598, 3336.6064);
	angles[37] = (0, -180, 0);
	at[37] = 23;
	points[38] = (-10609.0947, 9946.2598, 3336.6064);
	angles[38] = (0, -180, 0);
	at[38] = 23.5000;
	points[39] = (-10616.6533, 9946.2207, 3336.6064);
	angles[39] = (0, -180, 0);
	at[39] = 24;
	points[40] = (-10616.7715, 9946.2207, 3336.6064);
	angles[40] = (0, -180, 0);
	at[40] = 24.5000;
	points[41] = (-10630.5908, 9946.1416, 3336.6064);
	angles[41] = (0, -180, 0);
	at[41] = 25.5000;
	points[42] = (-10631.7715, 9946.1416, 3336.6064);
	angles[42] = (0, -180, 0);
	at[42] = 26;
	points[43] = (-10639.3311, 9946.1025, 3336.6064);
	angles[43] = (0, -180, 0);
	at[43] = 26.5000;
	points[44] = (-10639.4492, 9946.1025, 3336.6064);
	angles[44] = (0, -180, 0);
	at[44] = 27;
	points[45] = (-10653.2676, 9946.0234, 3336.6064);
	angles[45] = (0, -180, 0);
	at[45] = 28;
	points[46] = (-10654.4482, 9946.0234, 3336.6064);
	angles[46] = (0, -180, 0);
	at[46] = 28.5000;
	points[47] = (-10662.0078, 9945.9844, 3336.6064);
	angles[47] = (0, -180, 0);
	at[47] = 29;
	points[48] = (-10662.1260, 9945.9844, 3336.6064);
	angles[48] = (0, -180, 0);
	at[48] = 29.5000;
	points[49] = (-10675.9453, 9945.9062, 3336.6064);
	angles[49] = (0, -180, 0);
	at[49] = 30.5000;
	points[50] = (-10677.1260, 9945.9062, 3336.6064);
	angles[50] = (0, -180, 0);
	at[50] = 31;
	points[51] = (-10684.6846, 9945.8662, 3336.6064);
	angles[51] = (0, -180, 0);
	at[51] = 31.5000;
	points[52] = (-10684.8037, 9945.8662, 3336.6064);
	angles[52] = (0, -180, 0);
	at[52] = 32;
	points[53] = (-10698.6221, 9945.8262, 3336.6064);
	angles[53] = (0, -180, 0);
	at[53] = 33;
	points[54] = (-10699.8027, 9945.7871, 3336.6064);
	angles[54] = (0, -180, 0);
	at[54] = 33.5000;
	points[55] = (-10707.3623, 9945.7480, 3336.6064);
	angles[55] = (0, -180, 0);
	at[55] = 34;
	points[56] = (-10707.4805, 9945.7480, 3336.6064);
	angles[56] = (0, -180, 0);
	at[56] = 34.5000;
	points[57] = (-10721.2998, 9945.7090, 3336.6064);
	angles[57] = (0, -180, 0);
	at[57] = 35.5000;
	points[58] = (-10722.4814, 9945.6689, 3336.6064);
	angles[58] = (0, -180, 0);
	at[58] = 36;
	points[59] = (-10730.0391, 9945.6299, 3336.6064);
	angles[59] = (0, -180, 0);
	at[59] = 36.5000;
	points[60] = (-10730.1572, 9945.6299, 3336.6064);
	angles[60] = (0, -180, 0);
	at[60] = 37;
	points[61] = (-10743.9766, 9945.5908, 3336.6064);
	angles[61] = (0, -180, 0);
	at[61] = 38;
	points[62] = (-10745.1572, 9945.5518, 3336.6064);
	angles[62] = (0, -180, 0);
	at[62] = 38.5000;
	points[63] = (-10752.7158, 9945.5117, 3336.6064);
	angles[63] = (0, -180, 0);
	at[63] = 39;
	points[64] = (-10752.8350, 9945.5117, 3336.6064);
	angles[64] = (0, -180, 0);
	at[64] = 39.5000;
	points[65] = (-10766.6533, 9945.4727, 3336.6064);
	angles[65] = (0, -180, 0);
	at[65] = 40.5000;
	points[66] = (-10767.8340, 9945.4727, 3336.6064);
	angles[66] = (0, -180, 0);
	at[66] = 41;
	points[67] = (-10775.3945, 9945.4336, 3336.6064);
	angles[67] = (0, -180, 0);
	at[67] = 41.5000;
	points[68] = (-10775.5117, 9945.3945, 3336.6064);
	angles[68] = (0, -180, 0);
	at[68] = 42;
	points[69] = (-10789.3311, 9945.3545, 3336.6064);
	angles[69] = (0, -180, 0);
	at[69] = 43;
	points[70] = (-10790.5127, 9945.3545, 3336.6064);
	angles[70] = (0, -180, 0);
	at[70] = 43.5000;
	points[71] = (-10798.0713, 9945.3145, 3336.6064);
	angles[71] = (0, -180, 0);
	at[71] = 44;
	points[72] = (-10798.1885, 9945.3145, 3336.6064);
	angles[72] = (0, -180, 0);
	at[72] = 44.5000;
	points[73] = (-10812.0078, 9945.2363, 3336.6064);
	angles[73] = (0, -180, 0);
	at[73] = 45.5000;
	points[74] = (-10813.1895, 9945.2363, 3336.6064);
	angles[74] = (0, -180, 0);
	at[74] = 46;
	points[75] = (-10820.7480, 9945.1973, 3336.6064);
	angles[75] = (0, -180, 0);
	at[75] = 46.5000;
	points[76] = (-10820.8662, 9945.1973, 3336.6064);
	angles[76] = (0, -180, 0);
	at[76] = 47;
	points[77] = (-10834.6846, 9945.1182, 3336.6064);
	angles[77] = (0, -180, 0);
	at[77] = 48;
	points[78] = (-10835.8662, 9945.1182, 3336.6064);
	angles[78] = (0, -180, 0);
	at[78] = 48.5000;
	points[79] = (-10843.4258, 9945.0791, 3336.6064);
	angles[79] = (0, -180, 0);
	at[79] = 49;
	points[80] = (-10843.5430, 9945.0791, 3336.6064);
	angles[80] = (0, -180, 0);
	at[80] = 49.5000;
	points[81] = (-10857.3623, 9945, 3336.6064);
	angles[81] = (0, -180, 0);
	at[81] = 50.5000;
	points[82] = (-10858.5439, 9945, 3336.6064);
	angles[82] = (0, -180, 0);
	at[82] = 51;
	points[83] = (-10866.1025, 9944.9609, 3336.6064);
	angles[83] = (0, -180, 0);
	at[83] = 51.5000;
	points[84] = (-10866.2207, 9944.9609, 3336.6064);
	angles[84] = (0, -180, 0);
	at[84] = 52;
	points[85] = (-10880.0391, 9944.8818, 3336.6064);
	angles[85] = (0, -180, 0);
	at[85] = 53;
	points[86] = (-10881.2207, 9944.8818, 3336.6064);
	angles[86] = (0, -180, 0);
	at[86] = 53.5000;
	points[87] = (-10888.7803, 9944.8428, 3336.6064);
	angles[87] = (0, -180, 0);
	at[87] = 54;
	points[88] = (-10888.8975, 9944.8428, 3336.6064);
	angles[88] = (0, -180, 0);
	at[88] = 54.5000;
	points[89] = (-10902.7158, 9944.7637, 3336.6064);
	angles[89] = (0, -180, 0);
	at[89] = 55.5000;
	points[90] = (-10903.8984, 9944.7637, 3336.6064);
	angles[90] = (0, -180, 0);
	at[90] = 56;
	points[91] = (-10911.4570, 9944.7246, 3336.6064);
	angles[91] = (0, -180, 0);
	at[91] = 56.5000;
	points[92] = (-10911.5742, 9944.7246, 3336.6064);
	angles[92] = (0, -180, 0);
	at[92] = 57;
	points[93] = (-10925.3936, 9944.6455, 3336.6064);
	angles[93] = (0, -180, 0);
	at[93] = 58;
	points[94] = (-10926.5752, 9944.6455, 3336.6064);
	angles[94] = (0, -180, 0);
	at[94] = 58.5000;
	points[95] = (-10934.1338, 9944.6064, 3336.6064);
	angles[95] = (0, -180, 0);
	at[95] = 59;
	points[96] = (-10934.2529, 9944.6064, 3336.6064);
	angles[96] = (0, -180, 0);
	at[96] = 59.5000;
	points[97] = (-10948.0703, 9944.5273, 3336.6064);
	angles[97] = (0, -180, 0);
	at[97] = 60.5000;
	points[98] = (-10949.2520, 9944.5273, 3336.6064);
	angles[98] = (0, -180, 0);
	at[98] = 61;
	points[99] = (-10956.8115, 9944.4883, 3336.6064);
	angles[99] = (0, -180, 0);
	at[99] = 61.5000;
	points[100] = (-10956.9297, 9944.4883, 3336.6064);
	angles[100] = (0, -180, 0);
	at[100] = 62;
	points[101] = (-10970.7490, 9944.4092, 3336.6064);
	angles[101] = (0, -180, 0);
	at[101] = 63;
	points[102] = (-10971.9297, 9944.4092, 3336.6064);
	angles[102] = (0, -180, 0);
	at[102] = 63.5000;
	points[103] = (-10979.4883, 9944.3701, 3336.6064);
	angles[103] = (0, -180, 0);
	at[103] = 64;
	points[104] = (-10979.6064, 9944.3701, 3336.6064);
	angles[104] = (0, -180, 0);
	at[104] = 64.5000;
	points[105] = (-10993.4258, 9944.2920, 3336.6064);
	angles[105] = (0, -180, 0);
	at[105] = 65.5000;
	points[106] = (-10994.6064, 9944.2920, 3336.6064);
	angles[106] = (0, -180, 0);
	at[106] = 66;
	points[107] = (-11002.1650, 9944.2520, 3336.6064);
	angles[107] = (0, -180, 0);
	at[107] = 66.5000;
	points[108] = (-11002.2842, 9944.2520, 3336.6064);
	angles[108] = (0, -180, 0);
	at[108] = 67;
	points[109] = (-11016.1025, 9944.1738, 3336.6064);
	angles[109] = (0, -180, 0);
	at[109] = 68;
	points[110] = (-11017.2832, 9944.1738, 3336.6064);
	angles[110] = (0, -180, 0);
	at[110] = 68.5000;
	points[111] = (-11024.8428, 9944.1338, 3336.6064);
	angles[111] = (0, -180, 0);
	at[111] = 69;
	points[112] = (-11024.9609, 9944.1338, 3336.6064);
	angles[112] = (0, -180, 0);
	at[112] = 69.5000;
	points[113] = (-11038.7803, 9944.0547, 3336.6064);
	angles[113] = (0, -180, 0);
	at[113] = 70.5000;
	points[114] = (-11039.9609, 9944.0547, 3336.6064);
	angles[114] = (0, -180, 0);
	at[114] = 71;
	points[115] = (-11047.5195, 9944.0156, 3336.6064);
	angles[115] = (0, -180, 0);
	at[115] = 71.5000;
	points[116] = (-11047.6377, 9944.0156, 3336.6064);
	angles[116] = (0, -180, 0);
	at[116] = 72;
	points[117] = (-11061.4570, 9943.9375, 3336.6064);
	angles[117] = (0, -180, 0);
	at[117] = 73;
	points[118] = (-11062.6377, 9943.9375, 3336.6064);
	angles[118] = (0, -180, 0);
	at[118] = 73.5000;
	points[119] = (-11070.1973, 9943.8975, 3336.6064);
	angles[119] = (0, -180, 0);
	at[119] = 74;
	points[120] = (-11070.3154, 9943.8975, 3336.6064);
	angles[120] = (0, -180, 0);
	at[120] = 74.5000;
	points[121] = (-11084.1338, 9943.8193, 3336.6064);
	angles[121] = (0, -180, 0);
	at[121] = 75.5000;
	points[122] = (-11082.0479, 9943.8584, 3336.6064);
	angles[122] = (0, -180, 0);
	at[122] = 76;
	points[123] = (-11074.4883, 9943.8975, 3336.6064);
	angles[123] = (0, -180, 0);
	at[123] = 76.5000;
	points[124] = (-11074.3701, 9943.8975, 3336.6064);
	angles[124] = (0, -180, 0);
	at[124] = 77;
	points[125] = (-11060.5508, 9943.9375, 3336.6064);
	angles[125] = (0, -180, 0);
	at[125] = 78;
	points[126] = (-11059.3701, 9943.9375, 3336.6064);
	angles[126] = (0, -180, 0);
	at[126] = 78.5000;
	points[127] = (-11051.8115, 9943.9766, 3336.6064);
	angles[127] = (0, -180, 0);
	at[127] = 79;
	points[128] = (-11051.6934, 9943.9766, 3336.6064);
	angles[128] = (0, -180, 0);
	at[128] = 79.5000;
	points[129] = (-11037.8740, 9944.0547, 3336.6064);
	angles[129] = (0, -180, 0);
	at[129] = 80.5000;
	points[130] = (-11036.6934, 9944.0547, 3336.6064);
	angles[130] = (0, -180, 0);
	at[130] = 81;
	points[131] = (-11029.1348, 9944.0947, 3336.6064);
	angles[131] = (0, -180, 0);
	at[131] = 81.5000;
	points[132] = (-11029.0156, 9944.0947, 3336.6064);
	angles[132] = (0, -180, 0);
	at[132] = 82;
	points[133] = (-11015.1973, 9944.1738, 3336.6064);
	angles[133] = (0, -180, 0);
	at[133] = 83;
	points[134] = (-11014.0166, 9944.1738, 3336.6064);
	angles[134] = (0, -180, 0);
	at[134] = 83.5000;
	points[135] = (-11006.4570, 9944.2129, 3336.6064);
	angles[135] = (0, -180, 0);
	at[135] = 84;
	points[136] = (-11006.3389, 9944.2129, 3336.6064);
	angles[136] = (0, -180, 0);
	at[136] = 84.5000;
	points[137] = (-10992.5195, 9944.2920, 3336.6064);
	angles[137] = (0, -180, 0);
	at[137] = 85.5000;
	points[138] = (-10991.3389, 9944.2920, 3336.6064);
	angles[138] = (0, -180, 0);
	at[138] = 86;
	points[139] = (-10983.7803, 9944.3311, 3336.6064);
	angles[139] = (0, -180, 0);
	at[139] = 86.5000;
	points[140] = (-10983.6611, 9944.3311, 3336.6064);
	angles[140] = (0, -180, 0);
	at[140] = 87;
	points[141] = (-10969.8428, 9944.4092, 3336.6064);
	angles[141] = (0, -180, 0);
	at[141] = 88;
	points[142] = (-10968.6621, 9944.4092, 3336.6064);
	angles[142] = (0, -180, 0);
	at[142] = 88.5000;
	points[143] = (-10961.1016, 9944.4492, 3336.6064);
	angles[143] = (0, -180, 0);
	at[143] = 89;
	points[144] = (-10960.9844, 9944.4492, 3336.6064);
	angles[144] = (0, -180, 0);
	at[144] = 89.5000;
	points[145] = (-10947.1660, 9944.5273, 3336.6064);
	angles[145] = (0, -180, 0);
	at[145] = 90.5000;
	points[146] = (-10945.9854, 9944.5273, 3336.6064);
	angles[146] = (0, -180, 0);
	at[146] = 91;
	points[147] = (-10938.4248, 9944.5664, 3336.6064);
	angles[147] = (0, -180, 0);
	at[147] = 91.5000;
	points[148] = (-10938.3076, 9944.5664, 3336.6064);
	angles[148] = (0, -180, 0);
	at[148] = 92;
	points[149] = (-10924.4883, 9944.6455, 3336.6064);
	angles[149] = (0, -180, 0);
	at[149] = 93;
	points[150] = (-10923.3066, 9944.6455, 3336.6064);
	angles[150] = (0, -180, 0);
	at[150] = 93.5000;
	points[151] = (-10915.7490, 9944.6855, 3336.6064);
	angles[151] = (0, -180, 0);
	at[151] = 94;
	points[152] = (-10915.6299, 9944.6855, 3336.6064);
	angles[152] = (0, -180, 0);
	at[152] = 94.5000;
	points[153] = (-10901.8115, 9944.7637, 3336.6064);
	angles[153] = (0, -180, 0);
	at[153] = 95.5000;
	points[154] = (-10900.6299, 9944.7637, 3336.6064);
	angles[154] = (0, -180, 0);
	at[154] = 96;
	points[155] = (-10893.0703, 9944.8037, 3336.6064);
	angles[155] = (0, -180, 0);
	at[155] = 96.5000;
	points[156] = (-10892.9531, 9944.8037, 3336.6064);
	angles[156] = (0, -180, 0);
	at[156] = 97;
	points[157] = (-10879.1338, 9944.8818, 3336.6064);
	angles[157] = (0, -180, 0);
	at[157] = 98;
	points[158] = (-10877.9521, 9944.8818, 3336.6064);
	angles[158] = (0, -180, 0);
	at[158] = 98.5000;
	points[159] = (-10870.3936, 9944.9209, 3336.6064);
	angles[159] = (0, -180, 0);
	at[159] = 99;
	points[160] = (-10870.2764, 9944.9209, 3336.6064);
	angles[160] = (0, -180, 0);
	at[160] = 99.5000;
	points[161] = (-10856.4570, 9945, 3336.6064);
	angles[161] = (0, -180, 0);
	at[161] = 100.5000;
	points[162] = (-10855.2754, 9945, 3336.6064);
	angles[162] = (0, -180, 0);
	at[162] = 101;
	points[163] = (-10847.7168, 9945.0400, 3336.6064);
	angles[163] = (0, -180, 0);
	at[163] = 101.5000;
	points[164] = (-10847.5986, 9945.0400, 3336.6064);
	angles[164] = (0, -180, 0);
	at[164] = 102;
	points[165] = (-10833.7803, 9945.1182, 3336.6064);
	angles[165] = (0, -180, 0);
	at[165] = 103;
	points[166] = (-10832.5986, 9945.1182, 3336.6064);
	angles[166] = (0, -180, 0);
	at[166] = 103.5000;
	points[167] = (-10825.0391, 9945.1572, 3336.6064);
	angles[167] = (0, -180, 0);
	at[167] = 104;
	points[168] = (-10824.9219, 9945.1572, 3336.6064);
	angles[168] = (0, -180, 0);
	at[168] = 104.5000;
	points[169] = (-10811.1025, 9945.2363, 3336.6064);
	angles[169] = (0, -180, 0);
	at[169] = 105.5000;
	points[170] = (-10809.9209, 9945.2363, 3336.6064);
	angles[170] = (0, -180, 0);
	at[170] = 106;
	points[171] = (-10802.3623, 9945.2754, 3336.6064);
	angles[171] = (0, -180, 0);
	at[171] = 106.5000;
	points[172] = (-10802.2451, 9945.2754, 3336.6064);
	angles[172] = (0, -180, 0);
	at[172] = 107;
	points[173] = (-10788.4258, 9945.3545, 3336.6064);
	angles[173] = (0, -180, 0);
	at[173] = 108;
	points[174] = (-10787.2441, 9945.3545, 3336.6064);
	angles[174] = (0, -180, 0);
	at[174] = 108.5000;
	points[175] = (-10779.6846, 9945.3945, 3336.6064);
	angles[175] = (0, -180, 0);
	at[175] = 109;
	points[176] = (-10779.5664, 9945.3945, 3336.6064);
	angles[176] = (0, -180, 0);
	at[176] = 109.5000;
	points[177] = (-10765.7490, 9945.4727, 3336.6064);
	angles[177] = (0, -180, 0);
	at[177] = 110.5000;
	points[178] = (-10764.5674, 9945.4727, 3336.6064);
	angles[178] = (0, -180, 0);
	at[178] = 111;
	points[179] = (-10757.0078, 9945.5117, 3336.6064);
	angles[179] = (0, -180, 0);
	at[179] = 111.5000;
	points[180] = (-10756.8896, 9945.5117, 3336.6064);
	angles[180] = (0, -180, 0);
	at[180] = 112;
	points[181] = (-10743.0703, 9945.5908, 3336.6064);
	angles[181] = (0, -180, 0);
	at[181] = 113;
	points[182] = (-10741.8896, 9945.5908, 3336.6064);
	angles[182] = (0, -180, 0);
	at[182] = 113.5000;
	points[183] = (-10734.3311, 9945.6299, 3336.6064);
	angles[183] = (0, -180, 0);
	at[183] = 114;
	points[184] = (-10734.2119, 9945.6299, 3336.6064);
	angles[184] = (0, -180, 0);
	at[184] = 114.5000;
	points[185] = (-10720.3936, 9945.7090, 3336.6064);
	angles[185] = (0, -180, 0);
	at[185] = 115.5000;
	points[186] = (-10719.2129, 9945.7090, 3336.6064);
	angles[186] = (0, -180, 0);
	at[186] = 116;
	points[187] = (-10711.6533, 9945.7480, 3336.6064);
	angles[187] = (0, -180, 0);
	at[187] = 116.5000;
	points[188] = (-10711.5352, 9945.7480, 3336.6064);
	angles[188] = (0, -180, 0);
	at[188] = 117;
	points[189] = (-10697.7158, 9945.8262, 3336.6064);
	angles[189] = (0, -180, 0);
	at[189] = 118;
	points[190] = (-10696.5352, 9945.8262, 3336.6064);
	angles[190] = (0, -180, 0);
	at[190] = 118.5000;
	points[191] = (-10688.9766, 9945.8662, 3336.6064);
	angles[191] = (0, -180, 0);
	at[191] = 119;
	points[192] = (-10688.8584, 9945.8662, 3336.6064);
	angles[192] = (0, -180, 0);
	at[192] = 119.5000;
	points[193] = (-10675.0391, 9945.9453, 3336.6064);
	angles[193] = (0, -180, 0);
	at[193] = 120.5000;
	points[194] = (-10673.8584, 9945.9453, 3336.6064);
	angles[194] = (0, -180, 0);
	at[194] = 121;
	points[195] = (-10666.2998, 9945.9844, 3336.6064);
	angles[195] = (0, -180, 0);
	at[195] = 121.5000;
	points[196] = (-10666.1807, 9945.9844, 3336.6064);
	angles[196] = (0, -180, 0);
	at[196] = 122;
	points[197] = (-10652.3623, 9946.0635, 3336.6064);
	angles[197] = (0, -180, 0);
	at[197] = 123;
	points[198] = (-10651.1816, 9946.0635, 3336.6064);
	angles[198] = (0, -180, 0);
	at[198] = 123.5000;
	points[199] = (-10643.6221, 9946.1025, 3336.6064);
	angles[199] = (0, -180, 0);
	at[199] = 124;
	points[200] = (-10643.5039, 9946.1025, 3336.6064);
	angles[200] = (0, -180, 0);
	at[200] = 124.5000;
	points[201] = (-10629.6846, 9946.1807, 3336.6064);
	angles[201] = (0, -180, 0);
	at[201] = 125.5000;
	points[202] = (-10628.5039, 9946.1807, 3336.6064);
	angles[202] = (0, -180, 0);
	at[202] = 126;
	points[203] = (-10620.9453, 9946.2207, 3336.6064);
	angles[203] = (0, -180, 0);
	at[203] = 126.5000;
	points[204] = (-10620.8271, 9946.2207, 3336.6064);
	angles[204] = (0, -180, 0);
	at[204] = 127;
	points[205] = (-10607.0078, 9946.2598, 3336.6064);
	angles[205] = (0, -180, 0);
	at[205] = 128;
	points[206] = (-10605.8271, 9946.2998, 3336.6064);
	angles[206] = (0, -180, 0);
	at[206] = 128.5000;
	points[207] = (-10598.2686, 9946.3389, 3336.6064);
	angles[207] = (0, -180, 0);
	at[207] = 129;
	points[208] = (-10598.1494, 9946.3389, 3336.6064);
	angles[208] = (0, -180, 0);
	at[208] = 129.5000;
	points[209] = (-10584.3311, 9946.3779, 3336.6064);
	angles[209] = (0, -180, 0);
	at[209] = 130.5000;
	points[210] = (-10583.1504, 9946.4180, 3336.6064);
	angles[210] = (0, -180, 0);
	at[210] = 131;
	points[211] = (-10575.5908, 9946.4570, 3336.6064);
	angles[211] = (0, -180, 0);
	at[211] = 131.5000;
	points[212] = (-10575.4727, 9946.4570, 3336.6064);
	angles[212] = (0, -180, 0);
	at[212] = 132;
	points[213] = (-10561.6533, 9946.4961, 3336.6064);
	angles[213] = (0, -180, 0);
	at[213] = 133;
	points[214] = (-10560.4727, 9946.5352, 3336.6064);
	angles[214] = (0, -180, 0);
	at[214] = 133.5000;
	points[215] = (-10552.9141, 9946.5752, 3336.6064);
	angles[215] = (0, -180, 0);
	at[215] = 134;
	points[216] = (-10552.7949, 9946.5752, 3336.6064);
	angles[216] = (0, -180, 0);
	at[216] = 134.5000;
	points[217] = (-10538.9766, 9946.6143, 3336.6064);
	angles[217] = (0, -180, 0);
	at[217] = 135.5000;
	points[218] = (-10537.7959, 9946.6543, 3336.6064);
	angles[218] = (0, -180, 0);
	at[218] = 136;
	points[219] = (-10530.2354, 9946.6543, 3336.6064);
	angles[219] = (0, -180, 0);
	at[219] = 136.5000;
	points[220] = (-10530.1182, 9946.6543, 3336.6064);
	angles[220] = (0, -180, 0);
	at[220] = 137;
	points[221] = (-10516.2998, 9946.7324, 3336.6064);
	angles[221] = (0, -180, 0);
	at[221] = 138;
	points[222] = (-10515.1191, 9946.7324, 3336.6064);
	angles[222] = (0, -180, 0);
	at[222] = 138.5000;
	points[223] = (-10507.5596, 9946.7715, 3336.6064);
	angles[223] = (0, -180, 0);
	at[223] = 139;
	points[224] = (-10507.4414, 9946.7715, 3336.6064);
	angles[224] = (0, -180, 0);
	at[224] = 139.5000;
	points[225] = (-10493.6221, 9946.8506, 3336.6064);
	angles[225] = (0, -180, 0);
	at[225] = 140.5000;
	points[226] = (-10492.4404, 9946.8506, 3336.6064);
	angles[226] = (0, -180, 0);
	at[226] = 141;
	points[227] = (-10484.8828, 9946.8896, 3336.6064);
	angles[227] = (0, -180, 0);
	at[227] = 141.5000;
	points[228] = (-10484.7637, 9946.8896, 3336.6064);
	angles[228] = (0, -180, 0);
	at[228] = 142;
	points[229] = (-10470.9453, 9946.9688, 3336.6064);
	angles[229] = (0, -180, 0);
	at[229] = 143;
	points[230] = (-10469.7646, 9946.9688, 3336.6064);
	angles[230] = (0, -180, 0);
	at[230] = 143.5000;
	points[231] = (-10462.2041, 9947.0078, 3336.6064);
	angles[231] = (0, -180, 0);
	at[231] = 144;
	points[232] = (-10462.0869, 9947.0078, 3336.6064);
	angles[232] = (0, -180, 0);
	at[232] = 144.5000;
	points[233] = (-10448.2676, 9947.0869, 3336.6064);
	angles[233] = (0, -180, 0);
	at[233] = 145.5000;
	points[234] = (-10447.0859, 9947.0869, 3336.6064);
	angles[234] = (0, -180, 0);
	at[234] = 146;
	points[235] = (-10439.5273, 9947.1260, 3336.6064);
	angles[235] = (0, -180, 0);
	at[235] = 146.5000;
	points[236] = (-10439.4102, 9947.1260, 3336.6064);
	angles[236] = (0, -180, 0);
	at[236] = 147;
	points[237] = (-10425.5908, 9947.2051, 3336.6064);
	angles[237] = (0, -180, 0);
	at[237] = 148;
	points[238] = (-10424.4092, 9947.2051, 3336.6064);
	angles[238] = (0, -180, 0);
	at[238] = 148.5000;
	points[239] = (-10416.8506, 9947.2441, 3336.6064);
	angles[239] = (0, -180, 0);
	at[239] = 149;
	points[240] = (-10416.7324, 9947.2441, 3336.6064);
	angles[240] = (0, -180, 0);
	at[240] = 149.5000;
	points[241] = (-10402.9141, 9947.3232, 3336.6064);
	angles[241] = (0, -180, 0);
	at[241] = 150.5000;
	points[242] = (-10401.7324, 9947.3232, 3336.6064);
	angles[242] = (0, -180, 0);
	at[242] = 151;
	points[243] = (-10394.1729, 9947.3623, 3336.6064);
	angles[243] = (0, -180, 0);
	at[243] = 151.5000;
	points[244] = (-10397.4414, 9947.3623, 3336.6064);
	angles[244] = (0, -180, 0);
	at[244] = 152.4500;
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
	points[0] = (-9146.2988, 11875.9443, 3336.6143);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-9146.0635, 11868.3857, 3336.6143);
	angles[1] = (0, 90, 0);
	at[1] = 1;
	points[2] = (-9145.8271, 11860.8271, 3336.6143);
	angles[2] = (0, 90, 0);
	at[2] = 1.5000;
	points[3] = (-9145.8271, 11860.8271, 3336.6143);
	angles[3] = (0, 90, 0);
	at[3] = 2;
	points[4] = (-9145.1182, 11838.1895, 3336.6143);
	angles[4] = (0, 90, 0);
	at[4] = 4;
	points[5] = (-9145.1182, 11838.1895, 3336.6143);
	angles[5] = (0, 90, 0);
	at[5] = 4.5000;
	points[6] = (-9144.4102, 11815.5127, 3336.6143);
	angles[6] = (0, 90, 0);
	at[6] = 6.5000;
	points[7] = (-9144.4102, 11815.5127, 3336.6143);
	angles[7] = (0, 90, 0);
	at[7] = 7;
	points[8] = (-9143.7012, 11792.8350, 3336.6143);
	angles[8] = (0, 90, 0);
	at[8] = 9;
	points[9] = (-9143.7012, 11792.8350, 3336.6143);
	angles[9] = (0, 90, 0);
	at[9] = 9.5000;
	points[10] = (-9142.9922, 11770.1973, 3336.6143);
	angles[10] = (0, 90, 0);
	at[10] = 11.5000;
	points[11] = (-9142.9922, 11770.1973, 3336.6143);
	angles[11] = (0, 90, 0);
	at[11] = 12;
	points[12] = (-9142.2842, 11747.5195, 3336.6143);
	angles[12] = (0, 90, 0);
	at[12] = 14;
	points[13] = (-9142.2842, 11747.5195, 3336.6143);
	angles[13] = (0, 90, 0);
	at[13] = 14.5000;
	points[14] = (-9141.5752, 11724.8428, 3336.6143);
	angles[14] = (0, 90, 0);
	at[14] = 16.5000;
	points[15] = (-9141.5752, 11724.8428, 3336.6143);
	angles[15] = (0, 90, 0);
	at[15] = 17;
	points[16] = (-9140.8662, 11702.1650, 3336.6143);
	angles[16] = (0, 90, 0);
	at[16] = 19;
	points[17] = (-9140.8662, 11702.1650, 3336.6143);
	angles[17] = (0, 90, 0);
	at[17] = 19.5000;
	points[18] = (-9140.1973, 11679.5283, 3336.6143);
	angles[18] = (0, 90, 0);
	at[18] = 21.5000;
	points[19] = (-9140.1973, 11679.5283, 3336.6143);
	angles[19] = (0, 90, 0);
	at[19] = 22;
	points[20] = (-9139.4883, 11656.8516, 3336.6143);
	angles[20] = (0, 90, 0);
	at[20] = 24;
	points[21] = (-9139.4883, 11656.8516, 3336.6143);
	angles[21] = (0, 90, 0);
	at[21] = 24.5000;
	points[22] = (-9138.7793, 11634.1729, 3336.6143);
	angles[22] = (0, 90, 0);
	at[22] = 26.5000;
	points[23] = (-9138.7793, 11634.1729, 3336.6143);
	angles[23] = (0, 90, 0);
	at[23] = 27;
	points[24] = (-9138.0703, 11611.5361, 3336.6143);
	angles[24] = (0, 90, 0);
	at[24] = 29;
	points[25] = (-9138.0703, 11611.5361, 3336.6143);
	angles[25] = (0, 90, 0);
	at[25] = 29.5000;
	points[26] = (-9137.3623, 11588.8584, 3336.6143);
	angles[26] = (0, 90, 0);
	at[26] = 31.5000;
	points[27] = (-9137.3623, 11588.8584, 3336.6143);
	angles[27] = (0, 90, 0);
	at[27] = 32;
	points[28] = (-9136.6533, 11566.1816, 3336.6143);
	angles[28] = (0, 90, 0);
	at[28] = 34;
	points[29] = (-9136.6533, 11566.1816, 3336.6143);
	angles[29] = (0, 90, 0);
	at[29] = 34.5000;
	points[30] = (-9135.9443, 11543.5039, 3336.6143);
	angles[30] = (0, 90, 0);
	at[30] = 36.5000;
	points[31] = (-9135.9443, 11543.5039, 3336.6143);
	angles[31] = (0, 90, 0);
	at[31] = 37;
	points[32] = (-9135.2363, 11520.8662, 3336.6143);
	angles[32] = (0, 90, 0);
	at[32] = 39;
	points[33] = (-9135.2363, 11520.8662, 3336.6143);
	angles[33] = (0, 90, 0);
	at[33] = 39.5000;
	points[34] = (-9134.5273, 11498.1885, 3336.6143);
	angles[34] = (0, 90, 0);
	at[34] = 41.5000;
	points[35] = (-9134.5273, 11498.1885, 3336.6143);
	angles[35] = (0, 90, 0);
	at[35] = 42;
	points[36] = (-9133.8184, 11475.5117, 3336.6143);
	angles[36] = (0, 90, 0);
	at[36] = 44;
	points[37] = (-9133.8184, 11475.5117, 3336.6143);
	angles[37] = (0, 90, 0);
	at[37] = 44.5000;
	points[38] = (-9133.1104, 11452.8350, 3336.6143);
	angles[38] = (0, 90, 0);
	at[38] = 46.5000;
	points[39] = (-9133.1104, 11452.8350, 3336.6143);
	angles[39] = (0, 90, 0);
	at[39] = 47;
	points[40] = (-9132.4014, 11430.1973, 3336.6143);
	angles[40] = (0, 90, 0);
	at[40] = 49;
	points[41] = (-9132.4014, 11430.1973, 3336.6143);
	angles[41] = (0, 90, 0);
	at[41] = 49.5000;
	points[42] = (-9131.6934, 11407.5205, 3336.6143);
	angles[42] = (0, 90, 0);
	at[42] = 51.5000;
	points[43] = (-9131.6934, 11407.5205, 3336.6143);
	angles[43] = (0, 90, 0);
	at[43] = 52;
	points[44] = (-9130.9844, 11384.8418, 3336.6143);
	angles[44] = (0, 90, 0);
	at[44] = 54;
	points[45] = (-9130.9844, 11384.8418, 3336.6143);
	angles[45] = (0, 90, 0);
	at[45] = 54.5000;
	points[46] = (-9130.2754, 11362.2051, 3336.6143);
	angles[46] = (0, 90, 0);
	at[46] = 56.5000;
	points[47] = (-9130.2754, 11362.2051, 3336.6143);
	angles[47] = (0, 90, 0);
	at[47] = 57;
	points[48] = (-9129.5674, 11339.5273, 3336.6143);
	angles[48] = (0, 90, 0);
	at[48] = 59;
	points[49] = (-9129.5674, 11339.5273, 3336.6143);
	angles[49] = (0, 90, 0);
	at[49] = 59.5000;
	points[50] = (-9128.8975, 11316.8506, 3336.6143);
	angles[50] = (0, 90, 0);
	at[50] = 61.5000;
	points[51] = (-9128.8975, 11316.8506, 3336.6143);
	angles[51] = (0, 90, 0);
	at[51] = 62;
	points[52] = (-9128.1895, 11294.1738, 3336.6143);
	angles[52] = (0, 90, 0);
	at[52] = 64;
	points[53] = (-9128.1895, 11294.1738, 3336.6143);
	angles[53] = (0, 90, 0);
	at[53] = 64.5000;
	points[54] = (-9127.4805, 11271.5352, 3336.6143);
	angles[54] = (0, 90, 0);
	at[54] = 66.5000;
	points[55] = (-9127.4805, 11271.5352, 3336.6143);
	angles[55] = (0, 90, 0);
	at[55] = 67;
	points[56] = (-9126.7725, 11248.8584, 3336.6143);
	angles[56] = (0, 90, 0);
	at[56] = 69;
	points[57] = (-9126.7725, 11248.8584, 3336.6143);
	angles[57] = (0, 90, 0);
	at[57] = 69.5000;
	points[58] = (-9126.0635, 11226.1807, 3336.6143);
	angles[58] = (0, 90, 0);
	at[58] = 71.5000;
	points[59] = (-9126.0635, 11226.1807, 3336.6143);
	angles[59] = (0, 90, 0);
	at[59] = 72;
	points[60] = (-9125.3545, 11203.5439, 3336.6143);
	angles[60] = (0, 90, 0);
	at[60] = 74;
	points[61] = (-9125.3545, 11203.5439, 3336.6143);
	angles[61] = (0, 90, 0);
	at[61] = 74.5000;
	points[62] = (-9124.6465, 11180.8662, 3336.6143);
	angles[62] = (0, 90, 0);
	at[62] = 76.5000;
	points[63] = (-9124.6465, 11180.8662, 3336.6143);
	angles[63] = (0, 90, 0);
	at[63] = 77;
	points[64] = (-9124.4092, 11173.3076, 3336.6143);
	angles[64] = (0, 90, 0);
	at[64] = 77.5000;
	points[65] = (-9124.2920, 11170, 3336.6143);
	angles[65] = (0, 90, 0);
	at[65] = 78;
	points[66] = (-9124.3701, 11171.5352, 3336.6143);
	angles[66] = (0, 90, 0);
	at[66] = 78.5000;
	points[67] = (-9124.5674, 11179.0947, 3336.6143);
	angles[67] = (0, 90, 0);
	at[67] = 79;
	points[68] = (-9124.5674, 11179.0947, 3336.6143);
	angles[68] = (0, 90, 0);
	at[68] = 79.5000;
	points[69] = (-9125.2754, 11201.7715, 3336.6143);
	angles[69] = (0, 90, 0);
	at[69] = 81.5000;
	points[70] = (-9125.2754, 11201.7715, 3336.6143);
	angles[70] = (0, 90, 0);
	at[70] = 82;
	points[71] = (-9125.9844, 11224.4102, 3336.6143);
	angles[71] = (0, 90, 0);
	at[71] = 84;
	points[72] = (-9125.9844, 11224.4102, 3336.6143);
	angles[72] = (0, 90, 0);
	at[72] = 84.5000;
	points[73] = (-9126.6924, 11247.0869, 3336.6143);
	angles[73] = (0, 90, 0);
	at[73] = 86.5000;
	points[74] = (-9126.6924, 11247.0869, 3336.6143);
	angles[74] = (0, 90, 0);
	at[74] = 87;
	points[75] = (-9127.4014, 11269.7646, 3336.6143);
	angles[75] = (0, 90, 0);
	at[75] = 89;
	points[76] = (-9127.4014, 11269.7646, 3336.6143);
	angles[76] = (0, 90, 0);
	at[76] = 89.5000;
	points[77] = (-9128.1104, 11292.4014, 3336.6143);
	angles[77] = (0, 90, 0);
	at[77] = 91.5000;
	points[78] = (-9128.1104, 11292.4014, 3336.6143);
	angles[78] = (0, 90, 0);
	at[78] = 92;
	points[79] = (-9128.8184, 11315.0791, 3336.6143);
	angles[79] = (0, 90, 0);
	at[79] = 94;
	points[80] = (-9128.8184, 11315.0791, 3336.6143);
	angles[80] = (0, 90, 0);
	at[80] = 94.5000;
	points[81] = (-9129.5273, 11337.7559, 3336.6143);
	angles[81] = (0, 90, 0);
	at[81] = 96.5000;
	points[82] = (-9129.5273, 11337.7559, 3336.6143);
	angles[82] = (0, 90, 0);
	at[82] = 97;
	points[83] = (-9130.2363, 11360.4326, 3336.6143);
	angles[83] = (0, 90, 0);
	at[83] = 99;
	points[84] = (-9130.2363, 11360.4326, 3336.6143);
	angles[84] = (0, 90, 0);
	at[84] = 99.5000;
	points[85] = (-9130.9443, 11383.0713, 3336.6143);
	angles[85] = (0, 90, 0);
	at[85] = 101.5000;
	points[86] = (-9130.9443, 11383.0713, 3336.6143);
	angles[86] = (0, 90, 0);
	at[86] = 102;
	points[87] = (-9131.6533, 11405.7480, 3336.6143);
	angles[87] = (0, 90, 0);
	at[87] = 104;
	points[88] = (-9131.6533, 11405.7480, 3336.6143);
	angles[88] = (0, 90, 0);
	at[88] = 104.5000;
	points[89] = (-9132.3623, 11428.4258, 3336.6143);
	angles[89] = (0, 90, 0);
	at[89] = 106.5000;
	points[90] = (-9132.3623, 11428.4258, 3336.6143);
	angles[90] = (0, 90, 0);
	at[90] = 107;
	points[91] = (-9133.0713, 11451.1025, 3336.6143);
	angles[91] = (0, 90, 0);
	at[91] = 109;
	points[92] = (-9133.0713, 11451.1025, 3336.6143);
	angles[92] = (0, 90, 0);
	at[92] = 109.5000;
	points[93] = (-9133.7793, 11473.7412, 3336.6143);
	angles[93] = (0, 90, 0);
	at[93] = 111.5000;
	points[94] = (-9133.7793, 11473.7412, 3336.6143);
	angles[94] = (0, 90, 0);
	at[94] = 112;
	points[95] = (-9134.4883, 11496.4180, 3336.6143);
	angles[95] = (0, 90, 0);
	at[95] = 114;
	points[96] = (-9134.4883, 11496.4180, 3336.6143);
	angles[96] = (0, 90, 0);
	at[96] = 114.5000;
	points[97] = (-9135.1973, 11519.0947, 3336.6143);
	angles[97] = (0, 90, 0);
	at[97] = 116.5000;
	points[98] = (-9135.1973, 11519.0947, 3336.6143);
	angles[98] = (0, 90, 0);
	at[98] = 117;
	points[99] = (-9135.9053, 11541.7324, 3336.6143);
	angles[99] = (0, 90, 0);
	at[99] = 119;
	points[100] = (-9135.9053, 11541.7324, 3336.6143);
	angles[100] = (0, 90, 0);
	at[100] = 119.5000;
	points[101] = (-9136.5752, 11564.4092, 3336.6143);
	angles[101] = (0, 90, 0);
	at[101] = 121.5000;
	points[102] = (-9136.5752, 11564.4092, 3336.6143);
	angles[102] = (0, 90, 0);
	at[102] = 122;
	points[103] = (-9137.2842, 11587.0869, 3336.6143);
	angles[103] = (0, 90, 0);
	at[103] = 124;
	points[104] = (-9137.2842, 11587.0869, 3336.6143);
	angles[104] = (0, 90, 0);
	at[104] = 124.5000;
	points[105] = (-9137.9922, 11609.7637, 3336.6143);
	angles[105] = (0, 90, 0);
	at[105] = 126.5000;
	points[106] = (-9137.9922, 11609.7637, 3336.6143);
	angles[106] = (0, 90, 0);
	at[106] = 127;
	points[107] = (-9138.2285, 11617.2842, 3336.6143);
	angles[107] = (0, 90, 0);
	at[107] = 127.5000;
	points[108] = (-9138.4648, 11624.8428, 3336.6143);
	angles[108] = (0, 90, 0);
	at[108] = 128.5000;
	points[109] = (-9138.7012, 11632.4023, 3336.6143);
	angles[109] = (0, 90, 0);
	at[109] = 129;
	points[110] = (-9138.7012, 11632.4023, 3336.6143);
	angles[110] = (0, 90, 0);
	at[110] = 129.5000;
	points[111] = (-9139.4102, 11655.0791, 3336.6143);
	angles[111] = (0, 90, 0);
	at[111] = 131.5000;
	points[112] = (-9139.4102, 11655.0791, 3336.6143);
	angles[112] = (0, 90, 0);
	at[112] = 132;
	points[113] = (-9140.1182, 11677.7559, 3336.6143);
	angles[113] = (0, 90, 0);
	at[113] = 134;
	points[114] = (-9140.1182, 11677.7559, 3336.6143);
	angles[114] = (0, 90, 0);
	at[114] = 134.5000;
	points[115] = (-9140.8271, 11700.3936, 3336.6143);
	angles[115] = (0, 90, 0);
	at[115] = 136.5000;
	points[116] = (-9140.8271, 11700.3936, 3336.6143);
	angles[116] = (0, 90, 0);
	at[116] = 137;
	points[117] = (-9141.5361, 11723.0703, 3336.6143);
	angles[117] = (0, 90, 0);
	at[117] = 139;
	points[118] = (-9141.5361, 11723.0703, 3336.6143);
	angles[118] = (0, 90, 0);
	at[118] = 139.5000;
	points[119] = (-9142.2441, 11745.7490, 3336.6143);
	angles[119] = (0, 90, 0);
	at[119] = 141.5000;
	points[120] = (-9142.2441, 11745.7490, 3336.6143);
	angles[120] = (0, 90, 0);
	at[120] = 142;
	points[121] = (-9142.9531, 11768.4258, 3336.6143);
	angles[121] = (0, 90, 0);
	at[121] = 144;
	points[122] = (-9142.9531, 11768.4258, 3336.6143);
	angles[122] = (0, 90, 0);
	at[122] = 144.5000;
	points[123] = (-9143.6611, 11791.0635, 3336.6143);
	angles[123] = (0, 90, 0);
	at[123] = 146.5000;
	points[124] = (-9143.6611, 11791.0635, 3336.6143);
	angles[124] = (0, 90, 0);
	at[124] = 147;
	points[125] = (-9144.3701, 11813.7402, 3336.6143);
	angles[125] = (0, 90, 0);
	at[125] = 149;
	points[126] = (-9144.3701, 11813.7402, 3336.6143);
	angles[126] = (0, 90, 0);
	at[126] = 149.5000;
	points[127] = (-9145.0791, 11836.4170, 3336.6143);
	angles[127] = (0, 90, 0);
	at[127] = 151.5000;
	points[128] = (-9145.0791, 11836.4170, 3336.6143);
	angles[128] = (0, 90, 0);
	at[128] = 152;
	points[129] = (-9145.7871, 11859.0557, 3336.6143);
	angles[129] = (0, 90, 0);
	at[129] = 154;
	points[130] = (-9145.7871, 11859.0557, 3336.6143);
	angles[130] = (0, 90, 0);
	at[130] = 154.5000;
	points[131] = (-9146.4961, 11881.7324, 3336.6143);
	angles[131] = (0, 90, 0);
	at[131] = 156.5000;
	points[132] = (-9146.5361, 11883.5039, 3336.6143);
	angles[132] = (0, 90, 0);
	at[132] = 157.5000;
	points[133] = (-9146.2988, 11875.9443, 3336.6143);
	angles[133] = (0, 90, 0);
	at[133] = 158.2500;
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
