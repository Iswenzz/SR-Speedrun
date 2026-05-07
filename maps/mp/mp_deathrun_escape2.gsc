/*
	YOU HAVE NO PERMISSION TO USE THESE SCRIPTS!
	IF YOU NEED HELP WITH SCRIPTING ADD MY XFIRE: iqwikscopez
	Thanks to Stealth for doing guid script
	
	SCRIPTED BY FEARZ!
*/
main()
{
    maps\mp\_load::main();
	
	//level.effect1 = LoadFX("smoke/green_smoke");
	//level.effect2 = LoadFX("misc/watersplash_large");
	//PreCacheShellShock( "frag_grenade_mp" );
	//PreCacheItem("deserteagle_mp");
	//PreCacheItem("uzi_mp");
	//PreCacheItem("m4_mp");
	//PreCacheItem("ak47_mp");
	//PreCacheItem("g3_mp");
	//PreCacheItem("m60e4_mp");
	////PreCacheItem("p90_mp");
	//PreCacheItem("barrett_mp");
	//PreCacheItem("frag_grenade_mp");

	thread sr\api\_map::createSpawn((602, 504, 252), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((-7611.16, -2664.36, 183.183), 145,200, "normal_0");

	thread custom_tp();
	
	/*thread randomgun();
	thread mapper();
	thread portalsong();
	thread secretexit();
	thread killsound();
	thread secret_teleport();
	thread CheckLastMan();
	thread minigame();
	thread blockspin();
	thread finaldoor();
	thread turret1();
	thread turret2();
	thread turret3();
	thread turret4();
	thread turret5();
	thread fall1();
	thread trap1();
	thread trap2();
	thread trap3();
	thread lift();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();*/
}
custom_tp()
{
	trig = spawn("trigger_radius",(-1000.91, 503.649, 192.125), 0, 150, 120);
	trig.radius = 150;
	
	ori_t = spawn("script_origin",(-2100,-575,252));
	ori_t.angles = (0,269,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}

mapper()
{
    for(;;)
    {
        wait 60;
        iPrintln("Map made by ^1[aL]FearZ");
    }
}

portalsong()
{
	trig = getEnt ("portal_song", "targetname");
	sound = getEnt ("portal_song_org", "targetname");
	
	trig waittill ("trigger", player);
	trig delete();
	{
		sound PlaySound("portalsong"); 
		iPrintlnBold( player.name + " ^2Found the portal song ^1<3^7!");
	}
}

secretexit()
{
	trig = getEnt ("tele_secret2", "targetname");
	target1 = getEnt ("tele_secretexit", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
	
		if( RandomInt(2) == 0 )
		{
			player SetOrigin( target1.origin );
		}
	}
}

secret_teleport()
{
	trigger = getEnt( "secret_trig", "targetname" );
	org = getEnt( "secret_org", "targetname" );

	level.accepted1 = "53f59ceb1fb75d6879f5a0e9d4a5f422"; //Stealth
	level.accepted2 = "cd03d28b7652eb91a6a2d850c743c983"; //fearz
	level.accepted3 = "b17ea990e1ba4d8fe5feb364fb93ac5f"; //lossy
	level.accepted4 = "af8e6df0e95659a175ef5e3db5027ccc"; //dog
	level.accepted5 = "351ec0714311149968270ff89f6491a0"; //troll
	level.accepted6 = "14402f1613bd52b4bd3a6e00c92ca78a"; //techno
	level.accepted7 = "0b427b0f262ab108cd0b6a25d8e54f9a"; //slize

	
	while (1)
	{
		trigger waittill( "trigger", player );
		tempGuid = player getGUID();
        if((tempGuid == level.accepted1) || (tempGuid == level.accepted2) || (tempGuid == level.accepted3) || (tempGuid == level.accepted4) || (tempGuid == level.accepted5) || (tempGuid == level.accepted6) || (tempGuid == level.accepted7))
		{
			{
			player SetOrigin( org.origin );
        	player iprintlnbold("^1Teleported Successfully");
			}
		}
	}
}

killsound()
{
	trig = getEnt ("soundcheck_trig", "targetname");
	sound = getEnt ("winner2", "targetname");
	
	trig waittill ("trigger", player);
	trig delete();
	
	wait 1;
	sound PlaySound("pretect_humans");	
	
}

turret1()
{
	trig = getEnt ("turretlaser1_trig", "targetname");
	turret = getEnt ("turretlaser1", "targetname");
	target = getEnt ("jumper_tele", "targetname");
	sound = getEnt ("turretlaser1_sound", "targetname");
	
	for(;;)
	{
		turret hide();
		trig waittill ("trigger", player);
		turret show();
		turret rotateyaw (20,2);
		wait 2;
		turret rotateyaw (-20,2);
		wait 2;
		if ( player istouching ( trig ) )
		{
			wait 1;
			sound PlaySound("turret_lock");	
			player SetOrigin( target.origin );
			player iprintlnbold("A turret shot you");
			wait 0.5;
		}
		else
		{
			turret hide();
			sound PlaySound("turret_lost");	
			wait 0.5;
		}
	}
}

turret2()
{
	trig = getEnt ("turretlaser2_trig", "targetname");
	turret = getEnt ("turretlaser2", "targetname");
	target = getEnt ("jumper_tele", "targetname");
	sound = getEnt ("turretlaser2_sound", "targetname");
	
	for(;;)
	{
		turret hide();
		trig waittill ("trigger", player);
		turret show();
		turret rotateyaw (-20,2);
		wait 2;
		turret rotateyaw (20,2);
		wait 2;
		if ( player istouching ( trig ) )
		{
			wait 1;
			sound PlaySound("turret_lock");
			player SetOrigin( target.origin );
			player iprintlnbold("A turret shot you");
			wait 0.5;
		}
		else
		{
			turret hide();
			sound PlaySound("turret_lost");
			wait 1;
		}
	}
}

turret3()
{
	trig = getEnt ("turretlaser3_trig", "targetname");
	turret = getEnt ("turretlaser3", "targetname");
	target = getEnt ("jumper_tele", "targetname");
	sound = getEnt ("turretlaser3_sound", "targetname");
	
	for(;;)
	{
		turret hide();
		trig waittill ("trigger", player);
		turret show();
		turret rotateyaw (-20,2);
		wait 2;
		turret rotateyaw (20,2);
		wait 2;
		if ( player istouching ( trig ) )
		{
			wait 1;
			sound PlaySound("turret_lock");
			player SetOrigin( target.origin );
			player iprintlnbold("A turret shot you");
			wait 0.5;
		}
		else
		{
			turret hide();
			sound PlaySound("come_closer");
			wait 0.5;
		}
	}
}

turret4()
{
	trig = getEnt ("turretlaser4_trig", "targetname");
	turret = getEnt ("turretlaser4", "targetname");
	target = getEnt ("jumper_tele", "targetname");
	sound = getEnt ("turretlaser4_sound", "targetname");
	
	for(;;)
	{
		turret hide();
		trig waittill ("trigger", player);
		turret show();
		turret rotateyaw (-20,2);
		wait 2;
		turret rotateyaw (20,2);
		wait 2;
		if ( player istouching ( trig ) )
		{
			wait 1;
			sound PlaySound("turret_lock");
			player SetOrigin( target.origin );
			player iprintlnbold("A turret shot you");
			wait 0.5;
		}
		else
		{
			turret hide();
			sound PlaySound("turret_lost");
			wait 0.5;
		}
	}
}

turret5()
{
	trig = getEnt ("turretlaser5_trig", "targetname");
	turret = getEnt ("turretlaser5", "targetname");
	target = getEnt ("jumper_tele", "targetname");
	sound = getEnt ("turretlaser5_sound", "targetname");
	
	for(;;)
	{
		turret hide();
		trig waittill ("trigger", player);
		turret show();
		turret rotateyaw (-20,2);
		wait 2;
		turret rotateyaw (20,2);
		wait 2;
		if ( player istouching ( trig ) )
		{
			sound PlaySound("turret_lock");
			player SetOrigin( target.origin );
			player iprintlnbold("A turret shot you");
			wait 0.5;
		}
		else
		{
			turret hide();
			sound PlaySound("turret_lost");
			wait 0.5;
		}
	}
}

minigame()
{
	cake1 = getEnt ("cake1", "targetname");
	cake2 = getEnt ("cake2", "targetname");
	cake3 = getEnt ("cake3", "targetname");
	trig1 = getEnt ("trig_cake1", "targetname");
	trig2 = getEnt ("trig_cake2", "targetname");
	trig3 = getEnt ("trig_cake3", "targetname");
	
	cake1 hide();
	cake2 hide();
	cake3 hide();
	for(;;)
	{
		if( RandomInt(2) == 0 )
		{
			cake1 show();
			trig2 delete();
			trig3 delete();
			trig1 waittill ("trigger", player);
			player GiveWeapon("ak47_mp");
			player setWeaponAmmoClip( "ak47_mp", 100 );
			player setweaponammostock( "ak47_mp", 100 );
			iPrintlnBold( player.name + " ^2Found the cake!");
			player SwitchToWeapon("ak47_mp");
			thread checkwinner();
			break;
		}
		else
		{
			cake2 show();
			trig3 delete();
			trig1 delete();
			trig2 waittill ("trigger", player);
			player GiveWeapon("ak47_mp");
			player setWeaponAmmoClip( "ak47_mp", 100 );
			player setweaponammostock( "ak47_mp", 100 );
			player SwitchToWeapon("ak47_mp");
			iPrintlnBold( player.name + " ^2Found the cake!");
			thread checkwinner();
			break;
		}
	}
}

checkwinner()
{
	trig = getEnt ("trig_checker", "targetname");
	target1 = getEnt ("winner1", "targetname");
	target2 = getEnt ("winner2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
	
		if( RandomInt(2) == 0 )
		{
			player SetOrigin( target1.origin );
		}
		else
		{
			player SetOrigin( target2.origin );
		}		
	}
	
}

finaldoor()
{
	trig = getEnt ("finaldoor_trig", "targetname");
	door = getEnt ("finaldoor", "targetname");

	trig waittill ("trigger", who);
	trig delete();
	iPrintlnBold( who.name + " ^3Finished in first place!" );
	wait 2;
	door delete();
}

blockspin()
{
	block1 = getEnt ("minecraftblock1", "targetname");
	block2 = getEnt ("minecraftblock2", "targetname");
	block3 = getEnt ("minecraftblock3", "targetname");
	block4 = getEnt ("minecraftblock4", "targetname");
	
	while ( 1 )
	{
		block1 moveZ (20,2);
		block2 moveZ (20,2);
		block3 moveZ (20,2);
		block4 moveZ (20,2);
		block1 rotateyaw (360,2);
		block2 rotateyaw  (360,2);
		block3 rotateyaw  (360,2);
		block4 rotateyaw  (360,2);
		wait 2;
		block1 moveZ (-20,2);
		block2 moveZ (-20,2);
		block3 moveZ (-20,2);
		block4 moveZ (-20,2);
		block1 rotateyaw (360,2);
		block2 rotateyaw (360,2);
		block3 rotateyaw (360,2);
		block4 rotateyaw (360,2);
		wait 2;
	}
}

randomgun()
{
	trigger = getEnt ("randomguntrig", "targetname");
	
while(1)
	{
	trigger waittill("trigger", user);
		{
			{
			wait 0.1;
			user iprintLnBold("Giving you a random weapon...");
			random = randomInt(9);

			if(random == 0)
			{
				user rewardWeapon( "primary", "deserteagle_mp", 100, 500 );
				user iprintLnBold("You have recieved a deserteagle");
			}
			if(random == 1)
			{
				user rewardWeapon( "primary", "uzi_mp", 100, 500 );
				user iprintLnBold("You have recieved an uzi");
			}
			if(random == 2)
			{
				user rewardWeapon( "primary", "m4_mp", 100, 500 );
				user iprintLnBold("You have recieved an m4");
			}
			if(random == 3)
			{
				user rewardWeapon( "primary", "ak47_mp", 100, 500 );
				user iprintLnBold("You have recieved an ak47");
			}
			if(random == 4)
			{
				user rewardWeapon( "primary", "g3_mp", 100, 500 );
				user iprintLnBold("You have recieved a g3");
			}
			if(random == 5)
			{
				user rewardWeapon( "primary", "m60e4_mp", 100, 500 );
				user iprintLnBold("You have recieved an m60");
			}
			if(random == 6)
			{
				user rewardWeapon( "primary", "p90_mp", 100, 500 );
				user iprintLnBold("You have recieved a p90");
			}
			if(random == 7)
			{
				user rewardWeapon( "primary", "m40a3_mp", 100, 500 );
				user iprintLnBold("You have recieved a m40a3");
			}
			if(random == 8)
			{
				user rewardWeapon( "primary", "barrett_mp", 100, 500 );
				user iprintLnBold("You have recieved a barrett 50cal");
			}
			if(random == 9)
			{
				user rewardWeapon( "offhand", "frag_grenade_mp", 100, 0 );
				user iprintLnBold("You have recieved a frag grenade");
			}
		}
	}
}
}

rewardWeapon( weaponType, weaponName, ammoClip, ammoStock )
{
self endon( "disconnect" );
	if ( weaponType == "primary" )
	{
		self takeWeapon( self getCurrentWeapon() );
		self giveWeapon( weaponName );
		self setWeaponAmmoClip( weaponName, ammoClip );
		self setWeaponAmmoStock( weaponName, ammoStock );
		self switchToWeapon( weaponName );
	}
	else if ( weaponType == "offhand" )
	{
		self giveWeapon( weaponName );
		self setWeaponAmmoClip( weaponName, ammoClip );
		self switchToOffhand( weaponName );
	}
	else // if ( weaponType == "inventory" )
	{
		self giveWeapon( weaponName );
		self setWeaponAmmoClip( weaponName );
		self setWeaponAmmoStock( weaponName );
		self setActionSlot( 3, "weapon", weaponName );
	}
}

fall1()
{
	trig = getEnt ("fall_1", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", who);
		playFx( level.effect2, who.origin);
		who suicide();	
	}
}

trap1()
{
	trig = getEnt ("trap1_trig", "targetname");
	trap1 = getEnt ("trap1_turn", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 1");
	
	while (1)
	{
		trap1 rotatepitch (-360,8);
		wait 8;
	}
}

trap2()
{
	spike = getEnt ("trap2_spike", "targetname");
	hurt = getEnt ("trap2_hurt", "targetname");
	trig = getEnt ("trap2_trig", "targetname");
	
    hurt enablelinkto();
    hurt linkto (spike);
	
	spike hide();
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 2");
	spike show();
	
	{
		spike moveZ (64,1.5);
		wait 5;
		spike moveZ (-64,1.5);
	}
}

lift()
{
	lift = getEnt ("trap3_lift", "targetname");
	
	while(1)
	{
		lift moveX (-768, 3);
		wait 5;
		lift moveY (-1000, 3);
		wait 7;
		lift moveY (1000, 3);
		wait 5;
		lift moveX (768, 3);
		wait 5;
	}
}

trap3()
{
	trig = getEnt ("trap3_trig", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 3");
	
	thread part1();
	thread part2();
	
}

part1()
{
	part1 = getEnt ("trap3_part1", "targetname");
	
	while (1)
	{
		part1 rotateyaw (360, 4);
		wait 4;
	}
}	

part2()
{
	part2_1 = getEnt ("trap3_part2_1", "targetname");
	part2_2 = getEnt ("trap3_part2_2", "targetname");
	
	
	for(;;)
	{
		if( RandomInt(2) == 0 )
		{	
			part2_1 moveX (192,2);
			wait 3;
			part2_1 moveX(-192,2);
			wait 3;
		}
		else
		{
			part2_2 moveX (192,2);
			wait 3;
			part2_2 moveX (-192,2);
			wait 3;
		}
	}
}

trap4()
{
	trig = getEnt ("trap4_trig", "targetname");
	gas1 = getEnt ("trap4_efx1", "targetname");
	door = getEnt ("trap4_door", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 4");
	
	door moveZ (-192,2);
	thread shell();
	playFx( level.effect1, gas1.origin);
	wait 11;
	door moveZ (192,2);
}	

shell()
{
	trig = getEnt ("trap4_hurt", "targetname");
	door = getEnt ("trap4_door", "targetname");
	
	trig enablelinkto();
	trig linkto(door);	
	
	for(;;)
	{
		trig waittill ("trigger", who);
		who ShellShock ( "frag_grenade_mp", 5 );
		wait 4;
		who suicide();
		wait 5;
	}
}
	
trap5()
{
	trig = getEnt ("trap5_trig", "targetname");
	floor1 = getEnt ("trap5_1", "targetname");
	floor2 = getent ("trap5_2", "targetname");
	floor3 = getEnt ("trap5_3", "targetname");
	floor4 = getEnt ("trap5_4", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 5");	
	
	for(;;)
	{
		if( RandomInt(2) == 0 )
		{
			floor1 delete();
			floor4 delete();
			break;
		}
		else
		{
			floor2 delete();
			floor3 delete();
			break;
		}
	}
}

trap6()
{
	trig = getEnt ("trap6_trig", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 6");
	
	for(;;)
	{
		if( RandomInt(2) == 0 )
		{
			thread kill1();
			break;
		}
		else
		{
			thread kill2();
			break;
		}
	}
}
	
kill1()
{
	trig = getEnt ("trap6_kill1", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
		wait 0.5;
	}
}	

kill2()
{
	trig = getEnt ("trap6_kill2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
		wait 0.5;
	}
}

trap7()
{
	trig = getEnt ("trap7_trig", "targetname");
	part1 = getEnt ("trap7_spike1", "targetname");
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 7");
	
	part1 = getEnt ("trap7_spike1", "targetname");
	part1_hurt = getEnt ("trap7_hurt1", "targetname");
	
    part1_hurt  enablelinkto();
    part1_hurt  linkto (part1);
	
	{
		part1 moveZ (-400,3);
		wait 3;
		part1 moveZ (400,1);
		wait 2;
	}
}

trap8()
{
	trig = getEnt ("trap8_trig", "targetname");
	
	trig waittill( "trigger", who ); 
	trig delete();
    iPrintln (who.name + " ^5Activated Trap 8");
	
	while( 1 )
	{
		fanTrap();
		wait 5;
	}
}

fanTrap()
{
	level endon( "stop fan" );

	area = getEnt( "fan_blabla","targetname" );	
	fan = getEnt( "end_fan","targetname" );
	trig = getEnt ("trap8_trig", "targetname");

	pushPower = 100; 
	time = 10;		
	level thread blabla( fan, time );
	wait 0.05;
	
	trig waittill ("trigger", who);
	trig delete();
	iPrintln( who.name + " ^5Activated trap 8");

	while ( 1 )
	{
		area waittill ( "trigger", player );
		if ( player istouching ( area ) )
		{
			player.health = ( player.health + pushPower );		
		    player finishPlayerDamage( player, player, pushPower, 0, "MOD_PROJECTILE", "none", player.origin, vectorNormalize(player.origin - fan.origin), "none", 0 );
		}
	}
}

blabla( fan, time )
{
	for( i = 0; i < time; i++ )
	{
		fan rotatepitch( 360, 1 );
		wait 1;
	}
	level notify( "stop fan" );
}

trap9()
{
	trig = getEnt ("trap9_trig", "targetname");
	swing = getEnt ("trap9_swing", "targetname");
	swing2 = getEnt ("trap9_swing_2", "targetname");
	swing3 = getEnt ("trap9_swing_3", "targetname");
	
	trig waittill( "trigger", who ); 
	trig delete();
    iPrintln (who.name + " ^5Activated Trap 9");
	
	while ( 1 )
	{
		swing rotateroll (360,2);
		swing2 rotateroll (360,2);
		swing3 rotateroll (360,2);
		wait 2;
		swing rotateroll (-360,2);
		swing2 rotateroll (-360,2);
		swing3 rotateroll (-360,2);
	}
}

trap10()
{
	trig = getEnt ("trap10_trig", "targetname");
	part1 = getEnt ("trap10_part1", "targetname");
	part2 = getEnt ("trap10_part2", "targetname");
	floor1 = getEnt ("trap10_floor1", "targetname");
	floor2 = getEnt ("trap10_floor2", "targetname");
	
	part1 hide();
	part2 hide();
	
	trig waittill( "trigger", who ); 
	trig delete();
    iPrintln (who.name + " ^5Activated Trap 10");
	
	for(;;)
	{
	if( randomInt(2) == 0 )
	{
		floor2 delete();
		part2 show();
		break;
	}
	else
	{
		floor1 delete();
		part1 show();
		break;
	}
	}
}	

CheckLastMan()
{
    wait 5;
    players = getentarray("player", "classname");
	trig = getEnt ("finaldoor_trig", "targetname");
    jumperteleported = false;
    activatorteleported = false;
	
	for(;;)
	{
		trig waittill ("trigger");
		thread check();
	}
}
	

check()
{

    players = getentarray("player", "classname");
    jumperteleported = false;
    activatorteleported = false;
	
	
    while(!jumperteleported && !activatorteleported)
    {
    wait 1;
        jumpersalive = GetTeamPlayersAlive("allies");
        activatorsalive = GetTeamPlayersAlive("axis");

        if(jumpersalive <= 1 && activatorsalive <= 1)
        {	
			iprintlnbold("First person to find the cake will get a gun!");
			iprintlnbold("If you get shot by turrets you will be set back here");
		
            for(i=0;i<=players.size;i++)
            {
            wait 0.1;
                if(players[i].pers["team"] == "allies" && isAlive(players[i]))
                {
                    teleporter_jumpers = getent("jumper_tele", "targetname");
                    players[i] SetOrigin(teleporter_jumpers.origin);
					players[i] TakeAllWeapons();
					wait 0.05;
                    jumperteleported = true;
                }
                else if(players[i].pers["team"] == "axis" && isAlive(players[i]))
                {
                    teleporter_activators = getent("activator_tele", "targetname");
                    players[i] SetOrigin(teleporter_activators.origin);
					players[i] TakeAllWeapons();
					wait 0.05;
                    activatorteleported = true;
                }
            }
        }
    wait 0.1;
    }
}