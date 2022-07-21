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
	
	why you decompiled this lmao
	
	Thanks to VC'Blade for the Music Menu and Secret Timer scripts.	
	
	Thanks to Rotola for Fixing Errors.
		___    __  _       _______        
	| | / (_)__/ /_(_)___  / ___/ /__ ____ 
	| |/ / (_-< __/ / __/ / /__/ / _ `/ _ \
	|___/_/___|__/_/\__/  \___/_/\_,_/_//_/ 
	vistic-clan.net
*/
main()
{
thread sr\api\_map::createSpawn((-722, 529, 16), 359);
	maps\mp\_load::main(); 

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	visionSetNaked("mp_vacant");
	setDvar("r_drawDecals","1");
	setDvar( "r_specularcolorscale", "1" );
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
	
		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((-558, 774, 76), 60, 80, (-871, -14052, -708), 359 , "freeze", "red", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-543, 265, 76), 60, 80, (-11136, -8145, -708), 359 , "freeze", "blue", "secret_1");
	thread sr\api\_speedrun::createSecretWays("Hard Secret;Easy Secret;");
	
	precacheMenu("volpev2_music");
	
	precacheShader("drk");
	
	precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("rpg_mp"); 
	precacheItem("knife_mp");
	precacheItem("winchester1200_mp");
	precacheItem("usp_mp");
	precacheItem("colt45_mp");
	precacheItem("deserteagle_mp");
	precacheItem("uzi_silencer_mp");
	precacheItem("p90_mp");
	precacheItem("rpd_mp");
	precacheItem("saw_mp");
	precacheItem("ak47_mp");
	precacheItem("artillery_mp");
	precacheItem("dragunov_mp");

	precacheModel("playermodel_vcfox_fox");
	precacheModel("playermodel_vc_company_body");
	precacheModel("playermodel_vc_company_head");
	
	level.fox_trail = loadFX("fox/fox"); 
	
	thread teleport_1();
	thread teleport_2();
	thread teleport_3();
	thread teleport_4();
	thread teleport_5();
	thread teleport_6();
	thread teleport_7();
	thread teleport_8();
	thread teleport_9();
	thread teleport_10();
	thread teleport_11();
	thread teleport_12();
	thread teleport_13();
	thread teleport_14();
	thread teleport_15();
	// thread teleport_16();
	// thread bounce_tp_1();
	// thread bounce_tp_2();
	// thread bounce_tp_3();
	// thread bounce_tp_4();
	// thread t_room_wep();
	thread startdoor();
	//thread logo_shoot();
	//thread secret_step_1();
	thread second_area_trig();
	// thread teleport_secret_enter();
	// thread elev();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread fox_sec();
	// thread open_acti_sec();
	// thread first_place();
	// thread credit();
	// thread teleport_easy_enter();
	thread easy_fail_1();
	thread easy_fail_2();
	thread easy_fail_2a();
	thread easy_fail_2();
	thread easy_fail_3();
	thread easy_fail_4();
	thread easy_fail_5();
	thread easy_finish();
	// thread teleport_hard_enter();
	thread hard_fail_1();
	thread hard_fail_2();
	thread hard_fail_2a();
	thread hard_fail_3();
	thread hard_fail_4();
	thread hard_fail_5();
	thread hard_fail_6();
	thread hard_fail_6a();
	thread hard_fail_6b();
	thread hard_fail_6c();
	thread hard_finish();
	// thread rpg_fail_1();
	// thread rpg_fail_2();
	// thread bounce_room_sniper();
	// thread musicmenu();
	// thread bounce_room();
	// thread knife_room();
	// thread sniper_room();
	// thread shotgun_room();
	// thread rpg_room();
	// thread hop_room();
	// thread wep_room();
	// thread vip_fox();
	// thread addTestClients();
	// thread vip_fox2();
	// thread messages();
	 thread fuck_you();
	
	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");

}

addTriggerToList( name ) 
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}



credit()
{
	level waittill("round_started");
	
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 5;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.font = "objective";
		hud_clock.fontscale = 1.4;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (5,6,2);
		hud_clock.label = &"Welcome to ^2Volpe 2^7!";
		hud_clock SetPulseFX( 40, 5400, 200 );	
		wait 7;
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 5;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.font = "objective";
		hud_clock.fontscale = 1.4;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (5,6,2);
		hud_clock.label = &"Map By: ^3VC'Fox";
		hud_clock SetPulseFX( 40, 5400, 200 );	
}

messages()
{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^7Thanks To ^3VC'Blade ^7For The Music Menu!^6<3"); 
	wait 30;
	iPrintLn("^7Discord: ^3VC'Fox#8144"); 
	wait 30;
}	

startdoor()
{
	door = getEnt("startdoor","targetname");
	{
		door moveZ(-400, 5);
	}
}

second_area_trig() 
{ 
	trig = getEnt("2nd_area", "targetname"); 
 
	while(true) 
	{ 
		trig waittill ("trigger",player );
		trig delete ();
		iPrintLnBold("^2"+ player.name + " ^7Has Reached the ^2Second ^7Area^2!");	
		player braxi\_rank::giveRankXP( "", 50 );
	} 
}


first_place() 
{ 
	trig = getEnt("final_trig", "targetname"); 
 
	while(true) 
	{ 
		trig waittill ("trigger",player );
			
	} 
}




bounce_room_sniper()
{
	trig = getEnt("trig_br_sniper", "targetname");
	
	trig setHintString("Press [^2&&1^7] For R700");
	
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

t_room_wep()
{
	trig = getEnt("t_wep", "targetname");
	
	trig setHintString("Press [^2&&1^7] For Honey Badger");
	
		for(;;)
		{	
			trig waittill ("trigger",player );
			player takeAllWeapons();
			player giveWeapon("artillery_mp");
			player giveMaxAmmo("artillery_mp");
			player switchToWeapon("artillery_mp");
			wait 0.1;
		}
}


/*

 ??????    ??????   ??????     ???????????????????????????     ?????????      ??????   ???????????????????????????      ???????????????????????????  ??????          ??????????????????????????? ?????????????????????   
?????????    ????????? ?????????    ?????????    ????????? ????????????????????????????????? ?????????  ?????????    ?????????     ?????????    ????????? ?????????         ?????????    ????????? ??????????????????????????? 
?????????    ????????? ????????????   ?????????    ??????     ???????????????????????? ???????????? ?????????    ??????      ?????????    ??????  ?????????         ?????????    ????????? ?????????   ????????? 
?????????    ????????? ????????????   ?????????            ?????????   ??? ???????????? ?????????            ?????????        ?????????         ?????????    ????????? ?????????   ????????? 
?????????    ????????? ???????????? ????????????????????????????????????     ?????????     ???????????? ?????????            ?????????        ?????????       ???????????????????????????????????? ?????????   ????????? 
?????????    ????????? ?????????           ?????????     ?????????     ?????????  ?????????    ??????      ?????????    ??????  ?????????         ?????????    ????????? ?????????   ????????? 
?????????    ????????? ?????????     ??????    ?????????     ?????????     ?????????  ?????????    ?????????     ?????????    ????????? ????????????    ???   ?????????    ????????? ?????????   ????????? 
 ????????????????????????  ??????    ??????????????????????????????     ??????????????????   ??????   ???????????????????????????      ???????????????????????????  ???????????????????????????   ?????????    ??????   ??????   ??????  
                                                                        ???                                
*/

open_acti_sec()
{	
	wall = getEnt("acti_wall", "targetname");
	door = getEnt("acti_door", "targetname");
	trig = getEnt("trig_acti_door", "targetname"); 
	
	wall notSolid();

	trig setHintString("Press ^7[^2&&1^7] ^7To Open Door");
	
	trig waittill("trigger", player);

	door delete();
	trig delete();
}

bounce_tp_1()
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

bounce_tp_2()
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

bounce_tp_3()
{
	trig = getEnt("b_f_3", "targetname");
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

bounce_tp_4()
{
	trig = getEnt("b_f_4", "targetname");
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


teleport_1()
{
	trig = getEnt("tp_1", "targetname");
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

teleport_2()
{
	trig = getEnt("tp_2", "targetname");
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

teleport_3()
{
	trig = getEnt("tp_3", "targetname");
	tele1 = getEnt("here_3", "targetname");

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

teleport_4()
{
	trig = getEnt("tp_4", "targetname");
	tele1 = getEnt("here_4", "targetname");

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

teleport_5()
{
	trig = getEnt("tp_5", "targetname");
	tele1 = getEnt("here_5", "targetname");

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

teleport_6()
{
	trig = getEnt("tp_6", "targetname");
	tele1 = getEnt("here_6", "targetname");

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

teleport_7()
{
	trig = getEnt("tp_7", "targetname"); 
	tele1 = getEnt("here_4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player braxi\_rank::giveRankXP( "", 200 );
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

teleport_8()
{
	trig = getEnt("tp_8", "targetname");
	tele1 = getEnt("here_8", "targetname");

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

teleport_9() 
{
	trig = getEnt("tp_9", "targetname");
	tele1 = getEnt("here_8", "targetname");

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

teleport_10() 
{
	trig = getEnt("tp_back1", "targetname");
	tele1 = getEnt("here_10", "targetname");

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

teleport_11() 
{
	trig = getEnt("tp_back2", "targetname");
	tele1 = getEnt("here_11", "targetname");

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

teleport_12() 
{
	trig = getEnt("acti_fail", "targetname");
	tele1 = getEnt("here_12", "targetname");

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

teleport_13()
{
	trig = getEnt("s_f_1", "targetname");
	tele1 = getEnt("s_r_1", "targetname");

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

teleport_14()
{
	trig = getEnt("s_f_2", "targetname");
	tele1 = getEnt("s_r_2", "targetname");

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

teleport_15()
{
	trig = getEnt("t_f_1", "targetname");
	tele1 = getEnt("t_r_1", "targetname");

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

teleport_16()
{
	trig = getEnt("t_f_2", "targetname");
	tele1 = getEnt("t_r_2", "targetname");

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

teleport_secret_enter() 
{
	trig = getEnt("trig_secret_enter", "targetname");
	tele1 = getEnt("here_9", "targetname");

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

teleport_easy_enter() //enter easy secret
{
	trig = getEnt("easy_enter", "targetname");
	tele1 = getEnt("easy_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer_easy();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

easy_fail_1() 
{
	trig = getEnt("easy_f_1", "targetname");
	tele1 = getEnt("easy_r_1", "targetname");

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

easy_fail_2() 
{
	trig = getEnt("easy_f_2", "targetname");
	tele1 = getEnt("easy_r_2", "targetname");

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

easy_fail_2a() 
{
	trig = getEnt("easy_f_2a", "targetname");
	tele1 = getEnt("easy_r_2", "targetname");

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

easy_fail_3() 
{
	trig = getEnt("easy_f_3", "targetname");
	tele1 = getEnt("easy_r_3", "targetname");

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

easy_fail_4() 
{
	trig = getEnt("easy_f_4", "targetname");
	tele1 = getEnt("easy_r_4", "targetname");

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

easy_fail_5() 
{
	trig = getEnt("easy_f_5", "targetname");
	tele1 = getEnt("easy_r_5", "targetname");

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

rpg_fail_1() 
{
	trig = getEnt("rpg_f_1", "targetname");
	tele1 = getEnt("rpg_1", "targetname");

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

rpg_fail_2() 
{
	trig = getEnt("rpg_f_2", "targetname");
	tele1 = getEnt("rpg_2", "targetname");

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

easy_finish() //finish easy secret
{
	trig = getEnt("easy_finish", "targetname");
	tele1 = getEnt("here_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player braxi\_rank::giveRankXP( "", 250 );
			iPrintLnBold("^2"+ player.name + " ^7Has Finished the ^5Easy ^7Secret^5!");
			player notify("easy_secret_done");
			player.secretTimer destroy();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player thread sr\api\_speedrun::finishWay("secret_1");
		}
}

secret_timer_easy() //VC'Blades Timer
{
	self endon("easy_secret_done");
	

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
        self.secretTimer.label = &"^7Time in Secret: ^2&&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(5,6,2);

	time=90;
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

secret_timer_hard() //VC'Blades Timer
{
	self endon("hard_secret_done");
	

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
        self.secretTimer.label = &"^7Time in Secret: ^2&&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(5,6,2);

	time=180;
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


teleport_hard_enter()
{
	trig = getEnt("hard_enter", "targetname");
	tele1 = getEnt("hard_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer_hard();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

hard_fail_1() 
{
	trig = getEnt("hard_f_1", "targetname");
	tele1 = getEnt("hard_r_1", "targetname");

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

hard_fail_2() 
{
	trig = getEnt("hard_f_2", "targetname");
	tele1 = getEnt("hard_r_2", "targetname");

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

hard_fail_3() 
{
	trig = getEnt("hard_f_3", "targetname");
	tele1 = getEnt("hard_r_3", "targetname");

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

hard_fail_2a() 
{
	trig = getEnt("hard_f_2a", "targetname");
	tele1 = getEnt("hard_r_2", "targetname");

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

hard_fail_4() 
{
	trig = getEnt("hard_f_4", "targetname");
	tele1 = getEnt("hard_r_4", "targetname");

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

hard_fail_5() 
{
	trig = getEnt("hard_f_5", "targetname");
	tele1 = getEnt("hard_r_5", "targetname");

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

hard_fail_6() 
{
	trig = getEnt("hard_f_6", "targetname");
	tele1 = getEnt("hard_r_6", "targetname");

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

hard_fail_6a() 
{
	trig = getEnt("hard_f_6a", "targetname");
	tele1 = getEnt("hard_r_6", "targetname");

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

hard_fail_6b() 
{
	trig = getEnt("hard_f_6b", "targetname");
	tele1 = getEnt("hard_r_6", "targetname");

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

hard_fail_6c() 
{
	trig = getEnt("hard_f_6c", "targetname");
	tele1 = getEnt("hard_r_6", "targetname");

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

hard_finish() //Hard Secret End
{
	trig = getEnt("hard_finish", "targetname");
	tele1 = getEnt("here_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player braxi\_rank::giveRankXP( "", 1200 );
			iPrintLnBold("^2"+ player.name + " ^7Has Finished the ^1Hard ^7Secret^1!");	
			player notify("hard_secret_done");
			player.secretTimer destroy();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
}

vip_fox()
{
	trig = getEnt("vip_fox", "targetname");

	while(1)
	{
		trig waittill("trigger", player);

		if(player getGuid() == "5dcce639cbef05e4f9b739a0ab61c6e4" || player getGuid() == "fe617fc1fe33e942860a640345d2dde4" || player getGuid() == "2310346615434407089" || player getGuid() == "ba40e48a86db0e25c40499162d0c6e0e") 
		{
			player.vip = true;
			iPrintLn("^3>> ^7Welcome Map Creator: ^2VC'Fox ^3<<");
			player giveWeapon("winchester1200_mp");
			player giveMaxAmmo("winchester1200_mp");
			player giveWeapon("artillery_mp");
			player giveMaxAmmo("artillery_mp");
			player switchToWeapon("artillery_mp");
			player detachAll();
			player setModel("playermodel_vc_company_body");
			player attach("playermodel_vc_company_head");
			player thread vip_trail();

			if (!isDefined(player.xp_give))
			{
				player.xp_give = true;
				player braxi\_rank::giveRankXP( "", 500 );
			}
		}
		else
		{
			player.vip = false;
		}
		wait 1;
	}
}

vip_fox2()
{
	trig = getEnt("vip_2", "targetname");

	while(1)
	{
		trig waittill("trigger", player);

		if(player getGuid() == "5dcce639cbef05e4f9b739a0ab61c6e4" || player getGuid() == "fe617fc1fe33e942860a640345d2dde4" || player getGuid() == "2310346615434407089" || player getGuid() == "ba40e48a86db0e25c40499162d0c6e0e") 
		{
			player.vip = true;
			iPrintLn("^3>> ^7Welcome Map Creator: ^2VC'Fox ^3<<");
			player giveWeapon("winchester1200_mp");
			player giveMaxAmmo("winchester1200_mp");
			player giveWeapon("artillery_mp");
			player giveMaxAmmo("artillery_mp");
			player switchToWeapon("artillery_mp");
			player detachAll();
			player setModel("playermodel_vc_company_body");
			player attach("playermodel_vc_company_head");
			player thread vip_trail();

			if (!isDefined(player.xp_give))
			{
				player.xp_give = true;
				player braxi\_rank::giveRankXP( "", 500 );
			}
		}
		else
		{
			player.vip = false;
		}
		wait 1;
	}
}

vip_trail()
{
    self notify("vip_trail");
    self endon("vip_trail");

    while(isAlive(self))
    {
        playFX(level.fox_trail, self.origin);
        wait 0.1;
    }
}


logo_shoot()
{
	for(;;)
	{
	trig = getEnt("logo_shoot", "targetname");
	trig waittill("trigger", player);
	player iPrintLnBold("^7Map Made By: ^2VC'Fox");
	wait 0.1;
	}
}

secret_step_1()
{
	trig = getEnt("sec_step_1","targetname");
	trig waittill ("trigger", player);
	
	iPrintLn("^2Step 1");
	thread secret_step_2();
}


secret_step_2()
{
	trig = getEnt("sec_step_2","targetname");
	trig waittill ("trigger", player);
	
	iPrintLn("[^2Secret Opened^7]");
	thread secret_open();
}

secret_open()
{	
	brush = getEnt("secret_enter", "targetname");
	trig_tp = getEnt("trig_secret_enter", "targetname");	
	
	trig_tp enableLinkTo ();
    trig_tp linkTo (brush);
	brush moveZ(144, 2);
}



elev()
{
	elev = getEnt("elev", "targetname");
	
	for(;;)
	{
	wait 0.1;
	elev moveX (832, 1);
	wait 4;
	elev moveX (-832, 1);
	wait 4;
	}	
}

fox_sec()
{
	trig = getEnt("fox_sec", "targetname"); 

	trig setHintString("^7=^2^.^^7=^7");
	
	trig waittill("trigger", player);
	player freezeControls(1);
	player iPrintLnBold("VC'Fox Gives You Some XP ^6:o");
	wait 2;
	player freezeControls(0);
	player braxi\_rank::giveRankXP( "", 200 );
	player iPrintLnBold("^3+200 ^7XP");
	
	trig delete();
}

trap1()
{
	brush1 = getEnt("trap1", "targetname");
	brush2 = getEnt("trap1a", "targetname");
	trig = getEnt("trig_trap1", "targetname"); 

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	brush1 moveY(140, 0.3);
	brush2 moveY(-140, 0.3);
	wait 3;
	brush1 moveY(-140, 0.5);
	brush2 moveY(140, 0.5);
	trig delete();
}


trap2()
{
	brush = getEnt("trap2", "targetname");
	trig = getEnt("trig_trap2", "targetname"); 

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	brush moveZ(-150, 0.5);
	wait 5;
	brush moveZ(150, 0.5);
	trig delete();
}

trap3()
{
	brush = getEnt("trap3", "targetname");
	trig = getEnt("trig_trap3", "targetname"); 

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );
	
	brush delete();
	trig delete();
}

trap4()
{
	brush1 = getEnt("trap4", "targetname");
	brush2 = getEnt("trap4a", "targetname");
	trig = getEnt("trig_trap4", "targetname");
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	brush1 rotateRoll(360, 2);
	brush2 rotateRoll(-360, 2);
	wait 4;
	}
}


trap5()
{ 
	trap = getEnt("trap5", "targetname");
	trig = getEnt("trig_trap5", "targetname"); 
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	trap rotateRoll(720, 1);
	wait 3;
	}
	
}

trap6()
{ 
	trap = getEnt("trap6", "targetname");
	trig = getEnt("trig_trap6", "targetname"); 
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	trap moveZ(-220, 0.2);
	wait 1;
	trap moveZ(220, 0.2);
	wait 2;
	trap moveZ(-220, 0.1);
	wait 1;
	trap moveZ(220, 0.2);
	wait 4;
	}
	
}

trap7()
{ 
	brush1 = getEnt("trap7", "targetname");
	brush2 = getEnt("trap7a", "targetname");
	
	trig = getEnt("trig_trap7", "targetname"); 
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	brush1  moveY(192, 0.5);
	brush2  moveY(-192, 0.5);
	wait 0.6;
	brush1  moveY(-192, 0.5);
	brush2  moveY(192, 0.5);
	wait 0.6;
	}
	
}

trap8()
{ 
	brush = getEnt("trap8", "targetname");
	
	trig = getEnt("trig_trap8", "targetname"); 
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 50 );

	brush delete();
	trig delete();
}

trap9() 
{
	brush = getEnt("trap9", "targetname");
	brush1 = getEnt("trap9a", "targetname");
	
	trig = getEnt("trig_trap9", "targetname"); 
	
	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 50 );
	
	trig delete();
	
	{
		for(;;)
		{
		brush rotateTo ((0, 0, -80), 2);
		brush1 rotateTo ((0, 0, 80), 2);
		wait 3;
		brush rotateTo ((0, 0, 0), 1);
		brush1 rotateTo ((0, 0, 0), 1);
		wait 4;
		}
	}
}

musicmenu()
{
	trig = getEnt("music_menu","targetname");
	trig setHintString("Press [^2&&1^7] ^7to Select Music");

	trig waittill("trigger",who);
	if(!isdefined(level.volpe2_music_chosen))
	{
		level.volpe2_music_chosen = true;

		who thread onmenuresponse();
		who openMenu("volpev2_music");
	}
}

onmenuresponse()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("menuresponse",menu,response);

		if(menu == "volpev2_music")
		{
			switch(response)
			{
				case "0":
					thread play_ambient_song(0,"Andy Leech -  Voice Of The Forest");
					break;
				case "1":
					thread play_ambient_song(1,"Asteroids - Never Let You Go");
					break;
				case "2":
					thread play_ambient_song(2,"Muzzy - Feeling Stronger");
					break;
				case "3":
					thread play_ambient_song(3,"Korn - Narcissistic Cannibal");
					break;
				case "4":
					thread play_ambient_song(4,"Azaleh - Endeavour");
					break;
				case "5":
					thread play_ambient_song(5,"Going Quantum x Psychic Type - Rare");
					break;
				case "6":
					thread play_ambient_song(6,"Travis Scott - Antidote");
					break;
				case "7":
					thread play_ambient_song(7,"Laszlo - Airglow");
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
			ambientPlay("forest");	
			break;
		case 1:	
			ambientPlay("astroidz");	
			break;
		case 2:	
			ambientPlay("muzzy");	
			break;
		case 3:	
			ambientPlay("korn");	
			break;
		case 4:	
			ambientPlay("az");	
			break;
		case 5:	
			ambientPlay("rare");	
			break;
		case 6:	
			ambientPlay("travis");	
			break;
		case 7:	
			ambientPlay("airglow");	
			break;
	}

	thread now_playing(name);
}

now_playing(name)
{
	level.nowplaying = newHudElem();
	level.nowplaying.x = 0;
	level.nowplaying.y = -5;
	level.nowplaying.horzAlign = "center";	
	level.nowplaying.vertAlign = "bottom";
	level.nowplaying.alignX = "center"; 
	level.nowplaying.alignY = "bottom"; 
	level.nowplaying.archived = false;
	level.nowplaying.alpha = 0;
	level.nowplaying.fontScale = 1.5;
	level.nowplaying.hidewheninmenu = true;
	level.nowplaying.glowAlpha = 0;
	level.nowplaying.label = &"Music: ^2";
	level.nowplaying settext(name);

	if(isdefined(level.randomcolor))
		level.nowplaying.glowcolor=level.randomcolor;
	else 
		level.nowplaying.glowcolor = (1,1,0);

	level.nowplaying fadeovertime(.5);
	wait .5;
	level.nowplaying.alpha = 1;
	wait 8;
	level.nowplaying fadeovertime(.5);
	wait .5;
	level.nowplaying.alpha = 0;
}

bounce_room()
{
	while(1)
	{
		level.trigbounce = getEnt("bounce_room","targetname");
		acti = getEnt("b_r_1","targetname");
		jump = getEnt("b_r_2","targetname");
		
		level.trigbounce setHintString("^2Bounce Room");
		
		level.trigbounce waittill("trigger", player);
		
		level.trigknife delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigrpg delete();
		level.trighop delete();
		level.trigshotgun delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Bounce Room";
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

knife_room()
{
	while(1)
	{
		level.trigknife = getEnt("knife_room","targetname");
		acti = getEnt("k_1","targetname");
		jump = getEnt("k_2","targetname");
		
		level.trigknife setHintString("^2Fox Room");
		
		level.trigknife waittill("trigger", player);
		
		level.trigbounce delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigrpg delete();
		level.trigshotgun delete();
		level.trighop delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Fox Room";
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
		
		player detachAll();
		player setModel("playermodel_vcfox_fox");
		player setClientDvar("cg_thirdperson","1");
		player takeAllWeapons();
		player giveWeapon("dog_mp");
		player switchToWeapon("dog_mp");
		
		level.activ detachAll();
		level.activ setModel("playermodel_vcfox_fox");
		level.activ setClientDvar("cg_thirdperson","1");
		level.activ takeAllWeapons();
		level.activ giveWeapon("dog_mp");
		level.activ switchToWeapon("dog_mp");

		wait 5;
		player iPrintLnBold("^7BITE!");
		level.activ iPrintLnBold("^7BITE!");
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Is too cute and Died! ^2=^.^=");
		wait 1;
		iPrintLnBold("^7Fox Room Open!");
		player = undefined;
		
	}
}

hop_room()
{
	while(1)
	{
		level.trighop = getEnt("hop_room","targetname");
		acti = getEnt("t_r_1","targetname");
		jump = getEnt("t_r_2","targetname");
		
		level.trighop setHintString("^2Hop Room");
		
		level.trighop waittill("trigger", player);
		
		level.trigbounce delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigknife delete();
		level.trigrpg delete();
		level.trigshotgun delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Hop Room";
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
		iPrintLnBold("^7Hop Room Open!");
		player = undefined;
		
	}
}

sniper_room()
{
	while(1)
	{
		level.trigsniper = getEnt("sniper_room","targetname");
		acti = getEnt("s_r_1","targetname");
		jump = getEnt("s_r_2","targetname");
		
		level.trigsniper setHintString("^2Sniper Room");
		
		level.trigsniper waittill("trigger", player);
		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigshotgun delete();
		level.trighop delete();
		level.trigrpg delete();
		level.trigwep delete();
		
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

shotgun_room()
{
	while(1)
	{
		level.trigshotgun = getEnt("shotgun_room","targetname");
		acti = getEnt("sg_1","targetname");
		jump = getEnt("sg_2","targetname");
		
		level.trigshotgun setHintString("^2Shotgun Room");
		
		level.trigshotgun waittill("trigger", player);
		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigsniper delete();
		level.trighop delete();
		level.trigwep delete();
		level.trigrpg delete();
		
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
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7Shotgun Room Open!");
		player = undefined;
		
	}
}

wep_room()
{
	while(1)
	{
		level.trigwep = getEnt("wep_room","targetname");
		acti = getEnt("wep_1","targetname");
		jump = getEnt("wep_2","targetname");
		
		level.trigwep setHintString("^2Random Weapon Room");
		
		level.trigwep waittill("trigger", player);
		
		level.trigknife delete();
		level.trigsniper delete();
		level.trigbounce delete();
		level.trigrpg delete();
		level.trighop delete();
		level.trigshotgun delete();
		
		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Random Weapon Room";
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
		
		random_weapon = [];
		random_weapon[random_weapon.size] = "winchester1200_mp";
		random_weapon[random_weapon.size] = "usp_mp";
		random_weapon[random_weapon.size] = "colt45_mp";
		random_weapon[random_weapon.size] = "deserteagle_mp";
		random_weapon[random_weapon.size] = "uzi_silencer_mp";
		random_weapon[random_weapon.size] = "p90_mp";
		random_weapon[random_weapon.size] = "rpd_mp";
		random_weapon[random_weapon.size] = "saw_mp";
		random_weapon[random_weapon.size] = "artillery_mp";
		random_weapon[random_weapon.size] = "dragunov_mp";
			
		x = randomInt(random_weapon.size);
			
		wep = random_weapon[x];
			
		player takeAllWeapons();
		player giveWeapon(wep);
		player giveMaxAmmo(wep);	
		player switchToWeapon(wep);
		
		level.activ takeAllWeapons();
		level.activ giveWeapon(wep);
		level.activ giveMaxAmmo(wep);
		level.activ switchToWeapon(wep);

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


rpg_room()
{
	while(1)
	{
		level.trigrpg = getEnt("rpg_room","targetname");
		acti = getEnt("rpg_1","targetname");
		jump = getEnt("rpg_2","targetname");
		
		level.trigrpg setHintString("^2RPG Room");
		
		level.trigrpg waittill("trigger", player);
		
		level.trigknife delete();
		level.trigbounce delete();
		level.trigsniper delete();
		level.trighop delete();
		level.trigshotgun delete();
		level.trigwep delete();
		
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
		
		level.activ takeAllWeapons();
		
		level.activ giveWeapon("rpg_mp");
		level.activ giveMaxAmmo("rpg_mp");
		level.activ switchToWeapon("rpg_mp");
		
		player giveWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		player switchToWeapon("rpg_mp");

		wait 5;
		
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");
		
		
		player freezeControls(0);
		level.activ freezeControls(0);
	
		player thread rpg_ammo();
		level.activ thread rpg_ammo();
	
		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;
		
		iPrintLnBold("^3" + player.name + "^7 Has Died!");
		wait 1;
		iPrintLnBold("^7RPG Room Open!");
		player = undefined;
		
	}
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

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


fuck_you()
{
	for(;;)
{
	level waittill("player_spawn", player);
	username = player.name;
	if( isSubStr( toLower(username), toLower("brahmi") ) || username == "CAR DarkSTEP" || username == "Sr Brahmi" || username == "pizzaman") 
{
	player.fuu = true;
	player thread dark_hub();
	player freezeControls(1);
	wait 5;
	player suicide();
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	wait 0.01;
}
    else
{
	player.fuu = false;
	wait 0.1;
}
}
}


dark_hub()
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ("drk", 640, 480); 
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
}

	

