main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_luigi_circuit", 0);

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
	ambientPlay("iz_0_44", 2);
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
	level.iz_route[level.iz_route.size] = (-5619, 1018, 1419);
	level.iz_route[level.iz_route.size] = (-6634, 1018, 1419);
	level.iz_route[level.iz_route.size] = (-7653, 1158, 1419);
	level.iz_route[level.iz_route.size] = (-8421, 1758, 1419);
	level.iz_route[level.iz_route.size] = (-8882, 2602, 1419);
	level.iz_route[level.iz_route.size] = (-9151, 3515, 1419);
	level.iz_route[level.iz_route.size] = (-9355, 4320, 1419);
	level.iz_route[level.iz_route.size] = (-9686, 5051, 1419);
	level.iz_route[level.iz_route.size] = (-10315, 5700, 1419);
	level.iz_route[level.iz_route.size] = (-11134, 6044, 1419);
	level.iz_route[level.iz_route.size] = (-12049, 6163, 1419);
	level.iz_route[level.iz_route.size] = (-13023, 6171, 1414);
	level.iz_route[level.iz_route.size] = (-14102, 6197, 1397);
	level.iz_route[level.iz_route.size] = (-15134, 6536, 1362);
	level.iz_route[level.iz_route.size] = (-15626, 7258, 1329);
	level.iz_route[level.iz_route.size] = (-15454, 8191, 1293);
	level.iz_route[level.iz_route.size] = (-14913, 8687, 1267);
	level.iz_route[level.iz_route.size] = (-13863, 8867, 1262);
	level.iz_route[level.iz_route.size] = (-12987, 8721, 1262);
	level.iz_route[level.iz_route.size] = (-12104, 8473, 1262);
	level.iz_route[level.iz_route.size] = (-11221, 8233, 1261);
	level.iz_route[level.iz_route.size] = (-10364, 7968, 1257);
	level.iz_route[level.iz_route.size] = (-9412, 7677, 1253);
	level.iz_route[level.iz_route.size] = (-8610, 7525, 1253);
	level.iz_route[level.iz_route.size] = (-7787, 7723, 1253);
	level.iz_route[level.iz_route.size] = (-7459, 8467, 1253);
	level.iz_route[level.iz_route.size] = (-8055, 9297, 1253);
	level.iz_route[level.iz_route.size] = (-8675, 9881, 1253);
	level.iz_route[level.iz_route.size] = (-9296, 10480, 1253);
	level.iz_route[level.iz_route.size] = (-9911, 11003, 1253);
	level.iz_route[level.iz_route.size] = (-10470, 11550, 1253);
	level.iz_route[level.iz_route.size] = (-10771, 12442, 1253);
	level.iz_route[level.iz_route.size] = (-10345, 13316, 1253);
	level.iz_route[level.iz_route.size] = (-9755, 14051, 1253);
	level.iz_route[level.iz_route.size] = (-9236, 14952, 1253);
	level.iz_route[level.iz_route.size] = (-8831, 15843, 1253);
	level.iz_route[level.iz_route.size] = (-8176, 16655, 1274);
	level.iz_route[level.iz_route.size] = (-7347, 16752, 1307);
	level.iz_route[level.iz_route.size] = (-6572, 16261, 1340);
	level.iz_route[level.iz_route.size] = (-6299, 15395, 1369);
	level.iz_route[level.iz_route.size] = (-6338, 14453, 1383);
	level.iz_route[level.iz_route.size] = (-6325, 13575, 1396);
	level.iz_route[level.iz_route.size] = (-6375, 12787, 1408);
	level.iz_route[level.iz_route.size] = (-6345, 11934, 1420);
	level.iz_route[level.iz_route.size] = (-6108, 11075, 1422);
	level.iz_route[level.iz_route.size] = (-5110, 10987, 1415);
	level.iz_route[level.iz_route.size] = (-4368, 11608, 1385);
	level.iz_route[level.iz_route.size] = (-3432, 12506, 1342);
	level.iz_route[level.iz_route.size] = (-2646, 13306, 1304);
	level.iz_route[level.iz_route.size] = (-1974, 13932, 1283);
	level.iz_route[level.iz_route.size] = (-1177, 14661, 1283);
	level.iz_route[level.iz_route.size] = (-334, 15474, 1283);
	level.iz_route[level.iz_route.size] = (393, 16165, 1283);
	level.iz_route[level.iz_route.size] = (1255, 16790, 1283);
	level.iz_route[level.iz_route.size] = (2089, 16735, 1283);
	level.iz_route[level.iz_route.size] = (2545, 15976, 1283);
	level.iz_route[level.iz_route.size] = (2494, 15144, 1283);
	level.iz_route[level.iz_route.size] = (1957, 14348, 1283);
	level.iz_route[level.iz_route.size] = (1053, 13606, 1283);
	level.iz_route[level.iz_route.size] = (534, 12664, 1283);
	level.iz_route[level.iz_route.size] = (-132, 11802, 1283);
	level.iz_route[level.iz_route.size] = (-1170, 10990, 1283);
	level.iz_route[level.iz_route.size] = (-1992, 9987, 1298);
	level.iz_route[level.iz_route.size] = (-2477, 8741, 1406);
	level.iz_route[level.iz_route.size] = (-3184, 7936, 1422);
	level.iz_route[level.iz_route.size] = (-3970, 7131, 1422);
	level.iz_route[level.iz_route.size] = (-4798, 6333, 1441);
	level.iz_route[level.iz_route.size] = (-5534, 5498, 1469);
	level.iz_route[level.iz_route.size] = (-5571, 4590, 1468);
	level.iz_route[level.iz_route.size] = (-4740, 4020, 1429);
	level.iz_route[level.iz_route.size] = (-3725, 4041, 1422);
	level.iz_route[level.iz_route.size] = (-2691, 4053, 1422);
	level.iz_route[level.iz_route.size] = (-1387, 4080, 1422);
	level.iz_route[level.iz_route.size] = (-473, 4119, 1423);
	level.iz_route[level.iz_route.size] = (411, 4000, 1464);
	level.iz_route[level.iz_route.size] = (1201, 3415, 1480);
	level.iz_route[level.iz_route.size] = (1372, 2407, 1477);
	level.iz_route[level.iz_route.size] = (990, 1490, 1472);
	level.iz_route[level.iz_route.size] = (167, 1096, 1424);
	level.iz_route[level.iz_route.size] = (-947, 1044, 1420);
	level.iz_route[level.iz_route.size] = (-2023, 1026, 1419);
	level.iz_route[level.iz_route.size] = (-3062, 1019, 1419);
	level.iz_route[level.iz_route.size] = (-4217, 1052, 1419);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5443.8188, 15546.1807, 3543.3071);
	angles[0] = (0, -102.6346, 0);
	at[0] = 0;
	points[1] = (-5246.8506, 15483.7012, 3543.3071);
	angles[1] = (0, -105.8143, 0);
	at[1] = 0.3000;
	points[2] = (-5048.5435, 15410.0781, 3543.3071);
	angles[2] = (0, -108.6938, 0);
	at[2] = 0.6000;
	points[3] = (-4844.3306, 15327.5596, 3543.3071);
	angles[3] = (0, -110.7670, 0);
	at[3] = 0.9000;
	points[4] = (-4653.6221, 15246.1426, 3543.3071);
	angles[4] = (0, -112.2378, 0);
	at[4] = 1.2000;
	points[5] = (-4454.7246, 15157.7559, 3543.3071);
	angles[5] = (0, -113.3229, 0);
	at[5] = 1.5000;
	points[6] = (-4263.8979, 15070.1963, 3543.3071);
	angles[6] = (0, -114.1616, 0);
	at[6] = 1.8000;
	points[7] = (-4068.6221, 14978.1104, 3543.3071);
	angles[7] = (0, -114.8493, 0);
	at[7] = 2.1000;
	points[8] = (-3686.6929, 14791.5752, 3543.3071);
	angles[8] = (0, -115.9775, 0);
	at[8] = 2.7000;
	points[9] = (-3306.7520, 14597.9131, 3543.3071);
	angles[9] = (0, -116.9767, 0);
	at[9] = 3.3000;
	points[10] = (-3116.6221, 14497.8740, 3543.3071);
	angles[10] = (0, -117.4797, 0);
	at[10] = 3.6000;
	points[11] = (-2741.5906, 14293.1895, 3543.3071);
	angles[11] = (0, -118.6111, 0);
	at[11] = 4.2000;
	points[12] = (-2558.3110, 14188.6611, 3543.3071);
	angles[12] = (0, -119.3182, 0);
	at[12] = 4.5000;
	points[13] = (-2371.1064, 14077.5596, 3543.3071);
	angles[13] = (0, -120.2141, 0);
	at[13] = 4.8000;
	points[14] = (-2195.1772, 13967.0078, 3543.3071);
	angles[14] = (0, -121.4890, 0);
	at[14] = 5.1000;
	points[15] = (-2021.8427, 13846.3779, 3543.3071);
	angles[15] = (0, -123.8205, 0);
	at[15] = 5.4000;
	points[16] = (-1863.9292, 13715.0791, 3543.3071);
	angles[16] = (0, -127.6019, 0);
	at[16] = 5.7000;
	points[17] = (-1709.3149, 13571.4170, 3543.3071);
	angles[17] = (0, -130.9377, 0);
	at[17] = 6;
	points[18] = (-1556.4606, 13419.6846, 3543.3071);
	angles[18] = (0, -133.3622, 0);
	at[18] = 6.3000;
	points[19] = (-1408.1575, 13265.2373, 3543.3071);
	angles[19] = (0, -135.1234, 0);
	at[19] = 6.6000;
	points[20] = (-1264.3544, 13109.4883, 3543.3071);
	angles[20] = (0, -136.4899, 0);
	at[20] = 6.9000;
	points[21] = (-1121.2087, 12948.9766, 3543.3071);
	angles[21] = (0, -137.6244, 0);
	at[21] = 7.2000;
	points[22] = (-982.6299, 12788.3867, 3543.3071);
	angles[22] = (0, -138.6396, 0);
	at[22] = 7.5000;
	points[23] = (-711.8740, 12458.2285, 3543.3071);
	angles[23] = (0, -140.5937, 0);
	at[23] = 8.1000;
	points[24] = (-580.8937, 12289.2520, 3543.3071);
	angles[24] = (0, -141.6452, 0);
	at[24] = 8.4000;
	points[25] = (-454.7874, 12118.9766, 3543.3071);
	angles[25] = (0, -142.8393, 0);
	at[25] = 8.7000;
	points[26] = (-331.0260, 11941.9678, 3543.3071);
	angles[26] = (0, -144.2738, 0);
	at[26] = 9;
	points[27] = (-216.4185, 11764.7246, 3543.3071);
	angles[27] = (0, -146.1262, 0);
	at[27] = 9.3000;
	points[28] = (-111.2516, 11581.3379, 3543.3071);
	angles[28] = (0, -148.8369, 0);
	at[28] = 9.6000;
	points[29] = (-23.3165, 11385.5508, 3543.3071);
	angles[29] = (0, -153.6291, 0);
	at[29] = 9.9000;
	points[30] = (22.7141, 11191.0625, 3543.3071);
	angles[30] = (0, -161.9522, 0);
	at[30] = 10.2000;
	points[31] = (47.7102, 10980.8271, 3543.3071);
	angles[31] = (0, -169.0081, 0);
	at[31] = 10.5000;
	points[32] = (62.0677, 10762.3232, 3543.3071);
	angles[32] = (0, -173.5110, 0);
	at[32] = 10.8000;
	points[33] = (69.1693, 10552.4414, 3543.3071);
	angles[33] = (0, -176.3380, 0);
	at[33] = 11.1000;
	points[34] = (71.6492, 10336.8506, 3543.3071);
	angles[34] = (0, -178.2227, 0);
	at[34] = 11.4000;
	points[35] = (70.3697, 10124.5674, 3543.3071);
	angles[35] = (0, -179.5562, 0);
	at[35] = 11.7000;
	points[36] = (65.9378, 9909.7637, 3543.3071);
	angles[36] = (0, -180.5864, 0);
	at[36] = 12;
	points[37] = (58.8071, 9697.1650, 3543.3071);
	angles[37] = (0, -181.4342, 0);
	at[37] = 12.3000;
	points[38] = (36.8917, 9269.9209, 3543.3071);
	angles[38] = (0, -182.8785, 0);
	at[38] = 12.9000;
	points[39] = (4.7416, 8843.2676, 3543.3071);
	angles[39] = (0, -184.2805, 0);
	at[39] = 13.5000;
	points[40] = (-15.6281, 8631.8896, 3543.3071);
	angles[40] = (0, -185.0704, 0);
	at[40] = 13.8000;
	points[41] = (-40.0157, 8419.3311, 3543.3071);
	angles[41] = (0, -186.0402, 0);
	at[41] = 14.1000;
	points[42] = (-70.4157, 8204.1338, 3543.3071);
	angles[42] = (0, -187.3530, 0);
	at[42] = 14.4000;
	points[43] = (-110.0913, 7995.1572, 3543.3071);
	angles[43] = (0, -189.6058, 0);
	at[43] = 14.7000;
	points[44] = (-179.4854, 7807.3628, 3543.3071);
	angles[44] = (0, -197.2964, 0);
	at[44] = 15;
	points[45] = (-328.7602, 7655.5513, 3543.3071);
	angles[45] = (0, -214.7369, 0);
	at[45] = 15.3000;
	points[46] = (-510.7992, 7546.9683, 3543.3071);
	angles[46] = (0, -229.9321, 0);
	at[46] = 15.6000;
	points[47] = (-705.8111, 7461.7324, 3543.3071);
	angles[47] = (0, -240.1263, 0);
	at[47] = 15.9000;
	points[48] = (-906.5748, 7389.5278, 3543.3071);
	angles[48] = (0, -246.3660, 0);
	at[48] = 16.2000;
	points[49] = (-1313.4174, 7259.1343, 3543.3071);
	angles[49] = (0, -251.3431, 0);
	at[49] = 16.8000;
	points[50] = (-1514.2521, 7188.3862, 3543.3071);
	angles[50] = (0, -250.6758, 0);
	at[50] = 17.1000;
	points[51] = (-1699.2913, 7098.6221, 3543.3071);
	angles[51] = (0, -245.9564, 0);
	at[51] = 17.4000;
	points[52] = (-1876.6339, 6983.1890, 3543.3071);
	angles[52] = (0, -240.3822, 0);
	at[52] = 17.7000;
	points[53] = (-2228.6575, 6739.4883, 3543.3071);
	angles[53] = (0, -235.9836, 0);
	at[53] = 18.3000;
	points[54] = (-2753.0078, 6372.1655, 3543.3071);
	angles[54] = (0, -235.1231, 0);
	at[54] = 19.2000;
	points[55] = (-3105.0591, 6131.6538, 3543.3071);
	angles[55] = (0, -235.7060, 0);
	at[55] = 19.8000;
	points[56] = (-3282.0432, 6015, 3543.3071);
	angles[56] = (0, -236.3118, 0);
	at[56] = 20.1000;
	points[57] = (-3463.2756, 5900.6694, 3543.3071);
	angles[57] = (0, -237.2782, 0);
	at[57] = 20.4000;
	points[58] = (-3647.3149, 5793.5435, 3543.3071);
	angles[58] = (0, -238.9907, 0);
	at[58] = 20.7000;
	points[59] = (-3829.5552, 5703.7402, 3543.3071);
	angles[59] = (0, -242.0563, 0);
	at[59] = 21;
	points[60] = (-4022.2441, 5618.8979, 3543.3071);
	angles[60] = (0, -244.6649, 0);
	at[60] = 21.3000;
	points[61] = (-4222.4019, 5534.7637, 3543.3071);
	angles[61] = (0, -246.2398, 0);
	at[61] = 21.6000;
	points[62] = (-5408.1890, 5051.7720, 3543.3071);
	angles[62] = (0, -247.7225, 0);
	at[62] = 23.4000;
	points[63] = (-5997.0083, 4801.4175, 3543.3071);
	angles[63] = (0, -246.7371, 0);
	at[63] = 24.3000;
	points[64] = (-6192.5986, 4713.7007, 3543.3071);
	angles[64] = (0, -246.1584, 0);
	at[64] = 24.6000;
	points[65] = (-6384.5278, 4624.0552, 3543.3071);
	angles[65] = (0, -245.3672, 0);
	at[65] = 24.9000;
	points[66] = (-6578.7402, 4527.9531, 3543.3071);
	angles[66] = (0, -244.2586, 0);
	at[66] = 25.2000;
	points[67] = (-6761.1021, 4429.9214, 3543.3071);
	angles[67] = (0, -242.5823, 0);
	at[67] = 25.5000;
	points[68] = (-6944.6455, 4316.2603, 3543.3071);
	angles[68] = (0, -239.5817, 0);
	at[68] = 25.8000;
	points[69] = (-7096.4966, 4193.7798, 3543.3071);
	angles[69] = (0, -234.0874, 0);
	at[69] = 26.1000;
	points[70] = (-7251.2603, 4042.4016, 3543.3071);
	angles[70] = (0, -228.7389, 0);
	at[70] = 26.4000;
	points[71] = (-7398.6221, 3884.6062, 3543.3071);
	angles[71] = (0, -225.2009, 0);
	at[71] = 26.7000;
	points[72] = (-7538.7798, 3726.8113, 3543.3071);
	angles[72] = (0, -222.9668, 0);
	at[72] = 27;
	points[73] = (-7816.8506, 3400.8149, 3543.3071);
	angles[73] = (0, -220.7115, 0);
	at[73] = 27.6000;
	points[74] = (-8637.0469, 2417.2205, 3543.3071);
	angles[74] = (0, -220.0908, 0);
	at[74] = 29.4000;
	points[75] = (-8918.1895, 2093.9883, 3543.3071);
	angles[75] = (0, -221.0566, 0);
	at[75] = 30;
	points[76] = (-9060.5908, 1937.3071, 3543.3071);
	angles[76] = (0, -221.8470, 0);
	at[76] = 30.3000;
	points[77] = (-9209.8037, 1780.4567, 3543.3071);
	angles[77] = (0, -222.9924, 0);
	at[77] = 30.6000;
	points[78] = (-9360.5508, 1632.3623, 3543.3071);
	angles[78] = (0, -224.6396, 0);
	at[78] = 30.9000;
	points[79] = (-9520.7881, 1491.3583, 3543.3071);
	angles[79] = (0, -227.3526, 0);
	at[79] = 31.2000;
	points[80] = (-9699.2520, 1366.1890, 3543.3071);
	angles[80] = (0, -232.4992, 0);
	at[80] = 31.5000;
	points[81] = (-9878.8584, 1299.1575, 3543.3071);
	angles[81] = (0, -243.7240, 0);
	at[81] = 31.8000;
	points[82] = (-10091.5742, 1269.2834, 3543.3071);
	angles[82] = (0, -255.2506, 0);
	at[82] = 32.1000;
	points[83] = (-10309.9600, 1262.4921, 3543.3071);
	angles[83] = (0, -263.3126, 0);
	at[83] = 32.4000;
	points[84] = (-10517.7168, 1269.5591, 3543.3071);
	angles[84] = (0, -268.6854, 0);
	at[84] = 32.7000;
	points[85] = (-10732.1260, 1286.8110, 3543.3071);
	angles[85] = (0, -272.4049, 0);
	at[85] = 33;
	points[86] = (-10943.4258, 1311.7323, 3543.3071);
	angles[86] = (0, -275.1249, 0);
	at[86] = 33.3000;
	points[87] = (-11154.5664, 1343.3937, 3543.3071);
	angles[87] = (0, -277.2853, 0);
	at[87] = 33.6000;
	points[88] = (-11364.5674, 1380.9803, 3543.3071);
	angles[88] = (0, -279.1064, 0);
	at[88] = 33.9000;
	points[89] = (-11573.7002, 1424.1929, 3543.3071);
	angles[89] = (0, -280.7490, 0);
	at[89] = 34.2000;
	points[90] = (-11780.9443, 1472.6929, 3543.3071);
	angles[90] = (0, -282.3035, 0);
	at[90] = 34.5000;
	points[91] = (-11988.1094, 1527.0709, 3543.3071);
	angles[91] = (0, -283.8498, 0);
	at[91] = 34.8000;
	points[92] = (-12191.4170, 1586.6615, 3543.3071);
	angles[92] = (0, -285.4564, 0);
	at[92] = 35.1000;
	points[93] = (-12396.0625, 1653.7560, 3543.3071);
	angles[93] = (0, -287.2012, 0);
	at[93] = 35.4000;
	points[94] = (-12592.5205, 1726.2402, 3543.3071);
	angles[94] = (0, -289.1864, 0);
	at[94] = 35.7000;
	points[95] = (-12793.1104, 1810.7638, 3543.3071);
	angles[95] = (0, -291.5892, 0);
	at[95] = 36;
	points[96] = (-12983.0703, 1904.6891, 3543.3071);
	angles[96] = (0, -294.6641, 0);
	at[96] = 36.3000;
	points[97] = (-13162.3623, 2013.6417, 3543.3071);
	angles[97] = (0, -299.0851, 0);
	at[97] = 36.6000;
	points[98] = (-13312.0078, 2128.2520, 3543.3071);
	angles[98] = (0, -304.3480, 0);
	at[98] = 36.9000;
	points[99] = (-13486.1416, 2277.7874, 3543.3071);
	angles[99] = (0, -308.2982, 0);
	at[99] = 37.2000;
	points[100] = (-13634.4883, 2412.6458, 3543.3071);
	angles[100] = (0, -310.7557, 0);
	at[100] = 37.5000;
	points[101] = (-13797.4805, 2566.0786, 3543.3071);
	angles[101] = (0, -312.3234, 0);
	at[101] = 37.8000;
	points[102] = (-14097.5596, 2859.1101, 3543.3071);
	angles[102] = (0, -314.1555, 0);
	at[102] = 38.4000;
	points[103] = (-14253.3467, 3015.4604, 3543.3071);
	angles[103] = (0, -314.7581, 0);
	at[103] = 38.7000;
	points[104] = (-14401.3389, 3166.3306, 3543.3071);
	angles[104] = (0, -315.2634, 0);
	at[104] = 39;
	points[105] = (-14547.6768, 3317.5669, 3543.3071);
	angles[105] = (0, -315.6966, 0);
	at[105] = 39.3000;
	points[106] = (-14844.8428, 3630.6616, 3543.3071);
	angles[106] = (0, -316.4665, 0);
	at[106] = 39.9000;
	points[107] = (-14988.7793, 3785.1575, 3543.3071);
	angles[107] = (0, -316.8228, 0);
	at[107] = 40.2000;
	points[108] = (-15277.1660, 4100.2759, 3543.3071);
	angles[108] = (0, -317.5200, 0);
	at[108] = 40.8000;
	points[109] = (-15562.3223, 4419.8818, 3543.3071);
	angles[109] = (0, -318.2432, 0);
	at[109] = 41.4000;
	points[110] = (-15840.0400, 4739.9214, 3543.3071);
	angles[110] = (0, -319.0341, 0);
	at[110] = 42;
	points[111] = (-15981.0635, 4906.2993, 3543.3071);
	angles[111] = (0, -319.4803, 0);
	at[111] = 42.3000;
	points[112] = (-16117.4805, 5070.2759, 3543.3071);
	angles[112] = (0, -319.9734, 0);
	at[112] = 42.6000;
	points[113] = (-16248.5039, 5231.0234, 3543.3071);
	angles[113] = (0, -320.5185, 0);
	at[113] = 42.9000;
	points[114] = (-16385.3535, 5402.9917, 3543.3071);
	angles[114] = (0, -321.1472, 0);
	at[114] = 43.2000;
	points[115] = (-16517.2441, 5573.7012, 3543.3071);
	angles[115] = (0, -321.9052, 0);
	at[115] = 43.5000;
	points[116] = (-16639.2520, 5737.2441, 3543.3071);
	angles[116] = (0, -322.8054, 0);
	at[116] = 43.8000;
	points[117] = (-16768.8574, 5919.4092, 3543.3071);
	angles[117] = (0, -323.9572, 0);
	at[117] = 44.1000;
	points[118] = (-16886.2598, 6095.9453, 3543.3071);
	angles[118] = (0, -325.5598, 0);
	at[118] = 44.4000;
	points[119] = (-16995.1172, 6277.6772, 3543.3071);
	angles[119] = (0, -327.8340, 0);
	at[119] = 44.7000;
	points[120] = (-17088.6621, 6470.2759, 3543.3071);
	angles[120] = (0, -332.1718, 0);
	at[120] = 45;
	points[121] = (-17137.4805, 6652.1655, 3543.3071);
	angles[121] = (0, -340.5496, 0);
	at[121] = 45.3000;
	points[122] = (-17151.9297, 6871.6929, 3543.3071);
	angles[122] = (0, -350.5259, 0);
	at[122] = 45.6000;
	points[123] = (-17141.1426, 7078.2285, 3543.3071);
	angles[123] = (0, -358.3038, 0);
	at[123] = 45.9000;
	points[124] = (-17113.7793, 7294.5669, 3543.3071);
	angles[124] = (0, -363.9044, 0);
	at[124] = 46.2000;
	points[125] = (-17076.8105, 7500.4722, 3543.3071);
	angles[125] = (0, -367.8284, 0);
	at[125] = 46.5000;
	points[126] = (-17029.8809, 7714.1733, 3543.3071);
	angles[126] = (0, -370.6967, 0);
	at[126] = 46.8000;
	points[127] = (-16979.0156, 7916.6929, 3543.3071);
	angles[127] = (0, -372.8420, 0);
	at[127] = 47.1000;
	points[128] = (-16921.4570, 8124.3311, 3543.3071);
	angles[128] = (0, -374.5136, 0);
	at[128] = 47.4000;
	points[129] = (-16796.0625, 8531.0625, 3543.3071);
	angles[129] = (0, -376.9829, 0);
	at[129] = 48;
	points[130] = (-16657.8730, 8935.9053, 3543.3071);
	angles[130] = (0, -378.7518, 0);
	at[130] = 48.6000;
	points[131] = (-16510.5527, 9336.7725, 3543.3071);
	angles[131] = (0, -380.1105, 0);
	at[131] = 49.2000;
	points[132] = (-16356.7725, 9732.0078, 3543.3071);
	angles[132] = (0, -381.2110, 0);
	at[132] = 49.8000;
	points[133] = (-16275.1973, 9934.2520, 3543.3071);
	angles[133] = (0, -381.6955, 0);
	at[133] = 50.1000;
	points[134] = (-16196.6533, 10124.8818, 3543.3071);
	angles[134] = (0, -382.1392, 0);
	at[134] = 50.4000;
	points[135] = (-16110.6299, 10329.6455, 3543.3071);
	angles[135] = (0, -382.5546, 0);
	at[135] = 50.7000;
	points[136] = (-16030.6689, 10516.6533, 3543.3071);
	angles[136] = (0, -382.9374, 0);
	at[136] = 51;
	points[137] = (-15941.9287, 10720.8662, 3543.3071);
	angles[137] = (0, -383.2890, 0);
	at[137] = 51.3000;
	points[138] = (-15864.0947, 10895.0400, 3543.3071);
	angles[138] = (0, -383.8489, 0);
	at[138] = 51.6000;
	points[139] = (-15768.7803, 11093.0312, 3543.3071);
	angles[139] = (0, -385.0536, 0);
	at[139] = 51.9000;
	points[140] = (-15674.5273, 11279.5273, 3543.3071);
	angles[140] = (0, -386.1708, 0);
	at[140] = 52.2000;
	points[141] = (-15574.6064, 11470.4336, 3543.3071);
	angles[141] = (0, -387.0963, 0);
	at[141] = 52.5000;
	points[142] = (-15474.0547, 11657.2832, 3543.3071);
	angles[142] = (0, -387.8490, 0);
	at[142] = 52.8000;
	points[143] = (-15266.2207, 12030.0791, 3543.3071);
	angles[143] = (0, -389.0824, 0);
	at[143] = 53.4000;
	points[144] = (-15158.8584, 12216.4971, 3543.3071);
	angles[144] = (0, -389.6348, 0);
	at[144] = 53.7000;
	points[145] = (-15051.2598, 12399.3311, 3543.3071);
	angles[145] = (0, -390.1762, 0);
	at[145] = 54;
	points[146] = (-14828.9766, 12764.4883, 3543.3071);
	angles[146] = (0, -391.3066, 0);
	at[146] = 54.6000;
	points[147] = (-14715.7480, 12943.8193, 3543.3071);
	angles[147] = (0, -391.9310, 0);
	at[147] = 54.9000;
	points[148] = (-14598.6611, 13124.1338, 3543.3071);
	angles[148] = (0, -392.6238, 0);
	at[148] = 55.2000;
	points[149] = (-14480.4717, 13300.3545, 3543.3071);
	angles[149] = (0, -393.4186, 0);
	at[149] = 55.5000;
	points[150] = (-14357.8740, 13476.4170, 3543.3071);
	angles[150] = (0, -394.3502, 0);
	at[150] = 55.8000;
	points[151] = (-14232.6777, 13647.9922, 3543.3071);
	angles[151] = (0, -395.5077, 0);
	at[151] = 56.1000;
	points[152] = (-14100.7080, 13818.2686, 3543.3071);
	angles[152] = (0, -396.9881, 0);
	at[152] = 56.4000;
	points[153] = (-13966.6152, 13977.4014, 3543.3071);
	angles[153] = (0, -399.0688, 0);
	at[153] = 56.7000;
	points[154] = (-13814.2129, 14135.5117, 3543.3071);
	angles[154] = (0, -402.3532, 0);
	at[154] = 57;
	points[155] = (-13666.6934, 14255.9453, 3543.3071);
	angles[155] = (0, -407.9130, 0);
	at[155] = 57.3000;
	points[156] = (-13480, 14377.4414, 3543.3071);
	angles[156] = (0, -413.6024, 0);
	at[156] = 57.6000;
	points[157] = (-13302.5195, 14479.7246, 3543.3071);
	angles[157] = (0, -417.6049, 0);
	at[157] = 57.9000;
	points[158] = (-13108.8975, 14583.1494, 3543.3071);
	angles[158] = (0, -420.2906, 0);
	at[158] = 58.2000;
	points[159] = (-12922.9141, 14677.0869, 3543.3071);
	angles[159] = (0, -422.1091, 0);
	at[159] = 58.5000;
	points[160] = (-12725.0400, 14772.7168, 3543.3071);
	angles[160] = (0, -423.4280, 0);
	at[160] = 58.8000;
	points[161] = (-12536.2207, 14860.6689, 3543.3071);
	angles[161] = (0, -424.4342, 0);
	at[161] = 59.1000;
	points[162] = (-12340.2754, 14949.0947, 3543.3071);
	angles[162] = (0, -425.2471, 0);
	at[162] = 59.4000;
	points[163] = (-11949.1738, 15118.1895, 3543.3071);
	angles[163] = (0, -426.5562, 0);
	at[163] = 60;
	points[164] = (-11553.2676, 15280.5518, 3543.3071);
	angles[164] = (0, -427.6580, 0);
	at[164] = 60.6000;
	points[165] = (-11355.6689, 15358.5039, 3543.3071);
	angles[165] = (0, -428.1820, 0);
	at[165] = 60.9000;
	points[166] = (-10954.9219, 15510.0791, 3543.3071);
	angles[166] = (0, -429.2589, 0);
	at[166] = 61.5000;
	points[167] = (-10758.7012, 15580.8662, 3543.3071);
	angles[167] = (0, -429.8425, 0);
	at[167] = 61.8000;
	points[168] = (-10551.1816, 15652.9521, 3543.3071);
	angles[168] = (0, -430.4991, 0);
	at[168] = 62.1000;
	points[169] = (-10353.8584, 15718.3467, 3543.3071);
	angles[169] = (0, -431.2588, 0);
	at[169] = 62.4000;
	points[170] = (-10143.7402, 15783.8193, 3543.3071);
	angles[170] = (0, -432.1963, 0);
	at[170] = 62.7000;
	points[171] = (-9946.8896, 15839.9219, 3543.3071);
	angles[171] = (0, -433.4486, 0);
	at[171] = 63;
	points[172] = (-9730.1182, 15892.6777, 3543.3071);
	angles[172] = (0, -435.3952, 0);
	at[172] = 63.3000;
	points[173] = (-9542.8740, 15923.6221, 3543.3071);
	angles[173] = (0, -438.8842, 0);
	at[173] = 63.6000;
	points[174] = (-9321.6143, 15940.5127, 3543.3071);
	angles[174] = (0, -443.1635, 0);
	at[174] = 63.9000;
	points[175] = (-9116.9688, 15945.9453, 3543.3071);
	angles[175] = (0, -446.4821, 0);
	at[175] = 64.2000;
	points[176] = (-8898.4258, 15945.0791, 3543.3071);
	angles[176] = (0, -448.8362, 0);
	at[176] = 64.5000;
	points[177] = (-8689.2129, 15939.6855, 3543.3071);
	angles[177] = (0, -450.4946, 0);
	at[177] = 64.8000;
	points[178] = (-8471.6934, 15930.3555, 3543.3071);
	angles[178] = (0, -451.7275, 0);
	at[178] = 65.1000;
	points[179] = (-8262.2051, 15918.5430, 3543.3071);
	angles[179] = (0, -452.6791, 0);
	at[179] = 65.4000;
	points[180] = (-8046.9688, 15903.8584, 3543.3071);
	angles[180] = (0, -453.4543, 0);
	at[180] = 65.7000;
	points[181] = (-7835.5122, 15887.2451, 3543.3071);
	angles[181] = (0, -454.1151, 0);
	at[181] = 66;
	points[182] = (-7410.1182, 15847.9131, 3543.3071);
	angles[182] = (0, -455.2295, 0);
	at[182] = 66.6000;
	points[183] = (-6987.5591, 15801.6143, 3543.3071);
	angles[183] = (0, -456.2203, 0);
	at[183] = 67.2000;
	points[184] = (-6773.0708, 15775.3545, 3543.3071);
	angles[184] = (0, -456.7134, 0);
	at[184] = 67.5000;
	points[185] = (-6565.1577, 15747.9521, 3543.3071);
	angles[185] = (0, -457.2234, 0);
	at[185] = 67.8000;
	points[186] = (-6349.4487, 15717.3623, 3543.3071);
	angles[186] = (0, -457.7764, 0);
	at[186] = 68.1000;
	points[187] = (-6142.9136, 15685.5908, 3543.3071);
	angles[187] = (0, -458.4049, 0);
	at[187] = 68.4000;
	points[188] = (-5926.9297, 15649.2129, 3543.3071);
	angles[188] = (0, -459.1641, 0);
	at[188] = 68.7000;
	points[189] = (-5726.8506, 15611.4570, 3543.3071);
	angles[189] = (0, -460.1656, 0);
	at[189] = 69;
	points[190] = (-5510.4727, 15563.5430, 3543.3071);
	angles[190] = (0, -461.7572, 0);
	at[190] = 69.3000;
	points[191] = (-5443.8188, 15546.1807, 3543.3071);
	angles[191] = (0, -462.6346, 0);
	at[191] = 69.4167;
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
	points[0] = (-9386.7715, 10579.0156, 1252.8503);
	angles[0] = (0, -135, 0);
	at[0] = 0;
	points[1] = (-9386.7715, 10579.0156, 1252.8503);
	angles[1] = (0, -135, 0);
	at[1] = 0.1833;
	points[2] = (-9382.6777, 10584.4883, 1252.8503);
	angles[2] = (0, -135, 0);
	at[2] = 0.5500;
	points[3] = (-9382.2441, 10585.0391, 1252.8503);
	angles[3] = (0, -135, 0);
	at[3] = 1.1000;
	points[4] = (-9378.2285, 10590.4336, 1252.8503);
	angles[4] = (0, -135, 0);
	at[4] = 1.2833;
	points[5] = (-9378.1494, 10590.5518, 1252.8503);
	angles[5] = (0, -135, 0);
	at[5] = 1.8333;
	points[6] = (-9373.6221, 10596.5752, 1252.8503);
	angles[6] = (0, -135, 0);
	at[6] = 2.2000;
	points[7] = (-9373.3857, 10596.8906, 1252.8503);
	angles[7] = (0, -135, 0);
	at[7] = 2.7500;
	points[8] = (-9369.2910, 10602.3623, 1252.8503);
	angles[8] = (0, -135, 0);
	at[8] = 2.9333;
	points[9] = (-9369.0947, 10602.6387, 1252.8503);
	angles[9] = (0, -135, 0);
	at[9] = 3.4833;
	points[10] = (-9364.5674, 10608.7012, 1252.8503);
	angles[10] = (0, -135, 0);
	at[10] = 3.8500;
	points[11] = (-9364.4883, 10608.7803, 1252.8503);
	angles[11] = (0, -135, 0);
	at[11] = 4.4000;
	points[12] = (-9360.4336, 10614.1738, 1252.8503);
	angles[12] = (0, -135, 0);
	at[12] = 4.5833;
	points[13] = (-9360, 10614.7246, 1252.8503);
	angles[13] = (0, -135, 0);
	at[13] = 5.1333;
	points[14] = (-9355.4727, 10620.7881, 1252.8503);
	angles[14] = (0, -135, 0);
	at[14] = 5.5000;
	points[15] = (-9355.4727, 10620.7881, 1252.8503);
	angles[15] = (0, -135, 0);
	at[15] = 6.0500;
	points[16] = (-9351.6533, 10625.9062, 1252.8503);
	angles[16] = (0, -135, 0);
	at[16] = 6.2333;
	points[17] = (-9350.9453, 10626.8506, 1252.8503);
	angles[17] = (0, -135, 0);
	at[17] = 6.7833;
	points[18] = (-9349.8818, 10628.2686, 1252.8503);
	angles[18] = (0, -135, 0);
	at[18] = 6.9667;
	points[19] = (-9346.4180, 10632.9131, 1252.8503);
	angles[19] = (0, -135, 0);
	at[19] = 7.1500;
	points[20] = (-9346.4180, 10632.9131, 1252.8503);
	angles[20] = (0, -135, 0);
	at[20] = 7.7000;
	points[21] = (-9342.9531, 10637.5195, 1252.8503);
	angles[21] = (0, -135, 0);
	at[21] = 7.8833;
	points[22] = (-9341.8896, 10638.9375, 1252.8503);
	angles[22] = (0, -135, 0);
	at[22] = 8.0667;
	points[23] = (-9341.1816, 10639.8818, 1252.8503);
	angles[23] = (0, -135, 0);
	at[23] = 8.6167;
	points[24] = (-9337.3623, 10645, 1252.8503);
	angles[24] = (0, -135, 0);
	at[24] = 8.8000;
	points[25] = (-9337.3623, 10645, 1252.8503);
	angles[25] = (0, -135, 0);
	at[25] = 9.3500;
	points[26] = (-9332.8350, 10651.0625, 1252.8503);
	angles[26] = (0, -135, 0);
	at[26] = 9.7167;
	points[27] = (-9332.4014, 10651.6143, 1252.8503);
	angles[27] = (0, -135, 0);
	at[27] = 10.2667;
	points[28] = (-9328.3857, 10657.0078, 1252.8503);
	angles[28] = (0, -135, 0);
	at[28] = 10.4500;
	points[29] = (-9328.3066, 10657.0869, 1252.8503);
	angles[29] = (0, -135, 0);
	at[29] = 11;
	points[30] = (-9323.7803, 10663.1494, 1252.8503);
	angles[30] = (0, -135, 0);
	at[30] = 11.3667;
	points[31] = (-9323.5830, 10663.4258, 1252.8503);
	angles[31] = (0, -135, 0);
	at[31] = 11.9167;
	points[32] = (-9319.4492, 10668.9375, 1252.8937);
	angles[32] = (0, -135, 0);
	at[32] = 12.1000;
	points[33] = (-9319.2520, 10669.2119, 1252.8977);
	angles[33] = (0, -135, 0);
	at[33] = 12.6500;
	points[34] = (-9314.7246, 10675.2363, 1252.9685);
	angles[34] = (0, -135, 0);
	at[34] = 13.0167;
	points[35] = (-9314.6455, 10675.3545, 1252.9685);
	angles[35] = (0, -135, 0);
	at[35] = 13.5667;
	points[36] = (-9310.6299, 10680.7480, 1253.0315);
	angles[36] = (0, -135, 0);
	at[36] = 13.7500;
	points[37] = (-9310.1973, 10681.2988, 1253.0394);
	angles[37] = (0, -135, 0);
	at[37] = 14.3000;
	points[38] = (-9305.6689, 10687.3633, 1253.1102);
	angles[38] = (0, -135, 0);
	at[38] = 14.6667;
	points[39] = (-9305.6689, 10687.3633, 1253.1102);
	angles[39] = (0, -135, 0);
	at[39] = 15.2167;
	points[40] = (-9301.8506, 10692.4805, 1253.1693);
	angles[40] = (0, -135, 0);
	at[40] = 15.4000;
	points[41] = (-9301.1416, 10693.4258, 1253.1771);
	angles[41] = (0, -135, 0);
	at[41] = 15.9500;
	points[42] = (-9300.0791, 10694.8418, 1253.1969);
	angles[42] = (0, -135, 0);
	at[42] = 16.1333;
	points[43] = (-9296.6143, 10699.4482, 1253.2480);
	angles[43] = (0, -135, 0);
	at[43] = 16.3167;
	points[44] = (-9296.6143, 10699.4482, 1253.2480);
	angles[44] = (0, -135, 0);
	at[44] = 16.8667;
	points[45] = (-9293.1104, 10704.0947, 1253.3032);
	angles[45] = (0, -135, 0);
	at[45] = 17.0500;
	points[46] = (-9292.0479, 10705.5127, 1253.3188);
	angles[46] = (0, -135, 0);
	at[46] = 17.2333;
	points[47] = (-9291.3779, 10706.4570, 1253.3307);
	angles[47] = (0, -135, 0);
	at[47] = 17.7833;
	points[48] = (-9287.5195, 10711.5752, 1253.3898);
	angles[48] = (0, -135, 0);
	at[48] = 17.9667;
	points[49] = (-9287.5195, 10711.5752, 1253.3898);
	angles[49] = (0, -135, 0);
	at[49] = 18.5167;
	points[50] = (-9282.9922, 10717.5986, 1253.4607);
	angles[50] = (0, -135, 0);
	at[50] = 18.8833;
	points[51] = (-9282.5986, 10718.1895, 1253.4685);
	angles[51] = (0, -135, 0);
	at[51] = 19.4333;
	points[52] = (-9278.5439, 10723.5830, 1253.5276);
	angles[52] = (0, -135, 0);
	at[52] = 19.6167;
	points[53] = (-9276.4961, 10726.2988, 1253.5630);
	angles[53] = (0, -135, 0);
	at[53] = 20.5333;
	points[54] = (-9277.1260, 10725.4727, 1253.5513);
	angles[54] = (0, -135, 0);
	at[54] = 20.7167;
	points[55] = (-9280.5908, 10720.8662, 1253.4961);
	angles[55] = (0, -135, 0);
	at[55] = 20.9000;
	points[56] = (-9280.5908, 10720.8662, 1253.4961);
	angles[56] = (0, -135, 0);
	at[56] = 21.4500;
	points[57] = (-9284.0557, 10716.2197, 1253.4448);
	angles[57] = (0, -135, 0);
	at[57] = 21.6333;
	points[58] = (-9285.1182, 10714.8037, 1253.4291);
	angles[58] = (0, -135, 0);
	at[58] = 21.8167;
	points[59] = (-9285.8271, 10713.8584, 1253.4174);
	angles[59] = (0, -135, 0);
	at[59] = 22.3667;
	points[60] = (-9289.6455, 10708.7412, 1253.3583);
	angles[60] = (0, -135, 0);
	at[60] = 22.5500;
	points[61] = (-9289.6455, 10708.7412, 1253.3583);
	angles[61] = (0, -135, 0);
	at[61] = 23.1000;
	points[62] = (-9294.1738, 10702.7168, 1253.2874);
	angles[62] = (0, -135, 0);
	at[62] = 23.4667;
	points[63] = (-9294.6064, 10702.1270, 1253.2795);
	angles[63] = (0, -135, 0);
	at[63] = 24.0167;
	points[64] = (-9298.6221, 10696.7324, 1253.2166);
	angles[64] = (0, -135, 0);
	at[64] = 24.2000;
	points[65] = (-9298.7012, 10696.6543, 1253.2166);
	angles[65] = (0, -135, 0);
	at[65] = 24.7500;
	points[66] = (-9303.2285, 10690.5898, 1253.1458);
	angles[66] = (0, -135, 0);
	at[66] = 25.1167;
	points[67] = (-9303.4258, 10690.3154, 1253.1417);
	angles[67] = (0, -135, 0);
	at[67] = 25.6667;
	points[68] = (-9307.5596, 10684.8418, 1253.0787);
	angles[68] = (0, -135, 0);
	at[68] = 25.8500;
	points[69] = (-9307.7559, 10684.5273, 1253.0748);
	angles[69] = (0, -135, 0);
	at[69] = 26.4000;
	points[70] = (-9312.2832, 10678.5049, 1253.0079);
	angles[70] = (0, -135, 0);
	at[70] = 26.7667;
	points[71] = (-9312.3623, 10678.3857, 1253.0039);
	angles[71] = (0, -135, 0);
	at[71] = 27.3167;
	points[72] = (-9316.3779, 10672.9922, 1252.9409);
	angles[72] = (0, -135, 0);
	at[72] = 27.5000;
	points[73] = (-9316.8115, 10672.4404, 1252.9370);
	angles[73] = (0, -135, 0);
	at[73] = 28.0500;
	points[74] = (-9321.3389, 10666.3779, 1252.8661);
	angles[74] = (0, -135, 0);
	at[74] = 28.4167;
	points[75] = (-9321.3389, 10666.3779, 1252.8661);
	angles[75] = (0, -135, 0);
	at[75] = 28.9667;
	points[76] = (-9325.1572, 10661.2988, 1252.8503);
	angles[76] = (0, -135, 0);
	at[76] = 29.1500;
	points[77] = (-9325.8662, 10660.3545, 1252.8503);
	angles[77] = (0, -135, 0);
	at[77] = 29.7000;
	points[78] = (-9326.9297, 10658.9375, 1252.8503);
	angles[78] = (0, -135, 0);
	at[78] = 29.8833;
	points[79] = (-9330.3936, 10654.2910, 1252.8503);
	angles[79] = (0, -135, 0);
	at[79] = 30.0667;
	points[80] = (-9330.3936, 10654.2910, 1252.8503);
	angles[80] = (0, -135, 0);
	at[80] = 30.6167;
	points[81] = (-9333.8975, 10649.6465, 1252.8503);
	angles[81] = (0, -135, 0);
	at[81] = 30.8000;
	points[82] = (-9334.9609, 10648.2285, 1252.8503);
	angles[82] = (0, -135, 0);
	at[82] = 30.9833;
	points[83] = (-9335.6699, 10647.2842, 1252.8503);
	angles[83] = (0, -135, 0);
	at[83] = 31.5333;
	points[84] = (-9339.4883, 10642.2051, 1252.8503);
	angles[84] = (0, -135, 0);
	at[84] = 31.7167;
	points[85] = (-9339.4883, 10642.2051, 1252.8503);
	angles[85] = (0, -135, 0);
	at[85] = 32.2667;
	points[86] = (-9344.0156, 10636.1416, 1252.8503);
	angles[86] = (0, -135, 0);
	at[86] = 32.6333;
	points[87] = (-9344.4102, 10635.5518, 1252.8503);
	angles[87] = (0, -135, 0);
	at[87] = 33.1833;
	points[88] = (-9348.4648, 10630.1963, 1252.8503);
	angles[88] = (0, -135, 0);
	at[88] = 33.3667;
	points[89] = (-9348.5439, 10630.0791, 1252.8503);
	angles[89] = (0, -135, 0);
	at[89] = 33.9167;
	points[90] = (-9353.0703, 10624.0166, 1252.8503);
	angles[90] = (0, -135, 0);
	at[90] = 34.2833;
	points[91] = (-9353.2676, 10623.7402, 1252.8503);
	angles[91] = (0, -135, 0);
	at[91] = 34.8333;
	points[92] = (-9357.3623, 10618.2686, 1252.8503);
	angles[92] = (0, -135, 0);
	at[92] = 35.0167;
	points[93] = (-9357.5986, 10617.9922, 1252.8503);
	angles[93] = (0, -135, 0);
	at[93] = 35.5667;
	points[94] = (-9362.1260, 10611.9297, 1252.8503);
	angles[94] = (0, -135, 0);
	at[94] = 35.9333;
	points[95] = (-9362.2051, 10611.8496, 1252.8503);
	angles[95] = (0, -135, 0);
	at[95] = 36.4833;
	points[96] = (-9366.2207, 10606.4561, 1252.8503);
	angles[96] = (0, -135, 0);
	at[96] = 36.6667;
	points[97] = (-9366.6533, 10605.8662, 1252.8503);
	angles[97] = (0, -135, 0);
	at[97] = 37.2167;
	points[98] = (-9371.1816, 10599.8428, 1252.8503);
	angles[98] = (0, -135, 0);
	at[98] = 37.5833;
	points[99] = (-9371.1816, 10599.8428, 1252.8503);
	angles[99] = (0, -135, 0);
	at[99] = 38.1333;
	points[100] = (-9375, 10594.7236, 1252.8503);
	angles[100] = (0, -135, 0);
	at[100] = 38.3167;
	points[101] = (-9375.7090, 10593.7793, 1252.8503);
	angles[101] = (0, -135, 0);
	at[101] = 38.8667;
	points[102] = (-9376.7715, 10592.3623, 1252.8503);
	angles[102] = (0, -135, 0);
	at[102] = 39.0500;
	points[103] = (-9380.2363, 10587.7168, 1252.8503);
	angles[103] = (0, -135, 0);
	at[103] = 39.2333;
	points[104] = (-9380.2363, 10587.7168, 1252.8503);
	angles[104] = (0, -135, 0);
	at[104] = 39.7833;
	points[105] = (-9383.7002, 10583.1104, 1252.8503);
	angles[105] = (0, -135, 0);
	at[105] = 39.9667;
	points[106] = (-9386.7715, 10579.0156, 1252.8503);
	angles[106] = (0, -135, 0);
	at[106] = 40.8333;
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
	points[0] = (-6018.1890, 13737.3613, 1398.2480);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6026.2988, 13727.4414, 1398.2520);
	angles[1] = (0, 0, 0);
	at[1] = 1.2500;
	points[2] = (-6051.8110, 13707.5195, 1398.0984);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	points[3] = (-6109.2124, 13674.9609, 1397.5591);
	angles[3] = (0, 0, 0);
	at[3] = 12.0833;
	points[4] = (-6165.5122, 13652.2842, 1396.9174);
	angles[4] = (0, 0, 0);
	at[4] = 18.7500;
	points[5] = (-6182.7563, 13648.5830, 1396.7086);
	angles[5] = (0, 0, 0);
	at[5] = 20.8333;
	points[6] = (-6194.9609, 13649.7646, 1396.5039);
	angles[6] = (0, 0, 0);
	at[6] = 22.0833;
	points[7] = (-6204.9609, 13663.1104, 1396.1575);
	angles[7] = (0, 0, 0);
	at[7] = 24.1667;
	points[8] = (-6213.7012, 13684.2129, 1395.7834);
	angles[8] = (0, 0, 0);
	at[8] = 26.6667;
	points[9] = (-6234.5669, 13762.7168, 1394.4409);
	angles[9] = (0, 0, 0);
	at[9] = 35.4167;
	points[10] = (-6242.3228, 13809.8818, 1393.6851);
	angles[10] = (0, 0, 0);
	at[10] = 40.8333;
	points[11] = (-6244.5669, 13837.8740, 1393.2638);
	angles[11] = (0, 0, 0);
	at[11] = 43.7500;
	points[12] = (-6244.1338, 13855.1973, 1393.0198);
	angles[12] = (0, 0, 0);
	at[12] = 45.8333;
	points[13] = (-6243.3071, 13860.9844, 1392.9448);
	angles[13] = (0, 0, 0);
	at[13] = 46.2500;
	points[14] = (-6240.3545, 13869.2910, 1392.8544);
	angles[14] = (0, 0, 0);
	at[14] = 47.5000;
	points[15] = (-6231.7324, 13878.9365, 1392.8032);
	angles[15] = (0, 0, 0);
	at[15] = 48.7500;
	points[16] = (-6205.4727, 13897.7168, 1392.7993);
	angles[16] = (0, 0, 0);
	at[16] = 52.5000;
	points[17] = (-6140.1968, 13931.7725, 1393.3464);
	angles[17] = (0, 0, 0);
	at[17] = 60.4167;
	points[18] = (-6076.1416, 13956.2207, 1394.1102);
	angles[18] = (0, 0, 0);
	at[18] = 67.9167;
	points[19] = (-6051.8110, 13961.4971, 1394.4922);
	angles[19] = (0, 0, 0);
	at[19] = 70.8333;
	points[20] = (-6039.4883, 13960.3936, 1394.7362);
	angles[20] = (0, 0, 0);
	at[20] = 72.0833;
	points[21] = (-6033.3857, 13952.9531, 1394.9528);
	angles[21] = (0, 0, 0);
	at[21] = 73.3333;
	points[22] = (-6025.9844, 13931.5752, 1395.3779);
	angles[22] = (0, 0, 0);
	at[22] = 75.8333;
	points[23] = (-6015.0396, 13864.2529, 1396.4843);
	angles[23] = (0, 0, 0);
	at[23] = 83.3333;
	points[24] = (-6011.3779, 13783.0713, 1397.6968);
	angles[24] = (0, 0, 0);
	at[24] = 92.0833;
	points[25] = (-6014.0552, 13750.8662, 1398.1219);
	angles[25] = (0, 0, 0);
	at[25] = 95.8333;
	points[26] = (-6015.2754, 13745.1963, 1398.1812);
	angles[26] = (0, 0, 0);
	at[26] = 96.2500;
	points[27] = (-6018.1890, 13737.3613, 1398.2480);
	angles[27] = (0, 0, 0);
	at[27] = 97.4833;
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
	points[0] = (-713.1890, 3894.4133, 1419.4292);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-719.2717, 3887.3345, 1419.3899);
	angles[1] = (0, 90, 0);
	at[1] = 1.3333;
	points[2] = (-723.0394, 3882.9451, 1419.3622);
	angles[2] = (0, 90, 0);
	at[2] = 1.6000;
	points[3] = (-723.5040, 3882.4055, 1419.3583);
	angles[3] = (0, 90, 0);
	at[3] = 2.1333;
	points[4] = (-727.9685, 3877.2087, 1419.3307);
	angles[4] = (0, 90, 0);
	at[4] = 2.4000;
	points[5] = (-728.0433, 3877.1221, 1419.3307);
	angles[5] = (0, 90, 0);
	at[5] = 2.9333;
	points[6] = (-732.8937, 3871.4766, 1419.2953);
	angles[6] = (0, 90, 0);
	at[6] = 3.2000;
	points[7] = (-732.8937, 3871.4766, 1419.2953);
	angles[7] = (0, 90, 0);
	at[7] = 3.7333;
	points[8] = (-737.8189, 3865.7444, 1419.2638);
	angles[8] = (0, 90, 0);
	at[8] = 4;
	points[9] = (-737.8189, 3865.7444, 1419.2638);
	angles[9] = (0, 90, 0);
	at[9] = 4.5333;
	points[10] = (-742.5118, 3860.2795, 1419.2323);
	angles[10] = (0, 90, 0);
	at[10] = 4.8000;
	points[11] = (-742.7441, 3860.0078, 1419.2323);
	angles[11] = (0, 90, 0);
	at[11] = 5.3333;
	points[12] = (-746.8977, 3855.1694, 1419.2008);
	angles[12] = (0, 90, 0);
	at[12] = 5.6000;
	points[13] = (-747.6693, 3854.2756, 1419.1969);
	angles[13] = (0, 90, 0);
	at[13] = 6.1333;
	points[14] = (-750.9764, 3850.4211, 1419.1772);
	angles[14] = (0, 90, 0);
	at[14] = 6.4000;
	points[15] = (-752.5945, 3848.5393, 1419.1653);
	angles[15] = (0, 90, 0);
	at[15] = 6.9333;
	points[16] = (-757.5197, 3842.8071, 1419.1299);
	angles[16] = (0, 90, 0);
	at[16] = 7.4667;
	points[17] = (-758.6732, 3841.4644, 1419.1221);
	angles[17] = (0, 90, 0);
	at[17] = 8;
	points[18] = (-762.4449, 3837.0750, 1419.0985);
	angles[18] = (0, 90, 0);
	at[18] = 8.2667;
	points[19] = (-762.9055, 3836.5354, 1419.0945);
	angles[19] = (0, 90, 0);
	at[19] = 8.8000;
	points[20] = (-767.3701, 3831.3386, 1419.0669);
	angles[20] = (0, 90, 0);
	at[20] = 9.0667;
	points[21] = (-767.4489, 3831.2480, 1419.0630);
	angles[21] = (0, 90, 0);
	at[21] = 9.6000;
	points[22] = (-772.2953, 3825.6064, 1419.0315);
	angles[22] = (0, 90, 0);
	at[22] = 9.8667;
	points[23] = (-772.2953, 3825.6064, 1419.0315);
	angles[23] = (0, 90, 0);
	at[23] = 10.4000;
	points[24] = (-777.2205, 3819.8699, 1419);
	angles[24] = (0, 90, 0);
	at[24] = 10.6667;
	points[25] = (-777.2205, 3819.8699, 1419);
	angles[25] = (0, 90, 0);
	at[25] = 11.2000;
	points[26] = (-781.9174, 3814.4058, 1418.9725);
	angles[26] = (0, 90, 0);
	at[26] = 11.4667;
	points[27] = (-782.1772, 3814.5432, 1418.9725);
	angles[27] = (0, 90, 0);
	at[27] = 12;
	points[28] = (-787.0040, 3818.7087, 1418.9961);
	angles[28] = (0, 90, 0);
	at[28] = 12.2667;
	points[29] = (-787.8976, 3819.4805, 1419);
	angles[29] = (0, 90, 0);
	at[29] = 12.8000;
	points[30] = (-791.7441, 3822.8030, 1419.0197);
	angles[30] = (0, 90, 0);
	at[30] = 13.0667;
	points[31] = (-793.6181, 3824.4211, 1419.0315);
	angles[31] = (0, 90, 0);
	at[31] = 13.6000;
	points[32] = (-799.3426, 3829.3623, 1419.0591);
	angles[32] = (0, 90, 0);
	at[32] = 14.1333;
	points[33] = (-800.6811, 3830.5195, 1419.0669);
	angles[33] = (0, 90, 0);
	at[33] = 14.6667;
	points[34] = (-805.0630, 3834.3030, 1419.0906);
	angles[34] = (0, 90, 0);
	at[34] = 14.9333;
	points[35] = (-805.5984, 3834.7678, 1419.0945);
	angles[35] = (0, 90, 0);
	at[35] = 15.4667;
	points[36] = (-810.7835, 3839.2441, 1419.1221);
	angles[36] = (0, 90, 0);
	at[36] = 15.7333;
	points[37] = (-810.8741, 3839.3188, 1419.1221);
	angles[37] = (0, 90, 0);
	at[37] = 16.2667;
	points[38] = (-816.5040, 3844.1853, 1419.1536);
	angles[38] = (0, 90, 0);
	at[38] = 16.5333;
	points[39] = (-816.5040, 3844.1853, 1419.1536);
	angles[39] = (0, 90, 0);
	at[39] = 17.0667;
	points[40] = (-822.2244, 3849.1260, 1419.1810);
	angles[40] = (0, 90, 0);
	at[40] = 17.3333;
	points[41] = (-822.2244, 3849.1260, 1419.1810);
	angles[41] = (0, 90, 0);
	at[41] = 17.8667;
	points[42] = (-827.6772, 3853.8347, 1419.2126);
	angles[42] = (0, 90, 0);
	at[42] = 18.1333;
	points[43] = (-827.9449, 3854.0632, 1419.2126);
	angles[43] = (0, 90, 0);
	at[43] = 18.6667;
	points[44] = (-832.7716, 3858.2324, 1419.2401);
	angles[44] = (0, 90, 0);
	at[44] = 18.9333;
	points[45] = (-833.6693, 3859.0039, 1419.2441);
	angles[45] = (0, 90, 0);
	at[45] = 19.4667;
	points[46] = (-837.5118, 3862.3228, 1419.2638);
	angles[46] = (0, 90, 0);
	at[46] = 19.7333;
	points[47] = (-839.3898, 3863.9451, 1419.2755);
	angles[47] = (0, 90, 0);
	at[47] = 20.2667;
	points[48] = (-845.1102, 3868.8857, 1419.3032);
	angles[48] = (0, 90, 0);
	at[48] = 20.8000;
	points[49] = (-846.4488, 3870.0435, 1419.3110);
	angles[49] = (0, 90, 0);
	at[49] = 21.3333;
	points[50] = (-850.8307, 3873.8269, 1419.3347);
	angles[50] = (0, 90, 0);
	at[50] = 21.6000;
	points[51] = (-851.3661, 3874.2913, 1419.3386);
	angles[51] = (0, 90, 0);
	at[51] = 22.1333;
	points[52] = (-856.5511, 3878.7678, 1419.3661);
	angles[52] = (0, 90, 0);
	at[52] = 22.4000;
	points[53] = (-856.6417, 3878.8425, 1419.3661);
	angles[53] = (0, 90, 0);
	at[53] = 22.9333;
	points[54] = (-862.2716, 3883.7087, 1419.3977);
	angles[54] = (0, 90, 0);
	at[54] = 23.2000;
	points[55] = (-862.2716, 3883.7087, 1419.3977);
	angles[55] = (0, 90, 0);
	at[55] = 23.7333;
	points[56] = (-867.9922, 3888.6458, 1419.4252);
	angles[56] = (0, 90, 0);
	at[56] = 24;
	points[57] = (-867.9922, 3888.6458, 1419.4252);
	angles[57] = (0, 90, 0);
	at[57] = 24.5333;
	points[58] = (-873.4489, 3893.3582, 1419.4567);
	angles[58] = (0, 90, 0);
	at[58] = 24.8000;
	points[59] = (-873.7166, 3893.5867, 1419.4567);
	angles[59] = (0, 90, 0);
	at[59] = 25.3333;
	points[60] = (-878.5433, 3897.7559, 1419.4843);
	angles[60] = (0, 90, 0);
	at[60] = 25.6000;
	points[61] = (-879.4370, 3898.5276, 1419.4882);
	angles[61] = (0, 90, 0);
	at[61] = 26.1333;
	points[62] = (-883.2795, 3901.8467, 1419.5079);
	angles[62] = (0, 90, 0);
	at[62] = 26.4000;
	points[63] = (-885.1575, 3903.4685, 1419.5198);
	angles[63] = (0, 90, 0);
	at[63] = 26.9333;
	points[64] = (-890.8779, 3908.4094, 1419.5472);
	angles[64] = (0, 90, 0);
	at[64] = 27.4667;
	points[65] = (-892.2205, 3909.5671, 1419.5552);
	angles[65] = (0, 90, 0);
	at[65] = 28;
	points[66] = (-896.5984, 3913.3506, 1419.5787);
	angles[66] = (0, 90, 0);
	at[66] = 28.2667;
	points[67] = (-897.1378, 3913.8110, 1419.5826);
	angles[67] = (0, 90, 0);
	at[67] = 28.8000;
	points[68] = (-902.3189, 3918.2913, 1419.6104);
	angles[68] = (0, 90, 0);
	at[68] = 29.0667;
	points[69] = (-902.4094, 3918.3660, 1419.6104);
	angles[69] = (0, 90, 0);
	at[69] = 29.6000;
	points[70] = (-908.0433, 3923.2324, 1419.6417);
	angles[70] = (0, 90, 0);
	at[70] = 29.8667;
	points[71] = (-908.0433, 3923.2324, 1419.6417);
	angles[71] = (0, 90, 0);
	at[71] = 30.4000;
	points[72] = (-913.7638, 3928.1692, 1419.6732);
	angles[72] = (0, 90, 0);
	at[72] = 30.6667;
	points[73] = (-913.7638, 3928.1692, 1419.6732);
	angles[73] = (0, 90, 0);
	at[73] = 31.2000;
	points[74] = (-919.2166, 3932.8782, 1419.7007);
	angles[74] = (0, 90, 0);
	at[74] = 31.4667;
	points[75] = (-919.4843, 3933.1104, 1419.7007);
	angles[75] = (0, 90, 0);
	at[75] = 31.7333;
	points[76] = (-919.4843, 3933.1104, 1419.7007);
	angles[76] = (0, 90, 0);
	at[76] = 32;
	points[77] = (-914.5906, 3936.2717, 1419.7206);
	angles[77] = (0, 90, 0);
	at[77] = 32.2667;
	points[78] = (-913.5551, 3936.8425, 1419.7245);
	angles[78] = (0, 90, 0);
	at[78] = 32.8000;
	points[79] = (-909.1141, 3939.2913, 1419.7362);
	angles[79] = (0, 90, 0);
	at[79] = 33.0667;
	points[80] = (-906.9449, 3940.5117, 1419.7441);
	angles[80] = (0, 90, 0);
	at[80] = 33.6000;
	points[81] = (-900.3307, 3944.1733, 1419.7638);
	angles[81] = (0, 90, 0);
	at[81] = 34.1333;
	points[82] = (-898.7795, 3945.0396, 1419.7677);
	angles[82] = (0, 90, 0);
	at[82] = 34.6667;
	points[83] = (-893.7166, 3947.8347, 1419.7834);
	angles[83] = (0, 90, 0);
	at[83] = 34.9333;
	points[84] = (-893.0984, 3948.1890, 1419.7874);
	angles[84] = (0, 90, 0);
	at[84] = 35.4667;
	points[85] = (-887.1063, 3951.4958, 1419.8031);
	angles[85] = (0, 90, 0);
	at[85] = 35.7333;
	points[86] = (-887, 3951.5356, 1419.8031);
	angles[86] = (0, 90, 0);
	at[86] = 36.2667;
	points[87] = (-880.4921, 3955.1575, 1419.8505);
	angles[87] = (0, 90, 0);
	at[87] = 36.5333;
	points[88] = (-880.4921, 3955.1575, 1419.8505);
	angles[88] = (0, 90, 0);
	at[88] = 37.0667;
	points[89] = (-873.8780, 3958.8191, 1419.8976);
	angles[89] = (0, 90, 0);
	at[89] = 37.3333;
	points[90] = (-873.8780, 3958.8191, 1419.8976);
	angles[90] = (0, 90, 0);
	at[90] = 37.8667;
	points[91] = (-867.5748, 3962.3228, 1419.9410);
	angles[91] = (0, 90, 0);
	at[91] = 38.1333;
	points[92] = (-867.2638, 3962.4805, 1419.9410);
	angles[92] = (0, 90, 0);
	at[92] = 38.6667;
	points[93] = (-861.6851, 3965.5513, 1419.9843);
	angles[93] = (0, 90, 0);
	at[93] = 38.9333;
	points[94] = (-860.6536, 3966.1416, 1419.9882);
	angles[94] = (0, 90, 0);
	at[94] = 39.4667;
	points[95] = (-856.2087, 3968.5828, 1420.0198);
	angles[95] = (0, 90, 0);
	at[95] = 39.7333;
	points[96] = (-854.0394, 3969.8032, 1420.0355);
	angles[96] = (0, 90, 0);
	at[96] = 40.2667;
	points[97] = (-847.4252, 3973.4646, 1420.0826);
	angles[97] = (0, 90, 0);
	at[97] = 40.8000;
	points[98] = (-845.8780, 3974.3306, 1420.0945);
	angles[98] = (0, 90, 0);
	at[98] = 41.3333;
	points[99] = (-840.8150, 3977.1260, 1420.1300);
	angles[99] = (0, 90, 0);
	at[99] = 41.6000;
	points[100] = (-840.1929, 3977.4805, 1420.1339);
	angles[100] = (0, 90, 0);
	at[100] = 42.1333;
	points[101] = (-834.2008, 3980.7874, 1420.1771);
	angles[101] = (0, 90, 0);
	at[101] = 42.4000;
	points[102] = (-834.0984, 3980.8267, 1420.1771);
	angles[102] = (0, 90, 0);
	at[102] = 42.9333;
	points[103] = (-827.5867, 3984.4490, 1420.2244);
	angles[103] = (0, 90, 0);
	at[103] = 43.2000;
	points[104] = (-827.5867, 3984.4490, 1420.2244);
	angles[104] = (0, 90, 0);
	at[104] = 43.7333;
	points[105] = (-820.9764, 3988.1101, 1420.2717);
	angles[105] = (0, 90, 0);
	at[105] = 44;
	points[106] = (-820.9764, 3988.1101, 1420.2717);
	angles[106] = (0, 90, 0);
	at[106] = 44.5333;
	points[107] = (-814.6732, 3991.6143, 1420.3149);
	angles[107] = (0, 90, 0);
	at[107] = 44.8000;
	points[108] = (-814.3622, 3991.7717, 1420.3188);
	angles[108] = (0, 90, 0);
	at[108] = 45.3333;
	points[109] = (-808.7835, 3994.8425, 1420.3583);
	angles[109] = (0, 90, 0);
	at[109] = 45.6000;
	points[110] = (-807.7480, 3995.4331, 1420.3662);
	angles[110] = (0, 90, 0);
	at[110] = 45.8667;
	points[111] = (-802.0079, 3992.6772, 1420.3269);
	angles[111] = (0, 90, 0);
	at[111] = 46.9333;
	points[112] = (-796.6141, 3987.3623, 1420.2521);
	angles[112] = (0, 90, 0);
	at[112] = 47.4667;
	points[113] = (-795.3464, 3986.1418, 1420.2363);
	angles[113] = (0, 90, 0);
	at[113] = 48;
	points[114] = (-791.2166, 3982.0864, 1420.1812);
	angles[114] = (0, 90, 0);
	at[114] = 48.2667;
	points[115] = (-790.7126, 3981.5750, 1420.1732);
	angles[115] = (0, 90, 0);
	at[115] = 48.8000;
	points[116] = (-785.8189, 3976.7717, 1420.1063);
	angles[116] = (0, 90, 0);
	at[116] = 49.0667;
	points[117] = (-785.7363, 3976.6931, 1420.1063);
	angles[117] = (0, 90, 0);
	at[117] = 49.6000;
	points[118] = (-780.4252, 3971.4961, 1420.0316);
	angles[118] = (0, 90, 0);
	at[118] = 49.8667;
	points[119] = (-780.4252, 3971.4961, 1420.0316);
	angles[119] = (0, 90, 0);
	at[119] = 50.4000;
	points[120] = (-775.0275, 3966.1812, 1419.9607);
	angles[120] = (0, 90, 0);
	at[120] = 50.6667;
	points[121] = (-775.0275, 3966.1812, 1419.9607);
	angles[121] = (0, 90, 0);
	at[121] = 51.2000;
	points[122] = (-769.8858, 3961.1418, 1419.8898);
	angles[122] = (0, 90, 0);
	at[122] = 51.4667;
	points[123] = (-769.6339, 3960.9058, 1419.8859);
	angles[123] = (0, 90, 0);
	at[123] = 52;
	points[124] = (-765.0788, 3956.4568, 1419.8229);
	angles[124] = (0, 90, 0);
	at[124] = 52.2667;
	points[125] = (-764.2362, 3955.6299, 1419.8112);
	angles[125] = (0, 90, 0);
	at[125] = 52.8000;
	points[126] = (-760.6102, 3952.0474, 1419.7834);
	angles[126] = (0, 90, 0);
	at[126] = 53.0667;
	points[127] = (-758.8425, 3950.3149, 1419.7716);
	angles[127] = (0, 90, 0);
	at[127] = 53.6000;
	points[128] = (-753.4449, 3945.0396, 1419.7402);
	angles[128] = (0, 90, 0);
	at[128] = 54.1333;
	points[129] = (-752.1811, 3943.7795, 1419.7323);
	angles[129] = (0, 90, 0);
	at[129] = 54.6667;
	points[130] = (-748.0473, 3939.7244, 1419.7048);
	angles[130] = (0, 90, 0);
	at[130] = 54.9333;
	points[131] = (-747.5433, 3939.2520, 1419.7048);
	angles[131] = (0, 90, 0);
	at[131] = 55.4667;
	points[132] = (-742.6535, 3934.4409, 1419.6732);
	angles[132] = (0, 90, 0);
	at[132] = 55.7333;
	points[133] = (-742.5670, 3934.3545, 1419.6732);
	angles[133] = (0, 90, 0);
	at[133] = 56.2667;
	points[134] = (-737.2559, 3929.1458, 1419.6417);
	angles[134] = (0, 90, 0);
	at[134] = 56.5333;
	points[135] = (-737.2559, 3929.1458, 1419.6417);
	angles[135] = (0, 90, 0);
	at[135] = 57.0667;
	points[136] = (-731.8622, 3923.8506, 1419.6063);
	angles[136] = (0, 90, 0);
	at[136] = 57.3333;
	points[137] = (-731.8622, 3923.8506, 1419.6063);
	angles[137] = (0, 90, 0);
	at[137] = 57.8667;
	points[138] = (-726.7165, 3918.8071, 1419.5787);
	angles[138] = (0, 90, 0);
	at[138] = 58.1333;
	points[139] = (-726.4646, 3918.5593, 1419.5748);
	angles[139] = (0, 90, 0);
	at[139] = 58.6667;
	points[140] = (-721.9134, 3914.0906, 1419.5472);
	angles[140] = (0, 90, 0);
	at[140] = 58.9333;
	points[141] = (-721.0709, 3913.2637, 1419.5433);
	angles[141] = (0, 90, 0);
	at[141] = 59.4667;
	points[142] = (-717.4449, 3909.7087, 1419.5198);
	angles[142] = (0, 90, 0);
	at[142] = 59.7333;
	points[143] = (-715.6733, 3907.9724, 1419.5118);
	angles[143] = (0, 90, 0);
	at[143] = 60.2667;
	points[144] = (-710.2795, 3902.6772, 1419.4763);
	angles[144] = (0, 90, 0);
	at[144] = 60.8000;
	points[145] = (-708.2638, 3900.1458, 1419.4606);
	angles[145] = (0, 90, 0);
	at[145] = 61.8667;
	points[146] = (-713.1890, 3894.4133, 1419.4292);
	angles[146] = (0, 90, 0);
	at[146] = 62.4000;
	mover = getEnt("iz_obj_3", "targetname");
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
