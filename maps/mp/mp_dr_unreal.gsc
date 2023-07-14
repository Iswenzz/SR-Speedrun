main()
{
	maps\mp\_load::main();	
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;Secret Way;");
	thread sr\api\_map::createSpawn((-144, -320, 92), 90);
	thread sr\api\_speedrun::createTeleporter((-402.446, -68.0676, 32.125), 60, 100, (-2770, -838, -324), 270, "freeze", "yellow", "normal_1");

	thread main_door();
	thread secretteleback();
	
	
}

main_door()
{
	main_doorb  =getent( "main_doorb", "targetname" );
	main_doore  =getent( "main_doore", "targetname" );
	main_doora  =getent( "main_doora", "targetname" );
	main_doorc  =getent( "main_doorc", "targetname" );
	terror  =getent( "terror", "targetname" );
	
	main_doorb delete();
	main_doore delete();
	main_doora delete();
	main_doorc delete();
	terror delete();
}
	
secretteleback()
{
	trig_back=getent("sec_back","targetname");
	backmap=getent("backmap","targetname");

	for(;;)
	{
		trig_back waittill("trigger", player);
		
		player FreezeControls(1);
		player SetOrigin( backmap.origin );
		player SetPlayerAngles((0,180,0));
		wait 0.1;
		player FreezeControls(0);
		
	}
}

