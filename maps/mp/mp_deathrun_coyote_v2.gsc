main()
{
thread sr\api\_map::createSpawnOrigin((-163, 507, 31.500), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^2Easy Way; ^5Easy+ Way; ^1Hard Way;");


	maps\mp\_load::main();






	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	// Precache
	precacheItem( "rpg_mp" );
	precacheItem( "ak47_mp" );
	precacheItem( "remington700_mp" );
	precacheItem( "m40a3_mp" );
	precacheItem( "deserteagle_mp" );
	precacheItem( "winchester1200_mp" );
	precacheShader("black");
        precacheShader("white");


	// if(!isdefined(level. [AUTO DELETE] music))
	// 	level.music=[];

	/* [AUTO DELETE] level.music[0]["song"]	="Hoodie Allen - Interruption"; */
	/* [AUTO DELETE] level.music[0]["alias"]	="interruption"; */
	/* [AUTO DELETE] level.music[1]["song"]	="Our Last Night - Never Forget You"; */
	/* [AUTO DELETE] level.music[1]["alias"]	="forgetyou"; */
	/* [AUTO DELETE] level.music[2]["song"]	="Twenty One Pilots - Ride"; */
	/* [AUTO DELETE] level.music[2]["alias"]	="ride"; */
	/* [AUTO DELETE] level.music[3]["song"]	="Vanic X Machineheart - Circles"; */
	/* [AUTO DELETE] level.music[3]["alias"]	="circles"; */
	/* [AUTO DELETE] level.music[4]["song"]	="Razihel - Tick Tick Boom Boom"; */
	/* [AUTO DELETE] level.music[4]["alias"]	="ticktick"; */
	/* [AUTO DELETE] level.music[5]["song"]	="Tiest� - Wasted (Ummet Ozcan Remix)"; */
	/* [AUTO DELETE] level.music[5]["alias"]	="wasted"; */

    thread sr\api\_speedrun::createTeleporter((-109, 728, 85), 100, 150,
    	(-2552, 48, 1863), 270, "freeze", "green", "secret_0");
    thread sr\api\_speedrun::createTeleporter((-299, 679, 74), 100, 150,
    	(-2440, 4181, 1863), 270, "freeze", "cyan", "secret_1");
    thread sr\api\_speedrun::createTeleporter((-343, 503, 73), 100, 150,
    	(-2963, 11951, 1863), 270, "freeze", "red", "secret_2");

	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
	addTriggerToList("trig_trap10");
	addTriggerToList("trig_trap11");
	addTriggerToList("trig_trap12");
	addTriggerToList("trig_trap13");
	addTriggerToList("trig_trap14");
	addTriggerToList("trig_trap15");

	/* [AUTO DELETE] thread musictrig(); */

	// thread easy_enter();
	// thread easyplus_enter();
	// thread hard_enter();
	thread start_stairs();
	/* [AUTO DELETE] thread secret_room(); */
	thread easy_end();
	thread easyplus_end();
	thread hard_end();
	thread easy_sound();
	thread easyplus_sound();
	thread hard_sound();
	thread teddy_shoot1();
	thread teddy_shoot2();
	thread easy_fail1();
	thread easy_fail2();
	thread easy_fail3();
	thread easy_fail4();
	thread easy_fail5();
	thread easy_fail6();
	thread easy_fail7();
	thread easy_fail8();
	thread easyplus_fail1();
	thread easyplus_fail2();
	thread easyplus_fail3();
	thread easyplus_fail4();
	thread easyplus_fail5();
	thread easyplus_fail6();
	thread easyplus_fail7();
	thread easyplus_fail8();
	thread hard_fail1();
	thread hard_fail2();
	thread hard_fail3();
	thread hard_fail4();
	thread hard_fail5();
	thread hard_fail6();
	thread hard_fail7();
	thread hard_fail8();
	thread hard_fail9();
	// thread /* [AUTO DELETE] acti_bounce1(); */
	// thread /* [AUTO DELETE] acti_bounce2(); */
	// thread  [AUTO DELETE] acti_bounce3();
	// thread /* [AUTO DELETE] acti_bounce4(); */
	// thread /* [AUTO DELETE] acti_bounce5(); */
	thread acti_tele1();
	thread acti_tele1back();
	/* [AUTO DELETE] thread deagle_machine(); */
	// thread  [AUTO DELETE] acti_secret();
	/* [AUTO DELETE] thread bounce_r7001(); */
	/* [AUTO DELETE] thread bounce_r7002(); */
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	thread trap14();
	thread trap15();
	thread trap8_mover();
	// thread jump_room_battle();
	/* [AUTO DELETE] thread sniper_room_battle(); */
	/* [AUTO DELETE] thread knife_room_battle(); */
	// thread weaproom();
	/* [AUTO DELETE] thread old_room_battle(); */
	// thread sgun_room_battle();
	// thread ak_room_battle();
	// thread sgun_room_battle();
	// thread rpg_room_battle();
	/* [AUTO DELETE] thread secret_rpg(); */
	thread creators();
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

easy_enter()
{
	trig = getEnt ("easy_enter", "targetname");
	end = getEnt ("easy_enter_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player thread easy_secrettimer();
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

easyplus_enter()
{
	trig = getEnt ("easyplus_enter", "targetname");
	end = getEnt ("easyplus_enter_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player thread easyplus_secrettimer();
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

hard_enter()
{
	trig = getEnt ("hard_enter", "targetname");
	end = getEnt ("hard_enter_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player thread hard_secrettimer();
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

start_stairs()
{
	object = getEnt ("start_stairs", "targetname");
	wait 15;
	object movez(172,10);
}

secret_room()
{
	wall1 = getEnt ("s_wall1", "targetname");
	wall2 = getEnt ("s_wall2", "targetname");
	wall3 = getEnt ("s_wall3", "targetname");
	wall4 = getEnt ("s_wall4", "targetname");
	wall5 = getEnt ("s_wall5", "targetname");
	wall6 = getEnt ("s_wall6", "targetname");
	wall7 = getEnt ("s_wall7", "targetname");
	wall8 = getEnt ("s_wall8", "targetname");
	wall1 hide();
	wall2 hide();
	wall3 hide();
	wall4 hide();
	wall5 hide();
	wall6 hide();
	wall7 hide();
	wall8 hide();
	while(1)
	{
		wall1 show();
		 wait 0.4;
		wall1 hide();
		wall2 show();
		 wait 0.4;
		wall2 hide();
		wall3 show();
		 wait 0.4;
		wall3 hide();
		wall4 show();
		 wait 0.4;
		wall4 hide();
		wall5 show();
		 wait 0.4;
		wall5 hide();
		wall6 show();
		 wait 0.4;
		wall6 hide();
		wall7 show();
		 wait 0.4;
		wall7 hide();
		wall8 show();
		 wait 0.4;
		wall8 hide();
	}
}

easy_end()
{
	trig = getEnt ("easy_end","targetname");
	go = getEnt ("easy_end_go","targetname");
	out = getEnt ("easy_out","targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

easy_sound()
{
	trigger = getEnt ("easy_end","targetname");
	secret = getEnt ("secret_sound","targetname");
	while(1)
	{
		trigger waittill ("trigger", player);
		wait 0.2;
		secret playSound("callofduty");
	}
}

easyplus_end()
{
	trig = getEnt ("easyplus_end","targetname");
	go = getEnt ("easyplus_end_go","targetname");
	out = getEnt ("easyplus_out","targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_1");
	}
}

easyplus_sound()
{
	trigger = getEnt ("easyplus_end","targetname");
	secret = getEnt ("secret_sound","targetname");
	while(1)
	{
		trigger waittill ("trigger", player);
		wait 0.2;
		secret playSound("callofduty");
	}
}


hard_end()
{
	trig = getEnt ("hard_end","targetname");
	go = getEnt ("hard_end_go","targetname");
	out = getEnt ("hard_out","targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_2");
	}
}

hard_sound()
{
	trigger = getEnt ("hard_end","targetname");
	secret = getEnt ("secret_sound","targetname");
	while(1)
	{
		trigger waittill ("trigger", player);
		wait 0.2;
		secret playSound("callofduty");
	}
}

teddy_shoot1()
{
	trigger = getent("shortcut_open","targetname");
	object1 = getent("shortcutwall","targetname");
	object2 = getent("shortcut_ladder","targetname");
	object2 notsolid();
	// trigger waittill ("trigger" , player );
	object1 notsolid();
	object2 solid();
	/* [AUTO DELETE] iprintln( "^5TeddySHoot!" ); */
}

teddy_shoot2()
{
	trigger = getent("secret_open","targetname");
	secret_clip = getEnt ("secret_clip","targetname");
	// trigger waittill ("trigger" , player );
	secret_clip delete();
	/* [AUTO DELETE] iprintln( "^5TeddySHoot!" ); */
}

easy_fail1()
{
	trig = getEnt ("easy_fail1", "targetname");
	end = getEnt ("easy_fail1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail2()
{
	trig = getEnt ("easy_fail2", "targetname");
	end = getEnt ("easy_fail2_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail3()
{
	trig = getEnt ("easy_fail3", "targetname");
	end = getEnt ("easy_fail3_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail4()
{
	trig = getEnt ("easy_fail4", "targetname");
	end = getEnt ("easy_fail4_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail5()
{
	trig = getEnt ("easy_fail5", "targetname");
	end = getEnt ("easy_fail5_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail6()
{
	trig = getEnt ("easy_fail6", "targetname");
	end = getEnt ("easy_fail6_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail7()
{
	trig = getEnt ("easy_fail7", "targetname");
	end = getEnt ("easy_fail7_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easy_fail8()
{
	trig = getEnt ("easy_fail8", "targetname");
	end = getEnt ("easy_fail8_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail1()
{
	trig = getEnt ("easyplus_fail1", "targetname");
	end = getEnt ("easyplus_fail1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail2()
{
	trig = getEnt ("easyplus_fail2", "targetname");
	end = getEnt ("easyplus_fail2_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail3()
{
	trig = getEnt ("easyplus_fail3", "targetname");
	end = getEnt ("easyplus_fail3_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail4()
{
	trig = getEnt ("easyplus_fail4", "targetname");
	end = getEnt ("easyplus_fail4_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail5()
{
	trig = getEnt ("easyplus_fail5", "targetname");
	end = getEnt ("easyplus_fail5_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail6()
{
	trig = getEnt ("easyplus_fail6", "targetname");
	end = getEnt ("easyplus_fail6_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail7()
{
	trig = getEnt ("easyplus_fail7", "targetname");
	end = getEnt ("easyplus_fail7_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

easyplus_fail8()
{
	trig = getEnt ("easyplus_fail8", "targetname");
	end = getEnt ("easyplus_fail8_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail1()
{
	trig = getEnt ("hard_fail1", "targetname");
	end = getEnt ("hard_fail1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail2()
{
	trig = getEnt ("hard_fail2", "targetname");
	end = getEnt ("hard_fail2_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail3()
{
	trig = getEnt ("hard_fail3", "targetname");
	end = getEnt ("hard_fail3_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail4()
{
	trig = getEnt ("hard_fail4", "targetname");
	end = getEnt ("hard_fail4_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail5()
{
	trig = getEnt ("hard_fail5", "targetname");
	end = getEnt ("hard_fail5_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail6()
{
	trig = getEnt ("hard_fail6", "targetname");
	end = getEnt ("hard_fail6_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail7()
{
	trig = getEnt ("hard_fail7", "targetname");
	end = getEnt ("hard_fail7_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail8()
{
	trig = getEnt ("hard_fail8", "targetname");
	end = getEnt ("hard_fail8_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

hard_fail9()
{
	trig = getEnt ("hard_fail9", "targetname");
	end = getEnt ("hard_fail9_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_bounce1()
{
	trig = getEnt ("acti_bounce1", "targetname");
	end = getEnt ("acti_bounce1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_bounce2()
{
	trig = getEnt ("acti_bounce2", "targetname");
	end = getEnt ("acti_bounce2_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_bounce3()
{
	trig = getEnt ("acti_bounce3", "targetname");
	end = getEnt ("acti_bounce3_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_bounce4()
{
	trig = getEnt ("acti_bounce4", "targetname");
	end = getEnt ("acti_bounce4_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_bounce5()
{
	trig = getEnt ("acti_bounce5", "targetname");
	end = getEnt ("acti_bounce5_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_tele1()
{
	trig = getEnt ("acti_tele1", "targetname");
	end = getEnt ("acti_tele1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_tele1back()
{
	trig = getEnt ("acti_tele1back", "targetname");
	end = getEnt ("acti_tele1back_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

deagle_machine()
{
	trigger = getEnt ( "deagle_machine", "targetname" );
	while(1)
        {
                trigger waittill ( "trigger", player );
                wait 0.05;
                /* [AUTO DELETE] player giveWeapon ( "deserteagle_mp" ); */
                /* [AUTO DELETE] player switchToWeapon ( "deserteagle_mp" ); */
                /* [AUTO DELETE] player giveMaxAmmo ( "deserteagle_mp" ); */
		wait 1;
	}
}

acti_secret()
{
	trigger = getEnt ( "acti_chicken", "targetname" );
	object = getEnt ( "acti_secret_block", "targetname" );
	// trigger waittill ("trigger", player);
	/* [AUTO DELETE] player iPrintlnBold(" ^3You might want to go back..."); */
	object movex(-60,5);
	thread acti_secret_msg();
	thread acti_secret_tele();
	thread acti_secret_fin();
}

acti_secret_msg()
{
	trigger = getEnt ( "acti_secret_msg", "targetname" );
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player iPrintlnBold(" ^3Welcome to bounce room training!"); */
}

acti_secret_tele()
{
	trig = getEnt ("acti_secret_tele", "targetname");
	end = getEnt ("acti_secret_tele_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

acti_secret_fin()
{
	trig = getEnt ("acti_secret_fin", "targetname");
	object = getEnt ( "acti_secret_mover", "targetname" );
	end = getEnt ("acti_secret_fin_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 100); */
	/* [AUTO DELETE] player iPrintlnBold( " ^3 You finished the bounce room training!" ); */
	object movex(60,0.1);
	object waittill ("movedone");
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

jump_room_gun()
{
	trigger = getEnt ( "bounce_room_gun", "targetname" );
	while(1)
        {
                trigger waittill ( "trigger", player );
                wait 0.05;
                /* [AUTO DELETE] player giveWeapon ( "remington700_mp" ); */
		/* [AUTO DELETE] player giveMaxAmmo ( "remington700_mp" ); */
                /* [AUTO DELETE] player switchToWeapon ( "remington700_mp" ); */
           	wait 1;
	}
}

bounce_r7001()
{
	object = getEnt("bounce_r700","targetname");
	while(1)
	{
		object rotateyaw(720,6);
		object waittill ("rotatedone");
	}
}

bounce_r7002()
{
	object = getEnt("bounce_r700","targetname");
	object movez(4,1.5);
	while(1)
	{
		object movez(-8,1.5);
		object waittill ("movedone");
		object movez(8,1.5);
		object waittill ("movedone");
	}
}

trap1()
{
	level endon("trigger");
	trigger = getent("trig_trap1","targetname");
	object = getent("trap1_spikes","targetname");
	killtrigger = getent ("trap1_killtrig" , "targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	killtrigger enablelinkto ();
	killtrigger linkto (object);
	object movez(53, 1);
	object waittill("movedone");
	wait 6;
	object movez(-53, 1);
	object waittill("movedone");
	wait 1;
}

trap2()
{
	level endon("trigger");
	trigger = getent("trig_trap2","targetname");
	object = getent("trap2","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	object delete();
}

trap3()
{
	level endon("trigger");
	trigger = getent("trig_trap3","targetname");
	object = getent("trap3","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	while(1)
	{
		object movez(115, 2);
		object waittill ("movedone");
		object movez(-115,2);
		object waittill ("movedone");
		wait 5;
	}
}

trap4()
{
	level endon("trigger");
	trigger = getent("trig_trap4","targetname");
	object = getent("trap4","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	object movez(244,1);
	object rotateyaw(360,1);
	object waittill ("movedone");
	object movez(-244,3);
	object rotateyaw(-1080,3);
	object waittill ("movedone");
	while(1)
	{
		object rotateYaw(3240, 6);
		object waittill("rotatedone");
		wait 5;
		object rotateYaw(-3240, 6);
		object waittill("rotatedone");
		wait 5;
	}
}

trap5()
{
	level endon("trigger");
	trigger = getEnt ( "trig_trap5", "targetname" );
	object1 = getEnt ( "trap5_bou1", "targetname" );
	object2 = getEnt ( "trap5_bou2", "targetname" );
	trigger waittill ( "trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");

	i = randomintrange( 0, 2 );
	if(i == 0)
	{
		object1 delete();
	}
	else if(i == 1)
	{
		object2 delete();

	}
}

trap6()
{
	level endon("trigger");
	trigger = getent("trig_trap6","targetname");
	object1 = getent("trap6_spikes1","targetname");
	object2 = getent("trap6_spikes2","targetname");
	object3 = getent("trap6_spikes3","targetname");
	object4 = getent("trap6_spikes4","targetname");
	killtrigger1 = getent ("trap6_killtrig1" , "targetname");
	killtrigger2 = getent ("trap6_killtrig2" , "targetname");
	killtrigger3 = getent ("trap6_killtrig3" , "targetname");
	killtrigger4 = getent ("trap6_killtrig4" , "targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	killtrigger1 enablelinkto ();
	killtrigger1 linkto (object1);
	killtrigger2 enablelinkto ();
	killtrigger2 linkto (object2);
	killtrigger3 enablelinkto ();
	killtrigger3 linkto (object3);
	killtrigger4 enablelinkto ();
	killtrigger4 linkto (object4);
	object1 movez(36, 1);
	object2 movez(36, 1);
	object3 movez(36, 1);
	object4 movez(36, 1);
	object4 waittill("movedone");
	wait 5;
	object1 movez(-36, 1);
	object2 movez(-36, 1);
	object3 movez(-36, 1);
	object4 movez(-36, 1);
	object4 waittill("movedone");
	while(1)
	{
		object1 movez(36, 1.5);
		object1 waittill("movedone");
		object1 movez(-36, 1.5);
		object1 waittill("movedone");
		object2 movez(36, 1.5);
		object2 waittill("movedone");
		object2 movez(-36, 1.5);
		object2 waittill("movedone");
		object3 movez(36, 1.5);
		object3 waittill("movedone");
		object3 movez(-36, 1.5);
		object3 waittill("movedone");
		object4 movez(36, 1.5);
		object4 waittill("movedone");
		object4 movez(-36, 1.5);
		object4 waittill("movedone");
	}
}

trap7()
{
	level endon("trigger");
	trigger = getent("trig_trap7","targetname");
	object = getent("trap7","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	object notsolid();
}

trap8()
{
	level endon("trigger");
	trigger = getent("trig_trap8","targetname");
	object = getent("trap8","targetname");
	object notsolid();
	object hide();
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	object show();
	object solid();
}

trap8_mover()
{
	level endon("trigger");
	object = getent("trap8_mover","targetname");
	// while(1)
	// {
	// 	object movey(781,5);
	// 	object waittill ("movedone");
	// 	wait 3;
	// 	object movey(-781,5);
	// 	object waittill ("movedone");
	// 	wait 3;
	// }
}

trap9()
{
	level endon("trigger");
	trigger = getEnt ( "trig_trap9", "targetname" );
	object1 = getEnt ( "trap9_1", "targetname" );
	object2 = getEnt ( "trap9_2", "targetname" );
	object3 = getEnt ( "trap9_3", "targetname" );
	object4 = getEnt ( "trap9_4", "targetname" );
	object5 = getEnt ( "trap9_5", "targetname" );
	object6 = getEnt ( "trap9_6", "targetname" );
	object7 = getEnt ( "trap9_7", "targetname" );
	object8 = getEnt ( "trap9_8", "targetname" );
	object9 = getEnt ( "trap9_9", "targetname" );
	trigger waittill ( "trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");

	i = randomintrange( 0, 5 );
	if(i == 0)
	{
		thread trap9_mover1();
		thread trap9_mover2();
		thread trap9_mover3();
		thread trap9_mover4();
		thread trap9_mover5();
		thread trap9_mover6();
		thread trap9_mover7();
		thread trap9_mover8();
		thread trap9_mover9();
	}
	else if(i == 1)
	{
		object1 notsolid();
		object5 notsolid();
		object7 notsolid();

	}
	else if(i == 2)
	{
		object2 notsolid();
		object4 notsolid();
		object8 notsolid();
	}
	else if(i == 3)
	{
		object1 delete();
		object4 delete();
		object7 delete();
		object3 movex(-100,1);
		object6 movex(-100,1);
		object9 movex(-100,1);
		object9 waittill ("movedone");
		while(1)
		{
			object3 movex(202,2);
			object6 movex(202,2);
			object9 movex(202,2);
			object9 waittill ("movedone");
			object3 movex(-202,2);
			object6 movex(-202,2);
			object9 movex(-202,2);
			object9 waittill ("movedone");
		}

	}
	else if(i == 4)
	{
		object3 delete();
		object6 delete();
		thread trap9_floor1();
		thread trap9_floor2();
		thread trap9_floor3();
		thread trap9_floor4();
		thread trap9_floor5();
		thread trap9_floor6();
	}
}

trap9_mover1()
{
	level endon("trigger");
	object1 = getEnt ("trap9_1","targetname");
	while(1)
	{
		object1 movey(48,0.5);
		object1 waittill ("movedone");
		object1 movex(-48,0.5);
		object1 waittill ("movedone");
		object1 movey(-48,0.5);
		object1 waittill ("movedone");
		object1 movex(48,0.5);
		object1 waittill ("movedone");
	}
}

trap9_mover2()
{
	level endon("trigger");
	object1 = getEnt ("trap9_2","targetname");
	while(1)
	{
		object1 movey(48,0.5);
		object1 waittill ("movedone");
		object1 movex(48,0.5);
		object1 waittill ("movedone");
		object1 movey(-48,0.5);
		object1 waittill ("movedone");
		object1 movex(-48,0.5);
		object1 waittill ("movedone");
	}
}

trap9_mover3()
{
	level endon("trigger");
	object1 = getEnt ("trap9_3","targetname");
	while(1)
	{
		object1 rotateyaw(360,4);
		object1 waittill ("rotatedone");
	}
}

trap9_mover4()
{
	level endon("trigger");
	object1 = getEnt ("trap9_4","targetname");
	while(1)
	{
		object1 movey(48,0.5);
		object1 waittill ("movedone");
		object1 movex(-48,0.5);
		object1 waittill ("movedone");
		object1 movey(-48,0.5);
		object1 waittill ("movedone");
		object1 movex(48,0.5);
		object1 waittill ("movedone");
	}
}

trap9_mover5()
{
	level endon("trigger");
	object1 = getEnt ("trap9_5","targetname");
	while(1)
	{
		object1 movey(48,0.5);
		object1 waittill ("movedone");
		object1 movex(48,0.5);
		object1 waittill ("movedone");
		object1 movey(-48,0.5);
		object1 waittill ("movedone");
		object1 movex(-48,0.5);
		object1 waittill ("movedone");
	}
}

trap9_mover6()
{
	level endon("trigger");
	object1 = getEnt ("trap9_6","targetname");
	while(1)
	{
		object1 rotateyaw(-360,4);
		object1 waittill ("rotatedone");
	}
}

trap9_mover7()
{
	level endon("trigger");
	object1 = getEnt ("trap9_7","targetname");
	while(1)
	{
		object1 movey(48,0.5);
		object1 waittill ("movedone");
		object1 movex(-48,0.5);
		object1 waittill ("movedone");
		object1 movey(-48,0.5);
		object1 waittill ("movedone");
		object1 movex(48,0.5);
		object1 waittill ("movedone");
	}
}

trap9_mover8()
{
	level endon("trigger");
	object1 = getEnt ("trap9_8","targetname");
	while(1)
	{
		object1 movey(48,0.5);
		object1 waittill ("movedone");
		object1 movex(48,0.5);
		object1 waittill ("movedone");
		object1 movey(-48,0.5);
		object1 waittill ("movedone");
		object1 movex(-48,0.5);
		object1 waittill ("movedone");
	}
}

trap9_mover9()
{
	level endon("trigger");
	object1 = getEnt ("trap9_9","targetname");
	while(1)
	{
		object1 rotateyaw(360,4);
		object1 waittill ("rotatedone");
	}
}

trap9_floor1()
{
	level endon("trigger");
	object1 = getEnt ("trap9_1","targetname");
	while(1)
	{
		object1 movey(924,6);
		object1 waittill("movedone");
		object1 movex(186,0.5);
		object1 waittill("movedone");
		object1 movey(-924,6);
		object1 waittill("movedone");
		object1 movex(-186,0.5);
		object1 waittill("movedone");
	}
}

trap9_floor2()
{
	level endon("trigger");
	object1 = getEnt ("trap9_4","targetname");
	while(1)
	{
		object1 movey(462,3);
		object1 waittill ("movedone");
		object1 movex(186,0.5);
		object1 waittill("movedone");
		object1 movey(-924,6);
		object1 waittill("movedone");
		object1 movex(-186,0.5);
		object1 waittill("movedone");
		object1 movey(462,3);
		object1 waittill("movedone");
	}
}

trap9_floor3()
{
	level endon("trigger");
	object1 = getEnt ("trap9_7","targetname");
	while(1)
	{
		object1 movex(186,0.5);
		object1 waittill("movedone");
		object1 movey(-924,6);
		object1 waittill("movedone");
		object1 movex(-186,0.5);
		object1 waittill("movedone");
		object1 movey(924,6);
		object1 waittill("movedone");
	}
}

trap9_floor4()
{
	level endon("trigger");
	object1 = getEnt ("trap9_8","targetname");
	while(1)
	{
		object1 movey(-924,6);
		object1 waittill("movedone");
		object1 movex(-186,0.5);
		object1 waittill("movedone");
		object1 movey(924,6);
		object1 waittill("movedone");
		object1 movex(186,0.5);
		object1 waittill("movedone");
	}
}

trap9_floor5()
{
	level endon("trigger");
	object1 = getEnt ("trap9_5","targetname");
	while(1)
	{
		object1 movey(-462,3);
		object1 waittill ("movedone");
		object1 movex(-186,0.5);
		object1 waittill("movedone");
		object1 movey(924,6);
		object1 waittill("movedone");
		object1 movex(186,0.5);
		object1 waittill("movedone");
		object1 movey(-462,3);
		object1 waittill("movedone");

	}
}

trap9_floor6()
{
	level endon("trigger");
	object1 = getEnt ("trap9_2","targetname");
	while(1)
	{
		object1 movex(-186,0.5);
		object1 waittill("movedone");
		object1 movey(924,6);
		object1 waittill("movedone");
		object1 movex(186,0.5);
		object1 waittill("movedone");
		object1 movey(-924,6);
		object1 waittill("movedone");
	}
}

trap10()
{
	level endon("trigger");
	trigger = getent("trig_trap10","targetname");
	object = getent("trap10","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	object delete();
}

trap11()
{
	level endon("trigger");
	trigger = getent("trig_trap11","targetname");
	object = getent("trap11_mover","targetname");
	killtrig = getent("trap11_killtrig","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	killtrig movez(-55,0.1);
	object movez(-54,5);
	object waittill ("movedone");
	killtrig delete();
}

trap12()
{
	level endon("trigger");
	trigger = getent("trig_trap12","targetname");
	object = getent("trap12","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	while(1)
	{
		object rotateyaw(360,1);
		object waittill ("rotatedone");
		object rotateyaw(360,10);
		object waittill ("rotatedone");
		object rotateyaw(-360,1);
		object waittill ("rotatedone");
		object rotateyaw(-360,10);
	}
}

trap13()
{
	level endon("trigger");
	trigger = getent("trig_trap13","targetname");
	object = getent("trap13","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	object delete();
}

trap14()
{
	level endon("trigger");
	trigger = getEnt ( "trig_trap14", "targetname" );
	object1 = getEnt ( "trap14_1", "targetname" );
	object2 = getEnt ( "trap14_2", "targetname" );
	object3 = getEnt ( "trap14_3", "targetname" );
	object4 = getEnt ( "trap14_4", "targetname" );
	trigger waittill ( "trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");

	i = randomintrange( 0, 6 );
	if(i == 0)
	{
		object2 delete();
		object3 delete();
	}
	else if(i == 1)
	{
		object1 delete();
		object4 delete();
	}
	else if(i == 2)
	{
		object1 delete();
		object3 delete();
	}
	else if(i == 3)
	{
		object2 delete();
		object4 delete();
	}
	else if(i == 4)
	{
		object1 delete();
		object2 delete();
	}
	else if(i == 5)
	{
		object3 delete();
		object4 delete();
	}
}

trap15()
{
	level endon("trigger");
	trigger = getent("trig_trap15","targetname");
	object = getent("trap15","targetname");
	wall = getent("trap15_wall","targetname");
	wall movex(464,0.1);
	wall notsolid();
	wall hide();
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^1Activated");
	wall solid();
	wall show();
	object delete();
	wait 5;
	wall delete();
}

jump_room_battle()
{
    level.jump_trig=getent("jumproom_ent","targetname");

    jump=getent("jumproom_go","targetname");
    acti=getent("jumproom_acti","targetname");

    while(1)
    {
        level.jump_trig waittill("trigger",player);

        thread jump_fail();
	thread jump_room_gun();

        if(!isdefined(level.jump_trig)) return;

        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;

            ambientstop();
            /* [AUTO DELETE] ambientplay("jumbo"); */
            level.canPlaySound=false;

            /* [AUTO DELETE] iprintln("^1Now playing:^7 Alex Skrindo ^1-^7 Jumbo"); */

            level.old_trig delete();
            level.knife_trig delete();
            level.sgun_trig delete();
            level.sniper_trig delete();
            level.rpg_trig delete();
	    level.ak_trig delete();
	    level.weap_trig delete();

            /* [AUTO DELETE] iprintlnbold("^6"+player.name+" ^7entered Jump room."); */
        }

        player createroomport("knife_mp",undefined,1,jump,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);

        player thread countdown();
        level.activ thread countdown();

       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
    }
}

sniper_room_battle()
{
    level.sniper_trig=getent("sniproom_ent","targetname");

    jump=getent("sniproom_go","targetname");
    acti=getent("sniproom_acti","targetname");

    while(1)
    {
       level.sniper_trig waittill("trigger",player);
	if(!isdefined(level.sniper_trig)) return;

        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;

            ambientstop();
            /* [AUTO DELETE] ambientplay("janexo"); */
            level.canPlaySound=false;

            /* [AUTO DELETE] iprintln("^1Now playing:^7 Jane X� ^1-^7 Hard to forget"); */

            		level.old_trig delete();
			level.jump_trig delete();
			level.knife_trig delete();
			level.rpg_trig delete();
			level.sgun_trig delete();
			level.ak_trig delete();
			level.weap_trig delete();


            /* [AUTO DELETE] iprintlnbold("^6"+player.name+" ^7entered Sniper room."); */
        }

        player createroomport("remington700_mp","m40a3_mp",1,jump,100);
        level.activ createroomport("remington700_mp","m40a3_mp",1,acti,100);

        player thread countdown();
        level.activ thread countdown();

       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
    }
}

rpg_room_battle()
{
    level.rpg_trig=getent("rpgroom_ent","targetname");

    jump=getent("rpgroom_go","targetname");
    acti=getent("rpgroom_acti","targetname");

    while(1)
    {
       	level.rpg_trig waittill("trigger",player);
        if(!isdefined(level.rpg_trig)) return;

        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;

            ambientstop();
            /* [AUTO DELETE] ambientplay("secrets"); */
            level.canPlaySound=false;

            /* [AUTO DELETE] iprintln("^1Now playing:^7 Ti�sto & KSHMR ^1-^7 Secrets"); */


			level.sgun_trig delete();
			level.ak_trig delete();


            /* [AUTO DELETE] iprintlnbold("^6"+player.name+" ^7entered RPG room."); */
        }

        player createroomport("rpg_mp",undefined,1,jump,100);
        level.activ createroomport("rpg_mp",undefined,1,acti,100);

        player thread countdown();
        level.activ thread countdown();

        player thread refreshAmmo();
        level.activ thread refreshAmmo();

       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
    }
}

knife_room_battle()
{
    level.knife_trig=getent("kniferoom_ent","targetname");

    jump=getent("kniferoom_go","targetname");
    acti=getent("kniferoom_acti","targetname");

    while(1)
    {
       level.knife_trig waittill("trigger",player);
	if(!isdefined(level.knife_trig)) return;

        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;

            ambientstop();
            /* [AUTO DELETE] ambientplay("getup"); */
            level.canPlaySound=false;

            /* [AUTO DELETE] iprintln("^1Now playing:^7 Bingo Players ft. Far East Movement ^1-^7 Get up"); */

            		level.old_trig delete();
			level.jump_trig delete();
			level.sniper_trig delete();
			level.rpg_trig delete();
			level.sgun_trig delete();
			level.ak_trig delete();
			level.weap_trig delete();


            /* [AUTO DELETE] iprintlnbold("^6"+player.name+" ^7entered Knife room."); */
        }

        player createroomport("knife_mp",undefined,1,jump,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);

        player thread countdown();
        level.activ thread countdown();

       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
    }
}

sgun_room_battle()
{
   	level.sgun_trig=getent("sgunroom_ent","targetname");

    jump=getent("shootroom","targetname");
    acti=getent("shootroom_acti","targetname");

    while(1)
    {
       	level.sgun_trig waittill("trigger",player);
        if(!isdefined(level.sgun_trig)) return;

        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;

            ambientstop();
            /* [AUTO DELETE] ambientplay("brooklyn"); */
            level.canPlaySound=false;

            /* [AUTO DELETE] iprintln("^1Now playing:^7 Hoodie Allen ^1-^7 No faith in Brooklyn"); */


			level.rpg_trig delete();
			level.ak_trig delete();


            /* [AUTO DELETE] iprintlnbold("^6"+player.name+" ^7entered Shotgun room."); */
        }

        player createroomport("winchester1200_mp",undefined,1,jump,100);
        level.activ createroomport("winchester1200_mp",undefined,1,acti,100);

	player thread countdown();
        level.activ thread countdown();

       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
    }
}

ak_room_battle()
{
   	level.ak_trig=getent("akroom_ent","targetname");

    jump=getent("shootroom","targetname");
    acti=getent("shootroom_acti","targetname");

    while(1)
    {
       	level.ak_trig waittill("trigger",player);
        if(!isdefined(level.ak_trig)) return;

        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;

            ambientstop();
            /* [AUTO DELETE] ambientplay("brooklyn"); */
            level.canPlaySound=false;

            /* [AUTO DELETE] iprintln("^1Now playing:^7 Hoodie Allen ^1-^7 No faith in Brooklyn"); */

			level.rpg_trig delete();
			level.sgun_trig delete();


            /* [AUTO DELETE] iprintlnbold("^6"+player.name+" ^7entered Ak47 room."); */
        }

        player createroomport("ak47_mp",undefined,1,jump,100);
        level.activ createroomport("ak47_mp",undefined,1,acti,100);

	player thread countdown();
        level.activ thread countdown();

       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
    }
}

weaproom()
{
	level.weap_trig=getent("weaproom_ent","targetname");
	door =getent("weaproom_door","targetname");
	level.weap_trig waittill("trigger",player);

			level.old_trig delete();
            		level.knife_trig delete();
			level.jump_trig delete();
			level.sniper_trig delete();
	 /* [AUTO DELETE] iPrintlnBold("^3Weapon room open!"); */
	door delete();
			level.weap_trig delete();
}


old_room_battle()
{
    level.old_trig=getent("oldroom_ent","targetname");
    door=getent("oldroom_door","targetname");
    object=getent("old_actidoor","targetname");

        level.old_trig waittill("trigger",player);


            		level.knife_trig delete();
			level.jump_trig delete();
			level.sgun_trig delete();
			level.sniper_trig delete();
			level.rpg_trig delete();
			level.ak_trig delete();
			level.weap_trig delete();

		object movez (-144,1);
		object waittill ("movedone");
		wait 2;
		door delete();


            /* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7entered Old room."); */
		 level.old_trig delete();
}

refreshAmmo()
{
	while(isalive(self)&&isdefined(self))
	{
		self givemaxammo("rpg_mp");
		wait 4;
	}
}

createroomport(weapon,weapon2,freeze,where,health)
{
    self takeallweapons();
    /* [AUTO DELETE] self giveweapon(weapon); */
    if(isdefined(weapon2))
    	/* [AUTO DELETE] self giveweapon(weapon2); */
    /* [AUTO DELETE] self switchtoweapon(weapon); */

    self freezecontrols(freeze);
    self setorigin(where.origin);
    self setplayerangles(where.angles);

    self.health=health;
}

countdown()
{
    self iprintlnbold("^63");
    wait 1;
    self iprintlnbold("^62");
    wait 1;
    self iprintlnbold("^61");
    wait 1;
    self iprintlnbold("^5Fight!");
    wait 1;
    self freezecontrols(0);
}

jump_fail()
{
        level.jumpfail = getent ("bounce_alltp","targetname");
        level.js = getent ("bounce_jt_go","targetname");
        level.as = getent ("bounce_at_go","targetname");
        while(1)
        {
                level.jumpfail waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {
                        player SetPlayerAngles(level.js.angles);
                        player SetOrigin(level.js.origin);
                }
                else
                {
                        player SetPlayerAngles(level.as.angles);
                        player SetOrigin(level.as.origin);
                }
        }
}

secret_rpg()
{
    trig=getent("easy_rpg","targetname");
    for(;;)
    {
        trig waittill("trigger",who);
        /* [AUTO DELETE] who giveweapon("rpg_mp"); */
        /* [AUTO DELETE] who givemaxammo("rpg_mp"); */
        /* [AUTO DELETE] who switchtoweapon("rpg_mp"); */
    }
}

easy_secrettimer()
{
    self endon("easy_done");
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
       self.secretTimer.label = &"Time in left: &&1";

    if(isdefined(level.randomcolor))
        self.secretTimer.glowColor=level.randomcolor;
    else
        self.secretTimer.glowColor=(1,0,0);
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

easyplus_secrettimer()
{
    self endon("easyplus_done");
    if(isdefined(self.secretTimer2))
        self.secretTimer2 destroy();
    self.secretTimer2=newclienthudelem(self);
    self.secretTimer2.foreground = true;
    self.secretTimer2.alignX = "center";
    self.secretTimer2.alignY = "bottom";
    self.secretTimer2.horzAlign = "center";
    self.secretTimer2.vertAlign = "bottom";
    self.secretTimer2.x = 0;
    self.secretTimer2.y = -7;
    self.secretTimer2.sort = 5;
    self.secretTimer2.fontScale = 1.6;
    self.secretTimer2.font = "default";
    self.secretTimer2.glowAlpha = 1;
    self.secretTimer2.hidewheninmenu = true;
       self.secretTimer2.label = &"Time in left: &&1";

    if(isdefined(level.randomcolor))
        self.secretTimer2.glowColor=level.randomcolor;
    else
        self.secretTimer2.glowColor=(1,0,0);
    time=150;
    for(i=0;i<time;i++)
    {
        self.secretTimer2 setvalue(time-i);
        wait 1;
    }
    self.secretTimer2 setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer2))
        self.secretTimer2 destroy();
}

hard_secrettimer()
{
    self endon("hard_done");
    if(isdefined(self.secretTimer3))
    self.secretTimer3 destroy();
    self.secretTimer3=newclienthudelem(self);
    self.secretTimer3.foreground = true;
    self.secretTimer3.alignX = "center";
    self.secretTimer3.alignY = "bottom";
    self.secretTimer3.horzAlign = "center";
    self.secretTimer3.vertAlign = "bottom";
    self.secretTimer3.x = 0;
    self.secretTimer3.y = -7;
    self.secretTimer3.sort = 5;
    self.secretTimer3.fontScale = 1.6;
    self.secretTimer3.font = "default";
    self.secretTimer3.glowAlpha = 1;
    self.secretTimer3.hidewheninmenu = true;
       self.secretTimer3.label = &"Time in left: &&1";

    if(isdefined(level.randomcolor))
        self.secretTimer3.glowColor=level.randomcolor;
    else
        self.secretTimer3.glowColor=(1,0,0);
    time=250;
    for(i=0;i<time;i++)
    {
        self.secretTimer3 setvalue(time-i);
        wait 1;
    }
    self.secretTimer3 setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer3))
        self.secretTimer3 destroy();
}

musicMenu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );

	self thread onDeath();
	self thread onDisconnect();

	self.hud_music = [];
	self.selection = 0;

	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText("Welcome to ^5coyote_v2");
	self.hud_music[i].glowalpha=1;
	if(isdefined(level.randomcolor))
		self.hud_music[i].glowcolor=level.randomcolor;
	else
		self.hud_music[i].glowcolor=(1,0,0);

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");

	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
		self.hud_music[i].glowalpha=1;
		if(isdefined(level.randomcolor))
			self.hud_music[i].glowcolor=level.randomcolor;
		else
			self.hud_music[i].glowcolor=(1,0,0);

		entry = level.music[j];
		self.hud_music[i] setText(entry["song"]);
	}

	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );

	while(self.sessionstate == "playing")
	{
		wait 0.1;

		if(self attackButtonPressed())
		{
			self.hud_music[3+self.selection].alpha = 0.93;

			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;

			item = self.hud_music[3+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if(self useButtonPressed())
		{
 			/* [AUTO DELETE] iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]); */
			/* [AUTO DELETE] ambientPlay(level.music[self.selection]["alias"]); */
			self freezecontrols(0);
			break;
		}
		else if(self fragButtonPressed())
		{
			self freezecontrols(0);
			break;
		}
	}

	self cleanUp();
}


	musictrig()
{
	trig = getEnt ("musictrig", "targetname");
	trig setHintString("Press [^5&&1^7] to choose Music");

	trig waittill("trigger",player);
	player freezecontrols(1);
	trig delete();
	player musicMenu();
}


	onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}


	onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}


	cleanUp()
{
	if( !isDefined( self ) )
		return;



	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}

creators()
{
	wait 9;
	/* [AUTO DELETE] iPrintlnBold("^7Map by ^5TheLixfe"); */
	wait 2;
	/* [AUTO DELETE] iprintln("^7Thanks to ^5Vistic Clan"); */
	wait 2;
	/* [AUTO DELETE] iprintln("^7Special thanks to Blade for some scripts!"); */
	wait 5;
	/* [AUTO DELETE] iprintln("^7Special thanks to SuX Lolz :] for helping me fix errors!"); */
	wait 15;
	/* [AUTO DELETE] iprintln("^6steam: TheLixfe"); */
	wait 5;
	/* [AUTO DELETE] iprintln("^7Map by ^5TheLixfe"); */
}
