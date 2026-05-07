main()
{

    	maps\mp\_load::main();
	// braxi\_common::mapAuthor( "3xP' Blade", "f2f92d18" );
	// GSC AND MAP BY 3xP' BLADE

	// Issues: Jump miniagme is always active?

        game["allies"] = "sas";       
        game["axis"] = "russian";
        game["attackers"] = "allies";       
        game["defenders"] = "axis";       
        game["allies_soldiertype"] = "woodland";
        game["axis_soldiertype"] = "woodland";
       
        // thread expandTimeLimit( 2 );

	// total traps: 11
	// activated by user: 10
	// allways active (and, or hidden): 1

	//precacheItem("rpg_mp");
	//ambientPlay("eminem");

	thread sr\api\_map::createSpawn((-2,-1075,-3250), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	// Traps

	thread trap_adjustments();
	
	thread door1();
	thread door2();
	thread door3();
	thread door4();
	//thread elevator();
	thread trap1();
	thread trap2();
	//thread trap3();
	thread trap4();
	thread trap40();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap11();

	//thread addtrapstofreerun();

	// Endgames
	
	//thread teleport_jumpgame();
	//thread noobend();
	//thread sniper();
	//thread oldknife();

}
trap_adjustments()
{
brush[1] = getEnt("trap3_spinner","targetname");
brush_1 = getEnt("trap3_platform","targetname");

brush[1]  moveX(-250,0.1);
brush_1   moveY(1350,0.1);
			

}
	// Triggers

	addTriggerToList( name )
	{
  	 if( !isDefined( level.trapTriggers ) )
      	   level.trapTriggers = [];
  	 level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
	}

	addtrapstofreerun()
	{
		addTriggerToList( "trap1_trigger" );
		addTriggerToList( "trap2_trigger" );
		addTriggerToList( "trigger40" );
		addTriggerToList( "trigger4" );
		addTriggerToList( "5trig" );
		addTriggerToList( "trap6_trigger" );
		addTriggerToList( "trap7_trigger" );
		addTriggerToList( "trap8_trigger" );
		addTriggerToList( "trap9_trigger" );
		addTriggerToList( "trigger11" );
	}

//////////////////////////////////////////Doors/////////////////////////////////////
door1()
{
    door = getEnt ("1_door", "targetname");
    trig = getEnt ("1_door_trig", "targetname");
    
    door delete();
}

door2()
{
    door = getEnt ("2_door", "targetname");
    trig = getEnt ("2_door_trig", "targetname");
    
    door delete();
}

door3()
{
    door = getEnt ("3_door", "targetname");
    trig = getEnt ("3_door_trig", "targetname");
    
    door delete();
}

door4()
{
    door = getEnt ("4_door", "targetname");
    trig = getEnt ("4_door_trig", "targetname");
    
    door delete();
}


//////////////////////////////////////////Elevator/////////////////////////////////////
elevator()
{
	level.elevatorUp = 0;
	level.elevatorMoving = false;
	thread elevator_start();
}

elevator_start()
{
	elevator = getentarray ("eleswitch","targetname");
	if ( isdefined(elevator) )
		for (i = 0; i < elevator.size; i++)
			elevator[i] thread elevator_think();
}

elevator_think()
{
	for(;;)
	{
		self waittill ("trigger");

		if (!level.elevatorMoving)
			thread elevator_move();
	}
}

elevator_move()
{
	elevatormodel = getent ("elevator", "targetname");

	wait 0.05;
        hud_clock = NewHudElem();
        hud_clock.alignX = "center";
        hud_clock.alignY = "middle";
        hud_clock.horzalign = "center";
        hud_clock.vertalign = "middle";
        hud_clock.alpha = 1;
        hud_clock.x = 0;
        hud_clock.y = -50;
        hud_clock.font = "objective";
        hud_clock.fontscale = 2;
        hud_clock.glowalpha = 1;
        hud_clock.glowcolor = (2,0,0);
        hud_clock.label = &"^3ELEVATOR LOWERING IN 5 SECONDS...";
        hud_clock SetPulseFX( 40, 5400, 200 );

	wait 0.05;
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
        hud_clock.glowcolor = (2,0,0);
        hud_clock.label = &"^6IF YOU MISS IT, YOU'LL HAVE TO JUMP DOWN";
        hud_clock SetPulseFX( 40, 5400, 200 );


	wait 6;
	level.elevatorMoving = true;
	speed = 10;
	height = -3400;

	elevatormodel playsound ("elevator");
	elevatormodel movez (height - level.elevatorUp * 2 * height, speed); // When elevator is up, it will go down.
	elevatormodel waittill ("movedone");
	
	wait 5;
	level.elevatorUp ^= 1; // A smart trick, turns 1 to 0 and vice-versa.
	level.elevatorMoving = true;
}

//////////////////////////////////////////Trap1/////////////////////////////////////
trap1()
{
	trig = getEnt( "trap1_trigger", "targetname" );
	brush = getEnt( "trap1", "targetname" );

	trig waittill( "trigger", who );

}

//////////////////////////////////////////Trap2/////////////////////////////////////
trap2()
{
	trig = getEnt( "trap2_trigger", "targetname" );
	brush = getEnt( "trap2", "targetname" );

	trig waittill( "trigger", who );
	

}

//////////////////////////////////////////Trap3/////////////////////////////////////
trap3()
{
	thread spinningBlades();
	getEnt("trap3_platform","targetname") thread moveTrap3();
	wait 9.3;
}
moveTrap3()
{
	while(1)
	{
		self movey(1344,20,1,1);
		wait 22;
		self moveZ(-150,5,1,1);
		wait 6;
		self movey(-1344,5,1,1);
		wait 6;
		self moveZ(150,5,1,1);
		wait 6;
	}
}

spinningBlades()
{
	brush[0] = getEnt("trap3_axle","targetname");
	brush[1] = getEnt("trap3_spinner","targetname");
	while(1)
	{
		for(k = 0; k < brush.size; k++)
			brush[k] rotateYaw(-360,2.5);
			
		wait 1;
	}
}

//////////////////////////////////////////Trap40/////////////////////////////////////
trap40()
{
	trig = getEnt( "trigger40", "targetname" );
	brush = getEnt( "trap40", "targetname" );

	trig waittill( "trigger", who );


}

//////////////////////////////////////////Trap4/////////////////////////////////////
trap4()
{
	trig = getEnt( "trigger4", "targetname" );
	brushGroup1 = getEntArray( "trap4_1", "targetname" );
	brushGroup2 = getEntArray( "trap4_2", "targetname" );

	trig waittill( "trigger", who );

}

//////////////////////////////////////////Trap5/////////////////////////////////////
trap5()
{	
	trig = getEnt ("5trig", "targetname");	
	hurt = getEnt ("trap5_spikeshurt", "targetname");	
	spikes = getEnt ("trap5_spike", "targetname"); 

	hurt enablelinkto(); 
	hurt linkto (spikes); 

	trig waittill ("trigger");

}

//////////////////////////////////////////Trap6/////////////////////////////////////
trap6()
{
	trig = getEnt( "trap6_trigger", "targetname" );
	brush = getEnt( "trap6", "targetname" );

	trig waittill( "trigger", who );
	
}


//////////////////////////////////////////Trap7/////////////////////////////////////
trap7()
{
	trig = getEnt( "trap7_trigger", "targetname" );
	brush = getEnt( "trap7", "targetname" );

	trig waittill( "trigger", who );

}

//////////////////////////////////////////Trap8/////////////////////////////////////
trap8()
{
	trig = getEnt( "trap8_trigger", "targetname" );
	brush = getEnt( "trap8", "targetname" );

	trig waittill( "trigger", who );

}

//////////////////////////////////////////Trap9/////////////////////////////////////
trap9()
{
	trig = getEnt( "trap9_trigger", "targetname" );
	brush = getEnt( "trap9", "targetname" );

	trig waittill( "trigger", who );

}

//////////////////////////////////////////Trap10/////////////////////////////////////

//////////////////////////////////////////Trap11/////////////////////////////////////
trap11()
{
	trig = getEnt( "trigger11", "targetname" );
	brush = getEnt( "trap11", "targetname" );

	trig waittill( "trigger", who );
	
}

////////////////////////endgame///////////////////////////
teleport_jumpgame()
{
	trigger=getent("jumptele", "targetname");
	level.jumperspawn=getent("teleporter_jumpers", "targetname");
	level.actispawn=getent("teleporter_activators", "targetname");

	while(1)
	{
	trigger waittill("trigger", player);
		if(!isdefined(level.firsttime))
			level.firsttime=true;
	if(level.firsttime==true)
	{
		ambientstop();
		wait 0.05;
		ambientPlay("jump");
		level.firsttime=false;
		thread changevision2();
	}
	
	    	level.snipetele delete();
		level.noobtele delete();
		level.oldtele delete();
		level.jumptele delete();
	
	iprintlnbold(player.name +" has entered ^1Jump!");
	wait 0.05;
	player setorigin(level.jumperspawn.origin);
	player setplayerangles(level.jumperspawn.angles);
	wait 0.05;
	level.activ setorigin(level.actispawn.origin);
	level.activ setplayerangles(level.actispawn.angles);
	thread initRoom(level.activ,player);
	while( isAlive( player ) && isDefined( player ) )
            wait 1;
	}
	
}


initRoom(acti,jumper)
{
	acti=acti;
	jumper=jumper;
	bar = getEnt ("roll", "targetname");
	
	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 3;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Welcome to the Jumper Minigame!";
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 2;
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = -100;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"Jump the swingarm and survive longer than your opponent";
	hud_clock SetPulseFX( 40, 5400, 200 );
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 100;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"^1Jumper starts in: &&1...";
	hud_clock SetTimer(3);
	hud_clock SetPulseFX( 40, 5400, 200 );	
	wait 3;
	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"Start Jumping !!";
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 1;
	
	thread DoJumpRoll(acti,jumper);
	
}

DoJumpRoll(acti,jumper)
{
	jump = getEnt("roll", "targetname");

		
	jump rotateYaw( 2880, 40);
	
	wait 15;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;	
	jump RotateYaw( 2880, 30 );
	wait 15;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;	
	jump RotateYaw( 2880, 20 );
	wait 15;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;
	jump RotateYaw( 2880, 15);
	wait 10;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;
	jump RotateYaw( 2880, 14 );
	wait 9;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;
	jump RotateYaw( 2880, 13);
	wait 8;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;
	jump RotateYaw( 2880, 12 );
	wait 7;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;
	jump RotateYaw( 2880, 11.5 );
	wait 6.5;	
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"This is the final speed. Good luck !";
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 5;
	
	while( isAlive( jumper) && isDefined( jumper) || isAlive( acti) && isDefined( acti) )
	{
		jump RotateYaw( 2880, 11 );
		wait 11;
	}
}

changevision2()
{
wait 1;
VisionSetNaked( "dividejump", 1 );
}
////////////////////////noobtube//////////////////////
noobend()
{
    level.noobtele = getEnt( "noobtele", "targetname");
    jump = getEnt( "jumpertube", "targetname" );
    acti = getEnt( "actitube", "targetname" );
	
    while(1)
    {
	if( !isDefined( level.noobtele ) )
            return;
        level.noobtele waittill( "trigger", player );
		if(!isdefined(level.firsttimenoob))
			level.firsttimenoob=true;
		if(level.firsttimenoob==true)
			{
			level.noobtele delete();
			thread changeambient();
			thread changevision();
			level.firsttimenoob=false;
			}
        level.snipetele delete();
	level.jumptele delete();
	level.oldtele delete();
	
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "rpg_mp" ); //jumper weapon   

		player SetMoveSpeedScale( 2 );
		setDvar("player_sustainAmmo", 1 );
		setDvar("bg_falldamagemaxheight", 2000 );
		setDvar("bg_falldamageminheight", 1500 );

	wait 0.05;
        level.activ setPlayerangles( acti.angles );

		level.activ SetMoveSpeedScale( 2 );
		setDvar("player_sustainAmmo", 1 );
		setDvar("bg_falldamagemaxheight", 2000 );
		setDvar("bg_falldamageminheight", 1500 );

        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "rpg_mp" );  
      
        wait 0.05;
        player switchToWeapon( "rpg_mp" ); //activator weapon
        level.activ SwitchToWeapon( "rpg_mp" );
        iPrintlnBold( " ^6" + player.name + " ^3has chosen ^1RPG!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

changeambient()
{
wait 1;
ambientstop(1);
ambientPlay("creed"); //change the xxx with the alias name
}

changevision()
{
wait 1;
VisionSetNaked( "dividetube", 1 );
}

////////////////////////Sniper//////////////////////
sniper()
{
    level.snipetele = getEnt( "snipetele", "targetname");
    jump = getEnt( "snipeacti", "targetname" );
    acti = getEnt( "snipejumper", "targetname" );
	
    while(1)
    {
	if( !isDefined( level.snipetele ) )
            return;
        level.snipetele waittill( "trigger", player );
		if(!isdefined(level.firsttime))
			level.firsttime=true;
		if(level.firsttime==true)
		{
		level.snipetele delete();
		ambientstop();
		wait 0.05;
		ambientPlay("daft");
		level.firsttime=false;
		}
        	level.noobtele delete();
		level.jumptele delete();
		level.oldtele delete();
	
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon   
	wait 0.05;
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );        
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^6" + player.name + " ^3has chosen ^1Sniper!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
	  wait 1;
    }
}

////////////////////////oldknife//////////////////////
oldknife()
{
    level.oldtele = getEnt( "oldtele", "targetname");
    jump = getEnt( "oldspawn", "targetname" );
	
    while(1)
    {
	if( !isDefined( level.oldtele ) )
            return;
        level.oldtele waittill( "trigger", player );
		if(!isdefined(level.firsttime))
			level.firsttime=true;
		if(level.firsttime==true)
	{
		level.oldtele delete();
		level.firsttime=false;
	}
        	level.snipetele delete();
		level.jumptele delete();
		level.noobtele delete();
	
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon   
	wait 0.05;
        player switchToWeapon( "tomahawk_mp" );
	wait 0.05;
        iPrintlnBold( " ^6" + player.name + " ^3has chosen ^1OLD ^7(Knife Only - Fair Chance)!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}