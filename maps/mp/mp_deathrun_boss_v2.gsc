main()
{
	maps\mp\_load::main();
	
	precacheItem ("deserteagle_mp");
	precacheItem ("colt45_silencer_mp");
	precacheItem ("winchester1200_mp");
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
		setdvar( "r_specularcolorscale", "1" );
		setdvar("r_glowbloomintensity0",".25");
        setdvar("r_glowbloomintensity1",".25");
        setdvar("r_glowskybleedintensity0",".3");
    
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((798, -14, 76), 359);
	thread sr\api\_speedrun::createTeleporter((1942.89, -6114.58, -4495.88), 150, 100, (3738, -6247, -4436), 0, "freeze");
	thread sr\api\_speedrun::createTeleporter((798.451, 169.819, 16.125), 60, 100, (12783, -1812, -1396), 359, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((11021.9, -6129.62, -4415.88), 240, 100, "normal_0");
	

	thread stage2teleport();
	thread stage3teleport();
	thread startdoor();
	thread secretend();
	
}



stage2teleport()
{
	trig = getEnt("tele1", "targetname");
	target = getEnt("tele1_target", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
			player FreezeControls(1);
			wait 0.1;
			player FreezeControls(0);
		}
	}
}

stage3teleport()
{
	trig = getEnt("tele2", "targetname");
	target = getEnt("tele2_target", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		
		{	
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
			player FreezeControls(1);
			wait 0.1;
			player FreezeControls(0);
		}
	}
}


startdoor()
{
	startdoor = getent("startdoor","targetname");
	
	startdoor delete();
}

secretend()
{
	trig = getEnt("secretend_multi", "targetname");
	target = getEnt("secretend_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		{
		player thread sr\api\_speedrun::finishWay("secret_0");
		}
	}
}