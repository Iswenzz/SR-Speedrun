main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1.85" );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((16, 16, 12), 90);
	thread sr\api\_speedrun::createEndMap((96.8749, 3954.83, -47.875), 120, 100);
	
	thread door();

           
}

door()
{
	brush = getEnt ("trap5.1", "targetname");
	brush1 = getEnt( "move26", "targetname" );
	brush2 = getEnt( "trap7", "targetname" );

	
	brush delete();
	brush2 delete();
	brush1 moveY( 170,0.1);
	 
}

