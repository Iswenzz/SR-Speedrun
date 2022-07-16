main()
{
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
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	speedrun\_way_name::createWay("secret", "Secret Way", "1");
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

secret()
{
	thread secret_end();

	trig = getEnt ("secret_enter", "targetname");
	end = getEnt ("secret_enter_go", "targetname");

	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "secret");
	
	while(1)
    	{
        trig waittill ("trigger", player); 
        player speedrun\_way_name::startSecret(); //Speedrun Copy Paste       
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

secret_end()
{
	trig = getEnt("secretend_trig","targetname");

	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "secret");

	for(;;)
	{
		trig waittill("trigger",player);

		if(isDefined(player.sr_secret) && player.sr_secret)
			player thread braxi\_mod::endTimer();
	}
}