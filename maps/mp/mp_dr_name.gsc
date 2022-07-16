main()
{
    game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread speedrun\_way_name::create_spawn((-156,-0,76),270);
thread speedrun\_way_name::create_normal_way("Normal Way;");

thread door();
}

door()
{
door = getent("door","targetname");
trig = getent("drown_water","targetname");

wait 0.1;
door delete();
trig delete();

}