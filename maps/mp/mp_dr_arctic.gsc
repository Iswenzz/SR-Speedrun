main()
{
	maps\mp\_load::main();
	 	 
	game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";


	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((1360, 593, 42), 270);
	thread sr\api\_speedrun::createEndMap((730.452, 699.898, 96.625), 115, 100);

}