/*
mp_dr_theship
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

			 SPECIAL THANKS TO TWIYO <3

	Why are you decompiling my first scripted map ? :D
*/

#include maps\mp\gametypes\_hud_util;

main()
{
thread sr\api\_map::createSpawnOrigin((-1832.602, 502.545, 0.125), 0);
 maps\mp\_load::main();


 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	setExpFog(500, 2200, 0.81, 0.75, 0.63, 0.5);
	precacheModel("com_computer_rack");
	precacheModel("vehicle_80s_sedan1_red");
	precacheItem("ak74u_mp");
	precacheItem("remington700_mp");
	precacheItem("knife_mp");
	precacheItem("tomahawk_mp");
	precacheItem("deserteagle_mp");
	precacheItem("uzi_mp");
	precacheItem("m4_mp");
	precacheItem("ak47_mp");
	precacheItem("g3_mp");
	precacheItem("m60e4_mp");
	precacheItem("p90_mp");
	precacheItem("m40a3_mp");
	precacheItem("barrett_mp");
	precacheItem("g36c_silencer_mp");
	precacheItem("skorpion_silencer_mp");
	precacheItem("saw_grip_mp");

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

/////////////////////MUSIC/////////////////
thread ambient();
thread jukebox();
thread openjukedoor();
/////////////////////MISC/////////////////
thread linked();
thread actitp();

/////////////////////SECRET/////////////////
thread secret1();
thread secretweapon();

/////////////////////TRAPS/////////////////
thread trap1();
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
thread trap7();
thread trap8();
thread mover1();
thread mover2();

/////////////////////INFO/////////////////
thread mapperinfo();

/////////////////////XP/////////////////
addTriggerToList( "trap1" );
addTriggerToList( "trap2" );
addTriggerToList( "trap3" );
addTriggerToList( "trap4" );
addTriggerToList( "trap5" );
addTriggerToList( "trap6" );
addTriggerToList( "trap7" );
addTriggerToList( "trap8" );
/////////////////////ENDROOMS/////////////////
thread sniperfight();
thread knifefight();
thread bouncefight();
thread oldfight();
thread bounceweapon();
thread bouncerespawn();
level.firstenter = true;
}

//////////////////////////// ENDROOMS ////////
sniperfight(){
     level.snipe_trig = getEnt( "sniperoom", "targetname");
    jump = getEnt( "jumpsnipe", "targetname" );
    acti = getEnt( "actisnipe", "targetname" );

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

knifefight(){
    level.knife_trig = getEnt( "Knife", "targetname");
    jump = getEnt( "jumper_enter_kniferoom", "targetname" );
    acti = getEnt( "activator_enter_kniferoom", "targetname" );

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

oldfight(){
   	level.old_trig = getEnt( "Old", "targetname");
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


bouncefight(){
    level.jump_trig = getEnt( "Jump", "targetname");
    jump = getEnt( "jumper_enter_jumproom", "targetname" );
    acti = getEnt( "activator_enter_jumproom", "targetname" );
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

		trigger waittill ("trigger", user);
		trigger delete();

		{
			{
			wait 0.25;
			random = randomInt(14);

			if(random == 0)
			{
				user giveWeapon("deserteagle_mp", 100, 500 );
				user switchToWeapon("deserteagle_mp");

			}
			if(random == 1)
			{
				user giveWeapon("uzi_mp", 100, 500 );
				user switchToWeapon("uzi_mp");

			}
			if(random == 2)
			{
				user giveWeapon("m4_mp", 100, 500 );
				user switchToWeapon("m4_mp");

			}
			if(random == 3)
			{
				user giveWeapon("ak47_mp", 100, 500 );
				user switchToWeapon("ak47_mp");

			}
			if(random == 4)
			{
				user giveWeapon("g3_mp", 100, 500 );
				user switchToWeapon("g3_mp");

			}
			if(random == 5)
			{
				user giveWeapon("m60e4_mp", 100, 500 );
				user switchToWeapon("m60e4_mp");

			}
			if(random == 6)
			{
				user giveWeapon("p90_mp", 100, 500 );
				user switchToWeapon("p90_mp");

			}
			if(random == 7)
			{
				user giveWeapon("m40a3_mp", 100, 500 );
				user switchToWeapon("m40a3_mp");

			}
			if(random == 8)
			{
				user giveWeapon("barrett_mp", 100, 500 );
				user switchToWeapon("barrett_mp");

			}
			if(random == 9)
			{
				user giveWeapon("g36c_silencer_mp", 100, 0 );
				user switchToWeapon("g36c_silencer_mp");

			}
			if(random == 10)
			{
				user giveWeapon("skorpion_silencer_mp", 100, 500 );
				user switchToWeapon("skorpion_silencer_mp");

			}
			if(random == 11)
			{
				user giveWeapon("saw_grip_mp", 100, 500 );
				user switchToWeapon("saw_grip_mp");

			}
			if(random == 12)
			{
				user giveWeapon("remington700_mp", 100, 500 );
				user switchToWeapon("remington700_mp");

			}
			if(random == 13)
			{
				user giveWeapon("ak74u_mp", 100, 500 );
				user switchToWeapon("ak74u_mp");
			}
		}
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

//////////////////////////// INFO ////////
mapperinfo(){
	while(1)
	{
	wait 30;
	iprintln("^2map by ^1ix'.Elpredatore^2 !!!");
	wait 2;
	iprintln("^2Special Thanks to Twiyo and [PF]JeffSkye^2 !!!");
	}
}

//////////////////////////// MUSIC ////////
openjukedoor(){
	door = getent("container","targetname");
	door_music_trig = getent("musicdoor","targetname");

		door_music_trig waittill ( "trigger" );
		door_music_trig delete();
		door moveZ (52,2);
		door rotateto( ( 90, 0, 0 ), 2);
		door waittill ( "rotatedone" );

}

ambient()
{
level waittill( "round_started" );
AmbientPlay ( "map" );
wait 2;
iprintln("^1>>^7Now Playing^3: ^1WHITENO1SE & Ranji Ft. Nina Nesbitt  ^3- ^7The Moments I'm Missing^1<<");
}


endMusic()
{
	AmbientStop(1);
}

jukebox(){
	music_trig = getEnt( "jukebox", "targetname");
	music_trig setHintString ("Random Music Selector");

	music_trig waittill( "trigger",player);

	music_trig setHintString ("Music Changed");

	iPrintLnBold( " ^4" + player.name + " ^7has changed the Music!" );

	thread endMusic();
	random = RandomInt(8);

			if(random == 0)
			{
				ambientPlay("juke1");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1Kodex vs. Amazed  ^3- ^7Chasing Stars^1<<");
			}
			if(random == 1)
			{
				ambientPlay("juke2");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1Illenium  ^3- ^7Feel Something^1<<");
			}
			if(random == 2)
			{
				ambientPlay("juke3");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1Mausio feat. Bibiane Z ^3- ^7Trough the Night^1<<");
			}
			if(random == 3)
			{
				ambientPlay("juke4");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1San Holo ^3- ^7I Still See Your Face^1<<");
			}
			if(random == 4)
			{
				ambientPlay("juke5");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1Allie X  ^3- ^7Paper Love^1<<");
			}
			if(random == 5)
			{
				ambientPlay("juke6");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1NGHTMRE  Carmada   ^3- ^7Embrace^1<<");
			}
			if(random == 6)
			{
				ambientPlay("juke7");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1W&W and Groove Coverage  ^3- ^7God is a girl^1<<");
			}
			if(random == 7)
			{
				ambientPlay("juke8");
				music_trig delete();
				iprintln("^1>>^7Now Playing^3: ^1Linkin Park  ^3- ^7In The End (Mellen Gi & Tommee Profitt Remix)^1<<");
			}
}

//////////////////////////// SECRET ////////

secret1(){
	button1 = getent("secret1_button1","targetname");
	button2 = getent("secret1_button2","targetname");
	button3 = getent("secret1_button3","targetname");
	tele1 = getEnt("secret1_origin","targetname");

	button1 waittill("trigger", player);
	button1 delete();
	iPrintLnBold( "^4something happend" );

	button2 waittill("trigger", player);
	button2 delete();
	iPrintLnBold( "^4something happend" );

	for(;; )
   {
    button3 waittill("trigger", player);
    player setOrigin(tele1.origin);
	self iPrintLnBold( "^3woosh" );


   }
}

secretweapon(){
	finish = getent("secretweapon","targetname");
	target = getEnt ("secret_ausgang", "targetname");

	for(;;)
	{
		finish waittill ("trigger", user);
			wait 0.25;
		{
			{
				wait 0.25;
				random = randomInt(14);

				if(random == 0)
				{
					user giveWeapon("deserteagle_mp", 100, 500 );
					user switchToWeapon("deserteagle_mp");

				}
				if(random == 1)
				{
					user giveWeapon("uzi_mp", 100, 500 );
					user switchToWeapon("uzi_mp");

				}
				if(random == 2)
				{
					user giveWeapon("m4_mp", 100, 500 );
					user switchToWeapon("m4_mp");

				}
				if(random == 3)
				{
					user giveWeapon("ak47_mp", 100, 500 );
					user switchToWeapon("ak47_mp");

				}
				if(random == 4)
				{
					user giveWeapon("g3_mp", 100, 500 );
					user switchToWeapon("g3_mp");

				}
				if(random == 5)
				{
					user giveWeapon("m60e4_mp", 100, 500 );
					user switchToWeapon("m60e4_mp");

				}
				if(random == 6)
				{
					user giveWeapon("p90_mp", 100, 500 );
					user switchToWeapon("p90_mp");

				}
				if(random == 7)
				{
					user giveWeapon("m40a3_mp", 100, 500 );
					user switchToWeapon("m40a3_mp");

				}
				if(random == 8)
				{
					user giveWeapon("barrett_mp", 100, 500 );
					user switchToWeapon("barrett_mp");

				}
				if(random == 9)
				{
					user giveWeapon("g36c_silencer_mp", 100, 0 );
					user switchToWeapon("g36c_silencer_mp");

				}
				if(random == 10)
				{
					user giveWeapon("skorpion_silencer_mp", 100, 500 );
					user switchToWeapon("skorpion_silencer_mp");

				}
				if(random == 11)
				{
					user giveWeapon("saw_grip_mp", 100, 500 );
					user switchToWeapon("saw_grip_mp");

				}
				if(random == 12)
				{
					user giveWeapon("remington700_mp", 100, 500 );
					user switchToWeapon("remington700_mp");

				}
				if(random == 13)
				{
					user giveWeapon("ak74u_mp", 100, 500 );
					user switchToWeapon("ak74u_mp");
				}
			}
			wait 1;
			iPrintlnBold( " ^6" + user.name + " ^5 HAS FINISHED THE SECRET ROOM^1!" );
			user SetOrigin(target.origin);
			user SetPlayerAngles(target.angles);
		}
	}
}
//////////////////////////// TRAPS ////////

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1(){
trap1_bounce = getent("trap1_bounce","targetname");
platform1 = getent("platform1_trap1","targetname");
platform2 = getent("platform2_trap1","targetname");
platform3 = getent("platform3_trap1","targetname");
platform4 = getent("platform4_trap1","targetname");
trap1 = getent("trap1","targetname");
trap1 setHintString ("^3Smash them!");
trap1 waittill("trigger", player );
trap1 delete();
trap1_bounce delete();
 while(1) //Loop
 {
   platform1 rotateYaw (360,1);
   platform2 rotateYaw (360,1);
   platform3 rotateYaw (360,1);
   platform4 rotateYaw (360,1);
   platform1 moveZ (370,2);
   platform2 moveZ (370,2);
   platform3 moveZ (370,2);
   platform4 moveZ (370,2);
   wait 3;
   platform1 rotateYaw (360,1);
   platform2 rotateYaw (360,1);
   platform3 rotateYaw (360,1);
   platform4 rotateYaw (360,1);
   platform1 moveZ (-370,2);
   platform2 moveZ (-370,2);
   platform3 moveZ (-370,2);
   platform4 moveZ (-370,2);
   wait 4;

 }
}

trap2(){
	trap2 = getent("trap2","targetname");
	trap2_rot1 = getent("trap2_rot1","targetname");
	trap2_rot2 = getent("trap2_rot2","targetname");
	platte = getent("trap2_destroy","targetname");
	trap2 setHintString ("^3Turn up!");
	trap2 waittill("trigger", player);
	trap2 delete();
	platte moveZ(-600,4);
	wait 4;
	platte delete();
	while(1){
	   trap2_rot1 rotateYaw (360,4);
	   trap2_rot2 rotateYaw (360,4);
	   wait 1;
	}
}

trap3(){
	trap3 = getent("trap3","targetname");
	moving = getent("trap3_mover","targetname");
	trap3 setHintString ("^3Make it hard to bounce!");
	trap3 waittill("trigger", player);
	trap3 delete();

	while(1){
	   moving moveY (350,1);
	   wait 1;
	   moving moveY (-350,1);
	   wait 1;
	}
}

trap4(){
	trap4 = getent("trap4","targetname");
	plat1 = getent("trap4_1","targetname");
	plat2 = getent("trap4_2","targetname");
	plat3 = getent("trap4_3","targetname");
	plat4 = getent("trap4_4","targetname");
	trap4 setHintString ("^3Make the platforms move!");
	trap4 waittill("trigger", player);
	trap4 delete();

	while(1){
	   plat1 rotateYaw (360,1);
	   plat2 rotateYaw (360,1);
	   plat3 rotateYaw (360,1);
	   plat4 rotateYaw (360,1);
	   wait 5;
	   }
}

trap5(){
	trap5 = getent("trap5","targetname");
	laser = getent("trap5_laser","targetname");
	hurt = getent("trap5_hurt","targetname");
	hurt enablelinkto();
	hurt linkto(laser);
	trap5 setHintString ("^3Make it even harder with lasers!");
	trap5 waittill("trigger", player);
	trap5 delete();

	while(1){
	   laser movex (1560,3);
	   wait 3;
	   laser movex (-1560,3);
	   wait 3;
	   }
}

trap6(){
	floortrap = getent("trap6","targetname");
	rm1 = getent("trap6_rm1","targetname");
	rm2	= getent("trap6_rm2","targetname");
	floortrap setHintString ("^3Make the floor disappear!");
	floortrap waittill("trigger", player);
	floortrap delete();
	rm1 delete();
	rm2 delete();
}

trap7(){
	trap7_mover = getent("trap7_mover","targetname");
	trap7 = getent("trap7","targetname");
	trap7 setHintString ("^3Speed it up!");
	trap7 waittill("trigger", player);
	trap7 delete();
	wait 1;
	trap7_mover moveZ(8,2);
	level.mover1 moveZ(-500,0.1);
	wait 3;
	while(1){
		trap7_mover moveX(704,1);
		wait 1;
		trap7_mover moveY(-704,1);
		wait 1;
		trap7_mover moveX(-704,1);
		wait 1;
		trap7_mover moveY(704,1);
		wait 1;
	}
}

trap8(){
	trap8_mover = getent("trap8_mover","targetname");
	trap8 = getent("trap8","targetname");
	trap8 setHintString ("^3Push them Down!");
	trap8 waittill("trigger", player);
	trap8 delete();
	while(1){
		trap8_mover moveX(1350,3);
		wait 5;
		trap8_mover moveX(-1350,3);
		wait 5;
	}

}

mover1(){
	level.mover1 = getent("mover1","targetname");

	while(isDefined(level.mover1))
	{
		level.mover1 moveX(704,3);
		wait 3;
		level.mover1 moveY(-704,3);
		wait 3;
		level.mover1 moveX(-704,3);
		wait 3;
		level.mover1 moveY(704,3);
		wait 3;
	}
}

mover2(){
	mover2 = getent("mover2","targetname");

	while(1)
	{
		mover2 moveY(704,3);
		wait 3;
		mover2 moveX(704,3);
		wait 3;
		mover2 moveY(-704,3);
		wait 3;
		mover2 moveX(-704,3);
		wait 3;
	}
}

//////////////////////////// MISC ////////
linked(){
	trig = getent ("trigger","targetname"); // your trigger
	start = getent ("start_origin","targetname"); //your start origin
	stop = getent ("stop_origin","targetname"); //your end origin
	trig setHintString ("^4Press F");

	while(true)
	{
		trig waittill ("trigger", player);

			link = spawn ("script_model",player.origin);
			player linkTo (link);
			link moveTo (start.origin, 1);
			wait 1;
			link moveTo (stop.origin, 2);
			wait 2;
			player unlink();
	}
/* Created by [PF]JeffSkye Give Credits If Used In Any Map Or Mod */
}

actitp(){
	tp_origin = getent ("tp_end_origin","targetname");
	tp_end_trig = getent ("tp_end","targetname");

	tp_end_trig setHintString ("^7Press ^3F ^7twice for Teleport");
	tp_end_trig waittill ("trigger", player);

	for(;; )
	{
		tp_end_trig waittill("trigger", player);
		player setOrigin(tp_origin.origin);
	}
}

