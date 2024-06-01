main()
{
trigger = getent("trig_jumper_tele_end", "targetname");	
trigger.targetname = "endmap_trig";

	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setDvar("compassmaxrange","1800");
	setDvar("r_distortion" , "1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-28, 38, 3133), 270);
	thread sr\api\_speedrun::createTeleporter((7.11015, -14965.3, 2760.13), 175, 100, (7, -14092, 604), 90, "freeze");
	thread sr\api\_speedrun::createTeleporter((-6.88631, -4119.44, 544.125), 150, 100, (1313, -2169, 532), 270, "freeze");
	thread sr\api\_speedrun::createTeleporter((-20.8918, -8811.07, 2928.13), 150, 100, (10, -11303, 2988), 270, "freeze");
	
	getEntArray("water2","targetname")[0] notSolid();
	getEntArray("Water3","targetname")[0] notSolid();
	getEntArray("water4","targetname")[0] notSolid();
	getEntArray("water5","targetname")[0] notSolid();

	thread water();
	thread water1();
	thread water2();
	thread water3();
	
	
}

water()
{
    trig = getEnt("water_death_trig","targetname");
	
    for(;;)
	{
		trig waittill("trigger", player);

		player Suicide();
		
	}
}

water1()
{
    trig = getEnt("water_death_trig1","targetname");
	
    for(;;)
	{
		trig waittill("trigger", player);

		player Suicide();
		
	}
}

water2()
{
    trig = getEnt("water_death_trig2","targetname");
	
    for(;;)
	{
		trig waittill("trigger", player);

		player Suicide();
		
	}
}

water3()
{
    trig = getEnt("water_death_trig3","targetname");
	
    for(;;)
	{
		trig waittill("trigger", player);

		player Suicide();
		
	}
}