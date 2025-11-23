#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK/LENTAVA
///DISCORD: lentavakalakukko

main() {

	//setDvar("scr_fog_disable", 1);
	maps\mp\_load::main();
	//maps\mp\mp_vlct_grotfjord_fx::main();
	//setDvar("scr_fog_disable", 1);
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//precacheitem("h1_karambit_mp");
	//precacheitem("iw8_butterflyknife_mp");
	//precacheitem("iw6_honeybadger_mp");

	//precachemodel("mp_body_codo_cyberfemale");
	//precachemodel("vh_codo_cyberfemale");
    
	//setdvar("jump_slowdownenable" , "0");
	//setdvar("g_speed" , 210);
	SetDvar("bg_falldamagemaxheight", 99999);
	SetDvar("bg_falldamageminheight", 99998);
	//SetDvar("bg_bobmax", 0);
    
	//setup_swim_platforms();

	//level.watersplash_large = LoadFX( "misc/watersplash_large" );
	//level.water_splash_dump = LoadFX( "impacts/water_splash_bodydump" );

    thread sr\api\_map::createSpawn((-4653, -9136, 321), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Acti Secret");

    thread sr_acti_sec_enter();

	//thread sniper();
	//thread ak();
	//thread knife();
	//thread antiglitcher();
	//thread vlctaccess();
	//thread eryk();
	//thread select();
	//thread endmap();
	//thread credits();
	//thread credits2();
	//thread music();
	//trigger_overlay_room_setup();
	//thread trigger_water_setup();
	//thread velo_exp1();
	//thread velo_exp1_();
	//thread velo_exp2();
	//thread velo_exp2_();
	//thread velo_exp3();
	//thread velo_exp3_();
	//thread velo_exp4();
	//thread velo_exp4_();
	//thread krasin();
	//thread ognevoy();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread acti_deagle();
	//thread acti_secret_tp();
	thread acti_secret_end();
	thread bounce();
	//thread cont();
	//thread anka();
	
	
	addTriggerToList("trigger_trap1");
	addTriggerToList("trigger_trap2");
	addTriggerToList("trigger_trap3");
	addTriggerToList("trigger_trap4");
	
}

sr_acti_sec_enter()
{
	trig = spawn("trigger_radius",(-4796.09, -9135.57, 260.625), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_acti_start","targetname");

	thread sr\api\_map::createTriggerFx(trig, "cyan");

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
	
accessHUD( message)
{
    self endon("disconnect");
    self notify("access_hud");
    self endon("access_hud");

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(self.hud_access))
        self.hud_access destroy();

    self.hud_access = self createHUD(0, 85, "center", "top", 1, "objective", 1.5);
    self.hud_access setText(message);
    self.hud_access setPulseFX(40, waitTime * 1000 - offset, offset);

    wait waitTime;

    if (isDefined(self.hud_access))
        self.hud_access destroy();
}

	
select() 
{
    level.room_trig = getEnt( "trigger_select", "targetname");
    room = getEnt( "origin_select", "targetname" );
    level.room_trig setHintString ("Press ^5[&&1]^7 to enter room selection");

    for(;;)
    {
        level.room_trig waittill( "trigger", player );
        if(!isdefined(getactivator())){ player iprintln("^1No Activator Detected"); continue; }

        if( !isDefined( level.room_trig ) )
        return;

        acti = GetActivator();
        if(!isdefined(level.firstenter))
        {
            acti freezeControls(1);
            acti iPrintLnBold("^5Jumper ^7is picking a ^5room^7!");
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
    level.trigger_knife = getent("trigger_knife","targetname");
	
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_weapon thread maps\mp\_utility::triggerOff();
    level.trigger_knife thread maps\mp\_utility::triggerOff();
	
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_weapon thread maps\mp\_utility::triggerOn();
    level.trigger_knife thread maps\mp\_utility::triggerOn();
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

water_overlay_room(wait_time, fadeout_time) {
    self endon("death");
    self endon("disconnect");
    self notify("water_overlay_room");
    self endon("water_overlay_room");

    if(!isdefined(self.water_overlay_room))
        self.water_overlay_room = newClientHudElem(self);

    self.water_overlay_room.x = 0;
    self.water_overlay_room.y = 0;
    self.water_overlay_room setshader ("black", 640, 480);
    self.water_overlay_room.alignX = "left";
    self.water_overlay_room.alignY = "top";
    self.water_overlay_room.horzAlign = "fullscreen";
    self.water_overlay_room.vertAlign = "fullscreen";
    self.water_overlay_room.color = (0, 0, 0);
    self.water_overlay_room.alpha = 1;
    self thread delete_when_die(self.water_overlay_room);

    if(isdefined(wait_time))
        wait wait_time;
    
    self.water_overlay_room fadeovertime(fadeout_time);
    self.water_overlay_room.alpha = 0;


    wait(fadeout_time + 0.05);

    if(isdefined(self.water_overlay_room))
        self.water_overlay_room destroy();
}

delete_when_die(hud) {
    self endon("disconnect");
    self waittill("death");

    if(isdefined(hud))
        hud destroy();
}

sniper()
{
    level.trigger_scope = getEnt ("trigger_sniper", "targetname");
    jumpersc = getEnt ("origin_jumper_sniper", "targetname");
    actisc = getEnt ("origin_acti_sniper", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player);
        if(!isdefined(getactivator())){ player iprintln("^1No Activator Detected"); continue; }
        
        iPrintLnBold("^5 " + player.name + " ^7entered the ^5Scope ^7Room^5!");
        activator = GetActivator();
        player thread waitdead();

        player thread water_overlay_room(3, .5);
        activator thread water_overlay_room(3, .5);

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
        if(!isdefined(getactivator())){ player iprintln("^1No Activator Detected"); continue; }
        
        iPrintLnBold("^5 " + player.name + " ^7entered the ^5Weapon ^7Room^1!");
		activator = GetActivator();
        player thread waitdead();
		
        player thread water_overlay_room(3, .5);
        activator thread water_overlay_room(3, .5);
		
        thread fightHUD("Weapon Room", player, activator);
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        player setOrigin (jumperak.origin);
        player setPlayerAngles (jumperak.angles);    
        activator setOrigin (actiak.origin);
        activator setPlayerAngles (actiak.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("iw6_honeybadger_mp");
        activator giveWeapon("iw6_honeybadger_mp");
        player giveMaxAmmo("iw6_honeybadger_mp");
        activator giveMaxAmmo("iw6_honeybadger_mp");
//        player giveWeapon("ak74u_mp");
//        activator giveWeapon("ak74u_mp");
//        player giveMaxAmmo("ak74u_mp");
//        activator giveMaxAmmo("ak74u_mp");
        player switchToWeapon("iw6_honeybadger_mp");
        activator switchToWeapon("iw6_honeybadger_mp");   
		player giveWeapon("t4_ppsh_mp");
        activator giveWeapon("t4_ppsh_mp");
        player giveMaxAmmo("t4_ppsh_mp");
        activator giveMaxAmmo("t4_ppsh_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
		activator.maxhealth = 100;
		activator.health = activator.maxhealth; 
        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

knife()
{
    level.trigger_weapon = getEnt ("trigger_knife", "targetname");

    jumperak = getEnt ("origin_jumper_knife", "targetname");
    actiak = getEnt ("origin_acti_knife", "targetname");

    for(;;)
    {
        level.trigger_weapon waittill ("trigger", player);
        if(!isdefined(getactivator())){ player iprintln("^1No Activator Detected"); continue; }
        
        iPrintLnBold("^5 " + player.name + " ^7entered the ^5Knife ^7Room^1!");
		activator = GetActivator();
        player thread waitdead();
		
        player thread water_overlay_room(3, .5);
        activator thread water_overlay_room(3, .5);
		
        thread fightHUD("Weapon Room", player, activator);
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
		player switchToWeapon("h1_karambit_mp");
        activator switchToWeapon("h1_karambit_mp");   
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
            player giveWeapon("t4_ppsh_mp");
            player giveMaxAmmo("t4_ppsh_mp");
//          iPrintLnBold("^5Lentava^7 is on the server.");
			player thread accessHUD( "^5L^7entava is here...");
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
    trigger = getEnt ("trigger_vlct", "targetname");
    trigger setHintString ("^5VIP & Velocity Team Access^7");
for (;;)
    {
        trigger waittill("trigger", player);
        if (isVlct(player))
        {
	player takeAllWeapons();
	wait 1;
	player detachAll();
	player setModel("mp_body_codo_cyberfemale");
	player setViewModel("vh_codo_cyberfemale");
   	player giveWeapon("t4_ppsh_mp");
  	player SwitchToWeapon("t4_ppsh_mp");
	player GiveMaxAmmo("t4_ppsh_mp");
	wait 1;
	player giveWeapon("h1_karambit_mp");
	player switchToWeapon("h1_karambit_mp");
	player thread accessHUD("Welcome ^5" + player.name + "^7 on server.");
	iPrintLN("^5" + player.name + "^7 took his stuff.");
	player hide();
	wait 5;
	player iPrintLnBold("Karambit made by SadSlothXL");
	player show();
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

trap1()
	{
		bounce = getent("brush_trap1" , "targetname");
		trig = getent("trigger_trap1" , "targetname");
		trig SetHintString("^1Press ^5[&&1]^1 to rotate the first bounce^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce rotateroll (360, 2, 0, 0);
		wait 3;
		bounce rotateroll (360, 3, 0, 0);
		wait 6;
		}	
	}
	
trap2()
	{
		bounce = getent("brush_trap2" , "targetname");
		trig = getent("trigger_trap2" , "targetname");
		trig SetHintString("^1Press ^5[&&1]^1 to rotate the second bounce^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce rotateroll (360, 3, 0, 0);
		wait 4;
		bounce rotateroll (360, 2, 0, 0);
		wait 3;
		}	
	}
	

trap3()
	{
		bounce = getent("brush_trap3" , "targetname");
		trig = getent("trigger_trap3" , "targetname");
		trig SetHintString("^1Press ^5[&&1]^1 to rotate the third bounce");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce rotateroll (360, 2, 0, 0);
		wait 8;
		bounce rotateroll (360, 3, 0, 0);
		wait 10;
		}	
	}
	
	
trap4()
	{
		spinner_lower = getent("trap4_spinner_lower" , "targetname");
		spinner_upper = getent("trap4_spinner_upper" , "targetname");

		t1 = getent("trigger_spinner_dmg_lower" , "targetname");
		t2 = getent("trigger_spinner_dmg_upper" , "targetname");

		trig = getent("trigger_trap4" , "targetname");
		trig SetHintString("^1Rotate the spinner^7");
		trig waittill("trigger" , player);

		t1 enablelinkto();
		t2 enablelinkto();
		
		t1 linkto(spinner_lower);
		t2 linkto(spinner_upper);
				
		trig delete();
		spinner_lower moveZ (-74, 1, 0, 0);
		for(;;)
		{
		wait 2;
		spinner_lower rotateyaw (-90, 1, 0, 0);
		spinner_upper rotateyaw (-270, 3, 0, 0);
		
		wait 4;
		spinner_lower rotateyaw (90, 1, 0, 0);
		spinner_upper rotateyaw (270, 3, 0, 0);
		wait 12;
		}
	}

krasin()
{
krasin = getEnt("krasin" , "targetname");

for(;;)
{
krasin moveX (25000, 60, 0, 0);
wait 62;
krasin rotateyaw(180, 1, 0, 0);
wait 3;
krasin moveX (-25000, 60, 0, 0);
wait 62;
krasin rotateyaw (180, 20, 0, 0);
wait 3;
}
}

ognevoy()
{
ognevoy = getEnt("ognevoy" , "targetname");

for(;;)
{
ognevoy moveZ (-200, 4, 0.25, 0.25);
wait 6;
ognevoy moveZ (200, 4, 0.25, 0.25);
wait 7;
}
}	


	
credits()
{

  while(1) 
	{
        wait 10;
        iPrintln("^5M^7ap created by ^5E^7ryk, known as ^5l^7entava");
		wait 1;
		iPrintln("Join ^5Velocity Discord^7 server: ^5https://discord.gg/vlctdr^7");
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
	trig setHintString("Press ^5[&&1]^7 to show credits");
	trig waittill("trigger" , player);
	iPrintLnBold("Map made by vlct' eryk/lentava");
	wait 1;
	iPrintLnBold("^7Join ^5Velocity Discord^7 server: ^5https://discord.gg/vlctdr^7");
	player giveWeapon("h1_karambit_mp");
	player switchToWeapon("h1_karambit_mp");
	trig delete();
}

music()
{
    level.music = randomint(6);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "skeletons" );
	 iPrintLN("Song name: Travis Scott - skeletons");
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "rudimental" );
	 iPrintLN("Song name: Rudimental ft. Foxes - Right Here");
     break;
      case 2:
	        AmbientStop(2);
     AmbientPlay( "kurort" );
	 iPrintLN("Song name: Coals - kurort");
     break;
	 case 3:
	 	    AmbientStop(2);
     AmbientPlay( "dukedumont" );
	 iPrintLN("Song name: Duke Dumont - I got you");
     break;
	 case 4:
		    AmbientStop(2);
     AmbientPlay( "solong" );
	 iPrintLN("Song name: Verticals - So long");
     break;
	 case 5:
		    AmbientStop(2);
     AmbientPlay( "satelite" );
	 iPrintLN("Song name: Tasmin Archer - Sleeping Satellite");
     break;
	}
}




trigger_water_setup() {
    watertriggers = getentarray("trigger_water" , "targetname");
    for(i=0;i<watertriggers.size;i++) {
        watertriggers[i] thread trigger_water_logic();
    }
}

trigger_water_logic() {
    
    for(;;) {
        wait 0.25; // you could decrease this wait but imo not needed
        players = getentarray( "player", "classname" );
	
	    for(i = 0;i < players.size;i++) {
            if(players[i] istouching(self) && !isdefined(players[i].is_touching_water)) {
                players[i].is_touching_water = true;
                players[i] thread player_drown_water(self);

            }
        }
    }
}

player_drown_water(water)
{	
    self endon("disconnect");
    if(!isdefined(self.water_overlay)) {
        self.water_overlay = newClientHudElem(self);
        self.water_overlay.x = 0;
        self.water_overlay.y = 0;
        self.water_overlay setshader ("white", 640, 480);
        self.water_overlay.alignX = "left";
        self.water_overlay.alignY = "top";
        self.water_overlay.horzAlign = "fullscreen";
        self.water_overlay.vertAlign = "fullscreen";
        self.water_overlay.color = (.16, .38, .5);
        self.water_overlay.alpha = 0;
        self.water_overlay fadeovertime(0.25);
        self.water_overlay.alpha = .75;
    }

    while (self istouching(water) && isalive(self))
    {
        wait 0.05;
    }

    self.is_touching_water = undefined;
    if(isdefined(self.water_overlay)) {
        self.water_overlay fadeovertime(0.20);
        self.water_overlay.alpha = 0;
        wait 0.20;
        if(isdefined(self.water_overlay))
            self.water_overlay destroy();
    }
}


//--------------------------------------------
velo_exp1()
{
	logo1 = getEnt("velo_exp1" , "targetname");	
	for(;;)
	{
	logo1 rotateyaw (360, 1, 0, 0);
	wait 1;
	}	
}
velo_exp1_()
{
	logo1 = getEnt("velo_exp1" , "targetname");	
    trig1 = getEnt("trigger_velo_exp1", "targetname");
    trig1 waittill("trigger", player);
    player braxi\_rank::giveRankXP("", 500);
	player playlocalsound("orb");
	trig1 delete();
	logo1 hide();
}
//------------------------------------------
velo_exp2()
{
	logo2 = getEnt("velo_exp2" , "targetname");	
	for(;;)
	{
	logo2 rotateyaw (360, 1, 0, 0);
	wait 1;
	}	
}
velo_exp2_()
{
	logo2 = getEnt("velo_exp2" , "targetname");	
    trig2 = getEnt("trigger_velo_exp2", "targetname");
    trig2 waittill("trigger", player);
    player braxi\_rank::giveRankXP("", 500);
	player playlocalsound("orb");
	trig2 delete();
	logo2 hide();
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
    player braxi\_rank::giveRankXP("", 500);
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
    player braxi\_rank::giveRankXP("", 500);
	player playlocalsound("orb");
	trig4 delete();
	logo4 hide();
}
//------------------------------------------

trigger_overlay_room_setup()
{
   trigger = getent("trigger_overlay_room" , "targetname"); 
   trigger thread trigger_end_logic();
}

trigger_end_logic() {
    
    for(;;) {
        wait 0.25; // you could decrease this wait but imo not needed
        players = getentarray( "player", "classname" );
	
	    for(i = 0;i < players.size;i++) {
            if(players[i] istouching(self) && !isdefined(players[i].is_touching_water)) {
                players[i].is_touching_water = true;
                players[i] thread player_drown_end(self);
            }
        }
    }
}

player_drown_end(water)
{	
    self endon("disconnect");

    if(!isdefined(self.water_overlay)) {
        self.water_overlay = newClientHudElem(self);
        self.water_overlay.x = 0;
        self.water_overlay.y = 0;
        self.water_overlay setshader ("black", 640, 480);
        self.water_overlay.alignX = "left";
        self.water_overlay.alignY = "top";
        self.water_overlay.horzAlign = "fullscreen";
        self.water_overlay.vertAlign = "fullscreen";
        self.water_overlay.color = (0, 0, 0);
        self.water_overlay.alpha = 0;
        self.water_overlay fadeovertime(0.45);
        self.water_overlay.alpha = 1;
    }

    while (self istouching(water) && isalive(self))
    {
        wait 0.05;
    }

    self.is_touching_water = undefined;
    if(isdefined(self.water_overlay)) {
        self.water_overlay fadeovertime(0.20);
        self.water_overlay.alpha = 0;
        wait 0.20;
        if(isdefined(self.water_overlay))
            self.water_overlay destroy();
    }
}


acti_deagle()
{
	deagle = getent("model_deagle", "targetname");
	trig = getEnt("trigger_deagle_pickup", "targetname");
	trig waittill("trigger" , player);
	
		player giveweapon("t4_ppsh_mp");
		player giveMaxAmmo("t4_ppsh_mp");
		player switchToWeapon("t4_ppsh_mp");
		deagle moveZ (-10, 0.05, 0, 0);

}

acti_secret_tp()
{
	trig = getEnt("trigger_chicken", "targetname");
	tele = getEnt("origin_acti_start", "targetname");
		for(;;)
		{
		trig waittill("trigger" , player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		player iPrintLnBold("Use the bounce to hit the opposite corner with watermelon chunks");
		wait 1;
		player freezeControls(0);
		wait 1;
		}
	
}

bounce()
{
	secret_bounce = getent("secret_bounce" , "targetname");
	trig = getEnt("trigger_bounce", "targetname");

	secret_bounce moveZ (7680, 1, 0, 0);
	
}


acti_secret_end()
{

	trig = getEnt("acti_secret_end", "targetname");
	tele = getEnt("origin_acti_end", "targetname");

	for(;;)
    {
        trig waittill("trigger", player);

        player thread sr\api\_speedrun::finishWay("secret_0"); 
    }
}


setup_swim_platforms() {
    slide_exit_a = getent("trigger_slide_exit", "targetname");
    slide_exit_a thread slide_exit();
    plat1 = getent("swim_plat1", "targetname");
    plat2 = getent("swim_plat2", "targetname");
    plat3 = getent("swim_plat3", "targetname");
    plat1 thread platform_logic(1);
    plat2 thread platform_logic(2);
    plat3 thread platform_logic(3);
}

slide_exit() {
    for(;;) {
        self waittill("trigger", player);
        if(!isdefined(player.platform_move)) {
            player.platform_move = true;
            player thread undefined_platmove_die();
        }
    }
}

undefined_platmove_die() {
    self endon("disconnect");
    self waittill("death");

    if(isdefined(self.platform_move))
        self.platform_move = undefined;
}

platform_logic(index) {
    trigger = getent(self.target , "targetname");
    plants = getentarray("plants_plat" + index , "targetname");
    for(i=0;i<plants.size;i++) {
        plants[i] linkto(self);
    }

    base_pos = self.origin;
    moveto_pos = trigger.origin;

    self.movestate = "idle";
    
    for(;;) {
        trigger waittill("trigger", player);
        if(isdefined(player.platform_move))		{
            if(player IsOnGround() || player getvelocity()[2] > 5) {
                player.platform_move = undefined;

                if(self.movestate == "idle" || self.movestate == "up")
                    self thread move_platform(player, base_pos, moveto_pos);
					
            }
        }
    }
}

move_platform(player, base_pos, move_pos) {
    self notify("willywigger");
    self endon("willywigger");
	PlayFX(level.watersplash_large, self.origin);

	self playsound("mc_water_splash");

    self.movestate = "down";
    distance = self.origin[2] - move_pos[2] ;
    speed = 80;
    time = max(0.10, (distance/speed));

    self MoveTo(move_pos, time, 0, time/3);

    wait time + 0.1;

    self.movestate = "up";
    distance = base_pos[2] - self.origin[2];
    speed = 40;
    time = max(0.10, (distance/speed));
    self MoveTo(base_pos, time, 0, time/3);
    
    wait time + 0.05;

    self.movestate = "idle";
}

cont(){
	cont1 = getEnt("container1","targetname");
	cont2 = getEnt("container2","targetname");
	cont3 = getEnt("container3","targetname");
	
	for(;;){
		wait 0.05;
		cont1 moveZ (-20, 3, 0, 0);
		cont2 moveZ (-20, 3, 0, 0);
		cont3 moveZ (-20, 3, 0, 0);
		
		wait 3.1;
		cont1 moveZ (20, 3, 0, 0);
		cont2 moveZ (20, 3, 0, 0);
		cont3 moveZ (20, 3, 0, 0);
		wait 3.05;
		}
	}
	
anka(){
	musicbox = getEnt("anka_trigger","targetname");
	musicbox setHintString("Press ^5[&&1]^7 to play LZY - Anka, ot tak");
	musicbox waittill("trigger" , player);
	iPrintLnBold(" " + player.name + " has changed the song.");
	iPrintLN("Now playing: LZY - Anka, ot tak");
	AmbientStop(2);
	AmbientPlay ( "anka" );
	musicbox delete();
	}