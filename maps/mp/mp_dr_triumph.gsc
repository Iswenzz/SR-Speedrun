main()
{
 maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
	setDvar("bg_fallDamageMaxHeight", 99999);
	setDvar("bg_fallDamageMinHeight", 9999);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((0, 0, 76), 0);
	thread sr\api\_speedrun::createTeleporter((5547.07, 6.52985, 16.125), 170, 100, (6067, 178, 1100), 360, "freeze");


	thread startdoor();
	thread elevator_1();
	thread zipline_1();
	thread zipline_2();

	
}

startdoor()
{
startdoor = getent("startdoor","targetname");

startdoor delete();

}

elevator_1()
{
	elevator = getent("elevator_1", "targetname");
	
	
	elevator movez(144, 0.1);
	
	
}

zipline_1()
{
	start = getent("zipline_1_start","targetname");
	end = getent("zipline_1_end","targetname");
	trigger = getent("zipline_1_trig","targetname");
	trigger setHintString("Press [Use] to use zipline");

	for(;;)
	{
		trigger waittill("trigger", player);
		player thread zipline_move(start.origin, end.origin);
	}
}

zipline_2()
{
	start = getent("zipline_2_start","targetname");
	end = getent("zipline_2_end","targetname");
	trigger = getent("zipline_2_trig","targetname");
	trigger setHintString("Press [Use] to use zipline");

	for(;;)
	{
		trigger waittill("trigger", player);
		player thread zipline_move(start.origin, end.origin);
	}
}
zipline_move(start, end)
{
	level endon("disconnect");
	self endon("death");
	self endon("disconnect");

	self sr\api\_player::antiElevator(false);

	mov_link = spawn ( "script_model", (5, 7, 1));
	mov_link.origin = self.origin;
	self linkto(mov_link);
	
	self freezeControls(1);
	self setPlayerAngles((0,0,0));
	mov_link moveto(start, 0.5);
	mov_link waittill("movedone");
	mov_link moveto(end, 1);
	mov_link waittill("movedone");
	self freezeControls(0);
	
    self sr\api\_player::antiElevator(true);

	self unlink();
	mov_link delete();
}