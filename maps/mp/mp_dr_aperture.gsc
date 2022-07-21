/*
mp_dr_aperture
Map Made by Elpredatore
Created for Braxi's Deathrun 1.2 mod for CoD4

 /$$$$$$$$ /$$                                     /$$             /$$
| $$_____/| $$                                    | $$            | $$
| $$      | $$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$   /$$$$$$
| $$$$$   | $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$ |____  $$|_  $$_/   /$$__  $$ /$$__  $$ /$$__  $$
| $$__/   | $$| $$  \ $$| $$  \__/| $$$$$$$$| $$  | $$  /$$$$$$$  | $$    | $$  \ $$| $$  \__/| $$$$$$$$
| $$      | $$| $$  | $$| $$      | $$_____/| $$  | $$ /$$__  $$  | $$ /$$| $$  | $$| $$      | $$_____/
| $$$$$$$$| $$| $$$$$$$/| $$      |  $$$$$$$|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$/| $$      |  $$$$$$$
|________/|__/| $$____/ |__/       \_______/ \_______/ \_______/   \___/   \______/ |__/       \_______/
              | $$
              | $$
              |__/

CREDITS:

PORTAL MODELS BY : http://cfgfactory.com/downloads/show/5659df6b4115b

THANK YOU TO VC' BLADE FOR THE MUSIC MENU SCRIPT

	Why are you decompiling my map ? :D
*/

#include braxi\_common;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main()
{
thread sr\api\_map::createSpawnOrigin((-535.875, 504, 0.125), 0);
	maps\mp\_load::main();

 	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0.5);
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	 precacheModel("portal_big_button");
	 precacheModel("portal_button");
	 precacheModel("portal_cake");
	 precacheModel("portal_companion_cube");
	 precacheModel("portal_cube");
	 precacheModel("portal_glados_p1_p1");
	 precacheModel("portal_glados_p1_p2");
	 precacheModel("portal_glados_p2");
	 precacheModel("portal_glados_p3");
	 precacheModel("portal_radio");
	 precacheModel("portal_turret");

	precacheItem("remington700_mp");
	precacheItem("knife_mp");
	precacheItem("tomahawk_mp");
	precacheItem("ak47_mp");
	precacheItem("m40a3_mp");
	precacheItem("saw_mp");

/////////////////////JUMPPADS/////////////////
	setupJumppads();
if( isDefined( level.jumppads ) && level.jumppads.size )
{
for( i = 0 ; i < level.jumppads.size ; i++ )
{
pad = level.jumppads[i];
if( !isDefined( pad ) )
continue;
spawnJumppad( pad.origin , pad.angles , pad.height , pad.radius , pad.dirPos , pad.model , pad.power , pad.sound );

jumppads = getEntArray( "jumppad" , "targetname" );
if( isDefined( jumppads ) && jumppads.size )
{
for( i = 0 ; i < jumppads.size ; i++ )
{
pad = jumppads[i];
if( !isDefined( pad ) )
continue;
pad thread monitorUsage();
}
}
}
}
/////////////////////FX/////////////////
level.smoke = LoadFX ( "smoke/signal_smoke_green" );
level.fire = loadFX("fire/window_fire_large");
/////////////////////MUSIC/////////////////
thread ambient();
thread musicbox();

//put inside the main
level.music=[];
level.music[0]["song"]    = "Mike Shinoda - About You";
level.music[0]["alias"]    ="song1";
level.music[1]["song"]    ="Illenium - gold";
level.music[1]["alias"]    ="song2";
level.music[2]["song"]    ="Illenium - good things fall apart";
level.music[2]["alias"]    ="song3";
level.music[3]["song"]    ="lexxmatiq x sloth - tale";
level.music[3]["alias"]    ="song4";
level.music[4]["song"]    ="post malone - go flex";
level.music[4]["alias"]    ="song5";
level.music[5]["song"]    ="samahta - professional";
level.music[5]["alias"]    ="song6";

/////////////////////MISC/////////////////
thread start();
thread portal();
thread enddoor();
thread endele();
thread roomele();
/////////////////////SECRET/////////////////
thread cakeroom();
/////////////////////TRAPS/////////////////
thread trap1();
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
thread trap7();
/////////////////////INFO/////////////////
thread mapperinfo();
thread credits();
thread text();
/////////////////////TRAP ARRAY [NEEDED]/////////////////
addTriggerToList( "trap1" );
addTriggerToList( "trap2" );
addTriggerToList( "trap3" );
addTriggerToList( "trap4" );
addTriggerToList( "trap5" );
addTriggerToList( "trap6" );
addTriggerToList( "trap7" );
/////////////////////ENDROOMS/////////////////
thread oldfight();
thread knifefight();
thread sniperfight();
thread bouncefight();
thread bounceweapon();
thread bouncerespawn();
thread ammobox1();
thread ammobox2();
thread ammobox3();
thread akfight();
thread mgfight();
thread runner();
thread runnertp();
thread runnerfail();

level.ammoschrot = false;
level.ammoak = false;
level.firstenter = true;
}

//////////////////////////// ENDROOMS ////////
oldfight(){
   	level.old_trig = getEnt( "Old", "targetname");
	level.old_trig setHintString ("^3Old");
	for(;;)
	{
	while( 1 )
    {

		level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
		thread OldTeleport();
		if(level.firstenter==true)
		{
		level.jump_trig delete();
		level.snipe_trig delete();
		level.knife_trig delete();
		level.mg_trig delete();
		level.ak_trig delete();
		level.runner_trig delete();
		level.firstenter=false;
		}


	if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

		iPrintlnBold( " ^7" + player.name + " ^3 HAS OPENED THE OLD WAY^7!" );
		}

	}
}

OldTeleport(){
jumperorigin = getent ("old_origin", "targetname");
level.old_trig = getEnt( "Old", "targetname");

	for(;; )
   {
    level.old_trig waittill("trigger", player);
    player setOrigin(jumperorigin.origin);
	iPrintlnBold( " ^7" + player.name + " ^3 HAS ENTERED THE OLD WAY^7!" );


   }
}

knifefight(){
    level.knife_trig = getEnt( "Knife", "targetname");
    jump = getEnt( "jumper_enter_kniferoom", "targetname" );
    acti = getEnt( "activator_enter_kniferoom", "targetname" );
    level.knife_trig setHintString ("^3Knife");
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.old_trig delete();
		level.jump_trig delete();
		level.mg_trig delete();
		level.ak_trig delete();
		level.runner_trig delete();
		level.firstenter=false;
		}

		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^5" + player.name + " ^3 entered the Knife Room!" );
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		iPrintLnBold("^7Knife Room is now Open!");
		player = undefined;
    }
}

sniperfight(){
    level.snipe_trig = getEnt( "sniperoom", "targetname");
    jump = getEnt( "jumpsnipe", "targetname" );
    acti = getEnt( "actisnipe", "targetname" );
    level.snipe_trig setHintString ("^3Snipe");
    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;

		if(level.firstenter==true)
		{
		level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.mg_trig delete();
		level.ak_trig delete();
		level.runner_trig delete();
		level.firstenter=false;
		}
        iPrintlnBold( " ^5" + player.name + " ^3 entered the Sniper Room^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
		level.activ TakeAllWeapons();
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
		iprintlnbold ( "^33" );
		wait 1;
        player GiveWeapon( "M40A3_mp" );
        level.activ GiveWeapon( "m40a3_mp" );
		iprintlnbold ( "^22" );
		wait 1;
		player GiveWeapon( "remington700_mp" );
		level.activ GiveWeapon( "remington700_mp" );
		iprintlnbold ( "^11" );
		wait 1;
		iprintlnbold ( "^7GO^5!" );
		player switchToWeapon( "m40a3_mp" );
        level.activ SwitchToWeapon( "m40a3_mp" );
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		iPrintLnBold("^7Snipe Room is now Open!");
		player = undefined;
    }
}

ammobox1()
{
		trigger = getent ("ammo_box1", "targetname");

	while(1)
	    {
		trigger waittill( "trigger", player );
		player givemaxammo ( "m40a3_mp" );
		player givemaxammo ( "remington700_mp" );
		player iprintlnbold ("^3Ammo Replenished");
	    }
}
ammobox2()
{
		trigger = getent ("ammo_box2", "targetname");

	while(1)
	    {
		trigger waittill( "trigger", player );
		player givemaxammo ( "m40a3_mp" );
		player givemaxammo ( "remington700_mp" );
		player iprintlnbold ("^3Ammo Replenished");
	    }
}
ammobox3()
{
		trigger = getent ("ammo_box3", "targetname");

	while(1)
	    {
		trigger waittill( "trigger", player );
		if(level.ammoak == true){
		player givemaxammo ( "ak47_mp" );
		}
		if(level.ammoschrot == true){
		player givemaxammo ( "saw_mp" );
		}
		player iprintlnbold ("^3Ammo Replenished");
	    }
}

bouncefight(){
    level.jump_trig = getEnt( "Jump", "targetname");
    jump = getEnt( "jumper_enter_jumproom", "targetname" );
    acti = getEnt( "activator_enter_jumproom", "targetname" );
	level.jump_trig setHintString ("^3Bounce");
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
		if( !isDefined( level.jump_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.mg_trig delete();
		level.ak_trig delete();
		level.runner_trig delete();
		level.firstenter=false;
		}
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^5" + player.name + " ^3 entered the Bounce Room^7!" );
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		iPrintLnBold("^7Jump Room is now Open!");
		player = undefined;
    }
}

bounceweapon(){
	trigger = getent ("bounce_room_weapon", "targetname");
	trigger setHintString("^3Press [F] to get a weapon!");
	while(1){
		trigger waittill ("trigger", user);
		user giveWeapon("m40a3_mp", 100, 500 );
		user switchToWeapon("m40a3_mp");
		user givemaxammo ( "m40a3_mp" );
	}
}

bouncerespawn(){
	trigger = getent("jumpfail", "targetname");
	jumper = getEnt( "jumper_reset", "targetname" );
    activator = getEnt( "activator_reset", "targetname" );

	for(;;)
	{
		trigger waittill ("trigger", player);
		if(player.pers["team"] == "allies")
		{
			player SetOrigin(jumper.origin);
			player SetPlayerAngles( jumper.angles );
		}
		else if(player.pers["team"] == "axis")
		{
			player SetOrigin(activator.origin);
			player SetPlayerAngles( activator.angles );
		}
	}
}

akfight(){
    level.ak_trig = getEnt( "ak", "targetname");
    jump = getEnt( "wepjump", "targetname" );
    acti = getEnt( "wepacti", "targetname" );
    level.ak_trig setHintString ("^3Ak47 fight");
    while(1)
    {
        level.ak_trig waittill( "trigger", player );
        if( !isDefined( level.ak_trig ) )
            return;

		if(level.firstenter==true)
		{
		level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.snipe_trig delete();
		level.mg_trig delete();
		level.runner_trig delete();
		level.firstenter=false;
		level.ammoak = true;
		}
        iPrintlnBold( " ^5" + player.name + " ^3 entered the Ak Room^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
		level.activ TakeAllWeapons();
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
		iprintlnbold ( "^33" );
		wait 1;
        player GiveWeapon( "ak47_mp" );
        level.activ GiveWeapon( "ak47_mp" );
		iprintlnbold ( "^22" );
		wait 1;
		iprintlnbold ( "^11" );
		wait 1;
		iprintlnbold ( "^7GO^5!" );
		player switchToWeapon( "ak47_mp" );
        level.activ SwitchToWeapon( "ak47_mp" );
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		iPrintLnBold("^7Ak Room is now Open!");
		player = undefined;
    }
}

mgfight(){
    level.mg_trig = getEnt( "mg", "targetname");
    jump = getEnt( "wepjump", "targetname" );
    acti = getEnt( "wepacti", "targetname" );
    level.mg_trig setHintString ("^3Saw fight");
    while(1)
    {
        level.mg_trig waittill( "trigger", player );
        if( !isDefined( level.mg_trig ) )
            return;

		if(level.firstenter==true)
		{
		level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.snipe_trig delete();
		level.ak_trig delete();
		level.runner_trig delete();
		level.firstenter=false;
		level.ammoschrot = true;
		}
        iPrintlnBold( " ^5" + player.name + " ^3 entered the Saw Room^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
		level.activ TakeAllWeapons();
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
		iprintlnbold ( "^33" );
		wait 1;
        player giveWeapon("saw_mp");
        level.activ giveWeapon("saw_mp");
		iprintlnbold ( "^22" );
		wait 1;
		iprintlnbold ( "^11" );
		wait 1;
		iprintlnbold ( "^7GO^5!" );
		player switchToWeapon( "saw_mp" );
        level.activ SwitchToWeapon( "saw_mp" );
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		iPrintLnBold("^7Saw Room is now Open!");
		player = undefined;
    }
}

runner(){
    level.runner_trig = getEnt( "runner", "targetname");
    jump = getEnt( "runnerjumper", "targetname" );
    acti = getEnt( "runneracti", "targetname" );
    level.runner_trig setHintString ("^3Runner");
    while(1)
    {
        level.runner_trig waittill( "trigger", player );
		level.runner = player;
        if( !isDefined( level.runner_trig ) )
            return;

		if(level.firstenter==true)
		{
		level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.snipe_trig delete();
		level.mg_trig delete();
		level.ak_trig delete();
		level.firstenter=false;
		}
        iPrintlnBold( " ^5" + player.name + " ^3 entered the Runner Room^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
		level.activ TakeAllWeapons();
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
		runnerdoor();
		iprintlnbold ( "^33" );
		wait 1;
        player GiveWeapon( "ak47_mp" );
        level.activ GiveWeapon( "ak47_mp" );
		iprintlnbold ( "^22" );
		wait 1;
		iprintlnbold ( "^11" );
		wait 1;
		iprintlnbold ( "^7GO^5!" );
		player switchToWeapon( "ak47_mp" );
        level.activ SwitchToWeapon( "ak47_mp" );
		movewall();
		while( isAlive( player ) && isDefined( player ) ){
			wait 0.1;
		}

		iPrintLnBold("^7Runner Room is now Open!");
		runnerreset();
		player = undefined;
    }
}
runnerfail(){
	fail = getEnt("wall_runner_fail","targetname");
	winner = getEnt("runwinner","targetname");
	looser = getEnt("runlooser","targetname");
	for(;; ){
		fail waittill ("trigger", player);
		if(player.pers["team"] == "allies")
		{
			level.runner SetOrigin(looser.origin);
			level.runner SetPlayerAngles( looser.angles );
			level.activ SetOrigin(winner.origin);
			level.activ SetPlayerAngles( winner.angles );
			level.runner freezeControls(1);
		}
		else if(player.pers["team"] == "axis")
		{
			level.activ SetOrigin(looser.origin);
			level.activ SetPlayerAngles( looser.angles );
			level.runner SetOrigin(winner.origin);
			level.runner SetPlayerAngles( winner.angles );
			level.activ freezeControls(1);
		}
	}
}
runnertp(){
	trigger = getEnt("wall_runner_teleport","targetname");
	jump = getEnt( "runnerjumper", "targetname" );
    acti = getEnt( "runneracti", "targetname" );
	for(;;)
	{
		trigger waittill ("trigger", player);
		if(player.pers["team"] == "allies")
		{
			player SetOrigin(jump.origin);
			player SetPlayerAngles( jump.angles );
		}
			else if(player.pers["team"] == "axis")
		{
			player SetOrigin(acti.origin);
			player SetPlayerAngles( acti.angles );
		}


	}
}
movewall(){
	trigger = getEnt("wall_runner_fail","targetname");
	wall = getEnt("wall_runner","targetname");
	trigger enablelinkto();
	trigger linkto(wall);
	wait 10;
	wall moveX(4992,30);
}
runnerdoor(){
	wall_runner_door = getEnt("wall_runner_door","targetname");
	wall_runner_door moveZ(-1000,6);
}
runnerreset(){
	wall_runner_door = getEnt("wall_runner_door","targetname");
	wall = getEnt("wall_runner","targetname");
	trigger = getEnt("wall_runner_fail","targetname");
	trigger enablelinkto();
	trigger linkto(wall);
	wall_runner_door moveZ(1000,0.1);
	wall moveto((-1192,7684,4612),0.1);
}


//////////////////////////// TRAPS ////////

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1(){
	trigger = getEnt( "trap1", "targetname" );

	hurt1 = getEnt( "trap1_trigger1", "targetname" );
	hurt2 = getEnt( "trap1_trigger2", "targetname" );
	hurt3 = getEnt( "trap1_trigger3", "targetname" );
	hurt4 = getEnt( "trap1_trigger4", "targetname" );

	cone1 = getEnt( "trap1_cone1", "targetname" );
	cone2 = getEnt( "trap1_cone2", "targetname" );
	cone3 = getEnt( "trap1_cone3", "targetname" );
	cone4 = getEnt( "trap1_cone4", "targetname" );

	hurt1 enablelinkto();
	hurt1 linkto(cone1);

	hurt2 enablelinkto();
	hurt2 linkto(cone2);

	hurt3 enablelinkto();
	hurt3 linkto(cone3);

    hurt4 enablelinkto();
	hurt4 linkto(cone4);

	trigger setHintString ("^3Random Smasher");
	trigger waittill( "trigger",player);
	trigger delete();

	while(1){
		random = randomInt(4);
		wait 0.25;
		if(random == 0){
			cone1 moveY(-250,1);
			cone2 moveY(-250,1);
			cone1 waittill("movedone");
			cone1 moveY(250,1);
			cone2 moveY(250,1);
			cone1 waittill("movedone");
		}
		if(random == 1){
			cone3 moveY(250,1);
			cone4 moveY(250,1);
			cone3 waittill("movedone");
			cone3 moveY(-250,1);
			cone4 moveY(-250,1);
			cone3 waittill("movedone");
		}
		if(random == 2){
			cone1 moveY(-250,1);
			cone3 moveY(250,1);
			cone1 waittill("movedone");
			cone1 moveY(250,1);
			cone3 moveY(-250,1);
			cone1 waittill("movedone");
		}
		if(random == 3){
			cone2 moveY(-250,1);
			cone4 moveY(250,1);
			cone2 waittill("movedone");
			cone2 moveY(250,1);
			cone4 moveY(-250,1);
			cone2 waittill("movedone");
		}
		wait 3;
	}
}

trap2(){
	trigger = getEnt("trap2","targetname");
	belt = getEnt("belt","targetname");
	turret1 = getEnt("turret1","targetname");
	turret2 = getEnt("turret2","targetname");
	turret3 = getEnt("turret3","targetname");
	hurt = getEnt("trap2_hurt","targetname");
	//turret1 enablelinkto();
	turret1 linkto(belt);
	//turret2 enablelinkto();
	turret2 linkto(belt);
	//turret3 enablelinkto();
	turret3 linkto(belt);
	hurt enablelinkto();
	hurt linkto(belt);

	belt2 = getEnt("belt2","targetname");
	turret4 = getEnt("turret4","targetname");
	turret5 = getEnt("turret5","targetname");
	turret6 = getEnt("turret6","targetname");
	hurt2 = getEnt("trap2_hurt2","targetname");
	//turret4 enablelinkto();
	turret4 linkto(belt2);
	//turret5 enablelinkto();
	turret5 linkto(belt2);
	//turret6 enablelinkto();
	turret6 linkto(belt2);
	hurt2 enablelinkto();
	hurt2 linkto(belt2);

	trigger setHintString ("^3Start the turret production!");
	trigger waittill( "trigger",player);
	trigger delete();

	while(1){
		belt moveY(1200,2);
		belt2 moveY(-1200,2);
		belt waittill("movedone");
		belt moveZ(-1200,1);
		belt2 moveZ(-1200,1);
		belt waittill("movedone");
		belt moveY(-1200,1);
		belt2 moveY(1200,1);
		belt waittill("movedone");
		belt moveZ(1200,1);
		belt2 moveZ(1200,1);
		belt waittill("movedone");
	}

}

trap3(){
	trigger = getEnt("trap3","targetname");
	hurt = getEnt("trap3_hurt","targetname");
	cone = getEnt("trap3_cone","targetname");

	hurt enablelinkto();
	hurt linkto(cone);

	trigger setHintString ("^3Make The Red Portal deadly for a short time!");
	trigger waittill( "trigger",player);
	trigger delete();

	cone moveZ(300,2);
	wait 3;
	cone moveZ(-300,2);
}

trap4(){
	trigger = getEnt("trap4","targetname");
	plat1 = getEnt("trap4_plat1","targetname");
	plat2 = getEnt("trap4_plat2","targetname");
	plat3 = getEnt("trap4_plat3","targetname");
	plat4 = getEnt("trap4_plat4","targetname");

	trigger setHintString ("^3Make The Platforms move!");
	trigger waittill( "trigger",player);
	trigger delete();

	while(1){
		plat1 moveX(1000,1);
		plat1 waittill("movedone");
		plat2 moveX(1000,1);
		plat2 waittill("movedone");
	    plat3 moveX(1000,1);
		plat3 waittill("movedone");
	    plat4 moveX(1000,1);
		plat4 waittill("movedone");
		plat1 moveX(-1000,1);
		plat2 moveX(-1000,1);
		plat3 moveX(-1000,1);
		plat4 moveX(-1000,1);
		wait 2;
	}
}

trap5(){
	hurt = getEnt("trap_gas_hurt","targetname");
	trap5 = getEnt("trap5","targetname");
	nodraw = getEnt("trap5_nodraw","targetname");
	w1 = getEnt("w1","targetname");
	w2 = getEnt("w2","targetname");
	hurt enablelinkto();
	hurt linkto(nodraw);
	trap5 setHintString ("^3Initiate Neurotoxins");
	trap5 waittill("trigger",player);
	trap5 delete();
	fxA = spawnFx( level.smoke, (3616, 5508, -130) );
	triggerFx(fxA);
	nodraw moveZ(200,3);
	w1 moveZ(200,3);
	w2 moveZ(200,3);
	w2 waittill("movedone");
	wait 8;
	nodraw moveZ(-200,0.1);
	w1 moveZ(-200,0.1);
	w2 moveZ(-200,0.1);
	fxA delete();
}

trap6(){

	cylinder = getEnt("trap6_cylinder","targetname");
	plate =	getEnt("trap6_spinner","targetname");
	trap6 = getEnt("trap6","targetname");

	trap6 setHintString ("^3Activate the large Spinner");
	trap6 waittill("trigger",player);
	trap6 delete();

	while(1){
	   cylinder rotateYaw (360,6);
	   plate rotateYaw (360,6);
	   wait 1;
	}

}

trap7(){
	trap7 = getEnt("trap7","targetname");
	cat1 =	getEnt("catwalk1","targetname");
	cat2 =	getEnt("catwalk2","targetname");
	cat3 =	getEnt("catwalk3","targetname");
	cat4 =	getEnt("catwalk4","targetname");
	cat5 =	getEnt("catwalk5","targetname");
	cat6 =	getEnt("catwalk6","targetname");

	trap7 setHintString ("^3Make 5 of the 6 paths not solid!");
	trap7 waittill("trigger",player);
	trap7 delete();

	random = randomInt(6);

	if(random == 0){
		cat2 notSolid();
		cat3 notSolid();
		cat4 notSolid();
		cat5 notSolid();
		cat6 notSolid();
	}
	if(random == 1){
		cat1 notSolid();
		cat3 notSolid();
		cat4 notSolid();
		cat5 notSolid();
		cat6 notSolid();
	}
	if(random == 2){
		cat2 notSolid();
		cat1 notSolid();
		cat4 notSolid();
		cat5 notSolid();
		cat6 notSolid();
	}
	if(random == 3){
		cat2 notSolid();
		cat3 notSolid();
		cat1 notSolid();
		cat5 notSolid();
		cat6 notSolid();
	}
	if(random == 4){
		cat2 notSolid();
		cat3 notSolid();
		cat4 notSolid();
		cat1 notSolid();
		cat6 notSolid();
	}
	if(random == 5){
		cat2 notSolid();
		cat3 notSolid();
		cat4 notSolid();
		cat5 notSolid();
		cat1 notSolid();
	}
}
//////////////////////////// INFO ////////
mapperinfo(){
level waittill("round_started");
	while(1)
	{
		iprintln("^2Map made by ^1ix'.Elpredatore^2 !!!");
		wait 2;
		iprintln("^2Credits to VC'Blade for the Music Menu^2 !!!");
		wait 30;
	}
}

credits(){
	trigger = getEnt( "credits", "targetname" );
	trigger setHintString ("^3Map by ^7ix'.Elpredatore");
	trigger waittill( "trigger",player);
}

text()
{
	hud_clock = newhudelem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 250;
	hud_clock.y = 220;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.5;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0.0, 1.0, 0.0);
	while(1){
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 1;
		hud_clock setText("Map by Elpredatore");
		wait 10;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 0;
		wait 1;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 1;
		hud_clock setText("The cake is a lie");
		wait 10;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 0;
		wait 1;
	}
}

//////////////////////////// MUSIC ////////
ambient(){
	level waittill( "round_started" );
	AmbientPlay ( "map" );
	wait 2;
	iprintln("^1>>^7Now Playing^3: ^1swatdojo ^3- ^7Cake Is Gone (Portal Dubstep)^1<<");
}

endMusic()
{
	AmbientStop(1);
}

musicbox()
{
    trig = getEnt("musictrigger","targetname");
    trig setHintString("Press ^1&&1^7 to select a song for all test subjects");
    trig waittill("trigger",p);
    //p braxi\_rank::giveRankXP("", 50); //remove this if you still got braxi issues
    trig delete();
    p freezeControls(1);
    p musicmenu();
}

musicmenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );

    self.hud_music = [];
    self.selection = 0;

    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "white", 320, 160 ); //background image
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 ); //should be bar image, i suggest to not change cuz your texture will be stretched
    self.hud_music[i].color=(0,.7,.8);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Aperture Science Enrichment Center"); //title
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else
        self.hud_music[i].glowcolor=(0,.7,.8); //title text color
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                   Scroll: ^1[{+attack}] ^7| Select: ^1[{+activate}] ^7| Close: ^1[{+frag}]"); //just change numbers of colors here if you need different ones

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else
            self.hud_music[i].glowcolor=(0,.7,.8);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 ); //another bar image that will most likely stretch, i suggest to only change colors
    indicator.color=(0,.7,.8);

    while(self.sessionstate == "playing")
    {
        wait 0.1;

        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             iPrintLn("^2>>^1Now playing: ^5"+level.music[self.selection]["song"]+"^2<<"); //text that appears after picking a song
            endMusic();
            ambientPlay(level.music[self.selection]["alias"]);
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
           break;
        }
    }

    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

//////////////////////////// MISC ////////
roomele(){
	ele = getEnt( "room_ele", "targetname" );
	triggi = getent( "fucki2", "targetname" );
	triggi setHintString ("^3Press ^7[F] ^3 to start the elevator!");
	triggi waittill("trigger",player);
	triggi delete();
	iPrintlnBold( " ^5" + player.name + " ^3 Started the elevator!" );
	while(1){
		ele moveZ(1472,3);
		ele waittill("movedone");
		wait 2;
		ele moveZ(-1472,3);
		ele waittill("movedone");
		wait 2;
	}

}

endele(){
	ele = getEnt( "end_elevator", "targetname" );
	triggi = getent( "fucki", "targetname" );
	triggi setHintString ("^3Press ^7[F] ^3 to start the elevator!");
	triggi waittill("trigger",player);
	triggi delete();
	while(1){
		ele moveZ(1152,3);
		ele waittill("movedone");
		wait 2;
		ele moveZ(-1152,3);
		ele waittill("movedone");
		wait 2;
	}

}
start(){
	trigger = getEnt( "start_door_trig", "targetname" );
	cube = getEnt( "comp_cube", "targetname" );
	door = getEnt( "startdoor", "targetname" );

	trigger setHintString ("Sacrifice your best friend to Glados");
	trigger waittill( "trigger",player);
	trigger delete();
	cube rotateYaw (1200,4);
	cube moveZ (-500,2);
	wait 1;
	door moveZ (-500,4);
	cube delete();
	iPrintlnBold("^3Welcome to the Aperture Science testing facility^7!" );
}

portal(){
	tp_origin = getent ("blue_portal","targetname");
	tp_portal_trig = getent ("red_portal","targetname");

	for(;; )
	{
		tp_portal_trig waittill("trigger", player);
		player SetPlayerAngles( tp_origin.angles );
		player setOrigin(tp_origin.origin);
	}
}

enddoor(){
	trigger = getent ("enddoor","targetname");
	cube = getent ("end_cube","targetname");
	doorleft = getent("endleft","targetname");
	doorright = getent("endright","targetname");
	hurt = getent("endhurt","targetname");
	cubedoor = getent("cubedoorleft","targetname");

	hurt enablelinkto();
	hurt linkto(cube);

	trigger setHintString ("Open the door to the final stage");
	trigger waittill( "trigger",player);
	trigger delete();

	cubedoor rotateto( ( 90, 0, 0 ), 2);
	cubedoor moveX(-52,2);
    //cubedoor waittill ( "rotatedone" );
	wait 1.3;
	cube moveZ(-220,1);
	cube waittill ("movedone");
	doorleft moveY(100,2);
    doorright moveY(-100,2);
	doorleft waittill ("movedone");

	iPrintlnBold( " ^5" + player.name + " ^3 opened the door to the final chamber^7!" );

}
//////////////////////////// SECRET ////////
cakeroom(){
	weapon_trig = getEnt("cake_weapon","targetname");
	cylinder = getEnt("cake_cylinder","targetname");
	door = getEnt("cake_door", "targetname");
	door linkto(cylinder);
	vent = getEnt("vent", "targetname");
	cake2 = getEnt("cake2", "targetname");
	cake3 = getEnt("cake3", "targetname");
	vent3 = getEnt("vent3", "targetname");
	gitter2 = getEnt("gitter2", "targetname");
	trigger = getEnt("cake_trig", "targetname");
	door_trig = getEnt("cake_door_trig", "targetname");
	door_trig setHintSTring ("She will see it if you try to steal the cake...");
	trigger waittill( "trigger",player);
	trigger delete();
	iPrintlnBold( " ^5" + player.name + " ^3 destroyed a camera^7!" );
	door_trig waittill( "trigger",player);
	cylinder rotateyaw(90, 2, 0.5, 0.5);
	door_trig delete();
	weapon_trig waittill("trigger",player);
	weapon_trig delete();
	iPrintlnBold( " ^5" + player.name + " ^3 found a cake!" );
	vent notSolid();
	cake2 waittill("trigger", player);
	gitter2 notSolid();
	cake3 waittill("trigger",player);
	vent3 notSolid();
	tp_origin = getent ("tp_secret_origin","targetname");
	secret_tp = getent ("secret_tp","targetname");
	thread cara();
	thread secretfail();
	thread secretexit();
	for(;; )
	{
		secret_tp waittill("trigger", player);
		player SetPlayerAngles( tp_origin.angles );
		player setOrigin(tp_origin.origin);
	}
}
cara(){
	trigger = getEnt("caramia","targetname");
	fire_trig = getEnt("cake_fire","targetname");
	fire_trig waittill("trigger",player);
	fxB = spawnFx( level.fire, (6680, 2568, -48) );
	triggerFx(fxB);
	trigger setHintString("Let the turrets sing!");
	trigger waittill("trigger",player);
	iPrintlnBold( " ^5" + player.name + " ^3 started the turret opera!" );
	trigger delete();
	endMusic();
	ambientPlay("opera");
	thread turretdance();
	thread secretturretdance();
	wait 155;
	endMusic();
	ambientPlay("map");
}
turretdance(){
	turret1 = getEnt("caraturret1","targetname");
	turret2 = getEnt("caraturret2","targetname");
	turret3 = getEnt("caraturret3","targetname");
	turret4 = getEnt("caraturret4","targetname");
	turret5 = getEnt("caraturret5","targetname");
	turret6 = getEnt("caraturret6","targetname");
	turret7 = getEnt("caraturret7","targetname");
	turret8 = getEnt("caraturret8","targetname");
	turret9 = getEnt("caraturret9","targetname");
	turret10 = getEnt("caraturret10","targetname");
	turret11 = getEnt("caraturret11","targetname");
	turret12 = getEnt("caraturret12","targetname");
	turret13 = getEnt("caraturret13","targetname");
	turret14 = getEnt("caraturret14","targetname");
	turret15 = getEnt("caraturret15","targetname");
	turret16 = getEnt("caraturret16","targetname");
    turret17 = getEnt("caraturret17","targetname");

	while(1){
		turret1 moveZ(1000,3);
		turret2 moveZ(1000,3);
		turret3 moveZ(1000,3);
		turret4 moveZ(1000,3);
		turret5 moveZ(1000,3);
		turret6 moveZ(1000,3);
		turret7 moveZ(1000,3);
		turret8 moveZ(1000,3);
		turret9 moveZ(1000,3);
		turret10 moveZ(1000,3);
		turret11 moveZ(1000,3);
		turret12 moveZ(1000,3);
		turret13 moveZ(1000,3);
		turret14 moveZ(1000,3);
		turret15 moveZ(1000,3);
		turret16 moveZ(1000,3);
		turret17 moveZ(1000,3);
		turret1 waittill("movedone");
		wait 0.1;
		turret1 moveZ(-1000,3);
		turret2 moveZ(-1000,3);
		turret3 moveZ(-1000,3);
		turret4 moveZ(-1000,3);
		turret5 moveZ(-1000,3);
		turret6 moveZ(-1000,3);
		turret7 moveZ(-1000,3);
		turret8 moveZ(-1000,3);
		turret9 moveZ(-1000,3);
		turret10 moveZ(-1000,3);
		turret11 moveZ(-1000,3);
		turret12 moveZ(-1000,3);
		turret13 moveZ(-1000,3);
		turret14 moveZ(-1000,3);
		turret15 moveZ(-1000,3);
		turret16 moveZ(-1000,3);
		turret17 moveZ(-1000,3);
		turret1 waittill("movedone");
		wait 0.1;
	}
}
secretturretdance(){
	turret = getEnt("secret_turret","targetname");
	clip = getEnt("secret_clip","targetname");

	clip enablelinkto();
	clip linkto(turret);

	while(1){
		turret moveZ(30,1);
		turret waittill("movedone");
		turret moveZ(-30,1);
		turret waittill("movedone");
	}
}
secretfail(){
	tp_origin = getent ("tp_secret_origin","targetname");
	trigger = getent("secret_fail","targetname");

	for(;; )
	{
		trigger waittill("trigger", player);
		player SetPlayerAngles( tp_origin.angles );
		player setOrigin(tp_origin.origin);
	}

}

secretexit(){
	tp_origin = getent ("tp_secret_exit_origin","targetname");
	trigger = getent("secret_exit","targetname");

	for(;; )
	{
		trigger waittill("trigger", player);
		player SetPlayerAngles( tp_origin.angles );
		player setOrigin(tp_origin.origin);
		iPrintlnBold( " ^5" + player.name + " ^3 finished the cake room!" );
	}

}
////////////////////////// JUMPPADS ///////////////////////
setupJumppads() //3 als beispiel
{
//precacheModel( "xmodel/serthy_buildzone" );                         //falls model erwünscht, unbeding precachen! sonst crasht der server

level.jumppads = [];                                            // ganz wichtig! muss zuerst stehen!

level.jumppads[level.jumppads.size] = spawnStruct();                        //muss immer zuerst stehen bei jedem neuen jumppad
level.jumppads[level.jumppads.size - 1].origin = ( 2800,1296, 30 );        //wo?
level.jumppads[level.jumppads.size - 1].angles = ( 0 , 0 , 0 );             //winkel?
level.jumppads[level.jumppads.size - 1].height =  20;                       //trigger höhe
level.jumppads[level.jumppads.size - 1].radius = 80;                        //trigger radius
level.jumppads[level.jumppads.size - 1].dirPos = ( 2800 , 1326 , 150 );           //richtung, sollte im bereich von +/- 50 neben dem origin sich befinden: origin + ( 50 , -30 , 32 )
//level.jumppads[level.jumppads.size - 1].model = "xmodel/serthy_buildzone";      //damit man es erkennt? muss precached werden!!!
level.jumppads[level.jumppads.size - 1].power = 75000;                      //wie stark das jumppad ist
//level.jumppads[level.jumppads.size - 1].sound = "minefield_click";          //sound welcher abgespielt wird
}


spawnJumppad( origin , angles , height , radius , dirPos , model , power , sound )
{
if( !isDefined( radius ) )      radius = 5;
if( !isDefined( height ) )      height = 1;
if( !isDefined( angles ) )      angles = ( 0 , 0 , 0 );

jumppad = spawn( "trigger_radius" , origin , 0 , radius , height );
jumppad.angles = angles;
jumppad.targetname = "jumppad";
jumppad.jumpSound = sound;
jumppad.power = power;

if( isDefined( model ) )
{
jumppad.vis = spawn( "script_model" , origin );
jumppad.vis setmodel( model );
}

if( isDefined( dirPos ) )
jumppad.dir = vectorNormalize( dirPos - origin );
}

monitorUsage()
{
if( isDefined( self.target ) )
{
target = getEnt( self.target , "targetname" );

if( isDefined( target ) )
{
self.dir = vectorNormalize( self.target.origin - self.origin );
self.target delete();
}
}

if( isDefined( self.script_noteworthy ) )
{
tokens = strTok( self.script_noteworthy , "," );
self.power = tokens[0];
self.jumpSound = tokens[1];
}

while( isDefined( self ) )
{
wait( 0.05 );

self waittill( "trigger" , player );

if( !isDefined( player.isOnJumppad ) )
self bouncePlayer( player , self.power , self.dir );
}
}

bouncePlayer( player , power , dir )
{
player endon( "disconnect" );

player.isOnJumppad = undefined;

if( isDefined( self.jumpSound ) && self.jumpSound != "" )
self playSound( self.jumpSound );

if( !isDefined( dir ) )
dir = ( 0 , 0 , 1 );

if( !isDefined( power ) )
power = 150000;

//player iPrintLnBold( "Yippieeeh!" );

while( isDefined( self ) && isDefined( player ) )
{
if( player.sessionstate != "playing" )
break;
else if( !player isTouching( self ) )
break;

power = int( player.maxhealth * power );
health = player.health;
player.health += power;

player finishPlayerDamage( self , self , power , 0 , "MOD_PROJECTILE" , "none" , self.origin , dir , "none" , 0 );

player.health = health;

wait( 0.05 );
}

player.isOnJumppad = undefined;
}