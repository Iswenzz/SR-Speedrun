main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_wario_stadium", 0);

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
	ambientPlay("iz_0_28", 2);
	level thread iz_music("iz_7_se_cr_gcw_env_aud");
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
	level.iz_route[level.iz_route.size] = (-5789, 787, 649);
	level.iz_route[level.iz_route.size] = (-5786, 327, 649);
	level.iz_route[level.iz_route.size] = (-5797, -516, 667);
	level.iz_route[level.iz_route.size] = (-5794, -1473, 650);
	level.iz_route[level.iz_route.size] = (-5791, -2493, 663);
	level.iz_route[level.iz_route.size] = (-5785, -3469, 658);
	level.iz_route[level.iz_route.size] = (-5784, -4585, 682);
	level.iz_route[level.iz_route.size] = (-5786, -5680, 702);
	level.iz_route[level.iz_route.size] = (-5770, -6663, 750);
	level.iz_route[level.iz_route.size] = (-5647, -7371, 757);
	level.iz_route[level.iz_route.size] = (-5357, -8277, 811);
	level.iz_route[level.iz_route.size] = (-4496, -9081, 863);
	level.iz_route[level.iz_route.size] = (-2658, -9490, 910);
	level.iz_route[level.iz_route.size] = (-890, -9542, 961);
	level.iz_route[level.iz_route.size] = (1107, -9618, 940);
	level.iz_route[level.iz_route.size] = (3013, -9538, 921);
	level.iz_route[level.iz_route.size] = (4720, -9333, 889);
	level.iz_route[level.iz_route.size] = (6001, -8403, 807);
	level.iz_route[level.iz_route.size] = (6587, -6881, 743);
	level.iz_route[level.iz_route.size] = (6597, -5026, 672);
	level.iz_route[level.iz_route.size] = (6583, -4024, 650);
	level.iz_route[level.iz_route.size] = (6209, -3327, 649);
	level.iz_route[level.iz_route.size] = (5855, -3008, 675);
	level.iz_route[level.iz_route.size] = (5492, -2791, 702);
	level.iz_route[level.iz_route.size] = (5164, -2626, 720);
	level.iz_route[level.iz_route.size] = (4660, -2287, 742);
	level.iz_route[level.iz_route.size] = (4374, -1263, 682);
	level.iz_route[level.iz_route.size] = (4356, -783, 696);
	level.iz_route[level.iz_route.size] = (4340, -273, 737);
	level.iz_route[level.iz_route.size] = (4244, 531, 841);
	level.iz_route[level.iz_route.size] = (4004, 975, 929);
	level.iz_route[level.iz_route.size] = (3569, 1107, 955);
	level.iz_route[level.iz_route.size] = (3183, 1138, 960);
	level.iz_route[level.iz_route.size] = (2637, 1086, 949);
	level.iz_route[level.iz_route.size] = (1912, 719, 879);
	level.iz_route[level.iz_route.size] = (1608, -88, 815);
	level.iz_route[level.iz_route.size] = (1635, -1151, 830);
	level.iz_route[level.iz_route.size] = (1595, -2349, 684);
	level.iz_route[level.iz_route.size] = (1895, -3275, 773);
	level.iz_route[level.iz_route.size] = (2576, -3579, 658);
	level.iz_route[level.iz_route.size] = (3673, -3722, 692);
	level.iz_route[level.iz_route.size] = (4797, -3887, 668);
	level.iz_route[level.iz_route.size] = (5550, -4336, 664);
	level.iz_route[level.iz_route.size] = (5608, -5296, 663);
	level.iz_route[level.iz_route.size] = (5479, -6402, 710);
	level.iz_route[level.iz_route.size] = (4853, -7532, 704);
	level.iz_route[level.iz_route.size] = (3815, -8088, 639);
	level.iz_route[level.iz_route.size] = (2670, -8208, 576);
	level.iz_route[level.iz_route.size] = (1451, -8356, 691);
	level.iz_route[level.iz_route.size] = (1061, -8400, 756);
	level.iz_route[level.iz_route.size] = (-146, -8353, 548);
	level.iz_route[level.iz_route.size] = (-1031, -8365, 412);
	level.iz_route[level.iz_route.size] = (-2019, -8348, 471);
	level.iz_route[level.iz_route.size] = (-3087, -8027, 593);
	level.iz_route[level.iz_route.size] = (-3917, -7112, 698);
	level.iz_route[level.iz_route.size] = (-3974, -6147, 643);
	level.iz_route[level.iz_route.size] = (-3925, -4977, 661);
	level.iz_route[level.iz_route.size] = (-4021, -3741, 635);
	level.iz_route[level.iz_route.size] = (-4034, -2723, 665);
	level.iz_route[level.iz_route.size] = (-4106, -1768, 673);
	level.iz_route[level.iz_route.size] = (-4031, -952, 688);
	level.iz_route[level.iz_route.size] = (-3714, -354, 737);
	level.iz_route[level.iz_route.size] = (-3243, 142, 796);
	level.iz_route[level.iz_route.size] = (-2464, 173, 838);
	level.iz_route[level.iz_route.size] = (-1918, -433, 776);
	level.iz_route[level.iz_route.size] = (-1747, -1084, 708);
	level.iz_route[level.iz_route.size] = (-1685, -1965, 713);
	level.iz_route[level.iz_route.size] = (-1535, -2954, 677);
	level.iz_route[level.iz_route.size] = (-1432, -3730, 681);
	level.iz_route[level.iz_route.size] = (-1680, -4955, 692);
	level.iz_route[level.iz_route.size] = (-1706, -5979, 768);
	level.iz_route[level.iz_route.size] = (-1583, -6911, 1014);
	level.iz_route[level.iz_route.size] = (-829, -7381, 1149);
	level.iz_route[level.iz_route.size] = (-302, -7297, 1125);
	level.iz_route[level.iz_route.size] = (170, -6995, 1038);
	level.iz_route[level.iz_route.size] = (330, -5985, 801);
	level.iz_route[level.iz_route.size] = (217, -4305, 685);
	level.iz_route[level.iz_route.size] = (142, -3280, 725);
	level.iz_route[level.iz_route.size] = (150, -2127, 684);
	level.iz_route[level.iz_route.size] = (150, -890, 672);
	level.iz_route[level.iz_route.size] = (176, 115, 607);
	level.iz_route[level.iz_route.size] = (214, 1225, 405);
	level.iz_route[level.iz_route.size] = (195, 2379, 229);
	level.iz_route[level.iz_route.size] = (217, 3865, 354);
	level.iz_route[level.iz_route.size] = (223, 5172, 614);
	level.iz_route[level.iz_route.size] = (251, 6316, 776);
	level.iz_route[level.iz_route.size] = (1086, 7131, 835);
	level.iz_route[level.iz_route.size] = (2369, 7577, 923);
	level.iz_route[level.iz_route.size] = (3891, 7542, 915);
	level.iz_route[level.iz_route.size] = (5385, 6978, 844);
	level.iz_route[level.iz_route.size] = (6461, 5910, 798);
	level.iz_route[level.iz_route.size] = (6689, 4475, 745);
	level.iz_route[level.iz_route.size] = (6409, 3123, 662);
	level.iz_route[level.iz_route.size] = (5686, 2639, 663);
	level.iz_route[level.iz_route.size] = (4808, 2535, 629);
	level.iz_route[level.iz_route.size] = (3757, 2579, 644);
	level.iz_route[level.iz_route.size] = (2697, 2644, 537);
	level.iz_route[level.iz_route.size] = (1681, 2679, 588);
	level.iz_route[level.iz_route.size] = (1132, 2663, 657);
	level.iz_route[level.iz_route.size] = (151, 2655, 909);
	level.iz_route[level.iz_route.size] = (-414, 2667, 865);
	level.iz_route[level.iz_route.size] = (-1098, 2646, 779);
	level.iz_route[level.iz_route.size] = (-1999, 2576, 398);
	level.iz_route[level.iz_route.size] = (-2740, 2500, 536);
	level.iz_route[level.iz_route.size] = (-4012, 2657, 758);
	level.iz_route[level.iz_route.size] = (-4581, 3206, 747);
	level.iz_route[level.iz_route.size] = (-4795, 4010, 722);
	level.iz_route[level.iz_route.size] = (-4635, 4990, 768);
	level.iz_route[level.iz_route.size] = (-3786, 5719, 720);
	level.iz_route[level.iz_route.size] = (-2799, 5739, 623);
	level.iz_route[level.iz_route.size] = (-2136, 5578, 684);
	level.iz_route[level.iz_route.size] = (-1252, 5422, 889);
	level.iz_route[level.iz_route.size] = (-696, 5896, 1041);
	level.iz_route[level.iz_route.size] = (-730, 6890, 1060);
	level.iz_route[level.iz_route.size] = (-1449, 7619, 942);
	level.iz_route[level.iz_route.size] = (-1969, 7717, 955);
	level.iz_route[level.iz_route.size] = (-3121, 7617, 933);
	level.iz_route[level.iz_route.size] = (-4534, 6938, 837);
	level.iz_route[level.iz_route.size] = (-5466, 5740, 761);
	level.iz_route[level.iz_route.size] = (-5735, 4285, 715);
	level.iz_route[level.iz_route.size] = (-5795, 2430, 661);
}
