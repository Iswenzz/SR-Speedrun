main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_swing_bridges", 0);

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
	ambientPlay("iz_0_colony", 2);
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
	thread iz_mover2();
	thread iz_mover3();
	thread iz_mover4();
	thread iz_mover5();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 5250, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 5250, 0);
	angles[1] = (0, -1.7395, 0);
	at[1] = 0.2500;
	points[2] = (0, 5250, 0);
	angles[2] = (0, -6.7195, 0);
	at[2] = 0.5000;
	points[3] = (0, 5250, 0);
	angles[3] = (0, -14.5795, 0);
	at[3] = 0.7500;
	points[4] = (0, 5250, 0);
	angles[4] = (0, -27.3062, 0);
	at[4] = 1.0500;
	points[5] = (0, 5250, 0);
	angles[5] = (0, -43.0398, 0);
	at[5] = 1.3500;
	points[6] = (0, 5250, 0);
	angles[6] = (0, -64.3656, 0);
	at[6] = 1.7000;
	points[7] = (0, 5250, 0);
	angles[7] = (0, -87.9494, 0);
	at[7] = 2.0500;
	points[8] = (0, 5250, 0);
	angles[8] = (0, -145.0349, 0);
	at[8] = 2.8500;
	points[9] = (0, 5250, 0);
	angles[9] = (0, -165.7449, 0);
	at[9] = 3.1500;
	points[10] = (0, 5250, 0);
	angles[10] = (0, -185.1072, 0);
	at[10] = 3.4500;
	points[11] = (0, 5250, 0);
	angles[11] = (0, -202.4995, 0);
	at[11] = 3.7500;
	points[12] = (0, 5250, 0);
	angles[12] = (0, -219.4709, 0);
	at[12] = 4.1000;
	points[13] = (0, 5250, 0);
	angles[13] = (0, -230.4610, 0);
	at[13] = 4.4000;
	points[14] = (0, 5250, 0);
	angles[14] = (0, -234.5175, 0);
	at[14] = 4.5500;
	points[15] = (0, 5250, 0);
	angles[15] = (0, -237.5112, 0);
	at[15] = 4.7000;
	points[16] = (0, 5250, 0);
	angles[16] = (0, -239.3645, 0);
	at[16] = 4.8500;
	points[17] = (0, 5250, 0);
	angles[17] = (0, -240, 0);
	at[17] = 5;
	points[18] = (0, 5250, 0);
	angles[18] = (0, -239.3645, 0);
	at[18] = 5.1500;
	points[19] = (0, 5250, 0);
	angles[19] = (0, -237.5112, 0);
	at[19] = 5.3000;
	points[20] = (0, 5250, 0);
	angles[20] = (0, -234.5175, 0);
	at[20] = 5.4500;
	points[21] = (0, 5250, 0);
	angles[21] = (0, -230.4610, 0);
	at[21] = 5.6000;
	points[22] = (0, 5250, 0);
	angles[22] = (0, -219.4709, 0);
	at[22] = 5.9000;
	points[23] = (0, 5250, 0);
	angles[23] = (0, -202.4995, 0);
	at[23] = 6.2500;
	points[24] = (0, 5250, 0);
	angles[24] = (0, -185.1072, 0);
	at[24] = 6.5500;
	points[25] = (0, 5250, 0);
	angles[25] = (0, -165.7449, 0);
	at[25] = 6.8500;
	points[26] = (0, 5250, 0);
	angles[26] = (0, -145.0349, 0);
	at[26] = 7.1500;
	points[27] = (0, 5250, 0);
	angles[27] = (0, -87.9494, 0);
	at[27] = 7.9500;
	points[28] = (0, 5250, 0);
	angles[28] = (0, -64.3656, 0);
	at[28] = 8.3000;
	points[29] = (0, 5250, 0);
	angles[29] = (0, -43.0397, 0);
	at[29] = 8.6500;
	points[30] = (0, 5250, 0);
	angles[30] = (0, -27.3062, 0);
	at[30] = 8.9500;
	points[31] = (0, 5250, 0);
	angles[31] = (0, -14.5795, 0);
	at[31] = 9.2500;
	points[32] = (0, 5250, 0);
	angles[32] = (0, -6.7195, 0);
	at[32] = 9.5000;
	points[33] = (0, 5250, 0);
	angles[33] = (0, -1.7395, 0);
	at[33] = 9.7500;
	points[34] = (0, 5250, 0);
	angles[34] = (0, 0, 0);
	at[34] = 10;
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
	points[0] = (0, 8750, -140);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 8750, -140);
	angles[1] = (0, -1.2697, 0);
	at[1] = 0.1500;
	points[2] = (0, 8750, -140);
	angles[2] = (0, -4.9763, 0);
	at[2] = 0.3000;
	points[3] = (0, 8750, -140);
	angles[3] = (0, -10.9638, 0);
	at[3] = 0.4500;
	points[4] = (0, 8750, -140);
	angles[4] = (0, -19.0767, 0);
	at[4] = 0.6000;
	points[5] = (0, 8750, -140);
	angles[5] = (0, -29.1596, 0);
	at[5] = 0.7500;
	points[6] = (0, 8750, -140);
	angles[6] = (0, -41.0570, 0);
	at[6] = 0.9000;
	points[7] = (0, 8750, -140);
	angles[7] = (0, -54.6131, 0);
	at[7] = 1.0500;
	points[8] = (0, 8750, -140);
	angles[8] = (0, -75, 0);
	at[8] = 1.2500;
	points[9] = (0, 8750, -140);
	angles[9] = (0, -91.8217, 0);
	at[9] = 1.4000;
	points[10] = (0, 8750, -140);
	angles[10] = (0, -109.7843, 0);
	at[10] = 1.5500;
	points[11] = (0, 8750, -140);
	angles[11] = (0, -148.5087, 0);
	at[11] = 1.8500;
	points[12] = (0, 8750, -140);
	angles[12] = (0, -189.9289, 0);
	at[12] = 2.1500;
	points[13] = (0, 8750, -140);
	angles[13] = (0, -247.1986, 0);
	at[13] = 2.5500;
	points[14] = (0, 8750, -140);
	angles[14] = (0, -304.0999, 0);
	at[14] = 2.9500;
	points[15] = (0, 8750, -140);
	angles[15] = (0, -351.2675, 0);
	at[15] = 3.3000;
	points[16] = (0, 8750, -140);
	angles[16] = (0, -376.3196, 0);
	at[16] = 3.5000;
	points[17] = (0, 8750, -140);
	angles[17] = (0, -393.9193, 0);
	at[17] = 3.6500;
	points[18] = (0, 8750, -140);
	angles[18] = (0, -410.3266, 0);
	at[18] = 3.8000;
	points[19] = (0, 8750, -140);
	angles[19] = (0, -425.3862, 0);
	at[19] = 3.9500;
	points[20] = (0, 8750, -140);
	angles[20] = (0, -438.9424, 0);
	at[20] = 4.1000;
	points[21] = (0, 8750, -140);
	angles[21] = (0, -450.8397, 0);
	at[21] = 4.2500;
	points[22] = (0, 8750, -140);
	angles[22] = (0, -460.9224, 0);
	at[22] = 4.4000;
	points[23] = (0, 8750, -140);
	angles[23] = (0, -466.5596, 0);
	at[23] = 4.5000;
	points[24] = (0, 8750, -140);
	angles[24] = (0, -473.2729, 0);
	at[24] = 4.6500;
	points[25] = (0, 8750, -140);
	angles[25] = (0, -476.5196, 0);
	at[25] = 4.7500;
	points[26] = (0, 8750, -140);
	angles[26] = (0, -479.4312, 0);
	at[26] = 4.9000;
	points[27] = (0, 8750, -140);
	angles[27] = (0, -480, 0);
	at[27] = 5;
	points[28] = (0, 8750, -140);
	angles[28] = (0, -479.4312, 0);
	at[28] = 5.1000;
	points[29] = (0, 8750, -140);
	angles[29] = (0, -476.5196, 0);
	at[29] = 5.2500;
	points[30] = (0, 8750, -140);
	angles[30] = (0, -473.2729, 0);
	at[30] = 5.3500;
	points[31] = (0, 8750, -140);
	angles[31] = (0, -466.5596, 0);
	at[31] = 5.5000;
	points[32] = (0, 8750, -140);
	angles[32] = (0, -460.9224, 0);
	at[32] = 5.6000;
	points[33] = (0, 8750, -140);
	angles[33] = (0, -450.8397, 0);
	at[33] = 5.7500;
	points[34] = (0, 8750, -140);
	angles[34] = (0, -438.9424, 0);
	at[34] = 5.9000;
	points[35] = (0, 8750, -140);
	angles[35] = (0, -425.3862, 0);
	at[35] = 6.0500;
	points[36] = (0, 8750, -140);
	angles[36] = (0, -410.3266, 0);
	at[36] = 6.2000;
	points[37] = (0, 8750, -140);
	angles[37] = (0, -393.9193, 0);
	at[37] = 6.3500;
	points[38] = (0, 8750, -140);
	angles[38] = (0, -376.3197, 0);
	at[38] = 6.5000;
	points[39] = (0, 8750, -140);
	angles[39] = (0, -351.2675, 0);
	at[39] = 6.7000;
	points[40] = (0, 8750, -140);
	angles[40] = (0, -304.0997, 0);
	at[40] = 7.0500;
	points[41] = (0, 8750, -140);
	angles[41] = (0, -247.1988, 0);
	at[41] = 7.4500;
	points[42] = (0, 8750, -140);
	angles[42] = (0, -189.9289, 0);
	at[42] = 7.8500;
	points[43] = (0, 8750, -140);
	angles[43] = (0, -148.5089, 0);
	at[43] = 8.1500;
	points[44] = (0, 8750, -140);
	angles[44] = (0, -109.7843, 0);
	at[44] = 8.4500;
	points[45] = (0, 8750, -140);
	angles[45] = (0, -91.8217, 0);
	at[45] = 8.6000;
	points[46] = (0, 8750, -140);
	angles[46] = (0, -75, 0);
	at[46] = 8.7500;
	points[47] = (0, 8750, -140);
	angles[47] = (0, -54.6131, 0);
	at[47] = 8.9500;
	points[48] = (0, 8750, -140);
	angles[48] = (0, -41.0568, 0);
	at[48] = 9.1000;
	points[49] = (0, 8750, -140);
	angles[49] = (0, -29.1596, 0);
	at[49] = 9.2500;
	points[50] = (0, 8750, -140);
	angles[50] = (0, -19.0767, 0);
	at[50] = 9.4000;
	points[51] = (0, 8750, -140);
	angles[51] = (0, -10.9637, 0);
	at[51] = 9.5500;
	points[52] = (0, 8750, -140);
	angles[52] = (0, -4.9762, 0);
	at[52] = 9.7000;
	points[53] = (0, 8750, -140);
	angles[53] = (0, -1.2697, 0);
	at[53] = 9.8500;
	points[54] = (0, 8750, -140);
	angles[54] = (0, 0, 0);
	at[54] = 10;
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
	points[0] = (0, 12250, -280);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 12250, -280);
	angles[1] = (0, -0.2854, 0);
	at[1] = 0.0500;
	points[2] = (0, 12250, -280);
	angles[2] = (0, -2.5394, 0);
	at[2] = 0.1500;
	points[3] = (0, 12250, -280);
	angles[3] = (0, -4.4844, 0);
	at[3] = 0.2000;
	points[4] = (0, 12250, -280);
	angles[4] = (0, -9.9525, 0);
	at[4] = 0.3000;
	points[5] = (0, 12250, -280);
	angles[5] = (0, -21.9276, 0);
	at[5] = 0.4500;
	points[6] = (-0.0012, 12250, -280);
	angles[6] = (0, -38.1536, 0);
	at[6] = 0.6000;
	points[7] = (-0.0015, 12250, -280);
	angles[7] = (0, -58.3193, 0);
	at[7] = 0.7500;
	points[8] = (-0.0012, 12250, -280);
	angles[8] = (0, -82.1138, 0);
	at[8] = 0.9000;
	points[9] = (0, 12250, -280);
	angles[9] = (0, -109.2262, 0);
	at[9] = 1.0500;
	points[10] = (-0.0016, 12250, -280);
	angles[10] = (0, -128.9906, 0);
	at[10] = 1.1500;
	points[11] = (0, 12250, -280);
	angles[11] = (0, -150, 0);
	at[11] = 1.2500;
	points[12] = (0, 12250, -280);
	angles[12] = (0, -183.6434, 0);
	at[12] = 1.4000;
	points[13] = (0, 12250, -280);
	angles[13] = (0, -219.5686, 0);
	at[13] = 1.5500;
	points[14] = (0, 12250, -280);
	angles[14] = (0, -257.4636, 0);
	at[14] = 1.7000;
	points[15] = (-0.0015, 12250, -280);
	angles[15] = (0, -297.0175, 0);
	at[15] = 1.8500;
	points[16] = (0, 12250, -280);
	angles[16] = (0, -337.9193, 0);
	at[16] = 2;
	points[17] = (0, 12250, -280);
	angles[17] = (0, -379.8579, 0);
	at[17] = 2.1500;
	points[18] = (-0.0015, 12250, -280);
	angles[18] = (0, -422.5221, 0);
	at[18] = 2.3000;
	points[19] = (0, 12250, -280);
	angles[19] = (0, -480, 0);
	at[19] = 2.5000;
	points[20] = (0, 12250, -280);
	angles[20] = (0, -537.4764, 0);
	at[20] = 2.7000;
	points[21] = (0, 12250, -280);
	angles[21] = (0, -594.2163, 0);
	at[21] = 2.9000;
	points[22] = (-0.0014, 12250, -280);
	angles[22] = (0, -649.4815, 0);
	at[22] = 3.1000;
	points[23] = (0, 12250, -280);
	angles[23] = (0, -702.5349, 0);
	at[23] = 3.3000;
	points[24] = (-0.0013, 12250, -280);
	angles[24] = (0, -752.6392, 0);
	at[24] = 3.5000;
	points[25] = (-0.0014, 12250, -280);
	angles[25] = (0, -787.8386, 0);
	at[25] = 3.6500;
	points[26] = (0, 12250, -280);
	angles[26] = (0, -820.6534, 0);
	at[26] = 3.8000;
	points[27] = (-0.0015, 12250, -280);
	angles[27] = (0, -850.7725, 0);
	at[27] = 3.9500;
	points[28] = (-0.0013, 12250, -280);
	angles[28] = (0, -877.8847, 0);
	at[28] = 4.1000;
	points[29] = (0, 12250, -280);
	angles[29] = (0, -901.6793, 0);
	at[29] = 4.2500;
	points[30] = (-0.0013, 12250, -280);
	angles[30] = (0, -921.8450, 0);
	at[30] = 4.4000;
	points[31] = (0, 12250, -280);
	angles[31] = (0, -933.1192, 0);
	at[31] = 4.5000;
	points[32] = (0, 12250, -280);
	angles[32] = (0, -946.5456, 0);
	at[32] = 4.6500;
	points[33] = (-0.0016, 12250, -280);
	angles[33] = (0, -953.0394, 0);
	at[33] = 4.7500;
	points[34] = (0, 12250, -280);
	angles[34] = (0, -957.4592, 0);
	at[34] = 4.8500;
	points[35] = (0, 12250, -280);
	angles[35] = (0, -958.8625, 0);
	at[35] = 4.9000;
	points[36] = (0, 12250, -280);
	angles[36] = (0, -960, 0);
	at[36] = 5;
	points[37] = (0, 12250, -280);
	angles[37] = (0, -958.8627, 0);
	at[37] = 5.1000;
	points[38] = (0, 12250, -280);
	angles[38] = (0, -957.4590, 0);
	at[38] = 5.1500;
	points[39] = (-0.0016, 12250, -280);
	angles[39] = (0, -953.0394, 0);
	at[39] = 5.2500;
	points[40] = (0, 12250, -280);
	angles[40] = (0, -946.5458, 0);
	at[40] = 5.3500;
	points[41] = (0, 12250, -280);
	angles[41] = (0, -933.1192, 0);
	at[41] = 5.5000;
	points[42] = (-0.0013, 12250, -280);
	angles[42] = (0, -921.8452, 0);
	at[42] = 5.6000;
	points[43] = (0, 12250, -280);
	angles[43] = (0, -901.6793, 0);
	at[43] = 5.7500;
	points[44] = (-0.0013, 12250, -280);
	angles[44] = (0, -877.8847, 0);
	at[44] = 5.9000;
	points[45] = (-0.0015, 12250, -280);
	angles[45] = (0, -850.7724, 0);
	at[45] = 6.0500;
	points[46] = (0, 12250, -280);
	angles[46] = (0, -820.6534, 0);
	at[46] = 6.2000;
	points[47] = (-0.0014, 12250, -280);
	angles[47] = (0, -787.8386, 0);
	at[47] = 6.3500;
	points[48] = (-0.0013, 12250, -280);
	angles[48] = (0, -752.6393, 0);
	at[48] = 6.5000;
	points[49] = (0, 12250, -280);
	angles[49] = (0, -702.5350, 0);
	at[49] = 6.7000;
	points[50] = (-0.0014, 12250, -280);
	angles[50] = (0, -649.4815, 0);
	at[50] = 6.9000;
	points[51] = (0, 12250, -280);
	angles[51] = (0, -594.2162, 0);
	at[51] = 7.1000;
	points[52] = (0, 12250, -280);
	angles[52] = (0, -551.7593, 0);
	at[52] = 7.2500;
	points[53] = (0, 12250, -280);
	angles[53] = (0, -494.3974, 0);
	at[53] = 7.4500;
	points[54] = (-0.0013, 12250, -280);
	angles[54] = (0, -436.8511, 0);
	at[54] = 7.6500;
	points[55] = (0, 12250, -280);
	angles[55] = (0, -379.8579, 0);
	at[55] = 7.8500;
	points[56] = (0, 12250, -280);
	angles[56] = (0, -337.9193, 0);
	at[56] = 8;
	points[57] = (-0.0015, 12250, -280);
	angles[57] = (0, -297.0177, 0);
	at[57] = 8.1500;
	points[58] = (0, 12250, -280);
	angles[58] = (0, -257.4634, 0);
	at[58] = 8.3000;
	points[59] = (0, 12250, -280);
	angles[59] = (0, -219.5687, 0);
	at[59] = 8.4500;
	points[60] = (0, 12250, -280);
	angles[60] = (0, -183.6434, 0);
	at[60] = 8.6000;
	points[61] = (0, 12250, -280);
	angles[61] = (0, -150, 0);
	at[61] = 8.7500;
	points[62] = (-0.0016, 12250, -280);
	angles[62] = (0, -128.9905, 0);
	at[62] = 8.8500;
	points[63] = (0, 12250, -280);
	angles[63] = (0, -109.2263, 0);
	at[63] = 8.9500;
	points[64] = (-0.0012, 12250, -280);
	angles[64] = (0, -82.1138, 0);
	at[64] = 9.1000;
	points[65] = (-0.0015, 12250, -280);
	angles[65] = (0, -58.3193, 0);
	at[65] = 9.2500;
	points[66] = (-0.0012, 12250, -280);
	angles[66] = (0, -38.1535, 0);
	at[66] = 9.4000;
	points[67] = (0, 12250, -280);
	angles[67] = (0, -21.9275, 0);
	at[67] = 9.5500;
	points[68] = (0, 12250, -280);
	angles[68] = (0, -9.9524, 0);
	at[68] = 9.7000;
	points[69] = (0, 12250, -280);
	angles[69] = (0, -4.4845, 0);
	at[69] = 9.8000;
	points[70] = (0, 12250, -280);
	angles[70] = (0, -2.5394, 0);
	at[70] = 9.8500;
	points[71] = (0, 12250, -280);
	angles[71] = (0, -0.2854, 0);
	at[71] = 9.9500;
	points[72] = (0, 12250, -280);
	angles[72] = (0, 0, 0);
	at[72] = 10;
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
	points[0] = (0, -13300, -350);
	angles[0] = (0, 0.0018, 0);
	at[0] = 0;
	points[1] = (0, -13300, -350);
	angles[1] = (0, -0.6332, 0);
	at[1] = 0.1500;
	points[2] = (0, -13300, -350);
	angles[2] = (0, -2.4865, 0);
	at[2] = 0.3000;
	points[3] = (0, -13300, -350);
	angles[3] = (0, -5.4803, 0);
	at[3] = 0.4500;
	points[4] = (0, -13300, -350);
	angles[4] = (0, -9.5367, 0);
	at[4] = 0.6000;
	points[5] = (0, -13300, -350);
	angles[5] = (0, -20.5268, 0);
	at[5] = 0.9000;
	points[6] = (0, -13300, -350);
	angles[6] = (0, -37.4981, 0);
	at[6] = 1.2500;
	points[7] = (0, -13300, -350);
	angles[7] = (0, -54.8905, 0);
	at[7] = 1.5500;
	points[8] = (0, -13300, -350);
	angles[8] = (0, -74.2527, 0);
	at[8] = 1.8500;
	points[9] = (0, -13300, -350);
	angles[9] = (0, -94.9628, 0);
	at[9] = 2.1500;
	points[10] = (0, -13300, -350);
	angles[10] = (0, -148.5524, 0);
	at[10] = 2.9000;
	points[11] = (0, -13300, -350);
	angles[11] = (0, -175.6321, 0);
	at[11] = 3.3000;
	points[12] = (0, -13300, -350);
	angles[12] = (0, -196.9580, 0);
	at[12] = 3.6500;
	points[13] = (0, -13300, -350);
	angles[13] = (0, -212.6915, 0);
	at[13] = 3.9500;
	points[14] = (0, -13300, -350);
	angles[14] = (0, -225.4181, 0);
	at[14] = 4.2500;
	points[15] = (0, -13300, -350);
	angles[15] = (0, -233.2782, 0);
	at[15] = 4.5000;
	points[16] = (0, -13300, -350);
	angles[16] = (0, -238.2582, 0);
	at[16] = 4.7500;
	points[17] = (0, -13300, -350);
	angles[17] = (0, -239.9982, 0);
	at[17] = 5;
	points[18] = (0, -13300, -350);
	angles[18] = (0, -238.2582, 0);
	at[18] = 5.2500;
	points[19] = (0, -13300, -350);
	angles[19] = (0, -233.2781, 0);
	at[19] = 5.5000;
	points[20] = (0, -13300, -350);
	angles[20] = (0, -225.4181, 0);
	at[20] = 5.7500;
	points[21] = (0, -13300, -350);
	angles[21] = (0, -212.6915, 0);
	at[21] = 6.0500;
	points[22] = (0, -13300, -350);
	angles[22] = (0, -196.9580, 0);
	at[22] = 6.3500;
	points[23] = (0, -13300, -350);
	angles[23] = (0, -175.6321, 0);
	at[23] = 6.7000;
	points[24] = (0, -13300, -350);
	angles[24] = (0, -152.0482, 0);
	at[24] = 7.0500;
	points[25] = (0, -13300, -350);
	angles[25] = (0, -94.9628, 0);
	at[25] = 7.8500;
	points[26] = (0, -13300, -350);
	angles[26] = (0, -74.2527, 0);
	at[26] = 8.1500;
	points[27] = (0, -13300, -350);
	angles[27] = (0, -54.8905, 0);
	at[27] = 8.4500;
	points[28] = (0, -13300, -350);
	angles[28] = (0, -37.4981, 0);
	at[28] = 8.7500;
	points[29] = (0, -13300, -350);
	angles[29] = (0, -20.5268, 0);
	at[29] = 9.1000;
	points[30] = (0, -13300, -350);
	angles[30] = (0, -9.5367, 0);
	at[30] = 9.4000;
	points[31] = (0, -13300, -350);
	angles[31] = (0, -5.4802, 0);
	at[31] = 9.5500;
	points[32] = (0, -13300, -350);
	angles[32] = (0, -2.4865, 0);
	at[32] = 9.7000;
	points[33] = (0, -13300, -350);
	angles[33] = (0, -0.6332, 0);
	at[33] = 9.8500;
	points[34] = (0, -13300, -350);
	angles[34] = (0, 0.0018, 0);
	at[34] = 10;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -9800, -210);
	angles[0] = (0, 0.0037, 0);
	at[0] = 0;
	points[1] = (0, -9800, -210);
	angles[1] = (0, -1.2405, 0);
	at[1] = 0.3000;
	points[2] = (0, -9800, -210);
	angles[2] = (0, -4.7656, 0);
	at[2] = 0.6000;
	points[3] = (0, -9800, -210);
	angles[3] = (0, -10.2607, 0);
	at[3] = 0.9000;
	points[4] = (0, -9800, -210);
	angles[4] = (0, -18.7464, 0);
	at[4] = 1.2500;
	points[5] = (0, -9800, -210);
	angles[5] = (0, -37.1237, 0);
	at[5] = 1.8500;
	points[6] = (0, -9800, -210);
	angles[6] = (0, -87.8132, 0);
	at[6] = 3.3000;
	points[7] = (0, -9800, -210);
	angles[7] = (0, -98.4763, 0);
	at[7] = 3.6500;
	points[8] = (0, -9800, -210);
	angles[8] = (0, -106.3430, 0);
	at[8] = 3.9500;
	points[9] = (0, -9800, -210);
	angles[9] = (0, -112.7064, 0);
	at[9] = 4.2500;
	points[10] = (0, -9800, -210);
	angles[10] = (0, -116.6364, 0);
	at[10] = 4.5000;
	points[11] = (0, -9800, -210);
	angles[11] = (0, -119.1263, 0);
	at[11] = 4.7500;
	points[12] = (0, -9800, -210);
	angles[12] = (0, -119.9963, 0);
	at[12] = 5;
	points[13] = (0, -9800, -210);
	angles[13] = (0, -119.1263, 0);
	at[13] = 5.2500;
	points[14] = (0, -9800, -210);
	angles[14] = (0, -116.6364, 0);
	at[14] = 5.5000;
	points[15] = (0, -9800, -210);
	angles[15] = (0, -112.7064, 0);
	at[15] = 5.7500;
	points[16] = (0, -9800, -210);
	angles[16] = (0, -106.3429, 0);
	at[16] = 6.0500;
	points[17] = (0, -9800, -210);
	angles[17] = (0, -98.4763, 0);
	at[17] = 6.3500;
	points[18] = (0, -9800, -210);
	angles[18] = (0, -87.8132, 0);
	at[18] = 6.7000;
	points[19] = (0, -9800, -210);
	angles[19] = (0, -37.1237, 0);
	at[19] = 8.1500;
	points[20] = (0, -9800, -210);
	angles[20] = (0, -18.7464, 0);
	at[20] = 8.7500;
	points[21] = (0, -9800, -210);
	angles[21] = (0, -10.2607, 0);
	at[21] = 9.1000;
	points[22] = (0, -9800, -210);
	angles[22] = (0, -4.7656, 0);
	at[22] = 9.4000;
	points[23] = (0, -9800, -210);
	angles[23] = (0, -1.2405, 0);
	at[23] = 9.7000;
	points[24] = (0, -9800, -210);
	angles[24] = (0, 0.0037, 0);
	at[24] = 10;
	mover = getEnt("iz_mover4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -6300, -70);
	angles[0] = (0, 0.0018, 0);
	at[0] = 0;
	points[1] = (0, -6300, -70);
	angles[1] = (0, -0.6203, 0);
	at[1] = 0.3000;
	points[2] = (0, -6300, -70);
	angles[2] = (0, -2.3828, 0);
	at[2] = 0.6000;
	points[3] = (0, -6300, -70);
	angles[3] = (0, -9.3732, 0);
	at[3] = 1.2500;
	points[4] = (0, -6300, -70);
	angles[4] = (0, -18.5618, 0);
	at[4] = 1.8500;
	points[5] = (0, -6300, -70);
	angles[5] = (0, -43.9066, 0);
	at[5] = 3.3000;
	points[6] = (0, -6300, -70);
	angles[6] = (0, -53.1716, 0);
	at[6] = 3.9500;
	points[7] = (0, -6300, -70);
	angles[7] = (0, -58.3181, 0);
	at[7] = 4.5000;
	points[8] = (0, -6300, -70);
	angles[8] = (0, -59.9981, 0);
	at[8] = 5;
	points[9] = (0, -6300, -70);
	angles[9] = (0, -58.3181, 0);
	at[9] = 5.5000;
	points[10] = (0, -6300, -70);
	angles[10] = (0, -53.1716, 0);
	at[10] = 6.0500;
	points[11] = (0, -6300, -70);
	angles[11] = (0, -43.9066, 0);
	at[11] = 6.7000;
	points[12] = (0, -6300, -70);
	angles[12] = (0, -18.5618, 0);
	at[12] = 8.1500;
	points[13] = (0, -6300, -70);
	angles[13] = (0, -9.3732, 0);
	at[13] = 8.7500;
	points[14] = (0, -6300, -70);
	angles[14] = (0, -2.3828, 0);
	at[14] = 9.4000;
	points[15] = (0, -6300, -70);
	angles[15] = (0, -0.6202, 0);
	at[15] = 9.7000;
	points[16] = (0, -6300, -70);
	angles[16] = (0, 0.0018, 0);
	at[16] = 10;
	mover = getEnt("iz_mover5", "targetname");
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
