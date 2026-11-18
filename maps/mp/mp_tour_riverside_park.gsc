main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_riverside_park", 0);

	setExpFog(5905.5117, 14517.7158, 1, 0.7765, 0.2706, 0);

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
	ambientPlay("iz_0_trrp", 2);
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
	level.iz_route[level.iz_route.size] = (1888, -272, 316);
	level.iz_route[level.iz_route.size] = (1892, -1709, 316);
	level.iz_route[level.iz_route.size] = (1901, -2999, 318);
	level.iz_route[level.iz_route.size] = (1847, -3771, 322);
	level.iz_route[level.iz_route.size] = (1723, -4305, 335);
	level.iz_route[level.iz_route.size] = (1366, -4684, 353);
	level.iz_route[level.iz_route.size] = (883, -4903, 350);
	level.iz_route[level.iz_route.size] = (320, -4925, 338);
	level.iz_route[level.iz_route.size] = (-214, -4850, 332);
	level.iz_route[level.iz_route.size] = (-705, -4551, 328);
	level.iz_route[level.iz_route.size] = (-1310, -4066, 333);
	level.iz_route[level.iz_route.size] = (-1725, -3879, 334);
	level.iz_route[level.iz_route.size] = (-2325, -3824, 326);
	level.iz_route[level.iz_route.size] = (-3053, -4069, 316);
	level.iz_route[level.iz_route.size] = (-3883, -4350, 337);
	level.iz_route[level.iz_route.size] = (-4601, -4426, 366);
	level.iz_route[level.iz_route.size] = (-5301, -4206, 376);
	level.iz_route[level.iz_route.size] = (-5993, -3773, 389);
	level.iz_route[level.iz_route.size] = (-6277, -3354, 399);
	level.iz_route[level.iz_route.size] = (-6227, -2826, 402);
	level.iz_route[level.iz_route.size] = (-5966, -2411, 406);
	level.iz_route[level.iz_route.size] = (-5480, -2184, 399);
	level.iz_route[level.iz_route.size] = (-5013, -1976, 407);
	level.iz_route[level.iz_route.size] = (-3980, -1462, 230);
	level.iz_route[level.iz_route.size] = (-3085, -1141, 231);
	level.iz_route[level.iz_route.size] = (-1812, -625, 233);
	level.iz_route[level.iz_route.size] = (-1308, -398, 257);
	level.iz_route[level.iz_route.size] = (-1049, -63, 284);
	level.iz_route[level.iz_route.size] = (-882, 418, 309);
	level.iz_route[level.iz_route.size] = (-944, 991, 290);
	level.iz_route[level.iz_route.size] = (-1194, 1500, 288);
	level.iz_route[level.iz_route.size] = (-1702, 1980, 269);
	level.iz_route[level.iz_route.size] = (-2574, 2727, 239);
	level.iz_route[level.iz_route.size] = (-3396, 3456, 234);
	level.iz_route[level.iz_route.size] = (-3710, 3551, 233);
	level.iz_route[level.iz_route.size] = (-4110, 3594, 233);
	level.iz_route[level.iz_route.size] = (-5155, 3586, 241);
	level.iz_route[level.iz_route.size] = (-5749, 3615, 257);
	level.iz_route[level.iz_route.size] = (-6265, 3766, 283);
	level.iz_route[level.iz_route.size] = (-6597, 4062, 299);
	level.iz_route[level.iz_route.size] = (-6845, 4527, 305);
	level.iz_route[level.iz_route.size] = (-6907, 5150, 307);
	level.iz_route[level.iz_route.size] = (-6672, 5687, 304);
	level.iz_route[level.iz_route.size] = (-6070, 6239, 290);
	level.iz_route[level.iz_route.size] = (-4999, 6707, 255);
	level.iz_route[level.iz_route.size] = (-4218, 6737, 249);
	level.iz_route[level.iz_route.size] = (-3773, 6652, 257);
	level.iz_route[level.iz_route.size] = (-3371, 6388, 273);
	level.iz_route[level.iz_route.size] = (-2636, 5055, 269);
	level.iz_route[level.iz_route.size] = (-2149, 4366, 239);
	level.iz_route[level.iz_route.size] = (-1672, 4132, 221);
	level.iz_route[level.iz_route.size] = (-1082, 3963, 214);
	level.iz_route[level.iz_route.size] = (-289, 3843, 215);
	level.iz_route[level.iz_route.size] = (536, 3831, 221);
	level.iz_route[level.iz_route.size] = (1668, 3853, 228);
	level.iz_route[level.iz_route.size] = (2682, 3795, 263);
	level.iz_route[level.iz_route.size] = (3803, 3688, 343);
	level.iz_route[level.iz_route.size] = (4338, 3826, 394);
	level.iz_route[level.iz_route.size] = (4636, 4022, 428);
	level.iz_route[level.iz_route.size] = (4960, 4422, 481);
	level.iz_route[level.iz_route.size] = (5188, 4958, 561);
	level.iz_route[level.iz_route.size] = (5263, 5594, 662);
	level.iz_route[level.iz_route.size] = (5071, 6084, 744);
	level.iz_route[level.iz_route.size] = (4619, 6566, 845);
	level.iz_route[level.iz_route.size] = (3838, 6893, 1035);
	level.iz_route[level.iz_route.size] = (3183, 6842, 1201);
	level.iz_route[level.iz_route.size] = (2569, 6562, 1360);
	level.iz_route[level.iz_route.size] = (2095, 6039, 1487);
	level.iz_route[level.iz_route.size] = (1850, 5492, 1544);
	level.iz_route[level.iz_route.size] = (1784, 4751, 1568);
	level.iz_route[level.iz_route.size] = (1778, 3975, 1556);
	level.iz_route[level.iz_route.size] = (1848, 1492, 1054);
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
	points[0] = (-4270.3545, 2764.0276, 226.5961);
	angles[0] = (0, -108.8241, 0);
	at[0] = 0;
	points[1] = (-4205.7480, 2748.8938, 225.6839);
	angles[1] = (0, -101.7750, 0);
	at[1] = 0.2500;
	points[2] = (-4139.8032, 2740.0237, 224.7264);
	angles[2] = (0, -96.4208, 0);
	at[2] = 0.5000;
	points[3] = (-4073.1104, 2738.8113, 223.7724);
	angles[3] = (0, -88.6901, 0);
	at[3] = 0.7500;
	points[4] = (-4013.8188, 2762.4448, 223.0122);
	angles[4] = (0, -57.2257, 0);
	at[4] = 1;
	points[5] = (-3969.2520, 2812.2441, 222.4500);
	angles[5] = (0, -40.3664, 0);
	at[5] = 1.2500;
	points[6] = (-3929.9331, 2866.0474, 222.0346);
	angles[6] = (0, -35.2304, 0);
	at[6] = 1.5000;
	points[7] = (-3894.8308, 2922.5513, 221.8500);
	angles[7] = (0, -30.6298, 0);
	at[7] = 1.7500;
	points[8] = (-3869.0354, 2982.3267, 222.3405);
	angles[8] = (0, -19.4163, 0);
	at[8] = 2;
	points[9] = (-3854.3149, 3047.5435, 223.9720);
	angles[9] = (0, -11.9305, 0);
	at[9] = 2.2500;
	points[10] = (-3842.9805, 3113.4094, 225.8118);
	angles[10] = (0, -9.2628, 0);
	at[10] = 2.5000;
	points[11] = (-3828.1968, 3245.7166, 229.4508);
	angles[11] = (0, -4.4417, 0);
	at[11] = 3;
	points[12] = (-3826.6497, 3312.4644, 231.0437);
	angles[12] = (0, -0.0142, 0);
	at[12] = 3.2500;
	points[13] = (-3834.2678, 3375.7717, 232.0181);
	angles[13] = (0, 9.4299, 0);
	at[13] = 3.5000;
	points[14] = (-3849.2324, 3442.3071, 232.4563);
	angles[14] = (0, 13.0630, 0);
	at[14] = 3.7500;
	points[15] = (-3883.1772, 3570.8032, 232.9949);
	angles[15] = (0, 15.6300, 0);
	at[15] = 4.2500;
	points[16] = (-3944.9607, 3761.2402, 233.6398);
	angles[16] = (0, 20.0191, 0);
	at[16] = 5;
	points[17] = (-3970, 3823.2561, 233.8736);
	angles[17] = (0, 22.7012, 0);
	at[17] = 5.2500;
	points[18] = (-3999.4094, 3883.2520, 234.1555);
	angles[18] = (0, 27.5689, 0);
	at[18] = 5.5000;
	points[19] = (-4037.7952, 3935.2402, 234.5634);
	angles[19] = (0, 41.7148, 0);
	at[19] = 5.7500;
	points[20] = (-4093.4646, 3968.3857, 235.2681);
	angles[20] = (0, 62.1882, 0);
	at[20] = 6;
	points[21] = (-4155.4331, 3993.3857, 236.0831);
	angles[21] = (0, 69.0386, 0);
	at[21] = 6.2500;
	points[22] = (-4218.9370, 4014.6064, 236.9146);
	angles[22] = (0, 72.0558, 0);
	at[22] = 6.5000;
	points[23] = (-4412.0078, 4067.4805, 239.3256);
	angles[23] = (0, 75.9604, 0);
	at[23] = 7.2500;
	points[24] = (-4607.5591, 4112.3232, 241.3386);
	angles[24] = (0, 77.7055, 0);
	at[24] = 8;
	points[25] = (-4735.6694, 4137.9526, 241.6150);
	angles[25] = (0, 80.4307, 0);
	at[25] = 8.5000;
	points[26] = (-4934.0942, 4159.6851, 239.5724);
	angles[26] = (0, 84.5900, 0);
	at[26] = 9.2500;
	points[27] = (-5133.2285, 4178.8975, 237.0035);
	angles[27] = (0, 84.0883, 0);
	at[27] = 10;
	points[28] = (-5264.8818, 4195.1577, 235.3386);
	angles[28] = (0, 82.0167, 0);
	at[28] = 10.5000;
	points[29] = (-5330.2759, 4206.3389, 234.6102);
	angles[29] = (0, 79.4995, 0);
	at[29] = 10.7500;
	points[30] = (-5392.3623, 4222.4805, 234.1209);
	angles[30] = (0, 73.4673, 0);
	at[30] = 11;
	points[31] = (-5455.1182, 4245.1182, 233.9004);
	angles[31] = (0, 69.6419, 0);
	at[31] = 11.2500;
	points[32] = (-5640.4727, 4321.6929, 233.6284);
	angles[32] = (0, 66.6162, 0);
	at[32] = 12;
	points[33] = (-5822.9131, 4404.7637, 233.5071);
	angles[33] = (0, 64.6964, 0);
	at[33] = 12.7500;
	points[34] = (-5941.8896, 4463.8188, 233.4244);
	angles[34] = (0, 62.8359, 0);
	at[34] = 13.2500;
	points[35] = (-6057.8740, 4529.8032, 233.2547);
	angles[35] = (0, 57.9867, 0);
	at[35] = 13.7500;
	points[36] = (-6106.9688, 4571.7720, 232.9843);
	angles[36] = (0, 43.1034, 0);
	at[36] = 14;
	points[37] = (-6131.5752, 4633.4253, 232.3402);
	angles[37] = (0, 17.2694, 0);
	at[37] = 14.2500;
	points[38] = (-6140.3154, 4699.2520, 231.5780);
	angles[38] = (0, 5.7426, 0);
	at[38] = 14.5000;
	points[39] = (-6141.4565, 4766.0234, 230.7717);
	angles[39] = (0, -0.0764, 0);
	at[39] = 14.7500;
	points[40] = (-6131.4175, 4899.0156, 229.1102);
	angles[40] = (0, -6.1766, 0);
	at[40] = 15.2500;
	points[41] = (-6112.1650, 5028.9370, 227.4165);
	angles[41] = (0, -9.8339, 0);
	at[41] = 15.7500;
	points[42] = (-6098.8584, 5094.7637, 226.5020);
	angles[42] = (0, -11.8671, 0);
	at[42] = 16;
	points[43] = (-6065.3545, 5223.5830, 224.6850);
	angles[43] = (0, -16.3865, 0);
	at[43] = 16.5000;
	points[44] = (-6043.7402, 5286.6929, 223.7925);
	angles[44] = (0, -19.8046, 0);
	at[44] = 16.7500;
	points[45] = (-6017.1655, 5347.2837, 222.9382);
	angles[45] = (0, -25.2516, 0);
	at[45] = 17;
	points[46] = (-5980.7090, 5403.6221, 222.1555);
	angles[46] = (0, -36.3983, 0);
	at[46] = 17.2500;
	points[47] = (-5929.9209, 5444.4092, 221.6453);
	angles[47] = (0, -54.2281, 0);
	at[47] = 17.5000;
	points[48] = (-5872.6772, 5478.4248, 221.2815);
	angles[48] = (0, -59.9140, 0);
	at[48] = 17.7500;
	points[49] = (-5755.8267, 5539.8818, 220.6595);
	angles[49] = (0, -63.0831, 0);
	at[49] = 18.2500;
	points[50] = (-5514.6064, 5655.2363, 219.4189);
	angles[50] = (0, -65.1622, 0);
	at[50] = 19.2500;
	points[51] = (-5270.8267, 5764.8428, 217.6433);
	angles[51] = (0, -66.2252, 0);
	at[51] = 20.2500;
	points[52] = (-5211.6929, 5788.7798, 216.5945);
	angles[52] = (0, -68.8546, 0);
	at[52] = 20.5000;
	points[53] = (-4958.7402, 5872.2441, 209.9142);
	angles[53] = (0, -72.2201, 0);
	at[53] = 21.5000;
	points[54] = (-4832.1260, 5914.6851, 206.4075);
	angles[54] = (0, -70.6755, 0);
	at[54] = 22;
	points[55] = (-4770.2759, 5938.6611, 204.8618);
	angles[55] = (0, -67.9041, 0);
	at[55] = 22.2500;
	points[56] = (-4713.9766, 5970.4331, 204.0268);
	angles[56] = (0, -56.6680, 0);
	at[56] = 22.5000;
	points[57] = (-4663.6221, 6014.0552, 204.0681);
	angles[57] = (0, -47.7873, 0);
	at[57] = 22.7500;
	points[58] = (-4616.8896, 6061.9688, 204.4886);
	angles[58] = (0, -43.4304, 0);
	at[58] = 23;
	points[59] = (-4573.5039, 6112.5591, 205.2126);
	angles[59] = (0, -39.7659, 0);
	at[59] = 23.2500;
	points[60] = (-4534.2124, 6165.8267, 206.3004);
	angles[60] = (0, -35.1109, 0);
	at[60] = 23.5000;
	points[61] = (-4502.4805, 6224.3311, 208.0992);
	angles[61] = (0, -25.0148, 0);
	at[61] = 23.7500;
	points[62] = (-4503.0708, 6288.0317, 212.0347);
	angles[62] = (0, 9.0218, 0);
	at[62] = 24;
	points[63] = (-4525.9844, 6351.1816, 217.2543);
	angles[63] = (0, 21.2844, 0);
	at[63] = 24.2500;
	points[64] = (-4553.9370, 6411.0234, 222.5228);
	angles[64] = (0, 25.8536, 0);
	at[64] = 24.5000;
	points[65] = (-4585.6299, 6469.5278, 227.8563);
	angles[65] = (0, 29.2139, 0);
	at[65] = 24.7500;
	points[66] = (-4620.6299, 6525.8662, 233.1516);
	angles[66] = (0, 32.7513, 0);
	at[66] = 25;
	points[67] = (-4660.1182, 6579.5669, 238.3697);
	angles[67] = (0, 37.7114, 0);
	at[67] = 25.2500;
	points[68] = (-4706.6143, 6626.3779, 243.2102);
	angles[68] = (0, 48.3332, 0);
	at[68] = 25.5000;
	points[69] = (-4762.0078, 6658.7793, 247.0350);
	angles[69] = (0, 61.3343, 0);
	at[69] = 25.7500;
	points[70] = (-4945.6694, 6739.4492, 257.5244);
	angles[70] = (0, 67.9570, 0);
	at[70] = 26.5000;
	points[71] = (-5132.7168, 6809.5669, 267.5177);
	angles[71] = (0, 70.4395, 0);
	at[71] = 27.2500;
	points[72] = (-5258.2285, 6851.1416, 274.1299);
	angles[72] = (0, 72.5358, 0);
	at[72] = 27.7500;
	points[73] = (-5321.9292, 6869.5669, 277.5059);
	angles[73] = (0, 74.4518, 0);
	at[73] = 28;
	points[74] = (-5384.9604, 6883.5430, 280.9362);
	angles[74] = (0, 79.0906, 0);
	at[74] = 28.2500;
	points[75] = (-5517.4014, 6897.7949, 288.6665);
	angles[75] = (0, 85.3266, 0);
	at[75] = 28.7500;
	points[76] = (-5717.0474, 6907.7949, 300.4177);
	angles[76] = (0, 88.1549, 0);
	at[76] = 29.5000;
	points[77] = (-5850.2358, 6909.8423, 308.0264);
	angles[77] = (0, 89.7095, 0);
	at[77] = 30;
	points[78] = (-5983.3857, 6907.5986, 315.2055);
	angles[78] = (0, 91.8375, 0);
	at[78] = 30.5000;
	points[79] = (-6116.2598, 6897.0083, 321.2626);
	angles[79] = (0, 97.0950, 0);
	at[79] = 31;
	points[80] = (-6179.0552, 6884.0552, 322.8839);
	angles[80] = (0, 102.6536, 0);
	at[80] = 31.2500;
	points[81] = (-6306.4175, 6848.4253, 324.5654);
	angles[81] = (0, 106.6087, 0);
	at[81] = 31.7500;
	points[82] = (-6434.1338, 6807.7168, 325.5866);
	angles[82] = (0, 108.1924, 0);
	at[82] = 32.2500;
	points[83] = (-6685.6689, 6718.4253, 327.1212);
	angles[83] = (0, 110.6093, 0);
	at[83] = 33.2500;
	points[84] = (-6870.8267, 6642.5200, 328.7067);
	angles[84] = (0, 113.9988, 0);
	at[84] = 34;
	points[85] = (-6930.5122, 6612.9922, 329.7276);
	angles[85] = (0, 117.4651, 0);
	at[85] = 34.2500;
	points[86] = (-6984.7637, 6578.1890, 331.5382);
	angles[86] = (0, 123.9426, 0);
	at[86] = 34.5000;
	points[87] = (-7037.8350, 6538.2681, 333.8768);
	angles[87] = (0, 127.5174, 0);
	at[87] = 34.7500;
	points[88] = (-7139.2124, 6453.2676, 339.0910);
	angles[88] = (0, 131.0812, 0);
	at[88] = 35.2500;
	points[89] = (-7237.2441, 6362.8345, 344.7110);
	angles[89] = (0, 133.5996, 0);
	at[89] = 35.7500;
	points[90] = (-7330.7480, 6268.3857, 350.4949);
	angles[90] = (0, 136.3735, 0);
	at[90] = 36.2500;
	points[91] = (-7418.2676, 6167.4409, 356.3689);
	angles[91] = (0, 141.1790, 0);
	at[91] = 36.7500;
	points[92] = (-7455.9844, 6113.3857, 359.2067);
	angles[92] = (0, 146.9352, 0);
	at[92] = 37;
	points[93] = (-7485.0391, 6054.8428, 361.9909);
	angles[93] = (0, 154.8582, 0);
	at[93] = 37.2500;
	points[94] = (-7555.2759, 5869.1343, 370.6213);
	angles[94] = (0, 160.9206, 0);
	at[94] = 38;
	points[95] = (-7615.6299, 5678.3462, 379.1165);
	angles[95] = (0, 163.4342, 0);
	at[95] = 38.7500;
	points[96] = (-7667.1260, 5485.7480, 387.0705);
	angles[96] = (0, 166.3671, 0);
	at[96] = 39.5000;
	points[97] = (-7693.4253, 5353.8188, 391.7197);
	angles[97] = (0, 170.6768, 0);
	at[97] = 40;
	points[98] = (-7699.1733, 5287.7163, 393.2996);
	angles[98] = (0, 177.4167, 0);
	at[98] = 40.2500;
	points[99] = (-7686.8506, 5225.3545, 393.0949);
	angles[99] = (0, 195, 0);
	at[99] = 40.5000;
	points[100] = (-7660.8271, 5164.4092, 391.6787);
	angles[100] = (0, 204.6218, 0);
	at[100] = 40.7500;
	points[101] = (-7629.0156, 5105.7480, 389.7110);
	angles[101] = (0, 209.3277, 0);
	at[101] = 41;
	points[102] = (-7556.8901, 4993.7798, 384.8744);
	angles[102] = (0, 214.3552, 0);
	at[102] = 41.5000;
	points[103] = (-7477.6382, 4886.6143, 379.1540);
	angles[103] = (0, 217.6038, 0);
	at[103] = 42;
	points[104] = (-7392.7559, 4784.4487, 372.4122);
	angles[104] = (0, 221.2225, 0);
	at[104] = 42.5000;
	points[105] = (-7347.4805, 4738.6616, 368.0835);
	angles[105] = (0, 227.1053, 0);
	at[105] = 42.7500;
	points[106] = (-7292.2837, 4700.3149, 361.5606);
	angles[106] = (0, 236.7742, 0);
	at[106] = 43;
	points[107] = (-7176.4961, 4637.0864, 346.9197);
	angles[107] = (0, 242.8607, 0);
	at[107] = 43.5000;
	points[108] = (-6938.5435, 4521.8506, 317.2906);
	angles[108] = (0, 243.5651, 0);
	at[108] = 44.5000;
	points[109] = (-6882.0864, 4491.3779, 311.4646);
	angles[109] = (0, 241.1367, 0);
	at[109] = 44.7500;
	points[110] = (-6532.5195, 4296.9292, 282.5394);
	angles[110] = (0, 239.9781, 0);
	at[110] = 46.2500;
	points[111] = (-6418.5435, 4227.8740, 274.1244);
	angles[111] = (0, 237.7819, 0);
	at[111] = 46.7500;
	points[112] = (-6363.3467, 4190.0786, 270.4988);
	angles[112] = (0, 234.5718, 0);
	at[112] = 47;
	points[113] = (-6315.4722, 4147.4019, 268.3351);
	angles[113] = (0, 226.4021, 0);
	at[113] = 47.2500;
	points[114] = (-6270.5513, 4098.8584, 267.1618);
	angles[114] = (0, 222.1673, 0);
	at[114] = 47.5000;
	points[115] = (-6184.4097, 3997.0081, 265.8563);
	angles[115] = (0, 219.5955, 0);
	at[115] = 48;
	points[116] = (-6014.8032, 3791.8701, 264.3500);
	angles[116] = (0, 220.6069, 0);
	at[116] = 49;
	points[117] = (-5969.6855, 3741.9568, 263.7807);
	angles[117] = (0, 222.8072, 0);
	at[117] = 49.2500;
	points[118] = (-5924.0547, 3698.3899, 262.8362);
	angles[118] = (0, 227.3944, 0);
	at[118] = 49.5000;
	points[119] = (-5667.3623, 3484.4175, 256.1969);
	angles[119] = (0, 231.1473, 0);
	at[119] = 50.7500;
	points[120] = (-5510.5903, 3361.0237, 252.0138);
	angles[120] = (0, 232.3234, 0);
	at[120] = 51.5000;
	points[121] = (-5403.0317, 3280.6262, 249.1563);
	angles[121] = (0, 233.9488, 0);
	at[121] = 52;
	points[122] = (-5348.8188, 3243.3506, 247.7449);
	angles[122] = (0, 236.3225, 0);
	at[122] = 52.2500;
	points[123] = (-5292.7163, 3211.1890, 246.3122);
	angles[123] = (0, 241.1212, 0);
	at[123] = 52.5000;
	points[124] = (-5112.4409, 3124.4961, 241.7083);
	angles[124] = (0, 245.4644, 0);
	at[124] = 53.2500;
	points[125] = (-4503.7007, 2858.5474, 229.4484);
	angles[125] = (0, 246.6337, 0);
	at[125] = 55.7500;
	points[126] = (-4318.5039, 2781.3740, 227.2031);
	angles[126] = (0, 248.3397, 0);
	at[126] = 56.5000;
	points[127] = (-4270.3545, 2764.0276, 226.5961);
	angles[127] = (0, 251.1759, 0);
	at[127] = 56.7000;
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
	points[0] = (-1173.1536, 4398.9370, 212.0591);
	angles[0] = (0, 30.5642, 0);
	at[0] = 0;
	points[1] = (-1205.3818, 4427.8350, 212.4063);
	angles[1] = (0, 48.8450, 0);
	at[1] = 0.1667;
	points[2] = (-1242.6378, 4452.2832, 212.8425);
	angles[2] = (0, 56.8015, 0);
	at[2] = 0.3333;
	points[3] = (-1360.2008, 4515.5513, 214.3673);
	angles[3] = (0, 63.1061, 0);
	at[3] = 0.8333;
	points[4] = (-1519.8779, 4593.6616, 216.9323);
	angles[4] = (0, 63.7301, 0);
	at[4] = 1.5000;
	points[5] = (-1597.7047, 4635.6694, 218.7914);
	angles[5] = (0, 59.6184, 0);
	at[5] = 1.8333;
	points[6] = (-1817.2323, 4784.4487, 229.2004);
	angles[6] = (0, 54.7699, 0);
	at[6] = 2.8333;
	points[7] = (-1959.1693, 4891.1812, 237.1823);
	angles[7] = (0, 51.4049, 0);
	at[7] = 3.5000;
	points[8] = (-2023.3740, 4948.8584, 241.3374);
	angles[8] = (0, 45.6790, 0);
	at[8] = 3.8333;
	points[9] = (-2112.5630, 5047.4409, 248.6555);
	angles[9] = (0, 41.2298, 0);
	at[9] = 4.3333;
	points[10] = (-2254.9094, 5218.2681, 261.2780);
	angles[10] = (0, 38.8347, 0);
	at[10] = 5.1667;
	points[11] = (-2362.9136, 5359.4883, 271.0130);
	angles[11] = (0, 36.2097, 0);
	at[11] = 5.8333;
	points[12] = (-2436.5552, 5470.8667, 277.5260);
	angles[12] = (0, 31.0468, 0);
	at[12] = 6.3333;
	points[13] = (-2454.8818, 5506.5752, 279.0492);
	angles[13] = (0, 26.3896, 0);
	at[13] = 6.5000;
	points[14] = (-2486.8149, 5589.5278, 281.6685);
	angles[14] = (0, 19.7898, 0);
	at[14] = 6.8333;
	points[15] = (-2553.4487, 5802.6772, 287.0390);
	angles[15] = (0, 16.4393, 0);
	at[15] = 7.6667;
	points[16] = (-2688.6851, 6272.2046, 296.3784);
	angles[16] = (0, 17.1743, 0);
	at[16] = 9.5000;
	points[17] = (-2717.1299, 6353.6221, 297.1689);
	angles[17] = (0, 19.9845, 0);
	at[17] = 9.8333;
	points[18] = (-2780.0947, 6519.6855, 296.5189);
	angles[18] = (0, 21.2744, 0);
	at[18] = 10.5000;
	points[19] = (-2847.6614, 6683.9761, 294.9642);
	angles[19] = (0, 23.2731, 0);
	at[19] = 11.1667;
	points[20] = (-2904.1538, 6804.4097, 293.6729);
	angles[20] = (0, 26.6391, 0);
	at[20] = 11.6667;
	points[21] = (-2949.9568, 6881.3384, 292.9839);
	angles[21] = (0, 33.8338, 0);
	at[21] = 12;
	points[22] = (-2977.8032, 6912.5200, 292.9024);
	angles[22] = (0, 42.4261, 0);
	at[22] = 12.1667;
	points[23] = (-3044.7520, 6970.9058, 293.0051);
	angles[23] = (0, 50.4162, 0);
	at[23] = 12.5000;
	points[24] = (-3115.5828, 7024.8823, 293.2094);
	angles[24] = (0, 53.4333, 0);
	at[24] = 12.8333;
	points[25] = (-3262.9487, 7124.5674, 293.6331);
	angles[25] = (0, 57.5505, 0);
	at[25] = 13.5000;
	points[26] = (-3379.0986, 7190.8662, 293.7535);
	angles[26] = (0, 62.4741, 0);
	at[26] = 14;
	points[27] = (-3419.6497, 7209.0156, 293.6488);
	angles[27] = (0, 66.6010, 0);
	at[27] = 14.1667;
	points[28] = (-3460.2363, 7218.5830, 293.2811);
	angles[28] = (0, 79.5482, 0);
	at[28] = 14.3333;
	points[29] = (-3504.7795, 7216.1812, 292.6469);
	angles[29] = (0, 93.6275, 0);
	at[29] = 14.5000;
	points[30] = (-3548.5120, 7208.1499, 291.9283);
	angles[30] = (0, 100.6003, 0);
	at[30] = 14.6667;
	points[31] = (-3676.2402, 7169.4883, 289.3969);
	angles[31] = (0, 109.3723, 0);
	at[31] = 15.1667;
	points[32] = (-3798.7166, 7117.0869, 286.1012);
	angles[32] = (0, 115.5959, 0);
	at[32] = 15.6667;
	points[33] = (-3837.6260, 7095.9844, 284.6272);
	angles[33] = (0, 119.0386, 0);
	at[33] = 15.8333;
	points[34] = (-3872.4250, 7071.2598, 282.6106);
	angles[34] = (0, 127.4208, 0);
	at[34] = 16;
	points[35] = (-3902.2007, 7038.6226, 279.5516);
	angles[35] = (0, 138.0114, 0);
	at[35] = 16.1667;
	points[36] = (-3954.0159, 6966.4966, 272.5949);
	angles[36] = (0, 145.8442, 0);
	at[36] = 16.5000;
	points[37] = (-4021.7717, 6852.1655, 261.6323);
	angles[37] = (0, 151.1742, 0);
	at[37] = 17;
	points[38] = (-4060.9451, 6772.4805, 254.2469);
	angles[38] = (0, 155.1528, 0);
	at[38] = 17.3333;
	points[39] = (-4077.7166, 6731.3784, 250.6110);
	angles[39] = (0, 158.2662, 0);
	at[39] = 17.5000;
	points[40] = (-4090.6694, 6689.2520, 247.1398);
	angles[40] = (0, 163.9885, 0);
	at[40] = 17.6667;
	points[41] = (-4095.9451, 6646.7720, 243.9602);
	angles[41] = (0, 173.4389, 0);
	at[41] = 17.8333;
	points[42] = (-4096.9688, 6559.0557, 237.5087);
	angles[42] = (0, 180.4483, 0);
	at[42] = 18.1667;
	points[43] = (-4088.7007, 6381.4175, 224.9335);
	angles[43] = (0, 183.6043, 0);
	at[43] = 18.8333;
	points[44] = (-4074.6458, 6204.3701, 213.4697);
	angles[44] = (0, 185.1181, 0);
	at[44] = 19.5000;
	points[45] = (-4060.4727, 6071.1021, 207.1000);
	angles[45] = (0, 186.9319, 0);
	at[45] = 20;
	points[46] = (-4046.2600, 5986.0635, 211.2921);
	angles[46] = (0, 190.5353, 0);
	at[46] = 20.3333;
	points[47] = (-4025.8267, 5900.4331, 222.2016);
	angles[47] = (0, 194.8519, 0);
	at[47] = 20.6667;
	points[48] = (-3997.0081, 5817.4409, 234.4713);
	angles[48] = (0, 201.4056, 0);
	at[48] = 21;
	points[49] = (-3977.8740, 5777.7954, 239.8205);
	angles[49] = (0, 206.4422, 0);
	at[49] = 21.1667;
	points[50] = (-3954.5669, 5741.4175, 243.5398);
	angles[50] = (0, 213.7871, 0);
	at[50] = 21.3333;
	points[51] = (-3925.8149, 5707.9922, 245.8740);
	angles[51] = (0, 220.7638, 0);
	at[51] = 21.5000;
	points[52] = (-3864.7363, 5644.8032, 249.7933);
	angles[52] = (0, 224.6131, 0);
	at[52] = 21.8333;
	points[53] = (-3479.8228, 5273.5435, 269.0772);
	angles[53] = (0, 225.3683, 0);
	at[53] = 23.8333;
	points[54] = (-3451.3149, 5244.0942, 270.0795);
	angles[54] = (0, 223.8341, 0);
	at[54] = 24;
	points[55] = (-3391.0588, 5178.3076, 271.2292);
	angles[55] = (0, 222.1736, 0);
	at[55] = 24.3333;
	points[56] = (-3128.4373, 4876.2207, 271.7579);
	angles[56] = (0, 219.9322, 0);
	at[56] = 25.8333;
	points[57] = (-3022.0708, 4736.3389, 269.8468);
	angles[57] = (0, 216.4172, 0);
	at[57] = 26.5000;
	points[58] = (-2861.4214, 4523.5039, 265.4197);
	angles[58] = (0, 218.7924, 0);
	at[58] = 27.5000;
	points[59] = (-2834, 4491.8896, 264.5264);
	angles[59] = (0, 221.3065, 0);
	at[59] = 27.6667;
	points[60] = (-2711.0159, 4362.5981, 259.9598);
	angles[60] = (0, 224.1792, 0);
	at[60] = 28.3333;
	points[61] = (-2553.8936, 4205.3545, 253.8618);
	angles[61] = (0, 225.6535, 0);
	at[61] = 29.1667;
	points[62] = (-2457.1575, 4115.6299, 250.0591);
	angles[62] = (0, 228.9736, 0);
	at[62] = 29.6667;
	points[63] = (-2387.3269, 4061.5356, 247.2488);
	angles[63] = (0, 233.0429, 0);
	at[63] = 30;
	points[64] = (-2278.9922, 3984.1731, 242.8284);
	angles[64] = (0, 235.0977, 0);
	at[64] = 30.5000;
	points[65] = (-2092.9133, 3863.2283, 235.2823);
	angles[65] = (0, 239.0365, 0);
	at[65] = 31.3333;
	points[66] = (-2015.0867, 3824.1143, 232.2335);
	angles[66] = (0, 245.5388, 0);
	at[66] = 31.6667;
	points[67] = (-1849.7284, 3758.9763, 225.7685);
	angles[67] = (0, 249.5056, 0);
	at[67] = 32.3333;
	points[68] = (-1682, 3700.0945, 219.4480);
	angles[68] = (0, 251.5162, 0);
	at[68] = 33;
	points[69] = (-1597.9331, 3674.1458, 216.5598);
	angles[69] = (0, 253.7417, 0);
	at[69] = 33.3333;
	points[70] = (-1555.6969, 3664.2598, 215.4252);
	angles[70] = (0, 257.8135, 0);
	at[70] = 33.5000;
	points[71] = (-1467.0393, 3654.2126, 214.3752);
	angles[71] = (0, 265.0299, 0);
	at[71] = 33.8333;
	points[72] = (-1334.0708, 3650.9727, 213.7807);
	angles[72] = (0, 270.7438, 0);
	at[72] = 34.3333;
	points[73] = (-1245.1102, 3659.4724, 213.6138);
	angles[73] = (0, 278.7134, 0);
	at[73] = 34.6667;
	points[74] = (-1206.2756, 3675.7913, 213.5248);
	angles[74] = (0, 298.1967, 0);
	at[74] = 34.8333;
	points[75] = (-1178.9135, 3711.1262, 213.5299);
	angles[75] = (0, 322.4180, 0);
	at[75] = 35;
	points[76] = (-1157.6890, 3749.9763, 213.5917);
	angles[76] = (0, 331.3965, 0);
	at[76] = 35.1667;
	points[77] = (-1139.2245, 3790.4961, 213.6701);
	angles[77] = (0, 335.7009, 0);
	at[77] = 35.3333;
	points[78] = (-1108.5039, 3873.8425, 213.8256);
	angles[78] = (0, 341.3817, 0);
	at[78] = 35.6667;
	points[79] = (-1096.3701, 3916.6299, 213.8799);
	angles[79] = (0, 344.5999, 0);
	at[79] = 35.8333;
	points[80] = (-1088.0394, 3960.6299, 213.8823);
	angles[80] = (0, 350.3675, 0);
	at[80] = 36;
	points[81] = (-1087.7008, 4003.3464, 213.7374);
	angles[81] = (0, 359.9814, 0);
	at[81] = 36.1667;
	points[82] = (-1090.9095, 4047.5591, 213.5059);
	angles[82] = (0, 364.1753, 0);
	at[82] = 36.3333;
	points[83] = (-1101.5157, 4136.1416, 213);
	angles[83] = (0, 367.6683, 0);
	at[83] = 36.6667;
	points[84] = (-1116.2875, 4223.7007, 212.5150);
	angles[84] = (0, 370.4396, 0);
	at[84] = 37;
	points[85] = (-1136.4528, 4310.5513, 212.1169);
	angles[85] = (0, 374.5056, 0);
	at[85] = 37.3333;
	points[86] = (-1150.0237, 4353.0317, 211.9972);
	angles[86] = (0, 378.3126, 0);
	at[86] = 37.5000;
	points[87] = (-1173.1536, 4398.9370, 212.0591);
	angles[87] = (0, 390.5642, 0);
	at[87] = 37.7000;
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
	points[0] = (4926.4175, 3709.4292, 447.6811);
	angles[0] = (0, -56.3036, 0);
	at[0] = 0;
	points[1] = (4967.2441, 3742.6614, 452.3780);
	angles[1] = (0, -50.0804, 0);
	at[1] = 0.2000;
	points[2] = (5025.5122, 3797.0750, 459.3071);
	angles[2] = (0, -46.3017, 0);
	at[2] = 0.5000;
	points[3] = (5175.0791, 3947.9922, 477.9055);
	angles[3] = (0, -44.7312, 0);
	at[3] = 1.3000;
	points[4] = (5270.5117, 4038.5042, 491.1614);
	angles[4] = (0, -46.3804, 0);
	at[4] = 1.8000;
	points[5] = (5326.6934, 4094.8032, 499.6378);
	angles[5] = (0, -44.1104, 0);
	at[5] = 2.1000;
	points[6] = (5361.5752, 4134.5669, 505.5473);
	angles[6] = (0, -40.2838, 0);
	at[6] = 2.3000;
	points[7] = (5404.8032, 4199.9609, 515.0197);
	angles[7] = (0, -32.1277, 0);
	at[7] = 2.6000;
	points[8] = (5471.3784, 4314.0552, 531.4921);
	angles[8] = (0, -29.5283, 0);
	at[8] = 3.1000;
	points[9] = (5521.7324, 4407.3623, 544.8268);
	angles[9] = (0, -27.6541, 0);
	at[9] = 3.5000;
	points[10] = (5566.8110, 4502.6772, 558.1457);
	angles[10] = (0, -23.4809, 0);
	at[10] = 3.9000;
	points[11] = (5576.2993, 4528.0317, 561.5630);
	angles[11] = (0, -20.7147, 0);
	at[11] = 4;
	points[12] = (5587.5591, 4577.5986, 567.8386);
	angles[12] = (0, -11.6126, 0);
	at[12] = 4.2000;
	points[13] = (5604.8818, 4735.5903, 586.8032);
	angles[13] = (0, -4.8420, 0);
	at[13] = 4.8000;
	points[14] = (5622.5195, 5024.9214, 621.6496);
	angles[14] = (0, -3.0331, 0);
	at[14] = 5.9000;
	points[15] = (5625.5908, 5236.0630, 650.6693);
	angles[15] = (0, -0.2445, 0);
	at[15] = 6.7000;
	points[16] = (5627.9136, 5420.1973, 677.1417);
	angles[16] = (0, -2.3903, 0);
	at[16] = 7.4000;
	points[17] = (5632.1655, 5445.9448, 681.5315);
	angles[17] = (0, -8.8594, 0);
	at[17] = 7.5000;
	points[18] = (5649.0156, 5495.3545, 691.5709);
	angles[18] = (0, -19.4000, 0);
	at[18] = 7.7000;
	points[19] = (5657.5591, 5520.0396, 696.8622);
	angles[19] = (0, -18.5270, 0);
	at[19] = 7.8000;
	points[20] = (5661.8896, 5545.6694, 701.9764);
	angles[20] = (0, -9.4526, 0);
	at[20] = 7.9000;
	points[21] = (5655.2363, 5570.2358, 705.7480);
	angles[21] = (0, 12.0763, 0);
	at[21] = 8;
	points[22] = (5642.4409, 5593.7798, 708.7166);
	angles[22] = (0, 24.7835, 0);
	at[22] = 8.1000;
	points[23] = (5628.6221, 5616.4175, 711.4410);
	angles[23] = (0, 29.8400, 0);
	at[23] = 8.2000;
	points[24] = (5569.0161, 5704.2124, 721.5236);
	angles[24] = (0, 35.3796, 0);
	at[24] = 8.6000;
	points[25] = (5519.2915, 5766.9292, 728.3740);
	angles[25] = (0, 40.5961, 0);
	at[25] = 8.9000;
	points[26] = (5499.6455, 5783.0317, 729.8898);
	angles[26] = (0, 49.8087, 0);
	at[26] = 9;
	points[27] = (5452.7163, 5807.9922, 731.6339);
	angles[27] = (0, 62.7403, 0);
	at[27] = 9.2000;
	points[28] = (5378.7798, 5838.6221, 733.0906);
	angles[28] = (0, 68.5538, 0);
	at[28] = 9.5000;
	points[29] = (5328.6616, 5855.4331, 733.2795);
	angles[29] = (0, 73.1235, 0);
	at[29] = 9.7000;
	points[30] = (5249.3306, 5863.3071, 729.6614);
	angles[30] = (0, 87.5667, 0);
	at[30] = 10;
	points[31] = (5223.7012, 5859.1343, 727.0040);
	angles[31] = (0, 100.3790, 0);
	at[31] = 10.1000;
	points[32] = (5203.2285, 5843.1099, 722.0551);
	angles[32] = (0, 122.8566, 0);
	at[32] = 10.2000;
	points[33] = (5187.0864, 5822.7168, 716.3779);
	angles[33] = (0, 138.4742, 0);
	at[33] = 10.3000;
	points[34] = (5178.7007, 5798.8584, 710.2559);
	angles[34] = (0, 158.5773, 0);
	at[34] = 10.4000;
	points[35] = (5177.7168, 5772.9526, 703.9606);
	angles[35] = (0, 173.3564, 0);
	at[35] = 10.5000;
	points[36] = (5178.6611, 5721.1807, 691.5670);
	angles[36] = (0, 180.9199, 0);
	at[36] = 10.7000;
	points[37] = (5188.7007, 5488.2285, 638.7126);
	angles[37] = (0, 182.7348, 0);
	at[37] = 11.6000;
	points[38] = (5193.3462, 5305.3940, 598.9724);
	angles[38] = (0, 179.3548, 0);
	at[38] = 12.3000;
	points[39] = (5182.5986, 5176.6138, 574.6693);
	angles[39] = (0, 174.2113, 0);
	at[39] = 12.8000;
	points[40] = (5169.4878, 5072.4019, 555.9174);
	angles[40] = (0, 172.0463, 0);
	at[40] = 13.2000;
	points[41] = (5150.3545, 4969.0942, 537.7756);
	angles[41] = (0, 167.6154, 0);
	at[41] = 13.6000;
	points[42] = (5135.5908, 4921.0239, 529.6181);
	angles[42] = (0, 161.3013, 0);
	at[42] = 13.8000;
	points[43] = (5103.5039, 4847.8740, 517.5630);
	angles[43] = (0, 155.5229, 0);
	at[43] = 14.1000;
	points[44] = (5045.8267, 4729.2129, 498.2953);
	angles[44] = (0, 153.5791, 0);
	at[44] = 14.6000;
	points[45] = (4898.9766, 4448.7007, 454.7599);
	angles[45] = (0, 150.9778, 0);
	at[45] = 15.8000;
	points[46] = (4872.2046, 4404.6851, 449.1654);
	angles[46] = (0, 148.2493, 0);
	at[46] = 16;
	points[47] = (4768.6616, 4250.1577, 431.8701);
	angles[47] = (0, 145.7336, 0);
	at[47] = 16.7000;
	points[48] = (4665.3936, 4095.0393, 416.6614);
	angles[48] = (0, 147.4589, 0);
	at[48] = 17.4000;
	points[49] = (4639.5278, 4050.7480, 413.1378);
	angles[49] = (0, 150.6838, 0);
	at[49] = 17.6000;
	points[50] = (4560.9058, 3881.5396, 405.3189);
	angles[50] = (0, 156.2152, 0);
	at[50] = 18.3000;
	points[51] = (4480.1968, 3683.5867, 398.7047);
	angles[51] = (0, 159.6518, 0);
	at[51] = 19.1000;
	points[52] = (4465.9844, 3634.0042, 397.6614);
	angles[52] = (0, 166.7859, 0);
	at[52] = 19.3000;
	points[53] = (4467.3228, 3580.8032, 398.2402);
	angles[53] = (0, 183.9473, 0);
	at[53] = 19.5000;
	points[54] = (4482.5200, 3529.9685, 400.3150);
	angles[54] = (0, 199.6052, 0);
	at[54] = 19.7000;
	points[55] = (4497.0474, 3507.7048, 402.0906);
	angles[55] = (0, 211.9736, 0);
	at[55] = 19.8000;
	points[56] = (4519.1733, 3494.4214, 404.6260);
	angles[56] = (0, 237.2368, 0);
	at[56] = 19.9000;
	points[57] = (4543.8979, 3498.7837, 407.3032);
	angles[57] = (0, 271.8635, 0);
	at[57] = 20;
	points[58] = (4568.1104, 3508.8384, 409.8622);
	angles[58] = (0, 287.6045, 0);
	at[58] = 20.1000;
	points[59] = (4616.6143, 3532.1733, 414.9528);
	angles[59] = (0, 295.6631, 0);
	at[59] = 20.3000;
	points[60] = (4803.2285, 3634.0354, 434.5236);
	angles[60] = (0, 299.7871, 0);
	at[60] = 21.1000;
	points[61] = (4917.3623, 3703.2324, 446.6772);
	angles[61] = (0, 302.6913, 0);
	at[61] = 21.6000;
	points[62] = (4926.4175, 3709.4292, 447.6811);
	angles[62] = (0, 303.6964, 0);
	at[62] = 21.6500;
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
