#include maps\mp\_utility;
#include common_scripts\utility;

main() {
	maps\mp\_load::main();
	//thread maps\saveload::main();

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


    thread sr\api\_map::createSpawn((112, 192, 76), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Ice Secret;Hell Secret;Acti Secret");

    thread sr_ice_enter();
    thread sr_hell_enter();
    thread sr_acti_enter();

    //thread select();
    //thread endmap();
    //thread antiglitcher();
    //thread creditshud();
    //thread credits();
    //thread setup_music();

    //teleports
    thread teleport1();
    thread teleport12();
    thread teleport23();
    thread teleport34();
    //rooms

    //thread sniper();
    //thread teleport_sniper();
    //thread knife();
    //thread knife_fail();
    //thread pure();
    //thread pure_finish();
    //thread rpg();
    //thread teleport_rpg();
    //thread bounce();
    //thread bounce_sniper();
    //thread bounce_jumper_fail();
    //thread bounce_acti_fail();
    //secrets
    //thread secret_raky();
    //thread practise();
    thread practise_fail();
    thread practise_exit();
    thread practise_finish();
    //thread hell_secret();
    thread hell_secret_fail();
    thread hell_secret_finish();
    //thread secret_choice();
    //thread ice_secret();
    thread ice_secret_finish();
    thread fail1();
    thread fail2();
    thread fail3();
    thread fail4();
    thread fail5();
    thread fail6();
    thread fail7();
    thread fail8();
    thread fail9();
    thread tip1();
    thread tip2();
    thread tip3();
    thread tip4();
    thread tip5();
    thread tip6();
    thread tip7();
    thread tip8();
    thread tip9();
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

    precacheitem("iw8_butterflyknife_mp");
    precacheitem("h1_karambit_mp");
    precacheitem("rpg_mp");
}
sr_ice_enter()
{
	trig = spawn("trigger_radius",(124.14, 317.271, 16.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("ice_secret_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "blue");

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

sr_hell_enter()
{
	trig = spawn("trigger_radius",(124.14, 44.2309, 16.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("hell_secret_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sr_acti_enter()
{
	trig = spawn("trigger_radius",(285.398, 317.271, 16.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("practise_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_2");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
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
setup_music()
{
    level waittill("round_started");
    default_map_music();
}

default_map_music() {
    level.music = randomint(4);
    switch(level.music)
    {
    case 0:
        AmbientStop(2);
        AmbientPlay( "song1" );
        break;
    case 1:
        AmbientStop(2);
        AmbientPlay( "song2" );
        break;
    case 2:
        AmbientStop(2);
        AmbientPlay( "song3" );
        break;
    case 3:
        AmbientStop(2);
        AmbientPlay( "song4" );
        break;
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
		iPrintln("^5F^7lub, ^5E^7ryk, ^5D^7eath, ^5R^7exy and ^5S^7even for help");
		wait 0.5;
		iPrintln("^5S^7loth for karambit model");
		wait 0.5;
		iPrintln("Map made for ^5Velocity ^7Deathrun: 51.38.35.106:28960");
		wait 30;
        }
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
    AmbientStop(2);
    default_map_music();
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
waitdead()
{
    activator = GetActivator();
    level.trigger_scope = getent("trigger_sniper","targetname");
    level.trigger_bounce = getent("trigger_bounce","targetname");
    level.trigger_knife = getent("trigger_knife","targetname");
    level.trigger_pure = getent("trigger_pure","targetname");
    level.trigger_rpg = getent("trigger_rpg","targetname");
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    level.trigger_bounce thread maps\mp\_utility::triggerOff();
    level.trigger_knife thread maps\mp\_utility::triggerOff();
    level.trigger_pure thread maps\mp\_utility::triggerOff();
    level.trigger_rpg thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
    level.trigger_bounce thread maps\mp\_utility::triggerOn();
    level.trigger_knife thread maps\mp\_utility::triggerOn();
    level.trigger_pure thread maps\mp\_utility::triggerOn();
    level.trigger_rpg thread maps\mp\_utility::triggerOn();

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
//teleports
teleport1()
{
    trig = getEnt("teleport1", "targetname");
    tele = getEnt("teleport1_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            player freezeControls(1);
            wait 0.05;
            player freezeControls(0);
            wait 0.05;
        }
}
teleport12()
{
    trig = getEnt("teleport12", "targetname");
    trig setHintString("Press ^5[&&1]^7 to go to the next stage");
    tele = getEnt("teleport12_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            player freezeControls(1);
            wait 0.05;
            player freezeControls(0);
            wait 0.05;
        }
}
teleport23()
{
    trig = getEnt("teleport23", "targetname");
    trig setHintString("Press ^5[&&1]^7 to go to the next stage");
    tele = getEnt("teleport23_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            player freezeControls(1);
            wait 0.05;
            player freezeControls(0);
            wait 0.05;
        }
}
teleport34()
{
    trig = getEnt("teleport34", "targetname");
    trig setHintString("Press ^5[&&1]^7 to go to the next stage");
    tele = getEnt("teleport34_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            player freezeControls(1);
            wait 0.05;
            player freezeControls(0);
            wait 0.05;
        }
}
//rooms
sniper()
{
    level.trigger_scope = getEnt ("trigger_sniper", "targetname");
	level.trigger_scope setHintString("Press ^5[&&1]^7 to enter scope room");
    jumper = getEnt ("origin_jumper_sniper", "targetname");
    acti = getEnt ("origin_acti_sniper", "targetname");

    for(;;)
    {
        level.trigger_scope waittill ("trigger", player, activator);
        room_music();

        iPrintLnBold("^5 " + player.name + " ^7Entered The ^5Sniper ^7Room^5!");
		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
        player setOrigin (jumper.origin);
        player setPlayerAngles (jumper.angles);
        activator setOrigin (acti.origin);
        activator setPlayerAngles (acti.angles);
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
        //player.maxhealth = 100;
        player.health = player.maxhealth;
        //wait 1;
        player thread RoomCountDown("^5Kill each other !", 3, 1);
        activator thread RoomCountDown("^5Kill each other !", 3, 1);
        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}
teleport_sniper()
    {
        trig = getEnt("sniper_fail", "targetname");
        jumper = getEnt("sniper_jumper_fail_origin", "targetname");
        acti = getEnt("sniper_acti_fail_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            if(player.team == "axis"){
                player setOrigin(acti.origin);
                player setPlayerAngles(acti.angles);
            }
            else{
                player setOrigin(jumper.origin);
                player setPlayerAngles(jumper.angles);
            }

        }
    }

room_music() {
    level.musics = randomint(2);
    switch(level.musics)
    {
        case 0:
            AmbientStop(2);
        AmbientPlay( "song5" );
        break;
        case 1:
            AmbientStop(2);
        AmbientPlay( "song7" );
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
        room_music();

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
        //player.maxhealth = 100;
        player.health = player.maxhealth;
        //wait 1;
        player thread RoomCountDown("^5Kill each other !", 3, 1);
        activator thread RoomCountDown("^5Kill each other !", 3, 1);
        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}
    knife_fail()
    {
        trig = getEnt("knife_fail", "targetname");
        origins = [];
        origins[0] = getEnt("knife_fail_origin_1", "targetname");
        origins[1] = getEnt("knife_fail_origin_2", "targetname");
        origins[2] = getEnt("knife_fail_origin_3", "targetname");
        origins[3] = getEnt("knife_fail_origin_4", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            random_origin = randomInt(origins.size);
            random_teleport = origins[random_origin];
            player setOrigin(random_teleport.origin);
            player setPlayerAngles(random_teleport.angles);
        }
    }
 pure()
    {
        level.trigger_pure = getEnt("trigger_pure", "targetname");
        level.trigger_pure sethintstring("Press ^5[&&1]^7 to enter purestrafe room");
        jumper = getEnt("origin_jumper_pure", "targetname");
        acti = getEnt("origin_acti_pure", "targetname");

        for(;;)
        {
        level.trigger_pure waittill("trigger", player);
        AmbientStop(2);
        AmbientPlay("song6");
        iPrintLnBold("^5" + player.name + " ^7Entered The ^5PureStrafe ^7Room^5!");
        level.activ = GetActivator();
        level.pure_jumper = player;
        player thread waitdead();
        thread fightHUD("PureStrafe Room", player, level.activ);
        player setOrigin (jumper.origin);
        player setPlayerAngles (jumper.angles);
        level.activ setOrigin (acti.origin);
        level.activ setPlayerAngles (acti.angles);
        player takeAllWeapons();
        level.activ takeAllWeapons();
        player giveWeapon("beretta_mp");
        level.activ giveWeapon("beretta_mp");
        player switchtoweapon("beretta_mp");
        level.activ switchtoweapon("beretta_mp");
        player thread RoomCountDown("^5Strafe to the end to win!", 3, 1);
        level.activ thread RoomCountDown("^5Strafe to the end to win!", 3, 1);
        while(isDefined(player) && isAlive(player))
        wait .05;
        player = undefined;
        level.pure_jumper = undefined;
        level.activ = undefined;
        }
    }
    pure_finish()
    {
    trig = getEnt("trigger_pure_finish", "targetname");
    winner = getEnt("origin_pure_winner", "targetname");
    loser = getEnt("origin_pure_loser", "targetname");

    while (1)
    {
        trig waittill("trigger", player);

        if (player == level.pure_jumper)
        {
            // Jumper finished first
            level.pure_jumper freezeControls(1);
            level.pure_jumper setOrigin(winner.origin);
            level.pure_jumper setPlayerAngles(winner.angles);

            iPrintLn("Jumper:^5 " + level.pure_jumper.name + " ^7won the race!");
            level.activ iPrintLnBold("^1You lost the race");

            level.activ freezeControls(1);
            level.activ setOrigin(loser.origin);
            level.activ setPlayerAngles(loser.angles);

            wait 2;
            level.pure_jumper freezeControls(0);
            level.pure_jumper giveMaxAmmo("beretta_mp");
            wait 0.1;
        }
        else if (player == level.activ)
        {
            // Activator finished first
            level.activ freezeControls(1);
            level.activ setOrigin(winner.origin);
            level.activ setPlayerAngles(winner.angles);

            iPrintLn("Activator: ^5 " + level.activ.name + " ^7won the race!");
            level.pure_jumper iPrintLnBold("^1You lost the race");

            level.pure_jumper freezeControls(1);
            level.pure_jumper setOrigin(loser.origin);
            level.pure_jumper setPlayerAngles(loser.angles);

            wait 2;
            level.activ freezeControls(0);
            level.activ giveMaxAmmo("beretta_mp");
            wait 0.1;
        }
        else
        {
            iPrintLnBold("^1Error: Unknown player triggered the finish!");
        }
    }
}
rpg()
{
    level.trigger_rpg = getEnt ("trigger_rpg", "targetname");
	level.trigger_rpg setHintString("Press ^5[&&1]^7 to enter rpg room");
    jumperrpg = getEnt ("origin_jumper_rpg", "targetname");
    actirpg = getEnt ("origin_acti_rpg", "targetname");

    for(;;)
    {
        level.trigger_rpg waittill ("trigger", player, activator);
        room_music();
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
        //player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}
 teleport_rpg()
    {
        trig = getEnt("rpg_fail", "targetname");
        jumper = getEnt("jumper_rpg_fail_origin", "targetname");
        acti = getEnt("acti_rpg_fail_origin", "targetname");

        for(;;)
        {
            trig waittill("trigger", player);
            if(player.team == "axis"){
                player setOrigin(acti.origin);
                player setPlayerAngles(acti.angles);
            }
            else{
                player setOrigin(jumper.origin);
                player setPlayerAngles(jumper.angles);
            }

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
        room_music();

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
        //player giveWeapon("iw8_butterflyknife_mp");
        //activator giveWeapon("iw8_butterflyknife_mp");
        player giveWeapon("h1_karambit_mp");
        activator giveWeapon("h1_karambit_mp");
        player switchtoweapon("h1_karambit_mp");
        activator switchtoweapon("h1_karambit_mp");
        //player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread RoomCountDown("^5Get to the end and kill each other !", 3, 1);
        activator thread RoomCountDown("^5Get to the end and kill each other !", 3, 1);
        while(isDefined(player) && isAlive(player))
        wait .05;
    }
}
    bounce_sniper()
{
    trig = getEnt("bounce_sniper", "targetname");
    trig setHintString("Press ^5[&&1]^7 to get the weapon!");
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
bounce_jumper_fail()
{
    trig = getEnt("bounce_jumper_fail", "targetname");
    tele = getEnt("bounce_jumper_fail_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player iprintlnbold("You failed... try again!");
        player setPlayerAngles(tele.angles);
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
        player iprintlnbold("You failed... try again!");
        player setPlayerAngles(tele.angles);
    }
}
//secrets
secret_raky()
{
    trig = getEnt("secret_raky", "targetname");
    trig setHintString("Press ^5[&&1]^7 for a free vip on XM!");
    tele = getEnt("secret_raky_origin", "targetname");
    awljkmf = undefined;
    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        iprintlnBold("^5" +player.name+ " ^7tried to get an ^5xM VIP ^7for free... laugh at him in the chat");
        if(!isDefined(awljkmf)) {
            awljkmf = true;
            player iprintLnBold("We're not on xM ^5RETARD^7... have some xp instead");
            player braxi\_rank::giveRankXP("", 1000);
        }
        player freezecontrols(1);
        wait 1;
        player freezecontrols(0);
    }
}
practise()
{
    trig = getEnt("practise", "targetname");
    trig setHintString("Press ^5[&&1]^7 to enter the bounce practise room!");
    tele = getEnt("practise_origin", "targetname");
    for(;;)
        {
        trig waittill("trigger", player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
        player iprintlnbold("Welcome to the bounce practise room!");
        }
}
practise_fail()
{
    trig = getEnt("practise_fail", "targetname");
    tele = getEnt("practise_fail_origin", "targetname");
    for(;;)
        {
        trig waittill("trigger", player);
        player Suicide();
        }
}
practise_exit()
{
    trig = getEnt("practise_exit", "targetname");
    trig setHintstring("Press ^5[&&1]^7 to go back to the map");
    tele = getEnt("practise_exit_origin", "targetname");

    wait 0.1;

    trig delete();
}
practise_finish()
{
    trig = getEnt("practise_finish", "targetname");
    tele = getEnt("practise_finish_origin", "targetname");
    for(;;)
        {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_2");
        }
}
secret_choice()
    {
    trig = getEnt("secret_choice", "targetname");
    tele = getEnt("secret_choice_origin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player iprintlnbold("Welcome to the ^5secret ^7room! Choose the secret you wanna take on");
        player setOrigin(tele.origin);
        player setplayerAngles(tele.angles);

    }
    }
hell_secret()
    {
        trig = getEnt("hell_secret", "targetname");
        tele = getEnt("hell_secret_origin", "targetname");
        trig sethintstring("^1HELL ^7secret");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            player iprintlnbold("Welcome to ^1HELL ^7secret... you only have one try");
            wait 1;
            player freezecontrols(0);
            player iprintlnbold("If you complete it, you're insane... ^5GOOD LUCK^7!");
        }
    }
      hell_secret_fail()
    {
    trig = getEnt("hell_secret_fail", "targetname");
    tele = getEnt("hell_secret_fail_origin", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player Suicide();
    }
    }
    hell_secret_finish()
    {
        trig = getEnt("hell_secret_finish", "targetname");
        tele = getEnt("hell_secret_finish_origin", "targetname");
        for(;;)
            {
                trig waittill("trigger", player);
                player thread sr\api\_speedrun::finishWay("secret_1");
            }
    }
    ice_secret()
	{
	trig = getEnt("ice_secret", "targetname");
        tele = getEnt("ice_secret_origin", "targetname");
        trig sethintstring("^5ICE ^7secret (hard difficulty)");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            player iprintlnbold("Welcome to ^5ICE ^7secret!");
            player thread startDeathTimer(120);
            wait 1;
            player freezecontrols(0);
            player iprintlnbold("^5GOOD LUCK^7!");
        }
	}
    ice_secret_finish()
    {
        trig = getEnt("ice_secret_finish", "targetname");
        tele = getEnt("ice_secret_finish_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
           player thread sr\api\_speedrun::finishWay("secret_0");
        }
    }
    fail1()
    {
        trig = getEnt("fail1", "targetname");
        tele = getEnt("fail1_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    fail2()
    {
        trig = getEnt("fail2", "targetname");
        tele = getEnt("fail2_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    fail3()
    {
        trig = getEnt("fail3", "targetname");
        tele = getEnt("fail3_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }

    fail4()
    {
        trig = getEnt("fail4", "targetname");
        tele = getEnt("fail4_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    fail5()
    {
        trig = getEnt("fail5", "targetname");
        tele = getEnt("fail5_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    fail6()
    {
        trig = getEnt("fail6", "targetname");
        tele = getEnt("fail6_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    fail7()
    {
        trig = getEnt("fail7", "targetname");
        tele = getEnt("fail7_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    fail8()
    {
        trig = getEnt("fail8", "targetname");
        tele = getEnt("fail8_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
        fail9()
    {
        trig = getEnt("fail9", "targetname");
        tele = getEnt("fail9_origin", "targetname");
        for(;;)
        {
            trig waittill("trigger", player);
            player freezecontrols(1);
            player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
            wait 0.5;
            player freezecontrols(0);
        }
    }
    tip1()
    {
        trig = getEnt("tip1", "targetname");
        trig setHintString("^532-321");
    }
    tip2()
    {
        trig = getEnt("tip2", "targetname");
        trig setHintString("^532-3");
    }
    tip3()
    {
        trig = getEnt("tip3", "targetname");
        trig setHintString("^532-32");
    }
    tip4()
    {
        trig = getEnt("tip4", "targetname");
        trig setHintString("^5321-321");
    }
    tip5()
    {
        trig = getEnt("tip5", "targetname");
        trig setHintString("^532-23");
    }
    tip6()
    {
        trig = getEnt("tip6", "targetname");
        trig setHintString("^532 slide 32-32");
    }
      tip7()
    {
        trig = getEnt("tip7", "targetname");
        trig setHintString("^5532-3");
    }
      tip8()
    {
        trig = getEnt("tip8", "targetname");
        trig setHintString("^532-3");
    }
      tip9()
    {
        trig = getEnt("tip9", "targetname");
        trig setHintString("^532-323");
    }
    //traps
    trap1()
{
    trig = getEnt("trap1","targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 1!");
    plat1_1 = getEnt("trap1_1", "targetname");
    plat1_2 = getEnt("trap1_2", "targetname");
    trig waittill("trigger", player);
    trig setHintstring("^5Activated!");

while(true)
{
    plat1_1 hide();
    plat1_1 notsolid();
    plat1_2 hide();
    plat1_2 notsolid();
    wait 3;
    plat1_1 show();
    plat1_1 solid();
    plat1_2 show();
    plat1_2 solid();
    wait 3;
}
}
trap2()
{
    ladder1 = getEnt("trap2_1", "targetname");
    ladder2 = getEnt("trap2_2", "targetname");
    trig = getEnt("trap2", "targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 2!");
    trig waittill("trigger", player);
    trig setHintstring("^5Activated!");

    choice = randomint(2); // losuje 0 albo 1

    if (choice == 0)
        ladder1 delete();
    else
        ladder2 delete();
}
 trap3()
{
    plat3_1 = getEnt("trap3_1", "targetname");
    plat3_2 = getEnt("trap3_2", "targetname");
    trig = getEnt("trap3", "targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 3!");
    trig waittill("trigger", player);

    trig setHintstring("^5Activated!");

    choice = randomint(2);

    if (choice == 0)
    {
        plat3_1 delete();
    }
    else
    {
        plat3_2 delete();
    }
}
 trap4()
{
    plat4_1 = getEnt("trap4_1", "targetname");
    plat4_2 = getEnt("trap4_2", "targetname");
    trig = getEnt("trap4", "targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 4!");
    trig waittill("trigger", player);

    trig setHintstring("^5Activated!");

    choice = randomint(2);

    if (choice == 0)
    {
        plat4_1 delete();
    }
    else
    {
        plat4_2 delete();
    }
}
trap5()
{
    plat5_1 = getEnt("trap5_1", "targetname");
    plat5_2 = getEnt("trap5_2", "targetname");
    plat5_3 = getEnt("trap5_3", "targetname");
    trig = getEnt("trap5", "targetname");

    trig sethintstring("Press ^5[&&1]^7 to activate trap 5!");
    trig waittill("trigger", player);
    trig setHintstring("^5Activated!");

    // Pozycje bazowe
    base1 = plat5_1.origin;
    base2 = plat5_2.origin;
    base3 = plat5_3.origin;

    // Pozycje docelowe (w prawo = +x)
    offset = (0, 400, 0);
    target1 = base1 + offset;
    target2 = base2 + offset;
    target3 = base3 + offset;

    for (;;)
    {
        // Ruch do przodu z opóźnieniem
        plat5_1 moveTo(target1, 1);
        wait 0.5;
        plat5_2 moveTo(target2, 1);
        wait 0.5;
        plat5_3 moveTo(target3, 1);

        wait 3; // zatrzymanie w pozycji końcowej

        // Ruch powrotny z opóźnieniem
        plat5_1 moveTo(base1, 1);
        wait 0.5;
        plat5_2 moveTo(base2, 1);
        wait 0.5;
        plat5_3 moveTo(base3, 1);

        wait 5; // pauza przed kolejnym cyklem
    }
}
trap6()
{
    plat6_1 = getEnt("trap6_1", "targetname");
    plat6_2 = getEnt("trap6_2", "targetname");
    trig = getEnt("trap6", "targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 6!");
    trig waittill("trigger", player);
    trig setHintstring("^5Activated!");
    for(;;)
    {
        plat6_1 rotatepitch(-60,0.5);
        plat6_2 rotatepitch(60,0.5);
        wait 2;
        plat6_1 rotatepitch(60,0.5);
        plat6_2 rotatepitch(-60,0.5);
        wait 4;
    }
}
trap7()
    {
    plat7_1 = getEnt("plat7_1", "targetname");
    plat7_2 = getEnt("plat7_2", "targetname");
    trig = getEnt("trap7", "targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 7!");
    trig waittill("trigger", player);
    trig setHintstring("^5Activated!");
    for(;;)
    {
    wait 0.1;
    plat7_1 rotateyaw (360, 1, 0, 0);
    plat7_2 rotateyaw (360, 1, 0, 0);
    }
 }
 trap8()
 {
    plat8_1 = getEnt("trap8_1", "targetname");
    trig = getent("trap8", "targetname");
    trig sethintstring("Press ^5[&&1]^7 to activate trap 8!");
    trig waittill("trigger", player);
    trig setHintstring("^5Activated!");
    for(;;)
    {
        plat8_1 rotateyaw(360,2);
        wait 5;
    }
 }