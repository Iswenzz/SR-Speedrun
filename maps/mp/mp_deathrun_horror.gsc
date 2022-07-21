main()
{
thread sr\api\_map::createSpawn((-316, 541, 16), 360);

    precacheModel( "playermodel_mw2_usmc_smg_a" );
	precacheModel( "playermodel_ghost_recon" );
	precacheItem( "dragunov_mp" );
	precacheItem( "barrett_mp" );
	precacheItem( "ak47_mp" );
	precacheItem( "ak74u_mp" );
	precacheItem( "g3_mp" );
	precacheItem( "m21_mp" );
	precacheItem( "mp5_mp" );
	precacheItem( "deserteagle_mp" );
	precacheItem( "remington700_mp" );
	precacheItem( "knife_mp" );
	precacheItem( "p90_mp" );
	precacheItem( "rpg_mp" );
	
	level._effect["cannon"] = loadfx( "horror/cannon" );
	level._effect["cannon_fire"] = loadfx( "horror/cannon_fire" );

	//addTriggerToList( "trig_trap1" );
    //addTriggerToList( "trig_trap2" );
    //addTriggerToList( "trig_trap3" );
   // addTriggerToList( "trig_trap4" );
   // addTriggerToList( "trig_trap5" );
   // addTriggerToList( "trig_trap6" );
   // addTriggerToList( "trig_trap7" );
   // addTriggerToList( "trig_trap8" );
   // addTriggerToList( "trig_trap9" );
   // addTriggerToList( "trig_trap10" );
  //  addTriggerToList( "trig_trap11" );
   // addTriggerToList( "trig_trap12" );
   // addTriggerToList( "trig_trap13" );
	
	maps\mp\_load::main();
	maps\mp\_horror_acti_skin::main();
	maps\mp\_horror_jumper_skin::main();
	maps\mp\_teleport1::main();
	maps\mp\_teleport2::main();
	maps\mp\_teleport3::main();
	maps\mp\_teleport4::main();

	//ambientPlay("music1");
	
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
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	thread end_door();
	//thread sniperoom();
	//thread jumproom();
	//thread jumproom_wep();
	//thread virusroom();
	//thread virus_killtele();
	//thread weaponroom();
	//thread old();
	//thread msgs();
	//thread credit();
}

way_connect()
{
    wait 0.05;
    
    level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
	    
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

msgs()
{
	wait 8;
	iprintln("^4>^2Welcome to mp_deathrun_horror!");
	iprintln("Song: Minoru - Reckless");
	wait 10;
	iprintln("^4>^2Have fun and enjoj!");
	wait 10;
	iprintln("^4>^2Creator ^7eBc|Legend");
}

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "Horror" );
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

	hud.color = (1.0, 0.0, 0.0);
	hud.font = "objective";
	hud.glowColor = (1.0, 0.0, 0.0);
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
object = getent("startdoor","targetname");
{
wait 0;
object moveZ(172,3);
object waittill("movedone");
}
}

trap1()
{
cannonfire1 = getent("cannon1","targetname");
//effect1 = getent("fire1","targetname");
trig = getent("trig_trap1","targetname");
trig waittill("trigger" , user );

}

trap2()
{
cannonfire2 = getent("cannon2","targetname");
//effect2 = getent("fire2","targetname");
trig = getent("trig_trap2","targetname");
trig waittill("trigger" , user );

}

trap3()
{
cannonfire3 = getent("cannon3","targetname");
//effect3 = getent("fire3","targetname");
trig = getent("trig_trap3","targetname");
trig waittill("trigger" , user );

}

trap4()
{
trigger = getent("trig_trap4","targetname");
object = getent("trap4","targetname");
trap4quake = getent("trap4quake","targetname");
killtrigger = getent ("kill4" , "targetname");
trigger waittill ("trigger" , player );

}

trap5()
{
trig = getent("trig_trap5","targetname");
plats = getent("trap5","targetname");
trig waittill("trigger", user );

}

trap6()
{
trig = getent("trig_trap6","targetname");
rotator = getent("trap6","targetname");
trig waittill("trigger", user );

}

trap7()
{
	part1 = getentarray ("trap7_1" ,"targetname");
	part2 = getentarray ("trap7_2" ,"targetname");
	part3 = getentarray ("trap7_3" ,"targetname");
	part4 = getentarray ("trap7_4" ,"targetname");
	trig = getent ("trig_trap7" , "targetname");

 	trig waittill( "trigger", user ); 
	
}

trap8()
{
trig = getent("trig_trap8","targetname");
object = getent("trap8","targetname");
trig waittill("trigger", user );

}

trap9()
{
trig = getent("trig_trap9","targetname");
pillar1 = getent("pillar1","targetname");
pillar2 = getent("pillar2","targetname");
pillar3 = getent("pillar3","targetname");
pillar4 = getent("pillar4","targetname");
pillar5 = getent("pillar5","targetname");
trig waittill("trigger", user );

}

trap10()
{
trig = getent("trig_trap10","targetname");
object = getent("trap10","targetname");
trig waittill("trigger", user );

}

trap11()
{
	trig = getent("trig_trap11","targetname");
	//object1 = getent("trap11_1","targetname");
	object2 = getent("trap11_2","targetname");
	trig waittill("trigger", user );
	
}

trap12()
{
	trig = getent("trig_trap12","targetname");
	object = getent("trap12","targetname");
	trig waittill("trigger", user );
	
}

trap13()
{
	level.fan = getEnt("trap13","targetname");
	trig = getent("trig_trap13","targetname");
	trig waittill("trigger", user);
	
}



trap13_pusher()
{
	level.pusher = getEnt ( "pusher", "targetname" );
	thread stop();
	
	while(1)
	{
    	level.pusher waittill ( "trigger", who );
	
	    oldpos = who.origin;
	    strenght = 10;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishplayerdamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
	}
}

stop()
{
	wait 10;
	level.pusher delete();
}

end_door()
{
	door1 = getEnt ("door1","targetname");
	door2 = getEnt ("door2","targetname");
	trig = getent ("doortrig","targetname");
	trig delete();
	{
		door1 moveY(72, 1);
		door2 moveY(-72, 1);
	}

}

doHud()
{
	level endon( "intermission" );
		
	colour = randomInt(20);
	switch(colour)
	{
		case 0:
			level.randomcolour = (1, 0, 0);
			break;
		case 1:
			level.randomcolour = (0.3, 0.6, 0.3);
			break;
		case 2:
			level.randomcolour = (0.602, 0, 0.563);
			break;
		case 3:
			level.randomcolour = (0.055, 0.746, 1);
			break;
		case 4:
			level.randomcolour = (0, 1, 0);
			break;
		case 5:
			level.randomcolour = (0.043, 0.203, 1);
			break;
		case 6:
			level.randomcolour = (0.5, 0.0, 0.8);
			break;
		case 7:
			level.randomcolour = (1.0, 0.0, 0.0);
			break;
		case 8:
			level.randomcolour = (0.9, 1.0, 0.0);
			break;
		case 9:
			level.randomcolour = (1.0, 0.0, 0.0);
			break;			
		case 10:
			level.randomcolour = (1.0, 0.0, 0.4);
			break;
		case 11:
			level.randomcolour = (1.0, 0.5, 0.0);
			break;
		case 12:
			level.randomcolour = (0.0, 0.5, 1.0);
			break;
		case 13:
			level.randomcolour = (0.5, 0.0, 0.8);
			break;
		case 14:
			level.randomcolour = (1.0, 0.0, 0.4);
			break;
		case 15:
			level.randomcolour = (0.0, 0.5, 1.0);
			break;
		case 16:
			level.randomcolour = (0.3, 0.0, 0.3);
			break;
		case 17:
			level.randomcolour = (0.0, 0.5, 1.0);
			break;	
		case 18:
			level.randomcolour = (0.5, 0.0, 0.2);
			break;
		case 19:
			level.randomcolour = (0.0, 1.0, 1.0);
			break;
		case 20:
			level.randomcolour = (0.0, 0.0, 1.0);
			break;
		case 21:
			level.randomcolour = (0.0, 1.0, 1.0);
			break;
		default: 
			level.randomcolour = (0.0, 0.0, 1.0);
			break;
	}
	
	//0.5, 0.0, 0.8 - Sexxy purple
	//1.0, 0.0, 0.0 - Epic Red
	//1.0, 0.0, 0.4 - Preppy Pink
	//0.0, 0.8, 0.0 - Epic Green
	//0.9, 1.0, 0.0 - Banana Yellow
	//1.0, 0.5, 0.0 - Burnt Orange
	//0.0, 0.5, 1.0 - Turquoise
	//0.0, 0.0, 1.0 - Deep Blue
	//0.3, 0.0, 0.3 - Deep Purple
	//0.0, 1.0, 0.0 - Light Green
	//0.5, 0.0, 0.2 - Maroon
	//0.0, 0.0, 0.0 - Black
	//1.0, 1.0, 1.0 - White
	//0.0, 1.0, 1.0 - Cyan
	
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
		level.jump_trig delete();
		level.weapon_trig delete();
		level.virus_trig delete();
		level.old_trig delete();
		level.firstenter=false;
		}
        
			noti = SpawnStruct();
			noti.titleText = "^2>|^7Sniper Room^2|<";
			noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		ambientPlay("music2");
		iprintln("^4Song: ^2Martin Garrix Virus");
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	    player freezeControls(true);
		level.activ freezeControls(true);
	    wait 0.1;
        player GiveWeapon( "remington700_mp" );
		player switchToWeapon( "remington700_mp" );
		player giveMaxammo("remington700_mp");
	    wait 0.1;
		level.activ GiveWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
        level.activ giveMaxammo("remington700_mp");
        wait 6;
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
		level.virus_trig delete();
		level.weapon_trig delete();
		level.old_trig delete();
		level.firstenter=false;
		}
        
			noti = SpawnStruct();
			noti.titleText = "^2>|^7Jump Room^2|<";
			noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		ambientPlay("music2");
		iprintln("^4Song: ^2Martin Garrix Virus");
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	    player freezeControls(true);
		level.activ freezeControls(true);
	    wait 0.1;
        player GiveWeapon( "deserteagle_mp" );  
        player switchToWeapon( " deserteagle_mp" );
		player setWeaponAmmoClip("deserteagle_mp", 0 );
		player setWeaponAmmoStock( "deserteagle_mp", 0 );
	    wait 0.1;
        level.activ GiveWeapon( "deserteagle_mp" );  
        level.activ switchToWeapon ( "deserteagle_mp" );
		level.activ setWeaponAmmoClip("deserteagle_mp", 0 );
		level.activ setWeaponAmmoStock( "deserteagle_mp", 0 );
        wait 6;
	    player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

jumproom_wep()
{
trigger = getent ("jump_wep","targetname");
trigger waittill ("trigger",user); 
{  
trigger delete();
user giveWeapon( "m40a3_mp");
user setWeaponAmmoStock ( "m40a3_mp", 5 );
user setWeaponAmmoClip ( "m40a3_mp", 5 );
user switchToWeapon("m40a3_mp");
wait 0.1;
}
}

virusroom()
{
    level.virus_trig = getEnt( "virus", "targetname");
    jump = getEnt( "jumper_virus", "targetname" );
    acti = getEnt( "acti_virus", "targetname" );

    
    while(1)
    {
        level.virus_trig waittill( "trigger", player );
        if( !isDefined( level.virus_trig ) )
            return;
			
		if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.jump_trig delete();
		level.weapon_trig delete();
		level.old_trig delete();
		level.firstenter=false;
		}
        
			noti = SpawnStruct();
			noti.titleText = "^2>|^7Virus Room^2|<";
			noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		ambientPlay("music2");
		iprintln("^4Song: ^2Martin Garrix Virus");
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	 	player freezeControls(true);
		level.activ freezeControls(true);
	    wait 0.1;
        player GiveWeapon( "deserteagle_mp" ); 
        player setWeaponAmmoClip("deserteagle_mp", 0 );
		player setWeaponAmmoStock( "deserteagle_mp", 0 ); 
        player switchToWeapon( " deserteagle_mp" );
		player.maxhealth = 300;
		player.health = player.maxhealth;
		iprintln ("" + player.name + " ^2H^7ave ^2E^7xtra ^2H^7ealth");
	    wait 0.1;
	    level.activ iprintlnbold("^1Y^7ou ^1H^7ave ^1A^7ll ^1S^7nipers");
        level.activ giveWeapon("remington700_mp" );
        level.activ giveWeapon("m40a3_mp ");
        level.activ giveWeapon("dragunov_mp"); 
        level.activ giveWeapon("barrett_mp" ); 
        level.activ giveMaxammo("remington700_mp");
        level.activ giveMaxammo("m40a3_mp");
        level.activ giveMaxammo("dragunov_mp");
        level.activ giveMaxammo("barrett_mp");
        level.activ switchToWeapon("remington700_mp");
        wait 4;
        player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

virus_killtele()
{
	trig = getEnt ("virus_tele","targetname");
	orig = getent ("tele_spot","targetname");
	trig waittill("trigger", player );
	{
		player SetPlayerAngles( orig.angles );
		player setOrigin( orig.origin );
		wait 0.1;
		level.activ freezeControls(true);
		iprintlnbold ("^1A^7ctivator ^1I^7s ^1U^7nable ^1T^7o ^1M^7ove");
		player setWeaponAmmoClip("deserteagle_mp", 2);
		player setWeaponAmmoStock("deserteagle_mp", 2);
	}
}

weaponroom()
{
    level.weapon_trig = getEnt( "weapon", "targetname");
    jump = getEnt( "jumper_wep", "targetname" );
    acti = getEnt( "acti_wep", "targetname" );

    
    while(1)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
            return;
			
		if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.jump_trig delete();
		level.virus_trig delete();
		level.old_trig delete();
		level.firstenter=false;
		}
        
			noti = SpawnStruct();
			noti.titleText = "^2>|^7Weapon Room^2|<";
			noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		ambientPlay("music2");
		iprintln("^4Song: ^2Martin Garrix Virus");
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	 	player freezeControls(true);
		level.activ freezeControls(true);
	    wait 0.1;
	    level.player = player;
        thread player_wep(); 
        thread acti_wep();
        wait 6;
        player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

player_wep()
{
	random = randomint(10);

	switch(random)
	{
		case 0:
				level.player giveWeapon("ak47_mp");
				level.player switchToWeapon("ak47_mp");
				break;	
		case 1:	
				level.player giveWeapon("ak74u_mp");
				level.player switchToWeapon("ak74u_mp");
				break;
		case 2:
				level.player giveWeapon("g3_mp");
				level.player switchToWeapon("g3_mp");
				break;
		case 3:
				level.player giveWeapon("m21_mp");
				level.player switchToWeapon("m21_mp");
				break;
		case 4:
				level.player giveWeapon("mp5_mp");
				level.player switchToWeapon("mp5_mp");
				break;
		case 5:
				level.player giveWeapon("deserteagle_mp");
				level.player switchToWeapon("deserteagle_mp");
				break;
		case 6:
				level.player giveWeapon("remington700_mp");
				level.player switchToWeapon("remington700_mp");
				break;
		case 7:
				level.player giveWeapon("knife_mp");
				level.player switchToWeapon("knife_mp");
				break;
		case 8:
				level.player giveWeapon("p90_mp");
				level.player switchToWeapon("p90_mp");
				break;
		case 9:
				level.player giveWeapon("rpg_mp");
				level.player switchToWeapon("rpg_mp");
				
		default: return;
	}

}


acti_wep()
{
	random = randomint(10);

	switch(random)
	{
		case 0:
				level.activ giveWeapon("ak47_mp");
				level.activ switchToWeapon("ak47_mp");
				break;	
		case 1:	
				level.activ giveWeapon("ak74u_mp");
				level.activ switchToWeapon("ak74u_mp");
				break;
		case 2:
				level.activ giveWeapon("g3_mp");
				level.activ switchToWeapon("g3_mp");
				break;
		case 3:
				level.activ giveWeapon("m21_mp");
				level.activ switchToWeapon("m21_mp");
				break;
		case 4:
				level.activ giveWeapon("mp5_mp");
				level.activ switchToWeapon("mp5_mp");
				break;
		case 5:
				level.activ giveWeapon("deserteagle_mp");
				level.activ switchToWeapon("deserteagle_mp");
				break;
		case 6:
				level.activ giveWeapon("remington700_mp");
				level.activ switchToWeapon("remington700_mp");
				break;
		case 7:
				level.activ giveWeapon("knife_mp");
				level.activ switchToWeapon("knife_mp");
				break;
		case 8:
				level.activ giveWeapon("p90_mp");
				level.activ switchToWeapon("p90_mp");
				break;
		case 9:
				level.activ giveWeapon("rpg_mp");
				level.activ switchToWeapon("rpg_mp");
				
		default: return;
	}

}

old()
{
	level.old_trig = getent ("old_trig","targetname");
	door = getEnt ("old_door","targetname");
	level.old_trig waittill ("trigger", player );
	{
		{
		level.old_trig delete();
		level.jump_trig delete();
		level.snipe_trig delete();
		level.virus_trig delete();
		level.weapon_trig delete();
		}

	door moveZ(-224, 5);
	door waittill("movedone");
	iprintlnbold ("^2>|^1O^7ld ^1D^7oor ^1i^7s ^1O^7pened^2|<");

	}

}