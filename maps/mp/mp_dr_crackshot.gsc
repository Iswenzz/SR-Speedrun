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
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-10, -112, 92), 90);
    thread sr\api\_speedrun::createTeleporter((10884.3, 17897.1, -4959.88), 385, 100, (11837, 17599, -3956), 90, "freeze");
	thread sr\api\_speedrun::createTeleporter((-30.6838, 9671.62, -2975.88), 100, 100, (9159, 17920, -2916), 1, "freeze");
		
}
