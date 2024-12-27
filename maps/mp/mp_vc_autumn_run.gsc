main()
{
	maps\mp\_load::main();

	ambientPlay("ambient_citystreets_night");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//level.snow = loadFX("weather/snow_light_mp_bloc"); playLoopedFX(level.snow, 0.05, (-512, 2240, 448)); 
	//level.snow2 = loadFX("weather/snow_light_mp_bloc"); playLoopedFX(level.snow2, 0.05, (896, -576, 448));
	level.airstrikefx = loadfx ("explosions/clusterbomb"); 
	level.exp = loadfx ("explosions/small_vehicle_explosion"); 
	

    VisionSetNaked("mp_hill", 0);

	setDvar("r_drawDecals","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".5");
	setDvar("compassmaxrange","1800");
 	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-469, 512, 68), 90);
	
	precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("knife_mp");
	precacheItem("deserteagle_mp");
	preCacheItem("deserteaglegold_mp");
	precacheItem("ak47_mp");
	preCacheItem("saw_mp");
	preCacheItem("ak74u_mp");

	thread startdoor();
	thread sr_hard_sec_enter();
	thread sr_easy_sec_enter();
	//thread end_door();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	thread trap7();
	//thread trap8();
	//thread trap9();
	//thread vistic_vip();
	//thread messages();
	//thread ambient_sounds();
	//thread sec_step1();
	thread sec_fail_1();
	thread sec_fail_2();
	thread sec_fail_3();
	thread sec_fail_4();
	thread sec_leave();
	//thread onConnect();
	//thread acti_door();
	//thread vip_music();
	//thread ammo_refill();
	//thread first_place();
	//thread sec2();
	//thread sec2_part2();
	thread sec_2_fail();
	thread sec_2_leave();
	//thread sniper_room();
	//thread weapon_room();
	//thread knife_room();
	//thread deagle_room();
	//thread lol0x2();

	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
	addTriggerToList("trig_acti_door");

}

addTriggerToList( name ) 
{
    if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(-299.367, 507.471, 8.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("sec_enter","targetname");

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

sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(-628.181, 512.086, 8.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("sec2here","targetname");

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
sr_tp_safe(ori)
{   
	self endon("death");
	self endon("disconnect");
	
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
startdoor()
{
	door = getEnt("startdoor","targetname");
	
	door delete();
	
}


ambient_sounds()
{   
    elec = getEnt("elec1","targetname");
	radio = getEnt("radio","targetname");
	//water = getEnt("emt_ice","targetname");

	elec playLoopSound("elec");
	radio playLoopSound("emt_seaknight_radio");
	//water playLoopSound("emt_water_drip_bathroom");
}


messages()
{
	for(;;)
	{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^7Made For ^5Vistic-Clan"); 
	wait 30;
	iPrintLn("^7Discord: ^3VC'Fox#0001"); 
	wait 20;
	}
}

sec2()
{
	trig = getEnt("sec2_step1","targetname");

	trig waittill("trigger", player);

	player thread sec2_step2();

}

sec2_step2()
{
	trig = getEnt("sec2","targetname");
	tele1 = getEnt("here3", "targetname");

	trig waittill("trigger", player);

	player setOrigin(tele1.origin);
	player freezeControls(1);
	player setPlayerAngles(tele1.angles);
	wait 0.1;
	player freezeControls(0);
	trig delete();

}

sec2_part2()
{
	trig = getEnt("trig_sec2","targetname");
	tele1 = getEnt("sec2here", "targetname");

	trig waittill("trigger", player);

	player setOrigin(tele1.origin);
	player freezeControls(1);
	player setPlayerAngles(tele1.angles);
	player thread secret_timer();
	wait 0.1;
	player freezeControls(0);
	trig delete();
}

sec_2_fail()
{
	trig = getEnt("sec2_fail", "targetname");
	tele1 = getEnt("sec2here", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

sec_2_leave()
{
	trig = getEnt("sec2leave", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
		}
}




end_door()
{ 
		door = getEnt("end_door", "targetname"); 	
		level.old = getEnt("trig_old", "targetname"); 

		level.old setHintString("Press [^5&&1^7] To Open Door");

		level.old waittill ("trigger",player );

		level.old delete();
		level.wep delete();
		level.snip delete();
		level.knife delete();
		level.deagle delete();
		iPrintLn("^7End Door is ^5Open^7");
		noti = SpawnStruct();
		noti.notifyText = "^7End Door is ^5Open^7!";
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(noti); 
		door moveZ(-200,3);
		door waittill("movedone");
		door delete();
}

first_place()
{ 
	trig = getEnt("endmap_trig", "targetname"); 
	
	trig waittill ("trigger",player );

	
	firstPlace = newHudElem();
	firstPlace.foreground = true;
	firstPlace.alpha = 1;
	firstPlace.alignX = "left";
	firstPlace.alignY = "middle";
	firstPlace.horzAlign = "left";
	firstPlace.vertAlign = "middle";
	firstPlace.x = 5;
	firstPlace.y = 0;
	firstPlace.sort = 0;
	firstPlace.font = "default";
	firstPlace.fontScale = 1.4;
	firstplace.hidewheninmenu = false;
	firstPlace.glowAlpha = 1;
	firstPlace.glowColor = (.2,.2,1);
	firstPlace settext("^3"+ player.name+ " ^7Finished First!");
	//wait 2;
	//firstPlace moveOverTime(2);
	//firstPlace.x = -1000;
	wait 5;
	firstPlace destroy(); 
}



trap1()
{
	brush = getEnt("trap1","targetname");
	brush1 = getEnt("trap1a","targetname");
	trig = getEnt("trig_trap1","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);
	player braxi\_rank::giveRankXP( "", 25 );
	trig delete();

	x = randomInt(2);
	if(x == 0)
    {
		brush delete();
	}
	if(x == 1)
    {
		brush1 delete();
	}
}

trap2()
{
	brush = getEnt("trap2","targetname");
	trig = getEnt("trig_trap2","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);

	player braxi\_rank::giveRankXP( "", 25 );
	
	playfx(level.exp, (-480, 2680, 16)); 
	brush playSound("winter_run_exp"); 
	brush playSound("winter_run_debris");
	brush delete();
	trig delete();
}


trap3()
{
	trig = getEnt("trig_trap3", "targetname"); 

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);

	player braxi\_rank::giveRankXP( "", 25 );

	trig delete();
	
	brush1 = getEnt("trap3a", "targetname"); 
	kill_trig1 = getEnt("trap3a_kill", "targetname"); 

	brush2 = getEnt("trap3b", "targetname"); 
	kill_trig2 = getEnt("trap3b_kill", "targetname"); 

	brush3 = getEnt("trap3c", "targetname"); 
	kill_trig3 = getEnt("trap3c_kill", "targetname"); 

	brush4 = getEnt("trap3d", "targetname"); 
	kill_trig4 = getEnt("trap3d_kill", "targetname"); 
	

	kill_trig1 enableLinkTo();
	kill_trig1 linkTo(brush1);

	kill_trig2 enableLinkTo();
	kill_trig2 linkTo(brush2);

	kill_trig3 enableLinkTo();
	kill_trig3 linkTo(brush3);

	kill_trig4 enableLinkTo();
	kill_trig4 linkTo(brush4);

	brush1 moveZ(60,1);
	brush2 moveZ(60,1);
	brush3 moveZ(60,1);
	brush4 moveZ(60,1);
	wait 3;
	brush1 moveZ(-60,2);
	brush2 moveZ(-60,1);
	brush3 moveZ(-60,1);
	brush4 moveZ(-60,1);
	wait 3;
	brush1 moveZ(60,1);
	brush2 moveZ(60,1);
	brush3 moveZ(60,1);
	brush4 moveZ(60,1);
	wait 3;
	brush1 moveZ(-60,1);
	brush2 moveZ(-60,1);
	brush3 moveZ(-60,1);
	brush4 moveZ(-60,1);
}


trap4()
{
	brush = getEnt("trap4a","targetname");
	brush1 = getEnt("trap4b","targetname");
	brush2 = getEnt("trap4c","targetname");
	trig = getEnt("trig_trap4","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);
	player braxi\_rank::giveRankXP( "", 25 );
	trig delete();

	x = randomInt(3);
	if(x == 0)
    {
		brush moveZ(-250, 2);
		wait 0.2;
		brush2 moveZ(-250, 2);
		wait 4;
		brush delete();
		brush2 delete();
		
	}
	if(x == 1)
    {
		
		brush1 moveZ(-250, 2);
		wait 0.2;
		brush moveZ(-250, 2);
		wait 4;
		brush delete();
		brush1 delete();
	}
	if(x == 2)
    {
		brush1 moveZ(-250, 2);
		wait 0.2;
		brush2 moveZ(-250, 2);
		wait 4;
		brush1 delete();
		brush2 delete();
	}
}

trap5()
{
	jet1 = getEnt("jet1","targetname");
	jet2 = getEnt("jet2","targetname");
	trig = getEnt("trig_trap5","targetname");
	brush1 = getEnt("brush_trap5","targetname");
	brush2 = getEnt("brush2_trap5","targetname");
	brush3 = getEnt("brush3_trap5","targetname");
	kill_trig = getEnt("trap5kill","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	jet1 hide();
	jet2 hide();
	brush3 hide();
	brush3 notSolid();

	trig waittill("trigger",player);

	player playSoundToPlayer("opfor_airstrike",player);
	
	wait 1.2;

	kill_trig enableLinkTo();
	kill_trig linkTo(brush3);

	jet1 show();
	jet2 show();

	player braxi\_rank::giveRankXP( "", 25 );

	trig delete();

	jet1 playSound("a10_flyby");
	jet1 moveX(-8400, 2);
	wait 0.5;
	brush3 moveZ(24,0.2);
	playfx(level.airstrikefx, (320, 3432, 96));
	brush1 playSound("a10_flyby");
	brush1 playSound("a10_fire");
	thread a10();
	brush2 playSound("fast_artillery_round");
	wait 2;
	jet2 moveX(-8400, 2);
	wait 1;
	thread a10_1();
	playfx(level.airstrikefx, (320, 3432, 96));
	brush1 playSound("a10_flyby");
	brush2 playSound("fast_artillery_round");
	brush1 playSound("a10_fire2");
	wait 1;
	brush3 delete();
	kill_trig delete();
	wait 6;
	jet1 delete();
	jet2 delete();
}


a10()
{
	jet1 = getEnt("jet1","targetname");
	
	sound1 = randomInt(3);

    switch(sound1)
    {
    
        case 0:
			jet1 playSound("a10_roar1");
        break;
              
        case 1:
			jet1 playSound("a10_roar2");
        break;
                
        case 2:
			jet1 playSound("a10_roar3");
        break;
	}
}

a10_1()
{
	brush1 = getEnt("brush_trap5","targetname");
	jet1 = getEnt("jet1","targetname");
	jet2 = getEnt("jet2","targetname");
	
	sound = randomInt(3);

    switch(sound)
    {
    
        case 0:
			jet2 playSound("a10_roar1");
			jet2 playSound("a10_fire2");
        break;
              
        case 1:
			jet2 playSound("a10_roar2");
        break;
                
        case 2:
			jet2 playSound("a10_roar3");
			jet2 playSound("a10_fire2");
        break;
	}
}

trap6()
{
	brush = getEnt("trap6","targetname");
	trig = getEnt("trig_trap6","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);

	player braxi\_rank::giveRankXP( "", 25 );

	trig delete();

	for(;;)
	{
		brush rotateYaw(-720, 1.5);
		wait 4;
		brush rotateYaw(720, 1.5);
		wait 4;
	}
}

trap7()
{
	brush1 = getEnt("trap7a","targetname");
	brush2 = getEnt("trap7b","targetname");
	trig = getEnt("trig_trap7","targetname");

	brush1 delete();
	brush2 delete();

}

trap8()
{
	brush = getEnt("trap8","targetname");
	trig = getEnt("trig_trap8","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);

	player braxi\_rank::giveRankXP( "", 25 );
	
	trig delete();

	brush rotateYaw(-720, 2);
	brush moveZ(-200, 2);
	wait 4;
	brush moveZ(200, 3);
}


trap9()
{
	trig = getEnt("trig_trap9","targetname");
	brush1 = getEnt("trap9a","targetname");
	brush2 = getEnt("trap9b","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);

	player braxi\_rank::giveRankXP( "", 25 );

	trap = randomInt(2);

	switch(trap)
    {
	case 0:
		trig delete();
		brush1 delete();
	break;

	case 1:
		trig delete();
		brush2 delete();
	break;
	}
}






acti_door()
{
	while(1)
	{

    trig = getEnt("trig_acti_door","targetname");
	brush = getEnt("acti_door","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

    trig waittill("trigger",player);

    if(player getStat(767)==1)
    {
		wait 0.2;
		brush moveZ(-200, 2);
		brush playSound("winter_run_door");
		wait 3;
		brush delete();
		trig delete();
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
	}
}


vip_music()
{
	while(1)
	{

    trig = getEnt("trig_mus","targetname");

	trig setHintString("^3>> ^7Vistic Members Here ^3<<");

	trig waittill("trigger",player);

    if(player getStat(767)==1)
    {
		player thread mus();
		trig delete();
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
	}
}

mus()
{
    music = randomInt(4);

    switch(music)
    {
    
        case 0:
            ambientStop(4);
			wait 3;
			ambientPlay("ambient1");
        break;
            
        case 1:
            ambientStop(4);
			wait 3;
			ambientPlay("ambient2");
        break;
                
        case 2:
            ambientStop(4);
			wait 3;
			ambientPlay("ambient3");
        break;
		
		case 3:
			ambientStop(4);
			wait 3;
			ambientPlay("ambient4");
        break;
                    
    }
    
}



vistic_vip()
{
	while(1)
	{

    trig = getEnt("trig_vip","targetname");

	trig setHintString("^3>> ^7Vistic Members Here ^3<<");

    trig waittill("trigger",player);

    if(player getStat(767)==1)
    {
        player iprintlnBold("^1Authorized ^7Vistic Member!");
		player PlaySoundToPlayer("oldschool_return", player);
		player detachAll();
		player giveWeapon("deserteaglegold_mp");
		player giveMaxAmmo("deserteaglegold_mp");
		player switchToWeapon("deserteaglegold_mp");
		wait 0.1;
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
	}
}


sec_step1()
{
	trig = getEnt("sec_step1", "targetname");

	trig waittill("trigger",player);

	trig delete();

	player iPrintLn("^21");

	thread sec_step2();
}

sec_step2()
{
	trig = getEnt("sec_step2", "targetname");

	trig waittill("trigger",player);

	trig delete();

	player iPrintLn("^22");

	thread sec_step3();
}

sec_step3()
{
	trig = getEnt("sec_step3", "targetname");

	trig waittill("trigger",player);

	trig delete();

	player iPrintLn("^23");

	thread sec_step4();
}

sec_step4()
{
	trig = getEnt("sec_step4", "targetname");
	tele1 = getEnt("sec_enter", "targetname");

	while(1)
	{
		trig waittill("trigger", player);
		player iPrintLnBold("You Entered The Secret Way!");	
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player thread secret_timer();
		wait 0.01;
	}
}

sec_fail_1()
{
	trig = getEnt("trig_f_1", "targetname");
	tele1 = getEnt("sec_enter", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

sec_fail_2()
{
	trig = getEnt("trig_f_2", "targetname");
	tele1 = getEnt("r_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

sec_fail_3()
{
	trig = getEnt("trig_f_3", "targetname");
	tele1 = getEnt("r_3", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

sec_fail_4()
{
	trig = getEnt("trig_f_4", "targetname");
	tele1 = getEnt("r_4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}


sec_leave()
{
	trig = getEnt("sec_exit", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_1");
		}
}

sec_end_hud()
{
	sec_end = newHudElem();
	sec_end.foreground = true;
	sec_end.alpha = 1;
	sec_end.alignX = "left";
	sec_end.alignY = "middle";
	sec_end.horzAlign = "left";
	sec_end.vertAlign = "middle";
	sec_end.x = 5;
	sec_end.y = 0;
	sec_end.sort = 0;
	sec_end.font = "default";
	sec_end.fontScale = 1.4; 
	sec_end.hidewheninmenu = false;
	sec_end.glowAlpha = 1;
	sec_end.glowColor = (.2,.2,1);
	sec_end settext("^3"+ self.name + " ^7Completed The Secret!");
	wait 5;
	sec_end destroy(); 
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
		self setClientDvar("r_drawDecals","1");
		self setClientDvar("fx_enable","1");
		wait 1;
	}
}


ammo_refill()
{
	trig = getEnt("trig_ammo", "targetname");

	trig setHintString("^3Refill Ammo");

	while(1)
		{
			trig waittill("trigger", player);
			weap = player GetCurrentWeapon();
			player giveMaxAmmo(weap);	
			player setWeaponAmmoClip(weap,150);
			player playSoundToPlayer("weap_pickup", player);
			player disableWeapons(); 
			wait 3;
			player enableWeapons();
			player switchToWeapon(weap);
		}
}

sniper_room()
{
	level.snip = getEnt("trig_snip", "targetname");
	acti = getEnt("s1", "targetname");
	jumper = getEnt("s2", "targetname");
	
	while(1)
	{
		level.snip SetHintstring("^5Sniper ^7Room");
		level.snip waittill("trigger", player);

		

		level.snip SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.snip))
		return;

		level.old delete();
		level.wep delete();
		level.knife delete();
		level.deagle delete();

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
		
  		iPrintLnBold("^5" + player.name + " ^7has choosen Sniper!");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^5FIGHT");
		level.activ iPrintLnBold("^5FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while(isAlive(player) && isDefined(player))
		wait 1;
	}
}

weapon_room()
{
	level.wep = getEnt("trig_wep", "targetname");
	acti = getEnt("s1", "targetname");
	jumper = getEnt("s2", "targetname");
	
	while(1)
	{
		level.wep SetHintstring("^5Weapon ^7Room");
		level.wep waittill("trigger", player);

		
	

		level.wep SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.wep))
		return;

		level.old delete();
		level.snip delete();
		level.knife delete();
		level.deagle delete();

		player SetPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		player TakeAllWeapons();
		player GiveWeapon("ak47_mp");
		player giveMaxAmmo("ak47_mp");
		player switchToWeapon("ak47_mp");

		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon("ak47_mp");
		level.activ GiveMaxAmmo("ak47_mp");
		level.activ SwitchToWeapon("ak47_mp");

		player freezeControls(1);
		level.activ freezeControls(1);
		
  		iPrintLnBold("^5" + player.name + " ^7has choosen Weapon!");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^5FIGHT");
		level.activ iPrintLnBold("^5FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while(isAlive(player) && isDefined(player))
		wait 1;
	}
}

knife_room()
{
	level.knife = getEnt("trig_knife", "targetname");
	acti = getEnt("k1", "targetname");
	jumper = getEnt("k2", "targetname");
	
	while(1)
	{
		level.knife SetHintstring("^5Knife ^7Room");
		level.knife waittill("trigger", player);
	

		level.knife SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.knife))
		return;

		level.old delete();
		level.snip delete();
		level.wep delete();
		level.deagle delete();

		player SetPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		player TakeAllWeapons();
		player GiveWeapon("knife_mp");
		player switchToWeapon("knife_mp");

		level.activ setPlayerangles (acti.angles);
		level.activ setOrigin(acti.origin);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon("knife_mp");
		level.activ SwitchToWeapon("knife_mp");

		player freezeControls(1);
		level.activ freezeControls(1);
		
  		iPrintLnBold("^5" + player.name + " ^7has choosen Knife!");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^5FIGHT");
		level.activ iPrintLnBold("^5FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while(isAlive(player) && isDefined(player))
		wait 1;
	}
}


deagle_room()
{
	level.deagle = getEnt("trig_deagle", "targetname");
	acti = getEnt("s1", "targetname");
	jumper = getEnt("s2", "targetname");
	
	while(1)
	{
		level.deagle SetHintstring("^5Deagle ^7Room");
		level.deagle waittill("trigger", player);
	
		
		level.deagle SetHintstring("^1Wait Your Turn");
		if(!isDefined(level.deagle))
		return;

		level.old delete();
		level.snip delete();
		level.knife delete();
		level.wep delete();

		player SetPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		player TakeAllWeapons();
		player GiveWeapon("deserteagle_mp");
		player giveMaxAmmo("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");

		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon("deserteagle_mp");
		level.activ GiveMaxAmmo("deserteagle_mp");
		level.activ SwitchToWeapon("deserteagle_mp");

		player freezeControls(1);
		level.activ freezeControls(1);
		
  		iPrintLnBold("^5" + player.name + " ^7has choosen Deagle!");
		wait 1;
		player iPrintLnBold("^73");
		level.activ iPrintLnBold("^73");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^71");
		level.activ iPrintLnBold("^71");
		wait 1;
		player iPrintLnBold("^5FIGHT");
		level.activ iPrintLnBold("^5FIGHT");

		player freezeControls(0);
		level.activ freezeControls(0);

		while(isAlive(player) && isDefined(player))
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


