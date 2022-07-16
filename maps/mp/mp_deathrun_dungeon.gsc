main()
{
	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

    thread speedrun\_way_name::create_spawn((95,353,68),270);
	thread speedrun\_way_name::create_normal_way("Normal Way;");

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	 thread trap1();
	 thread trap2();
	 thread trap3();
	 thread pushers();
	 thread trap4() ;
	 thread trap5();
	 thread trap6();
	 thread trap7();
	 thread trap8();
	 thread trap9();
	 thread door();
	 thread anticut_main();
}

anticut_main() 
{
    trig1 = spawn( "trigger_radius", (1897.66, -2191.54, -183.875), 0, 100, 130 );
    trig1 thread anticut();

}
anticut()
{
   while(1)
    {
    	self waittill("trigger", player);
		player suicide();
        wait 0.5;
    }
   
}
door()
{
	door_1 = getent ("door1","targetname");
	door_2 = getent ("door2","targetname");
	trig_door = getent ("dooropen" , "targetname");
	trig_door waittill ("trigger",player);
	trig_door delete ();
	door_1 delete ();
	door_2 delete ();
}
 trap1 () 
	      {
			  level endon("triggeraadad");
		  trig1 = getent ( "trig_1" , "targetname" ) ;
		  half_1= getentarray ( "half_1","targetname" ) ;
		  half_2 = getentarray ( "half_2" , "targetname");
		  trig1 waittill ("triggeraadad", player );
		  trig1 delete ();
		  half_1[randomInt(half_1.size)] delete();
          half_2[randomInt(half_2.size)] delete();

		  }
trap2 ()
      {
		  level endon("triggeraafzfzfzd");
	  trig2 = getent ("trig_2", "targetname");
	  brush_2 = getent ("brush2","targetname");
	  trig2 waittill ("triggeraafzfzfzd",player);
	  trig2 delete ();
	  while (1)
	  {
	  brush_2 rotatepitch (-360 , 4 );
	  wait 0.5 ;
	  }
      }	  
	  
trap3 ()
{
	 		trig3 = getent ("trig_3", "targetname");
	  		killtrigger = getent ("killtrig" , "targetname");
	  		brush_3 = getent ("brush3" , "targetname");
	  		earthy = getent ("earth","targetname");
	  		trig3 delete ();
	  		killtrigger delete ();
	  		brush_3 delete ();
			earthy delete ();
}
pushers()
{
	push1 = getent ("pusher1","targetname" );
	push2 = getent ("pusher2","targetname" );
	push3 = getent ("pusher3","targetname" );
	push4 = getent ("pusher4","targetname" );
	push1 delete();
	push2 delete();
	push3 delete();
	push4 delete();
}
			trap4 ()
			{
				level endon("triggeraafzgzgcccd");
			part1 = getentarray ("part_1" ,"targetname");
			part2 = getentarray ("part_2" ,"targetname");
			trig4 = getent ("trig_4" , "targetname");
			trig4 waittill ("triggeraafzgzgcccd" , player );
			trig4 delete ();
			part1[randomInt(part1.size)] notsolid();
            part2[randomInt(part2.size)] notsolid();
			
			}
			
			trap5()
			{
				level endon("triggeraaggd");
			trig5 = getent ("trig_5","targetname");
			brush_5 = getent ("brush5", "targetname");
			brush_6 = getent ("brush6", "targetname");
			trig5 waittill ("triggeraaggd" , player );
			trig5 delete ();
			brush_5 rotateyaw ( 720 , 4 );
			brush_6 rotateyaw ( -720 , 4 );
			wait 4.5;
			brush_5 rotateyaw ( -720 , 4 );
			brush_6 rotateyaw ( 720 , 4 );
			wait 4.5 ;
			}
			trap6 ()
			{
				level endon("triggeazert");
			trig6 = getent ("trig_6","targetname");
			brush_7 = getent ("brush7","targetname");
			killtrigger2 = getent ("killtrig2","targetname");
			trig6 waittill ("triggeazert",player);
			trig6 delete ();
			killtrigger2 enablelinkto ();
			killtrigger2 linkto (brush_7);
			brush_7 movey(164, 0.5);
			wait 2 ;
			brush_7 movey(-164, 0.5);
			wait 1 ;
			}
			trap7 ()
			{
			level endon("triggeraqsqsqsq");
			trig7 = getent ("trig_7", "targetname");
			brush_8 = getent ("brush_8","targetname");
			brush_9 = getent ("brush_9","targetname");
			trig7 waittill ("triggeraqsqsqsq",player);
			trig7 delete ();
			brush_8 rotatepitch ( 90 , 1 ) ;
			brush_9 rotatepitch (- 90, 1 ) ;
			wait 2 ; 
			brush_8 rotatepitch (- 90 , 1 ) ;
			brush_9 rotatepitch ( 90 , 1 ) ;
			wait 2 ;
			}
			trap8 ()
			{
				level endon("triggerasdxd");
			brush_10 = getent ("brush10","targetname");
			brush_11 = getent ("brush11","targetname");
			brush_12 = getent ("brush12","targetname");
			trig8 = getent ("trig_8","targetname");
			trig8 waittill ("triggerasdxd",player);
			trig8 delete ();
			brush_10 movey (56 , 0.5);
			brush_11 movey (-56, 0.5);
			wait 0.5;
			while (1)
			{
			brush_12 rotateroll (360 ,6);
			brush_10 movey (-112 , 1);
			brush_11 movey (112, 1);
			wait 1 ; 
			brush_10 movey (112 , 1);
			brush_11 movey (-112, 1);
			wait 1;
			}
			}
			trap9 ()
			{
				level endon("triggerazfxxxd");
			brush_13 = getent ("brush13","targetname");
			trig_9 = getent ("trig_9","targetname");
			trig_9 waittill ("triggerazfxxxd",player);
			trig_9 delete ();
			brush_13 rotateroll (1800 , 6 );
			wait 1 ;
			}
