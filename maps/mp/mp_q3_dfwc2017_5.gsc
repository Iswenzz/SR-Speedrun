main()
{
	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	iz_emitter("iz_0_teleloop", (6720, -336, -128), 0, 1.9541);
	iz_emitter("iz_0_teleloop", (1280, 1968, 576), 0, 1.9541);
	iz_emitter("iz_0_teleloop", (2176, 2032, 1088), 0, 1.9541);
	iz_emitter("iz_0_teleloop", (64, 1344, 576), 0, 1.9541);
	iz_emitter("iz_0_teleloop", (-7104, 128, 320), 0, 1.9541);
	iz_emitter("iz_1_endloop", (-2232, 776, 64), 0, 6.2838);
	iz_emitter("iz_0_teleloop", (-3408, -320, 1536), 0, 1.9541);
	iz_emitter("iz_2_poker", (5680, 1392, -560), 0, 10.3106);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
}
