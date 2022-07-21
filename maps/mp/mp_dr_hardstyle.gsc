main()
{
thread sr\api\_map::createSpawnOrigin((193, -1, 16), 360);

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

thread sr\api\_speedrun::createTeleporter((209.977, 160.844, 16.125), 65, 30, (3509, -2937, 656), 91, "freeze", "red", "secret_0");
thread sr\api\_speedrun::createEndMap((8112.65, -220.956, -431.875), 85, 20, "normal_1");
thread sr\api\_speedrun::createEndMap((2038.18, -2338.81, 64.125), 125, 20, "secret_0");
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");

thread startdoor();

}

startdoor()
{
door = getent("door", "targetname");

wait 0.1;
door delete();
}
