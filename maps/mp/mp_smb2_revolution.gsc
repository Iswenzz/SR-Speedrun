main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_revolution", 0);

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
	points[0] = (0, -350, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -350, 0);
	angles[1] = (0.0742, 0, 0);
	at[1] = 1.0500;
	points[2] = (0, -350, 0);
	angles[2] = (1.7708, 0, 0);
	at[2] = 1.2500;
	points[3] = (0, -350, 0);
	angles[3] = (5.4675, 0, 0);
	at[3] = 1.4500;
	points[4] = (0, -350, 0);
	angles[4] = (12.4133, 0, 0);
	at[4] = 1.7000;
	points[5] = (0, -350, 0);
	angles[5] = (21.3592, 0, 0);
	at[5] = 1.9500;
	points[6] = (0, -350, 0);
	angles[6] = (31.6800, 0, 0);
	at[6] = 2.2000;
	points[7] = (0, -350, 0);
	angles[7] = (60.4642, 0, 0);
	at[7] = 2.8500;
	points[8] = (0, -350, 0);
	angles[8] = (72.4192, 0, 0);
	at[8] = 3.1500;
	points[9] = (0, -350, 0);
	angles[9] = (82.0341, 0, 0);
	at[9] = 3.4500;
	points[10] = (0, -350, 0);
	angles[10] = (88.2292, 0, 0);
	at[10] = 3.7500;
	points[11] = (0, -350, 0);
	angles[11] = (90, 0, 0);
	at[11] = 4;
	points[12] = (0, -350, 0);
	angles[12] = (90.0741, 0, 0);
	at[12] = 6.0500;
	points[13] = (0, -350, 0);
	angles[13] = (91.1467, 0, 0);
	at[13] = 6.2000;
	points[14] = (0, -350, 0);
	angles[14] = (94.3734, 0, 0);
	at[14] = 6.4000;
	points[15] = (0, -350, 0);
	angles[15] = (100.8442, 0, 0);
	at[15] = 6.6500;
	points[16] = (0, -350, 0);
	angles[16] = (111.3591, 0, 0);
	at[16] = 6.9500;
	points[17] = (0, -350, 0);
	angles[17] = (121.6799, 0, 0);
	at[17] = 7.2000;
	points[18] = (0, -350, 0);
	angles[18] = (150.4642, 0, 0);
	at[18] = 7.8500;
	points[19] = (0, -350, 0);
	angles[19] = (162.4191, 0, 0);
	at[19] = 8.1500;
	points[20] = (0, -350, 0);
	angles[20] = (170.6400, 0, 0);
	at[20] = 8.4000;
	points[21] = (0, -350, 0);
	angles[21] = (176.6108, 0, 0);
	at[21] = 8.6500;
	points[22] = (0, -350, 0);
	angles[22] = (178.8533, 0, 0);
	at[22] = 8.8000;
	points[23] = (0, -350, 0);
	angles[23] = (179.9258, 0, 0);
	at[23] = 8.9500;
	points[24] = (0, -350, 0);
	angles[24] = (180, 0, 0);
	at[24] = 11;
	points[25] = (0, -350, 0);
	angles[25] = (180.6525, 0, 0);
	at[25] = 11.1500;
	points[26] = (0, -350, 0);
	angles[26] = (182.5200, 0, 0);
	at[26] = 11.3000;
	points[27] = (0, -350, 0);
	angles[27] = (187.9659, 0, 0);
	at[27] = 11.5500;
	points[28] = (0, -350, 0);
	angles[28] = (197.5809, 0, 0);
	at[28] = 11.8500;
	points[29] = (0, -350, 0);
	angles[29] = (209.5358, 0, 0);
	at[29] = 12.1500;
	points[30] = (0, -350, 0);
	angles[30] = (238.3201, 0, 0);
	at[30] = 12.8000;
	points[31] = (0, -350, 0);
	angles[31] = (248.6409, 0, 0);
	at[31] = 13.0500;
	points[32] = (0, -350, 0);
	angles[32] = (259.1558, 0, 0);
	at[32] = 13.3500;
	points[33] = (0, -350, 0);
	angles[33] = (265.6266, 0, 0);
	at[33] = 13.6000;
	points[34] = (0, -350, 0);
	angles[34] = (268.8533, 0, 0);
	at[34] = 13.8000;
	points[35] = (0, -350, 0);
	angles[35] = (269.9259, 0, 0);
	at[35] = 13.9500;
	points[36] = (0, -350, 0);
	angles[36] = (270, 0, 0);
	at[36] = 16;
	points[37] = (0, -350, 0);
	angles[37] = (271.7709, 0, 0);
	at[37] = 16.2500;
	points[38] = (0, -350, 0);
	angles[38] = (277.9659, 0, 0);
	at[38] = 16.5500;
	points[39] = (0, -350, 0);
	angles[39] = (287.5808, 0, 0);
	at[39] = 16.8500;
	points[40] = (0, -350, 0);
	angles[40] = (299.5358, 0, 0);
	at[40] = 17.1500;
	points[41] = (0, -350, 0);
	angles[41] = (328.3200, 0, 0);
	at[41] = 17.8000;
	points[42] = (0, -350, 0);
	angles[42] = (338.6407, 0, 0);
	at[42] = 18.0500;
	points[43] = (0, -350, 0);
	angles[43] = (347.5867, 0, 0);
	at[43] = 18.3000;
	points[44] = (0, -350, 0);
	angles[44] = (354.5325, 0, 0);
	at[44] = 18.5500;
	points[45] = (0, -350, 0);
	angles[45] = (358.2291, 0, 0);
	at[45] = 18.7500;
	points[46] = (0, -350, 0);
	angles[46] = (359.9258, 0, 0);
	at[46] = 18.9500;
	points[47] = (0, -350, 0);
	angles[47] = (360, 0, 0);
	at[47] = 20;
	mover = getEnt("iz_mover0", "targetname");
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
