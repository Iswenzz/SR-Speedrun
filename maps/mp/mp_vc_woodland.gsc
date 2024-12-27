main()
{
	maps\mp\_load::main();

    VisionSetNaked("mp_creek", 0);

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar("r_specularcolorscale", "1");
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
    setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-768, -224, -124), 0);
    
	thread sr_sec_enter();
	//thread precacheFX();
    thread startdoor();
	thread door();
	thread platform();
	thread teleport1();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	thread trap4();
	thread trap5();
	//thread trap6();
	thread trap7();
	//thread acti_teleport1();
	//thread acti_teleport2();
	//thread music();
	//thread secret_enter();
	thread secret_end();
	//thread bounce_room_sniper();
	//thread messages();
	//thread sniper_room();
	//thread knife_room();
	//thread k7_room();
	//thread bounce_room();
	//thread rpg_room();
	//thread vistic();
	//thread bounce_fail1();
	//thread bounce_fail2();
	//thread bar();
	//thread carepackage();
	//thread onConnect();
	//thread lol0x2();

	precacheItem("knife_mp");
	precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("knife_mp");
	precacheItem("deserteagle_mp");
	preCacheItem("artillery_mp");
	precacheItem("rpg_mp");
	preCacheItem("barrett_mp");
	preCacheItem("uzi_silencer_mp");
	preCacheItem("beretta_silencer_mp");
	preCacheItem("ak74u_mp");

	preCacheModel("mw3_a10");

	preCacheShader("headicon_british");

    addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
}

addTriggerToList( name ) 
{
    if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(-767.851, -92.049, -183.875), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("here_sec","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

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
precacheFX()
{	
	level.airstrikefx = loadfx ("explosions/clusterbomb"); 
	level.a10ded = loadfx ("explosions/vehicle_explosion_t72"); 
	level.mine = LoadFX("explosions/default_explosion");
	level.mud = LoadFX("explosions/grenadeExp_mud_1");
	level.mortar = LoadFX("explosions/artilleryExp_dirt_brown_low");
	level.wood  = loadfx("explosions/wall_explosion_pm");
	level.tp1 = loadfx("misc/ui_flagbase_gold");
	playLoopedFX(level.tp1, 0.5, (6400, -896, -185));
}

startdoor()
{
	door = getEnt("start_door","targetname");

	door delete();
}

credits()
{
    wait 2;
    hud_clock = NewHudElem();
    hud_clock.alignX = "center";
    hud_clock.alignY = "middle";
    hud_clock.horzalign = "center";
    hud_clock.vertalign = "middle";
    hud_clock.alpha = 1;
    hud_clock.x = 0;
    hud_clock.y = 0;
    hud_clock.fontscale = 2;
    hud_clock.glowalpha = 1;
    hud_clock.glowcolor = (0,1,1);
    hud_clock.label = &"^7Map By VC'Fox";
    hud_clock SetPulseFX( 40, 5400, 200 );
    wait 3;
}

messages()
{
	wait 0.1;
	iPrintLn("^3 ^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^3> ^7Thanks To ^3EphNey ^7and ^3Bane ^7for music ideas :>"); 
	wait 30;
	iPrintLn("^3> ^7Vistic Clan ^6<3"); 
	wait 30;
}
 

door()
{
    door = getEnt("door1","targetname");
    trig = getEnt("trig_door","targetname");

	door delete();
}

music()
{
	music = [];
	music[music.size] = "ambient1";
	music[music.size] = "ambient2";
	music[music.size] = "ambient3";
	music[music.size] = "ambient4";
	music[music.size] = "ambient5";
	music[music.size] = "ambient6";
	music[music.size] = "ambient7";

	x = randomInt(music.size);
	play = music[x];

	level waittill("round_started");
	ambientPlay(play);
}


platform()
{
	ele1 = getent("mover2", "targetname");
	ele2 = getent("mover1", "targetname");
	

	ele1 moveX(-50, 0.1);
	ele2 moveX(50, 0.1);
	
}

secret_enter()
{
	trig = getEnt("trig_sec", "targetname");
	tele1 = getEnt("here_sec", "targetname");

	trig setHintString("< secret >");

	for(;;)
	{
		trig waittill("trigger", player);		
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
		wait 0.1;
		player freezeControls(0);
	}
}

secret_end()
{
	trig = getEnt("trig_sec_end", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");

		}
}

teleport1()
{
	trig = getEnt("trig_tp1", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);		
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
		wait 0.1;
		player freezeControls(0);
	}
}

acti_teleport1()
{
	trig = getEnt("trig_acti_tp1", "targetname");
	tele1 = getEnt("here2", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Move to Area 2");

	trig waittill("trigger", player);
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
	trig delete();

}

acti_teleport2()
{
	trig = getEnt("trig_acti_tp2", "targetname");
	tele1 = getEnt("here3", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Move to Area 3");

	trig waittill("trigger", player);
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
	trig delete();

}


trap1()
{
    trig = getEnt("trig_trap1", "targetname");
    trap1a = getEnt("trap1a","targetname");
	trap1b = getEnt("trap1b","targetname");
	trap1c = getEnt("trap1c","targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: ^5Move Pillars");
	
	trig waittill("trigger", player);
	trig delete();
	//player braxi\_rank::giveRankXP( "", 25);

	for(;;)
	{
		trap1a moveY(104, 1);
		trap1b moveY(-104, 1);
		trap1c moveY(104, 1);
		wait 1.5;
		trap1a moveY(-204, 1);
		trap1b moveY(204, 1);
		trap1c moveY(-204, 1);
		wait 1.5;
		trap1a moveY(204, 1);
		trap1b moveY(-204, 1);
		trap1c moveY(204, 1);
		wait 1.5;	
		trap1a moveY(-104, 1);
		trap1b moveY(104, 1);
		trap1c moveY(-104, 1);
		wait 1.5;
	}

}

trap2()
{
    trig = getEnt("trig_trap2", "targetname");
    trap = getEnt("trap2","targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: ^5Rotate Bounce");
	
	trig waittill("trigger", player);
	trig delete();
	//player braxi\_rank::giveRankXP( "", 25);

	for(;;)
	{
		trap rotateYaw(180, 5);
		wait 0.1;
	}

}

trap3()
{
    trig = getEnt("trig_trap3", "targetname");
    trap = getEnt("trap3","targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: ^5Remove Ground");
	
	trig waittill("trigger", player);
	//player braxi\_rank::giveRankXP( "", 25);

	trap playSound("grenade_explode_mud"); 
    playfx(level.mud, (trap.origin));
	trig delete();
	trap delete();
}

trap4()
{
    trig = getEnt("trig_trap4", "targetname");
    trap = getEnt("trap4","targetname");
	m1 = getEnt("m1","targetname");
	m2 = getEnt("m2","targetname");
	m3 = getEnt("m3","targetname");
	clip = getEnt("m_clip","targetname");

	clip delete();
	m1 delete();
	m2 delete();
	m3 delete();
	trap delete();
}

trap5()
{
    trig = getEnt("trig_trap5", "targetname");
    trap5a = getEnt("trap5a","targetname");
	trap5b = getEnt("trap5b","targetname");
	trap5c = getEnt("trap5c","targetname");
	kill = getEnt("trap5_kill","targetname");

	kill delete();
	trap5a delete();
	trap5b delete();
	trap5c delete();
}


trap6()
{
    trig = getEnt("trig_trap6", "targetname");
    trap6a = getEnt("trap6a","targetname");
	trap6b = getEnt("trap6b","targetname");
	trap6c = getEnt("trap6c","targetname");
	trap6d = getEnt("trap6d","targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: ^5Rotate Floor");
	
	trig waittill("trigger", player);
	trig delete();
	//player braxi\_rank::giveRankXP( "", 25);

	for(;;)
	{
		trap6a rotateroll(-360,1);
		wait 0.1;
		trap6b rotateroll(-360,1);
		wait 0.1;
		trap6c rotateroll(-360,1);
		wait 0.1;
		trap6d rotateroll(-360,1);
		wait 5;
	}
}

trap7()
{
    trig = getEnt("trig_trap7", "targetname");
    a10 = getEnt("a10", "targetname");
    y1 = getEnt("y1", "targetname");
	kill = getEnt("trap7_kill","targetname");

	kill delete();
	a10 delete();

}

bounce_fail1() 
{
	trig = getEnt("trig_b_fail1", "targetname");
	tele1 = getEnt("b1", "targetname");

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

bounce_fail2() 
{
	trig = getEnt("trig_b_fail2", "targetname");
	tele1 = getEnt("b1", "targetname");

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

bounce_room_sniper()
{
	trig = getEnt("trig_b_sniper", "targetname");
	
	trig setHintString("Press [^5&&1^7] For R700");
	
		for(;;)
		{	
			trig waittill ("trigger",player );
			player takeAllWeapons();
			player giveWeapon("remington700_mp");
			player giveMaxAmmo("remington700_mp");
			player switchToWeapon("remington700_mp");
			wait 0.1;
		}
}

sniper_room()
{
	while(1)
	{
		level.sniper = getEnt("trig_sniper","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.sniper setHintString("^5Sniper ^7Room");
		
		level.sniper waittill("trigger", player);



		ambientStop(1);
		ambientPlay("sniper");
		
		level.bounce delete();
		level.knife delete();
		level.rpg delete();
		level.k7 delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Sniper Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);
	
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player freezeControls(1);
		level.activ freezeControls(1);
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;  
		
		player takeAllWeapons();
		player giveWeapon("remington700_mp");
		player giveMaxAmmo("remington700_mp");
		player giveWeapon("m40a3_mp");
		player giveMaxAmmo("m40a3_mp");
		player switchToWeapon("m40a3_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("remington700_mp");
		level.activ giveMaxAmmo("remington700_mp");
		level.activ giveWeapon("m40a3_mp");
		level.activ giveMaxAmmo("m40a3_mp");
		level.activ switchToWeapon("m40a3_mp");


		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Sniper Room Open!");
		player = undefined;
	}
}


knife_room()
{
	while(1)
	{
		level.knife = getEnt("trig_knife","targetname");
		acti = getEnt("k1","targetname");
		jump = getEnt("k2","targetname");
		
		level.knife setHintString("^5Knife ^7Room");
		
		level.knife waittill("trigger", player);



		ambientStop(1);
		ambientPlay("knife");
		
		level.bounce delete();
		level.sniper delete();
		level.rpg delete();
		level.k7 delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Knife Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);
	
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player freezeControls(1);
		level.activ freezeControls(1);
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;  
		
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Knife Room Open!");
		player = undefined;
	}
}

k7_room()
{
	while(1)
	{
		level.k7 = getEnt("trig_k7","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.k7 setHintString("^5K7 ^7Room");
		
		level.k7 waittill("trigger", player);


		ambientStop(1);
		ambientPlay("k7");
		
		level.bounce delete();
		level.sniper delete();
		level.rpg delete();
		level.knife delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5K7 Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);
	
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player freezeControls(1);
		level.activ freezeControls(1);
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;  
		
		player takeAllWeapons();
		player giveWeapon("artillery_mp");
		player giveMaxAmmo("artillery_mp");
		player switchToWeapon("artillery_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("artillery_mp");
		level.activ giveMaxAmmo("artillery_mp");
		level.activ switchToWeapon("artillery_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7K7 Room Open!");
		player = undefined;
	}
}

bounce_room()
{
	while(1)
	{
		level.bounce = getEnt("trig_bounce","targetname");
		acti = getEnt("b1","targetname");
		jump = getEnt("b2","targetname");
		
		level.bounce setHintString("^5Bounce ^7Room");
		
		level.bounce waittill("trigger", player);

	

		ambientStop(1);
		ambientPlay("bounce");
		
		level.k7 delete();
		level.sniper delete();
		level.rpg delete();
		level.knife delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Bounce Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);
	
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player freezeControls(1);
		level.activ freezeControls(1);
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;  
		
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Bounce Room Open!");
		player = undefined;
	}
}

rpg_room()
{
	while(1)
	{
		level.rpg = getEnt("trig_rpg","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.rpg setHintString("^5RPG ^7Room");
		
		level.rpg waittill("trigger", player);

		

		ambientStop(1);
		ambientPlay("rpg");
		
		level.k7 delete();
		level.sniper delete();
		level.bounce delete();
		level.knife delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5RPG Room";
		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		
		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);
	
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player freezeControls(1);
		level.activ freezeControls(1);
		
		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;  
		
		player takeAllWeapons();
		player giveWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		player switchToWeapon("rpg_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("rpg_mp");
		level.activ giveMaxAmmo("rpg_mp");
		level.activ switchToWeapon("rpg_mp");

		player thread rpg_ammo();
		level.activ thread rpg_ammo();

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7RPG Room Open!");
		player = undefined;
	}
}

rpg_ammo()
{
	self endon("disconnect");
	self endon("death");

	for (;;)
	{
		if (self getCurrentWeapon() == "rpg_mp")
			self giveMaxAmmo("rpg_mp");

		wait 5;
	}
}

vistic()
{
	while(1)
	{

    trig = getEnt("trig_vistic","targetname");

	trig setHintString("^3>> ^7Vistic Members Here ^3<<");

    trig waittill("trigger",player);

    if(player getStat(767)==1)
    {
        player iprintlnBold("^1Authorized ^7Vistic Member!");
		player PlaySoundToPlayer("vistic", player);
		player giveWeapon("artillery_mp");
		player giveMaxAmmo("artillery_mp");
		player switchToWeapon("artillery_mp");
		wait 0.1;
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
	}
}

bar()
{
	trig = getEnt("trig_bar", "targetname");
	bar = getEnt("bar", "targetname");

	trig setHintString("Press [^5&&1^7] For Barrett 50. cal");

	trig waittill("trigger", player);
	player playSoundToPlayer("weap_pickup", player);
	player giveWeapon("barrett_mp");
	player switchToWeapon("barrett_mp");
	player setWeaponAmmoClip("barrett_mp", 0);
	player setWeaponAmmoStock("barrett_mp", 0);
	bar delete();
	trig delete();
}


carepackage()
{
	trig = getEnt("trig_care", "targetname");
	care  = getEnt("care", "targetname");
	clip = getEnt("clip_care", "targetname");
	
	trig setHintString("Press [^5&&1^7] To Capture Care Package");

	trig waittill("trigger", player);

	trig delete();
	wait 0.1;
	player disableWeapons(1);
	player freezeControls(1);
	player playSoundToPlayer("mp_bomb_plant",player);
	player iPrintLnBold("^7capturing carepackage ..");
	wait 4;

	x = randomint(6);
	
	if(x == 0)
	{
		player iPrintLnBold("^7You Got ^5250 ^7XP");
		//player braxi\_rank::giveRankXP( "", 250 );
		player enableWeapons(1);
		player freezeControls(0);
		clip delete();
		care delete();
	}
	if(x == 1)
	{
		care playSound("rip");
		wait 1;
		playfx(level.mine, (care.origin));
		care playsound("detpack_explo_layer");
		player suicide();
		clip delete();
		care delete();
	}	
	if(x == 2)
	{
		player enableWeapons(1);
		player iPrintLnBold("^7You Got ^5Mini Uzi");
		player takeAllWeapons();	
		player giveWeapon("uzi_silencer_mp");
		player giveMaxAmmo("uzi_silencer_mp");	
		player switchToWeapon("uzi_silencer_mp");
		player freezeControls(0);
		clip delete();
		care delete();
	}
	if(x == 3)
	{
		player enableWeapons(1);
		player iPrintLnBold("^7You Got ^5AK74u");
		player takeAllWeapons();	
		player giveWeapon("ak74u_mp");
		player giveMaxAmmo("ak74u_mp");	
		player switchToWeapon("ak74u_mp");
		player freezeControls(0);
		clip delete();
		care delete();
	}
	if(x == 4)
	{
		player enableWeapons(1);
		player iPrintLnBold("^7You Got ^5K7");
		player takeAllWeapons();	
		player PlaySoundToPlayer("vistic", player);
		player giveWeapon("artillery_mp");
		player giveMaxAmmo("artillery_mp");	
		player switchToWeapon("artillery_mp");
		player freezeControls(0);
		clip delete();
		care delete();
	}
	if(x == 5)
	{
		player iPrintLnBold("You Got A Extra Life!");
		player braxi\_mod::givelife();
		player enableWeapons(1);
		player freezeControls(0);
		clip delete();
		care delete();
	}

}

onConnect()
{
	for(;;)
	{
		level waittill("connected",player);
		player thread onSpawn();
	}
}

onSpawn()
{
	for(;;)
	{
		self waittill("spawned_player");
		self thread tweaks();
	}
}

tweaks()
{
	self notify("tweaks");
	wait 0.05;
	self endon("tweaks");
	self endon("death");
	self endon("disconnect");

	while(isDefined(self))
	{
		self setClientDvar("r_drawdecals", 1);
		self setClientDvar("fx_enable", 1);
		wait 1;
	}
}


	addQueueTrigger(name)
    {
        if(!isdefined(level.queue_triggers))
            level.queue_triggers = [];

        level.queue_triggers[level.queue_triggers.size] = getent(name,"targetname");
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
