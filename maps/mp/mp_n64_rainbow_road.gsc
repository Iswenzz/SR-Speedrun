main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_rainbow_road", 0);

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
	ambientPlay("iz_0_35", 2);
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
	level.iz_route[level.iz_route.size] = (-903, 576, 5935);
	level.iz_route[level.iz_route.size] = (460, -293, 5923);
	level.iz_route[level.iz_route.size] = (2021, -1253, 5293);
	level.iz_route[level.iz_route.size] = (3513, -2192, 3995);
	level.iz_route[level.iz_route.size] = (4745, -2968, 2958);
	level.iz_route[level.iz_route.size] = (6020, -3763, 2169);
	level.iz_route[level.iz_route.size] = (8074, -5032, 1892);
	level.iz_route[level.iz_route.size] = (10669, -6674, 2925);
	level.iz_route[level.iz_route.size] = (12700, -8105, 3918);
	level.iz_route[level.iz_route.size] = (13843, -9335, 4564);
	level.iz_route[level.iz_route.size] = (14371, -10724, 4996);
	level.iz_route[level.iz_route.size] = (14178, -11892, 5144);
	level.iz_route[level.iz_route.size] = (13476, -12713, 5138);
	level.iz_route[level.iz_route.size] = (12675, -13034, 5037);
	level.iz_route[level.iz_route.size] = (11779, -13081, 4893);
	level.iz_route[level.iz_route.size] = (10446, -12412, 4574);
	level.iz_route[level.iz_route.size] = (9664, -11166, 4316);
	level.iz_route[level.iz_route.size] = (9389, -9636, 4126);
	level.iz_route[level.iz_route.size] = (9443, -7224, 4045);
	level.iz_route[level.iz_route.size] = (9397, -4143, 3833);
	level.iz_route[level.iz_route.size] = (9343, -1795, 3771);
	level.iz_route[level.iz_route.size] = (8707, -3, 3749);
	level.iz_route[level.iz_route.size] = (7666, 1194, 3770);
	level.iz_route[level.iz_route.size] = (6206, 2793, 3901);
	level.iz_route[level.iz_route.size] = (5467, 3897, 4062);
	level.iz_route[level.iz_route.size] = (5190, 5179, 4272);
	level.iz_route[level.iz_route.size] = (5722, 6279, 4568);
	level.iz_route[level.iz_route.size] = (6741, 6808, 4929);
	level.iz_route[level.iz_route.size] = (7984, 6489, 5139);
	level.iz_route[level.iz_route.size] = (8831, 5600, 5178);
	level.iz_route[level.iz_route.size] = (9177, 4436, 5153);
	level.iz_route[level.iz_route.size] = (8842, 3163, 5082);
	level.iz_route[level.iz_route.size] = (7830, 2260, 5001);
	level.iz_route[level.iz_route.size] = (6252, 1494, 4869);
	level.iz_route[level.iz_route.size] = (5028, 1722, 4729);
	level.iz_route[level.iz_route.size] = (3928, 2508, 4752);
	level.iz_route[level.iz_route.size] = (2409, 4017, 4822);
	level.iz_route[level.iz_route.size] = (911, 5546, 4896);
	level.iz_route[level.iz_route.size] = (-696, 7268, 4602);
	level.iz_route[level.iz_route.size] = (-1395, 8207, 4600);
	level.iz_route[level.iz_route.size] = (-1895, 9218, 4610);
	level.iz_route[level.iz_route.size] = (-1842, 10294, 4634);
	level.iz_route[level.iz_route.size] = (-801, 11452, 4728);
	level.iz_route[level.iz_route.size] = (439, 12241, 4979);
	level.iz_route[level.iz_route.size] = (1639, 13333, 5332);
	level.iz_route[level.iz_route.size] = (2407, 14537, 5665);
	level.iz_route[level.iz_route.size] = (2335, 15827, 5810);
	level.iz_route[level.iz_route.size] = (1539, 16799, 5788);
	level.iz_route[level.iz_route.size] = (264, 16992, 5631);
	level.iz_route[level.iz_route.size] = (-976, 16419, 5414);
	level.iz_route[level.iz_route.size] = (-2131, 15424, 5227);
	level.iz_route[level.iz_route.size] = (-3175, 14158, 5077);
	level.iz_route[level.iz_route.size] = (-4505, 12448, 4916);
	level.iz_route[level.iz_route.size] = (-5689, 11183, 4822);
	level.iz_route[level.iz_route.size] = (-6929, 10564, 4782);
	level.iz_route[level.iz_route.size] = (-8707, 10691, 4885);
	level.iz_route[level.iz_route.size] = (-10016, 11026, 5039);
	level.iz_route[level.iz_route.size] = (-11399, 11225, 5234);
	level.iz_route[level.iz_route.size] = (-12494, 10924, 5336);
	level.iz_route[level.iz_route.size] = (-13226, 10072, 5321);
	level.iz_route[level.iz_route.size] = (-13214, 8846, 5112);
	level.iz_route[level.iz_route.size] = (-12531, 7527, 4757);
	level.iz_route[level.iz_route.size] = (-11713, 6193, 4434);
	level.iz_route[level.iz_route.size] = (-10865, 4520, 4201);
	level.iz_route[level.iz_route.size] = (-10701, 3198, 4038);
	level.iz_route[level.iz_route.size] = (-11307, 2247, 3988);
	level.iz_route[level.iz_route.size] = (-12442, 2115, 4089);
	level.iz_route[level.iz_route.size] = (-13620, 2843, 4279);
	level.iz_route[level.iz_route.size] = (-15024, 4216, 4634);
	level.iz_route[level.iz_route.size] = (-16418, 5077, 4984);
	level.iz_route[level.iz_route.size] = (-17839, 5196, 5329);
	level.iz_route[level.iz_route.size] = (-19089, 4586, 5648);
	level.iz_route[level.iz_route.size] = (-19678, 3741, 5863);
	level.iz_route[level.iz_route.size] = (-19695, 2857, 6026);
	level.iz_route[level.iz_route.size] = (-19215, 2116, 6111);
	level.iz_route[level.iz_route.size] = (-18318, 1648, 6089);
	level.iz_route[level.iz_route.size] = (-17116, 1675, 5973);
	level.iz_route[level.iz_route.size] = (-16051, 2180, 5882);
	level.iz_route[level.iz_route.size] = (-14993, 2990, 5844);
	level.iz_route[level.iz_route.size] = (-13599, 4027, 5812);
	level.iz_route[level.iz_route.size] = (-12164, 4928, 5826);
	level.iz_route[level.iz_route.size] = (-10456, 5662, 5890);
	level.iz_route[level.iz_route.size] = (-9193, 5543, 5974);
	level.iz_route[level.iz_route.size] = (-7691, 4824, 6056);
	level.iz_route[level.iz_route.size] = (-5983, 3734, 5923);
	level.iz_route[level.iz_route.size] = (-4191, 2623, 5921);
	level.iz_route[level.iz_route.size] = (-2301, 1435, 5935);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (9433.4248, -10530.6299, 4219.5278);
	angles[0] = (0, 17.5512, 0);
	at[0] = 0;
	points[1] = (9471.7324, -10652.7559, 4238.3071);
	angles[1] = (0, -36.7890, 0);
	at[1] = 0.3667;
	points[2] = (9509.6064, -10775.7871, 4257.0864);
	angles[2] = (0, -161.5516, 0);
	at[2] = 0.7333;
	points[3] = (9626.2598, -11144.1738, 4313.9370);
	angles[3] = (0, -161.5473, 0);
	at[3] = 1.8333;
	points[4] = (9669.9609, -11264.4092, 4333.7007);
	angles[4] = (0, -158.7045, 0);
	at[4] = 2.2000;
	points[5] = (9721.4170, -11381.4561, 4354.9214);
	angles[5] = (0, -155.7131, 0);
	at[5] = 2.5667;
	points[6] = (9831.9297, -11612.8750, 4398.8979);
	angles[6] = (0, -153.7290, 0);
	at[6] = 3.3000;
	points[7] = (9951.1025, -11839.8818, 4443.8584);
	angles[7] = (0, -150.9285, 0);
	at[7] = 4.0333;
	points[8] = (10017.4404, -11947.1260, 4466.6143);
	angles[8] = (0, -146.0290, 0);
	at[8] = 4.4000;
	points[9] = (10096.4570, -12048.7402, 4490.2363);
	angles[9] = (0, -141.2246, 0);
	at[9] = 4.7667;
	points[10] = (10262.0479, -12243.2676, 4537.4019);
	angles[10] = (0, -138.7901, 0);
	at[10] = 5.5000;
	points[11] = (10434.2520, -12432.5205, 4585.3940);
	angles[11] = (0, -136.8350, 0);
	at[11] = 6.2333;
	points[12] = (10524.3701, -12525.0791, 4610.2363);
	angles[12] = (0, -135.1021, 0);
	at[12] = 6.6000;
	points[13] = (10616.1016, -12608.4248, 4635.1182);
	angles[13] = (0, -129.8384, 0);
	at[13] = 6.9667;
	points[14] = (10720.8262, -12682.7959, 4663.2285);
	angles[14] = (0, -124.2138, 0);
	at[14] = 7.3333;
	points[15] = (10826.8896, -12750.9844, 4691.5356);
	angles[15] = (0, -122.2196, 0);
	at[15] = 7.7000;
	points[16] = (11045.5908, -12880.8672, 4749.1733);
	angles[16] = (0, -119.7052, 0);
	at[16] = 8.4333;
	points[17] = (11156.7715, -12941.8506, 4777.9136);
	angles[17] = (0, -118.2612, 0);
	at[17] = 8.8000;
	points[18] = (11271.3389, -12999.6465, 4806.7324);
	angles[18] = (0, -115.8522, 0);
	at[18] = 9.1667;
	points[19] = (11385.3154, -13044.9219, 4833.3467);
	angles[19] = (0, -108.2731, 0);
	at[19] = 9.5333;
	points[20] = (11510.6299, -13074.5273, 4859.3311);
	angles[20] = (0, -101.9802, 0);
	at[20] = 9.9000;
	points[21] = (11636.2207, -13097.3623, 4884.2915);
	angles[21] = (0, -99.7105, 0);
	at[21] = 10.2667;
	points[22] = (11889.8428, -13133.0322, 4933.2676);
	angles[22] = (0, -96.9252, 0);
	at[22] = 11;
	points[23] = (12017.8740, -13146.3389, 4957.3623);
	angles[23] = (0, -95.3940, 0);
	at[23] = 11.3667;
	points[24] = (12145, -13154.8027, 4980.7090);
	angles[24] = (0, -92.8434, 0);
	at[24] = 11.7333;
	points[25] = (12270.7480, -13151.2197, 5002.3623);
	angles[25] = (0, -85.4961, 0);
	at[25] = 12.1000;
	points[26] = (12397.8350, -13134.0557, 5022.6377);
	angles[26] = (0, -81.4801, 0);
	at[26] = 12.4667;
	points[27] = (12651.8896, -13088.2676, 5061.6533);
	angles[27] = (0, -78.9204, 0);
	at[27] = 13.2000;
	points[28] = (12903.5039, -13034.1729, 5099.3306);
	angles[28] = (0, -77.0843, 0);
	at[28] = 13.9333;
	points[29] = (13030.3154, -13002.9531, 5117.8345);
	angles[29] = (0, -75.6364, 0);
	at[29] = 14.3000;
	points[30] = (13150.3936, -12966.7324, 5134.7241);
	angles[30] = (0, -70.9614, 0);
	at[30] = 14.6667;
	points[31] = (13268.3467, -12912.8350, 5149.5278);
	angles[31] = (0, -63.8314, 0);
	at[31] = 15.0333;
	points[32] = (13382.5195, -12851.6934, 5162.9531);
	angles[32] = (0, -61.1215, 0);
	at[32] = 15.4000;
	points[33] = (13494.8818, -12786.5742, 5175.6299);
	angles[33] = (0, -59.3904, 0);
	at[33] = 15.7667;
	points[34] = (13605.1963, -12718.4648, 5187.4800);
	angles[34] = (0, -57.7644, 0);
	at[34] = 16.1333;
	points[35] = (13713.7402, -12645.9844, 5198.3071);
	angles[35] = (0, -55.3675, 0);
	at[35] = 16.5000;
	points[36] = (13812.4414, -12565.2373, 5205.5117);
	angles[36] = (0, -47.5449, 0);
	at[36] = 16.8667;
	points[37] = (13902.5596, -12471.3389, 5208.7402);
	angles[37] = (0, -42.7832, 0);
	at[37] = 17.2333;
	points[38] = (13988.0713, -12373.4258, 5210.3149);
	angles[38] = (0, -40.4369, 0);
	at[38] = 17.6000;
	points[39] = (14070.1191, -12271.8896, 5210.5903);
	angles[39] = (0, -38.2067, 0);
	at[39] = 17.9667;
	points[40] = (14146.9688, -12166.5352, 5209.1338);
	angles[40] = (0, -34.8558, 0);
	at[40] = 18.3333;
	points[41] = (14208.8184, -12056.4180, 5203.5830);
	angles[41] = (0, -25.3309, 0);
	at[41] = 18.7000;
	points[42] = (14255.2363, -11934.6846, 5192.7559);
	angles[42] = (0, -19.8251, 0);
	at[42] = 19.0667;
	points[43] = (14334.6064, -11687.0078, 5167.5591);
	angles[43] = (0, -16.6740, 0);
	at[43] = 19.8000;
	points[44] = (14401.7314, -11436.6533, 5139.2124);
	angles[44] = (0, -13.5828, 0);
	at[44] = 20.5333;
	points[45] = (14427.4014, -11309.0557, 5122.8740);
	angles[45] = (0, -9.8418, 0);
	at[45] = 20.9000;
	points[46] = (14435.5117, -11185.2363, 5103.6221);
	angles[46] = (0, -1.4333, 0);
	at[46] = 21.2667;
	points[47] = (14433.7402, -11056.4180, 5081.6538);
	angles[47] = (0, 1.4376, 0);
	at[47] = 21.6333;
	points[48] = (14420.3545, -10799.7637, 5035.6299);
	angles[48] = (0, 3.8485, 0);
	at[48] = 22.3667;
	points[49] = (14397.7168, -10544.1348, 4987.0078);
	angles[49] = (0, 6.0121, 0);
	at[49] = 23.1000;
	points[50] = (14381.6543, -10417.5205, 4961.0630);
	angles[50] = (0, 8.0012, 0);
	at[50] = 23.4667;
	points[51] = (14357.0869, -10297.4404, 4932.5200);
	angles[51] = (0, 14.2960, 0);
	at[51] = 23.8333;
	points[52] = (14317.6377, -10177.1260, 4898.1104);
	angles[52] = (0, 19.2231, 0);
	at[52] = 24.2000;
	points[53] = (14273.5439, -10060.0791, 4862.4409);
	angles[53] = (0, 21.1742, 0);
	at[53] = 24.5667;
	points[54] = (14177.2832, -9829.3301, 4788.3857);
	angles[54] = (0, 23.5596, 0);
	at[54] = 25.3000;
	points[55] = (14071.2207, -9603.1494, 4710.9844);
	angles[55] = (0, 26.5204, 0);
	at[55] = 26.0333;
	points[56] = (14013.5039, -9498.9766, 4671.4175);
	angles[56] = (0, 30.9347, 0);
	at[56] = 26.4000;
	points[57] = (13943.9365, -9396.7324, 4626.8110);
	angles[57] = (0, 35.1192, 0);
	at[57] = 26.7667;
	points[58] = (13797.8740, -9201.0234, 4535.8267);
	angles[58] = (0, 37.4837, 0);
	at[58] = 27.5000;
	points[59] = (13646.9688, -9009.7646, 4443.5435);
	angles[59] = (0, 38.7961, 0);
	at[59] = 28.2333;
	points[60] = (13491.0234, -8821.8896, 4350.1968);
	angles[60] = (0, 40.4574, 0);
	at[60] = 28.9667;
	points[61] = (13410.8662, -8731.5752, 4303.7012);
	angles[61] = (0, 42.3788, 0);
	at[61] = 29.3333;
	points[62] = (13328.6221, -8647.4805, 4258.1104);
	angles[62] = (0, 44.9613, 0);
	at[62] = 29.7000;
	points[63] = (13153.6611, -8478.6221, 4163.4253);
	angles[63] = (0, 46.5065, 0);
	at[63] = 30.4333;
	points[64] = (12975.8271, -8312.8350, 4068.3857);
	angles[64] = (0, 47.3373, 0);
	at[64] = 31.1667;
	points[65] = (12796.0244, -8149.9609, 3973.1890);
	angles[65] = (0, 48.1935, 0);
	at[65] = 31.9000;
	points[66] = (12612.7168, -7990.2363, 3877.2283);
	angles[66] = (0, 49.5754, 0);
	at[66] = 32.6333;
	points[67] = (12519.2529, -7913.1104, 3828.9724);
	angles[67] = (0, 51.0344, 0);
	at[67] = 33;
	points[68] = (12428.3467, -7844.0161, 3782.9331);
	angles[68] = (0, 53.4849, 0);
	at[68] = 33.3667;
	points[69] = (12130.5117, -7634.4487, 3634.5471);
	angles[69] = (0, 55.3860, 0);
	at[69] = 34.4667;
	points[70] = (11932.1260, -7498.6616, 3536.3425);
	angles[70] = (0, 55.7378, 0);
	at[70] = 35.2000;
	points[71] = (11332.4805, -7094.3706, 3241.2954);
	angles[71] = (0, 56.1591, 0);
	at[71] = 37.4000;
	points[72] = (11129.1338, -6958.0312, 3142.2322);
	angles[72] = (0, 56.1230, 0);
	at[72] = 38.1333;
	points[73] = (11034.6855, -6894.6455, 3096.9685);
	angles[73] = (0, 56.2107, 0);
	at[73] = 38.5000;
	points[74] = (9919.8818, -6159.5273, 2577.5825);
	angles[74] = (0, 56.5995, 0);
	at[74] = 42.5333;
	points[75] = (9994.2129, -6208.5039, 2612.1968);
	angles[75] = (0, 58.6990, 0);
	at[75] = 42.9000;
	points[76] = (10095.1572, -6274.9609, 2659.0747);
	angles[76] = (0, 223.7411, 0);
	at[76] = 43.2667;
	points[77] = (10196.4180, -6341.4966, 2706.0393);
	angles[77] = (0, 236.5880, 0);
	at[77] = 43.6333;
	points[78] = (10704.2920, -6675.7090, 2941.9058);
	angles[78] = (0, 236.5994, 0);
	at[78] = 45.4667;
	points[79] = (11105.3545, -6942.0474, 3130.7522);
	angles[79] = (0, 236.0941, 0);
	at[79] = 46.9333;
	points[80] = (11404.2129, -7142.4409, 3276.4136);
	angles[80] = (0, 236.1494, 0);
	at[80] = 48.0333;
	points[81] = (11905.7090, -7480.7085, 3523.2915);
	angles[81] = (0, 235.8136, 0);
	at[81] = 49.8667;
	points[82] = (12205.1572, -7686.0630, 3671.5945);
	angles[82] = (0, 235.2879, 0);
	at[82] = 50.9667;
	points[83] = (12400.0791, -7823.5039, 3768.7639);
	angles[83] = (0, 234.3178, 0);
	at[83] = 51.7000;
	points[84] = (12495.7881, -7894.6060, 3816.9961);
	angles[84] = (0, 232.6344, 0);
	at[84] = 52.0667;
	points[85] = (12588.6621, -7969.9604, 3864.7402);
	angles[85] = (0, 230.3580, 0);
	at[85] = 52.4333;
	points[86] = (12772.2832, -8128.8589, 3960.7085);
	angles[86] = (0, 228.5302, 0);
	at[86] = 53.1667;
	points[87] = (13041.4561, -8373.5039, 4103.3467);
	angles[87] = (0, 227.1921, 0);
	at[87] = 54.2667;
	points[88] = (13218.5439, -8540.3545, 4198.3071);
	angles[88] = (0, 226.3197, 0);
	at[88] = 55;
	points[89] = (13391.3779, -8710.9844, 4292.7559);
	angles[89] = (0, 224.2737, 0);
	at[89] = 55.7333;
	points[90] = (13470.1572, -8797.7559, 4337.9526);
	angles[90] = (0, 221.4421, 0);
	at[90] = 56.1000;
	points[91] = (13702.7949, -9079.5273, 4477.5195);
	angles[91] = (0, 218.5611, 0);
	at[91] = 57.2000;
	points[92] = (13852.4404, -9272.5586, 4569.5669);
	angles[92] = (0, 217.1930, 0);
	at[92] = 57.9333;
	points[93] = (13995.3936, -9471.0635, 4659.6460);
	angles[93] = (0, 214.1899, 0);
	at[93] = 58.6667;
	points[94] = (14056.7715, -9575.1572, 4700.8267);
	angles[94] = (0, 208.6305, 0);
	at[94] = 59.0333;
	points[95] = (14111.4961, -9685.2363, 4739.8423);
	angles[95] = (0, 205.7599, 0);
	at[95] = 59.4000;
	points[96] = (14163.7012, -9798.7002, 4778.2285);
	angles[96] = (0, 204.2920, 0);
	at[96] = 59.7667;
	points[97] = (14261.1025, -10028.8184, 4852.6382);
	angles[97] = (0, 202.0212, 0);
	at[97] = 60.5000;
	points[98] = (14306.3779, -10146.1416, 4888.8188);
	angles[98] = (0, 200.5844, 0);
	at[98] = 60.8667;
	points[99] = (14347.0479, -10263.9756, 4923.3071);
	angles[99] = (0, 198.0695, 0);
	at[99] = 61.2333;
	points[100] = (14376.3389, -10384.2529, 4953.8193);
	angles[100] = (0, 190.9689, 0);
	at[100] = 61.6000;
	points[101] = (14393.8984, -10510.4727, 4980.3149);
	angles[101] = (0, 187.0965, 0);
	at[101] = 61.9667;
	points[102] = (14417.8740, -10765.6299, 5029.3311);
	angles[102] = (0, 184.4587, 0);
	at[102] = 62.7000;
	points[103] = (14432.5596, -11021.3779, 5075.5117);
	angles[103] = (0, 182.3850, 0);
	at[103] = 63.4333;
	points[104] = (14435.5508, -11150.7881, 5097.8350);
	angles[104] = (0, 180.7166, 0);
	at[104] = 63.8000;
	points[105] = (14431.4961, -11277.0859, 5118.3071);
	angles[105] = (0, 175.9896, 0);
	at[105] = 64.1667;
	points[106] = (14409.3311, -11403.3076, 5135.1187);
	angles[106] = (0, 168.3308, 0);
	at[106] = 64.5333;
	points[107] = (14378.7803, -11528.9365, 5150.0396);
	angles[107] = (0, 165.6633, 0);
	at[107] = 64.9000;
	points[108] = (14344.2920, -11653.8584, 5163.9761);
	angles[108] = (0, 164.1309, 0);
	at[108] = 65.2667;
	points[109] = (14266.6924, -11901.5361, 5189.5669);
	angles[109] = (0, 161.4651, 0);
	at[109] = 66;
	points[110] = (14222.2441, -12023.7012, 5200.9053);
	angles[110] = (0, 159.0760, 0);
	at[110] = 66.3667;
	points[111] = (14165.6699, -12137.9521, 5208.2676);
	angles[111] = (0, 149.7495, 0);
	at[111] = 66.7333;
	points[112] = (14090.9053, -12244.6855, 5210.4331);
	angles[112] = (0, 143.6594, 0);
	at[112] = 67.1000;
	points[113] = (14010.3154, -12346.6924, 5210.5518);
	angles[113] = (0, 140.9250, 0);
	at[113] = 67.4667;
	points[114] = (13925.4326, -12445.9062, 5209.2910);
	angles[114] = (0, 138.7731, 0);
	at[114] = 67.8333;
	points[115] = (13836.5352, -12541.3379, 5206.5747);
	angles[115] = (0, 136.0536, 0);
	at[115] = 68.2000;
	points[116] = (13741.3389, -12625.9854, 5200.7876);
	angles[116] = (0, 128.4395, 0);
	at[116] = 68.5667;
	points[117] = (13634.4092, -12699.6064, 5190.5122);
	angles[117] = (0, 123.5657, 0);
	at[117] = 68.9333;
	points[118] = (13524.4492, -12768.7402, 5178.8584);
	angles[118] = (0, 121.6110, 0);
	at[118] = 69.3000;
	points[119] = (13412.6777, -12834.6455, 5166.4175);
	angles[119] = (0, 120.0173, 0);
	at[119] = 69.6667;
	points[120] = (13298.7002, -12897.2041, 5153.1494);
	angles[120] = (0, 118.0830, 0);
	at[120] = 70.0333;
	points[121] = (13182.4414, -12953.6221, 5138.8975);
	angles[121] = (0, 114.4609, 0);
	at[121] = 70.4000;
	points[122] = (13063.1104, -12994.1338, 5122.5596);
	angles[122] = (0, 106.3569, 0);
	at[122] = 70.7667;
	points[123] = (12811.7725, -13054.8818, 5085.7090);
	angles[123] = (0, 102.5385, 0);
	at[123] = 71.5000;
	points[124] = (12559.1348, -13106.1416, 5047.5586);
	angles[124] = (0, 100.7372, 0);
	at[124] = 72.2333;
	points[125] = (12304.1738, -13147.3623, 5007.7954);
	angles[125] = (0, 97.6023, 0);
	at[125] = 72.9667;
	points[126] = (12180.4326, -13155.7090, 4987.0474);
	angles[126] = (0, 90.9854, 0);
	at[126] = 73.3333;
	points[127] = (12051.6143, -13149.1338, 4963.6221);
	angles[127] = (0, 85.9968, 0);
	at[127] = 73.7000;
	points[128] = (11796.8516, -13121.3389, 4915.5117);
	angles[128] = (0, 82.5889, 0);
	at[128] = 74.4333;
	points[129] = (11543.5830, -13080.9453, 4865.9448);
	angles[129] = (0, 79.6130, 0);
	at[129] = 75.1667;
	points[130] = (11420.0391, -13054.2520, 4840.7480);
	angles[130] = (0, 76.6378, 0);
	at[130] = 75.5333;
	points[131] = (11300.5508, -13013.0322, 4813.8584);
	angles[131] = (0, 67.6013, 0);
	at[131] = 75.9000;
	points[132] = (11187.5596, -12958.0322, 4785.7480);
	angles[132] = (0, 63.0677, 0);
	at[132] = 76.2667;
	points[133] = (11075.1191, -12897.4414, 4756.8506);
	angles[133] = (0, 61.1563, 0);
	at[133] = 76.6333;
	points[134] = (10855.6299, -12768.7793, 4699.1733);
	angles[134] = (0, 58.6360, 0);
	at[134] = 77.3667;
	points[135] = (10748.0312, -12700.7480, 4670.5117);
	angles[135] = (0, 57.1854, 0);
	at[135] = 77.7333;
	points[136] = (10642.9922, -12628.7402, 4642.3623);
	angles[136] = (0, 54.5473, 0);
	at[136] = 78.1000;
	points[137] = (10548.4648, -12548.5039, 4616.8110);
	angles[137] = (0, 47.2485, 0);
	at[137] = 78.4667;
	points[138] = (10458.3467, -12457.8740, 4592.0864);
	angles[138] = (0, 44.1322, 0);
	at[138] = 78.8333;
	points[139] = (10370.3936, -12363.8975, 4567.7163);
	angles[139] = (0, 42.7333, 0);
	at[139] = 79.2000;
	points[140] = (10200.1582, -12172.2051, 4519.9604);
	angles[140] = (0, 40.8804, 0);
	at[140] = 79.9333;
	points[141] = (10037.0869, -11973.7002, 4472.6382);
	angles[141] = (0, 37.8158, 0);
	at[141] = 80.6667;
	points[142] = (9968.5439, -11870.1963, 4450.1182);
	angles[142] = (0, 31.3289, 0);
	at[142] = 81.0333;
	points[143] = (9905.9443, -11757.2441, 4427.2441);
	angles[143] = (0, 28.3083, 0);
	at[143] = 81.4000;
	points[144] = (9790.5508, -11528.4648, 4382.6772);
	angles[144] = (0, 25.9360, 0);
	at[144] = 82.1333;
	points[145] = (9682.5586, -11294.2119, 4338.9766);
	angles[145] = (0, 23.6722, 0);
	at[145] = 82.8667;
	points[146] = (9637.6768, -11177.4414, 4319.2520);
	angles[146] = (0, 19.7154, 0);
	at[146] = 83.2333;
	points[147] = (9596.8115, -11054.8027, 4299.9214);
	angles[147] = (0, 18.0549, 0);
	at[147] = 83.6000;
	points[148] = (9443.3467, -10561.7725, 4224.3701);
	angles[148] = (0, 17.4306, 0);
	at[148] = 85.0667;
	points[149] = (9433.4248, -10530.6299, 4219.5278);
	angles[149] = (0, 17.5512, 0);
	at[149] = 85.1667;
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
	points[0] = (-4954.3306, 11960, 4871.2202);
	angles[0] = (0, 141.4514, 0);
	at[0] = 0;
	points[1] = (-4847.8350, 12093.5830, 4882.0474);
	angles[1] = (0, 110.9118, 0);
	at[1] = 0.4833;
	points[2] = (-4741.4565, 12226.8896, 4892.8345);
	angles[2] = (0, -38.2341, 0);
	at[2] = 0.9667;
	points[3] = (-4421.0234, 12629.2910, 4925.6299);
	angles[3] = (0, -38.4086, 0);
	at[3] = 2.4167;
	points[4] = (-4317.2046, 12761.4561, 4937.0474);
	angles[4] = (0, -37.9979, 0);
	at[4] = 2.9000;
	points[5] = (-3896.7087, 13304.1729, 4986.8506);
	angles[5] = (0, -37.6243, 0);
	at[5] = 4.8333;
	points[6] = (-3794.2676, 13437.8740, 4999.6064);
	angles[6] = (0, -37.3048, 0);
	at[6] = 5.3167;
	points[7] = (-3277.7363, 14119.2920, 5067.5981);
	angles[7] = (0, -37.4561, 0);
	at[7] = 7.7333;
	points[8] = (-2965.9133, 14524.3311, 5112.3228);
	angles[8] = (0, -37.8248, 0);
	at[8] = 9.1833;
	points[9] = (-2752.4961, 14792.7559, 5143.6221);
	angles[9] = (0, -39.4718, 0);
	at[9] = 10.1500;
	points[10] = (-2643.1377, 14918.8975, 5159.8823);
	angles[10] = (0, -41.3651, 0);
	at[10] = 10.6333;
	points[11] = (-2529.4373, 15046.4961, 5176.9292);
	angles[11] = (0, -41.8482, 0);
	at[11] = 11.1167;
	points[12] = (-2299.5747, 15299.9600, 5211.5356);
	angles[12] = (0, -42.4775, 0);
	at[12] = 12.0833;
	points[13] = (-2064.8228, 15550.4727, 5247.2441);
	angles[13] = (0, -44.0642, 0);
	at[13] = 13.0500;
	points[14] = (-1944.9330, 15665.0791, 5265.7085);
	angles[14] = (0, -47.2817, 0);
	at[14] = 13.5333;
	points[15] = (-1818.0157, 15779.2129, 5285.2759);
	angles[15] = (0, -48.3277, 0);
	at[15] = 14.0167;
	points[16] = (-1431.2834, 16115.9053, 5346.9688);
	angles[16] = (0, -49.2917, 0);
	at[16] = 15.4667;
	points[17] = (-1304.4685, 16225.0391, 5370.7876);
	angles[17] = (0, -49.1350, 0);
	at[17] = 15.9500;
	points[18] = (-919.3661, 16555.4336, 5457.4409);
	angles[18] = (0, -50.0956, 0);
	at[18] = 17.4000;
	points[19] = (-788.3898, 16661.7715, 5487.3232);
	angles[19] = (0, -51.5930, 0);
	at[19] = 17.8833;
	points[20] = (-652.7795, 16757.4414, 5516.9683);
	angles[20] = (0, -57.8992, 0);
	at[20] = 18.3667;
	points[21] = (-504.6772, 16840.5508, 5548.2285);
	angles[21] = (0, -61.6302, 0);
	at[21] = 18.8500;
	points[22] = (-354.6736, 16917.5586, 5579.4092);
	angles[22] = (0, -63.4480, 0);
	at[22] = 19.3333;
	points[23] = (-201.5984, 16990, 5610.4331);
	angles[23] = (0, -65.4713, 0);
	at[23] = 19.8167;
	points[24] = (-44.8244, 17054.5273, 5640.4727);
	angles[24] = (0, -69.3375, 0);
	at[24] = 20.3000;
	points[25] = (116.8803, 17090, 5664.9604);
	angles[25] = (0, -83.6434, 0);
	at[25] = 20.7833;
	points[26] = (287.7910, 17096.8516, 5684.1338);
	angles[26] = (0, -89.0305, 0);
	at[26] = 21.2667;
	points[27] = (458.7992, 17095.4336, 5701.9292);
	angles[27] = (0, -91.1455, 0);
	at[27] = 21.7500;
	points[28] = (629.8425, 17088.8594, 5719.2129);
	angles[28] = (0, -92.8183, 0);
	at[28] = 22.2333;
	points[29] = (800.8307, 17076.3770, 5736.6934);
	angles[29] = (0, -95.1649, 0);
	at[29] = 22.7167;
	points[30] = (965.1850, 17048.7793, 5755.9053);
	angles[30] = (0, -102.6969, 0);
	at[30] = 23.2000;
	points[31] = (1129.8544, 17004.0156, 5777.9136);
	angles[31] = (0, -106.1596, 0);
	at[31] = 23.6833;
	points[32] = (1292.5946, 16952.7559, 5799.9209);
	angles[32] = (0, -108.2237, 0);
	at[32] = 24.1667;
	points[33] = (1452.7047, 16895.3945, 5820.9844);
	angles[33] = (0, -110.6985, 0);
	at[33] = 24.6500;
	points[34] = (1609.1495, 16826.8906, 5839.5669);
	angles[34] = (0, -116.2163, 0);
	at[34] = 25.1333;
	points[35] = (1742.9724, 16724.8828, 5847.2832);
	angles[35] = (0, -132.5172, 0);
	at[35] = 25.6167;
	points[36] = (1863.0708, 16602.0469, 5848.5830);
	angles[36] = (0, -136.7643, 0);
	at[36] = 26.1000;
	points[37] = (1978.1654, 16473.8594, 5848.1895);
	angles[37] = (0, -138.7189, 0);
	at[37] = 26.5833;
	points[38] = (2088.8347, 16343.1494, 5846.8110);
	angles[38] = (0, -140.3474, 0);
	at[38] = 27.0667;
	points[39] = (2194.5906, 16208.7803, 5844.6064);
	angles[39] = (0, -142.9911, 0);
	at[39] = 27.5500;
	points[40] = (2280.5039, 16061.5361, 5840.1572);
	angles[40] = (0, -153.9941, 0);
	at[40] = 28.0333;
	points[41] = (2345.9802, 15903.2275, 5833.1890);
	angles[41] = (0, -158.9901, 0);
	at[41] = 28.5167;
	points[42] = (2401.3228, 15741.1426, 5824.5273);
	angles[42] = (0, -162.3912, 0);
	at[42] = 29;
	points[43] = (2443.7363, 15575.7480, 5812.9922);
	angles[43] = (0, -168.4544, 0);
	at[43] = 29.4833;
	points[44] = (2464.1023, 15408.1504, 5796.8110);
	angles[44] = (0, -174.2327, 0);
	at[44] = 29.9667;
	points[45] = (2478.1614, 15237.0469, 5779.1338);
	angles[45] = (0, -175.8148, 0);
	at[45] = 30.4500;
	points[46] = (2488.0591, 15066.6533, 5760.6304);
	angles[46] = (0, -177.1883, 0);
	at[46] = 30.9333;
	points[47] = (2493.0237, 14895.5508, 5740.9844);
	angles[47] = (0, -179.1315, 0);
	at[47] = 31.4167;
	points[48] = (2487.7559, 14724.5674, 5718.9370);
	angles[48] = (0, -184.1598, 0);
	at[48] = 31.9000;
	points[49] = (2450.1025, 14563.7402, 5690.5508);
	angles[49] = (0, -196.6326, 0);
	at[49] = 32.3833;
	points[50] = (2395.1182, 14404.7246, 5658.4253);
	angles[50] = (0, -200.0222, 0);
	at[50] = 32.8667;
	points[51] = (2333.9055, 14247.2842, 5625);
	angles[51] = (0, -201.8653, 0);
	at[51] = 33.3500;
	points[52] = (2268.3503, 14092.2832, 5590.7871);
	angles[52] = (0, -203.5604, 0);
	at[52] = 33.8333;
	points[53] = (2196.8503, 13939.3701, 5555.1572);
	angles[53] = (0, -206.1814, 0);
	at[53] = 34.3167;
	points[54] = (2111.3818, 13799.8818, 5516.8506);
	angles[54] = (0, -215.9066, 0);
	at[54] = 34.8000;
	points[55] = (2005.4292, 13671.4971, 5473.5830);
	angles[55] = (0, -220.6992, 0);
	at[55] = 35.2833;
	points[56] = (1781.1497, 13426.7324, 5385.2363);
	angles[56] = (0, -223.4435, 0);
	at[56] = 36.2500;
	points[57] = (1666.1497, 13307.5195, 5341.3384);
	angles[57] = (0, -224.2629, 0);
	at[57] = 36.7333;
	points[58] = (1551.2520, 13192.5195, 5299.8032);
	angles[58] = (0, -225.7106, 0);
	at[58] = 37.2167;
	points[59] = (1428.2954, 13078.4648, 5259.5273);
	angles[59] = (0, -227.6174, 0);
	at[59] = 37.7000;
	points[60] = (1178.0513, 12855.5518, 5180.7085);
	angles[60] = (0, -228.7010, 0);
	at[60] = 38.6667;
	points[61] = (923.8071, 12637.0469, 5103.3467);
	angles[61] = (0, -230.0609, 0);
	at[61] = 39.6333;
	points[62] = (794.3307, 12535.6699, 5067.0474);
	angles[62] = (0, -232.9579, 0);
	at[62] = 40.1167;
	points[63] = (658.9331, 12436.2988, 5031.0630);
	angles[63] = (0, -234.0112, 0);
	at[63] = 40.6000;
	points[64] = (245.9134, 12144.6855, 4927.0474);
	angles[64] = (0, -235.4341, 0);
	at[64] = 42.0500;
	points[65] = (-33.0068, 11960.3945, 4866.6533);
	angles[65] = (0, -236.9185, 0);
	at[65] = 43.0167;
	points[66] = (-317.7835, 11776.0234, 4808.4648);
	angles[66] = (0, -237.1677, 0);
	at[66] = 43.9833;
	points[67] = (-460.7992, 11683.8975, 4781.0239);
	angles[67] = (0, -237.2505, 0);
	at[67] = 44.4667;
	points[68] = (-600.4724, 11594.8828, 4758.3071);
	angles[68] = (0, -238.0682, 0);
	at[68] = 44.9500;
	points[69] = (-1042.5000, 11332.0859, 4713.1104);
	angles[69] = (0, -238.7509, 0);
	at[69] = 46.4000;
	points[70] = (-1188.0079, 11240.7090, 4700.0391);
	angles[70] = (0, -237.2186, 0);
	at[70] = 46.8833;
	points[71] = (-1328.3976, 11141.7324, 4687.6772);
	angles[71] = (0, -232.6158, 0);
	at[71] = 47.3667;
	points[72] = (-1445.5985, 11022.9131, 4677.8740);
	angles[72] = (0, -221.5363, 0);
	at[72] = 47.8500;
	points[73] = (-1554.4489, 10890.0791, 4669.7246);
	angles[73] = (0, -218.4415, 0);
	at[73] = 48.3333;
	points[74] = (-1658.4922, 10753.1895, 4662.1655);
	angles[74] = (0, -216.5902, 0);
	at[74] = 48.8167;
	points[75] = (-1758.1891, 10612.9922, 4655);
	angles[75] = (0, -214.6966, 0);
	at[75] = 49.3000;
	points[76] = (-1851.6733, 10468.6230, 4648.0708);
	angles[76] = (0, -211.6105, 0);
	at[76] = 49.7833;
	points[77] = (-1923.4803, 10317.2832, 4641.8110);
	angles[77] = (0, -199.4116, 0);
	at[77] = 50.2667;
	points[78] = (-1963.7480, 10150.2363, 4636.6143);
	angles[78] = (0, -191.7593, 0);
	at[78] = 50.7500;
	points[79] = (-1993.1732, 9981.1816, 4631.8896);
	angles[79] = (0, -188.9985, 0);
	at[79] = 51.2333;
	points[80] = (-2016.0591, 9810.8662, 4627.4019);
	angles[80] = (0, -186.9009, 0);
	at[80] = 51.7167;
	points[81] = (-2031.9724, 9640.2363, 4623.1104);
	angles[81] = (0, -184.2442, 0);
	at[81] = 52.2000;
	points[82] = (-2032.0117, 9471.8506, 4619.1733);
	angles[82] = (0, -175.0159, 0);
	at[82] = 52.6833;
	points[83] = (-1992.1143, 9304.3311, 4616.0239);
	angles[83] = (0, -164.1555, 0);
	at[83] = 53.1667;
	points[84] = (-1939.2087, 9140.7090, 4613.2681);
	angles[84] = (0, -161.2231, 0);
	at[84] = 53.6500;
	points[85] = (-1880.7913, 8978.8584, 4610.7085);
	angles[85] = (0, -159.6386, 0);
	at[85] = 54.1333;
	points[86] = (-1818.6890, 8818.4648, 4608.3071);
	angles[86] = (0, -158.3848, 0);
	at[86] = 54.6167;
	points[87] = (-1752.0906, 8662.4414, 4606.3384);
	angles[87] = (0, -155.2039, 0);
	at[87] = 55.1000;
	points[88] = (-1674.7008, 8510.0791, 4605.0791);
	angles[88] = (0, -152.4312, 0);
	at[88] = 55.5833;
	points[89] = (-1429.7284, 8057.3232, 4601.9688);
	angles[89] = (0, -151.5676, 0);
	at[89] = 57.0333;
	points[90] = (-1438.3503, 8073.3071, 4602.0474);
	angles[90] = (0, -140.6473, 0);
	at[90] = 57.5167;
	points[91] = (-1520.6219, 8224.2920, 4603.0708);
	angles[91] = (0, 27.5323, 0);
	at[91] = 58;
	points[92] = (-1683.2166, 8526.2988, 4605.1968);
	angles[92] = (0, 27.7649, 0);
	at[92] = 58.9667;
	points[93] = (-1760.7245, 8680.6689, 4606.5352);
	angles[93] = (0, 25.6234, 0);
	at[93] = 59.4500;
	points[94] = (-1826.0985, 8837.0469, 4608.5825);
	angles[94] = (0, 21.8537, 0);
	at[94] = 59.9333;
	points[95] = (-1887.4921, 8996.8105, 4610.9844);
	angles[95] = (0, 20.5781, 0);
	at[95] = 60.4167;
	points[96] = (-1945.3268, 9158.5430, 4613.5435);
	angles[96] = (0, 19.0931, 0);
	at[96] = 60.9000;
	points[97] = (-1997.4646, 9322.6777, 4616.3779);
	angles[97] = (0, 16.5472, 0);
	at[97] = 61.3833;
	points[98] = (-2034.0198, 9489.1338, 4619.5669);
	angles[98] = (0, 7.9744, 0);
	at[98] = 61.8667;
	points[99] = (-2030.7205, 9658.3076, 4623.5830);
	angles[99] = (0, -3.5598, 0);
	at[99] = 62.3500;
	points[100] = (-2013.8229, 9829.8428, 4627.9136);
	angles[100] = (0, -6.5326, 0);
	at[100] = 62.8333;
	points[101] = (-1990.2874, 9999.7637, 4632.4019);
	angles[101] = (0, -8.6369, 0);
	at[101] = 63.3167;
	points[102] = (-1959.9094, 10169.2129, 4637.1650);
	angles[102] = (0, -11.1682, 0);
	at[102] = 63.8000;
	points[103] = (-1917.3781, 10336.2207, 4642.4805);
	angles[103] = (0, -17.0646, 0);
	at[103] = 64.2833;
	points[104] = (-1841.3386, 10485.6299, 4648.8584);
	angles[104] = (0, -30.6671, 0);
	at[104] = 64.7667;
	points[105] = (-1747.4921, 10628.5430, 4655.7480);
	angles[105] = (0, -34.3143, 0);
	at[105] = 65.2500;
	points[106] = (-1647.2520, 10768.3857, 4662.9922);
	angles[106] = (0, -36.2975, 0);
	at[106] = 65.7333;
	points[107] = (-1542.8779, 10904.7637, 4670.5513);
	angles[107] = (0, -38.1003, 0);
	at[107] = 66.2167;
	points[108] = (-1432.9213, 11037.4805, 4678.8584);
	angles[108] = (0, -40.7579, 0);
	at[108] = 66.7000;
	points[109] = (-1312.2677, 11154.3711, 4689.0942);
	angles[109] = (0, -50.7305, 0);
	at[109] = 67.1833;
	points[110] = (-1171.7874, 11251.2207, 4701.4565);
	angles[110] = (0, -56.7884, 0);
	at[110] = 67.6667;
	points[111] = (-1026.5118, 11341.8115, 4714.5669);
	angles[111] = (0, -58.5728, 0);
	at[111] = 68.1500;
	points[112] = (-584.2913, 11604.8828, 4760.4727);
	angles[112] = (0, -58.5260, 0);
	at[112] = 69.6000;
	points[113] = (-444.3701, 11694.4883, 4784.0947);
	angles[113] = (0, -57.2679, 0);
	at[113] = 70.0833;
	points[114] = (124.2087, 12063.2285, 4900.0786);
	angles[114] = (0, -56.6768, 0);
	at[114] = 72.0167;
	points[115] = (261.3307, 12155.3145, 4930.6694);
	angles[115] = (0, -55.6102, 0);
	at[115] = 72.5000;
	points[116] = (537.2402, 12348.9365, 4999.4883);
	angles[116] = (0, -54.5851, 0);
	at[116] = 73.4667;
	points[117] = (809.4764, 12547.0479, 5071.1421);
	angles[117] = (0, -53.2347, 0);
	at[117] = 74.4333;
	points[118] = (938.9646, 12649.6855, 5107.8345);
	angles[118] = (0, -50.4107, 0);
	at[118] = 74.9167;
	points[119] = (1191.8229, 12867.6387, 5185);
	angles[119] = (0, -48.7719, 0);
	at[119] = 75.8833;
	points[120] = (1441.7913, 13090.7480, 5263.8584);
	angles[120] = (0, -47.7592, 0);
	at[120] = 76.8500;
	points[121] = (1563.9135, 13204.7246, 5304.1343);
	angles[121] = (0, -46.2109, 0);
	at[121] = 77.3333;
	points[122] = (1679.0906, 13320.7871, 5346.2207);
	angles[122] = (0, -44.4070, 0);
	at[122] = 77.8167;
	points[123] = (1907.1575, 13561.6543, 5434.4883);
	angles[123] = (0, -42.6156, 0);
	at[123] = 78.7833;
	points[124] = (2017.3859, 13685.3145, 5478.3857);
	angles[124] = (0, -41.0830, 0);
	at[124] = 79.2667;
	points[125] = (2122.0906, 13814.1738, 5521.3779);
	angles[125] = (0, -37.3543, 0);
	at[125] = 79.7500;
	points[126] = (2205.0432, 13955.7871, 5559.1338);
	angles[126] = (0, -26.9975, 0);
	at[126] = 80.2333;
	points[127] = (2275.6772, 14108.9375, 5594.5273);
	angles[127] = (0, -23.8865, 0);
	at[127] = 80.7167;
	points[128] = (2340.8662, 14264.4883, 5628.7402);
	angles[128] = (0, -22.1387, 0);
	at[128] = 81.2000;
	points[129] = (2401.5276, 14422.1260, 5662.0469);
	angles[129] = (0, -20.3770, 0);
	at[129] = 81.6833;
	points[130] = (2455.8545, 14582.3623, 5694.1338);
	angles[130] = (0, -17.5104, 0);
	at[130] = 82.1667;
	points[131] = (2489.4529, 14744.5273, 5721.7715);
	angles[131] = (0, -6.2512, 0);
	at[131] = 82.6500;
	points[132] = (2492.7993, 14914.8037, 5743.2676);
	angles[132] = (0, 0.3836, 0);
	at[132] = 83.1333;
	points[133] = (2487.1812, 15085.3145, 5762.7168);
	angles[133] = (0, 2.5507, 0);
	at[133] = 83.6167;
	points[134] = (2476.8308, 15255.7090, 5781.1021);
	angles[134] = (0, 3.9633, 0);
	at[134] = 84.1000;
	points[135] = (2462.3347, 15426.2998, 5798.6611);
	angles[135] = (0, 5.4301, 0);
	at[135] = 84.5833;
	points[136] = (2440.4448, 15593.0713, 5814.4883);
	angles[136] = (0, 9.9202, 0);
	at[136] = 85.0667;
	points[137] = (2395.7913, 15758.8975, 5825.5908);
	angles[137] = (0, 16.9531, 0);
	at[137] = 85.5500;
	points[138] = (2339.3267, 15920.8271, 5834.0552);
	angles[138] = (0, 20.4275, 0);
	at[138] = 86.0333;
	points[139] = (2272.3977, 16078.7002, 5840.8267);
	angles[139] = (0, 24.7818, 0);
	at[139] = 86.5167;
	points[140] = (2184.3347, 16222.5195, 5844.8428);
	angles[140] = (0, 35.9047, 0);
	at[140] = 87;
	points[141] = (2077.1812, 16357.2842, 5847.0083);
	angles[141] = (0, 39.3428, 0);
	at[141] = 87.4833;
	points[142] = (1965.6771, 16488.1504, 5848.3071);
	angles[142] = (0, 41.0096, 0);
	at[142] = 87.9667;
	points[143] = (1850.1771, 16615.8672, 5848.5430);
	angles[143] = (0, 42.8404, 0);
	at[143] = 88.4500;
	points[144] = (1728.7795, 16738.2676, 5846.9287);
	angles[144] = (0, 46.2833, 0);
	at[144] = 88.9333;
	points[145] = (1592.6143, 16835.2754, 5837.8350);
	angles[145] = (0, 61.5457, 0);
	at[145] = 89.4167;
	points[146] = (1435.6377, 16901.8906, 5818.8193);
	angles[146] = (0, 68.7284, 0);
	at[146] = 89.9000;
	points[147] = (1274.7520, 16958.6621, 5797.5200);
	angles[147] = (0, 71.4227, 0);
	at[147] = 90.3833;
	points[148] = (1112.2047, 17009.2129, 5775.5117);
	angles[148] = (0, 73.4733, 0);
	at[148] = 90.8667;
	points[149] = (948.0945, 17052.7949, 5753.7007);
	angles[149] = (0, 76.3633, 0);
	at[149] = 91.3500;
	points[150] = (782.0984, 17078.1504, 5734.7637);
	angles[150] = (0, 84.1151, 0);
	at[150] = 91.8333;
	points[151] = (611.1772, 17089.8027, 5717.3228);
	angles[151] = (0, 86.8795, 0);
	at[151] = 92.3167;
	points[152] = (439.9410, 17095.8652, 5700);
	angles[152] = (0, 88.5700, 0);
	at[152] = 92.8000;
	points[153] = (269.4973, 17096.6152, 5682.2051);
	angles[153] = (0, 90.5275, 0);
	at[153] = 93.2833;
	points[154] = (99.5779, 17088.4258, 5662.8345);
	angles[154] = (0, 94.6819, 0);
	at[154] = 93.7667;
	points[155] = (-62.5571, 17047.9922, 5637.2046);
	angles[155] = (0, 109.3323, 0);
	at[155] = 94.2500;
	points[156] = (-218.6173, 16982.2832, 5607.0474);
	angles[156] = (0, 114.0870, 0);
	at[156] = 94.7333;
	points[157] = (-371.3091, 16909.2910, 5575.9844);
	angles[157] = (0, 116.2545, 0);
	at[157] = 95.2167;
	points[158] = (-521.5236, 16831.4961, 5544.6855);
	angles[158] = (0, 118.0316, 0);
	at[158] = 95.7000;
	points[159] = (-668.8032, 16747.6777, 5513.5825);
	angles[159] = (0, 120.9801, 0);
	at[159] = 96.1833;
	points[160] = (-803.0984, 16650.1973, 5484.0161);
	angles[160] = (0, 127.9169, 0);
	at[160] = 96.6667;
	points[161] = (-933.8858, 16543.3457, 5454.1343);
	angles[161] = (0, 129.7355, 0);
	at[161] = 97.1500;
	points[162] = (-1319.5630, 16211.9688, 5367.6377);
	angles[162] = (0, 130.9362, 0);
	at[162] = 98.6000;
	points[163] = (-1445.7205, 16103.4658, 5344.5278);
	angles[163] = (0, 130.6834, 0);
	at[163] = 99.0833;
	points[164] = (-1703.8661, 15879.7246, 5302.9922);
	angles[164] = (0, 131.1439, 0);
	at[164] = 100.0500;
	points[165] = (-1959.0946, 15652.0859, 5263.5435);
	angles[165] = (0, 132.4453, 0);
	at[165] = 101.0170;
	points[166] = (-2078.6221, 15536.2598, 5245.1182);
	angles[166] = (0, 135.4677, 0);
	at[166] = 101.5000;
	points[167] = (-2195.8621, 15412.2441, 5227.2441);
	angles[167] = (0, 136.9548, 0);
	at[167] = 101.9830;
	points[168] = (-2427.4331, 15159.6455, 5192.2837);
	angles[168] = (0, 137.7903, 0);
	at[168] = 102.9500;
	points[169] = (-2656.0710, 14904.2520, 5157.9526);
	angles[169] = (0, 138.5185, 0);
	at[169] = 103.9170;
	points[170] = (-2764.6182, 14778.1494, 5141.8115);
	angles[170] = (0, 140.1069, 0);
	at[170] = 104.4000;
	points[171] = (-2871.9490, 14644.4092, 5126.0630);
	angles[171] = (0, 141.6236, 0);
	at[171] = 104.8830;
	points[172] = (-3185.9448, 14238.9375, 5080.5513);
	angles[172] = (0, 142.5070, 0);
	at[172] = 106.3330;
	points[173] = (-3288.1616, 14105.7090, 5066.1812);
	angles[173] = (0, 142.4871, 0);
	at[173] = 106.8170;
	points[174] = (-3806.2205, 13422.1660, 4998.0708);
	angles[174] = (0, 142.7522, 0);
	at[174] = 109.2330;
	points[175] = (-4013.1497, 13153.3066, 4972.7954);
	angles[175] = (0, 142.3030, 0);
	at[175] = 110.2000;
	points[176] = (-4328.1890, 12747.3623, 4935.8271);
	angles[176] = (0, 142.0457, 0);
	at[176] = 111.6500;
	points[177] = (-4432.3228, 12615.0391, 4924.4487);
	angles[177] = (0, 141.6351, 0);
	at[177] = 112.1330;
	points[178] = (-4860.0396, 12078.2676, 4880.8267);
	angles[178] = (0, 141.4156, 0);
	at[178] = 114.0670;
	points[179] = (-4954.3306, 11960, 4871.2202);
	angles[179] = (0, 141.4514, 0);
	at[179] = 114.5000;
	mover = getEnt("iz_obj_1", "targetname");
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
