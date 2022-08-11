main()
{
maps\mp\_load::main();


	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar( "compassmaxrange", "1024" );

thread sr\api\_map::createSpawn((2691,5004,1036),270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((3158.27, 783.037, 896.125), 100, 10, "normal_0");

thread final();
thread final2();

}

final()
{
door = getEnt( "door_final", "targetname" );
clip = getEnt( "clip_final", "targetname" );

wait 0.2;
door delete();
clip delete();

}

final2()
{
door = getEnt( "door_final", "targetname" );
stairs = getEnt( "final_stairs1", "targetname" );
stairs2 = getEnt( "final_stairs2", "targetname" );
stairs3 = getEnt( "final_stairs3", "targetname" );
stairs4 = getEnt( "final_stairs4", "targetname" );
stairs5 = getEnt( "final_stairs5", "targetname" );
stairs6 = getEnt( "final_stairs6", "targetname" );
stairs7 = getEnt( "final_stairs7", "targetname" );
stairs8 = getEnt( "final_stairs8", "targetname" );
trig = getEnt( "trig_final2", "targetname" );

wait 0.2;
stairs movex (-584,0.2);
stairs2 movex (-552,0.4);
stairs3 movex (-520,0.6);
stairs4 movex (-488,0.8);
stairs5 movex (-456,1);
stairs6 movex (-424,1.2);
stairs7 movex (-392,1.4);
stairs8 movex (-360,1.6);
door movez(-440,2);

}