main()
{
	setExpFog(0, 6931.4722, 0.3000, 0.3100, 0.3400, 0);

	maps\mp\mp_cod2_brecourt_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((-3704, 1514, 98), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((3633, -1780, 0), 150, 100);
}

iz_sounds()
{
	ambientPlay("iz_0_amb_france01b", 2);
}
