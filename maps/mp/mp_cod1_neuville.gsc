main()
{
	setExpFog(0, 2772.5886, 0.3200, 0.3600, 0.4000, 0);

	maps\mp\mp_cod1_neuville_fx::main();

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
	ambientPlay("iz_0_amb_brecourt_ext", 2);
}
