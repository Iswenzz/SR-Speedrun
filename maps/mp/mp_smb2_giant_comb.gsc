main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_giant_comb", 0);

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
	ambientPlay("iz_0_kujira", 2);
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
	points[0] = (0, -7350, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -7350, 0);
	angles[1] = (0, 54, 0);
	at[1] = 0.3000;
	points[2] = (0, -7350, 0);
	angles[2] = (0, 108, 0);
	at[2] = 0.6000;
	points[3] = (0, -7350, 0);
	angles[3] = (0, 162, 0);
	at[3] = 0.9000;
	points[4] = (0, -7350, 0);
	angles[4] = (0, 225, 0);
	at[4] = 1.2500;
	points[5] = (0, -7350, 0);
	angles[5] = (0, 279, 0);
	at[5] = 1.5500;
	points[6] = (0, -7350, 0);
	angles[6] = (0, 333, 0);
	at[6] = 1.8500;
	points[7] = (0, -7350, 0);
	angles[7] = (0, 387, 0);
	at[7] = 2.1500;
	points[8] = (0, -7350, 0);
	angles[8] = (0, 450, 0);
	at[8] = 2.5000;
	points[9] = (0, -7350, 0);
	angles[9] = (0, 504, 0);
	at[9] = 2.8000;
	points[10] = (0, -7350, 0);
	angles[10] = (0, 558, 0);
	at[10] = 3.1000;
	points[11] = (0, -7350, 0);
	angles[11] = (0, 612, 0);
	at[11] = 3.4000;
	points[12] = (0, -7350, 0);
	angles[12] = (0, 675, 0);
	at[12] = 3.7500;
	points[13] = (0, -7350, 0);
	angles[13] = (0, 729, 0);
	at[13] = 4.0500;
	points[14] = (0, -7350, 0);
	angles[14] = (0, 783, 0);
	at[14] = 4.3500;
	points[15] = (0, -7350, 0);
	angles[15] = (0, 837, 0);
	at[15] = 4.6500;
	points[16] = (0, -7350, 0);
	angles[16] = (0, 900, 0);
	at[16] = 5;
	points[17] = (0, -7350, 0);
	angles[17] = (0, 954, 0);
	at[17] = 5.3000;
	points[18] = (0, -7350, 0);
	angles[18] = (0, 1008, 0);
	at[18] = 5.6000;
	points[19] = (0, -7350, 0);
	angles[19] = (0, 1062, 0);
	at[19] = 5.9000;
	points[20] = (0, -7350, 0);
	angles[20] = (0, 1125, 0);
	at[20] = 6.2500;
	points[21] = (0, -7350, 0);
	angles[21] = (0, 1179, 0);
	at[21] = 6.5500;
	points[22] = (0, -7350, 0);
	angles[22] = (0, 1233, 0);
	at[22] = 6.8500;
	points[23] = (0, -7350, 0);
	angles[23] = (0, 1287, 0);
	at[23] = 7.1500;
	points[24] = (0, -7350, 0);
	angles[24] = (0, 1350, 0);
	at[24] = 7.5000;
	points[25] = (0, -7350, 0);
	angles[25] = (0, 1404, 0);
	at[25] = 7.8000;
	points[26] = (0, -7350, 0);
	angles[26] = (0, 1458, 0);
	at[26] = 8.1000;
	points[27] = (0, -7350, 0);
	angles[27] = (0, 1512, 0);
	at[27] = 8.4000;
	points[28] = (0, -7350, 0);
	angles[28] = (0, 1575, 0);
	at[28] = 8.7500;
	points[29] = (0, -7350, 0);
	angles[29] = (0, 1629, 0);
	at[29] = 9.0500;
	points[30] = (0, -7350, 0);
	angles[30] = (0, 1683, 0);
	at[30] = 9.3500;
	points[31] = (0, -7350, 0);
	angles[31] = (0, 1737, 0);
	at[31] = 9.6500;
	points[32] = (0, -7350, 0);
	angles[32] = (0, 1800, 0);
	at[32] = 10;
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
