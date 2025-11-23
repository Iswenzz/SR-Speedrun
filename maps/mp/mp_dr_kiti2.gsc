main()
{
    //setDvar("scr_fog_disable", 1);
	maps\mp\_load::main();
	//maps\mp\mp_dr_kiti2_fx::main();
//	thread maps\saveload::main();
	//setDvar("scr_fog_disable", 1);
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//setdvar("bg_bobmax" , "0");
	//setdvar("jump_slowdownenable" , "0");
	//setdvar("g_speed" , "210");
	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");
	//setdvar("r_specular" , "0");
	//setdvar("r_drawDecals" , "1");
	//setdvar("SetMoveSpeedScale" , "1.12");
	//setdvar("ui_hud_hardcore" , "1");
//	setup_swim_platforms();

//	level.watersplash_large = LoadFX( "misc/watersplash_large" );
//	level.water_splash_dump = LoadFX( "impacts/water_splash_bodydump" );

    thread sr\api\_map::createSpawn((16, -176, -772), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	
//	thread force_decals();
	/*thread sniper();
	thread ak();
	thread pistol();
	thread antiglitcher();
	thread vlctaccess();
//	thread eryk();
	thread select();
	thread endmap();
	thread credits();
	thread credits2();
	thread music();
//	thread endroom_tp();
//	thread velocity();
	thread velo_exp3();
	thread velo_exp3_();
	thread velo_exp4();
	thread velo_exp4_();
	thread velo_exp5();
	thread velo_exp5_();
	thread kiti_brush();
	thread kiti_brush2();
	thread kiti_brush3();
	thread setupKits();
	thread velocity_logo_mid();
	thread vip_logo();
	thread honest_reaction();
	thread flower();
	thread lazy();
	thread old_kiti();
	thread shy();
	thread lazy_dex();
	thread hahayes();
	thread big_kiti_rotate1();
	thread big_kiti_rotate2();
	
	precacheitem("codo_spbc_mp");
	precacheitem("iw4_deagle_mp");*/

}


force_decals()
{
    level waittill("round_started");
    while(1)
    {
        players = getEntArray( "player", "classname" );
        for(i = 0; i < players.size; i++){
            players[i] setClientDvar("r_drawDecals", 1);
			players[i] setClientDvar("r_specular", 0);
        }
        wait 0.1;
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
	
	return undefined;
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
    hud.glowcolor = (0.4, 0.6, 1);

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
    level.hud_fight setText("^5" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^5" + jumper + " ^0VS^0 " + "^5" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}
	
accessHUD(player, message)
{
    player notify("access_hud");
    player endon("access_hud");

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(player.hud_access))
        player.hud_access destroy();

    player.hud_access = player createHUD(0, 85, "center", "top", 1, "objective", 1.5);
    player.hud_access setText(message);
    player.hud_access setPulseFX(40, waitTime * 1000 - offset, offset);

    wait waitTime;

    if (isDefined(player.hud_access))
        player.hud_access destroy();
}

	
select() 
{
level.room_trig = getEnt( "trigger_select", "targetname");
room = getEnt( "origin_select", "targetname" );
level.room_trig setHintString ("Press ^5[&&1]^7 to enter room selection");

for(;;)
{
level.room_trig waittill( "trigger", player );
if( !isDefined( level.room_trig ) )
return;

acti = GetActivator();
if(level.firstenter == true)
{
	acti freezeControls(1);
	acti iPrintLnBold("^5Jumper ^7is picking a ^5room^7!");
	level notify("acti_antiglitch");
	level.firstenter = false;
}
//player SetPlayerAngles( room.angles );
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
    firstPlace.hidewheninmenu = false;
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
    level.trigger_pistol = getent("trigger_pistol","targetname");
	
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_weapon thread maps\mp\_utility::triggerOff();
    level.trigger_pistol thread maps\mp\_utility::triggerOff();
	
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_weapon thread maps\mp\_utility::triggerOn();
    level.trigger_pistol thread maps\mp\_utility::triggerOn();
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

	iPrintln("^5"+self.name+" ^7died^5!"); 
	wait 0.2; 
	iPrintlnBold("^5Room selection opened^7!");
}


sniper()
{
    level.trigger_scope = getEnt ("trigger_sniper", "targetname");
    jumpersc = getEnt ("origin_jumper_sniper", "targetname");
    actisc = getEnt ("origin_acti_sniper", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player);
        
        iPrintLnBold("^5 " + player.name + " ^7entered the ^5Scope ^7Room^5!");
        activator = GetActivator();
        player thread waitdead();

        thread fightHUD("Scope Room", player, activator);
        player thread RoomCountDown("^5ill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
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
		activator.maxhealth = 100;
		activator.health = activator.maxhealth; 
        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}



ak()
{
    level.trigger_weapon = getEnt ("trigger_weapon", "targetname");

    jumperak = getEnt ("origin_jumper_weapon", "targetname");
    actiak = getEnt ("origin_acti_weapon", "targetname");

    for(;;)
    {
        level.trigger_weapon waittill ("trigger", player);
        
        iPrintLnBold("^5 " + player.name + " ^7entered the ^5Weapon ^7Room^1!");
		activator = GetActivator();
        player thread waitdead();
		
        thread fightHUD("Weapon Room", player, activator);
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        player setOrigin (jumperak.origin);
        player setPlayerAngles (jumperak.angles);    
        activator setOrigin (actiak.origin);
        activator setPlayerAngles (actiak.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("codo_spbc_mp");
        activator giveWeapon("codo_spbc_mp");
        player giveMaxAmmo("codo_spbc_mp");
        activator giveMaxAmmo("codo_spbc_mp");
//        player giveWeapon("ak74u_mp");
//        activator giveWeapon("ak74u_mp");
//        player giveMaxAmmo("ak74u_mp");
//        activator giveMaxAmmo("ak74u_mp");
        player switchToWeapon("codo_spbc_mp");
        activator switchToWeapon("codo_spbc_mp");   
		player giveWeapon("deserteagle_mp");
        activator giveWeapon("deserteagle_mp");
        player giveMaxAmmo("deserteagle_mp");
        activator giveMaxAmmo("deserteagle_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
		activator.maxhealth = 100;
		activator.health = activator.maxhealth; 
        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

pistol()
{
    level.trigger_weapon = getEnt ("trigger_pistol", "targetname");

    jumperak = getEnt ("origin_jumper_pistol", "targetname");
    actiak = getEnt ("origin_acti_pistol", "targetname");

    for(;;)
    {
        level.trigger_weapon waittill ("trigger", player);
        
        iPrintLnBold("^5 " + player.name + " ^7entered the ^5Desert Eagle ^7Room^1!");
		activator = GetActivator();
        player thread waitdead();
		
        thread fightHUD("Desert Eagle Room", player, activator);
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        player setOrigin (jumperak.origin);
        player setPlayerAngles (jumperak.angles);    
        activator setOrigin (actiak.origin);
        activator setPlayerAngles (actiak.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
		player giveWeapon("h1_karambit_mp");
		activator giveWeapon("h1_karambit_mp");
		player giveWeapon("iw4_deagle_mp");
        activator giveWeapon("iw4_deagle_mp");
        player giveMaxAmmo("iw4_deagle_mp");
        activator giveMaxAmmo("iw4_deagle_mp");
		player switchToWeapon("iw4_deagle_mp");
        activator switchToWeapon("iw4_deagle_mp");   
        player.maxhealth = 100;
        player.health = player.maxhealth;
		activator.maxhealth = 100;
		activator.health = activator.maxhealth; 
        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}


eryk()
{
    trigger = getEnt("trigger_mapper", "targetname");
    trigger setHintString("Mapper access");

    for (;;)
    {
        trigger waittill("trigger", player);
        if (isMapper(player))
        {
            wait 1;
            player giveWeapon("ak47_mp");
            player switchToWeapon("ak47_mp");
            player giveMaxAmmo("ak47_mp");
            player giveWeapon("deserteagle_mp");
            player giveMaxAmmo("deserteagle_mp");
//          iPrintLnBold("^5Lentava^7 is on the server.");
			player thread accessHUD(player, "^5L^7entava is here...");
            player setClientDvar("bg_bobmax", "0");
            player hide();
            wait 5;
            player show();
            wait 1;
        }
        else
        {
			player iPrintLnBold("^5You're not the mapper^7");
            wait 1;
        }
    }
}


vlctaccess()
{
    trigger = getEnt ("trigger_vip", "targetname");
    trigger setHintString ("^5VIP & Velocity Team Access^7");
for (;;)
    {
        trigger waittill("trigger", player);
        if (isVlct(player))
        {
	player takeAllWeapons();
	wait 0.5;
   	player giveWeapon("iw4_deagle_mp");
  	player SwitchToWeapon("iw4_deagle_mp");
	player GiveMaxAmmo("iw4_deagle_mp");
	iPrintLnBold("Welcome ^5" + player.name + "^7 on server.");
	iPrintLN("^5" + player.name + "^7 took his stuff.");
	wait 1;

    }
        else
        {
		player iPrintLnBold("^5You're not a VIP, ask @lentava for access^7");
		wait 1;
        }
    }
}

addVlctPlayer(guid, name)
{
    guidIndex = level.map_vlct["guid"].size;
    level.map_vlct["guid"][guidIndex] = guid;
    level.map_vlct["name"][guidIndex] = name;
}

isVlct(player)
{
    playerGuid = player getGuid();

    for (i = 0; i < level.map_vlct["guid"].size; i++)
    {
        if (level.map_vlct["guid"][i] == playerGuid)
        {
            return true;
        }
    }

    iPrintLn("No match found.");
    return false;
}
isMapper(player)
{
    playerGuid = player getGuid();

    for (i = 0; i < level.map_vlct["guid"].size; i++)
    {
        if (level.map_vlct["guid"][i] == playerGuid)
        {
			if(playerGuid == "2310346616691877291")
			{
            return true;
			}
        }
    }

    iPrintLn("No match found.");
    return false;
}
	
credits()
{

  while(1) 
	{
        wait 10;
        iPrintln("^5M^7ap created by ^5E^7ryk, known as ^5l^7entava");
		wait 1;
		iPrintln("Join ^5Velocity Discord^7 server: ^5https://dsc.gg/vlct^7");
		iPrintln("You^5Tube^7 channel: www.youtube.com/@cod4eryk");
        wait 5;
		wait 5;
		iPrintln("^3T^7hanks to ^3ManyAsset^7:");
		wait 0.5;
		iPrintln("^3C^7lippy for scripting and mapping help");
		wait 0.5;
		iPrintln("^3S^7loth for custom models");	
		wait 0.5;
		iPrintln("^5M^7ap made for ^5Velocity Deathrun^7: 162.19.241.204:28960");
		wait 100;
        }
	

}

credits2()
{
	trig = getent("trigger_credits" , "targetname");
//	trig setHintString("Press ^5[&&1]^7 to show credits");
	trig waittill("trigger" , player);
	iPrintLnBold("Map made by vlct' eryk/lentava");
	wait 1;
	iPrintLnBold("^7Join ^5Velocity Discord^7 server: ^5https://dsc.gg/vlct^7");
	trig delete();
}

music()
{
    level.music = randomint(4);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "pearls" );
	 iPrintLN("Song name: Pearls");
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "billie" );
	 iPrintLN("Song name: Birds of the feather ");
     break;
	 case 2:
	        AmbientStop(2);
     AmbientPlay( "story" );
	 iPrintLN("Song name: Story ");
     break;
	 case 3:
	        AmbientStop(2);
     AmbientPlay( "styropian" );
	 iPrintLN("Song name: Styropian ");
     break;
	}
}


endroom_tp()
{

	trig = getEnt("trigger_end", "targetname");
	tele = getEnt("origin_end", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		wait 1;
		player freezeControls(0);
		wait 1;
	}
}

//------------------------------------------
velo_exp3()
{
	logo3 = getEnt("velo_exp3" , "targetname");	
	for(;;)
	{
	logo3 rotateyaw (360, 1, 0, 0);
	wait 1;
	}	
}
velo_exp3_()
{
	logo3 = getEnt("velo_exp3" , "targetname");	
    trig3 = getEnt("trigger_velo_exp3", "targetname");
    trig3 waittill("trigger", player);
    player braxi\_rank::giveRankXP("", 1000);
	player playlocalsound("orb");
	trig3 delete();
	logo3 hide();
}
//-------------------------------------------
velo_exp4()
{
	logo4 = getEnt("velo_exp4" , "targetname");	
	for(;;)
	{
	logo4 rotateyaw (360, 1, 0, 0);
	wait 1;
	}	
}
velo_exp4_()
{
	logo4 = getEnt("velo_exp4" , "targetname");	
    trig4 = getEnt("trigger_velo_exp4", "targetname");
    trig4 waittill("trigger", player);
    player braxi\_rank::giveRankXP("", 1000);
	player playlocalsound("orb");
	trig4 delete();
	logo4 hide();
}
//------------------------------------------

velo_exp5()
{
	logo5 = getEnt("velo_exp5" , "targetname");	
	for(;;)
	{
	logo5 rotateyaw (360, 1, 0, 0);
	wait 1;
	}	
}
velo_exp5_()
{
	logo5 = getEnt("velo_exp5" , "targetname");	
    trig5 = getEnt("trigger_velo_exp5", "targetname");
    trig5 waittill("trigger", player);
    player braxi\_rank::giveRankXP("", 1000);
	player playlocalsound("orb");
	trig5 delete();
	logo5 hide();
}
//-------------------------------------------
	
kiti_brush()
{
	kiti = getEnt("kiti_brush" , "targetname");	
	for(;;)
	{
	kiti rotateyaw (360, 5, 0, 0);
	wait 5;
	kiti rotateroll (180, 3, 0, 0);
	wait 3;
	}	
}

//y320

kiti_brush2()
{
	dex_sh = getEnt("dex_shocked" , "targetname");	
	dex_im = getEnt("dex_ironmaiden" , "targetname");	
	for(;;)
	{
	wait 0.05;
	dex_sh movey (320, 3, 1, 1);
	dex_im movey (-320, 3, 1, 1);
	wait 5.1;
	dex_sh movey (-320, 3, 1, 1);
	dex_im movey (320, 3, 1, 1);
	wait 5.1;
	}	
}

kiti_brush3()
{
	mp_dr_kiti2 = getEnt("mp_dr_kiti2" , "targetname");		
	for(;;)
	{
	wait 0.05;
	mp_dr_kiti2 movex (320, 8, 1, 1);
	wait 8.1;
	mp_dr_kiti2 movex (-320, 8, 1, 1);
	wait 8.1;
	}	
}

velocity_logo_mid()
{
	velo = getEnt("logo_velocity" , "targetname");	
	for(;;)
	{
	velo rotateyaw (360, 10, 0, 0);
	wait 10;
	}
}



setupKits()
{
    level.kiti1 = getEnt("trigger_dex_shy", "targetname");
    level.kiti2 = getEnt("trigger_dex_lazy", "targetname");
    level.kiti3 = getEnt("trigger_dex_haha", "targetname");

    level.kit_triggers = [];
    level.kit_triggers[level.kit_triggers.size] = level.kiti1;
    level.kit_triggers[level.kit_triggers.size] = level.kiti2;
    level.kit_triggers[level.kit_triggers.size] = level.kiti3;

    for(i = 0; i < level.kit_triggers.size; i++)
        level.kit_triggers[i] thread watchKitTrigger();
}

watchKitTrigger()
{
    self waittill("damage", player);

    if(!isPlayer(player))
        return;

    // usuń wszystkie triggery
    for(i = 0; i < level.kit_triggers.size; i++)
        if(isDefined(level.kit_triggers[i]))
            level.kit_triggers[i] delete();

    // wyświetl tekst
    iprintlnbold(player.name + " wybrał " + self.targetname);

}

vip_logo()
{
		vip_logo = getEnt("brush_vip" , "targetname");

		while(1)

		{
		vip_logo moveZ(-25, 4, 0, 0);
		vip_logo rotateyaw(360, 80, 0, 0);
		wait 4;
		vip_logo moveZ(25, 4, 0, 0);	
		wait 4;
		}
}

honest_reaction()
{
	trig = getEnt("trigger_reaction" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("My honest reaction:");
	}
}

flower()
{
	trig = getEnt("trigger_flower" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("Flower Dexter ^1<3^7");
	}
}

lazy()
{
	trig = getEnt("trigger_lazy" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("KITI IS STRETCHING!!!");
	}
}

old_kiti()
{
	trig = getEnt("trigger_kiti1" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("WTF DEXTER IS PLAYING OLD MP_DR_KITI");
	}
}

shy()
{
	trig = getEnt("trigger_dex_shy" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("That's shy Dexter.");
	}
}

lazy_dex()
{
	trig = getEnt("trigger_dex_lazy" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("That's lazy Dexter.");
	}
}

hahayes()
{
	trig = getEnt("trigger_dex_haha" , "targetname");	
	for(;;){
	    trig waittill("trigger", player);
		player iPrintLnBold ("haha yes, kiti fr no cap");
	}
}

big_kiti_rotate1()
{
		kiti_rotate = getEnt("pixel_kiti_rotate" , "targetname");

		while(1)

		{
		kiti_rotate moveZ(-25, 4, 0, 0);
		kiti_rotate rotateyaw(360, 10, 0, 0);
		wait 4;
		kiti_rotate moveZ(25, 4, 0, 0);	
		wait 4;
		}
}

big_kiti_rotate2()
{
		kiti_rotate = getEnt("big_kiti_rotate" , "targetname");

		while(1)

		{
		kiti_rotate rotateyaw(360, 10, 0, 0);
		wait 10;
		}
}

