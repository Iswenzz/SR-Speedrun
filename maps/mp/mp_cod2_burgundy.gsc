main()
{
	setExpFog(0, 4620.9810, 0.7000, 0.8500, 1, 0);

	maps\mp\mp_cod2_burgundy_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((-1137, 510, 61), 25);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((1635, 2356, 10), 100, 100);
}

iz_sounds()
{
	ambientPlay("iz_1_amb_france01b", 2);
	iz_emitter("iz_0_fire_med_loop02", (201, 312, 100), 0);
}

iz_emitter(alias, origin, interval)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval);
}

iz_emitter_random(alias, interval)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
	}
}
