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
    thread sr\api\_map::createSpawn((-134, 113, 61), 270);
	thread sr\api\_speedrun::createTeleporter((-845.884, -1864.68, -110.885), 65, 100, (528, -3519, -52), 360, "freeze");
	thread sr\api\_speedrun::createEndMap((1502.91, -603.842, -122.651), 200, 100);
	
	thread mapstart();


}

mapstart()
{
	obj = getent("mapstart","targetname");
	obj1 = getent("trap2door","targetname");
	obj2 = getent("izegmozog","targetname");
	hurt = getent("hurt","targetname");
	
	obj delete();
	obj1 delete();
	hurt delete();
	obj2 movey(-20,0.1);

}

