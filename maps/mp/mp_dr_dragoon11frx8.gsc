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
	
	plat moveY(670,0.1);
	wait 0.1;
	plat rotatePitch(400,0.1);
	wait 0.1;
	plat moveZ(-210,0.1);
	wait 0.1;
	plat moveX(-150,0.1);
}