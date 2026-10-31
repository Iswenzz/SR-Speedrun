main()
{
	sr\api\_q3::setWeapons("rl;pg");
	sr\api\_q3::setAmmo(11);

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}
