//Map by _G4rG4m3l_
//Credits to Lootje for his tutos and help !
//Credits to Sux Lolz for run room help !
//Feel free to give your feedbacks !
//Enjoy !

//to do list(script): timer; freerun fix

main()
{
maps\mp\_load::main();

	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawnOrigin(auto_spawn[int(auto_spawn.size / 2)].origin,
			auto_spawn[int(auto_spawn.size / 2)].angles[1]);

thread sr\api\_speedrun::createEndMap((33733, -2495, 2300), 300, 150);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

	setdvar("r_drawDecals" ,"1");
	setdvar("r_specularcolorscale" ,"1");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	
	precacheItem("ak74u_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	precacheItem("tomahawk_mp");
	precacheItem("ak47_mp");
	precacheItem("rpg_mp");
	precacheItem("m60e4_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("winchester1200_mp");
	precacheItem("uzi_mp");
	
	addTriggerToList( "trigger_trap1" );
	addTriggerToList( "trigger_trap2" );
	addTriggerToList( "trigger_trap3" );
	addTriggerToList( "trigger_trap4" );
	addTriggerToList( "trigger_trap5" );
	addTriggerToList( "trigger_trap6" );
	addTriggerToList( "trigger_trap7" );
	addTriggerToList( "trigger_trap8" );
	addTriggerToList( "trigger_trap9" );
	addTriggerToList( "trigger_trap10" );
	addTriggerToList( "trigger_trap11" );
	addTriggerToList( "reward" );
	
	//START
	// thread messages();
	thread startdoor();
	//MUSICS
	// thread mapmusic();
	//ACTIVE TRAPS FROM START
	// thread cylinder();
	//TRAPS
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
	//TELEPORTS
	thread teleport1();
	thread teleport2();
	thread teleport3();
	thread teleport4();
	thread teleport5();
	thread teleport6();
	thread teleport7();
	thread teleport8();
	thread teleport9();
	thread teleport10();
	thread teleport11();
	thread teleport12();
	thread teleport13();
	thread teleport15();
	thread teleport16();
	thread teleport17();
	thread teleport18();
	thread teleport19();
	thread teleport20();
	thread teleport21();
	thread teleport22();
	thread teleport23();
	thread teleport24();
	thread teleport25();
	thread teleport26();
	thread teleport27();
	thread teleport28();
	thread teleport29();
	thread teleport30();
	thread teleport31();
	thread teleport32();
	thread teleport33();
	thread teleport34();
	thread teleport35();
	thread teleport36();
	thread teleport37();
	thread teleport38();
	//END
	thread ending();
	thread endoor();
	thread endmap();
	//ENDROOMS
	// thread old();
	// thread sniper();
	// thread knife();
	// thread bounce();
	// // thread bounce_weapon();
	// thread bounce_weapon2();
	// thread bounce_weapon3();
	// thread weapon();
	// thread run();
	//OTHER STUFF
	thread getaweapon();
	thread rpg();
	thread rpg3();
	thread rpg4();
	thread cj();
	thread reward();
	thread freerun();
	thread spawn_player();
	thread hard();
	thread retry();
	thread bounce_retry();
	thread jump();
	thread makelastbouncesafe();
	// thread stuck();
	// thread stuck2();
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////START////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

messages()
{
wait 8;
/* [AUTO DELETE] iprintlnBold("^4Welcome somewhere far ^5Away ^4!"); */
wait 52;
for(;;)
{
	/* [AUTO DELETE] iPrintln("^4Map made by ^5_G4rG4m3l_"); */
	wait 60;
	/* [AUTO DELETE] iPrintln("^5Relax ^4and ^5Enjoy ^4!"); */
	wait 60;
}
}


startdoor()
{
door = getent("startdoor","targetname");
{
// wait 15;
/* [AUTO DELETE] iprintlnBold("^5You're free to go !"); */
wait 0.01;
door delete();
}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////TRAPS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

trap1()
{
	level endon("trigger");
	t1 = getent("trap1", "targetname");
	trig = getent("trigger_trap1", "targetname");
	trig SetHintString("^1Rotate the brush");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	trig delete();
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		for(;;)
		{
			wait 0.01;
			t1 rotateroll(-360, 3);
			wait 3.29;
		}
	}
}


trap2()
{
	level endon("trigger");
	t21 = getent("trap2_1", "targetname");
	t22 = getent("trap2_2", "targetname");
	trig = getent("trigger_trap2", "targetname");
	trig SetHintString("^1Remove two platforms");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		x = randomInt(2);
		if(x == 0)
		{
			t21 delete();
		}
		else if(x == 1)
		{
			t22 delete();
		}
		
		trig delete();
	}
}


trap3()
{
	level endon("trigger");
	t3 = getent("trap3", "targetname");
	trig = getent("trigger_trap3", "targetname");
	trig SetHintString("^1Make them bounce");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
	t3 delete();
	
	trig delete();
	}
}


trap4()
{
	level endon("trigger");
	t4 = getent("trap4", "targetname");
	trig = getent("trigger_trap4", "targetname");
	trig SetHintString("^1Make them fall");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		trig delete();
		for(;;)
		{
			wait 0.1;
			t4 moveY(736, 4);
			wait 4;
			t4 moveY(-736, 4);
			wait 3.9;
		}
	}
}


trap5()
{
	level endon("trigger");
	t5 = getent("trap5", "targetname");
	trig = getent("trigger_trap5", "targetname");
	origin = getent("origin_trap5", "targetname");
	
	trig SetHintString("^1Make them strafe");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		Earthquake( 0.3, 3, origin.origin, 850 );
		t5 moveZ(-5000, 20);
		wait 20;
		t5 delete();
		
		trig delete();
	}
}


trap6()
{
	level endon("trigger");
	t6 = getent("trap6", "targetname");
	trig = getent("trigger_trap6", "targetname");
	trig SetHintString("^1Rotate");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		trig delete();
		for(;;)
		{
			wait 0.01;
			t6 rotatepitch(360, 4);
			wait 8;
		}
	}
}


trap7()
{
	level endon("trigger");
	t7 = getent("trap7", "targetname");
	trig = getent("trigger_trap7", "targetname");
	trig SetHintString("^1Do some magic");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		t7 notSolid();
		
		trig delete();
	}
}


trap8()
{
	level endon("trigger");
	t8 = getent("trap8", "targetname");
	trig = getent("trigger_trap8", "targetname");
	trig SetHintString("^1Rotate the bounce");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		trig delete();
		for(;;)
		{
			wait 0.1;
			t8 rotateroll(360, 4);
			wait 6.9;
		}
	}
}


trap9()
{
	level endon("trigger");
	t9 = getent("trap9", "targetname");
	trig = getent("trigger_trap9", "targetname");
	trig SetHintString("^1Make the floor disappear");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		t9 delete();
		
		trig delete();
	}
}


trap10()
{
	level endon("trigger");
	t10 = getent("trap10", "targetname");
	trig = getent("trigger_trap10", "targetname");
	trig SetHintString("^1Roll the bounce");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		trig delete();
		for(;;)
		{
			wait 0.1;
			t10 rotateroll(720, 4);
			wait 4.9;
		}
	}
}


trap11()
{
	level endon("trigger");
	t11_1 = getent("trap11_1", "targetname");
	t11_2 = getent("trap11_2", "targetname");
	t11_3 = getent("trap11_3", "targetname");
	t11_4 = getent("trap11_4", "targetname");
	trig = getent("trigger_trap11", "targetname");
	trig SetHintString("^1They shall not pass!");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	activator = level.activ;
	trig2 waittill("trigger", player);
	trig waittill("trigger", activator);
	
	if(level.trapsdisabled)
	{
		trig SetHintString("^5Traps ^4are ^5Disabled ^4!");
	}
	else
	{
		trig delete();
		for(;;)
		{
			wait 0.1;
			t11_1 rotateYaw(-360, 3);
			t11_2 rotateYaw(-360, 3);
			t11_3 rotateYaw(360, 2);
			t11_4 rotateYaw(360, 3);
			wait 1.9;
		}
	}
}




////////////////////////////////////////////////////////////////////////////////////////////////////////TELEPORTS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

teleport1()
{
	trig = getent("trigger_teleport1", "targetname");
	tele1 = getent("origin_teleport1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele1.angles);
		player setOrigin(tele1.origin);
	}
}


teleport2()
{
	trig = getent("trigger_teleport2", "targetname");
	tele2 = getent("origin_teleport2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele2.angles);
		player setOrigin(tele2.origin);
	}
}


teleport3()
{
	trig = getent("trigger_teleport3", "targetname");
	tele3 = getent("origin_teleport3", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele3.angles);
		player setOrigin(tele3.origin);
	}
}


teleport4()
{
	trig = getent("trigger_teleport34", "targetname");
	tele4 = getent("origin_teleport4", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele4.angles);
		player setOrigin(tele4.origin);
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Found The ^5Third Secret ^4!"); */
		// player thread SecretTimer();
	}
}

teleport5()
{
	trig = getent("trigger_teleport5", "targetname");
	tele5 = getent("origin_teleport5", "targetname");
	ladder = getent("ladder", "targetname");
	ladder2 = getent("ladder2", "targetname");
	
	ladder moveZ(-900, 0.1);
	ladder2 moveZ(-900, 0.1);

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player setPlayerAngles(tele5.angles);
		player setOrigin(tele5.origin);
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Found The ^5First Secret ^4!"); */
		// player thread SecretTimer();
	}
}


teleport6()
{
	trig = getent("trigger_teleport6", "targetname");
	tele6 = getent("origin_teleport6", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele6.angles);
		player setOrigin(tele6.origin);
	}
}


teleport7()
{
	trig = getent("trigger_teleport7", "targetname");
	tele7 = getent("origin_teleport7", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele7.angles);
		player setOrigin(tele7.origin);
	}
}


teleport8()
{
	trig = getent("trigger_teleport8", "targetname");
	tele8 = getent("origin_teleport8", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele8.angles);
		player setOrigin(tele8.origin);
		player freezecontrols(true);
		/* [AUTO DELETE] wait 0.1; */
		player freezecontrols(false);
	}
}


teleport9()
{
	trig = getent("trigger_teleport9", "targetname");
	tele9 = getent("origin_teleport9", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
		
		player.secret_finished = true;
        player.secret_timer Destroy();
		
		player setPlayerAngles(tele9.angles);
		player setOrigin(tele9.origin);
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Finished The ^5First Secret ^4!"); */
	}
}


teleport10()
{
	trig = getent("trigger_teleport10", "targetname");
	tele10 = getent("origin_teleport36", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		player.secret_finished = true;
        player.secret_timer Destroy();
		
		player setPlayerAngles(tele10.angles);
		player setOrigin(tele10.origin);
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Finished The ^5Third Secret ^4!"); */
	}
}


teleport11()
{
	trig = getent("trigger_teleport11", "targetname");
	tele11 = getent("origin_teleport11", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele11.angles);
		player setOrigin(tele11.origin);
	}
}


teleport12()
{
	trig = getent("trigger_teleport12", "targetname");
	tele12 = getent("origin_teleport12", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele12.angles);
		player setOrigin(tele12.origin);
	}
}


teleport13()
{
	trig = getent("trigger_teleport13", "targetname");
	tele13 = getent("origin_teleport13", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele13.angles);
		player setOrigin(tele13.origin);
	}
}


teleport14()
{
	trig = getent("trigger_teleport14", "targetname");
	tele14 = getent("origin_teleport14", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele14.angles);
		player setOrigin(tele14.origin);
	}
}


teleport15()
{
	trig = getent("trigger_teleport15", "targetname");
	tele15 = getent("origin_teleport15", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele15.angles);
		player setOrigin(tele15.origin);
	}
}


teleport16()
{
	trig = getent("trigger_teleport16", "targetname");
	tele16 = getent("origin_teleport16", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele16.angles);
		player setOrigin(tele16.origin);
	}
}


teleport17()
{
	trig = getent("trigger_teleport17", "targetname");
	tele17 = getent("origin_teleport17", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele17.angles);
		player setOrigin(tele17.origin);
	}
}


teleport18()
{
	trig = getent("trigger_teleport18", "targetname");
	tele18 = getent("origin_teleport18", "targetname");
	
	for(;;)
	{
		trig SetHintString("^4Press ^5[use] ^4to enter the bounce training room !");
		trig waittill("trigger", player);
		player setPlayerAngles(tele18.angles);
		player setOrigin(tele18.origin);
	}
}


teleport19()
{
	trig = getent("trigger_teleport19", "targetname");
	tele19 = getent("origin_teleport19", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele19.angles);
		player setOrigin(tele19.origin);
	}
}


teleport20()
{
	trig = getent("trigger_teleport20", "targetname");
	tele20 = getent("origin_teleport20", "targetname");
	
	for(;;)
	{
		trig SetHintString("^4Press ^5[use] ^4to leave the training room !");
		trig waittill("trigger", player);
		player setPlayerAngles(tele20.angles);
		player setOrigin(tele20.origin);
	}
}


teleport21()
{
	trig = getent("trigger_teleport21", "targetname");
	tele21 = getent("origin_teleport21", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele21.angles);
		player setOrigin(tele21.origin);
		/* [AUTO DELETE] player iprintlnBold("^5You ^4Have Completed The ^5Bounce Training Room ^4!"); */
	}
}


teleport22()
{
	trig = getent("trigger_teleport22", "targetname");
	tele22 = getent("origin_teleport22", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele22.angles);
		player setOrigin(tele22.origin);
	}
}


teleport23()
{
	trig = getent("trigger_teleport23", "targetname");
	tele23 = getent("origin_teleport23", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele23.angles);
		player setOrigin(tele23.origin);
	}
}


teleport24()
{
	trig = getent("trigger_teleport24", "targetname");
	tele24 = getent("origin_teleport24", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele24.angles);
		player setOrigin(tele24.origin);
	}
}


teleport25()
{
	trig = getent("trigger_teleport25", "targetname");
	tele25 = getent("origin_teleport25", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele25.angles);
		player setOrigin(tele25.origin);
	}
}


teleport26()
{
	trig = getent("trigger_teleport26", "targetname");
	tele26 = getent("origin_teleport26", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele26.angles);
		player setOrigin(tele26.origin);
	}
}


teleport27()
{
	trig = getent("trigger_teleport27", "targetname");
	tele27 = getent("origin_teleport27", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele27.angles);
		player setOrigin(tele27.origin);
	}
}


teleport28()
{
	trig = getent("trigger_teleport28", "targetname");
	tele28 = getent("origin_teleport28", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele28.angles);
		player setOrigin(tele28.origin);
	}
}


teleport29()
{
	trig = getent("trigger_teleport29", "targetname");
	tele29 = getent("origin_teleport29", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele29.angles);
		player setOrigin(tele29.origin);
	}
}


teleport30()
{
	trig = getent("trigger_teleport30", "targetname");
	tele30 = getent("origin_teleport30", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele30.angles);
		player setOrigin(tele30.origin);
	}
}


teleport31()
{
	trig = getent("trigger_teleport31", "targetname");
	tele31 = getent("origin_teleport31", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele31.angles);
		player setOrigin(tele31.origin);
	}
}


teleport32()
{
	trig = getent("trigger_teleport32", "targetname");
	tele32 = getent("origin_teleport32", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele32.angles);
		player setOrigin(tele32.origin);
	}
}


teleport33()
{
	trig = getent("trigger_teleport33", "targetname");
	tele33 = getent("origin_teleport33", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele33.angles);
		player setOrigin(tele33.origin);
	}
}


teleport34()
{
	trig = getent("trigger_teleport4", "targetname");
	tele34 = getent("origin_teleport34", "targetname");
	secret = getent("trigger_lever", "targetname");
	lever = getent("lever", "targetname");
	
	secret waittill("trigger", player);
	secret delete();
	lever rotatepitch(-90, 0.1);
	/* [AUTO DELETE] player iPrintlnBold("^4Second secret entrance opened."); */
	/* [AUTO DELETE] iPrintln("^4Second secret entrance opened."); */
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele34.angles);
		player setOrigin(tele34.origin);
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Found The ^5Second Secret ^4!"); */
		player SetClientDvar("g_speed" ,"500");
		// player thread SecretTimer();
	}
}


teleport35()
{
	trig = getent("trigger_teleport35", "targetname");
	tele34 = getent("origin_teleport34", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele34.angles);
		player setOrigin(tele34.origin);
		player freezecontrols(true);
		/* [AUTO DELETE] wait 0.1; */
		player freezecontrols(false);
	}
}


teleport36()
{
	trig = getent("trigger_teleport36", "targetname");
	tele36 = getent("origin_teleport10", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		player.secret_finished = true;
        player.secret_timer Destroy();
		
		player setPlayerAngles(tele36.angles);
		player setOrigin(tele36.origin);
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Completed The ^5Second Secret ^4!"); */
		player SetClientDvar("g_speed" ,"210");
		/* [AUTO DELETE] player GiveWeapon("ak74u_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("ak74u_mp"); */
		/* [AUTO DELETE] wait .05; */
		/* [AUTO DELETE] player SwitchToWeapon("ak74u_mp"); */
		player freezecontrols(true);
		/* [AUTO DELETE] wait 0.1; */
		player freezecontrols(false);
	}
}


teleport37()
{
	trig = getent("trigger_freerun", "targetname");
	tele37 = getent("origin_teleport1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele37.angles);
		player setOrigin(tele37.origin);
	}
}


teleport38()
{
	trig = getent("trigger_teleport38", "targetname");
	tele38 = getent("origin_teleport38", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele38.angles);
		player setOrigin(tele38.origin);
		player freezecontrols(true);
		/* [AUTO DELETE] wait 0.1; */
		player freezecontrols(false);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////TRAPS ACTIVED FROM START/////////////////////////////////////////////////////////////////////////////////////////////////////////////

cylinder()
{
	cyl = getent("cylinder", "targetname");
	
	for(;;)
	{
		wait 0.1;
		cyl rotateYaw(360, 10);
		wait 9.9;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////END////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ending()
{
	trig = getent("trigger_ending", "targetname");
	trig waittill("trigger", player);
	
	thread ending1();
	thread ending2();
	thread ending3();
	thread ending4();
}


ending1()
{
	pf = getent("ending1", "targetname");
	
	for(;;)
	{
		wait 0.1;
		pf moveY(1280, 5);
		wait 10;
		pf moveX(-2208, 5);
		wait 10;
		pf moveY(-2880, 5);
		wait 10;
		pf moveX(992, 1);
		wait 1;
		pf moveY(1641, 2);
		wait 2;
		pf moveX(1216, 2);
		wait 6.9;
	}
}


ending2()
{
	pf = getent("ending2", "targetname");
	
	for(;;)
	{
		wait 0.1;
		pf moveX(-2208, 5);
		wait 10;
		pf moveY(-2880, 5);
		wait 10;
		pf moveX(992, 1);
		wait 1;
		pf moveY(1641, 2);
		wait 2;
		pf moveX(1216, 2);
		wait 7;
		pf moveY(1280, 5);
		wait 9.9;
	}
}


ending3()
{
	pf = getent("ending3", "targetname");
	
	for(;;)
	{
		wait 0.1;
		pf moveY(-2880, 5);
		wait 10;
		pf moveX(992, 1);
		wait 1;
		pf moveY(1641, 2);
		wait 2;
		pf moveX(1216, 2);
		wait 7;
		pf moveY(1280, 5);
		wait 10;
		pf moveX(-2208, 5);
		wait 9.9;
	}
}


ending4()
{
	pf = getent("ending4", "targetname");
	
	for(;;)
	{
		wait 0.1;
		pf moveX(992, 1);
		wait 1;
		pf moveY(1641, 2);
		wait 2;
		pf moveX(1216, 2);
		wait 7;
		pf moveY(1280, 5);
		wait 10;
		pf moveX(-2208, 5);
		wait 10;
		pf moveY(-2880, 5);
		wait 9.9;
	}
}


endoor()
{
	d1 = getent("endoor1", "targetname");
	d2 = getent("endoor2", "targetname");
	trig = getent("trigger_endoor", "targetname");
	trig waittill("trigger", player);
	
	d1 rotateYaw(90, 2);
	d2 rotateYaw(-90, 2);
	/* [AUTO DELETE] iprintlnBold("^5" + player.name + " ^4Has Opened ^5The Doors ^4!"); */
	trig delete();
}


endmap()
{
	trig = getent("trigger_thebigtrigger", "targetname");
	trig2 = getent("timer_stop", "targetname");
	
	trig waittill("trigger", player);
	trig2 waittill("trigger", player);
	/* [AUTO DELETE] player iPrintlnBold("^5You ^4have finished the map !"); */
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////ENDROOMS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

old()
{
	level.old_trigger = getent("trigger_old", "targetname");
	level.sniper_trigger = getent("trigger_sniper", "targetname");
	level.bounce_trigger = getent("trigger_bounce", "targetname");
	level.knife_trigger = getent("trigger_knife", "targetname");
	level.weapon_trigger = getent("trigger_weapon", "targetname");
	level.run_trigger = getent("trigger_run", "targetname");
	door = getent("olddoor", "targetname");
	level.old_trigger waittill("trigger", player);
		
		{
		level.old_trigger delete();
		level.sniper_trigger delete();
		level.bounce_trigger delete();
		level.knife_trigger delete();
		level.weapon_trigger delete();
		level.run_trigger delete();
		
		/* [AUTO DELETE] iprintlnBold("^5" + player.name + "^4Has Opened The ^5Old Way ^4!"); */
		wait 1;
		thread teleport14();
		}
}


sniper()
{
	level.old_trigger = getent("trigger_old", "targetname");
	level.sniper_trigger = getent("trigger_sniper", "targetname");
	level.bounce_trigger = getent("trigger_bounce", "targetname");
	level.knife_trigger = getent("trigger_knife", "targetname");
	level.weapon_trigger = getent("trigger_weapon", "targetname");
	level.run_trigger = getent("trigger_run", "targetname");
	level.teleactorigin = getent("sniper_activator", "targetname");
	telejumporigin = getent("sniper_jumper", "targetname");

		while(1)
		{
			level.sniper_trigger waittill("trigger", player);

			if(!isDefined(level.sniper_trigger))
					return;
			if(level.firstenter==true)
		{
		level.old_trigger delete();
		level.bounce_trigger delete();
		level.knife_trigger delete();
		level.weapon_trigger delete();
		level.run_trigger delete();
		
		ambientStop(0);
		/* [AUTO DELETE] ambientPlay("ftw"); */
		
		player SetOrigin(telejumporigin.origin);
		player setplayerangles(telejumporigin.angles);
		level.activ SetOrigin(level.teleactorigin.origin);
		level.activ setplayerangles(level.teleactorigin.angles);
			
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^53"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^53"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^52"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^52"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^51"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^51"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^5GO^1!"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^5Go^1!"); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
			
		level.firstenter=false;
		}
		wait 0.05;

		player SetOrigin(telejumporigin.origin);
		player setplayerangles(telejumporigin.angles);
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player GiveWeapon("m40a3_mp"); */
		/* [AUTO DELETE] player GiveWeapon("remington700_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("m40a3_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("remington700_mp"); */
		player.maxhealth = 100;
		wait 0.05;
		/* [AUTO DELETE] player SwitchToWeapon("m40a3_mp"); */
		wait 0.05;
		level.activ SetOrigin(level.teleactorigin.origin);
		level.activ setplayerangles(level.teleactorigin.angles);
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ GiveWeapon("m40a3_mp"); */
		/* [AUTO DELETE] level.activ GiveWeapon("remington700_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("m40a3_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("remington700_mp"); */
		level.activ.maxhealth = 100;
		wait 0.05;
		/* [AUTO DELETE] level.activ SwitchToWeapon("m40a3_mp"); */
		/* [AUTO DELETE] iPrintlnBold("^5" + player.name + " ^4Has Entered The ^5Sniper Room ^4!"); */
		wait 0.05;
		/* [AUTO DELETE] player SwitchToWeapon("m40a3_mp"); */
		/* [AUTO DELETE] level.activ SwitchToWeapon("m40a3_mp"); */
		
		thread sniper_donotmelee();
		
		player waittill("death");
		level.PlayerInRoom = false;

		}
}


sniper_donotmelee()
{
	self endon("disconnect");
	self endon("killed_player");
	self endon("death");
	self endon("joined_spectators");
	
	trig = getent("trigger_donotmelee", "targetname");
	trig waittill("trigger", player);
	
	for(;;)
	{
		if ( player MeleeButtonPressed() )
			{
				/* [AUTO DELETE] player iPrintlnBold("^4Do Not ^5Melee ^4!"); */
				player suicide();
				self notify("killed_player");
				wait 0.1;
				
			}
		wait 0.1;
	}
}


knife()
{

	level.old_trigger = getent("trigger_old", "targetname");
	level.sniper_trigger = getent("trigger_sniper", "targetname");
	level.bounce_trigger = getent("trigger_bounce", "targetname");
	level.knife_trigger = getent("trigger_knife", "targetname");
	level.weapon_trigger = getent("trigger_weapon", "targetname");
	level.run_trigger = getent("trigger_run", "targetname");
	acti = getEnt("knife_activator", "targetname"); 
	jump = getEnt("knife_jumper", "targetname"); 

		while(1)
     	{
         	level.knife_trigger waittill("trigger", player);
			


         	if(!isDefined(level.knife_trigger))
         	return;
			if(level.firstenter==true)
		{
		level.old_trigger delete();
		level.bounce_trigger delete();
		level.sniper_trigger delete();
		level.weapon_trigger delete();
		level.run_trigger delete();
		
		ambientStop(0);
		/* [AUTO DELETE] ambientplay("hello"); */
		
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^53"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^53"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^52"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^52"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^51"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^51"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^5GO^1!"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^5Go^1!"); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		
		level.firstenter=false;
		}	
		wait 0.05;

		player SetOrigin(jump.origin);
		player setplayerangles(jump.angles);
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player GiveWeapon("knife_mp"); */ 
		player.maxhealth = 100;
		wait(0.05);
		level.activ SetOrigin (acti.origin);
		level.activ setplayerangles (acti.angles);
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ GiveWeapon("knife_mp"); */
		level.activ.maxhealth = 100;		
		wait(0.05);
		/* [AUTO DELETE] player switchToWeapon("knife_mp"); */
		/* [AUTO DELETE] level.activ SwitchToWeapon("knife_mp"); */
		/* [AUTO DELETE] iPrintlnBold("^5" + player.name + " ^4Has Entered The ^5Knife Room ^4!"); */
		player waittill("death");
		level.PlayerInRoom = false;
		}
}
	

bounce()
{
 	level.old_trigger = getent("trigger_old", "targetname");
	level.sniper_trigger = getent("trigger_sniper", "targetname");
	level.bounce_trigger = getent("trigger_bounce", "targetname");
	level.knife_trigger = getent("trigger_knife", "targetname");
	level.weapon_trigger = getent("trigger_weapon", "targetname");
	level.run_trigger = getent("trigger_run", "targetname");
	jump = getEnt("bounce_jumper", "targetname");
	acti = getEnt("bounce_activator", "targetname");
		
		while(1)
     	{
         	level.bounce_trigger waittill("trigger", player);
			


         	if(!isDefined(level.bounce_trigger))
         	return;
			if(level.firstenter==true)
		{
		level.old_trigger delete();
		level.sniper_trigger delete();
		level.knife_trigger delete();
		level.weapon_trigger delete();
		level.run_trigger delete();
		
		ambientStop(0);
		/* [AUTO DELETE] ambientPlay("soda"); */
		
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^53"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^53"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^52"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^52"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^51"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^51"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^5GO^1!"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^5Go^1!"); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		
		level.firstenter=false;
		}	
		wait(0.05);
			
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player giveweapon("tomahawk_mp"); */
		player.maxhealth = 100;
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ giveweapon("tomahawk_mp"); */
		level.activ.maxhealth = 100;
		/* [AUTO DELETE] iPrintlnBold("^5" + player.name + " ^4Has Entered The ^5Bounce Room ^4!"); */         
		wait 0.05;	
		/* [AUTO DELETE] level.activ switchtoweapon("tomahawk_mp"); */
		/* [AUTO DELETE] player switchtoweapon("tomahawk_mp"); */
		
		player waittill( "death" );
		level.PlayerInRoom = false;
			
     	}
}


bounce_weapon()
{
 
	trig = getent("bounce_weapon", "targetname");
		
        while(1)
        {
				trig SetHintString("^4Press ^5[use] ^4to get a sniper !");
                trig waittill("trigger", player);
                /* [AUTO DELETE] player GiveWeapon("m40a3_mp"); */      
				/* [AUTO DELETE] player GiveMaxAmmo("m40a3_mp"); */
                /* [AUTO DELETE] player switchToWeapon("m40a3_mp"); */
				wait 1;
        }
}


bounce_weapon2()
{
 
	trig = getent("step1_1", "targetname");
	trig2 = getent("step2_1", "targetname");
	trig3 = getent("step3_1", "targetname");
	start =getent("bounce_weapon_start", "targetname");
	start waittill("trigger", player);
        while(1)
        {
                trig waittill("trigger", player);
				trig2 waittill("trigger", player);
				trig3 waittill("trigger", player);
                /* [AUTO DELETE] player GiveWeapon("ak47_mp"); */      
				/* [AUTO DELETE] player GiveMaxAmmo("ak47_mp"); */
                /* [AUTO DELETE] player switchToWeapon("ak47_mp"); */
				wait 1;
        }
}


bounce_weapon3()
{
	start =getent("bounce_weapon_start", "targetname");
	trig = getent("step1_2", "targetname");
	trig2 = getent("step2_2", "targetname");
	trig3 = getent("step3_2", "targetname");
	activator = level.activ;
	start waittill("trigger", player);
		
        while(1)
        {
                trig waittill("trigger", activator);
				trig2 waittill("trigger", activator);
				trig3 waittill("trigger", activator);
                /* [AUTO DELETE] activator GiveWeapon("ak47_mp"); */      
				/* [AUTO DELETE] activator GiveMaxAmmo("ak47_mp"); */
                /* [AUTO DELETE] activator switchToWeapon("ak47_mp"); */
				wait 1;
        }
}


weapon()
{
 	level.old_trigger = getent("trigger_old", "targetname");
	level.sniper_trigger = getent("trigger_sniper", "targetname");
	level.bounce_trigger = getent("trigger_bounce", "targetname");
	level.knife_trigger = getent("trigger_knife", "targetname");
	level.weapon_trigger = getent("trigger_weapon", "targetname");
	level.run_trigger = getent("trigger_run", "targetname");
	jump = getEnt("weapon_jumper", "targetname");
	acti = getEnt("weapon_activator", "targetname");
		
		while(1)
     	{
         	level.weapon_trigger waittill("trigger", player);
			


         	if(!isDefined(level.weapon_trigger))
         	return;
			if(level.firstenter==true)
		{
		level.old_trigger delete();
		level.sniper_trigger delete();
		level.knife_trigger delete();
		level.bounce_trigger delete();
		level.run_trigger delete();
		
		ambientStop(0);
		/* [AUTO DELETE] ambientPlay("nitro"); */
		
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^53"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^53"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^52"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^52"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^51"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^51"); */
		wait 1;
		/* [AUTO DELETE] player iPrintlnBold("^5GO^1!"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^5Go^1!"); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		
		level.firstenter=false;
		}	
		wait 0.05;
			
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		/* [AUTO DELETE] player TakeAllWeapons(); */
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		
		x = randomInt(6);
		if(x == 0)
		{
		/* [AUTO DELETE] player giveweapon("rpg_mp"); */
		/* [AUTO DELETE] player switchtoweapon("rpg_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("rpg_mp"); */
		/* [AUTO DELETE] level.activ giveweapon("rpg_mp"); */
		/* [AUTO DELETE] level.activ switchtoweapon("rpg_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("rpg_mp"); */
		thread rpg2();
		}
		else if(x == 2)
		{
		/* [AUTO DELETE] player giveweapon("ak47_mp"); */
		/* [AUTO DELETE] player switchtoweapon("ak47_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("ak47_mp"); */
		/* [AUTO DELETE] level.activ giveweapon("ak47_mp"); */
		/* [AUTO DELETE] level.activ switchtoweapon("ak47_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("ak47_mp"); */
		}
		else if(x == 1)
		{
		/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] player switchtoweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("deserteaglegold_mp"); */
		/* [AUTO DELETE] level.activ giveweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] level.activ switchtoweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("deserteaglegold_mp"); */
		}
		
			else if(x == 4)
		{
		/* [AUTO DELETE] player giveweapon("winchester1200_mp"); */
		/* [AUTO DELETE] player switchtoweapon("winchester1200_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("winchester1200_mp"); */
		/* [AUTO DELETE] level.activ giveweapon("winchester1200_mp"); */
		/* [AUTO DELETE] level.activ switchtoweapon("winchester1200_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("winchester1200_mp"); */
		}
		
				else if(x == 3)
		{
		/* [AUTO DELETE] player giveweapon("m60e4_mp"); */
		/* [AUTO DELETE] player switchtoweapon("m60e4_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("m60e4_mp"); */
		/* [AUTO DELETE] level.activ giveweapon("m60e4_mp"); */
		/* [AUTO DELETE] level.activ switchtoweapon("m60e4_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("m60e4_mp"); */
		}
		
				else if(x == 5)
		{
		/* [AUTO DELETE] player giveweapon("uzi_mp"); */
		/* [AUTO DELETE] player switchtoweapon("uzi_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("uzi_mp"); */
		/* [AUTO DELETE] level.activ giveweapon("uzi_mp"); */
		/* [AUTO DELETE] level.activ switchtoweapon("uzi_mp"); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo("uzi_mp"); */
		}    

		player.maxhealth = 100;
		level.activ.maxhealth = 100;
		
		/* [AUTO DELETE] iPrintlnBold("^5" + player.name + " ^4Has Entered The ^5Weapon Room ^4!"); */         
		wait 0.05;
		
		player waittill("death");
		level.PlayerInRoom = false;
			
     	}
}


run()
{
 	level.old_trigger = getent("trigger_old", "targetname");
	level.sniper_trigger = getent("trigger_sniper", "targetname");
	level.bounce_trigger = getent("trigger_bounce", "targetname");
	level.knife_trigger = getent("trigger_knife", "targetname");
	level.weapon_trigger = getent("trigger_weapon", "targetname");
	level.run_trigger = getent("trigger_run", "targetname");
	jump = getEnt("run_jumper", "targetname");
	acti = getEnt("run_activator", "targetname");
	
	trigjump = getent("trigger_teleportrunjumper", "targetname");
	trigacti = getent("trigger_teleportrunactivator", "targetname");
	telejump = getent("origin_teleportrunjumper", "targetname");
	teleacti = getent("origin_teleportrunactivator", "targetname");
		
		while(1)
     	{
         	level.run_trigger waittill("trigger", player);
			


         	if(!isDefined(level.run_trigger))
         	return;
			if(level.firstenter==true)
		{
		level.old_trigger delete();
		level.sniper_trigger delete();
		level.knife_trigger delete();
		level.weapon_trigger delete();
		level.bounce_trigger delete();
		
		ambientStop(0);
		/* [AUTO DELETE] ambientPlay("restart"); */
		
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		/* [AUTO DELETE] wait 1; */
		/* [AUTO DELETE] player iPrintlnBold("^53"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^53"); */
		/* [AUTO DELETE] wait 1; */
		/* [AUTO DELETE] player iPrintlnBold("^52"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^52"); */
		/* [AUTO DELETE] wait 1; */
		/* [AUTO DELETE] player iPrintlnBold("^51"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^51"); */
		/* [AUTO DELETE] wait 1; */
		/* [AUTO DELETE] player iPrintlnBold("^5GO^1!"); */
		/* [AUTO DELETE] level.activ iPrintlnBold("^5Go^1!"); */
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		
		level.firstenter=false;
		}	
		wait(0.05);
			
		player SetPlayerAngles(jump.angles);
		player setOrigin(jump.origin);
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player giveweapon("tomahawk_mp"); */
		player.maxhealth = 100;		
		level.activ setPlayerangles(acti.angles);
		level.activ setOrigin(acti.origin);
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ giveweapon("tomahawk_mp"); */
		level.activ.maxhealth = 100;
		/* [AUTO DELETE] iPrintlnBold("^5" + player.name + " ^4Has Entered The ^5Speedrun Room ^4!"); */         
		/* [AUTO DELETE] wait 0.05; */	
		/* [AUTO DELETE] level.activ switchtoweapon("tomahawk_mp"); */
		/* [AUTO DELETE] player switchtoweapon("tomahawk_mp"); */
		
		thread teleportrunjumper();
		thread teleportrunactivator();
		
		player waittill("death");
		level.PlayerInRoom = false;
			
     	}
}


teleportrunjumper()
{
	jumpwinrun = getent("trigger_teleportrunjumper", "targetname");
	telejump = getent("origin_teleportrunjumper", "targetname");
	teleacti = getent("origin_teleportrunactivator", "targetname");
	
	jumpwinrun waittill("trigger", player);
	
	player SetPlayerAngles(telejump.angles);
	player setOrigin(telejump.origin);
	level.activ setPlayerangles(teleacti.angles);
	level.activ setOrigin(teleacti.origin);
	
	level.activ freezecontrols(true);
	/* [AUTO DELETE] player GiveWeapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] player GiveMaxAmmo("deserteaglegold_mp"); */
	/* [AUTO DELETE] player SwitchToWeapon("deserteaglegold_mp"); */
	
}


teleportrunactivator()
{
	definedjumper = getent("definedjumper", "targetname");
	actiwinrun = getent("teleportrunactivator", "targetname");
	telejump = getent("origin_teleportrunjumper", "targetname");
	teleacti = getent("origin_teleportrunactivator", "targetname");
	
	activator = level.activ;
	
	definedjumper waittill("trigger", player);
	actiwinrun waittill("trigger", activator);
	
	player SetPlayerAngles(telejump.angles);
	player setOrigin(telejump.origin);
	level.activ setPlayerangles(teleacti.angles);
	level.activ setOrigin(teleacti.origin);
	
	player freezecontrols(true);
	/* [AUTO DELETE] level.activ GiveWeapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] level.activ GiveMaxAmmo("deserteaglegold_mp"); */
	/* [AUTO DELETE] level.activ SwitchToWeapon("deserteaglegold_mp"); */
}


///////////////////////////////////////////////////////////////////////////////////////////////////////MUSIC//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

mapmusic()
{
	x = randomInt(6);
	if(x == 0)
    {
		/* [AUTO DELETE] ambientplay("away"); */
		wait 0.02;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Away - Subtact"); */
		wait 0.02;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Away - Subtact"); */
		wait 0.02;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Away - Subtact"); */
	}
    else if(x == 2)
    {
		/* [AUTO DELETE] ambientplay("routine"); */
		wait 4;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Routine - Alan Walker"); */
		wait 0.02;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Routine - Alan Walker"); */
		wait 0.02;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Routine - Alan Walker"); */
	}
    else if(x == 1)
    {
		/* [AUTO DELETE] ambientplay("id"); */
		wait 5;
		/* [AUTO DELETE] iPrintln("^6Song: ^5ID - Kygo"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5ID - Kygo"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5ID - Kygo"); */
    }
	
		else if(x == 4)
    {
		/* [AUTO DELETE] ambientplay("blue"); */
		wait 5;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Blue Heron - William French"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Blue Heron - William French"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Blue Heron - William French"); */
    }
	
			else if(x == 3)
    {
		/* [AUTO DELETE] ambientplay("unity"); */
		wait 5;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Unity - TheFatRat"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Unity - TheFatRat"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Unity - TheFatRat"); */
    }
	
			else if(x == 5)
    {
		/* [AUTO DELETE] ambientplay("afternoon"); */
		wait 5;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Afternoon Soul - Gramatik"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Afternoon Soul - Gramatik"); */
		wait 0.2;
		/* [AUTO DELETE] iPrintln("^6Song: ^5Afternoon Soul - Gramatik"); */
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////OTHER STUFF///////////////////////////////////////////////////////////////////////////////////////////////////////////////

getaweapon()
{
	trig = getEnt("trigger_getaweapon", "targetname");
	
	trig SetHintString("^4Press ^5[use] ^4to get a ^5Deagle ^4!");
	trig waittill("trigger", player);
	/* [AUTO DELETE] player TakeAllWeapons(); */
	/* [AUTO DELETE] player GiveWeapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] player GiveMaxAmmo("deserteaglegold_mp"); */
	/* [AUTO DELETE] player SwitchToWeapon("deserteaglegold_mp"); */
}


rpg()
{
	trig = getent("trigger_thebigtrigger", "targetname");
	trig waittill("trigger", player);
	for(;;)
	{
		/* [AUTO DELETE] player GiveMaxAmmo("rpg_mp"); */
		wait 1;
	}
}


rpg2()
{
	trig = getent("rpg2", "targetname");
	activator = level.activ;
	trig waittill("trigger", player);
	
	for(;;)
	{
		/* [AUTO DELETE] player GiveMaxAmmo("rpg_mp"); */
		/* [AUTO DELETE] activator GiveMaxAmmo("rpg_mp"); */
		wait 1;
	}
}


rpg3()
{
	trig = getent("rpg3", "targetname");
	
	for(;;)
	{
		
		trig waittill("trigger", player);
		/* [AUTO DELETE] player GiveWeapon("rpg_mp"); */
		/* [AUTO DELETE] player SwitchToWeapon("rpg_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("rpg_mp"); */
		wait 1;
	}
}


rpg4()
{
	trig = getent("rpg4", "targetname");
	
	for(;;)
	{
		
		trig waittill("trigger", player);
		/* [AUTO DELETE] player GiveWeapon("rpg_mp"); */
		/* [AUTO DELETE] player SwitchToWeapon("rpg_mp"); */
		/* [AUTO DELETE] player GiveMaxAmmo("rpg_mp"); */
		wait 1;
	}
}


cj()
{
	trig1 = getent("trigger_cj", "targetname");
	trig2 = getent("trigger_cj2", "targetname");
	trig3 = getent("trigger_retry", "targetname");
	origin = getent("origin_retry", "targetname");
	
	trig1 waittill("trigger", player);
	trig2 waittill("trigger", player);
	
	for(;;)
	{
		trig3 SetHintString("^4Press ^5[use] ^4to ^5retry ^4!");
		trig3 waittill("trigger", player);
		player setPlayerAngles(origin.angles);
		player setOrigin(origin.origin);
	}
}


reward()
{
	trig1 = getent("trigger_cj", "targetname");
	trig2 = getent("trigger_cj2", "targetname");
	trig3 = getent("trigger_cj3", "targetname");
	trig4 = getent("reward", "targetname");
	trig5 = getent("trigger_endhard", "targetname");
	
	for(;;)
	{
	trig1 waittill("trigger", player);
	trig2 waittill("trigger", player);
	trig3 waittill("trigger", player);
	trig4 SetHintString("^4Press ^5[use] ^4to get your ^5Reward ^4!");
	trig4 waittill("trigger", player);
	trig4 SetHintString("");
	
	/* [AUTO DELETE] player GiveWeapon("winchester1200_mp"); */
	/* [AUTO DELETE] player GiveMaxAmmo("winchester1200_mp"); */
	/* [AUTO DELETE] player SwitchToWeapon("winchester1200_mp"); */
	
	trig5 waittill("trigger", player);
	/* [AUTO DELETE] iPrintlnBold("^5" + player.name + " ^4Has Finished The ^5Hard way ^4!"); */
	wait 1;
	}
}


freerun()
{
	self endon("done");
	
	trig2 = getent("trigger_thebigtrigger", "targetname");
	hurt = getent("bloodmaker", "targetname");
	hurt2 = getent("bloodmaker2", "targetname");
	hurt3 = getent("bloodmaker3", "targetname");
	
	trig2 waittill("trigger", player);
	
	for(;;)
	{
		if(level.trapsdisabled)
		{
			hurt delete();
			hurt2 delete();
			hurt3 delete();
			self notify("done");
		}
		wait 0.1;
	}
}


spawn_player()
{
	trig = getent("trigger_thebigtrigger", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);
	player SetClientDvar("g_speed" ,"210");
	wait 5;
	}
}


hard()
{
	trig1 = getent("trigger_hard", "targetname");
	trig2 = getent("trigger_thebigtrigger", "targetname");
	run = getent("trigger_run", "targetname");
	activator = level.activ;
	
	trig2 waittill("trigger", player);
	trig1 SetHintString("^5HARD ^4MODE ^5?^4!");
	trig1 waittill("trigger", activator);
	/* [AUTO DELETE] iPrintlnBold("^4The ^5Activator ^4Challenge ^5You ^4To Complete The Map With ^560 FPS ^4!!!"); */
	/* [AUTO DELETE] iPrintlnBold("^5Run Room ^4Disabled ^5!"); */
	run delete();
	
	for(;;)
	{
	player SetClientDvar("com_maxfps" ,"60");
	wait 0.01;
	}
}


retry()
{
	trig1 = getent("bounce_check", "targetname");
	trig2 = getent("bounce_retry", "targetname");
	bounce = getent("bounce_origin", "targetname");
	
	
	for(;;)
	{
		trig1 waittill("trigger", player);
		trig2 SetHintString("^4Press ^5[use] ^4to ^5Retry ^4!");
		trig2 waittill("trigger", player);
		player setPlayerAngles(bounce.angles);
		player setOrigin(bounce.origin);
	}
}


bounce_retry()
{
	trig = getent("trigger_teleport2", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);
	wait 0.5;
	trig waittill("trigger", player);
	wait 0.5;
	trig waittill("trigger", player);
	wait 0.5;
	trig waittill("trigger", player);
	wait 0.5;
	trig waittill("trigger", player);
	thread bounce_retry2();
	/* [AUTO DELETE] player iPrintlnBold("^4Looks like ^5Your^4're havin' ^5some trouble^4..."); */
	/* [AUTO DELETE] player iPrintlnBold("^5Here is a little help !"); */
	player freezecontrols(true);
	wait 0.5;
	player freezecontrols(false);
	}
}


bounce_retry2()
{
jumpx = getent ("jump","targetname");
glow = getent ("origin_teleport2","targetname");
air1 = getent ("air1","targetname");
air2 = getent ("air2","targetname");
air3 = getent ("air3","targetname");
air4 = getent ("air4","targetname");


	//level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	//mapsmp_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{

		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));

		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		time = 1;
            air moveto (air1.origin, 1);
		wait 1;
            air moveto (air2.origin, 1);
		wait .5;
            air moveto (air3.origin, 1);
		wait .5;
            air moveto (air4.origin, 1);


		//air moveto (throw, time, 0.5,0.5);
		//air moveto (throw, time, 0.5,0.5);
		wait 1;
		user unlink();
		wait 1;
		}
	//this piece of code was taken from the internet
}


jump()
{
jumpx = getent ("jump2","targetname");
glow = getent ("glow","targetname");
air1 = getent ("air5","targetname");
air2 = getent ("air6","targetname");
air3 = getent ("air7","targetname");
air4 = getent ("air8","targetname");

	while(1)
	{
	//level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	//mapsmp_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{

		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));

		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		time = 1;
            air moveto (air1.origin, 0.2);
		wait 0.2;
            air moveto (air2.origin, 1);
		wait .5;
            air moveto (air3.origin, 1);
		wait .5;
            air moveto (air4.origin, 1);


		//air moveto (throw, time, 0.5,0.5);
		//air moveto (throw, time, 0.5,0.5);
		wait 1;
		user unlink();
		wait 1;
		}
	}
	//this piece of code was taken from the internet
}


SecretTimer()
{
        self endon( "disconnect" );
 
        self.secret_timer = NewClientHudElem( self );
        self.secret_timer.y = 10;
        self.secret_timer.alignX = "center";
        self.secret_timer.alignY = "middle";
        self.secret_timer.horzAlign = "center";
        self.secret_timer.sort = -3;
        self.secret_timer.fontScale = 2.5;
        self.secret_timer.owner = self;
        self.secret_timer thread removehudifsuicide();
 
        self.secret_time_left = 120;
        self.secret_finished = false;
 
        while( self.secret_time_left > 0 && !self.secret_finished )
        {
                self.secret_timer setText( "^4Secret time left: ^5" + self.secret_time_left );
                self.secret_time_left--;
                wait 1;
        }
       
        if( !self.secret_finished )
        {
                self.secret_timer Destroy();
                self Suicide();
                /* [AUTO DELETE] self iPrintlnBold( "^5Time^4's ^5Up^4!" ); */
        }
       
}


removehudifsuicide() 
{
        self endon ("death");
        self endon ("disconnect");
        self.owner waittill("death", player);
                player.secret_finished = true;
                player.secret_timer destroy();
                self destroy();
       
}


makelastbouncesafe()
{
	trig = getent("trigger_makelastbouncesafe", "targetname");
	safe = getent("safe_terrain", "targetname");
	
	trig SetHintString("^4Press ^5[use] ^4to make the last bounce ^5safe ^4!");
	trig waittill("trigger", player);
	safe moveZ(-2550, 0.1);
	trig delete();
	
}


stuck()
{
	trig = getent("trigger_stuck", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);
	/* [AUTO DELETE] player iPrintlnBold("^5You Choosed ^4To ^5Avoid ^4The ^5Trap ^4!"); */
	/* [AUTO DELETE] player iPrintlnBold("^5You ^4Will Be ^5Stuck ^4For^5 5 Seconds^4..."); */
	player freezecontrols(true);
	wait 5;
	player freezecontrols(false);
	/* [AUTO DELETE] player iPrintlnBold("^5OK, Go Now."); */
	wait 5;
	}
}


stuck2()
{
	trig = getent("trigger_stuck2", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);
	/* [AUTO DELETE] player iPrintlnBold("^5You Choosed ^4To ^5Avoid ^4The ^5Bounce ^4!"); */
	/* [AUTO DELETE] player iPrintlnBold("^5You ^4Will Be ^5Stuck ^4For^5 5 Seconds^4..."); */
	player freezecontrols(true);
	wait 5;
	player freezecontrols(false);
	/* [AUTO DELETE] player iPrintlnBold("^5OK, You Can Go!"); */
	wait 5;
	}
}


addTriggerToList( name, positionOfIconAboveTrap )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
	
	if( !isDefined( level.icon_origins ) )
		level.icon_origins = [];
	level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
}
