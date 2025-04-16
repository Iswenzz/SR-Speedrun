#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK
///(C) 2024/2025 ALL RIGHTS RESERVED TO ERYK/LENTAVA
///NEED A COD4 MAP? CONTACT ME ON DISCORD: lentavakalakukko

main()
{
	setDvar("scr_fog_disable", 1);
	maps\mp\_load::main();
	setDvar("scr_fog_disable", 1);
	
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
	thread sr\api\_map::createSpawn((-288, -152, 12), 90);
	thread sr\api\_speedrun::createTeleporter((221.192, 4605.9, 112.125), 215, 120, (-1321, 3050, 682), 183, "freeze", "blue");

	///TRAP TRIGGERS
    addTriggerToList("trigger_trap1");
    addTriggerToList("trigger_trap2");
    addTriggerToList("trigger_trap3");
	
	//thread platforma();
	//thread woda_sie_rusza();
	//thread woda1();
	//thread select();
	//thread start();
	//thread endmap();
	//thread antiglitcher();
	//thread sniper();
	//thread knife();
	//thread ak();
	//thread credits();
	//thread strzal();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	thread gate();
	//thread dcaccess();
	//thread eryk();
	//thread antiele();
	//thread elefail();
	//thread eledone();
	//thread music();


}


platforma()
	{
		platforma = getent("platform" , "targetname");
		trig = getent("trigger_platforma" , "targetname");
		trig waittill("trigger" , player);
		wait 2;

		for(;;)
		{
		wait 1;
		platforma moveY (680, 1, 0, 0);
		wait 1.1;
		platforma moveX (-1471.5, 2, 0, 0);
		wait 2.1;
		platforma moveY (-680, 1, 0, 0);
		wait 2.3;
		platforma moveY (680, 1, 0, 0);
		wait 1.1;
		platforma moveX (1471.5, 2, 0, 0);
		wait 2.1;
		platforma moveY (-680, 1, 0, 0);
		wait 3;
		}
	 trig delete();
	}
	
woda_sie_rusza()
	{
		woda = getent("wodabrush" , "targetname");
		{
		wait 1;
		woda moveZ (1, 1, 0, 0);
		wait 1;
		for(;;)
		{
		woda moveZ (100, 3, 0, 0);
		wait 3.1;
		woda moveZ (-100, 3, 0, 0);
		wait 3.1;
		}
		}
	}
	
	
woda1()
{
	trig = getEnt("woda_zabija", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
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


select() 
{
level.room_trig = getEnt( "trigger_select_room", "targetname");
room = getEnt( "origin_select_room", "targetname" );
level.room_trig setHintString ("Press ^3[&&1]^7 to enter room selection");

for(;;)
{
level.room_trig waittill( "trigger", player );
if( !isDefined( level.room_trig ) )
return;

acti = GetActivator();
if(level.firstenter == true)
{
	acti freezeControls(1);
	acti iPrintLnBold("^3Jumper ^7is picking a ^3room ^7so don't ^3move^7!");
	level notify("acti_antiglitch");
	level.firstenter = false;
}
player SetPlayerAngles( room.angles );
player setOrigin( room.origin );
player TakeAllWeapons();
player antiglitcher();
}
}
endmap()
{ 
    trig = getEnt("endmap_trig", "targetname");     
    trig waittill ("trigger" , player );
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
    firstPlace settext("^5" + player.name + " ^7has finished ^5FIRST^7");
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
    level.trigger_knife = getent("trigger_knife","targetname");
    level.trigger_scope = getent("trigger_sniper","targetname");
    level.trigger_ak = getent("trigger_weapon","targetname");
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_ak thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_ak thread maps\mp\_utility::triggerOn();
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
level.activator1 = GetActivator();
level.activ = GetActivator();  
self common_scripts\utility::waittill_any("death","disconnect");
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

	iPrintln("^3"+self.name+" ^7died^3!"); 
	wait 0.2; 
	iPrintlnBold("^3Room selection opened^7!");
}

sniper()
{
    level.trigger_scope = getEnt ("trigger_sniper", "targetname");
	level.trigger_scope setHintString("Press ^3[&&1]^7 to enter scope room");
    jumpersc = getEnt ("origin_jumper_sniper", "targetname");
    actisc = getEnt ("origin_acti_sniper", "targetname");

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

ak()
{
    level.trigger_ak = getEnt ("trigger_weapon", "targetname");
	level.trigger_ak setHintString("Press ^3[&&1]^7 to enter AK room");

    jumperak = getEnt ("origin_jumper_weapon", "targetname");
    actiak = getEnt ("origin_acti_weapon", "targetname");

    for(;;)
    {
        level.trigger_ak waittill ("trigger", player);
        
        iPrintLnBold("^1 " + player.name + " ^7Entered The ^1AK-47 ^7Room^1!");
		activator = GetActivator();
        player thread waitdead();
//        thread fightHUD("Sniper Room", player, activator);
        player thread RoomCountDown("^3Kill each other !", 3, 0);
        activator thread RoomCountDown("^3Kill each other !", 3, 0);
        player setOrigin (jumperak.origin);
        player setPlayerAngles (jumperak.angles);    
        activator setOrigin (actiak.origin);
        activator setPlayerAngles (actiak.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("ak47_mp");
        activator giveWeapon("ak47_mp");
        player giveMaxAmmo("ak47_mp");
        activator giveMaxAmmo("ak47_mp");
        player giveWeapon("ak74u_mp");
        activator giveWeapon("ak74u_mp");
        player giveMaxAmmo("ak74u_mp");
        activator giveMaxAmmo("ak74u_mp");
        player switchToWeapon("ak47_mp");
        activator switchToWeapon("ak47_mp");   
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

knife()
{
   level.trigger_knife = getEnt ("trigger_knife", "targetname");
   level.trigger_knife setHintString("Press ^3[&&1]^7 to enter knife room");
    jumperk = getEnt ("origin_jumper_knife", "targetname");
    actik = getEnt ("origin_acti_knife", "targetname");

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

strzal()
{
	trig = getent("strzaltrig" , "targetname");
	trig waittill ("trigger", player);
	iPrintLnBold("^1 MAP MADE FOR DC CLAN, BORROWED TO XM^7");
	trig delete();	
}


credits() 
{
    while(1) 
	{
        wait 20;
        iPrintln("Map created by Eryk/lentava");
		wait 1;
		iPrintln("Join DC Discord server: https://discord.gg/y9UPKrm");
        wait 2;
		iPrintLn("^3DC Deathhrun server: 128.140.0.203:28954^7");
		wait 20;
		iPrintln("You^1Tube^7 channel: www.youtube.com/@cod4eryk");
		wait 30;
		iPrintln("Huge thanks to @death fixing room bug for me <3");
		wait 30;
        }
}

gate()
	{
		brama = getent("gate" , "targetname");
		
		brama delete();
		}


///traps

trap1()
	{
		trap1 = getent("start_trap1" , "targetname");
		trap2 = getent("start_trap2" , "targetname");
		trig = getent("trigger_trap1" , "targetname");
		trig SetHintString("^1Spin blocks^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		trap1 rotateRoll (360, 4, 0.2, 0.2);
		trap2 rotateRoll (360, 4, 0.2, 0.2);
		wait 7;
		}
	
		trig delete();
	}

trap2()
	{
		bounce1 = getent("trap_bounce1" , "targetname");
		trig = getent("trigger_trap2" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		bounce1 rotateYaw (360, 2, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap3()
	{
		bounce2 = getent("trap_bounce2" , "targetname");
		trig = getent("trigger_trap3" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		bounce2 rotateYaw (360, 2, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
	
dcaccess()
{
    trigger = getEnt ("trigger_vip", "targetname");
    trigger setHintString ("^6VIP & DC Team Access^7");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("DC |")) || gametag == "eryk" || gametag == "lentava" || gametag == "mysens'lentava" || gametag == "Brickkk" || gametag == "DC | lentava" || gametag == "DC | death" || gametag == "death" || gametag == "DC | tiki" || gametag == "Seven" || gametag == "Zajczi" )

    {
	wait 1;

   	player giveWeapon("deserteagle_mp");
  	player SwitchToWeapon("deserteagle_mp");
	player GiveMaxAmmo("deserteagle_mp");
	iPrintLnBold("Welcome " + player.name + " on server.");
	iPrintLN(player.name + " took his stuff.");
	player hide();
	wait 5;
	player show();
	wait 1;

    }
        else
        {
		player iPrintLnBold("You're not a vip.");
		wait 1;
        }
    }
}

eryk()
{
    trigger = getEnt ("trigger_mapper", "targetname");
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

   	player giveWeapon("ak47_mp");
  	player SwitchToWeapon("ak47_mp");
	player GiveMaxAmmo("ak47_mp");
	iPrintLnBold("^6DC | lentava^7 is online.");
	player setClientDvar("bg_bobmax" , "0");
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


antiele()
{
	trigger = getEnt("trigger_antiele", "targetname");
	
	for(;;)
	{
		trigger waittill("trigger", player);
		iPrintLnBold("Please delete anti-elevator plugin to enable secret feature.");
		trigger delete();
	}
}

start()
{
	trig = getent("starttriggero" , "targetname");
	trig setHintString("^3MAP MADE BY DC | LENTAVA^7");
	trig waittill("trigger" , player);
	for(;;)
	{	
		wait 1;
	}
}

elefail()
{
	trigger = getent("ele_fail" , "targetname");
	
	for(;;)
	{
		trigger waittill("trigger" , player);
		iPrintLnBold (" " + player.name + " tried to enter elevator secret, but died due to anti-ele plugin.");
		wait 2;
	}
}

eledone()
{
	trigger = getent("ele_done" , "targetname");
	
	for(;;)
	{
		trigger waittill("trigger" , player);
		iPrintLnBold(player.name + " has finished secret elevator.");
		player braxi\_rank::giveRankXP("", 4000);
		wait 10;
	}
	
	trigger delete();
}

music()
{
    level.music = randomint(7);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "song1" );
	 iPrintLN("Songg name: Porter Robinson - The Seconds (feat. Jano)");
     break;

     case 1:
	 AmbientStop(2);
     AmbientPlay( "song2" );
	 iPrintln("Song name: Sandra - Everlasting love");
     break;
	 
	  case 2:
	 AmbientStop(2);
     AmbientPlay( "song4" );
	 iPrintln("Song name: Porter Robinson - Vandalism (feat. Amba Shepherd)");
     break;

	  case 3:
	 AmbientStop(2);
     AmbientPlay( "song5" );
	 iPrintln("Song name: Diamond Pistols ft. Anna Yvette - Twerk (Aero Chord Remix)");
     break;
	 
	   case 4:
	 AmbientStop(2);
     AmbientPlay( "song6" );
	 iPrintln("Song name: Trivium - Dying in Your Arms (added for DC | tiki)");
     break;
	 
		case 5:
	 AmbientStop(2);
     AmbientPlay( "song7" );
	 iPrintln("Song name: Coals - Batalija");
     break;
	 
	   case 6:
	 AmbientStop(2);
     AmbientPlay( "song8" );
	 iPrintln("Song name: Daniel Shake & O! Margo - Kvity");
     break;
	 




   }

}

