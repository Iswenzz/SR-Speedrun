/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| |||| ||| |||   |||       || |||   |||||||||||   ||| |||||||  |||| ||||| |||
||| |||| ||| || ||| ||||| ||||| || ||| ||||||||| ||| || |||||| || |||   ||| |||
||| |||| ||| || ||||||||| ||||| || ||||||||||||| |||||| ||||| |||| || || || |||
||| |||| ||| |||   |||||| ||||| || ||||||    ||| |||||| ||||| |||| || || || |||
||| |||| ||| |||||| ||||| ||||| || ||||||||||||| |||||| |||||      || ||  | |||
|||| || |||| |||||| ||||| ||||| || ||| ||||||||| ||| || ||||| |||| || ||| | |||
|||||  ||||| ||    |||||| ||||| |||   |||||||||||   |||    || |||| || ||||  |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

------------- Map       :	mp_dr_trapntrance -
------------- Mapper  	:	VC' Blade (bladetk17)
------------- Server  	:	VC' Deathrun: 62.75.222.118:28960
------------- xFire   	: 	bladetk17
------------- Homepage	:  	vistic-clan.com
*/
main()
{
	maps\mp\_load::main();
	//maps\mp\unnatural\special::main();

	precacheShellShock("frag_grenade_mp");

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-6660, -578, 76), 90);

	//ambientPlay( "creepzor" );

	//FX
	//level.rainbow = LoadFx("vistic/rainbow_funken");
	//level.portals = LoadFx("vistic/portal");
	//level.jumpport = LoadFx("vistic/vip");
	//level.poison = LoadFx("vistic/green_smoke");
	//level.explosion = LoadFX ("explosions/tanker_explosion");
	//level.mine = LoadFX ("explosions/artilleryExp_dirt_brown_low");
	//level.stars = LoadFx("vistic/sterne");
	//level.nuke = LoadFx("explosions/nuke_explosion");
	//level.nukeflash = LoadFx("explosions/nuke_flash");
	//level.fire_effect = LoadFx("shiet/fire_blue");
	//level.light_explo = LoadFx("vistic/light_explosion");

	//thread MapStart();
	thread MysteryStart();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap5_poison();
	//thread trap6();
	//thread trap7();
	thread trap8();
	//thread trap9();
	//thread trap10();
	//thread trap11();
	//thread trap12();
	//thread trap13();
	//thread trap14();
	//thread trap15();
	//thread activatorTele();
	//thread activatorTele2();
	thread ThirdJumpTelev1();
	thread ThirdJumpTelev2();
	//thread endsniper();
	//thread endknife();
	//thread endmaze();
	//thread endbounce();
	//thread antisuicideactivator();
	//thread antisuicideactivator2();
	//thread activatorelevator();
	thread mapmover1();
	//thread mapmover2();
	//thread FirstJumpTele();
	thread SecondJumpTele();
	//thread snipstart_jump();
	//thread snipstart_acti();
	//thread comp_nuke();
	//thread bounceele_jump();
	//thread bounceele_acti();
	//thread bounce_mover1();
	//thread bounce_mover2();
	//thread bounce_antifail();
	//thread fireffects();

		addTriggerToList( "trap1_trig" );
		addTriggerToList( "trap2_trig" );
		addTriggerToList( "trap3_trig" );
		addTriggerToList( "trap4_trig" );
		addTriggerToList( "trap5_trig" );
		addTriggerToList( "trap6_trig" );
		addTriggerToList( "trap7_trig" );
		addTriggerToList( "trap8_trig" );
		addTriggerToList( "trap9_trig" );
		addTriggerToList( "trap10_trig" );
		addTriggerToList( "trap11_trig" );
		addTriggerToList( "trap12_trig" );
		addTriggerToList( "trap13_trig" );
		addTriggerToList( "trap14_trig" );
		addTriggerToList( "trap15_trig" );
		addTriggerToList( "musictrig" );
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

MapStart()
{
	level waittill("round_started");
	level.effect1 = SpawnFx(level.rainbow,(-7400, 88, 72));
    level.effect2 = SpawnFx(level.rainbow,(-7400, 824, 72));
    level.effect3 = SpawnFx(level.rainbow,(-7400, 1688, 72));
    level.effect4 = SpawnFx(level.rainbow,(-7400, 2952, 72));
    level.effect5 = SpawnFx(level.rainbow,(-3896, -6008, -3688));
    level.effect6 = SpawnFx(level.rainbow,(-3896, -6296, -3688));
    level.effect7 = SpawnFx(level.rainbow,(-3896, -6552, -3688));
    level.effect8 = SpawnFx(level.rainbow,(-3896,-6808,-3688));
    level.effect9 = SpawnFx(level.rainbow,(-3896,-7112,-3688));
    level.effect10 = SpawnFx(level.rainbow,(-4424, -7112, -3688));
    level.effect11 = SpawnFx(level.rainbow,(-4984, -7112, -3688));
    level.effect12 = SpawnFx(level.rainbow,(-4984, -6504, -3688));
    level.effect13 = SpawnFx(level.rainbow,(-4984, -6008, -3688));
    level.effect14 = SpawnFx(level.rainbow,(-4584, -5400, -3464));
    level.effect15 = SpawnFx(level.rainbow,(-4584, -4776, -3464));
    triggerfx(level.effect1);
    triggerfx(level.effect2);
    triggerfx(level.effect3);
    triggerfx(level.effect4);
    triggerfx(level.effect5);
    triggerfx(level.effect6);
    triggerfx(level.effect7);
    triggerfx(level.effect8);
    triggerfx(level.effect9);
    triggerfx(level.effect10);
    triggerfx(level.effect11);
    triggerfx(level.effect12);
    triggerfx(level.effect13);
    triggerfx(level.effect14);
	triggerfx(level.effect15);
	wait(5);
	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1, 0.5, 0);
	hud_clock.label = &"Map by VC' Blade";
    hud_clock SetPulseFX( 40, 5400, 200 );
    wait 1;

    if(level.trapsdisabled)
    {
    	level.effect1 delete();
    	level.effect2 delete();
    	level.effect3 delete();
    	level.effect4 delete();
    	level.effect5 delete();
    	level.effect6 delete();
    	level.effect7 delete();
    	level.effect8 delete();
    	level.effect9 delete();
    	level.effect10 delete();
    	level.effect11 delete();
    	level.effect12 delete();
    	level.effect13 delete();
		level.effect14 delete();
		level.effect15 delete();
    }
}

MysteryStart()
{
	level.start_trig1 = getEnt("start_trig1", "targetname");
	level.start_trig2 = getEnt("start_trig2", "targetname");
	level.start_trig3 = getEnt("start_trig3", "targetname");

	thread startbut1();
	thread startbut2();
	thread startbut3();
}
startbut1()
{
	button1 = getEnt("start_but1", "targetname");
	move1 = getEnt("start_act1", "targetname");


		move1 delete();
}
startbut2()
{
	button2 = getEnt("start_but2", "targetname");
	move2 = getEnt("start_act2", "targetname");

		move2 delete();
}
startbut3()
{
	button3 = getEnt("start_but3", "targetname");
	move3 = getEnt("start_act3", "targetname");


		move3 delete();
}
FirstJumpTele()
{
	port = getEnt("port1port", "targetname");

	for(;;)
	{
	port waittill("trigger",player);

	player setOrigin((-6656, -704, 32));

	}
}

SecondJumpTele()
{
	trig = getEnt("jumper2_tele", "targetname");
	target = getEnt("jumper2_port", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles(target.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

activatorTele()
{
	trig = getEnt("atart_trig", "targetname");
	target = getEnt("ascape_origin", "targetname");
	trig setHintString("^3[^1Teleport^3]");
	trig setCursorHint("HINT_ACTIVATE");

	while(1)
	{
		trig waittill ("trigger", player);

		{
		  player SetOrigin(target.origin);
		  player SetPlayerAngles( target.angles );
		}
	}
}

ThirdJumpTelev1()
{
	up = getEnt("portal2_up", "targetname");
	down = getEnt("portal2_down", "targetname");

	up moveZ(48,0.1);
	down moveZ(-48,0.1);

}
ThirdJumpTelev2()
{
	//port = getEnt("open_portal2", "targetname");
	trig = getEnt("port3port", "targetname");

	ori = spawn("script_origin",(-2016, -8472, -3696));
	ori.angles = (0,180,0);


	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}


// Traps
trap1()
{
	level.trig_1 = getEnt("trap1_trig", "targetname");
	trap = getEnt("trap1_rotaty1", "targetname");
	atrap = getEnt("trap1_rotaty2", "targetname");


	level.trig_1 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_1 setCursorHint("HINT_ACTIVATE");
	level.trig_1 waittill("trigger");
	level.trig_1 delete();
	level.effect1 delete();

	while(1)
	{
		trap rotatePitch(360, 2);
		atrap rotateRoll(360, 2);
		wait .1;
	}
}

trap2()
{
	level.trig_2 = getEnt("trap2_trig", "targetname");
	trap = getEnt("trap2_delete", "targetname");
	atrap = getEnt("trap2_dick1", "targetname");
	btrap = getEnt("trap2_dick2", "targetname");

	level.trig_2 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_2 setCursorHint("HINT_ACTIVATE");
	level.trig_2 waittill("trigger");
	level.trig_2 delete();
	level.effect2 delete();

	trap delete();
	atrap rotatePitch(90,2);
	btrap rotatePitch(-90,2);

	while(1)
	{
		atrap moveZ(72,2);
		wait 1;
		btrap moveX(-100,1);
		wait 2;
		atrap rotateYaw(360,2);
		btrap rotateYaw(-360,2);
		wait 3;
		atrap moveZ(-72,1);
		btrap moveX(100,1);
		wait 3;
	}
}

trap3()
{
	level.trig_3 = getEnt("trap3_trig", "targetname");
	atrap = getEnt("trap3_rotate1", "targetname");
	btrap = getEnt("trap3_rotate2", "targetname");

	level.trig_3 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_3 setCursorHint("HINT_ACTIVATE");
	level.trig_3 waittill("trigger");
	level.trig_3 delete();
	level.effect3 delete();

	while(1)
	{
		atrap rotatePitch(360,2);
		wait 5;
		btrap rotatePitch(360,2);
		wait 5;
	}
}

trap4()
{
	level.trig_4 = getEnt("trap4_trig", "targetname");
	atrap = getEnt("atrap4", "targetname");
	btrap = getEnt("btrap4", "targetname");
	ctrap = getEnt("ctrap4", "targetname");

	level.trig_4 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_4 setCursorHint("HINT_ACTIVATE");
	level.trig_4 waittill("trigger");
	level.trig_4 delete();
	level.effect4 delete();

	while(1)
	{
		atrap rotatePitch(360, 5);
		wait 3;
		btrap rotatePitch(360, 5);
		wait 3;
		ctrap rotatePitch(360, 5);
		wait 3;
	}
}

trap5()
{
	level.trig_5 = getEnt("trap5_trig", "targetname");
	level.posion_trig = getEnt("poison","targetname");
	linker = getEnt("linker","targetname");

	level.trig_5 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_5 setCursorHint("HINT_ACTIVATE");
	level.trig_5 waittill("trigger");
	level.trig_5 delete();
	level.effect5 delete();

	level.posion_trig enableLinkTo ();
	level.posion_trig LinkTo ( linker );

	playFx ( level.poison,(-2792, -4360, -3864));
	wait 1;
	linker moveZ ( 32, 1);
	wait 12;
	linker moveZ ( -32, 1);
}
trap5_poison()
{
	level.posion_trig waittill("trigger",player);
	wait 0.05;
	player shellShock( "frag_grenade_mp", 6 );
	wait 0.5;
	player freezeControls(1);
	wait 5;
	player freezeControls(0);
	wait 0.05;
	player suicide();
}

trap6()
{
	level.trig_6 = getEnt("trap6_trig", "targetname");
	atrap = getEnt("trap6a", "targetname");
	a1trap = getEnt("trap6a1", "targetname");
	btrap = getEnt("trap6b", "targetname");
	b1trap = getEnt("trap6b1", "targetname");
	ctrap = getEnt("trap6c", "targetname");
	c1trap = getEnt("trap6c1", "targetname");

	level.trig_6 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_6 setCursorHint("HINT_ACTIVATE");
	level.trig_6 waittill("trigger");
	level.trig_6 delete();
	level.effect6 delete();
	thread rotatehurt();

	while(1)
	{
		atrap rotatePitch(360,2);
		a1trap rotatePitch(-360,2);
		wait 2;
		btrap rotatePitch(360,2);
		b1trap rotatePitch(-360,2);
		wait 2;
		ctrap rotatePitch(360,2);
		c1trap rotatePitch(-360,2);
		wait 2;
	}
}
rotatehurt()
{
	dtrap = getEnt("trap6d", "targetname");
	d1trap = getEnt("trap6d1", "targetname");
	hurt = getEnt("trap6h", "targetname");
	hurt1 = getEnt("trap6h1", "targetname");

	hurt enablelinkto();
	hurt1 enablelinkto();

	hurt linkto(dtrap);
	hurt1 linkto(d1trap);

	while(1)
	{
		dtrap rotatepitch(360,3);
		d1trap rotatepitch(-360,3);
		wait 1;
	}
}

trap7()
{
	level.trig_7 = getEnt("trap7_trig", "targetname");
	atrap = getEnt("trap7a", "targetname");
	btrap = getEnt("trap7b", "targetname");
	ctrap = getEnt("trap7c", "targetname");
	htrap1 = getEnt("trap7h","targetname");
	htrap2 = getEnt("trap7h2","targetname");
	htrap3 = getEnt("trap7h3","targetname");

	level.trig_7 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_7 setCursorHint("HINT_ACTIVATE");
	level.trig_7 waittill("trigger");
	level.trig_7 delete();
	level.effect7 delete();
	thread trap7moves();

	while(1)
	{
		atrap rotateyaw(360,1);
		btrap rotateyaw(-360,1);
		ctrap rotateyaw(360,1);
		wait .1;
	}
}
trap7moves()
{
	atrap = getEnt("trap7a", "targetname");
	btrap = getEnt("trap7b", "targetname");
	ctrap = getEnt("trap7c", "targetname");
	htrap1 = getEnt("trap7h","targetname");
	htrap2 = getEnt("trap7h2","targetname");
	htrap3 = getEnt("trap7h3","targetname");

	htrap1 enablelinkto();
	htrap2 enablelinkto();
	htrap3 enablelinkto();

	htrap1 linkto(atrap);
	htrap2 linkto(btrap);
	htrap3 linkto(ctrap);

	while(1)
	{
		atrap movez(80,2);
		wait 2;
		atrap movex(-440,2);
		btrap movex(232,2);
		ctrap movex(232,2);
		wait 2;
		atrap movez(-80,2);
		btrap movez(80,2);
		wait 2;
		btrap movex(-440,2);
		atrap movex(232,2);
		ctrap movex(232,2);
		wait 2;
		btrap movez(-80,2);
		ctrap movez(80,2);
		wait 2;
		ctrap movex(-440,2);
		atrap movex(232,2);
		btrap movex(232,2);
		wait 2;
		ctrap movez(-80,2);
		wait 2;
	}
}

trap8()
{
	level.trig_8 = getEnt("trap8_trig", "targetname");
	atrap = getEnt("trap8", "targetname");
	htrap = getEnt("trap8h","targetname");

	atrap delete();
	htrap delete();

}

trap9()
{
	level.trig_9 = getEnt("trap9_trig", "targetname");
	atrap = getEnt("trap9", "targetname");
	btrap = getEnt("trap9a","targetname");
	ctrap = getEnt("trap9b","targetname");

	btrap hide();
	ctrap hide();

	level.trig_9 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_9 setCursorHint("HINT_ACTIVATE");
	level.trig_9 waittill("trigger");
	level.trig_9 delete();
	level.effect9 delete();
	atrap delete();
	btrap show();
	ctrap show();

	while(1)
	{
		btrap movey(190,1.5);
		ctrap movey(-190,1.5);
		wait 3;
		btrap movey(-190,1.5);
		ctrap movey(190,1.5);
		wait 3;
	}
}

trap10()
{
	level.trig_10 = getEnt("trap10_trig", "targetname");
	atrap = getEnt("trap10", "targetname");

	level.trig_10 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_10 setCursorHint("HINT_ACTIVATE");
	level.trig_10 waittill("trigger");
	level.trig_10 delete();
	level.effect10 delete();

	playFx ( level.explosion,(-4456, -8472, -3768));
	wait 0.1;
	atrap delete();
	playFx ( level.mine,(-4456, -8472, -3768));
	wait 0.1;
	earthquake ( 1, 1, (-4456, -8472, -3768), 500 );
	wait 0.1;

	players = getEntArray( "player", "classname" );
    for(k=0;k<players.size;k++)
    {
	    dist = Distance2D(players[k].origin, (-4456, -8472, -3768));
	    if(dist < 100)
	    {
		    players[k] suicide();
	    }
	    else if(dist < 140)
	    {
		    RadiusDamage( players[k].origin, 10, 60, 40);
	    }
	    else if(dist < 180)
	    {
		    RadiusDamage( players[k].origin, 10, 30, 10);
		}
	}
}

trap11()
{
	level.trig_11 = getEnt("trap11_trig", "targetname");
	atrap = getEnt("trap11", "targetname");
	bridge = getEnt("trap11_bridge","targetname");

	atrap hide();

	level.trig_11 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_11 setCursorHint("HINT_ACTIVATE");
	level.trig_11 waittill("trigger");
	level.trig_11 delete();
	level.effect11 delete();
	atrap show();

	atrap movez(-368,3);
	wait 3;
	atrap movez(-272,3);
	bridge movez(-110,3);
	bridge rotateroll(20,3);
	wait 3;
	atrap delete();
}

trap12()
{
	level.trig_12 = getEnt("trap12_trig", "targetname");
	atrap = getEnt("trap12a", "targetname");
	btrap = getEnt("trap12b","targetname");

	level.trig_12 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_12 setCursorHint("HINT_ACTIVATE");
	level.trig_12 waittill("trigger");
	level.trig_12 delete();
	level.effect12 delete();

	atrap delete();
	while(1)
	{
		btrap movez(-150,3);
		wait 2;
		btrap movez(150,3);
		wait 2;
	}
}

trap13()
{
	level.trig_13 = getEnt("trap13_trig", "targetname");
	atrap = getEnt("trap13", "targetname");
	htrap = getEnt("trap13h","targetname");

	level.trig_13 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_13 setCursorHint("HINT_ACTIVATE");
	level.trig_13 waittill("trigger");
	level.trig_13 delete();
	level.effect13 delete();

	htrap enablelinkto();
	htrap linkto(atrap);

	atrap movez(40,1);
	wait 6;
	atrap movez(-40,1);
}

trap14()
{
	level.trig_14 = getEnt("trap14_trig", "targetname");
	atrap = getEnt("trap14a", "targetname");
	btrap = getEnt("trap14b","targetname");

	level.trig_14 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_14 setCursorHint("HINT_ACTIVATE");
	level.trig_14 waittill("trigger");
	level.trig_14 delete();
	level.effect14 delete();

	while(1)
	{
		atrap hide();
		atrap notsolid();
		btrap show();
		btrap solid();
		wait 2;
		atrap show();
		atrap solid();
		btrap hide();
		btrap notsolid();
		wait 2;
	}
}

trap15()
{
	level.trig_15 = getEnt("trap15_trig", "targetname");
 	amove = getEnt("mapmover2a","targetname");
	bmove = getEnt("mapmover2b","targetname");

	level.trig_15 setHintString("^3[^1Awaiting Activation^3]");
	level.trig_15 setCursorHint("HINT_ACTIVATE");
	level.trig_15 waittill("trigger");
	level.trig_15 delete();
	level.effect15 delete();

	while(1)
	{
		amove hide();
		bmove hide();
		wait 4;
		amove show();
		bmove show();
		wait 4;
	}
}

mapmover1()
{
	amove = getEnt("mapmove1a","targetname");
	bmove = getEnt("mapmove1b","targetname");

	amove movex(200,0.1);
	bmove movex(-200,0.1);

}

mapmover2()
{
	amove = getEnt("mapmover2a","targetname");
	bmove = getEnt("mapmover2b","targetname");

	amove rotateyaw(360,4);

}

// Endrooms and Endroombuild
endsniper()
{
	level.sniper = getEnt("sniper", "targetname");
	button = getEnt("sniperbutton", "targetname");
	level.sniper setHintString("^3[^1Open Sniper Portal^3]");
	level.sniper waittill("trigger");
	button moveZ(-24, 2);
	level.sniper setHintString("^3[^1Sniper Portal is open^3]");

	playLoopedFx( level.portals, 0.05, (-4672, -2572, -3694));
	playLoopedFx( level.rainbow, 0.05, (-1096, 120, -1224));
	playLoopedFx( level.rainbow, 0.05, (-1784, 120, -1224));
	playLoopedFx( level.rainbow, 0.05, (-1784, 712, -1224));
	playLoopedFx( level.rainbow, 0.05, (-1096, 712, -1224));
	playLoopedFx( level.rainbow, 0.05, (-1448, 456, -1224));
	level thread sniper();
	level.knife delete();
	level.maze delete();
	level.bounce delete();
}

endknife()
{
	level.knife = getEnt("knife", "targetname");
	button = getEnt("knifebutton", "targetname");
	level.knife setHintString("^3[^1Open Knife Portal^3]");
	level.knife waittill("trigger");
	button moveZ(-24, 2);
	level.knife setHintString("^3[^1Knife Portal is open^3]");

	playLoopedFx( level.portals, 0.05, (-4534, -2572, -3694));
	playLoopedFx( level.stars, 0.05, (-4596, -432, -44));
	level thread knife();
	level.sniper delete();
	level.maze delete();
	level.bounce delete();
}

endmaze()
{
	level.maze = getEnt("maze", "targetname");
	button = getEnt("mazebutton", "targetname");
	level.maze setHintString("^3[^1Open Compet. Run Portal^3]");
	level.maze waittill("trigger");
	button moveZ(-24, 2);
	level.maze setHintString("^3[^1Compet. Run Portal is open^3]");

	playLoopedFx( level.portals, 0.05, (-4388, -2572, -3694));
	level thread competrun();
	level.knife delete();
	level.sniper delete();
	level.bounce delete();
}

endbounce()
{
	level.bounce = getEnt("bounce", "targetname");
	button = getEnt("bouncebutton", "targetname");
	level.bounce setHintString("^3[^1Open Bounce Portal^3]");
	level.bounce waittill("trigger");
	button moveZ(-24, 2);
	level.bounce setHintString("^3[^1Bounce Portal is open^3]");

	playLoopedFx( level.portals, 0.05, (-4246, -2572, -3694));
	level thread bounce();
	level.knife delete();
	level.maze delete();
	level.sniper delete();
}

activatorTele2()
{
	trig = getEnt("acti2_tele","targetname");
	for(;;)
	{
		trig waittill("trigger", p);
		p setOrigin((-4416, -6528, -3672));
		p iprintln("^3[^1Teleported^3]");
	}
}

antisuicideactivator()
{
	trig = getEnt("antisuicideacti", "targetname");
	for(;;)
	{
		trig waittill("trigger", p);
		p setOrigin((-4416, -6528, -3672));
		p iprintln("^3[^1Respawned^3]");
	}
}

antisuicideactivator2()
{
	trig2 = getEnt("antisuicideacti2", "targetname");
	for(;;)
	{
		trig2 waittill("trigger", p);
		p setOrigin((-4416, -6528, -3672));
		p iprintln("^3[^1Respawned^3]");
	}
}

activatorelevator()
{
	lift = getEnt ( "trapmasterlift", "targetname" );
	trig = getEnt ( "trigmasterlift", "targetname" );

	trig waittill ( "trigger" );

	for(;;)
	{
		lift moveZ ( 132, 5, 1, 3 );
		lift waittill ( "movedone" );
		wait 5;
		lift moveZ ( -132, 5, 1, 3 );
		lift waittill ( "movedone" );
		wait 5;
	}
}

onspawned()
{
	level waittill("player_spawn");

	if(getSubStr( self.guid, 24, 32 ) == "c409ae43")
    {
        self thread Mapper();
    }
    if(getSubStr( self.guid, 24, 32 ) == "8a627e23")
    {
    	self thread Vips();
    }
}

Mapper()
{
	self endon("disconnect");
	self endon("death");
	while( game["state"] != "playing" )
		wait 0.05;
    while(true)
    {
		self setModel("Yuusha_2");
		self setViewmodel("viewmodel_base_viewhands");
	    wait 1;
    }
}

Vips()
{
	self endon("disconnect");
	self endon("death");
	while( game["state"] != "playing" )
		wait 0.05;
    while(true)
    {
		self setModel("playermodel_dnf_duke");
		self setViewmodel("viewhands_dnf_duke");
	    wait 1;
    }
}

sniper()
{

	trig = getEnt( "sniper_port", "targetname");
    jump = getEnt ("jumper_snip", "targetname");
    acti = getEnt ("acti_snip", "targetname");

    while(1)
    {
        trig waittill( "trigger", player );
        if( !isDefined( trig ) )
            return;



        if(level.roomsong==true)
		{
			ambientstop();
			ambientplay("roomz");
			level.roomsong = false;
		}


		player FreezeControls(1);
		level.activ FreezeControls(1);

		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

		player takeallweapons();
        level.activ takeallweapons();
        thread roomcountdown();

        wait 5;

		player FreezeControls(0);
		level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

knife()
{

	trig = getEnt( "knife_port", "targetname");
    jump = getEnt ("jumper_knife", "targetname");
    acti = getEnt ("acti_knife", "targetname");

    while(1)
    {
        trig waittill( "trigger", player );
        if( !isDefined( trig ) )
            return;


        if(level.roomsong==true)
		{
			ambientstop();
			ambientplay("roomz");
			level.roomsong = false;
		}

		player FreezeControls(1);
		level.activ FreezeControls(1);

		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

        player takeallweapons();
        level.activ takeallweapons();
        thread roomcountdown();

        wait 5;

        player setroomgun("knife_mp");
        level.activ setroomgun("knife_mp");
        player thread setkniferoom();
        level.activ thread setkniferoom();

		player FreezeControls(0);
		level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

/*maze()
{
	trig = getent("maze_port","targetname");
	acti = getent("acti_maze","targetname");
	jump = getent("jumper_maze","targetname");

	level.entrance = true;
	while(1)
	{
		trig waittill("trigger", player);
		if(level.entrance==true)
		{
			level.activ SetOrigin(acti.origin);
			level.activ setplayerangles(acti.angles);
			//AmbientStop();
			//ambientPlay("endzor");
			level.entrance=false;
		}
		player SetOrigin(jump.origin);
		player setplayerangles(jump.angles);
	}
}*/
bounce()
{
	trig = getEnt("bounce_port","targetname");
	acti = getEnt("acti_bounce","targetname");
	jump = getEnt("jump_bounce","targetname");
	level.roomsong = true;
	while(1)
	{
		trig waittill("trigger",player);
		if(!isDefined(trig))
			return;



		if(level.roomsong==true)
		{
			ambientstop();
			ambientplay("roomz");
			level.roomsong = false;
		}

		player FreezeControls(1);
		level.activ FreezeControls(1);

		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

        player takeallweapons();
        level.activ takeallweapons();
        thread roomcountdown();

        wait 5;

        player setroomgun("knife_mp");
        level.activ setroomgun("knife_mp");

		player FreezeControls(0);
		level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
	}
}

competrun()
{
	trig = getEnt("comrun","targetname");
	acti = getEnt("acti_run","targetname");
	jump = getEnt("jump_run","targetname");
	level.roomsong = true;
	while(1)
	{
		trig waittill("trigger",player);



		level.victim = player;

		if(!isDefined(trig))
			return;

		if(level.roomsong==true)
		{
			ambientstop();
			ambientplay("roomz");
			level.roomsong = false;
		}

		player FreezeControls(1);
		level.activ FreezeControls(1);

		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

        player takeallweapons();
        level.activ takeallweapons();
        thread roomcountdown();

        wait 5;

		player FreezeControls(0);
		level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
	}
}
comp_nuke()
{
	nuketrig = getEnt("comp_nuke","targetname");
	nuketrig setHintString("Bomb it.");

	for(;;)
	{
		nuketrig waittill("trigger",player);

		playfx(level.nuke,(-12248, -6344, -5096));
		wait 1;
		playfx(level.nukeflash,(-12248, -6344, -5096));
		wait 1;
		if(player.pers["team"] == "allies")
			level.activ suicide();
		if(player.pers["team"] == "axis")
			level.victim suicide();

	}
}

setroomgun( gun )
{
	self takeallweapons();
	self giveweapon(gun);
	self switchtoweapon(gun);
}

setkniferoom()
{
	self endon("death");
	self endon("disconnect");
}

snipstart_jump()
{
	trig = getEnt ("jumper_toroom", "targetname");
	jump1 = getEnt ("snipjump1", "targetname");
	jump2 = getEnt ("snipjump2", "targetname");
	jump3 = getEnt ("snipjump3", "targetname");
	jump4 = getEnt ("snipjump4", "targetname");
	door = getEnt("snipjump_door", "targetname");

	time = 3;
	for(;;)
	{
		trig waittill ("trigger", user);
		if (user istouching(trig))
		{
			door movez(-36, 1);
			air = spawn ("script_model",(5,7,1));
			air.origin = user.origin;
			air.angles = user.angles;
			user DisableWeapons();
			wait 0.5;
			user linkto (air);
			air moveto (jump1.origin, time);
			wait 3;
			air moveto (jump2.origin, time);
			wait 3;
			air moveto (jump3.origin, time);
			wait 3;
			air moveto (jump4.origin, time);
			door movez(36,1);
			wait 3;
			user unlink();
			wait 0.2;
			user EnableWeapons();
			user setroomgun("remington700_mp");
			wait 0.1;
		}
	}
}

snipstart_acti()
{
	trig = getEnt ("acti_toroom", "targetname");
	door = getEnt("snipact_door", "targetname");
	acti1 = getEnt ("snipacti1", "targetname");
	acti2 = getEnt ("snipacti2", "targetname");
	acti3 = getEnt ("snipacti3", "targetname");
	acti4 = getEnt ("snipacti4", "targetname");

	time = 3;
	for(;;)
	{
		trig waittill ("trigger", user);
		if (user istouching(trig))
		{
			door movez(-36, 1);
			air = spawn ("script_model",(5,7,1));
			air.origin = user.origin;
			air.angles = user.angles;
			user DisableWeapons();
			wait 0.5;
			user linkto (air);
			air moveto (acti1.origin, time);
			wait 3;
			air moveto (acti2.origin, time);
			wait 3;
			air moveto (acti3.origin, time);
			wait 3;
			air moveto (acti4.origin, time);
			door movez(36,2);
			wait 3;
			user unlink();
			wait 0.2;
			user EnableWeapons();
			user setroomgun("remington700_mp");
			wait 0.1;
		}
	}
}

bounceele_jump()
{
	ele = getEnt("jump_bounce_ele","targetname");
	trig = getEnt("jump_bounce_eletrig","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		ele movez(112, 3);
		wait 8;
		ele movez(-112, 3);
	}
}
bounceele_acti()
{
	ele = getEnt("acti_bounce_ele","targetname");
	trig = getEnt("acti_bounce_eletrig","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		ele movez(112, 3);
		wait 8;
		ele movez(-112, 3);
	}
}

bounce_mover1()
{
	mover = getEnt("jump_tobounce_end_brush","targetname");
	trig = getEnt("jump_tobounce_end","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		mover movey(-1296, 10);
		mover waittill("movedone");
		wait 8;
		mover movey(1296, 3);
		mover waittill("movedone");
	}
}
bounce_mover2()
{
	mover = getEnt("acti_tobounce_end_brush","targetname");
	trig = getEnt("acti_tobounce_end","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		mover movey(-1296, 10);
		mover waittill("movedone");
		wait 8;
		mover movey(1296, 3);
		mover waittill("movedone");
	}
}
bounce_antifail()
{
	acti = getEnt("acti_bounce","targetname");
	jump = getEnt("jump_bounce","targetname");
	trigger = getent("antifail","targetname");
	for(;;)
	{
		trigger waittill("trigger",player);

		if(player.pers["team"] != "spectator")
		{
			if(player.pers["team"] == "allies")
			{
				player SetPlayerAngles(jump.angles);
				player SetOrigin(jump.origin);
			}
			if(player.pers["team"] == "axis")
			{
				player SetPlayerAngles(acti.angles);
				player SetOrigin(acti.origin);
			}
		}
	}
}
roomcountdown()
{
	level.countdown = NewHudElem();
	level.countdown.alignX = "center";
	level.countdown.alignY = "middle";
	level.countdown.horzalign = "center";
	level.countdown.vertalign = "middle";
	level.countdown.alpha = 1;
	level.countdown.x = 0;
	level.countdown.y = 0;
	level.countdown.font = "default";
	level.countdown.fontscale = 2;
	level.countdown.glowalpha = 1;
	level.countdown.glowcolor = (1, 0.5, 0);
	level.countdown.label = &"Room starts in: ^1";
    level.countdown SetPulseFX( 40, 5400, 200 );
    for(i = 0; i < 5; i++)
	{
		level.countdown setvalue( 5 - i );
		wait 1;
	}
	thread removeit();
}
removeit()
{
	if(!isDefined(level.countdown))
		level.countdown destroy();
}

fireffects()
{
	trig1 = getEnt("fire1","targetname");
	trig2 = getEnt("fire2","targetname");
	trig3 = getEnt("fire3","targetname");
	trig4 = getEnt("fire4","targetname");
	trig5 = getEnt("fire5","targetname");
	trig6 = getEnt("fire6","targetname");

	trig1 waittill("trigger");
	{
		playloopedfx(level.fire_effect,0.5,(-1864,-5224,-3896));
	}
	trig2 waittill("trigger");
	{
		playloopedfx(level.fire_effect,0.5,(-2840, -7224, -3896));
	}
	trig3 waittill("trigger");
	{
		playloopedfx(level.fire_effect,0.5,(-3784, -9096, -3896));
	}
	trig4 waittill("trigger");
	{
		playloopedfx(level.fire_effect,0.5,(-6424, -9112, -3896));
	}
	trig5 waittill("trigger");
	{
		playloopedfx(level.fire_effect,0.5,(-6888, -6184, -3896));
	}
	trig6 waittill("trigger");
	{
		playloopedfx(level.fire_effect,0.5,(-5368, -5144, -3896));
	}
}