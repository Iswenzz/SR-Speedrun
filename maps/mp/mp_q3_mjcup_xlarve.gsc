main()
{
	sr\api\_q3::setWeapons("pg");
	sr\api\_q3::setAmmo(200);

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
	iz_emitter("iz_0_long_road_home", (1072, -3328, -1792), 0, 18.7632);
	iz_emitter("iz_1_fireloud", (832, -256, 1184), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1408, -128, 64), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1088, -7296, -1232), 0, 4.0808);
	iz_emitter("iz_2_deep_chant_drone", (512, -128, -1024), 0, 3.5291);
	iz_emitter("iz_3_amen_satan", (336, -256, -1296), 0, 7.0787);
	iz_emitter("iz_1_fireloud", (1904, -256, 1184), 0, 4.0808);
	iz_emitter("iz_0_long_road_home", (704, -384, 544), 0, 18.7632);
	iz_emitter("iz_1_fireloud", (336, -256, -1696), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1472, -256, 672), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1504, -256, -1696), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (912, -256, -1696), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1088, -5376, -1360), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1088, -2784, -848), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (-72, -256, -848), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1080, -784, -832), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1080, -1456, -832), 0, 4.0808);
	iz_emitter("iz_1_fireloud", (1080, -2128, -832), 0, 4.0808);
	iz_emitter("iz_0_long_road_home", (64, -128, 96), 0, 18.7632);
	iz_emitter("iz_4_xl_night2", (480, 544, -1408), 0, 7.5137);
	iz_emitter("iz_4_xl_night2", (32, 544, -1408), 0, 7.5137);
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
