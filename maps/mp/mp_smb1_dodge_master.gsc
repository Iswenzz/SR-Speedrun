main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_dodge_master", 0);

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
	ambientPlay("iz_0_stm", 2);
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
	thread iz_mover2();
	thread iz_mover3();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-117.7386, 117.7386, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-80.0980, 149.5146, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-37.8589, 174.2224, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (7.8394, 191.8016, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (55.8437, 202.2811, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (105.0016, 205.6909, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (154.1594, 202.0606, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (202.1650, 191.4205, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (247.8650, 173.8004, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (290.1075, 149.2303, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (327.7386, 117.7394, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (359.1855, 80.1079, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (383.6449, 37.8657, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (401.1142, -7.8348, 0);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (411.5984, -55.8409, 0);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (415.0905, -105, 0);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (411.5984, -154.1591, 0);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (401.1142, -202.1650, 0);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (383.6449, -247.8658, 0);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (359.1855, -290.1079, 0);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (327.7386, -327.7386, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (290.1103, -359.2303, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (247.8764, -383.8004, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (202.1866, -401.4213, 0);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (154.1925, -412.0591, 0);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (105.0441, -415.6890, 0);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (55.8917, -412.2795, 0);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (7.8872, -401.8032, 0);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (-37.8196, -384.2224, 0);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (-80.0779, -359.5138, 0);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (-117.7366, -327.7366, 0);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (-149.5299, -290.0779, 0);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (-174.3224, -247.8205, 0);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (-192.0303, -202.1146, 0);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (-202.6555, -154.1114, 0);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (-206.1976, -104.9606, 0);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (-202.6555, -55.8138, 0);
	angles[36] = (0, 0, 0);
	at[36] = 1.8000;
	points[37] = (-192.0303, -7.8209, 0);
	angles[37] = (0, 0, 0);
	at[37] = 1.8500;
	points[38] = (-174.3217, 37.8670, 0);
	angles[38] = (0, 0, 0);
	at[38] = 1.9000;
	points[39] = (-149.5299, 80.0996, 0);
	angles[39] = (0, 0, 0);
	at[39] = 1.9500;
	points[40] = (-117.7386, 117.7386, 0);
	angles[40] = (0, 0, 0);
	at[40] = 2;
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
	points[0] = (-210, 210, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-205.9972, 160.9154, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-194.3012, 113.5764, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-175.3807, 68.8327, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-149.7047, 27.4785, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-117.7413, -9.6923, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-80.1024, -41.8854, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-37.8573, -68.3067, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (7.8424, -88.1622, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (55.8453, -100.6579, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (105, -105, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (154.1547, -100.9972, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (202.1571, -89.3012, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (247.8575, -70.3807, 0);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (290.1024, -44.7051, 0);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (327.7413, -12.7415, 0);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (359.3850, 24.8974, 0);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (384.0146, 67.1425, 0);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (401.6063, 112.8421, 0);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (412.1614, 160.8453, 0);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (415.6811, 210, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (412.1614, 259.1547, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (401.6063, 307.1579, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (384.0146, 352.8575, 0);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (359.3850, 395.1024, 0);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (327.7413, 432.7402, 0);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (290.1024, 464.7047, 0);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (247.8567, 490.3819, 0);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (202.1571, 509.3032, 0);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (154.1539, 520.9961, 0);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (105, 525, 0);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (55.8449, 520.6575, 0);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (7.8420, 508.1614, 0);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (-37.8578, 488.3071, 0);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (-80.1031, 461.8858, 0);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (-117.7413, 429.6929, 0);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (-149.7055, 392.5217, 0);
	angles[36] = (0, 0, 0);
	at[36] = 1.8000;
	points[37] = (-175.3815, 351.1669, 0);
	angles[37] = (0, 0, 0);
	at[37] = 1.8500;
	points[38] = (-194.3012, 306.4236, 0);
	angles[38] = (0, 0, 0);
	at[38] = 1.9000;
	points[39] = (-205.9972, 259.0847, 0);
	angles[39] = (0, 0, 0);
	at[39] = 1.9500;
	points[40] = (-210, 210, 0);
	angles[40] = (0, 0, 0);
	at[40] = 2;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (105, -105, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (100.9972, -55.9154, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (89.3012, -8.5764, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (70.3815, 36.1672, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (44.7051, 77.5217, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (12.7415, 114.6921, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-24.8974, 146.8850, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-67.1425, 173.3067, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-112.8421, 193.1622, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-160.8453, 205.6579, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-210, 210, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-259.1547, 205.9972, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (-307.1571, 194.3012, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (-352.8575, 175.3807, 0);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (-395.1024, 149.7047, 0);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (-432.7402, 117.7413, 0);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (-464.3858, 80.1024, 0);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (-489.0157, 37.8574, 0);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (-506.6063, -7.8424, 0);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (-517.1614, -55.8453, 0);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (-520.6811, -105, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (-517.1614, -154.1547, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (-506.6063, -202.1579, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (-489.0157, -247.8575, 0);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (-464.3858, -290.1024, 0);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (-432.7402, -327.7413, 0);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (-395.1024, -359.7055, 0);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (-352.8567, -385.3815, 0);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (-307.1571, -404.3032, 0);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (-259.1539, -415.9961, 0);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (-210, -420, 0);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (-160.8453, -415.6575, 0);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (-112.8421, -403.1614, 0);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (-67.1421, -383.3067, 0);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (-24.8972, -356.8851, 0);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (12.7416, -324.6921, 0);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (44.7051, -287.5217, 0);
	angles[36] = (0, 0, 0);
	at[36] = 1.8000;
	points[37] = (70.3815, -246.1669, 0);
	angles[37] = (0, 0, 0);
	at[37] = 1.8500;
	points[38] = (89.3012, -201.4236, 0);
	angles[38] = (0, 0, 0);
	at[38] = 1.9000;
	points[39] = (100.9972, -154.0839, 0);
	angles[39] = (0, 0, 0);
	at[39] = 1.9500;
	points[40] = (105, -105, 0);
	angles[40] = (0, 0, 0);
	at[40] = 2;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (12.7387, -12.7386, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-24.9020, -44.5142, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-67.1409, -69.2224, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-112.8394, -86.8016, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-160.8437, -97.2811, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-210.0016, -100.6909, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-259.1595, -97.0606, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-307.1650, -86.4205, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-352.8650, -68.8004, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-395.1063, -44.2299, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-432.7402, -12.7389, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-464.1851, 24.8921, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (-488.6457, 67.1343, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (-506.1142, 112.8343, 0);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (-516.5984, 160.8409, 0);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (-520.0906, 210, 0);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (-516.5984, 259.1591, 0);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (-506.1142, 307.1650, 0);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (-488.6457, 352.8657, 0);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (-464.1851, 395.1063, 0);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (-432.7402, 432.7402, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (-395.1102, 464.1851, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (-352.8764, 488.6457, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (-307.1866, 506.1142, 0);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (-259.1917, 516.5984, 0);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (-210.0433, 520.0906, 0);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (-160.8921, 516.5984, 0);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (-112.8870, 506.1142, 0);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (-67.1803, 488.6457, 0);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (-24.9222, 464.1851, 0);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (12.7368, 432.7402, 0);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (44.5299, 395.1063, 0);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (69.3220, 352.8650, 0);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (87.0303, 307.1650, 0);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (97.6555, 259.1591, 0);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (101.1976, 210.0016, 0);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (97.6555, 160.8433, 0);
	angles[36] = (0, 0, 0);
	at[36] = 1.8000;
	points[37] = (87.0303, 112.8394, 0);
	angles[37] = (0, 0, 0);
	at[37] = 1.8500;
	points[38] = (69.3217, 67.1409, 0);
	angles[38] = (0, 0, 0);
	at[38] = 1.9000;
	points[39] = (44.5299, 24.9017, 0);
	angles[39] = (0, 0, 0);
	at[39] = 1.9500;
	points[40] = (12.7387, -12.7386, 0);
	angles[40] = (0, 0, 0);
	at[40] = 2;
	mover = getEnt("iz_mover3", "targetname");
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
