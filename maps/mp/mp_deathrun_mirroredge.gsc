/*
 MM  MMM  MM IMM. MMM  MM   ~MMMMM  MMMMMM   MMMMMZ   MMMMMN
 MM. MMM MM  OMM  MMMM MM  MMM         MMM  MM~  MMM  MM .MM
  MMMMMM MM  MMM  MMMMMMM  MM  MMM   :MM    MM    MM .MMMMM
  MMM,DMMM   MMM  MM MMMM  MMM  MM  MMM     MM7  MMM  MM MM
  MMM  MMM   MMM  MM  MMM   NMMMMM  MMMMMM   NMMMM .  MM MMM
*/
main()
{
thread sr\api\_map::createSpawnOrigin((-6600, -1064, -1580), 0);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (-8191, -5991, -2968), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
	thread onConnect();
	maps\mp\_load::main();


	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	// ambientPlay("ambient");

	precacheModel("vehicle_mig29_desert");
	precacheShader( "waypoint_defuse_b" );

	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");

	level.fx_coud_bank = loadfx ("weather/cloud_bank");

	PlayFX( level.fx_coud_bank, (-5231,4201,-1092) );


	PrecacheModel( "vehicle_blackhawk" );
	PrecacheModel( "vehicle_mi24p_hind_desert" );
	PrecacheItem("choppergunner_mp");

	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("ak74u_mp");

	// level.trig1=getent("trig_move1","targetname");
	// level.trig2=getent("trig_move2","targetname");
	// level.trig3=getent("trig_move3","targetname");
	// level.trig4=getent("trig_move4","targetname");
	// level.trig5=getent("trig_move5","targetname");
	// level.trig6=getent("trig_move6","targetname");

	// level.jumpspawn=getent("jumpspawn","targetname");
	// level.actispawn=getent("actispawn","targetname");


	//////////dvars/////////////////////////////
	// level.dvar["timelimit"] = 10;
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

	///////////variable////////////////////

	//////////////caches////////////////

	//////////////threads////////////////
	thread way_connect();
	thread cliffjump();
	thread jetspawn();
	thread wallrun();
	thread wallrun2();
	// thread WatchHelicopterTrigger();
	thread ropedown();
	thread cranemove();
	// thread straferunmode();

	////////////////traps//////////////////
	// thread checkactiprogress();
	// thread checkactiprogress2();
	// thread checkactiprogress3();
	// thread checkactiprogress4();
	// thread checkactiprogress5();
	// thread checkactiprogress6();

	////////endgames/////////////
	// thread scopegame();
	//912 -912 56 jump
	//-840 144 360 acti

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
		self.isSliding = false;
	}
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


checkactiprogress()
{
level.trig1used=false;
level.trig1 waittill("trigger");
level.trig1used=true;
level.trig1 delete();
}

checkactiprogress2()
{
level.trig2used=false;
level.trig2 waittill("trigger");
level.trig2used=true;
level.trig2 delete();
}

checkactiprogress3()
{
level.trig3used=false;
level.trig3 waittill("trigger");
level.trig3used=true;
level.trig3 delete();
}

checkactiprogress4()
{
level.trig4used=false;
level.trig4 waittill("trigger");
level.trig4used=true;
level.trig4 delete();
}

checkactiprogress5()
{
level.trig5used=false;
level.trig5 waittill("trigger");
level.trig5used=true;
level.trig5 delete();
}

checkactiprogress6()
{
level.trig6used=false;
level.trig6 waittill("trigger");
level.trig6used=true;
level.trig6 delete();
}

straferunmode()
{
trigger=getent("straferun_trigger","targetname");
trigger waittill("trigger", player);
iprintlnbold("^1" +player.name +" ^7called air support ! ^1Get yourself some cover !");
player straferun();
}



jetspawn()
{
spawn_jet_mid=(-5231,11369,-1092);
end_jet_mid=(-5552,-21364,-436);

spawn_jet_left=(-5743,11625,-1092);
end_jet_left=(-6064,-21108,-436);

spawn_jet_right=(-4719,11625,-1092);
end_jet_right=(-5040,-21108,-436);

	level waittill("round_started");

	jet_mid = spawn("script_model", spawn_jet_mid);
	jet_mid.angles=(0,270.1,0);
	jet_mid setModel( "vehicle_mig29_desert" );
	jet_mid playloopsound("veh_mig29_dist_loop");
	jet_mid thread playPlaneFx();

	jet_left = spawn("script_model", spawn_jet_left);
	jet_left.angles=(0,270.1,0);
	jet_left setModel( "vehicle_mig29_desert" );
	jet_left playloopsound("veh_mig29_dist_loop");
	jet_left thread playPlaneFx();

	jet_right = spawn("script_model", spawn_jet_right);
	jet_right.angles=(0,270.1,0);
	jet_right setModel( "vehicle_mig29_desert" );
	jet_right playloopsound("veh_mig29_dist_loop");
	jet_right thread playPlaneFx();


	jet_mid moveTo(end_jet_mid,9);
	jet_left moveTo(end_jet_left,9);
	jet_right moveTo(end_jet_right,9);
	jet_mid waittill("movedone");
	jet_mid delete();
	wait 0.5;
	jet_left delete();
	jet_right delete();
}

playPlaneFx()
{
	self endon ( "death" );
	while(1)
	{
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
	wait 1;
	}
}


///////////////////////////////////map-scripts////////////////////////////////////////
glasses()
{
    self endon("disconnect");
    self endon("death");

    self.hardpoint_jugg_goggles = newClientHudElem( self );
    self.hardpoint_jugg_goggles.x = 0;
    self.hardpoint_jugg_goggles.y = 0;
	self.hardpoint_jugg_goggles.alignX = "left";
	self.hardpoint_jugg_goggles.alignY = "top";
	self.hardpoint_jugg_goggles.horzAlign = "fullscreen";
	self.hardpoint_jugg_goggles.vertAlign = "fullscreen";
	self.hardpoint_jugg_goggles.sort = -5;
	self.hardpoint_jugg_goggles.archived = true;
	self.hardpoint_jugg_goggles setShader( "waypoint_defuse_b", 640, 480 );
	self.hardpoint_jugg_goggles.alpha = 1;
}

cliffjump()
{

	trigger=getent("jumproof1","targetname");
	if( !isDefined( trigger ) )
		return;

	while(1)
	{
		trigger waittill( "trigger", player );

		player transmit(5000,25);
		iprintln("acted");
	}
}

wallrun()
{

	trigger=getent("walljump","targetname");
	if( !isDefined( trigger ) )
		return;

	while(1)
	{
		trigger waittill( "trigger", player );
		player SetPlayerAngles( (0, 210, 0) );
		player transmit(100,90);
		iprintln("acted");
	}
}

wallrun2()
{

	trigger=getent("walljump2","targetname");
	if( !isDefined( trigger ) )
		return;

	while(1)
	{
		trigger waittill( "trigger", player );
		player SetPlayerAngles( (0, 150, 0) );
		player transmit(8,222);
		iprintln("acted");
	}
}


transmit(force,gravity)
{
self.origin = self getorigin();

if (!isDefined(self.bh))
	self.bh = 0;
self.bh += force;

			bounceFrom = (self.origin - vector_scal( anglesToForward( self.angles ), gravity )) - (0,0,42);
			bounceFrom = vectorNormalize( self.origin - bounceFrom );
			self bounce( bounceFrom, self.bh );
			self bounce( bounceFrom, self.bh );
			self bounce( bounceFrom, self.bh );
			wait 0.1;


}

bounce( pos, power )
{
	oldhp = self.health;
	self.health = self.health + power;
	self finishPlayerDamage( self, self, power, 0, "MOD_PROJECTILE", "bh_mp", undefined, pos, "none", 0 );
	self.health = oldhp;

}

vector_scal(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}

WatchHelicopterTrigger()
{
	trig = getEnt( "trigger_helicopter", "targetname" );
	helimodel=getent("heli_model","targetname");
	while(1)
	{
		trig waittill( "trigger", player );
		//if( GetTeamPlayersAlive( "allies" ) > 1 )
			//continue;
		player thread StartHelicopter();
		player.chopperlink=true;
		player thread godmode();
		//player thread glasses();
		//level.activ thread StartHelicopter();
		iPrintlnBold( "^1>> ^2" + player.name + " has entered the heli" );
		helimodel hide();
		break;
	}
}

godmode()
{
self endon ( "disconnect" );
self endon ( "death" );
self.maxhealth = 90000;
self.health = self.maxhealth;
self iprintln("health is: " +self.health);
if(!isdefined(self.chopperlink))
	self.chopperlink=true;

	while(self.chopperlink)
	{
	wait .4;
	if ( self.health < self.maxhealth )
	self.health = self.maxhealth;
	}

if(self.chopperlink==false)
	self.health = 100;
}

StartHelicopter()
{
	self endon( "disconnect" );
	self endon( "death" );

	if( !isDefined( self ) || !isAlive( self ) || !isPlayer( self ) )
		return;

	path = [];
	orig = getEntArray();
	if( self.pers["team"] == "allies" )
	{
		start = getEnt( "orig_heli_jumper_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_jumper"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
			}
		}
	}
	else
	{
		start = getEnt( "orig_heli_acti_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_acti"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
			}
		}
	}
	chopper = spawn_helicopter( self, start.origin, start.angles, "cobra_mp", "vehicle_blackhawk" );
	wait 0.05;
	chopper.owner = self;
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.linker = Spawn( "script_model", chopper GetTagOrigin( "tag_guy4" )-(0,0,20) );
	chopper.linker LinkTo( chopper );
	chopper setDamageStage( 3 );
	chopper setCanDamage( 1 );
	chopper.maxhealth = 5000;
	chopper.health = chopper.maxhealth;
	chopper setSpeed( 40, 15 );
	chopper setYawSpeed( 50, 20, 20 );
	chopper SetMaxPitchRoll( 30, 30 );
	chopper setNearGoalNotifyDist( 96 );
	//chopper thread DamageMonitor();
	chopper endon( "crashed" );

	pathnum = 0;

	self setOrigin( chopper.linker.origin );
	self LinkTo( chopper.linker );
	self TakeAllWeapons();
	self GiveWeapon( "choppergunner_mp" );
	self GiveMaxAmmo( "choppergunner_mp" );
	self SetSpawnWeapon( "choppergunner_mp" );


		//start
		chopper setVehGoalPos( (-5984,2192,-1132), true );
		chopper waittill("goal");
		if(level.trig1used==false)
			level.trig1 waittill("trigger");

		//after ropedown
		chopper setVehGoalPos( (-3548,3192,-1996), true );
		chopper waittill("goal");
		if(level.trig2used==false)
			level.trig2 waittill("trigger");

		//move up
		chopper setVehGoalPos( (-688,1360,-216), true );
		chopper waittill("goal");
		if(level.trig3used==false)
			level.trig3 waittill("trigger");

		//move down to walljump
		chopper setVehGoalPos( (-2668,-812,-2520), true );
		chopper waittill("goal");
		if(level.trig4used==false)
			level.trig4 waittill("trigger");

		//move infront of steiger
		chopper setVehGoalPos( (-4148,-1600,-2776), true );
		chopper waittill("goal");
		if(level.trig5used==false)
			level.trig5 waittill("trigger");

		//move to crane
		//-5117 -2454 -1784
		//-11458 -2423 -1784
		//-10385 -1119 -1784
		chopper setVehGoalPos( (-5117,-2454,-1784), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (-11458,-2423,-1784), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (-10385,-1119,-1784), true );
		chopper waittill("goal");
		if(level.trig6used==false)
			level.trig6 waittill("trigger");

		//move to mid town
		//-4834 -2520 -1624
		//-4322 -3864 -1624
		chopper setVehGoalPos( (-5346,-2520,-1624), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (-4322,-3864,-1624), true );
		chopper waittill("goal");
		wait 3+RandomInt(5);

		chopper setVehGoalPos( (-3426,-5142,-1304), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (-3426,-5142,-1600), true );
		chopper waittill("goal");
		self Unlink( chopper.linker );
		self.hardpoint_jugg_goggles destroy();
		//self.chopperlink=false;
		//self.health=100; //just in case



	if( !isDefined( self ) || !isAlive( self ) )
		chopper notify( "damage", 3000, undefined );
}


DamageMonitor()
{
	while( isDefined( self.owner ) )
	{
		self waittill( "damage", dmg, attacker );
		self.health -= dmg;
		self.attacker = attacker;

		if( self.health >= 2000 && self.health < 3000 )
			self SetDamageStage( 2 );
		else if( self.health >= 1000 && self.health < 2000 )
			self SetDamageStage( 1 );
		else if( self.health < 1000 )
			self SetDamageStage( 0 );

		if( self.health <= 0 )
			break;
	}
	if( isDefined( self.owner ) )
		self.owner UnLink();

	EarthQuake( 1.5, 1, self.origin, 1200 );
	self PlaySound( "exp_suitcase_bomb_main" );
	PlayFX( level.fx_heliexplode, self.origin-(0,0,60) );
	RadiusDamage( self.origin, 600, 500, 80, self.attacker );
	self.linker delete();
	self notify( "crashed" );
	self delete();
	//iPrintlnBold( "Helicopter is dead!" );
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return chopper;
}

ropedown()
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
			if(Distance( start, players[i].origin ) <= 128 && isAlive(players[i]) && !players[i].isSliding)
			{
				players[i] thread rope( start, end );
			}
		}

		wait 0.0001;
	}
}

rope( start, end )
{
	if( !isDefined( self.linker ) )
		self.linker = Spawn("script_origin", self GetEye()+(0,0,20) );

	self sr\api\_player::antiElevator(false);
	self.isSliding = true;
	self DisableWeapons();
	self LinkTo( self.linker );
	self.linker MoveTo( start, 1, 0.5, 0.5 );
	wait 1.2;
	self.linker MoveTo( end, 4, 4, 0 );
	wait 1;
	wait 3;
	self UnLink();
	self.linker delete();
	self EnableWeapons();
	self.isSliding = false;
	self sr\api\_player::antiElevator(true);
}

cranemove()
{
mover=getent("cranemover","targetname");
start = mover GetOrigin();
while(1)
	{
	mover moveTo((-7761,-1383,-2912),6);
	mover waittill("movedone");
	mover moveTo((-6264,-2248,-2912),6);
	mover waittill("movedone");
	}
}

/////
//Strafe-run �Duffman
////
StrafeRun() {

	level.strafeInProgress = true;
	self endon("disconnect");

	level thread EndonOnDc(self);

	center = getMapCenter();

	angle = randomint(360);

	vector1 = anglesToForward((0,angle - 180,0));
	vector2 = anglesToForward((0,angle,0));
	vector3 = anglesToForward((0,angle-90,0));
	vector4 = anglesToForward((0,angle-270,0));

	level.start[0] = center+(vector1[0]*10600,vector1[1]*10600,0)+(vector3[0]*1800,vector3[1]*1800,0);
	level.end[0] = center+(vector2[0]*10600,vector2[1]*10600,0)+(vector3[0]*1800,vector3[1]*1800,0);

	level.start[1] = center+(vector1[0]*10300,vector1[1]*10300,0)+(vector3[0]*900,vector3[1]*900,0);
	level.end[1] = center+(vector2[0]*10300,vector2[1]*10300,0)+(vector3[0]*900,vector3[1]*900,0);

	level.start[2] = center+(vector1[0]*10000,vector1[1]*10000,0);
	level.end[2] = center+(vector2[0]*10000,vector2[1]*10000,0);

	level.start[3] = center+(vector1[0]*10300,vector1[1]*10300,0)+(vector4[0]*900,vector4[1]*900,0);
	level.end[3] = center+(vector2[0]*10300,vector2[1]*10300,0)+(vector4[0]*900,vector4[1]*900,0);

	level.start[4] = center+(vector1[0]*10600,vector1[1]*10600,0)+(vector4[0]*1800,vector4[1]*1800,0);
	level.end[4] = center+(vector2[0]*10600,vector2[1]*10600,0)+(vector4[0]*1800,vector4[1]*1800,0);

	level.chopper = undefined;


	for(i=0;i<5;i++) {
		level.chopper[i] = spawnHelicopter( self, level.start[i], (0,angle,0), "cobra_mp", "vehicle_mi24p_hind_desert" );
		level.chopper[i] thread monitor_loop(level.start[i],level.end[i]);
		level.strafe_chopper[i] = level.chopper[i];
		level.chopper[i] playLoopSound( "mp_hind_helicopter" );
		level.chopper[i] SetDamageStage(3);
		level.chopper[i] setCanDamage(true);
		level.chopper[i] clearTargetYaw();
		level.chopper[i] clearGoalYaw();
		level.chopper[i] setspeed( 30, 25 );
		level.chopper[i] setyawspeed( 75, 45, 45 );
		level.chopper[i] setmaxpitchroll( 15, 15 );
		level.chopper[i] setneargoalnotifydist( 200 );
		level.chopper[i] setturningability( 0.9 );
		level.chopper[i] setvehgoalpos( level.end[i], 0 );
		level.chopper[i] setVehWeapon( "cobra_20mm_mp" );
		level.chopper[i].owner = self;
		level.chopper[i].team = self.pers["team"];
		level.chopper[i].pers["team"] = self.pers["team"];
	}


	while(distance(center,level.chopper[2].origin) >= 5000) wait .05;
	for(k=0;distance(center,level.chopper[2].origin) <= 5000;k++) {
		players = getAllPlayers();
		allowed = [];
		for(j=0;j<players.size;j++) {
			if(isDefined(players[j]) && players[j].health > 0 && players[j].sessionteam != "spectator" && (players[j].pers["team"] != self.pers["team"] || !level.teambased) && self != players[j] && BulletTracePassed(level.chopper[2].origin,players[j].origin+(0,0,100),true,level.chopper[2])) {
				allowed[allowed.size] = players[j];
			}
		}
		if(allowed.size > 0 && k%(randomint(20) + 20) != 0) {
			player = allowed[randomint(allowed.size)];
			for(i=0;i<5;i++) {
				level.chopper[i] setTurretTargetEnt( player, ( 0, 0, 40 ) );
				level.chopper[i] setturrettargetvec( player.origin );
				level.chopper[i] fireWeapon( "tag_flash",player);
			}
			luck = 80 - (GetTeamPlayersAlive(player.pers["team"]) * 2);
			if(!randomint(luck))
				player thread [[level.callbackPlayerDamage]](level.chopper[1],level.chopper[1],120,false,"MOD_PISTOL_BULLET","cobra_20mm_mp",(0,0,0),(0,0,0),"torso_upper",0);
		}
		else
			wait 1;
		wait .05;
	}
	wait 6;

}

 monitor_loop(start,end)
{
	while(1)
	{
		self waittill("goal");
		self setvehgoalpos( start, 0 );
		self waittill("goal");
		self setvehgoalpos( end, 0 );
	}
}

getMapCenter() {
	players = getAllPlayers();
	x = [];
	y = [];
	for(i=0;i<players.size;i++) {
		if(isDefined(players[i]) && players[i].health > 0 && players[i].sessionteam != "spectator") {
			x[x.size] = players[i].origin[0];
			y[y.size] = players[i].origin[1];
		}
	}
	location = 0;
	return (getAverageValue(x),getAverageValue(y),location);
}

EndonOnDc(player) {
	player endon("heli_deleted");
	player waittill("disconnect");
	for(i=0;i<5;i++)
		if(isDefined(level.strafe_chopper[i]))
			level.strafe_chopper[i] delete();
	level.strafeInProgress = undefined;
	iprintlnbold("heli deleted");
}

getAverageValue(array) {
	val = 0;
	for(i=0;i<array.size;i++)
		val += array[i];
	return val / array.size;
}

getAllPlayers() {
	return getEntArray( "player", "classname" );
}

scopegame()
{
	triggertele = getEnt("scope_endgame", "targetname");
	//precacheItem("m40a3_mp");
	//precacheItem("remington700_mp");
	while(1)
	{
		triggertele waittill("trigger", player );
		player SetOrigin((-2562,-603,-4456));
		player SetPlayerAngles((0,270,0));
		player takeallweapons();
		player GiveWeapon("m40a3_mp");
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("m40a3_mp");
		player GiveMaxAmmo("remington700_mp");
		player SwitchToWeapon( "m40a3_mp" );

		if(!isdefined(level.firsttime))
			level.firsttime=true;
		if(level.firsttime==true)
			{
			iprintln("Restored activator his health");
			level.activ.chopperlink=false;
			level.activ.hardpoint_jugg_goggles destroy();
			level.activ.health=100; //just in case
			wait 0.5;
			level.activ SetPlayerAngles((0,180,0));
			level.activ SetOrigin((-3562,-2348,-4158));
			level.activ takeallweapons();
			level.activ GiveWeapon("m40a3_mp");
			level.activ GiveWeapon("remington700_mp");
			level.activ GiveMaxAmmo("m40a3_mp");
			level.activ GiveMaxAmmo("remington700_mp");
			level.activ SwitchToWeapon( "m40a3_mp" );
			level.firsttime=false;
			}
	}
}