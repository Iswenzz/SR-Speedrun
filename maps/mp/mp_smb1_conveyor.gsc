main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_conveyor", 0);

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
	ambientPlay("iz_0_st3", 2);
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
	points[0] = (0, -812, -54.8315);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -854, -58.4791);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (0, -812, -54.8315);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (0, -854, -58.4791);
	angles[3] = (0, 0, 0);
	at[3] = 0.3500;
	points[4] = (0, -812, -54.8315);
	angles[4] = (0, 0, 0);
	at[4] = 0.4000;
	points[5] = (0, -854, -58.4791);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (0, -812, -54.8315);
	angles[6] = (0, 0, 0);
	at[6] = 0.6000;
	points[7] = (0, -854, -58.4791);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (0, -812, -54.8315);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (0, -854, -58.4791);
	angles[9] = (0, 0, 0);
	at[9] = 0.9500;
	points[10] = (0, -812, -54.8315);
	angles[10] = (0, 0, 0);
	at[10] = 1;
	points[11] = (0, -854, -58.4791);
	angles[11] = (0, 0, 0);
	at[11] = 1.1500;
	points[12] = (0, -812, -54.8315);
	angles[12] = (0, 0, 0);
	at[12] = 1.2000;
	points[13] = (0, -854, -58.4791);
	angles[13] = (0, 0, 0);
	at[13] = 1.3500;
	points[14] = (0, -812, -54.8315);
	angles[14] = (0, 0, 0);
	at[14] = 1.4000;
	points[15] = (0, -854, -58.4791);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (0, -812, -54.8315);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (0, -854, -58.4791);
	angles[17] = (0, 0, 0);
	at[17] = 1.7500;
	points[18] = (0, -812, -54.8315);
	angles[18] = (0, 0, 0);
	at[18] = 1.8000;
	points[19] = (0, -854, -58.4791);
	angles[19] = (0, 0, 0);
	at[19] = 1.9500;
	points[20] = (0, -812, -54.8315);
	angles[20] = (0, 0, 0);
	at[20] = 2;
	points[21] = (0, -854, -58.4791);
	angles[21] = (0, 0, 0);
	at[21] = 2.1500;
	points[22] = (0, -812, -54.8315);
	angles[22] = (0, 0, 0);
	at[22] = 2.2000;
	points[23] = (0, -854, -58.4791);
	angles[23] = (0, 0, 0);
	at[23] = 2.3500;
	points[24] = (0, -812, -54.8315);
	angles[24] = (0, 0, 0);
	at[24] = 2.4000;
	points[25] = (0, -854, -58.4791);
	angles[25] = (0, 0, 0);
	at[25] = 2.5500;
	points[26] = (0, -812, -54.8315);
	angles[26] = (0, 0, 0);
	at[26] = 2.6000;
	points[27] = (0, -854, -58.4791);
	angles[27] = (0, 0, 0);
	at[27] = 2.7500;
	points[28] = (0, -812, -54.8315);
	angles[28] = (0, 0, 0);
	at[28] = 2.8000;
	points[29] = (0, -854, -58.4791);
	angles[29] = (0, 0, 0);
	at[29] = 2.9500;
	points[30] = (0, -812, -54.8315);
	angles[30] = (0, 0, 0);
	at[30] = 3;
	points[31] = (0, -854, -58.4791);
	angles[31] = (0, 0, 0);
	at[31] = 3.1500;
	points[32] = (0, -812, -54.8315);
	angles[32] = (0, 0, 0);
	at[32] = 3.2000;
	points[33] = (0, -854, -58.4791);
	angles[33] = (0, 0, 0);
	at[33] = 3.3500;
	points[34] = (0, -812, -54.8315);
	angles[34] = (0, 0, 0);
	at[34] = 3.4000;
	points[35] = (0, -854, -58.4791);
	angles[35] = (0, 0, 0);
	at[35] = 3.5500;
	points[36] = (0, -812, -54.8315);
	angles[36] = (0, 0, 0);
	at[36] = 3.6000;
	points[37] = (0, -854, -58.4791);
	angles[37] = (0, 0, 0);
	at[37] = 3.7500;
	points[38] = (0, -812, -54.8315);
	angles[38] = (0, 0, 0);
	at[38] = 3.8000;
	points[39] = (0, -854, -58.4791);
	angles[39] = (0, 0, 0);
	at[39] = 3.9500;
	points[40] = (0, -812, -54.8315);
	angles[40] = (0, 0, 0);
	at[40] = 4;
	points[41] = (0, -854, -58.4791);
	angles[41] = (0, 0, 0);
	at[41] = 4.1500;
	points[42] = (0, -812, -54.8315);
	angles[42] = (0, 0, 0);
	at[42] = 4.2000;
	points[43] = (0, -854, -58.4791);
	angles[43] = (0, 0, 0);
	at[43] = 4.3500;
	points[44] = (0, -812, -54.8315);
	angles[44] = (0, 0, 0);
	at[44] = 4.4000;
	points[45] = (0, -854, -58.4791);
	angles[45] = (0, 0, 0);
	at[45] = 4.5500;
	points[46] = (0, -812, -54.8315);
	angles[46] = (0, 0, 0);
	at[46] = 4.6000;
	points[47] = (0, -854, -58.4791);
	angles[47] = (0, 0, 0);
	at[47] = 4.7500;
	points[48] = (0, -812, -54.8315);
	angles[48] = (0, 0, 0);
	at[48] = 4.8000;
	points[49] = (0, -854, -58.4791);
	angles[49] = (0, 0, 0);
	at[49] = 4.9500;
	points[50] = (0, -812, -54.8315);
	angles[50] = (0, 0, 0);
	at[50] = 5;
	points[51] = (0, -854, -58.4791);
	angles[51] = (0, 0, 0);
	at[51] = 5.1500;
	points[52] = (0, -812, -54.8315);
	angles[52] = (0, 0, 0);
	at[52] = 5.2000;
	points[53] = (0, -854, -58.4791);
	angles[53] = (0, 0, 0);
	at[53] = 5.3500;
	points[54] = (0, -812, -54.8315);
	angles[54] = (0, 0, 0);
	at[54] = 5.4000;
	points[55] = (0, -854, -58.4791);
	angles[55] = (0, 0, 0);
	at[55] = 5.5500;
	points[56] = (0, -812, -54.8315);
	angles[56] = (0, 0, 0);
	at[56] = 5.6000;
	points[57] = (0, -854, -58.4791);
	angles[57] = (0, 0, 0);
	at[57] = 5.7500;
	points[58] = (0, -812, -54.8315);
	angles[58] = (0, 0, 0);
	at[58] = 5.8000;
	points[59] = (0, -854, -58.4791);
	angles[59] = (0, 0, 0);
	at[59] = 5.9500;
	points[60] = (0, -812, -54.8315);
	angles[60] = (0, 0, 0);
	at[60] = 6;
	points[61] = (0, -854, -58.4791);
	angles[61] = (0, 0, 0);
	at[61] = 6.1500;
	points[62] = (0, -812, -54.8315);
	angles[62] = (0, 0, 0);
	at[62] = 6.2000;
	points[63] = (0, -854, -58.4791);
	angles[63] = (0, 0, 0);
	at[63] = 6.3500;
	points[64] = (0, -812, -54.8315);
	angles[64] = (0, 0, 0);
	at[64] = 6.4000;
	points[65] = (0, -854, -58.4791);
	angles[65] = (0, 0, 0);
	at[65] = 6.5500;
	points[66] = (0, -812, -54.8315);
	angles[66] = (0, 0, 0);
	at[66] = 6.6000;
	points[67] = (0, -854, -58.4791);
	angles[67] = (0, 0, 0);
	at[67] = 6.7500;
	points[68] = (0, -812, -54.8315);
	angles[68] = (0, 0, 0);
	at[68] = 6.8000;
	points[69] = (0, -854, -58.4791);
	angles[69] = (0, 0, 0);
	at[69] = 6.9500;
	points[70] = (0, -812, -54.8315);
	angles[70] = (0, 0, 0);
	at[70] = 7;
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
	points[0] = (0, 168, 29.4000);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 210, 33.0474);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (0, 168, 29.4000);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (0, 210, 33.0474);
	angles[3] = (0, 0, 0);
	at[3] = 0.3500;
	points[4] = (0, 168, 29.4000);
	angles[4] = (0, 0, 0);
	at[4] = 0.4000;
	points[5] = (0, 210, 33.0474);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (0, 168, 29.4000);
	angles[6] = (0, 0, 0);
	at[6] = 0.6000;
	points[7] = (0, 210, 33.0474);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (0, 168, 29.4000);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (0, 210, 33.0474);
	angles[9] = (0, 0, 0);
	at[9] = 0.9500;
	points[10] = (0, 168, 29.4000);
	angles[10] = (0, 0, 0);
	at[10] = 1;
	points[11] = (0, 210, 33.0474);
	angles[11] = (0, 0, 0);
	at[11] = 1.1500;
	points[12] = (0, 168, 29.4000);
	angles[12] = (0, 0, 0);
	at[12] = 1.2000;
	points[13] = (0, 210, 33.0474);
	angles[13] = (0, 0, 0);
	at[13] = 1.3500;
	points[14] = (0, 168, 29.4000);
	angles[14] = (0, 0, 0);
	at[14] = 1.4000;
	points[15] = (0, 210, 33.0474);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (0, 168, 29.4000);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (0, 210, 33.0474);
	angles[17] = (0, 0, 0);
	at[17] = 1.7500;
	points[18] = (0, 168, 29.4000);
	angles[18] = (0, 0, 0);
	at[18] = 1.8000;
	points[19] = (0, 210, 33.0474);
	angles[19] = (0, 0, 0);
	at[19] = 1.9500;
	points[20] = (0, 168, 29.4000);
	angles[20] = (0, 0, 0);
	at[20] = 2;
	points[21] = (0, 210, 33.0474);
	angles[21] = (0, 0, 0);
	at[21] = 2.1500;
	points[22] = (0, 168, 29.4000);
	angles[22] = (0, 0, 0);
	at[22] = 2.2000;
	points[23] = (0, 210, 33.0474);
	angles[23] = (0, 0, 0);
	at[23] = 2.3500;
	points[24] = (0, 168, 29.4000);
	angles[24] = (0, 0, 0);
	at[24] = 2.4000;
	points[25] = (0, 210, 33.0474);
	angles[25] = (0, 0, 0);
	at[25] = 2.5500;
	points[26] = (0, 168, 29.4000);
	angles[26] = (0, 0, 0);
	at[26] = 2.6000;
	points[27] = (0, 210, 33.0474);
	angles[27] = (0, 0, 0);
	at[27] = 2.7500;
	points[28] = (0, 168, 29.4000);
	angles[28] = (0, 0, 0);
	at[28] = 2.8000;
	points[29] = (0, 210, 33.0474);
	angles[29] = (0, 0, 0);
	at[29] = 2.9500;
	points[30] = (0, 168, 29.4000);
	angles[30] = (0, 0, 0);
	at[30] = 3;
	points[31] = (0, 210, 33.0474);
	angles[31] = (0, 0, 0);
	at[31] = 3.1500;
	points[32] = (0, 168, 29.4000);
	angles[32] = (0, 0, 0);
	at[32] = 3.2000;
	points[33] = (0, 210, 33.0474);
	angles[33] = (0, 0, 0);
	at[33] = 3.3500;
	points[34] = (0, 168, 29.4000);
	angles[34] = (0, 0, 0);
	at[34] = 3.4000;
	points[35] = (0, 210, 33.0474);
	angles[35] = (0, 0, 0);
	at[35] = 3.5500;
	points[36] = (0, 168, 29.4000);
	angles[36] = (0, 0, 0);
	at[36] = 3.6000;
	points[37] = (0, 210, 33.0474);
	angles[37] = (0, 0, 0);
	at[37] = 3.7500;
	points[38] = (0, 168, 29.4000);
	angles[38] = (0, 0, 0);
	at[38] = 3.8000;
	points[39] = (0, 210, 33.0474);
	angles[39] = (0, 0, 0);
	at[39] = 3.9500;
	points[40] = (0, 168, 29.4000);
	angles[40] = (0, 0, 0);
	at[40] = 4;
	points[41] = (0, 210, 33.0474);
	angles[41] = (0, 0, 0);
	at[41] = 4.1500;
	points[42] = (0, 168, 29.4000);
	angles[42] = (0, 0, 0);
	at[42] = 4.2000;
	points[43] = (0, 210, 33.0474);
	angles[43] = (0, 0, 0);
	at[43] = 4.3500;
	points[44] = (0, 168, 29.4000);
	angles[44] = (0, 0, 0);
	at[44] = 4.4000;
	points[45] = (0, 210, 33.0474);
	angles[45] = (0, 0, 0);
	at[45] = 4.5500;
	points[46] = (0, 168, 29.4000);
	angles[46] = (0, 0, 0);
	at[46] = 4.6000;
	points[47] = (0, 210, 33.0474);
	angles[47] = (0, 0, 0);
	at[47] = 4.7500;
	points[48] = (0, 168, 29.4000);
	angles[48] = (0, 0, 0);
	at[48] = 4.8000;
	points[49] = (0, 210, 33.0474);
	angles[49] = (0, 0, 0);
	at[49] = 4.9500;
	points[50] = (0, 168, 29.4000);
	angles[50] = (0, 0, 0);
	at[50] = 5;
	points[51] = (0, 210, 33.0474);
	angles[51] = (0, 0, 0);
	at[51] = 5.1500;
	points[52] = (0, 168, 29.4000);
	angles[52] = (0, 0, 0);
	at[52] = 5.2000;
	points[53] = (0, 210, 33.0474);
	angles[53] = (0, 0, 0);
	at[53] = 5.3500;
	points[54] = (0, 168, 29.4000);
	angles[54] = (0, 0, 0);
	at[54] = 5.4000;
	points[55] = (0, 210, 33.0474);
	angles[55] = (0, 0, 0);
	at[55] = 5.5500;
	points[56] = (0, 168, 29.4000);
	angles[56] = (0, 0, 0);
	at[56] = 5.6000;
	points[57] = (0, 210, 33.0474);
	angles[57] = (0, 0, 0);
	at[57] = 5.7500;
	points[58] = (0, 168, 29.4000);
	angles[58] = (0, 0, 0);
	at[58] = 5.8000;
	points[59] = (0, 210, 33.0474);
	angles[59] = (0, 0, 0);
	at[59] = 5.9500;
	points[60] = (0, 168, 29.4000);
	angles[60] = (0, 0, 0);
	at[60] = 6;
	points[61] = (0, 210, 33.0474);
	angles[61] = (0, 0, 0);
	at[61] = 6.1500;
	points[62] = (0, 168, 29.4000);
	angles[62] = (0, 0, 0);
	at[62] = 6.2000;
	points[63] = (0, 210, 33.0474);
	angles[63] = (0, 0, 0);
	at[63] = 6.3500;
	points[64] = (0, 168, 29.4000);
	angles[64] = (0, 0, 0);
	at[64] = 6.4000;
	points[65] = (0, 210, 33.0474);
	angles[65] = (0, 0, 0);
	at[65] = 6.5500;
	points[66] = (0, 168, 29.4000);
	angles[66] = (0, 0, 0);
	at[66] = 6.6000;
	points[67] = (0, 210, 33.0474);
	angles[67] = (0, 0, 0);
	at[67] = 6.7500;
	points[68] = (0, 168, 29.4000);
	angles[68] = (0, 0, 0);
	at[68] = 6.8000;
	points[69] = (0, 210, 33.0474);
	angles[69] = (0, 0, 0);
	at[69] = 6.9500;
	points[70] = (0, 168, 29.4000);
	angles[70] = (0, 0, 0);
	at[70] = 7;
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
