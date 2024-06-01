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
	setdvar("compassmaxrange","1500");

	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((1, -112, 76), 88);
	thread sr\api\_speedrun::createTeleporter((-2034.67, 12315.7, -3359.88), 80, 100, (-7095, 12060, -2576), 180, "freeze");
	thread sr\api\_speedrun::createTeleporter((-12957, 3897.51, -4920.73), 70, 100, (-12967, 6885, -3719), 354, "freeze");
	thread sr\api\_speedrun::createTeleporter((158.121, -112.063, 16.125), 60, 100, (1408, -18256, 1076), 90, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((-10888.1, 6892.86, -4177.84), 165, 100, "normal_0");

	thread start();
	thread enddoor();
	thread secretreturn1();
	thread secretreturn2();
	thread secret_finish();
	 
}

start()
{
	leftdoor = getEnt ("door_move_left","targetname");
	rightdoor = getEnt ("door_move_right","targetname");
	clip = getEnt ("start_clip","targetname");
	
	clip Delete();
	leftdoor Delete();
	rightdoor Delete();
	

}

enddoor()
{
	leftdoor = getEnt ("end_door_left","targetname");
	rightdoor = getEnt ("end_door_right","targetname");
	endtrig = getEnt("enddoor_trig", "targetname");
	
	leftdoor Delete();
	rightdoor Delete();
}

secretreturn1()
{
	teleport1 = GetEnt("secret_return_1","targetname");
	origin1 = GetEnt("secret_origin","targetname");
	for(;;)
    {
	teleport1 waittill("trigger", player);
	
	player Suicide();
	       
}	
}

secretreturn2()
{
	teleport1 = GetEnt("secret_return_2","targetname");
	origin1 = GetEnt("secret_return_2origin","targetname");

	for(;;)
    {
	teleport1 waittill("trigger", player);
	
	player Suicide();
}	
}

secret_finish()
{
	teleport1 = GetEnt("secret_finish","targetname");
	origin1 = GetEnt("secret_finish_origin","targetname");

	for(;;)
    {
	teleport1 waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");
	
			
}	
}
