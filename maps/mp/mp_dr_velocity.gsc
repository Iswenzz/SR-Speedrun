#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK/LENTAVA
///(C) 2024/2025 ALL RIGHTS RESERVED TO ERYK/LENTAVA
///NEED A COD4 MAP? CONTACT ME ON DISCORD: lentavakalakukko

main() {

	//setDvar("scr_fog_disable", 1);
	maps\mp\_load::main();
	maps\mp\mp_dr_velocity_fx::main();
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
	//setdvar("r_specular" , "1");
	//setdvar("r_drawDecals" , "1");
	//setdvar("SetMoveSpeedScale" , "1.12");
	//setdvar("ui_hud_hardcore" , "1");

    thread sr\api\_map::createSpawn((1330,-4088, -1276), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Acti Secret;");

    thread sr_acti_sec_enter();


	//thread sniper();
	//thread ak();
	//thread antiglitcher();
	//thread vlctaccess();
	//thread eryk();
	//thread select();
	//thread bonus_exp1();
	//thread bonus_exp1_tp();
	//thread endmap();
	//thread credits();
	//thread credits2();
	//thread music();
	//thread endroom_tp();
	//thread acti_secret();
	thread acti_secret_fail1();
	thread acti_secret_finish();
	//thread bonus_exp2();
	//thread velocity();
	//thread trigger_water_setup();
	//thread midair();
	//thread ele_secret_start();
	//thread ele_secret_end();
	//thread skeletons();
	//thread acti_tp1();
	//thread acti_tp2();
	//thread good();
	//thread ui_hud_hc();

	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();



	addTriggerToList("trigger_trap1");
	addTriggerToList("trigger_trap2");
	addTriggerToList("trigger_trap3");
	addTriggerToList("trigger_trap4");
	addTriggerToList("trigger_trap5");
	addTriggerToList("trigger_trap6");
	addTriggerToList("trigger_trap7");
	addTriggerToList("trigger_trap8");


	precacheitem("h1_karambit_mp");
	precacheitem("iw8_butterflyknife_mp");
	precacheitem("iw6_honeybadger_mp");
	precachemodel("mp_body_codo_cyberfemale");
	precachemodel("vh_codo_cyberfemale");
	precachemodel("plr_carl_johnson");


}

sr_acti_sec_enter()
{
	trig = spawn("trigger_radius",(1165.19, -4087.87, -1335.88), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("origin_acti_secret","targetname");

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

	iPrintln("^5"+self.name+" ^7died^5!");
	wait 0.2;
	iPrintlnBold("^5Room selection opened^7!");
}

sniper()
{
    level.trigger_scope = getEnt ("trigger_sniper", "targetname");
	level.trigger_scope setHintString("Press ^5[&&1]^7 to enter scope room");
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

        while(isDefined(player) && isAlive(player))
        wait .05;

    }
}

ak()
{
    level.trigger_weapon = getEnt ("trigger_weapon", "targetname");
	level.trigger_weapon setHintString("Press ^5[&&1]^7 to enter Weapon room");

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
		player giveWeapon("deserteagle_mp");
        activator giveWeapon("deserteagle_mp");
        player giveMaxAmmo("deserteagle_mp");
        activator giveMaxAmmo("deserteagle_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

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
            iPrintLnBold("^5Lentava^7 is here.");
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
   	player giveWeapon("t6_evoskorpion_mp");
  	player SwitchToWeapon("t6_evoskorpion_mp");
	player GiveMaxAmmo("dt6_evoskorpion_mp");
	wait 1;
	player giveWeapon("h1_karambit_mp");
	player switchToWeapon("h1_karambit_mp");
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
		bounce = getent("brush1_trap1" , "targetname");
		trig = getent("trigger_trap1" , "targetname");
		trig SetHintString("^1Move bounce up and down^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce movez (-400, 2, 0, 0);
		wait 3;
		bounce movez (400, 2, 0, 0);
		wait 3;
		}
	}

trap2()
	{
		bounce = getent("brush1_trap2" , "targetname");
		trig = getent("trigger_trap2" , "targetname");
		trig SetHintString("^1Move bounce up and down^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		bounce movez (-400, 2, 0, 0);
		wait 3;
		bounce movez (400, 2, 0, 0);
		wait 3;
		}
	}

trap3()
	{
		pillar1 = getent("trap3_pillar1" , "targetname");
		pillar2 = getent("trap3_pillar2" , "targetname");
		pillar3 = getent("trap3_pillar3" , "targetname");
		pillar4 = getent("trap3_pillar4" , "targetname");
		pillar5 = getent("trap3_pillar5" , "targetname");
		pillar6 = getent("trap3_pillar6" , "targetname");
		pillar7 = getent("trap3_pillar7" , "targetname");
		pillar8 = getent("trap3_pillar8" , "targetname");
		pillar9 = getent("trap3_pillar9" , "targetname");
		pillar10 = getent("trap3_pillar10" , "targetname");
		pillar11 = getent("trap3_pillar11" , "targetname");
		pillar12 = getent("trap3_pillar12" , "targetname");
		pillar13 = getent("trap3_pillar13" , "targetname");
		pillar14 = getent("trap3_pillar14" , "targetname");
		pillar15 = getent("trap3_pillar15" , "targetname");

		t1 = getent("hurt1" , "targetname");
		t2 = getent("hurt2" , "targetname");
		t3 = getent("hurt3" , "targetname");
		t4 = getent("hurt4" , "targetname");
		t5 = getent("hurt5" , "targetname");
		t6 = getent("hurt6" , "targetname");
		t7 = getent("hurt7" , "targetname");
		t8 = getent("hurt8" , "targetname");
		t9 = getent("hurt9" , "targetname");
		t10 = getent("hurt10" , "targetname");
		t11 = getent("hurt11" , "targetname");
		t12 = getent("hurt12" , "targetname");
		t13 = getent("hurt13" , "targetname");
		t14 = getent("hurt14" , "targetname");
		t15 = getent("hurt15" , "targetname");

		trig = getent("trigger_trap3" , "targetname");
		trig SetHintString("^1Smash players with pillars^7");
		trig waittill("trigger" , player);


		t1 enablelinkto();
		t2 enablelinkto();
		t3 enablelinkto();
		t4 enablelinkto();
		t5 enablelinkto();
		t6 enablelinkto();
		t7 enablelinkto();
		t8 enablelinkto();
		t9 enablelinkto();
		t10 enablelinkto();
		t11 enablelinkto();
		t12 enablelinkto();
		t13 enablelinkto();
		t14 enablelinkto();
		t15 enablelinkto();

		t1 linkto(pillar1);
		t2 linkto(pillar2);
		t3 linkto(pillar3);
		t4 linkto(pillar4);
		t5 linkto(pillar5);
		t6 linkto(pillar6);
		t7 linkto(pillar7);
		t8 linkto(pillar8);
		t9 linkto(pillar9);
		t10 linkto(pillar10);
		t11 linkto(pillar11);
		t12 linkto(pillar12);
		t13 linkto(pillar13);
		t14 linkto(pillar14);
		t15 linkto(pillar15);

		trig delete();

		for(;;)
		{
		wait 1;
		pillar1 movex (160, 2, 0, 0);
		pillar2 movex (160, 2, 0, 0);
		pillar3 movex (160, 2, 0, 0);
		pillar4 movex (160, 2, 0, 0);
		pillar5 movex (160, 2, 0, 0);
		pillar6 movex (160, 2, 0, 0);
		pillar7 movex (160, 2, 0, 0);
		pillar8 movex (160, 2, 0, 0);
		pillar9 movex (160, 2, 0, 0);
		pillar10 movex (160, 2, 0, 0);
		pillar11 movex (160, 2, 0, 0);
		pillar12 movex (160, 2, 0, 0);
		pillar13 movex (160, 2, 0, 0);
		pillar14 movex (160, 2, 0, 0);
		pillar15 movex (160, 2, 0, 0);

		wait 3;
		pillar1 movex (-160, 2, 0, 0);
		pillar2 movex (-160, 2, 0, 0);
		pillar3 movex (-160, 2, 0, 0);
		pillar4 movex (-160, 2, 0, 0);
		pillar5 movex (-160, 2, 0, 0);
		pillar6 movex (-160, 2, 0, 0);
		pillar7 movex (-160, 2, 0, 0);
		pillar8 movex (-160, 2, 0, 0);
		pillar9 movex (-160, 2, 0, 0);
		pillar10 movex (-160, 2, 0, 0);
		pillar11 movex (-160, 2, 0, 0);
		pillar12 movex (-160, 2, 0, 0);
		pillar13 movex (-160, 2, 0, 0);
		pillar14 movex (-160, 2, 0, 0);
		pillar15 movex (-160, 2, 0, 0);
		wait 30;
		}
	}




trap4()
	{
		platform = getent("brush1_trap4" , "targetname");
		trig = getent("trigger_trap4" , "targetname");
		trig SetHintString("^1Move platforms A, C^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		platform movez (-120, 2, 0, 0);
		wait 3;
		platform movez (120, 2, 0, 0);
		wait 10;
		}
	}

trap5()
	{
		platform = getent("brush1_trap5" , "targetname");
		trig = getent("trigger_trap5" , "targetname");
		trig SetHintString("^1Move platforms B, D^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		platform movez (-120, 2, 0, 0);
		wait 3;
		platform movez (120, 2, 0, 0);
		wait 9;
		}
	}

trap6()
	{
		platform1 = getent("brush1_trap6" , "targetname");
		platform2 = getent("brush2_trap6" , "targetname");
		trig = getent("trigger_trap6" , "targetname");
		trig SetHintString("^1Rotate platforms B, C^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		platform1 rotateyaw (360, 1.5, 0, 0);
		platform2 rotateyaw (360, 1.5, 0, 0);
		wait 2;
		platform1 rotateyaw (-360, 1, 0, 0);
		platform2 rotateyaw (-360, 1, 0, 0);
		wait 5;
		}
	}

trap7()
	{
		platform1 = getent("brush1_trap7" , "targetname");
		platform2 = getent("brush2_trap7" , "targetname");
		trig = getent("trigger_trap7" , "targetname");
		trig SetHintString("^1Rotate platforms A, D^7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		platform1 rotateyaw (-360, 1.5, 0, 0);
		platform2 rotateyaw (-360, 1.5, 0, 0);
		wait 2;
		platform1 rotateyaw (360, 1, 0, 0);
		platform2 rotateyaw (360, 1, 0, 0);
		wait 5;
		}
	}

trap8()
	{
		platform = getent("brush1_trap8" , "targetname");
		trig = getent("trigger_trap8" , "targetname");
		trig SetHintString("^1Rotate rusty platform7");
		trig waittill("trigger" , player);
		trig delete();
		for(;;)
		{
		wait 1;
		platform rotateyaw (-360, 1.5, 0, 0);
		wait 2;
		platform rotateyaw (-360, 3, 0, 0);
		wait 5;
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
		iPrintln("^5T^7hanks to:");
		wait 0.5;
		iPrintln("^5C^7lippy for tips");
		wait 0.5;
		iPrintln("^5S^7loth for custom models");
		wait 0.5;
		iPrintln("^5M^7ap made for ^5Velocity Deathrun^7: SERVER IP");
		wait 30;
        }


}

credits2()
{
	trig = getent("trigger_credits" , "targetname");
	trig setHintString("Show Credits");
	trig waittill("trigger" , player);
	iPrintLnBold("Map made by vlct' eryk/lentava");
	wait 1;
	iPrintLnBold("^7Join ^5Velocity Discord^7 server: ^5https://discord.gg/vlctdr^7");
	player giveWeapon("h1_karambit_mp");
	player switchToWeapon("h1_karambit_mp");
}


bonus_exp1()
{
    trig = getEnt("trigger_secret", "targetname");
    trig waittill("trigger", player);
	tele = getEnt("origin_secret", "targetname");

    iPrintLnBold("^5" + player.name + " found bonus XP!^7");
    player braxi\_rank::giveRankXP("", 4000);

    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++)
    {
        if (isDefined(players[i]))
        {
			players[i] playLocalSound("impact");
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		wait 0.05;
		player freezeControls(0);
		player giveWeapon("h1_karambit_mp");
		player switchToWeapon("h1_karambit_mp");
		player iPrintLnBold("Karambit and Cyber Female made by SadSlothXL");
		player detachAll();
		player setModel("mp_body_codo_cyberfemale");
		player setViewModel("vh_codo_cyberfemale");
        }
    }
}

bonus_exp1_tp()
{
	trig = getEnt("trigger2_secret", "targetname");
	tele = getEnt("origin2_secret", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player freezeControls(1);
		wait 0.05;
		player freezeControls(0);
		player giveWeapon("h1_karambit_mp");
		player switchToWeapon("h1_karambit_mp");
		player iPrintLnBold("Karambit made by SadSlothXL");
	}
}


music()
{
    level.music = randomint(6);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "song1" );
	 iPrintLN("Song name: Celldweller - Shapeshifter");
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "song2" );
	 iPrintLN("Song name: Plutonium 74 - Ruisleipää ja lakipykäliä");
     break;
      case 2:
	        AmbientStop(2);
     AmbientPlay( "song3" );
	 iPrintLN("Song name: Rise Against - Give It All");
     break;
      case 3:
	        AmbientStop(2);
     AmbientPlay( "song4" );
	 iPrintLN("Song name: KARAS/ROGUCKI - Film");
     break;
	 case 4:
	 	     AmbientStop(2);
     AmbientPlay( "song5" );
	 iPrintLN("Song name: Mariliyn Manson - mOBSCENE");
     break;
	 case 5:
	 	     AmbientStop(2);
     AmbientPlay( "song6" );
	 iPrintLN("Song name: Killradio - Scavenger");
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



acti_secret()

{
	trig = getEnt("trigger_acti_secret", "targetname");
	tele = getEnt("origin_acti_secret", "targetname");
	trig setHintString("Press [&&1] to enter training room");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player giveWeapon("h1_karambit_mp");
		player switchToWeapon("h1_karambit_mp");
		player iPrintLnBold("Karambit made by SadSlothXL");
	}
}

acti_secret_fail1()

{
	trig = getEnt("trigger_acti_secret_fail2", "targetname");
	tele = getEnt("origin_acti_secret_fail", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

acti_secret_finish()

{
	trig = getEnt("trigger_acti_secret_end", "targetname");
	tele = getEnt("origin_acti_secret_back", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}


}

bonus_exp2()
{
    trig = getEnt("trigger_secret2", "targetname");
    trig waittill("trigger", player);

    iPrintLnBold("^5" + player.name + " found the second bonus exp!^7");
    player braxi\_rank::giveRankXP("", 4000);

}

velocity()
{
	boat1 = getent("logo_velocity" , "targetname");
	boat2 = getent("logo_velocity2" , "targetname");

	while(1)

	{
	boat1 moveZ (-300, 3, 0.5, 0.5);
	boat2 moveZ (-300, 3, 0.5, 0.5);
	wait 3.05;
	boat1 moveZ (300, 3, 0.5, 0.5);
	boat2 moveZ (300, 3, 0.5, 0.5);
	wait 3.05;
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
        self.water_overlay destroy();
    }
}


midair()

{
	trig = getEnt("trigger_midair", "targetname");
	tele = getEnt("origin_midair", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
	}
}

ele_secret_start()

{
	trig = getEnt("trigger_ele_start", "targetname");
	tele = getEnt("origin_ele_start", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
	}
}


ele_hud(message)
{
    eleEnd = newHudElem();
    eleEnd.foreground = true;
    eleEnd.alpha = 1;
    eleEnd.alignX = "left";
    eleEnd.alignY = "middle";
    eleEnd.horzAlign = "left";
    eleEnd.vertAlign = "middle";
    eleEnd.x = -400;
    eleEnd.y = 0;
    eleEnd.sort = 0;
    eleEnd.font = "default";
    eleEnd.fontScale = 1.4;
    eleEnd.hidewheninmenu = false;
    eleEnd.glowAlpha = 1;
    eleEnd.glowColor = (.3,.0,3);
    eleEnd settext(message);
    eleEnd moveOverTime(2);
    eleEnd.x = 5;
    wait 5;
    eleEnd moveOverTime(2);
    eleEnd.x = -500;
    wait 7;
    eleEnd destroy();
}
ele_secret_end()

{
	trig = getEnt("trigger_ele_end", "targetname");
	tele = getEnt("origin_ele_end", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player braxi\_rank::giveRankXP("", 1000);
		wait 0.2;
		player freezeControls(0);
//		iPrintLnBold("^5" + player.name + "^7 has finished the ELEVATOR secret!");
		thread ele_hud("^5" + player.name + "^7 has finished the ELEVATOR secret!");


		player giveWeapon("iw8_butterflyknife_mp");
		player switchToWeapon("iw8_butterflyknife_mp");
		player iPrintLnBold("Butterfly knife made by SadSlothXL");
		player detachAll();
		player setModel("plr_carl_johnson");
	}


}

skeletons()
{
	trig = getent("trigger_skeletons" , "targetname");
	trig waittill ("trigger", player);
	iPrintlnBold("^5" + player.name + " has just changed the ambient.^7");
	      AmbientStop(2);
	AmbientPlay ( "skeletons" );
	iPrintLN("Song name: Travis Scott - Skeletons");
//	break;
	trig delete();
}


acti_tp1()

{
	trig = getEnt("trigger_acti_tp_1", "targetname");
	tele = getEnt("origin_acti_tp1", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
	}
}


acti_tp2()

{
	trig = getEnt("trigger_acti_tp2", "targetname");
	tele = getEnt("origin_acti_tp2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
	}
}

good()
{
    trig = getEnt("trigger_good", "targetname");
    trig waittill("trigger", player);

    iPrintLnBold("^5" + player.name + " is good.^7");
    player braxi\_rank::giveRankXP("", 3000);
	trig delete();

}

ui_hud_hc()
{
    trig = getEnt("trigger_ui", "targetname");
    trig waittill("trigger", player);
	// setDvar("ui_hud_hardcore" , "0");
	// setDvar("r_drawDecals" , "1");
}
