/*

	Map created by JR-Imagine / Raid|Slaya
	Scripted by JR-Imagine / Raid|Slaya

*/

//	      _ _____      _____                       _
//	     | |  __ \    |_   _|                     (_)
//	     | | |__) |_____| |  _ __ ___   __ _  __ _ _ _ __   ___
//	 _   | |  _  /______| | | '_ ` _ \ / _` |/ _` | | '_ \ / _ \
//	| |__| | | \ \     _| |_| | | | | | (_| | (_| | | | | |  __/
//	 \____/|_|  \_\   |_____|_| |_| |_|\__,_|\__, |_|_| |_|\___|
//	                                          __/ |
//	                                         |___/

// FGT WTF U DOIN IN MAH SCRIPTS?! GTFO >:(

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
thread sr\api\_map::createSpawnOrigin((352.125, 384, 0.125), 0);
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	SetDvar( "r_specularcolorscale", "1" );

	//Precache Stuff
	precacheModel( "playermodel_baa_joker" );
	precacheModel( "playermodel_dnf_duke" );
	precacheModel( "viewhands_dnf_duke" );
	PrecacheItem( "slaya_deagle" );
	PrecacheItem( "slaya_dsr50" );
	PrecacheItem( "knife_mp" );
	PrecacheItem( "rpg_mp" );
	PrecacheItem( "ak74u_mp" );

	thread way_connect();
	// thread onConnect();
	thread RandomShizzle();
	// thread Traps();
	// thread Rooms();
	thread Secret();

	level.PlayerInRoom = false;

	 a1 = GetEnt("trap8_wall","targetname");
	 a2 = GetEnt("trap8_hurt","targetname");
	 a3 = GetEnt("trap8_trig","targetname");
	 a4 = GetEnt("trap6_sides","targetname");
	 a5 = GetEnt("trap6_laser","targetname");
	 a6 = GetEnt("trap6_hurt","targetname");
	 a7 = GetEnt("trap6_trig","targetname");
	 a8 = GetEnt("trap11_t1","targetname");

	 a1 delete();
	 a2 delete();
	 a3 delete();
	 a4 delete();
	 a5 delete();
	 a6 delete();
	 a7 delete();
	 a8 delete();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

	thread secret_1();

    for(;;)
    {
        level waittill( "connected", player );

    }
}

secret_1()
{
	end = GetEnt("secret_enter_start","targetname");
	trigger = spawn( "trigger_radius", (516,580,60), 0, 70, 90 );

	wait 1;
	trigger.radius = 70;
	thread sr\api\_map::createTriggerFx(trigger, "secret");

	for(;;)
	{
		trigger waittill("trigger", player);

		player SetOrigin( end.origin );
		player SetPlayerAngles( end.angles );
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

xp()
{
	while(1)
	{
	self braxi\_rank::giveRankXp( "", 2000);
	wait 0.1;
	}
}

RandomShizzle()
{
	thread SpawnShizzle();
	//thread credits();
	thread endmap_trigger();
	//thread Music();
	thread GiveSlayaHisSmexyDeagle();
}

GiveSlayaHisSmexyDeagle()
{
	level waittill( "round_started" );
	wait 5;

	players = GetEntArray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		Guid = getSubStr(players[i] getGuid(),24,32);
		if( (Guid == "22b565c8" || Guid == "ed96e33f") && players[i].pers["team"] == "allies" )
		{
			players[i] GiveWeapon( "slaya_deagle" );
			players[i] GiveMaxAmmo( "slaya_deagle" );
			wait .05;
			players[i] SwitchToWeapon( "slaya_deagle" );
			players[i] iPrintlnBold( "^3This map loves you ^7" + players[i].name );
		}
	}
}

endmap_trigger()
{
	door1 = GetEnt("finish_door1","targetname");
	door2 = GetEnt("finish_door2","targetname");
	trig = GetEnt("endmap_trig","targetname");

	// trig waittill("trigger", player);

	//thread Music();

	door1 MoveY(-200, 3);
	door2 MoveY(200, 3);
}

SpawnShizzle()
{
	door = GetEnt("spawn_door","targetname");
	door delete();
}

/*credits()
{
	self endon( "disconnect" );

	if( isDefined( self.credits_text ) )
		self.credits_text Destroy();

	self.credits_text = newHudElem();
	self.credits_text.y = 10;
	self.credits_text.alignX = "center";
	self.credits_text.alignY = "middle";
	self.credits_text.horzAlign = "center";

	self.credits_text.alpha = 0;
	self.credits_text.sort = -3;
	self.credits_text.fontScale = 1.6;
	self.credits_text.archieved = true;

	for(;;)
	{
		self credit_roll( "---^3Mapped & scripted by ^7Raid|^9Slaya^7---", 5 );
		self credit_roll( "---^3www.youtube.com/^9JRImagineBE^7---", 5 );
		self credit_roll( "---^3Have fun ^9nublets^3!^7---", 5 );
		self credit_roll( "---^3Dem ^9Credits^7---", 3.5 );
		self credit_roll( "---^9PC. ^3for being Black^7---", 3.5 );
		self credit_roll( "---^9Staab ^3for being a FGT^7---", 3.5 );
		self credit_roll( "---^9Triton ^3for having sw3g^7---", 3.5 );
		self credit_roll( "---^9Purity ^3for being a smexy mofo^7---", 3.5 );
		self credit_roll( "---^9Lossy ^3because he kept on asking me to put him in the credits^7---", 2 );
		self credit_roll( "---^9Darmuh ^3for no reason because you can't read this fast anyway^7---", .75 );
		self credit_roll( "---Raid|^9Slaya ^3for being a nub mapper^7---", 3.5 );
	}
}*/

credit_roll( msg, time )
{
	self endon( "disconnect" );

	self.credits_text fadeOverTime(1);
	self.credits_text.alpha = 1;
	self.credits_text setText( msg );
	wait( time );
	self.credits_text fadeOverTime(1);
	self.credits_text.alpha = 0;
	wait 1;
}

Traps()
{
	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
	addTriggerToList( "trap6_trig" );
	addTriggerToList( "trap7_trig" );
	addTriggerToList( "trap8_trig" );
	addTriggerToList( "trap9_trig" );
	addTriggerToList( "trap10_trig" );
	addTriggerToList( "trap11_trig" );
	addTriggerToList( "trap12_trig" );

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8_bridge_troll();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
}

trap1()
{
	platform = GetEntArray("trap1_platform","targetname");
	trig = GetEnt("trap1_trig","targetname");

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	for(i=0;i<platform.size;i++)
		platform[i] thread trap1_platform();
}

trap1_platform()
{
	self MoveZ(304, RandomFloatRange(.5, 1.5));
	self waittill( "movedone" );
	self MoveZ(-304, RandomFloatRange(2.5, 5));

	for(;;)
	{
		self RotateYaw(360, .8);
		self waittill( "rotatedone" );
	}
}

trap2()
{
	supports = GetEnt("trap2_supports","targetname");
	platform = GetEnt("trap2_platform","targetname");
	trig = GetEnt("trap2_trig","targetname");

	supports NotSolid();

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	supports MoveZ(-200, 1);
	platform MoveZ(-200, 1);
	platform waittill( "movedone" );
	wait( RandomInt(3) );
	supports MoveZ(200, 1);
	platform MoveZ(200, 1);
	platform waittill( "movedone" );

	for(;;)
	{
		platform RotatePitch(360, 2);
		platform waittill( "rotatedone" );
	}
}

trap3()
{
	spikes = GetEnt("trap3_spikes","targetname");
	spikes_hurt = GetEnt("trap3_spikes_hurt","targetname");
	platform = GetEnt("trap3_platform","targetname");
	trig = GetEnt("trap3_trig","targetname");

	spikes_hurt EnableLinkTo();
	spikes_hurt LinkTo( spikes );

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	trap = RandomInt( 30 );
	if( trap < 10 )
	{
		platform Hide();
		platform NotSolid();
		wait( RandomIntRange(2, 5) );
		platform Show();
		platform Solid();
	}
	else if( trap < 23 )
	{
		spikes MoveZ(80, 1.5);
		wait( RandomIntRange(3, 5) );
		spikes MoveZ(-80, 2);
	}
	else
		platform Delete();
}

trap4()
{
	spinner = GetEnt("trap4_spinner","targetname");
	spinner_hurt = GetEnt("trap4_spinner_hurt","targetname");
	trig = GetEnt("trap4_trig","targetname");

	spinner NotSolid();
	spinner_hurt EnableLinkTo();
	spinner_hurt LinkTo( spinner );

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	spinner thread trap4_spinner_rotate();

	for(;;)
	{
		spinner MoveY(-592, RandomFloatRange(.75, 1.75));
		spinner waittill( "movedone" );
		spinner MoveY(592, RandomFloatRange(.75, 1.75));
		spinner waittill( "movedone" );
	}
}

trap4_spinner_rotate()
{
	for(;;)
	{
		self RotateRoll(360, 1);
		self waittill( "rotatedone" );
	}
}

trap5()
{
	pillars1 = GetEnt("trap5_pillars1","targetname");
	pillars2 = GetEnt("trap5_pillars2","targetname");
	pillars_down = GetEnt("trap5_pillars_down","targetname");
	trig = GetEnt("trap5_trig","targetname");

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	pillars_down MoveZ(-200, 1);
	pillars_down waittill( "movedone" );
	pillars_down Delete();

	for(;;)
	{
		spd = RandomFloatRange(.5, 1.5);
		pillars1 MoveY(160, spd);
		pillars2 MoveY(-160, spd);
		pillars2 waittill( "movedone" );
		wait( RandomFloatRange(.5, .75) );
		spd = RandomFloatRange(.5, 1.5);
		pillars1 MoveY(-160, spd);
		pillars2 MoveY(160, spd);
		pillars2 waittill( "movedone" );
		wait( RandomFloatRange(.5, .75) );
	}
}

trap6()
{
	sides = GetEnt("trap6_sides","targetname");
	laser = GetEnt("trap6_laser","targetname");
	hurt = GetEnt("trap6_hurt","targetname");
	trig = GetEnt("trap6_trig","targetname");

	laser Hide();
	laser NotSolid();
	sides NotSolid();
	hurt EnableLinkTo();
	hurt TriggerOff();

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	for(;;)
	{
		laser Show();
		hurt TriggerOn();
		hurt LinkTo( laser );
		for(i=0;i<RandomIntRange(5, 8);i++)
		{
			sides MoveY(-416, .7);
			laser MoveY(-416, .7);
			laser waittill( "movedone" );
			sides MoveY(416, .7);
			laser MoveY(416, .7);
			laser waittill( "movedone" );
		}
		hurt Unlink();
		hurt TriggerOff();
		laser Hide();
		wait( RandomFloatRange(3, 5) );
	}
}

trap7()
{
	select = RandomInt( 100 );
	if( select < 30 )
	{
		p1 = GetEnt("trap7_p1","targetname");
		p2 = GetEnt("trap7_p3","targetname");
	}
	else if( select < 75 )
	{
		p1 = GetEnt("trap7_p2","targetname");
		p2 = GetEnt("trap7_p4","targetname");
	}
	else if( select < 90 )
	{
		p1 = GetEnt("trap7_p1","targetname");
		p2 = GetEnt("trap7_p4","targetname");
	}
	else
	{
		p1 = GetEnt("trap7_p2","targetname");
		p2 = undefined;
	}

	trig = GetEnt("trap7_trig","targetname");

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	p1 MoveZ(-176, 2);
	if( isDefined( p2 ) )
		p2 MoveZ(-176, 2);

	wait 2;

	p1 Delete();
	if( isDefined( p2 ) )
		p2 Delete();
}

trap8_bridge_troll()
{
	bridge = GetEnt("trap8_bridge_troll","targetname");
	trig = GetEnt("trap8_bridge_troll_trig","targetname");

	trig waittill( "trigger" );

	trig Delete();
	bridge MoveZ(-200, .5);
	bridge waittill( "movedone" );
	bridge Delete();
}

trap8()
{
	wall = GetEnt("trap8_wall","targetname");
	hurt = GetEnt("trap8_hurt","targetname");
	trig = GetEnt("trap8_trig","targetname");

	hurt TriggerOff();
	wall NotSolid();
	wall Hide();

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	hurt TriggerOn();
	wall Show();
	wall Solid();

	wait( RandomFloatRange(4.5, 7) );

	hurt Delete();
	wall Delete();
}

trap9()
{
	tunnel = GetEnt("trap9_tunnel","targetname");
	trig = GetEnt("trap9_trig","targetname");

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	tunnel NotSolid();
	tunnel Hide();

	wait( RandomFloatRange(10, 20) );

	tunnel Show();
	tunnel Solid();
}

trap10()
{
	platform = GetEnt("trap10_platform","targetname");
	spikes = GetEnt("trap10_spikes","targetname");
	hurt = GetEnt("trap10_hurt","targetname");
	trig = GetEnt("trap10_trig","targetname");

	hurt EnableLinkTo();
	hurt LinkTo( spikes );

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	WtfWillDisTrapDo = RandomInt( 20 );
	if( WtfWillDisTrapDo < 10 )
	{
		platform MoveZ(192, 1.25);
		platform waittill( "movedone" );
		wait( RandomFloatRange(3, 6) );
		platform MoveZ(-192, 5);
	}
	else
	{
		spikes MoveZ(-192, 1.25);
		spikes waittill( "movedone" );
		wait( RandomFloatRange(3, 6) );
		spikes MoveZ(192, 5);
	}
}

trap11()
{
	t1 = GetEnt("trap11_t1","targetname");
	trig = GetEnt("trap11_trig","targetname");

	t1 MoveZ(-32, .05);

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	t1 MoveZ(32, .8);
	t1 waittill( "movedone" );

	while(1)
	{
		t1 MoveX(494, .45);
		t1 waittill( "movedone" );
		wait 1.2;
		t1 MoveX(-494, .45);
		t1 waittill( "movedone" );
		wait 1.2;
	}
}

trap12()
{
	p1 = GetEnt("trap12_p1","targetname");
	p2 = GetEnt("trap12_p2","targetname");
	trig = GetEnt("trap12_trig","targetname");

	trig SetHintString("^7Press ^3&&1 ^7to Activate Trap");
	trig waittill( "trigger" );
	trig Delete();

	DisTrapDoes = RandomInt( 20 );
	if( DisTrapDoes < 10 )
	{
		p1 NotSolid();
		p2 Hide();
	}
	else
	{
		p1 Hide();
		p2 NotSolid();
	}
}

Rooms()
{
	thread room_old();
	thread room_snipe();
	thread room_jump();
}

room_old()
{
	level.old_trig = GetEnt("room_old_trig","targetname");
	door1 = GetEnt("room_old_door1","targetname");
	door2 = GetEnt("room_old_door2","targetname");

	level.old_trig waittill( "trigger", player );

	level.snipe_trig Delete();
	level.jump_trig Delete();

	iPrintlnBold( player.name + "^3 has opened Old!" );

	door1 MoveZ(130, 3);
	door2 MoveZ(-130, 3);
}

room_jump()
{
	thread room_jump_fail();
	thread room_jump_sniper();

	level.jump_trig = GetEnt("room_jump_trig","targetname");
    jump = GetEnt( "jump_j", "targetname" );
    acti = GetEnt( "jump_a", "targetname" );

	while(1)
	{
		level.jump_trig waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
				level.old_trig Delete();
			level.PlayerInRoom = true;

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "knife_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "knife_mp" );
	        wait .05;
	        player switchToWeapon( "knife_mp" );
	        level.activ SwitchToWeapon( "knife_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Jump Room";
					noti.notifyText = level.activ.name + " ^6VS^7 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

room_jump_sniper()
{
	trig = GetEnt("room_jump_sniper","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player GiveWeapon("slaya_dsr50");
		player GiveMaxAmmo("slaya_dsr50");
		wait .05;
		player SwitchToWeapon("slaya_dsr50");
	}
}

room_jump_fail()
{
	trig = GetEnt("room_jump_fail","targetname");
	j = GetEnt("jump_j","targetname");
	a = GetEnt("jump_a","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		if( player.pers["team"] == "axis" )
		{
			player SetOrigin( a.origin );
			player SetPlayerAngles( a.angles );
		}
		else
		{
			player SetOrigin( j.origin );
			player SetPlayerAngles( j.angles );
		}
	}
}

room_snipe()
{
	level.snipe_trig = GetEnt("room_snipe_trig","targetname");
    jump = GetEnt( "sniper_j", "targetname" );
    acti = GetEnt( "sniper_a", "targetname" );

	while(1)
	{
		level.snipe_trig waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
				level.old_trig Delete();
			level.PlayerInRoom = true;

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "slaya_dsr50" );
			player GiveMaxAmmo( "slaya_dsr50" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "slaya_dsr50" );
	        level.activ GiveMaxAmmo( "slaya_dsr50" );
	        wait .05;
	        player switchToWeapon( "slaya_dsr50" );
	        level.activ SwitchToWeapon( "slaya_dsr50" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Sniper Room";
					noti.notifyText = level.activ.name + " ^6VS^7 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

Secret()
{
	// thread SecretTrigger1();
	// thread SecretTrigger2();
	// thread SecretTrigger3();

	thread SecretRPG();
	thread SecretEnter();
	thread SecretFail();
	thread SecretFinish();

	thread DeagleSecret();
}

DeagleSecret()
{
	trig = GetEnt("secret_deagle_trig", "targetname");
	model = GetEnt("secret_deagle_model","targetname");

	trig SetHintString( "Press ^3&&1 ^7for Smexy Deagle" );

	trig waittill("trigger", player);

	model Delete();
	trig Delete();

	iPrintlnBold( player.name + "^3 got a Smexy Deagle!" );

	player thread xp();

	player GiveWeapon( "slaya_deagle" );
	player GiveMaxAmmo( "slaya_deagle" );
	wait .05;
	player SwitchToWeapon( "slaya_deagle" );
}

SecretTrigger1()
{
	trig = GetEnt("secret_activate_trig1", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		if( !player.secret_step1 )
		{
			player.secret_step1 = true;
			player.secret_steps_complete++;
			player thread SecretCheckEnter();
		}
	}
}

SecretTrigger2()
{
	trig = GetEnt("secret_activate_trig2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		if( !player.secret_step2 )
		{
			player.secret_step2 = true;
			player.secret_steps_complete++;
			player thread SecretCheckEnter();
		}
	}
}

SecretTrigger3()
{
	trig = GetEnt("secret_activate_trig3", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		if( !player.secret_step3 )
		{
			player.secret_step3 = true;
			player.secret_steps_complete++;
			player thread SecretCheckEnter();
		}
	}
}

SecretCheckEnter()
{
	end = GetEnt("secret_enter_start","targetname");

	if( self.secret_steps_complete == 1 )
	{
		self iprintlnbold( "^3Secret Steps Complete: ^91/3" );
	}
	else if( self.secret_steps_complete == 2 )
	{
		self iprintlnbold( "^3Secret Steps Complete: ^92/3" );
	}
	else if( self.secret_steps_complete == 3 )
	{
		self iprintlnbold( "^3Secret Steps Complete: ^93/3" );

		self SetOrigin( end.origin );
		self SetPlayerAngles( end.angles );
	}
}

SecretEnter()
{
	trig = GetEnt("secret_enter_trig","targetname");
	end = GetEnt("secret_fail1","targetname");

	trig SetHintString( "^3R U READY?!" );

	for(;;)
	{
		trig waittill("trigger", player);

		player SetOrigin( end.origin );
		player SetPlayerAngles( end.angles );
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}

SecretRPG()
{
	triggers = GetEntArray("secret_rpg_trig","targetname");

	for(i=0;i<triggers.size;i++)
		triggers[i] thread SecretRPGTrig();
}

SecretRPGTrig()
{
	for(;;)
	{
		self waittill("trigger", player);

		player GiveWeapon("rpg_mp");
		player GiveMaxAmmo("rpg_mp");
		wait .05;
		player SwitchToWeapon("rpg_mp");
	}
}

SecretFail()
{
	thread SecretFailDoStuff( "secret_fail1_trig", "secret_fail1" );
	thread SecretFailDoStuff( "secret_fail2_trig", "secret_fail2" );
	thread SecretFailDoStuff( "secret_fail3_trig", "secret_fail3" );
}

SecretFailDoStuff( trigger, origin )
{
	trig = GetEnt( trigger, "targetname" );
	org = GetEnt( origin, "targetname" );

	for(;;)
	{
		trig waittill("trigger", player);

		player SetOrigin( org.origin );
		player SetPlayerAngles( org.angles );
	}
}

SecretFinish()
{
	trig = GetEnt("secret_finish_trig","targetname");
	end = GetEnt("secret_finish_end","targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		player thread braxi\_mod::endTimer();
	}
}

// FUNCTIONS //
Music()
{
	songs = [];
	songs[songs.size] = "gold_dust";
	songs[songs.size] = "alive";
	songs[songs.size] = "waiting_all_night";

	selected = songs[ Randomint( songs.size ) ];
	AmbientPlay( selected );
}

addTriggerToList( name, positionOfIconAboveTrap )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

    if( !isDefined( level.icon_origins ) )
        level.icon_origins = [];
    level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
}