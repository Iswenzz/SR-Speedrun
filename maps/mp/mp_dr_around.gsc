main()
{
    maps\mp\_load::main();
 
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-13, -21, -23), 180);
    thread sr\api\_speedrun::createEndMap((-11000.1, 21.988, -100.875), 190, 100);
	
	thread startdoor();

}


startdoor()
{
	door=getent("startdoor","targetname");
	
	door delete();
}	