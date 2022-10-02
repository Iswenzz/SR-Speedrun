//////////////////////////////////////////////////////////////////////////
///Made by: [aL]willeponken///////////////////////////////////////////////
///Credits: [aL]STEALTH, junkman, RedY and Brax for the deathrun mod :)///
///Oh! And i forgot |AoS|Blackass Aka. my hairy balls/////////////////////
//////////////////////////////////////////////////////////////////////////
//I am soz of the mess :(/////////////////////////////////////////////////
//I suck at making script's small xD//////////////////////////////////////
//Just look how many moving blocks i've added...//////////////////////////
//////////////////////////////////////////////////////////////////////////

main()
{
	getEnt("port_begin", "targetname") delete();
	ent = getEnt("port_finish", "targetname");
	ent.targetname = "endmap_trig";

	PrecacheItem("dragunov_mp");
	PrecacheItem("remington700_mp");
	setExpFog(1, 12500, 0.4, 0.425, 0.44, 0.0);
	// ambientPlay("amb_factory");
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_creek");
	thread ShowLogo();
	thread steam_leak();
	thread rotate_waw_trap();
	//thread elevator_move_drown();
	// thread elevator_port_end();
	// thread elevator_port_begin();
	thread rotation();
	thread rotate_prop();
	thread falllucka_activate();
	thread fallsak_rotation();
	thread rotate_prop_jumppad();
	thread jump_teleport();
	thread elevator();
	thread elevator2();
	thread elevator_blocks_effect();
	addTriggerToList( "activate1" );
	addTriggerToList( "activate2" );
	addTriggerToList( "switch" );
	addTriggerToList( "switch2" );
	addTriggerToList( "activate_blocks" );
	addTriggerToList( "activate_meatkvarn" );
	addTriggerToList( "actv" );
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	thread glow();

      jumpPads = getEntArray( "jump_pad1", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();



		       jumpPads = getEntArray( "jump_pad2", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();

		//Sniper Duel AKA Heaven
		       jumpPads = getEntArray( "jump_pad_bridge", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();

		       jumpPads = getEntArray( "jump_pad_small_island", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();

}

addTriggerToList( targetName )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( targetName, "targetname" );
}

elevator_blocks_effect()
{
trigger = getent("activate_blocks", "targetname");
trigger waittill ("trigger",player);
level.trigger delete();
//thread init( "vehicle_cobra_helicopter_fly" );
//player thread test();
thread elevator_move_blocks();
wait 0.2;
thread elevator_move_blocks1();
wait 0.2;
thread elevator_move_blocks2();
wait 0.2;
thread elevator_move_blocks3();
wait 0.2;
thread elevator_move_blocks4();
wait 0.2;
thread elevator_move_blocks5();
wait 0.2;
thread elevator_move_blocks6();
wait 0.2;
thread elevator_move_blocks7();
wait 0.2;
thread elevator_move_blocks8();
wait 0.2;
thread elevator_move_blocks9();
wait 0.2;
thread elevator_move_blocks10();
wait 0.2;
thread elevator_move_blocks11();
wait 0.2;
thread elevator_move_blocks111();
wait 0.2;
thread elevator_move_blocks12();
wait 0.2;
thread elevator_move_blocks13();
wait 0.2;
thread elevator_move_blocks14();
wait 0.2;
thread elevator_move_blocks15();
wait 0.2;
thread elevator_move_blocks16();
wait 0.2;
thread elevator_move_blocks17();
wait 0.2;
thread elevator_move_blocks18();
wait 0.2;
thread elevator_move_blocks19();
wait 0.2;
thread elevator_move_blocks20();
wait 0.2;
thread elevator_move_blocks21();
wait 0.2;
thread elevator_move_blocks22();
wait 0.2;
thread elevator_move_blocks23();
wait 0.2;
thread elevator_move_blocks24();
wait 0.2;
thread elevator_move_blocks25();
wait 0.2;
thread elevator_move_blocks26();
wait 0.2;
thread elevator_move_blocks27();
wait 0.2;
thread elevator_move_blocks28();
wait 0.2;
thread elevator_move_blocks29();
wait 0.2;
thread elevator_move_blocks30();
wait 0.2;
thread elevator_move_blocks31();
wait 0.2;
thread elevator_move_blocks32();
wait 0.2;
thread elevator_move_blocks33();
wait 0.2;
thread elevator_move_blocks34();
wait 0.2;
thread elevator_move_blocks35();
wait 0.2;
thread elevator_move_blocks36();
wait 0.2;
thread elevator_move_blocks37();
wait 0.2;
thread elevator_move_blocks38();
wait 0.2;
thread elevator_move_blocks39();
wait 0.2;
thread elevator_move_blocks40();
wait 0.2;
thread elevator_move_blocks41();
wait 0.2;
thread elevator_move_blocks42();
wait 0.2;
thread elevator_move_blocks43();
wait 0.2;
thread elevator_move_blocks44();
wait 0.2;
thread elevator_move_blocks45();
wait 0.2;
thread elevator_move_blocks46();
/*
	thread elevator_blocks1();
	thread elevator_blocks();
	thread elevator_blocks111();
	thread elevator_blocks2();
	thread elevator_blocks3();
	thread elevator_blocks4();
	thread elevator_blocks5();
	thread elevator_blocks6();
	thread elevator_blocks7();
	thread elevator_blocks8();
	thread elevator_blocks9();
	thread elevator_blocks10();
	thread elevator_blocks11();
	thread elevator_blocks12();
	thread elevator_blocks13();
	thread elevator_blocks14();
	thread elevator_blocks15();
	thread elevator_blocks16();
	thread elevator_blocks18();
	thread elevator_blocks17();
	thread elevator_blocks19();
	thread elevator_blocks20();
	thread elevator_blocks21();
	thread elevator_blocks22();
	thread elevator_blocks23();
	thread elevator_blocks24();
	thread elevator_blocks26();
	thread elevator_blocks25();
	thread elevator_blocks27();
	thread elevator_blocks29();
	thread elevator_blocks28();
	thread elevator_blocks30();
	thread elevator_blocks31();
	thread elevator_blocks32();
	thread elevator_blocks33();
	thread elevator_blocks34();
	thread elevator_blocks35();
	thread elevator_blocks36();
	thread elevator_blocks37();
	thread elevator_blocks38();
	thread elevator_blocks39();
	thread elevator_blocks40();
	thread elevator_blocks41();
	thread elevator_blocks42();
	thread elevator_blocks43();
	thread elevator_blocks44();
	thread elevator_blocks45();
	thread elevator_blocks46();
*/
}

rotate_prop()
{
  rotate_obj = getentarray("rotate_prop","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_rotate_prop();

   }
  }
}

ra_rotate_prop()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";

  while(true)
  {
  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(360,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(360,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(360,self.speed);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
  // self waittill("rotatedone");
  }
}

fallsak_rotation()
{
trigger = getent("activate_meatkvarn", "targetname");
  trigger waittill ("trigger",user);
  level.trigger delete();
  rotate_obj = getentarray("fallsak","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread fallsak_ra_rotate();
   }
  }
}

fallsak_ra_rotate()
{
while(true)
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";


  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(-81,0.6);
   else if (self.script_noteworthy == "x")
    self rotateRoll(-81,0.6);
   else if (self.script_noteworthy == "y")
    self rotatePitch(-81,0.6);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
  // self waittill("rotatedone");
  wait 5;
    if (self.script_noteworthy == "z")
    self rotateYaw(81,2);
   else if (self.script_noteworthy == "x")
    self rotateRoll(81,2);
   else if (self.script_noteworthy == "y")
    self rotatePitch(81,2);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
  trigger = getent ("move_trigger_kill","targetname");
  elevatormodel = getent ("spikes22", "targetname");
  elevatormodel_kill = getent ("move_origin_trigger", "targetname");
  elevatormodel_cylinder = getent ("spike2", "targetname");
  trigger enablelinkto();
  trigger linkto( elevatormodel_kill );
  speed = 1;
  height =-272;
   elevatormodel playsound ("elevator");
   elevatormodel movez (height, speed);
   elevatormodel_kill movez (height, speed);
   elevatormodel_cylinder movez (height, speed);
   elevatormodel waittill ("movedone");
   quake = getent("teleport_target","targetname");
   Earthquake( 0.3, 1, quake.origin, 500 );
   wait 5;
   elevatormodel playsound ("elevator");
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel_kill movez (height - (height * 2), speed);
   elevatormodel_cylinder movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");

	wait 99999;
	}
}

rotation()
{
trigger = getent("activate1", "targetname");
  trigger waittill ("trigger",user);
  level.trigger delete();
  rotate_obj = getentarray("rotate","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_rotate();
   }
  }
}

ra_rotate()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";

  while(true)
  {
  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(360,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(360,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(360,self.speed);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
  // self waittill("rotatedone");
  }
}

falllucka_activate()
{
trigger = getent("activate2", "targetname");
 trigger waittill ("trigger",user);
 level.trigger delete();
 thread falllucka();
 thread falllucka2();
}

falllucka()
{
  rotate_obj = getentarray("falllucka","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_falllucka();
   }
  }
}

ra_falllucka()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";

  while(true)
  {
  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(83,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(83,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(83,self.speed);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
	self NotSolid();
	wait 5;
	self Solid();
	   if (self.script_noteworthy == "z")
    self rotateYaw(-83,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(-83,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(-83,self.speed);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
  wait 99999;
  }
}

falllucka2()
{
  rotate_obj = getentarray("falllucka2","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_falllucka2();
   }
  }
}

ra_falllucka2()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";

  while(true)
  {
  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(-83,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(-83,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(-83,self.speed);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
	self NotSolid();
	wait 5;
	self Solid();
	   if (self.script_noteworthy == "z")
    self rotateYaw(83,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(83,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(83,self.speed);
    wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
  wait 99999;
  }
}

elevator()
{
  level.elevatorDown = true;
  level.elevatorMoving = false;
  thread elevator_start();
}

elevator_start()
{
  elevator = getentarray ("switch","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think();
}

elevator_think()
{
	trigger = getent("switch", "targetname");
	trigger waittill ("trigger",user);
	level.trigger delete();
   if (!level.elevatorMoving)
   thread elevator_move();
}

elevator_move()
{
  elevatormodel = getent ("elevator", "targetname");
  level.elevatorMoving = true;
  speed = 2;
  height =-300;
  if (level.elevatorDown)
  {
   elevatormodel playsound ("elevator");
   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
   level.elevatorDown = false;
  }
  else
  {
   elevatormodel playsound ("elevator");
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   level.elevatorDown = true;
  }
  level.elevatorMoving = false;
    wait 5;
   elevatormodel playsound ("elevator");
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   level.elevatorDown = true;
}

elevator2()
{
   trigger = getent("switch2", "targetname");
	trigger waittill ("trigger",user);
	level.trigger delete();
  level.elevatorDown = true;
  level.elevatorMoving = false;
  thread elevator_start2();
}

elevator_start2()
{
  elevator = getentarray ("switch2","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think2();
}

elevator_think2()
{
   if (!level.elevatorMoving)
   thread elevator_move2();
}

elevator_move2()
{
	trigger = getent ("kill_trigger","targetname");
  elevatormodel = getent ("spikes", "targetname");
  elevatormodel_kill = getent ("spikes_kill", "targetname");
  elevatormodel_cylinder = getent ("spikes_cylinder", "targetname");
  trigger enablelinkto();
  trigger linkto( elevatormodel_kill );
  speed = 1;
  height =-240;
   elevatormodel playsound ("elevator");
   elevatormodel movez (height, speed);
   elevatormodel_kill movez (height, speed);
   elevatormodel_cylinder movez (height, speed);
   elevatormodel waittill ("movedone");
   quake = getent("spikes_kill","targetname");
   Earthquake( 0.3, 1, quake.origin, 500 );
    wait 5;
   elevatormodel playsound ("elevator");
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel_kill movez (height - (height * 2), speed);
   elevatormodel_cylinder movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
}

//////////////////////////////////////////////////////////////////////////////////

elevator_blocks()
{
  level.elevatorDown = true;
  level.elevatorMoving = false;
  thread elevator_start_blocks();
}

elevator_start_blocks()
{
  elevator = getentarray ("movedown","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks();
}

elevator_think_blocks()
{
   self waittill ("trigger");
   if (!level.elevatorMoving)
   thread elevator_move_blocks();
}

elevator_move_blocks()
{
  elevatormodel = getent ("blocks", "targetname");
  level.elevatorMoving = true;
  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
   level.elevatorDown = false;
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   level.elevatorDown = true;
   thread elevator_blocks();
}

///////////////////////////////////////////////

elevator_blocks1()
{
  thread elevator_start_blocks1();
}

elevator_start_blocks1()
{
  elevator = getentarray ("movedown2","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks1();
}

elevator_think_blocks1()
{
   self waittill ("trigger");
   thread elevator_move_blocks1();
}

elevator_move_blocks1()
{
  elevatormodel = getent ("blocks1", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks1();
}

////////////////////////////////////////////////////////////////

elevator_blocks2()
{
  thread elevator_start_blocks2();
}

elevator_start_blocks2()
{
  elevator = getentarray ("movedown3","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks2();
}

elevator_think_blocks2()
{
   self waittill ("trigger");
   thread elevator_move_blocks2();
}

elevator_move_blocks2()
{
  elevatormodel = getent ("blocks2", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks2();
}

//////////////////////////////

elevator_blocks3()
{
  thread elevator_start_blocks3();
}

elevator_start_blocks3()
{
  elevator = getentarray ("movedown4","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks3();
}

elevator_think_blocks3()
{
   self waittill ("trigger");
   thread elevator_move_blocks3();
}

elevator_move_blocks3()
{
  elevatormodel = getent ("blocks3", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks3();
}

/////////////////////////////////////////////////

elevator_blocks4()
{
  thread elevator_start_blocks4();
}

elevator_start_blocks4()
{
  elevator = getentarray ("movedown5","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks4();
}

elevator_think_blocks4()
{
   self waittill ("trigger");
   thread elevator_move_blocks4();
}

elevator_move_blocks4()
{
  elevatormodel = getent ("blocks4", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks4();
}

//////////////////

elevator_blocks5()
{
  thread elevator_start_blocks5();
}

elevator_start_blocks5()
{
  elevator = getentarray ("movedown6","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks5();
}

elevator_think_blocks5()
{
   self waittill ("trigger");
   thread elevator_move_blocks5();
}

elevator_move_blocks5()
{
  elevatormodel = getent ("blocks5", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks5();
}

///////////

elevator_blocks6()
{
  thread elevator_start_blocks6();
}

elevator_start_blocks6()
{
  elevator = getentarray ("movedown7","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks6();
}

elevator_think_blocks6()
{
   self waittill ("trigger");
   thread elevator_move_blocks6();
}

elevator_move_blocks6()
{
  elevatormodel = getent ("blocks6", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks6();
}

/////////////////////////

elevator_blocks7()
{
  thread elevator_start_blocks7();
}

elevator_start_blocks7()
{
  elevator = getentarray ("movedown8","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks7();
}

elevator_think_blocks7()
{
   self waittill ("trigger");
   thread elevator_move_blocks7();
}

elevator_move_blocks7()
{
  elevatormodel = getent ("blocks7", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks7();
}

/////////////

elevator_blocks9()
{
  thread elevator_start_blocks9();
}

elevator_start_blocks9()
{
  elevator = getentarray ("movedown10","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks9();
}

elevator_think_blocks9()
{
   self waittill ("trigger");
   thread elevator_move_blocks9();
}

elevator_move_blocks9()
{
  elevatormodel = getent ("blocks9", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks9();
}

///////////////////////////////

elevator_blocks8()
{
  thread elevator_start_blocks8();
}

elevator_start_blocks8()
{
  elevator = getentarray ("movedown9","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks8();
}

elevator_think_blocks8()
{
   self waittill ("trigger");
   thread elevator_move_blocks8();
}

elevator_move_blocks8()
{
  elevatormodel = getent ("blocks8", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks8();
}

//////////////////////////////////
/*
elevator_blocks9()
{
  thread elevator_start_blocks9();
}

elevator_start_blocks9()
{
  elevator = getentarray ("movedown10","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks9();
}

elevator_think_blocks9()
{
   self waittill ("trigger");
   thread elevator_move_blocks9();
}

elevator_move_blocks9()
{
  elevatormodel = getent ("blocks9", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks9();
}
*/

/////////////////////////////////

elevator_blocks10()
{
  thread elevator_start_blocks10();
}

elevator_start_blocks10()
{
  elevator = getentarray ("movedown11","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks10();
}

elevator_think_blocks10()
{
   self waittill ("trigger");
   thread elevator_move_blocks10();
}

elevator_move_blocks10()
{
  elevatormodel = getent ("blocks10", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks10();
}

///////////////////////

elevator_blocks11()
{
  thread elevator_start_blocks11();
}

elevator_start_blocks11()
{
  elevator = getentarray ("movedown12","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks11();
}

elevator_think_blocks11()
{
   self waittill ("trigger");
   thread elevator_move_blocks11();
}

elevator_move_blocks11()
{
  elevatormodel = getent ("blocks11", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks11();
}


///////////////////////

elevator_blocks12()
{
  thread elevator_start_blocks12();
}

elevator_start_blocks12()
{
  elevator = getentarray ("movedown13","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks12();
}

elevator_think_blocks12()
{
   self waittill ("trigger");
   thread elevator_move_blocks12();
}

elevator_move_blocks12()
{
  elevatormodel = getent ("blocks12", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks12();
}

////////////////////

elevator_blocks13()
{
  thread elevator_start_blocks13();
}

elevator_start_blocks13()
{
  elevator = getentarray ("movedown14","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks13();
}

elevator_think_blocks13()
{
   self waittill ("trigger");
   thread elevator_move_blocks13();
}

elevator_move_blocks13()
{
  elevatormodel = getent ("blocks13", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks13();
}

///////////////

elevator_blocks14()
{
  thread elevator_start_blocks14();
}

elevator_start_blocks14()
{
  elevator = getentarray ("movedown15","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks14();
}

elevator_think_blocks14()
{
   self waittill ("trigger");
   thread elevator_move_blocks14();
}

elevator_move_blocks14()
{
  elevatormodel = getent ("blocks14", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks14();
}

//////////////////

elevator_blocks15()
{
  thread elevator_start_blocks15();
}

elevator_start_blocks15()
{
  elevator = getentarray ("movedown16","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks15();
}

elevator_think_blocks15()
{
   self waittill ("trigger");
   thread elevator_move_blocks15();
}

elevator_move_blocks15()
{
  elevatormodel = getent ("blocks15", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks15();
}

////////////////

elevator_blocks16()
{
  thread elevator_start_blocks16();
}

elevator_start_blocks16()
{
  elevator = getentarray ("movedown17","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks16();
}

elevator_think_blocks16()
{
   self waittill ("trigger");
   thread elevator_move_blocks16();
}

elevator_move_blocks16()
{
  elevatormodel = getent ("blocks16", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks16();
}

//////////////////////

elevator_blocks17()
{
  thread elevator_start_blocks17();
}

elevator_start_blocks17()
{
  elevator = getentarray ("movedown18","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks17();
}

elevator_think_blocks17()
{
   self waittill ("trigger");
   thread elevator_move_blocks17();
}

elevator_move_blocks17()
{
  elevatormodel = getent ("blocks17", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks17();
}

//////////////////////////

elevator_blocks18()
{
  thread elevator_start_blocks18();
}

elevator_start_blocks18()
{
  elevator = getentarray ("movedown19","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks18();
}

elevator_think_blocks18()
{
   self waittill ("trigger");
   thread elevator_move_blocks18();
}

elevator_move_blocks18()
{
  elevatormodel = getent ("blocks18", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks18();
}

/////////////

elevator_blocks19()
{
  thread elevator_start_blocks19();
}

elevator_start_blocks19()
{
  elevator = getentarray ("movedown20","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks19();
}

elevator_think_blocks19()
{
   self waittill ("trigger");
   thread elevator_move_blocks19();
}

elevator_move_blocks19()
{
  elevatormodel = getent ("blocks19", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks19();
}

///////////////

elevator_blocks20()
{
  thread elevator_start_blocks20();
}

elevator_start_blocks20()
{
  elevator = getentarray ("movedown21","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks20();
}

elevator_think_blocks20()
{
   self waittill ("trigger");
   thread elevator_move_blocks20();
}

elevator_move_blocks20()
{
  elevatormodel = getent ("blocks20", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks20();
}

////////////////////////

elevator_blocks21()
{
  thread elevator_start_blocks21();
}

elevator_start_blocks21()
{
  elevator = getentarray ("movedown22","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks21();
}

elevator_think_blocks21()
{
   self waittill ("trigger");
   thread elevator_move_blocks21();
}

elevator_move_blocks21()
{
  elevatormodel = getent ("blocks21", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks21();
}

//////////////////

elevator_blocks22()
{
  thread elevator_start_blocks22();
}

elevator_start_blocks22()
{
  elevator = getentarray ("movedown23","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks22();
}

elevator_think_blocks22()
{
   self waittill ("trigger");
   thread elevator_move_blocks22();
}

elevator_move_blocks22()
{
  elevatormodel = getent ("blocks22", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks22();
}

////////////////////////////////////

elevator_blocks23()
{
  thread elevator_start_blocks23();
}

elevator_start_blocks23()
{
  elevator = getentarray ("movedown24","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks23();
}

elevator_think_blocks23()
{
   self waittill ("trigger");
   thread elevator_move_blocks23();
}

elevator_move_blocks23()
{
  elevatormodel = getent ("blocks23", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks23();
}

/////////////////

elevator_blocks24()
{
  thread elevator_start_blocks24();
}

elevator_start_blocks24()
{
  elevator = getentarray ("movedown25","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks24();
}

elevator_think_blocks24()
{
   self waittill ("trigger");
   thread elevator_move_blocks24();
}

elevator_move_blocks24()
{
  elevatormodel = getent ("blocks24", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks24();
}

/////////////////////

elevator_blocks25()
{
  thread elevator_start_blocks25();
}

elevator_start_blocks25()
{
  elevator = getentarray ("movedown26","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks25();
}

elevator_think_blocks25()
{
   self waittill ("trigger");
   thread elevator_move_blocks25();
}

elevator_move_blocks25()
{
  elevatormodel = getent ("blocks25", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks25();
}

////////////////////

elevator_blocks26()
{
  thread elevator_start_blocks26();
}

elevator_start_blocks26()
{
  elevator = getentarray ("movedown27","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks26();
}

elevator_think_blocks26()
{
   self waittill ("trigger");
   thread elevator_move_blocks26();
}

elevator_move_blocks26()
{
  elevatormodel = getent ("blocks26", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks26();
}

//////////////////

elevator_blocks27()
{
  thread elevator_start_blocks27();
}

elevator_start_blocks27()
{
  elevator = getentarray ("movedown28","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks27();
}

elevator_think_blocks27()
{
   self waittill ("trigger");
   thread elevator_move_blocks27();
}

elevator_move_blocks27()
{
  elevatormodel = getent ("blocks27", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks27();
}

////////////////////

elevator_blocks28()
{
  thread elevator_start_blocks28();
}

elevator_start_blocks28()
{
  elevator = getentarray ("movedown29","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks28();
}

elevator_think_blocks28()
{
   self waittill ("trigger");
   thread elevator_move_blocks28();
}

elevator_move_blocks28()
{
  elevatormodel = getent ("blocks28", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks28();
}

///////////////////////

/*
elevator_blocks28()
{
  thread elevator_start_blocks28();
}

elevator_start_blocks28()
{
  elevator = getentarray ("movedown29","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks28();
}

elevator_think_blocks28()
{
   self waittill ("trigger");
   thread elevator_move_blocks28();
}

elevator_move_blocks28()
{
  elevatormodel = getent ("blocks28", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks28();
}
*/
//////////////////

elevator_blocks29()
{
  thread elevator_start_blocks29();
}

elevator_start_blocks29()
{
  elevator = getentarray ("movedown30","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks29();
}

elevator_think_blocks29()
{
   self waittill ("trigger");
   thread elevator_move_blocks29();
}

elevator_move_blocks29()
{
  elevatormodel = getent ("blocks29", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks29();
}

//////////////////

elevator_blocks30()
{
  thread elevator_start_blocks30();
}

elevator_start_blocks30()
{
  elevator = getentarray ("movedown31","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks30();
}

elevator_think_blocks30()
{
   self waittill ("trigger");
   thread elevator_move_blocks30();
}

elevator_move_blocks30()
{
  elevatormodel = getent ("blocks30", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks30();
}

////////////////

elevator_blocks31()
{
  thread elevator_start_blocks31();
}

elevator_start_blocks31()
{
  elevator = getentarray ("movedown32","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks31();
}

elevator_think_blocks31()
{
   self waittill ("trigger");
   thread elevator_move_blocks31();
}

elevator_move_blocks31()
{
  elevatormodel = getent ("blocks31", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks31();
}

/////////////////////////

elevator_blocks32()
{
  thread elevator_start_blocks32();
}

elevator_start_blocks32()
{
  elevator = getentarray ("movedown33","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks32();
}

elevator_think_blocks32()
{
   self waittill ("trigger");
   thread elevator_move_blocks32();
}

elevator_move_blocks32()
{
  elevatormodel = getent ("blocks32", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks32();
}

///////////

elevator_blocks33()
{
  thread elevator_start_blocks33();
}

elevator_start_blocks33()
{
  elevator = getentarray ("movedown34","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks33();
}

elevator_think_blocks33()
{
   self waittill ("trigger");
   thread elevator_move_blocks33();
}

elevator_move_blocks33()
{
  elevatormodel = getent ("blocks33", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks33();
}

//////////////////

elevator_blocks34()
{
  thread elevator_start_blocks34();
}

elevator_start_blocks34()
{
  elevator = getentarray ("movedown35","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks34();
}

elevator_think_blocks34()
{
   self waittill ("trigger");
   thread elevator_move_blocks34();
}

elevator_move_blocks34()
{
  elevatormodel = getent ("blocks34", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks34();
}

///////////////////

elevator_blocks35()
{
  thread elevator_start_blocks35();
}

elevator_start_blocks35()
{
  elevator = getentarray ("movedown36","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks35();
}

elevator_think_blocks35()
{
   self waittill ("trigger");
   thread elevator_move_blocks35();
}

elevator_move_blocks35()
{
  elevatormodel = getent ("blocks35", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks35();
}

///////////////

elevator_blocks36()
{
  thread elevator_start_blocks36();
}

elevator_start_blocks36()
{
  elevator = getentarray ("movedown37","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks36();
}

elevator_think_blocks36()
{
   self waittill ("trigger");
   thread elevator_move_blocks36();
}

elevator_move_blocks36()
{
  elevatormodel = getent ("blocks36", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks36();
}

//////////////////////

elevator_blocks37()
{
  thread elevator_start_blocks37();
}

elevator_start_blocks37()
{
  elevator = getentarray ("movedown38","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks37();
}

elevator_think_blocks37()
{
   self waittill ("trigger");
   thread elevator_move_blocks37();
}

elevator_move_blocks37()
{
  elevatormodel = getent ("blocks37", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks37();
}

/////////////////

elevator_blocks38()
{
  thread elevator_start_blocks38();
}

elevator_start_blocks38()
{
  elevator = getentarray ("movedown39","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks38();
}

elevator_think_blocks38()
{
   self waittill ("trigger");
   thread elevator_move_blocks38();
}

elevator_move_blocks38()
{
  elevatormodel = getent ("blocks38", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks38();
}

////////////////////

elevator_blocks39()
{
  thread elevator_start_blocks39();
}

elevator_start_blocks39()
{
  elevator = getentarray ("movedown40","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks39();
}

elevator_think_blocks39()
{
   self waittill ("trigger");
   thread elevator_move_blocks39();
}

elevator_move_blocks39()
{
  elevatormodel = getent ("blocks39", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks39();
}

///////////////

elevator_blocks40()
{
  thread elevator_start_blocks40();
}

elevator_start_blocks40()
{
  elevator = getentarray ("movedown41","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks40();
}

elevator_think_blocks40()
{
   self waittill ("trigger");
   thread elevator_move_blocks40();
}

elevator_move_blocks40()
{
  elevatormodel = getent ("blocks40", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks40();
}

//////////

elevator_blocks41()
{
  thread elevator_start_blocks41();
}

elevator_start_blocks41()
{
  elevator = getentarray ("movedown42","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks41();
}

elevator_think_blocks41()
{
   self waittill ("trigger");
   thread elevator_move_blocks41();
}

elevator_move_blocks41()
{
  elevatormodel = getent ("blocks41", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks41();
}

//////////

elevator_blocks42()
{
  thread elevator_start_blocks42();
}

elevator_start_blocks42()
{
  elevator = getentarray ("movedown43","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks42();
}

elevator_think_blocks42()
{
   self waittill ("trigger");
   thread elevator_move_blocks42();
}

elevator_move_blocks42()
{
  elevatormodel = getent ("blocks42", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks42();
}

/////////////

elevator_blocks43()
{
  thread elevator_start_blocks43();
}

elevator_start_blocks43()
{
  elevator = getentarray ("movedown44","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks43();
}

elevator_think_blocks43()
{
   self waittill ("trigger");
   thread elevator_move_blocks43();
}

elevator_move_blocks43()
{
  elevatormodel = getent ("blocks43", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks43();
}

/////////////////////

elevator_blocks44()
{
  thread elevator_start_blocks44();
}

elevator_start_blocks44()
{
  elevator = getentarray ("movedown45","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks44();
}

elevator_think_blocks44()
{
   self waittill ("trigger");
   thread elevator_move_blocks44();
}

elevator_move_blocks44()
{
  elevatormodel = getent ("blocks44", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks44();
}

///////////////////////

elevator_blocks45()
{
  thread elevator_start_blocks45();
}

elevator_start_blocks45()
{
  elevator = getentarray ("movedown46","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks45();
}

elevator_think_blocks45()
{
   self waittill ("trigger");
   thread elevator_move_blocks45();
}

elevator_move_blocks45()
{
  elevatormodel = getent ("blocks45", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks45();
}

////////////////////

elevator_blocks46()
{
  thread elevator_start_blocks46();
}

elevator_start_blocks46()
{
  elevator = getentarray ("movedown47","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks46();
}

elevator_think_blocks46()
{
   self waittill ("trigger");
   thread elevator_move_blocks46();
}

elevator_move_blocks46()
{
  elevatormodel = getent ("blocks46", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks46();
}

/////////////

elevator_blocks111()
{
  thread elevator_start_blocks111();
}

elevator_start_blocks111()
{
  elevator = getentarray ("movedown111","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_blocks111();
}

elevator_think_blocks111()
{
   self waittill ("trigger");
   thread elevator_move_blocks111();
}

elevator_move_blocks111()
{
  elevatormodel = getent ("blocks111", "targetname");

  speed = 5;
  height =-300;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
//--------------------------------------------------------//
   elevatormodel movez (height - (height * 2), speed);
   elevatormodel waittill ("movedone");
   thread elevator_blocks111();
}

//////////////////////////////////////////////////
// ^- Longest script ever? :o took me 3 hours xD//
//////////////////////////////////////////////////


jump_teleport()
{

	level.breakables_fx[ "jump_teleport" ] = loadfx( "custom/jump_teleport" );
	precacheShader("white");

	waittillframeend;

	// setdvar( "sv_cheats", 1 );
	// setdvar( "bg_falldamagemaxheight", 9999 );
	// setdvar( "bg_falldamageminheight", 9998 );
    // 	setdvar( "sv_cheats", 0 );

	for(;;)
	{

	waittillframeend;

	trigger = getent( "jump_trigger", "targetname" );
	trigger waittill( "trigger", player );

	jump_teleport_trigger( player );

	}

}

 jump_teleport_trigger( player )
{

	flash = undefined;

	fx = playFX( level.breakables_fx[ "jump_teleport" ], player.origin, player.angles, 0);

	flash = newClientHudElem( player );
	flash.x = 0;
	flash.y = 0;
	flash setshader ("white", 640, 480);
	flash.alignX = "left";
	flash.alignY = "top";
	flash.horzAlign = "fullscreen";
	flash.vertAlign = "fullscreen";
	flash.color = ( .16, .38, .5 );
	flash.alpha = .75;

	flash fadeOverTime( 0.75 );

	wait( 0.10 );

	flash.alpha = 0;
	flash fadeOverTime( 0.75 );
	player suicide();

}

rotate_prop_jumppad()
{
  rotate_obj = getentarray("jumppad_platform","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_rotate_prop_jumppad();

   }
  }
}

ra_rotate_prop_jumppad()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";

  while(true)
  {
  trigger = getent("jumppad_trigger", "targetname");
  trigger waittill ("trigger",user);

  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(-80,0.4);
   else if (self.script_noteworthy == "x")
    self rotateRoll(-80,0.4);
   else if (self.script_noteworthy == "y")
    self rotatePitch(-80,0.4);
	self waittill("rotatedone");
	wait 2;
	   if (self.script_noteworthy == "z")
    self rotateYaw(80,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(80,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(80,self.speed);
  self waittill("rotatedone");
  }
}

monitorTrigger()
{
    while(1)
    {
        self waittill( "trigger", player );
        if( isPlayer( player ) && isAlive( player ) )
            player thread Boost( Int( self.script_noteworthy ) );
    }
}

Boost( damage )
{
	oldhp = self.health;
	self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
    eInflictor = self;
    eAttacker = self;
    iDamage = damage;
    iDFlags = 0;
    sMeansOfDeath = "MOD_PROJECTILE";
    sWeapon = "rpg_mp";
    vPoint = ( self.origin + (0,0,-1) );
    vDir = vectornormalize( self.origin - vPoint );
    sHitLoc = "none";
    psOffsetTime = 0;

    self.health += iDamage;
    self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
	self.health = oldhp;
	wait 3;
}
/*
monitorTrigger()
 {
     while(1)
     {
         self waittill( "trigger", player );
         if( player.sessionstate == "playing" )
             player thread bounce( vectorNormalize( player.origin - (player.origin - (0,0,5)), Int( self.script_noteworthy ) );
     }
 }

 // >>> Copied from Death Run Mod
 bounce( pos, power )  // This function doesnt require to thread it
 {
     oldhp = self.health;
     self.health = self.health + power;
     self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
     self finishPlayerDamage( self, self, power, 0, "MOD_PROJECTILE", "bh_mp", undefined, pos, "none", 0 );
     self.health = oldhp;
     self thread bounce2();
 }
 bounce2()
 {
     self endon( "disconnect" );
     wait .05;
     self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
 }
 // <<<
 */

elevator_port_begin()
{
wait 10;
  thread elevator_move_begin();
}

elevator_move_begin()
{
  elevatormodel = getent ("port_begin", "targetname");

  speed = 10;
  height =200;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");
}

elevator_port_end()
{
  thread elevator_start_end();
}

elevator_start_end()
{
  elevator = getentarray ("port_finish","targetname");
  if ( isdefined(elevator) )
  for (i = 0; i < elevator.size; i++)
  elevator[i] thread elevator_think_end();
}

elevator_think_end()
{
   self waittill ("trigger");
   thread begin_door_open();
	//deathmethod1 = " reached the activator!";
	//iPrintLn( user.name, deathmetod1);
	musicplay ("music_end");

	//thread musicstop();

   thread elevator_move_end();
}


elevator_move_end()
{
  elevatormodel = getent ("port_end", "targetname");

  speed = 10;
  height =150;

   elevatormodel movez (height, speed);
   elevatormodel waittill ("movedone");

}

steam_leak()
{
leak_steam = getent("leak_steam","targetname");
sewer_dist = getent("sewer_dist","targetname");

level._effect[ "leak" ] = loadfx( "impacts/pipe_steam" );
level._effect[ "water" ] = loadfx( "impacts/pipe_water" );
level._effect[ "sewer_water_dist" ] = loadfx( "distortion/mp_factory_sewer_dist" );

maps\mp\_fx::loopfx("leak", (leak_steam.origin), 3, (leak_steam.origin) + (23, -600, 147));
maps\mp\_fx::loopfx("water", (leak_steam.origin), 3, (leak_steam.origin) + (23, -600, 147));
maps\mp\_fx::loopfx("sewer_water_dist", (sewer_dist.origin), 3, (sewer_dist.origin) + (0, 0, 0));

sound = getent("leak_steam","targetname");
while (1)
	{
sound playsound("steam_pipe_loop");
wait 4;
	}

}

elevator_move_drown()
{
  trigger = getent("open_port_end_2", "targetname");
  trigger waittill ("trigger",user);

    elevatormodel = getent ("move_water", "targetname");

   elevatormodel movez (150, 10);
   elevatormodel waittill ("movedone");

}

rotate_waw_trap()
{
  rotate_obj = getentarray("waw_trap","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_rotate_waw_trap();

   }
  }
}

ra_rotate_waw_trap()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";
//------------------------------------------------------//
  trigger = getent("actv", "targetname");
  trigger waittill ("trigger",user);
  wait 2;
  thread wow_trap_kill();
  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
    self rotatePitch(-3684,10,2,4);
	self waittill("rotatedone");
}

wow_trap_kill()
{
	trigger1 = getent ("r_nr1","targetname");
	trigger2 = getent ("r_nr2","targetname");

  origin_spin = getent ("origin_spin_end", "targetname");

  trigger1 enablelinkto();
  trigger2 enablelinkto();

  trigger1 linkto( origin_spin );
  trigger2 linkto( origin_spin );
  origin_spin rotatePitch(-3684,10,2,4);
  self waittill("rotatedone");
}

showLogo()
{
	if( isDefined( self.logoText ) )
		self.logoText destroy();

	self.logoText = newHudElem();
	//self.logoText.x = 200;
	self.logoText.y = 10;
		self.logoText.alignX = "center";
		self.logoText.alignY = "middle";
		self.logoText.horzAlign = "center_safearea";
		//self.logoText.vertAlign = "top";
	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.4;
	self.logoText.archieved = true;

	for(;;)
	{
		wait 6;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5Deathrun: ^7Factory");
		wait 5;
		wait 1 /* 20 */ ;
		self.logoText setText("By: [^1aL^7]^5willeponken");
		wait 5;
		self.logoText setText("^4Xfire: ^5thewilleponken");
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		wait 4;
		self.logoText setText("^1Credits:");
		wait 2;
		self.logoText setText("^5junkman, RedY, Brax and [aL]STEALTH");
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		wait 6;
		self.logoText setText("^3Play fair and have fun!");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
	}
}

// init( "vehicle_cobra_helicopter_fly" );
// todo: fx, sounds, weapon

init( name )
{
	precacheitem( "cobra_FFAR_mp" );
	precacheitem( "hind_FFAR_mp" );
	precacheitem( "cobra_20mm_mp" );

	//precacheHelicopter( name );

	level.chopper[name]["mdl"]["projectile"] = "projectile_hellfire_missile";
	level.chopper[name]["mdl"]["chopper"] = "vehicle_cobra_helicopter_fly";

	precacheModel( level.chopper[name]["mdl"]["projectile"] );
	precacheModel( level.chopper[name]["mdl"]["chopper"] );

	level.chopper[name]["fx"]["death"] = loadfx ("explosions/helicopter_explosion_cobra");
	level.chopper[name]["fx"]["large"] = loadfx ("explosions/aerial_explosion_large");
	level.chopper[name]["fx"]["medium"] = loadfx ("explosions/aerial_explosion");
	level.chopper[name]["fx"]["trail"] = loadfx ("smoke/smoke_trail_white_heli");
	level.chopper[name]["fx"]["trail"]["medium"] = loadfx ("smoke/smoke_trail_black_heli");
	level.chopper[name]["fx"]["trail"]["large"] = loadfx ("fire/fire_smoke_trail_L");
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	//chopper.attractor = Missile_CreateAttractorEnt( chopper, level.heli_attract_strength, level.heli_attract_range );
	return chopper;
}


test()
{
	chopper = spawn_helicopter( self, self.origin, self.angles, "cobra_mp", "vehicle_cobra_helicopter_fly" );
	chopper playLoopSound( "mp_cobra_helicopter" );

	//chopper.team = self.pers["team"];
	//chopper.pers["team"] = self.pers["team"];

	chopper.owner = undefined;

	chopper.maxhealth = 2000;
	chopper.health = chopper.maxhealth;

	heli_speed = 10+randomInt(20);
	heli_accel = 8+randomInt(15);
//	chopper MakeVehicleUsable();
	chopper setDamageStage( 3 ); // good, light damage, heavy damage
	chopper setSpeed( heli_speed, heli_accel );
	chopper setVehGoalPos( (0,0,0), true );

	chopper waittill( "goal" );
	chopper notify( "path start" );
//	chopper setspeed( 5, 5 );

	chopper setGoalYaw( 100 );
	chopper waittillmatch( "goal" );
	chopper heli_reset();
}

heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 60, 25 );
	self setyawspeed( 75, 45, 45 );
	//self setjitterparams( (30, 30, 30), 4, 6 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.9);
}

begin_door_open()
{
  trigger = getent("use_begin_door", "targetname");
  trigger waittill ("trigger",user);
  spin_door = getent ("spin_begin_door", "targetname");
  spin_door rotateyaw(87,1,0.2,0.3);
  spin_door waittill("rotatedone");
}

//Sniper Duell AKA Heaven

glow()
{
 glow_bridge = getent ("glow_bridge","targetname");
 glow_small_island = getent ("glow_small_island","targetname");

 level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );

 maps\mp\_fx::loopfx("beacon_glow", (glow_bridge.origin), 3, (glow_bridge.origin) + (0, 0, 90));
 maps\mp\_fx::loopfx("beacon_glow", (glow_small_island.origin), 3, (glow_small_island.origin) + (0, 0, 90));
}

cabinelift()
{
//getent - target
so1 = getent ("so1","targetname");
so2 = getent ("so2","targetname");
so3 = getent ("so3","targetname");
so4 = getent ("so4","targetname");
so5 = getent ("so5","targetname");
so6 = getent ("so6","targetname");
so7 = getent ("so7","targetname");
so8 = getent ("so8","targetname");
so9 = getent ("so9","targetname");
so10 = getent ("so10","targetname");
so11 = getent ("so11","targetname");
so12 = getent ("so12","targetname");
so13 = getent ("so13","targetname");
so14 = getent ("so14","targetname");
so15 = getent ("so15","targetname");
so16 = getent ("so16","targetname");
so17 = getent ("so17","targetname");
so18 = getent ("so18","targetname");
so19 = getent ("so19","targetname");

//getent - liftframe
lift_frame = getent ("lift_frame","targetname");

//moveto - everything
while (1)
	{

lift_frame moveto (so1.origin, 2, 0, 0);

wait 10;

lift_frame moveto (so2.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so3.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so4.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so5.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so6.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so7.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so8.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so9.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so10.origin, 1.5, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so11.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so12.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so13.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so14.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so15.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so16.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so17.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so18.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so19.origin, 2, 0, 0);

wait 10;

lift_frame moveto (so18.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so17.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so16.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so15.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so14.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so13.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so12.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so11.origin, 1, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so10.origin, 1.5, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so9.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so8.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so7.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so6.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so5.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so4.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so3.origin, 2, 0, 0);
lift_frame waittill ("movedone");
lift_frame moveto (so2.origin, 2, 0, 0);
lift_frame waittill ("movedone");
	}
}

fog()

{
weather = getent("so7","targetname");
weather1 = getent("wind1","targetname");
weather2 = getent("wind2","targetname");
level._effect[ "weather" ] = loadfx( "weather/big_cloud_bank" );
maps\mp\_fx::loopfx("weather", (weather.origin), 3, (weather.origin) + (0, 0, 90));
maps\mp\_fx::loopfx("weather", (weather1.origin), 3, (weather1.origin) + (0, 0, 90));
maps\mp\_fx::loopfx("weather", (weather2.origin), 3, (weather2.origin) + (0, 0, 90));
}

//teleport


port()
{
	if( GetTeamPlayersAlive("allies") == 1)
	{

		thread cabinelift();

		iprintlnbold("^2SNIPER ^7DUEL!");
		wait 2;
		iprintlnbold("^1EPIC HEAVEN FIGHT^7!");
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( isAlive(players[i]) && players[i].pers["team"] != "spectator" )
			{
				if( players[i].pers["team"] == "allies" )
				{
					players[i] SetPlayerAngles(( players[i].angles[0],0, players[i].angles[2] ));
					players[i] SetOrigin((1144, -5208, 8));

					players[i] TakeAllWeapons();
					players[i] GiveWeapon("dragunov_mp");
					wait 0.01;
					players[i] SwitchToWeapon("dragunov_mp");

				}
				if( players[i].pers["team"] == "axis" )
				{
					players[i] SetPlayerAngles( players[i].angles[0], 0, players[i].angles[2] );
					players[i] SetOrigin((1659.5, -7548, -1913.5));

					players[i] TakeAllWeapons();
					players[i] GiveWeapon("remington700_mp");
					wait 0.01;
					players[i] SwitchToWeapon("remington700_mp");

				}
			}
		}
		return;
	}
}