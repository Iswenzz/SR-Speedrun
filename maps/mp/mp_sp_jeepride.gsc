main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_jeepride_fx::main();
	maps\createfx\mp_sp_jeepride_fx::main();

	setExpFog( 1002.96, 211520, 0.952941, 0.980392, 1, 0 );
	VisionSetNaked( "jeepride", 0 );
}
