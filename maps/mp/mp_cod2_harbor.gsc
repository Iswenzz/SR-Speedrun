main()
{
	setExpFog(0, 2475.5256, 0.5800, 0.5700, 0.5700, 0);

	maps\mp\mp_cod2_harbor_fx::main();

	thread iz_sounds();

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

iz_sounds()
{
	ambientPlay("iz_1_amb_russia01b", 2);
	iz_emitter("iz_0_fire_med_loop02", (-8681, -7063, 66), 0);
	iz_emitter("iz_0_fire_med_loop02", (-8642, -8987, 43), 0);
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
