main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_vanillalak_2_b", 0);

	setExpFog(1594.4882, 16807.3320, 0.7843, 0.7843, 0.7843, 0);

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
	ambientPlay("iz_0_sfcvl2", 2);
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
	level.iz_route[level.iz_route.size] = (5511, 3663, 1343);
	level.iz_route[level.iz_route.size] = (5650, 4510, 1343);
	level.iz_route[level.iz_route.size] = (5505, 5078, 1343);
	level.iz_route[level.iz_route.size] = (5161, 5314, 1343);
	level.iz_route[level.iz_route.size] = (4451, 5337, 1343);
	level.iz_route[level.iz_route.size] = (3887, 5089, 1343);
	level.iz_route[level.iz_route.size] = (3274, 4919, 1343);
	level.iz_route[level.iz_route.size] = (2640, 4940, 1343);
	level.iz_route[level.iz_route.size] = (2142, 5097, 1343);
	level.iz_route[level.iz_route.size] = (1580, 5217, 1343);
	level.iz_route[level.iz_route.size] = (1007, 5129, 1343);
	level.iz_route[level.iz_route.size] = (720, 5072, 1343);
	level.iz_route[level.iz_route.size] = (-94, 4722, 1343);
	level.iz_route[level.iz_route.size] = (-523, 4529, 1332);
	level.iz_route[level.iz_route.size] = (-1059, 4395, 1343);
	level.iz_route[level.iz_route.size] = (-1630, 4395, 1343);
	level.iz_route[level.iz_route.size] = (-2720, 4470, 1343);
	level.iz_route[level.iz_route.size] = (-3393, 4335, 1343);
	level.iz_route[level.iz_route.size] = (-3817, 4081, 1343);
	level.iz_route[level.iz_route.size] = (-3359, 4577, 1339);
	level.iz_route[level.iz_route.size] = (-3945, 4374, 1339);
	level.iz_route[level.iz_route.size] = (-4214, 4006, 1339);
	level.iz_route[level.iz_route.size] = (-4536, 3378, 1343);
	level.iz_route[level.iz_route.size] = (-5218, 2617, 1343);
	level.iz_route[level.iz_route.size] = (-5338, 2229, 1343);
	level.iz_route[level.iz_route.size] = (-5315, 1926, 1340);
	level.iz_route[level.iz_route.size] = (-4829, 1437, 1340);
	level.iz_route[level.iz_route.size] = (-4219, 1622, 1340);
	level.iz_route[level.iz_route.size] = (-4071, 2285, 1340);
	level.iz_route[level.iz_route.size] = (-3957, 2995, 1340);
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
	points[0] = (5671.5747, 4823.8584, 1340.6378);
	angles[0] = (0, 89.5428, 0);
	at[0] = 0;
	points[1] = (5538.5039, 4828.2676, 1340.6378);
	angles[1] = (0, 86.2339, 0);
	at[1] = 1.8667;
	points[2] = (5504.0552, 4831.4175, 1340.6378);
	angles[2] = (0, 83.8862, 0);
	at[2] = 2.4000;
	points[3] = (5409.2910, 4844.1733, 1340.6378);
	angles[3] = (0, 81.5687, 0);
	at[3] = 3.7333;
	points[4] = (5147.3623, 4888.8188, 1340.6378);
	angles[4] = (0, 79.3097, 0);
	at[4] = 7.4667;
	points[5] = (4942.7954, 4932.4014, 1340.6378);
	angles[5] = (0, 75.9476, 0);
	at[5] = 10.4000;
	points[6] = (4905.8267, 4942.5200, 1340.6378);
	angles[6] = (0, 73.7644, 0);
	at[6] = 10.9333;
	points[7] = (4873.1499, 4953.9766, 1340.6378);
	angles[7] = (0, 68.3684, 0);
	at[7] = 11.4667;
	points[8] = (4821.4175, 4978.3462, 1340.6378);
	angles[8] = (0, 62.9515, 0);
	at[8] = 12.2667;
	points[9] = (4738.8975, 5025.0396, 1340.6378);
	angles[9] = (0, 58.8099, 0);
	at[9] = 13.6000;
	points[10] = (4643.8188, 5087.5986, 1340.6378);
	angles[10] = (0, 54.6982, 0);
	at[10] = 15.2000;
	points[11] = (4583.3857, 5134.0161, 1340.6378);
	angles[11] = (0, 50.3330, 0);
	at[11] = 16.2667;
	points[12] = (4542.8350, 5172.7559, 1340.6378);
	angles[12] = (0, 41.9167, 0);
	at[12] = 17.0667;
	points[13] = (4531.1421, 5188.6616, 1340.6378);
	angles[13] = (0, 33.2040, 0);
	at[13] = 17.3333;
	points[14] = (4525.3545, 5204.4883, 1340.6378);
	angles[14] = (0, 15.6877, 0);
	at[14] = 17.6000;
	points[15] = (4523.4253, 5223.5830, 1340.6378);
	angles[15] = (0, 3.4077, 0);
	at[15] = 17.8667;
	points[16] = (4523.9370, 5242.8745, 1340.6378);
	angles[16] = (0, -2.7127, 0);
	at[16] = 18.1333;
	points[17] = (4528.7402, 5280.5518, 1340.6378);
	angles[17] = (0, -9.4072, 0);
	at[17] = 18.6667;
	points[18] = (4541.4961, 5335.7085, 1340.6378);
	angles[18] = (0, -15.2050, 0);
	at[18] = 19.4667;
	points[19] = (4565.7480, 5407.5195, 1340.6378);
	angles[19] = (0, -21.3850, 0);
	at[19] = 20.5333;
	points[20] = (4598.5039, 5475.7876, 1340.6378);
	angles[20] = (0, -29.5896, 0);
	at[20] = 21.6000;
	points[21] = (4619.5273, 5507.1655, 1340.6378);
	angles[21] = (0, -37.0633, 0);
	at[21] = 22.1333;
	points[22] = (4645.4727, 5532.6382, 1340.6378);
	angles[22] = (0, -52.6776, 0);
	at[22] = 22.6667;
	points[23] = (4678.1890, 5551.8506, 1340.6378);
	angles[23] = (0, -61.9636, 0);
	at[23] = 23.2000;
	points[24] = (4799.3701, 5605.3149, 1340.6378);
	angles[24] = (0, -68.3443, 0);
	at[24] = 25.0667;
	points[25] = (4942.2832, 5657.2046, 1340.6378);
	angles[25] = (0, -71.4330, 0);
	at[25] = 27.2000;
	points[26] = (5087.7563, 5701.1812, 1340.6378);
	angles[26] = (0, -75.0076, 0);
	at[26] = 29.3333;
	points[27] = (5199.3701, 5725.0396, 1340.6378);
	angles[27] = (0, -81.7733, 0);
	at[27] = 30.9333;
	points[28] = (5252.0078, 5728.5039, 1340.6378);
	angles[28] = (0, -88.7695, 0);
	at[28] = 31.7333;
	points[29] = (5424.0947, 5722.5200, 1340.6378);
	angles[29] = (0, -93.6307, 0);
	at[29] = 34.1333;
	points[30] = (5612.4805, 5706.4170, 1340.6378);
	angles[30] = (0, -95.9632, 0);
	at[30] = 36.8000;
	points[31] = (5800.1968, 5682.1650, 1340.6378);
	angles[31] = (0, -98.8963, 0);
	at[31] = 39.4667;
	points[32] = (5931.6538, 5656.3779, 1340.6378);
	angles[32] = (0, -103.9467, 0);
	at[32] = 41.3333;
	points[33] = (5986.1025, 5639.2915, 1340.6378);
	angles[33] = (0, -111.1802, 0);
	at[33] = 42.1333;
	points[34] = (6015.7085, 5623.1104, 1340.6378);
	angles[34] = (0, -123.4412, 0);
	at[34] = 42.6667;
	points[35] = (6058.9761, 5585.9448, 1340.6378);
	angles[35] = (0, -134.2267, 0);
	at[35] = 43.4667;
	points[36] = (6122.3623, 5514.3306, 1340.6378);
	angles[36] = (0, -141.1106, 0);
	at[36] = 44.8000;
	points[37] = (6178.9375, 5438.5825, 1340.6378);
	angles[37] = (0, -144.7861, 0);
	at[37] = 46.1333;
	points[38] = (6231.4570, 5359.4492, 1340.6378);
	angles[38] = (0, -147.7243, 0);
	at[38] = 47.4667;
	points[39] = (6279.2915, 5278.4253, 1340.6378);
	angles[39] = (0, -150.9855, 0);
	at[39] = 48.8000;
	points[40] = (6314.0161, 5209.5669, 1340.6378);
	angles[40] = (0, -155.5530, 0);
	at[40] = 49.8667;
	points[41] = (6327.7563, 5174.6460, 1340.6378);
	angles[41] = (0, -160.7989, 0);
	at[41] = 50.4000;
	points[42] = (6332.5986, 5156.1021, 1340.6378);
	angles[42] = (0, -167.7654, 0);
	at[42] = 50.6667;
	points[43] = (6333.0312, 5139.5669, 1340.6378);
	angles[43] = (0, -182.7818, 0);
	at[43] = 50.9333;
	points[44] = (6328.3071, 5120.6694, 1340.6378);
	angles[44] = (0, -196.9128, 0);
	at[44] = 51.2000;
	points[45] = (6311.8506, 5086.7324, 1340.6378);
	angles[45] = (0, -209.6859, 0);
	at[45] = 51.7333;
	points[46] = (6267.2441, 5025.4727, 1340.6378);
	angles[46] = (0, -219.6581, 0);
	at[46] = 52.8000;
	points[47] = (6202.1260, 4956.6929, 1340.6378);
	angles[47] = (0, -226.1377, 0);
	at[47] = 54.1333;
	points[48] = (6130.0786, 4894.9214, 1340.6378);
	angles[48] = (0, -232.4185, 0);
	at[48] = 55.4667;
	points[49] = (6082.9131, 4863.1104, 1340.6378);
	angles[49] = (0, -239.3636, 0);
	at[49] = 56.2667;
	points[50] = (6066.0630, 4854.4883, 1340.6378);
	angles[50] = (0, -244.3732, 0);
	at[50] = 56.5333;
	points[51] = (6029.9604, 4843.7402, 1340.6378);
	angles[51] = (0, -257.3368, 0);
	at[51] = 57.0667;
	points[52] = (6012.6377, 4840.5513, 1340.6378);
	angles[52] = (0, -260.1109, 0);
	at[52] = 57.3333;
	points[53] = (5917.9526, 4830.2759, 1340.6378);
	angles[53] = (0, -265.7689, 0);
	at[53] = 58.6667;
	points[54] = (5804.1733, 4824.9609, 1340.6378);
	angles[54] = (0, -268.3854, 0);
	at[54] = 60.2667;
	points[55] = (5671.5747, 4823.8584, 1340.6378);
	angles[55] = (0, -270.4572, 0);
	at[55] = 62.1333;
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
	points[0] = (-588.9252, 3680.6182, 1340.1417);
	angles[0] = (0, -13.3452, -0.0164);
	at[0] = 0;
	points[1] = (-563.5709, 3784.8743, 1339.9646);
	angles[1] = (0, -14.8054, -0.2050);
	at[1] = 1.5000;
	points[2] = (-554.4528, 3816.1851, 1339.7717);
	angles[2] = (0, -16.5046, -0.4439);
	at[2] = 2;
	points[3] = (-474.0827, 4126.3384, 1335.5670);
	angles[3] = (0, -14.6803, -0.7785);
	at[3] = 6.5000;
	points[4] = (-424.0079, 4297.8350, 1333.5433);
	angles[4] = (0, -19.6070, -0.3632);
	at[4] = 9;
	points[5] = (-411.2716, 4328.2280, 1333.5197);
	angles[5] = (0, -24.2728, 0.2072);
	at[5] = 9.5000;
	points[6] = (-379.8673, 4392.2441, 1334.3464);
	angles[6] = (0, -27.3646, 0.8737);
	at[6] = 10.5000;
	points[7] = (-345.4083, 4454.6460, 1335.5984);
	angles[7] = (0, -30.1449, 1.0828);
	at[7] = 11.5000;
	points[8] = (-307.7024, 4514.8032, 1337);
	angles[8] = (0, -33.7421, 1.1528);
	at[8] = 12.5000;
	points[9] = (-265.1587, 4571.7324, 1338.4174);
	angles[9] = (0, -39.6078, 1.1088);
	at[9] = 13.5000;
	points[10] = (-241.1945, 4597.7954, 1339.0669);
	angles[10] = (0, -44.6078, 1.0124);
	at[10] = 14;
	points[11] = (-214.1516, 4620.7871, 1339.6180);
	angles[11] = (0, -53.1461, 0.7923);
	at[11] = 14.5000;
	points[12] = (-184.7713, 4636.1812, 1339.9174);
	angles[12] = (0, -68.9911, 0.3362);
	at[12] = 15;
	points[13] = (-149.8528, 4645.1968, 1340.0433);
	angles[13] = (0, -77.9156, 0.1425);
	at[13] = 15.5000;
	points[14] = (-43.6346, 4660.1572, 1340.1417);
	angles[14] = (0, -83.9389, 0.0121);
	at[14] = 17;
	points[15] = (239.5693, 4680.2754, 1339.9922);
	angles[15] = (0, -86.8630, -0.0498);
	at[15] = 21;
	points[16] = (417.0866, 4690.8662, 1339.8623);
	angles[16] = (0, -85.4075, -0.0123);
	at[16] = 23.5000;
	points[17] = (449.8032, 4693.6221, 1339.8623);
	angles[17] = (0, -85.2998, 0);
	at[17] = 24;
	points[18] = (769.6418, 4717.4409, 1339.8623);
	angles[18] = (0, -85.6567, 0);
	at[18] = 28.5000;
	points[19] = (1052.4764, 4743.5435, 1339.8623);
	angles[19] = (0, -82.1887, 0);
	at[19] = 32.5000;
	points[20] = (1120.2834, 4756.2598, 1339.8623);
	angles[20] = (0, -77.9099, 0);
	at[20] = 33.5000;
	points[21] = (1327.9370, 4806.4961, 1339.8623);
	angles[21] = (0, -75.9696, 0);
	at[21] = 36.5000;
	points[22] = (1500.8425, 4847.9136, 1339.8623);
	angles[22] = (0, -77.5252, 0);
	at[22] = 39;
	points[23] = (1605.2362, 4867.0869, 1339.8623);
	angles[23] = (0, -82.6905, 0);
	at[23] = 40.5000;
	points[24] = (1674, 4871.5356, 1339.8623);
	angles[24] = (0, -87.9275, 0);
	at[24] = 41.5000;
	points[25] = (1887.8151, 4873.1499, 1339.8623);
	angles[25] = (0, -90.2004, 0);
	at[25] = 44.5000;
	points[26] = (2137.1653, 4873.1104, 1339.8623);
	angles[26] = (0, -89.3424, 0);
	at[26] = 48;
	points[27] = (2277.7402, 4879.2124, 1339.8623);
	angles[27] = (0, -84.0138, 0);
	at[27] = 50;
	points[28] = (2416.7676, 4900.7085, 1339.8623);
	angles[28] = (0, -80.0270, 0);
	at[28] = 52;
	points[29] = (2626.5630, 4942.1260, 1339.8623);
	angles[29] = (0, -77.7420, 0);
	at[29] = 55;
	points[30] = (2798.3584, 4984.2915, 1339.8623);
	angles[30] = (0, -74.1512, 0);
	at[30] = 57.5000;
	points[31] = (2867.4172, 5007.2046, 1339.8662);
	angles[31] = (0, -68.5247, 0);
	at[31] = 58.5000;
	points[32] = (2896.3503, 5022.0474, 1339.8623);
	angles[32] = (0, -58.7962, -0.0090);
	at[32] = 59;
	points[33] = (2924.9805, 5043.2285, 1339.8505);
	angles[33] = (0, -51.1556, -0.0240);
	at[33] = 59.5000;
	points[34] = (3001.0120, 5118.2676, 1339.7953);
	angles[34] = (0, -41.9271, -0.0293);
	at[34] = 61;
	points[35] = (3046.6023, 5172.9136, 1339.7638);
	angles[35] = (0, -38.3508, -0.0202);
	at[35] = 62;
	points[36] = (3088.6655, 5230.0396, 1339.7521);
	angles[36] = (0, -34.7173, 0);
	at[36] = 63;
	points[37] = (3126.2166, 5290.8267, 1339.7875);
	angles[37] = (0, -28.6260, 0.0575);
	at[37] = 64;
	points[38] = (3140.5471, 5322.8345, 1339.8544);
	angles[38] = (0, -20.1037, 0.1543);
	at[38] = 64.5000;
	points[39] = (3147.8818, 5356.4170, 1340.0079);
	angles[39] = (0, -9.5082, 0.3018);
	at[39] = 65;
	points[40] = (3152.0078, 5391.7720, 1340.2166);
	angles[40] = (0, -5.3178, 0.3502);
	at[40] = 65.5000;
	points[41] = (3153.8230, 5498.2285, 1340.9213);
	angles[41] = (0, 2.3981, 0.3924);
	at[41] = 67;
	points[42] = (3146.9490, 5568.9761, 1341.4133);
	angles[42] = (0, 8.2445, 0.3947);
	at[42] = 68;
	points[43] = (3140.3582, 5603.8584, 1341.6575);
	angles[43] = (0, 12.2858, 0.3886);
	at[43] = 68.5000;
	points[44] = (3130.7244, 5638.2285, 1341.8937);
	angles[44] = (0, 17.9012, 0.3737);
	at[44] = 69;
	points[45] = (3116.8228, 5670.9844, 1342.1141);
	angles[45] = (0, 26.5124, 0.3402);
	at[45] = 69.5000;
	points[46] = (3096.4922, 5699.8818, 1342.2953);
	angles[46] = (0, 41.3360, 0.2605);
	at[46] = 70;
	points[47] = (3070.9841, 5719.4092, 1342.4055);
	angles[47] = (0, 56.8472, 0.1669);
	at[47] = 70.5000;
	points[48] = (3039.3701, 5737.4800, 1342.4961);
	angles[48] = (0, 61.6462, 0.1400);
	at[48] = 71;
	points[49] = (2942.9688, 5783.5825, 1342.7284);
	angles[49] = (0, 65.9892, 0.1134);
	at[49] = 72.5000;
	points[50] = (2844.0273, 5825.2363, 1342.9252);
	angles[50] = (0, 68.0459, 0.0992);
	at[50] = 74;
	points[51] = (2711.2363, 5875.6299, 1343.1497);
	angles[51] = (0, 70.2171, 0.0826);
	at[51] = 76;
	points[52] = (2576.4763, 5920.7480, 1343.3268);
	angles[52] = (0, 72.7606, 0.0614);
	at[52] = 78;
	points[53] = (2474.5120, 5949.4487, 1343.4172);
	angles[53] = (0, 75.8039, 0.0347);
	at[53] = 79.5000;
	points[54] = (2404.9292, 5964.5273, 1343.4370);
	angles[54] = (0, 79.6823, 0);
	at[54] = 80.5000;
	points[55] = (2367.8779, 5969.8428, 1343.4253);
	angles[55] = (0, 83.4775, -0.0348);
	at[55] = 81;
	points[56] = (2336.1653, 5971.4175, 1343.3859);
	angles[56] = (0, 89.8522, -0.0942);
	at[56] = 81.5000;
	points[57] = (2301.7363, 5969.1733, 1343.3070);
	angles[57] = (0, 95.3933, -0.1524);
	at[57] = 82;
	points[58] = (2161.6221, 5944.2520, 1342.8110);
	angles[58] = (0, 102.4941, -0.2211);
	at[58] = 84;
	points[59] = (1988.4568, 5900.6304, 1342.0828);
	angles[59] = (0, 105.2810, -0.2406);
	at[59] = 86.5000;
	points[60] = (1784.0828, 5840.9448, 1341.1812);
	angles[60] = (0, 107.0794, -0.2423);
	at[60] = 89.5000;
	points[61] = (1546.2245, 5763.4253, 1340.1733);
	angles[61] = (0, 109.0936, -0.2098);
	at[61] = 93;
	points[62] = (1514.7953, 5752.3623, 1340.0551);
	angles[62] = (0, 109.5474, -0.1955);
	at[62] = 93.5000;
	points[63] = (1478.8976, 5739.3311, 1339.9370);
	angles[63] = (0, 110.2986, -0.1675);
	at[63] = 94;
	points[64] = (1417.3347, 5713.6616, 1339.8031);
	angles[64] = (0, 115.1220, -0.0762);
	at[64] = 95;
	points[65] = (1292.0789, 5646.2207, 1339.7205);
	angles[65] = (0, 119.9236, -0.0116);
	at[65] = 97;
	points[66] = (1017.2441, 5481.6533, 1339.7795);
	angles[66] = (0, 120.7367, 0.0229);
	at[66] = 101.5000;
	points[67] = (893.4960, 5411.2598, 1339.8385);
	angles[67] = (0, 118.1163, 0.0220);
	at[67] = 103.5000;
	points[68] = (829.2913, 5380, 1339.8582);
	angles[68] = (0, 113.5612, 0.0109);
	at[68] = 104.5000;
	points[69] = (799.3386, 5368.8584, 1339.8623);
	angles[69] = (0, 108.1852, 0);
	at[69] = 105;
	points[70] = (763.9370, 5359.2520, 1339.8623);
	angles[70] = (0, 103.8420, 0);
	at[70] = 105.5000;
	points[71] = (660.3346, 5339.2910, 1339.8623);
	angles[71] = (0, 99.3856, 0);
	at[71] = 107;
	points[72] = (342.6283, 5295.3154, 1339.8623);
	angles[72] = (0, 97.7173, 0);
	at[72] = 111.5000;
	points[73] = (168.0882, 5267.1650, 1339.8623);
	angles[73] = (0, 101.9692, 0);
	at[73] = 114;
	points[74] = (132.4591, 5258.1104, 1339.8623);
	angles[74] = (0, 106.2224, 0);
	at[74] = 114.5000;
	points[75] = (101.9331, 5246.2603, 1339.8740);
	angles[75] = (0, 113.6689, 0.0472);
	at[75] = 115;
	points[76] = (39.0785, 5212.3623, 1339.9922);
	angles[76] = (0, 120.8430, 0.1153);
	at[76] = 116;
	points[77] = (-49.9008, 5153.6216, 1340.2126);
	angles[77] = (0, 125.0980, 0.1116);
	at[77] = 117.5000;
	points[78] = (-135.5398, 5090.3154, 1340.3622);
	angles[78] = (0, 127.4819, 0.0432);
	at[78] = 119;
	points[79] = (-246.2311, 5000.7871, 1340.0945);
	angles[79] = (0, 130.5045, -0.3649);
	at[79] = 121;
	points[80] = (-271.3949, 4978.2285, 1339.7008);
	angles[80] = (0, 133.6988, -0.9644);
	at[80] = 121.5000;
	points[81] = (-295.2374, 4951.8896, 1338.8151);
	angles[81] = (0, 139.5898, -1.6169);
	at[81] = 122;
	points[82] = (-360.0929, 4866.8901, 1335.1851);
	angles[82] = (0, 143.8316, -2.0661);
	at[82] = 123.5000;
	points[83] = (-423.3937, 4781.1812, 1331.4055);
	angles[83] = (0, 142.7276, -1.9385);
	at[83] = 125;
	points[84] = (-468.1260, 4726.1812, 1329.2639);
	angles[84] = (0, 138.8172, -1.5026);
	at[84] = 126;
	points[85] = (-492.7992, 4700.5903, 1328.5236);
	angles[85] = (0, 134.0359, -0.9626);
	at[85] = 126.5000;
	points[86] = (-519.1732, 4679.8423, 1328.3622);
	angles[86] = (0, 124.2464, 0.2398);
	at[86] = 127;
	points[87] = (-549.8071, 4661.4961, 1328.8385);
	angles[87] = (0, 119.6754, 0.9607);
	at[87] = 127.5000;
	points[88] = (-644.8149, 4612.7559, 1331.2678);
	angles[88] = (0, 115.7788, 1.4586);
	at[88] = 129;
	points[89] = (-774.3544, 4553.8584, 1335.0670);
	angles[89] = (0, 113.3732, 1.5461);
	at[89] = 131;
	points[90] = (-906.6260, 4500.5908, 1338.6890);
	angles[90] = (0, 110.2916, 1.2935);
	at[90] = 133;
	points[91] = (-972.3425, 4479.0552, 1339.8977);
	angles[91] = (0, 105.3875, 0.6190);
	at[91] = 134;
	points[92] = (-1007.6063, 4471.7715, 1340.1378);
	angles[92] = (0, 100.1147, 0.2953);
	at[92] = 134.5000;
	points[93] = (-1077.1221, 4462.1655, 1340.3307);
	angles[93] = (0, 96.8320, 0.0882);
	at[93] = 135.5000;
	points[94] = (-1324.8386, 4436.6538, 1340.2205);
	angles[94] = (0, 96.1881, -0.0819);
	at[94] = 139;
	points[95] = (-1430.9489, 4423.4253, 1340.0511);
	angles[95] = (0, 98.1718, -0.0966);
	at[95] = 140.5000;
	points[96] = (-1501.3583, 4411.2598, 1339.9331);
	angles[96] = (0, 101.4706, -0.0871);
	at[96] = 141.5000;
	points[97] = (-1535.3151, 4403.1104, 1339.8859);
	angles[97] = (0, 104.8427, -0.0674);
	at[97] = 142;
	points[98] = (-1567.9646, 4391.8506, 1339.8623);
	angles[98] = (0, 112.6411, -0.0110);
	at[98] = 142.5000;
	points[99] = (-1598.5157, 4375.7085, 1339.8623);
	angles[99] = (0, 119.7691, 0);
	at[99] = 143;
	points[100] = (-1686.7206, 4316.2603, 1339.8662);
	angles[100] = (0, 126.1632, 0);
	at[100] = 144.5000;
	points[101] = (-1826.0907, 4205.3940, 1339.8662);
	angles[101] = (0, 130.3068, 0);
	at[101] = 147;
	points[102] = (-1957.0708, 4085.1575, 1339.8662);
	angles[102] = (0, 135.2213, 0);
	at[102] = 149.5000;
	points[103] = (-2004.8386, 4032.1653, 1339.8623);
	angles[103] = (0, 141.0677, 0);
	at[103] = 150.5000;
	points[104] = (-2023.1104, 4004.2913, 1339.8623);
	angles[104] = (0, 151.7526, 0);
	at[104] = 151;
	points[105] = (-2036.0355, 3971.2207, 1339.8623);
	angles[105] = (0, 161.6280, 0);
	at[105] = 151.5000;
	points[106] = (-2052.1970, 3901.7322, 1339.8623);
	angles[106] = (0, 169.9933, 0);
	at[106] = 152.5000;
	points[107] = (-2060.7676, 3831.2993, 1339.8623);
	angles[107] = (0, 175.2584, 0);
	at[107] = 153.5000;
	points[108] = (-2063.0828, 3760.2324, 1339.8623);
	angles[108] = (0, 180.4493, 0);
	at[108] = 154.5000;
	points[109] = (-2057.9331, 3689.4331, 1339.8623);
	angles[109] = (0, 187.4604, 0);
	at[109] = 155.5000;
	points[110] = (-2051.3740, 3654.7480, 1339.8623);
	angles[110] = (0, 192.8710, 0);
	at[110] = 156;
	points[111] = (-2040.4213, 3620.7444, 1339.8623);
	angles[111] = (0, 201.4259, 0);
	at[111] = 156.5000;
	points[112] = (-2022.5354, 3590.3110, 1339.8623);
	angles[112] = (0, 217.2874, 0);
	at[112] = 157;
	points[113] = (-1997.7521, 3568.4568, 1339.8623);
	angles[113] = (0, 232.4595, 0);
	at[113] = 157.5000;
	points[114] = (-1968.5039, 3548.6931, 1339.8623);
	angles[114] = (0, 237.3432, 0);
	at[114] = 158;
	points[115] = (-1874.7125, 3495.4607, 1339.8623);
	angles[115] = (0, 242.1228, 0);
	at[115] = 159.5000;
	points[116] = (-1747.5394, 3432.4016, 1339.8623);
	angles[116] = (0, 244.6996, 0);
	at[116] = 161.5000;
	points[117] = (-1519.4567, 3332.9055, 1339.8623);
	angles[117] = (0, 248.1553, 0);
	at[117] = 165;
	points[118] = (-1418.4330, 3295.0039, 1339.8623);
	angles[118] = (0, 250.8057, 0);
	at[118] = 166.5000;
	points[119] = (-1350.1300, 3274.1182, 1339.8623);
	angles[119] = (0, 255.5093, 0);
	at[119] = 167.5000;
	points[120] = (-1319.3976, 3268.2285, 1339.8623);
	angles[120] = (0, 261.6216, 0);
	at[120] = 168;
	points[121] = (-1248.3268, 3263.9487, 1339.8662);
	angles[121] = (0, 269.0563, 0);
	at[121] = 169;
	points[122] = (-1141.2166, 3267.0198, 1339.8662);
	angles[122] = (0, 273.3349, 0);
	at[122] = 170.5000;
	points[123] = (-1034.9724, 3276.0276, 1339.8662);
	angles[123] = (0, 276.0309, 0);
	at[123] = 172;
	points[124] = (-929.5197, 3289.7834, 1339.8662);
	angles[124] = (0, 278.6720, 0);
	at[124] = 173.5000;
	points[125] = (-823.8111, 3309.5906, 1339.8662);
	angles[125] = (0, 282.6273, 0);
	at[125] = 175;
	points[126] = (-755.8582, 3328.4451, 1339.8662);
	angles[126] = (0, 288.6255, 0);
	at[126] = 176;
	points[127] = (-722.7952, 3342.7324, 1339.8662);
	angles[127] = (0, 297.6184, 0);
	at[127] = 176.5000;
	points[128] = (-698.2165, 3364.3110, 1339.8740);
	angles[128] = (0, 318.7517, 0.0378);
	at[128] = 177;
	points[129] = (-679.0630, 3393.9016, 1339.9094);
	angles[129] = (0, 330.4873, 0.0624);
	at[129] = 177.5000;
	points[130] = (-663.7283, 3425.8821, 1339.9529);
	angles[130] = (0, 336.1862, 0.0687);
	at[130] = 178;
	points[131] = (-628.5748, 3526.7913, 1340.0709);
	angles[131] = (0, 343.4209, 0.0564);
	at[131] = 179.5000;
	points[132] = (-588.9252, 3680.6182, 1340.1417);
	angles[132] = (0, 346.6548, -0.0164);
	at[132] = 181.7330;
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
	points[0] = (-3104.0354, 4556.4961, 1342.3938);
	angles[0] = (0, -39.0776, 0);
	at[0] = 0;
	points[1] = (-3055.2954, 4614.7241, 1342.3938);
	angles[1] = (0, -41.1627, 0);
	at[1] = 1.0667;
	points[2] = (-3030.6458, 4640.6694, 1342.3938);
	angles[2] = (0, -45.4689, 0);
	at[2] = 1.6000;
	points[3] = (-2987.7283, 4679.7637, 1342.3938);
	angles[3] = (0, -48.4437, 0);
	at[3] = 2.4000;
	points[4] = (-2873.8740, 4779.2520, 1342.3938);
	angles[4] = (0, -48.6186, 0);
	at[4] = 4.5333;
	points[5] = (-2789.9133, 4855.7085, 1342.3938);
	angles[5] = (0, -46.4950, 0);
	at[5] = 6.1333;
	points[6] = (-2736.3506, 4910.3545, 1342.3938);
	angles[6] = (0, -42.0117, 0);
	at[6] = 7.2000;
	points[7] = (-2712.9802, 4940.0786, 1342.3938);
	angles[7] = (0, -34.6805, 0);
	at[7] = 7.7333;
	points[8] = (-2704.8701, 4954.7637, 1342.3938);
	angles[8] = (0, -27.0311, 0);
	at[8] = 8;
	points[9] = (-2691.3269, 4990.1968, 1342.3938);
	angles[9] = (0, -18.4509, 0);
	at[9] = 8.5333;
	points[10] = (-2680.8308, 5026.7715, 1342.3938);
	angles[10] = (0, -14.8416, 0);
	at[10] = 9.0667;
	points[11] = (-2660.8782, 5119.6851, 1342.3938);
	angles[11] = (0, -10.3784, 0);
	at[11] = 10.4000;
	points[12] = (-2644.3230, 5232.1655, 1342.3938);
	angles[12] = (0, -6.6305, 0);
	at[12] = 12;
	points[13] = (-2637.9724, 5327.3623, 1342.3938);
	angles[13] = (0, -0.0485, 0);
	at[13] = 13.3333;
	points[14] = (-2641.9172, 5363.3467, 1342.3938);
	angles[14] = (0, 10.1680, 0);
	at[14] = 13.8667;
	points[15] = (-2656.3503, 5418.0312, 1342.3938);
	angles[15] = (0, 16.9817, 0);
	at[15] = 14.6667;
	points[16] = (-2675.0669, 5472.0078, 1342.3938);
	angles[16] = (0, 20.5131, 0);
	at[16] = 15.4667;
	points[17] = (-2704.5432, 5541.6533, 1342.3938);
	angles[17] = (0, 24.9742, 0);
	at[17] = 16.5333;
	points[18] = (-2731.1851, 5592.3228, 1342.3938);
	angles[18] = (0, 30.1659, 0);
	at[18] = 17.3333;
	points[19] = (-2752.3818, 5623.6221, 1342.3938);
	angles[19] = (0, 37.2845, 0);
	at[19] = 17.8667;
	points[20] = (-2765.3582, 5637.7563, 1342.3938);
	angles[20] = (0, 44.9782, 0);
	at[20] = 18.1333;
	points[21] = (-2779.3584, 5647.3618, 1342.3938);
	angles[21] = (0, 59.6975, 0);
	at[21] = 18.4000;
	points[22] = (-2797.4448, 5654.6064, 1342.3938);
	angles[22] = (0, 70.0179, 0);
	at[22] = 18.6667;
	points[23] = (-2815.3545, 5659.8423, 1342.3938);
	angles[23] = (0, 74.6234, 0);
	at[23] = 18.9333;
	points[24] = (-2889.9373, 5673.7007, 1342.3938);
	angles[24] = (0, 81.9356, 0);
	at[24] = 20;
	points[25] = (-3003.3347, 5684.2524, 1342.3938);
	angles[25] = (0, 86.7198, 0);
	at[25] = 21.6000;
	points[26] = (-3098.2915, 5686.1025, 1342.3938);
	angles[26] = (0, 90.9612, 0);
	at[26] = 22.9333;
	points[27] = (-3136.3188, 5684.2524, 1342.3938);
	angles[27] = (0, 94.1346, 0);
	at[27] = 23.4667;
	points[28] = (-3171.1104, 5679.6060, 1342.3938);
	angles[28] = (0, 99.7743, 0);
	at[28] = 24;
	points[29] = (-3319.2678, 5644.1338, 1342.3938);
	angles[29] = (0, 105.1429, 0);
	at[29] = 26.1333;
	points[30] = (-3501.1614, 5588.9766, 1342.3938);
	angles[30] = (0, 108.6374, 0);
	at[30] = 28.8000;
	points[31] = (-3625.0435, 5540.8267, 1342.3938);
	angles[31] = (0, 114.8242, 0);
	at[31] = 30.6667;
	points[32] = (-3658.7166, 5522.8345, 1342.3938);
	angles[32] = (0, 120.9377, 0);
	at[32] = 31.2000;
	points[33] = (-3672.1970, 5513.2280, 1342.3938);
	angles[33] = (0, 127.5731, 0);
	at[33] = 31.4667;
	points[34] = (-3685.8582, 5500.4727, 1342.3938);
	angles[34] = (0, 134.3990, 0);
	at[34] = 31.7333;
	points[35] = (-3710.5435, 5471.7720, 1342.3938);
	angles[35] = (0, 141.3781, 0);
	at[35] = 32.2667;
	points[36] = (-3784.3857, 5361.0635, 1342.3938);
	angles[36] = (0, 148.9044, 0);
	at[36] = 34.1333;
	points[37] = (-3849.9016, 5245.4727, 1342.3938);
	angles[37] = (0, 151.5126, 0);
	at[37] = 36;
	points[38] = (-3954.3701, 5045.0396, 1342.3938);
	angles[38] = (0, 153.1551, 0);
	at[38] = 39.2000;
	points[39] = (-4003.5042, 4942.5986, 1342.3938);
	angles[39] = (0, 155.6317, 0);
	at[39] = 40.8000;
	points[40] = (-4039.4094, 4855.1968, 1342.3938);
	angles[40] = (0, 159.8725, 0);
	at[40] = 42.1333;
	points[41] = (-4060.0393, 4782.2051, 1342.3938);
	angles[41] = (0, 169.3463, 0);
	at[41] = 43.2000;
	points[42] = (-4061.8110, 4746.5352, 1342.3938);
	angles[42] = (0, 182.8224, 0);
	at[42] = 43.7333;
	points[43] = (-4053.4646, 4689.2129, 1342.3938);
	angles[43] = (0, 190.4025, 0);
	at[43] = 44.5333;
	points[44] = (-4027.9919, 4578.3467, 1342.3938);
	angles[44] = (0, 194.5272, 0);
	at[44] = 46.1333;
	points[45] = (-3996.5354, 4469.1733, 1342.3938);
	angles[45] = (0, 197.4346, 0);
	at[45] = 47.7333;
	points[46] = (-3965.0393, 4379.1733, 1342.3938);
	angles[46] = (0, 201.2157, 0);
	at[46] = 49.0667;
	points[47] = (-3942.0867, 4327.6377, 1342.3938);
	angles[47] = (0, 206.9695, 0);
	at[47] = 49.8667;
	points[48] = (-3932.0435, 4310.5513, 1342.3938);
	angles[48] = (0, 212.0566, 0);
	at[48] = 50.1333;
	points[49] = (-3921.2048, 4297.7559, 1342.3938);
	angles[49] = (0, 224.6643, 0);
	at[49] = 50.4000;
	points[50] = (-3904.7483, 4287.5986, 1342.3938);
	angles[50] = (0, 241.7172, 0);
	at[50] = 50.6667;
	points[51] = (-3887.7205, 4281.1416, 1342.3938);
	angles[51] = (0, 250.9387, 0);
	at[51] = 50.9333;
	points[52] = (-3850.6062, 4272.6772, 1342.3938);
	angles[52] = (0, 259.8984, 0);
	at[52] = 51.4667;
	points[53] = (-3775.0710, 4265.4727, 1342.3938);
	angles[53] = (0, 267.1496, 0);
	at[53] = 52.5333;
	points[54] = (-3680.2798, 4264.8818, 1342.3938);
	angles[54] = (0, 271.3159, 0);
	at[54] = 53.8667;
	points[55] = (-3585.4685, 4269.7642, 1342.3938);
	angles[55] = (0, 274.3297, 0);
	at[55] = 55.2000;
	points[56] = (-3549.1772, 4274.2129, 1342.3938);
	angles[56] = (0, 278.5660, 0);
	at[56] = 55.7333;
	points[57] = (-3474.5867, 4288.7793, 1342.3938);
	angles[57] = (0, 282.5083, 0);
	at[57] = 56.8000;
	points[58] = (-3346.6023, 4324.4092, 1342.3938);
	angles[58] = (0, 288.9396, 0);
	at[58] = 58.6667;
	points[59] = (-3294.1338, 4346.5747, 1342.3938);
	angles[59] = (0, 297.2509, 0);
	at[59] = 59.4667;
	points[60] = (-3264.6143, 4368.6221, 1342.3938);
	angles[60] = (0, 311.7654, 0);
	at[60] = 60;
	points[61] = (-3213.0393, 4423.7402, 1342.3938);
	angles[61] = (0, 318.9911, 0);
	at[61] = 61.0667;
	points[62] = (-3104.0354, 4556.4961, 1342.3938);
	angles[62] = (0, 320.9224, 0);
	at[62] = 63.4833;
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
