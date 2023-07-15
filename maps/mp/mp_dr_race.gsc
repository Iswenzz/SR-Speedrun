/*

 /##   /## /##   /##                         /######## /##
| ### | ##|__/  | ##                        | ##_____/|__/
| ####| ## /## /######    /######   /###### | ##       /##  /######   /######
| ## ## ##| ##|_  ##_/   /##__  ## /##__  ##| #####   | ## /##__  ## /##__  ##
| ##  ####| ##  | ##    | ##  \__/| ##  \ ##| ##__/   | ##| ##  \__/| ########
| ##\  ###| ##  | ## /##| ##      | ##  | ##| ##      | ##| ##      | ##_____/
| ## \  ##| ##  |  ####/| ##      |  ######/| ##      | ##| ##      |  #######
|__/  \__/|__/   \___/  |__/       \______/ |__/      |__/|__/       \_______/

   Name : NitroFire
   Scripts by : NitroFire
   Map Name : mp_dr_race
   Steam : david1205red
   [If you plan to use this cringy af script in any way, please give credit where it is due.]

*/

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main() {
	thread sr\api\_defrag::weapons("");
thread sr\api\_map::createSpawnOrigin((-5318, -679, 312), 0);
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    // Fixes and Visual Tweaks
    setDvar("bg_falldamagemaxheight", 300000 );
    setDvar("bg_falldamageminheight", 128000 );
    VisionSetNaked( "mp_dr_race", 0);

    level.knifeTrig = getEnt("knifeEnter", "targetname");
    level.sniperTrig = getEnt("sniperEnter", "targetname");
    level.bounceTrig = getEnt("bounceEnter", "targetname");
	level.playerInRoom = undefined;

    //########################### Threads ###########################\\
    thread sr\api\_speedrun::createNormalWays("Normal Way;");

    thread tools();
    // thread connect();
    // thread music();
    // thread traps();
    thread teleports();
    // thread endRooms();
    //########################### End Threads #######################\\

    //########################### Precache ###########################\\
    precacheItem("knife_mp");
    //########################### End Precache ###########################\\

    level waittill("round_started");
    thread sendMessage("^1>>^7Welcome to ^1mp_dr_race ^7by ^1NitroFire^7!^1<<");
}

connect()
{
    for(;;)
    {
        level waittill("connected",player);
        player thread force_dvar();
	level waittill( "round_started" );
    }
}

force_dvar()
{
    wait 0.05;

        self setClientDvar("dynent_active","1");
        self setClientDvar("r_detail","1");
        self setClientDvar("r_specular","1");
        self setClientDvar("r_normal","1");
        self setClientDvar("r_drawsun","0");
        self setClientDvar("r_blur","0.3");
        self setClientDvar("cg_drawdecals","1");
        self setClientDvar("r_drawdecals","1");

        self setClientDvar("r_lighttweaksunlight","1.3");
        self setClientDvar("r_filmTweakBrightness","0");
        self setClientDvar("r_filmTweakContrast","1.4");
        self setClientDvar("r_filmTweakDarktint","1.3 1.3 1.7");
        self setClientDvar("r_filmTweakDesaturation","0");
        self setClientDvar("r_filmTweakEnable","1");
        self setClientDvar("r_filmTweakLighttint","1.3 1.4 1.5");
        self setClientDvar("r_filmTweakInvert","0");
        self setClientDvar("r_filmUseTweaks","1");
        self setClientDvar("r_lodBiasRigid","-1000");
        self setClientDvar("r_lodBiasSkinned","-1000");

        self setClientDvar("r_contrast","1.1");
        self setClientDvar("r_specularcolorscale","1");
        self setClientDvar("r_gamma","1");
        self setClientDvar("r_desaturation","0");
        self setClientDvar("r_blur","0.3");
}

tools() {
    thread startDoor();
    // thread bottomMessages();
    // thread endMap();
}

startDoor() {
    door = getEnt("startDoor", "targetname");
    trig = getEnt("startTrig", "targetname");
    door delete();
}

bottomMessages() {
    while(1) {
        iPrintLn("^1>>^7Special Thanks to ^1Voidix ^7with the Map's Concept, and Making the Map's Loadscreen.^1<<");
        wait 10;
        iPrintLn("^1>>^7Map Created by ^1NitroFire ^7and ^1SuX Lolz o/^7.^1<<");
        wait 10;
        iPrintLn("^1>>^7Special Thanks to All of the ^0FAM^9OUS ^7Members.^1<<");
        wait 10;
        iPrintLn("^1>>^7Special Thanks to ^1Easy ^7for Helping Debug the Scripts.^1<<");
        wait 10;
        iPrintLn("^1>>^7Thanks to ^1Everyone ^7who Tested the Map.^1<<");
        wait 10;
        iPrintLn("^1>>^7Steam: ^1NitroFire1289^1<<");
        wait 10;
        iPrintLn("^1>>^7Steam: ^Iswenzz^1^1<<");
        wait 10;
        iPrintLn("^1>>^7Join the ^0FAM^9OUS ^7Discord Here: https://discord.gg/FGnjbpS^1<<");
        wait 10;
        iPrintLn("^1>>^7Join the ^1SR ^7Discord Here: https://discord.gg/76aHfGF^1<<");
        wait 10;
        iPrintLn("^1>>^7Map Design by ^1NitroFire^1<<");
        wait 10;
        iPrintLn("^1>>^7Map Textures and Details by ^1SuX Lolz o/^1<<");
        wait 10;
    }
}

endMap() {
    jumperTrig = getEnt("jumper_end_map", "targetname");
    actiTrig = getEnt("acti_end_map", "targetname");
    jumperDoor = getEnt("jumperDoor", "targetname");
    actiDoor = getEnt("actiDoor", "targetname");

    thread lol(actiTrig,jumperDoor);

    jumperTrig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 500 );
    actiDoor moveZ(-200, 1);
    iPrintLnBold("^1>>^7The ^1Jumpers ^7have Won the Race!^1<<");
}

lol(actiTrig,jumperDoor)
{
    actiTrig waittill("trigger", player);
    jumperDoor moveZ(-200, 1);
    iPrintLnBold("^1>>^7The ^1Activator ^7has Won the Race!^1<<");
}

traps() {
    thread killJumpers();
}

killJumpers() {
    trig = getEnt("killJumpers", "targetname");
    trig setHintString("^1>>^7Press ^1[^7Use^1] ^7to ^1Kill ^7the ^1Jumpers^7!^1<<");
    trig waittill("trigger", player);
    //playerArray = getEntArray("player", "classname");

    if(player.pers["team"] == "axis") {
		player braxi\_rank::giveRankXP( "", 500 );
        for(i = 0; i < level.jumper.size; i++) {
             level.jumper[i] suicide();
        }

        iPrintLnBold("The Activator has Won the Race.");
        trig delete();
    } else {
        player iPrintLnBold("You are not an Activator.");
    }
}

music() {
 // thread initMusic();
//  thread musictrig();
 // thread secretSongs();
}

initMusic() {

        level.music = [];

    i = 0;
        level.music[i]["artist"] = "Lucian & Remmi";
        level.music[i]["title"] = "Bobby K";
        level.music[i]["alias"] = "song1";

        i++;
        level.music[i]["artist"] = "Rusko";
        level.music[i]["title"] = "Somebody To Love (Sigma Remix)";
        level.music[i]["alias"] = "song2";

        i++;
        level.music[i]["artist"] = "Unknown Brain";
        level.music[i]["title"] = "Separate Ways";
        level.music[i]["alias"] = "song3";

        i++;
        level.music[i]["artist"] = "Trivecta";
        level.music[i]["title"] = "Labyrinth (ft. Miyoki)";
        level.music[i]["alias"] = "song4";

        i++;
        level.music[i]["artist"] = "Seven Lions";
        level.music[i]["title"] = "Silent Skies (ft. Karra)";
        level.music[i]["alias"] = "song5";

        precacheShader( "black" );
        precacheShader( "white" );
}

musicMenu() {

    self endon( "death" );

    self thread onDeath();
    self thread onDisconnect();

    self.hud_music = [];
    self.selection = 0;

    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "black", 320, 160 );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
    self.hud_music[i].sort = 883;
    self.hud_music[i] setText( "^1>> ^7Music Menu ^1<<" );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText( "^1>> ^7Select a Song ^1<<" );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
    self.hud_music[i].sort = 885;
    self.hud_music[i] setText( "^1>> Press ^^1[^7USE^1]^7: ^^7Play ^7Song ^1<<" );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;

    for( j = 0; j < level.music.size; j++ ) {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";

        entry = level.music[j];
        self.hud_music[i] setText( entry["artist"] + " ^2-^7 " + entry["title"] );
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );

    while( 1 ) {
        wait 0.1;

        if( self attackButtonPressed() )
        {
            self.hud_music[5+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[5+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if( self useButtonPressed() ) {
            iPrintln( "^5Now playing: ^7" + level.music[self.selection]["artist"]+" - ^2" +level.music[self.selection]["title"] );

            ambientPlay( level.music[self.selection]["alias"], 3 );
            self freezeControls(0);
            level notify ( "song_picked" );
            self braxi\_rank::giveRankXp( "trap_activation" );
            break;
        }
        else if( self meleeButtonPressed() ) {
            self freezeControls(0);
            break;
        }
    }

    self cleanUpMusic();
}

musictrig() {
    trigger = getEnt ( "musicTrig", "targetname" ); //musicmenu is the trigger to pick songs
    trigger setHintString( "^1>>^7Press ^1[^7USE^1] ^7to Choose ^1Music^7!^1<<" );

    trigger waittill( "trigger", player );
    trigger delete();
    level endon ( "song_picked" );
    player thread musicMenu();
    player freezeControls(1);
}

onDeath() {
    self endon( "disconnect" );
    self endon( "music thread terminated" );
    self waittill( "death" );
    self cleanUpMusic();
}

onDisconnect() {
    self endon( "music thread terminated" );
    self waittill( "disconnect" );
    self cleanUpMusic();
}

cleanUpMusic() {
    if( !isDefined( self ) )
        return;

    if( isDefined( self.hud_music ) )
    {
        for( i = 0; i < self.hud_music.size; i++ )
        {
            if( isDefined( self.hud_music[i] ) )
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

teleports() {
    entTransporter = getentarray( "actiReturn01", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturn02", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturn03", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturn04", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturn05", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturn06", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturn07", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }

    entTransporter = getentarray( "actiReturnMissed", "targetname" );
    if(isdefined(entTransporter)){
        for( i = 0; i < entTransporter.size; i++ ) {
            entTransporter[i] thread transporter();
        }
    }
}

endRooms() {
   // thread knifeRoom();
   // thread sniperRoom();
   // thread bounceRoom();
    // thread weapon_bounceroom();
    // thread respawn_bounceroom();
}

respawn_bounceroom()
{
    trig = getEnt("bounceReturn","targetname");
    o_acti = getEnt("bounceOriginA","targetname");
    o_jump = getEnt("bounceOriginJ","targetname");

    for(;;)
    {
        trig waittill("trigger",player);

        if(isDefined(level.activ) && player == level.activ)
        {
            player setOrigin(o_acti.origin);
            player setPlayerAngles(o_acti.angles);

            player thread short_freeze();
        }
        else
        {
            player setOrigin(o_jump.origin);
            player setPlayerAngles(o_jump.angles);

            player thread short_freeze();
        }
    }
}

short_freeze()
{
    self endon("death");
    self endon("disconnect");

    self freezeControls(1);
    wait 0.05;
    self freezeControls(0);
}

weapon_bounceroom()
{
    weaponTrig = getEnt("bounceWeapon", "targetname");
    weaponTrig setHintString("^1>>^7Press ^1[^7Use^1] ^7to Recieve an ^1M40A3^7!^1<<");

    for(;;) {
        weaponTrig waittill("trigger", player);

        player TakeAllWeapons();
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo();
        player switchToWeapon("m40a3_mp");
        player.kys = true;
        wait 0.5;
    }
}

knifeRoom() {
    jumper = getEnt("knifeOriginJ", "targetname");
    activator = getEnt("knifeOriginA", "targetname");
    level.knifeTrig = getEnt("knifeEnter", "targetname");
    // level.knifeTrig setHintString("^1>>^7Press ^1[^7Use^1] ^7to Enter the ^1Knife ^7Room!^1<<");
	level.knifeTrig waittill("trigger", player);
	thread room_song("knife");
	while(1)
	{
		level.knifeTrig waittill("trigger", player);
			if(level.playerInRoom == undefined) {
				level.playerInRoom = player;

				level.bounceTrig delete();
				level.sniperTrig delete();

				level.playerInRoom setOrigin(jumper.origin);
				level.playerInRoom SetPlayerAngles(jumper.angles);

				level.activ setOrigin(activator.origin);
				level.activ SetPlayerAngles(activator.angles);

				level.playerInRoom TakeAllWeapons();
				level.activ TakeAllWeapons();

				level.playerInRoom giveWeapon("knife_mp");
				level.playerInRoom switchToWeapon("knife_mp");
				level.activ giveWeapon("knife_mp");
				level.activ switchToWeapon("knife_mp");

				level.playerInRoom FreezeControls(1);
				level.activ FreezeControls(1);

				thread sendMessage("^1>>^7" + level.playerInRoom.name + " has Entered the ^1Knife ^7Room!^1<<");
				wait 0.5;
				iPrintLnBold("^23");
				wait 1;
				iPrintLnBold("^32");
				wait 1;
				iPrintLnBold("^11");
				wait 1;
				iPrintLnBold("^5Fight!");

				level.playerInRoom FreezeControls(0);
				level.activ FreezeControls(0);

				while(isAlive(level.playerInRoom) && isDefined(level.playerInRoom)) {
					wait 1.5;
					if(!isAlive(level.playerInRoom) && self.pers["team"] == "allies") {
						iPrintLnBold(level.playerInRoom.name + " has ^1Died^7!");
						level.playerInRoom = undefined;
					}
					level.knifeTrig waittill("trigger", player);
					player iPrintLnBold("^1Wait ^7Your ^1Turn^7!");
				}


		}
	}
}

sniperRoom() {
    jumper = getEnt("sniperOriginJ", "targetname");
    activator = getEnt("sniperOriginA", "targetname");
    level.sniperTrig = getEnt("sniperEnter", "targetname");

    // level.sniperTrig setHintString("^1>>^7Press ^1[^7Use^1] ^7to Enter the ^1Sniper ^7Room!^1<<");
	level.sniperTrig waittill("trigger", player);
	thread room_song("sniper");
	while(1)
	{
		if(level.playerInRoom == undefined) {
			level.sniperTrig waittill("trigger", player);
			level.playerInRoom = player;
			level.knifeTrig delete();
			level.bounceTrig delete();

			level.playerInRoom setOrigin(jumper.origin);
			level.playerInRoom SetPlayerAngles(jumper.angles);

			level.activ setOrigin(activator.origin);
			level.activ SetPlayerAngles(activator.angles);

			level.playerInRoom TakeAllWeapons();
			level.activ TakeAllWeapons();

			level.playerInRoom giveWeapon("m40a3_mp");
			level.playerInRoom giveWeapon("remington700_mp");
			level.playerInRoom giveMaxAmmo("m40a3_mp");
			level.playerInRoom giveMaxAmmo("remington700_mp");
			level.playerInRoom switchToWeapon("m40a3_mp");

			level.activ giveWeapon("m40a3_mp");
			level.activ giveWeapon("remington700_mp");
			level.activ giveMaxAmmo("m40a3_mp");
			level.activ giveMaxAmmo("remington700_mp");
			level.activ switchToWeapon("m40a3_mp");



			level.playerInRoom FreezeControls(1);
			level.activ FreezeControls(1);

			thread sendMessage("^1>>^7" + level.playerInRoom.name + " has Entered the ^1Sniper ^7Room!^1<<");
			wait 0.5;
			iPrintLnBold("^23");
			wait 1;
			iPrintLnBold("^32");
			wait 1;
			iPrintLnBold("^11");
			wait 1;
			iPrintLnBold("^5Fight!");

			level.playerInRoom FreezeControls(0);
			level.activ FreezeControls(0);

			while(isAlive(level.playerInRoom) && isDefined(level.playerInRoom)) {
				wait 1.5;
				if(!isAlive(level.playerInRoom)) {
					iPrintLnBold(level.playerInRoom.name + " has ^1Died^7!");
					level.playerInRoom = undefined;
				}
				level.sniperTrig waittill("trigger", player);
				player iPrintLnBold("^1Wait ^7Your ^1Turn^7!");
			}

		}
	}
}

bounceRoom() {
    jumper = getEnt("bounceOriginJ", "targetname");
    activator = getEnt("bounceOriginA", "targetname");
    level.bounceTrig = getEnt("bounceEnter", "targetname");

    // level.bounceTrig setHintString("^1>>^7Press ^1[^7Use^1] ^7to Enter the ^1Bounce ^7Room!^1<<");
    returnTrig = getEnt("bounceReturn", "targetname");
	level.bounceTrig waittill("trigger", player);
	thread room_song("bounce");
	while(1)
		{
		level.bounceTrig waittill("trigger", player);
		if(level.playerInRoom == undefined) {
			level.playerInRoom = player;

			level.knifeTrig delete();
			level.sniperTrig delete();

			level.playerInRoom setOrigin(jumper.origin);
			level.playerInRoom SetPlayerAngles(jumper.angles);

			level.activ setOrigin(activator.origin);
			level.activ SetPlayerAngles(activator.angles);

			level.playerInRoom TakeAllWeapons();
			level.activ TakeAllWeapons();

			level.playerInRoom giveWeapon("deserteagle_mp");
			level.activ giveWeapon("deserteagle_mp");
			level.playerInRoom setWeaponAmmoClip("deserteagle_mp", 0);
			level.activ setWeaponAmmoClip("deserteagle_mp", 0);
			level.playerInRoom switchToWeapon("deserteagle_mp");
			level.activ switchToWeapon("deserteagle_mp");

			level.playerInRoom thread kys_weapon();
			level.activ thread kys_weapon();


			level.playerInRoom FreezeControls(1);
			level.activ FreezeControls(1);

			thread sendMessage("^1>>^7" + level.playerInRoom.name + " has Entered the ^1Bounce ^7Room!^1<<");
			wait 0.5;
			iPrintLnBold("^23");
			wait 1;
			iPrintLnBold("^32");
			wait 1;
			iPrintLnBold("^11");
			wait 1;
			iPrintLnBold("^5Fight!");

			level.playerInRoom FreezeControls(0);
			level.activ FreezeControls(0);

			while(isAlive(level.playerInRoom) && isDefined(level.playerInRoom)) {
				wait 1.5;
				if(!isAlive(level.playerInRoom)) {
					iPrintLnBold(level.playerInRoom.name + " has ^1Died^7!");
					level.playerInRoom = undefined;
				}
				level.bounceTrig waittill("trigger", player);
				player iPrintLnBold("^1Wait ^7Your ^1Turn^7!");
			}
		}
	}
}

kys_weapon()
{
    self endon("death");
    self endon("disconnect");

    while(isDefined(self))
    {
        if(isDefined(self.kys) && self.kys)
            break;

        wait 0.05;

        self SetWeaponAmmoClip( self getCurrentWeapon(), 0 );
        self SetWeaponAmmoStock( self getCurrentWeapon(), 0 );
    }
}

waitDead() {

    level.bounceTrig triggerOff();
    level.sniperTrig triggerOff();
    level.knifeTrig triggerOff();

    self common_scripts\utility::waittill_any("death", "disconnect");
    level.activ freezeControls(false);

    level.bounceTrig triggerOn();
    level.sniperTrig triggerOn();
    level.knifeTrig triggerOn();
}

room_song(alias)
{
    ambientStop(0);
    wait 0.05;
    ambientPlay(alias);
}

secretSongs() {
    thread aheas();
    thread crazed();
    thread harambe();
    thread soloking();
    thread nitro();
    thread voidix();
}

aheas() {
    self cleanUpMusic();
    level.aheas = getEnt("aheasTrig", "targetname");
    level.aheas waittill("trigger", player );
    ambientStop(0);
    wait 0.05;
  // ambientPlay("aheas");

    iPrintLnBold("^1>>^7" + player.name + " has Turned on ^1Aheas's ^7Secret Song!^1<<");

    // Trigger Delete
    level.nitro delete();
    level.crazed delete();
    level.harambe delete();
    level.soloking delete();
    level.voidix delete();
}

crazed() {
    self cleanUpMusic();
    level.crazed = getEnt("crazedTrig", "targetname");
    level.crazed waittill("trigger", player );
    ambientStop(0);
    wait 0.05;
   // ambientPlay("crazed");

    iPrintLnBold("^1>>^7" + player.name + " has Turned on ^1Crazed's ^7Secret Song!^1<<");

    // Trigger Delete
    level.aheas delete();
    level.nitro delete();
    level.harambe delete();
    level.soloking delete();
    level.voidix delete();
}

harambe() {
    self cleanUpMusic();
    level.harambe = getEnt("harambeTrig", "targetname");
    level.harambe waittill("trigger", player );
    ambientStop(0);
    wait 0.05;
   // ambientPlay("harambe");

    iPrintLnBold("^1>>^7" + player.name + " has Turned on ^1Harambe's ^7Secret Song!^1<<");

    // Trigger Delete
    level.aheas delete();
    level.crazed delete();
    level.nitro delete();
    level.soloking delete();
    level.voidix delete();
}

soloking() {
    self cleanUpMusic();
    level.soloking = getEnt("solokingTrig", "targetname");
    level.soloking waittill("trigger", player );
    ambientStop(0);
    wait 0.05;
   // ambientPlay("soloking");

    iPrintLnBold("^1>>^7" + player.name + " has Turned on ^1Soloking's ^7Secret Song!^1<<");

    // Trigger Delete
    level.aheas delete();
    level.crazed delete();
    level.harambe delete();
    level.nitro delete();
    level.voidix delete();
}

nitro() {
    self cleanUpMusic();
    level.nitro = getEnt("nitroTrig", "targetname");
    level.nitro waittill("trigger", player );
	endtrigwaitt = getEnt("jumper_end_map", "targetname");
    ambientStop(0);
    wait 0.05;
    // ambientPlay("nitro");

    iPrintLnBold("^1>>^7" + player.name + " has Turned on ^1NitroFire's ^7Secret Song!^1<<");

    // Trigger Delete
    level.aheas delete();
    level.crazed delete();
    level.harambe delete();
    level.soloking delete();
    level.voidix delete();

}

voidix() {
    self cleanUpMusic();
    level.nitro = getEnt("voidixTrig", "targetname");
    level.nitro waittill("trigger", player );
    ambientStop(0);
    wait 0.05;
    // ambientPlay("voidix");

    iPrintLnBold("^1>>^7" + player.name + " has Turned on ^1Voidix's ^7Secret Song!^1<<");

    // Trigger Delete
    level.aheas delete();
    level.crazed delete();
    level.harambe delete();
    level.soloking delete();
    level.nitro delete();
}

transporter() { // non
    for(;;) {
        self waittill("trigger", player);
		entTarget = getEnt(self.target, "targetname");
		wait 0;
		player setOrigin(entTarget.origin);
		player setplayerangles(entTarget.angles);
		wait 0;
    }
}

/*
  * @param msg - Enter the message you would like to be printed
*/
sendMessage(msg) {
  players = getentarray("player" , "classname");

    noti = SpawnStruct();
    noti.titleText = msg;
    noti.duration = 5;
    noti.glowcolor = (1, 0, 0);

    for(i=0; i<players.size; i++) {
    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(noti);
  }
}