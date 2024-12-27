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
	By VC' Fox.
		___    __  _       _______        
	| | / (_)__/ /_(_)___  / ___/ /__ ____ 
	| |/ / (_-< __/ / __/ / /__/ / _ `/ _ \
	|___/_/___|__/_/\__/  \___/_/\_,_/_//_/ 
	vistic-clan.net


	trig_skull();
*/
main()
{
	maps\mp\_load::main(); 

    ambientPlay("ambient1");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-512, -592, 68), 90);

    //level.fire = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire, 0.05, (-424, -872, 50)); 
    //level.fire2 = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire2, 0.05, (-608, -872, 50)); 
    //level._effect["trap1"]  = loadfx("explosions/default_explosion");
	
	visionSetNaked("hunted");
    setExpFog(500, 3500, .5, 0.5, 0.45, 0);
	setDvar("r_drawDecals","1");
	setDvar("r_specularcolorscale", "2.3");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
    setDvar("sm_sunShadowScale", "0.5");
    setDvar("r_filmTweakLightTint","0.736 1.092 1.618");
    setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);
	
	precacheItem("remington700_mp"); 
    precacheItem("c4_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("rpg_mp"); 
	precacheItem("knife_mp");
	precacheItem("m1014_mp");
	precacheItem("usp_mp");
	precacheItem("colt45_mp");
	precacheItem("deserteagle_mp");
	precacheItem("uzi_silencer_mp");
	precacheItem("p90_mp");
	precacheItem("rpd_mp");
	precacheItem("saw_mp");
	precacheItem("ak47_mp");
    precacheItem("ak74u_mp");
	precacheItem("artillery_mp");
	precacheItem("dragunov_mp");

    thread startdoor();
	thread sr_tp();
    thread sr_sec_enter();
    //thread ambient_sounds();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();
    //thread messages();
    //thread platform();
    //thread teleport_1();
    //thread teleport_2();
    //thread rotate_trap();
    //thread ghost_trap1();
    //thread wolf_sound();
    //thread animal_sound();
    //thread suspence_sound();
    //thread onConnect();
    //thread secret_door();
    //thread exp();
    //thread acti_tp_1();
    //thread acti_tp_2();
    //thread acti_tp_3();
    thread secret_finish();
    //thread ele_ak47();
    //thread ele_ak74u();
    //thread ele_sec();
    //thread ghost1();
    //thread rpg_room();
    //thread sniper_room();
    //thread shotgun_room();
    //thread marksman_room();
    //thread vip();
    //thread sec_shortcut();
	//thread lol0x2();

    addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");
    addTriggerToList("trig_trap7");

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

sr_tp()
{
	trig = getEnt("trig_plat","targetname");
	ori = getEnt("here1","targetname");

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
	trig = spawn("trigger_radius",(-678.415, -591.863, 8.125), 0, 60, 100);
	trig.radius = 60;

	ori = spawn("script_origin",(-597,-990,68));
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
messages()
{
	for(;;)
	{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^2Happy Halloween from Vistic Clan"); 
	wait 30;
	iPrintLn("^7Discord: ^3VC'Fox#0001"); 
	wait 30;
	}
}


platform()
{
	elev = getEnt("ele", "targetname");
    trig = getEnt("trig_plat", "targetname");
	
    trig waittill("trigger", player);

	for(;;)
	{
	wait 0.1;
	elev moveY (640, 3.5);
	wait 5;
	elev moveY (-640, 3.5);
	wait 5;
	}	
}

teleport_1() 
{
	trig = getEnt("trig_tp_1", "targetname");
	tele1 = getEnt("here1", "targetname");

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

teleport_2() 
{
	trig = getEnt("trig_tp_2", "targetname");
	tele1 = getEnt("here2", "targetname");

	for(;;)
	{
    trig waittill("trigger", player);
    player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    player freezeControls(1);
    wait 0.5;
    player freezeControls(0);
	}
}

ghost_trap1()
{
    g5 = getEnt("ghost5", "targetname");
    brush = getEnt("ghost_brush", "targetname");
    trig = getEnt("ghost_trig", "targetname");

    trig enableLinkTo();
	trig linkTo(brush);

    brush notSolid();
    brush hide();

    for(;;)
    {
    wait 0.2;
    g5 moveX(-1072,3);
    brush moveX(-1072,3);
    wait 4;
    g5 rotateYaw(-180,0.1);
    wait 0.2;
    g5 moveX(1072,3);
    brush moveX(1072,3);
    wait 4;
    g5 rotateYaw(-180,0.1);
    }
}


ambient_sounds()
{   
    torch1 = getEnt("b1","targetname");
	torch2 = getEnt("b2","targetname");

	torch1 playLoopSound("fire_wood_small");
	torch2 playLoopSound("fire_wood_small");
}


wolf_sound()
{
	trig = getEnt("trig_wolf", "targetname");
	brush =  getEnt("brush_wolf", "targetname");

	trig waittill("trigger", player);

    trig delete();

    x = randomInt(4);

	if(x == 0)
    {
	brush playSound("wolf1");
	}
    if(x == 1)
    {
	brush playSound("wolf2");
	}
    if(x == 2)
    {
	brush playSound("wolf3");
	}
    if(x == 3)
    {
	brush playSound("wolf4");
	}
}

animal_sound()
{
	trig = getEnt("trig_an", "targetname");
	brush =  getEnt("brush_an", "targetname");

	trig waittill("trigger", player);

    trig delete();

    x = randomInt(4);

	if(x == 0)
    {
	brush playSound("loon1");
	}
    if(x == 1)
    {
	brush playSound("owl");
	}
    if(x == 2)
    {
	brush playSound("loon2");
	}
    if(x == 3)
    {
	brush playSound("loon3");
	}
}

suspence_sound()
{
	trig = getEnt("trig_sus", "targetname");

	trig waittill("trigger", player);

    trig delete();

    x = randomInt(4);

	if(x == 0)
    {
		ambientStop(5);	
		wait 3;
    	ambientPlay("suspense1",5);
		wait 20;
		ambientStop(5);	
    	ambientPlay("ambient1",5); 
    }

    if(x == 1)
    {
		ambientStop(5); 
		wait 3;
      	ambientPlay("suspense2",5);
		wait 20;
		ambientStop(5);	
    	ambientPlay("ambient1",5);
    }

    if(x == 2)
    {
		ambientStop(5);
		wait 3;
      	ambientPlay("suspense3",5);
		wait 20;
		ambientStop(5);	
    	ambientPlay("ambient1",5);
    }   

    if(x == 3)
    {
		ambientStop(5);
		wait 3;
   		ambientPlay("suspense4",5);
		wait 20;
		ambientStop(5);	
    	ambientPlay("ambient1",5);

    }  
    
}


trap1()
{
	brush1 = getEnt("trap1a", "targetname");
	brush2 = getEnt("trap1b", "targetname");
	trig = getEnt("trig_trap1", "targetname"); 
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Rotate Pillars");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();

    brush1 rotateYaw(-720, 2);
    brush2 rotateYaw(720, 2);
}


trap2()
{
	brush1 = getEnt("trap2", "targetname");
	brush2 = getEnt("trap2a", "targetname");
	trig = getEnt("trig_trap2", "targetname"); 

	trig setHintString("Press ^7[^2&&1^7] ^7To Delete Part Of The Bounce");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
    trig delete();

    x = randomInt(2);
	if(x == 0)
    {
        brush1 delete();
	}
    if(x == 1)
    {
        brush2 delete();
	}
}

trap3()
{
	trig = getEnt("trig_trap3", "targetname"); 

	trig setHintString("Press ^7[^2&&1^7] ^7To Curse Door 1 or 2");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    x = randomInt(2);
	if(x == 0)
    {
        player iPrintLnBold("You placed a Curse on door 1");
        player thread door_a();
        trig delete();
	}
    if(x == 1)
    {
        player iPrintLnBold("You placed a Curse on door 2");
        player thread door_b();
        trig delete();
	}
}


door_a()
{
	trig = getEnt("trig_doora", "targetname"); 

    while(1)
    {
        trig waittill("trigger", player);
        player playSoundToPlayer("door", player);
        player thread cursed();
        iPrintLn("^3"+player.name+" ^7was cursed by ^1"+level.activ.name+"^7");
    }
    
}

door_b()
{
	trig = getEnt("trig_doorb", "targetname"); 


    while(1)
    {
        trig waittill("trigger", player);
        player playSoundToPlayer("door", player);
        player thread cursed();
        iPrintLn("^3"+player.name+" ^7was cursed by ^1"+level.activ.name+"^7");
    }
    
}

cursed()
{
    self endon ("death");
    self setClientDvar("r_blur", 8.0);
    self SetMoveSpeedScale(0.01);
    self AllowSprint(0);
    wait 5;
    self suicide();
    self setClientDvar("r_blur", 1.0);      
    self SetMoveSpeedScale (1.0);
    self AllowSprint(1);
}


trap4()
{
	trig = getEnt("trig_trap4", "targetname"); 
    brush = getEnt("trap4", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Delete Bridge");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    brush delete();
    trig delete();

}

rotate_trap()
{
	r1 = getEnt("brush_r1", "targetname");

	for(;;)
	{
        r1 rotateYaw(-360,4);
        wait 4;
	}	
}

ghost1()
{
	gh = getEnt("gh1", "targetname");

	for(;;)
	{
        gh moveZ(20, 5);
        wait 5;
        gh moveZ(-20, 5);
        wait 5;
	}	
}


trap5()
{
	trig = getEnt("trig_trap5", "targetname"); 
    brush1 = getEnt("trap5a", "targetname");
    brush2 = getEnt("trap5b", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Remove Random Pillars");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
    trig delete();

    x = randomInt(2);
	if(x == 0)
    {
        brush1 moveZ(-200,2);
        wait 2;
        brush1 delete();
	}
    if(x == 1)
    {
        brush2 moveZ(-200,2);
        wait 2;
        brush2 delete();
	}
}


trap6()
{
	trig = getEnt("trig_trap6", "targetname"); 
    brush = getEnt("trap6a", "targetname");
    kill = getEnt("trap6a_kill", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate Spikes");

	kill enableLinkTo();
	kill linkTo(brush);

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
    trig delete();

    for(;;)
    {
        brush moveZ(200, 3);
        wait 5;
        brush moveZ(-200, 3);
        wait 5;
    }
}
 


trap7()
{
	trig = getEnt("trig_trap7", "targetname"); 
    brush1 = getEnt("trap7a", "targetname");
    brush2 = getEnt("trap7b", "targetname");
    brush3 = getEnt("trap7c", "targetname");
    brush4 = getEnt("trap7d", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Remove Random Brush");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
    trig delete();

    x = randomInt(4);
	if(x == 0)
    {
        brush1 delete();
        brush2 delete();
	}
    if(x == 1)
    {
        brush2 delete();
        brush4 delete();
	}
    if(x == 2)
    {
        brush2 delete();
        brush3 delete();
	}
    if(x == 3)
    {
        brush3 delete();
        brush4 delete();
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
		self setClientDvar("r_filmTweakLightTint","0.736 1.092 1.618");
		self setClientDvar("r_filmTweakDarkTint","0.697 0.697 0.618");
		self setClientDvar("r_filmTweakBrightness",0.08);
		self setClientDvar("r_filmTweakContrast",1.312);
		self setClientDvar("r_lightTweakSunLight",0.9);
		self setClientDvar("r_filmTweakEnable",1);
		self setClientDvar("r_filmUseTweaks",1);
        self setClientDvar("r_drawDecals",1);
		wait 1;
	}
}


secret_door()
{
	door = getEnt("sec_door", "targetname");
    clip1 = getEnt("clip1", "targetname");
	trig = getEnt("trig_sec", "targetname"); 
    model1 = getEnt("plant1", "targetname"); 
    brush = getEnt("brush_sound", "targetname"); 

    model1 hide();

    trig setHintString("Press ^7[^2&&1^7] ^7To Open Secret");
	
	while(1)
	{
		trig waittill("trigger", player);

		if(isdefined(level.sec) && level.sec == true)
		{
            model1 show();
            player playSoundToPlayer("c4_bounce_wood", player);
            weap = player GetCurrentWeapon();
            wait 1;
            player giveWeapon("c4_mp");
            player switchToWeapon("c4_mp");
            wait 2;
            player switchToWeapon(weap);
            wait 0.5;
            player takeWeapon("c4_mp");
            brush playSound("grenade_explode_mud"); 
            playfx(level._effect["trap1"], (-513, -889, 67));

            clip1 delete();
            model1 delete();
            door delete();

			iprintlnbold("^3"+player.name+" ^7opened the Secret Door!");

            trig delete();
		}
		else 
			player iprintlnbold("^1Explosives Missing");
	}
}


exp()
{
	trig = getent("trig_exp", "targetname");
    exp = getent("sec_exp", "targetname");

    trig setHintString("Press ^7[^2&&1^7] ^7For Explosives");

	trig waittill("trigger", player);

	iprintlnbold("^3"+player.name+" ^7Got the Explosives");
    player playSoundToPlayer("weap_pickup", player);

    exp delete();
	trig delete();

	level.sec = true;
    player waittill("death");
    level.sec = false;

}


acti_tp_1() 
{
	trig = getEnt("trig_acti_tp1", "targetname");
	tele1 = getEnt("here3", "targetname");

    trig setHintString("^2Move to Next Area");

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

acti_tp_2() 
{
	trig = getEnt("trig_acti_tp2", "targetname");
	tele1 = getEnt("here4", "targetname");

    trig setHintString("^2Move to Next Area");

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

acti_tp_3() 
{
	trig = getEnt("trig_acti_tp_3", "targetname");
	tele1 = getEnt("here5", "targetname");

    trig setHintString("^2Move to Next Area");

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


secret_finish() 
{
	trig = getEnt("trig_sec_end", "targetname");
	tele1 = getEnt("here1", "targetname");

    trig setHintString("Press ^7[^2&&1^7] ^7To Finish Secret");

	for(;;)
	{
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_0");

	}
}


ele_sec()
{
	trig = getEnt("trig_ele_sec", "targetname");

 	while (1)
 	{
 	trig waittill("trigger", player);
  	if(isPlayer(player) && isAlive(player) && !(isdefined(player.ele)))
    {
  	iPrintLnBold("^3"+ player.name + " ^7Completed The Elevator Secret^7!");
	player braxi\_rank::giveRankXP( "", 250 );
  	player.ele = true;
	}
 	wait .05;
}
}


ele_ak74u()
{
	trig = getEnt("trig_ele_wep1", "targetname");
	
	trig setHintString("Press [^3&&1^7] For AK74u");
	
		for(;;)
		{	
			trig waittill ("trigger",player );
            weap = player GetCurrentWeapon();
			player takeWeapon(weap);
			player giveWeapon("ak74u_mp");
			player giveMaxAmmo("ak74u_mp");
			player switchToWeapon("ak74u_mp");
			wait 0.1;
		}
}


ele_ak47()
{
	trig = getEnt("trig_ele_wep2", "targetname");
	
	trig setHintString("Press [^3&&1^7] For AK47");
	
		for(;;)
		{	
			trig waittill ("trigger",player );
            weap = player GetCurrentWeapon();
			player takeWeapon(weap);
			player giveWeapon("ak47_mp");
			player giveMaxAmmo("ak47_mp");
			player switchToWeapon("ak47_mp");
			wait 0.1;
		}
}


vip()
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
		player giveWeapon("m21_mp");
		player giveMaxAmmo("m21_mp");
		wait 0.1;
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
	}
}



shotgun_room()
{
	while(1)
	{
		level.trigshotgun = getEnt("trig_shotgun","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigshotgun setHintString("^2Shotgun ^7Room");
		
		level.trigshotgun waittill("trigger", player);

	

        ambientStop(5);
        ambientPlay("shotgun");
		
		level.trigrpg delete();
		level.trigsniper delete();
        level.trigmark delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Shotgun Room";
		noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
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
		player giveWeapon("m1014_mp");
		player giveMaxAmmo("m1014_mp");
		player switchToWeapon("m1014_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("m1014_mp");
		level.activ giveMaxAmmo("m1014_mp");
		level.activ switchToWeapon("m1014_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Shotgun Room Open!");
		player = undefined;
		
	}
}



sniper_room()
{
	while(1)
	{
		level.trigsniper = getEnt("trig_sniper","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigsniper setHintString("^2Sniper ^7Room");
		
		level.trigsniper waittill("trigger", player);

	

        ambientStop(5);
        ambientPlay("sniper");
		
		level.trigrpg delete();
        level.trigmark delete();
		level.trigshotgun delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Sniper Room";
		noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
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


marksman_room()
{
	while(1)
	{
		level.trigmark = getEnt("trig_mark","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigmark setHintString("^2marksman ^7Room");
		
		level.trigmark waittill("trigger", player);


        ambientStop(5);
        ambientPlay("mark");
		
		level.trigrpg delete();
		level.trigsniper delete();
        level.trigshotgun delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^Marksman Room";
		noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
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
		player giveWeapon("m21_mp");
        player giveMaxAmmo("m21_mp");
        player switchToWeapon("m21_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("m21_mp");
		level.activ giveMaxAmmo("m21_mp");
        level.activ switchToWeapon("m21_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Marksman Room Open!");
		player = undefined;
		
	}
}


rpg_room()
{
	while(1)
	{
		level.trigrpg = getEnt("trig_rpg","targetname");
		acti = getEnt("rpg_acti","targetname");
		jump = getEnt("rpg_jumper","targetname");
		
		level.trigrpg setHintString("^2RPG ^7Room");
		
		level.trigrpg waittill("trigger", player);

	

        ambientStop(5);
        ambientPlay("dreamer");
		
		level.trigsniper delete();
		level.trigmark delete();
        level.trigshotgun delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2RPG Room";
		noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
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
		player giveWeapon("rpg_mp");
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




sec_shortcut() 
{
	trig = getEnt("trig_skull_sec", "targetname");
	tele1 = getEnt("here1", "targetname");


  	for(;;)
	{
    trig waittill("trigger", player);
    iPrintLn("^3"+ player.name + " ^7Found a shortcut!");	
	player braxi\_rank::giveRankXP( "", 1250);
    player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    player freezeControls(1);
    wait 0.01;
    player freezeControls(0);
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






