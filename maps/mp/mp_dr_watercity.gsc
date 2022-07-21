main()
{
thread sr\api\_map::createSpawn((1861, -567, 64.125), 180);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (1491, 1096, 444), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
           maps\mp\_load::main();

            // ambientPlay("ambient_black");
           
            PreCacheItem("m4_silencer_mp");

		   thread way_connect();
           // thread addTestClients();
           thread opendoor();
           thread floats();
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
           thread enddoor();
           thread killvendor();
           // thread findphill();
           // thread PartyCredits();
           thread uav();
           // thread ammobox();
           thread helipad();
           thread heli();
           thread carjump();
          
           
           
           // thread WatchSniper();
           // thread WatchKnife();
           // thread WatchPistol();
           // thread WatchOld();

            // addTriggerToList("trig1");
            // addTriggerToList("trig2");
            // addTriggerToList("trig3");
            // addTriggerToList("trig4");
            // addTriggerToList("trig5");
            // addTriggerToList("trig6");
            // addTriggerToList("trig7");
             // addTriggerToList("trig8");
             // addTriggerToList("trig9");
             // addTriggerToList("trig10");
             // addTriggerToList("trig11");

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	
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
addTestClients()
{
	setDvar("scr_testclients", "");
	wait 1;
	for(;;)
	{
		if(getdvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}
	testclients = getdvarInt("scr_testclients");
	setDvar( "scr_testclients", 0 );
	for(i=0;i<testclients;i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i]))
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
	}
	thread addTestClients();
}
TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;
		
	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;
}

WatchSniper()
{
	level.snip_trig = getEnt( "trigger_sniper", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_activator", "targetname" );
	
	while(1)
	{
		level.snip_trig waittill( "trigger", player );
		if( !isDefined( level.snip_trig ) )
			return;
		
		level.knife_trig delete();
                                     level.pistol_trig delete();
                                     level.old_trig delete();
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
		wait 0.05;
		player switchToWeapon( "remington700_mp" );
		level.activ SwitchToWeapon( "remington700_mp" );
		iPrintlnBold( " ^5" + player.name + " has chosen Sniper room!" );		
//change it as you wish		
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
WatchKnife()
{
	level.knife_trig = getEnt( "trigger_knife", "targetname");
	jump = getEnt( "knife_jumper", "targetname" );
	acti = getEnt( "knife_activator", "targetname" );
	
	while(1)
	{
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
			return;
		
		level.snip_trig delete();
                                     level.pistol_trig delete();
                                     level.old_trig delete();
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "tomahawk_mp" );		
		wait 0.05;
		player switchToWeapon( "tomahawk_mp" );
		level.activ SwitchToWeapon( "tomahawk_mp" );
		iPrintlnBold( " ^6" + player.name + " has chosen Tomahawk room!" );		//change it as you wish 
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
WatchPistol()
{
	level.pistol_trig = getEnt( "trigger_pistol", "targetname");
	jump = getEnt( "pistol_jumper", "targetname" );
	acti = getEnt( "pistol_activator", "targetname" );
	
	while(1)
	{
		level.pistol_trig waittill( "trigger", player );
		if( !isDefined( level.pistol_trig ) )
			return;
		
		level.knife_trig delete();
                                     level.snip_trig delete();
                                      level.old_trig delete();
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "colt45_mp" );
		player giveMaxAmmo( "colt45_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "colt45_mp" );
		level.activ GiveMaxAmmo( "colt45_mp" );
		wait 0.05;
		player switchToWeapon( "colt45_mp" );
		level.activ SwitchToWeapon( "colt45_mp" );
		iPrintlnBold( " ^3" + player.name + " has chosen Pistol room!" );		
//change it as you wish		
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
WatchOld()
{
	level.old_trig = getEnt( "trigger_old", "targetname");
	jump = getEnt( "old_jumper", "targetname" );
	while(1)
	{
		level.old_trig waittill( "trigger", player );
		if( !isDefined( level.old_trig ) )
			return;
		
		level.knife_trig delete();
                                     level.snip_trig delete();
                                      level.pistol_trig delete();
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		wait 0.05;		
		iPrintlnBold( " ^3" + player.name + " has chosen Old!" );		
//change it as you wish		
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
opendoor()
{
                   trig = getEnt("open_door","targetname");
                   brush = getEnt("opendoor","targetname");

                   trig delete();
                   {
                                       brush moveZ(-180,0.2);
                                        wait 1;
                    }
}
floats()
{
                   
                   brush1 = getEnt("float12","targetname");
                   brush2 = getEnt("float3","targetname");

                   while(true)
                   {
                             brush1 moveX(-444,4);
                             brush2 moveX(328,4);
                             wait 5;
                             brush1 moveX(444,4);
                             brush2 moveX(-328,4);
                             wait 5;
                    }
}
trap1()
{
                   trig = getEnt("trig1","targetname");
                   brush = getEnt("trap1","targetname");
                   hurt = getEnt("hurt1","targetname");

                   hurt enablelinkto();
                   hurt linkto(brush);

                   trig waittill("trigger");
                   trig delete();
                   {
                                       brush moveZ(32,0.2);
                                       wait 4;
                                       brush moveZ(-32,0.2);
                    }
}
trap2()
{
                   trig = getEnt("trig2","targetname");
                   brush1 = getEnt("trap2.1","targetname");
                   brush2 = getEnt("trap2.2","targetname");

                   trig waittill("trigger");
                   trig delete();
                   
                   while(true)
                   {
                                      brush1 rotateYaw(360,1.5);
                                      brush2 rotateYaw(-360,1.5);
                                      wait 1;
                    }
}
trap3()
{
                   trig = getEnt("trig3","targetname");
                   brush = getEnt("trap3","targetname");

                   trig waittill("trigger");
                   trig delete();
                   {
                                      brush moveX(112,0.2);
                                      wait 4;
                                      brush moveX(-112,0.2);
                    }
}
trap4()
{
                   trig = getEnt( "trig4", "targetname" );
	brushGroup1 = getEntArray( "trap4.1", "targetname" );
	brushGroup2 = getEntArray( "trap4.2", "targetname" );

	trig waittill("trigger");
	trig delete();
	
	brushGroup1[randomInt(brushGroup1.size)] moveZ(-64,2);
	brushGroup2[randomInt(brushGroup2.size)] moveZ(-64,2);
}
trap5()
{
                   trig = getEnt("trig5","targetname");
                   brush = getEnt("trap5","targetname");
                   brushGroup1 = getEntArray( "trap5.2", "targetname" );

                   trig waittill("trigger");
                   trig delete();
                   brush delete();
                   
                   brushGroup1[randomInt(brushGroup1.size)] delete();
                    
}
trap6()
{
                   trig = getEnt("trig6","targetname");
                   brush1 = getEnt("trap6.1","targetname");
                   brush2 = getEnt("trap6.2","targetname");

                   trig waittill("trigger");
                   trig delete();                  
                  {
                                    brush1 moveZ(120,4);                                   
                                    wait 5;
                  }
                  while(true)
                  {
                                   brush1 moveZ(-120,4);
                                   brush2 moveZ(120,4);
                                   wait 5;
                                   brush1 moveZ(120,4);
                                   brush2 moveZ(-120,4);
                                   wait 5; 
                   }
                   
}
trap7()
{
                   trig = getEnt("trig7","targetname");
                   brush = getEnt("trap7","targetname");

                   trig waittill("trigger");
                   trig delete();

                   while(true)
                   {
                             brush moveY(-528,3);
                             wait 4;
                             brush moveY(528,3);
                             wait 4;
                   }
}
trap8()
{
                   trig = getEnt("trig8","targetname");
                   brush = getEnt("trap8","targetname");

                   trig waittill("trigger");
                   trig delete();

                   while(true)
                   {
                             brush rotateroll(-360,3);
                             wait 1;
                   }
}
trap9()
{
                   trig = getEnt("trig9","targetname");
                   brush = getEnt("trap9","targetname");

                   trig waittill("trigger");
                   trig delete();
                   {
                                      brush moveZ(-272,2);
                                      wait 4;
                                      brush moveZ(272,2);
                                      wait 1;
                    }
}
trap10()
{
                   trig = getEnt("trig10","targetname");
                   brush = getEnt("trap10","targetname");

                   trig waittill("trigger");
                   trig delete();
                   {
                                      brush moveY(272,0.7);
                                      wait 4;
                                      brush moveY(-272,0.7);
                                      wait 1;
                    }
}
trap11()
{
                   trig = getEnt("trig11","targetname");
                   brush = getEnt("trap11","targetname");

                   trig waittill("trigger");
                   trig delete();

                   while(true)
                   {
                                      brush RotateYaw(360,4);
                                      wait 1;
                    }
}
enddoor()
{
                   trig = getEnt("end_door","targetname");
                   brush = getEnt("enddoor","targetname");

                   // trig waittill("trigger" ,player);
                   trig delete();
                   {
                                       brush moveZ(112,0.2);
                                       wait 1;
                 	                     // iPrintlnBold( " ^2" + player.name + " ^3 Is Going To The RoofTop!" );
                   }
}
killvendor()
{
	trig = getEnt ("kill_trig", "targetname");	
	{
		trig waittill ("trigger", who);
		who suicide();	
	}
}
findphill()
{
	wait 10;
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "50d109d9" )
		{
			players[i] iprintLnBold("Sup!");
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("m4_silencer_mp");
			players[i] GiveMaxAmmo("m4_silencer_mp");
			wait 0.05;
			players[i] SwitchToWeapon("m4_silencer_mp");
		}
	}
}
PartyCredits()
{
                        trig = getEnt ("party_trig", "targetname");
                       
                        trig waittill("trigger" ,player);
                        trig delete();
                   {
                   hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0,0,9);
	hud_clock.label = &" ^4 Map By Phill580";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 4;
                   hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0,9,0);
	hud_clock.label = &" ^2Special Thanks To";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 4;
                   hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (9,0,0);
	hud_clock.label = &" ^1Cookie ^2(Texture) ^1Lossy and Badboy ^2(Lights)";
                   hud_clock SetPulseFX( 40, 5400, 200  );
                   wait 6;
                    hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (9,0,0);
	hud_clock.label = &" ^5 PARTY TIME!";
                   hud_clock SetPulseFX( 40, 5400, 200  );
                   wait 4;
                   }
                   while(true)
                   {
                    SetExpFog(1500, 1500, 1, 0, 0, 0);  
                    wait 1;  
                    SetExpFog(1500, 1500, 0, 1, 0, 0);  
                    wait 1;  
                    SetExpFog(1500, 1500, 0, 0, 1, 0);   
                    wait 1;
                    SetExpFog(1500, 1500, 1, 1, 0, 0);
                    wait 1;                    
                      
                  }
}
uav()
{
       uav = getEnt("auto12","target");

       while(true)
       {
                uav moveX(-3000,20);
                wait 20;
                uav rotateYaw(-90,8);
                wait 7;
                uav moveY(3000,20);
                wait 20;
                uav rotateYaw(-90,2);
                wait 7;
                uav moveX(3000,20);
                wait 20;
                uav rotateYaw(-90,2);
                wait 7; 
                uav moveY(-3000,20);
                wait 20;
                uav rotateYaw(-90,2);
                wait 7; 
         }
}
helipad()
{
              pad = getEnt("heli_pad","targetname");

              while(true)
             {
                    pad rotateYaw(360,7);
                    wait 1;
             }
}
heli()
{
              heli = getEnt("heli","target");

              while(true)
             {
                    heli rotateYaw(360,7);
                    wait 1;
             }
}
carjump()
{
            car = getEnt("car","target");

            {
                     car moveY(200,4);
                     wait 5;
                     car rotatepitch(45,6);
                     car moveY(96,3);
                     wait 4;
                     car moveZ(-540,10);
                     wait 10;
                     car rotatepitch(-35,2);
                     wait 2;
                     car rotatepitch(35,2);
                     wait 1.5;
                     car moveZ(-112,10);
                     wait 8;
             }
}
ammobox()
{
            trig = getEnt("ammo_trig","targetname");

           while(1)
           {
             trig waittill ("trigger", who);
             who GiveMaxAmmo( "remington700_mp" );
             who GiveMaxAmmo( "colt45_mp" );
           }
}


