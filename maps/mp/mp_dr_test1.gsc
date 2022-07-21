main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_mp_sr_pure_cancer");
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
 
	setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((-18005.1, -8482.77, 3057.16), 165, 35, (-15810, -8393, 2732), 270, "freeze", "blue");
	thread sr\api\_speedrun::createEndMap((-12914.6, -5392.06, 903.675), 180, 40, "normal_0");
}
