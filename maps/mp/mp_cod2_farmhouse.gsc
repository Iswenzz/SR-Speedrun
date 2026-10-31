main()
{
	setExpFog(0, 4620.9810, 0.1500, 0.1400, 0.1300, 0);

	maps\mp\mp_cod2_farmhouse_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((1337, -1978, 93), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((-3178, 1339, -30), 100, 100);
}

iz_sounds()
{
	ambientPlay("iz_0_amb_france01b", 2);
}
