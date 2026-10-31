main()
{
	maps\mp\mp_cod2_decoy_fx::main();

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((9660, -12909, -439), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((6122, -13814, -540), 80, 100);
}

iz_sounds()
{
	ambientPlay("iz_1_amb_africa01b", 2);
	iz_emitter("iz_0_fire_med_loop02", (6271, -12902, -435), 0);
	iz_emitter("iz_0_fire_med_loop02", (7852, -12631, -438), 0);
	iz_emitter("iz_0_fire_med_loop02", (8197, -13405, -438), 0);
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
