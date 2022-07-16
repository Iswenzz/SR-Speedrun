main()
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";
 
setdvar("r_specularcolorscale","1");
setdvar("compassmaxrange","1600");
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 20000000 );
setDvar("bg_falldamageminheight", 15000000 );

thread sr\api\_map::createSpawn((1292, -310, 130), 270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((-3137.81, -10.0093, 81.125), 100, 10);

thread doors();
}

doors() 
{
door = getent("startdoor", "targetname"); 
door1 = getent("porte1", "targetname"); 
door2 = getent("porte2", "targetname"); 
	
wait 0.1;
door delete();
door1 delete();
door2 delete();
}