main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
    setDvar("bg_bobmax", 0);

    thread sr\api\_map::createSpawn((47, -371, 76), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

    thread startDoor();
}

startDoor()
{
	door = getEnt("startdoor", "targetname");
	door delete();
}