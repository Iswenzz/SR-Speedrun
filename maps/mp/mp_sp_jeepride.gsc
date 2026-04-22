main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_jeepride_fx::main();
	maps\createfx\mp_sp_jeepride_fx::main();

	setExpFog( 1002.96, 211520, 0.952941, 0.980392, 1, 0 );
	VisionSetNaked( "jeepride", 0 );

	thread sr\api\_map::createSpawn((20145, 11269, 226), 315);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-35855, -15808, 470), 200, 70, "normal_0");
}
