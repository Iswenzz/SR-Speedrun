main()
{
level.masterSpawn = spawn("script_origin",(-3008,-656,2552));
level.masterSpawn.angles = (0,0,0);
    maps\mp\_load::main();
 
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";
 
    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
    setdvar("compassmaxrange","1800");
    setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);

    thread way_connect();

	thread secret();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;) 
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

secret()
{
	thread secret_end();

	trig = getEnt ("secret_enter", "targetname");
	end = getEnt ("secret_enter_go", "targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "secret");
	
	while(1)
    	{
        trig waittill ("trigger", player); 
        player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste       
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

secret_end()
{
	trig = getEnt("secretend_trig","targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "secret");

	for(;;)
	{
		trig waittill("trigger",player);

player thread sr\api\_speedrun::finishWay("secret_0");
	}
}