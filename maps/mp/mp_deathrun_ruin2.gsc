/*
------------------------------------------------------------------------------
##############################################################################
##|       |##\  \####/  /##|        |##|        |##|        |##|   \####|  |##
##|   _   |###\  \##/  /###|  ______|##|   __   |##|   __   |##|    \###|  |##
##|  |_|  |####\  \/  /####|  |########|  |  |  |##|  |  |  |##|  \  \##|  |##
##|       |#####\    /#####|  |########|  |  |  |##|  |  |  |##|  |\  \#|  |##
##|       |######|  |######|  |########|  |  |  |##|  |  |  |##|  |#\  \|  |##
##|  |\  \#######|  |######|  |########|  |__|  |##|  |__|  |##|  |##\  |  |##
##|  |#\  \######|  |######|        |##|        |##|        |##|  |###\    |##
##|__|##\__\#####|__|######|________|##|________|##|________|##|__|####\___|##
##############################################################################
------------------------------------------------------------------------------
	Please give me credits for using this in your map/mod.
------------------------------------------------------------------------------
*/

main()
{
trigger = spawn("trigger_radius", (9329.7, 380.853, 128.125), 0, 255, 140);
trigger.targetname = "endmap_trig";
trigger.radius = 255;
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	thread maps\mp\_battlecast::init();
	level._effect["snowfx_mountain"] = LoadFX("deathrun/snowfx_mountain");
	level._effect["ambient_fire_med"] = LoadFX("fire/firelp_med_pm");
	level._effect["blue_fire"] = LoadFX("deathrun/blue_fire");
	level._effect["lightning_small"] = LoadFX("deathrun/lightning_small");
	level._effect["magicorbs"] = LoadFX("deathrun/magic_orbs");
	level._effect["big_laser"] = LoadFX("deathrun/blue_laser");
	level._effect["teleportfx_blue"] = LoadFX("deathrun/teleportfx_blue");
	level._effect["teleportfx_red"] = LoadFX("deathrun/teleportfx_red");
	level._effect["dragonfire"] = LoadFX("deathrun/fire_thrower");
	level._effect["magicfire"] = LoadFX("deathrun/magicfire");
	level._effect["fire_blue"] = LoadFX("deathrun/fire_blue");
	level.fire_impact = LoadFX("deathrun/fire_impact");
	level.waterfall = LoadFX("deathrun/waterfall_slow_long");
	level.waterfall_end = LoadFX("deathrun/waterfall_end");
	level.gateopen_dust_small = LoadFX("deathrun/gateopen_dust_small");
	level.gateopen_dust_large = LoadFX("deathrun/gateopen_dust_large");
	level.smash_blood = LoadFX("deathrun/body_smash");
	level.lightning = LoadFX("deathrun/lightning");
	level.fire_thrower = LoadFX("deathrun/fire_thrower_blue");
	level.watersplash_big = LoadFX("misc/watersplash_large");
	level.watersplash_player = LoadFX("deathrun/watersplash_player");
	level.skull_glow = LoadFX("deathrun/skull_eyeglow");
	level.skull_explosion = LoadFX("deathrun/skull_explosion");
	level.skeleton_dust = LoadFX("deathrun/skeleton_dust");
	level.laser_deathfx = LoadFX("deathrun/deathfx");
	level.mine_explosion = LoadFX("deathrun/stonemine_explosion");
	
	level.finalfight2_fireball_impact = LoadFX("masseffect/fire_impact");
	level.finalfight2_fireball_incomming = LoadFX("masseffect/fire_incomming");
	level.finalfight2_orb = LoadFX("masseffect/orb_center");
	level.finalfight2_orb_explosion = LoadFX("masseffect/orb_explosion");

	PrecacheItem("plasma_mp");
	PrecacheModel("projectile_at4");
	PrecacheShellShock("frag_grenade_mp");
	
	level.secret_found = false;
	level.maxfallheight = getDvarInt("bg_falldamagemaxheight");
	level.minfallheight = getDvarInt("bg_falldamageminheight");
	
	thread way_connect();
	thread CreateFXs();
	thread WatchGame();
	// thread GetTrapTriggers();
	// thread DoAllah();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


CreateFXs()
{
	SetExpFog( 1500, 2500, 0.9, 0.9, 0.9, 0 );

	obj = getent("ambient_snowfx_mountain", "targetname");
	weatherfx = maps\mp\_utility::createOneshotEffect( "snow_mountain" );
	weatherfx.v[ "origin" ] = obj.origin;
	weatherfx.v[ "angles" ] = ( 270, 0, 0 );
	weatherfx.v[ "fxid" ] = "snowfx_mountain";
	weatherfx.v[ "delay" ] = -15;
	
	fire_med = getentarray("ambient_fire_med", "targetname");
	for(i=0;i<fire_med.size;i++)
	{
		brazier_fire[i] = maps\mp\_utility::createOneshotEffect( "firelp_med_pm" );
		brazier_fire[i].v[ "origin" ] = fire_med[i].origin;
		brazier_fire[i].v[ "angles" ] = ( 270, 0, 0 );
		brazier_fire[i].v[ "fxid" ] = "ambient_fire_med";
		brazier_fire[i].v[ "delay" ] = -15;
		brazier_fire[i].v[ "soundalias" ] = "fire_metal_large";
	}
	laser = getentarray("ambient_laser_blue", "targetname");
	for(i=0;i<laser.size;i++)
	{
		laser_blue[i] = maps\mp\_utility::createOneshotEffect( "laser_blue" );
		laser_blue[i].v[ "origin" ] = laser[i].origin;
		laser_blue[i].v[ "angles" ] = laser[i].angles; //( 270, 0, 0 );
		laser_blue[i].v[ "fxid" ] = "lightning_small";
		laser_blue[i].v[ "delay" ] = -15;
	}
	blue_fire = getentarray("ambient_flying_fire_origin", "targetname");
	for(i=0;i<blue_fire.size;i++)
	{
		flying_fire[i] = maps\mp\_utility::createOneshotEffect( "blue_fire" );
		flying_fire[i].v[ "origin" ] = blue_fire[i].origin;
		flying_fire[i].v[ "angles" ] = ( 270, 0, 0 );
		flying_fire[i].v[ "fxid" ] = "blue_fire";
		flying_fire[i].v[ "delay" ] = -15;
		flying_fire[i].v[ "soundalias" ] = "fire_metal_large";
	}
	big_laser = getent("ambient_big_laser", "targetname");
	fx_biglaser = maps\mp\_utility::createOneshotEffect( "big_laser" );
	fx_biglaser.v[ "origin" ] = big_laser.origin;
	fx_biglaser.v[ "angles" ] = ( 270, 0, 0 );
	fx_biglaser.v[ "fxid" ] = "big_laser";
	fx_biglaser.v[ "delay" ] = -15;
	
	dragon = getent("ambient_dragon_fire", "targetname");
	fx_dragonfire = maps\mp\_utility::createOneshotEffect( "dragonfire" );
	fx_dragonfire.v[ "origin" ] = dragon.origin;
	fx_dragonfire.v[ "angles" ] = dragon.angles;
	fx_dragonfire.v[ "fxid" ] = "dragonfire";
	fx_dragonfire.v[ "delay" ] = -15;
	fx_dragonfire.v[ "soundalias" ] = "fire_metal_large";
	
	orbs = getent("ambient_magicorbs", "targetname");
	magicorbs = maps\mp\_utility::createOneshotEffect( "magicorbs" );
	magicorbs.v[ "origin" ] = orbs.origin;
	magicorbs.v[ "angles" ] = ( 270, 0, 0 );
	magicorbs.v[ "fxid" ] = "magicorbs";
	magicorbs.v[ "delay" ] = -15;
	
	tele_blue = getentarray("ambient_teleportfx_blue", "targetname");
	for(i=0;i<tele_blue.size;i++)
	{
		teleportfx_blue = maps\mp\_utility::createOneshotEffect( "teleportfx_blue" );
		teleportfx_blue.v[ "origin" ] = tele_blue[i].origin;
		teleportfx_blue.v[ "angles" ] = ( 270, 0, 0 );
		teleportfx_blue.v[ "fxid" ] = "teleportfx_blue";
		teleportfx_blue.v[ "delay" ] = -15;
	}
	tele_red = getentarray("ambient_teleportfx_red", "targetname");
	for(i=0;i<tele_red.size;i++)
	{
		teleportfx_red = maps\mp\_utility::createOneshotEffect( "teleportfx_red" );
		teleportfx_red.v[ "origin" ] = tele_red[i].origin;
		teleportfx_red.v[ "angles" ] = ( 270, 0, 0 );
		teleportfx_red.v[ "fxid" ] = "teleportfx_red";
		teleportfx_red.v[ "delay" ] = -15;
	}
	bfire = getentarray("secret3_bluefire", "targetname");
	for(i=0;i<bfire.size;i++)
	{
		fireblue_fx = maps\mp\_utility::createOneshotEffect( "fire_blue" );
		fireblue_fx.v[ "origin" ] = bfire[i].origin;
		fireblue_fx.v[ "angles" ] = ( 270, 0, 0 );
		fireblue_fx.v[ "fxid" ] = "fire_blue";
		fireblue_fx.v[ "delay" ] = -15;
	}
}

WatchGame()
{
	thread onConnected();
	thread WatchGate();
	thread PlaceSounds();
	thread GetWaterTriggers();
	thread GetSpikesTrigger();
	// thread GetSwimmingBlocks();
	thread WatchSkullSwitch();
	thread DoMagicStone();
	thread GetGlitchTriggers();
	thread LaserRoom();
	// thread EvilSkeleton();
	thread GetTeleporters();
	thread GetStoneMines();
	thread WatchEndGate();
	// thread FinalFight();
	// thread LastJumper();
	setDvar("bg_falldamagemaxheight", level.maxfallheight );
	setDvar("bg_falldamageminheight", level.minfallheight );
}

LastJumper()
{
	level waittill("activator", player );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		players[i].secrets_right = 0;
		players[i].secrets_false = 0;
	}
	wait 1;
	
	if( GetTeamPlayersAlive("allies") < 2 )
		return;
	
	while(1)
	{
		if( getTeamPlayersAlive("allies") < 1 || getTeamPlayersAlive("axis") < 1 )
		{
			AmbientStop(1);
			return;
		}
		if( GetTeamPlayersAlive("allies") == 1 )
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "allies" && isAlive( players[i] ) )
				{
					iprintln( players[i].name + " is the last alive jumper!");
					AmbientPlay("lastjumper");
					return;
				}
			}
		}
		wait 1;
	}
}

WatchEndGate()
{
	gate1 = getent("endgate_1", "targetname");
	gate2 = getent("endgate_2", "targetname");
	trig = getent("endgate_trigger", "targetname");
	
	wait 1;
	trig delete();
	
	gate1.endpos = gate1.origin+(0,56,0);
	gate2.endpos = gate2.origin-(0,56,0);
	
	wait 0.1;
	
	gate1 MoveY( 56, 4, 1, 1 );
	gate2 MoveY( -56, 4, 1, 1 );
	gate1 PlaySound("stonemove2");
	gate2 PlaySound("stonemove2");
	wait 4;
	gate1.origin = gate1.endpos;
	gate2.origin = gate2.endpos;
	gate1 PlaySound("stoneimpact");
	gate2 PlaySound("stoneimpact");
	
	// if( isDefined( player ) )
		// iprintlnbold( player.name + " opened the end gate...");
	// else
		// iprintlnbold("The end gate got opened by a ghost...");
}

GetStoneMines()
{
	mines = getentarray("stonemine", "targetname");
	for(i=0;i<mines.size;i++)
		mines[i] thread WatchStoneMine();
}

WatchStoneMine()
{
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( self.origin, players[i].origin ) <= 50 && isAlive( players[i] ) )
			{
				self MoveZ( 100, 0.5, 0, 0.5 );
				wait 0.5;
				PlayFX( level.mine_explosion, self.origin );
				// EarthQuake( 1, 1, self.origin, 350 );
				RadiusDamage( self.origin, 150, 300, 20, self );
				self PlaySound("explo_metal_rand");
				self delete();
				return;
			}
		}
		wait 0.1;
	}
}

GetTeleporters()
{
	tele = getentarray("teleport_trigger", "targetname");
	for(i=0;i<tele.size;i++)
		tele[i] thread DoTeleporter();
}

DoTeleporter()
{
	target = getent( self.target, "targetname");
	
	while(1)
	{
		self waittill("trigger", player );
		player SetPlayerAngles( target.angles );
		player SetOrigin( target.origin );
		// player iprintln("You got teleported!");
	}
}

EvilSkeleton()
{
	trig = getent("evil_skeleton_trigger", "targetname");
	trig waittill("trigger");
	trig delete();
	wall = getent("evil_skeleton_wall", "targetname");
	wall PlayLoopSound("stonemove_fast");
	wall MoveZ( -144, 1, 0.5, 0 );
	
	wait 1;
	wall StopLoopSound();
	
	skel = getent("evil_skeleton", "targetname");
	//x = -320
	
	skel PlaySound("scream");
	skel MoveX( -320, 1, 0.5, 0 );
	skel thread WatchEvilSkeleton();
	
	wait 1;
	
	skel notify("stop_skeleton");
	PlayFX( level.skeleton_dust, skel.origin+(64,0,0) );
	EarthQuake( 0.5, 0.5, skel.origin+(64,0,0), 400 );
	skel delete();
}

WatchEvilSkeleton()
{
	self endon("stop_skeleton");
	
	players = getentarray("player", "classname");
	
	while(1)
	{
		if( !isDefined( self ) )
			break;
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, self.origin ) <= 92 && isAlive( players[i] ) )
				players[i] ShellShock("frag_grenade_mp", 10 );
		}
		wait 0.1;
	}
}

LaserRoom()
{
	thread WatchLaserTrigger();
	stair[0] = getent("movingstair_1", "targetname");
	stair[1] = getent("movingstair_2", "targetname");
	stair[2] = getent("movingstair_3", "targetname");
	stair[3] = getent("movingstair_4", "targetname");
	stair[4] = getent("movingstair_5", "targetname");
	stair[5] = getent("movingstair_6", "targetname");
	for(i=0;i<stair.size;i++)
	{
		stair[i].oldpos = stair[i].origin;
		stair[i].origin -= (0,0,400);
	}
	
	wait 1;
	
	trig = getent("laserroom_switch_trig", "targetname");
	// trig waittill("trigger");
	swt = getent("laserroom_switch", "targetname");
	swt RotatePitch( 70, 1, 0.5, 0.5 );
	
	wait 2;
	
	for(i=0;i<stair.size;i++)
	{
		stair[i] MoveTo( stair[i].oldpos, 4, 0, 0.5 );
		stair[i] PlaySound("stonemove2");
		wait 0.2;
	}
	wait 0.5;
	wall = getent("laserroom_wall", "targetname");
	wall MoveZ( -128, 4, 1, 1 );
	wall PlaySound("stonemove2");
}

WatchLaserTrigger()
{
	trig = getent("big_laser_trigger", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player );
		player thread LaserCollide();
	}
}

LaserCollide()
{
	PlayFX( level.laser_deathfx, self GetTagOrigin("j_spinelower") );
	self suicide();
	self PlaySound("laser_collide");
	wait 0.1;
	if( isDefined( self.body ) )
		self.body delete();
}

GetSpikesTrigger()
{
	trig = getentarray("bloody_trigger", "targetname");
	for(i=0;i<trig.size;i++)
		trig[i] thread BloodyKillTrigger(1);
}

GetGlitchTriggers()
{
	trig = getentarray("glitch_trigger", "targetname");
	for(i=0;i<trig.size;i++)
		trig[i] thread WatchGlitchTrigger();
}

WatchGlitchTrigger()
{
	while(1)
	{
		self waittill("trigger", player );
		PlayFX( level.skull_explosion, player GetTagOrigin("j_spinelower") );
		player PlaySound("exp_suitcase_bomb_main");
		// EarthQuake( 1, 2, player.origin, 800 );
		player suicide();
		// iprintlnbold( player.name + " tried to glitch!");
		// player iprintlnbold("^1DONT GLITCH! GET A LIFE!");
		// logPrint( player.name + " tried to glitch! Guid: " + player GetGuid() );
	}
}

DoMagicStone()
{
	stone = getent("magicstone", "targetname");
	stone PlayLoopSound("magicstone");
	stone.oldpos = stone.origin;		//maybe smth makes the stone stucked and it doesnt move on right path
	wait 0.1;
	while(1)
	{
		stone RotateYaw( 90, 2, 0, 0 );
		stone MoveZ( -128, 2, 1, 1 );
		wait 2;
		stone RotateYaw( 90, 2, 0, 0 );
		stone MoveTo( stone.oldpos, 2, 0, 0 );
		wait 2;
	}
}

WatchSkullSwitch()
{
	trig = getent("skull_switch_trigger", "targetname");
	swt = getent("skull_switch", "targetname");
	
	wait 1;
	trig delete();
	
	swt RotatePitch( -70, 1, 1, 0 );
	wait 1;
	
	fxobj = getentarray("ambient_waterfall", "targetname");
	for(i=0;i<fxobj.size;i++)
		PlayFX( level.skull_glow, fxobj[i].origin );
	
	skull = getent("skeleton_skull", "targetname");
	skull PlaySound("skull_explode");
	
	wait 3.7;
	
	quake = 0.1;
	for(i=0;i<25;i++)
	{
		// EarthQuake( quake, 0.5, skull.origin, 3000 );
		quake += 0.03;
		wait 0.2;
	}
	PlayFX( level.skull_explosion, skull.origin-(500,0,0) );
	// EarthQuake( 1.5, 1, skull.origin, 3000 );
	skull delete();
	coll = getent("skull_collision", "targetname");
	coll delete();
	wait 2;
	thread MovingBlocks();
}

MovingBlocks()
{
	blocka = getent("moveblock_a", "targetname");
	blockb = getent("moveblock_b", "targetname");

	trig = spawn("trigger_radius",(5629,-752,-1204),0,150,150);
	trig.radius = 150;

	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "red");

	ori = spawn("script_origin",(5938,6,-124));
	ori.angles = (0,360,0);

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr_tp_safe(ori);
	}

}

sr_tp_safe(ori)
{
	self setOrigin(ori.origin);
	self SetPlayerAngles(ori.angles);
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}

GetSwimmingBlocks()
{
	blocks = getentarray("swimming_block", "targetname");
	for(i=0;i<blocks.size;i++)
		blocks[i] thread WatchSwimmingBlock();
}

WatchSwimmingBlock()
{
	self.oldpos = self.origin;
	wait 0.1;
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, self.origin ) <= 40 && isAlive(players[i]) )
			{
				self MoveZ( -192, 2, 1, 1 );
				wait 3;
				self MoveTo( self.oldpos, 2, 1, 1 );
				wait 2;
				break;
			}
		}
		wait 0.1;
	}
}

GetWaterTriggers()
{
	trig = getentarray("watersplash_trigger", "targetname");
	for(i=0;i<trig.size;i++)
		trig[i] thread WatchWaterTrigger();
}

WatchWaterTrigger()
{	
	while(1)
	{
		self waittill("trigger", player );
		player suicide();
		player PlaySound("watersplash");
		PlayFX( level.watersplash_player, player.origin );
		// EarthQuake( 0.5, 0.5, player.origin, 400 );
	}
}

PlaceSounds()
{
	sound = getent("ambient_snowfx_mountain", "targetname");
	sound PlayLoopSound( "blizzard" );
}

WatchGate()
{
	left = getent("gate_left", "targetname");
	right = getent("gate_right", "targetname");
	
	trig = getent("gateopen_trigger", "targetname");
	
	wait 1;
	
	// trig waittill("trigger", who );
	trig delete();
	
	left delete();
	right delete();
	
	largedust = getent("fx_gateopen_large", "targetname");
	PlayFX( level.gateopen_dust_large, largedust.origin );
	
	wait 6;
}

onConnected()
{
	while(1)
	{
		level waittill("connected", player );
		player thread onSpawn();
		player thread GraphicSettings();
	}
}

onSpawn()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("spawned_player");
		self.secrets_right = 0;
		self.secrets_false = 0;
	}
}

GraphicSettings()
{
	//some tweaks for nice graphic :)
	self SetClientDvar( "r_specularcolorscale", "10" );
	self SetClientDvar( "r_glowTweakEnable", 1 );
	self SetClientDvar( "r_glowUseTweaks", 1 );
	self SetClientDvar( "r_glowTweakBloomCutoff", 0.65 );
	self SetClientDvar( "r_glowTweakBloomIntensity", 1 );
	self SetClientDvar( "r_specular", 1 );
	self SetClientDvar( "r_dlightLimit", 4 );		//with this you see the lights included to FX's
	self SetClientDvar( "r_distortion", 1 );
}

FinalFight()
{
	level waittill("activator", acti );
	
	trig = getent("end_trigger", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player );
		if( isDefined( level.activ ) && level.activ == player )
		{
			player iprintlnbold("^1You should not be here!");
			player suicide();
			return;
		}
		if( GetTeamPlayersAlive( "allies" ) < 2 )
		{
			x = RandomInt(2);
			if( x == 0 )
				thread DoFinalFight1( acti, player );
			else
				thread DoFinalFight2( acti, player );
			trig delete();
			return;
		}
	}
}

DoFinalFight1( acti, player )
{
	AmbientStop(3);
	MusicStop(3);
	
	VisionSetNaked( "mpIntro", 3 );
	
	acti FreezeControls(1);
	player FreezeControls(1);
	
	wait 3;
	
	SoundOnPlayers( "dum" );
	level.blackhud = NewHudElem();
	level.blackhud.horzalign = "fullscreen";
	level.blackhud.vertalign = "fullscreen";
	level.blackhud.color = (0,0,0);
	level.blackhud setShader("white", 640, 480 );
	wait 2;
	
	acti TakeAllWeapons();
	acti GiveWeapon("knife_mp");
	acti SetSpawnWeapon("knife_mp");
	player TakeAllWeapons();
	player GiveWeapon("knife_mp");
	player SetSpawnWeapon("knife_mp");
	
	tele_acti = getentarray("finalfight1_activator", "targetname");
	tele_jumper = getentarray("finalfight1_jumper", "targetname");
	x = RandomInt( tele_acti.size );
	acti SetPlayerAngles( tele_acti[x].angles );
	acti SetOrigin( tele_acti[x].origin );
	
	x = RandomInt( tele_jumper.size );
	player SetPlayerAngles( tele_jumper[x].angles );
	player SetOrigin( tele_jumper[x].origin );
	
	players = getentarray("player", "classname");
	noti = SpawnStruct();
	noti.titleText = "*|Final Fight|*";
	noti.notifyText = "Activator VS Jumper";
	noti.duration = 5;
	noti.glowcolor = (0,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 2;
	
	SoundOnPlayers( "dum" );
	level.blackhud.alpha = 0;
	
	wait 3;
	
	SoundOnPlayers( "dum" );
	level.blackhud.alpha = 1;
	
	noti = SpawnStruct();
	noti.titleText = acti.name + " VS " + player.name;
	noti.notifyText = "GET READY!";
	noti.duration = 5;
	noti.glowcolor = (0,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 2;
	
	SoundOnPlayers( "dum" );
	level.blackhud.alpha = 0;
	
	VisionSetNaked( "finalfight_mp", 3 );
	wait 3;
	
	AmbientPlay("finalfight1");
	iprintlnbold("^1F  I  G  H  T!!!");
	
	acti FreezeControls(0);
	player FreezeControls(0);
	
	acti iprintlnbold("Press ^2Attack ^7to cast the current spell!");
	acti iprintlnbold("Press ^2Grenade ^7to switch to another spell!");
	acti thread maps\mp\_battlecast::FinalFightPower();
	player iprintlnbold("Press ^2Attack ^7to cast the current spell!");
	player iprintlnbold("Press ^2Grenade ^7to switch to another spell!");
	player thread maps\mp\_battlecast::FinalFightPower();
	
	setDvar("bg_falldamagemaxheight", 2000 );
	setDvar("bg_falldamageminheight", 1500 );
}

DoFinalFight2( acti, player )
{
	AmbientStop(3);
	MusicStop(3);
	
	acti FreezeControls(1);
	player FreezeControls(1);
	
	VisionSetNaked( "mpIntro", 3 );
	
	wait 3;
	
	teleA = getent("finalfight2_activator", "targetname");
	teleJ = getent("finalfight2_jumper", "targetname");
	
	acti SetPlayerAngles( teleA.angles );
	acti SetOrigin( teleA.origin );
	acti TakeAllWeapons();
	acti GiveWeapon("knife_mp");
	acti SetSpawnWeapon("knife_mp");
	player SetPlayerAngles( teleJ.angles );
	player SetOrigin( teleJ.origin );
	player TakeAllWeapons();
	player giveWeapon("knife_mp");
	player SetSpawnWeapon("knife_mp");
	
	AmbientPlay("finalfight2");
	
	thread Effects1();
	thread Effects2();
	
	players = getentarray("player", "classname");
	noti = SpawnStruct();
	noti.titleText = "*|MASSEFFECT-FIGHT|*";
	noti.notifyText = "Activator VS Jumper";
	noti.duration = 5;
	noti.glowcolor = (0,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
	wait 5;
	
	noti = SpawnStruct();
	noti.titleText = acti.name + " VS " + player.name;
	noti.notifyText = "Everybody dance now!";
	noti.duration = 5;
	noti.glowcolor = (0,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 5;
	
	iprintlnbold("^5F  I  G  H  T !!!");
	
	acti FreezeControls(0);
	player FreezeControls(0);
	
	VisionSetNaked( "finalfight_mp", 0.5 );
}

Effects1()
{
	SetExpFog( 128, 768, 0, 0, 0, 3 );
	center = (5632,-3584,-1656);
	ang = 0;
	fire_pos = undefined;
	fireball = undefined;
	
	for(i=0;i<5;i++)
	{
		fire_pos[i] = center+AnglesToForward( (0,ang,0) )*420;
		thread CreateFireball( fire_pos[i]+(0,0,300) );
		ang += 72;
		wait 1;
	}
	wait 4;
	fireball = getentarray("fireball", "targetname");
	for(i=0;i<fireball.size;i++)
	{
		trace = BulletTrace( fireball[i].origin, fireball[i].origin-(0,0,3000), false, fireball[i] );
		fireball[i] MoveTo( fireball[i].origin-(0,0,300), 1, 1, 0 );
	}
	wait 1;
	for(i=0;i<fireball.size;i++)
	{
		EarthQuake( 1, 1, fireball[i].origin, 700 );
		PlayFX( level.finalfight2_fireball_impact, fireball[i].origin );
		PlayFX( level._effect["fire_blue"], fireball[i].origin );
		fireball[i] delete();
	}
	thread DoRandomFog();
	thread DoEarthQuaking();
}

Effects2()
{
	center = (5632,-3584,-1656);
	
	orb = Spawn("script_model", center );
	orb SetModel("tag_origin");
	wait 0.05;
	PlayFXOnTag( level.finalfight2_orb, orb, "tag_origin" );
	orb MoveZ( 500, 5, 1, 1 );
	
	wait 10;
	
	EarthQuake( 1.5, 1.5, orb.origin, 1600 );
	pos = orb.origin;
	orb delete();
	
	while(1)
	{
		PlayFX( level.finalfight2_orb_explosion, pos );
		wait 2.5;
	}
}

CreateFireball( pos )
{
	fireball = spawn("script_model", pos );
	fireball SetModel("tag_origin");
	fireball.targetname = "fireball";
	wait 0.05;
	PlayFXOnTag( level.finalfight2_fireball_incomming, fireball, "tag_origin" );
}

DoRandomFog()
{
	while(1)
	{
		time = 1+RandomInt(3);
		SetExpFog( 64+RandomInt(256), 256+RandomInt(768), RandomFloat(1), RandomFloat(1), RandomFloat(1), time );
		wait time;
	}
}

DoEarthQuaking()
{
	level endon("stop_earthquaking");
	
	while(1)
	{
		EarthQuake( 0.1, 1, self.origin, 500 );
		wait 0.5;
	}
}

SoundOnPlayers( sound )
{
	if( !isDefined( sound ) )
		return;

	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] PlayLocaLSound( sound );
}

GetTrapTriggers()
{
	level.trapTriggers[0] = getent("trigger_trap1", "targetname");
	level.trapTriggers[1] = getent("trigger_trap2", "targetname");
	level.trapTriggers[2] = getent("trigger_trap3", "targetname");
	level.trapTriggers[3] = getent("trigger_trap4", "targetname");
	level.trapTriggers[4] = getent("trigger_trap5", "targetname");
	level.trapTriggers[5] = getent("trigger_trap6", "targetname");
	level.trapTriggers[6] = getent("trigger_trap7", "targetname");
	level.trapTriggers[7] = getent("trigger_trap8", "targetname");
	level.trapTriggers[8] = getent("trigger_trap9", "targetname");
	level.trapTriggers[9] = getent("trigger_trap10", "targetname");
	level.trapTriggers[10] = getent("trigger_trap11", "targetname");
	level.trapTriggers[11] = getent("trigger_trap12", "targetname");
	
	level.trapTriggers[0] thread TrapTrigger1();
	level.trapTriggers[1] thread TrapTrigger2();
	level.trapTriggers[2] thread TrapTrigger3();
	level.trapTriggers[3] thread TrapTrigger4();
	level.trapTriggers[4] thread TrapTrigger5();
	level.trapTriggers[5] thread TrapTrigger6();
	level.trapTriggers[6] thread TrapTrigger7();
	level.trapTriggers[7] thread TrapTrigger8();
	level.trapTriggers[8] thread TrapTrigger9();
	level.trapTriggers[9] thread TrapTrigger10();
	level.trapTriggers[10] thread TrapTrigger11();
	level.trapTriggers[11] thread TrapTrigger12();
}

TrapTrigger1()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap1();
}

TrapTrigger2()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap2();
}

TrapTrigger3()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap3();
}

TrapTrigger4()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap4();
}

TrapTrigger5()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap5();
}

TrapTrigger6()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap6();
}

TrapTrigger7()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap7();
}

TrapTrigger8()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap8();
}

TrapTrigger9()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap9();
}

TrapTrigger10()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap10();
}

TrapTrigger11()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap11();
}

TrapTrigger12()
{
	while(1)
	{
		self waittill("trigger", player );
		if( level.freeRun )
		{
			player iprintlnbold("^1Stop trying to kill your team mates, asshole!");
			player suicide();
			continue;
		}
		else
		{
			self delete();
			break;
		}
	}
	DoTrap12();
}

DoTrap1()
{
	shot = getentarray("trap1", "targetname");
	for(i=0;i<shot.size;i++)
		shot[i].ntarget = GetEnt( shot[i].target, "targetname" );
	wait 0.1;

	for(i=0;i<shot.size;i++)
	{
		thread Trap1Loop( shot[i] );
		wait 0.5;
		//wait 0.2+RandomFloat(0.8);
	}
}

DoTrap2()
{
	level.trap2_smasher = false;
	
	smasher = getent("trap2", "targetname");
	damage = getent("trap2_damage", "targetname");
	damage EnableLinkTo();
	damage LinkTo( smasher );
	
	trapa = getentarray("trap2_a", "targetname");
	trapb = getentarray("trap2_b", "targetname");
	trapc = getentarray("trap2_c", "targetname");
	trapd = getentarray("trap2_d", "targetname");
	trape = getentarray("trap2_e", "targetname");
	trapf = getentarray("trap2_f", "targetname");
	
	trapa[RandomInt(trapa.size)] thread WatchColliding();
	trapb[RandomInt(trapb.size)] thread WatchColliding();
	trapc[RandomInt(trapc.size)] thread WatchColliding();
	trapd[RandomInt(trapd.size)] thread WatchColliding();
	trape[RandomInt(trape.size)] thread WatchColliding();
	trapf[RandomInt(trapf.size)] thread WatchColliding();
}

WatchColliding()
{
	self endon("touched");
	
	while(1)
	{
		if( !level.trap2_smasher )
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( Distance( self.origin, players[i].origin ) <= 40 && isAlive( players[i] ) )
				{
					level.trap2_smasher = true;
					self MoveZ( -8, 1, 0.5, 0.5 );
					wait 1;
					self MoveZ( 8, 1, 0.5, 0.5 );
					wait 1;
					thread DoTrap2Smasher();
					break;
				}
			}
		}
		else
			break;
		wait 0.05;
	}
}

DoTrap2Smasher()
{
	wait 1+RandomInt(1);
	smasher = getent("trap2", "targetname");
	oldpos = smasher.origin;
	wait 0.1;
	for(i=0;i<5;i++)
	{
		smasher MoveZ( -112, 0.5, 0.5, 0 );
		wait 0.5;
		smasher PlaySound("stoneimpact");
		PhysicsJolt( smasher.origin, 500, 300, (0.15, 0.15, 0.1) );
		EarthQuake( 1, 0.5, smasher.origin, 500 );
		smasher MoveTo( oldpos, 0.5, 0, 0.5 );
		wait 0.5;
	}
	level.trap2_smasher = false;
}

Trap1Loop( ent )
{
	while(1)
	{
		thread DoTrap1Shot( ent.origin, ent.angles );
		wait 2;
		thread DoTrap1Shot( ent.ntarget.origin, ent.ntarget.angles );
		wait 2;
	}
}

DoTrap1Shot( origin, angles )
{
	proj = Spawn("script_model", origin );
	proj SetModel("projectile_at4");
	proj.angles = angles;
	
	while(1)
	{
		target = proj.origin+AnglesToForward( proj.angles )*30;
		trace = BulletTrace( proj.origin, target, true, proj );
		proj MoveTo( target, 0.05, 0, 0 );
		if( !BulletTracePassed( proj.origin, target, true, proj ) )
		{
			wait 0.05;
			if( isDefined( trace["entity"] ) && isPlayer( trace["entity"] ) )
			{
				trace["entity"] PlaySound("bullet_impact_headshot_2");
				trace["entity"] suicide();
			}
			proj delete();
			break;
		}
		wait 0.05;
	}
}

DoTrap3()
{	
	iprintln("Trap 3 activated!");
	org = getentarray("ambient_laser_blue", "targetname");
	for(i=0;i<org.size;i++)
		org[i] thread WatchLaser();
}

WatchLaser()
{
	time = 5;
	
	while(1)
	{
		if( time > 0 )
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( Distance( players[i].origin, self.origin ) <= 200 && isAlive(players[i]) && level.activ != players[i] )
				{
					EarthQuake( 0.5, 0.5, players[i].origin, 200 );
					PlayFX( level.lightning, players[i].origin );
					players[i] PlaySound("lightning_hit");
					players[i] suicide();
					wait 0.05;
				}
			}
			time --;
		}
		else
			break;
		wait 1;
	}
}

DoTrap4()
{	
	brush = getent("trap4", "targetname");
	oldpos = brush.origin;
	wait 0.1;
	brush MoveZ( 216, 0.5, 0.5, 0 );
	brush PlayLoopSound("stonemove_fast");
	wait 0.5;
	brush StopLoopSound();
	brush PlaySound("stoneimpact");
	wait 2;
	brush MoveTo( oldpos, 4, 0.5, 0.5 );
	brush PlayLoopSound("stonemove");
	wait 5;
	brush StopLoopSound();
}

DoTrap5()
{
	fire_thrower = getentarray("trap5_a", "targetname");
	for(i=0;i<fire_thrower.size;i++)
		thread DoFireThrower( fire_thrower[i].origin, fire_thrower[i].angles );
	
	wait 1.5;
	
	fire_thrower = getentarray("trap5_b", "targetname");
	for(i=0;i<fire_thrower.size;i++)
		thread DoFireThrower( fire_thrower[i].origin, fire_thrower[i].angles );
}

DoFireThrower( pos, ang )
{
	time = 0;
	target = pos+AnglesToForward( ang )*450;
	thrower = undefined;

	while(1)
	{	
		if(!isDefined(thrower))
		{
			thrower = Spawn("script_model", pos );
			thrower SetModel("tag_origin");
		}
		wait 0.05;
		PlayFXOnTag( level.fire_thrower, thrower, "tag_origin" );
		thrower PlaySound("firethrower");
		wait 0.01;
		thrower.angles = ang;
		time = 15;
		while(1)
		{
			trace = BulletTrace( pos, target, true, undefined );
			if( isDefined(trace["entity"]) && isPlayer(trace["entity"]) )
				trace["entity"] suicide();
			time --;
			if( time <= 0 )
				break;
			wait 0.1;
		}
		thrower delete();
		wait 1.5;
	}
}

DoTrap6()
{
	spikes = getent("trap6_spike", "targetname");
	trig = getent("trap6_trig", "targetname");
	wait 0.1;
	trig EnableLinkTo();
	trig LinkTo( spikes );
	trig thread BloodyKillTrigger(2);
	
	spikes PlaySound("spikes");
	spikes.oldpos = spikes.origin;
	wait 0.1;
	spikes MoveZ( 160, 0.5, 0.5, 0 );
	PhysicsJolt( spikes.origin, 300, 300, (0, 0, 0.5) );
	wait 1;
	spikes MoveTo( spikes.oldpos, 1, 1, 0 );
	trig notify("stop_trig");
	trig delete();
}

DoTrap7()
{
	rock = getent("trap7_rock", "targetname");
	bridge = getent("trap7_bridge", "targetname");
	
	trace = BulletTrace( rock.origin, rock.origin-(0,0,2000), false, rock );
	flyTime = Distance( rock.origin, trace["position"] ) / 1500;
	rock MoveTo( trace["position"], flyTime, flytime, 0 );
	
	wait flyTime;
	
	bridge PlaySound("bridge_breakdown");
	//368, 144
	bridge MoveZ( -388, 2, 1.9, 0.1 );
	rock MoveZ( -388, 2, 1.9, 0.1 );
	wait 2;
	PlayFX( level.watersplash_big, bridge.origin );
	bridge PlaySound("watersplash");
	bridge NotSolid();
	bridge MoveZ( -160, 8, 1, 0 );
	rock MoveZ( -160, 8, 1, 0 );
}

DoTrap8()
{
	walla = getent("trap8_a", "targetname");
	wallb = getent("trap8_b", "targetname");
	
	walla.oldpos = walla.origin;
	wallb.oldpos = wallb.origin;
	
	wait 0.1;
	
	trig = getent("trap8_trigger", "targetname");
	walla PlayLoopSound("stonemove_fast");
	wallb PlayLoopSound("stonemove_fast");
	walla MoveZ( 96, 0.5, 0.5, 0 );
	wallb MoveZ( 96, 0.5, 0.5, 0 );
	wait 0.5;
	walla MoveX( 64, 0.5, 0.5, 0 );
	wallb MoveX( -64, 0.5, 0.5, 0 );
	wait 0.4;
	trig thread BloodyKillTrigger(2);
	wait 0.1;
	walla StopLoopSound();
	wallb StopLoopSound();
	walla PlaySound("stoneimpact");
	wallb PlaySound("stoneimpact");
	wait 0.5;
	trig notify("stop_trig");
	trig delete();
	wait 0.5;
	walla PlaySound("stonemove");
	wallb PlaySound("stonemove");
	walla MoveTo( walla.oldpos, 3, 1.5, 1.5 );
	wallb MoveTo( wallb.oldpos, 3, 1.5, 1.5 );
}

DoTrap9()
{
	brush = getent("trap9", "targetname");
	brush RotateRoll( 1800, 4, 0.5, 0.5 );
}

DoTrap10()
{
	blades = getentarray("trap10_blades", "targetname");
	trig = getent("trap10_trigger", "targetname");
	clip = getent("trap10_clip", "targetname");
	
	trig EnableLinkTo();
	trig LinkTo( blades[RandomInt(blades.size)] );
	trig thread BloodyKillTrigger(3);
	clip LinkTo( blades[RandomInt(blades.size)] );
	
	for(i=0;i<blades.size;i++)
	{
		blades[i].oldpos = blades[i].origin;
		wait 0.05;
		blades[i] MoveZ( -128, 0.5, 0.5, 0 );
	}
	wait 0.5;
	blades[RandomInt(blades.size)] PlaySound("ironimpact");
	blades[RandomInt(blades.size)] PlaySound("ironimpact");
	wait 0.1;
	trig notify("stop_trig");
	trig delete();
	wait 1;
	
	for(i=0;i<blades.size;i++)
		blades[i] MoveTo( blades[i].oldpos, 2, 0.5, 0.5 );
}

DoTrap11()
{
	spikes = getent("trap11_spikes", "targetname");
	trig = getent("trap11_trigger", "targetname");
	
	trig thread BloodyKillTrigger( 2 );
	trig EnableLinkTo();
	trig LinkTo( spikes );
	
	spikes MoveZ( -192, 0.5, 0.5, 0 );
	spikes PlaySound("spikes");
	wait 0.5;
	spikes PlaySound("ironimpact");
	trig notify("stop_trig");
	trig delete();
	wait 0.5;
	spikes MoveZ( 192, 1, 0.5, 0.5 );
}

DoTrap12()
{
	smasher = getent("trap12_smasher", "targetname");
	trig = getent("trap12_trigger", "targetname");
	
	trig thread BloodyKillTrigger( 2 );
	trig EnableLinkTo();
	trig LinkTo( smasher );
	
	smasher.oldpos = smasher.origin;
	wait 0.1;
	smasher MoveZ( -256, 0.5, 0.5, 0 );
	smasher PlaySound("stonemove_fast");
	wait 0.5;
	smasher PlaySound("stoneimpact");
	trig notify("stop_trig");
	trig delete();
	smasher MoveTo( smasher.oldpos, 4, 0.5, 0.5 );
	smasher PlaySound("stonemove2");
}

BloodyKillTrigger( count )
{
	self endon("stop_trig");
	
	if( !isDefined( count ) || count < 1 )
		count = 1;
	
	while(1)
	{
		self waittill("trigger", player );
		for(i=0;i<count;i++)
			PlayFX( level.smash_blood, player GetTagOrigin("j_spinelower") );
		player suicide();
	}
}

DoAllah()
{
	thread Allah1();
	thread Allah2();
	thread Allah3();
}

Allah1()
{
	trig = getent("secret1_starttrigger", "targetname");
	trig waittill("trigger", player );
	trig delete();
	
	player iprintlnbold("Find the right switch...");
	
	trig2 = getent("secret1_switch2_trigger", "targetname");
	trig2 thread WatchAllahTrigger( false, "secret1_switch2_trigger" );
	
	trig = getent("secret1_switch1_trigger", "targetname");
	trig waittill("trigger", player );
	trig delete();
	player iprintlnBold("This probably was a good choice...");
	player.secrets_right++;
	
	if( isDefined( trig2 ) )
		trig2 delete();
	
	swt = getent("secret1_switch1", "targetname");
	swt MoveX( 8, 1, 0.5, 0.5 );
	wait 1;
	swt MoveX( -8, 1, 0.5, 0.5 );
}

Allah2()
{
	trig = getent("secret2_start_trigger", "targetname");
	trig waittill("trigger", player );
	trig delete();
	
	obj = getentarray("secret2_fire_origin", "targetname");
	for(i=0;i<obj.size;i++)
		PlayFX( level._effect["magicfire"], obj[i].origin );
	
	player iprintlnbold("Which could be the right brazier?");
	
	no1 = getent("secret2_no1", "targetname");
	no2 = getent("secret2_no2", "targetname");
	no3 = getent("secret2_no3", "targetname");
	no4 = getent("secret2_no4", "targetname");
	wait 0.1;
	no1 thread WatchAllahTrigger( false, "allah2" );
	no2 thread WatchAllahTrigger( false, "allah2" );
	no3 thread WatchAllahTrigger( true, "allah2" );
	no4 thread WatchAllahTrigger( false, "allah2" );
}

Allah3()
{
	open = getent("secret3_opentrigger", "targetname");
	open waittill("trigger", player );
	
	if( !level.secret_found )
		player iprintlnbold("You pressed a button...");
	else
	{
		player iprintlnbold("The button kinda doesnt work...");
		return;
	}
	
	entrance = getent("secret3_entrance", "targetname");
	entrance NotSolid();
	
	start = getent("secret3_starttrigger", "targetname");
	start waittill("trigger", player );
	start delete();
	
	player iprintlnbold("Mother is watching you from down...");
	player iprintlnbold("Find her, and maybe you will get the perfection...");
	
	swt = getent("secret3_stair_trigger", "targetname");
	swt waittill("trigger", player );
	swt delete();
	
	player iprintlnbold("You opened the way to mother...");
	player iprintlnbold("Now find her!");
	
	for(i=0;i<8;i++)
	{
		stair = getent("secret3_stair"+(i+1), "targetname");
		stair MoveZ( -24*(i+1), 1*(i+1), 1*(i+1), 0 );
	}
	
	trig = getent("secret3_mother", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player );
		if( player.secrets_false > 0 )
		{
			PlayFX( level.fire_impact, self GetTagOrigin("j_spinelower") );
			EarthQuake( 1, 1, self.origin, 500 );
			player iprintlnbold("^1MOTHER CANT NEED YOU USELESS FRAGMENT!");
			player suicide();
		}
		else
		{
			if( player.secrets_right == 2 )
			{
				PlayFX( level.fire_impact, self GetTagOrigin("j_spinelower") );
				EarthQuake( 1, 1, self.origin, 500 );
				player iprintlnbold("Mother is well pleased with you!");
				player iprintlnbold("She gave you the ^1PERFECTION!");
				player thread maps\mp\_battlecast::SuperJumping( 1 );
				player SetMoveSpeedScale( 1.4 );
				player.maxhealth += 50;
				player.health = player.maxhealth;
				player GiveWeapon("plasma_mp");
				player GiveMaxAmmo("plasma_mp");
				wait 0.05;
				player SwitchToWeapon("plasma_mp");
				player iprintlnbold("^1Be carefull with this! It can be dangerous to yourself too!");
//				if( player.pers["rankxp"] < 50000 )
//					player brax\_rank::giveRankXp( "bonus", 1000 );
				level.secret_found = true;
				return;
			}
		}
	}
}

WatchAllahTrigger( result, targetname )
{
	self.targetname = targetname;
	self waittill("trigger", player );
	self delete();
	
	player iprintlnbold("This probably was a good choice...");
	
	if( result )
		player.secrets_right++;
	else
		player.secrets_false++;
	
	trigs = getentarray( targetname, "targetname");
	for(i=0;i<trigs.size;i++)
		trigs[i] delete();
}

/*
##############################################################################
##|       |##\  \####/  /##|        |##|        |##|        |##|   \####|  |##
##|   _   |###\  \##/  /###|  ______|##|   __   |##|   __   |##|    \###|  |##
##|  |_|  |####\  \/  /####|  |########|  |  |  |##|  |  |  |##|  \  \##|  |##
##|       |#####\    /#####|  |########|  |  |  |##|  |  |  |##|  |\  \#|  |##
##|       |######|  |######|  |########|  |  |  |##|  |  |  |##|  |#\  \|  |##
##|  |\  \#######|  |######|  |########|  |__|  |##|  |__|  |##|  |##\  |  |##
##|  |#\  \######|  |######|        |##|        |##|        |##|  |###\    |##
##|__|##\__\#####|__|######|________|##|________|##|________|##|__|####\___|##
##############################################################################
*/