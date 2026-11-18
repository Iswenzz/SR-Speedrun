main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_rainbow_road_u", 0);

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
	ambientPlay("iz_0_sfcrr", 2);
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
	level.iz_route[level.iz_route.size] = (4562, -1436, 5029);
	level.iz_route[level.iz_route.size] = (4547, -2544, 5029);
	level.iz_route[level.iz_route.size] = (4552, -3742, 5021);
	level.iz_route[level.iz_route.size] = (4535, -5024, 5016);
	level.iz_route[level.iz_route.size] = (4424, -5575, 5025);
	level.iz_route[level.iz_route.size] = (4093, -5934, 5027);
	level.iz_route[level.iz_route.size] = (3555, -6028, 5022);
	level.iz_route[level.iz_route.size] = (2040, -6004, 5020);
	level.iz_route[level.iz_route.size] = (354, -5986, 5027);
	level.iz_route[level.iz_route.size] = (-1380, -5957, 5046);
	level.iz_route[level.iz_route.size] = (-2880, -5947, 5088);
	level.iz_route[level.iz_route.size] = (-3383, -5865, 5110);
	level.iz_route[level.iz_route.size] = (-3665, -5673, 5121);
	level.iz_route[level.iz_route.size] = (-3798, -5219, 5115);
	level.iz_route[level.iz_route.size] = (-3809, -4081, 5085);
	level.iz_route[level.iz_route.size] = (-3830, -2945, 5056);
	level.iz_route[level.iz_route.size] = (-3796, -1863, 5032);
	level.iz_route[level.iz_route.size] = (-3601, -1586, 5023);
	level.iz_route[level.iz_route.size] = (-3261, -1342, 5007);
	level.iz_route[level.iz_route.size] = (-2685, -1292, 4980);
	level.iz_route[level.iz_route.size] = (-1755, -1288, 4955);
	level.iz_route[level.iz_route.size] = (-847, -1284, 4932);
	level.iz_route[level.iz_route.size] = (217, -1292, 4907);
	level.iz_route[level.iz_route.size] = (937, -1240, 4896);
	level.iz_route[level.iz_route.size] = (1295, -937, 4887);
	level.iz_route[level.iz_route.size] = (1420, -448, 4878);
	level.iz_route[level.iz_route.size] = (1416, 419, 4870);
	level.iz_route[level.iz_route.size] = (1340, 1003, 4877);
	level.iz_route[level.iz_route.size] = (1108, 1374, 4888);
	level.iz_route[level.iz_route.size] = (639, 1500, 4898);
	level.iz_route[level.iz_route.size] = (-215, 1484, 4931);
	level.iz_route[level.iz_route.size] = (-1204, 1485, 4984);
	level.iz_route[level.iz_route.size] = (-2035, 1505, 5028);
	level.iz_route[level.iz_route.size] = (-2760, 1509, 5066);
	level.iz_route[level.iz_route.size] = (-3622, 1507, 5117);
	level.iz_route[level.iz_route.size] = (-4416, 1509, 5169);
	level.iz_route[level.iz_route.size] = (-5254, 1488, 5222);
	level.iz_route[level.iz_route.size] = (-5797, 1529, 5265);
	level.iz_route[level.iz_route.size] = (-6117, 1701, 5286);
	level.iz_route[level.iz_route.size] = (-6339, 1985, 5298);
	level.iz_route[level.iz_route.size] = (-6359, 2467, 5296);
	level.iz_route[level.iz_route.size] = (-6377, 3150, 5294);
	level.iz_route[level.iz_route.size] = (-6367, 3895, 5288);
	level.iz_route[level.iz_route.size] = (-6290, 4482, 5284);
	level.iz_route[level.iz_route.size] = (-6117, 4671, 5276);
	level.iz_route[level.iz_route.size] = (-5719, 4799, 5251);
	level.iz_route[level.iz_route.size] = (-4907, 4826, 5198);
	level.iz_route[level.iz_route.size] = (-4063, 4799, 5139);
	level.iz_route[level.iz_route.size] = (-3038, 4789, 5081);
	level.iz_route[level.iz_route.size] = (-2059, 4808, 5034);
	level.iz_route[level.iz_route.size] = (-1182, 4803, 5029);
	level.iz_route[level.iz_route.size] = (-764, 4618, 5029);
	level.iz_route[level.iz_route.size] = (-160, 4350, 5029);
	level.iz_route[level.iz_route.size] = (543, 4310, 5029);
	level.iz_route[level.iz_route.size] = (1370, 4328, 5029);
	level.iz_route[level.iz_route.size] = (2105, 4512, 5029);
	level.iz_route[level.iz_route.size] = (2852, 4780, 5029);
	level.iz_route[level.iz_route.size] = (3608, 4782, 5027);
	level.iz_route[level.iz_route.size] = (4169, 4764, 5029);
	level.iz_route[level.iz_route.size] = (4546, 4549, 5031);
	level.iz_route[level.iz_route.size] = (4597, 3929, 5024);
	level.iz_route[level.iz_route.size] = (4578, 2847, 5027);
	level.iz_route[level.iz_route.size] = (4591, 1894, 5028);
	level.iz_route[level.iz_route.size] = (4588, 1042, 5029);
	level.iz_route[level.iz_route.size] = (4587, 126, 5029);
	level.iz_route[level.iz_route.size] = (4573, -765, 5029);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4825.4331, 1420.8464, 5028.6611);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4825.4331, 1420.8464, 5031.6143);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (4825.4331, 1420.8464, 5279.6455);
	angles[2] = (0, 0, 0);
	at[2] = 1.5500;
	points[3] = (4825.4331, 1420.8464, 5279.6455);
	angles[3] = (0, 0, 0);
	at[3] = 2.5500;
	points[4] = (4825.4331, 1420.8464, 5288.5039);
	angles[4] = (0, 0, 0);
	at[4] = 2.6000;
	points[5] = (4825.4331, 1420.8464, 5270.7876);
	angles[5] = (0, 0, 0);
	at[5] = 2.7000;
	points[6] = (4825.4331, 1420.8464, 5288.5039);
	angles[6] = (0, 0, 0);
	at[6] = 2.8000;
	points[7] = (4825.4331, 1420.8464, 5270.7876);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (4825.4331, 1420.8464, 5288.5039);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (4825.4331, 1420.8464, 5279.6455);
	angles[9] = (0, 0, 0);
	at[9] = 3.0500;
	points[10] = (4825.4331, 1420.8464, 5304.7637);
	angles[10] = (0, 0, 0);
	at[10] = 3.1000;
	points[11] = (4825.4331, 1420.8464, 5393.3462);
	angles[11] = (0, 0, 0);
	at[11] = 3.2000;
	points[12] = (4825.4331, 1420.8464, 5417.8350);
	angles[12] = (0, 0, 0);
	at[12] = 3.2500;
	points[13] = (4825.4331, 1420.8464, 5372.6772);
	angles[13] = (0, 0, 0);
	at[13] = 3.3000;
	points[14] = (4825.4331, 1420.8464, 5282.3232);
	angles[14] = (0, 0, 0);
	at[14] = 3.3500;
	points[15] = (4825.4331, 1420.8464, 5146.7715);
	angles[15] = (0, 0, 0);
	at[15] = 3.4000;
	points[16] = (4825.4331, 1420.8464, 5028.6611);
	angles[16] = (0, 0, 0);
	at[16] = 3.4500;
	points[17] = (4825.4331, 1420.8464, 5028.6611);
	angles[17] = (0, 0, 0);
	at[17] = 4.3167;
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
	points[0] = (4317.0864, 1419.2598, 5284.0947);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4317.0864, 1419.2598, 5272.0078);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (4317.0864, 1419.2598, 5275.2363);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (4317.0864, 1419.2598, 5287.3232);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (4317.0864, 1419.2598, 5284.0947);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (4317.0864, 1419.2598, 5290);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (4317.0864, 1419.2598, 5422.8740);
	angles[6] = (0, 0, 0);
	at[6] = 0.4000;
	points[7] = (4317.0864, 1419.2598, 5392.7559);
	angles[7] = (0, 0, 0);
	at[7] = 0.4500;
	points[8] = (4317.0864, 1419.2598, 5317.4409);
	angles[8] = (0, 0, 0);
	at[8] = 0.5000;
	points[9] = (4317.0864, 1419.2598, 5196.9688);
	angles[9] = (0, 0, 0);
	at[9] = 0.5500;
	points[10] = (4317.0864, 1419.2598, 5031.3384);
	angles[10] = (0, 0, 0);
	at[10] = 0.6000;
	points[11] = (4317.0864, 1419.2598, 5028.6611);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (4317.0864, 1419.2598, 5028.6611);
	angles[12] = (0, 0, 0);
	at[12] = 1.6000;
	points[13] = (4317.0864, 1419.2598, 5034.5669);
	angles[13] = (0, 0, 0);
	at[13] = 1.6500;
	points[14] = (4317.0864, 1419.2598, 5273.7402);
	angles[14] = (0, 0, 0);
	at[14] = 3;
	points[15] = (4317.0864, 1419.2598, 5279.6455);
	angles[15] = (0, 0, 0);
	at[15] = 3.0500;
	points[16] = (4317.0864, 1419.2598, 5279.6455);
	angles[16] = (0, 0, 0);
	at[16] = 4;
	points[17] = (4317.0864, 1419.2598, 5287.3232);
	angles[17] = (0, 0, 0);
	at[17] = 4.1000;
	points[18] = (4317.0864, 1419.2598, 5275.2363);
	angles[18] = (0, 0, 0);
	at[18] = 4.1500;
	points[19] = (4317.0864, 1419.2598, 5272.0078);
	angles[19] = (0, 0, 0);
	at[19] = 4.2000;
	points[20] = (4317.0864, 1419.2598, 5284.0947);
	angles[20] = (0, 0, 0);
	at[20] = 4.2500;
	points[21] = (4317.0864, 1419.2598, 5287.3232);
	angles[21] = (0, 0, 0);
	at[21] = 4.3000;
	points[22] = (4317.0864, 1419.2598, 5284.0947);
	angles[22] = (0, 0, 0);
	at[22] = 4.3167;
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
	points[0] = (1174.1575, 4304.5273, 5256.0239);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1174.1575, 4304.5273, 5279.6455);
	angles[1] = (0, 90, 0);
	at[1] = 0.1500;
	points[2] = (1174.1575, 4304.5273, 5279.6455);
	angles[2] = (0, 90, 0);
	at[2] = 1.1000;
	points[3] = (1174.1575, 4304.5273, 5287.3232);
	angles[3] = (0, 90, 0);
	at[3] = 1.2000;
	points[4] = (1174.1575, 4304.5273, 5275.2363);
	angles[4] = (0, 90, 0);
	at[4] = 1.2500;
	points[5] = (1174.1575, 4304.5273, 5272.0078);
	angles[5] = (0, 90, 0);
	at[5] = 1.3000;
	points[6] = (1174.1575, 4304.5273, 5284.0947);
	angles[6] = (0, 90, 0);
	at[6] = 1.3500;
	points[7] = (1174.1575, 4304.5273, 5287.3232);
	angles[7] = (0, 90, 0);
	at[7] = 1.4000;
	points[8] = (1174.1575, 4304.5273, 5275.2363);
	angles[8] = (0, 90, 0);
	at[8] = 1.4500;
	points[9] = (1174.1575, 4304.5273, 5272.0078);
	angles[9] = (0, 90, 0);
	at[9] = 1.5000;
	points[10] = (1174.1575, 4304.5273, 5284.0947);
	angles[10] = (0, 90, 0);
	at[10] = 1.5500;
	points[11] = (1174.1575, 4304.5273, 5287.3232);
	angles[11] = (0, 90, 0);
	at[11] = 1.6000;
	points[12] = (1174.1575, 4304.5273, 5275.2363);
	angles[12] = (0, 90, 0);
	at[12] = 1.6500;
	points[13] = (1174.1575, 4304.5273, 5408.1104);
	angles[13] = (0, 90, 0);
	at[13] = 1.8000;
	points[14] = (1174.1575, 4304.5273, 5407.7954);
	angles[14] = (0, 90, 0);
	at[14] = 1.8500;
	points[15] = (1174.1575, 4304.5273, 5347.5591);
	angles[15] = (0, 90, 0);
	at[15] = 1.9000;
	points[16] = (1174.1575, 4304.5273, 5242.1655);
	angles[16] = (0, 90, 0);
	at[16] = 1.9500;
	points[17] = (1174.1575, 4304.5273, 5091.5752);
	angles[17] = (0, 90, 0);
	at[17] = 2;
	points[18] = (1174.1575, 4304.5273, 5028.6611);
	angles[18] = (0, 90, 0);
	at[18] = 2.0500;
	points[19] = (1174.1575, 4304.5273, 5028.6611);
	angles[19] = (0, 90, 0);
	at[19] = 3;
	points[20] = (1174.1575, 4304.5273, 5031.6143);
	angles[20] = (0, 90, 0);
	at[20] = 3.0500;
	points[21] = (1174.1575, 4304.5273, 5256.0239);
	angles[21] = (0, 90, 0);
	at[21] = 4.3167;
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
	points[0] = (1186.0906, 5302.9531, 5028.6611);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1186.0906, 5302.9531, 5031.6143);
	angles[1] = (0, 90, 0);
	at[1] = 0.1500;
	points[2] = (1186.0906, 5302.9531, 5279.6455);
	angles[2] = (0, 90, 0);
	at[2] = 1.5500;
	points[3] = (1186.0906, 5302.9531, 5279.6455);
	angles[3] = (0, 90, 0);
	at[3] = 2.5500;
	points[4] = (1186.0906, 5302.9531, 5288.5039);
	angles[4] = (0, 90, 0);
	at[4] = 2.6000;
	points[5] = (1186.0906, 5302.9531, 5270.7876);
	angles[5] = (0, 90, 0);
	at[5] = 2.7000;
	points[6] = (1186.0906, 5302.9531, 5288.5039);
	angles[6] = (0, 90, 0);
	at[6] = 2.8000;
	points[7] = (1186.0906, 5302.9531, 5270.7876);
	angles[7] = (0, 90, 0);
	at[7] = 2.9000;
	points[8] = (1186.0906, 5302.9531, 5288.5039);
	angles[8] = (0, 90, 0);
	at[8] = 3;
	points[9] = (1186.0906, 5302.9531, 5279.6455);
	angles[9] = (0, 90, 0);
	at[9] = 3.0500;
	points[10] = (1186.0906, 5302.9531, 5304.7637);
	angles[10] = (0, 90, 0);
	at[10] = 3.1000;
	points[11] = (1186.0906, 5302.9531, 5393.3462);
	angles[11] = (0, 90, 0);
	at[11] = 3.2000;
	points[12] = (1186.0906, 5302.9531, 5417.8350);
	angles[12] = (0, 90, 0);
	at[12] = 3.2500;
	points[13] = (1186.0906, 5302.9531, 5372.6772);
	angles[13] = (0, 90, 0);
	at[13] = 3.3000;
	points[14] = (1186.0906, 5302.9531, 5282.3232);
	angles[14] = (0, 90, 0);
	at[14] = 3.3500;
	points[15] = (1186.0906, 5302.9531, 5146.7715);
	angles[15] = (0, 90, 0);
	at[15] = 3.4000;
	points[16] = (1186.0906, 5302.9531, 5028.6611);
	angles[16] = (0, 90, 0);
	at[16] = 3.4500;
	points[17] = (1186.0906, 5302.9531, 5028.6611);
	angles[17] = (0, 90, 0);
	at[17] = 4.3167;
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
	points[0] = (-3103.3425, 1468.3898, 5339.5273);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-3103.3425, 1468.3898, 5327.4409);
	angles[1] = (0, -90, 0);
	at[1] = 0.0500;
	points[2] = (-3103.3425, 1468.3898, 5330.6694);
	angles[2] = (0, -90, 0);
	at[2] = 0.1000;
	points[3] = (-3103.3425, 1468.3898, 5342.7954);
	angles[3] = (0, -90, 0);
	at[3] = 0.1500;
	points[4] = (-3103.3425, 1468.3898, 5339.5273);
	angles[4] = (0, -90, 0);
	at[4] = 0.2000;
	points[5] = (-3103.3425, 1468.3898, 5345.4331);
	angles[5] = (0, -90, 0);
	at[5] = 0.2500;
	points[6] = (-3103.3425, 1468.3898, 5478.3071);
	angles[6] = (0, -90, 0);
	at[6] = 0.4000;
	points[7] = (-3103.3425, 1468.3898, 5448.1890);
	angles[7] = (0, -90, 0);
	at[7] = 0.4500;
	points[8] = (-3103.3425, 1468.3898, 5372.9136);
	angles[8] = (0, -90, 0);
	at[8] = 0.5000;
	points[9] = (-3103.3425, 1468.3898, 5252.4409);
	angles[9] = (0, -90, 0);
	at[9] = 0.5500;
	points[10] = (-3103.3425, 1468.3898, 5086.7715);
	angles[10] = (0, -90, 0);
	at[10] = 0.6000;
	points[11] = (-3103.3425, 1468.3898, 5084.1338);
	angles[11] = (0, -90, 0);
	at[11] = 0.6500;
	points[12] = (-3103.3425, 1468.3898, 5084.1338);
	angles[12] = (0, -90, 0);
	at[12] = 1.6000;
	points[13] = (-3103.3425, 1468.3898, 5090.0396);
	angles[13] = (0, -90, 0);
	at[13] = 1.6500;
	points[14] = (-3103.3425, 1468.3898, 5329.2124);
	angles[14] = (0, -90, 0);
	at[14] = 3;
	points[15] = (-3103.3425, 1468.3898, 5335.1177);
	angles[15] = (0, -90, 0);
	at[15] = 3.0500;
	points[16] = (-3103.3425, 1468.3898, 5335.1177);
	angles[16] = (0, -90, 0);
	at[16] = 4;
	points[17] = (-3103.3425, 1468.3898, 5342.7954);
	angles[17] = (0, -90, 0);
	at[17] = 4.1000;
	points[18] = (-3103.3425, 1468.3898, 5330.6694);
	angles[18] = (0, -90, 0);
	at[18] = 4.1500;
	points[19] = (-3103.3425, 1468.3898, 5327.4409);
	angles[19] = (0, -90, 0);
	at[19] = 4.2000;
	points[20] = (-3103.3425, 1468.3898, 5339.5273);
	angles[20] = (0, -90, 0);
	at[20] = 4.2500;
	points[21] = (-3103.3425, 1468.3898, 5342.7954);
	angles[21] = (0, -90, 0);
	at[21] = 4.3000;
	points[22] = (-3103.3425, 1468.3898, 5339.5273);
	angles[22] = (0, -90, 0);
	at[22] = 4.3167;
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
	points[0] = (-1335.8542, -5723.5825, 5253.7407);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-1335.8542, -5723.5825, 5279.6455);
	angles[1] = (0, -90, 0);
	at[1] = 0.1500;
	points[2] = (-1335.8542, -5723.5825, 5279.6455);
	angles[2] = (0, -90, 0);
	at[2] = 1.1000;
	points[3] = (-1335.8542, -5723.5825, 5287.3232);
	angles[3] = (0, -90, 0);
	at[3] = 1.2000;
	points[4] = (-1335.8542, -5723.5825, 5275.2363);
	angles[4] = (0, -90, 0);
	at[4] = 1.2500;
	points[5] = (-1335.8542, -5723.5825, 5272.0078);
	angles[5] = (0, -90, 0);
	at[5] = 1.3000;
	points[6] = (-1335.8542, -5723.5825, 5284.0947);
	angles[6] = (0, -90, 0);
	at[6] = 1.3500;
	points[7] = (-1335.8542, -5723.5825, 5287.3232);
	angles[7] = (0, -90, 0);
	at[7] = 1.4000;
	points[8] = (-1335.8542, -5723.5825, 5275.2363);
	angles[8] = (0, -90, 0);
	at[8] = 1.4500;
	points[9] = (-1335.8542, -5723.5825, 5272.0078);
	angles[9] = (0, -90, 0);
	at[9] = 1.5000;
	points[10] = (-1335.8542, -5723.5825, 5284.0947);
	angles[10] = (0, -90, 0);
	at[10] = 1.5500;
	points[11] = (-1335.8542, -5723.5825, 5287.3232);
	angles[11] = (0, -90, 0);
	at[11] = 1.6000;
	points[12] = (-1335.8542, -5723.5825, 5275.2363);
	angles[12] = (0, -90, 0);
	at[12] = 1.6500;
	points[13] = (-1335.8542, -5723.5825, 5408.1104);
	angles[13] = (0, -90, 0);
	at[13] = 1.8000;
	points[14] = (-1335.8542, -5723.5825, 5407.7954);
	angles[14] = (0, -90, 0);
	at[14] = 1.8500;
	points[15] = (-1335.8542, -5723.5825, 5347.5591);
	angles[15] = (0, -90, 0);
	at[15] = 1.9000;
	points[16] = (-1335.8542, -5723.5825, 5242.1655);
	angles[16] = (0, -90, 0);
	at[16] = 1.9500;
	points[17] = (-1335.8542, -5723.5825, 5091.5752);
	angles[17] = (0, -90, 0);
	at[17] = 2;
	points[18] = (-1335.8542, -5723.5825, 5044.0942);
	angles[18] = (0, -90, 0);
	at[18] = 2.0500;
	points[19] = (-1335.8542, -5723.5825, 5044.0942);
	angles[19] = (0, -90, 0);
	at[19] = 3;
	points[20] = (-1335.8542, -5723.5825, 5050);
	angles[20] = (0, -90, 0);
	at[20] = 3.0500;
	points[21] = (-1335.8542, -5723.5825, 5253.7407);
	angles[21] = (0, -90, 0);
	at[21] = 4.2000;
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
	points[0] = (-1335.8542, -6240.7090, 5045);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-1335.8542, -6240.7090, 5045);
	angles[1] = (0, -90, 0);
	at[1] = 0.2000;
	points[2] = (-1335.8542, -6240.7090, 5047.9531);
	angles[2] = (0, -90, 0);
	at[2] = 0.2500;
	points[3] = (-1335.8542, -6240.7090, 5278.2676);
	angles[3] = (0, -90, 0);
	at[3] = 1.5500;
	points[4] = (-1335.8542, -6240.7090, 5279.6455);
	angles[4] = (0, -90, 0);
	at[4] = 2.5500;
	points[5] = (-1335.8542, -6240.7090, 5288.5039);
	angles[5] = (0, -90, 0);
	at[5] = 2.6000;
	points[6] = (-1335.8542, -6240.7090, 5270.7876);
	angles[6] = (0, -90, 0);
	at[6] = 2.7000;
	points[7] = (-1335.8542, -6240.7090, 5288.5039);
	angles[7] = (0, -90, 0);
	at[7] = 2.8000;
	points[8] = (-1335.8542, -6240.7090, 5270.7876);
	angles[8] = (0, -90, 0);
	at[8] = 2.9000;
	points[9] = (-1335.8542, -6240.7090, 5288.5039);
	angles[9] = (0, -90, 0);
	at[9] = 3;
	points[10] = (-1335.8542, -6240.7090, 5279.6455);
	angles[10] = (0, -90, 0);
	at[10] = 3.0500;
	points[11] = (-1335.8542, -6240.7090, 5304.7637);
	angles[11] = (0, -90, 0);
	at[11] = 3.1000;
	points[12] = (-1335.8542, -6240.7090, 5393.3462);
	angles[12] = (0, -90, 0);
	at[12] = 3.2000;
	points[13] = (-1335.8542, -6240.7090, 5417.8350);
	angles[13] = (0, -90, 0);
	at[13] = 3.2500;
	points[14] = (-1335.8542, -6240.7090, 5372.6772);
	angles[14] = (0, -90, 0);
	at[14] = 3.3000;
	points[15] = (-1335.8542, -6240.7090, 5282.3232);
	angles[15] = (0, -90, 0);
	at[15] = 3.3500;
	points[16] = (-1335.8542, -6240.7090, 5146.7715);
	angles[16] = (0, -90, 0);
	at[16] = 3.4000;
	points[17] = (-1335.8542, -6240.7090, 5045);
	angles[17] = (0, -90, 0);
	at[17] = 3.4500;
	points[18] = (-1335.8542, -6240.7090, 5045);
	angles[18] = (0, -90, 0);
	at[18] = 4.2000;
	mover = getEnt("iz_obj_6", "targetname");
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
