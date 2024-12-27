main()
{
	maps\mp\_load::main();
	
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-3408, 4584, 380), 270);
	
	//Dvars
	setdvar( "r_specularcolorscale", "1" );
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
	
	//Effects
	//level._effect["explosion"] = loadFx("explosions/tanker_explosion");

	if(!isdefined(level.chosen))
		level.chosen=false;
	
	//Precaches
	precacheItem ( "ak47_acog_mp" );
	precacheItem ( "winchester1200_mp" );
	precacheItem ( "uzi_mp" );
	precacheItem ( "mp5_mp" );
	precacheItem ( "barrett_mp" );
	precacheShellShock ( "frag_grenade_mp" );
	
	addTriggerToList( "trap_1_trigger" );
	addTriggerToList( "trap_2_trigger" );
	addTriggerToList( "trap_3_trigger" );
	addTriggerToList( "trap_4_trigger" );
	addTriggerToList( "trap_5_trigger" );
	addTriggerToList( "trap_6_trigger" );
	addTriggerToList( "trap_7_trigger" );
	addTriggerToList( "trap_8_trigger" );
	addTriggerToList( "trap_9_trigger" );
	
	thread startdoor();
	thread sr_anti_glitch();
	thread sr_tp();
	thread sr_sec_enter();
	//thread rolltreppe();
	//thread secret_enter();
	thread initiateFailtrigger();
	thread s_end();
	
	//thread trap_1();
	//thread trap_2();
	//thread trap_3();
	//thread trap_4();
	//thread trap_5();
	thread trap_6();
	//thread trap_7();
	//thread trap_8();
	//thread trap_9();

	//thread knife();
	//thread sniper();
	//thread jump();
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

startdoor()
{
	target = getEnt ( "startdoor", "targetname" );

	target delete();
}

sr_anti_glitch()
{
	trig = spawn("trigger_radius",(-424.333, -728.87, 1024.13), 0, 1770, 200);
	trig.radius = 1770;

	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}

sr_tp()
{
	trig = spawn("trigger_radius",(-1912.46, 2488.01, -799.875), 0, 85, 100);
	trig.radius = 85;

	ori = spawn("script_origin",(-1282,2485,-452));
	ori.angles = (0,360,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(-3270.43, 4583.99, 320.125), 0, 60, 100);
	trig.radius = 60;

	ori = spawn("script_origin",(-1416,504,888));
	ori.angles = (0,270,0);

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
rolltreppe()
{
	steps = getEntArray( "rt_1", "targetname" );
	
	for ( i = 0; i < steps.size; i++ )
		steps[i] thread step();
		wait 0.5;
}

step()
{
	while(1)
	{
		self moveTo((-1830+20, 2488, -830), 2);
		wait 2;
		self moveTo((-1830+20+450, 2488, -830+275), 3.5);
		wait 3.5;
		self moveTo((-1830+20+450+120, 2488, -830+275), 2);
		wait 2;
		//self.origin = (-1830, 2488, -810);
		self.origin = (-1950, 2488, -830);
	}
}

countdown()
{
	cd = NewHudElem();
	cd.alignX = "center";
	cd.alignY = "middle";
	cd.horzalign = "center";
	cd.vertalign = "middle";
	cd.alpha = 1;
	cd.font = "objective";
	cd.fontscale = 4;
	cd.glowalpha = 1;
	cd.glowcolor = ( 0, 1, 1 );
	cd.x = 0;
	cd.y = -250;
	cd setText( "-3-" );
	cd SetPulseFX( 100, 4000, 500 );
	cd movetext( 1.6, 0, 250 );
	wait 0.7;
	cd.glowcolor = ( 1, 1, 1 );
	wait 0.2;
	cd.glowcolor = ( 0, 1, 1 );
	wait 0.7;
	cd.x = 0;
	cd.y = -250;
	cd setText( "-2-" );
	cd SetPulseFX( 100, 4000, 500 );
	cd movetext( 1.6, 0, 250 );
	wait 0.7;
	cd.glowcolor = ( 1, 1, 1 );
	wait 0.2;
	cd.glowcolor = ( 0, 1, 1 );
	wait 0.7;
	cd.x = 0;
	cd.y = -200;
	cd setText( "-1-" );
	cd SetPulseFX( 100, 4000, 500 );
	cd movetext( 1.6, 0, 250 );
	wait 0.7;
	cd.glowcolor = ( 1, 1, 1 );
	wait 0.2;
	cd.glowcolor = ( 0, 1, 1 );
	wait 0.7;
	cd destroy();

	iprintlnbold("Map created by ^1VC' Warhero");

	ambientstop();
	musicstop();

	ambientplay("night1");
}

movetext(time,x,y)
{
	self moveOverTime(time);
	if(isDefined(x))
		self.x = x;
		
	if(isDefined(y))
		self.y = y;
}

trap_1()
{
	trigger = getEnt( "trap_1_trigger", "targetname" );
	target_1 = getEnt ( "trap_1_target_1", "targetname" );
	target_2 = getEnt ( "trap_1_target_2", "targetname" );
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 1" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );
	
	while(1)
	{
		target_1 rotatePitch ( -360, 6 );
		target_2 rotatePitch ( 360, 6 );
		wait 6;
	}
}

trap_2()
{
	trigger = getEnt( "trap_2_trigger", "targetname" );
	target = getEnt ( "trap_2_target", "targetname" );
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 2" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );

	target delete();
}

trap_3()
{
	trigger = getEnt( "trap_3_trigger", "targetname" );
	target = getEnt ( "trap_3_target", "targetname" );
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 3" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );

	target moveY ( 304, 3, 2, 1 );
	wait 8;
	target notSolid();
	wait 1;
	target hide();
}

trap_4()
{
	trigger = getEnt( "trap_4_trigger", "targetname" );
	target_1 = getEnt ( "trap_4_target_1", "targetname" );
	target_2 = getEnt ( "trap_4_target_2", "targetname" );
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 4" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );
	
	thread trap_4_3();
	thread trap_4_random();
	
	while(1)
	{
		target_1 rotateYaw ( 360, 3 );
		target_2 rotateYaw ( -420, 3 );
		wait 3;
	}
}

trap_4_3()
{
	target = getEnt ( "trap_4_target_3", "targetname" );
	
	level.warisgay = true;
	
	while(level.warisgay)
	{
		target rotatePitch ( 360, 4 );
		wait 4;
	}
}

trap_4_random()
{
	i = randomintrange( 0, 4 );
	if(i == 0)
	{
		wait 5;
		level.warisgay = false;
	}
	else if(i == 1)
	{
		wait 8;
		level.warisgay = false;
	}
	else if(i == 2)
	{
		wait 10;
		level.warisgay = false;
	}
	else if(i == 3)
	{
		wait 12;
		level.warisgay = false;
	}
}

trap_5()
{
	trigger = getEnt( "trap_5_trigger", "targetname" );
	target_1 = getEnt ( "trap_5_target_1", "targetname" );
	target_2 = getEnt ( "trap_5_target_2", "targetname" );
	target_3 = getEnt ( "trap_5_target_3", "targetname" );
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 5" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );
	
	while(1)
	{
		target_1 moveZ ( -64, 3 );
		target_2 moveZ ( -84, 3 );
		target_3 moveZ ( 56, 3 );
		wait 3;
		target_1 moveZ ( 64, 3 );
		target_2 moveZ ( 84, 3 );
		target_3 moveZ ( -56, 3 );
		wait 3;
	}
}

trap_6()
{
	trigger = getEnt( "trap_6_trigger", "targetname" );
	target = getEnt ( "trap_6_spikes", "targetname" );
	hurt = getEnt ( "trap_6_hurt", "targetname" );
	
	hurt delete();
	target delete();
}

trap_7()
{
	trigger = getEnt( "trap_7_trigger", "targetname" );
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 7" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );
	player iprintlnbold("Trap is broken, sorry");
}


trap_8()
{
	trigger = getEnt( "trap_8_trigger", "targetname" );
	target_1 = getEnt ( "trap_8_target_1", "targetname" );
	target_2 = getEnt ( "trap_8_target_2", "targetname" );
	
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 7" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );
	
	target_1 moveZ ( 48, 3);
	target_2 moveZ ( -48, 3);
	wait 3;
	
	while(1)
	{
		target_1 moveZ ( -96, 6);
		target_2 moveZ ( 96, 6);
		wait 6;
		target_1 moveZ ( 96, 6);
		target_2 moveZ ( -96, 6);
		wait 6;
	}
}

trap_9()
{
	trigger = getEnt( "trap_9_trigger", "targetname" );
	target = getEnt ( "trap_9_target", "targetname" );	
	
	trigger setHintstring ( "Press ^3use ^7to activate ^3trap 7" );
	
	trigger waittill ( "trigger", player );
	trigger setHintstring ( "^1Activated" );
	
	player playsound( "mp_enemy_obj_captured" );
	
	target moveZ ( 80, 2);
	wait 10;
	target moveZ ( -80, 2);
	wait 2;
}

knife()
{
	level.knife = getEnt("knife_room","targetname");
	acti = getEnt("knife_acti","targetname");
	jump = getEnt("knife_jump","targetname");
	level.knife sethintstring("^1Enter The ^7Knife Room^1!");

	while(1)
	{
		level.knife waittill("trigger",player);
		if(!isDefined(level.knife))
			return;

	

		if(!level.chosen)
		{
			level.chosen=true;
			level.sniper delete();
			level.jump delete();
		}

		if(isDefined(level.activ))
		{
	        player roompreset("knife_mp",jump,1);
	        level.activ roompreset("knife_mp",acti,1);
	        wait 5;
			player FreezeControls(0);
			level.activ FreezeControls(0);
		}
		else
		{
			player roompreset("knife_mp",jump,1);
	        wait 5;
			player FreezeControls(0);
		}

        while(isAlive(player)&&isDefined(player))
            wait 1;
        iPrintlnBold( player.name+" ^1has been killed" );
	}
}

jump()
{
	level.jump = getEnt("jump_room","targetname");
	acti = getEnt("bounce_acti","targetname");
	jump = getEnt("bounce_jump","targetname");
	level.jump sethintstring("^1Enter The ^7Jump Room^1!");

	while(1)
	{
		level.jump waittill("trigger",player);
		if(!isDefined(level.jump))
			return;

		

		level.jump_p=player;

		if(!level.chosen)
		{
			level.chosen=true;
			level.sniper delete();
			level.knife delete();
			thread jump_fail();
			thread jump_win();
		}

		if(isDefined(level.activ))
		{
	        player roompreset("knife_mp",jump,1);
	        level.activ roompreset("knife_mp",acti,1);
	        wait 5;
			player FreezeControls(0);
			level.activ FreezeControls(0);
		}
		else
		{
			player roompreset("knife_mp",jump,1);
	        wait 5;
			player FreezeControls(0);
		}

        while(isAlive(player)&&isDefined(player))
            wait 1;
        iPrintlnBold(player.name+" ^1has been killed" );
        level.jump_p=undefined;
	}
}

sniper()
{
	level.sniper = getEnt("sniper_room","targetname");
	acti = getEnt("sniper_acti","targetname");
	jump = getEnt("sniper_jump","targetname");
	level.sniper sethintstring("^1Enter The ^7Sniper Room^1!");

	while(1)
	{
		level.sniper waittill("trigger",player);
		if(!isDefined(level.sniper))
			return;

	

		if(!level.chosen)
		{
			level.chosen=true;
			level.jump delete();
			level.knife delete();
			thread sniper_brushes();
		}

		if(isDefined(level.activ))
		{
	        player roompreset("m40a3_mp",jump,1);
	        level.activ roompreset("m40a3_mp",acti,1);
	        wait 5;
			player FreezeControls(0);
			level.activ FreezeControls(0);
		}
		else
		{
			player roompreset("m40a3_mp",jump,1);
	        wait 5;
			player FreezeControls(0);
		}

        while(isAlive(player)&&isDefined(player))
            wait 1;
        iPrintlnBold( player.name+" ^1has been killed" );
	}
}

sniper_brushes()
{
	brush1=getent("sniper_brush1","targetname");
	brush2=getent("sniper_brush2","targetname");

	brush1 notsolid();
	brush2 notsolid();

	while(1)
	{
		brush1 movez(200,2);
		brush2 movez(-200,2);
		wait 2;
		brush1 movez(-200,2);
		brush2 movez(200,2);
		wait 2;
	}
}

jump_fail()
{
	trig=getEnt("bounce_fail","targetname");
	acti=getEnt("bounce_acti","targetname");
	jump=getEnt("bounce_jump","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		if(player.pers["team"]!="spectator")
		{
			if(player.pers["team"]=="allies")
			{
				player SetPlayerAngles(jump.angles);
				player SetOrigin(jump.origin);
			}
			else
			{
				player SetPlayerAngles(acti.angles);
				player SetOrigin(acti.origin);
			}
		}
	}
}

jump_win()
{
	trig=getEnt("bounce_finish","targetname");
	win=getent("bounce_end_win","targetname");
	lose=getent("bounce_end_lose","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		if(player.pers["team"]!="spectator")
		{
			if(player.pers["team"]=="allies")
			{
				level.jump_p initiateWinner(win,"winner");
				level.activ initiateWinner(lose,"loser");
			}
			else
			{
				level.jump_p initiateWinner(lose,"loser");
				level.activ initiateWinner(win,"winner");
			}
		}
	}
}

initiateWinner(teleport,what)
{
	if(what=="loser")
		self freezecontrols(1);
	else 
	{
		self giveweapon("ak47_mp");
		self switchtoweapon("ak47_mp");
	}

	self setorigin(teleport.origin);
	self setplayerangles(teleport.angles);
}

roompreset(weapon,position,frozen)
{
	self takeallweapons();
	self giveweapon(weapon);
	self switchtoweapon(weapon);

	self freezecontrols(frozen);
	self setorigin(position.origin);
	self setplayerangles(position.angles);
}

secret_open()
{
	trigv=getent("secret_v","targetname");
	trigc=getent("secret_c","targetname");


	trigv waittill("trigger");
	trigv delete();
	iprintln("^1Vistic");
	trigc waittill("trigger");
	trigc delete();
	iprintln("^1Clan");

	thread secret_enter();
}

secret_enter()
{
	trigs=getent("secret_s","targetname");
	for(;;)
	{
		trigs waittill("trigger",player);
		player setorigin((-1416,504,888));
		player setplayerangles((0,270,0));
	}
}

initiateFailtrigger()
{
	thread s_fail1();
	thread s_fail2();
	thread s_fail3();
	thread s_fail4();
	thread s_fail5();
	thread s_fail6();
}

s_fail1()
{
	trig=getent("fail1_trig","targetname");
	targ=getent("fail1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

s_fail2()
{
	trig=getent("fail2_trig","targetname");
	targ=getent("fail2","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

s_fail3()
{
	trig=getent("fail3_trig","targetname");
	targ=getent("fail3","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

s_fail4()
{
	trig=getent("fail4_trig","targetname");
	targ=getent("fail4","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

s_fail5()
{
	trig=getent("fail5_trig","targetname");
	targ=getent("fail5","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

s_fail6()
{
	trig=getent("fail6_trig","targetname");
	targ=getent("fail6","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

s_end()
{
	trig=getent("secret_end","targetname");
	targ=getent("end_secret","targetname");

	for(;;)
	{
	trig waittill("trigger",player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}
}