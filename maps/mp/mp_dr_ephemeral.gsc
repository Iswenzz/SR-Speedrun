/*
___________      .__                                       .__   
\_   _____/_____ |  |__   ____   _____   ________________  |  |  
 |    __)_\____ \|  |  \_/ __ \ /     \_/ __ \_  __ \__  \ |  |  
 |        \  |_> >   Y  \  ___/|  Y Y  \  ___/|  | \// __ \|  |__
/_______  /   __/|___|  /\___  >__|_|  /\___  >__|  (____  /____/
        \/|__|        \/     \/      \/     \/           \/      
                                                                 
                                                                */
main()
{
	maps\mp\_load::main();
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
	setdvar("r_drawdecals", "1"); //can change if you want, adds a lot to map/secrets require decals for hints (map is well optimized, performance hit is not bad)
	level.hardsecretxp = 250; //DONT CHANGE
	level.impossible = 10000;
    
    thread speedrun\_way_name::create_normal_way("Normal Way");
    thread speedrun\_way_name::create_secret_way("Hard Secret;Easy Secret;");
    thread speedrun\_way_name::create_spawn((-74,-9,60),360);
    thread speedrun\_way_name::create_tp((452.335, 208.407, 0.125), 80, 80, (-27706, 12404, 1934), 222, "freeze", "darkred", "s0");
    thread speedrun\_way_name::create_tp((456.802, -239.358, 0.125), 80, 80, (6594, -10694, 2012), 125, "freeze", "blue", "s1");
    thread speedrun\_way_name::create_tp((-2864.63, 5696.1, -1519.88), 110, 105, (-3088, 5680, 180), 179, "freeze");
    // thread music();
    thread startdoor();
	// thread platform();
	// thread platform2();
	// thread elevator();
    // thread secret();
	// thread acti_tele1();
	// thread acti_tele2();
	// thread acti_tele3();
	// thread acti_tele4();
	thread secret_check_1();
	thread secret_check_2();
	thread secret_check_3();
	thread secret_check_4();
	thread secret_fail();
	thread secretend();
	// thread sniper();
	// thread weapon();
	// thread knife();
	// thread secretactivate();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread trap15();
	// thread isecret();
	thread i_secret_check_1();
	thread i_secret_check_2();
	thread i_secret_check_3();
	thread i_secret_check_4();
	thread i_secret_check_5();
	thread i_secret_check_6();
	thread i_secret_check_7();
	thread i_secret_check_8();
	thread i_secret_check_9();
	thread i_secret_fail();
	thread i_secretend();

	 addTriggerToList( "trig1" );
	 addTriggerToList( "trig2" );
	 addTriggerToList( "trig3" );
	 addTriggerToList( "trig4" );
	 addTriggerToList( "trig5" );
	 addTriggerToList( "trig6" );
	 addTriggerToList( "trig7" );
	 addTriggerToList( "trig8" );
	 addTriggerToList( "trig9" );
	 addTriggerToList( "trig10" );
	 addTriggerToList( "trig11" );
	 addTriggerToList( "trig12" );
	 addTriggerToList( "trig13" );
	 addTriggerToList( "trig14" );
	 addTriggerToList( "trig15" );

}

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

music()
{
        wait 5;
        random = randomint (4);
        switch (random)
        {
                case 0: ambientPlay("muzzy");
			    level.xx5 = newHudElem();	
				level.xx5.x = 0;	
				level.xx5.y = 150;
				level.xx5.horzAlign = "center";	
				level.xx5.vertAlign = "middle";
				level.xx5.alignX = "center";
				level.xx5.alignY = "middle";
				level.xx5.sort = 102;	
				level.xx5.foreground = 1;	
				level.xx5.archived = true;	
				level.xx5 fadeOverTime(2);
				level.xx5.alpha = 1;	
				level.xx5.fontScale = 4.6;
				level.xx5.hidewheninmenu = false;	
				level.xx5.color = (543,0,139);	
				level.xx5.glowColor = (0.0, 0.0, 0.0);
				level.xx5.glowAlpha = 1;
				level.xx5.label = &"[DnB] - Muzzy - Feeling Stronger (feat. Charlotte Colley) (High Maintenance Remix)";	
				wait 10;
				level.xx5 fadeOverTime(4);
				level.xx5.alpha = 0;	
				wait 15;
				level.xx5 destroy();
				break;
                case 1: Ambientplay("julian");
                level.xx5 = newHudElem();	
				level.xx5.x = 0;	
				level.xx5.y = 150;
				level.xx5.horzAlign = "center";	
				level.xx5.vertAlign = "middle";
				level.xx5.alignX = "center";
				level.xx5.alignY = "middle";
				level.xx5.sort = 102;	
				level.xx5.foreground = 1;	
				level.xx5.archived = true;	
				level.xx5 fadeOverTime(2);
				level.xx5.alpha = 1;	
				level.xx5.fontScale = 4.6;
				level.xx5.hidewheninmenu = false;	
				level.xx5.color = (236,0,139);	
				level.xx5.glowColor = (0.0, 0.0, 0.0);
				level.xx5.glowAlpha = 1;
				level.xx5.label = &"Julian Jordan - Angels x Demons (Radio Edit) [Official]";	
				wait 10;
				level.xx5 fadeOverTime(4);
				level.xx5.alpha = 0;	
				wait 15;
				level.xx5 destroy();
				break;            
                case 2: Ambientplay("young");
                level.xx5 = newHudElem();	
				level.xx5.x = 0;	
				level.xx5.y = 150;
				level.xx5.horzAlign = "center";	
				level.xx5.vertAlign = "middle";
				level.xx5.alignX = "center";
				level.xx5.alignY = "middle";
				level.xx5.sort = 102;	
				level.xx5.foreground = 1;	
				level.xx5.archived = true;	
				level.xx5 fadeOverTime(2);
				level.xx5.alpha = 1;	
				level.xx5.fontScale = 4.6;
				level.xx5.hidewheninmenu = false;	
				level.xx5.color = (134,0,139);	
				level.xx5.glowColor = (0.0, 0.0, 0.0);
				level.xx5.glowAlpha = 1;
				level.xx5.label = &"If I Die Young - Dubstep Remix";	
				wait 10;
				level.xx5 fadeOverTime(4);
				level.xx5.alpha = 0;	
				wait 15;
				level.xx5 destroy();
				break;        
				case 3: Ambientplay("ultraviolet");
                level.xx5 = newHudElem();	
				level.xx5.x = 0;	
				level.xx5.y = 150;
				level.xx5.horzAlign = "center";	
				level.xx5.vertAlign = "middle";
				level.xx5.alignX = "center";
				level.xx5.alignY = "middle";
				level.xx5.sort = 102;	
				level.xx5.foreground = 1;	
				level.xx5.archived = true;	
				level.xx5 fadeOverTime(2);
				level.xx5.alpha = 1;	
				level.xx5.fontScale = 4.6;
				level.xx5.hidewheninmenu = false;	
				level.xx5.color = (150,150,139);	
				level.xx5.glowColor = (0.0, 0.0, 0.0);
				level.xx5.glowAlpha = 1;
				level.xx5.label = &"ANFM - 'Ultraviolet'";	
				wait 10;
				level.xx5 fadeOverTime(4);
				level.xx5.alpha = 0;	
				wait 15;
				level.xx5 destroy();
				break;             
        }
}

startdoor()
{
	door = getEnt("startdoor","targetname");
	door moveZ(300, 6, 3, 3);
	door Delete();

}

platform()
{
	platform = getEnt ("moving1","targetname");
	trig = getEnt ("moving1_trig","targetname");
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	platform moveX (-472, 5, 2.5, 2.5 );
	wait 7;
	platform moveX (472, 5, 2.5, 2.5 );
	wait 7;
}
}

platform2()
{
	platform = getEnt ("moving2","targetname");
	trig = getEnt ("moving2_trig","targetname");
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	platform moveX (-472, 5, 2.5, 2.5 );
	wait 7;
	platform moveX (472, 5, 2.5, 2.5 );
	wait 7;
}
}

elevator()
{
	elevator = getEnt ("elevator","targetname");
	trig = getEnt ("elevator_trig","targetname");
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	elevator moveZ (1640, 8, 4, 4 );
	elevator waittill("movedone");
	wait 3;
	elevator moveZ (-1640, 8, 4, 4 );
	elevator waittill("movedone");
	wait 3;
}
}


secret() //if dont work then link
{
	dest = getEnt( "secret_enter_origin", "targetname" );
	trig = getEnt( "secret_trig", "targetname" );
	trig SetHintString("^2Hard Secret (Don't go in)");

	
	while(1)
	{
		trig waittill ( "trigger", player );
		player.checkpointid = 0;
		iPrintln( player.name + "^1 has entered the HARD secret" );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

isecret() //if dont work then link
{
	dest = getEnt( "i_secret_enter_origin", "targetname" );
	trig = getEnt( "i_secret_trig", "targetname" );
	trig SetHintString("^9The Impossible Secret (You won't finish)");

	
	while(1)
	{
		trig waittill ( "trigger", player );
		player.icheckpointid = 0;
		iPrintln( player.name + "^1 has entered the IMPOSSIBLE secret" );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

acti_tele1()
{
	dest = getEnt( "acti_tele_1_origin", "targetname" );
	trig = getEnt( "acti_tele_1", "targetname" );
	trig SetHintString("^1Press &&1 To Go To The ^6Next Area");

	
	while(1)
	{
		trig waittill ( "trigger", player );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

acti_tele2()
{
	dest = getEnt( "acti_tele_2_origin", "targetname" );
	trig = getEnt( "acti_tele_2", "targetname" );
	trig SetHintString("^1Press &&1 To Go To The ^6Next Area");

	
	while(1)
	{
		trig waittill ( "trigger", player );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

acti_tele3()
{
	dest = getEnt( "acti_tele_3_origin", "targetname" );
	trig = getEnt( "acti_tele_3", "targetname" );
	trig SetHintString("^1Press &&1 To Go To The ^6Next Area");

	
	while(1)
	{
		trig waittill ( "trigger", player );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

acti_tele4()
{
	dest = getEnt( "acti_tele_4_origin", "targetname" );
	trig = getEnt( "acti_tele_4", "targetname" );
	trig SetHintString("^1Press &&1 To Go To The ^6Next Area");

	
	while(1)
	{
		trig waittill ( "trigger", player );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

secret_check_1()
{
	trigger = getEnt("secret_check_1","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 1)
		{
			player.checkpointid = 1;
			
		}
	}
}

secret_check_2()
{
	trigger = getEnt("secret_check_2","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 2)
		{
			player.checkpointid = 2;
			
		}
	}
}

secret_check_3()
{
	trigger = getEnt("secret_check_3","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 3)
		{
			player.checkpointid = 3;
			
		}
	}
}

secret_check_4()
{
	trigger = getEnt("secret_check_4","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 4)
		{
			player.checkpointid = 4;
			
		}
	}
}


secret_fail()
{
	trigger = getEnt( "secret_fail", "targetname" );
	dest = getEnt( "secret_enter_origin", "targetname" );
	check1 = getEnt( "secret_check_1_tp", "targetname" );
	check2 = getEnt( "secret_check_2_tp", "targetname" );
	check3 = getEnt( "secret_check_3_tp", "targetname" );
	check4 = getEnt( "secret_check_4_tp", "targetname" );

	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (isDefined(player.checkpointid))
		{
			if (player.checkpointid == 0)
			{
				player setOrigin( dest.origin );
				player setplayerangles( dest.angles );
			}
			if (player.checkpointid == 1)
			{
				player setOrigin( check1.origin );
				player setplayerangles( check1.angles );
			}
			if (player.checkpointid == 2)
			{
				player setOrigin( check2.origin );
				player setplayerangles( check2.angles );
			}
			if (player.checkpointid == 3)
			{
				player setOrigin( check3.origin );
				player setplayerangles( check3.angles );
			}
			if (player.checkpointid == 4)
			{
				player setOrigin( check4.origin );
				player setplayerangles( check4.angles );
			}

		}
	}
}

secretend() //if dont work then link
{
	trig = getEnt( "secret_end", "targetname" );
	origin = getEnt( "secret_end_tp", "targetname" );
	while(1) {
		trig waittill ( "trigger", player );
		player.checkpointid = 0;
		IPrintLnBold( player.name + "^1 has finished the ^9HARD ^1secret!" );
		// player IPrintLnBold( "You've recieved " + level.hardsecretxp + "XP" );
		// player braxi\_rank::giveRankXp("trap_activation", level.hardsecretxp); //easily changable at top - wouldn't advise changing hard secret xp
		player setOrigin( origin.origin );
		player setplayerangles( origin.angles );
        player thread speedrun\_way_name::finish_way("s1");
        
    }

}

sniper()
{
	level.sniper = GetEnt("sniper_trig","targetname");
    jump = GetEnt( "sniper_jump", "targetname" );
    acti = GetEnt( "sniper_acti", "targetname" );
    level.sniper SetHintString("^5Sniper Room");

	while(1)
	{
		level.sniper waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.weaponroom delete();
			level.knife delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "remington700_mp" );
			player GiveWeapon( "m40a3_mp" );        
			player GiveMaxAmmo( "remington700_mp" );
			player GiveMaxAmmo( "m40a3_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
        	level.activ GiveWeapon( "remington700_mp" );
        	level.activ GiveWeapon( "m40a3_mp" );         
        	level.activ GiveMaxAmmo( "remington700_mp" );
        	level.activ GiveMaxAmmo( "m40a3_mp" );
	        wait .05;
	        player switchToWeapon( "remington700_mp" ); 
	        level.activ SwitchToWeapon( "remington700_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Sniper Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

weapon()
{
	level.weaponroom = GetEnt("weapon_trig","targetname");
    jump = GetEnt( "sniper_jump", "targetname" );
    acti = GetEnt( "sniper_acti", "targetname" );
    level.weaponroom SetHintString("^5Weapon Room");

	while(1)
	{
		level.weaponroom waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.sniper delete();
			level.knife delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "ak74u_mp" );
			player GiveMaxAmmo( "ak74u_mp" );
			player GiveWeapon( "deserteagle_mp" );
			player GiveMaxAmmo( "deserteagle_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "ak74u_mp" );
	        level.activ GiveMaxAmmo( "ak74u_mp" );
			level.activ GiveWeapon( "deserteagle_mp" );
	        level.activ GiveMaxAmmo( "deserteagle_mp" );
	        wait .05;
	        player switchToWeapon( "ak74u_mp" ); 
	        level.activ SwitchToWeapon( "ak74u_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Weapon Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

knife()
{
	level.knife = GetEnt("knife_trig","targetname");
    jump = GetEnt( "knife_jump", "targetname" );
    acti = GetEnt( "knife_acti", "targetname" );
    level.knife SetHintString("^5Knife Room");

	while(1)
	{
		level.knife waittill("trigger", player);
	//	PlayFX(level._effect[ "room" ],knifefx.origin);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.sniper delete();
			level.weaponroom delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "tomahawk_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "tomahawk_mp" );
	        wait .05;
	        player switchToWeapon( "tomahawk_mp" ); 
	        level.activ SwitchToWeapon( "tomahawk_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Knife Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

secretactivate()
{
	trig = getEnt("secret_trig1","targetname");

	trig waittill ("trigger", player);
	player iPrintln("Beep");
	trig delete();
	thread secretpart2();

}

secretpart2()
{
	trig = getEnt("secret_trig2","targetname");

	trig waittill ("trigger", player);
	player iPrintln("Boop");
	trig delete();
	thread secretopen();

}

secretopen()
{
	trig = getEnt("secret_trig3","targetname");
	door = getEnt("secret_door","targetname");

	trig waittill ("trigger", player);
	player iPrintln("^5The Doors Have Opened");
	trig delete();
	door MoveZ(200, 3, 1.5, 1.5);
	wait 3;
	door Delete();

}

trap1()
{
	plat1 = getEntArray("trap1","targetname");
	trig = getent("trig1", "targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	for(;;)
	{
	for(i=0;i<plat1.size;i++)
{
		plat1[i] rotateYaw(360, 1);
		wait 0.01;
	}
	
}
}

trap2()
{
	trig = getEnt("trig2","targetname");
	trap = getEnt("trap2","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap MoveZ(-74, 1, 0.5, 0.5);
	wait 4;
	trap MoveZ(74, 1, 0.5, 0.5);

}

trap3()
{
	trig = getEnt("trig3","targetname");
	trap = getEnt("trap3_door","targetname");
	trap2 = getEnt("trap3_floor","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap MoveZ(-150, 1, 0.5, 0.5);
	wait 1;
	trap2 MoveZ(-64, 3);
	wait 4;
	trap2 MoveZ(64, 3);
	wait 4;
	trap MoveZ(150, 4, 2, 2);

}

trap4()
{
	trig = getEnt("trig4","targetname");
	trap = getEnt("trap4","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap Hide();
	trap NotSolid();
	wait 5;
	trap Show();
	trap Solid();
}

trap5()
{
	trig = getEnt("trig5","targetname");
	trap = getEnt("trap5","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap Hide();
	trap NotSolid();
	wait 5;
	trap Show();
	trap Solid();
}

trap6()
{
	trig = getEnt("trig6","targetname");
	trap = getEnt("trap6","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap Hide();
	trap NotSolid();
	wait 5;
	trap Show();
	trap Solid();
}

trap7()
{
	trig = getEnt("trig7","targetname");
	trap = getEnt("trap7","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap Hide();
	trap NotSolid();
}

trap8()
{
	trig = getEnt("trig8","targetname");
	trap = getEnt("trap8","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap MoveZ(-112, 1, 0.5, 0.5);
	wait 4;
	trap MoveZ(112, 4, 2, 2);

}

trap9()
{
	trig = getEnt("trig9","targetname");
	trap = getEnt("trap9","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill ("trigger", player);
	trig Delete();
	trap MoveY(240, 4, 2, 2);
	wait 4;
	trap MoveY(-240, 4, 2, 2);

}

trap10()
{
	spin = getEnt("trap10","targetname");
	trig = getent("trig10", "targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	for(;;)
	{

		spin rotateYaw(360, 8);
		wait 0.01;
	}
	
}

trap11()
{
	spin = getEnt("trap11","targetname");
	trig = getent("trig11", "targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	for(;;)
	{

		spin rotateYaw(360, 6);
		wait 0.01;
	}
	
}

trap12()
{
	trig = getent("trig12", "targetname");
	fan = getent("fan1", "targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	thread bouncer1();
	thread trap12_2();

	for(;;)
	{
	self endon("trap12_stop");
	fan RotatePitch(360, 1, 0.5, 0.5);
	wait 0.1;
}
}

trap12_2()
{
wait 5;
level notify("trap12_stop");
}



bouncer1(who)
{
	trigger = getEnt ( "fan1_trig", "targetname" );
	origin = getent("fan_origin", "targetname");
	
	while(1)
	{
		self endon("trap12_stop");
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
		//playFx ( level.bounce, who.origin );
	    strenght = 9;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward(origin.angles), "none", 0);
	    }
	}
}

trap13()
{
	spin = getEnt("trap13","targetname");
	trig = getent("trig13", "targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	for(;;)
	{

		spin rotateYaw(360, 6);
		wait 0.01;
	}
	
}

trap14()
{
	trig = getent("trig14", "targetname");
	fan = getent("fan2", "targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	thread bouncer2();
	thread trap14_2();

	for(;;)
	{
	self endon("trap14_stop");
	fan RotatePitch(360, 1, 0.5, 0.5);
	wait 0.1;
}
}

trap14_2()
{
wait 7;
level notify("trap14_stop");
}

bouncer2(who)
{
	trigger = getEnt ( "fan2_trig", "targetname" );
	origin = getEnt ( "fan2_origin", "targetname" );
	
	while(1)
	{
		self endon("trap14_stop");
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
		//playFx ( level.bounce, who.origin );
	    strenght = 9;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward(origin.angles), "none", 0);
	    }
	}
}

trap15()
{
	trig = getent("trig15", "targetname");
	spin = getEnt("trap13","targetname");
	trig SetHintString("Press ^3&&1 ^7to ^1Activate");
	trig waittill("trigger", player);
	trig Delete();
	for(;;)
	{
	spin MoveZ(-70, 4, 2, 2);
	wait 4;
	spin MoveZ(70, 4, 2, 2);
	wait 4;
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
			;
		}
	}
}

i_secret_check_5()
{
	trigger = getEnt("i_secret_check_5","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 5)
		{
			player.icheckpointid = 5;
			
		}
	}
}

i_secret_check_6()
{
	trigger = getEnt("i_secret_check_6","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 6)
		{
			player.icheckpointid = 6;
			
		}
	}
}

i_secret_check_7()
{
	trigger = getEnt("i_secret_check_7","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 7)
		{
			player.icheckpointid = 7;
			
		}
	}
}

i_secret_check_8()
{
	trigger = getEnt("i_secret_check_8","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 8)
		{
			player.icheckpointid = 8;
			
		}
	}
}


i_secret_check_9()
{
	trigger = getEnt("i_secret_check_9","targetname");
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.icheckpointid < 9)
		{
			player.icheckpointid = 9;
		
		}
	}
}


i_secret_fail()
{
	trigger = getEnt( "impossible_secret_teleport", "targetname" );
	dest = getEnt( "i_secret_enter_origin", "targetname" );
	check1 = getEnt( "i_secret_check_1_tp", "targetname" );
	check2 = getEnt( "i_secret_check_2_tp", "targetname" );
	check3 = getEnt( "i_secret_check_3_tp", "targetname" );
	check4 = getEnt( "i_secret_check_4_tp", "targetname" );
	check5 = getEnt( "i_secret_check_5_tp", "targetname" );
	check6 = getEnt( "i_secret_check_6_tp", "targetname" );
	check7 = getEnt( "i_secret_check_7_tp", "targetname" );
	check8 = getEnt( "i_secret_check_8_tp", "targetname" );
	check9 = getEnt( "i_secret_check_9_tp", "targetname" );
	
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
			if (player.icheckpointid == 9)
			{
				player setOrigin( check9.origin );
				player setplayerangles( check9.angles );
			}

		}

}
}

i_secretend() //if dont work then link
{
	trig = getEnt( "i_secret_finish", "targetname" );
	origin = getEnt( "secret_end_tp", "targetname" );
	while(1) {
		trig waittill ( "trigger", player );
		player.icheckpointid = 0;
		IPrintLnBold( player.name + "^1 has finished the ^9IMPOSSIBLE ^1secret!!! WTF?" );
		// player IPrintLnBold( "You've recieved " + level.impossible + "XP" );
		// player braxi\_rank::giveRankXp("trap_activation", level.impossible); //easily changable at top - wouldn't advise changing hard secret xp
		player setOrigin( origin.origin );
		player setplayerangles( origin.angles );
         player thread speedrun\_way_name::finish_way("s0");

    }
}