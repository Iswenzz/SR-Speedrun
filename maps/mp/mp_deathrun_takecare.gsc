main()
{
	maps\mp\_load::main();
	
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((882, 888, 252), 270);
	thread sr\api\_speedrun::createEndMap((-737.448, 928.946, 192.125), 75, 100);
 

	thread traps();
	thread plat();

}

	 
traps()
{
kill1 = getEnt ("kill_1" , "targetname");
kill2= getEnt ("killa" , "targetname");
kill3 = getent ("killzone","targetname");
pusher1 = getent ("pusher1","targetname");
pusher2 = getent ("pusher2","targetname");
pusher3 = getent ("pusher3","targetname");
pusher4 = getent ("pusher4","targetname");

	  
kill1 delete();
kill2 delete();
kill3 delete();
pusher1 delete();
pusher2 delete();
pusher3 delete();
pusher4 delete();
		
}

plat()
{
plat = getEnt ("platform" , "targetname");
	     
plat moveY (-150 , 0.1 );
		   
}
		