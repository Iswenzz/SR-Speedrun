main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_bansheeboardw_b", 0);

	setExpFog(2362.2048, 12881.3975, 0.1137, 0, 0.2510, 0);

	level.iz_cue = [];
	level.iz_cue["iz_cue_boost"] = true;
	level.iz_cue["iz_cue_bounce"] = true;
	level.iz_cue["iz_cue_cannon"] = true;
	level.iz_cue["iz_cue_finish"] = true;
	level.iz_cue["iz_cue_item"] = true;
	level.iz_cue["iz_cue_jump"] = true;
	thread iz_sounds();

	thread iz_course();

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
	ambientPlay("iz_0_n64bb", 2);
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
	level.iz_route[level.iz_route.size] = (12085, 7173, 6809);
	level.iz_route[level.iz_route.size] = (12074, 7842, 6809);
	level.iz_route[level.iz_route.size] = (12016, 8777, 6809);
	level.iz_route[level.iz_route.size] = (11387, 9080, 6809);
	level.iz_route[level.iz_route.size] = (10430, 8954, 6809);
	level.iz_route[level.iz_route.size] = (9352, 8804, 6809);
	level.iz_route[level.iz_route.size] = (8303, 8833, 6809);
	level.iz_route[level.iz_route.size] = (7592, 8689, 6809);
	level.iz_route[level.iz_route.size] = (7489, 8119, 6809);
	level.iz_route[level.iz_route.size] = (7908, 7701, 6809);
	level.iz_route[level.iz_route.size] = (7882, 7222, 6809);
	level.iz_route[level.iz_route.size] = (7452, 6892, 6809);
	level.iz_route[level.iz_route.size] = (7827, 6407, 6809);
	level.iz_route[level.iz_route.size] = (7454, 6023, 6809);
	level.iz_route[level.iz_route.size] = (6752, 6012, 6809);
	level.iz_route[level.iz_route.size] = (6247, 6261, 6809);
	level.iz_route[level.iz_route.size] = (6227, 6829, 6809);
	level.iz_route[level.iz_route.size] = (6300, 7187, 6809);
	level.iz_route[level.iz_route.size] = (6217, 7520, 6809);
	level.iz_route[level.iz_route.size] = (5989, 7851, 6809);
	level.iz_route[level.iz_route.size] = (6026, 8320, 6809);
	level.iz_route[level.iz_route.size] = (6279, 8569, 6809);
	level.iz_route[level.iz_route.size] = (6097, 8800, 6809);
	level.iz_route[level.iz_route.size] = (5539, 8847, 6809);
	level.iz_route[level.iz_route.size] = (5446, 8344, 6809);
	level.iz_route[level.iz_route.size] = (5488, 7788, 6809);
	level.iz_route[level.iz_route.size] = (5394, 7374, 6809);
	level.iz_route[level.iz_route.size] = (4984, 7223, 6809);
	level.iz_route[level.iz_route.size] = (4819, 7822, 6809);
	level.iz_route[level.iz_route.size] = (4710, 8411, 6809);
	level.iz_route[level.iz_route.size] = (4504, 8709, 6809);
	level.iz_route[level.iz_route.size] = (3912, 8834, 6809);
	level.iz_route[level.iz_route.size] = (3355, 8814, 6809);
	level.iz_route[level.iz_route.size] = (3194, 8366, 6809);
	level.iz_route[level.iz_route.size] = (3102, 7819, 6809);
	level.iz_route[level.iz_route.size] = (2852, 7425, 6809);
	level.iz_route[level.iz_route.size] = (2162, 7359, 6809);
	level.iz_route[level.iz_route.size] = (1623, 7618, 6809);
	level.iz_route[level.iz_route.size] = (1448, 8128, 6809);
	level.iz_route[level.iz_route.size] = (1442, 8518, 6809);
	level.iz_route[level.iz_route.size] = (1549, 8843, 6809);
	level.iz_route[level.iz_route.size] = (2103, 9063, 6809);
	level.iz_route[level.iz_route.size] = (2649, 9049, 6809);
	level.iz_route[level.iz_route.size] = (4027, 8590, 6809);
	level.iz_route[level.iz_route.size] = (4346, 8138, 6809);
	level.iz_route[level.iz_route.size] = (4636, 7385, 6809);
	level.iz_route[level.iz_route.size] = (4902, 6698, 6809);
	level.iz_route[level.iz_route.size] = (5634, 6252, 6809);
	level.iz_route[level.iz_route.size] = (6366, 5761, 6809);
	level.iz_route[level.iz_route.size] = (7291, 5708, 6809);
	level.iz_route[level.iz_route.size] = (8215, 5822, 6809);
	level.iz_route[level.iz_route.size] = (9198, 5692, 6809);
	level.iz_route[level.iz_route.size] = (9649, 6078, 6809);
	level.iz_route[level.iz_route.size] = (9831, 6571, 6809);
	level.iz_route[level.iz_route.size] = (10415, 7026, 6809);
	level.iz_route[level.iz_route.size] = (11084, 7024, 6809);
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
	points[0] = (4039.8425, 6158.1890, 6820.8662);
	angles[0] = (0, -88.4974, 0);
	at[0] = 0;
	points[1] = (4130.3545, 6160.6299, 6820.8662);
	angles[1] = (0, -88.4105, 0);
	at[1] = 0.1000;
	points[2] = (4282.4409, 6164.9604, 6820.8662);
	angles[2] = (0, -88.3279, 0);
	at[2] = 0.2500;
	points[3] = (4424.4487, 6169.1733, 6820.8662);
	angles[3] = (0, -88.2856, 0);
	at[3] = 0.4000;
	points[4] = (4574.4883, 6173.7007, 6820.8662);
	angles[4] = (0, -88.2600, 0);
	at[4] = 0.5500;
	points[5] = (4718.4253, 6178.1104, 6820.8662);
	angles[5] = (0, -88.2474, 0);
	at[5] = 0.7000;
	points[6] = (4867.6377, 6182.6768, 6820.8662);
	angles[6] = (0, -88.2433, 0);
	at[6] = 0.8500;
	points[7] = (5697.9922, 6207.6377, 6820.8662);
	angles[7] = (0, -88.3498, 0);
	at[7] = 1.7000;
	points[8] = (5842.0869, 6211.7324, 6820.8662);
	angles[8] = (0, -88.3968, 0);
	at[8] = 1.8500;
	points[9] = (5992.0083, 6215.8662, 6820.8662);
	angles[9] = (0, -88.4623, 0);
	at[9] = 2;
	points[10] = (6134.8823, 6219.5674, 6820.8662);
	angles[10] = (0, -88.5486, 0);
	at[10] = 2.1500;
	points[11] = (6286.1816, 6223.2676, 6820.8662);
	angles[11] = (0, -88.6823, 0);
	at[11] = 2.3000;
	points[12] = (6428.9766, 6226.2993, 6820.8662);
	angles[12] = (0, -88.8872, 0);
	at[12] = 2.4500;
	points[13] = (6531.4170, 6228.0708, 6820.8662);
	angles[13] = (0, -89.1395, 0);
	at[13] = 2.5500;
	points[14] = (6625.3154, 6229.1729, 6820.8662);
	angles[14] = (0, -89.5787, 0);
	at[14] = 2.6500;
	points[15] = (6679.6455, 6229.3701, 6820.8662);
	angles[15] = (0, -90.1022, 0);
	at[15] = 2.7000;
	points[16] = (6768.1494, 6227.2837, 6820.8662);
	angles[16] = (0, -93.3433, 0);
	at[16] = 2.8000;
	points[17] = (6815.8662, 6223.3862, 6820.8662);
	angles[17] = (0, -96.0492, 0);
	at[17] = 2.8500;
	points[18] = (6913.1890, 6207.5200, 6820.8662);
	angles[18] = (0, -102.9045, 0);
	at[18] = 2.9500;
	points[19] = (6959.9609, 6194.7637, 6820.8662);
	angles[19] = (0, -107.8679, 0);
	at[19] = 3;
	points[20] = (7005.3545, 6176.7324, 6820.8662);
	angles[20] = (0, -116.5019, 0);
	at[20] = 3.0500;
	points[21] = (7043.6611, 6147.4014, 6820.8662);
	angles[21] = (0, -148.1965, 0);
	at[21] = 3.1000;
	points[22] = (7025.2759, 6110.2363, 6820.8662);
	angles[22] = (0, -243.8654, 0);
	at[22] = 3.1500;
	points[23] = (6978.0317, 6096.0239, 6820.8662);
	angles[23] = (0, -259.1817, 0);
	at[23] = 3.2000;
	points[24] = (6932.1265, 6089.6851, 6820.8662);
	angles[24] = (0, -264.5046, 0);
	at[24] = 3.2500;
	points[25] = (6888.5039, 6086.6143, 6820.8662);
	angles[25] = (0, -267.0892, 0);
	at[25] = 3.3000;
	points[26] = (6842.8745, 6084.6851, 6820.8662);
	angles[26] = (0, -267.9081, 0);
	at[26] = 3.3500;
	points[27] = (6784.4883, 6082.8345, 6820.8662);
	angles[27] = (0, -268.3699, 0);
	at[27] = 3.4000;
	points[28] = (6695.1182, 6080.5908, 6820.8662);
	angles[28] = (0, -268.7228, 0);
	at[28] = 3.5000;
	points[29] = (6591.2207, 6078.5039, 6820.8662);
	angles[29] = (0, -268.9458, 0);
	at[29] = 3.6000;
	points[30] = (6449.4883, 6076.1021, 6820.8662);
	angles[30] = (0, -269.1244, 0);
	at[30] = 3.7500;
	points[31] = (6296.6533, 6073.9370, 6820.8662);
	angles[31] = (0, -269.2441, 0);
	at[31] = 3.9000;
	points[32] = (6155.1182, 6072.1655, 6820.8662);
	angles[32] = (0, -269.3203, 0);
	at[32] = 4.0500;
	points[33] = (5956.2202, 6069.9609, 6820.8662);
	angles[33] = (0, -269.3948, 0);
	at[33] = 4.2500;
	points[34] = (5811.9683, 6068.5039, 6820.8662);
	angles[34] = (0, -269.4341, 0);
	at[34] = 4.4000;
	points[35] = (4931.8506, 6060.7876, 6820.8662);
	angles[35] = (0, -269.5298, 0);
	at[35] = 5.3000;
	points[36] = (4733.8584, 6059.1733, 6820.8662);
	angles[36] = (0, -269.5253, 0);
	at[36] = 5.5000;
	points[37] = (4590.3149, 6057.9526, 6820.8662);
	angles[37] = (0, -269.5144, 0);
	at[37] = 5.6500;
	points[38] = (4390.7876, 6056.2207, 6820.8662);
	angles[38] = (0, -269.4836, 0);
	at[38] = 5.8500;
	points[39] = (4248.5039, 6054.8823, 6820.8662);
	angles[39] = (0, -269.4435, 0);
	at[39] = 6;
	points[40] = (4145.1577, 6053.8584, 6820.8662);
	angles[40] = (0, -269.3973, 0);
	at[40] = 6.1000;
	points[41] = (4051.1418, 6052.7954, 6820.8662);
	angles[41] = (0, -269.3326, 0);
	at[41] = 6.2000;
	points[42] = (4039.8425, 6158.1890, 6820.8662);
	angles[42] = (0, -448.4974, 0);
	at[42] = 6.2500;
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
