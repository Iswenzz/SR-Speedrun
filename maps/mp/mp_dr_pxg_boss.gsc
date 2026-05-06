main()
{
	maps\mp\_load::main();

    setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

    thread sr\api\_map::createSpawn((176, 336, 76.1), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");

	thread sr\api\_speedrun::createTeleporter((-9.5776, -4591.41, 432.125), 100, 75, (-5.4, -1719, 435), 90, "freeze", "blue");

    sec = getEnt("hard_secret_origin", "targetname");
	thread sr\api\_speedrun::createTeleporter((3.57434, 546.515, 16.125), 75, 75, sec.origin, 180, "freeze", "yellow", "secret_0");
    thread hard_secret_end();
    
	laser = getEnt("laser_model", "targetname");
	laser2 = getEnt("laser_model2", "targetname");
    laser delete();
    laser2 delete();
}

hard_secret_end()
{
    trig = getEnt("hard_secret_end", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}