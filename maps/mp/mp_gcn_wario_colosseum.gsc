main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_wario_colosseum", 0);

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
	ambientPlay("iz_0_68", 2);
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
	level.iz_route[level.iz_route.size] = (1713, 6415, 10515);
	level.iz_route[level.iz_route.size] = (-1993, 6389, 10515);
	level.iz_route[level.iz_route.size] = (-3997, 6399, 10515);
	level.iz_route[level.iz_route.size] = (-4537, 6287, 10515);
	level.iz_route[level.iz_route.size] = (-5003, 6092, 10515);
	level.iz_route[level.iz_route.size] = (-5291, 5790, 10515);
	level.iz_route[level.iz_route.size] = (-5411, 5522, 10515);
	level.iz_route[level.iz_route.size] = (-5497, 5087, 10515);
	level.iz_route[level.iz_route.size] = (-5478, 3955, 10515);
	level.iz_route[level.iz_route.size] = (-5460, 3162, 10515);
	level.iz_route[level.iz_route.size] = (-5480, 2464, 10515);
	level.iz_route[level.iz_route.size] = (-5453, 1301, 10680);
	level.iz_route[level.iz_route.size] = (-5462, 687, 11210);
	level.iz_route[level.iz_route.size] = (-5449, -115, 11280);
	level.iz_route[level.iz_route.size] = (-5443, -1282, 11280);
	level.iz_route[level.iz_route.size] = (-5450, -2038, 11280);
	level.iz_route[level.iz_route.size] = (-5483, -2298, 11280);
	level.iz_route[level.iz_route.size] = (-5554, -2492, 11280);
	level.iz_route[level.iz_route.size] = (-5720, -2730, 11280);
	level.iz_route[level.iz_route.size] = (-6410, -3696, 11280);
	level.iz_route[level.iz_route.size] = (-6522, -3984, 11280);
	level.iz_route[level.iz_route.size] = (-6529, -4329, 11280);
	level.iz_route[level.iz_route.size] = (-6528, -5683, 11280);
	level.iz_route[level.iz_route.size] = (-6541, -6237, 11298);
	level.iz_route[level.iz_route.size] = (-6531, -6529, 11347);
	level.iz_route[level.iz_route.size] = (-6514, -6856, 11605);
	level.iz_route[level.iz_route.size] = (-6524, -7186, 11907);
	level.iz_route[level.iz_route.size] = (-6511, -7902, 12021);
	level.iz_route[level.iz_route.size] = (-6520, -9039, 11930);
	level.iz_route[level.iz_route.size] = (-6522, -10158, 12007);
	level.iz_route[level.iz_route.size] = (-6510, -10651, 12025);
	level.iz_route[level.iz_route.size] = (-6465, -11321, 12025);
	level.iz_route[level.iz_route.size] = (-6179, -11968, 12025);
	level.iz_route[level.iz_route.size] = (-5679, -12464, 12025);
	level.iz_route[level.iz_route.size] = (-4895, -12466, 12025);
	level.iz_route[level.iz_route.size] = (-4339, -12260, 12025);
	level.iz_route[level.iz_route.size] = (-3904, -11885, 12025);
	level.iz_route[level.iz_route.size] = (-3745, -11239, 12025);
	level.iz_route[level.iz_route.size] = (-3808, -10230, 12025);
	level.iz_route[level.iz_route.size] = (-3826, -9414, 12025);
	level.iz_route[level.iz_route.size] = (-3635, -8747, 12025);
	level.iz_route[level.iz_route.size] = (-3266, -7888, 12025);
	level.iz_route[level.iz_route.size] = (-2698, -6516, 12025);
	level.iz_route[level.iz_route.size] = (-2236, -5412, 12090);
	level.iz_route[level.iz_route.size] = (-1895, -4599, 12335);
	level.iz_route[level.iz_route.size] = (-1456, -3551, 13003);
	level.iz_route[level.iz_route.size] = (-1254, -2998, 13552);
	level.iz_route[level.iz_route.size] = (-983, -2315, 14445);
	level.iz_route[level.iz_route.size] = (-361, -794, 15265);
	level.iz_route[level.iz_route.size] = (177, 481, 13527);
	level.iz_route[level.iz_route.size] = (440, 1057, 13311);
	level.iz_route[level.iz_route.size] = (811, 1941, 13057);
	level.iz_route[level.iz_route.size] = (900, 2614, 12916);
	level.iz_route[level.iz_route.size] = (658, 3075, 12827);
	level.iz_route[level.iz_route.size] = (246, 3356, 12757);
	level.iz_route[level.iz_route.size] = (-312, 3280, 12645);
	level.iz_route[level.iz_route.size] = (-750, 2766, 12486);
	level.iz_route[level.iz_route.size] = (-877, 2083, 12354);
	level.iz_route[level.iz_route.size] = (-648, 1626, 12279);
	level.iz_route[level.iz_route.size] = (-221, 1383, 12191);
	level.iz_route[level.iz_route.size] = (513, 1526, 12044);
	level.iz_route[level.iz_route.size] = (949, 2099, 11908);
	level.iz_route[level.iz_route.size] = (759, 3019, 11734);
	level.iz_route[level.iz_route.size] = (-32, 3299, 11547);
	level.iz_route[level.iz_route.size] = (-634, 3108, 11428);
	level.iz_route[level.iz_route.size] = (-911, 2652, 11326);
	level.iz_route[level.iz_route.size] = (-972, 2176, 11180);
	level.iz_route[level.iz_route.size] = (-888, 1704, 10953);
	level.iz_route[level.iz_route.size] = (-611, 961, 10468);
	level.iz_route[level.iz_route.size] = (-187, 53, 10076);
	level.iz_route[level.iz_route.size] = (39, -746, 10041);
	level.iz_route[level.iz_route.size] = (-51, -1735, 10331);
	level.iz_route[level.iz_route.size] = (-288, -2582, 10733);
	level.iz_route[level.iz_route.size] = (-50, -3214, 10902);
	level.iz_route[level.iz_route.size] = (532, -3509, 10877);
	level.iz_route[level.iz_route.size] = (1031, -3567, 10809);
	level.iz_route[level.iz_route.size] = (1705, -3348, 10613);
	level.iz_route[level.iz_route.size] = (2281, -2977, 10440);
	level.iz_route[level.iz_route.size] = (2930, -2301, 10253);
	level.iz_route[level.iz_route.size] = (3548, -1412, 10206);
	level.iz_route[level.iz_route.size] = (3902, -485, 10282);
	level.iz_route[level.iz_route.size] = (3816, 104, 10319);
	level.iz_route[level.iz_route.size] = (3517, 416, 10326);
	level.iz_route[level.iz_route.size] = (3118, 586, 10365);
	level.iz_route[level.iz_route.size] = (2428, 564, 10481);
	level.iz_route[level.iz_route.size] = (1305, 322, 10919);
	level.iz_route[level.iz_route.size] = (415, 19, 11427);
	level.iz_route[level.iz_route.size] = (-31, -101, 11485);
	level.iz_route[level.iz_route.size] = (-845, -378, 11025);
	level.iz_route[level.iz_route.size] = (-1506, -648, 10655);
	level.iz_route[level.iz_route.size] = (-2407, -936, 10545);
	level.iz_route[level.iz_route.size] = (-3257, -1083, 10505);
	level.iz_route[level.iz_route.size] = (-3802, -841, 10362);
	level.iz_route[level.iz_route.size] = (-4203, -372, 10161);
	level.iz_route[level.iz_route.size] = (-4445, 541, 9877);
	level.iz_route[level.iz_route.size] = (-4251, 1596, 9697);
	level.iz_route[level.iz_route.size] = (-3840, 2402, 9708);
	level.iz_route[level.iz_route.size] = (-3329, 2979, 9860);
	level.iz_route[level.iz_route.size] = (-2831, 3365, 10027);
	level.iz_route[level.iz_route.size] = (-2144, 3698, 10208);
	level.iz_route[level.iz_route.size] = (-1261, 3889, 10367);
	level.iz_route[level.iz_route.size] = (-102, 3779, 10490);
	level.iz_route[level.iz_route.size] = (566, 3369, 10490);
	level.iz_route[level.iz_route.size] = (835, 2928, 10451);
	level.iz_route[level.iz_route.size] = (928, 2373, 10366);
	level.iz_route[level.iz_route.size] = (650, 1900, 10285);
	level.iz_route[level.iz_route.size] = (196, 1628, 10186);
	level.iz_route[level.iz_route.size] = (-276, 1746, 10074);
	level.iz_route[level.iz_route.size] = (-858, 2106, 10002);
	level.iz_route[level.iz_route.size] = (-964, 2421, 9667);
	level.iz_route[level.iz_route.size] = (-1140, 2911, 8817);
	level.iz_route[level.iz_route.size] = (-1234, 3427, 8506);
	level.iz_route[level.iz_route.size] = (-1345, 4296, 8377);
	level.iz_route[level.iz_route.size] = (-1395, 5312, 8270);
	level.iz_route[level.iz_route.size] = (-1277, 6164, 8231);
	level.iz_route[level.iz_route.size] = (-838, 6914, 8183);
	level.iz_route[level.iz_route.size] = (470, 8339, 8183);
	level.iz_route[level.iz_route.size] = (1673, 9240, 8291);
	level.iz_route[level.iz_route.size] = (2491, 9453, 8383);
	level.iz_route[level.iz_route.size] = (3226, 9247, 8417);
	level.iz_route[level.iz_route.size] = (3887, 8692, 8422);
	level.iz_route[level.iz_route.size] = (4356, 7801, 8404);
	level.iz_route[level.iz_route.size] = (4328, 7042, 8306);
	level.iz_route[level.iz_route.size] = (4090, 6218, 8161);
	level.iz_route[level.iz_route.size] = (3637, 5320, 7943);
	level.iz_route[level.iz_route.size] = (2946, 4219, 7562);
	level.iz_route[level.iz_route.size] = (2393, 3303, 7183);
	level.iz_route[level.iz_route.size] = (1993, 2628, 6808);
	level.iz_route[level.iz_route.size] = (1761, 1985, 6428);
	level.iz_route[level.iz_route.size] = (1931, 1337, 6294);
	level.iz_route[level.iz_route.size] = (2211, 573, 6267);
	level.iz_route[level.iz_route.size] = (2111, -489, 6225);
	level.iz_route[level.iz_route.size] = (1783, -1216, 6222);
	level.iz_route[level.iz_route.size] = (1225, -1882, 6250);
	level.iz_route[level.iz_route.size] = (538, -2191, 6255);
	level.iz_route[level.iz_route.size] = (-370, -2219, 6252);
	level.iz_route[level.iz_route.size] = (-1123, -2426, 6438);
	level.iz_route[level.iz_route.size] = (-1994, -3174, 7000);
	level.iz_route[level.iz_route.size] = (-2762, -4185, 7531);
	level.iz_route[level.iz_route.size] = (-3633, -5377, 8000);
	level.iz_route[level.iz_route.size] = (-4240, -6191, 8058);
	level.iz_route[level.iz_route.size] = (-4369, -6568, 8058);
	level.iz_route[level.iz_route.size] = (-4090, -6967, 8058);
	level.iz_route[level.iz_route.size] = (-3591, -7287, 8058);
	level.iz_route[level.iz_route.size] = (-2604, -7843, 8058);
	level.iz_route[level.iz_route.size] = (-942, -8226, 8058);
	level.iz_route[level.iz_route.size] = (585, -8095, 8058);
	level.iz_route[level.iz_route.size] = (2265, -7734, 8058);
	level.iz_route[level.iz_route.size] = (3177, -7431, 8097);
	level.iz_route[level.iz_route.size] = (3928, -6964, 8184);
	level.iz_route[level.iz_route.size] = (4589, -6259, 8335);
	level.iz_route[level.iz_route.size] = (5142, -5575, 8484);
	level.iz_route[level.iz_route.size] = (5567, -4704, 8649);
	level.iz_route[level.iz_route.size] = (5808, -3962, 8779);
	level.iz_route[level.iz_route.size] = (6015, -3173, 8926);
	level.iz_route[level.iz_route.size] = (6053, -1796, 9185);
	level.iz_route[level.iz_route.size] = (5985, -157, 9396);
	level.iz_route[level.iz_route.size] = (6059, 1123, 9581);
	level.iz_route[level.iz_route.size] = (6030, 1879, 10109);
	level.iz_route[level.iz_route.size] = (6004, 2305, 10549);
	level.iz_route[level.iz_route.size] = (6024, 3895, 10515);
	level.iz_route[level.iz_route.size] = (5933, 5208, 10515);
	level.iz_route[level.iz_route.size] = (5599, 5885, 10515);
	level.iz_route[level.iz_route.size] = (5082, 6268, 10515);
	level.iz_route[level.iz_route.size] = (4148, 6336, 10515);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (14.6173, 60.0555, 6480.2754);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (14.6173, 60.0555, 6480.2754);
	angles[1] = (55, 55, 90);
	at[1] = 1.8000;
	points[2] = (14.6173, 60.0555, 6480.2754);
	angles[2] = (0, 110, 180);
	at[2] = 3.6000;
	points[3] = (14.6173, 60.0555, 6480.2754);
	angles[3] = (-180, 180, 180);
	at[3] = 7.2000;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5446.7720, 363.7071, 11344.1338);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5446.7720, 363.7071, 11344.1338);
	angles[1] = (90, 0, 0);
	at[1] = 1.5000;
	points[2] = (-5446.7720, 363.7071, 11344.1338);
	angles[2] = (180, 0, 0);
	at[2] = 3;
	points[3] = (-5446.7720, 363.7071, 11344.1338);
	angles[3] = (0, 0, 0);
	at[3] = 6;
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
	points[0] = (-6501.5356, -7489.9604, 11944.4893);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6501.5356, -7489.9604, 11944.4893);
	angles[1] = (90, 0, 0);
	at[1] = 1.5000;
	points[2] = (-6501.5356, -7489.9604, 11944.4893);
	angles[2] = (180, 0, 0);
	at[2] = 3;
	points[3] = (-6501.5356, -7489.9604, 11944.4893);
	angles[3] = (0, 0, 0);
	at[3] = 6;
	mover = getEnt("iz_obj_2", "targetname");
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
