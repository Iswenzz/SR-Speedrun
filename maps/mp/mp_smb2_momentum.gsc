main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_momentum", 0);

	thread iz_sounds();

	thread iz_bananas();

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
	ambientPlay("iz_0_clocktower", 2);
}

iz_bananas()
{
	bananas = getEntArray("iz_banana", "targetname");
	for (i = 0; i < bananas.size; i++)
		bananas[i] thread iz_banana();
}

iz_banana()
{
	self notSolid();
	// One on a moving group rides what its target names, and a linked
	// entity takes no turn of its own.
	ride = undefined;
	if (isDefined(self.target))
		ride = getEnt(self.target, "targetname");
	if (isDefined(ride))
		self linkTo(ride);
	else
		self thread iz_banana_spin();
	reach = 48;
	if (isDefined(self.radius))
		reach = self.radius;
	for (;;)
	{
		wait 0.1;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isAlive(players[i]) || distance(players[i].origin + (0, 0, 35), self.origin) > reach)
				continue;
			if (isDefined(level.iz_cue) && isDefined(level.iz_cue["iz_cue_banana"]))
				players[i] playLocalSound("iz_cue_banana");
			self hide();
			wait 15;
			self show();
			break;
		}
	}
}

iz_banana_spin()
{
	for (;;)
	{
		self rotateYaw(360, 2);
		wait 2;
	}
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
	thread iz_mover0();
	thread iz_mover1();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -14434.0156, 1050);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -14434.0156, 1050);
	angles[1] = (0.8998, 0, 0);
	at[1] = 0.1000;
	points[2] = (0, -14434.0156, 1050);
	angles[2] = (5.3600, 0, 0);
	at[2] = 0.2500;
	points[3] = (0, -14434.0156, 1050);
	angles[3] = (10.1606, 0, 0);
	at[3] = 0.3500;
	points[4] = (0, -14434.0156, 1050);
	angles[4] = (19.6800, 0, -0.0020);
	at[4] = 0.5000;
	points[5] = (0, -14434.0156, 1050);
	angles[5] = (31.4746, 0, -0.0034);
	at[5] = 0.6500;
	points[6] = (0, -14434.0156, 1050);
	angles[6] = (44.9740, -0.0023, -0.0055);
	at[6] = 0.8000;
	points[7] = (0, -14434.0156, 1050);
	angles[7] = (89.9945, -0.0571, -0.0626);
	at[7] = 1.2500;
	points[8] = (0, -14434.0156, 1050);
	angles[8] = (89.9945, -0.0571, -0.0626);
	at[8] = 3.7500;
	points[9] = (0, -14434.0156, 1050);
	angles[9] = (44.9742, -0.0023, -0.0055);
	at[9] = 4.2000;
	points[10] = (0, -14434.0156, 1050);
	angles[10] = (31.4746, 0, -0.0034);
	at[10] = 4.3500;
	points[11] = (0, -14434.0156, 1050);
	angles[11] = (19.6800, 0, -0.0020);
	at[11] = 4.5000;
	points[12] = (0, -14434.0156, 1050);
	angles[12] = (10.1607, 0, 0);
	at[12] = 4.6500;
	points[13] = (0, -14434.0156, 1050);
	angles[13] = (5.3600, 0, 0);
	at[13] = 4.7500;
	points[14] = (0, -14434.0156, 1050);
	angles[14] = (0.8999, 0, 0);
	at[14] = 4.9000;
	points[15] = (0, -14434.0156, 1050);
	angles[15] = (0, 0, 0);
	at[15] = 5;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -14434.0156, 1050);
	angles[0] = (-0.0035, 0, 0);
	at[0] = 0;
	points[1] = (0, -14434.0156, 1050);
	angles[1] = (0.0055, 0, 0);
	at[1] = 1.2500;
	points[2] = (0, -14434.0156, 1050);
	angles[2] = (45.0315, -0.0023, -0.0055);
	at[2] = 1.7000;
	points[3] = (0, -14434.0156, 1050);
	angles[3] = (58.5310, -0.0050, -0.0090);
	at[3] = 1.8500;
	points[4] = (0, -14434.0156, 1050);
	angles[4] = (66.6187, -0.0083, -0.0127);
	at[4] = 1.9500;
	points[5] = (0, -14434.0156, 1050);
	angles[5] = (76.9598, -0.0188, -0.0237);
	at[5] = 2.1000;
	points[6] = (0, -14434.0156, 1050);
	angles[6] = (82.4138, -0.0361, -0.0412);
	at[6] = 2.2000;
	points[7] = (0, -14434.0156, 1050);
	angles[7] = (88.0125, -0.1528, -0.1582);
	at[7] = 2.3500;
	points[8] = (0, -14434.0156, 1050);
	angles[8] = (89.7769, -1.4041, -1.4096);
	at[8] = 2.4500;
	points[9] = (0, -14434.0156, 1050);
	angles[9] = (90.0078, 44.7414, 44.7386);
	at[9] = 2.5000;
	points[10] = (0, -14434.0156, 1050);
	angles[10] = (89.7769, -1.4041, -1.4096);
	at[10] = 2.5500;
	points[11] = (0, -14434.0156, 1050);
	angles[11] = (88.0125, -0.1528, -0.1582);
	at[11] = 2.6500;
	points[12] = (0, -14434.0156, 1050);
	angles[12] = (82.4138, -0.0361, -0.0412);
	at[12] = 2.8000;
	points[13] = (0, -14434.0156, 1050);
	angles[13] = (76.9598, -0.0188, -0.0237);
	at[13] = 2.9000;
	points[14] = (0, -14434.0156, 1050);
	angles[14] = (66.6187, -0.0083, -0.0127);
	at[14] = 3.0500;
	points[15] = (0, -14434.0156, 1050);
	angles[15] = (58.5310, -0.0050, -0.0090);
	at[15] = 3.1500;
	points[16] = (0, -14434.0156, 1050);
	angles[16] = (45.0315, -0.0023, -0.0055);
	at[16] = 3.3000;
	points[17] = (0, -14434.0156, 1050);
	angles[17] = (0.0055, 0, 0);
	at[17] = 3.7500;
	points[18] = (0, -14434.0156, 1050);
	angles[18] = (-0.0035, 0, 0);
	at[18] = 5;
	mover = getEnt("iz_mover1", "targetname");
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
