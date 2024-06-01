/*
 Map By CoMpy.
 /devmap mp_dr_broken2
*/

main()
{
    maps\mp\_load::main();
	//maps\mp\mp_dr_broken2_fx::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((881, -573, 76), 270);

 
     //thread messagescreen();
    // thread endmap_trig();
	// thread music();
	 thread jumpersa();//tp to second area jumper
	 thread returnsa();//return from second area jumper
     //thread roomselection();
    // thread roomreturn();//if fall in gaps in room selection return
     //thread kniferoom();
     //thread weaponroom();
     //thread sniproom();
     thread trap1();
     thread trap2();
     thread trap3();
     thread trap4();
     thread trap5();
     thread trap6();
     thread trap7();

     addTriggerToList( "trigger_trap1" );
     addTriggerToList( "trigger_trap2" );
     addTriggerToList( "trigger_trap3" );
     addTriggerToList( "trigger_trap4" );
     addTriggerToList( "trigger_trap5" );
     addTriggerToList( "trigger_trap6" );
     addTriggerToList( "trigger_trap7" );
}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale )
{
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}

createHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 1;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
}

addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];
    
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

messagescreen()
{
	 level waittill("round_started");
	 wait 1;
	 noti = SpawnStruct();
    noti.TitleText = "^9V1 by ^5ERIK";
    noti.notifyText = "^9V2 By ^6CoMpy";
	noti.duration = 8;
	noti.glowcolor = (1,1,1);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

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

music()
{
     brokenfx= getEnt("brokenfx", "targetname");
     fx4 = getEnt("firefx1", "targetname");
     selefx1 = getEnt("selefx1", "targetname");
     selefx2 = getEnt("selefx2", "targetname");
     selefx3 = getEnt("selefx3", "targetname");
	 goldfirefly1= getEnt("safx2", "targetname");
	 goldfirefly2 = getEnt("safx3", "targetname");
     goldsnow = getEnt("safx1", "targetname");
	 fx1 = getEnt("trap1fx", "targetname");
     fx2 = getEnt("turnfx", "targetname");
     fx3 = getEnt("roomfx1", "targetname");
     fx4 = getEnt("firefx1", "targetname");
     fx5 = getEnt("weatherfx", "targetname");

     maps\mp\_fx::loopfx("effect_1", (brokenfx.origin), 60);
     maps\mp\_fx::loopfx("effect_2", (selefx1.origin), 1);
     maps\mp\_fx::loopfx("effect_2", (selefx2.origin), 1);
     maps\mp\_fx::loopfx("effect_2", (selefx3.origin), 1);
     maps\mp\_fx::loopfx("effect_2", (fx4.origin), 1);
	 maps\mp\_fx::loopfx("effect_3", (goldfirefly1.origin), 3);
	 maps\mp\_fx::loopfx("effect_3", (goldfirefly2.origin), 3);
	 maps\mp\_fx::loopfx("effect_4", (goldsnow.origin), 3);
	 maps\mp\_fx::loopfx("effect_5", (fx1.origin), 1);
     maps\mp\_fx::loopfx("effect_5", (fx2.origin), 1);
     maps\mp\_fx::loopfx("effect_5", (fx3.origin), 1);
     maps\mp\_fx::loopfx("effect_6", (fx5.origin), 1);

    level.music = randomint(1);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
     AmbientPlay( "granny" );
     break;
   }
}

jumpersa()//secondarea
{
   trig = getent("trigger_jumpersa", "targetname");
   tele1 = getent ("origin_jumpersa", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player FreezeControls(1);
     wait 0.1;
     player FreezeControls(0);
    }
}

returnsa()//returnfromsecondarea
{
   trig = getent("trigger_returnsa", "targetname");
   tele1 = getent ("origin_returnsa", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player FreezeControls(1);
     wait 0.1;
     player FreezeControls(0);
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

roomreturn()//if fall down return back spawn room selection
{
   trig = getent("trigger_roomreturn", "targetname");
   tele1 = getent ("origin_roomselection", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
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
    weapon = getent("trigger_weaponroom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    knife thread maps\mp\_utility::triggerOff();
    weapon thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    scope thread maps\mp\_utility::triggerOn();
    knife thread maps\mp\_utility::triggerOn();
    weapon thread maps\mp\_utility::triggerOn();
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

weaponroom()
{
   
   level.trigger_weapon = getEnt ("trigger_weaponroom", "targetname");

    jumperk = getEnt ("origin_jumperw", "targetname");
    actik = getEnt ("origin_actiw", "targetname");

   for(;;)
    {
        level.trigger_weapon setHintString ("Press [&&1] to enter Weapon Room.");
        level.trigger_weapon waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
	    player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        activator setOrigin (actik.origin);
        activator setPlayerAngles (actik.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("ak47_mp");
        activator giveWeapon("ak47_mp");
        player switchToWeapon("ak47_mp");
        activator switchToWeapon("ak47_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
                       while(isDefined(player) && isAlive(player))
            wait .05;
        
        iPrintLnBold ("" + player.name + " has died in Weapon Room");
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

trap1()
{
     plat1 = getent("trap1","targetname");
     trig = getent("trigger_trap1", "targetname");
     trig setHintString("T1: Rotate platform");
     trig waittill ("trigger");

      
}

trap2()
{
     plat1 = getent("trap2","targetname");
     trig = getent("trigger_trap2", "targetname");
     trig setHintString("T2: Rotate platform");
     trig waittill ("trigger");

      
}

trap3()
{
    platform = getent("trap3", "targetname");
    trig = getent("trigger_trap3", "targetname");
    trig setHintString("T3; Unstable some parts");
    trig waittill ("trigger");

}

trap4()
{
     plat1 = getent("trap4","targetname");
     plat2 = getent("trap4a","targetname");
     trig = getent("trigger_trap4", "targetname");
     trig setHintString("T4: Rotate 2 platforms");
     trig waittill ("trigger");

      
}

trap5()
{
     plat1 = getent("trap5","targetname");
     plat2 = getent("trap5a","targetname");
     trig = getent("trigger_trap5", "targetname");
     trig setHintString("T5: Rotate 2 rolls");
     trig waittill ("trigger");

      
}

trap6()
{
     plat1 = getent("trap6","targetname");
     plat2 = getent("trap6a","targetname");
     plat3 = getent("trap6b","targetname");
     plat4 = getent("trap6c","targetname");
     plat5 = getent("trap6d","targetname");
     plat6 = getent("trap6e","targetname");
     trig = getent("trigger_trap6", "targetname");
     trig setHintString("T6: Rotate 6 cylinders");
     trig waittill ("trigger");

      
}

trap7()
{
     plat1 = getent("trap7","targetname");
     plat2 = getent("trap7a","targetname");
     plat3 = getent("trap7b","targetname");
     trig = getent("trigger_trap7", "targetname");
     trig setHintString("T7: Rotate 3 platforms below");
     trig waittill ("trigger");

      
}