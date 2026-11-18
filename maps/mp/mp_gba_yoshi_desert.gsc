main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_yoshi_desert", 0);

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
	ambientPlay("iz_0_50", 2);
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
	level.iz_route[level.iz_route.size] = (-6561, -1655, 955);
	level.iz_route[level.iz_route.size] = (-6607, -3545, 955);
	level.iz_route[level.iz_route.size] = (-6520, -4219, 955);
	level.iz_route[level.iz_route.size] = (-6321, -4945, 956);
	level.iz_route[level.iz_route.size] = (-5989, -5639, 955);
	level.iz_route[level.iz_route.size] = (-5912, -5869, 955);
	level.iz_route[level.iz_route.size] = (-5907, -6130, 957);
	level.iz_route[level.iz_route.size] = (-5984, -6497, 966);
	level.iz_route[level.iz_route.size] = (-6157, -7207, 1012);
	level.iz_route[level.iz_route.size] = (-6060, -7611, 1031);
	level.iz_route[level.iz_route.size] = (-5733, -7943, 1035);
	level.iz_route[level.iz_route.size] = (-5207, -8101, 1021);
	level.iz_route[level.iz_route.size] = (-4650, -8071, 1011);
	level.iz_route[level.iz_route.size] = (-4073, -7831, 998);
	level.iz_route[level.iz_route.size] = (-3685, -7305, 976);
	level.iz_route[level.iz_route.size] = (-3159, -6574, 981);
	level.iz_route[level.iz_route.size] = (-2730, -5920, 1012);
	level.iz_route[level.iz_route.size] = (-2255, -5655, 1027);
	level.iz_route[level.iz_route.size] = (-1596, -5573, 1037);
	level.iz_route[level.iz_route.size] = (-855, -5685, 1044);
	level.iz_route[level.iz_route.size] = (-309, -6028, 1025);
	level.iz_route[level.iz_route.size] = (74, -6624, 992);
	level.iz_route[level.iz_route.size] = (630, -7831, 997);
	level.iz_route[level.iz_route.size] = (1147, -8590, 1026);
	level.iz_route[level.iz_route.size] = (1754, -9229, 1063);
	level.iz_route[level.iz_route.size] = (2450, -9280, 1055);
	level.iz_route[level.iz_route.size] = (3005, -8954, 1044);
	level.iz_route[level.iz_route.size] = (3350, -8559, 1039);
	level.iz_route[level.iz_route.size] = (3395, -7907, 1013);
	level.iz_route[level.iz_route.size] = (3312, -7141, 1008);
	level.iz_route[level.iz_route.size] = (3229, -6107, 999);
	level.iz_route[level.iz_route.size] = (3235, -5558, 996);
	level.iz_route[level.iz_route.size] = (3490, -5053, 981);
	level.iz_route[level.iz_route.size] = (3676, -4440, 978);
	level.iz_route[level.iz_route.size] = (3676, -3783, 999);
	level.iz_route[level.iz_route.size] = (3676, -3163, 1022);
	level.iz_route[level.iz_route.size] = (3541, -2391, 1046);
	level.iz_route[level.iz_route.size] = (3190, -1778, 1050);
	level.iz_route[level.iz_route.size] = (2839, -846, 1043);
	level.iz_route[level.iz_route.size] = (2737, -238, 1051);
	level.iz_route[level.iz_route.size] = (2436, 319, 1038);
	level.iz_route[level.iz_route.size] = (1904, 636, 1003);
	level.iz_route[level.iz_route.size] = (1194, 799, 976);
	level.iz_route[level.iz_route.size] = (704, 886, 977);
	level.iz_route[level.iz_route.size] = (433, 1162, 984);
	level.iz_route[level.iz_route.size] = (260, 1540, 994);
	level.iz_route[level.iz_route.size] = (152, 1974, 1009);
	level.iz_route[level.iz_route.size] = (260, 2347, 1007);
	level.iz_route[level.iz_route.size] = (699, 2827, 987);
	level.iz_route[level.iz_route.size] = (1644, 3379, 969);
	level.iz_route[level.iz_route.size] = (2671, 3915, 994);
	level.iz_route[level.iz_route.size] = (3294, 4298, 1023);
	level.iz_route[level.iz_route.size] = (3667, 4564, 1053);
	level.iz_route[level.iz_route.size] = (3810, 5029, 1062);
	level.iz_route[level.iz_route.size] = (3784, 5514, 1084);
	level.iz_route[level.iz_route.size] = (3585, 5866, 1091);
	level.iz_route[level.iz_route.size] = (3166, 6106, 1073);
	level.iz_route[level.iz_route.size] = (2665, 6091, 1033);
	level.iz_route[level.iz_route.size] = (1828, 5994, 992);
	level.iz_route[level.iz_route.size] = (1092, 5713, 964);
	level.iz_route[level.iz_route.size] = (265, 5320, 960);
	level.iz_route[level.iz_route.size] = (-568, 4732, 992);
	level.iz_route[level.iz_route.size] = (-997, 4523, 1013);
	level.iz_route[level.iz_route.size] = (-1349, 4533, 1015);
	level.iz_route[level.iz_route.size] = (-1574, 4794, 993);
	level.iz_route[level.iz_route.size] = (-1738, 5325, 973);
	level.iz_route[level.iz_route.size] = (-2105, 6019, 987);
	level.iz_route[level.iz_route.size] = (-2514, 6495, 998);
	level.iz_route[level.iz_route.size] = (-3372, 6745, 997);
	level.iz_route[level.iz_route.size] = (-4761, 6581, 999);
	level.iz_route[level.iz_route.size] = (-6033, 6280, 1001);
	level.iz_route[level.iz_route.size] = (-6611, 5979, 1002);
	level.iz_route[level.iz_route.size] = (-6856, 5590, 1000);
	level.iz_route[level.iz_route.size] = (-6948, 5044, 998);
	level.iz_route[level.iz_route.size] = (-6825, 4354, 985);
	level.iz_route[level.iz_route.size] = (-6478, 3496, 962);
	level.iz_route[level.iz_route.size] = (-5998, 2694, 961);
	level.iz_route[level.iz_route.size] = (-5645, 2040, 992);
	level.iz_route[level.iz_route.size] = (-5727, 1668, 1006);
	level.iz_route[level.iz_route.size] = (-5993, 1213, 999);
	level.iz_route[level.iz_route.size] = (-6406, 671, 970);
	level.iz_route[level.iz_route.size] = (-6503, 396, 962);
	level.iz_route[level.iz_route.size] = (-6570, -130, 955);
	level.iz_route[level.iz_route.size] = (-6585, -994, 955);
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
	points[0] = (-6811.9292, 947.2244, 956.9095);
	angles[0] = (0, -138.6222, -0.4012);
	at[0] = 0;
	points[1] = (-6793.3462, 928.0867, 956.7244);
	angles[1] = (0, -134.8016, -0.4020);
	at[1] = 0.2500;
	points[2] = (-6772.5591, 912.2598, 956.5275);
	angles[2] = (0, -122.0619, -0.5013);
	at[2] = 0.5000;
	points[3] = (-6747.3623, 904.0197, 956.1929);
	angles[3] = (0, -106.1236, -0.7321);
	at[3] = 0.7500;
	points[4] = (-6721.2988, 898.4606, 955.8780);
	angles[4] = (0, -101.4595, -0.6338);
	at[4] = 1;
	points[5] = (-6669.0947, 888.2362, 955.7638);
	angles[5] = (0, -102.7709, 0.4501);
	at[5] = 1.5000;
	points[6] = (-6644.4487, 879.6221, 956.7283);
	angles[6] = (0, -110.7327, 2.5994);
	at[6] = 1.7500;
	points[7] = (-6595.2363, 859.0079, 959.8898);
	angles[7] = (0, -113.0746, 3.5623);
	at[7] = 2.2500;
	points[8] = (-6497.4414, 818.6339, 966.3898);
	angles[8] = (0, -110.9357, 3.1665);
	at[8] = 3.2500;
	points[9] = (-6321.7715, 755.3779, 976.4016);
	angles[9] = (0, -107.4202, 3.0706);
	at[9] = 5;
	points[10] = (-6244.7246, 738.4056, 980.5670);
	angles[10] = (0, -100.8035, 2.9988);
	at[10] = 5.7500;
	points[11] = (-6139.7246, 721.8347, 986.2834);
	angles[11] = (0, -96.8716, 3.2272);
	at[11] = 6.7500;
	points[12] = (-6060.5117, 721.9843, 991.5118);
	angles[12] = (0, -87.0936, 3.9632);
	at[12] = 7.5000;
	points[13] = (-5795.8662, 741.0275, 1009.2402);
	angles[13] = (0, -85.1848, 3.6729);
	at[13] = 10;
	points[14] = (-5716.6538, 750.6968, 1014.4489);
	angles[14] = (0, -79.3745, 3.8362);
	at[14] = 10.7500;
	points[15] = (-5691.8506, 758.1378, 1016.2402);
	angles[15] = (0, -72.1176, 3.9752);
	at[15] = 11;
	points[16] = (-5618.0312, 788.5591, 1021.8622);
	angles[16] = (0, -65.4331, 4.0472);
	at[16] = 11.7500;
	points[17] = (-5570.7480, 813.0984, 1025.6536);
	angles[17] = (0, -60.1257, 4.0884);
	at[17] = 12.2500;
	points[18] = (-5550.0786, 828.7126, 1027.5039);
	angles[18] = (0, -49.4886, 4.0320);
	at[18] = 12.5000;
	points[19] = (-5531.9683, 848.0276, 1029.2992);
	angles[19] = (0, -42.1778, 3.8610);
	at[19] = 12.7500;
	points[20] = (-5498.9370, 889.8504, 1032.8346);
	angles[20] = (0, -36.4613, 3.7758);
	at[20] = 13.2500;
	points[21] = (-5470.4722, 934.8661, 1036.3503);
	angles[21] = (0, -28.8578, 3.7790);
	at[21] = 13.7500;
	points[22] = (-5461.8506, 958.9213, 1038.0354);
	angles[22] = (0, -14.2453, 3.7536);
	at[22] = 14;
	points[23] = (-5461.0630, 985.8110, 1039.7717);
	angles[23] = (0, -0.0361, 3.6688);
	at[23] = 14.2500;
	points[24] = (-5465.3545, 1038.7441, 1043.0354);
	angles[24] = (0, 6.1240, 3.4235);
	at[24] = 14.7500;
	points[25] = (-5482.2837, 1144.0787, 1048.3149);
	angles[25] = (0, 12.0285, 1.8013);
	at[25] = 15.7500;
	points[26] = (-5489.4883, 1168.6653, 1048.4567);
	angles[26] = (0, 17.5445, 0.0110);
	at[26] = 16;
	points[27] = (-5508.0317, 1218.8623, 1047.7756);
	angles[27] = (0, 21.0522, -0.9547);
	at[27] = 16.5000;
	points[28] = (-5557.6768, 1341.9922, 1044.1772);
	angles[28] = (0, 21.6738, -2.5056);
	at[28] = 17.7500;
	points[29] = (-5588.7798, 1415.3229, 1037.6180);
	angles[29] = (0, 22.9311, -5.3387);
	at[29] = 18.5000;
	points[30] = (-5607.7954, 1464.7166, 1032.6024);
	angles[30] = (0, 18.9661, -5.2967);
	at[30] = 19;
	points[31] = (-5613.6221, 1490.0826, 1030.4252);
	angles[31] = (0, 10.9004, -4.6614);
	at[31] = 19.2500;
	points[32] = (-5620.5508, 1542.9291, 1026.2362);
	angles[32] = (0, 6.7577, -4.4647);
	at[32] = 19.7500;
	points[33] = (-5633.0708, 1648.1417, 1017.9016);
	angles[33] = (0, 8.7472, -4.6556);
	at[33] = 20.7500;
	points[34] = (-5645.3154, 1699.6417, 1013.1851);
	angles[34] = (0, 14.3718, -5.1811);
	at[34] = 21.2500;
	points[35] = (-5663.6611, 1777.0079, 1006.1851);
	angles[35] = (0, 10.9567, -4.7270);
	at[35] = 22;
	points[36] = (-5666.8110, 1803.0787, 1004.2953);
	angles[36] = (0, 6.1627, -3.9516);
	at[36] = 22.2500;
	points[37] = (-5673.1499, 1882.5394, 999.2677);
	angles[37] = (0, 3.2144, -3.4639);
	at[37] = 23;
	points[38] = (-5673.8193, 1935.8386, 996.2283);
	angles[38] = (0, -1.3088, -3.1077);
	at[38] = 23.5000;
	points[39] = (-5671.3389, 1962.4489, 994.9213);
	angles[39] = (0, -7.2276, -2.6491);
	at[39] = 23.7500;
	points[40] = (-5662.0078, 1985.9489, 994.2874);
	angles[40] = (0, -29.8945, -0.6759);
	at[40] = 24;
	points[41] = (-5642.7954, 2004.7993, 994.6771);
	angles[41] = (0, -47.4924, 1.0202);
	at[41] = 24.2500;
	points[42] = (-5621.9292, 2021.2245, 995.3386);
	angles[42] = (0, -52.5254, 1.4850);
	at[42] = 24.5000;
	points[43] = (-5578.0708, 2051.7166, 996.9291);
	angles[43] = (0, -56.2281, 1.7807);
	at[43] = 25;
	points[44] = (-5488.3857, 2108.4805, 999.9961);
	angles[44] = (0, -58.8063, 1.0561);
	at[44] = 26;
	points[45] = (-5417.9526, 2146.0591, 1000.9213);
	angles[45] = (0, -62.4702, 0.6249);
	at[45] = 26.7500;
	points[46] = (-5370.9844, 2171.3584, 1001.6417);
	angles[46] = (0, -60.7345, 0.9353);
	at[46] = 27.2500;
	points[47] = (-5349.2124, 2185.2954, 1002.3110);
	angles[47] = (0, -55.3679, 1.8547);
	at[47] = 27.5000;
	points[48] = (-5287.9526, 2236.8188, 1006.6575);
	angles[48] = (0, -48.0815, 3.3390);
	at[48] = 28.2500;
	points[49] = (-5249.8032, 2274.0513, 1009.7165);
	angles[49] = (0, -43.6702, 3.1670);
	at[49] = 28.7500;
	points[50] = (-5234.0156, 2294.4253, 1010.9173);
	angles[50] = (0, -34.2738, 2.3925);
	at[50] = 29;
	points[51] = (-5221.7324, 2318.1655, 1011.8819);
	angles[51] = (0, -26.4462, 2.0186);
	at[51] = 29.2500;
	points[52] = (-5201.0630, 2367.4253, 1013.4882);
	angles[52] = (0, -20.9472, 1.5224);
	at[52] = 29.7500;
	points[53] = (-5185.8657, 2418.6023, 1014.2914);
	angles[53] = (0, -12.6866, 0.2354);
	at[53] = 30.2500;
	points[54] = (-5185.6299, 2444.3032, 1013.4489);
	angles[54] = (0, 5.6909, -2.9653);
	at[54] = 30.5000;
	points[55] = (-5193.0317, 2469.7402, 1011.2599);
	angles[55] = (0, 17.4965, -4.9196);
	at[55] = 30.7500;
	points[56] = (-5213.1499, 2518.9883, 1006.0945);
	angles[56] = (0, 24.1918, -5.7546);
	at[56] = 31.2500;
	points[57] = (-5237.7949, 2565.9331, 1000.5157);
	angles[57] = (0, 30.1821, -6.1395);
	at[57] = 31.7500;
	points[58] = (-5252.9922, 2587.8149, 997.5787);
	angles[58] = (0, 36.9158, -6.3371);
	at[58] = 32;
	points[59] = (-5272.2051, 2604.5669, 994.6418);
	angles[59] = (0, 52.1172, -6.6387);
	at[59] = 32.2500;
	points[60] = (-5294.3306, 2618.8936, 991.5433);
	angles[60] = (0, 57.7929, -6.7119);
	at[60] = 32.5000;
	points[61] = (-5363.9761, 2657.5984, 982.2520);
	angles[61] = (0, 62.3557, -6.5738);
	at[61] = 33.2500;
	points[62] = (-5435.7480, 2692.2915, 973.4331);
	angles[62] = (0, 65.8770, -5.9845);
	at[62] = 34;
	points[63] = (-5459.6064, 2701.6458, 971.0591);
	angles[63] = (0, 70.3203, -4.8422);
	at[63] = 34.2500;
	points[64] = (-5485.6694, 2707.6851, 969.4961);
	angles[64] = (0, 78.3064, -3.0546);
	at[64] = 34.5000;
	points[65] = (-5591.4565, 2719.4370, 965.9252);
	angles[65] = (0, 85.8556, -1.4980);
	at[65] = 35.5000;
	points[66] = (-5670.6299, 2721.3975, 964.3622);
	angles[66] = (0, 91.0420, -0.7296);
	at[66] = 36.2500;
	points[67] = (-5803.8193, 2714.4919, 963.1653);
	angles[67] = (0, 94.6390, -0.4686);
	at[67] = 37.5000;
	points[68] = (-5830.1973, 2711.5750, 962.9292);
	angles[68] = (0, 97.3297, -0.5424);
	at[68] = 37.7500;
	points[69] = (-5881.6533, 2699.7913, 962.3701);
	angles[69] = (0, 104.6483, -0.6088);
	at[69] = 38.2500;
	points[70] = (-5958.0317, 2676.2598, 961.5079);
	angles[70] = (0, 108.9282, -0.6307);
	at[70] = 39;
	points[71] = (-6006.4175, 2655.8584, 960.8937);
	angles[71] = (0, 115.8466, -0.6974);
	at[71] = 39.5000;
	points[72] = (-6286.5747, 2502.9136, 957.2953);
	angles[72] = (0, 119.1324, -0.4949);
	at[72] = 42.5000;
	points[73] = (-6425.1577, 2422.3584, 956.0866);
	angles[73] = (0, 122.8579, -0.2963);
	at[73] = 44;
	points[74] = (-6445.3936, 2406.4922, 956.0748);
	angles[74] = (0, 129.6616, 0.0536);
	at[74] = 44.2500;
	points[75] = (-6483.5825, 2369.3308, 956.3465);
	angles[75] = (0, 135.7060, 0.3674);
	at[75] = 44.7500;
	points[76] = (-6577.3623, 2275.5552, 957.0827);
	angles[76] = (0, 133.2509, 0.2307);
	at[76] = 46;
	points[77] = (-6654.0156, 2201.0276, 957.5000);
	angles[77] = (0, 135.8131, 0.2173);
	at[77] = 47;
	points[78] = (-6685.9448, 2159.3269, 957.6772);
	angles[78] = (0, 147.2639, 0.1783);
	at[78] = 47.5000;
	points[79] = (-6712.6382, 2113.2954, 957.8347);
	angles[79] = (0, 150.7111, 0.1639);
	at[79] = 48;
	points[80] = (-6822.6772, 1900.6929, 958.4882);
	angles[80] = (0, 153.1047, 0.1358);
	at[80] = 50.2500;
	points[81] = (-6848.9370, 1854.8386, 958.5748);
	angles[81] = (0, 149.0173, 0.0762);
	at[81] = 50.7500;
	points[82] = (-6875.9839, 1808.9685, 958.6339);
	angles[82] = (0, 150.2062, 0.0599);
	at[82] = 51.2500;
	points[83] = (-6888.6221, 1785.4133, 958.6575);
	angles[83] = (0, 152.4711, 0.0510);
	at[83] = 51.5000;
	points[84] = (-6899.2520, 1760.9015, 958.6772);
	angles[84] = (0, 158.7561, 0.0326);
	at[84] = 51.7500;
	points[85] = (-6903.9370, 1735.5709, 958.6772);
	angles[85] = (0, 171.5305, -0.0076);
	at[85] = 52;
	points[86] = (-6908.8975, 1655.5552, 958.6418);
	angles[86] = (0, 177.8060, -0.0298);
	at[86] = 52.7500;
	points[87] = (-6912.8345, 1416.3505, 958.5197);
	angles[87] = (0, 181.0891, -0.0531);
	at[87] = 55;
	points[88] = (-6905.5513, 1311.0984, 958.3188);
	angles[88] = (0, 184.8679, -0.1290);
	at[88] = 56;
	points[89] = (-6887.0474, 1125.1575, 957.8661);
	angles[89] = (0, 186.6969, -0.1487);
	at[89] = 57.7500;
	points[90] = (-6874.8428, 1045.9568, 957.6339);
	angles[90] = (0, 192.3898, -0.1951);
	at[90] = 58.5000;
	points[91] = (-6865.6694, 1022.1732, 957.5118);
	angles[91] = (0, 203.6198, -0.2899);
	at[91] = 58.7500;
	points[92] = (-6836.9683, 977.2717, 957.1812);
	angles[92] = (0, 216.1667, -0.3799);
	at[92] = 59.2500;
	points[93] = (-6811.9292, 947.2244, 956.9095);
	angles[93] = (0, 221.3778, -0.4012);
	at[93] = 59.6167;
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
	points[0] = (3185.4685, -10197.5596, 1179.4606);
	angles[0] = (0, -127.9705, 1.4638);
	at[0] = 0;
	points[1] = (3232.5237, -10229.6855, 1180.8820);
	angles[1] = (0, -120.5610, 1.3857);
	at[1] = 0.5333;
	points[2] = (3257.9055, -10239.8818, 1181.4882);
	angles[2] = (0, -109.4265, 1.2311);
	at[2] = 0.8000;
	points[3] = (3340.7954, -10260.3154, 1183.1732);
	angles[3] = (0, -102.1340, 1.0952);
	at[3] = 1.6000;
	points[4] = (3452.4373, -10281.4561, 1185.2677);
	angles[4] = (0, -99.7980, 1.0225);
	at[4] = 2.6667;
	points[5] = (3508.2600, -10289.0557, 1186.1693);
	angles[5] = (0, -96.1411, 0.8427);
	at[5] = 3.2000;
	points[6] = (3593.4292, -10294.8428, 1187.2992);
	angles[6] = (0, -92.1943, 0.7002);
	at[6] = 4;
	points[7] = (3649.5198, -10292.1270, 1187.8268);
	angles[7] = (0, -83.0708, 0.3914);
	at[7] = 4.5333;
	points[8] = (3789.1812, -10264.6455, 1188.4764);
	angles[8] = (0, -74.8939, 0.1785);
	at[8] = 5.8667;
	points[9] = (3814.9292, -10254.6846, 1188.4922);
	angles[9] = (0, -67.1781, -0.0109);
	at[9] = 6.1333;
	points[10] = (3840.6694, -10242.5596, 1188.4567);
	angles[10] = (0, -64.3404, -0.0820);
	at[10] = 6.4000;
	points[11] = (3943.0708, -10192.7158, 1188.3977);
	angles[11] = (0, -66.2140, 0.1318);
	at[11] = 7.4667;
	points[12] = (3969.0552, -10183.5049, 1188.6063);
	angles[12] = (0, -71.6539, 0.5327);
	at[12] = 7.7333;
	points[13] = (4023.6614, -10167.3623, 1189.2874);
	angles[13] = (0, -73.9386, 0.7200);
	at[13] = 8.2667;
	points[14] = (4105.5903, -10143.8193, 1190.3347);
	angles[14] = (0, -73.6483, 0.6559);
	at[14] = 9.0667;
	points[15] = (4159.6851, -10126.2998, 1190.7914);
	angles[15] = (0, -69.8224, 0.1812);
	at[15] = 9.6000;
	points[16] = (4236.8896, -10091.2998, 1189.9370);
	angles[16] = (0, -63.6549, -0.8338);
	at[16] = 10.4000;
	points[17] = (4286.1416, -10062.8740, 1188.8386);
	angles[17] = (0, -56.5997, -1.3337);
	at[17] = 10.9333;
	points[18] = (4306.6538, -10043.8193, 1187.9174);
	angles[18] = (0, -40.2627, -2.2386);
	at[18] = 11.2000;
	points[19] = (4314.6460, -10016.9287, 1186.3031);
	angles[19] = (0, -12.9490, -3.4208);
	at[19] = 11.4667;
	points[20] = (4319.7637, -9960.4727, 1182.7125);
	angles[20] = (0, -2.7591, -3.6643);
	at[20] = 12;
	points[21] = (4318.2285, -9875.2754, 1177.2638);
	angles[21] = (0, 4.1585, -3.6010);
	at[21] = 12.8000;
	points[22] = (4307.4014, -9820.5908, 1173.9252);
	angles[22] = (0, 13.8425, -3.3680);
	at[22] = 13.3333;
	points[23] = (4258.0317, -9657.2441, 1164.1969);
	angles[23] = (0, 19.4972, -3.1110);
	at[23] = 14.9333;
	points[24] = (4234.4097, -9606.6533, 1161.5393);
	angles[24] = (0, 27.6733, -2.5399);
	at[24] = 15.4667;
	points[25] = (4162.6772, -9483.7402, 1155.6260);
	angles[25] = (0, 31.6211, -2.3313);
	at[25] = 16.8000;
	points[26] = (4018.2678, -9274.6455, 1145.6378);
	angles[26] = (0, 35.8215, -2.2155);
	at[26] = 19.2000;
	points[27] = (3937.4805, -9157.6377, 1140.0433);
	angles[27] = (0, 31.5576, -2.3419);
	at[27] = 20.5333;
	points[28] = (3915.9802, -9106.0234, 1137.5237);
	angles[28] = (0, 18.2912, -2.6810);
	at[28] = 21.0667;
	points[29] = (3881.0750, -8968.1494, 1130.7716);
	angles[29] = (0, 10.9108, -2.6747);
	at[29] = 22.4000;
	points[30] = (3877.7795, -8940.7871, 1129.5472);
	angles[30] = (0, 5.4231, -2.4836);
	at[30] = 22.6667;
	points[31] = (3875.7559, -8883.8975, 1127.1812);
	angles[31] = (0, 0.6461, -2.3524);
	at[31] = 23.2000;
	points[32] = (3877.5945, -8827.1260, 1124.8623);
	angles[32] = (0, -3.7976, -2.3346);
	at[32] = 23.7333;
	points[33] = (3881.4211, -8798.9766, 1123.7008);
	angles[33] = (0, -10.0166, -2.3448);
	at[33] = 24;
	points[34] = (3890.5081, -8772.7949, 1122.5984);
	angles[34] = (0, -20.8666, -2.2518);
	at[34] = 24.2667;
	points[35] = (3901.9370, -8746.6143, 1121.4961);
	angles[35] = (0, -24.0749, -2.2042);
	at[35] = 24.5333;
	points[36] = (3965.3152, -8619.8027, 1116.0315);
	angles[36] = (0, -27.9007, -2.3121);
	at[36] = 25.8667;
	points[37] = (3980.1575, -8595.8271, 1114.8229);
	angles[37] = (0, -32.9525, -2.4810);
	at[37] = 26.1333;
	points[38] = (4012.3230, -8549.0547, 1112.3032);
	angles[38] = (0, -34.4111, -2.5642);
	at[38] = 26.6667;
	points[39] = (4042.0867, -8500.7090, 1109.7284);
	angles[39] = (0, -28.1478, -2.6064);
	at[39] = 27.2000;
	points[40] = (4050.1182, -8474.1338, 1108.5237);
	angles[40] = (0, -12.2483, -2.3536);
	at[40] = 27.4667;
	points[41] = (4053.2678, -8445.9053, 1107.4646);
	angles[41] = (0, -5.4462, -2.1173);
	at[41] = 27.7333;
	points[42] = (4054.4490, -8360.7480, 1104.2323);
	angles[42] = (0, 2.4664, -2.3238);
	at[42] = 28.5333;
	points[43] = (4051.5750, -8332.5195, 1102.9606);
	angles[43] = (0, 7.3536, -2.6907);
	at[43] = 28.8000;
	points[44] = (4043.5828, -8305.8271, 1101.3229);
	angles[44] = (0, 20.6604, -3.5734);
	at[44] = 29.0667;
	points[45] = (4031.1812, -8280.6689, 1099.4724);
	angles[45] = (0, 27.0582, -3.8057);
	at[45] = 29.3333;
	points[46] = (3972.4016, -8183.5039, 1091.4489);
	angles[46] = (0, 33.7359, -4.2627);
	at[46] = 30.4000;
	points[47] = (3937.9136, -8138.2285, 1086.7795);
	angles[47] = (0, 41.2281, -5.1786);
	at[47] = 30.9333;
	points[48] = (3916.6575, -8121.4175, 1083.7795);
	angles[48] = (0, 54.4745, -6.5629);
	at[48] = 31.2000;
	points[49] = (3867.4568, -8093.2681, 1076.8031);
	angles[49] = (0, 62, -7.1407);
	at[49] = 31.7333;
	points[50] = (3765.4529, -8044.7642, 1062.3976);
	angles[50] = (0, 66.2324, -7.2889);
	at[50] = 32.8000;
	points[51] = (3713.3308, -8025.2363, 1055.3740);
	angles[51] = (0, 71.2574, -7.1688);
	at[51] = 33.3333;
	points[52] = (3631.8110, -8002.5591, 1044.6497);
	angles[52] = (0, 77.5161, -7.2986);
	at[52] = 34.1333;
	points[53] = (3576.2913, -7997.9922, 1037.3662);
	angles[53] = (0, 89.0411, -7.4618);
	at[53] = 34.6667;
	points[54] = (3491.7795, -7999.9609, 1026.3070);
	angles[54] = (0, 92.5912, -7.4449);
	at[54] = 35.4667;
	points[55] = (3435.6104, -8004.0161, 1018.9606);
	angles[55] = (0, 95.2536, -7.4236);
	at[55] = 36;
	points[56] = (3380.7754, -8013.8188, 1011.7756);
	angles[56] = (0, 104.3094, -7.2489);
	at[56] = 36.5333;
	points[57] = (3273.1890, -8047.6382, 997.6378);
	angles[57] = (0, 108.4248, -7.1061);
	at[57] = 37.6000;
	points[58] = (3139.9565, -8094.2129, 980.1772);
	angles[58] = (0, 110.2781, -6.9597);
	at[58] = 38.9333;
	points[59] = (3062.6772, -8126.9688, 969.8307);
	angles[59] = (0, 114.1754, -6.9667);
	at[59] = 39.7333;
	points[60] = (2986.4802, -8163.6221, 960.3229);
	angles[60] = (0, 117.3758, -5.5784);
	at[60] = 40.5333;
	points[61] = (2938.8230, -8193.9766, 958.1299);
	angles[61] = (0, 124.6704, -0.7747);
	at[61] = 41.0667;
	points[62] = (2893.0986, -8227.6377, 958.0355);
	angles[62] = (0, 127.3295, 0.1353);
	at[62] = 41.6000;
	points[63] = (2849.8582, -8264.2910, 958.2244);
	angles[63] = (0, 133.7862, 0.0162);
	at[63] = 42.1333;
	points[64] = (2831.7639, -8285.8662, 958.1851);
	angles[64] = (0, 141.1291, -0.0446);
	at[64] = 42.4000;
	points[65] = (2767.1301, -8379.2910, 958.2402);
	angles[65] = (0, 148.1979, 0.0515);
	at[65] = 43.4667;
	points[66] = (2753.9607, -8403.7402, 958.2598);
	angles[66] = (0, 154.1291, -0.0049);
	at[66] = 43.7333;
	points[67] = (2744.3740, -8430.5908, 958.0748);
	angles[67] = (0, 161.4146, -0.4361);
	at[67] = 44;
	points[68] = (2728.8662, -8485.3945, 957.6614);
	angles[68] = (0, 165.3055, -0.3054);
	at[68] = 44.5333;
	points[69] = (2716.1655, -8540.9453, 957.8898);
	angles[69] = (0, 168.5422, 0.7962);
	at[69] = 45.0667;
	points[70] = (2712.6418, -8568.6221, 959.2402);
	angles[70] = (0, 175.2322, 3.8211);
	at[70] = 45.3333;
	points[71] = (2712.5708, -8596.7324, 961.9371);
	angles[71] = (0, 180.5557, 5.7279);
	at[71] = 45.6000;
	points[72] = (2714.9175, -8653.1494, 968.3268);
	angles[72] = (0, 182.9256, 6.7364);
	at[72] = 46.1333;
	points[73] = (2718.1260, -8765.2754, 983.5906);
	angles[73] = (0, 180.0137, 8.7160);
	at[73] = 47.2000;
	points[74] = (2718.9805, -8877.4014, 1001.4213);
	angles[74] = (0, 181.5336, 9.2624);
	at[74] = 48.2667;
	points[75] = (2723.8269, -8932.9131, 1011.0040);
	angles[75] = (0, 186.3486, 9.9890);
	at[75] = 48.8000;
	points[76] = (2738.3464, -9043.8975, 1031.0157);
	angles[76] = (0, 188.2111, 10.1751);
	at[76] = 49.8667;
	points[77] = (2754.5513, -9125.7480, 1046.0079);
	angles[77] = (0, 192.3123, 10.2021);
	at[77] = 50.6667;
	points[78] = (2770.8899, -9208.2285, 1061.1024);
	angles[78] = (0, 188.9605, 10.1084);
	at[78] = 51.4667;
	points[79] = (2772.7322, -9235.3545, 1065.8503);
	angles[79] = (0, 182.4675, 9.8401);
	at[79] = 51.7333;
	points[80] = (2772.7717, -9291.5361, 1075.4607);
	angles[80] = (0, 179.4005, 9.6677);
	at[80] = 52.2667;
	points[81] = (2769.6575, -9543.5039, 1118.0709);
	angles[81] = (0, 180.9447, 9.7021);
	at[81] = 54.6667;
	points[82] = (2779.9805, -9625.9844, 1133.4685);
	angles[82] = (0, 189.9101, 10.8210);
	at[82] = 55.4667;
	points[83] = (2797.8032, -9707.8740, 1148.9331);
	angles[83] = (0, 194.8971, 9.7767);
	at[83] = 56.2667;
	points[84] = (2819.8188, -9759.2520, 1156.0315);
	angles[84] = (0, 206.7206, 6.1911);
	at[84] = 56.8000;
	points[85] = (2861.7756, -9832.9531, 1163.8268);
	angles[85] = (0, 211.4561, 4.6154);
	at[85] = 57.6000;
	points[86] = (2928.3701, -9924.2910, 1169.1260);
	angles[86] = (0, 218.0642, 1.8118);
	at[86] = 58.6667;
	points[87] = (3035.5864, -10056.7715, 1173.9528);
	angles[87] = (0, 219.9658, 1.5500);
	at[87] = 60.2667;
	points[88] = (3073.2087, -10099.2520, 1175.5079);
	angles[88] = (0, 223.5785, 1.6164);
	at[88] = 60.8000;
	points[89] = (3135.9688, -10157.0859, 1177.8110);
	angles[89] = (0, 228.9836, 1.5060);
	at[89] = 61.6000;
	points[90] = (3185.4685, -10197.5596, 1179.4606);
	angles[90] = (0, 232.0295, 1.4638);
	at[90] = 62.2000;
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
	points[0] = (-2794.2637, -6607.2832, 969.9685);
	angles[0] = (0, 149.5420, 0);
	at[0] = 0;
	points[1] = (-3113.5828, -6454.2124, 986.1614);
	angles[1] = (0, 149.5420, 0);
	at[1] = 2.5000;
	points[2] = (-3394.5825, -6319.5278, 993.7048);
	angles[2] = (0, 149.5420, 0);
	at[2] = 4.7000;
	points[3] = (-3394.5825, -6319.5278, 993.7048);
	angles[3] = (0, 149.5420, 0);
	at[3] = 5.2000;
	points[4] = (-3113.3782, -6454.3311, 986.1536);
	angles[4] = (0, 149.5420, 0);
	at[4] = 7.4000;
	points[5] = (-2794.0630, -6607.3623, 969.9606);
	angles[5] = (0, 149.5420, 0);
	at[5] = 9.9000;
	points[6] = (-2791.9331, -6608.3857, 969.8661);
	angles[6] = (0, 149.5420, 0);
	at[6] = 9.9500;
	points[7] = (-2791.9331, -6608.3857, 969.8661);
	angles[7] = (0, 149.5420, 0);
	at[7] = 10.4000;
	points[8] = (-2794.2637, -6607.2832, 969.9685);
	angles[8] = (0, 149.5420, 0);
	at[8] = 10.4333;
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
	points[0] = (3308.3545, -3633.0747, 1013.8583);
	angles[0] = (0, 174.8640, 0);
	at[0] = 0;
	points[1] = (4064.9607, -3661.1653, 992.1496);
	angles[1] = (0, 174.8640, 0);
	at[1] = 2.8500;
	points[2] = (4091.4963, -3662.1497, 992.5316);
	angles[2] = (0, 174.8640, 0);
	at[2] = 2.9500;
	points[3] = (4100.3545, -3662.4805, 992.7677);
	angles[3] = (0, 174.8640, 0);
	at[3] = 3;
	points[4] = (4100.3545, -3662.4805, 992.7677);
	angles[4] = (0, 174.8640, 0);
	at[4] = 3.4500;
	points[5] = (4095.4331, -3662.2954, 992.6378);
	angles[5] = (0, 174.8640, 0);
	at[5] = 3.5000;
	points[6] = (3312.3071, -3633.2205, 1013.7441);
	angles[6] = (0, 174.8640, 0);
	at[6] = 6.4500;
	points[7] = (3303.4568, -3632.8896, 1013.9686);
	angles[7] = (0, 174.8640, 0);
	at[7] = 6.5000;
	points[8] = (3303.4568, -3632.8896, 1013.9686);
	angles[8] = (0, 174.8640, 0);
	at[8] = 6.9500;
	points[9] = (3308.3545, -3633.0747, 1013.8583);
	angles[9] = (0, 174.8640, 0);
	at[9] = 7;
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
	points[0] = (-3309.5513, -7501.1421, 986.5551);
	angles[0] = (0, 149.3030, 0);
	at[0] = 0;
	points[1] = (-3898.2876, -7120.2363, 964.6851);
	angles[1] = (0, 149.3030, 0);
	at[1] = 4.9500;
	points[2] = (-3902.2522, -7117.6377, 964.4095);
	angles[2] = (0, 149.3030, 0);
	at[2] = 5;
	points[3] = (-3902.2522, -7117.6377, 964.4095);
	angles[3] = (0, 149.3030, 0);
	at[3] = 5.4500;
	points[4] = (-3899.2715, -7119.5674, 964.6142);
	angles[4] = (0, 149.3030, 0);
	at[4] = 5.5000;
	points[5] = (-3310.5354, -7500.5117, 986.5236);
	angles[5] = (0, 149.3030, 0);
	at[5] = 10.4500;
	points[6] = (-3306.5708, -7503.0713, 986.6536);
	angles[6] = (0, 149.3030, 0);
	at[6] = 10.5000;
	points[7] = (-3306.5708, -7503.0713, 986.6536);
	angles[7] = (0, 149.3030, 0);
	at[7] = 10.9500;
	points[8] = (-3309.5513, -7501.1421, 986.5551);
	angles[8] = (0, 149.3030, 0);
	at[8] = 11;
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
	points[0] = (1722.6417, 3033.3938, 969.2323);
	angles[0] = (0, 126.2381, 0);
	at[0] = 0;
	points[1] = (1356.2716, 3571.6143, 970.0394);
	angles[1] = (0, 126.2381, 0);
	at[1] = 2.4500;
	points[2] = (1353.7797, 3575.2754, 970.0591);
	angles[2] = (0, 126.2381, 0);
	at[2] = 2.5000;
	points[3] = (1353.7797, 3575.2754, 970.0591);
	angles[3] = (0, 126.2381, 0);
	at[3] = 2.9500;
	points[4] = (1359.0078, 3567.5945, 970.0197);
	angles[4] = (0, 126.2381, 0);
	at[4] = 3;
	points[5] = (1725.3779, 3029.3740, 969.2441);
	angles[5] = (0, 126.2381, 0);
	at[5] = 5.4500;
	points[6] = (1725.3779, 3029.3740, 969.2441);
	angles[6] = (0, 126.2381, 0);
	at[6] = 5.9500;
	points[7] = (1722.6417, 3033.3938, 969.2323);
	angles[7] = (0, 126.2381, 0);
	at[7] = 5.9667;
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
	points[0] = (3120.5669, 3692.2600, 1043.3622);
	angles[0] = (0, 127.7340, 0);
	at[0] = 0;
	points[1] = (2657.2520, 4091.2205, 982.2166);
	angles[1] = (0, 127.7340, 0);
	at[1] = 4.3333;
	points[2] = (2528.9526, 4201.6929, 969.1536);
	angles[2] = (0, 127.7340, 0);
	at[2] = 5.5333;
	points[3] = (2523.6064, 4206.2993, 968.5040);
	angles[3] = (0, 127.7340, 0);
	at[3] = 5.6000;
	points[4] = (2523.6064, 4206.2993, 968.5040);
	angles[4] = (0, 127.7340, 0);
	at[4] = 6.0667;
	points[5] = (2529.9331, 4200.8662, 969.2716);
	angles[5] = (0, 127.7340, 0);
	at[5] = 6.1333;
	points[6] = (2658.2322, 4090.3542, 982.3464);
	angles[6] = (0, 127.7340, 0);
	at[6] = 7.3333;
	points[7] = (3121.5474, 3691.4136, 1043.4961);
	angles[7] = (0, 127.7340, 0);
	at[7] = 11.6667;
	points[8] = (3123.3308, 3689.8818, 1043.7401);
	angles[8] = (0, 127.7340, 0);
	at[8] = 11.7333;
	points[9] = (3123.3308, 3689.8818, 1043.7401);
	angles[9] = (0, 127.7340, 0);
	at[9] = 12.1333;
	points[10] = (3120.5669, 3692.2600, 1043.3622);
	angles[10] = (0, 127.7340, 0);
	at[10] = 12.2000;
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
	points[0] = (-3890.0986, 6281.4565, 958.1457);
	angles[0] = (0, -96.7731, 0);
	at[0] = 0;
	points[1] = (-3951.5750, 6350.8271, 957.5472);
	angles[1] = (0, -96.7731, 0);
	at[1] = 0.3500;
	points[2] = (-4399.3701, 6856.4570, 1021.1693);
	angles[2] = (0, -96.7731, 0);
	at[2] = 2.9000;
	points[3] = (-4402.3228, 6859.7642, 1021.6024);
	angles[3] = (0, -96.7731, 0);
	at[3] = 2.9500;
	points[4] = (-4402.3228, 6859.7642, 1021.6024);
	angles[4] = (0, -96.7731, 0);
	at[4] = 3.4000;
	points[5] = (-4396.0630, 6852.7168, 1020.6772);
	angles[5] = (0, -96.7731, 0);
	at[5] = 3.4500;
	points[6] = (-3957.0081, 6357.0078, 958.1890);
	angles[6] = (0, -96.7731, 0);
	at[6] = 5.9500;
	points[7] = (-3886.7717, 6277.6772, 958.1772);
	angles[7] = (0, -96.7731, 0);
	at[7] = 6.3500;
	points[8] = (-3886.7717, 6277.6772, 958.1772);
	angles[8] = (0, -96.7731, 0);
	at[8] = 6.8500;
	points[9] = (-3890.0986, 6281.4565, 958.1457);
	angles[9] = (0, -96.7731, 0);
	at[9] = 6.8667;
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
	points[0] = (-5403.5039, 6170.3149, 968.2756);
	angles[0] = (0, -78.0910, 0);
	at[0] = 0;
	points[1] = (-6029.2915, 6466.7715, 1021.5945);
	angles[1] = (0, -78.0910, 0);
	at[1] = 4.9000;
	points[2] = (-6033.5435, 6468.7798, 1021.9724);
	angles[2] = (0, -78.0910, 0);
	at[2] = 4.9500;
	points[3] = (-6033.5435, 6468.7798, 1021.9724);
	angles[3] = (0, -78.0910, 0);
	at[3] = 5.4000;
	points[4] = (-6030.1973, 6467.2046, 1021.6772);
	angles[4] = (0, -78.0910, 0);
	at[4] = 5.4500;
	points[5] = (-5404.4487, 6170.7876, 968.3544);
	angles[5] = (0, -78.0910, 0);
	at[5] = 10.3500;
	points[6] = (-5400.1577, 6168.7402, 968.0039);
	angles[6] = (0, -78.0910, 0);
	at[6] = 10.4000;
	points[7] = (-5400.1577, 6168.7402, 968.0039);
	angles[7] = (0, -78.0910, 0);
	at[7] = 10.8500;
	points[8] = (-5403.5039, 6170.3149, 968.2756);
	angles[8] = (0, -78.0910, 0);
	at[8] = 10.9000;
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
	points[0] = (-1129.2480, 5015.6694, 959.3150);
	angles[0] = (0, -106.5773, -0.6099);
	at[0] = 0;
	points[1] = (-1084.7047, 5006.6143, 959.2086);
	angles[1] = (0, -97.6107, 0.2239);
	at[1] = 0.4333;
	points[2] = (-1038.4922, 5004.2915, 959.8071);
	angles[2] = (0, -91.9104, 0.8487);
	at[2] = 0.8667;
	points[3] = (-876.6457, 5003.5039, 962.5472);
	angles[3] = (0, -89.3083, 0.9957);
	at[3] = 2.3833;
	points[4] = (-785.1378, 5007.1260, 964.0275);
	angles[4] = (0, -84.5260, 0.7374);
	at[4] = 3.2500;
	points[5] = (-740.1418, 5017.3623, 964.3583);
	angles[5] = (0, -74.5834, 0.3062);
	at[5] = 3.6833;
	points[6] = (-674.3701, 5039.1343, 964.5945);
	angles[6] = (0, -70.7506, 0.1598);
	at[6] = 4.3333;
	points[7] = (-608.7992, 5060.0786, 964.9055);
	angles[7] = (0, -74.8745, 0.4271);
	at[7] = 4.9833;
	points[8] = (-497.0472, 5088.2285, 965.9489);
	angles[8] = (0, -76.0877, 0.5242);
	at[8] = 6.0667;
	points[9] = (-362.3098, 5118.7007, 966.8386);
	angles[9] = (0, -78.9463, 0.1804);
	at[9] = 7.3667;
	points[10] = (-294.5941, 5133.2285, 966.9252);
	angles[10] = (0, -76.3335, -0.0305);
	at[10] = 8.0167;
	points[11] = (-251.8284, 5148.6221, 966.6299);
	angles[11] = (0, -66.6460, -0.5913);
	at[11] = 8.4500;
	points[12] = (-107.8232, 5222.2046, 964.3740);
	angles[12] = (0, -59.8021, -0.9041);
	at[12] = 9.9667;
	points[13] = (-50.3047, 5260.0791, 963.1181);
	angles[13] = (0, -55.4483, -1.0854);
	at[13] = 10.6167;
	points[14] = (5.0524, 5301.7324, 961.7598);
	angles[14] = (0, -50.6316, -1.1532);
	at[14] = 11.2667;
	points[15] = (21.9918, 5317.6772, 961.2795);
	angles[15] = (0, -45.0833, -1.1965);
	at[15] = 11.4833;
	points[16] = (33.9503, 5336.3784, 960.7874);
	angles[16] = (0, -29.8408, -1.2767);
	at[16] = 11.7000;
	points[17] = (43.2453, 5357.6777, 960.2638);
	angles[17] = (0, -22.8994, -1.2920);
	at[17] = 11.9167;
	points[18] = (65.0083, 5423.4644, 958.7205);
	angles[18] = (0, -16.0931, -1.2572);
	at[18] = 12.5667;
	points[19] = (75.2472, 5468.5825, 957.7520);
	angles[19] = (0, -9.9322, -1.1348);
	at[19] = 13;
	points[20] = (75.9764, 5490.8267, 957.3661);
	angles[20] = (0, -0.3098, -0.9747);
	at[20] = 13.2167;
	points[21] = (72.4177, 5537.0864, 956.6457);
	angles[21] = (0, 5.5884, -0.8612);
	at[21] = 13.6500;
	points[22] = (56.8697, 5651.0234, 955.4134);
	angles[22] = (0, 9.2725, -0.0339);
	at[22] = 14.7333;
	points[23] = (39.0172, 5741.6533, 956.0472);
	angles[23] = (0, 12.8202, 0.4993);
	at[23] = 15.6000;
	points[24] = (26.3265, 5785.9448, 956.4567);
	angles[24] = (0, 18.9927, 0.4929);
	at[24] = 16.0333;
	points[25] = (17.0891, 5806.3389, 956.6457);
	angles[25] = (0, 25.0475, 0.4880);
	at[25] = 16.2500;
	points[26] = (6.6006, 5827.0078, 956.8464);
	angles[26] = (0, 27.0925, 0.4976);
	at[26] = 16.4667;
	points[27] = (-60.9012, 5948.5039, 958.0906);
	angles[27] = (0, 30.2663, 0.5290);
	at[27] = 17.7667;
	points[28] = (-125.8358, 6042.9922, 959.3268);
	angles[28] = (0, 36.8598, 0.6539);
	at[28] = 18.8500;
	points[29] = (-183.8079, 6114.2910, 960.3268);
	angles[29] = (0, 41.8793, 0.5684);
	at[29] = 19.7167;
	points[30] = (-296.4461, 6230.0391, 961.8347);
	angles[30] = (0, 46.7271, 0.5053);
	at[30] = 21.2333;
	points[31] = (-313.8461, 6245.3545, 962.0275);
	angles[31] = (0, 49.3934, 0.4748);
	at[31] = 21.4500;
	points[32] = (-332.6677, 6257.8740, 962.1575);
	angles[32] = (0, 58.9453, 0.2326);
	at[32] = 21.6667;
	points[33] = (-375.2646, 6275.3545, 962.0905);
	angles[33] = (0, 70.1769, -0.1314);
	at[33] = 22.1000;
	points[34] = (-441.6614, 6294.8428, 962.1575);
	angles[34] = (0, 75.4035, 0.3178);
	at[34] = 22.7500;
	points[35] = (-486.2914, 6304.6855, 963.0945);
	angles[35] = (0, 78.9842, 1.8251);
	at[35] = 23.1833;
	points[36] = (-623.0040, 6326.0635, 968.9213);
	angles[36] = (0, 82.2174, 2.5083);
	at[36] = 24.4833;
	points[37] = (-715.3386, 6335.2759, 972.8779);
	angles[37] = (0, 87.6623, 2.2737);
	at[37] = 25.3500;
	points[38] = (-759.6457, 6328.1890, 974.1851);
	angles[38] = (0, 103.6353, 1.4320);
	at[38] = 25.7833;
	points[39] = (-825.5473, 6306.8506, 975.6575);
	angles[39] = (0, 109.4033, 1.1532);
	at[39] = 26.4333;
	points[40] = (-890.4528, 6284.5278, 977.1418);
	angles[40] = (0, 106.7459, 1.4485);
	at[40] = 27.0833;
	points[41] = (-957.5157, 6266.4175, 979.1260);
	angles[41] = (0, 104.9335, 1.6772);
	at[41] = 27.7333;
	points[42] = (-1068.7480, 6235.9844, 982.6418);
	angles[42] = (0, 106.3378, 1.8412);
	at[42] = 28.8167;
	points[43] = (-1222.0315, 6186.2993, 988.4921);
	angles[43] = (0, 108.7923, 2.0685);
	at[43] = 30.3333;
	points[44] = (-1286.0118, 6161.8110, 990.7244);
	angles[44] = (0, 113.9398, 1.6159);
	at[44] = 30.9833;
	points[45] = (-1368.8190, 6120.7876, 993.0118);
	angles[45] = (0, 117.1292, 1.3091);
	at[45] = 31.8500;
	points[46] = (-1572.5748, 6013.3467, 994.4843);
	angles[46] = (0, 118.8400, -0.2254);
	at[46] = 34.0167;
	points[47] = (-1612.8466, 5989.9214, 994.1260);
	angles[47] = (0, 121.5237, -0.6324);
	at[47] = 34.4500;
	points[48] = (-1630.9448, 5977.0474, 993.6378);
	angles[48] = (0, 126.1920, -1.4224);
	at[48] = 34.6667;
	points[49] = (-1701.6339, 5917.7163, 990.2795);
	angles[49] = (0, 131.5731, -2.2767);
	at[49] = 35.5333;
	points[50] = (-1751.1930, 5869.8818, 987.4685);
	angles[50] = (0, 137.3582, -2.3191);
	at[50] = 36.1833;
	points[51] = (-1765.2953, 5851.8110, 986.5158);
	angles[51] = (0, 142.7006, -2.4006);
	at[51] = 36.4000;
	points[52] = (-1791.3583, 5813.7402, 984.5394);
	angles[52] = (0, 146.6434, -2.4592);
	at[52] = 36.8333;
	points[53] = (-1826.4843, 5753.9370, 981.6063);
	angles[53] = (0, 152.2570, -2.3616);
	at[53] = 37.4833;
	points[54] = (-1841.7992, 5711.1421, 979.9488);
	angles[54] = (0, 164.1401, -1.9429);
	at[54] = 37.9167;
	points[55] = (-1857.1929, 5643.6226, 977.7244);
	angles[55] = (0, 168.5793, -1.7963);
	at[55] = 38.5667;
	points[56] = (-1867.3149, 5574.8823, 975.6378);
	angles[56] = (0, 174.8047, -1.6389);
	at[56] = 39.2167;
	points[57] = (-1866.6851, 5552.6382, 975.0709);
	angles[57] = (0, 185.5382, -1.3424);
	at[57] = 39.4333;
	points[58] = (-1858.5946, 5530.8657, 974.7520);
	angles[58] = (0, 202.2669, -0.7146);
	at[58] = 39.6500;
	points[59] = (-1847.8229, 5510.6689, 974.5551);
	angles[59] = (0, 208.7498, -0.4609);
	at[59] = 39.8667;
	points[60] = (-1809.3269, 5452.9922, 974.1772);
	angles[60] = (0, 216.1700, -0.2749);
	at[60] = 40.5167;
	points[61] = (-1780.3229, 5418.1890, 973.9095);
	angles[61] = (0, 223.4211, -0.4242);
	at[61] = 40.9500;
	points[62] = (-1762.5552, 5402.7168, 973.7244);
	angles[62] = (0, 229.5572, -0.4519);
	at[62] = 41.1667;
	points[63] = (-1707.7755, 5360.4727, 973.1732);
	angles[63] = (0, 233.1811, -0.4586);
	at[63] = 41.8167;
	points[64] = (-1634.1221, 5305.3154, 972.3976);
	angles[64] = (0, 231.7339, -0.5345);
	at[64] = 42.6833;
	points[65] = (-1616.8308, 5290.0786, 972.2007);
	angles[65] = (0, 228.1346, -0.4747);
	at[65] = 42.9000;
	points[66] = (-1583.1221, 5258.6616, 971.8110);
	angles[66] = (0, 227.1275, -0.5211);
	at[66] = 43.3333;
	points[67] = (-1548.4685, 5228.1895, 971.2756);
	angles[67] = (0, 229.9319, -0.7642);
	at[67] = 43.7667;
	points[68] = (-1512.0157, 5202.2051, 970.4094);
	angles[68] = (0, 238.0407, -1.3711);
	at[68] = 44.2000;
	points[69] = (-1471.2992, 5179.2915, 969.1024);
	angles[69] = (0, 241.0940, -1.6476);
	at[69] = 44.6333;
	points[70] = (-1245.4883, 5061.1025, 961.6182);
	angles[70] = (0, 243.7953, -1.5676);
	at[70] = 47.0167;
	points[71] = (-1182.9409, 5033.9370, 960.1221);
	angles[71] = (0, 248.2173, -1.0909);
	at[71] = 47.6667;
	points[72] = (-1129.2480, 5015.6694, 959.3150);
	angles[72] = (0, 253.4227, -0.6099);
	at[72] = 48.2000;
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
	points[0] = (3424, 4587.0078, 1015.9803);
	angles[0] = (0, 120.3655, -5.0357);
	at[0] = 0;
	points[1] = (3317.9883, 4524.7246, 1005.7795);
	angles[1] = (0, 120.8410, -3.9887);
	at[1] = 1.1667;
	points[2] = (3146.7480, 4423.7007, 995.8386);
	angles[2] = (0, 118.4625, -2.6991);
	at[2] = 3.0333;
	points[3] = (3101.0828, 4405.8267, 993.0236);
	angles[3] = (0, 106.3587, -3.5970);
	at[3] = 3.5000;
	points[4] = (3028.7480, 4388.5435, 988.2401);
	angles[4] = (0, 103.4195, -3.6108);
	at[4] = 4.2000;
	points[5] = (2980.9724, 4374.4883, 985.3740);
	angles[5] = (0, 109.5870, -2.9755);
	at[5] = 4.6667;
	points[6] = (2960.6692, 4362.1655, 984.6339);
	angles[6] = (0, 127.6833, -1.0828);
	at[6] = 4.9000;
	points[7] = (2945.1733, 4342.4805, 984.8701);
	angles[7] = (0, 143.3981, 0.7264);
	at[7] = 5.1333;
	points[8] = (2919.6101, 4299.8032, 986.0670);
	angles[8] = (0, 150.9012, 1.5809);
	at[8] = 5.6000;
	points[9] = (2887.3032, 4232.3623, 988.6142);
	angles[9] = (0, 157.2285, 2.2367);
	at[9] = 6.3000;
	points[10] = (2880.1694, 4209.3701, 989.7756);
	angles[10] = (0, 166.0479, 3.0798);
	at[10] = 6.5333;
	points[11] = (2878.1497, 4184.6460, 991.4882);
	angles[11] = (0, 176.6260, 4.0574);
	at[11] = 6.7667;
	points[12] = (2878.1260, 4159.7637, 993.3701);
	angles[12] = (0, 180.4355, 4.3566);
	at[12] = 7;
	points[13] = (2880.0828, 4110.3149, 997.2205);
	angles[13] = (0, 182.7472, 4.4396);
	at[13] = 7.4667;
	points[14] = (2881.6338, 4061.5750, 1000.7756);
	angles[14] = (0, 180.1090, 3.8228);
	at[14] = 7.9333;
	points[15] = (2877.9961, 3912.2205, 1009.6812);
	angles[15] = (0, 179.8795, 3.4433);
	at[15] = 9.3333;
	points[16] = (2879.9529, 3862.5276, 1012.8032);
	angles[16] = (0, 184.5789, 3.7313);
	at[16] = 9.8000;
	points[17] = (2885.1497, 3838.9016, 1014.5591);
	angles[17] = (0, 195.2627, 4.2771);
	at[17] = 10.0333;
	points[18] = (2904.1931, 3793.3269, 1018.4764);
	angles[18] = (0, 204.6838, 4.5954);
	at[18] = 10.5000;
	points[19] = (2938.4883, 3727.3230, 1024.5945);
	angles[19] = (0, 209.0842, 4.7782);
	at[19] = 11.2000;
	points[20] = (2964.5078, 3685.3425, 1028.8820);
	angles[20] = (0, 214.6300, 5.1715);
	at[20] = 11.6667;
	points[21] = (2980.7205, 3666.9883, 1031.2756);
	angles[21] = (0, 222.7337, 5.6428);
	at[21] = 11.9000;
	points[22] = (3035.8191, 3617.3621, 1038.8701);
	angles[22] = (0, 230.3921, 5.9103);
	at[22] = 12.6000;
	points[23] = (3075.9802, 3588.1694, 1044.0472);
	angles[23] = (0, 237.2914, 5.9674);
	at[23] = 13.0667;
	points[24] = (3098.0435, 3578.8267, 1046.5708);
	angles[24] = (0, 249.5050, 6.0294);
	at[24] = 13.3000;
	points[25] = (3121.9133, 3572.1340, 1049.1732);
	angles[25] = (0, 255.0103, 5.9770);
	at[25] = 13.5333;
	points[26] = (3194.7285, 3557.4250, 1056.6063);
	angles[26] = (0, 260.2697, 5.4472);
	at[26] = 14.2333;
	points[27] = (3268.0828, 3548.8977, 1062.3544);
	angles[27] = (0, 265.4601, 3.8157);
	at[27] = 14.9333;
	points[28] = (3491.4844, 3535.8267, 1076.3779);
	angles[28] = (0, 267.4314, 3.5916);
	at[28] = 17.0333;
	points[29] = (3614.5120, 3533.8110, 1084.2087);
	angles[29] = (0, 270.3459, 3.6932);
	at[29] = 18.2000;
	points[30] = (3663.5750, 3535.7913, 1087.5079);
	angles[30] = (0, 274.4642, 4.0160);
	at[30] = 18.6667;
	points[31] = (3712.6929, 3543.0552, 1091.2953);
	angles[31] = (0, 279.3396, 4.4363);
	at[31] = 19.1333;
	points[32] = (3810.2639, 3561.2756, 1099.0511);
	angles[32] = (0, 281.4042, 4.4371);
	at[32] = 20.0667;
	points[33] = (3881.9490, 3578.6890, 1104.3386);
	angles[33] = (0, 285.2435, 3.8138);
	at[33] = 20.7667;
	points[34] = (3976.3386, 3609.7639, 1110.7086);
	angles[34] = (0, 292.0685, 3.5718);
	at[34] = 21.7000;
	points[35] = (3997.5198, 3620.8230, 1112.1536);
	angles[35] = (0, 300.3960, 3.3817);
	at[35] = 21.9333;
	points[36] = (4017.5198, 3636.1497, 1113.5237);
	angles[36] = (0, 308.2728, 3.0748);
	at[36] = 22.1667;
	points[37] = (4036.4175, 3652.2166, 1114.8149);
	angles[37] = (0, 310.7048, 2.9692);
	at[37] = 22.4000;
	points[38] = (4181.4565, 3787.3149, 1125.3859);
	angles[38] = (0, 313.6089, 3.4126);
	at[38] = 24.2667;
	points[39] = (4268.8188, 3875.0474, 1132.8622);
	angles[39] = (0, 317.8953, 3.4402);
	at[39] = 25.4333;
	points[40] = (4283.6221, 3894.7126, 1134.3071);
	angles[40] = (0, 325.0288, 3.3395);
	at[40] = 25.6667;
	points[41] = (4308.2676, 3937.7166, 1137.1378);
	angles[41] = (0, 331.7614, 3.2316);
	at[41] = 26.1333;
	points[42] = (4339.2915, 4005.3938, 1141.1417);
	angles[42] = (0, 338.9774, 2.8805);
	at[42] = 26.8333;
	points[43] = (4344.8818, 4029.1338, 1142.1536);
	angles[43] = (0, 349.8870, 2.1693);
	at[43] = 27.0667;
	points[44] = (4347.2441, 4078.7402, 1143.6024);
	angles[44] = (0, 359.1262, 1.5372);
	at[44] = 27.5333;
	points[45] = (4344.4097, 4153.2280, 1145.3071);
	angles[45] = (0, 364.5361, 1.1272);
	at[45] = 28.2333;
	points[46] = (4340.9448, 4177.3228, 1145.6614);
	angles[46] = (0, 369.7574, 0.7082);
	at[46] = 28.4667;
	points[47] = (4329.2520, 4225.6694, 1146.0079);
	angles[47] = (0, 374.4259, 0.3345);
	at[47] = 28.9333;
	points[48] = (4309.9214, 4297.9136, 1146.3898);
	angles[48] = (0, 375.0227, 0.2870);
	at[48] = 29.6333;
	points[49] = (4297.4014, 4346.2202, 1146.6732);
	angles[49] = (0, 373.9700, 0.3722);
	at[49] = 30.1000;
	points[50] = (4288.8979, 4394.5278, 1147.2953);
	angles[50] = (0, 367.6809, 0.9560);
	at[50] = 30.5667;
	points[51] = (4274.6064, 4567.2837, 1150.0118);
	angles[51] = (0, 362.9601, 0.1115);
	at[51] = 32.2000;
	points[52] = (4272.3623, 4642.0474, 1150.1300);
	angles[52] = (0, 360.3646, 0.2207);
	at[52] = 32.9000;
	points[53] = (4275.1968, 4691.8110, 1150.7756);
	angles[53] = (0, 353.0867, 1.2971);
	at[53] = 33.3667;
	points[54] = (4282.2441, 4714.6851, 1151.9448);
	angles[54] = (0, 340.4193, 3.1281);
	at[54] = 33.6000;
	points[55] = (4292.4409, 4737.4019, 1153.5669);
	angles[55] = (0, 335.3055, 3.7965);
	at[55] = 33.8333;
	points[56] = (4314.9604, 4781.7324, 1157.1141);
	angles[56] = (0, 332.3372, 4.1751);
	at[56] = 34.3000;
	points[57] = (4361.7324, 4868.1890, 1164.5039);
	angles[57] = (0, 331.6609, 4.3353);
	at[57] = 35.2333;
	points[58] = (4413.1104, 4953.3857, 1172.5669);
	angles[58] = (0, 328.9966, 4.6545);
	at[58] = 36.1667;
	points[59] = (4448.9766, 5018.4253, 1178.4213);
	angles[59] = (0, 333.7791, 4.3098);
	at[59] = 36.8667;
	points[60] = (4458.1494, 5041.9683, 1180.1497);
	angles[60] = (0, 341.2883, 3.6875);
	at[60] = 37.1000;
	points[61] = (4458.7793, 5065.6304, 1181.0197);
	angles[61] = (0, 362.3398, 1.7403);
	at[61] = 37.3333;
	points[62] = (4454.2915, 5090.2754, 1181.4331);
	angles[62] = (0, 371.3622, 0.8309);
	at[62] = 37.5667;
	points[63] = (4432.2441, 5161.5752, 1181.6456);
	angles[63] = (0, 379.9680, -0.1965);
	at[63] = 38.2667;
	points[64] = (4412.3623, 5207.3623, 1180.9724);
	angles[64] = (0, 386.3533, -1.3078);
	at[64] = 38.7333;
	points[65] = (4398.0708, 5226.4966, 1179.6693);
	angles[65] = (0, 400.1777, -3.6278);
	at[65] = 38.9667;
	points[66] = (4379.9214, 5243.6221, 1177.6771);
	angles[66] = (0, 407.4104, -4.6801);
	at[66] = 39.2000;
	points[67] = (4321.9688, 5290.1572, 1170.8190);
	angles[67] = (0, 412.5280, -5.5239);
	at[67] = 39.9000;
	points[68] = (4264.3311, 5335.8662, 1163.1732);
	angles[68] = (0, 410.6312, -6.2177);
	at[68] = 40.6000;
	points[69] = (4186.1025, 5396.5747, 1151.7047);
	angles[69] = (0, 414.6068, -7.0433);
	at[69] = 41.5333;
	points[70] = (4165.0396, 5409.7246, 1148.3977);
	angles[70] = (0, 419.8279, -7.8324);
	at[70] = 41.7667;
	points[71] = (4142.5986, 5417.2046, 1144.5039);
	angles[71] = (0, 434.1588, -9.6514);
	at[71] = 42;
	points[72] = (4118.4253, 5421.7324, 1140.0826);
	angles[72] = (0, 440.0790, -10.2507);
	at[72] = 42.2333;
	points[73] = (4045.3542, 5428.8975, 1126.3188);
	angles[73] = (0, 446.8988, -10.8095);
	at[73] = 42.9333;
	points[74] = (4021.1812, 5429.2124, 1121.6300);
	angles[74] = (0, 450.2275, -11.0280);
	at[74] = 43.1667;
	points[75] = (3997.4014, 5426.1812, 1116.8071);
	angles[75] = (0, 459.8461, -11.4530);
	at[75] = 43.4000;
	points[76] = (3973.7795, 5420.0786, 1111.8229);
	angles[76] = (0, 465.1111, -11.5528);
	at[76] = 43.6333;
	points[77] = (3927.2993, 5405.2363, 1101.8386);
	angles[77] = (0, 468.7544, -11.5659);
	at[77] = 44.1000;
	points[78] = (3860.0276, 5378.0317, 1087.0276);
	angles[78] = (0, 476.3536, -11.4459);
	at[78] = 44.8000;
	points[79] = (3839.0159, 5365.3940, 1082.1182);
	angles[79] = (0, 481.6492, -11.2930);
	at[79] = 45.0333;
	points[80] = (3798.7246, 5338.1104, 1072.5039);
	angles[80] = (0, 485.1234, -11.1126);
	at[80] = 45.5000;
	points[81] = (3741.0632, 5292.5591, 1058.4133);
	angles[81] = (0, 491.6750, -10.5311);
	at[81] = 46.2000;
	points[82] = (3725.6221, 5274.8032, 1054.3977);
	angles[82] = (0, 503.1419, -9.1456);
	at[82] = 46.4333;
	points[83] = (3714.3230, 5252.7168, 1051.0315);
	angles[83] = (0, 514.1337, -7.5337);
	at[83] = 46.6667;
	points[84] = (3696.4529, 5206.5747, 1045.1890);
	angles[84] = (0, 520.5914, -6.4074);
	at[84] = 47.1333;
	points[85] = (3682.6379, 5158.9370, 1040.1890);
	angles[85] = (0, 526.0444, -5.2902);
	at[85] = 47.6000;
	points[86] = (3678.7048, 5134.3311, 1038.3544);
	angles[86] = (0, 533.3051, -3.6533);
	at[86] = 47.8333;
	points[87] = (3684.0078, 5111.0630, 1038.7086);
	angles[87] = (0, 557.6401, 1.9196);
	at[87] = 48.0667;
	points[88] = (3694.9333, 5088.7402, 1040.3583);
	angles[88] = (0, 566.9717, 4.0016);
	at[88] = 48.3000;
	points[89] = (3719.7600, 5045.7480, 1044.4763);
	angles[89] = (0, 570.5478, 4.9293);
	at[89] = 48.7667;
	points[90] = (3732.2126, 5024.2124, 1046.6338);
	angles[90] = (0, 569.6553, 4.9279);
	at[90] = 49;
	points[91] = (3743.3267, 5001.9292, 1048.6300);
	angles[91] = (0, 564.7371, 4.3625);
	at[91] = 49.2333;
	points[92] = (3749.6023, 4978.7793, 1049.9803);
	angles[92] = (0, 553.9023, 3.1252);
	at[92] = 49.4667;
	points[93] = (3754.4648, 4954.2124, 1051.2440);
	angles[93] = (0, 550.8083, 2.8491);
	at[93] = 49.7000;
	points[94] = (3763.7048, 4880.1968, 1054.3346);
	angles[94] = (0, 543.8664, 1.8867);
	at[94] = 50.4000;
	points[95] = (3763.3032, 4855.3940, 1054.8110);
	angles[95] = (0, 536.8052, 0.7299);
	at[95] = 50.6333;
	points[96] = (3755.0237, 4832.7559, 1053.8425);
	angles[96] = (0, 515.3257, -3.1840);
	at[96] = 50.8667;
	points[97] = (3741.4448, 4812.0078, 1051.8149);
	angles[97] = (0, 505.6279, -4.8414);
	at[97] = 51.1000;
	points[98] = (3709.6733, 4774.0161, 1047.1143);
	angles[98] = (0, 497.6289, -5.5659);
	at[98] = 51.5667;
	points[99] = (3673.6890, 4740.1577, 1042.3188);
	angles[99] = (0, 490.5522, -5.4381);
	at[99] = 52.0333;
	points[100] = (3655.1970, 4726.3389, 1040.2087);
	angles[100] = (0, 485.5492, -5.1783);
	at[100] = 52.2667;
	points[101] = (3612.5786, 4699.2129, 1035.6378);
	angles[101] = (0, 481.8119, -5.1715);
	at[101] = 52.7333;
	points[102] = (3424, 4587.0078, 1015.9803);
	angles[102] = (0, 480.3655, -5.0357);
	at[102] = 54.8000;
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
