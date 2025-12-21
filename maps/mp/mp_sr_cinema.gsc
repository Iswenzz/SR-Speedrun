main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_speedrun::createNormalWays("Absolute Cinema;");

	thread boost();
}

boost()
{
	trig = getEnt("boost", "targetname");

	while (true)
	{
		trig waittill("trigger", player);
		player sr\api\_player::setPlayerSpeed(600);
	}
}
