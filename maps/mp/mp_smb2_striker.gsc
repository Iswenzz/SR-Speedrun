main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_striker", 0);

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
	ambientPlay("iz_0_sf", 2);
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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (175, 1225, -70);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (175, 1225, -84.5598);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (175, 1225, -119.2799);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (175, 1225, -160.7201);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (175, 1225, -195.4402);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (175, 1225, -210);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (175, 1225, -210);
	angles[6] = (0, 0, 0);
	at[6] = 0.6000;
	points[7] = (175, 1225, -165.8335);
	angles[7] = (0, 0, 0);
	at[7] = 0.6500;
	points[8] = (175, 1225, 62.5248);
	angles[8] = (0, 0, 0);
	at[8] = 0.7000;
	points[9] = (175, 1225, 210);
	angles[9] = (0, 0, 0);
	at[9] = 0.7500;
	points[10] = (175, 1225, 62.1598);
	angles[10] = (0, 0, 0);
	at[10] = 0.8000;
	points[11] = (175, 1225, -166.3201);
	angles[11] = (0, 0, 0);
	at[11] = 0.8500;
	points[12] = (175, 1225, -188.1599);
	angles[12] = (0, 0, 0);
	at[12] = 0.9000;
	points[13] = (175, 1225, -73.9201);
	angles[13] = (0, 0, 0);
	at[13] = 0.9500;
	points[14] = (175, 1225, 0);
	angles[14] = (0, 0, 0);
	at[14] = 1;
	points[15] = (175, 1225, -36.9599);
	angles[15] = (0, 0, 0);
	at[15] = 1.0500;
	points[16] = (175, 1225, -94.0799);
	angles[16] = (0, 0, 0);
	at[16] = 1.1000;
	points[17] = (175, 1225, -99.5402);
	angles[17] = (0, 0, 0);
	at[17] = 1.1500;
	points[18] = (175, 1225, -70.9799);
	angles[18] = (0, 0, 0);
	at[18] = 1.2000;
	points[19] = (175, 1225, -52.5000);
	angles[19] = (0, 0, 0);
	at[19] = 1.2500;
	points[20] = (175, 1225, -58.6598);
	angles[20] = (0, 0, 0);
	at[20] = 1.3000;
	points[21] = (175, 1225, -68.1799);
	angles[21] = (0, 0, 0);
	at[21] = 1.3500;
	points[22] = (175, 1225, -70);
	angles[22] = (0, 0, 0);
	at[22] = 1.4000;
	points[23] = (175, 1225, -70);
	angles[23] = (0, 0, 0);
	at[23] = 3;
	mover = getEnt("iz_mover0", "targetname");
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
