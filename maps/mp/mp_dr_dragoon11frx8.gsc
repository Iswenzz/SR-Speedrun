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
	setdvar("r_fullbright","1");

    thread sr\api\_map::createSpawn((59,92,76),270);
    thread sr\api\_speedrun::createNormalWays("Dragoon Way;");
    
    thread startdoor();
	thread mover();

}	

startdoor()
{
   door = getEnt("startdoor", "targetname");
	
	door delete();
	
}

mover()
{
	plat = getEnt("mover", "targetname");
	
    wait 0.1;
	plat rotateYaw(90,0.1);
    wait 0.2;
    plat moveY(300,0.1);
}