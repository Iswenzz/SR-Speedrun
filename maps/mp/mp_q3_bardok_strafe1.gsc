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
	thread iz_q3_mover3();
	thread iz_q3_mover4();
	thread iz_q3_mover5();
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1128, -244, -20);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1128, -244, -16.9080);
	angles[1] = (0, 0, 0);
	at[1] = 0.5625;
	points[2] = (1128, -244, -16);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (1128, -244, -17.1716);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (1128, -244, -22.5376);
	angles[4] = (0, 0, 0);
	at[4] = 2.4375;
	points[5] = (1128, -244, -23.9232);
	angles[5] = (0, 0, 0);
	at[5] = 2.8750;
	points[6] = (1128, -244, -23.3259);
	angles[6] = (0, 0, 0);
	at[6] = 3.3750;
	points[7] = (1128, -244, -20);
	angles[7] = (0, 0, 0);
	at[7] = 4;
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
	points[0] = (1152, -96, 4);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1152, -96, 7.0920);
	angles[1] = (0, 0, 0);
	at[1] = 0.5625;
	points[2] = (1152, -96, 8);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (1152, -96, 6.8284);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (1152, -96, 1.4624);
	angles[4] = (0, 0, 0);
	at[4] = 2.4375;
	points[5] = (1152, -96, 0.0769);
	angles[5] = (0, 0, 0);
	at[5] = 2.8750;
	points[6] = (1152, -96, 0.6741);
	angles[6] = (0, 0, 0);
	at[6] = 3.3750;
	points[7] = (1152, -96, 4);
	angles[7] = (0, 0, 0);
	at[7] = 4;
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
	points[0] = (1416, -200, 8);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1416, -200, 11.0920);
	angles[1] = (0, 0, 0);
	at[1] = 0.5625;
	points[2] = (1416, -200, 12);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (1416, -200, 10.8284);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (1416, -200, 5.4624);
	angles[4] = (0, 0, 0);
	at[4] = 2.4375;
	points[5] = (1416, -200, 4.0769);
	angles[5] = (0, 0, 0);
	at[5] = 2.8750;
	points[6] = (1416, -200, 4.6741);
	angles[6] = (0, 0, 0);
	at[6] = 3.3750;
	points[7] = (1416, -200, 8);
	angles[7] = (0, 0, 0);
	at[7] = 4;
	mover = getEnt("iz_q3_mover2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (936, -172, -4);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (936, -172, -0.9080);
	angles[1] = (0, 0, 0);
	at[1] = 0.5625;
	points[2] = (936, -172, 0);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (936, -172, -1.1716);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (936, -172, -6.5376);
	angles[4] = (0, 0, 0);
	at[4] = 2.4375;
	points[5] = (936, -172, -7.9232);
	angles[5] = (0, 0, 0);
	at[5] = 2.8750;
	points[6] = (936, -172, -7.3259);
	angles[6] = (0, 0, 0);
	at[6] = 3.3750;
	points[7] = (936, -172, -4);
	angles[7] = (0, 0, 0);
	at[7] = 4;
	mover = getEnt("iz_q3_mover3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1736, -172, -24);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1736, -172, -20.9080);
	angles[1] = (0, 0, 0);
	at[1] = 0.5625;
	points[2] = (1736, -172, -20);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (1736, -172, -21.1716);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (1736, -172, -26.5376);
	angles[4] = (0, 0, 0);
	at[4] = 2.4375;
	points[5] = (1736, -172, -27.9232);
	angles[5] = (0, 0, 0);
	at[5] = 2.8750;
	points[6] = (1736, -172, -27.3259);
	angles[6] = (0, 0, 0);
	at[6] = 3.3750;
	points[7] = (1736, -172, -24);
	angles[7] = (0, 0, 0);
	at[7] = 4;
	mover = getEnt("iz_q3_mover4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1376, -40, 4);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1376, -40, 7.0920);
	angles[1] = (0, 0, 0);
	at[1] = 0.5625;
	points[2] = (1376, -40, 8);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (1376, -40, 6.8284);
	angles[3] = (0, 0, 0);
	at[3] = 1.5000;
	points[4] = (1376, -40, 1.4624);
	angles[4] = (0, 0, 0);
	at[4] = 2.4375;
	points[5] = (1376, -40, 0.0769);
	angles[5] = (0, 0, 0);
	at[5] = 2.8750;
	points[6] = (1376, -40, 0.6741);
	angles[6] = (0, 0, 0);
	at[6] = 3.3750;
	points[7] = (1376, -40, 4);
	angles[7] = (0, 0, 0);
	at[7] = 4;
	mover = getEnt("iz_q3_mover5", "targetname");
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
