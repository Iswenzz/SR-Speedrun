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

	Thanks to VC'Blade for the Secret Timer script.

	probs last Version of volpe.
		___    __  _       _______
	| | / (_)__/ /_(_)___  / ___/ /__ ____
	| |/ / (_-< __/ / __/ / /__/ / _ `/ _ \
	|___/_/___|__/_/\__/  \___/_/\_,_/_//_/
	vistic-clan.net
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

	setdvar("r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);

	thread sr\api\_map::createSpawn((-521,390,68),89);
	thread sr\api\_speedrun::createTeleporter((-780, 555, 68), 60, 80, (-5637, 1157, 260), 89 , "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-784, 350, 68), 60, 80, (-5637, 1157, 260), 89 , "freeze", "red", "secret_1");
	thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	precacheModel("playermodel_vcfox_fox");
	preCacheModel("body_mp_sas_urban_sniper");
	precacheItem("dog_mp");
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("deserteagle_mp");
	precacheItem("winchester1200_mp");
	precacheItem("knife_mp");
	preCacheItem("deserteagle_mp");
    preCacheItem("ak74u_mp");
	preCacheItem("g3_mp");
	precacheItem("artillery_mp");

	thread startdoor();
 //   thread messages();
 //   thread vc_logo_shoot();
 //   thread map_logo_shoot();
    //thread vcfox_logo_shoot();
 //   thread platform_1();
 //   thread platform_2();
 //   thread platform_3();
 //   thread platform_4();
    thread ele_sec();
    thread teleport_1();
    thread teleport_2();
//    thread ele_ak74u();
 //   thread trap1();
 //   thread trap2();
//	thread trap3();
//	thread trap4();
//	thread trap5();
//	thread trap6();
//	thread trap7();
//	thread trap8();
//	thread acti_teleport_1();
//	thread acti_teleport_2();
 //   thread brush_help();
    thread second_area_trig();
//	thread spike_trap();
//	thread bounce_room_sniper();
//	thread race_room_wep();
//	thread music_box();
	thread sec_fail_1();
	thread sec_fail_2();
	thread sec_fail_3();
	thread sec_fail_4();
	thread sec_fail_5();
	thread sec_fail_6();
	thread sec_fail_7();
	thread sec_fail_8();
	thread sec_fail_9();
	thread sec_fail_10();
	thread sec_fail_11();
	thread sec_fail_12();
	thread sec_fail_13();
	thread sec_fail_14();
	thread sec_hard_finish();
	thread sec_easy_finish();
//	thread sec_enter();
//	thread fox();
//	thread fox_end();
//	thread vistic();
//	thread step1();
	thread sec_ele_finish();
	thread ele_open();
//	thread bounce_fail_1();
//	thread bounce_fail_2();
//	thread race_fail_1();
//	thread race_fail_2();
//	thread knife_room();
//	thread bounce_room();
//	thread race_room();
//	thread sniper_room();
//	thread karma_room();
//	thread shotgun_room();
//	thread fake();
//	thread credit();

	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}


startdoor()
{
	ele = getEnt("ele1","targetname");
	door = getEnt("startdoor","targetname");
	{
	ele hide();
    door delete();
	}
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
		hud_clock.label = &"Welcome to ^2Volpe 3^7!";
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
	for(;;)
	{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^7Made For Vistic-Clan");
	wait 30;
	iPrintLn("^7Discord: ^3VC'Fox#0001");
	wait 30;
	}
}

music_box()
{
	trig = getEnt("trig_music", "targetname");
    brush1 = getEnt("bs_1", "targetname");
    brush2 = getEnt("bs_2", "targetname");

    brush2 hide();

	trig setHintString("^2> ^7Music ^2<");

	trig waittill("trigger", player);

    brush1 delete();
    brush2 show();

	ambientStop();

	music = [];
	music[music.size] = "daybreak";
	music[music.size] = "ghost";
	music[music.size] = "etude";
	music[music.size] = "face";
	music[music.size] = "take";
	music[music.size] = "ton";
	music[music.size] = "voices";

	x = randomInt(music.size);
	play = music[x];

	ambientPlay(play);
	trig delete();
}



fake()
{
	trig = getEnt("trig_fake", "targetname");

	trig setHintString("^2?");

	trig waittill("trigger", player);

	trig delete();

	player freezeControls(1);
	player iPrintLnBold("^2No secret here lawl");
	wait 2;
	player freezeControls(0);
}


ele_open()
{
	trig = getEnt("trig_clip", "targetname");
	clip = getEnt("clip_brush1", "targetname");
	brush = getEnt("brush1", "targetname");

	trig waittill("trigger", player);

	trig delete();
	clip delete();
	brush notSolid();

	player thread maps\mp\gametypes\_hud_message::oldNotifyMessage("^2u wot");
}


vc_logo_shoot()
{
	while(1)
	{
	trig = getEnt("trig_vc", "targetname");
	trig waittill("trigger", player);
	player iPrintLnBold("^3Vistic Discord: ^7discord.gg/JKwXV3h");
	wait 0.1;
	}
}

map_logo_shoot()
{
	while(1)
	{
	trig = getEnt("trig_logo", "targetname");
	trig waittill("trigger", player);
	player iPrintLnBold("^7Map Made By: ^2VC'Fox");
	wait 0.1;
	}
}

vcfox_logo_shoot()
{

	trig = getEnt("trig_logo_vcfox", "targetname");
	trig waittill("trigger", player);
	trig delete();
	player iPrintLnBold("^7fine take it lmao");
	wait 1;
	player giveWeapon("artillery_mp");
	player giveMaxAmmo("artillery_mp");
	player switchToWeapon("artillery_mp");
}


platform_1()
{
	trig = getEnt("trig_plat1", "targetname");
    brush1 = getEnt("plat1", "targetname");
    brush2 = getEnt("plat1_a", "targetname");

    brush2 hide();

    trig waittill("trigger", player);

    brush2 playSound("ui_mp_suitcasebomb_timer");

    brush1 delete();
    brush2 show();

    trig delete();
}

platform_2()
{
	trig = getEnt("trig_plat2", "targetname");
    brush1 = getEnt("plat2", "targetname");
    brush2 = getEnt("plat2_a", "targetname");

    brush2 hide();

    trig waittill("trigger", player);

    brush2 playSound("ui_mp_suitcasebomb_timer");

    brush1 delete();
    brush2 show();

    trig delete();
}

platform_3()
{
	trig = getEnt("trig_plat3", "targetname");
    brush1 = getEnt("plat3", "targetname");
    brush2 = getEnt("plat3_a", "targetname");

    brush2 hide();

    trig waittill("trigger", player);

    brush2 playSound("ui_mp_suitcasebomb_timer");

    brush1 delete();
    brush2 show();

    trig delete();
}


platform_4()
{
	trig = getEnt("trig_plat4", "targetname");
    brush1 = getEnt("plat4", "targetname");
    brush2 = getEnt("plat4_a", "targetname");
    door = getEnt("end_door", "targetname");

    brush2 hide();

    trig waittill("trigger", player);

    brush2 playSound("ui_mp_suitcasebomb_timer");

    brush1 delete();
    brush2 show();
    wait 0.5;
    door delete();
    trig delete();

}


ele_sec()
{
	trig = getEnt("trig_ele", "targetname");

 	while (1)
 	{
 	trig waittill("trigger", player);
  	if(isPlayer(player) && isAlive(player) && !(isdefined(player.ele)))
    {
  	iPrintLnBold("^2"+ player.name + " ^7Completed The ^1Elevator^7!");
	player braxi\_rank::giveRankXP( "", 250 );
  	player.ele = true;
	}
 	wait .05;
}
}

acti_teleport_1()
{
	trig = getEnt("trig_acti_tp1", "targetname");
	tele1 = getEnt("acti_here1", "targetname");

    trig setHintString("Press [^2&&1^7] To Teleport 2nd Area");

    trig waittill("trigger", player);
    player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    player freezeControls(1);
    wait 0.01;
    player freezeControls(0);
    trig delete();
}

acti_teleport_2()
{
	trig = getEnt("trig_acti_tp2", "targetname");
	tele1 = getEnt("here3", "targetname");

    trig setHintString("Press [^2&&1^7] To Teleport To End");

    trig waittill("trigger", player);
    player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    player freezeControls(1);
    wait 0.01;
    player freezeControls(0);
    trig delete();
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

race_room_wep()
{
	trig = getEnt("trig_race_wep", "targetname");

	trig setHintString("Press [^2&&1^7] For G3");

		for(;;)
		{
		trig waittill ("trigger",player );
		player takeAllWeapons();
		player giveWeapon("g3_mp");
		player giveMaxAmmo("g3_mp");
		player switchToWeapon("g3_mp");
		wait 0.1;
		}
}

sec_fail_1()
{
	trig = getEnt("sec_f_1", "targetname");
	tele1 = getEnt("sec_here", "targetname");

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

sec_fail_2()
{
	trig = getEnt("sec_f_2", "targetname");
	tele1 = getEnt("sec_here", "targetname");

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

sec_fail_3()
{
	trig = getEnt("sec_f_3", "targetname");
	tele1 = getEnt("h_f_1", "targetname");

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

sec_fail_4()
{
	trig = getEnt("h_r_1", "targetname");
	tele1 = getEnt("h_f_1", "targetname");

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

sec_fail_5()
{
	trig = getEnt("h_r_2", "targetname");
	tele1 = getEnt("h_f_1", "targetname");

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

sec_fail_6()
{
	trig = getEnt("h_f_4", "targetname");
	tele1 = getEnt("h_r_4", "targetname");

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

sec_fail_7()
{
	trig = getEnt("h_f_5", "targetname");
	tele1 = getEnt("h_r_5", "targetname");

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

sec_fail_8()
{
	trig = getEnt("h_f_6", "targetname");
	tele1 = getEnt("h_r_6", "targetname");

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

sec_fail_9()
{
	trig = getEnt("h_f_7", "targetname");
	tele1 = getEnt("h_r_7", "targetname");

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


sec_fail_10()
{
	trig = getEnt("e_f_1", "targetname");
	tele1 = getEnt("e_r_1", "targetname");

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

sec_fail_11()
{
	trig = getEnt("e_f_2", "targetname");
	tele1 = getEnt("e_r_1", "targetname");

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

sec_fail_12()
{
	trig = getEnt("e_f_3", "targetname");
	tele1 = getEnt("e_r_3", "targetname");

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

sec_fail_13()
{
	trig = getEnt("e_f_4", "targetname");
	tele1 = getEnt("e_r_3", "targetname");

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

sec_fail_14()
{
	trig = getEnt("e_f_5", "targetname");
	tele1 = getEnt("e_r_5", "targetname");

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

bounce_fail_1()
{
	trig = getEnt("b_f_1", "targetname");
	tele1 = getEnt("b_1", "targetname");

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

bounce_fail_2()
{
	trig = getEnt("b_f_2", "targetname");
	tele1 = getEnt("b_2", "targetname");

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


race_fail_1()
{
	trig = getEnt("r_f_1", "targetname");
	tele1 = getEnt("r_1", "targetname");

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


race_fail_2()
{
	trig = getEnt("r_f_2", "targetname");
	tele1 = getEnt("r_2", "targetname");

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



sec_enter()
{
	trig = getEnt("trig_sec", "targetname");
	tele1 = getEnt("sec_here", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Enter Secret");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread secret_timer();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

sec_hard_finish()
{
	trig = getEnt("hard_end", "targetname");
	tele1 = getEnt("here2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
		    player thread sr\api\_speedrun::finishWay("secret_1");
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

sec_easy_finish()
{
	trig = getEnt("easy_finish", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_0");
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);

		}
}

sec_ele_finish()
{
	trig = getEnt("trig_ele2", "targetname");
	tele1 = getEnt("here2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player braxi\_rank::giveRankXP( "", 1500 );
			iPrintLnBold("^2"+ player.name + " ^7Completed The Hidden ^1Elevator^7!");
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

secret_timer() //VC'Blades Timer
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
	self.secretTimer.label = &"^7Time in Secret: ^2&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else
	self.secretTimer.glowColor=(5,6,2);

	time=100;
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

teleport_1()
{
	trig = getEnt("tp_1", "targetname");
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

fox()
{
	trig = getEnt("trig_fox", "targetname");

	trig setHintString("^7=^2^.^^7=^7");

	trig waittill("trigger", player);

	trig delete();

	x = randomInt(8);
	if(x == 0)
    {
	iPrintLnBold("^2"+ player.name + " ^7is a Fox!");
	player.isFox = true;
	player detachAll();
	player setModel("playermodel_vcfox_fox");
	player takeAllWeapons();
	player giveWeapon("dog_mp");
	player switchToWeapon("dog_mp");
	player setClientDvar("cg_thirdperson","1");
	player waittill("fox_end");
	player.isFox = false;
	player detachAll();
	player setModel("body_mp_sas_urban_sniper");
	player setClientDvar("cg_thirdperson","0");
	player takeAllWeapons();
	player giveWeapon("knife_mp");
	player switchToWeapon("knife_mp");
	player iPrintLn("^3Fox PlayerModel removed!");
	}
	if(x == 1)
    {
		player iPrintLnBold("Not this time >:D");
	}
	if(x == 2)
    {
		player freezeControls(1);
		player iPrintLnBold("VC'Fox Gives You Some XP ^6:o");
		wait 2;
		player freezeControls(0);
		player braxi\_rank::giveRankXP( "", 200 );
		player iPrintLnBold("^3+200 ^7XP");
	}
	if(x == 3)
	{
		player iPrintLnBold("VC'Fox Gives You A Weapon");
		player giveWeapon("winchester1200_mp");
		player switchToWeapon("winchester1200_mp");
		player giveMaxAmmo("winchester1200_mp");
	}
	if(x == 4)
    {
		player iPrintLnBold("unlucky m8 :(");
	}
	if(x == 5)
    {
		player iPrintLnBold("Nope.");
	}
	if(x == 6)
    {

		player endon("death");
		player iPrintLnBold("^2Super^7-Speed mode ^3activated^7!!");
		player sr\api\_player::setPlayerSpeedScale( 2.5 );
		player waittill ("death");
		player sr\api\_player::setPlayerSpeedScale (1.0);
	}
	if(x == 7)
    {
		player iPrintLnBold("VC'Fox Gives You A Extra Life!");
		player braxi\_mod::givelife();
	}
}

fox_end()
{
	trig = getEnt("endmap_trig", "targetname");

	while(1)
	{
		trig waittill("trigger", player);
		player notify("fox_end");
	}
}

vistic()
{
	trig = getEnt("trig_vip", "targetname");

	while(1)
	{
		trig waittill("trigger", player);

		if(player getGuid() == "5dcce639cbef05e4f9b739a0ab61c6e4" || player getGuid() == "2310346615434407089")
		{
			player.vip = true;
			iPrintLn("^3>> ^7Welcome Map Creator: ^2VC'Fox ^3<<");
			player giveWeapon("artillery_mp");
			player giveMaxAmmo("artillery_mp");
			player switchToWeapon("artillery_mp");
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


teleport_2()
{
	trig = getEnt("tp_2", "targetname");
	tele1 = getEnt("here2", "targetname");

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


step1()
{
	trig = getEnt("trig_step1", "targetname");
	model = getEnt("fox1", "targetname");
	model2 = getEnt("fox2", "targetname");

	model hide();
	model2 hide();

	trig waittill("trigger", player);

	trig delete();
	model show();
	iPrintLn("^21");
	player thread step2();
}

step2()
{
	trig = getEnt("trig_step2", "targetname");
	model2 = getEnt("fox2", "targetname");

	brush = getEnt("block", "targetname");

	trig waittill("trigger", player);

	trig delete();
	model2 show();
	iPrintLn("^22");
	brush delete();
	iPrintLn("^2Secret Opened!");
}

ele_ak74u()
{
	trig = getEnt("trig_ak", "targetname");

	trig setHintString("Press [^2&&1^7] For AK74u");

		for(;;)
		{
			trig waittill ("trigger",player );
			player takeAllWeapons();
			player giveWeapon("ak74u_mp");
			player giveMaxAmmo("ak74u_mp");
			player switchToWeapon("ak74u_mp");
			wait 0.1;
		}
}


brush_help()
{
	brush1 = getEnt("brush_help", "targetname");
	brush2 = getEnt("brush_die", "targetname");
    brush3 = getEnt("brush_die2", "targetname");
	trig = getEnt("trig_help", "targetname");

    brush1 hide();
    brush1 notSolid();

	trig waittill("trigger", player);

    brush1 show();
    brush1 solid();
    brush2 delete();
    brush3 delete();
    trig delete();
}

second_area_trig()
{
	trig = getEnt("2nd_area", "targetname");

	trig waittill ("trigger",player );
	trig delete ();
	iPrintLnBold("^2"+ player.name + " ^7Has Reached the ^2Second ^7Area^2!");
	player braxi\_rank::giveRankXP( "", 50 );
}


trap1()
{
	brush1 = getEnt("trap1_a", "targetname");
	brush2 = getEnt("trap1_b", "targetname");
    brush3 = getEnt("trap1_c", "targetname");
	trig = getEnt("trig_trap1", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    x = randomInt(2);
	if(x == 0)
    {
    brush1 moveZ(-200, 3);
    brush3 moveZ(-200, 3);
    wait 4;
    brush1 delete();
    brush3 delete();
    trig delete();
	}
    if(x == 1)
    {
    brush2 moveZ(-200, 3);
    brush3 moveZ(-200, 3);
    wait 4;
    brush2 delete();
    brush3 delete();
    trig delete();
	}
}

trap2()
{
	brush1 = getEnt("trap2_a", "targetname");
	brush2 = getEnt("trap2_b", "targetname");
    brush3 = getEnt("trap2_c", "targetname");
	trig = getEnt("trig_trap2", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    trig delete();
    x = randomInt(3);
	if(x == 0)
    {
    brush1 delete();
    brush3 delete();
	}
    if(x == 1)
    {
    brush2 delete();
    brush1 delete();
	}
    if(x == 2)
    {
    brush3 delete();
    brush2 delete();
	}
}

trap3()
{
	trig = getEnt("trig_trap3", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    trig delete();
    x = randomInt(3);
	if(x == 0)
    {
    player thread trap3_a();
    player thread trap3_c();
	}
    if(x == 1)
    {
  	player thread trap3_b();
    player thread trap3_c();
	}
    if(x == 2)
    {
  	player thread trap3_a();
    player thread trap3_b();
	}
}

trap3_a()
{
	trig = getEnt("trig_trap3_a","targetname");
	brush = getEnt("trap3_a", "targetname");

	trig waittill ("trigger", player);

	trig delete();
	brush moveZ(-200,0.5);
	wait 2;
	brush delete();
}

trap3_b()
{
	trig = getEnt("trig_trap3_b","targetname");
	brush = getEnt("trap3_b", "targetname");

	trig waittill ("trigger", player);

	trig delete();
	brush moveZ(-200,0.5);
	wait 2;
	brush delete();
}

trap3_c()
{
	trig = getEnt("trig_trap3_c","targetname");
	brush = getEnt("trap3_c", "targetname");

	trig waittill ("trigger", player);

	trig delete();
	brush moveZ(-200,0.5);
	wait 2;
	brush delete();
}


trap4()
{
	trig = getEnt("trig_trap4", "targetname");
	brush = getEnt("trap4", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    trig delete();
	brush delete();
}

trap5()
{
	trig = getEnt("trig_trap5", "targetname");
	brush1 = getEnt("trap5_a", "targetname");
	brush2 = getEnt("trap5_b", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    trig delete();

	for(;;)
	{
		brush1 moveZ(-164,0.5);
		brush2 rotatePitch(-360,0.5);
		wait 3;
		brush1 moveZ(164,0.5);
		brush2 rotatePitch(-360,0.5);
		wait 3;
		brush1 moveZ(-164,0.5);
		brush2 moveZ(-164,0.5);
		wait 3;
		brush1 moveZ(164,0.5);
		brush2 moveZ(164,0.5);
		wait 3;
	}
}


spike_trap()
{
	trig = getEnt("trig_spike", "targetname");
	brush = getEnt("spike", "targetname");

	trig enableLinkTo();
	trig linkTo(brush);

	for(;;)
	{
		brush moveZ(168,1);
		wait 3;
		brush moveZ(-168,2);
		wait 3;
	}
}


trap6()
{
	trig = getEnt("trig_trap6", "targetname");
	brush = getEnt("trap6", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	brush hide();
	brush notSolid();

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

	brush show();
	brush Solid();
	wait 3;
	brush delete();
    trig delete();
}

trap7()
{
	trig = getEnt("trig_trap7", "targetname");
	brush1 =  getEnt("trap7_a", "targetname");
	brush2 = getEnt("trap7_b", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");


	brush1 notSolid();
	brush1 hide();
	brush2 notSolid();
	brush2 hide();

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    trig delete();
    x = randomInt(2);
	if(x == 0)
    {
	brush1 solid();
	brush1 show();
	brush2 delete();
	wait 3;
	brush1 delete();
	}
    if(x == 1)
    {
	brush2 solid();
	brush2 show();
	brush1 delete();
	wait 3;
	brush2 delete();
	}
}


trap8()
{
	trig = getEnt("trig_trap8", "targetname");
	brush1 = getEnt("trap8_a", "targetname");
	brush2 = getEnt("trap8_b", "targetname");
	brush3 = getEnt("trap8_c", "targetname");

	trig setHintString("Press ^7[^2&&1^7] ^7To Activate");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 50 );

    trig delete();


		brush1 moveZ(-400,2);
		wait 5;
		brush1 moveZ(400,3);
}


knife_room()
{
	while(1)
	{
		level.trigknife = getEnt("trig_knife","targetname");
		acti = getEnt("k_1","targetname");
		jump = getEnt("k_2","targetname");

		level.trigknife setHintString("^2Knife Room");

		level.trigknife waittill("trigger", player);

		level.trigbounce delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigrace delete();
		level.trigshotgun delete();


		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Knife Room";
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
		iPrintLnBold("^7Knife Room Open!");
		player = undefined;

	}
}


bounce_room()
{
	while(1)
	{
		level.trigbounce = getEnt("trig_bounce","targetname");
		acti = getEnt("b_1","targetname");
		jump = getEnt("b_2","targetname");

		level.trigbounce setHintString("^2Bounce Room");

		level.trigbounce waittill("trigger", player);

		level.trigknife delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigrace delete();
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



race_room()
{
	while(1)
	{
		level.trigrace = getEnt("trig_race","targetname");
		acti = getEnt("r_1","targetname");
		jump = getEnt("r_2","targetname");

		level.trigrace setHintString("^2Race Room");

		level.trigrace waittill("trigger", player);

		level.trigbounce delete();
		level.trigwep delete();
		level.trigsniper delete();
		level.trigshotgun delete();
		level.trigknife delete();

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Race Room";
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
		iPrintLnBold("^7Race Room Open!");
		player = undefined;

	}
}



sniper_room()
{
	while(1)
	{
		level.trigsniper = getEnt("trig_sniper","targetname");
		acti = getEnt("s_1","targetname");
		jump = getEnt("s_2","targetname");

		level.trigsniper setHintString("^2Sniper Room");

		level.trigsniper waittill("trigger", player);

		level.trigbounce delete();
		level.trigwep delete();
		level.trigknife delete();
		level.trigrace delete();
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


karma_room()
{
	while(1)
	{
		level.trigwep = getEnt("trig_wep","targetname");
		acti = getEnt("s_1","targetname");
		jump = getEnt("s_2","targetname");

		level.trigwep setHintString("^2Wepon Room");

		level.trigwep waittill("trigger", player);

		level.trigbounce delete();
		level.trigsniper delete();
		level.trigknife delete();
		level.trigrace delete();
		level.trigshotgun delete();

		noti = SpawnStruct();
		noti.titleText = "^3" + player.name + " ^7Enterd the ^2Weapon Room";
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
		iPrintLnBold("^7Weapon Room Open!");
		player = undefined;

	}
}


shotgun_room()
{
	while(1)
	{
		level.trigshotgun = getEnt("trig_shot","targetname");
		acti = getEnt("shot_1","targetname");
		jump = getEnt("shot_2","targetname");

		level.trigshotgun setHintString("^2Shotgun Room");

		level.trigshotgun waittill("trigger", player);

		level.trigbounce delete();
		level.trigsniper delete();
		level.trigknife delete();
		level.trigrace delete();
		level.trigwep delete();

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
		player giveWeapon("winchester1200_mp");
		player giveMaxAmmo("winchester1200_mp");
		player switchToWeapon("winchester1200_mp");

		level.activ takeAllWeapons();
		level.activ giveWeapon("winchester1200_mp");
		level.activ giveMaxAmmo("winchester1200_mp");
		level.activ switchToWeapon("winchester1200_mp");


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