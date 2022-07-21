main()
{
thread sr\api\_map::createSpawnOrigin((-222, 2467, -70), 270);
    maps\mp\_load::main();
	maps\mp\_teleport::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

        thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((258.701, 2385.41, -69.875), 60, 35, (-2007, 2216, -577), 270, "freeze", "blue", "secret_0");
    thread sr\api\_speedrun::createEndMap((3967.51, -8678.48, -2664.88), 150, 50, "normal_0");
    thread sr\api\_speedrun::createEndMap((-3734.73, 1980.81, -473.875), 120, 35, "secret_0");

    thread startdoor();
	thread lift();
}

startdoor()
{
door=getent("startdoor","targetname");
enter=getentArray("enter","targetname");

wait 0.1;
door delete();
enter[0] delete();
enter[1] delete();
}

lift()
{
object1 = getent("lift","targetname");

wait 0.1;
object1 movez(-2556, 0.1);

}