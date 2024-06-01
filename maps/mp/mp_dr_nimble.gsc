main()
{

    maps\mp\_load::main();  

	game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";
 	
    setdvar("r_specularcolorscale", "1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-3040, 992, 716), 0);
 	

 	thread spawnDoor();

}


spawnDoor()
{

	door = getEnt("spawndoor", "targetname");

    door delete();


}

