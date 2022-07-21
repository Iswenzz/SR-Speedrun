main()
{
    maps\mp\_load::main();

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
        thread sr\api\_speedrun::createTeleporter((14.3142, -2143.04, 16.125), 125, 90, (-6, -1994, 364), 91, "freeze");
    thread sr\api\_speedrun::createEndMap((1648.43, -1134.13, 304.125), 115, 95);
    //thread trap1();
	//thread trap2();
	//thread vanish();
	//thread elevator();
	//thread elevator2();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread secret();
	//thread mapteleport();
	//thread trap8();
	//thread trap9();
	//thread finaldoor();
	
    addTriggerToList ("trap2_trig");
	addTriggerToList ("vanish_trigger");
	addTriggerToList ("trap4_trig");
	addTriggerToList ("trap5_trig");
	addTriggerToList ("trap6_trig");
	addTriggerToList ("trap7_trig");
	addTriggerToList ("trap8_trig");
	addTriggerToList ("trap9_trig");
	
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
	
trap1()
{

	moving = getEnt ("trap1_moving", "targetname");
		
	while (1)
	{
		
		moving moveY (-256,2);
		wait 2;
		moving moveY (256,2);
		wait 2;
		
	}
}

trap2()
{ 
			trig = getEnt ("trap2_trig", "targetname");
			spin = getEnt ("trap2_spin", "targetname");
			
			trig waittill ("trigger", who);
			trig delete();
			
			spin rotatepitch(2160,5);
		
}

vanish()
{
    vanish_trigger = getent("vanish_trigger", "targetname");
    vanish1 = getentarray("vanish_part1", "targetname");
    vanish2 = getentarray("vanish_part2", "targetname");
    vanish_trigger waittill( "trigger" );
    vanish_trigger delete();

    {
        vanish1[RandomInt(vanish1.size)] Notsolid();
        vanish2[RandomInt(vanish2.size)] Notsolid();
    }
}

elevator()
{             
    button = getEnt ("elevator_button", "targetname");
    body = getEnt ("elevator_body", "targetname");
    door = getEnt ("elevator_door", "targetname");
    door2 = getEnt ("elevator_door2", "targetname");
            
    for(;;)
    {      
    button waittill ("trigger", who);
        {
            door moveX (-256,3);
			wait 3;
            body moveZ (288,3);
			wait 3;
            door2 moveX (256,3);
            wait 5;
            door2 moveX (-256,3);
			wait 3;
            body moveZ (-288,3);
			wait 3;
            door moveX (256,3);    
        }
    }      
}

elevator2()
{             
    button = getEnt ("elevator2_button", "targetname");
    body = getEnt ("elevator2_body", "targetname");
    door = getEnt ("elevator2_door", "targetname");
    door2 = getEnt ("elevator2_door2", "targetname");
            
    for(;;)
    {      
    button waittill ("trigger", who);
        {
            door moveX (192,3);
			wait 3;
            body moveZ (288,3);
			wait 3;
            door2 moveX (-192,3);
            wait 5;
            door2 moveX (192,3);
			wait 3;
            body moveZ (-288,3);
			wait 3;
            door moveX (-192,3);    
        }
    }      
}
			
			
trap4()
{

	trig = getEnt ("trap4_trig", "targetname");
	lift = getEnt ("trap4_lift", "targetname");
		
	trig waittill ("trigger", who);
	trig delete();
	
	lift moveZ (240,1);
	wait 3;
	lift moveZ (-240,5);
	
}		
	
trap5()
{
	trig = getEnt ("trap5_trig", "targetname");
	hurt = getEnt ("trap5_hurt", "targetname");
	fall = getEnt ("trap5_fall", "targetname");
	
	hurt enablelinkto(); 
	hurt linkto (fall); 

	trig waittill ("trigger");
	trig delete();
	{ 
	fall moveZ (-256,1);
	wait 3;
	fall moveZ (256,1);
	}
}

trap6()
{
	trig = getEnt ("trap6_trig","targetname");
	spin = getEnt ("trap6_rotate", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	
	while (1)
	{
		spin rotateroll (360,1);
		wait 1;
	}
}

trap7()
{
	trig = getEnt ("trap7_trig","targetname");
	spin = getEnt ("trap7_rotate", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	
	while (1)
	{
		spin rotateroll (360,1);
		wait 1;
	}
}

secret()// FEARZ WROTE THIS CAUSE HE'S A SEXY CUNT!
{

	target = getEnt ("teleport_target", "targetname");
	trigger1 = getEnt ("teleport_trigger1", "targetname");
	trigger2 = getEnt ("teleport_trigger2", "targetname");

	
	thread random2();
	for(;;)
	{
	trigger1 waittill ("trigger", player);
	if( randomInt(2) == 0 )
		{
		
			player SetPlayerAngles( target.angles );
			player SetOrigin( target.origin );
			player iprintlnbold("Correct... Enjoy!"); // remove or change the textedddd if you like
			wait 0.5;
		}
		else
		{
			player suicide();
			player iprintlnbold("I see you're a gambling man. Unluky."); // remove or change the textedddd if you like
			wait 0.5;
		}
	}
}

random2()
{

	target = getEnt ("teleport_target", "targetname");
	trigger1 = getEnt ("teleport_trigger1", "targetname");
	trigger2 = getEnt ("teleport_trigger2", "targetname");

	for(;;)
	{
	trigger2 waittill ("trigger", player);
	if( randomInt(2) == 0 )
		{
		
			player SetPlayerAngles( target.angles );
			player SetOrigin( target.origin );
			player iprintlnbold("Correct... Enjoy!"); // remove or change the textedddd if you like
			wait 0.5;
		}
		else
		{
			player suicide();
			player iprintlnbold("I see you're a gambling man. Unluky."); // remove or change the textedddd if you like
			wait 0.5;
		}
	}
}

mapteleport()
{ 
	target = getEnt ("map_target", "targetname");
	trig = getEnt ("map_trigger", "targetname");
	
	for(;;)
	{
	trig waittill ("trigger", player);
		{
		player SetPlayerAngles( target.angles );
		player SetOrigin( target.origin );
		player iprintlnbold("You have returned to the map!");
			wait 0.5;
		}
	}
}
		
trap8()
{
	trig = getEnt ("trap8_trig","targetname");
	spin = getEnt ("trap8_spin", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	
	while (1)
	{
		spin rotateyaw (360,1);
		wait 1;
	}
}
	
trap9()
{
	trig = getEnt ("trap9_trig", "targetname");
	fall = getEnt ("trap9_fall", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	
	fall moveZ (-352,3);
	wait 4;
	fall moveZ (352,1);
	
}

finaldoor()
{
	trig = getEnt ("final_trig", "targetname");
	door = getEnt ("final_door", "targetname");
	
	trig waittill ("trigger", player);
	trig delete();
	
	iprintlnbold(player.name + " Is about to take on the ^1activator!");
	
	door moveZ (256,2);
	
}
	
	
	
	
	
	
	
	
	
	
	
	
