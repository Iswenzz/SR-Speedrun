//mp_dr_stonerun
//Map Made by Elpredatore		xf: elpredatore
//Scripted by TwiYo				xf: 1buzz
//Created for Braxi's Deathrun mod for CoD4
//ix-treme.com and braxi.org

/////////////////////////////////////////////////////////////////////
//[][][][][][][][]/[]////////////////[] []//[]//////[]///////////////
/////////[]/////////[]//////////////[]///////[]////[]////////////////
/////////[]//////////[]////////////[]///[]////[]//[]///[][][][][][]//
/////////[]///////////[]////[]////[]////[]/////[][]////[]////////[]//
/////////[]////////////[]//[][]//[]/////[]//////[]/////[]////////[]//
/////////[]/////////////[][]//[][]//////[]//////[]/////[][][][][][]//
/////////////////////////////////////////////////////////////////////




main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");

			maps\mp\_load::main();
	// thread ambient();

	thread sr\api\_speedrun::createEndMap((2336, -1354, -196), 200, 150);

	thread sr\api\_speedrun::createTeleporter((3856, -1057, -145), 100, 150,
		(3844, -1297, 284), 270, "freeze");


	precacheItem("ak74u_mp");
	precacheItem("remington700_mp");
	precacheItem("knife_mp");
	precacheItem("deserteagle_mp");
	precacheItem("uzi_mp");
	precacheItem("m4_mp");
	precacheItem("ak47_mp");
	precacheItem("g3_mp");
	precacheItem("m60e4_mp");
	precacheItem("p90_mp");
	precacheItem("m40a3_mp");
	precacheItem("barrett_mp");
	precacheItem("g36c_silencer_mp");
	precacheItem("skorpion_silencer_mp");
	precacheItem("saw_grip_mp");



	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	addTriggerToList("trigger_spin1");
    addTriggerToList("trigger_spin2");
    addTriggerToList("trigger_spin3");
	addTriggerToList("trigger_move1");
	addtriggerTolist("trigger_move2");
	addtriggerTolist("trigger_spike");
	addtriggerTolist("trigger_stangen");

	//Credits
	/* [AUTO DELETE] thread printCredits(); */
	//traps
	thread spin1();
	thread spin2();
	thread move1();
	thread move2();
	thread spin3();
	thread spike();
	thread stangen();
	//elevator
	// thread lift();
	//Finish Teleport
	thread ende();
	thread secret();
	//thread ausgang();
	thread ausgang();
	thread respawn();
	thread respawn2();
	/* [AUTO DELETE] thread secrettrap(); */
	//end rooms
	/* [AUTO DELETE] thread SniperFight(); */
	/* [AUTO DELETE] thread BounceFight(); */
	/* [AUTO DELETE] thread KnifeFight(); */
	/* [AUTO DELETE] thread OldFight(); */
	/* [AUTO DELETE] //bounce room respawn
	thread bouncerspawn1(); */
	/* [AUTO DELETE] thread bouncerspawn2(); */
	/* [AUTO DELETE] thread bouncerspawn3(); */
	/* [AUTO DELETE] thread bouncerspawn4(); */
	/* [AUTO DELETE] thread bouncerspawn5(); */
	/* [AUTO DELETE] thread bouncerspawn6(); */
	/* [AUTO DELETE] //bounce room end teleport
	thread bouncejumper(); */
	/* [AUTO DELETE] thread bounceacti(); */

	}

ambient()
{
AmbientPlay ( "map" );
wait 5;
/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2DJ Antoine - Sky is the Limit^1<<"); */
/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2DJ Antoine - Sky is the Limit^1<<"); */
}



bouncerspawn1()
	{
	trig = getEnt ("fail1_trigger", "targetname");
	target = getEnt ("jumperreset1_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);



		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


bouncerspawn2()
	{
	trig = getent ("fail2_trigger", "targetname");
	target = getEnt ("jumperreset2_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);



		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


bouncerspawn3()
	{
	trig = getent ("fail3_trigger", "targetname");
	target = getEnt ("jumperreset3_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);



		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


bouncerspawn4()
	{
	trig = getent ("fail4_trigger", "targetname");
	target = getEnt ("activatorreset1_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);



		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


bouncerspawn5()
	{
	trig = getent ("fail5_trigger", "targetname");
	target = getEnt ("activatorreset2_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);



		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


bouncerspawn6()
	{
	trig = getent ("fail6_trigger", "targetname");
	target = getEnt ("activatorreset3_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);



		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


                 addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


	spin1()
	{
	trigger = getEnt ("trigger_spin1", "targetname");
	object = getEnt ("spin1", "targetname");

	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */


	while (1)
	{

		object rotateroll (360, 4);
		wait (0.1);

	}
}

	spin2()
	{
	trigger = getEnt ("trigger_spin2", "targetname");
	object = getEnt ("spin2", "targetname");

	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */

	while(1)
	{

		object rotateroll (360, 4);
		wait (0.1);

	}
}


	spin3()
	{
	trigger = getEnt ("trigger_spin3", "targetname");
	object = getEnt ("spin3", "targetname");
	Standbein = getEnt ("stange", "targetname");


	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */

	while(1)
	{
		Standbein enablelinkto ();
		Standbein linkto (object);
		object rotateYaw (360, 4.5);
		wait (0.1);
	}
}


	move1()
	{
	trigger = getEnt ("trigger_move1", "targetname");
	object = getEnt ("move1", "targetname");
	killtrigger = getent ("killtrig1" , "targetname");

	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */

	{

		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object moveY(400, 0.5);
		object waittill("movedone");
		wait(3);
		object moveY(-400, 5);
		object waittill("movedone");
		wait(1);
		}
}


	move2()
	{
	trigger = getEnt ("trigger_move2", "targetname");
	object = getEnt ("move2", "targetname");
	killtrigger = getent ("killtrig2" , "targetname");

	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */

	{

		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object moveY(400, 0.5);
		object waittill("movedone");
		wait(3);
		object moveY(-400, 5);
		object waittill("movedone");
		wait(1);
		}
}


	spike()
	{
	trigger = getEnt ("trigger_spike", "targetname");
	object = getent ("spike", "targetname");
	killtrigger = getent ("killtrig3", "targetname");

	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */

	{

		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object moveZ (240, 1);
		object waittill ("movedone");
		wait(3.5);
		object moveZ (-240, 3);
		object waittill ("movedone");
		wait(1);
		}
	}



stangen()
{
	trigger = getent ("trigger_stangen", "targetname");
	object1 = getent("stange1", "targetname");

	trigger waittill ("trigger", Player);
	trigger delete();

	/* [AUTO DELETE] Player iPrintLnBold("^1Activated!"); */

	while(1)
	{

	thread stange2();
	thread stange3();
	thread stange4();
	thread stange5();
	thread stange6();

	object1 moveX(60, 1);
	object1 waittill("movedone");
	object1 moveX(-60, 1);
	object1 waittill("movedone");
		}
}


stange2()
{
	object2 = getent("stange2", "targetname");

	object2 moveX(-60, 1);
	object2 waittill("movedone");
	object2 moveX(60, 1);
	object2 waittill("movedone");
	}


stange3()
{
	object3 = getent("stange3", "targetname");

	object3 moveX(60, 1);
	object3 waittill("movedone");
	object3 moveX(-60, 1);
	object3 waittill("movedone");
	}


stange4()
{
	object4 = getent("stange4", "targetname");

	object4 moveX(-60, 1);
	object4 waittill("movedone");
	object4 moveX(60, 1);
	object4 waittill("movedone");
	}


stange5()
{
	object5 = getent("stange5", "targetname");

	object5 moveX(60, 1);
	object5 waittill("movedone");
	object5 moveX(-60, 1);
	object5 waittill("movedone");
	}


stange6()
{
	object6 = getent("stange6", "targetname");

	object6 moveX(-60, 1);
	object6 waittill("movedone");
	object6 moveX(60, 1);
	object6 waittill("movedone");
	}


secrettrap()
{
	level endon("trigger");

	object1 = getent("secretstangen1", "targetname");

	while(1)
	{
	thread secrettrap2();

	object1 moveZ (-40, 3);
	object1 waittill("movedone");
	object1 moveZ (40, 3);
	object1 waittill("movedone");
	}
}


secrettrap2()
{
	level endon("trigger");

	object2 = getent("secretstangen2", "targetname");


	object2 moveZ (40, 3);
	object2 waittill("movedone");
	object2 moveZ (-40, 3);
	object2 waittill("movedone");

}


	lift()
	{
	trigger = getEnt ("trigger_lift", "targetname");
	object = getEnt ("lift", "targetname");

	trigger waittill ("trigger", Player);

	while(1)
	{

	object moveZ (430, 1.5);
	object waittill ("movedone");
	wait(2);
	object moveZ(-430, 1);
	object waittill ("movedone");
	wait(2);
	}
}


	secret()
	{
	trigger = getEnt ("secret_trigger", "targetname");
	target = getEnt ("secret_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		/* [AUTO DELETE] player iprintlnbold ("Welcome to the Secret Room, good luck!"); */

		player SetOrigin(target.origin);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player SetPlayerAngles( target.angles );
	}
}



	respawn()
	{
	trigger = getEnt ("respawn_trigger", "targetname");
	target = getEnt ("respawn_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		/* [AUTO DELETE] player iprintlnbold ("You failed, Try it again!"); */
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


	respawn2()
	{
	trigger = getEnt ("respawn2_trigger", "targetname");
	target = getEnt ("respawn2_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		/* [AUTO DELETE] player iprintlnbold ("You failed, Try it again!"); */
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


ausgang()
{
	trigger = getEnt ("ausgang_trigger", "targetname");
	target = getEnt ("ausgang_target", "targetname");
	for(;;)
	{
		trigger waittill ("trigger", user);
		user thread sr\api\_speedrun::finishWay("secret_0");
		/* [AUTO DELETE] iPrintlnBold( " ^6" + user.name + " ^5 HAS FINISHED THE SECRET ROOM^1!" ); */
		// user SetOrigin(target.origin);
		// user SetPlayerAngles( target.angles );
		/* [AUTO DELETE] user braxi\_rank::giveRankXp( "", 100); */
	}
}




	ende()
{
	trigger = getEnt ("ende_trigger", "targetname");
	target = getEnt ("ende_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		/* [AUTO DELETE] player iprintlnbold ("Finish!"); */
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}




SniperFight()
{

    level.sniper_trigger = getEnt( "sniper_trigger", "targetname");
    tele_activator = getEnt( "sniper_activator_teleport", "targetname" );
    tele_jumper = getEnt( "sniper_jumper_teleport", "targetname" );
    music_changed = false;
    level.finalJumper = undefined;


    while( 1 )
    {

		level.sniper_trigger waittill( "trigger", player );
        if( !isDefined( level.sniper_trigger ) )
            return;

		if(level.firstenter==true)
		{
		level.bounce_trigger delete();
		level.old_jumper_trigger delete();
		level.knife_trigger delete();
		level.firstenter=false;
		}





       if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();

        level.finalJumper finalRoom( tele_jumper, "remington700_mp", 100);
        level.activ finalRoom( tele_activator, "remington700_mp", 100);
		if (!music_changed)
		{
			music_changed = true;
			thread endMusic();
		}
		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5 HAS ENTERED THE SNIPER ROOM^1!" ); */
    }

}


endMusic()
{
	AmbientStop(1);
	wait 0.5;
	/* [AUTO DELETE] AmbientPlay("sniper"); */
	wait (5);
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2StreetFighter^1<<"); */
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2StreetFighter^1<<"); */
}



finalMonitor()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}


finalRoom( tp, weap, health )
{

    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );



    /* [AUTO DELETE] self TakeAllWeapons(); */
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */
}



BounceFight()
{

    level.bounce_trigger = getEnt( "bounce_trigger", "targetname");
    tele_activator = getEnt( "bounce_activator_teleport", "targetname" );
    tele_jumper = getEnt( "bounce_jumper_teleport", "targetname" );
    music_changed = false;
    level.finalJumper = undefined;


    while( 1 )
    {
		level.bounce_trigger waittill( "trigger", player );
        if( !isDefined( level.bounce_trigger ) )
            return;

		if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.old_jumper_trigger delete();
		level.knife_trigger delete();
		level.firstenter=false;
		}



        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor1();

		level.finalJumper finalRoom( tele_jumper, "knife_mp");
		level.activ finalRoom( tele_activator, "knife_mp");
		if (!music_changed)
		{
			music_changed = true;
			thread endMusic1();
		}
		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5 HAS ENTERED THE BOUNCE ROOM^1!" ); */
    }

}


endMusic1()
{
	AmbientStop(1);
	wait 0.5;
	/* [AUTO DELETE] AmbientPlay("bounce"); */
	wait (5);
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2Dubstep Android Porn^1<<"); */
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2Dubstep Android Porn^1<<"); */
}



finalMonitor1()
{
    self endon( "disconnect" );
    self thread monitorDisconnect1();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


monitorDisconnect1()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}


finalRoom1( tp, weap, health )
{

    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );



    /* [AUTO DELETE] self TakeAllWeapons(); */
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */
}





	bouncejumper()
{
	trigger = getEnt ("bouncejumper_trigger", "targetname");
	target = getEnt ("bouncejumper_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		/* [AUTO DELETE] player iprintlnbold ("FIGHT!"); */
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );

		/* [AUTO DELETE] player giveWeapon("remington700_mp"); */
		wait(0.05);
		/* [AUTO DELETE] player giveMaxAmmo("remington700_mp"); */
		/* [AUTO DELETE] player switchToWeapon("remington700_mp"); */
	}
}



	bounceacti()
{
	trigger = getEnt ("bounceacti_trigger", "targetname");
	target = getEnt ("bounceacti_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		/* [AUTO DELETE] player iprintlnbold ("FIGHT!"); */
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );

		/* [AUTO DELETE] player giveWeapon("remington700_mp"); */
		wait(0.05);
		/* [AUTO DELETE] player giveMaxAmmo("remington700_mp"); */
		/* [AUTO DELETE] player switchToWeapon("remington700_mp"); */
	}
}



	KnifeFight()
{

    level.knife_trigger = getEnt( "knife_trigger", "targetname");
    tele_activator = getEnt( "knife_activator_teleport", "targetname" );
    tele_jumper = getEnt( "knife_jumper_teleport", "targetname" );
    music_changed = false;
    level.finalJumper = undefined;


    while( 1 )
    {

		level.knife_trigger waittill( "trigger", player );
        if( !isDefined( level.knife_trigger ) )
            return;

		if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.old_jumper_trigger delete();
		level.bounce_trigger delete();
		level.firstenter=false;
		}





        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor2();

        level.finalJumper finalRoom( tele_jumper, "tomahawk_mp");
        level.activ finalRoom( tele_activator, "tomahawk_mp");
		if (!music_changed)
		{
			music_changed = true;
			thread endMusic2();
		}
		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5 HAS ENTERED THE KNIFE ROOM^1!" ); */
    }

}


endMusic2()
{
	AmbientStop(1);
	wait 0.5;
	/* [AUTO DELETE] AmbientPlay("knife"); */
	wait (5);
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2Tonic feat. Tarantula Man - Big Fat Original Mix^1<<"); */
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2Tonic feat. Tarantula Man - Big Fat Original Mix^1<<"); */
}



finalMonitor2()
{
    self endon( "disconnect" );
    self thread monitorDisconnect2();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


monitorDisconnect2()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}


finalRoom2( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );

    /* [AUTO DELETE] self TakeAllWeapons(); */
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */
}



	OldFight()
{

   	level.old_jumper_trigger = getEnt( "old_jumper_trigger", "targetname");
	target = getEnt ("old_jumper_target", "targetname");
	music_changed = false;
	for(;;)
	{
	while( 1 )
    {

		level.old_jumper_trigger waittill( "trigger", player );
        if( !isDefined( level.old_jumper_trigger ) )
            return;

		if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.knife_trigger delete();
		level.bounce_trigger delete();
		level.firstenter=false;
		}



	if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;


		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5 HAS OPEN THE OLD WAY^1!" ); */
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		if (!music_changed)
		{
			music_changed = true;
			thread endMusic3();
			}
		}
	}
}


endMusic3()
{
	AmbientStop(1);
	wait 0.5;
	/* [AUTO DELETE] AmbientPlay("old"); */
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2JamerikanBeatz^1<<"); */
	/* [AUTO DELETE] iprintln("^1>>^4Now Playing: ^2JamerikanBeatz^1<<"); */
}



 printCredits()
    {
            if( isDefined( self.logoText ) )
                    self.logoText destroy();

            self.logoText = newHudElem();
            self.logoText.y = 10;
            self.logoText.alignX = "center";
            self.logoText.alignY = "middle";
            self.logoText.horzAlign = "center_safearea";

            self.logoText.alpha = 0;
            self.logoText.sort = -3;
            self.logoText.fontScale = 1.6;
            self.logoText.archieved = true;

            for(;;)
            {
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1Map created by Elpredatore^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0--^1xf: elpredatore^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1Scripted by TwiYo^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1xf: 1buzzz^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
		}

	}
