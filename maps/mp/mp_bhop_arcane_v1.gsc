main()
{
	visionSetNaked("mp_bhop_arcane_v1", 0);

	setExpFog(1000, 5583.3330, 0.6275, 0.6667, 0.6863, 0);

	thread iz_sounds();

	thread iz_triggers();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_ambience", 2);
	level thread iz_scatter("iz_1_aztec", 25);
	level thread iz_scatter("iz_7_aztec", 10);
	level thread iz_scatter("iz_27_aztec", 25);
	iz_emitter("iz_0_waterfall_mediumloop", (-6976, -2208, 2288), 0, 1.7366);
	iz_emitter("iz_0_waterfall_mediumloop", (-1280, -4608, 2160), 0, 1.7366);
	iz_emitter("iz_0_waterfall_mediumloop", (-3616, -6624, 2160), 0, 1.7366);
	iz_emitter("iz_0_waterfall_mediumloop", (-9056, -9200, 2288), 0, 1.7366);
	iz_emitter("iz_0_waterfall_mediumloop", (-4160, -656, 2800), 0, 1.7366);
	iz_emitter("iz_0_waterfall_mediumloop", (-624, 2944, 3568), 0, 1.7366);
	iz_emitter("iz_0_waterfall_mediumloop", (1504, 528, 3696), 0, 1.7366);
}

iz_scatter(alias, interval)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.4, interval));
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
			players[i] playLocalSound(alias);
	}
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

iz_triggers()
{
	thread iz_trig_0();
	thread iz_trig_1();
	thread iz_trig_2();
	thread iz_trig_3();
	thread iz_trig_4();
	thread iz_trig_5();
	thread iz_trig_6();
	thread iz_trig_7();
	thread iz_trig_8();
	thread iz_trig_9();
	thread iz_trig_10();
	thread iz_trig_11();
	thread iz_trig_12();
	thread iz_trig_13();
	thread iz_trig_14();
	thread iz_trig_15();
	thread iz_trig_16();
	thread iz_trig_17();
	thread iz_trig_18();
	thread iz_trig_19();
	thread iz_trig_20();
	thread iz_trig_21();
	thread iz_trig_22();
	thread iz_trig_23();
	thread iz_trig_24();
	thread iz_trig_25();
	thread iz_trig_26();
	thread iz_trig_27();
	thread iz_trig_28();
	thread iz_trig_29();
	thread iz_trig_30();
	thread iz_trig_31();
	thread iz_trig_32();
	thread iz_trig_33();
	thread iz_trig_34();
	thread iz_trig_35();
	thread iz_trig_36();
	thread iz_trig_37();
	thread iz_trig_38();
	thread iz_trig_39();
	thread iz_trig_40();
	thread iz_trig_41();
	thread iz_trig_42();
	thread iz_trig_43();
	thread iz_trig_44();
	thread iz_trig_45();
	thread iz_trig_46();
	thread iz_trig_47();
	thread iz_trig_48();
	thread iz_trig_49();
	thread iz_trig_50();
	thread iz_trig_51();
	thread iz_trig_52();
	thread iz_trig_53();
	thread iz_trig_54();
	thread iz_trig_55();
	thread iz_trig_56();
	thread iz_trig_57();
	thread iz_trig_58();
	thread iz_trig_59();
	thread iz_trig_60();
	thread iz_trig_61();
	thread iz_trig_62();
	thread iz_trig_63();
	thread iz_trig_64();
	thread iz_trig_65();
	thread iz_trig_66();
	thread iz_trig_67();
	thread iz_trig_68();
	thread iz_trig_69();
	thread iz_trig_70();
	thread iz_trig_71();
	thread iz_trig_72();
	thread iz_trig_73();
	thread iz_trig_74();
	thread iz_trig_75();
	thread iz_trig_76();
	thread iz_trig_77();
	thread iz_trig_78();
	thread iz_trig_79();
	thread iz_trig_80();
	thread iz_trig_81();
	thread iz_trig_82();
	thread iz_trig_83();
	thread iz_trig_84();
	thread iz_trig_85();
	thread iz_trig_86();
	thread iz_trig_87();
	thread iz_trig_88();
	thread iz_trig_89();
	thread iz_trig_90();
	thread iz_trig_91();
	thread iz_trig_92();
	thread iz_trig_93();
	thread iz_trig_94();
	thread iz_trig_95();
	thread iz_trig_96();
	thread iz_trig_97();
	thread iz_trig_98();
	thread iz_trig_99();
	thread iz_trig_100();
	thread iz_trig_101();
	thread iz_trig_102();
	thread iz_trig_103();
	thread iz_trig_104();
	thread iz_trig_105();
	thread iz_trig_106();
	thread iz_trig_107();
	thread iz_trig_108();
	thread iz_trig_109();
	thread iz_trig_110();
	thread iz_trig_111();
	thread iz_trig_112();
	thread iz_trig_113();
	thread iz_trig_114();
	thread iz_trig_115();
	thread iz_trig_116();
	thread iz_trig_117();
	thread iz_trig_118();
	thread iz_trig_119();
	thread iz_trig_120();
	thread iz_trig_121();
	thread iz_trig_122();
	thread iz_trig_123();
	thread iz_trig_124();
	thread iz_trig_125();
	thread iz_trig_126();
	thread iz_trig_127();
	thread iz_trig_128();
	thread iz_trig_129();
	thread iz_trig_130();
	thread iz_trig_131();
	thread iz_trig_132();
	thread iz_trig_133();
	thread iz_trig_134();
	thread iz_trig_135();
	thread iz_trig_136();
	thread iz_trig_137();
	thread iz_trig_138();
	thread iz_trig_139();
	thread iz_trig_140();
	thread iz_trig_141();
	thread iz_trig_142();
	thread iz_trig_143();
	thread iz_trig_144();
	thread iz_trig_145();
	thread iz_trig_146();
	thread iz_trig_147();
	thread iz_trig_148();
	thread iz_trig_149();
	thread iz_trig_150();
	thread iz_trig_151();
	thread iz_trig_152();
	thread iz_trig_153();
	thread iz_trig_154();
	thread iz_trig_155();
	thread iz_trig_156();
	thread iz_trig_157();
	thread iz_trig_158();
	thread iz_trig_159();
	thread iz_trig_160();
	thread iz_trig_161();
	thread iz_trig_162();
	thread iz_trig_163();
	thread iz_trig_164();
	thread iz_trig_165();
	thread iz_trig_166();
	thread iz_trig_167();
	thread iz_trig_168();
	thread iz_trig_169();
	thread iz_trig_170();
	thread iz_trig_171();
	thread iz_trig_172();
	thread iz_trig_173();
	thread iz_trig_174();
	thread iz_trig_175();
	thread iz_trig_176();
	thread iz_trig_177();
	thread iz_trig_178();
	thread iz_trig_179();
	thread iz_trig_180();
	thread iz_trig_181();
}

iz_trig_0()
{
	t = getEnt("iz_trig_0", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (353.5533, -353.5534, 0);
	t thread iz_trig(0.2000);
}

iz_trig_1()
{
	t = getEnt("iz_trig_1", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (353.5534, 353.5534, 0);
	t thread iz_trig(0.2000);
}

iz_trig_2()
{
	t = getEnt("iz_trig_2", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-353.5534, 353.5534, 0);
	t thread iz_trig(0.2000);
}

iz_trig_3()
{
	t = getEnt("iz_trig_3", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-353.5534, -353.5533, 0);
	t thread iz_trig(0.2000);
}

iz_trig_4()
{
	t = getEnt("iz_trig_4", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_5()
{
	t = getEnt("iz_trig_5", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_6()
{
	t = getEnt("iz_trig_6", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_7()
{
	t = getEnt("iz_trig_7", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 2000, 0);
	t thread iz_trig(0.2000);
}

iz_trig_8()
{
	t = getEnt("iz_trig_8", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 1500, 0);
	t thread iz_trig(0.2000);
}

iz_trig_9()
{
	t = getEnt("iz_trig_9", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 1000, 0);
	t thread iz_trig(0.2000);
}

iz_trig_10()
{
	t = getEnt("iz_trig_10", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_11()
{
	t = getEnt("iz_trig_11", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_12()
{
	t = getEnt("iz_trig_12", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_13()
{
	t = getEnt("iz_trig_13", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_14()
{
	t = getEnt("iz_trig_14", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_15()
{
	t = getEnt("iz_trig_15", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_16()
{
	t = getEnt("iz_trig_16", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (400, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_17()
{
	t = getEnt("iz_trig_17", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (500, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_18()
{
	t = getEnt("iz_trig_18", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-500, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_19()
{
	t = getEnt("iz_trig_19", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (500, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_20()
{
	t = getEnt("iz_trig_20", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-500, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_21()
{
	t = getEnt("iz_trig_21", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (400, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_22()
{
	t = getEnt("iz_trig_22", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_23()
{
	t = getEnt("iz_trig_23", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_24()
{
	t = getEnt("iz_trig_24", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_25()
{
	t = getEnt("iz_trig_25", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -400, 0);
	t thread iz_trig(0.2000);
}

iz_trig_26()
{
	t = getEnt("iz_trig_26", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (250, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_27()
{
	t = getEnt("iz_trig_27", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_28()
{
	t = getEnt("iz_trig_28", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 500);
	t thread iz_trig(0.2000);
}

iz_trig_29()
{
	t = getEnt("iz_trig_29", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_30()
{
	t = getEnt("iz_trig_30", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 500);
	t thread iz_trig(0.2000);
}

iz_trig_31()
{
	t = getEnt("iz_trig_31", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, -250);
	t thread iz_trig(0.2000);
}

iz_trig_32()
{
	t = getEnt("iz_trig_32", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_33()
{
	t = getEnt("iz_trig_33", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-250, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_34()
{
	t = getEnt("iz_trig_34", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_35()
{
	t = getEnt("iz_trig_35", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, -250);
	t thread iz_trig(0.2000);
}

iz_trig_36()
{
	t = getEnt("iz_trig_36", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 500);
	t thread iz_trig(0.2000);
}

iz_trig_37()
{
	t = getEnt("iz_trig_37", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_38()
{
	t = getEnt("iz_trig_38", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_39()
{
	t = getEnt("iz_trig_39", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -300, 0);
	t thread iz_trig(0.2000);
}

iz_trig_40()
{
	t = getEnt("iz_trig_40", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_41()
{
	t = getEnt("iz_trig_41", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_42()
{
	t = getEnt("iz_trig_42", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_43()
{
	t = getEnt("iz_trig_43", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_44()
{
	t = getEnt("iz_trig_44", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_45()
{
	t = getEnt("iz_trig_45", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_46()
{
	t = getEnt("iz_trig_46", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2n_stop";
	t thread iz_trig(0.2000);
}

iz_trig_47()
{
	t = getEnt("iz_trig_47", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5a_stop";
	t thread iz_trig(0.2000);
}

iz_trig_48()
{
	t = getEnt("iz_trig_48", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4m_stop";
	t thread iz_trig(0.2000);
}

iz_trig_49()
{
	t = getEnt("iz_trig_49", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4l_stop";
	t thread iz_trig(0.2000);
}

iz_trig_50()
{
	t = getEnt("iz_trig_50", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4i_stop";
	t thread iz_trig(0.2000);
}

iz_trig_51()
{
	t = getEnt("iz_trig_51", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4h_stop";
	t thread iz_trig(0.2000);
}

iz_trig_52()
{
	t = getEnt("iz_trig_52", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4g_stop";
	t thread iz_trig(0.2000);
}

iz_trig_53()
{
	t = getEnt("iz_trig_53", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_54()
{
	t = getEnt("iz_trig_54", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_55()
{
	t = getEnt("iz_trig_55", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3o_stop";
	t thread iz_trig(0.2000);
}

iz_trig_56()
{
	t = getEnt("iz_trig_56", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3o_stop";
	t thread iz_trig(0.2000);
}

iz_trig_57()
{
	t = getEnt("iz_trig_57", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3n_stop";
	t thread iz_trig(0.2000);
}

iz_trig_58()
{
	t = getEnt("iz_trig_58", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3m_stop";
	t thread iz_trig(0.2000);
}

iz_trig_59()
{
	t = getEnt("iz_trig_59", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2g_stop";
	t thread iz_trig(0.2000);
}

iz_trig_60()
{
	t = getEnt("iz_trig_60", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2m_stop";
	t thread iz_trig(0.2000);
}

iz_trig_61()
{
	t = getEnt("iz_trig_61", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2l_stop";
	t thread iz_trig(0.2000);
}

iz_trig_62()
{
	t = getEnt("iz_trig_62", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2k_stop";
	t thread iz_trig(0.2000);
}

iz_trig_63()
{
	t = getEnt("iz_trig_63", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2j_stop";
	t thread iz_trig(0.2000);
}

iz_trig_64()
{
	t = getEnt("iz_trig_64", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_65()
{
	t = getEnt("iz_trig_65", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_66()
{
	t = getEnt("iz_trig_66", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_67()
{
	t = getEnt("iz_trig_67", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_68()
{
	t = getEnt("iz_trig_68", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_69()
{
	t = getEnt("iz_trig_69", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_70()
{
	t = getEnt("iz_trig_70", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_71()
{
	t = getEnt("iz_trig_71", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_72()
{
	t = getEnt("iz_trig_72", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_73()
{
	t = getEnt("iz_trig_73", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_74()
{
	t = getEnt("iz_trig_74", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_75()
{
	t = getEnt("iz_trig_75", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_76()
{
	t = getEnt("iz_trig_76", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_77()
{
	t = getEnt("iz_trig_77", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_78()
{
	t = getEnt("iz_trig_78", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_79()
{
	t = getEnt("iz_trig_79", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_80()
{
	t = getEnt("iz_trig_80", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_81()
{
	t = getEnt("iz_trig_81", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_82()
{
	t = getEnt("iz_trig_82", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_83()
{
	t = getEnt("iz_trig_83", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_84()
{
	t = getEnt("iz_trig_84", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_85()
{
	t = getEnt("iz_trig_85", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_86()
{
	t = getEnt("iz_trig_86", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_87()
{
	t = getEnt("iz_trig_87", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_88()
{
	t = getEnt("iz_trig_88", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_89()
{
	t = getEnt("iz_trig_89", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_90()
{
	t = getEnt("iz_trig_90", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_91()
{
	t = getEnt("iz_trig_91", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_92()
{
	t = getEnt("iz_trig_92", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_93()
{
	t = getEnt("iz_trig_93", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_94()
{
	t = getEnt("iz_trig_94", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_95()
{
	t = getEnt("iz_trig_95", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_96()
{
	t = getEnt("iz_trig_96", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_97()
{
	t = getEnt("iz_trig_97", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_98()
{
	t = getEnt("iz_trig_98", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_99()
{
	t = getEnt("iz_trig_99", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_100()
{
	t = getEnt("iz_trig_100", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2a_stop";
	t thread iz_trig(0.2000);
}

iz_trig_101()
{
	t = getEnt("iz_trig_101", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2b_stop";
	t thread iz_trig(0.2000);
}

iz_trig_102()
{
	t = getEnt("iz_trig_102", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_103()
{
	t = getEnt("iz_trig_103", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2i_stop";
	t thread iz_trig(0.2000);
}

iz_trig_104()
{
	t = getEnt("iz_trig_104", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage2h_stop";
	t thread iz_trig(0.2000);
}

iz_trig_105()
{
	t = getEnt("iz_trig_105", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1b_stop";
	t thread iz_trig(0.2000);
}

iz_trig_106()
{
	t = getEnt("iz_trig_106", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_107()
{
	t = getEnt("iz_trig_107", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1j_stop";
	t thread iz_trig(0.2000);
}

iz_trig_108()
{
	t = getEnt("iz_trig_108", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1k_stop";
	t thread iz_trig(0.2000);
}

iz_trig_109()
{
	t = getEnt("iz_trig_109", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1m_stop";
	t thread iz_trig(0.2000);
}

iz_trig_110()
{
	t = getEnt("iz_trig_110", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1m_stop";
	t thread iz_trig(0.2000);
}

iz_trig_111()
{
	t = getEnt("iz_trig_111", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1n_stop";
	t thread iz_trig(0.2000);
}

iz_trig_112()
{
	t = getEnt("iz_trig_112", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1l_stop";
	t thread iz_trig(0.2000);
}

iz_trig_113()
{
	t = getEnt("iz_trig_113", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1h_stop";
	t thread iz_trig(0.2000);
}

iz_trig_114()
{
	t = getEnt("iz_trig_114", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1i_stop";
	t thread iz_trig(0.2000);
}

iz_trig_115()
{
	t = getEnt("iz_trig_115", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_116()
{
	t = getEnt("iz_trig_116", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1g_stop";
	t thread iz_trig(0.2000);
}

iz_trig_117()
{
	t = getEnt("iz_trig_117", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1c_stop";
	t thread iz_trig(0.2000);
}

iz_trig_118()
{
	t = getEnt("iz_trig_118", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_119()
{
	t = getEnt("iz_trig_119", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage1a_stop";
	t thread iz_trig(0.2000);
}

iz_trig_120()
{
	t = getEnt("iz_trig_120", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3l_stop";
	t thread iz_trig(0.2000);
}

iz_trig_121()
{
	t = getEnt("iz_trig_121", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3k_stop";
	t thread iz_trig(0.2000);
}

iz_trig_122()
{
	t = getEnt("iz_trig_122", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3j_stop";
	t thread iz_trig(0.2000);
}

iz_trig_123()
{
	t = getEnt("iz_trig_123", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3i_stop";
	t thread iz_trig(0.2000);
}

iz_trig_124()
{
	t = getEnt("iz_trig_124", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3h_stop";
	t thread iz_trig(0.2000);
}

iz_trig_125()
{
	t = getEnt("iz_trig_125", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3g_stop";
	t thread iz_trig(0.2000);
}

iz_trig_126()
{
	t = getEnt("iz_trig_126", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_127()
{
	t = getEnt("iz_trig_127", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_128()
{
	t = getEnt("iz_trig_128", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3c_stop";
	t thread iz_trig(0.2000);
}

iz_trig_129()
{
	t = getEnt("iz_trig_129", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3b_stop";
	t thread iz_trig(0.2000);
}

iz_trig_130()
{
	t = getEnt("iz_trig_130", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3a_stop";
	t thread iz_trig(0.2000);
}

iz_trig_131()
{
	t = getEnt("iz_trig_131", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage3f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_132()
{
	t = getEnt("iz_trig_132", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_133()
{
	t = getEnt("iz_trig_133", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_134()
{
	t = getEnt("iz_trig_134", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4a_stop";
	t thread iz_trig(0.2000);
}

iz_trig_135()
{
	t = getEnt("iz_trig_135", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4b_stop";
	t thread iz_trig(0.2000);
}

iz_trig_136()
{
	t = getEnt("iz_trig_136", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4c_stop";
	t thread iz_trig(0.2000);
}

iz_trig_137()
{
	t = getEnt("iz_trig_137", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4k_stop";
	t thread iz_trig(0.2000);
}

iz_trig_138()
{
	t = getEnt("iz_trig_138", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4u_stop";
	t thread iz_trig(0.2000);
}

iz_trig_139()
{
	t = getEnt("iz_trig_139", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4t_stop";
	t thread iz_trig(0.2000);
}

iz_trig_140()
{
	t = getEnt("iz_trig_140", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4s_stop";
	t thread iz_trig(0.2000);
}

iz_trig_141()
{
	t = getEnt("iz_trig_141", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4r_stop";
	t thread iz_trig(0.2000);
}

iz_trig_142()
{
	t = getEnt("iz_trig_142", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4q_stop";
	t thread iz_trig(0.2000);
}

iz_trig_143()
{
	t = getEnt("iz_trig_143", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4p_stop";
	t thread iz_trig(0.2000);
}

iz_trig_144()
{
	t = getEnt("iz_trig_144", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4p_stop";
	t thread iz_trig(0.2000);
}

iz_trig_145()
{
	t = getEnt("iz_trig_145", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4o_stop";
	t thread iz_trig(0.2000);
}

iz_trig_146()
{
	t = getEnt("iz_trig_146", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4o_stop";
	t thread iz_trig(0.2000);
}

iz_trig_147()
{
	t = getEnt("iz_trig_147", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4m_stop";
	t thread iz_trig(0.2000);
}

iz_trig_148()
{
	t = getEnt("iz_trig_148", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5e_stop";
	t thread iz_trig(0.2000);
}

iz_trig_149()
{
	t = getEnt("iz_trig_149", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5d_stop";
	t thread iz_trig(0.2000);
}

iz_trig_150()
{
	t = getEnt("iz_trig_150", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5c_stop";
	t thread iz_trig(0.2000);
}

iz_trig_151()
{
	t = getEnt("iz_trig_151", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4j_stop";
	t thread iz_trig(0.2000);
}

iz_trig_152()
{
	t = getEnt("iz_trig_152", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4w_stop";
	t thread iz_trig(0.2000);
}

iz_trig_153()
{
	t = getEnt("iz_trig_153", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4v_stop";
	t thread iz_trig(0.2000);
}

iz_trig_154()
{
	t = getEnt("iz_trig_154", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4u_stop";
	t thread iz_trig(0.2000);
}

iz_trig_155()
{
	t = getEnt("iz_trig_155", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4u_stop";
	t thread iz_trig(0.2000);
}

iz_trig_156()
{
	t = getEnt("iz_trig_156", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage4j_stop";
	t thread iz_trig(0.2000);
}

iz_trig_157()
{
	t = getEnt("iz_trig_157", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5b_stop";
	t thread iz_trig(0.2000);
}

iz_trig_158()
{
	t = getEnt("iz_trig_158", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5g_stop";
	t thread iz_trig(0.2000);
}

iz_trig_159()
{
	t = getEnt("iz_trig_159", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_160()
{
	t = getEnt("iz_trig_160", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5f_stop";
	t thread iz_trig(0.2000);
}

iz_trig_161()
{
	t = getEnt("iz_trig_161", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5i_stop";
	t thread iz_trig(0.2000);
}

iz_trig_162()
{
	t = getEnt("iz_trig_162", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5h_stop";
	t thread iz_trig(0.2000);
}

iz_trig_163()
{
	t = getEnt("iz_trig_163", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5j_stop";
	t thread iz_trig(0.2000);
}

iz_trig_164()
{
	t = getEnt("iz_trig_164", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_165()
{
	t = getEnt("iz_trig_165", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_166()
{
	t = getEnt("iz_trig_166", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_167()
{
	t = getEnt("iz_trig_167", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_168()
{
	t = getEnt("iz_trig_168", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "stage5h_stop";
	t thread iz_trig(0.2000);
}

iz_trig_169()
{
	t = getEnt("iz_trig_169", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_170()
{
	t = getEnt("iz_trig_170", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_171()
{
	t = getEnt("iz_trig_171", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 1250);
	t thread iz_trig(0.2000);
}

iz_trig_172()
{
	t = getEnt("iz_trig_172", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "bonus_stop";
	t thread iz_trig(0.2000);
}

iz_trig_173()
{
	t = getEnt("iz_trig_173", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_174()
{
	t = getEnt("iz_trig_174", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "bonus_stop";
	t thread iz_trig(0.2000);
}

iz_trig_175()
{
	t = getEnt("iz_trig_175", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "bonus_stop";
	t thread iz_trig(0.2000);
}

iz_trig_176()
{
	t = getEnt("iz_trig_176", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_177()
{
	t = getEnt("iz_trig_177", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "bonus_stop";
	t thread iz_trig(0.2000);
}

iz_trig_178()
{
	t = getEnt("iz_trig_178", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_179()
{
	t = getEnt("iz_trig_179", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "teleport";
	t.iz_dest = "bonus_stop";
	t thread iz_trig(0.2000);
}

iz_trig_180()
{
	t = getEnt("iz_trig_180", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_hold = "teleport";
	t.iz_hold_time = 90;
	t thread iz_trig(0.2000);
}

iz_trig_181()
{
	t = getEnt("iz_trig_181", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 500, 0);
	t thread iz_trig(0.2000);
}

iz_act(event, kind, value, delay)
{
	act = [];
	act["event"] = event;
	act["kind"] = kind;
	act["value"] = value;
	act["delay"] = delay;
	return act;
}

iz_trig(every)
{
	self.iz_seen = [];
	self.iz_who = [];
	self.iz_fired = [];
	if (isDefined(self.iz_dest))
		self.iz_dest = iz_trig_dest(self.iz_dest);
	for (i = 0; i < self.iz_acts.size; i++)
		if (self.iz_acts[i]["event"] == "end")
		{
			self thread iz_trig_leaves();
			break;
		}
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player) || !player iz_named(self))
			continue;
		n = player getEntityNumber();
		now = getTime();
		first = !isDefined(self.iz_seen[n]) || now - self.iz_seen[n] > 100;
		self.iz_seen[n] = now;
		self.iz_who[n] = player;
		if (first)
			self iz_trig_fire(player, "start");
		if (!isDefined(self.iz_fired[n]) || (every >= 0 && now - self.iz_fired[n] >= every * 1000))
		{
			self.iz_fired[n] = now;
			self iz_trig_fire(player, "trigger");
		}
		if (isDefined(self.iz_hold))
			player iz_hold(self.iz_hold, self.iz_hold_time, now);
		if (isDefined(self.iz_push))
			player iz_push(self.iz_push, isDefined(self.iz_push_once), first);
		if (isDefined(self.iz_dest))
			player iz_teleport(self.iz_dest);
	}
}

iz_trig_leaves()
{
	for (;;)
	{
		wait 0.05;
		now = getTime();
		keys = getArrayKeys(self.iz_seen);
		for (i = 0; i < keys.size; i++)
		{
			n = keys[i];
			player = self.iz_who[n];
			if (isDefined(player) && isAlive(player) && now - self.iz_seen[n] <= 50)
				continue;
			self.iz_seen[n] = undefined;
			self.iz_who[n] = undefined;
			if (isDefined(player))
				self iz_trig_fire(player, "end");
		}
	}
}

iz_trig_fire(player, event)
{
	for (i = 0; i < self.iz_acts.size; i++)
	{
		act = self.iz_acts[i];
		if (act["event"] != event)
			continue;
		if (act["kind"] == "boost")
			player thread iz_boost(act["value"], act["delay"]);
		else if (act["kind"] == "name")
			player thread iz_rename(act["value"], act["delay"]);
	}
}

iz_trig_dest(name)
{
	ents = getEntArray(name, "targetname");
	for (i = 0; i < ents.size; i++)
		if (isDefined(ents[i].origin))
			return ents[i];
}

iz_named(trigger)
{
	if (!isDefined(trigger.iz_filter))
		return true;
	named = isDefined(self.iz_name) && self.iz_name == trigger.iz_filter;
	if (!named && isDefined(self.iz_held) && isDefined(self.iz_held[trigger.iz_filter]))
	{
		held = self.iz_held[trigger.iz_filter];
		named = getTime() - held["seen"] <= 100 && getTime() - held["since"] >= held["time"];
	}
	if (isDefined(trigger.iz_filter_not))
		return !named;
	return named;
}

iz_hold(name, time, now)
{
	if (!isDefined(self.iz_held))
		self.iz_held = [];
	held = self.iz_held[name];
	if (!isDefined(held) || now - held["seen"] > 100)
	{
		held = [];
		held["since"] = now;
	}
	held["seen"] = now;
	held["time"] = time;
	self.iz_held[name] = held;
}

iz_rename(name, delay)
{
	self endon("disconnect");
	if (delay > 0)
		wait delay;
	self.iz_name = name;
}

iz_boost(velocity, delay)
{
	self endon("disconnect");
	self endon("death");
	if (delay > 0)
		wait delay;
	self setVelocity(self getVelocity() + velocity);
}

iz_push(push, once, first)
{
	velocity = self getVelocity();
	if (once)
	{
		if (first)
			self setVelocity(velocity + push);
		return;
	}
	flat = (push[0], push[1], 0);
	if (first)
		velocity += flat;
	speed = length(flat);
	if (speed > 0 && self isOnGround())
	{
		along = vectorDot(velocity, flat) / speed;
		if (along < speed)
			velocity += flat * ((speed - along) / speed);
	}
	self setVelocity(velocity + (0, 0, push[2] * 0.05));
}

iz_teleport(dest)
{
	if (!isDefined(dest))
		return;
	self setOrigin(dest.origin);
	if (isDefined(dest.angles))
		self setPlayerAngles(dest.angles);
	self setVelocity((0, 0, 0));
}
