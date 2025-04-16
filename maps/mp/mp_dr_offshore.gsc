/*Map Dedicated to my Beloved Vistic
 Map By CoMpy.
 /devmap mp_dr_offshore


                                                                                                            
     ***** *      **           *****  *       *******      ****           *         *****  *       * ***    
  ******  *    *****        ******  *       *       ***   *  *************       ******  *       *  ****  * 
 **   *  *       *****     **   *  *       *         **  *     *********        **   *  *       *  *  ****  
*    *  **       * **     *    *  *        **        *   *     *  *            *    *  *       *  **   **   
    *  ***      *             *  *          ***           **  *  **                *  *       *  ***        
   **   **      *            ** **         ** ***            *  ***               ** **      **   **        
   **   **      *            ** **          *** ***         **   **               ** **      **   **        
   **   **     *           **** **            *** ***       **   **             **** **      **   **        
   **   **     *          * *** **              *** ***     **   **            * *** **      **   **        
   **   **     *             ** **                ** ***    **   **               ** **      **   **        
    **  **    *         **   ** **                 ** **     **  **          **   ** **       **  **        
     ** *     *        ***   *  *                   * *       ** *      *   ***   *  *         ** *      *  
      ***     *         ***    *          ***        *         ***     *     ***    *           ***     *   
       *******           ******          *  *********           *******       ******             *******    
         ***               ***          *     *****               ***           ***                ***      
                                        *                                                                   
                                         **                                                                 
                                                                                                            

*/

main()
{
    maps\mp\_load::main();
    //maps\mp\mp_dr_offshore_fx::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("bg_falldamageminheight" , "99998");
	  setdvar("bg_falldamagemaxheight" , "99999");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-25298, -744, -28), 360);


    //thread music();
    //thread endmap_trig();
    //thread vc();
    //thread kniferoom();
    //thread sniproom();
    //thread jumproom();
    //thread jumperfailb();
    //thread bounceactif();
    //thread givesniper();
    //thread roomselection();
    thread startdoor();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();
    //thread trap8();
    //thread trap9();
    //thread trap10();

     addTriggerToList( "trigger_trap2" );
     addTriggerToList( "trigger_trap3" );
     addTriggerToList( "trigger_trap4" );
     addTriggerToList( "trigger_trap5" );
     addTriggerToList( "trigger_trap6" );
     addTriggerToList( "trigger_trap7" );
     addTriggerToList( "trigger_trap8" );
     addTriggerToList( "trigger_trap9" );
     addTriggerToList( "trigger_trap10" );

}

addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];
    
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

music()
{
     fog = getEnt("fog", "targetname");
     fire1 = getEnt("fire1", "targetname");
     fire2 = getEnt("fire2", "targetname");
     fire3 = getEnt("fire3", "targetname");
     waves = getEnt("waves", "targetname");
     rotatingskybox = getEnt("rotatingskybox", "targetname");
    
 
      maps\mp\_fx::loopfx("effect_1", (fog.origin), 1);
      maps\mp\_fx::loopfx("effect_2", (fire1.origin), 5);
      maps\mp\_fx::loopfx("effect_2", (fire2.origin), 5);
      maps\mp\_fx::loopfx("effect_2", (fire3.origin), 5);
      maps\mp\_fx::loopfx("effect_3", (waves.origin), 10);
      maps\mp\_fx::loopfx("effect_4", (rotatingskybox.origin), 30);


    level.music = randomint(1);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
     AmbientPlay( "nocy" );
     break;
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

vc()
{
 vistic_logo = getent("vishtick","targetname");                               
  for(;;) 
  {
   vistic_logo rotateYaw (360,7);
   wait 1;
  }
      
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
    jump = getent("trigger_bounceroom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    knife thread maps\mp\_utility::triggerOff();
    jump thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    scope thread maps\mp\_utility::triggerOn();
    knife thread maps\mp\_utility::triggerOn();
    jump thread maps\mp\_utility::triggerOn();
}

kniferoom()
{
   
   level.trigger_knife = getEnt ("trigger_kniferoom", "targetname");

    jumperk = getEnt ("origin_knifejumper", "targetname");
    actik = getEnt ("origin_knifeacti", "targetname");

   for(;;)
    {
        level.trigger_knife setHintString ("Press [&&1] to enter Knife Room.");
        level.trigger_knife waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
	    player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        activator setOrigin (actik.origin);
        activator setPlayerAngles (actik.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("knife_mp");
        activator giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        activator switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
                       while(isDefined(player) && isAlive(player))
            wait .05;
        
        iPrintLnBold ("" + player.name + " has died in Knife Room");
    }
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

jumproom()
{
   level.trigger_jump = getEnt ("trigger_bounceroom", "targetname");

    jumperk = getEnt ("origin_bouncejumper", "targetname");
    actik = getEnt ("origin_bounceactif", "targetname");

  for(;;)
    {
        level.trigger_jump setHintString ("Press [&&1] to enter JumpRoom");
        level.trigger_jump waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
	    player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        activator setOrigin (actik.origin);
        activator setPlayerAngles (actik.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("knife_mp");
        activator giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        activator switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
                       while(isDefined(player) && isAlive(player))
            wait .05;
        
        iPrintLnBold ("" + player.name + " has died in Jump Room");
    }
}

jumperfailb()//jumper respawn bounce r
{
   trigb = getent("trigger_jumperf", "targetname");
   teleb = getent ("origin_bouncejumper", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

bounceactif()// acti respawn bounce r
{
   trigb = getent("trigger_bounceactif", "targetname");
   teleb = getent ("origin_bounceactif", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

givesniper()// give snip in jump r 
{
givesnip = getEnt("givesnip_trig","targetname");
givesnip setHintString ("Press F for weapons");

	for (;;)
	{
		givesnip waittill("trigger", player);
		player takeallweapons();
		wait 0.1;
		player giveweapon("deserteagle_mp");
		player giveweapon("m40a3_mp");
		player switchtoweapon("deserteagle_mp");
		player givemaxammo("deserteagle_mp");
		player givemaxammo("m40a3_mp");
	}
}

roomselection()
{
   trig = getent("roomselection_trig", "targetname");
   tele1 = getent ("origin_roomselection", "targetname");
   trig setHintString ("^0Press ^4[&&1]^0 to enter ^4Room Selection^0!");
   
   while(1)
    {   
     trig waittill ("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     while (isDefined(player) && isAlive(player))
        wait .05;
    }
}

startdoor()

{
  door = getent("door","targetname");

  door delete();
}

trap2()
{
     plankt1 = getent("trap2","targetname");
     trig = getent("trigger_trap2", "targetname");
     trig setHintString("T2: Unstable terrain");
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
     trig setHintString("T3: Unstable platform for 5 sec");
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

trap4()
{
     plat1 = getent("trap4","targetname");
     trig = getent("trigger_trap4", "targetname");
     trig setHintString("T4: Rotate rotator");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plat1 rotateYaw(360,3);
     wait 0.1;
   }
      
}

trap5()
{
     plat1 = getent("trap5","targetname");
     trig = getent("trigger_trap5", "targetname");
     trig setHintString("T5: Rotate rotator");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plat1 rotateYaw(360,3);
     wait 0.1;
   }
      
}

trap6()
{
     plat1 = getent("trap6","targetname");
     trig = getent("trigger_trap6", "targetname");
     trig setHintString("T6: Rotate rotator");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plat1 rotateYaw(360,3);
     wait 0.1;
   }
      
}

trap7()
{
    trig = getEnt ("trigger_trap7", "targetname");
	trap7a = getEnt ("trap7a", "targetname");
	trap7b = getEnt ("trap7b", "targetname");
  trig setHintString("T7: Move upndown");
	
	trig waittill ("trigger", player );
  trig setHintString("^7Activated");
	
	while (1)
	{
	    trap7a moveZ (-80, 3);
		trap7b moveZ (30, 3);
		wait 3;
		trap7a moveZ (110, 6);
		trap7b moveZ (-110, 6);
		wait 6;
		trap7a moveZ (-30, 3);
		trap7b moveZ (80, 3);
		wait 3;
	}
}

trap8()
{
 part1 = getentarray("trap8a","targetname");
 part2 = getentarray("trap8b","targetname");
 part3 = getentarray("trap8c","targetname");
 part4 = getentarray("trap8d","targetname");
 part5 = getentarray("trap8e","targetname");
 part6 = getentarray("trap8f","targetname");
 part7 = getentarray("trap8g","targetname");
 part8s = getentarray("trap8s","targetname");
 trig = getent("trigger_trap8","targetname");
 trig  setHintString("T8: Randomly unstable pillars");
 trig waittill("trigger" , user );
 if(user.pers["team"] != "axis")
{
	wait 0.2;
}
 else if(level.trapsdisabled)
{

}
 else
 trig delete();
 trig SetHintString("^7Activated");
 random = randomint(2);
	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();
				part5[randomInt(part5.size)] notsolid();
        part7[randomInt(part7.size)] notsolid();
        part8s[randomInt(part8s.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();
				part6[randomInt(part6.size)] notsolid();
                break;
				
		default: return;
	}
}

trap9()
{
     plankt1 = getent("trap9","targetname");
     trig = getent("trigger_trap9", "targetname");
     trig setHintString("T9: Rotate bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotateYaw(360,3);
     wait 5;
   }
      
}

trap10()
{
     plankt1 = getent("trap10","targetname");
     trig = getent("trigger_trap10", "targetname");
     trig setHintString("T10: Rotate bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
    
	for(;;)
   { 
     wait 0.1;
     plankt1 rotateYaw(-360,3);
     wait 5;
   }
      
}