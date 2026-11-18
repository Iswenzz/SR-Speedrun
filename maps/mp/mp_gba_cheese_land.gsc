main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_cheese_land", 0);

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
	ambientPlay("iz_0_42", 2);
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
	level.iz_route[level.iz_route.size] = (-9177, -2738, 1655);
	level.iz_route[level.iz_route.size] = (-9129, -4493, 1655);
	level.iz_route[level.iz_route.size] = (-8910, -5070, 1655);
	level.iz_route[level.iz_route.size] = (-8363, -5593, 1655);
	level.iz_route[level.iz_route.size] = (-7731, -5831, 1655);
	level.iz_route[level.iz_route.size] = (-6883, -5760, 1655);
	level.iz_route[level.iz_route.size] = (-6310, -5367, 1655);
	level.iz_route[level.iz_route.size] = (-5981, -4774, 1655);
	level.iz_route[level.iz_route.size] = (-5873, -4179, 1655);
	level.iz_route[level.iz_route.size] = (-5838, -3668, 1655);
	level.iz_route[level.iz_route.size] = (-5738, -3222, 1655);
	level.iz_route[level.iz_route.size] = (-5398, -2750, 1655);
	level.iz_route[level.iz_route.size] = (-4769, -2455, 1655);
	level.iz_route[level.iz_route.size] = (-3963, -2313, 1655);
	level.iz_route[level.iz_route.size] = (-3319, -2036, 1655);
	level.iz_route[level.iz_route.size] = (-2850, -1514, 1655);
	level.iz_route[level.iz_route.size] = (-2609, -872, 1655);
	level.iz_route[level.iz_route.size] = (-2557, -185, 1655);
	level.iz_route[level.iz_route.size] = (-2477, 735, 1655);
	level.iz_route[level.iz_route.size] = (-2238, 1434, 1655);
	level.iz_route[level.iz_route.size] = (-1685, 1988, 1655);
	level.iz_route[level.iz_route.size] = (-1139, 2333, 1655);
	level.iz_route[level.iz_route.size] = (-176, 2599, 1655);
	level.iz_route[level.iz_route.size] = (620, 2707, 1655);
	level.iz_route[level.iz_route.size] = (1417, 2953, 1655);
	level.iz_route[level.iz_route.size] = (2413, 3248, 1655);
	level.iz_route[level.iz_route.size] = (3375, 3211, 1655);
	level.iz_route[level.iz_route.size] = (4055, 2776, 1655);
	level.iz_route[level.iz_route.size] = (4903, 2683, 1655);
	level.iz_route[level.iz_route.size] = (5723, 2395, 1655);
	level.iz_route[level.iz_route.size] = (6260, 1745, 1655);
	level.iz_route[level.iz_route.size] = (6260, 859, 1655);
	level.iz_route[level.iz_route.size] = (6260, -251, 1655);
	level.iz_route[level.iz_route.size] = (6260, -1312, 1655);
	level.iz_route[level.iz_route.size] = (6260, -2295, 1655);
	level.iz_route[level.iz_route.size] = (6260, -3243, 1655);
	level.iz_route[level.iz_route.size] = (6260, -4037, 1655);
	level.iz_route[level.iz_route.size] = (6260, -4849, 1655);
	level.iz_route[level.iz_route.size] = (6397, -6046, 1655);
	level.iz_route[level.iz_route.size] = (6824, -6641, 1655);
	level.iz_route[level.iz_route.size] = (7612, -6957, 1655);
	level.iz_route[level.iz_route.size] = (8347, -6931, 1655);
	level.iz_route[level.iz_route.size] = (9374, -6704, 1655);
	level.iz_route[level.iz_route.size] = (9989, -6059, 1655);
	level.iz_route[level.iz_route.size] = (10232, -5399, 1655);
	level.iz_route[level.iz_route.size] = (10209, -4763, 1655);
	level.iz_route[level.iz_route.size] = (10118, -4115, 1655);
	level.iz_route[level.iz_route.size] = (9765, -3534, 1655);
	level.iz_route[level.iz_route.size] = (9222, -3213, 1655);
	level.iz_route[level.iz_route.size] = (8687, -3078, 1655);
	level.iz_route[level.iz_route.size] = (8202, -3052, 1772);
	level.iz_route[level.iz_route.size] = (7675, -3032, 1860);
	level.iz_route[level.iz_route.size] = (7121, -3021, 1919);
	level.iz_route[level.iz_route.size] = (5167, -2993, 1919);
	level.iz_route[level.iz_route.size] = (3548, -2906, 1655);
	level.iz_route[level.iz_route.size] = (3027, -2657, 1655);
	level.iz_route[level.iz_route.size] = (2660, -2244, 1655);
	level.iz_route[level.iz_route.size] = (2431, -1686, 1655);
	level.iz_route[level.iz_route.size] = (2431, -1010, 1655);
	level.iz_route[level.iz_route.size] = (2666, -564, 1655);
	level.iz_route[level.iz_route.size] = (3043, -185, 1655);
	level.iz_route[level.iz_route.size] = (3744, -1, 1655);
	level.iz_route[level.iz_route.size] = (4500, 43, 1860);
	level.iz_route[level.iz_route.size] = (5317, 76, 1919);
	level.iz_route[level.iz_route.size] = (6969, 75, 1919);
	level.iz_route[level.iz_route.size] = (8954, 117, 1655);
	level.iz_route[level.iz_route.size] = (9393, 334, 1655);
	level.iz_route[level.iz_route.size] = (9887, 894, 1655);
	level.iz_route[level.iz_route.size] = (10058, 1530, 1655);
	level.iz_route[level.iz_route.size] = (9939, 2208, 1655);
	level.iz_route[level.iz_route.size] = (9504, 2917, 1655);
	level.iz_route[level.iz_route.size] = (9014, 3422, 1680);
	level.iz_route[level.iz_route.size] = (8315, 3908, 1655);
	level.iz_route[level.iz_route.size] = (7843, 4417, 1655);
	level.iz_route[level.iz_route.size] = (7693, 5059, 1655);
	level.iz_route[level.iz_route.size] = (7316, 5728, 1655);
	level.iz_route[level.iz_route.size] = (6689, 6041, 1655);
	level.iz_route[level.iz_route.size] = (5602, 6167, 1655);
	level.iz_route[level.iz_route.size] = (4327, 5958, 1655);
	level.iz_route[level.iz_route.size] = (3136, 5602, 1655);
	level.iz_route[level.iz_route.size] = (2153, 5268, 1655);
	level.iz_route[level.iz_route.size] = (1129, 4996, 1655);
	level.iz_route[level.iz_route.size] = (84, 4808, 1655);
	level.iz_route[level.iz_route.size] = (-878, 4808, 1655);
	level.iz_route[level.iz_route.size] = (-1825, 4893, 1655);
	level.iz_route[level.iz_route.size] = (-2613, 5351, 1655);
	level.iz_route[level.iz_route.size] = (-3219, 5916, 1655);
	level.iz_route[level.iz_route.size] = (-3679, 6438, 1655);
	level.iz_route[level.iz_route.size] = (-4264, 7149, 1655);
	level.iz_route[level.iz_route.size] = (-4871, 7421, 1655);
	level.iz_route[level.iz_route.size] = (-5519, 7254, 1655);
	level.iz_route[level.iz_route.size] = (-6148, 6656, 1655);
	level.iz_route[level.iz_route.size] = (-6777, 6044, 1655);
	level.iz_route[level.iz_route.size] = (-7372, 5478, 1655);
	level.iz_route[level.iz_route.size] = (-8034, 4854, 1656);
	level.iz_route[level.iz_route.size] = (-8695, 4218, 1655);
	level.iz_route[level.iz_route.size] = (-9114, 3386, 1655);
	level.iz_route[level.iz_route.size] = (-9156, 2718, 1655);
	level.iz_route[level.iz_route.size] = (-9010, 1965, 1655);
	level.iz_route[level.iz_route.size] = (-8592, 1359, 1655);
	level.iz_route[level.iz_route.size] = (-8571, 669, 1655);
	level.iz_route[level.iz_route.size] = (-8947, -21, 1655);
	level.iz_route[level.iz_route.size] = (-9114, -690, 1655);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (8828.3076, 3794.1497, 1654.9725);
	angles[0] = (0, 24.4052, 0);
	at[0] = 0;
	points[1] = (8736.2988, 3985.7874, 1654.9725);
	angles[1] = (0, 25.6502, 0);
	at[1] = 1;
	points[2] = (8726.8896, 4000.5513, 1654.9725);
	angles[2] = (0, 35.0700, 0);
	at[2] = 1.1000;
	points[3] = (8719.3701, 4008.0710, 1654.9725);
	angles[3] = (0, 42.4291, 0);
	at[3] = 1.2000;
	points[4] = (8704.3311, 4023.0708, 1654.9725);
	angles[4] = (0, 44.8692, 0);
	at[4] = 1.4000;
	points[5] = (8471.1025, 4255.9053, 1654.9725);
	angles[5] = (0, 45.0493, 0);
	at[5] = 4.5000;
	points[6] = (8463.1494, 4261.4175, 1654.9725);
	angles[6] = (0, 66.4742, 0);
	at[6] = 4.6000;
	points[7] = (8453.1504, 4257.8350, 1654.9725);
	angles[7] = (0, 98.0878, 0);
	at[7] = 4.7000;
	points[8] = (8443.1494, 4254.2124, 1654.9725);
	angles[8] = (0, 106.7223, 0);
	at[8] = 4.8000;
	points[9] = (8433.1494, 4250.6299, 1654.9725);
	angles[9] = (0, 108.9922, 0);
	at[9] = 4.9000;
	points[10] = (8103.1104, 4131.8110, 1654.9725);
	angles[10] = (0, 109.7989, 0);
	at[10] = 8.2000;
	points[11] = (8095.3940, 4126.9292, 1654.9725);
	angles[11] = (0, 135.3466, 0);
	at[11] = 8.3000;
	points[12] = (8097.5986, 4116.5352, 1654.9725);
	angles[12] = (0, 176.3920, 0);
	at[12] = 8.4000;
	points[13] = (8099.8423, 4106.1416, 1654.9725);
	angles[13] = (0, 187.9623, 0);
	at[13] = 8.5000;
	points[14] = (8102.0479, 4095.7480, 1654.9725);
	angles[14] = (0, 191.0111, 0);
	at[14] = 8.6000;
	points[15] = (8182.2441, 3721.5671, 1654.9725);
	angles[15] = (0, 192.0948, 0);
	at[15] = 12.2000;
	points[16] = (8186.2998, 3709.9922, 1654.9725);
	angles[16] = (0, 198.2764, 0);
	at[16] = 12.3000;
	points[17] = (8196.7324, 3691.4646, 1654.9725);
	angles[17] = (0, 206.4472, 0);
	at[17] = 12.4000;
	points[18] = (8207.1260, 3672.9333, 1654.9725);
	angles[18] = (0, 208.5948, 0);
	at[18] = 12.5000;
	points[19] = (8311.3779, 3487.6377, 1654.9725);
	angles[19] = (0, 209.3578, 0);
	at[19] = 13.5000;
	points[20] = (8323.2285, 3476.9016, 1654.9725);
	angles[20] = (0, 234.2773, 0);
	at[20] = 13.6000;
	points[21] = (8333.7793, 3475.5198, 1654.9725);
	angles[21] = (0, 255.0242, 0);
	at[21] = 13.7000;
	points[22] = (8344.3311, 3474.1338, 1654.9725);
	angles[22] = (0, 260.5563, 0);
	at[22] = 13.8000;
	points[23] = (8354.8428, 3472.7520, 1654.9725);
	angles[23] = (0, 262.0081, 0);
	at[23] = 13.9000;
	points[24] = (8534.0166, 3449.2402, 1654.9725);
	angles[24] = (0, 262.5241, 0);
	at[24] = 15.6000;
	points[25] = (8543.8584, 3451.6023, 1654.9725);
	angles[25] = (0, 283.5680, 0);
	at[25] = 15.7000;
	points[26] = (8553.1895, 3456.6970, 1654.9725);
	angles[26] = (0, 294.6771, 0);
	at[26] = 15.8000;
	points[27] = (8562.5205, 3461.7954, 1654.9725);
	angles[27] = (0, 297.6032, 0);
	at[27] = 15.9000;
	points[28] = (8767.7559, 3573.8938, 1654.9725);
	angles[28] = (0, 298.6432, 0);
	at[28] = 18.1000;
	points[29] = (8772.6377, 3583.3032, 1654.9725);
	angles[29] = (0, 323.8433, 0);
	at[29] = 18.2000;
	points[30] = (8777.4805, 3592.7756, 1654.9725);
	angles[30] = (0, 330.6198, 0);
	at[30] = 18.3000;
	points[31] = (8849.7637, 3734.8857, 1654.9725);
	angles[31] = (0, 333.0316, 0);
	at[31] = 19.8000;
	points[32] = (8851.3389, 3746.2363, 1654.9725);
	angles[32] = (0, 350.9911, 0);
	at[32] = 19.9000;
	points[33] = (8842.1260, 3765.4016, 1654.9725);
	angles[33] = (0, 376.3868, 0);
	at[33] = 20;
	points[34] = (8828.3076, 3794.1497, 1654.9725);
	angles[34] = (0, 384.4052, 0);
	at[34] = 20.1500;
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
	points[0] = (4595, 5875.2754, 1654.9725);
	angles[0] = (0, -164.2726, 0);
	at[0] = 0;
	points[1] = (4641.2207, 5733.8193, 1654.9725);
	angles[1] = (0, -161.9031, 0);
	at[1] = 0.7000;
	points[2] = (4647.3623, 5721.1421, 1654.9725);
	angles[2] = (0, -151.5966, 0);
	at[2] = 0.8000;
	points[3] = (4653.2285, 5712.2832, 1654.9725);
	angles[3] = (0, -147.8710, 0);
	at[3] = 0.9000;
	points[4] = (4664.9214, 5694.5669, 1654.9725);
	angles[4] = (0, -146.6376, 0);
	at[4] = 1.1000;
	points[5] = (4805.5513, 5481.6929, 1654.9725);
	angles[5] = (0, -146.5467, 0);
	at[5] = 3.5000;
	points[6] = (4812.8350, 5476.1416, 1654.9725);
	angles[6] = (0, -124.6438, 0);
	at[6] = 3.6000;
	points[7] = (4823.3071, 5477.9927, 1654.9725);
	angles[7] = (0, -92.0858, 0);
	at[7] = 3.7000;
	points[8] = (4833.7798, 5479.8428, 1654.9725);
	angles[8] = (0, -83.1698, 0);
	at[8] = 3.8000;
	points[9] = (4844.2520, 5481.6929, 1654.9725);
	angles[9] = (0, -80.8251, 0);
	at[9] = 3.9000;
	points[10] = (5304.8423, 5562.9526, 1654.9725);
	angles[10] = (0, -79.9921, 0);
	at[10] = 8.3000;
	points[11] = (5313.4253, 5566.8501, 1654.9725);
	angles[11] = (0, -58.3575, 0);
	at[11] = 8.4000;
	points[12] = (5316.0630, 5577.1655, 1654.9725);
	angles[12] = (0, -26.3331, 0);
	at[12] = 8.5000;
	points[13] = (5318.7397, 5587.4414, 1654.9725);
	angles[13] = (0, -17.5762, 0);
	at[13] = 8.6000;
	points[14] = (5321.3779, 5597.7559, 1654.9725);
	angles[14] = (0, -15.2739, 0);
	at[14] = 8.7000;
	points[15] = (5369.1343, 5783.0317, 1654.9725);
	angles[15] = (0, -14.4558, 0);
	at[15] = 10.5000;
	points[16] = (5371.8110, 5793.3071, 1654.9725);
	angles[16] = (0, -10.1672, 0);
	at[16] = 10.6000;
	points[17] = (5369.1343, 5814.4097, 1654.9725);
	angles[17] = (0, 2.6529, 0);
	at[17] = 10.7000;
	points[18] = (5366.4565, 5835.5117, 1654.9725);
	angles[18] = (0, 6.0352, 0);
	at[18] = 10.8000;
	points[19] = (5328.9370, 6130.7480, 1654.9725);
	angles[19] = (0, 7.2374, 0);
	at[19] = 12.2000;
	points[20] = (5323.5039, 6147.0469, 1654.9725);
	angles[20] = (0, 21.2383, 0);
	at[20] = 12.3000;
	points[21] = (5317.2441, 6155.6299, 1654.9725);
	angles[21] = (0, 32.3037, 0);
	at[21] = 12.4000;
	points[22] = (5304.6460, 6172.7954, 1654.9725);
	angles[22] = (0, 35.9825, 0);
	at[22] = 12.6000;
	points[23] = (5166.3779, 6361.3779, 1654.9725);
	angles[23] = (0, 36.2541, 0);
	at[23] = 14.8000;
	points[24] = (5157.4409, 6360.3540, 1654.9725);
	angles[24] = (0, 85.3210, 0);
	at[24] = 14.9000;
	points[25] = (5147.6777, 6356.1816, 1654.9725);
	angles[25] = (0, 105.7993, 0);
	at[25] = 15;
	points[26] = (5137.9136, 6351.9683, 1654.9725);
	angles[26] = (0, 111.2573, 0);
	at[26] = 15.1000;
	points[27] = (4649.4097, 6142.5986, 1654.9725);
	angles[27] = (0, 113.1986, 0);
	at[27] = 20.1000;
	points[28] = (4644.7246, 6133.9761, 1654.9725);
	angles[28] = (0, 146.8368, 0);
	at[28] = 20.2000;
	points[29] = (4641.8506, 6123.7402, 1654.9725);
	angles[29] = (0, 159.6887, 0);
	at[29] = 20.3000;
	points[30] = (4638.9370, 6113.5044, 1654.9725);
	angles[30] = (0, 163.0794, 0);
	at[30] = 20.4000;
	points[31] = (4584.2520, 5919.0947, 1654.9725);
	angles[31] = (0, 164.2846, 0);
	at[31] = 22.3000;
	points[32] = (4585.0786, 5905.5908, 1654.9725);
	angles[32] = (0, 180.5315, 0);
	at[32] = 22.4000;
	points[33] = (4591.6929, 5885.3545, 1654.9725);
	angles[33] = (0, 193.4698, 0);
	at[33] = 22.5000;
	points[34] = (4595, 5875.2754, 1654.9725);
	angles[34] = (0, 195.7274, 0);
	at[34] = 22.5500;
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
	points[0] = (-2848.6418, 5151.4170, 1654.9725);
	angles[0] = (0, 48.0801, 0);
	at[0] = 0;
	points[1] = (-3038.2322, 5322.1265, 1654.9725);
	angles[1] = (0, 48, 0);
	at[1] = 1.2000;
	points[2] = (-3049.1182, 5335.3936, 1654.9725);
	angles[2] = (0, 32.3295, 0);
	at[2] = 1.3000;
	points[3] = (-3051.9451, 5345.6694, 1654.9725);
	angles[3] = (0, 19.8756, 0);
	at[3] = 1.4000;
	points[4] = (-3057.5986, 5366.1421, 1654.9725);
	angles[4] = (0, 15.7298, 0);
	at[4] = 1.6000;
	points[5] = (-3162.2009, 5745.2754, 1654.9725);
	angles[5] = (0, 15.4238, 0);
	at[5] = 5.3000;
	points[6] = (-3160.8818, 5754.1338, 1654.9725);
	angles[6] = (0, -15.3951, 0);
	at[6] = 5.4000;
	points[7] = (-3152.4763, 5760.6694, 1654.9725);
	angles[7] = (0, -42.3763, 0);
	at[7] = 5.5000;
	points[8] = (-3144.0708, 5767.1650, 1654.9725);
	angles[8] = (0, -49.6600, 0);
	at[8] = 5.6000;
	points[9] = (-3135.6653, 5773.6616, 1654.9725);
	angles[9] = (0, -51.5733, 0);
	at[9] = 5.7000;
	points[10] = (-2841.4802, 6001.4175, 1654.9725);
	angles[10] = (0, -52.2531, 0);
	at[10] = 9.2000;
	points[11] = (-2832.9568, 5998.5825, 1654.9725);
	angles[11] = (0, -99.7121, 0);
	at[11] = 9.3000;
	points[12] = (-2824.3938, 5992.2832, 1654.9725);
	angles[12] = (0, -119.2755, 0);
	at[12] = 9.4000;
	points[13] = (-2815.8308, 5985.9844, 1654.9725);
	angles[13] = (0, -124.4819, 0);
	at[13] = 9.5000;
	points[14] = (-2498.9922, 5752.9927, 1654.9725);
	angles[14] = (0, -126.3335, 0);
	at[14] = 13.2000;
	points[15] = (-2490.3149, 5742.2051, 1654.9725);
	angles[15] = (0, -138.7698, 0);
	at[15] = 13.3000;
	points[16] = (-2480.3464, 5723.4253, 1654.9725);
	angles[16] = (0, -148.5541, 0);
	at[16] = 13.4000;
	points[17] = (-2470.3818, 5704.6455, 1654.9725);
	angles[17] = (0, -151.1286, 0);
	at[17] = 13.5000;
	points[18] = (-2300.9487, 5385.3940, 1654.9725);
	angles[18] = (0, -152.0434, 0);
	at[18] = 15.2000;
	points[19] = (-2294.1733, 5367.7163, 1654.9725);
	angles[19] = (0, -163.5941, 0);
	at[19] = 15.3000;
	points[20] = (-2295.0591, 5357.1260, 1654.9725);
	angles[20] = (0, -179.1745, 0);
	at[20] = 15.4000;
	points[21] = (-2296.8228, 5335.9453, 1654.9725);
	angles[21] = (0, -184.3794, 0);
	at[21] = 15.6000;
	points[22] = (-2323.3071, 5018.1494, 1654.9725);
	angles[22] = (0, -184.7637, 0);
	at[22] = 18.6000;
	points[23] = (-2332.6614, 5015.8267, 1654.9725);
	angles[23] = (0, -240.7501, 0);
	at[23] = 18.7000;
	points[24] = (-2343.2324, 5014.7246, 1654.9725);
	angles[24] = (0, -257.8458, 0);
	at[24] = 18.8000;
	points[25] = (-2353.8032, 5013.6221, 1654.9725);
	angles[25] = (0, -262.3789, 0);
	at[25] = 18.9000;
	points[26] = (-2596.9490, 4988.0317, 1654.9725);
	angles[26] = (0, -263.9909, 0);
	at[26] = 21.2000;
	points[27] = (-2607.1101, 4988.7402, 1654.9725);
	angles[27] = (0, -277.0533, 0);
	at[27] = 21.3000;
	points[28] = (-2616.2009, 4994.2520, 1654.9725);
	angles[28] = (0, -294.8228, 0);
	at[28] = 21.4000;
	points[29] = (-2634.3857, 5005.2759, 1654.9725);
	angles[29] = (0, -300.7767, 0);
	at[29] = 21.6000;
	points[30] = (-2788.9292, 5098.8975, 1654.9725);
	angles[30] = (0, -301.2162, 0);
	at[30] = 23.3000;
	points[31] = (-2801.2444, 5108.7397, 1654.9725);
	angles[31] = (0, -307.5754, 0);
	at[31] = 23.4000;
	points[32] = (-2817.0435, 5122.9917, 1654.9725);
	angles[32] = (0, -310.8395, 0);
	at[32] = 23.5000;
	points[33] = (-2848.6418, 5151.4170, 1654.9725);
	angles[33] = (0, -311.9199, 0);
	at[33] = 23.7000;
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
	points[0] = (-7735.6689, 5566.9688, 1654.9725);
	angles[0] = (0, -34.6007, 0);
	at[0] = 0;
	points[1] = (-7636.2598, 5709.3306, 1654.9725);
	angles[1] = (0, -34.9353, 0);
	at[1] = 0.8167;
	points[2] = (-7622.0474, 5729.6460, 1654.9725);
	angles[2] = (0, -37.5400, 0);
	at[2] = 0.9333;
	points[3] = (-7612.7559, 5737.8740, 1654.9725);
	angles[3] = (0, -45.8133, 0);
	at[3] = 1.0500;
	points[4] = (-7594.3306, 5754.4883, 1654.9725);
	angles[4] = (0, -47.9169, 0);
	at[4] = 1.2833;
	points[5] = (-7299.3306, 6019.9604, 1654.9725);
	angles[5] = (0, -48.0137, 0);
	at[5] = 5.0167;
	points[6] = (-7292.2446, 6016.3779, 1654.9725);
	angles[6] = (0, -110.1990, 0);
	at[6] = 5.1333;
	points[7] = (-7286.4175, 6005.3940, 1654.9725);
	angles[7] = (0, -142.9892, 0);
	at[7] = 5.2500;
	points[8] = (-7280.5908, 5994.4492, 1654.9725);
	angles[8] = (0, -150.1239, 0);
	at[8] = 5.3667;
	points[9] = (-7047.8745, 5556.3779, 1654.9725);
	angles[9] = (0, -152.0205, 0);
	at[9] = 10.0333;
	points[10] = (-7045.9058, 5545.1973, 1654.9725);
	angles[10] = (0, -175.0650, 0);
	at[10] = 10.1500;
	points[11] = (-7050.3149, 5533.5825, 1654.9725);
	angles[11] = (0, -195.3868, 0);
	at[11] = 10.2667;
	points[12] = (-7054.7246, 5522.0078, 1654.9725);
	angles[12] = (0, -199.7074, 0);
	at[12] = 10.3833;
	points[13] = (-7160.7090, 5243.8584, 1654.9725);
	angles[13] = (0, -200.8546, 0);
	at[13] = 13.1833;
	points[14] = (-7170.8271, 5229.6455, 1654.9725);
	angles[14] = (0, -213.1789, 0);
	at[14] = 13.3000;
	points[15] = (-7187.3623, 5211.1421, 1654.9725);
	angles[15] = (0, -220.0057, 0);
	at[15] = 13.4167;
	points[16] = (-7402.3623, 4970.8662, 1654.9725);
	angles[16] = (0, -221.8201, 0);
	at[16] = 14.9333;
	points[17] = (-7419.4487, 4957.2051, 1654.9725);
	angles[17] = (0, -236.9683, 0);
	at[17] = 15.0500;
	points[18] = (-7431.8115, 4956.1812, 1654.9725);
	angles[18] = (0, -259.3784, 0);
	at[18] = 15.1667;
	points[19] = (-7456.5352, 4954.2124, 1654.9725);
	angles[19] = (0, -265.1602, 0);
	at[19] = 15.4000;
	points[20] = (-7777.9526, 4928.5039, 1654.9725);
	angles[20] = (0, -265.4265, 0);
	at[20] = 18.4333;
	points[21] = (-7786.4170, 4933.7402, 1654.9725);
	angles[21] = (0, -306.0967, 0);
	at[21] = 18.5500;
	points[22] = (-7790.9058, 4945.3149, 1654.9725);
	angles[22] = (0, -331.7801, 0);
	at[22] = 18.6667;
	points[23] = (-7795.3940, 4956.8506, 1654.9725);
	angles[23] = (0, -337.2867, 0);
	at[23] = 18.7833;
	points[24] = (-7885.3149, 5188.0317, 1654.9725);
	angles[24] = (0, -338.7495, 0);
	at[24] = 21.1167;
	points[25] = (-7885.8662, 5199.6455, 1654.9725);
	angles[25] = (0, -362.7563, 0);
	at[25] = 21.2333;
	points[26] = (-7881.5752, 5211.2598, 1654.9725);
	angles[26] = (0, -376.4720, 0);
	at[26] = 21.3500;
	points[27] = (-7877.3228, 5222.9136, 1654.9725);
	angles[27] = (0, -379.3663, 0);
	at[27] = 21.4667;
	points[28] = (-7770.5908, 5514.0156, 1654.9725);
	angles[28] = (0, -380.1343, 0);
	at[28] = 24.3833;
	points[29] = (-7762.0474, 5529.2129, 1654.9725);
	angles[29] = (0, -388.8541, 0);
	at[29] = 24.5000;
	points[30] = (-7735.6689, 5566.9688, 1654.9725);
	angles[30] = (0, -394.6008, 0);
	at[30] = 24.7167;
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
	points[0] = (-9566.2207, 3067.5906, 1654.9725);
	angles[0] = (0, 178.0788, 0);
	at[0] = 0;
	points[1] = (-9571.9688, 2876.3386, 1654.9725);
	angles[1] = (0, 178.2820, 0);
	at[1] = 0.9000;
	points[2] = (-9569.5674, 2859.7400, 1654.9725);
	angles[2] = (0, 199.6969, 0);
	at[2] = 1;
	points[3] = (-9562.2441, 2852.0198, 1654.9725);
	angles[3] = (0, 217.1512, 0);
	at[3] = 1.1000;
	points[4] = (-9547.6377, 2836.5828, 1654.9725);
	angles[4] = (0, 222.9968, 0);
	at[4] = 1.3000;
	points[5] = (-9306.4961, 2581.8269, 1654.9725);
	angles[5] = (0, 223.4284, 0);
	at[5] = 4.6000;
	points[6] = (-9298.2676, 2576.9331, 1654.9725);
	angles[6] = (0, 242.7559, 0);
	at[6] = 4.7000;
	points[7] = (-9287.8350, 2578.8975, 1654.9725);
	angles[7] = (0, 270.4951, 0);
	at[7] = 4.8000;
	points[8] = (-9277.3623, 2580.8662, 1654.9725);
	angles[8] = (0, 277.9965, 0);
	at[8] = 4.9000;
	points[9] = (-9266.9297, 2582.8345, 1654.9725);
	angles[9] = (0, 279.9672, 0);
	at[9] = 5;
	points[10] = (-8984.8818, 2635.9646, 1654.9725);
	angles[10] = (0, 280.6674, 0);
	at[10] = 7.7000;
	points[11] = (-8975.8662, 2639.8938, 1654.9725);
	angles[11] = (0, 298.2118, 0);
	at[11] = 7.8000;
	points[12] = (-8970.8662, 2649.2715, 1654.9725);
	angles[12] = (0, 322.9191, 0);
	at[12] = 7.9000;
	points[13] = (-8965.8662, 2658.6497, 1654.9725);
	angles[13] = (0, 329.5562, 0);
	at[13] = 8;
	points[14] = (-8960.8662, 2668.0276, 1654.9725);
	angles[14] = (0, 331.2991, 0);
	at[14] = 8.1000;
	points[15] = (-8825.7480, 2921.2480, 1654.9725);
	angles[15] = (0, 331.9184, 0);
	at[15] = 10.8000;
	points[16] = (-8820.7480, 2930.6260, 1654.9725);
	angles[16] = (0, 340.0271, 0);
	at[16] = 10.9000;
	points[17] = (-8827.0869, 2951.3467, 1654.9725);
	angles[17] = (0, 365.1979, 0);
	at[17] = 11;
	points[18] = (-8832.3623, 2971.9409, 1654.9725);
	angles[18] = (0, 371.9659, 0);
	at[18] = 11.1000;
	points[19] = (-8906.2598, 3260.2600, 1654.9725);
	angles[19] = (0, 374.3748, 0);
	at[19] = 12.5000;
	points[20] = (-8912.6777, 3274.3113, 1654.9725);
	angles[20] = (0, 392.2863, 0);
	at[20] = 12.6000;
	points[21] = (-8920.1973, 3281.8306, 1654.9725);
	angles[21] = (0, 401.6586, 0);
	at[21] = 12.7000;
	points[22] = (-8935.2363, 3296.8623, 1654.9725);
	angles[22] = (0, 404.7704, 0);
	at[22] = 12.9000;
	points[23] = (-9115.6299, 3477.2600, 1654.9725);
	angles[23] = (0, 405, 0);
	at[23] = 15.3000;
	points[24] = (-9125.5908, 3474.6892, 1654.9725);
	angles[24] = (0, 450.1553, 0);
	at[24] = 15.4000;
	points[25] = (-9135.7090, 3471.4487, 1654.9725);
	angles[25] = (0, 463.1110, 0);
	at[25] = 15.5000;
	points[26] = (-9145.8271, 3468.2087, 1654.9725);
	angles[26] = (0, 466.5295, 0);
	at[26] = 15.6000;
	points[27] = (-9479.9209, 3361.2993, 1654.9725);
	angles[27] = (0, 467.7446, 0);
	at[27] = 18.9000;
	points[28] = (-9487.4414, 3355.3740, 1654.9725);
	angles[28] = (0, 492.5967, 0);
	at[28] = 19;
	points[29] = (-9490.9453, 3345.3389, 1654.9725);
	angles[29] = (0, 513.2781, 0);
	at[29] = 19.1000;
	points[30] = (-9494.4492, 3335.3030, 1654.9725);
	angles[30] = (0, 518.7921, 0);
	at[30] = 19.2000;
	points[31] = (-9497.9531, 3325.2678, 1654.9725);
	angles[31] = (0, 520.2392, 0);
	at[31] = 19.3000;
	points[32] = (-9561.0244, 3144.6221, 1654.9725);
	angles[32] = (0, 520.7535, 0);
	at[32] = 21.1000;
	points[33] = (-9564.4102, 3134.9211, 1654.9725);
	angles[33] = (0, 524.2328, 0);
	at[33] = 21.2000;
	points[34] = (-9564.8428, 3113.6299, 1654.9725);
	angles[34] = (0, 534.5875, 0);
	at[34] = 21.3000;
	points[35] = (-9566.2207, 3067.5906, 1654.9725);
	angles[35] = (0, 538.0788, 0);
	at[35] = 21.5167;
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
	points[0] = (-8748.2676, 872.9174, 1654.9725);
	angles[0] = (0, 62.2720, 0);
	at[0] = 0;
	points[1] = (-8935.5908, 973.4686, 1654.9725);
	angles[1] = (0, 61.7720, 0);
	at[1] = 1;
	points[2] = (-8941.9297, 983.4016, 1654.9725);
	angles[2] = (0, 32.4792, 0);
	at[2] = 1.1000;
	points[3] = (-8945.8662, 993.2756, 1654.9725);
	angles[3] = (0, 24.5276, 0);
	at[3] = 1.2000;
	points[4] = (-8949.8027, 1003.1536, 1654.9725);
	angles[4] = (0, 22.4380, 0);
	at[4] = 1.3000;
	points[5] = (-9083.4248, 1338.9685, 1654.9725);
	angles[5] = (0, 21.6955, 0);
	at[5] = 4.7000;
	points[6] = (-9084.8818, 1348.3662, 1654.9725);
	angles[6] = (0, 0.0911, 0);
	at[6] = 4.8000;
	points[7] = (-9077.5195, 1356.0511, 1654.9725);
	angles[7] = (0, -31.8740, 0);
	at[7] = 4.9000;
	points[8] = (-9070.1973, 1363.7324, 1654.9725);
	angles[8] = (0, -40.6131, 0);
	at[8] = 5;
	points[9] = (-9062.8350, 1371.4135, 1654.9725);
	angles[9] = (0, -42.9107, 0);
	at[9] = 5.1000;
	points[10] = (-8761.5752, 1686.3583, 1654.9725);
	angles[10] = (0, -43.7272, 0);
	at[10] = 9.2000;
	points[11] = (-8751.4570, 1685.0984, 1654.9725);
	angles[11] = (0, -85.6649, 0);
	at[11] = 9.3000;
	points[12] = (-8741.0625, 1682.9330, 1654.9725);
	angles[12] = (0, -97.5296, 0);
	at[12] = 9.4000;
	points[13] = (-8730.6699, 1680.7638, 1654.9725);
	angles[13] = (0, -100.6568, 0);
	at[13] = 9.5000;
	points[14] = (-8408.0312, 1613.5551, 1654.9725);
	angles[14] = (0, -101.7683, 0);
	at[14] = 12.6000;
	points[15] = (-8392.7559, 1604.8741, 1654.9725);
	angles[15] = (0, -115.5127, 0);
	at[15] = 12.7000;
	points[16] = (-8374.7637, 1593.5236, 1654.9725);
	angles[16] = (0, -120.5016, 0);
	at[16] = 12.8000;
	points[17] = (-8141.1025, 1445.9370, 1654.9725);
	angles[17] = (0, -122.2758, 0);
	at[17] = 14.1000;
	points[18] = (-8123.1499, 1434.5828, 1654.9725);
	angles[18] = (0, -132.1446, 0);
	at[18] = 14.2000;
	points[19] = (-8123.5830, 1423.2047, 1654.9725);
	angles[19] = (0, -163.7273, 0);
	at[19] = 14.3000;
	points[20] = (-8122.7168, 1412.6102, 1654.9725);
	angles[20] = (0, -172.3526, 0);
	at[20] = 14.4000;
	points[21] = (-8121.8901, 1402.0157, 1654.9725);
	angles[21] = (0, -174.6202, 0);
	at[21] = 14.5000;
	points[22] = (-8095.5908, 1073.5354, 1654.9725);
	angles[22] = (0, -175.4260, 0);
	at[22] = 17.6000;
	points[23] = (-8097.2837, 1064.4016, 1654.9725);
	angles[23] = (0, -197.9621, 0);
	at[23] = 17.7000;
	points[24] = (-8106.8896, 1059.8149, 1654.9725);
	angles[24] = (0, -231.8157, 0);
	at[24] = 17.8000;
	points[25] = (-8116.4570, 1055.2283, 1654.9725);
	angles[25] = (0, -241.1223, 0);
	at[25] = 17.9000;
	points[26] = (-8126.0630, 1050.6417, 1654.9725);
	angles[26] = (0, -243.5701, 0);
	at[26] = 18;
	points[27] = (-8432.9131, 903.8779, 1654.9725);
	angles[27] = (0, -244.4400, 0);
	at[27] = 21.2000;
	points[28] = (-8443.0703, 900.8268, 1654.9725);
	angles[28] = (0, -252.3309, 0);
	at[28] = 21.3000;
	points[29] = (-8474.0547, 893.2166, 1654.9725);
	angles[29] = (0, -256.1194, 0);
	at[29] = 21.6000;
	points[30] = (-8680.4727, 842.4645, 1654.9725);
	angles[30] = (0, -256.1888, 0);
	at[30] = 23.6000;
	points[31] = (-8692.0869, 842.7480, 1654.9725);
	angles[31] = (0, -270.8312, 0);
	at[31] = 23.7000;
	points[32] = (-8710.7871, 852.8032, 1654.9725);
	angles[32] = (0, -290.9593, 0);
	at[32] = 23.8000;
	points[33] = (-8748.2676, 872.9174, 1654.9725);
	angles[33] = (0, -297.7280, 0);
	at[33] = 24;
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
	points[0] = (2023.8623, -2539.4370, 1654.9725);
	angles[0] = (0, 45.7811, 0);
	at[0] = 0;
	points[1] = (1902.4883, -2420.2952, 1654.9725);
	angles[1] = (0, 45.5327, 0);
	at[1] = 0.8000;
	points[2] = (1892.3740, -2410.3662, 1654.9725);
	angles[2] = (0, 37.3869, 0);
	at[2] = 0.8667;
	points[3] = (1893.7638, -2402.5039, 1654.9725);
	angles[3] = (0, 17.2482, 0);
	at[3] = 0.9333;
	points[4] = (1893.4135, -2395.4253, 1654.9725);
	angles[4] = (0, 8.7721, 0);
	at[4] = 1;
	points[5] = (1892.7047, -2381.2717, 1654.9725);
	angles[5] = (0, 3.8544, 0);
	at[5] = 1.1333;
	points[6] = (1879.6102, -2119.3938, 1654.9725);
	angles[6] = (0, 2.8624, 0);
	at[6] = 3.6000;
	points[7] = (1883.2677, -2115.3269, 1654.9725);
	angles[7] = (0, -32.1858, 0);
	at[7] = 3.6667;
	points[8] = (1890.1615, -2113.6851, 1654.9725);
	angles[8] = (0, -57.8810, 0);
	at[8] = 3.7333;
	points[9] = (1897.0552, -2112.0435, 1654.9725);
	angles[9] = (0, -68.8989, 0);
	at[9] = 3.8000;
	points[10] = (1910.8425, -2108.7598, 1654.9725);
	angles[10] = (0, -75.3130, 0);
	at[10] = 3.9333;
	points[11] = (2186.5984, -2043.1023, 1654.9725);
	angles[11] = (0, -76.6075, 0);
	at[11] = 6.6000;
	points[12] = (2191.8860, -2045.1575, 1654.9725);
	angles[12] = (0, -100.3101, 0);
	at[12] = 6.6667;
	points[13] = (2195.3857, -2051.3188, 1654.9725);
	angles[13] = (0, -129.1081, 0);
	at[13] = 6.7333;
	points[14] = (2198.8896, -2057.4802, 1654.9725);
	angles[14] = (0, -141.6200, 0);
	at[14] = 6.8000;
	points[15] = (2202.3899, -2063.6418, 1654.9725);
	angles[15] = (0, -146.7973, 0);
	at[15] = 6.8667;
	points[16] = (2212.8899, -2082.1260, 1654.9725);
	angles[16] = (0, -150.1484, 0);
	at[16] = 7.0667;
	points[17] = (2282.9094, -2205.3584, 1654.9725);
	angles[17] = (0, -150.3957, 0);
	at[17] = 8.4000;
	points[18] = (2286.6694, -2213.3464, 1654.9725);
	angles[18] = (0, -153.6808, 0);
	at[18] = 8.4667;
	points[19] = (2301.5354, -2253.1851, 1654.9725);
	angles[19] = (0, -159.1320, 0);
	at[19] = 8.6667;
	points[20] = (2365.9568, -2425.8071, 1654.9725);
	angles[20] = (0, -159.5344, 0);
	at[20] = 9.5333;
	points[21] = (2367.2046, -2436.0867, 1654.9725);
	angles[21] = (0, -172.1920, 0);
	at[21] = 9.6000;
	points[22] = (2366.5000, -2443.1377, 1654.9725);
	angles[22] = (0, -180.1591, 0);
	at[22] = 9.6667;
	points[23] = (2365.0867, -2457.2402, 1654.9725);
	angles[23] = (0, -184.7788, 0);
	at[23] = 9.8000;
	points[24] = (2347.4607, -2633.5237, 1654.9725);
	angles[24] = (0, -185.7106, 0);
	at[24] = 11.4667;
	points[25] = (2346.7559, -2640.5789, 1654.9725);
	angles[25] = (0, -197.7200, 0);
	at[25] = 11.5333;
	points[26] = (2339.5669, -2642.2126, 1654.9725);
	angles[26] = (0, -229.8615, 0);
	at[26] = 11.6000;
	points[27] = (2332.7520, -2644.1575, 1654.9725);
	angles[27] = (0, -244.0622, 0);
	at[27] = 11.6667;
	points[28] = (2325.9409, -2646.1062, 1654.9725);
	angles[28] = (0, -249.9559, 0);
	at[28] = 11.7333;
	points[29] = (2305.4961, -2651.9448, 1654.9725);
	angles[29] = (0, -253.7728, 0);
	at[29] = 11.9333;
	points[30] = (2203.2874, -2681.1494, 1654.9725);
	angles[30] = (0, -254.0545, 0);
	at[30] = 12.9333;
	points[31] = (2197.1101, -2679.7480, 1654.9725);
	angles[31] = (0, -279.0550, 0);
	at[31] = 13;
	points[32] = (2191.4805, -2675.4448, 1654.9725);
	angles[32] = (0, -295.6619, 0);
	at[32] = 13.0667;
	points[33] = (2185.8503, -2671.1379, 1654.9725);
	angles[33] = (0, -302.5888, 0);
	at[33] = 13.1333;
	points[34] = (2180.2205, -2666.8347, 1654.9725);
	angles[34] = (0, -305.4349, 0);
	at[34] = 13.2000;
	points[35] = (2062.0156, -2576.4214, 1654.9725);
	angles[35] = (0, -307.4105, 0);
	at[35] = 14.6000;
	points[36] = (2054.2087, -2569.2205, 1654.9725);
	angles[36] = (0, -310.8521, 0);
	at[36] = 14.6667;
	points[37] = (2023.8623, -2539.4370, 1654.9725);
	angles[37] = (0, -314.2189, 0);
	at[37] = 14.8667;
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
	points[0] = (2023.9409, -388.1012, 1654.9725);
	angles[0] = (0, 175.6061, 0);
	at[0] = 0;
	points[1] = (2012.8583, -500.9449, 1654.9725);
	angles[1] = (0, 174.3914, 0);
	at[1] = 0.5333;
	points[2] = (2016.4962, -508.5551, 1654.9725);
	angles[2] = (0, 198.2649, 0);
	at[2] = 0.6000;
	points[3] = (2020.6143, -514.3228, 1654.9725);
	angles[3] = (0, 208.4328, 0);
	at[3] = 0.6667;
	points[4] = (2028.8544, -525.8583, 1654.9725);
	angles[4] = (0, 214.3448, 0);
	at[4] = 0.8000;
	points[5] = (2156.5432, -704.6221, 1654.9725);
	angles[5] = (0, 215.5378, 0);
	at[5] = 2.8667;
	points[6] = (2160.6614, -710.3898, 1654.9725);
	angles[6] = (0, 226.1162, 0);
	at[6] = 2.9333;
	points[7] = (2167.7598, -709.9252, 1654.9725);
	angles[7] = (0, 253.3689, 0);
	at[7] = 3;
	points[8] = (2174.8347, -709.5079, 1654.9725);
	angles[8] = (0, 265.1289, 0);
	at[8] = 3.0667;
	points[9] = (2188.9805, -708.6772, 1654.9725);
	angles[9] = (0, 271.9828, 0);
	at[9] = 3.2000;
	points[10] = (2408.2876, -695.7756, 1654.9725);
	angles[10] = (0, 273.3663, 0);
	at[10] = 5.2667;
	points[11] = (2413.2598, -692.5670, 1654.9725);
	angles[11] = (0, 295.4379, 0);
	at[11] = 5.3333;
	points[12] = (2415.6182, -685.8858, 1654.9725);
	angles[12] = (0, 321.5246, 0);
	at[12] = 5.4000;
	points[13] = (2417.9763, -679.2007, 1654.9725);
	angles[13] = (0, 332.7277, 0);
	at[13] = 5.4667;
	points[14] = (2422.6929, -665.8347, 1654.9725);
	angles[14] = (0, 339.2514, 0);
	at[14] = 5.6000;
	points[15] = (2469.8425, -532.1772, 1654.9725);
	angles[15] = (0, 340.5681, 0);
	at[15] = 6.9333;
	points[16] = (2469.9094, -521.7480, 1654.9725);
	angles[16] = (0, 352.9131, 0);
	at[16] = 7;
	points[17] = (2468.4055, -507.6535, 1654.9725);
	angles[17] = (0, 360.6773, 0);
	at[17] = 7.0667;
	points[18] = (2465.4016, -479.4685, 1654.9725);
	angles[18] = (0, 365.1783, 0);
	at[18] = 7.2000;
	points[19] = (2441.3584, -253.9732, 1654.9725);
	angles[19] = (0, 366.0862, 0);
	at[19] = 8.2667;
	points[20] = (2436.2954, -247.3339, 1654.9725);
	angles[20] = (0, 391.1666, 0);
	at[20] = 8.3333;
	points[21] = (2430.9136, -242.7221, 1654.9725);
	angles[21] = (0, 401.8956, 0);
	at[21] = 8.4000;
	points[22] = (2420.1536, -233.4980, 1654.9725);
	angles[22] = (0, 408.1387, 0);
	at[22] = 8.5333;
	points[23] = (2226.4526, -67.4693, 1654.9725);
	angles[23] = (0, 409.3987, 0);
	at[23] = 10.9333;
	points[24] = (2221.0708, -62.8575, 1654.9725);
	angles[24] = (0, 422.0282, 0);
	at[24] = 11;
	points[25] = (2215.1299, -66.7256, 1654.9725);
	angles[25] = (0, 456.5992, 0);
	at[25] = 11.0667;
	points[26] = (2209.1890, -70.5874, 1654.9725);
	angles[26] = (0, 472.0920, 0);
	at[26] = 11.1333;
	points[27] = (2197.3032, -78.3118, 1654.9725);
	angles[27] = (0, 481.1862, 0);
	at[27] = 11.2667;
	points[28] = (2013.1102, -198.0374, 1654.9725);
	angles[28] = (0, 483.0238, 0);
	at[28] = 13.3333;
	points[29] = (2012.0552, -204.2453, 1654.9725);
	angles[29] = (0, 511.8794, 0);
	at[29] = 13.4000;
	points[30] = (2012.7599, -211.2972, 1654.9725);
	angles[30] = (0, 531.6105, 0);
	at[30] = 13.4667;
	points[31] = (2013.4606, -218.3488, 1654.9725);
	angles[31] = (0, 539.9056, 0);
	at[31] = 13.5333;
	points[32] = (2014.1654, -225.4008, 1654.9725);
	angles[32] = (0, 543.3184, 0);
	at[32] = 13.6000;
	points[33] = (2026.8071, -352.3315, 1654.9725);
	angles[33] = (0, 545.6879, 0);
	at[33] = 14.8000;
	points[34] = (2026.3662, -363.4169, 1654.9725);
	angles[34] = (0, 540.1840, 0);
	at[34] = 14.8667;
	points[35] = (2023.9409, -388.1012, 1654.9725);
	angles[35] = (0, 535.6061, 0);
	at[35] = 14.9833;
	mover = getEnt("iz_obj_7", "targetname");
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
