main()
{
	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((1280, -124, -756), 90);
	thread sr\api\_speedrun::createEndMap((-97.6992, 469.871, -169.875), 90, 100);

	thread ele1();
	thread ele2();

}

ele1()
{
	part1 = getEnt( "elevator_1_1", "targetname" );
	part2 = getEnt( "elevator_1_2", "targetname" );
	part3 = getEnt( "elevator_1_3", "targetname" );
	part4 = getEnt( "elevator_1_4", "targetname" );
	blades = getEntArray( "chopper_blades_lights", "targetname" );
	beam = getEnt( "hover_beam_lights", "targetname" );

{
	part1 moveZ(25,0.1);
	part2 moveZ(-35,0.1);
	part3 moveX(-200,0.1);
	part4 moveY(-100,0.1);
	blades[0] delete();
	blades[1] delete();
	blades[2] delete();
	blades[3] delete();
	blades[4] delete();
	blades[5] delete();
	beam delete();
	wait 0.2;
	part1 moveY(-20,0.1);
	part2 moveY(-50,0.1);
	part3 moveZ(-60,0.1);
	wait 0.4;
	part3 moveY(250,0.1);

}
	
	
}

ele2()
{
	
	blocker1 = getEnt( "blocker_1_1", "targetname" );
	blocker2 = getEnt( "blocker_1_2", "targetname" );
	part1 = getEnt( "trap_1_1", "targetname" );
	part2 = getEnt( "trap_1_2", "targetname" );
	part2_1 = getEnt( "trap_1_3", "targetname" );
	part3 = getEnt( "trap_2_1", "targetname" );
	part4 = getEnt( "trap_2_2", "targetname" );
	blocker = getEnt( "platform_blocker", "targetname" );
	blocker_kill = getEnt( "platform_blocker_kill", "targetname" );
	platform1 = getEnt( "platform_1_1", "targetname" );
	platform2 = getEnt( "platform_1_2", "targetname" );

{	
	blocker1 delete();
	blocker2 delete();
	part2_1 delete();
	blocker delete();
	blocker_kill delete();
	platform1 moveX(600,0.1);
	platform2 moveX(-400,0.1);
	wait 0.2;
	platform1 moveZ(520,0.1);
	platform2 moveZ(520,0.1);
}

}
