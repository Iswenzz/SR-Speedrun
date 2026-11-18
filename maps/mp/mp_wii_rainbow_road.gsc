main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_rainbow_road", 0);

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
	ambientPlay("iz_0_n_rainbow32", 2);
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
	level.iz_route[level.iz_route.size] = (7961, -10423, 15933);
	level.iz_route[level.iz_route.size] = (6765, -10427, 15956);
	level.iz_route[level.iz_route.size] = (5478, -10423, 15936);
	level.iz_route[level.iz_route.size] = (4333, -10424, 15477);
	level.iz_route[level.iz_route.size] = (3518, -10424, 14215);
	level.iz_route[level.iz_route.size] = (2905, -10415, 12659);
	level.iz_route[level.iz_route.size] = (2209, -10411, 10920);
	level.iz_route[level.iz_route.size] = (1403, -10408, 9363);
	level.iz_route[level.iz_route.size] = (709, -10408, 9004);
	level.iz_route[level.iz_route.size] = (44, -10423, 9208);
	level.iz_route[level.iz_route.size] = (-322, -10423, 9467);
	level.iz_route[level.iz_route.size] = (-788, -10423, 9458);
	level.iz_route[level.iz_route.size] = (-1565, -10453, 9006);
	level.iz_route[level.iz_route.size] = (-2067, -10468, 9031);
	level.iz_route[level.iz_route.size] = (-3396, -10600, 9051);
	level.iz_route[level.iz_route.size] = (-4193, -11161, 8963);
	level.iz_route[level.iz_route.size] = (-4400, -12047, 8512);
	level.iz_route[level.iz_route.size] = (-3971, -13509, 7465);
	level.iz_route[level.iz_route.size] = (-3529, -14764, 6859);
	level.iz_route[level.iz_route.size] = (-2997, -15325, 6764);
	level.iz_route[level.iz_route.size] = (-2141, -15325, 6636);
	level.iz_route[level.iz_route.size] = (-1491, -14719, 6288);
	level.iz_route[level.iz_route.size] = (-1270, -13686, 5772);
	level.iz_route[level.iz_route.size] = (-1240, -12283, 5279);
	level.iz_route[level.iz_route.size] = (-1240, -11471, 5610);
	level.iz_route[level.iz_route.size] = (-1240, -9715, 5610);
	level.iz_route[level.iz_route.size] = (-1240, -7462, 5610);
	level.iz_route[level.iz_route.size] = (-1240, -6880, 5699);
	level.iz_route[level.iz_route.size] = (-1240, -6319, 5463);
	level.iz_route[level.iz_route.size] = (-1240, -5709, 4480);
	level.iz_route[level.iz_route.size] = (-1240, -4665, 4421);
	level.iz_route[level.iz_route.size] = (-1260, -3700, 4356);
	level.iz_route[level.iz_route.size] = (-650, -3100, 4353);
	level.iz_route[level.iz_route.size] = (-133, -2584, 4411);
	level.iz_route[level.iz_route.size] = (-44, -1816, 4391);
	level.iz_route[level.iz_route.size] = (-207, -1181, 4430);
	level.iz_route[level.iz_route.size] = (-472, -871, 4405);
	level.iz_route[level.iz_route.size] = (-753, -679, 4378);
	level.iz_route[level.iz_route.size] = (-1668, -325, 4371);
	level.iz_route[level.iz_route.size] = (-2037, -89, 4425);
	level.iz_route[level.iz_route.size] = (-2303, 251, 4439);
	level.iz_route[level.iz_route.size] = (-2466, 782, 4399);
	level.iz_route[level.iz_route.size] = (-2406, 1447, 4405);
	level.iz_route[level.iz_route.size] = (-2096, 2067, 4378);
	level.iz_route[level.iz_route.size] = (-1609, 2480, 4209);
	level.iz_route[level.iz_route.size] = (-1284, 2805, 4158);
	level.iz_route[level.iz_route.size] = (-827, 3174, 4165);
	level.iz_route[level.iz_route.size] = (-266, 3912, 4319);
	level.iz_route[level.iz_route.size] = (0, 4547, 4479);
	level.iz_route[level.iz_route.size] = (-177, 5167, 4327);
	level.iz_route[level.iz_route.size] = (-797, 5699, 3992);
	level.iz_route[level.iz_route.size] = (-1565, 6216, 3796);
	level.iz_route[level.iz_route.size] = (-2037, 6673, 3930);
	level.iz_route[level.iz_route.size] = (-2156, 7057, 4044);
	level.iz_route[level.iz_route.size] = (-2037, 7648, 4072);
	level.iz_route[level.iz_route.size] = (-1757, 7972, 3950);
	level.iz_route[level.iz_route.size] = (-945, 8282, 3683);
	level.iz_route[level.iz_route.size] = (-44, 8091, 3749);
	level.iz_route[level.iz_route.size] = (871, 7219, 4162);
	level.iz_route[level.iz_route.size] = (1137, 6038, 4771);
	level.iz_route[level.iz_route.size] = (1284, 4680, 5542);
	level.iz_route[level.iz_route.size] = (1816, 1093, 9386);
	level.iz_route[level.iz_route.size] = (2274, -2052, 12952);
	level.iz_route[level.iz_route.size] = (2820, -5832, 17386);
	level.iz_route[level.iz_route.size] = (3041, -7559, 18514);
	level.iz_route[level.iz_route.size] = (3112, -8469, 18420);
	level.iz_route[level.iz_route.size] = (3189, -9449, 18086);
	level.iz_route[level.iz_route.size] = (2731, -10408, 17795);
	level.iz_route[level.iz_route.size] = (1905, -11058, 17368);
	level.iz_route[level.iz_route.size] = (1093, -11737, 17149);
	level.iz_route[level.iz_route.size] = (620, -12313, 17284);
	level.iz_route[level.iz_route.size] = (399, -12726, 17789);
	level.iz_route[level.iz_route.size] = (672, -13287, 18657);
	level.iz_route[level.iz_route.size] = (1065, -14218, 18657);
	level.iz_route[level.iz_route.size] = (1329, -14911, 17581);
	level.iz_route[level.iz_route.size] = (2156, -14882, 16958);
	level.iz_route[level.iz_route.size] = (3145, -14808, 16562);
	level.iz_route[level.iz_route.size] = (3647, -14380, 16362);
	level.iz_route[level.iz_route.size] = (4429, -14085, 16020);
	level.iz_route[level.iz_route.size] = (5271, -14218, 15606);
	level.iz_route[level.iz_route.size] = (6186, -14749, 15143);
	level.iz_route[level.iz_route.size] = (6747, -15236, 15060);
	level.iz_route[level.iz_route.size] = (7367, -15236, 14942);
	level.iz_route[level.iz_route.size] = (8474, -14469, 14765);
	level.iz_route[level.iz_route.size] = (9508, -13996, 14714);
	level.iz_route[level.iz_route.size] = (10597, -13523, 15093);
	level.iz_route[level.iz_route.size] = (11073, -13317, 15531);
	level.iz_route[level.iz_route.size] = (11959, -12608, 15224);
	level.iz_route[level.iz_route.size] = (13125, -12387, 15398);
	level.iz_route[level.iz_route.size] = (14528, -12077, 15653);
	level.iz_route[level.iz_route.size] = (15399, -11250, 15973);
	level.iz_route[level.iz_route.size] = (15413, -9892, 16156);
	level.iz_route[level.iz_route.size] = (14350, -9065, 16335);
	level.iz_route[level.iz_route.size] = (12889, -9331, 16212);
	level.iz_route[level.iz_route.size] = (11944, -10143, 16058);
	level.iz_route[level.iz_route.size] = (10984, -10423, 15978);
	level.iz_route[level.iz_route.size] = (9729, -10423, 15933);
}
