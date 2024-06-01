main()
{

    maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("r_gamma", "1.8");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((25, 160, 76), 90);
	thread sr\api\_speedrun::createTeleporter((180.924, 159.995, 16.125), 60, 100, (66, 3292, 156), 180, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((-617.82, 6501.95, 16.1255), 130, 100);

	
	thread glitch();
	thread glitch2();
	thread glitch3();
	thread glitch4();
	thread fall2();
	thread fall3();
	thread fall4();
	thread fall5();
	thread trap1();
	thread kill1();
	thread kill2();
	thread secret_0_end();
	thread start_door();
	thread move();
	thread move1();


	
}

glitch()
{
	trig = getEnt ("glitch", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

glitch2()
{
	trig = getEnt ("glitch2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();	
	}
}

glitch3()
{
	trig = getEnt ("glitch3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();	
	}
}

glitch4()
{
	trig = getEnt ("glitch4", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

fall()
{
	trig = getEnt ("fall", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

fall2()
{
	trig = getEnt ("fall2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

fall3()
{
	trig = getEnt ("fall3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

fall4()
{
	trig = getEnt ("fall4", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

fall5()
{
	trig = getEnt ("fall5", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player suicide();		
	}
}

trap1()
{
	brush = getEnt ("trap1_spikes", "targetname");
	hurt = getEnt ("trap1_hurt", "targetname");
	trig = getEnt ("trap1_trig", "targetname");
	
	hurt delete();
   
}

kill1()
{
	trig = getEnt ("trap2_kill1", "targetname");
	
	trig delete();
}	

kill2()
{
	trig = getEnt ("trap2_kill2", "targetname");
	
	trig delete();
}

secret_0_end()
{
	trig = getEnt ("exit_trig", "targetname");
	
	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}

}

start_door()
{
	brush = getEnt ("start_door", "targetname");
	trig = getEnt ("start_trig", "targetname");
	
	
	brush delete();
	
}

move()
{

	door_left = getEnt( "first_left", "targetname" );
	door_right = getEnt( "first_right", "targetname" );

	door_left delete();
	door_right delete();

	
}

move1()
{

	door_left = getEnt( "second_left", "targetname" );
	door_right = getEnt( "second_right", "targetname" );

	door_left delete();
	door_right delete();

}

