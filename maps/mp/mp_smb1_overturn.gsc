main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_overturn", 0);

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
	ambientPlay("iz_0_st1", 2);
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
	points[0] = (0, -875, -10.5000);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -875, -10.5000);
	angles[1] = (0.6638, 0, 0);
	at[1] = 0.2500;
	points[2] = (0, -875, -10.5000);
	angles[2] = (2.6100, 0, 0);
	at[2] = 0.5000;
	points[3] = (0, -875, -10.5000);
	angles[3] = (5.7713, 0, 0);
	at[3] = 0.7500;
	points[4] = (0, -875, -10.5000);
	angles[4] = (10.0800, 0, 0);
	at[4] = 1;
	points[5] = (0, -875, -10.5000);
	angles[5] = (15.4688, 0, 0);
	at[5] = 1.2500;
	points[6] = (0, -875, -10.5000);
	angles[6] = (23.2658, 0, 0);
	at[6] = 1.5500;
	points[7] = (0, -875, -10.5000);
	angles[7] = (30.7930, 0, 0);
	at[7] = 1.8000;
	points[8] = (0, -875, -10.5000);
	angles[8] = (40.9601, 0, 0);
	at[8] = 2.1000;
	points[9] = (0, -875, -10.5000);
	angles[9] = (52.2547, 0, 0);
	at[9] = 2.4000;
	points[10] = (0, -875, -10.5000);
	angles[10] = (66.7012, 0, 0);
	at[10] = 2.7500;
	points[11] = (0, -875, -10.5000);
	angles[11] = (82.3384, 0, 0);
	at[11] = 3.1000;
	points[12] = (0, -875, -10.5000);
	angles[12] = (98.9811, 0, 0);
	at[12] = 3.4500;
	points[13] = (0, -875, -10.5000);
	angles[13] = (137.1686, 0, 0);
	at[13] = 4.2000;
	points[14] = (0, -875, -10.5000);
	angles[14] = (214.9023, 0, 0);
	at[14] = 5.6500;
	points[15] = (0, -875, -10.5000);
	angles[15] = (246.0937, 0, 0);
	at[15] = 6.2500;
	points[16] = (0, -875, -10.5000);
	angles[16] = (277.6616, 0, 0);
	at[16] = 6.9000;
	points[17] = (0, -875, -10.5000);
	angles[17] = (303.7500, 0, 0);
	at[17] = 7.5000;
	points[18] = (0, -875, -10.5000);
	angles[18] = (317.2326, 0, 0);
	at[18] = 7.8500;
	points[19] = (0, -875, -10.5000);
	angles[19] = (327.5959, 0, 0);
	at[19] = 8.1500;
	points[20] = (0, -875, -10.5000);
	angles[20] = (338.1300, 0, 0);
	at[20] = 8.5000;
	points[21] = (0, -875, -10.5000);
	angles[21] = (345.6921, 0, 0);
	at[21] = 8.8000;
	points[22] = (0, -875, -10.5000);
	angles[22] = (351.7769, 0, 0);
	at[22] = 9.1000;
	points[23] = (0, -875, -10.5000);
	angles[23] = (356.2676, 0, 0);
	at[23] = 9.4000;
	points[24] = (0, -875, -10.5000);
	angles[24] = (359.0475, 0, 0);
	at[24] = 9.7000;
	points[25] = (0, -875, -10.5000);
	angles[25] = (360, 0, 0);
	at[25] = 10;
	points[26] = (0, -875, -10.5000);
	angles[26] = (359.3362, 0, 0);
	at[26] = 10.2500;
	points[27] = (0, -875, -10.5000);
	angles[27] = (357.3900, 0, 0);
	at[27] = 10.5000;
	points[28] = (0, -875, -10.5000);
	angles[28] = (354.2288, 0, 0);
	at[28] = 10.7500;
	points[29] = (0, -875, -10.5000);
	angles[29] = (349.9200, 0, 0);
	at[29] = 11;
	points[30] = (0, -875, -10.5000);
	angles[30] = (344.5312, 0, 0);
	at[30] = 11.2500;
	points[31] = (0, -875, -10.5000);
	angles[31] = (336.7341, 0, 0);
	at[31] = 11.5500;
	points[32] = (0, -875, -10.5000);
	angles[32] = (329.2070, 0, 0);
	at[32] = 11.8000;
	points[33] = (0, -875, -10.5000);
	angles[33] = (319.0399, 0, 0);
	at[33] = 12.1000;
	points[34] = (0, -875, -10.5000);
	angles[34] = (307.7453, 0, 0);
	at[34] = 12.4000;
	points[35] = (0, -875, -10.5000);
	angles[35] = (293.2988, 0, 0);
	at[35] = 12.7500;
	points[36] = (0, -875, -10.5000);
	angles[36] = (277.6614, 0, 0);
	at[36] = 13.1000;
	points[37] = (0, -875, -10.5000);
	angles[37] = (261.0189, 0, 0);
	at[37] = 13.4500;
	points[38] = (0, -875, -10.5000);
	angles[38] = (222.8314, 0, 0);
	at[38] = 14.2000;
	points[39] = (0, -875, -10.5000);
	angles[39] = (145.0977, 0, 0);
	at[39] = 15.6500;
	points[40] = (0, -875, -10.5000);
	angles[40] = (113.9063, 0, 0);
	at[40] = 16.2500;
	points[41] = (0, -875, -10.5000);
	angles[41] = (82.3386, 0, 0);
	at[41] = 16.9000;
	points[42] = (0, -875, -10.5000);
	angles[42] = (56.2500, 0, 0);
	at[42] = 17.5000;
	points[43] = (0, -875, -10.5000);
	angles[43] = (42.7673, 0, 0);
	at[43] = 17.8500;
	points[44] = (0, -875, -10.5000);
	angles[44] = (32.4041, 0, 0);
	at[44] = 18.1500;
	points[45] = (0, -875, -10.5000);
	angles[45] = (21.8700, 0, 0);
	at[45] = 18.5000;
	points[46] = (0, -875, -10.5000);
	angles[46] = (14.3078, 0, 0);
	at[46] = 18.8000;
	points[47] = (0, -875, -10.5000);
	angles[47] = (8.2231, 0, 0);
	at[47] = 19.1000;
	points[48] = (0, -875, -10.5000);
	angles[48] = (3.7324, 0, 0);
	at[48] = 19.4000;
	points[49] = (0, -875, -10.5000);
	angles[49] = (0.9525, 0, 0);
	at[49] = 19.7000;
	points[50] = (0, -875, -10.5000);
	angles[50] = (0, 0, 0);
	at[50] = 20;
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
