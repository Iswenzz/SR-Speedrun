#include common_scripts\utility;

main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
	setDvar( "bg_fallDamageMaxHeight", 99999 );
	setDvar( "bg_fallDamageMinHeight", 99998 );
    
	thread sr\api\_speedrun::cj();///so secret can be finished///
	thread sr\api\_map::createSpawn((-281, -285, -137), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret");

	thread custom_tp();
	thread easy_sec_enter();
	thread hard_sec_enter();
	thread easy_sec_finish();
	thread hard_sec_finish();
	thread secret_fail_1();
	thread secret_fail_2();
	
	thread init();
	//thread preCache();
}
custom_tp()
{
	trig = spawn("trigger_radius",(-753.998, 4781.64, -423.955), 0, 100, 120);
	trig.radius = 100;
	
	ori_t = spawn("script_origin",(-2774,4783,-375));
	ori_t.angles = (0,180,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}

easy_sec_enter()
{
	trig = spawn("trigger_radius",(-124.172, -276.895, -196.812), 0,60, 120);
	trig.radius = 60;
	ori_t = getEnt("easy_spawn1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
easy_sec_finish()
{
   trig = getent("trig_easy_end", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
hard_sec_enter()
{
	trig = spawn("trigger_radius",(-428.093, -276.895, -196.812), 0,60, 120);
	trig.radius = 60;
	ori_t = getEnt("hard_spawn1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
hard_sec_finish()
{
   trig = getent("trig_hard_end", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_1");
    }
}
secret_fail_1()
{
   trig = getent("trig_easy_respawn", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

	player Suicide();
    }
}
secret_fail_2()
{
   trig = getent("trig_hard_respawn", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

	player Suicide();
    }
}

preCache()
{
	level._effect[ "smoke" ] = loadfx( "sailormoon/sailormoon_smoke" );
	level._effect[ "bomb" ] = loadfx( "sailormoon/sailor_bomb" );
	level._effect[ "emb" ] = loadfx( "sailormoon/sailor_emb" );
	
	//preCacheItem( "remington700_mp" );
	preCacheItem( "rpg_mp" );
	preCacheItem( "moonkaleidoscope_mp" );
	preCacheItem( "axe_pink_mp" );
	preCacheItem( "pink_raygun_mp" );
	preCacheItem( "sailormoonTomahawk_mp" );
	preCacheModel( "character_sailormoon" );
	preCacheModel( "plr_terry_lynx" );
	preCacheModel( "plr_terry_tron" );
	preCacheMenu( "vip_sailormoon" );
}

init()
{
	//thread zigzag();
	//thread endmap();
	//thread credits();
	//thread movePlat();
	//thread playerSetup();
	//thread secret();
	//thread traps();
	//thread acti_teleports();
	//thread acti_model();
	//thread room_setup();
	//level waittill("round_started");
	thread startdoor();
	//thread music();
	//thread vip();
}

playerSetup() 
{	
	for(;;) 
	{
		level waittill( "player_spawn", player );
		
		player detachAll();
		player setModel( "plr_terry_lynx" );
		player thread slide();
	}
}

credits()
{
	while(1){
		wait 20;
		iprintln("^1 Map Made by ^7FNRP-Muffinator");
		wait 4;
		iPrintln( "^6Big Thanks to Braxi for creating this beautiful mod^5!! ^6<3" );
		wait 4;
		iPrintln( "^5Thanks to all mappers who inspired me to map^6!" );
		wait 4;
		iPrintln( "^6Thank you ^5blu ^6:** for scripting, models" );
	}
}

acti_model()
{
	trig = getEnt( "trig_acti_spawn", "targetname" );
	
	for(;;)
	{
		trig waittill( "trigger", player );
		
		if( player == level.activ )
		{
			wait 1;
			player detachAll();
			player setModel( "character_sailormoon" );
		
			break;
		}
	}
}

vip()
{
	trig = getEnt( "trig_vip", "targetname" );
	trig setHintString("Press [^6&&1^7] ^7For ^6VIP");
	
	for(;;)
	{
		trig waittill( "trigger", player );
		guid = player getGuid();
		
		if( guid == "2310346613241551196" || guid == "2310346614834966617" )
		{
			if( guid == "2310346614834966617" )
			{
				player detachAll();
				player setModel( "character_sailormoon" );
			}
			else if( guid == "2310346613241551196" )
			{
				player detachAll();
				player setModel( "plr_terry_tron" );
			}
			player openMenu( "vip_sailormoon" );
			player thread onMenuResponse();
		}
		else
		{
			player iPrintln( "^6Maybe in another life" );
		}
	}
}

onMenuResponse()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "menuresponse", menu, response );
		
		if( menu == "vip_sailormoon" )
		{
			switch( response )
			{
				case "life": self braxi\_mod::givelife();break;
				case "music": thread vipMusic(); break;
			}
		}
	}
}

music()
{	
	song = "song" + ( randomInt(3) + 1 );
	ambientPlay( song );
}

vipMusic()
{
	song = "vip" + ( randomInt(4) + 1 );
	ambientPlay( song );
}

startdoor()
{
	door = getEnt( "startdoor", "targetname" );
	
	
	wait 0.1;
	
	door delete();
}

traps()
{
	thread setupTrapTrigger( "trig_trap1", ::trap1 );
	thread setupTrapTrigger( "trig_trap2", ::trap2 );
	thread setupTrapTrigger( "trig_trap3", ::trap3 );
	thread setupTrapTrigger( "trig_trap4", ::trap4 );
	thread setupTrapTrigger( "trig_trap5", ::trap5 );
	thread setupTrapTrigger( "trig_trap6", ::trap6 );
	thread setupTrapTrigger( "trig_trap7", ::trap7 );
	thread setupTrapTrigger( "trig_trap8", ::trap8 );
	thread setupTrapTrigger( "trig_trap9", ::trap9 );
	thread setupTrapTrigger( "trig_trap10", ::trap10 );
	thread setupTrapTrigger( "trig_trap11", ::trap11 );
}

setupTrapTrigger( name, func )
{
    if( !isDefined( level.trapTriggers ) )
		level.trapTriggers=[];
	
	trig = getEnt( name, "targetname" );
	o = trig.origin;
	
    level.trapTriggers[level.trapTriggers.size] = trig;
	
	trig waittill( "trigger", player );
	trig delete();
	playFX( level._effect[ "emb" ], o );
	
	[[ func ]]();
}

zigzag()
{
	spawns = [];
	o = [];
	
	for( i = 0; i < 5; i++ )
	{
		spawns[i] = getEnt( "trap7_" + (i+1), "targetname" );
		o[i] = spawns[i].origin;
	}
	
	trig = getEntArray( "trig_smoke", "targetname" );
	
	for( i = 0; i < trig.size; i++ )
		zigzag_smoke( trig[i], o[i] );
	
}

zigzag_smoke( trig, spawn )
{
	trig waittill( "trigger", player );
	
	playFX( level._effect[ "smoke" ], spawn );
}

trap1()
{
	trap = [];
	
	for( i = 0; i < 2; i++ )
		trap[i] = getEnt( "trap1_" + (i+1), "targetname" );
	
	x = randomInt( 2 );
	d = 5000;
	t = 1;
	
	trap[x] moveZ( -1 * d, t );
	trap[x] waittill( "movedone" );
	wait 5;
	trap[x] moveZ( d, t );
}

trap2()
{	
	trap = [];
	
	for( i = 0; i < 6; i++ )
		trap[i] = getEnt( "trap2_" + (i+1), "targetname" );
	
	for( i = 0; i < trap.size; i++ )
		trap[i] notsolid();
	
	x = randomInt( 3 );
	
	trap[x] solid();
	trap[ ( 3 + ( int( x / 2 ) ) ) + randomInt( 2 + ( x % 2 ) ) ] solid();	
}

trap3()
{
	trap = getEnt( "trap3_1", "targetname" );
	
	for(;;)
	{
		trap rotatePitch( 720, 1.5 );
		trap waittill( "rotatedone" );
		wait 2;
	}
}

trap4()
{
	trap = [];
	
	for( i = 0; i < 2; i++ )
		trap[i] = getEnt( "trap4_" + (i+1), "targetname" );
	
	x = randomInt( 2 );
	
	trap[x] delete();
}

trap5()
{
	trap = getEnt( "trap5_1", "targetname" );
	
	trap delete();
}

trap6()
{
	trap = [];
	
	for( i = 0; i < 3; i++ )
		trap[i] = getEnt( "trap6_" + (i+1), "targetname" );
	
	j = 0;
	
	for(;;)
	{
		j = j%3;
		trap[j] rotateRoll( 720, 3 );
		trap[j] waittill( "rotatedone" );
		j++;
	}
}

trap7()
{
	trap = [];
	
	for( i = 0; i < 4; i++ )
		trap[i] = getEnt( "trap7_" + (i+1), "targetname" );
	
	for( i = 0; i < trap.size; i++ )
	{
		playFX( level._effect[ "bomb" ], trap[i].origin );
		thread createDamage( trap[i].origin, 999, 500, 2 );
		wait 1;
	}
}

createDamage( o, dmg, range, time )
{
	while( time > 0 )
	{
		if( isDefined( level.activ ) )
			radiusDamage( o, range, dmg, dmg, level.activ );
		else
			radiusDamage( o, range, dmg, dmg );
		
		time -= 0.05;
		wait 0.05;
	}
}

trap8()
{
	trap = getEnt( "trap8_1", "targetname" );
	
	for(;;)
	{
		trap rotateRoll( 360, 2 );
		trap waittill( "rotatedone" );
		wait 2;
	}
}

trap9()
{
	trap = [];
	
	for( i = 0; i < 2; i++ )
		trap[i] = getEnt( "trap9_" + (i+1), "targetname" );
	
	d = 50;
	t = 1.2;
	j = 1;
	
	for(;;)
	{
		trap[0] moveZ( d, t );
		trap[1] moveZ( -1 * d, t );
		
		wait t;
		
		d *= ( -1 * j ) + ( j == 0 );
		j = ( j == 0 );
	}
}

trap10()
{
	trap = [];
	
	for( i = 0; i < 3; i++ )
		trap[i] = getEnt( "trap10_" + (i+1), "targetname" );
	
	j = 0;
	t = 1.5;
	
	for(;;)
	{
		for( i = 0; i < trap.size; i++ )
			trap[i] rotateRoll( 360, t );
		
		trap[0] waittill( "rotatedone" );
		wait t;
	}
	
}

trap11()
{
	trap = getEnt( "trap11_1", "targetname" );
	
	trap hide();
	trap notsolid();
	
	wait 3;
	
	trap show();
	trap solid();
}

room_setup()
{
	room = [];
	
	for( i = 0; i < 4; i++ )
		room[i] = spawnStruct();
	
	room[0].name = "Sniper";
	room[1].name = "Bounce";
	room[2].name = "Knife";
	room[3].name = "Raygun";
	
	room[0].weapons = strTok( "moonkaleidoscope_mp;", ";"  );
	room[1].weapons = strTok( "moonkaleidoscope_mp;axe_pink_mp;", ";" );
	room[2].weapons = strTok( "sailormoonTomahawk_mp;", ";" );
	room[3].weapons = strTok( "pink_raygun_mp;", ";" );
	
	room[0].triggers = strTok( "trig_sniper_room;trig_s_fail;", ";" );
	room[1].triggers = strTok( "trig_bounce_room;trig_b_fail;trig_b_wep", ";" );
	room[2].triggers = strTok( "trig_knife_room;", ";" );
	room[3].triggers = strTok( "trig_raygun_room;trig_r_fail;", ";" );
	
	room[0].spawns = strTok( "s1;s2;", ";" );
	room[1].spawns = strTok( "b1;b2;", ";" );
	room[2].spawns = strTok( "k1;k2;", ";" );
	room[3].spawns = strTok( "r1;r2;", ";" );
	
	room[0].song = "sniper";
	room[1].song = "bounce";
	room[2].song = "knife";
	room[3].song = "raygun";
	
	for( i = 0; i < room.size; i++ )
		thread room_start( room[i] );
	
}

room_start( room )
{
	trigs = [];
	spawns = [];
	
	for( i = 0; i < room.triggers.size; i++ )
		trigs[i] = getEnt( room.triggers[i], "targetname" );
	
	for( i = 0; i < room.spawns.size; i++ )
		spawns[i] = getEnt( room.spawns[i], "targetname" );
	
	if( trigs.size > 1 )
		trigs[1] thread room_respawn( spawns );
	
	if( trigs.size > 2 )
		trigs[2] thread bounce_weapon( room.weapons );
	
	for(;;)
	{
		trigs[0] waittill( "trigger", player );
		
		if( !isDefined( level.activ ) )
			continue;
			
		if( isDefined( level.qNum ) && player.qNum != level.qNum )
		{
			player iPrintlnBold( "^6Nice Try ;)" );
			wait 1;
			player setClientDvar( "ui_dvar_info", "^1You Know What You Did" );
			kick( player getEntityNumber() );
			wait 0.5;
			if( isDefined( Player ) ) player thread braxi\_common::clientcmd( "disconnect" );
			continue;
		}
		
		noti = SpawnStruct();
		noti.titleText = "^6" + player.name + " ^7Entered the ^5" + room.name + " ^7Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player teleport( spawns[0] );
		level.activ teleport( spawns[1] );
		
		player freezeControls( 1 );
		level.activ freezeControls( 1 );
		
		ambientPlay( room.song );
		
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		if( toLower( room.name ) == "raygun" )
			player thread start_jump();
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
		
		player thread room_weapons( toLower( room.name ), room.weapons );
		
		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	}
}

room_respawn( spawns )
{
	for(;;)
	{
		self waittill( "trigger", player );
		
		if( level.activ == player )
			player teleport( spawns[1] );
		else
			player teleport( spawns[0] );
	}
}

start_jump()
{
	self thread jump_height();
	level.activ thread jump_height();
	
	self waittill_any( "death", "disconnect" );
	
	level.activ notify( "jump_done" );
}

jump_height()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "jump_done" );
	
	
	
}

room_weapons( name, weapons )
{
	if( name == "bounce" )
	{
		self give_weapon( weapons[1] );
		level.activ give_weapon( weapons[1] );
	}
	else
	{
		for( i = 0; i < weapons.size; i++ )
		{
			self give_weapon( weapons[i] );
			level.activ give_weapon( weapons[i] );
		}
	}
	
	self switchToWeapon( ( self getWeaponsList() )[0] );
	level.activ switchToWeapon( ( level.activ getWeaponsList() )[0] );
	
	if( name == "knife" )
	{
		thread WatchTomahawkDamage();
		self thread tomahawk();
		level.activ thread tomahawk();
		self waittill_any( "death", "disconnect" );
		level notify( "tomahawk_done" );
	}
}

bounce_weapon( weapons )
{
	for(;;)
	{
		self waittill( "trigger", player );
		
		player takeAllWeapons();
		
		for( i = 0; i < weapons.size-1; i++ )
			player give_weapon( weapons[i] );
		
		player switchToWeapon( weapons[0] );
	}
}

give_weapon( weapon )
{
	self giveWeapon( weapon );
	self giveMaxAmmo( weapon );
}

tomahawk()
{
	self setWeaponAmmoCLip( "sailormoonTomahawk_mp", 5 );

	if( self hasWeapon( "sailormoonTomahawk_mp" ) )
		self thread RemoveTomahawk();
}

addTomahawk( count )
{
	if( !isDefined( self ) || !isPlayer( self ) || !isAlive( self ) )
		return;
	
	if( !self hasWeapon( "sailormoonTomahawk_mp" ) )
	{
		self giveWeapon( "sailormoonTomahawk_mp" );
		self setWeaponAmmoClip( "sailormoonTomahawk_mp", count );
	}
	else
		self setWeaponAmmoClip( "sailormoonTomahawk_mp", self GetWeaponAmmoClip( "sailormoonTomahawk_mp" )+count );
		
	self thread RemoveTomahawk();
}

RemoveTomahawk()	//...when empty
{
	self endon( "disconnect" );
	self endon( "death" );
	
	wait 0.1;
	
	while( self getWeaponAmmoClip( "sailormoonTomahawk_mp" ) > 1 )
	{
		self waittill( "grenade_fire", proj, weap );
		if( weap != "sailormoonTomahawk_mp" )
			continue;
		proj thread TomahawkPickUp();
	}
}

TomahawkPickUp()
{
	self endon( "death" );
	
	wait 2;
	
	oldpos = self.origin;
	while(1)		//lets check if its still moving - would be pretty stupid if you could pick it up while it is in mid air xD
	{
		wait 0.25;
		if( oldpos == self.origin )
			break;
		oldpos = self.origin;
	}
	
	players = getEntArray( "player", "classname" );
	self thread RemoveAfterTime( 5 );
	
	self.trig = spawn( "trigger_radius", self.origin, 0, 64, 128 );
	
	while(1)
	{
		self.trig waittill( "trigger", player );
		if( !player useButtonPressed() || player.doingBH )
			continue;
		player addTomahawk( 1 );
		player PlaySound( "grenade_pickup" );
		player iPrintln( "^1>> ^2You've picked up ^31 ^2tomahawk!" );
		self delete();
	}
}

RemoveAfterTime( time )
{
	if( !isDefined( time ) || !isDefined( self ) )
		return;
	wait time;
	if( isDefined( self.trig ) )
		self.trig delete();
	if( isDefined( self ) )
	{
		self notify( "death" );
		self delete();
	}
}

CreatePickupHud()
{
	if( isDefined( self.pickup_hud ) )
		return;
	
	self.pickup_hud = NewClientHudElem( self );
	self.pickup_hud.alignX = "center";
	self.pickup_hud.alignY = "middle";
	self.pickup_hud.horzalign = "center";
	self.pickup_hud.vertalign = "middle";
	self.pickup_hud.alpha = 0.75;
	self.pickup_hud.x = 0;
	self.pickup_hud.y = 60;
	self.pickup_hud.font = "default";
	self.pickup_hud.fontscale = 1.6;
	self.pickup_hud.glowalpha = 1;
	self.pickup_hud.glowcolor = (1,0,0);
	self.pickup_hud setText( "^1>> ^2Press ^1[{+activate}] ^2to pick up tomahawk!" );
}

WatchTomahawkDamage()
{
	level endon( "tomahawk_done" );

	while(1)
	{
		level waittill( "player_damage", victim, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		if( sWeapon != "sailormoonTomahawk_mp" || sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_FALLING" || victim.pers["team"] == eAttacker.pers["team"] )
			continue;
		victim FinishPlayerDamage( victim, eAttacker, 1000, iDFlags, sMeansOfDeath, "tomahawk_mp", vPoint, vDir, sHitLoc, psOffsetTime );
	}
}

secret()
{
	secret = getEnt( "secret", "targetname" );
	ladder = getEnt( "secret_ladder", "targetname" );
	
	secret hide();
	secret notsolid();
	ladder hide();
	ladder notsolid();
	
	trigs = [];
	trigs[0] = getEnt( "trig_secret1", "targetname" );
	trigs[1] = getEnt( "trig_secret4", "targetname" );
	trigs[2] = getEnt( "trig_secret5", "targetname" );
	
	for( i = 0; i < trigs.size; i++ )
		trigs[i] secret_open( i );
	
	secret show();
	secret solid();
	ladder show();
	ladder solid();
	
	thread secret_setup();
}

secret_open( n )
{
	self waittill( "trigger", player );
	
	switch( n )
	{
		case 0: iPrintlnBold( "\'^6Please stop talking about math when I'm eating.^7\'" ); break;
		case 2: self playSound( "secret" ); break;
		default: return;
	}
	
	return;
}

secret_setup()
{
	secrets = [];
	for( i = 0; i < 2; i++ )
		secrets[i] = spawnStruct();
	
	secrets[0].name = "easy";
	secrets[1].name = "hard";
	
	secrets[0].triggers = strTok( "trig_easy_enter;trig_easy_respawn;trig_easy_end;", ";" );
	secrets[1].triggers = strTok( "trig_hard_enter;trig_hard_respawn;trig_hard_end;", ";" );
	
	secrets[0].spawns = strTok( "easy_spawn1;o_easy_end;", ";" );
	secrets[1].spawns = strTok( "hard_spawn1;hard_spawn2;hard_spawn3;hard_spawn4;hard_spawn5;o_hard_end;", ";" );
	
	secrets[1].checkpoints = strTok( "trig_cp1;trig_cp2;trig_cp3;trig_cp4;", ";" );
	
	secrets[0].time = 999;
	secrets[1].time = 999;
	
	secrets[0].xp = 0;
	secrets[1].xp = 0;
	
	thread secret_start( secrets[0] );
	thread secret_start( secrets[1] );
}

secret_start( sec )
{
	thread secret_teleports( sec.triggers, sec.spawns, sec.name + "_end", sec.time ); 
	thread secret_end( sec.triggers[2], sec.spawns[sec.spawns.size-1], sec.name, sec.xp, sec.name + "_end" );
	
	if( isDefined( sec.checkpoints ) )
	{
		for( i = 0; i < sec.checkpoints.size; i++ )
			thread secret_checkpoints( sec.checkpoints[i], i );
	}
}

secret_checkpoints( cp, pos )
{
	trig = getEnt( cp, "targetname" );
	
	for(;;) 
	{
		trig waittill( "trigger", player );
	
		if ( player.checkpoint != pos+1 ) 
		{
			player.checkpoint = pos+1;
			player iPrintln( "^5Checkpoint: ^7" + player.checkpoint );
			if( player.checkpoint == 3 )
				player thread doRPG();
		}
	}
}

secret_teleports( t, o, n, time )
{
	trigs = [];
	spawns = [];
	
	for( i = 0; i < t.size-1; i++ )
		trigs[i] = getEnt( t[i], "targetname" );
	
	for( i = 0; i < o.size-1; i++ )
		spawns[i] = getEnt( o[i], "targetname" );
	
	trigs[1] thread secret_respawn( spawns );
	
	for(;;)
	{
		trigs[0] waittill( "trigger", player );
		player.checkpoint = 0;
		if( isDefined( time ) && isDefined( n ) ) player thread timer( time, n );
		player thread teleport( spawns[0] );
	}
}

secret_respawn( spawns )
{
	for(;;)
	{
		self waittill( "trigger", player );
		player thread teleport( spawns[player.checkpoint] );
	}
}

secret_end( t, o, type, xp, n )
{
	trig = t;
	tele = o;

	if( isString( t ) )
	trig = getEnt( t, "targetname" );
	
	if( isString( o ) )
		tele = getEnt( o, "targetname" );
	
	for(;;)
	{
		trig waittill( "trigger", player );
		if( isDefined( xp ) ) player braxi\_rank::giveRankXP( "", xp );
		if( isDefined( n ) )
		{
			player notify ( n );
			if( isDefined( player.secretTimer ) )
				player.secretTimer destroy();
		}
		
		player teleport( tele );
		
		if( isDefined( type ) )
		{
			if( type == "hard" )
				iPrintlnBold( "^6"+ player.name + " ^7Has Finished the ^1Hard ^7Secret^1!" );
			else
				iPrintlnBold( "^6"+ player.name + " ^7Has Finished the ^5Easy ^7Secret^5!" );
		}
	}
}

doRPG() 
{
	self endon ( "disconnect" );
    self endon ( "death" );
	
	self GiveWeapon("rpg_mp");
	self GiveMaxAmmo("rpg_mp");
	wait .05;
	self SwitchToWeapon("rpg_mp");

    while ( 1 )
    {
        currentWeapon = self getCurrentWeapon();
        if ( currentWeapon == "rpg_mp" )
        {
            self GiveMaxAmmo( currentWeapon );
        }
		
		if( self.checkpoint != 1 && self.checkpoint != 3 )
			break;

        wait 0.05;
    }
	
	self takeWeapon( "rpg_mp" );
	wait 0.5;
	self switchToWeapon( ( self getWeaponsList() )[0] );
}

acti_teleports()
{
	for( i = 1; i <= 4; i++ )
		thread setup_teleport( "trig_a" + i, "here_a" + i );
}

slide()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	plat = getEnt( "slide", "targetname" );
	
	
}

movePlat() 
{
    trig = getEnt( "trig_plat", "targetname" );
	plat = getEnt( "movingPlat", "targetname" );

    trig waittill( "trigger", player );
	
	d = 1850;
	t = 5;
	waitTime = 1;
	
	wait waitTime;
	
	for( ;; ) 
	{
		plat moveX( -1 * d, t );
		plat waittill( "movedone" );
		wait waitTime;
		plat moveX( d, t );
		plat waittill( "movedone" );
		wait waitTime;
	}
}


endmap()
{
	level.queue = [];

	trig = getEnt( "endmap_trig", "targetname" );
	o = getEnt( "endmap_here", "targetname" );
	
	for(;;)
	{
		trig waittill( "trigger", player );
		
		if( isDefined( player.ghost ) && player.ghost )
		{
			player iPrintlnBold( "^5Completed Map In Ghost", "\n", "^1Try Again!" );
			player braxi\_rank::giveRankXP( undefined, 50 );
			player suicide();
			continue;
		}
		
		if( !isDefined( player.qNum ) ) 
			player queue_add();
		
		if( level.qNum == player.qNum )
			continue;
		
		player iPrintlnBold( "^5Wait your turn" );
		player teleport( o );
	}
}

queue_add()
{
	if( !isDefined( level.qNum ) )
	{
		level.qNum = 0;
		self.qNum = level.qNum;
	}
	else
		self.qNum = level.queue.size;
	
	level.queue[level.queue.size] = self.guid;
	
	self thread queue_death();
	self thread get_place_reward( self.qNum+1 );
}

queue_death()
{
	id = self.guid;
	num = self.qNum;
	
	self waittill_any( "death", "disconnect" );
	
	self.qNum = undefined;
	
	if( level.qNum == num )
	{
		level.qNum++;
		return;
	}

	for( i = level.qNum; i < level.queue.size; i++ )
	{
		if( level.queue[i].guid == id )
		{
			level.queue = array_remove( level.queue, i );
			return;
		}
	}
}

array_remove( arr, index )
{
	temp = [];
	
	for( i = 0; i < arr.size; i++ )
	{
		if( i != index )
			temp[temp.size] = arr[i];
	}
	
	return temp;
}

get_place_reward(place)
{
	switch(place)
	{
		case 1:
			self iprintlnbold("You got 1000 XP for 1# Place");
			self braxi\_rank::giverankxp(undefined,1000);
			break;
		case 2:
			self iprintlnbold("You got 750 XP for 2# Place");
			self braxi\_rank::giverankxp(undefined,750);
			break;
		case 3:
			self iprintlnbold("You got 500 XP for 3# Place");
			self braxi\_rank::giverankxp(undefined,500);
			break;
		case 4:
			self iprintlnbold("You got 350 XP for 4# Place");
			self braxi\_rank::giverankxp(undefined,350);
			break;
		case 5:
			self iprintlnbold("You got 300 XP for 5# Place");
			self braxi\_rank::giverankxp(undefined,300);
			break;
		case 6:
			self iprintlnbold("You got 250 XP for 6# Place");
			self braxi\_rank::giverankxp(undefined,250);
			break;
		case 7:
			self iprintlnbold("You got 200 XP for 7# Place");
			self braxi\_rank::giverankxp(undefined,200);
			break;
		case 8:
			self iprintlnbold("You got 150 XP for 8# Place");
			self braxi\_rank::giverankxp(undefined,150);
			break;
		case 9:
			self iprintlnbold("You got 100 XP for 9# Place");
			self braxi\_rank::giverankxp(undefined,100);
			break;
		case 10:
			self iprintlnbold("You got 75XP for 10# Place");
			self braxi\_rank::giverankxp(undefined,75);
			break;
	}
}

timer( t, n ) //VC'Blades Timer
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if( isDefined( n ) && isString( n ) && n != "" )
		self endon( n );

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer=newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
        self.secretTimer.vertAlign = "bottom";
        self.secretTimer.x = 0;
        self.secretTimer.y = -7;
        self.secretTimer.sort = 5;
        self.secretTimer.fontScale = 1.6;
        self.secretTimer.font = "default";
        self.secretTimer.glowAlpha = 0;
        self.secretTimer.hidewheninmenu = true;
        self.secretTimer.label = &"^7Time in Secret: ^6&&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(5,6,2);
	
	self thread onDeath();

	time = 90;
	
	if( isDefined( t ) )
		time=t;
	
	for(i=0;i<time;i++)
		{
		self.secretTimer setvalue(time-i);
		wait 1;
		}
	self.secretTimer setvalue(0);
	self suicide();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();
}

onDeath()
{
	self endon( "disconnect" );
	self waittill( "death" );
	if( isDefined( self.secretTimer ) )
		self.secretTimer destroy();
}

setup_teleport( trig, spawn )
{
	t = trig;
	o = spawn;
	
	if( isString( trig ) )
		t = getEnt( trig, "targetname" );
	
	if( isString( spawn ) )
		o = getEnt( spawn, "targetname" );

	for(;;)
	{
		t waittill( "trigger", player );
		player teleport( o );
	}
}

teleport( spawn )
{
	self setOrigin( spawn.origin );
	self setPlayerAngles( spawn.angles );
	self freezeControls( 1 );
	wait 0.01;
	self freezeControls( 0 );
}