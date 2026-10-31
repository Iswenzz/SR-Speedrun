main()
{
	visionSetNaked("mp_pso_mines1_0", 0);

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
	iz_emitter("iz_1_m_env_021", (-7362.2046, 4724.4097, 0), 0, 0.6566);
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
	thread pso_loop_33();
	thread pso_loop_34();
	thread pso_loop_35();
	thread pso_loop_36();
	thread pso_loop_37();
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (157.4803, 0, 0);
	at[0] = 0;
	points[1] = (157.4803, 0, 30.4801);
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
	points[0] = (157.4803, 0, 0);
	at[0] = 0;
	points[1] = (157.4803, 0, 32.3851);
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
	points[0] = (157.4803, 0, 0);
	at[0] = 0;
	points[1] = (157.4803, 0, 20.9550);
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
	points[0] = (157.4803, 0, 0);
	at[0] = 0;
	points[1] = (157.4803, 0, 15.2400);
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
	points[0] = (157.4803, 0, 0);
	at[0] = 0;
	points[1] = (157.4803, 0, 9.5250);
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
	points[0] = (-10060.8906, 7027.8560, 0);
	at[0] = 0;
	points[1] = (-10060.8906, 7027.8560, 9.5250);
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
	points[0] = (-10060.8906, 7027.8560, 0);
	at[0] = 0;
	points[1] = (-10060.8906, 7027.8560, 15.2400);
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
	points[0] = (-10060.8906, 7027.8560, 0);
	at[0] = 0;
	points[1] = (-10060.8906, 7027.8560, 20.9550);
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
	points[0] = (-10060.8906, 7027.8560, 0);
	at[0] = 0;
	points[1] = (-10060.8906, 7027.8560, 26.6701);
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
	points[0] = (-12992.1260, -944.8668, 0);
	at[0] = 0;
	points[1] = (-12992.1260, -944.8668, 30.4801);
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
	points[0] = (-12992.1260, -944.8668, 0);
	at[0] = 0;
	points[1] = (-12992.1260, -944.8668, 32.3851);
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
	points[0] = (-12992.1260, -944.8668, 0);
	at[0] = 0;
	points[1] = (-12992.1260, -944.8668, 20.9550);
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
	points[0] = (-12992.1260, -944.8668, 0);
	at[0] = 0;
	points[1] = (-12992.1260, -944.8668, 15.2400);
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
	points[0] = (-12992.1260, -944.8668, 0);
	at[0] = 0;
	points[1] = (-12992.1260, -944.8668, 9.5250);
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
	points[0] = (-9723.5820, 3988.3372, 39.3553);
	at[0] = 0;
	points[1] = (-9723.5820, 3988.3372, 48.8804);
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
	points[0] = (-9723.5820, 3988.3372, 39.3553);
	at[0] = 0;
	points[1] = (-9723.5820, 3988.3372, 54.5954);
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
	points[0] = (-9723.5820, 3988.3372, 39.3553);
	at[0] = 0;
	points[1] = (-9723.5820, 3988.3372, 60.3104);
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
	points[0] = (-9723.5820, 3988.3372, 39.3553);
	at[0] = 0;
	points[1] = (-9723.5820, 3988.3372, 66.0254);
	at[1] = 1;
	part = getEnt("iz_anim_17", "targetname");
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
	points[0] = (-9251.9688, 1181.1024, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9251.9688, 1181.1024, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-9251.9688, 1181.1024, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-9251.9688, 1181.1024, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-9251.9688, 1181.1024, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-9251.9688, 1181.1024, 78.7402);
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
	points[0] = (-10196.8506, 5433.0708, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10196.8506, 5433.0708, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-10196.8506, 5433.0708, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-10196.8506, 5433.0708, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-10196.8506, 5433.0708, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-10196.8506, 5433.0708, 78.7402);
	angles[5] = (360, 0, 0);
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
	points[0] = (-9251.9688, 5433.0708, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9251.9688, 5433.0708, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-9251.9688, 5433.0708, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-9251.9688, 5433.0708, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-9251.9688, 5433.0708, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-9251.9688, 5433.0708, 78.7402);
	angles[5] = (360, 0, 0);
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
	points[0] = (-1692.9135, 2598.4253, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1692.9135, 2598.4253, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-1692.9135, 2598.4253, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-1692.9135, 2598.4253, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-1692.9135, 2598.4253, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-1692.9135, 2598.4253, 78.7402);
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
	points[0] = (-3582.6772, 1889.7638, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3582.6772, 1889.7638, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3582.6772, 1889.7638, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3582.6772, 1889.7638, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3582.6772, 1889.7638, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3582.6772, 1889.7638, 78.7402);
	angles[5] = (360, 89.9945, 0);
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
	points[0] = (-3582.6772, 1889.7638, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3582.6772, 1889.7638, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3582.6772, 1889.7638, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3582.6772, 1889.7638, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3582.6772, 1889.7638, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3582.6772, 1889.7638, 78.7402);
	angles[5] = (360, 89.9945, 0);
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
	points[0] = (-3582.6772, 1889.7638, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3582.6772, 1889.7638, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3582.6772, 1889.7638, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3582.6772, 1889.7638, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3582.6772, 1889.7638, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3582.6772, 1889.7638, 78.7402);
	angles[5] = (360, 89.9945, 0);
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
	points[0] = (-3582.6772, 1889.7638, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-3582.6772, 1889.7638, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-3582.6772, 1889.7638, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-3582.6772, 1889.7638, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-3582.6772, 1889.7638, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-3582.6772, 1889.7638, 78.7402);
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
	points[0] = (-6417.3228, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-6417.3228, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-6417.3228, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-6417.3228, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-6417.3228, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-6417.3228, 4724.4097, 78.7402);
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
	points[0] = (-6417.3228, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-6417.3228, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-6417.3228, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-6417.3228, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-6417.3228, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-6417.3228, 4724.4097, 78.7402);
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
	points[0] = (-6417.3228, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-6417.3228, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-6417.3228, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-6417.3228, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-6417.3228, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-6417.3228, 4724.4097, 78.7402);
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
	points[0] = (-6417.3228, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-6417.3228, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-6417.3228, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-6417.3228, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-6417.3228, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-6417.3228, 4724.4097, 78.7402);
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
	points[0] = (-8307.0869, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-8307.0869, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-8307.0869, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-8307.0869, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-8307.0869, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-8307.0869, 4724.4097, 78.7402);
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
	points[0] = (-8307.0869, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-8307.0869, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-8307.0869, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-8307.0869, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-8307.0869, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-8307.0869, 4724.4097, 78.7402);
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
	points[0] = (-8307.0869, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-8307.0869, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-8307.0869, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-8307.0869, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-8307.0869, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-8307.0869, 4724.4097, 78.7402);
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
	points[0] = (-8307.0869, 4724.4097, 78.7402);
	angles[0] = (0, 89.9945, 0);
	at[0] = 0;
	points[1] = (-8307.0869, 4724.4097, 78.7402);
	angles[1] = (89.1258, 89.9980, 0.0028);
	at[1] = 12.3793;
	points[2] = (-8307.0869, 4724.4097, 78.7402);
	angles[2] = (178.9757, 89.9946, 0);
	at[2] = 24.8585;
	points[3] = (-8307.0869, 4724.4097, 78.7402);
	angles[3] = (268.8257, 89.9943, 0);
	at[3] = 37.3377;
	points[4] = (-8307.0869, 4724.4097, 78.7402);
	angles[4] = (358.6715, 89.9944, 0);
	at[4] = 49.8168;
	points[5] = (-8307.0869, 4724.4097, 78.7402);
	angles[5] = (360, 89.9945, 0);
	at[5] = 49.9167;
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
	points[0] = (-11141.7324, 944.8819, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-11141.7324, 944.8819, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-11141.7324, 944.8819, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-11141.7324, 944.8819, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-11141.7324, 944.8819, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-11141.7324, 944.8819, 78.7402);
	angles[5] = (360, 0, 0);
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
	points[0] = (-11141.7324, 944.8819, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-11141.7324, 944.8819, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-11141.7324, 944.8819, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-11141.7324, 944.8819, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-11141.7324, 944.8819, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-11141.7324, 944.8819, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-11141.7324, 944.8819, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-11141.7324, 944.8819, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-11141.7324, 944.8819, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-11141.7324, 944.8819, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-11141.7324, 944.8819, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-11141.7324, 944.8819, 78.7402);
	angles[5] = (360, 0, 0);
	at[5] = 49.9167;
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
	points[0] = (-11141.7324, 944.8819, 78.7402);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-11141.7324, 944.8819, 78.7402);
	angles[1] = (89.1258, 0, 0);
	at[1] = 12.3793;
	points[2] = (-11141.7324, 944.8819, 78.7402);
	angles[2] = (178.9757, 0, 0);
	at[2] = 24.8585;
	points[3] = (-11141.7324, 944.8819, 78.7402);
	angles[3] = (268.8257, 0, 0);
	at[3] = 37.3377;
	points[4] = (-11141.7324, 944.8819, 78.7402);
	angles[4] = (358.6715, 0, 0);
	at[4] = 49.8168;
	points[5] = (-11141.7324, 944.8819, 78.7402);
	angles[5] = (360, 0, 0);
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
	points[0] = (-2165.3542, 1417.3229, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2165.3542, 1417.3229, 275.5905);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-2165.3542, 1417.3229, 275.5905);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-2165.3542, 1417.3229, 275.5905);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-2165.3542, 1417.3229, 275.5905);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-2165.3542, 1417.3229, 275.5905);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-2165.3542, 1417.3229, 275.5905);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-2165.3542, 1417.3229, 275.5905);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-2165.3542, 1417.3229, 275.5905);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-2165.3542, 1417.3229, 275.5905);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-2165.3542, 1417.3229, 275.5905);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-2165.3542, 1417.3229, 275.5905);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-2165.3542, 1417.3229, 275.5905);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-2165.3542, 1417.3229, 275.5905);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-2165.3542, 1417.3229, 275.5905);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-2165.3542, 1417.3229, 275.5905);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-2165.3542, 1417.3229, 275.5905);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-2165.3542, 1417.3229, 275.5905);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-2165.3542, 1417.3229, 275.5905);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-2165.3542, 1417.3229, 275.5905);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-2165.3542, 1417.3229, 275.5905);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
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
	points[0] = (-2165.3542, 1417.3229, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2165.3542, 1417.3229, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-2165.3542, 1417.3229, 275.5905);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-2165.3542, 1417.3229, 275.5905);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-2165.3542, 1417.3229, 275.5905);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-2165.3542, 1417.3229, 275.5905);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
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
	points[0] = (-2165.3542, 1417.3229, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2165.3542, 1417.3229, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-2165.3542, 1417.3229, 275.5905);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-2165.3542, 1417.3229, 275.5905);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-2165.3542, 1417.3229, 275.5905);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-2165.3542, 1417.3229, 275.5905);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-2165.3542, 1417.3229, 275.5905);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-2165.3542, 1417.3229, 275.5905);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-2165.3542, 1417.3229, 275.5905);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-2165.3542, 1417.3229, 275.5905);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-2165.3542, 1417.3229, 275.5905);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-2165.3542, 1417.3229, 275.5905);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-2165.3542, 1417.3229, 275.5905);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
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
	points[0] = (-2165.3542, 1417.3229, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2165.3542, 1417.3229, 0);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-2165.3542, 1417.3229, 0);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-2165.3542, 1417.3229, 0);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-2165.3542, 1417.3229, 0);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-2165.3542, 1417.3229, 0);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-2165.3542, 1417.3229, 0);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-2165.3542, 1417.3229, 0);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-2165.3542, 1417.3229, 0);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-2165.3542, 1417.3229, 0);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-2165.3542, 1417.3229, 0);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-2165.3542, 1417.3229, 0);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-2165.3542, 1417.3229, 0);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-2165.3542, 1417.3229, 0);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-2165.3542, 1417.3229, 0);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-2165.3542, 1417.3229, 0);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-2165.3542, 1417.3229, 0);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-2165.3542, 1417.3229, 0);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-2165.3542, 1417.3229, 0);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-2165.3542, 1417.3229, 0);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-2165.3542, 1417.3229, 0);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
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
	points[0] = (-2165.3542, 1417.3229, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2165.3542, 1417.3229, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-2165.3542, 1417.3229, 0);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-2165.3542, 1417.3229, 0);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-2165.3542, 1417.3229, 0);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-2165.3542, 1417.3229, 0);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
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
	points[0] = (-2165.3542, 1417.3229, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2165.3542, 1417.3229, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-2165.3542, 1417.3229, 0);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-2165.3542, 1417.3229, 0);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-2165.3542, 1417.3229, 0);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-2165.3542, 1417.3229, 0);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-2165.3542, 1417.3229, 0);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-2165.3542, 1417.3229, 0);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-2165.3542, 1417.3229, 0);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-2165.3542, 1417.3229, 0);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-2165.3542, 1417.3229, 0);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-2165.3542, 1417.3229, 0);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-2165.3542, 1417.3229, 0);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
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
	points[0] = (-10669.2910, 2362.2048, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10669.2910, 2362.2048, 275.5905);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-10669.2910, 2362.2048, 275.5905);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-10669.2910, 2362.2048, 275.5905);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-10669.2910, 2362.2048, 275.5905);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-10669.2910, 2362.2048, 275.5905);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-10669.2910, 2362.2048, 275.5905);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-10669.2910, 2362.2048, 275.5905);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-10669.2910, 2362.2048, 275.5905);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-10669.2910, 2362.2048, 275.5905);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-10669.2910, 2362.2048, 275.5905);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-10669.2910, 2362.2048, 275.5905);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-10669.2910, 2362.2048, 275.5905);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-10669.2910, 2362.2048, 275.5905);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-10669.2910, 2362.2048, 275.5905);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-10669.2910, 2362.2048, 275.5905);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-10669.2910, 2362.2048, 275.5905);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-10669.2910, 2362.2048, 275.5905);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-10669.2910, 2362.2048, 275.5905);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-10669.2910, 2362.2048, 275.5905);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-10669.2910, 2362.2048, 275.5905);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
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
	points[0] = (-10669.2910, 2362.2048, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10669.2910, 2362.2048, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-10669.2910, 2362.2048, 275.5905);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-10669.2910, 2362.2048, 275.5905);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-10669.2910, 2362.2048, 275.5905);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-10669.2910, 2362.2048, 275.5905);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
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
	points[0] = (-10669.2910, 2362.2048, 275.5905);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10669.2910, 2362.2048, 275.5905);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-10669.2910, 2362.2048, 275.5905);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-10669.2910, 2362.2048, 275.5905);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-10669.2910, 2362.2048, 275.5905);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-10669.2910, 2362.2048, 275.5905);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-10669.2910, 2362.2048, 275.5905);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-10669.2910, 2362.2048, 275.5905);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-10669.2910, 2362.2048, 275.5905);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-10669.2910, 2362.2048, 275.5905);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-10669.2910, 2362.2048, 275.5905);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-10669.2910, 2362.2048, 275.5905);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-10669.2910, 2362.2048, 275.5905);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
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
	points[0] = (-10669.2910, 2362.2048, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10669.2910, 2362.2048, 0);
	angles[1] = (0, 89.1282, 0);
	at[1] = 3.0948;
	points[2] = (-10669.2910, 2362.2048, 0);
	angles[2] = (0, 178.2570, 0);
	at[2] = 6.1897;
	points[3] = (-10669.2910, 2362.2048, 0);
	angles[3] = (0, 267.3851, 0);
	at[3] = 9.2845;
	points[4] = (-10669.2910, 2362.2048, 0);
	angles[4] = (0, 356.5139, 0);
	at[4] = 12.3793;
	points[5] = (-10669.2910, 2362.2048, 0);
	angles[5] = (0, 445.6475, 0);
	at[5] = 15.4742;
	points[6] = (-10669.2910, 2362.2048, 0);
	angles[6] = (0, 534.7764, 0);
	at[6] = 18.5690;
	points[7] = (-10669.2910, 2362.2048, 0);
	angles[7] = (0, 623.9045, 0);
	at[7] = 21.6638;
	points[8] = (-10669.2910, 2362.2048, 0);
	angles[8] = (0, 669.9064, 0);
	at[8] = 23.2612;
	points[9] = (-10669.2910, 2362.2048, 0);
	angles[9] = (0, 715.9084, 0);
	at[9] = 24.8585;
	points[10] = (-10669.2910, 2362.2048, 0);
	angles[10] = (0, 805.0419, 0);
	at[10] = 27.9533;
	points[11] = (-10669.2910, 2362.2048, 0);
	angles[11] = (0, 894.1709, 0);
	at[11] = 31.0482;
	points[12] = (-10669.2910, 2362.2048, 0);
	angles[12] = (0, 983.2991, 0);
	at[12] = 34.1430;
	points[13] = (-10669.2910, 2362.2048, 0);
	angles[13] = (0, 1029.3010, 0);
	at[13] = 35.7403;
	points[14] = (-10669.2910, 2362.2048, 0);
	angles[14] = (0, 1075.3030, 0);
	at[14] = 37.3377;
	points[15] = (-10669.2910, 2362.2048, 0);
	angles[15] = (0, 1164.4364, 0);
	at[15] = 40.4325;
	points[16] = (-10669.2910, 2362.2048, 0);
	angles[16] = (0, 1253.5654, 0);
	at[16] = 43.5273;
	points[17] = (-10669.2910, 2362.2048, 0);
	angles[17] = (0, 1342.6936, 0);
	at[17] = 46.6222;
	points[18] = (-10669.2910, 2362.2048, 0);
	angles[18] = (0, 1388.6976, 0);
	at[18] = 48.2195;
	points[19] = (-10669.2910, 2362.2048, 0);
	angles[19] = (0, 1434.7021, 0);
	at[19] = 49.8168;
	points[20] = (-10669.2910, 2362.2048, 0);
	angles[20] = (0, 1440, 0);
	at[20] = 49.9167;
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
	points[0] = (-10669.2910, 2362.2048, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10669.2910, 2362.2048, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 12.3793;
	points[2] = (-10669.2910, 2362.2048, 0);
	angles[2] = (0, 178.9757, 0);
	at[2] = 24.8585;
	points[3] = (-10669.2910, 2362.2048, 0);
	angles[3] = (0, 268.8257, 0);
	at[3] = 37.3377;
	points[4] = (-10669.2910, 2362.2048, 0);
	angles[4] = (0, 358.6715, 0);
	at[4] = 49.8168;
	points[5] = (-10669.2910, 2362.2048, 0);
	angles[5] = (0, 360, 0);
	at[5] = 49.9167;
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
	points[0] = (-10669.2910, 2362.2048, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10669.2910, 2362.2048, 0);
	angles[1] = (0, 89.1258, 0);
	at[1] = 6.1897;
	points[2] = (-10669.2910, 2362.2048, 0);
	angles[2] = (0, 178.2569, 0);
	at[2] = 12.3793;
	points[3] = (-10669.2910, 2362.2048, 0);
	angles[3] = (0, 267.3881, 0);
	at[3] = 18.5690;
	points[4] = (-10669.2910, 2362.2048, 0);
	angles[4] = (0, 311.9511, 0);
	at[4] = 21.6638;
	points[5] = (-10669.2910, 2362.2048, 0);
	angles[5] = (0, 357.9515, 0);
	at[5] = 24.8585;
	points[6] = (-10669.2910, 2362.2048, 0);
	angles[6] = (0, 447.0825, 0);
	at[6] = 31.0482;
	points[7] = (-10669.2910, 2362.2048, 0);
	angles[7] = (0, 491.6483, 0);
	at[7] = 34.1430;
	points[8] = (-10669.2910, 2362.2048, 0);
	angles[8] = (0, 537.6514, 0);
	at[8] = 37.3377;
	points[9] = (-10669.2910, 2362.2048, 0);
	angles[9] = (0, 626.7826, 0);
	at[9] = 43.5273;
	points[10] = (-10669.2910, 2362.2048, 0);
	angles[10] = (0, 671.3469, 0);
	at[10] = 46.6222;
	points[11] = (-10669.2910, 2362.2048, 0);
	angles[11] = (0, 717.3484, 0);
	at[11] = 49.8168;
	points[12] = (-10669.2910, 2362.2048, 0);
	angles[12] = (0, 720, 0);
	at[12] = 49.9167;
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
	points[0] = (-5000, 4251.9688, 275.5905);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5000, 4251.9688, 275.5905);
	angles[1] = (0, -0.8718, 0);
	at[1] = 3.0948;
	points[2] = (-5000, 4251.9688, 275.5905);
	angles[2] = (0, 88.2570, 0);
	at[2] = 6.1897;
	points[3] = (-5000, 4251.9688, 275.5905);
	angles[3] = (0, 177.3851, 0);
	at[3] = 9.2845;
	points[4] = (-5000, 4251.9688, 275.5905);
	angles[4] = (0, 266.5139, 0);
	at[4] = 12.3793;
	points[5] = (-5000, 4251.9688, 275.5905);
	angles[5] = (0, 355.6475, 0);
	at[5] = 15.4742;
	points[6] = (-5000, 4251.9688, 275.5905);
	angles[6] = (0, 444.7764, 0);
	at[6] = 18.5690;
	points[7] = (-5000, 4251.9688, 275.5905);
	angles[7] = (0, 533.9046, 0);
	at[7] = 21.6638;
	points[8] = (-5000, 4251.9688, 275.5905);
	angles[8] = (0, 579.9065, 0);
	at[8] = 23.2612;
	points[9] = (-5000, 4251.9688, 275.5905);
	angles[9] = (0, 625.9083, 0);
	at[9] = 24.8585;
	points[10] = (-5000, 4251.9688, 275.5905);
	angles[10] = (0, 715.0419, 0);
	at[10] = 27.9533;
	points[11] = (-5000, 4251.9688, 275.5905);
	angles[11] = (0, 804.1709, 0);
	at[11] = 31.0482;
	points[12] = (-5000, 4251.9688, 275.5905);
	angles[12] = (0, 893.2991, 0);
	at[12] = 34.1430;
	points[13] = (-5000, 4251.9688, 275.5905);
	angles[13] = (0, 939.3010, 0);
	at[13] = 35.7403;
	points[14] = (-5000, 4251.9688, 275.5905);
	angles[14] = (0, 985.3031, 0);
	at[14] = 37.3377;
	points[15] = (-5000, 4251.9688, 275.5905);
	angles[15] = (0, 1074.4364, 0);
	at[15] = 40.4325;
	points[16] = (-5000, 4251.9688, 275.5905);
	angles[16] = (0, 1163.5653, 0);
	at[16] = 43.5273;
	points[17] = (-5000, 4251.9688, 275.5905);
	angles[17] = (0, 1252.6936, 0);
	at[17] = 46.6222;
	points[18] = (-5000, 4251.9688, 275.5905);
	angles[18] = (0, 1298.6978, 0);
	at[18] = 48.2195;
	points[19] = (-5000, 4251.9688, 275.5905);
	angles[19] = (0, 1344.7021, 0);
	at[19] = 49.8168;
	points[20] = (-5000, 4251.9688, 275.5905);
	angles[20] = (0, 1350, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_32", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_33()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5000, 4251.9688, 275.5905);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5000, 4251.9688, 275.5905);
	angles[1] = (0, -0.8742, 0);
	at[1] = 12.3793;
	points[2] = (-5000, 4251.9688, 275.5905);
	angles[2] = (0, 88.9757, 0);
	at[2] = 24.8585;
	points[3] = (-5000, 4251.9688, 275.5905);
	angles[3] = (0, 178.8257, 0);
	at[3] = 37.3377;
	points[4] = (-5000, 4251.9688, 275.5905);
	angles[4] = (0, 268.6715, 0);
	at[4] = 49.8168;
	points[5] = (-5000, 4251.9688, 275.5905);
	angles[5] = (0, 270, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_33", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_34()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5000, 4251.9688, 275.5905);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5000, 4251.9688, 275.5905);
	angles[1] = (0, -0.8742, 0);
	at[1] = 6.1897;
	points[2] = (-5000, 4251.9688, 275.5905);
	angles[2] = (0, 88.2568, 0);
	at[2] = 12.3793;
	points[3] = (-5000, 4251.9688, 275.5905);
	angles[3] = (0, 177.3881, 0);
	at[3] = 18.5690;
	points[4] = (-5000, 4251.9688, 275.5905);
	angles[4] = (0, 221.9512, 0);
	at[4] = 21.6638;
	points[5] = (-5000, 4251.9688, 275.5905);
	angles[5] = (0, 267.9515, 0);
	at[5] = 24.8585;
	points[6] = (-5000, 4251.9688, 275.5905);
	angles[6] = (0, 357.0826, 0);
	at[6] = 31.0482;
	points[7] = (-5000, 4251.9688, 275.5905);
	angles[7] = (0, 401.6483, 0);
	at[7] = 34.1430;
	points[8] = (-5000, 4251.9688, 275.5905);
	angles[8] = (0, 447.6514, 0);
	at[8] = 37.3377;
	points[9] = (-5000, 4251.9688, 275.5905);
	angles[9] = (0, 536.7827, 0);
	at[9] = 43.5273;
	points[10] = (-5000, 4251.9688, 275.5905);
	angles[10] = (0, 581.3468, 0);
	at[10] = 46.6222;
	points[11] = (-5000, 4251.9688, 275.5905);
	angles[11] = (0, 627.3484, 0);
	at[11] = 49.8168;
	points[12] = (-5000, 4251.9688, 275.5905);
	angles[12] = (0, 630, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_34", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_35()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5000, 4251.9688, 275.5905);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5000, 4251.9688, 275.5905);
	angles[1] = (0, -0.8718, 0);
	at[1] = 3.0948;
	points[2] = (-5000, 4251.9688, 275.5905);
	angles[2] = (0, 88.2570, 0);
	at[2] = 6.1897;
	points[3] = (-5000, 4251.9688, 275.5905);
	angles[3] = (0, 177.3851, 0);
	at[3] = 9.2845;
	points[4] = (-5000, 4251.9688, 275.5905);
	angles[4] = (0, 266.5139, 0);
	at[4] = 12.3793;
	points[5] = (-5000, 4251.9688, 275.5905);
	angles[5] = (0, 355.6475, 0);
	at[5] = 15.4742;
	points[6] = (-5000, 4251.9688, 275.5905);
	angles[6] = (0, 444.7764, 0);
	at[6] = 18.5690;
	points[7] = (-5000, 4251.9688, 275.5905);
	angles[7] = (0, 533.9046, 0);
	at[7] = 21.6638;
	points[8] = (-5000, 4251.9688, 275.5905);
	angles[8] = (0, 579.9065, 0);
	at[8] = 23.2612;
	points[9] = (-5000, 4251.9688, 275.5905);
	angles[9] = (0, 625.9083, 0);
	at[9] = 24.8585;
	points[10] = (-5000, 4251.9688, 275.5905);
	angles[10] = (0, 715.0419, 0);
	at[10] = 27.9533;
	points[11] = (-5000, 4251.9688, 275.5905);
	angles[11] = (0, 804.1709, 0);
	at[11] = 31.0482;
	points[12] = (-5000, 4251.9688, 275.5905);
	angles[12] = (0, 893.2991, 0);
	at[12] = 34.1430;
	points[13] = (-5000, 4251.9688, 275.5905);
	angles[13] = (0, 939.3010, 0);
	at[13] = 35.7403;
	points[14] = (-5000, 4251.9688, 275.5905);
	angles[14] = (0, 985.3031, 0);
	at[14] = 37.3377;
	points[15] = (-5000, 4251.9688, 275.5905);
	angles[15] = (0, 1074.4364, 0);
	at[15] = 40.4325;
	points[16] = (-5000, 4251.9688, 275.5905);
	angles[16] = (0, 1163.5653, 0);
	at[16] = 43.5273;
	points[17] = (-5000, 4251.9688, 275.5905);
	angles[17] = (0, 1252.6936, 0);
	at[17] = 46.6222;
	points[18] = (-5000, 4251.9688, 275.5905);
	angles[18] = (0, 1298.6978, 0);
	at[18] = 48.2195;
	points[19] = (-5000, 4251.9688, 275.5905);
	angles[19] = (0, 1344.7021, 0);
	at[19] = 49.8168;
	points[20] = (-5000, 4251.9688, 275.5905);
	angles[20] = (0, 1350, 0);
	at[20] = 49.9167;
	mover = getEnt("pso_loop_35", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_36()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5000, 4251.9688, 275.5905);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5000, 4251.9688, 275.5905);
	angles[1] = (0, -0.8742, 0);
	at[1] = 12.3793;
	points[2] = (-5000, 4251.9688, 275.5905);
	angles[2] = (0, 88.9757, 0);
	at[2] = 24.8585;
	points[3] = (-5000, 4251.9688, 275.5905);
	angles[3] = (0, 178.8257, 0);
	at[3] = 37.3377;
	points[4] = (-5000, 4251.9688, 275.5905);
	angles[4] = (0, 268.6715, 0);
	at[4] = 49.8168;
	points[5] = (-5000, 4251.9688, 275.5905);
	angles[5] = (0, 270, 0);
	at[5] = 49.9167;
	mover = getEnt("pso_loop_36", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

pso_loop_37()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5000, 4251.9688, 275.5905);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5000, 4251.9688, 275.5905);
	angles[1] = (0, -0.8742, 0);
	at[1] = 6.1897;
	points[2] = (-5000, 4251.9688, 275.5905);
	angles[2] = (0, 88.2568, 0);
	at[2] = 12.3793;
	points[3] = (-5000, 4251.9688, 275.5905);
	angles[3] = (0, 177.3881, 0);
	at[3] = 18.5690;
	points[4] = (-5000, 4251.9688, 275.5905);
	angles[4] = (0, 221.9512, 0);
	at[4] = 21.6638;
	points[5] = (-5000, 4251.9688, 275.5905);
	angles[5] = (0, 267.9515, 0);
	at[5] = 24.8585;
	points[6] = (-5000, 4251.9688, 275.5905);
	angles[6] = (0, 357.0826, 0);
	at[6] = 31.0482;
	points[7] = (-5000, 4251.9688, 275.5905);
	angles[7] = (0, 401.6483, 0);
	at[7] = 34.1430;
	points[8] = (-5000, 4251.9688, 275.5905);
	angles[8] = (0, 447.6514, 0);
	at[8] = 37.3377;
	points[9] = (-5000, 4251.9688, 275.5905);
	angles[9] = (0, 536.7827, 0);
	at[9] = 43.5273;
	points[10] = (-5000, 4251.9688, 275.5905);
	angles[10] = (0, 581.3468, 0);
	at[10] = 46.6222;
	points[11] = (-5000, 4251.9688, 275.5905);
	angles[11] = (0, 627.3484, 0);
	at[11] = 49.8168;
	points[12] = (-5000, 4251.9688, 275.5905);
	angles[12] = (0, 630, 0);
	at[12] = 49.9167;
	mover = getEnt("pso_loop_37", "targetname");
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
