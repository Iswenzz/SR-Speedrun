main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_thwomp_ruins", 0);

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
	ambientPlay("iz_0_utr", 2);
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
	level.iz_route[level.iz_route.size] = (-5, -1210, 2280);
	level.iz_route[level.iz_route.size] = (-7, -2776, 2103);
	level.iz_route[level.iz_route.size] = (-11, -3993, 1967);
	level.iz_route[level.iz_route.size] = (-32, -4724, 1898);
	level.iz_route[level.iz_route.size] = (-206, -5129, 1901);
	level.iz_route[level.iz_route.size] = (-512, -5934, 1913);
	level.iz_route[level.iz_route.size] = (-577, -6239, 1916);
	level.iz_route[level.iz_route.size] = (-581, -6604, 1917);
	level.iz_route[level.iz_route.size] = (-452, -7031, 1924);
	level.iz_route[level.iz_route.size] = (57, -7571, 1941);
	level.iz_route[level.iz_route.size] = (672, -7991, 1949);
	level.iz_route[level.iz_route.size] = (972, -8037, 1948);
	level.iz_route[level.iz_route.size] = (1271, -7899, 1946);
	level.iz_route[level.iz_route.size] = (2145, -7264, 1952);
	level.iz_route[level.iz_route.size] = (2886, -6725, 1957);
	level.iz_route[level.iz_route.size] = (3316, -6650, 1960);
	level.iz_route[level.iz_route.size] = (3700, -6777, 1962);
	level.iz_route[level.iz_route.size] = (4409, -7661, 1961);
	level.iz_route[level.iz_route.size] = (5242, -8822, 1929);
	level.iz_route[level.iz_route.size] = (6029, -10095, 1831);
	level.iz_route[level.iz_route.size] = (6653, -11165, 1734);
	level.iz_route[level.iz_route.size] = (7200, -11938, 1650);
	level.iz_route[level.iz_route.size] = (7665, -12386, 1585);
	level.iz_route[level.iz_route.size] = (8125, -12710, 1530);
	level.iz_route[level.iz_route.size] = (8642, -12903, 1471);
	level.iz_route[level.iz_route.size] = (9228, -12830, 1403);
	level.iz_route[level.iz_route.size] = (9777, -12482, 1339);
	level.iz_route[level.iz_route.size] = (10123, -11875, 1295);
	level.iz_route[level.iz_route.size] = (10377, -11030, 1266);
	level.iz_route[level.iz_route.size] = (10462, -10145, 1257);
	level.iz_route[level.iz_route.size] = (10481, -9123, 1254);
	level.iz_route[level.iz_route.size] = (10482, -8461, 1254);
	level.iz_route[level.iz_route.size] = (10445, -7130, 1254);
	level.iz_route[level.iz_route.size] = (11002, -6726, 1254);
	level.iz_route[level.iz_route.size] = (11112, -5890, 1254);
	level.iz_route[level.iz_route.size] = (11585, -5062, 1254);
	level.iz_route[level.iz_route.size] = (11745, -4414, 1254);
	level.iz_route[level.iz_route.size] = (12147, -3703, 1254);
	level.iz_route[level.iz_route.size] = (12248, -2821, 1254);
	level.iz_route[level.iz_route.size] = (12239, -1838, 1254);
	level.iz_route[level.iz_route.size] = (12035, -1227, 1254);
	level.iz_route[level.iz_route.size] = (11608, -235, 1253);
	level.iz_route[level.iz_route.size] = (10991, 1514, 1253);
	level.iz_route[level.iz_route.size] = (10537, 2689, 1252);
	level.iz_route[level.iz_route.size] = (10481, 3569, 1207);
	level.iz_route[level.iz_route.size] = (10437, 5141, 1095);
	level.iz_route[level.iz_route.size] = (10428, 6672, 1066);
	level.iz_route[level.iz_route.size] = (10388, 8391, 1089);
	level.iz_route[level.iz_route.size] = (10320, 9006, 1114);
	level.iz_route[level.iz_route.size] = (10046, 9411, 1181);
	level.iz_route[level.iz_route.size] = (9591, 9583, 1287);
	level.iz_route[level.iz_route.size] = (9065, 9592, 1409);
	level.iz_route[level.iz_route.size] = (7063, 9448, 1858);
	level.iz_route[level.iz_route.size] = (6631, 9492, 1952);
	level.iz_route[level.iz_route.size] = (6244, 9864, 2042);
	level.iz_route[level.iz_route.size] = (5735, 10888, 2193);
	level.iz_route[level.iz_route.size] = (5275, 11468, 2322);
	level.iz_route[level.iz_route.size] = (4853, 11671, 2428);
	level.iz_route[level.iz_route.size] = (4516, 11711, 2494);
	level.iz_route[level.iz_route.size] = (3174, 11443, 2755);
	level.iz_route[level.iz_route.size] = (1597, 10908, 3036);
	level.iz_route[level.iz_route.size] = (877, 10602, 3163);
	level.iz_route[level.iz_route.size] = (311, 10107, 3242);
	level.iz_route[level.iz_route.size] = (102, 9588, 3259);
	level.iz_route[level.iz_route.size] = (9, 8404, 3226);
	level.iz_route[level.iz_route.size] = (33, 7381, 3195);
	level.iz_route[level.iz_route.size] = (22, 5663, 3348);
	level.iz_route[level.iz_route.size] = (3, 4086, 2993);
	level.iz_route[level.iz_route.size] = (30, 3309, 2993);
	level.iz_route[level.iz_route.size] = (34, 2939, 3004);
	level.iz_route[level.iz_route.size] = (18, 1619, 2609);
	level.iz_route[level.iz_route.size] = (17, -109, 2408);
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
	points[0] = (10402.4404, -3639.9016, 1420.1023);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (10402.4404, -3639.9016, 1420.1023);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (10402.4404, -3639.9016, 1427.7717);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (10402.4404, -3639.9016, 1424.5316);
	angles[3] = (0, -180, 0);
	at[3] = 0.5500;
	points[4] = (10402.4404, -3639.9016, 1412.4292);
	angles[4] = (0, -180, 0);
	at[4] = 0.6000;
	points[5] = (10402.4404, -3639.9016, 1415.6732);
	angles[5] = (0, -180, 0);
	at[5] = 0.6500;
	points[6] = (10402.4404, -3639.9016, 1427.7717);
	angles[6] = (0, -180, 0);
	at[6] = 0.7000;
	points[7] = (10402.4404, -3639.9016, 1424.5316);
	angles[7] = (0, -180, 0);
	at[7] = 0.7500;
	points[8] = (10402.4404, -3639.9016, 1412.4292);
	angles[8] = (0, -180, 0);
	at[8] = 0.8000;
	points[9] = (10402.4404, -3639.9016, 1415.6732);
	angles[9] = (0, -180, 0);
	at[9] = 0.8500;
	points[10] = (10402.4404, -3639.9016, 1427.7717);
	angles[10] = (0, -180, 0);
	at[10] = 0.9000;
	points[11] = (10402.4404, -3639.9016, 1424.5316);
	angles[11] = (0, -180, 0);
	at[11] = 0.9500;
	points[12] = (10402.4404, -3639.9016, 1430.4370);
	angles[12] = (0, -180, 0);
	at[12] = 1;
	points[13] = (10402.4404, -3639.9016, 1563.3110);
	angles[13] = (0, -180, 0);
	at[13] = 1.1500;
	points[14] = (10402.4404, -3639.9016, 1533.1929);
	angles[14] = (0, -180, 0);
	at[14] = 1.2000;
	points[15] = (10402.4404, -3639.9016, 1457.8977);
	angles[15] = (0, -180, 0);
	at[15] = 1.2500;
	points[16] = (10402.4404, -3639.9016, 1213.4094);
	angles[16] = (0, -180, 0);
	at[16] = 1.3500;
	points[17] = (10402.4404, -3639.9016, 1213.4094);
	angles[17] = (0, -180, 0);
	at[17] = 2.3500;
	points[18] = (10402.4404, -3639.9016, 1417.1497);
	angles[18] = (0, -180, 0);
	at[18] = 3.5000;
	points[19] = (10402.4404, -3639.9016, 1420.1023);
	angles[19] = (0, -180, 0);
	at[19] = 3.5500;
	points[20] = (10402.4404, -3639.9016, 1420.1023);
	angles[20] = (0, -180, 0);
	at[20] = 4.0333;
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
	points[0] = (1070.2205, 10957.4805, 3469.1260);
	angles[0] = (0, -73, 0);
	at[0] = 0;
	points[1] = (1070.2205, 10957.4805, 3469.1260);
	angles[1] = (0, -73, 0);
	at[1] = 0.4500;
	points[2] = (1070.2205, 10957.4805, 3476.7954);
	angles[2] = (0, -73, 0);
	at[2] = 0.5000;
	points[3] = (1070.2205, 10957.4805, 3473.5552);
	angles[3] = (0, -73, 0);
	at[3] = 0.5500;
	points[4] = (1070.2205, 10957.4805, 3461.4526);
	angles[4] = (0, -73, 0);
	at[4] = 0.6000;
	points[5] = (1070.2205, 10957.4805, 3464.6970);
	angles[5] = (0, -73, 0);
	at[5] = 0.6500;
	points[6] = (1070.2205, 10957.4805, 3476.7954);
	angles[6] = (0, -73, 0);
	at[6] = 0.7000;
	points[7] = (1070.2205, 10957.4805, 3473.5552);
	angles[7] = (0, -73, 0);
	at[7] = 0.7500;
	points[8] = (1070.2205, 10957.4805, 3461.4526);
	angles[8] = (0, -73, 0);
	at[8] = 0.8000;
	points[9] = (1070.2205, 10957.4805, 3464.6970);
	angles[9] = (0, -73, 0);
	at[9] = 0.8500;
	points[10] = (1070.2205, 10957.4805, 3476.7954);
	angles[10] = (0, -73, 0);
	at[10] = 0.9000;
	points[11] = (1070.2205, 10957.4805, 3473.5552);
	angles[11] = (0, -73, 0);
	at[11] = 0.9500;
	points[12] = (1070.2205, 10957.4805, 3479.4607);
	angles[12] = (0, -73, 0);
	at[12] = 1;
	points[13] = (1070.2205, 10957.4805, 3612.3347);
	angles[13] = (0, -73, 0);
	at[13] = 1.1500;
	points[14] = (1070.2205, 10957.4805, 3582.2166);
	angles[14] = (0, -73, 0);
	at[14] = 1.2000;
	points[15] = (1070.2205, 10957.4805, 3506.9211);
	angles[15] = (0, -73, 0);
	at[15] = 1.2500;
	points[16] = (1070.2205, 10957.4805, 3386.4490);
	angles[16] = (0, -73, 0);
	at[16] = 1.3000;
	points[17] = (1070.2205, 10957.4805, 3220.7991);
	angles[17] = (0, -73, 0);
	at[17] = 1.3500;
	points[18] = (1070.2205, 10957.4805, 3144.3228);
	angles[18] = (0, -73, 0);
	at[18] = 1.4000;
	points[19] = (1070.2205, 10957.4805, 3144.3228);
	angles[19] = (0, -73, 0);
	at[19] = 2.3500;
	points[20] = (1070.2205, 10957.4805, 3147.2759);
	angles[20] = (0, -73, 0);
	at[20] = 2.4000;
	points[21] = (1070.2205, 10957.4805, 3466.1733);
	angles[21] = (0, -73, 0);
	at[21] = 4.2000;
	points[22] = (1070.2205, 10957.4805, 3469.1260);
	angles[22] = (0, -73, 0);
	at[22] = 4.2500;
	points[23] = (1070.2205, 10957.4805, 3469.1260);
	angles[23] = (0, -73, 0);
	at[23] = 4.7333;
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
	points[0] = (4103.9766, 11856.3779, 2835.3425);
	angles[0] = (0, -73, 0);
	at[0] = 0;
	points[1] = (4103.9766, 11856.3779, 2915.0671);
	angles[1] = (0, -73, 0);
	at[1] = 0.4500;
	points[2] = (4103.9766, 11856.3779, 2920.9727);
	angles[2] = (0, -73, 0);
	at[2] = 0.5000;
	points[3] = (4103.9766, 11856.3779, 2920.9727);
	angles[3] = (0, -73, 0);
	at[3] = 0.9500;
	points[4] = (4103.9766, 11856.3779, 2928.6458);
	angles[4] = (0, -73, 0);
	at[4] = 1;
	points[5] = (4103.9766, 11856.3779, 2925.4016);
	angles[5] = (0, -73, 0);
	at[5] = 1.0500;
	points[6] = (4103.9766, 11856.3779, 2913.3032);
	angles[6] = (0, -73, 0);
	at[6] = 1.1000;
	points[7] = (4103.9766, 11856.3779, 2916.5435);
	angles[7] = (0, -73, 0);
	at[7] = 1.1500;
	points[8] = (4103.9766, 11856.3779, 2928.6458);
	angles[8] = (0, -73, 0);
	at[8] = 1.2000;
	points[9] = (4103.9766, 11856.3779, 2925.4016);
	angles[9] = (0, -73, 0);
	at[9] = 1.2500;
	points[10] = (4103.9766, 11856.3779, 2913.3032);
	angles[10] = (0, -73, 0);
	at[10] = 1.3000;
	points[11] = (4103.9766, 11856.3779, 2916.5435);
	angles[11] = (0, -73, 0);
	at[11] = 1.3500;
	points[12] = (4103.9766, 11856.3779, 2928.6458);
	angles[12] = (0, -73, 0);
	at[12] = 1.4000;
	points[13] = (4103.9766, 11856.3779, 2925.4016);
	angles[13] = (0, -73, 0);
	at[13] = 1.4500;
	points[14] = (4103.9766, 11856.3779, 2931.3071);
	angles[14] = (0, -73, 0);
	at[14] = 1.5000;
	points[15] = (4103.9766, 11856.3779, 3064.1812);
	angles[15] = (0, -73, 0);
	at[15] = 1.6500;
	points[16] = (4103.9766, 11856.3779, 3034.0630);
	angles[16] = (0, -73, 0);
	at[16] = 1.7000;
	points[17] = (4103.9766, 11856.3779, 2958.7678);
	angles[17] = (0, -73, 0);
	at[17] = 1.7500;
	points[18] = (4103.9766, 11856.3779, 2838.2952);
	angles[18] = (0, -73, 0);
	at[18] = 1.8000;
	points[19] = (4103.9766, 11856.3779, 2672.6458);
	angles[19] = (0, -73, 0);
	at[19] = 1.8500;
	points[20] = (4103.9766, 11856.3779, 2596.1694);
	angles[20] = (0, -73, 0);
	at[20] = 1.9000;
	points[21] = (4103.9766, 11856.3779, 2596.1694);
	angles[21] = (0, -73, 0);
	at[21] = 2.8500;
	points[22] = (4103.9766, 11856.3779, 2599.1221);
	angles[22] = (0, -73, 0);
	at[22] = 2.9000;
	points[23] = (4103.9766, 11856.3779, 2835.3425);
	angles[23] = (0, -73, 0);
	at[23] = 4.2333;
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
	points[0] = (12124.1738, -2983.9568, 1404.0905);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (12124.1738, -2983.9568, 1483.8149);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (12124.1738, -2983.9568, 1489.7206);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (12124.1738, -2983.9568, 1489.7206);
	angles[3] = (0, -180, 0);
	at[3] = 0.9500;
	points[4] = (12124.1738, -2983.9568, 1497.3937);
	angles[4] = (0, -180, 0);
	at[4] = 1;
	points[5] = (12124.1738, -2983.9568, 1494.1497);
	angles[5] = (0, -180, 0);
	at[5] = 1.0500;
	points[6] = (12124.1738, -2983.9568, 1482.0511);
	angles[6] = (0, -180, 0);
	at[6] = 1.1000;
	points[7] = (12124.1738, -2983.9568, 1485.2913);
	angles[7] = (0, -180, 0);
	at[7] = 1.1500;
	points[8] = (12124.1738, -2983.9568, 1497.3937);
	angles[8] = (0, -180, 0);
	at[8] = 1.2000;
	points[9] = (12124.1738, -2983.9568, 1494.1497);
	angles[9] = (0, -180, 0);
	at[9] = 1.2500;
	points[10] = (12124.1738, -2983.9568, 1482.0511);
	angles[10] = (0, -180, 0);
	at[10] = 1.3000;
	points[11] = (12124.1738, -2983.9568, 1485.2913);
	angles[11] = (0, -180, 0);
	at[11] = 1.3500;
	points[12] = (12124.1738, -2983.9568, 1497.3937);
	angles[12] = (0, -180, 0);
	at[12] = 1.4000;
	points[13] = (12124.1738, -2983.9568, 1494.1497);
	angles[13] = (0, -180, 0);
	at[13] = 1.4500;
	points[14] = (12124.1738, -2983.9568, 1500.0551);
	angles[14] = (0, -180, 0);
	at[14] = 1.5000;
	points[15] = (12124.1738, -2983.9568, 1632.9291);
	angles[15] = (0, -180, 0);
	at[15] = 1.6500;
	points[16] = (12124.1738, -2983.9568, 1602.8110);
	angles[16] = (0, -180, 0);
	at[16] = 1.7000;
	points[17] = (12124.1738, -2983.9568, 1527.5157);
	angles[17] = (0, -180, 0);
	at[17] = 1.7500;
	points[18] = (12124.1738, -2983.9568, 1407.0433);
	angles[18] = (0, -180, 0);
	at[18] = 1.8000;
	points[19] = (12124.1738, -2983.9568, 1253.5000);
	angles[19] = (0, -180, 0);
	at[19] = 1.8500;
	points[20] = (12124.1738, -2983.9568, 1253.5000);
	angles[20] = (0, -180, 0);
	at[20] = 2.8500;
	points[21] = (12124.1738, -2983.9568, 1404.0905);
	angles[21] = (0, -180, 0);
	at[21] = 3.7000;
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
	points[0] = (8794.9609, -3020.2322, 1404.0946);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (8794.9609, -3020.2322, 1483.8188);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (8794.9609, -3020.2322, 1489.7245);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (8794.9609, -3020.2322, 1489.7245);
	angles[3] = (0, -180, 0);
	at[3] = 0.9500;
	points[4] = (8794.9609, -3020.2322, 1497.3937);
	angles[4] = (0, -180, 0);
	at[4] = 1;
	points[5] = (8794.9609, -3020.2322, 1494.1536);
	angles[5] = (0, -180, 0);
	at[5] = 1.0500;
	points[6] = (8794.9609, -3020.2322, 1482.0511);
	angles[6] = (0, -180, 0);
	at[6] = 1.1000;
	points[7] = (8794.9609, -3020.2322, 1485.2954);
	angles[7] = (0, -180, 0);
	at[7] = 1.1500;
	points[8] = (8794.9609, -3020.2322, 1497.3937);
	angles[8] = (0, -180, 0);
	at[8] = 1.2000;
	points[9] = (8794.9609, -3020.2322, 1494.1536);
	angles[9] = (0, -180, 0);
	at[9] = 1.2500;
	points[10] = (8794.9609, -3020.2322, 1482.0511);
	angles[10] = (0, -180, 0);
	at[10] = 1.3000;
	points[11] = (8794.9609, -3020.2322, 1485.2954);
	angles[11] = (0, -180, 0);
	at[11] = 1.3500;
	points[12] = (8794.9609, -3020.2322, 1497.3937);
	angles[12] = (0, -180, 0);
	at[12] = 1.4000;
	points[13] = (8794.9609, -3020.2322, 1494.1536);
	angles[13] = (0, -180, 0);
	at[13] = 1.4500;
	points[14] = (8794.9609, -3020.2322, 1500.0591);
	angles[14] = (0, -180, 0);
	at[14] = 1.5000;
	points[15] = (8794.9609, -3020.2322, 1632.9331);
	angles[15] = (0, -180, 0);
	at[15] = 1.6500;
	points[16] = (8794.9609, -3020.2322, 1602.8149);
	angles[16] = (0, -180, 0);
	at[16] = 1.7000;
	points[17] = (8794.9609, -3020.2322, 1527.5197);
	angles[17] = (0, -180, 0);
	at[17] = 1.7500;
	points[18] = (8794.9609, -3020.2322, 1407.0472);
	angles[18] = (0, -180, 0);
	at[18] = 1.8000;
	points[19] = (8794.9609, -3020.2322, 1253.5040);
	angles[19] = (0, -180, 0);
	at[19] = 1.8500;
	points[20] = (8794.9609, -3020.2322, 1253.5040);
	angles[20] = (0, -180, 0);
	at[20] = 2.8500;
	points[21] = (8794.9609, -3020.2322, 1404.0946);
	angles[21] = (0, -180, 0);
	at[21] = 3.7000;
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
