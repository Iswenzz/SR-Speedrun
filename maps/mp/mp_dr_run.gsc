
//Map by CM'Death
//Discord:Death#7416
main()
{
thread sr\api\_map::createSpawnOrigin((572, 930, -1130), 360);
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
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((16985.2, 206.052, -5782.38), 55, 10, (16923, 960, -4550), 360, "freeze", "red", "normal_0");
thread sr\api\_speedrun::createTeleporter((16994.9, 1680.86, -5782.38), 55, 10, (16923, 960, -4550), 360, "freeze", "red", "normal_0");

thread startdoor();

}

startdoor()
{
door = getent("startdoor","targetname");

wait 0.1;
door delete();

}