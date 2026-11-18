main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_royal_raceway", 0);

	setExpFog(13287.4014, 27282.2344, 1, 0.8353, 0.9569, 0);

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

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_urrr", 2);
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
	level.iz_route[level.iz_route.size] = (-5295, -131, 1105);
	level.iz_route[level.iz_route.size] = (-5299, -1046, 1105);
	level.iz_route[level.iz_route.size] = (-5295, -2080, 1105);
	level.iz_route[level.iz_route.size] = (-5286, -3449, 1105);
	level.iz_route[level.iz_route.size] = (-5186, -5628, 1132);
	level.iz_route[level.iz_route.size] = (-5085, -6021, 1169);
	level.iz_route[level.iz_route.size] = (-4836, -6346, 1207);
	level.iz_route[level.iz_route.size] = (-4323, -6854, 1258);
	level.iz_route[level.iz_route.size] = (-3727, -7286, 1286);
	level.iz_route[level.iz_route.size] = (-3031, -7764, 1314);
	level.iz_route[level.iz_route.size] = (-2453, -8098, 1334);
	level.iz_route[level.iz_route.size] = (-2147, -8270, 1348);
	level.iz_route[level.iz_route.size] = (-1738, -8336, 1353);
	level.iz_route[level.iz_route.size] = (-1256, -8309, 1365);
	level.iz_route[level.iz_route.size] = (-698, -8164, 1397);
	level.iz_route[level.iz_route.size] = (-223, -7875, 1430);
	level.iz_route[level.iz_route.size] = (46, -7363, 1427);
	level.iz_route[level.iz_route.size] = (144, -6666, 1399);
	level.iz_route[level.iz_route.size] = (28, -5978, 1350);
	level.iz_route[level.iz_route.size] = (-192, -5435, 1299);
	level.iz_route[level.iz_route.size] = (-391, -4863, 1252);
	level.iz_route[level.iz_route.size] = (-463, -4334, 1223);
	level.iz_route[level.iz_route.size] = (-380, -3924, 1214);
	level.iz_route[level.iz_route.size] = (-174, -3614, 1215);
	level.iz_route[level.iz_route.size] = (220, -3469, 1234);
	level.iz_route[level.iz_route.size] = (843, -3434, 1254);
	level.iz_route[level.iz_route.size] = (1341, -3616, 1266);
	level.iz_route[level.iz_route.size] = (1742, -3874, 1274);
	level.iz_route[level.iz_route.size] = (2173, -4325, 1283);
	level.iz_route[level.iz_route.size] = (2831, -5168, 1298);
	level.iz_route[level.iz_route.size] = (3160, -5836, 1313);
	level.iz_route[level.iz_route.size] = (3284, -6655, 1349);
	level.iz_route[level.iz_route.size] = (3213, -7319, 1383);
	level.iz_route[level.iz_route.size] = (3011, -7987, 1416);
	level.iz_route[level.iz_route.size] = (2510, -8502, 1436);
	level.iz_route[level.iz_route.size] = (1715, -9047, 1452);
	level.iz_route[level.iz_route.size] = (477, -9751, 1463);
	level.iz_route[level.iz_route.size] = (-662, -10357, 1480);
	level.iz_route[level.iz_route.size] = (-1436, -10561, 1483);
	level.iz_route[level.iz_route.size] = (-2078, -10569, 1479);
	level.iz_route[level.iz_route.size] = (-2755, -10396, 1456);
	level.iz_route[level.iz_route.size] = (-3567, -9961, 1405);
	level.iz_route[level.iz_route.size] = (-4367, -9467, 1350);
	level.iz_route[level.iz_route.size] = (-4798, -9120, 1318);
	level.iz_route[level.iz_route.size] = (-5447, -8936, 1305);
	level.iz_route[level.iz_route.size] = (-6241, -8955, 1302);
	level.iz_route[level.iz_route.size] = (-7164, -9245, 1274);
	level.iz_route[level.iz_route.size] = (-7994, -9619, 1237);
	level.iz_route[level.iz_route.size] = (-8798, -9908, 1204);
	level.iz_route[level.iz_route.size] = (-9695, -10165, 1174);
	level.iz_route[level.iz_route.size] = (-10582, -10331, 1165);
	level.iz_route[level.iz_route.size] = (-11255, -10194, 1176);
	level.iz_route[level.iz_route.size] = (-11773, -9747, 1186);
	level.iz_route[level.iz_route.size] = (-12066, -9204, 1194);
	level.iz_route[level.iz_route.size] = (-12121, -8600, 1204);
	level.iz_route[level.iz_route.size] = (-12013, -7991, 1224);
	level.iz_route[level.iz_route.size] = (-11529, -7527, 1249);
	level.iz_route[level.iz_route.size] = (-10827, -7087, 1313);
	level.iz_route[level.iz_route.size] = (-9902, -6641, 1412);
	level.iz_route[level.iz_route.size] = (-8825, -6140, 1543);
	level.iz_route[level.iz_route.size] = (-6852, -5265, 1807);
	level.iz_route[level.iz_route.size] = (-4902, -4409, 2066);
	level.iz_route[level.iz_route.size] = (-3255, -3689, 2343);
	level.iz_route[level.iz_route.size] = (3851, -284, 1105);
	level.iz_route[level.iz_route.size] = (5324, 340, 1109);
	level.iz_route[level.iz_route.size] = (6527, 947, 1126);
	level.iz_route[level.iz_route.size] = (7291, 1403, 1160);
	level.iz_route[level.iz_route.size] = (7858, 1973, 1184);
	level.iz_route[level.iz_route.size] = (7980, 2619, 1176);
	level.iz_route[level.iz_route.size] = (7810, 3233, 1170);
	level.iz_route[level.iz_route.size] = (7285, 3761, 1154);
	level.iz_route[level.iz_route.size] = (6492, 4324, 1156);
	level.iz_route[level.iz_route.size] = (5547, 4868, 1165);
	level.iz_route[level.iz_route.size] = (4771, 5462, 1182);
	level.iz_route[level.iz_route.size] = (4193, 6103, 1194);
	level.iz_route[level.iz_route.size] = (3634, 6662, 1205);
	level.iz_route[level.iz_route.size] = (3122, 6902, 1214);
	level.iz_route[level.iz_route.size] = (2509, 6889, 1200);
	level.iz_route[level.iz_route.size] = (1864, 6566, 1159);
	level.iz_route[level.iz_route.size] = (1376, 6185, 1128);
	level.iz_route[level.iz_route.size] = (793, 5766, 1102);
	level.iz_route[level.iz_route.size] = (252, 5486, 1083);
	level.iz_route[level.iz_route.size] = (-476, 5390, 1094);
	level.iz_route[level.iz_route.size] = (-1203, 5544, 1103);
	level.iz_route[level.iz_route.size] = (-1971, 5711, 1105);
	level.iz_route[level.iz_route.size] = (-2673, 5856, 1113);
	level.iz_route[level.iz_route.size] = (-3484, 5952, 1140);
	level.iz_route[level.iz_route.size] = (-3997, 5876, 1158);
	level.iz_route[level.iz_route.size] = (-4519, 5646, 1178);
	level.iz_route[level.iz_route.size] = (-4845, 5302, 1178);
	level.iz_route[level.iz_route.size] = (-5095, 4769, 1159);
	level.iz_route[level.iz_route.size] = (-5256, 4143, 1136);
	level.iz_route[level.iz_route.size] = (-5352, 3294, 1115);
	level.iz_route[level.iz_route.size] = (-5333, 1609, 1106);
}
