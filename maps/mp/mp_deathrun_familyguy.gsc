#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
	maps\mp\_load::main();

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((-182.722, -116.053, 8.125), 75, 20, (1380, -4989, -14786), 360, "freeze", "red", "secret_0");
	thread sr\api\_speedrun::createTeleporter((3268, -5703.86, 0.125001), 85, 15, (3147, -5338, 60), 139,"unfreeze");
	thread sr\api\_speedrun::createEndMap((1433.01, -7476.19, -13853.9),110,15,"secret_0");
	thread sr\api\_speedrun::createEndMap((-187.078, -4609.33, 0.62499),95,20, "normal_0");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	addTriggerToList("trigger1");
	addTriggerToList("trigger2");
	addTriggerToList("trigger3");
	addTriggerToList("trigger4");
	addTriggerToList("trigger6pt1");
	addTriggerToList("trigger6pt2");
	addTriggerToList("trigger6");
	addTriggerToList("trigger7");
	addTriggerToList("trigger8");
	addTriggerToList("trigger9");
	addTriggerToList("trigger10");
	addTriggerToList("trigger11");
	addTriggerToList("trigger123");
	addTriggerToList("trigger124");
	addTriggerToList("trigger121");
	addTriggerToList("trigger122");
	addTriggerToList("trigger13");
	addTriggerToList("trigger133");
	addTriggerToList("trigger14_1");
	addTriggerToList("trigger14_2");
	addTriggerToList("trigger14_3");
	addTriggerToList("trigger14_4");
	addTriggerToList("trigger16");
	addTriggerToList("trigger17");
	addTriggerToList("trigger18");
	addTriggerToList("trigger15");


	thread trap_1();
	thread trap_2();
	thread trap3();
	thread trap_4();
	thread trap_7();
	thread trap_6();
	thread trap_18();
	thread trap_10();
	thread movingp();
	thread trap_6pt1();
	thread trap_6pt2();
	thread blue_stuff();
	thread trap_8();
	thread trap_11();
	thread trap121();
	thread trap122();
	thread trap123();
	thread trap124();
	thread trap13();
	thread trap133();
	thread trap16();
	thread trap_14_1();
	thread trap_14_2();
	thread trap_14_3();
	thread trap_14_4();
	thread trap_9();
	thread trap_15();
	thread trap_17();

}
addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
trap_7()
{
	level endon("triggerdz");
	trig = getEnt( "trigger7", "targetname" );
	spikes = getEntArray( "trap7_spikes", "targetname" );
	button = getEnt("trap7_button", "targetname");
	hurt = getEnt("anything","targetname");
	for( i = 0; i < spikes.size; i++ )
		spikes[i] hide();
	hurt enableLinkTo();
	hurt LinkTo(spikes[0]);
	trig waittill( "triggerdz", who );
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < spikes.size; i++ )
		spikes[i] show();
	for( i = 0; i < spikes.size; i++ )
		spikes[i] moveZ( 32, 0.2 );
	wait 6.5;
	for( i = 0; i < spikes.size; i++ )
		spikes[i] moveZ( -32, 0.75 );
	wait 0.75;
	for( i = 0; i < spikes.size; i++ )
			spikes[i] hide();
}

trap_4()
{
	level endon("triggerg");
	thread linkHurtToModel( "4hurt", "trap4left" );
	thread linkHurtToModel( "4hurt2", "tra4right" );
	trig = getEnt( "trigger4", "targetname" );
	trap4right = getEntArray( "trap4right", "targetname" );
	trap4left = getEntArray( "trap4left", "targetname" );
	button = getEnt("trap4_button", "targetname");
	trig waittill( "triggerg", who );
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < trap4left.size; i++ )
		trap4left[i] moveY( -124, 0.9 );
	for( i = 0; i < trap4right.size; i++ )
		trap4right[i] moveY( 124, 0.9 );
	wait 6;
	for( i = 0; i < trap4left.size; i++ )
		trap4left[i] moveY( 124, 0.9 );
	for( i = 0; i < trap4right.size; i++ )
		trap4right[i] moveY( -124, 0.9 );

}

trap_6()
{
	level endon("triggerazrty");
	trig = getEnt( "trigger6", "targetname" );
	box1 = getEntArray( "trap6_box1", "targetname" );
	box2 = getEntArray( "trap6_box2", "targetname" );
	box3 = getEntArray( "trap6_box3", "targetname" );
	box4 = getEntArray( "trap6_box4", "targetname" );
	button = getEnt("trap6_button", "targetname");
	hurt = getEnt("hurtbox1","targetname");
	hurt enableLinkTo();
	hurt LinkTo(box1[0]);
	hurt2 = getEnt("hurtbox2","targetname");
	hurt2 enableLinkTo();
	hurt2 LinkTo(box2[0]);
	hurt3 = getEnt("hurtbox3","targetname");
	hurt3 enableLinkTo();
	hurt3 LinkTo(box3[0]);
	hurt4 = getEnt("hurtbox4","targetname");
	hurt4 enableLinkTo();
	hurt4 LinkTo(box4[0]);
	trig waittill( "triggerazrty", who );
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < box1.size; i++ )
	{
		box1[i] moveY( 490, 1);
		box1[i] rotateRoll( 180, 1);
	}
	for( i = 0; i < box2.size; i++ )
	{
		box2[i] moveY( 490, 1);
		box2[i] rotateRoll( 180, 1);
	}
	for( i = 0; i < box3.size; i++ )
	{
		box3[i] moveY( -490, 1);
		box3[i] rotateRoll( 180, 1);
	}
	for( i = 0; i < box4.size; i++ )
	{
		box4[i] moveY( -490, 1);
		box4[i] rotateRoll( 180, 1);
	}
	wait 2.5;
	for( i = 0; i < box1.size; i++ )
		box1[i] delete();
	for( i = 0; i < box2.size; i++ )
		box2[i] delete();
	for( i = 0; i < box3.size; i++ )
		box3[i] delete();
	for( i = 0; i < box4.size; i++ )
		box4[i] delete();
	hurt delete();
	hurt2 delete();
	hurt3 delete();
	hurt4 delete();
}

trap_18()
{
	level endon("triggerqzazr");
	trig = getEnt( "trigger18", "targetname" );
	thing = getEntArray( "trap18", "targetname" );
	button = getEnt("trap18_button", "targetname");
	hurt = getEnt("hurt18","targetname");
	hurt enableLinkTo();
	hurt LinkTo(thing[0]);
	trig waittill( "triggerqzazr", who );
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < thing.size; i++ )
		thing[i] moveZ( -150, 1 );
	wait 6.5;
	for( i = 0; i < thing.size; i++ )
		thing[i] moveZ( 150, 1 );
}

trap_10()
{
	level endon("triggerxdsg");
	trig = getEnt( "trigger10", "targetname" );
	thing = getEntArray( "watertrap", "targetname" );
	button = getEnt("trap10_button", "targetname");
	trig waittill( "triggerxdsg", who );
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < thing.size; i++ )
		thing[i] moveZ( -464, 6 );
	wait 9;
	for( i = 0; i < thing.size; i++ )
		thing[i] moveZ( 464, 6 );
}

movingp()
{
	brush1 = getEnt( "movingp1", "targetname" );
	brush2 = getEnt( "movingp2", "targetname" );

	p1 = getEnt( "part1", "targetname" );
	p3 = getEnt( "part3", "targetname" );
	p2 = getEnt( "part2", "targetname" );
	p4 = getEnt( "part4", "targetname" );

	for(;;) {
		brush1 moveTo( p2.origin, 4.5 );
		brush2 moveTo( p4.origin, 4.5 );
		wait 4.5;
		brush1 moveTo( p3.origin, 1.85 );
		brush2 moveTo( p1.origin, 1.85 );
		wait 1.85;
		brush1 moveTo( p4.origin, 4.5 );
		brush2 moveTo( p2.origin, 4.5 );
		wait 4.5;
		brush1 moveTo( p1.origin, 1.85 );
		brush2 moveTo( p3.origin, 1.85 );
		wait 1.85;
	}
}

trap_6pt1()
{
	level endon("triggerujuklf");
	go = getEnt( "bar1go", "targetname" );
	bar1 = getEnt( "bar1", "targetname" );
	trig = getEnt( "trigger6pt1", "targetname" );
	button = getEnt("trap6pt1_button", "targetname");
	trig waittill( "triggerujuklf", who );
	button moveZ( -4, 0.5 );
	trig delete();
	bar1 moveTo( go.origin, 3.5 );
}

trap_6pt2()
{
	level endon("triggermpmpmii");
	go = getEnt( "bar2go", "targetname" );
	trig = getEnt( "trigger6pt2", "targetname" );
	bar2 = getEnt( "bar2", "targetname" );
	button = getEnt("trap6pt2_button", "targetname");
	trig waittill( "triggermpmpmii", who );
	button moveZ( -4, 0.5 );
	trig delete();
	bar2 moveTo( go.origin, 3.5 );
}

trap_8()
{
	level endon("triggerxcxvbcb");
	trig = getEnt( "trigger8", "targetname" );
	platform = getEnt( "trap8", "targetname" );
	dead= getEnt( "trap81", "targetname" );
	platform solid();
	platform moveX( -512, 0.5);
	wait 0.5;
	platform moveZ( 512, 0.5);
	wait 0.5;
	button = getEnt("trap8_button", "targetname");
	trig waittill( "triggerxcxvbcb", who );
	button moveZ( -4, 0.5 );
	trig delete();
	dead delete();
	wait 5;
	platform moveX( 512, 0.01 );
}

trap3()
{
	level endon("triggerjujuj");
	trap = getEnt("trap3", "targetname");
	trig = getEnt("trigger3", "targetname");
	button = getEnt("trap3_button", "targetname");
	trig waittill ("triggerjujuj", player);
	button moveZ( -4, 0.5 );
	trig delete();
	player thread trap3others();
	wait 6;
}

trap3others()
{
	trap = getEnt("trap3", "targetname");
	fan1 = getEnt("fan1", "targetname");
	fan2 = getEnt("fan2", "targetname");
	fan3 = getEnt("fan3", "targetname");
	fan4 = getEnt("fan4", "targetname");
	fence = getEnt("fence", "targetname");
 	fence hide();
	fence notSolid();
	fan1 rotatePitch( 3240, 6 );
	fan2 rotatePitch( 3240, 6 );
	fan3 rotatePitch( 3240, 6 );
	fan4 rotatePitch( 3240, 6 );
	wait 6;
	fence solid();
	fence show();
	trap delete();
}

trap_11()
{
	level endon("triggerazbjkl");
	trig = getEnt( "trigger11", "targetname" );
	right = getEntArray( "rightlog", "targetname" );
	left = getEntArray( "leftlog", "targetname" );
	button = getEnt("trap11_button", "targetname");
	hurt1 = getEnt("lefthurt","targetname");
	hurt1 enableLinkTo();
	hurt1 LinkTo(left[0]);
	hurt2 = getEnt("righthurt","targetname");
	hurt2 enableLinkTo();
	hurt2 LinkTo(right[0]);
	trig waittill( "triggerazbjkl", who );
	button moveZ( -4, 0.5 );
	trig delete();
	wait 1.25;
	for( i = 0; i < right.size; i++ )
		right[i] rotatePitch( -90, 0.4 );
	for( i = 0; i < left.size; i++ )
		left[i] rotatePitch( 90, 0.4 );
	wait 6.5;
	for( i = 0; i < right.size; i++ )
		right[i] rotatePitch( 90, 2.5 );
	for( i = 0; i < left.size; i++ )
		left[i] rotatePitch( -90, 2.5 );
}
trap121()
{
	level endon("triggerbbjnyj");
	trig = getEnt( "trigger121", "targetname" );
	trigother = getEnt( "trigger122", "targetname" );
	button = getEnt("trap121_button", "targetname");
	plank = getEnt("plank2", "targetname");
	trig waittill( "triggerbbjnyj", who );
	button moveZ( -4, 0.5 );
	trig delete();
	trigother delete();
	wait 0.1;
	plank delete();
}

trap122()
{
	level endon("triggertrez");
	trig = getEnt( "trigger122", "targetname" );
	trigother = getEnt( "trigger121", "targetname" );
	button = getEnt("trap122_button", "targetname");
	plank = getEnt("plank1", "targetname");
	trig waittill( "triggertrez", who );
	button moveZ( -4, 0.5 );
	trig delete();
	trigother delete();
	wait 0.1;
	plank delete();
}

trap123()
{
	level endon("triggerhghy");
	trig = getEnt( "trigger123", "targetname" );
	trigother = getEnt( "trigger124", "targetname" );
	button = getEnt("trap123_button", "targetname");
	plank = getEnt("plank4", "targetname");
	trig waittill( "triggerhghy", who );
	button moveZ( -4, 0.5 );
	trig delete();
	trigother delete();
	wait 0.1;
	plank delete();
}

trap124()
{
	level endon("triggerqsqxxwgg");
	trig = getEnt( "trigger124", "targetname" );
	trigother = getEnt( "trigger123", "targetname" );
	button = getEnt("trap124_button", "targetname");
	plank = getEnt("plank3", "targetname");
	trig waittill( "triggerqsqxxwgg", who );
	button moveZ( -4, 0.5 );
	trig delete();
	trigother delete();
	wait 0.1;
	plank delete();
}

trap13()
{
	level endon("triggerqdhjtjt");
	thread linkHurtToModel( "balls1hurt", "balls1" );
	trig = getEnt( "trigger13", "targetname" );
	trig2 = getEnt( "trigger133", "targetname" );
	balls1hurt = getEnt( "balls1hurt", "targetname" );
	balls = getEntArray( "balls1", "targetname" );
	ballsother = getEntArray( "balls2", "targetname" );
	button = getEnt("trap13_button", "targetname");
	for( i = 0; i < balls.size; i++ )
		balls[i] hide();
	trig waittill( "triggerqdhjtjt", who );
	trig2 delete();
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < balls.size; i++ )
		balls[i] show();
	for( i = 0; i < balls.size; i++ )
		balls[i] moveZ( -232, 0.45 );
	wait 4;
	for( i = 0; i < balls.size; i++ )
		balls[i] moveZ( -1000, 0.1 );
	wait 0.1;
	for( i = 0; i < balls.size; i++ )
		balls[i] delete();
}

trap133()
{
	level endon("triggerqxw");
	thread linkHurtToModel( "balls2hurt", "balls2" );
	trig = getEnt( "trigger133", "targetname" );
	trig2 = getEnt( "trigger13", "targetname" );
	balls2hurt = getEnt( "balls2hurt", "targetname" );
	balls = getEntArray( "balls2", "targetname" );
	button = getEnt("trap133_button", "targetname");
	for( i = 0; i < balls.size; i++ )
		balls[i] hide();
	trig waittill( "triggerqxw", who );
	trig2 delete();
	button moveZ( -4, 0.5 );
	trig delete();
	for( i = 0; i < balls.size; i++ )
		balls[i] show();
	for( i = 0; i < balls.size; i++ )
		balls[i] moveZ( -232, 0.45 );
	wait 4;
	for( i = 0; i < balls.size; i++ )
		balls[i] moveZ( -1000, 0.1 );
	wait 0.1;
	for( i = 0; i < balls.size; i++ )
		balls[i] delete();
}


trap16()
{
	level endon("triggermlmlmk");
	thread linkHurtToModel( "wheels1hurt", "wheels1" );
	thread linkHurtToModel( "wheels2hurt", "wheels2" );
	trig = getEnt( "trigger16", "targetname" );
	pos1 = getEnt( "1pos1", "targetname" );
	pos2 = getEnt( "1pos2", "targetname" );
	wheels1 = getEntArray( "wheels1", "targetname" );
	button = getEnt("trap16_button", "targetname");
	wheels2 = getEntArray( "wheels2", "targetname" );
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] hide();
	for( i = 0; i < wheels2.size; i++ )
		wheels2[i] hide();
	trig waittill( "triggermlmlmk", who );
	button moveZ( -4, 0.5 );
	trig delete();
	who thread trap162();
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] show();
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] moveTo( pos1.origin, 0.5 );
	wait 0.5;
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] moveTo( pos2.origin, 5 );
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] rotatePitch( 980, 5  );
	wait 5;
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] moveX( 50, 0.1  );
	wait 0.1;
	for( i = 0; i < wheels1.size; i++ )
		wheels1[i] delete();
}

linkHurtToModel( hurt, model )
{
	triggerHurt = getEntArray( hurt, "targetname" );
	model = getEntArray( model, "targetname" );
	// link the wheels
	for( a = 0; a < model.size; a ++ )
	{
		triggerHurt[a] enableLinkTo();
		triggerHurt[a] linkto(model[a]);
	}
}
trap162()
{
	spos1 = getEnt( "2pos1", "targetname" );
	spos2 = getEnt( "2pos2", "targetname" );
	wheels2 = getEntArray( "wheels2", "targetname" );
	for( i = 0; i < wheels2.size; i++ )
		wheels2[i] show();
	for( i = 0; i < wheels2.size; i++ )
		wheels2[i] moveTo( spos1.origin, 0.5 );
	wait 0.5;
	for( i = 0; i < wheels2.size; i++ )
		wheels2[i] moveTo( spos2.origin, 4.5 );
	for( i = 0; i < wheels2.size; i++ )
		wheels2[i] rotatePitch( 764, 4.5  );
	wait 4.5;
	for( i = 0; i < wheels2.size; i++ )
		wheels2[i] delete();
}

trap_14_1()
{
	level endon("triggerqswwwaa");
	trig = getEnt( "trigger14_1", "targetname" );
	trigother = getEnt( "trigger14_2", "targetname");
	trig waittill( "triggerqswwwaa", who );
	nigtrig = getEnt( "14_1", "targetname" );
	bhoptele1 = getEnt( "bhoptele1", "targetname" );
	trig delete();
	trigother delete();
	for(;;)
	{
		nigtrig waittill ("trigger", who);

	}
}

trap_14_2()
{
	level endon("triggerqqaartt");
	trig = getEnt( "trigger14_2", "targetname" );
	trigother = getEnt( "trigger14_1", "targetname");
	trig waittill( "triggerqqaartt", who );
	nigtrig = getEnt( "14_2", "targetname" );
	bhoptele1 = getEnt( "bhoptele1", "targetname" );
	trig delete();
	trigother delete();
	for(;;)
	{
		nigtrig waittill ("trigger", who);

	}
}

trap_14_3()
{
	level endon("triggeraqdqdxxw");
	trig = getEnt( "trigger14_3", "targetname" );
	trigother = getEnt( "trigger14_4", "targetname");
	trig waittill( "triggeraqdqdxxw", who );
	nigtrig = getEnt( "14_3", "targetname" );
	bhoptele1 = getEnt( "bhoptele1", "targetname" );
	trig delete();
	trigother delete();
	for(;;)
	{
		nigtrig waittill ("trigger", who);
	}
}

trap_14_4()
{
	level endon("triggerqsqdqd");
	trig = getEnt( "trigger14_4", "targetname" );
	trigother = getEnt( "trigger14_3", "targetname");
	trig waittill( "triggerqsqdqd", who );
	nigtrig = getEnt( "14_4", "targetname" );
	bhoptele1 = getEnt( "bhoptele1", "targetname" );
	trig delete();
	trigother delete();
	for(;;)
	{
		nigtrig waittill ("trigger", who);
	}
}


trap_2()
{
	level endon("triggerafascc");
	trig = getEnt( "trigger2", "targetname" );
	mover = getEnt( "mover2", "targetname" );
	hurt = getEnt( "move2", "targetname" );
	hurt enableLinkTo();
	hurt LinkTo(mover);
	mover moveZ( -500, 0.1 );
	kill = getEnt( "fartdeath", "targetname" );
	fart = getEnt( "fart", "targetname" );
	button = getEnt("trap2_button", "targetname");
	trig waittill( "triggerafascc", who );
	button moveZ( -4, 0.5 );
	trig delete();
	for(i=0;i<45;i++) {
		mover moveZ( 500, 0.08 );
		wait 0.08;
		mover moveZ( -500, 0.08 );
		wait 0.08;
	}
	mover delete();
	hurt delete();
}


trap_1()
{
	level endon("triggeraqfsfsf");
	trig = getEnt( "trigger1", "targetname" );
	mover = getEnt( "mover1", "targetname" );
	hurt = getEnt( "move1", "targetname" );
	hurt enableLinkTo();
	hurt LinkTo(mover);
	mover moveZ( -500, 0.1 );
	laser = getEnt( "laser", "targetname" );
	kill = getEnt("1death", "targetname");
	laser hide();
	laser notSolid();
	trap1_fx1 = getEnt( "trap1_fx2", "targetname" );
	trap1_fx2 = getEnt( "trap1_fx3", "targetname" );
	trap1_fx3 = getEnt( "trap1_fx1", "targetname" );
	button = getEnt("trap1_button", "targetname");
	trig waittill( "triggeraqfsfsf", who );
	button moveZ( -4, 0.5 );
	trig delete();
	laser show();
	wait 0.3;
	laser hide();
	mover moveZ( 500, 0.1 );
	wait 0.3;
	mover delete();
	hurt delete();

}

trap_9()
{
	level endon("triggeradass");
	trig = getEnt( "trigger9", "targetname" );
	gun1 = getEnt( "gun1", "targetname" );
	gun2 = getEnt( "gun2", "targetname" );
	gun3 = getEnt( "gun3", "targetname" );
	gun4 = getEnt( "gun4", "targetname" );
	gun5 = getEnt( "gun5", "targetname" );
	mover = getEnt( "move", "targetname" );
	hurt = getEnt( "gunkill", "targetname" );
	hurt enableLinkTo();
	hurt LinkTo(mover);
	mover moveZ( -500, 0.1 );
	button = getEnt("trap9_button", "targetname");
	trig waittill( "triggeradass", who );
	button moveZ( -4, 0.5 );
	trig delete();
	mover moveZ( 500, 0.1 );
	wait 5;
	mover delete();
	hurt delete();
}

trap_15()
{
	level endon("triggerzfzf");
	trig = getEnt( "trigger15", "targetname" );
	bomb = getEnt( "ugotme", "targetname" );
	mover = getEnt( "mover3", "targetname" );
	hurter = getEnt( "move3", "targetname" );
	hurter enableLinkTo();
	hurter LinkTo(mover);
	mover moveZ( -500, 0.1 );
	temp = spawn("script_model", bomb getOrigin());
	temp setModel("tag_origin");
	kill = getEnt( "bombhurt", "targetname" );
	button = getEnt("trap15_button", "targetname");
	trig waittill( "triggerzfzf", who );
	button moveZ( -4, 0.5 );
	trig delete();
	bomb StopLoopSound();
	bomb delete();
	mover moveZ( 500, 0.1 );
	temp delete();
	level notify("fuckyoubomb");
	wait 0.2;
	mover delete();
	hurter delete();
}


trap_17()
{
	level endon("triggera");
	trig = getEnt( "trigger17", "targetname" );
	l1 = getEnt( "l1", "targetname" );
	l2 = getEnt( "l2", "targetname" );
	l3 = getEnt( "l3", "targetname" );
	l4 = getEnt( "l4", "targetname" );
	l5 = getEnt( "l5", "targetname" );
	l6 = getEnt( "l6", "targetname" );
	l1h = getEnt( "lhurt1", "targetname" );
	l2h = getEnt( "lhurt2", "targetname" );
	l3h = getEnt( "lhurt3", "targetname" );
	l4h = getEnt( "lhurt4", "targetname" );
	l5h = getEnt( "lhurt5", "targetname" );
	l6h = getEnt( "lhurt6", "targetname" );
	l1h enableLinkTo();
	l2h enableLinkTo();
	l3h enableLinkTo();
	l4h enableLinkTo();
	l5h enableLinkTo();
	l6h enableLinkTo();
	l1h LinkTo(l1);
	l2h LinkTo(l2);
	l3h LinkTo(l3);
	l4h LinkTo(l4);
	l5h LinkTo(l5);
	l6h LinkTo(l6);
	l1 hide();
	l2 hide();
	l3 hide();
	l4 hide();
	l5 hide();
	l6 hide();
	l1 moveY( 1000, 0.1);
	l2 moveY( 1000, 0.1);
	l3 moveY( 1000, 0.1);
	l4 moveY( 1000, 0.1);
	l5 moveY( 1000, 0.1);
	l6 moveY( 1000, 0.1);
	button = getEnt("trap15_button", "targetname");
	trig waittill( "triggera", who );
	button moveZ( -4, 0.5 );
	trig delete();
	l6 moveY( -1000, 0.25);
	l6 show();
	wait 0.25;
	l5 moveY( -1000, 0.25);
	l5 show();
	wait 0.25;
	l4 moveY( -1000, 0.25);
	l4 show();
	wait 0.25;
	l3 moveY( -1000, 0.25);
	l3 show();
	wait 0.25;
	l2 moveY( -1000, 0.25);
	l2 show();
	wait 0.25;
	l1 moveY( -1000, 0.25);
	l1 show();
	wait 5;
	l1 delete();
	l2 delete();
	l3 delete();
	l4 delete();
	l5 delete();
	l6 delete();
	l1h delete();
	l2h delete();
	l3h delete();
	l4h delete();
	l5h delete();
	l6h delete();
}

blue_stuff() 
{
	trig = getEnt( "thetele", "targetname" );
	for(;;)
	{
		trig waittill( "trigger", who );
		who suicide();
	}
}


