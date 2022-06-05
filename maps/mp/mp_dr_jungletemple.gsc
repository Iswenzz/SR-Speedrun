#include common_scripts\utility;
#include maps\mp\_utility;
main()
{
maps\mp\_load::main();

////Ambience////
VisionSetNaked( "mp_dr_jungletemple");

////game////
game["allies"] = "sas"; 
game["axis"] = "spetnaz"; 
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert"; 
game["axis_soldiertype"] = "desert"; 

////SetDvar////
setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0","1");
setdvar("r_glowbloomintensity1","1");
setdvar("r_glowskybleedintensity0","1");
setDvar("bg_fallDamageMinHeight", "128000");
setDvar("bg_fallDamageMaxHeight", "368000"); 

////Fx////
level._fx["Water"]["FallStream"] = loadfx ("misc/speedex_fallstream");
level._fx["Water"]["Trap7a"] = loadfx ("speedex_waterfloor");
level._fx["Water"]["Trap7b"] = loadfx ("speedex_trap7b");
level._fx["Water"]["FallStreambig"] = loadfx ("speedex_fallstreambig");
level._fx["Water"]["Water_Pour"] = loadfx ("misc/speedex_waterpour");
level._fx["Water"]["Pour"] = loadfx ("water_pour");
level._fx["Lava"]["Pour"] = loadfx ("lava_pour");
level._fx["Fire"]["Trap1"] = loadfx ("fire/speedex_fire");
level._fx["Light"]["Env"] = loadfx ("speedex_spotlight");
level._fx["Light2"]["Env"] = loadfx ("speedex_spot_party");
level._fx["Light3"]["Env"] = loadfx ("speedex_spot_party2");
level._fx["Light4"]["Env"] = loadfx ("speedex_endfx");
level._fx["Water"]["Splash"] = loadfx ("explosions/grenadeExp_water"); 
level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
level.airstrikefx = loadfx ("explosions/clusterbomb");

////PrecacheItems////
PreCacheShellShock( "jeepride_ridedeath");
preCacheModel("vehicle_mig29_desert");
preCacheItem("rpg_mp");
preCacheItem("colt45_mp");
preCacheItem("m1014_grip_mp");
preCacheItem("ak74u_mp");
preCacheItem("artillery_mp");
preCacheRumble("artillery_rumble");

////RunCourseThreads////
thread way_connect();
// thread boat();
// thread boatb();
thread trap1();
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
thread trap7();
thread trap8();
thread trap9();
thread Water_gush_efx();
thread spotlight_efxs();
thread water_hud();
// thread platforms();
thread water_splash();
// thread music();
thread endfx();
////SecretThreads////
// thread rpg();
thread secret_access();
thread secret_finish();
////EndRoomThreads////
thread water_bounce();
thread water_bouncefx();
thread jump_respawn();
thread bounce_weapon();
thread bounce_slpash();
// thread old();
// thread sniperroom();
// thread bounceroom();
// thread weaproom();
// thread kniferoom();
// thread shotroom();

////AddToTriggerList////
// addTriggerToList( "trap1_trigger" );
// addTriggerToList( "trap2_trigger" );
// addTriggerToList( "trap3_trigger" );
// addTriggerToList( "trap4_trigger" ); 
// addTriggerToList( "trap5_trigger" );
// addTriggerToList( "trap6_trigger" );
// addTriggerToList( "trap8_trigger" );
// addTriggerToList( "trap9_trigger" );
// addTriggerToList( "trap10_trigger" );
////Booleans/////
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    thread sr_tp();
    thread sr_tp2();

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );
        
    }
}

sr_tp()
{
	ori = spawn("script_origin",(2756,-2211,-52));
	ori.angles = (0,180,0);
	trig = spawn("trigger_radius",(2814,-127,76),0,150,150);
	trig.radius = 150;
	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr_tp_safe(ori);
	}
}

sr_tp2()
{
	ori = spawn("script_origin",(2766,-5381,-164));
	ori.angles = (0,180,0);
	trig = spawn("trigger_radius",(2762,-3347,-52),0,150,150);
	trig.radius = 150;
	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr_tp_safe(ori);
	}
}

sr_tp_safe(ori)
{
	self endon("death");
	self endon("disconnect");

	self setOrigin(ori.origin);
	self setPlayerangles(ori.angles);
	self freezeControls(1);
	wait 0.05;
	self freezeControls(0);
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

water_bounce()
{
	waterbounce = getent("water_bounce", "targetname");

	while(1)
	{	
    	waterbounce waittill ("trigger",user);
		if (user istouching(waterbounce))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,0,1)) ), 1000 );		
		}
	}
}

water_bouncefx()
{
	waterbouncefx1 = getent("spray_fx1", "targetname");
	//waterbouncefx2 = getent("spray_fx2", "targetname");
	waterbouncefx3 = getent("spray_fx3", "targetname");

	playLoopedFX(level._fx["Light"]["Env"],0.5,waterbouncefx1.origin + (0,0,0),0,anglesToForward(waterbouncefx1.angles + (0,0,0)));
	//playLoopedFX(level._fx["Light"]["Env"],0.5,waterbouncefx2.origin + (0,0,0),0,anglesToForward(waterbouncefx2.angles + (0,0,0)));
	playLoopedFX(level._fx["Light"]["Env"],0.5,waterbouncefx3.origin + (0,0,0),0,anglesToForward(waterbouncefx3.angles + (0,0,0)));
}

endfx()
{
	endfx1 = getent("endfx1", "targetname");
	endfx2 = getent("endfx2", "targetname");
	endfx3 = getent("endfx3", "targetname");
	endfx4 = getent("endfx4", "targetname");
	endfx5 = getent("endfx5", "targetname");
	endfx6 = getent("endfx6", "targetname");

	playLoopedFX(level._fx["Light4"]["Env"],0.5,endfx1.origin + (0,0,0),0,anglesToForward(endfx1.angles));
	playLoopedFX(level._fx["Light4"]["Env"],0.5,endfx2.origin + (0,0,0),0,anglesToForward(endfx1.angles));
	playLoopedFX(level._fx["Light4"]["Env"],0.5,endfx3.origin + (0,0,0),0,anglesToForward(endfx1.angles));
	playLoopedFX(level._fx["Light4"]["Env"],0.5,endfx4.origin + (0,0,0),0,anglesToForward(endfx1.angles));
	playLoopedFX(level._fx["Light4"]["Env"],0.5,endfx5.origin + (0,0,0),0,anglesToForward(endfx1.angles));
	playLoopedFX(level._fx["Light4"]["Env"],0.5,endfx6.origin + (0,0,0),0,anglesToForward(endfx1.angles));
}

secret_access()
{
	trig_heen = getent("secret_trig", "targetname");
	orig_heen = getent("secret_begin", "targetname");

	while(true)
	{
		trig_heen waittill ("trigger", who);	
		who SetPlayerAngles( orig_heen.angles );
		who setOrigin( orig_heen.origin ); //teleports the jumper
		who sr\api\_speedrun::changeWay("secret_0");
	}
}

secret_finish()
{
	trig_terug = getent("secret_endtrig", "targetname");
	orig_terug = getent("secret_end", "targetname");

	while(true)
	{
		trig_terug waittill ("trigger", who);	
		who SetPlayerAngles( orig_terug.angles );
		who setOrigin( orig_terug.origin ); //teleports the jumper
		who thread braxi\_mod::endTimer();
	}
}


rpg()
{
	rpg_trig = getent("rpg_trig","targetname");

	for(;;)
	{
	rpg_trig waittill("trigger", who);
	who giveWeapon("rpg_mp");
	who switchToWeapon("rpg_mp");
	who giveMaxAmmo("rpg_mp");
	wait 1;
	}
}

music()
{
	
	switch(randomint(4))
	{
		case 0:
			ambientPlay("song1");
			wait 2;
			iprintln( " ^4Code Black - Brighter Day" );
			break;
		case 1:
			ambientPlay("song2");
			wait 2;
			iprintln( " ^4Coldplay - Hymn For The Weekend (Seeb remix)" );
			break;
		case 2:
			ambientPlay("song3");
			wait 2;
			iprintln( " ^4Julian Morde - Gypsy Dance" );
			break;
		case 3:
			ambientPlay("song4");
			wait 2;
			iprintln( " ^4Showtek vs. Technoboy & Tuneboy - Mellow" );
			break;
	}

	level waittill("round_ended");
	AmbientStop();
}

water_splash()
{
	trig3 = getent("water_fx", "targetname");

	while(true)
	{
		trig3 waittill ("trigger", who);	
		who PlaySound ("splash");
		PlayFX( level._fx["Water"]["Splash"], who.origin );
		wait 1;
	}
}

bounce_slpash()
{
	trig4 = getent("bounce_splash", "targetname");

	while(true)
	{
		trig4 waittill ("trigger", who);	
		who PlaySound ("splash");
		PlayFX( level._fx["Water"]["Splash"], who.origin );
		wait 1;
	}
}

partymode()
{
	switch(randomint(2))
	{
	case 0:
		level.partymode = 0;
		//iprintlnbold("World");
		break;
	case 1:
		level.partymode = 1;
		ambientStop();
		//ambientPlay("party");
		while(1)
		{
		SetExpFog(1000, 2000, 1, 0, 0, 0);  
        wait 0.5;  
        SetExpFog(1000, 2000, 0, 1, 0, 0);  
        wait 0.5;  
        SetExpFog(1000, 2000, 0, 0, 1, 0);   
        wait 0.5;
        SetExpFog(1000, 2000, 1, 1, 0, 0);
        wait 0.5;
		}
	}
}

boat()
{
	boat_model = getent("boat","targetname");
	start = getent("start","targetname");
	t1 = getent("t1","targetname");
	t2 = getent("t2","targetname");
	t3 = getent("t3","targetname");
	t4 = getent("t4","targetname");
	t5 = getent("t5","targetname");
	t6 = getent("t4","targetname");
	t7 = getent("t5","targetname");
	t8 = getent("end","targetname");
	boat_trigger = getent("boat_trigger","targetname");

	boat_model moveTo(start.origin, 0.1);
	wait 0.1;

	boat_trigger waittill("trigger");
	while(1)
	{
		boat_model moveTo(t1.origin, 0.7);
		boat_model waittill( "movedone" );
		boat_model rotateYaw(-45,2.5);
		boat_model moveTo(t4.origin, 2.5, 0.5,0);
		boat_model waittill( "movedone" );
		boat_model rotateYaw(-45,2.5);
		boat_model moveTo(t2.origin, 2.5);
		boat_model waittill( "movedone" );
		boat_model rotateYaw(-45,2.5);
		boat_model moveTo(t5.origin, 2.5);
		boat_model waittill( "movedone" );
		boat_model rotateYaw(-45,2.5);
		boat_model moveTo(t3.origin, 2.5);
		boat_model waittill( "movedone" );
		boat_model moveTo(t8.origin, 1,0,0.5);
		boat_model waittill( "movedone" );
		boat_model Hide();
		boat_model notSolid();
		boat_model moveTo(start.origin, 0.1);
		wait 0.1;
		boat_model show();
		boat_model Solid();
		wait 0.01;
	}
}

boatb()
{
	boat_modelb = getent("boatb","targetname");
	startb = getent("startb","targetname");
	t1b = getent("t1b","targetname");
	t2b = getent("t2b","targetname");
	t3b = getent("t3b","targetname");
	t4b = getent("t4b","targetname");
	t5b = getent("t5b","targetname");
	t6b = getent("t4b","targetname");
	t7b = getent("t5b","targetname");
	t8b = getent("endb","targetname");
	boat_triggerb = getent("boat_triggerb","targetname");

	boat_modelb moveTo(startb.origin, 0.1);
	wait 0.1;

	boat_triggerb waittill("trigger");
	while(1)
	{
		boat_modelb moveTo(t1b.origin, 0.7);
		boat_modelb waittill( "movedone" );
		boat_modelb rotateYaw(-45,2.5);
		boat_modelb moveTo(t4b.origin, 2.5, 0.5,0);
		boat_modelb waittill( "movedone" );
		boat_modelb rotateYaw(-45,2.5);
		boat_modelb moveTo(t2b.origin, 2.5);
		boat_modelb waittill( "movedone" );
		boat_modelb rotateYaw(-45,2.5);
		boat_modelb moveTo(t5b.origin, 2.5);
		boat_modelb waittill( "movedone" );
		boat_modelb rotateYaw(-45,2.5);
		boat_modelb moveTo(t3b.origin, 2.5);
		boat_modelb waittill( "movedone" );
		boat_modelb moveTo(t8b.origin, 1,0,0.5);
		boat_modelb waittill( "movedone" );
		boat_modelb Hide();
		boat_modelb notSolid();
		boat_modelb moveTo(startb.origin, 0.1);
		wait 0.1;
		boat_modelb show();
		boat_modelb Solid();
		wait 0.01;
	}
}

spotlight_efxs()
{
	spot1 = getent("spot1","targetname"); 
	spot2 = getent("spot2","targetname"); 
	spot3 = getent("spot3","targetname"); 
	spot4 = getent("spot4","targetname"); 
	spot5 = getent("spot5","targetname"); 
	spot6 = getent("spot6","targetname"); 
	spot7 = getent("spot7","targetname"); 
	spot10 = getent("spot10","targetname"); 
	spot11 = getent("spot11","targetname"); 
	spot12 = getent("spot12","targetname"); 
	spot13 = getent("spot13","targetname"); 
	spot14 = getent("spot14","targetname"); 
	spot15 = getent("spot15","targetname"); 
	spot16 = getent("spot16","targetname"); 
	spot17 = getent("spot17","targetname"); 
	spot18 = getent("spot18","targetname"); 
	spot19 = getent("spot19","targetname"); 
	spot20 = getent("spot20","targetname"); 
	spot21 = getent("spot21","targetname"); 
	spot22 = getent("spot22","targetname"); 
	spot23 = getent("spot23","targetname"); 
	spot24 = getent("spot24","targetname"); 
	spot26 = getent("spot26","targetname"); 
	spot27 = getent("spot27","targetname"); 
	spot28 = getent("spot28","targetname"); 
	spot29 = getent("spot29","targetname"); 
	spot30 = getent("spot30","targetname"); 
	spot31 = getent("spot31","targetname"); 
	spot32 = getent("spot32","targetname"); 
	spot33 = getent("spot33","targetname"); 

	wait 3;

		playLoopedFX(level._fx["Light"]["Env"],0.5,spot1.origin + (0,0,0),0,anglesToForward(spot1.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot2.origin + (0,0,0),0,anglesToForward(spot2.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot3.origin + (0,0,0),0,anglesToForward(spot3.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot4.origin + (0,0,0),0,anglesToForward(spot4.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot5.origin + (0,0,0),0,anglesToForward(spot5.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot6.origin + (0,0,0),0,anglesToForward(spot6.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot7.origin + (0,0,0),0,anglesToForward(spot7.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot10.origin + (0,0,0),0,anglesToForward(spot10.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot11.origin + (0,0,0),0,anglesToForward(spot11.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot12.origin + (0,0,0),0,anglesToForward(spot12.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot13.origin + (0,0,0),0,anglesToForward(spot13.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot14.origin + (0,0,0),0,anglesToForward(spot14.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot15.origin + (0,0,0),0,anglesToForward(spot15.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot16.origin + (0,0,0),0,anglesToForward(spot16.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot17.origin + (0,0,0),0,anglesToForward(spot17.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot18.origin + (0,0,0),0,anglesToForward(spot18.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot19.origin + (0,0,0),0,anglesToForward(spot19.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot20.origin + (0,0,0),0,anglesToForward(spot20.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot21.origin + (0,0,0),0,anglesToForward(spot21.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot22.origin + (0,0,0),0,anglesToForward(spot22.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot23.origin + (0,0,0),0,anglesToForward(spot23.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot24.origin + (0,0,0),0,anglesToForward(spot24.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot26.origin + (0,0,0),0,anglesToForward(spot26.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot27.origin + (0,0,0),0,anglesToForward(spot27.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot28.origin + (0,0,0),0,anglesToForward(spot28.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot29.origin + (0,0,0),0,anglesToForward(spot29.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot30.origin + (0,0,0),0,anglesToForward(spot30.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot31.origin + (0,0,0),0,anglesToForward(spot31.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot32.origin + (0,0,0),0,anglesToForward(spot32.angles + (0,0,0)));
		playLoopedFX(level._fx["Light"]["Env"],0.5,spot33.origin + (0,0,0),0,anglesToForward(spot33.angles + (0,0,0)));
}

trap1()
{
	trap1_trigger = getent("trap1_trigger","targetname");
	level.fx_mover = getent("fire_move","targetname");
	level.fx_moverb = getent("fire_moveb","targetname");
	level.fx_mover2 = getent("fire_move2","targetname");
	level.fx_mover2b = getent("fire_move2b","targetname");
	hurt_trigger_trap1a = getent("trap1_hurt1","targetname");
	hurt_trigger_trap1b = getent("trap1_hurt2","targetname");

	hurt_trigger_trap1a thread maps\mp\_utility::triggerOff();
	hurt_trigger_trap1b thread maps\mp\_utility::triggerOff();

	level.fx_mover2b hide();
	level.fx_moverb hide();

}

move_fxtest()
{	
	

	level.fx_ent = spawn( "script_model", level.fx_mover.origin );
	level.fx_ent setModel( "tag_origin" );
	level.fx_ent linkto( level.fx_mover);
	level.fx_entb = spawn( "script_model", level.fx_mover.origin );
	level.fx_entb setModel( "tag_origin" );
	level.fx_entb linkto( level.fx_moverb);

	level.fx_moverb rotateYaw(180,0.1);
	
	wait 0.5;

	level.fx_mover thread move_test();
	level.fx_moverb thread move_test();

	playfxontag (level._fx["Fire"]["Trap1"], level.fx_ent, "tag_origin");
	playfxontag (level._fx["Fire"]["Trap1"], level.fx_entb, "tag_origin");
	wait 4;	
}

move_test()
{
	while(1)
	{
	self rotateYaw(360,1.8);
	wait 1.8;
	}	
}

move_fxtest2()
{	
	

	level.fx_ent2 = spawn( "script_model", level.fx_mover2.origin );
	level.fx_ent2 setModel( "tag_origin" );
	level.fx_ent2 linkto( level.fx_mover2);
	level.fx_ent2b = spawn( "script_model",level.fx_mover2.origin );
	level.fx_ent2b setModel( "tag_origin" );
	level.fx_ent2b linkto( level.fx_mover2b);

	level.fx_mover2b rotateYaw(180,0.1);
	
	wait 0.5;

	level.fx_mover2 thread move_test2();
	level.fx_mover2b thread move_test2();

	playfxontag (level._fx["Fire"]["Trap1"], level.fx_ent2, "tag_origin");
	playfxontag (level._fx["Fire"]["Trap1"], level.fx_ent2b, "tag_origin");
	wait 4;
	
}

move_test2()
{
	while(1)
	{
	self rotateYaw(-360,1.8);
	wait 1.8;
	}
}

trap2()
{
	trap2_trigger = getent("trap2_trigger","targetname"); //acti trigger
	log1 = getent("log1","targetname"); 
	log2 = getent("log2","targetname"); 
	log3 = getent("log3","targetname"); 
	log4 = getent("log4","targetname"); 
	orig1 = getent("orig1","targetname"); 
	orig2 = getent("orig2","targetname");
	orig3 = getent("orig3","targetname");
	orig4 = getent("orig4","targetname");
	static_logs = getent("static_logs","targetname");

	log1 moveTo(orig1.origin, 2, 0 , 0.5);
	log2 moveTo(orig2.origin, 2, 0 , 0.5);
	log3 moveTo(orig3.origin, 2, 0 , 0.5);
	log4 moveTo(orig4.origin, 2, 0 , 0.5);

}

Water_gush_efx()
{
	watergush1 = getent("Waterstreamfx3","targetname"); //acti trigger
	watergush2 = getent("Waterstreamfx2","targetname"); //acti trigger

	playLoopedFX(level._fx["Water"]["FallStreambig"],0.4,watergush1.origin + (0,-100,0),0,anglesToForward(watergush2.angles + (0,0,-70)));
	playLoopedFX(level._fx["Water"]["FallStreambig"],0.4,watergush2.origin + (20,0,5),0,anglesToForward(watergush2.angles + (0,0,0)));
}

water_hud()
{
	trig4 = getent("watervision", "targetname"); 
	
	while(1)
	{
	trig4 waittill ("trigger", who);	
	who shellshock( "jeepride_ridedeath", 3 );
	hud_Screen = NewClientHudElem(who);
    hud_Screen.horzalign = "fullscreen";
	hud_Screen.vertalign = "fullscreen";
	hud_Screen.alpha = 0.5;
	hud_Screen.color = (0, 0.2, 0.7);
	hud_Screen SetShader( "white", 640, 480 );
	who allowJump(false);
    who waittill("death");
    if(IsDefined(hud_Screen)) hud_Screen Destroy();
    
	}
}
//Adds a blue overlay and blurred vision when the trigger is touched!

platforms()
{
	trap1_1 = getent("trap1_1","targetname"); 
	trap1_2 = getent("trap1_2","targetname"); 
	trap1_3 = getent("trap1_3","targetname"); 
	trap1_4 = getent("trap1_4","targetname");
	trap1_5 = getent("trap1_5","targetname"); 
	trap1_6 = getent("trap1_6","targetname");  
	trap1_1_t1 = getent("trap1_1_t1","targetname"); 
	trap1_1_t2 = getent("trap1_1_t2","targetname");
	trap1_2_t1 = getent("trap1_2_t1","targetname");
	trap1_2_t2 = getent("trap1_2_t2","targetname");
	//trap1_3_t1 = getent("trap1_3_t1","targetname");
	//trap1_3_t2 = getent("trap1_3_t2","targetname");
	//trap1_4_t1 = getent("trap1_4_t1","targetname");
	//trap1_4_t2 = getent("trap1_4_t2","targetname");
	trap1_5_t1 = getent("trap1_5_t1","targetname");
	trap1_5_t2 = getent("trap1_5_t2","targetname");
	trap1_6_t1 = getent("trap1_6_t1","targetname");
	trap1_6_t2 = getent("trap1_6_t2","targetname");

	
	trap1_1 moveTo(trap1_1_t1.origin, 2, 0 , 0.5);
	trap1_2 moveTo(trap1_2_t1.origin, 2, 0 , 0.5);
	//trap1_3 moveTo(trap1_3_t1.origin, 2, 0 , 0.5);
	//trap1_4 moveTo(trap1_4_t1.origin, 2, 0 , 0.5);
	trap1_5 moveTo(trap1_5_t1.origin, 2, 0 , 0.5);
	trap1_6 moveTo(trap1_6_t1.origin, 2, 0 , 0.5);
	wait 3;

	while(1)
	{
		trap1_1 moveTo(trap1_1_t2.origin, 3, 0.5 , 0.5);
		trap1_2 moveTo(trap1_2_t2.origin, 3, 0.5 , 0.5);
	//	trap1_3 moveTo(trap1_3_t2.origin, 3, 0.5 , 0.5);
	//	trap1_4 moveTo(trap1_4_t2.origin, 3, 0.5 , 0.5);
		trap1_5 moveTo(trap1_5_t2.origin, 3, 0.5 , 0.5);
		trap1_6 moveTo(trap1_6_t2.origin, 3, 0.5 , 0.5);
		wait 3;
		trap1_1 moveTo(trap1_1_t1.origin, 3, 0.5 , 0.5);
		trap1_2 moveTo(trap1_2_t1.origin, 3, 0.5 , 0.5);
	//	trap1_3 moveTo(trap1_3_t1.origin, 3, 0.5 , 0.5);
	//	trap1_4 moveTo(trap1_4_t1.origin, 3, 0.5 , 0.5);
		trap1_5 moveTo(trap1_5_t1.origin, 3, 0.5 , 0.5);
		trap1_6 moveTo(trap1_6_t1.origin, 3, 0.5 , 0.5);
		wait 3;
	}
}

trap3()
{
	trap3_trigger = getent("trap3_trigger","targetname"); //acti trigger
	level.trap31_hurt = getent("trap31_hurt","targetname"); 
	level.trap32_hurt = getent("trap32_hurt","targetname"); 
	level.trap33_hurt = getent("trap33_hurt","targetname"); 

	level.trap31_hurt thread maps\mp\_utility::triggerOff();
	level.trap32_hurt thread maps\mp\_utility::triggerOff();
	level.trap33_hurt thread maps\mp\_utility::triggerOff();


	
}

trap3_1()
{
	trap31a = getent("trap3_1a","targetname"); 
	trap31b = getent("trap3_1b","targetname"); 
	trap31 = getent("trap3_1","targetname"); 


	level.fx_ent3 = spawn( "script_model", trap31.origin );
	level.fx_ent3.angles = (270,89.3558,90.6442);
	level.fx_ent3 setModel( "tag_origin" );
	level.fx_ent3 linkto( trap31);
	level.trap31_hurt thread maps\mp\_utility::triggerOn();
		level.trap31_hurt enableLinkTo();
	level.trap31_hurt linkTo(trap31);
	wait 0.5;

	playfxontag (level._fx["Light2"]["Env"], level.fx_ent3, "tag_origin");
	wait 0.1;

	while(1)
	{
		trap31 moveTo(trap31b.origin, 1);
		wait 1;
		trap31 moveTo(trap31a.origin, 1);
		wait 1;
	}
}

trap3_2()
{
	trap32a = getent("trap3_2a","targetname"); 
	trap32b = getent("trap3_2b","targetname"); 
	trap32 = getent("trap3_2","targetname"); 

	level.fx_ent4 = spawn( "script_model", trap32.origin );
	level.fx_ent4.angles = (270,89.3558,90.6442);
	level.fx_ent4 setModel( "tag_origin" );
	level.fx_ent4 linkto( trap32);
	level.trap32_hurt thread maps\mp\_utility::triggerOn();

	level.trap32_hurt enableLinkTo();
	level.trap32_hurt linkTo(trap32);
	
	wait 0.5;

	playfxontag (level._fx["Light2"]["Env"], level.fx_ent4, "tag_origin");
	wait 0.1;

	while(1)
	{
		trap32 moveTo(trap32b.origin, 1);
		wait 1;
		trap32 moveTo(trap32a.origin, 1);
		wait 1;
	}
}

trap3_3()
{
	trap33a = getent("trap3_3a","targetname"); 
	trap33b = getent("trap3_3b","targetname"); 
	trap33 = getent("trap3_3","targetname"); 

	level.fx_ent5 = spawn( "script_model", trap33.origin );
	level.fx_ent5.angles = (270,89.3558,90.6442);
	level.fx_ent5 setModel( "tag_origin" );
	level.fx_ent5 linkto( trap33);
	level.trap33_hurt thread maps\mp\_utility::triggerOn();

	level.trap33_hurt enableLinkTo();
	level.trap33_hurt linkTo(trap33);
	
	wait 0.5;

	playfxontag (level._fx["Light2"]["Env"], level.fx_ent5, "tag_origin");
	wait 0.1;

	while(1)
	{
		trap33 moveTo(trap33b.origin, 1);
		wait 1;
		trap33 moveTo(trap33a.origin, 1);
		wait 1;
	}
}

trap4()
{
	trap4_trigger = getent("trap4_trigger","targetname"); //acti trigger
	level.trap4 = getent("trap4","targetname"); 
	level.trap41_hurt = getent("trap41_hurt","targetname"); 

	level.trap41_hurt thread maps\mp\_utility::triggerOff();

	
}

trap4_1()
{
	level.fx_ent5 = spawn( "script_model", level.trap4.origin + (0,0,132));
	level.fx_ent5.angles = (0,270,0);
	level.fx_ent5 setModel( "tag_origin" );
	level.fx_ent5 linkto( level.trap4);
	
	wait 0.5;

	playfxontag (level._fx["Water"]["Water_Pour"], level.fx_ent5, "tag_origin");
	wait 0.1;
}

trap4_2()
{
	level.fx_ent6 = spawn( "script_model", level.trap4.origin + (0,0,42) );
	level.fx_ent6.angles = (0,270,0);
	level.fx_ent6 setModel( "tag_origin" );
	level.fx_ent6 linkto( level.trap4);
	
	wait 0.5;

	playfxontag (level._fx["Water"]["Water_Pour"], level.fx_ent6, "tag_origin");
	wait 0.1;
}

bounce()
{
	while(1)
	{	
    	level.trap41_hurt waittill ("trigger",user);
		if (user istouching(level.trap41_hurt))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,1,0)) ), 1000 );		
		}
	}
}

trap5()
{
	trap5_trigger = getent("trap5_trigger","targetname");
	trap5_fx = getent("lava_fx","targetname");
	trap5_lava = getent("lava_pourhurt","targetname");
	FX = undefined;

	trap5_lava thread maps\mp\_utility::triggerOff();

	
}


trap6()
{
	trap6_trigger = getent("trap6_trigger","targetname"); //acti trigger
	log16 = getent("trap6_log1","targetname"); 
	log26 = getent("trap6_log2","targetname"); 
	log36 = getent("trap6_log3","targetname"); 
	log46 = getent("trap6_log4","targetname"); 
	orig61 = getent("trap6_orig1","targetname"); 
	orig62 = getent("trap6_orig2","targetname");
	orig63 = getent("trap6_orig3","targetname");
	orig64 = getent("trap6_orig4","targetname");
	orig612 = getent("trap6_orig12","targetname"); 
	orig622 = getent("trap6_orig22","targetname");
	orig632 = getent("trap6_orig32","targetname");
	orig642 = getent("trap6_orig42","targetname");
	trap6_static_logs = getent("trap6_static_logs","targetname");
	trap6_wall = getent("trap6_wall","targetname"); 
	trap6_wall2 = getent("trap6_wall1","targetname"); 

	log16 moveTo(orig61.origin, 2, 0 , 0.5);
	log26 moveTo(orig62.origin, 2, 0 , 0.5);
	log36 moveTo(orig63.origin, 2, 0 , 0.5);
	log46 moveTo(orig64.origin, 2, 0 , 0.5);
	trap6_wall Movex(2560, 0.1);
	trap6_wall2 Movex(2060, 0.1);
	wait 0.2;
	trap6_wall Movez(-600, 0.1);
	trap6_wall2 Movez(-600, 0.1);
	wait 0.2;


}

trap7()
{
	trap7_trigger = getent("trap8_trigger","targetname"); 
	level.trap7_bounce = getent("trap7_trigger","targetname"); 
	orig71 = getent("trap7_streamfx","targetname"); 
	orig72 = getent("trap7_streamfx2","targetname"); 
	level.fx_ent71 = spawn( "script_model", orig71.origin );
	level.fx_ent71 setModel( "tag_origin" );
	level.fx_ent71.angles = orig71.angles;
	level.fx_ent72 = spawn( "script_model", orig72.origin );
	level.fx_ent72 setModel( "tag_origin" );
	level.fx_ent72.angles = orig72.angles + (0,-270,0);

	level.trap7_bounce thread maps\mp\_utility::triggerOff();

	
}

bounce2()
{
	while(1)
	{	
    	level.trap7_bounce  waittill ("trigger",user);
		if (user istouching(level.trap7_bounce))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,-1,0)) ), 1000 );		
		}
		wait 0.05;
	}
}

trap8()
{
	trap8_trigger = getent("trap9_trigger","targetname"); //acti trigger
	level.trap81_hurt = getent("trap81_hurt","targetname"); 
	level.trap82_hurt = getent("trap82_hurt","targetname"); 
	level.trap83_hurt = getent("trap83_hurt","targetname"); 

	level.trap81_hurt thread maps\mp\_utility::triggerOff();
	level.trap82_hurt thread maps\mp\_utility::triggerOff();
	level.trap83_hurt thread maps\mp\_utility::triggerOff();


	
}

trap8_1()
{
	trap81a = getent("trap8_1a","targetname"); 
	trap81b = getent("trap8_1b","targetname"); 
	trap81 = getent("trap8_1","targetname"); 


	level.fx_ent7 = spawn( "script_model", trap81.origin );
	level.fx_ent7.angles = (270,89.3558,90.6442);
	level.fx_ent7 setModel( "tag_origin" );
	level.fx_ent7 linkto( trap81);
	level.trap81_hurt thread maps\mp\_utility::triggerOn();
		level.trap81_hurt enableLinkTo();
	level.trap81_hurt linkTo(trap81);
	wait 0.5;

	playfxontag (level._fx["Light3"]["Env"], level.fx_ent7, "tag_origin");
	wait 0.1;

	while(1)
	{
		trap81 moveTo(trap81a.origin, 1);
		wait 1;
		trap81 moveTo(trap81b.origin, 1);
		wait 1;
	}
}

trap8_2()
{
	trap82a = getent("trap8_2a","targetname"); 
	trap82b = getent("trap8_2b","targetname"); 
	trap82 = getent("trap8_2","targetname"); 

	level.fx_ent8 = spawn( "script_model", trap82.origin );
	level.fx_ent8.angles = (270,89.3558,90.6442);
	level.fx_ent8 setModel( "tag_origin" );
	level.fx_ent8 linkto( trap82);
	level.trap82_hurt thread maps\mp\_utility::triggerOn();

	level.trap82_hurt enableLinkTo();
	level.trap82_hurt linkTo(trap82);
	
	wait 0.5;

	playfxontag (level._fx["Light3"]["Env"], level.fx_ent8, "tag_origin");
	wait 0.1;

	while(1)
	{
		trap82 moveTo(trap82a.origin, 1);
		wait 1;
		trap82 moveTo(trap82b.origin, 1);
		wait 1;
	}
}

trap8_3()
{
	trap83a = getent("trap8_3a","targetname"); 
	trap83b = getent("trap8_3b","targetname"); 
	trap83 = getent("trap8_3","targetname"); 

	level.fx_ent9 = spawn( "script_model", trap83.origin );
	level.fx_ent9.angles = (270,89.3558,90.6442);
	level.fx_ent9 setModel( "tag_origin" );
	level.fx_ent9 linkto( trap83);
	level.trap83_hurt thread maps\mp\_utility::triggerOn();

	level.trap83_hurt enableLinkTo();
	level.trap83_hurt linkTo(trap83);
	
	wait 0.5;

	playfxontag (level._fx["Light3"]["Env"], level.fx_ent9, "tag_origin");
	wait 0.1;

	while(1)
	{
		trap83 moveTo(trap83a.origin, 1);
		wait 1;
		trap83 moveTo(trap83b.origin, 1);
		wait 1;
	}
}

trap9() //Artillery trap
{
	trap9_trigger = getent("trap10_trigger","targetname"); //acti trigger
	level.plane_start = getent("plane_start","targetname"); 
	level.plane_end = getent("plane_end","targetname"); 
	level.strikecoord = getent("strike_coord","targetname"); 
	level.trap9_kill = getent("trap9_kill","targetname"); 

	level.trap9_kill thread maps\mp\_utility::triggerOff();

	
}

callStrike()
{	
	// Get starting and ending point for the plane
	owner = level.activ;
	direction = level.plane_start.angles;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;
	
	startpoint = level.plane_start;
	endPoint = level.plane_end;
	
	// Make the plane fly by
	flyTime = ( 34816 / planeFlySpeed );
	
	level thread doPlaneStrike(startPoint, endPoint, flyTime, direction);
	wait 1;
}

doPlaneStrike(startPoint, endPoint, flyTime, direction)
{
	owner = getentarray( "player", "classname" )[0]; 

	
	// Spawn the planes
	plane = spawnplane(owner, "script_model", startpoint.origin );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	playfxontag( level._fx["Fire"]["Trap1"] , plane, "tag_engine_right" );
	playfxontag( level._fx["Fire"]["Trap1"] , plane, "tag_engine_left" );
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
	fx1 = getent("trap9_fx1","targetname"); 
	fx2 = getent("trap9_fx2","targetname");  
	fx3 = getent("trap9_fx3","targetname"); 
	fx4 = getent("trap9_fx4","targetname");  
	fx5 = getent("trap9_fx5","targetname"); 
	fx6 = getent("trap9_fx6","targetname"); 

	level.trap9_kill thread maps\mp\_utility::triggerOn();
	thread killplayers();
	playRumbleOnPosition( "artillery_rumble", fx3 );
	earthquake( 0.7, 0.75, fx3.origin, 1000 );
	PlayFX(level.airstrikefx, fx1.origin);
	fx1 PlaySound("artillery_impact");
	wait 0.2;
	PlayFX(level.airstrikefx, fx2.origin);
	fx2 PlaySound("artillery_impact");
	wait 0.2;
	PlayFX(level.airstrikefx, fx3.origin);
	fx3 PlaySound("artillery_impact");
	wait 0.2;
	PlayFX(level.airstrikefx, fx4.origin);
	fx4 PlaySound("artillery_impact");
	wait 0.2;
	PlayFX(level.airstrikefx, fx5.origin);
	fx5 PlaySound("artillery_impact");
	wait 0.2;
	PlayFX(level.airstrikefx, fx6.origin);
	fx6 PlaySound("artillery_impact");
	wait 0.2;
	level.trap9_kill thread maps\mp\_utility::triggerOff();
}

killplayers()
{
	while(1)
	{	
    	level.trap9_kill  waittill ("trigger",user);
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

old()
{
	level.old_trigger = getEnt( "old_trig", "targetname"); //The trigger
	level.sniper_trigger = getent("sniper_trig","targetname");
	level.shot_trigger = getent("shot_trig","targetname");
	level.knife_trigger = getent("knife_trig","targetname");
	level.weap_trigger = getent("weapon_trig","targetname");
	level.bounce_trigger = getent("bounce_trig","targetname");
	old_orig = getEnt ("old_orig", "targetname");

	for(;;)
	{
		level.old_trigger waittill ("trigger", player);
		level.shot_trigger delete();
    level.sniper_trigger delete();
    level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered
    level.weap_trigger delete();
    level.bounce_trigger delete();
		iPrintlnBold( " ^6" + player.name + " ^2went into the old room!" ); // announces on screen the player name and the knife room
		player SetOrigin(old_orig.origin);
		player SetPlayerAngles( old_orig.angles );
		wait 1;
	}
}

sniperroom()
{
level.old_trigger = getEnt( "old_trig", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
level.weap_trigger = getent("weapon_trig","targetname");
level.bounce_trigger = getent("bounce_trig","targetname");
jumpk = getEnt( "whole_area_jumper", "targetname" ); //the origin the jumper will teleport
actik = getEnt( "whole_area_acti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.sniper_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.sniper_trigger ) ) //defines that it is the knife trigger
	return;

		level.shot_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        level.weap_trigger delete();
        level.bounce_trigger delete();
        
	player SetPlayerAngles( jumpk.angles );
	player setOrigin( jumpk.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "remington700_mp" ); //jumper weapon 
	player GiveWeapon( "m40a3_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("remington700_mp");
	player giveMaxAmmo("remington700_mp"); 
	player giveMaxAmmo("m40a3_mp"); 

	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2went into the sniper room!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik.angles );
		level.activ setOrigin( actik.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "remington700_mp" ); //gives acti tomahawk
		level.activ GiveWeapon( "m40a3_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "remington700_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("remington700_mp");
		level.activ giveMaxAmmo("m40a3_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

kniferoom()
{
level.old_trigger = getEnt( "old_trig", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
level.weap_trigger = getent("weapon_trig","targetname");
level.bounce_trigger = getent("bounce_trig","targetname");
jumpk = getEnt( "small_area_jumper", "targetname" ); //the origin the jumper will teleport
actik = getEnt( "small_area_acti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.knife_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.knife_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.shot_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        level.weap_trigger delete();
        level.bounce_trigger delete();
        
	player SetPlayerAngles( jumpk.angles );
	player setOrigin( jumpk.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "tomahawk_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("tomahawk_mp");
	//player giveMaxAmmo("m1014_grip_mp"); 
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2went into the knife room!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik.angles );
		level.activ setOrigin( actik.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "tomahawk_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "tomahawk_mp" ); //this line means they switch to the weapon
		//level.activ giveMaxAmmo("m1014_grip_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

shotroom()
{
level.old_trigger = getEnt( "old_trig", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
level.weap_trigger = getent("weapon_trig","targetname");
level.bounce_trigger = getent("bounce_trig","targetname");
jumpk = getEnt( "whole_area_jumper", "targetname" ); //the origin the jumper will teleport
actik = getEnt( "whole_area_acti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.shot_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.shot_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        level.weap_trigger delete();
        level.bounce_trigger delete();
        
	player SetPlayerAngles( jumpk.angles );
	player setOrigin( jumpk.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "m1014_grip_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("m1014_grip_mp");
	player giveMaxAmmo("m1014_grip_mp"); 
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2went into the shotgun room!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik.angles );
		level.activ setOrigin( actik.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "m1014_grip_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "m1014_grip_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("m1014_grip_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

weaproom()
{
level.old_trigger = getEnt( "old_trig", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
level.weap_trigger = getent("weapon_trig","targetname");
level.bounce_trigger = getent("bounce_trig","targetname");
jumpk = getEnt( "whole_area_jumper", "targetname" ); //the origin the jumper will teleport
actik = getEnt( "whole_area_acti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.weap_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.weap_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        level.shot_trigger delete();
        level.bounce_trigger delete();
        
	player SetPlayerAngles( jumpk.angles );
	player setOrigin( jumpk.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "ak74u_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("ak74u_mp");
	player giveMaxAmmo("ak74u_mp"); 
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2went into the weapon room!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik.angles );
		level.activ setOrigin( actik.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "ak74u_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "ak74u_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("ak74u_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}


bounceroom()
{
level.old_trigger = getEnt( "old_trig", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
level.weap_trigger = getent("weapon_trig","targetname");
level.bounce_trigger = getent("bounce_trig","targetname");
level.bouncej = getEnt( "bouncej_orig", "targetname" ); //the origin the jumper will teleport
level.bouncea = getEnt( "bouncea_orig", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.bounce_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.bounce_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        level.shot_trigger delete();
        level.weap_trigger delete();
        
	player SetPlayerAngles( level.bouncej.angles );
	player setOrigin( level.bouncej.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "knife_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("knife_mp");
	//player giveMaxAmmo("knife_mp"); 
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2went into the bounce room!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( level.bouncea.angles );
		level.activ setOrigin( level.bouncea.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "knife_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "knife_mp" ); //this line means they switch to the weapon
		//level.activ giveMaxAmmo("knife_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}


jump_respawn()
{
	trigger = getent ( "bounce_fail", "targetname" );
	for(;;)
	{
		trigger waittill ( "trigger", player );
	
		if( player.pers[ "team" ] != "spectator" )
		{
			if( player.pers[ "team" ] == "allies" )
			{
				player SetPlayerAngles ( level.bouncej.angles );
				player SetOrigin ( level.bouncej.origin );
			}
			if( player.pers[ "team" ] == "axis" )
			{
				player SetPlayerAngles ( level.bouncea.angles );
				player SetOrigin ( level.bouncea.origin );
			}
		}
	}
}
//From waterworld hope anyone doesnt mind I borrowed it :p

bounce_weapon()
{
trig = getent("gear","targetname");

while(1)
{
	trig waittill("trigger", player);
	player takeallweapons();
	player giveweapon("rpg_mp");
	player switchtoweapon("rpg_mp");
	player giveMaxAmmo("rpg_mp");
	player giveweapon("colt44_mp");
	player giveMaxAmmo("colt44_mp");
	wait 10;
	}
}