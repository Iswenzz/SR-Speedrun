//////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//     _______     _____     ___    _______________     ___     ___     ___      ___     ___       ___     \\
//    |     \ \   /     |   |   |  |               |   |   |   |   |   |   \    /   |   \   \    /   /     \\
//	  |      \ \ /      |   |   |  |_____     _____|   |   |___|   |    \   \__/   /     \   \__/   /      \\
//	  |   |\  \_/  /|   |   |   |        |   |         |           |     \        /       \        /       \\          Youtube:https://www.youtube.com/channel/UCLPUQ9wxNmnPcNcHxPkblrA
//	  |   | \  	  / |   |   |   |        |   |         |    ___    |      \      /        /   __   \       \\
//	  |   | |\___/  |   |   |   |        |   |         |   |   |   |       |    |        /   /  \   \      \\
//	  |___|/        |___|   |___|        |___|         |___|   |___|       |____|       /___/    \___\     \\
//		                                                                                                   \\
//////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//     _______     _____                                                             _______     _____     \\
//    |     \ \   /     |                                                           |     \ \   /     |    \\
//    |      \ \ /      |                        Map by MiThyX                      |      \ \ /      |    \\
//    |   |\  \_/  /|   |                      Script by MiThyX                     |   |\  \_/  /|   |    \\
//    |   | \  	  / |   |                                                           |   | \     / |   |    \\
//    |   | |\___/  |   |                        Steam: MiThyX                      |   | |\___/  |   |    \\
//    |___|/        |___|                                                           |___|/        |___|    \\
//                                                                                                         \\
//////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

// © 2021 - MiThyX TOUS DROITS RÉSERVÉS - ALL RIGHT RESERVED

main()
{
 maps\mp\_load::main();
 
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 thread speedrun\_way_name::create_normal_way("Normal Way;");
 
	PreCacheShader( "neuschwansteinlogo" );
    PreCacheShader( "unavion" );
    PreCacheShader( "unpigeon" );
	precachemenu("menuroom");
 
	level.fire = loadFx("fire/firelp_med_streak_pm_h");
	
	//TRIGGERS//
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap4" );
	
	level.go = true;
	level.go4 = true;
	level.waittp = 0;
	level.musicplaying = false;
	level.firstenter = true;
	
	level.music=[];

	level.music[0]["song"]	="Axwell Λ Ingrosso - Dreamer";
	level.music[0]["alias"]	="music4";
	level.music[1]["song"]	="First Of The Year (Equinox) - Skrillex";
	level.music[1]["alias"]	="music1";
	level.music[2]["song"]	="Dua Lipa & Angele - Fever";
	level.music[2]["alias"]	="music2";
	level.music[3]["song"]	="David Guetta & Sia - Let's Love";
	level.music[3]["alias"]	="music3";
	level.music[4]["song"]	="Skrillex - Scary Monsters And Nice Sprites";
	level.music[4]["alias"]	="music0";
	level.music[5]["song"]	="G-Eazy & Halsey - Him & I";
	level.music[5]["alias"]	="music5";
	
	thread guidcheckgod();
	thread tpacti1();
	thread tpacti2();
	thread timertp();
	thread trap1();
	thread trap1trap();
	thread trap2();
	thread trap4();
	thread trap4trap();
	thread overlay();
	thread porte();
	thread credits();
	thread autorotate();
	thread autorotate2();
	thread autorotatedroite();
	thread autorotategauche();
	thread secret();
	thread secret2();
	thread secret4();
	thread secretjumpfail();
	thread secretjumpfail2();
	thread secretjumpfail3();
	thread endsecret();
	thread endtrigger();
	thread snipertp();
	thread knifetp();
	thread old();
	thread musictrig();
	thread partymusic();

}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

guidcheckgod()
{
god1 = "5b4d3eec";
sanictrig = getent("mithyx_check","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = getSubStr(user getGuid(), 24, 32);
		if(tempGuid == god1)
		{
			wait 1;
			iPrintLnBold(user.name + " Map ^5Creator ^7is ^2Connected ^7!!");
			wait 1;
		}
		
    sanictrig delete();	
	}
}

tpacti1()
{
	origintp1 = getent("origin_tp_acti2","targetname");
	level.trigtp1 = getent("trig_tp_acti1","targetname");
	while(1)
	{
		if(level.waittp == 0)
		{
			level.trigtp1 SetHintString("^5 [use] ");
			level.trigtp1 waittill("trigger", player);
			if(level.waittp == 0)
			{
				level.waittp = 5;
				player SetOrigin( origintp1.origin );
				player setplayerangles( origintp1.angles );
			}
		}
		wait 1;
	}
	
}

tpacti2()
{
	origintp2 = getent("origin_tp_acti1","targetname");
	level.trigtp2 = getent("trig_tp_acti2","targetname");
	while(1)
	{
		if(level.waittp == 0)
		{
			level.trigtp2 SetHintString("^5 [use] ");
			level.trigtp2 waittill("trigger", player);
			if(level.waittp == 0)
			{
				level.waittp = 5;
				player SetOrigin( origintp2.origin );
				player setplayerangles( origintp2.angles );
			}
		}
		wait 1;
	}
}

timertp()
{
	while(1)
	{
		if(level.waittp == 5)
		{
			for(i = level.waittp; i!=0; i--)
			{
				level.trigtp2 SetHintString("^5 Wait : "+i+" seconds");
				level.trigtp1 SetHintString("^5 Wait : "+i+" seconds");
				wait 1;
				level.waittp--;
			}
			level.trigtp1 SetHintString("^5 [use] ");
			level.trigtp2 SetHintString("^5 [use] ");
			level.waittp = 0;
		}
		wait 1;
	}
}

trap1()
{
	block28 = getent("rotatedroite28","targetname");
	while(level.go)
	{
		block28 rotateYaw(20, 1);
		wait 1;
	}
	if(!level.go)
	{
		while(!level.go)
		{
			block28 rotateYaw(-20, 1);
			wait 1;
		}
	}
	
}

trap1trap()
{
	trig = getEnt("trig_trap1", "targetname");
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 200);
	level.go=false;
}

trap2()
{
	block1 = getent("trap4_1","targetname");
	block2 = getent("trap4_2","targetname");
	trig = getEnt("trig_trap2", "targetname");
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 200);
	block1 moveZ(-25,1);
	block2 moveZ(25,1);
	
	while(1)
	{
		wait 2;
		block1 moveZ(50,2);
		block2 moveZ(-50,2);
		wait 2;
		block1 moveZ(-50,2);
		block2 moveZ(50,2);
	}
}

trap4()
{
	block29 = getent("rotatedroite29","targetname");
	block30 = getent("rotatedroite30","targetname");
	block26 = getent("rotategauche26","targetname");
	while(level.go4)
	{
		block29 rotateYaw(20, 1);
		block30 rotateYaw(20, 1);
		block26 rotateYaw(-20, 1);
		wait 1;
	}
	if(!level.go4)
	{
		while(!level.go4)
		{
			block29 rotateYaw(-20, 1);
			block30 rotateYaw(-20, 1);
			block26 rotateYaw(20, 1);
			wait 1;
		}
	}
	
}

trap4trap()
{
	trig4 = getEnt("trig_trap4", "targetname");
	trig4 waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 200);
	level.go4=false;
}

overlay()
{	
	overlay = NewHudElem();
	overlay2 = NewHudElem();
	overlay3 = NewHudElem();
    wait 5;
	overlay.alpha = 0;
    overlay setShader("neuschwansteinlogo", 400, 400);
    overlay.x = 120;
    overlay.y = 0;	
	overlay fadeOverTime( 0.6 );
	overlay.alpha = 1;
	wait 1;
	overlay2.alpha = 0;
    overlay2 setShader("unavion", 150, 150);
    overlay2.x = 150;
    overlay2.y = 134;	
	overlay2 fadeOverTime( 0.6 );
	overlay2.alpha = 1;
	wait 1;
	overlay3.alpha = 0;
    overlay3 setShader("unpigeon", 220, 220);
    overlay3.x = 220;
    overlay3.y = 114;	
	overlay3 fadeOverTime( 0.6 );
	overlay3.alpha = 1;
	wait 3;
	overlay fadeOverTime( 0.6 );
	overlay.alpha = 0;
	wait 2;
	overlay2 fadeOverTime( 0.6 );
	overlay2.alpha = 0;
	wait 2;
	overlay3 fadeOverTime( 0.6 );
	overlay3.alpha = 0;
	wait 1;
}

porte()
{
	porte1 = getent("porte1","targetname");
	porte2 = getent("porte2","targetname");
	{
	wait 15;
	porte1 rotateYaw(90, 5);
	porte2 rotateYaw(-90, 5);
	wait 2;
	}
}

autorotatedroite()
{
    block = getent("rotatedroite1","targetname");
	block2 = getent("rotatedroite2","targetname");
	block3 = getent("rotatedroite3","targetname");
	block4 = getent("rotatedroite4","targetname");
	block5 = getent("rotatedroite5","targetname");
	block6 = getent("rotatedroite6","targetname");
	block7 = getent("rotatedroite7","targetname");
	block8 = getent("rotatedroite8","targetname");
	block9 = getent("rotatedroite9","targetname");
	block10 = getent("rotatedroite10","targetname");
	block11 = getent("rotatedroite11","targetname");
	block12 = getent("rotatedroite12","targetname");
	block13 = getent("rotatedroite13","targetname");
	block14 = getent("rotatedroite14","targetname");
	block15 = getent("rotatedroite15","targetname");
	block16 = getent("rotatedroite16","targetname");
	block17 = getent("rotatedroite17","targetname");
	block18 = getent("rotatedroite18","targetname");
	block19 = getent("rotatedroite19","targetname");
	block20 = getent("rotatedroite20","targetname");
	block21 = getent("rotatedroite21","targetname");
	block22 = getent("rotatedroite22","targetname");
	block23 = getent("rotatedroite23","targetname");
	block24 = getent("rotatedroite24","targetname");
	block25 = getent("rotatedroite25","targetname");
	block26 = getent("rotatedroite26","targetname");
	block27 = getent("rotatedroite27","targetname");


    for(;;)
	{
	wait 2;
	block rotateYaw(200, 5);
	block2 rotateYaw(200, 5);
	block3 rotateYaw(200, 5);
	block4 rotateYaw(200, 5);
	block5 rotateYaw(200, 5);
	block6 rotateYaw(200, 5);
	block7 rotateYaw(200, 5);
	block8 rotateYaw(200, 5);
	block9 rotateYaw(200, 5);
	block10 rotateYaw(200, 5);
	block11 rotateYaw(200, 5);
	block12 rotateYaw(200, 5);
	block13 rotateYaw(200, 5);
	block14 rotateYaw(200, 5);
	block15 rotateYaw(200, 5);
	block16 rotateYaw(200, 5);
	block17 rotateYaw(200, 5);
	block18 rotateYaw(200, 5);
	block19 rotateYaw(200, 5);
	block20 rotateYaw(200, 5);
	block21 rotateYaw(200, 5);
	block22 rotateYaw(200, 5);
	block23 rotateYaw(200, 5);
	block24 rotateYaw(200, 5);
	block25 rotateYaw(200, 5);
	block26 rotateYaw(200, 5);
	block27 rotateYaw(100, 5);
	wait 2;
	}
	
}

autorotategauche()
{
    block = getent("rotategauche1","targetname");
	block2 = getent("rotategauche2","targetname");
	block3 = getent("rotategauche3","targetname");
	block4 = getent("rotategauche4","targetname");
	block5 = getent("rotategauche5","targetname");
	block6 = getent("rotategauche6","targetname");
	block7 = getent("rotategauche7","targetname");
	block8 = getent("rotategauche8","targetname");
	block9 = getent("rotategauche9","targetname");
	block10 = getent("rotategauche10","targetname");
	block11 = getent("rotategauche11","targetname");
	block12 = getent("rotategauche12","targetname");
	block13 = getent("rotategauche13","targetname");
	block14 = getent("rotategauche14","targetname");
	block15 = getent("rotategauche15","targetname");
	block16 = getent("rotategauche16","targetname");
	block17 = getent("rotategauche17","targetname");
	block18 = getent("rotategauche18","targetname");
	block19 = getent("rotategauche19","targetname");
	block20 = getent("rotategauche20","targetname");
	block21 = getent("rotategauche21","targetname");
	block22 = getent("rotategauche22","targetname");
	block23 = getent("rotategauche23","targetname");
	block24 = getent("rotategauche24","targetname");
	block25 = getent("rotategauche25","targetname");

    for(;;)
	{
	wait 2;
	block rotateYaw(-200, 5);
	block2 rotateYaw(-200, 5);
	block3 rotateYaw(-200, 5);
	block4 rotateYaw(-200, 5);
	block5 rotateYaw(-200, 5);
	block6 rotateYaw(-200, 5);
	block7 rotateYaw(-200, 5);
	block8 rotateYaw(-200, 5);
	block9 rotateYaw(-200, 5);
	block10 rotateYaw(-200, 5);
	block11 rotateYaw(-200, 5);
	block12 rotateYaw(-200, 5);
	block13 rotateYaw(-200, 5);
	block14 rotateYaw(-200, 5);
	block15 rotateYaw(-200, 5);
	block16 rotateYaw(-200, 5);
	block17 rotateYaw(-200, 5);
	block18 rotateYaw(-200, 5);
	block19 rotateYaw(-200, 5);
	block20 rotateYaw(-200, 5);
	block21 rotateYaw(-200, 5);
	block22 rotateYaw(-200, 5);
	block23 rotateYaw(-200, 5);
	block24 rotateYaw(-200, 5);
	block25 rotateYaw(-200, 5);
	wait 2;
	}
	
}

autorotate()
{
    block = getent("autorotate","targetname");
	block3 = getent("autorotate6","targetname");
	block9 = getent("autorotate9","targetname");

    for(;;)
	{
	wait 2;
	block rotateroll(200, 5);
	block3 rotatepitch(-200, 5);
	block9 rotatepitch(200, 5);
	wait 2;
	}
	
}

autorotate2()
{
    block = getent("autorotate7","targetname");
	block2 = getent("autorotate2","targetname");
	block3 = getent("autorotate3","targetname");
	block4 = getent("autorotate4","targetname");
	block5 = getent("autorotate8","targetname");
	block11 = getent("autorotate11","targetname");


    for(;;)
	{
	wait 2;
	block rotateroll(-150, 5);
	block2 rotateroll(-150, 5);
	block3 rotateroll(150, 5);
	block4 rotateroll(-150, 5);
	block5 rotateroll(-150, 5);
	block11 rotateroll(150, 5);
	wait 2;
	}
	
}

//jumper secret

secret()
{
   level.secret_trigger = getent("trig_tp1","targetname");
   telejumporigin = getent("secret_jumper", "targetname");
   
   while(1)
   {
      level.secret_trigger waittill( "trigger", player );
      if( !isDefined( level.secret_trigger ) )
      return;
      if(level.firstenter==true)
   wait(0.05);

   player SetOrigin( telejumporigin.origin );
   player setplayerangles( telejumporigin.angles );
   wait(0.05);
   }
   
}

secretjumpfail()
{
	secretjumper = getEnt("secret_trigger_respawn", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

secret2()
{
   level.secret_trigger2 = getent("trig_tp4","targetname");
   telejumporigin2 = getent("secret_jumper2", "targetname");
   
   while(1)
   {
      level.secret_trigger2 waittill( "trigger", player );
      if( !isDefined( level.secret_trigger2 ) )
      return;
      if(level.firstenter==true)
   wait(0.05);

   player SetOrigin( telejumporigin2.origin );
   player setplayerangles( telejumporigin2.angles );
   wait(0.05);
   }
   
}

secretjumpfail2()
{
	secretjumper2 = getEnt("secret_trigger_respawn2", "targetname");
	origin_jumper_secret2 = getEnt("origin_jumper_secret2", "targetname");
	
	for (;;)
	{
		secretjumper2 waittill("trigger", player);
		player setOrigin(origin_jumper_secret2.origin);
		player setPlayerAngles(origin_jumper_secret2.angles);
		player iprintln("^3>>^1Respawned");
	}
}

secret4()
{
   level.secret_trigger3 = getent("trig_tp3","targetname");
   telejumporigin3 = getent("secret_jumper3", "targetname");
   
   while(1)
   {
      level.secret_trigger3 waittill( "trigger", player );
      if( !isDefined( level.secret_trigger3 ) )
      return;
      if(level.firstenter==true)
   wait(0.05);

   player SetOrigin( telejumporigin3.origin );
   player setplayerangles( telejumporigin3.angles );
   wait(0.05);
   }
   
}

secretjumpfail3()
{
	secretjumper3 = getEnt("secret_trigger_respawn3", "targetname");
	origin_jumper_secret3 = getEnt("origin_jumper_secret3", "targetname");
	
	for (;;)
	{
		secretjumper3 waittill("trigger", player);
		player setOrigin(origin_jumper_secret3.origin);
		player setPlayerAngles(origin_jumper_secret3.angles);
		player iprintln("^3>>^1Respawned");
	}
}

endsecret()
{
   level.secret_trigger4 = getent("trig_end_secret","targetname");
   telejumporigin4 = getent("origin_end_secret", "targetname");
   level.secret_trigger4 SetHintString("^5 [use] ");
   
   while(1)
   {
      level.secret_trigger4 waittill( "trigger", player );
      if( !isDefined( level.secret_trigger4 ) )
      return;
      if(level.firstenter==true)
   wait(0.05);

   player SetOrigin( telejumporigin4.origin );
   player setplayerangles( telejumporigin4.angles );
   iprintlnbold(" ^9" + player.name + " ^8 has finished the secret room!!");
   player braxi\_rank::giveRankXP("", 400);
   wait(0.05);
   }
   
}

//credits

credits()
{
        self endon( "disconnect" );
 
        if( isDefined( self.credits_text ) )
                self.credits_text Destroy();
 
        self.credits_text = newHudElem();
        self.credits_text.y = 10;
        self.credits_text.alignX = "center";
        self.credits_text.alignY = "middle";
        self.credits_text.horzAlign = "center";
 
        self.credits_text.alpha = 0;
        self.credits_text.sort = -3;
        self.credits_text.fontScale = 1.6;
        self.credits_text.archieved = true;

		while(1)
        {
			    wait 5;
				self credit_roll( "^2Discord: ^4MiThyX#4794", 3 );
				self credit_roll( "^4---- ^2Map ^2by ^9MiThyX ^4----", 3);
				self credit_roll( "^4---- ^2Report any ^9bugs ^4----", 3);
				wait 50;
        }
}

credit_roll( msg, time )
{
        self endon( "disconnect" );
 
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 1;
        self.credits_text setText( msg );
        wait( time );
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 0;
        wait 1;
}

//end trigger

endtrigger()
{
	trigfin = getent("trig_finish","targetname");
	trigfin waittill( "trigger", player );
	iprintlnBold(" ^9" + player.name + " ^2 has finished the Map at ^4first^2 place ^1!");
}

//rooms

snipertp()
{
   level.sniper_triggertp = getent("trig_sniper","targetname");
   level.sniper_triggertp setHintString("Sniper");
   teleactoriginsnip3 = getent("origin_acti_sniper3", "targetname");
	telejumporiginsnip3 = getent("origin_jump_sniper3", "targetname");
	teleactoriginsnip1 = getent("origin_acti_sniper", "targetname");
	telejumporiginsnip1 = getent("origin_jump_sniper", "targetname");
	teleactoriginsnip2 = getent("origin_acti_sniper2", "targetname");
	telejumporiginsnip2 = getent("origin_jump_sniper2", "targetname");
	
   while(1)
   {
   level.sniper_triggertp waittill( "trigger", player );
         if( !isDefined( level.sniper_triggertp ) )
      return;
   if(level.firstenter==true)
   {
   level.old_trigger delete();
   level.knife_triggertp delete();
   level.firstenter=false;
   } 
   player openMenu("menuroom");
	
	player waittill("menuresponse", menu, response);
	if(menu == "menuroom")
	{
		switch(response)
		{
			case "1":

		   player SetOrigin( telejumporiginsnip1.origin );
		   player setplayerangles( telejumporiginsnip1.angles );
		   player TakeAllWeapons();
		   player GiveWeapon("m40a3_mp");
		   player GiveWeapon( "remington700_mp" ); 
		   player GiveMaxAmmo("m40a3_mp");
		   player GiveMaxAmmo( "remington700_mp" );
		   wait .05;
		   player SwitchToWeapon("m40a3_mp"); 
		   wait(0.05);
		   level.activ SetOrigin( teleactoriginsnip1.origin );
		   level.activ setplayerangles( teleactoriginsnip1.angles );
		   level.activ TakeAllWeapons();
		   level.activ GiveWeapon( "m40a3_mp" );
		   level.activ GiveWeapon( "remington700_mp" );
		   level.activ GiveMaxAmmo("m40a3_mp");
		   level.activ GiveMaxAmmo( "remington700_mp" );
		   wait .05;
		   level.activ SwitchToWeapon("m40a3_mp"); 
		   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Sniper room^8!" ); 
		   player thread ammo();
		   level.activ thread ammo();
		   wait(0.05);
		   player switchToWeapon( "m40a3_mp" );
		   level.activ SwitchToWeapon( "m40a3_mp" );
		   player waittill( "death" );
		   level.PlayerInRoom = false;
			
            break;
			case "3":

		   player SetOrigin( telejumporiginsnip2.origin );
		   player setplayerangles( telejumporiginsnip2.angles );
		   player TakeAllWeapons();
		   player GiveWeapon("m40a3_mp");
		   player GiveWeapon( "remington700_mp" ); 
		   player GiveMaxAmmo("m40a3_mp");
		   player GiveMaxAmmo( "remington700_mp" );
		   wait .05;
		   player SwitchToWeapon("m40a3_mp"); 
		   wait(0.05);
		   level.activ SetOrigin( teleactoriginsnip2.origin );
		   level.activ setplayerangles( teleactoriginsnip2.angles );
		   level.activ TakeAllWeapons();
		   level.activ GiveWeapon( "m40a3_mp" );
		   level.activ GiveWeapon( "remington700_mp" );
		   level.activ GiveMaxAmmo("m40a3_mp");
		   level.activ GiveMaxAmmo( "remington700_mp" );
		   wait .05;
		   level.activ SwitchToWeapon("m40a3_mp"); 
		   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Sniper room^8!" ); 
		   player thread ammo();
		   level.activ thread ammo();
		   wait(0.05);
		   player switchToWeapon( "m40a3_mp" );
		   level.activ SwitchToWeapon( "m40a3_mp" );
		   player waittill( "death" );
		   level.PlayerInRoom = false;
			
            break;
			case "2":

		   player SetOrigin( telejumporiginsnip3.origin );
		   player setplayerangles( telejumporiginsnip3.angles );
		   player TakeAllWeapons();
		   player GiveWeapon("m40a3_mp");
		   player GiveWeapon( "remington700_mp" ); 
		   player GiveMaxAmmo("m40a3_mp");
		   player GiveMaxAmmo( "remington700_mp" );
		   wait .05;
		   player SwitchToWeapon("m40a3_mp"); 
		   wait(0.05);
		   level.activ SetOrigin( teleactoriginsnip3.origin );
		   level.activ setplayerangles( teleactoriginsnip3.angles );
		   level.activ TakeAllWeapons();
		   level.activ GiveWeapon( "m40a3_mp" );
		   level.activ GiveWeapon( "remington700_mp" );
		   level.activ GiveMaxAmmo("m40a3_mp");
		   level.activ GiveMaxAmmo( "remington700_mp" );
		   wait .05;
		   level.activ SwitchToWeapon("m40a3_mp"); 
		   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Sniper room^8!" ); 
		   player thread ammo();
		   level.activ thread ammo();
		   wait(0.05);
		   player switchToWeapon( "m40a3_mp" );
		   level.activ SwitchToWeapon( "m40a3_mp" );
		   player waittill( "death" );
		   level.PlayerInRoom = false;
			
            break;
		}
   }
   }
}

knifetp()
{
   level.knife_triggertp = getent("trig_knife","targetname");
   level.knife_triggertp setHintString("Knife");
   teleactoriginsnip3 = getent("origin_acti_sniper3", "targetname");
	telejumporiginsnip3 = getent("origin_jump_sniper3", "targetname");
	teleactoriginsnip1 = getent("origin_acti_sniper", "targetname");
	telejumporiginsnip1 = getent("origin_jump_sniper", "targetname");
	teleactoriginsnip2 = getent("origin_acti_sniper2", "targetname");
	telejumporiginsnip2 = getent("origin_jump_sniper2", "targetname");
	
   while(1)
   {
   level.knife_triggertp waittill( "trigger", player );
         if( !isDefined( level.knife_triggertp ) )
      return;
   if(level.firstenter==true)
   {
   level.old_trigger delete();
   level.snipe_triggertp delete();
   level.firstenter=false;
   }
   player openMenu("menuroom");
		
	player waittill("menuresponse", menu, response);
	if(menu == "menuroom")
	{
		switch(response)
		{
			case "1":

		   player SetOrigin( telejumporiginsnip1.origin );
		   player setplayerangles( telejumporiginsnip1.angles );
		   player TakeAllWeapons();
		   wait(0.05);
		   level.activ SetOrigin( teleactoriginsnip1.origin );
		   level.activ setplayerangles( teleactoriginsnip1.angles );
		   level.activ TakeAllWeapons();
		   wait .05;
		   level.activ giveweapon("knife_mp");
			player giveweapon("knife_mp");
			player switchToWeapon( "knife_mp" );
			level.activ SwitchToWeapon( "knife_mp" );
		   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Knife room^8!" ); 
		   wait(0.05);
		   player waittill( "death" );
		   level.PlayerInRoom = false;
			
            break;
			case "3":

		   player SetOrigin( telejumporiginsnip2.origin );
		   player setplayerangles( telejumporiginsnip2.angles );
		   player TakeAllWeapons();
		   wait(0.05);
		   level.activ SetOrigin( teleactoriginsnip2.origin );
		   level.activ setplayerangles( teleactoriginsnip2.angles );
		   level.activ TakeAllWeapons();
		   wait .05;
		   level.activ giveweapon("knife_mp");
			player giveweapon("knife_mp");
			player switchToWeapon( "knife_mp" );
			level.activ SwitchToWeapon( "knife_mp" );
		   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Knife room^8!" ); 
		   wait(0.05);
		   player waittill( "death" );
		   level.PlayerInRoom = false;
			
            break;
			case "2":

		   player SetOrigin( telejumporiginsnip3.origin );
		   player setplayerangles( telejumporiginsnip3.angles );
		   player TakeAllWeapons();
		   wait(0.05);
		   level.activ SetOrigin( teleactoriginsnip3.origin );
		   level.activ setplayerangles( teleactoriginsnip3.angles );
		   level.activ TakeAllWeapons();
		   wait .05;
		   level.activ giveweapon("knife_mp");
			player giveweapon("knife_mp");
			player switchToWeapon( "knife_mp" );
			level.activ SwitchToWeapon( "knife_mp" );
		   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Knife room^8!" ); 
		   wait(0.05);
		   player waittill( "death" );
		   level.PlayerInRoom = false;
			
            break;
		}
   } 
   }
}

old()
{
   porte1 = getent("oldporte","targetname");
   level.old_trigger = getent("trig_old","targetname");
   level.old_trigger setHintString("Old");
   telejumporiginold = getent("origin_jump_old", "targetname");
   
   while(1)
   {
	   level.old_trigger waittill("trigger",player);
	   if(level.firstenter==true)
	   {
		   level.sniper_triggertp delete();
		   level.knife_triggertp delete();
		   level.firstenter=false;
	   }

	   player SetOrigin( telejumporiginold.origin );
	   player setplayerangles( telejumporiginold.angles );
	   porte1 moveZ (-800, 1);
	   iPrintlnBold(" ^9" + player.name + " ^4 has entered the Old room^8!"); 
	   wait 1;

	   player waittill( "death" );
	   level.PlayerInRoom = false;
   }
}

//ammo
ammo()
{
self endon("round_ended");
self endon("death");
self endon("disconected");
wait 1;
for(;;)
{
	weapon = self GetCurrentWeapon();
	ammo = self GetWeaponAmmoStock(weapon);
	if(weapon == "none")
	{
		wait 1;
	}
	else if(weapon == "knife_mp")
	{
		wait 1;
	}
	else if(1 >= ammo)
	{
		self givemaxammo(weapon);
	}
	wait 5;
	}
}

//music

musicMenu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i].glowalpha=1;
	if(isdefined(level.randomcolor))
		self.hud_music[i].glowcolor=level.randomcolor;
	else 
		self.hud_music[i].glowcolor=(1,0,0);

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
		self.hud_music[i].glowalpha=1;
		if(isdefined(level.randomcolor))
			self.hud_music[i].glowcolor=level.randomcolor;
		else 
			self.hud_music[i].glowcolor=(1,0,0);
 
		entry = level.music[j];
		self.hud_music[i] setText(entry["song"]);
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );
 
	while(self.sessionstate == "playing")
	{
		wait 0.1;
 
		if(self attackButtonPressed())
		{
			self.hud_music[3+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[3+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if(self useButtonPressed())
		{
 			iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
			ambientPlay(level.music[self.selection]["alias"]);
			level.musicplaying=true;
			thread time(self.selection);
			self freezecontrols(0);
			break;
		}
		else if(self fragButtonPressed())
		{
			self freezecontrols(0);
			break;
		}
	}
 
	self cleanUp();
}

time(num)
{
	if(num==0)
	{
		wait 245;
		level.musicplaying = false;
	}
	else if(num==1)
	{
		wait 261;
		level.musicplaying = false;
	}
	else if(num==2)
	{
		wait 156;
		level.musicplaying = false;
	}
	else if(num==3)
	{
		wait 212;
		level.musicplaying = false;
	}
	else if(num==4)
	{
		wait 250;
		level.musicplaying = false;
	}
	else if(num==5)
	{
		wait 280;
		level.musicplaying = false;
	}
}
 
musictrig()
{
	self.trigmusic = getEnt ("musicmenu", "targetname");
	self.trigmusic setHintString("Press [^5&&1^7] to choose Music");
 
	self.trigmusic waittill("trigger",player);
	player freezecontrols(1);
	self.trigmusic delete();
	player musicMenu();
}
 
	onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
	onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}

cleanUp()
{
	if( !isDefined( self ) )
		return;
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}
 
partymusic()
{	
	wait 20;
	if(isDefined(self.trigmusic))
	{
		self.trigmusic delete();
	}
	while(1)
	{
		if(!level.musicplaying)
		{
			x = randomint(5);
			if(x == 0)
			{
			ambientplay("music0");
			iprintln("^1>> ^7Now playing: ^1"+level.music[0]["song"]);
			level.musicplaying = true;
			thread time(0);
			}
			if(x == 1)
			{
			ambientplay("music1");
			iprintln("^1>> ^7Now playing: ^1"+level.music[1]["song"]);
			level.musicplaying = true;
			thread time(1);
			}
			if(x == 2)
			{
			ambientplay("music2");
			iprintln("^1>> ^7Now playing: ^1"+level.music[2]["song"]);
			level.musicplaying = true;
			thread time(2);
			}
			if(x == 3)
			{
			ambientplay("music3");
			iprintln("^1>> ^7Now playing: ^1"+level.music[3]["song"]);
			level.musicplaying = true;
			thread time(3);
			}
			if(x == 4)
			{
			ambientplay("music4");
			iprintln("^1>> ^7Now playing: ^1"+level.music[4]["song"]);
			level.musicplaying = true;
			thread time(4);
			}
			if(x == 5)
			{
			ambientplay("music5");
			iprintln("^1>> ^7Now playing: ^1"+level.music[5]["song"]);
			level.musicplaying = true;
			thread time(5);
			}
		}
		wait 5;
	}
}


//ENJOY