main()
{
	level.mortar = LoadFX("explosions/artilleryExp_dirt_brown_low");
	level.fire = LoadFX("fire/mp_deathrun_control");
	level.bru = LoadFX("misc/bitchesbebitches");
	level._effect[ "fire" ] = loadfx("fire/blue_fire");
	PreCacheItem("remington700_mp");
	PreCacheItem("ak47_mp");
	PreCacheItem("deserteagle_mp");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((218,106,76),89);
	thread sr\api\_speedrun::createEndMap((1038.3, -1565.46, 16.125), 110, 100);
	// thread healthpack1();
	// thread jump_blocks();
	// thread jump_blocks2();
	// thread onplayerconnect();
	// thread antiglitch();
	// thread author();
	thread fall();
	// thread fire();
	// thread finish();
	// thread sniper();
	// thread knife();
	// thread jump();
	// thread jump_gun();
	// thread jump_reset();
	// thread trap1();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread givechicken();
	// thread givefire();
	// thread wayout();
	
    addTriggerToList( "trap1_trigger" );
    addTriggerToList( "trap2_trigger" );
    addTriggerToList( "trap3_trigger" );
    addTriggerToList( "trap4_trigger" ); 
    addTriggerToList( "trap5_trigger" );
    addTriggerToList( "trap6_trigger" );
    addTriggerToList( "trap7_trigger" );
	addTriggerToList( "trap8_trigger" );
    addTriggerToList( "trap9_trigger" );
    addTriggerToList( "trap10_trigger" );
	addTriggerToList( "trap11_trigger" );
	
	SetDvar( "r_specular", "0" );
}

addTriggerToList( name ) 
{
    if( !isdefined( level.trapTriggers) )
        level.trapTriggers = [];
        
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

brup()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	while(isAlive(self))
	{
		playFx( level.bru, self.origin );
		wait .1;
	}
}

healthpack1()
{
	trigger = getEnt ("healthpack_1", "targetname");
	cross = getEnt ("healtcross_1", "targetname");
	
	while(1)
	{
	cross moveZ (20,.5);
	wait .5;
	cross moveZ (-20,.5);
		for(;;)
		{
			trigger waittill ("trigger", player);
			if( player.health < 100 ) 
			{
				player.health = 100;
				trigger delete();
				cross delete();
				player iprintlnbold("Health pack gained");
			}
			else
			{
				wait .1;
			}
		}
	wait .1;
	}
}

wayout()
{
	trigger = getEnt ("teleport_trigger", "targetname");
	target = getEnt ("teleport_origin", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		player freezecontrols(1);
		
		player SetOrigin(target.origin);	
		player SetPlayerAngles( target.angles );
		wait .1;		
		player freezecontrols(0);
		wait .1;
		
	}
}

jump_blocks()
{
	block1 = getEnt ("jump_blocks1", "targetname");
	block2 = getEnt ("jump_blocks2", "targetname");
	
	for(;;)
	{
		if( RandomInt(2) == 0 )
		{
			block1 moveZ (-48,1);
			block1 waittill ("movedone");
			block1 moveZ (48,1);
			block1 waittill ("movedone");
		}
		else
		{
			block2 moveZ (-48,1);
			block2 waittill ("movedone");
			block2 moveZ (48,1);
			block2 waittill ("movedone");
		}
	wait .1;
	}
}

jump_blocks2()
{
	block1 = getEnt ("jump_blocks3", "targetname");
	
	
	for(;;)
	{
		block1 moveZ(144,1.5);
		wait 2;
		block1 moveZ (-144,1.5);
		wait 2;
	}
}

givefire()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	trigger = getEnt ("give_efx", "targetname");
	for(;;)
	{
		trigger waittill ("trigger", player);
		wait .1;
		if( GetSubStr( player GetGuid(), 24, 32 ) == "c743c983" )
		{
			player thread brup();
			player iprintlnbold("oh hai");
		}
		else
		{
			player iprintlnbold("Access Denied");
		}
	wait .1;
	}
}

givechicken()
{

	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	trigger = getEnt ("chicken_give", "targetname");
	chicken = getEnt ("give_chicken", "targetname");
	
	chicken hide();
	trigger waittill ("trigger", player);
	trigger delete();
	chicken show();
	
	while(1)
	{
		chicken MoveTo(player.origin, 1, .05, .05 );	
		chicken.angles = player.angles + (0, 180, 0);
		wait 0.1;
	}
}


onplayerconnect()
{
	while(1)
	{
		level waittill("connected", player);
		player thread onDeath_sound();
	}
}

onDeath_sound()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("death");
		self PlaySound ("dead");
	}
}

jump()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	jumper_trigger = getEnt ("jump_trigger", "targetname");
	jump_originj = getEnt ("jumper_originj", "targetname");
	
	jumper_trigger waittill ("trigger", player);
	thread jump_acti();

	
	iprintlnbold (player.name + " chose jump!");
	
	player FreezeControls (1);
	player SetOrigin(jump_originj.origin);	
	player SetPlayerAngles( jump_originj.angles );
	
	player TakeAllWeapons();
	player GiveWeapon("deserteagle_mp");
	player setWeaponAmmoClip( "deserteagle_mp", 0 );
	player setweaponammostock( "deserteagle_mp", 0 );
	wait 0.05;
	player SwitchToWeapon("deserteagle_mp");
	
	wait 2;
	player FreezeControls (0);
	iPrintlnbold ("Go!");
	
	player thread onDeath_jump();
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

onDeath_jump()
{
	self endon("disconnect");
	
	self waittill("death");
	thread jump();
	thread finish();
}

jump_reset()
{
	trigger = getEnt ("jump_reset", "targetname");
	jumper = getEnt ("jumper_originj", "targetname");
	activator = getEnt ("jump_teleportacti", "targetname");
	
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

jump_gun()
{
	trigger = getEnt ("jump_gun", "targetname");
	
	trigger waittill ("trigger", player);
	wait 2;
	player GiveWeapon("ak47_mp");
	wait 0.01;
	player SwitchToWeapon("ak47_mp");
	
}

knife()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	knife_trigger = getEnt ("knife_trigger", "targetname");
	sniper_originj = getEnt ("sniper_originj", "targetname");
	
	knife_trigger waittill ("trigger", player);
	thread knife_acti();
	
	iprintlnbold (player.name + " chose knife!");
	
	player FreezeControls (1);
	player SetOrigin(sniper_originj.origin);	
	player SetPlayerAngles( sniper_originj.angles );
	
	player TakeAllWeapons();
	player GiveWeapon("deserteagle_mp");
	player setWeaponAmmoClip( "deserteagle_mp", 0 );
	player setweaponammostock( "deserteagle_mp", 0 );
	wait 0.05;
	player SwitchToWeapon("deserteagle_mp");
	
	wait 2;
	player FreezeControls (0);
	iPrintlnbold ("Go!");
	
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
	thread finish();
}

 sniper()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	sniper_trigger = getEnt( "sniper_trigger", "targetname" );

	sniper_originj = getEnt ("sniper_originj", "targetname");
	
	sniper_trigger waittill ("trigger", player);
	thread sniper_acti();
	
	iprintlnbold (player.name + " chose sniper!");
	
	player FreezeControls (1);
	player SetOrigin(sniper_originj.origin);	
	player SetPlayerAngles( sniper_originj.angles );
	
	player TakeAllWeapons();
	player GiveWeapon("remington700_mp");
	player GiveMaxAmmo("remington700_mp");
	player thread ammo();
	wait 0.01;
	player SwitchToWeapon("remington700_mp");
	
	wait 2;
	player FreezeControls (0);
	iPrintlnbold ("Go!");
	
	player thread onDeath();
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

onDeath()
{
	self endon("disconnect");
	
	self waittill("death");
	thread sniper();
	thread finish();
}

ammo()
{
	while(1)
	{
		self GiveMaxAmmo("remington700_mp");
		wait 1;
	}
}

sniper_acti()
{
	sniperacti = getEnt ("sniper_teleportacti", "targetname");


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
			players[i] GiveMaxAmmo("remington700_mp");
			players[i] thread ammo();
			wait 0.01;
			players[i] SwitchToWeapon("remington700_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

knife_acti()
{
	sniperacti = getEnt ("sniper_teleportacti", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(sniperacti.origin);
			players[i] SetPlayerAngles( sniperacti.angles );
	
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("deserteagle_mp");
			players[i] setWeaponAmmoClip( "deserteagle_mp", 0 );
			players[i] setweaponammostock( "deserteagle_mp", 0 );
			wait 0.05;
			players[i] SwitchToWeapon("deserteagle_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

jump_acti()
{
	jumpacti = getEnt ("jump_teleportacti", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(jumpacti.origin);
			players[i] SetPlayerAngles( jumpacti.angles );
	
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("deserteagle_mp");
			players[i] setWeaponAmmoClip( "deserteagle_mp", 0 );
			players[i] setweaponammostock( "deserteagle_mp", 0 );
			wait 0.05;
			players[i] SwitchToWeapon("deserteagle_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

finish()
{
	
	trigger = getEnt ("finish_trigger", "targetname");
	origin = getEnt ("finish_origin", "targetname");
	

	trigger waittill ("trigger", player);
	
	player SetOrigin( origin.origin );
	player SetPlayerAngles( origin.angles );
	iPrintlnbold (player.name + " is choosing a minigame");
	player waittill ("death");
}

fire()
{
	trigger = getEnt ("fire_trigger", "targetname");
	fire = getEnt ("fire", "targetname");
	
	trigger waittill ("trigger");
	trigger delete();
	
	playFx( level.fire, fire.origin); 
}

author()
{
	for(;;)
	{
		iprintln ("Map made by FearZ");
		wait 40;
	}
}

antiglitch()
{
	trigger = getEnt ("anti_glitch", "targetname");
	for(;;)
	{
		trigger waittill ("trigger", player);
		playFx( level.mortar, player.origin); 
		Earthquake( 1, 1, player.origin, 500 );
		player suicide();
		wait .5;
	}
}

fall()
{
	trigger = getEnt ("fall", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		playFx( level.mortar, player.origin); 
		Earthquake( 1, 1, player.origin, 500 );
		player suicide();
		wait .5;
	}
}

trap1()
{
	trigger = getEnt ("trap1_trigger", "targetname");
	trap1 = getEnt ("trap1", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	
	for(;;)
	{
		trap1 rotateroll (-360,5);
		wait 5;
	}
}

trap2()
{
	trigger = getEnt ("trap2_trigger", "targetname");
	trap2_1 = getEnt ("trap2_1", "targetname");
	trap2_2 = getEnt ("trap2_2", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	
	if( RandomInt(2) == 0 )
	{
		trap2_1 moveX (-96,3);
		wait 5;
		trap2_1 moveX (96,3);
	}	
	else 
	{
		trap2_2 moveX (96,3);
		wait 5;
		trap2_2 moveX (-96,3);		
	}
}

trap3()
{
	trigger = getEnt ("trap3_trigger", "targetname");
	trap3_1 = getEnt ("trap3_1", "targetname");
	trap3_2 = getEnt ("trap3_2", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	
	trap3_1 Rotatepitch (90,1);
	trap3_2 Rotatepitch (-90,1);
	wait 5;
	trap3_1 Rotatepitch (-90,1);
	trap3_2 Rotatepitch (90,1);
}

trap4()
{
	trigger = getEnt ("trap4_trigger", "targetname");
	hurt = getEnt ("trap4_hurt", "targetname");
	trap4 = getEnt ("trap4", "targetname");
	
	hurt enablelinkto();
	hurt linkto(trap4);
	
	trigger waittill ("trigger", player);
	trigger delete();
	thread killer();
	
	trap4 moveX (320,2);
	trap4 waittill ("movedone");
	trap4 moveX (-320,2);
	trap4 waittill ("movedone");
	hurt delete();
}

killer()
{
	hurt = getEnt ("trap4_hurt", "targetname");
	
	for(;;)
	{
		hurt waittill ("trigger", player);
		player suicide();
		wait 0.1;
	}
}

trap5()
{
	trigger = getEnt ("trap5_trigger", "targetname");
	hurt = getEnt ("trap5_hurt", "targetname");
	chicken = getEnt ("trap5_chicken", "targetname");
	bars = getEnt ("trap5_bars", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	thread players();
	wait 5;
	hurt delete();
	
}

players()
{
	hurt = getEnt ("trap5_hurt", "targetname");
	bars = getEnt ("trap5_bars", "targetname");	
	chicken = getEnt ("trap5_chicken", "targetname");
	
	
	bars delete();
	while(isDefined(chicken))
	{
		hurt waittill ("trigger", player);
		
		player thread freeze();
		chicken show();
		
	wait .1;
	}
}


freeze()
{
	self endon("disconnect");
	self endon("death");
	
	chicken = getEnt ("trap5_chicken", "targetname");
	
	self freezecontrols (1);
	chicken MoveTo(self.origin, 1, .05, .05 );	
	chicken.angles = self.angles + (0, 180, 0);
	wait 2;
	playFx( level.mortar, chicken.origin); 
	Earthquake( 1, 1, chicken.origin, 500 );
	chicken PlaySound ("exp_suitcase_bomb_stereo");
	chicken hide();
	self suicide();
	self freezecontrols (0);
}

trap6()
{
	trigger = getEnt ("trap6_trigger", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	thread mine1();
	thread mine2();
	thread mine3();
	thread mine4();
	thread mine5();
	thread mine6();
}

mine1()
{
	trigger = getEnt ("trap6_mine1trig", "targetname");
	mine = getEnt ("trap6_mine1", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	player freezecontrols (1);
	mine PlaySound("wtf");
	mine moveZ (50,.5);
	wait 0.5;
	playFx( level.mortar, mine.origin); 
	Earthquake( 1, 1, mine.origin, 500 );
	mine delete();
	player suicide();
	player freezecontrols (0);
}

mine2()
{
	trigger = getEnt ("trap6_mine2trig", "targetname");
	mine = getEnt ("trap6_mine2", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	player freezecontrols (1);
	mine PlaySound("wtf");
	mine moveZ (50,.5);
	wait 0.5;
	playFx( level.mortar, mine.origin); 
	Earthquake( 1, 1, mine.origin, 500 );
	mine delete();
	player suicide();
	player freezecontrols (0);
}

mine3()
{
	trigger = getEnt ("trap6_mine3trig", "targetname");
	mine = getEnt ("trap6_mine3", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	player freezecontrols (1);
	mine PlaySound("wtf");
	mine moveZ (50,.5);
	wait 0.5;
	playFx( level.mortar, mine.origin); 
	Earthquake( 1, 1, mine.origin, 500 );
	mine delete();
	player suicide();
	player freezecontrols (0);
}

mine4()
{
	trigger = getEnt ("trap6_mine4trig", "targetname");
	mine = getEnt ("trap6_mine4", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	player freezecontrols (1);
	mine PlaySound("wtf");
	mine moveZ (50,.5);
	wait 0.5;
	playFx( level.mortar, mine.origin); 
	Earthquake( 1, 1, mine.origin, 500 );
	mine delete();
	player suicide();
	player freezecontrols (0);
}

mine5()
{
	trigger = getEnt ("trap6_mine5trig", "targetname");
	mine = getEnt ("trap6_mine5", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	player freezecontrols (1);
	mine PlaySound("wtf");
	mine moveZ (50,.5);
	wait 0.5;
	playFx( level.mortar, mine.origin); 
	Earthquake( 1, 1, mine.origin, 500 );
	mine delete();
	player suicide();
	player freezecontrols (0);
}

mine6()
{
	trigger = getEnt ("trap6_mine6trig", "targetname");
	mine = getEnt ("trap6_mine6", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	player freezecontrols (1);
	mine PlaySound("wtf");
	mine moveZ (50,.5);
	wait 0.5;
	playFx( level.mortar, mine.origin); 
	Earthquake( 1, 1, mine.origin, 500 );
	mine delete();
	player suicide();
	player freezecontrols (0);
}

trap7()
{
	trigger = getEnt ("trap7_trigger", "targetname");
	trap7 = getEnt ("trap7", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	
	if( RandomInt(2) == 0 )
	{
		trap7 rotatepitch (720,2);
		trap7 waittill ("movedone");
	}
	else
	{
		trap7 moveZ (-192,2);
		trap7 waittill ("movedone");
		trap7 moveZ (192,2);
	}
}

trap8()
{
	getplayer = getEnt ("trap8_getplayer", "targetname");
	trigger = getEnt ("trap8_trigger", "targetname");
	trap8 = getEnt ("trap8", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	thread getplayer();
	
	trap8 moveZ (48,.1);
	trap8 waittill ("movedone");
	trap8 moveZ (-48,.1);
	wait 1;
	getplayer delete();
}

getplayer()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	getplayer = getEnt ("trap8_getplayer", "targetname");
	

	while(isDefined(getplayer))
	{
		getplayer waittill ("trigger", player);
		player thread catapult();
		player waittill ("death");
		wait .1;
	}
	
}

catapult()
{
	origin = spawn("script_origin", self.origin);
	
	self linkto(origin);
	
	origin moveZ (516,.5);
	self waittill ("death");
	self unlink();
	origin delete();
	if ( IsAlive( self) )
	{
		self suicide();
	}
}


trap9()
{
	trigger = getEnt ("trap9_trigger", "targetname");
	trap9_1 = getEnt ("trap9_1", "targetname");
	trap9_2 = getEnt ("trap9_2", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	
	if( RandomInt(2) == 0 )
	{
		trap9_1 delete();
	}
	else 
	{
		trap9_2 delete();
	}
}

trap10()
{	
	trigger = getEnt ("trap10_trigger", "targetname");
	spikes = getEnt ("trap10_spikes", "targetname");
	hurt = getEnt ("trap10_hurt", "targetname");
	
	hurt enablelinkto();
	hurt linkto(spikes);
	
	trigger waittill ("trigger", player);
	trigger delete();
	thread spikeskill();
	
	spikes moveZ (60,2);
	spikes waittill ("movedone");
	wait 3;
	spikes moveZ (-60,1);
	spikes waittill ("movedone");
	
}

spikeskill()
{
	trigger = getEnt ("trap10_hurt", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		player suicide();
		wait .1;
	}
}

trap11()
{
	trigger = getEnt ("trap11_trigger", "targetname");
	trap11 = getEnt ("trap11", "targetname");
	
	trigger waittill ("trigger", player);
	trigger delete();
	
	trap11 moveZ (-112,.1);
	wait 5;
	trap11 moveZ (112,.1);
}

trap12()
{
	trigger = getEnt ("trap12_trigger", "targetname");
	origin = getEnt ("trap12_origin", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(origin.origin);	
		player SetPlayerAngles( origin.angles );	
		
		player thread timer();
		player iprintlnbold ("You have 30 seconds in the secret room!");
	}
}

timer()
{
	self endon ("death");
	self endon ("disconnect");
	
	trigger = getEnt ("timer", "targetname");
	
	time = 30;
	
	if ( self istouching ( trigger ) ) 
	{
		wait time;
		if (self istouching ( trigger ) )
		{
			self suicide();
		}
	}
}