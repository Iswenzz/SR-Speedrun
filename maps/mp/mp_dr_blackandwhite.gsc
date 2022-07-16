main()
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

precacheItem("m40a3_mp");
precacheItem("deserteagle_mp");
precacheItem("rpg_mp");
precacheItem("remington700_mp");
precacheItem("knife_mp");
precacheItem("m14_mp");

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setdvar("compassmaxrange","1800");

thread speedrun\_way_name::create_spawn((-11,24,36),360);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_endmap((8328.09, 133.999, -23.875), 115, 10, "ns0");
thread speedrun\_way_name::create_endmap((8328.09, 133.999, -23.875), 75, 10, "s0");
thread speedrun\_way_name::create_tp((2891.45, -1772.73, 2598.13), 55, 10, (29, -1256, 2658), 360, "freeze", "blue", "s0");
thread ele2();
	
}

ele2()
{
ele1 = getent ("ele1", "targetname");
ele2 = getent ("ele2", "targetname");

wait 0.1;
ele2 delete();

}
