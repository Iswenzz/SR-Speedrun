main()
{
	maps\mp\_load::main();
	setExpFog( 1000, 17300, 0/255, 0/255, 0/255, 0 );

	thread sr\api\_map::createSpawn((1940, 2780, 60), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;Bhop Way;");

	thread sr\api\_speedrun::createTeleporter((1948, 2580, 60), 70, 50, (-16072, -17292, 62), 90, "freeze", "blue", "normal_1");

	thread sr\api\_speedrun::createEndMap((-3965, 408, 60), 80, 50, "normal_0");
	thread sr\api\_speedrun::createEndMap((5526, 8835, 60), 200, 70, "normal_1");

}
