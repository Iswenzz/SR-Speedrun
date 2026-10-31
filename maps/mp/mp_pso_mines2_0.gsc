main()
{
	visionSetNaked("mp_pso_mines2_0", 0);

	setExpFog(0, 984.2524, 0.1882, 0.2078, 0, 0);

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
	ambientPlay("iz_0_machin_n", 2);
	iz_emitter("iz_1_m_env_022", (-4724.4097, 4527.5591, 0), 0, 1.1703);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
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
	thread pso_loop_0();
	thread pso_loop_1();
	thread pso_loop_2();
	thread pso_loop_3();
	thread pso_loop_4();
	thread pso_loop_5();
	thread pso_loop_6();
	thread pso_loop_7();
	thread pso_loop_8();
	thread pso_loop_9();
	thread pso_loop_10();
	thread pso_loop_11();
	thread pso_loop_12();
	thread pso_loop_13();
	thread pso_loop_14();
	thread pso_loop_15();
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (0, -157.4801, 0);
	at[0] = 0;
	points[1] = (0, -157.4801, 30.4801);
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
	points[0] = (0, -157.4801, 0);
	at[0] = 0;
	points[1] = (0, -157.4801, 32.3851);
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
	points[0] = (0, -157.4801, 0);
	at[0] = 0;
	points[1] = (0, -157.4801, 20.9550);
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
	points[0] = (0, -157.4801, 0);
	at[0] = 0;
	points[1] = (0, -157.4801, 15.2400);
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
	points[0] = (0, -157.4801, 0);
	at[0] = 0;
	points[1] = (0, -157.4801, 9.5250);
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
	points[0] = (-10393.7012, 8208.6611, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 8208.6611, 30.8611);
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
	points[0] = (-10393.7012, 8208.6611, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 8208.6611, 32.3851);
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
	points[0] = (-10393.7012, 8208.6611, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 8208.6611, 20.9550);
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
	points[0] = (-10393.7012, 8208.6611, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 8208.6611, 14.8590);
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
	points[0] = (-10393.7012, 8208.6611, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 8208.6611, 9.5250);
	at[1] = 1;
	part = getEnt("iz_anim_9", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

pso_loop_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 2637.7954, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 2637.7954, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (0, 2637.7954, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 2637.7954, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 2637.7954, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (0, 2637.7954, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 2637.7954, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 2637.7954, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (0, 2637.7954, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-307.0866, 2332.6772, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-307.0866, 2332.6772, -1134.7834);
	angles[1] = (0, -0.0594, 0);
	at[1] = 4.9020;
	points[2] = (-307.0866, 2332.6772, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-944.8819, 3582.6772, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-944.8819, 3582.6772, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-944.8819, 3582.6772, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-944.8819, 3582.6772, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-944.8819, 3582.6772, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-944.8819, 3582.6772, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-944.8819, 3582.6772, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-944.8819, 3582.6772, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-944.8819, 3582.6772, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1251.9685, 3277.5591, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1251.9685, 3277.5591, -1134.7834);
	angles[1] = (0, -0.0594, 0);
	at[1] = 4.9020;
	points[2] = (-1251.9685, 3277.5591, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 7362.2046, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 7362.2046, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-8503.9375, 7362.2046, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 7362.2046, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 7362.2046, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-8503.9375, 7362.2046, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 7362.2046, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 7362.2046, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-8503.9375, 7362.2046, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8811.0234, 7057.0869, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8811.0234, 7057.0869, -1134.7834);
	angles[1] = (0, -0.0594, 0);
	at[1] = 4.9020;
	points[2] = (-8811.0234, 7057.0869, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-10393.7012, 5472.4409, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 5472.4409, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-10393.7012, 5472.4409, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-10393.7012, 5472.4409, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 5472.4409, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-10393.7012, 5472.4409, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-10393.7012, 5472.4409, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10393.7012, 5472.4409, -1134.7834);
	angles[1] = (0, 0, 0);
	at[1] = 4.9020;
	points[2] = (-10393.7012, 5472.4409, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-10700.7871, 5167.3228, 1181.1024);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10700.7871, 5167.3228, -1134.7834);
	angles[1] = (0, -0.0594, 0);
	at[1] = 4.9020;
	points[2] = (-10700.7871, 5167.3228, 1181.1024);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	mover = getEnt("pso_loop_15", "targetname");
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
