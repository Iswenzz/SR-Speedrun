main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("compassmaxrange","1600");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((97, -2, -52), 0);
	thread sr\api\_speedrun::createTeleporter((97.2123, 182.838, -111.875), 60, 100, (-1668, 963, -324), 359, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createEndMap((5409.58, 2436.91, -335.375), 105, 100);
    thread sr\api\_speedrun::createEndMap((-652.866, -50.7279, -63.875), 65, 100, "secret_0");

	thread door01();

}

door01()
{
	d1 = getEnt ("door01_s","targetname");
	d2 = getEnt ("door","targetname");
	t1 = getEnt ("t3","targetname");
	hurt = getEnt ("t3_hurt","targetname");

	d1 delete();
	d2 delete();
	t1 delete();
	hurt delete();
}