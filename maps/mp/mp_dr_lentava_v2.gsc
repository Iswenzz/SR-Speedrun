#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("bg_bobmax" , "0");
	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");
	setdvar("r_specular" , "0");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
	thread sr\api\_map::createSpawn((1495, 5495, -1272), 89);
    
	thread sr_hard_sec_enter();
	thread sr_easy_sec_enter();
	thread woda();
	//thread credits();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap_teleport();
	//thread music();
	//thread GetActivator();
	//thread eryk();
	//thread dcaccess();
	//thread select();
	//thread sniper();
	//thread knife();
//	thread exp();
//	thread tankdriver();
	//thread secret_step();
	//thread easy();
	thread easy1();
	thread easy2();
	thread easy3();
	//thread hard();
	thread hard1();
	thread hard2();
	thread hard3();
	thread hard4();

	addTriggerToList("trap1");
	addTriggerToList("trap2");
	addTriggerToList("trap3");
	addTriggerToList("trap4");
	addTriggerToList("trap5");
	

}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(1645.32, 5495, -1331.88), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_hard","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(1334.4, 5494.98, -1331.88), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_easy_secret","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
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

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

removeTextActivator()
{
    if( isDefined( self.hud_textacti) )
    {
        self.hud_textacti destroy();
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

fightHUD(room, jumper, activ)
{
    self notify("newFhud");
    self endon("newFhud");

    if (!isDefined(room))
        room = "undefined";
    if (!isDefined(jumper))
        jumper = "undefined";
    else
        jumper = jumper.name;
    if (!isDefined(activ))
        activ = "undefined";
    else
        activ = activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^3" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^3" + jumper + " ^0VS^0 " + "^3" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}

woda()
{
	trig = getEnt("wodazabija", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}

credits() 
{
    while(1) 
	{
        iPrintln("Thanks to people who helped me fixing bugs and scripting (Seven, Death, Vay).");
        wait 30;
        iPrintln("Map created by Eryk");
        wait 20;
        }
}

eryk()
{
    trigger = getEnt ("mapper", "targetname");
    trigger setHintString ("Mapper access");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("eryk")) || gametag == "my.sens lentava" || gametag == "lentava" || gametag == "mysens'lentava" || gametag == "mysens'banana" || gametag == "DC | lentava" )

    {
	wait 1;

   	player giveWeapon("ak74u_mp");
  	player SwitchToWeapon("ak74u_mp");
	player GiveMaxAmmo("ak74u_mp");
	iPrintLnBold("^6Eryk^7 is here.");
	player hide();
	wait 5;
	player show();
	wait 1;

    }
        else
        {
		player iPrintLnBold("You're not mapper.");
		wait 1;
        }
    }
}

dcaccess()
{
    trigger = getEnt ("dc_access", "targetname");
    trigger setHintString ("^6DC Team Access^7");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("DC |")) || gametag == "eryk" || gametag == "lentava" || gametag == "mysens'lentava" || gametag == "mysens'banana" || gametag == "DC | lentava" || gametag == "DC | Death" || gametag == "DC | tiki" )

    {
	wait 1;

   	player giveWeapon("deserteaglegold_mp");
  	player SwitchToWeapon("deserteaglegold_mp");
	player GiveMaxAmmo("deserteaglegold_mp");
	iPrintLnBold("Welcome " + player.name + " on server.");
	iPrintLN(player.name + " took his stuff.");
	player hide();
	wait 5;
	player show();
	wait 1;

    }
        else
        {
		player iPrintLnBold("You're not a member of DC.");
		wait 1;
        }
    }
}

exp()
{
    trigger = getEnt ("tankexp" , "targetname");
    trigger setHintString ("What's that?");
for(;;)
 {
    trigger waittill ("trigger" , player);
	player GiveWeapon("deserteaglegold_mp");
	player SwitchToWeapon("deserteaglegold_mp");
	player GiveMaxAmmo("deserteaglegold_mp");
//	player braxi\_rank::giveRankXP("", 1000);
	trigger delete();
 }
}

tankdriver()
{
	trigger = getEnt("tankrider" , "targetname");
	trigger setHintString("Show your presence here.");
for(;;)
 {
	trigger waittill ("trigger", player);
	iPrintLnBold (player.name + "is a ^2tank^7 driver.");
	trigger delete();
 }
}

trap1()
	{
		mantle1 = getent("trap1_mantle1" , "targetname");
		mantle2 = getent("trap1_mantle2" , "targetname");
		block1 = getent("trap1_block1" , "targetname");
		block2 = getent("trap1_block2" , "targetname");
		trig = getent("trap1" , "targetname");
		trig SetHintString("^1Remove two platforms^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		mantle1 moveZ (-1320, 4, 0, 0.2);
		mantle2 moveZ (-1320, 4, 0, 0.2);
		block1 moveZ (-1320, 4, 0, 0.2);
		block2 moveZ (-1320, 4, 0, 0.2);
		wait 5;
		mantle1 moveZ (1320, 3, 0, 1);
		mantle2 moveZ (1320, 3, 0, 1);
		block1 moveZ (1320, 3, 0, 1);
		block2 moveZ (1320, 3, 0, 1);
		wait 7;
		}
	
		trig delete();
	}

trap2()
	{
		bounce = getent("trap2_bounce" , "targetname");
		trig = getent("trap2" , "targetname");
		trig SetHintString("^1Rotate the bounce^7");
		trig waittill("trigger" , player);

		for(;;)
		{
		bounce rotateYaw (360, 2, 0, 0.2);
		wait 5;
		}
	 trig delete();
	}

trap3()
	{
		platform1 = getent("trap3_platform" , "targetname");
		trig = getent("trap3" , "targetname");
		trig SetHintString("^1Spin the platform^7");
		trig waittill("trigger" , player);

		for(;;)
		{
		platform1 rotateRoll(360, 3, 0, 0.2);
		wait 8;
		}
	 trig delete();
	}

trap4()
	{
		platform2 = getent("trap4_rotateplatform" , "targetname");
		trig = getent("trap4" , "targetname");
		trig SetHintString("^1Spin the platform^7");
		trig waittill("trigger" , player);

		for(;;)
		{
		platform2 rotateYaw(360, 2, 0, 0);
		wait 2.5;
		platform2 rotateYaw(360, 2, 0, 0);
		wait 5;
		}
	 trig delete();
	}

trap5()
	{
		ladder = getent("trap5_ladder" , "targetname");
		trig = getent("trap5" , "targetname");
		trig SetHintString("^1Remove ladder on one side^7");
		trig waittill("trigger" , player);

		for(;;)
		{
		wait 1;
		ladder notSolid();
		wait 1;
		}
	 trig delete();
	}
	
//SECRETS
secret_step()
{
	trig = getEnt("secret_shot1","targetname");
	belka = getEnt("secret_entrance", "targetname");
	trig waittill("trigger",player);	
	wait 1;
	belka notSolid();
	belka hide();
	iPrintLn("Something moved...");
	wait 1;
	trig delete();
}

	

easy()
{
	trig = getEnt("easy_secret", "targetname");
	tele = getEnt("origin_easy_secret", "targetname");
	trig setHintString(">>> Easy secret <<<");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
	}
}
easy1()
{
	trig = getEnt("trigger_easy_fall1", "targetname");
	tele = getEnt("origin_easy_secret_fall1", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}
easy2()
{
	trig = getEnt("trigger_easy_fall2", "targetname");
	tele = getEnt("origin_easy_fall2", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}
easy3()
{
	trig = getEnt("easysecretfinish", "targetname");
	tele = getEnt("origeasysecretfinish", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

hard()
{
	trig = getEnt("hard_secret", "targetname");
	tele = getEnt("origin_hard", "targetname");
	trig setHintString(">>> s e c r e t <<<");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
	}
}

hard1()
{
	trig = getEnt("trigger_hard_fall1", "targetname");
	tele = getEnt("origin_hard_fall1", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hard2()
{
	trig = getEnt("trigger_hard_fall2", "targetname");
	tele = getEnt("origin_hard_fall2", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}
hard3()
{
	trig = getEnt("trigger_hard_fall3", "targetname");
	tele = getEnt("origin_hard_fall3", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}
hard4()
{
	trig = getEnt("hardsecretfinish", "targetname");
	tele = getEnt("orighardsecretfinish", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_1");

	}
}


trap_teleport()
{
	trig = getEnt("trapteleport", "targetname");
	traptele = getEnt("origin_trapteleport", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(traptele.origin);
	}
}

select()
{
	trig = getEnt("trigger_select_room", "targetname");
	selecttp = getEnt("origin_select_room", "targetname");
	trig setHintString("Press ^3[&&1]^7 to enter room selection");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(selecttp.origin);
		player setPlayerAngles (selecttp.angles); 
	}
}

music()
{
    level.music = randomint(6);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
     AmbientPlay( "song1" );
     break;

     case 1:
     AmbientPlay( "song2" );
     break;

     case 2:
     AmbientPlay( "song3" );
     break;

     case 3:
     AmbientPlay( "song4" );
     break;

     case 4:
     AmbientPlay( "song5" );
     break;

     case 5:
     AmbientPlay( "song6" );
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

///ROOMS
waitdead()
{
    activator = GetActivator();
    level.trigger_knife = getent("knife_room","targetname");
    level.trigger_scope = getent("sniper_room","targetname");
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_scope thread maps\mp\_utility::triggerOn();
}

RoomCountDown(text, duration, extra)
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
    self.endTimerHUD = createHUD(0, 120, "center", "top", 1, "objective", 1.5);

    self freezeControls(1);
    wait extra;

    while (duration > 0)
    {
        self.endTimerHUD setText("^0" + duration);
        self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
        wait 1;
        duration--;
    }
    self.endTimerHUD setText(text);
    self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
    self freezeControls(0);
    wait 1;
    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
}

antiglitcher() 
{
level.activ = GetActivator();  
self common_scripts\utility::waittill_any("death","disconnect");
//self waittill("death");
	if(isDefined(self))
	{
		self notify("matchend");
	}
	else
	{
		level waittill("actiKill");
		self notify("matchend");
	}
self freezeControls(0);
level.activ notify("matchend");

	iPrintln("^3"+self.name+" ^0died"); 
	wait 0.2; 
	iPrintlnBold("^3Room selection opened^0!");
}

sniper()
{
    level.trigger_scope = getEnt ("sniper_room", "targetname");

    jumpersc = getEnt ("sniper_jumper", "targetname");
    actisc = getEnt ("sniper_activator", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player);
        
        iPrintLnBold("^2 " + player.name + " ^7Entered The ^2Sniper ^7Room^2!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
        player thread RoomCountDown("^3Kill each other !", 3, 0);
        activator thread RoomCountDown("^3Kill each other !", 3, 0);
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
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

knife()
{
   level.trigger_knife = getEnt ("knife_room", "targetname");

    jumperk = getEnt ("knife_jumper", "targetname");
    actik = getEnt ("knife_activator", "targetname");

   for(;;)
    {
        level.trigger_knife waittill ("trigger", player);

        iPrintLnBold("^6 " + player.name + " ^7Entered The ^6Knife ^7Room^6!^7");
        activator = getactivator();
        player thread waitdead();
        thread fightHUD("Knife Room", player, activator);
        activator thread RoomCountDown("^3Kill each other !", 3, 0);
        player thread RoomCountDown("^3Kill each other !", 3, 0);
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
        
    }
}