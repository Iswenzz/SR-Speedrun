
main()
{
thread sr\api\_map::createSpawn((1963, 652, 8), 270);

 maps\mp\_load::main();
 
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((3534.73, 1809.43, 128.125), 80, 95, (3603, 769, 388), 148, "freeze", "blue", "secret_0");
thread sr\api\_speedrun::createTeleporter((3295.85, 2035.72, 256.125), 170, 95, (3356, 2847, 316), 90,"freeze");
thread sr\api\_speedrun::createTeleporter((780.03, 2856.87, 256.125), 150, 95, (612, 1732, 260), 266,"freeze");
  
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
  
  
  
   
	
  thread teleport();
  thread trap1();
  thread trap2();
  thread trap3();
  thread trap4();
  thread trap5();
  thread trap6(); 
  thread trap7();
  thread trap8();
  thread trap9();
  thread trap10();
  thread trap11();
  thread trap12();
  thread trap13();
  thread trap14();
  thread trap15();
  thread trap16();
  thread mover();
  thread mover1();
  
 addTriggerToList( "trap1_trig" );
 addTriggerToList( "trap2_trig" );
 addTriggerToList( "trap3_trig" );
 addTriggerToList( "trap4_trig" );
 addTriggerToList( "trap5_trig" ); 
 addTriggerToList( "trap6_trig" ); 
 addTriggerToList( "trap7_trig" ); 
 addTriggerToList( "trap8_trig" ); 
 addTriggerToList( "trap9_trig" ); 
 addTriggerToList( "trap10_trig" ); 
 addTriggerToList( "trap11_trig" ); 
 addTriggerToList( "trap12_trig" ); 
 addTriggerToList( "trap13_trig" ); 
 addTriggerToList( "trap14_trig" ); 
 addTriggerToList( "trap15_trig" );  
 addTriggerToList( "trap16_trig" ); 

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}	


mover()
{
	obj = getent("mover","targetname");
}

mover1()
{
	obj = getent("mover1","targetname");
}

trap1()
{
	level endon("triggera");
	trigacti = getent("trap1_trig", "targetname");
	killtrig = getent ("hurt", "targetname");
	car1 = getent ("car1", "targetname");
	car2 = getent ("car2", "targetname");
	car3 = getent ("car3", "targetname");
	car4 = getent ("car4", "targetname");
	car5 = getent ("car5", "targetname");
	asd1 = getent ("car1multiple", "targetname");
	asd2 = getent ("car2multiple", "targetname");
	asd3 = getent ("car3multiple", "targetname");
	asd4 = getent ("car4multiple", "targetname");
	asd5 = getent ("car5multiple", "targetname");
	car1_clip = getent ("car1_clip", "targetname");
	car2_clip = getent ("car2_clip", "targetname");
	car3_clip = getent ("car3_clip", "targetname");
	car4_clip = getent ("car4_clip", "targetname");
	car5_clip = getent ("car5_clip", "targetname");
	killtrig maps\mp\_utility::triggerOff();
	trigacti waittill( "triggera", who ); 
	wait 0.1;

	x = RandomInt(100);
		if( x < 50 )
		{
		killtrig maps\mp\_utility::triggerOn();
		car1 delete();
		car1_clip delete();
		wait 0.5;
		asd1 delete();
		}
		if( x > 49  )
		{
		killtrig maps\mp\_utility::triggerOn();
		car2 delete();
		car2_clip delete();
		wait 0.5;
		asd2 delete();
		}
	trigacti waittill( "trigger", who ); 

	x = RandomInt(100);
		if( x < 50 )
		{
		killtrig maps\mp\_utility::triggerOn();
		car3 delete();
		car3_clip delete();
		wait 0.5;
		asd3 delete();
		}
		if( x > 49  )
		{
		killtrig maps\mp\_utility::triggerOn();
		car4 delete();
		car5 delete();
		car4_clip delete();
		car5_clip delete();
		wait 0.5;
		asd4 delete();
		asd5 delete();
		}
	    trigacti delete();
		killtrig delete();
}

trap2()
{
	level endon("triggerab");
	trig = getent("trap2_trig", "targetname");
	door1 = getent("door1", "targetname");
	door2 = getent("door2", "targetname");
	killtrig = getent("killtrig", "targetname");
	rpd = getent("rpdspawn", "targetname");
	rpd1 = getent("rpdspawn_1", "targetname");
	rpd2 = getent("rpdspawn_2", "targetname");
	rpd3 = getent("rpdspawn_3", "targetname");
	rpd4 = getent("rpdspawn_4", "targetname");
	gold = getent("trap2gold","targetname");
	killtrig maps\mp\_utility::triggerOff();
	trig waittill( "triggerab", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	door1 movez(168, 1);
	door2 movez(168, 1);
	killtrig maps\mp\_utility::triggerOn();
	killtrig delete();
	door1 movez(-168, 1);
	door2 movez(-168, 1);
	wait 5;
	door1 delete();
	door2 delete();
}

trap4()
{
	level endon("triggerabc");
	trig = getent("trap4_trig", "targetname");
	trap = getent("trap4", "targetname");
	trig waittill( "triggerabc", who ); 
	wait 0.1;
	trig delete();
	trap hide();
	wait 1;
	trap show();
}

trap5()
{
level endon("triggerabcd");
trig = getEnt( "trap5_trig", "targetname" );
trap5 = getEnt( "trap5", "targetname" );
hurt = getEnt ("trap5_hurt", "targetname"); 
hurt1 = getEnt ("trap5_hurt1", "targetname"); 
hurt2 = getEnt ("trap5_hurt2", "targetname"); 
hurt3 = getEnt ("trap5_hurt3", "targetname"); 
trap5 hide();
trap5 notsolid();
hurt maps\mp\_utility::triggerOff();
hurt1 maps\mp\_utility::triggerOff();
hurt2 maps\mp\_utility::triggerOff();
hurt3 maps\mp\_utility::triggerOff();

 
trig waittill ("triggerabcd");
trig delete();
 
{

    trap5 show();
    hurt maps\mp\_utility::triggerOn();
	hurt1 maps\mp\_utility::triggerOn();
	hurt2 maps\mp\_utility::triggerOn();
	hurt3 maps\mp\_utility::triggerOn();
    trap5 solid();

    }
}

trap6()
{
	level endon("triggerabcde");
	trig = getent("trap6_trig", "targetname");
	trap6_1 = getent("trap6_1", "targetname");
	trap6_2 = getent("trap6_2", "targetname");
	hurt1 = getent("trap6_hurt1", "targetname");
    hurt2 = getent("trap6_hurt2", "targetname");	
	trig waittill( "triggerabcde", who ); 
	wait 0.1;
	trig delete();
	while(1)
	{
	
	    hurt1 enablelinkto(); 
        hurt1 linkto (trap6_1);
		
		hurt2 enablelinkto(); 
        hurt2 linkto (trap6_2);
		
		wait .1;
		trap6_1 rotateYaw(-360,2);
		trap6_1 movey(-640, 1);
		trap6_1 waittill("movedone");
		trap6_2 rotateYaw(360,2);
		trap6_2 movey(576, 1);
		trap6_2 waittill("movedone");
		trap6_1 rotateYaw(360,2);
		trap6_1 movey(640, 1);
		trap6_1 waittill("movedone");
		trap6_2 rotateYaw(-360,2);
		trap6_2 movey(-576, 1);
		trap6_2 waittill("movedone");
		wait 1;
	}
}

trap7()
{
	level endon("triggerabcdef");
	trig = getent("trap7_trig", "targetname");
	trap = getent("trap7", "targetname");
	trig waittill( "triggerabcdef", who ); 
	wait 0.1;
	trig delete();
	while(1)
	{
		trap rotatePitch (360 , 2 );
		trap waittill("rotatedone");
		wait 0.5;
	}

}	

trap8()
{
	trig = getent("trap8_trig", "targetname");
	trap8_a = getent("trap8_a", "targetname");
	trap8_b = getent("trap8_b", "targetname");
	trig delete();
	trap8_a delete();
	trap8_b delete();
}

trap9()
{
	level endon("triggerabcdefg");
	trig = getent("trap9_trig", "targetname");
	trap = getent("trap9", "targetname");
	trig waittill( "triggerabcdefg", who ); 
	wait 0.1;
	trig delete();
	while(1)
	{
		trap rotatePitch (-360 , 3 );
		wait 3;
	}

}

trap10()
{
	level endon("triggerabcdefgh");
	trig = getent("trap10_trig", "targetname");
	trap10_a = getent("trap10_a", "targetname");
	trap10_b = getent("trap10_b", "targetname");
	trig waittill( "triggerabcdefgh", who );
	wait 0.1;
    trig delete(); 	
	while(1)
	{
	trap10_a movex(192, 1);
	trap10_b movex(-128, 1);
	wait 1;
	trap10_a movex(-192, 1);
	trap10_b movex(128, 1);
	wait 1;
	
    }
}	

trap11()
{
	level endon("triggerabcdefghi");
	trig = getent("trap11_trig", "targetname");
	trap = getent("trap11", "targetname");
	trig waittill( "triggerabcdefghi", who ); 
	wait 0.1;
	trig delete();
	while(1)
	{
		trap rotatePitch (360 , 3 );
		wait 3;
	}

}

trap12()
{
	level endon("triggerabcdefghij");
	trig = getent("trap12_trig", "targetname");
	trap12 = getent("trap12", "targetname");
	trig waittill( "triggerabcdefghij", who ); 
	wait 0.1;
	trig delete();
	trap12 movex(-624, 1);
	wait 3;
	trap12 movex(624, 1);
	wait 3;

	
}

trap13()
{
	level endon("triggerabcdefghijk");
	trig = getent("trap13_trig", "targetname");
	trap13 = getent("trap13", "targetname");
	trig waittill( "triggerabcdefghijk", who );
	wait 0.1;
    trig delete(); 	
	while(1)
	{
	trap13 movey(192, 1);
	wait 1;
	trap13 movey(-192, 1);
	wait 1;
	
    }
}

trap14()
{
	level endon("triggerabcdefghijkl");
	trig = getent("trap14_trig", "targetname");
	trap14 = getent("trap14", "targetname");
	trig waittill( "triggerabcdefghijkl", who ); 
	wait 0.1;
	trig delete();
	trap14 movex(624, 1);
	wait 3;
	trap14 movex(-624, 1);
	wait 3;

	
}

trap15()
{
	level endon("triggerabcdefghijklm");
	trig = getent("trap15_trig", "targetname");
	tank = getent("tank", "targetname");
	tanktrig = getent("trig_hurt", "targetname");
	tanktrig enablelinkto();
	tanktrig linkto(tank);
	trig waittill( "triggerabcdefghijklm", who );
	wait 0.1;
	tank movey(776, 4);
	wait 4;
	tank movey(-776, 4);
	trig delete();
}

trap16()
{
	level endon("triggerabcdefghijklmn");
	trig = getent("trap16_trig", "targetname");
	trap16 = getent("trap16", "targetname");
	trig waittill( "triggerabcdefghijklmn", who ); 
	wait 0.1;
	trig delete();
	trap16 movex(-320, 1);
	wait 3;
	trap16 movex(320, 1);
	wait 3;

	
}

teleport()
{

	target = getEnt( "teleport_target", "targetname" );
	trig = getent("teleport_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}

trap3()
{
	level endon("triggerabcdefghijklmno");
	trig = getent("trap3_trig", "targetname");
	heli = getent("helicopter", "targetname");
	door3 = getent("door3", "targetname");
	door4 = getent("door4", "targetname");
	hurt = getent("helicopter_trig", "targetname");
	hurt enablelinkto();
	hurt linkto(heli);
	trig waittill( "triggerabcdefghijklmno", who ); 
	trig delete();
	door3 movez(216, 1);
	door4 movez(216, 1);
	wait 1;
	heli movey(-600,3);
	heli rotatePitch (70 , .1 );
	heli rotateYaw(720,3);
	heli movez(-768,2);
	wait 2;
	heli delete();
	wait 2;
	hurt delete();
	door3 movez(-216, 1);
	door4 movez(-216, 1);
}
