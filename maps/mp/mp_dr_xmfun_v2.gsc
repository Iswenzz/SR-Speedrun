main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	
	setdvar("r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("r_drawDecals","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("compassmaxrange","1800");
 	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-608, -408, 76), 270);
    thread sr\api\_speedrun::createEndMap((-2621.6, -1607.89, 16.125), 150, 100);
                  

    thread startdoor();
	
}	

startdoor()
{
	door = getent ("startdoor","targetname");
	
	door delete();	

}
