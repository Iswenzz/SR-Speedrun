 main()
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "allies";
game["defenders"] = "axis";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

thread sr\api\_map::createSpawn((-936, 440, 348), 0);
thread sr\api\_speedrun::createNormalWays("Normal Way");
thread sr\api\_speedrun::createEndMap((-216.629, -4192.13, 288.12), 130,80, "normal_0");
thread custom_tp();
	
thread door1();
/*thread move1();
thread rotate1();
thread move2();
thread move3();
thread move4();
thread move5();
thread move6();
thread move7();
thread move8();
thread move9();
thread move10();
thread move11();
thread rotate2();
thread move12();
thread rotate3();
thread move13();
thread rotate4();
thread rotate5();
thread rotate6();
thread rotate7();
thread rotate8();
thread rotate9();*/
//thread door2();

//AmbientPlay( "magical" );
}
custom_tp()
{
	trig = spawn("trigger_radius",(-405.006, -2535.6, 272.125), 0, 65, 120);
	trig.radius = 65;
	
	ori_t = spawn("script_origin",(-16,-2546,732));
	ori_t.angles = (0,360,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);


		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
door1()
{
   trig = getent ("door1_aktiv" , "targetname");
   brush = getent ("door1" ,"targetname" );

   wait 0.1;
   brush  delete ();
}

move1()
{
	brush = getent( "move1", "targetname" );

	while(1)
	{
		brush moveX( 1000, 10 );
		wait 2;
		brush moveX(  -1000, 10 );
		wait 2;
	}
	
}

rotate1()
{
 trig = getent( "rorate1_aktiv", "targetname" );
 brush = getent( "rorate1", "targetname" );

 trig waittill( "trigger", who );
 trig delete();

 for( i = 0; i < 999; i++ )
 {
  brush rotatePitch( 180, 4 );
  wait 2;
 }
 brush.angles = (0,0,0);
}

move2()
{
   trig = getent ("move2_aktiv" , "targetname");
   brush = getent ("move2" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move3()
{
   trig = getent ("move3_aktiv" , "targetname");
   brush = getent ("move3" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move4()
{
   trig = getent ("move4_aktiv" , "targetname");
   brush = getent ("move4" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move5()
{
   trig = getent ("move5_aktiv" , "targetname");
   brush = getent ("move5" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move6()
{
   trig = getent ("move6_aktiv" , "targetname");
   brush = getent ("move6" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move7()
{
   trig = getent ("move7_aktiv" , "targetname");
   brush = getent ("move7" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move8()
{
   trig = getent ("move8_aktiv" , "targetname");
   brush = getent ("move8" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move9()
{
   trig = getent ("move9_aktiv" , "targetname");
   brush = getent ("move9" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move10()
{
   trig = getent ("move10_aktiv" , "targetname");
   brush = getent ("move10" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

move11()
{
   trig = getent ("move11_aktiv" , "targetname");
   brush = getent ("move11" ,"targetname" );
   trig waittill ("trigger",player);  
   while(1)
    {
   brush  moveZ (-500 , 10);
   wait 2;
   brush moveZ (500,10);
   wait 2;
    }  
}

rotate2()
{
 
 brush = getent( "rotate2", "targetname" );

 
while (1)
{
 for( i = 0; i < 999; i++ )
 {
  brush rotatePitch( 360, 3 );
  wait 2;
 }
 brush.angles = (0,0,0);
 }
}

move12()
{
	brush = getent( "move12", "targetname" );

	while(1)
	{
		brush moveX( 6000, 25 );
		wait 2;
		brush moveX( -6000, 25 );
		wait 2;
	}
	
}

rotate3()
{
 trig = getent( "rotate3_aktiv", "targetname" );
 brush = getent( "rotate3", "targetname" );

 trig waittill( "trigger", who );
 trig delete();

 for( i = 0; i < 999; i++ )
 {
  brush rotateRoll( 720, 3 );
  wait 7;
 }
 brush.angles = (0,0,0);
}

move13()
{
   trig = getent ("move13_aktiv" , "targetname");
   brush = getent ("move13" ,"targetname" );
   
   trig waittill ("trigger",player);  
   trig delete ();  
 
   brush  moveZ (200 , 1);
   wait 3;
   brush  moveZ (-200 , 1);

} 

rotate4()
{
 trig = getent( "rotate4_aktiv", "targetname" );
 hurt = getent( "hurt", "targetname" );
 brush = getent( "rotate4", "targetname" );

 trig waittill( "trigger", who );
 trig delete();
 
 hurt enablelinkto();
 hurt linkto (brush);
 for( i = 0; i < 999; i++ )
 {
  brush rotateRoll ( 360, 2 );
  wait 2;
 }
 brush.angles = (0,0,0);
}

rotate5()
{
 trig = getent( "rotate5_aktiv", "targetname" );
 hurt = getent( "hurt1", "targetname" );
 brush = getent( "rotate5", "targetname" );

 trig waittill( "trigger", who );
 trig delete();
 
 hurt enablelinkto();
 hurt linkto (brush);
 for( i = 0; i < 999; i++ )
 {
  brush rotateRoll ( 360, 2 );
  wait 2;
 }
 brush.angles = (0,0,0);
}

rotate6()
{
 trig = getent( "rotate6_aktiv", "targetname" );
 hurt = getent( "hurt2", "targetname" );
 brush = getent( "rotate6", "targetname" );

 trig waittill( "trigger", who );
 trig delete();

 hurt enablelinkto();
 hurt linkto (brush);
 for( i = 0; i < 999; i++ )
 {
  brush rotateRoll ( 360, 2 );
  wait 2;
 }
 brush.angles = (0,0,0);
}

rotate7()
{
trig = getEnt( "rotate7_aktiv", "targetname" );
brush = getEnt( "rotate7", "targetname" );

trig waittill( "trigger", who );
trig delete();

for( i = 0; i < 999; i++ )
{
brush rotateYaw( 512, 4 );
wait 3;
brush rotateYaw( -512, 4 );
wait 3;
}
}

rotate8()
{
trig = getEnt( "rotate8_aktiv", "targetname" );
brush = getEnt( "rotate8", "targetname" );

trig waittill( "trigger", who );
trig delete();

for( i = 0; i < 999; i++ )
{
brush rotateYaw( 512, 3 );
wait 3;
brush rotateYaw( -512, 3 );
wait 3;
}
}

rotate9()
{
 trig = getent( "rotate9_aktiv", "targetname" );
 brush = getent( "rotate9", "targetname" );

 trig waittill( "trigger", who );
 trig delete();

 for( i = 0; i < 999; i++ )
 {
  brush rotateRoll ( 360, 8 );
  wait 1;
 }
 brush.angles = (0,0,0);
}
 
 door2()
{
   trig = getent ("door2_aktiv" , "targetname");
   brush = getent ("door2" ,"targetname" );

   wait 0.1;
   brush  delete ();
}
