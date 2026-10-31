main()
{
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
	iz_emitter("iz_0_amb7", (-1280, -15984, 392), 0, 1.8285);
	iz_emitter("iz_1_loop_vent_01", (-2080, -13552, 384), 0, 4.8434);
	iz_emitter("iz_0_amb7", (-1280, -13696, 392), 0, 1.8285);
	iz_emitter("iz_0_amb7", (-1216, -11584, 216), 0, 1.8285);
	iz_emitter("iz_0_amb7", (-368, -11584, 216), 0, 1.8285);
	iz_emitter("iz_0_amb7", (-960, -10400, 216), 0, 1.8285);
	iz_emitter("iz_0_amb7", (-2368, -8032, 56), 0, 1.8285);
	iz_emitter("iz_2_amb23", (-2416, -15968, 144), 0, 3.6210);
	iz_emitter("iz_3_tim_pulse2", (-4048, -15184, 448), 0, 3.7629);
	iz_emitter("iz_4_loop_fan_03", (-4160, -15104, 112), 0, 8.4192);
	iz_emitter("iz_4_loop_fan_03", (-2760, -13440, 112), 0, 8.4192);
	iz_emitter("iz_5_deep_mach", (-2832, -15344, 312), 0, 4.4830);
	iz_emitter("iz_5_deep_mach", (-2832, -14320, 312), 0, 4.4830);
	iz_emitter("iz_5_deep_mach", (-2352, -14832, 312), 0, 4.4830);
	iz_emitter("iz_5_deep_mach", (-3344, -14832, 312), 0, 4.4830);
	iz_emitter("iz_6_lava_amb_01_quiet", (-3776, -14272, -96), 0, 2.9398);
	iz_emitter("iz_7_amb16", (-2832, -15456, 256), 0, 4.0144);
	iz_emitter("iz_7_amb16", (-3472, -14752, 256), 0, 4.0144);
	iz_emitter("iz_6_lava_amb_01_quiet", (-4064, -15648, -96), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (-832, -13568, -288), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (0, -12608, -288), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (0, -13504, -288), 0, 2.9398);
	iz_emitter("iz_8_l_hum1", (-2496, -6976, 120), 0, 1.8624);
	iz_emitter("iz_0_amb7", (-1360, 2816, -184), 0, 1.8285);
	iz_emitter("iz_9_loop_neonlight_02", (-1216, 3456, -40), 0, 6.5107);
	iz_emitter("iz_4_loop_fan_03", (-800, 928, -416), 0, 8.4192);
	iz_emitter("iz_1_loop_vent_01", (-608, 1368, -128), 0, 4.8434);
	iz_emitter("iz_1_loop_vent_01", (-608, 1816, -128), 0, 4.8434);
	iz_emitter("iz_1_loop_vent_01", (-608, 2264, -128), 0, 4.8434);
	iz_emitter("iz_1_loop_vent_01", (-608, 2712, -128), 0, 4.8434);
	iz_emitter("iz_10_bigair_machloop", (-544, 7072, -480), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-544, 7872, -480), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-544, 11840, -480), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-592, 8640, -432), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-592, 9408, -432), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-592, 10240, -432), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-544, 11072, -480), 0, 1.9532);
	iz_emitter("iz_11_tim_machine", (-1800, 11552, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-2376, 11552, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-2952, 11552, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-3528, 11552, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-4104, 11552, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-4680, 11552, -976), 0, 9.5639);
	iz_emitter("iz_0_amb7", (-3104, 17440, -900), 0, 1.8285);
	iz_emitter("iz_11_tim_machine", (-1792, 8608, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-1664, 9248, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-1280, 8992, -976), 0, 9.5639);
	iz_emitter("iz_11_tim_machine", (-1024, 9632, -976), 0, 9.5639);
	iz_emitter("iz_12_fan1", (-3487.8501, 19519.3008, -1440), 0, 4.8840);
	iz_emitter("iz_0_amb7", (-2144, 20367.9980, -1156), 0, 1.8285);
	iz_emitter("iz_9_loop_neonlight_02", (-1536, 21216, -1320), 0, 6.5107);
	iz_emitter("iz_9_loop_neonlight_02", (-624, 20128, -1280), 0, 6.5107);
	iz_emitter("iz_3_tim_pulse2", (-1920, -13536, 160), 0, 3.7629);
	iz_emitter("iz_10_bigair_machloop", (-1120, 14848, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 18944, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 15360, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 15872, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 16384, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 16896, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 17408, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 17920, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1120, 18432, -800), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-2112, 21920, -1328), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-1536, 21920, -1328), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-960, 21920, -1328), 0, 1.9532);
	iz_emitter("iz_10_bigair_machloop", (-368, 21920, -1328), 0, 1.9532);
	iz_emitter("iz_13_machine_loop", (-352, 21952, -2192), 0, 2.3068);
	iz_emitter("iz_14_furnace_drone", (-608, -8448, 0), 0, 5.3093);
	iz_emitter("iz_15_mbang_05", (-432, 15632, -1568), 0, 4.1182);
	iz_emitter("iz_6_lava_amb_01_quiet", (-2781.9800, 18176, -1888), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (-3421.9800, 18176, -1888), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (-2782.6201, 18795.8008, -1888), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (-3421.3401, 18836.1992, -1888), 0, 2.9398);
	iz_emitter("iz_11_tim_machine", (-3099.9600, 19199.9004, -1680), 0, 9.5639);
	iz_emitter("iz_7_amb16", (0, -1472, -272), 0, 4.0144);
	iz_emitter("iz_7_amb16", (-1216, 4352, -592), 0, 4.0144);
	iz_emitter("iz_9_loop_neonlight_02", (9984, 24208, -2600), 0, 6.5107);
	iz_emitter("iz_9_loop_neonlight_02", (9984, 22160, -2600), 0, 6.5107);
	iz_emitter("iz_6_lava_amb_01_quiet", (8672, 22176, -3648), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (8672, 24224, -3648), 0, 2.9398);
	iz_emitter("iz_9_loop_neonlight_02", (12880, 24480, -2984), 0, 6.5107);
	iz_emitter("iz_9_loop_neonlight_02", (15264, 26176.0020, -2984), 0, 6.5107);
	iz_emitter("iz_9_loop_neonlight_02", (16384, 26176.0020, -2984), 0, 6.5107);
	iz_emitter("iz_9_loop_neonlight_02", (18448, 25888, -2856), 0, 6.5107);
	iz_emitter("iz_9_loop_neonlight_02", (20288, 23968, -3160), 0, 6.5107);
	iz_emitter("iz_0_amb7", (22016.0020, 23208, -3200), 0, 1.8285);
	iz_emitter("iz_10_bigair_machloop", (24856, 25920, -3488), 0, 1.9532);
	iz_emitter("iz_7_amb16", (6144, 23968, -2480), 0, 4.0144);
	iz_emitter("iz_7_amb16", (7296, 23968, -2480), 0, 4.0144);
	iz_emitter("iz_7_amb16", (7296, 22431.9980, -2480), 0, 4.0144);
	iz_emitter("iz_7_amb16", (6144, 22431.9980, -2480), 0, 4.0144);
	iz_emitter("iz_6_lava_amb_01_quiet", (-1888, -15968, -96), 0, 2.9398);
	iz_emitter("iz_6_lava_amb_01_quiet", (-3136, -16096, -96), 0, 2.9398);
	iz_emitter("iz_16_generator_loop_01", (864, -12960, 0), 0, 2.4603);
	iz_emitter("iz_0_amb7", (23551.9980, 23200, -3264), 0, 1.8285);
	iz_emitter("iz_13_machine_loop", (352, 21952, -2192), 0, 2.3068);
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
	thread iz_q3_mover0();
	thread iz_q3_mover1();
	thread iz_q3_mover2();
	thread iz_q3_mover3();
	thread iz_q3_mover4();
	thread iz_q3_mover5();
	thread iz_q3_mover6();
	thread iz_q3_mover7();
	thread iz_q3_mover8();
	thread iz_q3_mover9();
	thread iz_q3_mover10();
	thread iz_q3_mover11();
	thread iz_q3_mover12();
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4127.9922, -4127.9922, -632);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4127.9922, -4127.9922, -614.2205);
	angles[1] = (0, 0, 0);
	at[1] = 0.3750;
	points[2] = (-4127.9922, -4127.9922, -605.3937);
	angles[2] = (0, 0, 0);
	at[2] = 0.6250;
	points[3] = (-4127.9922, -4127.9922, -602.4370);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (-4127.9922, -4127.9922, -600.6142);
	angles[4] = (0, 0, 0);
	at[4] = 0.8750;
	points[5] = (-4127.9922, -4127.9922, -600);
	angles[5] = (0, 0, 0);
	at[5] = 1;
	points[6] = (-4127.9922, -4127.9922, -600.6142);
	angles[6] = (0, 0, 0);
	at[6] = 1.1250;
	points[7] = (-4127.9922, -4127.9922, -603.7795);
	angles[7] = (0, 0, 0);
	at[7] = 1.3125;
	points[8] = (-4127.9922, -4127.9922, -611.7008);
	angles[8] = (0, 0, 0);
	at[8] = 1.5625;
	points[9] = (-4127.9922, -4127.9922, -622.7126);
	angles[9] = (0, 0, 0);
	at[9] = 1.8125;
	points[10] = (-4127.9922, -4127.9922, -644.2441);
	angles[10] = (0, 0, 0);
	at[10] = 2.2500;
	points[11] = (-4127.9922, -4127.9922, -654.6260);
	angles[11] = (0, 0, 0);
	at[11] = 2.5000;
	points[12] = (-4127.9922, -4127.9922, -658.6063);
	angles[12] = (0, 0, 0);
	at[12] = 2.6250;
	points[13] = (-4127.9922, -4127.9922, -661.5630);
	angles[13] = (0, 0, 0);
	at[13] = 2.7500;
	points[14] = (-4127.9922, -4127.9922, -663.3859);
	angles[14] = (0, 0, 0);
	at[14] = 2.8750;
	points[15] = (-4127.9922, -4127.9922, -664);
	angles[15] = (0, 0, 0);
	at[15] = 3;
	points[16] = (-4127.9922, -4127.9922, -662.6221);
	angles[16] = (0, 0, 0);
	at[16] = 3.1875;
	points[17] = (-4127.9922, -4127.9922, -660.2205);
	angles[17] = (0, 0, 0);
	at[17] = 3.3125;
	points[18] = (-4127.9922, -4127.9922, -656.7363);
	angles[18] = (0, 0, 0);
	at[18] = 3.4375;
	points[19] = (-4127.9922, -4127.9922, -647.0867);
	angles[19] = (0, 0, 0);
	at[19] = 3.6875;
	points[20] = (-4127.9922, -4127.9922, -632);
	angles[20] = (0, 0, 0);
	at[20] = 4;
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
	points[0] = (-4127.9922, -4384.0156, -648);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4127.9922, -4384.0156, -639.1102);
	angles[1] = (0, 0, 0);
	at[1] = 0.3750;
	points[2] = (-4127.9922, -4384.0156, -634.6968);
	angles[2] = (0, 0, 0);
	at[2] = 0.6250;
	points[3] = (-4127.9922, -4384.0156, -632.3071);
	angles[3] = (0, 0, 0);
	at[3] = 0.8750;
	points[4] = (-4127.9922, -4384.0156, -632.3071);
	angles[4] = (0, 0, 0);
	at[4] = 1.1250;
	points[5] = (-4127.9922, -4384.0156, -633.8898);
	angles[5] = (0, 0, 0);
	at[5] = 1.3125;
	points[6] = (-4127.9922, -4384.0156, -637.8504);
	angles[6] = (0, 0, 0);
	at[6] = 1.5625;
	points[7] = (-4127.9922, -4384.0156, -654.1221);
	angles[7] = (0, 0, 0);
	at[7] = 2.2500;
	points[8] = (-4127.9922, -4384.0156, -659.3149);
	angles[8] = (0, 0, 0);
	at[8] = 2.5000;
	points[9] = (-4127.9922, -4384.0156, -662.7834);
	angles[9] = (0, 0, 0);
	at[9] = 2.7500;
	points[10] = (-4127.9922, -4384.0156, -664);
	angles[10] = (0, 0, 0);
	at[10] = 3;
	points[11] = (-4127.9922, -4384.0156, -663.3110);
	angles[11] = (0, 0, 0);
	at[11] = 3.1875;
	points[12] = (-4127.9922, -4384.0156, -660.3701);
	angles[12] = (0, 0, 0);
	at[12] = 3.4375;
	points[13] = (-4127.9922, -4384.0156, -655.5433);
	angles[13] = (0, 0, 0);
	at[13] = 3.6875;
	points[14] = (-4127.9922, -4384.0156, -648);
	angles[14] = (0, 0, 0);
	at[14] = 4;
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
	points[0] = (-4127.9922, -3872, -608);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4127.9922, -3872, -600.4567);
	angles[1] = (0, 0, 0);
	at[1] = 0.1562;
	points[2] = (-4127.9922, -3872, -595.6299);
	angles[2] = (0, 0, 0);
	at[2] = 0.2812;
	points[3] = (-4127.9922, -3872, -592.6890);
	angles[3] = (0, 0, 0);
	at[3] = 0.4062;
	points[4] = (-4127.9922, -3872, -592);
	angles[4] = (0, 0, 0);
	at[4] = 0.5000;
	points[5] = (-4127.9922, -3872, -593.2166);
	angles[5] = (0, 0, 0);
	at[5] = 0.6250;
	points[6] = (-4127.9922, -3872, -596.6851);
	angles[6] = (0, 0, 0);
	at[6] = 0.7500;
	points[7] = (-4127.9922, -3872, -601.8779);
	angles[7] = (0, 0, 0);
	at[7] = 0.8750;
	points[8] = (-4127.9922, -3872, -618.1496);
	angles[8] = (0, 0, 0);
	at[8] = 1.2188;
	points[9] = (-4127.9922, -3872, -622.1103);
	angles[9] = (0, 0, 0);
	at[9] = 1.3438;
	points[10] = (-4127.9922, -3872, -623.6929);
	angles[10] = (0, 0, 0);
	at[10] = 1.4375;
	points[11] = (-4127.9922, -3872, -623.6929);
	angles[11] = (0, 0, 0);
	at[11] = 1.5625;
	points[12] = (-4127.9922, -3872, -621.3032);
	angles[12] = (0, 0, 0);
	at[12] = 1.6875;
	points[13] = (-4127.9922, -3872, -616.8898);
	angles[13] = (0, 0, 0);
	at[13] = 1.8125;
	points[14] = (-4127.9922, -3872, -608);
	angles[14] = (0, 0, 0);
	at[14] = 2;
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
	points[0] = (-2336, -3872, -528);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2336, -3872, -522.3425);
	angles[1] = (0, 0, 0);
	at[1] = 0.1953;
	points[2] = (-2336, -3872, -518.7244);
	angles[2] = (0, 0, 0);
	at[2] = 0.3516;
	points[3] = (-2336, -3872, -516.5157);
	angles[3] = (0, 0, 0);
	at[3] = 0.5078;
	points[4] = (-2336, -3872, -516);
	angles[4] = (0, 0, 0);
	at[4] = 0.6250;
	points[5] = (-2336, -3872, -516.9134);
	angles[5] = (0, 0, 0);
	at[5] = 0.7812;
	points[6] = (-2336, -3872, -519.5157);
	angles[6] = (0, 0, 0);
	at[6] = 0.9375;
	points[7] = (-2336, -3872, -535.6142);
	angles[7] = (0, 0, 0);
	at[7] = 1.5234;
	points[8] = (-2336, -3872, -538.5827);
	angles[8] = (0, 0, 0);
	at[8] = 1.6797;
	points[9] = (-2336, -3872, -539.7677);
	angles[9] = (0, 0, 0);
	at[9] = 1.7969;
	points[10] = (-2336, -3872, -539.7677);
	angles[10] = (0, 0, 0);
	at[10] = 1.9531;
	points[11] = (-2336, -3872, -537.9764);
	angles[11] = (0, 0, 0);
	at[11] = 2.1094;
	points[12] = (-2336, -3872, -534.6653);
	angles[12] = (0, 0, 0);
	at[12] = 2.2656;
	points[13] = (-2336, -3872, -528);
	angles[13] = (0, 0, 0);
	at[13] = 2.5000;
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
	points[0] = (-4384.0156, -3872, -528);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4384.0156, -3872, -521.8149);
	angles[1] = (0, 0, 0);
	at[1] = 0.1406;
	points[2] = (-4384.0156, -3872, -520);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (-4384.0156, -3872, -520.6102);
	angles[3] = (0, 0, 0);
	at[3] = 0.3125;
	points[4] = (-4384.0156, -3872, -522.3425);
	angles[4] = (0, 0, 0);
	at[4] = 0.3750;
	points[5] = (-4384.0156, -3872, -533.0748);
	angles[5] = (0, 0, 0);
	at[5] = 0.6094;
	points[6] = (-4384.0156, -3872, -535.8465);
	angles[6] = (0, 0, 0);
	at[6] = 0.7188;
	points[7] = (-4384.0156, -3872, -535.8465);
	angles[7] = (0, 0, 0);
	at[7] = 0.7812;
	points[8] = (-4384.0156, -3872, -534.6536);
	angles[8] = (0, 0, 0);
	at[8] = 0.8438;
	points[9] = (-4384.0156, -3872, -528);
	angles[9] = (0, 0, 0);
	at[9] = 1;
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
	points[0] = (-4384.0156, -4127.9922, -560);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4384.0156, -4127.9922, -544.9134);
	angles[1] = (0, 0, 0);
	at[1] = 0.0781;
	points[2] = (-4384.0156, -4127.9922, -535.2638);
	angles[2] = (0, 0, 0);
	at[2] = 0.1406;
	points[3] = (-4384.0156, -4127.9922, -531.7795);
	angles[3] = (0, 0, 0);
	at[3] = 0.1719;
	points[4] = (-4384.0156, -4127.9922, -529.3780);
	angles[4] = (0, 0, 0);
	at[4] = 0.2031;
	points[5] = (-4384.0156, -4127.9922, -528);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-4384.0156, -4127.9922, -528.6142);
	angles[6] = (0, 0, 0);
	at[6] = 0.2812;
	points[7] = (-4384.0156, -4127.9922, -530.4370);
	angles[7] = (0, 0, 0);
	at[7] = 0.3125;
	points[8] = (-4384.0156, -4127.9922, -533.3937);
	angles[8] = (0, 0, 0);
	at[8] = 0.3438;
	points[9] = (-4384.0156, -4127.9922, -537.3740);
	angles[9] = (0, 0, 0);
	at[9] = 0.3750;
	points[10] = (-4384.0156, -4127.9922, -547.7559);
	angles[10] = (0, 0, 0);
	at[10] = 0.4375;
	points[11] = (-4384.0156, -4127.9922, -569.2874);
	angles[11] = (0, 0, 0);
	at[11] = 0.5469;
	points[12] = (-4384.0156, -4127.9922, -580.2993);
	angles[12] = (0, 0, 0);
	at[12] = 0.6094;
	points[13] = (-4384.0156, -4127.9922, -588.2205);
	angles[13] = (0, 0, 0);
	at[13] = 0.6719;
	points[14] = (-4384.0156, -4127.9922, -591.3859);
	angles[14] = (0, 0, 0);
	at[14] = 0.7188;
	points[15] = (-4384.0156, -4127.9922, -592);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (-4384.0156, -4127.9922, -591.3859);
	angles[16] = (0, 0, 0);
	at[16] = 0.7812;
	points[17] = (-4384.0156, -4127.9922, -589.5630);
	angles[17] = (0, 0, 0);
	at[17] = 0.8125;
	points[18] = (-4384.0156, -4127.9922, -586.6063);
	angles[18] = (0, 0, 0);
	at[18] = 0.8438;
	points[19] = (-4384.0156, -4127.9922, -577.7795);
	angles[19] = (0, 0, 0);
	at[19] = 0.9062;
	points[20] = (-4384.0156, -4127.9922, -560);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	mover = getEnt("iz_q3_mover5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4384.0156, -4384.0156, -432);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4384.0156, -4384.0156, -413.4213);
	angles[1] = (0, 0, 0);
	at[1] = 0.2812;
	points[2] = (-4384.0156, -4384.0156, -396.4449);
	angles[2] = (0, 0, 0);
	at[2] = 0.5625;
	points[3] = (-4384.0156, -4384.0156, -386.7453);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (-4384.0156, -4384.0156, -378.7858);
	angles[4] = (0, 0, 0);
	at[4] = 0.9375;
	points[5] = (-4384.0156, -4384.0156, -372.8716);
	angles[5] = (0, 0, 0);
	at[5] = 1.1250;
	points[6] = (-4384.0156, -4384.0156, -369.2299);
	angles[6] = (0, 0, 0);
	at[6] = 1.3125;
	points[7] = (-4384.0156, -4384.0156, -368);
	angles[7] = (0, 0, 0);
	at[7] = 1.5000;
	points[8] = (-4384.0156, -4384.0156, -369.2299);
	angles[8] = (0, 0, 0);
	at[8] = 1.6875;
	points[9] = (-4384.0156, -4384.0156, -370.7559);
	angles[9] = (0, 0, 0);
	at[9] = 1.7812;
	points[10] = (-4384.0156, -4384.0156, -375.5571);
	angles[10] = (0, 0, 0);
	at[10] = 1.9688;
	points[11] = (-4384.0156, -4384.0156, -382.5272);
	angles[11] = (0, 0, 0);
	at[11] = 2.1562;
	points[12] = (-4384.0156, -4384.0156, -391.3988);
	angles[12] = (0, 0, 0);
	at[12] = 2.3438;
	points[13] = (-4384.0156, -4384.0156, -401.8307);
	angles[13] = (0, 0, 0);
	at[13] = 2.5312;
	points[14] = (-4384.0156, -4384.0156, -413.4213);
	angles[14] = (0, 0, 0);
	at[14] = 2.7188;
	points[15] = (-4384.0156, -4384.0156, -456.4921);
	angles[15] = (0, 0, 0);
	at[15] = 3.3750;
	points[16] = (-4384.0156, -4384.0156, -467.5551);
	angles[16] = (0, 0, 0);
	at[16] = 3.5625;
	points[17] = (-4384.0156, -4384.0156, -477.2559);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-4384.0156, -4384.0156, -485.2126);
	angles[18] = (0, 0, 0);
	at[18] = 3.9375;
	points[19] = (-4384.0156, -4384.0156, -491.1299);
	angles[19] = (0, 0, 0);
	at[19] = 4.1250;
	points[20] = (-4384.0156, -4384.0156, -494.7716);
	angles[20] = (0, 0, 0);
	at[20] = 4.3125;
	points[21] = (-4384.0156, -4384.0156, -496);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (-4384.0156, -4384.0156, -495.6929);
	angles[22] = (0, 0, 0);
	at[22] = 4.5938;
	points[23] = (-4384.0156, -4384.0156, -493.2441);
	angles[23] = (0, 0, 0);
	at[23] = 4.7812;
	points[24] = (-4384.0156, -4384.0156, -488.4449);
	angles[24] = (0, 0, 0);
	at[24] = 4.9688;
	points[25] = (-4384.0156, -4384.0156, -481.4724);
	angles[25] = (0, 0, 0);
	at[25] = 5.1562;
	points[26] = (-4384.0156, -4384.0156, -472.6024);
	angles[26] = (0, 0, 0);
	at[26] = 5.3438;
	points[27] = (-4384.0156, -4384.0156, -462.1693);
	angles[27] = (0, 0, 0);
	at[27] = 5.5312;
	points[28] = (-4384.0156, -4384.0156, -432);
	angles[28] = (0, 0, 0);
	at[28] = 6;
	mover = getEnt("iz_q3_mover6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4127.9922, -4127.9922, -632);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4127.9922, -4127.9922, -614.2205);
	angles[1] = (0, 0, 0);
	at[1] = 0.3750;
	points[2] = (4127.9922, -4127.9922, -605.3937);
	angles[2] = (0, 0, 0);
	at[2] = 0.6250;
	points[3] = (4127.9922, -4127.9922, -602.4370);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (4127.9922, -4127.9922, -600.6142);
	angles[4] = (0, 0, 0);
	at[4] = 0.8750;
	points[5] = (4127.9922, -4127.9922, -600);
	angles[5] = (0, 0, 0);
	at[5] = 1;
	points[6] = (4127.9922, -4127.9922, -600.6142);
	angles[6] = (0, 0, 0);
	at[6] = 1.1250;
	points[7] = (4127.9922, -4127.9922, -603.7795);
	angles[7] = (0, 0, 0);
	at[7] = 1.3125;
	points[8] = (4127.9922, -4127.9922, -611.7008);
	angles[8] = (0, 0, 0);
	at[8] = 1.5625;
	points[9] = (4127.9922, -4127.9922, -622.7126);
	angles[9] = (0, 0, 0);
	at[9] = 1.8125;
	points[10] = (4127.9922, -4127.9922, -644.2441);
	angles[10] = (0, 0, 0);
	at[10] = 2.2500;
	points[11] = (4127.9922, -4127.9922, -654.6260);
	angles[11] = (0, 0, 0);
	at[11] = 2.5000;
	points[12] = (4127.9922, -4127.9922, -658.6063);
	angles[12] = (0, 0, 0);
	at[12] = 2.6250;
	points[13] = (4127.9922, -4127.9922, -661.5630);
	angles[13] = (0, 0, 0);
	at[13] = 2.7500;
	points[14] = (4127.9922, -4127.9922, -663.3859);
	angles[14] = (0, 0, 0);
	at[14] = 2.8750;
	points[15] = (4127.9922, -4127.9922, -664);
	angles[15] = (0, 0, 0);
	at[15] = 3;
	points[16] = (4127.9922, -4127.9922, -662.6221);
	angles[16] = (0, 0, 0);
	at[16] = 3.1875;
	points[17] = (4127.9922, -4127.9922, -660.2205);
	angles[17] = (0, 0, 0);
	at[17] = 3.3125;
	points[18] = (4127.9922, -4127.9922, -656.7363);
	angles[18] = (0, 0, 0);
	at[18] = 3.4375;
	points[19] = (4127.9922, -4127.9922, -647.0867);
	angles[19] = (0, 0, 0);
	at[19] = 3.6875;
	points[20] = (4127.9922, -4127.9922, -632);
	angles[20] = (0, 0, 0);
	at[20] = 4;
	mover = getEnt("iz_q3_mover7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4127.9922, -4384.0156, -648);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4127.9922, -4384.0156, -639.1102);
	angles[1] = (0, 0, 0);
	at[1] = 0.3750;
	points[2] = (4127.9922, -4384.0156, -634.6968);
	angles[2] = (0, 0, 0);
	at[2] = 0.6250;
	points[3] = (4127.9922, -4384.0156, -632.3071);
	angles[3] = (0, 0, 0);
	at[3] = 0.8750;
	points[4] = (4127.9922, -4384.0156, -632.3071);
	angles[4] = (0, 0, 0);
	at[4] = 1.1250;
	points[5] = (4127.9922, -4384.0156, -633.8898);
	angles[5] = (0, 0, 0);
	at[5] = 1.3125;
	points[6] = (4127.9922, -4384.0156, -637.8504);
	angles[6] = (0, 0, 0);
	at[6] = 1.5625;
	points[7] = (4127.9922, -4384.0156, -654.1221);
	angles[7] = (0, 0, 0);
	at[7] = 2.2500;
	points[8] = (4127.9922, -4384.0156, -659.3149);
	angles[8] = (0, 0, 0);
	at[8] = 2.5000;
	points[9] = (4127.9922, -4384.0156, -662.7834);
	angles[9] = (0, 0, 0);
	at[9] = 2.7500;
	points[10] = (4127.9922, -4384.0156, -664);
	angles[10] = (0, 0, 0);
	at[10] = 3;
	points[11] = (4127.9922, -4384.0156, -663.3110);
	angles[11] = (0, 0, 0);
	at[11] = 3.1875;
	points[12] = (4127.9922, -4384.0156, -660.3701);
	angles[12] = (0, 0, 0);
	at[12] = 3.4375;
	points[13] = (4127.9922, -4384.0156, -655.5433);
	angles[13] = (0, 0, 0);
	at[13] = 3.6875;
	points[14] = (4127.9922, -4384.0156, -648);
	angles[14] = (0, 0, 0);
	at[14] = 4;
	mover = getEnt("iz_q3_mover8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4127.9922, -3872, -608);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4127.9922, -3872, -600.4567);
	angles[1] = (0, 0, 0);
	at[1] = 0.1562;
	points[2] = (4127.9922, -3872, -595.6299);
	angles[2] = (0, 0, 0);
	at[2] = 0.2812;
	points[3] = (4127.9922, -3872, -592.6890);
	angles[3] = (0, 0, 0);
	at[3] = 0.4062;
	points[4] = (4127.9922, -3872, -592);
	angles[4] = (0, 0, 0);
	at[4] = 0.5000;
	points[5] = (4127.9922, -3872, -593.2166);
	angles[5] = (0, 0, 0);
	at[5] = 0.6250;
	points[6] = (4127.9922, -3872, -596.6851);
	angles[6] = (0, 0, 0);
	at[6] = 0.7500;
	points[7] = (4127.9922, -3872, -601.8779);
	angles[7] = (0, 0, 0);
	at[7] = 0.8750;
	points[8] = (4127.9922, -3872, -618.1496);
	angles[8] = (0, 0, 0);
	at[8] = 1.2188;
	points[9] = (4127.9922, -3872, -622.1103);
	angles[9] = (0, 0, 0);
	at[9] = 1.3438;
	points[10] = (4127.9922, -3872, -623.6929);
	angles[10] = (0, 0, 0);
	at[10] = 1.4375;
	points[11] = (4127.9922, -3872, -623.6929);
	angles[11] = (0, 0, 0);
	at[11] = 1.5625;
	points[12] = (4127.9922, -3872, -621.3032);
	angles[12] = (0, 0, 0);
	at[12] = 1.6875;
	points[13] = (4127.9922, -3872, -616.8898);
	angles[13] = (0, 0, 0);
	at[13] = 1.8125;
	points[14] = (4127.9922, -3872, -608);
	angles[14] = (0, 0, 0);
	at[14] = 2;
	mover = getEnt("iz_q3_mover9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4384.0156, -3872, -528);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4384.0156, -3872, -521.8149);
	angles[1] = (0, 0, 0);
	at[1] = 0.1406;
	points[2] = (4384.0156, -3872, -520);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (4384.0156, -3872, -520.6102);
	angles[3] = (0, 0, 0);
	at[3] = 0.3125;
	points[4] = (4384.0156, -3872, -522.3425);
	angles[4] = (0, 0, 0);
	at[4] = 0.3750;
	points[5] = (4384.0156, -3872, -533.0748);
	angles[5] = (0, 0, 0);
	at[5] = 0.6094;
	points[6] = (4384.0156, -3872, -535.8465);
	angles[6] = (0, 0, 0);
	at[6] = 0.7188;
	points[7] = (4384.0156, -3872, -535.8465);
	angles[7] = (0, 0, 0);
	at[7] = 0.7812;
	points[8] = (4384.0156, -3872, -534.6536);
	angles[8] = (0, 0, 0);
	at[8] = 0.8438;
	points[9] = (4384.0156, -3872, -528);
	angles[9] = (0, 0, 0);
	at[9] = 1;
	mover = getEnt("iz_q3_mover10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4384.0156, -4127.9922, -560);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4384.0156, -4127.9922, -544.9134);
	angles[1] = (0, 0, 0);
	at[1] = 0.0781;
	points[2] = (4384.0156, -4127.9922, -535.2638);
	angles[2] = (0, 0, 0);
	at[2] = 0.1406;
	points[3] = (4384.0156, -4127.9922, -531.7795);
	angles[3] = (0, 0, 0);
	at[3] = 0.1719;
	points[4] = (4384.0156, -4127.9922, -529.3780);
	angles[4] = (0, 0, 0);
	at[4] = 0.2031;
	points[5] = (4384.0156, -4127.9922, -528);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (4384.0156, -4127.9922, -528.6142);
	angles[6] = (0, 0, 0);
	at[6] = 0.2812;
	points[7] = (4384.0156, -4127.9922, -530.4370);
	angles[7] = (0, 0, 0);
	at[7] = 0.3125;
	points[8] = (4384.0156, -4127.9922, -533.3937);
	angles[8] = (0, 0, 0);
	at[8] = 0.3438;
	points[9] = (4384.0156, -4127.9922, -537.3740);
	angles[9] = (0, 0, 0);
	at[9] = 0.3750;
	points[10] = (4384.0156, -4127.9922, -547.7559);
	angles[10] = (0, 0, 0);
	at[10] = 0.4375;
	points[11] = (4384.0156, -4127.9922, -569.2874);
	angles[11] = (0, 0, 0);
	at[11] = 0.5469;
	points[12] = (4384.0156, -4127.9922, -580.2993);
	angles[12] = (0, 0, 0);
	at[12] = 0.6094;
	points[13] = (4384.0156, -4127.9922, -588.2205);
	angles[13] = (0, 0, 0);
	at[13] = 0.6719;
	points[14] = (4384.0156, -4127.9922, -591.3859);
	angles[14] = (0, 0, 0);
	at[14] = 0.7188;
	points[15] = (4384.0156, -4127.9922, -592);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (4384.0156, -4127.9922, -591.3859);
	angles[16] = (0, 0, 0);
	at[16] = 0.7812;
	points[17] = (4384.0156, -4127.9922, -589.5630);
	angles[17] = (0, 0, 0);
	at[17] = 0.8125;
	points[18] = (4384.0156, -4127.9922, -586.6063);
	angles[18] = (0, 0, 0);
	at[18] = 0.8438;
	points[19] = (4384.0156, -4127.9922, -577.7795);
	angles[19] = (0, 0, 0);
	at[19] = 0.9062;
	points[20] = (4384.0156, -4127.9922, -560);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	mover = getEnt("iz_q3_mover11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4384.0156, -4384.0156, -432);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4384.0156, -4384.0156, -413.4213);
	angles[1] = (0, 0, 0);
	at[1] = 0.2812;
	points[2] = (4384.0156, -4384.0156, -396.4449);
	angles[2] = (0, 0, 0);
	at[2] = 0.5625;
	points[3] = (4384.0156, -4384.0156, -386.7453);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (4384.0156, -4384.0156, -378.7858);
	angles[4] = (0, 0, 0);
	at[4] = 0.9375;
	points[5] = (4384.0156, -4384.0156, -372.8716);
	angles[5] = (0, 0, 0);
	at[5] = 1.1250;
	points[6] = (4384.0156, -4384.0156, -369.2299);
	angles[6] = (0, 0, 0);
	at[6] = 1.3125;
	points[7] = (4384.0156, -4384.0156, -368);
	angles[7] = (0, 0, 0);
	at[7] = 1.5000;
	points[8] = (4384.0156, -4384.0156, -369.2299);
	angles[8] = (0, 0, 0);
	at[8] = 1.6875;
	points[9] = (4384.0156, -4384.0156, -370.7559);
	angles[9] = (0, 0, 0);
	at[9] = 1.7812;
	points[10] = (4384.0156, -4384.0156, -375.5571);
	angles[10] = (0, 0, 0);
	at[10] = 1.9688;
	points[11] = (4384.0156, -4384.0156, -382.5272);
	angles[11] = (0, 0, 0);
	at[11] = 2.1562;
	points[12] = (4384.0156, -4384.0156, -391.3988);
	angles[12] = (0, 0, 0);
	at[12] = 2.3438;
	points[13] = (4384.0156, -4384.0156, -401.8307);
	angles[13] = (0, 0, 0);
	at[13] = 2.5312;
	points[14] = (4384.0156, -4384.0156, -413.4213);
	angles[14] = (0, 0, 0);
	at[14] = 2.7188;
	points[15] = (4384.0156, -4384.0156, -456.4921);
	angles[15] = (0, 0, 0);
	at[15] = 3.3750;
	points[16] = (4384.0156, -4384.0156, -467.5551);
	angles[16] = (0, 0, 0);
	at[16] = 3.5625;
	points[17] = (4384.0156, -4384.0156, -477.2559);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (4384.0156, -4384.0156, -485.2126);
	angles[18] = (0, 0, 0);
	at[18] = 3.9375;
	points[19] = (4384.0156, -4384.0156, -491.1299);
	angles[19] = (0, 0, 0);
	at[19] = 4.1250;
	points[20] = (4384.0156, -4384.0156, -494.7716);
	angles[20] = (0, 0, 0);
	at[20] = 4.3125;
	points[21] = (4384.0156, -4384.0156, -496);
	angles[21] = (0, 0, 0);
	at[21] = 4.5000;
	points[22] = (4384.0156, -4384.0156, -495.6929);
	angles[22] = (0, 0, 0);
	at[22] = 4.5938;
	points[23] = (4384.0156, -4384.0156, -493.2441);
	angles[23] = (0, 0, 0);
	at[23] = 4.7812;
	points[24] = (4384.0156, -4384.0156, -488.4449);
	angles[24] = (0, 0, 0);
	at[24] = 4.9688;
	points[25] = (4384.0156, -4384.0156, -481.4724);
	angles[25] = (0, 0, 0);
	at[25] = 5.1562;
	points[26] = (4384.0156, -4384.0156, -472.6024);
	angles[26] = (0, 0, 0);
	at[26] = 5.3438;
	points[27] = (4384.0156, -4384.0156, -462.1693);
	angles[27] = (0, 0, 0);
	at[27] = 5.5312;
	points[28] = (4384.0156, -4384.0156, -432);
	angles[28] = (0, 0, 0);
	at[28] = 6;
	mover = getEnt("iz_q3_mover12", "targetname");
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
