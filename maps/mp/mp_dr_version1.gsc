/*
 Map By CoMpy.
 /devmap mp_dr_version1                                                                                                

*/

main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";


    //thread music();
    //thread trap0();//auto
    //thread trap01();//auto
    //thread endmap_trig();
    //thread sniproom();
    //thread sniperfail();
    //thread actisa();
    //thread actisa1();
    thread trap1();
     thread trap2();
     thread trap3();
     thread trap4();

     thread sr\api\_speedrun::createNormalWays("Normal Way;");
     thread sr\api\_map::createSpawn((629, 1, 76), 1);

     addTriggerToList( "trigger_trap1" );
     addTriggerToList( "trigger_trap2" );
     addTriggerToList( "trigger_trap3" );
     addTriggerToList( "trigger_trap4" );

}

addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];
    
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

music()
{
    level.music = randomint(2);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
     AmbientPlay( "unravel" );
     break;

     case 1:
     AmbientPlay( "unravel1" );
     break;
   }
}

trap0()
{
    cyli = getent("hulundert01","targetname");   
    cyli1 = getent("hulundert00","targetname");                                
    for(;;) 
    {
        cyli rotateYaw (360,7);
        cyli1 rotateYaw (360,7);
        wait 6.95;
    }
}

trap01()
{
    cyli = getent("tower","targetname");                               
    for(;;) 
    {
        cyli rotateYaw (360,7);
        wait 7;
        cyli rotateYaw (-360,7);
        wait 7;
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
    knife = getent("trigger_kniferoom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    knife thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    scope thread maps\mp\_utility::triggerOn();
    knife thread maps\mp\_utility::triggerOn();
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

sniperfail()//respawn in siniper sroom
{
   trigb = getent("trigger_failer1", "targetname");
   teleb = getent ("origin_failer1", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

actisa()//actisecondarea
{
   trig = getent("trigger_actisa", "targetname");
   tele1 = getent ("origin_actisa", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actisa1()//acti3rdarea
{
   trig = getent("trigger_actisa1", "targetname");
   tele1 = getent ("origin_actisa1", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

trap1()
{
     plat1 = getent("trap1","targetname");
     plat2 = getent("trap1a","targetname");
     trig = getent("trigger_trap1", "targetname");
     trig setHintString("T1: Rotate 2 plats");
     trig waittill ("trigger");
  
}

trap2()
{
    platform = getent("trap2", "targetname");
    trig = getent("trigger_trap2", "targetname");
    trig setHintString("T2; Unstable some parts");
    trig waittill ("trigger");
} 

trap3()
{
     plat1 = getent("trap3","targetname");
     trig = getent("trigger_trap3", "targetname");
     trig setHintString("T3: Rotate bounce");
     trig waittill ("trigger");
   
      
}

trap4()
{
     plat1 = getent("trap4","targetname");
     trig = getent("trigger_trap4", "targetname");
     trig setHintString("T4: Rotate cylinder");
     trig waittill ("trigger");
  
      
}