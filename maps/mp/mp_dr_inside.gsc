main()
{
    maps\mp\_load::main();
	maps\mp\_teleport::main();
	
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-19, 897, 1355), 90);
    thread sr\api\_speedrun::createTeleporter((-16.9167, 2955.52, 1296.13), 140, 100, (1924, 3351, 1355), 360, "freeze");
    thread sr\api\_speedrun::createTeleporter((4980.53, 3330.8, 1290.13), 140, 100, (5435, 1628, 1350), 270, "freeze");
    thread sr\api\_speedrun::createTeleporter((5417.2, -2575.28, 1290.13), 140, 100, (3575, -2999, 1350), 180, "freeze");
    thread sr\api\_speedrun::createEndMap((-2161.85, -1249.8, 1287.13), 165, 100);
    
	
	thread startdoor();
	

}

startdoor()
{
	door=getent("startdoor","targetname");
	
	door delete();
}

