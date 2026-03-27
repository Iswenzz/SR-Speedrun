main()
{
    maps\mp\_load::main();
    maps\mp\mp_dr_the_end_fx::main();
	setExpFog(10, 6500, 0.05, 0.05, 0.05, 0.0);

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
    setDvar("bg_bobmax", 0);

    thread sr\api\_map::createSpawn((-2272, -149, 76), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");

    thread secret();
}

secret()
{
	ori_t = getEnt("origin_secret", "targetname");

	thread sr\api\_speedrun::createTeleporter((-2170.25, 53.0339, 16.125), 70, 100, ori_t.origin, 0, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createEndMap((5410, -3592, 323), 100, 50, "secret_0");
}
