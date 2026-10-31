main()
{
	visionSetNaked("mp_pso_mines1_1", 0);

	setExpFog(393.7008, 6791.3384, 0.8824, 0.8863, 1, 0);

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
	iz_emitter("iz_1_m_env_021", (-2834.6458, 5984.2520, 0), 0, 0.6566);
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
	thread pso_loop_16();
	thread pso_loop_17();
	thread pso_loop_18();
	thread pso_loop_19();
	thread pso_loop_20();
	thread pso_loop_21();
	thread pso_loop_22();
	thread pso_loop_23();
	thread pso_loop_24();
	thread pso_loop_25();
	thread pso_loop_26();
	thread pso_loop_27();
	thread pso_loop_28();
	thread pso_loop_29();
	thread pso_loop_30();
	thread pso_loop_31();
	thread pso_loop_32();
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (0, -118.1102, 0);
	at[0] = 0;
	points[1] = (0, -118.1102, 30.4801);
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
	points[0] = (0, -118.1102, 0);
	at[0] = 0;
	points[1] = (0, -118.1102, 32.3851);
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
	points[0] = (0, -118.1102, 0);
	at[0] = 0;
	points[1] = (0, -118.1102, 20.9550);
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
	points[0] = (0, -118.1102, 0);
	at[0] = 0;
	points[1] = (0, -118.1102, 15.2400);
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
	points[0] = (0, -118.1102, 0);
	at[0] = 0;
	points[1] = (0, -118.1102, 9.5250);
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
	points[0] = (-9921.2598, 2244.0945, 0);
	at[0] = 0;
	points[1] = (-9921.2598, 2244.0945, 30.4801);
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
	points[0] = (-9921.2598, 2244.0945, 0);
	at[0] = 0;
	points[1] = (-9921.2598, 2244.0945, 32.3851);
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
	points[0] = (-9921.2598, 2244.0945, 0);
	at[0] = 0;
	points[1] = (-9921.2598, 2244.0945, 20.9550);
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
	points[0] = (-9921.2598, 2244.0945, 0);
	at[0] = 0;
	points[1] = (-9921.2598, 2244.0945, 15.2400);
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
	points[0] = (-9921.2598, 2244.0945, 0);
	at[0] = 0;
	points[1] = (-9921.2598, 2244.0945, 9.5250);
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
	points[0] = (-944.8819, 5275.5908, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-944.8819, 5275.5908, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-944.8819, 5275.5908, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-944.8819, 5275.5908, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-944.8819, 5275.5908, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-944.8819, 5275.5908, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-7322.8350, 4094.4883, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-7322.8350, 4094.4883, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-7322.8350, 4094.4883, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-7322.8350, 4094.4883, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-7322.8350, 4094.4883, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-7322.8350, 4094.4883, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-7322.8350, 5039.3701, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-7322.8350, 5039.3701, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-7322.8350, 5039.3701, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-7322.8350, 5039.3701, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-7322.8350, 5039.3701, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-7322.8350, 5039.3701, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-2834.6458, 2677.1653, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2834.6458, 2677.1653, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-2834.6458, 2677.1653, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-2834.6458, 2677.1653, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-2834.6458, 2677.1653, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-2834.6458, 2677.1653, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-2834.6458, 2677.1653, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2834.6458, 2677.1653, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-2834.6458, 2677.1653, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-2834.6458, 2677.1653, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-2834.6458, 2677.1653, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-2834.6458, 2677.1653, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-2834.6458, 2677.1653, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2834.6458, 2677.1653, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-2834.6458, 2677.1653, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-2834.6458, 2677.1653, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-2834.6458, 2677.1653, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-2834.6458, 2677.1653, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-2834.6458, 2677.1653, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2834.6458, 2677.1653, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-2834.6458, 2677.1653, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-2834.6458, 2677.1653, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-2834.6458, 2677.1653, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-2834.6458, 2677.1653, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-1889.7638, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-1889.7638, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-1889.7638, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-1889.7638, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-1889.7638, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-1889.7638, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-1889.7638, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-1889.7638, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-1889.7638, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-1889.7638, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-1889.7638, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-1889.7638, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-1889.7638, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-1889.7638, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-1889.7638, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-1889.7638, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-1889.7638, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-1889.7638, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-1889.7638, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-1889.7638, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-1889.7638, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-1889.7638, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-1889.7638, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-1889.7638, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-3779.5276, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3779.5276, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3779.5276, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3779.5276, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3779.5276, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3779.5276, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-3779.5276, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3779.5276, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3779.5276, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3779.5276, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3779.5276, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3779.5276, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-3779.5276, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3779.5276, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3779.5276, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3779.5276, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3779.5276, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3779.5276, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-3779.5276, 5984.2520, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3779.5276, 5984.2520, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3779.5276, 5984.2520, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3779.5276, 5984.2520, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3779.5276, 5984.2520, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3779.5276, 5984.2520, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-472.4409, 1259.8425, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-472.4409, 1259.8425, 275.5905);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-472.4409, 1259.8425, 275.5905);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-472.4409, 1259.8425, 275.5905);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-472.4409, 1259.8425, 275.5905);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-472.4409, 1259.8425, 275.5905);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-472.4409, 1259.8425, 275.5905);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-472.4409, 1259.8425, 275.5905);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-472.4409, 1259.8425, 275.5905);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-472.4409, 1259.8425, 275.5905);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-472.4409, 1259.8425, 275.5905);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-472.4409, 1259.8425, 275.5905);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-472.4409, 1259.8425, 275.5905);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-472.4409, 1259.8425, 275.5905);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-472.4409, 1259.8425, 275.5905);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-472.4409, 1259.8425, 275.5905);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-472.4409, 1259.8425, 275.5905);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-472.4409, 1259.8425, 275.5905);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-472.4409, 1259.8425, 275.5905);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-472.4409, 1259.8425, 275.5905);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-472.4409, 1259.8425, 275.5905);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-472.4409, 1259.8425, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-472.4409, 1259.8425, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-472.4409, 1259.8425, 275.5905);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-472.4409, 1259.8425, 275.5905);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-472.4409, 1259.8425, 275.5905);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-472.4409, 1259.8425, 275.5905);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-472.4409, 1259.8425, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-472.4409, 1259.8425, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-472.4409, 1259.8425, 275.5905);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-472.4409, 1259.8425, 275.5905);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-472.4409, 1259.8425, 275.5905);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-472.4409, 1259.8425, 275.5905);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-472.4409, 1259.8425, 275.5905);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-472.4409, 1259.8425, 275.5905);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-472.4409, 1259.8425, 275.5905);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-472.4409, 1259.8425, 275.5905);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-472.4409, 1259.8425, 275.5905);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-472.4409, 1259.8425, 275.5905);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-472.4409, 1259.8425, 275.5905);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-472.4409, 1259.8425, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-472.4409, 1259.8425, 0);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-472.4409, 1259.8425, 0);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-472.4409, 1259.8425, 0);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-472.4409, 1259.8425, 0);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-472.4409, 1259.8425, 0);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-472.4409, 1259.8425, 0);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-472.4409, 1259.8425, 0);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-472.4409, 1259.8425, 0);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-472.4409, 1259.8425, 0);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-472.4409, 1259.8425, 0);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-472.4409, 1259.8425, 0);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-472.4409, 1259.8425, 0);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-472.4409, 1259.8425, 0);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-472.4409, 1259.8425, 0);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-472.4409, 1259.8425, 0);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-472.4409, 1259.8425, 0);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-472.4409, 1259.8425, 0);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-472.4409, 1259.8425, 0);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-472.4409, 1259.8425, 0);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-472.4409, 1259.8425, 0);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-472.4409, 1259.8425, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-472.4409, 1259.8425, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-472.4409, 1259.8425, 0);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-472.4409, 1259.8425, 0);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-472.4409, 1259.8425, 0);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-472.4409, 1259.8425, 0);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-472.4409, 1259.8425, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-472.4409, 1259.8425, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-472.4409, 1259.8425, 0);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-472.4409, 1259.8425, 0);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-472.4409, 1259.8425, 0);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-472.4409, 1259.8425, 0);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-472.4409, 1259.8425, 0);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-472.4409, 1259.8425, 0);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-472.4409, 1259.8425, 0);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-472.4409, 1259.8425, 0);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-472.4409, 1259.8425, 0);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-472.4409, 1259.8425, 0);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-472.4409, 1259.8425, 0);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5196.8506, 5511.8110, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5196.8506, 5511.8110, 275.5905);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-5196.8506, 5511.8110, 275.5905);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-5196.8506, 5511.8110, 275.5905);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-5196.8506, 5511.8110, 275.5905);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-5196.8506, 5511.8110, 275.5905);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-5196.8506, 5511.8110, 275.5905);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-5196.8506, 5511.8110, 275.5905);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-5196.8506, 5511.8110, 275.5905);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-5196.8506, 5511.8110, 275.5905);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-5196.8506, 5511.8110, 275.5905);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-5196.8506, 5511.8110, 275.5905);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-5196.8506, 5511.8110, 275.5905);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-5196.8506, 5511.8110, 275.5905);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-5196.8506, 5511.8110, 275.5905);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-5196.8506, 5511.8110, 275.5905);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-5196.8506, 5511.8110, 275.5905);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-5196.8506, 5511.8110, 275.5905);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-5196.8506, 5511.8110, 275.5905);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-5196.8506, 5511.8110, 275.5905);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-5196.8506, 5511.8110, 275.5905);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5196.8506, 5511.8110, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5196.8506, 5511.8110, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-5196.8506, 5511.8110, 275.5905);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-5196.8506, 5511.8110, 275.5905);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-5196.8506, 5511.8110, 275.5905);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-5196.8506, 5511.8110, 275.5905);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_22", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_23()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5196.8506, 5511.8110, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5196.8506, 5511.8110, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-5196.8506, 5511.8110, 275.5905);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-5196.8506, 5511.8110, 275.5905);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-5196.8506, 5511.8110, 275.5905);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-5196.8506, 5511.8110, 275.5905);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-5196.8506, 5511.8110, 275.5905);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-5196.8506, 5511.8110, 275.5905);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-5196.8506, 5511.8110, 275.5905);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-5196.8506, 5511.8110, 275.5905);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-5196.8506, 5511.8110, 275.5905);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-5196.8506, 5511.8110, 275.5905);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-5196.8506, 5511.8110, 275.5905);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_23", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_24()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5196.8506, 5511.8110, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5196.8506, 5511.8110, 0);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-5196.8506, 5511.8110, 0);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-5196.8506, 5511.8110, 0);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-5196.8506, 5511.8110, 0);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-5196.8506, 5511.8110, 0);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-5196.8506, 5511.8110, 0);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-5196.8506, 5511.8110, 0);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-5196.8506, 5511.8110, 0);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-5196.8506, 5511.8110, 0);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-5196.8506, 5511.8110, 0);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-5196.8506, 5511.8110, 0);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-5196.8506, 5511.8110, 0);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-5196.8506, 5511.8110, 0);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-5196.8506, 5511.8110, 0);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-5196.8506, 5511.8110, 0);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-5196.8506, 5511.8110, 0);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-5196.8506, 5511.8110, 0);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-5196.8506, 5511.8110, 0);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-5196.8506, 5511.8110, 0);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-5196.8506, 5511.8110, 0);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_24", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_25()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5196.8506, 5511.8110, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5196.8506, 5511.8110, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-5196.8506, 5511.8110, 0);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-5196.8506, 5511.8110, 0);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-5196.8506, 5511.8110, 0);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-5196.8506, 5511.8110, 0);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_25", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_26()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5196.8506, 5511.8110, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5196.8506, 5511.8110, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-5196.8506, 5511.8110, 0);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-5196.8506, 5511.8110, 0);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-5196.8506, 5511.8110, 0);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-5196.8506, 5511.8110, 0);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-5196.8506, 5511.8110, 0);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-5196.8506, 5511.8110, 0);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-5196.8506, 5511.8110, 0);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-5196.8506, 5511.8110, 0);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-5196.8506, 5511.8110, 0);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-5196.8506, 5511.8110, 0);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-5196.8506, 5511.8110, 0);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_26", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_27()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 4566.9292, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 4566.9292, 275.5905);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-8503.9375, 4566.9292, 275.5905);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-8503.9375, 4566.9292, 275.5905);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-8503.9375, 4566.9292, 275.5905);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-8503.9375, 4566.9292, 275.5905);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-8503.9375, 4566.9292, 275.5905);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-8503.9375, 4566.9292, 275.5905);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-8503.9375, 4566.9292, 275.5905);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-8503.9375, 4566.9292, 275.5905);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-8503.9375, 4566.9292, 275.5905);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-8503.9375, 4566.9292, 275.5905);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-8503.9375, 4566.9292, 275.5905);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-8503.9375, 4566.9292, 275.5905);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-8503.9375, 4566.9292, 275.5905);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-8503.9375, 4566.9292, 275.5905);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-8503.9375, 4566.9292, 275.5905);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-8503.9375, 4566.9292, 275.5905);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-8503.9375, 4566.9292, 275.5905);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-8503.9375, 4566.9292, 275.5905);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-8503.9375, 4566.9292, 275.5905);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_27", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_28()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 4566.9292, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 4566.9292, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-8503.9375, 4566.9292, 275.5905);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-8503.9375, 4566.9292, 275.5905);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-8503.9375, 4566.9292, 275.5905);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-8503.9375, 4566.9292, 275.5905);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_28", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_29()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 4566.9292, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 4566.9292, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-8503.9375, 4566.9292, 275.5905);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-8503.9375, 4566.9292, 275.5905);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-8503.9375, 4566.9292, 275.5905);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-8503.9375, 4566.9292, 275.5905);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-8503.9375, 4566.9292, 275.5905);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-8503.9375, 4566.9292, 275.5905);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-8503.9375, 4566.9292, 275.5905);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-8503.9375, 4566.9292, 275.5905);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-8503.9375, 4566.9292, 275.5905);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-8503.9375, 4566.9292, 275.5905);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-8503.9375, 4566.9292, 275.5905);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_29", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_30()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 4566.9292, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 4566.9292, 275.5905);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-8503.9375, 4566.9292, 275.5905);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-8503.9375, 4566.9292, 275.5905);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-8503.9375, 4566.9292, 275.5905);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-8503.9375, 4566.9292, 275.5905);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-8503.9375, 4566.9292, 275.5905);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-8503.9375, 4566.9292, 275.5905);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-8503.9375, 4566.9292, 275.5905);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-8503.9375, 4566.9292, 275.5905);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-8503.9375, 4566.9292, 275.5905);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-8503.9375, 4566.9292, 275.5905);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-8503.9375, 4566.9292, 275.5905);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-8503.9375, 4566.9292, 275.5905);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-8503.9375, 4566.9292, 275.5905);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-8503.9375, 4566.9292, 275.5905);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-8503.9375, 4566.9292, 275.5905);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-8503.9375, 4566.9292, 275.5905);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-8503.9375, 4566.9292, 275.5905);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-8503.9375, 4566.9292, 275.5905);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-8503.9375, 4566.9292, 275.5905);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_30", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_31()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 4566.9292, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 4566.9292, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-8503.9375, 4566.9292, 275.5905);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-8503.9375, 4566.9292, 275.5905);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-8503.9375, 4566.9292, 275.5905);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-8503.9375, 4566.9292, 275.5905);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_31", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_32()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8503.9375, 4566.9292, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8503.9375, 4566.9292, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-8503.9375, 4566.9292, 275.5905);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-8503.9375, 4566.9292, 275.5905);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-8503.9375, 4566.9292, 275.5905);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-8503.9375, 4566.9292, 275.5905);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-8503.9375, 4566.9292, 275.5905);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-8503.9375, 4566.9292, 275.5905);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-8503.9375, 4566.9292, 275.5905);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-8503.9375, 4566.9292, 275.5905);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-8503.9375, 4566.9292, 275.5905);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-8503.9375, 4566.9292, 275.5905);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-8503.9375, 4566.9292, 275.5905);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_32", "targetname");
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
