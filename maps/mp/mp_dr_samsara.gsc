main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	maps\mp\_load::main();	
	

thread sr\api\_map::createSpawn((4386, 1, -2034), 360);
thread sr\api\_speedrun::createEndMap((22320, 4971, -1716), 100, 150);
thread sr\api\_speedrun::createTeleporter((4399, 324, -2034), 100, 150, 
	(-1055, -1640, -1545), 360, "freeze", "blue", "secret_0");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	precacheItem( "knife_mp" );
	precacheItem( "ak47_mp" );
	precacheItem( "m40a3_mp" );
	precacheItem( "deserteaglegold_mp" );

	addTriggerToList("trigger_trap_01");
        addTriggerToList("trigger_trap_02");
	addTriggerToList("trigger_trap_02_2");
        addTriggerToList("trigger_trap_03");
        addTriggerToList("trigger_trap_04");
        addTriggerToList("trigger_trap_05");
        addTriggerToList("trigger_trap_06");
        addTriggerToList("trigger_trap_07");
        addTriggerToList("trigger_trap_08");
        addTriggerToList("trigger_trap_09");
        addTriggerToList("trigger_trap_10");
       	addTriggerToList("trigger_trap_11");
	
	wall = getent("wall_01","targetname");
	wall notsolid();
	wall = getent("wall_02","targetname");
	wall notsolid();
	wall = getent("wall_03","targetname");
	wall notsolid();
	
	thread start_button();
	// thread lawnmover1();
	// thread lawnmover2();
	// thread lawnmover3();
	// thread lawnmover4();
	// thread lawnmover5();
	// thread lawnmover6();
	thread ball_jumppad();
	// thread high_mover();
	thread cannabis_tele();
	 thread secret_end();
	thread jump_fail();
	/* [AUTO DELETE] thread knife_fail(); */
	// thread snip_fail();
	// thread end_tp_rooms();
	thread dorsser69();
	/* [AUTO DELETE] thread sniper_room_BATTLE(); */
	/* [AUTO DELETE] thread knife_room_BATTLE(); */
	/* [AUTO DELETE] thread deagle_room_BATTLE(); */
	// thread jump_room_BATTLE();
	// thread jump_unlock();
	// thread jump_room_gun_jumper();
	// thread jump_room_gun_acti();
	// thread jump_wall();
	/* [AUTO DELETE] thread banana_move1(); */
	/* [AUTO DELETE] thread banana_move2(); */
	/* [AUTO DELETE] thread banana_move3(); */
	/* [AUTO DELETE] thread banana_move3_1(); */
	/* [AUTO DELETE] thread banana_move4(); */
	/* [AUTO DELETE] thread banana_move5(); */
	/* [AUTO DELETE] thread banana_move6(); */
	/* [AUTO DELETE] thread banana_move7(); */
	/* [AUTO DELETE] thread banana_move8(); */
	/* [AUTO DELETE] thread banana_move9(); */
	/* [AUTO DELETE] thread banana_move10(); */
	/* [AUTO DELETE] thread banana_move11(); */
	/* [AUTO DELETE] thread banana_move11_1(); */
	/* [AUTO DELETE] thread banana_move12(); */
	thread trap_01_1();
	thread trap_01_2();
	thread trap_02();
	thread trap_02_2();
	thread trap_03();
	thread trap_04();
	thread trap_05_1();
	thread trap_05_2();
	thread trap_05_3();
	thread trap_05_4();
	thread trap_05_11();
	thread trap_05_22();
	thread trap_05_33();
	thread trap_05_44();
	thread trap_06();
	thread trap_07();
	thread trap_08();
	thread trap_09();
	thread trap_10();
	thread trap_10_1();
	thread trap_11();
	thread s_fail1();
	thread s_fail2();
	thread s_fail3();
	thread s_fail4();
	thread s_fail5();
	thread s_fail6();
	// thread vcmover();
	// thread acti_end_trigger();
}


	addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}


	start_button()
{
	trigger = getent("trigger_start","targetname");
        button = getent("start_button","targetname");
	wall = getent("start_wall","targetname");
	object1 = getent("start_flipper1","targetname");
	object2 = getent("start_flipper2","targetname");
        trigger waittill ("trigger" , player );
	trigger SetHintString("^5Slides Opened");
	i = randomint(2);
	if(i == 0)
	{
	wait 0.5;
	/* [AUTO DELETE] ambientPlay("samsara"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Samsara - Tungevaag & Raaban ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Samsara - Tungevaag & Raaban ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Samsara - Tungevaag & Raaban ^2]] ^1>>>"); */
	 button movez(-8,2);
	object1 rotateroll(-90, 4);
	object2 rotateroll(90, 4);
	wait(2);
	wall delete();
	}
	else if(i == 1)
	{
	wait 0.5;
	/* [AUTO DELETE] ambientPlay("springfield"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Springfield - Martin Tungevaag & Italobrothers ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Springfield - Martin Tungevaag & Italobrothers ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Springfield - Martin Tungevaag & Italobrothers ^2]] ^1>>>"); */
	 button movez(-8,2);
	object1 rotateroll(-90, 4);
	object2 rotateroll(90, 4);
	wait(2);
	wall delete();
	}
}


	lawnmover1()
{
	object1 = getent("lawnmover1","targetname");
	killtrig1 = getent ("killtrig1" , "targetname");
	killtrig1 enablelinkto ();
	killtrig1 linkto (object1);
	while (1)
	{
		object1 movey(-429,1.4);
		object1 waittill("movedone");
		object1 rotateyaw(180,1);
		object1 waittill("rotatedone");
		object1 movey(429,1.4);
		object1 waittill("movedone");
		object1 rotateyaw(180,1);
		object1 waittill("rotatedone");
	}
}

		
	lawnmover2()
{
	object2 = getent("lawnmover2","targetname");
	killtrig2 = getent ("killtrig2" , "targetname");
	killtrig2 enablelinkto ();
	killtrig2 linkto (object2);
	object2 movey(-214.5,0.7);
	while(1)
	{
		object2 waittill("movedone");
		object2 rotateyaw(-180,1);
		object2 waittill("rotatedone");
		object2 movey(429,1.4);
		object2 waittill("movedone");
		object2 rotateyaw(-180,1);
		object2 waittill("rotatedone");
		object2 movey(-429,1.4);
	}
}


	lawnmover3()
{
	object3 = getent("lawnmover3","targetname");
	killtrig3 = getent ("killtrig3" , "targetname");
	killtrig3 enablelinkto ();
	killtrig3 linkto (object3);
	while(1)
	{
		object3 movey(429,1.4);
		object3 waittill("movedone");
		object3 rotateyaw(180,1);
		object3 waittill("rotatedone");
		object3 movey(-429,1.4);
		object3 waittill("movedone");
		object3 rotateyaw(180,1);
		object3 waittill("rotatedone");
	}
}


	lawnmover4()
{
	object4 = getent("lawnmover4","targetname");
	killtrig4 = getent ("killtrig4" , "targetname");
	killtrig4 enablelinkto ();
	killtrig4 linkto (object4);
	object4 movey(132.5,0.7);
	while(1)
	{
		object4 waittill("movedone");
		object4 rotateyaw(-180,1);
		object4 waittill("rotatedone");
		object4 movey(-429,1.4);
		object4 waittill("movedone");
		object4 rotateyaw(-180,1);
		object4 waittill("rotatedone");
		object4 movey(429,1.4);
	}
}


	lawnmover5()
{
	object5 = getent("lawnmover5","targetname");
	killtrig5 = getent ("killtrig5" , "targetname");
	killtrig5 enablelinkto ();
	killtrig5 linkto (object5);
	while(1)
	{
		object5 movey(-429,1.7);
		object5 waittill("movedone");
		object5 rotateyaw(180,1);
		object5 waittill("rotatedone");
		object5 movey(429,1.7);
		object5 waittill("movedone");
		object5 rotateyaw(180,1);
		object5 waittill("rotatedone");
	}
}


	lawnmover6()
{
	object6 = getent("lawnmover6","targetname");
	killtrig6 = getent ("killtrig6" , "targetname");
	killtrig6 enablelinkto ();
	killtrig6 linkto (object6);
	object6 movey(-214.5,0.7);
	while(1)
	{
		object6 waittill("movedone");
		object6 rotateyaw(-180,1);
		object6 waittill("rotatedone");
		object6 movey(429,1.4);
		object6 waittill("movedone");
		object6 rotateyaw(-180,1);
		object6 waittill("rotatedone");
		object6 movey(-429,1.4);
	}
}


	ball_jumppad()
{
	jumpx = getent ("ball_teleport","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		user safe_ball_teleport();
	}
}

safe_ball_teleport()
{
	jumpx = getent ("ball_teleport","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	time = 1;

	if (self istouching(jumpx))
		{
			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air1.origin, 5);
			wait .5;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			self unlink();
			wait 1;
		}
}

	high_mover()
{
	mover = getent ("high_mover","targetname");
	while(1)
	{
		mover movey(-896,2);
		mover waittill("movedone");
		wait (0.5);
		mover movey(896,2);
		mover waittill("movedone");
		wait (0.5);
	}
}


	cannabis_tele()
{
	trig = getEnt ("cannabis_tele", "targetname");
	end = getEnt ("cannabis_tele_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	/* [AUTO DELETE] iPrintlnBold (" ^5" + player.name + " ^2 is high!"); */
	}

}


	secret_end()
{
	trig = getEnt ("secret_end", "targetname");
	end = getEnt ("secret_end_go", "targetname");
	trig SetHintString("^5Press F");
	while(1)
    	{
        trig waittill ("trigger", player);       
           player thread sr\api\_speedrun::finishWay("secret_0");
	// player SetOrigin(end.origin);
 //        player SetPlayerAngles( end.angles );
	/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Finished ^24^32^10" ); */
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 420); */
	}
}


	jump_fail()
{
        level.jumpfail = getent ("jump_alltp","targetname");
        level.js = getent ("jump_jt_go","targetname");
        level.as = getent ("jump_at_go","targetname");
        while(1)
        {
                level.jumpfail waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {
                        player SetPlayerAngles(level.js.angles);
                        player SetOrigin(level.js.origin);
                }
                else
                {
                        player SetPlayerAngles(level.as.angles);
                        player SetOrigin(level.as.origin);
                }
        }
}


	knife_fail()
{
        level.knifefail = getent ("knife_alltp","targetname");
        level.js = getent ("knife_jt_go","targetname");
        level.as = getent ("knife_at_go","targetname");
        while(1)
        {
                level.knifefail waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {
                        player SetPlayerAngles(level.js.angles);
                        player SetOrigin(level.js.origin);
                }
                else
                {
                        player SetPlayerAngles(level.as.angles);
                        player SetOrigin(level.as.origin);
                }
        }
}

	
	snip_fail()
{
        level.snipfail = getent ("snip_alltp","targetname");
        level.js = getent ("snip_jt_go","targetname");
        level.as = getent ("snip_at_go","targetname");
        while(1)
        {
                level.snipfail waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {
                        player SetPlayerAngles(level.js.angles);
                        player SetOrigin(level.js.origin);
                }
                else
                {
                        player SetPlayerAngles(level.as.angles);
                        player SetOrigin(level.as.origin);
                }
        }
}


	
	dorsser69()
{
	trigger = getEnt ("trigger_dorsser69","targetname");
	object = getEnt ("dorsser69","targetname");
	// trigger waittill ("trigger", player);
	object rotateyaw (-140, 2);
	object waittill ("rotatedone");
	 /* [AUTO DELETE] iPrintlnBold("^2"+self.name+" ^5Opened Final Door^1!"); */
	 trigger SetHintString("^1Door is open");

	
}

	
	end_tp_rooms()
{
        level.rooms_trig = getEnt ("end_door","targetname");
	jump = getEnt("end_go","targetname");

	while(1)
	{
   		level.rooms_trig waittill( "trigger", player );
                if( !isDefined( level.rooms_trig ) )
                return;

		player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
		player died();
	}
}


	died()
{
        self endon("disconnect");
 
        self waittill("death");
        /* [AUTO DELETE] iPrintlnBold("^2"+self.name+" ^5died^1!"); */
}



	sniper_room_BATTLE()
{
        level.sniper_trig = getEnt( "sniproom_ent", "targetname");
        jump = getEnt( "sniproom_go", "targetname" );
        acti = getEnt( "sniproom_acti", "targetname" );
 
        while(1)
        {
                level.sniper_trig waittill( "trigger", player );
                level.activ thread snip_fail();
                thread snip_fail();
                if( !isDefined( level.sniper_trig ) )
                return;
 
                ambientStop("0");
                wait 0.05;
                /* [AUTO DELETE] ambientPlay("Followme"); */
 
                level.canPlaySound = false;
 		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Follow me - Tritonal feat. Underdown^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Follow me - Tritonal feat. Underdown^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Follow me - Tritonal feat. Underdown^2]] ^1>>>"); */
 
       
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                /* [AUTO DELETE] player TakeAllWeapons(); */
                /* [AUTO DELETE] player GiveWeapon( "m40a3_mp" ); */
                /* [AUTO DELETE] player givemaxammo( "m40a3_mp" ); */      
 
 
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                /* [AUTO DELETE] level.activ SetMoveSpeedScale(1); */
                /* [AUTO DELETE] level.activ TakeAllWeapons(); */
                /* [AUTO DELETE] level.activ GiveWeapon( "m40a3_mp" ); */
                /* [AUTO DELETE] level.activ givemaxammo( "m40a3_mp" ); */
 
                /* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Sniper room." ); */
                wait 0.05;
                /* [AUTO DELETE] player switchToWeapon( "m40a3_mp" ); */
                /* [AUTO DELETE] level.activ SwitchToWeapon( "m40a3_mp" ); */
                player freezecontrols(true);
                level.activ freezecontrols(true);
		player.health=100;
		level.activ.health=100;
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1FIGHT^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);
	
        }
}


	knife_room_BATTLE()
{
        level.knife_trig = getEnt( "kniferoom_ent", "targetname");
        jump = getEnt( "kniferoom_go", "targetname" );
        acti = getEnt( "kniferoom_acti", "targetname" );
 
        while(1)
        {
                level.knife_trig waittill( "trigger", player );
		level.activ thread knife_fail();
                thread knife_fail();
                if( !isDefined( level.knife_trig ) )
                return;
 
                ambientStop("0");
                wait 0.05 ;
                /* [AUTO DELETE] ambientPlay("rage"); */
 
                level.canPlaySound = false;
 
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Rage Valley - Knife Party^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Rage Valley - Knife Party^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Rage Valley - Knife Party^2]] ^1>>>"); */
 
       
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                /* [AUTO DELETE] player TakeAllWeapons(); */
                /* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */
               
 
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                /* [AUTO DELETE] level.activ SetMoveSpeedScale(1); */
                /* [AUTO DELETE] level.activ TakeAllWeapons(); */
                /* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */
                /* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Knife room." ); */
                wait 0.05;
                /* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
                /* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
                player freezecontrols(true);
                level.activ freezecontrols(true);
		player.health=100;
		level.activ.health=100;
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1FIGHT^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);
		 level.activ thread actiafker();
       
        }
}


	actiafker()
{ 
	object = getEnt ("knife_path","targetname");
	glass = getEnt ("knife_glass","targetname");
	self.oldOrigin = self.origin - (0,0,5);
	wait 15;
	if( distance(self.oldOrigin, self.origin) <= 10 )
	{
		glass delete();
		object movez (257,0.1);
		object waittill ("movedone");
		/* [AUTO DELETE] iPrintlnBold( " ^5Activator ^5is AFK, Path is now enabled in knife room" ); */
	}
}


	deagle_room_BATTLE()
{
        level.deagle_trig = getEnt( "deagleroom_ent", "targetname");
        jump = getEnt( "deagleroom_go", "targetname" );
        acti = getEnt( "deagleroom_acti", "targetname" );
 
        while(1)
        {
                level.deagle_trig waittill( "trigger", player );
                if( !isDefined( level.sniper_trig ) )
                return;
 
                ambientStop("0");
                wait 0.05;
                /* [AUTO DELETE] ambientPlay("desert"); */
 
                level.canPlaySound = false;
 
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Desert Eagle - Ratatat^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Desert Eagle - Ratatat^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Desert Eagle - Ratatat^2]] ^1>>>"); */
 
       
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                /* [AUTO DELETE] player TakeAllWeapons(); */
                /* [AUTO DELETE] player GiveWeapon( "deserteaglegold_mp" ); */
                /* [AUTO DELETE] player givemaxammo( "deserteaglegold_mp" ); */      
 
 
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                /* [AUTO DELETE] level.activ SetMoveSpeedScale(1); */
                /* [AUTO DELETE] level.activ TakeAllWeapons(); */
                /* [AUTO DELETE] level.activ GiveWeapon( "deserteaglegold_mp" ); */
                /* [AUTO DELETE] level.activ givemaxammo( "deserteaglegold_mp" ); */
 
                /* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Deagle room." ); */
                wait 0.05;
                /* [AUTO DELETE] player switchToWeapon( "deserteaglegold_mp" ); */
                /* [AUTO DELETE] level.activ SwitchToWeapon( "deserteaglegold_mp" ); */
                player freezecontrols(true);
                level.activ freezecontrols(true);
		player.health=100;
		level.activ.health=100;
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1FIGHT^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);

        }
}


	jump_room_BATTLE()
{
        level.jump_trig = getEnt( "jumproom_ent", "targetname");
        jump = getEnt( "jumproom_go", "targetname" );
        acti = getEnt( "jumproom_acti", "targetname" );
 
        while(1)
        {
                level.jump_trig waittill( "trigger", player );
		level.activ thread jump_fail();
                thread jump_fail();
                if( !isDefined( level.jump_trig ) )
                return;
 
                ambientStop("0");
                /* [AUTO DELETE] wait 0.05 ; */
                /* [AUTO DELETE] ambientPlay("bance"); */
 
                level.canPlaySound = false;
 
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Bounce - System Of a down^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Bounce - System Of a down^2]] ^1>>>"); */
                /* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Bounce - System Of a down^2]] ^1>>>"); */
 
       
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                /* [AUTO DELETE] player TakeAllWeapons(); */
                /* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */
               
 
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                /* [AUTO DELETE] level.activ SetMoveSpeedScale(1); */
                /* [AUTO DELETE] level.activ TakeAllWeapons(); */
                /* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */
                /* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Jump room." ); */
                /* [AUTO DELETE] wait 0.05; */
                /* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
                /* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
                player freezecontrols(true);
                level.activ freezecontrols(true);
		player.health=100;
		level.activ.health=100;
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1FIGHT^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);

        }
}


	jump_unlock()
{

	trigger = getent("endroom_unlock","targetname");
        wall = getent("secret_endroom","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] iPrintlnBold ("^3" + player.name +" ^1 Unlocked something...?"); */
	wall delete();
}


	    jump_room_gun_jumper()
{
        trigger = getEnt ( "jumper_ak47", "targetname" );
	object = getEnt ( "j_ak47","targetname");
        trigger waittill ( "trigger", player );
        wait 0.05;
	object delete();
        /* [AUTO DELETE] player giveWeapon ( "ak47_mp" ); */
        /* [AUTO DELETE] player giveMaxAmmo ( "ak47_mp" ); */
        /* [AUTO DELETE] player switchToWeapon ( "ak47_mp" ); */
        wait 1;
}


	jump_room_gun_acti()
{
        trigger = getEnt ( "acti_ak47", "targetname" );
	object = getEnt ( "a_ak47","targetname" );
        trigger waittill ( "trigger", player );
        wait 0.05;
	object delete();
        /* [AUTO DELETE] player giveWeapon ( "ak47_mp" ); */
        /* [AUTO DELETE] player giveMaxAmmo ( "ak47_mp" ); */
        /* [AUTO DELETE] player switchToWeapon ( "ak47_mp" ); */
        wait 1;
}


	jump_wall()
{
	trigger = getEnt ("wall_slid","targetname");
	object = getEnt ("jump_wall","targetname");
	trigger waittill ("trigger", player );
	object movez (-257,5);
	object waittill ("movedone");
}


	banana_move1()
{
	trigger = getEnt ("banana_move1","targetname");
	object = getEnt ("banana_move1_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object.origin, 3);
	banana waittill ("movedone");
}

	banana_move2()
{
	trigger = getEnt ("banana_move2","targetname");
	object = getEnt ("banana_move2_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object.origin, 3);
	banana rotateyaw (-90,3);
	banana waittill ("movedone");
}

	
	banana_move3()
{
	trigger = getEnt ("banana_move3","targetname");
	object1 = getEnt ("banana_move3_1_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object1.origin, 1.5);
	banana waittill ("movedone");
}


	banana_move3_1()
{
	trigger = getEnt ("banana_move3_1","targetname");
	object1 = getEnt ("banana_move4_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (45, 1.5);
	banana waittill ("rotatedone");
	banana moveto (object1.origin, 2);
	banana waittill ("movedone");
	banana rotateyaw (45, 1.5);
	banana waittill ("rotatedone");
}



	banana_move4()
{
	trigger = getEnt ("banana_move4","targetname");
	object = getEnt ("banana_move5_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object.origin, 1.5);
	banana waittill ("movedone");
}


	banana_move5()
{
	trigger = getEnt ("banana_move5","targetname");
	object1 = getEnt ("banana_move6_go","targetname");
	object2 = getEnt ("banana_move6_1_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (45,1.5);
	banana moveto (object1.origin, 1.5);
	banana waittill ("movedone");
	banana rotateyaw (-45,1.5);
	banana waittill ("rotatedone");
	banana moveto (object2.origin, 4);
	banana rotateyaw (-90,3);
	banana waittill ("rotatedone");
}


	banana_move6()
{
	trigger = getEnt ("banana_move6","targetname");
	object1 = getEnt ("banana_move7_go","targetname");
	object2 = getEnt ("banana_move7_1_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (45,1.5);
	banana moveto (object1.origin, 1.5);
	banana waittill ("movedone");
	banana rotateyaw (45,1.5);
	banana moveto (object2.origin, 1.5);
	banana waittill ("movedone");
}


	banana_move7()
{
	trigger = getEnt ("banana_move7","targetname");
	object = getEnt ("banana_move8_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object.origin, 3);
	banana waittill ("movedone");
}


	banana_move8()
{
	trigger = getEnt ("banana_move8","targetname");
	object = getEnt ("banana_move9_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object.origin, 1.5);
	banana waittill ("movedone");
}


	banana_move9()
{
	trigger = getEnt ("banana_move9","targetname");
	object = getEnt ("banana_move10_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (-45,3);
	banana moveto (object.origin, 2);
	banana waittill ("movedone");
	banana rotateyaw (90, 1.5);
	banana waittill ("rotatedone");
}

	
	banana_move10()
{
	trigger = getEnt ("banana_move10","targetname");
	object = getEnt ("banana_move11_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (45, 1.5);
	banana moveto (object.origin, 3);
	banana waittill ("movedone");
	banana rotateyaw (-90, 1.5);
	banana waittill ("rotatedone");
}


	banana_move11()
{
	trigger = getEnt ("banana_move11","targetname");
	object = getEnt ("banana_move11_1_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (90,4);
	banana moveto (object.origin, 4);
	banana waittill ("movedone");
	banana rotateyaw (-45, 1);
	banana waittill ("rotatedone");
}


	banana_move11_1()
{
	trigger = getEnt ("banana_move11_1","targetname");
	object = getEnt ("banana_move12_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana rotateyaw (90,2.5);
	banana waittill ("rotatedone");
	banana moveto (object.origin, 2.5);
	banana waittill ("movedone");
	banana rotateyaw (-45,1);
	banana waittill ("rotatedone");
}

	banana_move12()
{
	trigger = getEnt ("banana_move12","targetname");
	object1 = getEnt ("banana_move13_go","targetname");
	object2 = getEnt ("banana_move13_1_go","targetname");
	object3 = getEnt ("banana_move13_2_go","targetname");
	banana = getEnt ("banana","targetname");
	trigger waittill ("trigger", player );
	banana moveto (object1.origin, 1.5);
	banana waittill ("movedone");
	banana moveto (object2.origin, 3);
	banana waittill ("movedone");
	banana rotateyaw (200, 3);
	banana moveto (object3.origin, 3);
	banana waittill ("movedone");
}


	trap_01_1()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_01","targetname");
	object1 = getEnt ("trap_01_1","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	while(1)
	{
		object1 rotateyaw (-22.5, 4);
		object1 waittill ("rotatedone");
		object1 rotateyaw (22.5, 4);
		object1 waittill ("rotatedone");
	}
}


	trap_01_2()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_01","targetname");
	object1 = getEnt ("trap_01_2","targetname");
	trigger waittill ("trigger", player );
	while(1)
	{
		object1 rotateyaw (22.5, 4);
		object1 waittill ("rotatedone");
		object1 rotateyaw (-22.5, 4);
		object1 waittill ("rotatedone");
	}
}


	trap_02()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_02","targetname");
	object = getEnt ("trap_02","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	while(1)
	{
		object rotatepitch (360,5);
		object waittill ("rotatedone");
	}
}


	trap_02_2()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_02_2","targetname");
	object = getEnt ("trap_02_2","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object delete();
}


	trap_03()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_03","targetname");
	object = getEnt ("trap_03","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object delete();
}


	trap_04()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_04","targetname");
	object1 = getEnt ("trap_04_1","targetname");
	object2 = getEnt ("trap_04_2","targetname");
	object3 = getEnt ("trap_04_3","targetname");
	object4 = getEnt ("trap_04_4","targetname");
	object5 = getEnt ("trap_04_5","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");

	i = randomintrange( 0, 7 );
	if(i == 0)
	{
		object1 notSolid();
		object4 notSolid();
		object3 notSolid();
	}
	else if(i == 1)
	{
		object2 notSolid();
		object5 notSolid();
		object3 notsolid();
	}
	else if(i == 2)
	{
		object1 notSolid();
		object5 notSolid();
		object4 notSolid();	
	}
	else if(i == 3)
	{
		object3 notSolid();
		object1 notSolid();
		object5 notSolid();	
	}
	else if(i == 4)
	{
		object5 notSolid();
		object2 notSolid();
		object4 notSolid();	
	}
	else if(i == 5)
	{
		object4 notSolid();
		object3 notSolid();
		object2 notSolid();
	}
	else if(i == 6)
	{
		object1 notSolid();
		object3 notSolid();
		object2 notSolid();
	}
	else if(i == 7)
	{
		object1 notSolid();
		object3 notSolid();
		object2 notSolid();
	}
}


	trap_05_1()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object1 = getEnt ("trap_05_1","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object1 movex (40, 2);
	while(1)
	{
	
		object1 waittill ("movedone");
		object1 movex (-80, 2);
		object1 waittill ("movedone");
		object1 movex (80, 2);
	}
}


	trap_05_2()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object2 = getEnt ("trap_05_2","targetname");
	trigger waittill ("trigger", player );
	object2 movex (-40, 0.5);
	while(1)
	{
		object2 waittill ("movedone");
		object2 movex (80, 2);
		object2 waittill ("movedone");
		object2 movex (-80, 2);
	}
}


	trap_05_3()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object3 = getEnt ("trap_05_3","targetname");
	trigger waittill ("trigger", player );
	object3 movex (40, 3);
	while(1)
	{
		object3 waittill ("movedone");
		object3 movex (-80, 2);
		object3 waittill ("movedone");
		object3 movex (80, 2);
	}
}


	trap_05_4()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object4 = getEnt ("trap_05_4","targetname");
	trigger waittill ("trigger", player );
	object4 movex (-40, 1.5);
	while(1)
	{
		object4 waittill ("movedone");
		object4 movex (80, 2);
		object4 waittill ("movedone");
		object4 movex (-80, 2);
	}
}


	trap_05_11()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object1 = getEnt ("trap_05_1","targetname");
	trigger waittill ("trigger", player );
	object1 rotatepitch (15, 3);
	while(1)
	{
	
		object1 waittill ("rotatedone");
		object1 rotatepitch (-30, 2);
		object1 waittill ("rotatedone");
		object1 rotatepitch (30, 2);
	}
}


	trap_05_22()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object2 = getEnt ("trap_05_2","targetname");
	trigger waittill ("trigger", player );
	object2 rotatepitch (-15, 1.5);
	while(1)
	{
		object2 waittill ("rotatedone");
		object2 rotatepitch (30, 2);
		object2 waittill ("rotatedone");
		object2 rotatepitch (-30, 2);
	}
}


	trap_05_33()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object3 = getEnt ("trap_05_3","targetname");
	trigger waittill ("trigger", player );
	object3 rotatepitch (15, 0.5);
	while(1)
	{
		object3 waittill ("rotatedone");
		object3 rotatepitch (-30, 2);
		object3 waittill ("rotatedone");
		object3 rotatepitch (30, 2);
	}
}


	trap_05_44()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_05","targetname");
	object4 = getEnt ("trap_05_4","targetname");
	trigger waittill ("trigger", player );
	object4 rotatepitch (-15, 2);
	while(1)
	{
		object4 waittill ("rotatedone");
		object4 rotatepitch (30, 2);
		object4 waittill ("rotatedone");
		object4 rotatepitch (-30, 2);
	}
}


	trap_06()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_06","targetname");
	object1 = getEnt ("trap_06","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object1 delete();
}


	trap_07()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_07","targetname");
	object1 = getEnt ("trap_07","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object1 notSolid();
}

	trap_08()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_08","targetname");
	object = getEnt ("trap_08","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	while(1)
	{
		object rotatepitch (360,5);
		object waittill ("rotatedone");
	}
}

	trap_09()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_09","targetname");
	object = getEnt ("trap_09","targetname");
	object1 = getEnt ("trap_09_1","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object1 delete();
	while(1)
	{
		object movex (160,2);
		object waittill ("movedone");
		object movex (-160,2);
		object waittill("movedone");
	}
}


	trap_10()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_10","targetname");
	object = getEnt ("trap_10","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object delete();
}


	trap_10_1()
{
	level endon("trigger");
	trigger = getEnt ("trigger_trap_10_1","targetname");
	object = getEnt ("trap_10_1","targetname");
	object2 = getEnt ("killtrig_10_69","targetname");
	killtrig = getEnt ("killtrig_10_1","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object delete();
	killtrig enablelinkto ();
	killtrig linkto (object2);
	object2 movez (512,0.1);
	object2 waittill ("movedone");
}


	trap_11()
{
	level endon("trigger");
	
	trigger = getEnt ("trigger_trap_11","targetname");
	object = getEnt ("trap_11","targetname");
	mover = getEnt ("trap_11_mover","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
        trigger SetHintString("^1Activated");
	object delete();
	while(1)
	{
		mover movex (-364,4);
		mover waittill ("movedone");
		mover movex (364,4);
		mover waittill ("movedone");
	}
}


	s_fail1()
{
	trig = getEnt ("s_fail1", "targetname");
	end = getEnt ("s_fail1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


	s_fail2()
{
	trig = getEnt ("s_fail2", "targetname");
	end = getEnt ("s_fail2_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


	s_fail3()
{
	trig = getEnt ("s_fail3", "targetname");
	end = getEnt ("s_fail3_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


	s_fail4()
{
	trig = getEnt ("s_fail4", "targetname");
	end = getEnt ("s_fail4_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


	s_fail5()
{
	trig = getEnt ("s_fail5", "targetname");
	end = getEnt ("s_fail5_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


	s_fail6()
{
	trig = getEnt ("s_fail6", "targetname");
	end = getEnt ("s_fail6_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


	vcmover()
{
	object = getEnt ("vcmover","targetname");
	wait 1;
	while(1)
	{
		object movez (130,4);
		object waittill ("movedone");
		object movez (-130,4);
		object waittill ("movedone");
	}
}


	acti_end_trigger()
{
	trig = getEnt ("acti_end_trigger", "targetname");
	end = getEnt ("acti_end_trigger_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}
