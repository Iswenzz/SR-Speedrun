main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_dino_jungle", 0);

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
	ambientPlay("iz_0_69", 2);
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
	level.iz_route[level.iz_route.size] = (-5691, -3168, 3687);
	level.iz_route[level.iz_route.size] = (-5772, -4587, 3687);
	level.iz_route[level.iz_route.size] = (-5812, -5662, 3687);
	level.iz_route[level.iz_route.size] = (-5854, -6599, 3687);
	level.iz_route[level.iz_route.size] = (-5608, -7321, 3687);
	level.iz_route[level.iz_route.size] = (-5270, -7966, 3687);
	level.iz_route[level.iz_route.size] = (-4705, -8301, 3686);
	level.iz_route[level.iz_route.size] = (-3986, -8552, 3687);
	level.iz_route[level.iz_route.size] = (-3098, -8235, 3687);
	level.iz_route[level.iz_route.size] = (-2647, -7456, 3687);
	level.iz_route[level.iz_route.size] = (-2855, -6770, 3687);
	level.iz_route[level.iz_route.size] = (-3423, -6133, 3687);
	level.iz_route[level.iz_route.size] = (-3706, -5589, 3687);
	level.iz_route[level.iz_route.size] = (-3650, -4734, 3687);
	level.iz_route[level.iz_route.size] = (-3235, -3905, 3687);
	level.iz_route[level.iz_route.size] = (-2486, -2950, 3681);
	level.iz_route[level.iz_route.size] = (-1646, -2051, 3621);
	level.iz_route[level.iz_route.size] = (-131, -1367, 3561);
	level.iz_route[level.iz_route.size] = (737, -636, 3561);
	level.iz_route[level.iz_route.size] = (1050, 300, 3561);
	level.iz_route[level.iz_route.size] = (1638, 1334, 3562);
	level.iz_route[level.iz_route.size] = (2521, 1792, 3544);
	level.iz_route[level.iz_route.size] = (2993, 2276, 3544);
	level.iz_route[level.iz_route.size] = (3554, 2645, 3548);
	level.iz_route[level.iz_route.size] = (4335, 2524, 3556);
	level.iz_route[level.iz_route.size] = (5067, 2337, 3563);
	level.iz_route[level.iz_route.size] = (5674, 2816, 3569);
	level.iz_route[level.iz_route.size] = (6000, 3413, 3581);
	level.iz_route[level.iz_route.size] = (6417, 4182, 3629);
	level.iz_route[level.iz_route.size] = (7046, 5137, 3763);
	level.iz_route[level.iz_route.size] = (8103, 5756, 3995);
	level.iz_route[level.iz_route.size] = (8978, 5139, 4023);
	level.iz_route[level.iz_route.size] = (9888, 4724, 4164);
	level.iz_route[level.iz_route.size] = (10593, 3895, 4359);
	level.iz_route[level.iz_route.size] = (10960, 2646, 4614);
	level.iz_route[level.iz_route.size] = (11274, 1018, 4878);
	level.iz_route[level.iz_route.size] = (11548, -433, 5096);
	level.iz_route[level.iz_route.size] = (11901, -1531, 5255);
	level.iz_route[level.iz_route.size] = (12058, -2492, 5280);
	level.iz_route[level.iz_route.size] = (12117, -3276, 5280);
	level.iz_route[level.iz_route.size] = (12235, -4174, 5280);
	level.iz_route[level.iz_route.size] = (12892, -4900, 5280);
	level.iz_route[level.iz_route.size] = (12929, -5979, 5280);
	level.iz_route[level.iz_route.size] = (12376, -6640, 5280);
	level.iz_route[level.iz_route.size] = (11501, -7301, 5280);
	level.iz_route[level.iz_route.size] = (10671, -8215, 5316);
	level.iz_route[level.iz_route.size] = (10041, -8964, 5385);
	level.iz_route[level.iz_route.size] = (9312, -9651, 5429);
	level.iz_route[level.iz_route.size] = (8641, -10239, 5464);
	level.iz_route[level.iz_route.size] = (7625, -10516, 5515);
	level.iz_route[level.iz_route.size] = (6612, -10454, 5529);
	level.iz_route[level.iz_route.size] = (5687, -10117, 5498);
	level.iz_route[level.iz_route.size] = (4849, -9457, 5432);
	level.iz_route[level.iz_route.size] = (4082, -8382, 5372);
	level.iz_route[level.iz_route.size] = (3527, -7238, 5320);
	level.iz_route[level.iz_route.size] = (2960, -6242, 5283);
	level.iz_route[level.iz_route.size] = (2148, -4891, 5355);
	level.iz_route[level.iz_route.size] = (1331, -4041, 4961);
	level.iz_route[level.iz_route.size] = (311, -2708, 4993);
	level.iz_route[level.iz_route.size] = (-474, -1466, 4922);
	level.iz_route[level.iz_route.size] = (-1271, -119, 4871);
	level.iz_route[level.iz_route.size] = (-2454, 1901, 4821);
	level.iz_route[level.iz_route.size] = (-3082, 3078, 4718);
	level.iz_route[level.iz_route.size] = (-3415, 4157, 4781);
	level.iz_route[level.iz_route.size] = (-3305, 4954, 4784);
	level.iz_route[level.iz_route.size] = (-3396, 5790, 4853);
	level.iz_route[level.iz_route.size] = (-3991, 6374, 4928);
	level.iz_route[level.iz_route.size] = (-4992, 6347, 4907);
	level.iz_route[level.iz_route.size] = (-5711, 5633, 4725);
	level.iz_route[level.iz_route.size] = (-5852, 4657, 4564);
	level.iz_route[level.iz_route.size] = (-5943, 3084, 4178);
	level.iz_route[level.iz_route.size] = (-6143, 1173, 3748);
	level.iz_route[level.iz_route.size] = (-5782, -550, 3709);
	level.iz_route[level.iz_route.size] = (-5705, -1894, 3689);
	level.iz_route[level.iz_route.size] = (-5687, -2804, 3689);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (7859.0947, 9065.8271, 2732.7363);
	angles[0] = (0, 30.2313, 0);
	at[0] = 0;
	points[1] = (7888.4253, 9083.3076, 2734.9292);
	angles[1] = (0, 18.1870, 0);
	at[1] = 0.0667;
	points[2] = (7937.7954, 9119.7246, 2737.3228);
	angles[2] = (0, -2.9359, 0);
	at[2] = 0.2000;
	points[3] = (7987.2046, 9156.1416, 2739.7126);
	angles[3] = (0, -18.9557, 0);
	at[3] = 0.3333;
	points[4] = (8061.2993, 9210.7871, 2743.3032);
	angles[4] = (0, -34.5261, 0);
	at[4] = 0.5333;
	points[5] = (8160.0791, 9283.6611, 2748.0906);
	angles[5] = (0, -45.1394, 0);
	at[5] = 0.8000;
	points[6] = (8407.0078, 9465.7871, 2760.0513);
	angles[6] = (0, -52.5025, 0);
	at[6] = 1.4667;
	points[7] = (9024.4092, 9921.1025, 2789.9607);
	angles[7] = (0, -53.5851, 0);
	at[7] = 3.1333;
	points[8] = (9051.4180, 9923.8975, 2792.4448);
	angles[8] = (0, -60.5281, 0);
	at[8] = 3.2000;
	points[9] = (9109.1738, 9904.2520, 2799.5315);
	angles[9] = (0, -75.7123, 0);
	at[9] = 3.3333;
	points[10] = (9166.8896, 9884.5664, 2806.6182);
	angles[10] = (0, -86.5049, 0);
	at[10] = 3.4667;
	points[11] = (9253.5430, 9855.0791, 2817.2480);
	angles[11] = (0, -96.6420, 0);
	at[11] = 3.6667;
	points[12] = (9369.0557, 9815.7480, 2831.4172);
	angles[12] = (0, -103.4329, 0);
	at[12] = 3.9333;
	points[13] = (9657.7949, 9717.4414, 2866.8464);
	angles[13] = (0, -108.1124, 0);
	at[13] = 4.6000;
	points[14] = (10552.9531, 9412.6377, 2976.6809);
	angles[14] = (0, -108.8020, 0);
	at[14] = 6.6667;
	points[15] = (10569.6055, 9397.9922, 2980.0396);
	angles[15] = (0, -114.8272, 0);
	at[15] = 6.7333;
	points[16] = (10526.1807, 9317.2051, 2988.7048);
	angles[16] = (0, -149.3728, 0);
	at[16] = 6.9333;
	points[17] = (10497.2441, 9263.3467, 2994.4841);
	angles[17] = (0, -167.4712, 0);
	at[17] = 7.0667;
	points[18] = (10453.8193, 9182.5596, 3003.1497);
	angles[18] = (0, -185.6799, 0);
	at[18] = 7.2667;
	points[19] = (10410.3945, 9101.7715, 3011.8149);
	angles[19] = (0, -195.9819, 0);
	at[19] = 7.4667;
	points[20] = (10352.4805, 8994.0557, 3023.3701);
	angles[20] = (0, -202.8473, 0);
	at[20] = 7.7333;
	points[21] = (10280.1182, 8859.4102, 3037.8149);
	angles[21] = (0, -206.3180, 0);
	at[21] = 8.0667;
	points[22] = (9976.1816, 8293.8975, 3098.4805);
	angles[22] = (0, -208.2309, 0);
	at[22] = 9.4667;
	points[23] = (9956.6924, 8272.9922, 3100.3938);
	angles[23] = (0, -212.2553, 0);
	at[23] = 9.5333;
	points[24] = (9897.9922, 8254.9219, 3100.3938);
	angles[24] = (0, -225.3624, 0);
	at[24] = 9.6667;
	points[25] = (9809.9609, 8227.7949, 3100.3938);
	angles[25] = (0, -237.8288, 0);
	at[25] = 9.8667;
	points[26] = (9633.8584, 8173.5039, 3100.3938);
	angles[26] = (0, -248.4598, 0);
	at[26] = 10.2667;
	points[27] = (9369.7246, 8092.1260, 3100.3938);
	angles[27] = (0, -252.1761, 0);
	at[27] = 10.8667;
	points[28] = (8665.4336, 7875.0786, 3100.3938);
	angles[28] = (0, -252.8675, 0);
	at[28] = 12.4667;
	points[29] = (8640.3936, 7877.3228, 3097.8506);
	angles[29] = (0, -258.3474, 0);
	at[29] = 12.5333;
	points[30] = (8591.3779, 7951.8896, 3074.9409);
	angles[30] = (0, -286.0217, 0);
	at[30] = 12.7333;
	points[31] = (8558.7012, 8001.6143, 3059.6731);
	angles[31] = (0, -298.9197, 0);
	at[31] = 12.8667;
	points[32] = (8509.6846, 8076.1812, 3036.7678);
	angles[32] = (0, -311.3940, 0);
	at[32] = 13.0667;
	points[33] = (8460.6689, 8150.7485, 3013.8584);
	angles[33] = (0, -318.3636, 0);
	at[33] = 13.2667;
	points[34] = (8329.9609, 8349.5664, 2952.7759);
	angles[34] = (0, -325.0618, 0);
	at[34] = 13.8000;
	points[35] = (7872.4414, 9045.5117, 2738.9841);
	angles[35] = (0, -326.6738, 0);
	at[35] = 15.6667;
	points[36] = (7859.0947, 9065.8271, 2732.7363);
	angles[36] = (0, -329.7687, 0);
	at[36] = 15.7167;
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
	points[0] = (14434.1348, 2835.5984, 5118.6616);
	angles[0] = (0, -162.3896, 0);
	at[0] = 0;
	points[1] = (14419.2920, 2707.2009, 5115.6694);
	angles[1] = (0, -180.3457, 0);
	at[1] = 0.2333;
	points[2] = (14407.0078, 2579.6418, 5115.1968);
	angles[2] = (0, -184.3183, 0);
	at[2] = 0.4667;
	points[3] = (14137.0469, -226.6618, 5104.5674);
	angles[3] = (0, -185.4949, 0);
	at[3] = 5.6000;
	points[4] = (14045.6699, -298.2130, 5141.2993);
	angles[4] = (0, -223.3862, 0);
	at[4] = 5.8333;
	points[5] = (13942.5586, -361.4551, 5183.5825);
	angles[5] = (0, -234.9506, 0);
	at[5] = 6.0667;
	points[6] = (13839.4092, -424.6969, 5225.8662);
	angles[6] = (0, -237.6708, 0);
	at[6] = 6.3000;
	points[7] = (11983.1104, -1563.0472, 5986.8110);
	angles[7] = (0, -238.4822, 0);
	at[7] = 10.5000;
	points[8] = (11887.4414, -1514.5513, 5965.5122);
	angles[8] = (0, -286.5922, 0);
	at[8] = 10.7333;
	points[9] = (11793.7803, -1435.9843, 5927.0869);
	angles[9] = (0, -304.3726, 0);
	at[9] = 10.9667;
	points[10] = (11700.1191, -1357.4133, 5888.6616);
	angles[10] = (0, -308.6920, 0);
	at[10] = 11.2000;
	points[11] = (10107.8350, -21.7730, 5235.3545);
	angles[11] = (0, -309.9909, 0);
	at[11] = 15.1667;
	points[12] = (10042.8350, 62.8260, 5188.5435);
	angles[12] = (0, -327.5098, 0);
	at[12] = 15.4000;
	points[13] = (10065.8271, 165.9362, 5116.0239);
	angles[13] = (0, -361.2721, 0);
	at[13] = 15.6333;
	points[14] = (10088.8584, 269.0464, 5043.4648);
	angles[14] = (0, -369.9738, 0);
	at[14] = 15.8667;
	points[15] = (10134.8418, 475.2677, 4898.3857);
	angles[15] = (0, -372.4384, 0);
	at[15] = 16.3333;
	points[16] = (10433.8584, 1815.7008, 3955.4331);
	angles[16] = (0, -372.5745, 0);
	at[16] = 19.3667;
	points[17] = (10485.1973, 1873.5828, 3934.7834);
	angles[17] = (0, -400.7397, 0);
	at[17] = 19.6000;
	points[18] = (10587.7168, 1849.7875, 4007.8743);
	angles[18] = (0, -443.7474, 0);
	at[18] = 19.8333;
	points[19] = (10690.2754, 1825.9883, 4080.9448);
	angles[19] = (0, -458.2064, 0);
	at[19] = 20.0667;
	points[20] = (10792.7949, 1802.1929, 4154.0552);
	angles[20] = (0, -461.9296, 0);
	at[20] = 20.3000;
	points[21] = (12433.3867, 1421.4567, 5323.5039);
	angles[21] = (0, -463.0656, 0);
	at[21] = 24.0333;
	points[22] = (12540.5117, 1369.0511, 5338.5435);
	angles[22] = (0, -475.2445, 0);
	at[22] = 24.2667;
	points[23] = (12759.0947, 1237.4016, 5314.2129);
	angles[23] = (0, -480.7567, 0);
	at[23] = 24.7333;
	points[24] = (14288.9365, 315.8622, 5143.8975);
	angles[24] = (0, -481.0632, 0);
	at[24] = 28;
	points[25] = (14398.2285, 250.0378, 5131.7319);
	angles[25] = (0, -484.3951, 0);
	at[25] = 28.2333;
	points[26] = (14272.8740, 254.5370, 5163.3071);
	angles[26] = (0, -560.3680, 0);
	at[26] = 28.4667;
	points[27] = (14148.7012, 258.6831, 5194.6455);
	angles[27] = (0, -614.2165, 0);
	at[27] = 28.7000;
	points[28] = (14024.4873, 262.8287, 5225.9844);
	angles[28] = (0, -627.8947, 0);
	at[28] = 28.9333;
	points[29] = (13776.1416, 271.1208, 5288.7007);
	angles[29] = (0, -631.7026, 0);
	at[29] = 29.4000;
	points[30] = (11913.3467, 333.3094, 5759.0161);
	angles[30] = (0, -631.9121, 0);
	at[30] = 32.9000;
	points[31] = (11795.6689, 361.7496, 5738.3862);
	angles[31] = (0, -642.3126, 0);
	at[31] = 33.1333;
	points[32] = (11565.4727, 438.0905, 5655.4331);
	angles[32] = (0, -648.0143, 0);
	at[32] = 33.6000;
	points[33] = (9263.6221, 1201.4961, 4826.2207);
	angles[33] = (0, -648.3480, 0);
	at[33] = 38.2667;
	points[34] = (9200.0791, 1251.4095, 4778.1104);
	angles[34] = (0, -671.9641, 0);
	at[34] = 38.5000;
	points[35] = (9274.1338, 1332.6732, 4712.2837);
	angles[35] = (0, -740.7344, 0);
	at[35] = 38.7333;
	points[36] = (9348.1895, 1413.9410, 4646.4565);
	angles[36] = (0, -757.7133, 0);
	at[36] = 38.9667;
	points[37] = (9496.2988, 1576.4686, 4514.7642);
	angles[37] = (0, -762.1055, 0);
	at[37] = 39.4333;
	points[38] = (10755.2373, 2957.9685, 3395.5984);
	angles[38] = (0, -763.6584, 0);
	at[38] = 43.4000;
	points[39] = (10857.5977, 3031.5786, 3422.3623);
	angles[39] = (0, -771.7155, 0);
	at[39] = 43.6333;
	points[40] = (11061.2197, 3179.1140, 3472.0945);
	angles[40] = (0, -773.9443, 0);
	at[40] = 44.1000;
	points[41] = (13606.1025, 5023.3071, 4093.7402);
	angles[41] = (0, -774.0703, 0);
	at[41] = 49.9333;
	points[42] = (13655.0400, 4937.6377, 4141.4565);
	angles[42] = (0, -844.2349, 0);
	at[42] = 50.1667;
	points[43] = (13695.8662, 4827.4800, 4192.6772);
	angles[43] = (0, -871.6989, 0);
	at[43] = 50.4000;
	points[44] = (13736.6924, 4717.3228, 4243.8584);
	angles[44] = (0, -877.8613, 0);
	at[44] = 50.6333;
	points[45] = (14430.7090, 2844.7520, 5114.4097);
	angles[45] = (0, -879.6633, 0);
	at[45] = 54.6000;
	points[46] = (14434.1348, 2835.5984, 5118.6616);
	angles[46] = (0, -882.3896, 0);
	at[46] = 54.6167;
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
	points[0] = (-2564.6733, -7884.1733, 4598.5039);
	angles[0] = (0, -173.6307, 0);
	at[0] = 0;
	points[1] = (-2688.6731, -7940.4331, 4616.1416);
	angles[1] = (0, -229.0278, 0);
	at[1] = 0.2500;
	points[2] = (-2812.6694, -7996.6929, 4633.7793);
	angles[2] = (0, -242.1738, 0);
	at[2] = 0.5000;
	points[3] = (-3060.6692, -8109.2129, 4669.0947);
	angles[3] = (0, -245.4504, 0);
	at[3] = 1;
	points[4] = (-4548.6221, -8784.3311, 4880.8267);
	angles[4] = (0, -245.5954, 0);
	at[4] = 4;
	points[5] = (-4650.0786, -8757.2051, 4873.7402);
	angles[5] = (0, -285.1430, 0);
	at[5] = 4.2500;
	points[6] = (-4729.7637, -8649.8037, 4842.7559);
	angles[6] = (0, -315.1258, 0);
	at[6] = 4.5000;
	points[7] = (-4809.4883, -8542.3623, 4811.7720);
	angles[7] = (0, -321.7099, 0);
	at[7] = 4.7500;
	points[8] = (-5925.2363, -7038.3467, 4378.1499);
	angles[8] = (0, -323.4301, 0);
	at[8] = 8.2500;
	points[9] = (-5990.0786, -6926.4570, 4356.7324);
	angles[9] = (0, -333.9901, 0);
	at[9] = 8.5000;
	points[10] = (-5980, -6792.1650, 4383.5435);
	angles[10] = (0, -357.7733, 0);
	at[10] = 8.7500;
	points[11] = (-5969.9214, -6657.8740, 4410.3149);
	angles[11] = (0, -362.9321, 0);
	at[11] = 9;
	points[12] = (-5959.8818, -6523.5830, 4437.1260);
	angles[12] = (0, -364.0072, 0);
	at[12] = 9.2500;
	points[13] = (-5607.5596, -1823.5354, 5374.7246);
	angles[13] = (0, -364.2867, 0);
	at[13] = 18;
	points[14] = (-5617.7168, -1697.9174, 5333.3071);
	angles[14] = (0, -356.2327, 0);
	at[14] = 18.2500;
	points[15] = (-5647.8740, -1450.9094, 5217.1655);
	angles[15] = (0, -353.1846, 0);
	at[15] = 18.7500;
	points[16] = (-5904.1733, 648.6417, 4230.0396);
	angles[16] = (0, -353.0402, 0);
	at[16] = 23;
	points[17] = (-5854.8032, 747.1417, 4272.4409);
	angles[17] = (0, -382.3000, 0);
	at[17] = 23.2500;
	points[18] = (-5784.1733, 837.3779, 4348.0708);
	angles[18] = (0, -394.3640, 0);
	at[18] = 23.5000;
	points[19] = (-5642.8740, 1017.8504, 4499.2915);
	angles[19] = (0, -397.8955, 0);
	at[19] = 24;
	points[20] = (-3947.3230, 3183.5156, 6314.2124);
	angles[20] = (0, -398.0581, 0);
	at[20] = 30;
	points[21] = (-3862.5198, 3172.4333, 6298.4648);
	angles[21] = (0, -447.4984, 0);
	at[21] = 30.2500;
	points[22] = (-3769.2126, 3100.5510, 6227.9131);
	angles[22] = (0, -477.6648, 0);
	at[22] = 30.5000;
	points[23] = (-3675.9016, 3028.6694, 6157.3228);
	angles[23] = (0, -485.4717, 0);
	at[23] = 30.7500;
	points[24] = (-2276.2756, 1950.4449, 5098.9370);
	angles[24] = (0, -487.6094, 0);
	at[24] = 34.5000;
	points[25] = (-2268.3977, 1828.3818, 5134.2520);
	angles[25] = (0, -527.6938, 0);
	at[25] = 34.7500;
	points[26] = (-2271.2520, 1700.0157, 5182.9131);
	angles[26] = (0, -538.3113, 0);
	at[26] = 35;
	points[27] = (-2274.1062, 1571.6495, 5231.5352);
	angles[27] = (0, -540.6553, 0);
	at[27] = 35.2500;
	points[28] = (-2359.7205, -2279.3110, 6690.8271);
	angles[28] = (0, -541.2736, 0);
	at[28] = 42.7500;
	points[29] = (-2416.9016, -2368.0237, 6611.4170);
	angles[29] = (0, -565.5148, 0);
	at[29] = 43;
	points[30] = (-2477.7441, -2454.0630, 6523.3857);
	angles[30] = (0, -572.9822, 0);
	at[30] = 43.2500;
	points[31] = (-2538.5867, -2540.1062, 6435.3936);
	angles[31] = (0, -574.7806, 0);
	at[31] = 43.5000;
	points[32] = (-3998.7795, -4605.1182, 4322.9136);
	angles[32] = (0, -575.2648, 0);
	at[32] = 49.5000;
	points[33] = (-4023.9370, -4702.5591, 4265.2754);
	angles[33] = (0, -548.8904, 0);
	at[33] = 49.7500;
	points[34] = (-3966.2205, -4826.4570, 4278.1890);
	angles[34] = (0, -521.8821, 0);
	at[34] = 50;
	points[35] = (-3908.5156, -4950.3545, 4291.1025);
	angles[35] = (0, -516.4466, 0);
	at[35] = 50.2500;
	points[36] = (-2581.1062, -7800.3940, 4587.9922);
	angles[36] = (0, -515.0261, 0);
	at[36] = 56;
	points[37] = (-2564.6733, -7884.1733, 4598.5039);
	angles[37] = (0, -533.6307, 0);
	at[37] = 56.2000;
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
	points[0] = (18809.9219, 3098.9136, 3100.4253);
	angles[0] = (0, -174.5457, 0);
	at[0] = 0;
	points[1] = (18810.1582, 3036.6101, 3101.0750);
	angles[1] = (0, -175.9803, 0);
	at[1] = 0.1000;
	points[2] = (18808.2285, 2965.0315, 3101.6340);
	angles[2] = (0, -177.4965, 0);
	at[2] = 0.2000;
	points[3] = (18804.2520, 2886.3071, 3102.1064);
	angles[3] = (0, -178.9570, 0);
	at[3] = 0.3000;
	points[4] = (18799.8828, 2821.2166, 3102.4094);
	angles[4] = (0, -180.2637, 0);
	at[4] = 0.4000;
	points[5] = (18794.4492, 2752.0396, 3102.6733);
	angles[5] = (0, -181.4014, 0);
	at[5] = 0.5000;
	points[6] = (18780.5508, 2603.7283, 3103.0789);
	angles[6] = (0, -183.2587, 0);
	at[6] = 0.7000;
	points[7] = (18773.4648, 2536.7244, 3103.2048);
	angles[7] = (0, -184.0074, 0);
	at[7] = 0.8000;
	points[8] = (18757.2832, 2396.6694, 3103.3818);
	angles[8] = (0, -185.2243, 0);
	at[8] = 1;
	points[9] = (18738.8965, 2252.3149, 3103.4685);
	angles[9] = (0, -186.1824, 0);
	at[9] = 1.2000;
	points[10] = (18719.8809, 2113.9055, 3103.4802);
	angles[10] = (0, -186.9593, 0);
	at[10] = 1.4000;
	points[11] = (18688.1484, 1900.8779, 3103.3857);
	angles[11] = (0, -187.9221, 0);
	at[11] = 1.7000;
	points[12] = (18642.0879, 1621.2284, 3103.1104);
	angles[12] = (0, -189.0202, 0);
	at[12] = 2.1000;
	points[13] = (18603.9375, 1410.2480, 3102.8071);
	angles[13] = (0, -189.8099, 0);
	at[13] = 2.4000;
	points[14] = (18563.1895, 1202.5433, 3102.4490);
	angles[14] = (0, -190.6392, 0);
	at[14] = 2.7000;
	points[15] = (18517.9531, 991.1141, 3102.0396);
	angles[15] = (0, -191.5788, 0);
	at[15] = 3;
	points[16] = (18486.5371, 855.9961, 3101.7598);
	angles[16] = (0, -192.3099, 0);
	at[16] = 3.2000;
	points[17] = (18432.3633, 645.1378, 3101.2993);
	angles[17] = (0, -193.7015, 0);
	at[17] = 3.5000;
	points[18] = (18393.6230, 512.4567, 3101.0081);
	angles[18] = (0, -194.9480, 0);
	at[18] = 3.7000;
	points[19] = (18370.2363, 439.8346, 3100.8503);
	angles[19] = (0, -195.7631, 0);
	at[19] = 3.8000;
	points[20] = (18346.8105, 373.3055, 3100.7126);
	angles[20] = (0, -196.7728, 0);
	at[20] = 3.9000;
	points[21] = (18323.5039, 313.3429, 3100.5945);
	angles[21] = (0, -198.0275, 0);
	at[21] = 4;
	points[22] = (18290.8672, 240.9406, 3100.4724);
	angles[22] = (0, -199.7938, 0);
	at[22] = 4.1000;
	points[23] = (18257.2832, 181.7012, 3100.4016);
	angles[23] = (0, -202.6039, 0);
	at[23] = 4.2000;
	points[24] = (18219.4883, 135.1405, 3100.4055);
	angles[24] = (0, -207.2084, 0);
	at[24] = 4.3000;
	points[25] = (18165.1191, 89.4516, 3100.4802);
	angles[25] = (0, -213.3574, 0);
	at[25] = 4.4000;
	points[26] = (18104.2129, 50.3496, 3100.5986);
	angles[26] = (0, -219.7811, 0);
	at[26] = 4.5000;
	points[27] = (18043.4258, 18.0988, 3100.7322);
	angles[27] = (0, -225.6907, 0);
	at[27] = 4.6000;
	points[28] = (17975.5898, -12.8181, 3100.8938);
	angles[28] = (0, -230.9551, 0);
	at[28] = 4.7000;
	points[29] = (17911.0645, -38.7112, 3101.0474);
	angles[29] = (0, -235.5376, 0);
	at[29] = 4.8000;
	points[30] = (17775.7871, -84.9858, 3101.3779);
	angles[30] = (0, -242.7988, 0);
	at[30] = 5;
	points[31] = (17639.9219, -123.5035, 3101.6968);
	angles[31] = (0, -248.1307, 0);
	at[31] = 5.2000;
	points[32] = (17499.8027, -156.8315, 3102.0078);
	angles[32] = (0, -252.1196, 0);
	at[32] = 5.4000;
	points[33] = (17291.1816, -196.5516, 3102.4094);
	angles[33] = (0, -256.5770, 0);
	at[33] = 5.7000;
	points[34] = (17079.2129, -225.9374, 3102.7166);
	angles[34] = (0, -260.0911, 0);
	at[34] = 6;
	points[35] = (16937.7559, -239.3197, 3102.8428);
	angles[35] = (0, -262.2459, 0);
	at[35] = 6.2000;
	points[36] = (16865.7090, -244.0476, 3102.8782);
	angles[36] = (0, -263.3394, 0);
	at[36] = 6.3000;
	points[37] = (16726.2207, -248.6063, 3102.8582);
	angles[37] = (0, -265.6550, 0);
	at[37] = 6.5000;
	points[38] = (16651.8516, -248.1288, 3102.7952);
	angles[38] = (0, -266.9548, 0);
	at[38] = 6.6000;
	points[39] = (16581.2207, -245.3665, 3102.6890);
	angles[39] = (0, -268.4138, 0);
	at[39] = 6.7000;
	points[40] = (16513.8184, -240.1508, 3102.5315);
	angles[40] = (0, -270.0724, 0);
	at[40] = 6.8000;
	points[41] = (16438.3867, -230.4110, 3102.2678);
	angles[41] = (0, -272.1107, 0);
	at[41] = 6.9000;
	points[42] = (16371.2598, -216.8272, 3101.9172);
	angles[42] = (0, -274.7217, 0);
	at[42] = 7;
	points[43] = (16301.3779, -194.6043, 3101.3660);
	angles[43] = (0, -278.3165, 0);
	at[43] = 7.1000;
	points[44] = (16241.8506, -162.0669, 3100.5593);
	angles[44] = (0, -284.1132, 0);
	at[44] = 7.2000;
	points[45] = (16200.0791, -118.8354, 3099.5198);
	angles[45] = (0, -292.6385, 0);
	at[45] = 7.3000;
	points[46] = (16158.5039, -53.3587, 3098.0195);
	angles[46] = (0, -301.7227, 0);
	at[46] = 7.4000;
	points[47] = (16128.4648, 6.1435, 3096.6812);
	angles[47] = (0, -309.9271, 0);
	at[47] = 7.5000;
	points[48] = (16100.2754, 70.3512, 3095.2520);
	angles[48] = (0, -316.8310, 0);
	at[48] = 7.6000;
	points[49] = (16072.0078, 142.3252, 3093.6616);
	angles[49] = (0, -322.5534, 0);
	at[49] = 7.7000;
	points[50] = (16027.0078, 271.3205, 3090.8308);
	angles[50] = (0, -330.9630, 0);
	at[50] = 7.9000;
	points[51] = (15983.3076, 412.1890, 3087.7598);
	angles[51] = (0, -336.4456, 0);
	at[51] = 8.1000;
	points[52] = (15945.7480, 545.0236, 3084.8740);
	angles[52] = (0, -340.0547, 0);
	at[52] = 8.3000;
	points[53] = (15908.8975, 685.2756, 3081.8308);
	angles[53] = (0, -342.4977, 0);
	at[53] = 8.5000;
	points[54] = (15859.0156, 890.8701, 3077.3860);
	angles[54] = (0, -344.8974, 0);
	at[54] = 8.8000;
	points[55] = (15797.5586, 1169.6023, 3071.3701);
	angles[55] = (0, -346.8920, 0);
	at[55] = 9.2000;
	points[56] = (15741.8115, 1449.1221, 3065.3428);
	angles[56] = (0, -348.2825, 0);
	at[56] = 9.6000;
	points[57] = (15691.6533, 1728.4371, 3059.3230);
	angles[57] = (0, -349.4618, 0);
	at[57] = 10;
	points[58] = (15668.3467, 1870.5513, 3056.2598);
	angles[58] = (0, -350.0547, 0);
	at[58] = 10.2000;
	points[59] = (15647.4014, 2008.6969, 3053.2756);
	angles[59] = (0, -350.6864, 0);
	at[59] = 10.4000;
	points[60] = (15636.9297, 2082.7559, 3051.6772);
	angles[60] = (0, -351.0414, 0);
	at[60] = 10.5000;
	points[61] = (15627.6768, 2152.7678, 3050.1614);
	angles[61] = (0, -351.4354, 0);
	at[61] = 10.6000;
	points[62] = (15619.6846, 2218.3386, 3048.7402);
	angles[62] = (0, -351.8763, 0);
	at[62] = 10.7000;
	points[63] = (15611.3398, 2294.8542, 3047.0747);
	angles[63] = (0, -352.4058, 0);
	at[63] = 10.8000;
	points[64] = (15604.9609, 2365.9211, 3045.5276);
	angles[64] = (0, -353.0998, 0);
	at[64] = 10.9000;
	points[65] = (15601.1025, 2427.0156, 3044.1853);
	angles[65] = (0, -354.0312, 0);
	at[65] = 11;
	points[66] = (15599.1338, 2492.0159, 3042.7168);
	angles[66] = (0, -355.1972, 0);
	at[66] = 11.1000;
	points[67] = (15599.7246, 2637.7798, 3039.3032);
	angles[67] = (0, -357.6014, 0);
	at[67] = 11.3000;
	points[68] = (15601.5352, 2706.2244, 3037.6692);
	angles[68] = (0, -358.6570, 0);
	at[68] = 11.4000;
	points[69] = (15607.7168, 2852.5159, 3034.1379);
	angles[69] = (0, -360.4346, 0);
	at[69] = 11.6000;
	points[70] = (15615.9443, 2991.1577, 3030.7678);
	angles[70] = (0, -361.8224, 0);
	at[70] = 11.8000;
	points[71] = (15626.4561, 3135.4841, 3027.2520);
	angles[71] = (0, -362.9359, 0);
	at[71] = 12;
	points[72] = (15645.1572, 3346.7166, 3022.1143);
	angles[72] = (0, -364.2778, 0);
	at[72] = 12.3000;
	points[73] = (15676.1025, 3629.4685, 3015.2954);
	angles[73] = (0, -365.7874, 0);
	at[73] = 12.7000;
	points[74] = (15714.2520, 3911.8188, 3008.6143);
	angles[74] = (0, -367.2745, 0);
	at[74] = 13.1000;
	points[75] = (15748.5830, 4123.1104, 3003.7480);
	angles[75] = (0, -368.5405, 0);
	at[75] = 13.4000;
	points[76] = (15788.7803, 4330.9844, 2999.1418);
	angles[76] = (0, -370.1127, 0);
	at[76] = 13.7000;
	points[77] = (15820.9443, 4471.3384, 2996.1809);
	angles[77] = (0, -371.4895, 0);
	at[77] = 13.9000;
	points[78] = (15837.8350, 4536.6143, 2994.8662);
	angles[78] = (0, -372.3234, 0);
	at[78] = 14;
	points[79] = (15858.4248, 4608.8188, 2993.4727);
	angles[79] = (0, -373.3150, 0);
	at[79] = 14.1000;
	points[80] = (15880.3145, 4677.2837, 2992.2285);
	angles[80] = (0, -374.5475, 0);
	at[80] = 14.2000;
	points[81] = (15902.9131, 4739.3306, 2991.1970);
	angles[81] = (0, -376.0798, 0);
	at[81] = 14.3000;
	points[82] = (15933.5439, 4809.8032, 2990.1929);
	angles[82] = (0, -378.1700, 0);
	at[82] = 14.4000;
	points[83] = (15966.5752, 4869.0156, 2989.5945);
	angles[83] = (0, -381.2992, 0);
	at[83] = 14.5000;
	points[84] = (16003.4258, 4916.6538, 2989.4727);
	angles[84] = (0, -385.8412, 0);
	at[84] = 14.6000;
	points[85] = (16054.0557, 4967.3623, 2989.7246);
	angles[85] = (0, -390.9803, 0);
	at[85] = 14.7000;
	points[86] = (16110.2373, 5015.5908, 2990.2363);
	angles[86] = (0, -395.9177, 0);
	at[86] = 14.8000;
	points[87] = (16163.4648, 5057.0078, 2990.8464);
	angles[87] = (0, -400.2323, 0);
	at[87] = 14.9000;
	points[88] = (16283.6221, 5141.4570, 2992.4685);
	angles[88] = (0, -407.0754, 0);
	at[88] = 15.1000;
	points[89] = (16340.6699, 5178.5825, 2993.3230);
	angles[89] = (0, -409.7111, 0);
	at[89] = 15.2000;
	points[90] = (16463.6621, 5254.0552, 2995.2834);
	angles[90] = (0, -413.8035, 0);
	at[90] = 15.4000;
	points[91] = (16585.9844, 5324.2520, 2997.3662);
	angles[91] = (0, -416.7866, 0);
	at[91] = 15.6000;
	points[92] = (16711.8496, 5392.3623, 2999.6064);
	angles[92] = (0, -419.0436, 0);
	at[92] = 15.8000;
	points[93] = (16966.3398, 5519.2915, 3004.4055);
	angles[93] = (0, -422.4090, 0);
	at[93] = 16.2000;
	points[94] = (17226.8105, 5635.0396, 3009.6301);
	angles[94] = (0, -425.2079, 0);
	at[94] = 16.6000;
	points[95] = (17291.2207, 5661.3779, 3010.9685);
	angles[95] = (0, -425.9105, 0);
	at[95] = 16.7000;
	points[96] = (17426.9297, 5713.4253, 3013.8623);
	angles[96] = (0, -427.4166, 0);
	at[96] = 16.9000;
	points[97] = (17492.9922, 5736.8896, 3015.3110);
	angles[97] = (0, -428.2466, 0);
	at[97] = 17;
	points[98] = (17557.3633, 5758.4258, 3016.7441);
	angles[98] = (0, -429.1428, 0);
	at[98] = 17.1000;
	points[99] = (17629.4492, 5780.7480, 3018.3818);
	angles[99] = (0, -430.1534, 0);
	at[99] = 17.2000;
	points[100] = (17698.7012, 5800.0791, 3019.9961);
	angles[100] = (0, -431.3245, 0);
	at[100] = 17.3000;
	points[101] = (17764.3711, 5816.1812, 3021.5710);
	angles[101] = (0, -432.6882, 0);
	at[101] = 17.4000;
	points[102] = (17836.6543, 5830.6304, 3023.3582);
	angles[102] = (0, -434.3465, 0);
	at[102] = 17.5000;
	points[103] = (17908.7012, 5840.5117, 3025.2205);
	angles[103] = (0, -436.5572, 0);
	at[103] = 17.6000;
	points[104] = (17972.6387, 5843.6616, 3026.9763);
	angles[104] = (0, -439.5391, 0);
	at[104] = 17.7000;
	points[105] = (18050.3945, 5835, 3029.3230);
	angles[105] = (0, -444.4279, 0);
	at[105] = 17.8000;
	points[106] = (18104.6855, 5809.3311, 3031.3071);
	angles[106] = (0, -453.0837, 0);
	at[106] = 17.9000;
	points[107] = (18150.2363, 5760.7090, 3033.4958);
	angles[107] = (0, -464.2646, 0);
	at[107] = 18;
	points[108] = (18191.8105, 5696.4170, 3035.9016);
	angles[108] = (0, -475.1898, 0);
	at[108] = 18.1000;
	points[109] = (18222.4805, 5638.5430, 3037.8899);
	angles[109] = (0, -484.6390, 0);
	at[109] = 18.2000;
	points[110] = (18282.6387, 5502.6772, 3042.2283);
	angles[110] = (0, -499, 0);
	at[110] = 18.4000;
	points[111] = (18306.8125, 5440.5903, 3044.1182);
	angles[111] = (0, -504.2003, 0);
	at[111] = 18.5000;
	points[112] = (18330.9844, 5374.4487, 3046.0906);
	angles[112] = (0, -508.3593, 0);
	at[112] = 18.6000;
	points[113] = (18377.9922, 5235.2363, 3050.1221);
	angles[113] = (0, -514.3831, 0);
	at[113] = 18.8000;
	points[114] = (18398.5430, 5170.1577, 3051.9685);
	angles[114] = (0, -516.5428, 0);
	at[114] = 18.9000;
	points[115] = (18459.3320, 4963.0708, 3057.6851);
	angles[115] = (0, -520.9148, 0);
	at[115] = 19.2000;
	points[116] = (18496.0234, 4827.7168, 3061.3228);
	angles[116] = (0, -522.7509, 0);
	at[116] = 19.4000;
	points[117] = (18565.2363, 4550.7085, 3068.5591);
	angles[117] = (0, -525.1454, 0);
	at[117] = 19.8000;
	points[118] = (18627.7949, 4274.0942, 3075.5198);
	angles[118] = (0, -526.7450, 0);
	at[118] = 20.2000;
	points[119] = (18671.3770, 4063.6616, 3080.6338);
	angles[119] = (0, -527.7407, 0);
	at[119] = 20.5000;
	points[120] = (18697.9141, 3926.2756, 3083.8818);
	angles[120] = (0, -528.3721, 0);
	at[120] = 20.7000;
	points[121] = (18723.8984, 3783.2363, 3087.1655);
	angles[121] = (0, -529.0142, 0);
	at[121] = 20.9000;
	points[122] = (18757.9141, 3577.2246, 3091.7007);
	angles[122] = (0, -530.0662, 0);
	at[122] = 21.2000;
	points[123] = (18779.0547, 3430.4451, 3094.7402);
	angles[123] = (0, -530.9125, 0);
	at[123] = 21.4000;
	points[124] = (18795.5117, 3294.7166, 3097.3386);
	angles[124] = (0, -531.9753, 0);
	at[124] = 21.6000;
	points[125] = (18802.9922, 3217.3069, 3098.6892);
	angles[125] = (0, -532.6822, 0);
	at[125] = 21.7000;
	points[126] = (18807.8750, 3148.2480, 3099.7639);
	angles[126] = (0, -533.5963, 0);
	at[126] = 21.8000;
	points[127] = (18809.9219, 3098.9136, 3100.4253);
	angles[127] = (0, -534.5457, 0);
	at[127] = 21.8833;
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
	points[0] = (9969.0557, -9154.7246, 4731.0630);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (9969.0557, -9154.7246, 4731.0630);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (9969.0557, -9154.7246, 4819.6455);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (9969.0557, -9154.7246, 4819.6455);
	angles[3] = (0, 0, 0);
	at[3] = 2.7000;
	points[4] = (9969.0557, -9154.7246, 4891.1812);
	angles[4] = (0, 0, 0);
	at[4] = 2.7500;
	points[5] = (9969.0557, -9154.7246, 4957.9136);
	angles[5] = (0, 0, 0);
	at[5] = 2.8000;
	points[6] = (9969.0557, -9154.7246, 5019.8032);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (9969.0557, -9154.7246, 5076.8501);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (9969.0557, -9154.7246, 5129.1338);
	angles[8] = (0, 0, 0);
	at[8] = 2.9500;
	points[9] = (9969.0557, -9154.7246, 5176.5352);
	angles[9] = (0, 0, 0);
	at[9] = 3;
	points[10] = (9969.0557, -9154.7246, 5219.1338);
	angles[10] = (0, 0, 0);
	at[10] = 3.0500;
	points[11] = (9969.0557, -9154.7246, 5256.9292);
	angles[11] = (0, 0, 0);
	at[11] = 3.1000;
	points[12] = (9969.0557, -9154.7246, 5289.8823);
	angles[12] = (0, 0, 0);
	at[12] = 3.1500;
	points[13] = (9969.0557, -9154.7246, 5317.9922);
	angles[13] = (0, 0, 0);
	at[13] = 3.2000;
	points[14] = (9969.0557, -9154.7246, 5341.2993);
	angles[14] = (0, 0, 0);
	at[14] = 3.2500;
	points[15] = (9969.0557, -9154.7246, 5359.8037);
	angles[15] = (0, 0, 0);
	at[15] = 3.3000;
	points[16] = (9969.0557, -9154.7246, 5373.4644);
	angles[16] = (0, 0, 0);
	at[16] = 3.3500;
	points[17] = (9969.0557, -9154.7246, 5382.3228);
	angles[17] = (0, 0, 0);
	at[17] = 3.4000;
	points[18] = (9969.0557, -9154.7246, 5399.3701);
	angles[18] = (0, 0, 0);
	at[18] = 3.5500;
	points[19] = (9969.0557, -9154.7246, 5401.2598);
	angles[19] = (0, 0, 0);
	at[19] = 3.6000;
	points[20] = (9969.0557, -9154.7246, 5397.5596);
	angles[20] = (0, 0, 0);
	at[20] = 3.6500;
	points[21] = (9969.0557, -9154.7246, 5373.8188);
	angles[21] = (0, 0, 0);
	at[21] = 3.8000;
	points[22] = (9969.0557, -9154.7246, 5371.8896);
	angles[22] = (0, 0, 0);
	at[22] = 3.8500;
	points[23] = (9969.0557, -9154.7246, 5375.6299);
	angles[23] = (0, 0, 0);
	at[23] = 3.9000;
	points[24] = (9969.0557, -9154.7246, 5399.3701);
	angles[24] = (0, 0, 0);
	at[24] = 4.0500;
	points[25] = (9969.0557, -9154.7246, 5401.2598);
	angles[25] = (0, 0, 0);
	at[25] = 4.1000;
	points[26] = (9969.0557, -9154.7246, 5397.5596);
	angles[26] = (0, 0, 0);
	at[26] = 4.1500;
	points[27] = (9969.0557, -9154.7246, 5373.8188);
	angles[27] = (0, 0, 0);
	at[27] = 4.3000;
	points[28] = (9969.0557, -9154.7246, 5371.8896);
	angles[28] = (0, 0, 0);
	at[28] = 4.3500;
	points[29] = (9969.0557, -9154.7246, 5375.6299);
	angles[29] = (0, 0, 0);
	at[29] = 4.4000;
	points[30] = (9969.0557, -9154.7246, 5399.3701);
	angles[30] = (0, 0, 0);
	at[30] = 4.5500;
	points[31] = (9969.0557, -9154.7246, 5401.2598);
	angles[31] = (0, 0, 0);
	at[31] = 4.6000;
	points[32] = (9969.0557, -9154.7246, 5397.5596);
	angles[32] = (0, 0, 0);
	at[32] = 4.6500;
	points[33] = (9969.0557, -9154.7246, 5383.5039);
	angles[33] = (0, 0, 0);
	at[33] = 4.7500;
	points[34] = (9969.0557, -9154.7246, 4742.2441);
	angles[34] = (0, 0, 0);
	at[34] = 6.2500;
	points[35] = (9969.0557, -9154.7246, 4731.0630);
	angles[35] = (0, 0, 0);
	at[35] = 6.3000;
	points[36] = (9969.0557, -9154.7246, 4731.0630);
	angles[36] = (0, 0, 0);
	at[36] = 9;
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
	points[0] = (6919.4097, -10338.8975, 4840.7480);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6919.4097, -10338.8975, 4840.7480);
	angles[1] = (0, 0, 0);
	at[1] = 0.6500;
	points[2] = (6919.4097, -10338.8975, 4929.3311);
	angles[2] = (0, 0, 0);
	at[2] = 0.7000;
	points[3] = (6919.4097, -10338.8975, 4929.3311);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (6919.4097, -10338.8975, 4977.5591);
	angles[4] = (0, 0, 0);
	at[4] = 3;
	points[5] = (6919.4097, -10338.8975, 5045.8657);
	angles[5] = (0, 0, 0);
	at[5] = 3.0500;
	points[6] = (6919.4097, -10338.8975, 5109.3701);
	angles[6] = (0, 0, 0);
	at[6] = 3.1000;
	points[7] = (6919.4097, -10338.8975, 5168.0317);
	angles[7] = (0, 0, 0);
	at[7] = 3.1500;
	points[8] = (6919.4097, -10338.8975, 5221.8896);
	angles[8] = (0, 0, 0);
	at[8] = 3.2000;
	points[9] = (6919.4097, -10338.8975, 5270.9453);
	angles[9] = (0, 0, 0);
	at[9] = 3.2500;
	points[10] = (6919.4097, -10338.8975, 5315.1577);
	angles[10] = (0, 0, 0);
	at[10] = 3.3000;
	points[11] = (6919.4097, -10338.8975, 5354.5278);
	angles[11] = (0, 0, 0);
	at[11] = 3.3500;
	points[12] = (6919.4097, -10338.8975, 5389.0942);
	angles[12] = (0, 0, 0);
	at[12] = 3.4000;
	points[13] = (6919.4097, -10338.8975, 5418.8188);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (6919.4097, -10338.8975, 5443.7402);
	angles[14] = (0, 0, 0);
	at[14] = 3.5000;
	points[15] = (6919.4097, -10338.8975, 5463.8193);
	angles[15] = (0, 0, 0);
	at[15] = 3.5500;
	points[16] = (6919.4097, -10338.8975, 5479.0947);
	angles[16] = (0, 0, 0);
	at[16] = 3.6000;
	points[17] = (6919.4097, -10338.8975, 5489.5669);
	angles[17] = (0, 0, 0);
	at[17] = 3.6500;
	points[18] = (6919.4097, -10338.8975, 5499.3306);
	angles[18] = (0, 0, 0);
	at[18] = 3.7500;
	points[19] = (6919.4097, -10338.8975, 5507.2441);
	angles[19] = (0, 0, 0);
	at[19] = 3.8000;
	points[20] = (6919.4097, -10338.8975, 5510.9448);
	angles[20] = (0, 0, 0);
	at[20] = 3.8500;
	points[21] = (6919.4097, -10338.8975, 5509.0547);
	angles[21] = (0, 0, 0);
	at[21] = 3.9000;
	points[22] = (6919.4097, -10338.8975, 5485.2759);
	angles[22] = (0, 0, 0);
	at[22] = 4.0500;
	points[23] = (6919.4097, -10338.8975, 5481.5747);
	angles[23] = (0, 0, 0);
	at[23] = 4.1000;
	points[24] = (6919.4097, -10338.8975, 5483.4644);
	angles[24] = (0, 0, 0);
	at[24] = 4.1500;
	points[25] = (6919.4097, -10338.8975, 5507.2441);
	angles[25] = (0, 0, 0);
	at[25] = 4.3000;
	points[26] = (6919.4097, -10338.8975, 5510.9448);
	angles[26] = (0, 0, 0);
	at[26] = 4.3500;
	points[27] = (6919.4097, -10338.8975, 5509.0547);
	angles[27] = (0, 0, 0);
	at[27] = 4.4000;
	points[28] = (6919.4097, -10338.8975, 5485.2759);
	angles[28] = (0, 0, 0);
	at[28] = 4.5500;
	points[29] = (6919.4097, -10338.8975, 5481.5747);
	angles[29] = (0, 0, 0);
	at[29] = 4.6000;
	points[30] = (6919.4097, -10338.8975, 5483.4644);
	angles[30] = (0, 0, 0);
	at[30] = 4.6500;
	points[31] = (6919.4097, -10338.8975, 5507.2441);
	angles[31] = (0, 0, 0);
	at[31] = 4.8000;
	points[32] = (6919.4097, -10338.8975, 5510.9448);
	angles[32] = (0, 0, 0);
	at[32] = 4.8500;
	points[33] = (6919.4097, -10338.8975, 5509.0547);
	angles[33] = (0, 0, 0);
	at[33] = 4.9000;
	points[34] = (6919.4097, -10338.8975, 5493.1890);
	angles[34] = (0, 0, 0);
	at[34] = 5;
	points[35] = (6919.4097, -10338.8975, 5478.9370);
	angles[35] = (0, 0, 0);
	at[35] = 5.0500;
	points[36] = (6919.4097, -10338.8975, 4859.0552);
	angles[36] = (0, 0, 0);
	at[36] = 6.5000;
	points[37] = (6919.4097, -10338.8975, 4840.7480);
	angles[37] = (0, 0, 0);
	at[37] = 6.5500;
	points[38] = (6919.4097, -10338.8975, 4840.7480);
	angles[38] = (0, 0, 0);
	at[38] = 9;
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
	points[0] = (3679.3896, -7575.4331, 4665.1968);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3679.3896, -7575.4331, 4665.1968);
	angles[1] = (0, 0, 0);
	at[1] = 0.9000;
	points[2] = (3679.3896, -7575.4331, 4753.7798);
	angles[2] = (0, 0, 0);
	at[2] = 0.9500;
	points[3] = (3679.3896, -7575.4331, 4753.7798);
	angles[3] = (0, 0, 0);
	at[3] = 3.2000;
	points[4] = (3679.3896, -7575.4331, 4778.1890);
	angles[4] = (0, 0, 0);
	at[4] = 3.2500;
	points[5] = (3679.3896, -7575.4331, 4848.1104);
	angles[5] = (0, 0, 0);
	at[5] = 3.3000;
	points[6] = (3679.3896, -7575.4331, 4913.1890);
	angles[6] = (0, 0, 0);
	at[6] = 3.3500;
	points[7] = (3679.3896, -7575.4331, 4973.5039);
	angles[7] = (0, 0, 0);
	at[7] = 3.4000;
	points[8] = (3679.3896, -7575.4331, 5028.9370);
	angles[8] = (0, 0, 0);
	at[8] = 3.4500;
	points[9] = (3679.3896, -7575.4331, 5079.5669);
	angles[9] = (0, 0, 0);
	at[9] = 3.5000;
	points[10] = (3679.3896, -7575.4331, 5125.3936);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (3679.3896, -7575.4331, 5166.3779);
	angles[11] = (0, 0, 0);
	at[11] = 3.6000;
	points[12] = (3679.3896, -7575.4331, 5202.5591);
	angles[12] = (0, 0, 0);
	at[12] = 3.6500;
	points[13] = (3679.3896, -7575.4331, 5233.8975);
	angles[13] = (0, 0, 0);
	at[13] = 3.7000;
	points[14] = (3679.3896, -7575.4331, 5260.4336);
	angles[14] = (0, 0, 0);
	at[14] = 3.7500;
	points[15] = (3679.3896, -7575.4331, 5282.1260);
	angles[15] = (0, 0, 0);
	at[15] = 3.8000;
	points[16] = (3679.3896, -7575.4331, 5299.0156);
	angles[16] = (0, 0, 0);
	at[16] = 3.8500;
	points[17] = (3679.3896, -7575.4331, 5311.0630);
	angles[17] = (0, 0, 0);
	at[17] = 3.9000;
	points[18] = (3679.3896, -7575.4331, 5318.3076);
	angles[18] = (0, 0, 0);
	at[18] = 3.9500;
	points[19] = (3679.3896, -7575.4331, 5320.7085);
	angles[19] = (0, 0, 0);
	at[19] = 4;
	points[20] = (3679.3896, -7575.4331, 5334.7642);
	angles[20] = (0, 0, 0);
	at[20] = 4.1000;
	points[21] = (3679.3896, -7575.4331, 5334.7642);
	angles[21] = (0, 0, 0);
	at[21] = 4.1500;
	points[22] = (3679.3896, -7575.4331, 5329.4097);
	angles[22] = (0, 0, 0);
	at[22] = 4.2000;
	points[23] = (3679.3896, -7575.4331, 5312.0469);
	angles[23] = (0, 0, 0);
	at[23] = 4.3000;
	points[24] = (3679.3896, -7575.4331, 5306.6929);
	angles[24] = (0, 0, 0);
	at[24] = 4.3500;
	points[25] = (3679.3896, -7575.4331, 5306.6929);
	angles[25] = (0, 0, 0);
	at[25] = 4.4000;
	points[26] = (3679.3896, -7575.4331, 5312.0469);
	angles[26] = (0, 0, 0);
	at[26] = 4.4500;
	points[27] = (3679.3896, -7575.4331, 5329.4097);
	angles[27] = (0, 0, 0);
	at[27] = 4.5500;
	points[28] = (3679.3896, -7575.4331, 5334.7642);
	angles[28] = (0, 0, 0);
	at[28] = 4.6000;
	points[29] = (3679.3896, -7575.4331, 5334.7642);
	angles[29] = (0, 0, 0);
	at[29] = 4.6500;
	points[30] = (3679.3896, -7575.4331, 5329.4097);
	angles[30] = (0, 0, 0);
	at[30] = 4.7000;
	points[31] = (3679.3896, -7575.4331, 5312.0469);
	angles[31] = (0, 0, 0);
	at[31] = 4.8000;
	points[32] = (3679.3896, -7575.4331, 5306.6929);
	angles[32] = (0, 0, 0);
	at[32] = 4.8500;
	points[33] = (3679.3896, -7575.4331, 5306.6929);
	angles[33] = (0, 0, 0);
	at[33] = 4.9000;
	points[34] = (3679.3896, -7575.4331, 5312.0469);
	angles[34] = (0, 0, 0);
	at[34] = 4.9500;
	points[35] = (3679.3896, -7575.4331, 5329.4097);
	angles[35] = (0, 0, 0);
	at[35] = 5.0500;
	points[36] = (3679.3896, -7575.4331, 5334.7642);
	angles[36] = (0, 0, 0);
	at[36] = 5.1000;
	points[37] = (3679.3896, -7575.4331, 5334.7642);
	angles[37] = (0, 0, 0);
	at[37] = 5.1500;
	points[38] = (3679.3896, -7575.4331, 5329.4097);
	angles[38] = (0, 0, 0);
	at[38] = 5.2000;
	points[39] = (3679.3896, -7575.4331, 5310.5117);
	angles[39] = (0, 0, 0);
	at[39] = 5.3000;
	points[40] = (3679.3896, -7575.4331, 4669.2520);
	angles[40] = (0, 0, 0);
	at[40] = 6.8000;
	points[41] = (3679.3896, -7575.4331, 4665.1968);
	angles[41] = (0, 0, 0);
	at[41] = 6.8500;
	points[42] = (3679.3896, -7575.4331, 4665.1968);
	angles[42] = (0, 0, 0);
	at[42] = 9;
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
	points[0] = (-5193.8584, -454.5866, 3034.6733);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5193.8584, -454.5866, 3034.6733);
	angles[1] = (0, 0, 0);
	at[1] = 1.1500;
	points[2] = (-5193.8584, -454.5866, 3123.2561);
	angles[2] = (0, 0, 0);
	at[2] = 1.2000;
	points[3] = (-5193.8584, -454.5866, 3123.2561);
	angles[3] = (0, 0, 0);
	at[3] = 3.5000;
	points[4] = (-5193.8584, -454.5866, 3194.7913);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (-5193.8584, -454.5866, 3261.5039);
	angles[5] = (0, 0, 0);
	at[5] = 3.6000;
	points[6] = (-5193.8584, -454.5866, 3323.3938);
	angles[6] = (0, 0, 0);
	at[6] = 3.6500;
	points[7] = (-5193.8584, -454.5866, 3380.4607);
	angles[7] = (0, 0, 0);
	at[7] = 3.7000;
	points[8] = (-5193.8584, -454.5866, 3432.7087);
	angles[8] = (0, 0, 0);
	at[8] = 3.7500;
	points[9] = (-5193.8584, -454.5866, 3480.1301);
	angles[9] = (0, 0, 0);
	at[9] = 3.8000;
	points[10] = (-5193.8584, -454.5866, 3522.7285);
	angles[10] = (0, 0, 0);
	at[10] = 3.8500;
	points[11] = (-5193.8584, -454.5866, 3560.5078);
	angles[11] = (0, 0, 0);
	at[11] = 3.9000;
	points[12] = (-5193.8584, -454.5866, 3593.4607);
	angles[12] = (0, 0, 0);
	at[12] = 3.9500;
	points[13] = (-5193.8584, -454.5866, 3621.5947);
	angles[13] = (0, 0, 0);
	at[13] = 4;
	points[14] = (-5193.8584, -454.5866, 3644.9055);
	angles[14] = (0, 0, 0);
	at[14] = 4.0500;
	points[15] = (-5193.8584, -454.5866, 3663.3899);
	angles[15] = (0, 0, 0);
	at[15] = 4.1000;
	points[16] = (-5193.8584, -454.5866, 3677.0552);
	angles[16] = (0, 0, 0);
	at[16] = 4.1500;
	points[17] = (-5193.8584, -454.5866, 3685.8977);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-5193.8584, -454.5866, 3702.9685);
	angles[18] = (0, 0, 0);
	at[18] = 4.3500;
	points[19] = (-5193.8584, -454.5866, 3704.8662);
	angles[19] = (0, 0, 0);
	at[19] = 4.4000;
	points[20] = (-5193.8584, -454.5866, 3701.1536);
	angles[20] = (0, 0, 0);
	at[20] = 4.4500;
	points[21] = (-5193.8584, -454.5866, 3677.3977);
	angles[21] = (0, 0, 0);
	at[21] = 4.6000;
	points[22] = (-5193.8584, -454.5866, 3675.5000);
	angles[22] = (0, 0, 0);
	at[22] = 4.6500;
	points[23] = (-5193.8584, -454.5866, 3679.2129);
	angles[23] = (0, 0, 0);
	at[23] = 4.7000;
	points[24] = (-5193.8584, -454.5866, 3702.9685);
	angles[24] = (0, 0, 0);
	at[24] = 4.8500;
	points[25] = (-5193.8584, -454.5866, 3704.8662);
	angles[25] = (0, 0, 0);
	at[25] = 4.9000;
	points[26] = (-5193.8584, -454.5866, 3701.1536);
	angles[26] = (0, 0, 0);
	at[26] = 4.9500;
	points[27] = (-5193.8584, -454.5866, 3677.3977);
	angles[27] = (0, 0, 0);
	at[27] = 5.1000;
	points[28] = (-5193.8584, -454.5866, 3675.5000);
	angles[28] = (0, 0, 0);
	at[28] = 5.1500;
	points[29] = (-5193.8584, -454.5866, 3679.2129);
	angles[29] = (0, 0, 0);
	at[29] = 5.2000;
	points[30] = (-5193.8584, -454.5866, 3702.9685);
	angles[30] = (0, 0, 0);
	at[30] = 5.3500;
	points[31] = (-5193.8584, -454.5866, 3704.8662);
	angles[31] = (0, 0, 0);
	at[31] = 5.4000;
	points[32] = (-5193.8584, -454.5866, 3701.1536);
	angles[32] = (0, 0, 0);
	at[32] = 5.4500;
	points[33] = (-5193.8584, -454.5866, 3687.1143);
	angles[33] = (0, 0, 0);
	at[33] = 5.5500;
	points[34] = (-5193.8584, -454.5866, 3045.8506);
	angles[34] = (0, 0, 0);
	at[34] = 7.0500;
	points[35] = (-5193.8584, -454.5866, 3034.6733);
	angles[35] = (0, 0, 0);
	at[35] = 7.1000;
	points[36] = (-5193.8584, -454.5866, 3034.6733);
	angles[36] = (0, 0, 0);
	at[36] = 9;
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
	points[0] = (-5562.3232, -467.9685, 3034.6733);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5562.3232, -467.9685, 3034.6733);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (-5562.3232, -467.9685, 3123.2561);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (-5562.3232, -467.9685, 3123.2561);
	angles[3] = (0, 0, 0);
	at[3] = 2.7000;
	points[4] = (-5562.3232, -467.9685, 3194.7913);
	angles[4] = (0, 0, 0);
	at[4] = 2.7500;
	points[5] = (-5562.3232, -467.9685, 3261.5039);
	angles[5] = (0, 0, 0);
	at[5] = 2.8000;
	points[6] = (-5562.3232, -467.9685, 3323.3938);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-5562.3232, -467.9685, 3380.4607);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (-5562.3232, -467.9685, 3432.7087);
	angles[8] = (0, 0, 0);
	at[8] = 2.9500;
	points[9] = (-5562.3232, -467.9685, 3480.1301);
	angles[9] = (0, 0, 0);
	at[9] = 3;
	points[10] = (-5562.3232, -467.9685, 3522.7285);
	angles[10] = (0, 0, 0);
	at[10] = 3.0500;
	points[11] = (-5562.3232, -467.9685, 3560.5078);
	angles[11] = (0, 0, 0);
	at[11] = 3.1000;
	points[12] = (-5562.3232, -467.9685, 3593.4607);
	angles[12] = (0, 0, 0);
	at[12] = 3.1500;
	points[13] = (-5562.3232, -467.9685, 3621.5947);
	angles[13] = (0, 0, 0);
	at[13] = 3.2000;
	points[14] = (-5562.3232, -467.9685, 3644.9055);
	angles[14] = (0, 0, 0);
	at[14] = 3.2500;
	points[15] = (-5562.3232, -467.9685, 3663.3899);
	angles[15] = (0, 0, 0);
	at[15] = 3.3000;
	points[16] = (-5562.3232, -467.9685, 3677.0552);
	angles[16] = (0, 0, 0);
	at[16] = 3.3500;
	points[17] = (-5562.3232, -467.9685, 3685.8977);
	angles[17] = (0, 0, 0);
	at[17] = 3.4000;
	points[18] = (-5562.3232, -467.9685, 3702.9685);
	angles[18] = (0, 0, 0);
	at[18] = 3.5500;
	points[19] = (-5562.3232, -467.9685, 3704.8662);
	angles[19] = (0, 0, 0);
	at[19] = 3.6000;
	points[20] = (-5562.3232, -467.9685, 3701.1536);
	angles[20] = (0, 0, 0);
	at[20] = 3.6500;
	points[21] = (-5562.3232, -467.9685, 3677.3977);
	angles[21] = (0, 0, 0);
	at[21] = 3.8000;
	points[22] = (-5562.3232, -467.9685, 3675.5000);
	angles[22] = (0, 0, 0);
	at[22] = 3.8500;
	points[23] = (-5562.3232, -467.9685, 3679.2129);
	angles[23] = (0, 0, 0);
	at[23] = 3.9000;
	points[24] = (-5562.3232, -467.9685, 3702.9685);
	angles[24] = (0, 0, 0);
	at[24] = 4.0500;
	points[25] = (-5562.3232, -467.9685, 3704.8662);
	angles[25] = (0, 0, 0);
	at[25] = 4.1000;
	points[26] = (-5562.3232, -467.9685, 3701.1536);
	angles[26] = (0, 0, 0);
	at[26] = 4.1500;
	points[27] = (-5562.3232, -467.9685, 3677.3977);
	angles[27] = (0, 0, 0);
	at[27] = 4.3000;
	points[28] = (-5562.3232, -467.9685, 3675.5000);
	angles[28] = (0, 0, 0);
	at[28] = 4.3500;
	points[29] = (-5562.3232, -467.9685, 3679.2129);
	angles[29] = (0, 0, 0);
	at[29] = 4.4000;
	points[30] = (-5562.3232, -467.9685, 3702.9685);
	angles[30] = (0, 0, 0);
	at[30] = 4.5500;
	points[31] = (-5562.3232, -467.9685, 3704.8662);
	angles[31] = (0, 0, 0);
	at[31] = 4.6000;
	points[32] = (-5562.3232, -467.9685, 3701.1536);
	angles[32] = (0, 0, 0);
	at[32] = 4.6500;
	points[33] = (-5562.3232, -467.9685, 3687.1143);
	angles[33] = (0, 0, 0);
	at[33] = 4.7500;
	points[34] = (-5562.3232, -467.9685, 3045.8506);
	angles[34] = (0, 0, 0);
	at[34] = 6.2500;
	points[35] = (-5562.3232, -467.9685, 3034.6733);
	angles[35] = (0, 0, 0);
	at[35] = 6.3000;
	points[36] = (-5562.3232, -467.9685, 3034.6733);
	angles[36] = (0, 0, 0);
	at[36] = 9.1333;
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
	points[0] = (-5893.7007, -457.1417, 3034.6733);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5893.7007, -457.1417, 3034.6733);
	angles[1] = (0, 0, 0);
	at[1] = 1.7000;
	points[2] = (-5893.7007, -457.1417, 3123.2561);
	angles[2] = (0, 0, 0);
	at[2] = 1.7500;
	points[3] = (-5893.7007, -457.1417, 3123.2561);
	angles[3] = (0, 0, 0);
	at[3] = 4;
	points[4] = (-5893.7007, -457.1417, 3147.6338);
	angles[4] = (0, 0, 0);
	at[4] = 4.0500;
	points[5] = (-5893.7007, -457.1417, 3217.5630);
	angles[5] = (0, 0, 0);
	at[5] = 4.1000;
	points[6] = (-5893.7007, -457.1417, 3282.6692);
	angles[6] = (0, 0, 0);
	at[6] = 4.1500;
	points[7] = (-5893.7007, -457.1417, 3342.9529);
	angles[7] = (0, 0, 0);
	at[7] = 4.2000;
	points[8] = (-5893.7007, -457.1417, 3398.4136);
	angles[8] = (0, 0, 0);
	at[8] = 4.2500;
	points[9] = (-5893.7007, -457.1417, 3449.0513);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (-5893.7007, -457.1417, 3494.8662);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (-5893.7007, -457.1417, 3535.8582);
	angles[11] = (0, 0, 0);
	at[11] = 4.4000;
	points[12] = (-5893.7007, -457.1417, 3572.0276);
	angles[12] = (0, 0, 0);
	at[12] = 4.4500;
	points[13] = (-5893.7007, -457.1417, 3603.3743);
	angles[13] = (0, 0, 0);
	at[13] = 4.5000;
	points[14] = (-5893.7007, -457.1417, 3629.9016);
	angles[14] = (0, 0, 0);
	at[14] = 4.5500;
	points[15] = (-5893.7007, -457.1417, 3651.6025);
	angles[15] = (0, 0, 0);
	at[15] = 4.6000;
	points[16] = (-5893.7007, -457.1417, 3668.4802);
	angles[16] = (0, 0, 0);
	at[16] = 4.6500;
	points[17] = (-5893.7007, -457.1417, 3680.5396);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (-5893.7007, -457.1417, 3687.7717);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (-5893.7007, -457.1417, 3690.1812);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (-5893.7007, -457.1417, 3704.2246);
	angles[20] = (0, 0, 0);
	at[20] = 4.9000;
	points[21] = (-5893.7007, -457.1417, 3704.2246);
	angles[21] = (0, 0, 0);
	at[21] = 4.9500;
	points[22] = (-5893.7007, -457.1417, 3698.8623);
	angles[22] = (0, 0, 0);
	at[22] = 5;
	points[23] = (-5893.7007, -457.1417, 3681.5039);
	angles[23] = (0, 0, 0);
	at[23] = 5.1000;
	points[24] = (-5893.7007, -457.1417, 3676.1418);
	angles[24] = (0, 0, 0);
	at[24] = 5.1500;
	points[25] = (-5893.7007, -457.1417, 3676.1418);
	angles[25] = (0, 0, 0);
	at[25] = 5.2000;
	points[26] = (-5893.7007, -457.1417, 3681.5039);
	angles[26] = (0, 0, 0);
	at[26] = 5.2500;
	points[27] = (-5893.7007, -457.1417, 3698.8623);
	angles[27] = (0, 0, 0);
	at[27] = 5.3500;
	points[28] = (-5893.7007, -457.1417, 3704.2246);
	angles[28] = (0, 0, 0);
	at[28] = 5.4000;
	points[29] = (-5893.7007, -457.1417, 3704.2246);
	angles[29] = (0, 0, 0);
	at[29] = 5.4500;
	points[30] = (-5893.7007, -457.1417, 3698.8623);
	angles[30] = (0, 0, 0);
	at[30] = 5.5000;
	points[31] = (-5893.7007, -457.1417, 3681.5039);
	angles[31] = (0, 0, 0);
	at[31] = 5.6000;
	points[32] = (-5893.7007, -457.1417, 3676.1418);
	angles[32] = (0, 0, 0);
	at[32] = 5.6500;
	points[33] = (-5893.7007, -457.1417, 3676.1418);
	angles[33] = (0, 0, 0);
	at[33] = 5.7000;
	points[34] = (-5893.7007, -457.1417, 3681.5039);
	angles[34] = (0, 0, 0);
	at[34] = 5.7500;
	points[35] = (-5893.7007, -457.1417, 3698.8623);
	angles[35] = (0, 0, 0);
	at[35] = 5.8500;
	points[36] = (-5893.7007, -457.1417, 3704.2246);
	angles[36] = (0, 0, 0);
	at[36] = 5.9000;
	points[37] = (-5893.7007, -457.1417, 3704.2246);
	angles[37] = (0, 0, 0);
	at[37] = 5.9500;
	points[38] = (-5893.7007, -457.1417, 3698.8623);
	angles[38] = (0, 0, 0);
	at[38] = 6;
	points[39] = (-5893.7007, -457.1417, 3679.9883);
	angles[39] = (0, 0, 0);
	at[39] = 6.1000;
	points[40] = (-5893.7007, -457.1417, 3038.7285);
	angles[40] = (0, 0, 0);
	at[40] = 7.6000;
	points[41] = (-5893.7007, -457.1417, 3034.6733);
	angles[41] = (0, 0, 0);
	at[41] = 7.6500;
	points[42] = (-5893.7007, -457.1417, 3034.6733);
	angles[42] = (0, 0, 0);
	at[42] = 9.4000;
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
	points[0] = (-6230.9058, -444.1299, 3034.6733);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6230.9058, -444.1299, 3034.6733);
	angles[1] = (0, 0, 0);
	at[1] = 0.9000;
	points[2] = (-6230.9058, -444.1299, 3123.2561);
	angles[2] = (0, 0, 0);
	at[2] = 0.9500;
	points[3] = (-6230.9058, -444.1299, 3123.2561);
	angles[3] = (0, 0, 0);
	at[3] = 3.2000;
	points[4] = (-6230.9058, -444.1299, 3147.6338);
	angles[4] = (0, 0, 0);
	at[4] = 3.2500;
	points[5] = (-6230.9058, -444.1299, 3217.5630);
	angles[5] = (0, 0, 0);
	at[5] = 3.3000;
	points[6] = (-6230.9058, -444.1299, 3282.6692);
	angles[6] = (0, 0, 0);
	at[6] = 3.3500;
	points[7] = (-6230.9058, -444.1299, 3342.9529);
	angles[7] = (0, 0, 0);
	at[7] = 3.4000;
	points[8] = (-6230.9058, -444.1299, 3398.4136);
	angles[8] = (0, 0, 0);
	at[8] = 3.4500;
	points[9] = (-6230.9058, -444.1299, 3449.0513);
	angles[9] = (0, 0, 0);
	at[9] = 3.5000;
	points[10] = (-6230.9058, -444.1299, 3494.8662);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (-6230.9058, -444.1299, 3535.8582);
	angles[11] = (0, 0, 0);
	at[11] = 3.6000;
	points[12] = (-6230.9058, -444.1299, 3572.0276);
	angles[12] = (0, 0, 0);
	at[12] = 3.6500;
	points[13] = (-6230.9058, -444.1299, 3603.3743);
	angles[13] = (0, 0, 0);
	at[13] = 3.7000;
	points[14] = (-6230.9058, -444.1299, 3629.9016);
	angles[14] = (0, 0, 0);
	at[14] = 3.7500;
	points[15] = (-6230.9058, -444.1299, 3651.6025);
	angles[15] = (0, 0, 0);
	at[15] = 3.8000;
	points[16] = (-6230.9058, -444.1299, 3668.4802);
	angles[16] = (0, 0, 0);
	at[16] = 3.8500;
	points[17] = (-6230.9058, -444.1299, 3680.5396);
	angles[17] = (0, 0, 0);
	at[17] = 3.9000;
	points[18] = (-6230.9058, -444.1299, 3687.7717);
	angles[18] = (0, 0, 0);
	at[18] = 3.9500;
	points[19] = (-6230.9058, -444.1299, 3690.1812);
	angles[19] = (0, 0, 0);
	at[19] = 4;
	points[20] = (-6230.9058, -444.1299, 3704.2246);
	angles[20] = (0, 0, 0);
	at[20] = 4.1000;
	points[21] = (-6230.9058, -444.1299, 3704.2246);
	angles[21] = (0, 0, 0);
	at[21] = 4.1500;
	points[22] = (-6230.9058, -444.1299, 3698.8623);
	angles[22] = (0, 0, 0);
	at[22] = 4.2000;
	points[23] = (-6230.9058, -444.1299, 3681.5039);
	angles[23] = (0, 0, 0);
	at[23] = 4.3000;
	points[24] = (-6230.9058, -444.1299, 3676.1418);
	angles[24] = (0, 0, 0);
	at[24] = 4.3500;
	points[25] = (-6230.9058, -444.1299, 3676.1418);
	angles[25] = (0, 0, 0);
	at[25] = 4.4000;
	points[26] = (-6230.9058, -444.1299, 3681.5039);
	angles[26] = (0, 0, 0);
	at[26] = 4.4500;
	points[27] = (-6230.9058, -444.1299, 3698.8623);
	angles[27] = (0, 0, 0);
	at[27] = 4.5500;
	points[28] = (-6230.9058, -444.1299, 3704.2246);
	angles[28] = (0, 0, 0);
	at[28] = 4.6000;
	points[29] = (-6230.9058, -444.1299, 3704.2246);
	angles[29] = (0, 0, 0);
	at[29] = 4.6500;
	points[30] = (-6230.9058, -444.1299, 3698.8623);
	angles[30] = (0, 0, 0);
	at[30] = 4.7000;
	points[31] = (-6230.9058, -444.1299, 3681.5039);
	angles[31] = (0, 0, 0);
	at[31] = 4.8000;
	points[32] = (-6230.9058, -444.1299, 3676.1418);
	angles[32] = (0, 0, 0);
	at[32] = 4.8500;
	points[33] = (-6230.9058, -444.1299, 3676.1418);
	angles[33] = (0, 0, 0);
	at[33] = 4.9000;
	points[34] = (-6230.9058, -444.1299, 3681.5039);
	angles[34] = (0, 0, 0);
	at[34] = 4.9500;
	points[35] = (-6230.9058, -444.1299, 3698.8623);
	angles[35] = (0, 0, 0);
	at[35] = 5.0500;
	points[36] = (-6230.9058, -444.1299, 3704.2246);
	angles[36] = (0, 0, 0);
	at[36] = 5.1000;
	points[37] = (-6230.9058, -444.1299, 3704.2246);
	angles[37] = (0, 0, 0);
	at[37] = 5.1500;
	points[38] = (-6230.9058, -444.1299, 3698.8623);
	angles[38] = (0, 0, 0);
	at[38] = 5.2000;
	points[39] = (-6230.9058, -444.1299, 3679.9883);
	angles[39] = (0, 0, 0);
	at[39] = 5.3000;
	points[40] = (-6230.9058, -444.1299, 3038.7285);
	angles[40] = (0, 0, 0);
	at[40] = 6.8000;
	points[41] = (-6230.9058, -444.1299, 3034.6733);
	angles[41] = (0, 0, 0);
	at[41] = 6.8500;
	points[42] = (-6230.9058, -444.1299, 3034.6733);
	angles[42] = (0, 0, 0);
	at[42] = 9.2500;
	mover = getEnt("iz_obj_10", "targetname");
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
