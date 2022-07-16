main()
{
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_bloc");

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
	
	// raise up planes to avoid them flying through buildings
	level.airstrikeHeightScale = 1.8;

	thread speedrun\_way_name::create_spawn((-2016, -4342, 112), 360);
	thread speedrun\_way_name::create_normal_way("Normal Way");
	thread speedrun\_way_name::create_endmap((4043.6, -6580.41, 0.125), 100, 40);

}