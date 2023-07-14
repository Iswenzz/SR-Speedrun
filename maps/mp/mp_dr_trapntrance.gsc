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
  	setDvar( "compassmaxrange", "1024" );

	thread sr\api\_speedrun::createNormalWays("Trap Way;Trance Way;");
	thread sr\api\_map::createSpawn((-2576, 3504, 572), 270);
	thread sr\api\_speedrun::createTeleporter((-4569.62, -1137.14, 512.125), 135, 100, (-4562, -3177, 572), 270, "freeze");
	thread sr\api\_speedrun::createEndMap((-515.046, -8817.71, 512.125), 130, 100, "normal_0");
	thread sr\api\_speedrun::createEndMap((-4579.51, -8794.2, 512.125), 130, 100, "normal_1");

  	thread startdoor();
  	thread trapjump();
  	thread trancejump();
  	thread trapport();
  	thread tranceport();


}

startdoor()
{
	door[0] = getEnt( "trapdoor", "targetname" );
	door[1] = getEnt( "trancedoor", "targetname" );
	
	door[0] delete();
	door[1] delete();
	
}

trapjump()
{
	startdoor = getEnt("trapjumperdoor", "targetname");

	startdoor delete();
	
}

trapport()
{
  trigger = getEnt("sendtotrap", "targetname");
  target = getEnt("trap_origin", "targetname");
  
  for(;;)
  {
	trigger waittill ("trigger", player);
		
	player thread sr\api\_speedrun::changeWay("normal_0");
	player FreezeControls(1);
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	wait 0.1;
	player FreezeControls(0);
		
  }
}

trancejump()
{
	startdoor = getEnt("trancejumperdoor", "targetname");

	startdoor delete();
}

tranceport()
{
  trigger = getEnt("sendtotrance", "targetname");
  target = getEnt("trance_origin", "targetname");
  
  for(;;)
  {
	trigger waittill ("trigger", player);
		
	player thread sr\api\_speedrun::changeWay("normal_1");
	player FreezeControls(1);
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	wait 0.1;
	player FreezeControls(0);
	
   }
}