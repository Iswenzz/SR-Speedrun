/*
  /\\  /\\
  //\\_//\\     ____
  \_     _/    /   /
   / ^ ^ \    /^^^|
   \_\O/_/    |   |
    /   \_    |   /
    \     \_  /  /
    | | | /  \/ _/
    |_| | \__/_/
	By Fox.

Map Information
----------------
*/
main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
    thread sr\api\_map::createSpawn((-4127, -492, 76), 90);

	//level.fire = loadFX("fox/red_portal"); playLoopedFX(level.fire, 0.05, (-4920, 296, 96));
	//level.fire = loadFX("fox/red_portal"); playLoopedFX(level.fire, 0.05, (3312, -8352, 96));
	//level.super_fox_trail = loadFX("fox/trail_hippy_fox");

	setExpFog(500, 3500, .5, 0.5, 0.45, 0);
	setdvar("r_specularcolorscale", "1");
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");


	precacheItem("knife_mp");
	precacheItem("bulldog_mp");
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("deserteagle_mp");
	precacheItem("artillery_mp");

	precacheModel("playermodel_vc_company_body");
	precacheModel("playermodel_vc_company_head");

	thread sr_easy_sec_enter();
	thread sr_hard_sec_enter();
	//thread credits();
	//thread fox();
	thread startdoor();
	thread elev();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	thread trap6();
	thread trap7();
	//thread trap8();
	//thread trap10();
	thread jumperTP1();
	thread jumperTP2();
	//thread actiTP1();
	//thread music();
	//thread actiTP2();
	//thread actiTP3();
	//thread actiTP4();
	thread sec_res_1();
	//thread sec_enter_1();
	//thread slide_enter();
	//thread slide_exit();
	thread sec_exit_1();
	thread sec_res_2();
	//thread sec_enter_2();
	thread sec_exit_2();
	//thread race_room_fail_1();
	//thread race_room_fail_2();
	//thread bounce_room_sniper();
	//thread bounce_room_fail_1();
	//thread bounce_room_fail_2();
	//thread sniper_room();
	//thread bounce_room();
	//thread wep_room();
	//thread race_room();
    //thread tar_room();
	//thread addTestClients();
	//thread vip_fox();
	thread trigger_spawner();
	//thread lol0x2();


	//<--Trigger List-->\\
	addTriggerToList("trig_trap_1");
	addTriggerToList("trig_trap_2");
	addTriggerToList("trig_trap_3");
	addTriggerToList("trig_trap_4");
	addTriggerToList("trig_trap_5");
	addTriggerToList("trig_trap_61");
	addTriggerToList("trig_trap_7");
	addTriggerToList("trig_trap_8");
	addTriggerToList("trig_trap_10");

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}

sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(-3973.43, -492.061, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("sec_res_1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(-4256.87, -489.667, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("sec_res_2","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1");

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}
sr_tp_safe(ori)
{
	self endon("death");
	self endon("disconnect");

	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
trigger_spawner()
{
    trig = spawn("trigger_radius", (-4700, -90, 95),0, 100, 250);
	while(1)
	{
		trig waittill("trigger", player);
		player suicide();
		wait 0.1;
	}
}


music()
{
	x = randomInt(7);
	if(x == 0)
    {
		level waittill("round_started");
		ambientPlay("like");
	    iPrintLn("^3Music:^7 David Guetta & Martin Garrix - Like I Do");
	}
    if(x == 1)
    {
		level waittill("round_started");
		ambientPlay("pup");
	    iPrintLn("^3Music:^7 Lil Hank - A Young Puppo Is Born");
    }
	 if(x == 2)
    {
		level waittill("round_started");
		ambientPlay("night");
	    iPrintLn("^3Music:^7 Our Last Night - Dark Storms");
    }
	if(x == 3)
    {
		level waittill("round_started");
		ambientPlay("hurts");
	    iPrintLn("^3Music:^7 Sephyx & Bonnie X Clyde - Where It Hurts");
    }
	if(x == 4)
    {
		level waittill("round_started");
		ambientPlay("star");
	    iPrintLn("^3Music:^7 T & Sugah x NCT - Stardust");
    }
    if(x == 5)
    {
		level waittill("round_started");
		ambientPlay("here");
	    iPrintLn("^3Music:^7 Be Here Now (Koven Remix)");
    }
    if(x == 6)
    {
		level waittill("round_started");
		ambientPlay("thread");
	    iPrintLn("^3Music:^7 Elk Road - Hanging By A Thread (Flowidus Remix)");
    }
}

fox()
{
	level waittill("round_started");
	wait 5;
	thread braxi\_mod::drawInformation(500, 0.8, 2, "^7Map By: ^3VC' Fox");
    iPrintLn("^5mp_vc_nebula^7: Version 1.1");
}

credits()
{
	if( isDefined(self.screenText))
		self.screenText destroy();

	self.screenText = newHudElem();
	self.screenText.y = 10;
	self.screenText.alignX = "center";
	self.screenText.alignY = "middle";
	self.screenText.horzAlign = "center_safearea";

	self.screenText.alpha = 0;
	self.screenText.sort = -3;
	self.screenText.fontScale = 1.6;
	self.screenText.archieved = true;

	for(;;)
	{
		self.screenText fadeOverTime(2);
		self.screenText.alpha = 5;
		self.screenText setText("^5Vistic-Clan.Net");
		wait 6;
		self.screenText fadeOverTime(2);
		self.screenText.alpha = 0;
		wait 2;
		self.screenText fadeOverTime(2);
		self.screenText.alpha = 5;
		self.screenText setText("^7Map By: ^3VC'Fox");
		wait 6;
		self.screenText fadeOverTime(2);
		self.screenText.alpha = 0;
		wait 2;
		self.screenText fadeOverTime(2);
		self.screenText.alpha = 5;
		self.screenText setText("^7Credits to ^3VC'Blade ^7and ^3VC'Erik");
		wait 6;
		self.screenText fadeOverTime(2);
		self.screenText.alpha = 0;
		wait 2;
	}
}


startdoor()
{
	door = getEnt("door","targetname");

	door delete();

}

elev()
{
	elev = getent("ele", "targetname");

	elev moveX (500, 0.1);

}

slide_enter()
{
	trig = getEnt("slide_sec_enter", "targetname");
	tele1 = getEnt("slide_here", "targetname");
	tele2 = getEnt("here_7", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Enter Slide Secret");

	while(1)
		{
			trig waittill("trigger", player);
			if (!isDefined(player.slide))
		{
			player.slide = true;
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}

		else
		{
			player freezeControls(1);
			player setOrigin(tele2.origin);
			player setPlayerAngles(tele2.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.01;
		}
		}
}


slide_exit()
{
	trig = getEnt("slide_sec_exit", "targetname");
	tele1 = getEnt("here_7", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player braxi\_rank::giveRankXP( "", 2000);
			iPrintLnBold("^3"+ player.name + " ^7Has Finished the Slide Secret!");
			player freezeControls(1);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.01;
		}
}

bounce_room_sniper()
{
	trig = getEnt("br_sniper", "targetname");
	trig setHintString("^3>^7M40A3^3<^7");

		for(;;)
		{
			trig waittill("trigger", player);
			player giveWeapon("m40a3_mp");
			player givemaxammo("m40a3_mp");
			player switchtoweapon("m40a3_mp");
			wait 0.1;
		}
}

race_room_fail_1()
{
	trig = getEnt("race_f_1", "targetname");
	tele1 = getEnt("race_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

race_room_fail_2()
{
	trig = getEnt("race_f_2", "targetname");
	tele1 = getEnt("race_r_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}


bounce_room_fail_1()
{
	trig = getEnt("b_f_1", "targetname");
	tele1 = getEnt("b_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

bounce_room_fail_2()
{
	trig = getEnt("b_f_2", "targetname");
	tele1 = getEnt("b_r_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

jumperTP1()
{
	trig = getEnt("tele_1", "targetname");
	tele1 = getEnt("here_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

jumperTP2()
{
	trig = getEnt("tele_2", "targetname");
	tele1 = getEnt("here_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

sec_res_1()
{
	trig = getEnt("sec_fail_1", "targetname");
	tele1 = getEnt("sec_res_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

sec_enter_1()
{
	trig = getEnt("sec_enter_1", "targetname");
	tele1 = getEnt("sec_res_1", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Enter Secret #1");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer1();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

sec_exit_1()
{
	trig = getEnt("sec_exit_1", "targetname");
	tele1 = getEnt("here_1", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

sec_res_2()
{
	trig = getEnt("sec_fail_2", "targetname");
	tele1 = getEnt("sec_res_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

sec_enter_2()
{
	trig = getEnt("sec_enter_2", "targetname");
	tele1 = getEnt("sec_res_2", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Enter Secret #2");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer1();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

sec_exit_2()
{
	trig = getEnt("sec_exit_2", "targetname");
	tele1 = getEnt("here_2", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_1");
	}
}


actiTP1()
{
	trig = getEnt("acti_tp_1", "targetname");
	tele1 = getEnt("acti_here_1", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Teleport");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

actiTP2()
{
	trig = getEnt("acti_tp_2", "targetname");
	tele1 = getEnt("acti_here_2", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Teleport");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

actiTP3()
{
	trig = getEnt("acti_tp_3", "targetname");
	tele1 = getEnt("acti_here_3", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Teleport");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

actiTP4()
{
	trig = getEnt("acti_tp_4", "targetname");
	tele1 = getEnt("acti_here_4", "targetname");
	trig setHintString("Press ^3[&&1] ^7To Teleport");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

//Traps

trap1()
{
	trap = getEnt("trap_1", "targetname");
	trig = getent("trig_trap_1", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();
	trap moveZ(-490, 0.2);
	wait 4;
	trap moveZ(490, 2);
}



trap2()
{
	trap = getent("trap_2", "targetname");
	trig = getent("trig_trap_2", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();

	{
	for(;;)
	{
	trap rotateYaw(90, 1);
	wait 4;
	trap rotateYaw(90, 1);
	wait 4;
	trap rotateYaw(90, 1);
	wait 4;
	trap rotateYaw(90, 1);
	wait 4;
	}
}
}

trap3()
{
	trap = getEnt("trap_3", "targetname");
	trig = getent("trig_trap_3", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();
	trap notSolid();
}


trap4()
{
	trap = getEnt("trap_4", "targetname");
	trig = getent("trig_trap_4", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();
	trap delete();
}

trap5()
{
	trap = getEnt("trap_5", "targetname");
	trig = getent("trig_trap_5", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();
	trap delete();
}

trap6()
{
	trap = getEnt("trap_6", "targetname");
	trig = getEnt("trig_trap_61", "targetname");

	trap moveX(600, 0.1);
	wait 0.1;
	trap moveY(-400, 0.1);
	wait 0.1;
	trap moveZ(-100, 0.1);
	//wait 0.1;
	//trap rotateRoll(180,0.1);
	//wait 0.1;
	//trap rotateYaw(360,0.1);
}


trap7()
{
	trap = getEnt("trap_7", "targetname");
	trig = getEnt("trig_trap_7", "targetname");

	trap delete();
}

trap8()
{
	trap = getEnt("trap_8", "targetname");
	trig = getEnt("trig_trap_8", "targetname");
	kill = getEnt("hurt_8", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();

	kill enablelinkto();
    kill linkto (trap);


	for(;;)
	{
	wait 0.1;
	trap moveZ(-212, 1);
	wait 1.2;
	trap moveZ(212, 1);
	wait 1.2;
	}

}


trap10()
{
	b = getEnt("trap_10", "targetname");
	trig = getEnt("trig_trap_10", "targetname");

	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );


	trig delete();
	for(;;)
		{
			b rotateYaw(360, 1);
			wait 3;
			b rotateRoll(-360, 1);
			wait 3;
		}
}

//end romms


sniper_room()
{
	level.trigsniper = getent("trig_sniper","targetname");

	acti = getent("sf_1","targetname");
	jump = getent("sf_2","targetname");

	level.trigsniper sethintstring("^3Sniper Room");
	while(1)
	{
		level.trigsniper waittill("trigger",player);
		if(!isdefined(level.trigsniper))
			return;



		if(!isdefined(level.room_decided)) // this so it just deletes 1 time the triggers, else it gives error
		{
			level.room_decided = true;

			level.trigwep delete();
			level.trigrace delete();
			level.trigbounce delete();
            level.trigtar delete();
		}

		level.race_jumper = player;

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^1Sniper ^7Room.";
		noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		level.race_jumper room_setup_snip(jump,"m40a3_mp","yes",undefined,"yes",1);
		level.activ room_setup_snip(acti,"m40a3_mp","yes",undefined,"yes",1);

		wait 3;
		player iPrintLnBold("^7FIGHT");
		level.activ iPrintLnBold("^7FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) )
		wait 1;

		iprintlnbold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iprintlnbold("^7Sniper Room Open!");
		level.race_jumper = undefined;
	}
}




wep_room()
{
	level.trigwep = getent("wep_room","targetname");
	acti = getent("sf_1","targetname");
	jump = getent("sf_2","targetname");

	level.trigwep sethintstring("^7Weapon Room | ^3Bulldog");
	while(1)
	{
		level.trigwep waittill("trigger",player);
		if(!isdefined(level.trigwep))
			return;



		if(!isdefined(level.room_decided)) // this so it just deletes 1 time the triggers, else it gives error
		{
			level.room_decided = true;

			level.trigsniper delete();
			level.trigrace delete();
			level.trigbounce delete();
            level.trigtar delete();
		}

		level.race_jumper = player;

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^1Weapon ^7Room.";
		noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		level.race_jumper room_setup_wep(jump,"bulldog_mp","yes",undefined,"yes",1);
		level.activ room_setup_wep(acti,"bulldog_mp","yes",undefined,"yes",1);

		wait 3;
		player iPrintLnBold("^7FIGHT");
		level.activ iPrintLnBold("^7FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) )
		wait 1;

		iprintlnbold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iprintlnbold("^7Weapon Room Open!");
		level.race_jumper = undefined;
	}
}

tar_room()
{
	level.trigtar = getent("trig_tar","targetname");
	acti = getent("sf_1","targetname");
	jump = getent("sf_2","targetname");

	level.trigtar sethintstring("^7Weapon Room | ^3MTAR-X");
	while(1)
	{
		level.trigtar waittill("trigger",player);
		if(!isdefined(level.trigtar))
			return;



		if(!isdefined(level.room_decided))
		{
			level.room_decided = true;

			level.trigsniper delete();
			level.trigrace delete();
			level.trigbounce delete();
            level.trigwep delete();
		}

		level.race_jumper = player;

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^1Weapon ^7Room.";
		noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		level.race_jumper room_setup_wep(jump,"artillery_mp","yes",undefined,"yes",1);
		level.activ room_setup_wep(acti,"artillery_mp","yes",undefined,"yes",1);

		wait 3;
		player iPrintLnBold("^7FIGHT");
		level.activ iPrintLnBold("^7FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) )
		wait 1;

		iprintlnbold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iprintlnbold("^7Weapon Room Open!");
		level.race_jumper = undefined;
	}
}


bounce_room()
{
	level.trigbounce = getent("trig_bounce","targetname");
	acti = getent("b_r_2","targetname");
	jump = getent("b_r_1","targetname");

	level.trigbounce sethintstring("^3Bounce Room");
	while(1)
	{
		level.trigbounce waittill("trigger",player);
		if(!isdefined(level.trigbounce))
			return;



		if(!isdefined(level.room_decided)) // this so it just deletes 1 time the triggers, else it gives error
		{
			level.room_decided = true;

			level.trigsniper delete();
			level.trigwep delete();
			level.trigrace delete();
            level.trigtar delete();

		}

		level.race_jumper = player;

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^1Bounce ^7Room.";
		noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		level.race_jumper room_setup(jump,"knife_mp","no",undefined,"yes",1);
		level.activ room_setup(acti,"knife_mp","no",undefined,"yes",1);

		wait 3;
		player iPrintLnBold("^7FIGHT");
		level.activ iPrintLnBold("^7FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) )
		wait 1;

		iprintlnbold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iprintlnbold("^7Bounce Room Open!");
		level.race_jumper = undefined;
	}
}




race_room()
{
	level.trigrace = getent("trig_race","targetname");
	acti = getent("race_r_2","targetname");
	jump = getent("race_r_1","targetname");

	level.trigrace sethintstring("^3Race Room");
	while(1)
	{
		level.trigrace waittill("trigger",player);
		if(!isdefined(level.trigrace))
			return;



		if(!isdefined(level.room_decided)) // this so it just deletes 1 time the triggers, else it gives error
		{
			level.room_decided = true;

			level.trigsniper delete();
			level.trigwep delete();
			level.trigbounce delete();
            level.trigtar delete();

			thread race_ends(); // make it run only if room is entered to avoid bugzzz
		}

		level.race_jumper = player;

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^1Race ^7Room.";
		noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		level.race_jumper room_setup(jump,"deserteagle_mp","no",undefined,"yes",1);
		level.activ room_setup(acti,"deserteagle_mp","no",undefined,"yes",1);

		wait 3;
		player iPrintLnBold("^7FIGHT");
		level.activ iPrintLnBold("^7FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) )
		wait 1;

		iprintlnbold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iprintlnbold("^7Race Room Open!");
		level.race_jumper = undefined;
	}
}

room_setup_snip(targ,weap,ammo,weap2,health,freeze)
{
	self setorigin(targ.origin);
	self setplayerangles(targ.angles);

	self takeallweapons();
	self giveweapon(weap);
	self switchtoweapon(weap);
	self givemaxammo(weap);
	if(ammo == "no")
	{
		self  giveMaxAmmo("bulldog_mp");
		self  setWeaponAmmoStock(weap,0);
	}

	if(isdefined(weap2))
	{
		self giveweapon(weap2);
		self switchtoweapon(weap2);
	}

	self freezecontrols(freeze);
	if(health == "yes")
	{
		if(self.health < self.maxhealth)
			self.health = self.maxhealth;
	}
}

room_setup_wep(targ,weap,ammo,weap2,health,freeze)
{
	self setorigin(targ.origin);
	self setplayerangles(targ.angles);

	self takeallweapons();
	self giveweapon(weap);
	self switchtoweapon(weap);
	self givemaxammo(weap);
	if(ammo == "no")
	{
		self  giveMaxAmmo("bulldog_mp");
		self  setWeaponAmmoStock(weap,0);
	}

	if(isdefined(weap2))
	{
		self giveweapon(weap2);
		self switchtoweapon(weap2);
	}

	self freezecontrols(freeze);
	if(health == "yes")
	{
		if(self.health < self.maxhealth)
			self.health = self.maxhealth;
	}
}

room_setup(targ,weap,ammo,weap2,health,freeze)
{
	self setorigin(targ.origin);
	self setplayerangles(targ.angles);

	self takeallweapons();
	self giveweapon(weap);
	self switchtoweapon(weap);
	self givemaxammo(weap);
	if(ammo == "no")
	{
		self  setWeaponAmmoClip(weap,0);
		self  setWeaponAmmoStock(weap,0);
	}

	if(isdefined(weap2))
	{
		self giveweapon(weap2);
		self switchtoweapon(weap2);
	}

	self freezecontrols(freeze);
	if(health == "yes")
	{
		if(self.health < self.maxhealth)
			self.health = self.maxhealth;
	}
}

race_ends() //here i have the trigger to win/loos the race
{
	level.race_winner = getent("race_winner","targetname");
	level.race_loser = getent("race_loser","targetname");

	wait 1;

	thread ifactiwin();
	thread ifjumperwin();
}

ifactiwin()
{
	trig = getent("race_end_acti","targetname");

	for(;;)
	{
		trig waittill("trigger",who);

		if(who.pers["team"] == "axis")
		{
			level.activ setorigin(level.race_winner.origin);
			level.activ setplayerangles(level.race_winner.angles);
			if(level.activ getcurrentweapon() != "deserteagle_mp")
			{
				level.activ giveWeapon("deserteagle_mp");
				level.activ switchToWeapon("deserteagle_mp");
			}
			level.activ giveMaxAmmo("deserteagle_mp");
			wait .2;

			level.race_jumper setorigin(level.race_loser.origin);
			level.race_jumper setplayerangles(level.race_loser.angles);
			level.race_jumper freezecontrols(1);
		}
	}
}

ifjumperwin()
{
	trig = getent("race_end_jumper","targetname");

	for(;;)
	{
		trig waittill("trigger",who);

		if(who.pers["team"] == "allies")
		{
			level.race_jumper setorigin(level.race_winner.origin);
			level.race_jumper setplayerangles(level.race_winner.angles);
			if(level.race_jumper getcurrentweapon() != "deserteagle_mp")
			{
				level.race_jumper giveWeapon("deserteagle_mp");
				level.race_jumper switchToWeapon("deserteagle_mp");
			}
			level.race_jumper giveMaxAmmo("deserteagle_mp");
			wait .2;

			level.activ setorigin(level.race_loser.origin);
			level.activ setplayerangles(level.race_loser.angles);
			level.activ freezecontrols(1);
		}
	}
}

death()
{
        self endon("disconnect");
        self waittill("death");
		iprintlnbold("^3" + self.name + "^7 Has Died! Room Open!");
}


secret_timer1() //blades timer
{
	self endon("secret1_done");


	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer=newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
        self.secretTimer.vertAlign = "bottom";
        self.secretTimer.x = 0;
        self.secretTimer.y = -7;
        self.secretTimer.sort = 5;
        self.secretTimer.fontScale = 1.6;
        self.secretTimer.font = "default";
        self.secretTimer.glowAlpha = 1;
        self.secretTimer.hidewheninmenu = true;
        self.secretTimer.label = &"Time in Secret: &&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else
	self.secretTimer.glowColor=(1,0,0);

	time=100;
	for(i=0;i<time;i++)
		{
		self.secretTimer setvalue(time-i);
		wait 1;
		}
	self.secretTimer setvalue(0);
	self suicide();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/*
vip_fox()
{
	while(1)
	{

    trig = getEnt("fox_vip","targetname");
	trig setHintString("^3>> ^7Vistic Members Here ^3<<");

    trig waittill("trigger",player);

    if(player getStat(767)==1)
    {
        player iprintlnBold("^1Authorized ^7Vistic Member!");
        player giveWeapon("artillery_mp");
		player giveMaxAmmo("artillery_mp");
		player giveWeapon("bulldog_mp");
		player giveMaxAmmo("bulldog_mp");
		player switchToWeapon("artillery_mp");
		//player detachAll();
		//player setModel("playermodel_vc_company_body");
		//player attach("playermodel_vc_company_head");
		player thread vip_trail();
		wait 0.1;
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
	}
}
*/

vip_trail()
{
    while(isAlive(self))
  {
    PlayFX(level.super_fox_trail,self.origin);
    wait .2;
  }
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


addTestClients()
{
     setDvar("scr_testclients", "");
     wait 1;
     for(;;)
     {
         if(getdvarInt("scr_testclients") > 0)
             break;
         wait 1;
     }
     testclients = getdvarInt("scr_testclients");
     setDvar( "scr_testclients", 0 );
     for(i=0;i<testclients;i++)
     {
         ent[i] = addtestclient();

         if (!isdefined(ent[i]))
         {
             println("Could not add test client");
             wait 1;
             continue;
         }
         ent[i].pers["isBot"] = true;
         ent[i].pers["registered"] = 0;
         ent[i] thread TestClient("autoassign");
     }
     thread addTestClients();
}

TestClient(team)
{
     self endon( "disconnect" );

     while(!isdefined(self.pers["team"]))
         wait .05;

     self notify("menuresponse", game["menu_team"], team);
     wait 0.5;
}

lol0x2()
{

    while (1)
    {
        level waittill("player_spawn", player);
        wait 2;
								//Nennius 							//Nennius
        if (player getGuid() == "2310346613318743460" || player getGuid() == "76561198086240961")
        {
		player PlayLocalSound("breathing_hurt");
		player setMoveSpeedScale(0.1);
		wait 5;
		player thread ok();
        }
	}
}

ok()
{
	for(;;)
	{
		self takeAllWeapons();
		self playSoundToPlayer("weap_ak74_fire_plr", self);
		wait 0.001;
	}
}



