main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;Epic Secret Way;");

	thread sr\api\_map::createSpawn((-523, 171, 80), 320);

	maps\mp\_load::main();
	// maps\mp\_teleport::main();
	
    game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
    
	thread sr\api\_speedrun::createTeleporter((-173, -227, 80), 100, 150, 
		(-1596, -4293, -418), 180, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-616, -215, 80), 100, 150, 
		(-1749, -914, 132), 360, "freeze", "blue", "secret_1");
	thread sr\api\_speedrun::createEndMap((-2252, -2005, 210), 100, 150);
	thread sr\api\_speedrun::createEndMap((1650, 5839, -1744), 250, 50, "secret_0");
	thread sr\api\_speedrun::createEndMap((-983, -2719, 875), 100, 50, "secret_1");
	thread sr\api\_speedrun::createTeleporter((847, 1475, 188), 100, 150, (785, 1156, 639), 270, "freeze");
	
	
	elevatorparts = getentarray("secret","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread secret();
	}
	}
	
	thread startdoor();
	thread addTriggerToList( "trigger_spikes" );
	
	}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

 
startdoor()
{
door = getent("rise1","targetname");

door delete();

}

secret()
{
trigger = getEnt("trigger_secret", "targetname");
// trigger waittill("trigger");
// trigger delete();
self delete();
}
