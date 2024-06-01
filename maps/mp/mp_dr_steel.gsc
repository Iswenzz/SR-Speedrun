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
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((2444, 613, 76), 360);
	thread sr\api\_speedrun::createTeleporter((4336.13, 612.45, -3.87499), 80, 100, (4486, 612, 1340), 360, "freeze");
	thread sr\api\_speedrun::createTeleporter((2444.05, 445.733, 16.125), 60, 100, (2116, -1147, 736), 0, "freeze", "yellow", "secret_0");

	thread startdoor();
	thread secret_0_finish();
	thread respawn1();
	thread respawn2();
	thread train();
	

}
		

startdoor()
{
	object = getent("links", "targetname");
	main_door  = getent( "main_door", "targetname" );
	door  = getent( "rechts", "targetname" );
	killtrigger = getent ("spikesh", "targetname");
	object1 = getent ("knopf", "targetname");
	liftL = getent ("liftL", "targetname");
	liftR = getent ("liftR", "targetname");
	sec= getent ("secret_door", "targetname");
	trap9= getent ("move", "targetname");


	object delete();	
	main_door delete();
	door delete();
	killtrigger delete();
	object1 delete();
	liftL delete();
	liftR delete();
	sec delete();
	trap9 delete();
				
}

secret_0_finish()
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
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn2()
{
	trigger = getEnt ("secret_respawn2", "targetname");
	target = getEnt ("secret_respawn2_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

train()
{
		
	gleis2 = getent ("gleis2", "targetname"); 
	door2 = getent ("door2", "targetname"); 
	scheibe = getent ("train_scheibe", "targetname");
	door1 = getent ("door1", "targetname");

	gleis2 delete();			
	door2 delete();
	scheibe delete();
	door1 delete();
		
}
