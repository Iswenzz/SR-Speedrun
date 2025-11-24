#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main()
{
    //maps\mp\mp_dr_pendulum_fx::main();
    maps\mp\_load::main();
    //thread maps\saveload::main();

    game["allies"] = "sas";
    game["axis"] = "russian";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    SetDvar("bg_falldamagemaxheight", 99999);
    SetDvar("bg_falldamageminheight", 99999);

    //addTriggerToList( "badactitrigger" );
    //addTriggerToList( "actitrap1" );

    //precacheitem("iw8_hdromeo_mp");
    //precacheitem("t10_skateboard_mp");
    //precacheitem("china_lake_mp");

    thread sr\api\_map::createSpawn((288, 1424, 76), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");

    thread sr_sec_enter();

    //thread secrettp();
    thread secretendtp();
    //thread credits();
    //thread music();
    //thread trap1();
    //thread trap2();
    //thread sniper();
    //thread grenade_launcher();
    //thread knife();
    //thread endmap();
    //thread antiglitcher();
    //thread teleportacti2();
    //thread teleportacti3();
    //thread select();
    //thread secretxp();
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(475.718, 1423.02, 16.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secretorigin","targetname");

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
    level.trigger_knife = getent("knifetrigger","targetname");
    level.trigger_scope = getent("snipertrigger","targetname");
    level.trigger_grenade = getent("grenadelaunchertrigger","targetname");
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_grenade thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_grenade thread maps\mp\_utility::triggerOn();
}

endmap()
{
    trig = getEnt("endmaptrigger", "targetname");
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

secrettp()
{
    trig = getEnt("secrettrigger", "targetname");
    tele = getEnt("secretorigin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player freezeControls(1);
        wait 0.05;
        player freezeControls(0);
        wait 0.05;
        //player giveWeapon("t10_skateboard_mp");
        //player switchToWeapon("t10_skateboard_mp");
    }
}

secretendtp()
{
    trig = getEnt("secretendtrigger", "targetname");
    tele = getEnt("secretendorigin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);

        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}

trap1()
{
trig = getEnt("actitrap1","targetname");

brush = getEnt("bouncetrap1","targetname");

trig waittill("trigger", player);

trig delete();
for(;;)
        {
        wait 1;
        brush rotatePitch (-360, 3, 0, 0);
        wait 4;
        }
}

trap2()
{
   brush = getent("trap2", "targetname");
   trig = getent("badactitrigger", "targetname");
   trig waittill ("trigger");

   trig delete();
   for(;;)
    {
    brush moveZ(220,3);
    wait 3;
    brush moveZ(-220,3);
    wait 3;
    }
}

teleportacti2()
{
    trig = getEnt("actitp", "targetname");
    tele = getEnt("actiorigin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player freezeControls(1);
        wait 0.05;
        player freezeControls(0);
        wait 0.05;
        iPrintLnBold("^2 " + player.name + " ^7Got himself a penthouse!");
    }
}

teleportacti3()
{
    trig = getEnt("badactitrigger", "targetname");
    tele = getEnt("badactiorigin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player freezeControls(1);
        wait 0.05;
        player freezeControls(0);
        wait 0.05;
        iPrintLnBold("^2 " + player.name + " ^7ACTIVATED AND GOES TO PRISON!");
    }
}

sniper()
{
    level.trigger_scope = getEnt ("snipertrigger", "targetname");
    level.trigger_scope setHintString("Press ^3[&&1]^7 to enter Sniper Room");
    jumpersc = getEnt ("jumpersniperorigin", "targetname");
    actisc = getEnt ("actisniperorigin", "targetname");

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
        player giveWeapon("iw8_hdromeo_mp");
        activator giveWeapon("iw8_hdromeo_mp");
        player giveMaxAmmo("iw8_hdromeo_mp");
        activator giveMaxAmmo("iw8_hdromeo_mp");
        player giveWeapon("m40a3_mp");
        activator giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        activator giveMaxAmmo("m40a3_mp");
        player switchToWeapon("iw8_hdromeo_mp");
        activator switchToWeapon("iw8_hdromeo_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}

knife()
{
   level.trigger_knife = getEnt ("knifetrigger", "targetname");
   level.trigger_knife setHintString("Press ^3[&&1]^7 to enter Skateboard Knife Room");
    jumperk = getEnt ("jumperknifeorigin", "targetname");
    actik = getEnt ("actiknifeorigin", "targetname");

   for(;;)
    {
        level.trigger_knife waittill ("trigger", player);

        iPrintLnBold("^6 " + player.name + " ^7Entered The ^6Knife ^7Room^6!^7");
        activator = getactivator();
        player thread waitdead();
        thread fightHUD("Knife Room", player, activator);
        activator thread RoomCountDown("^3Knife each other !", 3, 0);
        player thread RoomCountDown("^3Knife each other !", 3, 0);
        player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        activator setOrigin (actik.origin);
        activator setPlayerAngles (actik.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("t10_skateboard_mp");
        activator giveWeapon("t10_skateboard_mp");
        player switchToWeapon("t10_skateboard_mp");
        activator switchToWeapon("t10_skateboard_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

grenade_launcher()
{
    level.trigger_grenade = getEnt ("grenadelaunchertrigger", "targetname");
    level.trigger_grenade setHintString("Press ^3[&&1]^7 to enter Grenade Launcher Room");
    jumpersc = getEnt ("jumpergrenadeorigin", "targetname");
    actisc = getEnt ("actigrenadeorigin", "targetname");

    for(;;)
    {
        level.trigger_grenade waittill ("trigger", player);

        iPrintLnBold("^2 " + player.name + " ^7Entered The ^2Grenade Launcher ^7Room^2!");
        activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Grenade Launcher Room", player, activator);
        player thread RoomCountDown("^3BOMB each other!", 3, 0);
        activator thread RoomCountDown("^3BOMB each other!", 3, 0);
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);
        activator setOrigin (actisc.origin);
        activator setPlayerAngles (actisc.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("china_lake_mp");
        activator giveWeapon("china_lake_mp");
        player giveMaxAmmo("china_lake_mp");
        activator giveMaxAmmo("china_lake_mp");
        player switchToWeapon("china_lake_mp");
        activator switchToWeapon("china_lake_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}

secretxp()
{
    trig = getEnt("creeper", "targetname");
    trig waittill("trigger", player);
    trig delete();

    iPrintLnBold("^1" + player.name + " wants MINE V2 and found bonus XP!^7");
    player braxi\_rank::giveRankXP("", 4000);
}

music()
{
    level.music = randomint(5);
    wait 3;
    switch(level.music)
   {
      case 0:
            AmbientStop(2);
     AmbientPlay( "song1" );
     iPrintLN("Song name: Midnight Runner - Pendulum");
     break;
      case 1:
            AmbientStop(2);
     AmbientPlay( "song2" );
     iPrintLN("Song name: Slam - Pendulum");
     break;
      case 2:
            AmbientStop(2);
     AmbientPlay( "song3" );
     iPrintLN("Song name: The Island Pt.1 (Dawn) - Pendulum");
     break;
      case 3:
            AmbientStop(2);
     AmbientPlay( "song4" );
     iPrintLN("Song name: The Other Side - Pendulum");
     break;
     case 4:
            AmbientStop(2);
     AmbientPlay( "song5" );
     iPrintLN("Song name: The Tempest - Pendulum");
     break;
    }
}

credits()
{
  while(1)
    {
        wait 10;
        iPrintln("^3Map created by Flub");
        wait 20;
        iPrintln("Special thanks to:");
        wait 0.5;
        iPrintln("^7Eryk/Lentava for helping");
        wait 0.5;
        iPrintln("^7LEGz criz for ideas");
        wait 0.5;
        iPrintln("^7Sloth and The Stig for custom weapons and help");
        wait 0.5;
        iPrintln("And everyone who helped me in any way (iMtroll)");
        wait 30;
    }
}