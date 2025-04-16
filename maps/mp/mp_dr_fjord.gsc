#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK/LENTAVA

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
	thread sr\api\_map::createSpawn((-1747, -1647, 108), 90);
	
	
	//thread sniper();
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
	//thread credits();
	//thread credits2();
	//thread bonus_exp1();
	//thread bonus_exp2();
	//thread secret();
	//thread music();
	//thread plywajace_obiekty();
	//thread boats();
	//thread container2();
	//thread container3();
	//thread vip_song();
	//thread acti_jump();
	//thread kiti();
	//thread sctp();
	
	addTriggerToList("trigger_trap1");
    addTriggerToList("trigger_trap2");
    addTriggerToList("trigger_trap3");
    addTriggerToList("trigger_trap4");
	
	precacheitem("h1_karambit_mp");
	precachemodel("mp_body_codo_cyberfemale");
	precachemodel("vh_codo_cyberfemale");
	
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
	AmbientStop(2);
	AmbientPlay ( "song5" );
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
    trigger = getEnt ("trigger_vip", "targetname");
    trigger setHintString ("^6VIP & DC Team Access^7");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("DC |")) || gametag == "eryk" || gametag == "lentava" || gametag == "Sloth" || gametag == "Brickkk" || gametag == "DC | lentava" || gametag == "DC | death" || gametag == "death" || gametag == "DC | tiki" || gametag == "Seven" || gametag == "Zajczi" || gametag == "Clippy" )

    {
	player takeAllWeapons();
	wait 1;
	player detachAll();
	player setModel("mp_body_codo_cyberfemale");
	player setClientDvar("cg_thirdperson" , "1");
	player setViewModel("vh_codo_cyberfemale");
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
	player iPrintLnBold("Karambit & Cyber Female made by SadSlothXL");
	player setClientDvar("cg_thirdperson" , "0");
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
		pillar1 = getent("trap1_pillar1" , "targetname");
		pillar2 = getent("trap1_pillar2" , "targetname");
		platform = getent("trap1_platform" , "targetname");
		trig = getent("trigger_trap1" , "targetname");
		trig SetHintString("^1Move second platform up and down^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		pillar1 moveZ (-100, 2, 0, 0);
		pillar2 moveZ (-100, 2, 0, 0);
		platform moveZ (-100, 2, 0, 0);
		wait 2;
		pillar1 moveZ (100, 2, 0, 0);
		pillar2 moveZ (100, 2, 0, 0);
		platform moveZ (100, 2, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap2()

	{
		pillar1 = getent("trap2_pillar1" , "targetname");
		pillar2 = getent("trap2_pillar2" , "targetname");

		trig = getent("trigger_trap2" , "targetname");
		trig SetHintString("^1Rotate two pillars^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		pillar1 rotateYaw (360, 1, 0, 0);
		pillar2 rotateYaw (360, 1, 0, 0);
		wait 2;
		pillar1 rotateYaw (360, 1, 0, 0);
		pillar2 rotateYaw (360, 1, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap3()

	{
		pillar1 = getent("trap3_pillar1" , "targetname");
		pillar2 = getent("trap3_pillar2" , "targetname");
		bounce = getent("trap3_bounce" , "targetname");
		trig = getent("trigger_trap3" , "targetname");
		trig SetHintString("^1Move bounce up and down^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		pillar1 moveZ (100, 2, 0, 0);
		pillar2 moveZ (100, 2, 0, 0);
		bounce moveZ (100, 2, 0, 0);
		wait 2;
		pillar1 moveZ (-100, 2, 0, 0);
		pillar2 moveZ (-100, 2, 0, 0);
		bounce moveZ (-100, 2, 0, 0);
		wait 4;
		}
		
		trig delete();
		
	}
	
trap4()
	
	{
		bounce = getent("trap4_bounce" , "targetname");


		trig = getent("trigger_trap4" , "targetname");
		trig SetHintString("^1Rotate bounce^7");
		trig waittill("trigger" , player);
		
		for(;;)
		{
		wait 1;
		bounce rotateyaw (360, 1, 0, 0);

		wait 2;
		}
		
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
        wait 18;
		iPrintln("You^1Tube^7 channel: www.youtube.com/@cod4eryk");
		wait 2;
		iPrintln("Thanks to ^3C^7lippy, ^3S^7loth and ^3D^7eath for help!");
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


bonus_exp1()
{
    trig = getEnt("trigger_bonus_exp1", "targetname");
    trig waittill("trigger", player);

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

    trig delete();
}

bonus_exp2()
{
	trig = getent("trigger_bonus_exp2" , "targetname");	
 	trig waittill ("trigger" , player);

	iPrintLnBold("^1" + player.name + " found another bonus XP!^7");
	player braxi\_rank::giveRankXP("", 4000);
	trig delete();
 
}

secret()

{
	trig = getEnt("trigger_roof", "targetname");
	tele = getEnt("origin_roof", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		wait 0.05;
		player freezeControls(0);
	}
}


music()
{
    level.music = randomint(4);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "song1" );
	 iPrintLN("Song name: HAIM - Falling");
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "song2" );
	 iPrintLN("Song name: Paramore - Brighter (for sad Mr. tiki)");
     break;
      case 2:
	        AmbientStop(2);
     AmbientPlay( "song3" );
	 iPrintLN("Song name: Sorry Boys - Mapy Gwiazd");
     break;
      case 3:
	        AmbientStop(2);
     AmbientPlay( "song4" );
	 iPrintLN("Song name: Robbie Williams - Tripping");
     break; 
	}
}

plywajace_obiekty()
	{
		container = getent("swimcontainer" , "targetname");
		container_clip = getEnt("swimcontainer_clip" , "targetname");
		pillar1 = getEnt("swimpillar1" , "targetname");
		platform = getEnt("swimplat1" , "targetname");
		
		while(1)
		
		{
		
		container moveY (1800, 60, 0.5, 0.5);
		container rotateYaw (360, 60, 0.5, 0.5);
	
		container_clip moveY (1800, 60, 0.5, 0.5);
		container_clip rotateYaw (360, 60, 0.5, 0.5);
		
		
		container moveZ (-25, 2, 0.5, 0.5);
		container_clip moveZ (-25, 2, 0.5, 0.5);
		
		pillar1 moveZ (-25, 2, 0.5, 0.5);
		pillar1 rotateYaw (10, 10, 0.5, 0.5);
		platform moveZ (-25, 2, 0.5, 0.5);
		platform rotateyaw(10, 10, 0.5, 0.5);
		
		wait 2;
		
		container moveZ (25, 2, 0.5, 0.5);
		container_clip moveZ (25, 2, 0.5, 0.5);
		
		pillar1 moveZ (25, 2, 0.5, 0.5);
		platform moveZ (25, 2, 0.5, 0.5);
		wait 2;
		}
		
	}

boats()
{
	boat1 = getent("boat1" , "targetname");
	boat2 = getent("boat2" , "targetname");
	boat3 = getent("boat3" , "targetname");
	boat4 = getent("boat4" , "targetname");
	boat5 = getent("boat5" , "targetname");
	
	while(1)
	
	{
	boat1 moveZ (-5, 1, 0.05, 0.05);
	boat2 moveZ (-5, 1, 0.05, 0.05);
	boat3 moveY (-5, 1, 0.05, 0.05);
	boat4 moveZ (-5, 1, 0.05, 0.05);
	boat5 moveZ (-5, 1, 0.05, 0.05);
	wait 1;
	boat1 moveZ (5, 1, 0.05, 0.05);
	boat2 moveZ (5, 1, 0.05, 0.05);
	boat3 moveY (5, 1, 0.05, 0.05);
	boat4 moveZ (5, 1, 0.05, 0.05);
	boat5 moveZ (5, 1, 0.05, 0.05);
	wait 1;
	}
}

container2()
{
		container2 = getEnt("container2" , "targetname");
		container2_clip = getEnt("container2_clip" , "targetname");

		while(1)

		{
		container2 moveZ(-8, 4, 0, 0);
		container2_clip moveZ(-8, 4, 0, 0);
		wait 4;
		container2 moveZ(8, 4, 0, 0);
		container2_clip moveZ(8, 4, 0, 0);		
		wait 4;
		}
}
		

container3()
{
		container3 = getEnt("container3" , "targetname");
		container3_clip = getEnt("container3_clip" , "targetname");

		while(1)

		{
		container3 moveZ(-25, 4, 0, 0);
		container3_clip moveZ(-25, 4, 0, 0);
		container3 rotateyaw(360, 80, 0, 0);
		container3_clip rotateyaw(360, 80, 0, 0);
		wait 4;
		container3 moveZ(25, 4, 0, 0);
		container3_clip moveZ(25, 4, 0, 0);		
		wait 4;
		}
}

vip_song()
{
    trigger = getEnt ("trigger_vipsong", "targetname");
    trigger setHintString ("^3VIP SONG^7");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("DC |")) || gametag == "eryk" || gametag == "lentava" || gametag == "Sloth" || gametag == "Brickkk" || gametag == "DC | lentava" || gametag == "DC | death" || gametag == "death" || gametag == "DC | tiki" || gametag == "Seven" || gametag == "Zajczi" || gametag == "Clippy" )

    {
	wait 1;
	iPrintLnBold(" " + player.name + " changed the song.");
	iPrintLN("Now playing: Katatonia - My Twin");
	AmbientStop(2);
	AmbientPlay ( "vipsong" );
	trigger delete();
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

acti_jump()
{
	trig = getent("trigger_acti_secret" , "targetname");
	trig waittill ("trigger" , player);

	iPrintLn("^1" + player.name + " has finished very difficult activators' jump room.^7");
	player iPrintLnBold("^1CONGRATULATIONS!^7");
	player braxi\_rank::giveRankXP("", 1000);
	trig delete();
}

kiti()
{
	trigger = getent("trigger_kiti" , "targetname");
	trigger waittill("trigger" , player);
	
	iPrintLnBold("^3" + player.name + "^7 has just found hidden ^6nsfw kiti^7!!!!!");
	
	players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++) 
    {
        if (isDefined(players[i])) 
        {
            players[i] playLocalSound("kiti");
			wait 1.5;
            players[i] playLocalSound("kiti"); 
        }
    }
	
	trigger delete();
}

sctp()
{

	trig = getEnt("trigger_sctp", "targetname");
	tele = getEnt("origin_sctp", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		player iPrintLnBold("Wait...");
		wait 12;
		player freezeControls(0);
		wait 3;
		player setPlayerAngles(player.angles);
	}
}
