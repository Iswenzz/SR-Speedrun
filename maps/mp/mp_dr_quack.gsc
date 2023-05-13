main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setDvar("r_gamma","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0","1");
	setDvar("r_glowbloomintensity1","1");
	setDvar("r_glowskybleedintensity0","1");
	setDvar("compassmaxrange","1800");
	setDvar("bg_fallDamageMaxHeight", "99999");
	setDvar("bg_fallDamageMinHeight", "99998");
	
thread startdoor();

thread sr\api\_map::createSpawn((190,514,60),360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((2495.39, 5678.47, -383.875), 100, 80, (-510, 5249, -140), 269, "freeze", "blue", "normal_0");

}

startdoor()
{
start = getEnt("starting_fence","targetname");
	
start delete();

}