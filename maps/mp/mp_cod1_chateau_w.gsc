main()
{
	setExpFog(0, 69314.7188, 0, 0, 0, 0);

	maps\mp\mp_cod1_chateau_w_fx::main();

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
	ambientPlay("iz_0_amb_night04", 2);
}
