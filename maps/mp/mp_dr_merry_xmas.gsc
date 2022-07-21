 ///////////////////////////////////////////////////////////////////////////////
 // __  __                               _    _____           _       _       //
 //|  \/  |                             | |  / ____|         (_)     | |      //
 //| \  / | __ _ _ __     __ _ _ __   __| | | (___   ___ _ __ _ _ __ | |_ ___ //
 //| |\/| |/ _` | '_ \   / _` | '_ \ / _` |  \___ \ / __| '__| | '_ \| __/ __|//
 //| |  | | (_| | |_) | | (_| | | | | (_| |  ____) | (__| |  | | |_) | |_\__ \//
 //|_|  |_|\__,_| .__/   \__,_|_| |_|\__,_| |_____/ \___|_|  |_| .__/ \__|___///
 //             | |                                            | |            //
 //             |_|                                            |_|            //
 //                                                                           //
 // _             _______ _          _      _       __                        //
 //| |           |__   __| |        | |    (_)     / _|                       //
 //| |__  _   _     | |  | |__   ___| |     ___  _| |_ ___                    //
 //| '_ \| | | |    | |  | '_ \ / _ \ |    | \ \/ /  _/ _ \                   //
 //| |_) | |_| |    | |  | | | |  __/ |____| |>  <| ||  __/                   //
 //|_.__/ \__, |    |_|  |_| |_|\___|______|_/_/\_\_| \___|                   //
 //        __/ |                                                              //
 //       |___/                                                               //
 ///////////////////////////////////////////////////////////////////////////////

main()
{
	maps\mp\_load::main(); 


	level.snowplode=loadfx("explosions/snowtreefall");
	level.cavec4=loadfx("explosions/cavec4");



	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//setdvar( "r_specularcolorscale", "1" );

	//setdvar("r_glowbloomintensity0",".25");
	//setdvar("r_glowbloomintensity1",".25");
	//setdvar("r_glowskybleedintensity0",".3");
	//setdvar("compassmaxrange","1800");

	addTriggerToList("trig_treetrap");
	addTriggerToList("treetrap2_trig");
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");


    thread sr\api\_speedrun::createNormalWays("Normal Way;");
		thread start_door();
	// thread old_room();
	// thread northpole();
	// thread santa();
	// thread treetrap();
	// thread trap1();
	//thread icicle1();
	// thread icicle2();
	// thread icicle3();
	// thread icicle4();
	// thread icicle5();
	// thread icicle6();
	// thread icicle7();
	// thread icicle8();
	// thread icicle9();
	//thread icicle10();
	// thread icicle11();
	// thread icicle12();
	// thread icicle13();
	// thread icicle14();
	// thread icicle15();
	// thread icicle16();
	// thread icicle17();
	// thread icicle18();
	// thread icicle19();
	// thread trap3();
	// thread trap2();
	// thread trap4();
	// thread treetrap2();
	// thread wtf();
	// thread lastxmas();
	// thread creators();
	// thread lamp();
}


	addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


	start_door()
{
	object = getEnt ("start_door1","targetname");
	object2 = getEnt ("start_door2","targetname");
    object rotateyaw (100,4);
	object2 rotateyaw (-100,4);
}


	old_room()
{
	trigger = getEnt ("old_door","targetname");
	door = getEnt ("door_trig","targetname");
	trigger waittill ("trigger", player);
	door delete();
	/* [AUTO DELETE] iPrintlnBold( " ^7" + player.name + " can now break the final door!" ); */
	thread present_1();
	thread present_2();
	thread present_3();
	thread present_4();
	thread present_5();
	thread present_6();
	thread present_7();
	thread present_8();
	thread present_9();
	thread present_10();
	thread present_11();
	thread present_12();
	thread present_13();
	thread present_14();
	thread present_15();
	thread present_16();
	thread present_17();
	thread present_18();
	thread present_19();
	thread present_20();
	thread present_21();
	thread present_22();
	thread present_23();
	thread present_24();
}


	present_1()
{
	trig = getEnt ("present_1trig","targetname");
	gift = getEnt ("present_1","targetname");
	clip = getEnt ("present_1clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_2()
{
	trig = getEnt ("present_2trig","targetname");
	gift = getEnt ("present_2","targetname");
	clip = getEnt ("present_2clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_3()
{
	trig = getEnt ("present_3trig","targetname");
	gift = getEnt ("present_3","targetname");
	clip = getEnt ("present_3clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_4()
{
	trig = getEnt ("present_4trig","targetname");
	gift = getEnt ("present_4","targetname");
	clip = getEnt ("present_4clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_5()
{
	trig = getEnt ("present_5trig","targetname");
	gift = getEnt ("present_5","targetname");
	clip = getEnt ("present_5clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_6()
{
	trig = getEnt ("present_6trig","targetname");
	gift = getEnt ("present_6","targetname");
	clip = getEnt ("present_6clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_7()
{
	trig = getEnt ("present_7trig","targetname");
	gift = getEnt ("present_7","targetname");
	clip = getEnt ("present_7clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_8()
{
	trig = getEnt ("present_8trig","targetname");
	gift = getEnt ("present_8","targetname");
	clip = getEnt ("present_8clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_9()
{
	trig = getEnt ("present_9trig","targetname");
	gift = getEnt ("present_9","targetname");
	clip = getEnt ("present_9clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_10()
{
	trig = getEnt ("present_10trig","targetname");
	gift = getEnt ("present_10","targetname");
	clip = getEnt ("present_10clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_11()
{
	trig = getEnt ("present_11trig","targetname");
	gift = getEnt ("present_11","targetname");
	clip = getEnt ("present_11clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_12()
{
	trig = getEnt ("present_12trig","targetname");
	gift = getEnt ("present_12","targetname");
	clip = getEnt ("present_12clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_13()
{
	trig = getEnt ("present_13trig","targetname");
	gift = getEnt ("present_13","targetname");
	clip = getEnt ("present_13clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_14()
{
	trig = getEnt ("present_14trig","targetname");
	gift = getEnt ("present_14","targetname");
	clip = getEnt ("present_14clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_15()
{
	trig = getEnt ("present_15trig","targetname");
	gift = getEnt ("present_15","targetname");
	clip = getEnt ("present_15clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_16()
{
	trig = getEnt ("present_16trig","targetname");
	gift = getEnt ("present_16","targetname");
	clip = getEnt ("present_16clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_17()
{
	trig = getEnt ("present_17trig","targetname");
	gift = getEnt ("present_17","targetname");
	clip = getEnt ("present_17clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_18()
{
	trig = getEnt ("present_18trig","targetname");
	gift = getEnt ("present_18","targetname");
	clip = getEnt ("present_18clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_19()
{
	trig = getEnt ("present_19trig","targetname");
	gift = getEnt ("present_19","targetname");
	clip = getEnt ("present_19clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_20()
{
	trig = getEnt ("present_20trig","targetname");
	gift = getEnt ("present_20","targetname");
	clip = getEnt ("present_20clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	present_21()
{
	trig = getEnt ("present_21trig","targetname");
	gift = getEnt ("present_21","targetname");
	clip = getEnt ("present_21clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


		present_22()
{
	trig = getEnt ("present_22trig","targetname");
	gift = getEnt ("present_22","targetname");
	clip = getEnt ("present_22clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


		present_23()
{
	trig = getEnt ("present_23trig","targetname");
	gift = getEnt ("present_23","targetname");
	clip = getEnt ("present_23clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


		present_24()
{
	trig = getEnt ("present_24trig","targetname");
	gift = getEnt ("present_24","targetname");
	clip = getEnt ("present_24clip","targetname");
	trig waittill ("trigger", player);
	gift delete();
	clip delete();
}


	northpole()
{
	trig = getEnt ("northpole","targetname");
	go = getEnt ("northpole_go","targetname");
	out = getEnt ("northpole_out","targetname");
	santa = getEnt ("santa_sound","targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 123); */         
	player SetOrigin(go.origin);
        player SetPlayerAngles( go.angles );
	/* [AUTO DELETE] player iPrintlnBold(" ^5MERRY CHRISTMAS! "); */
	/* [AUTO DELETE] wait 8; */        
	player SetOrigin(out.origin);
        player SetPlayerAngles( out.angles );
	}
}


	santa()
{
	trigger = getEnt ("northpole","targetname");
	santa = getEnt ("santa_sound","targetname");
	while(1)
	{
		trigger waittill ("trigger", player);
		wait 0.1;
		santa playSound("hohoho");
	}
}


	treetrap()
{
	level endon("trigger");
	trig = getEnt ("trig_treetrap","targetname");
	kill = getEnt ("tree_killtrig","targetname");
	tree = getEnt ("treetrap_tree","targetname");
	carrot = getEnt ("tree_carrot","targetname");
	tree_fx = getEnt ("tree_fx","targetname");
	tree2_fx = getEnt ("tree2_fx","targetname");
	tree_sound = getEnt ("tree_sound","targetname");
	clip = getEnt ("treetrap","targetname");
	
	trig waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trig SetHintString("^5Activated");
	carrot delete();
	kill enablelinkto ();
	kill linkto (clip);
	tree enablelinkto ();
	tree linkto (clip);
	tree_sound playSound("tree");
	wait 0.2;
	clip rotateroll(90,4,2);
	clip waittill ("rotatedone");
	playfx(level.snowplode,tree_fx.origin);
	wait 0.1;
	playfx(level.snowplode,tree2_fx.origin);
	kill delete();
}


	trap1()
{
	level endon("trigger");
	trigger = getEnt ("trap1_trig","targetname");
	cloud = getEnt ("trap1","targetname");
	carrot = getEnt ("trap1_carrot","targetname");
	trap1_fx = getEnt ("trap1_fx","targetname");
	cloud hide();
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^5Activated");
	playfx(level.snowplode,trap1_fx.origin);
	carrot delete();
	trap1_fx playSound("poof");
	cloud show();
}


	icicle1()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle1","targetname");
	kill = getEnt ("icicle1_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 10;
	}
}


	icicle2()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle2","targetname");
	kill = getEnt ("icicle2_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 9;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
	}
}


	icicle3()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle3","targetname");
	kill = getEnt ("icicle3_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 3;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 5;
	}
}


	icicle4()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle4","targetname");
	kill = getEnt ("icicle4_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 1;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 9;
	}
}


	icicle5()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle5","targetname");
	kill = getEnt ("icicle5_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 5;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 5;
	}
}


	icicle6()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle6","targetname");
	kill = getEnt ("icicle6_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 2;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 8;
	}
}


	icicle7()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle7","targetname");
	kill = getEnt ("icicle7_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 4;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 4;
	}
}


	icicle8()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle8","targetname");
	kill = getEnt ("icicle8_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 4;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 6;
	}
}


	icicle9()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle9","targetname");
	kill = getEnt ("icicle9_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 2;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 5;
	}
}


	icicle10()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle10","targetname");
	kill = getEnt ("icicle10_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 6;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 3;
	}
}


	icicle11()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle11","targetname");
	kill = getEnt ("icicle11_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 3;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 7;
	}
}


	icicle12()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle12","targetname");
	kill = getEnt ("icicle12_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 8;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
	}
}


	icicle13()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle13","targetname");
	kill = getEnt ("icicle13_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 4;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 3;
	}
}


	icicle14()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle14","targetname");
	kill = getEnt ("icicle14_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 7;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
	}
}


	icicle15()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle15","targetname");
	kill = getEnt ("icicle15_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 5;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 3;
	}
}


	icicle16()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle16","targetname");
	kill = getEnt ("icicle16_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 8;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 2;
	}
}


	icicle17()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle17","targetname");
	kill = getEnt ("icicle17_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 2;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 5;
	}
}


	icicle18()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle18","targetname");
	kill = getEnt ("icicle18_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 1;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 6;
	}
}


	icicle19()
{
	trigger = getEnt ("trap1_trig","targetname");
	icicle = getEnt ("icicle19","targetname");
	kill = getEnt ("icicle19_kill","targetname");
	icicle hide();
	trigger waittill ("trigger", player);
	icicle show();
	kill enablelinkto ();
	kill linkto (icicle);
	while(1)
	{
		wait 7;
		icicle movez (-321, 1, 1);
		icicle waittill ("movedone");
		wait 3;
		icicle hide();
		icicle notsolid();
		icicle movez (321, 0.01);
		icicle waittill ("movedone");
		icicle show();
		icicle solid();
		wait 1;
	}
}


	trap3()
{
	level endon("trigger");
	trigger = getEnt ("trap3_trig","targetname");
	snow = getEnt ("trap_3","targetname");
	cave1 = getEnt ("cavefall1","targetname");
	cave2 = getEnt ("cavefall2","targetname");
	cave3 = getEnt ("cavefall3","targetname");
	carrot = getEnt ("trap3_carrot","targetname");
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^5Activated");
	snow movez(-225,3.3);
	cave1 playSound("cavefall");
	cave3 playSound("cavefall");
	playfx(level.snowplode,cave1.origin);
	playfx(level.snowplode,cave2.origin);
	playfx(level.snowplode,cave3.origin);
	carrot delete();
}


	trap2()
{
	level endon("trigger");
	trigger = getEnt ("trap2_trig","targetname");
	box1_1 = getEnt ("box1_1","targetname");
	box1_2 = getEnt ("box1_2","targetname");
	box2_1 = getEnt ("box2_1","targetname");
	box2_2 = getEnt ("box2_2","targetname");
	box3_1 = getEnt ("box3_1","targetname");
	box3_2 = getEnt ("box3_2","targetname");
	box4_1 = getEnt ("box4_1","targetname");
	box4_2 = getEnt ("box4_2","targetname");
	box5_1 = getEnt ("box5_1","targetname");
	box5_2 = getEnt ("box5_2","targetname");
	box6_1 = getEnt ("box6_1","targetname");
	box6_2 = getEnt ("box6_2","targetname");
	box7_1 = getEnt ("box7_1","targetname");
	box7_2 = getEnt ("box7_2","targetname");
	box8_1 = getEnt ("box8_1","targetname");
	box8_2 = getEnt ("box8_2","targetname");
	box9_1 = getEnt ("box9_1","targetname");
	box9_2 = getEnt ("box9_2","targetname");
	box10_1 = getEnt ("box10_1","targetname");
	box10_2 = getEnt ("box10_2","targetname");
	box11_1 = getEnt ("box11_1","targetname");
	box11_2 = getEnt ("box11_2","targetname");
	box12_1 = getEnt ("box12_1","targetname");
	box12_2 = getEnt ("box12_2","targetname");
	clip1 = getEnt ("box1_clip","targetname");
	clip2 = getEnt ("box2_clip","targetname");
	clip3 = getEnt ("box3_clip","targetname");
	clip4 = getEnt ("box4_clip","targetname");
	clip5 = getEnt ("box5_clip","targetname");
	clip6 = getEnt ("box6_clip","targetname");
	clip7 = getEnt ("box7_clip","targetname");
	clip8 = getEnt ("box8_clip","targetname");
	clip9 = getEnt ("box9_clip","targetname");
	clip10 = getEnt ("box10_clip","targetname");
	clip11 = getEnt ("box11_clip","targetname");
	clip12 = getEnt ("box12_clip","targetname");
	fx1_1 = getEnt ("box1fx_1","targetname");
	fx1_2 = getEnt ("box1fx_2","targetname");
	fx2_1 = getEnt ("box2fx_1","targetname");
	fx2_2 = getEnt ("box2fx_2","targetname");
	fx3_1 = getEnt ("box3fx_1","targetname");
	fx3_2 = getEnt ("box3fx_2","targetname");
	fx4_1 = getEnt ("box4fx_1","targetname");
	fx4_2 = getEnt ("box4fx_2","targetname");
	fx5_1 = getEnt ("box5fx_1","targetname");
	fx5_2 = getEnt ("box5fx_2","targetname");
	fx6_1 = getEnt ("box6fx_1","targetname");
	fx6_2 = getEnt ("box6fx_2","targetname");
	fx7_1 = getEnt ("box7fx_1","targetname");
	fx7_2 = getEnt ("box7fx_2","targetname");
	fx8_1 = getEnt ("box8fx_1","targetname");
	fx8_2 = getEnt ("box8fx_2","targetname");
	fx9_1 = getEnt ("box9fx_1","targetname");
	fx9_2 = getEnt ("box9fx_2","targetname");
	fx10_1 = getEnt ("box10fx_1","targetname");
	fx10_2 = getEnt ("box10fx_2","targetname");
	fx11_1 = getEnt ("box11fx_1","targetname");
	fx11_2 = getEnt ("box11fx_2","targetname");
	fx12_1 = getEnt ("box12fx_1","targetname");
	fx12_2 = getEnt ("box12fx_2","targetname");
	carrot = getEnt ("trap2_carrot","targetname");
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^5Activated");
	carrot delete();

	i = randomintrange( 0, 9 );
	if(i == 0)
	{
		box2_1 delete();
		box2_2 delete();
		clip2 delete();
		playfx(level.snowplode,fx2_1.origin);
		playfx(level.snowplode,fx2_2.origin);
		fx2_1 playSound("boxplode");

		box3_1 delete();
		box3_2 delete();
		clip3 delete();
		playfx(level.snowplode,fx3_1.origin);
		playfx(level.snowplode,fx3_2.origin);
		fx3_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box7_1 delete();
		box7_2 delete();
		clip7 delete();
		playfx(level.snowplode,fx7_1.origin);
		playfx(level.snowplode,fx7_2.origin);
		fx7_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box10_1 delete();
		box10_2 delete();
		clip10 delete();
		playfx(level.snowplode,fx10_1.origin);
		playfx(level.snowplode,fx10_2.origin);
		fx10_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");
	}
	else if(i == 1)
	{
		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box3_1 delete();
		box3_2 delete();
		clip3 delete();
		playfx(level.snowplode,fx3_1.origin);
		playfx(level.snowplode,fx3_2.origin);
		fx3_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box6_1 delete();
		box6_2 delete();
		clip6 delete();
		playfx(level.snowplode,fx6_1.origin);
		playfx(level.snowplode,fx6_2.origin);
		fx6_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box10_1 delete();
		box10_2 delete();
		clip10 delete();
		playfx(level.snowplode,fx10_1.origin);
		playfx(level.snowplode,fx10_2.origin);
		fx10_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");
	}
	else if(i == 2)
	{
		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box3_1 delete();
		box3_2 delete();
		clip3 delete();
		playfx(level.snowplode,fx3_1.origin);
		playfx(level.snowplode,fx3_2.origin);
		fx3_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box6_1 delete();
		box6_2 delete();
		clip6 delete();
		playfx(level.snowplode,fx6_1.origin);
		playfx(level.snowplode,fx6_2.origin);
		fx6_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box10_1 delete();
		box10_2 delete();
		clip10 delete();
		playfx(level.snowplode,fx10_1.origin);
		playfx(level.snowplode,fx10_2.origin);
		fx10_1 playSound("boxplode");

		box2_1 delete();
		box2_2 delete();
		clip2 delete();
		playfx(level.snowplode,fx2_1.origin);
		playfx(level.snowplode,fx2_2.origin);
		fx2_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");	
	}
	else if(i == 3)
	{
		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box2_1 delete();
		box2_2 delete();
		clip2 delete();
		playfx(level.snowplode,fx2_1.origin);
		playfx(level.snowplode,fx2_2.origin);
		fx2_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box6_1 delete();
		box6_2 delete();
		clip6 delete();
		playfx(level.snowplode,fx6_1.origin);
		playfx(level.snowplode,fx6_2.origin);
		fx6_1 playSound("boxplode");

		box7_1 delete();
		box7_2 delete();
		clip7 delete();
		playfx(level.snowplode,fx7_1.origin);
		playfx(level.snowplode,fx7_2.origin);
		fx7_1 playSound("boxplode");

		box10_1 delete();
		box10_2 delete();
		clip10 delete();
		playfx(level.snowplode,fx10_1.origin);
		playfx(level.snowplode,fx10_2.origin);
		fx10_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");	
	}
	else if(i == 4)
	{
		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box3_1 delete();
		box3_2 delete();
		clip3 delete();
		playfx(level.snowplode,fx3_1.origin);
		playfx(level.snowplode,fx3_2.origin);
		fx3_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box6_1 delete();
		box6_2 delete();
		clip6 delete();
		playfx(level.snowplode,fx6_1.origin);
		playfx(level.snowplode,fx6_2.origin);
		fx6_1 playSound("boxplode");

		box7_1 delete();
		box7_2 delete();
		clip7 delete();
		playfx(level.snowplode,fx7_1.origin);
		playfx(level.snowplode,fx7_2.origin);
		fx7_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");	
	}
	else if(i == 5)
	{
		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box2_1 delete();
		box2_2 delete();
		clip2 delete();
		playfx(level.snowplode,fx2_1.origin);
		playfx(level.snowplode,fx2_2.origin);
		fx2_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box7_1 delete();
		box7_2 delete();
		clip7 delete();
		playfx(level.snowplode,fx7_1.origin);
		playfx(level.snowplode,fx7_2.origin);
		fx7_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box10_1 delete();
		box10_2 delete();
		clip10 delete();
		playfx(level.snowplode,fx10_1.origin);
		playfx(level.snowplode,fx10_2.origin);
		fx10_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");
	}
	else if(i == 6)
	{
		box3_1 delete();
		box3_2 delete();
		clip3 delete();
		playfx(level.snowplode,fx3_1.origin);
		playfx(level.snowplode,fx3_2.origin);
		fx3_1 playSound("boxplode");

		box2_1 delete();
		box2_2 delete();
		clip2 delete();
		playfx(level.snowplode,fx2_1.origin);
		playfx(level.snowplode,fx2_2.origin);
		fx2_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box7_1 delete();
		box7_2 delete();
		clip7 delete();
		playfx(level.snowplode,fx7_1.origin);
		playfx(level.snowplode,fx7_2.origin);
		fx7_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");
	}
	else if(i == 7)
	{
		box3_1 delete();
		box3_2 delete();
		clip3 delete();
		playfx(level.snowplode,fx3_1.origin);
		playfx(level.snowplode,fx3_2.origin);
		fx3_1 playSound("boxplode");

		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box6_1 delete();
		box6_2 delete();
		clip6 delete();
		playfx(level.snowplode,fx6_1.origin);
		playfx(level.snowplode,fx6_2.origin);
		fx6_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box11_1 delete();
		box11_2 delete();
		clip11 delete();
		playfx(level.snowplode,fx11_1.origin);
		playfx(level.snowplode,fx11_2.origin);
		fx11_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");
	}
	else if(i == 8)
	{
		box2_1 delete();
		box2_2 delete();
		clip2 delete();
		playfx(level.snowplode,fx2_1.origin);
		playfx(level.snowplode,fx2_2.origin);
		fx2_1 playSound("boxplode");

		box1_1 delete();
		box1_2 delete();
		clip1 delete();
		playfx(level.snowplode,fx1_1.origin);
		playfx(level.snowplode,fx1_2.origin);
		fx1_1 playSound("boxplode");

		box4_1 delete();
		box4_2 delete();
		clip4 delete();
		playfx(level.snowplode,fx4_1.origin);
		playfx(level.snowplode,fx4_2.origin);
		fx4_1 playSound("boxplode");

		box7_1 delete();
		box7_2 delete();
		clip7 delete();
		playfx(level.snowplode,fx7_1.origin);
		playfx(level.snowplode,fx7_2.origin);
		fx7_1 playSound("boxplode");

		box9_1 delete();
		box9_2 delete();
		clip9 delete();
		playfx(level.snowplode,fx9_1.origin);
		playfx(level.snowplode,fx9_2.origin);
		fx9_1 playSound("boxplode");

		box8_1 delete();
		box8_2 delete();
		clip8 delete();
		playfx(level.snowplode,fx8_1.origin);
		playfx(level.snowplode,fx8_2.origin);
		fx8_1 playSound("boxplode");

		box5_1 delete();
		box5_2 delete();
		clip5 delete();
		playfx(level.snowplode,fx5_1.origin);
		playfx(level.snowplode,fx5_2.origin);
		fx5_1 playSound("boxplode");

		box10_1 delete();
		box10_2 delete();
		clip10 delete();
		playfx(level.snowplode,fx10_1.origin);
		playfx(level.snowplode,fx10_2.origin);
		fx10_1 playSound("boxplode");

		box12_1 delete();
		box12_2 delete();
		clip12 delete();
		playfx(level.snowplode,fx12_1.origin);
		playfx(level.snowplode,fx12_2.origin);
		fx12_1 playSound("boxplode");
	}
}


	trap4()
{
	level endon("trigger");
	trigger = getEnt ("trap4_trig","targetname");
	object = getEnt ("trap4_delete","targetname");
	carrot = getEnt ("trap4_carrot","targetname");
	c4 = getEnt ("trap4_c4","targetname");
	efx = getEnt ("trap4_efx","targetname");
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^5Activated");
	efx playSound ("boxplode");
	playfx(level.cavec4,efx.origin);
	object delete();
	c4 delete();
	carrot delete();
}


	treetrap2()
{
	level endon("trigger");
	trig = getEnt ("treetrap2_trig","targetname");
	kill = getEnt ("tree2_killtrig","targetname");
	tree = getEnt ("treetrap2_tree","targetname");
	carrot = getEnt ("tree2_carrot","targetname");
	tree_fx = getEnt ("tree2_fx1","targetname");
	tree2_fx = getEnt ("tree2_fx2","targetname");
	tree_sound = getEnt ("tree2_sound","targetname");
	clip = getEnt ("treetrap2","targetname");
	
	trig waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trig SetHintString("^5Activated");
	carrot delete();
	kill enablelinkto ();
	kill linkto (clip);
	tree enablelinkto ();
	tree linkto (clip);
	tree_sound playSound("tree");
	wait 0.2;
	clip rotateroll(-90,4,2);
	clip waittill ("rotatedone");
	playfx(level.snowplode,tree_fx.origin);
	wait 0.1;
	playfx(level.snowplode,tree2_fx.origin);
	kill delete();
}


	wtf()
{
	trigger = getEnt ("wtf","targetname");
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player GiveWeapon( "ak74u_mp" ); */
	/* [AUTO DELETE] player givemaxammo( "ak74u_mp" ); */
	/* [AUTO DELETE] player switchtoweapon ( "ak74u_mp" ); */
}


	creators()
{
	wait 9;
	/* [AUTO DELETE] iPrintlnBold("^7Map by ^5TheLixfe"); */
	wait 2;
	/* [AUTO DELETE] iprintln("^7Thanks to ^5Vistic Clan"); */
	wait 2;
	/* [AUTO DELETE] iprintln("^7Special thanks to ^5Sheep Wizard ^7for helping me with sounds and fx"); */
	wait 5;
	/* [AUTO DELETE] iprintln("^1MERRY CHRISTMAS ^5TO EVERYONE IN THE DEATHRUN COMMUNITY!"); */
	wait 15;
	/* [AUTO DELETE] iprintln("^7Map by ^5TheLixfe"); */
}


	lastxmas()
{
	trigger = getEnt ("lastxmas","targetname");
	part = getEnt ("lastxmaspart","targetname");
	trigger waittill ("trigger", player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 5); */
	ambientStop("0");
	wait 0.05 ;
	/* [AUTO DELETE] ambientPlay("wham"); */
	/* [AUTO DELETE] iprintln("^5Song: ^7Last Christmas - Wham"); */
	part movez (16,0.01);
}


	lamp()
{
	trigger = getEnt ("lamp_trig","targetname");
	part = getEnt ("lamp_part","targetname");
	trigger waittill ("trigger", player);
	part delete();
	/* [AUTO DELETE] iPrintlnBold( "^7What are you doing Mr.^5" + player.name + "? " ); */
}
