//Map by Night Howl
 
 
main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
   
    setdvar( "r_specularcolorscale", "1" );
 
    setdvar("r_glowbloomintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
    setdvar("r_glowskybleedintensity0",".1");

    thread sr\api\_map::createSpawn((-3720, 5552, 540), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
    thread sr\api\_speedrun::createEndMap((7575.08, -5464.82, 560.125),295,120, "normal_0");

    thread sr_sec_enter();
 
//thread messages();
thread startdoor();
thread trap1();
thread trap2();
thread trap3();
thread trap4();
thread trap4_1();
thread trap4_2();
thread trap5();
thread trap5_1();
thread trap6();
thread trap7();
thread trap8();
thread trap9();
thread trap9_1();
thread trap9_2();
thread trap9_3();
thread trap10();
thread trap11();
thread trap12();
thread trap12_1();
thread trap12_2();
thread trap12_3();
thread trap12_4();
thread trap13();
//thread sniper();
//thread bounce();
//thread old();
//thread knife();
//thread teleportb();
//thread teleportba();
//thread secrettel();
thread secretf1();
thread secretf2();
thread secretfin();
//thread music1();



addTriggerToList( "trig_trap1" );
addTriggerToList( "trig_trap2" );
addTriggerToList( "trig_trap3" );
addTriggerToList( "trig_trap4" );
addTriggerToList( "trig_trap5" );
addTriggerToList( "trig_trap6" );
addTriggerToList( "trig_trap7" );
addTriggerToList( "trig_trap8" );
addTriggerToList( "trig_trap9" );
addTriggerToList( "trig_trap10" );
addTriggerToList( "trig_trap11" );
addTriggerToList( "trig_trap12" );


 
}
sr_sec_enter()
{
	trig = spawn("trigger_radius",(-3719.95, 5388.14, 480.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_secret","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
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

messages()
{
wait 10;
iprintlnBold("^2Are ^4You ^3Noob ^5At ^6Sniper ^1?");
wait 15;
iprintln("^2This ^4Map ^6Made ^5By ^3Most ^0Faster");
wait 25;
iprintln("^2Special ^4Thanks ^6To ^5$niper ^3Noob ^0<3");
wait 35;
iprintln("^2Special ^4Thanks ^6To ^5[Tr]Burak");
wait 45;
iprintln("^2Special ^4Thanks ^6To ^5Failzor");
wait 55;
iprintln("^2This ^4Map ^6Made ^5By ^3Most ^0Faster");
wait 65;
iprintln("^2Special ^4Thanks ^6To ^5$niper ^3Noob ^0<3");
wait 75;
iprintln("^2Special ^4Thanks ^6To ^5[Tr]Burak");
wait 85;
iprintln("^2Special ^4Thanks ^6To ^5Failzor");
}

music1()
{
    level waittill( "round_started" );
   
    wait 1;
   
    ambientPlay( "ambient" );
}

startdoor()
{
    door = getEnt("startdoor", "targetname");
    
    wait 0.1;

    door delete();
} 


trap1()
{
    platform = getEnt("trap1", "targetname");
    trig = getEnt("trig_trap1", "targetname");
	trig waittill("trigger", player);
   

    
}

trap2()
{
    platform = getEnt("trap2", "targetname");
    trig = getEnt("trig_trap2", "targetname");
    trig waittill("trigger", player);
   
 
}  

trap3()
{
    platform = getEnt("trap3", "targetname");
    trig = getEnt("trig_trap3", "targetname");
    trig waittill("trigger", player);
  
} 


trap4()
{
    platform = getEnt("trap4", "targetname");
    trig = getEnt("trig_trap4", "targetname");
	trig waittill("trigger", player);
   
    
}

trap4_1()
{
        platform = getEnt("trap4_1", "targetname");
        trig = getEnt("trig_trap4", "targetname");
        trig waittill("trigger", player);
 
}

trap4_2()
{
    platform = getEnt("trap4_2", "targetname");
    trig = getEnt("trig_trap4", "targetname");
	trig waittill("trigger", player);
   
}


trap5()
{
    platform = getEnt("trap5", "targetname");
    trig = getEnt("trig_trap5", "targetname");
	trig waittill("trigger", player);
   
  
}

trap5_1()
{
    platform = getEnt("trap5_1", "targetname");
    trig = getEnt("trig_trap5", "targetname");
	trig waittill("trigger", player);
   
    
}


trap6()
{
        platform = getEnt("trap6", "targetname");
        trig = getEnt("trig_trap6", "targetname");
        trig waittill("trigger", player);
 
   
}


trap7()
{
    platform = getEnt("trap7", "targetname");
    trig = getEnt("trig_trap7", "targetname");
	trig waittill("trigger", player);
   
  
	   
}

trap8()
{
    platform = getEnt("trap8", "targetname");
    trig = getEnt("trig_trap8", "targetname");
	trig waittill("trigger", player);
   
    
	   
}

trap9()
{
    platform = getEnt("trap9", "targetname");
    trig = getEnt("trig_trap9", "targetname");
	trig waittill("trigger", player);
   
 	   
}

trap9_1()
{
    platform = getEnt("trap9_1", "targetname");
    trig = getEnt("trig_trap9", "targetname");
	trig waittill("trigger", player);
   
   
		   
}

trap9_2()
{
    platform = getEnt("trap9_2", "targetname");
    trig = getEnt("trig_trap9", "targetname");
	trig waittill("trigger", player);
   
  
		   
}

trap9_3()
{
    platform = getEnt("trap9_3", "targetname");
    trig = getEnt("trig_trap9", "targetname");
	trig waittill("trigger", player);
   
  
}



trap10()
{
    platform = getEnt("trap10", "targetname");
    trig = getEnt("trig_trap10", "targetname");
	trig waittill("trigger", player);
   
  
 


	
		   
}

trap11()
{
    platform = getEnt("trap11", "targetname");
    trig = getEnt("trig_trap11", "targetname");
    trig waittill("trigger", player);
   
} 


trap12()
{
        platform = getEnt("trap12", "targetname");
        trig = getEnt("trig_trap12", "targetname");
        trig waittill("trigger", player);
 
   
} 

trap12_1()
{
        platform = getEnt("trap12_1", "targetname");
        trig = getEnt("trig_trap12", "targetname");
        trig waittill("trigger", player);
 
  
} 

trap12_2()
{
        platform = getEnt("trap12_2", "targetname");
        trig = getEnt("trig_trap12", "targetname");
        trig waittill("trigger", player);
 
  
} 

trap12_3()
{
        platform = getEnt("trap12_3", "targetname");
        trig = getEnt("trig_trap12", "targetname");
        trig waittill("trigger", player);
 
  
} 

trap12_4()
{
        platform = getEnt("trap12_4", "targetname");
        trig = getEnt("trig_trap12", "targetname");
        trig waittill("trigger", player);
 
} 

trap13()
{
        platform = getEnt("trap13", "targetname");
        trig = getEnt("trig_trap13", "targetname");
        trig waittill("trigger", player);
 
  
}
    

old()
{

            level.old_trigger = getent ( "trig_old", "targetname" );
			level.sniper_trigger = getEnt("trig_sniper","targetname");
            level.knife_trigger = getEnt("trig_knife","targetname");
            level.bounce_trigger = getEnt("trig_bounce","targetname");
			door = getent ( "oldroom", "targetname" );
			level.old_trigger waittill ( "trigger", player );
			
			{
			
			level.old_trigger delete();
			level.knife_trigger delete();
            level.bounce_trigger delete();
			level.sniper_trigger delete();
			
			iprintlnBold( "^8" + player.name + "^3 Entered The Old Room");
			door moveZ (-350, 4);
			wait 1;
			}
}


sniper()
{
level.sniper_trigger = getEnt("trig_sniper","targetname");
level.knife_trigger = getEnt("trig_knife","targetname");
level.bounce_trigger = getEnt("trig_bounce","targetname");
level.old_trigger = getEnt("trig_old","targetname");
level.teleactorigin = getEnt("sniper_activator", "targetname");
telejumporigin = getEnt("sniper_jumper", "targetname");

while(1)
{
level.sniper_trigger waittill( "trigger", player );

if( !isDefined( level.sniper_trigger ) )
return;
if(level.firstenter==true)
{
level.old_trigger delete();
level.knife_trigger delete();
level.bounce_trigger delete();
level.firstenter=false;
} 
wait(0.05);

player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon("m40a3_mp");
player GiveWeapon( "remington700_mp" ); 
player GiveMaxAmmo("m40a3_mp");
player GiveMaxAmmo( "remington700_mp" );
wait .05;
player SwitchToWeapon("m40a3_mp"); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "m40a3_mp" );
level.activ GiveWeapon( "remington700_mp" );
level.activ GiveMaxAmmo("m40a3_mp");
level.activ GiveMaxAmmo( "remington700_mp" );
wait .05;
level.activ SwitchToWeapon("m40a3_mp"); 
iPrintlnBold( " ^8" + player.name + " ^4 has entered the Sniper room^8!" ); 
wait(0.05);
player switchToWeapon( "m40a3_mp" );
level.activ SwitchToWeapon( "m40a3_mp" );




player waittill( "death" );
level.PlayerInRoom = false;

}
}	


bounce()
{
level.bounce_trigger = getEnt("trig_bounce","targetname");
level.knife_trigger = getEnt("trig_knife","targetname");
level.sniper_trigger = getEnt("trig_sniper","targetname");
level.old_trigger = getEnt("trig_old","targetname");
level.teleactorigin = getEnt("bounce_activator", "targetname");
telejumporigin = getEnt("bounce_jumper", "targetname");

while(1)
{
level.bounce_trigger waittill( "trigger", player );

if( !isDefined( level.bounce_trigger ) )
return;
if(level.firstenter==true)
{
level.old_trigger delete();
level.sniper_trigger delete();
level.knife_trigger delete();
level.firstenter=false;
} 
wait(0.05);

player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon("knife_mp");
player GiveMaxAmmo("knife_mp");
wait .05;
player SwitchToWeapon("knife_mp"); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" );
level.activ GiveMaxAmmo("knife_mp");
wait .05;
level.activ SwitchToWeapon("knife_mp"); 
iPrintlnBold( " ^8" + player.name + " ^4 has entered the Bounce room^8!" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );




player waittill( "death" );
level.PlayerInRoom = false;

}
}	

knife()
{
level.knife_trigger = getEnt("trig_knife","targetname");
level.bounce_trigger = getEnt("trig_bounce","targetname");
level.sniper_trigger = getEnt("trig_sniper","targetname");
level.old_trigger = getEnt("trig_old","targetname");
level.teleactorigin = getEnt("knife_activator", "targetname");
telejumporigin = getEnt("knife_jumper", "targetname");

while(1)
{
level.knife_trigger waittill( "trigger", player );

if( !isDefined( level.knife_trigger ) )
return;
if(level.firstenter==true)
{
level.old_trigger delete();
level.sniper_trigger delete();
level.bounce_trigger delete();
level.firstenter=false;
} 
wait(0.05);

player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon("knife_mp");
player GiveMaxAmmo("knife_mp");
wait .05;
player SwitchToWeapon("knife_mp"); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" );
level.activ GiveMaxAmmo("knife_mp");
wait .05;
level.activ SwitchToWeapon("knife_mp"); 
iPrintlnBold( " ^8" + player.name + " ^4 has entered the Knife room^8!" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );




player waittill( "death" );
level.PlayerInRoom = false;

}
}			


addTriggerToList( name, positionOfIconAboveTrap )
{ 
if( !isDefined( level.trapTriggers ) )
 level.trapTriggers = [];
 level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
 
 if( !isDefined( level.icon_origins ) ) 
 level.icon_origins = [];
 level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
}


teleportb()
{
    trig = getEnt("trig_bouncef", "targetname");
    telel = getEnt("bounce_jumper","targetname");
   
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(telel.origin);
        player iPrintlnBold( "^5You Respawned" );
    }
}

teleportba()
{
    trig = getEnt("trig_bouncefa", "targetname");
    telel = getEnt("bounce_activator","targetname");
   
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(telel.origin);
        player iPrintlnBold( "^5You Respawned" );
    }
}

secrettel()
{
    trig = getEnt("teleport_secret", "targetname");
    telel = getEnt("origin_secret","targetname");
   
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(telel.origin);
        iPrintlnBold( " ^8" + player.name + " ^4 has entered the Secret Room^8!" ); 
    }
}

secretfin()
{
    trig = getEnt("trig_secretfin", "targetname");
    telel = getEnt("origin_secretf","targetname");
   
    for(;;)
    {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}


secretf1()
{
    trig = getEnt("teleport_secretfall1", "targetname");
    telel = getEnt("origin_secretfall1","targetname");
   
    for(;;)
    {
        trig waittill("trigger", player);
        player Suicide();
    }
}


secretf2()
{
    trig = getEnt("teleport_secretfall2", "targetname");
    telel = getEnt("origin_secretfall2","targetname");
   
    for(;;)
    {
        trig waittill("trigger", player);
        player Suicide();
    }
}





