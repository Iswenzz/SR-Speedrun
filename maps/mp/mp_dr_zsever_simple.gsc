main()
{
    maps\mp\_load::main();
         
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
    
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((7, 27, 76), 180);

    thread start();
    thread tp();
    thread tp2();

    
}

start()
{
	door = getent("startdoor","targetname");
    trap8 = getent("trap8","targetname");
	
	door delete();
    trap8 delete();
}

tp()
{
	trig = getent("trig_platform1", "targetname");
    ori = spawn("script_origin",(-4347,-3570,188));
	ori.angles = (0,0,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");


	for(;;)
	{
	trig waittill("trigger",player);

	player setOrigin(ori.origin);
	player SetPlayerAngles(ori.angles);
	player FreezeControls(1);
	wait 0.1;
	player FreezeControls(0);
	}

}

tp2()
{
	trig = getent("trig_platform8", "targetname");
    ori = spawn("script_origin",(1340,-8587,636));
	ori.angles = (0,270,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");


	for(;;)
	{
	trig waittill("trigger",player);

	player setOrigin(ori.origin);
	player SetPlayerAngles(ori.angles);
	player FreezeControls(1);
	wait 0.1;
	player FreezeControls(0);
	}

}
