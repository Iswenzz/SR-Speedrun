main()
{
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;Epic Secret Way");

	thread speedrun\_way_name::create_spawn((-523, 171, 80), 320);

	maps\mp\_load::main();
	// maps\mp\_teleport::main();
	
    game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
    
	thread speedrun\_way_name::create_tp((-480.799, -405.218, 584.125), 40, 20, (-479, -1063, 639), 270, "freeze", "cyan", "ns0");
	thread speedrun\_way_name::create_tp((-173, -227, 80), 100, 150, 
		(-1596, -4293, -418), 180, "freeze", "blue", "s0");
	thread speedrun\_way_name::create_tp((-616, -215, 80), 100, 150, 
		(-1749, -914, 132), 360, "freeze", "blue", "s1");
	thread speedrun\_way_name::create_endmap((-2252, -2005, 210), 100, 150);
	thread speedrun\_way_name::create_endmap((1650, 5839, -1744), 250, 50, "s0");
	thread speedrun\_way_name::create_endmap((-983, -2719, 875), 100, 50, "s1");
	thread speedrun\_way_name::create_tp((847, 1475, 188), 100, 150, (785, 1156, 639), 270, "freeze");
	
	// elevatorparts = getentarray("elevator","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread elevator();
	// }
	// }
	
	// elevatorparts = getentarray("elevator2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread elevator2();
	// }
	// }
	
	// elevatorparts = getentarray("elevator3","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread elevator3();
	// }
	// }
	
	// elevatorparts = getentarray("elevator4","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread elevator4();
	// }
	// }
	
	// elevatorparts = getentarray("platform","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread platform();
	// }
	// }
	
	// elevatorparts = getentarray("platform2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread platform2();
	// }
	// }
	
	// elevatorparts = getentarray("platform3","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread platform3();
	// }
	// }
	
	// elevatorparts = getentarray("platform4","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread platform4();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing2();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing3","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing3();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing4","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing4();
	// }
	// }
	
	elevatorparts = getentarray("secret","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread secret();
	}
	}
	
	thread startdoor();
	thread platform();
	thread platform2();
	thread platform3();
	thread platform4();
	thread elevator();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap_spikes_left();
	// thread elevator();
	// thread elevator2();
	// thread elevator3();
	// thread elevator4();
	// thread twister();
	// thread twister2();
	// thread  [AUTO DELETE] teleportsniperroom(); 
	// teleportjump()
	
	thread addTriggerToList( "trigger_spikes" );
	
	}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

 
startdoor()
{
door = getent("rise1","targetname");

wait 0.1;
door delete();

}


secret()
{
trigger = getEnt("trigger_secret", "targetname");
// trigger waittill("trigger");
// trigger delete();
self delete();
}

platform()
{
plat = getent("platform","targetname");

wait 0.1;	
plat moveX(-200,0.1);

}

platform2()
{
plat = getent("platform2","targetname");

wait 0.1;	
plat moveX(160,0.1);

}

platform3()
{
plat = getent("platform3","targetname");

wait 0.1;
plat moveY(-60,0.1);

}

platform4()
{
plat = getent("platform4","targetname");

wait 0.1;
plat moveY(440,0.1);

}

elevator()
{
ele = getentArray("elevator4","targetname");

wait 0.1;
ele[0] moveZ(-130,0.1);
wait 0.2;
ele[1] moveZ(-130,0.1);

}
