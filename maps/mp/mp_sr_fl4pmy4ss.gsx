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
	setdvar("bg_falldamagemaxheight", 3280000); 
	setdvar("bg_falldamageminheight", 1280000);

    thread way_connect();
	thread secret();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
    
    sr\api\_map::createWay("normal", "Normal Way", "1");
    sr\api\_map::createWay("secret", "Secret Way", "1");
    
    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
        player thread onPlayer();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////
 
onPlayer()
{
    for(;;)
    {
        self waittill("spawned_player");
		self setjumpheight(125);
    }
}

secret()
{
	trig = getEnt("secret_enter", "targetname");
	end = getEnt("secret_enter_go", "targetname");

    thread secret_end();

    wait 1;
    thread speedrun\_triggerfx::createTrigFx(trig, "secret");

	while(1)
    {
        trig waittill ("trigger", player);        
    	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
        player sr\api\_map::startSecret(); //Speedrun Copy Paste
	}
}

secret_end()
{
    trig = getEnt("secretend_trig","targetname");

    wait 1;
    thread speedrun\_triggerfx::createTrigFx(trig, "secret");

    for(;;)
    {
        trig waittill ("trigger", player);

        if(isDefined(player.sr_secret) && player.sr_secret)
            player thread braxi\_mod::endTimer();
    }
}