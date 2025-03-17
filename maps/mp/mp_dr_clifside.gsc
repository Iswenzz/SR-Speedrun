#include maps\mp\_utility;
//#include maps\mp\jr_util;
main()
{
thread sr\api\_map::createSpawnOrigin((42.125, -64, 16.125), 0);
//Speedex
maps\mp\_load::main();

	// precacheItem("saw_mp");
	// precacheItem("rpg_mp");
	// ambientPlay("ambience");
//maps\mp\_compass::setupMiniMap("compass_map_mp_shipment");

//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
//ambientPlay("ambience");
VisionSetNaked( "mp_clifside");
game["allies"] = "marines";
game["axis"] = "opfor";

game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";
setdvar( "r_specularcolorscale", "5" );

setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
//setdvar("compassmaxrange","1500");
//precacheModel( "viewhands_mohw_marines" );

thread way_connect();
thread water();
// thread trap1();
// thread trap1_x2();
thread trap2();
thread trap3();
// thread trap4();
// thread trap6();
// thread trap7();
thread trap5();
// thread old();
// thread jugg();
thread water_bounce();
thread Water_Move();
// thread rpg();
// thread give_ammo1();
// thread give_ammo();
// thread badmusicv2();

// addTriggerToList( "trap1_trig" );
// addTriggerToList( "trap2_trig" );
// addTriggerToList( "trap3_trig" );
// addTriggerToList( "trap4_trig" );
// addTriggerToList( "trap5_trig" );
// addTriggerToList( "trap6_trig" );
// addTriggerToList( "trap7_trig" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

water()
{
	trig = getent("water", "targetname");
	level.splash_fx = loadfx ("explosions/grenadeExp_water");

	while(true)
	{
		trig waittill ("trigger", who);
		who PlaySound ("splash");
		PlayFX( level.splash_fx, who.origin );
		wait 1;
	}
}
//From rednose's released scripts

trap1()
{
	trap1 = getent("trap1","targetname");
	trap1_trigger = getent("trap1_trig","targetname");
	trap1_fx = getent("trap1_fx","targetname");
	level._effect["water"] = loadfx ("misc/watersplash_large");

	// Wachten tot op de knop wordt gedrukt
	trap1_trigger waittill("trigger");
	trap1_trigger delete();

	trap1 moveZ(-370, 1, 0.5, 0);

	wait 1;
	trap1_fx playsound("big_splash");
	playFX(level._effect["water"], trap1_fx.origin);
	wait 1;
}

trap1_x2()
{
	trap1x2 = getent("trap1_x2","targetname");
	trap1_x2_trigger = getent("trap1_x2_trig","targetname");

	// Wachten tot op de knop wordt gedrukt
	trap1_x2_trigger waittill("trigger");
	trap1_x2_trigger delete();

	trap1x2 moveZ(-370, 1, 0.5, 0);

	//trap1_fxorigin playsound("explosion");
	wait 1;
}


trap2()
{
	chunk = getent("trap2_wreckage","targetname");
	dirt = getent("trap2_dirt","targetname");
	trap2_trigger = getent("trap2_trig","targetname");
	trap2_pole = getent("trap2_pole","targetname");
	trap2_fxorigin = getent("trap2_fx","targetname");
	level._effect["explosion"] = loadfx ("explosions/speedex_biggerexplosion");

	chunk MoveZ(70, 0.01);
	dirt hide();


}

trap4()
{
	trap4_trigger = getent("trap4_trig","targetname");

	// Wachten tot op de knop wordt gedrukt
	trap4_trigger waittill("trigger");
	trap4_trigger delete();

	log1();
}

log1()
{
	log = getent("log","targetname");
	t1 = getent("t1","targetname");
	t2 = getent("t2","targetname");
	t3 = getent("t3","targetname");
	t4 = getent("t4","targetname");
	t5 = getent("t5","targetname");
	t6 = getent("t6","targetname");
	t7 = getent("t7","targetname");
	t8 = getent("t8","targetname");
	t9 = getent("t9","targetname");
	t10 = getent("t10","targetname");
	t11 = getent("t11","targetname");
	log_hurt = getent("log_hurt","targetname");
	log_fx = getent("log_fx","targetname");
	level.splash_fx = loadfx ("explosions/grenadeExp_water");

	log_hurt enableLinkTo();
	log_hurt linkTo(log);

	log moveTo(t1.origin, 0.1);
	wait 0.1;

	while(1)
	{
	log rotateRoll(-2160, 6);
	log moveTo(t2.origin, 1);
	wait 1;
	log moveTo(t3.origin, 0.5);
	wait 0.5;
	log moveTo(t4.origin, 0.3);
	wait 0.3;
	log moveTo(t5.origin, 1.5);
	wait 1.5;
	log moveTo(t6.origin, 0.3);
	wait 0.3;
	log moveTo(t7.origin, 0.3);
	wait 0.3;
	log rotateRoll(-360, 1);
	log moveTo(t8.origin, 0.3);
	wait 0.3;
	log moveTo(t9.origin, 0.1);
	wait 0.1;
	log moveTo(t10.origin, 0.5);
	wait 0.5;
	log_fx playsound("splash");
	playFX(level.splash_fx, log_fx.origin);
	wait 0.5;
	log moveTo(t11.origin, 1);
	wait 1;
	log moveTo(t1.origin, 1);
	wait 1;
	}
}


trap3()
{
	trap3_trigger = getent("trap3_trig","targetname");
	trap3_fxorigin = getent("tank_fx","targetname");

	tank_hurt = getent("tank_hurt","targetname");
	shell = getent("shell","targetname");
	shel_end = getent("shel_end","targetname");
	shel_begin = getent("shel_begin","targetname");
	level._effect["tank_shot"] = loadfx ("muzzleflashes/abrams_flash_wv");

	tank_hurt triggerOff();


}

trap5()
{
	trap5_trigger = getent("trap5_trig","targetname");
	trap5_fxorigin = getent("water_fx","targetname");
	level._effect["water_gush"] = loadfx ("misc/speedex_watergush");
	water_fx_trig = getEnt ( "water_trap_trig", "targetname" );
	FX = undefined;
	water_fx_trig triggerOff();

}

Water_Move()
{
	water1 = getent("water1","targetname");

	while(1)
	{
		water1 MoveZ(20, 4, 1, 1);
		wait 4;
		water1 MoveZ(-20, 4, 1, 1);
		wait 4;
	}
}


water_bounce()
{
	water_fx_trig = getEnt ( "water_trap_trig", "targetname" );


	while(1)
	{
    	water_fx_trig waittill ("trigger",user);
		if (user istouching(water_fx_trig))
		{
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,-1,0)) ), 200 );
		}
	}
}

trap6()
{
	trap6 = getent("trap7","targetname");
	trap6_trigger = getent("trap6_trig","targetname");

	//trap4a rotatePitch(90, 1);
	//trap4b rotatePitch(90, 1);
	// Wachten tot op de knop wordt gedrukt
	trap6_trigger waittill("trigger");
	trap6_trigger delete();

	while(1)
	{
		trap6 moveY(80, 0.5);
		earthquake(0.3, 1, trap6.origin, 200);
		//PlayFX( level.splash_fx, trap4.origin );
		trap6 PlaySound ("stonemove");
		wait 1;
		trap6 moveY(-80, 0.5);
		trap6 PlaySound ("stonemove");
		wait 2.5;
	}
}

trap7()
{
	trap7 = getent("trap8","targetname");
	trap7_trigger = getent("trap7_trig","targetname");

	//trap4a rotatePitch(90, 1);
	//trap4b rotatePitch(90, 1);
	// Wachten tot op de knop wordt gedrukt
	trap7_trigger waittill("trigger");
	trap7_trigger delete();



	while(1)
	{
		trap7 rotateRoll(30, 0.5);
		wait 0.5;
		trap7 rotateRoll(-60, 1);
		wait 1;
		trap7 rotateRoll(30, 0.5);
		wait 0.5;
	}
		//PlayFX( level.splash_fx, trap4.origin );
		//trap6 PlaySound ("stonemove");
}

old()
{
	level.rpg_trig = getEnt( "rpg_trigger", "targetname"); //The trigger
	level.old_trigger = getent("old_trig","targetname");
	level.jug_trigger = getent("jug_trigger","targetname");
	old = getent("old","targetname");
	level.old_trigger = getent("old_trig","targetname");
	old_clip = getent("old_clip","targetname");

	level.old_trigger waittill("trigger");
	level.old_trigger delete();
	 level.jug_trigger delete();
       //level.weapon_trig delete();
      level.rpg_trig delete(); //deletes all of the other room triggers so that they cant be entered

	old MoveZ(-100, 1);
	old_clip delete();
}

jugg()
{
level.jugg_trig = getEnt( "jug_trigger", "targetname"); //The trigger
level.old_trigger = getent("old_trig","targetname");
jump = getEnt( "jumperjug", "targetname" ); //the origin the jumper will teleport
acti = getEnt( "actijug", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.jugg_trig waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.jugg_trig ) ) //defines that it is the knife trigger
	return;

		//level.sniper_trig delete();
        level.old_trigger delete();
        //level.weapon_trig delete();
        level.rpg_trig delete(); //deletes all of the other room triggers so that they cant be entered

	player SetPlayerAngles( jump.angles );
	player setOrigin( jump.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "saw_mp" ); //jumper weapon
	wait 0.05;
	player SwitchToWeapon("saw_mp");
	player giveMaxAmmo(player.pers["weapon"]);
	player sr\api\_player::setPlayerSpeedScale(0.4);
	player setPerk("specialty_armorvest");
	player setModel("body_juggernaut");
	player.maxhealth = 1000;
	player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^5Wants to play around in a jugg suit!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "saw_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "saw_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo(level.activ.pers["weapon"]);
		level.activ sr\api\_player::setPlayerSpeedScale(0.4);
		level.activ setModel("body_juggernaut");
		wait 0.05;
  	  	level.activ.maxhealth = 1000;
  	  	level.activ.health = level.activ.maxhealth;
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("Ready?");
		level.activ IPrintLnBold("Ready?");
		wait 1;
		player IPrintLnBold("Set!");
		level.activ IPrintLnBold("Set!");
		wait 1;
		player IPrintLnBold("Go!");
		level.activ IPrintLnBold("Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		}
	while( isAlive( player ) && isDefined( player ) ) //if the player is alive the room will stay closed so no one can enter.
		wait 1;
	}

}
//Partially from Wingzors backlot

rpg()
{
level.rpg_trig = getEnt( "rpg_trigger", "targetname"); //The trigger
level.old_trigger = getent("old_trig","targetname");
level.jug_trigger = getent("jug_trigger","targetname");
jump1 = getEnt( "tomajump", "targetname" ); //the origin the jumper will teleport
acti1 = getEnt( "tomaacti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.rpg_trig waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.rpg_trig ) ) //defines that it is the knife trigger
	return;

		//level.sniper_trig delete();
        level.old_trigger delete();
        //level.weapon_trig delete();
        level.jug_trigger delete(); //deletes all of the other room triggers so that they cant be entered

	player SetPlayerAngles( jump1.angles );
	player setOrigin( jump1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "rpg_mp" ); //jumper weapon
	wait 0.05;
	player SwitchToWeapon("rpg_mp");
	player giveMaxAmmo("rpg_mp");
	player.maxhealth = 1000;
	player setPerk("specialty_armorvest");
	player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^1Wants to play around with some heavy weaponry!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( acti1.angles );
		level.activ setOrigin( acti1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "rpg_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "rpg_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("rpg_mp");
		level.activ.maxhealth = 1000;
  	  	level.activ.health = level.activ.maxhealth;
  	  	level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("Ready?");
		level.activ IPrintLnBold("Ready?");
		wait 1;
		player IPrintLnBold("Set!");
		level.activ IPrintLnBold("Set!");
		wait 1;
		player IPrintLnBold("Go!");
		level.activ IPrintLnBold("Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;

		}
		while( isAlive( player ) && isDefined( player ) ) //if the player is alive the room will stay closed so no one can enter.
		wait 1;
	}

}

give_ammo1()
{
	ammo1 = getent("ammo_give1","targetname");

	ammo1 setHintString( "Ammo?" );
	while(1)
	{
		ammo1 waittill( "trigger", player );

		player giveMaxAmmo( "rpg_mp" );
		wait 0.05;
	}
}

give_ammo()
{
	ammo = getent("ammo_give","targetname");

	ammo setHintString( "Ammo?" );
	while(1)
	{
		ammo waittill( "trigger", player );

		player giveMaxAmmo( "rpg_mp" );
		wait 0.05;
	}
}

badmusicv2()
{
	dem = getent("music","targetname");

	while(1)
	{
		dem waittill( "trigger", player );

		player playLocalSound("waardeloos");
		wait 0.05;
	}
}

//////////////////////////////////////////////////////////////////////////////
