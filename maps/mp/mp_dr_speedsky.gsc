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
	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setdvar("bg_fallDamageMinHeight", "99998");
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

thread sr\api\_map::createSpawn((15, -3466, 76), 90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread startdoor();
thread trap_1();
  
}

startdoor()
{
	door = getent("startdoor","targetname");

	door delete();
}

trap_1()
{
    trap1 = getent("trap1","targetname");
	
	trap1 movex (431, 0.1);
		
}
