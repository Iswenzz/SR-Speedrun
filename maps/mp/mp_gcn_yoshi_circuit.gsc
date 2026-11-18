main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_yoshi_circuit", 0);

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
	ambientPlay("iz_0_66", 2);
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
	level.iz_route[level.iz_route.size] = (-1523, 11783, 4389);
	level.iz_route[level.iz_route.size] = (-407, 11777, 4389);
	level.iz_route[level.iz_route.size] = (629, 11758, 4389);
	level.iz_route[level.iz_route.size] = (1203, 11665, 4389);
	level.iz_route[level.iz_route.size] = (1653, 11495, 4389);
	level.iz_route[level.iz_route.size] = (2014, 11231, 4389);
	level.iz_route[level.iz_route.size] = (2230, 10849, 4389);
	level.iz_route[level.iz_route.size] = (2332, 10467, 4390);
	level.iz_route[level.iz_route.size] = (2337, 9928, 4394);
	level.iz_route[level.iz_route.size] = (2275, 9444, 4405);
	level.iz_route[level.iz_route.size] = (2049, 8885, 4427);
	level.iz_route[level.iz_route.size] = (1614, 8489, 4449);
	level.iz_route[level.iz_route.size] = (788, 8100, 4468);
	level.iz_route[level.iz_route.size] = (540, 7856, 4469);
	level.iz_route[level.iz_route.size] = (431, 7638, 4469);
	level.iz_route[level.iz_route.size] = (409, 7390, 4473);
	level.iz_route[level.iz_route.size] = (425, 7128, 4484);
	level.iz_route[level.iz_route.size] = (540, 6930, 4491);
	level.iz_route[level.iz_route.size] = (949, 6500, 4490);
	level.iz_route[level.iz_route.size] = (1578, 5860, 4461);
	level.iz_route[level.iz_route.size] = (1974, 5515, 4435);
	level.iz_route[level.iz_route.size] = (2206, 5416, 4429);
	level.iz_route[level.iz_route.size] = (2453, 5372, 4431);
	level.iz_route[level.iz_route.size] = (2654, 5374, 4442);
	level.iz_route[level.iz_route.size] = (2863, 5425, 4464);
	level.iz_route[level.iz_route.size] = (3252, 5571, 4515);
	level.iz_route[level.iz_route.size] = (3592, 5641, 4545);
	level.iz_route[level.iz_route.size] = (4363, 5476, 4583);
	level.iz_route[level.iz_route.size] = (4826, 4928, 4583);
	level.iz_route[level.iz_route.size] = (4774, 4239, 4563);
	level.iz_route[level.iz_route.size] = (4296, 3700, 4529);
	level.iz_route[level.iz_route.size] = (3907, 3498, 4513);
	level.iz_route[level.iz_route.size] = (3668, 3372, 4512);
	level.iz_route[level.iz_route.size] = (3462, 3221, 4521);
	level.iz_route[level.iz_route.size] = (3327, 3099, 4532);
	level.iz_route[level.iz_route.size] = (3199, 2963, 4548);
	level.iz_route[level.iz_route.size] = (3061, 2794, 4570);
	level.iz_route[level.iz_route.size] = (2876, 2506, 4602);
	level.iz_route[level.iz_route.size] = (2702, 2000, 4625);
	level.iz_route[level.iz_route.size] = (2567, 1554, 4598);
	level.iz_route[level.iz_route.size] = (2394, 923, 4483);
	level.iz_route[level.iz_route.size] = (2381, 488, 4407);
	level.iz_route[level.iz_route.size] = (2455, 225, 4389);
	level.iz_route[level.iz_route.size] = (2754, -37, 4392);
	level.iz_route[level.iz_route.size] = (3200, -134, 4403);
	level.iz_route[level.iz_route.size] = (4011, -144, 4400);
	level.iz_route[level.iz_route.size] = (4655, -183, 4391);
	level.iz_route[level.iz_route.size] = (5442, -298, 4403);
	level.iz_route[level.iz_route.size] = (5953, -570, 4425);
	level.iz_route[level.iz_route.size] = (6256, -1063, 4449);
	level.iz_route[level.iz_route.size] = (6511, -1834, 4485);
	level.iz_route[level.iz_route.size] = (6564, -2581, 4503);
	level.iz_route[level.iz_route.size] = (6081, -3325, 4511);
	level.iz_route[level.iz_route.size] = (5105, -4008, 4539);
	level.iz_route[level.iz_route.size] = (4386, -4087, 4549);
	level.iz_route[level.iz_route.size] = (3502, -4244, 4565);
	level.iz_route[level.iz_route.size] = (2942, -4330, 4585);
	level.iz_route[level.iz_route.size] = (2726, -4629, 4589);
	level.iz_route[level.iz_route.size] = (2654, -5038, 4589);
	level.iz_route[level.iz_route.size] = (2437, -5795, 4603);
	level.iz_route[level.iz_route.size] = (2108, -6302, 4627);
	level.iz_route[level.iz_route.size] = (1695, -6579, 4647);
	level.iz_route[level.iz_route.size] = (1226, -6681, 4667);
	level.iz_route[level.iz_route.size] = (850, -6700, 4683);
	level.iz_route[level.iz_route.size] = (360, -6601, 4707);
	level.iz_route[level.iz_route.size] = (7, -6424, 4725);
	level.iz_route[level.iz_route.size] = (-240, -6170, 4741);
	level.iz_route[level.iz_route.size] = (-387, -5912, 4753);
	level.iz_route[level.iz_route.size] = (-510, -5620, 4766);
	level.iz_route[level.iz_route.size] = (-600, -5301, 4778);
	level.iz_route[level.iz_route.size] = (-729, -4939, 4788);
	level.iz_route[level.iz_route.size] = (-971, -4773, 4788);
	level.iz_route[level.iz_route.size] = (-1324, -4770, 4790);
	level.iz_route[level.iz_route.size] = (-1932, -4702, 4812);
	level.iz_route[level.iz_route.size] = (-2457, -4524, 4827);
	level.iz_route[level.iz_route.size] = (-2765, -4241, 4833);
	level.iz_route[level.iz_route.size] = (-2915, -3922, 4836);
	level.iz_route[level.iz_route.size] = (-2961, -3471, 4806);
	level.iz_route[level.iz_route.size] = (-2831, -3151, 4711);
	level.iz_route[level.iz_route.size] = (-2632, -2918, 4558);
	level.iz_route[level.iz_route.size] = (-2534, -2694, 4472);
	level.iz_route[level.iz_route.size] = (-2608, -2446, 4469);
	level.iz_route[level.iz_route.size] = (-2819, -2163, 4469);
	level.iz_route[level.iz_route.size] = (-3002, -1825, 4469);
	level.iz_route[level.iz_route.size] = (-3025, -1605, 4469);
	level.iz_route[level.iz_route.size] = (-2957, -1311, 4469);
	level.iz_route[level.iz_route.size] = (-2824, -1128, 4469);
	level.iz_route[level.iz_route.size] = (-2580, -956, 4469);
	level.iz_route[level.iz_route.size] = (-2424, -760, 4469);
	level.iz_route[level.iz_route.size] = (-2300, -439, 4469);
	level.iz_route[level.iz_route.size] = (-2278, -146, 4469);
	level.iz_route[level.iz_route.size] = (-2293, 213, 4469);
	level.iz_route[level.iz_route.size] = (-2231, 495, 4469);
	level.iz_route[level.iz_route.size] = (-2110, 791, 4469);
	level.iz_route[level.iz_route.size] = (-1795, 1000, 4466);
	level.iz_route[level.iz_route.size] = (-1591, 1047, 4451);
	level.iz_route[level.iz_route.size] = (-1331, 1082, 4402);
	level.iz_route[level.iz_route.size] = (-1106, 1136, 4338);
	level.iz_route[level.iz_route.size] = (-866, 1355, 4269);
	level.iz_route[level.iz_route.size] = (-783, 1632, 4233);
	level.iz_route[level.iz_route.size] = (-787, 1874, 4212);
	level.iz_route[level.iz_route.size] = (-901, 2018, 4205);
	level.iz_route[level.iz_route.size] = (-1106, 2127, 4201);
	level.iz_route[level.iz_route.size] = (-1395, 2191, 4205);
	level.iz_route[level.iz_route.size] = (-1819, 2245, 4234);
	level.iz_route[level.iz_route.size] = (-2314, 2304, 4305);
	level.iz_route[level.iz_route.size] = (-2654, 2354, 4367);
	level.iz_route[level.iz_route.size] = (-2962, 2442, 4389);
	level.iz_route[level.iz_route.size] = (-3509, 2695, 4389);
	level.iz_route[level.iz_route.size] = (-4339, 3061, 4389);
	level.iz_route[level.iz_route.size] = (-4858, 3255, 4389);
	level.iz_route[level.iz_route.size] = (-5300, 3385, 4389);
	level.iz_route[level.iz_route.size] = (-5775, 3365, 4389);
	level.iz_route[level.iz_route.size] = (-6234, 3239, 4389);
	level.iz_route[level.iz_route.size] = (-6904, 2960, 4389);
	level.iz_route[level.iz_route.size] = (-7462, 2771, 4389);
	level.iz_route[level.iz_route.size] = (-7910, 2829, 4389);
	level.iz_route[level.iz_route.size] = (-8249, 3020, 4389);
	level.iz_route[level.iz_route.size] = (-8525, 3435, 4389);
	level.iz_route[level.iz_route.size] = (-8446, 3856, 4389);
	level.iz_route[level.iz_route.size] = (-8224, 4342, 4389);
	level.iz_route[level.iz_route.size] = (-7826, 4785, 4389);
	level.iz_route[level.iz_route.size] = (-6874, 5694, 4389);
	level.iz_route[level.iz_route.size] = (-5648, 6702, 4389);
	level.iz_route[level.iz_route.size] = (-4783, 7423, 4389);
	level.iz_route[level.iz_route.size] = (-4445, 7837, 4389);
	level.iz_route[level.iz_route.size] = (-4316, 8095, 4389);
	level.iz_route[level.iz_route.size] = (-4320, 8389, 4389);
	level.iz_route[level.iz_route.size] = (-4446, 8646, 4389);
	level.iz_route[level.iz_route.size] = (-4862, 9377, 4389);
	level.iz_route[level.iz_route.size] = (-5069, 9915, 4389);
	level.iz_route[level.iz_route.size] = (-5031, 10539, 4389);
	level.iz_route[level.iz_route.size] = (-4770, 11237, 4389);
	level.iz_route[level.iz_route.size] = (-4309, 11597, 4389);
	level.iz_route[level.iz_route.size] = (-3591, 11716, 4389);
	level.iz_route[level.iz_route.size] = (-2741, 11745, 4389);
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
	points[0] = (-10191.1426, 10384.8027, 6496.0630);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10227.7959, 10228.0713, 6496.0630);
	angles[1] = (0, 0, 0);
	at[1] = 0.5000;
	points[2] = (-11085.3936, 6826.6929, 6496.0630);
	angles[2] = (0, 0, 0);
	at[2] = 11.5000;
	points[3] = (-12540.6689, 5133.9370, 6496.0630);
	angles[3] = (0, 0, 0);
	at[3] = 18.5000;
	points[4] = (-12620.9062, 5000.6694, 6496.0630);
	angles[4] = (0, 0, 0);
	at[4] = 19;
	points[5] = (-13294.2910, 2375.0315, 6496.0630);
	angles[5] = (0, 0, 0);
	at[5] = 27.5000;
	points[6] = (-13319.9609, 2223.3662, 6496.0630);
	angles[6] = (0, 0, 0);
	at[6] = 28;
	points[7] = (-10348.3467, -1726.5197, 6496.0630);
	angles[7] = (0, 0, 0);
	at[7] = 43.5000;
	points[8] = (-10219.9209, -1807.6693, 6496.0630);
	angles[8] = (0, 0, 0);
	at[8] = 44;
	points[9] = (-6260.2759, -3035.4490, 6496.0630);
	angles[9] = (0, 0, 0);
	at[9] = 57;
	points[10] = (-6119.1733, -3010.0710, 6496.0630);
	angles[10] = (0, 0, 0);
	at[10] = 57.5000;
	points[11] = (-4416.3779, -1828.1182, 6496.0630);
	angles[11] = (0, 0, 0);
	at[11] = 64;
	points[12] = (-4293.0317, -1728.5748, 6496.0630);
	angles[12] = (0, 0, 0);
	at[12] = 64.5000;
	points[13] = (-3023.6223, -296.9106, 6496.0630);
	angles[13] = (0, 0, 0);
	at[13] = 70.5000;
	points[14] = (-2904.6929, -194.7551, 6496.0630);
	angles[14] = (0, 0, 0);
	at[14] = 71;
	points[15] = (-1192.2914, 658.9213, 6496.0630);
	angles[15] = (0, 0, 0);
	at[15] = 77;
	points[16] = (-1043.8976, 711.7953, 6496.0630);
	angles[16] = (0, 0, 0);
	at[16] = 77.5000;
	points[17] = (692.3819, 960.0591, 6496.0630);
	angles[17] = (0, 0, 0);
	at[17] = 83;
	points[18] = (834.6417, 1010.8661, 6496.0630);
	angles[18] = (0, 0, 0);
	at[18] = 83.5000;
	points[19] = (2383.1221, 2833.6497, 6496.0630);
	angles[19] = (0, 0, 0);
	at[19] = 91;
	points[20] = (2469.5159, 2961.8740, 6496.0630);
	angles[20] = (0, 0, 0);
	at[20] = 91.5000;
	points[21] = (2605.8503, 5509.4092, 6496.0630);
	angles[21] = (0, 0, 0);
	at[21] = 99.5000;
	points[22] = (2554.4448, 5651.7324, 6496.0630);
	angles[22] = (0, 0, 0);
	at[22] = 100;
	points[23] = (835.1850, 8146.1421, 6496.0630);
	angles[23] = (0, 0, 0);
	at[23] = 109.5000;
	points[24] = (715.6536, 8246.1025, 6496.0630);
	angles[24] = (0, 0, 0);
	at[24] = 110;
	points[25] = (-2039.2205, 9852.3623, 6496.0630);
	angles[25] = (0, 0, 0);
	at[25] = 120;
	points[26] = (-2192.1064, 9896.2988, 6496.0630);
	angles[26] = (0, 0, 0);
	at[26] = 120.5000;
	points[27] = (-5118.8584, 10678.5049, 6496.0630);
	angles[27] = (0, 0, 0);
	at[27] = 130;
	points[28] = (-7233.5039, 11393.5430, 6496.0630);
	angles[28] = (0, 0, 0);
	at[28] = 137;
	points[29] = (-7384.2915, 11424.6064, 6496.0630);
	angles[29] = (0, 0, 0);
	at[29] = 137.5000;
	points[30] = (-10191.1426, 10384.8027, 6496.0630);
	angles[30] = (0, 0, 0);
	at[30] = 146.8830;
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
