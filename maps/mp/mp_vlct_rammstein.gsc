#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	maps\mp\_load::main();
	//thread maps\saveload::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");

    thread sr\api\_map::createSpawn((352,387,76), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret");

    thread sr_easy_sec_enter();
    thread sr_hard_sec_enter();

	//thread credits();
    //thread credits2();
    thread startdoor();
    //thread music();
    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap6();
    thread trap7();
    //thread select();
    //thread knife();
    //thread sniper();
    //thread bounce();
    //thread bounce_acti_fail();
    //thread bounce_jumper_fail();
    //thread bounce_weap();
    thread easy_secret_fail1();
    thread easy_secret_fail2();
    thread easy_secret_fail3();
    thread easy_secret_fail4();
    thread easy_secret_fail5();
    thread easy_secret_end();
    thread main_route_ext();
    thread main_route_ext_end();
	//thread secret_hard();
    //thread secret_easy();
	thread secret_fail_1();
    thread secret_fail_2();
    thread secret_fail_3();
    thread secret_fail_4();
    thread secret_fail_5();
    thread secret_fail_6();
	thread secret_end();
	//thread creditshud();
	//thread antiglitcher();
    //thread endmap();
    //thread actixp();

    addTriggerToList("trap1");
    addTriggerToList("trap2");
    addTriggerToList("trap3");
    addTriggerToList("trap4");
    addTriggerToList("trap5");
    addTriggerToList("trap6");
    addTriggerToList("trap7");

    precacheitem("iw8_butterflyknife_mp");

}
sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(531.957, 360, 16.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_easy_sec","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(162.758, 360, 16.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secret_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread anti_10fps(time);
}
anti_10fps(time) {
	wait time;
	self freezecontrols(false);
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
    mapby settext("^0Map by ^5Rammstein");
    mapby moveOverTime(2);
    mapby.x = 5;
    wait 5;
    mapby moveOverTime(2);
    mapby.x = -500;
    wait 7;
    mapby destroy();
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
startDeathTimer(duration)
{
    if (!isDefined(self) || !isPlayer(self))
        return;

    player = self;
    if (isDefined(player.deathTimerHud))
    {
        player.deathTimerHud destroy();
    }
    player.deathTimerCancelled = false;

    hudTimer = newClientHudElem(player);
    hudTimer.alignX = "center";
    hudTimer.alignY = "bottom";
    hudTimer.horzAlign = "center";
    hudTimer.vertAlign = "bottom";
    hudTimer.y = -10;
    hudTimer.fontScale = 2;
    hudTimer.alpha = 1;
    hudTimer.color = (0.26, 0.95, 0.96);
    hudTimer.glowalpha = 1;
    hudTimer.glowcolor = (0.26, 0.95, 0.96);
    hudTimer setValue(duration);

    player.deathTimerHud = hudTimer;

    player thread [[::deathWatcher]]();

    for (i = duration; i >= 0; i--)
    {
        if (!isDefined(player) || !isAlive(player) || player.deathTimerCancelled)
        {
            if (isDefined(hudTimer))
                hudTimer destroy();
            return;
        }

        hudTimer setValue(i);
        wait 1;
    }

    if (isDefined(player) && isAlive(player) && !player.deathTimerCancelled)
    {
        if (isDefined(hudTimer))
            hudTimer destroy();
        player suicide();
    }
}
    deathWatcher()
{
    self waittill_any("death", "disconnect");
    if (isDefined(self.deathTimerHud))
    {
        self.deathTimerHud destroy();
        self.deathTimerHud = undefined;
    }
    self.deathTimerCancelled = true;
}
	credits()
	{
		while(1)
        {
		wait 10;
		iPrintLn("Map by ^5vlct'RammsteiN^7");
        wait 5;
        iPrintLn("Hard secret made by ^5L^7EGz ^5c^7riz");
		wait 5;
        iPrintLn("Thanks ^5L^7EGz ^5c^7riz for everything <3");
        wait 5;
        iPrintLn("Thanks eryk/lentava for testing and suggestions");
        wait 5;
        iPrintLn("Thanks VC'Fox for music, testing and feedback");
        wait 5;
        iPrintLn("Thanks compy for testing");
        wait 5;
        iPrintLn("Thanks Klay for testing");
        wait 5;
        iPrintLn("Thanks Ems for testing");
        wait 50;
	}
    }
    waitdead()
{
    activator = GetActivator();
    level.trigger_scope = getent("trigger_sniper","targetname");
    level.trigger_knife = getent("trigger_knife","targetname");
    level.trigger_bounce = getent("trigger_bounce","targetname");
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_bounce thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_bounce thread maps\mp\_utility::triggerOn();
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
credits2()
{
    trig=getent("credits","targetname");
    trig sethintstring("Press ^5[&&1]^7 to show credits");
    for(;;)
    {
    trig waittill("trigger",player);
    iprintlnbold("Map by ^5vlct'RammsteiN^7");
    trig sethintstring("");
    trig delete();
    }
}
actixp()
{
    trig=getEnt("acti_xp","targetname");
    for(;;)
    {
        trig waittill("trigger",player);
        //player braxi\_rank::giveRankXP("", 500);
        iprintlnbold("Acti finished special route");
        trig delete();
    }
}
startdoor()
{
    door=getEnt("start_door","targetname");

     wait 0.1;

     door delete();

}
music()
{
    level.music=randomint(6);
    level waittill("round_started");
        switch(level.music)
        {
            case 0:
            ambientstop(2);
            ambientplay("song1");
            break;
            case 1:
            ambientstop(2);
            ambientplay("song2");
            break;
            case 2:
            ambientstop(2);
            ambientplay("song3");
            break;
            case 3:
            ambientstop(2);
            ambientplay("song4");
            break;
            case 4:
            ambientstop(2);
            ambientplay("song5");
            break;
            case 5:
            ambientstop(2);
            ambientplay("song6");
            break;
        }

}
    knife()
{
    level.trigger_knife = getEnt ("trigger_knife", "targetname");
	level.trigger_knife setHintString("Press ^5[&&1]^7 to enter knife room");
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
        player giveWeapon("iw8_butterflyknife_mp");
        activator giveWeapon("iw8_butterflyknife_mp");
        player switchtoweapon("iw8_butterflyknife_mp");
        activator switchtoweapon("iw8_butterflyknife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        //wait 1;
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
}
}
 sniper()
{
    level.trigger_scope = getEnt ("trigger_sniper", "targetname");
	level.trigger_scope setHintString("Press ^5[&&1]^7 to enter scope room");
    jumpersc = getEnt ("origin_jumper_sniper", "targetname");
    actisc = getEnt ("origin_acti_sniper", "targetname");

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
   bounce()
{
    level.trigger_bounce = getEnt ("trigger_bounce", "targetname");
	level.trigger_bounce setHintString("Press ^5[&&1]^7 to enter bounce room");
    jumper = getEnt ("origin_jumper_bounce", "targetname");
    acti = getEnt ("origin_acti_bounce", "targetname");

    for(;;)
    {
        level.trigger_bounce waittill ("trigger", player);

        iPrintLnBold("^5 " + player.name + " ^7Entered The ^5Bounce ^7Room^5!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Bounce Room", player, activator);
        player setOrigin (jumper.origin);
        player setPlayerAngles (jumper.angles);
        activator setOrigin (acti.origin);
        activator setPlayerAngles (acti.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("iw8_butterflyknife_mp");
        activator giveWeapon("iw8_butterflyknife_mp");
        player switchtoweapon("iw8_butterflyknife_mp");
        activator switchtoweapon("iw8_butterflyknife_mp");
        player.health = player.maxhealth;
        player thread RoomCountDown("^5Get to the end and kill each other !", 3, 0);
        activator thread RoomCountDown("^5Get to the end and kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}
bounce_acti_fail()
{
	trig = getEnt("bounce_acti_fail", "targetname");
    tele = getEnt("bounce_acti_fail_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
        player iprintlnbold("You failed");
		wait 0.1;
		player freezecontrols(0);
    }
}
bounce_jumper_fail()
{
	trig = getEnt("bounce_jumper_fail", "targetname");
    tele = getEnt("bounce_jumper_fail_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
        player iprintlnbold("You failed");
		wait 0.1;
		player freezecontrols(0);
    }
}
bounce_weap()
{
    trig = getEnt("bounce_weap", "targetname");
     trig setHintString("Press ^5[&&1]^7 to Get sniper");
     for(;;)
     {
        trig waittill("trigger", player);
        player giveweapon("remington700_mp");
        player givemaxammo("remington700_mp");
        player switchtoweapon("remington700_mp");
        iprintlnbold("^5"+player.name+" ^7Got the sniper");
     }

}
main_route_ext()
{
	trig = getEnt("main_route_ext", "targetname");
    tele = getEnt("main_route_ext_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player freezecontrols(1);
        wait 0.1;
        player freezecontrols(0);
    }
}
main_route_ext_end()
{
    trig = getEnt("main_route_ext_end", "targetname");
    tele = getEnt("main_route_ext_end_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player freezecontrols(1);
        wait 0.1;
        player freezecontrols(0);
    }
}
	secret_hard()
{
	trig = getEnt("secret_trigger", "targetname");
    tele = getEnt("secret_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
		player thread startDeathTimer(120);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player iprintlnbold("Welcome to ^1Hard^7 Secret");
    }
}
secret_easy()
{
	trig = getEnt("trigger_easy_sec", "targetname");
    tele = getEnt("origin_easy_sec", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
		player thread startDeathTimer(120);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player iprintlnbold("Welcome to ^2Easy^7 Secret");
    }
}
easy_secret_fail1()
{
    trig = getEnt("easy_secret_fail1", "targetname");
    tele = getEnt("origin_easy_secret_fail1", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
easy_secret_fail2()
{
    trig = getEnt("easy_secret_fail2", "targetname");
    tele = getEnt("origin_easy_secret_fail2", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
easy_secret_fail3()
{
    trig = getEnt("easy_secret_fail3", "targetname");
    tele = getEnt("origin_easy_secret_fail3", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
easy_secret_fail4()
{
    trig = getEnt("easy_secret_fail4", "targetname");
    tele = getEnt("origin_easy_secret_fail4", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
easy_secret_fail5()
{
    trig = getEnt("easy_secret_fail5", "targetname");
    tele = getEnt("origin_easy_secret_fail5", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
easy_secret_end()
{
	trig = getEnt("easy_secret_end", "targetname");
    tele = getEnt("easy_secret_end_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
    }
}

	secret_fail_1()
{
	trig = getEnt("secret_fail_1", "targetname");
    tele = getEnt("secret_fail_1_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
secret_fail_2()
{
	trig = getEnt("secret_fail_2", "targetname");
    tele = getEnt("secret_fail_2_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
secret_fail_3()
{
	trig = getEnt("secret_fail_3", "targetname");
    tele = getEnt("secret_fail_3_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
secret_fail_4()
{
	trig = getEnt("secret_fail_4", "targetname");
    tele = getEnt("secret_fail_4_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
secret_fail_5()
{
	trig = getEnt("secret_fail_5", "targetname");
    tele = getEnt("secret_fail_5_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
secret_fail_6()
{
	trig = getEnt("secret_fail_6", "targetname");
    tele = getEnt("secret_fail_6_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
		player freezecontrols(1);
		wait 0.1;
		player freezecontrols(0);
    }
}
	secret_end()
{
	trig = getEnt("secret_end", "targetname");
    tele = getEnt("secret_end_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_1");
    }
}
trap1()
{
    trig = getEnt("trap1","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    plat = getEnt("trap1_1","targetname");
    trig waittill("trigger",player);

}

trap2()
{
    trig = getEnt("trap2","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    plat1 = getEnt("trap2_1","targetname");
    plat2 = getEnt("trap2_2","targetname");
    trig waittill("trigger",player);

}
trap3()
{
    trig = getEnt("trap3","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    plat = getEnt("trap3_1","targetname");
    trig waittill("trigger",player);

}
trap4()
{
    trig = getEnt("trap4","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    plat1 = getEnt("trap4_1","targetname");
    plat2 = getEnt("trap4_2","targetname");
    plat3 = getEnt("trap4_3","targetname");
    trig waittill("trigger",player);

}
trap5()
{
    trig = getEnt("trap5","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    bounce = getEnt("trap5_1","targetname");
    trig waittill("trigger",player);

}
trap6()
{
    trig = getEnt("trap6","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    pillar1 = getEnt("trap6_1", "targetname");
    pillar2 = getEnt("trap6_2", "targetname");
    trig waittill("trigger",player);


}
trap7()
{
 trig = getEnt("trap7","targetname");
    trig setHintString("Press ^5[&&1]^7 to activate");
    bounce = getEnt("trap7_1","targetname");
    trig waittill("trigger",player);

}