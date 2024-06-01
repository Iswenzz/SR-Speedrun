main()
{
thread sr\api\_map::createSpawnOrigin((112.125, -282, 0.125), 0);
trigger = spawn( "trigger_radius", (-4064.87, 1593.28, -63.875), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
	maps\mp\_load::main();
	//maps\mp\_teleportal::main();
	//maps\mp\_teleportal2::main();
	// maps\mp\_hackbuzzer::main();
	maps\mp\_rotateglad1::main();
	maps\mp\_rotateglad2::main();
	maps\mp\_rotateglad3::main();
	maps\mp\mp_deathrun_portal_sound_fx_v3::main();
	maps\createart\mp_deathrun_portal_v3_art::main();
	maps\mp\mp_deathrun_portal_v3_fx::main();


	precacheItem( "remington700_mp" );
	precacheItem( "deserteagle_mp" );




	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar( "compassmaxrange", "1024" );

	thread way_connect();
	// thread trap_1();
	// thread trap_2();
	thread hidedoor();
	// thread trap_3();
	// thread trap_4();
	thread stairs();
	thread clipdelete();
	thread trigger_init();
	// thread trap_5();
	// thread trap_6();
	// thread trap_7();
	thread finalDoor();
	thread finalDoor2();
	// thread addtrapstofreerun();
    // level.trig = GetEnt("teletrigger", "targetname");
    // thread TeleportTrigger();
	// level.trig waittill("trigger");




}


////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

trap_1()
{
	trig = getEnt( "trigger1", "targetname" );
	brush = getEnt( "trap1", "targetname" );

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");
	trig delete();

	brush movey( -368, 2 );
	wait 5;
	brush movey( 368, 2 );
}

trap_2()
{
	trig = getEnt( "trigger2", "targetname" );
	brush = getEnt( "trap2", "targetname" );

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");
	trig delete();

	brush moveZ( -500, 3 );
	wait 5;
	brush moveZ( 500, 1 );
}

hidedoor() // first door
{
	trig = getEnt( "triggerhide", "targetname" );
	brush = getEnt( "hidedoor", "targetname" );
	brush2 = getEnt( "hidedoor_2", "targetname" );

	brush movey( -80, 3 );
	brush2 movey( -80, 3 );

}

trap_3()
{
	trig = getEnt( "trigger3", "targetname" );
	brushGroup1 = getEntArray( "trap3_1", "targetname" );
	brushGroup2 = getEntArray( "trap3_2", "targetname" );

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");
	trig delete();

	brushGroup1[randomInt(brushGroup1.size)] notSolid();
	brushGroup2[randomInt(brushGroup2.size)] notSolid();
}

trap_4()
{
	trig = getEnt( "trigger4", "targetname" );
	brush = getEnt( "trap4", "targetname" );

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");
	trig delete();

	brush movey( -288, 2 );
	wait 3;
	brush movey( 288, 2 );

}

stairs()
{
	trig = getEnt( "triggerstair", "targetname" );
	stair1 = getEnt( "stair1", "targetname" );
    stair2 = getEnt( "stair2", "targetname" );
    stair3 = getEnt( "stair3", "targetname" );
	stair4 = getEnt( "stair4", "targetname" );
	stair5 = getEnt( "stair5", "targetname" );
	stair6 = getEnt( "stair6", "targetname" );
	stair7 = getEnt( "stair7", "targetname" );
	stair8 = getEnt( "stair8", "targetname" );
	stair9 = getEnt( "stair9", "targetname" );
	stair10 = getEnt( "stair10", "targetname" );
	stair11 = getEnt( "stair11", "targetname" );
	stair12 = getEnt( "stair12", "targetname" );
	stair13 = getEnt( "stair13", "targetname" );
	stair14 = getEnt( "stair14", "targetname" );
	stair15 = getEnt( "stair15", "targetname" );
	stair16 = getEnt( "stair16", "targetname" );
	stair17 = getEnt( "stair17", "targetname" );
	stair18 = getEnt( "stair18", "targetname" );
	stair19 = getEnt( "stair19", "targetname" );
	stair20 = getEnt( "stair20", "targetname" );

	wait 0.5;

	stair1 movez( 16, 1 );
	wait 0.2;
	stair2 movez( 32, 1 );
	wait 0.2;
	stair3 movez( 48, 1 );
	wait 0.2;
	stair4 movez( 64, 1 );
	wait 0.2;
	stair5 movez( 80, 1 );
	wait 0.2;
	stair6 movez( 96, 1 );
	wait 0.2;
	stair7 movez( 112, 1 );
	wait 0.2;
	stair8 movez( 128, 1 );
	wait 0.2;
	stair9 movez( 144, 1 );
	wait 0.2;
	stair10 movez( 160, 1 );
	wait 0.2;
	stair11 movez( 176, 1 );
	wait 0.2;
	stair12 movez( 192, 1 );
	wait 0.2;
	stair13 movez( 208, 1 );
	wait 0.2;
	stair14 movez( 224, 1 );
	wait 0.2;
	stair15 movez( 240, 1 );
	wait 0.2;
	stair16 movez( 256, 1 );
	wait 0.2;
	stair17 movez( 272, 1 );
	wait 0.2;
	stair18 movez( 288, 1 );
	wait 0.2;
	stair19 movez( 304, 1 );
	wait 0.2;
	stair20 movez( 320, 1 );




}

clipdelete()
{
	trig = getEnt( "clipdeletetrigger", "targetname" );
	brush = getEnt( "clipdelete", "targetname" );

	wait 0.5;

	trig delete();
	brush delete();

}

trigger_init()
{
	soundtriggers = getentarray( "sound_trigger", "targetname" );

	for( i = 0; i < soundtriggers.size; i++ )
		soundtriggers[i] thread trigger_sound();
}

trigger_sound()
{
	self.wait_for_retrigger = false;
	soundpos = getent( self.target, "targetname" );

	while( 1 )
	{
		if( !self.wait_for_retrigger )
		{
			self waittill( "trigger" );
			self.wait_for_retrigger = true;
			soundpos thread play_the_sound( self, soundpos.script_noteworthy );
		}
		wait 0.1;
	}
}

play_the_sound( used_trigger, sound )
{
		self playsound( sound );
		wait 100000;
		used_trigger.wait_for_retrigger = false;
}



trap_5()
{
	trig = getEnt( "trigger5", "targetname" );
	trap5 = getEnt( "trap5", "targetname" );

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");
	trig delete();

	trap5 movez( -250, 2 );
	wait 5;
	trap5 movez( 250, 2 );

}

trap_6()
{
	trig = getEnt( "trigger6", "targetname" );
	brush = getEnt( "trap6", "targetname" );

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");
	trig delete();
	brush delete();
}

trap_7()
{
	trig = getEnt( "trigger7", "targetname" );

	brush1 = getEnt( "trap7_1", "targetname" );
	brush2 = getEnt( "trap7_2", "targetname" );

	oldOrigin1 = brush1.origin;
	oldOrigin2 = brush2.origin;

	trig waittill( "trigger", who );
	who PlaySound("button_synth_positive_01");

	moveTo = getEnt( brush1.target, "targetname" );
	brush1 moveTo( moveTo.origin, 1.2 );
	moveTo = getEnt( brush2.target, "targetname" );
	brush2 moveTo( moveTo.origin, 1.2 );

	wait 1.2;

	trig waittill( "trigger", who );
	trig delete();

	brush1 moveTo( oldOrigin1, 1.2 );
	brush2 moveTo( oldOrigin2, 1.2 );
}


finalDoor()
{
	trig = getEnt( "doors_trig", "targetname" );
	brush = getEnt( "door", "targetname" );

	wait 0.5;

	trig delete();
	brush delete();

}


finaldoor2()
{
	trig = getEnt( "triggerdoor1", "targetname" );
	brush = getEnt( "finaldoorthing", "targetname" );

	wait 0.5;

	trig delete();
	brush delete();

}


TeleportTrigger()
{
	level.trig waittill("trigger");
	level.trig delete();
	thread port();
}

port()
{
	if( GetTeamPlayersAlive("allies") == 1)
	{
		iprintlnbold("^2SNIPER ^11 ^7VS ^11!");
		wait 2;
		iprintlnbold("^1 F   I   G   H   T   ^7!");
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( isAlive(players[i]) && players[i].pers["team"] != "spectator" )
			{
				if( players[i].pers["team"] == "allies" )
				{
					players[i] SetPlayerAngles(( players[i].angles[0],0, players[i].angles[2] ));
					players[i] SetOrigin((-5560,-1544,-64));
				}
				if( players[i].pers["team"] == "axis" )
				{
					players[i] SetPlayerAngles( players[i].angles[0], 0, players[i].angles[2] );
					players[i] SetOrigin((-3800,-1544,-64));
				}
				players[i] TakeAllWeapons();
				players[i] GiveWeapon("remington700_mp");
				wait 0.01;
				players[i] SwitchToWeapon("remington700_mp");
			}
		}
		return;
	}
}


addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
addtrapstofreerun()
{
	addTriggerToList("trigger1");
	addTriggerToList("trigger2");
	addTriggerToList("trigger3");
	addTriggerToList("trigger4");
	addTriggerToList("trigger5");
	addTriggerToList("trigger6");
	addTriggerToList("trigger7");
}




