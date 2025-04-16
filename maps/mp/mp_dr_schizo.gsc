#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main()
{
    //maps\mp\mp_dr_schizo_fx::main();
    maps\mp\_load::main();
    //thread maps\saveload::main();

    game["allies"] = "sas";
    game["axis"] = "russian";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    SetDvar("bg_falldamagemaxheight", 99999);
    SetDvar("bg_falldamageminheight", 99998);


    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((48, -320, 268), 0);


    addTriggerToList( "acti1" );
    addTriggerToList( "acti2" );
    addTriggerToList( "acti3" );

    thread teleport1();
    thread teleport2();
    thread teleport3();
    thread teleport4();
    thread teleport5();
    thread teleport6();
    thread teleport7();
    thread teleport8();
    //thread credits();
    //thread music();
    //thread secretsong();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread sniper();
    //thread rifle();
    //thread endmap();
    //thread antiglitcher();
    //thread teleportacti();
    //thread select();
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

waitdead()
{
    activator = GetActivator();
    level.trigger_knife = getent("rifleroomtrigger","targetname");
    level.trigger_scope = getent("sniperroomtrigger","targetname");
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_scope thread maps\mp\_utility::triggerOn();
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
        
        if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"    )
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

select() 
{
level.room_trig = getEnt( "roomselecttrigger", "targetname");
room = getEnt( "endroomorigin", "targetname" );
level.room_trig setHintString ("Press ^3[&&1]^7 to enter room selection");

for(;;)
{
level.room_trig waittill( "trigger", player );
///////RESPECT SCRIPT/////////////////////////
//if(!plugins_respect::roomCheck(player))
//continue;
///////RESPECT SCRIPT END/////////////////////////
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

teleport1()
{
    trig = getEnt("triggertp1", "targetname");
    tele = getEnt("origintp1", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport2()
{
    trig = getEnt("triggertp2", "targetname");
    tele = getEnt("origintp2", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport3()
{
    trig = getEnt("triggertp3", "targetname");
    tele = getEnt("origintp3", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport4()
{
    trig = getEnt("triggertp4", "targetname");
    tele = getEnt("origintp4", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport5()
{
    trig = getEnt("triggertp5", "targetname");
    tele = getEnt("origintp5", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport6()
{
    trig = getEnt("triggertp6", "targetname");
    tele = getEnt("origintp6", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport7()
{
    trig = getEnt("triggertp7", "targetname");
    tele = getEnt("origintp7", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleport8()
{
    trig = getEnt("triggertp8", "targetname");
    tele = getEnt("origintp8", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
    }
}

teleportacti()
{
    trig = getEnt("actitptrigger", "targetname");
    tele = getEnt("actitporigin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
    }
}

Trap1()
{
trig = getEnt("acti1","targetname");

brush = getEnt("trap1","targetname");

trig waittill("trigger", player);

trig delete();
for(;;)
        {
        wait 1;
        brush rotatePitch (-360, 3, 0, 0);
        wait 4;
        }
}

Trap2()
{
   brush = getent("trap2", "targetname");
   trig = getent("acti2", "targetname");
   trig waittill ("trigger");

   trig delete();
   for(;;)
    {
    brush moveY(170,3);
    wait 3;
    brush moveY(-170,3);
    wait 3;
    }
}

trap3()
{
   brush = getent("trap3", "targetname");
   trig = getent("acti3", "targetname");
   trig waittill ("trigger");

   trig delete();
   for(;;)
    {
    brush moveZ(170,3);
    wait 3;
    brush moveZ(-170,3);
    wait 3;
    }
}

sniper()
{
    level.trigger_scope = getEnt ("sniperroomtrigger", "targetname");
    level.trigger_scope setHintString("Press ^3[&&1]^7 to enter scope room");
    jumpersc = getEnt ("sniperjumperorigin", "targetname");
    actisc = getEnt ("sniperactiorigin", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player);
        
        iPrintLnBold("^2 " + player.name + " ^7Entered The ^2Sniper ^7Room^2!");
        activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
        player thread RoomCountDown("^3Snipe each other !", 3, 0);
        activator thread RoomCountDown("^3Snipe each other !", 3, 0);
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);    
        activator setOrigin (actisc.origin);
        activator setPlayerAngles (actisc.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("remmington700_mp");
        activator giveWeapon("remmington700_mp");
        player giveMaxAmmo("remmington700_mp");
        activator giveMaxAmmo("remmington700_mp");
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

rifle()
{
   level.trigger_knife = getEnt ("rifleroomtrigger", "targetname");
   level.trigger_knife setHintString("Press ^3[&&1]^7 to enter rifle room");
    jumperk = getEnt ("riflejumperorigin", "targetname");
    actik = getEnt ("rifleactiorigin", "targetname");

   for(;;)
    {
        level.trigger_knife waittill ("trigger", player);

        iPrintLnBold("^6 " + player.name + " ^7Entered The ^6Rifle ^7Room^6!^7");
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
        player giveWeapon("ak47_mp");
        activator giveWeapon("ak47_mp");
        player switchToWeapon("ak47_mp");
        activator switchToWeapon("ak47_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        
        while(isDefined(player) && isAlive(player))
        wait .05;
        
    }
}

music()
{
    level.music = randomint(4);
    wait 3;
    switch(level.music)
   {
      case 0:
            AmbientStop(2);
     AmbientPlay( "song1" );
     iPrintLN("Song name: i was only temporary - my head is empty");
     break;
      case 1:
            AmbientStop(2);
     AmbientPlay( "song2" );
     iPrintLN("Song name: Poison Tree - Grouper");
     break;
      case 2:
            AmbientStop(2);
     AmbientPlay( "song3" );
     iPrintLN("Song name: A1-It's just a burning memory - The Caretaker");
     break;
      case 3:
            AmbientStop(2);
     AmbientPlay( "song4" );
     iPrintLN("Song name: Cancel - REDCHINAWAVE");
     break;
     case 4:
            AmbientStop(2);
     AmbientPlay( "song5" );
     iPrintLN("Song name: Gans Gewoen - Erwin");
     break; 
    }
}

secretsong()
{
    trig = getent("triggersecretsong" , "targetname");
    trig setHintString("Play a happy song");
    trig waittill ("trigger", player);
    iPrintln("Song Name: Gans Gewoen - Erwin");
          AmbientStop(2);
    AmbientPlay ( "song5" );
//    break;
    trig delete();
}

credits()
{
  while(1) 
    {
        wait 10;
        iPrintln("^3M^7ap created by Flub");
        wait 10;
        iPrintln("Special thanks to the people in my walls and... :");
        wait 0.5;
        iPrintln("^3E^7ryk | ^3L^7entava for scripting & mapping help");
        wait 0.5;
        iPrintln("^3S^7loth for custom weapons and mapping help");
        wait 0.5;
        iPrintln("^3C^7lippy for being my Microsoft Helpdesk");
        wait 30;
    }
}