main()
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setdvar("r_specularcolorscale","1");
setdvar("compassmaxrange","1600");
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 20000000 );
setDvar("bg_falldamageminheight", 15000000 );

thread sr\api\_map::createSpawn((-244, 44, 76), 360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((534.132, -607.69, -19.875), 2000, 10, (-244, 44, 76), 360, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((3592.95, -598.86, -19.875), 2000, 10, (-244, 44, 76), 360, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((5680.3, -664.239, -19.875), 2000, 10, (-244, 44, 76), 360, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((6077.45, 32.3576, 16.125), 70, 25, (6432, -1429, 76), 90, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((5320.02, -1355.83, 16.125), 85, 25, (2829, -1248, 76), 180, "freeze", "blue");
thread sr\api\_speedrun::createEndMap((-198.524, -1250.32, 16.125), 190, 25);
}
