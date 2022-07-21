main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");

maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "allies";
game["defenders"] = "axis";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

//Precache Stuff
precacheModel( "playermodel_baa_joker" );
precacheModel( "playermodel_dnf_duke" );
precacheModel( "viewhands_dnf_duke" );

precacheItem("ak74u_mp");
precacheItem("knife_mp");
precacheItem("m40a3_mp");
precacheItem("remington700_mp");

ent = getEnt("endmap_trig","targetname");
ent delete();

trigger = spawn( "trigger_radius", (-1404.58, 1494.36, -1023.88), 0, 220, 80 );
trigger.targetname = "endmap_trig";
trigger.radius = 220;

thread way_connect();

//Events
thread spawn_door();
//thread trap4_platform_small();
thread end_door();
//thread music();
//thread onSpawn();

//Secret
//thread trollface();
//thread secret_step2();
//thread secret_step3();
//thread secret_enter();
//thread secret_fail1();
//thread secret_fail2();
//thread secret_finish();

//Rooms
//thread room_old();
//thread room_snipe();
//thread room_jump();
//thread room_knife();
//thread room_jump_fail();
//thread room_jump_sniper();

//Traps
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
//thread trap10_platform();

//addTriggerToList("trap1_trig");
//addTriggerToList("trap2_trig");
//addTriggerToList("trap3_trig");
//addTriggerToList("trap4_trig");
//addTriggerToList("trap5_trig");
//addTriggerToList("trap6_trig");
//addTriggerToList("trap7_trig");
//addTriggerToList("trap8_trig");
//addTriggerToList("trap9_trig");
//addTriggerToList("trap10_trig");

level.PlayerInRoom = false;

}

way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}

// EVENTS //
spawn_door()
{
	door_left = getEnt("spawn_door_left","targetname");
	door_right = getEnt("spawn_door_right","targetname");

	wait 0;
	door_left moveY(130,3);
	door_right moveY(-130,3);
}

trap4_platform_small()
{
	t = getEnt("trap4_platform_small","targetname");
	secret_step2_trig = getEnt("secret_step2_trig","targetname");

	secret_step2_trig enablelinkto();
	secret_step2_trig linkto(t);

	while(1)
	{
		tt = floor(randomint(5));
		if(tt < 3)
			tt = 3;
		t moveX(448, tt);
		t waittill("movedone");

		tt = floor(randomint(5));
		if(tt < 3)
			tt = 3;
		t moveX(-448, tt);
		t waittill("movedone");
	}
}

end_door()
{
	trig = getEnt("endmap_trig","targetname");
	door_left = getEnt("end_door_left","targetname");
	door_right = getEnt("end_door_right","targetname");
	trig waittill("trigger", player);
	//iprintlnbold("^3" + player.name + " ^6Finished the map First!");
	//door_left moveX(144,2);
	//door_right moveX(-144,2);
}

onSpawn()
{
	while(1)
	{
		level waittill( "player_spawn", player );
		player thread player_skins();
		player.secret_step1 = false;
		player.secret_step2 = false;
		player.secret_step3 = false;
		player thread default_vars();
	}
}

default_vars()
{

}

player_skins()
{
	self endon( "disconnect" );

	waittillframeend;
	if( self.pers["team"] == "axis" )
		self setModel( "playermodel_baa_joker" );

	self SetViewModel( "viewhands_dnf_duke" );
}

//Secret
trollface()
{
	trig = getEnt("trig_trollface","targetname");
	while(1)
	{
		trig waittill("trigger",player);

		if( player.secret_step1 == false || !isDefined(player.secret_step1) )
		{
			player.realname = GetDvar("name");
			player thread ChangeName("^6Dumbass");
			iPrintlnBold("^6" + player.realname + "^7 is a dumbass!");
			player.secret_step1 = true;
			player iPrintln("^6Secret Step 1: ^2Complete");
			player iPrintln("^2Your name will change back in 15 seconds. ;)");
			player thread ChangeName(player.realname, 15);
		}
	}
}

secret_step2()
{
	trig = getEnt("secret_step2_trig","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		if( player.secret_step1 == true && (player.secret_step2 == false || !isDefined(player.secret_step2)) )
		{
			player.secret_step2 = true;
			player iPrintln("^6Secret Step 2: ^2Complete");
		}
	}
}

secret_step3()
{
	trig = getEnt("secret_step3_trig","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		if( player.secret_step2 == true && (player.secret_step3 == false || !isDefined(player.secret_step3)) )
		{
			player.secret_step3 = true;
			player iPrintln("^6Secret Step 3: ^2Complete");
		}
	}
}

secret_enter()
{
	trig = getEnt("secret_enter_trig","targetname");
	end = getEnt("secret_enter_end","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		if( player.secret_step1 == true && player.secret_step2 == true && player.secret_step3 == true )
		{
			player SetOrigin(end.origin);
			player SetPlayerAngles( end.angles );
			player.secret_fails_left = 10;
			player iPrintlnBold("^6You have entered the Secret!");
		}
	}
}

secret_fail1()
{
	trig = getEnt("secret_fail1_trig","targetname");
	end = getEnt("secret_enter_end","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		thread secret_fail_counter(player);
		player SetOrigin(end.origin);
		player SetPlayerAngles( end.angles );
	}
}

secret_fail2()
{
	trig = getEnt("secret_fail2_trig","targetname");
	end = getEnt("secret_fail2_end","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		thread secret_fail_counter(player);
		player SetOrigin(end.origin);
		player SetPlayerAngles( end.angles );
	}
}

secret_fail_counter(player)
{
	if( !player.secret_fails_left == 0 )
	{
		player.secret_fails_left -= 1;
		player iPrintln("^6Fails left untill death: ^3" + player.secret_fails_left);
	}
	else
	{
		player suicide();
		iPrintln("^3" + player.name + "^6 failed to finish secret!");
	}
}

secret_finish()
{
	trig = getEnt("secret_finish_trig","targetname");
	end = getEnt("secret_finish_end","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		player SetOrigin(end.origin);
		player SetPlayerAngles( end.angles );
		player GiveWeapon("ak74u_mp");
		player GiveMaxAmmo("ak74u_mp");
		player SwitchToWeapon("ak74u_mp");
		player setModel( "playermodel_dnf_duke" );
		iPrintlnBold("^3" + player.name + "^6 has finished the Secret!");
	}
}

// ROOMS //
room_old()
{
	level.old_trig = getEnt("room_old_trig","targetname");
	door = getEnt("room_old_door","targetname");
	level.old_trig waittill("trigger");
	level.snipe_trig Delete();
	level.jump_trig Delete();
	level.knife_trig Delete();
	iPrintlnBold("^1Old Room opening!");
	door moveZ(-208,3);
}

room_snipe()
{
	level.snipe_trig = getEnt("room_snipe_trig","targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );

	while(1)
	{
		level.snipe_trig waittill("trigger",player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
				level.old_trig Delete();
			level.PlayerInRoom = true;
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
			player thread default_vars();
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "remington700_mp" );
	        level.activ GiveWeapon( "m40a3_mp" );
	        level.activ GiveMaxAmmo( "remington700_mp" );
	        level.activ GiveMaxAmmo( "m40a3_mp" );
	        level.activ thread default_vars();
	        wait 0.05;
	        player switchToWeapon( "remington700_mp" );
	        level.activ SwitchToWeapon( "remington700_mp" );
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
			player waittill("death");
			level.PlayerInRoom = false;
		}
	}
}

room_jump()
{
	level.jump_trig = getEnt("room_jump_trig","targetname");
    jump = getEnt( "jump_j", "targetname" );
    acti = getEnt( "jump_a", "targetname" );

	while(1)
	{
		level.jump_trig waittill("trigger",player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
				level.old_trig Delete();
			level.PlayerInRoom = true;
			thread music();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "knife_mp" );
			player GiveMaxAmmo( "knife_mp" );
			player thread default_vars();
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "knife_mp" );
	        level.activ GiveMaxAmmo( "knife_mp" );
	        level.activ thread default_vars();
	        wait 0.05;
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
			player waittill("death");
			level.PlayerInRoom = false;
		}
	}
}

room_knife()
{
	level.knife_trig = getEnt("room_knife_trig","targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );

	while(1)
	{
		level.knife_trig waittill("trigger",player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
				level.old_trig Delete();
			level.PlayerInRoom = true;
			thread music();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "knife_mp" );
			player GiveMaxAmmo( "knife_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "knife_mp" );
	        level.activ GiveMaxAmmo( "knife_mp" );
	        wait 0.05;
	        player switchToWeapon( "knife_mp" );
	        level.activ SwitchToWeapon( "knife_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Knife Room";
					noti.notifyText = level.activ.name + " ^6VS^7 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill("death");
			level.PlayerInRoom = false;
		}
	}
}

room_jump_fail()
{
	trig = getEnt("room_jump_fail_trig","targetname");
	end_a = getEnt( "jump_a", "targetname" );
	end_j = getEnt( "jump_j", "targetname" );
	while(1)
	{
		trig waittill("trigger", player);
		if( player.pers["team"] == "axis" )
		{
			player SetPlayerAngles( end_a.angles );
	        player setOrigin( end_a.origin );
		}
		else
		{
			player SetPlayerAngles( end_j.angles );
        	player setOrigin( end_j.origin );
		}
	}
}

room_jump_sniper()
{
	trig = getEnt("room_jump_sniper_trig","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player SwitchToWeapon("remington700_mp");
	}
}

// TRAPS //
trap1()
{
	trig = getEnt("trap1_trig","targetname");
	bottom1 = getEnt("trap1_bottom1","targetname");
	bottom2 = getEnt("trap1_bottom2","targetname");
	top1 = getEnt("trap1_top1","targetname");
	top2 = getEnt("trap1_top2","targetname");

	bottom1_hurt = getEntArray("trap1_bottom1_hurt","targetname");
	bottom2_hurt = getEntArray("trap1_bottom2_hurt","targetname");
	top1_hurt = getEntArray("trap1_top1_hurt","targetname");
	top2_hurt = getEntArray("trap1_top2_hurt","targetname");

	for(i=0;i<bottom1_hurt.size;i++)
	{
		bottom1_hurt[i] enablelinkto();
		bottom1_hurt[i] linkto (bottom1);
	}
	for(i=0;i<bottom2_hurt.size;i++)
	{
		bottom2_hurt[i] enablelinkto();
		bottom2_hurt[i] linkto (bottom2);
	}
	for(i=0;i<top1_hurt.size;i++)
	{
		top1_hurt[i] enablelinkto();
		top1_hurt[i] linkto (top1);
	}
	for(i=0;i<top2_hurt.size;i++)
	{
		top2_hurt[i] enablelinkto();
		top2_hurt[i] linkto (top2);
	}

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap2()
{
	trig = getEnt("trap2_trig","targetname");
	t1 = getEnt("trap2_1","targetname");
	t2 = getEnt("trap2_2","targetname");
	t3 = getEnt("trap2_3","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap3()
{
	trig = getEnt("trap3_trig","targetname");
	t = getEnt("trap3_platforms","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap4()
{
	trig = getEnt("trap4_trig","targetname");
	t = getEntArray("trap4_platform","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap5()
{
	trig = getEnt("trap5_trig","targetname");
	t1 = getEnt("trap5_1","targetname");
	t2 = getEnt("trap5_2","targetname");
	t3 = getEnt("trap5_3","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap6()
{
	trig = getEnt("trap6_trig","targetname");
	t1 = getEnt("trap6_1","targetname");
	t2 = getEnt("trap6_2","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap7()
{
	trig = getEnt("trap7_trig","targetname");
	trig_j = getEnt("trap7_trig_j","targetname");
	end = getEnt("trap7_end","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap7_deactivate()
{
	trig = getEnt("trap7_trig_j","targetname");
	wait 10;
	trig Delete();
}

trap7_room_activate()
{
	roof1 = getEnt("t7_roof1","targetname");
	roof1_hurt = getEnt("t7_roof1_hurt","targetname");
	roof2 = getEnt("t7_roof2","targetname");
	roof2_hurt = getEnt("t7_roof2_hurt","targetname");
	pusher1 = getEnt("t7_pusher1","targetname");
	pusher2 = getEnt("t7_pusher2","targetname");
	pusher1_hurt = getEnt("t7_pusher1_hurt","targetname");
	pusher2_hurt = getEnt("t7_pusher2_hurt","targetname");
	platform1 = getEnt("t7_platform1","targetname");
	platform2 = getEnt("t7_platform2","targetname");
	finish_trig = getEnt("trap7_finish_trig","targetname");
	finish_end = getEnt("trap7_finish_end","targetname");

	roof1_hurt enablelinkto();
	roof1_hurt linkto(roof1);
	roof2_hurt enablelinkto();
	roof2_hurt linkto(roof2);
	pusher1_hurt enablelinkto();
	pusher1_hurt linkto(pusher1);
	pusher2_hurt enablelinkto();
	pusher2_hurt linkto(pusher2);

	wait 6;
	iPrintlnBold("^3Sweeper ^6activating in 5 seconds!");
	iPrintlnBold("^3Sweeper ^6activated!");
	wait 1.5;

	traps_left = 5;
	while(traps_left > 0)
	{
		todo = randomint(100);
		t = randomint(100);
		if(todo < 30)
		{
			if( t < 50 )
			{
				roof1 moveZ(-272,2);
				roof1 waittill("movedone");
				wait 2;
				roof1 moveZ(272,2);
				roof1 waittill("movedone");
			}
			else
			{
				roof2 moveZ(-272,2);
				roof2 waittill("movedone");
				wait 2;
				roof2 moveZ(272,2);
				roof2 waittill("movedone");
			}
		}
		else if( todo < 60 )
		{
			if( t < 50 )
			{
				pusher1 moveX(400,2);
				pusher1 waittill("movedone");
				wait 2;
				pusher1 moveX(-400,2);
				pusher1 waittill("movedone");
			}
			else
			{
				pusher2 moveX(-400,2);
				pusher2 waittill("movedone");
				wait 2;
				pusher2 moveX(400,2);
				pusher2 waittill("movedone");
			}
		}
		else
		{
			if( t < 50 )
			{
				platform1 moveZ(-208,1.5);
				platform1 waittill("movedone");
				wait 2;
				platform1 moveZ(208,2);
				platform1 waittill("movedone");
			}
			else
			{
				platform2 moveZ(-208,1.5);
				platform2 waittill("movedone");
				wait 2;
				platform2 moveZ(208,2);
				platform2 waittill("movedone");
			}
		}
		traps_left -= 1;
		wait 2;
	}

	while(1)
	{
		finish_trig waittill("trigger",player);
		player SetOrigin(finish_end.origin);
		player SetPlayerAngles( finish_end.angles );
		iPrintlnBold("^3" + player.name + "^6 has survived the Sweeper!");
	}
}

trap8()
{
	trig = getEnt("trap8_trig","targetname");
	t1 = getEnt("trap8_1","targetname");
	t2 = getEnt("trap8_2","targetname");
	t2_hurt = getEnt("trap8_2_hurt","targetname");

	t2_hurt enablelinkto();
	t2_hurt linkto(t2);

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap9()
{
	trig = getEnt("trap9_trig","targetname");
	t1 = getEnt("trap9_1","targetname");
	t2 = getEnt("trap9_2","targetname");

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap10()
{
	trig = getEnt("trap10_trig","targetname");
	t1 = getEnt("trap10_1","targetname");
	t2 = getEnt("trap10_2","targetname");
	t1_hurt = getEntArray("trap10_1_hurt","targetname");
	t2_hurt = getEntArray("trap10_2_hurt","targetname");

	for(i=0;i<t1_hurt.size;i++)
	{
		t1_hurt[i] enablelinkto();
		t1_hurt[i] linkto (t1);
	}
	for(i=0;i<t2_hurt.size;i++)
	{
		t2_hurt[i] enablelinkto();
		t2_hurt[i] linkto (t2);
	}

	trig setHintString("^6Press ^3&&1 ^6to Activate Trap");
	trig waittill("trigger",player);

}

trap10_platform()
{
	trig = getEnt("trap10_platform_trig","targetname");
	p = getEnt("trap10_platform","targetname");
	hurt = getEnt("trap10_platform_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(p);

	trig waittill("trigger");
	wait 1.5;
	while(1)
	{
		p moveY(-1312,10);
		p waittill("movedone");
		wait 1.5;
		p moveY(1312,10);
		p waittill("movedone");
		wait 1.5;
	}
}



// FUNCTIONS //
ChangeName(name, delay)
{
	if(isDefined(delay))
		wait(delay);
	self setClientDvar("name",name);
}

music()
{
	song = [];
	song[song.size] = "drive_by";
	song[song.size] = "let_her_go";
	song[song.size] = "let_it_go";
	song[song.size] = "timber";

	rz = randomint(song.size);
	play = song[rz];

	ambientPlay(play);
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