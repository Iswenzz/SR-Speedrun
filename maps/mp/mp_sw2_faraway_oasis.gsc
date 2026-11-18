main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_faraway_oasis", 0);

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
	ambientPlay("iz_0_sw2fo", 2);
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
	level.iz_route[level.iz_route.size] = (-1845, 6699, 682);
	level.iz_route[level.iz_route.size] = (-2201, 5111, 682);
	level.iz_route[level.iz_route.size] = (-3069, 4198, 682);
	level.iz_route[level.iz_route.size] = (-3857, 3796, 687);
	level.iz_route[level.iz_route.size] = (-6209, 2776, 690);
	level.iz_route[level.iz_route.size] = (-7598, 2430, 925);
	level.iz_route[level.iz_route.size] = (-8873, 2843, 1118);
	level.iz_route[level.iz_route.size] = (-9435, 3768, 1241);
	level.iz_route[level.iz_route.size] = (-9545, 4786, 1393);
	level.iz_route[level.iz_route.size] = (-9029, 5307, 1442);
	level.iz_route[level.iz_route.size] = (-8589, 5764, 1551);
	level.iz_route[level.iz_route.size] = (-7786, 5984, 1676);
	level.iz_route[level.iz_route.size] = (-7008, 5945, 1805);
	level.iz_route[level.iz_route.size] = (-6378, 5612, 1962);
	level.iz_route[level.iz_route.size] = (-5986, 5216, 2041);
	level.iz_route[level.iz_route.size] = (-5731, 4593, 2037);
	level.iz_route[level.iz_route.size] = (-4949, 3508, 2094);
	level.iz_route[level.iz_route.size] = (-4501, 2372, 2247);
	level.iz_route[level.iz_route.size] = (-3912, 808, 2416);
	level.iz_route[level.iz_route.size] = (-3514, -210, 2803);
	level.iz_route[level.iz_route.size] = (-2684, -2263, 2125);
	level.iz_route[level.iz_route.size] = (-2370, -3313, 1947);
	level.iz_route[level.iz_route.size] = (-1809, -5076, 1643);
	level.iz_route[level.iz_route.size] = (-1317, -6679, 1471);
	level.iz_route[level.iz_route.size] = (-1010, -8145, 1283);
	level.iz_route[level.iz_route.size] = (-499, -9683, 1227);
	level.iz_route[level.iz_route.size] = (571, -10645, 1173);
	level.iz_route[level.iz_route.size] = (1767, -10952, 1115);
	level.iz_route[level.iz_route.size] = (2720, -10417, 1058);
	level.iz_route[level.iz_route.size] = (3388, -9571, 1028);
	level.iz_route[level.iz_route.size] = (3731, -9036, 1023);
	level.iz_route[level.iz_route.size] = (4060, -7624, 665);
	level.iz_route[level.iz_route.size] = (4536, -6361, 665);
	level.iz_route[level.iz_route.size] = (4427, -5318, 665);
	level.iz_route[level.iz_route.size] = (4397, -4136, 665);
	level.iz_route[level.iz_route.size] = (4727, -3414, 665);
	level.iz_route[level.iz_route.size] = (5424, -2820, 665);
	level.iz_route[level.iz_route.size] = (6590, -2642, 665);
	level.iz_route[level.iz_route.size] = (8031, -2478, 665);
	level.iz_route[level.iz_route.size] = (8816, -1965, 665);
	level.iz_route[level.iz_route.size] = (9260, -941, 665);
	level.iz_route[level.iz_route.size] = (8964, 100, 661);
	level.iz_route[level.iz_route.size] = (8132, 686, 613);
	level.iz_route[level.iz_route.size] = (7365, 635, 586);
	level.iz_route[level.iz_route.size] = (6515, 276, 561);
	level.iz_route[level.iz_route.size] = (5625, -106, 535);
	level.iz_route[level.iz_route.size] = (4398, -636, 718);
	level.iz_route[level.iz_route.size] = (3489, -1082, 361);
	level.iz_route[level.iz_route.size] = (2450, -1206, 326);
	level.iz_route[level.iz_route.size] = (1317, -1210, 330);
	level.iz_route[level.iz_route.size] = (507, -481, 310);
	level.iz_route[level.iz_route.size] = (3, 483, 313);
	level.iz_route[level.iz_route.size] = (-94, 1468, 307);
	level.iz_route[level.iz_route.size] = (-135, 2814, 338);
	level.iz_route[level.iz_route.size] = (101, 3886, 362);
	level.iz_route[level.iz_route.size] = (267, 4842, 517);
	level.iz_route[level.iz_route.size] = (695, 6044, 568);
	level.iz_route[level.iz_route.size] = (802, 7559, 650);
	level.iz_route[level.iz_route.size] = (835, 9096, 739);
	level.iz_route[level.iz_route.size] = (481, 10018, 807);
	level.iz_route[level.iz_route.size] = (-428, 10442, 851);
	level.iz_route[level.iz_route.size] = (-1230, 9854, 818);
	level.iz_route[level.iz_route.size] = (-1700, 8761, 738);
	level.iz_route[level.iz_route.size] = (-1788, 7706, 687);
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
	points[0] = (7005.5513, -3734.3821, 682.0867);
	angles[0] = (0, 143.9955, 0);
	at[0] = 0;
	points[1] = (6836.5752, -3963.2285, 682.0867);
	angles[1] = (0, 144.2615, 0);
	at[1] = 1.6000;
	points[2] = (6778.2676, -4051.4172, 682.0867);
	angles[2] = (0, 147.8977, 0);
	at[2] = 2.2000;
	points[3] = (6567.4414, -4421.8896, 682.0867);
	angles[3] = (0, 150.3597, 0);
	at[3] = 4.6000;
	points[4] = (6515.6694, -4511.4170, 682.0867);
	angles[4] = (0, 149.9227, 0);
	at[4] = 5.2000;
	points[5] = (6157.0864, -5127.7559, 682.0867);
	angles[5] = (0, 149.6864, 0);
	at[5] = 9.2000;
	points[6] = (6123.6221, -5184.6851, 682.0867);
	angles[6] = (0, 149.4868, 0);
	at[6] = 9.6000;
	points[7] = (5758.7402, -5797.8345, 679.1929);
	angles[7] = (0, 149.6357, 0);
	at[7] = 13.6000;
	points[8] = (5724.7246, -5857.6772, 678.5433);
	angles[8] = (0, 150.7755, 0);
	at[8] = 14;
	points[9] = (5696.1421, -5922.4019, 677.5355);
	angles[9] = (0, 157.8560, 0);
	at[9] = 14.4000;
	points[10] = (5689.1338, -5956.8896, 676.6890);
	angles[10] = (0, 166.9510, 0);
	at[10] = 14.6000;
	points[11] = (5692.2437, -5991.6929, 675.4567);
	angles[11] = (0, 182.1651, 0);
	at[11] = 14.8000;
	points[12] = (5709.9214, -6022.3228, 673.8110);
	angles[12] = (0, 203.2417, 0);
	at[12] = 15;
	points[13] = (5731.4565, -6050.5513, 672.0984);
	angles[13] = (0, 213.7859, 0);
	at[13] = 15.2000;
	points[14] = (5756.2993, -6075.0396, 670.3819);
	angles[14] = (0, 224.5881, 0);
	at[14] = 15.4000;
	points[15] = (5790.2754, -6079.8423, 668.9567);
	angles[15] = (0, 255.2054, 0);
	at[15] = 15.6000;
	points[16] = (5823.7402, -6068.7012, 668.0630);
	angles[16] = (0, 280.6906, 0);
	at[16] = 15.8000;
	points[17] = (5850.7876, -6046.0635, 667.7795);
	angles[17] = (0, 302.6628, 0);
	at[17] = 16;
	points[18] = (5875.9058, -6021.1025, 667.6417);
	angles[18] = (0, 311.5926, 0);
	at[18] = 16.2000;
	points[19] = (5922.6377, -5967.9922, 667.5984);
	angles[19] = (0, 319.4840, 0);
	at[19] = 16.6000;
	points[20] = (5943.3076, -5939.7637, 667.7323);
	angles[20] = (0, 322.6720, 0);
	at[20] = 16.8000;
	points[21] = (6065.1572, -5764.5278, 668.8032);
	angles[21] = (0, 325.7580, 0);
	at[21] = 18;
	points[22] = (6141.2603, -5647.0869, 669.7284);
	angles[22] = (0, 327.7304, 0);
	at[22] = 18.8000;
	points[23] = (6421.9292, -5192.4014, 673.8347);
	angles[23] = (0, 328.4870, 0);
	at[23] = 21.8000;
	points[24] = (6438.6616, -5165.0396, 674.0866);
	angles[24] = (0, 328.5549, 0);
	at[24] = 22;
	points[25] = (6771.2993, -4616.0239, 679.2795);
	angles[25] = (0, 328.7142, 0);
	at[25] = 25.6000;
	points[26] = (6788.0317, -4588.6221, 679.5315);
	angles[26] = (0, 328.6012, 0);
	at[26] = 25.8000;
	points[27] = (7067.2051, -4135.3940, 682.0867);
	angles[27] = (0, 329.0899, 0);
	at[27] = 28.8000;
	points[28] = (7173.5825, -3950.5513, 682.0867);
	angles[28] = (0, 331.0227, 0);
	at[28] = 30;
	points[29] = (7190.1182, -3918.6221, 682.0867);
	angles[29] = (0, 332.4449, 0);
	at[29] = 30.2000;
	points[30] = (7202.4409, -3886.5317, 682.0867);
	angles[30] = (0, 338.0175, 0);
	at[30] = 30.4000;
	points[31] = (7218.9766, -3817.3389, 682.0867);
	angles[31] = (0, 346.9011, 0);
	at[31] = 30.8000;
	points[32] = (7230.0786, -3747.6733, 682.0867);
	angles[32] = (0, 351.7578, 0);
	at[32] = 31.2000;
	points[33] = (7227.9922, -3676.6772, 682.0867);
	angles[33] = (0, 363.2465, 0);
	at[33] = 31.6000;
	points[34] = (7213.8579, -3645.3779, 682.0867);
	angles[34] = (0, 382.5238, 0);
	at[34] = 31.8000;
	points[35] = (7186.6138, -3622.5393, 682.0867);
	angles[35] = (0, 402.9659, 0);
	at[35] = 32;
	points[36] = (7156.4570, -3603.6221, 682.0867);
	angles[36] = (0, 414.7693, 0);
	at[36] = 32.2000;
	points[37] = (7123.5825, -3608.1931, 682.0867);
	angles[37] = (0, 450.2811, 0);
	at[37] = 32.4000;
	points[38] = (7093.8584, -3627.6892, 682.0867);
	angles[38] = (0, 474.4212, 0);
	at[38] = 32.6000;
	points[39] = (7066.8110, -3650.2283, 682.0867);
	angles[39] = (0, 486.5826, 0);
	at[39] = 32.8000;
	points[40] = (7045.1577, -3678.2874, 682.0867);
	angles[40] = (0, 498.5045, 0);
	at[40] = 33;
	points[41] = (7024.8428, -3707.3506, 682.0867);
	angles[41] = (0, 503.2228, 0);
	at[41] = 33.2000;
	points[42] = (7008.6616, -3730.1538, 682.0867);
	angles[42] = (0, 504.0088, 0);
	at[42] = 33.4000;
	points[43] = (7008.6616, -3730.1538, 682.0867);
	angles[43] = (0, 504.0400, 0);
	at[43] = 47.8000;
	points[44] = (7005.5513, -3734.3821, 682.0867);
	angles[44] = (0, 503.9955, 0);
	at[44] = 47.9000;
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
