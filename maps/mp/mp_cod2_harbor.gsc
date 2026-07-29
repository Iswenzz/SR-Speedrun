main()
{
	maps\mp\mp_cod2_harbor_fx::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((-5820, -7372, 50), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((-11635, -8093, 10), 100, 100);
}
