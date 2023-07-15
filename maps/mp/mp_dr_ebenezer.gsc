
//Map by CM'Death
//Discord:Death#7416
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_rank;
main()
{
	thread sr\api\_defrag::weapons("");
 maps\mp\_load::main();
 
 game["allies"] = "marines";

 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";
 
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((-64, -16, 76), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");

    thread startdoor();
	
}	

startdoor()
{
   fences = getent("startdoor","targetname");
 
   fences delete();

}  
