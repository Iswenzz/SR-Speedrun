main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_mp_sr_delay_cope");

	thread sr\api\_map::createSpawn((-416, -128, 2450), 180);
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
 
	setDvar("r_specularcolorscale", "1");
	setDvar("compassmaxrange","1600");
	setDvar("r_glowbloomintensity0", ".1");
	setDvar("r_glowbloomintensity1", ".1");
	setDvar("r_glowskybleedintensity0", ".1");
	setDvar("bg_falldamagemaxheight", 20000000);
	setDvar("bg_falldamageminheight", 15000000);

	visionSetNaked("mp_sr_delay_cope", 0);

	setExpFog(768, 1500, 123/255, 155/255, 175/255, 3);
}
