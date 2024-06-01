main()
{
	// Keep one endmap trig only
	ends = getEntArray("endmap_trig", "targetname");

	ends[0] delete();
	ends[1] delete();

 maps\mp\_load::main();

       game["allies"] = "marines";
       game["axis"] = "opfor";
       game["attackers"] = "axis";
       game["defenders"] = "allies";
       game["allies_soldiertype"] = "desert";
       game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((18,-668,-204),270);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((207.386, -668.053, -263.875), 60, 100, (10464, -6633, -431), 89, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((12175.8, -2176.49, -505.875), 165, 100, "secret_0");

    thread sec_anticheat1();
    thread sec_anticheat2();
}

sec_anticheat1()
{
	trigger = getEntArray ("enter", "targetname");

	for(;;)
	{
		trigger[7] waittill ("trigger", player);

		player Suicide();

	}
}

sec_anticheat2()
{
	trigger = getEntArray ("enter", "targetname");

	for(;;)
	{
        trigger[8] waittill ("trigger", player);

		player Suicide();

	}
}