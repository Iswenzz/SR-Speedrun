////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     $$$$$                           /$$   /$$ /$$           /$$ /$$   /$$                           /$$                                                   /$$  //
//   /$$__  $$                        | $$  /$$/| $$          |__/| $$$ | $$                          |__/                                                  | $$  //
//  | $$  \__/  /$$$$$$               | $$ /$$/ | $$  /$$$$$$  /$$| $$$$| $$        /$$$$$$   /$$$$$$  /$$  /$$$$$$$       /$$$$$$/$$$$   /$$$$$$   /$$$$$$ | $$  //
//  |  $$$$$$  /$$__  $$ /$$$$$$      | $$$$$/  | $$ /$$__  $$| $$| $$ $$ $$       /$$__  $$ /$$__  $$| $$ /$$_____/      | $$_  $$_  $$ |____  $$ /$$__  $$| $$  //
//  \____  $$| $$  \__/|______/      | $$  $$  | $$| $$$$$$$$| $$| $$  $$$$      | $$$$$$$$| $$  \ $$| $$| $$            | $$ \ $$ \ $$  /$$$$$$$| $$  \ $$|__/   // 
//   /$$  \ $$| $$                    | $$\  $$ | $$| $$_____/| $$| $$\  $$$      | $$_____/| $$  | $$| $$| $$            | $$ | $$ | $$ /$$__  $$| $$  | $$      //
//  |  $$$$$$/| $$                    | $$ \  $$| $$|  $$$$$$$| $$| $$ \  $$      |  $$$$$$$| $$$$$$$/| $$|  $$$$$$$      | $$ | $$ | $$|  $$$$$$$| $$$$$$$/ /$$  //
//   \______/ |__/                    |__/  \__/|__/ \_______/|__/|__/  \__/       \_______/| $$____/ |__/ \_______/      |__/ |__/ |__/ \_______/| $$____/ |__/  //
//                                                                                        | $$                                                  | $$              //
//                                                                                        | $$                                                  | $$              //
//                                                                                        |__/                                                  |__/              //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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

	preCacheItem("rpg_mp");
    
	visionSetNaked("mp_sr_pure_distance");

	ambientPlay("ambient");
    
    thread rpgtrigger();
	thread fail();
	thread secrettp();
	thread secretfinish();
	//thread sr\api\_speedrun::createNormalWays("Normal Way");
	//thread sr\api\_speedrun::createSecretWays("Secret Way");

	
}

rpgtrigger()
{
	trig = getEnt("rpg_trig", "targetname");
	while( 1 )
	{
		trig waittill("trigger", player);
		player giveWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		player switchToWeapon("rpg_mp");
    }
}

secrettp()
{
	trig = getEnt("secret_trigger", "targetname");
	spawn = getEnt("secret_spawn", "targetname");
	trig setHintString("^3What is this random door doing here!?!?!");

	for(;;)
	{
		trig waittill("trigger",player);
		//player thread sr\api\_speedrun::changeWay("secret_0");
		player setPlayerAngles( spawn.angles );
		player setOrigin( spawn.origin );
		player iPrintLnBold("^3You Entered The Secret!");
		player freezeControls( 1 );
		wait 0.05;
		player freezeControls( 0 );
	}
}

secretfinish()
{
	trig = getEnt("secret_finish", "targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		//player thread sr\api\_speedrun::finishWay("secret_0");
		player iPrintLnBold("^3Nice One");

	}
}


fail()
{
	trigger = getEntArray("fail", "targetname");

	thread checkpoint1();
	thread checkpoint2();
	thread checkpoint3();
	thread checkpoint4();
	thread checkpoint5();
	thread checkpoint6();
	thread checkpoint7();
	thread checkpoint8();
	thread checkpoint9();
	thread checkpoint10();
	thread checkpoint11();
	thread checkpoint12();
	thread checkpoint13();
	thread checkpoint14();
	thread checkpoint15();
	thread checkpoint16();
	thread checkpoint17();
	thread checkpoint18();
	thread checkpoint19();
	thread checkpoint20();

	for(i = 0; i < trigger.size; i++) {
	trigger[i] thread checkpoints();
	}

}


 checkpoints()
 {
	target0 = getEnt("check1", "targetname");
	target1 = getEnt("check2", "targetname");
    target2 = getEnt("check3", "targetname");
	target3 = getEnt("check4", "targetname");
	target4 = getEnt("check5", "targetname");
	target5 = getEnt("check6", "targetname");
	target6 = getEnt("check7", "targetname");
	target7 = getEnt("check8", "targetname");
	target8 = getEnt("check9", "targetname");
	target9 = getEnt("check10", "targetname");
	target10 = getEnt("check11", "targetname");
	target11 = getEnt("check12", "targetname");
	target12 = getEnt("check13", "targetname");
	target13 = getEnt("check14", "targetname");
	target14 = getEnt("check15", "targetname");
	target15 = getEnt("check16", "targetname");
	target16 = getEnt("check17", "targetname");
	target17 = getEnt("check18", "targetname");
	target18 = getEnt("check19", "targetname");
	target19 = getEnt("check20", "targetname");
	target20 = getEnt("check21", "targetname");

	for(;;)
	{
		self waittill("trigger", player);

		if(player.cp == 0 )
		{
			player setPlayerAngles( target0.angles );
			player setOrigin( target0.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		 else if (player.cp == 1 )
        {
            player setPlayerangles( target1.angles );
            player setOrigin( target1.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
        }
         else if (player.cp == 2 )
        {
            player setPlayerangles( target2.angles );
            player setOrigin( target2.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
        }
		else if (player.cp == 3 )
		{
			player setPlayerAngles( target3.angles );
			player setOrigin( target3.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 4 )
		{
			player setPlayerAngles( target4.angles );
			player setOrigin( target4.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 5 )
		{
			player setPlayerAngles( target5.angles );
			player setOrigin( target5.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 6 )
		{
			player setPlayerAngles( target6.angles );
			player setOrigin( target6.origin );	
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 7 )
		{
			player setPlayerAngles( target7.angles );
			player setOrigin( target7.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 8 )
		{
			player setPlayerAngles( target8.angles );
			player setOrigin( target8.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 9 )
		{
			player setPlayerAngles( target9.angles );
			player setOrigin( target9.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 10 )
		{
			player setPlayerAngles( target10.angles );
			player setOrigin( target10.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 11 )
		{
			player setPlayerAngles( target11.angles );
			player setOrigin( target11.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 12 )
		{
			player setPlayerAngles( target12.angles );
			player setOrigin( target12.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 13 )
		{
			player setPlayerAngles( target13.angles );
			player setOrigin( target13.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 14 )
		{
			player setPlayerAngles( target14.angles );
			player setOrigin( target14.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
			
		}
		else if (player.cp == 15 )
		{
			player setPlayerAngles( target15.angles );
			player setOrigin( target15.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 16 )
		{
			player setPlayerAngles( target16.angles );
			player setOrigin( target16.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 17 )
		{
			player setPlayerAngles( target17.angles );
			player setOrigin ( target17.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 18 )
		{
			player setPlayerAngles( target18.angles );
			player setOrigin( target18.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 19 )
		{
			player setPlayerAngles( target19.angles );
			player setOrigin( target19.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
		else if (player.cp == 20 )
		{
			player setPlayerAngles( target20.angles );
			player setOrigin( target20.origin );
			player freezeControls( 1 );
			wait 0.05;
			player freezeControls( 0 );
		}
	
	 }

 }


checkpoint1()
{
	   trig = getent ("checkpoint1", "targetname");
       while(true)
    {
       trig waittill("trigger",player);
       if(player.cp == 0 )
       {
        player.cp = 1;
        player iprintln("^1You Have Reached A Checkpoint!");
        wait 0.05;
       }

    }
}

checkpoint2()
{
	trig = getent ("checkpoint2", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 1 )
		{
		player.cp = 2;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint3()
{
	trig = getent ("checkpoint3", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 2 )
		{
		player.cp = 3;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint4()
{
	trig = getent ("checkpoint4", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 3 )
		{
		player.cp = 4;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint5()
{
	trig = getent ("checkpoint5", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 4 )
		{
		player.cp = 5;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint6()
{
	trig = getent ("checkpoint6", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 5 )
		{
		player.cp = 6;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint7()
{
	trig = getent ("checkpoint7", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 6 )
		{
		player.cp = 7;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint8()
{
	trig = getent ("checkpoint8", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 7 )
		{
		player.cp = 8;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint9()
{
	trig = getent ("checkpoint9", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 8 )
		{
		player.cp = 9;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint10()
{
	trig = getent ("checkpoint10", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 9 )
		{
		player.cp = 10;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint11()
{
	trig = getent ("checkpoint11", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 10 )
		{
		player.cp = 11;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint12()
{
	trig = getent ("checkpoint12", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 11 )
		{
		player.cp = 12;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint13()
{
	trig = getent ("checkpoint13", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 12 )
		{
		player.cp = 13;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint14()
{
	trig = getent ("checkpoint14", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 13 )
		{
		player.cp = 14;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}

checkpoint15()
{
	trig = getent ("checkpoint15", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 14 )
		{
		player.cp = 15;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}


checkpoint16()
{
	trig = getent ("checkpoint16", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 15 )
		{
		player.cp = 16;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}


checkpoint17()
{
	trig = getent ("checkpoint17", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 16 )
		{
		player.cp = 17;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}


checkpoint18()
{
	trig = getent ("checkpoint18", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 17 )
		{
		player.cp = 18;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}


checkpoint19()
{
	trig = getent ("checkpoint19", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 18 )
		{
		player.cp = 19;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}


checkpoint20()
{
	trig = getent ("checkpoint20", "targetname");
	while(true)
	{
		trig waittill("trigger",player);
		if(player.cp == 19 )
		{
		player.cp = 20;
		player iprintln("^1You Have Reached A Checkpoint!");
		wait 0.05;
		}
	}
}






