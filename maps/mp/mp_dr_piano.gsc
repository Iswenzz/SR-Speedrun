
#include common_scripts\utility;

main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
	setDvar( "bg_fallDamageMaxHeight", 99999 );
	setDvar( "bg_fallDamageMinHeight", 99998 );	
	
	level.knockback = getdvarint ("g_knockback"); 

	thread sr\api\_map::createSpawn((2666, 1237, 1293), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((1524.07, 698.942, -63.875), 320,420, "normal_0"); 
	
	thread init();
	//thread precache();
	thread startdoor ();
}	


init()
{
	//thread playerSpawn();
	//thread credits();
	//thread messages(); 
	//thread music();
	thread traps();
	//thread roofxpyuhu(); 
	thread jumpPad();
	//thread acti_teleports();
	//thread room_setup();
	//thread endmap();
	
}

precache()
{
	precacheItem( "m40a3_mp" );
	precacheItem( "knife_mp" );
	precacheItem ( "tomahawk_mp");
	precacheItem( "remington700_mp" );
}

playerSpawn()
{
	for(;;)
	{
		level waittill( "player_spawn", player );
		player thread slide();
	
		if ( isdefined(level.activ) && player == level.activ )
		{
			player setMoveSpeedScale( 1.4 );
		}
	}
}


credits()
{
	while(1){
		wait 20;
		iprintln("^1 Map Made by ^7FNRP-Muffinator");
		wait 4;
		iPrintln( "^5Thanks to all mappers who inspired me to map^6! Especially ABprice, ERIK, Darkstep, Speedex, Wingzor, Icomar, Lixfe, VC-Fox, CM'Legend, Rednose, Rexy, Sux-Lolz" );
		wait 4;
		iPrintln( "^6Big Thanks to ^5blu ^6:** For scripting, ideas inspiration" );
		wait 4;
		iPrintln( "^5Thanks for your aid help Arfy^^ with the fake skybox issue xd" );
	}
}

messages()
{
	level waittill( "round_started" );
	wait 4;
	iPrintlnBold( "^6Welcome to Piano!" );
	wait 1;
	iPrintlnBold( "^5Have fun, enjoy the game... ;)" );
	wait 10;
	iPrintlnBold( "^7Music is the mediator between the spiritual and the sensual life. ^0- Ludwig van Beethoven" );
	
	//thread startdoor ();
}	

music()
{
	level waittill("round_started");
	
	song = "song" + ( randomInt(5) + 1 );
	ambientPlay( song );
}

startdoor()	
{ 
	rightdoor = getEnt ("righty", "targetname");
	leftdoor = getEnt ("lefty", "targetname");
	rightdoor delete();
	leftdoor delete();
}


traps()
{
	thread setupTrapTrigger( "trap1_trig", ::trap1 );
	thread setupTrapTrigger( "trap2_trig", ::trap2 );
	thread setupTrapTrigger( "trap3_trig", ::trap3 );
	//thread setupTrapTrigger( "trap4_trig", ::trap4 );
	thread setupTrapTrigger( "trap5_trig", ::trap5 );
	thread setupTrapTrigger( "trap6_trig", ::trap6 );
	thread setupTrapTrigger( "trap7_trig", ::trap7 );
	thread setupTrapTrigger( "trap8_trig", ::trap8 );
}

setupTrapTrigger( name, func )
{
    if( !isDefined( level.trapTriggers ) )
		level.trapTriggers=[];
	trig = getEnt (name, "targetname");
    level.trapTriggers[level.trapTriggers.size] = trig;
	
	[[ func ]]();
}

trap1()
{
	platform = getEntArray("trap1","targetname");
	trig = getent("trap1_trig","targetname");
	trig SetHintString("^3 Remove platforms");
	trig waittill ("trigger", player);
	
}

trap2()
{ 
	twoblockkeys = getEntArray ("twoblockkeys", "targetname");
	trig = getent ("trap2_trig","targetname");
	trig SetHintString ("^3 Rotate platforms");
	trig waittill ("trigger",player);
	
}

trap3()
{ 
	longkeys = getEntArray("longkeys","targetname");
	trig = getent ("trap3_trig","targetname");
	trig SetHintString ("^3 Speed time!");
	trig waittill ("trigger", player);
	

}


	
move( negative ) 
{	
	if( negative == 0 )
		negative = -1;
		
	d = 100;
	
	for(;;) {
		self moveZ( d * negative , 0.5 );
		wait 0.6;
		self moveZ( d * ( -1 * negative ), 0.5 );
		wait 0.6;
		self moveZ( d * ( -1 * negative ), 0.5 );
		wait 0.6;
		self moveZ( d * negative, 0.5 );
		wait 0.6;
	}
}


trap4()
{
	speakerfly = getEnt ("speakerfly","targetname");
	trig = getent ("trap4_trig","targetname");
	trig SetHintString ("^3 Push the betches");
	trig waittill ("trigger", player);
	
}	

flyplayers()
{
	self waittill ("trigger", player);
	while (player isTouching (self)) { 
	player.health += 1000;
	player FinishPlayerDamage( player, player, 1000, 0, "MOD_PROJECTILE", "m40a3_mp", self.origin, AnglesToForward( self.angles ), "none", 0 ); 
	wait 0.05;
	}
}


trap5()
{
	yuhufly1 = getEntArray ("yuhufly1", "targetname");
	trig = getent ("trap5_trig","targetname");
	trig SetHintString ("^3Yuhuu lets Fly");
	trig waittill ("trigger", player);


}

	
	
trap6()
{ 
	flipit = getEntArray ("flipit", "targetname");
	trig = getent ("trap6_trig", "targetname");
	trig SetHintString ("^3Flip that betches!");
	trig waittill ("trigger", player);
	
}

trap7()
{
	rotatingkeys = getEntArray ("rotatingkeys", "targetname");
	trig = getEnt ("trap7_trig", "targetname");
	trig SetHintString ("^3Let them feel dizzy");
	trig waittill ("trigger", player);

}

trap8()
{
	upbounce = getEnt ("upbounce", "targetname");
	trig = getent ("trap8_trig", "targetname");
	trig SetHintString ("^3Be Mean, let the bounce fly");
	trig waittill ("trigger", player);

}



slide()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	plat = getEnt( "slide", "targetname" );
	
	for(;;)
	{
		if( self isTouching( plat ) )
			self setMoveSpeedScale( 1.8	);
		else
			self setMoveSpeedScale( 1.0 );
		wait 0.05;
	}
}


roofxpyuhu()
{ 
	xpyahooo = getEnt ("roofxpyuhu", "targetname");
	tp_roofxpyuhu = getEnt ("tp_roofxpyuhu", "targetname");
	
	for (;;)
	{
		xpyahooo waittill ("trigger", player);
		player braxi\_rank::giveRankXP("", 2000);
		player setorigin (tp_roofxpyuhu.origin); 
		}
}


jumpPad()
{
    trigger = getEntArray( "padflyhigh", "targetname" );
    
    for( i = 0; i < trigger.size; i++ )
        thread padflyhigh ( trigger[i] );
}

padflyhigh( trigger )
{
    if( !isDefined( trigger ) )
        return;

    while(1)
    {
        trigger waittill( "trigger", player );
        if( isDefined( player.onpad ) )
            continue;
        player thread PushPlayer( trigger );
    }
}

PushPlayer( trigger )
{
    self endon("disconnect");

    self.onpad = true;

    if(distance(trigger.origin, self.origin) > 400) // then the player tried to load-glitch the speed
    {
        self freezeControls(true);
        wait 0.1;
        self freezeControls(false);
    }

    else
    {
        target = getEnt( trigger.target, "targetname" );
        speed = int(strTok(trigger.script_noteworthy, ",")[0]);

        self.health    = 1000000;
        self.maxhealth = 1000000;

        setDvar("g_knockback", (speed*9)-3000);
        self finishPlayerDamage(self, self, (speed*9)-3000, 0, "MOD_FALLING", "deserteaglegold_mp", trigger.origin, (target.origin - trigger.origin), "head", 0);
        wait 0.05;
        setDvar("g_knockback", level.knockback);

        self.health    = 100;
        self.maxhealth = 100;
    }

    while(self isTouching(trigger))
        wait 0.05;

    self.onpad = undefined;
}

acti_teleports()
{
	for( i = 1; i <= 6; i++ )
		thread setup_teleport( "tpa" + i, "a" + i );
}

setup_teleport( trig, spawn )
{
	t = trig;
	o = spawn;
	
	if( isString( trig ) )
		t = getEnt( trig, "targetname" );
	
	if( isString( spawn ) )
		o = getEnt( spawn, "targetname" );

	for(;;)
	{
		t waittill( "trigger", player );
		player teleport( o );
	}
}

teleport( spawn )
{
	self setOrigin( spawn.origin );
	self setPlayerAngles( spawn.angles );
	self freezeControls( 1 );
	wait 0.01;
	self freezeControls( 0 );
}

room_setup()
{
	room = [];
	
	for( i = 0; i < 2; i++ )
		room[i] = spawnStruct();
	
	room[0].name = "Sniper";
	room[1].name = "Strafe";
	//room[2].name = "Knife";
	
	room[0].weapons = strTok( "m40a3_mp;remington700_mp", ";"  );
	room[1].weapons = strTok( "knife_mp;", ";" );
	//room[2].weapons = strTok( "knife_mp;tomahawk_mp", ";" );
	
	room[0].triggers = strTok( "snip_trig;sniper_respawn_trig;", ";" );
	room[1].triggers = strTok( "strafe_trig;strafe_respawn_trig;strafeend", ";" );
	//room[2].triggers = strTok( "knifer_trig;", ";" );
	
	
	room[0].spawns = strTok( "sniperjump;sniperacti;", ";" );
	room[1].spawns = strTok( "strafe1;strafe2;winner;loser", ";" );
	//room[2].spawns = strTok( "knife1;knife2;", ";" );

	
	for( i = 0; i < 2; i++ )
		thread room_start( room[i] );
	
}

room_start( room )
{
	trigs = [];
	spawns = [];
	
	for( i = 0; i < room.triggers.size; i++ )
		trigs[i] = getEnt( room.triggers[i], "targetname" );
	
	for( i = 0; i < room.spawns.size; i++ )
		spawns[i] = getEnt( room.spawns[i], "targetname" );
	
	if( trigs.size > 1 )
		trigs[1] thread room_respawn( spawns );
	if (trigs.size > 2 ) 
		trigs[2] thread race_winner ( spawns ); 
	
	for(;;)
	{
		trigs[0] waittill( "trigger", player );
		
		if( !isDefined( level.activ ) )
			continue;
			
		level.playerInRoom = player; 
		
		noti = SpawnStruct();
		noti.titleText = "^6" + player.name + " ^7Entered the ^5" + room.name + " ^7Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player teleport( spawns[0] );
		level.activ teleport( spawns[1] );
		
		player freezeControls( 1 );
		level.activ freezeControls( 1 );
		
		
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;
		
		player thread room_weapons( toLower( room.name ), room.weapons );
		
		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	}
}

room_respawn( spawns )
{
	for(;;)
	{
		self waittill( "trigger", player );
		
		if( level.activ == player )
			player teleport( spawns[1] );
		else
			player teleport( spawns[0] );
	}
}

room_weapons( name, weapons )
{

		for( i = 0; i < weapons.size; i++ )
		{
			self give_weapon( weapons[i] );
			level.activ give_weapon( weapons[i] );
		}
	
	self switchToWeapon( ( self getWeaponsList() )[0] );
	level.activ switchToWeapon( ( level.activ getWeaponsList() )[0] );
	
}

give_weapon( weapon )
{
	self giveWeapon( weapon );
	self giveMaxAmmo( weapon );
}

race_winner( spawns )
{
    for(;;)
    {
        self waittill( "trigger", player );
        
        if( player == level.activ )
            race_end( level.activ, level.playerInRoom, spawns[2], spawns[3] );
        else
            race_end( level.playerInRoom, level.activ, spawns[2], spawns[3] );
    }
}

race_end( winner, loser, winnerSpawn, loserSpawn )
{
    loser freezeControls( 1 );
	loser iPrintlnBold ("YOU LOST!");
	winner iPrintlnBold ("You Won^^");
    loser takeAllWeapons();
    loser setOrigin( loserSpawn.origin );
    loser setPlayerAngles( loserSpawn.angles );
    
    winner freezeControls( 1 );
    winner setOrigin( winnerSpawn.origin );
    winner setPlayerAngles( winnerSpawn.angles );
    winner give_weapon( "knife_mp" );
    wait 2;
    winner freezeControls( 0 );
	

}


endmap()
{
	level.queue = [];

	trig = getEnt( "endmap_trig", "targetname" );
	o = getEnt( "endmap_here", "targetname" );
	
	for(;;)
	{
		trig waittill( "trigger", player );
		
		if( isDefined( player.ghost ) && player.ghost )
		{
			player iPrintlnBold( "^5Completed Map In Ghost", "\n", "^1Try Again!" );
			player braxi\_rank::giveRankXP( undefined, 50 );
			player suicide();
			continue;
		}
		
		if( !isDefined( player.qNum ) ) 
			player queue_add();
		
		if( level.qNum == player.qNum )
			continue;
		
		player iPrintlnBold( "^5Wait your turn" );
		player teleport( o );
	}
}

queue_add()
{
	if( !isDefined( level.qNum ) )
	{
		level.qNum = 0;
		self.qNum = level.qNum;
	}
	else
		self.qNum = level.queue.size;
	
	level.queue[level.queue.size] = self.guid;
	
	self thread queue_death();
	self thread get_place_reward( self.qNum+1 );
}

queue_death()
{
	id = self.guid;
	num = self.qNum;
	
	self waittill_any( "death", "disconnect" );
	
	self.qNum = undefined;
	
	if( level.qNum == num )
	{
		level.qNum++;
		return;
	}

	for( i = level.qNum; i < level.queue.size; i++ )
	{
		if( level.queue[i].guid == id )
		{
			level.queue = array_remove( level.queue, i );
			return;
		}
	}
}

array_remove( arr, index )
{
	temp = [];
	
	for( i = 0; i < arr.size; i++ )
	{
		if( i != index )
			temp[temp.size] = arr[i];
	}
	
	return temp;
}

get_place_reward(place)
{
	switch(place)
	{
		case 1:
			self iprintlnbold("You got 1000 XP for 1# Place");
			self braxi\_rank::giverankxp(undefined,1000);
			break;
		case 2:
			self iprintlnbold("You got 750 XP for 2# Place");
			self braxi\_rank::giverankxp(undefined,750);
			break;
		case 3:
			self iprintlnbold("You got 500 XP for 3# Place");
			self braxi\_rank::giverankxp(undefined,500);
			break;
		case 4:
			self iprintlnbold("You got 350 XP for 4# Place");
			self braxi\_rank::giverankxp(undefined,350);
			break;
		case 5:
			self iprintlnbold("You got 300 XP for 5# Place");
			self braxi\_rank::giverankxp(undefined,300);
			break;
		case 6:
			self iprintlnbold("You got 250 XP for 6# Place");
			self braxi\_rank::giverankxp(undefined,250);
			break;
		case 7:
			self iprintlnbold("You got 200 XP for 7# Place");
			self braxi\_rank::giverankxp(undefined,200);
			break;
		case 8:
			self iprintlnbold("You got 150 XP for 8# Place");
			self braxi\_rank::giverankxp(undefined,150);
			break;
		case 9:
			self iprintlnbold("You got 100 XP for 9# Place");
			self braxi\_rank::giverankxp(undefined,100);
			break;
		case 10:
			self iprintlnbold("You got 75XP for 10# Place");
			self braxi\_rank::giverankxp(undefined,75);
			break;
	}
}

