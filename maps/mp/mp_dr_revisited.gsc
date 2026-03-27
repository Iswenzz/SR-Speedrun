main()
{
    maps\mp\_load::main();
    maps\mp\mp_dr_revisited_fx::main();
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

    thread sr\api\_map::createSpawn((16, 16, 76), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

    thread tp1();
    thread tp2();
}

tp1()
{
    trig = getEnt("trigger_tp1", "targetname");
    tele1 = getEnt("origin_tp1", "targetname");

    for (;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele1.origin);
        player setPlayerAngles(tele1.angles);
    }
}

tp2()
{
    trig = getEnt("trigger_tp2", "targetname");
    tele1 = getEnt("origin_tp2", "targetname");

    for (;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele1.origin);
        player setPlayerAngles(tele1.angles);
    }
}