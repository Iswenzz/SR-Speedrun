
main()
{
    maps\mp\_load::main();
    //maps\mp\mp_dr_ethereal3_v2_fx::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    //setdvar("g_speed" ,"200");
    setdvar("bg_falldamageminheight" , "99998");
    setdvar("bg_falldamagemaxheight" , "99999");
    //setdvar("bg_bobmax" , "0");

    thread sr\api\_map::createSpawn((1554, 2657,-516), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

    //thread music();
    //thread rotator();
    //thread endmap_trig();
    //thread sniproom();
    //thread actiarea1();
    //thread actiarea2();
    //thread actireturn1();
    //thread actireturn2();
    //thread rotator1();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();

     addTriggerToList( "trigger_trap1" );
     addTriggerToList( "trigger_trap2" );
     addTriggerToList( "trigger_trap3" );
     addTriggerToList( "trigger_trap4" );
     addTriggerToList( "trigger_trap5" );
     addTriggerToList( "trigger_trap6" );
     addTriggerToList( "trigger_trap7" );
}

addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];
    
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

music()
{

  snow1 = getEnt("snow1", "targetname");
  snow2 = getEnt("snow2", "targetname");
  snow3 = getEnt("snow3", "targetname");
  snow4 = getEnt("snow4", "targetname");
  vcglow = getEnt("vcglow", "targetname");
  treeglow = getEnt("treeglow", "targetname");
  actiglow = getEnt("actiglow", "targetname");
  actiglow2 = getEnt("actiglow2", "targetname");

  maps\mp\_fx::loopfx("effect_2", (snow1.origin), 1);
  maps\mp\_fx::loopfx("effect_2", (snow2.origin), 1);
  maps\mp\_fx::loopfx("effect_2", (snow3.origin), 1);
  maps\mp\_fx::loopfx("effect_2", (snow4.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (vcglow.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (treeglow.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (actiglow.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (actiglow.origin), 1);

    level.music = randomint(1);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
     AmbientPlay( "ethereal3" );
     break; 
     
   }
}

rotator()
{
 logo = getent("rotator","targetname");               
  for(;;) 
  {
   logo rotateYaw (360,8);
   wait 1;
  }
}

endmap_trig()
{ 
	trig = getEnt("endmap_trig", "targetname"); 	
	trig waittill ("trigger",player );
	firstPlace = newHudElem();
	firstPlace.foreground = true;
	firstPlace.alpha = 1;
	firstPlace.alignX = "left";
	firstPlace.alignY = "middle";
	firstPlace.horzAlign = "left";
	firstPlace.vertAlign = "middle"; 
	firstPlace.x = -400;
	firstPlace.y = 0;
	firstPlace.sort = 0;
	firstPlace.font = "default";
	firstPlace.fontScale = 1.4;
	firstplace.hidewheninmenu = false;
	firstPlace.glowAlpha = 1;
	firstPlace.glowColor = (.3,.0,3);
	firstPlace settext("^6"+ player.name+ " ^7Finished ^7First");
	firstPlace moveOverTime(2); 
	firstPlace.x = 5;
	wait 5;
	firstPlace moveOverTime(2); 
	firstPlace.x = -500;
	wait 7;
	firstPlace destroy(); 
}

GetActivator()
{
	players = getentarray( "player", "classname" );
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}
	
	return "Noactivator";
}

waitdead()
{
    activator = GetActivator();
    scope = getent("trigger_sniproom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    scope thread maps\mp\_utility::triggerOn();
}


sniproom()
{
    
    level.trigger_scope = getEnt ("trigger_sniproom", "targetname");

    jumpersc = getEnt ("origin_sniperjumper", "targetname");
    actisc = getEnt ("origin_sniperacti", "targetname");

    for(;;)
    {   
        level.trigger_scope setHintString ("Press [&&1] to enter Sniper Room");
        level.trigger_scope waittill ("trigger", player);

        player thread waitdead();
        activator = GetActivator();
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);    
        activator setOrigin (actisc.origin);
        activator setPlayerAngles (actisc.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("remington700_mp");
        activator giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        activator giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        activator giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        activator giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        activator switchToWeapon("m40a3_mp");   
        player.maxhealth = 100;
        

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("" + player.name + " died in scope room");
    }
}

actiarea1()
{
   trig = getent("trigger_area1", "targetname");
   tele1 = getent ("origin_area1", "targetname");
   trig setHintString ("Acti next area");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actiarea2()
{
   trig = getent("trigger_area2", "targetname");
   tele1 = getent ("origin_area2", "targetname");
   trig setHintString ("Acti next area");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actireturn1()//if fall return
{
   trig = getent("trigger_fail1", "targetname");
   tele1 = getent ("origin_fail1", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actireturn2()//if fall return
{
   trig = getent("trigger_fail2", "targetname");
   tele1 = getent ("origin_fail2", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

rotator1()
{
 rotator1 = getent("rotator1","targetname");
	                                  
  for(;;) 
  {
  rotator1 rotateYaw (360,4);
  wait 4;
  }
      
}

trap1()
{
     plankt1 = getent("trap1","targetname");
     plankt2 = getent("trap1a","targetname");
     plankt3 = getent("trap1b","targetname");
     trig = getent("trigger_trap1", "targetname");
     trig setHintString("T1: Rotate 3 platforms");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotateYaw(360,3);
     plankt2 rotateYaw(-360,3);
     plankt3 rotateYaw(360,3);
     wait 5;
   }
      
}

trap2()
{
     plankt1 = getent("trap2","targetname");
     trig = getent("trigger_trap2", "targetname");
     trig setHintString("T2: Unstable 1 part of the bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
	 plankt1 notsolid();
	 wait 2000;
	 plankt1 solid();
	wait 2000;
   }
      
}

trap3()
{
     plankt1 = getent("trap3","targetname");
     trig = getent("trigger_trap3", "targetname");
     trig setHintString("T3: Rotate bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotateYaw(360,4);
     wait 5;
   }
      
}

trap4()
{
     plankt1 = getent("trap4","targetname");
     trig = getent("trigger_trap4", "targetname");
     trig setHintString("T4: Unstable 3 parts");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
	 plankt1 notsolid();
	 wait 2000;
	 plankt1 solid();
	wait 2000;
   }
      
}

trap5()
{
     plankt1 = getent("trap5","targetname");
     trig = getent("trigger_trap5", "targetname");
     trig setHintString("T5: Unstable 2 parts behind");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
	 plankt1 notsolid();
	 wait 2000;
	 plankt1 solid();
	wait 2000;
   }
      
}

trap6()
{
     plankt1 = getent("trap6","targetname");
     trig = getent("trigger_trap6", "targetname");
     trig setHintString("T6: Rotate platform");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotateroll(360,4);
     wait 5;
   }
      
}

trap7()
{
     plankt1 = getent("trap7","targetname");
     trig = getent("trigger_trap7", "targetname");
     trig setHintString("T7: Rotate platform");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotateroll(360,4);
     wait 5;
   }
      
}