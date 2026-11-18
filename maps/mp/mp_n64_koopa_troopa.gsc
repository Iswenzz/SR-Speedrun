main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_koopa_troopa", 0);

	setExpFog(8858.2676, 23314.4688, 0.6039, 0.6824, 1, 0);

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
	ambientPlay("iz_0_22", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (-1832.4121, 17724.0527, 666.8326), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (-2175.9819, 17491.6211, 666.8326), 0, 12.0104);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (-4802, 284, 658);
	level.iz_route[level.iz_route.size] = (-4868, -697, 658);
	level.iz_route[level.iz_route.size] = (-5142, -1696, 658);
	level.iz_route[level.iz_route.size] = (-5399, -2223, 658);
	level.iz_route[level.iz_route.size] = (-5687, -2611, 658);
	level.iz_route[level.iz_route.size] = (-5842, -2960, 658);
	level.iz_route[level.iz_route.size] = (-5930, -3342, 658);
	level.iz_route[level.iz_route.size] = (-6004, -3716, 658);
	level.iz_route[level.iz_route.size] = (-5957, -4075, 658);
	level.iz_route[level.iz_route.size] = (-5644, -4795, 631);
	level.iz_route[level.iz_route.size] = (-5050, -5423, 658);
	level.iz_route[level.iz_route.size] = (-4408, -5721, 658);
	level.iz_route[level.iz_route.size] = (-3144, -5607, 658);
	level.iz_route[level.iz_route.size] = (-2634, -5540, 658);
	level.iz_route[level.iz_route.size] = (-1748, -5518, 658);
	level.iz_route[level.iz_route.size] = (-1123, -5690, 658);
	level.iz_route[level.iz_route.size] = (-808, -5936, 658);
	level.iz_route[level.iz_route.size] = (-611, -6210, 658);
	level.iz_route[level.iz_route.size] = (-331, -6673, 632);
	level.iz_route[level.iz_route.size] = (198, -7369, 631);
	level.iz_route[level.iz_route.size] = (864, -7819, 658);
	level.iz_route[level.iz_route.size] = (1525, -7738, 631);
	level.iz_route[level.iz_route.size] = (2568, -7575, 646);
	level.iz_route[level.iz_route.size] = (3631, -7141, 642);
	level.iz_route[level.iz_route.size] = (4342, -6416, 658);
	level.iz_route[level.iz_route.size] = (4827, -5704, 658);
	level.iz_route[level.iz_route.size] = (5187, -4977, 658);
	level.iz_route[level.iz_route.size] = (5646, -4289, 658);
	level.iz_route[level.iz_route.size] = (6022, -3496, 658);
	level.iz_route[level.iz_route.size] = (6387, -2202, 658);
	level.iz_route[level.iz_route.size] = (6507, -890, 599);
	level.iz_route[level.iz_route.size] = (6516, 182, 658);
	level.iz_route[level.iz_route.size] = (6369, 1163, 658);
	level.iz_route[level.iz_route.size] = (5644, 2201, 658);
	level.iz_route[level.iz_route.size] = (5160, 2996, 631);
	level.iz_route[level.iz_route.size] = (4905, 3606, 658);
	level.iz_route[level.iz_route.size] = (4715, 4205, 658);
	level.iz_route[level.iz_route.size] = (4424, 4698, 658);
	level.iz_route[level.iz_route.size] = (3160, 6484, 658);
	level.iz_route[level.iz_route.size] = (2838, 7444, 658);
	level.iz_route[level.iz_route.size] = (2834, 7821, 658);
	level.iz_route[level.iz_route.size] = (3108, 9146, 658);
	level.iz_route[level.iz_route.size] = (3154, 9616, 516);
	level.iz_route[level.iz_route.size] = (2888, 10120, 449);
	level.iz_route[level.iz_route.size] = (2653, 11104, 392);
	level.iz_route[level.iz_route.size] = (2637, 12595, 415);
	level.iz_route[level.iz_route.size] = (2724, 14147, 576);
	level.iz_route[level.iz_route.size] = (2831, 14677, 658);
	level.iz_route[level.iz_route.size] = (3171, 15390, 632);
	level.iz_route[level.iz_route.size] = (3250, 16369, 635);
	level.iz_route[level.iz_route.size] = (2865, 17267, 632);
	level.iz_route[level.iz_route.size] = (1972, 17993, 631);
	level.iz_route[level.iz_route.size] = (765, 18428, 631);
	level.iz_route[level.iz_route.size] = (-729, 18752, 658);
	level.iz_route[level.iz_route.size] = (-2253, 18851, 658);
	level.iz_route[level.iz_route.size] = (-3345, 18461, 686);
	level.iz_route[level.iz_route.size] = (-3651, 18300, 686);
	level.iz_route[level.iz_route.size] = (-4102, 18007, 678);
	level.iz_route[level.iz_route.size] = (-4956, 17337, 658);
	level.iz_route[level.iz_route.size] = (-6052, 15572, 658);
	level.iz_route[level.iz_route.size] = (-6616, 14927, 658);
	level.iz_route[level.iz_route.size] = (-7323, 14463, 658);
	level.iz_route[level.iz_route.size] = (-7962, 13819, 658);
	level.iz_route[level.iz_route.size] = (-8578, 12921, 631);
	level.iz_route[level.iz_route.size] = (-9211, 11211, 658);
	level.iz_route[level.iz_route.size] = (-9053, 9895, 658);
	level.iz_route[level.iz_route.size] = (-8236, 8643, 658);
	level.iz_route[level.iz_route.size] = (-6875, 7323, 658);
	level.iz_route[level.iz_route.size] = (-6070, 5970, 658);
	level.iz_route[level.iz_route.size] = (-5671, 5079, 658);
	level.iz_route[level.iz_route.size] = (-5513, 4316, 658);
	level.iz_route[level.iz_route.size] = (-5440, 3365, 658);
	level.iz_route[level.iz_route.size] = (-5238, 2519, 618);
	level.iz_route[level.iz_route.size] = (-4882, 1447, 658);
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
	points[0] = (-4908.9766, -10133.8584, 1544.2913);
	angles[0] = (0, -141.9961, 0);
	at[0] = 0;
	points[1] = (-4732.7163, -10341.6143, 1544.2913);
	angles[1] = (0, -138.8541, 0);
	at[1] = 0.5000;
	points[2] = (-4550.8271, -10527.8350, 1544.2913);
	angles[2] = (0, -134.8364, 0);
	at[2] = 1;
	points[3] = (-4348.1890, -10705.9844, 1544.2913);
	angles[3] = (0, -130.3837, 0);
	at[3] = 1.5000;
	points[4] = (-4136.8501, -10863.2676, 1544.2913);
	angles[4] = (0, -125.7222, 0);
	at[4] = 2;
	points[5] = (-3910.6458, -11003.5049, 1544.2913);
	angles[5] = (0, -120.7872, 0);
	at[5] = 2.5000;
	points[6] = (-3673.3345, -11123.3457, 1544.2913);
	angles[6] = (0, -115.7909, 0);
	at[6] = 3;
	points[7] = (-3428.1970, -11221.3789, 1544.2913);
	angles[7] = (0, -110.8108, 0);
	at[7] = 3.5000;
	points[8] = (-3173, -11298.9756, 1544.2913);
	angles[8] = (0, -105.9514, 0);
	at[8] = 4;
	points[9] = (-2913.4014, -11355.3145, 1544.2913);
	angles[9] = (0, -101.3602, 0);
	at[9] = 4.5000;
	points[10] = (-2650.8779, -11391.8105, 1544.2913);
	angles[10] = (0, -97.0963, 0);
	at[10] = 5;
	points[11] = (-2385.2285, -11410.1572, 1544.2913);
	angles[11] = (0, -93.2056, 0);
	at[11] = 5.5000;
	points[12] = (-2119.1104, -11411.9688, 1544.2913);
	angles[12] = (0, -89.7309, 0);
	at[12] = 6;
	points[13] = (-1853.9489, -11399.2129, 1544.2913);
	angles[13] = (0, -86.6779, 0);
	at[13] = 6.5000;
	points[14] = (-1589.5040, -11373.8975, 1544.2913);
	angles[14] = (0, -84.0388, 0);
	at[14] = 7;
	points[15] = (-1325.0433, -11337.8340, 1544.2913);
	angles[15] = (0, -81.8275, 0);
	at[15] = 7.5000;
	points[16] = (-1090.1378, -11296.9688, 1544.2913);
	angles[16] = (0, -79.4376, 0);
	at[16] = 8;
	points[17] = (-822.0984, -11235.9453, 1544.2913);
	angles[17] = (0, -76.8128, 0);
	at[17] = 8.5000;
	points[18] = (-567.8622, -11170.6309, 1544.2913);
	angles[18] = (0, -75.3755, 0);
	at[18] = 9;
	points[19] = (-313.7362, -11101.0234, 1544.2913);
	angles[19] = (0, -74.5344, 0);
	at[19] = 9.5000;
	points[20] = (-38.8150, -11022.0869, 1544.2913);
	angles[20] = (0, -73.8586, 0);
	at[20] = 10;
	points[21] = (202.2201, -10950.4326, 1544.2913);
	angles[21] = (0, -73.3551, 0);
	at[21] = 10.5000;
	points[22] = (456.2480, -10872.7559, 1544.2913);
	angles[22] = (0, -72.9175, 0);
	at[22] = 11;
	points[23] = (721.7520, -10789.4883, 1544.2913);
	angles[23] = (0, -72.5061, 0);
	at[23] = 11.5000;
	points[24] = (1220.3544, -10627.7959, 1544.2913);
	angles[24] = (0, -71.7905, 0);
	at[24] = 12.5000;
	points[25] = (1475.6141, -10542.4414, 1544.2913);
	angles[25] = (0, -71.4488, 0);
	at[25] = 13;
	points[26] = (1733.8425, -10454.4092, 1544.2913);
	angles[26] = (0, -71.1052, 0);
	at[26] = 13.5000;
	points[27] = (1981.7874, -10368.2676, 1544.2913);
	angles[27] = (0, -70.7713, 0);
	at[27] = 14;
	points[28] = (2483.6221, -10188.8184, 1544.2913);
	angles[28] = (0, -70.0821, 0);
	at[28] = 15;
	points[29] = (2735.4766, -10096.1416, 1544.2913);
	angles[29] = (0, -69.7168, 0);
	at[29] = 15.5000;
	points[30] = (3234.5867, -9906.6533, 1544.2913);
	angles[30] = (0, -68.9311, 0);
	at[30] = 16.5000;
	points[31] = (3727.8860, -9710.9844, 1544.2913);
	angles[31] = (0, -68.0390, 0);
	at[31] = 17.5000;
	points[32] = (3979.0945, -9607.5986, 1544.2913);
	angles[32] = (0, -67.5209, 0);
	at[32] = 18;
	points[33] = (4225.1577, -9503.5039, 1544.2913);
	angles[33] = (0, -66.9522, 0);
	at[33] = 18.5000;
	points[34] = (4465.1577, -9398.9375, 1544.2913);
	angles[34] = (0, -66.3271, 0);
	at[34] = 19;
	points[35] = (4708.8979, -9289.2129, 1544.2913);
	angles[35] = (0, -65.6173, 0);
	at[35] = 19.5000;
	points[36] = (4957.3623, -9173.0713, 1544.2913);
	angles[36] = (0, -64.7567, 0);
	at[36] = 20;
	points[37] = (5194.4487, -9057.3232, 1544.2913);
	angles[37] = (0, -63.7668, 0);
	at[37] = 20.5000;
	points[38] = (5419.9609, -8941.7324, 1544.2913);
	angles[38] = (0, -62.6202, 0);
	at[38] = 21;
	points[39] = (5670.1182, -8805.5117, 1544.2913);
	angles[39] = (0, -61.0568, 0);
	at[39] = 21.5000;
	points[40] = (5897.7954, -8671.4170, 1544.2913);
	angles[40] = (0, -59.0509, 0);
	at[40] = 22;
	points[41] = (6112.3232, -8532.1260, 1544.2913);
	angles[41] = (0, -56.4504, 0);
	at[41] = 22.5000;
	points[42] = (6339.4092, -8361.5352, 1544.2913);
	angles[42] = (0, -51.9086, 0);
	at[42] = 23;
	points[43] = (6512.3623, -8197.9141, 1544.2913);
	angles[43] = (0, -44.7786, 0);
	at[43] = 23.5000;
	points[44] = (6671.8501, -8007.5986, 1544.2913);
	angles[44] = (0, -39.2104, 0);
	at[44] = 24;
	points[45] = (6840.2754, -7777.5591, 1544.2913);
	angles[45] = (0, -35.6216, 0);
	at[45] = 24.5000;
	points[46] = (6978.9370, -7569.1733, 1544.2913);
	angles[46] = (0, -33.2578, 0);
	at[46] = 25;
	points[47] = (7121.3779, -7338.8979, 1544.2913);
	angles[47] = (0, -31.4070, 0);
	at[47] = 25.5000;
	points[48] = (7257.0869, -7105.1572, 1544.2913);
	angles[48] = (0, -29.8411, 0);
	at[48] = 26;
	points[49] = (7382.0474, -6877.9922, 1544.2913);
	angles[49] = (0, -28.5789, 0);
	at[49] = 26.5000;
	points[50] = (7507.6777, -6638.1104, 1544.2913);
	angles[50] = (0, -27.4211, 0);
	at[50] = 27;
	points[51] = (7628.3462, -6396.6929, 1544.2913);
	angles[51] = (0, -26.3474, 0);
	at[51] = 27.5000;
	points[52] = (7740.7876, -6161.7720, 1544.2913);
	angles[52] = (0, -25.3955, 0);
	at[52] = 28;
	points[53] = (7852.3623, -5918.7402, 1544.2913);
	angles[53] = (0, -24.4780, 0);
	at[53] = 28.5000;
	points[54] = (7962.5986, -5668.3076, 1544.2913);
	angles[54] = (0, -23.5767, 0);
	at[54] = 29;
	points[55] = (8063.9766, -5428.1499, 1544.2913);
	angles[55] = (0, -22.7249, 0);
	at[55] = 29.5000;
	points[56] = (8163.4648, -5182.6382, 1544.2913);
	angles[56] = (0, -21.8895, 0);
	at[56] = 30;
	points[57] = (8260.6299, -4932.3623, 1544.2913);
	angles[57] = (0, -21.0493, 0);
	at[57] = 30.5000;
	points[58] = (8353.8975, -4681.1416, 1544.2913);
	angles[58] = (0, -20.2029, 0);
	at[58] = 31;
	points[59] = (8442.2842, -4432.0474, 1544.2913);
	angles[59] = (0, -19.3637, 0);
	at[59] = 31.5000;
	points[60] = (8527.4805, -4180.0391, 1544.2913);
	angles[60] = (0, -18.5070, 0);
	at[60] = 32;
	points[61] = (8609.2129, -3925.5276, 1544.2913);
	angles[61] = (0, -17.6259, 0);
	at[61] = 32.5000;
	points[62] = (8686.7715, -3670.2756, 1544.2913);
	angles[62] = (0, -16.7175, 0);
	at[62] = 33;
	points[63] = (8760.0400, -3414.3347, 1544.2913);
	angles[63] = (0, -15.7790, 0);
	at[63] = 33.5000;
	points[64] = (8828.8584, -3157.4331, 1544.2913);
	angles[64] = (0, -14.8011, 0);
	at[64] = 34;
	points[65] = (8892.9922, -2900.0630, 1544.2913);
	angles[65] = (0, -13.7780, 0);
	at[65] = 34.5000;
	points[66] = (8952.8740, -2638.8345, 1544.2913);
	angles[66] = (0, -12.6922, 0);
	at[66] = 35;
	points[67] = (9007.4014, -2377.2915, 1544.2913);
	angles[67] = (0, -11.5378, 0);
	at[67] = 35.5000;
	points[68] = (9055.9844, -2116.7874, 1544.2913);
	angles[68] = (0, -10.3147, 0);
	at[68] = 36;
	points[69] = (9098.5039, -1856.7048, 1544.2913);
	angles[69] = (0, -9.0137, 0);
	at[69] = 36.5000;
	points[70] = (9135.5908, -1588.7244, 1544.2913);
	angles[70] = (0, -7.5778, 0);
	at[70] = 37;
	points[71] = (9165.0791, -1323.5748, 1544.2913);
	angles[71] = (0, -6.0246, 0);
	at[71] = 37.5000;
	points[72] = (9186.5752, -1061.8386, 1544.2913);
	angles[72] = (0, -4.3515, 0);
	at[72] = 38;
	points[73] = (9200.0391, -794.9764, 1544.2913);
	angles[73] = (0, -2.5071, 0);
	at[73] = 38.5000;
	points[74] = (9204.0557, -525.2284, 1544.2913);
	angles[74] = (0, -0.4152, 0);
	at[74] = 39;
	points[75] = (9197.6377, -261.4272, 1544.2913);
	angles[75] = (0, 1.8775, 0);
	at[75] = 39.5000;
	points[76] = (9181.3779, -16.3121, 1544.2913);
	angles[76] = (0, 4.3464, 0);
	at[76] = 40;
	points[77] = (9159.7246, 195.5429, 1544.2913);
	angles[77] = (0, 6.0935, 0);
	at[77] = 40.5000;
	points[78] = (9129.1338, 441.2795, 1544.2913);
	angles[78] = (0, 7.2812, 0);
	at[78] = 41;
	points[79] = (9090, 719.2874, 1544.2913);
	angles[79] = (0, 8.1605, 0);
	at[79] = 41.5000;
	points[80] = (9042.6377, 1027.9489, 1544.2913);
	angles[80] = (0, 8.8424, 0);
	at[80] = 42;
	points[81] = (8999.9609, 1290.3938, 1544.2913);
	angles[81] = (0, 9.3275, 0);
	at[81] = 42.5000;
	points[82] = (8960, 1526.7007, 1544.2913);
	angles[82] = (0, 9.6510, 0);
	at[82] = 43;
	points[83] = (8916.7715, 1774.8503, 1544.2913);
	angles[83] = (0, 9.9324, 0);
	at[83] = 43.5000;
	points[84] = (8870.3936, 2034.3662, 1544.2913);
	angles[84] = (0, 10.1847, 0);
	at[84] = 44;
	points[85] = (8820.9053, 2304.7717, 1544.2913);
	angles[85] = (0, 10.4131, 0);
	at[85] = 44.5000;
	points[86] = (8768.4258, 2585.5864, 1544.2913);
	angles[86] = (0, 10.6217, 0);
	at[86] = 45;
	points[87] = (8713.1104, 2876.3386, 1544.2913);
	angles[87] = (0, 10.8136, 0);
	at[87] = 45.5000;
	points[88] = (8664.7246, 3126.5945, 1544.2913);
	angles[88] = (0, 10.9728, 0);
	at[88] = 46;
	points[89] = (8616.6143, 3372.1416, 1544.2913);
	angles[89] = (0, 11.1080, 0);
	at[89] = 46.5000;
	points[90] = (8566.8506, 3623.2400, 1544.2913);
	angles[90] = (0, 11.2355, 0);
	at[90] = 47;
	points[91] = (8515.4727, 3879.6575, 1544.2913);
	angles[91] = (0, 11.3569, 0);
	at[91] = 47.5000;
	points[92] = (8462.4805, 4141.1416, 1544.2913);
	angles[92] = (0, 11.4730, 0);
	at[92] = 48;
	points[93] = (8407.9922, 4407.4409, 1544.2913);
	angles[93] = (0, 11.5843, 0);
	at[93] = 48.5000;
	points[94] = (8352.0469, 4678.3467, 1544.2913);
	angles[94] = (0, 11.6915, 0);
	at[94] = 49;
	points[95] = (8294.6846, 4953.5825, 1544.2913);
	angles[95] = (0, 11.7950, 0);
	at[95] = 49.5000;
	points[96] = (8237.9922, 5223.2681, 1544.2913);
	angles[96] = (0, 11.8940, 0);
	at[96] = 50;
	points[97] = (8131.1025, 5725.8271, 1544.2913);
	angles[97] = (0, 12.0656, 0);
	at[97] = 51;
	points[98] = (8020.3940, 6239.0947, 1544.2913);
	angles[98] = (0, 12.2292, 0);
	at[98] = 52;
	points[99] = (7906.1025, 6761.7324, 1544.2913);
	angles[99] = (0, 12.3873, 0);
	at[99] = 53;
	points[100] = (7728.7012, 7560.2363, 1544.2913);
	angles[100] = (0, 12.6177, 0);
	at[100] = 54.5000;
	points[101] = (7670.1968, 7820.3940, 1544.2913);
	angles[101] = (0, 12.6919, 0);
	at[101] = 55;
	points[102] = (7553.6616, 8333.8193, 1544.2913);
	angles[102] = (0, 12.8346, 0);
	at[102] = 56;
	points[103] = (7435, 8850.8662, 1544.2913);
	angles[103] = (0, 12.9769, 0);
	at[103] = 57;
	points[104] = (7253.4253, 9630.7871, 1544.2913);
	angles[104] = (0, 13.1921, 0);
	at[104] = 58.5000;
	points[105] = (7068.1890, 10412.8740, 1544.2913);
	angles[105] = (0, 13.4121, 0);
	at[105] = 60;
	points[106] = (6879.6851, 11195.1182, 1544.2913);
	angles[106] = (0, 13.6409, 0);
	at[106] = 61.5000;
	points[107] = (6752.9136, 11713.5430, 1544.2913);
	angles[107] = (0, 13.7996, 0);
	at[107] = 62.5000;
	points[108] = (6625.5117, 12228.1104, 1544.2913);
	angles[108] = (0, 13.9646, 0);
	at[108] = 63.5000;
	points[109] = (6432.6382, 12994.8428, 1544.2913);
	angles[109] = (0, 14.2273, 0);
	at[109] = 65;
	points[110] = (6296.4961, 13526.7324, 1544.2913);
	angles[110] = (0, 14.4255, 0);
	at[110] = 66;
	points[111] = (6160.6694, 14049.6055, 1544.2913);
	angles[111] = (0, 14.6375, 0);
	at[111] = 67;
	points[112] = (6025.4336, 14562.1260, 1544.2913);
	angles[112] = (0, 14.8649, 0);
	at[112] = 68;
	points[113] = (5891.0630, 15062.8350, 1544.2913);
	angles[113] = (0, 15.1106, 0);
	at[113] = 69;
	points[114] = (5824.2915, 15308.3467, 1544.2913);
	angles[114] = (0, 15.2413, 0);
	at[114] = 69.5000;
	points[115] = (5750.9453, 15575.4336, 1544.2913);
	angles[115] = (0, 15.3873, 0);
	at[115] = 70;
	points[116] = (5675.5122, 15847.1260, 1544.2913);
	angles[116] = (0, 15.5513, 0);
	at[116] = 70.5000;
	points[117] = (5600.5908, 16113.7402, 1544.2913);
	angles[117] = (0, 15.7253, 0);
	at[117] = 71;
	points[118] = (5526.2993, 16375.1191, 1544.2913);
	angles[118] = (0, 15.9096, 0);
	at[118] = 71.5000;
	points[119] = (5452.6377, 16630.9043, 1544.2913);
	angles[119] = (0, 16.1056, 0);
	at[119] = 72;
	points[120] = (5379.6460, 16880.8652, 1544.2913);
	angles[120] = (0, 16.3146, 0);
	at[120] = 72.5000;
	points[121] = (5307.4414, 17124.8027, 1544.2913);
	angles[121] = (0, 16.5379, 0);
	at[121] = 73;
	points[122] = (5236.0630, 17362.3633, 1544.2913);
	angles[122] = (0, 16.7776, 0);
	at[122] = 73.5000;
	points[123] = (5158.4644, 17616.1816, 1544.2913);
	angles[123] = (0, 17.0478, 0);
	at[123] = 74;
	points[124] = (5070.4722, 17898.2676, 1544.2913);
	angles[124] = (0, 17.3999, 0);
	at[124] = 74.5000;
	points[125] = (4984.0947, 18168.7402, 1544.2913);
	angles[125] = (0, 17.7972, 0);
	at[125] = 75;
	points[126] = (4899.4097, 18427.1270, 1544.2913);
	angles[126] = (0, 18.2417, 0);
	at[126] = 75.5000;
	points[127] = (4816.5752, 18672.8359, 1544.2913);
	angles[127] = (0, 18.7426, 0);
	at[127] = 76;
	points[128] = (4735.6299, 18905.3945, 1544.2913);
	angles[128] = (0, 19.3121, 0);
	at[128] = 76.5000;
	points[129] = (4656.7324, 19124.2129, 1544.2913);
	angles[129] = (0, 19.9658, 0);
	at[129] = 77;
	points[130] = (4547.9526, 19411.6543, 1544.2913);
	angles[130] = (0, 20.9633, 0);
	at[130] = 77.5000;
	points[131] = (4435.6299, 19688.1113, 1544.2913);
	angles[131] = (0, 22.4719, 0);
	at[131] = 78;
	points[132] = (4329.2124, 19926.9297, 1544.2913);
	angles[132] = (0, 24.5102, 0);
	at[132] = 78.5000;
	points[133] = (4229.0947, 20126.1816, 1544.2913);
	angles[133] = (0, 27.3926, 0);
	at[133] = 79;
	points[134] = (4111.1812, 20321.6152, 1544.2913);
	angles[134] = (0, 32.1224, 0);
	at[134] = 79.5000;
	points[135] = (3952.0078, 20531.6934, 1544.2913);
	angles[135] = (0, 38.3809, 0);
	at[135] = 80;
	points[136] = (3768.1655, 20728.1504, 1544.2913);
	angles[136] = (0, 44.2031, 0);
	at[136] = 80.5000;
	points[137] = (3570.0278, 20904.4082, 1544.2913);
	angles[137] = (0, 49.3229, 0);
	at[137] = 81;
	points[138] = (3361.7600, 21062.3223, 1544.2913);
	angles[138] = (0, 53.6374, 0);
	at[138] = 81.5000;
	points[139] = (3136.9292, 21209.7656, 1544.2913);
	angles[139] = (0, 57.4599, 0);
	at[139] = 82;
	points[140] = (2901.5120, 21344.6465, 1544.2913);
	angles[140] = (0, 60.8392, 0);
	at[140] = 82.5000;
	points[141] = (2669.8428, 21461.9668, 1544.2913);
	angles[141] = (0, 63.6573, 0);
	at[141] = 83;
	points[142] = (2427.6536, 21571.4180, 1544.2913);
	angles[142] = (0, 66.1554, 0);
	at[142] = 83.5000;
	points[143] = (2176.0078, 21673.1895, 1544.2913);
	angles[143] = (0, 68.4038, 0);
	at[143] = 84;
	points[144] = (1926.5040, 21763.9375, 1544.2913);
	angles[144] = (0, 70.3886, 0);
	at[144] = 84.5000;
	points[145] = (1676.2638, 21846.2617, 1544.2913);
	angles[145] = (0, 72.1254, 0);
	at[145] = 85;
	points[146] = (1420.4252, 21922.4805, 1544.2913);
	angles[146] = (0, 73.7070, 0);
	at[146] = 85.5000;
	points[147] = (1159.8701, 21992.9141, 1544.2913);
	angles[147] = (0, 75.1552, 0);
	at[147] = 86;
	points[148] = (902.1103, 22056.1426, 1544.2913);
	angles[148] = (0, 76.4638, 0);
	at[148] = 86.5000;
	points[149] = (642.9646, 22113.9766, 1544.2913);
	angles[149] = (0, 77.6548, 0);
	at[149] = 87;
	points[150] = (381.8126, 22166.8906, 1544.2913);
	angles[150] = (0, 78.7557, 0);
	at[150] = 87.5000;
	points[151] = (119.4587, 22215.1582, 1544.2913);
	angles[151] = (0, 79.7772, 0);
	at[151] = 88;
	points[152] = (-144.9252, 22259.1738, 1544.2913);
	angles[152] = (0, 80.7308, 0);
	at[152] = 88.5000;
	points[153] = (-409.1103, 22298.8984, 1544.2913);
	angles[153] = (0, 81.6219, 0);
	at[153] = 89;
	points[154] = (-672.0630, 22334.4902, 1544.2913);
	angles[154] = (0, 82.4543, 0);
	at[154] = 89.5000;
	points[155] = (-932.9725, 22366.1406, 1544.2913);
	angles[155] = (0, 83.2338, 0);
	at[155] = 90;
	points[156] = (-1203.7599, 22395.3535, 1544.2913);
	angles[156] = (0, 83.9901, 0);
	at[156] = 90.5000;
	points[157] = (-1470.7638, 22420.7480, 1544.2913);
	angles[157] = (0, 84.7106, 0);
	at[157] = 91;
	points[158] = (-1995.5552, 22461.2598, 1544.2913);
	angles[158] = (0, 86.0350, 0);
	at[158] = 92;
	points[159] = (-2270.5906, 22477.7949, 1544.2913);
	angles[159] = (0, 86.6956, 0);
	at[159] = 92.5000;
	points[160] = (-2535.7717, 22490.7480, 1544.2913);
	angles[160] = (0, 87.3277, 0);
	at[160] = 93;
	points[161] = (-2789.7954, 22500.4746, 1544.2913);
	angles[161] = (0, 87.9281, 0);
	at[161] = 93.5000;
	points[162] = (-3071.3071, 22508.1895, 1544.2913);
	angles[162] = (0, 88.5668, 0);
	at[162] = 94;
	points[163] = (-3337.9607, 22512.4395, 1544.2913);
	angles[163] = (0, 89.2170, 0);
	at[163] = 94.5000;
	points[164] = (-3588.5906, 22513.6230, 1544.2913);
	angles[164] = (0, 89.8510, 0);
	at[164] = 95;
	points[165] = (-3877.6770, 22511.2988, 1544.2913);
	angles[165] = (0, 90.6403, 0);
	at[165] = 95.5000;
	points[166] = (-4117.9922, 22505.8281, 1544.2913);
	angles[166] = (0, 91.5099, 0);
	at[166] = 96;
	points[167] = (-4362.9922, 22493.6230, 1544.2913);
	angles[167] = (0, 93.2306, 0);
	at[167] = 96.5000;
	points[168] = (-4646.4961, 22470.4727, 1544.2913);
	angles[168] = (0, 94.9782, 0);
	at[168] = 97;
	points[169] = (-4897.0474, 22443.8184, 1544.2913);
	angles[169] = (0, 96.2993, 0);
	at[169] = 97.5000;
	points[170] = (-5165.8271, 22409.7227, 1544.2913);
	angles[170] = (0, 97.4464, 0);
	at[170] = 98;
	points[171] = (-5431.4966, 22370.9453, 1544.2913);
	angles[171] = (0, 98.5160, 0);
	at[171] = 98.5000;
	points[172] = (-5690, 22328.6211, 1544.2913);
	angles[172] = (0, 99.4838, 0);
	at[172] = 99;
	points[173] = (-5957.4014, 22280.2383, 1544.2913);
	angles[173] = (0, 100.4568, 0);
	at[173] = 99.5000;
	points[174] = (-6217.9922, 22228.4668, 1544.2913);
	angles[174] = (0, 101.4262, 0);
	at[174] = 100;
	points[175] = (-6476.1812, 22172.6758, 1544.2913);
	angles[175] = (0, 102.3865, 0);
	at[175] = 100.5000;
	points[176] = (-6738.0312, 22111.3379, 1544.2913);
	angles[176] = (0, 103.3889, 0);
	at[176] = 101;
	points[177] = (-6997.0078, 22045.7090, 1544.2913);
	angles[177] = (0, 104.4344, 0);
	at[177] = 101.5000;
	points[178] = (-7252.8745, 21975.7500, 1544.2913);
	angles[178] = (0, 105.5183, 0);
	at[178] = 102;
	points[179] = (-7508.6616, 21900.2773, 1544.2913);
	angles[179] = (0, 106.6729, 0);
	at[179] = 102.5000;
	points[180] = (-7763.3462, 21819.2129, 1544.2913);
	angles[180] = (0, 107.9119, 0);
	at[180] = 103;
	points[181] = (-8015.9058, 21732.3633, 1544.2913);
	angles[181] = (0, 109.2499, 0);
	at[181] = 103.5000;
	points[182] = (-8265, 21639.7656, 1544.2913);
	angles[182] = (0, 110.7011, 0);
	at[182] = 104;
	points[183] = (-8510.6299, 21540.7070, 1544.2913);
	angles[183] = (0, 112.2842, 0);
	at[183] = 104.5000;
	points[184] = (-8757.6777, 21432.3223, 1544.2913);
	angles[184] = (0, 114.0691, 0);
	at[184] = 105;
	points[185] = (-8997.2441, 21317.3633, 1544.2913);
	angles[185] = (0, 116.0502, 0);
	at[185] = 105.5000;
	points[186] = (-9228.7793, 21195.3555, 1544.2913);
	angles[186] = (0, 118.2480, 0);
	at[186] = 106;
	points[187] = (-9463.9766, 21058.0703, 1544.2913);
	angles[187] = (0, 120.8262, 0);
	at[187] = 106.5000;
	points[188] = (-9686.2207, 20912.9531, 1544.2913);
	angles[188] = (0, 123.7701, 0);
	at[188] = 107;
	points[189] = (-9896.5752, 20757.8359, 1544.2913);
	angles[189] = (0, 127.1092, 0);
	at[189] = 107.5000;
	points[190] = (-10104.2129, 20581.8496, 1544.2913);
	angles[190] = (0, 131.1732, 0);
	at[190] = 108;
	points[191] = (-10290.8262, 20396.0254, 1544.2913);
	angles[191] = (0, 135.8840, 0);
	at[191] = 108.5000;
	points[192] = (-10460.2764, 20192.5195, 1544.2913);
	angles[192] = (0, 141.3734, 0);
	at[192] = 109;
	points[193] = (-10607.8350, 19969.2520, 1544.2913);
	angles[193] = (0, 147.9495, 0);
	at[193] = 109.5000;
	points[194] = (-10723.3857, 19734.6855, 1544.2913);
	angles[194] = (0, 155.3447, 0);
	at[194] = 110;
	points[195] = (-10795.8262, 19536.5742, 1544.2913);
	angles[195] = (0, 160.5510, 0);
	at[195] = 110.5000;
	points[196] = (-10870.6309, 19290.3945, 1544.2913);
	angles[196] = (0, 163.5464, 0);
	at[196] = 111;
	points[197] = (-10947.4014, 18998.8594, 1544.2913);
	angles[197] = (0, 165.5690, 0);
	at[197] = 111.5000;
	points[198] = (-11010.5908, 18732.2441, 1544.2913);
	angles[198] = (0, 166.9083, 0);
	at[198] = 112;
	points[199] = (-11062.4805, 18496.4961, 1544.2913);
	angles[199] = (0, 167.7191, 0);
	at[199] = 112.5000;
	points[200] = (-11114.8818, 18244.2520, 1544.2913);
	angles[200] = (0, 168.3895, 0);
	at[200] = 113;
	points[201] = (-11167.6377, 17976.2988, 1544.2913);
	angles[201] = (0, 168.9702, 0);
	at[201] = 113.5000;
	points[202] = (-11220.6299, 17693.3848, 1544.2913);
	angles[202] = (0, 169.4809, 0);
	at[202] = 114;
	points[203] = (-11270.5908, 17414.8438, 1544.2913);
	angles[203] = (0, 169.9258, 0);
	at[203] = 114.5000;
	points[204] = (-11312.6377, 17171.2207, 1544.2913);
	angles[204] = (0, 170.2634, 0);
	at[204] = 115;
	points[205] = (-11354.7246, 16919.6055, 1544.2913);
	angles[205] = (0, 170.5666, 0);
	at[205] = 115.5000;
	points[206] = (-11396.7324, 16660.4336, 1544.2913);
	angles[206] = (0, 170.8486, 0);
	at[206] = 116;
	points[207] = (-11438.6221, 16394.0547, 1544.2913);
	angles[207] = (0, 171.1130, 0);
	at[207] = 116.5000;
	points[208] = (-11480.3555, 16120.8662, 1544.2913);
	angles[208] = (0, 171.3622, 0);
	at[208] = 117;
	points[209] = (-11521.8896, 15841.2207, 1544.2913);
	angles[209] = (0, 171.5982, 0);
	at[209] = 117.5000;
	points[210] = (-11559.8818, 15578.4648, 1544.2913);
	angles[210] = (0, 171.8128, 0);
	at[210] = 118;
	points[211] = (-11595.7090, 15324.7236, 1544.2913);
	angles[211] = (0, 172.0025, 0);
	at[211] = 118.5000;
	points[212] = (-11666.4971, 14805.3145, 1544.2913);
	angles[212] = (0, 172.3608, 0);
	at[212] = 119.5000;
	points[213] = (-11735.9443, 14271.7715, 1544.2913);
	angles[213] = (0, 172.6991, 0);
	at[213] = 120.5000;
	points[214] = (-11803.8184, 13726.1025, 1544.2913);
	angles[214] = (0, 173.0226, 0);
	at[214] = 121.5000;
	points[215] = (-11865.5898, 13206.8506, 1544.2913);
	angles[215] = (0, 173.3187, 0);
	at[215] = 122.5000;
	points[216] = (-11925.4727, 12680.5518, 1544.2913);
	angles[216] = (0, 173.6060, 0);
	at[216] = 123.5000;
	points[217] = (-11983.3076, 12148.9375, 1544.2913);
	angles[217] = (0, 173.8905, 0);
	at[217] = 124.5000;
	points[218] = (-12065.4336, 11347.8740, 1544.2913);
	angles[218] = (0, 174.3171, 0);
	at[218] = 126;
	points[219] = (-12141.1025, 10551.1816, 1544.2913);
	angles[219] = (0, 174.7486, 0);
	at[219] = 127.5000;
	points[220] = (-12187.9932, 10021.4180, 1544.2913);
	angles[220] = (0, 175.0455, 0);
	at[220] = 128.5000;
	points[221] = (-12231.8105, 9494.6846, 1544.2913);
	angles[221] = (0, 175.3533, 0);
	at[221] = 129.5000;
	points[222] = (-12293.3467, 8685.5518, 1544.2913);
	angles[222] = (0, 175.8588, 0);
	at[222] = 131;
	points[223] = (-12312.0479, 8417.9141, 1544.2913);
	angles[223] = (0, 176.0388, 0);
	at[223] = 131.5000;
	points[224] = (-12346.4170, 7889.3701, 1544.2913);
	angles[224] = (0, 176.4172, 0);
	at[224] = 132.5000;
	points[225] = (-12376.4570, 7371.4961, 1544.2913);
	angles[225] = (0, 176.8248, 0);
	at[225] = 133.5000;
	points[226] = (-12390.7090, 7099.2520, 1544.2913);
	angles[226] = (0, 177.0511, 0);
	at[226] = 134;
	points[227] = (-12404.0166, 6821.7324, 1544.2913);
	angles[227] = (0, 177.3023, 0);
	at[227] = 134.5000;
	points[228] = (-12415.9062, 6548.6226, 1544.2913);
	angles[228] = (0, 177.5679, 0);
	at[228] = 135;
	points[229] = (-12426.2207, 6280.3154, 1544.2913);
	angles[229] = (0, 177.8487, 0);
	at[229] = 135.5000;
	points[230] = (-12435.0400, 6017.0869, 1544.2913);
	angles[230] = (0, 178.1466, 0);
	at[230] = 136;
	points[231] = (-12442.2441, 5759.2520, 1544.2913);
	angles[231] = (0, 178.4637, 0);
	at[231] = 136.5000;
	points[232] = (-12447.8340, 5507.1655, 1544.2913);
	angles[232] = (0, 178.8024, 0);
	at[232] = 137;
	points[233] = (-12452.0479, 5236.4175, 1544.2913);
	angles[233] = (0, 179.1861, 0);
	at[233] = 137.5000;
	points[234] = (-12454.2529, 4950.1968, 1544.2913);
	angles[234] = (0, 179.6566, 0);
	at[234] = 138;
	points[235] = (-12453.9365, 4673.7007, 1544.2913);
	angles[235] = (0, 180.1783, 0);
	at[235] = 138.5000;
	points[236] = (-12450.9844, 4407.4805, 1544.2913);
	angles[236] = (0, 180.7558, 0);
	at[236] = 139;
	points[237] = (-12445.3545, 4152.0864, 1544.2913);
	angles[237] = (0, 181.3993, 0);
	at[237] = 139.5000;
	points[238] = (-12436.9678, 3908.0947, 1544.2913);
	angles[238] = (0, 182.1220, 0);
	at[238] = 140;
	points[239] = (-12423.1504, 3630.5786, 1544.2913);
	angles[239] = (0, 183.0411, 0);
	at[239] = 140.5000;
	points[240] = (-12402.3232, 3336.9648, 1544.2913);
	angles[240] = (0, 184.3612, 0);
	at[240] = 141;
	points[241] = (-12375.8652, 3068.3071, 1544.2913);
	angles[241] = (0, 186, 0);
	at[241] = 141.5000;
	points[242] = (-12343.5830, 2826.0042, 1544.2913);
	angles[242] = (0, 188.0638, 0);
	at[242] = 142;
	points[243] = (-12304.6455, 2608.2207, 1544.2913);
	angles[243] = (0, 190.7624, 0);
	at[243] = 142.5000;
	points[244] = (-12249.8027, 2377.4487, 1544.2913);
	angles[244] = (0, 193.9475, 0);
	at[244] = 143;
	points[245] = (-12177.8340, 2128.7678, 1544.2913);
	angles[245] = (0, 196.6136, 0);
	at[245] = 143.5000;
	points[246] = (-12089.4883, 1863.2441, 1544.2913);
	angles[246] = (0, 198.7862, 0);
	at[246] = 144;
	points[247] = (-11987.6377, 1587.1141, 1544.2913);
	angles[247] = (0, 200.5783, 0);
	at[247] = 144.5000;
	points[248] = (-11897.5195, 1359.9016, 1544.2913);
	angles[248] = (0, 201.8431, 0);
	at[248] = 145;
	points[249] = (-11799.0557, 1124.3977, 1544.2913);
	angles[249] = (0, 202.8831, 0);
	at[249] = 145.5000;
	points[250] = (-11692.5986, 881.0906, 1544.2913);
	angles[250] = (0, 203.8031, 0);
	at[250] = 146;
	points[251] = (-11578.5439, 630.4764, 1544.2913);
	angles[251] = (0, 204.6250, 0);
	at[251] = 146.5000;
	points[252] = (-11457.2842, 373.0469, 1544.2913);
	angles[252] = (0, 205.3638, 0);
	at[252] = 147;
	points[253] = (-11343.4648, 138.3378, 1544.2913);
	angles[253] = (0, 205.9879, 0);
	at[253] = 147.5000;
	points[254] = (-11229.4883, -91.1287, 1544.2913);
	angles[254] = (0, 206.5157, 0);
	at[254] = 148;
	points[255] = (-11110.9844, -324.5827, 1544.2913);
	angles[255] = (0, 207, 0);
	at[255] = 148.5000;
	points[256] = (-10988.2676, -561.7166, 1544.2913);
	angles[256] = (0, 207.4507, 0);
	at[256] = 149;
	points[257] = (-10861.5352, -802.2244, 1544.2913);
	angles[257] = (0, 207.8690, 0);
	at[257] = 149.5000;
	points[258] = (-10730.9834, -1045.7953, 1544.2913);
	angles[258] = (0, 208.2592, 0);
	at[258] = 150;
	points[259] = (-10602.7959, -1281.4724, 1544.2913);
	angles[259] = (0, 208.6161, 0);
	at[259] = 150.5000;
	points[260] = (-10349.1729, -1738.6024, 1544.2913);
	angles[260] = (0, 209.2296, 0);
	at[260] = 151.5000;
	points[261] = (-10218.6611, -1969.6772, 1544.2913);
	angles[261] = (0, 209.5108, 0);
	at[261] = 152;
	points[262] = (-9951.2207, -2435.6614, 1544.2913);
	angles[262] = (0, 210.0309, 0);
	at[262] = 153;
	points[263] = (-9814.6465, -2670.1025, 1544.2913);
	angles[263] = (0, 210.2721, 0);
	at[263] = 153.5000;
	points[264] = (-9408.0713, -3355.7244, 1544.2913);
	angles[264] = (0, 210.9162, 0);
	at[264] = 155;
	points[265] = (-8853.8984, -4265.3149, 1544.2913);
	angles[265] = (0, 211.6567, 0);
	at[265] = 157;
	points[266] = (-8569.8037, -4722.1655, 1544.2913);
	angles[266] = (0, 211.9929, 0);
	at[266] = 158;
	points[267] = (-8284.7246, -5174.8423, 1544.2913);
	angles[267] = (0, 212.3103, 0);
	at[267] = 159;
	points[268] = (-8000.9058, -5620.2363, 1544.2913);
	angles[268] = (0, 212.6107, 0);
	at[268] = 160;
	points[269] = (-7859.9214, -5839.6455, 1544.2913);
	angles[269] = (0, 212.7553, 0);
	at[269] = 160.5000;
	points[270] = (-7562.9136, -6297.9531, 1544.2913);
	angles[270] = (0, 213.0502, 0);
	at[270] = 161.5000;
	points[271] = (-7415.0391, -6524.1733, 1544.2913);
	angles[271] = (0, 213.1963, 0);
	at[271] = 162;
	points[272] = (-7268.8193, -6746.6538, 1544.2913);
	angles[272] = (0, 213.3402, 0);
	at[272] = 162.5000;
	points[273] = (-7124.4487, -6965.1968, 1544.2913);
	angles[273] = (0, 213.4823, 0);
	at[273] = 163;
	points[274] = (-6982.1260, -7179.4487, 1544.2913);
	angles[274] = (0, 213.6231, 0);
	at[274] = 163.5000;
	points[275] = (-6836.0234, -7398.1494, 1544.2913);
	angles[275] = (0, 213.7657, 0);
	at[275] = 164;
	points[276] = (-6678.5830, -7632.5591, 1544.2913);
	angles[276] = (0, 213.9239, 0);
	at[276] = 164.5000;
	points[277] = (-6524.7642, -7860.1973, 1544.2913);
	angles[277] = (0, 214.0852, 0);
	at[277] = 165;
	points[278] = (-6374.8818, -8080.5903, 1544.2913);
	angles[278] = (0, 214.2483, 0);
	at[278] = 165.5000;
	points[279] = (-6229.2915, -8293.3857, 1544.2913);
	angles[279] = (0, 214.4142, 0);
	at[279] = 166;
	points[280] = (-6088.3071, -8498.1104, 1544.2913);
	angles[280] = (0, 214.5845, 0);
	at[280] = 166.5000;
	points[281] = (-5928.3467, -8728.8193, 1544.2913);
	angles[281] = (0, 214.7807, 0);
	at[281] = 167;
	points[282] = (-5764.9214, -8962.4805, 1544.2913);
	angles[282] = (0, 215.0154, 0);
	at[282] = 167.5000;
	points[283] = (-5610.7876, -9180.8662, 1544.2913);
	angles[283] = (0, 215.2703, 0);
	at[283] = 168;
	points[284] = (-5466.4961, -9383.1885, 1544.2913);
	angles[284] = (0, 215.5515, 0);
	at[284] = 168.5000;
	points[285] = (-5316.5747, -9590.9453, 1544.2913);
	angles[285] = (0, 215.8851, 0);
	at[285] = 169;
	points[286] = (-5136.2993, -9836.1816, 1544.2913);
	angles[286] = (0, 216.4598, 0);
	at[286] = 169.5000;
	points[287] = (-4984.9214, -10036.4961, 1544.2913);
	angles[287] = (0, 217.2923, 0);
	at[287] = 170;
	points[288] = (-4908.9766, -10133.8584, 1544.2913);
	angles[288] = (0, 218.0039, 0);
	at[288] = 170.3000;
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
	points[0] = (4416.2993, 21095.5527, 1544.2913);
	angles[0] = (0, 30.0218, 0);
	at[0] = 0;
	points[1] = (4269.5669, 21310.8262, 1544.2913);
	angles[1] = (0, 35.4642, 0);
	at[1] = 0.5000;
	points[2] = (4099.0942, 21514.4102, 1544.2913);
	angles[2] = (0, 41, 0);
	at[2] = 1;
	points[3] = (3906.4019, 21706.5742, 1544.2913);
	angles[3] = (0, 46.0268, 0);
	at[3] = 1.5000;
	points[4] = (3708.2520, 21875.5918, 1544.2913);
	angles[4] = (0, 50.3393, 0);
	at[4] = 2;
	points[5] = (3497.2559, 22032.5195, 1544.2913);
	angles[5] = (0, 54.0536, 0);
	at[5] = 2.5000;
	points[6] = (3271.3228, 22180.6309, 1544.2913);
	angles[6] = (0, 57.3781, 0);
	at[6] = 3;
	points[7] = (3037.9214, 22316.6934, 1544.2913);
	angles[7] = (0, 60.3316, 0);
	at[7] = 3.5000;
	points[8] = (2807.6104, 22437.3242, 1544.2913);
	angles[8] = (0, 62.8209, 0);
	at[8] = 4;
	points[9] = (2567.6379, 22551.1016, 1544.2913);
	angles[9] = (0, 65.0551, 0);
	at[9] = 4.5000;
	points[10] = (2318.9133, 22658.2285, 1544.2913);
	angles[10] = (0, 67.0851, 0);
	at[10] = 5;
	points[11] = (2069.8740, 22756.0645, 1544.2913);
	angles[11] = (0, 68.9095, 0);
	at[11] = 5.5000;
	points[12] = (1822.7126, 22845, 1544.2913);
	angles[12] = (0, 70.5105, 0);
	at[12] = 6;
	points[13] = (1570.1693, 22928.5449, 1544.2913);
	angles[13] = (0, 71.9789, 0);
	at[13] = 6.5000;
	points[14] = (1312.9921, 23006.8105, 1544.2913);
	angles[14] = (0, 73.3348, 0);
	at[14] = 7;
	points[15] = (1054.9922, 23079.1348, 1544.2913);
	angles[15] = (0, 74.5842, 0);
	at[15] = 7.5000;
	points[16] = (798.4764, 23145.4727, 1544.2913);
	angles[16] = (0, 75.7214, 0);
	at[16] = 8;
	points[17] = (539.7008, 23207.2441, 1544.2913);
	angles[17] = (0, 76.7798, 0);
	at[17] = 8.5000;
	points[18] = (279.3575, 23264.5664, 1544.2913);
	angles[18] = (0, 77.7701, 0);
	at[18] = 9;
	points[19] = (17.7083, 23317.7168, 1544.2913);
	angles[19] = (0, 78.6997, 0);
	at[19] = 9.5000;
	points[20] = (-245.7697, 23366.9688, 1544.2913);
	angles[20] = (0, 79.5796, 0);
	at[20] = 10;
	points[21] = (-508.7283, 23412.1660, 1544.2913);
	angles[21] = (0, 80.4104, 0);
	at[21] = 10.5000;
	points[22] = (-770.4606, 23453.4238, 1544.2913);
	angles[22] = (0, 81.1964, 0);
	at[22] = 11;
	points[23] = (-1030.8898, 23490.9844, 1544.2913);
	angles[23] = (0, 81.9425, 0);
	at[23] = 11.5000;
	points[24] = (-1301.0472, 23526.3789, 1544.2913);
	angles[24] = (0, 82.6791, 0);
	at[24] = 12;
	points[25] = (-1567.4606, 23557.9121, 1544.2913);
	angles[25] = (0, 83.3901, 0);
	at[25] = 12.5000;
	points[26] = (-1829.3071, 23585.7480, 1544.2913);
	angles[26] = (0, 84.0713, 0);
	at[26] = 13;
	points[27] = (-2088.1458, 23610.1953, 1544.2913);
	angles[27] = (0, 84.7277, 0);
	at[27] = 13.5000;
	points[28] = (-2364.4094, 23633.0723, 1544.2913);
	angles[28] = (0, 85.4131, 0);
	at[28] = 14;
	points[29] = (-2631.9646, 23651.9688, 1544.2913);
	angles[29] = (0, 86.0926, 0);
	at[29] = 14.5000;
	points[30] = (-2889.6929, 23667.1660, 1544.2913);
	angles[30] = (0, 86.7586, 0);
	at[30] = 15;
	points[31] = (-3159.1812, 23679.8027, 1544.2913);
	angles[31] = (0, 87.4502, 0);
	at[31] = 15.5000;
	points[32] = (-3434.7244, 23689.1328, 1544.2913);
	angles[32] = (0, 88.2272, 0);
	at[32] = 16;
	points[33] = (-3691.3267, 23694.2129, 1544.2913);
	angles[33] = (0, 89.0302, 0);
	at[33] = 16.5000;
	points[34] = (-3962.9133, 23695.3555, 1544.2913);
	angles[34] = (0, 89.9511, 0);
	at[34] = 17;
	points[35] = (-4235.7085, 23691.0254, 1544.2913);
	angles[35] = (0, 91.2017, 0);
	at[35] = 17.5000;
	points[36] = (-4467.4805, 23681.1816, 1544.2913);
	angles[36] = (0, 92.8514, 0);
	at[36] = 18;
	points[37] = (-4718.1890, 23659.7227, 1544.2913);
	angles[37] = (0, 95.3373, 0);
	at[37] = 18.5000;
	points[38] = (-5003.7402, 23624.4102, 1544.2913);
	angles[38] = (0, 97.4059, 0);
	at[38] = 19;
	points[39] = (-5250.6694, 23586.9688, 1544.2913);
	angles[39] = (0, 98.8609, 0);
	at[39] = 19.5000;
	points[40] = (-5515.1577, 23541.1016, 1544.2913);
	angles[40] = (0, 100.0656, 0);
	at[40] = 20;
	points[41] = (-5786.5352, 23488.5820, 1544.2913);
	angles[41] = (0, 101.1662, 0);
	at[41] = 20.5000;
	points[42] = (-6038.1890, 23435.4727, 1544.2913);
	angles[42] = (0, 102.0999, 0);
	at[42] = 21;
	points[43] = (-6298.5825, 23376.2207, 1544.2913);
	angles[43] = (0, 102.9904, 0);
	at[43] = 21.5000;
	points[44] = (-6566.5352, 23310.9043, 1544.2913);
	angles[44] = (0, 103.8723, 0);
	at[44] = 22;
	points[45] = (-6818.4644, 23245.5527, 1544.2913);
	angles[45] = (0, 104.7079, 0);
	at[45] = 22.5000;
	points[46] = (-7073.6616, 23175.3945, 1544.2913);
	angles[46] = (0, 105.5326, 0);
	at[46] = 23;
	points[47] = (-7332.1655, 23100.2754, 1544.2913);
	angles[47] = (0, 106.3762, 0);
	at[47] = 23.5000;
	points[48] = (-7588.7402, 23021.4961, 1544.2913);
	angles[48] = (0, 107.2408, 0);
	at[48] = 24;
	points[49] = (-7840.4331, 22940.0391, 1544.2913);
	angles[49] = (0, 108.1131, 0);
	at[49] = 24.5000;
	points[50] = (-8092.4414, 22854.0547, 1544.2913);
	angles[50] = (0, 109.0222, 0);
	at[50] = 25;
	points[51] = (-8343.8975, 22763.6211, 1544.2913);
	angles[51] = (0, 109.9780, 0);
	at[51] = 25.5000;
	points[52] = (-8593.9365, 22668.7402, 1544.2913);
	angles[52] = (0, 110.9886, 0);
	at[52] = 26;
	points[53] = (-8841.6924, 22569.4102, 1544.2913);
	angles[53] = (0, 112.0630, 0);
	at[53] = 26.5000;
	points[54] = (-9086.2998, 22465.7480, 1544.2913);
	angles[54] = (0, 113.2108, 0);
	at[54] = 27;
	points[55] = (-9326.8506, 22357.6777, 1544.2913);
	angles[55] = (0, 114.4428, 0);
	at[55] = 27.5000;
	points[56] = (-9571.2988, 22240.9844, 1544.2913);
	angles[56] = (0, 115.8093, 0);
	at[56] = 28;
	points[57] = (-9809.5273, 22119.6074, 1544.2913);
	angles[57] = (0, 117.3090, 0);
	at[57] = 28.5000;
	points[58] = (-10040.4727, 21993.6602, 1544.2913);
	angles[58] = (0, 118.9478, 0);
	at[58] = 29;
	points[59] = (-10270.2373, 21858.8984, 1544.2913);
	angles[59] = (0, 120.7759, 0);
	at[59] = 29.5000;
	points[60] = (-10499.1348, 21713.3066, 1544.2913);
	angles[60] = (0, 122.9088, 0);
	at[60] = 30;
	points[61] = (-10716.1416, 21562.5195, 1544.2913);
	angles[61] = (0, 125.3001, 0);
	at[61] = 30.5000;
	points[62] = (-10922.3623, 21404.7246, 1544.2913);
	angles[62] = (0, 127.9890, 0);
	at[62] = 31;
	points[63] = (-11131.2988, 21225.8262, 1544.2913);
	angles[63] = (0, 131.2920, 0);
	at[63] = 31.5000;
	points[64] = (-11320.9453, 21040.7090, 1544.2913);
	angles[64] = (0, 135.1372, 0);
	at[64] = 32;
	points[65] = (-11491.7715, 20846.6934, 1544.2913);
	angles[65] = (0, 139.5628, 0);
	at[65] = 32.5000;
	points[66] = (-11653.0713, 20625.5508, 1544.2913);
	angles[66] = (0, 145.1362, 0);
	at[66] = 33;
	points[67] = (-11783.6221, 20396.8516, 1544.2913);
	angles[67] = (0, 151.6845, 0);
	at[67] = 33.5000;
	points[68] = (-11873.5820, 20184.0547, 1544.2913);
	angles[68] = (0, 158.5060, 0);
	at[68] = 34;
	points[69] = (-11944.3301, 19964.7637, 1544.2913);
	angles[69] = (0, 162.7197, 0);
	at[69] = 34.5000;
	points[70] = (-12014.7637, 19701.1816, 1544.2913);
	angles[70] = (0, 165.4718, 0);
	at[70] = 35;
	points[71] = (-12084.6465, 19395.8672, 1544.2913);
	angles[71] = (0, 167.4277, 0);
	at[71] = 35.5000;
	points[72] = (-12134.3311, 19152.5996, 1544.2913);
	angles[72] = (0, 168.6553, 0);
	at[72] = 36;
	points[73] = (-12179.7246, 18911.3789, 1544.2913);
	angles[73] = (0, 169.4863, 0);
	at[73] = 36.5000;
	points[74] = (-12224.7246, 18654.5664, 1544.2913);
	angles[74] = (0, 170.1912, 0);
	at[74] = 37;
	points[75] = (-12269.2520, 18382.8730, 1544.2913);
	angles[75] = (0, 170.8051, 0);
	at[75] = 37.5000;
	points[76] = (-12313.2676, 18097.0078, 1544.2913);
	angles[76] = (0, 171.3464, 0);
	at[76] = 38;
	points[77] = (-12353.4258, 17821.1816, 1544.2913);
	angles[77] = (0, 171.8136, 0);
	at[77] = 38.5000;
	points[78] = (-12387.4404, 17575.7090, 1544.2913);
	angles[78] = (0, 172.1707, 0);
	at[78] = 39;
	points[79] = (-12421.1025, 17322.5605, 1544.2913);
	angles[79] = (0, 172.4928, 0);
	at[79] = 39.5000;
	points[80] = (-12454.2910, 17062.1660, 1544.2913);
	angles[80] = (0, 172.7919, 0);
	at[80] = 40;
	points[81] = (-12487.0088, 16794.8828, 1544.2913);
	angles[81] = (0, 173.0714, 0);
	at[81] = 40.5000;
	points[82] = (-12519.2529, 16521.0645, 1544.2913);
	angles[82] = (0, 173.3337, 0);
	at[82] = 41;
	points[83] = (-12551.0234, 16241.0635, 1544.2913);
	angles[83] = (0, 173.5810, 0);
	at[83] = 41.5000;
	points[84] = (-12580.3535, 15972.4805, 1544.2913);
	angles[84] = (0, 173.8083, 0);
	at[84] = 42;
	points[85] = (-12607.2041, 15718.3066, 1544.2913);
	angles[85] = (0, 174.0057, 0);
	at[85] = 42.5000;
	points[86] = (-12659.6055, 15198.3066, 1544.2913);
	angles[86] = (0, 174.3743, 0);
	at[86] = 43.5000;
	points[87] = (-12710.0391, 14664.5674, 1544.2913);
	angles[87] = (0, 174.7177, 0);
	at[87] = 44.5000;
	points[88] = (-12758.4648, 14118.9766, 1544.2913);
	angles[88] = (0, 175.0416, 0);
	at[88] = 45.5000;
	points[89] = (-12780.9443, 13853.0322, 1544.2913);
	angles[89] = (0, 175.1943, 0);
	at[89] = 46;
	points[90] = (-12843.6221, 13065.5908, 1544.2913);
	angles[90] = (0, 175.6170, 0);
	at[90] = 47.5000;
	points[91] = (-12882.7168, 12533.5049, 1544.2913);
	angles[91] = (0, 175.8892, 0);
	at[91] = 48.5000;
	points[92] = (-12953.8975, 11462.9531, 1544.2913);
	angles[92] = (0, 176.4213, 0);
	at[92] = 50.5000;
	points[93] = (-13000.5508, 10664.0557, 1544.2913);
	angles[93] = (0, 176.8168, 0);
	at[93] = 52;
	points[94] = (-13041.4180, 9868.9766, 1544.2913);
	angles[94] = (0, 177.2209, 0);
	at[94] = 53.5000;
	points[95] = (-13053.7012, 9605.6689, 1544.2913);
	angles[95] = (0, 177.3590, 0);
	at[95] = 54;
	points[96] = (-13076.8906, 9064.2129, 1544.2913);
	angles[96] = (0, 177.6505, 0);
	at[96] = 55;
	points[97] = (-13097.1260, 8525.9053, 1544.2913);
	angles[97] = (0, 177.9587, 0);
	at[97] = 56;
	points[98] = (-13114.0547, 7996.2993, 1544.2913);
	angles[98] = (0, 178.2833, 0);
	at[98] = 57;
	points[99] = (-13127.5986, 7477.1655, 1544.2913);
	angles[99] = (0, 178.6284, 0);
	at[99] = 58;
	points[100] = (-13133.3467, 7208.3462, 1544.2913);
	angles[100] = (0, 178.8156, 0);
	at[100] = 58.5000;
	points[101] = (-13138.3076, 6929.6060, 1544.2913);
	angles[101] = (0, 179.0246, 0);
	at[101] = 59;
	points[102] = (-13142.1260, 6655.2363, 1544.2913);
	angles[102] = (0, 179.2445, 0);
	at[102] = 59.5000;
	points[103] = (-13144.8027, 6385.5117, 1544.2913);
	angles[103] = (0, 179.4755, 0);
	at[103] = 60;
	points[104] = (-13146.3389, 6120.7480, 1544.2913);
	angles[104] = (0, 179.7189, 0);
	at[104] = 60.5000;
	points[105] = (-13146.6924, 5861.2207, 1544.2913);
	angles[105] = (0, 179.9763, 0);
	at[105] = 61;
	points[106] = (-13143.7012, 5352.2046, 1544.2913);
	angles[106] = (0, 180.5424, 0);
	at[106] = 62;
	points[107] = (-13139.4893, 5062.0864, 1544.2913);
	angles[107] = (0, 180.9077, 0);
	at[107] = 62.5000;
	points[108] = (-13133.4648, 4781.4175, 1544.2913);
	angles[108] = (0, 181.3175, 0);
	at[108] = 63;
	points[109] = (-13125.5518, 4510.6694, 1544.2913);
	angles[109] = (0, 181.7678, 0);
	at[109] = 63.5000;
	points[110] = (-13115.7490, 4250.3936, 1544.2913);
	angles[110] = (0, 182.2653, 0);
	at[110] = 64;
	points[111] = (-13103.9766, 4001.1416, 1544.2913);
	angles[111] = (0, 182.8192, 0);
	at[111] = 64.5000;
	points[112] = (-13090.1572, 3761.7952, 1544.2913);
	angles[112] = (0, 183.4415, 0);
	at[112] = 65;
	points[113] = (-13067.9131, 3454.5867, 1544.2913);
	angles[113] = (0, 184.3589, 0);
	at[113] = 65.5000;
	points[114] = (-13041.7715, 3171.5078, 1544.2913);
	angles[114] = (0, 185.5423, 0);
	at[114] = 66;
	points[115] = (-13011.6533, 2913.9172, 1544.2913);
	angles[115] = (0, 187.0092, 0);
	at[115] = 66.5000;
	points[116] = (-12977.4023, 2683.1653, 1544.2913);
	angles[116] = (0, 188.8742, 0);
	at[116] = 67;
	points[117] = (-12935.3154, 2463.3269, 1544.2913);
	angles[117] = (0, 191.3885, 0);
	at[117] = 67.5000;
	points[118] = (-12877.4814, 2223.0198, 1544.2913);
	angles[118] = (0, 194, 0);
	at[118] = 68;
	points[119] = (-12804.8818, 1966.2638, 1544.2913);
	angles[119] = (0, 196.1690, 0);
	at[119] = 68.5000;
	points[120] = (-12718.3076, 1694.0709, 1544.2913);
	angles[120] = (0, 197.9716, 0);
	at[120] = 69;
	points[121] = (-12628.7012, 1436.0315, 1544.2913);
	angles[121] = (0, 199.4237, 0);
	at[121] = 69.5000;
	points[122] = (-12541.9297, 1201.4213, 1544.2913);
	angles[122] = (0, 200.4895, 0);
	at[122] = 70;
	points[123] = (-12447.6387, 958.8898, 1544.2913);
	angles[123] = (0, 201.4180, 0);
	at[123] = 70.5000;
	points[124] = (-12346.1807, 708.9331, 1544.2913);
	angles[124] = (0, 202.2481, 0);
	at[124] = 71;
	points[125] = (-12127.2832, 198.0217, 1544.2913);
	angles[125] = (0, 203.6639, 0);
	at[125] = 72;
	points[126] = (-12023.4248, -34.1113, 1544.2913);
	angles[126] = (0, 204.2104, 0);
	at[126] = 72.5000;
	points[127] = (-11915.1973, -270.3713, 1544.2913);
	angles[127] = (0, 204.7054, 0);
	at[127] = 73;
	points[128] = (-11802.8740, -510.4410, 1544.2913);
	angles[128] = (0, 205.1645, 0);
	at[128] = 73.5000;
	points[129] = (-11686.6543, -753.9961, 1544.2913);
	angles[129] = (0, 205.5919, 0);
	at[129] = 74;
	points[130] = (-11445.7480, -1245.7047, 1544.2913);
	angles[130] = (0, 206.3629, 0);
	at[130] = 75;
	points[131] = (-11329.3701, -1477.7953, 1544.2913);
	angles[131] = (0, 206.6912, 0);
	at[131] = 75.5000;
	points[132] = (-11089.1738, -1947.4331, 1544.2913);
	angles[132] = (0, 207.2889, 0);
	at[132] = 76.5000;
	points[133] = (-10965.7080, -2184.4844, 1544.2913);
	angles[133] = (0, 207.5653, 0);
	at[133] = 77;
	points[134] = (-10712.9531, -2661.7952, 1544.2913);
	angles[134] = (0, 208.0797, 0);
	at[134] = 78;
	points[135] = (-10460.2764, -3129.4766, 1544.2913);
	angles[135] = (0, 208.5404, 0);
	at[135] = 79;
	points[136] = (-10203.8584, -3595.5591, 1544.2913);
	angles[136] = (0, 208.9619, 0);
	at[136] = 80;
	points[137] = (-9812.8350, -4291.8896, 1544.2913);
	angles[137] = (0, 209.5413, 0);
	at[137] = 81.5000;
	points[138] = (-9545.4727, -4759.2129, 1544.2913);
	angles[138] = (0, 209.9040, 0);
	at[138] = 82.5000;
	points[139] = (-9277.5586, -5220.7876, 1544.2913);
	angles[139] = (0, 210.2494, 0);
	at[139] = 83.5000;
	points[140] = (-8875.1963, -5902.6382, 1544.2913);
	angles[140] = (0, 210.7431, 0);
	at[140] = 85;
	points[141] = (-8594.2910, -6370.8267, 1544.2913);
	angles[141] = (0, 211.0802, 0);
	at[141] = 86;
	points[142] = (-8455.6699, -6599.5669, 1544.2913);
	angles[142] = (0, 211.2471, 0);
	at[142] = 86.5000;
	points[143] = (-8318.5430, -6824.3701, 1544.2913);
	angles[143] = (0, 211.4134, 0);
	at[143] = 87;
	points[144] = (-8047.5981, -7264.2915, 1544.2913);
	angles[144] = (0, 211.7473, 0);
	at[144] = 88;
	points[145] = (-7898.3862, -7504.0947, 1544.2913);
	angles[145] = (0, 211.9344, 0);
	at[145] = 88.5000;
	points[146] = (-7752.2441, -7737.1655, 1544.2913);
	angles[146] = (0, 212.1291, 0);
	at[146] = 89;
	points[147] = (-7609.4487, -7963.1104, 1544.2913);
	angles[147] = (0, 212.3286, 0);
	at[147] = 89.5000;
	points[148] = (-7470.3540, -8181.4961, 1544.2913);
	angles[148] = (0, 212.5342, 0);
	at[148] = 90;
	points[149] = (-7335.2754, -8391.8906, 1544.2913);
	angles[149] = (0, 212.7480, 0);
	at[149] = 90.5000;
	points[150] = (-7183.5825, -8625.9844, 1544.2913);
	angles[150] = (0, 212.9952, 0);
	at[150] = 91;
	points[151] = (-7028.2681, -8863.0703, 1544.2913);
	angles[151] = (0, 213.2935, 0);
	at[151] = 91.5000;
	points[152] = (-6880.7480, -9085.5117, 1544.2913);
	angles[152] = (0, 213.6219, 0);
	at[152] = 92;
	points[153] = (-6741.6538, -9292.4414, 1544.2913);
	angles[153] = (0, 213.9890, 0);
	at[153] = 92.5000;
	points[154] = (-6594.7241, -9507.4414, 1544.2913);
	angles[154] = (0, 214.4327, 0);
	at[154] = 93;
	points[155] = (-6423.5435, -9752.0078, 1544.2913);
	angles[155] = (0, 215.1679, 0);
	at[155] = 93.5000;
	points[156] = (-6275.0786, -9956.8115, 1544.2913);
	angles[156] = (0, 216.1998, 0);
	at[156] = 94;
	points[157] = (-6137.2046, -10136.6143, 1544.2913);
	angles[157] = (0, 217.9007, 0);
	at[157] = 94.5000;
	points[158] = (-5966.6533, -10338.1494, 1544.2913);
	angles[158] = (0, 220.8460, 0);
	at[158] = 95;
	points[159] = (-5782.5591, -10534.5674, 1544.2913);
	angles[159] = (0, 223.6933, 0);
	at[159] = 95.5000;
	points[160] = (-5593.9370, -10718.3066, 1544.2913);
	angles[160] = (0, 226.2320, 0);
	at[160] = 96;
	points[161] = (-5394.7637, -10896.8896, 1544.2913);
	angles[161] = (0, 228.5613, 0);
	at[161] = 96.5000;
	points[162] = (-5190.4722, -11066.5352, 1544.2913);
	angles[162] = (0, 230.7108, 0);
	at[162] = 97;
	points[163] = (-4979.9604, -11229.1338, 1544.2913);
	angles[163] = (0, 232.7086, 0);
	at[163] = 97.5000;
	points[164] = (-4763.4253, -11385.1182, 1544.2913);
	angles[164] = (0, 234.6056, 0);
	at[164] = 98;
	points[165] = (-4542.9136, -11533.5430, 1544.2913);
	angles[165] = (0, 236.4117, 0);
	at[165] = 98.5000;
	points[166] = (-4317.7954, -11675.1963, 1544.2913);
	angles[166] = (0, 238.1600, 0);
	at[166] = 99;
	points[167] = (-4087.7168, -11810.5518, 1544.2913);
	angles[167] = (0, 239.8778, 0);
	at[167] = 99.5000;
	points[168] = (-3854.8110, -11938.3857, 1544.2913);
	angles[168] = (0, 241.5799, 0);
	at[168] = 100;
	points[169] = (-3617.5315, -12059.5664, 1544.2913);
	angles[169] = (0, 243.2900, 0);
	at[169] = 100.5000;
	points[170] = (-3376.2480, -12173.6611, 1544.2913);
	angles[170] = (0, 245.0494, 0);
	at[170] = 101;
	points[171] = (-3134.4724, -12278.8184, 1544.2913);
	angles[171] = (0, 246.8520, 0);
	at[171] = 101.5000;
	points[172] = (-2883.8899, -12378.1104, 1544.2913);
	angles[172] = (0, 248.7889, 0);
	at[172] = 102;
	points[173] = (-2636.4607, -12466.1426, 1544.2913);
	angles[173] = (0, 250.8437, 0);
	at[173] = 102.5000;
	points[174] = (-2378.5789, -12546.7324, 1544.2913);
	angles[174] = (0, 253.1311, 0);
	at[174] = 103;
	points[175] = (-2124.5669, -12614.0947, 1544.2913);
	angles[175] = (0, 255.6931, 0);
	at[175] = 103.5000;
	points[176] = (-1860.4213, -12670.0391, 1544.2913);
	angles[176] = (0, 258.6875, 0);
	at[176] = 104;
	points[177] = (-1602.0315, -12708.7012, 1544.2913);
	angles[177] = (0, 262.2684, 0);
	at[177] = 104.5000;
	points[178] = (-1331.1534, -12728.6221, 1544.2913);
	angles[178] = (0, 266.8256, 0);
	at[178] = 105;
	points[179] = (-1083.8661, -12723.1895, 1544.2913);
	angles[179] = (0, 272.6571, 0);
	at[179] = 105.5000;
	points[180] = (-842.8307, -12692.9922, 1544.2913);
	angles[180] = (0, 277.8645, 0);
	at[180] = 106;
	points[181] = (-551.2205, -12638.8193, 1544.2913);
	angles[181] = (0, 281.0069, 0);
	at[181] = 106.5000;
	points[182] = (-313.5232, -12586.4570, 1544.2913);
	angles[182] = (0, 282.6587, 0);
	at[182] = 107;
	points[183] = (-52.8315, -12523.3076, 1544.2913);
	angles[183] = (0, 283.8202, 0);
	at[183] = 107.5000;
	points[184] = (225.3295, -12450.8672, 1544.2913);
	angles[184] = (0, 284.7717, 0);
	at[184] = 108;
	points[185] = (466.9685, -12384.4883, 1544.2913);
	angles[185] = (0, 285.4767, 0);
	at[185] = 108.5000;
	points[186] = (719.7048, -12312.2051, 1544.2913);
	angles[186] = (0, 286.0753, 0);
	at[186] = 109;
	points[187] = (1243.5669, -12154.3311, 1544.2913);
	angles[187] = (0, 287.1248, 0);
	at[187] = 110;
	points[188] = (1490.3149, -12076.6543, 1544.2913);
	angles[188] = (0, 287.5594, 0);
	at[188] = 110.5000;
	points[189] = (1742.2953, -11995.2754, 1544.2913);
	angles[189] = (0, 287.9721, 0);
	at[189] = 111;
	points[190] = (1998.6969, -11910.5127, 1544.2913);
	angles[190] = (0, 288.3737, 0);
	at[190] = 111.5000;
	points[191] = (2257.0198, -11823.1504, 1544.2913);
	angles[191] = (0, 288.7680, 0);
	at[191] = 112;
	points[192] = (2755.1101, -11649.1338, 1544.2913);
	angles[192] = (0, 289.5127, 0);
	at[192] = 113;
	points[193] = (3508.6497, -11372.0078, 1544.2913);
	angles[193] = (0, 290.6537, 0);
	at[193] = 114.5000;
	points[194] = (4006.2993, -11179.2129, 1544.2913);
	angles[194] = (0, 291.4666, 0);
	at[194] = 115.5000;
	points[195] = (4497.3228, -10980.4727, 1544.2913);
	angles[195] = (0, 292.3543, 0);
	at[195] = 116.5000;
	points[196] = (4748.5039, -10875.1182, 1544.2913);
	angles[196] = (0, 292.8557, 0);
	at[196] = 117;
	points[197] = (4995.0396, -10769.0547, 1544.2913);
	angles[197] = (0, 293.3949, 0);
	at[197] = 117.5000;
	points[198] = (5236.1416, -10662.4404, 1544.2913);
	angles[198] = (0, 293.9753, 0);
	at[198] = 118;
	points[199] = (5471.0239, -10555.5117, 1544.2913);
	angles[199] = (0, 294.6042, 0);
	at[199] = 118.5000;
	points[200] = (5722.1655, -10437.4404, 1544.2913);
	angles[200] = (0, 295.3432, 0);
	at[200] = 119;
	points[201] = (5965.9053, -10318.5039, 1544.2913);
	angles[201] = (0, 296.1946, 0);
	at[201] = 119.5000;
	points[202] = (6198.8584, -10200.0791, 1544.2913);
	angles[202] = (0, 297.1534, 0);
	at[202] = 120;
	points[203] = (6423.5039, -10080.5127, 1544.2913);
	angles[203] = (0, 298.2465, 0);
	at[203] = 120.5000;
	points[204] = (6672.3623, -9940.3936, 1544.2913);
	angles[204] = (0, 299.7218, 0);
	at[204] = 121;
	points[205] = (6900.5513, -9802.4805, 1544.2913);
	angles[205] = (0, 301.5595, 0);
	at[205] = 121.5000;
	points[206] = (7106.2598, -9667.3232, 1544.2913);
	angles[206] = (0, 303.8277, 0);
	at[206] = 122;
	points[207] = (7340.1968, -9493.9365, 1544.2913);
	angles[207] = (0, 307.4577, 0);
	at[207] = 122.5000;
	points[208] = (7531.7720, -9323.1104, 1544.2913);
	angles[208] = (0, 313.1565, 0);
	at[208] = 123;
	points[209] = (7682.7559, -9148.3076, 1544.2913);
	angles[209] = (0, 320.4856, 0);
	at[209] = 123.5000;
	points[210] = (7835.1973, -8932.7168, 1544.2913);
	angles[210] = (0, 325.5397, 0);
	at[210] = 124;
	points[211] = (7979.8032, -8696.6924, 1544.2913);
	angles[211] = (0, 329.1596, 0);
	at[211] = 124.5000;
	points[212] = (8102.6382, -8473.7002, 1544.2913);
	angles[212] = (0, 331.5526, 0);
	at[212] = 125;
	points[213] = (8226.1416, -8229.7637, 1544.2913);
	angles[213] = (0, 333.5058, 0);
	at[213] = 125.5000;
	points[214] = (8340.9053, -7985.5908, 1544.2913);
	angles[214] = (0, 335.1378, 0);
	at[214] = 126;
	points[215] = (8445.1182, -7749.4097, 1544.2913);
	angles[215] = (0, 336.4312, 0);
	at[215] = 126.5000;
	points[216] = (8548.6221, -7501.0239, 1544.2913);
	angles[216] = (0, 337.5966, 0);
	at[216] = 127;
	points[217] = (8650.1582, -7243.7798, 1544.2913);
	angles[217] = (0, 338.6721, 0);
	at[217] = 127.5000;
	points[218] = (8740.5908, -7002.7954, 1544.2913);
	angles[218] = (0, 339.6003, 0);
	at[218] = 128;
	points[219] = (8829.6855, -6754.0947, 1544.2913);
	angles[219] = (0, 340.4610, 0);
	at[219] = 128.5000;
	points[220] = (8917.1260, -6498.2676, 1544.2913);
	angles[220] = (0, 341.2863, 0);
	at[220] = 129;
	points[221] = (9000.9443, -6241.5356, 1544.2913);
	angles[221] = (0, 342.0785, 0);
	at[221] = 129.5000;
	points[222] = (9078.8584, -5991.8896, 1544.2913);
	angles[222] = (0, 342.8110, 0);
	at[222] = 130;
	points[223] = (9154.7246, -5737.6377, 1544.2913);
	angles[223] = (0, 343.5260, 0);
	at[223] = 130.5000;
	points[224] = (9298.8975, -5219.7637, 1544.2913);
	angles[224] = (0, 344.9352, 0);
	at[224] = 131.5000;
	points[225] = (9428.5430, -4706.3779, 1544.2913);
	angles[225] = (0, 346.3024, 0);
	at[225] = 132.5000;
	points[226] = (9546.8896, -4185.1968, 1544.2913);
	angles[226] = (0, 347.6973, 0);
	at[226] = 133.5000;
	points[227] = (9651.8896, -3663.0315, 1544.2913);
	angles[227] = (0, 349.1427, 0);
	at[227] = 134.5000;
	points[228] = (9742.8740, -3140.1577, 1544.2913);
	angles[228] = (0, 350.6738, 0);
	at[228] = 135.5000;
	points[229] = (9783.3857, -2874.7324, 1544.2913);
	angles[229] = (0, 351.4921, 0);
	at[229] = 136;
	points[230] = (9819.8037, -2609.5198, 1544.2913);
	angles[230] = (0, 352.3537, 0);
	at[230] = 136.5000;
	points[231] = (9851.8506, -2346, 1544.2913);
	angles[231] = (0, 353.2566, 0);
	at[231] = 137;
	points[232] = (9879.2520, -2084.6418, 1544.2913);
	angles[232] = (0, 354.2062, 0);
	at[232] = 137.5000;
	points[233] = (9902.6377, -1816.5789, 1544.2913);
	angles[233] = (0, 355.2321, 0);
	at[233] = 138;
	points[234] = (9920.8662, -1547.7953, 1544.2913);
	angles[234] = (0, 356.3522, 0);
	at[234] = 138.5000;
	points[235] = (9933.3467, -1283.0236, 1544.2913);
	angles[235] = (0, 357.5499, 0);
	at[235] = 139;
	points[236] = (9939.8428, -1022.8190, 1544.2913);
	angles[236] = (0, 358.8346, 0);
	at[236] = 139.5000;
	points[237] = (9939.9609, -751.4449, 1544.2913);
	angles[237] = (0, 360.2785, 0);
	at[237] = 140;
	points[238] = (9932.5596, -481.6181, 1544.2913);
	angles[238] = (0, 361.9095, 0);
	at[238] = 140.5000;
	points[239] = (9917.3623, -219.2039, 1544.2913);
	angles[239] = (0, 363.6974, 0);
	at[239] = 141;
	points[240] = (9894.8818, 26.8126, 1544.2913);
	angles[240] = (0, 365.6461, 0);
	at[240] = 141.5000;
	points[241] = (9869.4883, 236.6791, 1544.2913);
	angles[241] = (0, 367.1339, 0);
	at[241] = 142;
	points[242] = (9835.5508, 477.7599, 1544.2913);
	angles[242] = (0, 368.1790, 0);
	at[242] = 142.5000;
	points[243] = (9793.4648, 748.6536, 1544.2913);
	angles[243] = (0, 368.9675, 0);
	at[243] = 143;
	points[244] = (9743.4648, 1047.9646, 1544.2913);
	angles[244] = (0, 369.5875, 0);
	at[244] = 143.5000;
	points[245] = (9692.4805, 1337.7834, 1544.2913);
	angles[245] = (0, 370.0712, 0);
	at[245] = 144;
	points[246] = (9650.2363, 1569.7401, 1544.2913);
	angles[246] = (0, 370.3776, 0);
	at[246] = 144.5000;
	points[247] = (9604.7637, 1812.9135, 1544.2913);
	angles[247] = (0, 370.6371, 0);
	at[247] = 145;
	points[248] = (9556.2207, 2066.8701, 1544.2913);
	angles[248] = (0, 370.8704, 0);
	at[248] = 145.5000;
	points[249] = (9504.6064, 2331.1890, 1544.2913);
	angles[249] = (0, 371.0826, 0);
	at[249] = 146;
	points[250] = (9450.1182, 2605.4487, 1544.2913);
	angles[250] = (0, 371.2770, 0);
	at[250] = 146.5000;
	points[251] = (9334.8037, 3172.0710, 1544.2913);
	angles[251] = (0, 371.6214, 0);
	at[251] = 147.5000;
	points[252] = (9284.6846, 3413.3899, 1544.2913);
	angles[252] = (0, 371.7524, 0);
	at[252] = 148;
	points[253] = (9232.9141, 3660.0867, 1544.2913);
	angles[253] = (0, 371.8721, 0);
	at[253] = 148.5000;
	points[254] = (9179.5664, 3911.9451, 1544.2913);
	angles[254] = (0, 371.9859, 0);
	at[254] = 149;
	points[255] = (9124.6465, 4168.7402, 1544.2913);
	angles[255] = (0, 372.0949, 0);
	at[255] = 149.5000;
	points[256] = (9068.1895, 4430.2363, 1544.2913);
	angles[256] = (0, 372.1996, 0);
	at[256] = 150;
	points[257] = (9010.2754, 4696.2603, 1544.2913);
	angles[257] = (0, 372.3005, 0);
	at[257] = 150.5000;
	points[258] = (8830.1572, 5510.7085, 1544.2913);
	angles[258] = (0, 372.5834, 0);
	at[258] = 152;
	points[259] = (8717.3232, 6011.7720, 1544.2913);
	angles[259] = (0, 372.7419, 0);
	at[259] = 153;
	points[260] = (8659.5273, 6266.1812, 1544.2913);
	angles[260] = (0, 372.8182, 0);
	at[260] = 153.5000;
	points[261] = (8541.2207, 6781.9683, 1544.2913);
	angles[261] = (0, 372.9673, 0);
	at[261] = 154.5000;
	points[262] = (8419.6455, 7306.0635, 1544.2913);
	angles[262] = (0, 373.1129, 0);
	at[262] = 155.5000;
	points[263] = (8232.2441, 8102.4014, 1544.2913);
	angles[263] = (0, 373.3267, 0);
	at[263] = 157;
	points[264] = (8048.5830, 8870.5117, 1544.2913);
	angles[264] = (0, 373.5280, 0);
	at[264] = 158.5000;
	points[265] = (7860.3149, 9645.7480, 1544.2913);
	angles[265] = (0, 373.7296, 0);
	at[265] = 160;
	points[266] = (7603.5435, 10684.3701, 1544.2913);
	angles[266] = (0, 374.0045, 0);
	at[266] = 162;
	points[267] = (7340.8657, 11724.8027, 1544.2913);
	angles[267] = (0, 374.2932, 0);
	at[267] = 164;
	points[268] = (7074.9604, 12755.3145, 1544.2913);
	angles[268] = (0, 374.6025, 0);
	at[268] = 166;
	points[269] = (6874.6064, 13516.2988, 1544.2913);
	angles[269] = (0, 374.8527, 0);
	at[269] = 167.5000;
	points[270] = (6732.4409, 14047.8350, 1544.2913);
	angles[270] = (0, 375.0404, 0);
	at[270] = 168.5000;
	points[271] = (6590.5908, 14571.1016, 1544.2913);
	angles[271] = (0, 375.2419, 0);
	at[271] = 169.5000;
	points[272] = (6449.2915, 15084.7246, 1544.2913);
	angles[272] = (0, 375.4573, 0);
	at[272] = 170.5000;
	points[273] = (6378.9766, 15337.4805, 1544.2913);
	angles[273] = (0, 375.5712, 0);
	at[273] = 171;
	points[274] = (6308.8979, 15587.4023, 1544.2913);
	angles[274] = (0, 375.6893, 0);
	at[274] = 171.5000;
	points[275] = (6169.0947, 16079.7246, 1544.2913);
	angles[275] = (0, 375.9409, 0);
	at[275] = 172.5000;
	points[276] = (6090.1968, 16353.8184, 1544.2913);
	angles[276] = (0, 376.0898, 0);
	at[276] = 173;
	points[277] = (6011.8110, 16623.2676, 1544.2913);
	angles[277] = (0, 376.2510, 0);
	at[277] = 173.5000;
	points[278] = (5934.0156, 16887.8750, 1544.2913);
	angles[278] = (0, 376.4214, 0);
	at[278] = 174;
	points[279] = (5856.8506, 17147.3633, 1544.2913);
	angles[279] = (0, 376.6017, 0);
	at[279] = 174.5000;
	points[280] = (5780.3154, 17401.4961, 1544.2913);
	angles[280] = (0, 376.7930, 0);
	at[280] = 175;
	points[281] = (5704.5669, 17650.0801, 1544.2913);
	angles[281] = (0, 376.9966, 0);
	at[281] = 175.5000;
	points[282] = (5629.5278, 17892.8750, 1544.2913);
	angles[282] = (0, 377.2137, 0);
	at[282] = 176;
	points[283] = (5555.3545, 18129.5664, 1544.2913);
	angles[283] = (0, 377.4462, 0);
	at[283] = 176.5000;
	points[284] = (5475.2759, 18381.1816, 1544.2913);
	angles[284] = (0, 377.7060, 0);
	at[284] = 177;
	points[285] = (5384.0156, 18662.6387, 1544.2913);
	angles[285] = (0, 378.0437, 0);
	at[285] = 177.5000;
	points[286] = (5294.2915, 18933.1504, 1544.2913);
	angles[286] = (0, 378.4233, 0);
	at[286] = 178;
	points[287] = (5206.3384, 19192.2441, 1544.2913);
	angles[287] = (0, 378.8456, 0);
	at[287] = 178.5000;
	points[288] = (5120.1968, 19439.4082, 1544.2913);
	angles[288] = (0, 379.3182, 0);
	at[288] = 179;
	points[289] = (5035.9448, 19674.1738, 1544.2913);
	angles[289] = (0, 379.8514, 0);
	at[289] = 179.5000;
	points[290] = (4953.7402, 19896.1016, 1544.2913);
	angles[290] = (0, 380.4579, 0);
	at[290] = 180;
	points[291] = (4853.7402, 20155.3164, 1544.2913);
	angles[291] = (0, 381.2551, 0);
	at[291] = 180.5000;
	points[292] = (4736.1812, 20442.7559, 1544.2913);
	angles[292] = (0, 382.5523, 0);
	at[292] = 181;
	points[293] = (4624.3306, 20695.5918, 1544.2913);
	angles[293] = (0, 384.2689, 0);
	at[293] = 181.5000;
	points[294] = (4518.5830, 20912.0859, 1544.2913);
	angles[294] = (0, 386.5958, 0);
	at[294] = 182;
	points[295] = (4416.2993, 21095.5527, 1544.2913);
	angles[295] = (0, 390.0219, 0);
	at[295] = 182.5170;
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
	points[0] = (5973.6616, 120.4657, 631.1181);
	angles[0] = (0, -176.1624, 0);
	at[0] = 0;
	points[1] = (6278.5825, 140.8941, 627.9528);
	angles[1] = (0, -176.3434, 0);
	at[1] = 1.1500;
	points[2] = (6781.5356, 173.5366, 597.4921);
	angles[2] = (0, -176.2681, 0);
	at[2] = 3.0500;
	points[3] = (6781.5356, 173.5366, 597.4921);
	angles[3] = (0, -176.2681, 0);
	at[3] = 3.8000;
	points[4] = (6766.2603, 172.5410, 598.4213);
	angles[4] = (0, -176.2681, 0);
	at[4] = 3.8500;
	points[5] = (6276.5352, 140.7646, 628.0748);
	angles[5] = (0, -176.3434, 0);
	at[5] = 5.7000;
	points[6] = (5971.6533, 120.3295, 631.1339);
	angles[6] = (0, -176.1624, 0);
	at[6] = 6.8500;
	points[7] = (5967.2051, 120.0331, 631.1772);
	angles[7] = (0, -176.1624, 0);
	at[7] = 6.9000;
	points[8] = (5967.2051, 120.0331, 631.1772);
	angles[8] = (0, -176.1624, 0);
	at[8] = 7.6000;
	points[9] = (5973.6616, 120.4657, 631.1181);
	angles[9] = (0, -176.1624, 0);
	at[9] = 7.6333;
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
	points[0] = (2617.4688, 10827.1260, 386.8004);
	angles[0] = (0, -159.3735, 0);
	at[0] = 0;
	points[1] = (3015.2915, 10976.8506, 376.4413);
	angles[1] = (0, -159.3735, 0);
	at[1] = 1.6000;
	points[2] = (3027.7244, 10981.5352, 376.1177);
	angles[2] = (0, -162.2229, 0);
	at[2] = 1.6500;
	points[3] = (3419.9370, 11107.2832, 381.3866);
	angles[3] = (0, -162.3314, 0);
	at[3] = 3.2000;
	points[4] = (3596.6931, 11163.5830, 367.5276);
	angles[4] = (0, -162.3314, 0);
	at[4] = 3.9000;
	points[5] = (3605.1104, 11166.2598, 366.8705);
	angles[5] = (0, -162.3314, 0);
	at[5] = 3.9500;
	points[6] = (3605.1104, 11166.2598, 366.8705);
	angles[6] = (0, -162.3314, 0);
	at[6] = 4.6500;
	points[7] = (3600.4766, 11164.8037, 367.2323);
	angles[7] = (0, -162.3314, 0);
	at[7] = 4.7000;
	points[8] = (3411.0747, 11104.4492, 381.2677);
	angles[8] = (0, -162.2229, 0);
	at[8] = 5.4500;
	points[9] = (3031.5159, 10982.7559, 376.1752);
	angles[9] = (0, -162.2229, 0);
	at[9] = 6.9500;
	points[10] = (3019.0156, 10978.2676, 376.3445);
	angles[10] = (0, -159.3735, 0);
	at[10] = 7;
	points[11] = (2621.1929, 10828.5439, 386.7036);
	angles[11] = (0, -159.3735, 0);
	at[11] = 8.6000;
	points[12] = (2612.9055, 10825.3936, 386.9193);
	angles[12] = (0, -159.3735, 0);
	at[12] = 8.6500;
	points[13] = (2612.9055, 10825.3936, 386.9193);
	angles[13] = (0, -159.3735, 0);
	at[13] = 9.3500;
	points[14] = (2617.4688, 10827.1260, 386.8004);
	angles[14] = (0, -159.3735, 0);
	at[14] = 9.4000;
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
	points[0] = (3284.2520, 12539.6455, 351.4819);
	angles[0] = (0, -153.2262, 0);
	at[0] = 0;
	points[1] = (3142.1575, 12468.1885, 362.5213);
	angles[1] = (0, -154.8080, 0);
	at[1] = 0.6000;
	points[2] = (2805.4961, 12309.8428, 363.5764);
	angles[2] = (0, -154.8080, 0);
	at[2] = 2;
	points[3] = (2793.7480, 12303.6611, 363.8957);
	angles[3] = (0, -151.4995, 0);
	at[3] = 2.0500;
	points[4] = (2268.5159, 12018.4648, 381.9355);
	angles[4] = (0, -151.4995, 0);
	at[4] = 4.3000;
	points[5] = (2264.6260, 12016.3779, 382.0693);
	angles[5] = (0, -151.4995, 0);
	at[5] = 4.3500;
	points[6] = (2264.6260, 12016.3779, 382.0693);
	angles[6] = (0, -151.4995, 0);
	at[6] = 5.0500;
	points[7] = (2274.9055, 12021.9287, 381.7162);
	angles[7] = (0, -151.4995, 0);
	at[7] = 5.1000;
	points[8] = (2800.1377, 12307.1270, 363.6764);
	angles[8] = (0, -151.4995, 0);
	at[8] = 7.3500;
	points[9] = (2812.0828, 12312.9521, 363.5555);
	angles[9] = (0, -154.8080, 0);
	at[9] = 7.4000;
	points[10] = (3148.7400, 12471.2988, 362.5004);
	angles[10] = (0, -154.8080, 0);
	at[10] = 8.8000;
	points[11] = (3290.7285, 12542.9131, 350.9524);
	angles[11] = (0, -153.2262, 0);
	at[11] = 9.4000;
	points[12] = (3290.7285, 12542.9131, 350.9524);
	angles[12] = (0, -153.2262, 0);
	at[12] = 10.1500;
	points[13] = (3284.2520, 12539.6455, 351.4819);
	angles[13] = (0, -153.2262, 0);
	at[13] = 10.1667;
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
	points[0] = (-5260.2754, 4505.9053, 611.9449);
	angles[0] = (0, -2.0509, 0);
	at[0] = 0;
	points[1] = (-5949.0942, 4530.5513, 563.7166);
	angles[1] = (0, -2.0509, 0);
	at[1] = 2.6000;
	points[2] = (-5949.0942, 4530.5513, 563.7166);
	angles[2] = (0, -2.0509, 0);
	at[2] = 3.3500;
	points[3] = (-5259.8428, 4505.8662, 611.9764);
	angles[3] = (0, -2.0509, 0);
	at[3] = 5.9500;
	points[4] = (-5255.4336, 4505.7085, 612.2834);
	angles[4] = (0, -2.0509, 0);
	at[4] = 6;
	points[5] = (-5255.4336, 4505.7085, 612.2834);
	angles[5] = (0, -2.0509, 0);
	at[5] = 6.7000;
	points[6] = (-5260.2754, 4505.9053, 611.9449);
	angles[6] = (0, -2.0509, 0);
	at[6] = 6.7333;
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
	points[0] = (-5606.9292, 3125.2205, 575.8937);
	angles[0] = (0, -1.6991, 0);
	at[0] = 0;
	points[1] = (-5223.6616, 3113.8503, 613.9528);
	angles[1] = (0, -1.6991, 0);
	at[1] = 1.4500;
	points[2] = (-5214.8428, 3113.5906, 614.8268);
	angles[2] = (0, -1.6991, 0);
	at[2] = 1.5000;
	points[3] = (-5214.8428, 3113.5906, 614.8268);
	angles[3] = (0, -1.6991, 0);
	at[3] = 1.6000;
	points[4] = (-5214.8428, 3113.5906, 614.8268);
	angles[4] = (0, -1.6991, 0);
	at[4] = 2.2000;
	points[5] = (-5222.2441, 3113.8071, 614.0906);
	angles[5] = (0, -1.6991, 0);
	at[5] = 2.2500;
	points[6] = (-5605.5513, 3125.1772, 576.0315);
	angles[6] = (0, -1.6991, 0);
	at[6] = 3.7000;
	points[7] = (-5614.3311, 3125.4409, 575.1575);
	angles[7] = (0, -1.6991, 0);
	at[7] = 3.7500;
	points[8] = (-5614.3311, 3125.4409, 575.1575);
	angles[8] = (0, -1.6991, 0);
	at[8] = 4.4500;
	points[9] = (-5606.9292, 3125.2205, 575.8937);
	angles[9] = (0, -1.6991, 0);
	at[9] = 4.5000;
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
	points[0] = (-5271.0630, 2182.9724, 615.7834);
	angles[0] = (0, -8.9133, 0);
	at[0] = 0;
	points[1] = (-5441.2993, 2209.5354, 603.5315);
	angles[1] = (0, -7.5388, 0);
	at[1] = 0.6500;
	points[2] = (-5833.9375, 2261.5000, 558.6181);
	angles[2] = (0, -7.5388, 0);
	at[2] = 2.1500;
	points[3] = (-5842.6777, 2262.6575, 557.6181);
	angles[3] = (0, -7.5388, 0);
	at[3] = 2.2000;
	points[4] = (-5842.6777, 2262.6575, 557.6181);
	angles[4] = (0, -7.5388, 0);
	at[4] = 2.5500;
	points[5] = (-5842.6777, 2262.6575, 557.6181);
	angles[5] = (0, -7.5388, 0);
	at[5] = 2.9000;
	points[6] = (-5835.9053, 2261.7598, 558.3937);
	angles[6] = (0, -7.5388, 0);
	at[6] = 2.9500;
	points[7] = (-5443.2280, 2209.7952, 603.3110);
	angles[7] = (0, -7.5388, 0);
	at[7] = 4.4500;
	points[8] = (-5272.9922, 2183.2795, 615.6457);
	angles[8] = (0, -8.9133, 0);
	at[8] = 5.1000;
	points[9] = (-5264.2915, 2181.9094, 616.2638);
	angles[9] = (0, -8.9133, 0);
	at[9] = 5.1500;
	points[10] = (-5264.2915, 2181.9094, 616.2638);
	angles[10] = (0, -8.9133, 0);
	at[10] = 5.8500;
	points[11] = (-5271.0630, 2182.9724, 615.7834);
	angles[11] = (0, -8.9133, 0);
	at[11] = 5.9000;
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
