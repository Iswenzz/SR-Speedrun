///MAP MADE BY ERYK

main()
{
	maps\mp\_load::main();

	//thread kiti();
	//thread platforma();
	//thread woda_sie_rusza();
	//thread select();
	//thread endmap();
	//thread sniper();
	//thread knife();
	//thread ak();
	//thread eryk();
	//thread music();
	//thread dcaccess();
	//thread lootmachine();
	thread woda1();
	thread woda2();
	thread woda3();
	thread woda4();
	thread woda5();
	//thread credits();
	//thread trap_teleport();
	//thread trap_teleport_back();
	//thread antiglitcher();
	
	
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
    thread sr\api\_map::createSpawn((-3, -1661, 76), 90);
    thread sr\api\_speedrun::createTeleporter((519.814, 2833.06, 28.125), 130, 120, (872, 3327,772), 90, "freeze", "blue");

	precacheShader("kiti1");
	precacheShader("kiti2");
	precacheShader("kiti3");
	precacheShader("kiti4");
	precacheShader("kiti5");
	precacheShader("kiti6");
	precacheShader("kiti7");
	precacheShader("kiti8");
}

kiti()
	{
		kiti = getent("kot" , "targetname");

		for(;;)
		{
		kiti moveX (620, 4, 0, 0.2);
		wait 4.1;
		kiti moveX (-620, 4, 0, 0.2);
		wait 4.1;
		}
	}
	
platforma()
	{
		platformabezkota = getent("platforma" , "targetname");
		platformazkotem = getent("platformakot" , "targetname");
		trig = getent("platforma_trigger" , "targetname");
		trig waittill("trigger" , player);
		wait 2;

		for(;;)
		{
		platformazkotem moveZ (650, 3, 0.2, 0.2);
		platformabezkota moveZ (650, 3, 0.2, 0.2);
		wait 5;
		platformazkotem moveZ (-650, 3, 0.2, 0.2);
		platformabezkota moveZ (-650, 3, 0.2, 0.2);
		wait 6;
		}
	 trig delete();
	}
	
woda_sie_rusza()
	{
		wodabrush = getent("wodamoving" , "targetname");
		{
		wait 1;
		wodabrush moveZ (1, 1, 0, 0);
		wait 1;
		for(;;)
		{
		wodabrush moveZ (35, 3, 0.3, 0.3);
		wait 3;
		wodabrush moveZ (-35, 3, 0.3, 0.3);
		wait 3;
		}
		}
	}
	
	
woda1()
{
	trig = getEnt("woda1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}
woda2()
{
	trig = getEnt("woda2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}
woda3()
{
	trig = getEnt("woda3", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}
woda4()
{
	trig = getEnt("woda4", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}
woda5()
{
	trig = getEnt("woda5", "targetname");
	
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
	trig_room = getEnt("trigger_select", "targetname");
	selecttp = getEnt("origin_select", "targetname");
	trig_room setHintString("Press ^3[&&1]^7 to enter room selection");
	
	for(;;)
	{
		trig_room waittill("trigger", player);
        
        if( !isDefined( trig_room ) )
        return;
//        if(!plugins\_respect::roomCheck(player))
        continue;
        
		player setOrigin(selecttp.origin);
		player setPlayerAngles (selecttp.angles); 
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
    level.trigger_knife = getent("knife_room","targetname");
    level.trigger_scope = getent("sniper_room","targetname");
    level.trigger_ak = getent("ak_room","targetname");
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
	level.trigger_scope setHintString("Press ^3[&&1]^7 to enter scope room");
    jumpersc = getEnt ("jumper_sniper", "targetname");
    actisc = getEnt ("acti_sniper", "targetname");

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
    level.trigger_scope = getEnt ("ak_room", "targetname");
	level.trigger_scope setHintString("Press ^3[&&1]^7 to enter AK room");

    jumpersc = getEnt ("jumper_sniper", "targetname");
    actisc = getEnt ("acti_sniper", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player);
        
        iPrintLnBold("^1 " + player.name + " ^7Entered The ^1AK-47 ^7Room^1!");
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
   level.trigger_knife = getEnt ("knife_room", "targetname");
   level.trigger_knife setHintString("Press ^3[&&1]^7 to enter knife room");
    jumperk = getEnt ("jumper_knife", "targetname");
    actik = getEnt ("acti_knife", "targetname");

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
    trigger = getEnt ("laptop", "targetname");
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
	iPrintLnBold("^6Eryk^7 is here.");
	player setClientDvar("bg_bobmax" , "0");
	player hide();
	wait 5;
	player show();
	wait 1;
	iPrintlnBold("^6IT'S LIKE A LOOT MACHINE^7");
	      AmbientStop(2);
	AmbientPlay ( "lootmachine" );
//	break;
    }
        else
        {
		player iPrintLnBold("You're not mapper.");
		wait 1;
        }
    }
}

lootmachine()
{
	trig = getent("obrazek" , "targetname");
	trig waittill ("trigger", player);
	iPrintlnBold("^6DJ WIELKI HUJ ON DA BEAT^7");
	      AmbientStop(2);
	AmbientPlay ( "radlery" );
//	break;
	trig delete();
}

dcaccess()
{
    trigger = getEnt ("vending_trigger", "targetname");
    trigger setHintString ("^6VIP & DC Team Access^7");
for(;;)
{

    trigger waittill ("trigger", player);
    guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	 if ( isSubStr( toLower(gametag), toLower("DC |")) || gametag == "eryk" || gametag == "lentava" || gametag == "mysens'lentava" || gametag == "Brickkk" || gametag == "DC | lentava" || gametag == "DC | Death" || gametag == "DC | tiki" || gametag == "Seven")

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

music()
{
    level.music = randomint(5);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "ceremony" );
	 iPrintLN("Now playing: Yung Lean, Bladee, Skrillex - Ceremony");
     break;

     case 1:
	 AmbientStop(2);
     AmbientPlay( "problem" );
	 iPrintln("Now playing: PRO8L3M - GeForce");
     break;

     case 2:
	       AmbientStop(2);
     AmbientPlay( "etc" );
	iPrintln("Now playing: sanah - etc");
     break;

     case 3:
	       AmbientStop(2);
     AmbientPlay( "sendmeonmyway" );
	 iPrintln("Now playing: Rusted Root - Send Me On My Way");
     break;

     case 4:
	       AmbientStop(2);
     AmbientPlay( "cyberpunk" );
	 iPrintln("Now playing: Rosa Walton - I Really Want to Stay At Your House");
     break;

   }
}

credits() 
{
    while(1) 
	{
        iPrintln("Thanks to Seven, Death and Vay. They helped me fix bugs and script the map.");
        wait 30;
        iPrintln("Map created by Eryk");
        wait 30;
		iPrintln("raky jebem ti kurac");
		wait 30;
		iPrintln("^6KITI!!! :DDDDDDDDdddddddDddd^7");
		wait 30;
        }
}


trap_teleport()
{
	trig = getEnt("acti_trig_spec1", "targetname");
	traptele = getEnt("origin_spec1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(traptele.origin);
		player setPlayerAngles (traptele.angles);
	}
}
trap_teleport_back()
{
	trig = getEnt("trig_acti_back", "targetname");
	traptele2 = getEnt("origin_spec2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(traptele2.origin);
		player setPlayerAngles (traptele2.angles);
	}
}