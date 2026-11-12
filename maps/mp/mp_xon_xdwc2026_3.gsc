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
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (12035.9844, -4480, 4607.9922);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (12035.9844, -4480, 4607.9922);
	angles[1] = (0, 0, 45);
	at[1] = 0.6429;
	points[2] = (12035.9844, -4480, 4607.9922);
	angles[2] = (0, 0, 90);
	at[2] = 1.2857;
	points[3] = (12035.9844, -4480, 4607.9922);
	angles[3] = (0, 0, 180);
	at[3] = 2.5714;
	points[4] = (12035.9844, -4480, 4607.9922);
	angles[4] = (0, 0, 270);
	at[4] = 3.8571;
	points[5] = (12035.9844, -4480, 4607.9922);
	angles[5] = (0, 0, 315);
	at[5] = 4.5000;
	points[6] = (12035.9844, -4480, 4607.9922);
	angles[6] = (0, 0, 360);
	at[6] = 5.1429;
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
	points[0] = (12035.9844, -3712, 4607.9922);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (12035.9844, -3712, 4607.9922);
	angles[1] = (0, 0, 45);
	at[1] = 0.4500;
	points[2] = (12035.9844, -3712, 4607.9922);
	angles[2] = (0, 0, 90);
	at[2] = 0.9000;
	points[3] = (12035.9844, -3712, 4607.9922);
	angles[3] = (0, 0, 180);
	at[3] = 1.8000;
	points[4] = (12035.9844, -3712, 4607.9922);
	angles[4] = (0, 0, 270);
	at[4] = 2.7000;
	points[5] = (12035.9844, -3712, 4607.9922);
	angles[5] = (0, 0, 315);
	at[5] = 3.1500;
	points[6] = (12035.9844, -3712, 4607.9922);
	angles[6] = (0, 0, 360);
	at[6] = 3.6000;
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
	points[0] = (27075.9844, -13535.9844, 7807.9922);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (27075.9844, -13535.9844, 7807.9922);
	angles[1] = (0, 0, 45);
	at[1] = 0.4500;
	points[2] = (27075.9844, -13535.9844, 7807.9922);
	angles[2] = (0, 0, 90);
	at[2] = 0.9000;
	points[3] = (27075.9844, -13535.9844, 7807.9922);
	angles[3] = (0, 0, 180);
	at[3] = 1.8000;
	points[4] = (27075.9844, -13535.9844, 7807.9922);
	angles[4] = (0, 0, 270);
	at[4] = 2.7000;
	points[5] = (27075.9844, -13535.9844, 7807.9922);
	angles[5] = (0, 0, 315);
	at[5] = 3.1500;
	points[6] = (27075.9844, -13535.9844, 7807.9922);
	angles[6] = (0, 0, 360);
	at[6] = 3.6000;
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
	points[0] = (13600, -11132.0078, 4224.0156);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (13600, -11132.0078, 4224.0156);
	angles[1] = (90, 0, 0);
	at[1] = 0.9000;
	points[2] = (13600, -11132.0078, 4224.0156);
	angles[2] = (135, 0, 0);
	at[2] = 1.3500;
	points[3] = (13600, -11132.0078, 4224.0156);
	angles[3] = (180, 0, 0);
	at[3] = 1.8000;
	points[4] = (13600, -11132.0078, 4224.0156);
	angles[4] = (225, 0, 0);
	at[4] = 2.2500;
	points[5] = (13600, -11132.0078, 4224.0156);
	angles[5] = (270, 0, 0);
	at[5] = 2.7000;
	points[6] = (13600, -11132.0078, 4224.0156);
	angles[6] = (360, 0, 0);
	at[6] = 3.6000;
	mover = getEnt("iz_q3_mover3", "targetname");
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
