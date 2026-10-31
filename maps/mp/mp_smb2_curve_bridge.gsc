main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_curve_bridge", 0);

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
	ambientPlay("iz_0_jungle", 2);
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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -20536.1035, 0);
	angles[0] = (0, 0, 0.0037);
	at[0] = 0;
	points[1] = (0, -20536.1035, 0);
	angles[1] = (0, 0, -1.1887);
	at[1] = 1.2000;
	points[2] = (0, -20536.1035, 0);
	angles[2] = (0, 0, -4.6838);
	at[2] = 2.5000;
	points[3] = (0, -20536.1035, 0);
	angles[3] = (-0.0020, 0, -21.7479);
	at[3] = 6.5500;
	points[4] = (0, -20536.1035, 0);
	angles[4] = (-0.0025, 0, -26.5830);
	at[4] = 7.9000;
	points[5] = (0, -20536.1035, 0);
	angles[5] = (-0.0027, 0, -29.1564);
	at[5] = 9;
	points[6] = (0, -20536.1035, 0);
	angles[6] = (-0.0027, 0, -29.9963);
	at[6] = 10;
	points[7] = (0, -20536.1035, 0);
	angles[7] = (-0.0026, 0, -28.8040);
	at[7] = 11.2000;
	points[8] = (0, -20536.1035, 0);
	angles[8] = (-0.0023, 0, -25.3088);
	at[8] = 12.5000;
	points[9] = (0, -20536.1035, 0);
	angles[9] = (0, 0, -8.2448);
	at[9] = 16.5500;
	points[10] = (0, -20536.1035, 0);
	angles[10] = (0, 0, -3.4097);
	at[10] = 17.9000;
	points[11] = (0, -20536.1035, 0);
	angles[11] = (0, 0, -0.8363);
	at[11] = 19;
	points[12] = (0, -20536.1035, 0);
	angles[12] = (0, 0, 0.0037);
	at[12] = 20;
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
	points[0] = (0, -13536.1816, 0);
	angles[0] = (0, 0, 0.0037);
	at[0] = 0;
	points[1] = (0, -13536.1816, 0);
	angles[1] = (0, 0, -1.1887);
	at[1] = 1.2000;
	points[2] = (0, -13536.1816, 0);
	angles[2] = (0, 0, -4.6838);
	at[2] = 2.5000;
	points[3] = (0, -13536.1816, 0);
	angles[3] = (-0.0020, 0, -21.7479);
	at[3] = 6.5500;
	points[4] = (0, -13536.1816, 0);
	angles[4] = (-0.0025, 0, -26.5830);
	at[4] = 7.9000;
	points[5] = (0, -13536.1816, 0);
	angles[5] = (-0.0027, 0, -29.1564);
	at[5] = 9;
	points[6] = (0, -13536.1816, 0);
	angles[6] = (-0.0027, 0, -29.9963);
	at[6] = 10;
	points[7] = (0, -13536.1816, 0);
	angles[7] = (-0.0026, 0, -28.8040);
	at[7] = 11.2000;
	points[8] = (0, -13536.1816, 0);
	angles[8] = (-0.0023, 0, -25.3088);
	at[8] = 12.5000;
	points[9] = (0, -13536.1816, 0);
	angles[9] = (0, 0, -8.2448);
	at[9] = 16.5500;
	points[10] = (0, -13536.1816, 0);
	angles[10] = (0, 0, -3.4097);
	at[10] = 17.9000;
	points[11] = (0, -13536.1816, 0);
	angles[11] = (0, 0, -0.8363);
	at[11] = 19;
	points[12] = (0, -13536.1816, 0);
	angles[12] = (0, 0, 0.0037);
	at[12] = 20;
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
	points[0] = (0, -20536.1035, 0);
	angles[0] = (0, 0, 0.0037);
	at[0] = 0;
	points[1] = (0, -20536.1035, 0);
	angles[1] = (0, 0, -1.1887);
	at[1] = 1.2000;
	points[2] = (0, -20536.1035, 0);
	angles[2] = (0, 0, -4.6838);
	at[2] = 2.5000;
	points[3] = (0, -20536.1035, 0);
	angles[3] = (-0.0020, 0, -21.7479);
	at[3] = 6.5500;
	points[4] = (0, -20536.1035, 0);
	angles[4] = (-0.0025, 0, -26.5830);
	at[4] = 7.9000;
	points[5] = (0, -20536.1035, 0);
	angles[5] = (-0.0027, 0, -29.1564);
	at[5] = 9;
	points[6] = (0, -20536.1035, 0);
	angles[6] = (-0.0027, 0, -29.9963);
	at[6] = 10;
	points[7] = (0, -20536.1035, 0);
	angles[7] = (-0.0026, 0, -28.8040);
	at[7] = 11.2000;
	points[8] = (0, -20536.1035, 0);
	angles[8] = (-0.0023, 0, -25.3088);
	at[8] = 12.5000;
	points[9] = (0, -20536.1035, 0);
	angles[9] = (0, 0, -8.2448);
	at[9] = 16.5500;
	points[10] = (0, -20536.1035, 0);
	angles[10] = (0, 0, -3.4097);
	at[10] = 17.9000;
	points[11] = (0, -20536.1035, 0);
	angles[11] = (0, 0, -0.8363);
	at[11] = 19;
	points[12] = (0, -20536.1035, 0);
	angles[12] = (0, 0, 0.0037);
	at[12] = 20;
	mover = getEnt("iz_mover2", "targetname");
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
