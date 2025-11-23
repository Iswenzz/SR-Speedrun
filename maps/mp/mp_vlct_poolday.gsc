#include maps\mp\_utility;
#include common_scripts\utility;
main() {
	///External scripts///
	maps\mp\_load::main();

	///Team Setup///
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	///Set Dvars///
	//VisionSetNaked( "mp_dr_poolday");
	setdvar( "r_specularcolorscale", "1" );
	// setdvar("r_specular", "0" );
	setdvar("r_glowbloomintensity0","1");
	setdvar("r_glowbloomintensity1","1");
	setdvar("r_glowskybleedintensity0","1");
	setdvar("compassmaxrange","1800");
	//setdvar("g_speed" ,"210");
    //setdvar("dr_jumpers_speed" ,"1.12");
	setDvar("bg_fallDamageMinHeight", "9999");
	setDvar("bg_fallDamageMaxHeight", "99999");

	///Precache///
	preCacheItem("artillery_mp");
	PreCacheModel("com_laptop_generic_open");
	PreCacheShellShock( "jeepride_ridedeath");
	PreCacheModel("vehicle_mig29_desert");
	preCacheRumble("artillery_rumble");
	PreCacheModel("vehicle_blackhawk_sas");

	///PrecacheFX///
	///Water///
	//level._fx["Water"]["Trap2_Mortar_Water_Impact"] = loadfx ("explosions/mortarExp_water");
	//level._fx["Water"]["Trap3_Turret"] = loadfx ("poolday/poolday_trap3_turret");
	//level._fx["Water"]["Trap4_Water_Spray"] = loadfx ("poolday/poolday_trap4_waterspray");
	//level._fx["Water"]["Trap7_Heli_Spray"] = loadfx ("poolday/poolday_trap7_helispray");
	//level._fx["Water"]["Splash"] = loadfx ("explosions/grenadeExp_water");
	///Wood///
	//level._fx["Wood"]["Trap2_Platform_Explode"] = loadfx ("poolday/poolday_trap2_wood_exp");
	///Air Strike///
	//level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	//level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");

	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way");
	thread sr\api\_map::createSpawn((52, -240, -3), 89);

	thread sr_death();
	thread sr_death2();
	thread sr_sec_enter();


	///Course Trap Threads///
	//thread sign1();
	//thread trap1();
	thread trap2();
	//thread trap3_water_turret();
	//thread trap3_acti();
	//thread trap4();
	thread trap5();
	thread trap7();

	///End Room Threads///
	//thread antiglitcher();
	//thread endmap();
	//thread room_select();
	//thread sniperroom();
	//thread bounceroom();
	//thread bounceweapon();

	///Misc Functions///
	//thread music();
	//thread teleport_secret();
	thread teleport_secretrespawn();
	thread teleport_secretrespawn2();
	thread teleport_secretend();
	//thread add_trap_to_triggers();
	//thread underwater_effects_player();
	//thread underwater_effects_player2();
	//thread player_bounce_off_area();
	//thread player_water_splash();
	//thread player_water_splash2();
	//thread play_ambient_sound();

	//Variables
	//level.waterturretused = 0;
	//level.trap4triggerlinked = 0;
	//level.trap7triggerlinked = 0;
	//level.watermovedback = 0;
}

sr_death()
{
	underwater_trig = getent("underwater_effect_trig","targetname");

	for(;;)
	{
		underwater_trig waittill ("trigger", player);
		player Suicide();
	}
}

sr_death2()
{
	underwater_trig = getent("underwater_effect_trig2","targetname");

	for(;;)
	{
		underwater_trig waittill ("trigger", player);
		player Suicide();
	}
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(-148.091, -239.906, -63.375), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secretrespawn_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sign1()
{
   vlct = getent("logo_velocity","targetname");

	for(;;)
   {
   wait 0.1;
   vlct rotateYaw (360,15);
   wait 0.1;
   }

}

music()
{
    level.music = randomint(4);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "song1" );
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "song2" );
     break;
      case 2:
	        AmbientStop(2);
     AmbientPlay( "song3" );
     break;
      case 3:
	        AmbientStop(2);
     AmbientPlay( "song4" );
     break;
	}
}

trap1()
{
	trap1_trigger = getent("trap1_trigger","targetname");
	trap1_laptop = getent("trap1_laptop","targetname");


	trap1_trigger SetHintString("^5Press [USE] to activate trap!");
	trap1_trigger waittill("trigger", player);

 	trap1_trigger SetHintString("^1Trap activated!");
 	trap1_laptop SetModel("com_laptop_generic_open");

 	thread trap1_platform1_move();
 	wait 1;
 	thread trap1_platform2_move();
}

trap1_platform1_move()
{
	trap1_platform1 = getent("trap1_hold1","targetname");
	trap1_start1 = getent("trap1_moveto_start1","targetname");
	trap1_middle1 = getent("trap1_moveto_middle1","targetname");
	trap1_end1 = getent("trap1_moveto_end1","targetname");

	trap1_platform1 MoveTo(trap1_middle1.origin, 2);
 	wait 2;
 	trap1_platform1 RotatePitch(-80, 1);
 	trap1_platform1 MoveTo(trap1_end1.origin, 1, 1,0);
 	wait 2;

	while(1)
 	{
 		trap1_platform1.angles = (0,0,0);
 		trap1_platform1 MoveTo(trap1_start1.origin, 0.1);
 		wait 0.5;
 		trap1_platform1 MoveTo(trap1_middle1.origin, 4,2,0);
 		wait 3.8;
 		trap1_platform1 RotatePitch(-80, 1);
 		wait 0.2;
 		trap1_platform1 MoveTo(trap1_end1.origin, 1, 1,0);
 		wait 2;
 	}
}

trap1_platform2_move()
{
	trap1_platform2 = getent("trap1_hold3","targetname");
	trap1_start2 = getent("trap1_moveto_start2","targetname");
	trap1_middle2 = getent("trap1_moveto_middle2","targetname");
	trap1_end2 = getent("trap1_moveto_end2","targetname");

	trap1_platform2 MoveTo(trap1_middle2.origin, 2);
 	wait 2;
 	trap1_platform2 RotatePitch(-80, 1);
 	trap1_platform2 MoveTo(trap1_end2.origin, 1, 1,0);
 	wait 2;

	while(1)
 	{
 		trap1_platform2.angles = (0,0,0);
 		trap1_platform2 MoveTo(trap1_start2.origin, 0.1);
 		wait 0.5;
 		trap1_platform2 MoveTo(trap1_middle2.origin, 4,2,0);
 		wait 3.8;
 		trap1_platform2 RotatePitch(-80, 1);
 		wait 0.2;
 		trap1_platform2 MoveTo(trap1_end2.origin, 1, 1,0);
 		wait 2;
 	}
}

trap2()
{
	trap2_trigger = getent("trap2_trigger","targetname");
	trap2_laptop = getent("trap2_laptop","targetname");

	trap2_laptop SetModel("com_laptop_generic_open_obj");

	trap2_moveto_start = getent("trap2_moveto_start","targetname");
	trap2_mortar_incoming = getent("trap2_mortar_incoming","targetname");
	trap2_mortar_impact = getent("trap2_mortar_impact","targetname");
	trap2_platform = getent("trap2_platform","targetname");
	trap2_mortar_hurt = getent("trap2_mortar_hurt","targetname");

	wait 0.1;

	trap2_mortar_hurt delete();
}

trap2_kill_players()
{
	while(1)
	{
    	self waittill ("trigger",user);
		if (user istouching(level.trap9_kill) && isDefined(level.activ))
			{
				user FinishPlayerDamage( level.activ, level.activ, 1000, 0, "MOD_PROJECTILE_SPLASH", "artillery_mp", self.origin, self.origin, "none", 0 );
			}
			wait 0.05;
		if (user istouching(level.trap9_kill) && !isDefined(level.activ))
		{
			user FinishPlayerDamage( self, self, 1000, 0, "MOD_PROJECTILE_SPLASH", "artillery_mp", self.origin, self.origin, "none", 0 );
		}
	}
}


trap3_water_turret()
{
	level.waterturret = getent("turretwater","targetname");

	turret_water_trigger = getent("turretwatertrig","targetname");

	turret_water_trigger EnableLinkTo();
	turret_water_trigger LinkTo(level.waterturret, "tag_flash"); //Link water bounce trig to the end of the turret's barrel
	turret_water_trigger thread trap3_water_bounce();
	wait 5;
	thread trap3_link_fx_to_turret();
}

trap3_water_bounce()
{
	trap3_bounce_trigger = self;
	while(1)
	{
    	trap3_bounce_trigger waittill ("trigger",player);
		if (player istouching(trap3_bounce_trigger))
		{
			player braxi\_common::bounce( vectorNormalize( player.origin - (player.origin - (0,1,0)) ), 200 );
		}
	}
}

trap3_acti()
{
	trap3_trigger = getent("trap3_trigger","targetname");
	trap3_trigger SetHintString("^5Press [USE] to activate trap!");
	trap3_trigger waittill("trigger", player);
	trap3_trigger SetHintString("^1Trap activated!");

	if(level.waterturretused == 0)
	{
		level.waterturret UseBy(player);
		level.waterturretused = 1;
		wait 1;
	}
	wait 3;
	level.waterturretused = 0;
	thread trap3_acti();
}


trap3_link_fx_to_turret()
{
	//Link the water spray to the turret
	waterturretfx = spawn( "script_model", level.waterturret gettagorigin("tag_flash") );
	waterturretfx.angles = level.waterturret GetTagAngles("tag_flash") + (0,0,0);
	waterturretfx setModel( "tag_origin" );
	waterturretfx linkto( level.waterturret, "tag_flash");
	wait 1;
	playfxontag (level._fx["Water"]["Trap3_Turret"], waterturretfx, "tag_origin");
}

trap4()
{
	trap4_trigger = getent("trap4_trigger","targetname");
	trap4_laptop = getent("trap4_laptop","targetname");

	trap4_laptop SetModel("com_laptop_generic_open_obj");

	trap4_water_bounce = getent("trap4_water_bounce","targetname");
	level.trap4_pipe = getent("trap4_pipe","targetname");
	trap4_moveto_left = getent("trap4_left_origin","targetname");
	trap4_moveto_middle = getent("trap4_middle_origin","targetname");
	trap4_moveto_right = getent("trap4_right_origin","targetname");
	wait 0.5;

	if(level.trap4triggerlinked == 0)
	{
		trap4_water_bounce EnableLinkTo();
		trap4_water_bounce LinkTo(level.trap4_pipe);
		level.trap4triggerlinked = 1;
		wait 0.1;
	}

	trap4_water_bounce thread maps\mp\_utility::triggerOff();
	trap4_trigger SetHintString("^5Press [USE] to activate trap!");
	trap4_trigger waittill("trigger", player);

 	trap4_trigger SetHintString("^1Trap activated!");
 	trap4_laptop SetModel("com_laptop_generic_open");

 	thread trap4_create_water_fx();
 	level.trap4_pipe PlaySound("trap6_watergush");
 	trap4_water_bounce thread trap4_water_bounce();
 	level.trap4_pipe MoveTo(trap4_moveto_right.origin, 2);
 	wait 2;
 	level.trap4_pipe MoveTo(trap4_moveto_middle.origin, 2);
 	wait 2;
 	level.trap4_pipe MoveTo(trap4_moveto_left.origin, 2);
 	wait 2;
 	level.trap4_pipe MoveTo(trap4_moveto_middle.origin, 2);
 	wait 2;
 	level.trap4_water_fx Delete();
 	trap4_water_bounce thread maps\mp\_utility::triggerOff();
 	wait 2;
 	thread trap4();
}

trap4_create_water_fx()
{
	level.trap4_water_fx = spawn( "script_model", level.trap4_pipe.origin );
	level.trap4_water_fx.angles = level.trap4_water_fx.angles + (0,-90,0);
	level.trap4_water_fx setModel( "tag_origin" );
	level.trap4_water_fx linkto( level.trap4_pipe);
	wait 0.1;
	playfxontag (level._fx["Water"]["Trap4_Water_Spray"], level.trap4_water_fx, "tag_origin");
}

trap4_water_bounce()
{
	trap4_bounce_trigger = self;
	while(1)
	{
    	trap4_bounce_trigger waittill ("trigger",player);
		if (player istouching(trap4_bounce_trigger))
		{
			player braxi\_common::bounce( vectorNormalize( player.origin - (player.origin - (0,1,0)) ), 200 );
		}
	}
}

trap5()
{
	trap5_trigger = getent("trap5_trigger","targetname");
	trap5_laptop = getent("trap5_laptop","targetname");

	trap5_laptop SetModel("com_laptop_generic_open_obj");

	level.plane_start = getent("trap5_jet_node1","targetname");
	level.plane_end = getent("trap5_jet_node2","targetname");
	level.strikecoord = getent("strike_coord","targetname");
	level.trap5_airstrike_hurt = getent("trao5_airstrike_hurt","targetname");

	wait 0.1;

	level.trap5_airstrike_hurt delete();
}

callStrike()
{
	// Get starting and ending point for the plane
	owner = level.activ;
	direction = level.plane_start.angles;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	startPoint = level.plane_start;
	endPoint = level.plane_end;

	// Make the plane fly by
	flyTime = ( 14816 / planeFlySpeed );

	level thread doPlaneStrike(startPoint, endPoint, flyTime, direction);
	wait 1;
}

doPlaneStrike(startPoint, endPoint, flyTime, direction)
{
	if(isDefined(level.activ))
	{
		owner = level.activ;
	}
	else
	{
		owner = getentarray( "player", "classname" )[0];
	}


	// Spawn the planes
	plane = spawnplane(owner, "script_model", startPoint.origin );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	wait 0.1;
	playfxontag( level.fx_airstrike_afterburner , plane, "tag_engine_right" );
	playfxontag( level.fx_airstrike_afterburner , plane, "tag_engine_left" );
	playfxontag( level.fx_airstrike_contrail, plane, "tag_right_wingtip" );
	playfxontag( level.fx_airstrike_contrail, plane, "tag_left_wingtip" );

	wait 0.1;

	plane moveTo( endPoint.origin, flyTime, 0, 0 );

	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );

	wait flyTime / 2;

	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	thread bomb_effect();

	// Delete the plane after its flyby
	wait flyTime / 2;
	plane notify( "delete" );
	plane delete();
}

bomb_effect()
{
	fx1 = getent("trap5_airstrike_fx1","targetname");
	fx2 = getent("trap5_airstrike_fx2","targetname");

	fx1 PlaySound("artillery_incoming");
	wait 0.2;
	PlayFX(level._fx["Water"]["Trap2_Mortar_Water_Impact"], fx1.origin);
	level.trap5_airstrike_hurt thread maps\mp\_utility::triggerOn();
	thread killplayers();
	fx1 PlaySound("mortar_impact_water");
	playRumbleOnPosition( "artillery_rumble", fx1 );
	earthquake( 0.7, 0.75, fx1.origin, 2000 );
	wait 0.2;
	fx2 PlaySound("artillery_incoming");
	wait 0.2;
	PlayFX(level._fx["Water"]["Trap2_Mortar_Water_Impact"], fx2.origin);
	fx2 PlaySound("mortar_impact_water");
	playRumbleOnPosition( "artillery_rumble", fx2 );
	earthquake( 0.7, 0.75, fx2.origin, 2000 );
	wait 0.2;
	level.trap5_airstrike_hurt thread maps\mp\_utility::triggerOff();
}

killplayers()
{
	while(1)
	{
    	level.trap5_airstrike_hurt  waittill ("trigger",user);
		if (user istouching(level.trap5_airstrike_hurt) && isDefined(level.activ))
			{
				user FinishPlayerDamage( level.activ, level.activ, 1000, 0, "MOD_PROJECTILE_SPLASH", "artillery_mp", self.origin, self.origin, "none", 0 );
			}
			wait 0.05;
		if (user istouching(level.trap9_kill) && !isDefined(level.activ))
		{
			user FinishPlayerDamage( self, self, 1000, 0, "MOD_PROJECTILE_SPLASH", "artillery_mp", self.origin, self.origin, "none", 0 );
		}
	}
}

play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}


delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}


flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}


targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}


targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec);
	if(dot > 0)
		return true;
	else
		return false;
}

callStrike_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}
///End artillery trap

trap6()
{
	trap6_trigger = getent("trap6_trigger","targetname");
	trap6_laptop = getent("trap6_laptop","targetname");

	trap6_laptop SetModel("com_laptop_generic_open_obj");

	trap6_water_bounce = getent("trap6_water_bounce","targetname");
	trap6_running_water = getent("poolday_trap6_water","targetname");
	trap6_water_sound = getent("trap6_water_gush_sound","targetname");

	wait 0.1;

	trap6_water_bounce delete();
	trap6_running_water delete();
	trap6_water_sound delete();


}

trap6_water_bounce()
{
	trap6_bounce_trigger = self;
	while(1)
	{
    	trap6_bounce_trigger waittill ("trigger",player);
		if (player istouching(trap6_bounce_trigger))
		{
			player braxi\_common::bounce( vectorNormalize( player.origin - (player.origin - (1,0,0)) ), 200 );
		}
	}
}


trap7()
{
	trap7_trigger = getent("trap7_trigger","targetname");
	trap7_laptop = getent("trap7_laptop","targetname");

	trap7_laptop SetModel("com_laptop_generic_open_obj");

	level.trap7_heli_spawn = getent("trap7_heli_spawn","targetname");
	level.trap7_heli_node1 = getent("trap7_heli_node1","targetname");
	level.trap7_heli_node2 = getent("trap7_heli_node2","targetname");

	level.trap7_target1 = getent("trap7_target_orig1","targetname");
	level.trap7_target2 = getent("trap7_target_orig2","targetname");
	level.trap7_target3 = getent("trap7_target_orig3","targetname");
	level.trap7_target4 = getent("trap7_target_orig4","targetname");
	level.trap7_target5 = getent("trap7_target_orig5","targetname");
	level.trap7_target_ent = getent("trap7_target_ent","targetname");
	level.trap7_water_bounce = getent("trap7_water_bounce","targetname");

	wait 0.1;

	level.trap7_target_ent delete();
	level.trap7_water_bounce delete();


}

trap7_water_bounce()
{
	trap7_bounce_trigger = self;
	while(1)
	{
    	trap7_bounce_trigger waittill ("trigger",player);
		if (player istouching(trap7_bounce_trigger))
		{
			player braxi\_common::bounce( vectorNormalize( player.origin - (player.origin - (-1,0,0)) ), 150 );
		}
	}
}

helicopter_spawn()
{
	if(isDefined(level.activ))
	{
		heliowner = level.activ;
	}
	else
	{
		heliowner = getentarray( "player", "classname" )[0];
	}

	level.chopper = spawnHelicopter( heliowner, level.trap7_heli_spawn.origin, level.trap7_heli_spawn.angles, "cobra_mp", "vehicle_blackhawk_sas" );
	//level.chopper playLoopSound( "chamber1_helicopter_over" );
	level.chopper helicopter_set_defaults();

	wait 1;
	//level.chopper helicopter_setturrettargetent( level.trap7_target1 );
	level.chopper thread helicopter_searchlight_on();
}

helicopter_set_defaults()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 40, 25 );
	self setyawspeed( 75, 45, 45 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 32 );
	self setturningability(1.0);

	self.maxhealth = 1500;
	self.health = self.maxhealth;

	self setDamageStage( 3 );
}

helicopter_movement()
{
	level.chopper SetVehGoalPos(level.trap7_heli_node1.origin, false);
	level.chopper waittill("goal");
	level.chopper SetVehGoalPos(level.trap7_heli_node2.origin, true);
	level.chopper SetLookAtEnt(level.trap7_heli_node1);
	level.chopper waittill("goal");
	level.chopper notify("InPosition");
	wait 15;
	level.chopper notify("DoneSpraying");
	level.trap7_target_ent MoveTo(level.trap7_target1.origin, 0.1);
	level.chopper SetVehGoalPos(level.trap7_heli_node1.origin, false);
	level.chopper waittill("goal");
	level.chopper SetVehGoalPos(level.trap7_heli_spawn.origin, false);
	level.chopper waittill("goal");
	wait 2;
	level.chopper = undefined;
	self delete();
}

helicopter_setturrettargetent( ent )
{
	level.helicopter_aimtarget = ent;
	level.chopper SetTurretTargetEnt( level.helicopter_aimtarget );
}

helicopter_getturrettargetent()
{
	return level.helicopter_aimtarget;
}


helicopter_searchlight_off()
{
	if ( isdefined( level.fx_ent ) )
		level.fx_ent delete();
}

helicopter_searchlight_on()
{
	self.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
	self.dlight setModel( "tag_origin" );

	self waittill("InPosition");
	self thread helicopter_searchlight_effect();

	level.fx_ent = spawn( "script_model", self gettagorigin("tag_barrel") );
	level.fx_ent setModel( "tag_origin" );
	level.fx_ent linkto( self, "tag_barrel", ( 0,0,0 ), ( 0,0,0 ) );

	wait 0.5;
	playfxontag (level._fx["Water"]["Trap7_Heli_Spray"], level.fx_ent, "tag_origin");
	thread helicopter_turretmovement();
	self waittill("DoneSpraying");
	level.fx_ent Delete();
}

helicopter_turretmovement()
{
	level.trap7_water_bounce thread maps\mp\_utility::triggerOn();
	level.trap7_water_bounce thread trap7_water_bounce();
	level.chopper helicopter_setturrettargetent(level.trap7_target_ent);
	wait 3;
	level.trap7_target_ent MoveTo(level.trap7_target2.origin, 2.5);
	wait 3;
	level.trap7_target_ent MoveTo(level.trap7_target3.origin, 2.5);
	wait 3;
	level.trap7_target_ent MoveTo(level.trap7_target4.origin, 2.5);
	wait 3;
	level.trap7_target_ent MoveTo(level.trap7_target5.origin, 2.5);
	level.trap7_water_bounce thread maps\mp\_utility::triggerOff();
}

helicopter_searchlight_effect()
{
	self endon("death");

	while( true )
	{
		targetent = self helicopter_getturrettargetent();
		wait .8;
	}
}

play_ambient_sound()
{
	poolday_waterfall1 = getent("waterfall_1","targetname");
	poolday_waterfall2 = getent("waterfall_2","targetname");
	poolday_waterfall3 = getent("waterfall_3","targetname");
	wait 1;
	poolday_waterfall1 PlayLoopSound("waterfall_loop");
	poolday_waterfall2 PlayLoopSound("waterfall_loop");
	poolday_waterfall3 PlayLoopSound("waterfall_loop");
}

underwater_effects_player()
{
	underwater_trig = getent("underwater_effect_trig","targetname");

	while(1)
	{
		underwater_trig waittill ("trigger", player);
		player shellshock( "jeepride_ridedeath", 3 );
		hud_Screen = NewClientHudElem(player);
   		hud_Screen.horzalign = "fullscreen";
		hud_Screen.vertalign = "fullscreen";
		hud_Screen.alpha = 0.6;
		hud_Screen.color = (0.25, 1, 1);
		hud_Screen SetShader( "white", 640, 480 );
		player allowJump(false);
		player thread underwater_death();
    	player waittill("death");
    	if(IsDefined(hud_Screen))
    		hud_Screen Destroy();
	}
}

underwater_effects_player2()
{
	underwater_trig = getent("underwater_effect_trig2","targetname");

	while(1)
	{
		underwater_trig waittill ("trigger", player);
		player shellshock( "jeepride_ridedeath", 3 );
		hud_Screen = NewClientHudElem(player);
   		hud_Screen.horzalign = "fullscreen";
		hud_Screen.vertalign = "fullscreen";
		hud_Screen.alpha = 0.6;
		hud_Screen.color = (0.25, 1, 1);
		hud_Screen SetShader( "white", 640, 480 );
		player allowJump(false);
		player thread underwater_death();
    	player waittill("death");
    	if(IsDefined(hud_Screen))
    		hud_Screen Destroy();
	}
}

underwater_death()
{
	wait 2;
	self Suicide();
}

player_bounce_off_area()
{
	bounce_off_trig = getent("player_bounce_off", "targetname");

	while(1)
	{
    	bounce_off_trig waittill ("trigger",player);
		if (player istouching(bounce_off_trig))
		{
			player braxi\_common::bounce( vectorNormalize( player.origin - (player.origin - (-1,0,0)) ), 100 );
		}
	}
}

player_water_splash()
{
	player_watersplash_trig = getent("player_water_splash_fx", "targetname");

	while(true)
	{
		player_watersplash_trig waittill ("trigger", player);
		player PlaySound ("player_water_splash_sound");
		PlayFX( level._fx["Water"]["Splash"], player.origin );
		wait 1;
	}
}

player_water_splash2()
{
	player_watersplash_trig = getent("player_water_splash_fx2", "targetname");

	while(true)
	{
		player_watersplash_trig waittill ("trigger", player);
		player PlaySound ("player_water_splash_sound");
		PlayFX( level._fx["Water"]["Splash"], player.origin );
		wait 1;
	}
}

add_trap_to_triggers()
{
	addTriggerToList("trap1_trigger");
	addTriggerToList("trap2_trigger");
	addTriggerToList("trap3_trigger");
	addTriggerToList("trap4_trigger");
	addTriggerToList("trap5_trigger");
}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
 	level.trapTriggers = [];

	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

room_select()
{
level.room_trig = getEnt( "room_select", "targetname");
room = getEnt( "select_origin", "targetname" );
level.room_trig setHintString ("^0Press ^5[&&1] ^0to enter room selection");

for(;;)
{
level.room_trig waittill( "trigger", player );
if( !isDefined( level.room_trig ) )
return;

acti = GetActivator();
if(level.firstenter == true)
{
	acti freezeControls(1);
	acti iPrintLnBold("^5Jumper is picking a room, so don't ^0MOVE!!!!");
	level notify("acti_antiglitch");
	level.firstenter = false;
}
player SetPlayerAngles( room.angles );
player setOrigin( room.origin );
player TakeAllWeapons();
player antiglitcher();
}
}

endmap()
{
    trig = getEnt("endmap_trig", "targetname");
    trig waittill ("trigger" , player );
    firstPlace = newHudElem();
    firstPlace.foreground = true;
    firstPlace.alpha = 1;
    firstPlace.alignX = "left";
    firstPlace.alignY = "middle";
    firstPlace.horzAlign = "left";
    firstPlace.vertAlign = "middle";
    firstPlace.x = -400;
    firstPlace.y = 0;
    firstPlace.sort = 0;
    firstPlace.font = "default";
    firstPlace.fontScale = 1.4;
    firstPlace.hidewheninmenu = false;
    firstPlace.glowAlpha = 1;
    firstPlace.glowColor = (.3,.0,3);
    firstPlace settext("^5" + player.name + " ^3has finished ^5FIRST^5");
    firstPlace moveOverTime(2);
    firstPlace.x = 5;
    wait 5;
    firstPlace moveOverTime(2);
    firstPlace.x = -500;
    wait 7;
    firstPlace destroy();
}

antiglitcher()
{
level.activator1 = GetActivator();
level.activ = GetActivator();
self common_scripts\utility::waittill_any("death","disconnect");
	if(isDefined(self))
	{
		self notify("matchend");
	}
	else
	{
		level waittill("actiKill");
		self notify("matchend");
	}
self freezeControls(0);
level.activ notify("matchend");

	iPrintln("^3"+self.name+" ^7died^3!");
	wait 0.2;
	iPrintlnBold("^0Room selection ^5opened!");
}
waitdead()
{
    activator = GetActivator();
	sniper = getent("sniper_trig","targetname");
    bounce = getent("bounce_trig","targetname");
	sniper thread maps\mp\_utility::triggerOff();
    bounce thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    sniper thread maps\mp\_utility::triggerOn();
    bounce thread maps\mp\_utility::triggerOn();
}
GetActivator()
{
	players = getentarray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}

	return "Noactivator";
}
createHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 1;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
}
fightHUD(room, jumper, activ)
{
    self notify("newFhud");
    self endon("newFhud");

    if (!isDefined(room))
        room = "undefined";
    if (!isDefined(jumper))
        jumper = "undefined";
    else
        jumper = jumper.name;
    if (!isDefined(activ))
        activ = "undefined";
    else
        activ = activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^3" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^5" + jumper + " ^0VS^0 " + "^5" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}
endTimerPure(text, duration, extra)
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
    self.endTimerHUD = createHUD(0, 120, "center", "top", 1, "objective", 1.5);

    self freezeControls(1);
    wait extra;

    while (duration > 0)
    {
        //self iPrintLnBold (duration);
        self.endTimerHUD setText("^3" + duration);
        self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
        wait 1;
        duration--;
    }
		//self iPrintLnBold(text);
    self.endTimerHUD setText(text);
    self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
    self freezeControls(0);
    wait 1;
    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
}
RoomCountDown(text, duration, extra)
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
    self.endTimerHUD = createHUD(0, 120, "center", "top", 1, "objective", 1.5);

    self freezeControls(1);
    wait extra;

    while (duration > 0)
    {
        self.endTimerHUD setText("^0" + duration);
        self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
        wait 1;
        duration--;
    }
    self.endTimerHUD setText(text);
    self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
    self freezeControls(0);
    wait 1;
    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
}
sniperroom()
{
    level.trigger_scope = getEnt ("sniper_trig", "targetname");

    jumpersc = getEnt ("sniperjumper_origin", "targetname");
    actisc = getEnt ("sniperacti_origin", "targetname");

    for(;;)
    {
        level.trigger_scope setHintString ("^5Press ^0[&&1]^5 to enter Sniper Room");
        level.trigger_scope waittill ("trigger", player);

		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
		player thread RoomCountDown("^5Kill each other !", 3, 0);
		player thread endTimerPure("^0Go Go Go !", 3, 0);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);
        activator setOrigin (actisc.origin);
        activator setPlayerAngles (actisc.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("remington700_mp");
        activator giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        activator giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        activator giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        activator giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        activator switchToWeapon("m40a3_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;


        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^0" + player.name + " ^5has died in Sniper Room!");
    }
}

bounceroom()
{
    level.trigger_jump = getEnt ("bounce_trig", "targetname");

    jumperb = getEnt ("bouncejumper_origin", "targetname");
    actib = getEnt ("bounceacti_origin", "targetname");

    for(;;)
    {
        level.trigger_jump setHintString ("^0Press ^5[&&1]^0 to enter ^5Bounce Room");
        level.trigger_jump waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
        thread fightHUD("Jump Room", player, activator);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
		player setOrigin (jumperb.origin);
        player setPlayerAngles (jumperb.angles);
        activator setOrigin (actib.origin);
        activator setPlayerAngles (actib.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("knife_mp");
        activator giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        activator switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
                       while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^0" + player.name + " ^5has died in ^Jump Room!");
    }
}

bounceweapon()
{
    trig = getEnt ("trig_bounceweapon", "targetname");
    trig setHintString ("^0Press ^5[&&1]^0 to get a ^5Sniper");
    while (1)
    {
        trig waittill ("trigger", player);
        player takeAllWeapons();
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
		player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player switchToWeapon("m40a3_mp");
    }
}

secret_timer()
{
	self endon("secret_done");
	self endon("death");
	self endon("round_ended");
	self thread destroyOnDeath();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer = newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
	self.secretTimer.vertAlign = "bottom";
	self.secretTimer.x = 0;
	self.secretTimer.y = -7;
	self.secretTimer.sort = 5;
	self.secretTimer.fontScale = 1.4;
	self.secretTimer.font = "default";
	self.secretTimer.glowAlpha = 0;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"^0Time left: ^5&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor = level.randomcolor;
	else
	self.secretTimer.glowColor = (1,0,0);

	time = 60;
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
destroyOnDeath()
{

	self waittill("death");

	if(isDefined(self.secretTimer))

	self.secretTimer destroy();
}

teleport_secret()
{
   trig = getent("secret_teleport", "targetname");
   tele1 = getEnt("secretrespawn_origin", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
     player thread secret_timer();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
	 player freezeControls(1);
	 wait 0.05;
	 player freezeControls(0);
    }
}
teleport_secretrespawn()
{
    trig = getEnt("secretrespawn", "targetname");
    tele1 = getEnt("secretrespawn_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player Suicide();
    }
}
teleport_secretrespawn2()
{
    trig = getEnt("secretrespawn2", "targetname");
    tele1 = getEnt("secretrespawn_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player Suicide();
    }
}
teleport_secretend()
{
    trig = getEnt("teleport_secretend", "targetname");
    tele1 = getEnt("secretend_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}