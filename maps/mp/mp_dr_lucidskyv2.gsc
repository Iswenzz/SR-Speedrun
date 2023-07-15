main() {
	thread sr\api\_defrag::weapons("");

	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";


    setdvar("bg_fallDamageMaxHeight","5000000");
    setdvar("bg_fallDamageMinHeight","3000000");

	preCacheShader( "material,mtl_space_robot_kyle" );
	preCacheModel( "space_robot_kyle" );
    preCacheItem( "bloodhound_mp" );
    preCacheItem( "m40a3_mp" );
    preCacheItem( "remington700_mp" );

    thread sr\api\_map::createSpawn((-74,-9,60),360);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((452.335, 208.407, 0.125), 80, 80, (4071, 1945, 412), 134, "freeze", "blue", "secret_0");

    // Other
    //thread credits();
    //thread music();
    //thread annoy_light();

    // VIP
    //thread vip();

    // Secret
    // thread secret_activate();
    //thread secret_fail();
    thread secret_finish();
    // thread secret_check_1();
    // thread secret_check_2();
    // thread secret_check_3();
    // thread secret_check_5();
    // thread secret_check_6();
    // thread secret_check_7();
    // thread secret_check_8();

    // Misc
    // thread mover();

    // Teleports
    //thread acti_tele_1();
    //thread acti_tele_2();
    //thread acti_tele_3();
    //thread acti_tele_4();

    thread spawndoor();
    // thread trap1();
    // thread trap2();
    thread trap3();
    // thread trap4();
    // thread trap5();
    // thread trap6();
    thread trap7();

    // End Rooms
    //thread old();
    //thread knife();
    //thread revolver();
    //thread bounce();
    //thread bounce_weap();
    //thread bounce_fail();

}

credits() {
    while(1) {
        wait 7;
        iprintLn( "^7Mapped by ^8Mist" );
        wait 7;
        iprintLn( "^7Scripted by ^8Mist ^7& ^8Jay Creations" );
        wait 7;
        iprintLn( "^7Visit: ^8pxg^7.^8gg" ); // change to your community name
        wait 7;
        iprintLn( "^7Discord: ^8Mist#0001" );
    }
}

music() {

    level waittill( "round_started" );
    wait 4;

	songs = [];
	songs[songs.size] = "song1";
	songs[songs.size] = "song2";
	songs[songs.size] = "song3";

	selected = songs[ Randomint( songs.size ) ];
	AmbientPlay( selected );
}

annoy_light() {

    trig = getEnt( "trig_annoy_light", "targetname" );

    trig waittill( "trigger", player );

    ambientPlay( "just_to_annoy_light" );
    trig delete();
}

vip() {
	level waittill( "round_started" );
	wait 3;

	players = GetEntArray("player", "classname");
	for(i=0;i<players.size;i++) {
		Guid = getSubStr(players[i] getGuid(),24,32);
		if( (Guid == "4021c83b" || Guid == "65586cbf") || (Guid == "" || Guid == "") && players[i].pers["team"] == "allies" ) {
			players[i] GiveWeapon( "bloodhound_mp" );
			players[i] GiveMaxAmmo( "bloodhound_mp" );
			wait .05;
			players[i] SwitchToWeapon( "bloodhound_mp" );
			players[i] iPrintlnBold( "^7Grats on ^8VIP " + players[i].name );
			wait 1;
			players[i] endon( "disconnect" );
			players[i] detachAll();
         		players[i] setModel( "space_robot_kyle" );
			players[i] iprintLnBold("^8You ^7are now ^8Space Robot Kyle ^7& ^7recieved a ^8Bloodhound" );

		}
	}
}

secret_activate() {
    trig = getEnt( "trig_secret_activate", "targetname" );
    bounce_thing = getEnt( "bounce_thing", "targetname" );

    trig SetHintString( "^8?" );
    trig waittill( "trigger", player );
    trig delete();
    bounce_thing delete();

    iPrintLnBold( "^8Something ^7has happened..." );
    thread secret_step2();

}

secret_step2() {
    trig2 = getEnt( "trig_secret_enter", "targetname" );
    origin_enter = getEnt( "origin_secret_enter", "targetname" );

    for( ;; ) {
        trig2 waittill( "trigger", player );
        player.icheckpointid = 0;
        player freezeControls( 1 );
        player setOrigin( origin_enter.origin );
        player setPlayerAngles( origin_enter.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

secret_fail() {
	trigger = getEnt( "trig_secret_fail", "targetname" );
	dest = getEnt( "origin_secret_enter", "targetname" );
	check1 = getEnt( "origin_secret_check1", "targetname" );
	check2 = getEnt( "origin_secret_check2", "targetname" );
	check3 = getEnt( "origin_secret_check3", "targetname" );
	check5 = getEnt( "origin_secret_check5", "targetname" );
	check6 = getEnt( "origin_secret_check6", "targetname" );
	check7 = getEnt( "origin_secret_check7", "targetname" );
	check8 = getEnt( "origin_secret_check8", "targetname" );

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (isDefined(player.icheckpointid))
		{
			if (player.icheckpointid == 0)
			{
				player setOrigin( dest.origin );
				player setplayerangles( dest.angles );
			}
			if (player.icheckpointid == 1)
			{
				player setOrigin( check1.origin );
				player setplayerangles( check1.angles );
			}
			if (player.icheckpointid == 2)
			{
				player setOrigin( check2.origin );
				player setplayerangles( check2.angles );
			}
			if (player.icheckpointid == 3)
			{
				player setOrigin( check3.origin );
				player setplayerangles( check3.angles );
			}
			if (player.icheckpointid == 5)
			{
				player setOrigin( check5.origin );
				player setplayerangles( check5.angles );
			}
			if (player.icheckpointid == 6)
			{
				player setOrigin( check6.origin );
				player setplayerangles( check6.angles );
			}
			if (player.icheckpointid == 7)
			{
				player setOrigin( check7.origin );
				player setplayerangles( check7.angles );
			}
			if (player.icheckpointid == 8)
			{
				player setOrigin( check8.origin );
				player setplayerangles( check8.angles );
			}
		}
    }
}

secret_check_0()
{
	trigger = getEnt("trig_secret_check0","targetname");

	trigger waittill ( "trigger", player );
	player iPrintln( "^7Entered ^8Secret" );

	while(1)
	{
        trigger waittill ( "trigger", player );
		if (player.icheckpointid == 0)
		{
			player.icheckpointid = 0;
		}
	}
}

secret_check_1()
{
	trigger = getEnt("trig_secret_check1","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 1)
		{
			player.icheckpointid = 1;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_check_2()
{
	trigger = getEnt("trig_secret_check2","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 2)
		{
			player.icheckpointid = 2;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_check_3()
{
	trigger = getEnt("trig_secret_check3","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 3)
		{
			player.icheckpointid = 3;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_check_5()
{
	trigger = getEnt("trig_secret_check5","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 5)
		{
			player.icheckpointid = 5;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_check_6()
{
	trigger = getEnt("trig_secret_check6","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 6)
		{
			player.icheckpointid = 6;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_check_7()
{
	trigger = getEnt("trig_secret_check7","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 7)
		{
			player.icheckpointid = 7;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_check_8()
{
	trigger = getEnt("trig_secret_check8","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 8)
		{
			player.icheckpointid = 8;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

secret_finish() {
    trig = getEnt( "trig_secret_finish", "targetname" );
    origin_finish = getEnt( "origin_secret_finish", "targetname" );

    while( 1 ) {
        trig waittill("trigger", player);
        player SetPlayerAngles( origin_finish.angles );
        player setOrigin( origin_finish.origin );
        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}

mover() {
    trig = getEnt( "trig_moving_plat", "targetname" );
    plat = getEnt( "moving_plat", "targetname" );

    trig waittill( "trigger", player );

    while( 1 ) {
        plat moveX( 384, 2, 1, 1 );
        wait 2;
        plat moveY( -194, 2, 1, 1 );
        wait 2;
        plat moveY( 194, 2, 1, 1 );
        wait 2;
        plat moveX( -384, 2, 1, 1 );
        wait 2;
    }
}

acti_tele_1() {
    trig = getEnt( "trig_acti_tele1", "targetname" );
    org = getEnt( "origin_acti_tele1", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_2() {
    trig = getEnt( "trig_acti_tele2", "targetname" );
    org = getEnt( "origin_acti_tele2", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_3() {
    trig = getEnt( "trig_acti_tele3", "targetname" );
    org = getEnt( "origin_acti_tele3", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_4() {
    trig = getEnt( "trig_acti_tele4", "targetname" );
    org = getEnt( "origin_acti_tele4", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

spawndoor()
{
door = getEnt( "startdoor", "targetname" );

wait 0.1;
door delete();
}

trap1() {
    trig = getEnt( "trap1_trig", "targetname" );
    bounce1 = getEnt( "trap1_1", "targetname" );
    bounce2 = getEnt( "trap1_2", "targetname" );
    bounce3 = getEnt( "trap1_3", "targetname" );

    trig SetHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig SetHintString( "^8Activated" );

    bounce1 hide();
    bounce2 hide();
    bounce3 hide();
    bounce1 notSolid();
    bounce2 notSolid();
    bounce3 notSolid();
    wait 5;

    while( 1 ) {
        bounce1 hide();
        bounce1 notSolid();
        bounce2 show();
        bounce2 solid();
        bounce3 show();
        bounce3 solid();
        wait 3;
        bounce1 show();
        bounce1 solid();
        bounce2 hide();
        bounce2 notSolid();
        bounce3 show();
        bounce3 solid();
        wait 3;
        bounce1 show();
        bounce1 solid();
        bounce2 show();
        bounce2 solid();
        bounce3 hide();
        bounce3 notSolid();
        wait 3;
    }
}

trap2() {
    trig = getEnt( "trap2_trig", "targetname" );
    wood1 = getEnt( "trap2_1", "targetname" );
    wood2 = getEnt( "trap2_2", "targetname" );

    trig SetHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig SetHintString( "^8Activated" );

    while( 1 ) {
        wood1 moveZ( 120, 3, 1, 1 );
        wood2 moveZ( -120, 3, 1, 1 );
        wait 3;
        wood1 moveZ( -120, 3, 1, 1 );
        wood2 moveZ( 120, 3, 1, 1 );
        wait 3;
    }
}

trap3()
{
c3 = getEnt( "trap3_3", "targetname" );

wait 0.1;
c3 moveX(900,0.1);


}

trap4() {
    trig = getEnt( "trap4_trig", "targetname" );
    spin1 = getEnt( "trap4_1", "targetname" );
    spin2 = getEnt( "trap4_2", "targetname" );
    spin3 = getEnt( "trap4_3", "targetname" );
    spin4 = getEnt( "trap4_4", "targetname" );

    trig SetHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig SetHintString( "^8Activated" );

    while( 1 ) {
        spin1 rotateYaw( 360, 3, 1, 1 );
        wait 1;
        spin2 rotateYaw( -360, 3, 1, 1 );
        wait 1;
        spin3 rotateYaw( 360, 3, 1, 1 );
        wait 1;
        spin4 rotateYaw( -360, 3, 1, 1 );
        wait 3;
    }
}

trap5() {
    trig = getEnt( "trap5_trig", "targetname" );
    plat1 = getEnt( "trap5_1", "targetname" );
    plat2 = getEnt( "trap5_2", "targetname" );
    plat3 = getEnt( "trap5_3", "targetname" );
    plat4 = getEnt( "trap5_4", "targetname" );
    plat5 = getEnt( "trap5_5", "targetname" );

    trig SetHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig SetHintString( "^8Activated" );

    while( 1 ) {
        plat1 moveZ( -300, 3, 1, 1 );
        wait 1;
        plat2 moveZ( -300, 3, 1, 1 );
        wait 1;
        plat3 moveZ( -300, 3, 1, 1 );
        wait 1;
        plat4 moveZ( -300, 3, 1, 1 );
        wait 1;
        plat5 moveZ( -300, 3, 1, 1 );
        wait 4;
        plat1 moveZ( 300, 3, 1, 1 );
        plat2 moveZ( 300, 3, 1, 1 );
        plat3 moveZ( 300, 3, 1, 1 );
        plat4 moveZ( 300, 3, 1, 1 );
        plat5 moveZ( 300, 3, 1, 1 );
        wait 5;
    }
}

trap6() {
    trig = getEnt( "trap6_trig", "targetname" );
    circle1 = getEnt( "trap6_1", "targetname" );
    circle2 = getEnt( "trap6_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ( "trigger", player );
    trig setHintString( "^8Activated" );

    randomPart = randomInt( 2 );
        switch( randomPart ) {
        case 0:
        for( i = 0; i < circle1.size; i++ ) {
            circle1 delete();
            wait .05;
        }
        break;
        case 1:
        for( i = 0; i < circle2.size; i++ ) {
            circle2 delete();
            wait .05;
        }
        break;
    }
}

trap7() {
    trig = getEnt( "trap7_trig", "targetname" );
    wood1 = getEnt( "trap7_1", "targetname" );
    wood2 = getEnt( "trap7_2", "targetname" );
    clip = getEnt( "trap7_clip", "targetname" );

    clip notsolid();

    // trig setHintString("^7Press ^8&&1 ^7To Activate");
    // trig waittill ( "trigger", player );
    // trig setHintString( "^8Activated" );

    // clip solid();

    // randomPart = randomInt( 2 );
    //     switch( randomPart ) {
    //     case 0:
    //     for( i = 0; i < wood1.size; i++ ) {
    //         wood1 delete();
    //         wait .05;
    //     }
    //     break;
    //     case 1:
    //     for( i = 0; i < wood2.size; i++ ) {
    //         wood2 delete();
    //         wait .05;
    //     }
    //     break;
    // }
}

old() {
    level.old = getEnt( "trig_old", "targetname" );
    door = getEnt( "olddoor", "targetname" );
    clip = getEnt( "clip_old", "targetname" );

    level.old setHintString( "Press ^8&&1 ^7to choose ^8Old!" );
    level.old waittill( "trigger", player );
    iprintlnbold(  "^8" + player.name + " ^7chose the ^8old way!" );

    level.old delete();
    level.bounce delete();
    level.revolver delete();
    level.knife delete();
    clip delete();

    door moveZ( -92, 3, 1, 1 );
}

knife() {

    level.knife = getEnt( "trig_knife", "targetname");
    jump = getEnt( "origin_knife_jump", "targetname" );
    acti = getEnt( "origin_knife_acti", "targetname" );

    while( 1 ) {

        level.inRoom = false;
        level.knife setHintString( "Press ^8&&1 ^7to choose ^8Knife!" );
        level.knife waittill( "trigger", player );
        level.knife setHintString( "^8" + player.name + " ^7is in the knife room with ^8" + level.activ.name + "^7!" );  // change to level.activ

            if( !level.inRoom ) {

            if( isDefined( level.knife ) )
            level.inRoom = true;
            level.inKnife = true;

                level.old delete();
                level.bounce delete();
                level.revolver delete();

                wait 0.05;
		        knife_hud = SpawnStruct();
	    	    knife_hud.titleText = "Knife Room";
	    	    knife_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    knife_hud.glowcolor = (.1725, .7373, .8);
	    	    knife_hud.duration = 5;
	    	    players = getEntArray( "player", "classname" );
	    	    for ( i = 0; i < players.size; i++ ) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( knife_hud );
	    	    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player.maxhealth = 100;

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100;
                }

                level.activ freezeControls( true );
                player freezeControls( true );
                wait 3;
                player freezeControls( false );
                level.activ freezeControls( false );

	    	    player waittill( "death" );
	    	    level.inRoom = false;
        }
    }
}

revolver() {

    level.revolver = getEnt( "trig_revolver", "targetname");
    jump = getEnt( "origin_revolver_jump", "targetname" );
    acti = getEnt( "origin_revolver_acti", "targetname" );

    while( 1 ) {

        level.inRoom = false;
        level.revolver setHintString( "Press ^8&&1 ^7to choose ^8Revolver!" );
        level.revolver waittill( "trigger", player );
        level.revolver setHintString( "^8" + player.name + " ^7is in the Revolver room with ^8" + level.activ.name + "^7!" );  // change to level.activ

            if( !level.inRoom ) {

            if( isDefined( level.knife ) )
            level.inRoom = true;
            level.inRevolver = true;

                level.old delete();
                level.bounce delete();
                level.knife delete();

                wait 0.05;
		        knife_hud = SpawnStruct();
	    	    knife_hud.titleText = "Revolver Room";
	    	    knife_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    knife_hud.glowcolor = (.1725, .7373, .8);
	    	    knife_hud.duration = 5;
	    	    players = getEntArray( "player", "classname" );
	    	    for ( i = 0; i < players.size; i++ ) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( knife_hud );
	    	    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "bloodhound_mp" );
                player GiveMaxAmmo( "bloodhound_mp" );
                player switchToWeapon( "bloodhound_mp" );
                player.maxhealth = 100;

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "bloodhound_mp" );
                    level.activ GiveMaxAmmo( "bloodhound_mp" );
                    level.activ switchToWeapon( "bloodhound_mp" );
                    level.activ.maxhealth = 100;
                }

                level.activ freezeControls( true );
                player freezeControls( true );
                wait 3;
                player freezeControls( false );
                level.activ freezeControls( false );

	    	    player waittill( "death" );
	    	    level.inRoom = false;
        }
    }
}

bounce() {

    level.bounce = getEnt( "trig_bounce", "targetname");
    jump = getEnt( "origin_bounce_jump", "targetname" );
    acti = getEnt( "origin_bounce_acti", "targetname" );

    while( 1 ) {

        level.inRoom = false;
        level.bounce setHintString( "Press ^8&&1 ^7to choose ^8Bounce!" );
        level.bounce waittill( "trigger", player );
        level.bounce setHintString( "^8" + player.name + " ^7is in Bounce battling it out with ^8" + level.activ.name + "^7!" );

            if( !level.inRoom ) {

                if( isDefined( level.bounce ) )
                level.inRoom = true;
                level.inBounce = true;

                level.old delete();
                level.knife delete();
                level.revolver delete();

                wait 0.05;
	    	    bounce_hud = SpawnStruct();
	    	    bounce_hud.titleText = "Bounce Room";
	    	    bounce_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;     // change self.name to level.activ.name
	    	    bounce_hud.glowcolor = (.1725, .7373, .8);
	    	    bounce_hud.duration = 5;
	    	    players = getEntArray( "player", "classname" );
	    	    for ( i = 0; i < players.size; i++ ) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( bounce_hud );
	    	    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player.maxhealth = 100;

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100;
                }

                thread bounce_weap();

                level.activ freezeControls( true );
                player freezeControls( true );
                wait 3;
                player freezeControls( false );
                level.activ freezeControls( false );

                player waittill( "death" );
	    	    level.inRoom = false;
        }
    }
}

bounce_weap() {

    weapon = getEnt( "trig_bounce_weap", "targetname" );
    weapon setHintString( "Press ^8&&1 ^7to get a ^8Weapon!" );

	while( 1 ) {
		weapon waittill( "trigger", player );
		player giveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		player switchToWeapon( "remington700_mp" );
		player giveWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		player switchToWeapon( "m40a3_mp" );
		player takeWeapon( "knife_mp" );
	}
}

bounce_fail() {

    jump = getEnt( "origin_bounce_jump", "targetname" );
    acti = getEnt( "origin_bounce_acti", "targetname" );
    trig = getEnt( "trig_bounce_fail", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );

        if( player.pers["team"] == "allies" ) {
            player freezeControls( 1 );
            player SetPlayerAngles( jump.angles );
            player SetOrigin( jump.origin );
            player freezeControls( 0 );
        }
        else if( player.pers["team"] == "axis" ) {
            level.activ freezeControls( 1 );
            level.activ setPlayerAngles ( acti.angles );
            level.activ setOrigin( acti.origin );
            level.activ freezeControls( 0 );
        }
    }
}