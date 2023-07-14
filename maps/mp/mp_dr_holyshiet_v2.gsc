main()
{
    maps\mp\_load::main();
         
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    setdvar("r_specularcolorscale","1");
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((944, 4608, -244), 180);
    thread sr\api\_speedrun::createTeleporter((941.901, 4426.28, -303.875), 60, 100, (-3687, 1584, -259), 180, "freeze", "green", "secret_0");
    thread sr\api\_speedrun::createTeleporter((939.312, 4801.36, -303.875), 60, 100, (-3661, 2357, 172), 180, "freeze", "orange", "secret_1");
    thread sr\api\_speedrun::createEndMap((-3705.02, 1593.36, 112.125), 80, 100, "secret_0");
    thread sr\api\_speedrun::createEndMap((-5250.44, 4433.28, -191.875), 95, 100, "secret_1");

    thread startdoor();

}

startdoor()
{
    b = getent("shiet_sec_bounce","targetname");
    door = getent("shiet_startdoor","targetname");
    trap3a = getent("shiet_trap_3a","targetname");
    trap3b = getent("shiet_trap_3b","targetname");

    door delete();
    b delete();
    trap3a delete();
    trap3b delete();

   
}
