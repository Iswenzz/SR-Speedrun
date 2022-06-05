#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
trig=getent("activator_door_trig","targetname");
trig.targetname = "endmap_trig";
	//maps\mp\_load::main();
	
	// setExpFog(800, 2500, 255/255, 250/255, 250/255, 0.0); //dit is voor enviroment fog 
	
	//ambientPlay("ambient");
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	
	//////////dvars/////////////////////////////alle dvars hierin pleuren
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	///////////variable////////////////////alle variable van scripts hierin

	
	
	//////////////caches////////////////	
	level.fx = loadFx( "framey/aura2" );
	
	//////////////threads////////////////alle thread hierin pleuren , die je wil starten
	thread way_connect();
	thread startdoor();
	// thread shortcut1();
	thread mover();
	thread mover2();
	thread secret();
	// thread activatordoor();
	// thread addtriggers();
	
////////////////traps//////////////////all trap scripts hier
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	
	PlayLoopedFX( level.fx,1, (-1476,544,366));
	PlayLoopedFX( level.fx,1, (-4316,8632,188));		

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );
        
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

startdoor()
{
	startdoor=getent("startdoor_lasers","targetname");
	startdoor_hurt=getent("firstdoor_hurt","targetname");

	startdoor_hurt delete();
	startdoor delete();
}

shortcut1()
{
	platform=getent("shortcut1","targetname");
	trigger=getent("shortcut1_trigger","targetname");
	trigger delete();
	
	while(1)
	{
	platform movez(288,1);
	platform waittill("movedone");
	wait 3;
	platform movez(-288,1);
	platform waittill("movedone");
	wait 3;
	}
}

mover()
{
	platform=getent("mover","targetname");

	ori = spawn("script_origin",(1076,3672,412));
	ori.angles = (0,360,0);
	trig = spawn("trigger_radius",(1017,3852,124),0,150,150);
	trig.radius = 150;
	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread safe_tp1(ori);
	}
	
}

safe_tp1(ori)
{
	self endon("death");
	self endon("disconnect");

	self setOrigin(ori.origin);
	self setplayerangles(ori.angles);
	self freezecontrols(1);
	wait 0.05;
	self freezecontrols(0);
}

mover2()
{
	platform=getent("mover2","targetname");
	ori = spawn("script_origin",(1617,4853,508));
	trig = spawn("trigger_radius",(2510,4676,508),0,150,150);
	trig.radius = 150;
	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(ori.origin);
	}
}

activatordoor()
{
	door=getent("activator_door","targetname");
	trig=getent("activator_door_trig","targetname");
	trig.targetname = "endmap_trig";
	trig delete();
	door delete();
}

secret()
{
	spawn=getent("secretspawn","targetname");
	trig1=getent("secrethit1","targetname");
	trig2=getent("secrethit2","targetname");
	
	for(;;)
	{
	trig2 waittill("trigger",player);
	player setplayerangles(spawn.angles);
	player setorigin(spawn.origin);
	player sr\api\_speedrun::changeWay("secret_0");
	}
}


/*trig2=getent("secrethit2","targetname");
	trig1 waittill("trigger");*/


//////////////traps/////////////

trap1()
{
movers=getent("trap1_movers","targetname");
trigger=getent("trap1_trigger","targetname");

trigger waittill("trigger");
thread trap1b();


while(1)
{
	movers movez(-150,2);
	movers waittill("movedone");
	movers movez(150,2);
	movers waittill("movedone");
	movers movez(150,2);
	movers waittill("movedone");
	movers movez(-150,2);
	movers waittill("movedone");
}

}

trap1b()
{
remover=getent("trap1_remover","targetname");
remover movez(-1088,5);
Earthquake( 0.3, 5, remover.origin, 850 );
remover waittill("movedone");
}


trap2()
{
	pins=getent("pin_trap","targetname");
	hurt=getent("pin_trap_hurt","targetname");
	hurt enablelinkto();
	hurt linkto(pins);
	
	trigger=getent("trigger_trap2","targetname");

	trigger waittill("trigger");
	pins movez  (288,0.5);
	pins waittill("movedone");
	pins movez  (-288,5);
}	

trap3()
{
wait 10;
brush=getent("trap3_sweeper","targetname");
trigger=getent("trigger_trap3","targetname");
if (!isdefined(brush.speed))
 brush.speed = 5;
if (!isdefined(brush.script_noteworthy))
 brush.script_noteworthy = "y";

 trigger waittill("trigger");
while(true)
{

 if (brush.script_noteworthy == "z")
  brush rotateYaw(360,brush.speed);
 else if (brush.script_noteworthy == "x")
  brush rotateRoll(360,brush.speed);
 else if (brush.script_noteworthy == "y")
  brush rotatePitch(360,brush.speed);
brush waittill("movedone");
wait 10;
}

}

trap4()
{
brush=getent("trap3","targetname");
if (!isdefined(brush.speed))
 brush.speed = 3;
if (!isdefined(brush.script_noteworthy))
 brush.script_noteworthy = "y";
 
 trigger=getent("trigger_trap4","targetname");
trigger waittill("trigger");

while(true)
{
 if (brush.script_noteworthy == "z")
  brush rotateYaw(360,brush.speed);
 else if (brush.script_noteworthy == "x")
  brush rotateRoll(360,brush.speed);
 else if (brush.script_noteworthy == "y")
  brush rotatePitch(360,brush.speed);
 wait ((brush.speed)-0.1);
}
}

trap5()
{
trigger=getent("trigger_trap5","targetname");

trigger waittill("trigger");

shake1=getent("shake1","targetname");
shake2=getent("shake2","targetname");
shake3=getent("shake3","targetname");
thread spin(shake1);
thread spin(shake2);
thread spin(shake3);
}

spin(brush)
{
if (!isdefined(brush.speed))
 brush.speed = 4;
if (!isdefined(brush.script_noteworthy))
 brush.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (brush.script_noteworthy == "z")
  brush rotateYaw(360,brush.speed);
 else if (brush.script_noteworthy == "x")
  brush rotateRoll(360,brush.speed);
 else if (brush.script_noteworthy == "y")
  brush rotatePitch(360,brush.speed);
 wait ((brush.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 //epic waittill("rotatedone");
}
}

trap6()
{
	brush=getent("trap6_brush","targetname");
	trigger=getent("trigger_trap6","targetname");
	
	if (!isdefined(brush.speed))
	brush.speed = 4;
	if (!isdefined(brush.script_noteworthy))
	brush.script_noteworthy = "x";
	
	trigger waittill("trigger");
	while(true)
	{

	if (brush.script_noteworthy == "z")
	brush rotateYaw(360,brush.speed);
	else if (brush.script_noteworthy == "x")
	brush rotateRoll(360,brush.speed);
	else if (brush.script_noteworthy == "y")
	brush rotatePitch(360,brush.speed);
	wait ((brush.speed)-0.1);
	
	wait 5;
	}

}

trap7()
{	
	brush=getent("3xp_logo_trap","targetname");
	brush_origin=getent("3xp_logo_origin","targetname");
	brush_dmg=getent("logo_falldmg","targetname");
	
	trigger=getent("trigger_trap7","targetname");
	
	brush_dmg enablelinkto();
	brush_dmg linkto(brush_origin);
	brush linkto(brush_origin);
	
	trigger waittill("trigger");
	Earthquake( 0.5, 5, brush_origin.origin, 1500 );
	brush_origin movex(-80,0.5);
	brush_origin rotatePitch(-95,3);
	wait(0.45);
	brush_origin movez(-1200,3);
	wait (2.9);
	brush_origin rotatePitch(-30,1.3);
	brush_origin movez(-450,1.3);
	brush_origin waittill("movedone");
	brush_origin delete();
	
}

trap8()
{
	brushes=getent("trap8_nonsolid","targetname");
	trigger=getent("trigger_trap8","targetname");
	trigger waittill("trigger");
	brushes notsolid();
}

trap9()
{
wait 10;
brush=getent("trap9_rotatefloor","targetname");
trigger=getent("trigger_trap9","targetname");

if (!isdefined(brush.speed))
 brush.speed = 5;
if (!isdefined(brush.script_noteworthy))
 brush.script_noteworthy = "y";

 trigger waittill("trigger");
	while(true)
	{
	
	if (brush.script_noteworthy == "z")
	brush rotateYaw(-360,brush.speed);
	else if (brush.script_noteworthy == "x")
	brush rotateRoll(-360,brush.speed);
	else if (brush.script_noteworthy == "y")
	brush rotatePitch(-360,brush.speed);
	wait ((brush.speed)-0.1);
	}
}

trap10()
{
	platform=getent("trap10_move","targetname");
	trigger=getent("trigger_trap10","targetname");
	trigger waittill("trigger");
	platform movex(-224,4,1,3);
	
}
