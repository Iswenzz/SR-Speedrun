/*
Map by Gabriel
Credits for helping: Lossy, Xenon, Darmuh
*/
main()
{
thread sr\api\_map::createSpawnOrigin((-1238, -13, 24), 89);
//-----------------load effects-----------------//

	level.wall_explosion = LoadFX("explosions/wall_explosion_grnd");
	level.fire = LoadFX("fire/firelp_barrel_pm");

//-----------------Dvars-----------------//
	setDvar("r_distortion", "1");
	setDvar("r_specular", "1");
	setDvar( "r_specularcolorscale", "1" );
	setDvar("r_fullbright", "0");
	setDvar("r_drawDecals", "1");
	setDvar("drHideCompass", "1");

//-----------------Precache-----------------//

	precacheModel("playermodel_baa_joker");
	precacheItem("ak74u_mp");

//----------------------------------//

	maps\mp\_load::main();
	//ambientPlay("gramatik");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	addTriggerToList( "trigger_platform" );
	addTriggerToList( "trigger_trap2" );
	addTriggerToList( "trigger_push" );
	addTriggerToList( "trigger_lasers" );
	addTriggerToList( "trigger_floor" );
	addTriggerToList( "trigger_trap5" );
	addTriggerToList( "trigger_blockdrop" );
	addTriggerToList( "trigger_sweeper" );
	addTriggerToList( "trigger_hammer" );
	addTriggerToList( "trigger_wall" );
	addTriggerToList( "trigger_rotate" );
	addTriggerToList( "trigger_thin" );
	addTriggerToList( "trigger_glass" );
//-----------------Threads-----------------//
    thread sr\api\_speedrun::createNormalWays("Normal Way");
        thread sr\api\_speedrun::createTeleporter((-412.483, 1849.74, 664.125), 90, 105, (67, 1927, 725), 268, "freeze");
	//thread nospawnshoot();
	thread startdoor();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread blockdrop();
	//thread opensecret1();
	//thread credits();
	//thread travel();
	thread level1();
	//thread movingplatform1();
	//thread lvl1();
	//thread level0();
	thread nextarea();
	//thread nextareaacti();
	thread laser();
	//thread floor();
	//thread wallexplode();
	//thread jumppad1();
	//thread thin();
	//thread rotate();
	//thread Sniper();
	//thread sniperroom();
	//thread fire();
	//thread Cowboy();
	//thread joker();
	//thread old();
	//thread bounce();
	//thread bouncetele();
	thread glasstrap();
	thread glass();
}
//-----------------Start door & Credits-----------------//
startdoor()
{
	main_door = getent( "door1", "targetname" );
	main_door delete();

}

Credits()
{
	if( isDefined( self.logoText ) )
	self.logoText destroy();

	self.logoText = newHudElem();
	self.logoText.y = 10;
	self.logoText.alignX = "center";
	self.logoText.alignY = "middle";
	self.logoText.horzAlign = "center_safearea";

	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.6;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7>>^7Map By: ^9Gabriel^7<<");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7>>^3www.Raid-gaming.net^7<<");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7>>^7Report bugs to xFire & Steam: ^9epikxgamer^7<<");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}
//-----------------Traps-----------------//

Trap1()
{
	trigger = getEnt ("trigger_platform", "targetname");
	earthquakeorigin = getEnt ("earthquake", "targetname");
	earthquakeorigin1 = getEnt ("earthquakeorigin1", "targetname");
	platform2 = getEnt ("platform2", "targetname");
	platform1 = getEnt ("platform1", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	if( randomInt(2) == 0 )
    {
		platform2 moveZ (-130, 1);
		earthquake( 0.5, 3, earthquakeorigin.origin, 350 );
		earthquake( 0.5, 3, earthquakeorigin1.origin, 50 );
    }
    else
    {
		platform1 moveZ (-130, 1);
		earthquake( 0.5, 3, earthquakeorigin.origin, 350 );
		earthquake( 0.5, 3, earthquakeorigin1.origin, 50 );
    }
}

trap2()
{
	trigger = getEnt ("trigger_trap2", "targetname");
	brush1 = getEnt ("trap2_1", "targetname");
    brush2 = getEnt ("trap2_2", "targetname");
	brush3 = getEnt ("trap2_3", "targetname");
	brush4 = getEnt ("trap2_4", "targetname");
    brush5 = getEnt ("trap2_5", "targetname");
	brush6 = getEnt ("trap2_6", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	while(1)
	{
		brush1 rotateYaw(360, 1);
		brush5 rotateYaw(360, 1);
		brush3 rotateYaw(360, 1);
		wait 1;
		brush2 rotateYaw(360, 1);
		brush4 rotateYaw(360, 1);
		brush6 rotateYaw(360, 1);
		wait 1;
	}
}

trap3()
{
	trigger = getEnt ("trigger_push", "targetname");
	brush1 = getEnt ("push_1", "targetname");
    brush2 = getEnt ("push_2", "targetname");
	brush3 = getEnt ("push_3", "targetname");
	brush4 = getEnt ("push_4", "targetname");
	brush5 = getEnt ("push_antibug", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	while(1)
	{
		brush1 moveY(-170, 1);
		brush3 moveY(-170, 1);
		brush2 moveY(-170, 1);
		brush4 moveY(-170, 1);
		brush5 moveY(-170, 1);
		brush1 waittill("movedone");
		brush1 moveY(170, 1);
		brush3 moveY(170, 1);
		brush2 moveY(170, 1);
		brush4 moveY(170, 1);
		brush5 moveY(170, 1);
		brush1 waittill("movedone");
	}
}

trap5()
{
	trigger = getEnt ("trigger_trap5", "targetname");
	spin = getEnt ("trap5", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	for(;;)
	{
		spin rotateYaw(360, 4);
		wait 0.1;
	}
}

trap6()
{
	trigger = getEnt ("trigger_sweeper", "targetname");
	sweeper = getEnt ("sweeper", "targetname");
	sweeper1 = getEnt ("sweeper1", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	for(;;)
	{
		sweeper moveX(688, 4);
		sweeper waittill("movedone");
		sweeper1 moveX(688, 4);
		wait 1.3;
		sweeper moveX(-688, 4);
		sweeper1 waittill("movedone");
		sweeper1 moveX(-688, 4);
		sweeper1 waittill("movedone");
		wait 2;
	}
}

trap7()
{
	trigger = getEnt ("trigger_hammer", "targetname");
	hammer1 = getEnt ("hammer_1", "targetname");
	hammer2 = getEnt ("hammer_2", "targetname");
	hammer3 = getEnt ("hammer_3", "targetname");
	hammer4 = getEnt ("hammer_4", "targetname");
	killtrigger1 = getEnt ("hurt_hammer1", "targetname");
	killtrigger2 = getEnt ("hurt_hammer2", "targetname");
	killtrigger3 = getEnt ("hurt_hammer3", "targetname");
	killtrigger4 = getEnt ("hurt_hammer4", "targetname");
	cylinder = getEnt ("cylinder", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	cylinder rotatepitch (360, 2);
	killtrigger1 enablelinkto ();
	killtrigger1 linkTo (hammer1);
	hammer1 rotatepitch (360, 2);
	wait 0.5;
	killtrigger2 enablelinkto ();
	killtrigger2 linkTo (hammer2);
	hammer2 rotatepitch (360, 2);
	wait 0.5;
	killtrigger3 enablelinkto ();
	killtrigger3 linkTo (hammer3);
	hammer3 rotatepitch (360, 2);
	wait 0.5;
	killtrigger4 enablelinkto ();
	killtrigger4 linkTo (hammer4);
	hammer4 rotatepitch (360, 2);

	for(;;)
	{
		cylinder rotatepitch (360, 2);
		hammer1 rotatepitch (360, 2);
		hammer2 rotatepitch (360, 2);
		hammer3 rotatepitch (360, 2);
		hammer4 rotatepitch (360, 2);
		wait 0.1;
	}
}

blockdrop()
{
	trigger = getEnt ("trigger_blockdrop", "targetname");
	blockdrop = getEnt ("blockdrop", "targetname");
	killtrigger = getEnt ("hurt_blockdrop", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	killtrigger enablelinkTo ();
	killtrigger linkTo (blockdrop);
	blockdrop moveZ(-264, 0.2);
	blockdrop waittill("movedone");
	wait 2;
	blockdrop moveZ(264, 3);
}

laser()
{
	laser1 = getEnt ("laser1", "targetname");
	laser2 = getEnt ("laser2", "targetname");
	laser3 = getEnt ("laser3", "targetname");
	laser4 = getEnt ("laser4", "targetname");
	laser5 = getEnt ("laser5", "targetname");
	laser6 = getEnt ("laser6", "targetname");
	killtrigger_laser1 = getEnt ("killtrigger_laser1", "targetname");
	killtrigger_laser2 = getEnt ("killtrigger_laser2", "targetname");
	killtrigger_laser3 = getEnt ("killtrigger_laser3", "targetname");
	killtrigger_laser4 = getEnt ("killtrigger_laser4", "targetname");
	killtrigger_laser5 = getEnt ("killtrigger_laser5", "targetname");
	killtrigger_laser6 = getEnt ("killtrigger_laser6", "targetname");
	trigger = getEnt ("trigger_lasers", "targetname");

	laser1 notSolid();
	laser2 notSolid();
	laser3 notSolid();
	laser4 notSolid();
	laser5 notSolid();
	laser6 notSolid();
	killtrigger_laser1 delete();
	killtrigger_laser2 delete();
	killtrigger_laser3 delete();
	killtrigger_laser4 delete();
	killtrigger_laser5 delete();
	killtrigger_laser6 delete();
	trigger delete();


}

floor()
{
	floor = getEnt ("floor", "targetname");
	floor1 = getEnt ("floor1", "targetname");
	trigger = getEnt ("trigger_floor", "targetname");
	explosion_ori = getEnt ("explosion_ori", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	wait 0.5;
	playFx( level.wall_explosion, explosion_ori.origin );
	explosion_ori PlaySound("exp_suitcase_bomb_stereo");
	earthquake( 0.5, 3, explosion_ori.origin, 450 );

	floor delete();
	floor1 delete();
}

wallexplode()
{
	trigger = getEnt ("trigger_wall", "targetname");
	wall = getEnt ("wall_explode", "targetname");
	wall_ori = getEnt ("wall_ori", "targetname");
	killtrigger = getEnt ("wall_hurt", "targetname");
	wall_link = getEnt ("wall_link", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	wait 0.5;
	playFx( level.wall_explosion, wall_ori.origin );
	wall_ori PlaySound("exp_suitcase_bomb_stereo");
	earthquake( 0.5, 3, wall_ori.origin, 400 );
	wait 0.1;

	wall delete();

	killtrigger enablelinkTo ();
	killtrigger linkTo (wall_link);
	wall_link moveX(-264, 0.01);
	wait 2.5;

	wall_link delete();
	killtrigger delete();
}

thin()
{
	thin1 = getEnt ("thin1", "targetname");
	thin2 = getEnt ("thin2", "targetname");
	thin3 = getEnt ("thin3", "targetname");
	thin4 = getEnt ("thin4", "targetname");
	thin5 = getEnt ("thin5", "targetname");
	thin6 = getEnt ("thin6", "targetname");
	trigger = getEnt ("trigger_thin", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	thin1 rotateYaw (90, 2);
	thin2 rotateYaw (90, 2);
	thin3 rotateYaw (90, 2);
	thin4 rotateYaw (90, 2);
	thin5 rotateYaw (90, 2);
	thin6 rotateYaw (90, 2);
}

rotate()
{
	rotate = getEnt ("rotate", "targetname");
	trigger = getEnt ("trigger_rotate", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger waittill ("trigger", player);
	trigger setHintString ("^3Trap ^9Activated");

	trigger delete();

	for(;;)
	{
		rotate moveX (96, 3);
		rotate waittill("movedone");
		rotate moveX (-96, 3);
		rotate waittill("movedone");
	}
}

glass()
{
	glass = getEnt ("glass", "targetname");
    level waittill("round started");
	glass delete();
}

glasstrap()
{
	glass = getEnt ("glass", "targetname");
	trigger = getEnt ("trigger_glass", "targetname");

	trigger setHintString ("^3Press ^9[Use] ^3to Activate");
    trigger delete();
    glass delete();
}

//-----------------Secrets-----------------//

opensecret1()
{
	trigger = getEnt ("openningsecret", "targetname");

	trigger waittill("trigger", player);
	player thread secret1();
	player iprintln ("^5Nice ^8Guess!");
}

secret1()
{
	trigger = getEnt ("trigger_secret_1", "targetname");
	secret1 = getEnt ("secret_1", "targetname");
	secret1door = getEnt ("secret1_door", "targetname");
	target = getEnt ("teleport_target", "targetname");

	secret1door notSolid();

	trigger setHintString ("^6What does this ^8Do?");

	for(;;)
	{
		trigger waittill ("trigger", player);


		player iPrintLnBold ("I think i unlocked a tiny shortcut :s");
		wait 0.7;
		player SetOrigin(target.origin);//this teleports the player :D
		player SetPlayerAngles( target.angles );

		secret1 moveX(-7, 2);
		secret1 waittill ("movedone");
		iPrintLnBold("^2A button was pressed by "+ player.name +"^4:O");
		thread secret2();

		trigger delete();

	}
}

secret2()
{
	trigger = getEnt ("trigger_dmg1", "targetname");

	trigger waittill ("trigger", player);
	thread secret2b();
	trigger delete();
}

secret2b()
{
	trigger = getEnt ("trigger_dmg3", "targetname");

	trigger waittill ("trigger", player);
	thread secret2c();
	trigger delete();
}

secret2c()
{
	trigger = getEnt ("trigger_dmg2", "targetname");
	target = getEnt ("target_secret2", "targetname");

		trigger waittill ("trigger", player);

		thread secrrettele();
		thread teleportfromsecret();

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );

		player iPrintLnBold("^6Welcome ^7To the ^6Secret!");
		iPrintLnBold("^8"+ player.name +" ^5has found the secret :o");
}

secrrettele()
{
	trigger = getEnt ("teleport_secret", "targetname");
	target = getEnt ("target_secret", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		player iPrintLnBold ("^5You have been ^7respawned");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleportfromsecret()
{
	trigger = getEnt ("trigger_finnishedsecret", "targetname");
	target = getEnt ("target_finnishedsecret", "targetname");

		trigger waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );

		iPrintLnBold ("^8"+ player.name +" has completed the ^5secret!");
		player TakeAllWeapons();
		player GiveWeapon( "ak74u_mp" );
		player SetWeaponAmmoClip( "ak74u_mp", 30 );
		player SetWeaponAmmoStock( "ak74u_mp", 5 );
		player switchToWeapon( "ak74u_mp" );
		player iPrintLnBold ("^5Enjoy your ^3Weapon!");
		player braxi\_rank::giveRankXp( "", 10 );
}

//-----------------Other Shit-----------------//

travel()
{
	travel = getEnt ("travel", "targetname");

		travel rotateYaw(180, 0.1);
		travel waittill("movedone");
		wait 0.1;
		travel moveY(200, 0.1);
		travel waittill("movedone");
}

nospawnshoot()
{
	level endon ("map_restart");
	self endon ("death");
	self endon ("joined_spectator");
	self endon ("disconnect");


    thread playerSpawned();
}

playerSpawned()
{
    level waittill( "player_spawn", player );

		if (player.pers["team"] == "allies" && level.freerun == true)
		{
			level waittill( "round_started" );
			player iprintln("^8This map is running the no spawn shoot plugin^8!");
		}
		if (player.pers["team"] == "allies" && level.freerun == false)
		{
			level waittill( "round_started" );
			player iprintln("^8This map is running the no spawn shoot plugin^8!");
			player DisableWeapons();
			wait 1.8;
			player EnableWeapons();
		}
}

//-----------------Next Level-----------------//

nextarea()
{
	trigger = getEnt ("trigger_nextareajumper", "targetname");
	target = getEnt ("target_nextareajumper", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		player iPrintLnBold ("^3Next ^5area!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

level1()
{
	trigger = getEnt ("teleport_level1", "targetname");
	target = getEnt ("teleport_level1_target", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);

		player braxi\_rank::giveRankXp( "", 5 );
		player iPrintLnBold ("^6Next ^5level!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

movingplatform1()
{
	travel1 = getEnt ("travel1", "targetname");

	for(;;)
	{
		travel1 rotateyaw(180, 0.1);
		travel1 waittill("movedone");
        travel1 moveY(200, 0.1);
		travel1 moveY(-424, 2);
		travel1 waittill("movedone");
	}
}

//-----------------Activator teleports-----------------//

nextareaacti()
{
	trigger = getEnt ("trigger_acti_nextarea", "targetname");
	target = getEnt ("target_acti_nextarea", "targetname");

	for(;;)
	{
		trigger setHintString ("^5Press ^6[Use] ^5 to go to the ^8next area ");
		trigger waittill ("trigger", player);

		player iPrintLnBold ("^3Next ^5area!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );

		thread othersideacti();
	}
}

othersideacti()
{
	trigger = getEnt ("trigger_otherside", "targetname");
	target = getEnt ("target_otherside", "targetname");

	for(;;)
	{
		trigger setHintString ("^5Press ^6[Use] ^5 to go to the ^8next area ");
		trigger waittill ("trigger", player);

		player iPrintLnBold ("^3Next ^5area!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

lvl1()
{
	trigger = getEnt ("trigger_teleport_lvl1", "targetname");
	target = getEnt ("target_teleport_lvl1", "targetname");

	for(;;)
	{
		trigger setHintString ("^3Press ^8[Use] ^3to go to ^4level 1");
		trigger waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		player iPrintLnBold("^3Welcome to ^4Level 1");
	}
}

level0()
{
	trigger = getEnt ("trigger_teleport_lvl0", "targetname");
	target = getEnt ("target_teleport_lvl0", "targetname");

	for(;;)
	{
		trigger setHintString ("^3Press ^8[Use] ^3to go to ^4level 0");
		trigger waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		player iPrintLnBold("^3Welcome to ^4Level 0");
	}
}

//-----------------Jump pads-----------------//

jumppad1()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

//-----------------Sniper Room-----------------//

Sniper()
{
	level.snipe_trigger = getEnt( "trigger_sniper", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_acti", "targetname" );

	while(1)
	{
		level.snipe_trigger setHintString ("^5Sniper");
		level.snipe_trigger waittill( "trigger", player );
		if( !isDefined( level.snipe_trigger ) )
			return;

		level.cowboy_trigger delete();
		level.old_trigger delete();
		level.bounce_trigger delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
        level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveMaxAmmo( "m40a3_mp" );
		wait 0.05;
		AmbientStop();
		AmbientPlay("skrillex");
		player switchToWeapon( "remington700_mp" );
		level.activ switchToWeapon( "remington700_mp" );
		iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4SNIPER^7 room^4!" );
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}

sniperroom()
{
	block1 = getEnt ("block1", "targetname");
	block2 = getEnt ("block2", "targetname");
	block3 = getEnt ("block3", "targetname");
	block4 = getEnt ("block4", "targetname");
	block5 = getEnt ("block5", "targetname");
	block6 = getEnt ("block6", "targetname");
	lift = getEnt ("lift", "targetname");

	block1 moveX (-72, 2);
	block2 moveY (-86, 2);
	block3 moveX (-72, 2);
	block4 moveX (144, 2);
	block5 moveY (160, 2);
	block6 moveX (144, 2);
	block6 waittill("movedone");

	for(;;)
	{
		lift moveZ (-552, 3);
		block1 moveX (358, 3);
		block2 moveY (102, 3);
		block3 moveX (358, 3);
		block4 moveX (-432, 3);
		block5 moveY (-376, 3);
		block6 moveX (-432, 3);
		block6 waittill("movedone");
		wait 1.5;
		lift moveZ (552, 4);
		block1 moveX (-358, 3);
		block2 moveY (-102, 3);
		block3 moveX (-358, 3);
		block4 moveX (432, 3);
		block5 moveY (376, 3);
		block6 moveX (432, 3);
		block6 waittill("movedone");
		wait 1.5;
	}
}

//-----------------Cowboy Room-----------------//

Cowboy()
{
	level.cowboy_trigger = getEnt( "trigger_cowboy", "targetname");
	jump = getEnt( "cowboy_jumper", "targetname" );
	acti = getEnt( "cowboy_acti", "targetname" );

	while(1)
	{
		level.cowboy_trigger setHintString ("^5Cowboy");
		level.cowboy_trigger waittill( "trigger", player );
		if( !isDefined( level.cowboy_trigger ) )
			return;

		level.snipe_trigger delete();
		level.old_trigger delete();
		level.bounce_trigger delete();

		player setPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player takeAllWeapons();
		player giveWeapon( "colt44_mp" );
		player giveMaxAmmo( "colt44_mp" );
		player setWeaponAmmoClip( "colt44_mp", 2 );
		player freezeControls( true );
		level.activ setPlayerAngles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ takeAllWeapons();
		level.activ giveWeapon( "colt44_mp" );
		level.activ giveMaxAmmo( "colt44_mp" );
		level.activ setWeaponAmmoClip( "colt44_mp", 2 );
		level.activ freezeControls( true );
		wait 0.05;
		AmbientStop();
		AmbientPlay("skrillex");
		player switchToWeapon( "colt44_mp" );
		level.activ switchToWeapon( "colt44_mp" );
		iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4COWBOY^7 room^4!" );
		wait 1;
		iPrintLnBold ("^15");
		wait 1;
		iPrintLnBold ("^24");
		wait 1;
		iPrintLnBold ("^33");
		wait 1;
		iPrintLnBold ("^42");
		wait 1;
		iPrintLnBold ("^51");
		wait 1;
		iPrintLnBold ("^6SHOOT!");
		player freezeControls( false );
		level.activ freezeControls( false );
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}

/*
fire()
{
	fire1 = getEnt ("fire1", "targetname");
	fire2 = getEnt ("fire2", "targetname");
	fire3 = getEnt ("fire3", "targetname");
	fire4 = getEnt ("fire4", "targetname");
	fire5 = getEnt ("fire5", "targetname");
	fire6 = getEnt ("fire6", "targetname");
	fire7 = getEnt ("fire7", "targetname");
	fire8 = getEnt ("fire8", "targetname");
	fire9 = getEnt ("fire9", "targetname");
	fire10 = getEnt ("fire10", "targetname");
	fire11 = getEnt ("fire11", "targetname");
	fire12 = getEnt ("fire12", "targetname");
	fire13 = getEnt ("fire13", "targetname");
	fire14 = getEnt ("fire14", "targetname");
	fire15 = getEnt ("fire15", "targetname");
	fire16 = getEnt ("fire16", "targetname");
	fire17 = getEnt ("fire17", "targetname");
	fire18 = getEnt ("fire18", "targetname");
	fire19 = getEnt ("fire19", "targetname");
	fire20 = getEnt ("fire20", "targetname");

	for(;;)
	{
		playLoopedFX( level.fire, fire1.origin );
		playLoopedFX( level.fire, fire2.origin );
		playLoopedFX( level.fire, fire3.origin );
		playLoopedFX( level.fire, fire4.origin );
		playLoopedFX( level.fire, fire5.origin );
		playLoopedFX( level.fire, fire6.origin );
		playLoopedFX( level.fire, fire7.origin );
		playLoopedFX( level.fire, fire8.origin );
		playLoopedFX( level.fire, fire9.origin );
		playLoopedFX( level.fire, fire10.origin );
		playLoopedFX( level.fire, fire11.origin );
		playLoopedFX( level.fire, fire12.origin );
		playLoopedFX( level.fire, fire13.origin );
		playLoopedFX( level.fire, fire14.origin );
		playLoopedFX( level.fire, fire15.origin );
		playLoopedFX( level.fire, fire16.origin );
		playLoopedFX( level.fire, fire17.origin );
		playLoopedFX( level.fire, fire18.origin );
		playLoopedFX( level.fire, fire19.origin );
		playLoopedFX( level.fire, fire20.origin );
	}
}
*/

//-----------------VIP-----------------//

joker()
{
	level.accepted1 = "acb016f3"; //Darmuh
	level.accepted2 = "7fd24f5f"; //Gabriel
	level.accepted3 = "fb93ac5f"; //Lossy
	level.accepted4 = "6547f97b"; //Xenon
	level.accepted5 = "abeb6251"; //Beathat
	level.accepted6 = "21c2cce3"; //Rv| Ninja
	level.accepted7 = "35af2071"; //Blueseven
	level.accepted8 = "71633b959"; //Tilak
	level.accepted9 = "006d463d"; //Aod'Daze
	level.accepted10 = "4016b955"; //Triton
	level.accepted11 = "d2045bc6"; //I.NINJA
	level.accepted12 = "b1a7e605"; //Cat

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if((friend == level.accepted1) || (friend == level.accepted2) || (friend == level.accepted3) || (friend == level.accepted4) || (friend == level.accepted5) || (friend == level.accepted6) || (friend == level.accepted7) || (friend == level.accepted8) || (friend == level.accepted9) || (friend == level.accepted10) || (friend == level.accepted11) || (friend == level.accepted12))
		{
			player detachAll();
			player setModel("playermodel_baa_joker");
			player iprintln("^8Joker ^6Skin ^8Enabled");
		}
	}
}

//-----------------Old Room-----------------//

old()
{
	level.old_trigger = getEnt( "trigger_old", "targetname");
	jump = getEnt( "old_jumper", "targetname" );
	acti = getEnt( "old_acti", "targetname" );

	while(1)
	{
		level.old_trigger setHintString ("^5Old");
		level.old_trigger waittill( "trigger", player );
		if( !isDefined( level.old_trigger ) )
			return;

		level.cowboy_trigger delete();
		level.snipe_trigger delete();
		level.bounce_trigger delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		AmbientStop();
		AmbientPlay("skrillex");
		iPrintLnBold( " ^4" + player.name + " ^7has chosen the ^4Old way ^7!" );
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}

//-----------------Bounce Room-----------------//

bounce()
{
	level.bounce_trigger = getEnt( "trigger_bounce", "targetname");
	jump = getEnt ("bounce_jumper", "targetname" );
	acti = getEnt ("bounce_acti", "targetname" );

	while(1)
	{
		level.bounce_trigger setHintString ("^5Bounce");
		level.bounce_trigger waittill( "trigger", player );
		thread bounceweap();
		if( !isDefined( level.bounce_trigger ) )
			return;

		level.cowboy_trigger delete();
		level.old_trigger delete();
		level.snipe_trigger delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "knife_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "knife_mp" );
		wait 0.05;
		AmbientStop();
		AmbientPlay("skrillex");
		player switchToWeapon( "knife_mp" );
		level.activ switchToWeapon( "knife_mp" );
		iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Bounce^7 room^4!" );
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}

bouncetele()
{
	jump = getEnt ("bounce_jumper", "targetname" );
	acti = getEnt ("bounce_acti", "targetname" );
	respawn = getEnt ("bounce_respawn", "targetname");
	for(;;)
	{
		respawn waittill ("trigger", player);
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

bounceweap()
{
	pistol = getEnt ("bounce_pistol", "targetname");

		pistol setHintString ("^2press ^3[Use] ^2to pick up ^5Colt.45");
		pistol waittill ("trigger", player);
		player GiveWeapon( "colt45_mp" );
		player switchToWeapon( "colt45_mp" );

		pistol delete();
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}