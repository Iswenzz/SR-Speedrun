
 main()
{
thread sr\api\_map::createSpawnOrigin((52.125, 2064, 20.125), 270);

 maps\mp\_load::main();



    game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


    setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );


   thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("190 Secret;210 Secret;");
   thread secret1entrance();
   thread secret2entrance();
   thread secret1fail();
   thread secret1end();
   thread secret2end();

}


secret1entrance()
{
	trig = getEnt("190entrancetrig", "targetname");
	ori = getEnt("190entrance", "targetname");
	trig setHintString("Press ^1&&1 ^7 to enter the 190 secret!");

	for(;;)
	{
		trig waittill("trigger", player);
		if (player.speed == 190)
		{
            player setPlayerAngles(ori.angles);
        player setOrigin(ori.origin);
        player thread sr\api\_speedrun::changeWay("secret_0");
        player.secret1 = 0;
        }
	}
}
secret2entrance()
{
	trig = getEnt("210entrancetrig", "targetname");
	ori = getEnt("210entrance", "targetname");
	trig setHintString("Press ^1&&1 ^7to enter the 210 secret!");

	for(;;)
	{
	trig waittill("trigger", player);
	if (player.speed == 210)
	{
        player setPlayerAngles(ori.angles);
    player setOrigin(ori.origin);
    player thread sr\api\_speedrun::changeWay("secret_1");
    }
	}

}

secret1fail()
{
    trig = getEntArray("secret1_fail", "targetname");

    thread secret1_checkpoint1();
    thread secret1_checkpoint2();
    thread secret1_checkpoint3();

    for(i = 0; i < trig.size; i++) {
	trig[i] thread checkpoints1();
    }

}

checkpoints1()
{
    secret1_check0 = getEnt("190entrance", "targetname");
    secret1_check1 = getEnt("secret_1check1", "targetname");
    secret1_check2 = getEnt("secret_1check2", "targetname");
    secret1_check3 = getEnt("secret_1check3", "targetname");

	 for(;;)
    {
        self waittill("trigger", player);

        if(player.secret1 == 0)
        {
			player setPlayerAngles( secret1_check0.angles );
			player setOrigin( secret1_check0.origin );
            player freezeControls( 1 );
            wait 0.1;
			player freezeControls( 0 );
        }
        else if(player.secret1 == 1)
        {
            player setPLayerAngles( secret1_check1.angles );
            player setOrigin( secret1_check1.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret1 == 2)
        {
            player setPlayerAngles( secret1_check2.angles );
            player setOrigin( secret1_check2.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret1 == 3)
        {
            player setPlayerAngles( secret1_check3.angles );
            player setOrigin( secret1_check3.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
    }
	}
}

secret1_checkpoint1()
{
	 trig = getEnt("secret_1checkpoint1", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret1 == 0)
        {
            player.secret1 = 1;
            player iPrintLn("checkpoint");
            wait 0.05;
        }
    }
}

secret1_checkpoint2()
{
	 trig = getEnt("secret_1checkpoint2", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret1 == 1)
        {
            player.secret1 = 2;
            player iPrintLn("checkpoint");
            wait 0.05;
        }
    }
}

secret1_checkpoint3()
{
	 trig = getEnt("secret_1checkpoint3", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret1 == 2)
        {
            player.secret1 = 3;
            player iPrintLn("checkpoint");
            wait 0.05;
        }
    }
}


secret1end()
{
	trig = getEnt("190endtrig", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

secret2end()
{
	trig = getEnt("210endtrig", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
	    player thread sr\api\_speedrun::finishWay("secret_0");
	}
}




