main()
{
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
	thread speedrun\_way_name::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);
	maps\mp\_load::main();
    thread speedrun\_way_name::create_tp((-336.27, -973.907, 15.9623), 50, 15, (558, 1355, -1300), 270, "freeze", "blue", "s0");
    thread speedrun\_way_name::create_endmap((1871.13, -285.334, -1502.88),85,30, "s0");  

	PreCacheItem("brick_blaster_mp");
	PreCacheItem("ak47_mp");
	PreCacheItem("m14_mp");
	PreCacheItem("m60e4_mp"); 
	PreCacheItem("saw_mp");
	PreCacheItem("m1014_mp");
	PreCacheItem("mp44_mp");
	PreCacheItem("g3_mp");
	PreCacheItem("p90_mp");
	PreCacheItem("rpd_mp");
	PreCacheItem("ak74u_mp");

	/* [AUTO DELETE] ambientplay( "beat" ); */

	// thread trap1();
	// thread trap2();
	// thread elev();
	// thread signs();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread trap14b();
	// thread trap15();
	// thread trap16();
	/* [AUTO DELETE] thread secret(); */
	// thread lazers1();
	// thread lazers2();
	/* [AUTO DELETE] thread deagle(); */
	/* [AUTO DELETE] thread bounce(); */
	/* [AUTO DELETE] thread knife(); */
	// thread snip();
	/* [AUTO DELETE] thread weapons(); */
	// thread games();
	// thread ranks();
	/* [AUTO DELETE] thread old(); */
	// thread stage2();
	// thread Acti_stage1();
	// thread Acti_stage2();
	// thread ammo1();
	// thread ammo2();
	// thread ammo3();
	/* [AUTO DELETE] thread bouncerspawn(); */
	/* [AUTO DELETE] thread bounceelev(); */
	/* [AUTO DELETE] thread bouncegun(); */
	// thread lol();
	// thread hardstart();
	// thread hardfail1();
	// thread hardfail2();
	// thread hardfail3();
	// thread hardend();
	// thread actimsg();

	addTriggerToList("trigger1");
    addTriggerToList("trigger2");
    addTriggerToList("trigger3");
    addTriggerToList("trigger5");
    addTriggerToList("trigger6");
    addTriggerToList("trigger7");
    addTriggerToList("trigger8");
    addTriggerToList("trigger9");
    addTriggerToList("trigger10");
    addTriggerToList("trigger11");
	addTriggerToList("trigger12");
	addTriggerToList("trigger13");
	addTriggerToList("trigger14");
	addTriggerToList("trigger15");
	addTriggerToList("notsolid2");

}


touching(ent)
{
	level endon("game_ended");
	while(1)
	{
		players = getEntArray("player","classname");	
		for(i = 0; i < players.size; i++)
		{
			if(players[i] isTouching(ent))
				players[i] suicide();
		}
		wait .05;
	}
}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

		
SetTimeLimit( time )
{
    wait 0.05;
	if( level.dvar["time_limit"] <= time )
		level.dvar["time_limit"] = time;
}


signs()
{
	sign1 = getent( "sign1", "targetname" );
	sign2 = getent( "sign2", "targetname" );
	sign3 = getent( "sign3", "targetname" );

 	for( ;; )
	{
	
		sign1 show();
		sign1 notsolid();
		sign2 hide();
		sign2 notsolid();
		sign3 hide();
		sign3 notsolid();
		wait 5;
		sign1 hide();
		sign1 notsolid();
		sign2 show();
		sign2 notsolid();
		sign3 hide();
		sign3 notsolid();
		wait 5;
		sign3 show();
		sign3 notsolid();
		sign2 show();
		sign2 notsolid();
		sign1 hide();
		sign1 notsolid();
		wait 5;
		
	}	
}



games()
{
     	level.games_trig = getEnt( "minigames", "targetname");
     	games = getEnt( "minigames_ori", "targetname" );
     
     	while(1)
     	{
         	level.games_trig waittill( "trigger", player );
         	if( !isDefined( level.games_trig ) )
         	return;

		level.games_trig SetHintstring ("^1Please wait!");

		level.old_trig delete();

         	player SetPlayerAngles( games.angles );
         	player setOrigin( games.origin );
	 	/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the  minigames section^1!" ); */
         	/* [AUTO DELETE] player TakeAllWeapons(); */
	 	player died();
	
	             
  //        	while( isAlive( player ) && isDefined( player ) )
		// if( isDefined( level.activ ) && isAlive( level.activ ) )
  //            	/* [AUTO DELETE] wait 1; */
  //    	}
}
}


died()
{
	self endon("disconnect");

	self waittill("death");
	/* [AUTO DELETE] iPrintlnBold("^2"+self.name+" ^5died^1!"); */
	/* [AUTO DELETE] iPrintlnBold("^2The Minigames Section is now ^5open^1."); */
	level.games_trig SetHintstring ("^2Minigames.");
}


actimsg()
{
     	actimsg = getEnt( "acti_msg", "targetname");
     
        actimsg waittill( "trigger" );

	actimsg delete();

	wait 1;
	
	/* [AUTO DELETE] level.activ iPrintlnBold( " ^2" + level.activ.name + "^1, ^5kill all  the jumpers with your deadly traps^1!" ); */               
}


weapons()
{
	level.weapons_trig = getent("run_start","targetname");
    	jump = getEnt( "weap_jump", "targetname" );
    	acti = getEnt( "weap_acti", "targetname" );
	while(1)
	{
		level.weapons_trig waittill("trigger", player);
		if( !isDefined( level.weapons_trig ) )
        	return;
		
		gun = randomintrange(0, 11);
		weapon = "ak74u_mp";
		if(gun == 0)
		{
			weapon = "brick_blaster_mp";
		}
		else if(gun == 1)
		{
			weapon = "m14_mp";
		}
		else if(gun == 2)
		{
			weapon = "m60e4_mp";
		}
		else if(gun == 3)
		{
			weapon = "saw_mp";
		}
		else if(gun == 4)
		{
			weapon = "m1014_mp";
		}
		else if(gun == 5)
		{
			weapon = "mp44_mp";
		}
		else if(gun == 6)
		{
			weapon = "g3_mp";
		}
		else if(gun == 7)
		{
			weapon = "ak47_mp";
		}
		else if(gun == 8)
		{
			weapon = "deserteagle_mp";
		}
		else if(gun == 9)
		{
			weapon = "p90_mp";
		}
		else if(gun == 10)
		{
			weapon = "rpd_mp";
		}
		
        	player SetPlayerAngles( jump.angles );
        	player setOrigin( jump.origin );
        	/* [AUTO DELETE] player TakeAllWeapons(); */
        	/* [AUTO DELETE] player GiveWeapon( weapon ); */	
		/* [AUTO DELETE] player GiveMaxAmmo( weapon ); */ 
        	level.activ setPlayerangles( acti.angles );
        	level.activ setOrigin( acti.origin );
        	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
        	/* [AUTO DELETE] level.activ GiveWeapon( weapon ); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo( weapon ); */ 
		/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the  Weapons room^1!" ); */               
        	wait 0.05;
        	/* [AUTO DELETE] player switchToWeapon( weapon ); */ 
        	/* [AUTO DELETE] level.activ SwitchToWeapon( weapon ); */ 
		player freezecontrols(true); 
		level.activ freezecontrols(true);
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
		/* [AUTO DELETE] player iPrintlnBold( "^5Fight^1!" ); */
		/* [AUTO DELETE] level.activ iPrintlnBold( "^5Fight^1!" ); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
	}
}



knife()
{
     	level.knife_trig = getEnt( "knife", "targetname");
     	jump = getEnt( "knife_jump", "targetname" );
     	acti = getEnt( "knife_acti", "targetname" );
     
     	while(1)
     	{
         	level.knife_trig waittill( "trigger", player );
         	if( !isDefined( level.knife_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	/* [AUTO DELETE] player TakeAllWeapons(); */
         	/* [AUTO DELETE] player GiveWeapon( "tomahawk_mp" ); */      
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
         	/* [AUTO DELETE] level.activ GiveWeapon( "tomahawk_mp" ); */ 
		/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the Knife  room^1!" ); */               
         	wait 0.05;
         	/* [AUTO DELETE] player switchToWeapon( "tomahawk_mp" ); */
         	/* [AUTO DELETE] level.activ SwitchToWeapon( "tomahawk_mp" ); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
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
		/* [AUTO DELETE] player iPrintlnBold( "^5Fight^1!" ); */
		/* [AUTO DELETE] level.activ iPrintlnBold( "^5Fight^1!" ); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		     
     	}
}


bounce()
{
     	level.bounce_trig = getEnt( "assault", "targetname");
     	jump = getEnt( "bounce_tele_jump", "targetname" );
     	acti = getEnt( "bounce_tele_acti", "targetname" );
     
     	while(1)
     	{
         	level.bounce_trig waittill( "trigger", player );
         	if( !isDefined( level.bounce_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player giveweapon( "tomahawk_mp" ); */     
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ giveweapon( "tomahawk_mp" ); */ 
		/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the Bounce  room^1!" ); */         
         	wait 0.05;
		/* [AUTO DELETE] level.activ switchtoweapon( "tomahawk_mp" ); */
		/* [AUTO DELETE] player switchtoweapon( "tomahawk_mp" ); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
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
		/* [AUTO DELETE] player iPrintlnBold( "^5Bounce^1!" ); */
		/* [AUTO DELETE] level.activ iPrintlnBold( "^5Bounce^1!" ); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);     
     	}
}


old()
{
   	level.old_trig = getEnt ("oldtrig" , "targetname");
   	brush = getEnt ("old" ,"targetname" );
	level.old_trig sethintstring( "Press ^3[Use] ^7to enter the old way."  );

	if( !isDefined( level.freeRun ) )
	wait 0.1;

	if( isDefined( level.freeRun ) && level.freeRun )
	{

		level.games_trig delete();
		level.old_trig delete();
		level.secret_trig delete();
		return;
	}

   	level.old_trig waittill ("trigger",player);
	level.old_trig delete();
	level.games_trig delete();

	/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the Old way^1!" ); */    
   
   	brush moveZ ( -600 , 4);
}

	
snip()
{
     	level.snip_trig = getEnt( "sniper", "targetname");
     	jump = getEnt( "snip_jump", "targetname" );
     	acti = getEnt( "snip_acti", "targetname" );
     
     	while(1)
     	{
         	level.snip_trig waittill( "trigger", player );
         	if( !isDefined( level.snip_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	/* [AUTO DELETE] player TakeAllWeapons(); */
         	/* [AUTO DELETE] player GiveWeapon( "m40a3_mp" ); */
	 	/* [AUTO DELETE] player givemaxammo( "m40a3_mp" ); */
         	/* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
	 	/* [AUTO DELETE] player givemaxammo( "remington700_mp" ); */       
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
         	/* [AUTO DELETE] level.activ GiveWeapon( "m40a3_mp" ); */
	 	/* [AUTO DELETE] level.activ givemaxammo( "m40a3_mp" ); */
         	/* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */
	 	/* [AUTO DELETE] level.activ givemaxammo( "remington700_mp" ); */
		/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the Sniper  room^1!" ); */         		
		/* [AUTO DELETE] wait .5; */
         	/* [AUTO DELETE] player switchToWeapon( "m40a3_mp" ); */
         	/* [AUTO DELETE] level.activ SwitchToWeapon( "m40a3_mp" ); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
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
		/* [AUTO DELETE] player iPrintlnBold( "^5Fight^1!" ); */
		/* [AUTO DELETE] level.activ iPrintlnBold( "^5Fight^1!" ); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);        
     	}
}


deagle()
{
     	level.deagle_trig = getEnt( "deagle", "targetname");
     	jump = getEnt( "deagle_jump", "targetname" );
     	acti = getEnt( "deagle_acti", "targetname" );
     
     	while(1)
     	{
         	level.deagle_trig waittill( "trigger", player );
         	if( !isDefined( level.deagle_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	/* [AUTO DELETE] player TakeAllWeapons(); */
         	/* [AUTO DELETE] player GiveWeapon( "deserteagle_mp" ); */
	 	/* [AUTO DELETE] player givemaxammo( "deserteagle_mp" ); */      
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
         	/* [AUTO DELETE] level.activ GiveWeapon( "deserteagle_mp" ); */
	 	/* [AUTO DELETE] level.activ givemaxammo( "deserteagle_mp" ); */
		/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + " ^5 has entered the Deagle  room^1!" ); */         		
		wait 0.05;
         	/* [AUTO DELETE] player switchToWeapon( "deserteagle_mp" ); */
         	/* [AUTO DELETE] level.activ SwitchToWeapon( "deserteagle_mp" ); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
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
		/* [AUTO DELETE] player iPrintlnBold( "^5Fight^1!" ); */
		/* [AUTO DELETE] level.activ iPrintlnBold( "^5Fight^1!" ); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);        
     	}
}


trap1()
{
	level endon("trigger");
	trig = getEnt("trigger1","targetname");
 	brush1 = getEnt("trap1_ran1","targetname");
 	brush2 = getEnt("trap1_ran2","targetname");

	trig waittill("trigger");
	trig SetHintstring ("^1Activated!");
	random = randomInt(2);
	switch(random)
	{
		case 0:	brush1 delete();
				break;
				
		case 1:	brush2 delete();
				break;
				
		default: return;
	}
}


trap2()
{
	level endon("trigger");
	trig = getEnt("trigger2","targetname");
 	brush1 = getEnt("trap2_ran1","targetname");
 	brush2 = getEnt("trap2_ran2","targetname");

	trig waittill("trigger");
	trig SetHintstring ("^1Activated!");
	random = randomInt(2);
	switch(random)
	{
		case 0:	brush1 delete();
				break;
				
		case 1:	brush2 delete();
				break;
				
		default: return;
	}
}

	
elev()
{
   	brush = getEnt ("trap_ele" ,"targetname" );
	wait 5;
 
	while(true) 
	{ 
		brush moveto ((-4664,-652,296.5),6,2,2); 
		brush waittill ("movedone"); 
		wait 5; 
		brush moveto ((-3624, -680, 11),6,2,2); 
		brush waittill ("movedone"); 
		wait 5; 
	}
}


trap3()
{
	level endon("trigger");
	trig = getEnt( "trigger3", "targetname" );
	brush = getEnt( "trap3", "targetname" );

	trig waittill( "trigger", player );
	trig SetHintstring ("^1Activated!");

	while( isDefined( brush ) )
	{
		brush rotateRoll( 360, 5 );
		wait 5;
	}
}


trap4()
{
	level endon("trigger");
	trig = getEnt( "trigger5", "targetname" );
	brush = getEnt( "trap5", "targetname" );

	trig waittill( "trigger", player );
	trig SetHintstring ("^1Activated!");

	while( isDefined( brush ) )
	{
		brush rotateRoll( 360, 4.5 );
		wait 4.5;
	}
}


trap5()
{
	level endon("trigger");
	trig = getEnt("trigger6","targetname");
 	brush1 = getEnt("trap6_ran1","targetname");
 	brush2 = getEnt("trap6_ran2","targetname");
	brush3 = getEnt("trap6_ran3","targetname");

	trig waittill("trigger");
	trig SetHintstring ("^1Activated!");
	while(1)
	{
		brush1 rotateyaw( 360, 2 );
		wait 2;
		brush2 rotateyaw( 360, 2 );
		wait 2;
		brush3 rotateyaw( 360, 2 );
		wait 2;
	}
}

	
trap6()
{
	level endon("trigger");
   	trig = getEnt ("trigger7" , "targetname");
   	brush = getEnt ("trap7" ,"targetname" );

   	trig waittill ("trigger",player);  
	trig SetHintstring ("^1Activated!");

   	while( 1 )
   	{
   
   		brush moveZ ( 90 , 1);
   		wait 1;
  	 	brush moveZ ( -90, 1 );
   		wait 1;
	}
}


trap7()
{
	level endon("trigger");
	trig = getEnt("trigger8","targetname");
 	brush1 = getEnt("trap8_ran1","targetname");
 	brush2 = getEnt("trap8_ran2","targetname");

	trig waittill("trigger");
	trig SetHintstring ("^1Activated!");
	random = randomInt(2);
	switch(random)
	{
		case 0:	brush1 delete();
				break;
				
		case 1:	brush2 delete();
				break;
				
		default: return;
	}
}


trap8()
{
	level endon("trigger");
	trig = getEnt( "trigger9", "targetname" );
	brush = getEnt( "trap9_1", "targetname" );	
	brush1 = getEnt( "trap9_2", "targetname" );

	trig waittill( "trigger", player );
	trig SetHintstring ("^1Activated!");

	while(1)
	{
		brush rotateroll( 360, 3 );
		brush1 rotateroll( -360, 3 );
		wait 3;
	}
}


trap9()
{
	level endon("trigger");
	trig = getEnt( "trigger10", "targetname" );
	brush = getEnt( "trap10", "targetname" );

	trig waittill( "trigger" );
	trig SetHintstring ("^1Activated!");

	while(1)
	{
		brush rotateyaw( 360, 2 );
		wait 2;
	}
}


trap11()
{
	level endon("trigger");
   	brush = getEnt ("trap12" ,"targetname" );
	trig = getEnt("trigger11","targetname");

	trig waittill("trigger");
	trig SetHintstring ("^1Activated!");

	brush moveZ( 600, .5);
	wait 3.5;	
	brush moveZ( -600, 3);
}



trap12()
{
	level endon("trigger");
   	trig = getEnt ("trigger12" , "targetname");
   	brush = getEnt ("trap13" ,"targetname" );
	
   	trig waittill ("trigger");
	trig SetHintstring ("^1Activated!");  
  
   	for( i = 0; i < 7; i++ )
	{
		brush rotateYaw( 360, 1 );
		wait 1;
	}
}


trap13()
{
	level endon("trigger");
   	brush = getEnt ("trap13_1" ,"targetname" );
   	brush1 = getEnt ("trap13_2" ,"targetname" );
	trig = getEnt ("trigger13" , "targetname");

	trig waittill ("trigger");
	trig SetHintstring ("^1Activated!");
     
   	while(1)
        {
		brush rotateRoll( 360, 1.5 );
		brush1 rotateRoll( -360, 1.5 );
		wait 1.5;
	}
}


trap14b() 

{
	moveTime = 1;

	up = [];

	down = [];

	for( i = 0; i < 10; i++ )

	{

		up[i] = getEnt( "trap14_up"+(i+1), "targetname" );

		down[i] = getEnt( "trap14_down"+(i+1), "targetname" );

	}

 

 

	while( 1 )

	{

		for( i = 0; i < up.size; i++ )

		{

			up[i] moveZ( 112, moveTime );

			wait 0.1;

		}

 
		wait moveTime;

 

		for( i = 0; i < down.size; i++ )

		{

			down[i] moveZ( -112, moveTime );

			wait 0.1;

		}

 

		wait moveTime;

 

		for( i = 0; i < up.size; i++ )

		{

			up[i] moveZ( -112, moveTime );

			wait 0.1;

		}

 

		wait moveTime;

 

		for( i = 0; i < down.size; i++ )

		{

			down[i] moveZ( 112, moveTime );

			wait 0.1;

		}

 

		wait moveTime;

 

	}

}


trap14()
{
	level endon("trigger");
	brush = getEnt ("trap14_oben" ,"targetname" );
	things = getEnt ("things" ,"targetname" );
	trig = getEnt ("trigger14" , "targetname");

	trig waittill ("trigger");
	trig SetHintstring ("^1Activated!");

	brush notsolid();
	thread touching(brush);
   
   	while(1)
   	{
   	
		brush movez( -160 , .4);
		things movez( -160, .4);
  	 	wait 1;
		brush movez ( 160 , .4);
		things movez ( 160, .4);
		wait 1;
	}
}


trap15()
{
	level endon("trigger");
	trig = getEnt ("trigger15" , "targetname");
	brush = getEnt( "trap15_links", "targetname" );
	brush1 = getEnt( "trap15_rechts", "targetname" );

	trig waittill ("trigger");
	trig SetHintstring ("^1Activated!");

	brush notsolid();
	thread touching(brush);
	brush1 notsolid();
	thread touching(brush1);


	while(1)
	{
		brush rotateyaw( 360, 2.5 );
		brush1 rotateyaw( -360, 2.5 );
		wait 2.5;
	}
}


trap16()
{
	level endon("trigger");
	doors = getEnt ("trap16_doors" ,"targetname" );
	wall = getEnt ("trap16_wall" ,"targetname" );
	trig = getEnt ("trigger16" , "targetname");

	trig waittill ("trigger");
	trig SetHintstring ("^1Activated!");
   	
	doors movey( -306 , 2);
  	wait 2;
	wall movey ( 752 , 6);
	wait 6;
	wall movey ( -745 , 1);
	wait 1;
	doors movey( 306 , 2);
}


lazers1()
{
	lazer1 = getEnt ("trap11_1" , "targetname");
	
	lazer1 notsolid();
	thread touching(lazer1);

	while(1)
	{
		lazer1 movez( 192 , 0.7);
		wait 0.7;
		lazer1 movez( -192 , 0.7);
		wait 0.7;
	}
}


lazers2()
{
	lazer2 = getEnt ("lazer2" , "targetname");

	lazer2 notsolid();
	thread touching(lazer2);

	while(1)
	{
		lazer2 movex( 462 , 1.2);
		wait 1.2;
		lazer2 movex( -462 , 1.2);
		wait 1.2;
	}
}


secret()
{
   	trig = getEnt ("trigger_secret" , "targetname");
   	trig waittill ("trigger",player);  
   	trig delete();

	/* [AUTO DELETE] player giveweapon ("brick_blaster_mp"); */
	/* [AUTO DELETE] player givemaxammo ("brick_blaster_mp"); */
	wait .5;
	/* [AUTO DELETE] player switchtoweapon("brick_blaster_mp"); */

}


stage2()
{
	trigger = getEnt ("stage2", "targetname");
	target = getEnt ("stage2_ori", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}


trap162()
{

	self iPrintLnBold("Sorry, the host of this server likes to steal maps!");
	self iPrintLnBold("Redirecting you to correct server, don't touch anything!");
	wait 10;
	self thread braxi\_common::clientCmd( "disconnect; wait 10; connect 198.245.49.104:28965" );
	wait 1;

}


Acti_stage1()
{
	trig = getEnt ("stage1acti", "targetname");
	target1 = getEnt ("stage1_ran1", "targetname");
	target2 = getEnt ("stage1_ran2", "targetname");
	target3 = getEnt ("stage1_ran3", "targetname");
	target4 = getEnt ("stage1_ran4", "targetname");
	target5 = getEnt ("stage1_ran5", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		random = randomInt(5);
		switch(random)
		{
			case 0:	player SetOrigin(target1.origin);
				player SetPlayerAngles( target1.angles );
					break;
				
			case 1:	player SetOrigin(target2.origin);
				player SetPlayerAngles( target2.angles );
					break;

			case 2:	player SetOrigin(target3.origin);
				player SetPlayerAngles( target3.angles );
					break;
				
			case 3:	player SetOrigin(target4.origin);
				player SetPlayerAngles( target4.angles );
					break;

			case 4:	player SetOrigin(target5.origin);
				player SetPlayerAngles( target5.angles );
					break;
				
			default: return;
		}
	}
}


lol()
{
	lol = getEnt ("umad", "targetname");

	while(1)
	{
		lol movez( -10 , 1.5);
		wait 1.5;
		lol movez( 10, 1.5);
		wait 1.5;
	}
}


bouncegun()
{
	trig = getEnt("ak_trig","targetname");
	while(1)
	{
		trig waittill("trigger", player);
		
		if(player == level.activ)
		{
			wait .05;
			/* [AUTO DELETE] level.activ GiveWeapon( "skorpion_acog_mp"); */
			wait .05;
			/* [AUTO DELETE] level.activ switchToWeapon( "skorpion_acog_mp"); */
			/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^5Picked up the Peacekeeper^1!" ); */
			wait .05;
		}
		if(player != level.activ)
		{
			wait .05;
			/* [AUTO DELETE] level.activ GiveWeapon( "skorpion_acog_mp"); */
			wait .05;
			/* [AUTO DELETE] level.activ switchToWeapon( "skorpion_acog_mp"); */
			/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^5Picked up the Peacekeeper^1!" ); */
			wait .05;
		}
	}
}


bounceelev()
{
	elev = getEnt ("bounce_ele", "targetname");

	while(1)
	{
		elev movez( 194 , 1.5);
		wait 1.5;
		elev movez( -194 , 1.5);
		wait 1.5;
	}
}


bouncerspawn()
{
trig = getent("bounce_tele", "targetname");
jump = getEnt( "bounce_tele_jump", "targetname" );
acti = getEnt( "bounce_tele_acti", "targetname" );

for(;;)
{
trig waittill( "trigger", player );
if(player.pers["team"] == "axis")
{
    level.activ setPlayerangles( acti.angles );
    level.activ setOrigin( acti.origin );
}
if(player.pers["team"] == "allies")
{
    player setplayerangles( jump.angles, 3 );
    player setorigin( jump.origin, 3 );
}
}
}



	
ammo1()
{
	snipe = getEnt ("sniper_ammo2", "targetname");

	while(1)
	{
		snipe waittill ("trigger", player);
		
		/* [AUTO DELETE] player Givemaxammo( "m40a3_mp" ); */
		/* [AUTO DELETE] player Givemaxammo( "remington700_mp" ); */
	}
}


ammo2()
{
	deagle = getEnt ("deagle_ammo1", "targetname");

	while(1)
	{
		deagle waittill ("trigger", player);
		
		/* [AUTO DELETE] player Givemaxammo( "deserteagle_mp" ); */
	}
}


ammo3()
{
	deagle = getEnt ("deagle_ammo2", "targetname");

	while(1)
	{
		deagle waittill ("trigger", player);
		
		/* [AUTO DELETE] player Givemaxammo( "deserteagle_mp" ); */
	}
}


hardstart()
{
	level.secret_trig = getEnt ("secret_entertrig", "targetname");
	target1 = getEnt ("hard_start", "targetname");
	
	for(;;)
	{
		level.secret_trig waittill ("trigger", player);
		
		level.fail = 0;
		
		/* [AUTO DELETE] player iPrintlnBold( "^5Good luck^1! ^5Remember^1, ^5you only  have 15 tries in my secret^1." ); */	
		player SetOrigin(target1.origin);
		player SetPlayerAngles( target1.angles );

	}
}



ranks()
{
	rank_trig = getEnt("first", "targetname");

	level.rank = 0;	
	
	while(1)
	{
		rank_trig waittill("trigger", player);
	
		level.rank += 1;
		
		if(!isDefined(player.rank))
		{
			player.rank = false;
		}

		if(isDefined(player.rank) && player.rank == false)
		{

			if(level.rank == 1)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^51st Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 2)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^52nd Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 3)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^53rd Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 4)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^54th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 5)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^55th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 6)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^56th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 7)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^57th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 8)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^58th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 9)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^59th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank == 10)
			{
				/* [AUTO DELETE] iPrintlnBold( "^1>> ^510th Place ^1<< \n ^2" +  player.name + " "); */
			}
			if(level.rank > 10)
			{
				/* [AUTO DELETE] iPrintlnBold( "^2" + player.name + " ^5has  finished the map^1! "); */
			}
			player.rank = true;
		}
		wait .5;
	}
}


hardfail1()
{
	trig = getEnt ("secret_tele1", "targetname");
	target1 = getEnt ("secret_fail1", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
	
		level.fail += 1;
		
		if(level.fail == 14)
		{
			/* [AUTO DELETE] player iPrintlnBold( "^1This is your last try!!" ); */
		}

		if(level.fail == 15)
		{
			player suicide();
		}
			
		player SetOrigin(target1.origin);
		player SetPlayerAngles( target1.angles );
	}
	/* [AUTO DELETE] wait .1; */
}


hardfail2()
{
	trig = getEnt ("secret_tele2", "targetname");
	target2 = getEnt ("secret_fail2", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
	
		level.fail += 1;
		
		if(level.fail == 14)
		{
			/* [AUTO DELETE] player iPrintlnBold( "^1This is your last try!!" ); */
		}

		if(level.fail == 15)
		{
			player suicide();
		}
			
		player SetOrigin(target2.origin);
		player SetPlayerAngles( target2.angles );
	}
	/* [AUTO DELETE] wait .1; */
}


hardfail3()
{
	trig = getEnt ("secret_tele3", "targetname");
	target3 = getEnt ("secret_fail3", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
	
		level.fail += 1;
		
		if(level.fail == 14)
		{
			/* [AUTO DELETE] player iPrintlnBold( "^1This is your last try!!" ); */
		}

		if(level.fail == 15)
		{
			player suicide();
		}
			
		player SetOrigin(target3.origin);
		player SetPlayerAngles( target3.angles );
	}
	/* [AUTO DELETE] wait .1; */
}


thing1()
{
	brush = getEnt ("elev2_1", "targetname");

	while(1)
	{
		brush movex( 1008 , 3);
		wait 3;
		brush movez( 160 , 1);
		wait 1;
		brush movex( -1008 , 3);
		wait 3;
		brush movez( -160 , 1);
		wait 1;
	}
}


thing2()
{
	brush = getEnt ("elev2_2", "targetname");

	while(1)
	{
		brush movez( 160 , 1);
		wait 1;
		brush movex( -1008 , 3);
		wait 3;
		brush movez( -160 , 1);
		wait 1;
		brush movex( 1008 , 3);
		wait 3;
	}
}


hardend()
{
	trig = getEnt ("theend", "targetname");
	target1 = getEnt ("theend_ori", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		player SetOrigin(target1.origin);
		player SetPlayerAngles( target1.angles );
		/* [AUTO DELETE] iPrintlnBold( " ^2" + player.name + "^5 is Godlike^1!" ); */
		/* [AUTO DELETE] player giveweapon( "ak47_mp" ); */
		/* [AUTO DELETE] player givemaxammo( "ak47_mp" ); */
		/* [AUTO DELETE] wait .1; */
		/* [AUTO DELETE] player switchtoweapon( "ak47_mp" ); */
	}
}


Acti_stage2()
{
	trig = getEnt ("stage2acti", "targetname");
	target1 = getEnt ("stage2_ran1", "targetname");
	target2 = getEnt ("stage2_ran2", "targetname");
	target3 = getEnt ("stage2_ran3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", user);
		random = randomInt(3);
		switch(random)
		{
			case 0:	user SetOrigin(target1.origin);
				user SetPlayerAngles( target1.angles );
					break;
				
			case 1:	user SetOrigin(target2.origin);
				user SetPlayerAngles( target2.angles );
					break;

			case 2:	user SetOrigin(target3.origin);
				user SetPlayerAngles( target3.angles );
					break;
				
			default: return;
		}
	}
}
