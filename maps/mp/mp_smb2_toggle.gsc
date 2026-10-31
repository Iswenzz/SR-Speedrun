main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_toggle", 0);

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
	ambientPlay("iz_0_yuenchi", 2);
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
	points[0] = (0, 3220, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 3220, 0);
	angles[1] = (1.8662, 0, 0);
	at[1] = 0.1500;
	points[2] = (0, 3220, 0);
	angles[2] = (7.1539, 0, 0);
	at[2] = 0.3000;
	points[3] = (0, 3220, 0);
	angles[3] = (15.3965, 0, 0);
	at[3] = 0.4500;
	points[4] = (0, 3220, 0);
	angles[4] = (26.1274, 0, 0);
	at[4] = 0.6000;
	points[5] = (0, 3220, 0);
	angles[5] = (38.8801, 0, 0);
	at[5] = 0.7500;
	points[6] = (0, 3220, 0);
	angles[6] = (53.1878, 0, 0);
	at[6] = 0.9000;
	points[7] = (0, 3220, 0);
	angles[7] = (116.6399, 0, 0);
	at[7] = 1.5000;
	points[8] = (0, 3220, 0);
	angles[8] = (141.1199, 0, 0);
	at[8] = 1.7500;
	points[9] = (0, 3220, 0);
	angles[9] = (153.8726, 0, 0);
	at[9] = 1.9000;
	points[10] = (0, 3220, 0);
	angles[10] = (161.2800, 0, 0);
	at[10] = 2;
	points[11] = (0, 3220, 0);
	angles[11] = (170.4039, 0, 0);
	at[11] = 2.1500;
	points[12] = (0, 3220, 0);
	angles[12] = (174.9600, 0, 0);
	at[12] = 2.2500;
	points[13] = (0, 3220, 0);
	angles[13] = (179.1590, 0, 0);
	at[13] = 2.4000;
	points[14] = (0, 3220, 0);
	angles[14] = (180, 0, 0);
	at[14] = 2.5000;
	points[15] = (0, 3220, 0);
	angles[15] = (180, 0, 0);
	at[15] = 5;
	points[16] = (0, 3220, 0);
	angles[16] = (181.8662, 0, 0);
	at[16] = 5.1500;
	points[17] = (0, 3220, 0);
	angles[17] = (185.0400, 0, 0);
	at[17] = 5.2500;
	points[18] = (0, 3220, 0);
	angles[18] = (192.3495, 0, 0);
	at[18] = 5.4000;
	points[19] = (0, 3220, 0);
	angles[19] = (198.7200, 0, 0);
	at[19] = 5.5000;
	points[20] = (0, 3220, 0);
	angles[20] = (210.1766, 0, 0);
	at[20] = 5.6500;
	points[21] = (0, 3220, 0);
	angles[21] = (223.4996, 0, 0);
	at[21] = 5.8000;
	points[22] = (0, 3220, 0);
	angles[22] = (238.2220, 0, 0);
	at[22] = 5.9500;
	points[23] = (0, 3220, 0);
	angles[23] = (296.6399, 0, 0);
	at[23] = 6.5000;
	points[24] = (0, 3220, 0);
	angles[24] = (321.1200, 0, 0);
	at[24] = 6.7500;
	points[25] = (0, 3220, 0);
	angles[25] = (333.8726, 0, 0);
	at[25] = 6.9000;
	points[26] = (0, 3220, 0);
	angles[26] = (341.2800, 0, 0);
	at[26] = 7;
	points[27] = (0, 3220, 0);
	angles[27] = (350.4039, 0, 0);
	at[27] = 7.1500;
	points[28] = (0, 3220, 0);
	angles[28] = (354.9600, 0, 0);
	at[28] = 7.2500;
	points[29] = (0, 3220, 0);
	angles[29] = (359.1591, 0, 0);
	at[29] = 7.4000;
	points[30] = (0, 3220, 0);
	angles[30] = (360, 0, 0);
	at[30] = 7.5000;
	points[31] = (0, 3220, 0);
	angles[31] = (360, 0, 0);
	at[31] = 10;
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
	points[0] = (0, 3220, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 3220, 0);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (0, 3220, 0);
	angles[2] = (0.8410, 0, 0);
	at[2] = 2.6000;
	points[3] = (0, 3220, 0);
	angles[3] = (5.0400, 0, 0);
	at[3] = 2.7500;
	points[4] = (0, 3220, 0);
	angles[4] = (9.5962, 0, 0);
	at[4] = 2.8500;
	points[5] = (0, 3220, 0);
	angles[5] = (18.7200, 0, 0);
	at[5] = 3;
	points[6] = (0, 3220, 0);
	angles[6] = (26.1274, 0, 0);
	at[6] = 3.1000;
	points[7] = (0, 3220, 0);
	angles[7] = (38.8801, 0, 0);
	at[7] = 3.2500;
	points[8] = (0, 3220, 0);
	angles[8] = (63.3601, 0, 0);
	at[8] = 3.5000;
	points[9] = (0, 3220, 0);
	angles[9] = (121.7780, 0, 0);
	at[9] = 4.0500;
	points[10] = (0, 3220, 0);
	angles[10] = (136.5004, 0, 0);
	at[10] = 4.2000;
	points[11] = (0, 3220, 0);
	angles[11] = (149.8234, 0, 0);
	at[11] = 4.3500;
	points[12] = (0, 3220, 0);
	angles[12] = (161.2800, 0, 0);
	at[12] = 4.5000;
	points[13] = (0, 3220, 0);
	angles[13] = (167.6505, 0, 0);
	at[13] = 4.6000;
	points[14] = (0, 3220, 0);
	angles[14] = (174.9600, 0, 0);
	at[14] = 4.7500;
	points[15] = (0, 3220, 0);
	angles[15] = (178.1338, 0, 0);
	at[15] = 4.8500;
	points[16] = (0, 3220, 0);
	angles[16] = (180, 0, 0);
	at[16] = 5;
	points[17] = (0, 3220, 0);
	angles[17] = (180, 0, 0);
	at[17] = 7.5000;
	points[18] = (0, 3220, 0);
	angles[18] = (180.8409, 0, 0);
	at[18] = 7.6000;
	points[19] = (0, 3220, 0);
	angles[19] = (185.0400, 0, 0);
	at[19] = 7.7500;
	points[20] = (0, 3220, 0);
	angles[20] = (189.5962, 0, 0);
	at[20] = 7.8500;
	points[21] = (0, 3220, 0);
	angles[21] = (198.7200, 0, 0);
	at[21] = 8;
	points[22] = (0, 3220, 0);
	angles[22] = (206.1274, 0, 0);
	at[22] = 8.1000;
	points[23] = (0, 3220, 0);
	angles[23] = (218.8801, 0, 0);
	at[23] = 8.2500;
	points[24] = (0, 3220, 0);
	angles[24] = (243.3599, 0, 0);
	at[24] = 8.5000;
	points[25] = (0, 3220, 0);
	angles[25] = (306.8122, 0, 0);
	at[25] = 9.1000;
	points[26] = (0, 3220, 0);
	angles[26] = (321.1200, 0, 0);
	at[26] = 9.2500;
	points[27] = (0, 3220, 0);
	angles[27] = (333.8726, 0, 0);
	at[27] = 9.4000;
	points[28] = (0, 3220, 0);
	angles[28] = (344.6035, 0, 0);
	at[28] = 9.5500;
	points[29] = (0, 3220, 0);
	angles[29] = (352.8461, 0, 0);
	at[29] = 9.7000;
	points[30] = (0, 3220, 0);
	angles[30] = (358.1338, 0, 0);
	at[30] = 9.8500;
	points[31] = (0, 3220, 0);
	angles[31] = (360, 0, 0);
	at[31] = 10;
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
