#include maps\mp\_utility;
#include common_scripts\utility;

main() {
	maps\mp\_load::main();
	//thread maps\saveload::main();
    SetDvar("bg_falldamagemaxheight", 99999);
    SetDvar("bg_falldamageminheight", 99998);
    //SetDvar("g_speed", 210);

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//setdvar("bg_bobmax" , "0");
	// setdvar("jump_slowdownenable" , "0");
	//setdvar("g_speed" , "210");
	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");
	// setdvar("r_specular" , "1");
	// setdvar("r_drawDecals" , "1");
	//setdvar("dr_jumpers_speed" , "1.12");

    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_map::createSpawn((-8022, -3367, 460), 90);

    thread startdoor();
	//thread antiglitcher();
	//thread endmap();
    //thread creditshud();
	//thread select();
    //thread music();
    //thread secret_music();
    //thread secret();
    //thread secret_xp();
    //thread credits();
    //thread creditsall();
	//teleport
    thread teleport01();
	thread teleport12();
	thread teleport23();
	thread teleport34();
	thread teleportend();
    //thread teleport12_acti();
    //thread teleport23_acti();
    //thread teleport34_acti();
    //rooms
    //thread sniper();
    //thread teleport_sniper_jumper();
    //thread teleport_sniper_acti();
    //thread rpg();
    //thread teleport_rpg_jumper();
    //thread teleport_rpg_acti();
    //thread knife();
    //thread bounce();
    //thread bouncesniper();
    //thread teleport_bounceroom_jumper();
    //thread teleport_bounceroom_acti();
    //traps
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();
    //thread trap8();

    addTriggerToList("trap1");
	addTriggerToList("trap2");
	addTriggerToList("trap3");
    addTriggerToList("trap4");
	addTriggerToList("trap5");
	addTriggerToList("trap6");
    addTriggerToList("trap7");
	addTriggerToList("trap8");

    precacheitem("h1_karambit_mp");
    precacheitem("rpg_mp");
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
    level.hud_fight setText("^5" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^5" + jumper + " ^0VS^0 " + "^5" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
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
select()
{
level.room_trig = getEnt( "trigger_select_room", "targetname");
room = getEnt( "origin_select_room", "targetname" );
level.room_trig setHintString ("Press ^5[&&1]^7 to enter room selection");

for(;;)
{
level.room_trig waittill( "trigger", player );
if( !isDefined( level.room_trig ) )
return;

acti = GetActivator();
if(!isdefined(level.firstenter))
{
	acti freezeControls(1);
	acti iPrintLnBold("^5Jumper ^7is picking a ^5room ^7so don't ^5move^7!");
	level notify("acti_antiglitch");
	level.firstenter = false;
}
player SetPlayerAngles( room.angles );
player setOrigin( room.origin );
player TakeAllWeapons();
player antiglitcher();
}
}
creditshud()
{
    mapby = newHudElem();
    mapby.foreground = true;
    mapby.alpha = 1;
    mapby.alignX = "left";
    mapby.alignY = "middle";
    mapby.horzAlign = "left";
    mapby.vertAlign = "middle";
    mapby.x = -400;
    mapby.y = 0;
    mapby.sort = 0;
    mapby.font = "default";
    mapby.fontScale = 1.4;
    mapby.hidewheninmenu = false;
    mapby.glowAlpha = 1;
    mapby.glowColor = (.3,.0,3);
    mapby settext("^0Map by ^5LEGz criz");
    mapby moveOverTime(2);
    mapby.x = 5;
    wait 5;
    mapby moveOverTime(2);
    mapby.x = -500;
    wait 7;
    mapby destroy();
}
waitdead()
{
    activator = GetActivator();
    level.trigger_scope = getent("sniper","targetname");
    level.trigger_bounce = getent("bounce","targetname");
    level.trigger_knife = getent("knife","targetname");
    level.trigger_rpg = getent("rpg","targetname");
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_bounce thread maps\mp\_utility::triggerOff();
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_rpg thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_bounce thread maps\mp\_utility::triggerOn();
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_rpg thread maps\mp\_utility::triggerOn();

}
startdoor()
{
    door = getEnt("door", "targetname");

    wait 0.1;

    door delete();

}
music()
{
    level.music = randomint(2);

   while(1)
    {
    wait 12;
    switch(level.music)
   {
    case 0:
	    AmbientStop(2);
        AmbientPlay( "song1" );
    break;
    case 1:
	    AmbientStop(2);
        AmbientPlay( "song3" );
    break;
    // case 2:
	//        AmbientStop(2);
    //AmbientPlay( "song3" );
    // break;
	}
    break;
    }
}
secret_music()
{
trig = getent("secret_music", "targetname");
for(;;)
    {
    trig waittill ("trigger", player);
    AmbientStop(2);
    AmbientPlay("song2");
    iprintlnbold("^5 " + player.name + " ^7activated a SECRET SONG!");
    trig delete();
    }

}
credits()
{
  while(1)
	{
        wait 10;
        iPrintln("^5M^7ap created by ^5LEGz criz");
		wait 1;
		iPrintln("Join ^5Velocity ^7Discord server: https://discord.gg/7fWhErrSEa");
        wait 10;
		iPrintln("You^1Tube^7 channel: www.youtube.com/@crizbye");
		wait 5;
		iPrintln("Thanks to:");
		wait 0.5;
		iPrintln("^5C^7lippy, ^5E^7ryk, ^5R^7exy and ^5S^7even for help");
		wait 0.5;
		iPrintln("^5S^7loth for karambit model");
		wait 0.5;
		iPrintln("Map made for ^5Velocity ^7Deathrun: 162.19.241.204:28960");
		wait 30;
        iPrintln("^5M^7ap created by ^5LEGz criz");
		wait 1;
		iPrintln("Join ^5Velocity ^7Discord server: https://discord.gg/7fWhErrSEa");
        wait 30;
        }
}
creditsall()
{
        trig = getEnt("credits", "targetname");
        trig setHintstring("Press ^5[&&1]^7 to show credits");
        for(;;)
        {
        trig waittill("trigger", player);
        iPrintLnBold("Map made by ^5LEGz criz");
	    wait 1;
	    iPrintLnBold("Join ^5Velocity ^7Discord server: ^5https://discord.gg/7fWhErrSEa");
        trig delete();
        }
    }
secret()
{
    trig = getEnt("secret", "targetname");
    tele = getEnt("secret_origin", "targetname");
    trig sethintstring("Press ^4[&&1]^7 to get bonus XP!");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player freezecontrols(1);
        wait 0.5;
        player freezecontrols(0);
    }

}
secret_xp()
{
    trig = getEnt("secret_xp", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        iprintlnbold("^5 " + player.name + " ^7found bonus XP!");
        //player braxi_rank::giveRankXP("", 4000);
        trig delete();
    }
}

//rooms
sniper()
{
    level.trigger_scope = getEnt ("sniper", "targetname");
	level.trigger_scope setHintString("Press ^2[&&1]^7 to enter scope room");
    jumpersc = getEnt ("sniper_origin_jumper", "targetname");
    actisc = getEnt ("sniper_origin_acti", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player, activator);
        iPrintLnBold("^5 " + player.name + " ^7Entered The ^5Sniper ^7Room^5!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
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
        //wait 1;
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}
teleport_sniper_jumper()
    {
        trig = getEnt("jumper_sniper_fail", "targetname");
        tele = getEnt("jumper_sniper_fail_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
        }
    }
     teleport_sniper_acti()
    {
        trig = getEnt("acti_sniper_fail", "targetname");
        tele = getEnt("acti_sniper_fail_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
        }
    }
    rpg()
{
    level.trigger_rpg = getEnt ("rpg", "targetname");
	level.trigger_rpg setHintString("Press ^6[&&1]^7 to enter rpg room");
    jumperrpg = getEnt ("origin_jumper_rpg", "targetname");
    actirpg = getEnt ("origin_acti_rpg", "targetname");

    for(;;)
    {
        level.trigger_rpg waittill ("trigger", player, activator);
        iPrintLnBold("^5 " + player.name + " ^7Entered The ^5RPG ^7Room^5!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("RPG Room", player, activator);
        player setOrigin (jumperrpg.origin);
        player setPlayerAngles (jumperrpg.angles);
        activator setOrigin (actirpg.origin);
        activator setPlayerAngles (actirpg.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("rpg_mp");
        activator giveWeapon("rpg_mp");
        player giveMaxAmmo("rpg_mp");
        activator giveMaxAmmo("rpg_mp");
        player switchToWeapon("rpg_mp");
        activator switchToWeapon("rpg_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}
 teleport_rpg_jumper()
    {
        trig = getEnt("jumper_rpg_fail", "targetname");
        tele = getEnt("jumper_rpg_fail_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
        }
    }
teleport_rpg_acti()
    {
        trig = getEnt("acti_rpg_fail", "targetname");
        tele = getEnt("acti_rpg_fail_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
        }
    }
    knife()
{
    level.trigger_knife = getEnt ("knife", "targetname");
	level.trigger_knife setHintString("Press ^1[&&1]^7 to enter knife room");
    jumper = getEnt ("origin_jumper_knife", "targetname");
    acti = getEnt ("origin_acti_knife", "targetname");

    for(;;)
{
        level.trigger_knife waittill ("trigger", player, activator);
        iPrintLnBold("^5 " + player.name + " ^7Entered The ^5Knife ^7Room^5!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Knife Room", player, activator);
        player setOrigin (jumper.origin);
        player setPlayerAngles (jumper.angles);
        activator setOrigin (acti.origin);
        activator setPlayerAngles (acti.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("h1_karambit_mp");
        activator giveWeapon("h1_karambit_mp");
        player switchtoweapon("h1_karambit_mp");
        activator switchtoweapon("h1_karambit_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        //wait 1;
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
}
}
bounce()
{
    level.trigger_bounce = getEnt ("bounce", "targetname");
	level.trigger_bounce setHintString("Press ^4[&&1]^7 to enter bounce room");
    jumperb = getEnt ("origin_jumper_bounce", "targetname");
    actib = getEnt ("origin_acti_bounce", "targetname");

    for(;;)
    {
        level.trigger_bounce waittill ("trigger", player);

        iPrintLnBold("^5 " + player.name + " ^7Entered The ^5Bounce ^7Room^5!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Bounce Room", player, activator);
        player setOrigin (jumperb.origin);
        player setPlayerAngles (jumperb.angles);
        activator setOrigin (actib.origin);
        activator setPlayerAngles (actib.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("h1_karambit_mp");
        activator giveWeapon("h1_karambit_mp");
        player switchtoweapon("h1_karambit_mp");
        activator switchtoweapon("h1_karambit_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread RoomCountDown("^5Get to the end and kill each other !", 3, 0);
        activator thread RoomCountDown("^5Get to the end and kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}
bouncesniper()
{
    trig = getEnt("bounce_givesniper", "targetname");
    trig setHintString("Press ^4[&&1]^7 to get the weapon!");
    for(;;)
    {
        trig waittill ("trigger", player);
        player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        iprintlnbold("^5"+player.name+" ^7got the gun!");

    }
}
teleport_bounceroom_jumper()
{
    trig = getEnt("jumper_fail", "targetname");
    tele = getEnt("jumper_fail_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player iprintlnbold("You failed... try again!");
        player setPlayerAngles(tele.angles);
    }
}

    teleport_bounceroom_acti()
{
    trig = getEnt("acti_fail", "targetname");
    tele = getEnt("acti_fail_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player iprintlnbold("You failed... try again!");
        player setPlayerAngles(tele.angles);
    }
}
//teleports
teleport01()
{
	trig = getEnt("teleport01", "targetname");
    tele = getEnt("teleport01_origin", "targetname");

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
teleport12()
{
	trig = getEnt("teleport12", "targetname");
    tele = getEnt("teleport12_origin", "targetname");

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
teleport23()
{
	trig = getEnt("teleport23", "targetname");
    tele = getEnt("teleport23_origin", "targetname");

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
teleport34()
{
	trig = getEnt("teleport34", "targetname");
    tele = getEnt("teleport34_origin", "targetname");

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
teleportend()
{
	trig = getEnt("teleport_end", "targetname");
    tele = getEnt("teleport_end_origin", "targetname");

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
teleport12_acti()
{
	trig = getEnt("teleport12_acti", "targetname");
    tele = getEnt("teleport12_acti_origin", "targetname");
    trig sethintstring("Press ^2[&&1]^7 to enter the next ^2Stage");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player iprintlnbold("Welcome to the ^1Ruby ^7Stage");
    }
}
teleport23_acti()
{
	trig = getEnt("teleport23_acti", "targetname");
    tele = getEnt("teleport23_acti_origin", "targetname");
    trig sethintstring("Press ^1[&&1]^7 to enter the next ^1Stage 3");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player iprintlnbold("Welcome to the ^4Sapphire ^7Stage");
    }
}
teleport34_acti()
{
	trig = getEnt("teleport34_acti", "targetname");
    tele = getEnt("teleport34_acti_origin", "targetname");
    trig sethintstring("Press ^4[&&1]^7 to enter the next ^4Stage");
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player iprintlnbold("Welcome to the ^6Amethyst ^7Stage");
    }
}

//traps
trap1()
{
    trig = getEnt("trap1", "targetname");
    trig sethintstring("Press ^2[&&1]^7 to activate trap 1!");
    trig waittill("trigger", player);
    trap1_1 = getEnt("trap1_1", "targetname");
    trap1_2 = getEnt("trap1_2", "targetname");
    trig setHintstring("^2Activated!");
    while(true)
    {
        trap1_1 hide();
        trap1_1 notsolid();
        wait 2;
        trap1_1 show();
        trap1_1 solid();
        wait 2;
        trap1_2 hide();
        trap1_2 notsolid();
        wait 2;
        trap1_2 show();
        trap1_2 solid();
        wait 2;
    }

}
trap2()
{
    trig = getEnt("trap2", "targetname");
    trig sethintstring("Press ^2[&&1]^7 to activate trap 2!");
    trig waittill("trigger", player);
    trap2_1 = getEnt("trap2_1", "targetname");
    trap2_2 = getEnt("trap2_2", "targetname");
   choice = randomint(2); // losuje 0 albo 1

    if (choice == 0)
        trap2_1 delete();
    else
        trap2_2 delete();
    trig setHintstring("^2Activated!");
}
trap3()
{
    trig = getEnt("trap3", "targetname");
    trig sethintstring("Press ^1[&&1]^7 to activate trap 3!");
    trig waittill("trigger", player);
    trap3_1 = getEnt("trap3_1", "targetname");
    trap3_2 = getEnt("trap3_2", "targetname");
    trig setHintstring("^1Activated!");
    while(true)
    {
        trap3_1 hide();
        trap3_1 notsolid();
        wait 2;
        trap3_1 show();
        trap3_1 solid();
        wait 2;
        trap3_2 hide();
        trap3_2 notsolid();
        wait 2;
        trap3_2 show();
        trap3_2 solid();
        wait 2;
    }

}
trap4()
{
    trig = getEnt("trap4", "targetname");
    trig sethintstring("Press ^1[&&1]^7 to activate trap 4!");
    trig waittill("trigger", player);
    trap4 = getEnt("trap4_1", "targetname");
    trig setHintstring("^1Activated!");
    while(true)
    {
        trap4 rotateyaw(360,2);
        wait 6;
    }

}
trap5()
{
    trig = getEnt("trap5", "targetname");
    trig sethintstring("Press ^4[&&1]^7 to activate trap 5!");
    trig waittill("trigger", player);
    trap5_1 = getEnt("trap5_1", "targetname");
    trig setHintstring("^4Activated!");
    while(true)
    {
        trap5_1 hide();
        trap5_1 notsolid();
        wait 2;
        trap5_1 show();
        trap5_1 solid();
        wait 5;
    }

}
trap6()
{
    trig = getEnt("trap6", "targetname");
    trig sethintstring("Press ^4[&&1]^7 to activate trap 6!");
    trig waittill("trigger", player);
    trap6 = getEnt("trap6_1", "targetname");
    trig setHintstring("^4Activated!");
    while(true)
    {
      trap6 rotatepitch(360,2);
      wait 6;
    }

}
trap7()
{
    trig = getEnt("trap7", "targetname");
    trig sethintstring("Press ^6[&&1]^7 to activate trap 7!");
    trig waittill("trigger", player);
    trap7 = getEnt("trap7_1", "targetname");
    trig setHintstring("^6Activated!");
    while(true)
    {
        trap7 rotateyaw(360,2);
        wait 5;
    }

}
trap8()
{
    trig = getEnt("trap8", "targetname");
    trig sethintstring("Press ^6[&&1]^7 to activate trap 8!");
    trig waittill("trigger", player);
    trap8 = getEnt("trap8_1", "targetname");
    trig setHintstring("^6Activated!");
    while(true)
    {
        trap8 rotateyaw(360,2);
        wait 5;
    }
}