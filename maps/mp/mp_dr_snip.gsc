 main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((-1059, -998, 45), 89);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((-1060.47, -449.343, 241.485), 285, 130, (-1059, -998, 45), 89, "freeze");
	thread sr\api\_speedrun::createEndMap((-293.713, -1094.88, -15.875), 65, 100);
	
}
