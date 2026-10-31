main()
{
	visionSetNaked("mp_pso_forest2", 0);

	setExpFog(0, 7381.8892, 0.2196, 0.1922, 0.2824, 0);

	maps\mp\mp_pso_forest2_fx::main();

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
	iz_emitter("iz_1_f_env_005", (1121.3947, -253.3043, 94.4714), 0, 2.4445);
	iz_emitter("iz_2_f_env_006", (-1098.1161, -1686.4082, 210.8945), 0, 2.4792);
	iz_emitter("iz_3_f_env_004", (1226.2079, -1845.2225, 429.5266), 0, 2.4246);
	iz_emitter("iz_3_f_env_004", (-65.6443, 1678.7610, 429.5266), 0, 2.4246);
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
	thread iz_anim_26();
	thread iz_anim_27();
	thread iz_anim_28();
	thread iz_anim_29();
	thread iz_anim_30();
	thread iz_anim_31();
	thread iz_anim_32();
	thread iz_anim_33();
	thread iz_anim_34();
	thread iz_anim_35();
	thread iz_anim_36();
	thread iz_anim_37();
}

iz_anim_0()
{
	points = [];
	at = [];
	points[0] = (2305.7168, -2312.4265, 299.5763);
	at[0] = 0;
	points[1] = (2305.7168, -2312.4265, 330.0564);
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
	points[0] = (2305.7168, -2312.4265, 299.5763);
	at[0] = 0;
	points[1] = (2305.7168, -2312.4265, 331.9614);
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
	points[0] = (2305.7168, -2312.4265, 299.5763);
	at[0] = 0;
	points[1] = (2305.7168, -2312.4265, 320.5314);
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
	points[0] = (2305.7168, -2312.4265, 299.5763);
	at[0] = 0;
	points[1] = (2305.7168, -2312.4265, 314.8164);
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
	points[0] = (2305.7168, -2312.4265, 299.5763);
	at[0] = 0;
	points[1] = (2305.7168, -2312.4265, 309.1013);
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
	points[0] = (-611.8463, -1971.7646, 238.4562);
	at[0] = 0;
	points[1] = (-611.8463, -1971.7646, 269.3172);
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
	points[0] = (-611.8463, -1971.7646, 238.4562);
	at[0] = 0;
	points[1] = (-611.8463, -1971.7646, 270.8412);
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
	points[0] = (-611.8463, -1971.7646, 238.4562);
	at[0] = 0;
	points[1] = (-611.8463, -1971.7646, 259.4112);
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
	points[0] = (-611.8463, -1971.7646, 238.4562);
	at[0] = 0;
	points[1] = (-611.8463, -1971.7646, 253.3152);
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
	points[0] = (-611.8463, -1971.7646, 238.4562);
	at[0] = 0;
	points[1] = (-611.8463, -1971.7646, 247.9812);
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
	points[0] = (559.6948, 982.9582, 73.1643);
	at[0] = 0;
	points[1] = (559.6948, 982.9582, 107.4163);
	at[1] = 0.9667;
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
	points[0] = (559.6948, 982.9582, 73.1643);
	at[0] = 0;
	points[1] = (559.6948, 982.9582, 107.4162);
	at[1] = 0.9667;
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
	points[0] = (559.6948, 982.9582, 73.1643);
	at[0] = 0;
	points[1] = (559.6948, 982.9582, 95.9989);
	at[1] = 0.9667;
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
	points[0] = (559.6948, 982.9582, 73.1643);
	at[0] = 0;
	points[1] = (559.6948, 982.9582, 88.3873);
	at[1] = 0.9667;
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
	points[0] = (-1517.9756, 699.2153, 227.0620);
	at[0] = 0;
	points[1] = (-1517.9756, 699.2153, 236.5871);
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
	points[0] = (-1517.9756, 699.2153, 227.0620);
	at[0] = 0;
	points[1] = (-1517.9756, 699.2153, 242.3021);
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
	points[0] = (-1517.9756, 699.2153, 227.0620);
	at[0] = 0;
	points[1] = (-1517.9756, 699.2153, 248.0171);
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
	points[0] = (-1517.9756, 699.2153, 227.0620);
	at[0] = 0;
	points[1] = (-1517.9756, 699.2153, 253.7321);
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
	points[0] = (-1556.4072, -210.8069, 211.3438);
	at[0] = 0;
	points[1] = (-1556.4072, -210.8069, 220.8688);
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
	points[0] = (-1556.4072, -210.8069, 211.3438);
	at[0] = 0;
	points[1] = (-1556.4072, -210.8069, 226.5838);
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
	points[0] = (-1556.4072, -210.8069, 211.3438);
	at[0] = 0;
	points[1] = (-1556.4072, -210.8069, 232.2988);
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
	points[0] = (-1556.4072, -210.8069, 211.3438);
	at[0] = 0;
	points[1] = (-1556.4072, -210.8069, 238.0138);
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
	points[0] = (-1338.1848, -650.6344, 16.6449);
	at[0] = 0;
	points[1] = (-1338.1848, -650.6344, 26.1700);
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
	points[0] = (-1338.1848, -650.6344, 16.6449);
	at[0] = 0;
	points[1] = (-1338.1848, -650.6344, 31.8850);
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
	points[0] = (-1338.1848, -650.6344, 16.6449);
	at[0] = 0;
	points[1] = (-1338.1848, -650.6344, 37.6000);
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
	points[0] = (-1338.1848, -650.6344, 16.6449);
	at[0] = 0;
	points[1] = (-1338.1848, -650.6344, 43.3150);
	at[1] = 1;
	part = getEnt("iz_anim_25", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_26()
{
	points = [];
	at = [];
	points[0] = (-1096.7939, 852.6481, 45.6157);
	at[0] = 0;
	points[1] = (-1096.7939, 852.6481, 55.1407);
	at[1] = 1;
	part = getEnt("iz_anim_26", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_27()
{
	points = [];
	at = [];
	points[0] = (-1096.7939, 852.6481, 45.6157);
	at[0] = 0;
	points[1] = (-1096.7939, 852.6481, 60.8557);
	at[1] = 1;
	part = getEnt("iz_anim_27", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_28()
{
	points = [];
	at = [];
	points[0] = (-1096.7939, 852.6481, 45.6157);
	at[0] = 0;
	points[1] = (-1096.7939, 852.6481, 66.5707);
	at[1] = 1;
	part = getEnt("iz_anim_28", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_29()
{
	points = [];
	at = [];
	points[0] = (-1096.7939, 852.6481, 45.6157);
	at[0] = 0;
	points[1] = (-1096.7939, 852.6481, 72.2858);
	at[1] = 1;
	part = getEnt("iz_anim_29", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_30()
{
	points = [];
	at = [];
	points[0] = (-920.3461, 1154.9980, 60.8278);
	at[0] = 0;
	points[1] = (-920.4100, 1154.8540, 95.0794);
	at[1] = 0.9667;
	part = getEnt("iz_anim_30", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_31()
{
	points = [];
	at = [];
	points[0] = (-920.3461, 1154.9980, 60.8278);
	at[0] = 0;
	points[1] = (-920.4100, 1154.8540, 95.0794);
	at[1] = 0.9667;
	part = getEnt("iz_anim_31", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_32()
{
	points = [];
	at = [];
	points[0] = (-920.3461, 1154.9980, 60.8278);
	at[0] = 0;
	points[1] = (-920.3887, 1154.9020, 83.6622);
	at[1] = 0.9667;
	part = getEnt("iz_anim_32", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_33()
{
	points = [];
	at = [];
	points[0] = (-920.3461, 1154.9980, 60.8278);
	at[0] = 0;
	points[1] = (-920.3745, 1154.9340, 76.0507);
	at[1] = 0.9667;
	part = getEnt("iz_anim_33", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_34()
{
	points = [];
	at = [];
	points[0] = (-1040.8951, 1208.7581, 60.8118);
	at[0] = 0;
	points[1] = (-1040.8951, 1208.7581, 95.0638);
	at[1] = 0.9667;
	part = getEnt("iz_anim_34", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_35()
{
	points = [];
	at = [];
	points[0] = (-1040.8951, 1208.7581, 60.8118);
	at[0] = 0;
	points[1] = (-1040.8951, 1208.7581, 95.0637);
	at[1] = 0.9667;
	part = getEnt("iz_anim_35", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_36()
{
	points = [];
	at = [];
	points[0] = (-1040.8951, 1208.7581, 60.8118);
	at[0] = 0;
	points[1] = (-1040.8951, 1208.7581, 83.6464);
	at[1] = 0.9667;
	part = getEnt("iz_anim_36", "targetname");
	if (!isDefined(part))
		return;
	part notSolid();
	part thread iz_mover_loop(points, undefined, at, false, false);
}

iz_anim_37()
{
	points = [];
	at = [];
	points[0] = (-1040.8951, 1208.7581, 60.8118);
	at[0] = 0;
	points[1] = (-1040.8951, 1208.7581, 76.0348);
	at[1] = 0.9667;
	part = getEnt("iz_anim_37", "targetname");
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
