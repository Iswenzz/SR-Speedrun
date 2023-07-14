main()
{
	maps\mp\_load::main();
	
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");


    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((576, -129, 76), 179);
	thread sr\api\_speedrun::createEndMap((1900.95, -1728.02, 16.125), 130, 100);

	thread traps();

}

traps()
{
trap7 = getent ("trap7","targetname");
rotate = getent ("rotate","targetname");

trap7 delete();
rotate delete();

}