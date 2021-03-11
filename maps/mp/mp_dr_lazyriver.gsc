#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setDvar("bg_fallDamageMinHeight", "99999");
		setDvar("bg_fallDamageMaxHeight", "999999");

	VisionSetNaked( "mp_dr_lazyriver");
	precacheItem("m1014_grip_mp");

preCacheModel("vehicle_mig29_desert");
preCacheItem("artillery_mp");
preCacheRumble("artillery_rumble");

	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
level.airstrikefx = loadfx ("explosions/clusterbomb");
level._fx["Water"]["Splash"] = loadfx ("explosions/grenadeExp_water"); 
	
	thread way_connect();
	// thread trap1();	
	thread trap2();
	// thread trap3();
	// thread trap4();	
	// thread trap5();	
	thread trap6();
	thread trap8();
	// thread trap9();
	thread tele1();	
	thread tele2();	
	thread tele3();	
	thread telejumper();	
	thread teleacti();
	thread markers();
	// thread sniperroom();
	// thread shotroom();
	// thread kniferoom();
	// thread oldroom();
	thread water_splash();
	// thread badmusic();
	// thread music();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

music()
{
	
	switch(randomint(4))
	{
		case 0:
			ambientPlay("super");
			wait 2;
			break;
		case 1:
			ambientPlay("need");
			wait 2;
			break;
		case 2:
			ambientPlay("song3");
			wait 2;
			break;
		case 3:
			ambientPlay("undef");
			wait 2;
			break;
	}
}

trap1()
{
	trap1a = getent ("trap1a","targetname");
	trap1b = getent ("trap1b","targetname");
	trap1_trig = getent ("trap1_trig","targetname");
	
	trap1_trig waittill ("trigger");
	trap1_trig delete ();

	while (1)
	{
		trap1a moveZ (100,1,0.4,0);		
		trap1b moveZ (-100,1,0,0.4);
		wait 1;
		trap1a moveZ (-200,1,0.4,0.4);		
		trap1b moveZ (200,1,0.4,0.4);
		wait 1;
		trap1a moveZ (100,1,0,0.4);		
		trap1b moveZ (-100,1,0.4,0);
		wait 1;
	}
}

water_splash()
{
	trig3 = getent("water_fxx", "targetname");

	while(true)
	{
		trig3 waittill ("trigger", who);	
		who PlaySound ("splash");
		PlayFX( level._fx["Water"]["Splash"], who.origin );
		wait 1;
	}
}

markers()
{
	glow1 = getent ("glow1","targetname");
	glow2 = getent ("glow2","targetname");
	glow3 = getent ("glow3","targetname");
	glow4 = getent ("glow4","targetname");
	glow5 = getent ("glow5","targetname");
	glow6 = getent ("glow6","targetname");
	glow7 = getent ("glow7","targetname");
	glow8 = getent ("glow8","targetname");
	glow11 = getent ("glow11","targetname");
		
	{
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow1.origin), 3, (glow1.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow2.origin), 3, (glow2.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow3.origin), 3, (glow3.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow4.origin), 3, (glow4.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow5.origin), 3, (glow5.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow6.origin), 3, (glow6.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow7.origin), 3, (glow7.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow8.origin), 3, (glow8.origin) + (0, 0, 90));
		level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
			maps\mp\_fx::loopfx("beacon_glow", (glow11.origin), 3, (glow11.origin) + (0, 0, 90));
	}
}

trap2()
{
	trap2_trigger = getent("trap2_trig","targetname"); //acti trigger
	fire1 = getent("trap2_fire","targetname"); 
	fire2 = getent("trap2_fire1","targetname"); 
	fire3 = getent("trap2_fire2","targetname"); 
	fire1_hurt = getent("trap2","targetname"); 
	fire2_hurt = getent("trap22","targetname"); 
	fire3_hurt = getent("trap23","targetname"); 
	level._effect["fire"] = loadfx ("fire/jet_afterburner"); //load FIRE fx
	FX = undefined;

	fire1_hurt triggeroff();
	fire2_hurt triggeroff();
	fire3_hurt triggeroff();
	
}

trap3()
{
	trap3 = getent ("trap3","targetname");
	trap3_water = getent ("trap3_water","targetname");
	trap3_trig = getent ("trap3_trig","targetname");
	trap3_fx = loadfx("explosions/mortarExp_water");
	trap3_trig waittill ("trigger");
	trap3_trig delete ();

	while(1)
	{
		trap3 moveZ (-700,1,0.4,0);	
		playFx( trap3_fx, trap3_water.origin);
		wait 3;
		trap3 moveZ (700,1,0,0.4);
		wait 3;
	}
}

trap4()
{
	trap4 = getent ("trap4","targetname");
	trap4_trig = getent ("trap4_trig","targetname");
	
	trap4_trig waittill ("trigger");
	trap4_trig delete ();

	{
		trap4 moveZ (-400,0.1);
		wait 0.1;
	}
}

trap5()
{
	trap5a = getent ("trap5a","targetname");
	trap5b = getent ("trap5b","targetname");
	trap5c = getent ("trap5c","targetname");
	trap5d = getent ("trap5d","targetname");
	trap5_trig = getent ("trap5_trig","targetname");
	
	trap5_trig waittill ("trigger");
	trap5_trig delete ();

	while(1)
	{
		trap5a rotateRoll (-45,1);
		trap5c rotateRoll (45,1);
		wait 1.2;
		trap5a rotateRoll (45,1);
		trap5c rotateRoll (-45,1);
		wait 1.2;
		trap5b rotateRoll (-45,1);
		trap5d rotateRoll (45,1);
		wait 1.2;
		trap5b rotateRoll (45,1);
		trap5d rotateRoll (-45,1);
		wait 1.2;
	}
}


trap9()
{
	trap8 = getent ("trap8","targetname");
	trap9_trig = getent ("trap9_trig","targetname");
	
	trap9_trig waittill ("trigger");
	trap9_trig delete ();

	{
		trap8 notSolid();
	}
}

trap8()
{
	trap8_trigger = getent("trap8_trig","targetname"); //acti trigger
	fire18 = getent("fire18","targetname"); 
	fire48 = getent("fire48","targetname"); 
	fire1_hurt = getent("trap8_h1","targetname"); 
	fire2_hurt = getent("trap8_h2","targetname"); 
	FX = undefined;
	FX2 = undefined;

	fire1_hurt thread maps\mp\_utility::triggerOff();
	fire2_hurt thread maps\mp\_utility::triggerOff();
	// Wachten tot op de knop wordt gedrukt
}

badmusic()
{
	dem = getent("secret","targetname");

	dem waittill("trigger", player);
	dem delete();

	ambientStop();
	ambientPlay("promised");
}

tele1()
{
	tele1_trig = getEnt ("tele1_trig", "targetname");
	tele1 = getEnt ("tele1", "targetname");
	
	for(;;)
	{
		tele1_trig waittill ("trigger", player);
		
		player SetOrigin(tele1.origin);
		player SetPlayerAngles( tele1.angles );
	}
}

tele2()
{
	tele2_trig = getEnt ("tele2_trig", "targetname");
	tele2 = getEnt ("tele2", "targetname");
	
	for(;;)
	{
		tele2_trig waittill ("trigger", player);
		
		player SetOrigin(tele2.origin);
		player SetPlayerAngles( tele2.angles );
	}
}

tele3()
{
	tele3_trig = getEnt ("tele3_trig", "targetname");
	tele3 = getEnt ("tele3", "targetname");
	
	for(;;)
	{
		tele3_trig waittill ("trigger", player);
		
		player SetOrigin(tele3.origin);
		player SetPlayerAngles( tele3.angles );
	}
}

telejumper()
{
	telejumper = getEnt ("telejumper", "targetname");
	jumper_origin = getEnt ("jumper_origin", "targetname");
	
	for(;;)
	{
		telejumper waittill ("trigger", player);
		
		player SetOrigin(jumper_origin.origin);
		player SetPlayerAngles( jumper_origin.angles );
	}
}

teleacti()
{
	teleacti = getEnt ("teleacti", "targetname");
	acti_origin = getEnt ("acti_origin", "targetname");
	
	for(;;)
	{
		teleacti waittill ("trigger", player);
		
		player SetOrigin(acti_origin.origin);
		player SetPlayerAngles( acti_origin.angles );
	}
}

oldroom()
{
level.old_trigger = getEnt( "endgame", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");

level.old_trigger setHintString("");
level.sniper_trigger setHintString("");
level.shot_trigger setHintString("");
level.knife_trigger setHintString("");

jumpk1 = getEnt( "jumper_orig", "targetname" ); //the origin the jumper will teleport
actik1 = getEnt( "acti_orig", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.old_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.old_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.knife_trigger delete();
        level.shot_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        
	player SetPlayerAngles( jumpk1.angles );
	player setOrigin( jumpk1.origin ); //teleports the jumper
	//player TakeAllWeapons(); //takes all weapons from jumper
	//player GiveWeapon( "knife_mp" ); //jumper weapon 
	//wait 0.05;
	//player SwitchToWeapon("knife_mp");
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2goes old!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik1.angles );
		level.activ setOrigin( actik1.origin ); //teleports acti
		//level.activ TakeAllWeapons(); //takes all weapons from acti
		//level.activ GiveWeapon( "knife_mp" ); //gives acti tomahawk
		//wait 0.05;
		//level.activ SwitchToWeapon( "knife_mp" ); //this line means they switch to the weapon
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		//while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

sniperroom()
{
level.old_trigger = getEnt( "endgame", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
jumpk1 = getEnt( "jumper_orig", "targetname" ); //the origin the jumper will teleport
actik1 = getEnt( "acti_orig", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.sniper_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.sniper_trigger ) ) //defines that it is the knife trigger
	return;

		level.knife_trigger delete();
        level.old_trigger delete();
        level.shot_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        
	player SetPlayerAngles( jumpk1.angles );
	player setOrigin( jumpk1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "remington700_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("remington700_mp");
	player giveMaxAmmo("remington700_mp"); 
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2goes sniper!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik1.angles );
		level.activ setOrigin( actik1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "remington700_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "remington700_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("remington700_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

kniferoom()
{
level.old_trigger = getEnt( "endgame", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
jumpk1 = getEnt( "jumper_orig", "targetname" ); //the origin the jumper will teleport
actik1 = getEnt( "acti_orig", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.knife_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.knife_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.shot_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        
	player SetPlayerAngles( jumpk1.angles );
	player setOrigin( jumpk1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "knife_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("knife_mp");
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2goes knife!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik1.angles );
		level.activ setOrigin( actik1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "knife_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "knife_mp" ); //this line means they switch to the weapon
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

shotroom()
{
level.old_trigger = getEnt( "endgame", "targetname"); //The trigger
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.knife_trigger = getent("knife_trig","targetname");
jumpk1 = getEnt( "jumper_orig", "targetname" ); //the origin the jumper will teleport
actik1 = getEnt( "acti_orig", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.shot_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.shot_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered
        
	player SetPlayerAngles( jumpk1.angles );
	player setOrigin( jumpk1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "m1014_grip_mp" ); //jumper weapon 
	wait 0.05;
	player SwitchToWeapon("m1014_grip_mp");
	player giveMaxAmmo("m1014_grip_mp"); 
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2goes shotgun!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik1.angles );
		level.activ setOrigin( actik1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "m1014_grip_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "m1014_grip_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("m1014_grip_mp");
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000; 
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}
		
	}
	
}

trap6() //Artillery trap
{
	trap6_trigger = getent("trap6_trig","targetname"); //acti trigger
	level.plane_start = getent("plane_start","targetname"); 
	level.plane_end = getent("plane_end","targetname"); 
	//level.strikecoord = getent("trap3_exp","targetname"); 
	level.trap6_kill = getent("trap6_kill","targetname"); 

	level.trap6_kill thread maps\mp\_utility::triggerOff();


	
}

callStrike()
{	
	// Get starting and ending point for the plane
	owner = level.activ;
	direction = level.plane_start.angles;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;
	
	startpoint = level.plane_start;
	endPoint = level.plane_end;
	
	// Make the plane fly by
	flyTime = ( 14816 / planeFlySpeed );
	
	level thread doPlaneStrike(startPoint, endPoint, flyTime, direction);
	wait 1;
}

doPlaneStrike(startPoint, endPoint, flyTime, direction)
{
	owner = getentarray( "player", "classname" )[0]; 

	
	// Spawn the planes
	plane = spawnplane(owner, "script_model", startpoint.origin );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	plane thread playPlaneFx();

	wait 0.1;

	plane moveTo( endPoint.origin, flyTime, 0, 0 );

	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );

	wait flyTime / 2;

	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	thread bomb_effect();
	
	// Delete the plane after its flyby
	wait flyTime / 2;
	plane notify( "delete" );
	plane delete();
}

playPlaneFx()
{
	self endon ( "death" );

	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}

bomb_effect()
{
	fx1 = getent("trap6_fx","targetname");  

	level.trap6_kill thread maps\mp\_utility::triggerOn();
	thread killplayers();
	playRumbleOnPosition( "artillery_rumble", fx1 );
	earthquake( 0.7, 0.75, fx1.origin, 5000 );
	PlayFX(level.airstrikefx, fx1.origin);
	fx1 PlaySound("artillery_impact");
	wait 1;
	level.trap6_kill thread maps\mp\_utility::triggerOff();
}

killplayers()
{
	while(1)
	{	
    	level.trap6_kill  waittill ("trigger",user);
		if (user istouching(level.trap3_kill) && isDefined(level.activ))
			{ 
				user FinishPlayerDamage( level.activ, level.activ, 1000, 0, "MOD_PROJECTILE_SPLASH", "artillery_mp", self.origin, self.origin, "none", 0 );		
			}
			wait 0.05;
		if (user istouching(level.trap6_kill) && !isDefined(level.activ))
		{
			user FinishPlayerDamage( self, self, 1000, 0, "MOD_PROJECTILE_SPLASH", "artillery_mp", self.origin, self.origin, "none", 0 );	
		}
	}
}

play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}


delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}


flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}


targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}


targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

callStrike_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}