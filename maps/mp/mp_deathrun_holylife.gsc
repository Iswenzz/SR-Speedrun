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
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-2040, 380, -292), 90);
	thread sr\api\_speedrun::createTeleporter((-2242.47, 872.267, -335.875), 70, 100, (-1000, 1381, -708), 90, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((-2049.96, 4183.01, 568.125), 210, 100);
	
	thread start_elevator();
	thread secret_respawn();
	thread secret_respawn1();
	thread secret_respawn2();
	thread secret_respawn3();
	thread fix((-2645.87, 615.125, -351.875));
	thread fix((-2625.53, 1797.55, -335.875));

	
}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 110, 550);
	trigger.targetname = "fix";
	trigger.radius = 110;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

start_elevator()
{
	platform = getent("startplatform","targetname");
	
	platform movez(1024,0.1);
	
}

secret_respawn()
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

secret_respawn1()
{
	trig = getEnt("tele2", "targetname");
	target = getEnt("tele2_target", "targetname");
	
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

secret_respawn2()
{
	trig = getEnt("tele3", "targetname");
	target = getEnt("tele3_target", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		player thread sr\api\_speedrun::finishWay("secret_0");
		
	}
}

secret_respawn3()
{
	trig = getEnt("tele4", "targetname");
	target = getEnt("tele4_target", "targetname");
	
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