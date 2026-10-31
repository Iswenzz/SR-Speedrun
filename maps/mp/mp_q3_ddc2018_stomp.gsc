main()
{
	thread iz_sounds();

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
	iz_emitter("iz_0_chicklenz", (9840, -8704, -672), 0, 26.9844);
	iz_emitter("iz_1_lava31", (1488, -19008, -6368), 0, 2.5239);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
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
	thread iz_q3_mover0();
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-320, -3136, 432);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-320, -3136, 568.5630);
	angles[1] = (0, 0, 0);
	at[1] = 0.0312;
	points[2] = (-320, -3136, 635.2008);
	angles[2] = (0, 0, 0);
	at[2] = 0.0469;
	points[3] = (-320, -3136, 699.8779);
	angles[3] = (0, 0, 0);
	at[3] = 0.0625;
	points[4] = (-320, -3136, 761.9764);
	angles[4] = (0, 0, 0);
	at[4] = 0.0781;
	points[5] = (-320, -3136, 820.8976);
	angles[5] = (0, 0, 0);
	at[5] = 0.0938;
	points[6] = (-320, -3136, 876.0748);
	angles[6] = (0, 0, 0);
	at[6] = 0.1094;
	points[7] = (-320, -3136, 926.9764);
	angles[7] = (0, 0, 0);
	at[7] = 0.1250;
	points[8] = (-320, -3136, 973.1063);
	angles[8] = (0, 0, 0);
	at[8] = 0.1406;
	points[9] = (-320, -3136, 1014.0276);
	angles[9] = (0, 0, 0);
	at[9] = 0.1562;
	points[10] = (-320, -3136, 1049.3464);
	angles[10] = (0, 0, 0);
	at[10] = 0.1719;
	points[11] = (-320, -3136, 1078.7166);
	angles[11] = (0, 0, 0);
	at[11] = 0.1875;
	points[12] = (-320, -3136, 1101.8583);
	angles[12] = (0, 0, 0);
	at[12] = 0.2031;
	points[13] = (-320, -3136, 1118.5511);
	angles[13] = (0, 0, 0);
	at[13] = 0.2188;
	points[14] = (-320, -3136, 1128.6299);
	angles[14] = (0, 0, 0);
	at[14] = 0.2344;
	points[15] = (-320, -3136, 1132);
	angles[15] = (0, 0, 0);
	at[15] = 0.2500;
	points[16] = (-320, -3136, 1128.6299);
	angles[16] = (0, 0, 0);
	at[16] = 0.2656;
	points[17] = (-320, -3136, 1118.5511);
	angles[17] = (0, 0, 0);
	at[17] = 0.2812;
	points[18] = (-320, -3136, 1101.8583);
	angles[18] = (0, 0, 0);
	at[18] = 0.2969;
	points[19] = (-320, -3136, 1078.7166);
	angles[19] = (0, 0, 0);
	at[19] = 0.3125;
	points[20] = (-320, -3136, 1049.3464);
	angles[20] = (0, 0, 0);
	at[20] = 0.3281;
	points[21] = (-320, -3136, 1014.0276);
	angles[21] = (0, 0, 0);
	at[21] = 0.3438;
	points[22] = (-320, -3136, 973.1063);
	angles[22] = (0, 0, 0);
	at[22] = 0.3594;
	points[23] = (-320, -3136, 926.9764);
	angles[23] = (0, 0, 0);
	at[23] = 0.3750;
	points[24] = (-320, -3136, 876.0748);
	angles[24] = (0, 0, 0);
	at[24] = 0.3906;
	points[25] = (-320, -3136, 820.8976);
	angles[25] = (0, 0, 0);
	at[25] = 0.4062;
	points[26] = (-320, -3136, 761.9764);
	angles[26] = (0, 0, 0);
	at[26] = 0.4219;
	points[27] = (-320, -3136, 699.8779);
	angles[27] = (0, 0, 0);
	at[27] = 0.4375;
	points[28] = (-320, -3136, 635.2008);
	angles[28] = (0, 0, 0);
	at[28] = 0.4531;
	points[29] = (-320, -3136, 568.5630);
	angles[29] = (0, 0, 0);
	at[29] = 0.4688;
	points[30] = (-320, -3136, 363.3878);
	angles[30] = (0, 0, 0);
	at[30] = 0.5156;
	points[31] = (-320, -3136, 295.4366);
	angles[31] = (0, 0, 0);
	at[31] = 0.5312;
	points[32] = (-320, -3136, 228.8008);
	angles[32] = (0, 0, 0);
	at[32] = 0.5469;
	points[33] = (-320, -3136, 164.1217);
	angles[33] = (0, 0, 0);
	at[33] = 0.5625;
	points[34] = (-320, -3136, 102.0224);
	angles[34] = (0, 0, 0);
	at[34] = 0.5781;
	points[35] = (-320, -3136, 43.1008);
	angles[35] = (0, 0, 0);
	at[35] = 0.5938;
	points[36] = (-320, -3136, -12.0754);
	angles[36] = (0, 0, 0);
	at[36] = 0.6094;
	points[37] = (-320, -3136, -62.9748);
	angles[37] = (0, 0, 0);
	at[37] = 0.6250;
	points[38] = (-320, -3136, -109.1075);
	angles[38] = (0, 0, 0);
	at[38] = 0.6406;
	points[39] = (-320, -3136, -150.0287);
	angles[39] = (0, 0, 0);
	at[39] = 0.6562;
	points[40] = (-320, -3136, -185.3449);
	angles[40] = (0, 0, 0);
	at[40] = 0.6719;
	points[41] = (-320, -3136, -214.7158);
	angles[41] = (0, 0, 0);
	at[41] = 0.6875;
	points[42] = (-320, -3136, -237.8583);
	angles[42] = (0, 0, 0);
	at[42] = 0.7031;
	points[43] = (-320, -3136, -254.5496);
	angles[43] = (0, 0, 0);
	at[43] = 0.7188;
	points[44] = (-320, -3136, -264.6295);
	angles[44] = (0, 0, 0);
	at[44] = 0.7344;
	points[45] = (-320, -3136, -268);
	angles[45] = (0, 0, 0);
	at[45] = 0.7500;
	points[46] = (-320, -3136, -264.6295);
	angles[46] = (0, 0, 0);
	at[46] = 0.7656;
	points[47] = (-320, -3136, -254.5496);
	angles[47] = (0, 0, 0);
	at[47] = 0.7812;
	points[48] = (-320, -3136, -237.8583);
	angles[48] = (0, 0, 0);
	at[48] = 0.7969;
	points[49] = (-320, -3136, -214.7158);
	angles[49] = (0, 0, 0);
	at[49] = 0.8125;
	points[50] = (-320, -3136, -185.3449);
	angles[50] = (0, 0, 0);
	at[50] = 0.8281;
	points[51] = (-320, -3136, -150.0287);
	angles[51] = (0, 0, 0);
	at[51] = 0.8438;
	points[52] = (-320, -3136, -109.1075);
	angles[52] = (0, 0, 0);
	at[52] = 0.8594;
	points[53] = (-320, -3136, -62.9744);
	angles[53] = (0, 0, 0);
	at[53] = 0.8750;
	points[54] = (-320, -3136, -12.0752);
	angles[54] = (0, 0, 0);
	at[54] = 0.8906;
	points[55] = (-320, -3136, 43.1008);
	angles[55] = (0, 0, 0);
	at[55] = 0.9062;
	points[56] = (-320, -3136, 102.0224);
	angles[56] = (0, 0, 0);
	at[56] = 0.9219;
	points[57] = (-320, -3136, 164.1217);
	angles[57] = (0, 0, 0);
	at[57] = 0.9375;
	points[58] = (-320, -3136, 228.8008);
	angles[58] = (0, 0, 0);
	at[58] = 0.9531;
	points[59] = (-320, -3136, 295.4370);
	angles[59] = (0, 0, 0);
	at[59] = 0.9688;
	points[60] = (-320, -3136, 432);
	angles[60] = (0, 0, 0);
	at[60] = 1;
	mover = getEnt("iz_q3_mover0", "targetname");
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
