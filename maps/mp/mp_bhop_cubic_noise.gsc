main()
{
	visionSetNaked("mp_bhop_cubic_noise", 0);

	thread iz_triggers();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
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
}

iz_trig_0()
{
	t = getEnt("iz_trig_0", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 550, 0);
	t thread iz_trig(0.2000);
}

iz_trig_1()
{
	t = getEnt("iz_trig_1", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 550, 0);
	t thread iz_trig(0.2000);
}

iz_trig_2()
{
	t = getEnt("iz_trig_2", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -550, 0);
	t thread iz_trig(0.2000);
}

iz_trig_3()
{
	t = getEnt("iz_trig_3", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "s2end";
	t.iz_dest = "tp03";
	t thread iz_trig(0.2000);
}

iz_trig_4()
{
	t = getEnt("iz_trig_4", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 750), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_5()
{
	t = getEnt("iz_trig_5", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 128), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_6()
{
	t = getEnt("iz_trig_6", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 128), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_7()
{
	t = getEnt("iz_trig_7", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 128), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_8()
{
	t = getEnt("iz_trig_8", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 128), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_9()
{
	t = getEnt("iz_trig_9", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 128), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_10()
{
	t = getEnt("iz_trig_10", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 135), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_11()
{
	t = getEnt("iz_trig_11", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 128), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_12()
{
	t = getEnt("iz_trig_12", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 132), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_13()
{
	t = getEnt("iz_trig_13", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 200), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_14()
{
	t = getEnt("iz_trig_14", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "name", "s3tp", 0);
	t thread iz_trig(0.2000);
}

iz_trig_15()
{
	t = getEnt("iz_trig_15", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "name", "s2end", 0);
	t thread iz_trig(0.2000);
}

iz_trig_16()
{
	t = getEnt("iz_trig_16", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_17()
{
	t = getEnt("iz_trig_17", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "s3tp";
	t.iz_dest = "tp04";
	t thread iz_trig(0.2000);
}

iz_trig_18()
{
	t = getEnt("iz_trig_18", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -512, 0);
	t thread iz_trig(0.2000);
}

iz_trig_19()
{
	t = getEnt("iz_trig_19", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp01";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_20()
{
	t = getEnt("iz_trig_20", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -512, 0);
	t thread iz_trig(0.2000);
}

iz_trig_21()
{
	t = getEnt("iz_trig_21", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 256), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_22()
{
	t = getEnt("iz_trig_22", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "s4end";
	t.iz_dest = "tp05";
	t thread iz_trig(0.2000);
}

iz_trig_23()
{
	t = getEnt("iz_trig_23", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 160), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_24()
{
	t = getEnt("iz_trig_24", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "boost", (0, 0, 330), 0.0100);
	t thread iz_trig(0.2000);
}

iz_trig_25()
{
	t = getEnt("iz_trig_25", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "name", "s5end", 0);
	t thread iz_trig(0.2000);
}

iz_trig_26()
{
	t = getEnt("iz_trig_26", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("end", "name", "s4end", 0);
	t thread iz_trig(0.2000);
}

iz_trig_27()
{
	t = getEnt("iz_trig_27", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (512, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_28()
{
	t = getEnt("iz_trig_28", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "s5end";
	t.iz_dest = "tp06";
	t thread iz_trig(0.2000);
}

iz_trig_29()
{
	t = getEnt("iz_trig_29", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 256, 0);
	t thread iz_trig(0.2000);
}

iz_trig_30()
{
	t = getEnt("iz_trig_30", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp05d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_31()
{
	t = getEnt("iz_trig_31", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp06";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_32()
{
	t = getEnt("iz_trig_32", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp03d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_33()
{
	t = getEnt("iz_trig_33", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp02d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_34()
{
	t = getEnt("iz_trig_34", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_35()
{
	t = getEnt("iz_trig_35", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp01";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_36()
{
	t = getEnt("iz_trig_36", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp03d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_37()
{
	t = getEnt("iz_trig_37", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp03d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_38()
{
	t = getEnt("iz_trig_38", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_39()
{
	t = getEnt("iz_trig_39", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_40()
{
	t = getEnt("iz_trig_40", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp05d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_41()
{
	t = getEnt("iz_trig_41", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp05d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_42()
{
	t = getEnt("iz_trig_42", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp05d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_43()
{
	t = getEnt("iz_trig_43", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp06";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_44()
{
	t = getEnt("iz_trig_44", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_45()
{
	t = getEnt("iz_trig_45", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_46()
{
	t = getEnt("iz_trig_46", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_47()
{
	t = getEnt("iz_trig_47", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_48()
{
	t = getEnt("iz_trig_48", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_49()
{
	t = getEnt("iz_trig_49", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_50()
{
	t = getEnt("iz_trig_50", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_51()
{
	t = getEnt("iz_trig_51", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_52()
{
	t = getEnt("iz_trig_52", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_53()
{
	t = getEnt("iz_trig_53", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_54()
{
	t = getEnt("iz_trig_54", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_55()
{
	t = getEnt("iz_trig_55", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_56()
{
	t = getEnt("iz_trig_56", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_57()
{
	t = getEnt("iz_trig_57", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_58()
{
	t = getEnt("iz_trig_58", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_59()
{
	t = getEnt("iz_trig_59", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_60()
{
	t = getEnt("iz_trig_60", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_61()
{
	t = getEnt("iz_trig_61", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_62()
{
	t = getEnt("iz_trig_62", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_63()
{
	t = getEnt("iz_trig_63", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_64()
{
	t = getEnt("iz_trig_64", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_65()
{
	t = getEnt("iz_trig_65", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_66()
{
	t = getEnt("iz_trig_66", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_67()
{
	t = getEnt("iz_trig_67", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_68()
{
	t = getEnt("iz_trig_68", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_69()
{
	t = getEnt("iz_trig_69", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_70()
{
	t = getEnt("iz_trig_70", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp04d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_71()
{
	t = getEnt("iz_trig_71", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp02d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_72()
{
	t = getEnt("iz_trig_72", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp02d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
	t thread iz_trig(0.2000);
}

iz_trig_73()
{
	t = getEnt("iz_trig_73", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_dest = "tp02d";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "d", 0);
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
