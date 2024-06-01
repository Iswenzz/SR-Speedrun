main()
	{
	maps\mp\_load::main();
	
	setExpFog(500, 2200, 0.81, 0.75, 0.63, 0.5);
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Short Secret;^3Bounce Secret;^3Mixed Secret;");
	thread sr\api\_map::createSpawn((2430, 609, 76), 360);
	thread sr\api\_speedrun::createTeleporter((4336.13, 612.45, -3.87499), 125, 100, (4494, 716, 1340), 360, "freeze");
	thread sr\api\_speedrun::createTeleporter((2429.98, 478.592, 16.125), 60, 100, (2109, -1148, 736), 360, "freeze", "green", "secret_0");
    thread sr\api\_speedrun::createTeleporter((2429.96, 761.431, 16.125), 60, 100, (2368, -6947, 1156), 90, "freeze", "yellow", "secret_1");
	thread sr\api\_speedrun::createTeleporter((2645.31, 743.402, 16.125), 60, 100, (3121, -7046, 1725), 360, "freeze", "orange", "secret_2");

	thread mover();
	thread startdoor();
	thread trap3();
	thread trap9();
	thread secret3respawn1();
	thread secret3_respawn2();
	thread secret3_teil2();
	thread secret3_respawn3();
	thread secret1_finish();
	thread secret0_finish();
	thread respawn1();
	thread respawn2();
	thread secret2respawn();
	thread secret2_finish();

	
}

mover()
{
	objecta = getent ("trap3a", "targetname");
	objectb = getent ("trap3b", "targetname");
		
	
	objecta moveX (250, 0.1);
	objectb moveX (400, 0.1);
		
}

startdoor()
{
	object = getent("links", "targetname");
	object1 = getent ("rechts", "targetname");
	main_door  = getent( "main_door", "targetname" );
	spike = getent("spikes", "targetname");
	killtrigger = getent ("spikesh", "targetname");
	liftL = getent ("liftL", "targetname");
	liftR = getent ("liftR", "targetname");
	object2  = getent ("secret_door", "targetname");
	scheibe = getent ("train_scheibe", "targetname");
	door1 = getent ("door1", "targetname");
		
	object delete();
	object1 delete();
	main_door delete();
	killtrigger delete();
	spike delete();
	liftL delete();
	liftR delete();
	object2 delete();
	scheibe delete();
	door1 delete();
				
}

trap3()
{
		
	object1 = getent ("trap3_lasera", "targetname");
	object2 = getent ("trap3_laserb", "targetname");
	hurt1 = getent ("laser_hurt1", "targetname");
	hurt2 = getent ("laser_hurt2", "targetname");
	hurt4 = getent ("laser_hurt4", "targetname");
	hurt5 = getent ("laser_hurt5", "targetname");	
	
	object1 delete();
	object2 delete();
	hurt1 delete();
	hurt2 delete();
	hurt4 delete();
	hurt5 delete();
		
}

trap9()
{
	trigger = getent ("trap9_trigger", "targetname");
	object = getent ("trap9", "targetname");
	hurt1 = getent ("trap9_hurt1", "targetname");
	hurt2 = getent ("trap9_hurt2", "targetname");
	hurt3 = getent ("trap9_hurt3", "targetname");
	
	hurt1 delete();
	hurt2 delete();
	hurt3 delete();
}

secret0_finish()
{
	trigger = getEnt ("secret_ausgang_teleport", "targetname");
	target = getEnt ("secret_ausgang_target", "targetname");
	
	for(;;)
	{
	trigger waittill ("trigger", player);
		
		
	player thread sr\api\_speedrun::finishWay("secret_0");
	}
}	

respawn1()
{
	trigger = getEnt ("secret_respawn1", "targetname");
	target = getEnt ("secret_respawn1_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player Suicide();
	}
}

respawn2()
{
	trigger = getEnt ("secret_respawn2", "targetname");
	target = getEnt ("secret_respawn2_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player Suicide();
	}
}


secret2respawn()
{
	trigger = getEnt ("secret2_respawn_trigger", "targetname");
	target = getEnt ("secret2_respawn_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player Suicide();
	}
}

secret2_finish()
{
	trigger = getent ("m60_1_trigger", "targetname");
		
	for(;;)
	{
		trigger waittill ("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_2");
		

    }	
}

secret3respawn1()
{
	trigger = getent ("secret3_respawn1_trigger", "targetname");

	for(;;)
	{
	trigger waittill ("trigger", player);
		
	player Suicide();

	}
}
secret3_respawn2()
{
	trigger = getent ("secret3_respawn2_trigger", "targetname");
		

	for(;;)
	{
	trigger waittill ("trigger", player);
		
	player Suicide();

	}
}

secret3_teil2()
{
	trigger = getent ("secret3_teil2_trigger", "targetname");
	target = getent ("secret3_teil2_eingang", "targetname");
		
	for(;;)
	{
	trigger waittill ("trigger", player);
		
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player FreezeControls(1);
	wait 0.1;
	player FreezeControls(0);

	}
}

secret3_respawn3()
{
		trigger = getent ("secret3_teil2_respawn_trigger", "targetname");
		target = getent ("secret3_teil2_respawn", "targetname");
		
		for(;;)
	{
		trigger waittill ("trigger", player);
		
		player Suicide();
		
	}
}

secret1_finish()
{
	trigger = getent ("secret3_ausgang_trigger", "targetname");
	target = getent ("secret3_ausgang", "targetname");

	for(;;)
	{
	trigger waittill ("trigger", player);
		
	player thread sr\api\_speedrun::finishWay("secret_1");

	}
}
