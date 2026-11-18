main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_daisy_hills", 0);

	setExpFog(15463.0410, 29231.2422, 0.7176, 0.7333, 0.7451, 0);

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
	ambientPlay("iz_0_105", 2);
	iz_emitter("iz_1_se_cc_env_audience_m", (-5829.4102, -534.5105, 912.2764), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-5860.4146, 461.9938, 937.8392), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-6877.3438, 459.5970, 966.6765), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-6864.9419, 2125.2109, 1015.5956), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-6923.1470, -3473.2676, 805.8003), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-5848.0127, -1520.8521, 869.1596), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-6343, -353, 914);
	level.iz_route[level.iz_route.size] = (-6343, -1234, 883);
	level.iz_route[level.iz_route.size] = (-6322, -2030, 855);
	level.iz_route[level.iz_route.size] = (-6322, -2827, 827);
	level.iz_route[level.iz_route.size] = (-6301, -3540, 802);
	level.iz_route[level.iz_route.size] = (-6217, -4127, 801);
	level.iz_route[level.iz_route.size] = (-5735, -4336, 801);
	level.iz_route[level.iz_route.size] = (-5169, -4315, 795);
	level.iz_route[level.iz_route.size] = (-4582, -4294, 777);
	level.iz_route[level.iz_route.size] = (-3848, -4315, 756);
	level.iz_route[level.iz_route.size] = (-2968, -4294, 756);
	level.iz_route[level.iz_route.size] = (-2150, -4315, 756);
	level.iz_route[level.iz_route.size] = (-1374, -4336, 757);
	level.iz_route[level.iz_route.size] = (-850, -4420, 779);
	level.iz_route[level.iz_route.size] = (-431, -4714, 823);
	level.iz_route[level.iz_route.size] = (9, -5175, 940);
	level.iz_route[level.iz_route.size] = (464, -5689, 1087);
	level.iz_route[level.iz_route.size] = (785, -6055, 1192);
	level.iz_route[level.iz_route.size] = (1246, -6684, 1359);
	level.iz_route[level.iz_route.size] = (1812, -7397, 1558);
	level.iz_route[level.iz_route.size] = (2462, -8215, 1788);
	level.iz_route[level.iz_route.size] = (2962, -8895, 1974);
	level.iz_route[level.iz_route.size] = (3329, -9505, 2163);
	level.iz_route[level.iz_route.size] = (3789, -10123, 2322);
	level.iz_route[level.iz_route.size] = (4429, -10571, 2492);
	level.iz_route[level.iz_route.size] = (5230, -10664, 2609);
	level.iz_route[level.iz_route.size] = (5791, -10498, 2651);
	level.iz_route[level.iz_route.size] = (6244, -10050, 2629);
	level.iz_route[level.iz_route.size] = (6617, -9527, 2558);
	level.iz_route[level.iz_route.size] = (6754, -8885, 2455);
	level.iz_route[level.iz_route.size] = (6819, -8156, 2350);
	level.iz_route[level.iz_route.size] = (6783, -7509, 2275);
	level.iz_route[level.iz_route.size] = (6867, -6934, 2260);
	level.iz_route[level.iz_route.size] = (6889, -6364, 2270);
	level.iz_route[level.iz_route.size] = (7113, -5535, 2333);
	level.iz_route[level.iz_route.size] = (7503, -4958, 2402);
	level.iz_route[level.iz_route.size] = (7979, -4607, 2474);
	level.iz_route[level.iz_route.size] = (8482, -4395, 2566);
	level.iz_route[level.iz_route.size] = (9067, -4092, 2694);
	level.iz_route[level.iz_route.size] = (9548, -3819, 2798);
	level.iz_route[level.iz_route.size] = (10247, -3384, 2968);
	level.iz_route[level.iz_route.size] = (10726, -2957, 3097);
	level.iz_route[level.iz_route.size] = (11095, -2451, 3206);
	level.iz_route[level.iz_route.size] = (11274, -1893, 3261);
	level.iz_route[level.iz_route.size] = (11232, -1171, 3245);
	level.iz_route[level.iz_route.size] = (10815, -551, 3083);
	level.iz_route[level.iz_route.size] = (10216, -204, 2897);
	level.iz_route[level.iz_route.size] = (9824, 83, 2778);
	level.iz_route[level.iz_route.size] = (9303, 481, 2596);
	level.iz_route[level.iz_route.size] = (8829, 831, 2430);
	level.iz_route[level.iz_route.size] = (8232, 1202, 2228);
	level.iz_route[level.iz_route.size] = (7577, 1549, 2038);
	level.iz_route[level.iz_route.size] = (7242, 1726, 1995);
	level.iz_route[level.iz_route.size] = (6897, 1945, 2103);
	level.iz_route[level.iz_route.size] = (185, 5245, 798);
	level.iz_route[level.iz_route.size] = (-719, 5721, 1034);
	level.iz_route[level.iz_route.size] = (-1720, 6222, 1121);
	level.iz_route[level.iz_route.size] = (-2596, 6389, 1121);
	level.iz_route[level.iz_route.size] = (-2864, 6209, 1121);
	level.iz_route[level.iz_route.size] = (-3254, 5768, 1121);
	level.iz_route[level.iz_route.size] = (-3738, 5772, 1121);
	level.iz_route[level.iz_route.size] = (-4122, 6042, 1121);
	level.iz_route[level.iz_route.size] = (-4687, 6404, 1121);
	level.iz_route[level.iz_route.size] = (-5411, 6195, 1121);
	level.iz_route[level.iz_route.size] = (-6053, 5799, 1121);
	level.iz_route[level.iz_route.size] = (-6333, 5204, 1122);
	level.iz_route[level.iz_route.size] = (-6334, 4416, 1124);
	level.iz_route[level.iz_route.size] = (-6349, 3776, 1128);
	level.iz_route[level.iz_route.size] = (-6329, 3274, 1076);
	level.iz_route[level.iz_route.size] = (-6347, 2942, 1067);
	level.iz_route[level.iz_route.size] = (-6358, 1991, 1019);
	level.iz_route[level.iz_route.size] = (-6366, 1280, 971);
	level.iz_route[level.iz_route.size] = (-6349, 695, 951);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4980.2759, -9934.7637, 2573);
	angles[0] = (0, 153.6494, 0);
	at[0] = 0;
	points[1] = (4969.8428, -9971.8896, 2573.0984);
	angles[1] = (0, 162.1841, 0);
	at[1] = 0.2167;
	points[2] = (4955.0786, -10047.4414, 2573.9136);
	angles[2] = (0, 169.3273, 0);
	at[2] = 0.6500;
	points[3] = (4945.5117, -10123.8184, 2575.2520);
	angles[3] = (0, 173.6042, 0);
	at[3] = 1.0833;
	points[4] = (4944.1733, -10162.4414, 2576.2639);
	angles[4] = (0, 177.5880, 0);
	at[4] = 1.3000;
	points[5] = (4948.8584, -10198.6230, 2581.0435);
	angles[5] = (0, 185.6952, 0);
	at[5] = 1.5167;
	points[6] = (4956.6143, -10235.5518, 2590.2954);
	angles[6] = (0, 190.5513, 0);
	at[6] = 1.7333;
	points[7] = (4985.5513, -10344.0938, 2618.1182);
	angles[7] = (0, 195.8850, 0);
	at[7] = 2.3833;
	points[8] = (5009.2915, -10414.9219, 2636.7717);
	angles[8] = (0, 199.2549, 0);
	at[8] = 2.8167;
	points[9] = (5024.3701, -10449.3311, 2646.1931);
	angles[9] = (0, 203.3637, 0);
	at[9] = 3.0333;
	points[10] = (5044.6460, -10478.9375, 2655.0435);
	angles[10] = (0, 212.5309, 0);
	at[10] = 3.2500;
	points[11] = (5068.7007, -10507.7168, 2664.1062);
	angles[11] = (0, 218.3420, 0);
	at[11] = 3.4667;
	points[12] = (5119.9214, -10562.6377, 2681.9211);
	angles[12] = (0, 223.3554, 0);
	at[12] = 3.9000;
	points[13] = (5202.0474, -10639.2129, 2707.8701);
	angles[13] = (0, 228.6827, 0);
	at[13] = 4.5500;
	points[14] = (5232.7559, -10661.8506, 2716.4214);
	angles[14] = (0, 233.3286, 0);
	at[14] = 4.7667;
	points[15] = (5266.6143, -10674.9609, 2723.2126);
	angles[15] = (0, 246.4007, 0);
	at[15] = 4.9833;
	points[16] = (5304.0947, -10683.0312, 2729.2324);
	angles[16] = (0, 255.5224, 0);
	at[16] = 5.2000;
	points[17] = (5341.6929, -10688.5039, 2734.6812);
	angles[17] = (0, 260.4339, 0);
	at[17] = 5.4167;
	points[18] = (5456.2603, -10694.6846, 2749.3899);
	angles[18] = (0, 269.3033, 0);
	at[18] = 6.0667;
	points[19] = (5492.8350, -10690, 2752.8071);
	angles[19] = (0, 277, 0);
	at[19] = 6.2833;
	points[20] = (5529.2129, -10676.7324, 2754.2598);
	angles[20] = (0, 287.4662, 0);
	at[20] = 6.5000;
	points[21] = (5564.2910, -10660.7871, 2754.9490);
	angles[21] = (0, 292.9808, 0);
	at[21] = 6.7167;
	points[22] = (5632.3623, -10624.5674, 2755.0867);
	angles[22] = (0, 298.6230, 0);
	at[22] = 7.1500;
	points[23] = (5696.0630, -10581.1807, 2753.0710);
	angles[23] = (0, 306.2298, 0);
	at[23] = 7.5833;
	points[24] = (5718.4253, -10551.8506, 2749.5120);
	angles[24] = (0, 320.5508, 0);
	at[24] = 7.8000;
	points[25] = (5735.3149, -10517.2441, 2744.7166);
	angles[25] = (0, 331.0819, 0);
	at[25] = 8.0167;
	points[26] = (5762.9526, -10446.4570, 2733.4370);
	angles[26] = (0, 339.0362, 0);
	at[26] = 8.4500;
	points[27] = (5786.0630, -10374.1338, 2720.3977);
	angles[27] = (0, 342.8082, 0);
	at[27] = 8.8833;
	points[28] = (5801.0234, -10301.2207, 2706.8464);
	angles[28] = (0, 350.1265, 0);
	at[28] = 9.3167;
	points[29] = (5815.3545, -10112.8740, 2669.5867);
	angles[29] = (0, 357.3232, 0);
	at[29] = 10.4000;
	points[30] = (5815.3545, -10037.0078, 2652.8782);
	angles[30] = (0, 360.9452, 0);
	at[30] = 10.8333;
	points[31] = (5810.1182, -10000.6299, 2644.0789);
	angles[31] = (0, 367.2857, 0);
	at[31] = 11.0500;
	points[32] = (5790.7085, -9927.2441, 2624.9646);
	angles[32] = (0, 375.1849, 0);
	at[32] = 11.4833;
	points[33] = (5754.0552, -9818.9375, 2615.2637);
	angles[33] = (0, 379.8146, 0);
	at[33] = 12.1333;
	points[34] = (5722.8350, -9749.4883, 2609.2715);
	angles[34] = (0, 386.2112, 0);
	at[34] = 12.5667;
	points[35] = (5722.8350, -9749.4883, 2609.2715);
	angles[35] = (0, 390.2263, 0);
	at[35] = 12.7833;
	points[36] = (5722.8350, -9749.4883, 2609.2715);
	angles[36] = (0, 391.5718, 0);
	at[36] = 13.4333;
	points[37] = (5722.8350, -9749.4883, 2609.2715);
	angles[37] = (0, 391.5942, 0);
	at[37] = 30.5500;
	points[38] = (5702.2441, -9721.6934, 2606.6733);
	angles[38] = (0, 395.8348, 0);
	at[38] = 30.7667;
	points[39] = (5650.3545, -9664.8428, 2600.6023);
	angles[39] = (0, 402.9504, 0);
	at[39] = 31.2000;
	points[40] = (5565.0786, -9587.8350, 2591.6770);
	angles[40] = (0, 410.1748, 0);
	at[40] = 31.8500;
	points[41] = (5532.5591, -9567.0078, 2588.8386);
	angles[41] = (0, 417.1213, 0);
	at[41] = 32.0667;
	points[42] = (5495.8267, -9559.0947, 2586.6772);
	angles[42] = (0, 434.0983, 0);
	at[42] = 32.2833;
	points[43] = (5457.4409, -9556.9297, 2586.2046);
	angles[43] = (0, 444.0264, 0);
	at[43] = 32.5000;
	points[44] = (5342.0474, -9562.9131, 2588.8584);
	angles[44] = (0, 455.0630, 0);
	at[44] = 33.1500;
	points[45] = (5303.9761, -9569.2129, 2588.8071);
	angles[45] = (0, 458.8993, 0);
	at[45] = 33.3667;
	points[46] = (5268.9766, -9583.1494, 2586.9016);
	angles[46] = (0, 470.8954, 0);
	at[46] = 33.5833;
	points[47] = (5238.9370, -9606.4570, 2585.6536);
	angles[47] = (0, 484.2164, 0);
	at[47] = 33.8000;
	points[48] = (5210.4331, -9632.5596, 2584.6064);
	angles[48] = (0, 490.6904, 0);
	at[48] = 34.0167;
	points[49] = (5130.4331, -9715.9453, 2580.9172);
	angles[49] = (0, 497.2268, 0);
	at[49] = 34.6667;
	points[50] = (5110.9844, -9738.1104, 2579.7085);
	angles[50] = (0, 498.6736, 0);
	at[50] = 34.8833;
	points[51] = (5110.9844, -9738.1104, 2579.7085);
	angles[51] = (0, 499.5469, 0);
	at[51] = 47.6667;
	points[52] = (5105.9448, -9744.1338, 2579.4055);
	angles[52] = (0, 499.7316, 0);
	at[52] = 47.8833;
	points[53] = (5016.1421, -9869.4883, 2574.5081);
	angles[53] = (0, 506.2516, 0);
	at[53] = 48.7500;
	points[54] = (4996.1812, -9902.3232, 2573.5630);
	angles[54] = (0, 508.3698, 0);
	at[54] = 48.9667;
	points[55] = (4980.2759, -9934.7637, 2573);
	angles[55] = (0, 513.6494, 0);
	at[55] = 49.1833;
	mover = getEnt("iz_obj_0", "targetname");
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
