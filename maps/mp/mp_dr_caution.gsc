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
setdvar("compassmaxrange","1600");
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 2000000000 );
setDvar("bg_falldamageminheight", 1500000000 );

thread speedrun\_way_name::create_spawn((-28,-4,76),180);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_tp((-25.0864, -217.393, 16.125), 55, 10, (323, -676, 348), 180, "freeze", "cyan", "s0");
thread speedrun\_way_name::create_tp((-3267.13, -36.1948, 352.125), 65, 10, (-3027, -34, 860), 360, "freeze", "blue", "ns0");

thread lift();
thread secfinish();

	precacheitem ("m40a3_mp");
	precacheitem ("remington700_mp");
	precacheitem ("knife_mp");
	precacheitem ("tomahawk_mp");
	precacheitem ("uzi_silencer_mp");
	precacheItem ("ak74u_mp");
	precacheItem ("rpg_mp");
	precacheItem ("winchester1200_mp");
	precacheItem ("ak47_mp");
	precacheItem ("rpd_mp");
	precacheItem ("m1014_grip_mp");
	precacheItem ("deserteaglegold_mp");
	precacheItem ("p90_silencer_mp");
	precacheItem ("saw_grip_mp");

}

secfinish()
{
	trig = getent("secret_finish","targetname");
	
	for(;;)
	{
		trig waittill("trigger",player);
		player thread speedrun\_way_name::finish_way("s0");
	}
}

lift()
{
b = getEnt("lift","targetname");
	
wait 0.1;
b delete();

}