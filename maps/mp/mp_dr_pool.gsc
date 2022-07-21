 main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (-876.881, 678.355, 184.125), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
  thread way_connect();
  thread start_door();
  thread move1();
  thread move2();
  thread move3();
  thread move4();
  thread move5();
  thread move6();
  // thread rotate1();
  // thread trap1();
  // thread trap2();
  // thread trap3();
  // thread trap4();
  // thread trap5();
  // thread trap6();
  // thread trap7();
  // thread trap8();
  // thread trap9();
  // thread trap10();
  // thread final_door();
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

start_door()
{
   trig = getEnt ("start_door_aktiv" , "targetname");
   brush = getEnt ("start_door" ,"targetname" );  
   trig delete ();  
   brush delete();
}
  
move1()
{
	brush = getEnt( "move1", "targetname" );

	while(1)
	{
		brush moveY( -512, 3 );
		wait 2;
		brush moveX( 300, 3 );
		wait 2;
		brush moveY(  512, 3 );
		wait 2;
		brush moveX( -300, 3);
		wait 2;
	}
	
}

move2()
{
	brush = getEnt( "move2", "targetname" );

	while(1)
	{
		brush moveY( 512, 3 );
		wait 2;
		brush moveX( -300, 3 );
		wait 2;
		brush moveY( -512, 3 );
		wait 2;
		brush moveX( 300, 3);
		wait 2;
	}
	
}

move3()
{
	brush = getEnt( "move3", "targetname" );

	while(1)
	{
		brush moveX( 400, 3 );
		wait 2;
		brush moveX( -400, 3 );
		wait 2;
	}
	
}

move4()
{
	brush = getEnt( "move4", "targetname" );

	while(1)
	{
		brush moveY( 650, 7 );
		wait 3;
		brush moveY( -650, 7 );
		wait 3;
	}
	
}

move5()
{
	brush = getEnt( "move5", "targetname" );

	while(1)
	{
		brush moveX( -300, 3 );
		wait 2;
		brush moveY( -512, 3 );
		wait 2;
		brush moveX( 300, 3 );
		wait 2;
		brush moveY( 512, 3);
		wait 2;
	}
	
}

move6()
{
	brush = getEnt( "move6", "targetname" );

	while(1)
	{
		brush moveX( 300, 3 );
		wait 2;
		brush moveY( 512, 3 );
		wait 2;
		brush moveX( -300, 3 );
		wait 2;
		brush moveY( -512, 3);
		wait 2;
	}
	
}

rotate1()
{
   trig = getEnt ("rotate1_aktiv" , "targetname");
   brush = getEnt ("rotate1" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
  
   for( i = 0; i < 10; i++ )
	{
		brush rotateYaw( 360, 1 );
		wait 1;
	}
}

trap1()
{
   trig = getEnt ("trap1_aktiv" , "targetname");
   brush = getEnt ("trap1" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
  
   for( i = 0; i < 7; i++ )
	{
		brush rotateYaw( 360, 1 );
		wait 1;
	}
}

trap2 ()
{
   trig = getEnt ("trap2_aktiv" , "targetname");
   brush = getEnt ("trap2" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
   
   brush moveY ( 500 , 4);
   wait 5;
   brush moveY ( -500, 4 );
}

trap3 ()
{
   trig = getEnt ("trap3_aktiv" , "targetname");
   brush1 = getEnt ("trap3_1" ,"targetname" );
   hurt1 = getEnt ("hurt1_1" , "targetname");
   hurt2 = getEnt ("hurt1_2" , "targetname");
   brush2 = getEnt ("trap3_2" ,"targetname" );
   hurt3 = getEnt ("hurt2_1" , "targetname");
   hurt4 = getEnt ("hurt2_2" , "targetname");
   brush3 = getEnt ("trap3_3" ,"targetname" );
   hurt5 = getEnt ("hurt3_1" , "targetname");
   hurt6 = getEnt ("hurt3_2" , "targetname");
   trig waittill ("trigger",player);  
   trig delete ();  
   
   hurt1 enablelinkto();
   hurt1 linkto (brush1);
   hurt2 enablelinkto();
   hurt2 linkto (brush1);
   hurt3 enablelinkto();
   hurt3 linkto (brush2);
   hurt4 enablelinkto();
   hurt4 linkto (brush2);
   hurt5 enablelinkto();
   hurt5 linkto (brush3);
   hurt6 enablelinkto();
   hurt6 linkto (brush3);
   
   for( i = 0; i < 999; i++ )
	{
		brush1 rotateRoll( 360, 3 );
		brush2 rotateRoll( 360, 3 );
		brush3 rotateRoll( 360, 3 );
		wait 1;
	}
   
   
}

trap4 ()
{
   trig = getEnt ("trap4_aktiv" , "targetname");
   brush = getEnt ("trap4" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
   
   brush notSolid();
}

trap5 ()
{
   trig = getEnt ("trap5_aktiv" , "targetname");
   brush = getEnt ("trap5" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
   
   brush moveZ ( -200 , 1);
   wait 5;
   brush moveZ ( 200 , 2 );
   
}

trap6()
{
	trig = getEnt( "trap6_aktiv", "targetname" );
	brush = getEnt( "trap6", "targetname" );

	trig waittill( "trigger", player );
	trig delete();

	while( isDefined( brush ) )
	{
		brush rotateRoll( 180, 8 );
		wait 4;
	}
}

trap7()
{
   trig = getEnt ("trap7_aktiv" , "targetname");
   brush = getEnt ("trap7", "targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
   
   for( i = 0; i < 10; i++ )
	{
		brush rotateRoll( 360, 3 );
		wait 1;
	}
   
}

trap8()
{
   trig = getEnt ("trap8_aktiv" , "targetname");
   brushGroup1 = getEntArray ("trap8_1" ,"targetname" );
   brushGroup2 = getEntArray ("trap8_2" ,"targetname" );
   
   trig waittill ("trigger",player);  
   trig delete ();  
  
   brushGroup1[randomInt(brushGroup1.size)] delete();
	 brushGroup2[randomInt(brushGroup2.size)] delete();
}

trap9()
{
	trig = getEnt( "trap9_aktiv", "targetname" );
	brushGroup1 = getEntArray( "trap9_1", "targetname" );
	brushGroup2 = getEntArray( "trap9_2", "targetname" );

	trig waittill( "trigger", player );
	trig delete();
	
	brushGroup1[randomInt(brushGroup1.size)] notSolid();
	brushGroup2[randomInt(brushGroup2.size)] notSolid();
}

trap10 ()
{
   trig = getEnt ("trap10_aktiv" , "targetname");
   brush = getEnt ("trap10" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();  
   
   brush moveZ ( 600 , 1);
   wait 5;
   brush moveZ ( -600, 4 );
}

final_door()
{
   trig = getEnt ("final_door_open" , "targetname");
   brush = getEnt ("final_door" ,"targetname" );
   trig waittill ("trigger",player);  
   trig delete ();
}