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
*/
main()
{
	maps\mp\_load::main(); 

    //ambientPlay("ambient1");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

    //level.fire = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire, 0.05, (-424, -872, 50)); 
    //level.fire2 = loadFX("fire/firelp_barrel_pm"); playLoopedFX(level.fire2, 0.05, (-608, -872, 50)); 
    //level._effect["trap1"]  = loadfx("explosions/default_explosion");
	
	visionSetNaked("hunted");
	setDvar("r_specularcolorscale", "2.3");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
    setDvar("sm_sunShadowScale", "0.5");
    setDvar("r_filmTweakLightTint","0.736 1.092 1.618");
    setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
    thread sr\api\_map::createSpawn((-512, -523, 68), 90);
	
	precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("rpg_mp"); 
	precacheItem("knife_mp");
	precacheItem("m1014_mp");
	precacheItem("deserteagle_mp");
	precacheItem("saw_mp");
	precacheItem("ak47_mp");
    precacheItem("ak74u_mp");
	precacheItem("artillery_mp");
	precacheItem("m21_mp");
	precacheItem("g3_mp");
	precacheItem("colt45_silencer_mp");
	precacheItem("usp_mp");
	precacheItem("uzi_silencer_mp");
	precacheItem("winchester1200_mp");

	thread startdoor();
	thread sr_hard_sec_enter();
	thread sr_easy_sec_enter();
	thread tp_1();
	//thread acti_tp();
	thread plat1();
	thread plat2();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread sec_open();
	//thread easy_enter();
	thread easy_leave();
	thread easy_fail();
	//thread hard_enter();
	thread hard_leave();
	thread hard_fail();
	//thread music();
	//thread sg_fail();
	//thread random_wep();
	//thread knife_room();
	//thread fal_room();
	//thread shotgun_room();
	//thread sniper_room();
	//thread ele();
	//thread messages();
	//thread lol0x2();

	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");

}

addTriggerToList(name) 
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name , "targetname");
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(-351.762, -522.627, 8.1255), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("here_hard","targetname");

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
	trig = spawn("trigger_radius",(-666.751, -522.545, 8.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("here_easy","targetname");

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
messages()
{
	for(;;)
	{
	wait 2;
	iPrintLn("^2catto.exe loaded");
	wait 30;
	iPrintLn("^2Thanks to VC'Bane for das gud musik :>"); 
	wait 30;
	iPrintLn("^2blame VC'Brian for this awful map"); 
	wait 30;
	iPrintLn("^2Vistic Cat Club"); 
	wait 20;
	}
}

startdoor()
{
	door = getEnt("startdoor","targetname");
	
		door delete();
	
}

music()
{	
	level waittill("round_started");

	music = [];
	music[music.size] = "siren";
	music[music.size] = "bass";
	music[music.size] = "yuma";
	music[music.size] = "lone";
	music[music.size] = "meow";
	music[music.size] = "nyan";
	music[music.size] = "howe";

	x = randomInt(music.size);
	play = music[x];

	ambientPlay(play);
}

acti_tp()
{
	trig = getEnt("acti_tp", "targetname");
	ori = getEnt("here2", "targetname");

	trig waittill("trigger", player);
	player setOrigin(ori.origin);
	player setPlayerAngles(ori.angles);
	player thread sr_tp_safe(ori);
	trig delete();
}

tp_1()
{
	trig = getEnt("trig_tp1", "targetname");
	ori = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(ori.origin);
			player setPlayerAngles(ori.angles);
			player thread sr_tp_safe(ori);
		}
}

ele()
{
	trig = getEnt("trig_ele", "targetname");

 	while (1)
 	{
 	trig waittill("trigger", player);
  	if(isPlayer(player) && isAlive(player) && !(isdefined(player.ele)))
    {
  	iPrintLnBold("^2"+ player.name + " ^7is fokin ^6godlike");
	player braxi\_rank::giveRankXP( "", 250 );
  	player.ele = true;
	}
 	wait .05;
}
}


plat1()
{
	elev = getent("plat_1", "targetname");
	
	elev moveX (480, 0.1);
	
}

plat2()
{
	elev = getent("plat_2", "targetname");
	

	elev delete();
		
}



trap1()
{
	trap = getEnt("trap1", "targetname");
	trig = getent("trig_trap1", "targetname"); 
	
	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();
	trap delete();
}

trap2()
{
	trap = getEnt("trap2", "targetname");
	trig = getent("trig_trap2", "targetname"); 
	
	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();

	for(;;)
	{	
		wait 0.01;
		trap rotateYaw(-360, 4);
	}
	
}



trap3()
{
	trap = getEnt("trap3", "targetname");
	trig = getent("trig_trap3", "targetname"); 
	
	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();

	for(;;)
	{	
		wait 0.01;
		trap rotateYaw(-360, 5);
	}
	
}


trap4()
{
	trap = getEnt("trap4", "targetname");
	trig = getent("trig_trap4", "targetname"); 
	
	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();

	for(;;)
	{	
		wait 0.01;
		trap rotatePitch(-360, 2);
		wait 5;
	}
	
}

trap5()
{
	trap = getEnt("trap5", "targetname");
	trig = getent("trig_trap5", "targetname"); 
	
	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();

	trap moveX(200, 0.5);
	wait 3;
	trap moveX(-200, 2);	
}

trap6()
{
	trapa = getEnt("trap6a", "targetname");
	trapb = getEnt("trap6b", "targetname");
	trig = getent("trig_trap6", "targetname"); 
	
	trig setHintString("Press ^3[&&1] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();

	trapa rotatePitch(-360, 3);
	trapb rotatePitch(360, 3);
}





sec_open()
{
	trap = getEnt("sec_brush", "targetname");
	trig = getent("trig_sec", "targetname"); 

	trig waittill("trigger", player);
	
	trig delete();

	trap notSolid();	
	iPrintLn("^3meow");
}


easy_enter()
{
	trig = getEnt("easy_enter", "targetname");
	tele1 = getEnt("here_easy", "targetname");

	trig setHintString("Super Ez");

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

easy_fail()
{
	trig = getEnt("easy_f", "targetname");
	tele1 = getEnt("here_easy", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}


easy_leave()
{
	trig = getEnt("easy_leave", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_0");
		}
}



hard_enter()
{
	trig = getEnt("hard_enter", "targetname");
	tele1 = getEnt("here_hard", "targetname");

	trig setHintString("2 Hard 4 u");

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

hard_fail()
{
	trig = getEnt("hard_f", "targetname");
	tele1 = getEnt("here_hard", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}


hard_leave()
{
	trig = getEnt("hard_leave", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_1");
		}
}





secret_timer() //blades timer
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
	self.secretTimer.glowAlpha = 1;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"Time in Secret: &&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(1,0,0);

	time=70;
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


sg_fail()
{
	trig = getEnt("trig_s_fail", "targetname");
	tele1 = getEnt("sr", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.05;
			player freezeControls(0);
		}
}


random_wep()
{
	trig = getEnt("trig_brian", "targetname");

	trig setHintString("Press me ;)");

	while(1)
		{
			trig waittill("trigger", player);
			if (!isDefined(player.weap))
		{
			player iPrintLnBold("^1getting random weapon ...");
			player.weap = true;
			wait 3;
			random_weapon = [];
			random_weapon[random_weapon.size] = "m40a3_mp";
			random_weapon[random_weapon.size] = "deserteagle_mp";
			random_weapon[random_weapon.size] = "uzi_silencer_mp";
			random_weapon[random_weapon.size] = "ak74u_mp";
			random_weapon[random_weapon.size] = "artillery_mp";
			random_weapon[random_weapon.size] = "ak47_mp";
			random_weapon[random_weapon.size] = "m21_mp";
			random_weapon[random_weapon.size] = "rpg_mp";
			random_weapon[random_weapon.size] = "winchester1200_mp";
				
			x = randomInt(random_weapon.size);
				
			wep = random_weapon[x];

			player giveWeapon(wep);
			player giveMaxAmmo(wep);	
			player switchToWeapon(wep);
		}

		else
		{
			player iPrintLnBold("You already got a weapon u nab");

		}
		}
}


sniper_room()
{
	while(1)
	{
		level.trigsniper = getEnt("trig_snip","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigsniper  setHintString("^2sniper Room");
		
		level.trigsniper  waittill("trigger", player);

	
		
		level.trigknife delete();
		level.trigshotgun delete();
		level.trigfal delete();
		
		iPrintLnBold("^3"+ player.name + " ^7Choose Sniper");
		
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
		
		level.activ takeAllWeapons();

		wait 5;
		
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");

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
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 RIP");
		player = undefined;
	}
}

shotgun_room()
{
	while(1)
	{
		level.trigshotgun = getEnt("trig_shotgun","targetname");
		acti = getEnt("sg1","targetname");
		jump = getEnt("sg2","targetname");
		
		level.trigshotgun setHintString("^2Shotgun Room");
		
		level.trigshotgun waittill("trigger", player);

	
		
		level.trigknife delete();
		level.trigsniper delete();
		level.trigfal delete();
		
		iPrintLnBold("^3"+ player.name + " ^7Choose Shotgun");
		
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
		
		level.activ takeAllWeapons();

		wait 5;
		
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		level.activ giveWeapon("winchester1200_mp");
		level.activ giveMaxAmmo("winchester1200_mp");
		level.activ switchToWeapon("winchester1200_mp");
		
		player giveWeapon("winchester1200_mp");
		player giveMaxAmmo("winchester1200_mp");
		player switchToWeapon("winchester1200_mp");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 RIP");
		player = undefined;
	}
}


knife_room()
{
	while(1)
	{
		level.trigknife = getEnt("trig_knife","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigknife setHintString("^2Knife Room");
		
		level.trigknife waittill("trigger", player);

	
		
		level.trigfal delete();
		level.trigsniper delete();
		level.trigshotgun delete();
		
		iPrintLnBold("^3"+ player.name + " ^7Choose Knife");
		
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
		
		iPrintLnBold("^3" + player.name + "^7 RIP");
		player = undefined;
		
	}
}


fal_room()
{
	while(1)
	{
		level.trigfal = getEnt("trig_fal","targetname");
		acti = getEnt("s1","targetname");
		jump = getEnt("s2","targetname");
		
		level.trigfal setHintString("^2FAL Room");
		
		level.trigfal waittill("trigger", player);

		
		
		level.trigknife delete();
		level.trigsniper delete();
		level.trigshotgun delete();
		
		iPrintLnBold("^3"+ player.name + " ^7Choose FAL");
		
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
		player switchToWeapon("artillery_mp");
		
		level.activ takeAllWeapons();
		level.activ giveWeapon("artillery_mp");
		level.activ switchToWeapon("artillery_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 RIP");
		player = undefined;
		
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