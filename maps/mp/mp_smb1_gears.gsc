main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_gears", 0);

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
	ambientPlay("iz_0_st2", 2);
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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3640, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3640, 0, 0);
	angles[1] = (0, 89.2800, 0);
	at[1] = 3.1000;
	points[2] = (-3640, 0, 0);
	angles[2] = (0, 133.9200, 0);
	at[2] = 4.6500;
	points[3] = (-3640, 0, 0);
	angles[3] = (0, 180, 0);
	at[3] = 6.2500;
	points[4] = (-3640, 0, 0);
	angles[4] = (0, 269.2799, 0);
	at[4] = 9.3500;
	points[5] = (-3640, 0, 0);
	angles[5] = (0, 313.9200, 0);
	at[5] = 10.9000;
	points[6] = (-3640, 0, 0);
	angles[6] = (0, 360, 0);
	at[6] = 12.5000;
	points[7] = (-3640, 0, 0);
	angles[7] = (0, 449.2800, 0);
	at[7] = 15.6000;
	points[8] = (-3640, 0, 0);
	angles[8] = (0, 493.9200, 0);
	at[8] = 17.1500;
	points[9] = (-3640, 0, 0);
	angles[9] = (0, 540, 0);
	at[9] = 18.7500;
	points[10] = (-3640, 0, 0);
	angles[10] = (0, 629.2800, 0);
	at[10] = 21.8500;
	points[11] = (-3640, 0, 0);
	angles[11] = (0, 673.9200, 0);
	at[11] = 23.4000;
	points[12] = (-3640, 0, 0);
	angles[12] = (0, 720, 0);
	at[12] = 25;
	points[13] = (-3640, 0, 0);
	angles[13] = (0, 809.2800, 0);
	at[13] = 28.1000;
	points[14] = (-3640, 0, 0);
	angles[14] = (0, 853.9199, 0);
	at[14] = 29.6500;
	points[15] = (-3640, 0, 0);
	angles[15] = (0, 900, 0);
	at[15] = 31.2500;
	points[16] = (-3640, 0, 0);
	angles[16] = (0, 989.2799, 0);
	at[16] = 34.3500;
	points[17] = (-3640, 0, 0);
	angles[17] = (0, 1033.9200, 0);
	at[17] = 35.9000;
	points[18] = (-3640, 0, 0);
	angles[18] = (0, 1080, 0);
	at[18] = 37.5000;
	points[19] = (-3640, 0, 0);
	angles[19] = (0, 1169.2798, 0);
	at[19] = 40.6000;
	points[20] = (-3640, 0, 0);
	angles[20] = (0, 1213.9200, 0);
	at[20] = 42.1500;
	points[21] = (-3640, 0, 0);
	angles[21] = (0, 1260, 0);
	at[21] = 43.7500;
	points[22] = (-3640, 0, 0);
	angles[22] = (0, 1349.2799, 0);
	at[22] = 46.8500;
	points[23] = (-3640, 0, 0);
	angles[23] = (0, 1393.9200, 0);
	at[23] = 48.4000;
	points[24] = (-3640, 0, 0);
	angles[24] = (0, 1440, 0);
	at[24] = 50;
	points[25] = (-3640, 0, 0);
	angles[25] = (0, 1529.2798, 0);
	at[25] = 53.1000;
	points[26] = (-3640, 0, 0);
	angles[26] = (0, 1573.9200, 0);
	at[26] = 54.6500;
	points[27] = (-3640, 0, 0);
	angles[27] = (0, 1620, 0);
	at[27] = 56.2500;
	points[28] = (-3640, 0, 0);
	angles[28] = (0, 1709.2799, 0);
	at[28] = 59.3500;
	points[29] = (-3640, 0, 0);
	angles[29] = (0, 1753.9199, 0);
	at[29] = 60.9000;
	points[30] = (-3640, 0, 0);
	angles[30] = (0, 1800, 0);
	at[30] = 62.5000;
	points[31] = (-3640, 0, 0);
	angles[31] = (0, 1889.2800, 0);
	at[31] = 65.6000;
	points[32] = (-3640, 0, 0);
	angles[32] = (0, 1933.9199, 0);
	at[32] = 67.1500;
	points[33] = (-3640, 0, 0);
	angles[33] = (0, 1980, 0);
	at[33] = 68.7500;
	points[34] = (-3640, 0, 0);
	angles[34] = (0, 2069.2798, 0);
	at[34] = 71.8500;
	points[35] = (-3640, 0, 0);
	angles[35] = (0, 2113.9202, 0);
	at[35] = 73.4000;
	points[36] = (-3640, 0, 0);
	angles[36] = (0, 2160, 0);
	at[36] = 75;
	points[37] = (-3640, 0, 0);
	angles[37] = (0, 2249.2798, 0);
	at[37] = 78.1000;
	points[38] = (-3640, 0, 0);
	angles[38] = (0, 2293.9202, 0);
	at[38] = 79.6500;
	points[39] = (-3640, 0, 0);
	angles[39] = (0, 2340, 0);
	at[39] = 81.2500;
	points[40] = (-3640, 0, 0);
	angles[40] = (0, 2429.2798, 0);
	at[40] = 84.3500;
	points[41] = (-3640, 0, 0);
	angles[41] = (0, 2473.9202, 0);
	at[41] = 85.9000;
	points[42] = (-3640, 0, 0);
	angles[42] = (0, 2520, 0);
	at[42] = 87.5000;
	points[43] = (-3640, 0, 0);
	angles[43] = (0, 2609.2798, 0);
	at[43] = 90.6000;
	points[44] = (-3640, 0, 0);
	angles[44] = (0, 2653.9202, 0);
	at[44] = 92.1500;
	points[45] = (-3640, 0, 0);
	angles[45] = (0, 2700, 0);
	at[45] = 93.7500;
	points[46] = (-3640, 0, 0);
	angles[46] = (0, 2789.2800, 0);
	at[46] = 96.8500;
	points[47] = (-3640, 0, 0);
	angles[47] = (0, 2833.9202, 0);
	at[47] = 98.4000;
	points[48] = (-3640, 0, 0);
	angles[48] = (0, 2880, 0);
	at[48] = 100;
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
	angles[1] = (0, 45, 0);
	at[1] = 6.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 90, 0);
	at[2] = 12.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 180, 0);
	at[3] = 25;
	points[4] = (0, 0, 0);
	angles[4] = (0, 270, 0);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 315, 0);
	at[5] = 43.7500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 360, 0);
	at[6] = 50;
	points[7] = (0, 0, 0);
	angles[7] = (0, 450, 0);
	at[7] = 62.5000;
	points[8] = (0, 0, 0);
	angles[8] = (0, 540, 0);
	at[8] = 75;
	points[9] = (0, 0, 0);
	angles[9] = (0, 630, 0);
	at[9] = 87.5000;
	points[10] = (0, 0, 0);
	angles[10] = (0, 675, 0);
	at[10] = 93.7500;
	points[11] = (0, 0, 0);
	angles[11] = (0, 720, 0);
	at[11] = 100;
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
	points[0] = (-1260, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1260, 0, 0);
	angles[1] = (0, -45, 0);
	at[1] = 6.2500;
	points[2] = (-1260, 0, 0);
	angles[2] = (0, -90, 0);
	at[2] = 12.5000;
	points[3] = (-1260, 0, 0);
	angles[3] = (0, -180, 0);
	at[3] = 25;
	points[4] = (-1260, 0, 0);
	angles[4] = (0, -270, 0);
	at[4] = 37.5000;
	points[5] = (-1260, 0, 0);
	angles[5] = (0, -315, 0);
	at[5] = 43.7500;
	points[6] = (-1260, 0, 0);
	angles[6] = (0, -360, 0);
	at[6] = 50;
	points[7] = (-1260, 0, 0);
	angles[7] = (0, -450, 0);
	at[7] = 62.5000;
	points[8] = (-1260, 0, 0);
	angles[8] = (0, -540, 0);
	at[8] = 75;
	points[9] = (-1260, 0, 0);
	angles[9] = (0, -630, 0);
	at[9] = 87.5000;
	points[10] = (-1260, 0, 0);
	angles[10] = (0, -675, 0);
	at[10] = 93.7500;
	points[11] = (-1260, 0, 0);
	angles[11] = (0, -720, 0);
	at[11] = 100;
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
	points[0] = (-2240, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2240, 0, 0);
	angles[1] = (0, 44.6400, 0);
	at[1] = 3.1000;
	points[2] = (-2240, 0, 0);
	angles[2] = (0, 90, 0);
	at[2] = 6.2500;
	points[3] = (-2240, 0, 0);
	angles[3] = (0, 180, 0);
	at[3] = 12.5000;
	points[4] = (-2240, 0, 0);
	angles[4] = (0, 270, 0);
	at[4] = 18.7500;
	points[5] = (-2240, 0, 0);
	angles[5] = (0, 314.6400, 0);
	at[5] = 21.8500;
	points[6] = (-2240, 0, 0);
	angles[6] = (0, 360, 0);
	at[6] = 25;
	points[7] = (-2240, 0, 0);
	angles[7] = (0, 450, 0);
	at[7] = 31.2500;
	points[8] = (-2240, 0, 0);
	angles[8] = (0, 540, 0);
	at[8] = 37.5000;
	points[9] = (-2240, 0, 0);
	angles[9] = (0, 630, 0);
	at[9] = 43.7500;
	points[10] = (-2240, 0, 0);
	angles[10] = (0, 674.6400, 0);
	at[10] = 46.8500;
	points[11] = (-2240, 0, 0);
	angles[11] = (0, 720, 0);
	at[11] = 50;
	points[12] = (-2240, 0, 0);
	angles[12] = (0, 764.6400, 0);
	at[12] = 53.1000;
	points[13] = (-2240, 0, 0);
	angles[13] = (0, 810, 0);
	at[13] = 56.2500;
	points[14] = (-2240, 0, 0);
	angles[14] = (0, 900, 0);
	at[14] = 62.5000;
	points[15] = (-2240, 0, 0);
	angles[15] = (0, 990, 0);
	at[15] = 68.7500;
	points[16] = (-2240, 0, 0);
	angles[16] = (0, 1080, 0);
	at[16] = 75;
	points[17] = (-2240, 0, 0);
	angles[17] = (0, 1170, 0);
	at[17] = 81.2500;
	points[18] = (-2240, 0, 0);
	angles[18] = (0, 1260, 0);
	at[18] = 87.5000;
	points[19] = (-2240, 0, 0);
	angles[19] = (0, 1350, 0);
	at[19] = 93.7500;
	points[20] = (-2240, 0, 0);
	angles[20] = (0, 1440, 0);
	at[20] = 100;
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
	points[0] = (-2940, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2940, 0, 0);
	angles[1] = (0, -44.6400, 0);
	at[1] = 3.1000;
	points[2] = (-2940, 0, 0);
	angles[2] = (0, -90, 0);
	at[2] = 6.2500;
	points[3] = (-2940, 0, 0);
	angles[3] = (0, -180, 0);
	at[3] = 12.5000;
	points[4] = (-2940, 0, 0);
	angles[4] = (0, -270, 0);
	at[4] = 18.7500;
	points[5] = (-2940, 0, 0);
	angles[5] = (0, -360, 0);
	at[5] = 25;
	points[6] = (-2940, 0, 0);
	angles[6] = (0, -404.6400, 0);
	at[6] = 28.1000;
	points[7] = (-2940, 0, 0);
	angles[7] = (0, -450, 0);
	at[7] = 31.2500;
	points[8] = (-2940, 0, 0);
	angles[8] = (0, -540, 0);
	at[8] = 37.5000;
	points[9] = (-2940, 0, 0);
	angles[9] = (0, -630, 0);
	at[9] = 43.7500;
	points[10] = (-2940, 0, 0);
	angles[10] = (0, -674.6400, 0);
	at[10] = 46.8500;
	points[11] = (-2940, 0, 0);
	angles[11] = (0, -720, 0);
	at[11] = 50;
	points[12] = (-2940, 0, 0);
	angles[12] = (0, -764.6400, 0);
	at[12] = 53.1000;
	points[13] = (-2940, 0, 0);
	angles[13] = (0, -810, 0);
	at[13] = 56.2500;
	points[14] = (-2940, 0, 0);
	angles[14] = (0, -900, 0);
	at[14] = 62.5000;
	points[15] = (-2940, 0, 0);
	angles[15] = (0, -990, 0);
	at[15] = 68.7500;
	points[16] = (-2940, 0, 0);
	angles[16] = (0, -1080, 0);
	at[16] = 75;
	points[17] = (-2940, 0, 0);
	angles[17] = (0, -1170, 0);
	at[17] = 81.2500;
	points[18] = (-2940, 0, 0);
	angles[18] = (0, -1260, 0);
	at[18] = 87.5000;
	points[19] = (-2940, 0, 0);
	angles[19] = (0, -1350, 0);
	at[19] = 93.7500;
	points[20] = (-2940, 0, 0);
	angles[20] = (0, -1440, 0);
	at[20] = 100;
	mover = getEnt("iz_mover4", "targetname");
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
