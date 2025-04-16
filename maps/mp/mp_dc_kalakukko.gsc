#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK/LENTAVA
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
	setdvar("r_specular" , "1");
	setdvar("r_drawDecals" , "1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Acti Secret;");
	thread sr\api\_map::createSpawn((-117, 915, 76), 99);
	
	thread sr_acti_sec_enter();
	//thread sniper();
	//thread ak();
	//thread antiglitcher();
	//thread dcaccess();
	//thread eryk();
	//thread select();
	//thread bonus_exp1();
	//thread bonus_exp1_tp();
	//thread endmap();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread credits();
	//thread credits2();
	//thread music();
	//thread sctp();		//actitp
	//thread acti_secret();
	thread acti_secret_fail1();
	thread acti_secret_finish();
	//thread shortcut();
	
	addTriggerToList("trigger_trap1");
	addTriggerToList("trigger_trap2");
	addTriggerToList("trigger_trap3");

	
	precacheitem("h1_karambit_mp");
//	precachemodel("mp_body_codo_cyberfemale");
//	precachemodel("vh_codo_cyberfemale");
	
}

sr_acti_sec_enter()
{
	trig = spawn("trigger_radius",(-330.462, 960.193, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("origin_acti_secret","targetname");

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
    level.trigger_scope = getent("trigger_sniper","targetname");
    level.trigger_weapon = getent("trigger_weapon","targetname");
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_weapon thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_weapon thread maps\mp\_utility::triggerOn();
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
    level.trigger_weapon = getEnt ("trigger_weapon", "targetname");
	level.trigger_weapon setHintString("Press ^3[&&1]^7 to enter AK room");

    jumperak = getEnt ("origin_jumper_weapon", "targetname");
    actiak = getEnt ("origin_acti_weapon", "targetname");

    for(;;)
    {
        level.trigger_weapon waittill ("trigger", player);
        
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
		player giveWeapon("deserteagle_mp");
        activator giveWeapon("deserteagle_mp");
        player giveMaxAmmo("deserteagle_mp");
        activator giveMaxAmmo("deserteagle_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

eryk()
{
    trigger = getEnt ("trigger_eryk", "targetname");
    trigger setHintString ("Mapper access");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("eryk")) || gametag == "my.sens lentava" || gametag == "lentava" || gametag == "eryk" || gametag == "mysens'banana" || gametag == "DC | lentava" )

    {
	wait 1;

   	player giveWeapon("ak47_mp");
  	player SwitchToWeapon("ak47_mp");
	player GiveMaxAmmo("ak47_mp");
	iPrintLnBold("^6Eryk^7 is here.");
	player setClientDvar("bg_bobmax" , "0");
	player hide();
	wait 5;
	player show();
	wait 1;
    }
        else
        {
		player iPrintLnBold("Access denied.");
		wait 1;
        }
    }
}

dcaccess()
{
    trigger = getEnt ("trigger_dc", "targetname");
    trigger setHintString ("^6VIP & DC Team Access^7");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("DC |")) || gametag == "eryk" || gametag == "lentava" || gametag == "Sloth" || gametag == "Brickkk" || gametag == "DC | lentava" || gametag == "DC | death" || gametag == "death" || gametag == "DC | tiki" || gametag == "Seven" || gametag == "Compy" || gametag == "Freaktard" || gametag == "Zajczi" || gametag == "Clippy" )

    {
	player takeAllWeapons();
	wait 1;
//	player detachAll();
//	player setModel("mp_body_codo_cyberfemale");
//	player setViewModel("vh_codo_cyberfemale");
   	player giveWeapon("deserteagle_mp");
  	player SwitchToWeapon("deserteagle_mp");
	player GiveMaxAmmo("deserteagle_mp");
	wait 1;
	player giveWeapon("h1_karambit_mp");
	player switchToWeapon("h1_karambit_mp");
	iPrintLnBold("Welcome " + player.name + " on server.");
	iPrintLN(player.name + " took his stuff.");
	player hide();
	wait 5;
	player iPrintLnBold("Karambit made by SadSlothXL");
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

trap1()
	{
		bounce = getent("trap1" , "targetname");
		trig = getent("trigger_trap1" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce rotateyaw (360, 2, 0, 0);
		wait 4;
		}	
	}
	
trap2()
	{
		bounce = getent("trap2" , "targetname");
		trig = getent("trigger_trap2" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce rotateyaw (360, 2, 0, 0);
		wait 4;
		}	
	}
	
trap3()
	{
		bounce = getent("trap3" , "targetname");
		trig = getent("trigger_trap3" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce rotateyaw (360, 2, 0, 0);
		wait 4;
		}	
	}	


credits()
{

  while(1) 
	{
        wait 10;
        iPrintln("^3M^7ap created by ^3E^7ryk/^3l^7entava");
		wait 1;
		iPrintln("Join DC Discord server: https://discord.gg/y9UPKrm");
        wait 10;
		iPrintln("You^1Tube^7 channel: www.youtube.com/@cod4eryk");
		wait 5;
		iPrintln("Thanks to:");
		wait 0.5;
		iPrintln("^3C^7lippy for improvements");
		wait 0.5;
		iPrintln("^3S^7loth for karambit model");
		wait 0.5;
		iPrintln("^3D^7eath for scripting help");
		wait 0.5;
		iPrintln("^3C^7ompy for ^3DC^7 logo on start");		
		wait 0.5;
		iPrintln("^3M^7ap made for ^3DC Deathrun^7: 128.140.0.203:28954");
		wait 30;
        }
	

}

credits2()
{
	trig = getent("trigger_credits" , "targetname");
	trig setHintString("Show Credits");
	trig waittill("trigger" , player);
	iPrintLnBold("Map made by DC | eryk/lentava");
	wait 1;
	iPrintLnBold("Join DC Discord server: ^5https://discord.gg/y9UPKrm^7");
	player giveWeapon("h1_karambit_mp");
	player switchToWeapon("h1_karambit_mp");
	wait 5;
	player iPrintLnBold("Karambit made by SadSlothXL");
	wait 1;
	player iPrintLnBold("If this map is on xM server, it means that raky stole this map. Play it at DC Deathrun server.");
}


bonus_exp1()
{
    trig = getEnt("trigger_secret", "targetname");
    trig waittill("trigger", player);
	tele = getEnt("origin_secret", "targetname");

    iPrintLnBold("^1" + player.name + " found bonus XP!^7");
    player braxi\_rank::giveRankXP("", 4000);
	
    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++) 
    {
        if (isDefined(players[i])) 
        {
			players[i] playLocalSound("impact"); 	
        }
    }
}

bonus_exp1_tp()
{
	trig = getEnt("trigger2_secret", "targetname");
	tele = getEnt("origin2_secret", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		wait 0.05;
		player freezeControls(0);
		player giveWeapon("h1_karambit_mp");
		player switchToWeapon("h1_karambit_mp");
		player iPrintLnBold("Karambit made by SadSlothXL");
	}
}


music()
{
    level.music = randomint(6);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "song1" );
	 iPrintLN("Song name: Coals - Dzwony");
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "song2" );
	 iPrintLN("Song name: Coals - plasma");
     break;
      case 2:
	        AmbientStop(2);
     AmbientPlay( "song3" );
	 iPrintLN("Song name: Yung Lean - Trip");
     break;
      case 3:
	        AmbientStop(2);
     AmbientPlay( "song4" );
	 iPrintLN("Song name: The Dumplings - Running up that hill (Kate Bush cover)");
     break; 	 
	 case 4:
	 	     AmbientStop(2);
     AmbientPlay( "song5" );
	 iPrintLN("Song name: Coals - ufo");
     break; 
	 case 5:
	 	     AmbientStop(2);
     AmbientPlay( "song6" );
	 iPrintLN("Song name: Taska Black - In Your Eyes");
     break; 
	}
}


sctp()
{

	trig = getEnt("trigger_acti_tp", "targetname");
	tele = getEnt("origin_acti_tp", "targetname");
	trig setHintString("Press [&&1] to enter next area");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		wait 1;
		player freezeControls(0);
		wait 3;
	}
}



acti_secret()

{
	trig = getEnt("trigger_acti_secret", "targetname");
	tele = getEnt("origin_acti_secret", "targetname");
	trig setHintString("Press [&&1] to enter training room");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player giveWeapon("h1_karambit_mp");
		player switchToWeapon("h1_karambit_mp");
		player iPrintLnBold("Karambit made by SadSlothXL");
	}
}

acti_secret_fail1()

{
	trig = getEnt("trigger_acti_secret_fail2", "targetname");
	tele = getEnt("origin_acti_secret_fail", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

acti_secret_finish()

{
	trig = getEnt("trigger_acti_secret_end", "targetname");
	tele = getEnt("origin_acti_secret_back", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}


}

shortcut()
{
    trig = getEnt("trigger_shortcut", "targetname");
    trig waittill("trigger", player);

    iPrintLnBold("^1" + player.name + " found the shortcut!^7");
    player braxi\_rank::giveRankXP("", 4000);
	
}