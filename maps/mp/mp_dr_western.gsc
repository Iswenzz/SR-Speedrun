main()
{
    maps\mp\_load::main(); 

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";


    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-2690, -1566, 156), 360);
    thread sr\api\_speedrun::createEndMap((-2346.98, 800.228, 96.125), 110, 100);
    thread sr\api\_speedrun::createTeleporter((-2690.01, -1448.68, 96.0081), 60, 100, (-1591, -1049, -594), 90, "freeze", "yellow", "secret_0");

    thread secret_0_end();

   
}


secret_0_end()
{
    trig = getEnt("trigger_secret2", "targetname");
    s2tele = getEnt("jumper2_teleport", "targetname");

    for(;;)
    {
        trig waittill("trigger", player );

        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}