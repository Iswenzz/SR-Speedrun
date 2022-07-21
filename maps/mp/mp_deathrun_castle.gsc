main()
{
    level._effect["helicopter_explosion"] = loadfx( "explosions/helicopter_explosion" );
	
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trigger_t9_" );
	addTriggerToList( "trig_trap10" );
	addTriggerToList( "trig_trap11" );
	
	maps\mp\_load::main();
	maps\mp\_teleport1::main();
	maps\mp\_teleport2::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	
	thread sr\api\_speedrun::createNormalWays("Normal Way");
        thread sr\api\_speedrun::createEndMap((47.7244, -623.468, 224.125), 355, 150);
	//thread creator();
	thread startdoor();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	//thread trap11();
	//thread sniperoom();
	//thread jumproom();
	//thread kniferoom();
	//thread old();

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

creator()
{
trigger = GetEnt( "creator", "targetname" );
	{
	trigger waittill ("trigger", user);
		{
		iprintlnbold( "^1M^4ap ^1C^4reator ^7eBc|Legend");
		wait 1.5;
		iprintlnbold( "Visit: forum.explicitbouncers.co.uk");
		wait 1.5;
		iprintlnbold( "^3Big Thanks to Pr!m3");
		wait 1.5;
		}
	}
}

startdoor()
{
trigger = getent("trig_startdoor","targetname");
object = getent("startdoor","targetname");
trigger delete();
object delete();
}

trap1()
{
trigger = getent("trig_trap1","targetname");
object = getent("trap1","targetname");
killtrigger = getent ("trig_kill" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object movez(80, 1);
object waittill("movedone");
wait 2;
object movez(-80, 3);
object waittill("movedone");
wait 1;
}
}

trap2()
{
trigger = getent("trig_trap2","targetname");
object = getent("trap2","targetname");
killtrigger = getent ("trig_kill_2" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object movez(-320, 3);
object waittill("movedone");
wait 2;
object movez(320, 3);
object waittill("movedone");
wait 2;
}
}


trap3()
{
trig = GetEnt("trig_trap3","targetname");
killtrigger = GetEnt("trig_kill_3","targetname");
brush = GetEnt("trap3","targetname");
trig waittill ("trigger" , player );
trig delete();
{
killtrigger enablelinkto ();
killtrigger linkto (brush);
brush rotatePitch(-90,1.5);
wait(2.5);
PlayFX(level._effect["helicopter_explosion"],(-2856, -104, -1000));
wait(1);
killtrigger delete();
wait(1);
}
}

trap4()
{
trigger = getent("trig_trap4","targetname");
object = getent("trap4","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object movez(-80, 1.7);
object waittill("movedone");
object movez(80, 1.7);
wait 2;
}
}

trap5()
{
trigger = getent("trig_trap5","targetname");
object = getent("trap5","targetname");
killtrigger = getent ("trig_kill_5" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveY(-672, 3.3);
object waittill("movedone");
wait 2;
}
}

trap6()
{
trigger = getent("trig_trap6","targetname");
object = getent("trap6","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object moveZ(-160, 1.5);
object waittill("movedone");
wait 2;
object moveZ(160, 1.5);
object waittill("movedone");
}
}

trap7()
{
	part1 = getentarray ("trap7_1" ,"targetname");
	part2 = getentarray ("trap7_2" ,"targetname");
	trig = getent ("trig_trap7" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(2);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part1[randomInt(part1.size)] hide();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
                part2[randomInt(part2.size)] hide();				
				
		default: return;
	}
}

trap8()
{
trigger = getent("trig_trap8","targetname");
object = getent("trap8","targetname");
killtrigger = getent ("trig_kill_8" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveZ(208, 0.1);
object waittill("movedone");
wait 2;
object moveZ(-208, 0.1);
object waittill("movedone");
wait 2;
}
}

trap9()
{
    trigger = getent("trigger_t9_","targetname");
	object = getent("t9_","targetname");
    trigger waittill ("trigger" , player );
    trigger delete();
	a = getent("t9a","targetname");
	b = getent("t9b","targetname");
	c = getent("t9c","targetname");
	d = getent("t9d","targetname");
	e = getent("t9e","targetname");
	
	while(1)
	{
		a moveZ(80,0.5);
		b moveZ(-80,0.5);
		c rotateYaw(180,0.5);
		d moveZ(-80,0.5);
		e moveZ(80,0.5);
		wait 2;
		a moveZ(-80,0.5);
		b moveZ(80,0.5);
		c rotateYaw(-180,0.5);
		d moveZ(80,0.5);
		e moveZ(-80,0.5);
		wait 2;
	}
}

trap10()
{
	part1 = getentarray ("trap10_1" ,"targetname");
	part2 = getentarray ("trap10_2" ,"targetname");
	part3 = getentarray ("trap10_3" ,"targetname");
	trig = getent ("trig_trap10" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(3);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] moveZ(-80, 2);
				part2[randomInt(part2.size)] moveZ(-80, 2);
				
				break;
				
		case 1:	
				part3[randomInt(part2.size)] moveZ(-80, 2);
                break;				

		case 2:	
				part2[randomInt(part2.size)] moveZ(-80, 2);
                part3[randomInt(part3.size)] moveZ(-80, 2);				
				
		default: return;
	}
}

trap11()
{
	part1 = getentarray ("trap11_1" ,"targetname");
	part2 = getentarray ("trap11_2" ,"targetname");
	trig = getent ("trig_trap11" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(2);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part1[randomInt(part1.size)] hide();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
                part2[randomInt(part2.size)] hide();				
				
		default: return;
	}
}

sniperoom()
{
    level.snipe_trig = getEnt( "sniperoom", "targetname");
    jump = getEnt( "jump_snipe", "targetname" );
    acti = getEnt( "acti_snipe", "targetname" );

    
    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;
			
		if(level.firstenter==true)
		{
        level.old_trig delete();
		level.jump_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
        iPrintlnBold( " ^4" + player.name + " picked ^1SNIPER!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
	level.activ TakeAllWeapons();
	wait 0.1;
        player GiveWeapon( "remington700_mp" );
        level.activ GiveWeapon( "remington700_mp" );
	wait 0.1;
	player GiveWeapon( "M40A3_mp" );
	level.activ GiveWeapon( "M40A3_mp" );
	wait 0.1;;
	player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

jumproom()
{
    level.jump_trig = getEnt( "jump", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if(level.firstenter==true)
		{       
	    level.snipe_trig delete();
        level.old_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );       
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^4" + player.name + " picked ^1JUMP!" );
		wait 0.1;
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

kniferoom()
{
    level.knife_trig = getEnt( "knife", "targetname");
    jump = getEnt( "jumper_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.snipe_trig delete();
        level.old_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );       
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^4" + player.name + " picked ^1KNIFE!" );
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

old()
{
    level.old_trig = getEnt( "old", "targetname");
    jump = getEnt( "jumper_old", "targetname" );
    acti = getEnt( "acti_old", "targetname" );
    
    while(1)
    {
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.gun_trig delete();
                level.snipe_trig delete();
                level.knife_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );      
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^4" + player.name + " picked ^1OLD!" );
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
