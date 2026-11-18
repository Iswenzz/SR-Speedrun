main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_bowsers_castle", 0);

	setExpFog(5905.5117, 64960.6250, 1, 0.4314, 0, 0);

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
	ambientPlay("iz_0_70", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
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
	level.iz_route[level.iz_route.size] = (-1772, 7662, 3946);
	level.iz_route[level.iz_route.size] = (-1762, 5848, 3946);
	level.iz_route[level.iz_route.size] = (-1751, 5095, 3840);
	level.iz_route[level.iz_route.size] = (-1728, 3662, 3502);
	level.iz_route[level.iz_route.size] = (-1694, 1331, 3291);
	level.iz_route[level.iz_route.size] = (-1677, -491, 3289);
	level.iz_route[level.iz_route.size] = (-1696, -1510, 3289);
	level.iz_route[level.iz_route.size] = (-1691, -2261, 3289);
	level.iz_route[level.iz_route.size] = (-1720, -3032, 3364);
	level.iz_route[level.iz_route.size] = (-1733, -3902, 3376);
	level.iz_route[level.iz_route.size] = (-1656, -4250, 3376);
	level.iz_route[level.iz_route.size] = (-1393, -4601, 3376);
	level.iz_route[level.iz_route.size] = (-1244, -4882, 3376);
	level.iz_route[level.iz_route.size] = (-1144, -5323, 3376);
	level.iz_route[level.iz_route.size] = (-1113, -6395, 3376);
	level.iz_route[level.iz_route.size] = (-1075, -8160, 3376);
	level.iz_route[level.iz_route.size] = (-1063, -8913, 3376);
	level.iz_route[level.iz_route.size] = (-1228, -9284, 3376);
	level.iz_route[level.iz_route.size] = (-1509, -9570, 3376);
	level.iz_route[level.iz_route.size] = (-1710, -9973, 3376);
	level.iz_route[level.iz_route.size] = (-1722, -10729, 3376);
	level.iz_route[level.iz_route.size] = (-1686, -11550, 3376);
	level.iz_route[level.iz_route.size] = (-1615, -11937, 3376);
	level.iz_route[level.iz_route.size] = (-1380, -12291, 3376);
	level.iz_route[level.iz_route.size] = (-954, -12508, 3376);
	level.iz_route[level.iz_route.size] = (460, -12560, 3376);
	level.iz_route[level.iz_route.size] = (2995, -12585, 3376);
	level.iz_route[level.iz_route.size] = (4356, -12589, 3376);
	level.iz_route[level.iz_route.size] = (4806, -12572, 3376);
	level.iz_route[level.iz_route.size] = (5136, -12490, 3376);
	level.iz_route[level.iz_route.size] = (5418, -12304, 3376);
	level.iz_route[level.iz_route.size] = (5596, -12076, 3376);
	level.iz_route[level.iz_route.size] = (5691, -11820, 3376);
	level.iz_route[level.iz_route.size] = (5723, -11395, 3375);
	level.iz_route[level.iz_route.size] = (5716, -10658, 3253);
	level.iz_route[level.iz_route.size] = (5705, -9779, 3099);
	level.iz_route[level.iz_route.size] = (6357, -9110, 2973);
	level.iz_route[level.iz_route.size] = (6586, -8616, 2879);
	level.iz_route[level.iz_route.size] = (6625, -7211, 2850);
	level.iz_route[level.iz_route.size] = (6253, -6655, 2850);
	level.iz_route[level.iz_route.size] = (5727, -6009, 2850);
	level.iz_route[level.iz_route.size] = (5747, -5412, 2859);
	level.iz_route[level.iz_route.size] = (5752, -4745, 2947);
	level.iz_route[level.iz_route.size] = (5740, -4392, 3030);
	level.iz_route[level.iz_route.size] = (5758, -3266, 3038);
	level.iz_route[level.iz_route.size] = (5721, -1897, 3102);
	level.iz_route[level.iz_route.size] = (5624, -1052, 3169);
	level.iz_route[level.iz_route.size] = (5444, -598, 3233);
	level.iz_route[level.iz_route.size] = (5016, -192, 3313);
	level.iz_route[level.iz_route.size] = (4519, -83, 3372);
	level.iz_route[level.iz_route.size] = (4068, -80, 3431);
	level.iz_route[level.iz_route.size] = (3529, -380, 3498);
	level.iz_route[level.iz_route.size] = (3059, -887, 3588);
	level.iz_route[level.iz_route.size] = (2907, -1487, 3665);
	level.iz_route[level.iz_route.size] = (3127, -2172, 3747);
	level.iz_route[level.iz_route.size] = (3659, -2730, 3845);
	level.iz_route[level.iz_route.size] = (4450, -2862, 3932);
	level.iz_route[level.iz_route.size] = (5245, -2542, 4028);
	level.iz_route[level.iz_route.size] = (5711, -1961, 4101);
	level.iz_route[level.iz_route.size] = (5820, -1198, 4194);
	level.iz_route[level.iz_route.size] = (5802, -77, 4339);
	level.iz_route[level.iz_route.size] = (5776, 1000, 4385);
	level.iz_route[level.iz_route.size] = (5715, 1936, 4385);
	level.iz_route[level.iz_route.size] = (6197, 2386, 4385);
	level.iz_route[level.iz_route.size] = (6720, 2958, 4385);
	level.iz_route[level.iz_route.size] = (6962, 3542, 4385);
	level.iz_route[level.iz_route.size] = (6922, 4153, 4385);
	level.iz_route[level.iz_route.size] = (6601, 4884, 4385);
	level.iz_route[level.iz_route.size] = (6195, 5550, 4385);
	level.iz_route[level.iz_route.size] = (5735, 6140, 4385);
	level.iz_route[level.iz_route.size] = (5715, 6775, 4385);
	level.iz_route[level.iz_route.size] = (5717, 7250, 4385);
	level.iz_route[level.iz_route.size] = (5611, 7455, 4385);
	level.iz_route[level.iz_route.size] = (5418, 7627, 4385);
	level.iz_route[level.iz_route.size] = (5006, 7689, 4385);
	level.iz_route[level.iz_route.size] = (4569, 7691, 4385);
	level.iz_route[level.iz_route.size] = (2496, 7691, 4385);
	level.iz_route[level.iz_route.size] = (2060, 7690, 4385);
	level.iz_route[level.iz_route.size] = (1837, 7615, 4385);
	level.iz_route[level.iz_route.size] = (1654, 7480, 4385);
	level.iz_route[level.iz_route.size] = (1519, 7279, 4385);
	level.iz_route[level.iz_route.size] = (1373, 6920, 4447);
	level.iz_route[level.iz_route.size] = (1262, 6277, 4641);
	level.iz_route[level.iz_route.size] = (1276, 5778, 4788);
	level.iz_route[level.iz_route.size] = (1337, 5546, 4823);
	level.iz_route[level.iz_route.size] = (1542, 5303, 4823);
	level.iz_route[level.iz_route.size] = (1846, 5006, 4823);
	level.iz_route[level.iz_route.size] = (2057, 4616, 4823);
	level.iz_route[level.iz_route.size] = (2161, 4293, 4839);
	level.iz_route[level.iz_route.size] = (2175, 3774, 4981);
	level.iz_route[level.iz_route.size] = (2157, 2886, 5230);
	level.iz_route[level.iz_route.size] = (2203, 2342, 5262);
	level.iz_route[level.iz_route.size] = (2341, 2150, 5262);
	level.iz_route[level.iz_route.size] = (2655, 2012, 5262);
	level.iz_route[level.iz_route.size] = (3122, 1979, 5262);
	level.iz_route[level.iz_route.size] = (3546, 2136, 5262);
	level.iz_route[level.iz_route.size] = (3770, 2509, 5262);
	level.iz_route[level.iz_route.size] = (3911, 3130, 5303);
	level.iz_route[level.iz_route.size] = (3905, 4174, 5566);
	level.iz_route[level.iz_route.size] = (3888, 5042, 5700);
	level.iz_route[level.iz_route.size] = (3905, 6513, 5700);
	level.iz_route[level.iz_route.size] = (3861, 7132, 5700);
	level.iz_route[level.iz_route.size] = (3784, 7487, 5700);
	level.iz_route[level.iz_route.size] = (3620, 7731, 5700);
	level.iz_route[level.iz_route.size] = (3432, 7932, 5700);
	level.iz_route[level.iz_route.size] = (3130, 8123, 5700);
	level.iz_route[level.iz_route.size] = (2595, 8264, 5700);
	level.iz_route[level.iz_route.size] = (1725, 8309, 5700);
	level.iz_route[level.iz_route.size] = (1128, 8371, 5700);
	level.iz_route[level.iz_route.size] = (852, 8620, 5700);
	level.iz_route[level.iz_route.size] = (799, 9112, 5700);
	level.iz_route[level.iz_route.size] = (823, 9573, 5700);
	level.iz_route[level.iz_route.size] = (1011, 9937, 5700);
	level.iz_route[level.iz_route.size] = (1404, 10151, 5700);
	level.iz_route[level.iz_route.size] = (1945, 10223, 5553);
	level.iz_route[level.iz_route.size] = (3949, 10202, 4952);
	level.iz_route[level.iz_route.size] = (5889, 10235, 4359);
	level.iz_route[level.iz_route.size] = (6350, 10249, 4297);
	level.iz_route[level.iz_route.size] = (6798, 10310, 4297);
	level.iz_route[level.iz_route.size] = (7240, 10544, 4297);
	level.iz_route[level.iz_route.size] = (7872, 10633, 4297);
	level.iz_route[level.iz_route.size] = (8853, 10654, 4297);
	level.iz_route[level.iz_route.size] = (11425, 10682, 4297);
	level.iz_route[level.iz_route.size] = (12025, 10683, 4297);
	level.iz_route[level.iz_route.size] = (12398, 10565, 4297);
	level.iz_route[level.iz_route.size] = (12601, 10286, 4297);
	level.iz_route[level.iz_route.size] = (12686, 9947, 4297);
	level.iz_route[level.iz_route.size] = (12801, 9240, 4276);
	level.iz_route[level.iz_route.size] = (12879, 8255, 4254);
	level.iz_route[level.iz_route.size] = (13206, 7868, 4218);
	level.iz_route[level.iz_route.size] = (13748, 7646, 4172);
	level.iz_route[level.iz_route.size] = (14321, 7655, 4132);
	level.iz_route[level.iz_route.size] = (14834, 8050, 4048);
	level.iz_route[level.iz_route.size] = (15036, 8648, 3982);
	level.iz_route[level.iz_route.size] = (15085, 9406, 3956);
	level.iz_route[level.iz_route.size] = (15015, 11211, 3946);
	level.iz_route[level.iz_route.size] = (14947, 11718, 3946);
	level.iz_route[level.iz_route.size] = (14528, 12075, 3946);
	level.iz_route[level.iz_route.size] = (12983, 12172, 4126);
	level.iz_route[level.iz_route.size] = (11976, 12186, 4253);
	level.iz_route[level.iz_route.size] = (9171, 12160, 4253);
	level.iz_route[level.iz_route.size] = (7003, 12108, 4253);
	level.iz_route[level.iz_route.size] = (5812, 12097, 4287);
	level.iz_route[level.iz_route.size] = (5031, 12129, 4403);
	level.iz_route[level.iz_route.size] = (4223, 12135, 4627);
	level.iz_route[level.iz_route.size] = (1372, 12147, 4044);
	level.iz_route[level.iz_route.size] = (-208, 12119, 3948);
	level.iz_route[level.iz_route.size] = (-976, 11979, 3946);
	level.iz_route[level.iz_route.size] = (-1487, 11708, 3946);
	level.iz_route[level.iz_route.size] = (-1765, 11030, 3946);
	level.iz_route[level.iz_route.size] = (-1792, 10071, 3946);
	level.iz_route[level.iz_route.size] = (-1782, 8687, 3946);
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
	thread iz_obj_11();
	thread iz_obj_12();
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
	thread iz_obj_20();
	thread iz_obj_21();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (16924.6855, 12119.3311, 4429.1338);
	angles[0] = (0, 89.9986, -65.9899);
	at[0] = 0;
	points[1] = (16924.6855, 12119.3311, 4429.1338);
	angles[1] = (0, 89.9986, -65.9899);
	at[1] = 0.1500;
	points[2] = (16635.6309, 12170.5908, 4399.0156);
	angles[2] = (0, 89.9985, -28.9974);
	at[2] = 0.2000;
	points[3] = (16281.2998, 12170.5908, 4363.5825);
	angles[3] = (0, 89.9985, -19.9973);
	at[3] = 0.2500;
	points[4] = (15926.9688, 12170.5908, 4322.8350);
	angles[4] = (0, 89.9985, -10.9972);
	at[4] = 0.3000;
	points[5] = (15572.6387, 12170.5908, 4276.7715);
	angles[5] = (0, 89.9987, -1.9971);
	at[5] = 0.3500;
	points[6] = (15218.3076, 12170.5908, 4241.6143);
	angles[6] = (0, 89.9986, 14.0030);
	at[6] = 0.4000;
	points[7] = (14863.9775, 12170.6299, 4259.3306);
	angles[7] = (0, 89.9987, 44.0032);
	at[7] = 0.4500;
	points[8] = (14509.6465, 12170.6299, 4271.7324);
	angles[8] = (0, 89.9986, 74.0033);
	at[8] = 0.5000;
	points[9] = (14155.3154, 12170.6299, 4278.8188);
	angles[9] = (0, 89.9986, 104.0035);
	at[9] = 0.5500;
	points[10] = (13800.9854, 12170.6299, 4294.6851);
	angles[10] = (0, 89.9986, 134.0037);
	at[10] = 0.6000;
	points[11] = (13446.6543, 12170.6699, 4349.3306);
	angles[11] = (0, 89.9986, 164.0038);
	at[11] = 0.6500;
	points[12] = (13249.8037, 12170.6699, 4379.6455);
	angles[12] = (0, 89.9985, 194.0040);
	at[12] = 0.7000;
	points[13] = (12777.3633, 12170.6699, 4452.4805);
	angles[13] = (0, 89.9985, 314.0046);
	at[13] = 0.9000;
	points[14] = (12304.9219, 12170.6699, 4525.3149);
	angles[14] = (0, 89.9986, 434.0052);
	at[14] = 1.1000;
	points[15] = (12068.7012, 12170.6699, 4547.6377);
	angles[15] = (0, 89.9987, 494.0056);
	at[15] = 1.2000;
	points[16] = (11832.4814, 12170.6699, 4548.5435);
	angles[16] = (0, 89.9986, 554.0059);
	at[16] = 1.3000;
	points[17] = (11360.0400, 12170.6699, 4548.5435);
	angles[17] = (0, 89.9986, 674.0065);
	at[17] = 1.5000;
	points[18] = (10887.5986, 12170.6699, 4548.5435);
	angles[18] = (0, 89.9985, 794.0071);
	at[18] = 1.7000;
	points[19] = (10415.1582, 12170.6699, 4548.5435);
	angles[19] = (0, 89.9987, 914.0078);
	at[19] = 1.9000;
	points[20] = (9942.7168, 12170.6699, 4548.5435);
	angles[20] = (0, 89.9985, 1034.0084);
	at[20] = 2.1000;
	points[21] = (9470.2754, 12170.6699, 4548.5435);
	angles[21] = (0, 89.9986, 1154.0090);
	at[21] = 2.3000;
	points[22] = (8997.8350, 12170.6699, 4548.5435);
	angles[22] = (0, 89.9986, 1274.0096);
	at[22] = 2.5000;
	points[23] = (8643.5039, 12170.6699, 4548.5435);
	angles[23] = (0, 89.9986, 1364.0100);
	at[23] = 2.6500;
	points[24] = (8643.5039, 12170.6699, 4548.5435);
	angles[24] = (0, 89.9986, 1364.0100);
	at[24] = 2.6667;
	points[25] = (16924.6855, 12119.3311, 4429.1338);
	angles[25] = (0, 89.9986, 1374.0101);
	at[25] = 2.6667;
	points[26] = (16924.6855, 12119.3311, 4429.1338);
	angles[26] = (0, 89.9986, 1374.0101);
	at[26] = 3.5333;
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
	points[0] = (-1092.4528, -6212.8745, 3543.3071);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1092.4528, -6212.8745, 3543.3071);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-1092.4528, -6212.8745, 3550.9805);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-1092.4528, -6212.8745, 3547.7363);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (-1092.4528, -6212.8745, 3535.6338);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (-1092.4528, -6212.8745, 3538.8779);
	angles[5] = (0, 0, 0);
	at[5] = 0.6500;
	points[6] = (-1092.4528, -6212.8745, 3550.9805);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (-1092.4528, -6212.8745, 3547.7363);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (-1092.4528, -6212.8745, 3535.6338);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (-1092.4528, -6212.8745, 3538.8779);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (-1092.4528, -6212.8745, 3550.9805);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (-1092.4528, -6212.8745, 3547.7363);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (-1092.4528, -6212.8745, 3553.6416);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (-1092.4528, -6212.8745, 3686.5156);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (-1092.4528, -6212.8745, 3656.3977);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (-1092.4528, -6212.8745, 3581.1023);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (-1092.4528, -6212.8745, 3460.6301);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (-1092.4528, -6212.8745, 3376.3149);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (-1092.4528, -6212.8745, 3376.3149);
	angles[18] = (0, 0, 0);
	at[18] = 2.3000;
	points[19] = (-1092.4528, -6212.8745, 3379.2676);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (-1092.4528, -6212.8745, 3538.7166);
	angles[20] = (0, 0, 0);
	at[20] = 3.2500;
	points[21] = (-1092.4528, -6212.8745, 3543.3071);
	angles[21] = (0, 0, 0);
	at[21] = 3.3000;
	points[22] = (-1092.4528, -6212.8745, 3543.3071);
	angles[22] = (0, 0, 0);
	at[22] = 3.8000;
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
	points[0] = (-1092.4528, -7866.1421, 3550.9805);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1092.4528, -7866.1421, 3547.7363);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-1092.4528, -7866.1421, 3535.6338);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-1092.4528, -7866.1421, 3538.8779);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-1092.4528, -7866.1421, 3550.9805);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-1092.4528, -7866.1421, 3547.7363);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-1092.4528, -7866.1421, 3535.6338);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-1092.4528, -7866.1421, 3538.8779);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-1092.4528, -7866.1421, 3550.9805);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-1092.4528, -7866.1421, 3547.7363);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-1092.4528, -7866.1421, 3553.6416);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-1092.4528, -7866.1421, 3686.5156);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (-1092.4528, -7866.1421, 3656.3977);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (-1092.4528, -7866.1421, 3581.1023);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (-1092.4528, -7866.1421, 3460.6301);
	angles[14] = (0, 0, 0);
	at[14] = 0.8000;
	points[15] = (-1092.4528, -7866.1421, 3376.3149);
	angles[15] = (0, 0, 0);
	at[15] = 0.8500;
	points[16] = (-1092.4528, -7866.1421, 3376.3149);
	angles[16] = (0, 0, 0);
	at[16] = 1.8000;
	points[17] = (-1092.4528, -7866.1421, 3379.2676);
	angles[17] = (0, 0, 0);
	at[17] = 1.8500;
	points[18] = (-1092.4528, -7866.1421, 3538.7166);
	angles[18] = (0, 0, 0);
	at[18] = 2.7500;
	points[19] = (-1092.4528, -7866.1421, 3543.3071);
	angles[19] = (0, 0, 0);
	at[19] = 2.8000;
	points[20] = (-1092.4528, -7866.1421, 3543.3071);
	angles[20] = (0, 0, 0);
	at[20] = 3.7500;
	points[21] = (-1092.4528, -7866.1421, 3550.9805);
	angles[21] = (0, 0, 0);
	at[21] = 3.8000;
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
	points[0] = (-2408.9961, -6170.5122, 3550.9805);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2408.9961, -6170.5122, 3547.7363);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-2408.9961, -6170.5122, 3535.6338);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-2408.9961, -6170.5122, 3538.8779);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-2408.9961, -6170.5122, 3550.9805);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-2408.9961, -6170.5122, 3547.7363);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-2408.9961, -6170.5122, 3535.6338);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-2408.9961, -6170.5122, 3538.8779);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-2408.9961, -6170.5122, 3550.9805);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-2408.9961, -6170.5122, 3547.7363);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-2408.9961, -6170.5122, 3553.6416);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-2408.9961, -6170.5122, 3686.5156);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (-2408.9961, -6170.5122, 3656.3977);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (-2408.9961, -6170.5122, 3581.1023);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (-2408.9961, -6170.5122, 3460.6301);
	angles[14] = (0, 0, 0);
	at[14] = 0.8000;
	points[15] = (-2408.9961, -6170.5122, 3376.3149);
	angles[15] = (0, 0, 0);
	at[15] = 0.8500;
	points[16] = (-2408.9961, -6170.5122, 3376.3149);
	angles[16] = (0, 0, 0);
	at[16] = 1.8000;
	points[17] = (-2408.9961, -6170.5122, 3379.2676);
	angles[17] = (0, 0, 0);
	at[17] = 1.8500;
	points[18] = (-2408.9961, -6170.5122, 3538.7166);
	angles[18] = (0, 0, 0);
	at[18] = 2.7500;
	points[19] = (-2408.9961, -6170.5122, 3543.3071);
	angles[19] = (0, 0, 0);
	at[19] = 2.8000;
	points[20] = (-2408.9961, -6170.5122, 3543.3071);
	angles[20] = (0, 0, 0);
	at[20] = 3.7500;
	points[21] = (-2408.9961, -6170.5122, 3550.9805);
	angles[21] = (0, 0, 0);
	at[21] = 3.8000;
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
	points[0] = (-2408.9961, -7865.5903, 3543.3071);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2408.9961, -7865.5903, 3543.3071);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-2408.9961, -7865.5903, 3550.9805);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-2408.9961, -7865.5903, 3547.7363);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (-2408.9961, -7865.5903, 3535.6338);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (-2408.9961, -7865.5903, 3538.8779);
	angles[5] = (0, 0, 0);
	at[5] = 0.6500;
	points[6] = (-2408.9961, -7865.5903, 3550.9805);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (-2408.9961, -7865.5903, 3547.7363);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (-2408.9961, -7865.5903, 3535.6338);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (-2408.9961, -7865.5903, 3538.8779);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (-2408.9961, -7865.5903, 3550.9805);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (-2408.9961, -7865.5903, 3547.7363);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (-2408.9961, -7865.5903, 3553.6416);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (-2408.9961, -7865.5903, 3686.5156);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (-2408.9961, -7865.5903, 3656.3977);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (-2408.9961, -7865.5903, 3581.1023);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (-2408.9961, -7865.5903, 3460.6301);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (-2408.9961, -7865.5903, 3376.3149);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (-2408.9961, -7865.5903, 3376.3149);
	angles[18] = (0, 0, 0);
	at[18] = 2.3000;
	points[19] = (-2408.9961, -7865.5903, 3379.2676);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (-2408.9961, -7865.5903, 3538.7166);
	angles[20] = (0, 0, 0);
	at[20] = 3.2500;
	points[21] = (-2408.9961, -7865.5903, 3543.3071);
	angles[21] = (0, 0, 0);
	at[21] = 3.3000;
	points[22] = (-2408.9961, -7865.5903, 3543.3071);
	angles[22] = (0, 0, 0);
	at[22] = 3.8000;
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
	points[0] = (3417.7717, -12597.0078, 3543.3071);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (3417.7717, -12597.0078, 3543.3071);
	angles[1] = (0, 90, 0);
	at[1] = 0.9500;
	points[2] = (3417.7717, -12597.0078, 3550.9805);
	angles[2] = (0, 90, 0);
	at[2] = 1;
	points[3] = (3417.7717, -12597.0078, 3547.7363);
	angles[3] = (0, 90, 0);
	at[3] = 1.0500;
	points[4] = (3417.7717, -12597.0078, 3535.6338);
	angles[4] = (0, 90, 0);
	at[4] = 1.1000;
	points[5] = (3417.7717, -12597.0078, 3538.8779);
	angles[5] = (0, 90, 0);
	at[5] = 1.1500;
	points[6] = (3417.7717, -12597.0078, 3550.9805);
	angles[6] = (0, 90, 0);
	at[6] = 1.2000;
	points[7] = (3417.7717, -12597.0078, 3547.7363);
	angles[7] = (0, 90, 0);
	at[7] = 1.2500;
	points[8] = (3417.7717, -12597.0078, 3535.6338);
	angles[8] = (0, 90, 0);
	at[8] = 1.3000;
	points[9] = (3417.7717, -12597.0078, 3538.8779);
	angles[9] = (0, 90, 0);
	at[9] = 1.3500;
	points[10] = (3417.7717, -12597.0078, 3550.9805);
	angles[10] = (0, 90, 0);
	at[10] = 1.4000;
	points[11] = (3417.7717, -12597.0078, 3547.7363);
	angles[11] = (0, 90, 0);
	at[11] = 1.4500;
	points[12] = (3417.7717, -12597.0078, 3553.6416);
	angles[12] = (0, 90, 0);
	at[12] = 1.5000;
	points[13] = (3417.7717, -12597.0078, 3686.5156);
	angles[13] = (0, 90, 0);
	at[13] = 1.6500;
	points[14] = (3417.7717, -12597.0078, 3656.3977);
	angles[14] = (0, 90, 0);
	at[14] = 1.7000;
	points[15] = (3417.7717, -12597.0078, 3581.1023);
	angles[15] = (0, 90, 0);
	at[15] = 1.7500;
	points[16] = (3417.7717, -12597.0078, 3460.6301);
	angles[16] = (0, 90, 0);
	at[16] = 1.8000;
	points[17] = (3417.7717, -12597.0078, 3376.3149);
	angles[17] = (0, 90, 0);
	at[17] = 1.8500;
	points[18] = (3417.7717, -12597.0078, 3376.3149);
	angles[18] = (0, 90, 0);
	at[18] = 2.8000;
	points[19] = (3417.7717, -12597.0078, 3379.2676);
	angles[19] = (0, 90, 0);
	at[19] = 2.8500;
	points[20] = (3417.7717, -12597.0078, 3538.7166);
	angles[20] = (0, 90, 0);
	at[20] = 3.7500;
	points[21] = (3417.7717, -12597.0078, 3543.3071);
	angles[21] = (0, 90, 0);
	at[21] = 3.8000;
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
	points[0] = (2257.3623, -12597.0078, 3543.3071);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (2257.3623, -12597.0078, 3543.3071);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (2257.3623, -12597.0078, 3550.9805);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (2257.3623, -12597.0078, 3547.7363);
	angles[3] = (0, 90, 0);
	at[3] = 0.5500;
	points[4] = (2257.3623, -12597.0078, 3535.6338);
	angles[4] = (0, 90, 0);
	at[4] = 0.6000;
	points[5] = (2257.3623, -12597.0078, 3538.8779);
	angles[5] = (0, 90, 0);
	at[5] = 0.6500;
	points[6] = (2257.3623, -12597.0078, 3550.9805);
	angles[6] = (0, 90, 0);
	at[6] = 0.7000;
	points[7] = (2257.3623, -12597.0078, 3547.7363);
	angles[7] = (0, 90, 0);
	at[7] = 0.7500;
	points[8] = (2257.3623, -12597.0078, 3535.6338);
	angles[8] = (0, 90, 0);
	at[8] = 0.8000;
	points[9] = (2257.3623, -12597.0078, 3538.8779);
	angles[9] = (0, 90, 0);
	at[9] = 0.8500;
	points[10] = (2257.3623, -12597.0078, 3550.9805);
	angles[10] = (0, 90, 0);
	at[10] = 0.9000;
	points[11] = (2257.3623, -12597.0078, 3547.7363);
	angles[11] = (0, 90, 0);
	at[11] = 0.9500;
	points[12] = (2257.3623, -12597.0078, 3553.6416);
	angles[12] = (0, 90, 0);
	at[12] = 1;
	points[13] = (2257.3623, -12597.0078, 3686.5156);
	angles[13] = (0, 90, 0);
	at[13] = 1.1500;
	points[14] = (2257.3623, -12597.0078, 3656.3977);
	angles[14] = (0, 90, 0);
	at[14] = 1.2000;
	points[15] = (2257.3623, -12597.0078, 3581.1023);
	angles[15] = (0, 90, 0);
	at[15] = 1.2500;
	points[16] = (2257.3623, -12597.0078, 3460.6301);
	angles[16] = (0, 90, 0);
	at[16] = 1.3000;
	points[17] = (2257.3623, -12597.0078, 3376.3149);
	angles[17] = (0, 90, 0);
	at[17] = 1.3500;
	points[18] = (2257.3623, -12597.0078, 3376.3149);
	angles[18] = (0, 90, 0);
	at[18] = 2.3000;
	points[19] = (2257.3623, -12597.0078, 3379.2676);
	angles[19] = (0, 90, 0);
	at[19] = 2.3500;
	points[20] = (2257.3623, -12597.0078, 3538.7166);
	angles[20] = (0, 90, 0);
	at[20] = 3.2500;
	points[21] = (2257.3623, -12597.0078, 3543.3071);
	angles[21] = (0, 90, 0);
	at[21] = 3.3000;
	points[22] = (2257.3623, -12597.0078, 3543.3071);
	angles[22] = (0, 90, 0);
	at[22] = 3.8000;
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
	points[0] = (1117.9331, -12597.0078, 3550.9805);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1117.9331, -12597.0078, 3547.7363);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (1117.9331, -12597.0078, 3535.6338);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (1117.9331, -12597.0078, 3538.8779);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (1117.9331, -12597.0078, 3550.9805);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (1117.9331, -12597.0078, 3547.7363);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (1117.9331, -12597.0078, 3535.6338);
	angles[6] = (0, 90, 0);
	at[6] = 0.3000;
	points[7] = (1117.9331, -12597.0078, 3538.8779);
	angles[7] = (0, 90, 0);
	at[7] = 0.3500;
	points[8] = (1117.9331, -12597.0078, 3550.9805);
	angles[8] = (0, 90, 0);
	at[8] = 0.4000;
	points[9] = (1117.9331, -12597.0078, 3547.7363);
	angles[9] = (0, 90, 0);
	at[9] = 0.4500;
	points[10] = (1117.9331, -12597.0078, 3553.6416);
	angles[10] = (0, 90, 0);
	at[10] = 0.5000;
	points[11] = (1117.9331, -12597.0078, 3686.5156);
	angles[11] = (0, 90, 0);
	at[11] = 0.6500;
	points[12] = (1117.9331, -12597.0078, 3656.3977);
	angles[12] = (0, 90, 0);
	at[12] = 0.7000;
	points[13] = (1117.9331, -12597.0078, 3581.1023);
	angles[13] = (0, 90, 0);
	at[13] = 0.7500;
	points[14] = (1117.9331, -12597.0078, 3460.6301);
	angles[14] = (0, 90, 0);
	at[14] = 0.8000;
	points[15] = (1117.9331, -12597.0078, 3376.3149);
	angles[15] = (0, 90, 0);
	at[15] = 0.8500;
	points[16] = (1117.9331, -12597.0078, 3376.3149);
	angles[16] = (0, 90, 0);
	at[16] = 1.8000;
	points[17] = (1117.9331, -12597.0078, 3379.2676);
	angles[17] = (0, 90, 0);
	at[17] = 1.8500;
	points[18] = (1117.9331, -12597.0078, 3538.7166);
	angles[18] = (0, 90, 0);
	at[18] = 2.7500;
	points[19] = (1117.9331, -12597.0078, 3543.3071);
	angles[19] = (0, 90, 0);
	at[19] = 2.8000;
	points[20] = (1117.9331, -12597.0078, 3543.3071);
	angles[20] = (0, 90, 0);
	at[20] = 3.7500;
	points[21] = (1117.9331, -12597.0078, 3550.9805);
	angles[21] = (0, 90, 0);
	at[21] = 3.8000;
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
	points[0] = (4825.6694, -7701.7720, 2477.6062);
	angles[0] = (0, 90.9012, 88.4490);
	at[0] = 0;
	points[1] = (4823.5039, -7701.8115, 2550.3306);
	angles[1] = (0, 90.8352, 88.3251);
	at[1] = 0.1500;
	points[2] = (4821.4961, -7701.8115, 2618.0903);
	angles[2] = (0, 90.8271, 88.3084);
	at[2] = 0.3000;
	points[3] = (4819.6455, -7701.8506, 2681.2285);
	angles[3] = (0, 90.8260, 88.3063);
	at[3] = 0.4500;
	points[4] = (4817.9136, -7701.8901, 2740.0593);
	angles[4] = (0, 90.8259, 88.3059);
	at[4] = 0.6000;
	points[5] = (4816.2993, -7701.8901, 2794.8740);
	angles[5] = (0, 90.8257, 88.3058);
	at[5] = 0.7500;
	points[6] = (4814.2915, -7701.9292, 2862.1851);
	angles[6] = (0, 90.8257, 88.3058);
	at[6] = 0.9500;
	points[7] = (4809.2124, -7701.8506, 2876.1575);
	angles[7] = (0, 89.2656, 78.0771);
	at[7] = 1;
	points[8] = (4804.6851, -7701.7720, 2886.9292);
	angles[8] = (0, 89.1847, 72.7874);
	at[8] = 1.0500;
	points[9] = (4801.1812, -7701.7319, 2895.2363);
	angles[9] = (0, 89.1588, 58.0205);
	at[9] = 1.1000;
	points[10] = (4796.4570, -7701.6533, 2884.4487);
	angles[10] = (0, 89.1518, 15.4974);
	at[10] = 1.1500;
	points[11] = (4790.7871, -7701.5747, 2874.6694);
	angles[11] = (0, 89.1487, -18.1533);
	at[11] = 1.2000;
	points[12] = (4783.7007, -7701.4570, 2862.4211);
	angles[12] = (0, 89.1617, -42.8520);
	at[12] = 1.2500;
	points[13] = (4783.9766, -7701.4961, 2846.0432);
	angles[13] = (0, 89.2194, -64.1380);
	at[13] = 1.3000;
	points[14] = (4783.3467, -7701.4961, 2829.5588);
	angles[14] = (0, 89.3118, -75.5559);
	at[14] = 1.3500;
	points[15] = (4782.6377, -7701.4961, 2812.6851);
	angles[15] = (0, 89.4537, -81.4753);
	at[15] = 1.4000;
	points[16] = (4781.2598, -7701.4961, 2777.7283);
	angles[16] = (0, 89.8555, -86.0739);
	at[16] = 1.5000;
	points[17] = (4777.4409, -7701.5356, 2682.8384);
	angles[17] = (0, 90.3542, -87.6512);
	at[17] = 1.7500;
	points[18] = (4774.0947, -7701.5747, 2598.5315);
	angles[18] = (0, 90.3833, -87.7049);
	at[18] = 1.9500;
	points[19] = (4771.3389, -7701.5747, 2529.9214);
	angles[19] = (0, 90.3852, -87.7083);
	at[19] = 2.1000;
	points[20] = (4768.3857, -7701.6143, 2456.3269);
	angles[20] = (0, 90.3854, -87.7088);
	at[20] = 2.2500;
	points[21] = (4765.2363, -7701.6143, 2377.3899);
	angles[21] = (0, 90.3855, -87.7089);
	at[21] = 2.4000;
	points[22] = (4761.8501, -7701.6533, 2292.7205);
	angles[22] = (0, 90.3855, -87.7089);
	at[22] = 2.5500;
	points[23] = (4758.2285, -7701.6533, 2201.9055);
	angles[23] = (0, 90.3855, -87.7089);
	at[23] = 2.7000;
	points[24] = (4772.3623, -7701.6533, 2185.0393);
	angles[24] = (0, 269.9907, -65.0308);
	at[24] = 2.7500;
	points[25] = (4804.2520, -7701.6533, 2185.0393);
	angles[25] = (0, 270.0117, -35.2373);
	at[25] = 2.8000;
	points[26] = (4843.7793, -7701.6533, 2185.0393);
	angles[26] = (0, 270.0108, -3.9228);
	at[26] = 2.8500;
	points[27] = (4833.1104, -7701.6533, 2225.8857);
	angles[27] = (0, 269.9917, 35.7354);
	at[27] = 2.9000;
	points[28] = (4832.2046, -7701.6929, 2256.5630);
	angles[28] = (0, 269.9640, 61.8384);
	at[28] = 2.9500;
	points[29] = (4831.3389, -7701.6929, 2286.5237);
	angles[29] = (0, 269.9106, 76.2344);
	at[29] = 3;
	points[30] = (4830.4727, -7701.6929, 2315.7874);
	angles[30] = (0, 269.7885, 83.7548);
	at[30] = 3.0500;
	points[31] = (4828.7798, -7701.7319, 2372.2874);
	angles[31] = (0, 266.4585, 89.6100);
	at[31] = 3.1500;
	points[32] = (4827.9922, -7701.7319, 2399.5552);
	angles[32] = (0, 92.2142, 89.3722);
	at[32] = 3.2000;
	points[33] = (4825.6694, -7701.7720, 2477.6062);
	angles[33] = (0, 90.9012, 88.4490);
	at[33] = 3.3500;
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
	points[0] = (6626.8506, -7701.7720, 2477.6062);
	angles[0] = (0, 90.9012, 88.4490);
	at[0] = 0;
	points[1] = (6624.6851, -7701.8115, 2550.3306);
	angles[1] = (0, 90.8352, 88.3251);
	at[1] = 0.1500;
	points[2] = (6622.6772, -7701.8115, 2618.0947);
	angles[2] = (0, 90.8271, 88.3084);
	at[2] = 0.3000;
	points[3] = (6620.8271, -7701.8506, 2681.2285);
	angles[3] = (0, 90.8260, 88.3062);
	at[3] = 0.4500;
	points[4] = (6619.0947, -7701.8901, 2740.0593);
	angles[4] = (0, 90.8259, 88.3059);
	at[4] = 0.6000;
	points[5] = (6617.4805, -7701.8901, 2794.8740);
	angles[5] = (0, 90.8257, 88.3058);
	at[5] = 0.7500;
	points[6] = (6615.4727, -7701.9292, 2862.1851);
	angles[6] = (0, 90.8257, 88.3058);
	at[6] = 0.9500;
	points[7] = (6610.3940, -7701.8506, 2876.1575);
	angles[7] = (0, 89.2657, 78.0774);
	at[7] = 1;
	points[8] = (6605.8662, -7701.7720, 2886.9292);
	angles[8] = (0, 89.1846, 72.7876);
	at[8] = 1.0500;
	points[9] = (6602.3623, -7701.7319, 2895.2363);
	angles[9] = (0, 89.1589, 58.0210);
	at[9] = 1.1000;
	points[10] = (6597.6382, -7701.6533, 2884.4487);
	angles[10] = (0, 89.1519, 15.4978);
	at[10] = 1.1500;
	points[11] = (6591.9688, -7701.5747, 2874.6694);
	angles[11] = (0, 89.1488, -18.1530);
	at[11] = 1.2000;
	points[12] = (6584.8818, -7701.4570, 2862.4211);
	angles[12] = (0, 89.1617, -42.8518);
	at[12] = 1.2500;
	points[13] = (6585.1577, -7701.4961, 2846.0432);
	angles[13] = (0, 89.2194, -64.1380);
	at[13] = 1.3000;
	points[14] = (6584.5273, -7701.4961, 2829.5588);
	angles[14] = (0, 89.3118, -75.5559);
	at[14] = 1.3500;
	points[15] = (6583.8193, -7701.4961, 2812.6812);
	angles[15] = (0, 89.4537, -81.4753);
	at[15] = 1.4000;
	points[16] = (6582.4409, -7701.4961, 2777.7244);
	angles[16] = (0, 89.8555, -86.0740);
	at[16] = 1.5000;
	points[17] = (6578.6221, -7701.5356, 2682.8384);
	angles[17] = (0, 90.3542, -87.6512);
	at[17] = 1.7500;
	points[18] = (6575.2754, -7701.5747, 2598.5276);
	angles[18] = (0, 90.3833, -87.7049);
	at[18] = 1.9500;
	points[19] = (6572.5200, -7701.5747, 2529.9214);
	angles[19] = (0, 90.3852, -87.7083);
	at[19] = 2.1000;
	points[20] = (6569.5674, -7701.6143, 2456.3269);
	angles[20] = (0, 90.3855, -87.7089);
	at[20] = 2.2500;
	points[21] = (6566.4175, -7701.6143, 2377.3899);
	angles[21] = (0, 90.3855, -87.7089);
	at[21] = 2.4000;
	points[22] = (6563.0317, -7701.6533, 2292.7205);
	angles[22] = (0, 90.3855, -87.7089);
	at[22] = 2.5500;
	points[23] = (6559.4092, -7701.6533, 2201.9016);
	angles[23] = (0, 90.3855, -87.7089);
	at[23] = 2.7000;
	points[24] = (6573.5435, -7701.6533, 2185.0393);
	angles[24] = (0, 269.9907, -65.0307);
	at[24] = 2.7500;
	points[25] = (6605.4331, -7701.6533, 2185.0393);
	angles[25] = (0, 270.0117, -35.2373);
	at[25] = 2.8000;
	points[26] = (6644.9604, -7701.6533, 2185.0393);
	angles[26] = (0, 270.0108, -3.9228);
	at[26] = 2.8500;
	points[27] = (6634.2915, -7701.6533, 2225.8899);
	angles[27] = (0, 269.9917, 35.7354);
	at[27] = 2.9000;
	points[28] = (6633.3862, -7701.6929, 2256.5630);
	angles[28] = (0, 269.9640, 61.8384);
	at[28] = 2.9500;
	points[29] = (6632.5200, -7701.6929, 2286.5276);
	angles[29] = (0, 269.9106, 76.2344);
	at[29] = 3;
	points[30] = (6631.6538, -7701.6929, 2315.7913);
	angles[30] = (0, 269.7885, 83.7548);
	at[30] = 3.0500;
	points[31] = (6629.9609, -7701.7319, 2372.2913);
	angles[31] = (0, 266.4583, 89.6100);
	at[31] = 3.1500;
	points[32] = (6629.1733, -7701.7319, 2399.5552);
	angles[32] = (0, 92.2141, 89.3722);
	at[32] = 3.2000;
	points[33] = (6626.8506, -7701.7720, 2477.6062);
	angles[33] = (0, 90.9012, 88.4490);
	at[33] = 3.3500;
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
	points[0] = (5741.0239, -5841.5356, 2477.6062);
	angles[0] = (0, 90.9012, 88.4490);
	at[0] = 0;
	points[1] = (5738.8584, -5841.5752, 2550.3306);
	angles[1] = (0, 90.8352, 88.3251);
	at[1] = 0.1500;
	points[2] = (5736.8896, -5841.5752, 2618.0947);
	angles[2] = (0, 90.8271, 88.3084);
	at[2] = 0.3000;
	points[3] = (5735, -5841.6143, 2681.2285);
	angles[3] = (0, 90.8260, 88.3062);
	at[3] = 0.4500;
	points[4] = (5733.2676, -5841.6538, 2740.0593);
	angles[4] = (0, 90.8259, 88.3059);
	at[4] = 0.6000;
	points[5] = (5731.6538, -5841.6538, 2794.8740);
	angles[5] = (0, 90.8257, 88.3058);
	at[5] = 0.7500;
	points[6] = (5729.6460, -5841.6929, 2862.1851);
	angles[6] = (0, 90.8257, 88.3058);
	at[6] = 0.9500;
	points[7] = (5724.5674, -5841.6143, 2876.1575);
	angles[7] = (0, 89.2657, 78.0774);
	at[7] = 1;
	points[8] = (5720.0396, -5841.5356, 2886.9292);
	angles[8] = (0, 89.1846, 72.7876);
	at[8] = 1.0500;
	points[9] = (5716.5352, -5841.4961, 2895.2363);
	angles[9] = (0, 89.1589, 58.0210);
	at[9] = 1.1000;
	points[10] = (5711.8110, -5841.4170, 2884.4487);
	angles[10] = (0, 89.1519, 15.4978);
	at[10] = 1.1500;
	points[11] = (5706.1421, -5841.3384, 2874.6694);
	angles[11] = (0, 89.1488, -18.1530);
	at[11] = 1.2000;
	points[12] = (5699.0552, -5841.2207, 2862.4211);
	angles[12] = (0, 89.1617, -42.8518);
	at[12] = 1.2500;
	points[13] = (5699.3306, -5841.2598, 2846.0432);
	angles[13] = (0, 89.2194, -64.1380);
	at[13] = 1.3000;
	points[14] = (5698.7007, -5841.2598, 2829.5588);
	angles[14] = (0, 89.3118, -75.5559);
	at[14] = 1.3500;
	points[15] = (5697.9922, -5841.2598, 2812.6812);
	angles[15] = (0, 89.4537, -81.4753);
	at[15] = 1.4000;
	points[16] = (5696.6143, -5841.2598, 2777.7244);
	angles[16] = (0, 89.8555, -86.0740);
	at[16] = 1.5000;
	points[17] = (5692.7954, -5841.2993, 2682.8384);
	angles[17] = (0, 90.3542, -87.6512);
	at[17] = 1.7500;
	points[18] = (5689.4487, -5841.3384, 2598.5276);
	angles[18] = (0, 90.3833, -87.7049);
	at[18] = 1.9500;
	points[19] = (5686.6929, -5841.3384, 2529.9214);
	angles[19] = (0, 90.3852, -87.7083);
	at[19] = 2.1000;
	points[20] = (5683.7402, -5841.3779, 2456.3269);
	angles[20] = (0, 90.3855, -87.7089);
	at[20] = 2.2500;
	points[21] = (5680.5908, -5841.3779, 2377.3899);
	angles[21] = (0, 90.3855, -87.7089);
	at[21] = 2.4000;
	points[22] = (5677.2051, -5841.4170, 2292.7205);
	angles[22] = (0, 90.3855, -87.7089);
	at[22] = 2.5500;
	points[23] = (5673.5825, -5841.4170, 2201.9016);
	angles[23] = (0, 90.3855, -87.7089);
	at[23] = 2.7000;
	points[24] = (5687.7168, -5841.4170, 2185.0393);
	angles[24] = (0, 269.9907, -65.0307);
	at[24] = 2.7500;
	points[25] = (5719.6064, -5841.4170, 2185.0393);
	angles[25] = (0, 270.0117, -35.2373);
	at[25] = 2.8000;
	points[26] = (5759.1338, -5841.4170, 2185.0393);
	angles[26] = (0, 270.0108, -3.9228);
	at[26] = 2.8500;
	points[27] = (5748.4648, -5841.4170, 2225.8899);
	angles[27] = (0, 269.9917, 35.7354);
	at[27] = 2.9000;
	points[28] = (5747.5596, -5841.4570, 2256.5630);
	angles[28] = (0, 269.9640, 61.8384);
	at[28] = 2.9500;
	points[29] = (5746.6934, -5841.4570, 2286.5276);
	angles[29] = (0, 269.9106, 76.2344);
	at[29] = 3;
	points[30] = (5745.8267, -5841.4570, 2315.7913);
	angles[30] = (0, 269.7885, 83.7548);
	at[30] = 3.0500;
	points[31] = (5744.1338, -5841.4961, 2372.2913);
	angles[31] = (0, 266.4583, 89.6100);
	at[31] = 3.1500;
	points[32] = (5743.3462, -5841.4961, 2399.5552);
	angles[32] = (0, 92.2141, 89.3722);
	at[32] = 3.2000;
	points[33] = (5741.0239, -5841.5356, 2477.6062);
	angles[33] = (0, 90.9012, 88.4490);
	at[33] = 3.3500;
	mover = getEnt("iz_obj_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5712.5591, 3867.7874, 4384.8428);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5712.5591, 3867.7874, 4384.8428);
	angles[1] = (1, -90, -1);
	at[1] = 4.5000;
	points[2] = (5712.5591, 3867.7874, 4384.8428);
	angles[2] = (0, -180, -2);
	at[2] = 9;
	points[3] = (5712.5591, 3867.7874, 4384.8428);
	angles[3] = (0, -360, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1928.3032, 10445.7090, 3477.7676);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-1928.3032, 10445.7090, 3407.0552);
	angles[1] = (0, -170, 0);
	at[1] = 0.2000;
	points[2] = (-1928.3032, 10445.7090, 3404.2322);
	angles[2] = (0, -170, 0);
	at[2] = 0.2500;
	points[3] = (-1928.3032, 10445.7090, 3404.2322);
	angles[3] = (0, -170, 0);
	at[3] = 3.3000;
	points[4] = (-1928.3032, 10445.7090, 3492.8149);
	angles[4] = (0, -170, 0);
	at[4] = 3.3500;
	points[5] = (-1928.3032, 10445.7090, 3492.8149);
	angles[5] = (0, -170, 0);
	at[5] = 5.6000;
	points[6] = (-1928.3032, 10445.7090, 3512.3188);
	angles[6] = (0, -170, 0);
	at[6] = 5.6500;
	points[7] = (-1928.3032, 10445.7090, 3568.2639);
	angles[7] = (0, -170, 0);
	at[7] = 5.7000;
	points[8] = (-1928.3032, 10445.7090, 3668.5750);
	angles[8] = (0, -170, 0);
	at[8] = 5.8000;
	points[9] = (-1928.3032, 10445.7090, 3753.4529);
	angles[9] = (0, -170, 0);
	at[9] = 5.9000;
	points[10] = (-1928.3032, 10445.7090, 3790.1064);
	angles[10] = (0, -170, 0);
	at[10] = 5.9500;
	points[11] = (-1928.3032, 10445.7090, 3851.8347);
	angles[11] = (0, -170, 0);
	at[11] = 6.0500;
	points[12] = (-1928.3032, 10445.7090, 3898.1299);
	angles[12] = (0, -170, 0);
	at[12] = 6.1500;
	points[13] = (-1928.3032, 10445.7090, 3928.9961);
	angles[13] = (0, -170, 0);
	at[13] = 6.2500;
	points[14] = (-1928.3032, 10445.7090, 3938.6614);
	angles[14] = (0, -170, 0);
	at[14] = 6.3000;
	points[15] = (-1928.3032, 10445.7090, 3946.3386);
	angles[15] = (0, -170, 0);
	at[15] = 6.4000;
	points[16] = (-1928.3032, 10445.7090, 3960.3938);
	angles[16] = (0, -170, 0);
	at[16] = 6.5000;
	points[17] = (-1928.3032, 10445.7090, 3960.3938);
	angles[17] = (0, -170, 0);
	at[17] = 6.5500;
	points[18] = (-1928.3032, 10445.7090, 3955.0393);
	angles[18] = (0, -170, 0);
	at[18] = 6.6000;
	points[19] = (-1928.3032, 10445.7090, 3937.6772);
	angles[19] = (0, -170, 0);
	at[19] = 6.7000;
	points[20] = (-1928.3032, 10445.7090, 3932.3188);
	angles[20] = (0, -170, 0);
	at[20] = 6.7500;
	points[21] = (-1928.3032, 10445.7090, 3932.3188);
	angles[21] = (0, -170, 0);
	at[21] = 6.8000;
	points[22] = (-1928.3032, 10445.7090, 3937.6772);
	angles[22] = (0, -170, 0);
	at[22] = 6.8500;
	points[23] = (-1928.3032, 10445.7090, 3955.0393);
	angles[23] = (0, -170, 0);
	at[23] = 6.9500;
	points[24] = (-1928.3032, 10445.7090, 3960.3938);
	angles[24] = (0, -170, 0);
	at[24] = 7;
	points[25] = (-1928.3032, 10445.7090, 3960.3938);
	angles[25] = (0, -170, 0);
	at[25] = 7.0500;
	points[26] = (-1928.3032, 10445.7090, 3955.0393);
	angles[26] = (0, -170, 0);
	at[26] = 7.1000;
	points[27] = (-1928.3032, 10445.7090, 3937.6772);
	angles[27] = (0, -170, 0);
	at[27] = 7.2000;
	points[28] = (-1928.3032, 10445.7090, 3932.3188);
	angles[28] = (0, -170, 0);
	at[28] = 7.2500;
	points[29] = (-1928.3032, 10445.7090, 3932.3188);
	angles[29] = (0, -170, 0);
	at[29] = 7.3000;
	points[30] = (-1928.3032, 10445.7090, 3937.6772);
	angles[30] = (0, -170, 0);
	at[30] = 7.3500;
	points[31] = (-1928.3032, 10445.7090, 3955.0393);
	angles[31] = (0, -170, 0);
	at[31] = 7.4500;
	points[32] = (-1928.3032, 10445.7090, 3960.3938);
	angles[32] = (0, -170, 0);
	at[32] = 7.5000;
	points[33] = (-1928.3032, 10445.7090, 3960.3938);
	angles[33] = (0, -170, 0);
	at[33] = 7.5500;
	points[34] = (-1928.3032, 10445.7090, 3955.0393);
	angles[34] = (0, -170, 0);
	at[34] = 7.6000;
	points[35] = (-1928.3032, 10445.7090, 3937.4016);
	angles[35] = (0, -170, 0);
	at[35] = 7.7000;
	points[36] = (-1928.3032, 10445.7090, 3477.7676);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1305.8071, 9791.2598, 3713.4724);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-1305.8071, 9791.2598, 3412.9490);
	angles[1] = (0, -170, 0);
	at[1] = 0.8500;
	points[2] = (-1305.8071, 9791.2598, 3404.2322);
	angles[2] = (0, -170, 0);
	at[2] = 0.9000;
	points[3] = (-1305.8071, 9791.2598, 3404.2322);
	angles[3] = (0, -170, 0);
	at[3] = 1;
	points[4] = (-1305.8071, 9791.2598, 3404.2322);
	angles[4] = (0, -170, 0);
	at[4] = 3.9500;
	points[5] = (-1305.8071, 9791.2598, 3492.8149);
	angles[5] = (0, -170, 0);
	at[5] = 4;
	points[6] = (-1305.8071, 9791.2598, 3492.8149);
	angles[6] = (0, -170, 0);
	at[6] = 6.3000;
	points[7] = (-1305.8071, 9791.2598, 3603.4136);
	angles[7] = (0, -170, 0);
	at[7] = 6.4000;
	points[8] = (-1305.8071, 9791.2598, 3698.5828);
	angles[8] = (0, -170, 0);
	at[8] = 6.5000;
	points[9] = (-1305.8071, 9791.2598, 3778.3149);
	angles[9] = (0, -170, 0);
	at[9] = 6.6000;
	points[10] = (-1305.8071, 9791.2598, 3842.6182);
	angles[10] = (0, -170, 0);
	at[10] = 6.7000;
	points[11] = (-1305.8071, 9791.2598, 3891.4883);
	angles[11] = (0, -170, 0);
	at[11] = 6.8000;
	points[12] = (-1305.8071, 9791.2598, 3924.9253);
	angles[12] = (0, -170, 0);
	at[12] = 6.9000;
	points[13] = (-1305.8071, 9791.2598, 3942.9136);
	angles[13] = (0, -170, 0);
	at[13] = 7;
	points[14] = (-1305.8071, 9791.2598, 3946.1418);
	angles[14] = (0, -170, 0);
	at[14] = 7.0500;
	points[15] = (-1305.8071, 9791.2598, 3959.1338);
	angles[15] = (0, -170, 0);
	at[15] = 7.1500;
	points[16] = (-1305.8071, 9791.2598, 3961.0237);
	angles[16] = (0, -170, 0);
	at[16] = 7.2000;
	points[17] = (-1305.8071, 9791.2598, 3957.3228);
	angles[17] = (0, -170, 0);
	at[17] = 7.2500;
	points[18] = (-1305.8071, 9791.2598, 3933.5708);
	angles[18] = (0, -170, 0);
	at[18] = 7.4000;
	points[19] = (-1305.8071, 9791.2598, 3931.6733);
	angles[19] = (0, -170, 0);
	at[19] = 7.4500;
	points[20] = (-1305.8071, 9791.2598, 3935.3860);
	angles[20] = (0, -170, 0);
	at[20] = 7.5000;
	points[21] = (-1305.8071, 9791.2598, 3959.1338);
	angles[21] = (0, -170, 0);
	at[21] = 7.6500;
	points[22] = (-1305.8071, 9791.2598, 3961.0237);
	angles[22] = (0, -170, 0);
	at[22] = 7.7000;
	points[23] = (-1305.8071, 9791.2598, 3957.3228);
	angles[23] = (0, -170, 0);
	at[23] = 7.7500;
	points[24] = (-1305.8071, 9791.2598, 3933.5708);
	angles[24] = (0, -170, 0);
	at[24] = 7.9000;
	points[25] = (-1305.8071, 9791.2598, 3931.6733);
	angles[25] = (0, -170, 0);
	at[25] = 7.9500;
	points[26] = (-1305.8071, 9791.2598, 3935.3860);
	angles[26] = (0, -170, 0);
	at[26] = 8;
	points[27] = (-1305.8071, 9791.2598, 3959.1338);
	angles[27] = (0, -170, 0);
	at[27] = 8.1500;
	points[28] = (-1305.8071, 9791.2598, 3961.0237);
	angles[28] = (0, -170, 0);
	at[28] = 8.2000;
	points[29] = (-1305.8071, 9791.2598, 3957.3228);
	angles[29] = (0, -170, 0);
	at[29] = 8.2500;
	points[30] = (-1305.8071, 9791.2598, 3943.3074);
	angles[30] = (0, -170, 0);
	at[30] = 8.3500;
	points[31] = (-1305.8071, 9791.2598, 3713.4724);
	angles[31] = (0, -170, 0);
	at[31] = 9;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-337.4563, 12384.7637, 3944.1338);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-337.4563, 12384.7637, 3932.3464);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (-337.4563, 12384.7637, 3419.6812);
	angles[2] = (0, -170, 0);
	at[2] = 1.5000;
	points[3] = (-337.4563, 12384.7637, 3405.0747);
	angles[3] = (0, -170, 0);
	at[3] = 1.5500;
	points[4] = (-337.4563, 12384.7637, 3405.0747);
	angles[4] = (0, -170, 0);
	at[4] = 4.6500;
	points[5] = (-337.4563, 12384.7637, 3493.6575);
	angles[5] = (0, -170, 0);
	at[5] = 4.7000;
	points[6] = (-337.4563, 12384.7637, 3493.6575);
	angles[6] = (0, -170, 0);
	at[6] = 6.9500;
	points[7] = (-337.4563, 12384.7637, 3532.2363);
	angles[7] = (0, -170, 0);
	at[7] = 7;
	points[8] = (-337.4563, 12384.7637, 3586.8938);
	angles[8] = (0, -170, 0);
	at[8] = 7.0500;
	points[9] = (-337.4563, 12384.7637, 3684.6338);
	angles[9] = (0, -170, 0);
	at[9] = 7.1500;
	points[10] = (-337.4563, 12384.7637, 3727.7166);
	angles[10] = (0, -170, 0);
	at[10] = 7.2000;
	points[11] = (-337.4563, 12384.7637, 3802.3071);
	angles[11] = (0, -170, 0);
	at[11] = 7.3000;
	points[12] = (-337.4563, 12384.7637, 3833.8149);
	angles[12] = (0, -170, 0);
	at[12] = 7.3500;
	points[13] = (-337.4563, 12384.7637, 3885.2561);
	angles[13] = (0, -170, 0);
	at[13] = 7.4500;
	points[14] = (-337.4563, 12384.7637, 3905.1892);
	angles[14] = (0, -170, 0);
	at[14] = 7.5000;
	points[15] = (-337.4563, 12384.7637, 3933.4805);
	angles[15] = (0, -170, 0);
	at[15] = 7.6000;
	points[16] = (-337.4563, 12384.7637, 3941.8506);
	angles[16] = (0, -170, 0);
	at[16] = 7.6500;
	points[17] = (-337.4563, 12384.7637, 3961.8899);
	angles[17] = (0, -170, 0);
	at[17] = 7.8500;
	points[18] = (-337.4563, 12384.7637, 3960);
	angles[18] = (0, -170, 0);
	at[18] = 7.9000;
	points[19] = (-337.4563, 12384.7637, 3936.2285);
	angles[19] = (0, -170, 0);
	at[19] = 8.0500;
	points[20] = (-337.4563, 12384.7637, 3932.5159);
	angles[20] = (0, -170, 0);
	at[20] = 8.1000;
	points[21] = (-337.4563, 12384.7637, 3934.4133);
	angles[21] = (0, -170, 0);
	at[21] = 8.1500;
	points[22] = (-337.4563, 12384.7637, 3958.1892);
	angles[22] = (0, -170, 0);
	at[22] = 8.3000;
	points[23] = (-337.4563, 12384.7637, 3961.8899);
	angles[23] = (0, -170, 0);
	at[23] = 8.3500;
	points[24] = (-337.4563, 12384.7637, 3960);
	angles[24] = (0, -170, 0);
	at[24] = 8.4000;
	points[25] = (-337.4563, 12384.7637, 3936.2285);
	angles[25] = (0, -170, 0);
	at[25] = 8.5500;
	points[26] = (-337.4563, 12384.7637, 3932.5159);
	angles[26] = (0, -170, 0);
	at[26] = 8.6000;
	points[27] = (-337.4563, 12384.7637, 3934.4133);
	angles[27] = (0, -170, 0);
	at[27] = 8.6500;
	points[28] = (-337.4563, 12384.7637, 3958.1892);
	angles[28] = (0, -170, 0);
	at[28] = 8.8000;
	points[29] = (-337.4563, 12384.7637, 3961.8899);
	angles[29] = (0, -170, 0);
	at[29] = 8.8500;
	points[30] = (-337.4563, 12384.7637, 3960);
	angles[30] = (0, -170, 0);
	at[30] = 8.9000;
	points[31] = (-337.4563, 12384.7637, 3944.1338);
	angles[31] = (0, -170, 0);
	at[31] = 9;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1445.1772, 11140.8262, 3960.3938);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-1445.1772, 11140.8262, 3960.3938);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (-1445.1772, 11140.8262, 3955.0393);
	angles[2] = (0, -170, 0);
	at[2] = 0.1000;
	points[3] = (-1445.1772, 11140.8262, 3937.6772);
	angles[3] = (0, -170, 0);
	at[3] = 0.2000;
	points[4] = (-1445.1772, 11140.8262, 3932.3188);
	angles[4] = (0, -170, 0);
	at[4] = 0.2500;
	points[5] = (-1445.1772, 11140.8262, 3932.3188);
	angles[5] = (0, -170, 0);
	at[5] = 0.3000;
	points[6] = (-1445.1772, 11140.8262, 3937.6772);
	angles[6] = (0, -170, 0);
	at[6] = 0.3500;
	points[7] = (-1445.1772, 11140.8262, 3955.0393);
	angles[7] = (0, -170, 0);
	at[7] = 0.4500;
	points[8] = (-1445.1772, 11140.8262, 3960.3938);
	angles[8] = (0, -170, 0);
	at[8] = 0.5000;
	points[9] = (-1445.1772, 11140.8262, 3960.3938);
	angles[9] = (0, -170, 0);
	at[9] = 0.5500;
	points[10] = (-1445.1772, 11140.8262, 3955.0393);
	angles[10] = (0, -170, 0);
	at[10] = 0.6000;
	points[11] = (-1445.1772, 11140.8262, 3936.1653);
	angles[11] = (0, -170, 0);
	at[11] = 0.7000;
	points[12] = (-1445.1772, 11140.8262, 3294.9016);
	angles[12] = (0, -170, 0);
	at[12] = 2.2000;
	points[13] = (-1445.1772, 11140.8262, 3290.8464);
	angles[13] = (0, -170, 0);
	at[13] = 2.2500;
	points[14] = (-1445.1772, 11140.8262, 3290.8464);
	angles[14] = (0, -170, 0);
	at[14] = 3.3500;
	points[15] = (-1445.1772, 11140.8262, 3290.8464);
	angles[15] = (0, -170, 0);
	at[15] = 5.3000;
	points[16] = (-1445.1772, 11140.8262, 3379.4292);
	angles[16] = (0, -170, 0);
	at[16] = 5.3500;
	points[17] = (-1445.1772, 11140.8262, 3379.4292);
	angles[17] = (0, -170, 0);
	at[17] = 7.6000;
	points[18] = (-1445.1772, 11140.8262, 3403.8113);
	angles[18] = (0, -170, 0);
	at[18] = 7.6500;
	points[19] = (-1445.1772, 11140.8262, 3473.7402);
	angles[19] = (0, -170, 0);
	at[19] = 7.7000;
	points[20] = (-1445.1772, 11140.8262, 3538.8467);
	angles[20] = (0, -170, 0);
	at[20] = 7.7500;
	points[21] = (-1445.1772, 11140.8262, 3599.1260);
	angles[21] = (0, -170, 0);
	at[21] = 7.8000;
	points[22] = (-1445.1772, 11140.8262, 3654.5867);
	angles[22] = (0, -170, 0);
	at[22] = 7.8500;
	points[23] = (-1445.1772, 11140.8262, 3705.2246);
	angles[23] = (0, -170, 0);
	at[23] = 7.9000;
	points[24] = (-1445.1772, 11140.8262, 3751.0393);
	angles[24] = (0, -170, 0);
	at[24] = 7.9500;
	points[25] = (-1445.1772, 11140.8262, 3792.0315);
	angles[25] = (0, -170, 0);
	at[25] = 8;
	points[26] = (-1445.1772, 11140.8262, 3828.2046);
	angles[26] = (0, -170, 0);
	at[26] = 8.0500;
	points[27] = (-1445.1772, 11140.8262, 3859.5513);
	angles[27] = (0, -170, 0);
	at[27] = 8.1000;
	points[28] = (-1445.1772, 11140.8262, 3886.0747);
	angles[28] = (0, -170, 0);
	at[28] = 8.1500;
	points[29] = (-1445.1772, 11140.8262, 3907.7756);
	angles[29] = (0, -170, 0);
	at[29] = 8.2000;
	points[30] = (-1445.1772, 11140.8262, 3924.6577);
	angles[30] = (0, -170, 0);
	at[30] = 8.2500;
	points[31] = (-1445.1772, 11140.8262, 3936.7126);
	angles[31] = (0, -170, 0);
	at[31] = 8.3000;
	points[32] = (-1445.1772, 11140.8262, 3943.9373);
	angles[32] = (0, -170, 0);
	at[32] = 8.3500;
	points[33] = (-1445.1772, 11140.8262, 3946.3386);
	angles[33] = (0, -170, 0);
	at[33] = 8.4000;
	points[34] = (-1445.1772, 11140.8262, 3960.3938);
	angles[34] = (0, -170, 0);
	at[34] = 8.5000;
	points[35] = (-1445.1772, 11140.8262, 3960.3938);
	angles[35] = (0, -170, 0);
	at[35] = 8.5500;
	points[36] = (-1445.1772, 11140.8262, 3955.0393);
	angles[36] = (0, -170, 0);
	at[36] = 8.6000;
	points[37] = (-1445.1772, 11140.8262, 3937.6772);
	angles[37] = (0, -170, 0);
	at[37] = 8.7000;
	points[38] = (-1445.1772, 11140.8262, 3932.3188);
	angles[38] = (0, -170, 0);
	at[38] = 8.7500;
	points[39] = (-1445.1772, 11140.8262, 3932.3188);
	angles[39] = (0, -170, 0);
	at[39] = 8.8000;
	points[40] = (-1445.1772, 11140.8262, 3937.6772);
	angles[40] = (0, -170, 0);
	at[40] = 8.8500;
	points[41] = (-1445.1772, 11140.8262, 3955.0393);
	angles[41] = (0, -170, 0);
	at[41] = 8.9500;
	points[42] = (-1445.1772, 11140.8262, 3960.3938);
	angles[42] = (0, -170, 0);
	at[42] = 9;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-680.6339, 11703.7402, 3942.9136);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-680.6339, 11703.7402, 3946.1418);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (-680.6339, 11703.7402, 3959.1338);
	angles[2] = (0, -170, 0);
	at[2] = 0.1500;
	points[3] = (-680.6339, 11703.7402, 3961.0237);
	angles[3] = (0, -170, 0);
	at[3] = 0.2000;
	points[4] = (-680.6339, 11703.7402, 3957.3228);
	angles[4] = (0, -170, 0);
	at[4] = 0.2500;
	points[5] = (-680.6339, 11703.7402, 3933.5708);
	angles[5] = (0, -170, 0);
	at[5] = 0.4000;
	points[6] = (-680.6339, 11703.7402, 3931.6733);
	angles[6] = (0, -170, 0);
	at[6] = 0.4500;
	points[7] = (-680.6339, 11703.7402, 3935.3821);
	angles[7] = (0, -170, 0);
	at[7] = 0.5000;
	points[8] = (-680.6339, 11703.7402, 3959.1338);
	angles[8] = (0, -170, 0);
	at[8] = 0.6500;
	points[9] = (-680.6339, 11703.7402, 3961.0237);
	angles[9] = (0, -170, 0);
	at[9] = 0.7000;
	points[10] = (-680.6339, 11703.7402, 3957.3228);
	angles[10] = (0, -170, 0);
	at[10] = 0.7500;
	points[11] = (-680.6339, 11703.7402, 3933.5708);
	angles[11] = (0, -170, 0);
	at[11] = 0.9000;
	points[12] = (-680.6339, 11703.7402, 3931.6733);
	angles[12] = (0, -170, 0);
	at[12] = 0.9500;
	points[13] = (-680.6339, 11703.7402, 3935.3821);
	angles[13] = (0, -170, 0);
	at[13] = 1;
	points[14] = (-680.6339, 11703.7402, 3959.1338);
	angles[14] = (0, -170, 0);
	at[14] = 1.1500;
	points[15] = (-680.6339, 11703.7402, 3961.0237);
	angles[15] = (0, -170, 0);
	at[15] = 1.2000;
	points[16] = (-680.6339, 11703.7402, 3957.3228);
	angles[16] = (0, -170, 0);
	at[16] = 1.2500;
	points[17] = (-680.6339, 11703.7402, 3943.2676);
	angles[17] = (0, -170, 0);
	at[17] = 1.3500;
	points[18] = (-680.6339, 11703.7402, 3412.9448);
	angles[18] = (0, -170, 0);
	at[18] = 2.8500;
	points[19] = (-680.6339, 11703.7402, 3404.2283);
	angles[19] = (0, -170, 0);
	at[19] = 2.9000;
	points[20] = (-680.6339, 11703.7402, 3404.2283);
	angles[20] = (0, -170, 0);
	at[20] = 5.9500;
	points[21] = (-680.6339, 11703.7402, 3492.8110);
	angles[21] = (0, -170, 0);
	at[21] = 6;
	points[22] = (-680.6339, 11703.7402, 3492.8110);
	angles[22] = (0, -170, 0);
	at[22] = 8.3000;
	points[23] = (-680.6339, 11703.7402, 3550.0393);
	angles[23] = (0, -170, 0);
	at[23] = 8.3500;
	points[24] = (-680.6339, 11703.7402, 3652.9253);
	angles[24] = (0, -170, 0);
	at[24] = 8.4500;
	points[25] = (-680.6339, 11703.7402, 3740.3740);
	angles[25] = (0, -170, 0);
	at[25] = 8.5500;
	points[26] = (-680.6339, 11703.7402, 3812.3938);
	angles[26] = (0, -170, 0);
	at[26] = 8.6500;
	points[27] = (-680.6339, 11703.7402, 3842.6143);
	angles[27] = (0, -170, 0);
	at[27] = 8.7000;
	points[28] = (-680.6339, 11703.7402, 3891.4841);
	angles[28] = (0, -170, 0);
	at[28] = 8.8000;
	points[29] = (-680.6339, 11703.7402, 3924.9214);
	angles[29] = (0, -170, 0);
	at[29] = 8.9000;
	points[30] = (-680.6339, 11703.7402, 3942.9136);
	angles[30] = (0, -170, 0);
	at[30] = 9;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1555.0354, 12106.5361, 3492.8149);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (-1555.0354, 12106.5361, 3492.8149);
	angles[1] = (0, -170, 0);
	at[1] = 0.6000;
	points[2] = (-1555.0354, 12106.5361, 3512.3188);
	angles[2] = (0, -170, 0);
	at[2] = 0.6500;
	points[3] = (-1555.0354, 12106.5361, 3568.2639);
	angles[3] = (0, -170, 0);
	at[3] = 0.7000;
	points[4] = (-1555.0354, 12106.5361, 3668.5750);
	angles[4] = (0, -170, 0);
	at[4] = 0.8000;
	points[5] = (-1555.0354, 12106.5361, 3753.4529);
	angles[5] = (0, -170, 0);
	at[5] = 0.9000;
	points[6] = (-1555.0354, 12106.5361, 3790.1064);
	angles[6] = (0, -170, 0);
	at[6] = 0.9500;
	points[7] = (-1555.0354, 12106.5361, 3851.8347);
	angles[7] = (0, -170, 0);
	at[7] = 1.0500;
	points[8] = (-1555.0354, 12106.5361, 3898.1299);
	angles[8] = (0, -170, 0);
	at[8] = 1.1500;
	points[9] = (-1555.0354, 12106.5361, 3928.9961);
	angles[9] = (0, -170, 0);
	at[9] = 1.2500;
	points[10] = (-1555.0354, 12106.5361, 3938.6614);
	angles[10] = (0, -170, 0);
	at[10] = 1.3000;
	points[11] = (-1555.0354, 12106.5361, 3946.3386);
	angles[11] = (0, -170, 0);
	at[11] = 1.4000;
	points[12] = (-1555.0354, 12106.5361, 3960.3938);
	angles[12] = (0, -170, 0);
	at[12] = 1.5000;
	points[13] = (-1555.0354, 12106.5361, 3960.3938);
	angles[13] = (0, -170, 0);
	at[13] = 1.5500;
	points[14] = (-1555.0354, 12106.5361, 3955.0393);
	angles[14] = (0, -170, 0);
	at[14] = 1.6000;
	points[15] = (-1555.0354, 12106.5361, 3937.6772);
	angles[15] = (0, -170, 0);
	at[15] = 1.7000;
	points[16] = (-1555.0354, 12106.5361, 3932.3188);
	angles[16] = (0, -170, 0);
	at[16] = 1.7500;
	points[17] = (-1555.0354, 12106.5361, 3932.3188);
	angles[17] = (0, -170, 0);
	at[17] = 1.8000;
	points[18] = (-1555.0354, 12106.5361, 3937.6772);
	angles[18] = (0, -170, 0);
	at[18] = 1.8500;
	points[19] = (-1555.0354, 12106.5361, 3955.0393);
	angles[19] = (0, -170, 0);
	at[19] = 1.9500;
	points[20] = (-1555.0354, 12106.5361, 3960.3938);
	angles[20] = (0, -170, 0);
	at[20] = 2;
	points[21] = (-1555.0354, 12106.5361, 3960.3938);
	angles[21] = (0, -170, 0);
	at[21] = 2.0500;
	points[22] = (-1555.0354, 12106.5361, 3955.0393);
	angles[22] = (0, -170, 0);
	at[22] = 2.1000;
	points[23] = (-1555.0354, 12106.5361, 3937.6772);
	angles[23] = (0, -170, 0);
	at[23] = 2.2000;
	points[24] = (-1555.0354, 12106.5361, 3932.3188);
	angles[24] = (0, -170, 0);
	at[24] = 2.2500;
	points[25] = (-1555.0354, 12106.5361, 3932.3188);
	angles[25] = (0, -170, 0);
	at[25] = 2.3000;
	points[26] = (-1555.0354, 12106.5361, 3937.6772);
	angles[26] = (0, -170, 0);
	at[26] = 2.3500;
	points[27] = (-1555.0354, 12106.5361, 3955.0393);
	angles[27] = (0, -170, 0);
	at[27] = 2.4500;
	points[28] = (-1555.0354, 12106.5361, 3960.3938);
	angles[28] = (0, -170, 0);
	at[28] = 2.5000;
	points[29] = (-1555.0354, 12106.5361, 3960.3938);
	angles[29] = (0, -170, 0);
	at[29] = 2.5500;
	points[30] = (-1555.0354, 12106.5361, 3955.0393);
	angles[30] = (0, -170, 0);
	at[30] = 2.6000;
	points[31] = (-1555.0354, 12106.5361, 3937.4016);
	angles[31] = (0, -170, 0);
	at[31] = 2.7000;
	points[32] = (-1555.0354, 12106.5361, 3407.0552);
	angles[32] = (0, -170, 0);
	at[32] = 4.2000;
	points[33] = (-1555.0354, 12106.5361, 3404.2322);
	angles[33] = (0, -170, 0);
	at[33] = 4.2500;
	points[34] = (-1555.0354, 12106.5361, 3404.2322);
	angles[34] = (0, -170, 0);
	at[34] = 7.3000;
	points[35] = (-1555.0354, 12106.5361, 3492.8149);
	angles[35] = (0, -170, 0);
	at[35] = 7.3500;
	points[36] = (-1555.0354, 12106.5361, 3492.8149);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (11196.8105, 7337.8345, 537.4016);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (11196.8105, 7337.8345, 537.4016);
	angles[1] = (0, -170, 0);
	at[1] = 0.6000;
	points[2] = (11196.8105, 7337.8345, 634.9252);
	angles[2] = (0, -170, 0);
	at[2] = 0.6500;
	points[3] = (11196.8105, 7337.8345, 914.6378);
	angles[3] = (0, -170, 0);
	at[3] = 0.7000;
	points[4] = (11196.8105, 7337.8345, 1175.0630);
	angles[4] = (0, -170, 0);
	at[4] = 0.7500;
	points[5] = (11196.8105, 7337.8345, 1416.1969);
	angles[5] = (0, -170, 0);
	at[5] = 0.8000;
	points[6] = (11196.8105, 7337.8345, 1638.0354);
	angles[6] = (0, -170, 0);
	at[6] = 0.8500;
	points[7] = (11196.8105, 7337.8345, 1840.5867);
	angles[7] = (0, -170, 0);
	at[7] = 0.9000;
	points[8] = (11196.8105, 7337.8345, 2023.8505);
	angles[8] = (0, -170, 0);
	at[8] = 0.9500;
	points[9] = (11196.8105, 7337.8345, 2187.8188);
	angles[9] = (0, -170, 0);
	at[9] = 1;
	points[10] = (11196.8105, 7337.8345, 2332.5000);
	angles[10] = (0, -170, 0);
	at[10] = 1.0500;
	points[11] = (11196.8105, 7337.8345, 2457.8860);
	angles[11] = (0, -170, 0);
	at[11] = 1.1000;
	points[12] = (11196.8105, 7337.8345, 2563.9841);
	angles[12] = (0, -170, 0);
	at[12] = 1.1500;
	points[13] = (11196.8105, 7337.8345, 2650.7915);
	angles[13] = (0, -170, 0);
	at[13] = 1.2000;
	points[14] = (11196.8105, 7337.8345, 2718.3110);
	angles[14] = (0, -170, 0);
	at[14] = 1.2500;
	points[15] = (11196.8105, 7337.8345, 2766.5354);
	angles[15] = (0, -170, 0);
	at[15] = 1.3000;
	points[16] = (11196.8105, 7337.8345, 2795.4724);
	angles[16] = (0, -170, 0);
	at[16] = 1.3500;
	points[17] = (11196.8105, 7337.8345, 2813.7952);
	angles[17] = (0, -170, 0);
	at[17] = 1.4500;
	points[18] = (11196.8105, 7337.8345, 2819.1575);
	angles[18] = (0, -170, 0);
	at[18] = 1.5000;
	points[19] = (11196.8105, 7337.8345, 2819.1575);
	angles[19] = (0, -170, 0);
	at[19] = 1.5500;
	points[20] = (11196.8105, 7337.8345, 2813.7952);
	angles[20] = (0, -170, 0);
	at[20] = 1.6000;
	points[21] = (11196.8105, 7337.8345, 2796.4412);
	angles[21] = (0, -170, 0);
	at[21] = 1.7000;
	points[22] = (11196.8105, 7337.8345, 2791.0789);
	angles[22] = (0, -170, 0);
	at[22] = 1.7500;
	points[23] = (11196.8105, 7337.8345, 2791.0789);
	angles[23] = (0, -170, 0);
	at[23] = 1.8000;
	points[24] = (11196.8105, 7337.8345, 2796.4412);
	angles[24] = (0, -170, 0);
	at[24] = 1.8500;
	points[25] = (11196.8105, 7337.8345, 2813.7952);
	angles[25] = (0, -170, 0);
	at[25] = 1.9500;
	points[26] = (11196.8105, 7337.8345, 2819.1575);
	angles[26] = (0, -170, 0);
	at[26] = 2;
	points[27] = (11196.8105, 7337.8345, 2819.1575);
	angles[27] = (0, -170, 0);
	at[27] = 2.0500;
	points[28] = (11196.8105, 7337.8345, 2813.7952);
	angles[28] = (0, -170, 0);
	at[28] = 2.1000;
	points[29] = (11196.8105, 7337.8345, 2796.4412);
	angles[29] = (0, -170, 0);
	at[29] = 2.2000;
	points[30] = (11196.8105, 7337.8345, 2791.0789);
	angles[30] = (0, -170, 0);
	at[30] = 2.2500;
	points[31] = (11196.8105, 7337.8345, 2791.0789);
	angles[31] = (0, -170, 0);
	at[31] = 2.3000;
	points[32] = (11196.8105, 7337.8345, 2796.4412);
	angles[32] = (0, -170, 0);
	at[32] = 2.3500;
	points[33] = (11196.8105, 7337.8345, 2813.7952);
	angles[33] = (0, -170, 0);
	at[33] = 2.4500;
	points[34] = (11196.8105, 7337.8345, 2819.1575);
	angles[34] = (0, -170, 0);
	at[34] = 2.5000;
	points[35] = (11196.8105, 7337.8345, 2819.1575);
	angles[35] = (0, -170, 0);
	at[35] = 2.5500;
	points[36] = (11196.8105, 7337.8345, 2805.1182);
	angles[36] = (0, -170, 0);
	at[36] = 2.6500;
	points[37] = (11196.8105, 7337.8345, 2776.4370);
	angles[37] = (0, -170, 0);
	at[37] = 2.7000;
	points[38] = (11196.8105, 7337.8345, 471.3622);
	angles[38] = (0, -170, 0);
	at[38] = 4.2000;
	points[39] = (11196.8105, 7337.8345, 448.8189);
	angles[39] = (0, -170, 0);
	at[39] = 4.2500;
	points[40] = (11196.8105, 7337.8345, 448.8189);
	angles[40] = (0, -170, 0);
	at[40] = 7.3000;
	points[41] = (11196.8105, 7337.8345, 537.4016);
	angles[41] = (0, -170, 0);
	at[41] = 7.3500;
	points[42] = (11196.8105, 7337.8345, 537.4016);
	angles[42] = (0, -170, 0);
	at[42] = 9;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (9209.0156, 8884.2520, 778.7048);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (9209.0156, 8884.2520, 471.3622);
	angles[1] = (0, -170, 0);
	at[1] = 0.2000;
	points[2] = (9209.0156, 8884.2520, 448.8189);
	angles[2] = (0, -170, 0);
	at[2] = 0.2500;
	points[3] = (9209.0156, 8884.2520, 448.8189);
	angles[3] = (0, -170, 0);
	at[3] = 3.3000;
	points[4] = (9209.0156, 8884.2520, 537.4016);
	angles[4] = (0, -170, 0);
	at[4] = 3.3500;
	points[5] = (9209.0156, 8884.2520, 537.4016);
	angles[5] = (0, -170, 0);
	at[5] = 5.6000;
	points[6] = (9209.0156, 8884.2520, 634.9252);
	angles[6] = (0, -170, 0);
	at[6] = 5.6500;
	points[7] = (9209.0156, 8884.2520, 914.6378);
	angles[7] = (0, -170, 0);
	at[7] = 5.7000;
	points[8] = (9209.0156, 8884.2520, 1175.0630);
	angles[8] = (0, -170, 0);
	at[8] = 5.7500;
	points[9] = (9209.0156, 8884.2520, 1416.1969);
	angles[9] = (0, -170, 0);
	at[9] = 5.8000;
	points[10] = (9209.0156, 8884.2520, 1638.0354);
	angles[10] = (0, -170, 0);
	at[10] = 5.8500;
	points[11] = (9209.0156, 8884.2520, 1840.5867);
	angles[11] = (0, -170, 0);
	at[11] = 5.9000;
	points[12] = (9209.0156, 8884.2520, 2023.8505);
	angles[12] = (0, -170, 0);
	at[12] = 5.9500;
	points[13] = (9209.0156, 8884.2520, 2187.8188);
	angles[13] = (0, -170, 0);
	at[13] = 6;
	points[14] = (9209.0156, 8884.2520, 2332.5000);
	angles[14] = (0, -170, 0);
	at[14] = 6.0500;
	points[15] = (9209.0156, 8884.2520, 2457.8860);
	angles[15] = (0, -170, 0);
	at[15] = 6.1000;
	points[16] = (9209.0156, 8884.2520, 2563.9841);
	angles[16] = (0, -170, 0);
	at[16] = 6.1500;
	points[17] = (9209.0156, 8884.2520, 2650.7915);
	angles[17] = (0, -170, 0);
	at[17] = 6.2000;
	points[18] = (9209.0156, 8884.2520, 2718.3110);
	angles[18] = (0, -170, 0);
	at[18] = 6.2500;
	points[19] = (9209.0156, 8884.2520, 2766.5354);
	angles[19] = (0, -170, 0);
	at[19] = 6.3000;
	points[20] = (9209.0156, 8884.2520, 2795.4724);
	angles[20] = (0, -170, 0);
	at[20] = 6.3500;
	points[21] = (9209.0156, 8884.2520, 2813.7952);
	angles[21] = (0, -170, 0);
	at[21] = 6.4500;
	points[22] = (9209.0156, 8884.2520, 2819.1575);
	angles[22] = (0, -170, 0);
	at[22] = 6.5000;
	points[23] = (9209.0156, 8884.2520, 2819.1575);
	angles[23] = (0, -170, 0);
	at[23] = 6.5500;
	points[24] = (9209.0156, 8884.2520, 2813.7952);
	angles[24] = (0, -170, 0);
	at[24] = 6.6000;
	points[25] = (9209.0156, 8884.2520, 2796.4412);
	angles[25] = (0, -170, 0);
	at[25] = 6.7000;
	points[26] = (9209.0156, 8884.2520, 2791.0789);
	angles[26] = (0, -170, 0);
	at[26] = 6.7500;
	points[27] = (9209.0156, 8884.2520, 2791.0789);
	angles[27] = (0, -170, 0);
	at[27] = 6.8000;
	points[28] = (9209.0156, 8884.2520, 2796.4412);
	angles[28] = (0, -170, 0);
	at[28] = 6.8500;
	points[29] = (9209.0156, 8884.2520, 2813.7952);
	angles[29] = (0, -170, 0);
	at[29] = 6.9500;
	points[30] = (9209.0156, 8884.2520, 2819.1575);
	angles[30] = (0, -170, 0);
	at[30] = 7;
	points[31] = (9209.0156, 8884.2520, 2819.1575);
	angles[31] = (0, -170, 0);
	at[31] = 7.0500;
	points[32] = (9209.0156, 8884.2520, 2813.7952);
	angles[32] = (0, -170, 0);
	at[32] = 7.1000;
	points[33] = (9209.0156, 8884.2520, 2796.4412);
	angles[33] = (0, -170, 0);
	at[33] = 7.2000;
	points[34] = (9209.0156, 8884.2520, 2791.0789);
	angles[34] = (0, -170, 0);
	at[34] = 7.2500;
	points[35] = (9209.0156, 8884.2520, 2791.0789);
	angles[35] = (0, -170, 0);
	at[35] = 7.3000;
	points[36] = (9209.0156, 8884.2520, 2796.4412);
	angles[36] = (0, -170, 0);
	at[36] = 7.3500;
	points[37] = (9209.0156, 8884.2520, 2813.7952);
	angles[37] = (0, -170, 0);
	at[37] = 7.4500;
	points[38] = (9209.0156, 8884.2520, 2819.1575);
	angles[38] = (0, -170, 0);
	at[38] = 7.5000;
	points[39] = (9209.0156, 8884.2520, 2819.1575);
	angles[39] = (0, -170, 0);
	at[39] = 7.5500;
	points[40] = (9209.0156, 8884.2520, 2805.1182);
	angles[40] = (0, -170, 0);
	at[40] = 7.6500;
	points[41] = (9209.0156, 8884.2520, 2776.4370);
	angles[41] = (0, -170, 0);
	at[41] = 7.7000;
	points[42] = (9209.0156, 8884.2520, 778.7048);
	angles[42] = (0, -170, 0);
	at[42] = 9;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (16832.2832, 8502.1660, 2787.9724);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (16832.2832, 8502.1660, 2804.0474);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (16832.2832, 8502.1660, 2817.9055);
	angles[2] = (0, -170, 0);
	at[2] = 0.1500;
	points[3] = (16832.2832, 8502.1660, 2819.7993);
	angles[3] = (0, -170, 0);
	at[3] = 0.2000;
	points[4] = (16832.2832, 8502.1660, 2816.0906);
	angles[4] = (0, -170, 0);
	at[4] = 0.2500;
	points[5] = (16832.2832, 8502.1660, 2792.3308);
	angles[5] = (0, -170, 0);
	at[5] = 0.4000;
	points[6] = (16832.2832, 8502.1660, 2790.4370);
	angles[6] = (0, -170, 0);
	at[6] = 0.4500;
	points[7] = (16832.2832, 8502.1660, 2794.1458);
	angles[7] = (0, -170, 0);
	at[7] = 0.5000;
	points[8] = (16832.2832, 8502.1660, 2817.9055);
	angles[8] = (0, -170, 0);
	at[8] = 0.6500;
	points[9] = (16832.2832, 8502.1660, 2819.7993);
	angles[9] = (0, -170, 0);
	at[9] = 0.7000;
	points[10] = (16832.2832, 8502.1660, 2816.0906);
	angles[10] = (0, -170, 0);
	at[10] = 0.7500;
	points[11] = (16832.2832, 8502.1660, 2792.3308);
	angles[11] = (0, -170, 0);
	at[11] = 0.9000;
	points[12] = (16832.2832, 8502.1660, 2790.4370);
	angles[12] = (0, -170, 0);
	at[12] = 0.9500;
	points[13] = (16832.2832, 8502.1660, 2794.1458);
	angles[13] = (0, -170, 0);
	at[13] = 1;
	points[14] = (16832.2832, 8502.1660, 2817.9055);
	angles[14] = (0, -170, 0);
	at[14] = 1.1500;
	points[15] = (16832.2832, 8502.1660, 2819.7993);
	angles[15] = (0, -170, 0);
	at[15] = 1.2000;
	points[16] = (16832.2832, 8502.1660, 2816.0906);
	angles[16] = (0, -170, 0);
	at[16] = 1.2500;
	points[17] = (16832.2832, 8502.1660, 2802.0471);
	angles[17] = (0, -170, 0);
	at[17] = 1.3500;
	points[18] = (16832.2832, 8502.1660, 496.9725);
	angles[18] = (0, -170, 0);
	at[18] = 2.8500;
	points[19] = (16832.2832, 8502.1660, 448.8189);
	angles[19] = (0, -170, 0);
	at[19] = 2.9000;
	points[20] = (16832.2832, 8502.1660, 448.8189);
	angles[20] = (0, -170, 0);
	at[20] = 5.9500;
	points[21] = (16832.2832, 8502.1660, 537.4016);
	angles[21] = (0, -170, 0);
	at[21] = 6;
	points[22] = (16832.2832, 8502.1660, 537.4016);
	angles[22] = (0, -170, 0);
	at[22] = 8.3000;
	points[23] = (16832.2832, 8502.1660, 823.5472);
	angles[23] = (0, -170, 0);
	at[23] = 8.3500;
	points[24] = (16832.2832, 8502.1660, 1090.3977);
	angles[24] = (0, -170, 0);
	at[24] = 8.4000;
	points[25] = (16832.2832, 8502.1660, 1337.9606);
	angles[25] = (0, -170, 0);
	at[25] = 8.4500;
	points[26] = (16832.2832, 8502.1660, 1566.2323);
	angles[26] = (0, -170, 0);
	at[26] = 8.5000;
	points[27] = (16832.2832, 8502.1660, 1775.2166);
	angles[27] = (0, -170, 0);
	at[27] = 8.5500;
	points[28] = (16832.2832, 8502.1660, 1964.9055);
	angles[28] = (0, -170, 0);
	at[28] = 8.6000;
	points[29] = (16832.2832, 8502.1660, 2135.3071);
	angles[29] = (0, -170, 0);
	at[29] = 8.6500;
	points[30] = (16832.2832, 8502.1660, 2286.4175);
	angles[30] = (0, -170, 0);
	at[30] = 8.7000;
	points[31] = (16832.2832, 8502.1660, 2418.2361);
	angles[31] = (0, -170, 0);
	at[31] = 8.7500;
	points[32] = (16832.2832, 8502.1660, 2530.7639);
	angles[32] = (0, -170, 0);
	at[32] = 8.8000;
	points[33] = (16832.2832, 8502.1660, 2624);
	angles[33] = (0, -170, 0);
	at[33] = 8.8500;
	points[34] = (16832.2832, 8502.1660, 2697.9490);
	angles[34] = (0, -170, 0);
	at[34] = 8.9000;
	points[35] = (16832.2832, 8502.1660, 2752.6062);
	angles[35] = (0, -170, 0);
	at[35] = 8.9500;
	points[36] = (16832.2832, 8502.1660, 2787.9724);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (11421.5752, 9535.0791, 2787.9724);
	angles[0] = (0, -170, 0);
	at[0] = 0;
	points[1] = (11421.5752, 9535.0791, 2804.0474);
	angles[1] = (0, -170, 0);
	at[1] = 0.0500;
	points[2] = (11421.5752, 9535.0791, 2817.9055);
	angles[2] = (0, -170, 0);
	at[2] = 0.1500;
	points[3] = (11421.5752, 9535.0791, 2819.7993);
	angles[3] = (0, -170, 0);
	at[3] = 0.2000;
	points[4] = (11421.5752, 9535.0791, 2816.0906);
	angles[4] = (0, -170, 0);
	at[4] = 0.2500;
	points[5] = (11421.5752, 9535.0791, 2792.3308);
	angles[5] = (0, -170, 0);
	at[5] = 0.4000;
	points[6] = (11421.5752, 9535.0791, 2790.4370);
	angles[6] = (0, -170, 0);
	at[6] = 0.4500;
	points[7] = (11421.5752, 9535.0791, 2794.1458);
	angles[7] = (0, -170, 0);
	at[7] = 0.5000;
	points[8] = (11421.5752, 9535.0791, 2817.9055);
	angles[8] = (0, -170, 0);
	at[8] = 0.6500;
	points[9] = (11421.5752, 9535.0791, 2819.7993);
	angles[9] = (0, -170, 0);
	at[9] = 0.7000;
	points[10] = (11421.5752, 9535.0791, 2816.0906);
	angles[10] = (0, -170, 0);
	at[10] = 0.7500;
	points[11] = (11421.5752, 9535.0791, 2792.3308);
	angles[11] = (0, -170, 0);
	at[11] = 0.9000;
	points[12] = (11421.5752, 9535.0791, 2790.4370);
	angles[12] = (0, -170, 0);
	at[12] = 0.9500;
	points[13] = (11421.5752, 9535.0791, 2794.1458);
	angles[13] = (0, -170, 0);
	at[13] = 1;
	points[14] = (11421.5752, 9535.0791, 2817.9055);
	angles[14] = (0, -170, 0);
	at[14] = 1.1500;
	points[15] = (11421.5752, 9535.0791, 2819.7993);
	angles[15] = (0, -170, 0);
	at[15] = 1.2000;
	points[16] = (11421.5752, 9535.0791, 2816.0906);
	angles[16] = (0, -170, 0);
	at[16] = 1.2500;
	points[17] = (11421.5752, 9535.0791, 2802.0471);
	angles[17] = (0, -170, 0);
	at[17] = 1.3500;
	points[18] = (11421.5752, 9535.0791, 496.9725);
	angles[18] = (0, -170, 0);
	at[18] = 2.8500;
	points[19] = (11421.5752, 9535.0791, 448.8189);
	angles[19] = (0, -170, 0);
	at[19] = 2.9000;
	points[20] = (11421.5752, 9535.0791, 448.8189);
	angles[20] = (0, -170, 0);
	at[20] = 5.9500;
	points[21] = (11421.5752, 9535.0791, 537.4016);
	angles[21] = (0, -170, 0);
	at[21] = 6;
	points[22] = (11421.5752, 9535.0791, 537.4016);
	angles[22] = (0, -170, 0);
	at[22] = 8.3000;
	points[23] = (11421.5752, 9535.0791, 823.5472);
	angles[23] = (0, -170, 0);
	at[23] = 8.3500;
	points[24] = (11421.5752, 9535.0791, 1090.3977);
	angles[24] = (0, -170, 0);
	at[24] = 8.4000;
	points[25] = (11421.5752, 9535.0791, 1337.9606);
	angles[25] = (0, -170, 0);
	at[25] = 8.4500;
	points[26] = (11421.5752, 9535.0791, 1566.2323);
	angles[26] = (0, -170, 0);
	at[26] = 8.5000;
	points[27] = (11421.5752, 9535.0791, 1775.2166);
	angles[27] = (0, -170, 0);
	at[27] = 8.5500;
	points[28] = (11421.5752, 9535.0791, 1964.9055);
	angles[28] = (0, -170, 0);
	at[28] = 8.6000;
	points[29] = (11421.5752, 9535.0791, 2135.3071);
	angles[29] = (0, -170, 0);
	at[29] = 8.6500;
	points[30] = (11421.5752, 9535.0791, 2286.4175);
	angles[30] = (0, -170, 0);
	at[30] = 8.7000;
	points[31] = (11421.5752, 9535.0791, 2418.2361);
	angles[31] = (0, -170, 0);
	at[31] = 8.7500;
	points[32] = (11421.5752, 9535.0791, 2530.7639);
	angles[32] = (0, -170, 0);
	at[32] = 8.8000;
	points[33] = (11421.5752, 9535.0791, 2624);
	angles[33] = (0, -170, 0);
	at[33] = 8.8500;
	points[34] = (11421.5752, 9535.0791, 2697.9490);
	angles[34] = (0, -170, 0);
	at[34] = 8.9000;
	points[35] = (11421.5752, 9535.0791, 2752.6062);
	angles[35] = (0, -170, 0);
	at[35] = 8.9500;
	points[36] = (11421.5752, 9535.0791, 2787.9724);
	angles[36] = (0, -170, 0);
	at[36] = 9;
	mover = getEnt("iz_obj_21", "targetname");
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
