main()
{
	setExpFog(0, 6931.4722, 0.5294, 0.5098, 0.4353, 0);

	maps\mp\mp_cod1_bocage_fx::main();

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
