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

thread sr\api\_map::createSpawn((-11,24,36),360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createEndMap((8328.09, 133.999, -23.875), 115, 10);
thread sr\api\_speedrun::createEndMap((2891.45, -1772.73, 2598.13), 55, 10, "secret_0");
thread sr\api\_speedrun::createTeleporter((-6, -234, 36), 55, 10, (29, -1256, 2658), 360, "freeze", "blue", "secret_0");
thread ele2();

}

ele2()
{
ele1 = getent ("ele1", "targetname");
ele2 = getent ("ele2", "targetname");

wait 0.1;
ele2 delete();

}
