main()
{
	visionSetNaked("mp_pso_cave2_0", 0);

	setExpFog(0, 3280.8401, 0.5020, 1, 0.6667, 0);

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
	iz_emitter("iz_1_c_env_003", (1181.1024, -196.8504, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (-2362.2048, -3740.1575, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (787.4016, -9448.8193, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (-8110.2363, -7854.3306, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (-1555.1182, -10492.1260, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (-216.5354, -9704.7246, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (1968.5039, -3740.1575, 0), 0, 2.1562);
	iz_emitter("iz_1_c_env_003", (984.2520, -4527.5591, 0), 0, 2.1562);
	iz_emitter("iz_2_c_env_005", (0, -2559.0552, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (-1377.9528, -3740.1575, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (-1555.1182, -11476.3779, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (787.4016, -8464.5674, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (-7125.9844, -7854.3306, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (1181.1024, -1181.1024, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (0, -4527.5591, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (0, -1181.1024, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (-1377.9528, -2559.0552, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (1968.5039, -2559.0552, 0), 0, 2.9925);
	iz_emitter("iz_2_c_env_005", (-5748.0317, -7854.3306, 0), 0, 2.9925);
	iz_emitter("iz_3_c_env_004", (-4253.3711, -11125.8672, 0), 0, 2.4443);
	iz_emitter("iz_3_c_env_004", (-4372.0669, -9827.4551, 0), 0, 2.4443);
	iz_emitter("iz_3_c_env_004", (-1255.2222, -9116.1621, 0), 0, 2.4443);
	iz_emitter("iz_4_c_env_004", (-1377.9528, -6003.9370, 0), 0, 2.4443);
	iz_emitter("iz_5_c_env_003", (-4901.5747, -11476.3779, 0), 0, 2.1562);
	iz_emitter("iz_5_c_env_003", (-1377.9528, -7283.4648, 0), 0, 2.1562);
	iz_emitter("iz_5_c_env_003", (-2539.3701, -9704.7246, 0), 0, 2.1562);
	iz_emitter("iz_5_c_env_003", (-5748.0317, -11476.3779, 0), 0, 2.1562);
	iz_emitter("iz_5_c_env_003", (-1692.9135, -9704.7246, 0), 0, 2.1562);
	iz_emitter("iz_5_c_env_003", (-1062.9922, -9704.7246, 0), 0, 2.1562);
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
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (1220.4724, -23.6220, 0);
	at[0] = 0;
	points[1] = (1220.4724, -23.6220, 30.4801);
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
	points[0] = (1220.4724, -23.6220, 0);
	at[0] = 0;
	points[1] = (1220.4724, -23.6220, 32.3851);
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
	points[0] = (1220.4724, -23.6220, 0);
	at[0] = 0;
	points[1] = (1220.4724, -23.6220, 20.9550);
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
	points[0] = (1220.4724, -23.6220, 0);
	at[0] = 0;
	points[1] = (1220.4724, -23.6220, 15.2400);
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
	points[0] = (1220.4724, -23.6220, 0);
	at[0] = 0;
	points[1] = (1220.4724, -23.6220, 9.5250);
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
	points[0] = (918.0453, -9343.9014, 0);
	at[0] = 0;
	points[1] = (918.0453, -9343.9014, 9.5250);
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
	points[0] = (918.0453, -9343.9014, 0);
	at[0] = 0;
	points[1] = (918.0453, -9343.9014, 15.2400);
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
	points[0] = (918.0453, -9343.9014, 0);
	at[0] = 0;
	points[1] = (918.0453, -9343.9014, 20.9550);
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
	points[0] = (918.0453, -9343.9014, 0);
	at[0] = 0;
	points[1] = (918.0453, -9343.9014, 26.6701);
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
	points[0] = (-8283.4648, -7814.9609, 0);
	at[0] = 0;
	points[1] = (-8283.4648, -7814.9609, 30.4801);
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
	points[0] = (-8283.4648, -7814.9609, 0);
	at[0] = 0;
	points[1] = (-8283.4648, -7814.9609, 32.3851);
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
	points[0] = (-8283.4648, -7814.9609, 0);
	at[0] = 0;
	points[1] = (-8283.4648, -7814.9609, 20.9550);
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
	points[0] = (-8283.4648, -7814.9609, 0);
	at[0] = 0;
	points[1] = (-8283.4648, -7814.9609, 15.2400);
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
	points[0] = (-8283.4648, -7814.9609, 0);
	at[0] = 0;
	points[1] = (-8283.4648, -7814.9609, 9.5250);
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
	points[0] = (-305.7479, -9560.8076, 0);
	at[0] = 0;
	points[1] = (-305.7479, -9560.8076, 9.5250);
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
	points[0] = (-305.7479, -9560.8076, 0);
	at[0] = 0;
	points[1] = (-305.7479, -9560.8076, 15.2400);
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
	points[0] = (-305.7479, -9560.8076, 0);
	at[0] = 0;
	points[1] = (-305.7479, -9560.8076, 20.9550);
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
	points[0] = (-305.7479, -9560.8076, 0);
	at[0] = 0;
	points[1] = (-305.7479, -9560.8076, 26.6701);
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
