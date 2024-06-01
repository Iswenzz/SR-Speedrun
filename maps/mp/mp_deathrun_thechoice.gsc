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
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_speedrun::createNormalWays("Bounce Way;Strafe Way;");
    thread sr\api\_map::createSpawn((0, 0, 68), 90);
	thread sr\api\_speedrun::createWay((-145.4, 441.869, 4.125), 100, 100, "yellow", "normal_1");
	thread sr\api\_speedrun::createTeleporter((9.17668, 540.901, 128.125), 445, 100, (0, 0, 68), 90, "freeze");
	thread sr\api\_speedrun::createEndMap((143.69, 195.728, -943.875), 60, 100, "normal_0");
	thread sr\api\_speedrun::createEndMap((-263.624, 255.735, -183.875), 60, 100, "normal_1");
	
	thread startdoor();
	
}


startdoor()
{
	door = getent("start_door", "targetname");

	door delete();
	
	
}