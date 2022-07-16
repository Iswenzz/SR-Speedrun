main()
{
	maps\mp\_teleport::main();
	maps\mp\_load::main();
	

    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_map::createSpawn((0,-61,68),270);
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread sniper();
	//thread pickend();
	//thread bouncer();
	//thread bounce_reset();
	//thread knife();
	//thread dog();
	//thread grave();
	//thread dig_grave();
	//thread xp_give();
	//thread addTestCLients();
}


xp_give()
{
	target = getEnt ("xp_exit", "targetname");
	acti = getEnt ("xp_give", "targetname");
	
	acti waittill ("trigger", player);
	player braxi\_rank::giveRankXP("", 700);
	
	player SetPlayerAngles( target.angles );
    player setOrigin( target.origin );
	player giveWeapon( "deserteaglegold_mp" );
    player SwitchToWeapon( "deserteaglegold_mp" );
	iPrintlnBold( " ^6" + player.name + " ^2 Is Almost As Sexy As ^6Seen^0|^6Render <3..." );
	player iPrintlnBold( "^4Exploring does pay off ;)" );

}

grave()
{
	sniper_trig = getEnt ("sniper_trig", "targetname");
	knife_trig = getEnt ("knife_trig", "targetname");
	bounce_trig = getEnt ("bouncer_trig", "targetname");
	dog_trig = getEnt ("dog_trig", "targetname");
	grave_trig = getEnt ("grave_trig", "targetname");
	target = getEnt ("grave_orig", "targetname");
	acti = getEnt ("grave_acti", "targetname");

	
	while(1)
	{
		grave_trig waittill ("trigger", player);
		
		knife_trig delete();
		sniper_trig delete();
		bounce_trig delete();
		dog_trig delete();
		
		player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
        player TakeAllWeapons();	
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();   		
        iPrintlnBold( " ^6" + player.name + " ^2 HAS CHOSEN ^0GRAVEYARD..." );     //change to what you want it to be
    player freezeControls(true);
    level.activ freezeControls(true);
    wait 3;
    iPrintlnBold( "^33" );
    wait 1;
    iPrintlnBold( "^22" );
    wait 1;
    iPrintlnBold( "^11" );
    wait 1;
    iPrintlnBold( "^1FIGHT" );
    player freezeControls(false);
	level.activ freezeControls(false);
            wait 1;
	}
}

dig_grave()
{
	g_1 = getEnt ("grave_1", "targetname");
	
	for(;;)
	{
	
	g_1 waittill ("trigger", player);
		thread grave_trigz();
	}

}

grave_trigz() //Made By Rv| Seen|Render ||| Please Credit Me If You Use This!!!
{
    g_1 = getEnt ("grave_1", "targetname");
    self endon("disconnect");
    self endon ( "death" );
    self endon("joined_spectators");
    self endon("killed_player");
   
    g_1 waittill ("trigger", player);
        player iprintlnbold( "^6" + player.name + " Is Digging");
        wait 3;
    x = RandomInt( 6 );
   
    if (x>=3)
     {
       
       iprintlnbold( "^2" + player.name + " Found Nothing But A Dead Body");  
       player takeAllWeapons();
     }
   
        if (x<=1)
     {
       
		iprintlnbold( "^1Ouch! A Zombie Bit " + player.name + "! ^0" + player.name + " Is Infected");
 
        {
               
                player takeAllWeapons();
        player giveWeapon( "knife_mp" );
        player SwitchToWeapon( "knife_mp" );
                wait 0.1;
        player.health = 100;
                zombie_vision = newClientHudElem(player);
                zombie_vision.x = 0;
                zombie_vision.y = 0;
                zombie_vision setshader ("white", 640, 480);
                zombie_vision.alignX = "left";
                zombie_vision.alignY = "top";
                zombie_vision.horzAlign = "fullscreen";
                zombie_vision.vertAlign = "fullscreen";
                zombie_vision.color = (.10, .30, .10);
                zombie_vision.alpha = .75;
                zombie_vision fadeOverTime(2);
        wait 2;
        player.health = 90;
        wait 2;
        player.health = 80;
        wait 2;
                player.health = 70;
                wait 2;
                player.health = 60;
                wait 2;
                player.health = 50;
                wait 2;
                player.health = 40;
                wait 2;
                player.health = 30;
                wait 2;
                player.health = 20;
                wait 2;
                player.health = 10;
                wait 2;
                player suicide();
				zombie_vision.alpha = .0;
				
       
     }
         }
   
    if (x==2)
     {
       
        iprintlnbold( "^5Nice, " + player.name + " Found A Gun!");  
        player takeAllWeapons();
        player giveWeapon( "deserteaglegold_mp" );
        player SwitchToWeapon( "deserteaglegold_mp" );
       
     }
}
 pickend()
{
    trig = getent("endmap_trig", "targetname");
    pickroom = getent("pickingrooms", "targetname");
    
    while(1)
    {
        trig waittill ( "trigger", player );
        player SetPlayerAngles( pickroom.angles );
        player setOrigin( pickroom.origin );
        player thread onDeath();
		wait 0.1;
	
	
    for(;;)
    {
		wait .1;		
		while(isAlive(player))
		{
			wait 1;
		}
		
    }
    }
}
onDeath()
{
        self endon("disconnect");
        self endon("joined_spectators");
        self endon("killed_player");
        self waittill("death");
               
                iprintlnbold( "^5" + self.name + " ^7has^1 died^7!" );
 
}

bouncer()
{
	sniper_trig = getEnt ("sniper_trig", "targetname");
	knife_trig = getEnt ("knife_trig", "targetname");
	bounce_trig = getEnt ("bouncer_trig", "targetname");
	dog_trig = getEnt ("dog_trig", "targetname");
	grave_trig = getEnt ("grave_trig", "targetname");
	target = getEnt ("bouncer_orig", "targetname");
	acti = getEnt ("bouncer_acti", "targetname");
	
	while(1)
	{
		bounce_trig waittill ("trigger", player);
	
		knife_trig delete();
		sniper_trig delete();
		grave_trig delete();
		dog_trig delete();
		
		player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
        player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" ); //jumper weapon  		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();  
		level.activ GiveWeapon( "tomahawk_mp" );    		
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^2 HAS CHOSEN BOUNCE^1!" );     //change to what you want it to be
    player freezeControls(true);
    level.activ freezeControls(true);
    wait 3;
    iPrintlnBold( "^33" );
    wait 1;
    iPrintlnBold( "^22" );
    wait 1;
    iPrintlnBold( "^11" );
    wait 1;
    iPrintlnBold( "^1FIGHT" );
    player freezeControls(false);
	level.activ freezeControls(false);
            wait 1;
	}
}

knife()
{
	sniper_trig = getEnt ("sniper_trig", "targetname");
	knife_trig = getEnt ("knife_trig", "targetname");
	bounce_trig = getEnt ("bouncer_trig", "targetname");
	dog_trig = getEnt ("dog_trig", "targetname");
	grave_trig = getEnt ("grave_trig", "targetname");
	target = getEnt ("knife_orig", "targetname");
	acti = getEnt ("knife_acti", "targetname");
	
	while(1)
	{
		knife_trig waittill ("trigger", player);
	
		bounce_trig delete();
		sniper_trig delete();
		grave_trig delete();
		dog_trig delete();
		
		player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
        player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" ); //jumper weapon  		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();  
		level.activ GiveWeapon( "tomahawk_mp" );    		
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN KNIFE^1!" );     //change to what you want it to be
        player freezeControls(true);
		level.activ freezeControls(true);
		wait 3;
		iPrintlnBold( "^33" );
		wait 1;
		iPrintlnBold( "^22" );
		wait 1;
		iPrintlnBold( "^11" );
		wait 1;
		iPrintlnBold( "^1FIGHT" );
		player freezeControls(false);
		level.activ freezeControls(false);
            wait 1;	
	}
}

dog()
{
	sniper_trig = getEnt ("sniper_trig", "targetname");
	knife_trig = getEnt ("knife_trig", "targetname");
	bounce_trig = getEnt ("bouncer_trig", "targetname");
	dog_trig = getEnt ("dog_trig", "targetname");
	grave_trig = getEnt ("grave_trig", "targetname");
	target = getEnt ("knife_orig", "targetname");
	acti = getEnt ("knife_acti", "targetname");
	
	while(1)
    {    
        dog_trig waittill( "trigger", player );
		bounce_trig delete();
		sniper_trig delete();
		grave_trig delete();
		knife_trig delete();
    
    player SetPlayerAngles( target.angles );
    player setOrigin( target.origin );
    player detachAll();
    player setModel("german_sheperd_dog");
    player TakeAllWeapons();
    player giveweapon( "dog_mp");  
    level.activ setPlayerangles(acti.angles );
    level.activ setOrigin(acti.origin );
    level.activ detachAll();
    level.activ setModel("german_sheperd_dog");
    level.activ TakeAllWeapons();
    level.activ giveweapon( "dog_mp");   
    player switchToWeapon( "dog_mp" );
    level.activ SwitchToWeapon( "dog_mp" );
    player freezeControls(true);
    level.activ freezeControls(true);
    iPrintlnBold( " ^6" + player.name + " ^3 HAS CHOSEN ^1DOG FIGHT^7!" );
    wait 3;
    iPrintlnBold( "^33" );
    wait 1;
    iPrintlnBold( "^22" );
    wait 1;
    iPrintlnBold( "^11" );
    wait 1;
    iPrintlnBold( "^1FIGHT" );
    player freezeControls(false);
            wait 1;	
	}
}

 bounce_reset()
{
    trigger = getEnt ("bounce_reset", "targetname");
    jumper = getEnt ("bouncer_orig", "targetname");
    activator = getEnt ("bouncer_acti", "targetname");
    
    for(;;)
    {
        trigger waittill ("trigger", player);
        if(player.pers["team"] == "allies")
        {
            player SetOrigin(jumper.origin);
            player SetPlayerAngles( jumper.angles );
        }
        else if(player.pers["team"] == "axis")    
        {
            player SetOrigin(activator.origin);
            player SetPlayerAngles( activator.angles );            
        }
    }
}

sniper()
{
	sniper_trig = getEnt ("sniper_trig", "targetname");
	knife_trig = getEnt ("knife_trig", "targetname");
	bounce_trig = getEnt ("bouncer_trig", "targetname");
	dog_trig = getEnt ("dog_trig", "targetname");
	grave_trig = getEnt ("grave_trig", "targetname");
	target = getEnt ("snipe_orig", "targetname");
	acti = getEnt ("snipe_acti", "targetname");
	
	while(1)
	{
		sniper_trig waittill ("trigger", player);
	
		knife_trig delete();
		bounce_trig delete();
		grave_trig delete();
		dog_trig delete();
		
		player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon  
		player GiveWeapon( "remington700_mp" ); //jumper weapon  		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );    
		level.activ GiveWeapon( "remington700_mp" );    		
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN SNIPE^1!" );     //change to what you want it to be
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 3;
		iPrintlnBold( "^33" );
		wait 1;
		iPrintlnBold( "^22" );
		wait 1;
		iPrintlnBold( "^11" );
		wait 1;
		iPrintlnBold( "^1FIGHT" );
		player freezeControls(false);
		level.activ freezeControls(false);
            wait 1;
	}
}

trap1()
{
	act1 = getEnt ("trap1_acti", "targetname");
	rotate1 = getEnt ("trap1_trap", "targetname");
	
	act1 waittill ("trigger");
	act1 delete();
	
	while (1) //makes it always rotate
		{
			rotate1 rotatepitch (90, 3); //rotateroll rotateyaw rotatepitch
			wait 3; //same speed brush rotates
		}
}



trap2()
{
	act = getEnt ("trap2_acti", "targetname");
	move = getEnt ("trap2_trap", "targetname");
	move2 = getEnt ("trap2_trap2", "targetname");
	
	act waittill ("trigger");
	act delete();
	
	while (1)
		{
			move moveX (-256, 1);
			move2 moveX (256, 1);
			move waittill ("movedone");
			move2 moveX (-256, 1);
			move moveX (256, 1);
			move waittill ("movedone");
		}
}

trap3()
{
    trig = getEnt ("trap3_acti", "targetname"); 
    
    trig waittill ("trigger", who);
    trig delete();
    
    
    if (randomInt(2) == 0)
        thread kill1();
    else
        thread kill2();
}


kill1()
{
    trig = getEnt ("trap3_kill1", "targetname");
    
    for(;;)
    {
        trig waittill ("trigger", who);
        who suicide();
        wait 0.5;
    }
}    

kill2()
{
    trig = getEnt ("trap3_kill3", "targetname");
    
    for(;;)
    {
        trig waittill ("trigger", who);
        who suicide();
        wait 0.5;
    }
}

trap4()
{
beam = getent("trap4_trap2", "targetname");
brush = getent("trap4_trap", "targetname");
trig = getEnt ("trap4_acti", "targetname"); 
    
    trig waittill ("trigger");
    trig delete();
    
    while(1)
    {
        beam movez(-128,2);
                        brush movez(128,2);
        beam waittill ("movedone");
                        brush movez(-128,2);
        beam movez(128,2);
        beam waittill ("movedone");
    }
}

trap5()
{
      act6 = getEnt ("trap5_acti", "targetname");
      killtrigger = getEnt ("trap5_dmg" , "targetname");
      spikez1 = getEnt ("trap5_trap" , "targetname");
      act6 waittill ("trigger" , player );
      act6 delete ();
      killtrigger enablelinkto ();
      killtrigger linkto (spikez1);
      spikez1 movez (64 , 1 );
      wait 3 ; 
      spikez1 movez (-64 ,1);
      wait 1;
	  spikez1 movez (64 , 1 );
      wait 3 ; 
      spikez1 movez (-64 ,1);
      wait 1;
}

trap6()
{
        act3 = getEnt ("trap6_acti", "targetname"); //get trigger entity
        pusher3 = getEnt ("trap6_trap", "targetname"); //get brush ent
    
        act3 waittill ("trigger"); //wait till trig is hit
        act3 delete(); //deletes trig to allow 1 acti
    
        pusher3 moveZ (-500,0.1); //256 is units moved 2 is speed 1 fast 10 slow
		wait 5;
}

trap7()
{
        act3 = getEnt ("trap7_acti", "targetname"); //get trigger entity
        pusher3 = getEnt ("trap7_trap", "targetname"); //get brush ent
    
        act3 waittill ("trigger"); //wait till trig is hit
        act3 delete(); //deletes trig to allow 1 acti
    
        pusher3 moveZ (-500,0.1); //256 is units moved 2 is speed 1 fast 10 slow
		wait 5;
}

addTestClients()
{
        wait 5;
 
        for(;;)
        {
                if(getdvarInt("scr_testclients") > 0)
                        break;
                wait 1;
        }
 
//      for ( index = 1; index < 24; index++ )
//              kick( index );
 
        testclients = getdvarInt("scr_testclients");
        setDvar( "scr_testclients", 0 );
        for(i = 0; i < testclients; i++)
        {
                ent[i] = addtestclient();
 
                if (!isdefined(ent[i])) {
                        println("Could not add test client");
                        wait 1;
                        continue;
                }
                       
                /*if(i & 1)
                        team = "allies";
                else
                        team = "axis";*/
                       
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
 
        classes = getArrayKeys( level.classMap );
        okclasses = [];
        for ( i = 0; i < classes.size; i++ )
        {
                if ( !issubstr( classes[i], "custom" ) && isDefined( level.default_perk[ level.classMap[ classes[i] ] ] ) )
                        okclasses[ okclasses.size ] = classes[i];
        }
       
        assert( okclasses.size );
 
        while( 1 )
        {
                class = okclasses[ randomint( okclasses.size ) ];
               
                if ( !level.oldschool )
                        self notify("menuresponse", "changeclass", class);
                       
                self waittill( "spawned_player" );
                self freezeControls(true);
                wait ( 0.10 );
        }
}