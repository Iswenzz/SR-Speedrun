main()
{
	setExpFog(0, 1540.3271, 0.5800, 0.5700, 0.5700, 0);

	maps\mp\mp_cod2_leningrad_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((941, -849, 85), 140);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((-1330, 1183, 50), 80, 110);
}

iz_sounds()
{
	ambientPlay("iz_1_amb_russia01b", 2);
	iz_emitter("iz_0_fire_big_loop02", (1384, -746, -575), 0);
	iz_emitter("iz_0_fire_big_loop02", (-1352, -1494, 656), 0);
	iz_emitter("iz_0_fire_big_loop02", (-2236, 1405, 362), 0);
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
