main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_mushroom_gorge", 0);

	setExpFog(14814.2422, 28492.3340, 0.2627, 0.8039, 0.6667, 0);

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
	ambientPlay("iz_0_n_kinoko", 2);
	level thread iz_music("iz_9_se_cn_knk_env_wind");
	iz_emitter("iz_1_se_cn_knk_env_cave", (8459.6455, 10172.2441, 4623.6128), 0, 12.0104);
	iz_emitter("iz_2_se_cn_knk_env_cave", (11929.1338, 3690.9448, 4623.6128), 0, 12.0104);
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

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (-5315, 12298, 3426);
	level.iz_route[level.iz_route.size] = (-5285, 10704, 3438);
	level.iz_route[level.iz_route.size] = (-5399, 9956, 3477);
	level.iz_route[level.iz_route.size] = (-6031, 8694, 3555);
	level.iz_route[level.iz_route.size] = (-6304, 7338, 3687);
	level.iz_route[level.iz_route.size] = (-5846, 6171, 3817);
	level.iz_route[level.iz_route.size] = (-4695, 5581, 3875);
	level.iz_route[level.iz_route.size] = (-3425, 5344, 3889);
	level.iz_route[level.iz_route.size] = (-2790, 4887, 3919);
	level.iz_route[level.iz_route.size] = (-2628, 3337, 3765);
	level.iz_route[level.iz_route.size] = (-2598, 2274, 4045);
	level.iz_route[level.iz_route.size] = (-2598, 797, 3881);
	level.iz_route[level.iz_route.size] = (-2333, -266, 3925);
	level.iz_route[level.iz_route.size] = (-1594, -1152, 4046);
	level.iz_route[level.iz_route.size] = (-265, -1218, 4127);
	level.iz_route[level.iz_route.size] = (591, -1122, 4181);
	level.iz_route[level.iz_route.size] = (1594, -886, 4248);
	level.iz_route[level.iz_route.size] = (2835, -502, 4434);
	level.iz_route[level.iz_route.size] = (3912, 0, 4839);
	level.iz_route[level.iz_route.size] = (4660, 283, 4971);
	level.iz_route[level.iz_route.size] = (5433, 576, 5107);
	level.iz_route[level.iz_route.size] = (6954, 1107, 4866);
	level.iz_route[level.iz_route.size] = (8548, 1727, 4498);
	level.iz_route[level.iz_route.size] = (9390, 2008, 4395);
	level.iz_route[level.iz_route.size] = (10010, 2274, 4505);
	level.iz_route[level.iz_route.size] = (10955, 2628, 4826);
	level.iz_route[level.iz_route.size] = (11814, 3146, 5216);
	level.iz_route[level.iz_route.size] = (12461, 3765, 5479);
	level.iz_route[level.iz_route.size] = (12712, 5256, 5592);
	level.iz_route[level.iz_route.size] = (12269, 6718, 5356);
	level.iz_route[level.iz_route.size] = (11191, 8031, 4904);
	level.iz_route[level.iz_route.size] = (9995, 8873, 4575);
	level.iz_route[level.iz_route.size] = (8976, 9921, 4462);
	level.iz_route[level.iz_route.size] = (8238, 10955, 4575);
	level.iz_route[level.iz_route.size] = (6954, 12195, 4304);
	level.iz_route[level.iz_route.size] = (5625, 13036, 4121);
	level.iz_route[level.iz_route.size] = (4193, 13686, 4072);
	level.iz_route[level.iz_route.size] = (2687, 14719, 4089);
	level.iz_route[level.iz_route.size] = (797, 14838, 4000);
	level.iz_route[level.iz_route.size] = (-192, 15236, 3694);
	level.iz_route[level.iz_route.size] = (-1358, 16019, 3675);
	level.iz_route[level.iz_route.size] = (-2156, 17023, 3633);
	level.iz_route[level.iz_route.size] = (-2672, 18233, 3610);
	level.iz_route[level.iz_route.size] = (-3750, 18912, 3651);
	level.iz_route[level.iz_route.size] = (-4990, 18455, 3622);
	level.iz_route[level.iz_route.size] = (-5344, 16919, 3527);
	level.iz_route[level.iz_route.size] = (-5344, 15487, 3438);
	level.iz_route[level.iz_route.size] = (-5359, 14144, 3425);
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
	points[0] = (-3941.9292, 18690.9453, 3628.6653);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-3941.9292, 18683.3867, 3627.9607);
	angles[1] = (0, -90, 0);
	at[1] = 0.5000;
	points[2] = (-3941.9292, 18683.3867, 3627.9607);
	angles[2] = (0, -90, 0);
	at[2] = 1;
	points[3] = (-3941.9292, 18675.8672, 3627.2561);
	angles[3] = (0, -90, 0);
	at[3] = 1.5000;
	points[4] = (-3941.9292, 18668.3066, 3626.5513);
	angles[4] = (0, -90, 0);
	at[4] = 2.5000;
	points[5] = (-3941.9292, 18660.7480, 3625.8464);
	angles[5] = (0, -90, 0);
	at[5] = 3;
	points[6] = (-3941.9292, 18660.7480, 3625.8464);
	angles[6] = (0, -90, 0);
	at[6] = 3.5000;
	points[7] = (-3941.9292, 18638.1094, 3623.7363);
	angles[7] = (0, -90, 0);
	at[7] = 5.5000;
	points[8] = (-3941.9292, 18638.1094, 3623.7363);
	angles[8] = (0, -90, 0);
	at[8] = 6;
	points[9] = (-3941.9292, 18615.4727, 3621.6221);
	angles[9] = (0, -90, 0);
	at[9] = 8;
	points[10] = (-3941.9292, 18615.4727, 3621.6221);
	angles[10] = (0, -90, 0);
	at[10] = 8.5000;
	points[11] = (-3941.9292, 18592.8340, 3619.5081);
	angles[11] = (0, -90, 0);
	at[11] = 10.5000;
	points[12] = (-3941.9292, 18592.8340, 3619.5081);
	angles[12] = (0, -90, 0);
	at[12] = 11;
	points[13] = (-3941.9292, 18570.1973, 3617.3975);
	angles[13] = (0, -90, 0);
	at[13] = 13;
	points[14] = (-3941.9292, 18570.1973, 3617.3975);
	angles[14] = (0, -90, 0);
	at[14] = 13.5000;
	points[15] = (-3941.9292, 18547.5195, 3615.2834);
	angles[15] = (0, -90, 0);
	at[15] = 15.5000;
	points[16] = (-3941.9292, 18547.5195, 3615.2834);
	angles[16] = (0, -90, 0);
	at[16] = 16;
	points[17] = (-3941.9292, 18524.8828, 3613.1731);
	angles[17] = (0, -90, 0);
	at[17] = 18;
	points[18] = (-3941.9292, 18524.8828, 3613.1731);
	angles[18] = (0, -90, 0);
	at[18] = 18.5000;
	points[19] = (-3941.9292, 18502.2441, 3611.0591);
	angles[19] = (0, -90, 0);
	at[19] = 20.5000;
	points[20] = (-3941.9292, 18502.2441, 3611.0591);
	angles[20] = (0, -90, 0);
	at[20] = 21;
	points[21] = (-3941.9292, 18479.6055, 3608.9448);
	angles[21] = (0, -90, 0);
	at[21] = 23;
	points[22] = (-3941.9292, 18479.6055, 3608.9448);
	angles[22] = (0, -90, 0);
	at[22] = 23.5000;
	points[23] = (-3941.9292, 18456.9688, 3606.8308);
	angles[23] = (0, -90, 0);
	at[23] = 25.5000;
	points[24] = (-3941.9292, 18456.9688, 3606.8308);
	angles[24] = (0, -90, 0);
	at[24] = 26;
	points[25] = (-3941.9292, 18434.3301, 3604.6536);
	angles[25] = (0, -90, 0);
	at[25] = 28;
	points[26] = (-3941.9292, 18434.3301, 3604.6536);
	angles[26] = (0, -90, 0);
	at[26] = 28.5000;
	points[27] = (-3941.9292, 18411.6934, 3602.4763);
	angles[27] = (0, -90, 0);
	at[27] = 30.5000;
	points[28] = (-3941.9292, 18411.6934, 3602.4763);
	angles[28] = (0, -90, 0);
	at[28] = 31;
	points[29] = (-3941.9292, 18389.0156, 3600.2993);
	angles[29] = (0, -90, 0);
	at[29] = 33;
	points[30] = (-3941.9292, 18389.0156, 3600.2993);
	angles[30] = (0, -90, 0);
	at[30] = 33.5000;
	points[31] = (-3941.9292, 18366.3789, 3598.1223);
	angles[31] = (0, -90, 0);
	at[31] = 35.5000;
	points[32] = (-3941.9292, 18366.3789, 3598.1223);
	angles[32] = (0, -90, 0);
	at[32] = 36;
	points[33] = (-3941.9292, 18343.7402, 3597.1064);
	angles[33] = (0, -90, 0);
	at[33] = 38;
	points[34] = (-3941.9292, 18343.7402, 3597.1064);
	angles[34] = (0, -90, 0);
	at[34] = 38.5000;
	points[35] = (-3941.9292, 18321.1016, 3597.1064);
	angles[35] = (0, -90, 0);
	at[35] = 40.5000;
	points[36] = (-3941.9292, 18321.1016, 3597.1064);
	angles[36] = (0, -90, 0);
	at[36] = 41;
	points[37] = (-3941.9292, 18313.5430, 3597.1064);
	angles[37] = (0, -90, 0);
	at[37] = 41.5000;
	points[38] = (-3941.9292, 18306.0234, 3597.1064);
	angles[38] = (0, -90, 0);
	at[38] = 42.5000;
	points[39] = (-3941.9292, 18298.4648, 3597.1064);
	angles[39] = (0, -90, 0);
	at[39] = 43;
	points[40] = (-3941.9292, 18298.4648, 3597.1064);
	angles[40] = (0, -90, 0);
	at[40] = 43.5000;
	points[41] = (-3941.9292, 18275.8262, 3597.1064);
	angles[41] = (0, -90, 0);
	at[41] = 45.5000;
	points[42] = (-3941.9292, 18275.8262, 3597.1064);
	angles[42] = (0, -90, 0);
	at[42] = 46;
	points[43] = (-3941.9292, 18253.1895, 3597.1064);
	angles[43] = (0, -90, 0);
	at[43] = 48;
	points[44] = (-3941.9292, 18253.1895, 3597.1064);
	angles[44] = (0, -90, 0);
	at[44] = 48.5000;
	points[45] = (-3941.9292, 18230.5508, 3597.1064);
	angles[45] = (0, -90, 0);
	at[45] = 50.5000;
	points[46] = (-3941.9292, 18230.5508, 3597.1064);
	angles[46] = (0, -90, 0);
	at[46] = 51;
	points[47] = (-3941.9292, 18207.8750, 3597.1064);
	angles[47] = (0, -90, 0);
	at[47] = 53;
	points[48] = (-3941.9292, 18207.8750, 3597.1064);
	angles[48] = (0, -90, 0);
	at[48] = 53.5000;
	points[49] = (-3941.9292, 18185.2363, 3597.1064);
	angles[49] = (0, -90, 0);
	at[49] = 55.5000;
	points[50] = (-3941.9292, 18185.2363, 3597.1064);
	angles[50] = (0, -90, 0);
	at[50] = 56;
	points[51] = (-3941.9292, 18177.7168, 3597.1064);
	angles[51] = (0, -90, 0);
	at[51] = 56.5000;
	points[52] = (-3941.9292, 18170.1582, 3597.1064);
	angles[52] = (0, -90, 0);
	at[52] = 57.5000;
	points[53] = (-3941.9292, 18162.5977, 3597.1064);
	angles[53] = (0, -90, 0);
	at[53] = 58;
	points[54] = (-3941.9292, 18162.5977, 3597.1064);
	angles[54] = (0, -90, 0);
	at[54] = 58.5000;
	points[55] = (-3941.9292, 18139.9609, 3597.1064);
	angles[55] = (0, -90, 0);
	at[55] = 60.5000;
	points[56] = (-3941.9292, 18139.9609, 3597.1064);
	angles[56] = (0, -90, 0);
	at[56] = 61;
	points[57] = (-3941.9292, 18117.3223, 3597.1064);
	angles[57] = (0, -90, 0);
	at[57] = 63;
	points[58] = (-3941.9292, 18115.5117, 3597.1064);
	angles[58] = (0, -90, 0);
	at[58] = 64;
	points[59] = (-3941.9292, 18129.5273, 3597.1064);
	angles[59] = (0, -90, 0);
	at[59] = 65;
	points[60] = (-3941.9292, 18130.2363, 3597.1064);
	angles[60] = (0, -90, 0);
	at[60] = 65.5000;
	points[61] = (-3941.9292, 18137.7969, 3597.1064);
	angles[61] = (0, -90, 0);
	at[61] = 66;
	points[62] = (-3941.9292, 18138.1504, 3597.1064);
	angles[62] = (0, -90, 0);
	at[62] = 66.5000;
	points[63] = (-3941.9292, 18152.2051, 3597.1064);
	angles[63] = (0, -90, 0);
	at[63] = 67.5000;
	points[64] = (-3941.9292, 18152.9141, 3597.1064);
	angles[64] = (0, -90, 0);
	at[64] = 68;
	points[65] = (-3941.9292, 18160.4336, 3597.1064);
	angles[65] = (0, -90, 0);
	at[65] = 68.5000;
	points[66] = (-3941.9292, 18160.7871, 3597.1064);
	angles[66] = (0, -90, 0);
	at[66] = 69;
	points[67] = (-3941.9292, 18174.8418, 3597.1064);
	angles[67] = (0, -90, 0);
	at[67] = 70;
	points[68] = (-3941.9292, 18175.5508, 3597.1064);
	angles[68] = (0, -90, 0);
	at[68] = 70.5000;
	points[69] = (-3941.9292, 18183.0723, 3597.1064);
	angles[69] = (0, -90, 0);
	at[69] = 71;
	points[70] = (-3941.9292, 18183.4258, 3597.1064);
	angles[70] = (0, -90, 0);
	at[70] = 71.5000;
	points[71] = (-3941.9292, 18197.4805, 3597.1064);
	angles[71] = (0, -90, 0);
	at[71] = 72.5000;
	points[72] = (-3941.9292, 18198.1895, 3597.1064);
	angles[72] = (0, -90, 0);
	at[72] = 73;
	points[73] = (-3941.9292, 18205.7480, 3597.1064);
	angles[73] = (0, -90, 0);
	at[73] = 73.5000;
	points[74] = (-3941.9292, 18206.0625, 3597.1064);
	angles[74] = (0, -90, 0);
	at[74] = 74;
	points[75] = (-3941.9292, 18220.1172, 3597.1064);
	angles[75] = (0, -90, 0);
	at[75] = 75;
	points[76] = (-3941.9292, 18220.8262, 3597.1064);
	angles[76] = (0, -90, 0);
	at[76] = 75.5000;
	points[77] = (-3941.9292, 18228.3867, 3597.1064);
	angles[77] = (0, -90, 0);
	at[77] = 76;
	points[78] = (-3941.9292, 18228.7402, 3597.1064);
	angles[78] = (0, -90, 0);
	at[78] = 76.5000;
	points[79] = (-3941.9292, 18242.7559, 3597.1064);
	angles[79] = (0, -90, 0);
	at[79] = 77.5000;
	points[80] = (-3941.9292, 18243.4648, 3597.1064);
	angles[80] = (0, -90, 0);
	at[80] = 78;
	points[81] = (-3941.9292, 18251.0234, 3597.1064);
	angles[81] = (0, -90, 0);
	at[81] = 78.5000;
	points[82] = (-3941.9292, 18251.3770, 3597.1064);
	angles[82] = (0, -90, 0);
	at[82] = 79;
	points[83] = (-3941.9292, 18265.3945, 3597.1064);
	angles[83] = (0, -90, 0);
	at[83] = 80;
	points[84] = (-3941.9292, 18266.1035, 3597.1064);
	angles[84] = (0, -90, 0);
	at[84] = 80.5000;
	points[85] = (-3941.9292, 18273.6621, 3597.1064);
	angles[85] = (0, -90, 0);
	at[85] = 81;
	points[86] = (-3941.9292, 18274.0156, 3597.1064);
	angles[86] = (0, -90, 0);
	at[86] = 81.5000;
	points[87] = (-3941.9292, 18288.0312, 3597.1064);
	angles[87] = (0, -90, 0);
	at[87] = 82.5000;
	points[88] = (-3941.9292, 18288.7402, 3597.1064);
	angles[88] = (0, -90, 0);
	at[88] = 83;
	points[89] = (-3941.9292, 18296.3008, 3597.1064);
	angles[89] = (0, -90, 0);
	at[89] = 83.5000;
	points[90] = (-3941.9292, 18296.6523, 3597.1064);
	angles[90] = (0, -90, 0);
	at[90] = 84;
	points[91] = (-3941.9292, 18310.7090, 3597.1064);
	angles[91] = (0, -90, 0);
	at[91] = 85;
	points[92] = (-3941.9292, 18311.3789, 3597.1064);
	angles[92] = (0, -90, 0);
	at[92] = 85.5000;
	points[93] = (-3941.9292, 18318.9375, 3597.1064);
	angles[93] = (0, -90, 0);
	at[93] = 86;
	points[94] = (-3941.9292, 18319.2910, 3597.1064);
	angles[94] = (0, -90, 0);
	at[94] = 86.5000;
	points[95] = (-3941.9292, 18333.3457, 3597.1064);
	angles[95] = (0, -90, 0);
	at[95] = 87.5000;
	points[96] = (-3941.9292, 18334.0547, 3597.1064);
	angles[96] = (0, -90, 0);
	at[96] = 88;
	points[97] = (-3941.9292, 18341.5762, 3597.1064);
	angles[97] = (0, -90, 0);
	at[97] = 88.5000;
	points[98] = (-3941.9292, 18341.9297, 3597.1064);
	angles[98] = (0, -90, 0);
	at[98] = 89;
	points[99] = (-3941.9292, 18355.9844, 3597.1221);
	angles[99] = (0, -90, 0);
	at[99] = 90;
	points[100] = (-3941.9292, 18356.6934, 3597.1890);
	angles[100] = (0, -90, 0);
	at[100] = 90.5000;
	points[101] = (-3941.9292, 18364.2520, 3597.9175);
	angles[101] = (0, -90, 0);
	at[101] = 91;
	points[102] = (-3941.9292, 18364.6074, 3597.9490);
	angles[102] = (0, -90, 0);
	at[102] = 91.5000;
	points[103] = (-3941.9292, 18378.6211, 3599.2993);
	angles[103] = (0, -90, 0);
	at[103] = 92.5000;
	points[104] = (-3941.9292, 18379.3301, 3599.3660);
	angles[104] = (0, -90, 0);
	at[104] = 93;
	points[105] = (-3941.9292, 18386.8906, 3600.0945);
	angles[105] = (0, -90, 0);
	at[105] = 93.5000;
	points[106] = (-3941.9292, 18387.2441, 3600.1260);
	angles[106] = (0, -90, 0);
	at[106] = 94;
	points[107] = (-3941.9292, 18401.2598, 3601.4766);
	angles[107] = (0, -90, 0);
	at[107] = 95;
	points[108] = (-3941.9292, 18401.9688, 3601.5435);
	angles[108] = (0, -90, 0);
	at[108] = 95.5000;
	points[109] = (-3941.9292, 18409.5273, 3602.2717);
	angles[109] = (0, -90, 0);
	at[109] = 96;
	points[110] = (-3941.9292, 18409.8809, 3602.3030);
	angles[110] = (0, -90, 0);
	at[110] = 96.5000;
	points[111] = (-3941.9292, 18423.8984, 3603.6536);
	angles[111] = (0, -90, 0);
	at[111] = 97.5000;
	points[112] = (-3941.9292, 18424.6055, 3603.7205);
	angles[112] = (0, -90, 0);
	at[112] = 98;
	points[113] = (-3941.9292, 18432.1660, 3604.4451);
	angles[113] = (0, -90, 0);
	at[113] = 98.5000;
	points[114] = (-3941.9292, 18432.5195, 3604.4805);
	angles[114] = (0, -90, 0);
	at[114] = 99;
	points[115] = (-3941.9292, 18446.5352, 3605.8306);
	angles[115] = (0, -90, 0);
	at[115] = 100;
	points[116] = (-3941.9292, 18447.2441, 3605.8977);
	angles[116] = (0, -90, 0);
	at[116] = 100.5000;
	points[117] = (-3941.9292, 18454.8047, 3606.6221);
	angles[117] = (0, -90, 0);
	at[117] = 101;
	points[118] = (-3941.9292, 18455.1562, 3606.6575);
	angles[118] = (0, -90, 0);
	at[118] = 101.5000;
	points[119] = (-3941.9292, 18469.2129, 3607.9766);
	angles[119] = (0, -90, 0);
	at[119] = 102.5000;
	points[120] = (-3941.9292, 18469.8828, 3608.0396);
	angles[120] = (0, -90, 0);
	at[120] = 103;
	points[121] = (-3941.9292, 18477.4414, 3608.7441);
	angles[121] = (0, -90, 0);
	at[121] = 103.5000;
	points[122] = (-3941.9292, 18477.7949, 3608.7795);
	angles[122] = (0, -90, 0);
	at[122] = 104;
	points[123] = (-3941.9292, 18491.8496, 3610.0867);
	angles[123] = (0, -90, 0);
	at[123] = 105;
	points[124] = (-3941.9292, 18492.5586, 3610.1536);
	angles[124] = (0, -90, 0);
	at[124] = 105.5000;
	points[125] = (-3941.9292, 18500.0801, 3610.8582);
	angles[125] = (0, -90, 0);
	at[125] = 106;
	points[126] = (-3941.9292, 18500.4336, 3610.8896);
	angles[126] = (0, -90, 0);
	at[126] = 106.5000;
	points[127] = (-3941.9292, 18514.4883, 3612.2009);
	angles[127] = (0, -90, 0);
	at[127] = 107.5000;
	points[128] = (-3941.9292, 18515.1973, 3612.2678);
	angles[128] = (0, -90, 0);
	at[128] = 108;
	points[129] = (-3941.9292, 18522.7168, 3612.9685);
	angles[129] = (0, -90, 0);
	at[129] = 108.5000;
	points[130] = (-3941.9292, 18523.0703, 3613.0042);
	angles[130] = (0, -90, 0);
	at[130] = 109;
	points[131] = (-3941.9292, 18537.1250, 3614.3110);
	angles[131] = (0, -90, 0);
	at[131] = 110;
	points[132] = (-3941.9292, 18537.8340, 3614.3779);
	angles[132] = (0, -90, 0);
	at[132] = 110.5000;
	points[133] = (-3941.9292, 18545.3945, 3615.0825);
	angles[133] = (0, -90, 0);
	at[133] = 111;
	points[134] = (-3941.9292, 18545.7480, 3615.1182);
	angles[134] = (0, -90, 0);
	at[134] = 111.5000;
	points[135] = (-3941.9292, 18559.7637, 3616.4253);
	angles[135] = (0, -90, 0);
	at[135] = 112.5000;
	points[136] = (-3941.9292, 18560.4727, 3616.4922);
	angles[136] = (0, -90, 0);
	at[136] = 113;
	points[137] = (-3941.9292, 18568.0312, 3617.1970);
	angles[137] = (0, -90, 0);
	at[137] = 113.5000;
	points[138] = (-3941.9292, 18568.3867, 3617.2285);
	angles[138] = (0, -90, 0);
	at[138] = 114;
	points[139] = (-3941.9292, 18582.4023, 3618.5393);
	angles[139] = (0, -90, 0);
	at[139] = 115;
	points[140] = (-3941.9292, 18583.1094, 3618.6023);
	angles[140] = (0, -90, 0);
	at[140] = 115.5000;
	points[141] = (-3941.9292, 18590.6699, 3619.3071);
	angles[141] = (0, -90, 0);
	at[141] = 116;
	points[142] = (-3941.9292, 18591.0234, 3619.3425);
	angles[142] = (0, -90, 0);
	at[142] = 116.5000;
	points[143] = (-3941.9292, 18605.0391, 3620.6497);
	angles[143] = (0, -90, 0);
	at[143] = 117.5000;
	points[144] = (-3941.9292, 18605.7480, 3620.7166);
	angles[144] = (0, -90, 0);
	at[144] = 118;
	points[145] = (-3941.9292, 18613.3086, 3621.4214);
	angles[145] = (0, -90, 0);
	at[145] = 118.5000;
	points[146] = (-3941.9292, 18613.6621, 3621.4529);
	angles[146] = (0, -90, 0);
	at[146] = 119;
	points[147] = (-3941.9292, 18627.6777, 3622.7639);
	angles[147] = (0, -90, 0);
	at[147] = 120;
	points[148] = (-3941.9292, 18628.3867, 3622.8306);
	angles[148] = (0, -90, 0);
	at[148] = 120.5000;
	points[149] = (-3941.9292, 18635.9453, 3623.5315);
	angles[149] = (0, -90, 0);
	at[149] = 121;
	points[150] = (-3941.9292, 18636.2988, 3623.5669);
	angles[150] = (0, -90, 0);
	at[150] = 121.5000;
	points[151] = (-3941.9292, 18650.3535, 3624.8740);
	angles[151] = (0, -90, 0);
	at[151] = 122.5000;
	points[152] = (-3941.9292, 18651.0625, 3624.9412);
	angles[152] = (0, -90, 0);
	at[152] = 123;
	points[153] = (-3941.9292, 18658.5840, 3625.6458);
	angles[153] = (0, -90, 0);
	at[153] = 123.5000;
	points[154] = (-3941.9292, 18658.9375, 3625.6772);
	angles[154] = (0, -90, 0);
	at[154] = 124;
	points[155] = (-3941.9292, 18672.9922, 3626.9883);
	angles[155] = (0, -90, 0);
	at[155] = 125;
	points[156] = (-3941.9292, 18673.7012, 3627.0552);
	angles[156] = (0, -90, 0);
	at[156] = 125.5000;
	points[157] = (-3941.9292, 18681.2207, 3627.7600);
	angles[157] = (0, -90, 0);
	at[157] = 126;
	points[158] = (-3941.9292, 18681.5742, 3627.7913);
	angles[158] = (0, -90, 0);
	at[158] = 126.5000;
	points[159] = (-3941.9292, 18688.7793, 3628.4607);
	angles[159] = (0, -90, 0);
	at[159] = 127;
	points[160] = (-3941.9292, 18690.9453, 3628.6653);
	angles[160] = (0, -90, 0);
	at[160] = 127.5000;
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
	points[0] = (-5226.2993, 17819.8418, 3593.8386);
	angles[0] = (0, -19, 0);
	at[0] = 0;
	points[1] = (-5219.9214, 17817.6387, 3593.7363);
	angles[1] = (0, -19, 0);
	at[1] = 0.4167;
	points[2] = (-5219.2124, 17817.4023, 3593.7246);
	angles[2] = (0, -19, 0);
	at[2] = 0.8333;
	points[3] = (-5212.7563, 17815.1973, 3593.6221);
	angles[3] = (0, -19, 0);
	at[3] = 1.2500;
	points[4] = (-5212.0864, 17814.9609, 3593.6104);
	angles[4] = (0, -19, 0);
	at[4] = 1.6667;
	points[5] = (-5205.6304, 17812.7168, 3593.5081);
	angles[5] = (0, -19, 0);
	at[5] = 2.0833;
	points[6] = (-5204.9604, 17812.4805, 3593.5002);
	angles[6] = (0, -19, 0);
	at[6] = 2.5000;
	points[7] = (-5198.4648, 17810.2363, 3593.3977);
	angles[7] = (0, -19, 0);
	at[7] = 2.9167;
	points[8] = (-5197.7954, 17810.0391, 3593.3860);
	angles[8] = (0, -19, 0);
	at[8] = 3.3333;
	points[9] = (-5191.3389, 17807.7949, 3593.2834);
	angles[9] = (0, -19, 0);
	at[9] = 3.7500;
	points[10] = (-5190.6694, 17807.5605, 3593.2715);
	angles[10] = (0, -19, 0);
	at[10] = 4.1667;
	points[11] = (-5184.1729, 17805.3145, 3593.1694);
	angles[11] = (0, -19, 0);
	at[11] = 4.5833;
	points[12] = (-5183.5039, 17805.0781, 3593.1575);
	angles[12] = (0, -19, 0);
	at[12] = 5;
	points[13] = (-5177.0469, 17802.8730, 3593.0552);
	angles[13] = (0, -19, 0);
	at[13] = 5.4167;
	points[14] = (-5176.3779, 17802.6387, 3593.0471);
	angles[14] = (0, -19, 0);
	at[14] = 5.8333;
	points[15] = (-5169.8818, 17800.3945, 3592.9409);
	angles[15] = (0, -19, 0);
	at[15] = 6.2500;
	points[16] = (-5169.2129, 17800.1582, 3592.9331);
	angles[16] = (0, -19, 0);
	at[16] = 6.6667;
	points[17] = (-5162.7559, 17797.9531, 3592.8306);
	angles[17] = (0, -19, 0);
	at[17] = 7.0833;
	points[18] = (-5162.0869, 17797.7168, 3592.8188);
	angles[18] = (0, -19, 0);
	at[18] = 7.5000;
	points[19] = (-5155.5903, 17795.4727, 3592.7166);
	angles[19] = (0, -19, 0);
	at[19] = 7.9167;
	points[20] = (-5154.9214, 17795.2363, 3592.7048);
	angles[20] = (0, -19, 0);
	at[20] = 8.3333;
	points[21] = (-5148.4644, 17792.9922, 3592.6023);
	angles[21] = (0, -19, 0);
	at[21] = 8.7500;
	points[22] = (-5147.7954, 17792.7969, 3592.5945);
	angles[22] = (0, -19, 0);
	at[22] = 9.1667;
	points[23] = (-5141.2993, 17790.5508, 3592.4883);
	angles[23] = (0, -19, 0);
	at[23] = 9.5833;
	points[24] = (-5140.6304, 17790.3145, 3592.4805);
	angles[24] = (0, -19, 0);
	at[24] = 10;
	points[25] = (-5134.1733, 17788.0703, 3592.3779);
	angles[25] = (0, -19, 0);
	at[25] = 10.4167;
	points[26] = (-5133.5044, 17787.8359, 3592.3662);
	angles[26] = (0, -19, 0);
	at[26] = 10.8333;
	points[27] = (-5127.0078, 17785.6309, 3592.2639);
	angles[27] = (0, -19, 0);
	at[27] = 11.2500;
	points[28] = (-5126.3389, 17785.3945, 3592.2522);
	angles[28] = (0, -19, 0);
	at[28] = 11.6667;
	points[29] = (-5119.8818, 17783.1484, 3592.1497);
	angles[29] = (0, -19, 0);
	at[29] = 12.0833;
	points[30] = (-5119.2129, 17782.9141, 3592.1379);
	angles[30] = (0, -19, 0);
	at[30] = 12.5000;
	points[31] = (-5112.7168, 17780.7090, 3592.0356);
	angles[31] = (0, -19, 0);
	at[31] = 12.9167;
	points[32] = (-5112.0469, 17780.4727, 3592.0278);
	angles[32] = (0, -19, 0);
	at[32] = 13.3333;
	points[33] = (-5105.5908, 17778.2285, 3591.9253);
	angles[33] = (0, -19, 0);
	at[33] = 13.7500;
	points[34] = (-5104.9209, 17777.9922, 3591.9133);
	angles[34] = (0, -19, 0);
	at[34] = 14.1667;
	points[35] = (-5098.4253, 17775.7480, 3591.8110);
	angles[35] = (0, -19, 0);
	at[35] = 14.5833;
	points[36] = (-5097.7559, 17775.5117, 3591.7991);
	angles[36] = (0, -19, 0);
	at[36] = 15;
	points[37] = (-5091.2993, 17773.3066, 3591.6970);
	angles[37] = (0, -19, 0);
	at[37] = 15.4167;
	points[38] = (-5090.6299, 17773.0703, 3591.6851);
	angles[38] = (0, -19, 0);
	at[38] = 15.8333;
	points[39] = (-5084.1338, 17770.8262, 3591.5825);
	angles[39] = (0, -19, 0);
	at[39] = 16.2500;
	points[40] = (-5083.4644, 17770.5898, 3591.5747);
	angles[40] = (0, -19, 0);
	at[40] = 16.6667;
	points[41] = (-5077.0078, 17768.3848, 3591.4724);
	angles[41] = (0, -19, 0);
	at[41] = 17.0833;
	points[42] = (-5076.3384, 17768.1504, 3591.4607);
	angles[42] = (0, -19, 0);
	at[42] = 17.5000;
	points[43] = (-5069.8428, 17765.9062, 3591.3582);
	angles[43] = (0, -19, 0);
	at[43] = 17.9167;
	points[44] = (-5069.1733, 17765.6699, 3591.3464);
	angles[44] = (0, -19, 0);
	at[44] = 18.3333;
	points[45] = (-5062.7168, 17763.4258, 3591.2441);
	angles[45] = (0, -19, 0);
	at[45] = 18.7500;
	points[46] = (-5062.0474, 17763.2285, 3591.2324);
	angles[46] = (0, -19, 0);
	at[46] = 19.1667;
	points[47] = (-5055.5513, 17760.9844, 3591.1299);
	angles[47] = (0, -19, 0);
	at[47] = 19.5833;
	points[48] = (-5054.8818, 17760.7480, 3591.1221);
	angles[48] = (0, -19, 0);
	at[48] = 20;
	points[49] = (-5048.4253, 17758.5039, 3591.0159);
	angles[49] = (0, -19, 0);
	at[49] = 20.4167;
	points[50] = (-5047.7559, 17758.2676, 3591.0081);
	angles[50] = (0, -19, 0);
	at[50] = 20.8333;
	points[51] = (-5041.2603, 17756.0625, 3590.9055);
	angles[51] = (0, -19, 0);
	at[51] = 21.2500;
	points[52] = (-5040.5908, 17755.8262, 3590.8938);
	angles[52] = (0, -19, 0);
	at[52] = 21.6667;
	points[53] = (-5034.1338, 17753.5840, 3590.7915);
	angles[53] = (0, -19, 0);
	at[53] = 22.0833;
	points[54] = (-5033.4644, 17753.3457, 3590.7798);
	angles[54] = (0, -19, 0);
	at[54] = 22.5000;
	points[55] = (-5026.9683, 17751.1016, 3590.6772);
	angles[55] = (0, -19, 0);
	at[55] = 22.9167;
	points[56] = (-5026.2993, 17750.9043, 3590.6655);
	angles[56] = (0, -19, 0);
	at[56] = 23.3333;
	points[57] = (-5019.8423, 17748.6621, 3590.5632);
	angles[57] = (0, -19, 0);
	at[57] = 23.7500;
	points[58] = (-5019.1733, 17748.4258, 3590.5554);
	angles[58] = (0, -19, 0);
	at[58] = 24.1667;
	points[59] = (-5012.6772, 17746.1816, 3590.4529);
	angles[59] = (0, -19, 0);
	at[59] = 24.5833;
	points[60] = (-5012.0078, 17745.9453, 3590.4409);
	angles[60] = (0, -19, 0);
	at[60] = 25;
	points[61] = (-5005.5513, 17743.7402, 3590.3386);
	angles[61] = (0, -19, 0);
	at[61] = 25.4167;
	points[62] = (-5004.8818, 17743.5039, 3590.3267);
	angles[62] = (0, -19, 0);
	at[62] = 25.8333;
	points[63] = (-4998.3857, 17741.2598, 3590.2246);
	angles[63] = (0, -19, 0);
	at[63] = 26.2500;
	points[64] = (-4997.7168, 17741.0234, 3590.2126);
	angles[64] = (0, -19, 0);
	at[64] = 26.6667;
	points[65] = (-4991.2598, 17738.8203, 3590.1101);
	angles[65] = (0, -19, 0);
	at[65] = 27.0833;
	points[66] = (-4990.5908, 17738.5820, 3590.1023);
	angles[66] = (0, -19, 0);
	at[66] = 27.5000;
	points[67] = (-4984.0947, 17736.3379, 3590);
	angles[67] = (0, -19, 0);
	at[67] = 27.9167;
	points[68] = (-4983.4253, 17736.1035, 3589.9883);
	angles[68] = (0, -19, 0);
	at[68] = 28.3333;
	points[69] = (-4976.9688, 17733.8594, 3589.8857);
	angles[69] = (0, -19, 0);
	at[69] = 28.7500;
	points[70] = (-4976.2993, 17733.6621, 3589.8740);
	angles[70] = (0, -19, 0);
	at[70] = 29.1667;
	points[71] = (-4969.8032, 17731.4180, 3589.7717);
	angles[71] = (0, -19, 0);
	at[71] = 29.5833;
	points[72] = (-4969.1343, 17731.1816, 3589.7600);
	angles[72] = (0, -19, 0);
	at[72] = 30;
	points[73] = (-4962.6772, 17728.9375, 3589.6575);
	angles[73] = (0, -19, 0);
	at[73] = 30.4167;
	points[74] = (-4962.0083, 17728.7012, 3589.6497);
	angles[74] = (0, -19, 0);
	at[74] = 30.8333;
	points[75] = (-4955.5122, 17726.4961, 3589.5474);
	angles[75] = (0, -19, 0);
	at[75] = 31.2500;
	points[76] = (-4954.8423, 17726.2598, 3589.5356);
	angles[76] = (0, -19, 0);
	at[76] = 31.6667;
	points[77] = (-4948.3862, 17724.0156, 3589.4331);
	angles[77] = (0, -19, 0);
	at[77] = 32.0833;
	points[78] = (-4947.7163, 17723.7793, 3589.4214);
	angles[78] = (0, -19, 0);
	at[78] = 32.5000;
	points[79] = (-4941.2207, 17721.5742, 3589.3191);
	angles[79] = (0, -19, 0);
	at[79] = 32.9167;
	points[80] = (-4940.5513, 17721.3398, 3589.3074);
	angles[80] = (0, -19, 0);
	at[80] = 33.3333;
	points[81] = (-4934.0942, 17719.0957, 3589.2048);
	angles[81] = (0, -19, 0);
	at[81] = 33.7500;
	points[82] = (-4933.4253, 17718.8574, 3589.1929);
	angles[82] = (0, -19, 0);
	at[82] = 34.1667;
	points[83] = (-4926.9292, 17716.6152, 3589.0908);
	angles[83] = (0, -19, 0);
	at[83] = 34.5833;
	points[84] = (-4926.2598, 17716.3789, 3589.0825);
	angles[84] = (0, -19, 0);
	at[84] = 35;
	points[85] = (-4919.8032, 17714.1738, 3588.9805);
	angles[85] = (0, -19, 0);
	at[85] = 35.4167;
	points[86] = (-4919.1338, 17713.9375, 3588.9685);
	angles[86] = (0, -19, 0);
	at[86] = 35.8333;
	points[87] = (-4912.6377, 17711.6934, 3588.8662);
	angles[87] = (0, -19, 0);
	at[87] = 36.2500;
	points[88] = (-4911.9688, 17711.4570, 3588.8542);
	angles[88] = (0, -19, 0);
	at[88] = 36.6667;
	points[89] = (-4905.5117, 17709.2520, 3588.7520);
	angles[89] = (0, -19, 0);
	at[89] = 37.0833;
	points[90] = (-4904.8428, 17709.0156, 3588.7441);
	angles[90] = (0, -19, 0);
	at[90] = 37.5000;
	points[91] = (-4898.3467, 17706.7715, 3588.6377);
	angles[91] = (0, -19, 0);
	at[91] = 37.9167;
	points[92] = (-4897.6772, 17706.5352, 3588.6299);
	angles[92] = (0, -19, 0);
	at[92] = 38.3333;
	points[93] = (-4891.2207, 17704.2910, 3588.5276);
	angles[93] = (0, -19, 0);
	at[93] = 38.7500;
	points[94] = (-4890.5513, 17704.0938, 3588.5159);
	angles[94] = (0, -19, 0);
	at[94] = 39.1667;
	points[95] = (-4884.0552, 17701.8516, 3588.4133);
	angles[95] = (0, -19, 0);
	at[95] = 39.5833;
	points[96] = (-4883.3857, 17701.6152, 3588.4016);
	angles[96] = (0, -19, 0);
	at[96] = 40;
	points[97] = (-4876.9292, 17699.3691, 3588.2993);
	angles[97] = (0, -19, 0);
	at[97] = 40.4167;
	points[98] = (-4876.2598, 17699.1348, 3588.2876);
	angles[98] = (0, -19, 0);
	at[98] = 40.8333;
	points[99] = (-4869.7637, 17696.9297, 3588.1851);
	angles[99] = (0, -19, 0);
	at[99] = 41.2500;
	points[100] = (-4869.0947, 17696.6934, 3588.1772);
	angles[100] = (0, -19, 0);
	at[100] = 41.6667;
	points[101] = (-4862.6377, 17694.4492, 3588.0750);
	angles[101] = (0, -19, 0);
	at[101] = 42.0833;
	points[102] = (-4861.9688, 17694.2129, 3588.0632);
	angles[102] = (0, -19, 0);
	at[102] = 42.5000;
	points[103] = (-4855.4727, 17691.9688, 3587.9607);
	angles[103] = (0, -19, 0);
	at[103] = 42.9167;
	points[104] = (-4854.8032, 17691.7715, 3587.9490);
	angles[104] = (0, -19, 0);
	at[104] = 43.3333;
	points[105] = (-4848.3467, 17689.5273, 3587.8467);
	angles[105] = (0, -19, 0);
	at[105] = 43.7500;
	points[106] = (-4847.6772, 17689.2930, 3587.8345);
	angles[106] = (0, -19, 0);
	at[106] = 44.1667;
	points[107] = (-4841.1812, 17687.0469, 3587.7324);
	angles[107] = (0, -19, 0);
	at[107] = 44.5833;
	points[108] = (-4840.5117, 17686.8105, 3587.7244);
	angles[108] = (0, -19, 0);
	at[108] = 45;
	points[109] = (-4834.0552, 17684.6055, 3587.6223);
	angles[109] = (0, -19, 0);
	at[109] = 45.4167;
	points[110] = (-4833.3857, 17684.3711, 3587.6101);
	angles[110] = (0, -19, 0);
	at[110] = 45.8333;
	points[111] = (-4826.8896, 17682.1270, 3587.5081);
	angles[111] = (0, -19, 0);
	at[111] = 46.2500;
	points[112] = (-4826.2207, 17681.8906, 3587.4961);
	angles[112] = (0, -19, 0);
	at[112] = 46.6667;
	points[113] = (-4819.7637, 17679.6855, 3587.3936);
	angles[113] = (0, -19, 0);
	at[113] = 47.0833;
	points[114] = (-4819.0947, 17679.4492, 3587.3818);
	angles[114] = (0, -19, 0);
	at[114] = 47.5000;
	points[115] = (-4812.5986, 17677.2051, 3587.2795);
	angles[115] = (0, -19, 0);
	at[115] = 47.9167;
	points[116] = (-4811.9292, 17676.9688, 3587.2678);
	angles[116] = (0, -19, 0);
	at[116] = 48.3333;
	points[117] = (-4805.4727, 17674.7246, 3587.4685);
	angles[117] = (0, -19, 0);
	at[117] = 48.7500;
	points[118] = (-4804.8032, 17674.4883, 3587.4961);
	angles[118] = (0, -19, 0);
	at[118] = 49.1667;
	points[119] = (-4798.3071, 17672.2832, 3587.7520);
	angles[119] = (0, -19, 0);
	at[119] = 49.5833;
	points[120] = (-4804.6851, 17674.4883, 3587.5000);
	angles[120] = (0, -19, 0);
	at[120] = 50;
	points[121] = (-4805.3545, 17674.7246, 3587.4727);
	angles[121] = (0, -19, 0);
	at[121] = 50.4167;
	points[122] = (-4811.8506, 17676.9297, 3587.2678);
	angles[122] = (0, -19, 0);
	at[122] = 50.8333;
	points[123] = (-4812.5195, 17677.1660, 3587.2795);
	angles[123] = (0, -19, 0);
	at[123] = 51.2500;
	points[124] = (-4818.9766, 17679.4102, 3587.3818);
	angles[124] = (0, -19, 0);
	at[124] = 51.6667;
	points[125] = (-4819.6455, 17679.6445, 3587.3936);
	angles[125] = (0, -19, 0);
	at[125] = 52.0833;
	points[126] = (-4826.1416, 17681.8496, 3587.4961);
	angles[126] = (0, -19, 0);
	at[126] = 52.5000;
	points[127] = (-4826.8110, 17682.0859, 3587.5039);
	angles[127] = (0, -19, 0);
	at[127] = 52.9167;
	points[128] = (-4833.2676, 17684.3320, 3587.6062);
	angles[128] = (0, -19, 0);
	at[128] = 53.3333;
	points[129] = (-4833.9370, 17684.5664, 3587.6184);
	angles[129] = (0, -19, 0);
	at[129] = 53.7500;
	points[130] = (-4840.4331, 17686.8105, 3587.7205);
	angles[130] = (0, -19, 0);
	at[130] = 54.1667;
	points[131] = (-4841.1025, 17687.0469, 3587.7324);
	angles[131] = (0, -19, 0);
	at[131] = 54.5833;
	points[132] = (-4847.5591, 17689.2520, 3587.8345);
	angles[132] = (0, -19, 0);
	at[132] = 55;
	points[133] = (-4848.2285, 17689.4883, 3587.8467);
	angles[133] = (0, -19, 0);
	at[133] = 55.4167;
	points[134] = (-4854.7246, 17691.7324, 3587.9490);
	angles[134] = (0, -19, 0);
	at[134] = 55.8333;
	points[135] = (-4855.3940, 17691.9688, 3587.9568);
	angles[135] = (0, -19, 0);
	at[135] = 56.2500;
	points[136] = (-4861.8506, 17694.1738, 3588.0593);
	angles[136] = (0, -19, 0);
	at[136] = 56.6667;
	points[137] = (-4862.5200, 17694.4102, 3588.0710);
	angles[137] = (0, -19, 0);
	at[137] = 57.0833;
	points[138] = (-4869.0156, 17696.6543, 3588.1733);
	angles[138] = (0, -19, 0);
	at[138] = 57.5000;
	points[139] = (-4869.6851, 17696.8906, 3588.1851);
	angles[139] = (0, -19, 0);
	at[139] = 57.9167;
	points[140] = (-4876.1416, 17699.1348, 3588.2876);
	angles[140] = (0, -19, 0);
	at[140] = 58.3333;
	points[141] = (-4876.8110, 17699.3301, 3588.2993);
	angles[141] = (0, -19, 0);
	at[141] = 58.7500;
	points[142] = (-4883.3071, 17701.5742, 3588.4016);
	angles[142] = (0, -19, 0);
	at[142] = 59.1667;
	points[143] = (-4883.9766, 17701.8105, 3588.4133);
	angles[143] = (0, -19, 0);
	at[143] = 59.5833;
	points[144] = (-4890.4331, 17704.0566, 3588.5159);
	angles[144] = (0, -19, 0);
	at[144] = 60;
	points[145] = (-4891.1025, 17704.2910, 3588.5237);
	angles[145] = (0, -19, 0);
	at[145] = 60.4167;
	points[146] = (-4897.5986, 17706.4961, 3588.6260);
	angles[146] = (0, -19, 0);
	at[146] = 60.8333;
	points[147] = (-4898.2676, 17706.7324, 3588.6377);
	angles[147] = (0, -19, 0);
	at[147] = 61.2500;
	points[148] = (-4904.7246, 17708.9766, 3588.7402);
	angles[148] = (0, -19, 0);
	at[148] = 61.6667;
	points[149] = (-4905.3936, 17709.2129, 3588.7520);
	angles[149] = (0, -19, 0);
	at[149] = 62.0833;
	points[150] = (-4911.8896, 17711.4180, 3588.8542);
	angles[150] = (0, -19, 0);
	at[150] = 62.5000;
	points[151] = (-4912.5591, 17711.6543, 3588.8662);
	angles[151] = (0, -19, 0);
	at[151] = 62.9167;
	points[152] = (-4919.0156, 17713.8984, 3588.9685);
	angles[152] = (0, -19, 0);
	at[152] = 63.3333;
	points[153] = (-4919.6851, 17714.1348, 3588.9766);
	angles[153] = (0, -19, 0);
	at[153] = 63.7500;
	points[154] = (-4926.1812, 17716.3789, 3589.0786);
	angles[154] = (0, -19, 0);
	at[154] = 64.1667;
	points[155] = (-4926.8506, 17716.6152, 3589.0908);
	angles[155] = (0, -19, 0);
	at[155] = 64.5833;
	points[156] = (-4933.3071, 17718.8203, 3589.1929);
	angles[156] = (0, -19, 0);
	at[156] = 65;
	points[157] = (-4933.9766, 17719.0547, 3589.2048);
	angles[157] = (0, -19, 0);
	at[157] = 65.4167;
	points[158] = (-4940.4727, 17721.2988, 3589.3074);
	angles[158] = (0, -19, 0);
	at[158] = 65.8333;
	points[159] = (-4941.1416, 17721.5371, 3589.3191);
	angles[159] = (0, -19, 0);
	at[159] = 66.2500;
	points[160] = (-4947.5986, 17723.7402, 3589.4214);
	angles[160] = (0, -19, 0);
	at[160] = 66.6667;
	points[161] = (-4948.2676, 17723.9766, 3589.4292);
	angles[161] = (0, -19, 0);
	at[161] = 67.0833;
	points[162] = (-4954.7637, 17726.2207, 3589.5317);
	angles[162] = (0, -19, 0);
	at[162] = 67.5000;
	points[163] = (-4955.4331, 17726.4570, 3589.5435);
	angles[163] = (0, -19, 0);
	at[163] = 67.9167;
	points[164] = (-4961.8896, 17728.7012, 3589.6458);
	angles[164] = (0, -19, 0);
	at[164] = 68.3333;
	points[165] = (-4962.5591, 17728.8984, 3589.6575);
	angles[165] = (0, -19, 0);
	at[165] = 68.7500;
	points[166] = (-4969.0552, 17731.1426, 3589.7600);
	angles[166] = (0, -19, 0);
	at[166] = 69.1667;
	points[167] = (-4969.7246, 17731.3789, 3589.7717);
	angles[167] = (0, -19, 0);
	at[167] = 69.5833;
	points[168] = (-4976.1812, 17733.6211, 3589.8740);
	angles[168] = (0, -19, 0);
	at[168] = 70;
	points[169] = (-4976.8506, 17733.8594, 3589.8818);
	angles[169] = (0, -19, 0);
	at[169] = 70.4167;
	points[170] = (-4983.3467, 17736.0625, 3589.9844);
	angles[170] = (0, -19, 0);
	at[170] = 70.8333;
	points[171] = (-4984.0161, 17736.3008, 3589.9961);
	angles[171] = (0, -19, 0);
	at[171] = 71.2500;
	points[172] = (-4990.4727, 17738.5430, 3590.0984);
	angles[172] = (0, -19, 0);
	at[172] = 71.6667;
	points[173] = (-4991.1421, 17738.7793, 3590.1101);
	angles[173] = (0, -19, 0);
	at[173] = 72.0833;
	points[174] = (-4997.6382, 17740.9844, 3590.2126);
	angles[174] = (0, -19, 0);
	at[174] = 72.5000;
	points[175] = (-4998.3071, 17741.2207, 3590.2246);
	angles[175] = (0, -19, 0);
	at[175] = 72.9167;
	points[176] = (-5004.7642, 17743.4648, 3590.3267);
	angles[176] = (0, -19, 0);
	at[176] = 73.3333;
	points[177] = (-5005.4331, 17743.7012, 3590.3347);
	angles[177] = (0, -19, 0);
	at[177] = 73.7500;
	points[178] = (-5011.9292, 17745.9453, 3590.4409);
	angles[178] = (0, -19, 0);
	at[178] = 74.1667;
	points[179] = (-5012.5986, 17746.1816, 3590.4490);
	angles[179] = (0, -19, 0);
	at[179] = 74.5833;
	points[180] = (-5019.0552, 17748.3848, 3590.5510);
	angles[180] = (0, -19, 0);
	at[180] = 75;
	points[181] = (-5019.7246, 17748.6230, 3590.5632);
	angles[181] = (0, -19, 0);
	at[181] = 75.4167;
	points[182] = (-5026.2207, 17750.8672, 3590.6655);
	angles[182] = (0, -19, 0);
	at[182] = 75.8333;
	points[183] = (-5026.8896, 17751.1016, 3590.6772);
	angles[183] = (0, -19, 0);
	at[183] = 76.2500;
	points[184] = (-5033.3467, 17753.3066, 3590.7798);
	angles[184] = (0, -19, 0);
	at[184] = 76.6667;
	points[185] = (-5034.0156, 17753.5430, 3590.7915);
	angles[185] = (0, -19, 0);
	at[185] = 77.0833;
	points[186] = (-5040.5122, 17755.7871, 3590.8938);
	angles[186] = (0, -19, 0);
	at[186] = 77.5000;
	points[187] = (-5041.1812, 17756.0234, 3590.9016);
	angles[187] = (0, -19, 0);
	at[187] = 77.9167;
	points[188] = (-5047.6382, 17758.2676, 3591.0042);
	angles[188] = (0, -19, 0);
	at[188] = 78.3333;
	points[189] = (-5048.3071, 17758.4648, 3591.0159);
	angles[189] = (0, -19, 0);
	at[189] = 78.7500;
	points[190] = (-5054.8032, 17760.7090, 3591.1182);
	angles[190] = (0, -19, 0);
	at[190] = 79.1667;
	points[191] = (-5055.4722, 17760.9453, 3591.1299);
	angles[191] = (0, -19, 0);
	at[191] = 79.5833;
	points[192] = (-5061.9292, 17763.1895, 3591.2324);
	angles[192] = (0, -19, 0);
	at[192] = 80;
	points[193] = (-5062.5981, 17763.4258, 3591.2441);
	angles[193] = (0, -19, 0);
	at[193] = 80.4167;
	points[194] = (-5069.0947, 17765.6309, 3591.3464);
	angles[194] = (0, -19, 0);
	at[194] = 80.8333;
	points[195] = (-5069.7642, 17765.8652, 3591.3542);
	angles[195] = (0, -19, 0);
	at[195] = 81.2500;
	points[196] = (-5076.2207, 17768.1113, 3591.4568);
	angles[196] = (0, -19, 0);
	at[196] = 81.6667;
	points[197] = (-5076.8901, 17768.3477, 3591.4685);
	angles[197] = (0, -19, 0);
	at[197] = 82.0833;
	points[198] = (-5083.3857, 17770.5898, 3591.5708);
	angles[198] = (0, -19, 0);
	at[198] = 82.5000;
	points[199] = (-5084.0552, 17770.7871, 3591.5825);
	angles[199] = (0, -19, 0);
	at[199] = 82.9167;
	points[200] = (-5090.5117, 17773.0312, 3591.6851);
	angles[200] = (0, -19, 0);
	at[200] = 83.3333;
	points[201] = (-5091.1812, 17773.2676, 3591.6970);
	angles[201] = (0, -19, 0);
	at[201] = 83.7500;
	points[202] = (-5097.6772, 17775.5117, 3591.7991);
	angles[202] = (0, -19, 0);
	at[202] = 84.1667;
	points[203] = (-5098.3467, 17775.7480, 3591.8074);
	angles[203] = (0, -19, 0);
	at[203] = 84.5833;
	points[204] = (-5104.8032, 17777.9531, 3591.9133);
	angles[204] = (0, -19, 0);
	at[204] = 85;
	points[205] = (-5105.4727, 17778.1895, 3591.9214);
	angles[205] = (0, -19, 0);
	at[205] = 85.4167;
	points[206] = (-5111.9683, 17780.4336, 3592.0234);
	angles[206] = (0, -19, 0);
	at[206] = 85.8333;
	points[207] = (-5112.6377, 17780.6699, 3592.0356);
	angles[207] = (0, -19, 0);
	at[207] = 86.2500;
	points[208] = (-5119.0942, 17782.8750, 3592.1379);
	angles[208] = (0, -19, 0);
	at[208] = 86.6667;
	points[209] = (-5119.7642, 17783.1113, 3592.1497);
	angles[209] = (0, -19, 0);
	at[209] = 87.0833;
	points[210] = (-5126.2598, 17785.3535, 3592.2522);
	angles[210] = (0, -19, 0);
	at[210] = 87.5000;
	points[211] = (-5126.9292, 17785.5898, 3592.2639);
	angles[211] = (0, -19, 0);
	at[211] = 87.9167;
	points[212] = (-5133.3857, 17787.8359, 3592.3662);
	angles[212] = (0, -19, 0);
	at[212] = 88.3333;
	points[213] = (-5134.0552, 17788.0312, 3592.3740);
	angles[213] = (0, -19, 0);
	at[213] = 88.7500;
	points[214] = (-5140.5518, 17790.2754, 3592.4766);
	angles[214] = (0, -19, 0);
	at[214] = 89.1667;
	points[215] = (-5141.2207, 17790.5117, 3592.4883);
	angles[215] = (0, -19, 0);
	at[215] = 89.5833;
	points[216] = (-5147.6777, 17792.7559, 3592.5906);
	angles[216] = (0, -19, 0);
	at[216] = 90;
	points[217] = (-5148.3467, 17792.9922, 3592.6023);
	angles[217] = (0, -19, 0);
	at[217] = 90.4167;
	points[218] = (-5154.8423, 17795.1973, 3592.7048);
	angles[218] = (0, -19, 0);
	at[218] = 90.8333;
	points[219] = (-5155.5117, 17795.4336, 3592.7166);
	angles[219] = (0, -19, 0);
	at[219] = 91.2500;
	points[220] = (-5161.9683, 17797.6777, 3592.8188);
	angles[220] = (0, -19, 0);
	at[220] = 91.6667;
	points[221] = (-5162.6377, 17797.9121, 3592.8267);
	angles[221] = (0, -19, 0);
	at[221] = 92.0833;
	points[222] = (-5169.1343, 17800.1582, 3592.9292);
	angles[222] = (0, -19, 0);
	at[222] = 92.5000;
	points[223] = (-5169.8032, 17800.3535, 3592.9409);
	angles[223] = (0, -19, 0);
	at[223] = 92.9167;
	points[224] = (-5176.2603, 17802.5996, 3593.0432);
	angles[224] = (0, -19, 0);
	at[224] = 93.3333;
	points[225] = (-5176.9292, 17802.8340, 3593.0552);
	angles[225] = (0, -19, 0);
	at[225] = 93.7500;
	points[226] = (-5183.4253, 17805.0781, 3593.1575);
	angles[226] = (0, -19, 0);
	at[226] = 94.1667;
	points[227] = (-5184.0942, 17805.3145, 3593.1694);
	angles[227] = (0, -19, 0);
	at[227] = 94.5833;
	points[228] = (-5190.5513, 17807.5195, 3593.2715);
	angles[228] = (0, -19, 0);
	at[228] = 95;
	points[229] = (-5191.2202, 17807.7559, 3593.2798);
	angles[229] = (0, -19, 0);
	at[229] = 95.4167;
	points[230] = (-5197.7168, 17810, 3593.3818);
	angles[230] = (0, -19, 0);
	at[230] = 95.8333;
	points[231] = (-5198.3857, 17810.2363, 3593.3938);
	angles[231] = (0, -19, 0);
	at[231] = 96.2500;
	points[232] = (-5204.8428, 17812.4414, 3593.4963);
	angles[232] = (0, -19, 0);
	at[232] = 96.6667;
	points[233] = (-5205.5117, 17812.6777, 3593.5081);
	angles[233] = (0, -19, 0);
	at[233] = 97.0833;
	points[234] = (-5212.0078, 17814.9219, 3593.6104);
	angles[234] = (0, -19, 0);
	at[234] = 97.5000;
	points[235] = (-5212.6768, 17815.1582, 3593.6221);
	angles[235] = (0, -19, 0);
	at[235] = 97.9167;
	points[236] = (-5219.1338, 17817.4023, 3593.7246);
	angles[236] = (0, -19, 0);
	at[236] = 98.3333;
	points[237] = (-5219.8027, 17817.6387, 3593.7363);
	angles[237] = (0, -19, 0);
	at[237] = 98.7500;
	points[238] = (-5226.2993, 17819.8418, 3593.8386);
	angles[238] = (0, -19, 0);
	at[238] = 99.1667;
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
	points[0] = (-2583.6929, 18188.9766, 3610.9175);
	angles[0] = (0, -154, 0);
	at[0] = 0;
	points[1] = (-2590.3621, 18185.7480, 3610.7561);
	angles[1] = (0, -154, 0);
	at[1] = 0.4500;
	points[2] = (-2590.4685, 18185.7090, 3610.7520);
	angles[2] = (0, -154, 0);
	at[2] = 0.9000;
	points[3] = (-2597.2717, 18182.4023, 3610.5828);
	angles[3] = (0, -154, 0);
	at[3] = 1.3500;
	points[4] = (-2597.2717, 18182.4023, 3610.5828);
	angles[4] = (0, -154, 0);
	at[4] = 1.8000;
	points[5] = (-2604.0789, 18179.1348, 3610.4172);
	angles[5] = (0, -154, 0);
	at[5] = 2.2500;
	points[6] = (-2604.0789, 18179.1348, 3610.4172);
	angles[6] = (0, -154, 0);
	at[6] = 2.7000;
	points[7] = (-2610.8857, 18175.8262, 3610.2520);
	angles[7] = (0, -154, 0);
	at[7] = 3.1500;
	points[8] = (-2611.5237, 18175.5117, 3610.2361);
	angles[8] = (0, -154, 0);
	at[8] = 3.6000;
	points[9] = (-2630.2361, 18166.4961, 3609.7756);
	angles[9] = (0, -154, 0);
	at[9] = 5.4000;
	points[10] = (-2631.2993, 18165.9844, 3609.7520);
	angles[10] = (0, -154, 0);
	at[10] = 5.8500;
	points[11] = (-2638.1062, 18162.6777, 3609.5828);
	angles[11] = (0, -154, 0);
	at[11] = 6.3000;
	points[12] = (-2638.1062, 18162.6777, 3609.5828);
	angles[12] = (0, -154, 0);
	at[12] = 6.7500;
	points[13] = (-2644.9136, 18159.4102, 3609.4172);
	angles[13] = (0, -154, 0);
	at[13] = 7.2000;
	points[14] = (-2644.9136, 18159.4102, 3609.4172);
	angles[14] = (0, -154, 0);
	at[14] = 7.6500;
	points[15] = (-2651.7166, 18156.1035, 3609.2522);
	angles[15] = (0, -154, 0);
	at[15] = 8.1000;
	points[16] = (-2651.7166, 18156.1035, 3609.2522);
	angles[16] = (0, -154, 0);
	at[16] = 8.5500;
	points[17] = (-2658.5234, 18152.8340, 3609.0828);
	angles[17] = (0, -154, 0);
	at[17] = 9;
	points[18] = (-2659.5864, 18152.3223, 3609.0591);
	angles[18] = (0, -154, 0);
	at[18] = 9.4500;
	points[19] = (-2678.3032, 18143.3066, 3608.5986);
	angles[19] = (0, -154, 0);
	at[19] = 11.2500;
	points[20] = (-2678.9409, 18142.9922, 3608.5864);
	angles[20] = (0, -154, 0);
	at[20] = 11.7000;
	points[21] = (-2685.7480, 18139.6855, 3608.4175);
	angles[21] = (0, -154, 0);
	at[21] = 12.1500;
	points[22] = (-2685.7480, 18139.6855, 3608.4175);
	angles[22] = (0, -154, 0);
	at[22] = 12.6000;
	points[23] = (-2692.5513, 18136.4180, 3608.2520);
	angles[23] = (0, -154, 0);
	at[23] = 13.0500;
	points[24] = (-2692.5513, 18136.4180, 3608.2520);
	angles[24] = (0, -154, 0);
	at[24] = 13.5000;
	points[25] = (-2699.3582, 18133.1094, 3608.0867);
	angles[25] = (0, -154, 0);
	at[25] = 13.9500;
	points[26] = (-2699.4646, 18133.0703, 3608.0828);
	angles[26] = (0, -154, 0);
	at[26] = 14.4000;
	points[27] = (-2706.1616, 18129.8418, 3607.9172);
	angles[27] = (0, -154, 0);
	at[27] = 14.8500;
	points[28] = (-2707.7598, 18129.0547, 3607.8779);
	angles[28] = (0, -154, 0);
	at[28] = 15.3000;
	points[29] = (-2719.7756, 18123.2676, 3607.5828);
	angles[29] = (0, -154, 0);
	at[29] = 16.6500;
	points[30] = (-2726.2600, 18120.1191, 3607.4253);
	angles[30] = (0, -154, 0);
	at[30] = 17.1000;
	points[31] = (-2726.5786, 18119.9609, 3607.4175);
	angles[31] = (0, -154, 0);
	at[31] = 17.5500;
	points[32] = (-2733.3860, 18116.6934, 3607.2520);
	angles[32] = (0, -154, 0);
	at[32] = 18;
	points[33] = (-2733.3860, 18116.6934, 3607.2520);
	angles[33] = (0, -154, 0);
	at[33] = 18.4500;
	points[34] = (-2740.1929, 18113.4258, 3607.0867);
	angles[34] = (0, -154, 0);
	at[34] = 18.9000;
	points[35] = (-2740.1929, 18113.4258, 3607.0867);
	angles[35] = (0, -154, 0);
	at[35] = 19.3500;
	points[36] = (-2746.9961, 18110.1191, 3606.9172);
	angles[36] = (0, -154, 0);
	at[36] = 19.8000;
	points[37] = (-2747.3149, 18109.9609, 3606.9097);
	angles[37] = (0, -154, 0);
	at[37] = 20.2500;
	points[38] = (-2753.8032, 18106.8516, 3606.7522);
	angles[38] = (0, -154, 0);
	at[38] = 20.7000;
	points[39] = (-2765.8188, 18101.0234, 3606.4565);
	angles[39] = (0, -154, 0);
	at[39] = 22.0500;
	points[40] = (-2767.4133, 18100.2754, 3606.4172);
	angles[40] = (0, -154, 0);
	at[40] = 22.5000;
	points[41] = (-2774.1143, 18097.0469, 3606.2520);
	angles[41] = (0, -154, 0);
	at[41] = 22.9500;
	points[42] = (-2774.2207, 18096.9688, 3606.2520);
	angles[42] = (0, -154, 0);
	at[42] = 23.4000;
	points[43] = (-2781.0276, 18093.7012, 3606.0864);
	angles[43] = (0, -154, 0);
	at[43] = 23.8500;
	points[44] = (-2781.0276, 18093.7012, 3606.0864);
	angles[44] = (0, -154, 0);
	at[44] = 24.3000;
	points[45] = (-2787.8306, 18090.3945, 3605.9175);
	angles[45] = (0, -154, 0);
	at[45] = 24.7500;
	points[46] = (-2787.8306, 18090.3945, 3605.9175);
	angles[46] = (0, -154, 0);
	at[46] = 25.2000;
	points[47] = (-2794.6379, 18087.1270, 3605.7520);
	angles[47] = (0, -154, 0);
	at[47] = 25.6500;
	points[48] = (-2795.2756, 18086.8105, 3605.7363);
	angles[48] = (0, -154, 0);
	at[48] = 26.1000;
	points[49] = (-2813.9922, 18077.7949, 3605.2756);
	angles[49] = (0, -154, 0);
	at[49] = 27.9000;
	points[50] = (-2815.0552, 18077.2832, 3605.2522);
	angles[50] = (0, -154, 0);
	at[50] = 28.3500;
	points[51] = (-2821.8584, 18073.9766, 3605.0867);
	angles[51] = (0, -154, 0);
	at[51] = 28.8000;
	points[52] = (-2821.8584, 18073.9766, 3605.0867);
	angles[52] = (0, -154, 0);
	at[52] = 29.2500;
	points[53] = (-2828.6653, 18070.7090, 3604.9175);
	angles[53] = (0, -154, 0);
	at[53] = 29.7000;
	points[54] = (-2828.6653, 18070.7090, 3604.9175);
	angles[54] = (0, -154, 0);
	at[54] = 30.1500;
	points[55] = (-2835.4727, 18067.4004, 3604.7520);
	angles[55] = (0, -154, 0);
	at[55] = 30.6000;
	points[56] = (-2835.4727, 18067.4004, 3604.7520);
	angles[56] = (0, -154, 0);
	at[56] = 31.0500;
	points[57] = (-2842.2756, 18064.1348, 3604.5825);
	angles[57] = (0, -154, 0);
	at[57] = 31.5000;
	points[58] = (-2843.3386, 18063.6230, 3604.5591);
	angles[58] = (0, -154, 0);
	at[58] = 31.9500;
	points[59] = (-2862.0552, 18054.5664, 3604.1023);
	angles[59] = (0, -154, 0);
	at[59] = 33.7500;
	points[60] = (-2862.6931, 18054.2520, 3604.0867);
	angles[60] = (0, -154, 0);
	at[60] = 34.2000;
	points[61] = (-2869.5000, 18050.9844, 3603.9172);
	angles[61] = (0, -154, 0);
	at[61] = 34.6500;
	points[62] = (-2869.5000, 18050.9844, 3603.9172);
	angles[62] = (0, -154, 0);
	at[62] = 35.1000;
	points[63] = (-2876.3069, 18047.7168, 3603.7520);
	angles[63] = (0, -154, 0);
	at[63] = 35.5500;
	points[64] = (-2876.3069, 18047.7168, 3603.7520);
	angles[64] = (0, -154, 0);
	at[64] = 36;
	points[65] = (-2883.1104, 18044.4102, 3603.5867);
	angles[65] = (0, -154, 0);
	at[65] = 36.4500;
	points[66] = (-2883.2168, 18044.3711, 3603.5828);
	angles[66] = (0, -154, 0);
	at[66] = 36.9000;
	points[67] = (-2889.9175, 18041.1426, 3603.4175);
	angles[67] = (0, -154, 0);
	at[67] = 37.3500;
	points[68] = (-2891.5117, 18040.3555, 3603.3782);
	angles[68] = (0, -154, 0);
	at[68] = 37.8000;
	points[69] = (-2903.5278, 18034.5664, 3603.0828);
	angles[69] = (0, -154, 0);
	at[69] = 39.1500;
	points[70] = (-2910.0156, 18031.4160, 3602.9250);
	angles[70] = (0, -154, 0);
	at[70] = 39.6000;
	points[71] = (-2910.3347, 18031.2598, 3602.9172);
	angles[71] = (0, -154, 0);
	at[71] = 40.0500;
	points[72] = (-2917.1377, 18027.9922, 3602.7522);
	angles[72] = (0, -154, 0);
	at[72] = 40.5000;
	points[73] = (-2917.1377, 18027.9922, 3602.7522);
	angles[73] = (0, -154, 0);
	at[73] = 40.9500;
	points[74] = (-2923.9451, 18024.6855, 3602.5867);
	angles[74] = (0, -154, 0);
	at[74] = 41.4000;
	points[75] = (-2923.9451, 18024.6855, 3602.5867);
	angles[75] = (0, -154, 0);
	at[75] = 41.8500;
	points[76] = (-2930.7520, 18021.4180, 3602.4175);
	angles[76] = (0, -154, 0);
	at[76] = 42.3000;
	points[77] = (-2931.0710, 18021.2598, 3602.4094);
	angles[77] = (0, -154, 0);
	at[77] = 42.7500;
	points[78] = (-2937.5552, 18018.1113, 3602.2520);
	angles[78] = (0, -154, 0);
	at[78] = 43.2000;
	points[79] = (-2949.5747, 18012.3223, 3601.9568);
	angles[79] = (0, -154, 0);
	at[79] = 44.5500;
	points[80] = (-2951.1694, 18011.5742, 3601.9175);
	angles[80] = (0, -154, 0);
	at[80] = 45;
	points[81] = (-2957.8662, 18008.3086, 3601.7559);
	angles[81] = (0, -154, 0);
	at[81] = 45.4500;
	points[82] = (-2957.9724, 18008.2676, 3601.7520);
	angles[82] = (0, -154, 0);
	at[82] = 45.9000;
	points[83] = (-2964.7795, 18005, 3601.5867);
	angles[83] = (0, -154, 0);
	at[83] = 46.3500;
	points[84] = (-2964.7795, 18005, 3601.5867);
	angles[84] = (0, -154, 0);
	at[84] = 46.8000;
	points[85] = (-2971.5867, 18001.6934, 3601.4172);
	angles[85] = (0, -154, 0);
	at[85] = 47.2500;
	points[86] = (-2971.5867, 18001.6934, 3601.4172);
	angles[86] = (0, -154, 0);
	at[86] = 47.7000;
	points[87] = (-2978.3899, 17998.4258, 3601.2522);
	angles[87] = (0, -154, 0);
	at[87] = 48.1500;
	points[88] = (-2979.0276, 17998.1113, 3601.2361);
	angles[88] = (0, -154, 0);
	at[88] = 48.6000;
	points[89] = (-2997.7441, 17989.0547, 3600.7795);
	angles[89] = (0, -154, 0);
	at[89] = 50.4000;
	points[90] = (-2998.8071, 17988.5430, 3600.7520);
	angles[90] = (0, -154, 0);
	at[90] = 50.8500;
	points[91] = (-3005.6140, 17985.2754, 3600.5828);
	angles[91] = (0, -154, 0);
	at[91] = 51.3000;
	points[92] = (-3005.6140, 17985.2754, 3600.5828);
	angles[92] = (0, -154, 0);
	at[92] = 51.7500;
	points[93] = (-3011.8110, 17982.2832, 3600.4329);
	angles[93] = (0, -154, 0);
	at[93] = 52.2000;
	points[94] = (-3005.0042, 17985.5508, 3600.5984);
	angles[94] = (0, -154, 0);
	at[94] = 52.6500;
	points[95] = (-3005.0042, 17985.5508, 3600.5984);
	angles[95] = (0, -154, 0);
	at[95] = 53.1000;
	points[96] = (-2998.2007, 17988.8574, 3600.7678);
	angles[96] = (0, -154, 0);
	at[96] = 53.5500;
	points[97] = (-2997.8821, 17989.0156, 3600.7756);
	angles[97] = (0, -154, 0);
	at[97] = 54;
	points[98] = (-2991.3938, 17992.1270, 3600.9331);
	angles[98] = (0, -154, 0);
	at[98] = 54.4500;
	points[99] = (-2979.3779, 17997.9531, 3601.2283);
	angles[99] = (0, -154, 0);
	at[99] = 55.8000;
	points[100] = (-2977.7834, 17998.7012, 3601.2678);
	angles[100] = (0, -154, 0);
	at[100] = 56.2500;
	points[101] = (-2971.0828, 18001.9297, 3601.4292);
	angles[101] = (0, -154, 0);
	at[101] = 56.7000;
	points[102] = (-2970.9763, 18002.0078, 3601.4331);
	angles[102] = (0, -154, 0);
	at[102] = 57.1500;
	points[103] = (-2964.1694, 18005.2773, 3601.5984);
	angles[103] = (0, -154, 0);
	at[103] = 57.6000;
	points[104] = (-2964.1694, 18005.2773, 3601.5984);
	angles[104] = (0, -154, 0);
	at[104] = 58.0500;
	points[105] = (-2957.3662, 18008.5820, 3601.7678);
	angles[105] = (0, -154, 0);
	at[105] = 58.5000;
	points[106] = (-2957.3662, 18008.5820, 3601.7678);
	angles[106] = (0, -154, 0);
	at[106] = 58.9500;
	points[107] = (-2950.5591, 18011.8516, 3601.9331);
	angles[107] = (0, -154, 0);
	at[107] = 59.4000;
	points[108] = (-2949.9214, 18012.1660, 3601.9490);
	angles[108] = (0, -154, 0);
	at[108] = 59.8500;
	points[109] = (-2931.2046, 18021.1816, 3602.4055);
	angles[109] = (0, -154, 0);
	at[109] = 61.6500;
	points[110] = (-2930.1416, 18021.6934, 3602.4331);
	angles[110] = (0, -154, 0);
	at[110] = 62.1000;
	points[111] = (-2923.3386, 18025, 3602.5984);
	angles[111] = (0, -154, 0);
	at[111] = 62.5500;
	points[112] = (-2923.3386, 18025, 3602.5984);
	angles[112] = (0, -154, 0);
	at[112] = 63;
	points[113] = (-2916.5317, 18028.2676, 3602.7678);
	angles[113] = (0, -154, 0);
	at[113] = 63.4500;
	points[114] = (-2916.5317, 18028.2676, 3602.7678);
	angles[114] = (0, -154, 0);
	at[114] = 63.9000;
	points[115] = (-2909.7244, 18031.5762, 3602.9333);
	angles[115] = (0, -154, 0);
	at[115] = 64.3500;
	points[116] = (-2909.7244, 18031.5762, 3602.9333);
	angles[116] = (0, -154, 0);
	at[116] = 64.8000;
	points[117] = (-2902.9214, 18034.8418, 3603.0984);
	angles[117] = (0, -154, 0);
	at[117] = 65.2500;
	points[118] = (-2901.8582, 18035.3535, 3603.1260);
	angles[118] = (0, -154, 0);
	at[118] = 65.7000;
	points[119] = (-2883.1416, 18044.4102, 3603.5828);
	angles[119] = (0, -154, 0);
	at[119] = 67.5000;
	points[120] = (-2882.5039, 18044.7246, 3603.5986);
	angles[120] = (0, -154, 0);
	at[120] = 67.9500;
	points[121] = (-2875.6970, 18047.9922, 3603.7676);
	angles[121] = (0, -154, 0);
	at[121] = 68.4000;
	points[122] = (-2875.6970, 18047.9922, 3603.7676);
	angles[122] = (0, -154, 0);
	at[122] = 68.8500;
	points[123] = (-2868.8938, 18051.2598, 3603.9331);
	angles[123] = (0, -154, 0);
	at[123] = 69.3000;
	points[124] = (-2868.8938, 18051.2598, 3603.9331);
	angles[124] = (0, -154, 0);
	at[124] = 69.7500;
	points[125] = (-2862.0867, 18054.5664, 3604.0984);
	angles[125] = (0, -154, 0);
	at[125] = 70.2000;
	points[126] = (-2861.9802, 18054.6074, 3604.1023);
	angles[126] = (0, -154, 0);
	at[126] = 70.6500;
	points[127] = (-2855.2795, 18057.8359, 3604.2678);
	angles[127] = (0, -154, 0);
	at[127] = 71.1000;
	points[128] = (-2853.6851, 18058.6230, 3604.3071);
	angles[128] = (0, -154, 0);
	at[128] = 71.5500;
	points[129] = (-2843.9016, 18063.3457, 3604.5432);
	angles[129] = (0, -154, 0);
	at[129] = 72.4500;
	points[130] = (-2841.6692, 18064.4102, 3604.5984);
	angles[130] = (0, -154, 0);
	at[130] = 72.9000;
	points[131] = (-2835.1812, 18067.5586, 3604.7598);
	angles[131] = (0, -154, 0);
	at[131] = 73.3500;
	points[132] = (-2834.8623, 18067.7168, 3604.7676);
	angles[132] = (0, -154, 0);
	at[132] = 73.8000;
	points[133] = (-2828.0591, 18070.9844, 3604.9331);
	angles[133] = (0, -154, 0);
	at[133] = 74.2500;
	points[134] = (-2828.0591, 18070.9844, 3604.9331);
	angles[134] = (0, -154, 0);
	at[134] = 74.7000;
	points[135] = (-2821.2520, 18074.2910, 3605.0986);
	angles[135] = (0, -154, 0);
	at[135] = 75.1500;
	points[136] = (-2821.2520, 18074.2910, 3605.0986);
	angles[136] = (0, -154, 0);
	at[136] = 75.6000;
	points[137] = (-2814.4448, 18077.5605, 3605.2678);
	angles[137] = (0, -154, 0);
	at[137] = 76.0500;
	points[138] = (-2814.1260, 18077.7168, 3605.2756);
	angles[138] = (0, -154, 0);
	at[138] = 76.5000;
	points[139] = (-2807.6418, 18080.8672, 3605.4333);
	angles[139] = (0, -154, 0);
	at[139] = 76.9500;
	points[140] = (-2795.6262, 18086.6543, 3605.7285);
	angles[140] = (0, -154, 0);
	at[140] = 78.3000;
	points[141] = (-2794.0315, 18087.4023, 3605.7678);
	angles[141] = (0, -154, 0);
	at[141] = 78.7500;
	points[142] = (-2787.3308, 18090.6699, 3605.9292);
	angles[142] = (0, -154, 0);
	at[142] = 79.2000;
	points[143] = (-2787.2246, 18090.7090, 3605.9331);
	angles[143] = (0, -154, 0);
	at[143] = 79.6500;
	points[144] = (-2780.4172, 18093.9766, 3606.0986);
	angles[144] = (0, -154, 0);
	at[144] = 80.1000;
	points[145] = (-2780.4172, 18093.9766, 3606.0986);
	angles[145] = (0, -154, 0);
	at[145] = 80.5500;
	points[146] = (-2773.6143, 18097.2832, 3606.2676);
	angles[146] = (0, -154, 0);
	at[146] = 81;
	points[147] = (-2773.6143, 18097.2832, 3606.2676);
	angles[147] = (0, -154, 0);
	at[147] = 81.4500;
	points[148] = (-2766.8071, 18100.5508, 3606.4331);
	angles[148] = (0, -154, 0);
	at[148] = 81.9000;
	points[149] = (-2766.1692, 18100.8652, 3606.4487);
	angles[149] = (0, -154, 0);
	at[149] = 82.3500;
	points[150] = (-2747.4529, 18109.9219, 3606.9058);
	angles[150] = (0, -154, 0);
	at[150] = 84.1500;
	points[151] = (-2746.3899, 18110.4336, 3606.9329);
	angles[151] = (0, -154, 0);
	at[151] = 84.6000;
	points[152] = (-2739.5828, 18113.7012, 3607.0984);
	angles[152] = (0, -154, 0);
	at[152] = 85.0500;
	points[153] = (-2739.5828, 18113.7012, 3607.0984);
	angles[153] = (0, -154, 0);
	at[153] = 85.5000;
	points[154] = (-2732.7795, 18117.0078, 3607.2678);
	angles[154] = (0, -154, 0);
	at[154] = 85.9500;
	points[155] = (-2732.7795, 18117.0078, 3607.2678);
	angles[155] = (0, -154, 0);
	at[155] = 86.4000;
	points[156] = (-2725.9724, 18120.2754, 3607.4331);
	angles[156] = (0, -154, 0);
	at[156] = 86.8500;
	points[157] = (-2725.9724, 18120.2754, 3607.4331);
	angles[157] = (0, -154, 0);
	at[157] = 87.3000;
	points[158] = (-2719.1655, 18123.5449, 3607.5986);
	angles[158] = (0, -154, 0);
	at[158] = 87.7500;
	points[159] = (-2718.1025, 18124.0566, 3607.6260);
	angles[159] = (0, -154, 0);
	at[159] = 88.2000;
	points[160] = (-2699.3896, 18133.1094, 3608.0828);
	angles[160] = (0, -154, 0);
	at[160] = 90;
	points[161] = (-2698.7480, 18133.4258, 3608.0984);
	angles[161] = (0, -154, 0);
	at[161] = 90.4500;
	points[162] = (-2691.9448, 18136.6934, 3608.2678);
	angles[162] = (0, -154, 0);
	at[162] = 90.9000;
	points[163] = (-2691.9448, 18136.6934, 3608.2678);
	angles[163] = (0, -154, 0);
	at[163] = 91.3500;
	points[164] = (-2685.1377, 18140, 3608.4331);
	angles[164] = (0, -154, 0);
	at[164] = 91.8000;
	points[165] = (-2685.1377, 18140, 3608.4331);
	angles[165] = (0, -154, 0);
	at[165] = 92.2500;
	points[166] = (-2678.3308, 18143.2676, 3608.5986);
	angles[166] = (0, -154, 0);
	at[166] = 92.7000;
	points[167] = (-2678.2246, 18143.3066, 3608.6025);
	angles[167] = (0, -154, 0);
	at[167] = 93.1500;
	points[168] = (-2671.5273, 18146.5742, 3608.7676);
	angles[168] = (0, -154, 0);
	at[168] = 93.6000;
	points[169] = (-2669.9331, 18147.3223, 3608.8069);
	angles[169] = (0, -154, 0);
	at[169] = 94.0500;
	points[170] = (-2657.9175, 18153.1504, 3609.0984);
	angles[170] = (0, -154, 0);
	at[170] = 95.4000;
	points[171] = (-2651.4292, 18156.2598, 3609.2600);
	angles[171] = (0, -154, 0);
	at[171] = 95.8500;
	points[172] = (-2651.1104, 18156.4180, 3609.2678);
	angles[172] = (0, -154, 0);
	at[172] = 96.3000;
	points[173] = (-2644.3032, 18159.6855, 3609.4333);
	angles[173] = (0, -154, 0);
	at[173] = 96.7500;
	points[174] = (-2644.3032, 18159.6855, 3609.4333);
	angles[174] = (0, -154, 0);
	at[174] = 97.2000;
	points[175] = (-2637.5000, 18162.9922, 3609.5984);
	angles[175] = (0, -154, 0);
	at[175] = 97.6500;
	points[176] = (-2637.5000, 18162.9922, 3609.5984);
	angles[176] = (0, -154, 0);
	at[176] = 98.1000;
	points[177] = (-2630.6931, 18166.2598, 3609.7678);
	angles[177] = (0, -154, 0);
	at[177] = 98.5500;
	points[178] = (-2630.3740, 18166.4180, 3609.7756);
	angles[178] = (0, -154, 0);
	at[178] = 99;
	points[179] = (-2623.8857, 18169.5664, 3609.9331);
	angles[179] = (0, -154, 0);
	at[179] = 99.4500;
	points[180] = (-2611.8701, 18175.3535, 3610.2283);
	angles[180] = (0, -154, 0);
	at[180] = 100.8000;
	points[181] = (-2610.2756, 18176.1426, 3610.2676);
	angles[181] = (0, -154, 0);
	at[181] = 101.2500;
	points[182] = (-2603.5747, 18179.3711, 3610.4292);
	angles[182] = (0, -154, 0);
	at[182] = 101.7000;
	points[183] = (-2603.4685, 18179.4102, 3610.4331);
	angles[183] = (0, -154, 0);
	at[183] = 102.1500;
	points[184] = (-2596.6653, 18182.7168, 3610.5984);
	angles[184] = (0, -154, 0);
	at[184] = 102.6000;
	points[185] = (-2596.6653, 18182.7168, 3610.5984);
	angles[185] = (0, -154, 0);
	at[185] = 103.0500;
	points[186] = (-2589.8584, 18185.9844, 3610.7678);
	angles[186] = (0, -154, 0);
	at[186] = 103.5000;
	points[187] = (-2589.8584, 18185.9844, 3610.7678);
	angles[187] = (0, -154, 0);
	at[187] = 103.9500;
	points[188] = (-2583.6929, 18188.9766, 3610.9175);
	angles[188] = (0, -154, 0);
	at[188] = 104.1670;
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
