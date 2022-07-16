#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
    maps\mp\_load::main();

 	thread speedrun\_way_name::create_spawn((4,466,76),270);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;");
    thread speedrun\_way_name::create_tp((-3618.66, 437.539, -173.942), 55, 95, (-3669, 1562, -114), 98,"freeze");
    thread speedrun\_way_name::create_tp((171.921, -201.41, 16.3458), 100, 95, (-524, 4041, 302), 181, "freeze", "cyan", "s0");
    thread speedrun\_way_name::create_endmap((-4077.53, 2535.03, -173.942),120,40,"ns0");
    thread speedrun\_way_name::create_endmap((-1181.95, 7193.06, 42.4977),165,35,"s0");
	
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

 
	thread startdoor();
    thread anticut_main();

}

startdoor()
{
	door=getent("startdoor","targetname");
	door delete();
}

anticut_main() 
{
    trig1 = spawn( "trigger_radius", (-1277.06, 4624.98, 13.2463), 0, 1255, 10 );
    trig2 = spawn( "trigger_radius", (-2369.09, 5987.85, 13.253), 0, 1420, 10 );
    trig3 = spawn( "trigger_radius", (-1765.83, 7381.17, 13.2463), 0, 1420, 10 );
    trig4 = spawn( "trigger_radius", (-3048.43, 4058.95, 13.253), 0, 820, 10 );
    
    trig1 thread anticut();
    trig2 thread anticut();
    trig3 thread anticut();
    trig4 thread anticut();

}

anticut() 
{
    
    enter = getent("auto16","targetname");

    for(;;)
    {
        self waittill("trigger",player);
        player setOrigin( enter.origin );
  		player setplayerangles( enter.angles );
    }

}