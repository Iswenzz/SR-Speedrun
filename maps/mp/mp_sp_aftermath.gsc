main()
{
	precachemodel( "com_airduct_square" );

	maps\mp\_load::main();
	maps\mp\mp_sp_aftermath_fx::main();

	VisionSetNaked( "aftermath", 0 );
}
