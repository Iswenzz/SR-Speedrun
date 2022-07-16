main()
{
	maps\mp\_load::main(); 
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread speedrun\_way_name::create_spawn((-2175, -1991, 586),90);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;");
	thread speedrun\_way_name::create_tp((-2177.04, -2491.73, 460.606), 235, 60, (-2165, -3278, 572), 270, "freeze", "yellow", "s0");
	thread speedrun\_way_name::create_endmap((510.74, -4595.06, 984.125),100,20,"s0");

	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".1");
	setDvar("r_glowbloomintensity1",".1");
	setDvar("r_glowskybleedintensity0",".1");
	setDvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_fallDamageMinHeight", "99998");

}
