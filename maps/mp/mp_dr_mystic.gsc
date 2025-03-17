main()
{
thread sr\api\_map::createSpawnOrigin((-48, -464, 16), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");


	maps\mp\_load::main();
	maps\mp\mp_dr_mystic_fx::main();
	maps\createfx\mp_dr_mystic_fx::main();

	thread sr\api\_speedrun::createEndMap((1188, -1234, -80), 100, 150);

	//maps\mp\_compass::setupMiniMap("compass_map_mp_dr_mystic");

	/* [AUTO DELETE] ambientPlay("ambient_farm"); */

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	PreCacheItem("remington700_mp");
	PreCacheItem("winchester1200_grip_mp");
	PreCacheItem("saw_mp");
	PreCacheItem("ak47_mp");

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1200");

	/* [AUTO DELETE] thread Secret_In(); */
	// thread messages();
	thread door();
	thread teddy_2();
	thread teddy_3();
	thread teddy_4();
	thread trap0();
	thread door2();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	// thread move_blocks1();
	// thread move_blocks2();
	thread machinegun_model();
	thread machinegun_take();
	thread jump_doors();
	// thread War_Song();
	// thread /* [AUTO DELETE] allow_sprint_jumper(); */
	// thread  [AUTO DELETE] disable_sprint_jumper();
	// thread /* [AUTO DELETE] allow_sprint_acti(); */
	// thread /* [AUTO DELETE] disable_sprint_acti(); */
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	/* [AUTO DELETE] thread old(); */
	// thread games();
	// thread  [AUTO DELETE] acti_sniper();
	thread acti_jump();
	// thread /* [AUTO DELETE] acti_knife(); */
	// thread /* [AUTO DELETE] acti_shotgun(); */

	addTriggerToList( "trigger0" );
	addTriggerToList( "trigger1" );
	addTriggerToList( "trigger2" );
	addTriggerToList( "trigger3" );
	addTriggerToList( "trigger4" );
	addTriggerToList( "trigger5" );
	addTriggerToList( "trigger6" );
	addTriggerToList( "trigger7" );
	addTriggerToList( "trigger8" );
	addTriggerToList( "trigger9" );
	addTriggerToList( "trigger10" );
	addTriggerToList( "trigger11" );
	addTriggerToList( "trigger12" );
}


Secret_In()
{

	trig = getEnt("secret_in","targetname");

	trig waittill("trigger", player);
	trig delete();

	player setOrigin((-32, -352, -304));
	player setplayerangles((0,180,0));
	/* [AUTO DELETE] player iPrintLnbold("^7You found ^3the secret room"); */
	wait 0.1;

}


messages()
{
	while(true)
	{
	wait 10;
	/* [AUTO DELETE] iprintln ("^3Map created by ^2[BSF]Punk"); */
	wait 10;
	/* [AUTO DELETE] iprintln ("^3Exclusively made for ^2LukServers"); */
	wait 10;
	/* [AUTO DELETE] iprintln ("^1luk-servers.com:28967"); */
	wait 20;
	/* [AUTO DELETE] iprintln ("^3Visit ^2luk-servers.com"); */
	wait 120;
	}
}


addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}


door()
{

	trig = getEnt("door_trig","targetname");
	door1 = getEnt("door1_1","targetname");
	door2 = getEnt("door1_2","targetname");
	secret_floor = getEnt("secret_floor","targetname");
	secret_port = getEnt("secret_in","targetname");

	secret_port enablelinkto();
	secret_port linkto (secret_floor);

	// trig waittill("trigger");
	trig delete();
	secret_floor moveZ(1000,0.1);
	door1 RotateYaw(110,2);
	door2 RotateYaw(-110,2);
	// MusicPlay("teddy");
	wait 0.5;
	thread teddy_1();
}


teddy_1()
{
	teddy = getEnt("teddy_bear1","targetname"); //Fucking teddy bear lol :P

	teddy RotateYaw(720,3);
	teddy moveZ(334,4);
	teddy waittill("movedone");
	teddy delete();

	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "bottom";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "bottom";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = -150;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1.5;
	hud_clock.glowcolor = (1,1,0);
	hud_clock.label = &"Map by: [BSF]Punk";
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 8;
	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "bottom";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "bottom";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = -150;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1.5;
	hud_clock.glowcolor = (0,1,0);
	hud_clock.label = &"Map for LukServers";
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 6;
}


teddy_2()
{

	trig = getEnt("teddy_trig2","targetname");
	teddy = getEnt("teddy_bear2","targetname");
	secret_floor = getEnt("secret_floor","targetname");
	secret_port = getEnt("secret_in","targetname");

	trig waittill("trigger", player);
	trig delete();
	secret_floor moveZ(-1000,0.1);
	player PlaySound("teddy");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("kill",10); */

}


teddy_3()
{
	teddy = getEnt("teddy_bear3","targetname");
	trig = getEnt("teddy_trig3","targetname");
	clip = getEnt("teddy_clip","targetname");
	block = getEnt("block","targetname");

	trig waittill("trigger", player);
	trig delete();

	player PlaySound("teddy");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("kill",10); */
	teddy delete();
	clip delete();
	player setOrigin((328, 3976, -120));
	player setplayerangles((0,360,0));
	block moveX(-32,1);
}


teddy_4()
{

	trig = getEnt("teddy_trig4","targetname");
	teddy = getEnt("teddy_bear4","targetname");

	trig waittill("trigger", player);
	trig delete();
	teddy delete();

	player PlaySound("teddy");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("kill",20); */
	/* [AUTO DELETE] iprintlnbold("^7All of the ^3teddy bears ^7have been found"); */
	wait 2;
	/* [AUTO DELETE] player GiveWeapon("ak47_mp"); */
	/* [AUTO DELETE] player GiveMaxAmmo("ak47_mp"); */
	wait 0.01;
	/* [AUTO DELETE] player SwitchToWeapon("ak47_mp"); */
	player braxi\_mod::giveLife();
	/* [AUTO DELETE] player iprintlnbold("^7You received an ^3extra life"); */

}


move_blocks1()
{

	block1 = getEnt("move_block1","targetname");
	block2 = getEnt("move_block2","targetname");
	hurt = getEnt("move_block1_hurt","targetname");
	hurt2 = getEnt("move_block2_hurt","targetname");

	hurt enablelinkto();
	hurt linkto (block1);

	hurt2 enablelinkto();
	hurt2 linkto (block2);

	while(1)
	{
		block1 RotatePitch(360,2);
		block2 RotatePitch(-360,2);
		wait 2;
	}
}


move_blocks2()
{

	block1 = getEnt("move_block3","targetname");
	block2 = getEnt("move_block4","targetname");

	while(1)
	{
		block1 moveX(1088,3);
		block2 moveX(-1088,3);
		wait 3;
		block1 moveX(-1088,3);
		block2 moveX(1088,3);
		wait 3;
	}
}


jump_doors()
{

	trig = getEnt("jump_door_inside_trig","targetname");
	door1_1 = getEnt("jump_door_inside1_1","targetname");
	door1_2 = getEnt("jump_door_inside1_2","targetname");
	door2_1 = getEnt("jump_door_inside2_1","targetname");
	door2_2 = getEnt("jump_door_inside2_2","targetname");
	trig setHintString("^7Press ^3F ^7to open doors");

	trig waittill("trigger");
	trig delete();

	door1_1 RotateYaw(-100,3);
	door1_2 RotateYaw(100,3);
	door2_1 RotateYaw(100,3);
	door2_2 RotateYaw(-100,3);
	wait 3;

}


War_Song()
{

	trig = getEnt("war_song","targetname");

	trig waittill("trigger", player);
	trig delete();

	/* [AUTO DELETE] AmbientPlay( "war" ); */

}


disable_sprint_jumper()
{

	trig = getEnt("disable_sprint_jumper","targetname");

	while(1)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] player sr\api\_player::setPlayerSpeedScale(0.5); */
		player AllowSprint(false);
	}
}


allow_sprint_jumper()
{

	trig = getEnt("allow_sprint_jumper","targetname");

	while(1)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] player sr\api\_player::setPlayerSpeedScale(1); */
		player AllowSprint(true);
	}
}


disable_sprint_acti()
{

	trig = getEnt("disable_sprint_acti","targetname");

	trig waittill("trigger", player);
	trig delete();
	/* [AUTO DELETE] player sr\api\_player::setPlayerSpeedScale(0.5); */
	player AllowSprint(false);

}


allow_sprint_acti()
{

	trig = getEnt("allow_sprint_acti","targetname");

	trig waittill("trigger", player);
	trig delete();
	/* [AUTO DELETE] player sr\api\_player::setPlayerSpeedScale(1); */
	player AllowSprint(true);

}


machinegun_model()
{

	gun = getEnt("machinegun_model","targetname");

	while(1)
	{
		gun RotateYaw(360,5);
		wait 5;
	}
}


machinegun_take()
{

	trig = getEnt("machinegun_take","targetname");
	trig setHintString("^7Press ^3F ^7to grab the machine gun");
	while(1)
	{
		trig waittill("trigger", player);

		/* [AUTO DELETE] player GiveWeapon("saw_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("saw_mp"); */
		wait 0.01;
		/* [AUTO DELETE] player SwitchToWeapon("saw_mp"); */
	}
}


trap0()
{
	level endon("trigger");

	trig = getEnt("trigger0","targetname");
	trap = getEnt("trap0","targetname");

	trig waittill("trigger");
	trig delete();
	trap delete();

}


door2()
{

	trig = getEnt("cylinder_trig","targetname");
	door = getEnt("cylinder_door","targetname");

	// trig waittill("trigger");
	trig delete();

	door moveZ(172,2);
	door waittill("movedone");
	door delete();

}


trap1()
{
	level endon("trigger");

	trig = getEnt("stairs_trig","targetname");
	brush = getEnt("stairs","targetname");

	trig waittill("trigger");
	trig delete();
	brush delete();

}


trap2()
{
	level endon("trigger");

	trig = getEnt("trigger1","targetname");
	trap = getEnt("trap1_spikes","targetname");
	hurt = getEnt("trap1_hurt","targetname");

	hurt enablelinkto();
	hurt linkto (trap);

	trig waittill("trigger");
	trig delete();

	trap moveZ(108,1);
	trap waittill("movedone");
	trap delete();
	hurt delete();

}


trap3()
{
	level endon("trigger");

	trig = getEnt("trigger2","targetname");
	trap = getEnt("gone","targetname");
	trap2 = getEnt("gone2","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	trap notsolid();
				break;

		case 1:	trap2 notsolid();
				break;

		default: return;
	}
}


trap4()
{
	level endon("trigger");

	trig = getEnt("trigger3","targetname");
	trap = getEnt("rotater1","targetname");
	trap2 = getEnt("rotater2","targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap RotatePitch(-360,3);
		trap2 RotatePitch(360,3);
		wait 3;
	}
}


trap5()
{
	level endon("trigger");

	trig = getEnt("trigger4","targetname");
	trap = getEnt("foolyou","targetname");

	trig waittill("trigger");
	trig delete();

	trap moveX(128,0.5);
	wait 2.5;
	trap moveX(-128,0.5);
	wait 2.5;
	trap moveX(-128,0.5);
	wait 2.5;
	trap moveX(128,0.5);
	wait 0.5;

}


trap6()
{
	level endon("trigger");

	trig = getEnt("trigger5","targetname");
	trap = getEnt("pusher","targetname");
	hurt = getEnt("pusher_hurt","targetname");

	hurt enablelinkto();
	hurt linkto (trap);

	trig waittill("trigger");
	trig delete();

	trap moveX(128,2);
	wait 2;

	while(1)
	{
		trap moveX(-256,2);
		wait 2;
		trap moveX(256,2);
		wait 2;
	}

}


trap7()
{
	level endon("trigger");

	trig = getEnt("trigger6","targetname");
	trap = getEnt("weird_rotate","targetname");

	trig waittill("trigger");
	trig delete();

	trap RotateRoll(360,2);
	wait 3;
	trap RotateRoll(-360,2);
	wait 3;

}


trap8()
{
	level endon("trigger");

	trig = getEnt("trigger7","targetname");
	trap = getEnt("pushing_spikes","targetname");
	hurt = getEnt("trap8_hurt","targetname");

	hurt enablelinkto();
	hurt linkto (trap);

	trig waittill("trigger");
	trig delete();

	trap moveY(-576,2);
	wait 4;
	trap moveY(576,2);

}


trap9()
{
	level endon("trigger");

	trig = getEnt("trigger8","targetname");
	poles = getEnt("poles1","targetname");
	poles2 = getEnt("poles2","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	poles moveZ(-292,4);
				poles waittill("movedone");
				poles delete();
				break;

		case 1:	poles2 moveZ(-292,4);
				poles2 waittill("movedone");
				poles2 delete();
				break;

		default: return;
	}
}


trap10()
{
	level endon("trigger");

	trig = getEnt("trigger9","targetname");
	left = getEnt("move_left","targetname");
	center = getEnt("move_center","targetname");
	right = getEnt("move_right","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	left notsolid();
				right notsolid();
				break;

		case 1:	center notsolid();
				break;

		default: return;
	}
}


trap11()
{
	level endon("trigger");

	trig = getEnt("trigger10","targetname");
	trap = getEnt("normal_rotate","targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap RotateRoll(360,5);
		wait 5;
	}
}


trap12()
{
	level endon("trigger");

	trig = getEnt("trigger11","targetname");
	part1 = getEnt("part1","targetname");
	part2 = getEnt("part2","targetname");
	part3 = getEnt("part3","targetname");
	part4 = getEnt("part4","targetname");
	part5 = getEnt("part5","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(4);

	switch(randomend)
	{
		case 0:	part1 delete();
				part3 notsolid();
				part5 delete();
				break;

		case 1:	part2 delete();
				part4 notsolid();
				part1 delete();
				break;

		case 2: part1 delete();
				part4 notsolid();
				part5 delete();
				break;

		case 3: part3 delete();
				part4 notsolid();
				part1 delete();
				break;

		default: return;
	}
}


trap13()
{
	level endon("trigger");

	trig = getEnt("trigger12","targetname");
	first = getEnt("first","targetname");
	second = getEnt("second","targetname");
	third = getEnt("third","targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		first RotatePitch(360,10);
		second RotatePitch(360,10);
		third RotatePitch(360,10);
		wait 14;
		first RotatePitch(360,2);
		wait 6;
		third RotatePitch(360,2);
		wait 6;
		second RotatePitch(360,2);
		wait 6;
	}
}


old()
{

	trig = getEnt("old_trig","targetname");
	door = getEnt("old_door","targetname");
	clip = getEnt("old_clip","targetname");
	hint = getEnt("old_hint","targetname");
	games = getEnt("sniper_enter","targetname");

	trig waittill("trigger");
	trig delete();
	clip delete();
	hint delete();
	games delete();

	door moveZ(172,2);
	door waittill("movedone");
	door delete();

}


//All Scripts from here are done by #AfterLife.fearz thanks man
//Also ask him for permission to use them, since you already got this map to my gsc file >.<

acti_sniper()
{

	trig = getEnt("acti_sniper","targetname");
	old = getEnt("old_trig","targetname");

	trig waittill("trigger");
	trig delete();
	old delete();

	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((-1472, 1792, -476));
			/* [AUTO DELETE] players[i] TakeAllWeapons(); */
			/* [AUTO DELETE] players[i] GiveWeapon("remington700_mp"); */
			/* [AUTO DELETE] players[i] GiveMaxAmmo("remington700_mp"); */
			wait 0.01;
			/* [AUTO DELETE] players[i] SwitchToWeapon("remington700_mp"); */
			}
		}
		return;
	}
}


acti_jump()
{

	trig = getEnt("acti_jump","targetname");
	old = getEnt("old_trig","targetname");

	trig waittill("trigger");
	trig delete();
	old delete();

	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((2848, 6016, -208));
			/* [AUTO DELETE] players[i] TakeAllWeapons(); */
			/* [AUTO DELETE] players[i] GiveWeapon("knife_mp"); */
			/* [AUTO DELETE] wait 0.01; */
			/* [AUTO DELETE] players[i] SwitchToWeapon("knife_mp"); */
			}
		}
		return;
	}
}


acti_shotgun()
{

	trig = getEnt("acti_shotgun","targetname");
	old = getEnt("old_trig","targetname");

	trig waittill("trigger");
	trig delete();
	old delete();

	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((-1884, 4068, -36));
			/* [AUTO DELETE] players[i] TakeAllWeapons(); */
			/* [AUTO DELETE] players[i] GiveWeapon("winchester1200_grip_mp"); */
			/* [AUTO DELETE] players[i] GiveMaxAmmo("winchester1200_grip_mp"); */
			wait 0.01;
			/* [AUTO DELETE] players[i] SwitchToWeapon("winchester1200_grip_mp"); */
			}
		}
		return;
	}
}


acti_knife()
{

	trig = getEnt("acti_knife","targetname");
	old = getEnt("old_trig","targetname");
	trig waittill("trigger");
	trig delete();
	old delete();

	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((-1832 -1144 -216));
			/* [AUTO DELETE] players[i] TakeAllWeapons(); */
			/* [AUTO DELETE] players[i] GiveWeapon("knife_mp"); */
			/* [AUTO DELETE] players[i] GiveMaxAmmo("knife_mp"); */
			wait 0.01;
			/* [AUTO DELETE] players[i] SwitchToWeapon("knife_mp"); */
			}
		}
		return;
	}
}


//Script by Dr.Uzi
//Edited some things

games()
{
	trig = getEnt("games", "targetname");
	trig setHintString("^7Press ^3F ^7to enter a random room");
	randomend = randomint(4);
	weapon = undefined;

	while (1)
	{
		trig waittill("trigger", player);
		trig setHintString("^1Please wait for your turn");

	switch(randomend)
	{
		case 0:	target_jumper = ((-1600, -128, -476));
				text = "^3" + player.name + " ^7has entered the sniper room";
				weapon = "remington700_mp";
				break;

		case 1:	target_jumper = ((-1556, 2108, -36));
				text = "^3" + player.name + " ^7has entered the shotgun room";
				weapon = "winchester1200_grip_mp";
				break;

		case 2:	target_jumper = ((-1832 -2456 -216));
				text = "^3" + player.name + " ^7has entered the knife room";
				weapon = "knife_mp";
				break;

		case 3:	target_jumper = ((2848, -1920, -208));
				text = "^3" + player.name + " ^7has entered the jump room";
				weapon = "knife_mp";
				break;

		default: return;
	}

	/* [AUTO DELETE] iPrintLnBold(text); */

	player SetOrigin( target_jumper );
	player SetPlayerAngles((0,90,0));
	/* [AUTO DELETE] player takeAllWeapons(); */


	if(isDefined(weapon))
	{
		/* [AUTO DELETE] player GiveWeapon(weapon); */
		/* [AUTO DELETE] player GiveMaxAmmo(weapon); */
		/* [AUTO DELETE] wait 0.01; */
		/* [AUTO DELETE] player SwitchToWeapon( weapon ); */
	}
	player onDeath();
	/* [AUTO DELETE] wait 0.1; */
	trig setHintString("^7Press ^3F ^7to enter a random room");
	}
}


onDeath()
{
        self endon("disconnect");

        self waittill("death");

		/* [AUTO DELETE] iprintlnbold("^3" + self.name + "^1 died"); */

}
