main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 setdvar( "r_specularcolorscale", "1" );
 setdvar("r_glowbloomintensity0",".25");
 setdvar("r_glowbloomintensity1",".25");
 setdvar("r_glowskybleedintensity0",".3");
 setdvar("compassmaxrange","1800");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((186, 258, 76), 1);
	thread sr\api\_speedrun::createTeleporter((1337.93, 520.948, 224.125), 1525, 100, (186, 258, 76), 1, "freeze");

	thread secretwall();

}

secretwall()
{
 object = getent("notsolid", "targetname");
 
 object delete();
}
 