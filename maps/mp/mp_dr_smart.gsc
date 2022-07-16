main()
{
 maps\mp\_load::main();

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

	
thread speedrun\_way_name::create_spawn((-40, 52, 75), 90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_endmap((3095.35, 9445.44, -383.875), 100, 25);
}
