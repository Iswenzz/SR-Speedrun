main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((8, -216, 76), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createTeleporter((244.189, 3541.16, 10.125), 70, 60, (231, 4719, 70), 90, "freeze", "blue");

    thread startDoor();
}

startDoor()
{
	door = getEnt("startdoor", "targetname");
	door delete();
}