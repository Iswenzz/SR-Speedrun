main()
{
thread sr\api\_map::createSpawnOrigin((-40, 52, 15), 90);
 maps\mp\_load::main();

 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";


	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);


thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((3095.35, 9445.44, -383.875), 100, 25);
}
