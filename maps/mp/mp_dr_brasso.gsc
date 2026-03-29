main()
{
    maps\mp\_load::main();

    game["allies"] = "sas";
    game["axis"] = "russian";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    SetDvar("bg_falldamagemaxheight", 99999);
    SetDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((5328, 360, 2785), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");

    thread secret();
    thread teleport1();
    thread credits();
}

secret()
{
	ori_t = getEnt("secretorigin", "targetname");

	thread sr\api\_speedrun::createTeleporter((5186.1, 218.763, 2692.63), 70, 100, ori_t.origin, 0, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createEndMap((3448.67, 5081.3, 222.125), 70, 60, "secret_0");
}

teleport1()
{
    trig = getEnt("tp1trigger", "targetname");
    tele = getEnt("tp1origin", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
    }
}

credits()
{
    while(true)
    {
        wait 10;
        iPrintln("^3Map created by Flub");
        wait 2;
        iPrintln("Special thanks to LEGz criz and Vlad");
        wait 30;
    }
}
