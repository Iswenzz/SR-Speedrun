main()
{
trigger = spawn( "trigger_radius", (350.749, 197.533, 688.125), 0, 65, 40 );
trigger.targetname = "endmap_trig";
trigger.radius = 65;
    maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attacker"] = "allies";
	game["defender"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";


	////weapons
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

	thread sr\api\_speedrun::createNormalWays("Normal Way");
    
	//secrets
	//thread porntrap();
	//thread porntrap1();

	//credits
	//thread credit();
	//thread printCredits();
	//thread door();
	//thread music();


	//falls
	thread fall1();
	thread fall2();
	thread fall3();

	//traps
	//thread trap1();
	//thread trap2();
	//thread trap4();
	//thread vanish();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();

	//Random shit
	//thread jumper();
	//thread knife();
	//thread old();
	//thread sniper();
	//thread map_finish();
	//thread LastMan();
	//thread jump_tele();
	//thread jump_tele2();
	//thread acti_ammo();
	//thread jumper_ammo();

	///////////////////VIP STUFF//////////////////////////////////
	//thread vip_view();
	//thread vip_teleport();
	//thread kill();
	//thread vip_gun();
	//thread vip_tele();

	//find me & fearz
	//thread findloss();
	//thread findfearz();


	///////////traps for free run//////////////////
	//thread addtrapstofreerun();

}

////////////////////////////random shit///////////////////////////

LastMan()
{
	jump = undefined;
	acti = undefined;

	trigger = getEnt( "last", "targetname" );

	trigger waittill("trigger");
	while(1)
	{
		if( getTeamPlayersAlive( "allies" ) == 1 && getTeamPlayersAlive("allies") == 1 )
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "allies" && isAlive( players[i] ) && !isDefined( jump ) )
				jump = players[i];
				else if( players[i].pers["team"] == "axis" && isAlive( players[i] ) && !isDefined( acti ) )
				acti = players[i];
			}

				teleA = getent("teleporter_activators", "targetname");
				teleJ = getent("teleporter_jumpers", "targetname");

				jump SetPlayerAngles( teleJ.angles );
				jump SetOrigin( teleJ.origin );
				jump FreezeControls(1);
				acti SetPlayerAngles( teleA.angles );
				acti SetOrigin( teleA.origin );
				acti FreezeControls(1);
				wait 3;
				thread minigame();
				wait 9;
				acti FreezeControls(0);
				jump FreezeControls(0);
				break;

		}

	break;
	}
}

minigame()
{
	{
	bar = getEnt ("roll", "targetname");

	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 3;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Welcome to Jumper";
	wait 2;
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"You must jump over the bar and try to survive longer than your opponent";
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"Jumper starts in: &&1...";
	hud_clock SetTimer(6);
	wait 6;
	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"Start Jumping !!";
	wait 1;

	thread DoJumpRoll();
	}
}

DoJumpRoll()
{
	jump = getEnt("roll", "targetname");

	jump rotateYaw( 2880, 40);
	wait 15;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 30 );
	wait 15;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 20 );
	wait 15;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 15);
	wait 10;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 14 );
	wait 9;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 13);
	wait 8;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 12 );
	wait 7;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"Speed increasing in: &&1...";
	hud_clock SetTimer(5);
	wait 5;
	jump RotateYaw( 2880, 11.5 );
	wait 6.5;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.4;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1,0,0);
	hud_clock.label = &"This is the final speed. Good luck !";
	wait 5;

	while(1)
	{
		jump RotateYaw( 2880, 11 );
		wait 11;
	}
}

sniper()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );


	sniper_trigger = getEnt( "trigger_sniper", "targetname" );
	sniper_originj = getEnt ("jumper_enter_snipe", "targetname");
	old_trig = getEnt ("map_finish", "targetname");
	knife_trig = getEnt ("trigger_knife", "targetname");
	jumper_trigger = getEnt( "jumper_trig", "targetname" );

	sniper_trigger waittill ("trigger", player);
	thread sniper_acti();
	old_trig delete();
	jumper_trigger delete();
	knife_trig delete();

	iprintlnbold (player.name + " chose sniper!");

	player FreezeControls (1);
	player SetOrigin(sniper_originj.origin);
	player SetPlayerAngles( sniper_originj.angles );

	player TakeAllWeapons();
	player GiveWeapon("remington700_mp");
	wait 0.01;
	player SwitchToWeapon("remington700_mp");

	wait 2;
	player FreezeControls (0);

	player thread onDeath_sniper();
	wait 0.1;


    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_sniper()
{
	self endon("disconnect");

	self waittill("death");
	thread sniper();
}

sniper_acti()
{
	sniperacti = getEnt ("activator_enter_snipe", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(sniperacti.origin);
			players[i] SetPlayerAngles( sniperacti.angles );

			players[i] TakeAllWeapons();
			players[i] GiveWeapon("remington700_mp");
			wait 0.01;
			players[i] SwitchToWeapon("remington700_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

jumper_ammo()
{
	trig = getEnt( "Snipe_ammo", "targetname" );

	trig waittill ("trigger", who);

	for(;;)
	{

		trig waittill ("trigger", who);


		who takeWeapon( who getCurrentWeapon() );

		who giveWeapon("remington700_mp");
		who GiveMaxAmmo("remington700_mp");
		who SwitchToWeapon("remington700_mp");

		wait 5;

	}
}

acti_ammo()
{
	trig = getEnt( "Snipe_ammo1", "targetname" );

	trig waittill ("trigger", who);

	for(;;)
	{

		trig waittill ("trigger", who);


		who takeWeapon( who getCurrentWeapon() );

		who giveWeapon("remington700_mp");
		who GiveMaxAmmo("remington700_mp");
		who SwitchToWeapon("remington700_mp");

		wait 5;

	}
}

knife()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	acti = undefined;
	jumper = undefined;

	knife_trigger = getEnt ("knife_trig", "targetname");
	jumper = getEnt ("jump_knife_enter", "targetname");
	old_trig = getEnt ("map_finish", "targetname");
	jumper_trigger = getEnt( "jumper_trig", "targetname" );
	sniper_trigger = getEnt( "trigger_sniper", "targetname" );

	knife_trigger waittill ("trigger", player);
	thread knife_acti();
	old_trig delete();
	jumper_trigger delete();
	sniper_trigger delete();

	iprintlnbold (player.name + " chose knife!");

	player FreezeControls (1);
	player SetOrigin(jumper.origin);
	player SetPlayerAngles( jumper.angles );

	player TakeAllWeapons();
	player GiveWeapon("tomahawk_mp");
	wait 0.05;
	player SwitchToWeapon("tomahawk_mp");


	noti = SpawnStruct();
	noti.titleText = "^1Knife fight!";
	noti.notifyText = acti.name + " ^1VS ^7" + jumper.name;
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	wait 5;
	iPrintlnbold ("^13");
	wait 4;
	iPrintlnbold ("^12");
	wait 3;
	iPrintlnbold ("^11");
	wait 2;
	player FreezeControls (0);
	iPrintlnbold ("^1Go!");

	player thread onDeath_knife();
	wait 0.1;


    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_knife()
{
	self endon("disconnect");

	self waittill("death");
	thread knife();
}

knife_acti()
{
	acti = getEnt ("acti_knife_enter", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(acti.origin);
			players[i] SetPlayerAngles( acti.angles );

			players[i] TakeAllWeapons();
			players[i] GiveWeapon("tomahawk_mp");
			wait 0.05;
			players[i] SwitchToWeapon("tomahawk_mp");
			wait 14;
			players[i] FreezeControls (0);
		}
	}
}


old()
{
	old_trig = getEnt ("map_finish", "targetname");
	door = getEnt ("finish_door", "targetname");

	old_trig waittill ("trigger", player);
	knife_trigger = getEnt ("knife_trig", "targetname");
	jumper_trigger = getEnt ("trigger_jumper", "targetname");
	sniper_trigger = getEnt( "trigger_sniper", "targetname" );

	old_trig delete();
	door delete();
	knife_trigger delete();
	jumper_trigger delete();
	sniper_trigger delete();

	iprintlnbold (player.name + " ^2Opened the door!");
}

map_finish()
{
	trig = getEnt ("end_trig", "targetname");

	trig waittill ("trigger", player);
	trig delete();


	iprintlnbold (player.name + " ^1Finished the map first!");
}

jumper()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	jumper_trigger = getEnt( "jumper_trig", "targetname" );
	jumper_originj = getEnt ("enter_jumper_room", "targetname");
	sniper_trigger = getEnt( "trigger_sniper", "targetname" );
	old_trig = getEnt ("map_finish", "targetname");
	knife_trigger = getEnt ("knife_trig", "targetname");

	jumper_trigger waittill ("trigger", player);
	thread jumper_acti();
	old_trig delete();
	sniper_trigger delete();
	knife_trigger delete();

	iprintlnbold (player.name + " chose jumper!");

	player FreezeControls (1);
	player SetOrigin(jumper_originj.origin);
	player SetPlayerAngles( jumper_originj.angles );

	player TakeAllWeapons();
	player GiveWeapon("tomahawk_mp");
	wait 0.01;
	player SwitchToWeapon("tomahawk_mp");

	wait 2;
	player FreezeControls (0);
	iPrintlnbold ("Go!");

	player thread onDeath_jumper();
	wait 0.1;


    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_jumper()
{
	self endon("disconnect");

	self waittill("death");
	thread sniper();
}

jumper_acti()
{
	jumperacti = getEnt ("activator_enter_jump", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(jumperacti.origin);
			players[i] SetPlayerAngles( jumperacti.angles );

			players[i] TakeAllWeapons();
			players[i] GiveWeapon("tomahawk_mp");
			wait 0.01;
			players[i] SwitchToWeapon("tomahawk_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

jump_tele()
{

	trig = getEnt ("jumper_tele_1", "targetname");
	target = getEnt("jump_half","targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
	}
}

jump_tele2()
{

	trig = getEnt ("jumper_tele_2", "targetname");
	target = getEnt("acti_half","targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
	}
}


////////////////////////End Of Random Shit/////////////////////

////////////////////////Secrets////////////////////////////////
porntrap()
{
	trig = getEnt ("porntrap1", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);
		iPrintlnBold( "^1" + player.name + " ^6tried to look at porn but failed!" );
		wait 2;
	}
}

porntrap1()
{
	trig = getEnt ("porntrap2", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
	}
}

secret()
{

	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	level endon( "game_ended" );
	trigger = getent("king", "targetname");
	earth = getEnt ("effectearth", "targetname");
	target = getEnt ("king_exist", "targetname");

	trigger waittill("trigger", who);
	iPrintlnBold( who.name + " ^3is the king^1!" );
	iPrintlnBold( who.name + " ^3he now has a flaming head^1!" );
	Earthquake( 2, 3, earth.origin, 1000 );
	who iprintlnbold ("You have been teleported");
	who SetOrigin(target.origin);
	trigger delete();

	who thread onDeath1();

	while(isAlive(who))
	{
		wait .1;
	}
}

onDeath1()
{
	self endon("disconnect");

	self waittill("death");
}


fall1()
{
	trig = getEnt ("fall_1", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
	}
}

fall2()
{
	trig = getEnt ("fall_2", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
	}
}

fall3()
{
	trig = getEnt ("fall_3", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
	}
}

////////////////////////END OF FALL/////////////////////////////
///////////////////////TRAPS///////////////////////////////////
trap1()
{
	swing = getEnt ("trap1_turn", "targetname");
	trig = getEnt ("trap1_trig", "targetname");

	trig waittill ("trigger");
	trig setHintString("Trap Activated^1!");

	thread exp();

	while( 1 )
	{
		swing rotateroll(-360,5);
		wait 5;
	}
}

exp()
{
	trig = getEnt( "exp", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

trap2()
{
	spike = getEnt ("trap2_spike", "targetname");
	hurt = getEnt ("trap2_hurt", "targetname");
	trig = getEnt ("trap2_trig", "targetname");

    hurt enablelinkto();
    hurt linkto (spike);

	trig waittill ("trigger", who);
	trig setHintString("Trap Activated^1!");

	thread exp2();

	{
		spike moveZ (64,1.5);
		wait 5;
		spike moveZ (-64,1.5);
	}
}

exp2()
{
	trig = getEnt( "exp1", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

trap4()
{
	trig = getEnt ("trap4_trig", "targetname");

	trig waittill ("trigger", who);
    trig setHintString("Trap Activated^1!");

	thread exp3();

	for(;;)
	{
		if( RandomInt(2) == 0 )
		{
			thread kill1();
			break;
		}

		{
			thread kill2();
			break;
		}
	}
}

exp3()
{
	trig = getEnt( "exp4", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

kill1()
{
	trig = getEnt ("trap4_kill1", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
		wait 0.5;
	}
}

kill2()
{
	trig = getEnt ("trap4_kill2", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		who suicide();
		wait 0.5;
	}
}

vanish()
{
	trig = getEnt( "trap5_trig", "targetname" );
	brushGroup1 = getEntArray( "vanish_part1", "targetname" );
	brushGroup2 = getEntArray( "vanish_part2", "targetname" );

	trig waittill( "trigger", who );
	trig setHintString("Trap Activated^1!");

	thread exp4();

	brushGroup1[randomInt(brushGroup1.size)] notSolid();
	brushGroup2[randomInt(brushGroup2.size)] notSolid();
}

exp4()
{
	trig = getEnt( "exp3", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

trap6()
{
	pillar = getEnt ("trap6_pillar", "targetname");
	pillar2 = getEnt ("trap6_pillar2", "targetname");
	trig = getEnt ("trap6_trig", "targetname");

	trig waittill ("trigger");
	trig setHintString("Trap Activated^1!");

	while( 1 )
	{
		pillar rotateroll(360,2);
		wait 0.5;
		pillar2 rotateroll(-360,2);
		wait 0.5;
	}
}

trap7()
{
	trig = getEnt ("trap7_trig", "targetname");
	hurt = getEnt ("trap7_hurt", "targetname");
	door = getEnt ("trap7_door", "targetname");

	trig waittill ("trigger", who);
	trig setHintString("Trap Activated^1!");

	thread exp5();

	hurt enablelinkto();
	hurt linkto (door);

	door moveZ (-200,3);
	wait 10;
	door moveZ (200,3);


}

exp5()
{
	trig = getEnt( "exp5", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

trap8()
{
	trig = getEnt ("trap8_trig", "targetname");
	part1 = getEnt ("trap8_part1", "targetname");
	part2 = getEnt ("trap8_part2", "targetname");
	part3 = getEnt ("trap8_part3", "targetname");
	part4 = getEnt ("trap8_part4", "targetname");
	part5 = getEnt ("trap8_part5", "targetname");
	part6 = getEnt ("trap8_part6", "targetname");
	part7 = getEnt ("trap8_part7", "targetname");

	trig waittill ("trigger");
	trig setHintString("Trap Activated^1!");

	thread exp6();

	{
	thread slowdown();
	thread speedup();

		while(1)
		{
			part1 rotateyaw (360,2);
			part2 rotateyaw (-360,2);
			wait 3;
			part3 rotatepitch (360,2);
			wait 1;
			part4 rotatepitch (-360,2);
			wait 4;
			part5 rotateyaw (360,2);
			part6 rotateroll (360,2);
			wait 4;
			part7 rotateyaw(360,2);
			wait 2;
		}
	}
}

exp6()
{
	trig = getEnt( "exp6", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

slowdown()
{
	trig = getEnt ("trap8_trig2", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		{
		}
	}
}

speedup()
{
	trig = getEnt ("trap8_trig3", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);
		{
		}
	}
}

trap9()
{
	trig = getEnt ("trap9_trig", "targetname");
	part1 = getEnt ("trap9_part1", "targetname");
	part2 = getEnt ("trap9_part2", "targetname");

	trig waittill ("trigger");
	trig setHintString("Trap Activated^1!");

	thread exp7();

	while(1)
	{
		part1 rotateyaw (360,2);
		wait 3;
		part2 rotatepitch (360,2);
		wait 3;
		part1 rotateyaw(-360,2);
		wait 3;
		part2 rotatepitch(-360,2);
		wait 3;
	}
}

exp7()
{
	trig = getEnt( "exp6", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 5 );
	user iprintlnbold ("You got 5xp!");
	trig delete();
}

trap10()
{
	trig = getEnt ("trap10_trig", "targetname");
	clip = getEnt ("trap10_clip", "targetname");

	trig waittill ("trigger");
	trig setHintString("Trap Activated^1!");

	clip moveX (252,1);
	thread hurt();
}

hurt()
{
	trig = getEnt ("trap10_hurt", "targetname");

	for(;;)
	{
		trig waittill ("trigger", who);

		who suicide();
		wait 0.1;
	}
}
////////////////////VIP ROOM/////////////////////////////
vip_exp()
{

	trig = getEnt( "vip_exp", "targetname" );

	trig waittill( "trigger", user );
	user braxi\_rank::giveRankXp( "kill", 250 );
	user iprintlnbold ("You got 250xp! Abuse = removed^1!");
	trig delete();
}

vip_view()
{
	self endon("death");
	self endon("disconnect");
	trig = getent("shader","targetname");

	while(true)
	{
		trig waittill("trigger", user);
		user setClientDvar("r_debugshader", 1); // von 1 - 4
		wait 120;
		user setClientDvar("r_debugshader", 0);
	}
}

vip_teleport()
{
	vip_trig = getEnt( "secret_trig", "targetname" );
	org = getEnt( "secret_org", "targetname" );

	level.accepted1 = "b17ea990e1ba4d8fe5feb364fb93ac5f"; //Lossy
	level.accepted2 = "53f59ceb1fb75d6879f5a0e9d4a5f422"; //Stealth
	level.accepted3 = "cd03d28b7652eb91a6a2d850c743c983"; //Fearz
	level.accepted4 = "af8e6df0e95659a175ef5e3db5027ccc"; //Braxi
	level.accepted5 = "351ec0714311149968270ff89f6491a0"; //iMTroll
	level.accepted6 = "14402f1613bd52b4bd3a6e00c92ca78a"; //Techno
	level.accepted7 = "c65a9331252ee7bfc662c4fb35aedf63"; //Harry
	level.accepted8 = "16b83e37a37e4664852b27a33e1196db"; //Stu
	level.accepted9 = "c2f17019ed88d1c30bbcb853e4bb7802"; //Jericho
	level.accepted10= "562350f7ef4db0b88b1001e5767d830a"; //Morgaan

	while (1)
	{
		vip_trig waittill( "trigger", player );
		tempGuid = player getGUID();

		if(player isTouching(vip_trig) && player useButtonPressed())
		{
			if((tempGuid == level.accepted1) || (tempGuid == level.accepted2) || (tempGuid == level.accepted3) || (tempGuid == level.accepted4) || (tempGuid == level.accepted5) || (tempGuid == level.accepted6) || (tempGuid == level.accepted7) || (tempGuid == level.accepted8) || (tempGuid == level.accepted9) || (tempGuid == level.accepted10))
			{
				player SetOrigin( org.origin );
				player iprintlnbold("^1Teleported Successfully");
			}
            else
            {
                wait 0.5;
                player iprintlnbold ("You are ^1not ^3autorized^7!");
            }
        }
        else
        {
            wait 0.5;
        }
	}
}

kill(trigger)
{
	level endon("game_ended");

	trigger = getEnt ("death", "targetname");

	for(;;)
	{
		trigger waittill("trigger", user);

		if( user isTouching(trigger) && user getGuid() != "b17ea990e1ba4d8fe5feb364fb93ac5f" && user getGuid() != "53f59ceb1fb75d6879f5a0e9d4a5f422" && user getGuid() != "cd03d28b7652eb91a6a2d850c743c983" && user getGuid() != "af8e6df0e95659a175ef5e3db5027ccc"  && user getGuid() != "351ec0714311149968270ff89f6491a0"  && user getGuid() != "14402f1613bd52b4bd3a6e00c92ca78a"  && user getGuid() != "c65a9331252ee7bfc662c4fb35aedf63"  && user getGuid() != "16b83e37a37e4664852b27a33e1196db"  && user getGuid() != "c2f17019ed88d1c30bbcb853e4bb7802"  && user getGuid() != "562350f7ef4db0b88b1001e5767d830a")
			user suicide();
	}
}

vip_tele()
{
	trig = getEnt ("vip_teleport", "targetname");
	target = getEnt ("vip_end", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player iprintlnbold ("^2You've been teleported out the vip room^1");
		player SetPlayerAngles( target.angles );
		player SetOrigin(target.origin);
	}
}

vip_gun()
{
	trigger = getEnt ("vip_gun" , "targetname");

while(1)
	{
	trigger waittill("trigger", user);
		{
			{
			wait 2;
			user iprintLnBold("^4Giving you a random weapon^1...");
			random = randomInt(11);

			if(random == 0)
			{
				user rewardWeapon( "primary", "deserteagle_mp", 100, 500 );
				user iprintLnBold("^1You have recieved a deserteagle");
			}
			if(random == 1)
			{
				user rewardWeapon( "primary", "uzi_mp", 100, 500 );
				user iprintLnBold("^1You have recieved an uzi");
			}
			if(random == 2)
			{
				user rewardWeapon( "primary", "m4_mp", 100, 500 );
				user iprintLnBold("^1You have recieved an m4");
			}
			if(random == 3)
			{
				user rewardWeapon( "primary", "ak47_mp", 100, 500 );
				user iprintLnBold("^1You have recieved an ak47");
			}
			if(random == 4)
			{
				user rewardWeapon( "primary", "g3_mp", 100, 500 );
				user iprintLnBold("^1You have recieved a g3");
			}
			if(random == 5)
			{
				user rewardWeapon( "primary", "m60e4_mp", 100, 500 );
				user iprintLnBold("^1You have recieved an m60");
			}
			if(random == 6)
			{
				user rewardWeapon( "primary", "p90_mp", 100, 500 );
				user iprintLnBold("^1You have recieved a p90");
			}
			if(random == 7)
			{
				user rewardWeapon( "primary", "m40a3_mp", 100, 500 );
				user iprintLnBold("^1You have recieved a m40a3");
			}
			if(random == 8)
			{
				user rewardWeapon( "primary", "barrett_mp", 100, 500 );
				user iprintLnBold("^1You have recieved a barrett 50cal");
			}
			if(random == 9)
			{
				user rewardWeapon( "primary", "g36c_silencer_mp", 100, 0 );
				user iprintLnBold("^1You have recieved a g36c with a silencer attachment");
			}
			if(random == 10)
			{
				user rewardWeapon( "primary", "skorpion_silencer_mp", 100, 500 );
				user iprintLnBold("^1You have recieved an skorpion with a silencer attachment");
			}
			if(random == 11)
			{
				user rewardWeapon( "primary", "saw_grip_mp", 100, 500 );
				user iprintLnBold("^1You have recieved a saw with a grip attachment");
			}
		}
	}
}
}

rewardWeapon( weaponType, weaponName, ammoClip, ammoStock )
{
self endon( "disconnect" );
	if ( weaponType == "primary" )
	{
		self takeWeapon( self getCurrentWeapon() );
		self giveWeapon( weaponName );
		self setWeaponAmmoClip( weaponName, ammoClip );
		self setWeaponAmmoStock( weaponName, ammoStock );
		self switchToWeapon( weaponName );
	}
	else if ( weaponType == "offhand" )
	{
		self giveWeapon( weaponName );
		self setWeaponAmmoClip( weaponName, ammoClip );
		self switchToOffhand( weaponName );
	}
	else // if ( weaponType == "inventory" )
	{
		self giveWeapon( weaponName );
		self setWeaponAmmoClip( weaponName );
		self setWeaponAmmoStock( weaponName );
		self setActionSlot( 3, "weapon", weaponName );
	}
}
/////////////////////////END OF VIP STUFF/////////////////////

/////////////////////////FIND US////////////////
findloss()
{
	wait 10;

	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "fb93ac5f" )
		{
			players[i] GiveWeapon("brick_blaster_mp");
			players[i] GiveMaxAmmo("brick_blaster_mp");
			wait 0.05;
			players[i] SwitchToWeapon("brick_blaster_mp");
		}
	}
}

findfearz()
{
	wait 10;

	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "c743c983" )
		{
			players[i] GiveWeapon("brick_blaster_mp");
			players[i] GiveMaxAmmo("brick_blaster_mp");
			wait 0.05;
			players[i] SwitchToWeapon("brick_blaster_mp");
		}
	}
}
/////////////////////////END OF FIND US////////////////

////////////////////////EXP///////////////////////////


/////////////////traps for free run//////////////////
addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
addtrapstofreerun()
{
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap5_trig");
	addTriggerToList("trap6_trig");
	addTriggerToList("trap7_trig");
	addTriggerToList("trap8_trig");
	addTriggerToList("trap9_trig");
	addTriggerToList("trap10_trig");
}
///////////END of traps for free run//////////////////

////////////////////Credits room////////////////////////////
printCredits()
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
	self.logoText.fontScale = 1.4;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5mp_^9deathrun_^2colourful ^8by Lossy^1!");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^4Helped by ^2Fearz^1! ^3His xfire^0: ^7iqwikscopez");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^4Visit www.lossycreation.weebly.com^1!");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^8My ^3xfire^0: ^7xlossx");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}

credit()
{
	rain = getEnt ("credit_rain", "targetname");

	while(1)
	{
		wait .1;
	}
}

door()
{
	doortrig = getEnt( "credit_door", "targetname" );
	doortrig.doorclosed = true;

	while (1)
	{
		doortrig waittill("trigger", other);
		if(doortrig.doorclosed)
		{
			doortrig thread move(other);
		}
	}

}

move(other)
{

	door_left = getEnt( "credit_left", "targetname" );
	door_right = getEnt( "credit_right", "targetname" );

	self notify("doortrig_finish");
	self.doorclosed = false;;
	door_left movey(-64, 2, 0.5, 0.5);
	door_right movey(64, 2, 0.5, 0.5);
	door_left waittill ("movedone");

	if(isDefined(other) && other isTouching(self))
	{
		while(isDefined(other) && other isTouching(self))
		{
			wait 2; // Wait until 'other' is no longer touching the trigger
		}
	}

	door_left movey(64, 2, 0.5, 0.5);
	door_right movey(-64, 2, 0.5, 0.5);
	door_left waittill ("movedone");
	self.doorclosed = true;
}


music()
{
	trig = getEnt( "music", "targetname");

	trig waittill ("trigger", player);
    trig delete();

	ambientPlay("tooclose");

	{
		noti = SpawnStruct();
		noti.titleText = "^1Song name";
		noti.notifyText = "^1-----^2Alex Clare - Too Close^1-----";
		noti.duration = 5;
		noti.glowcolor = (1,0,0);
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	}
}