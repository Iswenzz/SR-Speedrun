main()
{
	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
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
	thread iz_q3_mover1();
	thread iz_q3_mover2();
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-12795, 7100.9844, -292);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-12795, 7100.9844, -292);
	angles[1] = (90, 0, 0);
	at[1] = 900;
	points[2] = (-12795, 7100.9844, -292);
	angles[2] = (135, 0, 0);
	at[2] = 1350;
	points[3] = (-12795, 7100.9844, -292);
	angles[3] = (180, 0, 0);
	at[3] = 1800;
	points[4] = (-12795, 7100.9844, -292);
	angles[4] = (225, 0, 0);
	at[4] = 2250;
	points[5] = (-12795, 7100.9844, -292);
	angles[5] = (270, 0, 0);
	at[5] = 2700;
	points[6] = (-12795, 7100.9844, -292);
	angles[6] = (360, 0, 0);
	at[6] = 3600;
	mover = getEnt("iz_q3_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-12795, 7097.0083, -292);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-12795, 7097.0083, -292);
	angles[1] = (90, 0, 0);
	at[1] = 10800;
	points[2] = (-12795, 7097.0083, -292);
	angles[2] = (135, 0, 0);
	at[2] = 16200;
	points[3] = (-12795, 7097.0083, -292);
	angles[3] = (180, 0, 0);
	at[3] = 21600;
	points[4] = (-12795, 7097.0083, -292);
	angles[4] = (225, 0, 0);
	at[4] = 27000;
	points[5] = (-12795, 7097.0083, -292);
	angles[5] = (270, 0, 0);
	at[5] = 32400;
	points[6] = (-12795, 7097.0083, -292);
	angles[6] = (360, 0, 0);
	at[6] = 43200;
	mover = getEnt("iz_q3_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-12795, 7092.9922, -292);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-12795, 7092.9922, -292);
	angles[1] = (90, 0, 0);
	at[1] = 15;
	points[2] = (-12795, 7092.9922, -292);
	angles[2] = (135, 0, 0);
	at[2] = 22.5000;
	points[3] = (-12795, 7092.9922, -292);
	angles[3] = (180, 0, 0);
	at[3] = 30;
	points[4] = (-12795, 7092.9922, -292);
	angles[4] = (225, 0, 0);
	at[4] = 37.5000;
	points[5] = (-12795, 7092.9922, -292);
	angles[5] = (270, 0, 0);
	at[5] = 45;
	points[6] = (-12795, 7092.9922, -292);
	angles[6] = (360, 0, 0);
	at[6] = 60;
	mover = getEnt("iz_q3_mover2", "targetname");
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
