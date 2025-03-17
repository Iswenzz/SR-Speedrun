main()
{
thread sr\api\_map::createSpawnOrigin((-619, -440, 16), 360);
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
	addTriggerToList("trig_trap12");
	addTriggerToList("trig_trap13");
	addTriggerToList("trig_trap14");

	maps\mp\_load::main();
	maps\mp\_teleport1::main();
	maps\mp\_teleport2::main();
	maps\mp\_teleport3::main();
	maps\mp\_teleport4::main();

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

	trigger = spawn( "trigger_radius", (-694.431, 5677.12, -31.875), 0, 170, 100 );
	trigger.targetname = "endmap_trig";
	trigger.radius = 170;


	thread way_connect();

	//thread credit();
	thread startdoor();
	//thread startmessages();
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
	//thread trap12();
	//thread trap13();
	//thread trap14_trig();
	//thread kniferoom();
	//thread jumproom();
	//thread jump_scope();
	//thread sniperoom();
	//thread old();
	//thread weaponroom();
	//thread ammo_box();
	//thread finish();

}

way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
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
thread drawInformation( 800, 0.8, 1, "World Of Metal" );
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

startdoor()
{
trigger = getent("trig_startdoor","targetname");
object = getent("startdoor","targetname");
trigger delete();
{
wait 0;
object movez(-543, 5);
object waittill("movedone");
wait 0;
}
}

startmessages()
{
while(1)
{
wait(10);
iprintln("^1>>^7Welcome Player");
wait(10);
iprintln("^1>>^7Map Creator ^5eBc|^7Legend");
wait(10);
iprintln("^1>>^7Map Created For ^5eBc|^7Deathrun Server");
wait(10);
iprintln("^1>>^7Feal Free To Connect: 185.4.149.21:29050");
wait(5);
iprintln("^1>>^7Or");
wait(10);
iprintln("^1>>^7eBc|CoDJumper.com #5: 185.4.149.11:28962");
wait(10);
iprintln("^1>>^7Have Fun and Enjoj Yourself :D");
wait(180);
}
}



trap1()
{
trigger = getent("trig_trap1","targetname");
object = getent("trap1","targetname");
trigger waittill ("trigger" , player );
}

trap2()
{
trigger = getent("trig_trap2","targetname");
object = getent("trap2","targetname");
trigger waittill ("trigger" , player );
}

trap3()
{
    trigger = getent("trig_trap3","targetname");
	object = getent("t3_","targetname");
    trigger waittill ("trigger" , player );
}

trap4()
{
    trigger = getent("trig_trap4","targetname");
	object = getent("t3_","targetname");
    trigger waittill ("trigger" , player );
}

trap5()
{
trigger = getent("trig_trap5","targetname");
object = getent("trap5","targetname");
trigger waittill ("trigger" , player );
}

trap6()
{
trigger = getent("trig_trap6","targetname");
object = getent("trap6","targetname");
trigger waittill ("trigger" , player );
}

trap7()
{
trigger = getent("trig_trap7","targetname");
object = getent("trap7","targetname");
trigger waittill ("trigger" , player );
}

trap8()
{
trigger = getent("trig_trap8","targetname");
object = getent("trap8","targetname");
trigger waittill ("trigger" , player );
}

trap9()
{
trigger = getent("trig_trap9","targetname");
object = getent("trap9","targetname");
trigger waittill ("trigger" , player );
}

trap10()
{
    trigger = getent("trig_trap10","targetname");
	object = getent("t10_","targetname");
    trigger waittill ("trigger" , player );
}

trap11()
{
trigger = getent("trig_trap11","targetname");
object = getent("trap11","targetname");
trigger waittill ("trigger" , player );
}

trap12()
{
    trigger = getent("trig_trap12","targetname");
	object = getent("t12_","targetname");
    trigger waittill ("trigger" , player );
}

trap13()
{
trigger = getent("trig_trap13","targetname");
object = getent("trap13","targetname");
trigger waittill ("trigger" , player );
}

trap14_trig()
{
trigger = getent("trig_trap14","targetname");
trigger waittill ("trigger" , player );
}

trap14()
{
	part1 = getentarray ("plat1" ,"targetname");
	part2 = getentarray ("plat2" ,"targetname");
	part3 = getentarray ("plat3" ,"targetname");
	part4 = getentarray ("plat4" ,"targetname");
	trig1 = getent ("trig_plat1" , "targetname");
	trig2 = getent ("trig_plat2" , "targetname");
	trig3 = getent ("trig_plat3" , "targetname");
	trig4 = getent ("trig_plat4" , "targetname");

	random = randomint(4);

	switch(random)
	{
		case 0:
		        trig1 waittill( "trigger", user );
				part1[randomInt(part1.size)] moveZ(-544, 2);
				trig2 waittill( "trigger", user );
				part2[randomInt(part2.size)] moveZ(-544, 2);
				break;

		case 1:
		        trig1 waittill( "trigger", user );
				part1[randomInt(part1.size)] moveZ(-544, 2);
				trig3 waittill( "trigger", user );
				part3[randomInt(part3.size)] moveZ(-544, 2);
				break;

		case 2:
		        trig2 waittill( "trigger", user );
				part2[randomInt(part2.size)] moveZ(-544, 2);
				trig4 waittill( "trigger", user );
				part4[randomInt(part4.size)] moveZ(-544, 2);
                break;

		case 3:
		        trig3 waittill( "trigger", user );
				part3[randomInt(part3.size)] moveZ(-544, 2);
				trig4 waittill( "trigger", user );
				part4[randomInt(part4.size)] moveZ(-544, 2);

		default: return;
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
		level.weapon_trig delete();
        level.snipe_trig delete();
        level.old_trig delete();
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
        if(level.firstenter==true)
		{
		level.old_trig delete();
		level.weapon_trig delete();
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
        iPrintlnBold( " ^7" + player.name + " Chose ^5Jump^7!" );
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

jump_scope()
{
trigger = getent ("scope","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user giveWeapon( "remington700_mp");
user giveMaxammo("remington700_mp");
wait 0.1;
user switchToWeapon("remington700_mp");
wait 0.1;
}
}

sniperoom()
{
    level.snipe_trig = getEnt( "sniper", "targetname");
    jump = getEnt( "jump_snipe", "targetname" );
    acti = getEnt( "acti_snipe", "targetname" );


    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;

		if(level.firstenter==true)
		{
		level.weapon_trig delete();
        level.old_trig delete();
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

old()
{
level.old_trig = getent("old","targetname");
door = getent("old_door","targetname");
level.old_trig waittill("trigger" , player );
{
level.old_trig delete();
level.knife_trig delete();
level.jump_trig delete();
level.snipe_trig delete();
level.weapon_trig delete();
{
door moveZ(136, 3);
door waittill("movedone");
wait 1;
}
}
}

weaponroom()
{
    level.weapon_trig = getEnt( "weapon", "targetname");
    jump = getEnt( "jumper_weapon", "targetname" );
    acti = getEnt( "acti_weapon", "targetname" );

    while(1)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.knife_trig delete();
        level.snipe_trig delete();
        level.old_trig delete();
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
        iPrintlnBold( "^7" + player.name + " Chose ^0Weapon^7!" );
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

ammo_box()
{
trigger = getent("ammo_box","targetname");
while(1)
{
trigger waittill("trigger" , user );
user iPrintlnBold("Ammo Restored");
user giveMaxammo("remington700_mp");
user giveMaxammo("m40a3_mp");
wait 0.1;
}
}

finish()
{
trigger = GetEnt( "finish", "targetname" );
	trigger waittill ("trigger", user);
	trigger delete();
		{
		iprintlnbold( "^7" + user.name + " ^3F^1inished ^3F^1irst^7!");
		wait 4;
		}

}

