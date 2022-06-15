main()
{
level.masterSpawn = spawn("script_origin",(-3072,448,-671));
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
	setdvar("bg_falldamagemaxheight", 3280000); 
	setdvar("bg_falldamageminheight", 1280000);

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
    thread sr\api\_map::createTriggerFx(trig, "secret");

	while(1)
    {
        trig waittill ("trigger", player);        
    	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
        player sr\api\_speedrun::changeWay("secret_0");
	}
}

secret_end()
{
    trig = getEnt("secretend_trig","targetname");

    wait 1;
    thread sr\api\_map::createTriggerFx(trig, "secret");

    for(;;)
    {
        trig waittill ("trigger", player);
player thread sr\api\_speedrun::finishWay("secret_0");
    }
}