#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK

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
	thread sr\api\_speedrun::createSecretWays("Acti Secret;");
	thread sr\api\_map::createSpawn((-21, 158, 140), 86);
	
	thread sr_acti_sec_enter();
	//thread shortcut();
	//thread sniper();
	//thread knife();
	//thread ak();
	//thread antiglitcher();
	//thread dcaccess();
	//thread eryk();
	//thread select();
	//thread endmap();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread acti_tp1();
	//thread acti_tp2();
	//thread ele_secret_tp();
	//thread ele_secret_tp_fail();
	//thread ele_secret_tp_midair_fail();
	//thread ele_midair();
	//thread music();
	//thread vip_song();
	//thread credits();
	//thread credits2();
	//thread bonus_exp1();
	//thread bonus_exp2();
	//thread acti_secret();
	thread acti_secret_fail1();
	thread acti_secret_fail2();
	thread acti_secret_finish();
}

sr_acti_sec_enter()
{
	trig = spawn("trigger_radius",(157.165, 157.694, 80.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_acti_secret_start","targetname");

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




shortcut()
	{
		platforma = getent("shortcut_platform" , "targetname");
		trig = getent("trigger_shortcut" , "targetname");
		trig waittill("trigger" , player);
		wait 0.1;

		for(;;)
		{
		
		platforma moveZ (267.5, 1, 0, 0);
		iPrintLnBold(" " + player.name + " found the shortcut!");
		wait 999;
		}
	 trig delete();
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
    level.trigger_ak = getent("trigger_ak","targetname");
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
    level.trigger_ak = getEnt ("trigger_ak", "targetname");
	level.trigger_ak setHintString("Press ^3[&&1]^7 to enter AK room");

    jumperak = getEnt ("origin_jumper_ak", "targetname");
    actiak = getEnt ("origin_acti_ak", "targetname");

    for(;;)
    {
        level.trigger_ak waittill ("trigger", player);
        
        iPrintLnBold("^1 " + player.name + " ^7Entered The ^1AK-47 ^7Room^1!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
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
		player iPrintLnBold("You're not mapper.");
		wait 1;
        }
    }
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

trap1()
	{
		platforma1 = getent("trap1_plat1" , "targetname");
		platforma2 = getent("trap1_plat2" , "targetname");
		platforma3 = getent("trap1_plat3" , "targetname");
		trig = getent("trigger_trap1" , "targetname");
		trig SetHintString("^1Rotate platforms^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		platforma1 rotateYaw (360, 2, 0, 0);
		platforma2 rotateYaw (360, 2, 0, 0);
		platforma3 rotateYaw (360, 2, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap2()

	{
		bounce = getent("trap2_bounce" , "targetname");
		trig = getent("trigger_trap2" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		bounce rotateYaw (360, 1, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap3()

	{
		platforma1 = getent("trap3_plat1_v2" , "targetname");
		platforma2 = getent("trap3_plat2_v2" , "targetname");
		trig = getent("trigger_trap3" , "targetname");
		trig SetHintString("^1Rotate platforms^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		platforma1 rotateYaw (360, 1, 0, 0);
		platforma2 rotateYaw (360, 1, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap4()
	
	{
		platforma1 = getent("trap4_plat1" , "targetname");
		platforma2 = getent("trap4_plat2" , "targetname");

		trig = getent("trigger_trap4" , "targetname");
		trig SetHintString("^1Rotate platforms 1, 3^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		platforma1 rotateYaw (360, 1, 0, 0);
		platforma2 rotateYaw (360, 1, 0, 0);
		wait 1;
		}
		
		trig delete();
		
	}
	
trap5()

	{
		platforma1 = getent("trap5_plat1" , "targetname");
		platforma2 = getent("trap5_plat2" , "targetname");
		trig = getent("trigger_trap5" , "targetname");
		trig SetHintString("^1Rotate platforms 2, 4^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		platforma1 rotateYaw (360, 1, 0, 0);
		platforma2 rotateYaw (360, 1, 0, 0);
		wait 1;
		}
		
		trig delete();
		
	}
	
acti_tp1()

{
	trig = getEnt("trigger_acti_tp1", "targetname");
	tele = getEnt("origin_acti_tp1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
	}
}

acti_tp2()

{
	trig = getEnt("trigger_acti_tp2", "targetname");
	tele = getEnt("origin_acti_tp2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
	}
}


ele_secret_tp()

{
	trig = getEnt("trigger_elevator_secret", "targetname");
	tele = getEnt("origin_elevator_done", "targetname");
	
	for(;;)
{
	trig waittill("trigger", player);
	player setOrigin(tele.origin);
	iPrintLnBold("^1 " + player.name + " has just finished secret elevator!^7");
	player show();
	player braxi\_rank::giveRankXP("", 10000);
	wait 1;
	}
}

ele_midair()

{
	trig = getEnt("trigger_midair", "targetname");
	tele = getEnt("origin_midair", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.origin);
	}
}

ele_secret_tp_fail()

{
	trig = getEnt("trigger_ele_fail", "targetname");
	tele = getEnt("origin_ele_fail", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.origin);
	}
}

ele_secret_tp_midair_fail()

{
	trig = getEnt("trigger_midair_fail", "targetname");
	tele = getEnt("origin_midair_fail", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.origin);
	}
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
	 iPrintLN("Song name: Rysy - I Will Fly");
     break;

     case 1:
	 AmbientStop(2);
     AmbientPlay( "song2" );
	 iPrintln("Song name: Rysy - The Fib");
     break;
	 
	  case 2:
	 AmbientStop(2);
     AmbientPlay( "song3" );
	 iPrintln("KOMM TANZEN - ICH WILL NICHT");
     break;

	  case 3:
	 AmbientStop(2);
     AmbientPlay( "song5" );
	 iPrintln("Song name: Sorry Boys - Zimna Wojna");
     break;
	 
	   case 4:
	 AmbientStop(2);
     AmbientPlay( "song6" );
	 iPrintln("Song name: Tiesto - Close To You");
     break;
	 
		case 5:
	 AmbientStop(2);
     AmbientPlay( "song7" );
	 iPrintln("Song name: Cold Hart - 2017");
     break;
	 
	   case 6:
	 AmbientStop(2);
     AmbientPlay( "song8" );
	 iPrintln("Song name: The Dumplings - Mewy");
     break;
	 




   }

}

vip_song()
{
	trig = getent("trigger_vipsong" , "targetname");
	trig setHintString("Play song from mp_dr_broken2 (map made by Compy)");
	trig waittill ("trigger", player);
	iPrintln("Song Name: Porter Robinson - The seconds");
	      AmbientStop(2);
	AmbientPlay ( "song4" );
//	break;
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
        wait 25;
		iPrintln("You^1Tube^7 channel: www.youtube.com/@cod4eryk");
		wait 30;
		iPrintln("Thanks to ^3C^7ompy and ^3D^7eath for help");
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
}

inv()
{
	trig = getent("trigger_invisible" , "targetname");
	trig waittill("trigger" , player);
	player hide();
}

bonus_exp1()
{
	trig = getent("trigger_bounce_platform1" , "targetname");
	trig waittill("trigger" , player);

 
	iPrintLnBold("^1" + player.name + " found bonus XP!^7");
	player braxi\_rank::giveRankXP("", 4000);
	trig delete();
	
}

bonus_exp2()
{
	trig = getent("trigger_bounce_platform2" , "targetname");	
 	trig waittill ("trigger" , player);


 

	iPrintLnBold("^1" + player.name + " found another bonus XP!^7");
	player braxi\_rank::giveRankXP("", 4000);
	trig delete();
 
}

acti_secret()

{
	trig = getEnt("trigger_acti_secret_enter", "targetname");
	tele = getEnt("origin_acti_secret_start", "targetname");
	trig setHintString("Press [&&1] to enter training room");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
	}
}

acti_secret_fail1()

{
	trig = getEnt("trigger_acti_secret_fail1", "targetname");
	tele = getEnt("origin_acti_secret_fail1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

acti_secret_fail2()

{
	trig = getEnt("trigger_acti_secret_fail2", "targetname");
	tele = getEnt("origin_acti_secret_fail2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

acti_secret_finish()

{
	trig = getEnt("trigger_acti_secret_finish", "targetname");
	tele = getEnt("origin_acti_secret_back", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}


}