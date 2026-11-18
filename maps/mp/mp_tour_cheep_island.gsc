main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_cheep_island", 0);

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
	ambientPlay("iz_0_trcci", 2);
	iz_emitter("iz_1_se_cc_env_sea", (7677.1655, 5019.6851, 743.1688), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (5928.2974, 4695.5439, 690.2085), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (4179.4297, 4371.4033, 637.2481), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (2430.5623, 4047.2629, 584.2878), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (734.5479, 4174.5532, 538.8229), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-961.4662, 4301.8433, 493.3580), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2657.4805, 4429.1338, 447.8932), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2890.3167, 6724.9341, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2301.7500, 8562.2598, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-1713.1831, 10399.5859, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6216.6582, 4362.7295, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6216.3706, 5581.1484, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6216.0830, 6799.5674, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6802.9546, 8597.5938, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-7389.8267, 10395.6201, 438.2265), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-4439, 81, 4963);
	level.iz_route[level.iz_route.size] = (-4424, -1082, 4963);
	level.iz_route[level.iz_route.size] = (-4449, -1750, 4963);
	level.iz_route[level.iz_route.size] = (-4422, -2480, 4963);
	level.iz_route[level.iz_route.size] = (-4479, -3157, 4962);
	level.iz_route[level.iz_route.size] = (-4395, -3852, 4956);
	level.iz_route[level.iz_route.size] = (-4244, -4685, 4958);
	level.iz_route[level.iz_route.size] = (-3834, -5381, 4963);
	level.iz_route[level.iz_route.size] = (-3221, -5787, 4973);
	level.iz_route[level.iz_route.size] = (-2368, -5833, 4965);
	level.iz_route[level.iz_route.size] = (-1657, -5819, 4963);
	level.iz_route[level.iz_route.size] = (-793, -5826, 4963);
	level.iz_route[level.iz_route.size] = (183, -5820, 4962);
	level.iz_route[level.iz_route.size] = (1073, -5793, 4963);
	level.iz_route[level.iz_route.size] = (1543, -5774, 4963);
	level.iz_route[level.iz_route.size] = (2164, -5726, 4963);
	level.iz_route[level.iz_route.size] = (2801, -5698, 4966);
	level.iz_route[level.iz_route.size] = (3418, -5645, 4980);
	level.iz_route[level.iz_route.size] = (3981, -5561, 4988);
	level.iz_route[level.iz_route.size] = (4549, -5495, 5000);
	level.iz_route[level.iz_route.size] = (5214, -5280, 5014);
	level.iz_route[level.iz_route.size] = (5652, -4778, 5014);
	level.iz_route[level.iz_route.size] = (5745, -4343, 4997);
	level.iz_route[level.iz_route.size] = (5829, -3695, 4961);
	level.iz_route[level.iz_route.size] = (5851, -3154, 4927);
	level.iz_route[level.iz_route.size] = (5880, -2721, 4907);
	level.iz_route[level.iz_route.size] = (5836, -2148, 4908);
	level.iz_route[level.iz_route.size] = (5758, -1774, 4909);
	level.iz_route[level.iz_route.size] = (5909, -1308, 4909);
	level.iz_route[level.iz_route.size] = (6268, -849, 4908);
	level.iz_route[level.iz_route.size] = (6799, -536, 4907);
	level.iz_route[level.iz_route.size] = (7449, -103, 4937);
	level.iz_route[level.iz_route.size] = (8054, 314, 4989);
	level.iz_route[level.iz_route.size] = (8532, 982, 5063);
	level.iz_route[level.iz_route.size] = (8745, 1610, 5145);
	level.iz_route[level.iz_route.size] = (8634, 2333, 5231);
	level.iz_route[level.iz_route.size] = (8298, 2905, 5295);
	level.iz_route[level.iz_route.size] = (7638, 3328, 5338);
	level.iz_route[level.iz_route.size] = (6834, 3379, 5325);
	level.iz_route[level.iz_route.size] = (6271, 3264, 5310);
	level.iz_route[level.iz_route.size] = (5803, 2867, 5257);
	level.iz_route[level.iz_route.size] = (5279, 2368, 5219);
	level.iz_route[level.iz_route.size] = (4515, 1480, 5119);
	level.iz_route[level.iz_route.size] = (3964, 824, 5121);
	level.iz_route[level.iz_route.size] = (3609, 253, 5140);
	level.iz_route[level.iz_route.size] = (3145, -499, 5158);
	level.iz_route[level.iz_route.size] = (2755, -1095, 5171);
	level.iz_route[level.iz_route.size] = (2191, -1421, 5166);
	level.iz_route[level.iz_route.size] = (1215, -1824, 5101);
	level.iz_route[level.iz_route.size] = (405, -1927, 5084);
	level.iz_route[level.iz_route.size] = (-221, -1522, 5084);
	level.iz_route[level.iz_route.size] = (-510, -842, 5084);
	level.iz_route[level.iz_route.size] = (-633, 62, 5084);
	level.iz_route[level.iz_route.size] = (-606, 891, 5084);
	level.iz_route[level.iz_route.size] = (-170, 1663, 5084);
	level.iz_route[level.iz_route.size] = (-121, 2331, 5084);
	level.iz_route[level.iz_route.size] = (-55, 3136, 5084);
	level.iz_route[level.iz_route.size] = (-170, 3733, 5084);
	level.iz_route[level.iz_route.size] = (-540, 4275, 5084);
	level.iz_route[level.iz_route.size] = (-491, 4990, 5084);
	level.iz_route[level.iz_route.size] = (-748, 5369, 5084);
	level.iz_route[level.iz_route.size] = (-1404, 5674, 5084);
	level.iz_route[level.iz_route.size] = (-2217, 5726, 5084);
	level.iz_route[level.iz_route.size] = (-3319, 5778, 5084);
	level.iz_route[level.iz_route.size] = (-4103, 5491, 5084);
	level.iz_route[level.iz_route.size] = (-4348, 5058, 5084);
	level.iz_route[level.iz_route.size] = (-4406, 4613, 5084);
	level.iz_route[level.iz_route.size] = (-4311, 4040, 5041);
	level.iz_route[level.iz_route.size] = (-4327, 3484, 4963);
	level.iz_route[level.iz_route.size] = (-4373, 2669, 4963);
	level.iz_route[level.iz_route.size] = (-4488, 1760, 4963);
	level.iz_route[level.iz_route.size] = (-4535, 781, 4963);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3586.5198, 9001.4180, 693.9843);
	angles[0] = (0, -39.2382, 0);
	at[0] = 0;
	points[1] = (-3558.9490, 9066.2598, 690.7244);
	angles[1] = (0, -30.2041, 0);
	at[1] = 0.1167;
	points[2] = (-3538.0276, 9135.8271, 687.7520);
	angles[2] = (0, -22.9421, 0);
	at[2] = 0.2333;
	points[3] = (-3520.5276, 9206.6533, 684.9370);
	angles[3] = (0, -18.0772, 0);
	at[3] = 0.3500;
	points[4] = (-3491.9529, 9348.5439, 679.6024);
	angles[4] = (0, -12.5963, 0);
	at[4] = 0.5833;
	points[5] = (-3469.3503, 9492.1260, 674.4016);
	angles[5] = (0, -9.5144, 0);
	at[5] = 0.8167;
	points[6] = (-3453.1143, 9635.7090, 669.2441);
	angles[6] = (0, -6.7871, 0);
	at[6] = 1.0500;
	points[7] = (-3448.6299, 9707.9131, 666.5984);
	angles[7] = (0, -4.8840, 0);
	at[7] = 1.1667;
	points[8] = (-3450.2048, 9777.9531, 663.8661);
	angles[8] = (0, -0.9577, 0);
	at[8] = 1.2833;
	points[9] = (-3463.3743, 9849.0156, 660.7913);
	angles[9] = (0, 5.4325, 0);
	at[9] = 1.4000;
	points[10] = (-3481.7637, 9919.4492, 657.6417);
	angles[10] = (0, 10.4143, 0);
	at[10] = 1.5167;
	points[11] = (-3525.3228, 10058.3467, 651.3583);
	angles[11] = (0, 16.1297, 0);
	at[11] = 1.7500;
	points[12] = (-3574.0552, 10194.8828, 645.2520);
	angles[12] = (0, 19.0629, 0);
	at[12] = 1.9833;
	points[13] = (-3656.6104, 10397.0869, 636.8268);
	angles[13] = (0, 22.5474, 0);
	at[13] = 2.3333;
	points[14] = (-3688.1025, 10460.1572, 634.8464);
	angles[14] = (0, 25.0657, 0);
	at[14] = 2.4500;
	points[15] = (-3730.7480, 10517.5195, 634.5787);
	angles[15] = (0, 31.7383, 0);
	at[15] = 2.5667;
	points[16] = (-3780.8267, 10570.7090, 635.3583);
	angles[16] = (0, 38.0289, 0);
	at[16] = 2.6833;
	points[17] = (-3833.1890, 10620.5508, 636.5945);
	angles[17] = (0, 42.5455, 0);
	at[17] = 2.8000;
	points[18] = (-3942.4805, 10715.9453, 639.7126);
	angles[18] = (0, 47.7121, 0);
	at[18] = 3.0333;
	points[19] = (-4109.7246, 10852.8340, 643.5669);
	angles[19] = (0, 50.7108, 0);
	at[19] = 3.3833;
	points[20] = (-4283.8584, 10983.2285, 645.5511);
	angles[20] = (0, 53.2012, 0);
	at[20] = 3.7333;
	points[21] = (-4402.2837, 11067.4414, 647.7402);
	angles[21] = (0, 54.4214, 0);
	at[21] = 3.9667;
	points[22] = (-4520.9448, 11145.3936, 652.4724);
	angles[22] = (0, 56.4924, 0);
	at[22] = 4.2000;
	points[23] = (-4954.4487, 11411.3779, 676.5197);
	angles[23] = (0, 58.7418, 0);
	at[23] = 5.0167;
	points[24] = (-5142.5591, 11523.1104, 687.2874);
	angles[24] = (0, 59.4368, 0);
	at[24] = 5.3667;
	points[25] = (-5203.1104, 11556.3789, 690.7205);
	angles[25] = (0, 60.4837, 0);
	at[25] = 5.4833;
	points[26] = (-5332.2837, 11621.5742, 698.1457);
	angles[26] = (0, 62.7936, 0);
	at[26] = 5.7167;
	points[27] = (-5528.6611, 11714.0166, 709.5354);
	angles[27] = (0, 64.8652, 0);
	at[27] = 6.0667;
	points[28] = (-5595.3540, 11743.4648, 713.3976);
	angles[28] = (0, 65.6214, 0);
	at[28] = 6.1833;
	points[29] = (-5660.7480, 11768.9766, 717.0906);
	angles[29] = (0, 67.4198, 0);
	at[29] = 6.3000;
	points[30] = (-6003.3071, 11889.4893, 736.3622);
	angles[30] = (0, 70.2514, 0);
	at[30] = 6.8833;
	points[31] = (-6069.9209, 11915.5117, 740.3977);
	angles[31] = (0, 69.2634, 0);
	at[31] = 7;
	points[32] = (-6134.3701, 11946.6143, 744.8386);
	angles[32] = (0, 66.2130, 0);
	at[32] = 7.1167;
	points[33] = (-6259.1733, 12019.2920, 754.5552);
	angles[33] = (0, 60.9807, 0);
	at[33] = 7.3500;
	points[34] = (-6382.2441, 12095.9844, 764.6496);
	angles[34] = (0, 58.5759, 0);
	at[34] = 7.5833;
	points[35] = (-6503.1890, 12176.1807, 775.1693);
	angles[35] = (0, 56.6519, 0);
	at[35] = 7.8167;
	points[36] = (-6559.4092, 12218.8975, 780.8032);
	angles[36] = (0, 54.0646, 0);
	at[36] = 7.9333;
	points[37] = (-6608.2285, 12271.9688, 787.9961);
	angles[37] = (0, 47.5639, 0);
	at[37] = 8.0500;
	points[38] = (-6651.4175, 12329.8037, 795.8819);
	angles[38] = (0, 41.6180, 0);
	at[38] = 8.1667;
	points[39] = (-6689.9609, 12390.6689, 804.0748);
	angles[39] = (0, 36.4781, 0);
	at[39] = 8.2833;
	points[40] = (-6720.6694, 12456.0635, 812.4960);
	angles[40] = (0, 29.6131, 0);
	at[40] = 8.4000;
	points[41] = (-6722.5195, 12526.5361, 819.9134);
	angles[41] = (0, 14.0041, 0);
	at[41] = 8.5167;
	points[42] = (-6712.2441, 12598.1504, 826.9095);
	angles[42] = (0, 2.1452, 0);
	at[42] = 8.6333;
	points[43] = (-6695.7485, 12668.3066, 833.8032);
	angles[43] = (0, -6.2158, 0);
	at[43] = 8.7500;
	points[44] = (-6668.9766, 12735.5908, 840.9685);
	angles[44] = (0, -15.4256, 0);
	at[44] = 8.8667;
	points[45] = (-6619.0161, 12785.4727, 847.9016);
	angles[45] = (0, -31.6038, 0);
	at[45] = 8.9833;
	points[46] = (-6561.1816, 12828.8975, 854.5984);
	angles[46] = (0, -43.0419, 0);
	at[46] = 9.1000;
	points[47] = (-6500.5908, 12868.4258, 861.1771);
	angles[47] = (0, -50.4813, 0);
	at[47] = 9.2167;
	points[48] = (-6437.7954, 12903.8184, 867.7047);
	angles[48] = (0, -56.0402, 0);
	at[48] = 9.3333;
	points[49] = (-6372.6772, 12932.5986, 874.1575);
	angles[49] = (0, -61.8933, 0);
	at[49] = 9.4500;
	points[50] = (-6304.8818, 12953.3477, 880.6812);
	angles[50] = (0, -67.8787, 0);
	at[50] = 9.5667;
	points[51] = (-6164.6460, 12990.3936, 894.0316);
	angles[51] = (0, -73.7063, 0);
	at[51] = 9.8000;
	points[52] = (-5812.0474, 13071.8896, 926.1693);
	angles[52] = (0, -77.5192, 0);
	at[52] = 10.3833;
	points[53] = (-5670.9453, 13098.1895, 937.4410);
	angles[53] = (0, -79.4185, 0);
	at[53] = 10.6167;
	points[54] = (-5456.6147, 13122.3633, 950.8779);
	angles[54] = (0, -83.4936, 0);
	at[54] = 10.9667;
	points[55] = (-5095.3154, 13152.7168, 970.8977);
	angles[55] = (0, -85.4999, 0);
	at[55] = 11.5500;
	points[56] = (-4804.5669, 13168.7402, 983.0552);
	angles[56] = (0, -87.4153, 0);
	at[56] = 12.0167;
	points[57] = (-4736.7324, 13168.3467, 983.5551);
	angles[57] = (0, -89.1429, 0);
	at[57] = 12.1333;
	points[58] = (-4519.0552, 13154.4883, 977.8976);
	angles[58] = (0, -93.5673, 0);
	at[58] = 12.4833;
	points[59] = (-4229.7637, 13127.4414, 966.2638);
	angles[59] = (0, -95.5093, 0);
	at[59] = 12.9500;
	points[60] = (-4014.5671, 13103.4648, 957.3504);
	angles[60] = (0, -96.4463, 0);
	at[60] = 13.3000;
	points[61] = (-3945.1182, 13094.4092, 955.1890);
	angles[61] = (0, -97.0694, 0);
	at[61] = 13.4167;
	points[62] = (-3729.6221, 13059.5283, 951.2834);
	angles[62] = (0, -99.2228, 0);
	at[62] = 13.7667;
	points[63] = (-3515.3228, 13020, 947.9489);
	angles[63] = (0, -100.5332, 0);
	at[63] = 14.1167;
	points[64] = (-3373.1614, 12989.9609, 945.3780);
	angles[64] = (0, -101.8455, 0);
	at[64] = 14.3500;
	points[65] = (-3302.2954, 12971.4170, 943.5275);
	angles[65] = (0, -103.6319, 0);
	at[65] = 14.4667;
	points[66] = (-3238.5435, 12942.7959, 939.8622);
	angles[66] = (0, -109.8198, 0);
	at[66] = 14.5833;
	points[67] = (-3177.5708, 12903.9375, 934.5551);
	angles[67] = (0, -116.8182, 0);
	at[67] = 14.7000;
	points[68] = (-3120.1536, 12859.8428, 928.4764);
	angles[68] = (0, -122.6804, 0);
	at[68] = 14.8167;
	points[69] = (-3066.5432, 12811.2598, 921.8386);
	angles[69] = (0, -127.9919, 0);
	at[69] = 14.9333;
	points[70] = (-3022.6340, 12756.1807, 914.7205);
	angles[70] = (0, -136.5130, 0);
	at[70] = 15.0500;
	points[71] = (-3005.5630, 12685.8662, 906.8111);
	angles[71] = (0, -152.7788, 0);
	at[71] = 15.1667;
	points[72] = (-2998.6182, 12614.2129, 898.9370);
	angles[72] = (0, -164.3125, 0);
	at[72] = 15.2833;
	points[73] = (-2996.6340, 12542.1660, 890.9606);
	angles[73] = (0, -171.9052, 0);
	at[73] = 15.4000;
	points[74] = (-3000.5315, 12470, 882.6614);
	angles[74] = (0, -178.2259, 0);
	at[74] = 15.5167;
	points[75] = (-3021.1223, 12402.2842, 873.4213);
	angles[75] = (0, -188.8393, 0);
	at[75] = 15.6333;
	points[76] = (-3084.2124, 12273.3467, 854.1693);
	angles[76] = (0, -202.7446, 0);
	at[76] = 15.8667;
	points[77] = (-3120.1890, 12210.7871, 844.8859);
	angles[77] = (0, -206.6764, 0);
	at[77] = 15.9833;
	points[78] = (-3160.4172, 12152.2041, 836.7441);
	angles[78] = (0, -211.4139, 0);
	at[78] = 16.1000;
	points[79] = (-3211.0867, 12101.3389, 831.2599);
	angles[79] = (0, -218.8534, 0);
	at[79] = 16.2167;
	points[80] = (-3265.5945, 12053.3066, 826.6260);
	angles[80] = (0, -224.0876, 0);
	at[80] = 16.3333;
	points[81] = (-3378.7639, 11962.7168, 818.2874);
	angles[81] = (0, -230.0885, 0);
	at[81] = 16.5667;
	points[82] = (-3437.9211, 11920.7480, 814.3898);
	angles[82] = (0, -232.7094, 0);
	at[82] = 16.6833;
	points[83] = (-3498.8857, 11885.7090, 810.8937);
	angles[83] = (0, -236.9426, 0);
	at[83] = 16.8000;
	points[84] = (-3694.8032, 11790.4326, 801.0867);
	angles[84] = (0, -243.6084, 0);
	at[84] = 17.1500;
	points[85] = (-3958.7402, 11668.1494, 788.5630);
	angles[85] = (0, -245.1163, 0);
	at[85] = 17.6167;
	points[86] = (-4022.2048, 11639.2520, 785.7480);
	angles[86] = (0, -245.4014, 0);
	at[86] = 17.7333;
	points[87] = (-4419.8818, 11462.7168, 769.1654);
	angles[87] = (0, -245.4585, 0);
	at[87] = 18.4333;
	points[88] = (-4485.4331, 11430.3936, 766.2087);
	angles[88] = (0, -244.4147, 0);
	at[88] = 18.5500;
	points[89] = (-4547.1655, 11396.2197, 763.1299);
	angles[89] = (0, -242.5311, 0);
	at[89] = 18.6667;
	points[90] = (-4733.6221, 11286.3389, 753.2205);
	angles[90] = (0, -239.6340, 0);
	at[90] = 19.0167;
	points[91] = (-4981.4961, 11134.2920, 739.7047);
	angles[91] = (0, -238.2792, 0);
	at[91] = 19.4833;
	points[92] = (-5164.2129, 11014.5283, 729.5315);
	angles[92] = (0, -236.3543, 0);
	at[92] = 19.8333;
	points[93] = (-5218.5430, 10971.0635, 726.3582);
	angles[93] = (0, -233.3549, 0);
	at[93] = 19.9500;
	points[94] = (-5270.6694, 10921.6934, 723.1772);
	angles[94] = (0, -229.6138, 0);
	at[94] = 20.0667;
	points[95] = (-5418.3071, 10762.0869, 713.7087);
	angles[95] = (0, -222.8178, 0);
	at[95] = 20.4167;
	points[96] = (-5510.5513, 10650.6299, 707.2953);
	angles[96] = (0, -219.9831, 0);
	at[96] = 20.6500;
	points[97] = (-5592.0469, 10532.6768, 699.4843);
	angles[97] = (0, -215.2580, 0);
	at[97] = 20.8833;
	points[98] = (-5703.2681, 10345.7490, 686.5512);
	angles[98] = (0, -210.6111, 0);
	at[98] = 21.2333;
	points[99] = (-5767.8350, 10215.9062, 679.9055);
	angles[99] = (0, -206.6408, 0);
	at[99] = 21.4667;
	points[100] = (-5788.7012, 10149.0938, 679.4843);
	angles[100] = (0, -200.9104, 0);
	at[100] = 21.5833;
	points[101] = (-5799.4092, 10076.4961, 682.0630);
	angles[101] = (0, -194.1193, 0);
	at[101] = 21.7000;
	points[102] = (-5811.6934, 9932.2832, 689.2559);
	angles[102] = (0, -186.6495, 0);
	at[102] = 21.9333;
	points[103] = (-5819.0942, 9714.6064, 701.6812);
	angles[103] = (0, -181.8849, 0);
	at[103] = 22.2833;
	points[104] = (-5818.0713, 9642.5195, 705.8780);
	angles[104] = (0, -180.3111, 0);
	at[104] = 22.4000;
	points[105] = (-5812.0474, 9572.9531, 709.7087);
	angles[105] = (0, -177.0390, 0);
	at[105] = 22.5167;
	points[106] = (-5797.8345, 9500.6699, 713.6812);
	angles[106] = (0, -172.5463, 0);
	at[106] = 22.6333;
	points[107] = (-5762.3232, 9360.6699, 721.5079);
	angles[107] = (0, -167.0028, 0);
	at[107] = 22.8667;
	points[108] = (-5720.8271, 9221.5752, 729.2638);
	angles[108] = (0, -163.9438, 0);
	at[108] = 23.1000;
	points[109] = (-5672.0474, 9085.7080, 736.5945);
	angles[109] = (0, -160.4687, 0);
	at[109] = 23.3333;
	points[110] = (-5638.7402, 9022.4023, 739.5433);
	angles[110] = (0, -155.4915, 0);
	at[110] = 23.4500;
	points[111] = (-5597.7559, 8963.5039, 741.7992);
	angles[111] = (0, -149.8903, 0);
	at[111] = 23.5667;
	points[112] = (-5507.9526, 8849.2920, 745.7913);
	angles[112] = (0, -143.2919, 0);
	at[112] = 23.8000;
	points[113] = (-5412.7954, 8739.8027, 749.5197);
	angles[113] = (0, -139.6596, 0);
	at[113] = 24.0333;
	points[114] = (-5362.4019, 8686.8115, 751.4016);
	angles[114] = (0, -137.8091, 0);
	at[114] = 24.1500;
	points[115] = (-5310.6299, 8639.8428, 753.3386);
	angles[115] = (0, -134.3201, 0);
	at[115] = 24.2667;
	points[116] = (-5250.9844, 8596.9688, 755.9095);
	angles[116] = (0, -129.5986, 0);
	at[116] = 24.3833;
	points[117] = (-5128.6616, 8520.1572, 761.2126);
	angles[117] = (0, -123.3883, 0);
	at[117] = 24.6167;
	points[118] = (-5000.7480, 8452.0479, 765.9016);
	angles[118] = (0, -118.6601, 0);
	at[118] = 24.8500;
	points[119] = (-4933.7798, 8423.3857, 767.6142);
	angles[119] = (0, -115.4522, 0);
	at[119] = 24.9667;
	points[120] = (-4864.4097, 8404.1338, 768.1299);
	angles[120] = (0, -109.3632, 0);
	at[120] = 25.0833;
	points[121] = (-4794.3306, 8402.0479, 766.4528);
	angles[121] = (0, -99.6917, 0);
	at[121] = 25.2000;
	points[122] = (-4721.7324, 8405.9453, 763.9606);
	angles[122] = (0, -92.8803, 0);
	at[122] = 25.3167;
	points[123] = (-4504.8823, 8430.2363, 755.1575);
	angles[123] = (0, -83.9658, 0);
	at[123] = 25.6667;
	points[124] = (-4290.5117, 8468.8193, 745.3622);
	angles[124] = (0, -79.4563, 0);
	at[124] = 26.0167;
	points[125] = (-4220.1577, 8486.6934, 741.8819);
	angles[125] = (0, -77.2885, 0);
	at[125] = 26.1333;
	points[126] = (-4153.7793, 8510.4727, 738.3110);
	angles[126] = (0, -72.9160, 0);
	at[126] = 26.2500;
	points[127] = (-4092.4016, 8545.9453, 734.3386);
	angles[127] = (0, -65.7408, 0);
	at[127] = 26.3667;
	points[128] = (-4032.4805, 8587.0469, 730.0945);
	angles[128] = (0, -60.2422, 0);
	at[128] = 26.4833;
	points[129] = (-3916.9097, 8675.4727, 721.4252);
	angles[129] = (0, -53.9764, 0);
	at[129] = 26.7167;
	points[130] = (-3806.2483, 8768.7803, 712.7363);
	angles[130] = (0, -50.5089, 0);
	at[130] = 26.9500;
	points[131] = (-3700.0591, 8867.6768, 704.0670);
	angles[131] = (0, -47.4314, 0);
	at[131] = 27.1833;
	points[132] = (-3649.9097, 8919.8037, 699.8032);
	angles[132] = (0, -45.3810, 0);
	at[132] = 27.3000;
	points[133] = (-3603.2244, 8976.0234, 695.6221);
	angles[133] = (0, -41.9989, 0);
	at[133] = 27.4167;
	points[134] = (-3586.5198, 9001.4180, 693.9843);
	angles[134] = (0, -39.2382, 0);
	at[134] = 27.4667;
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
	points[0] = (7121.3779, -9836.8105, 3921.4133);
	angles[0] = (0, -126.2014, 0);
	at[0] = 0;
	points[1] = (7221.0630, -9909.0947, 3856.5117);
	angles[1] = (0, -125.9562, 0);
	at[1] = 0.2000;
	points[2] = (7335.4727, -9990.7881, 3842.9961);
	angles[2] = (0, -125.6019, 0);
	at[2] = 0.4000;
	points[3] = (7451.0234, -10072.1650, 3857.9055);
	angles[3] = (0, -125.2391, 0);
	at[3] = 0.6000;
	points[4] = (7681.2202, -10229.4492, 3912.4448);
	angles[4] = (0, -124.1128, 0);
	at[4] = 1;
	points[5] = (7799.8423, -10304.2920, 3918.6260);
	angles[5] = (0, -122.5155, 0);
	at[5] = 1.2000;
	points[6] = (7920.5518, -10376.0635, 3918.6143);
	angles[6] = (0, -121.1816, 0);
	at[6] = 1.4000;
	points[7] = (8536.5361, -10734.1738, 3918.6418);
	angles[7] = (0, -120.1385, 0);
	at[7] = 2.4000;
	points[8] = (8654.4492, -10803.7012, 3918.6458);
	angles[8] = (0, -120.5333, 0);
	at[8] = 2.6000;
	points[9] = (9017.4023, -11030.2764, 3918.6458);
	angles[9] = (0, -121.9762, 0);
	at[9] = 3.2000;
	points[10] = (9260.4727, -11178.2285, 3918.6458);
	angles[10] = (0, -121.0822, 0);
	at[10] = 3.6000;
	points[11] = (9384.7246, -11248.2676, 3918.6458);
	angles[11] = (0, -119.6018, 0);
	at[11] = 3.8000;
	points[12] = (9513.4258, -11300.9053, 3918.6458);
	angles[12] = (0, -112.8453, 0);
	at[12] = 4;
	points[13] = (9652.5596, -11328.3467, 3918.6497);
	angles[13] = (0, -103.8847, 0);
	at[13] = 4.2000;
	points[14] = (9793.5430, -11346.2207, 3918.6497);
	angles[14] = (0, -98.8545, 0);
	at[14] = 4.4000;
	points[15] = (9934.6855, -11359.4492, 3918.6497);
	angles[15] = (0, -96.2138, 0);
	at[15] = 4.6000;
	points[16] = (10077.4805, -11370.9062, 3918.6497);
	angles[16] = (0, -95.0529, 0);
	at[16] = 4.8000;
	points[17] = (10216.5352, -11379.8828, 3918.6497);
	angles[17] = (0, -93.8139, 0);
	at[17] = 5;
	points[18] = (10643.4248, -11395.3535, 3918.6497);
	angles[18] = (0, -92.2529, 0);
	at[18] = 5.6000;
	points[19] = (10782.2051, -11405.5508, 3918.6497);
	angles[19] = (0, -93.9528, 0);
	at[19] = 5.8000;
	points[20] = (11206.8506, -11452.3232, 3918.6497);
	angles[20] = (0, -96.7077, 0);
	at[20] = 6.4000;
	points[21] = (11347.9531, -11472.4404, 3918.6497);
	angles[21] = (0, -97.9540, 0);
	at[21] = 6.6000;
	points[22] = (11484.3701, -11501.9688, 3918.6497);
	angles[22] = (0, -101.3423, 0);
	at[22] = 6.8000;
	points[23] = (12037.1650, -11638.6221, 3918.6497);
	angles[23] = (0, -103.2527, 0);
	at[23] = 7.6000;
	points[24] = (12174.9219, -11661.7725, 3918.6497);
	angles[24] = (0, -100.2729, 0);
	at[24] = 7.8000;
	points[25] = (12456.2998, -11698.6221, 3918.6497);
	angles[25] = (0, -97.4387, 0);
	at[25] = 8.2000;
	points[26] = (12737.7559, -11729.1348, 3918.6497);
	angles[26] = (0, -95.8809, 0);
	at[26] = 8.6000;
	points[27] = (12878.4258, -11737.4414, 3918.6497);
	angles[27] = (0, -93.9152, 0);
	at[27] = 8.8000;
	points[28] = (13163.1494, -11748.3076, 3918.6536);
	angles[28] = (0, -92.1658, 0);
	at[28] = 9.2000;
	points[29] = (13729.6064, -11760.3545, 3918.6536);
	angles[29] = (0, -90.8197, 0);
	at[29] = 10;
	points[30] = (13872.0078, -11759.5273, 3918.6536);
	angles[30] = (0, -89.8229, 0);
	at[30] = 10.2000;
	points[31] = (14012.8740, -11750.4727, 3918.6536);
	angles[31] = (0, -86.4813, 0);
	at[31] = 10.4000;
	points[32] = (14149.0547, -11715.0781, 3918.6536);
	angles[32] = (0, -77.8810, 0);
	at[32] = 10.6000;
	points[33] = (14283.9375, -11669.8428, 3918.6536);
	angles[33] = (0, -73.0447, 0);
	at[33] = 10.8000;
	points[34] = (14416.8506, -11620.2754, 3918.6536);
	angles[34] = (0, -70.3537, 0);
	at[34] = 11;
	points[35] = (14548.3857, -11564.9609, 3918.6536);
	angles[35] = (0, -67.6617, 0);
	at[35] = 11.2000;
	points[36] = (14670.0791, -11496.2207, 3918.6536);
	angles[36] = (0, -62.0534, 0);
	at[36] = 11.4000;
	points[37] = (14909.3701, -11342.0479, 3918.6536);
	angles[37] = (0, -57.1692, 0);
	at[37] = 11.8000;
	points[38] = (15027.0859, -11261.3779, 3918.6536);
	angles[38] = (0, -55.8805, 0);
	at[38] = 12;
	points[39] = (15140.0791, -11179.2920, 3918.6536);
	angles[39] = (0, -54.4630, 0);
	at[39] = 12.2000;
	points[40] = (15253.9375, -11093.8975, 3918.6536);
	angles[40] = (0, -53.3787, 0);
	at[40] = 12.4000;
	points[41] = (15365.2764, -11005, 3918.6536);
	angles[41] = (0, -51.7013, 0);
	at[41] = 12.6000;
	points[42] = (15468.8184, -10908.8975, 3918.6536);
	angles[42] = (0, -47.5602, 0);
	at[42] = 12.8000;
	points[43] = (15533.8984, -10785.2363, 3918.6536);
	angles[43] = (0, -31.1292, 0);
	at[43] = 13;
	points[44] = (15573.3076, -10648.6621, 3918.6536);
	angles[44] = (0, -19.8557, 0);
	at[44] = 13.2000;
	points[45] = (15602.5986, -10509.4492, 3918.6536);
	angles[45] = (0, -13.7262, 0);
	at[45] = 13.4000;
	points[46] = (15619.3301, -10367.9531, 3918.6536);
	angles[46] = (0, -7.8972, 0);
	at[46] = 13.6000;
	points[47] = (15606.2598, -10228.7402, 3918.6536);
	angles[47] = (0, 2.5436, 0);
	at[47] = 13.8000;
	points[48] = (15580.1572, -10088.9375, 3918.6536);
	angles[48] = (0, 8.5799, 0);
	at[48] = 14;
	points[49] = (15548.2676, -9950.8271, 3918.6536);
	angles[49] = (0, 11.9829, 0);
	at[49] = 14.2000;
	points[50] = (15510.2363, -9813.6221, 3918.6536);
	angles[50] = (0, 14.7976, 0);
	at[50] = 14.4000;
	points[51] = (15463.1895, -9679.4883, 3918.6536);
	angles[51] = (0, 18.6124, 0);
	at[51] = 14.6000;
	points[52] = (15400.6299, -9555.7480, 3918.6536);
	angles[52] = (0, 25.1651, 0);
	at[52] = 14.8000;
	points[53] = (15329.2520, -9433.8193, 3918.6536);
	angles[53] = (0, 29.0242, 0);
	at[53] = 15;
	points[54] = (15179.3701, -9191.1807, 3918.6536);
	angles[54] = (0, 31.7402, 0);
	at[54] = 15.4000;
	points[55] = (15025.0391, -8951.8506, 3918.6536);
	angles[55] = (0, 32.9327, 0);
	at[55] = 15.8000;
	points[56] = (14865.6299, -8716.1025, 3918.6536);
	angles[56] = (0, 34.3049, 0);
	at[56] = 16.2000;
	points[57] = (14781.2207, -8599.7246, 3918.6536);
	angles[57] = (0, 35.7245, 0);
	at[57] = 16.4000;
	points[58] = (14692.9922, -8494.5664, 3918.6536);
	angles[58] = (0, 39.2338, 0);
	at[58] = 16.6000;
	points[59] = (14497.2832, -8290.1973, 3918.6536);
	angles[59] = (0, 43.8555, 0);
	at[59] = 17;
	points[60] = (14192.5195, -7991.3779, 3918.6536);
	angles[60] = (0, 45.8590, 0);
	at[60] = 17.6000;
	points[61] = (13881.9688, -7697.4805, 3918.6536);
	angles[61] = (0, 46.7966, 0);
	at[61] = 18.2000;
	points[62] = (13781.4961, -7605, 3918.6497);
	angles[62] = (0, 47.2760, 0);
	at[62] = 18.4000;
	points[63] = (13250.8662, -7132.0078, 3918.6260);
	angles[63] = (0, 48.5334, 0);
	at[63] = 19.4000;
	points[64] = (12930.1182, -6851.2202, 3918.6182);
	angles[64] = (0, 48.9025, 0);
	at[64] = 20;
	points[65] = (12606.9297, -6574.7637, 3918.6497);
	angles[65] = (0, 49.8124, 0);
	at[65] = 20.6000;
	points[66] = (12279.2129, -6309.2915, 3918.7637);
	angles[66] = (0, 51.1651, 0);
	at[66] = 21.2000;
	points[67] = (11944.8037, -6043.6616, 3918.9016);
	angles[67] = (0, 51.6407, 0);
	at[67] = 21.8000;
	points[68] = (11495.1973, -5693.4644, 3919.1418);
	angles[68] = (0, 52.3427, 0);
	at[68] = 22.6000;
	points[69] = (11269.9219, -5523.4253, 3919.3110);
	angles[69] = (0, 53.1134, 0);
	at[69] = 23;
	points[70] = (11158.2285, -5442.7949, 3919.3740);
	angles[70] = (0, 54.0453, 0);
	at[70] = 23.2000;
	points[71] = (10922.3232, -5283.0708, 3910.8977);
	angles[71] = (0, 55.9879, 0);
	at[71] = 23.6000;
	points[72] = (10805.6309, -5206.0630, 3904.9644);
	angles[72] = (0, 56.4410, 0);
	at[72] = 23.8000;
	points[73] = (10447.5195, -4973.4644, 3887.6614);
	angles[73] = (0, 57.1213, 0);
	at[73] = 24.4000;
	points[74] = (10207.8340, -4820.0786, 3879.7991);
	angles[74] = (0, 57.4130, 0);
	at[74] = 24.8000;
	points[75] = (9968.2676, -4668.4253, 3877.9058);
	angles[75] = (0, 57.7048, 0);
	at[75] = 25.2000;
	points[76] = (9846.2598, -4591.9688, 3880.6299);
	angles[76] = (0, 57.8778, 0);
	at[76] = 25.4000;
	points[77] = (9725.6689, -4517.0078, 3887.1890);
	angles[77] = (0, 58.0932, 0);
	at[77] = 25.6000;
	points[78] = (9606.8896, -4444.1338, 3899.6497);
	angles[78] = (0, 58.4007, 0);
	at[78] = 25.8000;
	points[79] = (9489.3311, -4373.5825, 3923.4529);
	angles[79] = (0, 58.9570, 0);
	at[79] = 26;
	points[80] = (9373.1494, -4306.2207, 3967.3623);
	angles[80] = (0, 59.6659, 0);
	at[80] = 26.2000;
	points[81] = (9262.2441, -4242.9531, 4019.4490);
	angles[81] = (0, 60.1483, 0);
	at[81] = 26.4000;
	points[82] = (9035.3545, -4115.2759, 4139.0552);
	angles[82] = (0, 60.6579, 0);
	at[82] = 26.8000;
	points[83] = (8812.0869, -3991.1418, 4264.9214);
	angles[83] = (0, 60.9530, 0);
	at[83] = 27.2000;
	points[84] = (8144.6455, -3627.9607, 4652.7168);
	angles[84] = (0, 61.7964, 0);
	at[84] = 28.4000;
	points[85] = (8030.3940, -3567.3779, 4717.4014);
	angles[85] = (0, 62.0198, 0);
	at[85] = 28.6000;
	points[86] = (7920.9839, -3510.1379, 4777.4805);
	angles[86] = (0, 62.3172, 0);
	at[86] = 28.8000;
	points[87] = (7802.2832, -3449.2598, 4839.2915);
	angles[87] = (0, 62.7744, 0);
	at[87] = 29;
	points[88] = (7682.6772, -3390.3542, 4894.0552);
	angles[88] = (0, 63.6468, 0);
	at[88] = 29.2000;
	points[89] = (7565.8267, -3338.9961, 4927.9136);
	angles[89] = (0, 65.8589, 0);
	at[89] = 29.4000;
	points[90] = (7433.9375, -3288.1223, 4945.7480);
	angles[90] = (0, 68.2588, 0);
	at[90] = 29.6000;
	points[91] = (7300.3545, -3240.5906, 4953.1494);
	angles[91] = (0, 69.9324, 0);
	at[91] = 29.8000;
	points[92] = (7165.6694, -3195.3425, 4954.2124);
	angles[92] = (0, 71.0928, 0);
	at[92] = 30;
	points[93] = (7030.2358, -3151.8621, 4951.1025);
	angles[93] = (0, 71.9610, 0);
	at[93] = 30.2000;
	points[94] = (6894.2520, -3109.9487, 4945.1577);
	angles[94] = (0, 72.6773, 0);
	at[94] = 30.4000;
	points[95] = (6621.1421, -3030.8386, 4928.9370);
	angles[95] = (0, 74.0237, 0);
	at[95] = 30.8000;
	points[96] = (6483.6616, -2994.2007, 4921.2993);
	angles[96] = (0, 74.8898, 0);
	at[96] = 31;
	points[97] = (6348.8188, -2962.3308, 4918.7007);
	angles[97] = (0, 76.4963, 0);
	at[97] = 31.2000;
	points[98] = (6211.1416, -2939.2639, 4924.8032);
	angles[98] = (0, 79.6800, 0);
	at[98] = 31.4000;
	points[99] = (5928.4253, -2905.6301, 4941.7720);
	angles[99] = (0, 83.3584, 0);
	at[99] = 31.8000;
	points[100] = (5645.7480, -2880.7756, 4959.2520);
	angles[100] = (0, 85.1381, 0);
	at[100] = 32.2000;
	points[101] = (5362.2046, -2864.4253, 4973.7402);
	angles[101] = (0, 87.0277, 0);
	at[101] = 32.6000;
	points[102] = (5219.1733, -2863.0591, 4976.5356);
	angles[102] = (0, 89.1812, 0);
	at[102] = 32.8000;
	points[103] = (5082.9922, -2877.3306, 4967.2837);
	angles[103] = (0, 94.6592, 0);
	at[103] = 33;
	points[104] = (4942.6772, -2902.1260, 4950.5513);
	angles[104] = (0, 98.7359, 0);
	at[104] = 33.2000;
	points[105] = (4805.3149, -2931.0042, 4931.5747);
	angles[105] = (0, 101.1310, 0);
	at[105] = 33.4000;
	points[106] = (4532.2837, -2998.2400, 4890.9844);
	angles[106] = (0, 104.1263, 0);
	at[106] = 33.8000;
	points[107] = (4395.9448, -3037.7834, 4871.1416);
	angles[107] = (0, 105.8302, 0);
	at[107] = 34;
	points[108] = (4267.8345, -3086.5552, 4856.7324);
	angles[108] = (0, 110.5165, 0);
	at[108] = 34.2000;
	points[109] = (4145.3545, -3159.0630, 4849.6064);
	angles[109] = (0, 118.3709, 0);
	at[109] = 34.4000;
	points[110] = (4028.1892, -3239.8701, 4845.1182);
	angles[110] = (0, 123.1136, 0);
	at[110] = 34.6000;
	points[111] = (3914.7244, -3325.2483, 4842.4019);
	angles[111] = (0, 126.0992, 0);
	at[111] = 34.8000;
	points[112] = (3805.0198, -3415.2363, 4841.8110);
	angles[112] = (0, 128.7489, 0);
	at[112] = 35;
	points[113] = (3705.9568, -3513.4373, 4846.9292);
	angles[113] = (0, 134.2695, 0);
	at[113] = 35.2000;
	points[114] = (3624.1340, -3629.3032, 4865.9844);
	angles[114] = (0, 142.3399, 0);
	at[114] = 35.4000;
	points[115] = (3552.1221, -3749.2678, 4888.8584);
	angles[115] = (0, 147.4858, 0);
	at[115] = 35.6000;
	points[116] = (3488.1655, -3873.9451, 4912.7954);
	angles[116] = (0, 151.7869, 0);
	at[116] = 35.8000;
	points[117] = (3438.2007, -4004.4487, 4935.8662);
	angles[117] = (0, 157.9973, 0);
	at[117] = 36;
	points[118] = (3427.5710, -4141.4175, 4953.1494);
	angles[118] = (0, 172.5542, 0);
	at[118] = 36.2000;
	points[119] = (3441.3740, -4283.7007, 4967.7954);
	angles[119] = (0, 182.2254, 0);
	at[119] = 36.4000;
	points[120] = (3483.9961, -4562.8740, 4994.6455);
	angles[120] = (0, 188.6857, 0);
	at[120] = 36.8000;
	points[121] = (3538.2480, -4840.7480, 5019.9609);
	angles[121] = (0, 191.3257, 0);
	at[121] = 37.2000;
	points[122] = (3571.2087, -4978.6616, 5031.8110);
	angles[122] = (0, 193.1453, 0);
	at[122] = 37.4000;
	points[123] = (3611.8623, -5109.8423, 5039.2520);
	angles[123] = (0, 196.3593, 0);
	at[123] = 37.6000;
	points[124] = (3658.4409, -5244.8423, 5044.1338);
	angles[124] = (0, 198.3839, 0);
	at[124] = 37.8000;
	points[125] = (3806.6221, -5644.9609, 5059.7246);
	angles[125] = (0, 200.6638, 0);
	at[125] = 38.4000;
	points[126] = (3910.7678, -5908.8188, 5078.3071);
	angles[126] = (0, 201.6919, 0);
	at[126] = 38.8000;
	points[127] = (3964.6853, -6038.1499, 5094.1733);
	angles[127] = (0, 202.4897, 0);
	at[127] = 39;
	points[128] = (4019.9214, -6159.8818, 5122.0078);
	angles[128] = (0, 204.1521, 0);
	at[128] = 39.2000;
	points[129] = (4080.2363, -6281.6538, 5167.3228);
	angles[129] = (0, 205.8237, 0);
	at[129] = 39.4000;
	points[130] = (4202.2837, -6518.1890, 5269.5273);
	angles[130] = (0, 207.3264, 0);
	at[130] = 39.8000;
	points[131] = (4388.9370, -6867.8345, 5429.2915);
	angles[131] = (0, 208.3065, 0);
	at[131] = 40.4000;
	points[132] = (4517.2046, -7100.3154, 5533.5435);
	angles[132] = (0, 208.9920, 0);
	at[132] = 40.8000;
	points[133] = (4583.1104, -7216.2993, 5582.4414);
	angles[133] = (0, 209.5127, 0);
	at[133] = 41;
	points[134] = (4652.6772, -7333.8584, 5626.3384);
	angles[134] = (0, 210.4513, 0);
	at[134] = 41.2000;
	points[135] = (4725.8271, -7444.9214, 5651.3779);
	angles[135] = (0, 212.9498, 0);
	at[135] = 41.4000;
	points[136] = (4810.2759, -7560.2363, 5661.0234);
	angles[136] = (0, 215.4742, 0);
	at[136] = 41.6000;
	points[137] = (4984.0161, -7784.4883, 5663.2280);
	angles[137] = (0, 217.8315, 0);
	at[137] = 42;
	points[138] = (5161.5752, -8005.6689, 5656.0630);
	angles[138] = (0, 218.8292, 0);
	at[138] = 42.4000;
	points[139] = (5341.4175, -8224.3311, 5645.5513);
	angles[139] = (0, 219.5200, 0);
	at[139] = 42.8000;
	points[140] = (5434.6455, -8335.3145, 5641.0234);
	angles[140] = (0, 219.9405, 0);
	at[140] = 43;
	points[141] = (5524.9209, -8439.1338, 5645.8271);
	angles[141] = (0, 220.8466, 0);
	at[141] = 43.2000;
	points[142] = (5810.6299, -8749.6064, 5702.6377);
	angles[142] = (0, 222.9817, 0);
	at[142] = 43.8000;
	points[143] = (5908.1099, -8851.9688, 5714.6064);
	angles[143] = (0, 223.4767, 0);
	at[143] = 44;
	points[144] = (6007.3623, -8954.0947, 5715.4727);
	angles[144] = (0, 224.0593, 0);
	at[144] = 44.2000;
	points[145] = (6107.1650, -9053.6221, 5695.6304);
	angles[145] = (0, 224.9177, 0);
	at[145] = 44.4000;
	points[146] = (6197.8740, -9138.4648, 5636.6929);
	angles[146] = (0, 226.5952, 0);
	at[146] = 44.6000;
	points[147] = (6270.0396, -9198.5830, 5533.1890);
	angles[147] = (0, 229.0616, 0);
	at[147] = 44.8000;
	points[148] = (6337.3618, -9252.0078, 5416.1812);
	angles[148] = (0, 230.8022, 0);
	at[148] = 45;
	points[149] = (6398.7007, -9299.5674, 5302.2441);
	angles[149] = (0, 231.8010, 0);
	at[149] = 45.2000;
	points[150] = (6582.7954, -9439.2910, 4941.0234);
	angles[150] = (0, 232.9590, 0);
	at[150] = 45.8000;
	points[151] = (6824.1733, -9618.7793, 4456.0234);
	angles[151] = (0, 233.5072, 0);
	at[151] = 46.6000;
	points[152] = (6883.7798, -9662.6777, 4338.2676);
	angles[152] = (0, 233.5959, 0);
	at[152] = 46.8000;
	points[153] = (6947.4019, -9709.4102, 4215.1577);
	angles[153] = (0, 233.6741, 0);
	at[153] = 47;
	points[154] = (7011.3384, -9756.2988, 4096.2598);
	angles[154] = (0, 233.7409, 0);
	at[154] = 47.2000;
	points[155] = (7078.3462, -9805.3145, 3981.7717);
	angles[155] = (0, 233.7925, 0);
	at[155] = 47.4000;
	points[156] = (7121.3779, -9836.8105, 3921.4133);
	angles[156] = (0, 233.7986, 0);
	at[156] = 47.5167;
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
	points[0] = (-882.5552, 4541.6143, 809.5906);
	angles[0] = (0, 57.8971, 0);
	at[0] = 0;
	points[1] = (-1149.6221, 4700.2759, 795.8897);
	angles[1] = (0, 59.6861, 0);
	at[1] = 0.5000;
	points[2] = (-1259.2638, 4758.6616, 789.8661);
	angles[2] = (0, 61.7223, 0);
	at[2] = 0.7000;
	points[3] = (-1314.4646, 4781.6143, 786.8976);
	angles[3] = (0, 64.8704, 0);
	at[3] = 0.8000;
	points[4] = (-1434.3346, 4817.0474, 780.4173);
	angles[4] = (0, 71.4526, 0);
	at[4] = 1;
	points[5] = (-1554.9016, 4846.7720, 773.8859);
	angles[5] = (0, 75.0424, 0);
	at[5] = 1.2000;
	points[6] = (-1676.8542, 4871.4565, 767.3268);
	angles[6] = (0, 77.8864, 0);
	at[6] = 1.4000;
	points[7] = (-1738.5001, 4880.5117, 764.0630);
	angles[7] = (0, 79.8380, 0);
	at[7] = 1.5000;
	points[8] = (-1798.3386, 4883.7402, 760.9961);
	angles[8] = (0, 83.8262, 0);
	at[8] = 1.6000;
	points[9] = (-1859.4685, 4876.4175, 758.0315);
	angles[9] = (0, 90.2650, 0);
	at[9] = 1.7000;
	points[10] = (-1981.6812, 4851.7324, 752.2599);
	angles[10] = (0, 98.6151, 0);
	at[10] = 1.9000;
	points[11] = (-2102.5945, 4821.7324, 746.6339);
	angles[11] = (0, 102.6192, 0);
	at[11] = 2.1000;
	points[12] = (-2222.5315, 4787.6772, 741.1299);
	angles[12] = (0, 105.1608, 0);
	at[12] = 2.3000;
	points[13] = (-2281.6299, 4768.5435, 738.4646);
	angles[13] = (0, 106.6104, 0);
	at[13] = 2.4000;
	points[14] = (-2337.0396, 4745.8267, 736.0709);
	angles[14] = (0, 109.8848, 0);
	at[14] = 2.5000;
	points[15] = (-2390.1416, 4712.9136, 734.2165);
	angles[15] = (0, 115.8626, 0);
	at[15] = 2.6000;
	points[16] = (-2440.0591, 4675.9844, 732.6772);
	angles[16] = (0, 121.0382, 0);
	at[16] = 2.7000;
	points[17] = (-2534.4333, 4594.7637, 729.8071);
	angles[17] = (0, 128.5345, 0);
	at[17] = 2.9000;
	points[18] = (-2577.8384, 4550.7871, 728.2874);
	angles[18] = (0, 132.0024, 0);
	at[18] = 3;
	points[19] = (-2614.9568, 4502.3623, 726.3661);
	angles[19] = (0, 137.9098, 0);
	at[19] = 3.1000;
	points[20] = (-2638.3464, 4444.6064, 723.5118);
	angles[20] = (0, 147.7732, 0);
	at[20] = 3.2000;
	points[21] = (-2671.1655, 4325, 717.4134);
	angles[21] = (0, 160.3719, 0);
	at[21] = 3.4000;
	points[22] = (-2694.9172, 4202.7559, 711.4331);
	angles[22] = (0, 167.0195, 0);
	at[22] = 3.6000;
	points[23] = (-2701.9922, 4141.5747, 708.7678);
	angles[23] = (0, 170.3275, 0);
	at[23] = 3.7000;
	points[24] = (-2698.9604, 4080.5117, 706.9135);
	angles[24] = (0, 176.9656, 0);
	at[24] = 3.8000;
	points[25] = (-2672.8347, 3959.1733, 704.4174);
	angles[25] = (0, 188.3436, 0);
	at[25] = 4;
	points[26] = (-2639.2837, 3839.3977, 702.5788);
	angles[26] = (0, 193.8651, 0);
	at[26] = 4.2000;
	points[27] = (-2598.5156, 3721.5947, 701.7677);
	angles[27] = (0, 198.1907, 0);
	at[27] = 4.4000;
	points[28] = (-2568.1809, 3668.9922, 703.3898);
	angles[28] = (0, 204.8593, 0);
	at[28] = 4.5000;
	points[29] = (-2524.1731, 3625.5039, 707.9528);
	angles[29] = (0, 214.8680, 0);
	at[29] = 4.6000;
	points[30] = (-2475.9487, 3586.7834, 713.3819);
	angles[30] = (0, 222.7377, 0);
	at[30] = 4.7000;
	points[31] = (-2372.9016, 3517.7874, 724.6339);
	angles[31] = (0, 233.0175, 0);
	at[31] = 4.9000;
	points[32] = (-2318.3425, 3489.9526, 729.0079);
	angles[32] = (0, 238.1522, 0);
	at[32] = 5;
	points[33] = (-2261.2126, 3467.6575, 732.4252);
	angles[33] = (0, 243.2323, 0);
	at[33] = 5.1000;
	points[34] = (-2143.4607, 3427.1733, 738.9489);
	angles[34] = (0, 249.0520, 0);
	at[34] = 5.3000;
	points[35] = (-2024.7126, 3391.5000, 745.4410);
	angles[35] = (0, 252.3791, 0);
	at[35] = 5.5000;
	points[36] = (-1964.6141, 3377.3701, 748.9252);
	angles[36] = (0, 254.8154, 0);
	at[36] = 5.6000;
	points[37] = (-1903.4489, 3370.4094, 752.8937);
	angles[37] = (0, 259.1472, 0);
	at[37] = 5.7000;
	points[38] = (-1717.7953, 3362.5986, 765.4252);
	angles[38] = (0, 266.8730, 0);
	at[38] = 6;
	points[39] = (-1593.9331, 3364.6890, 773.8976);
	angles[39] = (0, 270.2536, 0);
	at[39] = 6.2000;
	points[40] = (-1532.9528, 3372.5198, 778.1536);
	angles[40] = (0, 274.0540, 0);
	at[40] = 6.3000;
	points[41] = (-1473.1180, 3386.0273, 782.5591);
	angles[41] = (0, 278.2576, 0);
	at[41] = 6.4000;
	points[42] = (-1233.8466, 3453.6653, 799.8149);
	angles[42] = (0, 285.8267, 0);
	at[42] = 6.8000;
	points[43] = (-1118.3347, 3494.6812, 805.6457);
	angles[43] = (0, 289.1585, 0);
	at[43] = 7;
	points[44] = (-948.8661, 3572.9805, 807.9764);
	angles[44] = (0, 294.2519, 0);
	at[44] = 7.3000;
	points[45] = (-725.7953, 3679.7285, 811.8543);
	angles[45] = (0, 295.2643, 0);
	at[45] = 7.7000;
	points[46] = (-387.4134, 3837.6731, 828.5591);
	angles[46] = (0, 295.1837, 0);
	at[46] = 8.3000;
	points[47] = (-333.4807, 3863.7324, 831.4410);
	angles[47] = (0, 295.4880, 0);
	at[47] = 8.4000;
	points[48] = (0.7723, 4029.4487, 849.2363);
	angles[48] = (0, 296.7027, 0);
	at[48] = 9;
	points[49] = (163.0504, 4118.3857, 848.0788);
	angles[49] = (0, 298.6620, 0);
	at[49] = 9.3000;
	points[50] = (431.8425, 4272.9136, 839.7993);
	angles[50] = (0, 300.2818, 0);
	at[50] = 9.8000;
	points[51] = (741.9528, 4478.0708, 821.1575);
	angles[51] = (0, 303.0851, 0);
	at[51] = 10.4000;
	points[52] = (905.4174, 4565.7876, 809.4095);
	angles[52] = (0, 298.3795, 0);
	at[52] = 10.7000;
	points[53] = (1073.7047, 4645.5513, 797.7480);
	angles[53] = (0, 295.2977, 0);
	at[53] = 11;
	points[54] = (1130.4882, 4667.8740, 794.9567);
	angles[54] = (0, 293.1586, 0);
	at[54] = 11.1000;
	points[55] = (1189.4094, 4685.6694, 793.8898);
	angles[55] = (0, 290.0257, 0);
	at[55] = 11.2000;
	points[56] = (1370.4252, 4732.2046, 792.9725);
	angles[56] = (0, 284.9127, 0);
	at[56] = 11.5000;
	points[57] = (1492.0984, 4759.0552, 792.4331);
	angles[57] = (0, 282.9390, 0);
	at[57] = 11.7000;
	points[58] = (1553.4528, 4770.3936, 791.8425);
	angles[58] = (0, 281.6676, 0);
	at[58] = 11.8000;
	points[59] = (1612.8937, 4777.7954, 790.5473);
	angles[59] = (0, 279.0850, 0);
	at[59] = 11.9000;
	points[60] = (1737.3740, 4777.4409, 784.8661);
	angles[60] = (0, 272.0060, 0);
	at[60] = 12.1000;
	points[61] = (1923.4174, 4767.0864, 774.9094);
	angles[61] = (0, 267.2656, 0);
	at[61] = 12.4000;
	points[62] = (2046.7954, 4756.0630, 767.9646);
	angles[62] = (0, 265.3448, 0);
	at[62] = 12.6000;
	points[63] = (2109.5237, 4747.9526, 764.3583);
	angles[63] = (0, 263.9002, 0);
	at[63] = 12.7000;
	points[64] = (2167.7480, 4734.6460, 760.8897);
	angles[64] = (0, 260.3167, 0);
	at[64] = 12.8000;
	points[65] = (2285.4565, 4694.6851, 753.3779);
	angles[65] = (0, 253.3472, 0);
	at[65] = 13;
	points[66] = (2399.6931, 4646.6538, 745.7441);
	angles[66] = (0, 248.4820, 0);
	at[66] = 13.2000;
	points[67] = (2455.4133, 4618.1890, 741.8504);
	angles[67] = (0, 245.5935, 0);
	at[67] = 13.3000;
	points[68] = (2503.8740, 4582.7168, 738.0984);
	angles[68] = (0, 239.0553, 0);
	at[68] = 13.4000;
	points[69] = (2544.7876, 4536.0234, 734.2953);
	angles[69] = (0, 230.3760, 0);
	at[69] = 13.5000;
	points[70] = (2617.9568, 4435.3545, 726.8937);
	angles[70] = (0, 219.6002, 0);
	at[70] = 13.7000;
	points[71] = (2682.5474, 4329.8032, 719.9803);
	angles[71] = (0, 213.1971, 0);
	at[71] = 13.9000;
	points[72] = (2708.7598, 4273.4644, 717.0118);
	angles[72] = (0, 208.6578, 0);
	at[72] = 14;
	points[73] = (2722.2600, 4213.8584, 715.2166);
	angles[73] = (0, 200.7838, 0);
	at[73] = 14.1000;
	points[74] = (2730.9841, 4152.2051, 713.8465);
	angles[74] = (0, 194.6649, 0);
	at[74] = 14.2000;
	points[75] = (2741.5117, 4028.2285, 711.6102);
	angles[75] = (0, 187.2411, 0);
	at[75] = 14.4000;
	points[76] = (2742, 3903.5789, 709.8819);
	angles[76] = (0, 181.4989, 0);
	at[76] = 14.6000;
	points[77] = (2731.5630, 3844.4724, 709.4528);
	angles[77] = (0, 174.8544, 0);
	at[77] = 14.7000;
	points[78] = (2701.4802, 3789.6970, 709.5945);
	angles[78] = (0, 163.2533, 0);
	at[78] = 14.8000;
	points[79] = (2665.6931, 3739.0789, 709.9685);
	angles[79] = (0, 154.3946, 0);
	at[79] = 14.9000;
	points[80] = (2586.3386, 3643.0906, 711.2992);
	angles[80] = (0, 143.8869, 0);
	at[80] = 15.1000;
	points[81] = (2543.5396, 3597.6260, 712.3780);
	angles[81] = (0, 140.3583, 0);
	at[81] = 15.2000;
	points[82] = (2498.3977, 3555.5117, 714.0079);
	angles[82] = (0, 136.5723, 0);
	at[82] = 15.3000;
	points[83] = (2447.1377, 3522.5237, 717.3268);
	angles[83] = (0, 129.2756, 0);
	at[83] = 15.4000;
	points[84] = (2390.9094, 3497.7678, 722.0276);
	angles[84] = (0, 121.8110, 0);
	at[84] = 15.5000;
	points[85] = (2274.3464, 3454.6143, 732.3701);
	angles[85] = (0, 113.2792, 0);
	at[85] = 15.7000;
	points[86] = (2156.7520, 3416.1692, 742.9016);
	angles[86] = (0, 109.3826, 0);
	at[86] = 15.9000;
	points[87] = (2038.0198, 3382.2400, 752.8504);
	angles[87] = (0, 106.5136, 0);
	at[87] = 16.1000;
	points[88] = (1977.7638, 3370.1536, 756.7834);
	angles[88] = (0, 103.8998, 0);
	at[88] = 16.2000;
	points[89] = (1793.3151, 3344.0471, 767.3976);
	angles[89] = (0, 98.4233, 0);
	at[89] = 16.5000;
	points[90] = (1669.1890, 3333.6497, 773.8504);
	angles[90] = (0, 95.4025, 0);
	at[90] = 16.7000;
	points[91] = (1609.4409, 3334.4133, 776.5001);
	angles[91] = (0, 91.9543, 0);
	at[91] = 16.8000;
	points[92] = (1547.0709, 3343.4211, 778.5433);
	angles[92] = (0, 86.9497, 0);
	at[92] = 16.9000;
	points[93] = (1364.6536, 3381.5120, 783.5197);
	angles[93] = (0, 79.0811, 0);
	at[93] = 17.2000;
	points[94] = (1184.4567, 3428.2009, 788.2480);
	angles[94] = (0, 75.3815, 0);
	at[94] = 17.5000;
	points[95] = (1070.0040, 3473.9568, 791.5354);
	angles[95] = (0, 69.7209, 0);
	at[95] = 17.7000;
	points[96] = (844.7795, 3579.9805, 799.0591);
	angles[96] = (0, 64.7286, 0);
	at[96] = 18.1000;
	points[97] = (519.2717, 3758.4016, 821.6102);
	angles[97] = (0, 61.2570, 0);
	at[97] = 18.7000;
	points[98] = (466.1339, 3786.1140, 824.8189);
	angles[98] = (0, 61.9491, 0);
	at[98] = 18.8000;
	points[99] = (129.5535, 3948.6221, 842.2559);
	angles[99] = (0, 64.1788, 0);
	at[99] = 19.4000;
	points[100] = (20.4746, 4003.2283, 844.7480);
	angles[100] = (0, 63.3980, 0);
	at[100] = 19.6000;
	points[101] = (-306.2685, 4183.9370, 828.0709);
	angles[101] = (0, 60.8100, 0);
	at[101] = 20.2000;
	points[102] = (-465.6378, 4275.9844, 819.6890);
	angles[102] = (0, 59.8000, 0);
	at[102] = 20.5000;
	points[103] = (-833.2205, 4511.1025, 811.1536);
	angles[103] = (0, 57.4246, 0);
	at[103] = 21.2000;
	points[104] = (-882.5552, 4541.6143, 809.5906);
	angles[104] = (0, 57.8971, 0);
	at[104] = 21.3000;
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
	points[0] = (-120.1130, 4642.0864, 5083.5430);
	angles[0] = (0, 179.3775, 0);
	at[0] = 0;
	points[1] = (-1076.7480, 4652.4805, 5083.5430);
	angles[1] = (0, 179.3774, 0);
	at[1] = 3.6000;
	points[2] = (-1085.6063, 4652.5591, 5083.5430);
	angles[2] = (0, 179.3774, 0);
	at[2] = 3.6500;
	points[3] = (-1085.6063, 4652.5591, 5083.5430);
	angles[3] = (0, 179.3774, 0);
	at[3] = 5.1000;
	points[4] = (-1078.3898, 4652.4805, 5083.5430);
	angles[4] = (0, 179.3774, 0);
	at[4] = 5.1500;
	points[5] = (-121.7551, 4642.0864, 5083.5430);
	angles[5] = (0, 179.3774, 0);
	at[5] = 8.7500;
	points[6] = (-112.8972, 4642.0078, 5083.5430);
	angles[6] = (0, 179.3774, 0);
	at[6] = 8.8000;
	points[7] = (-112.8972, 4642.0078, 5083.5430);
	angles[7] = (0, 179.3774, 0);
	at[7] = 10.2500;
	points[8] = (-120.1130, 4642.0864, 5083.5430);
	angles[8] = (0, 179.3774, 0);
	at[8] = 10.3000;
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
	points[0] = (-155.0354, 302.8972, 5083.5430);
	angles[0] = (0, 179.7999, 0);
	at[0] = 0;
	points[1] = (-978.8464, 305.7744, 5083.5430);
	angles[1] = (0, 179.7999, 0);
	at[1] = 3.1000;
	points[2] = (-983.2756, 305.7898, 5083.5430);
	angles[2] = (0, 179.7999, 0);
	at[2] = 3.1500;
	points[3] = (-983.2756, 305.7898, 5083.5430);
	angles[3] = (0, 179.7999, 0);
	at[3] = 4.6000;
	points[4] = (-146.2390, 302.8665, 5083.5430);
	angles[4] = (0, 179.7999, 0);
	at[4] = 7.7500;
	points[5] = (-146.2390, 302.8665, 5083.5430);
	angles[5] = (0, 179.7999, 0);
	at[5] = 9.2500;
	points[6] = (-155.0354, 302.8972, 5083.5430);
	angles[6] = (0, 179.7999, 0);
	at[6] = 9.2667;
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
	points[0] = (-238.6339, -6297.3623, 4963.2681);
	angles[0] = (0, 91.3512, 0);
	at[0] = 0;
	points[1] = (-260.5658, -5367.4805, 4963.2681);
	angles[1] = (0, 91.3512, 0);
	at[1] = 3.5000;
	points[2] = (-260.5658, -5367.4805, 4963.2681);
	angles[2] = (0, 91.3512, 0);
	at[2] = 5;
	points[3] = (-238.6138, -6298.1890, 4963.2681);
	angles[3] = (0, 91.3512, 0);
	at[3] = 8.5000;
	points[4] = (-238.5094, -6302.6382, 4963.2681);
	angles[4] = (0, 91.3512, 0);
	at[4] = 8.5500;
	points[5] = (-238.5094, -6302.6382, 4963.2681);
	angles[5] = (0, 91.3512, 0);
	at[5] = 10;
	points[6] = (-238.6339, -6297.3623, 4963.2681);
	angles[6] = (0, 91.3512, 0);
	at[6] = 10.0333;
	mover = getEnt("iz_obj_5", "targetname");
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
