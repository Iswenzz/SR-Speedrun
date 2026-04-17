main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_ambush_fx::main();

	setExpFog(2000, 5500, .462618, .478346, .455313, 0);
	VisionSetNaked( "ambush", 0 );
}
