main()
{
	setExpFog(0, 4620.9810, 0.1500, 0.1400, 0.1300, 0);

	maps\mp\mp_cod2_breakout_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((3000, 3115, 63), 40);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((6380, 6602, -50), 100, 100);
}

iz_sounds()
{
	ambientPlay("iz_2_amb_france01b", 2);
	iz_emitter("iz_0_fire_med_loop02", (3345, 3349, 117), 0);
	iz_emitter("iz_1_fire_sm_loop01", (3316, 5767, 64), 0);
	iz_emitter("iz_0_fire_med_loop02", (4082, 5757, 126), 0);
	iz_emitter("iz_0_fire_med_loop02", (5011, 5791, 127), 0);
	iz_emitter("iz_1_fire_sm_loop01", (6122, 4709, 71), 0);
	iz_emitter("iz_0_fire_med_loop02", (6593, 3995, 47), 0);
	iz_emitter("iz_0_fire_med_loop02", (5299, 3293, 61), 0);
	iz_emitter("iz_1_fire_sm_loop01", (5300, 4477, 64), 0);
	iz_emitter("iz_0_fire_med_loop02", (5088, 4163, 48), 0);
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
