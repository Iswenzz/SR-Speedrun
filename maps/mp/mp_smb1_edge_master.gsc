main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_edge_master", 0);

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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (175, 0, 210);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (175, 0, 210);
	angles[1] = (0, 0, 0);
	at[1] = 4.8000;
	points[2] = (175, 0, 208.0594);
	angles[2] = (0, 0, 0);
	at[2] = 4.8500;
	points[3] = (175, 0, 202.7929);
	angles[3] = (0, 0, 0);
	at[3] = 4.9000;
	points[4] = (175, 0, 195.0311);
	angles[4] = (0, 0, 0);
	at[4] = 4.9500;
	points[5] = (175, 0, 185.6063);
	angles[5] = (0, 0, 0);
	at[5] = 5;
	points[6] = (175, 0, 165.0937);
	angles[6] = (0, 0, 0);
	at[6] = 5.1000;
	points[7] = (175, 0, 155.6689);
	angles[7] = (0, 0, 0);
	at[7] = 5.1500;
	points[8] = (175, 0, 147.9071);
	angles[8] = (0, 0, 0);
	at[8] = 5.2000;
	points[9] = (175, 0, 142.6405);
	angles[9] = (0, 0, 0);
	at[9] = 5.2500;
	points[10] = (175, 0, 140.7000);
	angles[10] = (0, 0, 0);
	at[10] = 5.3000;
	points[11] = (175, 0, 141.3181);
	angles[11] = (0, 0, 0);
	at[11] = 5.4500;
	points[12] = (175, 0, 143.0764);
	angles[12] = (0, 0, 0);
	at[12] = 5.6000;
	points[13] = (175, 0, 149.4457);
	angles[13] = (0, 0, 0);
	at[13] = 5.9000;
	points[14] = (175, 0, 160.4008);
	angles[14] = (0, 0, 0);
	at[14] = 6.2500;
	points[15] = (175, 0, 188.5232);
	angles[15] = (0, 0, 0);
	at[15] = 7;
	points[16] = (175, 0, 198.4409);
	angles[16] = (0, 0, 0);
	at[16] = 7.3000;
	points[17] = (175, 0, 203.7504);
	angles[17] = (0, 0, 0);
	at[17] = 7.5000;
	points[18] = (175, 0, 206.8087);
	angles[18] = (0, 0, 0);
	at[18] = 7.6500;
	points[19] = (175, 0, 208.9157);
	angles[19] = (0, 0, 0);
	at[19] = 7.8000;
	points[20] = (175, 0, 209.9291);
	angles[20] = (0, 0, 0);
	at[20] = 7.9500;
	points[21] = (175, 0, 210);
	angles[21] = (0, 0, 0);
	at[21] = 10.5000;
	points[22] = (175, 0, 208.0594);
	angles[22] = (0, 0, 0);
	at[22] = 10.5500;
	points[23] = (175, 0, 202.7929);
	angles[23] = (0, 0, 0);
	at[23] = 10.6000;
	points[24] = (175, 0, 195.0311);
	angles[24] = (0, 0, 0);
	at[24] = 10.6500;
	points[25] = (175, 0, 185.6063);
	angles[25] = (0, 0, 0);
	at[25] = 10.7000;
	points[26] = (175, 0, 165.0937);
	angles[26] = (0, 0, 0);
	at[26] = 10.8000;
	points[27] = (175, 0, 155.6689);
	angles[27] = (0, 0, 0);
	at[27] = 10.8500;
	points[28] = (175, 0, 147.9071);
	angles[28] = (0, 0, 0);
	at[28] = 10.9000;
	points[29] = (175, 0, 142.6405);
	angles[29] = (0, 0, 0);
	at[29] = 10.9500;
	points[30] = (175, 0, 140.7000);
	angles[30] = (0, 0, 0);
	at[30] = 11;
	points[31] = (175, 0, 141.3181);
	angles[31] = (0, 0, 0);
	at[31] = 11.1500;
	points[32] = (175, 0, 143.0764);
	angles[32] = (0, 0, 0);
	at[32] = 11.3000;
	points[33] = (175, 0, 145.8331);
	angles[33] = (0, 0, 0);
	at[33] = 11.4500;
	points[34] = (175, 0, 150.8150);
	angles[34] = (0, 0, 0);
	at[34] = 11.6500;
	points[35] = (175, 0, 162.1768);
	angles[35] = (0, 0, 0);
	at[35] = 12;
	points[36] = (175, 0, 186.7095);
	angles[36] = (0, 0, 0);
	at[36] = 12.6500;
	points[37] = (175, 0, 195.3531);
	angles[37] = (0, 0, 0);
	at[37] = 12.9000;
	points[38] = (175, 0, 203.7504);
	angles[38] = (0, 0, 0);
	at[38] = 13.2000;
	points[39] = (175, 0, 208.3276);
	angles[39] = (0, 0, 0);
	at[39] = 13.4500;
	points[40] = (175, 0, 210);
	angles[40] = (0, 0, 0);
	at[40] = 13.7000;
	points[41] = (175, 0, 210);
	angles[41] = (0, 0, 0);
	at[41] = 16.2000;
	points[42] = (175, 0, 208.0594);
	angles[42] = (0, 0, 0);
	at[42] = 16.2500;
	points[43] = (175, 0, 202.7929);
	angles[43] = (0, 0, 0);
	at[43] = 16.3000;
	points[44] = (175, 0, 195.0311);
	angles[44] = (0, 0, 0);
	at[44] = 16.3500;
	points[45] = (175, 0, 155.6689);
	angles[45] = (0, 0, 0);
	at[45] = 16.5500;
	points[46] = (175, 0, 147.9071);
	angles[46] = (0, 0, 0);
	at[46] = 16.6000;
	points[47] = (175, 0, 142.6405);
	angles[47] = (0, 0, 0);
	at[47] = 16.6500;
	points[48] = (175, 0, 140.7000);
	angles[48] = (0, 0, 0);
	at[48] = 16.7000;
	points[49] = (175, 0, 141.3658);
	angles[49] = (0, 0, 0);
	at[49] = 16.8500;
	points[50] = (175, 0, 143.2551);
	angles[50] = (0, 0, 0);
	at[50] = 17;
	points[51] = (175, 0, 150.0681);
	angles[51] = (0, 0, 0);
	at[51] = 17.3000;
	points[52] = (175, 0, 161.6953);
	angles[52] = (0, 0, 0);
	at[52] = 17.6500;
	points[53] = (175, 0, 187.1311);
	angles[53] = (0, 0, 0);
	at[53] = 18.3000;
	points[54] = (175, 0, 196.0272);
	angles[54] = (0, 0, 0);
	at[54] = 18.5500;
	points[55] = (175, 0, 203.2969);
	angles[55] = (0, 0, 0);
	at[55] = 18.8000;
	points[56] = (175, 0, 208.2012);
	angles[56] = (0, 0, 0);
	at[56] = 19.0500;
	points[57] = (175, 0, 210);
	angles[57] = (0, 0, 0);
	at[57] = 19.3000;
	points[58] = (175, 0, 210);
	angles[58] = (0, 0, 0);
	at[58] = 21.8000;
	points[59] = (175, 0, 208.0594);
	angles[59] = (0, 0, 0);
	at[59] = 21.8500;
	points[60] = (175, 0, 202.7929);
	angles[60] = (0, 0, 0);
	at[60] = 21.9000;
	points[61] = (175, 0, 195.0311);
	angles[61] = (0, 0, 0);
	at[61] = 21.9500;
	points[62] = (175, 0, 155.6689);
	angles[62] = (0, 0, 0);
	at[62] = 22.1500;
	points[63] = (175, 0, 147.9071);
	angles[63] = (0, 0, 0);
	at[63] = 22.2000;
	points[64] = (175, 0, 142.6405);
	angles[64] = (0, 0, 0);
	at[64] = 22.2500;
	points[65] = (175, 0, 140.7000);
	angles[65] = (0, 0, 0);
	at[65] = 22.3000;
	points[66] = (175, 0, 142.3725);
	angles[66] = (0, 0, 0);
	at[66] = 22.5500;
	points[67] = (175, 0, 148.1551);
	angles[67] = (0, 0, 0);
	at[67] = 22.8500;
	points[68] = (175, 0, 158.6669);
	angles[68] = (0, 0, 0);
	at[68] = 23.2000;
	points[69] = (175, 0, 188.5232);
	angles[69] = (0, 0, 0);
	at[69] = 24;
	points[70] = (175, 0, 199.8850);
	angles[70] = (0, 0, 0);
	at[70] = 24.3500;
	points[71] = (175, 0, 204.8669);
	angles[71] = (0, 0, 0);
	at[71] = 24.5500;
	points[72] = (175, 0, 207.6236);
	angles[72] = (0, 0, 0);
	at[72] = 24.7000;
	points[73] = (175, 0, 209.3819);
	angles[73] = (0, 0, 0);
	at[73] = 24.8500;
	points[74] = (175, 0, 210);
	angles[74] = (0, 0, 0);
	at[74] = 25;
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
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -0.0105);
	at[1] = 5.3500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -1.6859);
	at[2] = 5.5500;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -7.3041);
	at[3] = 5.8000;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -16.0073);
	at[4] = 6.0500;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -29.2702);
	at[5] = 6.3500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -59.1278);
	at[6] = 6.9500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -70.5600);
	at[7] = 7.2000;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -81.6944);
	at[8] = 7.5000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -87.7752);
	at[9] = 7.7500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -89.6298);
	at[10] = 7.9000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -90);
	at[11] = 8;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -90);
	at[12] = 11;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -90.3701);
	at[13] = 11.1000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -92.2248);
	at[14] = 11.2500;
	points[15] = (0, 0, 0);
	angles[15] = (0, 0, -96.8236);
	at[15] = 11.4500;
	points[16] = (0, 0, 0);
	angles[16] = (0, 0, -105.3489);
	at[16] = 11.7000;
	points[17] = (0, 0, 0);
	angles[17] = (0, 0, -118.4766);
	at[17] = 12;
	points[18] = (0, 0, 0);
	angles[18] = (0, 0, -148.3200);
	at[18] = 12.6000;
	points[19] = (0, 0, 0);
	angles[19] = (0, 0, -159.8471);
	at[19] = 12.8500;
	points[20] = (0, 0, 0);
	angles[20] = (0, 0, -171.1736);
	at[20] = 13.1500;
	points[21] = (0, 0, 0);
	angles[21] = (0, 0, -177.4800);
	at[21] = 13.4000;
	points[22] = (0, 0, 0);
	angles[22] = (0, 0, -179.4983);
	at[22] = 13.5500;
	points[23] = (0, 0, 0);
	angles[23] = (0, 0, -179.9895);
	at[23] = 13.6500;
	points[24] = (0, 0, 0);
	angles[24] = (0, 0, -180);
	at[24] = 16.6500;
	points[25] = (0, 0, 0);
	angles[25] = (0, 0, -180.2582);
	at[25] = 16.7500;
	points[26] = (0, 0, 0);
	angles[26] = (0, 0, -181.9466);
	at[26] = 16.9000;
	points[27] = (0, 0, 0);
	angles[27] = (0, 0, -187.7981);
	at[27] = 17.1500;
	points[28] = (0, 0, 0);
	angles[28] = (0, 0, -196.6753);
	at[28] = 17.4000;
	points[29] = (0, 0, 0);
	angles[29] = (0, 0, -210.0688);
	at[29] = 17.7000;
	points[30] = (0, 0, 0);
	angles[30] = (0, 0, -237.5080);
	at[30] = 18.2500;
	points[31] = (0, 0, 0);
	angles[31] = (0, 0, -249.1260);
	at[31] = 18.5000;
	points[32] = (0, 0, 0);
	angles[32] = (0, 0, -258.9642);
	at[32] = 18.7500;
	points[33] = (0, 0, 0);
	angles[33] = (0, 0, -266.1328);
	at[33] = 19;
	points[34] = (0, 0, 0);
	angles[34] = (0, 0, -268.7823);
	at[34] = 19.1500;
	points[35] = (0, 0, 0);
	angles[35] = (0, 0, -269.9581);
	at[35] = 19.3000;
	points[36] = (0, 0, 0);
	angles[36] = (0, 0, -270.0105);
	at[36] = 22.3500;
	points[37] = (0, 0, 0);
	angles[37] = (0, 0, -271.6859);
	at[37] = 22.5500;
	points[38] = (0, 0, 0);
	angles[38] = (0, 0, -277.3041);
	at[38] = 22.8000;
	points[39] = (0, 0, 0);
	angles[39] = (0, 0, -288.0399);
	at[39] = 23.1000;
	points[40] = (0, 0, 0);
	angles[40] = (0, 0, -301.6800);
	at[40] = 23.4000;
	points[41] = (0, 0, 0);
	angles[41] = (0, 0, -333.8716);
	at[41] = 24.0500;
	points[42] = (0, 0, 0);
	angles[42] = (0, 0, -348.3815);
	at[42] = 24.4000;
	points[43] = (0, 0, 0);
	angles[43] = (0, 0, -353.1763);
	at[43] = 24.5500;
	points[44] = (0, 0, 0);
	angles[44] = (0, 0, -356.8392);
	at[44] = 24.7000;
	points[45] = (0, 0, 0);
	angles[45] = (0, 0, -359.1777);
	at[45] = 24.8500;
	points[46] = (0, 0, 0);
	angles[46] = (0, 0, -360);
	at[46] = 25;
	mover = getEnt("iz_mover1", "targetname");
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
