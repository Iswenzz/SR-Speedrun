#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_mp_shipment");

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

	thread sr\api\_map::createSpawn((-721, -603, 260), 49);
	thread sr\api\_speedrun::createNormalWays("Normal Way;Cargo Way");
	thread sr\api\_speedrun::createEndMap((690.455, 735.083, 192.077), 85, 115, "normal_0");
	thread sr\api\_speedrun::createWay((-713.248, 77.0254, 299.125), 115, 200, "none", "normal_1");
	thread sr\api\_speedrun::createEndMap((-713.248, 77.0254, 299.125), 115, 200, "normal_1");

}

