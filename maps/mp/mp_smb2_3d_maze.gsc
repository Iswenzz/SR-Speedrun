main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_3d_maze", 0);

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
	points[0] = (-0.0013, -6020, -35);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-0.0013, -6020, -35);
	angles[1] = (-0.8018, 0, 0);
	at[1] = 0.5500;
	points[2] = (-0.0013, -6020, -35);
	angles[2] = (-3.4339, 0, 0);
	at[2] = 1.1500;
	points[3] = (-0.0013, -6020, -35);
	angles[3] = (-7.7864, 0, 0);
	at[3] = 1.7500;
	points[4] = (-0.0013, -6020, -35);
	angles[4] = (-13.7428, 0, 0);
	at[4] = 2.3500;
	points[5] = (-0.0013, -6020, -35);
	angles[5] = (-21.8700, 0, 0);
	at[5] = 3;
	points[6] = (-0.0013, -6020, -35);
	angles[6] = (-31.5944, 0, 0);
	at[6] = 3.6500;
	points[7] = (-0.0013, -6020, -35);
	angles[7] = (-42.7673, 0, 0);
	at[7] = 4.3000;
	points[8] = (-0.0013, -6020, -35);
	angles[8] = (-56.2500, 0, 0);
	at[8] = 5;
	points[9] = (-0.0013, -6020, -35);
	angles[9] = (-81.1859, 0, 0);
	at[9] = 6.1500;
	points[10] = (-0.0013, -6020, -35);
	angles[10] = (-112.6423, 0, 0);
	at[10] = 7.4500;
	points[11] = (-0.0013, -6020, -35);
	angles[11] = (-145.0977, 0, 0);
	at[11] = 8.7000;
	points[12] = (-0.0013, -6020, -35);
	angles[12] = (-225.4579, 0, 0);
	at[12] = 11.7000;
	points[13] = (-0.0013, -6020, -35);
	angles[13] = (-262.2370, 0, 0);
	at[13] = 13.1500;
	points[14] = (-0.0013, -6020, -35);
	angles[14] = (-293.2988, 0, 0);
	at[14] = 14.5000;
	points[15] = (-0.0013, -6020, -35);
	angles[15] = (-306.7568, 0, 0);
	at[15] = 15.1500;
	points[16] = (-0.0013, -6020, -35);
	angles[16] = (-318.1401, 0, 0);
	at[16] = 15.7500;
	points[17] = (-0.0013, -6020, -35);
	angles[17] = (-328.4056, 0, 0);
	at[17] = 16.3500;
	points[18] = (-0.0013, -6020, -35);
	angles[18] = (-336.7341, 0, 0);
	at[18] = 16.9000;
	points[19] = (-0.0013, -6020, -35);
	angles[19] = (-343.9357, 0, 0);
	at[19] = 17.4500;
	points[20] = (-0.0013, -6020, -35);
	angles[20] = (-349.4286, 0, 0);
	at[20] = 17.9500;
	points[21] = (-0.0013, -6020, -35);
	angles[21] = (-354.2287, 0, 0);
	at[21] = 18.5000;
	points[22] = (-0.0013, -6020, -35);
	angles[22] = (-357.3900, 0, 0);
	at[22] = 19;
	points[23] = (-0.0013, -6020, -35);
	angles[23] = (-359.3363, 0, 0);
	at[23] = 19.5000;
	points[24] = (-0.0013, -6020, -35);
	angles[24] = (-360, 0, 0);
	at[24] = 20;
	points[25] = (-0.0013, -6020, -35);
	angles[25] = (-359.3362, 0, 0);
	at[25] = 20.5000;
	points[26] = (-0.0013, -6020, -35);
	angles[26] = (-357.3900, 0, 0);
	at[26] = 21;
	points[27] = (-0.0013, -6020, -35);
	angles[27] = (-354.2288, 0, 0);
	at[27] = 21.5000;
	points[28] = (-0.0013, -6020, -35);
	angles[28] = (-349.4286, 0, 0);
	at[28] = 22.0500;
	points[29] = (-0.0013, -6020, -35);
	angles[29] = (-343.9355, 0, 0);
	at[29] = 22.5500;
	points[30] = (-0.0013, -6020, -35);
	angles[30] = (-336.7343, 0, 0);
	at[30] = 23.1000;
	points[31] = (-0.0013, -6020, -35);
	angles[31] = (-328.4058, 0, 0);
	at[31] = 23.6500;
	points[32] = (-0.0013, -6020, -35);
	angles[32] = (-318.1401, 0, 0);
	at[32] = 24.2500;
	points[33] = (-0.0013, -6020, -35);
	angles[33] = (-306.7568, 0, 0);
	at[33] = 24.8500;
	points[34] = (-0.0013, -6020, -35);
	angles[34] = (-293.2988, 0, 0);
	at[34] = 25.5000;
	points[35] = (-0.0013, -6020, -35);
	angles[35] = (-262.2370, 0, 0);
	at[35] = 26.8500;
	points[36] = (-0.0013, -6020, -35);
	angles[36] = (-224.1456, 0, 0);
	at[36] = 28.3500;
	points[37] = (-0.0013, -6020, -35);
	angles[37] = (-145.0978, 0, 0);
	at[37] = 31.3000;
	points[38] = (-0.0013, -6020, -35);
	angles[38] = (-112.6423, 0, 0);
	at[38] = 32.5500;
	points[39] = (-0.0013, -6020, -35);
	angles[39] = (-81.1861, 0, 0);
	at[39] = 33.8500;
	points[40] = (-0.0013, -6020, -35);
	angles[40] = (-56.2500, 0, 0);
	at[40] = 35;
	points[41] = (-0.0013, -6020, -35);
	angles[41] = (-42.7673, 0, 0);
	at[41] = 35.7000;
	points[42] = (-0.0013, -6020, -35);
	angles[42] = (-31.5943, 0, 0);
	at[42] = 36.3500;
	points[43] = (-0.0013, -6020, -35);
	angles[43] = (-21.8700, 0, 0);
	at[43] = 37;
	points[44] = (-0.0013, -6020, -35);
	angles[44] = (-13.7428, 0, 0);
	at[44] = 37.6500;
	points[45] = (-0.0013, -6020, -35);
	angles[45] = (-7.7865, 0, 0);
	at[45] = 38.2500;
	points[46] = (-0.0013, -6020, -35);
	angles[46] = (-3.4339, 0, 0);
	at[46] = 38.8500;
	points[47] = (-0.0013, -6020, -35);
	angles[47] = (-0.8018, 0, 0);
	at[47] = 39.4500;
	points[48] = (-0.0013, -6020, -35);
	angles[48] = (0, 0, 0);
	at[48] = 40;
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
