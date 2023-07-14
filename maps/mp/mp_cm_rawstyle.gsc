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
	setdvar("bg_fallDamageMinHeight","10000000");
	setdvar("bg_fallDamageMaxHeight","100000001");
	visionSetNaked("mp_dr_rawstyle", 0);
	
	thread startdoor();
	thread sr\api\_map::createSpawn((243,-1152,486),90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((-4571.33, 298.102, -807.875), 95, 245, (-6591, 291, -752), 180, "freeze", "cyan");
	thread sr\api\_speedrun::createTeleporter((-8887.05, 301.988, -1407.88), 125, 150, (-9043, 294, -938), 180, "freeze", "cyan");
	
}

startdoor() 
{
door = getEnt("startdoor", "targetname");
door1 = getEnt("door1", "targetname");
door2 = getEnt("door2", "targetname");
hurt1 = getEnt("trap6hurt", "targetname");
hurt2 = getEnt("trap8hurt", "targetname");

door delete();
door1 delete();
door2 delete();
hurt1 delete();
hurt2 delete();
	
}
