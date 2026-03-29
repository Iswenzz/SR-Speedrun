main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    SetDvar("bg_falldamagemaxheight", 99999);
    SetDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((2368, -2688, 428), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createTeleporter((796.998, 2843.68, 368.125), 100, 70, (-775, 2730, 428), 180, "freeze", "blue");

    thread startDoor();
}

startDoor()
{
	door = getEnt("startdoor", "targetname");
	door delete();
}