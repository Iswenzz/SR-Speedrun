/*			            				  
	By VC' Fox
	Thanks to Blade for his music menu
	Vistic Disord: https://discord.gg/JKwXV3h
	vistic-clan
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
	
	VisionSetNaked("mp_creek", 0);
	setDvar("r_drawDecals","1");
	setDvar( "r_specularcolorscale", "1" );
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
    setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);

	precacheMenu("bouncezor_music");

	precacheShader("vistic_clan");
	
	precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("knife_mp");
	precacheItem("ak74u_mp");
	precacheItem("ak47_mp");
	precacheItem("deserteagle_mp");
	precacheItem("winchester1200_mp");
	precacheItem("uzi_mp");
	precacheItem("saw_mp");
	precacheItem("dragunov_mp");
	precacheItem("brick_blaster_mp");
	precacheItem("rpg_mp");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
	thread sr\api\_map::createSpawn((-712, 1440, 68), 0);
	thread sr\api\_speedrun::createTeleporter((3008.73, -2591.54, 64.125), 95, 100, (3045, -3273, 124), 210, "freeze");
	thread sr\api\_speedrun::createTeleporter((-711.897, 1273.49, 8.125), 60, 100, (-2813, 5349, -4), 89, "freeze", "green", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-712.183, 1612.71, 8.125), 60, 100, (696, 5988, -4), 90, "freeze", "orange", "secret_1");

	thread startdoor();
	//thread precacheFX();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread jumper_tp();
	//thread acti_tp();
	//thread platform();
	//thread glass1();
	//thread glass2();
	thread sec_step1();
	thread sec_quit();
	//thread give_ak74u();
	//thread give_deagle();
	//thread give_ak47();
	//thread give_r700();
	//thread easy_enter();
	thread easy_leave();
	thread easy_fail1();
	thread easy_fail2();
	//thread hard_enter();
	thread hard_fail1();
	thread hard_fail2();
	thread hard_fail3();
	thread hard_fail4();
	thread hard_leave();
	//thread sniper_room();
	//thread wep_room();
	//thread bounce_room();
	//thread knife_room();
	//thread climb_room();
	//thread rpg_room();
	//thread old_room();
	//thread music();
	//thread bounce_room_fail();
	//thread climb_room_fail();
	//thread messages();
	//thread vistic();
	//thread friends();
	
	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
}

addTriggerToList(name) 
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name , "targetname");
}

startdoor()
{
	door = getEnt("startdoor","targetname");

	door delete();

}

precacheFX()
{	
	level.glass = loadfx("props/car_glass_large");
	level.c4 = loadfx ("explosions/default_explosion"); 
	level.speakerfx = loadfx("deathrun/trail_hippy_fox");
	playLoopedFX(level.speakerfx, 0.1, (-930.00, 1396.00, 20.00));
	playLoopedFX(level.speakerfx, 0.1, (-930.00, 1488.00, 20.00));
	playLoopedFX(level.speakerfx, 0.1, (4608.00, -7680.00, -50.00));
	playLoopedFX(level.speakerfx, 0.1, (1536.00, -10368.00, 140.00));
}

messages()
{
	for(;;)
	{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^7Made For Vistic-Clan"); 
	wait 30;
	iPrintLn("^7Vistic Discord: ^3https://discord.gg/JKwXV3h"); 
	wait 30;
	iPrintLn("^7Thanks to VC'Blade for the music menu <3"); 
	wait 20;
	}
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
    hud_clock.label = &"^7Map By ^3VC'Fox";
    hud_clock SetPulseFX(40, 5400, 200);
    wait 3;
	hud_clock destroy();
}

trap1()
{
    trig = getEnt("trig_trap1", "targetname");
    trap1a = getEnt("trap1a","targetname");
	trap1b = getEnt("trap1b","targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Split Bounce");
	
	trig waittill("trigger", player);

}

trap2()
{
    trig = getEnt("trig_trap2", "targetname");
    trap2 = getEnt("trap2","targetname");

	trap2 hide();
	trap2 notSolid();

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Block Jumpers");
	
	trig waittill("trigger", player);

}

trap3()
{
    trig = getEnt("trig_trap3", "targetname");
    trap3 = getEnt("trap3","targetname");
	kill = getEnt("trap3_dmg","targetname");

	kill maps\mp\_utility::triggerOff();

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Detonate C4");
	
	trig waittill("trigger", player);

}

trap4()
{
	trig = getEnt("trig_trap4", "targetname"); 

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate: Random Pillars");
	
	trig waittill("trigger", player);

}

trap4_a()
{
	trig = getEnt("trap4a_trig","targetname");
	brush = getEnt("trap4a", "targetname");

	trig waittill ("trigger", player);
	
	
}

trap4_b()
{
	trig = getEnt("trap4b_trig","targetname");
	brush = getEnt("trap4b", "targetname");

	trig waittill ("trigger", player);
	
	
}

trap4_c()
{
	trig = getEnt("trap4c_trig","targetname");
	brush = getEnt("trap4c", "targetname");

	trig waittill ("trigger", player);
	
	
}

trap5()
{
    trig = getEnt("trig_trap5", "targetname");
    trap5 = getEnt("trap5","targetname");
	kill = getEnt("trap5_dmg","targetname");

	trap5 hide();
	trap5 notSolid();

	kill maps\mp\_utility::triggerOff();

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Spike Trap");
	
	trig waittill("trigger", player);

}

trap6()
{
    trig = getEnt("trig_trap6", "targetname");
    trap6a = getEnt("trap6a","targetname");
	trap6b = getEnt("trap6b","targetname");

	trap6a hide();
	trap6a notSolid();

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Spawn Blocked Bounce");
	
	trig waittill("trigger", player);

}

trap7()
{
    trig = getEnt("trig_trap7", "targetname");
    trap7 = getEnt("trap7","targetname");

	trap7 hide();
	trap7 notSolid();

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Block Jumpers");
	
	trig waittill("trigger", player);

}

trap8()
{
    trig = getEnt("trig_trap8", "targetname");
    trap8 = getEnt("trap8","targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Trap: Delete Floor");
	
	trig waittill("trigger", player);
	
}

jumper_tp()
{
	trig = getEnt("trig_tp1", "targetname");
	tele1 = getEnt("here1", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Move To Next Area");

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

acti_tp()
{
	trig = getEnt("trig_acti_tp", "targetname");
	tele1 = getEnt("here_acti", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Move To Next Area");

	trig waittill("trigger", player);
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
	trig delete();
}




platform()
{
	elev = getent("ele", "targetname");
	
	for(;;)
	{
	wait 0.1;
	elev moveY (-484, 1.5);
	wait 4;
	elev moveY (484, 1.5);
	wait 4;
	}	
}

glass1()
{
    trig = getEnt("trig_glass1", "targetname");
    glass = getEnt("glass1","targetname");
	
	trig waittill("trigger", player);

	glass playsound("window_entry_glass_med");
	playfx(level.glass, (glass.origin));
	wait 0.1;
	glass delete();
	trig delete();
}

glass2()
{
    trig = getEnt("trig_glass2", "targetname");
    glass = getEnt("glass2","targetname");
	
	trig waittill("trigger", player);

	glass playsound("window_entry_glass_med");
	playfx(level.glass, (glass.origin));
	wait 0.1;
	glass delete();
	trig delete();
}

sec_step1()
{
	trig = getEnt("trig_sec1", "targetname"); 
	trig2 = getEnt("trig_sec_enter", "targetname");
	brush = getEnt("sec_enter", "targetname");

	trig2 maps\mp\_utility::triggerOff();

	brush hide();
	brush notSolid();
	
	trig waittill("trigger", player);

    trig delete();
	iPrintLn("^3Secret: ^71/3");
	thread sec_step2();
}

sec_step2()
{
	trig = getEnt("trig_sec2", "targetname"); 
	
	trig waittill("trigger", player);

    trig delete();
	iPrintLn("^3Secret: ^72/3");
	thread sec_step3();
}

sec_step3()
{
	trig = getEnt("trig_sec3", "targetname");
	
	trig waittill("trigger", player);

    trig delete();
	iPrintLn("^3Secret: ^73/3");
	wait 0.1;
	iPrintLn("^3Secret: ^7Open!");
	thread sec_open();
}

sec_open()
{
	trig = getEnt("trig_sec_enter", "targetname");
	brush = getEnt("sec_enter", "targetname");
	tele1 = getEnt("here_sec", "targetname");

	brush show();
	brush solid();
	trig maps\mp\_utility::triggerOn();
	playLoopedFX(level.speakerfx, 0.1, (448.00, 2600.00, 8.00));
	wait 0.1;
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

sec_quit()
{
	trig = getEnt("trig_2hard4u", "targetname");
	tele1 = getEnt("sec_quit", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Leave Secret Room");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 1;
			player freezeControls(0);
		}
}

give_ak74u()
{
	trig = getEnt("trig_ak74u", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7For AK-74u");

	for(;;)
		{
			trig waittill("trigger", player);
			player takeAllWeapons();
			player giveWeapon("ak74u_mp");
			player giveMaxAmmo("ak74u_mp");
			player switchToWeapon("ak74u_mp");
			wait 0.1;
		}
}

give_deagle()
{
	trig = getEnt("trig_deagle", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7For Desert Eagle");

	for(;;)
		{
			trig waittill("trigger", player);
			player takeAllWeapons();
			player giveWeapon("deserteagle_mp");
			player giveMaxAmmo("deserteagle_mp");
			player switchToWeapon("deserteagle_mp");
			wait 0.1;
		}
}

give_r700()
{
	trig = getEnt("trig_r700", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7For R700");

	for(;;)
		{
			trig waittill("trigger", player);
			player takeAllWeapons();
			player giveWeapon("remington700_mp");
			player giveMaxAmmo("remington700_mp");
			player switchToWeapon("remington700_mp");
			wait 0.1;
		}
}

give_ak47()
{
	trig = getEnt("trig_ak47", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7For AK-47");

	for(;;)
		{
			trig waittill("trigger", player);
			player takeAllWeapons();
			player giveWeapon("ak47_mp");
			player giveMaxAmmo("ak47_mp");
			player switchToWeapon("ak47_mp");
			wait 0.1;
		}
}

easy_enter()
{
	trig = getEnt("trig_easy_enter", "targetname");
	tele1 = getEnt("here_easy", "targetname");

	trig setHintString("^5Easy Secret");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.05;
			player freezeControls(0);
		}
}

easy_leave()
{
	trig = getEnt("trig_easy_leave", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
}

easy_fail1()
{
	trig = getEnt("trig_easy_f_1", "targetname");
	tele1 = getEnt("here_easy", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

easy_fail2()
{
	trig = getEnt("trig_easy_f_2", "targetname");
	tele1 = getEnt("easy_r2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

hard_enter()
{
	trig = getEnt("trig_hard_enter", "targetname");
	tele1 = getEnt("here_hard", "targetname");

	trig setHintString("^1Hard Secret");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.05;
			player freezeControls(0);
		}
}

hard_fail1()
{
	trig = getEnt("trig_hard_f1", "targetname");
	tele1 = getEnt("here_hard", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

hard_fail2()
{
	trig = getEnt("trig_hard_f2", "targetname");
	tele1 = getEnt("here_hard", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}


hard_fail3()
{
	trig = getEnt("trig_hard_f3", "targetname");
	tele1 = getEnt("hard_r2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

hard_fail4()
{
	trig = getEnt("trig_hard_f4", "targetname");
	tele1 = getEnt("hard_r3", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

hard_leave()
{
	trig = getEnt("trig_hard_end", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_1");
		}
}

bounce_room_fail()
{
	trig = getEnt("trig_bounce_fail","targetname");
	acti_f = getEnt("b1","targetname");
	jumper_f = getEnt("b2","targetname");

	while(1)
	{
		trig waittill("trigger",player);
		if(player.pers["team"] == "allies")
		{
			player freezeControls(1);
			player setOrigin(jumper_f.origin);
			player setPlayerAngles(jumper_f.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.1;
		}
		else
		{
			player freezeControls(1);
			player setOrigin(acti_f.origin);
			player setPlayerAngles(acti_f.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.1;
		}
	}
}

climb_room_fail()
{
	trig = getEnt("trig_climb_fail","targetname");
	acti_f = getEnt("c1","targetname");
	jumper_f = getEnt("c2","targetname");

	while(1)
	{
		trig waittill("trigger",player);
		if(player.pers["team"] == "allies")
		{
			player freezeControls(1);
			player setOrigin(jumper_f.origin);
			player setPlayerAngles(jumper_f.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.1;
		}
		else
		{
			player freezeControls(1);
			player setOrigin(acti_f.origin);
			player setPlayerAngles(acti_f.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.1;
		}
	}
}


secret_timer()
{
	self endon("secret_done");
	self endon("death");
	self endon("round_ended");
	self thread destroyOnDeath();
	
	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer = newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
	self.secretTimer.vertAlign = "bottom";
	self.secretTimer.x = 0;
	self.secretTimer.y = -7;
	self.secretTimer.sort = 5;
	self.secretTimer.fontScale = 1.4;
	self.secretTimer.font = "default";
	self.secretTimer.glowAlpha = 0;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"^7Time in Secret: ^5&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor = level.randomcolor;
	else 
	self.secretTimer.glowColor = (1,0,0);

	time = 90; 
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

destroyOnDeath()
{

	self waittill("death");

	if(isDefined(self.secretTimer))

	self.secretTimer destroy();
}

sniper_room()
{
	while(1)
	{
		level.trigsniper = getEnt("trig_sniper","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigsniper setHintString("^5Sniper ^7Room");
		
		level.trigsniper waittill("trigger", player);

		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigwep delete();
		level.trigclimb delete();
		level.trigrpg delete();
		level.old delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Sniper Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
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

wep_room()
{
	while(1)
	{
		level.trigwep = getEnt("trig_wep","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigwep setHintString("^5Random Weapon ^7Room");
		
		level.trigwep waittill("trigger", player);
		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigsniper delete();
		level.trigclimb delete();
		level.trigrpg delete();
		level.old delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Random Weapon Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
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
		
		random_weapon = [];
		random_weapon[random_weapon.size] = "winchester1200_mp";
		random_weapon[random_weapon.size] = "ak74u_mp";
		random_weapon[random_weapon.size] = "ak47_mp";
		random_weapon[random_weapon.size] = "deserteagle_mp";
		random_weapon[random_weapon.size] = "uzi_mp";
		random_weapon[random_weapon.size] = "saw_mp";
		random_weapon[random_weapon.size] = "brick_blaster_mp";
		random_weapon[random_weapon.size] = "dragunov_mp";
			
		x = randomInt(random_weapon.size);
			
		wep = random_weapon[x];
			
		player takeAllWeapons();
		player giveWeapon(wep);
		player giveMaxAmmo(wep);	
		player switchToWeapon(wep);
		player iPrintLnBold("^7Your Weapon: ^3 "+wep.name);
		
		level.activ takeAllWeapons();
		level.activ giveWeapon(wep);
		level.activ giveMaxAmmo(wep);
		level.activ switchToWeapon(wep);
		level.activ iPrintLnBold("^7Your Weapon: ^3 "+wep.name);

		wait 4;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Random Weapon Room Open!");
		player = undefined;
		
	}
}

knife_room()
{
	while(1)
	{
		level.trigknife = getEnt("trig_knife","targetname");
		acti = getEnt("k1","targetname");
		jump = getEnt("k2","targetname");
		
		level.trigknife setHintString("^5Knife ^7Room");
		
		level.trigknife waittill("trigger", player);
		
		level.trigsniper delete();
		level.trigbounce delete();
		level.trigwep delete();
		level.trigclimb delete();
		level.trigrpg delete();
		level.old delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Knife Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
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

bounce_room()
{
	while(1)
	{
		level.trigbounce = getEnt("trig_bounce","targetname");
		acti = getEnt("b1","targetname");
		jump = getEnt("b2","targetname");
		
		level.trigbounce setHintString("^5Bounce ^7Room");
		
		level.trigbounce waittill("trigger", player);

		level.trigknife delete();
		level.trigsniper delete();
		level.trigwep delete();
		level.trigclimb delete();
		level.trigrpg delete();
		level.old delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Bounce Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
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

climb_room()
{
	while(1)
	{
		level.trigclimb = getEnt("trig_climb","targetname");
		acti = getEnt("c1","targetname");
		jump = getEnt("c2","targetname");
		
		level.trigclimb setHintString("^5Climb ^7Room");
		
		level.trigclimb waittill("trigger", player);

		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigrpg delete();
		level.old delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5Climb Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
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
		iPrintLnBold("^7Climb Room Open!");
		player = undefined;
	}
}

rpg_room()
{
	while(1)
	{
		level.trigrpg = getEnt("trig_rpg","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigrpg setHintString("^5RPG ^7Room");
		
		level.trigrpg waittill("trigger", player);

		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigwep delete();
		level.trigclimb delete();
		level.trigsniper delete();
		level.old delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^5RPG Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
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
		player switchToWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("rpg_mp");
		level.activ switchToWeapon("rpg_mp");
		level.activ giveMaxAmmo("rpg_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");

		player thread rpg_ammo();
		level.activ thread rpg_ammo();
		
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

old_room()
{
	level.old = getEnt ("trig_old", "targetname");
	door = getEnt ("old_door", "targetname");
	tele1 = getEnt("here_acti", "targetname");

	level.old setHintString("^5Old ^7Room");
	while(1){
	level.old waittill ("trigger", player);


	level.trigknife delete();
	level.trigsniper delete();
	level.trigwep delete();
	level.trigclimb delete();
	level.trigrpg delete();
	level.trigbounce delete();

	iPrintLnBold("^3" + player.name + " ^7Opened The Old Way");

	wait 2;

	level.activ freezeControls(1);
	level.activ setOrigin(tele1.origin);
	level.activ setPlayerAngles(tele1.angles);
	wait 0.5;
	level.activ freezeControls(0);

	wait 2;
	door playsound("grenade_explode_concrete");
	playfx(level.c4, (door.origin));;
	door delete();
	level.old delete();
  }
}

music()
{
	trig = getEnt("trig_music","targetname");
	trig setHintString("Press [^3&&1^7] ^7to Open Music Menu");

	trig waittill("trigger",who);
	if(!isdefined(level.music_chosen))
	{
		level.music_chosen = true;

		who thread onmenuresponse();
		who openMenu("bouncezor_music");
	}
}

onmenuresponse()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("menuresponse",menu,response);

		if(menu == "bouncezor_music")
		{
			switch(response)
			{
				case "0":
					thread play_ambient_song(0,"Speed Limits & Jaco ft. Joni Fatora - Palm Of Your Hand");
					break;
				case "1":
					thread play_ambient_song(1,"Pegboard Nerds & Stonebank & EMEL - Falling Apart");
					break;
				case "2":
					thread play_ambient_song(2,"Vosai - See The Light");
					break;
				case "3":
					thread play_ambient_song(3,"Twenty One Pilots - Shy Away");
					break;
				case "4":
					thread play_ambient_song(4,"Assaf & Jeremy Vancaulart - Citadel");
					break;
				case "5":
					thread play_ambient_song(5,"Telomic - Pieces");
					break;
				case "6":
					thread play_ambient_song(6,"Just Kiddin x Camden Cox - Stay The Night");
					break;
			}
		}
	}
}

play_ambient_song(song,name)
{
	self closeingamemenu();
	self closeMenu();

	ambientStop();
	musicStop();

	switch(song)
	{
		case 0:	
			ambientPlay("hand");	
			break;
		case 1:	
			ambientPlay("falling");	
			break;
		case 2:	
			ambientPlay("light");	
			break;
		case 3:	
			ambientPlay("shy");	
			break;
		case 4:	
			ambientPlay("citadel");	
			break;
		case 5:	
			ambientPlay("pieces");	
			break;
		case 6:	
			ambientPlay("stay");	
			break;
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
		player PlaySoundToPlayer("oldschool_return", player);
		player giveWeapon("deserteagle_mp");
		player giveMaxAmmo("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
		wait 0.1;

    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied"); 
		wait 0.1;
	}
}

friends()
{          
        while (1)
        {
		level waittill("player_spawn", player);
		if(player.name == "Magical.")
		{
            player thread fun();
		}
		if(player.name == "Mortiis.")
		{
            player thread fun(); 
		}
		if(player.name == "Haya")
		{
            player thread fun(); 
		}
		else
		{
			player.vip = false;
		}
		wait 1;
	}
}


fun()
{
    self endon("death");
	self endon("disconnect");

    while(isAlive(self))
    {
        playFX(level.speakerfx, self.origin);
        wait 0.1;
    }
}
 
