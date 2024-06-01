//Map by Night Howl


main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-221, 506, 45), 180);
    thread sr\api\_speedrun::createTeleporter((-4256.88, 506.736, -15.875), 80, 100, (-4268, 512, 1004), 180, "freeze");

	thread startdoor();
	thread teleport1();
	thread teleport2();
	thread teleport3();
	thread teleport4();
 
 
}

startdoor()
{
    door = getEnt("startdoor", "targetname");
	
	door delete();
	
}	


teleport1()
{
    trig = getEnt("trigger_teleport1", "targetname");
	telel = getEnt("origin_teleport1","targetname");
	
	for(;;)
	{
	    trig waittill("trigger", player);
		player setOrigin(telel.origin);
	}
}

teleport2()
{
    trig = getEnt("trigger_teleport2", "targetname");
	telel = getEnt("origin_teleport2","targetname");
	
	for(;;)
	{
	    trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

teleport3()
{
    trig = getEnt("trigger_teleport3", "targetname");
	telel = getEnt("origin_teleport3","targetname");
	
	for(;;)
	{
	    trig waittill("trigger", player);
		player setOrigin(telel.origin);
	}
}

teleport4()
{
    trig = spawn("trigger_radius",(-221.157, 333.771, -14.875),0,60,100);
	trig.radius = 60;

	ori = spawn("script_origin",(-1002,-2291,192));
	ori.angles = (0,360,0);

    thread sr\api\_map::createTriggerFx(trig, "yellow");
	
	for(;;)
	{
	    trig waittill("trigger", player);

        player thread sr\api\_speedrun::changeWay("secret_0");  

		player setOrigin(ori.origin);
        player SetPlayerAngles(ori.angles);
        player FreezeControls(1);
	    wait 0.1;
	    player FreezeControls(0);
		
	}
}	
