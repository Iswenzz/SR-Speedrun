main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_koopa_beach_1", 0);

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
	ambientPlay("iz_0_10", 2);
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
	level.iz_route[level.iz_route.size] = (1736, -1943, 639);
	level.iz_route[level.iz_route.size] = (1704, -2350, 639);
	level.iz_route[level.iz_route.size] = (1517, -2688, 639);
	level.iz_route[level.iz_route.size] = (1055, -3199, 639);
	level.iz_route[level.iz_route.size] = (333, -3547, 639);
	level.iz_route[level.iz_route.size] = (-650, -3679, 639);
	level.iz_route[level.iz_route.size] = (-2277, -3879, 639);
	level.iz_route[level.iz_route.size] = (-3367, -3814, 639);
	level.iz_route[level.iz_route.size] = (-4564, -3391, 639);
	level.iz_route[level.iz_route.size] = (-5705, -2944, 639);
	level.iz_route[level.iz_route.size] = (-6582, -2134, 639);
	level.iz_route[level.iz_route.size] = (-6797, -1201, 693);
	level.iz_route[level.iz_route.size] = (-6867, 264, 604);
	level.iz_route[level.iz_route.size] = (-6862, 889, 604);
	level.iz_route[level.iz_route.size] = (-7110, 1658, 639);
	level.iz_route[level.iz_route.size] = (-7538, 2531, 639);
	level.iz_route[level.iz_route.size] = (-7640, 3574, 639);
	level.iz_route[level.iz_route.size] = (-7237, 4405, 639);
	level.iz_route[level.iz_route.size] = (-6684, 4755, 639);
	level.iz_route[level.iz_route.size] = (-5983, 5001, 639);
	level.iz_route[level.iz_route.size] = (-5307, 5000, 699);
	level.iz_route[level.iz_route.size] = (-3334, 5257, 639);
	level.iz_route[level.iz_route.size] = (-2588, 5770, 639);
	level.iz_route[level.iz_route.size] = (-1979, 6344, 639);
	level.iz_route[level.iz_route.size] = (-1103, 6691, 639);
	level.iz_route[level.iz_route.size] = (84, 6575, 639);
	level.iz_route[level.iz_route.size] = (1124, 6332, 639);
	level.iz_route[level.iz_route.size] = (1856, 5712, 639);
	level.iz_route[level.iz_route.size] = (2278, 5054, 639);
	level.iz_route[level.iz_route.size] = (2517, 4151, 638);
	level.iz_route[level.iz_route.size] = (2575, 3804, 639);
	level.iz_route[level.iz_route.size] = (2559, 3409, 639);
	level.iz_route[level.iz_route.size] = (2347, 1886, 639);
	level.iz_route[level.iz_route.size] = (1993, 410, 639);
	level.iz_route[level.iz_route.size] = (1782, -772, 639);
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
	points[0] = (-292.7551, -3022.9094, 638.7638);
	angles[0] = (0, -91.8230, 0);
	at[0] = 0;
	points[1] = (-326.9949, -4098.6616, 638.7638);
	angles[1] = (0, -91.8230, 0);
	at[1] = 4.0500;
	points[2] = (-326.4425, -4081.2993, 638.7638);
	angles[2] = (0, -91.8230, 0);
	at[2] = 4.1000;
	points[3] = (-292.6252, -3018.8269, 638.7638);
	angles[3] = (0, -91.8230, 0);
	at[3] = 8.1000;
	points[4] = (-292.7551, -3022.9094, 638.7638);
	angles[4] = (0, -91.8230, 0);
	at[4] = 8.1333;
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
	points[0] = (-2439.4409, -4439.3701, 638.7638);
	angles[0] = (0, 87.8514, 0);
	at[0] = 0;
	points[1] = (-2398.0945, -3337.2874, 638.7638);
	angles[1] = (0, 87.8514, 0);
	at[1] = 4.1500;
	points[2] = (-2398.0315, -3335.6929, 638.7638);
	angles[2] = (0, 87.8514, 0);
	at[2] = 4.2000;
	points[3] = (-2439.3818, -4437.7559, 638.7638);
	angles[3] = (0, 87.8514, 0);
	at[3] = 8.3500;
	points[4] = (-2439.4409, -4439.3701, 638.7638);
	angles[4] = (0, 87.8514, 0);
	at[4] = 8.4000;
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
	points[0] = (-8325.2764, 2309.7834, 638.7638);
	angles[0] = (0, 5.8595, 0);
	at[0] = 0;
	points[1] = (-7043.1104, 2441.3623, 638.7638);
	angles[1] = (0, 5.8595, 0);
	at[1] = 4.8500;
	points[2] = (-7050.5513, 2440.6023, 638.7638);
	angles[2] = (0, 5.8595, 0);
	at[2] = 4.9000;
	points[3] = (-8332.6768, 2309.0198, 638.7638);
	angles[3] = (0, 5.8595, 0);
	at[3] = 9.7500;
	points[4] = (-8325.2764, 2309.7834, 638.7638);
	angles[4] = (0, 5.8595, 0);
	at[4] = 9.7667;
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
	points[0] = (-6653.1890, 3963.4250, 638.7638);
	angles[0] = (0, 179.5625, 0);
	at[0] = 0;
	points[1] = (-8167.9136, 3974.9604, 638.7638);
	angles[1] = (0, 179.5625, 0);
	at[1] = 5.7000;
	points[2] = (-8151.8110, 3974.8425, 638.7638);
	angles[2] = (0, 179.5625, 0);
	at[2] = 5.7500;
	points[3] = (-6650.3936, 3963.3857, 638.7638);
	angles[3] = (0, 179.5625, 0);
	at[3] = 11.4000;
	points[4] = (-6653.1890, 3963.4250, 638.7638);
	angles[4] = (0, 179.5625, 0);
	at[4] = 11.4333;
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
	points[0] = (57.8866, 4702.0474, 638.7638);
	angles[0] = (0, -117.2447, 0);
	at[0] = 0;
	points[1] = (-665.9725, 3296.2676, 638.7638);
	angles[1] = (0, -117.2447, 0);
	at[1] = 5.9500;
	points[2] = (-663.0433, 3301.9526, 638.7638);
	angles[2] = (0, -117.2447, 0);
	at[2] = 6;
	points[3] = (60.8142, 4707.7163, 638.7638);
	angles[3] = (0, -117.2447, 0);
	at[3] = 11.9500;
	points[4] = (57.8866, 4702.0474, 638.7638);
	angles[4] = (0, -117.2447, 0);
	at[4] = 11.9667;
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
	points[0] = (-2032.1300, 5589.6460, 638.7638);
	angles[0] = (0, 83.5116, 0);
	at[0] = 0;
	points[1] = (-1854.9567, 7147.5195, 638.7638);
	angles[1] = (0, 83.5116, 0);
	at[1] = 5.9000;
	points[2] = (-1854.7716, 7149.0947, 638.7638);
	angles[2] = (0, 83.5116, 0);
	at[2] = 5.9500;
	points[3] = (-2031.9489, 5591.2207, 638.7638);
	angles[3] = (0, 83.5116, 0);
	at[3] = 11.8500;
	points[4] = (-2032.1300, 5589.6460, 638.7638);
	angles[4] = (0, 83.5116, 0);
	at[4] = 11.9000;
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
