main()
{

maps\mp\_load::main();

    game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_map::createSpawn((230,1535,76),1);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Banana Way;");
	thread sr\api\_speedrun::createTeleporter((2066.02, 1550.5, 34.125), 50, 25, (1952, 1540, 252), 180, "freeze", "blue");
	thread sr\api\_speedrun::createTeleporter((502.587, 1802.51, 16.125), 60, 35, (1979, 1035, 496), 180, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((-291.868, 1033.4, 436.125), 85, 35, "secret_0");

	thread start();
	thread movingplat();
}

start() 
{
door = getEnt ("begindoor","targetname");
block1 = getEnt ("begin1","targetname");
block2 = getEnt ("begin2","targetname");
block3 = getEnt("edeur", "targetname");

wait 0.1;

door delete();
block1 delete();
block2 delete();
block3 delete();
}

movingplat()
{
trap6 = getEnt("trap6", "targetname");

wait 0.1;

trap6 moveY(170,0.1);

}