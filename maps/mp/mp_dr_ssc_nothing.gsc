main()
{
	maps\mp\_load::main();
	//maps\mp\_teleport::main();
	//maps\mp\mp_dr_ssc_nothing_soundfx::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_map::createSpawn((-6, -49, 76), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((231.17, 49.4164, 254.625), 90,120, "normal_0"); 


	// total traps: 4
	// activated by user: 4
	// allways active (and, or hidden): 0
	thread trap_1();
	thread trap_2();
	thread trap_3();
	thread trap_4();
	thread finalDoor();
}

trap_1()
{
	trig = getEnt( "trigger1", "targetname" );

	brush1 = getEnt( "trap1_1", "targetname" );
	brush2 = getEnt( "trap1_2", "targetname" );

	oldOrigin1 = brush1.origin;
	oldOrigin2 = brush2.origin;

	trig waittill( "trigger", who );

}

trap_2()
{
	trig = getEnt( "trigger2", "targetname" );
	brush = getEnt( "trap2", "targetname" );

	trig waittill( "trigger", who );
	
}

trap_3()
{
	trig = getEnt( "trigger3", "targetname" );
	brushGroup1 = getEntArray( "trap3_1", "targetname" );
	brushGroup2 = getEntArray( "trap3_2", "targetname" );

	trig waittill( "trigger", who );
	
}

trap_4()
{
	trig = getEnt( "trigger4", "targetname" );
	brush = getEnt( "trap4", "targetname" );

	trig waittill( "trigger", who );

}


finalDoor()
{
	trig = getEnt( "doors_trig", "targetname" );
	brush = getEnt( "door", "targetname" );

	brush delete();
}