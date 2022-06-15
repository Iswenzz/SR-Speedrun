main()
{
	maps\mp\_load::main();
	
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
	//scrits
	maps\mp\mp_deathrun_online\movings::main();
	maps\mp\mp_deathrun_online\traps::main();
	// maps\mp\mp_deathrun_online\endrooms::main();
	// maps\mp\mp_deathrun_online\helicopter::main();
	// maps\mp\mp_deathrun_online\jukebox::main();
	
	//effects
	level.water_crate = LoadFX ( "mp_deathrun_online/trap_2_water" );
	level.distortion = LoadFX ( "mp_deathrun_online/distortion" );
	level.smoke = LoadFX ( "mp_deathrun_online/green_smoke" );
	level.vip = LoadFX ( "mp_deathrun_online/vip" );
	level.bounce = LoadFX ( "mp_deathrun_online/jump" );
	level.brunnen = LoadFX ( "mp_deathrun_online/pont" );
	level.jukeeffect = LoadFX ( "mp_deathrun_online/rainbow_funken" );
	
	//dvars
	setdvar( "r_specularcolorscale", "1" );
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
    setdvar( "compassmaxrange", "1800" );
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
	
	//Precaches
	precacheItem ( "ak47_acog_mp" );
	precacheItem ( "winchester1200_mp" );
	precacheItem ( "uzi_mp" );
	precacheItem ( "mp5_mp" );
	precacheItem ( "barrett_mp" );
	precacheModel( "vehicle_blackhawk" );
	precacheShellShock ( "frag_grenade_mp" );
	
	thread way_connect();
	thread onConnect();
	thread startdoor();
	// thread icohud();
	// thread unknown();
	thread secret_respawn_1();
	thread secret_respawn_2();
	thread secret_end();
	// thread unknown_weapons();
	// thread ak47();
	// thread uzi();
	// thread r700();
	// thread mp5();
	// thread barrett();
	// thread fail_xp();
	thread back_port();
	// thread weapon_secret_winchester();
	// thread weapon_secret_uzi();
	// thread vip_effect();
	// thread party();
}

onConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.secret_1 = undefined;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
	thread secret1();
	
    for(;;) 
    {
        level waittill( "connected", player );
        
    }
}

secret1()
{
	s1 = spawn( "trigger_radius", (2250.36, -105.584, -15.875), 0, 115, 120 );
	s1.radius = 115;
	thread sr\api\_map::createTriggerFx(s1, "secret");
	
	for(;;)
	{
		s1 waittill("trigger",player);
		
		if(!isDefined(player.secret_1))
		{
			player sr\api\_speedrun::changeWay("secret_0");
			player.secret_1 = true;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

startdoor()
{
	target = getEnt ( "startdoor_target", "targetname" );
	clip = getEnt ( "startdoor_clip", "targetname" );
	
	wait 0.2;
	
	clip Linkto ( target );
	
	target moveZ ( 168, 5, 3, 1);
	
	clip delete();
}

//by Blade
icohud()
{
 
    level endon( "intermission" );
 
    colour = randomInt(5);
    switch(colour)
            {
            case 0:
            level.hudcolour = (0, 0.9, 2);
            break;
            case 1:
            level.hudcolour = (0, 1, 1);
            break;
            case 2:
            level.hudcolour = (0.8 ,1 ,0.1);
            break;
            case 3:
            level.hudcolour = (1, 0, 0);
            break;
            case 4:
            level.hudcolour = (0.9, 0.1, 0.9);
            break;
            }
 
    if( isDefined( level.icomarhud ) )
        level.icomarhud destroy();
 
    level.icomarhud = newHudElem();
    level.icomarhud.foreground = true;
    level.icomarhud.alignX = "center";
    level.icomarhud.alignY = "top";
    level.icomarhud.horzAlign = "center";
    level.icomarhud.vertAlign = "top";
    level.icomarhud.x = 4;
    level.icomarhud.y = 0;
    level.icomarhud.sort = 0;
    level.icomarhud.fontScale = 2;
    level.icomarhud.color = (1.0, 1.0, 1.0);
    level.icomarhud.font = "objective";
    level.icomarhud.glowColor = (level.hudcolour);
    level.icomarhud.glowAlpha = 1;
    level.icomarhud.hidewheninmenu = true;
    level.icomarhud setText( "mp_deathrun_waterworld" );
    wait 10;
	level.icomarhud setText( "map by Icomar" );
	wait 10;
	level.icomarhud setText( "xFire: icomar727" );
	wait 10;
	level.icomarhud setText( "additional help: Blade" );
	wait 10;
	level.icomarhud destroy();
}

//lossy's VIP scipt

unknown()
{
	trigger = getEnt ( "unknown_trigger", "targetname" );
    org = getEnt( "unknown_origin", "targetname" );

    level.accepted1 = "f0909b6a1c65356edf1cbaaac409ae43";
    level.accepted2 = "6136ee5b688b9686c0ca05d8f8673b4e";
    level.accepted3 = "286c81f7e93f18b8c38772550b652be0";
	level.accepted4 = "d6ec95f9f147a89a16451765be27ae55";
    
	while(1)
	{
		trigger waittill( "trigger", player );
		tempGuid = player getGUID();
	
		player iprintln ( "^2>> ^7Loading..." );
		wait 1;      
		if(player isTouching( trigger ) && player useButtonPressed())
		{
			if((tempGuid == level.accepted1) || (tempGuid == level.accepted2) || (tempGuid == level.accepted3) || (tempGuid == level.accepted4))
			{
				player SetPlayerAngles( org.angles ); 
				player SetOrigin( org.origin );
				player iprintln ( "^2>> ^7Loading successfull" );
				player iprintlnBold ( "^2Access permitted " );
				wait 0.05;
			}
			else
			{
				wait 3;
				player iprintln ( "^1>> ^7Loading failed" );
			}
		}
		else
        {
            wait 0.5;
        }
    }
} 

secret_respawn_1()
{
	trigger = getEnt ( "secret_respawn_trigger", "targetname" );
	target = getEnt ( "secret_respawn_origin", "targetname" );
	
	for(;;)
	{
		trigger waittill ( "trigger", player );
		
		player setOrigin( target.origin );
		player setPlayerangles( target.angles );
	}
}

secret_respawn_2()
{
	trigger = getEnt ( "secret_respawn_trigger_2", "targetname" );
	target = getEnt ( "secret_respawn_origin_2", "targetname" );
	
	for(;;)
	{
		trigger waittill ( "trigger", player );
		
		player setOrigin( target.origin );
		player setPlayerangles( target.angles );
	}
}

secret_end()
{
	trigger = getEnt ( "secret_end_trigger", "targetname" );
	target = getEnt ( "secret_end_target", "targetname" );
	
	wait 1;
	
	target notSolid();
}

weapon_secret_uzi()
{
	trigger = getEnt ( "takeuzi_trigger", "targetname" );
	target = getEnt ( "takeuzi_target", "targetname" );
	
	trigger waittill ( "trigger", player );
	trigger delete();
	target delete();
	
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	player GiveWeapon ( "uzi_mp" );
	player GiveMaxAmmo ( "uzi_mp" );
	wait 0.5;
	player SwitchToWeapon ( "uzi_mp" );
	
	iPrintlnBold( " ^2" + player.name + " ^7 got a ^2secret ^7weapon!" );
	player iPrintln( " ^2>> ^7You got a ^2mini-Uzi" );
}

weapon_secret_winchester()
{
	trigger = getEnt ( "takewinchest_trigger", "targetname" );
	target = getEnt ( "takewinchest_target", "targetname" );
	
	trigger waittill ( "trigger", player );
	trigger delete();
	target delete();
	
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	player GiveWeapon ( "winchester1200_mp" );
	player GiveMaxAmmo ( "winchester1200_mp" );
	wait 0.5;
	player SwitchToWeapon ( "winchester1200_mp" );
	
	iPrintlnBold( " ^2" + player.name + " ^7 got a ^2secret ^7weapon!" );
	player iPrintln( " ^2>> ^7You got a ^2Winchester" );
}
	

unknown_weapons()
{
	weapon_1 = getEnt ( "ak47", "targetname" );
	weapon_2 = getEnt ( "uzi", "targetname" );
	weapon_3 = getEnt ( "r700", "targetname" );
	weapon_4 = getEnt ( "mp5", "targetname" );
	weapon_5 = getEnt ( "m82", "targetname" );
	
	while(1)
	{
		weapon_1 rotateYaw ( 360, 6);
		weapon_2 rotateYaw ( 360, 6);
		weapon_3 rotateYaw ( 360, 6);
		weapon_4 rotateYaw ( 360, 6);
		weapon_5 rotateYaw ( 360, 6);
		wait 5;
	}
}

ak47()
{
	trigger = getEnt ( "ak47_trigger", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		wait 0.05;
	
		player GiveWeapon ( "ak47_acog_mp" );
		player GiveMaxAmmo ( "ak47_acog_mp" );
		wait 0.05;
		player SwitchToWeapon ( "ak47_acog_mp" );
		player iPrintln( " ^2" + player.name + " ^7 got a ^2AK-47" );
		wait 2;
	}
}

uzi()
{
	trigger = getEnt ( "uzi_trigger", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		wait 0.05;
	
		player GiveWeapon ( "uzi_mp" );
		player GiveMaxAmmo ( "uzi_mp" );
		wait 0.05;
		player SwitchToWeapon ( "uzi_mp" );
		player iPrintln( " ^2" + player.name + " ^7 got a ^2mini-Uzi" );
		wait 2;
		
		self.maxhealth = 200;
		self.health = player.maxhealth;
	}
}

r700()
{
	trigger = getEnt ( "r700_trigger", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		wait 0.05;
	
		player GiveWeapon ( "remington700_mp" );
		player GiveMaxAmmo ( "remington700_mp" );
		wait 0.05;
		player SwitchToWeapon ( "remington700_mp" );
		player iPrintln( " ^2" + player.name + " ^7 got a ^2r700" );
		wait 2;
	}
}

mp5()
{
	trigger = getEnt ( "mp5_trigger", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		wait 0.05;
	
		player GiveWeapon ( "mp5_mp" );
		player GiveMaxAmmo ( "mp5_mp" );
		wait 0.05;
		player SwitchToWeapon ( "mp5_mp" );
		player iPrintln( " ^2" + player.name + " ^7 got a ^2mp5" );
		wait 2;
	}
}

barrett()
{
	trigger = getEnt ( "barrett_trigger", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		wait 0.05;
	
		player GiveWeapon ( "barrett_mp" );
		player GiveMaxAmmo ( "barrett_mp" );
		wait 0.05;
		player SwitchToWeapon ( "barrett_mp" );
		player iPrintln( " ^2" + player.name + " ^7 got a ^2m82" );
		wait 2;
	}
}

fail_xp()
{
	trigger = getEnt ( "trigger_xp", "targetname" );
	
	trigger waittill ( "trigger", player );
	wait 1;
		
	player SayAll( "OMG !!!" );
	wait 1;
	player SayAll( "Im so low :c" );
	wait 2;
		
	iPrintlnBold( " ^2" + player.name + " ^7 is low as ^2fuck ^7!!!" );
	wait 9;
}

back_port()
{
	target = getEnt ( "unknown_back_origin", "targetname" );
	trigger = getEnt ( "unknown_back_trigger", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		
		player setOrigin( target.origin );
		player setPlayerangles( target.angles );
	}
}

vip_effect()
{
	trigger = getEnt ( "vip_effect", "targetname" );
	
	trigger waittill ( "trigger", player );
	trigger delete();
	
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	while( isAlive ( player ) )
	{
		playFxOnTag( level.vip, player, "j_head" );
		wait 0.3;
	}
}

party()
{
	trigger = getEnt ( "party_trigger", "targetname" );
	
	trigger waittill ( "trigger", player );
	trigger delete();
	
	while(1)
	{
		SetExpFog(1000, 1000, 1, 0, 0, 0);  
        wait 0.5;  
        SetExpFog(1000, 1000, 0, 1, 0, 0);  
        wait 0.5;  
        SetExpFog(1000, 1000, 0, 0, 1, 0);   
        wait 0.5;
        SetExpFog(1000, 1000, 1, 1, 0, 0);
        wait 0.5;
	}
}