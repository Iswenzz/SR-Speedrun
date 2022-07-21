/*

   ♀♀♀♀♀♀♀      ♀♀♀♀♀♀♀♀      ♀♀♀♀♀♀♀                    
   ♀♀♀♀♀♀♀♀     ♀♀♀♀♀♀♀♀      ♀♀♀♀♀♀♀♀                  
   ♀♀♀♀         ♀♀    ♀♀      ♀♀                   
   ♀♀♀♀♀♀♀♀     ♀♀    ♀♀      ♀♀
   ♀♀♀♀♀♀♀♀     ♀♀♀♀♀♀♀♀♀♀    ♀♀  
   ♀♀♀♀         ♀♀      ♀♀    ♀♀
   ♀♀♀♀♀♀♀♀     ♀♀♀♀♀♀♀♀♀♀    ♀♀♀♀♀♀♀♀
   ♀♀♀♀♀♀♀      ♀♀♀♀♀♀♀♀♀♀    ♀♀♀♀♀♀♀

   ♀♀♀       ♀♀♀♀♀♀♀     ♀♀♀♀♀♀♀♀      ♀♀♀♀♀♀♀     ♀♀♀    ♀♀    ♀♀♀♀♀♀
   ♀♀♀♀      ♀♀♀♀♀♀♀♀   ♀♀♀♀♀♀♀♀       ♀♀♀♀♀♀♀♀    ♀♀♀♀   ♀♀♀   ♀♀♀♀♀♀♀♀
   ♀♀♀♀      ♀♀♀♀       ♀♀♀♀           ♀♀♀♀        ♀♀♀ ♀  ♀♀♀   ♀♀♀   ♀♀
   ♀♀♀♀      ♀♀♀♀♀♀♀♀   ♀♀♀♀           ♀♀♀♀♀♀♀♀    ♀♀♀  ♀ ♀♀♀   ♀♀♀   ♀♀
   ♀♀♀♀      ♀♀♀♀♀♀♀♀   ♀♀♀♀   ♀♀♀♀    ♀♀♀♀♀♀♀♀    ♀♀♀   ♀♀♀♀   ♀♀♀   ♀♀
   ♀♀♀♀      ♀♀♀♀       ♀♀♀♀    ♀♀♀♀   ♀♀♀♀        ♀♀♀    ♀♀♀   ♀♀♀   ♀♀
   ♀♀♀♀♀♀♀♀  ♀♀♀♀♀♀♀♀   ♀♀♀♀♀♀♀♀♀♀♀♀   ♀♀♀♀♀♀♀♀♀   ♀♀♀    ♀♀♀   ♀♀♀♀♀♀♀♀
   ♀♀♀♀♀♀♀   ♀♀♀♀♀♀♀     ♀♀♀♀♀♀♀♀♀♀♀   ♀♀♀♀♀♀♀♀    ♀♀♀    ♀♀    ♀♀♀♀♀♀
   
   
   ▼ ▼ Mind telling me what you do here? ▼ ▼
   ▼ ▼ Learn to script bastard!! ▼ ▼
   ▼ ▼ Credits: No one, dont need help. ▼ ▼
   
*/   

main()
{
thread sr\api\_map::createSpawn((-313.356, 0, 16.125), 0);
trigger = spawn( "trigger_radius", (5852.35, -3361.35, 96.125), 0, 315, 55 );
trigger.targetname = "endmap_trig";
trigger.radius = 315;

    // addTriggerToList( "trig_trap1" );
    // addTriggerToList( "trig_trap2" );
    // addTriggerToList( "trig_trap3" );
    // addTriggerToList( "trig_trap4" );
    // addTriggerToList( "trig_trap5" );
    // addTriggerToList( "trig_trap6" );
    // addTriggerToList( "trig_trap7" );
    // addTriggerToList( "trig_trap8" );
    // addTriggerToList( "trig_trap9" );
    // addTriggerToList( "trig_trap10" );
    // addTriggerToList( "trig_trap11" );
    // addTriggerToList( "trig_trap12" );
    // addTriggerToList( "trig_trap13" );
    // addTriggerToList( "trig_trap14" );
    // addTriggerToList( "trig_trap15" );
    // addTriggerToList( "trig_trap16" );
	
	// precacheItem("winchester1200_mp");
 

	// maps\mp\mp_deathrun_crystal_fx::main();
	// maps\createfx\mp_deathrun_crystal_fx::main();
	maps\mp\_load::main();
	maps\mp\mp_deathrun_crystal\_teleport1::main();
	maps\mp\mp_deathrun_crystal\_teleport2::main();
	maps\mp\mp_deathrun_crystal\_teleport3::main();
	maps\mp\mp_deathrun_crystal\_teleport4::main();
	maps\mp\mp_deathrun_crystal\_teleport5::main();
	maps\mp\mp_deathrun_crystal\_teleport6::main();
	
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
	// thread messages();
	// thread credit();
	// thread dj_bord();
	thread startdoor();
	thread plat1();
	thread plat2();
	thread plat3();
	thread plat4();
	thread crystal_rotators();
	// thread trap1();
	// thread trap2();
	// thread trap3();²
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread trap15();
	// thread trap16();
	// thread sniperoom();
	// thread shotgunroom();
	// thread kniferoom();
	// thread oldroom();
	// thread jumproom();
	// thread finish();
	// thread air_wep();
	// thread jump_wep();
	thread end_crystals();


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

messages()
{
wait 7;
iprintln("^5>>^7eBc|Legend Welcomes you on mp_deathrun_crystal");
wait 17;
iprintln("^5>>^7Map Creator ^1eBc|Legend");
wait 21;
iprintln("^5>>^7Thanks For Playng Crystal");
wait 21;
iprintln("^5>>^7Have Fun and Enjoj the ^1C^2r^3y^4s^5t^6a^7l^8s");
wait 1;
}

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^1C^2r^3y^4s^5t^6a^7l" );
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

	hud.color = (0.9, 1.0, 0.0);
	hud.font = "objective";
	hud.glowColor = (0.9, 1.0, 0.0);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

dj_bord()
{
dj_bord = getent("dj_bord","targetname");
dj_bord waittill("trigger" , user );
{
dj_bord delete();
iprintln("^5>>^7Song: ^2Snoop ^0Dog^7 Smoke^2 Weed ^7Everyday");
iprintlnbold("^5" + user.name + " ^7Turns Music On!!");
ambientplay("weed");
wait 1;
}
}

startdoor()
{
door = getent("door","targetname");
{
wait 1;
door moveZ(144, 1);
}
}

plat1()
{
plat1 = getent("plat1","targetname");
trig_plat1 = getent("trig_plat1","targetname");
trig_plat1 waittill("trigger" , user );

}

plat2()
{
plat2 = getent("plat2","targetname");
trig_plat2 = getent("trig_plat2","targetname");
trig_plat2 waittill("trigger" , user );

}


plat3()
{
plat3 = getent("plat3","targetname");
trig_plat3 = getent("trig_plat3","targetname");
trig_plat3 waittill("trigger" , user );

}


plat4()
{
plat4 = getent("plat4","targetname");
trig_plat4 = getent("trig_plat4","targetname");
trig_plat4 waittill("trigger" , user );

}

crystal_rotators()
{
crystal1 = getent("crystal1","targetname");
crystal2 = getent("crystal2","targetname");
crystal3 = getent("crystal3","targetname");
crystal4 = getent("crystal4","targetname");
crystal5 = getent("crystal5","targetname");
crystal6 = getent("crystal6","targetname");
while(1)
{
crystal1 rotateYaw(360, 4);
crystal2 rotateYaw(-360, 4);
crystal3 rotateYaw(360, 4);
crystal4 rotateYaw(-360, 4);
crystal5 rotateYaw(360, 4);
crystal6 rotateYaw(-360, 4);
wait 0.1;
}
}

trap1()
{
object = getent("trap1","targetname");
trig = getent("trig_trap1","targetname");


}

trap2()
{
	part1 = getentarray ("trap2_1" ,"targetname");
	part2 = getentarray ("trap2_2" ,"targetname");
	trig = getent ("trig_trap2" , "targetname");


}

trap3()
{
object = getent("trap3","targetname");
trig = getent("trig_trap3","targetname");


}

trap4()
{
object = getent("trap4","targetname");
trig = getent("trig_trap4","targetname");
trig waittill("trigger", user );
trig delete();
{
object rotateRoll(360, 3);
object waittill("rotatedone");
wait 4;
object rotateRoll(-360, 3);
object waittill("rotatedone");
wait 4;
}
}

trap5()
{
object1 = getent("trap5_1","targetname");
object2 = getent("trap5_2","targetname");
trig = getent("trig_trap5","targetname");
trig waittill("trigger", user );
trig delete();
while(1)
{
object1 rotatePitch(360, 3);
object2 rotatePitch(-360, 3);
wait 0.1;
}
}

trap6()
{
object1 = getent("trap6_1","targetname");
object2 = getent("trap6_2","targetname");
object3 = getent("trap6_3","targetname");
trig = getent("trig_trap6","targetname");
trig waittill("trigger", user );
trig delete();
while(1)
{
object1 moveZ(-386, 1);
wait 2;
object2 moveZ(-386, 1);
wait 2;
object3 moveZ(-386, 1);
wait 5;
object1 moveZ(386, 1);
wait 2;
object2 moveZ(386, 1);
wait 2;
object3 moveZ(386, 1);
wait 2;
}
}

trap7()
{
        trigger = getent("trig_trap7","targetname");
	object = getent("t7_","targetname");
        trigger waittill ("trigger" , player );
        trigger delete();
	a = getent("t7a","targetname");
	b = getent("t7b","targetname");
	c = getent("t7c","targetname");
	d = getent("t7d","targetname");
	e = getent("t7e","targetname");
	f = getent("t7f","targetname");
	
	while(1)
	{
		a moveX(80,0.1);
		wait 0.5;
		a moveX(-80,0.1);
		wait 0.5;
		b moveX(80,0.1);
		c moveX(80,0.1);
		wait 0.5;
		b moveX(-80,0.1);
		c moveX(-80,0.1);
		wait 0.5;
		d moveX(80,0.1);
		wait 0.5;
		d moveX(-80,0.1);
		wait 0.5;
		e moveX(80,0.1);
		f moveX(80,0.1);
		wait 0.5;
		e moveX(-80,0.1);
		f moveX(-80,0.1);
		wait 0.5;

	}
}

trap8()
{
trig = getent("trig_trap8","targetname");
object1 = getent("trap8_1","targetname");
object2 = getent("trap8_2","targetname");
object3 = getent("trap8_3","targetname");
object1 delete();
object2 delete();
object3 delete();
}

trap9()
{
trigger = getent("trig_trap9","targetname");
yail = getent("yail","targetname");
chains = getent("chains","targetname");
object = getent("spikes","targetname");
killtrigger = getent ("killtrig" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
chains delete();
yail moveZ(-112, 1);
wait 3;
killtrigger enablelinkto ();
killtrigger linkto (object);
object movez(96, 3);
object waittill("movedone");
wait 2;
object movez(-96, 3);
object waittill("movedone");
wait 1;
yail delete();
wait 1;
}
}

trap10()
{
trig = getent("trig_trap10","targetname");
object1 = getent("trap10_1","targetname");
object2 = getent("trap10_2","targetname");
trig waittill("trigger", user );
trig delete();
while(1)
{
object1 rotateYaw(360, 2);
object2 rotateYaw(-360, 2);
wait 0.1;
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
				part1[randomInt(part1.size)] delete();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] delete();		
				
		default: return;
	}
}

trap12()
{
	part1 = getentarray ("trap12_1" ,"targetname");
	part2 = getentarray ("trap12_2" ,"targetname");
	part3 = getentarray ("trap12_3" ,"targetname");
	part4 = getentarray ("trap12_4" ,"targetname");
	trig = getent ("trig_trap12" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(4);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] delete();
				part3[randomInt(part3.size)] delete();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] delete();
                part4[randomInt(part4.size)] delete();
				break;

		case 2:	
				part1[randomInt(part2.size)] delete();
                part4[randomInt(part4.size)] delete();	
				break;

		case 3:	
				part2[randomInt(part2.size)] delete();
                part3[randomInt(part3.size)] delete();				
				
				
		default: return;
	}
}

trap13()
{
trig = getent("trig_trap13","targetname");
object1 = getent("trap13_1","targetname");
object2 = getent("trap13_2","targetname");
object3 = getent("trap13_3","targetname");
trig waittill("trigger", user );
trig delete();
while(1)
{
object1 moveZ(-144, 2);
object2 rotateYaw(-180, 1);
object3 moveZ(-144, 2);
wait 3;
object1 moveZ(144, 2);
object2 rotateYaw(180, 1);
object3 moveZ(144, 2);
wait 3;
}
}

trap14()
{
trig = getent("trig_trap14","targetname");
object = getent("trap14","targetname");
trig waittill("trigger", user );
trig delete();
while(1)
{
object rotatePitch(180, 2);
wait 0.1;
}
}

trap15()
{
trig = getent("trig_trap15","targetname");
object1 = getent("trap15_1","targetname");
object2 = getent("trap15_2","targetname");
object3 = getent("trap15_3","targetname");
object4 = getent("trap15_4","targetname");
trig waittill("trigger", user );
trig delete();
{
object1 moveX(208, 1);
wait 2.5;
object2 moveX(208, 1);
wait 2.5;
object3 moveX(208, 1);
wait 2.5;
object4 moveX(208, 1);
wait 5;
object1 moveX(-208, 1);
wait 2.5;
object2 moveX(-208, 1);
wait 2.5;
object3 moveX(-208, 1);
wait 2.5;
object4 moveX(-208, 1);
wait 0.1;
}
}

trap16()
{
trig = getent("trig_trap16","targetname");
object1 = getent("trap16_1","targetname");
object2 = getent("trap16_2","targetname");
trig waittill("trigger", user );
trig delete();
while(1)
{
object1 rotatePitch(360, 2.5);
object2 rotatePitch(-360, 2.5);
wait 0.1;
}
}

sniperoom()
{
    level.snipe_trig = getEnt( "sniper", "targetname");
    jump = getEnt( "jump_sniper", "targetname" );
    acti = getEnt( "acti_sniper", "targetname" );

    
    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;
			
		if(level.firstenter==true)
		{
        level.old_trig delete();
		level.shotgun_trig delete();
		level.jump_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
		ambientplay("sniper");
		iprintln("^1Playng:^7 Nightcore - Can't Controle MySelf");
        iPrintlnBold( "^7" + player.name + " Entered ^4Sniper" );
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
	    player GiveWeapon( "deserteagle_mp" );
		player setWeaponAmmoClip("deserteagle_mp", 0 );
		player setWeaponAmmoStock( "deserteagle_mp", 0 );
		player switchToWeapon( "remington700_mp" );
		player giveMaxammo("remington700_mp");
	    wait 0.1;
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveWeapon( "deserteagle_mp" );
		level.activ setWeaponAmmoClip("deserteagle_mp", 0 );
		level.activ setWeaponAmmoStock( "deserteagle_mp", 0 );
        level.activ SwitchToWeapon( "remington700_mp" );
		level.activ giveMaxammo("remington700_mp");
	    player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}


shotgunroom()
{
    level.shotgun_trig = getEnt( "shotgun", "targetname");
    jump = getEnt( "jump_shotgun", "targetname" );
    acti = getEnt( "acti_shotgun", "targetname" );

    
    while(1)
    {
        level.shotgun_trig waittill( "trigger", player );
        if( !isDefined( level.shotgun_trig ) )
            return;
			
		if(level.firstenter==true)
		{
		level.snipe_trig delete();
        level.old_trig delete();
		level.jump_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
		ambientplay("shotgun");
		iprintln("^1Playng:^7 Nightcore - Angel With A Shotgun");
        iPrintlnBold( "^7" + player.name + " Entered ^8Shotgun" );
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
        player GiveWeapon( "winchester1200_mp" );
		player switchToWeapon( "winchester1200_mp" );
		player giveMaxammo("winchester1200_mp");
	    wait 0.1;
		level.activ GiveWeapon( "winchester1200_mp" );
        level.activ SwitchToWeapon( "winchester1200_mp" );
		level.activ giveMaxammo("winchester1200_mp");
	    player freezeControls(false);
		level.activ freezeControls(false);
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
		level.shotgun_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		ambientplay("knife");
		iprintln("^1Playng:^7 Nightcore - A+ SuperStar");
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
        iPrintlnBold( "^7" + player.name + " Entered ^6Knife" );
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

oldroom()
{
    level.old_trig = getEnt( "old", "targetname");
	old_door = getent ("old_door","targetname");
    jump = getEnt( "jumper_old", "targetname" );
    
    while(1)
    {   
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.snipe_trig delete();
        level.knife_trig delete();
 		level.jump_trig delete();
		level.shotgun_trig delete();
		level.firstenter=false;
		}
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );      
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        level.activ SwitchToWeapon( "knife_mp" );
		level.activ iprintln("^5You'r Weapons Are Removed");
        iPrintlnBold( " ^4" + player.name + "^7 Entered ^0OLD!" );
		wait 5;
		old_door delete();
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
		level.knife_trig delete();
		level.old_trig delete();
		level.shotgun_trig delete();
		level.firstenter=false;
		}
		ambientplay("jump");
		iprintln("^1Playng:^7 Nightcore - Jump Jump");
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
        iPrintlnBold( " ^7" + player.name + " Entered ^3Jump" );
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

finish()
{
trigger = GetEnt( "finish", "targetname" );
	{
	trigger waittill ("trigger", user);
		{
		iprintlnbold( "^7" + user.name + " ^5F^7inished ^5F^7irst");
		wait 4;
		}
	}
}

jump_wep()
{
trigger = getent ("jump_wep","targetname");
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("You Have Taken [^4R700^7]");
wait(0.1);    
user giveWeapon( "remington700_mp");
user giveMaxammo("remington700_mp");
level.wep hide();
wait 0.1;
user switchToWeapon("remington700_mp");
wait 0.1;
}
}

air_wep()
{
level.wep = getent("air_wep","targetname");
while(1)
{
level.wep rotateYaw(360, 4);
wait 0.1;
}
}

end_crystals()
{
object = getent("end_crystals","targetname");
while(1)
{
object moveZ(16,2);
object waittill("movedone");
wait 0.1;
object moveZ(-16,2);
object waittill("movedone");
wait 0.1;
}
}