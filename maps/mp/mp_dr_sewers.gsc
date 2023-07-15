main()
{
	thread sr\api\_defrag::weapons("");
	maps\mp\_load::main();

	setExpFog(600, 600, 0, 0, 0, 0);

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_map::createSpawnOrigin((498, -568, 14), 92);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread finaldoor();
	
}

finaldoor()
{
	final_door_a = getent("final_door_a","targetname");
	final_door_b = getent("final_door_b","targetname");
	final_door_open = getent("final_door_open","targetname");

	
	final_door_a delete();
	final_door_b delete();
	
	
}

