main()
{
   	maps\mp\_load::main();
	maps\mp\_teleport::main(); 
maps\mp\_load::main();
// ambientPlay("muza");


        level.fx_sparks = loadFx( "sparks/electric" );
    
	thread way_connect();
        // thread elevator();
        // thread elevator2();
        // thread elevator3();
        // thread elevator4();
        // thread elevator5();
	// thread elevator6();
	// thread elevator8();
	// thread elevator9();
	// thread elevator10();
	// thread elevator11();
        // thread twister();
        // thread twister2();
	// thread twister3();
	// thread finalFight();
	// thread finalFight1(); 
	// thread finalFight2(); 
	// thread finalFight3(); 

        // addTriggerToList( "elevator_trigger" );
        // addTriggerToList( "elevator2_trigger" );
        // addTriggerToList( "elevator3_trigger" );
        // addTriggerToList( "elevator4_trigger" );
        // addTriggerToList( "elevator5_trigger" );
        // addTriggerToList( "elevator6_trigger" );
        // addTriggerToList( "elevator8_trigger" );
        // addTriggerToList( "elevator9_trigger" );
        // addTriggerToList( "elevator10_trigger" );
        // addTriggerToList( "elevator11_trigger" );
        // addTriggerToList( "twister_trigger" );
        // addTriggerToList( "twister2_trigger" );

        
        elevatorparts = getentarray("elevator","targetname");
        if(isdefined(elevatorparts))
        {
        for(i=0;i<elevatorparts.size;i++)
        {
        wait(0.05);
        elevatorparts[i] thread elevator();
        }
        }

 elevatorparts = getentarray("elevator5","targetname");
        if(isdefined(elevatorparts))
        {
        for(i=0;i<elevatorparts.size;i++)
        {
        wait(0.05);
        elevatorparts[i] thread elevator5();
        }
        }


 elevatorparts = getentarray("elevator4","targetname");
        if(isdefined(elevatorparts))
        {
        for(i=0;i<elevatorparts.size;i++)
        {
        wait(0.05);
        elevatorparts[i] thread elevator4();
        }
        }

	elevatorparts = getentarray("elevator3","targetname");
        if(isdefined(elevatorparts))
        {
        for(i=0;i<elevatorparts.size;i++)
        {
        wait(0.05);
        elevatorparts[i] thread elevator3();
        }
        }

	elevatorparts = getentarray("elevator2","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread elevator2();
	}
	}

	elevatorparts = getentarray("elevator6","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread elevator6();
	}
	}


elevatorparts = getentarray("elevator8","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread elevator8();
	}
	}

elevatorparts = getentarray("elevator9","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread elevator9();
	}
	}

elevatorparts = getentarray("elevator10","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread elevator10();
	}
	}

elevatorparts = getentarray("elevator11","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread elevator11();
	}
	}
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

elevator10()
{
trigger = getEnt("trigger_elevator10", "targetname");
trigger waittill("trigger", player);
trigger delete();
while(1)
{
wait(0.01);
self movez(-100, 2, 0.5, 1);
self waittill("movedone");
wait(500);
} 
}

elevator11()
{
trigger = getEnt("trigger_elevator11", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movez(100, 0.05, 0.02, 0.02);
self waittill("movedone");
wait(0.01);
self movez(-100, 0.05, 0.02, 0.02);
self waittill("movedone");
wait(0.01);
}
}
elevator()
{
trigger = getEnt("trigger_elevator", "targetname");
while(1)
{
wait(0.01);
self movez(448, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movez(-448, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
} 
}

elevator2()
{
trigger = getEnt("trigger_elevator2", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movey(-550, 1, 0.5, 0.5);
self waittill("movedone");
wait(0.5);
self movey(550, 1, 0.5, 0.5);
self waittill("movedone");
wait(10.5);
} 
}

elevator3()
{
trigger = getEnt("trigger_elevator3", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movey(-550, 1, 0.5, 0.5);
self waittill("movedone");
wait(0.5);
self movey(550, 1, 0.5, 0.5);
wait(1.5);
} 
}

elevator4()
{
trigger = getEnt("trigger_elevator4", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movez(-500, 2, 0.5, 1);
wait(500);
} 
}

elevator5()
{
trigger = getEnt("trigger_elevator5", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movez(-500, 2, 0.5, 1);
wait(500);
} 
}

elevator6()
{
trigger = getEnt("trigger_elevator6", "targetname");
trigger waittill("trigger", player);
trigger delete();
while(1)
{
wait(0.01);
self movez(316, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movez(-316, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
} 
}



elevator8()
{
trigger = getEnt("trigger_elevator8", "targetname");
trigger waittill("trigger", player);
trigger delete();
while(1)
{
wait(0.01);
self movey(-300, 2, 0.5, 1);
self waittill("movedone");
wait(500);
} 
}

elevator9()
{
trigger = getEnt("trigger_elevator9", "targetname");
trigger waittill("trigger", player);
trigger delete();
while(1)
{
wait(0.01);
self movex(180, 2, 0.5, 0.5);
self waittill("movedone");
wait(0.5);
self movex(-180, 2, 0.5, 0.5);
self waittill("movedone");
wait(0.5);
} 
}

twister()
{
	trig = getEnt( "trigger_twister", "targetname" );
	brush = getEnt( "twister", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 100; i++ )
	{
		brush rotateyaw( 360, 3 );
		wait 2;
	}
	brush.angles = (0,0,0);
}

twister1()
{
	trig = getEnt( "trigger_twister1", "targetname" );
	brush = getEnt( "twister1", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 100; i++ )
	{
		brush rotateyaw( 360, 5 );
		wait 2;
	}
	brush.angles = (0,0,0);
}

twister2()
{
	trig = getEnt( "trigger_twister2", "targetname" );
	brush = getEnt( "twister2", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 100; i++ )
	{
		brush rotateyaw( 360, 1 );
		wait 0.5;
	}
	brush.angles = (0,0,0);
}

twister3()
{
	trig = getEnt( "trigger_twister3", "targetname" );
	brush = getEnt( "twister3", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 100; i++ )
	{
		brush rotateyaw( 360, 6 );
		wait 2;
	}
	brush.angles = (0,0,0);
}

finalFight()
{
    level.trigger = getEnt( "final_trigger", "targetname" );
    tele_activator = getEnt( "final_activator_teleport", "targetname" );
    tele_jumper = getEnt( "final_jumper_teleport", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
         level.trigger waittill( "trigger", player );
		level.trigger1 delete();
	level.trigger2 delete();
	level.trigger3 delete();


        // this will be blocked if jumper is currently in room and while its free run round
        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "m40a3_mp", 100 );
        level.activ finalRoom( tele_activator, "m40a3_mp", 100 );
    }
    // code never gets here
}


finalMonitor()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}

monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}

finalRoom( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
    
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    self GiveWeapon( weap );
    self GiveMaxAmmo( weap );
    self SwitchToWeapon( weap );
    
    self.maxhealth = health;
    
} 

finalFight1()
{
    level.trigger1 = getEnt( "final_trigger1", "targetname" );
    tele_activator = getEnt( "final_activator_teleport1", "targetname" );
    tele_jumper = getEnt( "final_jumper_teleport1", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
 level.trigger1  waittill( "trigger", player );
		level.trigger delete();
	level.trigger2 delete();
	level.trigger3 delete();



        // this will be blocked if jumper is currently in room and while its free run round
        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "tomahawk_mp", 10 );
        level.activ finalRoom( tele_activator, "tomahawk_mp", 10 );
    }
}
    // code never gets here

finalFight2()
{
    level.trigger2 = getEnt( "final_trigger2", "targetname" );
    tele_activator = getEnt( "final_activator_teleport2", "targetname" );
    tele_jumper = getEnt( "final_jumper_teleport2", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        level.trigger2  waittill( "trigger", player );
		level.trigger delete();
		level.trigger1 delete();			
		level.trigger3 delete();

        // this will be blocked if jumper is currently in room and while its free run round
        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "tomahawk_mp", 10 );
        level.activ finalRoom( tele_activator, "tomahawk_mp", 10 );
    }
}
    // code never gets here


finalFight3()
{
    level.trigger3 = getEnt( "final_trigger3", "targetname" );
    tele_activator = getEnt( "final_activator_teleport3", "targetname" );
    tele_jumper = getEnt( "final_jumper_teleport3", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        level.trigger3  waittill( "trigger", player );
		level.trigger delete();
		level.trigger1 delete();
		level.trigger2 delete();


        // this will be blocked if jumper is currently in room and while its free run round
        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "m40a3_mp", 100 );
        level.activ finalRoom( tele_activator, "m40a3_mp", 100 );
    }
}
    // code never gets here
