/*																																					=
					????????????????????????																										=
					?					   ?																										=
					?????????	????????????															?????      ????								=
							?	?																		?	?    ??  ??								=
							?	?		?????															?	?  ??  ??								=
							?	?		?	?????????????	?????			?????	?????????????????	?	???  ??									=
							?	?		?				?	?	?			?	?	?				?	?	   ??									=
							?	?		?	?????????????	?	?			?	?	?	?????????????	?	???										=	
							?	?		?	?				?	?			?	?	?	?				?	?  ??									=
							?	?		?	?				?	?			?	?	?	?				?	?    ??									=
							?	?		?	?				?	?			?	?	?	?				?	?      ???								=				
							?	?		?	?				?	?????????????	?	?	?????????????	?	?       ????							=
							?	?		?	?				?					?	?				?	?	?        ????		????				=
							?????		?????				?????????????????????	?????????????????	?????         ?????		????				=
=====================================================================================================================================================
mp_dr_beach:
Mapper: Trucker0009
Scripter: Trucker0009
Steam: Trucker0009 / tjn659
Date started: 19th of August, 2015.
Date finished: 26th of August, 2015.(Was still under testing after this date)
RIP XFire
GREEEEEEEEEEEEEEEEEEEEETINGS :)

												//////////////////////////////////////////////////
												//	FEEL FREE TO COPY/USE ANY SCRIPT FROM HERE	//
												//////////////////////////////////////////////////
*/
#include braxi\_common;
#include maps\mp\_utility;
#include common_scripts\utility;
main()
{
	maps\mp\_load::main();

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((-4941.74, -4823.45, 1196.13), 65, 20, (9568, 11608, 269), 106, "freeze", "red", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-4743.47, -3127.81, 1184.13), 130, 70, (-5233, -1711, 1232), 179,"freeze");
	thread sr\api\_speedrun::createTeleporter((-4395.83, 2797.15, 1184.13), 130, 70, (-3181, 2798, 1216), 1,"freeze");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	// Teleporters \\
	
	thread secret_tp1();
	thread secret_tp2();
	thread secret_tp3();
	thread secret_tp4();
	thread secret_tp5();
	thread secret_tp6();
	thread secret_tp7();
	thread secret_tp8();
	thread secret_tp9();
	thread secret_tp10();
	thread secret_tp11();
	thread secret_tp12();
	thread secret_tp13();
	thread secret_tp14();
	thread secret_tp15();
	thread secretfinish_tp();
	thread give_rpg();
	
	// Traps \\
	
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread walls();
	thread trap10();
	thread trap11();
	
	// Others \\
	
	thread startdoor();
	thread waterdrown();
	thread addTriggerToList( "trap1_trig" );
	thread addTriggerToList( "trap2_trig" );
	thread addTriggerToList( "trap3_trig" );
	thread addTriggerToList( "trap4_trig" );
	thread addTriggerToList( "trap5_trig" );
	thread addTriggerToList( "trap6_trig" );
	thread addTriggerToList( "trap7_trig" );
	thread addTriggerToList( "trap8_trig" );
	thread addTriggerToList( "harder_walls" );
	thread addTriggerToList( "trap10_trig" );
	thread addTriggerToList( "trap11_trig" );
	
}
waterdrown()
{
	trig = getEnt("water", "targetname");
	while ( 1 )
	{
		trig waittill("trigger", player);
		player suicide();
	}
}

trap1()
{

	level endon("triggerloyy");
	p1 = getEnt("trap1_p1", "targetname");
	p2 = getEnt("trap1_p2", "targetname");
	p3 = getEnt("trap1_p3", "targetname");
	p4 = getEnt("trap1_p4", "targetname");
	trig = getEnt("trap1_trig", "targetname");
	trig waittill("triggerloyy", player);
	trig delete();

		while( 1 )
		{
			p1 hide();
			p1 notsolid();
			p4 show();
			p4 solid();
			wait 1;
			p2 hide();
			p2 notsolid();
			p1 show();
			p1 solid();
			wait 1;
			p3 hide();
			p3 notsolid();
			p2 show();
			p2 solid();
			wait 1;
			p4 hide();
			p4 notsolid();
			p3 show();
			p3 solid();
			wait 1;
		}
}

trap2()
{
	level endon("triggerbgrt");
	trig = getEnt("trap2_trig", "targetname");
	trig waittill("triggerbgrt", player);
	trig delete();

	a = RandomInt( 2 );
		if(a==1)
		{
		thread trap2_left();
		}
		else
		{
		thread trap2_right();
		}
}
trap2_left()
{
	org = getEnt("trap2_d1", "targetname");
	bounce1 = getEnt("trap2_b1", "targetname");
	bounce2 = getEnt("trap2_b2", "targetname");
	
	bounce1 delete();
	while( 1 )
	{
		bounce2 movex(400, 2);
		wait 2;
		bounce2 movex(-400, 2);
		wait 2;
	}
}
trap2_right()
{
	org = getEnt("trap2_d2", "targetname");
	bounce1 = getEnt("trap2_b2", "targetname");
	bounce2 = getEnt("trap2_b1", "targetname");
	bounce1 delete();
	while( 1 )
	{
		bounce2 movex(-400, 2);
		wait 2;
		bounce2 movex(400, 2);
		wait 2;
	}
}

trap3()
{
	level endon("triggerathjt");
	trig = getEnt("trap3_trig", "targetname");
	rollers = getEnt("trap3_rollers", "targetname");
	trig waittill("triggerathjt", player);
	trig delete();

		while( 1 )
		{
			rollers rotateyaw(360, 3);
			wait 3;
			rollers rotateyaw(360, 3);
			wait 3;
		}
}

trap4()
{
	level endon("triggerdqytj");
g1 = getEnt("trap4_g1", "targetname");
g2 = getEnt("trap4_g2", "targetname");
trig = getEnt("trap4_trig", "targetname");
	trig waittill("triggerdqytj", player);
	trig delete();
		a = RandomInt( 2 );
		if(a==1)
		{
		g1 notsolid();
		}
		else
		{
		g2 notsolid();
		}
}

trap5()
{
	level endon("triggerxvvb");
b1 = getEnt("trap5_bounce1", "targetname");
b2 = getEnt("trap5_bounce2", "targetname");
trig = getEnt("trap5_trig", "targetname");
	trig waittill("triggerxvvb", player);
	trig delete();
		while( 1 )
		{
		b1 rotateroll(-50, 1, 0.5, 0.5);
		b2 rotateroll(50, 1, 0.5, 0.5);
		wait 2;
		b1 rotateroll(50, 1, 0.5, 0.5);
		b2 rotateroll(-50, 1, 0.5, 0.5);
		wait 2;
		}
}

trap6()
{
	level endon("triggermlj");
lol = getEnt("trap6_lol", "targetname");
trig = getEnt("trap6_trig", "targetname");
hurt = getEnt("hurt2", "targetname");
hurt enableLinkTo();
hurt linkTo( lol );
trig waittill("triggermlj", player);
	trig delete();
		lol rotateyaw(40, 1);
		wait 1;
		while( 1 )
		{
		lol rotateyaw(-80, 2);
		wait 3;
		lol rotateyaw(80, 2);
		wait 3;
		}
}

trap7()
{
	level endon("triggerhjjt");
p1 = getEnt("trap7_p1", "targetname");
p2 = getEnt("trap7_p2", "targetname");
p3 = getEnt("trap7_p3", "targetname");
p4 = getEnt("trap7_p4", "targetname");
trig = getEnt("trap7_trig", "targetname");
trig waittill("triggerhjjt", player);
	trig delete();
		while( 1 )
		{
		p1 rotateyaw(360, 2);
		wait 1;
		p2 rotateyaw(360, 2);
		wait 1;
		p3 rotateyaw(360, 2);
		wait 1;
		p4 rotateyaw(360, 2);
		wait 1;
		}
}

trap8()
{
	level endon("triggergfhfh");
door1 = getEnt("trap8_door1", "targetname");
door2 = getEnt("trap8_door2", "targetname");
floor1 = getEnt("trap8_floor", "targetname");
floor2 = getEnt("trap8_floor2", "targetname");
trig = getEnt("trap8_trig", "targetname");
trig waittill("triggergfhfh", player);

	trig delete();
	door1 movey(80, 2.5);
	door2 movey(-80, 2.5);
	wait 2.5;
	floor1 movey(-336, 5);
	floor2 movey(336, 5);
	wait 6;
	floor1 movey(336, 5);
	floor2 movey(-336, 5);
	wait 6;
	door1 movey(-80, 2.5);
	door2 movey(80, 2.5);
}

walls()
{
	level endon("triggerwcvz");
	walls = getEnt("3walls", "targetname");
	trig = getEnt("harder_walls", "targetname");
	trig waittill("triggerwcvz", player);
	trig delete();

	walls movez(90, 2);
}

trap10()
{
	level endon("triggeradqqxa");
	s1 = getEnt("trap10_s1", "targetname");
	hurt1 = getEnt("s_hurt1", "targetname");
	s2 = getEnt("trap10_s2", "targetname");
	hurt2 = getEnt("s_hurt2", "targetname");
	s3 = getEnt("trap10_s3", "targetname");
	hurt3 = getEnt("s_hurt3", "targetname");
	hurt1 enableLinkTo();
	hurt2 enableLinkTo();
	hurt3 enableLinkTo();
	trig = getEnt("trap10_trig", "targetname");
	trig waittill("triggeradqqxa", player);
	trig delete();

		thread spikesroll(s1, s2 ,s3);
		thread spikesmove(s1, s2, s3);
		while( 1 )
		{
		hurt1 linkto(s1);
		hurt2 linkto(s2);
		hurt3 linkto(s3);
		wait 0.05;
		}
}

spikesroll(s1, s2 ,s3)
{
		while( 1 )
		{
			s1 rotateroll(-360*5, 2);
			s2 rotateroll(360*5, 2);
			s3 rotateroll(-360*5, 2);
			wait 2;
		}
}
spikesmove(s1, s2 ,s3)
{
		while( 1 )
		{
			s1 movey(608, 1.2);
			s2 movey(-608, 1.2);
			s3 movey(608, 1.2);
			s1 waittill("movedone");
			s1 movey(-608, 1.2);
			s2 movey(608, 1.2);
			s3 movey(-608, 1.2);
			s1 waittill("movedone");
		}
}

trap11()
{
	level endon("triggerjgjg");
	rollers = getEnt("trap11_rollers", "targetname");
	trig = getEnt("trap11_trig", "targetname");
	trig waittill("triggerjgjg", player);
	trig delete();
		while( 1 )
		{
		rollers rotatepitch(360, 2);
		wait 2;
		}
}

secretfinish_tp()
{
	trig = getEnt("secret_finishtp_trig", "targetname");
	for(;;)
		{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
}

startdoor()
{
door = getEnt("startdoor", "targetname");
door delete();
}

give_rpg()
{
	trig = getEnt("rpg_trig", "targetname");
	while( 1 )
	{
		trig waittill("trigger", player);
		player giveWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}


secret_tp1()
{
hit = getEnt("secret_tp1_trig", "targetname");
tp = getEnt("secret_tp1", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
	player suicide();

	}
}

secret_tp2()
{
hit = getEnt("secret_tp2_trig", "targetname");
tp = getEnt("secret_tp2", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp3()
{
hit = getEnt("secret_tp3_trig", "targetname");
tp = getEnt("secret_tp3", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp4()
{
hit = getEnt("secret_tp4_trig", "targetname");
tp = getEnt("secret_tp4", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp5()
{
hit = getEnt("secret_tp5_trig", "targetname");
tp = getEnt("secret_tp5", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp6()
{
hit = getEnt("secret_tp6_trig", "targetname");
tp = getEnt("secret_tp6", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp7()
{
hit = getEnt("secret_tp7_trig", "targetname");
tp = getEnt("secret_tp7", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp8()
{
hit = getEnt("secret_tp8_trig", "targetname");
tp = getEnt("secret_tp8", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp9()
{
hit = getEnt("secret_tp9_trig", "targetname");
tp = getEnt("secret_tp9", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp10()
{
hit = getEnt("secret_tp10_trig", "targetname");
tp = getEnt("secret_tp10", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp11()
{
hit = getEnt("secret_tp11_trig", "targetname");
tp = getEnt("secret_tp11", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp12()
{
hit = getEnt("secret_tp12_trig", "targetname");
tp = getEnt("secret_tp12", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp13()
{
hit = getEnt("secret_tp13_trig", "targetname");
tp = getEnt("secret_tp13", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp14()
{
hit = getEnt("secret_tp14_trig", "targetname");
tp = getEnt("secret_tp14", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

secret_tp15()
{
hit = getEnt("secret_tp15_trig", "targetname");
tp = getEnt("secret_tp15", "targetname");
	while(1)
	{
	hit waittill("trigger", player);
player suicide();
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}