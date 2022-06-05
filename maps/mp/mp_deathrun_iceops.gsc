main() 
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
  thread sr\api\_speedrun::createSecretWays("Secret Way;");

    thread weapon_fix();

	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawn(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);	
       	maps\mp\_load::main();

		maps\mp\_breakable_windows::main();
		// maps\mp\_acorns::main();
		maps\mp\greenfire::main();
		
       /* [AUTO DELETE] ambientPlay("ambient_9"); */
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar("r_specularcolorscale","1");
    setdvar("r_glowbloomintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
    setdvar("r_glowskybleedintensity0",".1");
	
	precacheModel( "fire_troch" );
	precacheModel( "snow_forist" );
	precacheModel( "snow_tree" );
	precacheModel( "sea_hourse" );
	precacheModel( "snow_weel" );
	precacheModel( "arcons" ); 
	precacheModel( "boat" );
    precacheItem("m40a3_acog_mp");
	precacheItem( "rpg_mp" );
	precacheItem( "g36c_mp" ); 
	

    entr = getEnt ("auto68", "targetname");
    thread sr\api\_speedrun::createTeleporter((316, -2160, -289), 100, 150, 
      entr.origin, entr.angles[1], "freeze", "blue", "secret_0");
	
	level._effect[ "exit_fx" ]		= loadfx( "deathrun/exit_fx" );
	level.playerfx4 = loadfx ("misc/playerfx4");
	
	entTransporter = getentarray("tele1","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter();
   }  
       
	  entTransporter2 = getentarray("teleport2","targetname"); 
  if(isdefined(entTransporter2)) 
  { 
    for(lp=0;lp<entTransporter2.size;lp=lp+1) 
      entTransporter2[lp] thread Transporter2(); 
  }  
	 
	 entTransporter3 = getentarray("teleports3","targetname"); 
  if(isdefined(entTransporter3)) 
  { 
    for(lp=0;lp<entTransporter3.size;lp=lp+1) 
      entTransporter3[lp] thread Transporter3(); 
  }

entTransporter4 = getentarray("lasttele","targetname"); 
  if(isdefined(entTransporter4)) 
  { 
    for(lp=0;lp<entTransporter4.size;lp=lp+1) 
      entTransporter4[lp] thread Transporter4(); 
  }   
	 
   thread sr\api\_speedrun::createEndMap((-1196, -32409, -1839), 200, 150);

    thread trap1();
	thread trap2();
	// thread trap3_a();
	// thread trap3_b();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	// thread obstacles();
	// thread boat();
	// thread shark_1();
	// thread shark_2();
	// thread shark_3();
	// thread creator(); 
	thread transporter();
	thread Transporter2();
	thread Transporter3();
	thread Transporter4();
	/* [AUTO DELETE] thread sniperammo(); */
	thread jumpfail1();
	thread jumpfail2();
	thread jumpfail3();
	thread jumpfail4();
	thread fail1();
	thread fail2();
	thread fail3();
	thread fail4();
	thread fail5();
	thread fail6();
	thread fail7();
	thread tele1();
	thread tele2();
	thread tele3();
	/* [AUTO DELETE] thread secretexit(); */
	// thread secret2enter();
	thread secret2exit();
	thread rpg();
	thread fx1();
	thread fx2();
	thread fx3();
	thread fx4();
	thread fx5();
	thread fx6();
	thread fx7();
	// thread /* [AUTO DELETE] televip(); */
 //     [AUTO DELETE] thread sniper(); 
 //    /* [AUTO DELETE] thread weapons(); */  	
    // thread jumproom(); 
   
  addTriggerToList( "trap1_trig" );
  addTriggerToList( "trap2_trig" );
  addTriggerToList( "trap3_trig" );
  addTriggerToList( "trap4_trig" );
  addTriggerToList( "trap5_trig" );
  addTriggerToList( "trap6_trig" );
  addTriggerToList( "trap7_trig" );
  addTriggerToList( "trap8_trig" );
  addTriggerToList( "trap9_trig" );
  addTriggerToList( "trap10_trig" );
  addTriggerToList( "boat_trig" );
  addTriggerToList( "mapby_trig" );
  addTriggerToList( "jumpfail1_trig" );
  addTriggerToList( "jumpfail2_trig" );
  addTriggerToList( "jumpfail3_trig" );
  addTriggerToList( "jumpfail4_trig" );
  addTriggerToList( "secret1exit_trig" );
  addTriggerToList( "sniperammo_trig" );
  addTriggerToList( "rpg_trigger" );
  
}


weapon_fix()
{
	del_weapon("knife_mp");
	del_weapon("m16_gl_mp");
	del_weapon("ak74u_reflex_mp");
	del_weapon("ak74u_acog_mp");
	del_weapon("ak74u_silencer_mp");
	del_weapon("dog_mp");
	del_weapon("shovel_mp");
}

del_weapon(name)
{
	array = getEntArray("weapon_" + name, "classname");
	if (!isDefined(array) || isDefined(array) && !isDefined(array.size))
		return;

	for (i = 0; i < array.size ;i++)
		array[i] delete();
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

	
trap1()
{
	level endon("trigger"); 
   trig = getent( "trap1_trig", "targetname" );
   spike = getent("spikes","targetname"); 
   hurt1 = getent("trap1_hurt","targetname");
   
   hurt1 enablelinkto();
   hurt1 linkto(spike);
   
   trig waittill("trigger", player); 
   trig delete();   
   {
   spike movez( -185, 0.2);
   spike playsound("gsp_eff");
   wait 2;
   spike movez( 185, 1.5); 
   }
}


trap2()
{
	level endon("trigger"); 
   trig = getent( "trap2_trig", "targetname" );
   t01 = getent("t1","targetname"); 
   t02 = getent("t2","targetname");
   t03 = getent("t3","targetname");

   trig waittill("trigger", player); 
   trig delete();  
   
   while(1)
   {
   t01 movex( 110, 1.5);
   t02 movex( -110, 1.5);
   t03 movex( 110, 1.5);
   wait 1.5;
   t01 movex( -110, 1.5);
   t02 movex( 110, 1.5);
   t03 movex( -110, 1.5);
   wait 1.5;
   }
}


trap3_a()
{ 
   s01 = getent("s1","targetname"); 
   s02 = getent("s2","targetname");
   s03 = getent("s3","targetname");
   s04 = getent("s4","targetname");
   s05 = getent("s5","targetname");
   
   // while(1)
   // { 
   // s01 rotateroll(4,1.5);
   // s02 rotatePitch(4,1.5);
   // s03 rotateroll(4,1.5);
   // s04 rotatePitch(4,1.5);
   // s05 rotateroll(4,1.5);
   // wait 1;
   // s01 rotateroll(-8,1.5);
   // s02 rotatePitch(-8,1.5);
   // s03 rotateroll(-8,1.5);
   // s04 rotatePitch(-8,1.5);
   // s05 rotateroll(-8,1.5);
   // wait 1;
   // s01 rotateroll(4,1.5);
   // s02 rotatePitch(4,1.5);
   // s03 rotateroll(4,1.5);
   // s04 rotatePitch(4,1.5);
   // s05 rotateroll(4,1.5);
   // wait 1;
   // }
}


trap3_b()
{
	level endon("trigger"); 
   trig = getent( "trap3_trig", "targetname" );
   t3sh1 = getent("trap3_shark1","targetname");
   s1o1 = getent("shark1_origin1","targetname");
   s1o2 = getent("shark1_origin2","targetname");
   s1o3 = getent("shark1_origin3","targetname");
   s1h = getent("shark1_hurt","targetname");
   t3sh2 = getent("trap3_shark2","targetname");
   s2o1 = getent("shark2_origin1","targetname");
   s2o2 = getent("shark2_origin2","targetname");
   s2o3 = getent("shark2_origin3","targetname");
   s2h = getent("shark2_hurt","targetname");
   t3sh3 = getent("trap3_shark3","targetname");
   s3o1 = getent("shark3_origin1","targetname");
   s3o2 = getent("shark3_origin2","targetname");
   s3o3 = getent("shark3_origin3","targetname");
   s3h = getent("shark3_hurt","targetname");
   t3sh4 = getent("trap3_shark4","targetname");
   s4o1 = getent("shark4_origin1","targetname");
   s4o2 = getent("shark4_origin2","targetname");
   s4o3 = getent("shark4_origin3","targetname");
   s4h = getent("shark4_hurt","targetname");
   t3sh5 = getent("trap3_shark5","targetname");
   s5o1 = getent("shark5_origin1","targetname");
   s5o2 = getent("shark5_origin2","targetname");
   s5o3 = getent("shark5_origin3","targetname");
   s5h = getent("shark5_hurt","targetname");
   t3sh6 = getent("trap3_shark6","targetname");
   s6o1 = getent("shark6_origin1","targetname");
   s6o2 = getent("shark6_origin2","targetname");
   s6o3 = getent("shark6_origin3","targetname");
   s6h = getent("shark6_hurt","targetname");
   t3sh7 = getent("trap3_shark7","targetname");
   s7o1 = getent("shark7_origin1","targetname");
   s7o2 = getent("shark7_origin2","targetname");
   s7o3 = getent("shark7_origin3","targetname");
   s7h = getent("shark7_hurt","targetname");
   t3sh8 = getent("trap3_shark8","targetname");
   s8o1 = getent("shark8_origin1","targetname");
   s8o2 = getent("shark8_origin2","targetname");
   s8o3 = getent("shark8_origin3","targetname");
   s8h = getent("shark8_hurt","targetname");
   
   s1h enablelinkto();
   s1h linkto(t3sh1);
   s2h enablelinkto();
   s2h linkto(t3sh2);
   s3h enablelinkto();
   s3h linkto(t3sh3);
   s4h enablelinkto();
   s4h linkto(t3sh4);
   s5h enablelinkto();
   s5h linkto(t3sh5);
   s6h enablelinkto();
   s6h linkto(t3sh6);
   s7h enablelinkto();
   s7h linkto(t3sh7);
   s8h enablelinkto();
   s8h linkto(t3sh8);
   
   trig waittill("trigger", player); 
   trig delete();  
  
   {
	t3sh1 moveTo( s1o1.origin, 0.3 );
	t3sh1 rotateroll( 10,0.3);
	wait 0.3;
	t3sh1 moveTo( s1o2.origin, 0.3 );
	t3sh1 rotateroll( 40,0.3);
	wait 0.3;
	t3sh1 moveTo( s1o3.origin, 0.3 );
	t3sh1 rotateroll( 60,0.3);
	wait 2.5;
	t3sh2 moveTo( s2o1.origin, 0.3 );
	t3sh2 rotateroll( 10,0.3);
	wait 0.3;
	t3sh2 moveTo( s2o2.origin, 0.3 );
	t3sh2 rotateroll( 40,0.3);
	wait 0.3;
	t3sh2 moveTo( s2o3.origin, 0.3 );
	t3sh2 rotateroll( 60,0.3);
	wait 2.5;
	t3sh3 moveTo( s3o1.origin, 0.3 );
	t3sh3 rotateroll( 10,0.3);
	wait 0.3;
	t3sh3 moveTo( s3o2.origin, 0.3 );
	t3sh3 rotateroll( 40,0.3);
	wait 0.3;
	t3sh3 moveTo( s3o3.origin, 0.3 );
	t3sh3 rotateroll( 60,0.3);
	wait 2.5;
	t3sh4 moveTo( s4o1.origin, 0.3 );
	t3sh4 rotateroll( 10,0.3);
	wait 0.3;
	t3sh4 moveTo( s4o2.origin, 0.3 );
	t3sh4 rotateroll( 40,0.3);
	wait 0.3;
	t3sh4 moveTo( s4o3.origin, 0.3 );
	t3sh4 rotateroll( 60,0.3);
	wait 2.5;
	t3sh5 moveTo( s5o1.origin, 0.3 );
	t3sh5 rotateroll( 10,0.3);
	wait 0.3;
	t3sh5 moveTo( s5o2.origin, 0.3 );
	t3sh5 rotateroll( 40,0.3);
	wait 0.3;
	t3sh5 moveTo( s5o3.origin, 0.3 );
	t3sh5 rotateroll( 60,0.3);
	wait 2.5;
	t3sh6 moveTo( s6o1.origin, 0.3 );
	t3sh6 rotateroll( 10,0.3);
	wait 0.3;
	t3sh6 moveTo( s6o2.origin, 0.3 );
	t3sh6 rotateroll( 40,0.3);
	wait 0.3;
	t3sh6 moveTo( s6o3.origin, 0.3 );
	t3sh6 rotateroll( 60,0.3);
	wait 2.5;
	t3sh7 moveTo( s7o1.origin, 0.3 );
	t3sh7 rotateroll( 10,0.3);
	wait 0.3;
	t3sh7 moveTo( s7o2.origin, 0.3 );
	t3sh7 rotateroll( 40,0.3);
	wait 0.3;
	t3sh7 moveTo( s7o3.origin, 0.3 );
	t3sh7 rotateroll( 60,0.3);
	wait 2.5;
	t3sh8 moveTo( s8o1.origin, 0.3 );
	t3sh8 rotateroll( 10,0.3);
	wait 0.3;
	t3sh8 moveTo( s8o2.origin, 0.3 );
	t3sh8 rotateroll( 40,0.3);
	wait 0.3;
	t3sh8 moveTo( s8o3.origin, 0.3 );
	t3sh8 rotateroll( 60,0.3);
	wait 2.5;
	}
}


trap4()
{
	level endon("trigger"); 
   trig = getent( "trap4_trig", "targetname" );
   t4b1 = getent("trap4_b1","targetname");
   t4b2 = getent("trap4_b2","targetname");
   t4b3 = getent("trap4_b3","targetname");
   t4b4 = getent("trap4_b4","targetname");
   t4b5 = getent("trap4_b5","targetname");
   t4o1 = getent("trap4_origin1","targetname");
   t4o2 = getent("trap4_origin2","targetname");
   t4o3 = getent("trap4_origin3","targetname");   
   t4o4 = getent("trap4_origin4","targetname");
   t4o5 = getent("trap4_origin5","targetname");
   
   trig waittill("trigger", player); 
   trig delete(); 
   
   {
    Earthquake( 2, 1, t4o1.origin, 1000 );
    t4b1 moveTo( t4o1.origin, 2 );
	wait 0.5;
	t4b2 moveTo( t4o2.origin, 2 );
	wait 0.5;
	t4b3 moveTo( t4o3.origin, 2 );
	wait 0.5;
	t4b4 moveTo( t4o4.origin, 2 );
	wait 0.5;
	t4b5 moveTo( t4o5.origin, 2 );
	wait 2;
	t4b1 delete();
	t4b2 delete();
	t4b3 delete();
	t4b4 delete();
	t4b5 delete();
   }
}


trap5()
{
	level endon("trigger"); 
   trig = getent( "trap5_trig", "targetname" );
   t5b1 = getent("trap5_brush1","targetname");
   t5h = getent("trap5_hurt","targetname"); 
   
   t5h enablelinkto();
   t5h linkto(t5b1);
   
   trig waittill("trigger", player); 
   trig delete();   
   
   while(1)
   {
    t5b1 rotatePitch( -360,1);
	wait 2;
	t5b1 rotatePitch( -360,1);
	wait 2;
   }
}


trap6()
{
	level endon("trigger"); 
   trig = getent( "trap6_trig", "targetname" );
   spike6 = getent("spikes_2","targetname"); 
   hurt6 = getent("hurt_t6","targetname"); 
   hurt6 enablelinkto();
   hurt6 linkto(spike6);
   
   trig waittill("trigger", player); 
   trig delete();   
   {
   spike6 movez( 74, 0.2);
   spike6 playsound("sp_eff");
   wait 3;
   spike6 movez( -80, 1.5); 
   }
}


trap7()
{
	level endon("trigger"); 
   trig = getent( "trap7_trig", "targetname" );
   t7b1 = getent("t7_brush1","targetname"); 
   t7b2 = getent("t7_brush2","targetname");
   t7b3 = getent("t7_brush3","targetname");
   t7b4 = getent("t7_brush4","targetname");
   t7b5 = getent("t7_brush5","targetname");

   trig waittill("trigger", player); 
   trig delete();  
   
   while(1)
   { 
    t7b1 movez( 60, 1);
	t7b2 rotateroll(5,1);
	t7b3 rotatePitch(5,1);
	t7b4 movez( 44, 1);
	t7b5 movez( 40, 1);
	wait 1;
    t7b1 movez( 1, 1);
	t7b2 rotateroll(-10,1);
	t7b3 rotatePitch(-10,1);
	t7b4 movez( 1, 1);
	t7b5 movez( 1, 1);
	wait 1;
	t7b1 movez( -61, 1);
	t7b2 rotateroll(5,1);
	t7b3 rotatePitch(5,1);
	t7b4 movez( -45, 1);
	t7b5 movez( -41, 1);
	wait 1;
   }
   
}



trap8()
{
	level endon("trigger"); 
   trig = getent( "trap8_trig", "targetname" );
   sb1 = getent("snowb1","targetname");
   sb2 = getent("snowb2","targetname");
   sb3 = getent("snowb3","targetname");
   sb4 = getent("snowb4","targetname");
   sb5 = getent("snowb5","targetname");
   sb6 = getent("snowb6","targetname");
   sb7 = getent("snowb7","targetname");
   sbo1 = getent("snowb1_origin","targetname");
   sbo2 = getent("snowb2_origin","targetname");
   sbo3 = getent("snowb3_origin","targetname");
   sbo4 = getent("snowb4_origin","targetname");
   sbo5 = getent("snowb5_origin","targetname");
   sbo6 = getent("snowb6_origin","targetname");
   sbo7 = getent("snowb7_origin","targetname");
   sbh1 = getent("snowb1_hurt","targetname");
   sbh2 = getent("snowb2_hurt","targetname");
   sbh3 = getent("snowb3_hurt","targetname");
   sbh4 = getent("snowb4_hurt","targetname");
   sbh5 = getent("snowb5_hurt","targetname");
   sbh6 = getent("snowb6_hurt","targetname");
   sbh7 = getent("snowb7_hurt","targetname");
   sbh1 enablelinkto();
   sbh1 linkto(sb1);
   sbh2 enablelinkto();
   sbh2 linkto(sb2);
   sbh3 enablelinkto();
   sbh3 linkto(sb3);
   sbh4 enablelinkto();
   sbh4 linkto(sb4);
   sbh5 enablelinkto();
   sbh5 linkto(sb5);
   sbh6 enablelinkto();
   sbh6 linkto(sb6);
   sbh7 enablelinkto();
   sbh7 linkto(sb7);
   
   sb1 hide();
   sb2 hide();
   sb3 hide();
   sb4 hide();
   sb5 hide();
   sb6 hide();
   sb7 hide();
   
   trig waittill("trigger", player); 
   trig delete();
   
   sb1 show();
   sb2 show();
   sb3 show();
   sb4 show();
   sb5 show();
   sb6 show();
   sb7 show();
   
  for(;;)
	{
   Earthquake( 2, 1, sbo1.origin, 500 );
   sb1 moveTo( sbo1.origin, 2 );
   sb1 rotateTo( sbo1.angles, 2 );
   wait 0.5;
   sb7 moveTo( sbo7.origin, 2 );
   sb7 rotateTo( sbo7.angles, 2 );
   wait 0.5;
   sb2 moveTo( sbo2.origin, 2 );
   sb2 rotateTo( sbo2.angles, 2 );
   wait 0.5;
   sb3 moveTo( sbo3.origin, 2 );
   sb3 rotateTo( sbo3.angles, 2 );
   wait 0.5;
   sb6 moveTo( sbo6.origin, 2 );
   sb6 rotateTo( sbo6.angles, 2 );
   wait 0.5;
   sb4 moveTo( sbo4.origin, 2 );
   sb4 rotateTo( sbo4.angles, 2 );
   wait 0.5;
   sb7 moveTo( sbo7.origin, 2 );
   sb7 rotateTo( sbo7.angles, 2 );
   wait 2.2;
   sb1 delete();
   sbh1 delete();
   sb2 delete();
   sbh2 delete();
   sb3 delete();
   sbh3 delete();
   sb4 delete();
   sbh4 delete();
   sb5 delete();
   sbh5 delete();
   sb6 delete();
   sbh6 delete();
   sb7 delete();
   sbh7 delete();
   break;
   }
}


trap9()
{
	level endon("trigger"); 
   trig = getent( "trap9_trig", "targetname" );
   spikes1 = getent("t9_spikes1","targetname");
   spikes2 = getent("t9_spikes2","targetname"); 
   slide = getent("t9_slide","targetname");
   t9s1h = getent("t9s1_hurt","targetname");
   t9s2h = getent("t9s2_hurt","targetname");   
   t9s1h enablelinkto();
   t9s1h linkto(spikes1);
   t9s2h enablelinkto();
   t9s2h linkto(spikes2);
   
   trig waittill("trigger", player); 
   trig delete();  
   
   slide movez( 3, 1);
   while(1)
   {
   spikes1 movez( 33, 0.2);
   spikes1 waittill ("movedone");
   spikes1 movez( -33, 0.5);
   spikes1 waittill ("movedone");
   wait 1;
   spikes2 movez( 33, 0.2);
   spikes2 waittill ("movedone");
   spikes2 movez( -33, 0.5);
   spikes2 waittill ("movedone");
   }
}


   
trap10()
{
	level endon("trigger"); 
   trig = getent( "trap10_trig", "targetname" );
   pol1 = getent("trap10_pol1","targetname");
   pol2 = getent("trap10_pol2","targetname");
   pol3 = getent("trap10_pol3","targetname");
   pol4 = getent("trap10_pol4","targetname");   
   
   trig waittill("trigger", player); 
   trig delete();  
   
   while(1)
   {
   pol1 RotateYaw( 360, 6.5);
   pol3 RotateYaw( 360, 6.5);
   pol4 RotateYaw( 360, 6.5);
   pol2 movez( -25, 1.5);
   wait 1.5;
   pol1 RotateYaw( 360, 6.5);
   pol3 RotateYaw( 360, 6.5);
   pol4 RotateYaw( 360, 6.5);
   pol2 movez( 25, 1.5);
   wait 1.5;
   }
}


obstacles()
{ 
   obs1 = getent("obstacle1","targetname");
   obs2 = getent("obstacle2","targetname");
   obs3 = getent("obstacle3","targetname");
   obs1h = getent("obstacle1_hurt","targetname");   
   obs2h = getent("obstacle2_hurt","targetname");
   obs3h = getent("obstacle3_hurt","targetname");
   
   obs1h enablelinkto();
   obs1h linkto(obs1);
   obs2h enablelinkto();
   obs2h linkto(obs2);
   obs3h enablelinkto();
   obs3h linkto(obs3);
   while(1)
   {
   obs1 movex( -2584 , 1);
   obs2 movex( -2584 , 1);
   obs3 movex( 2584 , 1);
   wait 1;
   obs1 RotateYaw( 180, 1);
   obs2 RotateYaw( 180, 1);
   obs3 RotateYaw( 180, 1);
   wait 1;
   obs1 movex( 2584 , 1);
   obs2 movex( 2584 , 1);
   obs3 movex( -2584 , 1);
   wait 1;
   obs1 RotateYaw( 180, 1);
   obs2 RotateYaw( 180, 1);
   obs3 RotateYaw( 180, 1);
   wait 1;
   }
}


transporter()
 {
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   other playsound("mp_enemy_obj_captured");
   wait(0.10);
  }
 }
 
 
 Transporter2() 
{ 
  while(true) 
  { 
    self waittill("trigger",other); 
    entTarget = getent(self.target, "targetname"); 

    wait(0.10); 
    other setorigin(entTarget.origin); 
    other setplayerangles(entTarget.angles);
    other playsound("mp_enemy_obj_captured");
    wait(0.10); 
  } 
}
 

Transporter3() 
{ 
  while(true) 
  { 
    self waittill("trigger",other); 
    entTarget = getent(self.target, "targetname"); 

    wait(0.10); 
    other setorigin(entTarget.origin); 
    other setplayerangles(entTarget.angles); 
    other playsound("mp_enemy_obj_captured");
    wait(0.10); 
  } 
}


Transporter4() 
{ 
  while(true) 
  { 
    self waittill("trigger",other); 
    entTarget = getent(self.target, "targetname"); 

    wait(0.10); 
    other setorigin(entTarget.origin); 
    other setplayerangles(entTarget.angles); 
    other playsound("mp_enemy_obj_captured");
    wait(0.10); 
  } 
}
  


jumpfail1()
{
    trig = getEnt ("jumpfail1_trig", "targetname");
    jf1 = getEnt ("auto39", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(jf1.origin);
        player SetPlayerAngles( jf1.angles );
	}
}


jumpfail2()
{
    trig = getEnt ("jumpfail2_trig", "targetname");
    jf2 = getEnt ("auto40", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(jf2.origin);
        player SetPlayerAngles( jf2.angles );
	}
}


jumpfail3()
{
    trig = getEnt ("jumpfail3_trig", "targetname");
    jf3 = getEnt ("auto41", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(jf3.origin);
        player SetPlayerAngles( jf3.angles );
	}
}



jumpfail4()
{
    trig = getEnt ("jumpfail4_trig", "targetname");
    jf4 = getEnt ("auto42", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(jf4.origin);
        player SetPlayerAngles( jf4.angles );
	}
}


fail1()
{
    trig = getEnt ("fail1_trig", "targetname");
    fo1 = getEnt ("auto70", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo1.origin);
        player SetPlayerAngles( fo1.angles );
	}
}


fail2()
{
    trig = getEnt ("fail2_trig", "targetname");
    fo2 = getEnt ("auto71", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo2.origin);
        player SetPlayerAngles( fo2.angles );
	}
}


fail3()
{
    trig = getEnt ("fail3_trig", "targetname");
    fo3 = getEnt ("auto72", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo3.origin);
        player SetPlayerAngles( fo3.angles );
	}
}


fail4()
{
    trig = getEnt ("fail4_trig", "targetname");
    fo4 = getEnt ("auto73", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo4.origin);
        player SetPlayerAngles( fo4.angles );
	}
}


fail5()
{
    trig = getEnt ("fail5_trig", "targetname");
    fo5 = getEnt ("auto74", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo5.origin);
        player SetPlayerAngles( fo5.angles );
	}
}


fail6()
{
    trig = getEnt ("fail6_trig", "targetname");
    fo6 = getEnt ("auto75", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo6.origin);
        player SetPlayerAngles( fo6.angles );
	}
}


fail7()
{
    trig = getEnt ("fail7_trig", "targetname");
    fo7 = getEnt ("auto76", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(fo7.origin);
        player SetPlayerAngles( fo7.angles );
	}
}


televip() 
{
	secretvip = getentarray("secret1enter_trig","targetname");
	if(isdefined(secretvip))
	{
		for(lp=0;lp<secretvip.size;lp++)
		secretvip[lp] thread secretenter();
	}
}


secretenter()
{
 // while(true)
	// {
	// f1 = getEnt ("f1_origin", "targetname");
	// self waittill("trigger",other);
	// entTarget = getEnt (self.target, "targetname");
	// wait(.1);
		
	// pb_guid = [];
 //    pb_guid[1] = "33f1db2e016197d7d47923436fb8e97f";
	// pb_guid[2] = "bc0c41408898e2c8000595d963e25c53";
		
	// tempGUID = other getGUID();

	// 	for(i=0;i<pb_guid.size;i++)
	// 	{	
	// 		if(tempGUID == pb_guid[i])
	// 		{
 //        other setorigin(entTarget.origin);
	// 	other setplayerangles(entTarget.angles);
	// 	fx = PlayFX( level._effect["exit_fx"], f1.origin );
	//     /* [AUTO DELETE] other iprintlnbold (" ^1<3 "); */
	// 			wait(.1);
	// 		}
	// 	}
	// }
}


secretexit()
{
    trig = getEnt ("secret1exit_trig", "targetname");
    sexit = getEnt ("auto53", "targetname");
	
    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(sexit.origin);
        player SetPlayerAngles( sexit.angles );
		// player playsound("mp_enemy_obj_captured");
		/* [AUTO DELETE] player iprintlnbold (" you feel different?! "); */
		// PlayFXOnTag( level.playerfx4, player, "j_spinelower" );
	}
}


secret2enter()
{
    trig = getEnt ("secret2_enter", "targetname");
    entr = getEnt ("auto68", "targetname");
	f2 = getEnt ("f2_origin", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(entr.origin);
        player SetPlayerAngles( entr.angles );
		// fx = PlayFX( level._effect["exit_fx"], f2.origin );
		/* [AUTO DELETE] iPrintLnBold(player.name+ "^2 has found the secret room!"); */

	}
}


secret2exit()
{
    trig = getEnt ("secret2_exit", "targetname");
    exit = getEnt ("auto69", "targetname");
	
    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(exit.origin);
        player SetPlayerAngles( exit.angles );
		/* [AUTO DELETE] player giveweapon( "g36c_mp" ); */
		/* [AUTO DELETE] player giveMaxAmmo( "g36c_mp" ); */
		/* [AUTO DELETE] player SwitchToWeapon( "g36c_mp" ); */
		player playsound("mp_enemy_obj_captured");
      player thread sr\api\_speedrun::finishWay("secret_0");
	}
}


tele1()
{
    trig = getEnt ("teleport1_trig", "targetname");
    t1 = getEnt ("auto94", "targetname");
	

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(t1.origin);
        player SetPlayerAngles( t1.angles );
		player playsound("mp_enemy_obj_captured");
		
	}
}


tele2()
{
    trig = getEnt ("teleport2_trig", "targetname");
    t2 = getEnt ("auto95", "targetname");
	

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(t2.origin);
        player SetPlayerAngles( t2.angles );
		player playsound("mp_enemy_obj_captured");
		
	}
}


tele3()
{
    trig = getEnt ("teleport3_trig", "targetname");
    t3 = getEnt ("auto96", "targetname");
	

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(t3.origin);
        player SetPlayerAngles( t3.angles );
		player playsound("mp_enemy_obj_captured");
		
	}
}


sniperammo() 
{
    trig = getEnt ("sniperammo_trig", "targetname");
	
	while(1)
	{
	trig waittill("trigger", player);
	wait 5;
	/* [AUTO DELETE] player giveMaxammo("m40a3_acog_mp"); */
	}
}


	
fx1()
   {
     trigger = getent("f3_trig", "targetname");
	 f3 = getEnt ("f3_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f3.origin );
	}


fx2()
   {
     trigger = getent("f4_trig", "targetname");
	 f4 = getEnt ("f4_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f4.origin );
	}

	
fx3()
   {
     trigger = getent("f5_trig", "targetname");
	 f5 = getEnt ("f5_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f5.origin );
	}

fx4()
   {
     trigger = getent("f6_trig", "targetname");
	 f6 = getEnt ("f6_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f6.origin );
	}

	
fx5()
   {
     trigger = getent("f7_trig", "targetname");
	 f7 = getEnt ("f7_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f7.origin );
	}

	
fx6()
   {
     trigger = getent("f8_trig", "targetname");
	 f8 = getEnt ("f8_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f8.origin );
	}


fx7()
   {
     trigger = getent("f9_trig", "targetname");
	 f9 = getEnt ("f9_origin", "targetname"); 
	 
    trigger waittill("trigger", player);  
	fx = PlayFX( level._effect["exit_fx"], f9.origin );
	}

	
creator()
   {
     say = getent("mapby", "targetname"); 
	 trigger = getent( "mapby_trig", "targetname" );
	 
	 trigger waittill("trigger", player);
	 
	wait 10;
	/* [AUTO DELETE] iPrintLnBold("^2Map by ^5IceOps|*V*"); */
   }

	
rpg()	
{		
trigger = getEnt ("rpg_trigger", "targetname"); 
while(1)
{ 
trigger waittill ("trigger", player);
/* [AUTO DELETE] player GiveWeapon("rpg_mp"); */
player GiveMaxAmmo("rpg_mp");
/* [AUTO DELETE] player SwitchToWeapon( "rpg_mp" ); */

}
}

	
boat()
{
boat=getent("boat_f","targetname");
mtnt=getent("boat_trig","targetname");
tele=getent("brush3_trig","targetname");
clip=getent("boat_clip","targetname");
clip2=getent("boat_clip2","targetname");
clip3=getent("boat_clip3","targetname");
brush01=getent("boat_brush1","targetname");
brush02=getent("boat_brush2","targetname");
brush03=getent("boat_brush3","targetname");
auto=getent("auto27","targetname");
fbo = getEnt ("fbout_origin", "targetname");
mtnt enablelinkto();
mtnt linkto(boat);
tele enablelinkto();
tele linkto(boat);
brush03 hide();
tele hide();

		mtnt waittill("trigger", player);
		clip linkto(boat);
		clip2 linkto(boat);
        clip3 linkto(boat);
		brush01 linkto(boat);
		brush02 linkto(boat);
		brush03 linkto(boat);
		player enablelinkto();
		player linkto(boat);
		boat movey( -2776, 2.5);
		boat waittill ("movedone");
		player unlink();
		
		mtnt waittill("trigger", player);
		player enablelinkto();
		player linkto(boat);
		boat movey( -2520, 2.5);
		boat waittill ("movedone");
		player unlink();
		mtnt delete();
		brush03 show();
        tele show();
		fx = PlayFX( level._effect["exit_fx"], fbo.origin );
		
		tele waittill("trigger", player);
		player SetOrigin(auto.origin);
        player SetPlayerAngles( auto.angles );
		player playsound("mp_enemy_obj_captured");
}


shark_1()
{
   sh1 = getent("shark1","targetname");  

   while(1)
   {
   sh1 movey( -845, 6);
   sh1 waittill ("movedone");
   sh1 rotateYaw( 180, 0.7 );
   sh1 waittill ("rotatedone");
   sh1 movey( 845, 6);
   sh1 waittill ("movedone");
   sh1 rotateYaw( 180, 0.7 );
   sh1 waittill ("rotatedone");
   }
}

	   
shark_2()
{
   sh2 = getent("shark2","targetname");  

   while(1)
   {
   wait 1;
   sh2 movex( 490, 6);
   sh2 waittill ("movedone");
   sh2 rotateYaw( 90, 2 );
   sh2 waittill ("rotatedone");
   sh2 movey( 637, 6);
   sh2 waittill ("movedone");
   sh2 rotateYaw( 90, 2 );
   sh2 waittill ("rotatedone");
   sh2 movex( -490, 6);
   sh2 waittill ("movedone");
   sh2 rotateYaw( 90, 2 );
   sh2 waittill ("rotatedone");
   sh2 movey( -637, 6);
   sh2 waittill ("movedone");
   sh2 rotateYaw( 90, 2);
   sh2 waittill ("rotatedone");
   }
}

	   
shark_3()
{
   sh3 = getent("shark3","targetname");  

   while(1)
   {
   sh3 movex( 680, 6);
   sh3 waittill ("movedone");
   sh3 rotateYaw( 180, 2 );
   sh3 waittill ("rotatedone");
   sh3 movex( -680, 6);
   sh3   waittill ("movedone");
   sh3 rotateYaw( 180, 2 );
   sh3 waittill ("rotatedone");
   }
}


sniper()
{ 
    level.snipe_trig = getEnt("sniper_trig", "targetname");
    jump = getEnt( "jumps", "targetname" ); 
    acti = getEnt( "actis", "targetname" ); 
	 

        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
        return;
		if(level.firstenter==true)
		{
		level.weapon_trig delete();
		level.jumps_trig delete();
		level.firstenter=false;
		}
	 AmbientStop();	
	 /* [AUTO DELETE] ambientPlay("ambient_10"); */	
	 player.health = player.maxhealth;
     level.activ.health = level.activ.maxhealth;		
     player SetPlayerAngles( jump.angles );
	 player setOrigin( jump.origin );
	 level.activ setPlayerangles( acti.angles );
	 level.activ setOrigin( acti.origin );
	 /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	 /* [AUTO DELETE] player TakeAllWeapons(); */
	 /* [AUTO DELETE] level.activ giveweapon( "m40a3_mp"); */
	 /* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */
	 /* [AUTO DELETE] player giveweapon( "m40a3_mp"); */
	 /* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
	 wait 0.05;
	 /* [AUTO DELETE] player switchToWeapon( "m40a3_mp" ); */
	 /* [AUTO DELETE] level.activ SwitchToWeapon( "m40a3_mp" ); */
	 /* [AUTO DELETE] iPrintLnBold(player.name+ "^1 has entered the sniper room"); */
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 wait 3;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
     player thread class_sniper();
     wait 0.1;
       
     for(;;)
     {
         wait .1;               
         while(isAlive(player))
         {
             wait 1;
            }
               
     }
}


class_sniper()
{
     self endon("disconnect");
     self waittill("death");
     thread sniper();
}



weapons()
{ 
    level.weapon_trig = getEnt( "weapons_trigger", "targetname");
    jump = getEnt( "jumpg", "targetname" ); 
    acti = getEnt( "actig", "targetname" ); 
	 
	level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
        return;
		if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.jumps_trig delete();
		level.firstenter=false;
		}
	 AmbientStop();	
	 /* [AUTO DELETE] ambientPlay("ambient_11"); */	
	 player.health = player.maxhealth;
     level.activ.health = level.activ.maxhealth;			
     player SetPlayerAngles( jump.angles );
	 player setOrigin( jump.origin );
	 level.activ setPlayerangles( acti.angles );
	 level.activ setOrigin( acti.origin );
	 /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	 /* [AUTO DELETE] player TakeAllWeapons(); */
	 /* [AUTO DELETE] player giveweapon( "ak74u_mp"); */
	 /* [AUTO DELETE] level.activ giveweapon( "ak74u_mp"); */
	 /* [AUTO DELETE] player giveMaxAmmo( "ak74u_mp"); */
	 /* [AUTO DELETE] level.activ giveMaxAmmo( "ak74u_mp"); */
	 wait 0.05;
	 /* [AUTO DELETE] player switchToWeapon( "ak74u_mp", 100 ); */
	 /* [AUTO DELETE] level.activ SwitchToWeapon( "ak74u_mp", 100 ); */
	 /* [AUTO DELETE] iPrintLnBold(player.name+ "^1 has entered the weapon room"); */
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 wait 3;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
     player thread class_weapon();
     wait 0.1;
       
}


class_weapon()
{
     self endon("disconnect");
     self waittill("death");
     thread weapons();
}



jumproom()
{
    level.jumps_trig = getEnt( "jump_trig", "targetname"); 
    jump = getEnt( "jumpj", "targetname" ); 
    acti = getEnt( "actij", "targetname" ); 
	 

        level.jumps_trig waittill( "trigger", player );
        if( !isDefined( level.jumps_trig ) )
        return;
		if(level.firstenter==true)
		{
		level.weapon_trig delete();
		level.snipe_trig delete(); 
		level.firstenter=false;
		}
	 AmbientStop();	
	 /* [AUTO DELETE] ambientPlay("ambient_11"); */	
	 player.health = player.maxhealth;
     level.activ.health = level.activ.maxhealth;	
     player SetPlayerAngles( jump.angles );
	 player setOrigin( jump.origin );
	 level.activ setPlayerangles( acti.angles );
	 level.activ setOrigin( acti.origin );
	 /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	 /* [AUTO DELETE] player TakeAllWeapons(); */
	 /* [AUTO DELETE] level.activ giveweapon( "knife_mp"); */
	 /* [AUTO DELETE] player giveweapon( "knife_mp"); */
	 /* [AUTO DELETE] wait 0.05; */
	 /* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
	 /* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
	 /* [AUTO DELETE] iPrintLnBold(player.name+ "^1 has entered jump room"); */
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 /* [AUTO DELETE] wait 3; */
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
     player thread class_jumproom();
     /* [AUTO DELETE] wait 0.1; */
}


class_jumproom()
{
     self endon("disconnect");
     self waittill("death");
     thread jumproom();
}
