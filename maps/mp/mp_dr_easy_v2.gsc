main()
{

	maps\mp\_load::main();
	// maps\mp\_teleport1::main();
	// maps\mp\_teleport2::main();
	// maps\mp\_teleport3::main();
	// maps\mp\_teleport4::main();
	// maps\mp\_teleport5::main();
	// maps\mp\_teleport6::main();

	
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
	
	thread way_connect();
	thread startdoor();
	// thread messages();
	// thread credit();
	thread mover();
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
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread trap15();
	// thread trap16();
	// thread trap17();
	// thread trap18();
	// thread trap19();
	// thread trap20();
	// thread kniferoom();
	// thread sniperoom();
	// thread jumproom();
	// thread old();
	thread end();


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

startdoor()
{
object = getent("door","targetname");
object delete();
}

messages()
{
while(1)
{
wait 20;
iprintlnbold("^1>>^7Welcome to mp_deathrun_special");
wait 20;
iprintlnbold("^1>>^7eBc|Legend Says ^3HELLO^1! ^7To You Jumpers");
wait 20;
iprintlnbold("^1>>^7Map Creator ^5eBc|Legend");
wait 20;
iprintlnbold("^1>>^7Play Fair and Have Fun :D");
wait 30;
}
}

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "Easy_v2" );
wait(6);
thread drawInformation( 800, 0.8, 1, "eBc|Legend" );
wait(6);
}

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

mover()
{
level.mover = getent("mover","targetname");
while(1)
{
level.mover moveY(608, 2, 1, 0.5);
level.mover waittill("movedone");
wait 0.1;
level.mover moveY(-608, 2, 1, 0.5);
level.mover waittill("movedone");
wait 0.1;
}
}

trap1()
{
	part1 = getentarray ("trap1_1" ,"targetname");
	part2 = getentarray ("trap1_2" ,"targetname");
	part3 = getentarray ("trap1_3" ,"targetname");
	part4 = getentarray ("trap1_4" ,"targetname");
	trig = getent ("trig_trap1" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(4);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();
                break;				

		case 2:	
				part1[randomInt(part1.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();	
                break;
				
		case 3:	
				part2[randomInt(part2.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();				
				
		default: return;
	}
}

trap2()
{
trig = getent("trig_trap2","targetname");
object = getent("trap2","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object rotateYaw(360 ,2, 0.5);
wait 6;
object rotateYaw(-360 ,2, 0.5);
wait 6;
}
}

trap3()
{
trig = getent("trig_trap3","targetname");
trig waittill("trigger" , user );
trig delete();
{
level.mover hide();
level.mover notsolid();
wait 4;
level.mover show();
level.mover solid();
wait 1;
}
}

trap4()
{
        trigger = getent("trig_trap4","targetname");
	object = getent("t4_","targetname");
        trigger waittill ("trigger" , player );
        trigger delete();
	a = getent("t4a","targetname");
	b = getent("t4b","targetname");
	c = getent("t4c","targetname");
	d = getent("t4d","targetname");
	e = getent("t4e","targetname");
	f = getent("t4f","targetname");
	
	while(1)
	{
		a moveZ(56,0.5);
		b moveZ(-56,0.5);
		c moveZ(56,0.5);
		d moveZ(-56,0.5);
		e moveZ(56,0.5);
		f moveZ(-56,0.5);
		wait 0.5;
		a moveZ(-56,0.5);
		b moveZ(56,0.5);
		c moveZ(-56,0.5);
		d moveZ(56,0.5);
		e moveZ(-56,0.5);
		f moveZ(56,0.5);
		wait 0.5;
	}
}

trap5()
{
trig = getent("trig_trap5","targetname");
object = getent("trap5","targetname");
trig waittill("trigger" , user );
trig delete();
{
object rotatePitch(360 ,3);
wait 6;
object rotatePitch(-360 ,3);
wait 1;
}
}

trap6()
{
trig = getent("trig_trap6","targetname");
object = getent("trap6","targetname");
trig waittill("trigger" , user );
trig delete();
{
object hide();
object notsolid();
wait 4;
object show();
object solid();
wait 4;
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
trig = getent("trig_trap8","targetname");
object = getent("trap8","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object rotateYaw(360 ,2.5);
wait 0.1;
}
}

trap9()
{
trig = getent("trig_trap9","targetname");
object1 = getent("trap9_1","targetname");
object2 = getent("trap9_2","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object1 moveX(544 ,1.5);
object2 moveX(-544 ,1.5);
wait 3;
object1 moveX(-544 ,1.5);
object2 moveX(544 ,1.5);
wait 3;
}
}

trap10()
{
trig = getent("trig_trap10","targetname");
object1 = getent("trap10_1","targetname");
object2 = getent("trap10_2","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object1 rotateRoll(360 ,2);
object2 rotateRoll(-360 ,2);
wait 0.1;
}
}

trap11()
{
trig = getent("trig_trap11","targetname");
object = getent("trap11","targetname");
trig waittill("trigger" , user );
trig delete();
{
object rotateYaw(360 ,2);
wait 10;
object rotateYaw(-360 ,2);
wait 0.1;
}
}

trap12()
{
trigger = getent("trig_trap12","targetname");
object1 = getent("trap12_1","targetname");
object2 = getent("trap12_2","targetname");
object3 = getent("trap12_3","targetname");
object4 = getent("trap12_4","targetname");
object5 = getent("trap12_5","targetname");
kill1 = getent ("kill1" , "targetname");
kill2 = getent ("kill2" , "targetname");
kill3 = getent ("kill3" , "targetname");
kill4 = getent ("kill4" , "targetname");
kill5 = getent ("kill5" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
kill1 enablelinkto ();
kill1 linkto (object1);
object1 moveZ(48, 1);
wait 2;
object1 moveZ(-48, 1);
kill2 enablelinkto ();
kill2 linkto (object2);
object2 moveZ(48, 1);
wait 2;
object2 moveZ(-48, 1);
kill3 enablelinkto ();
kill3 linkto (object3);
object3 moveZ(48, 1);
wait 2;
object3 moveZ(-48, 1);
kill4 enablelinkto ();
kill4 linkto (object4);
object4 moveZ(48, 1);
wait 2;
object4 moveZ(-48, 1);
kill5 enablelinkto ();
kill5 linkto (object5);
object5 moveZ(48, 1);
wait 2;
object5 moveZ(-48, 1);
wait 2;
}
}

trap13()
{
trig = getent("trig_trap13","targetname");
object = getent("trap13","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object rotatePitch(360 ,5);
wait 0.1;
}
}

trap14()
{
trig = getent("trig_trap14","targetname");
object1 = getent("trap14_1","targetname");
object2 = getent("trap14_2","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object1 rotateRoll(360 ,3);
object2 rotateRoll(-360 ,3);
wait 0.1;
}
}

trap15()
{
trig = getent("trig_trap15","targetname");
object = getent("trap15","targetname");
trig waittill("trigger" , user );
trig delete();
{
object rotateYaw(360 ,3);
wait 0.1;
}
}

trap16()
{
trig = getent("trig_trap16","targetname");
object = getent("trap16","targetname");
trig waittill("trigger" , user );
trig delete();
{
object moveY(-464 ,1);
wait 4;
object moveY(464 ,1);
wait 2;
}
}

trap17()
{
	part1 = getentarray ("trap17_1" ,"targetname");
	part2 = getentarray ("trap17_2" ,"targetname");
	part3 = getentarray ("trap17_3" ,"targetname");
	part4 = getentarray ("trap17_4" ,"targetname");
	part5 = getentarray ("trap17_5" ,"targetname");
	trig = getent ("trig_trap17" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(4);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part1[randomInt(part1.size)] hide();
				part2[randomInt(part2.size)] notsolid();
				part2[randomInt(part2.size)] hide();
				wait 2;
				part1[randomInt(part1.size)] solid();
				part1[randomInt(part1.size)] show();
				part2[randomInt(part2.size)] solid();
				part2[randomInt(part2.size)] show();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				part2[randomInt(part2.size)] hide();
				part3[randomInt(part3.size)] notsolid();
				part3[randomInt(part3.size)] hide();
				wait 2;
				part2[randomInt(part2.size)] solid();
				part2[randomInt(part2.size)] show();
				part3[randomInt(part3.size)] solid();
				part3[randomInt(part3.size)] show();
                break;				

		case 2:	
				part3[randomInt(part1.size)] notsolid();
				part3[randomInt(part1.size)] hide();
				part4[randomInt(part4.size)] notsolid();
                part4[randomInt(part4.size)] hide();
                wait 2;				
				part3[randomInt(part1.size)] solid();
				part3[randomInt(part1.size)] show();
				part4[randomInt(part4.size)] solid();
                part4[randomInt(part4.size)] show();				
                break;
				
		case 3:	
				part4[randomInt(part4.size)] notsolid();
				part4[randomInt(part4.size)] hide();
				part5[randomInt(part5.size)] notsolid();
                part5[randomInt(part5.size)] hide();
				wait 2;
				part4[randomInt(part4.size)] solid();
				part4[randomInt(part4.size)] show();
				part5[randomInt(part5.size)] solid();
                part5[randomInt(part5.size)] show();				
				
		default: return;
	}
}

trap18()
{
trig = getent("trig_trap18","targetname");
object = getent("trap18","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object rotateYaw(360 ,6);
wait 0.1;
}
}

trap19()
{
	part1 = getentarray ("trap19_1" ,"targetname");
	part2 = getentarray ("trap19_2" ,"targetname");
	part3 = getentarray ("trap19_3" ,"targetname");
	part4 = getentarray ("trap19_4" ,"targetname");
	trig = getent ("trig_trap19" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(4);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();
                break;				

		case 2:	
				part1[randomInt(part1.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();	
                break;
				
		case 3:	
				part2[randomInt(part2.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();				
				
		default: return;
	}
}

trap20()
{
trig = getent("trig_trap20","targetname");
object1 = getent("trap20_1","targetname");
object2 = getent("trap20_2","targetname");
trig waittill("trigger" , user );
trig delete();
while(1)
{
object1 moveZ(96 ,6);
object2 moveZ(-96 ,6);
wait 7;
object1 moveZ(-96 ,6);
object2 moveZ(96 ,6);
wait 7;
object1 moveZ(-96 ,6);
object2 moveZ(96 ,6);
wait 7;
object1 moveZ(96 ,6);
object2 moveZ(-96 ,6);
wait 7;
}
}

kniferoom()
{
    level.knife_trig = getEnt( "knife", "targetname");
	level.knife_brick = getEnt( "knife_brick","targetname");
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
		level.snipe_brick delete();
        level.old_trig delete();
		level.old_brick delete();
 		level.jump_trig delete();
		level.jump_brick delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );
		player setWeaponAmmoClip("deserteagle_mp", 0 );
		player setWeaponAmmoStock( "deserteagle_mp", 0 );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" ); 
        level.activ setWeaponAmmoClip("deserteagle_mp", 0 );
        level.activ setWeaponAmmoStock( "deserteagle_mp", 0 );		
        wait 0.05;
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        iPrintlnBold( "^7" + player.name + " ^2Entered ^3Knife^7!" );
		wait 2;
		iPrintlnBold("3");
		wait 1;
		iPrintlnBold("2");
		wait 1;
		iPrintlnBold("1");
		wait 1;
		iPrintlnBold("Fight!!");
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

sniperoom()
{
    level.snipe_trig = getEnt( "sniper", "targetname");
	level.snipe_brick = getEnt( "sniper_block","targetname");
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
		level.old_brick delete();
		level.jump_trig delete();
		level.jump_brick delete();
		level.knife_trig delete();
		level.knife_brick delete();
		level.firstenter=false;
		}
        iPrintlnBold( "^7" + player.name + " ^9Entered ^2Sniper^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	    player freezeControls(true);
		level.activ freezeControls(true);
		wait 2;
		iPrintlnBold("3");
		wait 1;
		iPrintlnBold("2");
		wait 1;
		iPrintlnBold("1");
		wait 1;
		iPrintlnBold("Fight!!");
	    wait 0.1;
        player GiveWeapon( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );
		player GiveMaxAmmo("m40a3_mp");
		player switchToWeapon( "remington700_mp" );
	    wait 0.1;
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveMaxAmmo("m40a3_mp");
        level.activ SwitchToWeapon( "remington700_mp" );
	    player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

jumproom()
{
    level.jump_trig = getEnt( "jump", "targetname");
	level.jump_brick = getEnt ( "jump_brick","targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if(level.firstenter==true)
		{     
	    level.snipe_trig delete();
		level.snipe_brick delete();
		level.knife_trig delete();
		level.knife_brick delete();
		level.old_trig delete();
		level.old_brick delete();
		level.firstenter=false;
		}
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" ); 
		player setWeaponAmmoClip("deserteagle_mp", 0 );
		player setWeaponAmmoStock( "deserteagle_mp", 0 );		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );  
		level.activ setWeaponAmmoClip("deserteagle_mp", 0 );
		level.activ setWeaponAmmoStock( "deserteagle_mp", 0 );			
        wait 0.05;
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        iPrintlnBold( " ^7" + player.name + " ^8Entered ^5Jump^7!" );
		wait 2;
		iPrintlnBold("3");
		wait 1;
		iPrintlnBold("2");
		wait 1;
		iPrintlnBold("1");
		wait 1;
		iPrintlnBold("Fight!!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 0.1;
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

old()
{
level.old_trig = getEnt("old","targetname");
level.old_brick = getEnt("old_brick","targetname");
level.old_way = getEnt("old_way","targetname");
door = getEnt ("old_door","targetname");
level.old_trig waittill("trigger" , user );
{
level.snipe_trig delete();
level.snipe_brick delete();
level.knife_trig delete();
level.knife_brick delete();
level.jump_trig delete();
level.jump_brick delete();
level.old_trig delete();
level.old_brick delete();
{
level.old_way moveZ(1008, 5);
level.old_way waittill("movedone");
wait 5;
iprintlnbold("Door Is Removed!!");
door delete();
wait 5;
}
}
}

end()
{
trigger = GetEnt( "end", "targetname" );
	{
	trigger waittill ("trigger", user);
		{
		iprintlnbold( "^7 " + user.name + " ^4Finished First^7!!");
		wait 0.1;
		}
	}
}