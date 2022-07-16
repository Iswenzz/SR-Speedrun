main()
{
	maps\mp\_load::main(); 
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread sr\api\_map::createSpawn((-2175, -1991, 586),90);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((-2177.04, -2491.73, 460.606), 235, 60, (-2165, -3278, 572), 270, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((510.74, -4595.06, 984.125),100,20,"secret_0");

	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".1");
	setDvar("r_glowbloomintensity1",".1");
	setDvar("r_glowskybleedintensity0",".1");
	setDvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_fallDamageMinHeight", "99998");

}
