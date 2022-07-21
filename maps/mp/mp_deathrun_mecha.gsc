main()
{
thread sr\api\_map::createSpawn((181, 1, 16), 360);
    addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
	addTriggerToList("trig_trap10");
	addTriggerToList("trig_trap11");

	maps\mp\_load::main();
	maps\mp\_teleport1::main(); 
	maps\mp\_teleport2::main();
	maps\mp\_teleport4::main();
	maps\mp\_teleport6::main();
	maps\mp\_teleport7::main();
	maps\mp\_teleport8::main();
	
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
	thread sr\api\_speedrun::createSecretWays("Secret Way");
		thread sr\api\_speedrun::createEndMap((-325.249, 3.00147, 16.125), 70, 100);
	//thread credit();
	thread start_door();
	thread elev();
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
	//thread kniferoom();
	//thread jumproom();
	//thread messages1();
	//thread messages2();
	//thread messages3();

		entTransporter = getentarray( "enter3", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
	
	
}

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}	

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^1Mecha" );
wait(6);
thread drawInformation( 800, 0.8, 1, "^3By:Xplosive" );
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

start_door()
{
object = getent("start_door","targetname");
{
ambientPlay("music2");	
object delete();
}
}

elev()
{
object = getent("elev","targetname");
while(1)
{
object moveX(640, 1);
object waittill("movedone");
wait(4);
object moveX(-640, 4);
object waittill("movedone");
wait(1);
}
}

trap1()
{
trigger = getent("trig_trap1","targetname");
object = getent("trap1","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object moveY(508, 0.1);
wait(4);
object moveY(-508, 4);
wait(1);
}
}

trap2()
{
trigger = getent("trig_trap2","targetname");
object = getent("trap2","targetname");
killtrigger = getent ("killtrig_2" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveZ(36, 1.5);
object waittill("movedone");
wait(2);
object moveZ(-36, 3);
object waittill("movedone");
wait(1);
}
}

trap3()
{
trigger = getent("trig_trap3","targetname");
object1 = getent("trap3_1","targetname");
object2 = getent("trap3_2","targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 moveX(128, 1);
object2 moveX(-128, 1);
wait(1);
object1 moveX(-128, 2.5);
object2 moveX(128, 2.5);
wait(2.5);
}
}

trap4()
{
trigger = getent("trig_trap4","targetname");
object = getent("trap4","targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object rotateYaw(360, 1);
wait(2);
object rotateYaw(-360, 1);
wait(2);
}
}

trap5()
{
trigger = getent("trig_trap5","targetname");
object = getent("trap5","targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object rotateYaw(360, 1);
wait(2);
object rotateYaw(-360, 1);
wait(2);
}
}

trap6()
{
trigger = getent("trig_trap6","targetname");
object = getent("trap6","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object notsolid();
object hide();
wait(4);
object solid();
object show();
wait(1);
}
}

trap7()
{
trigger = getent("trig_trap7","targetname");
object = getent("trap7","targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object rotateRoll(360, 1);
wait(2);
object rotateRoll(-360, 1);
wait(2);
}
}

trap8()
{
trigger = getent("trig_trap8","targetname");
object = getent("trap8","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object moveZ(194, 0.1);
wait(4);
object moveZ(-194, 4);
wait(1);
}
}

trap9()
{
trigger = getent("trig_trap9","targetname");
object = getent("trap9","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object notsolid();
object hide();
wait(4);
object solid();
object show();
wait(1);
}
}

trap10()
{
trigger = getent("trig_trap10","targetname");
object = getent("trap10","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object rotateRoll(360, 1);
wait(2);
object rotateRoll(-360, 1);
wait(2);
}
}

trap11()
{
trigger = getent("trig_trap11","targetname");
object = getent("trap11","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object moveZ(-688, 0.1);
wait(4);
object moveZ(688, 4);
wait(1);
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
        level.jump_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
        iPrintlnBold( "^7" + player.name + " ^9Chose ^2Sniper^7!" );
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
		player switchToWeapon( "remington700_mp" );
	    wait 0.1;
		level.activ GiveWeapon( "remington700_mp" );
                level.activ GiveWeapon( "m40a3_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
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
        level.jump_trig delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
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
        iPrintlnBold( "^7" + player.name + " ^2Chose ^3Knife^7!" );
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

jumproom()
{
    level.jump_trig = getEnt( "jump", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.snipe_trig delete();
        level.knife_trig delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
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
        iPrintlnBold( "^7" + player.name + " ^2Chose ^3Jump^7!" );
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

messages1()
{
while (1)
	{
		{
		iprintln( "^1>>^7Map Creator ^5Xplosive");
		wait 30;
		}
	}
}

messages2()
{
while (1)
	{
		{
		iprintln( "^1>>^7Music:Pop Danthology 2012");
		wait 30;
		}
	}
}

messages3()
{
while (1)
	{
		{
		iprintln( "^1>>^7Xfire: ^5seljofk13");
		wait 30;
		}
	}
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		player thread sr\api\_speedrun::changeWay("secret_0");
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		{
			entTransporter = getentarray( "enter10", "targetname" );
	        if(isdefined(entTransporter))
		    for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter2();
		}
	}
}

transporter2()
{
	for(;;)
	{
		self waittill( "trigger", player );
		player thread sr\api\_speedrun::finishWay("secret_0");
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}
