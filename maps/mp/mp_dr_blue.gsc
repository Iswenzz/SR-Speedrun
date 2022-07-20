/*#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
*/
                                                                   //Map Made by Poyser
																   // Add amb2.mp3 to mp_dr_blue.iwd/sound/ if you wish (its linked to soundaliases "skrillex")
main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
level.masterSpawn = spawn("script_origin", level.spawn["allies"][6].origin);
level.masterSpawn.angles = level.spawn["allies"][6].angles;
level.masterSpawn placeSpawnPoint();
trigger = spawn( "trigger_radius", (4582, 2556, -1714), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
             //Please Use without Permission ©
    maps\mp\_load::main();
	// setExpFog(500, 1000, 0.4, 0.425, 0.44, 0.0);
level.prop = LoadFX("blue/up");
level.ring = LoadFX("blue/blue");
level.gate = LoadFX("blue/gate");
level.prop = LoadFX("blue/up");
level.kool = LoadFX("blue/pro");
level.b = LoadFX("blue/bou");
level.t = LoadFX("blue/tx");
level.e = LoadFX("blue/ends");
level.shower = LoadFX("blue/blue_shower");
level.knife_fx = LoadFX("blue/blue_ball");
level.sm = LoadFX("blue/sm");
level.fog = LoadFX("blue/fog");


	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	// PreCacheItem("colt44_mp");
	// PreCacheItem("colt45_silencer_mp");
	// PreCacheItem("colt45_mp");
	// PreCacheItem("deserteagle_mp");
	// PreCacheItem("mp5_silencer_mp");
	// PreCacheItem("ak74u_silencer_mp");
	// PreCacheItem("ak47_mp");
	// PreCacheItem("uzi_silencer_mp");

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread way_connect();
	// thread addtriggers();
	// thread addTestClients();
	// thread help();
    thread onPlayerConnect();
	thread X();
	// thread lights();
	thread gate();
	thread end();
	//thread end2();
	thread smile1();
	thread smile2();
	thread smile3();
	// thread WatchSniper();
	// thread WatchKnife();
	// thread WatchPistol();
	// thread WatchSpec();
	// thread WatchSlick();
	// thread WatchMaze();
	thread jumper1();
	thread jumper2();
	thread jumper3();
	thread jumper4();
	thread jumper5();
	thread jumper6();
	thread jumper7();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	thread trap8(); // Let this one
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	// thread fog();
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


fog()
{
	f = getent ("fogg" ,"targetname");

	// PlayFX( level.fog, f.origin);
}
addtriggers()
{
    addTriggerToList("t1t");
   addTriggerToList("t2t");
   addTriggerToList("t3t");
   addTriggerToList("t4t");
   addTriggerToList("t5t");
    addTriggerToList("t6t");
   addTriggerToList("t7t");
   addTriggerToList("t8t");
   addTriggerToList("t9t");
   addTriggerToList("t10t");
    addTriggerToList("t11t");
   addTriggerToList("t_newt");
    addTriggerToList("t_new2t");
}

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
		player SetClientDvars("r_fullbright", 1, "r_fog", 1, "fx_enable", 1 );
	}
}
onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self SetClientDvars("r_fullbright", 1, "r_fog", 1, "fx_enable", 1 );
		self.x1 = undefined;
		self.x2 = undefined;
		self.x3 = undefined;
		self.x4 = undefined;
		self.x5 = undefined;
		self.x6 = undefined;
		self.x7	= undefined;
	}
}
lights()
{

	wait 0.5;
	// thread adv_light();
}

adv_light()
{
	self SetClientDvars("r_dLightLimit", 4, "r_distortion", 1 );
	// SetExpFog( 128, 768, 0, 0, 0, 3 );
	sunlight = 1.3;
	while(sunlight>0.34)
	{
		sunlight -= 0.5;
		wait 0.2;
		self SetClientDvar("r_lightTweakSunLight", sunlight );
	}
	self SetClientDvar("r_lightTweakSunLight", 0 );
	wait 1;
}
X()
{
	thread blue();
	// thread bbe();
	thread tx();
	  x = getent ("smile9_fx" ,"targetname");
    PlayFX( level.sm, x.origin);
	/*thread ring1();
	thread ring2();
	thread ring3();
	thread ring4();
	thread ring5();
	thread ring6();*/
	// ambientPlay("krewella");
	thread misc();
	thread ends();
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
}

blue()
{
    gate = getent ("gate_portal" ,"targetname");
	gate2 = getent ("gate_portal2" ,"targetname");
	m1 = getent ("smokei" ,"targetname");
	m2 = getent ("smokei2" ,"targetname");
	p1 = getent ("up1" ,"targetname");
	p2 = getent ("up2" ,"targetname");
	p3 = getent ("up3" ,"targetname");
	p4 = getent ("up4" ,"targetname");
	p5 = getent ("up1" ,"targetname");
	p6 = getent ("up2" ,"targetname");
	p7 = getent ("up3" ,"targetname");
	p8 = getent ("up4" ,"targetname");
	g1 = getent ("glow1" ,"targetname");
	g2 = getent ("glow2" ,"targetname");
	g3 = getent ("glow3" ,"targetname");
	g4 = getent ("glow4" ,"targetname");
	g5 = getent ("glow5" ,"targetname");
	g6 = getent ("glow6" ,"targetname");
	s = (0,0,0);

	PlayFX( level.gate, gate.origin);
	wait 1;
	// PlayFX( level.fog, m1.origin);
	// PlayFX( level.fog, m2.origin);
	PlayFX( level.gate, gate2.origin);
	wait 1;
	PlayFX( level.ring, gate.origin);
	wait 1;
	PlayFX( level.ring, gate2.origin);
	wait 1;
	PlayFX( level.prop, p1.origin);
	wait 1;
	PlayFX( level.prop, p2.origin);
	wait 1;
	PlayFX( level.prop, p3.origin);
	wait 1;
	PlayFX( level.prop, p4.origin);
	wait 1;
	PlayFX( level.prop, p5.origin);
	wait 1;
	PlayFX( level.prop, p6.origin);
	wait 1;
	PlayFX( level.prop, p7.origin);
	wait 1;
	PlayFX( level.prop, p8.origin);
	wait 1;
	PlayFX( level.gate, g1.origin);
	wait 1;
	PlayFX( level.gate, g2.origin);
	wait 1;
	PlayFX( level.gate, g3.origin);
	wait 1;
	PlayFX( level.gate, g4.origin);
	wait 1;
	PlayFX( level.gate, g5.origin);
	wait 1;
	PlayFX( level.gate, g6.origin);
	wait 1;
	playLoopedFx(level.shower, 1, s);
	wait 1;
	//EarthQuake( 100, 5, gate, 200 );

}
fov()
{
	self endon("disconnect");
        while(1)
	{
                while(!self secondaryoffhandButtonPressed())
                {
                        wait 0.05;
                }
		self SetClientDvar("cg_fovscale", 1.4 );

                  while(!self MeleebuttonPressed())
                        {
                        wait 0.05;
                }
	 self SetClientDvar("cg_fovscale", 1 );



         }
}

bbe()
{
b1 = getent ("b1" ,"targetname");
b2 = getent ("b2" ,"targetname");
b3 = getent ("b3" ,"targetname");
b4 = getent ("b4" ,"targetname");
b5 = getent ("b5" ,"targetname");
b6 = getent ("b6" ,"targetname");
b7 = getent ("b7" ,"targetname");
b8 = getent ("b8" ,"targetname");
b9 = getent ("b9" ,"targetname");
b10 = getent ("b10" ,"targetname");
b11 = getent ("b11" ,"targetname");
b12 = getent ("b12" ,"targetname");


	PlayFX( level.b, b1.origin);
	wait 1;
	PlayFX( level.b, b2.origin);
	wait 1;
	PlayFX( level.b, b3.origin);
	wait 1;
	PlayFX( level.b, b4.origin);
	wait 1;
	PlayFX( level.b, b5.origin);
	wait 1;
	PlayFX( level.b, b6.origin);
	wait 1;
	PlayFX( level.b, b7.origin);
	wait 1;
	PlayFX( level.b, b8.origin);
	wait 1;
	PlayFX( level.b, b9.origin);
	wait 1;
	PlayFX( level.b, b10.origin);
	wait 1;
	PlayFX( level.b, b11.origin);
	wait 1;
	PlayFX( level.b, b12.origin);
	wait 1;
}
tx()
{
t1 = getent ("t1x" ,"targetname");
t2 = getent ("t2x" ,"targetname");
t3 = getent ("t3x" ,"targetname");
t4 = getent ("t4x" ,"targetname");
t5 = getent ("t5x" ,"targetname");
t6 = getent ("t6x" ,"targetname");
t7 = getent ("t7x" ,"targetname");
t8 = getent ("t8x" ,"targetname");
t9 = getent ("t9x" ,"targetname");
t10 = getent ("t10x" ,"targetname");
t11 = getent ("t11x" ,"targetname");
t12 = getent ("t_newx" ,"targetname");
t13 = getent ("t_new2x" ,"targetname");

	PlayFX( level.t, t1.origin);
	wait 1;
	PlayFX( level.t, t2.origin);
	wait 1;
	PlayFX( level.t, t3.origin);
	wait 1;
	PlayFX( level.t, t4.origin);
	wait 1;
	PlayFX( level.t, t5.origin);
	wait 1;
    PlayFX( level.t, t6.origin);
	wait 1;
	PlayFX( level.t, t7.origin);
	wait 1;
	PlayFX( level.t, t8.origin);
	wait 1;
	PlayFX( level.t, t9.origin);
	wait 1;
	PlayFX( level.t, t10.origin);
	wait 1;
	PlayFX( level.t, t11.origin);
	wait 1;
	PlayFX( level.t, t12.origin);
	wait 1;
	PlayFX( level.t, t13.origin);
	wait 1;
}
misc()
{
   	a1 = getent ("air1" ,"targetname");

	r = Spawn("script_model", (0,0,0) );
	r.origin = a1.origin;
	r SetModel("tag_origin");
	wait 0.05;
	PlayFXOnTag( level.kool, r, "tag_origin" );
	r rotatePitch(-180,1);
	s = Spawn("script_model", (0,0,0) );
	s.origin = a1.origin;
	s SetModel("tag_origin");
	wait 0.05;
	PlayFXOnTag( level.kool, s, "tag_origin" );
	r rotatePitch(180,1);
	wait 1;
}
gate()
{
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
			self PlaySound("tfx");
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}
jumper1()
{
	jumpx = getent ("jump","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j1();
	}
}

j1()
{
	if(isDefined(self.x1))
		return;

	self.x1 = true;

	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	time = 1;

			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

jumper2()
{
	jumpx = getent ("jump2","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j2();
	}
}

j2()
{
	if(isDefined(self.x2))
		return;

	self.x2 = true;

	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	time = 1;

			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

jumper3()
{
	jumpx = getent ("jump3","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j3();
	}
}

j3()
{
	if(isDefined(self.x3))
		return;

	self.x3 = true;

	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	time = 1;
			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

jumper4()
{
	jumpx = getent ("jump4","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j4();
	}
}

j4()
{
	if(isDefined(self.x4))
		return;

	self.x4 = true;

	air1 = getent ("air4","targetname");
	air2 = getent ("air5","targetname");
	air3 = getent ("air6","targetname");
	time = 1;
			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

jumper5()
{
	jumpx = getent ("jump5","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j5();
	}
}

j5()
{
	if(isDefined(self.x5))
		return;

	self.x5 = true;

	air1 = getent ("air7","targetname");
	air2 = getent ("air8","targetname");
	time = 1;
			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air2.origin, time);
			wait 1;
			air moveto (air1.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

jumper6()
{
	jumpx = getent ("jump6","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j6();
	}
}

j6()
{
	if(isDefined(self.x6))
		return;

	self.x6 = true;

	air1 = getent ("air9","targetname");
	air2 = getent ("air10","targetname");
	time = 1;
			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air2.origin, time);
			wait 1;
			air moveto (air1.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

jumper7()
{
	jumpx = getent ("jump7","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if(user istouching(jumpx))
			user thread j7();
	}
}

j7()
{
	if(isDefined(self.x7))
		return;

	self.x7 = true;

	air1 = getent ("air11","targetname");
	air2 = getent ("air12","targetname");
	time = 1;
			air = spawn ("script_model",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait 1;
			self unlink();
			wait 1;
}

trap1()
{
    trig = getEnt( "t1t", "targetname" );
     brush1 = getEnt( "t1b1", "targetname" );
	 brush2 = getEnt( "t1b2", "targetname" );
	trig setHintString("^5Remove!");
	trig waittill( "trigger", player );
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

 	x = RandomInt(2);
	if( x == 1 )
		{
		//trig setHintString(1);
		 brush1 moveZ(-100,1.5);
		 wait 1;
		 brush1 delete();
		 wait 1;
		}
	if( x == 0 )
		{
		//trig setHintString(0);
		 brush2 moveZ(-100,1.5);
		 wait 1;
		 brush2 delete();
		 wait 1;
		}

}
trap2()
{
    trig = getEnt( "t2t", "targetname" );
     b = getEnt( "t2b", "targetname" );
	trig setHintString("^5Rotate");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");
    while(1)
{
	b rotateYaw(360,5);
	wait 5;
	}
}
trap3()
{
    trig = getEnt( "t3t", "targetname" );
     b = getEnt( "t3b", "targetname" );
	trig setHintString("^5Lower");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

	b moveZ(-100,1.5);
	wait 3;
	b moveZ(100,1.5);
}
	trap4()
{
    trig = getEnt( "t4t", "targetname" );
     brush1 = getEnt( "t4b1", "targetname" );
	 brush2 = getEnt( "t4b2", "targetname" );
	trig setHintString("^5Remove Random Parts");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

 	x = RandomInt(2);
	if( x == 1 )
		{
		//trig setHintString(1);
		 brush1 moveZ(-200,1.5,1,1);
		 wait 1;
		 brush1 delete();
		 wait 1;
		}
	if( x == 0 )
		{
		//trig setHintString(0);
		 brush2 moveZ(-200,1.5,1,1);
		 wait 1;
		 brush2 delete();
		 wait 1;
		}

}
trap5()
{
    trig = getEnt( "t5t", "targetname" );
     b = getEnt( "t5b", "targetname" );
	trig setHintString("^5Rotate");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");
    while(1)
{
	b rotateYaw(360,5);
	wait 2;
	}
}
trap6()
{
    trig = getEnt( "t6t", "targetname" );
    bru = getEnt( "t6b", "targetname" );
	trig setHintString("^5Activate Floor Trap");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

	bru moveZ(-110,5);
	wait 5;
}
trap7()
{
    trig = getEnt( "t7t", "targetname" );
     b1 = getEnt( "t7g1_1", "targetname" );
	 b2 = getEnt( "t7g1_2", "targetname" );
	 b3 = getEnt( "t7g1_3", "targetname" );
	 b4 = getEnt( "t7g1_4", "targetname" );
	 b5 = getEnt( "t7g1_5", "targetname" );
	 b6 = getEnt( "t7g2_1", "targetname" );
	 b7 = getEnt( "t7g2_2", "targetname" );
	 b8 = getEnt( "t7g2_3", "targetname" );
	 b9 = getEnt( "t7g2_4", "targetname" );
	 b10 = getEnt( "t7g2_5", "targetname" );
	trig setHintString("^5Rotate");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");
 	x = RandomInt(2);
	if( x == 1 )
		{
		//trig setHintString(1);
		while(1)
		{
		 b1 rotatePitch(3600,0.5);
		 wait 2;
		 b2 rotatePitch(3600,0.5);
		 wait 2;
		 b3 rotatePitch(3600,0.5);
		 wait 2;
		 b4 rotatePitch(3600,0.5);
		 wait 2;
		 b5 rotatePitch(3600,0.5);
		 wait 2;
		 }
		}
	if( x == 0 )
		{
		//trig setHintString(1);
		while(1)
		{
		 b6 rotatePitch(3600,0.5);
		 wait 2;
		 b7 rotatePitch(3600,0.5);
		 wait 2;
		 b8 rotatePitch(3600,0.5);
		 wait 2;
		 b9 rotatePitch(3600,0.5);
		 wait 2;
		 b10 rotatePitch(3600,0.5);
		 wait 2;
		 }
		}
		}
trap8()
{
    trig = getEnt( "t8t", "targetname" );
     b1 = getEnt( "t8b1", "targetname" );
	 b2 = getEnt( "t8b2", "targetname" );
	 b3 = getEnt( "t8b3", "targetname" );
	 b4 = getEnt( "t8b4", "targetname" );
	b1 rotatePitch( -30, 0.05 );
	b2 rotatePitch( 30, 0.05 );
	b3 rotatePitch( -30, 0.05 );
	b4 rotatePitch( 30, 0.05 );
	trig delete();
}
trap9()
{
trig = getEnt ("t9t", "targetname");
h = getEnt ("t9_hurt", "targetname");
b = getEnt ("t9b", "targetname");
	trig setHintString("^5Lower Tool");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

h enablelinkto();
h linkto (b);

	{
	while(1)
	{
	b moveZ(-170,0.5);
	wait 3;
	b moveZ(170,3,1,1);
	wait 5;
	}
}
}
trap10()
{
    trig = getEnt( "t10t", "targetname" );
     b = getEnt( "t10b", "targetname" );
	trig setHintString("^5Open Trap Hole");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

	b delete();
	wait 1;
}
trap11()
{
    trig = getEnt( "t11t", "targetname" );
     b = getEnt( "t11b", "targetname" );
	trig setHintString("^5Fail and Die");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

	b delete();
	wait 1;
}
trap12()
{
    trig = getEnt( "t_newt", "targetname" );
     b = getEnt( "t_newb", "targetname" );
	trig setHintString("^5Open Spaces");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

	b moveZ(-200,5);
	wait 2;
	b delete();
}
trap13()
{
    trig = getEnt( "t_new2t", "targetname" );
     b = getEnt( "t_new2b", "targetname" );
	trig setHintString("^5Trap Floor");
	trig waittill( "trigger", player );
	player braxi\_rank::giveRankXp( "trap_activation" );
	trig setHintString("^5Done");

	b moveZ(-200,5);
	wait 2;
	b delete();
}
end()
{
    trig = getEnt( "end_t", "targetname" );
     b1 = getEnt( "end_b1", "targetname" );
	 b2 = getEnt( "end_b2", "targetname" );
	  x = getent ("smile_fx" ,"targetname");
    PlayFX( level.sm, x.origin);
	b1 delete();
	b2 delete();
}
ends()
{
e1 = getent ("end1" ,"targetname");
e2 = getent ("end2" ,"targetname");
e3 = getent ("end3" ,"targetname");
e4 = getent ("end4" ,"targetname");
e5 = getent ("end5" ,"targetname");
e6 = getent ("end6" ,"targetname");
e7 = getent ("end7" ,"targetname");
e8 = getent ("end8" ,"targetname");
e9 = getent ("end9" ,"targetname");
e10 = getent ("end10" ,"targetname");
e11 = getent ("end11" ,"targetname");
e12 = getent ("end12" ,"targetname");
e13 = getent ("end13" ,"targetname");
e14 = getent ("end14" ,"targetname");
e15 = getent ("end15" ,"targetname");
e16 = getent ("end16" ,"targetname");
e17 = getent ("end17" ,"targetname");
e18 = getent ("end18" ,"targetname");
e19 = getent ("end19" ,"targetname");
e20 = getent ("end20" ,"targetname");
e21 = getent ("end21" ,"targetname");
e22 = getent ("end22" ,"targetname");


	PlayFX( level.e, e1.origin);
	PlayFX( level.e, e2.origin);
	PlayFX( level.e, e3.origin);
	PlayFX( level.e, e4.origin);
	PlayFX( level.e, e5.origin);
	PlayFX( level.e, e6.origin);
	PlayFX( level.e, e7.origin);
	PlayFX( level.e, e8.origin);
	PlayFX( level.e, e9.origin);
	PlayFX( level.e, e10.origin);
	PlayFX( level.e, e11.origin);
	PlayFX( level.e, e12.origin);
	PlayFX( level.e, e13.origin);
	PlayFX( level.e, e14.origin);
	PlayFX( level.e, e15.origin);
	PlayFX( level.e, e16.origin);
	PlayFX( level.e, e17.origin);
	PlayFX( level.e, e18.origin);
	PlayFX( level.e, e19.origin);
	PlayFX( level.e, e20.origin);
	PlayFX( level.e, e21.origin);
	PlayFX( level.e, e22.origin);
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
WatchSniper()
{
	level.snip_trig = getEnt( "sniper_trig", "targetname");
	jump = getEnt( "j_sniper", "targetname" );
	acti = getEnt( "a_sniper", "targetname" );

	while(1)
	{
		level.snip_trig waittill( "trigger", player );
		if( !isDefined( level.snip_trig ) )
			return;
						level.knife_trig delete();
		level.spec_trig delete();
		level.pistol_trig delete();
		level.slick_trig delete();
			level.maze_trig delete();
		//ambientStop( 2 );
		//ambientPlay("skrillex");
        player freezeControls( true );
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		level.activ freezeControls( true );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		wait 0.05;
		noti = SpawnStruct();
		noti.titleText = "^2--^9SNIPER WAHHRR^2--";
	noti.notifyText ="^2"+player.name + " ^1VS ^2"+level.activ.name+" ^7";
	noti.duration = 20;
	noti.glowcolor = (1,1,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player thread countdown_snip();
		level.activ thread countdown_snip();
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
			iPrintlnBold( " ^9" + player.name + "^7 got Owned by ^9"+ level.activ.name+ "^7" );

	}
}
countdown_snip()
{
thread scripts\_slider::oben(self,"^53",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^52",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^11",level.randomcolour);
wait 3;
thread scripts\_slider::unten(self,"^1FIGHT!!",level.randomcolour);
self freezeControls( false );
    self giveweapon( "remington700_mp");
	self giveweapon( "m40a3_mp");
    self GiveMaxAmmo("m40a3_mp");
	self GiveMaxAmmo("remington700_mp");
	self switchToWeapon( "m40a3_mp" );
}
WatchKnife()
{
	level.knife_trig = getEnt( "knife_trig", "targetname");
	jump = getEnt( "j_knife", "targetname" );
	acti = getEnt( "a_knife", "targetname" );

	while(1)
	{
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
			return;
			level.snip_trig delete();
		level.spec_trig delete();
		level.pistol_trig delete();
		level.slick_trig delete();
			level.maze_trig delete();
		//ambientStop( 2 );
		//ambientPlay("skrillex");
    player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );
		   player freezeControls( true );
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
        level.activ freezeControls( true );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "tomahawk_mp" );
		wait 0.05;
		player switchToWeapon( "tomahawk_mp" );
		level.activ SwitchToWeapon( "tomahawk_mp" );
	noti = SpawnStruct();
		noti.titleText = "^2--^9Knife^2--";
	noti.notifyText ="^2"+player.name + " ^1VS ^2"+level.activ.name+" ^7";
	noti.duration = 20;
	noti.glowcolor = (1,1,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player thread countdown_knife();
		level.activ thread countdown_knife();
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
			iPrintlnBold( " ^9" + player.name + "^7 got Owned by ^9"+ level.activ.name+ "^7" );

	}
}
countdown_knife()
{
thread scripts\_slider::oben(self,"^53",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^52",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^11",level.randomcolour);
fx = getent ("knife_fx" ,"targetname");


	PlayFX( level.knife_fx, fx.origin);
wait 3;
thread scripts\_slider::unten(self,"^1FIGHT!!",level.randomcolour);
self freezeControls( false );
}
WatchPistol()
{
	level.pistol_trig = getEnt( "pistol_trig", "targetname");
	jump = getEnt( "j_pistol", "targetname" );
	acti = getEnt( "a_pistol", "targetname" );

	while(1)
	{
		level.pistol_trig waittill( "trigger", player );
		if( !isDefined( level.pistol_trig ) )
			return;
			level.snip_trig delete();
		level.spec_trig delete();
		level.knife_trig delete();
		level.slick_trig delete();
			level.maze_trig delete();
		//ambientStop( 2 );
		//ambientPlay("skrillex");
    player freezeControls( true );
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ freezeControls( true );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		wait 0.05;
	noti = SpawnStruct();
		noti.titleText = "^2--^9Pistols^2--";
	noti.notifyText ="^2"+player.name + " ^1VS ^2"+level.activ.name+" ^7";
	noti.duration = 20;
	noti.glowcolor = (1,1,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player thread countdown_pistol();
		level.activ thread countdown_pistol();
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
			iPrintlnBold( " ^9" + player.name + "^7 got Owned by ^9"+ level.activ.name+ "^7" );

	}
}
countdown_pistol()
{
thread scripts\_slider::oben(self,"^53",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^52",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^11",level.randomcolour);
wait 3;
thread scripts\_slider::unten(self,"^1FIGHT!!",level.randomcolour);
self freezeControls( false );
    self giveweapon( "colt44_mp");
	self GiveMaxAmmo("colt44_mp");
	self GiveMaxAmmo("deserteagle_mp");
	self giveweapon( "deserteagle_mp");
	  self giveweapon( "colt45_mp");
	self giveweapon( "colt45_silencer_mp");
	self GiveMaxAmmo("colt45_mp");
	self GiveMaxAmmo("colt45_silencer_mp");
	self switchToWeapon( "colt44_mp" );
}
WatchSpec()
{
	level.spec_trig = getEnt( "spec_trig", "targetname");
	jump = getEnt( "j_pistol", "targetname" );
	acti = getEnt( "a_pistol", "targetname" );

	while(1)
	{
		level.spec_trig waittill( "trigger", player );
		if( !isDefined( level.spec_trig ) )
			return;
			level.snip_trig delete();
		level.spec_trig delete();
		level.knife_trig delete();
			level.slick_trig delete();
				level.maze_trig delete();
		//ambientStop( 2 );
		//ambientPlay("skrillex");
       player freezeControls( true );
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ freezeControls( true );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		wait 0.05;
	noti = SpawnStruct();
		noti.titleText = "^2--^9Spec Ops^2--";
	noti.notifyText ="^2"+player.name + " ^1VS ^2"+level.activ.name+" ^7";
	noti.duration = 20;
	noti.glowcolor = (1,1,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player thread countdown_spec();
		level.activ thread countdown_spec();
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
			iPrintlnBold( " ^9" + player.name + "^7 got Owned by ^9"+ level.activ.name+ "^7" );

	}
}
countdown_spec()
{
thread scripts\_slider::oben(self,"^53",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^52",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^11",level.randomcolour);
wait 3;
thread scripts\_slider::unten(self,"^1FIGHT!!",level.randomcolour);
self freezeControls( false );
    self giveweapon( "uzi_silencer_mp");
	self giveweapon( "mp5_silencer_mp");
	  self giveweapon( "ak74u_silencer_mp");
	  self GiveMaxAmmo("uzi_silencer_mp");
	  self GiveMaxAmmo("mp5_silencer_mp");
	  self GiveMaxAmmo("ak74u_silencer_mp");
	self switchToWeapon( "mp5_silencer_mp" );
}
help()
{
    //Please use Without Permisson

level.xxx2 = newHudElem();	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	level.xxx2.x = 0;	//position on the x-axis
	level.xxx2.y = 150;	//position on the <-axis
	level.xxx2.horzAlign = "left";
	level.xxx2.vertAlign = "middle";
	level.xxx2.alignX = "left";
	level.xxx2.alignY = "middle";
	level.xxx2.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	level.xxx2.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	level.xxx2.archived = false;	//visible in killcam
	level.xxx2.alpha = 1;	//transparency	0 = invicible, 1 = visible
	level.xxx2.fontScale = 1.9;	//textsize
	level.xxx2.hidewheninmenu = false;	//will it be visble when a player is in a menu
	level.xxx2.color = (1,0,1);	//RGB color code
	while(1)
	{
	level.xxx2.label = &"xfire:poyser1911";	//The text for the hud & is required, &&1 is the value which will be added below
	wait 10;
	level.xxx2.label = &"";
	wait 5;
	}
}
smile1()
{
     b = getEnt( "smile1", "targetname" );

	wait 1;
    while(1)
{
	b rotateYaw(360,8);
	wait 8;
	}
}
smile2()
{
     b = getEnt( "smile2", "targetname" );
    while(1)
{
	b rotateYaw(360,8);
	wait 8;
	}
}
smile3()
{
     b = getEnt( "smile3", "targetname" );
    while(1)
{
	b rotateYaw(360,8);
	wait 8;
	}
}
WatchSlick()
{
	level.slick_trig = getEnt( "slick_trig", "targetname");
	jump = getEnt( "j_slip", "targetname" );
	acti = getEnt( "a_slip", "targetname" );

	while(1)
	{
		level.slick_trig waittill( "trigger", player );
		if( !isDefined( level.slick_trig ) )
			return;
			level.snip_trig delete();
		level.spec_trig delete();
		level.pistol_trig delete();
		level.knife_trig delete();
		level.maze_trig delete();
		//ambientStop( 2 );
		//ambientPlay("skrillex");
    player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );
		   player freezeControls( true );
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
        level.activ freezeControls( true );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "tomahawk_mp" );
		wait 0.05;
		player switchToWeapon( "tomahawk_mp" );
		level.activ SwitchToWeapon( "tomahawk_mp" );
	noti = SpawnStruct();
		noti.titleText = "^2--^9SlicK^2--";
	noti.notifyText ="^2"+player.name + " ^1VS ^2"+level.activ.name+" ^7";
	noti.duration = 20;
	noti.glowcolor = (1,1,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player thread countdown_slick();
		level.activ thread countdown_slick();
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
			iPrintlnBold( " ^9" + player.name + "^7 got Owned by ^9"+ level.activ.name+ "^7" );

	}
}
countdown_slick()
{
thread scripts\_slider::oben(self,"^53",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^52",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^51",level.randomcolour);
wait 3;
thread scripts\_slider::unten(self,"^1FIGHT!!",level.randomcolour);
self sr\api\_player::setPlayerSpeedScale( 5 );
self freezeControls( false );
wait 5;
  x = getent ("sm2" ,"targetname");
    PlayFX( level.sm, x.origin);
}
WatchMaze()
{
	level.maze_trig = getEnt( "maze_trig", "targetname");
	jump = getEnt( "j_maze", "targetname" );
	acti = getEnt( "a_maze", "targetname" );

	while(1)
	{
		level.maze_trig waittill( "trigger", player );
		if( !isDefined( level.maze_trig ) )
			return;
			level.snip_trig delete();
		level.spec_trig delete();
		level.pistol_trig delete();
		level.knife_trig delete();
		level.slick_trig delete();
		//ambientStop( 2 );
		//ambientPlay("skrillex");
    player TakeAllWeapons();
		   player freezeControls( true );
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
        level.activ freezeControls( true );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		wait 0.05;
	noti = SpawnStruct();
		noti.titleText = "^2--^9Maze^2--";
	noti.notifyText ="^2"+player.name + " ^1VS ^2"+level.activ.name+" ^7";
	noti.duration = 20;
	noti.glowcolor = (1,1,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player thread countdown_maze();
		level.activ thread countdown_maze();
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
			iPrintlnBold( " ^9" + player.name + "^7 got Owned by ^9"+ level.activ.name+ "^7" );

	}
}
countdown_maze()
{
thread scripts\_slider::oben(self,"^53",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^52",level.randomcolour);
wait 1;
thread scripts\_slider::oben(self,"^51",level.randomcolour);
wait 3;
thread scripts\_slider::unten(self,"^1FIGHT!!",level.randomcolour);
self freezeControls( false );
    self giveweapon( "ak47_mp");
	self giveweapon( "deserteagle_mp");
    self GiveMaxAmmo("ak47_mp");
	self GiveMaxAmmo("deserteagle_mp");
	self switchToWeapon( "ak47_mp" );
}
