main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_cassiopeia", 0);

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
	ambientPlay("iz_0_st7", 2);
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
	thread iz_mover2();
	thread iz_mover3();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 791, 0);
	angles[0] = (0, -0.0055, 0);
	at[0] = 0;
	points[1] = (0, 791, 0);
	angles[1] = (0, 1.7830, 0);
	at[1] = 0.3000;
	points[2] = (0, 791, 0);
	angles[2] = (0, 6.5264, 0);
	at[2] = 0.6000;
	points[3] = (0, 791, 0);
	angles[3] = (0, 13.2915, 0);
	at[3] = 0.9000;
	points[4] = (0, 791, 0);
	angles[4] = (0, 32.9259, 0);
	at[4] = 1.6500;
	points[5] = (0, 791, 0);
	angles[5] = (0, 39.4188, 0);
	at[5] = 1.9500;
	points[6] = (0, 791, 0);
	angles[6] = (0, 43.7344, 0);
	at[6] = 2.2500;
	points[7] = (0, 791, 0);
	angles[7] = (0, 44.9945, 0);
	at[7] = 2.5000;
	points[8] = (0, 791, 0);
	angles[8] = (0, 43.7344, 0);
	at[8] = 2.7500;
	points[9] = (0, 791, 0);
	angles[9] = (0, 39.4188, 0);
	at[9] = 3.0500;
	points[10] = (0, 791, 0);
	angles[10] = (0, 32.9259, 0);
	at[10] = 3.3500;
	points[11] = (0, 791, 0);
	angles[11] = (0, 13.2915, 0);
	at[11] = 4.1000;
	points[12] = (0, 791, 0);
	angles[12] = (0, 6.5264, 0);
	at[12] = 4.4000;
	points[13] = (0, 791, 0);
	angles[13] = (0, 1.7830, 0);
	at[13] = 4.7000;
	points[14] = (0, 791, 0);
	angles[14] = (0, -0.0055, 0);
	at[14] = 5;
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
	points[0] = (-105, 392, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-105, 392, 0);
	angles[1] = (0, -1.7885, 0);
	at[1] = 0.3000;
	points[2] = (-105, 392, 0);
	angles[2] = (0, -6.5318, 0);
	at[2] = 0.6000;
	points[3] = (-105, 392, 0);
	angles[3] = (0, -13.2970, 0);
	at[3] = 0.9000;
	points[4] = (-105, 392, 0);
	angles[4] = (0, -32.9314, 0);
	at[4] = 1.6500;
	points[5] = (-105, 392, 0);
	angles[5] = (0, -39.4243, 0);
	at[5] = 1.9500;
	points[6] = (-105, 392, 0);
	angles[6] = (0, -43.7400, 0);
	at[6] = 2.2500;
	points[7] = (-105, 392, 0);
	angles[7] = (0, -45, 0);
	at[7] = 2.5000;
	points[8] = (-105, 392, 0);
	angles[8] = (0, -43.7400, 0);
	at[8] = 2.7500;
	points[9] = (-105, 392, 0);
	angles[9] = (0, -39.4243, 0);
	at[9] = 3.0500;
	points[10] = (-105, 392, 0);
	angles[10] = (0, -32.9314, 0);
	at[10] = 3.3500;
	points[11] = (-105, 392, 0);
	angles[11] = (0, -13.2970, 0);
	at[11] = 4.1000;
	points[12] = (-105, 392, 0);
	angles[12] = (0, -6.5318, 0);
	at[12] = 4.4000;
	points[13] = (-105, 392, 0);
	angles[13] = (0, -1.7885, 0);
	at[13] = 4.7000;
	points[14] = (-105, 392, 0);
	angles[14] = (0, 0, 0);
	at[14] = 5;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, -0.0055, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 1.7830, 0);
	at[1] = 0.3000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 6.5264, 0);
	at[2] = 0.6000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 13.2915, 0);
	at[3] = 0.9000;
	points[4] = (0, 0, 0);
	angles[4] = (0, 32.9259, 0);
	at[4] = 1.6500;
	points[5] = (0, 0, 0);
	angles[5] = (0, 39.4188, 0);
	at[5] = 1.9500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 43.7344, 0);
	at[6] = 2.2500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 44.9945, 0);
	at[7] = 2.5000;
	points[8] = (0, 0, 0);
	angles[8] = (0, 43.7344, 0);
	at[8] = 2.7500;
	points[9] = (0, 0, 0);
	angles[9] = (0, 39.4188, 0);
	at[9] = 3.0500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 32.9259, 0);
	at[10] = 3.3500;
	points[11] = (0, 0, 0);
	angles[11] = (0, 13.2915, 0);
	at[11] = 4.1000;
	points[12] = (0, 0, 0);
	angles[12] = (0, 6.5264, 0);
	at[12] = 4.4000;
	points[13] = (0, 0, 0);
	angles[13] = (0, 1.7830, 0);
	at[13] = 4.7000;
	points[14] = (0, 0, 0);
	angles[14] = (0, -0.0055, 0);
	at[14] = 5;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-105, -406, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-105, -406, 0);
	angles[1] = (0, -1.7885, 0);
	at[1] = 0.3000;
	points[2] = (-105, -406, 0);
	angles[2] = (0, -6.5318, 0);
	at[2] = 0.6000;
	points[3] = (-105, -406, 0);
	angles[3] = (0, -13.2970, 0);
	at[3] = 0.9000;
	points[4] = (-105, -406, 0);
	angles[4] = (0, -32.9314, 0);
	at[4] = 1.6500;
	points[5] = (-105, -406, 0);
	angles[5] = (0, -39.4243, 0);
	at[5] = 1.9500;
	points[6] = (-105, -406, 0);
	angles[6] = (0, -43.7400, 0);
	at[6] = 2.2500;
	points[7] = (-105, -406, 0);
	angles[7] = (0, -45, 0);
	at[7] = 2.5000;
	points[8] = (-105, -406, 0);
	angles[8] = (0, -43.7400, 0);
	at[8] = 2.7500;
	points[9] = (-105, -406, 0);
	angles[9] = (0, -39.4243, 0);
	at[9] = 3.0500;
	points[10] = (-105, -406, 0);
	angles[10] = (0, -32.9314, 0);
	at[10] = 3.3500;
	points[11] = (-105, -406, 0);
	angles[11] = (0, -13.2970, 0);
	at[11] = 4.1000;
	points[12] = (-105, -406, 0);
	angles[12] = (0, -6.5318, 0);
	at[12] = 4.4000;
	points[13] = (-105, -406, 0);
	angles[13] = (0, -1.7885, 0);
	at[13] = 4.7000;
	points[14] = (-105, -406, 0);
	angles[14] = (0, 0, 0);
	at[14] = 5;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
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
