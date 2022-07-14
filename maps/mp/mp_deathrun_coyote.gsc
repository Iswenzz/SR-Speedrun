#include maps\mp\_utility;
main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawnOrigin(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);

	thread sr\api\_speedrun::createTeleporter((283, 378, 65), 100, 150, (-2695, 422, 2399), 180, "freeze", "green", "secret_0");
	thread sr\api\_speedrun::createEndMap((3035, 9626, -1056), 300, 150);
	thread sr\api\_speedrun::createEndMap((-8029, 601, -52), 150, 150, "secret_0");

	maps\mp\_load::main();

	// entTransporter = getentarray( "bounce_enter", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread transporter();

	// entTransporter = getentarray( "bounce02_enter", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread transporter02();

	secwood = getent("wall_secret","targetname");
	secwood delete();

	// entTransporter = getentarray( "secret_entrance", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread secret_69();
	// entTransporter = getentarray( "secret_fail", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread secret_fail();
	// entTransporter = getentarray( "bounce_room_acti", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread bounce_room_acti();
	// entTransporter = getentarray( "bounce_room_jumper", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread bounce_room_jumper();
	// entTransporter = getentarray( "secret_finish", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread secret_finish();
	// entTransporter = getentarray( "secret_21", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread secret_21();
	// entTransporter = getentarray( "secret_21_out", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread secret_21_out();
	// entTransporter = getentarray( "jumpers_secret1", "targetname" );
	// if(isdefined(entTransporter))
	// 	for( i = 0; i < entTransporter.size; i++ )
	// 		entTransporter[i] thread jumpers_secret1();





	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	//VisionSetNaked( "mp_backlot" );


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
	wall = getent("wall03","targetname");
	wall notsolid();
	wall = getent("actisecret","targetname");
	wall notsolid();
	wall = getent("wall04","targetname");
	wall notsolid();
	wall = getent("swagster","targetname");
	wall notsolid();

	addTriggerToList("trigger_spikes");
        addTriggerToList("trigger_trap06");
        addTriggerToList("trigger_trap5");
        addTriggerToList("trigger_trap02");
        addTriggerToList("trigger_bounce01");
        addTriggerToList("trigger_trap03");
        addTriggerToList("trigger_spikes02");
        addTriggerToList("trigger_trap07");
        addTriggerToList("trigger_trap08");
        addTriggerToList("trigger_trap09");
        addTriggerToList("trigger_trap10");
        addTriggerToList("trigger_trap11");
        addTriggerToList("trigger_trap12");
        addTriggerToList("trigger_trap13");
        addTriggerToList("trigger_trap14");
        addTriggerToList("trigger_trap15");
        addTriggerToList("trigger_trap16");
        addTriggerToList("trigger_trap17");
        addTriggerToList("trigger_trap18");

	thread spikes();
	thread trap06();
	thread trap06mover();
	thread trap5();
	// thread  [AUTO DELETE] actisecret();
	thread trap02();
	/* [AUTO DELETE] thread bounce01(); */
	thread trap03();
	thread spikes02();
	//thread trap03mover();
	thread trap04();
	thread trap07();
	thread trap08();
	thread trap09();
	// thread wall_start();
	thread trap10();
	thread trap11_1();
	thread trap11_2();
	thread trap11_3();
	thread trap12();
	thread trap13();
	thread trap13_2();
	thread trap14();
	thread trap15_1();
	thread trap15_2();
	thread trap15_3();
	thread trap16();
	thread trap17();
	thread trap18();
	/* [AUTO DELETE] thread bounce_room_gun(); */
	/* [AUTO DELETE] thread secret_coyote_found(); */
	/* [AUTO DELETE] thread secret_finish(); */
	thread creators();
	/* [AUTO DELETE] thread knife_room_BATTLE(); */
	/* [AUTO DELETE] thread sniper_room_BATTLE(); */
	// thread jump_room_BATTLE();
	// thread finished_map();
	// thread teddy_shoot();
	// thread acti_xp1();
	/* [AUTO DELETE] thread deagle_machine(); */
	/* [AUTO DELETE] thread secret_21(); */
	/* [AUTO DELETE] thread secret_21_key(); */
	/* [AUTO DELETE] thread secret_21_out(); */
}


	addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


	spikes()
{
	trigger = getent("trigger_spikes","targetname");
	object = getent("spikes","targetname");
	killtrigger = getent ("killtrig" , "targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	killtrigger enablelinkto ();
	killtrigger linkto (object);
	object movez(32, 1);
	object waittill("movedone");
	wait(6);
	object movez(-32, 1);
	object waittill("movedone");
	wait(1);
}


	trap06()
{
	level endon("trigger");
	trigger = getent("trigger_trap06","targetname");
	object = getent("trap06","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movez(632, 0.01);
	object waittill("movedone");
}


	trap06mover()
{
	level endon("trigger");
	mover = getent ("trap06mover","targetname");
	while(1)
	{
		mover movey(647,4.8);
		mover waittill("movedone");
		wait (2.9);
		mover movey(-647,4.8);
		mover waittill("movedone");
		wait (2.9);
	}
}


	trap5()
{
	level endon("trigger");
	trigger = getent("trigger_trap5","targetname");
	wall = getent("trap5","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	wall notsolid();
}


	transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		/* [AUTO DELETE] wait 0.1; */
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		/* [AUTO DELETE] wait 0.1; */
	}
}


	actisecret()
{
	trigger = getent("trigger_actisecret","targetname");
	wall = getent("actisecret","targetname");
	trigger waittill ("trigger" , player );
	trigger delete();
	wall = getent("actisecret","targetname");
	wall solid();
}


	trap02()
{
	level endon("trigger");
	trigger = getent("trigger_trap02","targetname");
	object = getent("trap02","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object delete();
}


	bounce01()
{
	trigger = getent("trigger_bounce01","targetname");
	object = getent("bounce01","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object rotateYaw(720, 6);
}


	trap03()
{
	level endon("trigger");
	trigger = getent("trigger_trap03","targetname");
	object = getent("trap03","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	for(;;)
	{
		object rotateYaw(360, 1);
		object waittill("rotatedone");
		object rotateYaw(360,1);
	}
}


	spikes02()
{
	trigger = getent("trigger_spikes02","targetname");
	object = getent("spikes02","targetname");
	killtrigger = getent ("killtrig02" , "targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	killtrigger enablelinkto ();
	killtrigger linkto (object);
	object movez(40, 1);
	object waittill("movedone");
	wait(6);
	object movez(-40, 1);
	object waittill("movedone");
	wait(6);
	object movez(40, 1);
	object waittill("movedone");
	wait(6);
	object movez(-40, 1);
	object waittill("movedone");
	wait(6);
	object movez(40, 1);
	object waittill("movedone");
	wait(6);
	object movez(-40, 1);
	object waittill("movedone");
	wait(6);
	object movez(40, 1);
	object waittill("movedone");
	wait(6);
	object movez(-40, 1);
	object waittill("movedone");
	wait(6);
}


	trap03mover()
{
	level endon("trigger");
	trigger = getent("trigger_trap03","targetname");
	object = getent("trap03mover","targetname");
	trigger waittill ("trigger" , player );
	for(;;)
	{
		object movez(-103, 2);
		object waittill("movedone");
		wait(2);
		object movez(103, 2);
		object waittill("movedone");
		wait(2);
	}
}


	trap04()
{
	level endon("trigger");
	trigger = getent("trigger_spikes02","targetname");
	wall = getent("trap04","targetname");
	trigger waittill ("trigger" , player );
	trigger SetHintString("^1Activated");
	wall notsolid();
}


	trap07()
{
	level endon("trigger");
	trigger = getEnt ( "trigger_trap07", "targetname" );
	object1 = getEnt ( "trap07_1", "targetname" );
	object2 = getEnt ( "trap07_2", "targetname" );
	object3 = getEnt ( "trap07_3", "targetname" );
	object4 = getEnt ( "trap07_4", "targetname" );
	object5 = getEnt ( "trap07_5", "targetname" );
	object6 = getEnt ( "trap07_6", "targetname" );

	trigger waittill ( "trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");

	i = randomintrange( 0, 6 );
	if(i == 0)
	{
		object1 notSolid();
	}
	else if(i == 1)
	{
		object2 notSolid();
		object5 notSolid();
		object1 notSolid();
	}
	else if(i == 2)
	{
		object3 notSolid();
		object5 notSolid();
		object4 notSolid();
	}
	else if(i == 3)
	{
		object4 notSolid();
		object6 notSolid();
		object2 notSolid();
	}
	else if(i == 4)
	{
		object5 notSolid();
		object3 notSolid();
		object1 notSolid();
	}
	else if(i == 5)
	{
		object6 notSolid();
		object3 notSolid();
		object1 notSolid();
	}
}


	trap08()
{
	level endon("trigger");
	trigger = getent("trigger_trap08","targetname");
	object = getent("trap08","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object delete();
}


	trap09()
{
	level endon("trigger");
	trigger = getent("trigger_trap09","targetname");
	object = getent("trap09","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movez(89, 0.1);
	object waittill("movedone");
	wait(1);
	object movez(-89, 4);
	object waittill("movedone");
	wait(2);
}


	wall_start()
{
	object = getent("wall_start","targetname");
	i = randomint(2);
	if(i == 0)
	{
	wait 6;
	/* [AUTO DELETE] ambientPlay("habits"); */
	wait 9;
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Habits - Tove Lo (Cover by Our Last Night) ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Habits - Tove Lo (Cover by Our Last Night) ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Habits - Tove Lo (Cover by Our Last Night) ^2]] ^1>>>"); */
	object movez(172, 7);
	object waittill("movedone");
	}
	else if(i == 1)
	{
	wait 1;
	/* [AUTO DELETE] ambientPlay("radio"); */
	wait 14;
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Radioactive - Imagine Dragons (Cover by Our Last Night) ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Radioactive - Imagine Dragons (Cover by Our Last Night) ^2]] ^1>>>"); */
	/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 Radioactive - Imagine Dragons (Cover by Our Last Night) ^2]] ^1>>>"); */
	object movez(172, 7);
	object waittill("movedone");
	}

}


	trap10()
{
	level endon("trigger");
	trigger = getent("trigger_trap10","targetname");
	object = getent("trap10","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movex(389,1);
	object waittill("movedone");
	wait(5);
	object movex(-389,3);
	object waittill("movedone");
}


	trap11_1()
{
	level endon("trigger");
	trigger = getent("trigger_trap11","targetname");
	object = getent("trap11_1","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movez(84, 2);
	object waittill("movedone");
	wait(0.5);

	for(;;)
	{
		object movez(-217,4);
		object waittill("movedone");
		wait(0.5);
		object movez(217,4);
		object waittill("movedone");
		wait(0.5);
	}
}


	trap11_2()
{
	level endon("trigger");
	trigger = getent("trigger_trap11","targetname");
	object = getent("trap11_2","targetname");
	trigger waittill ("trigger" , player );
	object movez(-133, 2);
	object waittill("movedone");
	wait(0.5);

	for(;;)
	{
		object movez(217,4);
		object waittill("movedone");
		wait(0.5);
		object movez(-217,4);
		object waittill("movedone");
		wait(0.5);
	}
}


	trap11_3()
{
	level endon("trigger");
	trigger = getent("trigger_trap11","targetname");
	object = getent("trap11_3","targetname");
	trigger waittill ("trigger" , player );
	object movez(84, 2);
	object waittill("movedone");
	wait(0.5);

	for(;;)
	{

		object movez(-217,0.5);
		object waittill("movedone");
		wait(0.5);
		object movez(217,0.5);
		object waittill("movedone");
		wait(0.5);
	}
}



	transporter02()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		/* [AUTO DELETE] wait 0.1; */
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		/* [AUTO DELETE] wait 0.1; */
	}
}


	trap12()
{
	level endon("trigger");
	trigger = getent("trigger_trap12","targetname");
	object = getent("trap12","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	for(;;)
	{
		object rotateRoll(-720, 7);
		object waittill("rotatedone");
		object rotateRoll(-720,7);
	}
}


	trap13()
{
	level endon("trigger");
	trigger = getent("trigger_trap13","targetname");
	object = getent("trap13_bounce","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movez(-200, 3);
	object waittill("movedone");
}


	trap13_2()
{
	level endon("trigger");
	trigger = getent("trigger_trap13","targetname");
	object = getent("trap13_spinners","targetname");
	trigger waittill ("trigger" , player );
	object movex(-212, 3);
	object waittill("movedone");
	for(;;)
	{
		object rotateYaw(360, 1);
		object waittill("rotatedone");
		wait 2;
		object rotateYaw(360,1);
		object waittill("rotatedone");
	}
}


	trap14()
{
	level endon("trigger");

	trigger = getent("trigger_trap14","targetname");
	object = getent("trap14","targetname");
	killtrigger = getent ("killtrigger_trap14" , "targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	killtrigger enablelinkto ();
	killtrigger linkto (object);
	object movez(34, 1);
	object waittill("movedone");
}


	trap15_1()
{
	level endon("trigger");
	trigger = getent("trigger_trap15","targetname");
	object = getent("trap15_1","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	for(;;)
	{
		object movex(-232, 1);
		object waittill("movedone");
		wait(2);
		object movex(232, 1);
		object waittill("movedone");
		wait(2);
	}
}


	trap15_2()
{
	level endon("trigger");
	trigger = getent("trigger_trap15","targetname");
	object = getent("trap15_2","targetname");
	trigger waittill ("trigger" , player );
	for(;;)
	{
		object movex(232, 1);
		object waittill("movedone");
		wait(2);
		object movex(-232, 1);
		object waittill("movedone");
		wait(2);
	}
}


		trap15_3()
{
	level endon("trigger");
	trigger = getent("trigger_trap15","targetname");
	object = getent("trap15_3","targetname");
	trigger waittill ("trigger" , player );
	for(;;)
	{
		object movex(-232, 1);
		object waittill("movedone");
		wait(2);
		object movex(232, 1);
		object waittill("movedone");
		wait(2);
	}
}


	acti_bounce69_1()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	acti_bounce69_2()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	trap16()
{
	level endon("trigger");
	trigger = getent("trigger_trap16","targetname");
	object = getent("trap16","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movez(-300, 0.01);
	object waittill("movedone");
}


		trap17()
{
	level endon("trigger");
	trigger = getent("trigger_trap17","targetname");
	object = getent("trap17","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	object movez(-300, 0.01);
	object waittill("movedone");
}


	trap18()
{
	level endon("trigger");
	trigger = getent("trigger_trap18","targetname");
	wall = getent("trap18","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 10); */
	trigger SetHintString("^1Activated");
	wall notsolid();
}


	sniper_room_secret()
{
	trigger = getEnt ( "sniper_secret", "targetname" );
        level.HasGun = true;

        while(level.HasGun)
        {
                trigger waittill ( "trigger", player );
                wait 0.05;
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 100); */
                /* [AUTO DELETE] player giveWeapon ( "m40a3_mp" ); */
                /* [AUTO DELETE] player switchToWeapon ( "m40a3_mp" ); */
                /* [AUTO DELETE] player giveMaxAmmo ( "m40a3_mp" ); */
                level.HasGun = false;
	}
}


	shortcut_secret()
{
	trigger = getent("trigger_secret","targetname");
	wall = getent("wall02","targetname");
	trigger waittill ("trigger" , player );
	wall notsolid();
}


	wall_secret()
{
	trigger = getent("trigger_redbutton","targetname");
	object = getent("wall_secret","targetname");
	trigger waittill ("trigger" , player );
		object movex(-152, 4);
		object waittill("movedone");
}


	secret_69()
{
	while(true)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	secret_fail()
{
	for(;;)
	{
		self waittill( "trigger", player );
		/* [AUTO DELETE] player iprintlnbold ("^6YOU ^1FAILED!? ^5HAHAHHA!"); */
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	bounce_room_acti()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	bounce_room_jumper()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	bounce_room_gun()
{
	trigger = getEnt ( "bounce_room_gun", "targetname" );
	for(;;)
        {
                trigger waittill ( "trigger", player );
                wait 0.05;
                /* [AUTO DELETE] player giveWeapon ( "remington700_mp" ); */
		/* [AUTO DELETE] player giveMaxAmmo ( "remington700_mp" ); */
                /* [AUTO DELETE] player switchToWeapon ( "remington700_mp" ); */
           	wait 1;
	}
}


	secret_coyote_found()
{
	trigger = getent("secret_coyote_found","targetname");
		trigger waittill ("trigger" , player );
		/* [AUTO DELETE] iPrintlnBold( " ^3" + player.name + " ^7found ^4the ^6Mysterious coyote ." ); */
}


	secret_finish()
{
	for(;;)
	{
		self waittill( "trigger", player );
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 666); */
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}


	creators()
{
	wait 20;
	/* [AUTO DELETE] iprintln("Map made by ^5TheLixfe"); */
	wait 12;
	/* [AUTO DELETE] iprintln("HUGE thanks to ^2KecsKe ^7for teaching me, helping me on mapping and helping on scripts!"); */
	wait 6;
	/* [AUTO DELETE] iprintln("Thanks to ^2VC'Icomar ^7for helping me on the scripts and helping me on the musics!"); */
	wait 6;
	/* [AUTO DELETE] iprintln("Thanks to ^2nobody. ^7for helping me update the map :)"); */
	wait 6;
	/* [AUTO DELETE] iprintln("Thanks ^6Puncake ^7and ^6Pares928 ^7for being my support!"); */
	wait 60;
	/* [AUTO DELETE] iprintln("^3Beeeeeeeeeeeeee     ^7-Kecske 2014"); */
	/* [AUTO DELETE] iprintln("^3Beeeeeeeeeeeeee     ^7-Kecske 2014"); */
	/* [AUTO DELETE] iprintln("^3Beeeeeeeeeeeeee     ^7-Kecske 2014"); */
}


	knife_room_BATTLE()
{
	level.knife_trig = getEnt( "knife_room_end", "targetname");
	jump = getEnt( "knife_room_enter", "targetname" );
	acti = getEnt( "knife_room_acti", "targetname" );

	while(1)
	{
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
		return;

		ambientStop("0");
		wait 0.05 ;
		/* [AUTO DELETE] ambientPlay("getoboys"); */

		level.canPlaySound = false;

		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Still - Geto Boys^2]] ^1>>>"); */
		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Still - Geto Boys^2]] ^1>>>"); */
		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Still - Geto Boys^2]] ^1>>>"); */


		level.jump_trig delete();
		level.sniper_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */


		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */
		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Knife room." ); */
		wait 0.05;
		/* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
		/* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1Finish his throat^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);
                player died();

	}
}


	sniper_room_BATTLE()
{
	level.sniper_trig = getEnt( "sniper_room_end", "targetname");
	jump = getEnt( "sniper_room_enter", "targetname" );
	acti = getEnt( "sniper_room_acti", "targetname" );

	while(1)
	{
		level.sniper_trig waittill( "trigger", player );
		if( !isDefined( level.sniper_trig ) )
		return;

		ambientStop("0");
		wait 0.05;
		/* [AUTO DELETE] ambientPlay("weare"); */

		level.canPlaySound = false;

		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 We Are - Hollywood Undead^2]] ^1>>>"); */
		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 We Are - Hollywood Undead^2]] ^1>>>"); */
		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5 We Are - Hollywood Undead^2]] ^1>>>"); */

		level.jump_trig delete();
		level.knife_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] player givemaxammo( "remington700_mp" ); */


		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] level.activ givemaxammo( "remington700_mp" ); */

		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Sniper room." ); */
		wait 0.05;
		/* [AUTO DELETE] player switchToWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] level.activ SwitchToWeapon( "remington700_mp" ); */
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                wait 1;
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1Snip Him Down^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);
                player died();

	}
}


	jump_room_BATTLE()
{
	level.jump_trig = getEnt( "jump_room_end", "targetname");
	jump = getEnt( "jump_room_enter", "targetname" );
	acti = getEnt( "jump_room_acti", "targetname" );

	while(1)
	{
		level.jump_trig waittill( "trigger", player );
		if( !isDefined( level.jump_trig ) )
		return;

		ambientStop("0");
		/* [AUTO DELETE] wait 0.05; */
		/* [AUTO DELETE] ambientPlay("zomboy"); */

		level.canPlaySound = false;

		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Bad Intentions - Zomboy^2]] ^1>>>"); */
		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Bad Intentions - Zomboy^2]] ^1>>>"); */
		/* [AUTO DELETE] iprintln("<<< ^3Now playing ^2[[^5Bad Intentions - Zomboy^2]] ^1>>>"); */

		level.knife_trig delete();
		level.sniper_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */


		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */
		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5Entered Bounce room." ); */
		/* [AUTO DELETE] wait 0.05; */
		/* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
		/* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
		player freezecontrols(true);
		level.activ freezecontrols(true);
		/* [AUTO DELETE] wait 1; */
		/* [AUTO DELETE] player iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^53" ); */
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^52" ); */
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^51" ); */
                /* [AUTO DELETE] wait 1; */
                /* [AUTO DELETE] player iPrintlnBold( "^1FIGHT^9!" ); */
                /* [AUTO DELETE] level.activ iPrintlnBold( "^1Go get the R700^9!" ); */
                player freezecontrols(false);
                level.activ freezecontrols(false);
                player died();

	}
}


	died()
{
        self endon("disconnect");

        self waittill("death");
        /* [AUTO DELETE] iPrintlnBold("^2"+self.name+" ^5died^1!"); */
}


	finished_map()
{
	trigger = getent("finished_map","targetname");
		trigger waittill ("trigger" , player );
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 69); */
		/* [AUTO DELETE] iprintln( " ^6" + player.name + " ^5Finished map!" ); */
}


	teddy_shoot()
{
	trigger = getent("trigger_secret","targetname");
	for(;;)
	{
		trigger waittill ("trigger" , player );
		/* [AUTO DELETE] iPrintlnBold ("^1Why you shoot my  ^7teddy^5bear ^1?!"); */
	}
}


	acti_xp1()
{
	trigger = getent("acti_xp1","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 50); */
}


	deagle_machine()
{
	trigger = getEnt ( "deagle_machine", "targetname" );
	for(;;)
        {
                trigger waittill ( "trigger", player );
                wait 0.05;
                /* [AUTO DELETE] player giveWeapon ( "deserteagle_mp" ); */
                /* [AUTO DELETE] player switchToWeapon ( "deserteagle_mp" ); */
                /* [AUTO DELETE] player giveMaxAmmo ( "deserteagle_mp" ); */
		wait 1;
	}
}


	secret_21()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


	secret_21_key()
{
	trigger = getent("trigger_secret_21_key","targetname");
	object = getent("secret_21_key","targetname");
	trigger waittill ("trigger" , player );
	/* [AUTO DELETE] player iPrintlnBold(" ^3Something has moved... "); */
		object movex(-69, 5);
		object waittill("movedone");
}


	secret_21_out()
{
	trigger = getent("secret_21_out","targetname");
	object = getent("secret_21_key","targetname");
	self waittill( "trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 250); */
	/* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */
	/* [AUTO DELETE] player switchToWeapon ( "knife_mp" ); */
	entTarget = getEnt( self.target, "targetname" );
	wait 0.1;
	player setOrigin( entTarget.origin );
	player setplayerangles( entTarget.angles );
	wait 0.1;
	object movex(69, 3);
	/* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */
}


	jumpers_secret2()
{
	trigger = getent("jumpers_secret1","targetname");
	wall = getent("swagster","targetname");
	object = getent("jumpers_secret_ladder","targetname");
	trigger waittill( "trigger", player );
	wall solid();
	object movez(300,0.1);
	object waittill("movedone");

}

	jumpers_secret1()
{
	for(;;)
	{
		self waittill( "trigger", player );
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 250); */
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}
