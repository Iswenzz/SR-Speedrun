main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_jeepride_fx::main();
	maps\createfx\mp_sp_jeepride_fx::main();

	setExpFog( 1002.96, 211520, 0.952941, 0.980392, 1, 0 );
	VisionSetNaked( "jeepride", 0 );

	thread sr\api\_map::createSpawn((20145, 11269, 226), 315);
	thread sr\api\_speedrun::createNormalWays("Normal Way;Reverse Way");
	thread sr\api\_speedrun::createEndMap((-35855, -15808, 470), 200, 70, "normal_0");
	thread sr\api\_speedrun::createEndMap((23633, 11429, -415), 200, 70, "normal_1");
	thread sr\api\_speedrun::createTeleporter((20385, 11347, 196), 70, 50, (-27049, -12590, 527), 100, "freeze", "blue", "normal_1");
}
