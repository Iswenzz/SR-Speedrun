main()
{
thread sr\api\_map::createSpawnOrigin((2, -3121, 992), 270);
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

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((-1.17717, -6242.37, 904.125), 60, 10, (648, -6318, 900), 360, "freeze", "blue", "normal_0");

}

