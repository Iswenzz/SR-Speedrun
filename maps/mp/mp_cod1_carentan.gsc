main()
{
	setExpFog(0, 6875, 0.7000, 0.8500, 1, 0);

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
