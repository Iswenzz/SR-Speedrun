main()
{
	setExpFog(0, 4791.6665, 0.8000, 0.8000, 0.8000, 0);

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
	ambientPlay("iz_0_amb_snowy_ext", 2);
}
