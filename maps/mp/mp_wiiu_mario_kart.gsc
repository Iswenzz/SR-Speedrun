main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_mario_kart", 0);

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
	ambientPlay("iz_0_umks", 2);
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
	level.iz_route[level.iz_route.size] = (-22, 1751, 1007);
	level.iz_route[level.iz_route.size] = (-5, 134, 1004);
	level.iz_route[level.iz_route.size] = (-14, -1104, 1002);
	level.iz_route[level.iz_route.size] = (-11, -2259, 1000);
	level.iz_route[level.iz_route.size] = (-51, -4618, 1003);
	level.iz_route[level.iz_route.size] = (-151, -5250, 1020);
	level.iz_route[level.iz_route.size] = (-587, -5695, 1024);
	level.iz_route[level.iz_route.size] = (-1367, -5890, 1006);
	level.iz_route[level.iz_route.size] = (-3145, -5917, 974);
	level.iz_route[level.iz_route.size] = (-4213, -5901, 946);
	level.iz_route[level.iz_route.size] = (-5778, -5936, 785);
	level.iz_route[level.iz_route.size] = (-6819, -5899, 736);
	level.iz_route[level.iz_route.size] = (-7448, -5638, 762);
	level.iz_route[level.iz_route.size] = (-7670, -5022, 775);
	level.iz_route[level.iz_route.size] = (-7610, -4493, 772);
	level.iz_route[level.iz_route.size] = (-7391, -3981, 765);
	level.iz_route[level.iz_route.size] = (-6488, -3721, 719);
	level.iz_route[level.iz_route.size] = (-4657, -3700, 994);
	level.iz_route[level.iz_route.size] = (-2811, -3724, 1323);
	level.iz_route[level.iz_route.size] = (-306, -3667, 1747);
	level.iz_route[level.iz_route.size] = (2419, -3702, 2163);
	level.iz_route[level.iz_route.size] = (2999, -3510, 2234);
	level.iz_route[level.iz_route.size] = (3327, -3296, 2268);
	level.iz_route[level.iz_route.size] = (3883, -2684, 2314);
	level.iz_route[level.iz_route.size] = (5120, -1151, 2442);
	level.iz_route[level.iz_route.size] = (6316, 489, 2622);
	level.iz_route[level.iz_route.size] = (7326, 1897, 2828);
	level.iz_route[level.iz_route.size] = (8354, 3065, 3069);
	level.iz_route[level.iz_route.size] = (8924, 3405, 3203);
	level.iz_route[level.iz_route.size] = (9473, 3540, 3332);
	level.iz_route[level.iz_route.size] = (10366, 3565, 3544);
	level.iz_route[level.iz_route.size] = (11573, 3750, 3872);
	level.iz_route[level.iz_route.size] = (12119, 4004, 4020);
	level.iz_route[level.iz_route.size] = (12400, 4419, 4083);
	level.iz_route[level.iz_route.size] = (12453, 4918, 4087);
	level.iz_route[level.iz_route.size] = (12299, 5436, 4057);
	level.iz_route[level.iz_route.size] = (11798, 5702, 3937);
	level.iz_route[level.iz_route.size] = (10611, 5800, 3692);
	level.iz_route[level.iz_route.size] = (9547, 5771, 3466);
	level.iz_route[level.iz_route.size] = (8730, 5786, 3293);
	level.iz_route[level.iz_route.size] = (5559, 5838, 1742);
	level.iz_route[level.iz_route.size] = (3709, 5854, 1336);
	level.iz_route[level.iz_route.size] = (1812, 5843, 1060);
	level.iz_route[level.iz_route.size] = (691, 5698, 1021);
	level.iz_route[level.iz_route.size] = (31, 5485, 1037);
	level.iz_route[level.iz_route.size] = (-287, 4866, 1042);
	level.iz_route[level.iz_route.size] = (-179, 4201, 1025);
	level.iz_route[level.iz_route.size] = (-54, 3416, 1014);
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
	points[0] = (1498.2245, 5113.9370, 4154.3306);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1533.6890, 4991.4961, 4162.4805);
	angles[1] = (0, 0, 0);
	at[1] = 0.2000;
	points[2] = (1610.7795, 4741.1025, 4187.6772);
	angles[2] = (0, 0, 0);
	at[2] = 0.6000;
	points[3] = (1696.5118, 4495.1182, 4219.3701);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (1744.0236, 4373.4253, 4236.8501);
	angles[4] = (0, 0, 0);
	at[4] = 1.2000;
	points[5] = (1794.9055, 4253.9370, 4255.0396);
	angles[5] = (0, 0, 0);
	at[5] = 1.4000;
	points[6] = (1850.1575, 4136.0239, 4273.8975);
	angles[6] = (0, 0, 0);
	at[6] = 1.6000;
	points[7] = (1909.9330, 4021.3386, 4293.1104);
	angles[7] = (0, 0, 0);
	at[7] = 1.8000;
	points[8] = (1976.0472, 3908.8347, 4312.8345);
	angles[8] = (0, 0, 0);
	at[8] = 2;
	points[9] = (2048.6458, 3801.2085, 4332.5981);
	angles[9] = (0, 0, 0);
	at[9] = 2.2000;
	points[10] = (2128.6182, 3700.2441, 4352.0864);
	angles[10] = (0, 0, 0);
	at[10] = 2.4000;
	points[11] = (2219.2913, 3606.0237, 4371.3779);
	angles[11] = (0, 0, 0);
	at[11] = 2.6000;
	points[12] = (2319.9961, 3524.1970, 4389.4487);
	angles[12] = (0, 0, 0);
	at[12] = 2.8000;
	points[13] = (2425.5750, 3461.6853, 4404.8818);
	angles[13] = (0, 0, 0);
	at[13] = 3;
	points[14] = (2537.6929, 3413.3230, 4419.0552);
	angles[14] = (0, 0, 0);
	at[14] = 3.2000;
	points[15] = (2667.9016, 3365.3269, 4434.7637);
	angles[15] = (0, 0, 0);
	at[15] = 3.4000;
	points[16] = (2784.9214, 3325.8188, 4448.5830);
	angles[16] = (0, 0, 0);
	at[16] = 3.6000;
	points[17] = (2915.8621, 3284.1101, 4463.7402);
	angles[17] = (0, 0, 0);
	at[17] = 3.8000;
	points[18] = (3162.1653, 3210.3582, 4491.8110);
	angles[18] = (0, 0, 0);
	at[18] = 4.2000;
	points[19] = (3421.0117, 3137.3425, 4520.8271);
	angles[19] = (0, 0, 0);
	at[19] = 4.6000;
	points[20] = (3668.4253, 3070.6614, 4548.1890);
	angles[20] = (0, 0, 0);
	at[20] = 5;
	points[21] = (3925.6299, 3003.9016, 4576.2993);
	angles[21] = (0, 0, 0);
	at[21] = 5.4000;
	points[22] = (4177.1655, 2940.8032, 4603.5039);
	angles[22] = (0, 0, 0);
	at[22] = 5.8000;
	points[23] = (4432.8350, 2878.6812, 4630.8267);
	angles[23] = (0, 0, 0);
	at[23] = 6.2000;
	points[24] = (4941.0234, 2761.0317, 4684.2124);
	angles[24] = (0, 0, 0);
	at[24] = 7;
	points[25] = (5200.5908, 2704.0906, 4710.9053);
	angles[25] = (0, 0, 0);
	at[25] = 7.4000;
	points[26] = (5451.2993, 2651.4097, 4736.2598);
	angles[26] = (0, 0, 0);
	at[26] = 7.8000;
	points[27] = (5585.4331, 2624.2952, 4749.6064);
	angles[27] = (0, 0, 0);
	at[27] = 8;
	points[28] = (5715.4331, 2598.8464, 4762.3623);
	angles[28] = (0, 0, 0);
	at[28] = 8.2000;
	points[29] = (5840.2759, 2575.3030, 4774.4092);
	angles[29] = (0, 0, 0);
	at[29] = 8.4000;
	points[30] = (5969.1338, 2552.0789, 4786.6538);
	angles[30] = (0, 0, 0);
	at[30] = 8.6000;
	points[31] = (6104.4097, 2529.1614, 4799.1338);
	angles[31] = (0, 0, 0);
	at[31] = 8.8000;
	points[32] = (6229.0156, 2509.7639, 4810.2759);
	angles[32] = (0, 0, 0);
	at[32] = 9;
	points[33] = (6361.1812, 2491.7363, 4821.4961);
	angles[33] = (0, 0, 0);
	at[33] = 9.2000;
	points[34] = (6494.3306, 2477.8032, 4831.8501);
	angles[34] = (0, 0, 0);
	at[34] = 9.4000;
	points[35] = (6607.5195, 2472.4961, 4839.0947);
	angles[35] = (0, 0, 0);
	at[35] = 9.6000;
	points[36] = (6737.9136, 2476.0630, 4845);
	angles[36] = (0, 0, 0);
	at[36] = 9.8000;
	points[37] = (6869.2910, 2486.8308, 4849.1338);
	angles[37] = (0, 0, 0);
	at[37] = 10;
	points[38] = (6999.4097, 2502.5393, 4851.9683);
	angles[38] = (0, 0, 0);
	at[38] = 10.2000;
	points[39] = (7130.9844, 2522.3308, 4853.9370);
	angles[39] = (0, 0, 0);
	at[39] = 10.4000;
	points[40] = (7258.8188, 2544.6023, 4855.1182);
	angles[40] = (0, 0, 0);
	at[40] = 10.6000;
	points[41] = (7390.7485, 2570.2361, 4855.7480);
	angles[41] = (0, 0, 0);
	at[41] = 10.8000;
	points[42] = (7645.7090, 2626.1260, 4855.6694);
	angles[42] = (0, 0, 0);
	at[42] = 11.2000;
	points[43] = (7901.2598, 2689.2559, 4854.2915);
	angles[43] = (0, 0, 0);
	at[43] = 11.6000;
	points[44] = (8155.5117, 2758.3030, 4851.9292);
	angles[44] = (0, 0, 0);
	at[44] = 12;
	points[45] = (8406.5352, 2832.2876, 4848.9370);
	angles[45] = (0, 0, 0);
	at[45] = 12.4000;
	points[46] = (8533.9766, 2872.1262, 4847.2051);
	angles[46] = (0, 0, 0);
	at[46] = 12.6000;
	points[47] = (8657.4414, 2912.2795, 4845.4722);
	angles[47] = (0, 0, 0);
	at[47] = 12.8000;
	points[48] = (8907.2441, 2998.9253, 4841.8506);
	angles[48] = (0, 0, 0);
	at[48] = 13.2000;
	points[49] = (9153.2285, 3093.7480, 4838.5039);
	angles[49] = (0, 0, 0);
	at[49] = 13.6000;
	points[50] = (9274.5674, 3146.1182, 4837.2441);
	angles[50] = (0, 0, 0);
	at[50] = 13.8000;
	points[51] = (9387.8740, 3201.4409, 4836.6143);
	angles[51] = (0, 0, 0);
	at[51] = 14;
	points[52] = (9493.7402, 3264.3503, 4836.6143);
	angles[52] = (0, 0, 0);
	at[52] = 14.2000;
	points[53] = (9603.7803, 3339.7717, 4836.6143);
	angles[53] = (0, 0, 0);
	at[53] = 14.4000;
	points[54] = (9812.8740, 3499.6418, 4836.6143);
	angles[54] = (0, 0, 0);
	at[54] = 14.8000;
	points[55] = (10015.8662, 3668.5317, 4836.6143);
	angles[55] = (0, 0, 0);
	at[55] = 15.2000;
	points[56] = (10310.0791, 3930.5356, 4836.6143);
	angles[56] = (0, 0, 0);
	at[56] = 15.8000;
	points[57] = (10596.6143, 4202.4409, 4836.6143);
	angles[57] = (0, 0, 0);
	at[57] = 16.4000;
	points[58] = (10783.3066, 4388.8188, 4836.6143);
	angles[58] = (0, 0, 0);
	at[58] = 16.8000;
	points[59] = (10873.6621, 4482.0869, 4836.6143);
	angles[59] = (0, 0, 0);
	at[59] = 17;
	points[60] = (11053.4248, 4675.3936, 4836.6143);
	angles[60] = (0, 0, 0);
	at[60] = 17.4000;
	points[61] = (11141.2598, 4774.9214, 4836.6143);
	angles[61] = (0, 0, 0);
	at[61] = 17.6000;
	points[62] = (11224.9609, 4874.5278, 4836.6143);
	angles[62] = (0, 0, 0);
	at[62] = 17.8000;
	points[63] = (11307.9141, 4980.7480, 4836.6143);
	angles[63] = (0, 0, 0);
	at[63] = 18;
	points[64] = (11375.8662, 5079.5669, 4836.6143);
	angles[64] = (0, 0, 0);
	at[64] = 18.2000;
	points[65] = (11440.4727, 5191.3389, 4836.6143);
	angles[65] = (0, 0, 0);
	at[65] = 18.4000;
	points[66] = (11500.9053, 5307.3623, 4836.6143);
	angles[66] = (0, 0, 0);
	at[66] = 18.6000;
	points[67] = (11614.6055, 5546.1025, 4836.6143);
	angles[67] = (0, 0, 0);
	at[67] = 19;
	points[68] = (11721.3779, 5788.6616, 4836.6143);
	angles[68] = (0, 0, 0);
	at[68] = 19.4000;
	points[69] = (11771.6143, 5908.1099, 4836.6143);
	angles[69] = (0, 0, 0);
	at[69] = 19.6000;
	points[70] = (11870.6299, 6153.1890, 4836.6143);
	angles[70] = (0, 0, 0);
	at[70] = 20;
	points[71] = (12010.4336, 6522.8345, 4836.6143);
	angles[71] = (0, 0, 0);
	at[71] = 20.6000;
	points[72] = (12139.4492, 6896.7324, 4836.6143);
	angles[72] = (0, 0, 0);
	at[72] = 21.2000;
	points[73] = (12178.5049, 7019.3706, 4836.6143);
	angles[73] = (0, 0, 0);
	at[73] = 21.4000;
	points[74] = (12217.4414, 7148.6616, 4836.6143);
	angles[74] = (0, 0, 0);
	at[74] = 21.6000;
	points[75] = (12252.4414, 7273.6221, 4836.6143);
	angles[75] = (0, 0, 0);
	at[75] = 21.8000;
	points[76] = (12285.1572, 7403.1890, 4836.6143);
	angles[76] = (0, 0, 0);
	at[76] = 22;
	points[77] = (12312.0479, 7529.5674, 4836.6143);
	angles[77] = (0, 0, 0);
	at[77] = 22.2000;
	points[78] = (12331.6934, 7664.2520, 4836.6143);
	angles[78] = (0, 0, 0);
	at[78] = 22.4000;
	points[79] = (12332.4023, 7781.5747, 4836.6143);
	angles[79] = (0, 0, 0);
	at[79] = 22.6000;
	points[80] = (12311.2598, 7914.3311, 4836.6143);
	angles[80] = (0, 0, 0);
	at[80] = 22.8000;
	points[81] = (12279.4883, 8039.2129, 4836.6143);
	angles[81] = (0, 0, 0);
	at[81] = 23;
	points[82] = (12239.7246, 8164.8032, 4836.6143);
	angles[82] = (0, 0, 0);
	at[82] = 23.2000;
	points[83] = (12194.2910, 8289.4883, 4836.6143);
	angles[83] = (0, 0, 0);
	at[83] = 23.4000;
	points[84] = (12145.3945, 8410.5117, 4836.6143);
	angles[84] = (0, 0, 0);
	at[84] = 23.6000;
	points[85] = (12036.1025, 8650.2363, 4836.6143);
	angles[85] = (0, 0, 0);
	at[85] = 24;
	points[86] = (11914.0947, 8883.7793, 4836.6143);
	angles[86] = (0, 0, 0);
	at[86] = 24.4000;
	points[87] = (11848.7803, 8997.3232, 4836.6143);
	angles[87] = (0, 0, 0);
	at[87] = 24.6000;
	points[88] = (11779.4092, 9110.0791, 4836.6143);
	angles[88] = (0, 0, 0);
	at[88] = 24.8000;
	points[89] = (11707.4023, 9218.8584, 4836.6143);
	angles[89] = (0, 0, 0);
	at[89] = 25;
	points[90] = (11629.7236, 9326.8896, 4836.6143);
	angles[90] = (0, 0, 0);
	at[90] = 25.2000;
	points[91] = (11549.6055, 9427.9531, 4836.6143);
	angles[91] = (0, 0, 0);
	at[91] = 25.4000;
	points[92] = (11459.6846, 9527.9531, 4836.6143);
	angles[92] = (0, 0, 0);
	at[92] = 25.6000;
	points[93] = (11364.5273, 9616.7725, 4836.6143);
	angles[93] = (0, 0, 0);
	at[93] = 25.8000;
	points[94] = (11259.1738, 9691.1416, 4836.6143);
	angles[94] = (0, 0, 0);
	at[94] = 26;
	points[95] = (11150.5518, 9740.5908, 4837.0474);
	angles[95] = (0, 0, 0);
	at[95] = 26.2000;
	points[96] = (11021.1025, 9784.2129, 4838.1890);
	angles[96] = (0, 0, 0);
	at[96] = 26.4000;
	points[97] = (10897.9922, 9818.7793, 4839.4883);
	angles[97] = (0, 0, 0);
	at[97] = 26.6000;
	points[98] = (10763.8584, 9852.0479, 4841.0234);
	angles[98] = (0, 0, 0);
	at[98] = 26.8000;
	points[99] = (10641.1416, 9879.6855, 4842.4409);
	angles[99] = (0, 0, 0);
	at[99] = 27;
	points[100] = (10379.6064, 9932.5596, 4845.4331);
	angles[100] = (0, 0, 0);
	at[100] = 27.4000;
	points[101] = (10252.9141, 9955.9844, 4846.8506);
	angles[101] = (0, 0, 0);
	at[101] = 27.6000;
	points[102] = (9990.8271, 10001.0234, 4849.5669);
	angles[102] = (0, 0, 0);
	at[102] = 28;
	points[103] = (9862.5986, 10021.6533, 4850.7876);
	angles[103] = (0, 0, 0);
	at[103] = 28.2000;
	points[104] = (9341.1816, 10098.3457, 4854.6064);
	angles[104] = (0, 0, 0);
	at[104] = 29;
	points[105] = (8948.7793, 10149.6055, 4855.8662);
	angles[105] = (0, 0, 0);
	at[105] = 29.6000;
	points[106] = (8688.7402, 10180.8662, 4855.5908);
	angles[106] = (0, 0, 0);
	at[106] = 30;
	points[107] = (8555.7090, 10196.0234, 4854.9609);
	angles[107] = (0, 0, 0);
	at[107] = 30.2000;
	points[108] = (8296.1416, 10223.7793, 4852.5591);
	angles[108] = (0, 0, 0);
	at[108] = 30.6000;
	points[109] = (8162.0083, 10237.0869, 4850.4331);
	angles[109] = (0, 0, 0);
	at[109] = 30.8000;
	points[110] = (8037.2051, 10248.7002, 4847.7168);
	angles[110] = (0, 0, 0);
	at[110] = 31;
	points[111] = (7898.8979, 10260.4326, 4843.5435);
	angles[111] = (0, 0, 0);
	at[111] = 31.2000;
	points[112] = (7773.8188, 10269.6855, 4838.0708);
	angles[112] = (0, 0, 0);
	at[112] = 31.4000;
	points[113] = (7658.9761, 10276.4570, 4830.7876);
	angles[113] = (0, 0, 0);
	at[113] = 31.6000;
	points[114] = (7523.5039, 10282.9531, 4820.1577);
	angles[114] = (0, 0, 0);
	at[114] = 31.8000;
	points[115] = (7265.0791, 10292.6387, 4796.6929);
	angles[115] = (0, 0, 0);
	at[115] = 32.2000;
	points[116] = (7127.1265, 10296.8115, 4783.1104);
	angles[116] = (0, 0, 0);
	at[116] = 32.4000;
	points[117] = (6871.3384, 10302.9531, 4756.7715);
	angles[117] = (0, 0, 0);
	at[117] = 32.8000;
	points[118] = (6737.2046, 10305.4727, 4742.4805);
	angles[118] = (0, 0, 0);
	at[118] = 33;
	points[119] = (6477.7954, 10309.0557, 4714.2124);
	angles[119] = (0, 0, 0);
	at[119] = 33.4000;
	points[120] = (6213.3071, 10310.9834, 4684.6851);
	angles[120] = (0, 0, 0);
	at[120] = 33.8000;
	points[121] = (5823.0713, 10310.4717, 4640.2363);
	angles[121] = (0, 0, 0);
	at[121] = 34.4000;
	points[122] = (5169.4878, 10299.1338, 4564.3306);
	angles[122] = (0, 0, 0);
	at[122] = 35.4000;
	points[123] = (4907.4019, 10289.7637, 4533.6616);
	angles[123] = (0, 0, 0);
	at[123] = 35.8000;
	points[124] = (4780.9053, 10283.9375, 4518.8188);
	angles[124] = (0, 0, 0);
	at[124] = 36;
	points[125] = (4645.2754, 10276.5352, 4502.9526);
	angles[125] = (0, 0, 0);
	at[125] = 36.2000;
	points[126] = (4514.2915, 10268.0703, 4487.6377);
	angles[126] = (0, 0, 0);
	at[126] = 36.4000;
	points[127] = (4389.2129, 10258.5430, 4473.1104);
	angles[127] = (0, 0, 0);
	at[127] = 36.6000;
	points[128] = (4253.7793, 10246.2207, 4457.4409);
	angles[128] = (0, 0, 0);
	at[128] = 36.8000;
	points[129] = (4123.1494, 10231.7314, 4442.4805);
	angles[129] = (0, 0, 0);
	at[129] = 37;
	points[130] = (4001.0237, 10215, 4428.6616);
	angles[130] = (0, 0, 0);
	at[130] = 37.2000;
	points[131] = (3862.5630, 10190.2363, 4413.4253);
	angles[131] = (0, 0, 0);
	at[131] = 37.4000;
	points[132] = (3749.4961, 10161.8896, 4401.6143);
	angles[132] = (0, 0, 0);
	at[132] = 37.6000;
	points[133] = (3633.1301, 10121.8506, 4390.0791);
	angles[133] = (0, 0, 0);
	at[133] = 37.8000;
	points[134] = (3505.5513, 10069.7637, 4377.8740);
	angles[134] = (0, 0, 0);
	at[134] = 38;
	points[135] = (3391.3032, 10018.1494, 4367.1260);
	angles[135] = (0, 0, 0);
	at[135] = 38.2000;
	points[136] = (3269.3938, 9959.1338, 4355.8267);
	angles[136] = (0, 0, 0);
	at[136] = 38.4000;
	points[137] = (3039.4724, 9839.2910, 4334.8818);
	angles[137] = (0, 0, 0);
	at[137] = 38.8000;
	points[138] = (2921.2795, 9774.0557, 4324.2124);
	angles[138] = (0, 0, 0);
	at[138] = 39;
	points[139] = (2809.5276, 9710.3545, 4314.2129);
	angles[139] = (0, 0, 0);
	at[139] = 39.2000;
	points[140] = (2582.9607, 9575.6299, 4294.0156);
	angles[140] = (0, 0, 0);
	at[140] = 39.6000;
	points[141] = (2251.4763, 9365.3936, 4264.7241);
	angles[141] = (0, 0, 0);
	at[141] = 40.2000;
	points[142] = (2033.1456, 9217.9131, 4245.5117);
	angles[142] = (0, 0, 0);
	at[142] = 40.6000;
	points[143] = (1819.6221, 9065.4326, 4226.6929);
	angles[143] = (0, 0, 0);
	at[143] = 41;
	points[144] = (1713.7717, 8986.1807, 4217.4019);
	angles[144] = (0, 0, 0);
	at[144] = 41.2000;
	points[145] = (1612.5787, 8907.6377, 4208.4644);
	angles[145] = (0, 0, 0);
	at[145] = 41.4000;
	points[146] = (1508.0787, 8823.0713, 4199.2129);
	angles[146] = (0, 0, 0);
	at[146] = 41.6000;
	points[147] = (1407.9567, 8737.7959, 4190.3149);
	angles[147] = (0, 0, 0);
	at[147] = 41.8000;
	points[148] = (1313.6812, 8652.4014, 4181.8506);
	angles[148] = (0, 0, 0);
	at[148] = 42;
	points[149] = (1215.9843, 8556.1416, 4172.9922);
	angles[149] = (0, 0, 0);
	at[149] = 42.2000;
	points[150] = (1133.6063, 8464.5674, 4165.3940);
	angles[150] = (0, 0, 0);
	at[150] = 42.4000;
	points[151] = (1051.6339, 8352.0469, 4157.5195);
	angles[151] = (0, 0, 0);
	at[151] = 42.6000;
	points[152] = (1004.7441, 8248.0312, 4152.3623);
	angles[152] = (0, 0, 0);
	at[152] = 42.8000;
	points[153] = (979.1536, 8112.9131, 4148.1890);
	angles[153] = (0, 0, 0);
	at[153] = 43;
	points[154] = (971.0040, 7988.5044, 4145.4331);
	angles[154] = (0, 0, 0);
	at[154] = 43.2000;
	points[155] = (971.3543, 7851.9688, 4143.1104);
	angles[155] = (0, 0, 0);
	at[155] = 43.4000;
	points[156] = (977.5591, 7723.3467, 4141.3779);
	angles[156] = (0, 0, 0);
	at[156] = 43.6000;
	points[157] = (988.0906, 7592.6377, 4139.9214);
	angles[157] = (0, 0, 0);
	at[157] = 43.8000;
	points[158] = (1002.4134, 7457.5986, 4138.7402);
	angles[158] = (0, 0, 0);
	at[158] = 44;
	points[159] = (1018.4528, 7330.5908, 4137.8345);
	angles[159] = (0, 0, 0);
	at[159] = 44.2000;
	points[160] = (1057.8466, 7067.7954, 4136.5747);
	angles[160] = (0, 0, 0);
	at[160] = 44.6000;
	points[161] = (1127.5000, 6680.0786, 4135.9448);
	angles[161] = (0, 0, 0);
	at[161] = 45.2000;
	points[162] = (1206.8190, 6294.9604, 4136.6533);
	angles[162] = (0, 0, 0);
	at[162] = 45.8000;
	points[163] = (1235.7441, 6163.7402, 4137.2441);
	angles[163] = (0, 0, 0);
	at[163] = 46;
	points[164] = (1293.8346, 5911.1025, 4138.9370);
	angles[164] = (0, 0, 0);
	at[164] = 46.4000;
	points[165] = (1325.6654, 5777.9526, 4140.1973);
	angles[165] = (0, 0, 0);
	at[165] = 46.6000;
	points[166] = (1388.6102, 5524.3701, 4143.4253);
	angles[166] = (0, 0, 0);
	at[166] = 47;
	points[167] = (1422.1812, 5394.1338, 4145.7876);
	angles[167] = (0, 0, 0);
	at[167] = 47.2000;
	points[168] = (1454.9843, 5270.3936, 4148.6616);
	angles[168] = (0, 0, 0);
	at[168] = 47.4000;
	points[169] = (1490.3308, 5141.7715, 4153.0317);
	angles[169] = (0, 0, 0);
	at[169] = 47.6000;
	points[170] = (1498.2245, 5113.9370, 4154.3306);
	angles[170] = (0, 0, 0);
	at[170] = 47.6500;
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
