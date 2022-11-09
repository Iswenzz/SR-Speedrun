main()
{
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

	visionSetNaked("mp_sr_descent");

	thread secretroomtp();
	thread secrettp_210();
	thread secretfail210();
	//thread secretendroom();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread secretfinish_210();
}


secretroomtp()
{
	trig = getEnt("secretroomtp", "targetname");
	spawn = getEnt("secretroom", "targetname");
    trig sethintString("^1Press ^3&&1 ^1To Enter The Secret Selection!");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls( 1 );
		player setOrigin( spawn.origin );
		player setPlayerangles( spawn.angles );
		player freezeControls( 0 );
		player.secret = 0;
		wait 0.05;
	}
}

secrettp_210()
{
	trig = getEnt("210secrettp", "targetname");
	spawn = getEnt("210secretspawn", "targetname");
	trig setHintString("^1Warning! This Secret is Pretty Hard, Press ^3&&1 ^1If You Wish To Continue!");

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player freezeControls( 1 );
		player setOrigin( spawn.origin );
		player setPlayerangles( spawn.angles );
		player freezeControls( 0 );
      	wait 0.05;
	}
}

secretfail210()
{
	trigger = getEntArray("trig_secretfail", "targetname");


	thread checkpoint1_210();
	thread checkpoint2_210();
	thread checkpoint3_210();
	thread checkpoint4_210();
	thread checkpoint5_210();
	thread checkpoint6_210();

    for(i = 0; i < trigger.size; i++) {
		trigger[i] thread checkpoints_210();
	}
}

checkpoints_210()
{
	target0 = getEnt("210secretspawn", "targetname");
	target1 = getEnt("210check1", "targetname");
	target2 = getEnt("210check2", "targetname");
	target3 = getEnt("210check3", "targetname");
	target4 = getEnt("210check4", "targetname");
	target5 = getEnt("210check5", "targetname");
	target6 = getEnt("210check6", "targetname");

	for(;;)
	{
		self waittill("trigger", player);

		if(player.secret == 0 )
		{
			player freezeControls( 1 );
			player setPlayerAngles( target0.angles );
			player setOrigin( target0.origin );
			player freezeControls( 0 );
		}
		 else if (player.secret == 1 )
        {
			player freezeControls( 1 );
            player setPlayerangles( target1.angles );
            player setOrigin( target1.origin );
			player freezeControls( 0 );
        }
         else if (player.secret == 2 )
        {
			player freezeControls( 1 );
            player setPlayerangles( target2.angles );
            player setOrigin( target2.origin );
			player freezeControls( 0 );
        }
		else if (player.secret == 3 )
		{
			player freezeControls( 1 );
			player setPlayerAngles( target3.angles );
			player setOrigin( target3.origin );
			player freezeControls( 0 );
		}
		else if (player.secret == 4 )
		{
			player freezeControls( 1 );
			player setPlayerAngles( target4.angles );
			player setOrigin( target4.origin );
			player freezeControls( 0 );
		}
		else if (player.secret == 5 )
		{
			player freezeControls( 1 );
			player setPlayerAngles( target5.angles );
			player setOrigin( target5.origin );
			player freezeControls( 0 );
		}
		else if (player.secret == 6 )
		{
			player freezeControls( 1 );
			player setPlayerAngles( target6.angles );
			player setOrigin( target6.origin );
			player freezeControls( 0 );
		}
 	}

}

checkpoint1_210()
{
       trig = getent ("210checkpoint1", "targetname");
       while(true)
    {
       trig waittill("trigger",player);
       if(player.secret == 0 )
       {
        player.secret = 1;
        player iprintln("^1You Have Reached A Checkpoint!");
        wait 0.05;
       }

    }
}


checkpoint2_210()
{
	trig = getent ("210checkpoint2", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.secret == 1 )
		{
			player.secret = 2;
			player iprintln("^1You Have Reached A Checkpoint!");
			wait 0.05;
		}
	}
}

checkpoint3_210()
{
	trig = getent ("210checkpoint3", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.secret == 2 )
 	     {
		    player.secret = 3;
		    player iprintln("^1You Have Reached A Checkpoint!");
	        wait 0.05;

	     }
	}
}

checkpoint4_210()
{
	trig = getent ("210checkpoint4", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.secret == 3 )
		{
			player.secret = 4;
			player iprintln("^1You Have Reached A Checkpoint!");
			wait 0.05;
		}
	}
}

checkpoint5_210()
{
	trig = getent ("210checkpoint5", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.secret == 4 )
		{
			player.secret = 5;
			player iprintln("^1You Have Reached A Checkpoint!");
			wait 0.05;
		}
	}
}

checkpoint6_210()
{
	trig = getent ("210checkpoint6", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.secret == 5 )
		{
			player.secret = 6;
			player iprintln("^1You Have Reached A Checkpoint!");
			wait 0.05;
		}
	}
}

secretfinish_210()
{
	trig = getEnt("secretfinish210", "targetname");

	for(;;)
	{
	trig waittill("trigger",player);
	player thread sr\api\_speedrun::finishWay("secret_0");
	}
}



