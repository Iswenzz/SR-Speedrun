main()
{
	maps\mp\mp_cod2_downtown_fx::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((2842, 1126, 61), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((952, -3476, 30), 100, 100);

	thread delEnts();
}

delEnts()
{
	ents = getEntArray("script_model", "classname");

	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].model == "prop_suitcase_bomb")
			ents[i] delete();
	}
}
