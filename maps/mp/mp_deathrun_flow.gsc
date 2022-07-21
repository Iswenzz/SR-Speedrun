#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
		thread sr\api\_speedrun::createNormalWays("Way 1;Way 2;Way 3;Way 4;Way 5;");
	thread sr\api\_speedrun::createEndMap((-1792.41, 8784.88, -239.875), 80, 100, "normal_0");
	thread sr\api\_speedrun::createEndMap((-1319.51, 7104.87, 144.125), 100, 100, "normal_1");
	thread sr\api\_speedrun::createEndMap((-797.81, 8495.07, 496.125), 95, 100, "normal_2");
	thread sr\api\_speedrun::createEndMap((-312.31, 9363.85, 16.125), 125, 100, "normal_3");
	thread sr\api\_speedrun::createEndMap((215.155, 9824.88, 352.125), 175, 100, "normal_4");
	thread sr\api\_speedrun::createTeleporter((-1307.19, 2040.07, 144.125), 45, 100, (-1318, 2466, 204), 89,"freeze");
	thread sr\api\_speedrun::createTeleporter((-1300.21, 4424.46, 144.125), 105, 100, (-1317, 5349, 204), 90,"freeze");
	thread sr\api\_speedrun::createTeleporter((-799.761, 4271.27, 496.125), 95, 100, (-803, 5750, 556), 91,"freeze");
	
	maps\mp\_load::main();

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
	addTriggerToList("trigger5");
	addTriggerToList("trigger6");
	addTriggerToList("trigger7");
	addTriggerToList("trigger8");
	addTriggerToList("trigger9");
	addTriggerToList("trigger10");
	addTriggerToList("trigger11");
	addTriggerToList("trigger12");
	addTriggerToList("trigger13");
	addTriggerToList("trigger14");
	addTriggerToList("trigger15");
	addTriggerToList("trigger16");
	addTriggerToList("trigger17");
	addTriggerToList("trigger18");
	addTriggerToList("trigger19");
	addTriggerToList("trigger19_fixed");
	addTriggerToList("trigger20");
	addTriggerToList("trigger21");
	addTriggerToList("trigger22");
	addTriggerToList("trigger23");
	addTriggerToList("trigger24");
	addTriggerToList("trigger25");
	addTriggerToList("trigger26");
	addTriggerToList("trigger27");
	addTriggerToList("trigger28");
	addTriggerToList("trigger29");
	addTriggerToList("trigger30");
	addTriggerToList("trigger31");
	addTriggerToList("trigger32");
	addTriggerToList("trigger33");
	addTriggerToList("trigger34");
	addTriggerToList("trigger35");
	addTriggerToList("trigger36");
	addTriggerToList("trigger37");
	addTriggerToList("trigger38");
	addTriggerToList("trigger39");
	addTriggerToList("trigger40");
	addTriggerToList("trigger41");
	addTriggerToList("trigger42");

	thread change_way1();
	thread change_way2();
	thread change_way3();
	thread change_way4();
	thread change_way5();
	thread randomRoute();
	thread moveme();
	thread pedotime();
	thread movetogether();
	thread enter35();
	thread avoidbug();
	thread lol();
	thread act2();
	/////////////////
	thread movearound();
	thread fuckyou();
	thread trap_01();
	thread trap_02();
	thread trap_03();
	thread trap_04();
	thread trap_05();
	thread trap_07();
	thread trap_08();
	thread trap_09();
	thread trap_10();
	thread trap_11();
	thread trap_12();
	thread trap_13();
	thread trap_14();
	thread trap_15();
	thread trap_16();
	thread trap_17();
	thread trap_18();
	thread trap_19();
	thread trap_20();
	thread trap_21();
	thread trap_22();
	thread trap_23();
	thread trap_24();
	thread trap_26();
	thread trap_27();
	thread trap_28();
	thread trap_29();
	thread trap_30();
	thread trap_31();
	thread trap_32();
	thread trap_33();
	thread trap_34();
	thread trap_35();
	thread trap_36();
	thread trap_37();
	thread trap_38();
	thread trap_39();
	thread trap_40();
	thread trap_41();
	thread trap_42();
}
change_way1() 
{
    trigg = spawn( "trigger_radius", (-1803.4, 1011.52, 16.125), 0, 90, 100 );

	for(;;)
	{
		trigg waittill("trigger",player);
		player thread sr\api\_speedrun::changeWay("normal_0");

	}

}
change_way2() 
{
    trigg = spawn( "trigger_radius", (-1329.29, 1015.58, 16.125), 0, 110, 100 );

	for(;;)
	{
		trigg waittill("trigger",player);
		player thread sr\api\_speedrun::changeWay("normal_1");

	}

}
change_way3() 
{
    trigg = spawn( "trigger_radius", (-805.288, 1065.3, 30.7107), 0, 115, 70 );

	for(;;)
	{
		trigg waittill("trigger",player);
		player thread sr\api\_speedrun::changeWay("normal_2");

	}

}
change_way4() 
{
    trigg = spawn( "trigger_radius", (-285.239, 1058.8, 16.125), 0, 105, 100 );

	for(;;)
	{
		trigg waittill("trigger",player);
		player thread sr\api\_speedrun::changeWay("normal_3");

	}

}
change_way5() 
{
    trigg = spawn( "trigger_radius", (218.339, 1036.86, 23.8963), 0, 110, 100 );

	for(;;)
	{
		trigg waittill("trigger",player);
		player thread sr\api\_speedrun::changeWay("normal_4");


	}

}
addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
lol()
{
  rotate_obj = getentarray("rotateme_trap","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
   }
  }
}

enter35()
{
	level endon("triggeraqdsqz");
	trig = getent ("enter35","targetname");
	brush = getent ("enter35del","targetname");

	trig waittill( "triggeraqdsqz", player );
	trig delete();
	
	brush delete();


}



act2()
{
	level endon("triggerazazaz");
	trig = getent ("act2","targetname");
	floor1 = getent ("act2_floor","targetname");
	trig waittill( "triggerazazaz", player );
	trig delete();	
	wait 5;
	floor1 delete();
}




avoidbug()
{
	level endon("triggerv");
	trig = getent ("avoidbugtrig","targetname");
	brush1 = getEnt( "avoidbug1", "targetname" );
	brush2 = getEnt( "avoidbug2", "targetname" );
	brush3 = getEnt( "avoidbug3", "targetname" );
	brush4 = getEnt( "avoidbug4", "targetname" );
	brush5 = getEnt( "avoidbug5", "targetname" );			
	
	
	trig waittill( "triggerv", player );
	trig delete();
	
	
	wait 2;
	brush1 movez( -200, 2 );
	brush2 movez( -2000, 2 );
	brush3 movez( -150, 2 );
	brush4 movez( -300, 2 );
	brush5 movez( -800, 2 );
				
}
randomRoute()
{	
	door = [];
	door[0] = getEnt( "door1", "targetname" );
	door[1] = getEnt( "door2", "targetname" );
	door[2] = getEnt( "door3", "targetname" );
	door[3] = getEnt( "door4", "targetname" );
	door[4] = getEnt( "door5", "targetname" );
	
	
	
	door[0] delete();
	door[1] delete();
	door[2] delete();
	door[3] delete();
	door[4] delete();
	
	
}

movetogether()
{
	trig = getEnt( "movetogethertrig", "targetname" );

	trig waittill( "trigger", who );
	trig delete();
	
}


pedotime()
{
	level endon("triggeqsqsr");
	trig = getEnt( "pedotimetrig", "targetname" );
	pedotime1 = getEnt( "pedotime", "targetname" );
	pedotime2 = getEnt( "pedotime2", "targetname" );
	pedotime3 = getEnt( "pedotime3", "targetname" );

	trig waittill( "triggeqsqsr", who );
	trig delete();

	pedotime1 movez( 112, 5 );

	
	pedotime2 movez( 112, 5 );

	
	pedotime3 movez( 112, 5 );

}


//*******************************************TRAPS*******************************************//


trap_01()
{
	trig = getent ("trigger1","targetname");
	dmg = getent ("trap1_dmg","targetname");
	c41 = getEnt( "c41", "targetname" );
	c42 = getEnt( "c42", "targetname" );
	c43 = getEnt( "c43", "targetname" );
	c44 = getEnt( "c44", "targetname" );
	c45 = getEnt( "c45", "targetname" );
	c46 = getEnt( "c46", "targetname" );
	
	trig delete();
	c41 delete();
	c42 delete();
	c43 delete();
	c44 delete();
	c45 delete();
	c46 delete();
	dmg delete();
}




trap_02()
{
	trig = getEnt( "trigger2", "targetname" );
	squeeze1 = getEnt( "squeeze1", "targetname" );
	squeeze2 = getEnt( "squeeze2", "targetname" );

	trig delete();

	squeeze1 delete();
	squeeze2 delete();
	
}


trap_03()
{
	level endon("triggersqdsdsdsd");
	trig = getent ("trigger3","targetname");
	brush = getent ("trap_03brush","targetname");
		
	trig waittill( "triggersqdsdsdsd", who );
	trig delete();
	brush delete();

}


trap_04()
{
	slid1 =getent("slid1","targetname");
	slid2 =getent("slid2","targetname");
}


trap_05()
{
	level endon("triggerwxxwxw");
	trig = getent ("trigger5","targetname");
	dmg = getent ("trap05_dmg","targetname");
	safe = getent ("safe","targetname");
	firesound =	getent("firesound","targetname");


	dmg maps\mp\_utility::triggerOff();
	
	trig waittill( "triggerwxxwxw", player );
	trig delete();



		
	dmg maps\mp\_utility::triggerOn();	
	
	wait 5;
	
	safe movez( 32, 3 );
	dmg delete();
	
					
}


trap_07()
{
	level endon("triggerzezerzr");
	trig = getEnt( "trigger7", "targetname" );
	brushGroup1 = getEntArray( "trap07_1", "targetname" );
	brushGroup2 = getEntArray( "trap07_2", "targetname" );
	clip1 = getent("clip1","targetname");
	clip2 = getent("clip2","targetname");
	block1 = getent("block1","targetname");
	block2 = getent("block2","targetname");



	trig waittill( "triggerzezerzr", who );
	trig delete();

	
	clip1 movez( 208, 1 );
	clip2 movez( 208, 1 );
	block1 movez( 112, 2 );
	block2 movez( 112, 2 );
		
		
	wait 7.5;

	
	brushGroup1[randomInt(brushGroup1.size)] notSolid();
	brushGroup2[randomInt(brushGroup2.size)] notSolid();


		
	
	wait 5;
	
	clip1 movez( -208, 1 );
	clip2 movez( -208, 1 );
	block1 movez( -112, 2 );
	block2 movez( -112, 2 );

}


trap_08()
{
	level endon("triggerqsdq");
	trig = getEnt( "trigger8", "targetname" );
	updown1 =getent("updown1","targetname");
	updown2 =getent("updown2","targetname");
	updown3 =getent("updown3","targetname");
	updown4 =getent("updown4","targetname");
	updown5 =getent("updown5","targetname");
	updown6 =getent("updown6","targetname");
	updown7 =getent("updown7","targetname");
	updown8 =getent("updown8","targetname");

	
	
	trig waittill( "triggerqsdq", who );
	trig delete();
	
	
	while(1)
		{	
		wait(2);
		
		updown1 movez( -500, 3 );
		updown2 movez( -500, 3 );
		updown3 movez( -500, 3 );
		updown4 movez( -500, 3 );
		updown5 movez( -500, 3 );
		updown6 movez( -500, 3 );
		updown7 movez( -500, 3 );
		updown8 movez( -500, 3 );

		wait(5);
		
		updown1 movez( 500, 5 );
		updown2 movez( 500, 5 );
		updown3 movez( 500, 5 );
		updown4 movez( 500, 5 );
		updown5 movez( 500, 5 );
		updown6 movez( 500, 5 );
		updown7 movez( 500, 5 );
		updown8 movez( 500, 5 );

		wait(7);	
		}
}


trap_09()
{
	trig = getEnt( "trigger9", "targetname" );
	movingdown =getent("movingdown","targetname");
	clip112 =getent("clip112","targetname");
	dmg = getent ("trap9_dmg","targetname");
		
	trig delete();
	movingdown delete();
	clip112 delete();	
	dmg delete();

}


trap_10()
{
	trig = getent ("trigger10","targetname");
	dmg = getent ("trap10_dmg","targetname");
	clips = getEnt( "clips", "targetname" );
	be1 = getEnt( "be1", "targetname" );
	be2 = getEnt( "be2", "targetname" );
	be3 = getEnt( "be3", "targetname" );
	be4 = getEnt( "be4", "targetname" );
	be5 = getEnt( "be5", "targetname" );
	be6 = getEnt( "be6", "targetname" );
	be7 = getEnt( "be7", "targetname" );
	be8 = getEnt( "be8", "targetname" );
	be9 = getEnt( "be9", "targetname" );
	be10 = getEnt( "be10", "targetname" );
	be11 = getEnt( "be11", "targetname" );
	be12 = getEnt( "be12", "targetname" );
	be13 = getEnt( "be13", "targetname" );
	be14 = getEnt( "be14", "targetname" );
	be15 = getEnt( "be15", "targetname" );
	be16 = getEnt( "be16", "targetname" );
	be17 = getEnt( "be17", "targetname" );

	trig delete();
	
	be1 delete();
	be2 delete();
	be3 delete();
	be4 delete();
	be5 delete();
	be6 delete();
	be7 delete();
	be8 delete();
	be9 delete();
	be10 delete();
	be11 delete();
	be12 delete();
	be13 delete();
	be14 delete();
	be15 delete();
	be16 delete();
	be17 delete();
	clips delete();
	dmg delete();
					

}


trap_11()
{
	slid1_1 =getent("slid1_1","targetname");

}


trap_12()
{
	level endon("triggerazrr");
	trig = getEnt( "trigger12", "targetname" );
	brush = getEnt( "trap12", "targetname" );

	trig waittill( "triggerazrr", who );
	trig delete();

	while( isDefined( brush ) )
	{
		brush rotateRoll( 180, 8 );
		wait 4;
	}
}



trap_13()
{
	level endon("triggerbfbfh");
	trig = getEnt( "trigger13", "targetname" );
	catshit = getEnt( "catshit", "targetname" );

	trig waittill( "triggerbfbfh", who );
	trig delete();

	catshit movez( -232, 2 );
	wait 5;
	catshit movez( 232, 2 );
}


moveme()
{
	moveme = getEnt( "moveme", "targetname" );
}


trap_14()
{
	level endon("triggerazdsdsd");
	trig = getent ("trigger14","targetname");
	dmg = getent ("trap14_dmg","targetname");
	firesound112 =getent("firesound112","targetname");
	help1 = getEnt( "help1", "targetname" );
	help2 = getEnt( "help2", "targetname" );


	dmg maps\mp\_utility::triggerOff();
	
	trig waittill( "triggerazdsdsd", player );
	trig delete();

		
	dmg maps\mp\_utility::triggerOn();	
	
	wait 5;
	
	help1 movez( 256, 1 );
	help2 movez( 256, 1 );
	
					
}


trap_15()
{
	level endon("triggerjhjhjh");
	trig = getent ("trigger15","targetname");
	moveme1 = getEnt( "moveme1", "targetname" );
	
	trig waittill( "triggerjhjhjh", player );
	trig delete();

	moveme1 movez( 384, 2 );
	wait 5;
	moveme1 movez( -384, 2 );

}

trap_16()
{
	level endon("triggerqdsdsdsd");
	trig = getent ("trigger16","targetname");
	upme = getEnt( "upme", "targetname" );
	
	trig waittill( "triggerqdsdsdsd", player );
	trig delete();

	upme movez( 240, 1 );
	wait 2.5;
	upme movez( -240, 1 );

}

trap_17() 
{ 
	level endon("triggerxwxwxwve");
	trapdoor1 = getent( "trapdoor1", "targetname" );
	trapdoor2 = getent( "trapdoor2", "targetname" ); 
	goup = getent( "goup", "targetname" ); 
	trig = getent( "trigger17", "targetname" ); 
	
	trig waittill( "triggerxwxwxwve", player );
	trig delete();

		trapdoor1 rotateto( ( -90, 0, 0 ), 1); 
		trapdoor1 waittill ("rotatedone"); 
		trapdoor2 rotateto( ( -90, 0, 0 ), 1); 
		trapdoor2 waittill ("rotatedone"); 
		
		wait 3; 
		
		trapdoor1 rotateto( ( 0, 0, 0 ), 1.7); 
		trapdoor1 waittill ("rotatedone"); 
		trapdoor2 rotateto( ( 0, 0, 0 ), 1.7); 
		trapdoor2 waittill ("rotatedone"); 
		
		goup movez( 240, 5 );

}


trap_18()
{
	level endon("triggernthg");
	trig = getEnt( "trigger18", "targetname" );
	brush = getent ("delette","targetname");
	
	trig waittill( "triggernthg", who );
	trig delete();
	
	brush delete();
	
}

fuckyou()
{
  rotate_obj = getentarray("rotateme","targetname");
    if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    	rotate_obj[i] delete();
   }
  }

}

trap_19()
{
	level endon("triggerwxwxwxwxvdza");
	trig = getEnt( "trigger19_fixed", "targetname" );
	brush = getEnt( "trap19_fixed", "targetname" );

	trig waittill( "triggerwxwxwxwxvdza", who );
	trig delete();
	
	brush delete();
}

movearound()
{
	movearound =getent("movearound","targetname");
}

trap_20()
{
	level endon("triggerazarthrhrh");
	trig = getent ("trigger20","targetname");
	trap_20 = getEnt( "trap_20", "targetname" );
	
	trig waittill( "triggerazarthrhrh", player );
	trig delete();

	trap_20 movez( 120, 2 );
	trap_20 movey( 850, 2.5 );
	trap_20 movez( -120, 5 );
}



trap_21()
{
	level endon("triggerqdqdqdqdqd");
	trig = getEnt( "trigger21", "targetname" );
	brush = getEnt( "trap21", "targetname" );

	trig waittill( "triggerqdqdqdqdqd", who );
	trig delete();
	
	for( i = 0; i < 2; i++ )
	{
		brush rotateYaw( 512, 3 );
		wait 3;
		brush rotateYaw( -512, 3 );
		wait 3;
	}
}

trap_22()
{
	level endon("triggerzrjkulmiji");
	trig = getEnt( "trigger22", "targetname" );

	trig waittill( "triggerzrjkulmiji", who );
	height = 559;
	for(i=0;i<5;i++)
	{
		trace = BulletTrace( (-799,8253,height), (-799,8008,height), true, undefined );
		if( isPlayer(trace["entity"]))
			trace["entity"] finishPlayerDamage( trace["entity"], trace["entity"], 1000, 0, "MOD_PROJECTILE", "winchester1200_mp", (-799,8253,height), (-799,8253,height), "none", 0);
		height -= 2;
	}
	trig delete();

}

trap_23 ()
{
	level endon("triggerqdcvdg");
	trigger23 = getent ("trigger23","targetname");
	brush_3 = getent ("brush_3","targetname");
	killa = getent ("kill","targetname");
	
	trigger23 waittill ("triggerqdcvdg",who);
	trigger23 delete ();
	
	killa enablelinkto ();
	killa linkto (brush_3);
	
	brush_3 movez( 12, 0.5 );
	wait 4 ;
	brush_3 movez( -12, 0.5 );
	wait 4 ; 
}
//thx to mrx
	
trap_24 ()
{
	level endon("triggervevhh");
	trigger = getent ("trigger24","targetname");
	brush = getent ("olotrolo","targetname");

	
	trigger waittill ("triggervevhh",who);
	trigger delete ();
	
	
	brush movez( 286, 2 );
	wait 4 ;
	brush movez( -286, 2 );

}

trap_26()
{
	level endon("triggeazeaearararr");
	trigger = getent ("trigger26","targetname");
	brush1 =getent("brushyt1","targetname");
	brush2 =getent("brushyt2","targetname");
	brush3 =getent("brushyt3","targetname");
	brush4 =getent("brushyt4","targetname");
	
	trigger waittill ("triggeazeaearararr",who);
	trigger delete ();
	
	while(1)
		{
		brush1 movex( -320, 3 );
		brush1 waittill ("movedone");
		brush2 movex( 320, 3 );
		brush2 waittill ("movedone");
		brush3 movex( -320, 3 );
		brush3 waittill ("movedone");
		brush4 movex( 320, 3 );
		brush4 waittill ("movedone");
		wait(1);
		brush1 movex( 320, 3 );
		brush1 waittill ("movedone");
		brush2 movex( -320, 3 );
		brush2 waittill ("movedone");
		brush3 movex( 320, 3 );
		brush3 waittill ("movedone");
		brush4 movex( -320, 3 );
		brush4 waittill ("movedone");
		}
}

trap_27()
{
	level endon("triggerfzfaaaa");
	trigger = getent ("trigger27","targetname");
	brush1 =getent("brushz1","targetname");
	brush2 =getent("brushz2","targetname");

	trigger waittill ("triggerfzfaaaa",who);
	trigger delete ();
	
	while(1)
		{
		brush1 movex( 490, 3 );
		brush1 waittill ("movedone");
		brush2 movex( -490, 3 );
		brush2 waittill ("movedone");
		wait(1);
		brush1 movex( -490, 3 );
		brush1 waittill ("movedone");
		brush2 movex( 490, 3 );
		brush2 waittill ("movedone");
		}
}

trap_28()
{
	level endon("triggerdqdqdqdqdqdq");
	trig = getEnt("trigger28", "targetname");	
	
	trig waittill("triggerdqdqdqdqdqdq", player);
	trig delete();
	
	player TakeAllWeapons();
	player GiveWeapon( "deserteaglegold_mp" );
	wait 0.01;
	player SwitchToWeapon( "deserteaglegold_mp" );
				

}

trap_29()
{
	trigger = getent ("trigger29","targetname");
	brush =getent("spikestogether","targetname");
	dmg1 =getent("linkeddmg","targetname");

	trigger delete();
	brush delete();
	dmg1 delete();
	
}

trap_30()
{
	level endon("triggervhgrrhr");
	trigger = getent ("trigger30","targetname");
	blocklooping = getent ("blocklooping","targetname");
	dmg = getent ("trigger_dmg_30","targetname");
	dmg maps\mp\_utility::triggerOff();
	
	trigger waittill ("triggervhgrrhr",who);
	trigger delete ();
	
	dmg maps\mp\_utility::triggerOn();	
	wait(3);
	blocklooping movez( -1000, 2 );

}

trap_31()
{
	trigger = getent ("trigger31","targetname");
	brush =getent("removertrap31","targetname");

	trigger delete ();
	brush delete();

}

trap_32()
{
	trigger = getent ("trigger32","targetname");
	dmg = getent ("trigger_dmg_32","targetname");
	trigger delete();	
	dmg delete();
}

trap_33()
{
	trigger = getent ("trigger33","targetname");
	brush = getent ("smasher33","targetname");
	dmg = getent ("trigger_dmg_33","targetname");

	trigger delete();
	
	dmg delete();
	brush delete();

}

trap_34()
{
	level endon("triggerzddzdzz");
	trigger = getent ("trigger34","targetname");
	brush = getent("pushmeup","targetname");
	
	trigger waittill ("triggerzddzdzz",who);
	trigger delete ();

	wait(0.5);
	brush movez( -800, 2 );
}

trap_35()
{
	trigger = getent ("trigger35","targetname");
	brush = getent("spikesrot","targetname");
	dmg = getent ("dmg_rot","targetname");
	trigger delete ();	
	brush delete();
	dmg delete();
	
}

trap_36()
{
	trigger = getent ("trigger36","targetname");
	brush1 = getent("smasha1","targetname");
	brush2 = getent("smasha2","targetname");
	brush3 = getent("smasha3","targetname");
	brush4 = getent("smasha4","targetname");
	brush5 = getent("smasha5","targetname");
	dmg1 = getent ("dmg_smasha1","targetname");
	dmg2 = getent ("dmg_smasha2","targetname");
	dmg3 = getent ("dmg_smasha3","targetname");
	dmg4 = getent ("dmg_smasha4","targetname");
	dmg5 = getent ("dmg_smasha5","targetname");

	trigger delete();

	brush1 delete();
	brush2 delete();
	brush3 delete();
	brush4 delete();
	brush5 delete();
	dmg1 delete();
	dmg2 delete();
	dmg3 delete();
	dmg4 delete();
	dmg5 delete();

}


trap_37()
{
	trigger = getent ("trigger37","targetname");
	brush = getent("rotaspikes","targetname");
	dmg = getent ("dmg_sikes","targetname");
	
	trigger delete ();
	dmg delete ();	
	brush delete ();
}

trap_38()
{
	level endon("triggeradadsfsggg");
	trigger = getent ("trigger38","targetname");
	brush = getent("deletelie","targetname");
	
	trigger waittill ("triggeradadsfsggg",who);
	trigger delete ();

	brush delete();

}

trap_39 ()
{
	level endon("triggerqsqsaghe");
	trigger = getent ("trigger39","targetname");
	brush = getent ("trap_39","targetname");
	killa = getent ("trap_39_dmg","targetname");
	
	killa maps\mp\_utility::triggerOff();
		
	trigger waittill ("triggerqsqsaghe",who);
	trigger delete ();
	
	killa maps\mp\_utility::triggerOn();
	
	killa enablelinkto ();
	killa linkto (brush);
	
	brush movez( 36, 0.5 );
	wait 10 ;
	brush movez( -36, 0.5 );
}

trap_40()
{
	level endon("triggerdqdhhrr");
	trig = getEnt("trigger40", "targetname");	
	
	trig waittill("triggerdqdhhrr", who );
	trig delete();
	
	thread StartFiringLightnings();
}

StartFiringLightnings()
{
	center = (283,8629,354);		
	count = 20;
	
	soundObj = Spawn("script_origin", center );
	wait 0.1;
	while(1)
	{
		if( count > 0 )
		{
			count --;
			x = center+(RandomIntRange(-125,125),RandomIntRange(-125,125),0);
			trace = BulletTrace( x, x-(0,0,1000), false, undefined );
			soundObj.origin = trace["position"];
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "allies" && isAlive( players[i] ) && Distance( trace["position"], players[i].origin ) <= 100 )
					players[i] suicide();
			}
		}
		else
			break;
		wait 0.25+RandomFloat(0.25);
	}
	if( isDefined( soundObj ) )
		soundObj delete();
}

//Written by Rycoon :]

trap_41 ()
{
	trigger = getent ("trigger41","targetname");
	brush = getent ("trap41","targetname");
	brushsound = getent ("trap41_sound","targetname");
	killaa = getent ("trap41_dmg","targetname");

	trigger delete ();

	
	killaa delete();
	brushsound delete();
	brush delete();

}

trap_42()
{
	trig = getent ("trigger42","targetname");
	brush = getEnt( "trap42", "targetname" );
	dmg1 = getent ("trap42_dmg_1","targetname");
	dmg2 = getent ("trap42_dmg_2","targetname");
	dmg3 = getent ("trap42_dmg_3","targetname");
	dmg4 = getent ("trap42_dmg_4","targetname");
	
	dmg1 delete();
	dmg2 delete();
	dmg3 delete();
	dmg4 delete();
	brush delete();
	trig delete();
	


}
