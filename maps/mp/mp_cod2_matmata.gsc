main()
{
	setExpFog(0, 3465.7361, 0.5000, 0.5000, 0.5000, 0);

	maps\mp\mp_cod2_matmata_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((5710, 8070, 50), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((2490, 4939, 20), 100, 100);
}

iz_sounds()
{
	ambientPlay("iz_0_amb_africa01b", 2);
}
