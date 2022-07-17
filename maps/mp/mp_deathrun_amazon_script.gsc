#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include braxi\_common;
main()
{
	//level.splash_fx = loadfx("explosions/grenadeExp_water");

	precacheItem( "knife_mp" );
	precacheItem( "tomahawk_mp" );
	precacheItem( "mp5_reflex_mp" );
	precacheItem( "remington700_mp" );

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-301,-127,-479),359);
	//thread messages();
	//thread trap1();
	//thread auto();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	////thread trap6();
	//thread trap7();
	//thread trap8();
	//thread end_message();
	//thread dogs();
	//thread water();
	//thread water1();
	//thread water2();
	//thread water3();
	//thread water4();
	//thread bounce_fall();
	//thread mapper_name();
	//thread extra();
	//thread extra2();
	//thread bounce_weap();
	//thread ends();

	addTriggerToList( "trigger1" );
	addTriggerToList( "trigger2" );
	addTriggerToList( "trigger3" );
	addTriggerToList( "trigger4" );
	addTriggerToList( "trigger5" );
	addTriggerToList( "trigger6" );
	addTriggerToList( "trigger7" );
	addTriggerToList( "trigger8" );
}

addTriggerToList( targetname )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( targetname, "targetname" );
}

messages()
{
	if(isDefined(level.message))
		level.message destroy();

	level.message = newHudElem();
	level.message.x = 0;
	level.message.y = 0;
	level.message.alignX = "center";
	level.message.alignY = "TOP";
	level.message.horzAlign = "center";
	level.message.vertAlign = "TOP";
	level.message.alpha = 1;
	level.message.sort = 10;
	level.message.fontScale = 1.5;
	for(;;)
	{
		level.message setText("^3Report bugs here ^2=> ^4xfire: theviper1996");
		wait 5;
		level.message setText("^3Welcome to ^2-bBF- ^1DEATH^5RUN ^3Server");
		wait 5;
		level.message setText("^3Join us at ^2www.blightysbattlefield.com");
		wait 5;
		level.message setText("^2Amazon: ^3Map by ^2-bBF- ^4V!P3R");
		wait 5;
		level.message setText("^2Special thanks to ^0N!ghtmare ^2for helping with some ideas.");
		wait 5;
	}

}

trap1()
{
	part1 = getent ("trap1_1" ,"targetname");
	part2 = getent ("trap1_2" ,"targetname");
	part3 = getent ("trap1_3" ,"targetname");
	part4 = getent ("trap1_4" ,"targetname");
	part5 = getent ("trap1_5" ,"targetname");
	part6 = getent ("trap1_6" ,"targetname");
	part7 = getent ("trap1_7" ,"targetname");
	part8 = getent ("trap1_8" ,"targetname");
	part9 = getent ("trap1_9" ,"targetname");
	part10 = getent ("trap1_10" ,"targetname");
	part11 = getent ("trap1_11" ,"targetname");
	part12 = getent ("trap1_12" ,"targetname");
	part13 = getent ("trap1_13" ,"targetname");
	part14 = getent ("trap1_14" ,"targetname");
	trap1_p = getent( "trap1_p", "targetname" );
	used = getent ("trap1_used" ,"targetname");
	trig1 = getent( "trigger1", "targetname" );
	trig1   setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig1 waittill( "trigger", player);
	trig1 delete();
	trap1_p rotateroll (25 , 0.7);
	used movey(4 , 0.5);
while (1)
{
	part1 rotateYaw(720 , 3);
	part2 rotateYaw(720 , 3);
	part3 rotateYaw(720 , 3);
	part4 rotateYaw(720 , 3);
	part5 rotateYaw(720 , 3);
	part6 rotateYaw(-720 , 3);
	part7 rotateYaw(-720 , 3);
	part8 rotateYaw(-720 , 3);
	part9 rotateYaw(-720 , 3);
	part10 rotateYaw(720 , 3);
	part11 rotateYaw(720 , 3);
	part12 rotateYaw(720 , 3);
	part13 rotateYaw(720 , 3);
	part14 rotateYaw(720 , 3);
	wait 3;
	part14 rotateYaw(-720 , 3);
	part13 rotateYaw(-720 , 3);
	part12 rotateYaw(-720 , 3);
	part11 rotateYaw(-720 , 3);
	part10 rotateYaw(-720 , 3);
	part9 rotateYaw(720 , 3);
	part8 rotateYaw(720 , 3);
	part7 rotateYaw(720 , 3);
	part6 rotateYaw(720 , 3);
	part5 rotateYaw(-720 , 3);
	part4 rotateYaw(-720 , 3);
	part3 rotateYaw(-720 , 3);
	part2 rotateYaw(-720 , 3);
	part1 rotateYaw(-720 , 3);
	wait 3;
}
}

auto()
{
	auto1 = getent( "auto1", "targetname" );
	auto2 = getent( "auto2", "targetname" );
	auto3 = getent( "auto3", "targetname" );
	auto4 = getent( "auto4", "targetname" );
	auto5 = getent( "auto5", "targetname" );

	auto1 movey (-150 , 0.5);
	auto2 movey (150 , 0.5);
	auto3 movey (-150 , 0.5);
	auto4 movey (150 , 0.5);
	auto5 movey (-150 , 0.5);
	wait 0.5;

while (1)
{
	auto1 movey (300 , 1);
	auto2 movey (-300 , 1);
	auto3 movey (300 , 1);
	auto4 movey (-300 , 1);
	auto5 movey (300 , 1);
	wait 1;
	auto1 movey (-300 , 1);
	auto2 movey (300 , 1);
	auto3 movey (-300 , 1);
	auto4 movey (300 , 1);
	auto5 movey (-300 , 1);
	wait 1;
}
}

trap2()
{
	trap2 = getent( "trap2", "targetname" );
	trig2 = getent( "trigger2", "targetname" );
	trap2_p = getent( "trap2_p", "targetname" );
	used = getent ("trap2_used" ,"targetname");
	trig2   setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig2 waittill( "trigger", player);
	trig2 delete();
	used movey(4 , 0.5);
	trap2_p rotateroll (25 , 0.7);
	trap2 rotateyaw (4680 , 10);
}

trap3()
{
	part1 = getent ("trap3_1" ,"targetname");
	part2 = getent ("trap3_2" ,"targetname");
	part3 = getent ("trap3_3" ,"targetname");
	part4 = getent ("trap3_4" ,"targetname");
	part5 = getent ("trap3_5" ,"targetname");
	part6 = getent ("trap3_6" ,"targetname");
	part7 = getent ("trap3_7" ,"targetname");
	part8 = getent ("trap3_8" ,"targetname");
	trig3 = getEnt ("trigger3", "targetname" );
	used = getent ("trap3_used" ,"targetname");
	trap3_p = getent( "trap3_p", "targetname" );
	trig3   setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig3 waittill ("trigger" , player);
	trig3 delete();
	used movey(4 , 0.5);

	trap3_p rotateroll (25 , 0.7);
	part2 enablelinkto ();
	part2 linkto (part1);
	part3 enablelinkto ();
	part3 linkto (part4);
	part6 enablelinkto ();
	part6 linkto (part5);
	part7 enablelinkto ();
	part7 linkto (part8);
	part1 rotateYaw (25 , 1);
	part4 rotateYaw (-25 , 1);
	part5 rotateYaw (-25 , 1);
	part8 rotateYaw (25 , 1);
	wait 2;
	part2 unlink();
	part3 unlink();
	part6 unlink();
	part7 unlink();
	part2 rotateYaw (-50 , 1);
	part3 rotateYaw (50 , 1);
	part6 rotateYaw (50 , 1);
	part7 rotateYaw (-50 , 1);
}

trap4()
{
	trig4 = getEnt( "trigger4", "targetname" );
	brush1 = getEnt( "trap4_1", "targetname" );
	brush2 = getEnt( "trap4_2", "targetname" );
	brush3 = getEnt( "trap4_3", "targetname" );
	used = getent ("trap4_used" ,"targetname");
	trap4_p = getEnt( "trap4_p", "targetname" );
	trig4   setHintString("^4Press ^2[Use] ^3to activate this ^1trap");

	oldOrigin1 = brush1.origin;
	oldOrigin2 = brush2.origin;
	oldOrigin3 = brush3.origin;

	trig4 waittill( "trigger", player);
	used movey(4 , 0.5);
	trap4_p rotateroll (25 , 0.7);
	moveTo = getEnt( brush1.target, "targetname" );
	brush1 moveTo( moveTo.origin, 1.2 );
	moveTo = getEnt( brush2.target, "targetname" );
	brush2 moveTo( moveTo.origin, 1.2 );
	moveTo = getEnt( brush3.target, "targetname" );
	brush3 moveTo( moveTo.origin, 1.2 );
	wait 1.2;
	trap4_p rotateroll (-25 , 0.7);

	wait 1.2;

	trig4 waittill( "trigger", player);
	trig4 delete();
	trap4_p rotateroll (25 , 0.7);
	brush1 moveTo( oldOrigin1, 1.2 );
	brush2 moveTo( oldOrigin2, 1.2 );
	brush3 moveTo( oldOrigin3, 1.2 );
}

trap5()
{
	push1 = getent ("trap5_1","targetname" );
	push2 = getent ("trap5_2","targetname" );
	push3 = getent ("trap5_3","targetname" );
	push4 = getent ("trap5_4","targetname" );
	push1_kill = getent ("trap5_1_kill","targetname" );
	push2_kill = getent ("trap5_2_kill","targetname" );
	push3_kill = getent ("trap5_3_kill","targetname" );
	push4_kill = getent ("trap5_4_kill","targetname" );
	used = getent ("trap5_used" ,"targetname");
	trap5_p = getent ("trap5_p","targetname" );
	trig5 = getent ("trigger5","targetname" );
	trig5   setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig5 waittill( "trigger", player);
	trig5 delete();
	used movey(4 , 0.5);
	trap5_p rotateroll (25 , 0.7);
	push1_kill enablelinkto();
	push1_kill linkto(push1);
	push2_kill enablelinkto();
	push2_kill linkto(push2);
	push3_kill enablelinkto();
	push3_kill linkto(push3);
	push4_kill enablelinkto();
	push4_kill linkto(push4);
	wait 0.5;
	while (1)
	{
	push1 rotateroll (360 ,1.5);
	push2 rotateroll (-360 ,1.5);
	push3 rotateroll (360 ,1.5);
	push4 rotateroll (-360 ,1.5);
	wait 1.5;
	}
}

trap6()
{
	trig6 = getent ("trigger6","targetname");
	trap6 = getent ("trap6","targetname");
	trap6_p = getent ("trap6_p","targetname" );
	used = getent ("trap6_used" ,"targetname");
	trig6 setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig6 waittill ("trigger", player);
	used movex(4 , 0.5);
	trig6 delete ();
	trap6_p rotatepitch (-25 , 0.7);
	while (1)
		{
		trap6 rotateroll (360 , 4 );
		wait 1 ;
		}
}

trap7()
{
	trap7_1 = getent( "trap7_1" , "targetname" );
	trap7_2 = getent( "trap7_2" , "targetname" );
	trap7_3 = getent( "trap7_3" , "targetname" );
	used = getent ("trap7_used" ,"targetname");
	trig7 = getent ("trigger7" , "targetname");
	trap7_p = getent ("trap7_p","targetname" );
	trig7  setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig7 waittill ("trigger" , player);
	used movex(4 , 0.5);
	trig7 delete ();
	trap7_p rotatepitch (-25 , 0.7);
	wait 0.5;
        while( 1 )
	{
		trap7_1 rotatepitch( -360, 3 );
		trap7_2 rotatepitch( 360, 3 );
		trap7_3 rotatepitch( -360, 3 );
		wait 3;
	}
}

trap8()
{
	trig8 = getent ("trigger8", "targetname");
	brush_1 = getent ("brush_1","targetname");
	brush_2 = getent ("brush_2","targetname");
	used = getent ("trap8_used" ,"targetname");
	trap8_p = getent ("trap8_p","targetname" );
	trig8   setHintString("^4Press ^2[Use] ^3to activate this ^1trap");
	trig8 waittill ("trigger",player);
	used movex(4 , 0.5);
	trig8 delete ();
	trap8_p rotatepitch (-25 , 0.7);
	brush_1 rotateroll ( 90 , 1 ) ;
	brush_2 rotateroll (- 90, 1 ) ;
	wait 2 ;
	brush_1 rotateroll (- 90 , 1 ) ;
	brush_2 rotateroll ( 90 , 1 ) ;
	wait 2 ;
}

end_message()
{
	trig = getEnt("endmap_trig","targetname");
	trig waittill("trigger" , player);
	trig delete();
	iPrintlnBold("^4"+player.name+" ^2Finished at first place!");
}

dogs()
{
	dogs_trig = getent ("dogs_trig","targetname");
while(1)
{
	dogs_trig waittill ("trigger",player);
	iPrintlnBold("^4"+player.name+" ^2became a ^1victim ^2of the hungry dogs ^3xD");
	player PlaySound("dogs");
wait 0.2;
}
}

water()
{
	trig = getent("water", "targetname");
	while(true)
	{
	trig waittill ("trigger", who);
	x = RandomInt(30);
	if( x < 10 )
		{
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 9 && x < 20  )
		{
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 19 )
		{
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		PlayFX( level.splash_fx, who.origin );
		}
	}
}


water1()
{
	trig1 = getent("water1", "targetname");
	while(true)
	{
	trig1 waittill ("trigger", who);
	x = RandomInt(30);
	if( x < 10 )
		{
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 9 && x < 20  )
		{
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 19 )
		{
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		PlayFX( level.splash_fx, who.origin );
		}
	}
}

water2()
{
	trig2 = getent("water2", "targetname");
	while(true)
	{
	trig2 waittill ("trigger", who);
	x = RandomInt(30);
	if( x < 10 )
		{
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 9 && x < 20  )
		{
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 19 )
		{
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		PlayFX( level.splash_fx, who.origin );
		}
	}
}

water3()
{
	trig3 = getent("water3", "targetname");
	while(true)
	{
	trig3 waittill ("trigger", who);
	x = RandomInt(30);
	if( x < 10 )
		{
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 9 && x < 20  )
		{
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 19 )
		{
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		PlayFX( level.splash_fx, who.origin );
		}
	}
}

water4()
{
	trig4 = getent("water4", "targetname");
	while(true)
	{
	trig4 waittill ("trigger", who);
	x = RandomInt(30);
	if( x < 10 )
		{
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 9 && x < 20  )
		{
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 19 )
		{
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		PlayFX( level.splash_fx, who.origin );
		}
	}
}

bounce_fall()
{
	fall = getEnt("bounce_fall","targetname");
	while(1)
	{
		fall waittill("trigger",player);
	x = RandomInt(30);
	if( x < 10 )
		{
		player PlaySound ("splash1");
		player PlaySound ("splash1");
		player PlaySound ("splash1");
		player PlaySound ("splash1");
		player PlaySound ("splash1");
		PlayFX( level.splash_fx, player.origin );
		}
	if( x > 9 && x < 20  )
		{
		player PlaySound ("splash2");
		player PlaySound ("splash2");
		player PlaySound ("splash2");
		player PlaySound ("splash2");
		player PlaySound ("splash2");
		PlayFX( level.splash_fx, player.origin );
		}
	if( x > 19 )
		{
		player PlaySound ("splash3");
		player PlaySound ("splash3");
		player PlaySound ("splash3");
		player PlaySound ("splash3");
		player PlaySound ("splash3");
		PlayFX( level.splash_fx, player.origin );
		}
		if( player.pers["team"] == "allies" )
				{
					player SetOrigin((-1418.83, 1968.34, -3434.87));
					player.health = player.maxhealth;
				}
		else
		if( player.pers["team"] == "axis" )
				{
					player SetOrigin((2511.51, 1974.89, -3434.87));
					player.health = player.maxhealth;
				}


	}
}

mapper_name()
{
	trigm = getent ("mapper_trig", "targetname");
	st = getent( "1st", "targetname" );
	earth1 = getent ("earth1","targetname");
	earth2 = getent ("earth2","targetname");
	earth3 = getent ("earth3","targetname");
	earth4 = getent ("earth4","targetname");
	earth5 = getent ("earth5","targetname");
	earth6 = getent ("earth6","targetname");
	earth7 = getent ("earth7","targetname");
	earth8 = getent ("earth8","targetname");
	earth9 = getent ("earth9","targetname");
	earth10 = getent ("earth10","targetname");
	earth11 = getent ("earth11","targetname");
	earth12 = getent ("earth12","targetname");
	earth13 = getent ("earth13","targetname");
	earth14 = getent ("earth14","targetname");
	earth15 = getent ("earth15","targetname");
	earth16 = getent ("earth16","targetname");
	earth17 = getent ("earth17","targetname");
	earth18 = getent ("earth18","targetname");
	earth19 = getent ("earth19","targetname");
	earth20 = getent ("earth20","targetname");
	earth21 = getent ("earth21","targetname");
	earth22 = getent ("earth22","targetname");
	earth23 = getent ("earth23","targetname");
	earth24 = getent ("earth24","targetname");
	earth25 = getent ("earth25","targetname");
	earth26 = getent ("earth26","targetname");
	earth27 = getent ("earth27","targetname");
	earth28 = getent ("earth28","targetname");
	earth29 = getent ("earth29","targetname");
	earth30 = getent ("earth30","targetname");
	earth31 = getent ("earth31","targetname");
	earth32 = getent ("earth32","targetname");
	earth33 = getent ("earth33","targetname");
	earth34 = getent ("earth34","targetname");
	earth35 = getent ("earth35","targetname");

	trigm waittill("trigger",player);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] PlaySound ("volcano");
	player iPrintlnBold("^4You won ^240 ^1XP points");
	player braxi\_rank::giveRankXP( "win", 40);
	trigm delete();
	earthquake( 2, 1, earth1.origin, 512 );
	earthquake( 2, 1, earth2.origin, 512 );
	earthquake( 2, 1, earth3.origin, 512 );
	earthquake( 2, 1, earth4.origin, 512 );
	earthquake( 2, 1, earth5.origin, 512 );
	earthquake( 2, 1, earth6.origin, 512 );
	earthquake( 2, 1, earth7.origin, 512 );
	earthquake( 2, 1, earth8.origin, 512 );
	earthquake( 2, 1, earth9.origin, 512 );
	earthquake( 2, 1, earth10.origin, 512 );
	earthquake( 2, 1, earth11.origin, 512 );
	earthquake( 2, 1, earth12.origin, 512 );
	earthquake( 2, 1, earth13.origin, 512 );
	earthquake( 2, 1, earth14.origin, 512 );
	earthquake( 2, 1, earth15.origin, 512 );
	earthquake( 2, 1, earth16.origin, 512 );
	earthquake( 2, 1, earth17.origin, 512 );
	earthquake( 2, 1, earth18.origin, 512 );
	earthquake( 2, 1, earth19.origin, 512 );
	earthquake( 2, 1, earth20.origin, 512 );
	earthquake( 2, 1, earth21.origin, 512 );
	earthquake( 2, 1, earth22.origin, 512 );
	earthquake( 2, 1, earth23.origin, 512 );
	earthquake( 2, 1, earth24.origin, 512 );
	earthquake( 2, 1, earth25.origin, 512 );
	earthquake( 2, 1, earth26.origin, 512 );
	earthquake( 2, 1, earth27.origin, 512 );
	earthquake( 2, 1, earth28.origin, 512 );
	earthquake( 2, 1, earth29.origin, 512 );
	earthquake( 2, 1, earth30.origin, 512 );
	earthquake( 2, 1, earth31.origin, 512 );
	earthquake( 2, 1, earth32.origin, 512 );
	earthquake( 2, 1, earth33.origin, 512 );
	earthquake( 2, 1, earth34.origin, 512 );
	earthquake( 2, 1, earth35.origin, 512 );
	st movez ( 1300 , 0.5 );
	wait 1.5;
	thread moveb ();
	st movex ( 10000 , 3.5 );
	wait 3.5;
	st movey ( 1580 , 2 );
	wait 2;
}

moveb()
{
	b = getent( "b", "targetname" );
	b movez ( 1300 , 0.5 );
	wait 1.5;
	thread moveb2 ();
	b movex ( 9200 , 3.25 );
	wait 3.25;
	b movey ( 1580 , 2 );
	wait 2;
}

moveb2()
{
	b2 = getent( "b2", "targetname" );
	b2 movez ( 1300 , 0.5 );
	wait 1.5;
	thread movef ();
	b2 movex ( 8400 , 3 );
	wait 3;
	b2 movey ( 1580 , 2 );
	wait 2;
}

movef()
{
	f = getent( "f", "targetname" );
	f movez ( 1300 , 0.5 );
	wait 1.5;
	thread movend ();
	f movex ( 7600 , 2.75 );
	wait 2.75;
	f movey ( 1580 , 2 );
	wait 2;
}

movend()
{
	nd = getent( "2nd", "targetname" );
	nd movez ( 1300 , 0.5 );
	wait 1.5;
	thread movev ();
	nd movex ( 6800 , 2.5 );
	wait 2.5;
	nd movey ( 1580 , 2 );
	wait 2;
}

movev()
{
	v = getent( "v", "targetname" );
	v movez ( 1300 , 0.5 );
	wait 1.5;
	thread movei ();
	v movex ( 6000 , 2.25 );
	wait 2.25;
	v movey ( 1580 , 2 );
	wait 2;
}
movei()
{
	i = getent( "i", "targetname" );
	i movez ( 1300 , 0.5 );
	wait 1.5;
	thread movep ();
	i movex ( 5200 , 2 );
	wait 2;
	i movey ( 1580 , 2 );
	wait 2;
}

movep()
{
	p = getent( "p", "targetname" );
	p movez ( 1300 , 0.5 );
	wait 1.5;
	thread movee ();
	p movex ( 4400 , 1.75 );
	wait 1.75;
	p movey ( 1580 , 2 );
	wait 2;
}

movee()
{
	e = getent( "e", "targetname" );
	e movez ( 1300 , 0.5 );
	wait 1.5;
	thread mover ();
	e movex ( 3600 , 1.5 );
	wait 1.5;
	e movey ( 1580 , 2 );
	wait 2;
}

mover()
{
	r = getent( "r", "targetname" );
	r movez ( 1300 , 0.5 );
	wait 1.5;
	r movex ( 2800 , 1.25 );
	wait 1.25;
	r movey ( 1580 , 2 );
	wait 2;
}

extra()
{
	extra = getent( "extra", "targetname" );
while(1)
{
	extra waittill ("trigger" , player);
//V!P3R
if(player getGuid() == "590698b8db585853b5c6f29d7b4d874b")
{
	if(player getStance() == "stand")
	{
	player iPrintlnBold("^3High Speed");
	}
	if(player getStance() == "prone")
	{
	player iPrintlnBold("^3Extra life");
	player braxi\_mod::givelife();
	}
	if(player getStance() == "crouch")
	{
	}
}
//N!ghtmare
if(player getguid() == "3c8ae180102243812ac62a580ba9f68a")
{
	if(player getStance() == "stand")
	{
	player iPrintlnBold("^3High Speed");
	}
	if(player getStance() == "crouch")
	{
	player iPrintlnBold("^31000 XP");
	player braxi\_rank::giverankxp("kill" , 1000);
	}
	if(player getStance() == "prone")
	{
	player iPrintlnBold("^3Extra life");
	player braxi\_mod::givelife();
	}
}
if(player getguid() != "590698b8db585853b5c6f29d7b4d874b" && player getguid() != "3c8ae180102243812ac62a580ba9f68a")
{
	player iPrintlnBold("^2What did you expect Sweety?");
	player suicide();
	wait 1;
	iPrintlnBold("^2Nice Try, Keep believing in ^3Santa Claus ^4"+player.name+"");
}
wait 0.2;
}
}

extra2()
{
	extra2 = getent( "extra2" , "targetname" );
	self.hide = false;
while(1)
{
	extra2 waittill("trigger" , player);
if(player getGuid() == "590698b8db585853b5c6f29d7b4d874b")
{
	if(player getStance() == "stand")
	{
		if(!player.hide)
		{
		player hide();
		player.hide = true;
		player iPrintlnBold("Invisible mode ^2ON");
		}
		else
		{
		player show();
		player.hide = false;
		player iPrintlnBold("Invisible mode ^1OFF");
		}
	}

	if(player getStance() == "crouch")
	{
		player thread jetpack();
		player iPrintlnBold("^3Jetpack");
	}
	if(player getstance() == "prone")
	{
	player braxi\_rank::giverankxp("kill" , 1000);
	player iprintlnbold("^31000 XP");
	}
wait 0.1;
}
//N!ghtmare
if(player getguid() == "3c8ae180102243812ac62a580ba9f68a")
{
	if(player getStance() == "stand")
	{
	player iPrintlnBold("^3High Speed");
	}
	if(player getStance() == "crouch")
	{
	player iPrintlnBold("^31000 XP");
	player braxi\_rank::giverankxp("kill" , 1000);
	}
	if(player getStance() == "prone")
	{
	player iPrintlnBold("^3Extra life");
	player braxi\_mod::givelife();
	}
}
if(player getguid() != "590698b8db585853b5c6f29d7b4d874b" && player getguid() != "3c8ae180102243812ac62a580ba9f68a")
{
	player iPrintlnBold("^2What did you expect Sweety?");
	player suicide();
	wait 1;
	iPrintlnBold("^2Nice Try, Keep believing in ^3Santa Claus ^4"+player.name+"");
}
wait 0.2;
}
}

jetpack()
{
self endon("death");
self endon("disconnect");
if(!isdefined(self.jetwait) || self.jetwait == 0)
{
	self.user = spawn( "script_origin", self.origin );
	self.user.angles = self.angles;
	self linkto (self.user);
	self.linkeduser = true;
	self.user moveto( self.user.origin + (0,0,25), 0.5 );

while(self.linkeduser == true)
{
	Earthquake( 0.1, 1, self.user.origin, 100 );
	PlayFX( level.jetpack_stop , self.origin );
	angle = self getplayerangles();
   	if( self useButtonPressed() )
   	{
	PlayFX( level.jetpack , self.origin );
   	self thread moveonangle(angle);
   	}
   	if( self meleebuttonpressed() || self.health < 1 )
	{
	self thread jetpack_disabled();
	}
	if( self fragButtonPressed() )
	{
	self jetpack_vertical( "up" );
	}
	if( self attackbuttonpressed() )
	{
	self jetpack_vertical( "down" );
	}
wait 0.01;
}
}
}

moveonangle(angle)
{
	forward = maps\mp\_utility::vector_scale(anglestoforward(angle), 80 );
	forward2 = maps\mp\_utility::vector_scale(anglestoforward(angle), 105 );
	if( bullettracepassed( self.origin, self.origin + forward2, false, undefined ) )
	{
	self.user moveto( self.user.origin + forward, 0.1 );
	}
	else
	{
	self.user moveto( self.user.origin - forward, 0.25 );
	}
}

jetpack_vertical( dir )
{
vertical = (0,0,50);
vertical2 = (0,0,100);

	if( dir == "up" )
	{
	if( bullettracepassed( self.user.origin,  self.user.origin + vertical2, false, undefined ) )
	{
	self.user moveto( self.user.origin + vertical, 0.25 );
	}
	else
	{
	self.user moveto( self.user.origin - vertical, 0.25 );
	}
	}
	else
	if( dir == "down" )
	{
	if( bullettracepassed( self.user.origin,  self.user.origin - vertical, false, undefined ) )
	{
	self.user moveto( self.user.origin - vertical, 0.25 );
	}
	else
	{
	self.user moveto( self.user.origin + vertical, 0.25 );
	}
	}
}

jetpack_disabled()
{
self unlink();
self.linkeduser = false;
wait 0.01;
}

bounce_weap()
{
	mp5 = getent( "mp5", "targetname" );
	mp5 waittill("trigger" , player);
	player TakeAllWeapons();
	player GiveWeapon("mp5_reflex_mp");
	wait 0.01;
	player SwitchToWeapon("mp5_reflex_mp");
	mp5 delete();
}

ends()
{
	sniper_trig = getent("sniper_trig" , "targetname");
	bounce_trig = getent("bounce_trig" , "targetname");
	knife_trig = getent("knife_trig" , "targetname");
	old_trig = getent("old_trig" , "targetname");
	sniper_lock = getent("sniper_lock" , "targetname");
	bounce_lock = getent("bounce_lock" , "targetname");
	knife_lock = getent("knife_lock" , "targetname");
	old_lock = getent("old_lock" , "targetname");
	door = getEnt("end_door","targetname");

	old_trig thread old();
	sniper_trig thread sniper();
	bounce_trig thread bounce_room();
	knife_trig thread knife();
}

old()
{
	sniper_lock = getent("sniper_lock" , "targetname");
	bounce_lock = getent("bounce_lock" , "targetname");
	knife_lock = getent("knife_lock" , "targetname");
	old_lock = getent("old_lock" , "targetname");
	door = getEnt("end_door","targetname");
while(1)
{
	self waittill("trigger" , player);
	sniper_lock movex(122,0.1);
	bounce_lock movex(122,0.1);
	knife_lock movex(122,0.1);
	old_lock movex(122,0.1);

	player SetOrigin((9910.13, -3217.51, -408));
	player SetPlayerAngles((0,90,0));
	door movez(-500 , 5);
	iPrintlnBold("^4"+player.name+" ^2has entered the ^1OLD ^2way");

	thread old_acti();

	player death();
	sniper_lock movex(-122,0.3);
	bounce_lock movex(-122,0.3);
	knife_lock movex(-122,0.3);
	old_lock movex(-122,0.3);
	iprintlnbold("^4"+player.name+" ^1died");
	iprintlnbold("^2Doors are opened.");
}
}

old_acti()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((9954.1, -1531.08, -423.3));
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

sniper()
{
	sniper_lock = getent("sniper_lock" , "targetname");
	bounce_lock = getent("bounce_lock" , "targetname");
	knife_lock = getent("knife_lock" , "targetname");
	old_lock = getent("old_lock" , "targetname");
while(1)
{
	self waittill("trigger", player);

	sniper_lock movex(122,0.1);
	bounce_lock movex(122,0.1);
	knife_lock movex(122,0.1);
	old_lock movex(122,0.1);

	player SetOrigin((16093.8, 3111.6, 1607.2));
	player SetPlayerAngles((0,270,0));

	iprintlnbold("^4"+player.name+" ^2has entered the ^1SNIPER ^2area");

	player TakeAllWeapons();
	player GiveWeapon("remington700_mp");
	player GiveMaxAmmo("remington700_mp");
	wait 0.01;
	player SwitchToWeapon("remington700_mp");

	thread sniper_acti();

	player death();
	sniper_lock movex(-122,0.3);
	bounce_lock movex(-122,0.3);
	knife_lock movex(-122,0.3);
	old_lock movex(-122,0.3);
	iprintlnbold("^4"+player.name+" ^1died");
	iprintlnbold("^2Doors are opened.");
}
}

death()
{
self endon("disconnect");

self waittill("death");
}

sniper_acti()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,90,0));
			players[i] SetOrigin((16041.6, 109, 1609.2));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("remington700_mp");
			players[i] GiveMaxAmmo("remington700_mp");
			wait 0.01;
			players[i] SwitchToWeapon("remington700_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

bounce_room()
{
	sniper_lock = getent("sniper_lock" , "targetname");
	bounce_lock = getent("bounce_lock" , "targetname");
	knife_lock = getent("knife_lock" , "targetname");
	old_lock = getent("old_lock" , "targetname");
while(1)
{
	self waittill("trigger", player);

	sniper_lock movex(122,0.1);
	bounce_lock movex(122,0.1);
	knife_lock movex(122,0.1);
	old_lock movex(122,0.1);

	player SetOrigin((-1418.83, 1968.34, -3434.87));
	player SetPlayerAngles((0,90,0));

	iprintlnbold("^4"+player.name+" ^2has entered the ^1BOUNCE ^2room");

	player TakeAllWeapons();
	player GiveWeapon("tomahawk_mp");
	player GiveMaxAmmo("tomahawk_mp");
	wait 0.01;
	player SwitchToWeapon("tomahawk_mp");

	thread bounce_acti();

	player death();
	sniper_lock movex(-122,0.3);
	bounce_lock movex(-122,0.3);
	knife_lock movex(-122,0.3);
	old_lock movex(-122,0.3);
	iprintlnbold("^4"+player.name+" ^1died");
	iprintlnbold("^2Doors are opened.");
}
}

bounce_acti()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((2511.51, 1974.89, -3434.87));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("tomahawk_mp");
			players[i] GiveMaxAmmo("tomahawk_mp");
			wait 0.01;
			players[i] SwitchToWeapon("tomahawk_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

knife()
{
	sniper_lock = getent("sniper_lock" , "targetname");
	bounce_lock = getent("bounce_lock" , "targetname");
	knife_lock = getent("knife_lock" , "targetname");
	old_lock = getent("old_lock" , "targetname");
while(1)
{
	self waittill("trigger", player);

	sniper_lock movex(122,0.1);
	bounce_lock movex(122,0.1);
	knife_lock movex(122,0.1);
	old_lock movex(122,0.1);

	player SetOrigin((-1939.52, 593.201, -539.111));
	player SetPlayerAngles((0,270,0));

	iprintlnbold("^4"+player.name+" ^2has entered the ^1KNIFE ^2area");

	player TakeAllWeapons();
	player GiveWeapon("knife_mp");
	player GiveMaxAmmo("knife_mp");
	wait 0.01;
	player SwitchToWeapon("knife_mp");

	thread knife_acti();

	player death();
	sniper_lock movex(-122,0.3);
	bounce_lock movex(-122,0.3);
	knife_lock movex(-122,0.3);
	old_lock movex(-122,0.3);
	iprintlnbold("^4"+player.name+" ^1died");
	iprintlnbold("^2Doors are opened.");
}
}

knife_acti()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,90,0));
			players[i] SetOrigin((-2004.9, -844.2, -539.1));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("knife_mp");
			players[i] GiveMaxAmmo("knife_mp");
			wait 0.01;
			players[i] SwitchToWeapon("knife_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}