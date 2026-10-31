main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_narrow_bridge", 0);

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
	points[0] = (-0.0049, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-0.0049, 0, 0);
	angles[1] = (0, -1.3994, 0);
	at[1] = 1;
	points[2] = (-0.0049, 0, 0);
	angles[2] = (0, -5.6883, 0);
	at[2] = 2.1000;
	points[3] = (-0.0049, 0, 0);
	angles[3] = (0, -13.7468, 0);
	at[3] = 3.4500;
	points[4] = (-0.0049, 0, 0);
	angles[4] = (0, -34.1791, 0);
	at[4] = 6.2500;
	points[5] = (-0.0049, 0, 0);
	angles[5] = (0, -42.1869, 0);
	at[5] = 7.5000;
	points[6] = (-0.0049, 0, 0);
	angles[6] = (0, -48.0122, 0);
	at[6] = 8.8000;
	points[7] = (-0.0049, 0, 0);
	angles[7] = (0, -50, 0);
	at[7] = 10;
	points[8] = (-0.0049, 0, 0);
	angles[8] = (0, -48.0122, 0);
	at[8] = 11.2000;
	points[9] = (-0.0049, 0, 0);
	angles[9] = (0, -42.1869, 0);
	at[9] = 12.5000;
	points[10] = (-0.0049, 0, 0);
	angles[10] = (0, -34.1791, 0);
	at[10] = 13.7500;
	points[11] = (-0.0049, 0, 0);
	angles[11] = (0, -13.7468, 0);
	at[11] = 16.5500;
	points[12] = (-0.0049, 0, 0);
	angles[12] = (0, -5.6883, 0);
	at[12] = 17.9000;
	points[13] = (-0.0049, 0, 0);
	angles[13] = (0, -1.3994, 0);
	at[13] = 19;
	points[14] = (-0.0049, 0, 0);
	angles[14] = (0, 0, 0);
	at[14] = 20;
	points[15] = (-0.0049, 0, 0);
	angles[15] = (0, -1.5374, 0);
	at[15] = 21.0500;
	points[16] = (-0.0049, 0, 0);
	angles[16] = (0, -6.1946, 0);
	at[16] = 22.2000;
	points[17] = (-0.0049, 0, 0);
	angles[17] = (0, -14.0869, 0);
	at[17] = 23.5000;
	points[18] = (-0.0049, 0, 0);
	angles[18] = (0, -33.8266, 0);
	at[18] = 26.2000;
	points[19] = (-0.0049, 0, 0);
	angles[19] = (0, -41.6171, 0);
	at[19] = 27.4000;
	points[20] = (-0.0049, 0, 0);
	angles[20] = (0, -47.5117, 0);
	at[20] = 28.6500;
	points[21] = (-0.0049, 0, 0);
	angles[21] = (0, -49.9072, 0);
	at[21] = 29.7500;
	points[22] = (-0.0049, 0, 0);
	angles[22] = (0, -48.9771, 0);
	at[22] = 30.8500;
	points[23] = (-0.0049, 0, 0);
	angles[23] = (0, -44.5571, 0);
	at[23] = 32.0500;
	points[24] = (-0.0049, 0, 0);
	angles[24] = (0, -36.5898, 0);
	at[24] = 33.4000;
	points[25] = (-0.0049, 0, 0);
	angles[25] = (0, -15.8197, 0);
	at[25] = 36.2500;
	points[26] = (-0.0049, 0, 0);
	angles[26] = (0, -7.8119, 0);
	at[26] = 37.5000;
	points[27] = (-0.0049, 0, 0);
	angles[27] = (0, -1.9866, 0);
	at[27] = 38.8000;
	points[28] = (-0.0049, 0, 0);
	angles[28] = (0, 0, 0);
	at[28] = 40;
	points[29] = (-0.0049, 0, 0);
	angles[29] = (0, -1.5374, 0);
	at[29] = 41.0500;
	points[30] = (-0.0049, 0, 0);
	angles[30] = (0, -6.4541, 0);
	at[30] = 42.2500;
	points[31] = (-0.0049, 0, 0);
	angles[31] = (0, -14.4292, 0);
	at[31] = 43.5500;
	points[32] = (-0.0049, 0, 0);
	angles[32] = (0, -33.1163, 0);
	at[32] = 46.1000;
	points[33] = (-0.0049, 0, 0);
	angles[33] = (0, -40.4345, 0);
	at[33] = 47.2000;
	points[34] = (-0.0049, 0, 0);
	angles[34] = (0, -46.3649, 0);
	at[34] = 48.3500;
	points[35] = (-0.0049, 0, 0);
	angles[35] = (0, -49.4810, 0);
	at[35] = 49.4000;
	points[36] = (-0.0049, 0, 0);
	angles[36] = (0, -50, 0);
	at[36] = 50;
	points[37] = (-0.0049, 0, 0);
	angles[37] = (0, -49.4810, 0);
	at[37] = 50.6000;
	points[38] = (-0.0049, 0, 0);
	angles[38] = (0, -47.8510, 0);
	at[38] = 51.2500;
	points[39] = (-0.0049, 0, 0);
	angles[39] = (0, -45.0372, 0);
	at[39] = 51.9500;
	points[40] = (-0.0049, 0, 0);
	angles[40] = (0, -36.5898, 0);
	at[40] = 53.4000;
	points[41] = (-0.0049, 0, 0);
	angles[41] = (0, -15.8197, 0);
	at[41] = 56.2500;
	points[42] = (-0.0049, 0, 0);
	angles[42] = (0, -7.8119, 0);
	at[42] = 57.5000;
	points[43] = (-0.0049, 0, 0);
	angles[43] = (0, -1.9866, 0);
	at[43] = 58.8000;
	points[44] = (-0.0049, 0, 0);
	angles[44] = (0, 0, 0);
	at[44] = 60;
	points[45] = (-0.0049, 0, 0);
	angles[45] = (0, -1.9866, 0);
	at[45] = 61.2000;
	points[46] = (-0.0049, 0, 0);
	angles[46] = (0, -7.8119, 0);
	at[46] = 62.5000;
	points[47] = (-0.0049, 0, 0);
	angles[47] = (0, -15.8197, 0);
	at[47] = 63.7500;
	points[48] = (-0.0049, 0, 0);
	angles[48] = (0, -36.5898, 0);
	at[48] = 66.6000;
	points[49] = (-0.0049, 0, 0);
	angles[49] = (0, -44.7993, 0);
	at[49] = 68;
	points[50] = (-0.0049, 0, 0);
	angles[50] = (0, -49.1978, 0);
	at[50] = 69.2500;
	points[51] = (-0.0049, 0, 0);
	angles[51] = (0, -49.8200, 0);
	at[51] = 70.3500;
	points[52] = (-0.0049, 0, 0);
	angles[52] = (0, -47.1505, 0);
	at[52] = 71.4500;
	points[53] = (-0.0049, 0, 0);
	angles[53] = (0, -41.3266, 0);
	at[53] = 72.6500;
	points[54] = (-0.0049, 0, 0);
	angles[54] = (0, -33.8266, 0);
	at[54] = 73.8000;
	points[55] = (-0.0049, 0, 0);
	angles[55] = (0, -14.0869, 0);
	at[55] = 76.5000;
	points[56] = (-0.0049, 0, 0);
	angles[56] = (0, -6.1946, 0);
	at[56] = 77.8000;
	points[57] = (-0.0049, 0, 0);
	angles[57] = (0, -1.5374, 0);
	at[57] = 78.9500;
	points[58] = (-0.0049, 0, 0);
	angles[58] = (0, 0, 0);
	at[58] = 80;
	points[59] = (-0.0049, 0, 0);
	angles[59] = (0, -1.9866, 0);
	at[59] = 81.2000;
	points[60] = (-0.0049, 0, 0);
	angles[60] = (0, -7.8119, 0);
	at[60] = 82.5000;
	points[61] = (-0.0049, 0, 0);
	angles[61] = (0, -15.8197, 0);
	at[61] = 83.7500;
	points[62] = (-0.0049, 0, 0);
	angles[62] = (0, -36.5898, 0);
	at[62] = 86.6000;
	points[63] = (-0.0049, 0, 0);
	angles[63] = (0, -44.5571, 0);
	at[63] = 87.9500;
	points[64] = (-0.0049, 0, 0);
	angles[64] = (0, -48.9771, 0);
	at[64] = 89.1500;
	points[65] = (-0.0049, 0, 0);
	angles[65] = (0, -49.9402, 0);
	at[65] = 90.2000;
	points[66] = (-0.0049, 0, 0);
	angles[66] = (0, -47.5117, 0);
	at[66] = 91.3500;
	points[67] = (-0.0049, 0, 0);
	angles[67] = (0, -41.6171, 0);
	at[67] = 92.6000;
	points[68] = (-0.0049, 0, 0);
	angles[68] = (0, -33.8266, 0);
	at[68] = 93.8000;
	points[69] = (-0.0049, 0, 0);
	angles[69] = (0, -13.7468, 0);
	at[69] = 96.5500;
	points[70] = (-0.0049, 0, 0);
	angles[70] = (0, -5.9393, 0);
	at[70] = 97.8500;
	points[71] = (-0.0049, 0, 0);
	angles[71] = (0, -1.5374, 0);
	at[71] = 98.9500;
	points[72] = (-0.0049, 0, 0);
	angles[72] = (0, 0, 0);
	at[72] = 100;
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
