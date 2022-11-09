main()
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"]= "desert";

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");

thread sr\api\_map::createSpawn((680,-49,709),1);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((720.667, 321.135, 648.625), 70, 60, (4028, -356, 853), 360, "freeze", "blue", "secret_0");
thread sr\api\_speedrun::createEndMap((10544.9, 126.551, 891.125),100,50, "normal_0");
thread sr\api\_speedrun::createEndMap((10060.2, -357.346, 792.625),100,50, "secret_0");

thread elevator();

}

elevator()
{
plat = getEnt("elevator", "targetname");


plat movez(444,0.1);


}