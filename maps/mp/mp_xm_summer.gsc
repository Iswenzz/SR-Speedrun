main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((832, -4992, 556), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createTeleporter((3675.49, -4974.25, 496.125), 80, 70, (4540, -4963, 556), 0, "freeze", "blue");

    thread startDoor();
}

startDoor()
{
	door = getEnt("startdoor", "targetname");
	door delete();
}