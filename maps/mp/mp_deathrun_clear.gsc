#include common_scripts\utility;

main()
{
	
//////////////////////////////thready////////////
        thread smrt ();
        //thread heli();
        //thread strela();
       // thread teleport();			
		
        maps\mp\_load::main();
	
	//maps\mp\mp_deathrun_clear_script::main();
	//maps\mp\mp_deathrun_clear_door::main();

	thread sr\api\_map::createSpawn((2612, 828, 108), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-768.674, 677.165, 32.125), 165, 195, "normal_0");

	thread trap_adjustments();
	thread custom_tp();
    
	
	//ambientPlay("clear");

////////////////////////////////efekty////////////////////////

	level._effect[ "dym" ] = loadfx( "smoke/emitter_rocket_trail" );
	level._effect[ "prach" ] = loadfx( "treadfx/heli_dust_jeepride" );
	level._effect[ "boom" ] = loadfx( "explosions/suitcase_explosion" );
	level._effect[ "laser" ] = loadfx( "misc/laser" );
	
//////////////////////////////////global////////////////////////////

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

//////////////////////////////////////////deathrun/////////////////////

        level.trapTriggers = [];
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t1", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t2", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t3", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t4", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t5", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t6", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t7", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t8", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t9", "targetname" );
	    level.trapTriggers[level.trapTriggers.size] = getEnt( "t10", "targetname" );	
	    level.trapTriggers[level.trapTriggers.size] = getEnt( "t11", "targetname" );	
	    level.trapTriggers[level.trapTriggers.size] = getEnt( "l1", "targetname" );	
		level.trapTriggers[level.trapTriggers.size] = getEnt( "l2", "targetname" );	
		level.trapTriggers[level.trapTriggers.size] = getEnt( "l4", "targetname" );	
		
}
trap_adjustments()
{
brush_1 = getEnt("t1_door","targetname");
brush_2 = getEnt("t2_kill","targetname");
brush_3 = getEnt("laser1_trig","targetname");
brush_4 = getEnt("laser2_trig","targetname");
brush_5 = getEnt("t10_dvere","targetname");
brush_6 = getEnt("t11_door","targetname");

wait 0.1;

brush_1 delete();
brush_2 delete();
brush_3 delete();
brush_4 delete();
brush_5 delete();
brush_6 delete();
			

}
smrt()
{
	trig = getent("smrt", "targetname");

	trig waittill("trigger",player);
	                 	

	for(;;)
	{
		trig waittill("trigger",player);

		player suicide();
	}
}
custom_tp()
{
	trig = spawn("trigger_radius",(-948.834, -2040.35, 32.125), 0, 80, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(-1135,-1191,92));
	ori_t.angles = (0,74,0);

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

/*smrt_think()
{
	while (1)
	{
		self waittill ("trigger",other);
		
		if(isPlayer(other))
			other thread smrt_kill(self);
	}
}

smrt_kill(trigger)
{
	if(isDefined(self.smrt))
		return;
		
	self.smrt = true;

	if(isdefined(self) && self istouching(trigger))
	{
		origin = self getorigin();
		range = 10;
		maxdamage = 20;
		mindamage = 10;

		radiusDamage(origin, range, maxdamage, mindamage);
                wait 0.5;
	}
	
	self.smrt = undefined;
}*/

teleport()
{
	entTransporter = getentarray( "enter", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
	}
}
 
transporter()
{
	while(true)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

heli()
{
heli = getent( "heli" , "targetname" );
orig2 = getent( "heli2" , "targetname" );
orig1 = getent( "heli1" , "targetname" );
door = getent( "door_c_trig" , "targetname" );

heli moveto ( (2560.7, 1600, 423.2), 0.05 );

wait 2;

heli PlayLoopSound ("blackhawk_idle_low1");
heli movez ( 368, 5, 2, 1 );
orig1 thread prach();
heli waittill ("movedone");
heli rotatePitch( 10, 3, 0.8, 0.8  );
wait 1;
orig1 notify("hotovo");

heli movex ( -3136, 10, 2, 1 );
wait 8;
heli rotatePitch( -10, 3, 0.8, 0.8  );
wait 1;
orig2 thread prach();
wait 1;
heli movez ( -368, 5, 2, 1 );
heli waittill ("movedone");
door waittill ("trigger");
heli movez ( 368, 5, 2, 1 );
wait 4;
heli rotateyaw( -90, 3, 0.8, 0.8  );
wait 3;

heli rotatePitch( 10, 3, 0.8, 0.8  );
wait 1;
heli movey ( 20000, 50, 10, 5 );
wait 3;
orig2 notify("hotovo");
heli waittill ("movedone");
heli delete();
}

prach()
{
self endon("hotovo");

while (1)
{
PlayFX(level._effect["prach"], self.origin );
wait 0.4;
}
}

strela()
{
strela = getent( "strela" , "targetname" );
kryt = getent( "kryt" , "targetname" );
dym = getent( "dym" , "targetname" );
dirt = getent( "dirt" , "targetname" );
delete_raketa = getent( "delete_raketa" , "targetname" );
delete_raketa2 = getent( "delete_raketa2" , "targetname" );
trosky = getent( "trosky" , "targetname" );
kill = getent( "t0_kill" , "targetname" );
trig = getent( "t0_trig" , "targetname" );
spawn = getent( "spawn_trig" , "targetname" );

dirt movez (-5, 0.05);
trosky movez (-20, 0.05);

wait 65;
strela playsound ("start_raketa1");
wait 1.5;
kryt delete();


c = 2;
strela movez ( 20624, c );
fx = PlayFX(level._effect["dym"], dym.origin );

wait c;

strela rotatePitch( 90, 1, 0.4, 0.4  );

strela movex ( 2624, 3 );
wait 3;
strela movey ( 960, 3 );

wait 3;

strela rotatePitch( 90, 1, 0.4, 0.4  );

strela movez ( -20624, c);

wait c;

fx = PlayFX(level._effect["boom"], strela.origin );
strela playsound ("airstrike_explosion1");

trig enableLinkTo();
trig linkTo( kill );
kill movez (560, 0.05);

kill waittill ("movedone");
trig unLink();
trig delete();
kill delete();
		
strela delete ();
delete_raketa delete ();
delete_raketa2 delete ();
dirt movez (5, 0.05);
trosky movez (20, 0.05);
}

