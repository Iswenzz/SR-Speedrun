main()
{
thread sr\api\_map::createSpawn((221, -149, 1173), 234);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
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


thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((-408.351, -2541.96, 88.125), 60, 10, (1007, -2537, 150), 50, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((-24.7226, -202.352, 1139.94), 60, 20, (5490, -5789, -201), 90, "freeze", "red", "secret_0");
thread sr\api\_speedrun::createEndMap((-4235.72, -334.019, 56.125), 150, 10, "normal_0");
thread sr\api\_speedrun::createEndMap((5121.54, 2611.6, 80.125), 50, 10, "secret_0");

thread startdoor();

}

startdoor()
{      
door = getent("map_starter","targetname");

wait 0.1;
door hide();
door notsolid();
}
