main() {
thread sr\api\_map::createSpawn((15.467, -17.973, 0.125), 0);

	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

    setdvar("bg_fallDamageMaxHeight","300000");
    setdvar("bg_fallDamageMinHeight","300000");

    precacheitem( "m14_gl_mp" );
    precacheitem( "remington700_mp" );
    precacheitem( "g3_gl_mp" );
    precacheitem( "m21_acog_mp" );

    // Spawn
    thread startdoor();

    // Misc
    thread music();
    thread credits();
    thread precachefx();

    // Secret
    thread secret_enter();
    thread secret_finish();
    thread i_secret_fail();
    thread i_secret_check_0();
    thread i_secret_check_1();
    thread i_secret_check_2();
    thread i_secret_check_3();
    thread i_secret_check_4();

    // Jumper Teleports
    thread jump_tele_1();

    // Activator Teleports
    thread acti_tele_1();
    thread acti_tele_2();
    thread acti_tele_3();
    thread acti_tele_4();
    thread acti_tele_5();
    thread acti_tele_6();
    thread acti_tele_7();

    // Traps
    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap5_mover();
    thread trap6();
    thread trap7();
    thread trap8();

    // End Rooms
    thread sniper_room();
    thread bounce_room();
    thread bounce_fail();
    thread boxing_room();

    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");

    // Trigger List
    addTriggerToList( "trap1_trig" ); 
    addTriggerToList( "trap2_trig" ); 
    addTriggerToList( "trap3_trig" ); 
    addTriggerToList( "trap4_trig" ); 
    addTriggerToList( "trap5_trig" ); 
    addTriggerToList( "trap6_trig" ); 
    addTriggerToList( "trap7_trig" ); 
    addTriggerToList( "trap8_trig" );
}

addTriggerToList( name ) {

   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor() {
    level waittill( "round_started" );
    door = getEnt( "startdoor", "targetname" );

        wait 5;

        door moveZ( -300, 2, .25, .25 );
        door waittill( "movedone" );
        door delete();
}

music() {

    level waittill( "round_started" );

	songs = [];
	songs[songs.size] = "song1";
	songs[songs.size] = "song2";
	songs[songs.size] = "song3";

	selected = songs[ Randomint( songs.size ) ];
	AmbientPlay( selected );
}

credits() {
    while(1) {
        wait 8;
        iprintLn( "^7Mapped & Scripted by ^8Mist" );
        wait 8;
        iprintLn( "^7Visit: ^8pxg.gg" );
        wait 8;
        iprintLn( "^7Thank you to ^8Jay^7, ^8Jax ^7& ^8Cloudy" );
        wait 8;
        iprintLn( "^7Map made for ^8Precision Gaming" );
    }
}

precachefx() {
    level._effect[ "teleport_fx" ]        = loadFX( "pxg_capacity/tp_fx" );
}

secret_enter() {
    trig = getEnt( "trig_enter_secret", "targetname" );
    origin_enter = getEnt( "origin_secret_enter", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Enter Secret");

    for( ;; ) {
        trig waittill( "trigger", player );
         player thread sr\api\_speedrun::changeWay("secret_0"); 
        player freezeControls( 1 );
        player setOrigin( origin_enter.origin );
        player setPlayerAngles( origin_enter.angles );
        player freezeControls( 0 );
        player.icheckpointid = 0;
        wait .05;
    }
}

secret_finish() {
    teleport1 = GetEnt("trig_secret_finish","targetname");
    origin1 = GetEnt("origin_finish_secret","targetname");

    while(1) {
        teleport1 waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
        player SetPlayerAngles( origin1.angles );
        player setOrigin( origin1.origin );
        player braxi\_rank::giveRankXp("trap_activation", 1000);
        player braxi\_rank::giveRankXp("trap_activation", 1000);
        player braxi\_rank::giveRankXp("trap_activation", 1000);
        player braxi\_rank::giveRankXp("trap_activation", 1000);
        player braxi\_rank::giveRankXp("trap_activation", 1000);
    }    
}

i_secret_fail() {
	trigger = getEnt( "trig_secret_fail", "targetname" );
	dest = getEnt( "origin_secret_enter", "targetname" );
	check1 = getEnt( "origin_secret_check1", "targetname" );
	check2 = getEnt( "origin_secret_check2", "targetname" );
	check3 = getEnt( "origin_secret_check3", "targetname" );
	check4 = getEnt( "origin_secret_check4", "targetname" );
	
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
			if (player.icheckpointid == 4)
			{
				player setOrigin( check4.origin );
				player setplayerangles( check4.angles );
			}
		}
    }
}

i_secret_check_0()
{
	trigger = getEnt("i_secret_check_0","targetname");

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

i_secret_check_1()
{
	trigger = getEnt("i_secret_check_1","targetname");
	
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

i_secret_check_2()
{
	trigger = getEnt("i_secret_check_2","targetname");
	
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

i_secret_check_3()
{
	trigger = getEnt("i_secret_check_3","targetname");
	
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

i_secret_check_4()
{
	trigger = getEnt("i_secret_check_4","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 4)
		{
			player.icheckpointid = 4;
			player iPrintln( "^8Checkpoint reached" );
		}
	}
}

jump_tele_1() {

    fx = loadFX( "pxg_capacity/tp_fx" );
    trig = getEnt( "trig_enter_stage2", "targetname" );
    org = getEnt( "origin_tp_fx", "targetname" );
    org2 = getEnt( "origin_enter_stage2", "targetname" );

    playLoopedFX( fx, .5, org.origin );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( org2.origin );
        player setPlayerAngles( org2.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_1() {
    trig = getEnt( "acti_tele_1", "targetname" );
    origin = getEnt( "acti_tele_1_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_2() {
    trig = getEnt( "acti_tele_2", "targetname" );
    origin = getEnt( "acti_tele_2_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_3() {
    trig = getEnt( "acti_tele_3", "targetname" );
    origin = getEnt( "acti_tele_3_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_4() {
    trig = getEnt( "acti_tele_4", "targetname" );
    origin = getEnt( "acti_tele_4_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_5() {
    trig = getEnt( "acti_tele_5", "targetname" );
    origin = getEnt( "acti_tele_5_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_6() {
    trig = getEnt( "acti_tele_6", "targetname" );
    origin = getEnt( "acti_tele_6_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

acti_tele_7() {
    trig = getEnt( "acti_tele_7", "targetname" );
    origin = getEnt( "acti_tele_7_origin", "targetname" );

    for( ;; ) {
        trig waittill( "trigger", player );
        player freezeControls( 1 );
        player setOrigin( origin.origin );
        player setPlayerAngles( origin.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

trap1() {
    trig = getEnt( "trap1_trig", "targetname" );
    rock1 = getEnt( "trap1_1", "targetname" );
    rock2 = getEnt( "trap1_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

    while( 1 ) {
        rock1 moveY( -350, 2 );
        rock2 moveY( 350, 2 );
        wait 2;
        rock1 moveY( 350, 2 );
        rock2 moveY( -350, 2 );
        wait 2;
    }
}

trap2() {
    trig = getEnt( "trap2_trig", "targetname" );
    plat1 = getEnt( "trap2_1", "targetname" );
    plat2 = getEnt( "trap2_2", "targetname" );
    plat3 = getEnt( "trap2_3", "targetname" );
    plat4 = getEnt( "trap2_4", "targetname" );
    plat5 = getEnt( "trap2_5", "targetname" );
    plat6 = getEnt( "trap2_6", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

    plat1 rotateYaw( -1050, 2, .25, .25 );  
    plat2 rotateYaw( -1050, 2, .25, .25 );  
    plat3 rotateYaw( -1050, 2, .25, .25 );    
    plat4 rotateYaw( -1050, 2, .25, .25 );
    plat5 rotateYaw( -1050, 2, .25, .25 );
    plat6 rotateYaw( -1050, 2, .25, .25 );
    wait 3;

    while( 1 ) {
        plat1 rotateYaw( -1050, 1, .25, .25 );
        plat2 rotateYaw( -1050, 1, .25, .25 );
        wait 2;
        plat3 rotateYaw( -1050, 1, .25, .25 );
        plat4 rotateYaw( -1050, 1, .25, .25 );
        wait 2;
        plat5 rotateYaw( -1050, 1, .25, .25 );
        plat6 rotateYaw( -1050, 1, .25, .25 );
        wait 2;
    }
}

trap3() {
    trig = getEnt( "trap3_trig", "targetname" );
    square1 = getEnt( "trap3_1", "targetname" );
    square2 = getEnt( "trap3_2", "targetname" );
    square3 = getEnt( "trap3_3", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

    while( 1 ) {
        square1 hide();
        square1 notsolid();
        square2 show();
        square2 solid();
        square3 show();
        square3 solid();
        wait 1.2;
        square1 show();
        square1 solid();
        square2 hide();
        square2 notsolid();
        square3 show();
        square3 solid();
        wait 1.2;
        square1 show();
        square1 solid();
        square2 show();
        square2 solid();
        square3 hide();
        square3 notsolid();
        wait 1.2;
    }
}

trap4() {
    trig = getEnt( "trap4_trig", "targetname" );
    ladder1 = getEnt( "trap4_1", "targetname" );
    ladder2 = getEnt( "trap4_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

    randomPart = randomInt( 2 );
        switch( randomPart ) {
        case 0:
        for( i = 0; i < ladder1.size; i++ ) {
            ladder1 delete();
            wait .05;
        }
        break;
        case 1:
        for( i = 0; i < ladder2.size; i++ ) {
            ladder2 delete();
            wait .05;
        }
        break;
    }
}

trap5() {
    trig = getEnt( "trap5_trig", "targetname" );
    plat = getEnt( "trap5_1", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

    plat hide();
    plat notsolid();
    wait 5;
    plat show();
    plat solid();
}

trap5_mover() {
    trig = getEnt( "trap5_1_move_trig", "targetname" );
    plat = getEnt( "trap5_1", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

}


trap6() {
    trig = getEnt( "trap6_trig", "targetname" );
    rockone = getEnt( "trap6_1", "targetname" );
    rocktwo = getEnt( "trap6_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger", player );
    trig delete();

    while( 1 ) {
        rockone moveZ( 200, 3 );
        rocktwo moveZ( -200, 3 );
        wait 3;
        rockone moveZ( -200, 3 );
        rocktwo moveZ( 200, 3 );
        wait 3;
    }
}

trap7() {
    trig = getEnt( "trap7_trig", "targetname" );
    bounce1 = getEnt( "trap7_1", "targetname" );
    bounce2 = getEnt( "trap7_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger", player );
    trig delete();

    while( 1 ) {
        bounce1 moveY( 150, 1.5 );
        bounce2 moveY( -150, 1.5 );
        wait 1.5;
        bounce1 moveY( -150, 1.5 );
        bounce2 moveY( 150, 1.5 );
        wait 1.5;
    }
}

trap8() {
    trig = getEnt( "trap8_trig", "targetname" );
    plat = getEnt( "trap8_1", "targetname" );
    plat_down = getEnt( "trap8_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig delete();

    plat moveZ( -75, 1, .25, .25 );
    plat_down moveZ( 75, 1, .25, .25 );
    plat waittill( "movedone" );

    while( 1 ) {
        plat moveZ( 150, 1, .25, .25 );
        plat_down moveZ( -150, 1, .25, .25 );
        plat waittill( "movedone" );
        wait .5;
        plat moveZ( -150, 1, .25, .25 );
        plat_down moveZ( 150, 1, .25, .25 );
        plat waittill( "movedone" );
        wait .5;
    }
}

sniper_room() {
 
    level.sniper_trig = getEnt( "trig_enter_sniper", "targetname"); 
    jump = getEnt( "origin_enter_sniper_jump", "targetname" );
    acti = getEnt( "origin_enter_sniper_acti", "targetname" ); 

    while( 1 ) {

        level.inRoom = false;
        level.sniper_trig setHintString( "Press [^8F^7] choose Sniper!" );        
        level.sniper_trig waittill( "trigger", player );
        level.sniper_trig setHintString( "^8" + player.name + " ^7is in Sniper battling it out with ^8" + level.activ.name + "^7!" );

        if( !level.inRoom ) {
        
            if( isDefined( level.sniper_trig ) ) 
            level.inRoom = true;
            level.inSniper = true;

            level.bounce_trig delete();
            level.knife_trig delete();

            wait 0.05;
		    sniper_hud = SpawnStruct();
		    sniper_hud.titleText = "Sniper Room";
		    sniper_hud.notifyText = player.name + " [^3VS^7] " + level.activ.name;     // change self.name to level.activ.name
		    sniper_hud.glowcolor = (.1725, .7373, .8);
		    sniper_hud.duration = 5;
		    
            players = getEntArray( "player", "classname" );
		    for ( i = 0; i < players.size; i++ ) {
		        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( sniper_hud );
		    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "g3_gl_mp" );
                player giveMaxAmmo( "g3_gl_mp" );
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );   
                player switchToWeapon( "remington700_mp" );
                player.maxhealth = 100;

            if( isDefined( level.activ ) && isAlive( level.activ ) ) {
    
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin ); 
                level.activ TakeAllWeapons(); 
                level.activ GiveWeapon( "g3_gl_mp" ); 
                level.activ giveMaxAmmo( "g3_gl_mp" ); 
                level.activ GiveWeapon( "remington700_mp" );
                level.activ giveMaxAmmo( "remington700_mp" );
                level.activ SwitchToWeapon( "remington700_mp" );
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

bounce_room() {
 
    level.bounce_trig = getEnt( "trig_enter_bounce", "targetname");
    jump = getEnt( "origin_enter_bounce_jump", "targetname" );
    acti = getEnt( "origin_enter_bounce_acti", "targetname" );

    while( 1 ) {
        
        level.inRoom = false;
        level.bounce_trig setHintString( "Press [^8F^7] to choose Bounce!" );        
        level.bounce_trig waittill( "trigger", player );
        level.bounce_trig setHintString( "^8" + player.name + " ^7is in Bounce battling it out with ^8" + level.activ.name + "^7!" );
            
            if( !level.inRoom ) {
            
                if( isDefined( level.bounce_trig ) ) 
                level.inRoom = true;
                level.inBounce = true;  

                level.sniper_trig delete();
                level.knife_trig delete();

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
                player GiveWeapon( "m21_acog_mp" );
                player switchToWeapon( "m21_acog_mp" );
                player.maxhealth = 100;

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m21_acog_mp" );
                    level.activ switchToWeapon( "m21_acog_mp" ); 
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

    weapon = getEnt( "trig_bounce_sniper", "targetname" );
        weapon setHintString( "Press [^8F^7] to get a Weapon!" );     
        weapon waittill( "trigger", player );
        player giveWeapon( "remington700_mp" );
        player giveMaxAmmo( "remington700_mp" );
        player switchToWeapon( "remington700_mp" );
        player giveWeapon( "g3_gl_mp" );
        player giveMaxAmmo( "g3_gl_mp" );
        player switchToWeapon( "g3_gl_mp" );

        weapon delete();
}

bounce_fail() {
    
    jump = getEnt( "origin_enter_bounce_jump", "targetname" );
    acti = getEnt( "origin_enter_bounce_acti", "targetname" );
    trig = getEnt( "trig_bounce_room_fail", "targetname" );

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

boxing_room() {   
 
    level.knife_trig = getEnt( "trig_enter_boxing", "targetname");
    jump = getEnt( "origin_enter_boxing_jump", "targetname" );
    acti = getEnt( "origin_enter_boxing_acti", "targetname" ); 

    while( 1 ) {

        level.inRoom = false;
        level.knife_trig setHintString( "Press [^8F^7] to choose a ^8Boxing ^7Match!" );        
        level.knife_trig waittill( "trigger", player );
        level.knife_trig setHintString( "^8" + player.name + " ^7is in a boxing match with ^8" + level.activ.name + "^7!" );  // change to level.activ

            if( !level.inRoom ) {

            if( isDefined( level.knife_trig ) ) 
            level.inRoom = true;
            level.inKnife = true;

                level.bounce_trig delete();    
                level.sniper_trig delete();

                wait 0.05;
		        knife_hud = SpawnStruct();
	    	    knife_hud.titleText = "Boxing Room";
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
                player GiveWeapon( "m14_gl_mp" );
                player switchToWeapon( "m14_gl_mp" );
                player.maxhealth = 100; 

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m14_gl_mp" );
                    level.activ switchToWeapon( "m14_gl_mp" ); 
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