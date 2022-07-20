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

	Scripts and map made by Rycoon!
|*************************************|
	Xfire: phaedrean
*/

main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
level.masterSpawn = spawn("script_origin", level.spawn["allies"][10].origin);
level.masterSpawn.angles = level.spawn["allies"][10].angles;
level.masterSpawn placeSpawnPoint();
trigger = spawn( "trigger_radius", (409, 1538, -2820), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");
	
	level.big_light = LoadFX("deathrun_ruin/big_light");
	level.big_light_end = LoadFX("deathrun_ruin/big_light_end");
	level._effect["ambient_fire_med"] = LoadFX("fire/firelp_med_pm");
	level.fire_thrower = LoadFX("deathrun_ruin/fire_far");
	level.burn_fx = LoadFX("deathrun_ruin/burn_fx");
	level.missile["trail"] = LoadFX("smoke/smoke_geotrail_javelin");
	level.missile["explosion"] = LoadFX("explosions/ffar_explosion");
	level.finalfight_fire = LoadFX("deathrun_ruin/finalfight_fire");
	level.finalfight_embers = LoadFX("deathrun_ruin/finalfight_embers");
	level.finalfight_distortion = LoadFX("deathrun_ruin/finalfight_distortion");

	PrecacheModel("projectile_sa6_missile_desert");
	PrecacheShellShock("frag_grenade_mp");
	PrecacheShellShock("burn_mp");
	
	thread way_connect();
	thread CreateFXs();
	thread MakeTriggers();
	thread onConnected();
	// thread WatchGame();
	// thread AddTestClients();
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


onConnected()
{
	while(1)
	{
		level waittill("connected", player );
		player.isSliding = false;
		player.glitching = false;
	}
}

CreateFXs()
{
	SetExpFog( 400, 800, 0, 0, 0, 0 );
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
	
	big_light = getentarray("ambient_big_light", "targetname");
	for(i=0;i<big_light.size;i++)
		thread DoBigLightLoop( big_light[i].origin );
}

DoBigLightLoop( origin )
{
	start = origin;
	linker = undefined;
	while(1)
	{
		wait 0.1;
		linker = Spawn("script_model", start );
		linker SetModel("tag_origin");
		wait 0.05;	//we have to wait between spawning the origin and playing FX on it
		PlayFXOnTag( level.big_light, linker, "tag_origin" );
		trace = BulletTrace( start, start-(0,0,4000), false, linker );
		flyTime = Distance( start, trace["position"] ) / 100;
		linker MoveTo( trace["position"], flyTime, 0, 0 );
		wait flyTime;
		linker delete();
		PlayFX( level.big_light_end, trace["position"] );
		wait 0.1;
	}
}

MakeTriggers()
{
	wait 0.5;
	level.trapTriggers[0] = getent("trigger_stair", "targetname");
	level.trapTriggers[1] = getent("trigger_bridge_broken", "targetname");
	level.trapTriggers[2] = getent("trigger_bridge_blades", "targetname");
	level.trapTriggers[3] = getent("trigger_fire", "targetname");
	level.trapTriggers[4] = getent("trigger_traps", "targetname");
	level.trapTriggers[5] = getent("trigger_disabling_spot", "targetname");
	
	// level.trapTriggers[0] thread WatchStairs();
	// level.trapTriggers[1] thread WatchBridgeBroken();
	// level.trapTriggers[2] thread WatchBridgeBlades();
	// level.trapTriggers[3] thread WatchFire();
	// level.trapTriggers[4] thread WatchTraps();
	// level.trapTriggers[5] thread WatchDisablingSpots();

	// thread DoArtillery();
	thread WatchSliding();
	thread PlaceTeleporters();
	// thread DoWallBlades();
	
	endtrig = getEnt("endtrigger", "targetname");
	// endtrig thread WatchEndTrigger();
}

PlaceTeleporters()
{
	porters = getentarray("teleport_trigger", "targetname");
	for(i=0;i<porters.size;i++)
		porters[i] thread WatchTeleporter();
}

WatchTeleporter()
{
	target = getent( self.target, "targetname");
	
	while(1)
	{
		self waittill("trigger", who );
		if( isPlayer( who ) && isAlive(who) )
		who SetPlayerAngles( target.angles );
		who SetOrigin( target.origin );
		// who iprintln("You got teleported!");
	}
}

WatchStairs()
{
	while(1)
	{
		self waittill("trigger", who );
		if( who.pers["team"] != "axis" && level.freeRun )
		{
			who suicide();
			who iprintlnbold("^1DONT TRY TO KILL YOUR MATES! FUCK YOU!");
			continue;
		}
		thread DoStairs();
		self delete();
		break;
	}
}

WatchBridgeBroken()
{
	while(1)
	{
		self waittill("trigger", who );
		if( who.pers["team"] != "axis" && level.freeRun )
		{
			who suicide();
			who iprintlnbold("^1DONT TRY TO KILL YOUR MATES! FUCK YOU!");
			continue;
		}
		thread DoBridgeBroken();
		self delete();
		break;
	}
}

WatchBridgeBlades()
{
	while(1)
	{
		self waittill("trigger", who );
		if( who.pers["team"] != "axis" && level.freeRun )
		{
			who suicide();
			who iprintlnbold("^1DONT TRY TO KILL YOUR MATES! FUCK YOU!");
			continue;
		}
		thread DoBridgeBlades();
		self delete();
		break;
	}
}

WatchFire()
{
	while(1)
	{
		self waittill("trigger", who );
		if( who.pers["team"] != "axis" && level.freeRun )
		{
			who suicide();
			who iprintlnbold("^1DONT TRY TO KILL YOUR MATES! FUCK YOU!");
			continue;
		}
		thread PlaceFireThrower();
		self delete();
		break;
	}
}

WatchTraps()
{
	while(1)
	{
		self waittill("trigger", who );
		if( who.pers["team"] != "axis" && level.freeRun )
		{
			who suicide();
			who iprintlnbold("^1DONT TRY TO KILL YOUR MATES! FUCK YOU!");
			continue;
		}
		thread DoTraps();
		self delete();
		break;
	}
}

WatchDisablingSpots()
{
	while(1)
	{
		self waittill("trigger", who );
		if( who.pers["team"] != "axis" && level.freeRun )
		{
			who suicide();
			who iprintlnbold("^1DONT TRY TO KILL YOUR MATES! FUCK YOU!");
			continue;
		}
		spot1 = getentarray("disabling_spot1", "targetname");
		spot2 = getentarray("disabling_spot2", "targetname");
		spot1[RandomInt(spot1.size)] NotSolid();
		spot2[RandomInt(spot2.size)] NotSolid();
		self delete();
		break;
	}
}


DoTraps()
{
	trap1 = getent("trap1", "targetname");
	trap2 = getent("trap2", "targetname");
	
	x = RandomInt(2);
	if( x == 0 )
	{
		time = 1+RandomFloat(2);
		trap2 RotatePitch( 90, time, time, 0 );
		wait time;
		time = 1+RandomFloat(2);
		trap1 RotatePitch( -90, time, time, 0 );
		wait time+RandomFloat(2);
	}
	else
	{
		time = 1+RandomFloat(2);
		trap1 RotatePitch( 90, time, time, 0 );
		wait time;
		time = 1+RandomFloat(2);
		trap2 RotatePitch( -90, time, time, 0 );
		wait time+RandomFloat(2);
	}
	time = 1+RandomFloat(2);
	trap1 RotatePitch( 90, time, time, 0 );
	trap2 RotatePitch( -90, time, time, 0 );
}

DoBridgeBroken()
{
	broken = getent("bridge_broken", "targetname");
	target = broken.origin-(0,0,1500);
	
	flyTime = Distance( broken.origin, target ) / 800;
	broken MoveTo( target, flyTime, flyTime, 0 );
	wait 1.5;
	broken RotateTo( (broken.angles[0]+RandomIntRange(-40,40),broken.angles[1]+RandomIntRange(-40,40),broken.angles[2]+RandomIntRange(-40,40)), flyTime-1.5, flyTime-1.5, 0 );
	wait flyTime-1.5;
	
	while(1)
	{
		broken RotatePitch( 90, 5 );
		PlayFX( level.big_light_end, broken.origin );
		wait 5;
	}
}

PlaceFireThrower()
{
	fire_thrower = getentarray("fire_thrower", "targetname");
	for(i=0;i<fire_thrower.size;i++)
		thread DoFireThrower( fire_thrower[i].origin, fire_thrower[i].angles );
	
	wait 3;
	
	fire_thrower = getentarray("fire_thrower2", "targetname");
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
		wait 0.01;
		thrower.angles = ang;
		time = 30;
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
		wait 3;
	}
}

DoWallBlades()
{
	wall_blade_horz = getEnt("turning_blade_wall_horz", "targetname");
	wall_blade_vert = getentarray("turning_blade_wall_vert", "targetname");
	
	while(1)
	{
		wall_blade_horz RotateYaw( 360, 2 );
		wall_blade_vert[0] RotateRoll( 360, 2 );
		wall_blade_vert[1] RotateRoll( -360, 2 );
		wait 2;
	}
}

DoBridgeBlades()
{
	startEnt = getEnt("turning_blade_bridge_start", "targetname");
	endEnt = getEnt("turning_blade_bridge_end", "targetname");
	start = startEnt.origin;
	end = endEnt.origin;
	
	bridge_blade = getEnt("turning_blade_bridge", "targetname");
	wait 0.1;
	while(1)
	{
		bridge_blade RotateYaw( 2160, 4, 0, 0 );
		bridge_blade MoveTo( (end[0],end[1],bridge_blade.origin[2]), 3, 0.5, 0.5 );
		wait 3;
		bridge_blade MoveZ( -40, 1, 0.5, 0.5 );
		wait 1;
		bridge_blade RotateYaw( 2160, 4, 0, 0 );
		bridge_blade MoveTo( (start[0],start[1],bridge_blade.origin[2]), 3, 0.5, 0.5 );
		wait 3;
		bridge_blade MoveZ( 40, 1, 0.5, 0.5 );
		wait 1;
	}
}

DoArtillery()
{
	randomi = getentarray("artillery_impact", "targetname");
	while(1)
	{
		level waittill("activator", who );
		break;
	}
	wait 15;
	wall = getent("start_wall", "targetname");
	wall MoveY( 208, 1.5, 1.5, 0 );
	wait 3;
	
	for(i=0;i<15;i++)
	{
		thread DoMissile( randomi[RandomInt(randomi.size)].origin );
		wait 0.2+RandomFloat(0.5);
	}
	wait 1;
	thread WatchStartTrigger();
}

DoMissile( pos )
{
	trace = BulletTrace( pos, pos-(0,0,600), false, undefined );
	target = trace["position"];
	start = target+(0,0,800+RandomInt(400));
	
	missile = Spawn("script_model", start );
	missile SetModel("projectile_sa6_missile_desert");
	missile.angles = (90,0,0);
	missile PlaySound("fast_artillery_round");
	wait 0.5;
	PlayFXOnTag( level.missile["trail"], missile, "tag_fx" );
	
	flyTime = Distance( start, target ) / 1600;
	missile MoveTo( target, flytime, flytime, 0 );
	
	wait flyTime;
	
	PlayFX( level.missile["explosion"], target );
	EarthQuake( 1.5, 1, target, 700 );
	missile PlaySound("artillery_impact");
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( Distance( players[i].origin, target ) <= 800 )
		{
			trace = BulletTrace( trace["position"], players[i].origin, true, missile );
			if( isPlayer(trace["entity"]) )
				trace["entity"] suicide();
		}
	}
	missile delete();
}

WatchStartTrigger()
{
	trig = getent("starttrigger", "targetname");
	
	while(1)
	{
		trig waittill("trigger", who );
		if( !level.freeRun && isAlive( who ) )
		{
			who suicide();
			who iprintlnbold("Sorry, but no respawn possible. :3");
		}
	}
}

WatchSliding()
{
	startent = getent("sliding_start", "targetname");
	endent = getent("sliding_end", "targetname");
	start = startent.origin;
	end = endent.origin;
	
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( start, players[i].origin ) <= 128 && isAlive(players[i]) && players[i].pers["team"] != "axis" && !players[i].isSliding )
			{
				if( players[i] UseButtonPressed() )
				{
					players[i] thread DoSlide( start, end );
				}
			}
		}
		wait 0.05;
	}
}

DoSlide( start, end )
{
	if( !isDefined( self.linker ) )
		self.linker = Spawn("script_origin", self GetEye()+(0,0,20) );
	
	self.isSliding = true;
	self DisableWeapons();
	self LinkTo( self.linker );
	self.linker MoveTo( start, 1, 0.5, 0.5 );
	wait 1.2;
	self.linker MoveTo( end, 4, 4, 0 );
	wait 1;
	self ShellShock("frag_grenade_mp", 2.5 );
	wait 3;
	self UnLink();
	self.linker delete();
	self EnableWeapons();
	self.isSliding = false;
}

DoStairs()
{
	stairs = getentarray("stair1", "targetname");
	
	while(1)
	{
		for(i=0;i<stairs.size;i++)
			stairs[i] MoveX( -400, 2, 1, 1 );
		wait 3;
		for(i=0;i<stairs.size;i++)
			stairs[i] MoveX( 400, 2, 1, 1 );
		wait 3;
	}
}

WatchGame()
{
	level.finalfight = false;
	
	while(1)
	{
		level waittill("activator", who );
		thread GetGlitchTriggers();
		thread DoAmbient();
		who thread AntiFreeTraps();
	}
}

AntiFreeTraps()
{
	if( getDvarInt("scr_activator_freerun") != 1 )
		return;
	
	self FreezeControls(1);
	wait getDvarInt("scr_activator_freerun_wait");
	self FreezeControls(0);
}

GetGlitchTriggers()
{
	triggers = getentarray("glitch_trigger", "targetname");
	for(i=0;i<triggers.size;i++)
		triggers[i] thread WatchGlitchTrigger();
}

WatchGlitchTrigger()
{
	while(1)
	{
		self waittill("trigger", who );
		if( !level.freeRun && !who.glitching )
			who thread DoAntiGlitcher();
	}
}

DoAntiGlitcher()
{
	self.glitching = true;
	self FreezeControls(1);
	self iprintlnbold("^1HAHAHAHA! CAUGHT YOU GLITCHER! >:)");
	self PlayLocalSound("laughing");
	wait 4;
	self iprintlnbold("^3Wanna see something cool, hmm? >:)");
	self SetClientDvar("cg_thirdperson", 1 );
	wait 4;
	self iprintlnbold("^1BUUUUUUUUUUUUUUUUURN! HAHAHA!!!");
	self thread BurnPlayer();
	wait 2;
	iprintlnbold("^1LOOK! ^7" + self.name + " ^1is BURNING due to glitching!");
	iprintlnbold("^1HUAHAHAHA!");
	self SetClientDvar("cg_thirdperson", 0 );
	wait 8;
	self.glitching = false;
}

BurnPlayer()
{
	PlayFXOnTag( level.burn_fx, self, "head" );
	PlayFXOnTag( level.burn_fx, self, "neck" );
	PlayFXOnTag( level.burn_fx, self, "j_shoulder_le" );
	PlayFXOnTag( level.burn_fx, self, "j_spinelower" );
	PlayFXOnTag( level.burn_fx, self, "j_knee_ri" );
	
	for(i=0;i<5;i++)
	{
		self ShellShock("burn_mp", 2.5 );
		self PlayLocalSound("breathing_hurt");
		wait 1.4;
	}
	self suicide();
	iprintln( self.name + " ^1burned down!");
}

DoAmbient()
{
	AmbientStop(0);
	MusicStop(0);
	wait 0.1;
	allies = GetTeamPlayersAlive("allies");
	AmbientPlay("ambient"+(1+RandomInt(2)));
	thread WatchIfAllDead();
	if( allies == 1 )		//when only 1 jumper left at start then dont play last jumper music
		return;
	
	while(1)
	{
		if( getTeamPlayersAlive("allies") == 1 && !level.finalfight)
		{
			AmbientStop(1);
			MusicStop(1);
			wait 1;
			AmbientPlay("lastjumper"+(1+RandomInt(2)));
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "allies" && isAlive(players[i]) )
				{
					iprintln( players[i].name + " is the last alive jumper!");
					break;
				}
			}
			break;
		}
		wait 0.1;
	}
}

WatchIfAllDead()
{
	while(1)
	{
		if( getTeamPlayersAlive("allies") < 1 || getTeamPlayersAlive("axis") < 1 )
		{
			AmbientStop(1);
			break;
		}
		wait 0.2;
	}
}

WatchEndTrigger()
{
	level.acti_enemy = undefined;
	while(1)
	{
		self waittill("trigger", who );
		if( getTeamPlayersAlive("axis") < 1 )
			return;
		if( getTeamPlayersAlive("allies") == 1 )
		{
			thread StartFinalFight();
			self delete();
			break;
		}
		else if( getTeamPlayersAlive("allies") > 1 )
		{
			if( isDefined( level.acti_enemy ) && isAlive(level.acti_enemy) && level.acti_enemy != who )
			{
				who suicide();
				who iprintlnbold("^11 VS 1 Noob! ^2You wasnt first, get a life!");
			}
			if( !isDefined(level.acti_enemy) || !isAlive(level.acti_enemy))
			{
				level.acti_enemy = who;
				iprintlnbold( who.name + " ^1reached as first the end hall!");
				iprintlnbold("^11 VS 1 Fight!");
				acti = undefined;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
				{
					if( players[i].pers["team"] == "axis" )
					{
						acti = players[i];
						break;
					}
				}
				starta = getent("finalfight_activator", "targetname");
				acti SetPlayerAngles( starta.angles );
				acti SetOrigin( starta.origin );
			}
		}
	}
}

StartFinalFight()
{
	acti = undefined;
	jumper = undefined;
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "axis" && isAlive(players[i]) )
		{
			acti = players[i];
			break;
		}
	}
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "allies" && isAlive(players[i]) )
		{
			jumper = players[i];
			break;
		}
	}
	
	startj = getent("finalfight_jumper", "targetname");
	starta = getent("finalfight_activator", "targetname");
	
	jumper SetPlayerAngles( startj.angles );
	jumper SetOrigin( startj.origin );
	jumper TakeAllWeapons();
	jumper GiveWeapon("knife_mp");
	jumper SetSpawnWeapon("knife_mp");
	jumper FreezeControls(1);
	acti SetPlayerAngles( starta.angles );
	acti SetOrigin( starta.origin );
	acti TakeAllWeapons();
	acti GiveWeapon("knife_mp");
	acti SetSpawnWeapon("knife_mp");
	acti FreezeControls(1);
	
	VisionSetNaked( "finalfight_intro_mp", 2 );
	wait 2;
	
	fire = getentarray("finalfight_fire", "targetname");
	for(i=0;i<fire.size;i++)
	{
		fire[i].origin += (0,0,50);
		PlayFXOnTag( level.finalfight_fire, fire[i], "tag_origin" );
	}
	wait 0.2;
	embers = getent("finalfight_embers", "targetname");
	for(i=0;i<5;i++)
		PlayFX( level.finalfight_embers, embers.origin+(RandomIntRange(-256,256),RandomIntRange(-256,256),0) );
	wait 0.2;
	distortion = getentarray("finalfight_distortion", "targetname");
	for(i=0;i<distortion.size;i++)
		PlayFXOnTag( level.finalfight_distortion, distortion[i], "tag_origin" );
	wait 0.2;
	
	AmbientPlay("finalfight"+(1+RandomInt(2)));
	
	noti = SpawnStruct();
	noti.titleText = "=|FINAL FIGHT|=";
	noti.notifyText = "1 VS 1 Knife!";
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 5;
	
	noti = SpawnStruct();
	noti.titleText = acti.name + " ^1VS ^7" + jumper.name;
	noti.notifyText = "GET READY!";
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 5;
	
	VisionSetNaked( "finalfight_mp", 2 );
	jumper FreezeControls(0);
	acti FreezeControls(0);
	
	iprintlnbold("^1F  I  G  H  T !");
}

addTestClients()
{
	setDvar("scr_testclients", "");
	wait 1;
	for(;;)
	{
		if(getdvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}
	testclients = getdvarInt("scr_testclients");
	setDvar( "scr_testclients", 0 );
	for(i=0;i<testclients;i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i]))
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
	}
	thread addTestClients();
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;
		
	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;
}
