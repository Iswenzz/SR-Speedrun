main()
{
    maps\mp\_load::main();
    //maps\mp\mp_dr_divine_fx::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    //setdvar("g_speed" ,"200");

    thread sr\api\_map::createSpawn((-1348, -148, 226), 88);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

    thread teleportsroutenormal();
    thread teleportsroutenormal1();
    thread teleportsroutenormal2();
    //thread actitele();
    //thread music();
    //thread messages();
    //thread sniproom();
    //thread endmap_trig();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread rotator();
    //thread naughtyjumper();

   addTriggerToList( "trigger_trap1" );
    addTriggerToList( "trigger_trap2" );
    addTriggerToList( "trigger_trap3" );
    addTriggerToList( "trigger_trap4" );
    addTriggerToList( "trigger_trap5" );
}

addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];
    
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

teleportsroutenormal()//1
{
   trig = getent("trigger_tp1", "targetname");
   tele1 = getent ("origin_tp1", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	    player setOrigin(tele1.origin);
        player setPlayerAngles(tele1.angles);
        player freezeControls(1);
        wait 0.05;
        player freezeControls(0);
        wait 0.05;
    }
}

teleportsroutenormal1()//2 to 2nd
{
   trig = getent("trigger_tp2", "targetname");
   tele1 = getent ("origin_tp2", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	    player setOrigin(tele1.origin);
        player setPlayerAngles(tele1.angles);
        player freezeControls(1);
        wait 0.05;
        player freezeControls(0);
        wait 0.05;
    }
}

teleportsroutenormal2()//3 to end
{
   trig = getent("trigger_tp3", "targetname");
   tele1 = getent ("origin_tp3", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	    player setOrigin(tele1.origin);
        player setPlayerAngles(tele1.angles);
        player freezeControls(1);
        wait 0.05;
        player freezeControls(0);
        wait 0.05;
    }
}

actitele()//1
{
   trig = getent("trigger_acti1", "targetname");
   tele1 = getent ("origin_acti1", "targetname");
   trig setHintString ("^6Next area");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

music()
{

  glow1 = getEnt("glow1", "targetname");
  glow2 = getEnt("glow2", "targetname");
  glow3 = getEnt("glow3", "targetname");
  glow4 = getEnt("glow4", "targetname");
  fire = getEnt("endroomfire", "targetname");
  splash = getEnt("splash", "targetname");
  
  maps\mp\_fx::loopfx("effect_1", (glow1.origin), 3);
  maps\mp\_fx::loopfx("effect_1", (glow2.origin), 3);
  maps\mp\_fx::loopfx("effect_1", (glow3.origin), 3);
  maps\mp\_fx::loopfx("effect_1", (glow4.origin), 3);
  maps\mp\_fx::loopfx("effect_2", (splash.origin), 7);
  maps\mp\_fx::loopfx("effect_3", (fire.origin), 3);

    level.music = 0;
    level waittill("round_started");
    AmbientPlay( "louloudi" );
}

messages()
{    

    wait 15;
     
    iprintln ("^5Anymood - Just Mine");

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
	
	return undefined;
}

waitdead()
{
    activator = GetActivator();
    scope = getent("trigger_sniproom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    if(isdefined(activator))
        activator freezeControls(false);
    if(isdefined(self))
        self freezeControls(false);
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

        if(!isdefined(getactivator())){ player iprintln("^1No Activator Detected"); continue; }
        
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

        player.health = player.maxhealth;
        activator.health = activator.maxhealth;


        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("" + player.name + " died in scope room");
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
	firstPlace.hidewheninmenu = false;
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

trap1()
{
     plankt1 = getent("trap1","targetname");
     trig = getent("trigger_trap1", "targetname");
     trig setHintString("T1: Unstable the bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
	 plankt1 notsolid();
	 wait 5;
	 plankt1 solid();
	wait 2000;
   }
      
}

trap2()
{
     plankt1 = getent("trap2","targetname");
     plankt2 = getent("trap2a","targetname");
     trig = getent("trigger_trap2", "targetname");
     trig setHintString("T2: Rotate 4 platforms");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotatePitch(360,3);
     plankt2 rotatePitch(-360,3);
     wait 5;
   }
      
}

trap3()
{
     plankt1 = getent("trap3","targetname");
     plankt2 = getent("trap3a","targetname");
     plankt3 = getent("trap3b","targetname");
     trig = getent("trigger_trap3", "targetname");
     trig setHintString("T3: Rotate 3 platforms up");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotatePitch(360,1);
     plankt2 rotatePitch(-360,1);
     plankt3 rotatePitch(360,1);
     wait 2;
   }
      
}

trap4()
{
     plankt1 = getent("trap4","targetname");
     trig = getent("trigger_trap4", "targetname");
     trig setHintString("T4: Rotate 1 round platform");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 RotateYaw(360,3);
     wait 5;
   }
      
}

trap5()
{
     plankt1 = getent("trap5","targetname");
     trig = getent("trigger_trap5", "targetname");
     trig setHintString("T5: Rotate bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 RotateYaw(360,3);
     wait 5;
   }
      
}

rotator()//deco shit
{
 name = getent("rotator","targetname");                 
  for(;;) 
  {
   name rotateYaw (360,5);
   wait 1;
  }
}

naughtyjumper()//top of acti returbn
{
   trig = getent("trigger_reeturn", "targetname");
   tele1 = getent ("origin_reeturn", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}
