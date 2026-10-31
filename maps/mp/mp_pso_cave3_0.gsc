main()
{
	visionSetNaked("mp_pso_cave3_0", 0);

	setExpFog(0, 656.1684, 0.1255, 0.1255, 0.3137, 0);

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
	ambientPlay("iz_0_cave_n", 2);
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
	thread iz_anim_0();
	thread iz_anim_1();
	thread iz_anim_2();
	thread iz_anim_3();
	thread iz_anim_4();
	thread iz_anim_5();
	thread iz_anim_6();
	thread iz_anim_7();
	thread iz_anim_8();
	thread iz_anim_9();
	thread iz_anim_10();
	thread iz_anim_11();
	thread iz_anim_12();
	thread iz_anim_13();
	thread iz_anim_14();
	thread iz_anim_15();
	thread iz_anim_16();
	thread iz_anim_17();
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (4409.4487, -9086.6143, 0);
	at[0] = 0;
	points[1] = (4409.4487, -9086.6143, 30.8611);
	at[1] = 1;
	part = getEnt("iz_anim_0", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_1()
{
	points = [];
	at = [];
	points[0] = (4409.4487, -9086.6143, 0);
	at[0] = 0;
	points[1] = (4409.4487, -9086.6143, 32.3851);
	at[1] = 1;
	part = getEnt("iz_anim_1", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_2()
{
	points = [];
	at = [];
	points[0] = (4409.4487, -9086.6143, 0);
	at[0] = 0;
	points[1] = (4409.4487, -9086.6143, 20.9550);
	at[1] = 1;
	part = getEnt("iz_anim_2", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_3()
{
	points = [];
	at = [];
	points[0] = (4409.4487, -9086.6143, 0);
	at[0] = 0;
	points[1] = (4409.4487, -9086.6143, 14.8590);
	at[1] = 1;
	part = getEnt("iz_anim_3", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_4()
{
	points = [];
	at = [];
	points[0] = (4409.4487, -9086.6143, 0);
	at[0] = 0;
	points[1] = (4409.4487, -9086.6143, 9.5250);
	at[1] = 1;
	part = getEnt("iz_anim_4", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_5()
{
	points = [];
	at = [];
	points[0] = (-3572.4292, -8509.9453, 0);
	at[0] = 0;
	points[1] = (-3572.4292, -8509.9453, 9.5250);
	at[1] = 1;
	part = getEnt("iz_anim_5", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_6()
{
	points = [];
	at = [];
	points[0] = (-3572.4292, -8509.9453, 0);
	at[0] = 0;
	points[1] = (-3572.4292, -8509.9453, 15.2400);
	at[1] = 1;
	part = getEnt("iz_anim_6", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_7()
{
	points = [];
	at = [];
	points[0] = (-3572.4292, -8509.9453, 0);
	at[0] = 0;
	points[1] = (-3572.4292, -8509.9453, 20.9550);
	at[1] = 1;
	part = getEnt("iz_anim_7", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_8()
{
	points = [];
	at = [];
	points[0] = (-3572.4292, -8509.9453, 0);
	at[0] = 0;
	points[1] = (-3572.4292, -8509.9453, 26.6701);
	at[1] = 1;
	part = getEnt("iz_anim_8", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_9()
{
	points = [];
	at = [];
	points[0] = (964.0128, -9659.1641, 0);
	at[0] = 0;
	points[1] = (964.0128, -9659.1641, 9.5250);
	at[1] = 1;
	part = getEnt("iz_anim_9", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_10()
{
	points = [];
	at = [];
	points[0] = (964.0128, -9659.1641, 0);
	at[0] = 0;
	points[1] = (964.0128, -9659.1641, 15.2400);
	at[1] = 1;
	part = getEnt("iz_anim_10", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_11()
{
	points = [];
	at = [];
	points[0] = (964.0128, -9659.1641, 0);
	at[0] = 0;
	points[1] = (964.0128, -9659.1641, 20.9550);
	at[1] = 1;
	part = getEnt("iz_anim_11", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_12()
{
	points = [];
	at = [];
	points[0] = (964.0128, -9659.1641, 0);
	at[0] = 0;
	points[1] = (964.0128, -9659.1641, 26.6701);
	at[1] = 1;
	part = getEnt("iz_anim_12", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_13()
{
	points = [];
	at = [];
	points[0] = (2854.3308, -1279.5276, 0);
	at[0] = 0;
	points[1] = (2854.3308, -1279.5276, 30.4801);
	at[1] = 1;
	part = getEnt("iz_anim_13", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_14()
{
	points = [];
	at = [];
	points[0] = (2854.3308, -1279.5276, 0);
	at[0] = 0;
	points[1] = (2854.3308, -1279.5276, 32.3851);
	at[1] = 1;
	part = getEnt("iz_anim_14", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_15()
{
	points = [];
	at = [];
	points[0] = (2854.3308, -1279.5276, 0);
	at[0] = 0;
	points[1] = (2854.3308, -1279.5276, 20.9550);
	at[1] = 1;
	part = getEnt("iz_anim_15", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_16()
{
	points = [];
	at = [];
	points[0] = (2854.3308, -1279.5276, 0);
	at[0] = 0;
	points[1] = (2854.3308, -1279.5276, 15.2400);
	at[1] = 1;
	part = getEnt("iz_anim_16", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_17()
{
	points = [];
	at = [];
	points[0] = (2854.3308, -1279.5276, 0);
	at[0] = 0;
	points[1] = (2854.3308, -1279.5276, 9.5250);
	at[1] = 1;
	part = getEnt("iz_anim_17", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
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
