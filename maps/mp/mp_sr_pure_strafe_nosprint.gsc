main()
{
	maps\mp\_load::main();
	
	game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "urban";
    game["axis_soldiertype"] = "urban";
	game["mapname"] = "mp_sr_pure_strafe_nosprint";

	SetDvar("bg_falldamagemaxheight", 99999);
	SetDvar("bg_falldamageminheight", 99998);
    
	thread sr\api\_map::createSpawn((272,0,92), 0);
	thread sr\api\_speedrun::createNormalWays("No-Sprint Way;Slide Way");
    thread sr\api\_speedrun::createWay((384.821, 360.654, 32.125), 135, 220, "cyan", "normal_1");

	level thread no_sprint_spam();
	level thread normal_1_end();
}

no_sprint_spam() 
{
	for(;;) 
	{
	wait 0.05;
        
    players = getEntArray( "player", "classname" );
    for(i=0;i<players.size;i++) 
    {
    players[i] AllowSprint(false);
    }

	}
}

normal_1_end()
{
    trig = getEnt ("trig_end_normal_1", "targetname");

    
    for(;;)
    {   
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("normal_1");

    }
    }