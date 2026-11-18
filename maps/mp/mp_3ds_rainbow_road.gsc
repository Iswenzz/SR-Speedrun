main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_rainbow_road", 0);

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
	ambientPlay("iz_0_119", 2);
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
	level.iz_route[level.iz_route.size] = (-851, -11591, 3016);
	level.iz_route[level.iz_route.size] = (-2626, -12199, 3054);
	level.iz_route[level.iz_route.size] = (-3190, -12284, 3100);
	level.iz_route[level.iz_route.size] = (-3707, -12216, 3170);
	level.iz_route[level.iz_route.size] = (-4163, -12038, 3263);
	level.iz_route[level.iz_route.size] = (-4546, -11575, 3383);
	level.iz_route[level.iz_route.size] = (-4647, -11270, 3435);
	level.iz_route[level.iz_route.size] = (-4674, -11059, 3464);
	level.iz_route[level.iz_route.size] = (-4725, -10545, 3534);
	level.iz_route[level.iz_route.size] = (-4750, -10249, 3572);
	level.iz_route[level.iz_route.size] = (-4773, -9554, 3662);
	level.iz_route[level.iz_route.size] = (-4905, -8733, 3791);
	level.iz_route[level.iz_route.size] = (-5283, -8275, 3907);
	level.iz_route[level.iz_route.size] = (-5722, -8142, 3993);
	level.iz_route[level.iz_route.size] = (-6288, -8148, 4125);
	level.iz_route[level.iz_route.size] = (-6788, -8332, 4231);
	level.iz_route[level.iz_route.size] = (-7226, -8751, 4331);
	level.iz_route[level.iz_route.size] = (-7772, -9346, 4473);
	level.iz_route[level.iz_route.size] = (-8076, -9555, 4548);
	level.iz_route[level.iz_route.size] = (-8523, -9628, 4649);
	level.iz_route[level.iz_route.size] = (-8909, -9502, 4737);
	level.iz_route[level.iz_route.size] = (-9183, -9254, 4806);
	level.iz_route[level.iz_route.size] = (-9612, -8839, 4920);
	level.iz_route[level.iz_route.size] = (-9814, -8594, 4980);
	level.iz_route[level.iz_route.size] = (-10619, -7541, 5148);
	level.iz_route[level.iz_route.size] = (-10721, -7403, 5223);
	level.iz_route[level.iz_route.size] = (-10932, -7135, 5373);
	level.iz_route[level.iz_route.size] = (-11530, -6473, 5590);
	level.iz_route[level.iz_route.size] = (-11852, -6086, 5833);
	level.iz_route[level.iz_route.size] = (-12041, -5871, 5972);
	level.iz_route[level.iz_route.size] = (-12574, -5251, 6170);
	level.iz_route[level.iz_route.size] = (-12853, -4916, 6387);
	level.iz_route[level.iz_route.size] = (-13034, -4646, 6548);
	level.iz_route[level.iz_route.size] = (-13636, -3765, 6837);
	level.iz_route[level.iz_route.size] = (-14533, -2375, 7405);
	level.iz_route[level.iz_route.size] = (-14877, -1521, 7663);
	level.iz_route[level.iz_route.size] = (-14983, -720, 7822);
	level.iz_route[level.iz_route.size] = (-14804, 13, 7888);
	level.iz_route[level.iz_route.size] = (-14514, 446, 7889);
	level.iz_route[level.iz_route.size] = (-13998, 904, 7650);
	level.iz_route[level.iz_route.size] = (-13387, 1173, 7620);
	level.iz_route[level.iz_route.size] = (-12703, 1165, 7550);
	level.iz_route[level.iz_route.size] = (-11931, 952, 7469);
	level.iz_route[level.iz_route.size] = (-11493, 655, 7404);
	level.iz_route[level.iz_route.size] = (-11048, 100, 7168);
	level.iz_route[level.iz_route.size] = (-10840, -810, 7099);
	level.iz_route[level.iz_route.size] = (-10954, -1457, 7046);
	level.iz_route[level.iz_route.size] = (-11243, -2007, 7002);
	level.iz_route[level.iz_route.size] = (-11531, -2373, 6979);
	level.iz_route[level.iz_route.size] = (-12113, -2789, 6778);
	level.iz_route[level.iz_route.size] = (-12725, -2946, 6758);
	level.iz_route[level.iz_route.size] = (-13218, -2933, 6740);
	level.iz_route[level.iz_route.size] = (-13661, -2752, 6710);
	level.iz_route[level.iz_route.size] = (-14177, -2360, 6668);
	level.iz_route[level.iz_route.size] = (-15057, -1165, 6238);
	level.iz_route[level.iz_route.size] = (-15803, -373, 6157);
	level.iz_route[level.iz_route.size] = (-16326, 15, 6181);
	level.iz_route[level.iz_route.size] = (-16926, 253, 6246);
	level.iz_route[level.iz_route.size] = (-17483, 428, 6316);
	level.iz_route[level.iz_route.size] = (-20686, 538, 6033);
	level.iz_route[level.iz_route.size] = (-22179, 549, 5653);
	level.iz_route[level.iz_route.size] = (-22685, 671, 5663);
	level.iz_route[level.iz_route.size] = (-23195, 1058, 5704);
	level.iz_route[level.iz_route.size] = (-23612, 1699, 5808);
	level.iz_route[level.iz_route.size] = (-24083, 2850, 6087);
	level.iz_route[level.iz_route.size] = (-24661, 4657, 6521);
	level.iz_route[level.iz_route.size] = (-25075, 5694, 6714);
	level.iz_route[level.iz_route.size] = (-25569, 6283, 6850);
	level.iz_route[level.iz_route.size] = (-26042, 6683, 6967);
	level.iz_route[level.iz_route.size] = (-26368, 7199, 7087);
	level.iz_route[level.iz_route.size] = (-26524, 7738, 7188);
	level.iz_route[level.iz_route.size] = (-26598, 8302, 7278);
	level.iz_route[level.iz_route.size] = (-26532, 8758, 7327);
	level.iz_route[level.iz_route.size] = (-26354, 9210, 7373);
	level.iz_route[level.iz_route.size] = (-26127, 9590, 7422);
	level.iz_route[level.iz_route.size] = (-25777, 9785, 7411);
	level.iz_route[level.iz_route.size] = (-25336, 9930, 7377);
	level.iz_route[level.iz_route.size] = (-24558, 10017, 7297);
	level.iz_route[level.iz_route.size] = (-23467, 10073, 7219);
	level.iz_route[level.iz_route.size] = (-21936, 10319, 7095);
	level.iz_route[level.iz_route.size] = (-21139, 10467, 7083);
	level.iz_route[level.iz_route.size] = (-20505, 10570, 7048);
	level.iz_route[level.iz_route.size] = (-19788, 10592, 6795);
	level.iz_route[level.iz_route.size] = (-19183, 10615, 6613);
	level.iz_route[level.iz_route.size] = (-18773, 10633, 6506);
	level.iz_route[level.iz_route.size] = (-17819, 10677, 6026);
	level.iz_route[level.iz_route.size] = (-17219, 10859, 6099);
	level.iz_route[level.iz_route.size] = (-16642, 11191, 6159);
	level.iz_route[level.iz_route.size] = (-15737, 11560, 6252);
	level.iz_route[level.iz_route.size] = (-15280, 11922, 6287);
	level.iz_route[level.iz_route.size] = (-14876, 12496, 6312);
	level.iz_route[level.iz_route.size] = (-14788, 13118, 6294);
	level.iz_route[level.iz_route.size] = (-14967, 13661, 6233);
	level.iz_route[level.iz_route.size] = (-15014, 14258, 6178);
	level.iz_route[level.iz_route.size] = (-15140, 15398, 6048);
	level.iz_route[level.iz_route.size] = (-15650, 16182, 5885);
	level.iz_route[level.iz_route.size] = (-16625, 16745, 5673);
	level.iz_route[level.iz_route.size] = (-17704, 16973, 5482);
	level.iz_route[level.iz_route.size] = (-18959, 16882, 5304);
	level.iz_route[level.iz_route.size] = (-19815, 16278, 5221);
	level.iz_route[level.iz_route.size] = (-20553, 15494, 5168);
	level.iz_route[level.iz_route.size] = (-20837, 14784, 5184);
	level.iz_route[level.iz_route.size] = (-20958, 13562, 5325);
	level.iz_route[level.iz_route.size] = (-20900, 12951, 5408);
	level.iz_route[level.iz_route.size] = (-20779, 12277, 5491);
	level.iz_route[level.iz_route.size] = (-20507, 11450, 5456);
	level.iz_route[level.iz_route.size] = (-20291, 10653, 5504);
	level.iz_route[level.iz_route.size] = (-20059, 9972, 5439);
	level.iz_route[level.iz_route.size] = (-19548, 7692, 5271);
	level.iz_route[level.iz_route.size] = (-19303, 6439, 5365);
	level.iz_route[level.iz_route.size] = (-18995, 5515, 5448);
	level.iz_route[level.iz_route.size] = (-18574, 4832, 5496);
	level.iz_route[level.iz_route.size] = (-17818, 4590, 5466);
	level.iz_route[level.iz_route.size] = (-17109, 4569, 5441);
	level.iz_route[level.iz_route.size] = (-16194, 4799, 5365);
	level.iz_route[level.iz_route.size] = (-15490, 4992, 5297);
	level.iz_route[level.iz_route.size] = (-14852, 5113, 5252);
	level.iz_route[level.iz_route.size] = (-14149, 5020, 5223);
	level.iz_route[level.iz_route.size] = (-13336, 4694, 5211);
	level.iz_route[level.iz_route.size] = (-12336, 4195, 5209);
	level.iz_route[level.iz_route.size] = (-11523, 3963, 5214);
	level.iz_route[level.iz_route.size] = (-10559, 4085, 5120);
	level.iz_route[level.iz_route.size] = (-9844, 4620, 5038);
	level.iz_route[level.iz_route.size] = (-8864, 5699, 5013);
	level.iz_route[level.iz_route.size] = (-8101, 6610, 5260);
	level.iz_route[level.iz_route.size] = (-7616, 7208, 5356);
	level.iz_route[level.iz_route.size] = (-6782, 8157, 5618);
	level.iz_route[level.iz_route.size] = (-5108, 9742, 5312);
	level.iz_route[level.iz_route.size] = (-4173, 11367, 5932);
	level.iz_route[level.iz_route.size] = (-3708, 12266, 6177);
	level.iz_route[level.iz_route.size] = (-3108, 13762, 6321);
	level.iz_route[level.iz_route.size] = (-2889, 14967, 6295);
	level.iz_route[level.iz_route.size] = (-2024, 15670, 6304);
	level.iz_route[level.iz_route.size] = (-1821, 17019, 6060);
	level.iz_route[level.iz_route.size] = (-1317, 18015, 5817);
	level.iz_route[level.iz_route.size] = (-543, 18395, 5699);
	level.iz_route[level.iz_route.size] = (562, 19089, 5384);
	level.iz_route[level.iz_route.size] = (2169, 19583, 4848);
	level.iz_route[level.iz_route.size] = (3980, 20145, 4912);
	level.iz_route[level.iz_route.size] = (5096, 20066, 5050);
	level.iz_route[level.iz_route.size] = (6018, 19241, 5371);
	level.iz_route[level.iz_route.size] = (6402, 18209, 5664);
	level.iz_route[level.iz_route.size] = (6661, 16353, 6092);
	level.iz_route[level.iz_route.size] = (6630, 14426, 6498);
	level.iz_route[level.iz_route.size] = (6472, 6913, 7696);
	level.iz_route[level.iz_route.size] = (6199, 4153, 7010);
	level.iz_route[level.iz_route.size] = (5782, 3049, 6641);
	level.iz_route[level.iz_route.size] = (5725, 2073, 6384);
	level.iz_route[level.iz_route.size] = (5669, 799, 6027);
	level.iz_route[level.iz_route.size] = (5385, 332, 5825);
	level.iz_route[level.iz_route.size] = (5301, -590, 5573);
	level.iz_route[level.iz_route.size] = (5249, -1760, 5254);
	level.iz_route[level.iz_route.size] = (5576, -2447, 4999);
	level.iz_route[level.iz_route.size] = (5500, -3022, 4842);
	level.iz_route[level.iz_route.size] = (5449, -4440, 4455);
	level.iz_route[level.iz_route.size] = (5697, -5206, 4123);
	level.iz_route[level.iz_route.size] = (5662, -6526, 3761);
	level.iz_route[level.iz_route.size] = (5630, -7795, 3520);
	level.iz_route[level.iz_route.size] = (5817, -8571, 3536);
	level.iz_route[level.iz_route.size] = (6170, -9187, 3670);
	level.iz_route[level.iz_route.size] = (6669, -9759, 3942);
	level.iz_route[level.iz_route.size] = (7239, -10235, 4305);
	level.iz_route[level.iz_route.size] = (7897, -10893, 4845);
	level.iz_route[level.iz_route.size] = (8416, -11476, 5333);
	level.iz_route[level.iz_route.size] = (8591, -12097, 5739);
	level.iz_route[level.iz_route.size] = (8607, -12791, 6169);
	level.iz_route[level.iz_route.size] = (8182, -13253, 6275);
	level.iz_route[level.iz_route.size] = (7691, -13479, 6207);
	level.iz_route[level.iz_route.size] = (7053, -13463, 5942);
	level.iz_route[level.iz_route.size] = (6579, -13057, 5549);
	level.iz_route[level.iz_route.size] = (6063, -12288, 4987);
	level.iz_route[level.iz_route.size] = (5713, -11517, 4506);
	level.iz_route[level.iz_route.size] = (5169, -10735, 3975);
	level.iz_route[level.iz_route.size] = (4627, -10342, 3604);
	level.iz_route[level.iz_route.size] = (4111, -10227, 3355);
	level.iz_route[level.iz_route.size] = (3560, -10210, 3180);
	level.iz_route[level.iz_route.size] = (3002, -10337, 3130);
	level.iz_route[level.iz_route.size] = (2551, -10458, 3176);
	level.iz_route[level.iz_route.size] = (1174, -10863, 3016);
	level.iz_route[level.iz_route.size] = (96, -11227, 3016);
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
	points[0] = (-3157.5867, 16726.1016, 5973.8188);
	angles[0] = (0, 142.7755, 0);
	at[0] = 0;
	points[1] = (-3199.7048, 16648.7012, 5985.9058);
	angles[1] = (0, 149.6587, 0);
	at[1] = 0.1000;
	points[2] = (-3276.8938, 16490.2754, 6011.1816);
	angles[2] = (0, 154.1604, 0);
	at[2] = 0.3000;
	points[3] = (-3330.4487, 16369.3311, 6029.6455);
	angles[3] = (0, 156.5021, 0);
	at[3] = 0.4500;
	points[4] = (-3344.5002, 16329.3701, 6034.7642);
	angles[4] = (0, 158.8751, 0);
	at[4] = 0.5000;
	points[5] = (-3392.8701, 16159.2920, 6053.9761);
	angles[5] = (0, 164.2860, 0);
	at[5] = 0.7000;
	points[6] = (-3457.9058, 15903.5820, 6082.8345);
	angles[6] = (0, 165.8850, 0);
	at[6] = 1;
	points[7] = (-3477.6301, 15817.5986, 6093.1499);
	angles[7] = (0, 167.0940, 0);
	at[7] = 1.1000;
	points[8] = (-3491.5513, 15730.8262, 6104.4487);
	angles[8] = (0, 170.8619, 0);
	at[8] = 1.2000;
	points[9] = (-3492.4526, 15688.3076, 6110.8662);
	angles[9] = (0, 175.4714, 0);
	at[9] = 1.2500;
	points[10] = (-3489.9172, 15643.8193, 6118.2285);
	angles[10] = (0, 179.4474, 0);
	at[10] = 1.3000;
	points[11] = (-3478.0828, 15513.3066, 6140.5513);
	angles[11] = (0, 184.7255, 0);
	at[11] = 1.4500;
	points[12] = (-3457.0789, 15339.2129, 6170.3936);
	angles[12] = (0, 187.1846, 0);
	at[12] = 1.6500;
	points[13] = (-3443.0630, 15253.7402, 6184.4097);
	angles[13] = (0, 189.3940, 0);
	at[13] = 1.7500;
	points[14] = (-3421.6694, 15168.9766, 6196.4175);
	angles[14] = (0, 193.2985, 0);
	at[14] = 1.8500;
	points[15] = (-3384.5789, 15041.8896, 6213.5039);
	angles[15] = (0, 196.1798, 0);
	at[15] = 2;
	points[16] = (-3328.1143, 14874.2520, 6236.0630);
	angles[16] = (0, 199.4157, 0);
	at[16] = 2.2000;
	points[17] = (-3310.9055, 14834.8818, 6241.7720);
	angles[17] = (0, 202.3293, 0);
	at[17] = 2.2500;
	points[18] = (-3285.8188, 14799.4893, 6247.8740);
	angles[18] = (0, 209.7716, 0);
	at[18] = 2.3000;
	points[19] = (-3255.7126, 14767.5195, 6254.0161);
	angles[19] = (0, 216.8913, 0);
	at[19] = 2.3500;
	points[20] = (-3189.2561, 14709.7637, 6266.2993);
	angles[20] = (0, 226.6418, 0);
	at[20] = 2.4500;
	points[21] = (-3118.1655, 14659.7637, 6278.7402);
	angles[21] = (0, 233.9554, 0);
	at[21] = 2.5500;
	points[22] = (-2998.0195, 14605.6699, 6298.2676);
	angles[22] = (0, 245.1952, 0);
	at[22] = 2.7000;
	points[23] = (-2874.4292, 14559.6455, 6318.2676);
	angles[23] = (0, 249.6444, 0);
	at[23] = 2.8500;
	points[24] = (-2832.8267, 14547.1650, 6325.3149);
	angles[24] = (0, 252.0439, 0);
	at[24] = 2.9000;
	points[25] = (-2790.3860, 14539.6855, 6333.3857);
	angles[25] = (0, 256.3922, 0);
	at[25] = 2.9500;
	points[26] = (-2660.3347, 14527.2842, 6359.4883);
	angles[26] = (0, 264.1964, 0);
	at[26] = 3.1000;
	points[27] = (-2573.1221, 14524.8828, 6376.0630);
	angles[27] = (0, 268.0894, 0);
	at[27] = 3.2000;
	points[28] = (-2530.3032, 14530.5127, 6381.8115);
	angles[28] = (0, 274.0247, 0);
	at[28] = 3.2500;
	points[29] = (-2487.8032, 14543.2676, 6384.9214);
	angles[29] = (0, 280.6949, 0);
	at[29] = 3.3000;
	points[30] = (-2364.5867, 14593.2686, 6391.2993);
	angles[30] = (0, 291.6690, 0);
	at[30] = 3.4500;
	points[31] = (-2248.5000, 14655.5908, 6402.8740);
	angles[31] = (0, 297.9762, 0);
	at[31] = 3.6000;
	points[32] = (-2135.9136, 14725.9053, 6415.8271);
	angles[32] = (0, 302.4742, 0);
	at[32] = 3.7500;
	points[33] = (-2100.6338, 14752.4014, 6419.0557);
	angles[33] = (0, 305.0754, 0);
	at[33] = 3.8000;
	points[34] = (-2067.7678, 14782.7158, 6420.9058);
	angles[34] = (0, 309.7552, 0);
	at[34] = 3.8500;
	points[35] = (-2043.6063, 14817.8340, 6419.4878);
	angles[35] = (0, 318.6966, 0);
	at[35] = 3.9000;
	points[36] = (-2023.5394, 14857.6777, 6416.0234);
	angles[36] = (0, 326.0968, 0);
	at[36] = 3.9500;
	points[37] = (-1988.0040, 14938.2285, 6407.8350);
	angles[37] = (0, 333.8631, 0);
	at[37] = 4.0500;
	points[38] = (-1923.3346, 15103.3066, 6389.3311);
	angles[38] = (0, 338.8104, 0);
	at[38] = 4.2500;
	points[39] = (-1868.1219, 15269.4492, 6369.4487);
	angles[39] = (0, 342.9409, 0);
	at[39] = 4.4500;
	points[40] = (-1845.8937, 15399.3311, 6351.9683);
	angles[40] = (0, 350.2940, 0);
	at[40] = 4.6000;
	points[41] = (-1832.8740, 15530.7480, 6333.3467);
	angles[41] = (0, 354.4034, 0);
	at[41] = 4.7500;
	points[42] = (-1829.0513, 15618.6230, 6320.5908);
	angles[42] = (0, 357.1673, 0);
	at[42] = 4.8500;
	points[43] = (-1829.6299, 15662.7168, 6314.0947);
	angles[43] = (0, 359.2596, 0);
	at[43] = 4.9000;
	points[44] = (-1833.1929, 15703.5039, 6308.0317);
	angles[44] = (0, 362.5357, 0);
	at[44] = 4.9500;
	points[45] = (-1870.7008, 15921.3389, 6275.1182);
	angles[45] = (0, 370.2477, 0);
	at[45] = 5.2000;
	points[46] = (-1924.8308, 16179.7637, 6235.1968);
	angles[46] = (0, 372.3352, 0);
	at[46] = 5.5000;
	points[47] = (-1956.5237, 16305.7871, 6214.4888);
	angles[47] = (0, 374.7726, 0);
	at[47] = 5.6500;
	points[48] = (-1987.1812, 16386.9688, 6198.6226);
	angles[48] = (0, 379.8240, 0);
	at[48] = 5.7500;
	points[49] = (-2023.1182, 16466.5352, 6181.7324);
	angles[49] = (0, 383.4799, 0);
	at[49] = 5.8500;
	points[50] = (-2082.7402, 16582.4023, 6155.2754);
	angles[50] = (0, 387.4022, 0);
	at[50] = 6;
	points[51] = (-2128.3621, 16656.9297, 6136.2598);
	angles[51] = (0, 391.2808, 0);
	at[51] = 6.1000;
	points[52] = (-2154.8032, 16689.1328, 6126.1025);
	angles[52] = (0, 395.9832, 0);
	at[52] = 6.1500;
	points[53] = (-2216.4094, 16749.0957, 6103.4248);
	angles[53] = (0, 403.7242, 0);
	at[53] = 6.2500;
	points[54] = (-2280.4568, 16805.7871, 6080.3540);
	angles[54] = (0, 407.4755, 0);
	at[54] = 6.3500;
	points[55] = (-2414.1221, 16913.8984, 6033.8979);
	angles[55] = (0, 411.7137, 0);
	at[55] = 6.5500;
	points[56] = (-2449.6143, 16938.7012, 6022.5195);
	angles[56] = (0, 413.8636, 0);
	at[56] = 6.6000;
	points[57] = (-2487.1260, 16956.2207, 6012.7168);
	angles[57] = (0, 420.5646, 0);
	at[57] = 6.6500;
	points[58] = (-2529.0198, 16968.1094, 6003.5435);
	angles[58] = (0, 427.7983, 0);
	at[58] = 6.7000;
	points[59] = (-2615.0552, 16982.8730, 5987.0474);
	angles[59] = (0, 437.8667, 0);
	at[59] = 6.8000;
	points[60] = (-2701.3425, 16988.1504, 5972.9526);
	angles[60] = (0, 445.6512, 0);
	at[60] = 6.9000;
	points[61] = (-2832.9568, 16971.0234, 5958.3462);
	angles[61] = (0, 456.9843, 0);
	at[61] = 7.0500;
	points[62] = (-2919.4094, 16951.9297, 5950.7480);
	angles[62] = (0, 461.7922, 0);
	at[62] = 7.1500;
	points[63] = (-2961.4058, 16937.1660, 5948.4648);
	angles[63] = (0, 466.7474, 0);
	at[63] = 7.2000;
	points[64] = (-2996.4331, 16911.8105, 5949.9604);
	angles[64] = (0, 477.2971, 0);
	at[64] = 7.2500;
	points[65] = (-3059.0945, 16849.3711, 5957.0864);
	angles[65] = (0, 491.0364, 0);
	at[65] = 7.3500;
	points[66] = (-3116.7363, 16782.1660, 5965.9453);
	angles[66] = (0, 497.7172, 0);
	at[66] = 7.4500;
	points[67] = (-3143.3269, 16747.2832, 5970.7876);
	angles[67] = (0, 500.4789, 0);
	at[67] = 7.5000;
	points[68] = (-3157.5867, 16726.1016, 5973.8188);
	angles[68] = (0, 502.7755, 0);
	at[68] = 7.5333;
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
	points[0] = (-1321.8662, 18667.9141, 5589.2915);
	angles[0] = (0, -134.2322, 0);
	at[0] = 0;
	points[1] = (-1269.7008, 18600.9453, 5615.1177);
	angles[1] = (0, -140.9498, 0);
	at[1] = 0.1000;
	points[2] = (-1223.5276, 18530.0781, 5642.0083);
	angles[2] = (0, -145.7404, 0);
	at[2] = 0.2000;
	points[3] = (-1046.5552, 18243.5039, 5751.6533);
	angles[3] = (0, -148.5274, 0);
	at[3] = 0.6000;
	points[4] = (-962.0354, 18096.6934, 5806.6934);
	angles[4] = (0, -150.6893, 0);
	at[4] = 0.8000;
	points[5] = (-942.7913, 18058.8184, 5820.2363);
	angles[5] = (0, -152.1349, 0);
	at[5] = 0.8500;
	points[6] = (-927.2874, 18022.6387, 5832.3232);
	angles[6] = (0, -154.8322, 0);
	at[6] = 0.9000;
	points[7] = (-857.5670, 17820.1973, 5895.0786);
	angles[7] = (0, -161.5400, 0);
	at[7] = 1.1500;
	points[8] = (-796.6851, 17615.0801, 5956.5356);
	angles[8] = (0, -164.1252, 0);
	at[8] = 1.4000;
	points[9] = (-776.7598, 17533.1113, 5980.4331);
	angles[9] = (0, -166.2643, 0);
	at[9] = 1.5000;
	points[10] = (-770.2166, 17491.7324, 5992.0083);
	angles[10] = (0, -169.4356, 0);
	at[10] = 1.5500;
	points[11] = (-770.3229, 17405.7480, 6013.8584);
	angles[11] = (0, -178.2880, 0);
	at[11] = 1.6500;
	points[12] = (-783.6496, 17276.5762, 6044.6851);
	angles[12] = (0, -185.7659, 0);
	at[12] = 1.8000;
	points[13] = (-798.6417, 17191.6543, 6064.3306);
	angles[13] = (0, -189.4351, 0);
	at[13] = 1.9000;
	points[14] = (-822.3150, 17107.4414, 6083.3862);
	angles[14] = (0, -195.5490, 0);
	at[14] = 2;
	points[15] = (-843.6378, 17071.0645, 6091.2202);
	angles[15] = (0, -204.3624, 0);
	at[15] = 2.0500;
	points[16] = (-903.8307, 17007.3223, 6103.5435);
	angles[16] = (0, -219.4263, 0);
	at[16] = 2.1500;
	points[17] = (-969.7952, 16948.8184, 6114.4097);
	angles[17] = (0, -226.5099, 0);
	at[17] = 2.2500;
	points[18] = (-1073.8622, 16866.9688, 6129.6064);
	angles[18] = (0, -231.8322, 0);
	at[18] = 2.4000;
	points[19] = (-1146.1024, 16819.6855, 6139.3701);
	angles[19] = (0, -236.8466, 0);
	at[19] = 2.5000;
	points[20] = (-1227.1693, 16783.8574, 6149.9209);
	angles[20] = (0, -244.3992, 0);
	at[20] = 2.6000;
	points[21] = (-1309.8464, 16752.6387, 6160.1182);
	angles[21] = (0, -248.2877, 0);
	at[21] = 2.7000;
	points[22] = (-1478.0040, 16697.6387, 6177.7168);
	angles[22] = (0, -252.5135, 0);
	at[22] = 2.9000;
	points[23] = (-1521.3937, 16686.1816, 6180.4331);
	angles[23] = (0, -254.1401, 0);
	at[23] = 2.9500;
	points[24] = (-1563.5985, 16678.8184, 6180.0786);
	angles[24] = (0, -257.6574, 0);
	at[24] = 3;
	points[25] = (-1651.6182, 16671.5352, 6173.2285);
	angles[25] = (0, -263.7340, 0);
	at[25] = 3.1000;
	points[26] = (-1783.9016, 16667.4414, 6158.9766);
	angles[26] = (0, -268.1073, 0);
	at[26] = 3.2500;
	points[27] = (-1916.6693, 16671.4961, 6142.5986);
	angles[27] = (0, -272.4949, 0);
	at[27] = 3.4000;
	points[28] = (-1958.3820, 16680, 6136.9683);
	angles[28] = (0, -277.9222, 0);
	at[28] = 3.4500;
	points[29] = (-1999.6536, 16694.2129, 6130.7876);
	angles[29] = (0, -283.7422, 0);
	at[29] = 3.5000;
	points[30] = (-2080.6458, 16728.7012, 6117.7168);
	angles[30] = (0, -291.1340, 0);
	at[30] = 3.6000;
	points[31] = (-2197.3662, 16788.8594, 6096.1025);
	angles[31] = (0, -297.5597, 0);
	at[31] = 3.7500;
	points[32] = (-2232.4331, 16813.5039, 6086.7324);
	angles[32] = (0, -302.2679, 0);
	at[32] = 3.8000;
	points[33] = (-2293.3464, 16873.3066, 6063.1104);
	angles[33] = (0, -312.0568, 0);
	at[33] = 3.9000;
	points[34] = (-2349.0039, 16937.7559, 6038.1104);
	angles[34] = (0, -317.8708, 0);
	at[34] = 4;
	points[35] = (-2397.0828, 17006.1816, 6013.3862);
	angles[35] = (0, -324.5032, 0);
	at[35] = 4.1000;
	points[36] = (-2473.2244, 17159.5273, 5963.6616);
	angles[36] = (0, -333.7899, 0);
	at[36] = 4.3000;
	points[37] = (-2540.0747, 17316.4180, 5914.3706);
	angles[37] = (0, -337.7495, 0);
	at[37] = 4.5000;
	points[38] = (-2563.6260, 17396.7324, 5890.7085);
	angles[38] = (0, -343.0947, 0);
	at[38] = 4.6000;
	points[39] = (-2598.7402, 17564.9219, 5843.4644);
	angles[39] = (0, -348.3240, 0);
	at[39] = 4.8000;
	points[40] = (-2635.6770, 17776.5352, 5784.4492);
	angles[40] = (0, -350.6398, 0);
	at[40] = 5.0500;
	points[41] = (-2645.2717, 17859.5273, 5760.9839);
	angles[41] = (0, -353.4854, 0);
	at[41] = 5.1500;
	points[42] = (-2647.7559, 18072.9531, 5699.2910);
	angles[42] = (0, -359.8901, 0);
	at[42] = 5.4000;
	points[43] = (-2644.8503, 18285.0391, 5638.2681);
	angles[43] = (0, -360.4481, 0);
	at[43] = 5.6500;
	points[44] = (-2646.5630, 18541.7715, 5566.6143);
	angles[44] = (0, -360.8535, 0);
	at[44] = 5.9500;
	points[45] = (-2637.2913, 18627.4414, 5543.3071);
	angles[45] = (0, -366.4600, 0);
	at[45] = 6.0500;
	points[46] = (-2620.0591, 18665.4336, 5533.7007);
	angles[46] = (0, -377.1151, 0);
	at[46] = 6.1000;
	points[47] = (-2565.0986, 18733.0723, 5518.5435);
	angles[47] = (0, -394.5114, 0);
	at[47] = 6.2000;
	points[48] = (-2503.3623, 18795.6699, 5504.9214);
	angles[48] = (0, -402.4208, 0);
	at[48] = 6.3000;
	points[49] = (-2438.7441, 18854.8418, 5491.6538);
	angles[49] = (0, -406.5720, 0);
	at[49] = 6.4000;
	points[50] = (-2370.4412, 18908.5430, 5476.7720);
	angles[50] = (0, -411.5661, 0);
	at[50] = 6.5000;
	points[51] = (-2296.8740, 18954.3711, 5459.0156);
	angles[51] = (0, -416.7474, 0);
	at[51] = 6.6000;
	points[52] = (-2182.5354, 19018.1895, 5432.5591);
	angles[52] = (0, -420.8597, 0);
	at[52] = 6.7500;
	points[53] = (-2103.5513, 19056.0234, 5416.8506);
	angles[53] = (0, -424.2130, 0);
	at[53] = 6.8500;
	points[54] = (-2063.0867, 19069.0957, 5412.2051);
	angles[54] = (0, -429.3645, 0);
	at[54] = 6.9000;
	points[55] = (-2018.8779, 19075.3555, 5411.7319);
	angles[55] = (0, -436.0963, 0);
	at[55] = 6.9500;
	points[56] = (-1930.2401, 19078.3457, 5415.6304);
	angles[56] = (0, -445.8593, 0);
	at[56] = 7.0500;
	points[57] = (-1842.2244, 19070.1191, 5423.8584);
	angles[57] = (0, -454.0884, 0);
	at[57] = 7.1500;
	points[58] = (-1799.8268, 19059.6855, 5430.0396);
	angles[58] = (0, -459.6848, 0);
	at[58] = 7.2000;
	points[59] = (-1762.5040, 19042.3613, 5438.0317);
	angles[59] = (0, -468.5817, 0);
	at[59] = 7.2500;
	points[60] = (-1726.7126, 19017.5977, 5448.3862);
	angles[60] = (0, -476.7861, 0);
	at[60] = 7.3000;
	points[61] = (-1657.6143, 18963.7402, 5470.4331);
	angles[61] = (0, -485.2973, 0);
	at[61] = 7.4000;
	points[62] = (-1461.1654, 18796.8105, 5537.8345);
	angles[62] = (0, -490.9011, 0);
	at[62] = 7.7000;
	points[63] = (-1365.4567, 18710.6309, 5572.3618);
	angles[63] = (0, -492.1274, 0);
	at[63] = 7.8500;
	points[64] = (-1340.1812, 18686.7324, 5581.8506);
	angles[64] = (0, -492.7896, 0);
	at[64] = 7.9000;
	points[65] = (-1321.8662, 18667.9141, 5589.2915);
	angles[65] = (0, -494.2322, 0);
	at[65] = 7.9333;
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
