
main()
{

 maps\mp\_load::main();
 
thread speedrun\_way_name::create_spawn((3320,2076,188),269);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_tp((3534.73, 1809.43, 128.125), 80, 95, (3603, 769, 388), 148, "freeze", "blue", "s0");
thread speedrun\_way_name::create_tp((6393.97, -1885.42, 104.125), 120, 95, (6027, -847, 164), 112,"freeze");

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
 	setdvar( "r_specularcolorscale", "1" );
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );


	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
  
 
 thread secret();
 thread trap1();
 thread platform(); 
 thread trap6();
 thread trap5();
 thread jets();
 thread trap4();
 thread trap8();
 thread teleport1();
 thread trap7();
 thread trap2();
 
 addTriggerToList( "trap1_trig" );
 addTriggerToList( "trap2_trig" );
 addTriggerToList( "trap3_trig" );
 addTriggerToList( "trap4_trig" );
 addTriggerToList( "trap5_trig" ); 
 addTriggerToList( "trap6_trig" ); 
 addTriggerToList( "trap7_trig" ); 
 addTriggerToList( "trap8_trig" ); 
 
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

secret()
{
trig = getent("secret", "targetname");
block = getent("secret_open", "targetname");
trig waittill ("trigger", player);

{
      block delete();
      iPrintLnBold ("^3S^7ecret ^3O^7pened");
    }
}	


trap1()
{
		level endon("triggeraz");
        trap1 = getEnt("trap1","targetname");
		origin = getEnt("trap1_origin","targetname");
		trig = getEnt("trap1_trig","targetname");
		ent = getEnt( "boom", "targetname" );
        trig waittill ("triggeraz", player);
        trig delete();
                trap1 hide();
				trap1 notsolid();
		        wait 10;
				ent delete();
		
}

trap3()
{
	level endon("triggerazaddd");
    trig = getEnt ("trap3_trig", "targetname");
    hurt = getEnt ("trap3_hurt", "targetname"); 
	trap3 = getEnt ("trap3", "targetname");
    
    hurt enablelinkto(); 
	hurt linkto (trap3); 

    trig waittill ("triggerazaddd",player);
    trig delete();
    
    trap3 moveZ (56,3);
    wait 5;
    trap3 moveZ (-56,3);
     
}

platform()
{
	plat1 = getEnt("platform1", "targetname");
	plat2 = getEnt("platform2", "targetname");

}

trap6()
{
	level endon("triggerazaaeada");
    trig = getEnt ("trap6_trig", "targetname");
	trap6 = getEnt ("trap6", "targetname");
    
    trig waittill ("triggerazaaeada",player);
    trig delete();
	
	while(1)
    {
    trap6 rotateYaw(360,3);
    wait 0.1;
    }
}

trap5()
{
		level endon("triggerazxxda");
        trap5 = getEnt("trap5","targetname");
		origin = getEnt("trap5_origin","targetname");
		trig = getEnt("trap5_trig","targetname");
		ent = getEnt( "boom1", "targetname" );
        trig waittill ("triggerazxxda", player);
        trig delete();
                trap5 hide();
				trap5 notsolid();
		        wait 10;
				ent delete();
		
}


jets()
{
	level endon("triggeraxxa");
trig = getent("trigger_jets","targetname");
model1 = getent("model1_jets","targetname");
model2 = getent("model2_jets","targetname");
model3 = getent("model3_jets","targetname");
{
	trig waittill ("triggeraxxa", player);
	
	trig delete();	
	model1 moveY(24000,8);
	model2 moveY(24000,8);
	model3 moveY(24000,8);
	
	wait 8;
	model1 delete();
	model2 delete();
	model3 delete();
}
}


trap4()
{
 
    trig = getEnt ("trap4_trig", "targetname");
	hurt = getEnt ("trap4_hurt", "targetname"); 
	trap4_spikes = getEnt ("trap4_spikes", "targetname");
	trap4_a = getEnt ("trap4_a", "targetname");
	trap4_b = getEnt ("trap4_b", "targetname");
	trap4_c = getEnt ("trap4_c", "targetname");
	
	hurt delete();
	trap4_spikes delete();
    trap4_a delete();
	trap4_b delete();
	trap4_c delete();
    trig delete();
	
}

trap8()
{
 
    trig = getEnt ("trap8_trig", "targetname");
	trap8 = getEnt ("trap8", "targetname");
	hurt = getEnt ("trap8_hurt", "targetname"); 	
	hurt delete(); 
    trap8 delete();
    trig delete();
	
}


teleport1()
{

	target = getEnt( "teleport1_target", "targetname" );
	trig = getent("teleport1_trigger", "targetname");
	
for(;;)
{
	trig waittill ("trigger", player);
	player thread speedrun\_way_name::finish_way("s0");
}
}

trap7()
{
 
    trig = getEnt ("trap7_trig", "targetname");
	trap7 = getEnt ("trap7", "targetname");

    trig waittill ("trigger");
    trig delete();
    
    trap7 notsolid();
     
}

trap2()
{
 
    trig = getEnt ("trap2_trig", "targetname");
	trap2 = getEnt ("trap2", "targetname");
    
    trig waittill ("trigger");
    trig delete();
	
    trap2 moveZ(-136,3);
    wait 0.1;
    
}