main()
{
    maps\mp\_load::main();

    thread sr\api\_map::createSpawn((-47.6, 0, 76.5), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

    thread sr\api\_map::createDeath((-11, -448, -170), 700, 150);
    thread sr\api\_map::createDeath((-4, -1851, -230), 700, 250);
    thread sr\api\_map::createDeath((-5, -3097, -230), 500, 200);

    door = getEnt("start_door","targetname");
    door delete();
}
