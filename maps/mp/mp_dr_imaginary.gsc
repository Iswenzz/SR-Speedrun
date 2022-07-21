main()

{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
maps\mp\_load::main();

  precacheItem("m40a3_mp"); 
  precacheItem("knife_mp");

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
				// addTriggerToList( "trap1_trig" );
				// addTriggerToList( "trap2_trig" );
				// addTriggerToList( "trap3_trig" );
				// addTriggerToList( "trap4_trig" );
				// addTriggerToList( "trap5_trig" );
				// addTriggerToList( "trap6_trig" );
				// addTriggerToList( "trap7_trig" );
				// addTriggerToList( "trap8_trig" );
				// addTriggerToList( "trap9_trig" );
				// addTriggerToList( "trap10_trig" );
				// addTriggerToList( "trap11_trig" );
				// addTriggerToList( "trap12_trig" );

thread way_connect();				
thread weapon();
// thread trap1(); 
// thread trap2();
// thread elevator1();
// thread elevator2();
// thread elevator3();
// thread elevator4();
// thread elevator5();
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
// thread schuifding();
thread cave_spinner();
thread teleporter_thread();
// thread topbar();
// thread sniper();
// thread bouncefight();
// thread trigsoda1();
// thread trigsoda2();
// thread bounceroom_3rdstage_jumpertp();
// thread bounceroom_3rdstage_actitp();
// thread knife();
// thread old();
// thread old_elevator();
// thread old_elevator2();
thread Secret_Jumper();
thread secret_jumper_door();
thread secret_jumper_level1_fail();
// thread secret_activator();
// thread song4();
// thread song5();
// thread song6();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
} 


weapon()
{
	ak = getEnt("ak","targetname");
	dragunov = getEnt("dragunov","targetname");
	
	{
		ak ItemWeaponSetAmmo(5,150);
		dragunov ItemWeaponSetAmmo(5,20);
	}
}

trap1()
{
	bounce = getEnt("trap1_bounce","targetname");
	trig = getEnt("trap1_trig","targetname");

	trig waittill("trigger");
	{
		trig setHintString ("^4Activated!"); 
		bounce moveZ(-192,2);
		wait(4);
		bounce moveZ(192,2);
		bounce waittill("movedone");
	}
}

trap2()
{
	cylinder = getEnt("trap2_cylinder","targetname");
	trig = getEnt("trap2_trig","targetname");
	
	trig waittill("trigger"); 
	
	while(1) 
	{
		trig setHintString ("^4Activated!"); 
		cylinder rotateyaw(360,1); 
		cylinder waittill("rotatedone");
		
	}
}

elevator1()
{
	elevator = getEnt("elevator1","targetname");
	
	
	while(1)
	{
		elevator moveY(1129,6);
		elevator waittill("movedone");
		elevator moveY(-1129,6);
		elevator waittill("movedone");

	}
}

elevator2()
{
	elevator = getEnt("elevator2","targetname");

	while(1)
	{
		elevator moveY(-1129,6);
		elevator waittill("movedone");
		elevator moveY(1129,6);
		elevator waittill("movedone");

	}
}

elevator3()
{
	elevator = getEnt("elevator3","targetname");

	while(1)
	{
		elevator moveY(1129,6);
		elevator waittill("movedone");
		elevator moveY(-1129,6);
		elevator waittill("movedone");
	}
}

elevator4()
{
	elevator = getEnt("elevator4","targetname");

	while(1)
	{
		elevator moveY(-1129,6);
		elevator waittill("movedone");
		elevator moveY(1129,6);
		elevator waittill("movedone");
	}
}


elevator5()
{
	trig = getEnt("elevator5_trig","targetname");
	elevator = getEnt("elevator5","targetname");

	while(1)
	{
		trig waittill ("trigger");
		elevator moveZ(128,2);
		elevator waittill("movedone");
		wait (3);
		elevator moveZ(-128,2);
		elevator waittill("movedone");
		wait (3);
	}
}

trap3()
{
	spikes = getEnt("trap3_spikes","targetname" );
	trig = getEnt("trap3_trig","targetname");
	hurt = getEnt("trap3_hurt","targetname");
	
	trig waittill("trigger"); 
	{
		trig setHintString ("^4Activated!"); 
		
		hurt enablelinkto();
		hurt linkto(spikes); 

		spikes moveZ(180,0.8);
		wait(4);
		spikes moveZ(-180,3);
		spikes waittill("movedone");
	}
}

trap4()
{
	trig = getEnt("trap4_trig","targetname");
	platform = getEnt("trap4_platform","targetname");
	
	trig waittill ("trigger");
	
	while(1)
	{
		trig setHintString ("^4Activated!"); 
		platform hide();
		platform notsolid();
		wait(5);
		platform solid();
		platform show();
		wait(5);
	}
}

schuifding()
{
	schuif= getEnt("schuiven5","targetname");

	while(1)
	{
		schuif moveY(-687,2.2);
		schuif waittill("movedone");
		wait(5);
		schuif moveY(687,2.2);
		schuif waittill("movedone");
		wait(5);
	}
}

trap5()
{
	squares = getEnt("trap5_squares","targetname");
	trig = getEnt("trap5_trig","targetname");
	
	trig waittill ("trigger");
	
	while(1)
	{
		trig setHintString ("^4Activated!"); 
		squares rotateYaw(360,2);
		wait(4);
		squares rotateYaw(-360,2);
		wait(4);
	}	
}

trap6()
{
	bounce = getEnt("trap6_bounce","targetname");
	trig = getEnt("trap6_trig","targetname");
	
	trig waittill ("trigger");
	trig setHintString ("^4Activated!"); 
	
	while(1)
	{
		bounce rotateYaw(360,3);
		wait(6);
	}	
}

trap7()
{
	trig = getEnt("trap7_trig","targetname");
	muur1_1 = getEnt("muur1_1","targetname");
	muur1_2 = getEnt("muur1_2","targetname");
	muur2 = getEnt("trap7_muur2","targetname");
	stairs1 = getEnt("trap7_stair1","targetname");
	stairs2 = getEnt("trap7_stair2","targetname");
	stairs3 = getEnt("trap7_stair3","targetname");
	stairs4 = getEnt("trap7_stair4","targetname");
	
	trig waittill("trigger");
	trig setHintString ("^4Activated!"); 
	{
	muur1_2 moveY(575,4);
	muur1_1 moveY(210,4);
	muur2 moveY(-896,4);
	stairs1 moveX(-92,4);
	stairs2 moveX(-69,4);
	stairs3 moveX(-46,4);
	stairs4 moveX(-23,4);
	}
}

trap8()
{
	trig = getEnt("trap8_trig","targetname");
	blok = getEnt("trap8_blok","targetname");
	
	trig waittill("trigger");
	trig setHintString ("^4Activated!"); 
	{
	blok hide();
	blok notsolid();
	}
}

trap9()
{
	trig = getEnt("trap9_trig","targetname");
	blok = getEnt("trap9_blok","targetname");
	
	trig waittill("trigger");
	trig setHintString ("^4Activated!"); 
	 
	while(1)
	{
		blok rotatePitch(180,1);
		wait(4);
	}
}

trap10()
{
	trig = getEnt("trap10_trig","targetname");
	squares1 = getEnt("trap10_squares1","targetname");
	squares2 = getEnt("trap10_squares2","targetname");
	
	trig waittill("trigger");
	trig setHintString ("^4Activated!"); 
	squares1 moveZ(-150,1);
	squares1 waittill("movedone");
	
	while(1)
	{
	wait(2);
	squares1 moveZ(150,1);
	squares2 moveZ(-150,1);
	wait(2);
	squares1 moveZ(-150,1);
	squares2 moveZ(150,1);

	}
}

trap11()
{
	trig = getEnt("trap11_trig","targetname");
	windows = getEnt("trap11_windows","targetname");
	
	trig waittill("trigger");
	trig setHintString ("^4Activated!"); 
	windows moveZ(90,2);
	windows waittill("movedone");
	
	while(1)
	{
	windows moveZ(-200,2);
	windows waittill("movedone");
	windows moveZ(200,2);
	windows waittill("movedone");
	}
	
}

trap12()
{
	trig = getEnt("trap12_trig","targetname");
	stairs1 = getEnt("trap12_stairs1","targetname");
	stairs2 = getEnt("trap12_stairs2","targetname");
	stairs3 = getEnt("trap12_stairs3","targetname");
	
	trig waittill("trigger");
	trig setHintString ("^4Activated!"); 
	
	while(1){
	stairs1 moveZ(-320,2);
	wait(2);
	stairs2 moveZ(-320,2);
	wait(2);
	stairs3 moveZ(-320,2);
	wait(2);
	stairs1 moveZ(320,2);
	wait(2);
	stairs2 moveZ(320,2);
	wait(2);
	stairs3 moveZ(320,2);
	wait(2);
	}
}


cave_spinner()
{
	spinner = getEnt("cave_spin","targetname");
	
	
}

//teleporters
teleporter_thread () 
{

	entTransporter= getentarray("teleport","targetname");
	if(isdefined(entTransporter))
 
		{
			for(lp=0; lp<entTransporter.size;lp=lp+1)
			entTransporter [lp] thread teleporter();
		}
}


teleporter()
{
  while(true)
 {
    self waittill("trigger",other);
    entTarget = getent(self.target, "targetname");

    other setorigin(entTarget.origin);
    other setplayerangles(entTarget.angles);
   
   }
}


//topbar
	topbar()
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
			self.logoText setText("^7Map Made By: ^7ix'.Fresh ^3and ^4ix'.Robin");
			wait 2;
			self.logoText fadeOverTime(1);
			self.logoText.alpha = 0;
			wait 9;
			self.logoText fadeOverTime(1);
			self.logoText.alpha = 1;
			self.logoText setText("^7Xfire: ^4jehoofd4(robin) and marco02374(fresh)");
			wait 8;
			self.logoText fadeOverTime(1);
			self.logoText.alpha = 0;
			wait 4;
		}
	}

//////////////// END ROOMS


sniper()
{
level.teleactorigin7 = getEnt("sniper_activator", "targetname"); //origin from activator teleport place 
telejumporigin7 = getEnt("sniper_jumper", "targetname"); //origin from jumper teleport place 
level.bounce_trigger = getEnt("trigger_bounce", "targetname"); //Room enter trigger (door)
level.sniper_trigger = getEnt("trigger_sniper","targetname");
level.knife_trigger = getEnt("trigger_knife","targetname");
level.old_trigger = getEnt("trigger_old","targetname");
while(1)
{
level.sniper_trigger waittill("trigger", player);

ambientPlay("sniperRoom_runit");

level.bounce_trigger delete();
level.knife_trigger delete();
level.old_trigger delete();


if(!isDefined(level.sniper_trigger))
            return;
    if(level.firstenter==true)
{
		level.bounce_trigger delete();
		level.old_trigger delete();
		level.knife_trigger delete();
		level.firstenter=false;
		}	
		wait(0.05);
player SetOrigin( telejumporigin7.origin );
player setplayerangles( telejumporigin7.angles );
player TakeAllWeapons();
player GiveWeapon("m40a3_mp"); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin7.origin);
level.activ setplayerangles (level.teleactorigin7.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "m40a3_mp" ); 
wait(0.05);
player switchToWeapon( "m40a3_mp" );
level.activ SwitchToWeapon( "m40a3_mp" );
level.telejumporigin delete();
iPrintlnBold( " ^7" +  player.name  + " ^3 HAS ENTERED THE SNIPER ROOM^7!" ); //Change the message if you want
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

bouncefight()
{
level.teleactorigins = getEnt("bounce_activator_start", "targetname"); //origin from activator teleport place 
telejumporigins = getEnt("bounce_jumper_start", "targetname"); //origin from jumper teleport place
level.bounce_trigger = getEnt("trigger_bounce", "targetname"); //Room enter trigger (door)
level.sniper_trigger = getEnt("trigger_sniper","targetname");
level.knife_trigger = getEnt("trigger_knife","targetname");
level.old_trigger = getEnt("trigger_old","targetname");
trig2 = getEnt("player_suicide","targetname");
trig1 = getEnt("activator_suicide","targetname");



while(1)
{
level.bounce_trigger waittill("trigger", player);
level.sodaguy = player;

		level.sniper_trigger delete();
		level.knife_trigger delete();
		level.old_trigger delete();


ambientPlay("bounceRoom_runit");


if(!isDefined(level.bounce_trigger))
            return;
    if(level.firstenter==true)
		{
		level.firstenter=false;
		}	
		wait(0.05);
player setOrigin( telejumporigins.origin );
player setplayerangles( telejumporigins.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigins.origin);
level.activ setplayerangles (level.teleactorigins.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telejumporigin delete();
iPrintlnBold( " ^7" + player.name + " ^3 HAS ENTERED THE BOUNCE ROOM^7!" ); 
				
while( isAlive( player ) && isDefined( player ) )
            wait 1;
        }
}


trigsoda1()
{
trig_sodamachine6 = getEnt("bounceroom_sodamachine1","targetname");

while(1)
	{
	     trig_sodamachine6 waittill("trigger", player);
         player iPrintlnBold( "you won!" ); 	
         level.activ suicide();          
	}
}

trigsoda2()
{
	trig_sodamachine8 = getEnt("bounceroom_sodamachine3","targetname");
	
while(1)
{
	trig_sodamachine8 waittill("trigger", player);
	player iPrintlnBold("you won!"); 
	level.sodaguy suicide();			
}
}

bounceroom_3rdstage_jumpertp()
{

	trig = getEnt("bounceroom_to3rdstage_tp2","targetname");
	origin_3rd_stage = getEnt("teleport_3st_stage_jumper","targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		player SetOrigin( origin_3rd_stage.origin );
		player setplayerangles( origin_3rd_stage.angles );
		player TakeAllWeapons();
		player GiveWeapon("m40a3_mp"); 
		wait(0.05);
		player switchToWeapon( "m40a3_mp" );
	}	
}

bounceroom_3rdstage_actitp()
{
		trig = getEnt("bounceroom_to3rdstage_tp1","targetname");
		origin_3rd_stage = getEnt("teleport_3st_stage_acti","targetname");

	while(1)
	{
		trig waittill("trigger", player );
		player SetOrigin( origin_3rd_stage.origin );
		player setplayerangles( origin_3rd_stage.angles );
		player TakeAllWeapons();
		player GiveWeapon("m40a3_mp"); 
		wait(0.05);
		player switchToWeapon( "m40a3_mp" );///laat me ff iets veranderen bij de bounce script :D daar irriteer ik me aan :D. ok
	}
}

knife()
{
level.teleactoriginss = getEnt("knife_activator", "targetname"); //origin from activator teleport place 
telejumporiginss = getEnt("knife_jumper", "targetname"); //origin from jumper teleport place 
level.bounce_trigger = getEnt("trigger_bounce", "targetname"); //Room enter trigger (door)
level.sniper_trigger = getEnt("trigger_sniper","targetname");
level.knife_trigger = getEnt("trigger_knife","targetname");
level.old_trigger = getEnt("trigger_old","targetname");
while(1)
{
level.knife_trigger waittill("trigger", player);

		level.sniper_trigger delete();
		level.bounce_trigger delete();
		level.old_trigger delete();

ambientPlay("knifeRoom_runit");

if(!isDefined(level.knife_trigger))
            return;
    if(level.firstenter==true)
{


		}	
		wait(0.05);
player SetOrigin( telejumporiginss.origin );
player setplayerangles( telejumporiginss.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactoriginss.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telejumporigin delete();
iPrintlnBold( " ^7" + player.name + " ^3 HAS ENTERED THE KNIFE ROOM^7!" ); //Change the message if you want
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}


old()
{
level.teleactorigin = getEnt("bounce_activator_start", "targetname"); //origin from activator teleport place 
telejumporigin = getEnt("bounce_jumper_start", "targetname"); //origin from jumper teleport place 
level.bounce_trigger = getEnt("trigger_bounce", "targetname"); //Room enter trigger (door)
level.sniper_trigger = getEnt("trigger_sniper","targetname");
level.knife_trigger = getEnt("trigger_knife","targetname");
level.old_trigger = getEnt("trigger_old","targetname");
classicPlatform = getEnt("classic_platform","targetname");
classicDoor = getEnt("classic_door","targetname");
	
{
level.old_trigger waittill("trigger", player);

	level.sniper_trigger delete();
	level.bounce_trigger delete();
	level.knife_trigger delete();
	level.old_trigger delete();

iPrintlnBold( " ^7" + player.name + " ^3 Entered Classic^7!" ); //Change the message if you want

	classicPlatform moveZ(319,4);
		classicPlatform waittill("movedone");
		classicDoor moveX(73,4);
		classicDoor waittill("movedone");

}
}


old_elevator()
{
	classicElevator = getEnt("classic_elevator3","targetname");
	trig= getEnt("classic_elevator_trigger3","targetname");
	
	while(1)
	{
		trig waittill ("trigger");
		wait(1.5);
		classicElevator moveX(-4466,7);
		classicElevator waittill("movedone");
		wait(3);
		classicElevator moveX(4466,7);
		classicElevator waittill("movedone");
	}
}

old_elevator2()
{
	elevator = getEnt("classic_elevator2","targetname");
	trig = getEnt("classic_elevator_trigger2","targetname");
	
	while(1)
	{
		trig waittill("trigger");
		wait(1.5);
		elevator moveX(7437,8);
		elevator waittill("movedone");
		wait(3);
		elevator moveX(-7437,8);
		elevator waittill("movedone");
	}
}



//SECRETTTTTT
Secret_Jumper()
{
	trig1entrance = getEnt("secret_entrance1","targetname");
	trig2entrance = getEnt("secret_entrance2","targetname");
	trig3entrance = getEnt("secret_entrance3","targetname");
	trig4entrance = getEnt("secret_entrance4","targetname");
	SecretEntrOrig = getEnt("teleport_secret_entrance","targetname");
	
	while(1)
	{
		trig4entrance waittill( "trigger", player );
	
		
		
		
		player SetPlayerAngles( SecretEntrOrig.angles );
        player setOrigin( SecretEntrOrig.origin );
		
		
		thread secretfailsystem(player);
		
	}
}

secretfailsystem(player)
{
	trig1 = getEnt("secret_level1_failtp","targetname");
	trig2 = getEnt("level1_room1","targetname");
	trig3 = getEnt("level1_room2","targetname");
	trig4 = getEnt("level1_room3","targetname");
	trig5 = getEnt("level1_room4","targetname");
	trig6 = getEnt("level2_room1","targetname");
	trig7 = getEnt("level2_room2","targetname");
	trig8 = getEnt("level2_room3","targetname");
	trig9 = getEnt("level2_room4","targetname");

	
{
		
		// player iPrintlnBold("^2Welcome to the secret room! ^1" + player.name + " ^3. Have fun!" );
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste		
}
}


secret_jumper_door()
{
	trigRandomPerson = getEnt("secret_randomPerson_trig","targetname");
	Secr_door = getEnt("secret_door","targetname");
	SecretEntrOrig = getEnt("teleport_secret_entrance","targetname");
	
	{
		// trigRandomPerson waittill("trigger", player);
		// player iPrintlnBold("^2You opened a door???!!!!");  
		Secr_door moveZ(-220,1);
		Secr_door waittill("movedone");	
		// wait(10);
		// trigRandomPerson setHintString ("^4Door is already open:D"); 
	}
}

secret_jumper_level1_fail()
{
		Secr_lvl1_failtp = getEnt("secret_level1_failtp","targetname");
		SecretEntrOrig = getEnt("teleport_secret_entrance","targetname");
		
	while(1)
	{
		Secr_lvl1_failtp waittill("trigger", player );
		player SetPlayerAngles( SecretEntrOrig.angles );
        player setOrigin( SecretEntrOrig.origin );
	}
}

secret_activator()
{
	trig1 = getEnt("secret_activator_trap1","targetname");
	trig2 = getEnt("secret_activator_trap2","targetname");
	trig3 = getEnt("secret_activator_trap3","targetname");
	trig4 = getEnt("secret_activator_trap4","targetname");
	trig5 = getEnt("secret_activator_trap5","targetname");
	trig6 = getEnt("secret_activator_trap6","targetname");
	{
	
	trig1 waittill("trigger", player );
	trig2 waittill("trigger", player );
	trig3 waittill("trigger", player );
	trig4 waittill("trigger", player );
	trig5 waittill("trigger", player );
	trig6 waittill("trigger", player );
	   
			player TakeAllWeapons();
			player GiveWeapon("m40a3_mp"); 
			wait(0.05);
			player switchToWeapon( "m40a3_mp" );
}
}


song4()
	{
	level.song4 = getent ("song4", "targetname");
	while(true)
	{
	level.song4 waittill("trigger", player);
	level.song4 delete();
	level.song5 delete();
	level.song6 delete();
	
	wait (0.05);
	AmbientStop(1);
	wait 0.05;
	AmbientPlay("song4");
	wait (1);
	iprintln("^1>>^4Now Playing: Stephen Swartz -- Bullet Train  ^1<<");
	iprintln("^1>>^4Now Playing: Stephen Swartz -- Bullet Train  ^1<<");
	iPrintlnBold("^1" + player.name + " ^3 choosed Stephen Swartz -- Bullet Train !!" ); 
}
}



	song5()
	{
	level.song5 = getent ("song5", "targetname");
	while(true)
	{
	level.song5 waittill("trigger", player);
	level.song4 delete();
	level.song5 delete();
	level.song6 delete(); 
	
	wait (0.05);
	AmbientStop(1);
	wait 0.05;
	AmbientPlay("song5");
	wait (1);
	iprintln("^1>>^4Now Playing: Brennan Heart & Jonathan Mendelsohn - Imaginary ^1<<");
	iprintln("^1>>^4Now Playing: Brennan Heart & Jonathan Mendelsohn - Imaginary ^1<<");
	iPrintlnBold("^1" + player.name + " ^3 choosed Brennan Heart & Jonathan Mendelsohn - Imaginary !!" );  
}	
}

song6()
	{
	level.song6 = getent ("song6", "targetname");
	while(true)
	{
	level.song6 waittill("trigger", player);
	level.song4 delete();
	level.song5 delete();
	level.song6 delete(); 
	
	AmbientStop(1);
	wait 0.05;
	AmbientPlay("song6");
	wait (1);
	iprintln("^1>>^4Now Playing: Headhunterz feat. Krewella - United Kids of the World ^1<<");
	iprintln("^1>>^4Now Playing: Headhunterz feat. Krewella - United Kids of the World ^1<<");
	iPrintlnBold("^1" + player.name + " ^3 choosed Headhunterz feat. Krewella - United Kids of the World !!" ); 
}
}




