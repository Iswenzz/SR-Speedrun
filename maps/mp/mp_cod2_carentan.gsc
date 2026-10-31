main()
{
	setExpFog(0, 6931.4722, 0.5500, 0.6000, 0.5500, 0);

	maps\mp\mp_cod2_carentan_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((372, -854, 93), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((935, 3805, 0), 100, 100);
}

iz_sounds()
{
	ambientPlay("iz_0_amb_france01b", 2);
}
