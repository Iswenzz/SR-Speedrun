main()
{
maps\mp\_load::main();
		
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
		
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
		
thread speedrun\_way_name::create_spawn((1533,735,124),90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_endmap((1543.47, 19599.4, 641.125), 145, 40, "ns0");

thread start();
thread twisters();
}

start()
{
brush1 = getEnt("startdoor", "targetname");

wait 0.1;
brush1 delete();
}

twisters()
{
epica = getEnt("twister1a", "targetname");
epicb = getEnt("twister1b", "targetname");

wait 0.1;
epica movex(400,0.1);
epicb movex(-400,0.1);
}