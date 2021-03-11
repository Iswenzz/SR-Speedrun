main()
{

	// thread trap_1();
	// thread trap_2();
	// thread trap_3();
	// thread trap_4();
	// thread trap_5();
	// thread trap_6();
	// thread trap_7();
	thread trap_8();
	// thread trap_9();
	// thread trap_9_poison();
	
	// addTriggerToList( "trap_1" );
	// addTriggerToList( "trap_2" );
	// addTriggerToList( "trap_3" );
	// addTriggerToList( "trap_4" );
	// addTriggerToList( "trap_5" );
	// addTriggerToList( "trap_6" );
	// addTriggerToList( "trap_7" );
	// addTriggerToList( "trap_8" );
	// addTriggerToList( "trap_9" );
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
	level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap_1()
{
	trigger = getEnt ( "trap_1_trigger", "targetname" );
	target_1 = getEnt ( "crate_2", "targetname" );
	target_2 = getEnt ( "crate_1", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	if ( RandomIntRange ( 1, 101) > 50 )
	{
		for ( i = 1; i < 5; i++ )
		{
			target_1 notSolid();
		}
	}
	else
	{
		for ( i = 5; i < 9; i++ )
		{
			target_2 notSolid();
		}
	}
}

trap_2()
{
	trigger = getEnt ( "trap_2_trigger", "targetname" );
	target = getEnt ( "trap_2_target", "targetname" );
	crane_1 = getEnt ( "crane_1", "targetname" );
	crane_2 = getEnt ( "crane_2", "targetname" );
	crate = getEnt ( "crane_crate", "targetname" );
	explosion = getEnt ( "trap_2_origin_1", "targetname" );
	water2 = getEnt ( "trap_2_origin_3", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	crane_1 rotatePitch ( -13, 1);
	crane_2 rotatePitch( 13, 1);
	
	crate moveZ ( -420, 1, 0.5, 0.1);
	wait 1;
	playFx ( level.distortion, explosion.origin );
	playFx ( level.water_crate, water2.origin );
	thread water_2();
	target moveZ ( -80, 1, 0.5, 0.1);
	crate moveZ ( -80, 1, 0.5, 0.1);
	thread crane_move();
	wait 6;
	target moveZ ( 80, 3, 2, 1);
	crate delete();
	wait 3;
	target moveZ ( -10, 1, 0.5, 0.4);
	wait 1;
	target moveZ ( 10, 2, 1, 0.5);
	wait 2;
	target moveZ ( -7, 2, 1, 0.5);
	wait 2;
	target moveZ ( 7 , 1, 0.5, 0.3);
	wait 1;
}

water_2()
{
	water = getEnt ( "trap_2_origin_2", "targetname" );
	
	wait 0.3;
	playFx ( level.water_crate, water.origin );
}

crane_move()
{
	target = getEnt ( "crane_hold_crate", "targetname" );
	target_1 = getEnt ( "crane_1", "targetname" );
	target_2 = getEnt ( "crane_2", "targetname" );
	
	target_1 Linkto ( target );
	target_2 Linkto ( target );
	
	start = target getOrigin();
	
	target moveTo (( 896, -64, 588 ), 15);
	wait 15;
}

trap_3()
{
	target = getEnt ( "trap_3_target", "targetname" );
	trigger = getEnt ( "trap_3_trigger", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	target moveX ( -272, 4, 2, 1);
	wait 7;
	
	target moveX ( 272, 4, 2, 1);
	wait 7;
}

trap_4()
{
	target = getEnt ( "trap_4_target", "targetname" );
	target_2 = getEnt ( "trap_4_target_2", "targetname" );
	trigger = getEnt ( "trap_4_trigger", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	target moveZ ( -176, 3, 2, 1);
	target_2 moveZ ( -176, 3, 2, 1);
	wait 6;
	
	target delete();
}

trap_5()
{
	target = getEnt ( "trap_5_target", "targetname" );
	target_2 = getEnt ( "trap_5_target_2", "targetname" );
	trigger = getEnt ( "trap_5_trigger", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	target_2 notSolid();
	
	while(1)
	{
		target rotateRoll ( 360, 5);
		target_2 rotateRoll ( 512, 5);
		wait 5;
	}
}

trap_6()
{
	trigger = getEnt ( "trap_6_trigger", "targetname" );
	target_1 = getEnt ( "trap_6_target_1", "targetname" );
	target_2 = getEnt ( "trap_6_target_2", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	if ( RandomIntRange ( 1, 101) > 50 )
	{
		for ( i = 1; i < 5; i++ )
		{
			target_1 moveZ ( -288, 4, 2, 1);
			wait 5;
		}
	}
	else
	{
		for ( i = 5; i < 9; i++ )
		{
			target_2 moveZ ( -288, 4, 2, 1);
			wait 5;
		}
	}
}

trap_7()
{
	trigger = getEnt ( "trap_7_trigger", "targetname" );
	target = getEnt ( "trap_7_target", "targetname" );
	hurt_1 = getEnt ( "trap_7_hurt_1", "targetname" );
	hurt_2 = getEnt ( "trap_7_hurt_2", "targetname" );
	hurt_3 = getEnt ( "trap_7_hurt_3", "targetname" );
	hurt_4 = getEnt ( "trap_7_hurt_4", "targetname" );
	
	hurt_1 enableLinkTo ();
	hurt_1 LinkTo ( target );
	hurt_2 enableLinkTo ();
	hurt_2 LinkTo ( target );
	hurt_3 enableLinkTo ();
	hurt_3 LinkTo ( target );
	hurt_4 enableLinkTo ();
	hurt_4 LinkTo ( target );
	
	trigger setHintString("^2[^7use^2]");
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	while(1)
	{
		target rotateRoll ( 360, 2.5);
		wait 2.5;
	}
}

trap_8()
{
	trigger = getEnt ( "trap_8_trigger", "targetname" );
	target_1 = getEnt ( "trap_8_target_1", "targetname" );
	target_2 = getEnt ( "trap_8_target_2", "targetname" );
	target_3 = getEnt ( "trap_8_target_3", "targetname" );
	hurt_1 = getEnt ( "trap_8_hurt_1", "targetname" );
	hurt_2 = getEnt ( "trap_8_hurt_2", "targetname" );
	hurt_3 = getEnt ( "trap_8_hurt_3", "targetname" );
	
	hurt_1 enableLinkTo ();
	hurt_1 LinkTo ( target_1 );
	hurt_2 enableLinkTo ();
	hurt_2 LinkTo ( target_2 );
	hurt_3 enableLinkTo ();
	hurt_3 LinkTo ( target_3 );
	
	wait 10;
	target_1 moveZ ( -64, 5);
	target_2 moveZ ( -64, 5);
	target_3 moveZ ( -64, 5);
	
}

trap_9()
{
	trigger = getEnt ( "trap_9_trigger", "targetname" );
	level.posion_trigger = getEnt ( "trap_9_poison_trigger", "targetname" );
	linker = getEnt ( "trap_9_poison_linker", "targetname" );
	effect = getEnt ( "trap_9_poison_origin", "targetname" );
	
	trigger setHintString("^2[^7use^2]");
	
	level.posion_trigger enableLinkTo ();
	level.posion_trigger LinkTo ( linker );
	
	linker moveZ ( -25, 1);
	wait 1;
	
	trigger waittill ( "trigger", player );
	
	trigger setHintString("^1[^7activated^1]");
	player braxi\_rank::giveRankXp( "trap_activation" );
	
	playFx ( level.smoke, effect.origin );
	wait 1;
	
	linker moveZ ( 25, 1);
	wait 12;
	
	linker moveZ ( -25, 1);
}

trap_9_poison()
{
	level.posion_trigger waittill ( "trigger", player );
	wait 0.05;
		
	player shellShock( "frag_grenade_mp", 6 );
	wait 0.5;
		
	player freezeControls(1);
	wait 5;
		
	player freezeControls(0);
	wait 0.05;
		
	player suicide();
}