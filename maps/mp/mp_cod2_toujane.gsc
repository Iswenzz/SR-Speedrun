main()
{
	setExpFog(0, 4620.9810, 0.9000, 0.9500, 1, 0);

	maps\mp\mp_cod2_toujane_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((2160, 1885, 365), 225);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((125, 158, 0), 100, 90);
}

iz_sounds()
{
	ambientPlay("iz_0_amb_africa01b", 2);
}
