main()
{
	visionSetNaked("mp_aion_poeta", 0);

	setExpFog(154.4851, 8292.2139, 0.4784, 0.6431, 0.8368, 0);

	maps\mp\mp_aion_poeta_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_the_still_sad_world_", 2);
	iz_emitter("iz_1_ambient_boiling", (9924.5049, 44008.5156, 4154.3193), 0, 2.2291);
	iz_emitter("iz_2_ambient_windmill", (9536.5098, 47028.0820, 4764.8193), 0, 0.9680);
	iz_emitter("iz_3_ambient_cute_jump", (23791.1914, 60757.2305, 4585.0078), 0, 4.5000);
	iz_emitter("iz_4_ambient_waterfall_2", (6229.5171, 60132.6953, 4269.4385), 0, 2.0027);
	iz_emitter("iz_5_ambient_power_stone", (11402.5596, 40044.2930, 5231.2993), 0, 8.1444);
	iz_emitter("iz_6_ambient_bell", (14405.5176, 80291.6484, 6320.2817), 0, 10.5000);
	iz_emitter("iz_7_ambient_windmill", (39295.8945, 58587.6172, 8372.6250), 0, 0.9680);
	iz_emitter("iz_8_ambient_burning", (35297.2461, 43491.9648, 4173.7656), 0, 3.7152);
	iz_emitter("iz_9_ambient_gear", (12050.8057, 73199.8359, 6097.7231), 0, 1.9153);
	iz_emitter("iz_10_ambient_sign_weapon", (33706.8281, 48785.9844, 4805.4751), 0, 1.6184);
	iz_emitter("iz_1_ambient_boiling", (8214.5371, 74982.4922, 6844.0669), 0, 2.2291);
	iz_emitter("iz_11_ambient_gear", (9710.4941, 46976.8398, 4546.9448), 0, 1.9153);
	iz_emitter("iz_12_ambient_fish_jump", (38869.6758, 49509.0391, 3988.3826), 0, 5);
	iz_emitter("iz_13_ambient_water_tank", (26222.0898, 36352.9062, 4296.7085), 0, 8);
	iz_emitter("iz_14_ambient_bubble_1", (25718.5977, 41169.2578, 3912.5186), 0, 5.1226);
	iz_emitter("iz_15_ambient_abgate", (11702.4424, 40030.6328, 5273.5894), 0, 6.9989);
	iz_emitter("iz_16_ambient_windmill", (12062.6016, 72949.3203, 6419.2637), 0, 0.9680);
	iz_emitter("iz_17_ambient_waterfall_2", (18821.3809, 61419.7930, 4144.2236), 0, 2.0027);
	iz_emitter("iz_13_ambient_water_tank", (24054.7754, 35544.9180, 4101.9585), 0, 8);
	iz_emitter("iz_18_ambient_water_move", (11528.4951, 81732.4922, 6783.1729), 0, 11.0046);
	iz_emitter("iz_19_ambient_record", (33587.2656, 47514.0664, 4682.8462), 0, 4.5616);
	iz_emitter("iz_20_ambient_sign_post", (32567.8848, 48947.2656, 4730.9565), 0, 1.6631);
	iz_emitter("iz_21_ambient_flag", (11980.8311, 81814.3594, 6779.6670), 0, 5.8262);
	iz_emitter("iz_22_ambient_bubble_2", (11524.3623, 81705.2969, 6789.5664), 0, 8.4757);
	iz_emitter("iz_23_ambient_steam_small", (11072.1973, 81616.4844, 6808.7026), 0, 1.0516);
	iz_emitter("iz_24_ambient_water_flow_1", (38839.7383, 49721.0664, 3978.7139), 0, 2.9896);
	iz_emitter("iz_25_ambient_fx_11", (32411.4512, 49926.9688, 4835.6753), 0, 7.0722);
	iz_emitter("iz_13_ambient_water_tank", (34134.6016, 43387.8281, 4326.6519), 0, 8);
	iz_emitter("iz_7_ambient_windmill", (39833.7930, 53721.6523, 9261.3359), 0, 0.9680);
	iz_emitter("iz_5_ambient_power_stone", (8975.0127, 39913.7109, 4817.9136), 0, 8.1444);
	iz_emitter("iz_26_ambient_waterfall_2", (37409.5156, 56390.0156, 5852.9028), 0, 2.0027);
	iz_emitter("iz_27_ambient_creak_2", (23183.4277, 43028.3008, 4041.8799), 0, 4.6962);
	iz_emitter("iz_19_ambient_record", (16654.7402, 68589.7344, 4751.3701), 0, 4.5616);
	iz_emitter("iz_28_ambient_water_well", (34281.6445, 48126.0977, 4723.0068), 0, 10);
	iz_emitter("iz_23_ambient_steam_small", (12735.0537, 73209.3828, 6068.2749), 0, 1.0516);
	iz_emitter("iz_14_ambient_bubble_1", (25549.9922, 42268.8789, 3942.4546), 0, 5.1226);
	iz_emitter("iz_29_ambient_fx_16", (16793.3438, 68508.5391, 4742.4165), 0, 6);
	iz_emitter("iz_30_ambient_fx_1", (12666.7412, 55387.2266, 4080.2217), 0, 3.6978);
	iz_emitter("iz_23_ambient_steam_small", (12726.6426, 72977.2891, 6067.9014), 0, 1.0516);
	iz_emitter("iz_29_ambient_fx_16", (31740.9004, 48923.1016, 4711.9971), 0, 6);
	iz_emitter("iz_31_ambient_flag", (9678.6592, 74993.5938, 6802.9033), 0, 5.8262);
	iz_emitter("iz_23_ambient_steam_small", (11213.1143, 81405.8984, 6807.9058), 0, 1.0516);
	iz_emitter("iz_32_ambient_metal_jar", (11526.7490, 81724.9688, 6736.1836), 0, 8.7663);
	iz_emitter("iz_1_ambient_boiling", (46743.8125, 45977.8398, 5416.4946), 0, 2.2291);
	iz_emitter("iz_31_ambient_flag", (10148.0225, 75891.8750, 6665.6523), 0, 5.8262);
	iz_emitter("iz_33_ambient_cute_jump", (23427.4336, 60440.6172, 4569.3594), 0, 4.5000);
	iz_emitter("iz_7_ambient_windmill", (39920.7969, 55966.2734, 8178.7749), 0, 0.9680);
	iz_emitter("iz_31_ambient_flag", (9077.6973, 46596.6758, 4591), 0, 5.8262);
	iz_emitter("iz_34_ambient_steam_small", (11174.0068, 81910.8828, 6738.1279), 0, 1.0516);
	iz_emitter("iz_1_ambient_boiling", (19158.0137, 42518.0234, 4637.7153), 0, 2.2291);
	iz_emitter("iz_35_ambient_flag", (32199.1016, 48978.8281, 4774.2603), 0, 5.8262);
	iz_emitter("iz_5_ambient_power_stone", (9878.6113, 41755.4805, 4836.6099), 0, 8.1444);
	iz_emitter("iz_36_ambient_village_4", (27247.7734, 54353.4258, 6901.8921), 1, 40);
	iz_emitter("iz_37_ambient_wind_natural", (27372.2715, 55365.5195, 6900.3491), 1, 15.0763);
	iz_emitter("iz_38_ambient_wind_natural", (27372.2715, 55365.5195, 6900.3491), 1, 14.8444);
	iz_emitter("iz_39_ambient_wind_low", (27372.2715, 55365.5195, 6900.3491), 1, 19.1332);
	iz_emitter("iz_40_ambient_indoor_churc", (27920.1387, 54554.1992, 6961.7007), 1, 45);
	iz_emitter("iz_41_ambient_wind_short", (1401.0651, 56383.9766, 8874.0879), 1, 15.0465);
	iz_emitter("iz_37_ambient_wind_natural", (27342.3984, 54863.4219, 6909.9976), 1, 15.0763);
	iz_emitter("iz_42_ambient_bird_lite", (27342.3984, 54863.4219, 6909.9976), 1, 34.2500);
	iz_emitter("iz_43_ambient_bird_forest_", (27342.3984, 54863.4219, 6909.9976), 1, 19);
	iz_emitter("iz_38_ambient_wind_natural", (27342.3984, 54863.4219, 6909.9976), 1, 14.8444);
	iz_emitter("iz_44_ambient_wind_cliff", (1467.8546, 55637.3281, 9211.1377), 1, 12);
	iz_emitter("iz_45_ambient_indoor_store", (27931.0547, 54795.2500, 6994.8501), 1, 50);
	iz_emitter("iz_46_ambient_wind_howl", (27030.6152, 55411.6328, 6867.3174), 1, 23);
	iz_emitter("iz_47_ambient_quarry_2", (27030.6152, 55411.6328, 6867.3174), 1, 29);
	iz_emitter("iz_37_ambient_wind_natural", (33490.8945, 17295.3770, 4314.8984), 1, 15.0763);
	iz_emitter("iz_38_ambient_wind_natural", (33490.8945, 17295.3770, 4314.8984), 1, 14.8444);
	iz_emitter("iz_42_ambient_bird_lite", (33490.8945, 17295.3770, 4314.8984), 1, 34.2500);
	iz_emitter("iz_48_ambient_frog", (33414.9023, 17758.3574, 4257.8555), 1, 3.8719);
	iz_emitter("iz_37_ambient_wind_natural", (32773.3672, 18215.0059, 4321.4019), 1, 15.0763);
	iz_emitter("iz_42_ambient_bird_lite", (32773.3672, 18215.0059, 4321.4019), 1, 34.2500);
	iz_emitter("iz_38_ambient_wind_natural", (32773.3672, 18215.0059, 4321.4019), 1, 14.8444);
	iz_emitter("iz_49_ambient_frog", (32199.2539, 17335.6406, 4299.4189), 1, 3.8719);
	iz_emitter("iz_42_ambient_bird_lite", (1767.7712, 55739.7266, 9075.5762), 1, 34.2500);
	iz_emitter("iz_43_ambient_bird_forest_", (1767.7712, 55739.7266, 9075.5762), 1, 19);
	iz_emitter("iz_37_ambient_wind_natural", (1767.7712, 55739.7266, 9075.5762), 1, 15.0763);
	iz_emitter("iz_50_ambient_forest_bugs_", (1767.7712, 55739.7266, 9075.5762), 1, 8.0109);
	iz_emitter("iz_51_ambient_cave_water", (27015.0078, 55152.5938, 6932.1646), 1, 10.4490);
	iz_emitter("iz_52_ambient_wind_cliff", (27015.0078, 55152.5938, 6932.1646), 1, 12);
	iz_emitter("iz_49_ambient_frog", (1820.3805, 56382.0859, 8954.8145), 1, 3.8719);
	iz_emitter("iz_53_ambient_mute", (31462.4023, 16591.9395, 4446.3555), 1, 1.0478);
	iz_emitter("iz_54_ambient_water_under", (33570.4844, 16741.2695, 4364.8013), 1, 22);
	iz_emitter("iz_55_ambient_water_lake", (27002.6504, 54661.5469, 6840.9873), 1, 10);
	iz_emitter("iz_55_ambient_water_lake", (32786.9688, 17806.6348, 4301.1797), 1, 10);
	iz_emitter("iz_56_ambient_swamp", (32786.9688, 17806.6348, 4301.1797), 1, 7.6394);
	iz_emitter("iz_57_ambient_cave_1", (1432.7283, 55885.0586, 9055.4355), 1, 10);
	iz_emitter("iz_51_ambient_cave_water", (1432.7283, 55885.0586, 9055.4355), 1, 10.4490);
	iz_emitter("iz_55_ambient_water_lake", (32957.8750, 16792.0664, 4417.1411), 1, 10);
	iz_emitter("iz_55_ambient_water_lake", (1431.4473, 56158.1484, 8971.6943), 1, 10);
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
