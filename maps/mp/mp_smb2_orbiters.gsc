main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_orbiters", 0);

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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -6790, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -6790, 0);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (0, -6790, 0);
	angles[2] = (1.3050, 0, 0);
	at[2] = 1.0500;
	points[3] = (0, -6790, 0);
	angles[3] = (5.0400, 0, 0);
	at[3] = 1.1000;
	points[4] = (0, -6790, 0);
	angles[4] = (10.9350, 0, 0);
	at[4] = 1.1500;
	points[5] = (0, -6790, 0);
	angles[5] = (18.7200, 0, 0);
	at[5] = 1.2000;
	points[6] = (0, -6790, 0);
	angles[6] = (28.1250, 0, 0);
	at[6] = 1.2500;
	points[7] = (0, -6790, 0);
	angles[7] = (38.8799, 0, 0);
	at[7] = 1.3000;
	points[8] = (0, -6790, 0);
	angles[8] = (63.3601, 0, 0);
	at[8] = 1.4000;
	points[9] = (0, -6790, 0);
	angles[9] = (103.4550, 0, 0);
	at[9] = 1.5500;
	points[10] = (0, -6790, 0);
	angles[10] = (129.2850, 0, 0);
	at[10] = 1.6500;
	points[11] = (0, -6790, 0);
	angles[11] = (141.1201, 0, 0);
	at[11] = 1.7000;
	points[12] = (0, -6790, 0);
	angles[12] = (151.8750, 0, 0);
	at[12] = 1.7500;
	points[13] = (0, -6790, 0);
	angles[13] = (161.2800, 0, 0);
	at[13] = 1.8000;
	points[14] = (0, -6790, 0);
	angles[14] = (169.0650, 0, 0);
	at[14] = 1.8500;
	points[15] = (0, -6790, 0);
	angles[15] = (174.9600, 0, 0);
	at[15] = 1.9000;
	points[16] = (0, -6790, 0);
	angles[16] = (178.6950, 0, 0);
	at[16] = 1.9500;
	points[17] = (0, -6790, 0);
	angles[17] = (180, 0, 0);
	at[17] = 2;
	points[18] = (0, -6790, 0);
	angles[18] = (180, 0, 0);
	at[18] = 5;
	points[19] = (0, -6790, 0);
	angles[19] = (181.3050, 0, 0);
	at[19] = 5.0500;
	points[20] = (0, -6790, 0);
	angles[20] = (185.0400, 0, 0);
	at[20] = 5.1000;
	points[21] = (0, -6790, 0);
	angles[21] = (190.9350, 0, 0);
	at[21] = 5.1500;
	points[22] = (0, -6790, 0);
	angles[22] = (198.7200, 0, 0);
	at[22] = 5.2000;
	points[23] = (0, -6790, 0);
	angles[23] = (208.1250, 0, 0);
	at[23] = 5.2500;
	points[24] = (0, -6790, 0);
	angles[24] = (218.8801, 0, 0);
	at[24] = 5.3000;
	points[25] = (0, -6790, 0);
	angles[25] = (230.7150, 0, 0);
	at[25] = 5.3500;
	points[26] = (0, -6790, 0);
	angles[26] = (309.2850, 0, 0);
	at[26] = 5.6500;
	points[27] = (0, -6790, 0);
	angles[27] = (321.1200, 0, 0);
	at[27] = 5.7000;
	points[28] = (0, -6790, 0);
	angles[28] = (331.8750, 0, 0);
	at[28] = 5.7500;
	points[29] = (0, -6790, 0);
	angles[29] = (341.2800, 0, 0);
	at[29] = 5.8000;
	points[30] = (0, -6790, 0);
	angles[30] = (349.0650, 0, 0);
	at[30] = 5.8500;
	points[31] = (0, -6790, 0);
	angles[31] = (354.9600, 0, 0);
	at[31] = 5.9000;
	points[32] = (0, -6790, 0);
	angles[32] = (358.6949, 0, 0);
	at[32] = 5.9500;
	points[33] = (0, -6790, 0);
	angles[33] = (360, 0, 0);
	at[33] = 6;
	points[34] = (0, -6790, 0);
	angles[34] = (360, 0, 0);
	at[34] = 8;
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
	points[0] = (0, -6790, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -6790, 0);
	angles[1] = (0, 0, -1.3050);
	at[1] = 0.0500;
	points[2] = (0, -6790, 0);
	angles[2] = (0, 0, -5.0400);
	at[2] = 0.1000;
	points[3] = (0, -6790, 0);
	angles[3] = (0, 0, -10.9350);
	at[3] = 0.1500;
	points[4] = (0, -6790, 0);
	angles[4] = (0, 0, -18.7200);
	at[4] = 0.2000;
	points[5] = (0, -6790, 0);
	angles[5] = (0, 0, -28.1250);
	at[5] = 0.2500;
	points[6] = (0, -6790, 0);
	angles[6] = (0, 0, -38.8801);
	at[6] = 0.3000;
	points[7] = (0, -6790, 0);
	angles[7] = (0, 0, -50.7150);
	at[7] = 0.3500;
	points[8] = (0, -6790, 0);
	angles[8] = (0, 0, -129.2850);
	at[8] = 0.6500;
	points[9] = (0, -6790, 0);
	angles[9] = (0, 0, -141.1199);
	at[9] = 0.7000;
	points[10] = (0, -6790, 0);
	angles[10] = (0, 0, -151.8750);
	at[10] = 0.7500;
	points[11] = (0, -6790, 0);
	angles[11] = (0, 0, -161.2800);
	at[11] = 0.8000;
	points[12] = (0, -6790, 0);
	angles[12] = (0, 0, -169.0650);
	at[12] = 0.8500;
	points[13] = (0, -6790, 0);
	angles[13] = (0, 0, -174.9600);
	at[13] = 0.9000;
	points[14] = (0, -6790, 0);
	angles[14] = (0, 0, -178.6950);
	at[14] = 0.9500;
	points[15] = (0, -6790, 0);
	angles[15] = (0, 0, -180);
	at[15] = 1;
	points[16] = (0, -6790, 0);
	angles[16] = (0, 0, -180);
	at[16] = 4;
	points[17] = (0, -6790, 0);
	angles[17] = (0, 0, -181.3050);
	at[17] = 4.0500;
	points[18] = (0, -6790, 0);
	angles[18] = (0, 0, -185.0400);
	at[18] = 4.1000;
	points[19] = (0, -6790, 0);
	angles[19] = (0, 0, -190.9350);
	at[19] = 4.1500;
	points[20] = (0, -6790, 0);
	angles[20] = (0, 0, -198.7200);
	at[20] = 4.2000;
	points[21] = (0, -6790, 0);
	angles[21] = (0, 0, -208.1250);
	at[21] = 4.2500;
	points[22] = (0, -6790, 0);
	angles[22] = (0, 0, -218.8801);
	at[22] = 4.3000;
	points[23] = (0, -6790, 0);
	angles[23] = (0, 0, -230.7150);
	at[23] = 4.3500;
	points[24] = (0, -6790, 0);
	angles[24] = (0, 0, -256.5450);
	at[24] = 4.4500;
	points[25] = (0, -6790, 0);
	angles[25] = (0, 0, -296.6400);
	at[25] = 4.6000;
	points[26] = (0, -6790, 0);
	angles[26] = (0, 0, -321.1199);
	at[26] = 4.7000;
	points[27] = (0, -6790, 0);
	angles[27] = (0, 0, -331.8751);
	at[27] = 4.7500;
	points[28] = (0, -6790, 0);
	angles[28] = (0, 0, -341.2800);
	at[28] = 4.8000;
	points[29] = (0, -6790, 0);
	angles[29] = (0, 0, -349.0650);
	at[29] = 4.8500;
	points[30] = (0, -6790, 0);
	angles[30] = (0, 0, -354.9600);
	at[30] = 4.9000;
	points[31] = (0, -6790, 0);
	angles[31] = (0, 0, -358.6949);
	at[31] = 4.9500;
	points[32] = (0, -6790, 0);
	angles[32] = (0, 0, -360);
	at[32] = 5;
	points[33] = (0, -6790, 0);
	angles[33] = (0, 0, -360);
	at[33] = 8;
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
	points[0] = (0, -6790, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -6790, 0);
	angles[1] = (0, 0, 0);
	at[1] = 3;
	points[2] = (0, -6790, 0);
	angles[2] = (-1.3050, 0, 0);
	at[2] = 3.0500;
	points[3] = (0, -6790, 0);
	angles[3] = (-5.0400, 0, 0);
	at[3] = 3.1000;
	points[4] = (0, -6790, 0);
	angles[4] = (-10.9350, 0, 0);
	at[4] = 3.1500;
	points[5] = (0, -6790, 0);
	angles[5] = (-18.7200, 0, 0);
	at[5] = 3.2000;
	points[6] = (0, -6790, 0);
	angles[6] = (-28.1250, 0, 0);
	at[6] = 3.2500;
	points[7] = (0, -6790, 0);
	angles[7] = (-38.8799, 0, 0);
	at[7] = 3.3000;
	points[8] = (0, -6790, 0);
	angles[8] = (-50.7150, 0, 0);
	at[8] = 3.3500;
	points[9] = (0, -6790, 0);
	angles[9] = (-76.5450, 0, 0);
	at[9] = 3.4500;
	points[10] = (0, -6790, 0);
	angles[10] = (-116.6399, 0, 0);
	at[10] = 3.6000;
	points[11] = (0, -6790, 0);
	angles[11] = (-141.1201, 0, 0);
	at[11] = 3.7000;
	points[12] = (0, -6790, 0);
	angles[12] = (-151.8750, 0, 0);
	at[12] = 3.7500;
	points[13] = (0, -6790, 0);
	angles[13] = (-161.2800, 0, 0);
	at[13] = 3.8000;
	points[14] = (0, -6790, 0);
	angles[14] = (-169.0650, 0, 0);
	at[14] = 3.8500;
	points[15] = (0, -6790, 0);
	angles[15] = (-174.9600, 0, 0);
	at[15] = 3.9000;
	points[16] = (0, -6790, 0);
	angles[16] = (-178.6950, 0, 0);
	at[16] = 3.9500;
	points[17] = (0, -6790, 0);
	angles[17] = (-180, 0, 0);
	at[17] = 4;
	points[18] = (0, -6790, 0);
	angles[18] = (-180, 0, 0);
	at[18] = 7;
	points[19] = (0, -6790, 0);
	angles[19] = (-181.3050, 0, 0);
	at[19] = 7.0500;
	points[20] = (0, -6790, 0);
	angles[20] = (-185.0400, 0, 0);
	at[20] = 7.1000;
	points[21] = (0, -6790, 0);
	angles[21] = (-190.9350, 0, 0);
	at[21] = 7.1500;
	points[22] = (0, -6790, 0);
	angles[22] = (-198.7200, 0, 0);
	at[22] = 7.2000;
	points[23] = (0, -6790, 0);
	angles[23] = (-208.1250, 0, 0);
	at[23] = 7.2500;
	points[24] = (0, -6790, 0);
	angles[24] = (-218.8801, 0, 0);
	at[24] = 7.3000;
	points[25] = (0, -6790, 0);
	angles[25] = (-230.7151, 0, 0);
	at[25] = 7.3500;
	points[26] = (0, -6790, 0);
	angles[26] = (-256.5450, 0, 0);
	at[26] = 7.4500;
	points[27] = (0, -6790, 0);
	angles[27] = (-296.6400, 0, 0);
	at[27] = 7.6000;
	points[28] = (0, -6790, 0);
	angles[28] = (-321.1200, 0, 0);
	at[28] = 7.7000;
	points[29] = (0, -6790, 0);
	angles[29] = (-331.8750, 0, 0);
	at[29] = 7.7500;
	points[30] = (0, -6790, 0);
	angles[30] = (-341.2801, 0, 0);
	at[30] = 7.8000;
	points[31] = (0, -6790, 0);
	angles[31] = (-349.0650, 0, 0);
	at[31] = 7.8500;
	points[32] = (0, -6790, 0);
	angles[32] = (-354.9600, 0, 0);
	at[32] = 7.9000;
	points[33] = (0, -6790, 0);
	angles[33] = (-358.6950, 0, 0);
	at[33] = 7.9500;
	points[34] = (0, -6790, 0);
	angles[34] = (-360, 0, 0);
	at[34] = 8;
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
	points[0] = (0, -6790, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -6790, 0);
	angles[1] = (0, 0, 0);
	at[1] = 2;
	points[2] = (0, -6790, 0);
	angles[2] = (0, 0, 1.3050);
	at[2] = 2.0500;
	points[3] = (0, -6790, 0);
	angles[3] = (0, 0, 5.0400);
	at[3] = 2.1000;
	points[4] = (0, -6790, 0);
	angles[4] = (0, 0, 10.9350);
	at[4] = 2.1500;
	points[5] = (0, -6790, 0);
	angles[5] = (0, 0, 18.7200);
	at[5] = 2.2000;
	points[6] = (0, -6790, 0);
	angles[6] = (0, 0, 28.1250);
	at[6] = 2.2500;
	points[7] = (0, -6790, 0);
	angles[7] = (0, 0, 38.8799);
	at[7] = 2.3000;
	points[8] = (0, -6790, 0);
	angles[8] = (0, 0, 50.7150);
	at[8] = 2.3500;
	points[9] = (0, -6790, 0);
	angles[9] = (0, 0, 76.5450);
	at[9] = 2.4500;
	points[10] = (0, -6790, 0);
	angles[10] = (0, 0, 116.6399);
	at[10] = 2.6000;
	points[11] = (0, -6790, 0);
	angles[11] = (0, 0, 141.1201);
	at[11] = 2.7000;
	points[12] = (0, -6790, 0);
	angles[12] = (0, 0, 151.8750);
	at[12] = 2.7500;
	points[13] = (0, -6790, 0);
	angles[13] = (0, 0, 161.2800);
	at[13] = 2.8000;
	points[14] = (0, -6790, 0);
	angles[14] = (0, 0, 169.0650);
	at[14] = 2.8500;
	points[15] = (0, -6790, 0);
	angles[15] = (0, 0, 174.9600);
	at[15] = 2.9000;
	points[16] = (0, -6790, 0);
	angles[16] = (0, 0, 178.6950);
	at[16] = 2.9500;
	points[17] = (0, -6790, 0);
	angles[17] = (0, 0, 180);
	at[17] = 3;
	points[18] = (0, -6790, 0);
	angles[18] = (0, 0, 180);
	at[18] = 6;
	points[19] = (0, -6790, 0);
	angles[19] = (0, 0, 181.3050);
	at[19] = 6.0500;
	points[20] = (0, -6790, 0);
	angles[20] = (0, 0, 185.0400);
	at[20] = 6.1000;
	points[21] = (0, -6790, 0);
	angles[21] = (0, 0, 190.9350);
	at[21] = 6.1500;
	points[22] = (0, -6790, 0);
	angles[22] = (0, 0, 198.7200);
	at[22] = 6.2000;
	points[23] = (0, -6790, 0);
	angles[23] = (0, 0, 208.1250);
	at[23] = 6.2500;
	points[24] = (0, -6790, 0);
	angles[24] = (0, 0, 218.8801);
	at[24] = 6.3000;
	points[25] = (0, -6790, 0);
	angles[25] = (0, 0, 230.7150);
	at[25] = 6.3500;
	points[26] = (0, -6790, 0);
	angles[26] = (0, 0, 256.5450);
	at[26] = 6.4500;
	points[27] = (0, -6790, 0);
	angles[27] = (0, 0, 296.6400);
	at[27] = 6.6000;
	points[28] = (0, -6790, 0);
	angles[28] = (0, 0, 321.1200);
	at[28] = 6.7000;
	points[29] = (0, -6790, 0);
	angles[29] = (0, 0, 331.8750);
	at[29] = 6.7500;
	points[30] = (0, -6790, 0);
	angles[30] = (0, 0, 341.2800);
	at[30] = 6.8000;
	points[31] = (0, -6790, 0);
	angles[31] = (0, 0, 349.0650);
	at[31] = 6.8500;
	points[32] = (0, -6790, 0);
	angles[32] = (0, 0, 354.9600);
	at[32] = 6.9000;
	points[33] = (0, -6790, 0);
	angles[33] = (0, 0, 358.6949);
	at[33] = 6.9500;
	points[34] = (0, -6790, 0);
	angles[34] = (0, 0, 360);
	at[34] = 7;
	points[35] = (0, -6790, 0);
	angles[35] = (0, 0, 360);
	at[35] = 8;
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
