#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
	maps\mp\_load::main();

	thread speedrun\_way_name::create_spawn((89,-810,-793),90);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;");
	thread speedrun\_way_name::create_tp((271.251, -495.089, -852.875), 80, 75, (5773, 3266, -3534), 358, "freeze", "blue", "s0");
	thread speedrun\_way_name::create_tp((-203.329, 1835.91, -853.875), 55, 75, (-1127, 1844, -794), 179,"freeze");
	thread speedrun\_way_name::create_endmap((-4227.93, 1544.57, -269.375),160,80, "ns0");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread trap1();
	thread trap2();
	thread bridge();
	thread lightningtrap();
	thread trap3();
	thread trap3swagshop();
	thread trap5();
	thread secretrespawn();
	thread secretend();
	
	addTriggerToList( "trig1" );
	addTriggerToList( "trap2trig" );
	addTriggerToList( "trap3" );
	addTriggerToList( "nigtrig" );
	addTriggerToList( "trig5" );
	 
}

	
 

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1()
{
	level endon("triggeraofa");
trap1_1 = getent("trap1_1", "targetname");
trap1_2 = getent("trap1_2", "targetname");
trap1_3 = getent("trap1_3", "targetname");
trap1_4 = getent("trap1_4", "targetname");
trap1_5 = getent("trap1_5", "targetname");
trap1_6 = getent("trap1_6", "targetname");
trap1_7 = getent("trap1_7", "targetname");
trig = getEnt("trig1","targetname");
trig waittill ("triggeraofa", player);
trig delete();

		while(1)
        {

				trap1_1 rotateyaw (720 , 2.5);
				trap1_2 rotateyaw (720 , 2.5);
				trap1_3 rotateyaw (720 , 2.5);
				trap1_4 rotateyaw (720 , 2.5);
				trap1_5 rotateyaw (720 , 2.5);
				trap1_6 rotateyaw (720 , 2.5);
				trap1_7 rotateroll (-720 , 2.5);
				
				wait 4;
				
				trap1_1 rotateyaw (720 , 2.5);
				trap1_2 rotateyaw (720 , 2.5);
				trap1_3 rotateyaw (720 , 2.5);
				trap1_4 rotateyaw (720 , 2.5);
				trap1_5 rotateyaw (720 , 2.5);
				trap1_6 rotateyaw (720 , 2.5);
				trap1_7 rotateroll (-720 , 2.5);
				
wait 4;
}				
}	


trap2()
{
	level endon("triggeraaafaofa");
fire1 = GetEnt("fire1", "targetname");
fire2 = GetEnt("fire2", "targetname");
fire3 = GetEnt("fire3", "targetname");
fire4 = GetEnt("fire4", "targetname");
firekill = GetEnt("trap2kill", "targetname");
trig = GetEnt("trap2trig", "targetname");
trig waittill("triggeraaafaofa", player);
trig delete();

for(;;)
{
firekill waittill("trigger", player);
wait 0.01;
player suicide();
}
}


bridge()
{
	level endon("triggeraadaqwa");
	bridge = GetEnt("bridge", "targetname");
	bridgedoor = GetEnt("bridgedoor", "targetname");
	trig = GetEnt("bridgetrig", "targetname");
	trig waittill ("triggeraadaqwa", player);
	trig delete();

	bridgedoor moveZ (156 , 1.5);
	wait 1.5;
	bridge moveX (849 , 1.9);
	wait .5;
}


lightningtrap()
{
		level endon("triggerxvbb");
 lightning1 = getent("lightning1", "targetname");
 lightning2 = getent("lightning2", "targetname");

 trig = getent("trap3", "targetname");

 trap3damage = getent("trap3damage", "targetname");

 trap3link = getent("trap3link", "targetname");

 trap3damage enableLinkTo();
 
 trap3damage LinkTo(trap3link);

 trap3link moveY( -1000, 0.1 );

 trig waittill ("triggerxvbb", player);
 trig delete();
 
 trap3link moveY( 1000, 0.1 );
 

trap3damage delete();

}

trap3()
{ 
	level endon("triggerxaqwvsvsb");
	lasers = getEnt( "syndkys", "targetname" );
	trig = getEnt( "nigtrig", "targetname" ); // targetname stolen from familyguy
	acti = getEnt("nigtrigacti", "targetname");
	
	acti waittill ("triggerxaqwvsvsb", player);

	lasers show();
	lasers solid();
	
	thread trap3meh();
}

trap3meh()
{
	level endon("triggerxaqwvsadadadvsb");
	trig = getEnt( "nigtrig", "targetname" );
	for(;;) 
	{
	trig waittill ("triggerxaqwvsadadadvsb", player);
	player suicide();
	wait 1;
}
}

		
trap3swagshop()
{ 
	lasers = getEnt( "syndkys", "targetname" );		
	
	lasers hide();
	lasers notsolid();
}


trap5()
 {
	 level endon("triggerxmlmlvsb");
	trap5_1 = getEnt ("trap5_1","targetname");
	trap5_2 = getEnt ("trap5_2","targetname");
	trig5 = getEnt ("trig5","targetname");
	trig5 waittill ("triggerxmlmlvsb", player);
	trig5 delete ();
	random = randomint (2);
	switch (random) 
	{
		case 0: trap5_1 hide();
				trap5_1 notsolid();
				wait 1.0;
				break;
		case 1: trap5_2 hide();
				trap5_2 notsolid();
				wait 1.0;
				break;
	}
}
secretrespawn()
{
		secretrespawn= GetEnt("secrettrigger","targetname");
		origin = GetEnt("secretrespawn","targetname");

		while(1)
        {
			secretrespawn waittill("trigger", player);
		  	player suicide();
		}	
}
secretend()
{
	level.secretend = GetEnt("secretend","targetname");

	while(1)
	{
		level.secretend waittill("trigger", player);
		{
			player thread speedrun\_way_name::finish_way("s0");		
		}
	}
}
