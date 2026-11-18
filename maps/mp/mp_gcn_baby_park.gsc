main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_baby_park", 0);

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
	ambientPlay("iz_0_58", 2);
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
	level.iz_route[level.iz_route.size] = (-894, 961, 2126);
	level.iz_route[level.iz_route.size] = (-904, 2772, 2126);
	level.iz_route[level.iz_route.size] = (-786, 3877, 2126);
	level.iz_route[level.iz_route.size] = (14, 4380, 2126);
	level.iz_route[level.iz_route.size] = (827, 3807, 2126);
	level.iz_route[level.iz_route.size] = (895, 2775, 2126);
	level.iz_route[level.iz_route.size] = (893, 958, 2126);
	level.iz_route[level.iz_route.size] = (911, -1527, 2126);
	level.iz_route[level.iz_route.size] = (891, -3077, 2126);
	level.iz_route[level.iz_route.size] = (742, -3965, 2126);
	level.iz_route[level.iz_route.size] = (2, -4386, 2126);
	level.iz_route[level.iz_route.size] = (-749, -3949, 2126);
	level.iz_route[level.iz_route.size] = (-916, -3039, 2126);
	level.iz_route[level.iz_route.size] = (-897, -1182, 2126);
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
	points[0] = (-2223.7678, 6167.2441, 3907.3701);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-2519.3860, 4260.7876, 3574.7598);
	angles[1] = (0, 90, 0);
	at[1] = 6.5000;
	points[2] = (-2535.3386, 4113.0708, 3552.6577);
	angles[2] = (0, 90, 0);
	at[2] = 7;
	points[3] = (-2577.8623, 1716.4370, 3308.3269);
	angles[3] = (0, 90, 0);
	at[3] = 15;
	points[4] = (-2569.8228, 1567, 3295.0471);
	angles[4] = (0, 90, 0);
	at[4] = 15.5000;
	points[5] = (-2288.4016, -818.8779, 3111.0867);
	angles[5] = (0, 90, 0);
	at[5] = 23.5000;
	points[6] = (-2268.2598, -967.5512, 3099.5276);
	angles[6] = (0, 90, 0);
	at[6] = 24;
	points[7] = (-1829.3229, -2869.0945, 2944.8267);
	angles[7] = (0, 90, 0);
	at[7] = 30.5000;
	points[8] = (-1823.7677, -4072.0474, 2879.9685);
	angles[8] = (0, 90, 0);
	at[8] = 34.5000;
	points[9] = (-1800.3112, -4217.4805, 2872.8818);
	angles[9] = (0, 90, 0);
	at[9] = 35;
	points[10] = (-1115.0039, -5724.4487, 2814.1497);
	angles[10] = (0, 90, 0);
	at[10] = 40.5000;
	points[11] = (-1040.2401, -5855.0396, 2813.1377);
	angles[11] = (0, 90, 0);
	at[11] = 41;
	points[12] = (-274.0752, -7151.4570, 2809.4607);
	angles[12] = (0, 90, 0);
	at[12] = 46;
	points[13] = (-157.1721, -7210.5513, 2810.0078);
	angles[13] = (0, 90, 0);
	at[13] = 46.5000;
	points[14] = (1499.2678, -7212.2051, 2824.4016);
	angles[14] = (0, 90, 0);
	at[14] = 52;
	points[15] = (1611.0787, -7120.7871, 2824.9766);
	angles[15] = (0, 90, 0);
	at[15] = 52.5000;
	points[16] = (2448.4448, -6254.6851, 2828.5198);
	angles[16] = (0, 90, 0);
	at[16] = 56.5000;
	points[17] = (2794.9565, -4026.9290, 2959.9568);
	angles[17] = (0, 90, 0);
	at[17] = 64;
	points[18] = (2815.3308, -3878.1379, 2968.9805);
	angles[18] = (0, 90, 0);
	at[18] = 64.5000;
	points[19] = (2983.9487, 926.1772, 3303.2915);
	angles[19] = (0, 90, 0);
	at[19] = 80.5000;
	points[20] = (2936.1772, 3333.2717, 3398.2520);
	angles[20] = (0, 90, 0);
	at[20] = 88.5000;
	points[21] = (2930.4055, 3483.6221, 3401.2087);
	angles[21] = (0, 90, 0);
	at[21] = 89;
	points[22] = (2824.2205, 4985.6299, 3379.1143);
	angles[22] = (0, 90, 0);
	at[22] = 94;
	points[23] = (2776.5039, 5127.1650, 3388.9451);
	angles[23] = (0, 90, 0);
	at[23] = 94.5000;
	points[24] = (2345.8308, 6248.3071, 3483.5042);
	angles[24] = (0, 90, 0);
	at[24] = 98.5000;
	points[25] = (2264.3662, 6370.9058, 3495.9055);
	angles[25] = (0, 90, 0);
	at[25] = 99;
	points[26] = (1539.2794, 7130.7085, 3586.0120);
	angles[26] = (0, 90, 0);
	at[26] = 102.5000;
	points[27] = (1411.5945, 7207.2051, 3587.8623);
	angles[27] = (0, 90, 0);
	at[27] = 103;
	points[28] = (602.0866, 7608.4648, 3579.1182);
	angles[28] = (0, 90, 0);
	at[28] = 106;
	points[29] = (462.7323, 7662.0474, 3578.0552);
	angles[29] = (0, 90, 0);
	at[29] = 106.5000;
	points[30] = (-425.7047, 7826.5747, 3576.3074);
	angles[30] = (0, 90, 0);
	at[30] = 109.5000;
	points[31] = (-572.2874, 7824.1338, 3574.8699);
	angles[31] = (0, 90, 0);
	at[31] = 110;
	points[32] = (-1439.9489, 7572.6768, 3557.1733);
	angles[32] = (0, 90, 0);
	at[32] = 113;
	points[33] = (-1542.5394, 7479.6460, 3587.2522);
	angles[33] = (0, 90, 0);
	at[33] = 113.5000;
	points[34] = (-1955.8071, 6893.2681, 3815.9922);
	angles[34] = (0, 90, 0);
	at[34] = 116;
	points[35] = (-2009.7520, 6754.6851, 3835.8740);
	angles[35] = (0, 90, 0);
	at[35] = 116.5000;
	points[36] = (-2216.2834, 6193.3071, 3907.0510);
	angles[36] = (0, 90, 0);
	at[36] = 118.5000;
	points[37] = (-2223.7678, 6167.2441, 3907.3701);
	angles[37] = (0, 90, 0);
	at[37] = 118.6000;
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
