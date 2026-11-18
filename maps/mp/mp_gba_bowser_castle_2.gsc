main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_bowser_castle_2", 0);

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
	ambientPlay("iz_0_43", 2);
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
	level.iz_route[level.iz_route.size] = (8544, -2744, 2436);
	level.iz_route[level.iz_route.size] = (8557, -4827, 2436);
	level.iz_route[level.iz_route.size] = (8591, -5543, 2436);
	level.iz_route[level.iz_route.size] = (8436, -5919, 2436);
	level.iz_route[level.iz_route.size] = (8041, -6134, 2436);
	level.iz_route[level.iz_route.size] = (7619, -6206, 2436);
	level.iz_route[level.iz_route.size] = (7011, -6266, 2436);
	level.iz_route[level.iz_route.size] = (6545, -6195, 2436);
	level.iz_route[level.iz_route.size] = (6276, -5945, 2436);
	level.iz_route[level.iz_route.size] = (6148, -5543, 2436);
	level.iz_route[level.iz_route.size] = (6127, -4462, 2436);
	level.iz_route[level.iz_route.size] = (6150, -3203, 2436);
	level.iz_route[level.iz_route.size] = (6163, -1617, 2436);
	level.iz_route[level.iz_route.size] = (6119, 484, 2436);
	level.iz_route[level.iz_route.size] = (5968, 1269, 2436);
	level.iz_route[level.iz_route.size] = (5697, 1798, 2436);
	level.iz_route[level.iz_route.size] = (5177, 2064, 2436);
	level.iz_route[level.iz_route.size] = (4491, 2062, 2436);
	level.iz_route[level.iz_route.size] = (4014, 1867, 2436);
	level.iz_route[level.iz_route.size] = (3644, 1471, 2436);
	level.iz_route[level.iz_route.size] = (3360, 1045, 2436);
	level.iz_route[level.iz_route.size] = (2912, 277, 2436);
	level.iz_route[level.iz_route.size] = (2505, -329, 2436);
	level.iz_route[level.iz_route.size] = (2199, -682, 2436);
	level.iz_route[level.iz_route.size] = (1541, -975, 2436);
	level.iz_route[level.iz_route.size] = (779, -1082, 2436);
	level.iz_route[level.iz_route.size] = (-139, -1092, 2436);
	level.iz_route[level.iz_route.size] = (-1327, -1087, 2436);
	level.iz_route[level.iz_route.size] = (-2133, -1278, 2436);
	level.iz_route[level.iz_route.size] = (-2459, -1537, 2436);
	level.iz_route[level.iz_route.size] = (-2599, -1852, 2436);
	level.iz_route[level.iz_route.size] = (-2599, -2076, 2436);
	level.iz_route[level.iz_route.size] = (-2576, -3436, 2436);
	level.iz_route[level.iz_route.size] = (-2565, -5321, 2436);
	level.iz_route[level.iz_route.size] = (-2579, -6818, 2436);
	level.iz_route[level.iz_route.size] = (-2589, -7207, 2436);
	level.iz_route[level.iz_route.size] = (-2637, -7497, 2436);
	level.iz_route[level.iz_route.size] = (-3049, -7656, 2436);
	level.iz_route[level.iz_route.size] = (-3860, -7694, 2436);
	level.iz_route[level.iz_route.size] = (-5450, -7713, 2436);
	level.iz_route[level.iz_route.size] = (-6918, -7725, 2436);
	level.iz_route[level.iz_route.size] = (-7434, -7715, 2436);
	level.iz_route[level.iz_route.size] = (-7731, -7616, 2436);
	level.iz_route[level.iz_route.size] = (-7896, -7329, 2436);
	level.iz_route[level.iz_route.size] = (-7958, -6876, 2436);
	level.iz_route[level.iz_route.size] = (-7968, -6345, 2436);
	level.iz_route[level.iz_route.size] = (-7961, -5864, 2436);
	level.iz_route[level.iz_route.size] = (-7958, -4917, 2436);
	level.iz_route[level.iz_route.size] = (-7949, -4480, 2436);
	level.iz_route[level.iz_route.size] = (-8393, -4209, 2436);
	level.iz_route[level.iz_route.size] = (-8474, -3625, 2436);
	level.iz_route[level.iz_route.size] = (-8526, -2714, 2436);
	level.iz_route[level.iz_route.size] = (-8487, -1627, 2436);
	level.iz_route[level.iz_route.size] = (-8482, -1014, 2436);
	level.iz_route[level.iz_route.size] = (-8488, 222, 2436);
	level.iz_route[level.iz_route.size] = (-8525, 1505, 2436);
	level.iz_route[level.iz_route.size] = (-8537, 2394, 2436);
	level.iz_route[level.iz_route.size] = (-8334, 2979, 2436);
	level.iz_route[level.iz_route.size] = (-8073, 3440, 2436);
	level.iz_route[level.iz_route.size] = (-7900, 4079, 2436);
	level.iz_route[level.iz_route.size] = (-7904, 4714, 2436);
	level.iz_route[level.iz_route.size] = (-7882, 5570, 2436);
	level.iz_route[level.iz_route.size] = (-7761, 6143, 2436);
	level.iz_route[level.iz_route.size] = (-7218, 6354, 2436);
	level.iz_route[level.iz_route.size] = (-5762, 6435, 2436);
	level.iz_route[level.iz_route.size] = (-4205, 6472, 2436);
	level.iz_route[level.iz_route.size] = (-3103, 6515, 2436);
	level.iz_route[level.iz_route.size] = (-2124, 6534, 2436);
	level.iz_route[level.iz_route.size] = (-913, 6502, 2436);
	level.iz_route[level.iz_route.size] = (128, 6522, 2436);
	level.iz_route[level.iz_route.size] = (1507, 6578, 2436);
	level.iz_route[level.iz_route.size] = (3542, 6632, 2436);
	level.iz_route[level.iz_route.size] = (4996, 6605, 2436);
	level.iz_route[level.iz_route.size] = (6802, 6593, 2436);
	level.iz_route[level.iz_route.size] = (8076, 6584, 2436);
	level.iz_route[level.iz_route.size] = (8370, 6467, 2436);
	level.iz_route[level.iz_route.size] = (8518, 6172, 2436);
	level.iz_route[level.iz_route.size] = (8620, 5540, 2436);
	level.iz_route[level.iz_route.size] = (8682, 4568, 2436);
	level.iz_route[level.iz_route.size] = (8668, 2642, 2436);
	level.iz_route[level.iz_route.size] = (8599, 76, 2436);
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
	thread iz_obj_22();
	thread iz_obj_23();
	thread iz_obj_24();
	thread iz_obj_25();
	thread iz_obj_26();
	thread iz_obj_27();
	thread iz_obj_28();
	thread iz_obj_29();
	thread iz_obj_30();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1409.9213, -1091.6968, 2671.0552);
	angles[0] = (0, -45, 0);
	at[0] = 0;
	points[1] = (1409.9213, -1091.6968, 2667.8149);
	angles[1] = (0, -45, 0);
	at[1] = 0.0500;
	points[2] = (1409.9213, -1091.6968, 2655.7126);
	angles[2] = (0, -45, 0);
	at[2] = 0.1000;
	points[3] = (1409.9213, -1091.6968, 2658.9565);
	angles[3] = (0, -45, 0);
	at[3] = 0.1500;
	points[4] = (1409.9213, -1091.6968, 2671.0552);
	angles[4] = (0, -45, 0);
	at[4] = 0.2000;
	points[5] = (1409.9213, -1091.6968, 2667.8149);
	angles[5] = (0, -45, 0);
	at[5] = 0.2500;
	points[6] = (1409.9213, -1091.6968, 2655.7126);
	angles[6] = (0, -45, 0);
	at[6] = 0.3000;
	points[7] = (1409.9213, -1091.6968, 2658.9565);
	angles[7] = (0, -45, 0);
	at[7] = 0.3500;
	points[8] = (1409.9213, -1091.6968, 2671.0552);
	angles[8] = (0, -45, 0);
	at[8] = 0.4000;
	points[9] = (1409.9213, -1091.6968, 2667.8149);
	angles[9] = (0, -45, 0);
	at[9] = 0.4500;
	points[10] = (1409.9213, -1091.6968, 2673.7205);
	angles[10] = (0, -45, 0);
	at[10] = 0.5000;
	points[11] = (1409.9213, -1091.6968, 2806.5945);
	angles[11] = (0, -45, 0);
	at[11] = 0.6500;
	points[12] = (1409.9213, -1091.6968, 2776.4763);
	angles[12] = (0, -45, 0);
	at[12] = 0.7000;
	points[13] = (1409.9213, -1091.6968, 2701.1812);
	angles[13] = (0, -45, 0);
	at[13] = 0.7500;
	points[14] = (1409.9213, -1091.6968, 2580.7087);
	angles[14] = (0, -45, 0);
	at[14] = 0.8000;
	points[15] = (1409.9213, -1091.6968, 2436.0198);
	angles[15] = (0, -45, 0);
	at[15] = 0.8500;
	points[16] = (1409.9213, -1091.6968, 2436.0198);
	angles[16] = (0, -45, 0);
	at[16] = 1.8500;
	points[17] = (1409.9213, -1091.6968, 2657.4766);
	angles[17] = (0, -45, 0);
	at[17] = 3.1000;
	points[18] = (1409.9213, -1091.6968, 2663.3860);
	angles[18] = (0, -45, 0);
	at[18] = 3.1500;
	points[19] = (1409.9213, -1091.6968, 2663.3860);
	angles[19] = (0, -45, 0);
	at[19] = 4.1000;
	points[20] = (1409.9213, -1091.6968, 2671.0552);
	angles[20] = (0, -45, 0);
	at[20] = 4.1667;
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
	points[0] = (-3931.0789, -7327.6377, 2663.3860);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-3931.0789, -7327.6377, 2663.3860);
	angles[1] = (0, -90, 0);
	at[1] = 0.9500;
	points[2] = (-3931.0789, -7327.6377, 2671.0552);
	angles[2] = (0, -90, 0);
	at[2] = 1;
	points[3] = (-3931.0789, -7327.6377, 2667.8149);
	angles[3] = (0, -90, 0);
	at[3] = 1.0500;
	points[4] = (-3931.0789, -7327.6377, 2655.7126);
	angles[4] = (0, -90, 0);
	at[4] = 1.1000;
	points[5] = (-3931.0789, -7327.6377, 2658.9565);
	angles[5] = (0, -90, 0);
	at[5] = 1.1500;
	points[6] = (-3931.0789, -7327.6377, 2671.0552);
	angles[6] = (0, -90, 0);
	at[6] = 1.2000;
	points[7] = (-3931.0789, -7327.6377, 2667.8149);
	angles[7] = (0, -90, 0);
	at[7] = 1.2500;
	points[8] = (-3931.0789, -7327.6377, 2655.7126);
	angles[8] = (0, -90, 0);
	at[8] = 1.3000;
	points[9] = (-3931.0789, -7327.6377, 2658.9565);
	angles[9] = (0, -90, 0);
	at[9] = 1.3500;
	points[10] = (-3931.0789, -7327.6377, 2671.0552);
	angles[10] = (0, -90, 0);
	at[10] = 1.4000;
	points[11] = (-3931.0789, -7327.6377, 2667.8149);
	angles[11] = (0, -90, 0);
	at[11] = 1.4500;
	points[12] = (-3931.0789, -7327.6377, 2673.7205);
	angles[12] = (0, -90, 0);
	at[12] = 1.5000;
	points[13] = (-3931.0789, -7327.6377, 2806.5945);
	angles[13] = (0, -90, 0);
	at[13] = 1.6500;
	points[14] = (-3931.0789, -7327.6377, 2776.4763);
	angles[14] = (0, -90, 0);
	at[14] = 1.7000;
	points[15] = (-3931.0789, -7327.6377, 2701.1812);
	angles[15] = (0, -90, 0);
	at[15] = 1.7500;
	points[16] = (-3931.0789, -7327.6377, 2580.7087);
	angles[16] = (0, -90, 0);
	at[16] = 1.8000;
	points[17] = (-3931.0789, -7327.6377, 2436.0237);
	angles[17] = (0, -90, 0);
	at[17] = 1.8500;
	points[18] = (-3931.0789, -7327.6377, 2436.0237);
	angles[18] = (0, -90, 0);
	at[18] = 2.8500;
	points[19] = (-3931.0789, -7327.6377, 2657.4805);
	angles[19] = (0, -90, 0);
	at[19] = 4.1000;
	points[20] = (-3931.0789, -7327.6377, 2663.3860);
	angles[20] = (0, -90, 0);
	at[20] = 4.1500;
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
	points[0] = (8742.7959, -3.9603, 2580.7046);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (8742.7959, -3.9603, 2660.4292);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (8742.7959, -3.9603, 2663.3860);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (8742.7959, -3.9603, 2663.3860);
	angles[3] = (0, 0, 0);
	at[3] = 1.4500;
	points[4] = (8742.7959, -3.9603, 2671.0552);
	angles[4] = (0, 0, 0);
	at[4] = 1.5000;
	points[5] = (8742.7959, -3.9603, 2667.8149);
	angles[5] = (0, 0, 0);
	at[5] = 1.5500;
	points[6] = (8742.7959, -3.9603, 2655.7126);
	angles[6] = (0, 0, 0);
	at[6] = 1.6000;
	points[7] = (8742.7959, -3.9603, 2658.9565);
	angles[7] = (0, 0, 0);
	at[7] = 1.6500;
	points[8] = (8742.7959, -3.9603, 2671.0552);
	angles[8] = (0, 0, 0);
	at[8] = 1.7000;
	points[9] = (8742.7959, -3.9603, 2667.8149);
	angles[9] = (0, 0, 0);
	at[9] = 1.7500;
	points[10] = (8742.7959, -3.9603, 2655.7126);
	angles[10] = (0, 0, 0);
	at[10] = 1.8000;
	points[11] = (8742.7959, -3.9603, 2658.9565);
	angles[11] = (0, 0, 0);
	at[11] = 1.8500;
	points[12] = (8742.7959, -3.9603, 2671.0552);
	angles[12] = (0, 0, 0);
	at[12] = 1.9000;
	points[13] = (8742.7959, -3.9603, 2667.8149);
	angles[13] = (0, 0, 0);
	at[13] = 1.9500;
	points[14] = (8742.7959, -3.9603, 2673.7205);
	angles[14] = (0, 0, 0);
	at[14] = 2;
	points[15] = (8742.7959, -3.9603, 2806.5945);
	angles[15] = (0, 0, 0);
	at[15] = 2.1500;
	points[16] = (8742.7959, -3.9603, 2776.4763);
	angles[16] = (0, 0, 0);
	at[16] = 2.2000;
	points[17] = (8742.7959, -3.9603, 2701.1812);
	angles[17] = (0, 0, 0);
	at[17] = 2.2500;
	points[18] = (8742.7959, -3.9603, 2580.7087);
	angles[18] = (0, 0, 0);
	at[18] = 2.3000;
	points[19] = (8742.7959, -3.9603, 2436.0198);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (8742.7959, -3.9603, 2436.0198);
	angles[20] = (0, 0, 0);
	at[20] = 3.3500;
	points[21] = (8742.7959, -3.9603, 2580.7046);
	angles[21] = (0, 0, 0);
	at[21] = 4.1667;
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
	points[0] = (8290.4727, 1157.0945, 2663.3860);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (8290.4727, 1157.0945, 2663.3860);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (8290.4727, 1157.0945, 2671.0552);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (8290.4727, 1157.0945, 2667.8149);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (8290.4727, 1157.0945, 2655.7126);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (8290.4727, 1157.0945, 2658.9565);
	angles[5] = (0, 0, 0);
	at[5] = 0.6500;
	points[6] = (8290.4727, 1157.0945, 2671.0552);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (8290.4727, 1157.0945, 2667.8149);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (8290.4727, 1157.0945, 2655.7126);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (8290.4727, 1157.0945, 2658.9565);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (8290.4727, 1157.0945, 2671.0552);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (8290.4727, 1157.0945, 2667.8149);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (8290.4727, 1157.0945, 2673.7205);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (8290.4727, 1157.0945, 2806.5945);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (8290.4727, 1157.0945, 2776.4763);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (8290.4727, 1157.0945, 2701.1812);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (8290.4727, 1157.0945, 2580.7087);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (8290.4727, 1157.0945, 2436.0198);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (8290.4727, 1157.0945, 2436.0198);
	angles[18] = (0, 0, 0);
	at[18] = 2.3500;
	points[19] = (8290.4727, 1157.0945, 2657.4766);
	angles[19] = (0, 0, 0);
	at[19] = 3.6000;
	points[20] = (8290.4727, 1157.0945, 2663.3860);
	angles[20] = (0, 0, 0);
	at[20] = 3.6500;
	points[21] = (8290.4727, 1157.0945, 2663.3860);
	angles[21] = (0, 0, 0);
	at[21] = 4.1667;
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
	points[0] = (7398.3076, -4484.9604, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7398.3076, -4484.9604, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (7398.3076, -4484.9604, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (7398.3076, -4484.9604, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (7398.3076, -4484.9604, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (7398.3076, -4484.9604, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (7398.3076, -4484.9604, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (7398.3076, -4484.9604, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (7398.3076, -4484.9604, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (7398.3076, -4484.9604, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (7398.3076, -4484.9604, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (7398.3076, -4484.9604, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (7398.3076, -4484.9604, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (7398.3076, -4484.9604, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (7398.3076, -4484.9604, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (7398.3076, -4484.9604, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (7398.3076, -4484.9604, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (7398.3076, -4484.9604, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (7398.3076, -4484.9604, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (7398.3076, -4484.9604, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (7403.3862, 2277.7559, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7403.3862, 2277.7559, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (7403.3862, 2277.7559, 1785.8623);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (7403.3862, 2277.7559, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (7403.3862, 2277.7559, 1943.1851);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (7403.3862, 2277.7559, 2033.8937);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (7403.3862, 2277.7559, 2074.9961);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (7403.3862, 2277.7559, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (7403.3862, 2277.7559, 2211.0591);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (7403.3862, 2277.7559, 2237.9880);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (7403.3862, 2277.7559, 2283.3425);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (7403.3862, 2277.7559, 2301.7678);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (7403.3862, 2277.7559, 2330.1143);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (7403.3862, 2277.7559, 2347.1221);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (7403.3862, 2277.7559, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (7403.3862, 2277.7559, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (7403.3862, 2277.7559, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (7403.3862, 2277.7559, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (7403.3862, 2277.7559, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (7403.3862, 2277.7559, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (7402.1265, 587.0748, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7402.1265, 587.0748, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (7402.1265, 587.0748, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (7402.1265, 587.0748, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (7402.1265, 587.0748, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (7402.1265, 587.0748, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (7402.1265, 587.0748, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (7402.1265, 587.0748, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (7402.1265, 587.0748, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (7402.1265, 587.0748, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (7402.1265, 587.0748, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (7402.1265, 587.0748, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (7402.1265, 587.0748, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (7402.1265, 587.0748, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (7402.1265, 587.0748, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (7402.1265, 587.0748, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (7402.1265, 587.0748, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (7402.1265, 587.0748, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (7402.1265, 587.0748, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (7402.1265, 587.0748, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (7402.1265, 587.0748, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (7400.8271, -1103.6102, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7400.8271, -1103.6102, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (7400.8271, -1103.6102, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (7400.8271, -1103.6102, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (7400.8271, -1103.6102, 1943.1890);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (7400.8271, -1103.6102, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (7400.8271, -1103.6102, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (7400.8271, -1103.6102, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (7400.8271, -1103.6102, 2211.0630);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (7400.8271, -1103.6102, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (7400.8271, -1103.6102, 2283.3464);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (7400.8271, -1103.6102, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (7400.8271, -1103.6102, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (7400.8271, -1103.6102, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (7400.8271, -1103.6102, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (7400.8271, -1103.6102, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (7400.8271, -1103.6102, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (7400.8271, -1103.6102, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (7400.8271, -1103.6102, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (7400.8271, -1103.6102, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (7399.5674, -2794.2913, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7399.5674, -2794.2913, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (7399.5674, -2794.2913, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (7399.5674, -2794.2913, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (7399.5674, -2794.2913, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (7399.5674, -2794.2913, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (7399.5674, -2794.2913, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (7399.5674, -2794.2913, 2125.3938);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (7399.5674, -2794.2913, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (7399.5674, -2794.2913, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (7399.5674, -2794.2913, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (7399.5674, -2794.2913, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (7399.5674, -2794.2913, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (7399.5674, -2794.2913, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (7399.5674, -2794.2913, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (7399.5674, -2794.2913, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (7399.5674, -2794.2913, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (7399.5674, -2794.2913, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (7399.5674, -2794.2913, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (7399.5674, -2794.2913, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (7399.5674, -2794.2913, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-1099.2402, -2207.6575, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1099.2402, -2207.6575, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-1099.2402, -2207.6575, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-1099.2402, -2207.6575, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-1099.2402, -2207.6575, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (-1099.2402, -2207.6575, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-1099.2402, -2207.6575, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-1099.2402, -2207.6575, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-1099.2402, -2207.6575, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (-1099.2402, -2207.6575, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-1099.2402, -2207.6575, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (-1099.2402, -2207.6575, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-1099.2402, -2207.6575, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-1099.2402, -2207.6575, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-1099.2402, -2207.6575, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-1099.2402, -2207.6575, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-1099.2402, -2207.6575, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-1099.2402, -2207.6575, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-1099.2402, -2207.6575, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-1099.2402, -2207.6575, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (2530.0315, -2243.1694, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2530.0315, -2243.1694, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (2530.0315, -2243.1694, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (2530.0315, -2243.1694, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (2530.0315, -2243.1694, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (2530.0315, -2243.1694, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (2530.0315, -2243.1694, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (2530.0315, -2243.1694, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (2530.0315, -2243.1694, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (2530.0315, -2243.1694, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (2530.0315, -2243.1694, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (2530.0315, -2243.1694, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (2530.0315, -2243.1694, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (2530.0315, -2243.1694, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (2530.0315, -2243.1694, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (2530.0315, -2243.1694, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (2530.0315, -2243.1694, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (2530.0315, -2243.1694, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (2530.0315, -2243.1694, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (2530.0315, -2243.1694, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (629.6299, -2193.8860, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (629.6299, -2193.8860, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (629.6299, -2193.8860, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (629.6299, -2193.8860, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (629.6299, -2193.8860, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (629.6299, -2193.8860, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (629.6299, -2193.8860, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (629.6299, -2193.8860, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (629.6299, -2193.8860, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (629.6299, -2193.8860, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (629.6299, -2193.8860, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (629.6299, -2193.8860, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (629.6299, -2193.8860, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (629.6299, -2193.8860, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (629.6299, -2193.8860, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (629.6299, -2193.8860, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (629.6299, -2193.8860, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (629.6299, -2193.8860, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (629.6299, -2193.8860, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (629.6299, -2193.8860, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (629.6299, -2193.8860, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-327.8618, 4779.9214, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-327.8618, 4779.9214, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-327.8618, 4779.9214, 1804.6023);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (-327.8618, 4779.9214, 1858.9331);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (-327.8618, 4779.9214, 1959.0906);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (-327.8618, 4779.9214, 2004.9174);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (-327.8618, 4779.9214, 2088.0669);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-327.8618, 4779.9214, 2125.3899);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (-327.8618, 4779.9214, 2191.5315);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (-327.8618, 4779.9214, 2246.3347);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (-327.8618, 4779.9214, 2269.4844);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (-327.8618, 4779.9214, 2307.2795);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (-327.8618, 4779.9214, 2333.7363);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (-327.8618, 4779.9214, 2348.8542);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (-327.8618, 4779.9214, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (-327.8618, 4779.9214, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (-327.8618, 4779.9214, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (-327.8618, 4779.9214, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-327.8618, 4779.9214, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (-327.8618, 4779.9214, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (-327.8618, 4779.9214, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-4390.5117, 5120.8267, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4390.5117, 5120.8267, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-4390.5117, 5120.8267, 1785.8623);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-4390.5117, 5120.8267, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-4390.5117, 5120.8267, 1943.1851);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (-4390.5117, 5120.8267, 2033.8937);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-4390.5117, 5120.8267, 2074.9961);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-4390.5117, 5120.8267, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-4390.5117, 5120.8267, 2211.0591);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (-4390.5117, 5120.8267, 2237.9880);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-4390.5117, 5120.8267, 2283.3425);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (-4390.5117, 5120.8267, 2301.7678);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-4390.5117, 5120.8267, 2330.1143);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-4390.5117, 5120.8267, 2347.1221);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-4390.5117, 5120.8267, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-4390.5117, 5120.8267, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-4390.5117, 5120.8267, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-4390.5117, 5120.8267, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-4390.5117, 5120.8267, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-4390.5117, 5120.8267, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (-9288.3076, 4758.6616, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9288.3076, 4758.6616, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-9288.3076, 4758.6616, 1785.8623);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-9288.3076, 4758.6616, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-9288.3076, 4758.6616, 1943.1851);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (-9288.3076, 4758.6616, 2033.8937);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-9288.3076, 4758.6616, 2074.9961);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-9288.3076, 4758.6616, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-9288.3076, 4758.6616, 2211.0591);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (-9288.3076, 4758.6616, 2237.9880);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-9288.3076, 4758.6616, 2283.3425);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (-9288.3076, 4758.6616, 2301.7678);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-9288.3076, 4758.6616, 2330.1143);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-9288.3076, 4758.6616, 2347.1221);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-9288.3076, 4758.6616, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-9288.3076, 4758.6616, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-9288.3076, 4758.6616, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-9288.3076, 4758.6616, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-9288.3076, 4758.6616, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-9288.3076, 4758.6616, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (-4911.2598, -2699.5159, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4911.2598, -2699.5159, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-4911.2598, -2699.5159, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (-4911.2598, -2699.5159, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (-4911.2598, -2699.5159, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (-4911.2598, -2699.5159, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (-4911.2598, -2699.5159, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-4911.2598, -2699.5159, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (-4911.2598, -2699.5159, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (-4911.2598, -2699.5159, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (-4911.2598, -2699.5159, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (-4911.2598, -2699.5159, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (-4911.2598, -2699.5159, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (-4911.2598, -2699.5159, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (-4911.2598, -2699.5159, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (-4911.2598, -2699.5159, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (-4911.2598, -2699.5159, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (-4911.2598, -2699.5159, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-4911.2598, -2699.5159, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (-4911.2598, -2699.5159, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (-4911.2598, -2699.5159, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-2039.8268, 2188.8228, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2039.8268, 2188.8228, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-2039.8268, 2188.8228, 1785.8623);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-2039.8268, 2188.8228, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-2039.8268, 2188.8228, 1943.1851);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (-2039.8268, 2188.8228, 2033.8937);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-2039.8268, 2188.8228, 2074.9961);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-2039.8268, 2188.8228, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-2039.8268, 2188.8228, 2211.0591);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (-2039.8268, 2188.8228, 2237.9880);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-2039.8268, 2188.8228, 2283.3425);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (-2039.8268, 2188.8228, 2301.7678);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-2039.8268, 2188.8228, 2330.1143);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-2039.8268, 2188.8228, 2347.1221);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-2039.8268, 2188.8228, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-2039.8268, 2188.8228, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-2039.8268, 2188.8228, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-2039.8268, 2188.8228, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-2039.8268, 2188.8228, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-2039.8268, 2188.8228, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (4429.5669, -6899.5278, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4429.5669, -6899.5278, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (4429.5669, -6899.5278, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (4429.5669, -6899.5278, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (4429.5669, -6899.5278, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (4429.5669, -6899.5278, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (4429.5669, -6899.5278, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (4429.5669, -6899.5278, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (4429.5669, -6899.5278, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (4429.5669, -6899.5278, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (4429.5669, -6899.5278, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (4429.5669, -6899.5278, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (4429.5669, -6899.5278, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (4429.5669, -6899.5278, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (4429.5669, -6899.5278, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (4429.5669, -6899.5278, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (4429.5669, -6899.5278, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (4429.5669, -6899.5278, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (4429.5669, -6899.5278, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (4429.5669, -6899.5278, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (4429.5669, -6899.5278, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (44.5902, -7214.8818, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (44.5902, -7214.8818, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (44.5902, -7214.8818, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (44.5902, -7214.8818, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (44.5902, -7214.8818, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (44.5902, -7214.8818, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (44.5902, -7214.8818, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (44.5902, -7214.8818, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (44.5902, -7214.8818, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (44.5902, -7214.8818, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (44.5902, -7214.8818, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (44.5902, -7214.8818, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (44.5902, -7214.8818, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (44.5902, -7214.8818, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (44.5902, -7214.8818, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (44.5902, -7214.8818, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (44.5902, -7214.8818, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (44.5902, -7214.8818, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (44.5902, -7214.8818, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (44.5902, -7214.8818, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (44.5902, -7214.8818, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (13382.2441, 366.3138, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (13382.2441, 366.3138, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (13382.2441, 366.3138, 1804.6023);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (13382.2441, 366.3138, 1858.9331);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (13382.2441, 366.3138, 1959.0906);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (13382.2441, 366.3138, 2004.9174);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (13382.2441, 366.3138, 2088.0669);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (13382.2441, 366.3138, 2125.3899);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (13382.2441, 366.3138, 2191.5315);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (13382.2441, 366.3138, 2246.3347);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (13382.2441, 366.3138, 2269.4844);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (13382.2441, 366.3138, 2307.2795);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (13382.2441, 366.3138, 2333.7363);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (13382.2441, 366.3138, 2348.8542);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (13382.2441, 366.3138, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (13382.2441, 366.3138, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (13382.2441, 366.3138, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (13382.2441, 366.3138, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (13382.2441, 366.3138, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (13382.2441, 366.3138, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (13382.2441, 366.3138, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (12356.7324, 4620.7480, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (12356.7324, 4620.7480, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (12356.7324, 4620.7480, 1785.8623);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (12356.7324, 4620.7480, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (12356.7324, 4620.7480, 1943.1851);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (12356.7324, 4620.7480, 2033.8937);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (12356.7324, 4620.7480, 2074.9961);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (12356.7324, 4620.7480, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (12356.7324, 4620.7480, 2211.0591);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (12356.7324, 4620.7480, 2237.9880);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (12356.7324, 4620.7480, 2283.3425);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (12356.7324, 4620.7480, 2301.7678);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (12356.7324, 4620.7480, 2330.1143);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (12356.7324, 4620.7480, 2347.1221);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (12356.7324, 4620.7480, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (12356.7324, 4620.7480, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (12356.7324, 4620.7480, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (12356.7324, 4620.7480, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (12356.7324, 4620.7480, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (12356.7324, 4620.7480, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (12548.1094, -3533.1616, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (12548.1094, -3533.1616, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (12548.1094, -3533.1616, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (12548.1094, -3533.1616, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (12548.1094, -3533.1616, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (12548.1094, -3533.1616, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (12548.1094, -3533.1616, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (12548.1094, -3533.1616, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (12548.1094, -3533.1616, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (12548.1094, -3533.1616, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (12548.1094, -3533.1616, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (12548.1094, -3533.1616, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (12548.1094, -3533.1616, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (12548.1094, -3533.1616, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (12548.1094, -3533.1616, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (12548.1094, -3533.1616, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (12548.1094, -3533.1616, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (12548.1094, -3533.1616, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (12548.1094, -3533.1616, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (12548.1094, -3533.1616, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (12548.1094, -3533.1616, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-11041.5352, -6399.1338, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-11041.5352, -6399.1338, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-11041.5352, -6399.1338, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-11041.5352, -6399.1338, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-11041.5352, -6399.1338, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (-11041.5352, -6399.1338, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-11041.5352, -6399.1338, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-11041.5352, -6399.1338, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-11041.5352, -6399.1338, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (-11041.5352, -6399.1338, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-11041.5352, -6399.1338, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (-11041.5352, -6399.1338, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-11041.5352, -6399.1338, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-11041.5352, -6399.1338, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-11041.5352, -6399.1338, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-11041.5352, -6399.1338, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-11041.5352, -6399.1338, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-11041.5352, -6399.1338, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-11041.5352, -6399.1338, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-11041.5352, -6399.1338, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_22", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_23()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6256.7715, 9289.4883, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6256.7715, 9289.4883, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (6256.7715, 9289.4883, 1804.6023);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (6256.7715, 9289.4883, 1858.9331);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (6256.7715, 9289.4883, 1959.0906);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (6256.7715, 9289.4883, 2004.9174);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (6256.7715, 9289.4883, 2088.0669);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (6256.7715, 9289.4883, 2125.3899);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (6256.7715, 9289.4883, 2191.5315);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (6256.7715, 9289.4883, 2246.3347);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (6256.7715, 9289.4883, 2269.4844);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (6256.7715, 9289.4883, 2307.2795);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (6256.7715, 9289.4883, 2333.7363);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (6256.7715, 9289.4883, 2348.8542);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (6256.7715, 9289.4883, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (6256.7715, 9289.4883, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (6256.7715, 9289.4883, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (6256.7715, 9289.4883, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (6256.7715, 9289.4883, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (6256.7715, 9289.4883, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (6256.7715, 9289.4883, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_23", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_24()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4022.4409, 9663.2686, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4022.4409, 9663.2686, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-4022.4409, 9663.2686, 1785.8623);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-4022.4409, 9663.2686, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-4022.4409, 9663.2686, 1943.1851);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (-4022.4409, 9663.2686, 2033.8937);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-4022.4409, 9663.2686, 2074.9961);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-4022.4409, 9663.2686, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-4022.4409, 9663.2686, 2211.0591);
	angles[8] = (0, 0, 0);
	at[8] = 4.7000;
	points[9] = (-4022.4409, 9663.2686, 2237.9880);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-4022.4409, 9663.2686, 2283.3425);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (-4022.4409, 9663.2686, 2301.7678);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-4022.4409, 9663.2686, 2330.1143);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-4022.4409, 9663.2686, 2347.1221);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-4022.4409, 9663.2686, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-4022.4409, 9663.2686, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-4022.4409, 9663.2686, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-4022.4409, 9663.2686, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-4022.4409, 9663.2686, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-4022.4409, 9663.2686, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_24", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_25()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-13254.7637, 1167.8937, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-13254.7637, 1167.8937, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-13254.7637, 1167.8937, 1804.6023);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (-13254.7637, 1167.8937, 1858.9331);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (-13254.7637, 1167.8937, 1959.0906);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (-13254.7637, 1167.8937, 2004.9174);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (-13254.7637, 1167.8937, 2088.0669);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-13254.7637, 1167.8937, 2125.3899);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (-13254.7637, 1167.8937, 2191.5315);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (-13254.7637, 1167.8937, 2246.3347);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (-13254.7637, 1167.8937, 2269.4844);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (-13254.7637, 1167.8937, 2307.2795);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (-13254.7637, 1167.8937, 2333.7363);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (-13254.7637, 1167.8937, 2348.8542);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (-13254.7637, 1167.8937, 2352.7913);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (-13254.7637, 1167.8937, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (-13254.7637, 1167.8937, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (-13254.7637, 1167.8937, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-13254.7637, 1167.8937, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (-13254.7637, 1167.8937, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (-13254.7637, 1167.8937, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_25", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_26()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3990.4331, -3928.3386, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3990.4331, -3928.3386, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (3990.4331, -3928.3386, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (3990.4331, -3928.3386, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (3990.4331, -3928.3386, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (3990.4331, -3928.3386, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (3990.4331, -3928.3386, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (3990.4331, -3928.3386, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (3990.4331, -3928.3386, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (3990.4331, -3928.3386, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (3990.4331, -3928.3386, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (3990.4331, -3928.3386, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (3990.4331, -3928.3386, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (3990.4331, -3928.3386, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (3990.4331, -3928.3386, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (3990.4331, -3928.3386, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (3990.4331, -3928.3386, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (3990.4331, -3928.3386, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (3990.4331, -3928.3386, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (3990.4331, -3928.3386, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_26", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_27()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (11051.0625, -8795, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (11051.0625, -8795, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (11051.0625, -8795, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (11051.0625, -8795, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (11051.0625, -8795, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (11051.0625, -8795, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (11051.0625, -8795, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (11051.0625, -8795, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (11051.0625, -8795, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (11051.0625, -8795, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (11051.0625, -8795, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (11051.0625, -8795, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (11051.0625, -8795, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (11051.0625, -8795, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (11051.0625, -8795, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (11051.0625, -8795, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (11051.0625, -8795, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (11051.0625, -8795, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (11051.0625, -8795, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (11051.0625, -8795, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (11051.0625, -8795, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_27", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_28()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5963.1499, -9139.2910, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5963.1499, -9139.2910, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (5963.1499, -9139.2910, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (5963.1499, -9139.2910, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (5963.1499, -9139.2910, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (5963.1499, -9139.2910, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (5963.1499, -9139.2910, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (5963.1499, -9139.2910, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (5963.1499, -9139.2910, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (5963.1499, -9139.2910, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (5963.1499, -9139.2910, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (5963.1499, -9139.2910, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (5963.1499, -9139.2910, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (5963.1499, -9139.2910, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (5963.1499, -9139.2910, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (5963.1499, -9139.2910, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (5963.1499, -9139.2910, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (5963.1499, -9139.2910, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (5963.1499, -9139.2910, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (5963.1499, -9139.2910, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_28", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_29()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1126.6497, -9460.3945, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1126.6497, -9460.3945, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-1126.6497, -9460.3945, 1804.6064);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (-1126.6497, -9460.3945, 1858.9370);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (-1126.6497, -9460.3945, 1959.0946);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (-1126.6497, -9460.3945, 2004.9213);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (-1126.6497, -9460.3945, 2088.0708);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-1126.6497, -9460.3945, 2159.8818);
	angles[7] = (0, 0, 0);
	at[7] = 2.9500;
	points[8] = (-1126.6497, -9460.3945, 2191.5354);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (-1126.6497, -9460.3945, 2246.3386);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (-1126.6497, -9460.3945, 2269.4883);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (-1126.6497, -9460.3945, 2307.2834);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (-1126.6497, -9460.3945, 2333.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (-1126.6497, -9460.3945, 2348.8582);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (-1126.6497, -9460.3945, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (-1126.6497, -9460.3945, 2366.8347);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (-1126.6497, -9460.3945, 2366.8347);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (-1126.6497, -9460.3945, 2362.4292);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-1126.6497, -9460.3945, 1786.0511);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (-1126.6497, -9460.3945, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (-1126.6497, -9460.3945, 1779.7520);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_29", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_30()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-6860.3545, -10005.7480, 1779.7520);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6860.3545, -10005.7480, 1779.7520);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-6860.3545, -10005.7480, 1785.8662);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-6860.3545, -10005.7480, 1893.5828);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-6860.3545, -10005.7480, 1989.9606);
	angles[4] = (0, 0, 0);
	at[4] = 4.4000;
	points[5] = (-6860.3545, -10005.7480, 2033.8976);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-6860.3545, -10005.7480, 2075);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-6860.3545, -10005.7480, 2148.7007);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-6860.3545, -10005.7480, 2181.2991);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (-6860.3545, -10005.7480, 2237.9922);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-6860.3545, -10005.7480, 2262.0867);
	angles[10] = (0, 0, 0);
	at[10] = 4.8000;
	points[11] = (-6860.3545, -10005.7480, 2301.7717);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-6860.3545, -10005.7480, 2330.1182);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-6860.3545, -10005.7480, 2347.1260);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-6860.3545, -10005.7480, 2352.7954);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-6860.3545, -10005.7480, 2365.5789);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-6860.3545, -10005.7480, 2367.4763);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-6860.3545, -10005.7480, 2365.5789);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-6860.3545, -10005.7480, 1779.7520);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-6860.3545, -10005.7480, 1779.7520);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_30", "targetname");
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
