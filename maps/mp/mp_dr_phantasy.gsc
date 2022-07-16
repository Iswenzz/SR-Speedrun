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

thread speedrun\_way_name::create_spawn((6,-1336,76),2);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_endmap((7.76228, -2058.89, 16.125), 70, 10, "ns0");

thread startdoor();	
	
}

startdoor()
{	
door=getent("startdoor","targetname");

wait 0.1;
door delete();
	
}