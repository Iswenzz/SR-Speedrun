main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_choco_island_1", 0);

	setExpFog(8858.2676, 49751.9609, 1, 1, 1, 0);

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
	ambientPlay("iz_0_5", 2);
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
	level.iz_route[level.iz_route.size] = (-5962, 2043, 386);
	level.iz_route[level.iz_route.size] = (-5856, 1013, 386);
	level.iz_route[level.iz_route.size] = (-5625, 320, 386);
	level.iz_route[level.iz_route.size] = (-5145, -213, 386);
	level.iz_route[level.iz_route.size] = (-4737, -745, 386);
	level.iz_route[level.iz_route.size] = (-4542, -1420, 386);
	level.iz_route[level.iz_route.size] = (-4577, -1829, 386);
	level.iz_route[level.iz_route.size] = (-4702, -2397, 386);
	level.iz_route[level.iz_route.size] = (-4950, -3018, 386);
	level.iz_route[level.iz_route.size] = (-4826, -3676, 386);
	level.iz_route[level.iz_route.size] = (-4293, -4120, 386);
	level.iz_route[level.iz_route.size] = (-3725, -4084, 386);
	level.iz_route[level.iz_route.size] = (-3050, -3800, 386);
	level.iz_route[level.iz_route.size] = (-2127, -3498, 386);
	level.iz_route[level.iz_route.size] = (-1292, -3214, 386);
	level.iz_route[level.iz_route.size] = (-528, -3001, 386);
	level.iz_route[level.iz_route.size] = (289, -2752, 386);
	level.iz_route[level.iz_route.size] = (981, -2503, 386);
	level.iz_route[level.iz_route.size] = (1436, -2246, 386);
	level.iz_route[level.iz_route.size] = (1541, -1493, 386);
	level.iz_route[level.iz_route.size] = (1648, -783, 386);
	level.iz_route[level.iz_route.size] = (1914, -73, 386);
	level.iz_route[level.iz_route.size] = (2411, 371, 386);
	level.iz_route[level.iz_route.size] = (3139, 744, 386);
	level.iz_route[level.iz_route.size] = (3530, 1188, 386);
	level.iz_route[level.iz_route.size] = (3672, 1579, 386);
	level.iz_route[level.iz_route.size] = (3672, 2076, 386);
	level.iz_route[level.iz_route.size] = (3672, 2467, 386);
	level.iz_route[level.iz_route.size] = (3637, 2946, 386);
	level.iz_route[level.iz_route.size] = (3594, 3421, 419);
	level.iz_route[level.iz_route.size] = (3581, 4131, 386);
	level.iz_route[level.iz_route.size] = (3507, 4754, 386);
	level.iz_route[level.iz_route.size] = (3206, 5532, 386);
	level.iz_route[level.iz_route.size] = (2729, 5808, 386);
	level.iz_route[level.iz_route.size] = (2052, 5808, 386);
	level.iz_route[level.iz_route.size] = (1626, 5707, 386);
	level.iz_route[level.iz_route.size] = (999, 5381, 386);
	level.iz_route[level.iz_route.size] = (447, 5105, 386);
	level.iz_route[level.iz_route.size] = (-356, 4905, 386);
	level.iz_route[level.iz_route.size] = (-1159, 5080, 386);
	level.iz_route[level.iz_route.size] = (-1585, 5306, 386);
	level.iz_route[level.iz_route.size] = (-2043, 5506, 386);
	level.iz_route[level.iz_route.size] = (-2824, 5737, 386);
	level.iz_route[level.iz_route.size] = (-3463, 5790, 386);
	level.iz_route[level.iz_route.size] = (-4049, 5826, 386);
	level.iz_route[level.iz_route.size] = (-4706, 5737, 386);
	level.iz_route[level.iz_route.size] = (-5168, 5506, 386);
	level.iz_route[level.iz_route.size] = (-5648, 5151, 386);
	level.iz_route[level.iz_route.size] = (-5896, 4689, 386);
	level.iz_route[level.iz_route.size] = (-5950, 3872, 386);
	level.iz_route[level.iz_route.size] = (-5932, 3144, 386);
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
	points[0] = (548.9330, 4800.3545, 208.9346);
	angles[0] = (0, -5.4380, 0);
	at[0] = 0;
	points[1] = (644.0984, 4893.5039, 208.9346);
	angles[1] = (0, -5.4380, 0);
	at[1] = 0.3000;
	points[2] = (678.0394, 4921.7324, 208.9346);
	angles[2] = (0, -5.4380, 0);
	at[2] = 0.4000;
	points[3] = (754.3149, 4966.8896, 208.9346);
	angles[3] = (0, -5.4380, 0);
	at[3] = 0.6000;
	points[4] = (795.3150, 4984.2124, 386.1000);
	angles[4] = (0, -5.4380, 0);
	at[4] = 0.7000;
	points[5] = (795.3150, 4984.2124, 386.1000);
	angles[5] = (0, -5.4380, 0);
	at[5] = 2.3000;
	points[6] = (795.3150, 4984.2124, 422.8898);
	angles[6] = (0, -5.4380, 0);
	at[6] = 2.4000;
	points[7] = (795.3150, 4984.2124, 514.1299);
	angles[7] = (0, -5.4380, 0);
	at[7] = 2.5000;
	points[8] = (795.3150, 4984.2124, 576.6693);
	angles[8] = (0, -5.4380, 0);
	at[8] = 2.6000;
	points[9] = (795.3150, 4984.2124, 610.5079);
	angles[9] = (0, -5.4380, 0);
	at[9] = 2.7000;
	points[10] = (795.3150, 4984.2124, 615.6457);
	angles[10] = (0, -5.4380, 0);
	at[10] = 2.8000;
	points[11] = (795.3150, 4984.2124, 592.0827);
	angles[11] = (0, -5.4380, 0);
	at[11] = 2.9000;
	points[12] = (795.3150, 4984.2124, 539.8189);
	angles[12] = (0, -5.4380, 0);
	at[12] = 3;
	points[13] = (795.3150, 4984.2124, 458.8543);
	angles[13] = (0, -5.4380, 0);
	at[13] = 3.1000;
	points[14] = (802.0394, 4985.3545, 208.9346);
	angles[14] = (0, -5.4380, 0);
	at[14] = 3.2000;
	points[15] = (845.2520, 4976.0234, 208.9346);
	angles[15] = (0, -5.4380, 0);
	at[15] = 3.3000;
	points[16] = (886.3032, 4959.0552, 208.9346);
	angles[16] = (0, -5.4380, 0);
	at[16] = 3.4000;
	points[17] = (921.8425, 4933.9370, 208.9346);
	angles[17] = (0, -5.4380, 0);
	at[17] = 3.5000;
	points[18] = (941.7441, 4894.2915, 208.9346);
	angles[18] = (0, -5.4380, 0);
	at[18] = 3.6000;
	points[19] = (956.7205, 4852.4805, 208.9346);
	angles[19] = (0, -5.4380, 0);
	at[19] = 3.7000;
	points[20] = (955.0551, 4809.5278, 208.9346);
	angles[20] = (0, -5.4380, 0);
	at[20] = 3.8000;
	points[21] = (932.2284, 4771.7324, 208.9346);
	angles[21] = (0, -5.4380, 0);
	at[21] = 3.9000;
	points[22] = (899.7638, 4742.0474, 208.9346);
	angles[22] = (0, -5.4380, 0);
	at[22] = 4;
	points[23] = (760.2717, 4632.1655, 208.9346);
	angles[23] = (0, -5.4380, 0);
	at[23] = 4.4000;
	points[24] = (628.2480, 4514.2915, 208.9346);
	angles[24] = (0, -5.4380, 0);
	at[24] = 4.8000;
	points[25] = (558.6653, 4459.1733, 208.9346);
	angles[25] = (0, -5.4380, 0);
	at[25] = 5;
	points[26] = (519.6771, 4437.0078, 208.9346);
	angles[26] = (0, -5.4380, 0);
	at[26] = 5.1000;
	points[27] = (396.3898, 4385.0396, 208.9346);
	angles[27] = (0, -5.4380, 0);
	at[27] = 5.4000;
	points[28] = (271.5945, 4337.7559, 208.9346);
	angles[28] = (0, -5.4380, 0);
	at[28] = 5.7000;
	points[29] = (145.5898, 4294.9609, 208.9346);
	angles[29] = (0, -5.4380, 0);
	at[29] = 6;
	points[30] = (110.1402, 4284.9604, 386.1000);
	angles[30] = (0, -5.4380, 0);
	at[30] = 6.1000;
	points[31] = (110.1402, 4284.9604, 386.1000);
	angles[31] = (0, -5.4380, 0);
	at[31] = 7.7000;
	points[32] = (110.1402, 4284.9604, 440.0905);
	angles[32] = (0, -5.4380, 0);
	at[32] = 7.8000;
	points[33] = (110.1402, 4284.9604, 526.5472);
	angles[33] = (0, -5.4380, 0);
	at[33] = 7.9000;
	points[34] = (110.1402, 4284.9604, 584.3032);
	angles[34] = (0, -5.4380, 0);
	at[34] = 8;
	points[35] = (110.1402, 4284.9604, 613.3583);
	angles[35] = (0, -5.4380, 0);
	at[35] = 8.1000;
	points[36] = (110.1402, 4284.9604, 613.7126);
	angles[36] = (0, -5.4380, 0);
	at[36] = 8.2000;
	points[37] = (110.1402, 4284.9604, 585.3661);
	angles[37] = (0, -5.4380, 0);
	at[37] = 8.3000;
	points[38] = (110.1402, 4284.9604, 528.3189);
	angles[38] = (0, -5.4380, 0);
	at[38] = 8.4000;
	points[39] = (110.1402, 4284.9604, 442.5709);
	angles[39] = (0, -5.4380, 0);
	at[39] = 8.5000;
	points[40] = (97.4752, 4281.9688, 208.9346);
	angles[40] = (0, -5.4380, 0);
	at[40] = 8.6000;
	points[41] = (-34.3039, 4257.5981, 208.9346);
	angles[41] = (0, -5.4380, 0);
	at[41] = 8.9000;
	points[42] = (-209.8689, 4231.8896, 208.9346);
	angles[42] = (0, -5.4380, 0);
	at[42] = 9.3000;
	points[43] = (-342.9980, 4216.9688, 208.9346);
	angles[43] = (0, -5.4380, 0);
	at[43] = 9.6000;
	points[44] = (-387.5665, 4213.9370, 208.9346);
	angles[44] = (0, -5.4380, 0);
	at[44] = 9.7000;
	points[45] = (-429.2953, 4214.0947, 208.9346);
	angles[45] = (0, -5.4380, 0);
	at[45] = 9.8000;
	points[46] = (-562.1181, 4227.7168, 208.9346);
	angles[46] = (0, -5.4380, 0);
	at[46] = 10.1000;
	points[47] = (-737.8386, 4255.7090, 208.9346);
	angles[47] = (0, -5.4380, 0);
	at[47] = 10.5000;
	points[48] = (-825.2363, 4273.3857, 208.9346);
	angles[48] = (0, -5.4380, 0);
	at[48] = 10.7000;
	points[49] = (-908.2717, 4298.5435, 208.9346);
	angles[49] = (0, -5.4380, 0);
	at[49] = 10.9000;
	points[50] = (-990.2205, 4333.2681, 208.9346);
	angles[50] = (0, -5.4380, 0);
	at[50] = 11.1000;
	points[51] = (-1110.2047, 4391.8110, 208.9346);
	angles[51] = (0, -5.4380, 0);
	at[51] = 11.4000;
	points[52] = (-1187.6260, 4435.9844, 208.9346);
	angles[52] = (0, -5.4380, 0);
	at[52] = 11.6000;
	points[53] = (-1222.9607, 4461.4565, 208.9346);
	angles[53] = (0, -5.4380, 0);
	at[53] = 11.7000;
	points[54] = (-1251.7638, 4493.7402, 208.9346);
	angles[54] = (0, -5.4380, 0);
	at[54] = 11.8000;
	points[55] = (-1277.8544, 4530.0396, 208.9346);
	angles[55] = (0, -5.4380, 0);
	at[55] = 11.9000;
	points[56] = (-1325.0433, 4605.4331, 208.9346);
	angles[56] = (0, -5.4380, 0);
	at[56] = 12.1000;
	points[57] = (-1367.5078, 4683.2285, 208.9346);
	angles[57] = (0, -5.4380, 0);
	at[57] = 12.3000;
	points[58] = (-1386.7755, 4723.8188, 208.9346);
	angles[58] = (0, -5.4380, 0);
	at[58] = 12.4000;
	points[59] = (-1401.3938, 4764.6851, 208.9346);
	angles[59] = (0, -5.4380, 0);
	at[59] = 12.5000;
	points[60] = (-1401.8700, 4808.9370, 208.9346);
	angles[60] = (0, -5.4380, 0);
	at[60] = 12.6000;
	points[61] = (-1386.7677, 4896.3384, 208.9346);
	angles[61] = (0, -5.4380, 0);
	at[61] = 12.8000;
	points[62] = (-1374.9961, 4939.1338, 208.9346);
	angles[62] = (0, -5.4380, 0);
	at[62] = 12.9000;
	points[63] = (-1359.1732, 4980.9058, 208.9346);
	angles[63] = (0, -5.4380, 0);
	at[63] = 13;
	points[64] = (-1329.2284, 4997.3623, 208.9346);
	angles[64] = (0, -5.4380, 0);
	at[64] = 13.1000;
	points[65] = (-1301.8505, 4963.3467, 208.9346);
	angles[65] = (0, -5.4380, 0);
	at[65] = 13.2000;
	points[66] = (-1202.9922, 4814.8032, 208.9346);
	angles[66] = (0, -5.4380, 0);
	at[66] = 13.6000;
	points[67] = (-1150.1772, 4743.5039, 208.9346);
	angles[67] = (0, -5.4380, 0);
	at[67] = 13.8000;
	points[68] = (-1116.3740, 4715.9844, 208.9346);
	angles[68] = (0, -5.4380, 0);
	at[68] = 13.9000;
	points[69] = (-1077.6063, 4695.5117, 208.9346);
	angles[69] = (0, -5.4380, 0);
	at[69] = 14;
	points[70] = (-995.8976, 4660.1973, 208.9346);
	angles[70] = (0, -5.4380, 0);
	at[70] = 14.2000;
	points[71] = (-870.1811, 4615.1182, 208.9346);
	angles[71] = (0, -5.4380, 0);
	at[71] = 14.5000;
	points[72] = (-835.1102, 4604.7246, 386.1000);
	angles[72] = (0, -5.4380, 0);
	at[72] = 14.6000;
	points[73] = (-835.1102, 4604.7246, 386.1000);
	angles[73] = (0, -5.4380, 0);
	at[73] = 16.2000;
	points[74] = (-835.1102, 4604.7246, 440.0905);
	angles[74] = (0, -5.4380, 0);
	at[74] = 16.3000;
	points[75] = (-835.1102, 4604.7246, 526.5472);
	angles[75] = (0, -5.4380, 0);
	at[75] = 16.4000;
	points[76] = (-835.1102, 4604.7246, 584.3032);
	angles[76] = (0, -5.4380, 0);
	at[76] = 16.5000;
	points[77] = (-835.1102, 4604.7246, 613.3583);
	angles[77] = (0, -5.4380, 0);
	at[77] = 16.6000;
	points[78] = (-835.1102, 4604.7246, 613.7126);
	angles[78] = (0, -5.4380, 0);
	at[78] = 16.7000;
	points[79] = (-835.1102, 4604.7246, 585.3661);
	angles[79] = (0, -5.4380, 0);
	at[79] = 16.8000;
	points[80] = (-835.1102, 4604.7246, 528.3189);
	angles[80] = (0, -5.4380, 0);
	at[80] = 16.9000;
	points[81] = (-835.1102, 4604.7246, 442.5709);
	angles[81] = (0, -5.4380, 0);
	at[81] = 17;
	points[82] = (-822.2087, 4601.5356, 208.9346);
	angles[82] = (0, -5.4380, 0);
	at[82] = 17.1000;
	points[83] = (-646.0748, 4573.9766, 208.9346);
	angles[83] = (0, -5.4380, 0);
	at[83] = 17.5000;
	points[84] = (-294.0287, 4532.9136, 208.9346);
	angles[84] = (0, -5.4380, 0);
	at[84] = 18.3000;
	points[85] = (-117.5752, 4519.0156, 208.9346);
	angles[85] = (0, -5.4380, 0);
	at[85] = 18.7000;
	points[86] = (-73.2291, 4518.5830, 208.9346);
	angles[86] = (0, -5.4380, 0);
	at[86] = 18.8000;
	points[87] = (-29.0966, 4522.8740, 208.9346);
	angles[87] = (0, -5.4380, 0);
	at[87] = 18.9000;
	points[88] = (140.7280, 4572.7954, 208.9346);
	angles[88] = (0, -5.4380, 0);
	at[88] = 19.3000;
	points[89] = (267.3760, 4615.8267, 208.9346);
	angles[89] = (0, -5.4380, 0);
	at[89] = 19.6000;
	points[90] = (307.2925, 4631.8110, 208.9346);
	angles[90] = (0, -5.4380, 0);
	at[90] = 19.7000;
	points[91] = (384.0445, 4676.5352, 208.9346);
	angles[91] = (0, -5.4380, 0);
	at[91] = 19.9000;
	points[92] = (457.4685, 4726.2598, 208.9346);
	angles[92] = (0, -5.4380, 0);
	at[92] = 20.1000;
	points[93] = (493.4803, 4752.2837, 208.9346);
	angles[93] = (0, -5.4380, 0);
	at[93] = 20.2000;
	points[94] = (548.9330, 4800.3545, 208.9346);
	angles[94] = (0, -5.4380, 0);
	at[94] = 20.3667;
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
	points[0] = (-4713.6221, -4262.4014, 208.9346);
	angles[0] = (0, -88.4531, 0);
	at[0] = 0;
	points[1] = (-4595.7090, -4249.5669, 208.9346);
	angles[1] = (0, -88.4531, 0);
	at[1] = 0.2667;
	points[2] = (-4480.0396, -4225.4331, 208.9346);
	angles[2] = (0, -88.4531, 0);
	at[2] = 0.5333;
	points[3] = (-4423.8584, -4205.9448, 386.1000);
	angles[3] = (0, -88.4531, 0);
	at[3] = 0.6667;
	points[4] = (-4423.8584, -4205.9448, 386.1000);
	angles[4] = (0, -88.4531, 0);
	at[4] = 2.2667;
	points[5] = (-4423.8584, -4205.9448, 456.4921);
	angles[5] = (0, -88.4531, 0);
	at[5] = 2.4000;
	points[6] = (-4423.8584, -4205.9448, 559.0118);
	angles[6] = (0, -88.4531, 0);
	at[6] = 2.5333;
	points[7] = (-4423.8584, -4205.9448, 610.5079);
	angles[7] = (0, -88.4531, 0);
	at[7] = 2.6667;
	points[8] = (-4423.8584, -4205.9448, 610.9803);
	angles[8] = (0, -88.4531, 0);
	at[8] = 2.8000;
	points[9] = (-4423.8584, -4205.9448, 560.4291);
	angles[9] = (0, -88.4531, 0);
	at[9] = 2.9333;
	points[10] = (-4423.8584, -4205.9448, 458.8543);
	angles[10] = (0, -88.4531, 0);
	at[10] = 3.0667;
	points[11] = (-4406.4175, -4195.4727, 208.9346);
	angles[11] = (0, -88.4531, 0);
	at[11] = 3.2000;
	points[12] = (-4361.0630, -4156.9292, 208.9346);
	angles[12] = (0, -88.4531, 0);
	at[12] = 3.3333;
	points[13] = (-4319.2915, -4114.7637, 208.9346);
	angles[13] = (0, -88.4531, 0);
	at[13] = 3.4667;
	points[14] = (-4241.3779, -4025.1968, 208.9346);
	angles[14] = (0, -88.4531, 0);
	at[14] = 3.7333;
	points[15] = (-4205.2363, -3977.8347, 208.9346);
	angles[15] = (0, -88.4531, 0);
	at[15] = 3.8667;
	points[16] = (-4174.0947, -3927.0867, 208.9346);
	angles[16] = (0, -88.4531, 0);
	at[16] = 4;
	points[17] = (-4181.7324, -3872.0195, 208.9346);
	angles[17] = (0, -88.4531, 0);
	at[17] = 4.1333;
	points[18] = (-4212.2441, -3821.1301, 208.9346);
	angles[18] = (0, -88.4531, 0);
	at[18] = 4.2667;
	points[19] = (-4248.5435, -3774.2520, 208.9346);
	angles[19] = (0, -88.4531, 0);
	at[19] = 4.4000;
	points[20] = (-4289.1733, -3730.6379, 208.9346);
	angles[20] = (0, -88.4531, 0);
	at[20] = 4.5333;
	points[21] = (-4341.2993, -3706.6299, 208.9346);
	angles[21] = (0, -88.4531, 0);
	at[21] = 4.6667;
	points[22] = (-4399.0552, -3693.6062, 208.9346);
	angles[22] = (0, -88.4531, 0);
	at[22] = 4.8000;
	points[23] = (-4455.5513, -3676.3740, 208.9346);
	angles[23] = (0, -88.4531, 0);
	at[23] = 4.9333;
	points[24] = (-4502.6772, -3640.6655, 208.9346);
	angles[24] = (0, -88.4531, 0);
	at[24] = 5.0667;
	points[25] = (-4573.5435, -3545.4646, 208.9346);
	angles[25] = (0, -88.4531, 0);
	at[25] = 5.3333;
	points[26] = (-4638.4648, -3446.2441, 208.9346);
	angles[26] = (0, -88.4531, 0);
	at[26] = 5.6000;
	points[27] = (-4696.6143, -3342.7283, 208.9346);
	angles[27] = (0, -88.4531, 0);
	at[27] = 5.8667;
	points[28] = (-4719.7241, -3288.2637, 208.9346);
	angles[28] = (0, -88.4531, 0);
	at[28] = 6;
	points[29] = (-4721.7715, -3281.8188, 386.1000);
	angles[29] = (0, -88.4531, 0);
	at[29] = 6.1333;
	points[30] = (-4721.7715, -3281.8188, 386.1000);
	angles[30] = (0, -88.4531, 0);
	at[30] = 7.6000;
	points[31] = (-4721.7715, -3281.8188, 440.0905);
	angles[31] = (0, -88.4531, 0);
	at[31] = 7.7333;
	points[32] = (-4721.7715, -3281.8188, 548.9882);
	angles[32] = (0, -88.4531, 0);
	at[32] = 7.8667;
	points[33] = (-4721.7715, -3281.8188, 606.8622);
	angles[33] = (0, -88.4531, 0);
	at[33] = 8;
	points[34] = (-4721.7715, -3281.8188, 613.7126);
	angles[34] = (0, -88.4531, 0);
	at[34] = 8.1333;
	points[35] = (-4721.7715, -3281.8188, 569.5394);
	angles[35] = (0, -88.4531, 0);
	at[35] = 8.2667;
	points[36] = (-4721.7715, -3281.8188, 474.3425);
	angles[36] = (0, -88.4531, 0);
	at[36] = 8.4000;
	points[37] = (-4725.1182, -3269.7166, 208.9346);
	angles[37] = (0, -88.4531, 0);
	at[37] = 8.5333;
	points[38] = (-4757.6772, -3094.1379, 208.9346);
	angles[38] = (0, -88.4531, 0);
	at[38] = 8.9333;
	points[39] = (-4780.9448, -2917.6458, 208.9346);
	angles[39] = (0, -88.4531, 0);
	at[39] = 9.3333;
	points[40] = (-4796.0630, -2740.3032, 208.9346);
	angles[40] = (0, -88.4531, 0);
	at[40] = 9.7333;
	points[41] = (-4797.4805, -2680.7639, 208.9346);
	angles[41] = (0, -88.4531, 0);
	at[41] = 9.8667;
	points[42] = (-4793.1104, -2623.5234, 208.9346);
	angles[42] = (0, -88.4531, 0);
	at[42] = 10;
	points[43] = (-4770.4331, -2570.0039, 208.9346);
	angles[43] = (0, -88.4531, 0);
	at[43] = 10.1333;
	points[44] = (-4736.7720, -2520.8545, 208.9346);
	angles[44] = (0, -88.4531, 0);
	at[44] = 10.2667;
	points[45] = (-4699.3306, -2474.8701, 208.9346);
	angles[45] = (0, -88.4531, 0);
	at[45] = 10.4000;
	points[46] = (-4542.1655, -2297.4961, 208.9346);
	angles[46] = (0, -88.4531, 0);
	at[46] = 10.9333;
	points[47] = (-4508.6611, -2250.0750, 208.9346);
	angles[47] = (0, -88.4531, 0);
	at[47] = 11.0667;
	points[48] = (-4393.5435, -2044.0433, 208.9346);
	angles[48] = (0, -88.4531, 0);
	at[48] = 11.6000;
	points[49] = (-4312.7954, -1885.9094, 208.9346);
	angles[49] = (0, -88.4531, 0);
	at[49] = 12;
	points[50] = (-4263.8584, -1777.1456, 208.9346);
	angles[50] = (0, -88.4531, 0);
	at[50] = 12.2667;
	points[51] = (-4242.7954, -1721.5237, 208.9346);
	angles[51] = (0, -88.4531, 0);
	at[51] = 12.4000;
	points[52] = (-4227.1260, -1664.2402, 208.9346);
	angles[52] = (0, -88.4531, 0);
	at[52] = 12.5333;
	points[53] = (-4225.9448, -1608.3623, 208.9346);
	angles[53] = (0, -88.4531, 0);
	at[53] = 12.6667;
	points[54] = (-4234.6064, -1549.8032, 208.9346);
	angles[54] = (0, -88.4531, 0);
	at[54] = 12.8000;
	points[55] = (-4261.2993, -1434.4489, 208.9346);
	angles[55] = (0, -88.4531, 0);
	at[55] = 13.0667;
	points[56] = (-4294.2915, -1320.3898, 208.9346);
	angles[56] = (0, -88.4531, 0);
	at[56] = 13.3333;
	points[57] = (-4331.6929, -1207.6969, 208.9346);
	angles[57] = (0, -88.4531, 0);
	at[57] = 13.6000;
	points[58] = (-4374.0552, -1096.8977, 208.9346);
	angles[58] = (0, -88.4531, 0);
	at[58] = 13.8667;
	points[59] = (-4398.5435, -1043.0394, 208.9346);
	angles[59] = (0, -88.4531, 0);
	at[59] = 14;
	points[60] = (-4417.4409, -1010.9645, 386.1000);
	angles[60] = (0, -88.4531, 0);
	at[60] = 14.1333;
	points[61] = (-4417.4409, -1010.9645, 386.1000);
	angles[61] = (0, -88.4531, 0);
	at[61] = 15.7333;
	points[62] = (-4417.4409, -1010.9645, 500.9173);
	angles[62] = (0, -88.4531, 0);
	at[62] = 15.8667;
	points[63] = (-4417.4409, -1010.9645, 584.3032);
	angles[63] = (0, -88.4531, 0);
	at[63] = 16;
	points[64] = (-4417.4409, -1010.9645, 616.6653);
	angles[64] = (0, -88.4531, 0);
	at[64] = 16.1333;
	points[65] = (-4417.4409, -1010.9645, 598.0039);
	angles[65] = (0, -88.4531, 0);
	at[65] = 16.2667;
	points[66] = (-4417.4409, -1010.9645, 528.3189);
	angles[66] = (0, -88.4531, 0);
	at[66] = 16.4000;
	points[67] = (-4417.4409, -1010.9645, 407.6103);
	angles[67] = (0, -88.4531, 0);
	at[67] = 16.5333;
	points[68] = (-4453.5830, -990.8189, 208.9346);
	angles[68] = (0, -88.4531, 0);
	at[68] = 16.6667;
	points[69] = (-4512.6772, -992.2008, 208.9346);
	angles[69] = (0, -88.4531, 0);
	at[69] = 16.8000;
	points[70] = (-4570.5908, -1005.1812, 208.9346);
	angles[70] = (0, -88.4531, 0);
	at[70] = 16.9333;
	points[71] = (-4739.0947, -1060.6654, 208.9346);
	angles[71] = (0, -88.4531, 0);
	at[71] = 17.3333;
	points[72] = (-4912.9136, -1094.8032, 208.9346);
	angles[72] = (0, -88.4531, 0);
	at[72] = 17.7333;
	points[73] = (-4969.5273, -1112.4685, 208.9346);
	angles[73] = (0, -88.4531, 0);
	at[73] = 17.8667;
	points[74] = (-5019.4883, -1143.2795, 208.9346);
	angles[74] = (0, -88.4531, 0);
	at[74] = 18;
	points[75] = (-5036.6538, -1197.5197, 208.9346);
	angles[75] = (0, -88.4531, 0);
	at[75] = 18.1333;
	points[76] = (-5045.4727, -1316.2087, 208.9346);
	angles[76] = (0, -88.4531, 0);
	at[76] = 18.4000;
	points[77] = (-5053.2676, -1553.5355, 208.9346);
	angles[77] = (0, -88.4531, 0);
	at[77] = 18.9333;
	points[78] = (-5059.4883, -1611.2008, 208.9346);
	angles[78] = (0, -88.4531, 0);
	at[78] = 19.0667;
	points[79] = (-5072.5591, -1667.6221, 208.9346);
	angles[79] = (0, -88.4531, 0);
	at[79] = 19.2000;
	points[80] = (-5138.6616, -1895.6614, 208.9346);
	angles[80] = (0, -88.4531, 0);
	at[80] = 19.7333;
	points[81] = (-5211.8110, -2119.6458, 208.9346);
	angles[81] = (0, -88.4531, 0);
	at[81] = 20.2667;
	points[82] = (-5296.6929, -2340.7205, 208.9346);
	angles[82] = (0, -88.4531, 0);
	at[82] = 20.8000;
	points[83] = (-5364.8823, -2504.1221, 208.9346);
	angles[83] = (0, -88.4531, 0);
	at[83] = 21.2000;
	points[84] = (-5377.5200, -2531.3938, 386.1000);
	angles[84] = (0, -88.4531, 0);
	at[84] = 21.3333;
	points[85] = (-5377.5200, -2531.3938, 386.1000);
	angles[85] = (0, -88.4531, 0);
	at[85] = 22.9333;
	points[86] = (-5377.5200, -2531.3938, 514.1299);
	angles[86] = (0, -88.4531, 0);
	at[86] = 23.0667;
	points[87] = (-5377.5200, -2531.3938, 591.1378);
	angles[87] = (0, -88.4531, 0);
	at[87] = 23.2000;
	points[88] = (-5377.5200, -2531.3938, 617.1221);
	angles[88] = (0, -88.4531, 0);
	at[88] = 23.3333;
	points[89] = (-5377.5200, -2531.3938, 592.0827);
	angles[89] = (0, -88.4531, 0);
	at[89] = 23.4667;
	points[90] = (-5377.5200, -2531.3938, 516.0197);
	angles[90] = (0, -88.4531, 0);
	at[90] = 23.6000;
	points[91] = (-5377.5200, -2531.3938, 388.9346);
	angles[91] = (0, -88.4531, 0);
	at[91] = 23.7333;
	points[92] = (-5402.2837, -2575.0471, 208.9346);
	angles[92] = (0, -88.4531, 0);
	at[92] = 23.8667;
	points[93] = (-5565.8267, -2822.4766, 208.9346);
	angles[93] = (0, -88.4531, 0);
	at[93] = 24.5333;
	points[94] = (-5595.0396, -2874, 208.9346);
	angles[94] = (0, -88.4531, 0);
	at[94] = 24.6667;
	points[95] = (-5619.1338, -2927.2678, 208.9346);
	angles[95] = (0, -88.4531, 0);
	at[95] = 24.8000;
	points[96] = (-5628.8188, -2983.4253, 208.9346);
	angles[96] = (0, -88.4531, 0);
	at[96] = 24.9333;
	points[97] = (-5624.0552, -3043.3306, 208.9346);
	angles[97] = (0, -88.4531, 0);
	at[97] = 25.0667;
	points[98] = (-5615.0786, -3101.7913, 208.9346);
	angles[98] = (0, -88.4531, 0);
	at[98] = 25.2000;
	points[99] = (-5578.3071, -3275.8191, 208.9346);
	angles[99] = (0, -88.4531, 0);
	at[99] = 25.6000;
	points[100] = (-5517.1655, -3504.3308, 208.9346);
	angles[100] = (0, -88.4531, 0);
	at[100] = 26.1333;
	points[101] = (-5499.2915, -3558.8623, 208.9346);
	angles[101] = (0, -88.4531, 0);
	at[101] = 26.2667;
	points[102] = (-5477.4409, -3614.2126, 208.9346);
	angles[102] = (0, -88.4531, 0);
	at[102] = 26.4000;
	points[103] = (-5429.0552, -3722.6262, 208.9346);
	angles[103] = (0, -88.4531, 0);
	at[103] = 26.6667;
	points[104] = (-5376.3389, -3828.5198, 208.9346);
	angles[104] = (0, -88.4531, 0);
	at[104] = 26.9333;
	points[105] = (-5317.4409, -3931.1694, 208.9346);
	angles[105] = (0, -88.4531, 0);
	at[105] = 27.2000;
	points[106] = (-5282.5591, -3979.9607, 208.9346);
	angles[106] = (0, -88.4531, 0);
	at[106] = 27.3333;
	points[107] = (-5240.6299, -4018.7007, 208.9346);
	angles[107] = (0, -88.4531, 0);
	at[107] = 27.4667;
	points[108] = (-5143.1499, -4085.5906, 208.9346);
	angles[108] = (0, -88.4531, 0);
	at[108] = 27.7333;
	points[109] = (-4989.7637, -4175.1577, 208.9346);
	angles[109] = (0, -88.4531, 0);
	at[109] = 28.1333;
	points[110] = (-4884.4097, -4228.6221, 208.9346);
	angles[110] = (0, -88.4531, 0);
	at[110] = 28.4000;
	points[111] = (-4828.4253, -4252.0078, 208.9346);
	angles[111] = (0, -88.4531, 0);
	at[111] = 28.5333;
	points[112] = (-4772.7954, -4262.5591, 208.9346);
	angles[112] = (0, -88.4531, 0);
	at[112] = 28.6667;
	points[113] = (-4713.6221, -4262.4014, 208.9346);
	angles[113] = (0, -88.4531, 0);
	at[113] = 28.8000;
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
