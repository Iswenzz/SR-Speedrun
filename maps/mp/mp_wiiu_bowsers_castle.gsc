main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_bowsers_castle", 0);

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
	ambientPlay("iz_0_ubc", 2);
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
	level.iz_route[level.iz_route.size] = (-536, -20, 2730);
	level.iz_route[level.iz_route.size] = (621, 11, 2775);
	level.iz_route[level.iz_route.size] = (1803, 19, 2896);
	level.iz_route[level.iz_route.size] = (2861, -18, 2939);
	level.iz_route[level.iz_route.size] = (4127, 11, 2937);
	level.iz_route[level.iz_route.size] = (5292, 25, 2937);
	level.iz_route[level.iz_route.size] = (6506, 16, 2937);
	level.iz_route[level.iz_route.size] = (6562, -1699, 2873);
	level.iz_route[level.iz_route.size] = (6558, -2928, 2852);
	level.iz_route[level.iz_route.size] = (6597, -3768, 2852);
	level.iz_route[level.iz_route.size] = (7195, -4052, 2852);
	level.iz_route[level.iz_route.size] = (7986, -4037, 2853);
	level.iz_route[level.iz_route.size] = (8647, -4016, 2853);
	level.iz_route[level.iz_route.size] = (8921, -3171, 2856);
	level.iz_route[level.iz_route.size] = (8916, -2159, 2951);
	level.iz_route[level.iz_route.size] = (9060, -1135, 3195);
	level.iz_route[level.iz_route.size] = (9597, -267, 3489);
	level.iz_route[level.iz_route.size] = (10698, 112, 3791);
	level.iz_route[level.iz_route.size] = (11595, 238, 3971);
	level.iz_route[level.iz_route.size] = (11972, 683, 4145);
	level.iz_route[level.iz_route.size] = (11877, 1391, 4434);
	level.iz_route[level.iz_route.size] = (11770, 2732, 4900);
	level.iz_route[level.iz_route.size] = (11756, 3375, 5137);
	level.iz_route[level.iz_route.size] = (11780, 4741, 5666);
	level.iz_route[level.iz_route.size] = (11805, 5792, 6242);
	level.iz_route[level.iz_route.size] = (11800, 6418, 6593);
	level.iz_route[level.iz_route.size] = (10679, 6443, 6605);
	level.iz_route[level.iz_route.size] = (9638, 6458, 6616);
	level.iz_route[level.iz_route.size] = (8621, 6312, 6555);
	level.iz_route[level.iz_route.size] = (7915, 5782, 6276);
	level.iz_route[level.iz_route.size] = (7762, 4601, 5771);
	level.iz_route[level.iz_route.size] = (7832, 3391, 5584);
	level.iz_route[level.iz_route.size] = (8395, 2324, 5385);
	level.iz_route[level.iz_route.size] = (8719, 1203, 5181);
	level.iz_route[level.iz_route.size] = (9038, -88, 4944);
	level.iz_route[level.iz_route.size] = (9189, -1308, 4723);
	level.iz_route[level.iz_route.size] = (9219, -2966, 4422);
	level.iz_route[level.iz_route.size] = (9178, -4273, 4191);
	level.iz_route[level.iz_route.size] = (8994, -5580, 3910);
	level.iz_route[level.iz_route.size] = (8613, -6630, 3651);
	level.iz_route[level.iz_route.size] = (7768, -7216, 3414);
	level.iz_route[level.iz_route.size] = (6591, -7087, 3154);
	level.iz_route[level.iz_route.size] = (5226, -6680, 2895);
	level.iz_route[level.iz_route.size] = (4271, -6348, 2740);
	level.iz_route[level.iz_route.size] = (-3252, -3040, 699);
	level.iz_route[level.iz_route.size] = (-4216, -2770, 900);
	level.iz_route[level.iz_route.size] = (-5098, -2982, 1066);
	level.iz_route[level.iz_route.size] = (-5798, -3532, 1218);
	level.iz_route[level.iz_route.size] = (-6406, -4128, 1387);
	level.iz_route[level.iz_route.size] = (-7161, -4342, 1551);
	level.iz_route[level.iz_route.size] = (-7937, -3920, 1702);
	level.iz_route[level.iz_route.size] = (-8294, -3109, 1809);
	level.iz_route[level.iz_route.size] = (-8327, -2317, 1907);
	level.iz_route[level.iz_route.size] = (-7953, -1300, 1954);
	level.iz_route[level.iz_route.size] = (-7474, -751, 1999);
	level.iz_route[level.iz_route.size] = (-6760, -529, 2076);
	level.iz_route[level.iz_route.size] = (-6102, -787, 2099);
	level.iz_route[level.iz_route.size] = (-5482, -980, 2156);
	level.iz_route[level.iz_route.size] = (-4853, -839, 2255);
	level.iz_route[level.iz_route.size] = (-4222, -494, 2353);
	level.iz_route[level.iz_route.size] = (-3449, -131, 2462);
	level.iz_route[level.iz_route.size] = (-2293, -11, 2594);
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
	points[0] = (6871.7715, -5273.1104, 4999.6064);
	angles[0] = (0, 31.0225, -27.6643);
	at[0] = 0;
	points[1] = (6871.7715, -5273.1104, 4999.6064);
	angles[1] = (0, 31.0225, -27.6643);
	at[1] = 0.2000;
	points[2] = (7810.0791, -5119.8818, 4990.1577);
	angles[2] = (0, 31.0225, 72.3314);
	at[2] = 0.2000;
	points[3] = (7633.4258, -4826.1416, 4958.2681);
	angles[3] = (0, 31.0225, 81.3315);
	at[3] = 0.2500;
	points[4] = (7456.7715, -4532.4019, 4921.0630);
	angles[4] = (0, 31.0225, 90.3314);
	at[4] = 0.3000;
	points[5] = (7280.1182, -4238.6221, 4878.5435);
	angles[5] = (0, 31.0225, 99.3314);
	at[5] = 0.3500;
	points[6] = (7103.4253, -3944.8818, 4830.7085);
	angles[6] = (0, 31.0225, 108.3313);
	at[6] = 0.4000;
	points[7] = (6926.7720, -3651.1377, 4777.5591);
	angles[7] = (0, 31.0225, 117.3312);
	at[7] = 0.4500;
	points[8] = (6750.1182, -3357.3860, 4719.0942);
	angles[8] = (0, 31.0225, 126.3312);
	at[8] = 0.5000;
	points[9] = (6573.4648, -3063.6377, 4658.0317);
	angles[9] = (0, 31.0225, 142.3312);
	at[9] = 0.5500;
	points[10] = (6578.3071, -2873.4763, 4686.8110);
	angles[10] = (0, 31.0225, 172.3312);
	at[10] = 0.6000;
	points[11] = (6620.4727, -2409.1062, 4762.2046);
	angles[11] = (0, 31.0225, 292.3312);
	at[11] = 0.8000;
	points[12] = (6641.5356, -2176.9175, 4802.5986);
	angles[12] = (0, 31.0225, 352.3312);
	at[12] = 0.9000;
	points[13] = (6657.5596, -2061.7717, 4843.1890);
	angles[13] = (0, 31.0224, 382.3312);
	at[13] = 0.9500;
	points[14] = (6680.9844, -1947.8938, 4889.2520);
	angles[14] = (0, 31.0225, 412.3312);
	at[14] = 1;
	points[15] = (6704.4097, -1834.0197, 4930);
	angles[15] = (0, 31.0225, 442.3312);
	at[15] = 1.0500;
	points[16] = (6727.8345, -1720.1417, 4965.4331);
	angles[16] = (0, 31.0225, 472.3312);
	at[16] = 1.1000;
	points[17] = (6751.2598, -1606.2638, 4995.5513);
	angles[17] = (0, 31.0225, 502.3312);
	at[17] = 1.1500;
	points[18] = (6774.6851, -1492.3898, 5020.3545);
	angles[18] = (0, 31.0225, 532.3311);
	at[18] = 1.2000;
	points[19] = (6798.1104, -1378.5117, 5039.8423);
	angles[19] = (0, 31.0224, 562.3312);
	at[19] = 1.2500;
	points[20] = (6821.5356, -1264.6378, 5054.0156);
	angles[20] = (0, 31.0225, 592.3314);
	at[20] = 1.3000;
	points[21] = (6844.9609, -1150.7599, 5077.6377);
	angles[21] = (0, 31.0225, 622.3314);
	at[21] = 1.3500;
	points[22] = (6863.9766, -1036.4489, 5125.4722);
	angles[22] = (0, 31.0225, 652.3316);
	at[22] = 1.4000;
	points[23] = (6883.8188, -922.2244, 5167.9922);
	angles[23] = (0, 31.0225, 682.3318);
	at[23] = 1.4500;
	points[24] = (6903.7012, -808, 5205.1973);
	angles[24] = (0, 31.0225, 712.3320);
	at[24] = 1.5000;
	points[25] = (6923.5825, -693.7756, 5237.0869);
	angles[25] = (0, 31.0225, 742.3321);
	at[25] = 1.5500;
	points[26] = (6943.4644, -579.5472, 5263.6616);
	angles[26] = (0, 31.0225, 772.3324);
	at[26] = 1.6000;
	points[27] = (6963.3071, -465.3228, 5284.9214);
	angles[27] = (0, 31.0224, 802.3324);
	at[27] = 1.6500;
	points[28] = (6983.1890, -351.0984, 5300.8662);
	angles[28] = (0, 31.0225, 832.3326);
	at[28] = 1.7000;
	points[29] = (7003.0713, -236.8728, 5311.4961);
	angles[29] = (0, 31.0224, 862.3328);
	at[29] = 1.7500;
	points[30] = (7022.9136, -122.6476, 5316.8110);
	angles[30] = (0, 31.0225, 892.3330);
	at[30] = 1.8000;
	points[31] = (7042.7949, -8.4222, 5316.8110);
	angles[31] = (0, 31.0225, 922.3331);
	at[31] = 1.8500;
	points[32] = (7062.6772, 105.8032, 5311.4961);
	angles[32] = (0, 31.0225, 952.3333);
	at[32] = 1.9000;
	points[33] = (7082.5195, 220.0287, 5300.8662);
	angles[33] = (0, 31.0225, 982.3334);
	at[33] = 1.9500;
	points[34] = (7102.4019, 334.2540, 5284.9214);
	angles[34] = (0, 31.0225, 1012.3336);
	at[34] = 2;
	points[35] = (7122.2837, 448.4803, 5315.5908);
	angles[35] = (0, 31.0225, 1042.3336);
	at[35] = 2.0500;
	points[36] = (7138.1104, 563.3464, 5363.4253);
	angles[36] = (0, 31.0225, 1072.3339);
	at[36] = 2.1000;
	points[37] = (7154.6851, 678.0984, 5405.9453);
	angles[37] = (0, 31.0224, 1102.3341);
	at[37] = 2.1500;
	points[38] = (7171.2598, 792.8503, 5443.1494);
	angles[38] = (0, 31.0225, 1132.3342);
	at[38] = 2.2000;
	points[39] = (7187.7954, 907.6024, 5475.0391);
	angles[39] = (0, 31.0224, 1162.3344);
	at[39] = 2.2500;
	points[40] = (7204.3701, 1022.3544, 5501.6143);
	angles[40] = (0, 31.0225, 1192.3345);
	at[40] = 2.3000;
	points[41] = (7220.9453, 1137.1063, 5522.8745);
	angles[41] = (0, 31.0225, 1222.3347);
	at[41] = 2.3500;
	points[42] = (7237.4805, 1251.8622, 5538.8193);
	angles[42] = (0, 31.0224, 1252.3348);
	at[42] = 2.4000;
	points[43] = (7254.0557, 1366.6143, 5549.4487);
	angles[43] = (0, 31.0225, 1282.3350);
	at[43] = 2.4500;
	points[44] = (7270.6299, 1481.3662, 5554.7642);
	angles[44] = (0, 31.0224, 1312.3352);
	at[44] = 2.5000;
	points[45] = (7303.7402, 1710.8701, 5554.2520);
	angles[45] = (0, 31.0225, 1372.3354);
	at[45] = 2.6000;
	points[46] = (7320.3154, 1825.6221, 5576.2598);
	angles[46] = (0, 31.0225, 1402.3357);
	at[46] = 2.6500;
	points[47] = (7320.3154, 1825.6221, 5576.2598);
	angles[47] = (0, 31.0225, 1402.3357);
	at[47] = 2.6667;
	points[48] = (6871.7715, -5273.1104, 4999.6064);
	angles[48] = (0, 31.0225, 1412.3357);
	at[48] = 2.6667;
	points[49] = (6871.7715, -5273.1104, 4999.6064);
	angles[49] = (0, 31.0225, 1412.3357);
	at[49] = 3.5167;
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
	points[0] = (9110.1572, -5321.4961, 5050.5908);
	angles[0] = (0, -27.1247, -36.9637);
	at[0] = 0;
	points[1] = (9110.1572, -5321.4961, 5050.5908);
	angles[1] = (0, -27.1247, -36.9637);
	at[1] = 0.2000;
	points[2] = (8123.3071, -5117.4409, 5041.1416);
	angles[2] = (0, -27.1247, -206.9709);
	at[2] = 0.2000;
	points[3] = (8280.7480, -4810.1182, 5009.2520);
	angles[3] = (0, -27.1248, -197.9707);
	at[3] = 0.2500;
	points[4] = (8438.1895, -4502.7954, 4972.0474);
	angles[4] = (0, -27.1247, -188.9706);
	at[4] = 0.3000;
	points[5] = (8595.5908, -4195.4727, 4929.5273);
	angles[5] = (0, -27.1246, -179.9705);
	at[5] = 0.3500;
	points[6] = (8753.0312, -3888.1770, 4881.6929);
	angles[6] = (0, -27.1247, -170.9704);
	at[6] = 0.4000;
	points[7] = (8910.4727, -3580.8623, 4828.5435);
	angles[7] = (0, -27.1247, -161.9702);
	at[7] = 0.4500;
	points[8] = (9067.8740, -3273.5513, 4770.0791);
	angles[8] = (0, -27.1247, -152.9702);
	at[8] = 0.5000;
	points[9] = (9225.3154, -2966.2402, 4722.6377);
	angles[9] = (0, -27.1248, -136.9700);
	at[9] = 0.5500;
	points[10] = (9278.8984, -2709.0078, 4792.9526);
	angles[10] = (0, -27.1247, -106.9698);
	at[10] = 0.6000;
	points[11] = (9279.3701, -2592.8110, 4809.0552);
	angles[11] = (0, -27.1247, -76.9697);
	at[11] = 0.6500;
	points[12] = (9280.7480, -2244.2205, 4871.8901);
	angles[12] = (0, -27.1247, 13.0308);
	at[12] = 0.8000;
	points[13] = (9282.5986, -1779.4331, 4959.0156);
	angles[13] = (0, -27.1247, 133.0313);
	at[13] = 1;
	points[14] = (9277.8740, -1663.3505, 5000.2759);
	angles[14] = (0, -27.1247, 163.0316);
	at[14] = 1.0500;
	points[15] = (9267.4805, -1547.3937, 5046.3389);
	angles[15] = (0, -27.1248, 193.0317);
	at[15] = 1.1000;
	points[16] = (9257.0469, -1431.4410, 5087.0869);
	angles[16] = (0, -27.1247, 223.0319);
	at[16] = 1.1500;
	points[17] = (9246.6543, -1315.4843, 5122.5195);
	angles[17] = (0, -27.1247, 253.0320);
	at[17] = 1.2000;
	points[18] = (9236.2207, -1199.5315, 5152.6377);
	angles[18] = (0, -27.1246, 283.0322);
	at[18] = 1.2500;
	points[19] = (9225.8271, -1083.5748, 5177.4409);
	angles[19] = (0, -27.1247, 313.0324);
	at[19] = 1.3000;
	points[20] = (9215.3936, -967.6221, 5196.9292);
	angles[20] = (0, -27.1246, 343.0325);
	at[20] = 1.3500;
	points[21] = (9205, -851.6653, 5224.0947);
	angles[21] = (0, -27.1246, 373.0327);
	at[21] = 1.4000;
	points[22] = (9179.1738, -737.8110, 5271.9292);
	angles[22] = (0, -27.1246, 403.0329);
	at[22] = 1.4500;
	points[23] = (9157.0078, -623.4606, 5314.4487);
	angles[23] = (0, -27.1247, 433.0330);
	at[23] = 1.5000;
	points[24] = (9134.8428, -509.1063, 5351.6538);
	angles[24] = (0, -27.1248, 463.0331);
	at[24] = 1.5500;
	points[25] = (9112.6777, -394.7559, 5383.5435);
	angles[25] = (0, -27.1247, 493.0333);
	at[25] = 1.6000;
	points[26] = (9090.5117, -280.4016, 5410.1187);
	angles[26] = (0, -27.1247, 523.0334);
	at[26] = 1.6500;
	points[27] = (9068.3467, -166.0492, 5431.3779);
	angles[27] = (0, -27.1247, 553.0336);
	at[27] = 1.7000;
	points[28] = (9046.1807, -51.6968, 5447.3228);
	angles[28] = (0, -27.1247, 583.0338);
	at[28] = 1.7500;
	points[29] = (9023.9766, 62.6559, 5457.9531);
	angles[29] = (0, -27.1247, 613.0340);
	at[29] = 1.8000;
	points[30] = (9001.8105, 177.0083, 5463.2676);
	angles[30] = (0, -27.1247, 643.0341);
	at[30] = 1.8500;
	points[31] = (8979.6455, 291.3606, 5463.2676);
	angles[31] = (0, -27.1248, 673.0342);
	at[31] = 1.9000;
	points[32] = (8957.4805, 405.7126, 5457.9531);
	angles[32] = (0, -27.1247, 703.0344);
	at[32] = 1.9500;
	points[33] = (8932.0869, 519.2087, 5488.6616);
	angles[33] = (0, -27.1247, 733.0345);
	at[33] = 2;
	points[34] = (8903.7803, 631.9449, 5534.7246);
	angles[34] = (0, -27.1247, 763.0348);
	at[34] = 2.0500;
	points[35] = (8875.5117, 744.6851, 5575.4727);
	angles[35] = (0, -27.1247, 793.0349);
	at[35] = 2.1000;
	points[36] = (8847.2441, 857.4213, 5610.9053);
	angles[36] = (0, -27.1247, 823.0350);
	at[36] = 2.1500;
	points[37] = (8818.9375, 970.1614, 5641.0234);
	angles[37] = (0, -27.1246, 853.0352);
	at[37] = 2.2000;
	points[38] = (8790.6699, 1082.8977, 5675.2754);
	angles[38] = (0, -27.1247, 883.0354);
	at[38] = 2.2500;
	points[39] = (8759.0947, 1194.9016, 5723.1104);
	angles[39] = (0, -27.1247, 913.0355);
	at[39] = 2.3000;
	points[40] = (8728.2676, 1307.0670, 5765.6304);
	angles[40] = (0, -27.1247, 943.0358);
	at[40] = 2.3500;
	points[41] = (8697.4404, 1419.2362, 5802.8345);
	angles[41] = (0, -27.1248, 973.0358);
	at[41] = 2.4000;
	points[42] = (8666.5752, 1531.4015, 5834.7241);
	angles[42] = (0, -27.1247, 1003.0360);
	at[42] = 2.4500;
	points[43] = (8635.7480, 1643.5709, 5861.2993);
	angles[43] = (0, -27.1247, 1033.0361);
	at[43] = 2.5000;
	points[44] = (8635.7480, 1643.5709, 5861.2993);
	angles[44] = (0, -27.1247, 1033.0361);
	at[44] = 2.5167;
	points[45] = (9110.1572, -5321.4961, 5050.5908);
	angles[45] = (0, -27.1247, 1043.0363);
	at[45] = 2.5167;
	points[46] = (9110.1572, -5321.4961, 5050.5908);
	angles[46] = (0, -27.1247, 1043.0363);
	at[46] = 3.5167;
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
	points[0] = (-7414.6851, 1077.1300, 3081.7324);
	angles[0] = (0, 158.8680, -178.4669);
	at[0] = 0;
	points[1] = (-7433.2676, 1029.0315, 3124.2522);
	angles[1] = (0, 158.8680, -190.4688);
	at[1] = 0.0667;
	points[2] = (-7451.8501, 980.9291, 3157.3228);
	angles[2] = (0, 158.8680, -202.4707);
	at[2] = 0.1333;
	points[3] = (-7470.4727, 932.8307, 3180.9448);
	angles[3] = (0, 158.8680, -214.4725);
	at[3] = 0.2000;
	points[4] = (-7489.0552, 884.7323, 3195.1182);
	angles[4] = (0, 158.8680, -226.4745);
	at[4] = 0.2667;
	points[5] = (-7507.6377, 836.6299, 3199.8425);
	angles[5] = (0, 158.8680, -238.4765);
	at[5] = 0.3333;
	points[6] = (-7526.2207, 788.5315, 3195.1182);
	angles[6] = (0, 158.8680, -250.4783);
	at[6] = 0.4000;
	points[7] = (-7544.8428, 740.4291, 3180.9448);
	angles[7] = (0, 158.8680, -262.4802);
	at[7] = 0.4667;
	points[8] = (-7563.4248, 692.3307, 3157.3228);
	angles[8] = (0, 158.8680, -274.4821);
	at[8] = 0.5333;
	points[9] = (-7582.0078, 644.2323, 3124.2522);
	angles[9] = (0, 158.8680, -286.4841);
	at[9] = 0.6000;
	points[10] = (-7600.5903, 596.1299, 3081.7324);
	angles[10] = (0, 158.8680, -298.4859);
	at[10] = 0.6667;
	points[11] = (-7619.1729, 548.0315, 3029.7639);
	angles[11] = (0, 158.8680, -310.4879);
	at[11] = 0.7333;
	points[12] = (-7637.7954, 499.9331, 2968.3467);
	angles[12] = (0, 158.8680, -322.4897);
	at[12] = 0.8000;
	points[13] = (-7656.3779, 451.8307, 2897.4805);
	angles[13] = (0, 158.8681, -334.4916);
	at[13] = 0.8667;
	points[14] = (-7674.9609, 403.7323, 2817.1653);
	angles[14] = (0, 158.8680, -346.4935);
	at[14] = 0.9333;
	points[15] = (-7693.5435, 355.6315, 2727.4016);
	angles[15] = (0, 158.8680, -358.4954);
	at[15] = 1;
	points[16] = (-7712.1260, 307.5315, 2628.1890);
	angles[16] = (0, 158.8680, -370.4973);
	at[16] = 1.0667;
	points[17] = (-7730.7480, 259.4311, 2519.5276);
	angles[17] = (0, 158.8680, -382.4993);
	at[17] = 1.1333;
	points[18] = (-7749.3306, 211.3311, 2477.9448);
	angles[18] = (0, 158.8681, -401.7820);
	at[18] = 1.2000;
	points[19] = (-7767.9131, 163.2311, 2502.3938);
	angles[19] = (0, 158.8680, -423.4917);
	at[19] = 1.2667;
	points[20] = (-7786.4961, 115.1311, 2517.3938);
	angles[20] = (0, 158.8680, -445.2014);
	at[20] = 1.3333;
	points[21] = (-7805.1182, 67.0307, 2522.9451);
	angles[21] = (0, 158.8680, -466.9113);
	at[21] = 1.4000;
	points[22] = (-7823.7007, 18.9307, 2519.0471);
	angles[22] = (0, 158.8680, -488.6208);
	at[22] = 1.4667;
	points[23] = (-7842.2837, -29.1694, 2505.7007);
	angles[23] = (0, 158.8680, -510.3306);
	at[23] = 1.5333;
	points[24] = (-7860.8662, -77.2693, 2482.9055);
	angles[24] = (0, 158.8680, -532.0403);
	at[24] = 1.6000;
	points[25] = (-7879.4487, -125.3697, 2450.6614);
	angles[25] = (0, 158.8681, -553.7501);
	at[25] = 1.6667;
	points[26] = (-7898.0708, -173.4697, 2408.9685);
	angles[26] = (0, 158.8680, -575.4598);
	at[26] = 1.7333;
	points[27] = (-7916.6533, -221.5697, 2357.8269);
	angles[27] = (0, 158.8680, -597.1696);
	at[27] = 1.8000;
	points[28] = (-7953.8188, -317.7701, 2362.2126);
	angles[28] = (0, 158.8680, -648.5903);
	at[28] = 1.9333;
	points[29] = (-7972.4014, -365.8701, 2356.8857);
	angles[29] = (0, 158.8681, -674.3006);
	at[29] = 2;
	points[30] = (-7991.0239, -413.9685, 2342.1104);
	angles[30] = (0, 158.8680, -700.0110);
	at[30] = 2.0667;
	points[31] = (-8007.8350, -469.4134, 2317.8857);
	angles[31] = (0, 163.4814, -725.7214);
	at[31] = 2.1333;
	points[32] = (-8024.4888, -525.5669, 2288.3740);
	angles[32] = (0, 163.4814, -752.4319);
	at[32] = 2.2000;
	points[33] = (-8041.1416, -581.7205, 2293.6340);
	angles[33] = (0, 163.4814, -782.1428);
	at[33] = 2.2667;
	points[34] = (-8057.7954, -637.8740, 2289.4451);
	angles[34] = (0, 163.4814, -811.8539);
	at[34] = 2.3333;
	points[35] = (-8074.4492, -694.0275, 2275.8071);
	angles[35] = (0, 163.4815, -841.5648);
	at[35] = 2.4000;
	points[36] = (-8091.1025, -750.1811, 2252.7205);
	angles[36] = (0, 163.4815, -871.2759);
	at[36] = 2.4667;
	points[37] = (-8107.7559, -806.3307, 2242.3110);
	angles[37] = (0, 163.4814, -903.9873);
	at[37] = 2.5333;
	points[38] = (-8124.4097, -862.4843, 2241.0867);
	angles[38] = (0, 163.4814, -937.6990);
	at[38] = 2.6000;
	points[39] = (-8141.0635, -918.6378, 2230.4133);
	angles[39] = (0, 163.4814, -971.4106);
	at[39] = 2.6667;
	points[40] = (-8157.7163, -974.7914, 2210.2913);
	angles[40] = (0, 163.4814, -1005.1222);
	at[40] = 2.7333;
	points[41] = (-8191.0239, -1087.0985, 2202.9448);
	angles[41] = (0, 163.4815, -1080.5468);
	at[41] = 2.8667;
	points[42] = (-8207.6777, -1143.2521, 2193.4565);
	angles[42] = (0, 163.4814, -1120.2593);
	at[42] = 2.9333;
	points[43] = (-8224.3311, -1199.4055, 2189.9331);
	angles[43] = (0, 163.4814, -1161.9722);
	at[43] = 3;
	points[44] = (-8240.9844, -1255.5591, 2182.3779);
	angles[44] = (0, 163.4814, -1205.6853);
	at[44] = 3.0667;
	points[45] = (-8257.6377, -1311.7126, 2178.3542);
	angles[45] = (0, 163.4815, -1251.3989);
	at[45] = 3.1333;
	points[46] = (-8290.9453, -1424.0198, 2168.2480);
	angles[46] = (0, 163.4814, -1350.8273);
	at[46] = 3.2667;
	points[47] = (-8307.5986, -1480.1733, 2165.4883);
	angles[47] = (0, 163.4814, -1404.5421);
	at[47] = 3.3333;
	points[48] = (-8324.2520, -1536.3268, 2162);
	angles[48] = (0, 180.1969, -1461.2573);
	at[48] = 3.4000;
	points[49] = (-8321.6533, -1653.8976, 2148.2876);
	angles[49] = (0, 180.1969, -1579.6886);
	at[49] = 3.5333;
	points[50] = (-8321.4570, -1712.5237, 2142.3347);
	angles[50] = (0, 180.1969, -1641.4047);
	at[50] = 3.6000;
	points[51] = (-8321.2598, -1771.1456, 2127.9253);
	angles[51] = (0, 180.1969, -1704.1210);
	at[51] = 3.6667;
	points[52] = (-8321.0234, -1829.7717, 2127.7048);
	angles[52] = (0, 180.1969, -1769.8376);
	at[52] = 3.7333;
	points[53] = (-8320.8271, -1888.3937, 2118.0315);
	angles[53] = (0, 180.1969, -1835.5543);
	at[53] = 3.8000;
	points[54] = (-8320.6299, -1947.0197, 2108.2678);
	angles[54] = (0, 180.1969, -1903.2573);
	at[54] = 3.8667;
	points[55] = (-8320.4336, -2005.6417, 2106.0906);
	angles[55] = (0, 180.1969, -1972.9467);
	at[55] = 3.9333;
	points[56] = (-8320.2363, -2064.2678, 2094.4646);
	angles[56] = (0, 180.1969, -2042.6361);
	at[56] = 4;
	points[57] = (-8320.0391, -2122.8896, 2087.7993);
	angles[57] = (0, 180.1969, -2115.3257);
	at[57] = 4.0667;
	points[58] = (-8319.8428, -2181.5120, 2083.1338);
	angles[58] = (0, 180.1969, -2189.0159);
	at[58] = 4.1333;
	points[59] = (-8319.6455, -2240.1379, 2069.0237);
	angles[59] = (0, 180.1969, -2262.7058);
	at[59] = 4.2000;
	points[60] = (-8319.4102, -2298.7598, 2068.0081);
	angles[60] = (0, 180.1969, -2340.3965);
	at[60] = 4.2667;
	points[61] = (-8319.2129, -2357.3860, 2061.0198);
	angles[61] = (0, 180.1969, -2418.0869);
	at[61] = 4.3333;
	points[62] = (-8319.0156, -2416.0078, 2047.3466);
	angles[62] = (0, 180.1969, -2496.7778);
	at[62] = 4.4000;
	points[63] = (-8318.8193, -2474.6340, 2047.4331);
	angles[63] = (0, 180.1969, -2578.4690);
	at[63] = 4.4667;
	points[64] = (-8318.4248, -2591.8821, 2028.8977);
	angles[64] = (0, 180.1969, -2743.8518);
	at[64] = 4.6000;
	points[65] = (-8318.2285, -2650.5039, 2026.6260);
	angles[65] = (0, 180.1969, -2829.5437);
	at[65] = 4.6667;
	points[66] = (-8318.0312, -2709.1299, 2014.9055);
	angles[66] = (0, 180.1969, -2915.2356);
	at[66] = 4.7333;
	points[67] = (-8317.8350, -2767.7522, 2011.4448);
	angles[67] = (0, 180.1969, -3004.9282);
	at[67] = 4.8000;
	points[68] = (-8317.5986, -2826.3779, 2003.7402);
	angles[68] = (0, 180.1969, -3094.6206);
	at[68] = 4.8667;
	points[69] = (-8317.4014, -2885, 1994.5630);
	angles[69] = (0, 180.1969, -3186.3135);
	at[69] = 4.9333;
	points[70] = (-8317.2051, -2943.6260, 1991.7953);
	angles[70] = (0, 180.1969, -3280.0066);
	at[70] = 5;
	points[71] = (-8317.0078, -3002.2483, 1981.2795);
	angles[71] = (0, 203.5468, -3374.7000);
	at[71] = 5.0667;
	points[72] = (-8289.6064, -3055.1379, 1980.1024);
	angles[72] = (0, 203.5468, -3472.3938);
	at[72] = 5.1333;
	points[73] = (-8266.1807, -3108.8662, 1969.4764);
	angles[73] = (0, 203.5468, -3570.0874);
	at[73] = 5.2000;
	points[74] = (-8242.7559, -3162.5986, 1949.4016);
	angles[74] = (0, 203.5468, -3667.7812);
	at[74] = 5.2667;
	points[75] = (-8219.3311, -3216.3308, 1940.9685);
	angles[75] = (0, 203.5468, -3768.4756);
	at[75] = 5.3333;
	points[76] = (-8195.9453, -3270.0591, 1938.8425);
	angles[76] = (0, 203.5468, -3870.1699);
	at[76] = 5.4000;
	points[77] = (-8172.5200, -3323.7915, 1927.2677);
	angles[77] = (0, 203.5468, -3971.8643);
	at[77] = 5.4667;
	points[78] = (-8149.0947, -3377.5237, 1906.2401);
	angles[78] = (0, 203.5468, -4073.5588);
	at[78] = 5.5333;
	points[79] = (-8125.6694, -3431.2520, 1905.8149);
	angles[79] = (0, 203.5468, -4179.2539);
	at[79] = 5.6000;
	points[80] = (-8102.2837, -3484.9844, 1900.9016);
	angles[80] = (0, 203.5467, -4284.9487);
	at[80] = 5.6667;
	points[81] = (-8078.8584, -3538.7166, 1886.5433);
	angles[81] = (0, 203.5468, -4390.6440);
	at[81] = 5.7333;
	points[82] = (-8055.4331, -3592.4448, 1880.4489);
	angles[82] = (0, 203.5468, -4499.3394);
	at[82] = 5.8000;
	points[83] = (-8032.0078, -3646.1772, 1876.6104);
	angles[83] = (0, 203.5468, -4609.0352);
	at[83] = 5.8667;
	points[84] = (-8008.6226, -3699.9094, 1865.6339);
	angles[84] = (0, 203.5468, -4719.7310);
	at[84] = 5.9333;
	points[85] = (-7985.1973, -3753.6379, 1864.7795);
	angles[85] = (0, 203.5468, -4833.4272);
	at[85] = 6;
	points[86] = (-7961.7720, -3807.3701, 1855.7756);
	angles[86] = (0, 203.5468, -4948.1235);
	at[86] = 6.0667;
	points[87] = (-7938.3857, -3861.1023, 1854.0237);
	angles[87] = (0, 203.5468, -5065.8208);
	at[87] = 6.1333;
	points[88] = (-7914.9604, -3914.8308, 1850.9568);
	angles[88] = (0, 203.5468, -5186.5181);
	at[88] = 6.2000;
	points[89] = (-7891.5356, -3968.5828, 1847.5276);
	angles[89] = (0, 203.5468, -5310.2158);
	at[89] = 6.2667;
	points[90] = (-7868.1104, -4022.2834, 1844.5393);
	angles[90] = (0, 242.8691, -5437.9146);
	at[90] = 6.3333;
	points[91] = (-7815.0396, -4047.9529, 1838.3110);
	angles[91] = (0, 242.8692, -5567.6133);
	at[91] = 6.4000;
	points[92] = (-7762.9917, -4074.6064, 1822.6377);
	angles[92] = (0, 242.8691, -5697.3120);
	at[92] = 6.4667;
	points[93] = (-7710.9839, -4101.2598, 1819.0511);
	angles[93] = (0, 242.8691, -5831.0117);
	at[93] = 6.5333;
	points[94] = (-7658.9761, -4127.9136, 1812.5315);
	angles[94] = (0, 242.8691, -5964.7114);
	at[94] = 6.6000;
	points[95] = (-7606.9292, -4154.5669, 1796.5631);
	angles[95] = (0, 242.8691, -6098.4106);
	at[95] = 6.6667;
	points[96] = (-7554.9214, -4181.2207, 1781.0984);
	angles[96] = (0, 242.8691, -6234.1104);
	at[96] = 6.7333;
	points[97] = (-7502.9136, -4207.8740, 1780.8110);
	angles[97] = (0, 242.8691, -6371.8105);
	at[97] = 6.8000;
	points[98] = (-7450.8662, -4234.5273, 1771.0708);
	angles[98] = (0, 242.8692, -6509.5107);
	at[98] = 6.8667;
	points[99] = (-7398.8584, -4261.1812, 1751.8857);
	angles[99] = (0, 242.8691, -6647.2109);
	at[99] = 6.9333;
	points[100] = (-7346.8506, -4287.8350, 1748.1969);
	angles[100] = (0, 242.8691, -6788.9116);
	at[100] = 7;
	points[101] = (-7294.8032, -4314.4883, 1742.7323);
	angles[101] = (0, 242.8692, -6930.6123);
	at[101] = 7.0667;
	points[102] = (-7242.7954, -4341.1416, 1727.8229);
	angles[102] = (0, 242.8691, -7072.3130);
	at[102] = 7.1333;
	points[103] = (-7190.7871, -4367.7954, 1724.0197);
	angles[103] = (0, 242.8691, -7218.0146);
	at[103] = 7.2000;
	points[104] = (-7138.7793, -4394.4492, 1717.2716);
	angles[104] = (0, 242.8690, -7363.7158);
	at[104] = 7.2667;
	points[105] = (-7086.7324, -4421.1025, 1711.1732);
	angles[105] = (0, 242.8691, -7512.4175);
	at[105] = 7.3333;
	points[106] = (-7034.7246, -4447.7559, 1705.0472);
	angles[106] = (0, 242.8692, -7662.1196);
	at[106] = 7.4000;
	points[107] = (-6982.7163, -4474.4097, 1701.6732);
	angles[107] = (0, 242.8692, -7815.8223);
	at[107] = 7.4667;
	points[108] = (-6931.4570, -4465.8662, 1692.2914);
	angles[108] = (0, 297.9803, -7969.5249);
	at[108] = 7.5333;
	points[109] = (-6880.6304, -4438.8584, 1675.3386);
	angles[109] = (0, 297.9802, -8124.2280);
	at[109] = 7.6000;
	points[110] = (-6829.7637, -4411.8501, 1676.1458);
	angles[110] = (0, 297.9803, -8281.9316);
	at[110] = 7.6667;
	points[111] = (-6778.9370, -4384.8428, 1667.5000);
	angles[111] = (0, 297.9802, -8439.6348);
	at[111] = 7.7333;
	points[112] = (-6728.1104, -4357.8350, 1649.4095);
	angles[112] = (0, 297.9803, -8597.3379);
	at[112] = 7.8000;
	points[113] = (-6677.2832, -4330.8267, 1621.8701);
	angles[113] = (0, 297.9803, -8755.0410);
	at[113] = 7.8667;
	points[114] = (-6626.4175, -4303.8188, 1619.8425);
	angles[114] = (0, 297.9803, -8916.7451);
	at[114] = 7.9333;
	points[115] = (-6575.5908, -4276.8110, 1616.8820);
	angles[115] = (0, 297.9803, -9078.4482);
	at[115] = 8;
	points[116] = (-6524.7642, -4249.8032, 1604.4764);
	angles[116] = (0, 297.9804, -9240.1523);
	at[116] = 8.0667;
	points[117] = (-6473.8975, -4222.7954, 1582.6182);
	angles[117] = (0, 297.9803, -9401.8564);
	at[117] = 8.1333;
	points[118] = (-6423.0708, -4195.7876, 1556.8622);
	angles[118] = (0, 297.9803, -9564.5605);
	at[118] = 8.2000;
	points[119] = (-6372.2441, -4168.7798, 1561.4095);
	angles[119] = (0, 297.9803, -9730.2646);
	at[119] = 8.2667;
	points[120] = (-6321.4170, -4141.7715, 1556.5118);
	angles[120] = (0, 297.9803, -9895.9697);
	at[120] = 8.3333;
	points[121] = (-6270.5513, -4114.7637, 1542.1614);
	angles[121] = (0, 297.9802, -10061.6738);
	at[121] = 8.4000;
	points[122] = (-6219.7246, -4087.7561, 1518.3662);
	angles[122] = (0, 297.9803, -10227.3789);
	at[122] = 8.4667;
	points[123] = (-6168.8979, -4060.7480, 1499.4409);
	angles[123] = (0, 297.9803, -10395.0840);
	at[123] = 8.5333;
	points[124] = (-6118.0708, -4033.7402, 1501.5000);
	angles[124] = (0, 308.9861, -10564.7891);
	at[124] = 8.6000;
	points[125] = (-6073.9370, -3995.8662, 1494.1143);
	angles[125] = (0, 308.9861, -10734.4941);
	at[125] = 8.6667;
	points[126] = (-6028.9370, -3959.4490, 1477.2756);
	angles[126] = (0, 308.9861, -10904.1992);
	at[126] = 8.7333;
	points[127] = (-5983.9370, -3923.0396, 1450.9882);
	angles[127] = (0, 308.9861, -11073.9043);
	at[127] = 8.8000;
	points[128] = (-5938.9370, -3886.6143, 1428.8740);
	angles[128] = (0, 308.9861, -11245.6094);
	at[128] = 8.8667;
	points[129] = (-5893.9370, -3850.1929, 1431.6812);
	angles[129] = (0, 308.9861, -11419.3154);
	at[129] = 8.9333;
	points[130] = (-5848.9370, -3813.7715, 1425.0393);
	angles[130] = (0, 308.9861, -11593.0215);
	at[130] = 9;
	points[131] = (-5803.9370, -3777.3506, 1408.9489);
	angles[131] = (0, 308.9861, -11766.7275);
	at[131] = 9.0667;
	points[132] = (-5758.9370, -3740.9253, 1383.4094);
	angles[132] = (0, 308.9861, -11940.4326);
	at[132] = 9.1333;
	points[133] = (-5713.9370, -3704.5039, 1373.1417);
	angles[133] = (0, 308.9861, -12117.1396);
	at[133] = 9.2000;
	points[134] = (-5668.9370, -3668.0825, 1372.6534);
	angles[134] = (0, 308.9862, -12294.8457);
	at[134] = 9.2667;
	points[135] = (-5623.9375, -3631.6577, 1362.7166);
	angles[135] = (0, 308.9861, -12472.5518);
	at[135] = 9.3333;
	points[136] = (-5578.9370, -3595.2363, 1343.3308);
	angles[136] = (0, 308.9861, -12650.2588);
	at[136] = 9.4000;
	points[137] = (-5533.9370, -3558.8149, 1327.4646);
	angles[137] = (0, 308.9861, -12829.9658);
	at[137] = 9.4667;
	points[138] = (-5488.9375, -3522.3938, 1328.2008);
	angles[138] = (0, 308.9862, -12651.6729);
	at[138] = 9.5333;
	points[139] = (-5443.9370, -3485.9685, 1319.4921);
	angles[139] = (0, 308.9861, -12473.3799);
	at[139] = 9.6000;
	points[140] = (-5398.9370, -3449.5474, 1301.3307);
	angles[140] = (0, 308.9861, -12295.0869);
	at[140] = 9.6667;
	points[141] = (-5362.0474, -3404.4172, 1287.1615);
	angles[141] = (0, 322.3765, -12118.7939);
	at[141] = 9.7333;
	points[142] = (-5326.3389, -3358.0630, 1287.5315);
	angles[142] = (0, 322.3765, -11944.5020);
	at[142] = 9.8000;
	points[143] = (-5290.5903, -3311.7048, 1278.4528);
	angles[143] = (0, 322.3765, -11770.2090);
	at[143] = 9.8667;
	points[144] = (-5254.8818, -3265.3506, 1259.9253);
	angles[144] = (0, 322.3765, -11595.9170);
	at[144] = 9.9333;
	points[145] = (-5219.1338, -3218.9961, 1257.9882);
	angles[145] = (0, 322.3765, -11425.6250);
	at[145] = 10;
	points[146] = (-5183.4253, -3172.6377, 1252.3268);
	angles[146] = (0, 322.3765, -11255.3340);
	at[146] = 10.0667;
	points[147] = (-5147.6777, -3126.2834, 1237.2126);
	angles[147] = (0, 322.3765, -11085.0420);
	at[147] = 10.1333;
	points[148] = (-5111.9683, -3079.9253, 1231.7521);
	angles[148] = (0, 322.3764, -10917.7510);
	at[148] = 10.2000;
	points[149] = (-5076.2207, -3033.5708, 1228.1378);
	angles[149] = (0, 322.3766, -10751.4600);
	at[149] = 10.2667;
	points[150] = (-5040.5122, -2987.2126, 1215.0709);
	angles[150] = (0, 322.3765, -10585.1689);
	at[150] = 10.3333;
	points[151] = (-5004.7642, -2940.8584, 1208.6575);
	angles[151] = (0, 322.3765, -10421.8779);
	at[151] = 10.4000;
	points[152] = (-4969.0156, -2894.5000, 1204.4252);
	angles[152] = (0, 322.3765, -10259.5879);
	at[152] = 10.4667;
	points[153] = (-4933.3071, -2848.1458, 1190.7480);
	angles[153] = (0, 322.3765, -10097.2979);
	at[153] = 10.5333;
	points[154] = (-4897.5591, -2801.7874, 1187.7402);
	angles[154] = (0, 322.3765, -9939.0078);
	at[154] = 10.6000;
	points[155] = (-4856.6929, -2761.0234, 1180.6221);
	angles[155] = (0, 303.0282, -9780.7178);
	at[155] = 10.6667;
	points[156] = (-4807.6772, -2729.1538, 1164.4213);
	angles[156] = (0, 303.0282, -9623.4287);
	at[156] = 10.7333;
	points[157] = (-4758.6616, -2697.2834, 1164.5472);
	angles[157] = (0, 303.0283, -9469.1396);
	at[157] = 10.8000;
	points[158] = (-4709.6455, -2665.4094, 1155.2244);
	angles[158] = (0, 303.0283, -9314.8506);
	at[158] = 10.8667;
	points[159] = (-4660.6299, -2633.5393, 1137.3937);
	angles[159] = (0, 303.0282, -9161.5615);
	at[159] = 10.9333;
	points[160] = (-4611.5752, -2601.6653, 1138.1812);
	angles[160] = (0, 303.0283, -9011.2725);
	at[160] = 11;
	points[161] = (-4562.5591, -2569.7952, 1129.5197);
	angles[161] = (0, 303.0282, -8860.9844);
	at[161] = 11.0667;
	points[162] = (-4513.5435, -2537.9214, 1111.4135);
	angles[162] = (0, 303.0282, -8710.6953);
	at[162] = 11.1333;
	points[163] = (-4464.5278, -2506.0513, 1110.1930);
	angles[163] = (0, 303.0282, -8564.4082);
	at[163] = 11.2000;
	points[164] = (-4415.4727, -2474.1812, 1104.4055);
	angles[164] = (0, 303.0282, -8418.1201);
	at[164] = 11.2667;
	points[165] = (-4366.4565, -2442.3071, 1089.1693);
	angles[165] = (0, 303.0283, -8271.8320);
	at[165] = 11.3333;
	points[166] = (-4317.4409, -2410.4370, 1083.5906);
	angles[166] = (0, 303.0283, -8128.5449);
	at[166] = 11.4000;
	points[167] = (-4268.4253, -2378.5630, 1080.0118);
	angles[167] = (0, 303.0282, -7986.2578);
	at[167] = 11.4667;
	points[168] = (-4219.3701, -2346.6929, 1066.9843);
	angles[168] = (0, 303.0283, -7843.9707);
	at[168] = 11.5333;
	points[169] = (-4170.3545, -2314.8188, 1059.7086);
	angles[169] = (0, 303.0282, -7704.6836);
	at[169] = 11.6000;
	points[170] = (-4121.3384, -2282.9490, 1055.4685);
	angles[170] = (0, 303.0283, -7566.3970);
	at[170] = 11.6667;
	points[171] = (-4072.3228, -2251.0786, 1041.7795);
	angles[171] = (0, 303.0283, -7428.1104);
	at[171] = 11.7333;
	points[172] = (-4019.0552, -2246.0750, 1039.9213);
	angles[172] = (0, 255.9814, -7293.8242);
	at[172] = 11.8000;
	points[173] = (-3962.8347, -2260.1143, 1032.8071);
	angles[173] = (0, 255.9815, -7159.5386);
	at[173] = 11.8667;
	points[174] = (-3906.6062, -2274.1536, 1016.2441);
	angles[174] = (0, 255.9816, -7025.2524);
	at[174] = 11.9333;
	points[175] = (-3850.3779, -2288.1929, 1000.7599);
	angles[175] = (0, 255.9814, -6892.9668);
	at[175] = 12;
	points[176] = (-3794.1497, -2302.2285, 1000.6496);
	angles[176] = (0, 255.9815, -6762.6816);
	at[176] = 12.0667;
	points[177] = (-3737.9214, -2316.2676, 991.0906);
	angles[177] = (0, 255.9816, -6632.3960);
	at[177] = 12.1333;
	points[178] = (-3681.6890, -2330.3071, 972.0827);
	angles[178] = (0, 255.9814, -6502.1108);
	at[178] = 12.2000;
	points[179] = (-3625.4607, -2344.3464, 954.3976);
	angles[179] = (0, 255.9815, -6373.8257);
	at[179] = 12.2667;
	points[180] = (-3569.2324, -2358.3857, 955.0197);
	angles[180] = (0, 255.9816, -6247.5410);
	at[180] = 12.3333;
	points[181] = (-3513.0039, -2372.4253, 946.1929);
	angles[181] = (0, 255.9814, -6121.2563);
	at[181] = 12.4000;
	points[182] = (-3456.7756, -2386.4607, 927.9213);
	angles[182] = (0, 255.9815, -5994.9717);
	at[182] = 12.4667;
	points[183] = (-3400.5435, -2400.5000, 903.7598);
	angles[183] = (0, 255.9814, -5869.6875);
	at[183] = 12.5333;
	points[184] = (-3344.3152, -2414.5393, 907.2363);
	angles[184] = (0, 255.9815, -5747.4033);
	at[184] = 12.6000;
	points[185] = (-3288.0867, -2428.5789, 901.2599);
	angles[185] = (0, 255.9815, -5625.1191);
	at[185] = 12.6667;
	points[186] = (-3231.8584, -2442.6182, 885.8386);
	angles[186] = (0, 255.9815, -5502.8350);
	at[186] = 12.7333;
	points[187] = (-3175.6260, -2456.6575, 860.9645);
	angles[187] = (0, 255.9815, -5380.5508);
	at[187] = 12.8000;
	points[188] = (-3119.3975, -2470.6968, 859.1418);
	angles[188] = (0, 255.9815, -5262.2676);
	at[188] = 12.8667;
	points[189] = (-3063.1692, -2484.7324, 855.3819);
	angles[189] = (0, 255.9815, -5143.9839);
	at[189] = 12.9333;
	points[190] = (-3006.9409, -2498.7717, 842.1732);
	angles[190] = (0, 255.9815, -5025.7007);
	at[190] = 13;
	points[191] = (-2950.7126, -2512.8110, 819.5158);
	angles[191] = (0, 255.9816, -4907.4170);
	at[191] = 13.0667;
	points[192] = (-2894.4802, -2526.8503, 812.1969);
	angles[192] = (0, 255.9815, -4792.1133);
	at[192] = 13.1333;
	points[193] = (-2838.2520, -2540.8896, 810.8425);
	angles[193] = (0, 248.6948, -4677.8022);
	at[193] = 13.2000;
	points[194] = (-2783.7324, -2562.8149, 800.0433);
	angles[194] = (0, 248.6949, -4563.4917);
	at[194] = 13.2667;
	points[195] = (-2729.0789, -2584.1301, 779.7913);
	angles[195] = (0, 248.6948, -4449.1807);
	at[195] = 13.3333;
	points[196] = (-2674.4211, -2605.4448, 770.0945);
	angles[196] = (0, 248.6948, -4337.8706);
	at[196] = 13.4000;
	points[197] = (-2619.7678, -2626.7600, 768.0197);
	angles[197] = (0, 248.6948, -4227.5605);
	at[197] = 13.4667;
	points[198] = (-2565.1143, -2648.0750, 756.4961);
	angles[198] = (0, 248.6947, -4117.2500);
	at[198] = 13.5333;
	points[199] = (-2510.4607, -2669.3896, 735.5237);
	angles[199] = (0, 248.6947, -4006.9404);
	at[199] = 13.6000;
	points[200] = (-2455.8071, -2690.7048, 733.9252);
	angles[200] = (0, 248.6949, -3900.6309);
	at[200] = 13.6667;
	points[201] = (-2401.1536, -2712.0198, 728.9961);
	angles[201] = (0, 248.6949, -3794.3213);
	at[201] = 13.7333;
	points[202] = (-2346.4961, -2733.3345, 714.6182);
	angles[202] = (0, 248.6948, -3688.0117);
	at[202] = 13.8000;
	points[203] = (-2291.8425, -2754.6458, 723.3071);
	angles[203] = (0, 248.6948, -3591.7039);
	at[203] = 13.8667;
	points[204] = (-2237.1890, -2775.9607, 729.2795);
	angles[204] = (0, 248.6947, -3510.3982);
	at[204] = 13.9333;
	points[205] = (-2186.2598, -2802.3779, 721.5591);
	angles[205] = (0, 234.9403, -3432.0930);
	at[205] = 14;
	points[206] = (-2139.8308, -2834.9565, 704.3937);
	angles[206] = (0, 234.9404, -3353.7881);
	at[206] = 14.0667;
	points[207] = (-2093.4016, -2867.5396, 677.7756);
	angles[207] = (0, 234.9404, -3275.4829);
	at[207] = 14.1333;
	points[208] = (-2046.9763, -2900.1221, 641.7087);
	angles[208] = (0, 234.9403, -3197.1777);
	at[208] = 14.2000;
	points[209] = (-2000.5472, -2932.7009, 596.1968);
	angles[209] = (0, 234.9402, -3118.8728);
	at[209] = 14.2667;
	points[210] = (-1954.1182, -2965.2834, 541.2323);
	angles[210] = (0, 234.9404, -3040.5679);
	at[210] = 14.3333;
	points[211] = (-1907.6890, -2997.8660, 476.8228);
	angles[211] = (0, 234.9403, -2962.2627);
	at[211] = 14.4000;
	points[212] = (-1861.2638, -3030.4448, 402.9606);
	angles[212] = (0, 234.9403, -2883.9575);
	at[212] = 14.4667;
	points[213] = (-1814.8347, -3063.0278, 319.6532);
	angles[213] = (0, 234.9403, -2805.6526);
	at[213] = 14.5333;
	points[214] = (-1768.4055, -3095.6104, 226.8953);
	angles[214] = (0, 234.9404, -2727.3474);
	at[214] = 14.6000;
	points[215] = (-1721.9764, -3128.1929, 124.6886);
	angles[215] = (0, 234.9403, -2649.0425);
	at[215] = 14.6667;
	points[216] = (-1675.5472, -3160.7717, 13.0330);
	angles[216] = (0, 234.9404, -2570.7373);
	at[216] = 14.7333;
	points[217] = (-1629.1221, -3193.3542, -108.0713);
	angles[217] = (0, 234.9402, -2492.4321);
	at[217] = 14.8000;
	points[218] = (-1582.6930, -3225.9370, -238.6248);
	angles[218] = (0, 234.9404, -2414.1272);
	at[218] = 14.8667;
	points[219] = (-1536.2638, -3258.5156, -378.6268);
	angles[219] = (0, 234.9402, -2335.8220);
	at[219] = 14.9333;
	points[220] = (-1489.8347, -3291.0986, -528.0787);
	angles[220] = (0, 234.9403, -2257.5171);
	at[220] = 15;
	points[221] = (-1443.4095, -3323.6812, -686.9764);
	angles[221] = (0, 234.9403, -2179.2119);
	at[221] = 15.0667;
	points[222] = (-1396.9803, -3356.2600, -855.3268);
	angles[222] = (0, 234.9403, -2100.9067);
	at[222] = 15.1333;
	points[223] = (-1350.5513, -3388.8425, -1033.1221);
	angles[223] = (0, 234.9403, -2022.6018);
	at[223] = 15.2000;
	points[224] = (-1304.1221, -3421.4250, -1220.3701);
	angles[224] = (0, 234.9403, -1944.2966);
	at[224] = 15.2667;
	points[225] = (-1257.6969, -3454.0039, -1417.0630);
	angles[225] = (0, 234.9403, -1865.9915);
	at[225] = 15.3333;
	points[226] = (-1211.2677, -3486.5867, -1623.2086);
	angles[226] = (0, 234.9403, -1787.6865);
	at[226] = 15.4000;
	points[227] = (-1164.8386, -3519.1694, -1838.7993);
	angles[227] = (0, 234.9403, -1709.3813);
	at[227] = 15.4667;
	points[228] = (-1118.4094, -3551.7520, -2063.8425);
	angles[228] = (0, 234.9402, -1631.0764);
	at[228] = 15.5333;
	points[229] = (-1095.1969, -3568.0393, -2179.9055);
	angles[229] = (0, 234.9403, -1771.9238);
	at[229] = 15.5833;
	points[230] = (-7410.0396, 1089.1575, 3056.9292);
	angles[230] = (0, 234.9403, -1771.9238);
	at[230] = 15.5833;
	points[231] = (-7410.0396, 1089.1575, 3056.9292);
	angles[231] = (0, 234.9403, -1771.9238);
	at[231] = 15.6000;
	points[232] = (-7414.6851, 1077.1300, 3081.7324);
	angles[232] = (0, 158.8680, -1618.4669);
	at[232] = 15.6333;
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
	points[0] = (1324.6693, -740.0512, 1585.2836);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1324.6693, -740.0512, 1585.2836);
	angles[1] = (0, 90, 0);
	at[1] = 0.8500;
	points[2] = (1324.6693, -740.0512, 1617.7244);
	angles[2] = (0, 90, 0);
	at[2] = 0.9000;
	points[3] = (1324.6693, -740.0512, 1660.4331);
	angles[3] = (0, 90, 0);
	at[3] = 0.9500;
	points[4] = (1324.6693, -740.0512, 1739.0472);
	angles[4] = (0, 90, 0);
	at[4] = 1.0500;
	points[5] = (1324.6693, -740.0512, 1808.5907);
	angles[5] = (0, 90, 0);
	at[5] = 1.1500;
	points[6] = (1324.6693, -740.0512, 1839.9607);
	angles[6] = (0, 90, 0);
	at[6] = 1.2000;
	points[7] = (1324.6693, -740.0512, 1895.8977);
	angles[7] = (0, 90, 0);
	at[7] = 1.3000;
	points[8] = (1324.6693, -740.0512, 1942.7638);
	angles[8] = (0, 90, 0);
	at[8] = 1.4000;
	points[9] = (1324.6693, -740.0512, 1962.7953);
	angles[9] = (0, 90, 0);
	at[9] = 1.4500;
	points[10] = (1324.6693, -740.0512, 1996.0551);
	angles[10] = (0, 90, 0);
	at[10] = 1.5500;
	points[11] = (1324.6693, -740.0512, 2020.2441);
	angles[11] = (0, 90, 0);
	at[11] = 1.6500;
	points[12] = (1324.6693, -740.0512, 2035.3622);
	angles[12] = (0, 90, 0);
	at[12] = 1.7500;
	points[13] = (1324.6693, -740.0512, 2044.6063);
	angles[13] = (0, 90, 0);
	at[13] = 1.9000;
	points[14] = (1324.6693, -740.0512, 2052.5081);
	angles[14] = (0, 90, 0);
	at[14] = 1.9500;
	points[15] = (1324.6693, -740.0512, 2056.2166);
	angles[15] = (0, 90, 0);
	at[15] = 2;
	points[16] = (1324.6693, -740.0512, 2054.3228);
	angles[16] = (0, 90, 0);
	at[16] = 2.0500;
	points[17] = (1324.6693, -740.0512, 2030.5631);
	angles[17] = (0, 90, 0);
	at[17] = 2.2000;
	points[18] = (1324.6693, -740.0512, 2026.8544);
	angles[18] = (0, 90, 0);
	at[18] = 2.2500;
	points[19] = (1324.6693, -740.0512, 2028.7480);
	angles[19] = (0, 90, 0);
	at[19] = 2.3000;
	points[20] = (1324.6693, -740.0512, 2052.5081);
	angles[20] = (0, 90, 0);
	at[20] = 2.4500;
	points[21] = (1324.6693, -740.0512, 2056.2166);
	angles[21] = (0, 90, 0);
	at[21] = 2.5000;
	points[22] = (1324.6693, -740.0512, 2054.3228);
	angles[22] = (0, 90, 0);
	at[22] = 2.5500;
	points[23] = (1324.6693, -740.0512, 2030.5631);
	angles[23] = (0, 90, 0);
	at[23] = 2.7000;
	points[24] = (1324.6693, -740.0512, 2026.8544);
	angles[24] = (0, 90, 0);
	at[24] = 2.7500;
	points[25] = (1324.6693, -740.0512, 2028.7480);
	angles[25] = (0, 90, 0);
	at[25] = 2.8000;
	points[26] = (1324.6693, -740.0512, 2052.5081);
	angles[26] = (0, 90, 0);
	at[26] = 2.9500;
	points[27] = (1324.6693, -740.0512, 2056.2166);
	angles[27] = (0, 90, 0);
	at[27] = 3;
	points[28] = (1324.6693, -740.0512, 2054.3228);
	angles[28] = (0, 90, 0);
	at[28] = 3.0500;
	points[29] = (1324.6693, -740.0512, 2030.5631);
	angles[29] = (0, 90, 0);
	at[29] = 3.2000;
	points[30] = (1324.6693, -740.0512, 2026.8544);
	angles[30] = (0, 90, 0);
	at[30] = 3.2500;
	points[31] = (1324.6693, -740.0512, 2028.7480);
	angles[31] = (0, 90, 0);
	at[31] = 3.3000;
	points[32] = (1324.6693, -740.0512, 2052.5081);
	angles[32] = (0, 90, 0);
	at[32] = 3.4500;
	points[33] = (1324.6693, -740.0512, 2056.2166);
	angles[33] = (0, 90, 0);
	at[33] = 3.5000;
	points[34] = (1324.6693, -740.0512, 2054.3228);
	angles[34] = (0, 90, 0);
	at[34] = 3.5500;
	points[35] = (1324.6693, -740.0512, 2030.5631);
	angles[35] = (0, 90, 0);
	at[35] = 3.7000;
	points[36] = (1324.6693, -740.0512, 2026.2284);
	angles[36] = (0, 90, 0);
	at[36] = 3.7500;
	points[37] = (1324.6693, -740.0512, 1587.8032);
	angles[37] = (0, 90, 0);
	at[37] = 6.6500;
	points[38] = (1324.6693, -740.0512, 1585.2836);
	angles[38] = (0, 90, 0);
	at[38] = 6.7000;
	points[39] = (1324.6693, -740.0512, 1585.2836);
	angles[39] = (0, 90, 0);
	at[39] = 10.0167;
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
	points[0] = (1407.0117, 885.3189, 1588.1182);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1407.0117, 885.3189, 1588.1182);
	angles[1] = (0, 90, 0);
	at[1] = 0.8500;
	points[2] = (1407.0117, 885.3189, 1620.5591);
	angles[2] = (0, 90, 0);
	at[2] = 0.9000;
	points[3] = (1407.0117, 885.3189, 1663.2678);
	angles[3] = (0, 90, 0);
	at[3] = 0.9500;
	points[4] = (1407.0117, 885.3189, 1741.8820);
	angles[4] = (0, 90, 0);
	at[4] = 1.0500;
	points[5] = (1407.0117, 885.3189, 1811.4253);
	angles[5] = (0, 90, 0);
	at[5] = 1.1500;
	points[6] = (1407.0117, 885.3189, 1842.7953);
	angles[6] = (0, 90, 0);
	at[6] = 1.2000;
	points[7] = (1407.0117, 885.3189, 1898.7323);
	angles[7] = (0, 90, 0);
	at[7] = 1.3000;
	points[8] = (1407.0117, 885.3189, 1945.5985);
	angles[8] = (0, 90, 0);
	at[8] = 1.4000;
	points[9] = (1407.0117, 885.3189, 1965.6299);
	angles[9] = (0, 90, 0);
	at[9] = 1.4500;
	points[10] = (1407.0117, 885.3189, 1998.8898);
	angles[10] = (0, 90, 0);
	at[10] = 1.5500;
	points[11] = (1407.0117, 885.3189, 2023.0787);
	angles[11] = (0, 90, 0);
	at[11] = 1.6500;
	points[12] = (1407.0117, 885.3189, 2038.1968);
	angles[12] = (0, 90, 0);
	at[12] = 1.7500;
	points[13] = (1407.0117, 885.3189, 2047.4410);
	angles[13] = (0, 90, 0);
	at[13] = 1.9000;
	points[14] = (1407.0117, 885.3189, 2055.3425);
	angles[14] = (0, 90, 0);
	at[14] = 1.9500;
	points[15] = (1407.0117, 885.3189, 2059.0513);
	angles[15] = (0, 90, 0);
	at[15] = 2;
	points[16] = (1407.0117, 885.3189, 2057.1575);
	angles[16] = (0, 90, 0);
	at[16] = 2.0500;
	points[17] = (1407.0117, 885.3189, 2033.3977);
	angles[17] = (0, 90, 0);
	at[17] = 2.2000;
	points[18] = (1407.0117, 885.3189, 2029.6851);
	angles[18] = (0, 90, 0);
	at[18] = 2.2500;
	points[19] = (1407.0117, 885.3189, 2031.5826);
	angles[19] = (0, 90, 0);
	at[19] = 2.3000;
	points[20] = (1407.0117, 885.3189, 2055.3425);
	angles[20] = (0, 90, 0);
	at[20] = 2.4500;
	points[21] = (1407.0117, 885.3189, 2059.0513);
	angles[21] = (0, 90, 0);
	at[21] = 2.5000;
	points[22] = (1407.0117, 885.3189, 2057.1575);
	angles[22] = (0, 90, 0);
	at[22] = 2.5500;
	points[23] = (1407.0117, 885.3189, 2033.3977);
	angles[23] = (0, 90, 0);
	at[23] = 2.7000;
	points[24] = (1407.0117, 885.3189, 2029.6851);
	angles[24] = (0, 90, 0);
	at[24] = 2.7500;
	points[25] = (1407.0117, 885.3189, 2031.5826);
	angles[25] = (0, 90, 0);
	at[25] = 2.8000;
	points[26] = (1407.0117, 885.3189, 2055.3425);
	angles[26] = (0, 90, 0);
	at[26] = 2.9500;
	points[27] = (1407.0117, 885.3189, 2059.0513);
	angles[27] = (0, 90, 0);
	at[27] = 3;
	points[28] = (1407.0117, 885.3189, 2057.1575);
	angles[28] = (0, 90, 0);
	at[28] = 3.0500;
	points[29] = (1407.0117, 885.3189, 2033.3977);
	angles[29] = (0, 90, 0);
	at[29] = 3.2000;
	points[30] = (1407.0117, 885.3189, 2029.6851);
	angles[30] = (0, 90, 0);
	at[30] = 3.2500;
	points[31] = (1407.0117, 885.3189, 2031.5826);
	angles[31] = (0, 90, 0);
	at[31] = 3.3000;
	points[32] = (1407.0117, 885.3189, 2055.3425);
	angles[32] = (0, 90, 0);
	at[32] = 3.4500;
	points[33] = (1407.0117, 885.3189, 2059.0513);
	angles[33] = (0, 90, 0);
	at[33] = 3.5000;
	points[34] = (1407.0117, 885.3189, 2057.1575);
	angles[34] = (0, 90, 0);
	at[34] = 3.5500;
	points[35] = (1407.0117, 885.3189, 2033.3977);
	angles[35] = (0, 90, 0);
	at[35] = 3.7000;
	points[36] = (1407.0117, 885.3189, 2029.0630);
	angles[36] = (0, 90, 0);
	at[36] = 3.7500;
	points[37] = (1407.0117, 885.3189, 1590.6378);
	angles[37] = (0, 90, 0);
	at[37] = 6.6500;
	points[38] = (1407.0117, 885.3189, 1588.1182);
	angles[38] = (0, 90, 0);
	at[38] = 6.7000;
	points[39] = (1407.0117, 885.3189, 1588.1182);
	angles[39] = (0, 90, 0);
	at[39] = 10.0167;
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
	points[0] = (-1150.3229, -4367.7559, -392.1575);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-1150.3229, -4367.7559, -392.1575);
	angles[1] = (0, 90, 0);
	at[1] = 3.3500;
	points[2] = (-1150.3229, -4367.7559, -351.6551);
	angles[2] = (0, 90, 0);
	at[2] = 3.4000;
	points[3] = (-1150.3229, -4367.7559, -247.7181);
	angles[3] = (0, 90, 0);
	at[3] = 3.5000;
	points[4] = (-1150.3229, -4367.7559, -200.0016);
	angles[4] = (0, 90, 0);
	at[4] = 3.5500;
	points[5] = (-1150.3229, -4367.7559, -113.0724);
	angles[5] = (0, 90, 0);
	at[5] = 3.6500;
	points[6] = (-1150.3229, -4367.7559, -37.4819);
	angles[6] = (0, 90, 0);
	at[6] = 3.7500;
	points[7] = (-1150.3229, -4367.7559, 26.7700);
	angles[7] = (0, 90, 0);
	at[7] = 3.8500;
	points[8] = (-1150.3229, -4367.7559, 54.6441);
	angles[8] = (0, 90, 0);
	at[8] = 3.9000;
	points[9] = (-1150.3229, -4367.7559, 101.8882);
	angles[9] = (0, 90, 0);
	at[9] = 4;
	points[10] = (-1150.3229, -4367.7559, 137.7937);
	angles[10] = (0, 90, 0);
	at[10] = 4.1000;
	points[11] = (-1150.3229, -4367.7559, 151.4945);
	angles[11] = (0, 90, 0);
	at[11] = 4.1500;
	points[12] = (-1150.3229, -4367.7559, 170.3921);
	angles[12] = (0, 90, 0);
	at[12] = 4.2500;
	points[13] = (-1150.3229, -4367.7559, 181.1784);
	angles[13] = (0, 90, 0);
	at[13] = 4.4000;
	points[14] = (-1150.3229, -4367.7559, 189.0803);
	angles[14] = (0, 90, 0);
	at[14] = 4.4500;
	points[15] = (-1150.3229, -4367.7559, 192.7914);
	angles[15] = (0, 90, 0);
	at[15] = 4.5000;
	points[16] = (-1150.3229, -4367.7559, 190.8945);
	angles[16] = (0, 90, 0);
	at[16] = 4.5500;
	points[17] = (-1150.3229, -4367.7559, 167.1370);
	angles[17] = (0, 90, 0);
	at[17] = 4.7000;
	points[18] = (-1150.3229, -4367.7559, 163.4256);
	angles[18] = (0, 90, 0);
	at[18] = 4.7500;
	points[19] = (-1150.3229, -4367.7559, 165.3228);
	angles[19] = (0, 90, 0);
	at[19] = 4.8000;
	points[20] = (-1150.3229, -4367.7559, 189.0803);
	angles[20] = (0, 90, 0);
	at[20] = 4.9500;
	points[21] = (-1150.3229, -4367.7559, 192.7914);
	angles[21] = (0, 90, 0);
	at[21] = 5;
	points[22] = (-1150.3229, -4367.7559, 190.8945);
	angles[22] = (0, 90, 0);
	at[22] = 5.0500;
	points[23] = (-1150.3229, -4367.7559, 167.1370);
	angles[23] = (0, 90, 0);
	at[23] = 5.2000;
	points[24] = (-1150.3229, -4367.7559, 163.4256);
	angles[24] = (0, 90, 0);
	at[24] = 5.2500;
	points[25] = (-1150.3229, -4367.7559, 165.3228);
	angles[25] = (0, 90, 0);
	at[25] = 5.3000;
	points[26] = (-1150.3229, -4367.7559, 189.0803);
	angles[26] = (0, 90, 0);
	at[26] = 5.4500;
	points[27] = (-1150.3229, -4367.7559, 192.7914);
	angles[27] = (0, 90, 0);
	at[27] = 5.5000;
	points[28] = (-1150.3229, -4367.7559, 190.8945);
	angles[28] = (0, 90, 0);
	at[28] = 5.5500;
	points[29] = (-1150.3229, -4367.7559, 167.1370);
	angles[29] = (0, 90, 0);
	at[29] = 5.7000;
	points[30] = (-1150.3229, -4367.7559, 163.4256);
	angles[30] = (0, 90, 0);
	at[30] = 5.7500;
	points[31] = (-1150.3229, -4367.7559, 165.3228);
	angles[31] = (0, 90, 0);
	at[31] = 5.8000;
	points[32] = (-1150.3229, -4367.7559, 189.0803);
	angles[32] = (0, 90, 0);
	at[32] = 5.9500;
	points[33] = (-1150.3229, -4367.7559, 192.7914);
	angles[33] = (0, 90, 0);
	at[33] = 6;
	points[34] = (-1150.3229, -4367.7559, 190.8945);
	angles[34] = (0, 90, 0);
	at[34] = 6.0500;
	points[35] = (-1150.3229, -4367.7559, 167.1370);
	angles[35] = (0, 90, 0);
	at[35] = 6.2000;
	points[36] = (-1150.3229, -4367.7559, 162.1732);
	angles[36] = (0, 90, 0);
	at[36] = 6.2500;
	points[37] = (-1150.3229, -4367.7559, -385.8583);
	angles[37] = (0, 90, 0);
	at[37] = 9.1500;
	points[38] = (-1150.3229, -4367.7559, -392.1575);
	angles[38] = (0, 90, 0);
	at[38] = 9.2000;
	points[39] = (-1150.3229, -4367.7559, -392.1575);
	angles[39] = (0, 90, 0);
	at[39] = 10.0333;
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
	points[0] = (-803.3661, -3102.3740, -429.8150);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-803.3661, -3102.3740, -429.8150);
	angles[1] = (0, 90, 0);
	at[1] = 3.3500;
	points[2] = (-803.3661, -3102.3740, -389.3122);
	angles[2] = (0, 90, 0);
	at[2] = 3.4000;
	points[3] = (-803.3661, -3102.3740, -285.3752);
	angles[3] = (0, 90, 0);
	at[3] = 3.5000;
	points[4] = (-803.3661, -3102.3740, -237.6587);
	angles[4] = (0, 90, 0);
	at[4] = 3.5500;
	points[5] = (-803.3661, -3102.3740, -150.7299);
	angles[5] = (0, 90, 0);
	at[5] = 3.6500;
	points[6] = (-803.3661, -3102.3740, -75.1390);
	angles[6] = (0, 90, 0);
	at[6] = 3.7500;
	points[7] = (-803.3661, -3102.3740, -10.8872);
	angles[7] = (0, 90, 0);
	at[7] = 3.8500;
	points[8] = (-803.3661, -3102.3740, 16.9868);
	angles[8] = (0, 90, 0);
	at[8] = 3.9000;
	points[9] = (-803.3661, -3102.3740, 64.2307);
	angles[9] = (0, 90, 0);
	at[9] = 4;
	points[10] = (-803.3661, -3102.3740, 100.1366);
	angles[10] = (0, 90, 0);
	at[10] = 4.1000;
	points[11] = (-803.3661, -3102.3740, 113.8370);
	angles[11] = (0, 90, 0);
	at[11] = 4.1500;
	points[12] = (-803.3661, -3102.3740, 132.7346);
	angles[12] = (0, 90, 0);
	at[12] = 4.2500;
	points[13] = (-803.3661, -3102.3740, 143.5209);
	angles[13] = (0, 90, 0);
	at[13] = 4.4000;
	points[14] = (-803.3661, -3102.3740, 151.4228);
	angles[14] = (0, 90, 0);
	at[14] = 4.4500;
	points[15] = (-803.3661, -3102.3740, 155.1342);
	angles[15] = (0, 90, 0);
	at[15] = 4.5000;
	points[16] = (-803.3661, -3102.3740, 153.2370);
	angles[16] = (0, 90, 0);
	at[16] = 4.5500;
	points[17] = (-803.3661, -3102.3740, 129.4799);
	angles[17] = (0, 90, 0);
	at[17] = 4.7000;
	points[18] = (-803.3661, -3102.3740, 125.7685);
	angles[18] = (0, 90, 0);
	at[18] = 4.7500;
	points[19] = (-803.3661, -3102.3740, 127.6658);
	angles[19] = (0, 90, 0);
	at[19] = 4.8000;
	points[20] = (-803.3661, -3102.3740, 151.4228);
	angles[20] = (0, 90, 0);
	at[20] = 4.9500;
	points[21] = (-803.3661, -3102.3740, 155.1342);
	angles[21] = (0, 90, 0);
	at[21] = 5;
	points[22] = (-803.3661, -3102.3740, 153.2370);
	angles[22] = (0, 90, 0);
	at[22] = 5.0500;
	points[23] = (-803.3661, -3102.3740, 129.4799);
	angles[23] = (0, 90, 0);
	at[23] = 5.2000;
	points[24] = (-803.3661, -3102.3740, 125.7685);
	angles[24] = (0, 90, 0);
	at[24] = 5.2500;
	points[25] = (-803.3661, -3102.3740, 127.6658);
	angles[25] = (0, 90, 0);
	at[25] = 5.3000;
	points[26] = (-803.3661, -3102.3740, 151.4228);
	angles[26] = (0, 90, 0);
	at[26] = 5.4500;
	points[27] = (-803.3661, -3102.3740, 155.1342);
	angles[27] = (0, 90, 0);
	at[27] = 5.5000;
	points[28] = (-803.3661, -3102.3740, 153.2370);
	angles[28] = (0, 90, 0);
	at[28] = 5.5500;
	points[29] = (-803.3661, -3102.3740, 129.4799);
	angles[29] = (0, 90, 0);
	at[29] = 5.7000;
	points[30] = (-803.3661, -3102.3740, 125.7685);
	angles[30] = (0, 90, 0);
	at[30] = 5.7500;
	points[31] = (-803.3661, -3102.3740, 127.6658);
	angles[31] = (0, 90, 0);
	at[31] = 5.8000;
	points[32] = (-803.3661, -3102.3740, 151.4228);
	angles[32] = (0, 90, 0);
	at[32] = 5.9500;
	points[33] = (-803.3661, -3102.3740, 155.1342);
	angles[33] = (0, 90, 0);
	at[33] = 6;
	points[34] = (-803.3661, -3102.3740, 153.2370);
	angles[34] = (0, 90, 0);
	at[34] = 6.0500;
	points[35] = (-803.3661, -3102.3740, 129.4799);
	angles[35] = (0, 90, 0);
	at[35] = 6.2000;
	points[36] = (-803.3661, -3102.3740, 124.5161);
	angles[36] = (0, 90, 0);
	at[36] = 6.2500;
	points[37] = (-803.3661, -3102.3740, -423.5158);
	angles[37] = (0, 90, 0);
	at[37] = 9.1500;
	points[38] = (-803.3661, -3102.3740, -429.8150);
	angles[38] = (0, 90, 0);
	at[38] = 9.2000;
	points[39] = (-803.3661, -3102.3740, -429.8150);
	angles[39] = (0, 90, 0);
	at[39] = 10.0333;
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
	points[0] = (-6587.0078, -2218.9802, 494.8307);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-6587.0078, -2218.9802, 494.8307);
	angles[1] = (0, 90, 0);
	at[1] = 3.3500;
	points[2] = (-6587.0078, -2218.9802, 535.3347);
	angles[2] = (0, 90, 0);
	at[2] = 3.4000;
	points[3] = (-6587.0078, -2218.9802, 639.2677);
	angles[3] = (0, 90, 0);
	at[3] = 3.5000;
	points[4] = (-6587.0078, -2218.9802, 686.9843);
	angles[4] = (0, 90, 0);
	at[4] = 3.5500;
	points[5] = (-6587.0078, -2218.9802, 773.9134);
	angles[5] = (0, 90, 0);
	at[5] = 3.6500;
	points[6] = (-6587.0078, -2218.9802, 849.5040);
	angles[6] = (0, 90, 0);
	at[6] = 3.7500;
	points[7] = (-6587.0078, -2218.9802, 883.0472);
	angles[7] = (0, 90, 0);
	at[7] = 3.8000;
	points[8] = (-6587.0078, -2218.9802, 941.6299);
	angles[8] = (0, 90, 0);
	at[8] = 3.9000;
	points[9] = (-6587.0078, -2218.9802, 988.8740);
	angles[9] = (0, 90, 0);
	at[9] = 4;
	points[10] = (-6587.0078, -2218.9802, 1008.2441);
	angles[10] = (0, 90, 0);
	at[10] = 4.0500;
	points[11] = (-6587.0078, -2218.9802, 1038.4803);
	angles[11] = (0, 90, 0);
	at[11] = 4.1500;
	points[12] = (-6587.0078, -2218.9802, 1057.3781);
	angles[12] = (0, 90, 0);
	at[12] = 4.2500;
	points[13] = (-6587.0078, -2218.9802, 1068.1653);
	angles[13] = (0, 90, 0);
	at[13] = 4.4000;
	points[14] = (-6587.0078, -2218.9802, 1076.0669);
	angles[14] = (0, 90, 0);
	at[14] = 4.4500;
	points[15] = (-6587.0078, -2218.9802, 1079.7795);
	angles[15] = (0, 90, 0);
	at[15] = 4.5000;
	points[16] = (-6587.0078, -2218.9802, 1077.8820);
	angles[16] = (0, 90, 0);
	at[16] = 4.5500;
	points[17] = (-6587.0078, -2218.9802, 1054.1260);
	angles[17] = (0, 90, 0);
	at[17] = 4.7000;
	points[18] = (-6587.0078, -2218.9802, 1050.4135);
	angles[18] = (0, 90, 0);
	at[18] = 4.7500;
	points[19] = (-6587.0078, -2218.9802, 1052.3110);
	angles[19] = (0, 90, 0);
	at[19] = 4.8000;
	points[20] = (-6587.0078, -2218.9802, 1076.0669);
	angles[20] = (0, 90, 0);
	at[20] = 4.9500;
	points[21] = (-6587.0078, -2218.9802, 1079.7795);
	angles[21] = (0, 90, 0);
	at[21] = 5;
	points[22] = (-6587.0078, -2218.9802, 1077.8820);
	angles[22] = (0, 90, 0);
	at[22] = 5.0500;
	points[23] = (-6587.0078, -2218.9802, 1054.1260);
	angles[23] = (0, 90, 0);
	at[23] = 5.2000;
	points[24] = (-6587.0078, -2218.9802, 1050.4135);
	angles[24] = (0, 90, 0);
	at[24] = 5.2500;
	points[25] = (-6587.0078, -2218.9802, 1052.3110);
	angles[25] = (0, 90, 0);
	at[25] = 5.3000;
	points[26] = (-6587.0078, -2218.9802, 1076.0669);
	angles[26] = (0, 90, 0);
	at[26] = 5.4500;
	points[27] = (-6587.0078, -2218.9802, 1079.7795);
	angles[27] = (0, 90, 0);
	at[27] = 5.5000;
	points[28] = (-6587.0078, -2218.9802, 1077.8820);
	angles[28] = (0, 90, 0);
	at[28] = 5.5500;
	points[29] = (-6587.0078, -2218.9802, 1054.1260);
	angles[29] = (0, 90, 0);
	at[29] = 5.7000;
	points[30] = (-6587.0078, -2218.9802, 1050.4135);
	angles[30] = (0, 90, 0);
	at[30] = 5.7500;
	points[31] = (-6587.0078, -2218.9802, 1052.3110);
	angles[31] = (0, 90, 0);
	at[31] = 5.8000;
	points[32] = (-6587.0078, -2218.9802, 1076.0669);
	angles[32] = (0, 90, 0);
	at[32] = 5.9500;
	points[33] = (-6587.0078, -2218.9802, 1079.7795);
	angles[33] = (0, 90, 0);
	at[33] = 6;
	points[34] = (-6587.0078, -2218.9802, 1077.8820);
	angles[34] = (0, 90, 0);
	at[34] = 6.0500;
	points[35] = (-6587.0078, -2218.9802, 1054.1260);
	angles[35] = (0, 90, 0);
	at[35] = 6.2000;
	points[36] = (-6587.0078, -2218.9802, 1049.1615);
	angles[36] = (0, 90, 0);
	at[36] = 6.2500;
	points[37] = (-6587.0078, -2218.9802, 501.1299);
	angles[37] = (0, 90, 0);
	at[37] = 9.1500;
	points[38] = (-6587.0078, -2218.9802, 494.8307);
	angles[38] = (0, 90, 0);
	at[38] = 9.2000;
	points[39] = (-6587.0078, -2218.9802, 494.8307);
	angles[39] = (0, 90, 0);
	at[39] = 10.0333;
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
