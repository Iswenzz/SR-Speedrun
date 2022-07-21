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
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setdvar("compassmaxrange","1500");

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((7.76228, -2058.89, 16.125), 70, 10, "normal_0");

thread startdoor();	
	
}

startdoor()
{	
door=getent("startdoor","targetname");

wait 0.1;
door delete();
	
}