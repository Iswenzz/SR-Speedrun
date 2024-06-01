main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((801,750,-84),270);
	thread sr\api\_speedrun::createEndMap((475.396, 3270.41, -575.875), 90, 100);
    
	thread map_mover();
	thread startdoor();
	thread trap2();
	thread trap9();
	thread trap10();
}

map_mover()
{
	object = getent("map_mover","targetname");
	
	object movez (32,5);
	
}

trap2()
{
	trigger = getEnt ( "trap2_trig", "targetname" );
	trap2_fx = getent("trap2_fx","targetname");
	kill1 = getEnt ( "trap2_1", "targetname" );
	kill2 = getEnt ( "trap2_2", "targetname" );
	
	kill1 delete();
	kill2 delete();

}

trap9()
{
	trigger = getEnt ( "trap9_trig", "targetname" );
	object = getEnt ( "trap9", "targetname" );
	kill = getEnt ( "trap9_kill", "targetname" );
	trap9_fx = getent("trap9_fx","targetname");
	
	kill delete();
	
}

trap10()
{
	trigger = getEnt ( "trap10_trig", "targetname" );
	kill = getEnt ( "trap_10kill", "targetname" );
	trap10_fx = getent("trap10_fx","targetname");
	g1 = getent("trap10g1","targetname");
	g2 = getent("trap10g2","targetname");
	g3 = getent("trap10g3","targetname");
	g4 = getent("trap10g4","targetname");
	g5 = getent("trap10g5","targetname");
	g6 = getent("trap10g6","targetname");
	
	kill delete();
}

startdoor()
{
	object = getent("startdoor","targetname");

	object delete();

}
