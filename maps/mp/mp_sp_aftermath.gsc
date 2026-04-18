main()
{
	precachemodel( "com_airduct_square" );

	maps\mp\_load::main();
	maps\mp\mp_sp_aftermath_fx::main();

	VisionSetNaked( "aftermath", 0 );

	thread sr\api\_map::createSpawn((-696, 9895, 690), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((201, 8408, 698), 80, 70, "normal_0");
}
