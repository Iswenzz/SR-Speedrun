//<-- Scripted By Fox for my map mp_dr_Vople
//MY GUID: 5dcce639cbef05e4f9b739a0ab61c6e4
//Prood:   67bf38f1c4011b6baad14263fa011572
//VC Glen: 00000000834a8a24535c3c56e3905ad9
//NitroFire: 1cac0c03e6cfb44ba80c5d5dd05bc267
//Preview SS: http:// imgur. com/a/8I7Pm

main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret");

			maps\mp\_load::main();

	//<-- End Rooms -->


	tele1 = getEnt("e_r_1", "targetname");
	thread sr\api\_speedrun::createTeleporter((-737, -836, 124), 100, 150,
		tele1.origin, tele1.angles[1], "freeze", "green", "secret_0");
	tele2 = getEnt("h_r_1", "targetname");
	thread sr\api\_speedrun::createTeleporter((-318, -836, 124), 100, 150,
		tele2.origin, tele2.angles[1], "freeze", "darkred", "secret_1");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");


	//<- Threads -->
	// thread messages();
	thread startdoor();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	// thread elev();
	thread trap8();
	thread trap9();
	// thread first_trig();
	// thread first_place();
	thread strafe_trig();
	thread JumperTele1();
	thread JumperTele2();
	thread JumperTele3();
	thread JumperTele4();
	// thread ActiTele7();
	// thread ActiTele1();
	// thread ActiTele2();
	// thread ActiTele3();
	// thread ActiTele4();
	// thread ActiTele5();
	// thread ActiTele6();
	// thread ActiTele7();
	// thread ActiTele8();
	/* [AUTO DELETE] thread sniper_room_fail_1(); */
	/* [AUTO DELETE] thread sniper_room_fail_2(); */
	thread rpg_room_fail_1();
	thread rpg_room_fail_2();
	/* [AUTO DELETE] thread bounce_room_fail_1(); */
	/* [AUTO DELETE] thread bounce_room_fail_1_2(); */
	/* [AUTO DELETE] thread bounce_room_fail_2(); */
	/* [AUTO DELETE] thread bounce_room_fail_2_2(); */
	// thread  [AUTO DELETE] bounce_room_sniper();
	// thread acti_sec();
	// thread acti_sec_enter();
	// thread acti_sec_fails();
	// thread acti_sec_xp();
	// thread logo_shoot();
	/* [AUTO DELETE] thread secret_enter(); */
	// thread  [AUTO DELETE] open_secret();
	/* [AUTO DELETE] thread vip_fox(); */
	/* [AUTO DELETE] thread vip_glen(); */
	/* [AUTO DELETE] thread vip_prood(); */
	/* [AUTO DELETE] thread vip_nitro(); */
	thread easy_sec_fail_1();
	thread easy_enter();
	thread easy_finish();
	thread easy_sec_fail_2();
	thread easy_sec_fail_3();
	thread easy_sec_fail_4();
	thread easy_sec_fail_5();
	thread easy_sec_fail_6();
	thread easy_sec_fail_7();
	/* [AUTO DELETE] thread knife_room(); */
	/* [AUTO DELETE] thread musicBox(); */
	thread hard_sec_enter();
	thread hard_sec_fail_1();
	thread hard_sec_fail_2();
	thread hard_sec_fail_3();
	thread hard_sec_fail_4();
	thread hard_sec_fail_5();
	thread hard_sec_fail_6();
	thread hard_finish();
	/* [AUTO DELETE] thread addTestClients(); */
	/* [AUTO DELETE] thread sniper_room(); */
	/* [AUTO DELETE] thread bounce_room(); */
	// thread rpg_room();
	//thread addTriggerToList(); <-- There an error here :>

	//<-- PreCache -->
	//Models
	//<-- Elysium -->
	precacheShader("ely_bra");
	precacheShader("ely_choker");
	precacheShader("ely_edging");
	precacheShader("ely_eyes");
	precacheShader("ely_face");
	precacheShader("ely_feet");
	precacheShader("ely_hair3");
	precacheShader("ely_hands");
	precacheShader("ely_head_scarf");
	precacheShader("ely_jewel");
	precacheShader("ely_leg_sock_clasp");
	precacheShader("ely_legs");
	precacheShader("ely_mask");
	precacheShader("ely_mask_feathers");
	precacheShader("ely_necklace_beads");
	precacheShader("ely_necklace_chain");
	precacheShader("ely_pants");
	precacheShader("ely_ribbons");
	precacheShader("ely_shoes");
	precacheShader("ely_skin");
	precacheShader("ely_skirt");
	precacheShader("ely_sock_clasp");
	precacheShader("ely_socks");
	precacheShader("ely_toga");
	precacheShader("elysium_gold");
	precacheShader("elysium_sleeve_fabric");
	precacheModel("Elysium_SC5");
	//<-- Metal Sonic -->
	precacheShader("sonic_metal_body");
	precacheShader("sonic_metal_head");
	precacheModel("sonic_metal_model");
	//<-- Yuusha -->
	precacheShader("de_m_kami_01");
	precacheShader("de_m_kami_02");
	precacheShader("de_m_kami_03");
	precacheShader("de_m_kami_04");
	precacheShader("de_m_kao_01");
	precacheShader("de_m_me_01");
	precacheShader("de_m_sukato01");
	precacheShader("de_m_sukato10");
	precacheShader("de_m_sukato19");
	precacheShader("de_m_sukato20");
	precacheShader("de_m_sukato25");
	precacheShader("de_m_sukato27");
	precacheModel("Yuusha");
	/* [AUTO DELETE] //Weapons
	precacheItem("remington700_mp"); */
	precacheItem("m40a3_mp");
	precacheItem("rpg_mp");
	precacheItem("knife_mp");
	precacheItem("shockwave_mp");



	// //<-- /* [AUTO DELETE] Music -->
	// //Music//
	// if(!isdefined(level.music))
 //    level.music=[]; */
 //    level.music[0]["song"]    ="Brennan Heart - Be Here Now";	//name to show in game
 //    /* [AUTO DELETE] level.music[0]["alias"]    ="song1"; */						//name in iwd
 //    /* [AUTO DELETE] level.music[1]["song"]    ="Logic  - Ballin"; */
 //    /* [AUTO DELETE] level.music[1]["alias"]    ="song2"; */
 //    /* [AUTO DELETE] level.music[2]["song"]    ="Netsky - Nobody's Perfect"; */
 //    /* [AUTO DELETE] level.music[2]["alias"]    ="song3"; */
 //    /* [AUTO DELETE] level.music[3]["song"]    ="Era Istrefi - Bonbon"; */
 //    /* [AUTO DELETE] level.music[3]["alias"]    ="song4"; */
	//  [AUTO DELETE] level.music[4]["song"]    ="Muzzy - Break Away";
 //    /* [AUTO DELETE] level.music[4]["alias"]    ="song5"; */
	// /* [AUTO DELETE] level.music[5]["song"]    ="Mr FijiWiji & Direct - Hysteria"; */
 //    /* [AUTO DELETE] level.music[5]["alias"]    ="song6"; */
 //   	/* [AUTO DELETE] level.music[6]["song"]    ="Eyeris - All In Good Time"; */
 //    /* [AUTO DELETE] level.music[6]["alias"]    ="song7"; */

	// //<--Trigger List-->
	// addTriggerToList("acti_trap_1"); //use your trap triggers instead of trig_trap10, do this for all traps
	// addTriggerToList("trig2");
	// addTriggerToList("trig3");
	// addTriggerToList("trig4");
	// addTriggerToList("trig5");
	// addTriggerToList("trig6");
	// addTriggerToList("trig7");
	// addTriggerToList("trig8");
	// addTriggerToList("trig9");

}


addTriggerToList( name ) //Free Run Trap Fix
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}


//<-- Thread Messages -->
messages()
{
	wait 10;
	/* [AUTO DELETE] iprintlnBold("Welcome to ^2Mp^7_^2dr^7_^2Volpe^7!"); */
	wait 2;
	/* [AUTO DELETE] iprintlnBold("^7Map Made By: ^2Fox"); */
	wait 10;
	for(;;)
{
	wait 0.1;
	/* [AUTO DELETE] iprintln("^2>> ^7Map Made By: ^2Fox"); */
	wait 30;
	/* [AUTO DELETE] iprintln("^2>> ^7Thanks to ^1VC' Glen ^7For Fixing Errors"); */
	wait 30;
}

}

//<-- Thread Startdoor -->
startdoor()
{
	door = getent("startdoor","targetname");
	{
		wait 20;
		door moveZ(-400, 5);
		/* [AUTO DELETE] iprintlnbold("^2Start ^7Door ^2Opened^7!"); */
		wait 2;
	}
}


trap1()
{
	level endon("trigger");
	platform = getent("trap1", "targetname");
	part2 = getent("part2", "targetname");
	trig = getent("acti_trap_1", "targetname"); //is this the trigger that the acti presses? yes

	trig waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	//
	trig delete();
	platform delete();
	part2 delete();
}


trap2()
{
	level endon("trigger");
	delete1 = getent("trap2_1", "targetname");
	delete2 = getent("trap2_2", "targetname");
	delete3 = getent("trap2_3", "targetname");
	delete4 = getent("trap2_4", "targetname");
	trig2 = getent("trig2", "targetname");
	trig2 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig2 delete();
	delete1 delete();
	delete2 delete();
	delete3 delete();
	delete4 delete();

}



trap3()
{
	level endon("trigger");
	trap3 = getent("trap3", "targetname");
	trig3 = getent("trig3", "targetname");
	trig3 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig3 delete();
	trap3 delete();

}

//<-- Thread Trap 4 -->
trap4()
{
	level endon("trigger");
	triange1 = getent("trap4_1", "targetname");
	triange2 = getent("trap4_2", "targetname");
	delete4 = getent("trap4_3", "targetname");
	delete5 = getent("trap4_4", "targetname");
	trig4 = getent("trig4", "targetname");
	trig4 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	delete4 delete();
	delete5 delete();

	for(;;)
	{
	wait 0.1;
	triange1 moveZ(-400, 0.1);
	wait 1;
	triange2 moveZ(-400, 0.1);
	wait 1;
	triange1 moveZ(400, 0.1);
	wait 1;
	triange2 moveZ(400, 0.1);
	wait 3;
	}
	trig4 delete();
}

//<-- Thread Trap 5 -->
trap5()
{
	level endon("trigger");
	bounce1 = getent("trap5", "targetname");
	trig5 = getent("trig5", "targetname");
	trig5 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig5 delete();
	wait 0.1;
	bounce1 moveX(-192, 1);
	wait 6;
	bounce1 moveX(192, 1);

}

//<-- Thread Trap 6 -->
trap6()
{
	level endon("trigger");
	bounce2 = getent("trap6", "targetname");
	trig6 = getent("trig6", "targetname");
	trig6 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig6 delete();
	bounce2 delete();

}

//<-- Thread Trap 7 -->
trap7()
{
	level endon("trigger");
	square = getent("trap7", "targetname");
	trig7 = getent("trig7", "targetname");
	trig7 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig7 delete();
	square delete();

}


//<-- Thread Elevator -->
elev()
{
	elev = getent("elevator", "targetname");

	for(;;)
	{
	wait 0.1;
	elev moveY (896, 1);
	wait 4;
	elev moveY (-896, 1);
	wait 4;
	}
}


//<-- Thread Trap 8 -->
trap8()
{
	level endon("trigger");
	bounce3 = getent("trap8_1", "targetname");
	bounce4 = getent("trap8_2", "targetname");
	trig8 = getent("trig8", "targetname");
	trig8 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig8 delete();
	bounce3 delete();
	bounce4 delete();

}


//<-- Thread Trap 9 -->
trap9()
{
	level endon("trigger");
	pillars1 = getent("trap9_1", "targetname");
	pillars2 = getent("trap9_2", "targetname");
	pillars3 = getent("trap9_3", "targetname");
	pillars4 = getent("trap9_4", "targetname");
	pillars5 = getent("trap9_5", "targetname");
	pillars6 = getent("trap9_6", "targetname");
	pillars7 = getent("trap9_7", "targetname");
	pillars8 = getent("trap9_8", "targetname");
	trig9 = getent("trig9", "targetname");
	trig9 waittill("trigger", player);

	/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 60 ); */
	trig9 delete();
	pillars1 delete();
	pillars2 delete();
	pillars3 delete();
	pillars4 delete();
	pillars5 delete();
	pillars6 delete();
	pillars7 delete();
	pillars8 delete();

}


JumperTele1()
{
	trig = getEnt("2ndroomtp", "targetname");
	tele1 = getEnt("2ndroom", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


JumperTele2()
{
	trig = getEnt("3rdroom_tp", "targetname");
	tele1 = getEnt("3rdroom", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


JumperTele3()
{
	trig = getEnt("4rthroom_tp", "targetname");
	tele1 = getEnt("here4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


JumperTele4()
{
	trig = getEnt("tp9", "targetname");
	tele1 = getEnt("here9", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele1()
{
	trig = getEnt("tp1", "targetname");
	tele1 = getEnt("here", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele2()
{
	trig = getEnt("tp2", "targetname");
	tele1 = getEnt("here2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele3()
{
	trig = getEnt("acti_tp3", "targetname");
	tele1 = getEnt("here5", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele4()
{
	trig = getEnt("acti_tp4", "targetname");
	tele1 = getEnt("here6", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele8()
{
	trig = getEnt("fail_acti", "targetname");
	tele1 = getEnt("safe", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele5()
{
	trig = getEnt("tp10", "targetname");
	tele1 = getEnt("here10", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele6()
{
	trig = getEnt("tp11", "targetname");
	tele1 = getEnt("here11", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}


ActiTele7()
{
	trig = getEnt("tp12", "targetname");
	tele1 = getEnt("here12", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			/* [AUTO DELETE] wait 0.01; */
			player freezeControls(0);
		}
}






first_trig()
{
	trig10 = getEnt( "first_trig", "targetname" );

	while(true)
	{
		trig10 waittill ("trigger",player );
		trig10 delete ();
		/* [AUTO DELETE] iPrintLnBold("^2"+ player.name + " ^7Has Reached the ^2Second ^7Area^2!"); */
		/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 50 ); */
	}
}

first_place()
{
	trig11 = getEnt( "first_place", "targetname" );

	while(true)
	{
		trig11 waittill ("trigger",player );
		trig11 delete ();
		/* [AUTO DELETE] iPrintLnBold("^2"+ player.name + " ^7Has Finished ^2First^7!"); */
	}
}


strafe_trig()
{
	trig12 = getEnt( "strafe", "targetname" );

	while(true)
	{
		trig12 waittill ("trigger",player );
		trig12 delete ();
		/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 50 ); */
	}
}


sniper_room_fail_1()
{
	trig = getEnt("sniperfail_1", "targetname");
	tele1 = getEnt("sf_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}



sniper_room_fail_2()
{
	trig = getEnt("sniperfail_2", "targetname");
	tele1 = getEnt("sf_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}


rpg_room_fail_1()
{
	trig = getEnt("rpg_fail_1", "targetname");
	tele1 = getEnt("rpgf_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}



rpg_room_fail_2()
{
	trig = getEnt("rpg_fail_2", "targetname");
	tele1 = getEnt("rpgf_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}




bounce_room_fail_1()
{
	trig = getEnt("bounce_fail1", "targetname");
	tele1 = getEnt("bf_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}



bounce_room_fail_1_2()
{
	trig = getEnt("bounce_fail1_2", "targetname");
	tele1 = getEnt("bf_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}



bounce_room_fail_2()
{
	trig = getEnt("bounce_fail2", "targetname");
	tele1 = getEnt("bf_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}


bounce_room_fail_2_2()
{
	trig = getEnt("bounce_fail2_2", "targetname");
	tele1 = getEnt("bf_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}



bounce_room_sniper()
{
	trig = getEnt("br_sniper", "targetname");

		for(;;)
		{
			trig waittill("trigger", player);
			/* [AUTO DELETE] player giveWeapon("remington700_mp"); */
			/* [AUTO DELETE] player givemaxammo("remington700_mp"); */
			/* [AUTO DELETE] player switchtoweapon("remington700_mp"); */
			wait 0.1;
		}
}


acti_sec()
{
	sec_door = getent("acti_sec_door", "targetname");
	trig = getent("trig_scti_sec", "targetname");
	trig waittill("trigger", player);

	/* [AUTO DELETE] player iprintln("^2[^7Activator Secret Opened^2]"); */
	sec_door delete();
	trig delete();
}


acti_sec_enter()
{
	trig = getEnt( "acti_sec_enter", "targetname" );

	while(true)
	{
		trig waittill ("trigger",player );
		/* [AUTO DELETE] player iPrintLnBold("Welcome to the ^2Activator ^7Secret^2!"); */
		trig delete ();
	}
}


acti_sec_fails()
{
	trig = getEnt("act_sec_tp_1", "targetname");
	tele1 = getEnt("act_sec_reset", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


acti_sec_xp()
{
	trig = getEnt("act_sec_xp", "targetname");
	tele1 = getEnt("here6", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 50 ); */
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


logo_shoot()
{
	for(;;)
	{
	trig = getent("logo_shoot", "targetname");
	trig waittill("trigger", player);
	/* [AUTO DELETE] player iprintlnBold("^7Map Made By: ^2Fox"); */
	wait 0.1;
		}
}


secret_enter()
{
	trig = getEnt("secret_enter", "targetname");
	tele1 = getEnt("secret_area", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			wait 0.01;
		}
}


open_secret()
{
	sec_block = getent("secret_block", "targetname");
	trig = getent("open_secret", "targetname");
	trig waittill("trigger", player);

	/* [AUTO DELETE] iprintln("^2[^7Secret Opened^2]"); */
	sec_block delete();
	trig delete();
}




vip_fox()
{
	trig = getent("vip_fox", "targetname");
	trig waittill("trigger", player);
	if(player getGuid() == "5dcce639cbef05e4f9b739a0ab61c6e4") //Fox
{
	player.vip = true;
	/* [AUTO DELETE] iprintlnBold("^3>> ^7Welcome Map Creator: ^2Fox ^3<<"); */
	/* [AUTO DELETE] player giveWeapon("shockwave_mp"); */
	/* [AUTO DELETE] player giveMaxAmmo("shockwave_mp"); */
	/* [AUTO DELETE] player switchtoweapon("shockwave_mp"); */
	player detachAll();
	player setmodel("Elysium_SC5");
	wait 1;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	wait 0.1;
}
    else
{
	player.vip = false;
	wait 0.1;
}
}


vip_glen()
{
	trig = getent("vip_glen", "targetname");
	trig waittill("trigger", player);
	if(player getGuid() == "00000000834a8a24535c3c56e3905ad9") //VC Glen
{
	player.vip = true;
	/* [AUTO DELETE] player iprintlnBold("^3>> ^7Heya ^1VC Glen^7! ^3<<"); */
	/* [AUTO DELETE] player giveWeapon("shockwave_mp"); */
	/* [AUTO DELETE] player giveMaxAmmo("shockwave_mp"); */
	/* [AUTO DELETE] player switchtoweapon("shockwave_mp"); */
	player detachAll();
	player setmodel("sonic_metal_model");
	wait 1;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	wait 30;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	trig delete();
}
    else
{
	player.vip = false;
	wait 0.1;
}
}


vip_prood()
{
	trig = getent("vip_prood", "targetname");
	trig waittill("trigger", player);
	if(player getGuid() == "67bf38f1c4011b6baad14263fa011572") //Prood
{
	player.vip = true;
	/* [AUTO DELETE] player iprintlnBold("^3>> ^7Heya ^1Proodigy^7! ^3<<"); */
	wait 1;
	/* [AUTO DELETE] player iprintlnBold("^3TY for testing my dude ^1<3"); */
	/* [AUTO DELETE] player giveWeapon("shockwave_mp"); */
	/* [AUTO DELETE] player giveMaxAmmo("shockwave_mp"); */
	/* [AUTO DELETE] player switchtoweapon("shockwave_mp"); */
	player detachAll();
	player setmodel("Yuusha");
	wait 1;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	wait 30;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	trig delete();
}
    else
{
	player.vip = false;
	wait 0.1;
}
}


vip_nitro()
{
	trig = getent("vip_nitro", "targetname");
	trig waittill("trigger", player);
	if(player getGuid() == "1cac0c03e6cfb44ba80c5d5dd05bc267") //NitroFire
{
	player.vip = true;
	/* [AUTO DELETE] player iprintlnBold("^3>> ^7Heya ^1NitroFire^7! ^3<<"); */
	wait 1;
	/* [AUTO DELETE] player giveWeapon("shockwave_mp"); */
	/* [AUTO DELETE] player giveMaxAmmo("shockwave_mp"); */
	/* [AUTO DELETE] player switchtoweapon("shockwave_mp"); */
	player detachAll();
	player setmodel("sonic_metal_model");
	wait 1;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	wait 30;
	rand = RandomIntRange(50, 150);
    /* [AUTO DELETE] player braxi\_rank::giveRankXP( "", rand ); */
    /* [AUTO DELETE] player iprintln("^3[Volpe VIP:] ^2" +player.name +"^7 has earned ^2" +rand +"XP"); */
	trig delete();
}
    else
{
	player.vip = false;
	wait 0.1;
}
}











easy_sec_fail_1()
{
	trig = getEnt("e_f_1", "targetname");
	tele1 = getEnt("e_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_enter()
{
	trig = getEnt("easy_enter", "targetname");
	tele1 = getEnt("e_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player thread secret_timer_easy();
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_finish()
{
	trig = getEnt("easy_finish", "targetname");
	tele1 = getEnt("3rdroom", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 200 ); */
			/* [AUTO DELETE] iPrintLnBold("^2"+ player.name + " ^7Has Finished the ^5Easy ^7Secret^5!"); */
			// player notify("secret1_done");
			// player.secretTimer destroy();
			// player setOrigin(tele1.origin);
			// player setPlayerAngles(tele1.angles);
			player thread sr\api\_speedrun::finishWay("secret_0");
			/* [AUTO DELETE] wait 0.01; */
		}
}


secret_timer_easy() //blades timer
{
	self endon("secret1_done");


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


easy_sec_fail_2()
{
	trig = getEnt("e_f_2", "targetname");
	tele1 = getEnt("e_r_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_sec_fail_3()
{
	trig = getEnt("e_f_3", "targetname");
	tele1 = getEnt("e_r_3", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_sec_fail_4()
{
	trig = getEnt("e_f_4", "targetname");
	tele1 = getEnt("e_r_4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_sec_fail_5()
{
	trig = getEnt("e_f_5", "targetname");
	tele1 = getEnt("e_r_5", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_sec_fail_6()
{
	trig = getEnt("e_f_6", "targetname");
	tele1 = getEnt("e_r_6", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


easy_sec_fail_7()
{
	trig = getEnt("e_f_7", "targetname");
	tele1 = getEnt("e_r_7", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}






knife_room()
{
	while(1)
	{
	level.trigknife = getEnt("trig_knife", "targetname");

	jumporigin = getEnt("origin_jknife", "targetname");
	actiorigin = getEnt("origin_aknife", "targetname");

	level.trigknife waittill("trigger", player);

	level.trigsniper delete();
	level.trigrpg delete();
	level.trigbounce delete();



	/* [AUTO DELETE] iPrintLnBold("^2 " + player.name + " ^7Entered The ^2Knife ^7Room^7!"); */
	wait 2;

	/* [AUTO DELETE] player takeAllWeapons(); */
	/* [AUTO DELETE] level.activ takeAllWeapons(); */

	/* [AUTO DELETE] player giveWeapon("knife_mp"); */
	/* [AUTO DELETE] level.activ giveWeapon("knife_mp"); */

	player freezeControls(1);
	level.activ freezeControls(1);

	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);

	/* [AUTO DELETE] player iPrintLnBold("^63"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^63"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^62"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^62"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^61"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^61"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^1FIGHT!"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^1FIGHT!"); */

	player freezeControls(0);
	level.activ freezeControls(0);

	/* [AUTO DELETE] player switchToWeapon("knife_mp"); */
	/* [AUTO DELETE] level.activ switchToWeapon("knife_mp"); */
	}
}



musicBox()
{
    trig = getEnt("trig_music","targetname");
    trig setHintString("Press ^2&&1^7 to select Music");
    trig waittill("trigger",p);
	//braxi\_rank::/* [AUTO DELETE] giveRankXP("", 50); */
    trig delete();

    p freezeControls(1);
    p musicMenu();
}






musicMenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );

    self.hud_music = [];
    self.selection = 0;

    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,0,0);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Mp_Dr_Volpe!");
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
    indicator.color=(1,0,0);

    while(self.sessionstate == "playing")
    {
        wait 0.1;

        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             /* [AUTO DELETE] iPrintLn("^2>> ^7Now playing: ^2"+level.music[self.selection]["song"]); */

            /* [AUTO DELETE] ambientPlay(level.music[self.selection]["alias"]); */
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
           break;
        }
    }

    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}




hard_sec_enter()
{
	trig = getEnt("hard_enter", "targetname");
	tele1 = getEnt("h_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player thread secret_timer_hard();
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}



hard_sec_fail_1()
{
	trig = getEnt("h_f_1", "targetname");
	tele1 = getEnt("h_r_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


hard_sec_fail_2()
{
	trig = getEnt("h_f_2", "targetname");
	tele1 = getEnt("h_r_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


hard_sec_fail_3()
{
	trig = getEnt("h_f_3", "targetname");
	tele1 = getEnt("h_r_3", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


hard_sec_fail_4()
{
	trig = getEnt("h_f_4", "targetname");
	tele1 = getEnt("h_r_4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


hard_sec_fail_5()
{
	trig = getEnt("h_f_5", "targetname");
	tele1 = getEnt("h_r_5", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


hard_sec_fail_6()
{
	trig = getEnt("h_f_6", "targetname");
	tele1 = getEnt("h_r_6", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
		}
}


hard_finish()
{
	trig = getEnt("hard_finish", "targetname");
	tele1 = getEnt("hard_finish_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			/* [AUTO DELETE] player braxi\_rank::giveRankXP( "", 500 ); */
			/* [AUTO DELETE] iPrintLnBold("^2"+ player.name + " ^7Has Finished the ^1Hard ^7Secret^1!"); */
			// player notify("secret2_done");
			// player.secretTimer destroy();
			// player setOrigin(tele1.origin);
			// player setPlayerAngles(tele1.angles);
			/* [AUTO DELETE] wait 0.01; */
			player thread sr\api\_speedrun::finishWay("secret_1");
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
             /* [AUTO DELETE] println("Could not add test client"); */
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




secret_timer_hard() //blades timer
{
	self endon("secret2_done");


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

	time=120;
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



sniper_room()
{
	while(1)
	{
	level.trigsniper = getEnt("sniper_room", "targetname");

	jumporigin = getEnt("sf_1", "targetname");
	actiorigin = getEnt("sf_2", "targetname");

	level.trigsniper waittill("trigger", player);

	level.trigknife delete();
	level.trigrpg delete();
	level.trigbounce delete();

	/* [AUTO DELETE] iPrintLnBold("^2 " + player.name + " ^7Entered The ^2Sniper ^7Room^7!"); */


	/* [AUTO DELETE] player takeAllWeapons(); */
	/* [AUTO DELETE] level.activ takeAllWeapons(); */

	/* [AUTO DELETE] player giveWeapon("m40a3_mp"); */
	/* [AUTO DELETE] player giveWeapon("remington700_mp"); */
	/* [AUTO DELETE] player giveMaxAmmo("remington700_mp"); */
	/* [AUTO DELETE] player giveMaxAmmo("m40a3_mp"); */
	/* [AUTO DELETE] level.activ giveWeapon("m40a3_mp"); */
	/* [AUTO DELETE] level.activ giveWeapon("remington700_mp"); */
	/* [AUTO DELETE] level.activ giveMaxAmmo("remington700_mp"); */
	/* [AUTO DELETE] level.activ giveMaxAmmo("m40a3_mp"); */


	/* [AUTO DELETE] player switchToWeapon("m40a3_mp"); */
	/* [AUTO DELETE] player switchToWeapon("remington700_mp"); */
	/* [AUTO DELETE] level.activ switchToWeapon("m40a3_mp"); */
	/* [AUTO DELETE] player switchToWeapon("remington700_mp"); */

	player freezeControls(1);
	level.activ freezeControls(1);

	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;

	/* [AUTO DELETE] player iPrintLnBold("^23"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^23"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^72"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^72"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^21"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^21"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^7FIGHT^2!"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^7FIGHT^2!"); */

	player freezeControls(0);
	level.activ freezeControls(0);


	}
}


bounce_room()
{
	while(1)
	{
	level.trigbounce = getEnt("bounce_room", "targetname");

	jumporigin = getEnt("bf_1", "targetname");
	actiorigin = getEnt("bf_2", "targetname");

	level.trigbounce waittill("trigger", player);
	level.trigknife delete();
	level.trigrpg delete();
	level.trigsniper delete();


	/* [AUTO DELETE] iPrintLnBold("^2 " + player.name + " ^7Entered The ^2Bounce ^7Room^7!"); */


	/* [AUTO DELETE] player takeAllWeapons(); */
	/* [AUTO DELETE] level.activ takeAllWeapons(); */

	/* [AUTO DELETE] player giveWeapon("knife_mp"); */
	/* [AUTO DELETE] level.activ giveWeapon("knife_mp"); */

	/* [AUTO DELETE] player switchToWeapon("knife_mp"); */
	/* [AUTO DELETE] level.activ switchToWeapon("knife_mp"); */

	player freezeControls(1);
	level.activ freezeControls(1);

	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;

	/* [AUTO DELETE] player iPrintLnBold("^23"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^23"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^72"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^72"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^21"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^21"); */
	wait 1;
	/* [AUTO DELETE] player iPrintLnBold("^7FIGHT^2!"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^7FIGHT^2!"); */

	player freezeControls(0);
	level.activ freezeControls(0);


	}
}



rpg_room()
{
	while(1)
	{
	level.trigrpg = getEnt("rpg_room", "targetname");

	jumporigin = getEnt("rpgf_1", "targetname");
	actiorigin = getEnt("rpgf_2", "targetname");

	level.trigrpg waittill("trigger", player);

	level.trigknife delete();
	level.trigsniper delete();
	level.trigbounce delete();

	/* [AUTO DELETE] iPrintLnBold("^2 " + player.name + " ^7Entered The ^2RPG ^7Room^7!"); */


	/* [AUTO DELETE] player takeAllWeapons(); */
	/* [AUTO DELETE] level.activ takeAllWeapons(); */

	/* [AUTO DELETE] player giveWeapon("rpg_mp"); */
	/* [AUTO DELETE] level.activ giveWeapon("rpg_mp"); */
	/* [AUTO DELETE] player switchToWeapon("rpg_mp"); */
	/* [AUTO DELETE] level.activ switchToWeapon("rpg_mp"); */


	player freezeControls(1);
	level.activ freezeControls(1);

	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	/* [AUTO DELETE] wait 2; */

	/* [AUTO DELETE] player iPrintLnBold("^23"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^23"); */
	/* [AUTO DELETE] wait 1; */
	/* [AUTO DELETE] player iPrintLnBold("^72"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^72"); */
	/* [AUTO DELETE] wait 1; */
	/* [AUTO DELETE] player iPrintLnBold("^21"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^21"); */
	/* [AUTO DELETE] wait 1; */
	/* [AUTO DELETE] player iPrintLnBold("^7FIGHT^2!"); */
	/* [AUTO DELETE] level.activ iPrintLnBold("^7FIGHT^2!"); */

	player freezeControls(0);
	level.activ freezeControls(0);

		for(;;)
		{
			/* [AUTO DELETE] player giveMaxAmmo("rpg_mp"); */
			/* [AUTO DELETE] level.activ giveMaxAmmo("rpg_mp"); */
			/* [AUTO DELETE] wait 0.1; */
		}
}
}
