main()
{
  	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap ("compass_map_mp_fnrp_piratas");
	

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((23, -51, 148), 89);
	thread sr\api\_speedrun::createEndMap((2796.97, 682.365, 88.125), 65, 100);
	
	
}