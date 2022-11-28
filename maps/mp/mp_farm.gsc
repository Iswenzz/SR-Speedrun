#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_mp_farm");

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

	thread sr\api\_map::createSpawnOrigin((1398.8, -1218.64, 132.159), 135);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createEndMap((1862.11, 4470.62, 227.846), 115, 50);

}