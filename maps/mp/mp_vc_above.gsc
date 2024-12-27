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

	Thanks to VC'Blade for his Secret Timer Script.
*/

main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    //level.portal = loadFX("fox/portal_flame_blue"); playLoopedFX(level.portal, 0.05, (-480, 4768, 392)); 
	//level.fire = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire, 0.05, (-1880, 1436, 300)); 
	//level.fire1 = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire1, 0.05, (-1448, 1436, 300));
	//level.fire2 = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire2, 0.05, (4532, 2176, 118)); 
	//level.fire3 = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire3, 0.05, (4684, 2176, 118)); 
	//level._effect["trap1"]  = loadfx("explosions/small_vehicle_explosion");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^2Jumper Secret;^5Acti Secret;");
    thread sr\api\_map::createSpawn((-512, 323, 60), 90);

	setdvar("r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000); 
	setdvar("r_drawdecals", "1" );

	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("deserteagle_mp");
	precacheItem("rpd_mp");
	precacheItem("knife_mp");
	preCacheItem("deserteagle_mp");
    preCacheItem("ak74u_mp");
	preCacheItem("g3_mp");
	precacheItem("sword_mp");

	preCacheModel("body_mp_arab_regular_sniper");
	preCacheModel("head_mp_arab_regular_headwrap");

	thread startdoor();
	thread sr_custom_tp();
	thread sr_jumper_sec_enter();
	thread sr_acti_sec_enter();
    //thread messages();
    //thread platform_1();
    //thread platform_2();
	//thread ambient_sounds();
	//thread sword();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	thread tp_1();
	//thread acti_tp();
	//thread acti_sec();
	thread acti_sec_fail1();
	thread acti_sec_fail2();
	thread acti_sec_end();
	//thread music_box();
	//thread secret_step();
	//thread secret_open();
	//thread sec_enter();
	thread sec_reset_1();
	thread sec_reset_2();
	thread sec_end();
	//thread tree_sec();
	//thread sword_room();
	//thread maze_room();
	//thread sniper_room();
	//thread lmg_room();
	//thread rpg_room();
	//thread secret_music();
	//thread vip();
	//thread trigger_spawner();
	//thread lol0x2();

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

sr_custom_tp()
{   
	ori = getEnt("here1","targetname");
	trig = spawn("trigger_radius",(-481.837, 2921.76, 0.125),0,105,100);
	trig.radius = 105;

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "blue");


	for(;;)
	{
		trig waittill("trigger",player);

		player setOrigin(ori.origin);
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

sr_jumper_sec_enter()
{
	trig = spawn("trigger_radius",(-635.393, 322.703, 0.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("here7","targetname");

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

sr_acti_sec_enter()
{
	trig = spawn("trigger_radius",(-364.428, 322.237, 0.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("here3","targetname");

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

startdoor()
{
	door = getEnt("startdoor","targetname");

    door delete();
   
}

trigger_spawner()
{
    trig = spawn("trigger_radius", (-577, 555, 245),0, 1000, 250);
	while(1)
	{
		trig waittill("trigger", player);
		player iPrintLnBold("^1gtfo fag");
		player thread gay();
		wait 0.1;
	}
}

gay()
{
	self playSound("wtf");
	wait 0.8;
	playFx( level.fx["bombexplosion"], self.origin );
	self suicide();
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
	wait 30;
	}
}


ambient_sounds()
{   
    torch1 = getEnt("torch1","targetname");
	torch2 = getEnt("torch2","targetname");
	brush = getEnt("brush_fire","targetname");

	torch1 playLoopSound("fire_wood_medium");
	torch2 playLoopSound("fire_wood_medium");
	brush playLoopSound("fire_wood_medium");
}

music_box()
{
	music = [];
	music[music.size] = "1991";
	music[music.size] = "final";
	music[music.size] = "cer";
	music[music.size] = "luke";
	music[music.size] = "you";

	x = randomInt(music.size);
	play = music[x];

	ambientStop(1);
	ambientPlay(play);
}

secret_music()
{
	trig = getEnt("trig_sec_music","targetname");
	clip = getEnt("clip5","targetname");
	tele1 = getEnt("here7","targetname");

	clip notSolid();

	trig setHintString("^1gtfo");

	trig waittill("trigger", player);

	x = randomInt(2);

	if(x == 0)
    {
		ambientStop(1);
		ambientPlay("zard");
		iPrintLnBold("^2"+ player.name + " ^7Changed the Music! ^_^");
		clip Solid();
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
		wait 0.01;
		player freezeControls(0);
	}
	if(x == 1)
    {
		clip Solid();
		player iPrintLnBold("^1get Fuked lmao");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
		wait 0.01;
		player freezeControls(0);
	}

	trig delete();
}

sword()
{
	trig = getEnt("trig_sword","targetname");
	sword = getEnt("sword","targetname");

	trig setHintString("Press [^5&&1^7] For Sword");

	trig waittill("trigger", player);

	player giveWeapon("sword_mp");
	player switchToWeapon("sword_mp");
	player playSoundToPlayer("weap_pickup", player);
	sword delete();
	trig delete();
}




platform_1()
{
	elev = getent("ele1", "targetname");
	
	for(;;)
	{
	wait 0.1;
	elev moveY (960, 2);
    wait 4;
	elev moveY (-960, 2); //768
	wait 4;
	}	
}

platform_2()
{
	elev = getent("ele2", "targetname");
	
	for(;;)
	{
	wait 0.1;
	elev moveZ (-376, 2);
    wait 4;
	elev moveZ (376, 2);
	wait 4;
	}	
}

trap1()
{
	brush1 = getEnt("trap1_a", "targetname");
	brush2 = getEnt("trap1_b", "targetname");
	trig = getEnt("trig_trap1", "targetname"); 

	trig setHintString("Press ^7[^5&&1^7] ^7To Make Platform Not Solid");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    x = randomInt(2);
	if(x == 0)
    {
    brush1 notSolid();
    trig delete();
	}
    if(x == 1)
    {
    brush2 notSolid();
    trig delete();
	}
}

trap2()
{
	brush1 = getEnt("trap2_a", "targetname");
	brush2 = getEnt("trap2_b", "targetname");
	c4_a = getEnt("c4_a", "targetname");
	c4_b = getEnt("c4_b", "targetname");
	trig = getEnt("trig_trap2", "targetname"); 

	trig setHintString("Press ^7[^5&&1^7] ^7To Detonate C4");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	trig playSound("weap_c4detpack_trigger_plr");
	wait 0.3;

    x = randomInt(2);
	if(x == 0)
    {
	playfx(level._effect["trap1"], (-640, 2016, 2));
	brush1 playSound("grenade_explode_metal");
    brush1 delete();
	c4_a delete();
    trig delete();
	}
    if(x == 1)
    {
	playfx(level._effect["trap1"], (-384, 2016, 2)); 
	brush2 playSound("grenade_explode_metal"); 
    brush2 delete();
	c4_b delete();
    trig delete();
	}
}

trap3()
{
	brush1 = getEnt("trap3_a", "targetname");
	brush2 = getEnt("trap3_b", "targetname");
	trig = getEnt("trig_trap3", "targetname"); 

	trig setHintString("Press ^7[^5&&1^7] ^7To Split Bounce");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    brush1 moveX(-120,0.2);
	brush2 moveX(120,0.2);
	wait 3;
	brush1 moveX(120,2);
	brush2 moveX(-120,2);
    trig delete();
}

trap4()
{
	brush = getEnt("trap4", "targetname");
	trig = getEnt("trig_trap4", "targetname"); 

	trig setHintString("Press ^7[^5&&1^7] ^7To Block Jumpers");


    trig delete();
	brush delete();
}


trap5()
{
	brush = getEnt("trap5", "targetname");
	trig = getEnt("trig_trap5", "targetname"); 

	trig setHintString("Press ^7[^5&&1^7] ^7To Remove Floor");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    brush delete();
    trig delete();
}


trap6()
{
	brush = getEnt("trap6", "targetname");
	trig = getEnt("trig_trap6", "targetname"); 
	hurt = getEnt("trig_hurt", "targetname"); 

	brush hide();
	
	trig setHintString("Press ^7[^5&&1^7] ^7To Activate Spikes");
	
	trig waittill("trigger", player);
	brush show();
	player braxi\_rank::giveRankXP( "", 50 );

	hurt enableLinkTo();
	hurt linkTo(brush);

    brush moveZ(128, 0.2);
	wait 6;
	hurt delete();
	brush moveZ(-128, 2);
	wait 4;
	brush delete();
    trig delete();
}

trap7()
{
	brush1 = getEnt("trap7", "targetname");
	brush2 = getEnt("trap7b", "targetname");
	trig = getEnt("trig_trap7", "targetname"); 
	
	trig setHintString("Press ^7[^5&&1^7] ^7To Rotate Pillars");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	trig delete();

	for(;;)
	{
		wait 0.1;
		brush1 rotateYaw(-720, 2);
		brush2 rotateYaw(720, 2);
		wait 5;
		brush1 rotateYaw(720, 2);
		brush2 rotateYaw(-720, 2);
		wait 5;
	}

}


tp_1()
{
	trig = getEnt("trig_tp1", "targetname");
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

acti_tp()
{
	trig = getEnt("trig_acti", "targetname");
	tele1 = getEnt("here2", "targetname");

	trig waittill("trigger", player);
	trig delete();
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
}

acti_sec()
{
	brush = getEnt("acti_door", "targetname");
	trig = getEnt("trig_acti_sec", "targetname"); 
	
	trig setHintString("Press ^7[^5&&1^7] ^7To Enter Jump Room");
	
	trig waittill("trigger", player);
    brush moveZ(-130, 2);
	brush playSound("rock");
	trig delete();
}

acti_sec_fail1()
{
	trig = getEnt("trig_acti_fail1", "targetname");
	tele1 = getEnt("here3", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);
	player Suicide();
	}
}

acti_sec_fail2()
{
	trig = getEnt("trig_acti_fail2", "targetname");
	tele1 = getEnt("here4", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);
	player Suicide();
	}
}

acti_sec_end()
{
	trig = getEnt("trig_acti_end", "targetname");
	tele1 = getEnt("here5", "targetname");
	brush = getEnt("acti_door", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Finish Activator Secret!");

	for(;;)
	{

	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_1"); 

	}
}


secret_step()
{
	brush = getEnt("sec_door", "targetname");
	trig = getEnt("trig_sec", "targetname"); 
	
	trig waittill("trigger", player);

    brush notSolid();    
	player iPrintLn("^3W");
	player iPrintLn("^5U");
	player iPrintLn("^1T");
	trig delete();
}

secret_open()
{
	brush = getEnt("sec_path", "targetname");
	door = getEnt("sec_door", "targetname");
	clip = getEnt("clip1", "targetname");
	trig = getEnt("trig_sec_open", "targetname"); 
	tele1 = getEnt("here6", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Open Secret");

	brush hide();
	brush notSolid();
	
	trig waittill("trigger", player);

    brush solid();  
	brush show();
	iPrintLn("^3Secret Open!");
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player freezeControls(1);
	wait 0.5;
	player freezeControls(0);
	trig delete();
	door solid();
	clip delete();
}

sec_enter()
{
	trig = getEnt("sec_enter", "targetname");
	tele1 = getEnt("here7", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);
	player thread secret_timer();
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	player freezeControls(1);
	wait 0.5;
	player freezeControls(0);
	}
}

sec_reset_1()
{
	trig = getEnt("sec_fail_1", "targetname");
	tele1 = getEnt("here7", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);
	player Suicide();
	}
}

sec_reset_2()
{
	trig = getEnt("sec_fail_2", "targetname");
	tele1 = getEnt("sec_r_2", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);
	player Suicide();
	}
}

sec_end()
{
	trig = getEnt("sec_end", "targetname");
	tele1 = getEnt("here1", "targetname");

	trig setHintString("Press ^7[^5&&1^7] ^7To Leave Secret");

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

	time=60;
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


tree_sec()
{
	trig = getEnt("trig_tree", "targetname");
	tele1 = getEnt("here8", "targetname");
	clip = getEnt("cip_tree", "targetname");

	trig waittill("trigger", player);	
	player freezeControls(1);
	player iPrintLnBold("Magic Tree gives you random XP :o");	
	wait 2;
	player iPrintLnBold("^2*");
	player iPrintLnBold("^2^");
	player iPrintLnBold("^2^^^");
	player iPrintLnBold("^2^^^^^");
	player iPrintLnBold("^2|");
	player thread tree_xp();
	clip delete();
	trig delete();
	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);
	wait 0.5;
	player freezeControls(0);
}

tree_xp()
{
    rand = RandomIntRange(500, 1500);
    self braxi\_rank::giveRankXP( "", rand);
    self iprintln("^7+ ^2" +rand +"XP");
}

sword_room()
{
	while(1)
	{
		level.trigsword = getEnt("trig_knife","targetname");
		acti = getEnt("k1","targetname");
		jump = getEnt("k2","targetname");
		
		level.trigsword setHintString("Sword Room");
		
		level.trigsword waittill("trigger", player);

		

		level.trigsniper delete();
		level.trigmaze delete();
		level.triglmg delete();
		level.trigrpg delete();

		iPrintLnBold("^3" + player.name + "^7 Entered The Sword Room"); 
		
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
		player giveWeapon("sword_mp");
		player switchToWeapon("sword_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("sword_mp");
		level.activ switchToWeapon("sword_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while(isAlive( player ) && isDefined( player ) && player.sessionstate == "playing")
		wait 0.5;
		player = undefined;	
	}
}

maze_room()
{
	while(1)
	{
		level.trigmaze = getEnt("trig_maze","targetname");
		acti = getEnt("maze1","targetname");
		jump = getEnt("maze2","targetname");
		
		level.trigmaze setHintString("Maze Room");
		
		level.trigmaze waittill("trigger", player);



		level.trigsniper delete();
		level.trigsword delete();
		level.triglmg delete();
		level.trigrpg delete();

		iPrintLnBold("^3" + player.name + "^7 Enters the Maze!"); 
		
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
	
		while(isAlive( player ) && isDefined( player ) && player.sessionstate == "playing")
		wait 0.5;
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
		
		level.trigsniper setHintString("Sniper Room");
		
		level.trigsniper waittill("trigger", player);

		level.trigmaze delete();
		level.trigsword delete();
		level.triglmg delete();
		level.trigrpg delete();
		
		iPrintLnBold("^3" + player.name + "^7 Entered The Sniper Room"); 
		
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
		player = undefined;
		
	}
}


lmg_room()
{
	while(1)
	{
		level.triglmg = getEnt("trig_lmg","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.triglmg setHintString("Grease Gun Room");
		
		level.triglmg waittill("trigger", player);

	
		
		level.trigsniper delete();
		level.trigsword delete();
		level.trigmaze delete();
		level.trigrpg delete();
		
		iPrintLnBold("^3" + player.name + "^7 uses the Grease Gun!"); 
		
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
		player giveWeapon("rpd_mp");
		player giveWeapon("rpd_mp");
		player switchToWeapon("rpd_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("rpd_mp");
		level.activ giveMaxAmmo("rpd_mp");
		level.activ switchToWeapon("rpd_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
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
		
		level.trigrpg setHintString("RPG Room");
		
		level.trigrpg waittill("trigger", player);

	
		
		level.trigsniper delete();
		level.trigsword delete();
		level.triglmg delete();
		level.trigmaze delete();
		
		iPrintLnBold("^3" + player.name + "^7 Entered The RPG Room!"); 
		
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
		player detachAll();
		player setModel("body_mp_arab_regular_sniper");
		player attach("head_mp_arab_regular_headwrap", "", true);
		player giveWeapon("rpd_mp");
		player giveMaxAmmo("rpd_mp");
		player switchToWeapon("rpd_mp");
		player giveWeapon("sword_mp");
		wait 0.1;
    }
	if(player getStat(767)==0)
        player iprintlnbold("^1Access Denied");
		wait 0.1;
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
