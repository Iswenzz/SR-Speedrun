main()
{
	visionSetNaked("mp_pso_forest1", 0);

	setExpFog(0, 3280.8401, 0.5020, 1, 0.6667, 0);

	thread iz_sounds();

	thread iz_anims();

	thread iz_door_signs();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_forest_n", 2);
	iz_emitter("iz_1_f_env_000", (-1889.7638, 1889.7638, 0), 0, 4);
	iz_emitter("iz_2_f_env_001", (29.2700, -1723.0706, 46.4190), 0, 0.9834);
	iz_emitter("iz_3_f_env_002", (900.0833, -2044.1238, 45.1944), 0, 1.5542);
	iz_emitter("iz_3_f_env_002", (-985.8899, -655.0248, 45.1944), 0, 1.5542);
	iz_emitter("iz_3_f_env_002", (-2134.5339, -102.0777, 45.1944), 0, 1.5542);
	iz_emitter("iz_3_f_env_002", (-2082.5408, 1675.5009, 45.1944), 0, 1.5542);
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
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (-2107.3662, -2249.5020, 6.1360);
	at[0] = 0;
	points[1] = (-2107.3662, -2249.5020, 36.6161);
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
	points[0] = (-2107.3662, -2249.5020, 6.1360);
	at[0] = 0;
	points[1] = (-2107.3662, -2249.5020, 38.5211);
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
	points[0] = (-2107.3662, -2249.5020, 6.1360);
	at[0] = 0;
	points[1] = (-2107.3662, -2249.5020, 27.0911);
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
	points[0] = (-2107.3662, -2249.5020, 6.1360);
	at[0] = 0;
	points[1] = (-2107.3662, -2249.5020, 21.3761);
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
	points[0] = (-2107.3662, -2249.5020, 6.1360);
	at[0] = 0;
	points[1] = (-2107.3662, -2249.5020, 15.6611);
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
	points[0] = (-870.3015, 1940.5137, 101.2713);
	at[0] = 0;
	points[1] = (-870.3015, 1940.5137, 135.5233);
	at[1] = 0.9667;
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
	points[0] = (-870.3015, 1940.5137, 101.2713);
	at[0] = 0;
	points[1] = (-870.3015, 1940.5137, 135.5233);
	at[1] = 0.9667;
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
	points[0] = (-870.3015, 1940.5137, 101.2713);
	at[0] = 0;
	points[1] = (-870.3015, 1940.5137, 124.1060);
	at[1] = 0.9667;
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
	points[0] = (-870.3015, 1940.5137, 101.2713);
	at[0] = 0;
	points[1] = (-870.3015, 1940.5137, 116.4944);
	at[1] = 0.9667;
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
	points[0] = (-2260.1382, 1999.6305, 18.5007);
	at[0] = 0;
	points[1] = (-2260.1382, 1999.6305, 48.9807);
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
	points[0] = (-2260.1382, 1999.6305, 18.5007);
	at[0] = 0;
	points[1] = (-2260.1382, 1999.6305, 50.8857);
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
	points[0] = (-2260.1382, 1999.6305, 18.5007);
	at[0] = 0;
	points[1] = (-2260.1382, 1999.6305, 39.4557);
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
	points[0] = (-2260.1382, 1999.6305, 18.5007);
	at[0] = 0;
	points[1] = (-2260.1382, 1999.6305, 33.7407);
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
	points[0] = (-2260.1382, 1999.6305, 18.5007);
	at[0] = 0;
	points[1] = (-2260.1382, 1999.6305, 28.0257);
	at[1] = 1;
	part = getEnt("iz_anim_13", "targetname");
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

iz_door_signs()
{
	signs = getEntArray("iz_door_sign", "targetname");
	doors = getEntArray("q3_door", "targetname");
	for (i = 0; i < signs.size; i++)
	{
		for (j = 0; j < doors.size; j++)
		{
			if (distanceSquared(doors[j].origin, signs[i].origin) < 1)
			{
				signs[i] thread iz_door_sign(doors[j]);
				break;
			}
		}
	}
}

iz_door_sign(door)
{
	shut = door.origin;
	for (;;)
	{
		while (door.origin == shut)
			wait 0.05;
		self hide();
		while (door.origin != shut)
			wait 0.05;
		self show();
	}
}
