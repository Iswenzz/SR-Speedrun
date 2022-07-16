#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
    maps\mp\_load::main();

 	thread speedrun\_way_name::create_spawn((4,466,76),270);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;");
    thread speedrun\_way_name::create_tp((171.921, -201.41, 16.3458), 100, 95, (-524, 4041, 302), 181, "freeze", "cyan", "s0");
    thread speedrun\_way_name::create_endmap((-1129.56, 7198.12, 42.4977),215,95,"s0");
    thread speedrun\_way_name::create_endmap((-4100.14, 2497.42, -173.942),105,95,"ns0");
    thread speedrun\_way_name::create_tp((-3618.66, 437.539, -173.942), 55, 95, (-3669, 1562, -114), 98,"freeze");
	
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
 addTriggerToList( "trig_trap1" );
 addTriggerToList( "trig_trap2" );
 addTriggerToList( "trig_trap3" );
 addTriggerToList( "trig_trap4" );
 addTriggerToList( "trig_trap5" );
 addTriggerToList( "trig_trap6" );
 addTriggerToList( "trig_trap7" );
 addTriggerToList( "trig_trap8" );
 
	thread startdoor();
	thread lift();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
    thread anticut_main();
    thread removetrigg();

	
}
removetrigg()
{
    	if(isDefined(getEnt("endmap_trig","targetname")))
		{
			endtrigg = getEnt("endmap_trig","targetname");
			endtrigg delete();
		}
}
anticut_main() 
{
    trig1 = spawn( "trigger_radius", (-1277.06, 4624.98, 13.2463), 0, 1255, 10 );
    trig2 = spawn( "trigger_radius", (-2369.09, 5987.85, 13.253), 0, 1420, 10 );
    trig3 = spawn( "trigger_radius", (-1765.83, 7381.17, 13.2463), 0, 1420, 10 );
    trig4 = spawn( "trigger_radius", (-3048.43, 4058.95, 13.253), 0, 820, 10 );
    

    trig1 thread anticut();
    trig2 thread anticut();
    trig3 thread anticut();
    trig4 thread anticut();

}
anticut() 
{
    
    enter = getent("auto16","targetname");

    for(;;)
    {
        self waittill("trigger",player);
        player setOrigin( enter.origin );
  		player setplayerangles( enter.angles );
    }

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


startdoor()
{
	door=getent("startdoor","targetname");
	door delete();
}

lift()
{
object1 = getent("lift","targetname");
}

trap1()
{
    level endon("triggeraaeaeae");
    trig = getEnt( "trig_trap1", "targetname" );
    object1 = getent("trap1","targetname");
 
    trig waittill ("triggeraaeaeae",user);
    trig delete();
 
    {
        object1 delete();
		wait 2;
		
    }
}

trap2()
{
    level endon("triggeraaxxxeae");
    trig = getEnt( "trig_trap2", "targetname" );
    object1 = getent("trap2","targetname");
 
    trig waittill ("triggeraaxxxeae",user);
    trig delete();
 
    {
        object1 delete();
		wait 2;
    }
}

trap3()
{
    level endon("triggeraaxxqqaae");
    trig = getEnt( "trig_trap3", "targetname" );
    object1 = getent("trap3","targetname");
 
    trig waittill ("triggeraaxxqqaae",user);
    trig delete();
 
    {
        object1 delete();
		wait 2;
    }
}


trap4()
{
    level endon("triggeraazerttae");
    trig = getEnt( "trig_trap4", "targetname" );
    object1 = getent("trap4","targetname");
 
    trig waittill ("triggeraazerttae",user);
    trig delete();
	
    while(1) 
    {
        object1 rotateroll(-360, 5);
		wait 10;
		object1 rotateYaw(360, 5);
		wait 10;
		object1 rotateroll(-360, 5);
		wait 10;
		object1 rotateYaw(360, 5);
		wait 10;
	}
}

trap5()
{
    level endon("triggerapopo");
    trig = getEnt( "trig_trap5", "targetname" );
    object1 = getent("trap5","targetname");
 
    trig waittill ("triggerapopo",user);
    trig delete();
	
    while(1) 
    {
        object1 rotateroll(360, 5);
		wait 10;
		object1 rotateYaw(-360, 5);
		wait 10;
		object1 rotateroll(360, 5);
		wait 10;
		object1 rotateYaw(-360, 5);
		wait 10;
	}
}

trap6()
{
    level endon("triggerapfzfzfz");
    trig = getEnt( "trig_trap6", "targetname" );
    object1 = getent("trap6","targetname");
 
    trig waittill ("triggerapfzfzfz",user);
    trig delete();
 
    while(1) 
    {
        object1 hide();
		object1 notsolid();
		wait 5;
        object1 show();
		object1 solid();
		wait 5;
    }
}

trap7()
{
    level endon("triggerazdsaaapo");
    trig = getEnt( "trig_trap7", "targetname" );
    object1 = getent("trap7","targetname");
 
    trig waittill ("triggerazdsaaapo",user);
    trig delete();
 
    {
        object1 delete();
		wait 2;
    }
}

trap8()
{
    level endon("triggerapobbbbbo");
    trig = getEnt( "trig_trap8", "targetname" );
    object1 = getent("trap8","targetname");
 
    trig waittill ("triggerapobbbbbo",user);
    trig delete();
 
    {
        object1 delete();
		wait 2;
    }
}