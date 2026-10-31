main()
{
	visionSetNaked("mp_pso_cave1_0", 0);

	setExpFog(614.9597, 1655.6427, 1, 0.4392, 0, 0);

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
	iz_emitter("iz_1_c_env_002", (-544.8051, -3363.1260, 0), 0, 2.4495);
	iz_emitter("iz_1_c_env_002", (-8999.0264, -3300.6902, 0), 0, 2.4495);
	iz_emitter("iz_1_c_env_002", (-7788.8999, -1000.9214, 0), 0, 2.4495);
	iz_emitter("iz_1_c_env_002", (-3756.8794, -6148.1289, 0), 0, 2.4495);
	iz_emitter("iz_2_c_env_001", (-7165.3545, -5511.8115, 0), 0, 2.4513);
	iz_emitter("iz_2_c_env_001", (-7165.3545, -3937.0076, 0), 0, 2.4513);
	iz_emitter("iz_2_c_env_001", (-5590.5513, -3937.0076, 0), 0, 2.4513);
	iz_emitter("iz_2_c_env_001", (-5590.5513, -5511.8110, 0), 0, 2.4513);
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
	thread iz_anim_10();
	thread iz_anim_11();
	thread iz_anim_12();
	thread iz_anim_13();
	thread iz_anim_14();
	thread iz_anim_15();
	thread iz_anim_16();
	thread iz_anim_17();
	thread iz_anim_18();
	thread iz_anim_19();
	thread iz_anim_20();
	thread iz_anim_21();
	thread iz_anim_22();
	thread iz_anim_23();
	thread iz_anim_24();
	thread iz_anim_25();
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (-3392.1353, -8299.6182, 0);
	at[0] = 0;
	points[1] = (-3392.1353, -8299.6182, 9.5250);
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
	points[0] = (-3392.1353, -8299.6182, 0);
	at[0] = 0;
	points[1] = (-3392.1353, -8299.6182, 15.2400);
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
	points[0] = (-3392.1353, -8299.6182, 0);
	at[0] = 0;
	points[1] = (-3392.1353, -8299.6182, 20.9550);
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
	points[0] = (-3392.1353, -8299.6182, 0);
	at[0] = 0;
	points[1] = (-3392.1353, -8299.6182, 26.6701);
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
	points[0] = (-1789.7267, -6070.9961, 0);
	at[0] = 0;
	points[1] = (-1789.7267, -6070.9961, 9.5250);
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
	points[0] = (-1789.7267, -6070.9961, 0);
	at[0] = 0;
	points[1] = (-1789.7267, -6070.9961, 15.2400);
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
	points[0] = (-1789.7267, -6070.9961, 0);
	at[0] = 0;
	points[1] = (-1789.7267, -6070.9961, 20.9550);
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
	points[0] = (-1789.7267, -6070.9961, 0);
	at[0] = 0;
	points[1] = (-1789.7267, -6070.9961, 26.6701);
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
	points[0] = (-5640.9185, -632.1814, 0);
	at[0] = 0;
	points[1] = (-5640.9185, -632.1814, 9.5250);
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
	points[0] = (-5640.9185, -632.1814, 0);
	at[0] = 0;
	points[1] = (-5640.9185, -632.1814, 15.2400);
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
	points[0] = (-5640.9185, -632.1814, 0);
	at[0] = 0;
	points[1] = (-5640.9185, -632.1814, 20.9550);
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
	points[0] = (-5640.9185, -632.1814, 0);
	at[0] = 0;
	points[1] = (-5640.9185, -632.1814, 26.6701);
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
	points[0] = (1673.2284, -3149.6064, 0);
	at[0] = 0;
	points[1] = (1673.2284, -3149.6064, 30.4801);
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
	points[0] = (1673.2284, -3149.6064, 0);
	at[0] = 0;
	points[1] = (1673.2284, -3149.6064, 32.3851);
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
	points[0] = (1673.2284, -3149.6064, 0);
	at[0] = 0;
	points[1] = (1673.2284, -3149.6064, 20.9550);
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
	points[0] = (1673.2284, -3149.6064, 0);
	at[0] = 0;
	points[1] = (1673.2284, -3149.6064, 15.2400);
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
	points[0] = (1673.2284, -3149.6064, 0);
	at[0] = 0;
	points[1] = (1673.2284, -3149.6064, 9.5250);
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
	points[0] = (-9241.5830, 769.8389, 0);
	at[0] = 0;
	points[1] = (-9241.5830, 769.8389, 9.5250);
	at[1] = 1;
	part = getEnt("iz_anim_17", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_18()
{
	points = [];
	at = [];
	points[0] = (-9241.5830, 769.8389, 0);
	at[0] = 0;
	points[1] = (-9241.5830, 769.8389, 15.2400);
	at[1] = 1;
	part = getEnt("iz_anim_18", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_19()
{
	points = [];
	at = [];
	points[0] = (-9241.5830, 769.8389, 0);
	at[0] = 0;
	points[1] = (-9241.5830, 769.8389, 20.9550);
	at[1] = 1;
	part = getEnt("iz_anim_19", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_20()
{
	points = [];
	at = [];
	points[0] = (-9241.5830, 769.8389, 0);
	at[0] = 0;
	points[1] = (-9241.5830, 769.8389, 26.6701);
	at[1] = 1;
	part = getEnt("iz_anim_20", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_21()
{
	points = [];
	at = [];
	points[0] = (-9219.5850, -187.6148, 0);
	at[0] = 0;
	points[1] = (-9219.5850, -187.6148, 30.4802);
	at[1] = 1;
	part = getEnt("iz_anim_21", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_22()
{
	points = [];
	at = [];
	points[0] = (-9219.5850, -187.6148, 0);
	at[0] = 0;
	points[1] = (-9219.5850, -187.6148, 32.3852);
	at[1] = 1;
	part = getEnt("iz_anim_22", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_23()
{
	points = [];
	at = [];
	points[0] = (-9219.5850, -187.6148, 0);
	at[0] = 0;
	points[1] = (-9219.5850, -187.6148, 20.9552);
	at[1] = 1;
	part = getEnt("iz_anim_23", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_24()
{
	points = [];
	at = [];
	points[0] = (-9219.5850, -187.6148, 0);
	at[0] = 0;
	points[1] = (-9219.5850, -187.6148, 15.2402);
	at[1] = 1;
	part = getEnt("iz_anim_24", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_25()
{
	points = [];
	at = [];
	points[0] = (-9219.5850, -187.6148, 0);
	at[0] = 0;
	points[1] = (-9219.5850, -187.6148, 9.5251);
	at[1] = 1;
	part = getEnt("iz_anim_25", "targetname");
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
