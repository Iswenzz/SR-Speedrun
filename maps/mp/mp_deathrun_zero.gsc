main()
{
maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("compassmaxrange","2000");

thread sr\api\_map::createSpawn((3,653,78),270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((-1860, 82, 76), 100, 100);

thread stuff();

portals = getentarray("teleport", "targetname");

	for(inx = 0; inx < portals.size; inx++)
	{
		thread TransporterRandom(portals, inx);
	}
}

TransporterRandom(portals, inx)
{
	trigger = spawn( "trigger_radius", portals[inx].origin, 0, 40, 40);

	while(true)
	{
		trigger waittill("trigger",player);

		if (getdvarint("scr_teleport_disabled") == 1)
		{
			continue;
		}

		if(!isDefined(player) || isDefined(player.mp_deathrun_zero_teleport_time) && player.mp_deathrun_zero_teleport_time + 3000 > GetTime())
			continue;

		endInx = randomint(portals.size);
		while(endInx == inx)
			endInx = randomint(portals.size);

		player linkTo(portals[endInx]);
		player setorigin(portals[endInx].origin);
		player SetPlayerAngles(portals[endInx].angles);
		player unlink();
		player.mp_deathrun_zero_teleport_time = GetTime();
	}
}

stuff()
{
block1 = getent("mackac1", "targetname");
block2 = getent("tlacic1", "targetname");

wait 0.05;
block1 delete();
block2 delete();

}