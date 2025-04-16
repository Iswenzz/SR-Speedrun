main()
{
	maps\mp\_load::main();	
	
	VisionSetNaked("mp_killhouse");

	ambientPlay("ambient1");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-1699, -2466,380), 90);
	thread sr\api\_speedrun::createEndMap((20706.6, -1884.48, 448.125),95,120, "normal_0");

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
    setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998"); 

    precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("knife_mp");
	precacheItem("deserteagle_mp");
	preCacheItem("ak74u_mp"); 
	preCacheItem("barrett_mp");
	preCacheItem("rpd_mp");
	preCacheItem("ak47_mp");
	precacheItem("artillery_mp"); 
	precacheShellShock("jeepride_ridedeath");
	preCacheShader("hudicon_american"); 
	preCacheHeadIcon("hudicon_american"); 

    thread startdoor(); 
	thread sr_tp();
	thread sr_sec_enter();
    //thread distant_planets();
    //thread precacheFX();
	//thread clipboard();
	//thread ambientsounds();
	//thread trap_1();
	//thread trap_2();
	//thread trap_3();
	//thread trap_4();
	thread trap_5();
	thread trap_6();
	thread trap_7();
	//thread trap_8();
	//thread rocks();
	thread jumper_tp();
	thread jumper_tp2();
	//thread acti_tp();
	//thread music();
	//thread platform();
	//thread sec_open();
	//thread sec_enter();
	thread sec_fail1();
	thread sec_fail2();
	thread sec_fail3();
	thread sec_done();
	//thread slide_enter();
	//thread slide_done();
	//thread ele_sec();
	//thread vistic_intel_1();
	//thread vistic_intel_2();
	//thread vistic_intel_3();
	//thread vistic_intel_4();
	//thread vistic_intel_5();
	//thread sniper_room_respawn();
	//thread bounce_room_weapon();
	//thread bounce_room_sec();
	//thread bounce_room_fail();
	//thread bounce_room_ak();
	//thread sniper_room();
	//thread ak_room();
	//thread bounce_room();
	//thread vistic_door();
	//thread onSpawn();
	//thread lol0x2();

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

sr_tp()
{
	trig = getEnt("ele","targetname");

	ori = spawn("script_origin",(20715,-2846,508));
	ori.angles = (0,270,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(-1848.66, -2465.61, 320.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("sec_here","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

precacheFX()
{
	level.teleport = loadfx("misc/ui_pickup_unavailable"); 	playLoopedFX(level.teleport, 1, (-1952, 3008, 466)); 
	level.teleport2 = loadfx("misc/ui_pickup_available"); 	playLoopedFX(level.teleport2, 1, (17952, -4928, 452));
	level.teleport3 = loadfx("misc/ui_pickup_unavailable"); playLoopedFX(level.teleport3, 1, (18816, -256, 460));
	level.teleport4 = loadfx("misc/ui_pickup_unavailable"); playLoopedFX(level.teleport4, 1, (-10272, 23680, 932));  
	level.teleport5 = loadfx("misc/ui_pickup_available"); 	playLoopedFX(level.teleport5, 1, (43648, -256, 6));
	level.barrel = loadfx("explosions/small_vehicle_explosion"); 
	level.rocket = loadfx("explosions/aa_explosion"); 
}


music()
{
    
    music = randomInt(7);

    switch(music)
    {
    
        case 0:
            ambientStop(1);
			ambientPlay("ambient1");
        break;
             
        case 1:
            ambientStop(1);
			ambientPlay("ambient2");
        break;  

	 	case 2:
            ambientStop(1);
			ambientPlay("ambient3");
        break;  

		case 3:
            ambientStop(1);
			ambientPlay("ambient4");
        break;  

		case 4:
            ambientStop(1);
			ambientPlay("ambient5");
        break;     

		case 5:
            ambientStop(1);
			ambientPlay("ambient6");
        break; 

		case 6:
            ambientStop(1);
			ambientPlay("ambient7");
        break;       

    }
}

startdoor()
{
	door = getEnt("startdoor","targetname");

	door delete();
}

distant_planets()
{
	planet1 = getEnt("planet1", "targetname");
    planet2 = getEnt("planet2", "targetname");
    planet3 = getEnt("planet3", "targetname");
	planet4 = getEnt("planet4", "targetname");
	planet5 = getEnt("planet5", "targetname");
	
	for(;;)
	{
        planet1 rotateYaw(360,120);
        planet2 rotateYaw(-360,120);
        planet3 rotateYaw(360,120);
		planet4 rotateYaw(360,120);
		planet5 rotateYaw(360,120);
        wait 0.1;
    }
}

sec_open()
{
	trig = getEnt("trig_sec_open","targetname");
	brush = getEnt("sec_plat","targetname");

	brush hide();
	brush notSolid();

	trig waittill("trigger",player);

	iPrintLn("^7[^1Secret Open^7]");

	trig delete();
	brush show();
	brush solid();

}

vistic_hud(messages)
{
	vistic = newClientHudElem(self);
	vistic.alignX = "center";
	vistic.alignY = "middle";
	vistic.horzalign = "center"; 
	vistic.vertalign = "middle";
	vistic.alpha = 1;
	vistic.x = 0;
	vistic.y = 0;
	vistic.font = "default";
	vistic.fontscale = 2;
	vistic.glowalpha = 1;
	vistic.glowcolor = (1,0,0);
	vistic setText(messages);
	vistic SetPulseFX(100, 4000, 500);
	wait 8;
	if(isdefined(vistic))
	vistic destroy();
}


vistic_intel_1()
{
	intel = getEnt("toolbox","targetname");
	trig = getEnt("trig_toolbox","targetname");

	trig setHintString("Press ^3[&&1] ^7To Collect ToolBox");

	trig waittill("trigger", player);

	player thread vistic_hud("^7Engineer's Toolbox Retrieved");

	player braxi\_rank::giveRankXP("", 250);

	player PlaySoundToPlayer("intelligence_pickup", player);
	iPrintLn("^3"+ player.name + " ^7Has Secured The Engineer's ToolBox");

	intel delete();
	trig delete();
}

vistic_intel_2()
{
	intel = getEnt("map","targetname");
	trig = getEnt("trig_map","targetname");

	trig setHintString("Press ^3[&&1] ^7To Collect Vistic Map");

	trig waittill("trigger", player);

	player thread vistic_hud("^7Vistic Map Retrieved");

	player braxi\_rank::giveRankXP("", 250);

	player PlaySoundToPlayer("intelligence_pickup", player);
	iPrintLn("^3"+ player.name + " ^7Has Secured The Vistic Map");

	intel delete();
	trig delete();
}

vistic_intel_3()
{
	intel = getEnt("helmet","targetname");
	trig = getEnt("trig_helmet","targetname");

	trig setHintString("Press ^3[&&1] ^7To Collect Astronaut Helmet");

	trig waittill("trigger", player);

	player thread vistic_hud("^7Astronaut Helmet Retrieved");

	player braxi\_rank::giveRankXP("", 250);

	player PlaySoundToPlayer("intelligence_pickup", player);
	iPrintLn("^3"+ player.name + " ^7Has Secured The Astronaut Helmet");

	intel delete();
	trig delete();
}

vistic_intel_4()
{
	intel = getEnt("laptop","targetname");
	trig = getEnt("trig_laptop","targetname");
	brush = getEnt("brush_laptop","targetname");
	here = getEnt("here3","targetname");

	brush hide();
	brush notSolid();

	trig setHintString("Press ^3[&&1] ^7To Collect Alien Intelligence Laptop");

	trig waittill("trigger", player);

	brush show();
	brush solid();
	intel delete();
	trig delete();

	player thread vistic_hud("^7Alien Intelligence Laptop Retrieved");

	player braxi\_rank::giveRankXP("", 250);

	player PlaySoundToPlayer("intelligence_pickup", player);
	iPrintLn("^3"+ player.name + " ^7Has Secured The Alien Intelligence Laptop");

	wait 5;
	player freezeControls(1);
	player setClientDvar("r_blur", 6.0);
	player shellShock("jeepride_ridedeath", 3); 
	wait 1;
	player setOrigin(here.origin);
	player setPlayerAngles(here.angles);
	player setClientDvar("r_blur", 0);
	wait 0.2;
	player freezeControls(0);
	wait 0.1;
}

vistic_intel_5()
{
	intel = getEnt("dna","targetname");
	trig = getEnt("trig_dna","targetname");

	trig setHintString("Press ^3[&&1] ^7To Collect Alien DNA Sample");

	trig waittill("trigger", player);

	player thread vistic_hud("^7Alien DNA Sample Retrieved");

	player braxi\_rank::giveRankXP("", 250);

	player PlaySoundToPlayer("intelligence_pickup", player);
	iPrintLn("^3"+ player.name + " ^7Has Secured The Alien DNA Sample");

	intel delete();
	trig delete();
}




sec_enter()
{
	trig = getEnt("trig_sec","targetname");
	here = getEnt("sec_here","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread secret_timer();
		player freezeControls(1);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		wait 0.2;
		player freezeControls(0);
		wait 0.1;
	}
}

sec_fail1()
{
	trig = getEnt("sec_fail1","targetname");
	here = getEnt("sec_here","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

sec_fail2()
{
	trig = getEnt("sec_fail2","targetname");
	here = getEnt("sec_r1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

sec_fail3()
{
	trig = getEnt("sec_fail3","targetname");
	here = getEnt("sec_r2","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();
	}
}

sec_done()
{
	trig = getEnt("sec_done","targetname");
	here = getEnt("here1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

slide_enter()
{
	trig = getEnt("trig_slide_enter","targetname");
	here = getEnt("slide_here","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player freezeControls(1);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		wait 0.2;
		player freezeControls(0);
		wait 0.1;
	}
}

slide_done()
{
	trig = getEnt("slide_done","targetname");
	here = getEnt("here1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player notify("secret_done");
		player.secretTimer destroy();
		player braxi\_rank::giveRankXp(undefined, 1000);
		iPrintLnBold("^3"+ player.name+ " ^7Completed The ^1Slide ^7Secret^7!");
		player freezeControls(1);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		wait 0.2;
		player freezeControls(0);
		wait 0.1;
	}
}


clipboard()
{
	clipboard = getEnt("clipboard", "targetname");
	trig = getEnt("trig_clipboard", "targetname"); 

	trig setHintString("Press ^7[^1&&1^7] ^7For Item List");
	
	trig waittill("trigger", player);

	player playSoundToPlayer("clipboard", player);
	player giveWeapon("artillery_mp");
	player switchToWeapon("artillery_mp");

    clipboard delete();
    trig delete();
}

ambientsounds()
{   
    icbm1 = getEnt("icbm1","targetname");
	icbm2 = getEnt("icbm2","targetname");
	icbm3 = getEnt("icbm3","targetname");
	rock1 = getEnt("rock1","targetname");
	rock2 = getEnt("rock2","targetname");
	rock3 = getEnt("rock3","targetname");
	g3 = getEnt("g3","targetname");

	icbm1 playLoopSound("icmb");
	icbm2 playLoopSound("icmb");
	icbm3 playLoopSound("icmb1");
	rock1 playLoopSound("geiger_counter1");
	rock2 playLoopSound("geiger_counter2");
	rock3 playLoopSound("geiger_counter2");
	g3 playLoopSound("geiger_counter3");
}

vistic_door()
{
    trig = getEnt("trig_door", "targetname");
    brush = getEnt("vc_door","targetname");
	brush2 = getEnt("vc_door2","targetname");

	vc_door = 1;

	trig setHintString("Press ^7[^1&&1^7] ^7To Open");

	while(isdefined(vc_door))
	{
    	trig waittill("trigger",player);
		if(player getStat(767)==1)
		{
			player iprintlnBold("^1Authorized ^7Vistic Member!");
			trig delete();
			brush2 delete();
			brush playSound("door1");
			brush moveZ(-120, 4);
			brush waittill("movedone");
			brush delete();
			vc_door = undefined;
			trig delete();
			wait 0.1;
		}
		if(player getStat(767)==0)
			player iprintlnbold("^1Access Denied");
			wait 0.1;
	}
}

trap_1()
{
    trig = getEnt("trig_trap1", "targetname");
    brush = getEnt("trap1","targetname");
    	
	trig setHintString("Press ^7[^1&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 25);
	
	trig delete();

	brush MoveZ(-250, 0.5);
	brush waittill("movedone");
	wait 2;
	brush MoveZ(250, 2);
}

trap_2()
{
    trig = getEnt("trig_trap2", "targetname");
    brush = getEnt("trap2","targetname");
    	
	trig setHintString("Press ^7[^1&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);

	trig delete();
	
	player braxi\_rank::giveRankXP( "", 25);

	rotation = randomInt(2);

	switch(rotation)
	{
		case 0:
		for(;;)
		{
			brush rotateYaw(-360, 2);
			wait 0.1;
		}
		break;

		case 1:
		for(;;)
		{
			brush rotateYaw(360, 2);
			wait 0.1;
		}
	}
}

trap_3()
{
    trig = getEnt("trig_trap3", "targetname");
    brush = getEnt("trap3","targetname");

    	
	trig setHintString("Press ^7[^1&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 25);
	
	trig delete();
	brush delete();
}

trap_4()
{
    trig = getEnt("trig_trap4", "targetname");
    brush1 = getEnt("trap4a","targetname");
	brush2 = getEnt("trap4b","targetname");

    	
	trig setHintString("Press ^7[^1&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 25);
	
	trig delete();
	for(;;)
	{
		brush1 rotatePitch(-75, 0.2);
		brush2 rotatePitch(75, 0.2);
		wait 4;
		brush1 rotatePitch(75, 2);
		brush2 rotatePitch(-75, 2);
		wait 5;
	}

}

trap_5()
{
    trig = getEnt("trig_trap5", "targetname");
    barrel1 = getEnt("trap5a","targetname");
	barrel2 = getEnt("trap5b","targetname");
	barrel3 = getEnt("trap5c","targetname");
	kill = getEnt("trap5_kill","targetname");

	kill delete();
	barrel1 delete();
	barrel2 delete();
	barrel3 delete();
	
}

trap_6()
{
    trig = getEnt("trig_trap6", "targetname");
    rocket = getEnt("trap6","targetname");
	kill = getEnt("trap6_kill","targetname");

	kill delete();
	rocket delete();
	
}

trap_7()
{
    trig = getEnt("trig_trap7", "targetname");
    rocket1 = getEnt("trap7a","targetname");
	rocket2 = getEnt("trap7b","targetname");
	kill = getEnt("trap7_kill","targetname");

	kill delete();
	rocket1 delete();
	rocket2 delete();
	
}

trap_8()
{
    trig = getEnt("trig_trap8", "targetname");
    brush = getEnt("trap8","targetname");

	trig setHintString("Press ^7[^1&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 25);
	
	trig delete();
	brush moveZ(-192, 0.2);
	brush waittill("movedone");
	wait 2;
	brush moveZ(192, 2);
	brush waittill("movedone");
	brush delete();
}

platform()
{
	elev = getent("ele", "targetname");
	
	for(;;)
	{
		elev moveY (-768, 2);
		elev waittill("movedone");
		wait 2;
		elev moveY (768, 2); 
		elev waittill("movedone");
		wait 2;
	}	
}


rocks()
{
	rock1 = getEnt("rock1","targetname");
	rock2 = getEnt("rock2","targetname");
	rock3 = getEnt("rock3","targetname");
	rock4 = getEnt("rock4","targetname");

    while(1)
    {
        rock1 MoveZ(10, 4); 
		rock2 MoveZ(-20, 4); 
		rock3 MoveZ(15, 4); 
		rock4 MoveZ(-10, 4); 
        wait 4;
        rock1 MoveZ(-10, 4); 
		rock2 MoveZ(20, 4); 
		rock3 MoveZ(-15, 4); 
		rock4 MoveZ(10, 4); 
		wait 4;
    }
}

jumper_tp()
{
	trig = getEnt("trig_tp","targetname");
	here = getEnt("here1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

jumper_tp2()
{
	trig = getEnt("trig_tp2","targetname");
	here = getEnt("here3","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sniper_room_respawn()
{
	trig = getEnt("trig_s_fail","targetname");
	here = getEnt("s_fail","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player freezeControls(1);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		wait 0.2;
		player freezeControls(0);
		wait 0.1;
	}
}

acti_tp()
{
	trig = getEnt("trig_acti_tp","targetname");
	here = getEnt("here2","targetname");

	trig setHintString("Press ^7[^1&&1^7] ^7To Teleport");
	trig waittill("trigger",player);
	trig delete();
	player freezeControls(1);
	player setOrigin(here.origin);
	player setPlayerAngles(here.angles);
	wait 0.2;
	player freezeControls(0);
	wait 0.1;
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

	time = 70; 
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

ele_sec()
{
	trig = getEnt("trig_ele", "targetname");
	tele1 = getEnt("slide_here", "targetname"); 

	while(1)
		{
			trig waittill("trigger", player);
			if (!isDefined(player.slide))
		{
			player.slide = true;
			iPrintLnBold("^3"+ player.name + " ^7Completed The ^1Elevator^7!");
			player braxi\_rank::giveRankXP("", 333);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);	
		}

		else
		{
			player freezeControls(1);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.2;
			player freezeControls(0);
			wait 0.01;
		}
		}
}

bounce_room_fail()
{
	trig = getEnt("trig_b_f","targetname");
	acti_f = getEnt("b2","targetname");
	jumper_f = getEnt("b1","targetname");

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

bounce_room_weapon()
{
	trig = getEnt("trig_b_wep","targetname");

	trig setHintString("Press [^5&&1^7] For R700");

	while(1)
	{
		trig waittill("trigger",player);
		player takeAllWeapons();
		player giveWeapon("remington700_mp");
		player switchToWeapon("remington700_mp");
		player giveMaxAmmo("remington700_mp");
		wait 0.1;
	}
}

bounce_room_sec()
{
	trig = getEnt("trig_b_sec","targetname");
	here = getEnt("b3","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player freezeControls(1);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		wait 0.2;
		player freezeControls(0);
		wait 0.1;
	}
}


bounce_room_ak()
{
	trig = getEnt("trig_b_ak","targetname");
	here = getEnt("b3","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player giveWeapon("ak47_mp");
		player giveMaxAmmo("ak47_mp");
		player switchToWeapon("ak47_mp");
		player freezeControls(1);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
		wait 0.2;
		player freezeControls(0);
		wait 0.1;
	}
}



endroom_hud(messages)
{
	endroom = newHudElem();
	endroom.alignX = "center";
	endroom.alignY = "middle";
	endroom.horzalign = "center"; 
	endroom.vertalign = "-150";
	endroom.alpha = 1;
	endroom.x = 0;
	endroom.y = 0;
	endroom.font = "default";
	endroom.fontscale = 1.6;
	endroom.glowalpha = 1;
	endroom.glowcolor = (1,0.3,0);
	endroom setText(messages);
	endroom SetPulseFX(100, 4000, 500);
	wait 7;
	if(isdefined(endroom))
	endroom destroy();
}

sniper_room()
{
	level.snip = getEnt("trig_snip", "targetname");
	acti = getEnt("s1", "targetname");
	jumper = getEnt("s2", "targetname");
	
	while(1)
	{
		level.snip SetHintstring("^1Sniper ^7Room");
		level.snip waittill("trigger", player);

	

		level.snip SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.snip))
		return;

		level.ak delete();
		level.bounce delete();

		player SetPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		player TakeAllWeapons();
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player giveMaxAmmo("m40a3_mp");
		player switchToWeapon("m40a3_mp");

		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon("remington700_mp");
		level.activ GiveMaxAmmo("remington700_mp");
		level.activ GiveWeapon("m40a3_mp");
		level.activ GiveMaxAmmo("m40a3_mp");
		level.activ SwitchToWeapon("m40a3_mp");

		player freezeControls(1);
		level.activ freezeControls(1);
		
  		player thread vistic_hud("^3"+player.name+" ^7Entered The Sniper Room");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^12");
		level.activ iPrintLnBold("^12");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^1FIGHT");
		level.activ iPrintLnBold("^1FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing")
		wait 1;
		player = undefined;
	}
}


ak_room()
{
	level.ak = getEnt("trig_ak", "targetname");
	acti = getEnt("s1", "targetname");
	jumper = getEnt("s2", "targetname");
	
	while(1)
	{
		level.ak SetHintstring("^1AK47 ^7Room");
		level.ak waittill("trigger", player);

	

		level.ak SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.ak))
		return;

		level.snip delete();
		level.bounce delete();

		player SetPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		player TakeAllWeapons();
		player GiveWeapon("ak47_mp");
		player GiveMaxAmmo("ak47_mp");
		player switchToWeapon("ak47_mp");

		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon("ak47_mp");
		level.activ GiveMaxAmmo("ak47_mp");
		level.activ switchToWeapon("ak47_mp");

		player freezeControls(1);
		level.activ freezeControls(1);
		
  		player thread vistic_hud("^3"+player.name+" ^7Entered The AK47 Room");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^12");
		level.activ iPrintLnBold("^12");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^1FIGHT");
		level.activ iPrintLnBold("^1FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing")
		wait 1;
		player = undefined;
	}
}


bounce_room()
{
	level.bounce = getEnt("trig_bounce", "targetname");
	acti = getEnt("b2", "targetname");
	jumper = getEnt("b1", "targetname");
	
	while(1)
	{
		level.bounce SetHintstring("^1Bounce ^7Room");
		level.bounce waittill("trigger", player);

	
		
		level.bounce SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.bounce))
		return;

		level.snip delete();
		level.ak delete();

		player SetPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		player TakeAllWeapons();
		player GiveWeapon("knife_mp");
		player switchToWeapon("knife_mp");

		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		player freezeControls(1);
		level.activ freezeControls(1);
		
  		player thread vistic_hud("^3"+player.name+" ^7Entered The Bounce Room");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^12");
		level.activ iPrintLnBold("^12");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^1FIGHT");
		level.activ iPrintLnBold("^1FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing")
		wait 1;
		player = undefined;
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
        self setClientDvar("r_drawDecals",1);
		wait 1;
	}
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
