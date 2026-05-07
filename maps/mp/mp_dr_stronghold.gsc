
//  ASK FOR PERMISSION BEFORE USING MY SCRIPTS! - Sentrex

main()
{

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";


	thread sr\api\_map::createSpawn((-800, 192, 76), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((2936.16, -932.285, 688.125), 110,120, "normal_0");

	//-----------Precache-----------//

	/*PrecacheShellShock("death");
	PreCacheItem("deserteagle_mp");
	PreCacheItem("uzi_mp");
	PreCacheItem("m4_mp");
	PreCacheItem("ak47_mp");
	PreCacheItem("g3_mp");
	PreCacheItem("m60e4_mp");
	PreCacheItem("p90_mp");
	PreCacheItem("barrett_mp");
	PreCacheItem("g36c_silencer_mp");
	PreCacheItem("brick_blaster_mp");
	PreCacheItem("skorpion_silencer_mp");
	PreCacheItem("saw_grip_mp");
	PreCacheItem("remington700_mp");
	PreCacheModel("playermodel_dnf_duke");
	PreCacheShader("mtl_plr_dnf_duke_body");
	PreCacheShader("mtl_plr_dnf_duke_glasses");
	PreCacheShader("mtl_plr_dnf_duke_glasses_lens");
	PreCacheShader("mtl_plr_dnf_duke_hand");
	PreCacheShader("mtl_plr_dnf_duke_head");*/

	//-----------Effects-----------//

	/*level.brickfx = loadfx ("explosions/brick_chunk");
	level.embersfx = loadfx ("Deathrun/embershighschool");
	level.firefx = loadfx ("fire/window_fire_large");
	level.firefx2 = loadfx ("fire/firelp_med_pm");
	level.disappearfx = loadfx ("Deathrun/disappear");
	level.lavaembersfx = loadfx ("Deathrun/emb_burst_d");
	level.lavaembers2fx = loadfx ("Deathrun/emb_burst_e");
	level.bloodfx = loadfx ("impacts/sniper_escape_blood");
	level.TRAILfx = loadfx ("Deathrun/TRAILv2");
	level.laserfx = loadfx ("Deathrun/laserbig");
	level.rainfx = LoadFX("Deathrun/strongweather");
	level.bloodpoolfx = LoadFX("impacts/deathfx_bloodpool_view_sh");

	rainfx = getEnt( "lightning_fx", "targetname" );
	outside_fire_1 = getEnt( "outside_fire_1", "targetname" );
	outside_fire_2 = getEnt( "outside_fire_2", "targetname" );

	PlayLoopedFX( level.rainfx, 50, (-264, 424, 100) );*/

	//thread lavaembersfx();

	//-----------Variables-----------//

	level.hudYOffset = 10;
	level.time = 18;

	//-----------MapParts-----------//

	//thread cliff();

	thread maindoor();
	//thread maindoor_nosprinting();

	//-----------HUDs-----------//

	//thread warning();
	//thread sentrex();
	//thread maindoorwarn();
	//thread detonation();
	//thread gabe();

	//-----------Traps-----------//

	//thread acti_sniper();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread lasers();
	thread stoploop();
	thread endtrap();
	thread trap13();

	//-----------Secrets-----------//

	//thread spin();
	//thread WS();

	//-----------EffectsOnTrigger-----------//

	//thread brickfx();
	//thread firefx();
	//thread firefxb();
	//thread bloodfx();

	//-----------VIP-----------//

	//thread VIP1();
	//thread VIP2();
	//thread VIP3();
	//thread VIP4();
	//thread VIP5();
	//thread VIP6();
	//thread VIP7();
	//thread VIP8();
	//thread VIP9();
	//thread VIP10();


	//-----------Rooms-----------//

	//thread old();

	//thread snipe();

	//thread jump();
	//thread jumperweapon();
	//thread jumptele_1();
	//thread jumptele_2();

	//thread slide();

	//thread letters();

	//-----------Triggers-----------//




	addTriggerToList( "firefxb_trig");
	addTriggerToList( "firefx_trig");
	addTriggerToList( "lava_trig");
	addTriggerToList( "trap1_trig");
	addTriggerToList( "trap2_trig");
	addTriggerToList( "trap3_trig");
	addTriggerToList( "trap4_trig");
	addTriggerToList( "trap5_trig");
	addTriggerToList( "trap6_trig");
	addTriggerToList( "trap7_trig");
	addTriggerToList( "trap8_trig");
	addTriggerToList( "trap9_trig");
	addTriggerToList( "trap10_trig");
	addTriggerToList( "trap11_trig");
	addTriggerToList( "trap12_trig");
	addTriggerToList( "trap13_trig");
	addTriggerToList( "ff_trig");
	addTriggerToList( "acti_weapon_trig");
}

	//-----------Triggers-----------//

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
	level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

	//-----------VIP-----------//
VIP1()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Syndie
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "300000031";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted1 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP2()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed
	level.accepted7 = "8a9721a7";//Sox

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted2 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP3()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted3 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP4()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted4 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP5()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "300000031";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted5 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP6()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted6 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP7()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted7 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP8()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed
	level.accepted8 = "23930fff";//Sp!der
	level.accepted9 = "8a9721a7";//Sox

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted8 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP9()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed
	level.accepted8 = "23930fff";//Sp!der
	level.accepted9 = "8a9721a7";//Sox

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted9 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

VIP10()
{
	level.accepted1 = "14fd5874";//Sentrex
    level.accepted2 = "7fd24f5f";//Gabe
    level.accepted3 = "65586cbf";//Synd
    level.accepted4 = "35af2071";//BlueSeven
    level.accepted5 = "5cf47233";//Rebecka
	level.accepted6 = "23b75023";//Tail
	level.accepted7 = "b8cdf6c8";//Unnamed
	level.accepted8 = "cdc62aeb";//Sp!der
	level.accepted9 = "8a9721a7";//Sox
	level.accepted10 = "cdc62aeb";//Dani

	while (1)
	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if( ( friend == level.accepted10 ) )
		{
			player iprintlnbold( "--Checking VIP status--" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "VIP ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "CHARACTER ^2ACTIVATED" );
			player detachall();
			player setModel( "playermodel_dnf_duke" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "TRAIL ^2ACTIVATED" );
			wait 1;
			player braxi\_common::cleanScreen();
			player iprintlnbold( "WEAPON ^2ACTIVATED" );
			player giveweapon( "brick_blaster_mp" );
			player switchtoweapon( "brick_blaster_mp" );

			while(isAlive(player))
			{
				PlayFX( level.TRAILfx, player.origin );
				wait 0.1;
			}
		}
	}
}

	//-----------MapParts-----------//

statue()
{
	head = getEnt( "outside_head", "targetname" );
	body = getEnt( "outside_body", "targetname" );

	head moveZ( -80, 15 );
	body moveZ( -80, 15 );
}

maindoor_nosprinting()
{
	trig = getEnt ("maindoor_kick", "targetname");
	hurttrig = getEnt ("maindoor_hurt", "targetname");

	link = getEnt ("maindoor_link", "targetname");

	trig enablelinkto();
	trig linkto(link);

	hurttrig enablelinkto();
	hurttrig linkto(link);

	wait 18.2;

	thread maindoor_nosprint();

	link moveZ(240, 0.001);
	wait 0.1;
	link moveZ(-240, 0.001);
}

maindoor_nosprint()
{
	trig = getEnt ("maindoor_kick", "targetname");

	trig waittill ("trigger", player);

	player AllowSprint(false);

	player ShellShock( "death", 5 );

	player TakeAllWeapons();
	player GiveWeapon ("knife_mp");
	player SwitchToWeapon ("knife_mp");

	player iprintlnbold ("^1Whoops! I bet that hurt? Now you can't run! Good luck! c:");
	player iprintlnbold ("^1Looks like you dropped your weapon as well! Oh dear!");

	player iprintln ("Stand away from the door next time.");

}

maindoor()
{
	hole = getEnt ("maindoor", "targetname");
	kick = getEnt ("maindoor_kick", "targetname");
	hurt_link = getEnt ("maindoor_link", "targetname");
	c4 = getEnt ("maindoor_c4", "targetname");
	c4b = getEnt ("maindoor_c4b", "targetname");
	c4c = getEnt ("maindoor_c4c", "targetname");
	c4d = getEnt ("maindoor_c4d", "targetname");
	c4e = getEnt ("maindoor_c4e", "targetname");
	maindoor_sound = getEnt ("maindoor_sound","targetname");
	maindoor_kick = getEnt ("maindoor_quake", "targetname");

	maindoor_org1 = getEnt ("maindoor_fx1", "targetname");
	maindoor_org2 = getEnt ("maindoor_fx2", "targetname");
	maindoor_org3 = getEnt ("maindoor_fx3", "targetname");
	maindoor_org4 = getEnt ("maindoor_fx4", "targetname");
	maindoor_org5 = getEnt ("maindoor_fx5", "targetname");
	maindoor_org6 = getEnt ("maindoor_fx6", "targetname");
	maindoor_org7 = getEnt ("maindoor_fx7", "targetname");
	maindoor_org8 = getEnt ("maindoor_fx8", "targetname");
	maindoor_org9 = getEnt ("maindoor_fx9", "targetname");
	maindoor_org10 = getEnt ("maindoor_fx10", "targetname");
	maindoor_org11 = getEnt ("maindoor_fx11", "targetname");

    wait 0.1;


	c4 delete();
	c4b delete();
	c4c delete();
	c4d delete();
	c4e delete();
	hole delete();
}


warning()
{
	warn = getEnt ( "turretwarning", "targetname" );

	warn waittill("trigger", user);
	warn delete();

	if (!isdefined (level.activ) )
	{
		thread warn();
	}
	else
	{
		level.activ iprintlnbold ( "Carefull, they can shoot back!" );
		thread warn();
	}
}

cliff()

{
	trig = getEnt("cliffedge_trig","targetname");
	quake = getEnt("quake","targetname");
	sound = getEnt("sound","targetname");

	cliff1 = getEnt ("cliff1", "targetname");
	cliff2 = getEnt ("cliff2", "targetname");
	cliff3 = getEnt ("cliff3", "targetname");
	cliff4 = getEnt ("cliff4", "targetname");
	cliff5 = getEnt ("cliff5", "targetname");
	cliff6 = getEnt ("cliff6", "targetname");
	cliff7 = getEnt ("cliff7", "targetname");

	trig waittill("trigger", user);

	sound PlaySound( "elm_quake_sub_rumble");
	Earthquake( 0.4, 1, sound.origin, 500 );

	cliff1 moveZ(-192, 0.5);
	cliff1 rotateRoll(754, 0.5);
	cliff1 rotateYaw(453, 0.5);
	cliff1 rotatePitch(360, 0.5);
	cliff2 moveZ(-192, 1);
	cliff2 rotateRoll(674, 1);
	cliff2 rotateYaw(485, 1);
	cliff2 rotatePitch(650, 1);
	cliff3 moveZ(-192, 1);
	cliff3 rotateRoll(454, 1);
	cliff3 rotateYaw(875, 1);
	cliff3 rotatePitch(340, 1);
	cliff4 moveZ(-192, 0.7);
	cliff4 rotateRoll(764, 0.7);
	cliff4 rotateYaw(955, 0.7);
	cliff4 rotatePitch(240, 0.7);
	cliff5 moveZ(-192, 1);
	cliff5 rotateRoll(764, 1);
	cliff5 rotateYaw(325, 1);
	cliff5 rotatePitch(860, 1);
	cliff6 moveZ(-192, 1.5);
	cliff6 rotateRoll(344, 1.5);
	cliff6 rotateYaw(125, 1.5);
	cliff6 rotatePitch(650, 1.5);
	cliff7 moveZ(-192, 1.8);
	cliff7 rotateRoll(344, 1.8);
	cliff7 rotateYaw(125, 1.8);
	cliff7 rotatePitch(650, 1.8);


}

	//-----------Traps-----------//

acti_sniper()
{
	sniper = getEnt( "acti_weapon", "targetname" );
	acti_sniper_trig = getEnt( "acti_weapon_trig", "targetname" );
	take = getEnt( "acti_takeweapon", "targetname" );

	acti_sniper_trig waittill( "trigger", user );
	acti_sniper_trig delete();
	sniper delete();

	user giveweapon( "m40a3_mp" );
	user switchtoweapon( "m40a3_mp" );

	take waittill( "trigger", user );

	user takeallweapons();
	user giveweapon( "tomahawk_mp" );
	user switchtoweapon( "tomahawk_mp" );
}

trap1()
{
	poles = getEnt("trap1_poles", "targetname");
	trig = getEnt("lava_trig", "targetname");
	org1 = getEnt ("trap1_fx1", "targetname");
	org2 = getEnt ("trap1_fx2", "targetname");
	org3 = getEnt ("trap1_fx3", "targetname");
	org4 = getEnt ("trap1_fx4", "targetname");
	org5 = getEnt ("trap1_fx5", "targetname");
	org6 = getEnt ("trap1_fx6", "targetname");

	trig waittill("trigger", user);

}

trap2()
{
	stepsa = getEnt ("trap2a", "targetname");
	stepsb = getEnt ("trap2b", "targetname");
	stepsc = getEnt ("trap2c", "targetname");

	steps_trig = getEnt ("trap2_trig", "targetname");

	steps_trig waittill("trigger", user);

}

trap3()
{
	trigger = getEnt("firefx_trig","targetname");
	brush = getEnt("links","targetname");
	hurt = getEnt("trap3hurt","targetname");

	hurt enablelinkto();
	hurt linkto (brush);

	trigger waittill ("trigger", user);

}

trap4()
{
	trigger = getEnt("firefxb_trig","targetname");
	brush = getEnt("linksb","targetname");
	hurt = getEnt("trap3hurtb","targetname");

	hurt enablelinkto();
	hurt linkto ( brush );

	trigger waittill ("trigger", user);

}

trap5()
{
	doors = getEnt ("trap5_doors", "targetname");
	wall = getEnt ("trap5_wallhurt", "targetname");
	link = getEnt ("trap5_link", "targetname");

	parta = getEnt ("trap5a", "targetname");
	partaa = getEnt ("trap5aa", "targetname");
	partb = getEnt ("trap5b", "targetname");
	partc = getEnt ("trap5c", "targetname");
	partd = getEnt ("trap5d2", "targetname");

	trigger = getEnt ("trap5_trig", "targetname");

	wall enablelinkto();
	wall linkto (link);

	trigger waittill ("trigger", user);

}

trap5check()
{
	level.check = getEnt ("trap5_check", "targetname");

	level.check waittill ("trigger", player);

}

trap6()
{
	brusha = getEnt ("trap6a", "targetname");
	brushb = getEnt ("trap6b", "targetname");
	trig = getEnt ("trap6_trig", "targetname");
	link = getEnt ("trap6_link", "targetname");

	trig enableLinkTo();
	trig LinkTo(link);

	trig sethintstring ("Press ^3F ^7to drop the floor! ^5[3 times remaining]");

	trig waittill ("trigger", user);

}

trap7()
{
	brusha = getEnt ("trap7a", "targetname");
	hurta = getEnt ("trap7a_hurt", "targetname");
	brushb = getEnt ("trap7b", "targetname");
	hurtb = getEnt ("trap7b_hurt", "targetname");
	trig = getEnt ("trap7_trig", "targetname");

	hurta enablelinkto();
	hurta linkto (brusha);

	hurtb enablelinkto();
	hurtb linkto (brushb);

	trig waittill ("trigger", user);

}


trap8()
{
	walls = getEnt ("trap8", "targetname");
	trig = getEnt ("trap8_trig", "targetname");

	trig waittill ("trigger", user);

}

trap9()
{
	middle = getEnt ("trap9_mid", "targetname");
	left = getEnt ("trap9_left", "targetname");
	leftb = getEnt ("trap9_leftb", "targetname");
	right = getEnt ("trap9_right", "targetname");
	rightb = getEnt ("trap9_rightb", "targetname");
	left_end = getEnt ("trap9_left_end", "targetname");
	right_end = getEnt ("trap9_right_end", "targetname");
	trig = getEnt ("trap9_trig", "targetname");
	orgleft = getEnt ("trap9_origin_left", "targetname");
	orgright = getEnt ("trap9_origin_right", "targetname");
	orgleftr = getEnt ("trap9_origin_left_return", "targetname");
	orgrightr = getEnt ("trap9_origin_right_return", "targetname");

	trig waittill ("trigger", user);

}

trap10()
{
	pillara = getEnt( "trap10a", "targetname");
	pillarb = getEnt( "trap10b", "targetname");
	pillarc = getEnt( "trap10c", "targetname");
	pillard = getEnt( "trap10d", "targetname");
	pillare = getEnt( "trap10e", "targetname");
	trig = getEnt( "trap10_trig", "targetname");

	trig waittill( "trigger", player);

}

trap11()
{
	head = getEnt( "head", "targetname" );
	body = getEnt( "body", "targetname" );
	hurt = getEnt( "trap11_hurt", "targetname" );
	link = getEnt( "trap11_link", "targetname" );
	actitrig = getEnt( "trap11_trig", "targetname" );
	playertrig = getEnt( "trap11_playtrig", "targetname" );
	blood = getEnt( "trap11_blood", "targetname");

	hurt enableLinkTo();
	hurt LinkTo( link );

	head hide();
	body hide();

	actitrig waittill( "trigger", user );

}


lasers()
{
	lasers = getEnt( "lasers", "targetname" );
	laserlink = getEnt( "laserlink", "targetname" );
	hurt = getEnt( "trap12_hurt", "targetname" );
	start = getEnt( "trap12_start", "targetname" );
	location1 = getEnt( "trap12_1", "targetname" );
	location2 = getEnt( "trap12_2", "targetname" );
	location3 = getEnt( "trap12_3", "targetname" );
	location4 = getEnt( "trap12_4", "targetname" );
	stahp = getEnt( "trap12_trig", "targetname" );
	restriction = getEnt( "trap12_restriction", "targetname" );

	wait 0.1;

	restriction delete();
	lasers delete();
	hurt delete();


}

lasersrotate()
{
	lasers = getEnt( "lasers", "targetname" );

	while(1)
	{
		lasers rotateYaw( 360, 1.5 );
		wait 1.5;
	}
}

stoploop()
{
    lasers = getEnt( "lasers", "targetname" );
	laserlink = getEnt( "laserlink", "targetname" );
    hurt = getEnt( "trap12_hurt", "targetname" );
    trig = getEnt( "trap12_trig", "targetname" );
    stop = getEnt( "trap12_stop", "targetname" );
    link = getEnt( "trap12_link", "targetname" );
    restriction = getEnt( "trap12_restriction", "targetname" );
    start = getEnt( "trap12_start", "targetname" );
	ori = getEnt( "trap12_origin", "targetname" );

	stop enablelinkto();
    stop linkto( link );

	trig waittill ("trigger", user);

}

laserscontinue()
{
	lasers = getEnt( "lasers", "targetname" );
	laserlink = getEnt( "laserlink", "targetname" );
	hurt = getEnt( "trap12_hurt", "targetname" );
	start = getEnt( "trap12_start", "targetname" );
	location1 = getEnt( "trap12_1", "targetname" );
	location2 = getEnt( "trap12_2", "targetname" );
	location3 = getEnt( "trap12_3", "targetname" );
	location4 = getEnt( "trap12_4", "targetname" );
	stahp = getEnt( "trap12_trig", "targetname" );
	restriction = getEnt( "trap12_restriction", "targetname" );


}

endtrap()
{
	trig = getEnt( "ff_trig", "targetname" );

	ff1_trig = getEnt( "ff1_trig", "targetname" );
	ff2_trig = getEnt( "ff2_trig", "targetname" );
	ff3_trig = getEnt( "ff3_trig", "targetname" );
	ff4_trig = getEnt( "ff4_trig", "targetname" );
	ff5_trig = getEnt( "ff5_trig", "targetname" );
	ff6_trig = getEnt( "ff6_trig", "targetname" );
	ff7_trig = getEnt( "ff7_trig", "targetname" );
	ff8_trig = getEnt( "ff8_trig", "targetname" );
	ff9_trig = getEnt( "ff9_trig", "targetname" );
	ff10_trig = getEnt( "ff10_trig", "targetname" );
	ff11_trig = getEnt( "ff11_trig", "targetname" );
	ff12_trig = getEnt( "ff12_trig", "targetname" );
	ff13_trig = getEnt( "ff13_trig", "targetname" );

	link = getEnt( "fftrap_link", "targetname" );

	ff1_trig enableLinkTo();
	ff2_trig enableLinkTo();
	ff3_trig enableLinkTo();
	ff4_trig enableLinkTo();
	ff5_trig enableLinkTo();
	ff6_trig enableLinkTo();
	ff7_trig enableLinkTo();
	ff8_trig enableLinkTo();
	ff9_trig enableLinkTo();
	ff10_trig enableLinkTo();
	ff11_trig enableLinkTo();
	ff12_trig enableLinkTo();
	ff13_trig enableLinkTo();

	ff1_trig LinkTo( link );
	ff2_trig LinkTo( link );
	ff3_trig LinkTo( link );
	ff4_trig LinkTo( link );
	ff5_trig LinkTo( link );
	ff6_trig LinkTo( link );
	ff7_trig LinkTo( link );
	ff8_trig LinkTo( link );
	ff9_trig LinkTo( link );
	ff10_trig LinkTo( link );
	ff11_trig LinkTo( link );
	ff12_trig LinkTo( link );
	ff13_trig LinkTo( link );

	trig waittill( "trigger", user );

}

ff1()
{
	trig = getEnt( "ff1_trig", "targetname" );
	brush = getEnt( "ff1", "targetname" );

	trig waittill( "trigger", player );


}

ff2()
{
	trig = getEnt( "ff2_trig", "targetname" );
	brush = getEnt( "ff2", "targetname" );

	trig waittill( "trigger", player );


}

ff3()
{
	trig = getEnt( "ff3_trig", "targetname" );
	brush = getEnt( "ff3", "targetname" );

	trig waittill( "trigger", player );


}

ff4()
{
	trig = getEnt( "ff4_trig", "targetname" );
	brush = getEnt( "ff4", "targetname" );

	trig waittill( "trigger", player );



}

ff5()
{
	trig = getEnt( "ff5_trig", "targetname" );
	brush = getEnt( "ff5", "targetname" );

	trig waittill( "trigger", player );


}

ff6()
{
	trig = getEnt( "ff6_trig", "targetname" );
	brush = getEnt( "ff6", "targetname" );

	trig waittill( "trigger", player );


}

ff7()
{
	trig = getEnt( "ff7_trig", "targetname" );
	brush = getEnt( "ff7", "targetname" );

	trig waittill( "trigger", player );


}

ff8()
{
	trig = getEnt( "ff8_trig", "targetname" );
	brush = getEnt( "ff8", "targetname" );

	trig waittill( "trigger", player );


}

ff9()
{
	trig = getEnt( "ff9_trig", "targetname" );
	brush = getEnt( "ff9", "targetname" );

	trig waittill( "trigger", player );


}

ff10()
{
	trig = getEnt( "ff10_trig", "targetname" );
	brush = getEnt( "ff10", "targetname" );

	trig waittill( "trigger", player );


}

ff11()
{
	trig = getEnt( "ff11_trig", "targetname" );
	brush = getEnt( "ff11", "targetname" );

	trig waittill( "trigger", player );


}

ff12()
{
	trig = getEnt( "ff12_trig", "targetname" );
	brush = getEnt( "ff12", "targetname" );

	trig waittill( "trigger", player );


}

ff13()
{
	trig = getEnt( "ff13_trig", "targetname" );
	brush = getEnt( "ff13", "targetname" );

	trig waittill( "trigger", player );


}

trap13()
{
	head = getEnt( "head2", "targetname" );
	body = getEnt( "body2", "targetname" );
	hurt = getEnt( "trap13_hurt", "targetname" );
	link = getEnt( "trap13_link", "targetname" );
	actitrig = getEnt( "trap13_trig", "targetname" );
	playertrig = getEnt( "trap13_playtrig", "targetname" );
	blood = getEnt( "trap13_blood", "targetname");

	hurt enableLinkTo();
	hurt LinkTo( link );

	head hide();
	body hide();

	actitrig waittill( "trigger", user );

}

//-----------Effects-----------//

lavaembersfx()
{
	trig = getEnt( "play", "targetname");

	rain = getEnt( "lightning_fx", "targetname" );
	emb2 = getEnt( "lavaembers_2", "targetname");
	emb12 = getEnt( "lavaembers_12", "targetname");
	emb17 = getEnt( "lavaembers_17", "targetname");
	emb21 = getEnt( "lavaembers_21", "targetname");
	emb26 = getEnt( "lavaembers_26", "targetname");
	emb31 = getEnt( "lavaembers_31", "targetname");
	emb34 = getEnt( "lavaembers_34", "targetname");
	emb38 = getEnt( "lavaembers_38", "targetname");

	trig waittill( "trigger", player);
	trig delete();

	AmbientPlay( "background" );

	PlayFX (level.lavaembers2fx, emb2.origin);
	PlayFX (level.lavaembers2fx, emb12.origin);
	PlayFX (level.lavaembers2fx, emb17.origin);
	PlayFX (level.lavaembers2fx, emb21.origin);
	PlayFX (level.lavaembers2fx, emb26.origin);
	PlayFX (level.lavaembers2fx, emb31.origin);
	PlayFX (level.lavaembers2fx, emb34.origin);
	PlayFX (level.lavaembers2fx, emb38.origin);

	wait 5;

	iprintln( "Thanks to ^5UnnamedPlayer ^7& ^5Synd ^7for map testing" );

}

bloodfx()
{
	outside_blood = getEnt( "outside_blood", "targetname" );
	outside_fire = getEnt( "outside_fire_3", "targetname" );
	trig = getEnt( "outsidefire_trig", "targetname" );

	trig waittill( "trigger", user );
	trig delete();

	PlayFX( level.firefx2, outside_fire.origin );
	PlayLoopedFX( level.bloodfx, 4, outside_blood.origin );
}

brickfx()
{
	trigger = getEnt("cliffedge_trig","targetname");
	brickfx = getEnt ("brickfx", "targetname");

	trigger waittill ("trigger", user);
	trigger delete();

	playFX(level.brickfx, brickfx.origin);
}

embersfx()
{
	embersfx = getEnt ("embersfx", "targetname");

	playFX(level.embersfx, embersfx.origin);
}

firefx()
{
	trigger = getEnt("firefx_trig","targetname");
	firefx1 = getEnt ("firehole1", "targetname");
	firefx2 = getEnt ("firehole2", "targetname");
	firefx3 = getEnt ("firehole3", "targetname");

	trigger waittill ("trigger", user);
	trigger delete();

	FX1 = SpawnFX(level.firefx, firefx1.origin);
	FX2 = SpawnFX(level.firefx, firefx2.origin);
	FX3 = SpawnFX(level.firefx, firefx3.origin);

	TriggerFx( FX1 );
	TriggerFx( FX2 );
	TriggerFx( FX3 );                      //start

	while (1)
	{
		wait 2;

		self thread deleteOnWait(FX1);
		self thread deleteOnWait(FX2);
		self thread deleteOnWait(FX3);   //wait 4 then delete

		wait 4;

		self thread showOnWait(FX1);
		self thread showOnWait(FX2);
		self thread showOnWait(FX3);    //wait 1 then show
	}
}

deleteOnWait(fx)
{
	fx hide();
}

showOnWait(fx)
{
	fx show();
}

firefxb()
{
	trigger = getEnt("firefxb_trig","targetname");
	firefx1 = getEnt ("fireholeb1", "targetname");
	firefx2 = getEnt ("fireholeb2", "targetname");
	firefx3 = getEnt ("fireholeb3", "targetname");

	trigger waittill ("trigger", user);
	trigger delete();

	FX1 = SpawnFX(level.firefx, firefx1.origin);
	FX2 = SpawnFX(level.firefx, firefx2.origin);
	FX3 = SpawnFX(level.firefx, firefx3.origin);

	TriggerFx( FX1 );
	TriggerFx( FX2 );
	TriggerFx( FX3 );                      //start

	while (1)
	{
		wait 2;

		self thread deleteOnWait(FX1);
		self thread deleteOnWait(FX2);
		self thread deleteOnWait(FX3);   //wait 4 then delete

		wait 4;

		self thread showOnWait(FX1);
		self thread showOnWait(FX2);
		self thread showOnWait(FX3);    //wait 1 then show
	}
}

	//-----------HUDs-----------//

maindoorwarn()
{
	level.time_hud = newHudElem();
	level.time_hud.foreground = true;
	level.time_hud.alignX = "right";
	level.time_hud.alignY = "top";
	level.time_hud.horzalign = "right";
	level.time_hud.vertalign = "top";
	level.time_hud.x = 0;
	level.time_hud.y = 165;
	level.time_hud.sort = 0;
	level.time_hud.fontScale = 3;
	level.time_hud.color = (2, 0.8, 0.8);
	level.time_hud.font = "objective";
	level.time_hud.glowcolor = (2, 0.8, 0.8);
	level.time_hud.glowAlpha = 1;
	level.time_hud.hidewheninmenu = false;
	level.time_hud setTimer( level.time );
}

detonation()
{
	level.detonation_hud = newHudElem();
	level.detonation_hud.foreground = true;
	level.detonation_hud.alignX = "right";
	level.detonation_hud.alignY = "top";
	level.detonation_hud.horzalign = "right";
	level.detonation_hud.vertalign = "top";
	level.detonation_hud.x = 0;
	level.detonation_hud.y = 150;
	level.detonation_hud.sort = 0;
	level.detonation_hud.fontScale = 1.5;
	level.detonation_hud.color = (2, 0.8, 0.8);
	level.detonation_hud.font = "objective";
	level.detonation_hud.glowcolor = (2, 0.8, 0.8);
	level.detonation_hud.glowAlpha = 1;
	level.detonation_hud.hidewheninmenu = false;
	level.detonation_hud.label = &" Detonation in: ";
}

sentrex()
{
	wait 10.5;

	sentrex_hud = newHudElem();
	sentrex_hud.foreground = true;
	sentrex_hud.alignX = "center";
	sentrex_hud.alignY = "bottom";
	sentrex_hud.horzalign = "center";
	sentrex_hud.vertalign = "bottom";
	sentrex_hud.x = 0;
	sentrex_hud.y = -30;
	sentrex_hud.sort = 0;
	sentrex_hud.fontScale = 3;
	sentrex_hud.color = (2.55, 196, 0);
	sentrex_hud.font = "objective";
	sentrex_hud.glowcolor = (2.55, 196, 0);
	sentrex_hud.glowAlpha = 1;
	sentrex_hud.hidewheninmenu = false;
	sentrex_hud.label = &" Map By Sentrex ";
	sentrex_hud SetPulseFX( 40, 3000, 600 );
}

warn()
{
	hud_warn = NewHudElem();
	hud_warn.alignX = "center";
	hud_warn.alignY = "top";
	hud_warn.horzalign = "center";
	hud_warn.vertalign = "top";
	hud_warn.alpha = 1;
	hud_warn.x = 0;
	hud_warn.y = 0;
	hud_warn.font = "default";
	hud_warn.fontscale = 2;
	hud_warn.glowalpha = 1;
	hud_warn.glowcolor = (0,0,0);
	if (!isdefined (level.activ) )
		hud_warn.label = &" Aaaaahhh! the Activator is on the turret!";
	else
		hud_warn.label = &" Aaaaahhh! + level.activ.name + is on the turret!";
	hud_warn SetPulseFX( 40, 3000, 600 );
}

gabe()
{
	wait 30;

	hud_gabe = NewHudElem();
	hud_gabe.alignX = "center";
	hud_gabe.alignY = "top";
	hud_gabe.horzalign = "center";
	hud_gabe.vertalign = "top";
	hud_gabe.alpha = 1;
	hud_gabe.x = 0;
	hud_gabe.y = 0;
	hud_gabe.font = "objective";
	hud_gabe.fontscale = 2.3;
	hud_gabe.glowalpha = 1;
	hud_gabe.glowcolor = (0,0.157,0.255);
	hud_gabe.label = &"--Special Thanks To Gabe!--";
	hud_gabe SetPulseFX( 40, 3000, 600 );
}

trap5hud()
{
	hud_wallwarn = NewHudElem();
	hud_wallwarn.alignX = "center";
	hud_wallwarn.alignY = "middle";
	hud_wallwarn.horzalign = "center";
	hud_wallwarn.vertalign = "middle";
	hud_wallwarn.alpha = 1;
	hud_wallwarn.x = 0;
	hud_wallwarn.y = 0;
	hud_wallwarn.font = "objective";
	hud_wallwarn.fontscale = 2;
	hud_wallwarn.glowalpha = 1;
	hud_wallwarn.glowcolor = (0,0,0);
	hud_wallwarn.label = &" The walls are now deadly! ";
	hud_wallwarn SetPulseFX( 40, 3010, 600 );
}

VIPhud()
{
	hud_vip = NewHudElem();
	hud_vip.alignX = "left";
	hud_vip.alignY = "bottom";
	hud_vip.horzalign = "left";
	hud_vip.vertalign = "middle";
	hud_vip.x = 0;
	hud_vip.y = -60;
	hud_vip.alpha = 1;
	hud_vip.x = 0;
	hud_vip.y = 0;
	hud_vip.font = "objective";
	hud_vip.fontscale = 2;
	hud_vip.glowalpha = 1;
	hud_vip.glowcolor = (1,1,0);
	hud_vip.label = &"Press ^3F ^7to check VIP status";
	hud_vip SetPulseFX( 40, 3010, 600 );
	wait 3;
}

	//-----------Secret-----------//

walkend()
{
	end = getEnt( "walkend", "targetname" );

	end waittill( "trigger", player );

	random = randomInt(11);

	player iprintlnbold( "Nice! You finished while walking, have a weapon!" );
	player allowSprint( true );
	wait 1;

	if(random == 0)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "deserteagle_mp" );
		player switchtoWeapon( "deserteagle_mp" );
		player iprintLnBold("^3Here, have a deagle!");
	}
	if(random == 1)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "uzi_mp" );
		player switchtoWeapon( "uzi_mp" );
		player iprintLnBold("^3Here, have an uzi!");
	}
	if(random == 2)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "m4_mp" );
		player switchtoWeapon( "m4_mp" );
		player iprintLnBold("^3Here, have an m4!");
	}
	if(random == 3)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "ak47_mp" );
		player switchtoWeapon( "ak47_mp" );
		player iprintLnBold("^3Here, have an ak47!");
	}
	if(random == 4)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "g3_mp" );
		player switchtoWeapon( "g3_mp" );
		player iprintLnBold("^3Here, have a g3!");
	}
	if(random == 5)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "m60e4_mp" );
		player switchtoWeapon( "m60e4_mp" );
		player iprintLnBold("^3Here, have a m60!");
	}
	if(random == 6)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "p90_mp" );
		player switchtoWeapon( "p90_mp" );
		player iprintLnBold("^3Here, have a p90!");
	}
	if(random == 7)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "m40a3_mp" );
		player switchtoWeapon( "m40a3_mp" );
		player iprintLnBold("^3Here, have a m40a3!");
	}
	if(random == 8)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "barrett_mp" );
		player switchtoWeapon( "barrett_mp" );
		player iprintLnBold("^3Here, have a barrett!");
	}
	if(random == 9)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		wait 1;
		player giveWeapon( "g36c_silencer_mp" );
		player switchtoWeapon( "g36c_silencer_mp" );
		player iprintLnBold("^3Here, have a silenced g36c!");
	}
	if(random == 10)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "skorpian_silencer_mp" );
		player switchtoWeapon( "skorpian_silencer_mp" );
		player iprintLnBold("^3Here, have a silenced skorpian!");
	}
	if(random == 11)
	{
		player iprintLnBold("^3Random weapon will be selected");
		wait 1;
		player giveWeapon( "saw_grip_mp" );
		player switchtoWeapon( "saw_grip_mp" );
		player iprintLnBold("^3Here, have a saw with grip!");
	}
}

	//-----------Secrets-----------//

toilet()
{
	trig = getEnt( "toilet_trig", "targetname" );

	trig waittill( "trigger", player );

	player takeallweapons();
	player braxi\_common::clientCmd( "cg_thirdperson 1" );
	iprintlnbold( player.name + " literally eats s***!" );
	//player detachall();
	player setModel( "bathroom_toilet" );
}

spin()
{
	trig = getEnt( "toilet_trig", "targetname" );

	trig waittill( "trigger", user );

	user braxi\_common::clientCmd( "+right" );
	user iprintlnbold( "WEEEEEEEEEEEEEEEEEEEE" );
	wait 20;
	user braxi\_common::clientCmd( "+left" );
}

WS()
{
	trig = getEnt( "WS_swap", "targetname" );

	trig waittill( "trigger", user );

	user braxi\_common::clientCmd( "unbind W; unbind S; bind W +back; bind S +forward" );
	user iprintlnbold( "udrunkm8?" );
	wait 10;
	user braxi\_common::clientCmd( "unbind W; unbind S; bind S +back; bind W +forward" );
}

	//-----------Rooms-----------//

old()
{
	level.old_trig = getEnt( "old_trig", "targetname" );
	door = getEnt( "old_door", "targetname" );
	fx = getEnt( "old_explosion", "targetname" );
	fx2 = getEnt( "old_explosion2", "targetname" );
	fx3 = getEnt( "old_explosion3", "targetname" );

	level.old_trig waittill( "trigger", player );
	level.old_trig delete();
	level.jump_trig delete();
	level.snipe_trig delete();
	level.slide_trig delete();

	playFX(level.brickfx, fx.origin);
	playFX(level.brickfx, fx2.origin);
	playFX(level.brickfx, fx3.origin);
	player playsound( "explosion" );
	wait 0.15;
	door delete();
}

snipe()
{
    level.snipe_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "sniper_origin_jumper", "targetname" );
    acti = getEnt( "sniper_origin_acti", "targetname" );

    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
        return;

		level.jump_trig delete();
		level.old_trig delete();
		level.slide_trig delete();

        player setPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player setMoveSpeedScale( 1 );
        player takeAllWeapons();
        player giveWeapon( "m40a3_mp" );
        player giveMaxAmmo( "m40a3_mp" );
		player iprintlnbold( "Welcome to the sniper room" );
		player iprintlnbold( "You are up against ^1" + level.activ.name + "^7!" );
        level.activ setPlayerAngles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ setMoveSpeedScale( 1 );
        level.activ takeAllWeapons();
        level.activ giveWeapon( "m40a3_mp" );
        level.activ giveMaxAmmo( "m40a3_mp" );
		level.activ iPrintlnBold( "You are up against ^2" + player.name + "^7!" );
		iprintlnbold( "^8" + player.name + "^7 and ^1" + level.activ.name + "^7 are in the sniper room!" );
        wait 0.05;
        player switchToWeapon( "m40a3_mp" );
        level.activ switchToWeapon( "m40a3_mp" );
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
		player braxi\_common::cleanScreen();
    }
}

jump()
{
level.jump_trig = getEnt( "jump_trig", "targetname");
jump = getEnt( "jump_jumper", "targetname" );
acti = getEnt( "jump_acti", "targetname" );

while(1)
	{
		level.jump_trig waittill( "trigger", player );
		if( !isDefined( level.jump_trig ) )
		return;

		level.snipe_trig delete();
		level.old_trig delete();
		level.slide_trig delete();

		player setPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player takeAllWeapons();
		player giveWeapon( "knife_mp");
		player iprintlnbold( "Welcome to the bounce room" );
		player iprintlnbold( "You are up against ^1" + level.activ.name + "^7!" );
		level.activ setPlayerAngles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ takeAllWeapons();
		level.activ giveWeapon( "knife_mp");
		level.activ iPrintlnBold( "You are up against ^2" + player.name + "^7!" );
		iprintlnbold( "^8" + player.name + "^7 and ^1" + level.activ.name + "^7 are in the bounce room!" );
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ switchToWeapon( "knife_mp" );
		while( isAlive( player ) && isDefined( player ) )
		wait 1;
		player braxi\_common::cleanScreen();
	}

}

slide()
{
    level.slide_trig = getEnt( "slide_trig", "targetname");
    jump = getEnt( "slide_jumper", "targetname" );
    acti = getEnt( "slide_acti", "targetname" );

    while(1)
    {
        level.slide_trig waittill( "trigger", player );
        if( !isDefined( level.slide_trig ) )
            return;

        level.old_trig delete();
		level.snipe_trig delete();
		level.jump_trig delete();

        player setPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player setMoveSpeedScale( 2.6 );
        player takeAllWeapons();
        player giveWeapon( "knife_mp" );
		player iprintlnbold( "Welcome to the mystery (slide) room!" );
		player iprintlnbold( "You are up against ^1" + level.activ.name + "^7!" );
        level.activ setPlayerAngles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ setMoveSpeedScale( 2.6 );
        level.activ takeAllWeapons();
        level.activ giveWeapon( "knife_mp" );
		level.activ iPrintlnBold( "You are up against ^2" + player.name + "^7!" );
		iprintlnbold( "^8" + player.name + "^7 and ^1" + level.activ.name + "^7 are in the mystery room!" );
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ switchToWeapon( "knife_mp" );
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
		player braxi\_common::cleanScreen();

    }
}

jumptele_1()

{
	trig = getEnt ("jumptele1", "targetname");
	target = getEnt ("jump_jumper", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}

}

jumptele_2()

{
	trig = getEnt ("jumptele2", "targetname");
	target = getEnt ("jump_acti", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}

}

jumperweapon()
{
    trig = getEnt ("givejumproomwep" , "targetname");

	while(1)
	{
		trig waittill("trigger", player);

		player giveWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		player switchToWeapon( "m40a3_mp" );
  	}
}

letters()
{
	Sletter = getEnt( "Sletter", "targetname" );
	Jletter = getEnt( "Jletter", "targetname" );
	Uletter = getEnt( "?letter", "targetname" );
	wep = getEnt( "jumproomwep", "targetname" );

	Sletter notSolid();
	Jletter notSolid();
	Uletter notSolid();

	while(1)
	{
		Sletter rotateYaw( 360, 2 );
		Jletter rotateYaw( 360, 2 );
		Uletter rotateYaw( 360, 2 );
		wep rotateYaw( 360, 2 );
		wait 2;
	}
}

