main()
{
	maps\mp\_load::main();

	//ambientPlay("amb_winter_run");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//level.snow = loadFX("weather/snow_light_mp_bloc"); playLoopedFX(level.snow, 0.05, (-512, 2240, 448)); 
	//level.snow2 = loadFX("weather/snow_light_mp_bloc"); playLoopedFX(level.snow2, 0.05, (896, -576, 448));
	//level.airstrikefx = loadfx ("explosions/clusterbomb"); 
	//level.exp = loadfx ("explosions/small_vehicle_explosion"); 
	

    VisionSetNaked("mp_crash_snow", 0);

	setDvar("r_drawDecals","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
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
	precacheItem("ak47_mp");
	preCacheItem("saw_mp");
	preCacheItem("snowball_mp");
	preCacheItem("ak74u_mp");
	preCacheModel("playermodel_bo1_spet_winter_body");
	preCacheModel("head_russian_gas_mask");
	preCacheModel("viewhandsl_bo1_spet_winter");

	thread startdoor();
	thread sr_sec_enter();
	//thread door_check();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	thread trap7();
	//thread trap8();
	//thread vistic_vip();
	//thread messages();
	//thread ambient_sounds();
	//thread radio();
	//thread sec_step1();
	thread sec_fail_1();
	thread sec_fail_2();
	thread sec_fail_3();
	thread sec_fail_4();
	thread sec_leave();
	//thread onConnect();
	//thread acti_door();
	//thread vip_music();
	//thread friends();
	//thread ammo_refill();
	//thread sniper_room();
	//thread weapon_room();
	//thread snow_jumper();
	//thread snow_acti();
	//thread lol0x2();

	addQueueTrigger("end_door");
	addQueueTrigger("trig_wep");
	addQueueTrigger("trig_sniper");


	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_acti_door");

}

addTriggerToList( name ) 
{
    if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(-626.95, 526.594, 8.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("sec_enter","targetname");

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
startdoor()
{
	door = getEnt("startdoor","targetname");

	door delete();

}


ambient_sounds()
{   
    elec = getEnt("elec1","targetname");
	wood = getEnt("wood","targetname");

	elec playLoopSound("elec");
	wood playLoopSound("wood_creak");
}

snow_jumper()
{
	trig = getEnt("trig_snow","targetname");
	trig setHintString("Press [^5&&1^7] For Snowball");

	while (1)
    {
		trig waittill("trigger",player);
		player thread give_snow();
		wait 0.1;
	}
}

snow_acti()
{
	trig = getEnt("trig_snow_acti","targetname");
	trig setHintString("Press [^5&&1^7] For Snowball");

	while (1)
    {
		trig waittill("trigger",player);
		player thread give_snow();
		wait 0.1;
	}
}

give_snow()
{
	self giveWeapon("snowball_mp");
	self giveMaxAmmo("snowball_mp");
	self switchToWeapon("snowball_mp");
}



radio()
{
	radio = getEnt("radio","targetname");

	x = randomInt(3);
	if(x == 0)
    {
		radio playLoopSound("radio");
	}
	if(x == 1)
    {
		radio playLoopSound("xmas1");
	}
	if(x == 2)
    {
		radio playLoopSound("xmas2");
	}
}

friends()
{      
        level.accepted1 = "2310346615939752233"; //Lue
        //level.accepted2 = ""; 
       
        while (1)
        {
			level waittill("player_spawn", player);
			wait 2;
			tempGuid = player getGUID();
       
        if ((tempGuid == level.accepted1))
        {
			player detachAll();
			player setViewModel("viewhandsl_bo1_spet_winter");
			player setModel("playermodel_bo1_spet_winter_body");
			player attach("head_russian_gas_mask");
        }
}
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

door_check()
{
	door = getEnt("end_door", "targetname"); 
	level.trigold = getEnt("trig_old", "targetname"); 

	level.trigold setHintString("Press [^5&&1^7] To Open Door");

	level.trigold waittill ("trigger",player );
  while(1){
 

	level.trigold delete();
	level.trigwep delete();
	level.trigsniper delete();
	iPrintLn("^7End Door is ^5Open^7");
	noti = SpawnStruct();
	noti.notifyText = "^7^7";
	noti.duration = 5;
	players = getEntArray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	door moveZ(-200,3);
	wait 3.1;
	door delete();
  }

}


trap1()
{
	brush = getEnt("trap1","targetname");
	brush1 = getEnt("trap1a","targetname");
	trig = getEnt("trig_trap1","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);
	//player braxi\_rank::giveRankXP( "", 25 );
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

	//player braxi\_rank::giveRankXP( "", 25 );
	
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

	//player braxi\_rank::giveRankXP( "", 25 );

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
	//player braxi\_rank::giveRankXP( "", 25 );
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
		//
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

	kill_trig enableLinkTo();
	kill_trig linkTo(brush3);

	jet1 show();
	jet2 show();

	//player braxi\_rank::giveRankXP( "", 25 );

	trig delete();

	jet1 playSound("veh_mig29_sonic_boom");
	jet1 moveX(-8400, 3);
	wait 1;
	brush3 moveZ(24,0.2);
	playfx(level.airstrikefx, (320, 3432, 96));
	brush1 playSound("evil_santa");
	brush1 playSound("bells");
	brush1 playSound("artillery_impact");
	brush2 playSound("fast_artillery_round");
	wait 1.2;
	jet2 playSound("veh_mig29_sonic_boom");
	jet2 moveX(-8400, 3);
	wait 1;
	playfx(level.airstrikefx, (320, 3432, 96));
	brush1 playSound("artillery_impact");
	brush2 playSound("fast_artillery_round");
	wait 1;
	brush3 delete();
	kill_trig delete();
	wait 4;
	jet1 delete();
	jet2 delete();
}


trap6()
{
	brush = getEnt("trap6","targetname");
	trig = getEnt("trig_trap6","targetname");

	trig setHintString("Press [^5&&1^7] To Activate");

	trig waittill("trigger",player);

	//player braxi\_rank::giveRankXP( "", 25 );

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

	//player braxi\_rank::giveRankXP( "", 25 );
	
	trig delete();

	brush rotateYaw(-720, 2);
	brush moveZ(-200, 2);
	wait 4;
	brush moveZ(200, 3);
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
	ambientStop(5);
	ambientPlay("amb_jug",5);
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
		player setViewModel("viewhandsl_bo1_spet_winter");
		player setModel("playermodel_bo1_spet_winter_body");
		player attach("head_russian_gas_mask");
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

	iPrintLn("^21");

	thread sec_step2();
}

sec_step2()
{
	trig = getEnt("sec_step2", "targetname");

	trig waittill("trigger",player);

	trig delete();

	iPrintLn("^22");

	thread sec_step3();
}

sec_step3()
{
	trig = getEnt("sec_step3", "targetname");

	trig waittill("trigger",player);

	trig delete();

	iPrintLn("^23");

	thread sec_step4();
}

sec_step4()
{
	trig = getEnt("sec_step4", "targetname");
	tele1 = getEnt("sec_enter", "targetname");

	trig waittill("trigger", player);
	trig delete();
	player iPrintLnBold("You Found The Secret Way!");	
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player thread secret_timer();
	wait 0.01;

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

			player thread sr\api\_speedrun::finishWay("secret_0");
		}
}


secret_timer()
{
	self endon("secret_done");
	
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
	self.secretTimer.glowAlpha = 0;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"^7Time in Secret: ^5&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(1,0,0);

	time=45;
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
	while(1)
	{
		level.trigsniper = getEnt("trig_sniper","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigsniper setHintString("^5Sniper Room");
		
		level.trigsniper waittill("trigger", player);
		
		
		level.trigold delete();
		level.trigwep delete();
		
		noti = SpawnStruct();
		noti.titleText = "^5" + player.name + " ^7Enterd the ^5Sniper Room";
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
		
		iPrintLnBold("^3" + player.name + "^5 Has Died!");
		wait 1;
		iPrintLnBold("^7Sniper Room Open!");
		player = undefined;
		
	}
}


weapon_room()
{
	while(1)
	{
		level.trigwep = getEnt("trig_wep","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigwep setHintString("^5Weapon Room");
		
		level.trigwep waittill("trigger", player);

		
		level.trigold delete();
		level.trigsniper delete();
		
		noti = SpawnStruct();
		noti.titleText = "^5" + player.name + " ^7Enterd the ^5Weapon Room";
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
		player giveWeapon("ak47_mp");
		player giveMaxAmmo("ak47_mp");
		player switchToWeapon("ak47_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("ak47_mp");
		level.activ giveMaxAmmo("ak47_mp");
		level.activ switchToWeapon("ak47_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^5 Has Died!");
		wait 1;
		iPrintLnBold("^7Weapon Room Open!");
		player = undefined;
		
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