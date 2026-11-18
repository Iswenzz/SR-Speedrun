main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_donut_plains_3", 0);

	setExpFog(0, 61515.7461, 1, 1, 1, 0);

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
	ambientPlay("iz_0_15", 2);
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
	level.iz_route[level.iz_route.size] = (5926, 157, 1140);
	level.iz_route[level.iz_route.size] = (5922, -123, 1141);
	level.iz_route[level.iz_route.size] = (5923, -557, 1147);
	level.iz_route[level.iz_route.size] = (5908, -1138, 1160);
	level.iz_route[level.iz_route.size] = (5896, -1785, 1163);
	level.iz_route[level.iz_route.size] = (5877, -2392, 1160);
	level.iz_route[level.iz_route.size] = (5800, -2842, 1153);
	level.iz_route[level.iz_route.size] = (5643, -3371, 1146);
	level.iz_route[level.iz_route.size] = (5353, -3782, 1145);
	level.iz_route[level.iz_route.size] = (5241, -4080, 1148);
	level.iz_route[level.iz_route.size] = (5205, -4376, 1152);
	level.iz_route[level.iz_route.size] = (5280, -4661, 1155);
	level.iz_route[level.iz_route.size] = (5410, -4997, 1164);
	level.iz_route[level.iz_route.size] = (5464, -5233, 1176);
	level.iz_route[level.iz_route.size] = (5380, -5601, 1195);
	level.iz_route[level.iz_route.size] = (5164, -5967, 1211);
	level.iz_route[level.iz_route.size] = (4889, -6139, 1209);
	level.iz_route[level.iz_route.size] = (4537, -6193, 1199);
	level.iz_route[level.iz_route.size] = (4161, -6208, 1185);
	level.iz_route[level.iz_route.size] = (3694, -6202, 1172);
	level.iz_route[level.iz_route.size] = (3280, -6207, 1166);
	level.iz_route[level.iz_route.size] = (2862, -6196, 1161);
	level.iz_route[level.iz_route.size] = (2301, -6210, 1176);
	level.iz_route[level.iz_route.size] = (1768, -6237, 1176);
	level.iz_route[level.iz_route.size] = (1193, -6255, 1177);
	level.iz_route[level.iz_route.size] = (735, -6295, 1178);
	level.iz_route[level.iz_route.size] = (243, -6339, 1178);
	level.iz_route[level.iz_route.size] = (-95, -6345, 1181);
	level.iz_route[level.iz_route.size] = (-548, -6305, 1182);
	level.iz_route[level.iz_route.size] = (-876, -6299, 1182);
	level.iz_route[level.iz_route.size] = (-1260, -6306, 1184);
	level.iz_route[level.iz_route.size] = (-1656, -6283, 1186);
	level.iz_route[level.iz_route.size] = (-2218, -6259, 1188);
	level.iz_route[level.iz_route.size] = (-2880, -6265, 1179);
	level.iz_route[level.iz_route.size] = (-3311, -6315, 1182);
	level.iz_route[level.iz_route.size] = (-3758, -6361, 1196);
	level.iz_route[level.iz_route.size] = (-4343, -6243, 1214);
	level.iz_route[level.iz_route.size] = (-5050, -6027, 1242);
	level.iz_route[level.iz_route.size] = (-5427, -5762, 1260);
	level.iz_route[level.iz_route.size] = (-5815, -5423, 1281);
	level.iz_route[level.iz_route.size] = (-6129, -5097, 1303);
	level.iz_route[level.iz_route.size] = (-6302, -4604, 1307);
	level.iz_route[level.iz_route.size] = (-6411, -4027, 1305);
	level.iz_route[level.iz_route.size] = (-6442, -3418, 1299);
	level.iz_route[level.iz_route.size] = (-6359, -2885, 1291);
	level.iz_route[level.iz_route.size] = (-6043, -2484, 1256);
	level.iz_route[level.iz_route.size] = (-5652, -2253, 1218);
	level.iz_route[level.iz_route.size] = (-5240, -2058, 1191);
	level.iz_route[level.iz_route.size] = (-4806, -1967, 1175);
	level.iz_route[level.iz_route.size] = (-4246, -1955, 1182);
	level.iz_route[level.iz_route.size] = (-3691, -1953, 1182);
	level.iz_route[level.iz_route.size] = (-2914, -1976, 1182);
	level.iz_route[level.iz_route.size] = (-2315, -2019, 1182);
	level.iz_route[level.iz_route.size] = (-1459, -2001, 941);
	level.iz_route[level.iz_route.size] = (-908, -2004, 941);
	level.iz_route[level.iz_route.size] = (-197, -2020, 941);
	level.iz_route[level.iz_route.size] = (348, -2013, 941);
	level.iz_route[level.iz_route.size] = (860, -1994, 1067);
	level.iz_route[level.iz_route.size] = (1185, -1977, 1134);
	level.iz_route[level.iz_route.size] = (1728, -1905, 1168);
	level.iz_route[level.iz_route.size] = (2147, -1664, 1199);
	level.iz_route[level.iz_route.size] = (2389, -1104, 1217);
	level.iz_route[level.iz_route.size] = (2322, -561, 1218);
	level.iz_route[level.iz_route.size] = (2139, -83, 1214);
	level.iz_route[level.iz_route.size] = (1809, 307, 1204);
	level.iz_route[level.iz_route.size] = (1233, 730, 1187);
	level.iz_route[level.iz_route.size] = (574, 691, 1157);
	level.iz_route[level.iz_route.size] = (30, 628, 1143);
	level.iz_route[level.iz_route.size] = (-515, 622, 1138);
	level.iz_route[level.iz_route.size] = (-1270, 838, 1136);
	level.iz_route[level.iz_route.size] = (-1674, 1282, 1134);
	level.iz_route[level.iz_route.size] = (-1894, 1776, 1134);
	level.iz_route[level.iz_route.size] = (-2258, 2294, 1138);
	level.iz_route[level.iz_route.size] = (-2475, 2595, 1143);
	level.iz_route[level.iz_route.size] = (-2927, 2894, 1151);
	level.iz_route[level.iz_route.size] = (-3791, 2986, 1153);
	level.iz_route[level.iz_route.size] = (-4567, 2906, 1141);
	level.iz_route[level.iz_route.size] = (-5374, 2845, 1146);
	level.iz_route[level.iz_route.size] = (-5963, 3081, 1159);
	level.iz_route[level.iz_route.size] = (-6393, 3366, 1167);
	level.iz_route[level.iz_route.size] = (-6595, 3660, 1174);
	level.iz_route[level.iz_route.size] = (-6635, 3931, 1174);
	level.iz_route[level.iz_route.size] = (-6581, 4242, 1174);
	level.iz_route[level.iz_route.size] = (-6480, 4488, 1173);
	level.iz_route[level.iz_route.size] = (-6325, 4685, 1171);
	level.iz_route[level.iz_route.size] = (-6040, 4931, 1168);
	level.iz_route[level.iz_route.size] = (-5746, 5111, 1170);
	level.iz_route[level.iz_route.size] = (-5339, 5244, 1172);
	level.iz_route[level.iz_route.size] = (-4929, 5304, 1170);
	level.iz_route[level.iz_route.size] = (-4300, 5386, 1169);
	level.iz_route[level.iz_route.size] = (-3478, 5417, 1164);
	level.iz_route[level.iz_route.size] = (-2640, 5412, 1162);
	level.iz_route[level.iz_route.size] = (-1792, 5355, 1156);
	level.iz_route[level.iz_route.size] = (-1267, 5200, 1150);
	level.iz_route[level.iz_route.size] = (-733, 4924, 1150);
	level.iz_route[level.iz_route.size] = (-299, 4636, 1144);
	level.iz_route[level.iz_route.size] = (128, 4241, 1135);
	level.iz_route[level.iz_route.size] = (558, 3830, 1142);
	level.iz_route[level.iz_route.size] = (1153, 3594, 1153);
	level.iz_route[level.iz_route.size] = (1685, 3774, 1164);
	level.iz_route[level.iz_route.size] = (2134, 4177, 1167);
	level.iz_route[level.iz_route.size] = (2422, 4638, 1162);
	level.iz_route[level.iz_route.size] = (2693, 5188, 1164);
	level.iz_route[level.iz_route.size] = (2958, 5719, 1173);
	level.iz_route[level.iz_route.size] = (3422, 6319, 1200);
	level.iz_route[level.iz_route.size] = (4075, 6675, 1233);
	level.iz_route[level.iz_route.size] = (4728, 6449, 1238);
	level.iz_route[level.iz_route.size] = (5222, 5771, 1217);
	level.iz_route[level.iz_route.size] = (5262, 5054, 1195);
	level.iz_route[level.iz_route.size] = (5355, 4301, 1187);
	level.iz_route[level.iz_route.size] = (5603, 3348, 1171);
	level.iz_route[level.iz_route.size] = (5659, 2442, 1149);
	level.iz_route[level.iz_route.size] = (5793, 1319, 1140);
	level.iz_route[level.iz_route.size] = (5852, 708, 1140);
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
	points[0] = (-3411.0435, 4920.2363, 996.5355);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3549.0825, 4867.1260, 996.7914);
	angles[1] = (0, 0, 0);
	at[1] = 0.3333;
	points[2] = (-3607.0237, 4851.5752, 996.7441);
	angles[2] = (0, 0, 0);
	at[2] = 0.4667;
	points[3] = (-3633.8542, 4848.5435, 996.6260);
	angles[3] = (0, 0, 0);
	at[3] = 0.5333;
	points[4] = (-3694.0198, 4851.8896, 996.0866);
	angles[4] = (0, 0, 0);
	at[4] = 0.6667;
	points[5] = (-3810.4607, 4870.6299, 994.7322);
	angles[5] = (0, 0, 0);
	at[5] = 0.9333;
	points[6] = (-3926.0393, 4897.6377, 993.2402);
	angles[6] = (0, 0, 0);
	at[6] = 1.2000;
	points[7] = (-4011.1812, 4923.9370, 992.0866);
	angles[7] = (0, 0, 0);
	at[7] = 1.4000;
	points[8] = (-4063.3071, 4947.5591, 991.3583);
	angles[8] = (0, 0, 0);
	at[8] = 1.5333;
	points[9] = (-4109.8032, 4984.1733, 990.3622);
	angles[9] = (0, 0, 0);
	at[9] = 1.6667;
	points[10] = (-4152.9136, 5025.1182, 989.2520);
	angles[10] = (0, 0, 0);
	at[10] = 1.8000;
	points[11] = (-4213.8188, 5089.4883, 987.6733);
	angles[11] = (0, 0, 0);
	at[11] = 2;
	points[12] = (-4271.8501, 5157.0869, 986.3661);
	angles[12] = (0, 0, 0);
	at[12] = 2.2000;
	points[13] = (-4341.4175, 5252.0078, 985.8032);
	angles[13] = (0, 0, 0);
	at[13] = 2.4667;
	points[14] = (-4355.9058, 5278.7007, 1163.5118);
	angles[14] = (0, 0, 0);
	at[14] = 2.5333;
	points[15] = (-4355.9058, 5278.7007, 1163.5118);
	angles[15] = (0, 0, 0);
	at[15] = 4.2000;
	points[16] = (-4355.9058, 5278.7007, 1233.9055);
	angles[16] = (0, 0, 0);
	at[16] = 4.2667;
	points[17] = (-4355.9058, 5278.7007, 1291.5432);
	angles[17] = (0, 0, 0);
	at[17] = 4.3333;
	points[18] = (-4355.9058, 5278.7007, 1336.4253);
	angles[18] = (0, 0, 0);
	at[18] = 4.4000;
	points[19] = (-4355.9058, 5278.7007, 1368.5511);
	angles[19] = (0, 0, 0);
	at[19] = 4.4667;
	points[20] = (-4355.9058, 5278.7007, 1387.9213);
	angles[20] = (0, 0, 0);
	at[20] = 4.5333;
	points[21] = (-4355.9058, 5278.7007, 1394.5354);
	angles[21] = (0, 0, 0);
	at[21] = 4.6000;
	points[22] = (-4355.9058, 5278.7007, 1388.3938);
	angles[22] = (0, 0, 0);
	at[22] = 4.6667;
	points[23] = (-4355.9058, 5278.7007, 1369.4960);
	angles[23] = (0, 0, 0);
	at[23] = 4.7333;
	points[24] = (-4355.9058, 5278.7007, 1337.8425);
	angles[24] = (0, 0, 0);
	at[24] = 4.8000;
	points[25] = (-4355.9058, 5278.7007, 1293.4331);
	angles[25] = (0, 0, 0);
	at[25] = 4.8667;
	points[26] = (-4355.9058, 5278.7007, 1236.2677);
	angles[26] = (0, 0, 0);
	at[26] = 4.9333;
	points[27] = (-4355.9058, 5278.7007, 1166.3464);
	angles[27] = (0, 0, 0);
	at[27] = 5;
	points[28] = (-4363.1494, 5298.1494, 987.2362);
	angles[28] = (0, 0, 0);
	at[28] = 5.0667;
	points[29] = (-4382.6377, 5385.0396, 992.9882);
	angles[29] = (0, 0, 0);
	at[29] = 5.2667;
	points[30] = (-4394.8423, 5472.7954, 999.6693);
	angles[30] = (0, 0, 0);
	at[30] = 5.4667;
	points[31] = (-4404.3311, 5590.7085, 1009.0709);
	angles[31] = (0, 0, 0);
	at[31] = 5.7333;
	points[32] = (-4404.9214, 5679.5669, 1016.1851);
	angles[32] = (0, 0, 0);
	at[32] = 5.9333;
	points[33] = (-4402.4805, 5709.2129, 1018.4803);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (-4397.0474, 5735.5513, 1020.4056);
	angles[34] = (0, 0, 0);
	at[34] = 6.0667;
	points[35] = (-4387.1260, 5763.7402, 1022.4370);
	angles[35] = (0, 0, 0);
	at[35] = 6.1333;
	points[36] = (-4362.9922, 5817.6772, 1026.3190);
	angles[36] = (0, 0, 0);
	at[36] = 6.2667;
	points[37] = (-4321.5356, 5896.3784, 1031.9292);
	angles[37] = (0, 0, 0);
	at[37] = 6.4667;
	points[38] = (-4276.3779, 5972.5591, 1037.2480);
	angles[38] = (0, 0, 0);
	at[38] = 6.6667;
	points[39] = (-4226.9292, 6046.6143, 1042.1969);
	angles[39] = (0, 0, 0);
	at[39] = 6.8667;
	points[40] = (-4190.3545, 6093.1104, 1045.0118);
	angles[40] = (0, 0, 0);
	at[40] = 7;
	points[41] = (-4170.4727, 6112.8740, 1045.9528);
	angles[41] = (0, 0, 0);
	at[41] = 7.0667;
	points[42] = (-4121.4175, 6145.7871, 1046.4489);
	angles[42] = (0, 0, 0);
	at[42] = 7.2000;
	points[43] = (-4015.9841, 6200, 1045.7401);
	angles[43] = (0, 0, 0);
	at[43] = 7.4667;
	points[44] = (-3906.8545, 6246.4961, 1044.3425);
	angles[44] = (0, 0, 0);
	at[44] = 7.7333;
	points[45] = (-3822.9409, 6275.7876, 1043.1378);
	angles[45] = (0, 0, 0);
	at[45] = 7.9333;
	points[46] = (-3765.7798, 6288.9370, 1042.4055);
	angles[46] = (0, 0, 0);
	at[46] = 8.0667;
	points[47] = (-3737.1694, 6289.7637, 1042.1378);
	angles[47] = (0, 0, 0);
	at[47] = 8.1333;
	points[48] = (-3648.7205, 6280.5513, 1041.3583);
	angles[48] = (0, 0, 0);
	at[48] = 8.3333;
	points[49] = (-3561.5708, 6264.6851, 1040.5630);
	angles[49] = (0, 0, 0);
	at[49] = 8.5333;
	points[50] = (-3474.8743, 6244.4487, 1039.7086);
	angles[50] = (0, 0, 0);
	at[50] = 8.7333;
	points[51] = (-3389.9963, 6219.4487, 1038.7284);
	angles[51] = (0, 0, 0);
	at[51] = 8.9333;
	points[52] = (-3334.4644, 6197.0083, 1037.8661);
	angles[52] = (0, 0, 0);
	at[52] = 9.0667;
	points[53] = (-3311.4136, 6182.5195, 1037.3347);
	angles[53] = (0, 0, 0);
	at[53] = 9.1333;
	points[54] = (-3265.7402, 6143.9766, 1036.1339);
	angles[54] = (0, 0, 0);
	at[54] = 9.2667;
	points[55] = (-3182.7285, 6059.6455, 1033.5748);
	angles[55] = (0, 0, 0);
	at[55] = 9.5333;
	points[56] = (-3087.2480, 5946.1812, 1029.7166);
	angles[56] = (0, 0, 0);
	at[56] = 9.8667;
	points[57] = (-3037.2444, 5872.3623, 1026.4095);
	angles[57] = (0, 0, 0);
	at[57] = 10.0667;
	points[58] = (-3031.0630, 5860.0396, 1202.8464);
	angles[58] = (0, 0, 0);
	at[58] = 10.1333;
	points[59] = (-3031.0630, 5860.0396, 1202.8464);
	angles[59] = (0, 0, 0);
	at[59] = 11.7333;
	points[60] = (-3031.0630, 5860.0396, 1239.6378);
	angles[60] = (0, 0, 0);
	at[60] = 11.8000;
	points[61] = (-3031.0630, 5860.0396, 1303.6536);
	angles[61] = (0, 0, 0);
	at[61] = 11.8667;
	points[62] = (-3031.0630, 5860.0396, 1354.9133);
	angles[62] = (0, 0, 0);
	at[62] = 11.9333;
	points[63] = (-3031.0630, 5860.0396, 1393.4174);
	angles[63] = (0, 0, 0);
	at[63] = 12;
	points[64] = (-3031.0630, 5860.0396, 1419.1653);
	angles[64] = (0, 0, 0);
	at[64] = 12.0667;
	points[65] = (-3031.0630, 5860.0396, 1432.1575);
	angles[65] = (0, 0, 0);
	at[65] = 12.1333;
	points[66] = (-3031.0630, 5860.0396, 1432.3938);
	angles[66] = (0, 0, 0);
	at[66] = 12.2000;
	points[67] = (-3031.0630, 5860.0396, 1419.8740);
	angles[67] = (0, 0, 0);
	at[67] = 12.2667;
	points[68] = (-3031.0630, 5860.0396, 1394.5984);
	angles[68] = (0, 0, 0);
	at[68] = 12.3333;
	points[69] = (-3031.0630, 5860.0396, 1356.5669);
	angles[69] = (0, 0, 0);
	at[69] = 12.4000;
	points[70] = (-3031.0630, 5860.0396, 1305.7795);
	angles[70] = (0, 0, 0);
	at[70] = 12.4667;
	points[71] = (-3031.0630, 5860.0396, 1242.2362);
	angles[71] = (0, 0, 0);
	at[71] = 12.5333;
	points[72] = (-3028.6143, 5854.2520, 1025.2914);
	angles[72] = (0, 0, 0);
	at[72] = 12.6000;
	points[73] = (-3012.5750, 5797.4014, 1020.5472);
	angles[73] = (0, 0, 0);
	at[73] = 12.7333;
	points[74] = (-2997.5513, 5710.3545, 1012.3937);
	angles[74] = (0, 0, 0);
	at[74] = 12.9333;
	points[75] = (-2987.5708, 5622.2437, 1004.0039);
	angles[75] = (0, 0, 0);
	at[75] = 13.1333;
	points[76] = (-2981.9055, 5534.2129, 995.8976);
	angles[76] = (0, 0, 0);
	at[76] = 13.3333;
	points[77] = (-2981.2991, 5474.7642, 990.8819);
	angles[77] = (0, 0, 0);
	at[77] = 13.4667;
	points[78] = (-2986.3506, 5416.2993, 987.0591);
	angles[78] = (0, 0, 0);
	at[78] = 13.6000;
	points[79] = (-3004.8938, 5361.8501, 986.4488);
	angles[79] = (0, 0, 0);
	at[79] = 13.7333;
	points[80] = (-3043.6064, 5281.6538, 987.7480);
	angles[80] = (0, 0, 0);
	at[80] = 13.9333;
	points[81] = (-3102.4646, 5178.6221, 990.6497);
	angles[81] = (0, 0, 0);
	at[81] = 14.2000;
	points[82] = (-3168.0828, 5080.4727, 993.8622);
	angles[82] = (0, 0, 0);
	at[82] = 14.4667;
	points[83] = (-3206.5669, 5034.4097, 995.2205);
	angles[83] = (0, 0, 0);
	at[83] = 14.6000;
	points[84] = (-3227.3228, 5016.9292, 995.5316);
	angles[84] = (0, 0, 0);
	at[84] = 14.6667;
	points[85] = (-3278.0947, 4985.2363, 995.9410);
	angles[85] = (0, 0, 0);
	at[85] = 14.8000;
	points[86] = (-3411.0435, 4920.2363, 996.5355);
	angles[86] = (0, 0, 0);
	at[86] = 15.1333;
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
	points[0] = (2479.6182, 4276.6143, 1001.0197);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2383.0630, 4332.0078, 997.6496);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (2259.2363, 4412.7954, 993.6418);
	angles[2] = (0, 0, 0);
	at[2] = 0.5833;
	points[3] = (2140.9370, 4501.6929, 990.2874);
	angles[3] = (0, 0, 0);
	at[3] = 0.9167;
	points[4] = (2085.8386, 4552.5591, 989.1693);
	angles[4] = (0, 0, 0);
	at[4] = 1.0833;
	points[5] = (2077.0117, 4562.6377, 1166.2521);
	angles[5] = (0, 0, 0);
	at[5] = 1.1667;
	points[6] = (2077.0117, 4562.6377, 1166.2521);
	angles[6] = (0, 0, 0);
	at[6] = 2.7500;
	points[7] = (2077.0117, 4562.6377, 1220.2402);
	angles[7] = (0, 0, 0);
	at[7] = 2.8333;
	points[8] = (2077.0117, 4562.6377, 1294.2836);
	angles[8] = (0, 0, 0);
	at[8] = 2.9167;
	points[9] = (2077.0117, 4562.6377, 1348.3898);
	angles[9] = (0, 0, 0);
	at[9] = 3;
	points[10] = (2077.0117, 4562.6377, 1382.5708);
	angles[10] = (0, 0, 0);
	at[10] = 3.0833;
	points[11] = (2077.0117, 4562.6377, 1396.8149);
	angles[11] = (0, 0, 0);
	at[11] = 3.1667;
	points[12] = (2077.0117, 4562.6377, 1391.1339);
	angles[12] = (0, 0, 0);
	at[12] = 3.2500;
	points[13] = (2077.0117, 4562.6377, 1365.5157);
	angles[13] = (0, 0, 0);
	at[13] = 3.3333;
	points[14] = (2077.0117, 4562.6377, 1319.9725);
	angles[14] = (0, 0, 0);
	at[14] = 3.4167;
	points[15] = (2077.0117, 4562.6377, 1254.4921);
	angles[15] = (0, 0, 0);
	at[15] = 3.5000;
	points[16] = (2077.0117, 4562.6377, 1169.0865);
	angles[16] = (0, 0, 0);
	at[16] = 3.5833;
	points[17] = (2060.9175, 4585.0786, 989.1457);
	angles[17] = (0, 0, 0);
	at[17] = 3.6667;
	points[18] = (2024.3071, 4650.6299, 990.0709);
	angles[18] = (0, 0, 0);
	at[18] = 3.8333;
	points[19] = (1992.9803, 4717.3228, 991.4055);
	angles[19] = (0, 0, 0);
	at[19] = 4;
	points[20] = (1950.5669, 4819.8818, 993.7677);
	angles[20] = (0, 0, 0);
	at[20] = 4.2500;
	points[21] = (1912.6733, 4924.4883, 996.3898);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (1880.4016, 5030.3545, 999.1614);
	angles[22] = (0, 0, 0);
	at[22] = 4.7500;
	points[23] = (1864.2795, 5103.3862, 1001.1063);
	angles[23] = (0, 0, 0);
	at[23] = 4.9167;
	points[24] = (1861.1221, 5133.4258, 1001.8976);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (1862.3859, 5170.2754, 1002.9095);
	angles[25] = (0, 0, 0);
	at[25] = 5.0833;
	points[26] = (1872.2756, 5242.9922, 1005.0157);
	angles[26] = (0, 0, 0);
	at[26] = 5.2500;
	points[27] = (1886.7166, 5315.5513, 1007.1811);
	angles[27] = (0, 0, 0);
	at[27] = 5.4167;
	points[28] = (1923.2086, 5459.3311, 1011.5315);
	angles[28] = (0, 0, 0);
	at[28] = 5.7500;
	points[29] = (1968.5472, 5600.6299, 1015.7874);
	angles[29] = (0, 0, 0);
	at[29] = 6.0833;
	points[30] = (1996.0354, 5669.1338, 1017.8032);
	angles[30] = (0, 0, 0);
	at[30] = 6.2500;
	points[31] = (2012.7283, 5702.7954, 1018.7520);
	angles[31] = (0, 0, 0);
	at[31] = 6.3333;
	points[32] = (2031.1417, 5730.7085, 1019.4843);
	angles[32] = (0, 0, 0);
	at[32] = 6.4167;
	points[33] = (2107.4883, 5811.8110, 1021.5158);
	angles[33] = (0, 0, 0);
	at[33] = 6.6667;
	points[34] = (2190.8386, 5886.0239, 1023.2875);
	angles[34] = (0, 0, 0);
	at[34] = 6.9167;
	points[35] = (2306.6101, 5978.1499, 1025.2992);
	angles[35] = (0, 0, 0);
	at[35] = 7.2500;
	points[36] = (2397.4763, 6042.3232, 1026.4606);
	angles[36] = (0, 0, 0);
	at[36] = 7.5000;
	points[37] = (2460.5354, 6080.3149, 1026.8781);
	angles[37] = (0, 0, 0);
	at[37] = 7.6667;
	points[38] = (2493.5552, 6095.8267, 1026.8149);
	angles[38] = (0, 0, 0);
	at[38] = 7.7500;
	points[39] = (2563.5708, 6113.5830, 1025.5867);
	angles[39] = (0, 0, 0);
	at[39] = 7.9167;
	points[40] = (2711.0747, 6131.7715, 1021.6812);
	angles[40] = (0, 0, 0);
	at[40] = 8.2500;
	points[41] = (2896.1614, 6140.0396, 1016.2284);
	angles[41] = (0, 0, 0);
	at[41] = 8.6667;
	points[42] = (3044.2205, 6134.3701, 1011.9764);
	angles[42] = (0, 0, 0);
	at[42] = 9;
	points[43] = (3081.3308, 6129.1733, 1011.0433);
	angles[43] = (0, 0, 0);
	at[43] = 9.0833;
	points[44] = (3113.7205, 6120.7480, 1010.3937);
	angles[44] = (0, 0, 0);
	at[44] = 9.1667;
	points[45] = (3148.6497, 6106.6929, 1009.8504);
	angles[45] = (0, 0, 0);
	at[45] = 9.2500;
	points[46] = (3214.5789, 6073.7012, 1009.0040);
	angles[46] = (0, 0, 0);
	at[46] = 9.4167;
	points[47] = (3342.2085, 5997.9136, 1007.6536);
	angles[47] = (0, 0, 0);
	at[47] = 9.7500;
	points[48] = (3464.8623, 5914.3706, 1006.5433);
	angles[48] = (0, 0, 0);
	at[48] = 10.0833;
	points[49] = (3523.8386, 5869.5273, 1006.0591);
	angles[49] = (0, 0, 0);
	at[49] = 10.2500;
	points[50] = (3579.2600, 5821.9292, 1005.6418);
	angles[50] = (0, 0, 0);
	at[50] = 10.4167;
	points[51] = (3605.1458, 5794.8818, 1182.6378);
	angles[51] = (0, 0, 0);
	at[51] = 10.5000;
	points[52] = (3605.1458, 5794.8818, 1182.6378);
	angles[52] = (0, 0, 0);
	at[52] = 12.1667;
	points[53] = (3605.1458, 5794.8818, 1268.6378);
	angles[53] = (0, 0, 0);
	at[53] = 12.2500;
	points[54] = (3605.1458, 5794.8818, 1334.7047);
	angles[54] = (0, 0, 0);
	at[54] = 12.3333;
	points[55] = (3605.1458, 5794.8818, 1380.8386);
	angles[55] = (0, 0, 0);
	at[55] = 12.4167;
	points[56] = (3605.1458, 5794.8818, 1407.0472);
	angles[56] = (0, 0, 0);
	at[56] = 12.5000;
	points[57] = (3605.1458, 5794.8818, 1413.3190);
	angles[57] = (0, 0, 0);
	at[57] = 12.5833;
	points[58] = (3605.1458, 5794.8818, 1399.6653);
	angles[58] = (0, 0, 0);
	at[58] = 12.6667;
	points[59] = (3605.1458, 5794.8818, 1366.0748);
	angles[59] = (0, 0, 0);
	at[59] = 12.7500;
	points[60] = (3605.1458, 5794.8818, 1312.5591);
	angles[60] = (0, 0, 0);
	at[60] = 12.8333;
	points[61] = (3605.1458, 5794.8818, 1239.1102);
	angles[61] = (0, 0, 0);
	at[61] = 12.9167;
	points[62] = (3609.0552, 5790, 1005.4489);
	angles[62] = (0, 0, 0);
	at[62] = 13;
	points[63] = (3647.4175, 5727.8745, 1005.3229);
	angles[63] = (0, 0, 0);
	at[63] = 13.1667;
	points[64] = (3695.3464, 5627.3232, 1005.3307);
	angles[64] = (0, 0, 0);
	at[64] = 13.4167;
	points[65] = (3737.3110, 5524.2915, 1005.4489);
	angles[65] = (0, 0, 0);
	at[65] = 13.6667;
	points[66] = (3774.6968, 5419.4097, 1005.6575);
	angles[66] = (0, 0, 0);
	at[66] = 13.9167;
	points[67] = (3796.6221, 5348.4644, 1005.8583);
	angles[67] = (0, 0, 0);
	at[67] = 14.0833;
	points[68] = (3814.5708, 5276.8901, 1006.1417);
	angles[68] = (0, 0, 0);
	at[68] = 14.2500;
	points[69] = (3820.7874, 5239.7637, 1006.3504);
	angles[69] = (0, 0, 0);
	at[69] = 14.3333;
	points[70] = (3822.1299, 5206.3784, 1006.6142);
	angles[70] = (0, 0, 0);
	at[70] = 14.4167;
	points[71] = (3819.2007, 5168.9766, 1006.9646);
	angles[71] = (0, 0, 0);
	at[71] = 14.5000;
	points[72] = (3792.6418, 5023.1890, 1008.5551);
	angles[72] = (0, 0, 0);
	at[72] = 14.8333;
	points[73] = (3755.0947, 4879.6460, 1010.3740);
	angles[73] = (0, 0, 0);
	at[73] = 15.1667;
	points[74] = (3708.5867, 4739.0161, 1012.4921);
	angles[74] = (0, 0, 0);
	at[74] = 15.5000;
	points[75] = (3679.7639, 4671.0630, 1013.7953);
	angles[75] = (0, 0, 0);
	at[75] = 15.6667;
	points[76] = (3662.2046, 4639.4883, 1014.6024);
	angles[76] = (0, 0, 0);
	at[76] = 15.7500;
	points[77] = (3615.7522, 4583.9370, 1017.0906);
	angles[77] = (0, 0, 0);
	at[77] = 15.9167;
	points[78] = (3507.1023, 4482.6377, 1023.1969);
	angles[78] = (0, 0, 0);
	at[78] = 16.2500;
	points[79] = (3392.0986, 4389.6460, 1029.2284);
	angles[79] = (0, 0, 0);
	at[79] = 16.5833;
	points[80] = (3271.4607, 4304.6064, 1034.3503);
	angles[80] = (0, 0, 0);
	at[80] = 16.9167;
	points[81] = (3205.9805, 4267.3623, 1035.8386);
	angles[81] = (0, 0, 0);
	at[81] = 17.0833;
	points[82] = (3174.7993, 4255.2754, 1035.6102);
	angles[82] = (0, 0, 0);
	at[82] = 17.1667;
	points[83] = (3138.2837, 4246.2202, 1034.4922);
	angles[83] = (0, 0, 0);
	at[83] = 17.2500;
	points[84] = (3065.5632, 4234.2129, 1031.3188);
	angles[84] = (0, 0, 0);
	at[84] = 17.4167;
	points[85] = (2991.8584, 4226.1025, 1027.5591);
	angles[85] = (0, 0, 0);
	at[85] = 17.5833;
	points[86] = (2843.9292, 4217.2441, 1019.3347);
	angles[86] = (0, 0, 0);
	at[86] = 17.9167;
	points[87] = (2733.1338, 4216.4961, 1012.9803);
	angles[87] = (0, 0, 0);
	at[87] = 18.1667;
	points[88] = (2623.1733, 4223.6616, 1006.9016);
	angles[88] = (0, 0, 0);
	at[88] = 18.4167;
	points[89] = (2586.4055, 4230.3540, 1005.1221);
	angles[89] = (0, 0, 0);
	at[89] = 18.5000;
	points[90] = (2553.1733, 4241.5747, 1003.7717);
	angles[90] = (0, 0, 0);
	at[90] = 18.5833;
	points[91] = (2479.6182, 4276.6143, 1001.0197);
	angles[91] = (0, 0, 0);
	at[91] = 18.7667;
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
