#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	setExpFog(612, 25000, 0.613, 0.671, 0.75, 0);
	VisionSetNaked( "mp_creek", 0 );

	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_creek");
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );

		thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((223.19, 4055.94, 30.925), 80, 30);
}