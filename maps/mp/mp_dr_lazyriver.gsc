#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	thread sr\api\_defrag::weapons("");
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setDvar("bg_fallDamageMinHeight", "99999");
	setDvar("bg_fallDamageMaxHeight", "999999");

	VisionSetNaked( "mp_dr_lazyriver");
	
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_map::createSpawn((66, -1020, 651), 90);
thread sr\api\_speedrun::createTeleporter((-676.899, -69.2373, 584.125), 500, 100, (66, -1020, 651), 90, "freeze", "cyan");
thread sr\api\_speedrun::createTeleporter((738.394, -134.923, 584.125), 410, 100, (66, -1020, 651), 90, "freeze", "cyan");

	//thread trap1();	
	thread trap2();
	//thread trap3();
	//thread trap4();	
	//thread trap5();	
	thread trap6();	
	thread tele1();	
	thread tele2();	
	thread tele3();	
	thread telejumper();	
	thread trap9();
	thread trap8();
}

trap1()
{
	trap1a = getent ("trap1a","targetname");
	trap1b = getent ("trap1b","targetname");
	trap1_trig = getent ("trap1_trig","targetname");
	
	trap1_trig waittill ("trigger");
	trap1_trig delete ();

	while (1)
	{
		trap1a moveZ (100,1,0.4,0);		
		trap1b moveZ (-100,1,0,0.4);
		wait 1;
		trap1a moveZ (-200,1,0.4,0.4);		
		trap1b moveZ (200,1,0.4,0.4);
		wait 1;
		trap1a moveZ (100,1,0,0.4);		
		trap1b moveZ (-100,1,0.4,0);
		wait 1;
	}
}

trap2()
{
	fire1_hurt = getent("trap2","targetname"); 
	fire2_hurt = getent("trap22","targetname"); 
	fire3_hurt = getent("trap23","targetname"); 

	fire1_hurt delete();
	fire2_hurt delete();
	fire3_hurt delete();
	
}

trap3()
{
	trap3 = getent ("trap3","targetname");
	trap3_water = getent ("trap3_water","targetname");
	trap3_trig = getent ("trap3_trig","targetname");
	trap3_trig waittill ("trigger");
	trap3_trig delete ();

	while(1)
	{
		trap3 moveZ (-700,1,0.4,0);	
		wait 3;
		trap3 moveZ (700,1,0,0.4);
		wait 3;
	}
}

trap4()
{
	trap4 = getent ("trap4","targetname");
	trap4_trig = getent ("trap4_trig","targetname");
	
	trap4_trig waittill ("trigger");
	trap4_trig delete ();

	{
		trap4 moveZ (-400,0.1);
		wait 0.1;
	}
}

trap5()
{
	trap5a = getent ("trap5a","targetname");
	trap5b = getent ("trap5b","targetname");
	trap5c = getent ("trap5c","targetname");
	trap5d = getent ("trap5d","targetname");
	trap5_trig = getent ("trap5_trig","targetname");
	
	trap5_trig waittill ("trigger");
	trap5_trig delete ();

	while(1)
	{
		trap5a rotateRoll (-45,1);
		trap5c rotateRoll (45,1);
		wait 1.2;
		trap5a rotateRoll (45,1);
		trap5c rotateRoll (-45,1);
		wait 1.2;
		trap5b rotateRoll (-45,1);
		trap5d rotateRoll (45,1);
		wait 1.2;
		trap5b rotateRoll (45,1);
		trap5d rotateRoll (-45,1);
		wait 1.2;
	}
}


trap9()
{
	trap8 = getent ("trap8","targetname");
	trap9_trig = getent ("trap9_trig","targetname");
	
}

trap8()
{
	fire18 = getent("fire18","targetname"); 
	fire48 = getent("fire48","targetname"); 
	fire1_hurt = getent("trap8_h1","targetname"); 
	fire2_hurt = getent("trap8_h2","targetname"); 

	fire1_hurt delete();
	fire2_hurt delete();
}


tele1()
{
	tele1_trig = getEnt ("tele1_trig", "targetname");
	tele1 = getEnt ("tele1", "targetname");
	
	for(;;)
	{
		tele1_trig waittill ("trigger", player);
		
		player SetOrigin(tele1.origin);
		player SetPlayerAngles( tele1.angles );
	}
}

tele2()
{
	tele2_trig = getEnt ("tele2_trig", "targetname");
	tele2 = getEnt ("tele2", "targetname");
	
	for(;;)
	{
		tele2_trig waittill ("trigger", player);
		
		player SetOrigin(tele2.origin);
		player SetPlayerAngles( tele2.angles );
	}
}

tele3()
{
	tele3_trig = getEnt ("tele3_trig", "targetname");
	tele3 = getEnt ("tele3", "targetname");
	
	for(;;)
	{
		tele3_trig waittill ("trigger", player);
		
		player SetOrigin(tele3.origin);
		player SetPlayerAngles( tele3.angles );
	}
}

telejumper()
{
	telejumper = getEnt ("telejumper", "targetname");
	jumper_origin = getEnt ("jumper_origin", "targetname");
	
	for(;;)
	{
		telejumper waittill ("trigger", player);
		
		player SetOrigin(jumper_origin.origin);
		player SetPlayerAngles( jumper_origin.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

trap6() 
{
	trap6_trigger = getent("trap6_trig","targetname"); 
	level.plane_start = getent("plane_start","targetname"); 
	level.plane_end = getent("plane_end","targetname"); 
	level.trap6_kill = getent("trap6_kill","targetname"); 

	level.trap6_kill delete();


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
