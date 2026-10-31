main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_breathe", 0);

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
	ambientPlay("iz_0_st5", 2);
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
	thread iz_mover6();
	thread iz_mover7();
	thread iz_mover8();
	thread iz_mover9();
	thread iz_mover10();
	thread iz_mover11();
	thread iz_mover12();
	thread iz_mover13();
	thread iz_mover14();
	thread iz_mover15();
	thread iz_mover16();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 560, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 560, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, 560, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, 560, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, 560, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, 560, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, 560, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, 560, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, 560, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, 560, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, 560, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, 560, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, 560, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, 560, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, 560, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, 560, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, 560, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, 560, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
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
	points[0] = (0, 840, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 840, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, 840, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, 840, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, 840, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, 840, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, 840, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, 840, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, 840, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, 840, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, 840, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, 840, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, 840, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, 840, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, 840, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, 840, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, 840, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, 840, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
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
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, 0, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, 0, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, 0, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
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
	points[0] = (0, -560, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -560, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, -560, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, -560, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, -560, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, -560, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, -560, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, -560, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, -560, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, -560, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, -560, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, -560, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, -560, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, -560, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, -560, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, -560, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, -560, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, -560, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
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
	points[0] = (0, -1120, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -1120, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, -1120, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, -1120, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, -1120, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, -1120, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, -1120, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, -1120, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, -1120, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, -1120, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, -1120, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, -1120, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, -1120, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, -1120, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, -1120, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, -1120, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, -1120, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, -1120, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
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
	points[0] = (0, 280, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 280, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, 280, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, 280, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, 280, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, 280, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, 280, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, 280, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, 280, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, 280, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, 280, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, 280, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, 280, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, 280, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, 280, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, 280, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, 280, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, 280, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -280, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -280, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, -280, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, -280, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, -280, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, -280, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, -280, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, -280, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, -280, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, -280, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, -280, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, -280, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, -280, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, -280, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, -280, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, -280, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, -280, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, -280, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -840, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -840, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, -840, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, -840, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, -840, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, -840, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, -840, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, -840, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, -840, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, -840, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, -840, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, -840, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, -840, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, -840, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, -840, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, -840, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, -840, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, -840, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -1400, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -1400, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, -1400, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, -1400, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, -1400, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, -1400, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, -1400, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, -1400, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, -1400, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, -1400, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, -1400, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, -1400, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, -1400, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, -1400, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, -1400, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, -1400, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, -1400, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, -1400, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, 0, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, 0, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, 0, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 1120, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 1120, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, 1120, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, 1120, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, 1120, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, 1120, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, 1120, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, 1120, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, 1120, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, 1120, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, 1120, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, 1120, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, 1120, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, 1120, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, 1120, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, 1120, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, 1120, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, 1120, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 840, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 840, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, 840, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, 840, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, 840, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, 840, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, 840, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, 840, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, 840, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, 840, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, 840, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, 840, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, 840, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, 840, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, 840, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, 840, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, 840, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, 840, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -560, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -560, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, -560, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, -560, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, -560, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, -560, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, -560, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, -560, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, -560, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, -560, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, -560, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, -560, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, -560, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, -560, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, -560, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, -560, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, -560, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, -560, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 280, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 280, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, 280, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, 280, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, 280, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, 280, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, 280, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, 280, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, 280, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, 280, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, 280, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, 280, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, 280, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, 280, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, 280, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, 280, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, 280, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, 280, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -280, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -280, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, -280, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, -280, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, -280, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, -280, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, -280, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, -280, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, -280, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, -280, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, -280, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, -280, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, -280, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, -280, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, -280, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, -280, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, -280, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, -280, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -1400, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -1400, 0);
	angles[1] = (0, 0, -0.4350);
	at[1] = 2.0500;
	points[2] = (0, -1400, 0);
	angles[2] = (0, 0, -3.6450);
	at[2] = 2.1500;
	points[3] = (0, -1400, 0);
	angles[3] = (0, 0, -6.2400);
	at[3] = 2.2000;
	points[4] = (0, -1400, 0);
	angles[4] = (0, 0, -12.9599);
	at[4] = 2.3000;
	points[5] = (0, -1400, 0);
	angles[5] = (0, 0, -43.0949);
	at[5] = 2.6500;
	points[6] = (0, -1400, 0);
	angles[6] = (0, 0, -50.6250);
	at[6] = 2.7500;
	points[7] = (0, -1400, 0);
	angles[7] = (0, 0, -56.3551);
	at[7] = 2.8500;
	points[8] = (0, -1400, 0);
	angles[8] = (0, 0, -58.3200);
	at[8] = 2.9000;
	points[9] = (0, -1400, 0);
	angles[9] = (0, 0, -60);
	at[9] = 3;
	points[10] = (0, -1400, 0);
	angles[10] = (0, 0, -58.3200);
	at[10] = 3.1000;
	points[11] = (0, -1400, 0);
	angles[11] = (0, 0, -56.3551);
	at[11] = 3.1500;
	points[12] = (0, -1400, 0);
	angles[12] = (0, 0, -50.6250);
	at[12] = 3.2500;
	points[13] = (0, -1400, 0);
	angles[13] = (0, 0, -38.8799);
	at[13] = 3.4000;
	points[14] = (0, -1400, 0);
	angles[14] = (0, 0, -16.9050);
	at[14] = 3.6500;
	points[15] = (0, -1400, 0);
	angles[15] = (0, 0, -6.2400);
	at[15] = 3.8000;
	points[16] = (0, -1400, 0);
	angles[16] = (0, 0, -1.6800);
	at[16] = 3.9000;
	points[17] = (0, -1400, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 1120, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 1120, 0);
	angles[1] = (0, 0, -1.6800);
	at[1] = 0.1000;
	points[2] = (0, 1120, 0);
	angles[2] = (0, 0, -6.2400);
	at[2] = 0.2000;
	points[3] = (0, 1120, 0);
	angles[3] = (0, 0, -16.9050);
	at[3] = 0.3500;
	points[4] = (0, 1120, 0);
	angles[4] = (0, 0, -38.8801);
	at[4] = 0.6000;
	points[5] = (0, 1120, 0);
	angles[5] = (0, 0, -50.6250);
	at[5] = 0.7500;
	points[6] = (0, 1120, 0);
	angles[6] = (0, 0, -56.3551);
	at[6] = 0.8500;
	points[7] = (0, 1120, 0);
	angles[7] = (0, 0, -58.3200);
	at[7] = 0.9000;
	points[8] = (0, 1120, 0);
	angles[8] = (0, 0, -60);
	at[8] = 1;
	points[9] = (0, 1120, 0);
	angles[9] = (0, 0, -58.3200);
	at[9] = 1.1000;
	points[10] = (0, 1120, 0);
	angles[10] = (0, 0, -56.3551);
	at[10] = 1.1500;
	points[11] = (0, 1120, 0);
	angles[11] = (0, 0, -50.6250);
	at[11] = 1.2500;
	points[12] = (0, 1120, 0);
	angles[12] = (0, 0, -43.0949);
	at[12] = 1.3500;
	points[13] = (0, 1120, 0);
	angles[13] = (0, 0, -12.9599);
	at[13] = 1.7000;
	points[14] = (0, 1120, 0);
	angles[14] = (0, 0, -6.2400);
	at[14] = 1.8000;
	points[15] = (0, 1120, 0);
	angles[15] = (0, 0, -3.6450);
	at[15] = 1.8500;
	points[16] = (0, 1120, 0);
	angles[16] = (0, 0, -0.4350);
	at[16] = 1.9500;
	points[17] = (0, 1120, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4;
	mover = getEnt("iz_mover16", "targetname");
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
