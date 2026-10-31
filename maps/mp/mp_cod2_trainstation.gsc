main()
{
	setExpFog(0, 5545.1772, 0.7000, 0.8500, 1, 0);

	maps\mp\mp_cod2_trainstation_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((8837, -2797, 77), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((3805, -3870, -10), 100, 90);
}

iz_sounds()
{
	ambientPlay("iz_1_amb_france01b", 2);
	iz_emitter("iz_0_fire_med_loop02", (6684, -2432, 288), 0);
	iz_emitter("iz_0_fire_med_loop02", (4300, -3282, 178), 0);
	iz_emitter("iz_0_fire_med_loop02", (4221, -4133, 54), 0);
	iz_emitter("iz_0_fire_med_loop02", (6390, -4173, 13), 0);
	iz_emitter("iz_0_fire_med_loop02", (7741, -4229, 94), 0);
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
