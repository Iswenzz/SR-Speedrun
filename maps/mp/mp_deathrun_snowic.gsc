main()
{
maps\mp\_load::main(); 

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setdvar("r_specularcolorscale", "1");
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setdvar("compassmaxrange","1800");
setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);


thread speedrun\_way_name::create_spawn((221,-149,1233),234);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_tp((-408.351, -2541.96, 88.125), 60, 10, (1007, -2537, 150), 50, "freeze", "blue", "ns0");
thread speedrun\_way_name::create_tp((-24.7226, -202.352, 1139.94), 60, 20, (5490, -5789, -201), 90, "freeze", "red", "s0");
thread speedrun\_way_name::create_endmap((-4235.72, -334.019, 56.125), 150, 10, "ns0");
thread speedrun\_way_name::create_endmap((5121.54, 2611.6, 80.125), 50, 10, "s0");

thread startdoor();

}

startdoor()
{      
door = getent("map_starter","targetname");

wait 0.1;
door hide();
door notsolid();
}
