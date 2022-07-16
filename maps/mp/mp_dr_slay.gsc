main()
{

maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "allies";
game["defenders"] = "axis";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

//Precaching Guns
precacheItem( "remington700_mp" );
precacheItem( "m40a3_mp" );
precacheItem( "ak74u_mp" );
precacheItem( "knife_mp" );

thread way_connect();
thread onConnect();
//Traps
// thread trap1(); //Delete Blocks Near Spawn
// thread trap2(); //Move spikes
// thread trap3(); //Remove Parts of Bridge
// thread trap4(); //Make platforms spin
// thread trap5(); //Delete a row of platforms
// thread trap6(); //Rotate platforms
// thread trap7(); //Move bars
// thread trap8(); //Move platform
// thread trap9(); //Rotate cilinder
// thread trap10(); //Make platforms non-solid and remove platforms
// thread trap11(); //Move brush to push players off

// addTriggerToList( "trap1_trig" );
// addTriggerToList( "trap2_trig" );
// addTriggerToList( "trap3_trig" );
// addTriggerToList( "trap4_trig" );
// addTriggerToList( "trap5_trig" );
// addTriggerToList( "trap6_trig" );
// addTriggerToList( "trap7_trig" );
// addTriggerToList( "trap8_trig" );
// addTriggerToList( "trap9_trig" );
// addTriggerToList( "trap10_trig" );
// addTriggerToList( "trap11_trig" );

//Events
thread spawn_cage();
// thread endmap_trigger();
// thread music();

//Jumper Teleports
thread jump_tele1(); // Teleports you to part 2
thread jump_tele2(); // Teleports you to part 3

//Activator Teleports
thread acti_tele1(); // Teleports you out of room 1
thread acti_tele2(); // Teleports you out of room 2
thread acti_tele3(); // Teleports you out of room 3

// Secrets
thread secret1_enter();
thread secret1_finish();
thread secret2_activate();
thread secret2_enter();
thread secret2_teletoloc2();
thread secret2_fail1();
thread secret2_fail2();
thread secret2_fail3();
thread secret2_finish();

// Minigames
// thread minigames_enter(); // Enter minigames room
// thread rm_snip();
// thread rm_knife();
// thread rm_1v1();
// thread rm_jump();

// Jump Room Stuff
// thread jump_j_fail();
// thread jump_a_fail();
// thread jump_sniper_give();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	speedrun\_way_name::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

onConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self.secret2 = undefined;
	}
}

// TRAPS //
trap1()
{
	trig = getEnt("trap1_trig","targetname");
	block1 = getEnt("trap1_block1","targetname");
	block2 = getEnt("trap1_block2","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	rz = floor(randomint(2));
	if(rz == 1)
	{
		block1 moveZ(-256,2);
		block1 waittill ("movedone");
		block1 Delete();
	}
	else
	{
		block2 moveZ(-256,2);
		block2 waittill ("movedone");
		block2 Delete();
	}
}

trap2()
{
	trig = getEnt("trap2_trig","targetname");
	spike1 = getEnt("trap2_spike1","targetname");
	spike2 = getEnt("trap2_spike2","targetname");
	spike1_trig = getEnt("trap2_spike1_trig","targetname");
	spike2_trig = getEnt("trap2_spike2_trig","targetname");

	spike1_trig enablelinkto(); 
	spike1_trig linkto (spike1);	
	spike2_trig enablelinkto(); 
	spike2_trig linkto (spike2);	

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	while(1)
	{
		spike1 moveY(-136,1);
		spike1 waittill ("movedone");
		spike2 moveY(136,1);
		spike2 waittill ("movedone");
		spike2 moveY(-136,1);
		spike2 waittill ("movedone");
		spike1 moveY(136,1);
		spike1 waittill ("movedone");
		wait 1;
	}
}

trap3()
{
	trig = getEnt("trap3_trig","targetname");
	t1 = getEnt("trap3_1","targetname");
	t2 = getEnt("trap3_2","targetname");
	t3 = getEnt("trap3_3","targetname");
	t4 = getEnt("trap3_4","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	todel = floor(randomint(5));
	if(todel == 1)
	{
		t1 Delete();
		t3 Delete();
	}
	else if(todel == 2)
	{
		t1 Delete();
	}
	else if(todel == 3)
	{
		t2 Delete();
		t4 Delete();
	}
	else if(todel == 4)
	{
		t1 Delete();
		t4 Delete();
	}
	else
	{
		t2 Delete();
	}
}

trap4()
{
	trig = getEnt("trap4_trig","targetname");
	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	thread t4_rot1();
	thread t4_rot2();
	thread t4_rot3();
	thread t4_rot4();
	thread t4_rot5();
}

t4_rot1()
{
	t1 = getEnt("trap4_1","targetname");
	while(1)
	{
		t1 rotateyaw(360,2.75);
		t1 waittill("rotatedone");
	}
}
t4_rot2()
{
	t2 = getEnt("trap4_2","targetname");
	while(1)
	{
		t2 rotateyaw(-360,2.75);
		t2 waittill("rotatedone");
	}
}
t4_rot3()
{
	t3 = getEnt("trap4_3","targetname");
	while(1)
	{
		t3 rotateyaw(360,3.5);
		t3 waittill("rotatedone");
	}
}
t4_rot4()
{
	t4 = getEnt("trap4_4","targetname");
	while(1)
	{
		t4 rotateyaw(-360,2);
		t4 waittill("rotatedone");
	}
}
t4_rot5()
{
	t5 = getEnt("trap4_5","targetname");
	while(1)
	{
		t5 rotateyaw(360,2.5);
		t5 waittill("rotatedone");
	}
}

trap5()
{
	trig = getEnt("trap5_trig","targetname");
	t1 = getEnt("trap5_1","targetname");
	t2 = getEnt("trap5_2","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	todel = floor(randomint(2));
	if(todel == 1)
		t1 Delete();
	else
		t2 Delete();

	thread t5_rotb();
}

t5_rotb()
{
	bounce = getEnt("trap5_b","targetname");

	while(1)
	{
		bounce rotateyaw(360,2);
		wait 3.5;
	}
}

trap6()
{
	trig = getEnt("trap6_trig","targetname");
	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	thread t6_rot1();
	thread t6_rot2();
	thread t6_move3();
}

t6_rot1()
{
	t1 = getEnt("trap6_1","targetname");

	while(1)
	{
		t1 rotateyaw(360,2);
		t1 waittill("rotatedone");
	}
}

t6_rot2()
{
	t2 = getEnt("trap6_2","targetname");

	while(1)
	{
		t2 rotateyaw(-360,2);
		t2 waittill("rotatedone");
	}
}

t6_move3()
{
	t3 = getEnt("trap6_3","targetname");
	t3 moveY(-36,.05);
	wait 3;
	t3 moveY(36,.05);
}

trap7()
{
	trig = getEnt("trap7_trig","targetname");
	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	thread t7_move1();
	wait 1.5;
	thread t7_move2();
}

t7_move1()
{
	while(1)
	{
		t1 = getEnt("trap7_1","targetname");
		t1 moveZ(128,1.5);
		t1 waittill("movedone");
		t1 moveZ(-128,1.5);
		t1 waittill("movedone");
	}
}

t7_move2()
{
	while(1)
	{
		t2 = getEnt("trap7_2","targetname");
		t2 moveZ(128,1.5);
		t2 waittill("movedone");
		t2 moveZ(-128,1.5);
		t2 waittill("movedone");
	}
}

trap8()
{
	trig = getEnt("trap8_trig","targetname");
	t1 = getEnt("trap8_1","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	t1 MoveZ(176,.5);
	t1 waittill("movedone");
	wait 3;
	t1 MoveZ(-176,3);
}

trap9()
{
	trig = getEnt("trap9_trig","targetname");
	t1 = getEnt("trap9_1","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	while(1)
	{
		t1 rotatepitch(360,1.5);
		t1 waittill("rotatedone");
		wait 2;
		t1 rotatepitch(-360,1.5);
		t1 waittill("rotatedone");
		wait 2;
	}
}

trap10()
{
	trig = getEnt("trap10_trig","targetname");
	clip1 = getEnt("trap10_clîp1","targetname");
	clip2 = getEnt("trap10_clîp2","targetname");
	t1 = getEnt("trap10_1","targetname");
	t2 = getEnt("trap10_2","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	todel = floor(randomint(2));
	if(todel == 2)
	{
		clip1 Delete();
		t2 Delete();
	}
	else
	{
		clip2 Delete();
		t1 Delete();
	}
}

trap11()
{
	trig = getEnt("trap11_trig","targetname");
	t1 = getEnt("trap11_1","targetname");

	trig setHintString("^7Press ^1&&1 ^7to Activate Trap");
	trig waittill("trigger", player);
	trig Delete();

	while(1)
	{
		t1 MoveY(432,.5);
		t1 waittill("movedone");
		wait 1.5;
		t1 MoveY(-432,.5);
		t1 waittill("movedone");
		wait 1.5;
	}
}


spawn_cage()
{
	cage = getEnt("spawn_cage","targetname");
	cage Delete();
}

endmap_trigger()
{
	trig = getEnt("endmap_trig","targetname");
	trig waittill("trigger", player);
	iprintlnbold("^0" + player.name + " ^1Finished the map First!");
	trig delete();
}

music()
{
	song = [];
	song[song.size] = "monster";
	song[song.size] = "payphone";
	song[song.size] = "pompeii";
	song[song.size] = "timber";
	song[song.size] = "wake_me_up";

	rz = randomint(song.size);
	play = song[rz];

	ambientPlay(play);
}

// JUMPER TELEPORTS //
jump_tele1()
{
	while(1)
	{
		trig = getEnt("tele_jump_part2","targetname");
		end = getEnt("tele_jump_part2_end","targetname");
		trig waittill("trigger", player);

		player SetOrigin(end.origin);
		player SetPlayerAngles( end.angles );
	}
}

jump_tele2()
{
	while(1)
	{
		trig = getEnt("tele_jump_part3","targetname");
		end = getEnt("tele_jump_part3_end","targetname");
		trig waittill("trigger", player);

		player SetOrigin(end.origin);
		player SetPlayerAngles( end.angles );
	}
}

// ACTIVATOR TELEPORTS //
acti_tele1()
{
	trig = getEnt("activ_tele_room1","targetname");
	end = getEnt("activ_tele_room1_end","targetname");
	trig waittill("trigger", player);

	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
}

acti_tele2()
{
	trig = getEnt("activ_tele_room2","targetname");
	end = getEnt("activ_tele_room2_end","targetname");
	trig waittill("trigger", player);

	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
}

acti_tele3()
{
	trig = getEnt("activ_tele_room3","targetname");
	end = getEnt("activ_tele_room3_end","targetname");
	trig waittill("trigger", player);

	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
}

// SECRETS //
secret1_enter()
{
	while(1)
	{
		trig = getEnt("secret1_trig_enter","targetname");
		end = getEnt("secret1_end_enter","targetname");
		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}

secret1_finish()
{
	while(1)
	{
		trig = getEnt("secret1_trig_finish","targetname");
		end = getEnt("secret1_end_finish","targetname");
		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}

secret2_activate()
{
	trig = getEnt("secret2_activate_trig","targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);
	player iprintlnbold("^1You activated something!");
	player.secret2 = true;
	}
}

secret2_enter()
{
	trig = getEnt("secret2_enter_trig","targetname");
	end = getEnt("secret2_enter_end","targetname");
	while(1)
	{
		trig waittill("trigger", player);
		if(isDefined(player.secret2) && player.secret2)
		{
		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
		player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
		}
	}
}

secret2_teletoloc2()
{
	while(1)
	{
		trig = getEnt("secret2_teletoloc2_trig","targetname");
		end = getEnt("secret2_teletoloc2_end","targetname");

		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}

secret2_fail1()
{
	while(1)
	{
		trig = getEnt("secret2_fail1","targetname");
		end = getEnt("secret2_enter_end","targetname");

		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}
secret2_fail2()
{
	while(1)
	{
		trig = getEnt("secret2_fail2","targetname");
		end = getEnt("secret2_fail2_end","targetname");

		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}
secret2_fail3()
{
	while(1)
	{
		trig = getEnt("secret2_fail3","targetname");
		end = getEnt("secret2_fail3_end","targetname");

		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}

secret2_finish()
{
	trig = getEnt("secret2_finish_trig","targetname");
	end = getEnt("tele_jump_part3_end","targetname");

	while(1)
	{
		trig waittill("trigger", player);

		player thread braxi\_mod::endTimer();
	}
}

// MINIGAMES //
minigames_enter()
{
	trig = getEnt("minigames_trig","targetname");
	end = getEnt("minigames_end","targetname");
	while(1)
	{
		trig waittill("trigger", player);

		player SetOrigin(end.origin);
    	player SetPlayerAngles( end.angles );
	}
}

rm_snip()
{
	level.rm_snip_trig = getEnt("room_snip_trig","targetname");
	level.rm_snip_trig setHintString("^7Press ^1&&1 ^7to Enter ^1Sniper Room");

    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );

	while(1)
	{
		level.rm_snip_trig waittill("trigger", player);
		if( !isDefined( level.rm_snip_trig ) )
            return;

		level.rm_knife_trig Delete();
		level.rm_1v1_trig Delete();
		level.rm_jump_trig Delete();
		thread music();

		player.health = player.maxhealth;
		level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );        
		player GiveMaxAmmo( "remington700_mp" );
		player GiveMaxAmmo( "m40a3_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" );
        level.activ GiveWeapon( "m40a3_mp" );         
        level.activ GiveMaxAmmo( "remington700_mp" );
        level.activ GiveMaxAmmo( "m40a3_mp" );
        wait 0.05;
        player switchToWeapon( "remington700_mp" ); 
        level.activ SwitchToWeapon( "remington700_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Sniper Room";
				noti.notifyText = level.activ.name + " ^0VS^7 " + player.name;
				noti.glowcolor = (1,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

rm_knife()
{
	level.rm_knife_trig = getEnt("room_knife_trig","targetname");
	level.rm_knife_trig setHintString("^7Press ^1&&1 ^7to Enter ^1Knife Room");

    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );

	while(1)
	{
		level.rm_knife_trig waittill("trigger", player);
		if( !isDefined( level.rm_knife_trig ) )
            return;

		level.rm_snip_trig Delete();
		level.rm_1v1_trig Delete();
		level.rm_jump_trig Delete();
		thread music();

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
        wait 0.05;
        player switchToWeapon( "knife_mp" ); 
        level.activ SwitchToWeapon( "knife_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Knife Room";
				noti.notifyText = level.activ.name + " ^0VS^7 " + player.name;
				noti.glowcolor = (1,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

rm_1v1()
{
	level.rm_1v1_trig = getEnt("room_1v1_trig","targetname");
	level.rm_1v1_trig setHintString("^7Press ^1&&1 ^7to Enter ^11v1 Room");

    jump = getEnt( "old_j", "targetname" );
    old_clip = getEnt("old_clip","targetname");

	while(1)
	{
		level.rm_1v1_trig waittill("trigger", player);
		if( !isDefined( level.rm_1v1_trig ) )
            return;

		level.rm_snip_trig Delete();
		level.rm_knife_trig Delete();
		level.rm_jump_trig Delete();

		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );

        iprintlnbold("^0Old ^1Opened!");

        wait 1;

        if (isDefined(old_clip))
        	old_clip Delete();
	}
}

rm_jump()
{
	level.rm_jump_trig = getEnt("room_jump_trig","targetname");
	level.rm_jump_trig setHintString("^7Press ^1&&1 ^7to Enter ^1Jump Room");

    jump = getEnt( "jump_j", "targetname" );
    acti = getEnt( "jump_a", "targetname" );

	while(1)
	{
		level.rm_jump_trig waittill("trigger", player);
		if( !isDefined( level.rm_jump_trig ) )
            return;

		level.rm_snip_trig Delete();
		level.rm_knife_trig Delete();
		level.rm_1v1_trig Delete();
		thread music();

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
        wait 0.05;
        player switchToWeapon( "knife_mp" ); 
        level.activ SwitchToWeapon( "knife_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Jump Room";
				noti.notifyText = level.activ.name + " ^0VS^7 " + player.name;
				noti.glowcolor = (1,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

jump_j_fail()
{
	trig = getEnt("jump_j_fail","targetname");
	end = getEnt( "jump_j", "targetname" );
	while(1)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles( end.angles );
        player setOrigin( end.origin );
	}
}

jump_a_fail()
{
	trig = getEnt("jump_a_fail","targetname");
	end = getEnt( "jump_a", "targetname" );
	while(1)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles( end.angles );
        player setOrigin( end.origin );
	}
}

jump_sniper_give()
{
	trig = getEnt("jump_snip_trig","targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player SwitchToWeapon("remington700_mp");
	}
}

// FUNCTIONS //
addTriggerToList( name, positionOfIconAboveTrap )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

    if( !isDefined( level.icon_origins ) )
        level.icon_origins = [];
    level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
} 