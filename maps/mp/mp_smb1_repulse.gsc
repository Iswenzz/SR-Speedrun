main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_repulse", 0);

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
	thread iz_mover1();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1.5747, 0, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (-3.5192, 0, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1500;
	points[3] = (-9.6425, 0, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-18.6386, 0, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.3500;
	points[5] = (-24.1741, 0, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (-37.2400, 0, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.5000;
	points[7] = (-52.8595, 0, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.6000;
	points[8] = (-61.5870, 0, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.6500;
	points[9] = (-80.7976, 0, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.7500;
	points[10] = (-91.2484, 0, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.8000;
	points[11] = (-113.7626, 0, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (-151.3248, 0, 0);
	angles[12] = (0, 0, 0);
	at[12] = 1.0500;
	points[13] = (-193.0524, 0, 0);
	angles[13] = (0, 0, 0);
	at[13] = 1.2000;
	points[14] = (-238.5146, 0, 0);
	angles[14] = (0, 0, 0);
	at[14] = 1.3500;
	points[15] = (-287.2799, 0, 0);
	angles[15] = (0, 0, 0);
	at[15] = 1.5000;
	points[16] = (-321.4134, 0, 0);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-356.6957, 0, 0);
	angles[17] = (0, 0, 0);
	at[17] = 1.7000;
	points[18] = (-411.4961, 0, 0);
	angles[18] = (0, 0, 0);
	at[18] = 1.8500;
	points[19] = (-487.3898, 0, 0);
	angles[19] = (0, 0, 0);
	at[19] = 2.0500;
	points[20] = (-565.5827, 0, 0);
	angles[20] = (0, 0, 0);
	at[20] = 2.2500;
	points[21] = (-803.7402, 0, 0);
	angles[21] = (0, 0, 0);
	at[21] = 2.8500;
	points[22] = (-861.8386, 0, 0);
	angles[22] = (0, 0, 0);
	at[22] = 3;
	points[23] = (-918.5040, 0, 0);
	angles[23] = (0, 0, 0);
	at[23] = 3.1500;
	points[24] = (-973.3071, 0, 0);
	angles[24] = (0, 0, 0);
	at[24] = 3.3000;
	points[25] = (-1025.8071, 0, 0);
	angles[25] = (0, 0, 0);
	at[25] = 3.4500;
	points[26] = (-1075.5787, 0, 0);
	angles[26] = (0, 0, 0);
	at[26] = 3.6000;
	points[27] = (-1122.1851, 0, 0);
	angles[27] = (0, 0, 0);
	at[27] = 3.7500;
	points[28] = (-1151.2914, 0, 0);
	angles[28] = (0, 0, 0);
	at[28] = 3.8500;
	points[29] = (-1178.6732, 0, 0);
	angles[29] = (0, 0, 0);
	at[29] = 3.9500;
	points[30] = (-1216.2362, 0, 0);
	angles[30] = (0, 0, 0);
	at[30] = 4.1000;
	points[31] = (-1238.7480, 0, 0);
	angles[31] = (0, 0, 0);
	at[31] = 4.2000;
	points[32] = (-1249.2008, 0, 0);
	angles[32] = (0, 0, 0);
	at[32] = 4.2500;
	points[33] = (-1268.4135, 0, 0);
	angles[33] = (0, 0, 0);
	at[33] = 4.3500;
	points[34] = (-1277.1417, 0, 0);
	angles[34] = (0, 0, 0);
	at[34] = 4.4000;
	points[35] = (-1292.7599, 0, 0);
	angles[35] = (0, 0, 0);
	at[35] = 4.5000;
	points[36] = (-1299.6182, 0, 0);
	angles[36] = (0, 0, 0);
	at[36] = 4.5500;
	points[37] = (-1305.8307, 0, 0);
	angles[37] = (0, 0, 0);
	at[37] = 4.6000;
	points[38] = (-1316.2087, 0, 0);
	angles[38] = (0, 0, 0);
	at[38] = 4.7000;
	points[39] = (-1320.3623, 0, 0);
	angles[39] = (0, 0, 0);
	at[39] = 4.7500;
	points[40] = (-1326.4803, 0, 0);
	angles[40] = (0, 0, 0);
	at[40] = 4.8500;
	points[41] = (-1329.6024, 0, 0);
	angles[41] = (0, 0, 0);
	at[41] = 4.9500;
	points[42] = (-1330, 0, 0);
	angles[42] = (0, 0, 0);
	at[42] = 5;
	points[43] = (-1329.6024, 0, 0);
	angles[43] = (0, 0, 0);
	at[43] = 5.0500;
	points[44] = (-1326.4803, 0, 0);
	angles[44] = (0, 0, 0);
	at[44] = 5.1500;
	points[45] = (-1323.7834, 0, 0);
	angles[45] = (0, 0, 0);
	at[45] = 5.2000;
	points[46] = (-1316.2087, 0, 0);
	angles[46] = (0, 0, 0);
	at[46] = 5.3000;
	points[47] = (-1305.8307, 0, 0);
	angles[47] = (0, 0, 0);
	at[47] = 5.4000;
	points[48] = (-1299.6182, 0, 0);
	angles[48] = (0, 0, 0);
	at[48] = 5.4500;
	points[49] = (-1292.7599, 0, 0);
	angles[49] = (0, 0, 0);
	at[49] = 5.5000;
	points[50] = (-1277.1417, 0, 0);
	angles[50] = (0, 0, 0);
	at[50] = 5.6000;
	points[51] = (-1268.4135, 0, 0);
	angles[51] = (0, 0, 0);
	at[51] = 5.6500;
	points[52] = (-1249.2008, 0, 0);
	angles[52] = (0, 0, 0);
	at[52] = 5.7500;
	points[53] = (-1238.7480, 0, 0);
	angles[53] = (0, 0, 0);
	at[53] = 5.8000;
	points[54] = (-1216.2362, 0, 0);
	angles[54] = (0, 0, 0);
	at[54] = 5.9000;
	points[55] = (-1178.6732, 0, 0);
	angles[55] = (0, 0, 0);
	at[55] = 6.0500;
	points[56] = (-1151.2914, 0, 0);
	angles[56] = (0, 0, 0);
	at[56] = 6.1500;
	points[57] = (-1122.1851, 0, 0);
	angles[57] = (0, 0, 0);
	at[57] = 6.2500;
	points[58] = (-1075.5787, 0, 0);
	angles[58] = (0, 0, 0);
	at[58] = 6.4000;
	points[59] = (-1025.8071, 0, 0);
	angles[59] = (0, 0, 0);
	at[59] = 6.5500;
	points[60] = (-973.3071, 0, 0);
	angles[60] = (0, 0, 0);
	at[60] = 6.7000;
	points[61] = (-918.5040, 0, 0);
	angles[61] = (0, 0, 0);
	at[61] = 6.8500;
	points[62] = (-861.8386, 0, 0);
	angles[62] = (0, 0, 0);
	at[62] = 7;
	points[63] = (-803.7402, 0, 0);
	angles[63] = (0, 0, 0);
	at[63] = 7.1500;
	points[64] = (-585.3701, 0, 0);
	angles[64] = (0, 0, 0);
	at[64] = 7.7000;
	points[65] = (-506.7599, 0, 0);
	angles[65] = (0, 0, 0);
	at[65] = 7.9000;
	points[66] = (-430.1969, 0, 0);
	angles[66] = (0, 0, 0);
	at[66] = 8.1000;
	points[67] = (-356.6957, 0, 0);
	angles[67] = (0, 0, 0);
	at[67] = 8.3000;
	points[68] = (-321.4134, 0, 0);
	angles[68] = (0, 0, 0);
	at[68] = 8.4000;
	points[69] = (-287.2799, 0, 0);
	angles[69] = (0, 0, 0);
	at[69] = 8.5000;
	points[70] = (-238.5146, 0, 0);
	angles[70] = (0, 0, 0);
	at[70] = 8.6500;
	points[71] = (-193.0524, 0, 0);
	angles[71] = (0, 0, 0);
	at[71] = 8.8000;
	points[72] = (-151.3248, 0, 0);
	angles[72] = (0, 0, 0);
	at[72] = 8.9500;
	points[73] = (-113.7626, 0, 0);
	angles[73] = (0, 0, 0);
	at[73] = 9.1000;
	points[74] = (-91.2484, 0, 0);
	angles[74] = (0, 0, 0);
	at[74] = 9.2000;
	points[75] = (-80.7976, 0, 0);
	angles[75] = (0, 0, 0);
	at[75] = 9.2500;
	points[76] = (-61.5870, 0, 0);
	angles[76] = (0, 0, 0);
	at[76] = 9.3500;
	points[77] = (-52.8595, 0, 0);
	angles[77] = (0, 0, 0);
	at[77] = 9.4000;
	points[78] = (-37.2400, 0, 0);
	angles[78] = (0, 0, 0);
	at[78] = 9.5000;
	points[79] = (-24.1741, 0, 0);
	angles[79] = (0, 0, 0);
	at[79] = 9.6000;
	points[80] = (-18.6386, 0, 0);
	angles[80] = (0, 0, 0);
	at[80] = 9.6500;
	points[81] = (-9.6424, 0, 0);
	angles[81] = (0, 0, 0);
	at[81] = 9.7500;
	points[82] = (-3.5191, 0, 0);
	angles[82] = (0, 0, 0);
	at[82] = 9.8500;
	points[83] = (-1.5749, 0, 0);
	angles[83] = (0, 0, 0);
	at[83] = 9.9000;
	points[84] = (0, 0, 0);
	angles[84] = (0, 0, 0);
	at[84] = 10;
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
	points[0] = (-1330, -630, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1329.6024, -630, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-1326.4803, -630, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1500;
	points[3] = (-1323.7834, -630, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.2000;
	points[4] = (-1316.2087, -630, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.3000;
	points[5] = (-1305.8307, -630, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (-1299.6182, -630, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.4500;
	points[7] = (-1292.7599, -630, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.5000;
	points[8] = (-1277.1417, -630, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.6000;
	points[9] = (-1268.4135, -630, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.6500;
	points[10] = (-1249.2008, -630, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.7500;
	points[11] = (-1227.7599, -630, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.8500;
	points[12] = (-1216.2362, -630, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.9000;
	points[13] = (-1178.6732, -630, 0);
	angles[13] = (0, 0, 0);
	at[13] = 1.0500;
	points[14] = (-1151.2914, -630, 0);
	angles[14] = (0, 0, 0);
	at[14] = 1.1500;
	points[15] = (-1122.1851, -630, 0);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (-1075.5787, -630, 0);
	angles[16] = (0, 0, 0);
	at[16] = 1.4000;
	points[17] = (-1025.8071, -630, 0);
	angles[17] = (0, 0, 0);
	at[17] = 1.5500;
	points[18] = (-973.3071, -630, 0);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-918.5040, -630, 0);
	angles[19] = (0, 0, 0);
	at[19] = 1.8500;
	points[20] = (-861.8386, -630, 0);
	angles[20] = (0, 0, 0);
	at[20] = 2;
	points[21] = (-803.7402, -630, 0);
	angles[21] = (0, 0, 0);
	at[21] = 2.1500;
	points[22] = (-585.3701, -630, 0);
	angles[22] = (0, 0, 0);
	at[22] = 2.7000;
	points[23] = (-506.7599, -630, 0);
	angles[23] = (0, 0, 0);
	at[23] = 2.9000;
	points[24] = (-430.1969, -630, 0);
	angles[24] = (0, 0, 0);
	at[24] = 3.1000;
	points[25] = (-356.6957, -630, 0);
	angles[25] = (0, 0, 0);
	at[25] = 3.3000;
	points[26] = (-321.4126, -630, 0);
	angles[26] = (0, 0, 0);
	at[26] = 3.4000;
	points[27] = (-287.2799, -630, 0);
	angles[27] = (0, 0, 0);
	at[27] = 3.5000;
	points[28] = (-238.5146, -630, 0);
	angles[28] = (0, 0, 0);
	at[28] = 3.6500;
	points[29] = (-193.0524, -630, 0);
	angles[29] = (0, 0, 0);
	at[29] = 3.8000;
	points[30] = (-151.3248, -630, 0);
	angles[30] = (0, 0, 0);
	at[30] = 3.9500;
	points[31] = (-113.7626, -630, 0);
	angles[31] = (0, 0, 0);
	at[31] = 4.1000;
	points[32] = (-91.2484, -630, 0);
	angles[32] = (0, 0, 0);
	at[32] = 4.2000;
	points[33] = (-80.7976, -630, 0);
	angles[33] = (0, 0, 0);
	at[33] = 4.2500;
	points[34] = (-61.5870, -630, 0);
	angles[34] = (0, 0, 0);
	at[34] = 4.3500;
	points[35] = (-52.8595, -630, 0);
	angles[35] = (0, 0, 0);
	at[35] = 4.4000;
	points[36] = (-37.2400, -630, 0);
	angles[36] = (0, 0, 0);
	at[36] = 4.5000;
	points[37] = (-24.1740, -630, 0);
	angles[37] = (0, 0, 0);
	at[37] = 4.6000;
	points[38] = (-18.6387, -630, 0);
	angles[38] = (0, 0, 0);
	at[38] = 4.6500;
	points[39] = (-9.6424, -630, 0);
	angles[39] = (0, 0, 0);
	at[39] = 4.7500;
	points[40] = (-3.5190, -630, 0);
	angles[40] = (0, 0, 0);
	at[40] = 4.8500;
	points[41] = (-1.5748, -630, 0);
	angles[41] = (0, 0, 0);
	at[41] = 4.9000;
	points[42] = (0, -630, 0);
	angles[42] = (0, 0, 0);
	at[42] = 5;
	points[43] = (-1.5747, -630, 0);
	angles[43] = (0, 0, 0);
	at[43] = 5.1000;
	points[44] = (-3.5192, -630, 0);
	angles[44] = (0, 0, 0);
	at[44] = 5.1500;
	points[45] = (-9.6426, -630, 0);
	angles[45] = (0, 0, 0);
	at[45] = 5.2500;
	points[46] = (-18.6386, -630, 0);
	angles[46] = (0, 0, 0);
	at[46] = 5.3500;
	points[47] = (-24.1741, -630, 0);
	angles[47] = (0, 0, 0);
	at[47] = 5.4000;
	points[48] = (-37.2400, -630, 0);
	angles[48] = (0, 0, 0);
	at[48] = 5.5000;
	points[49] = (-52.8595, -630, 0);
	angles[49] = (0, 0, 0);
	at[49] = 5.6000;
	points[50] = (-61.5870, -630, 0);
	angles[50] = (0, 0, 0);
	at[50] = 5.6500;
	points[51] = (-80.7976, -630, 0);
	angles[51] = (0, 0, 0);
	at[51] = 5.7500;
	points[52] = (-91.2484, -630, 0);
	angles[52] = (0, 0, 0);
	at[52] = 5.8000;
	points[53] = (-113.7634, -630, 0);
	angles[53] = (0, 0, 0);
	at[53] = 5.9000;
	points[54] = (-151.3248, -630, 0);
	angles[54] = (0, 0, 0);
	at[54] = 6.0500;
	points[55] = (-193.0524, -630, 0);
	angles[55] = (0, 0, 0);
	at[55] = 6.2000;
	points[56] = (-238.5146, -630, 0);
	angles[56] = (0, 0, 0);
	at[56] = 6.3500;
	points[57] = (-287.2799, -630, 0);
	angles[57] = (0, 0, 0);
	at[57] = 6.5000;
	points[58] = (-321.4134, -630, 0);
	angles[58] = (0, 0, 0);
	at[58] = 6.6000;
	points[59] = (-356.6957, -630, 0);
	angles[59] = (0, 0, 0);
	at[59] = 6.7000;
	points[60] = (-411.4921, -630, 0);
	angles[60] = (0, 0, 0);
	at[60] = 6.8500;
	points[61] = (-487.3898, -630, 0);
	angles[61] = (0, 0, 0);
	at[61] = 7.0500;
	points[62] = (-565.5827, -630, 0);
	angles[62] = (0, 0, 0);
	at[62] = 7.2500;
	points[63] = (-803.7402, -630, 0);
	angles[63] = (0, 0, 0);
	at[63] = 7.8500;
	points[64] = (-861.8386, -630, 0);
	angles[64] = (0, 0, 0);
	at[64] = 8;
	points[65] = (-918.5040, -630, 0);
	angles[65] = (0, 0, 0);
	at[65] = 8.1500;
	points[66] = (-973.3071, -630, 0);
	angles[66] = (0, 0, 0);
	at[66] = 8.3000;
	points[67] = (-1025.8071, -630, 0);
	angles[67] = (0, 0, 0);
	at[67] = 8.4500;
	points[68] = (-1075.5787, -630, 0);
	angles[68] = (0, 0, 0);
	at[68] = 8.6000;
	points[69] = (-1122.1851, -630, 0);
	angles[69] = (0, 0, 0);
	at[69] = 8.7500;
	points[70] = (-1151.2914, -630, 0);
	angles[70] = (0, 0, 0);
	at[70] = 8.8500;
	points[71] = (-1178.6732, -630, 0);
	angles[71] = (0, 0, 0);
	at[71] = 8.9500;
	points[72] = (-1216.2362, -630, 0);
	angles[72] = (0, 0, 0);
	at[72] = 9.1000;
	points[73] = (-1227.7599, -630, 0);
	angles[73] = (0, 0, 0);
	at[73] = 9.1500;
	points[74] = (-1249.2008, -630, 0);
	angles[74] = (0, 0, 0);
	at[74] = 9.2500;
	points[75] = (-1268.4135, -630, 0);
	angles[75] = (0, 0, 0);
	at[75] = 9.3500;
	points[76] = (-1277.1417, -630, 0);
	angles[76] = (0, 0, 0);
	at[76] = 9.4000;
	points[77] = (-1292.7599, -630, 0);
	angles[77] = (0, 0, 0);
	at[77] = 9.5000;
	points[78] = (-1299.6182, -630, 0);
	angles[78] = (0, 0, 0);
	at[78] = 9.5500;
	points[79] = (-1305.8307, -630, 0);
	angles[79] = (0, 0, 0);
	at[79] = 9.6000;
	points[80] = (-1316.2087, -630, 0);
	angles[80] = (0, 0, 0);
	at[80] = 9.7000;
	points[81] = (-1320.3623, -630, 0);
	angles[81] = (0, 0, 0);
	at[81] = 9.7500;
	points[82] = (-1326.4803, -630, 0);
	angles[82] = (0, 0, 0);
	at[82] = 9.8500;
	points[83] = (-1329.6024, -630, 0);
	angles[83] = (0, 0, 0);
	at[83] = 9.9500;
	points[84] = (-1330, -630, 0);
	angles[84] = (0, 0, 0);
	at[84] = 10;
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
