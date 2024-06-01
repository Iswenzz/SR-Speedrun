main()
{
	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-184, 16, 76), 0);
	
	thread teleport( "spawnToPart1", "spawnToPart1org" );
	thread teleport( "part1ToPart2", "part1ToPart2org" );
	thread teleport( "part2ToPart3", "part2ToPart3org" );
	thread teleport( "part3ToPart4", "part3ToPart4org" );
	thread prepareMap();

}

teleport( from, to )
{
trig = getEnt(from, "targetname");
orgn = getEnt(to, "targetname");
	while(1)
	{
	trig waittill("trigger", player);
	player freezeControls(true);
	player SetOrigin(orgn.origin);
	player SetPlayerAngles(orgn.angles);
	wait .2;
	player freezeControls(false);
	}
}

prepareMap()
{
left_trap4 = getentarray("trap4_left", "targetname");
right_trap4 = getentarray("trap4_right", "targetname");

left_trap4[0] delete();
left_trap4[1] delete();
left_trap4[2] delete();
left_trap4[3] delete();
right_trap4[0] delete();
right_trap4[1] delete();
right_trap4[2] delete();
right_trap4[3] delete();

}