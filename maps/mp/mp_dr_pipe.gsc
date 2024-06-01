main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((146,-459,60),175);
	thread sr\api\_speedrun::createTeleporter((142.959, -572.609, 0.016153), 60, 100, (-6054, -1487, 421), 108, "freeze", "yellow", "secret_0");
	
	thread startdoor();
	thread shf();
	thread sec0_finish();
	thread trap6();
	thread door_6();
	thread door_7();

	wall = getEnt ( "trap7_wall", "targetname" );
	wall delete();


}

door_6()
{
	trigger = getEnt ( "door6_trig", "targetname" );
	door_6 = getEnt ( "door6", "targetname" );
	
	door_6 delete();
}

door_7()
{
	trigger = getEnt ( "door7_trig", "targetname" );
	door_7 = getEnt ( "door7", "targetname" );
	
	door_7 delete();
}

startdoor()
{
	object = getent("startdoor","targetname");
	
	object delete();
}

shf()
{
	trig=getent("shf","targetname");
	targ=getent("shf_go","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		
		player Suicide();
		
		
	}
}

sec0_finish()
{
	trig = getEnt ("shend", "targetname");
	end = getEnt ("shend_go", "targetname");
	while(1)
    {
        trig waittill ("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
		
	}
}

trap6()
{
	trigger = getEnt ( "trap6_trig", "targetname" );
	kill1 = getEnt ( "trap6_1", "targetname" );
	kill2 = getEnt ( "trap6_2", "targetname" );

	kill1 delete();
	kill2 delete();

}
