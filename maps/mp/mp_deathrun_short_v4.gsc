main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	//Trap 1
	level.trap1_trig = getEnt( "t1", "targetname" );
	level.trap1 = getEnt("trap1", "targetname" );
	level.trap1_2 = getEnt("trap1_2", "targetname" );
	//Trap 2
	level.trap2_trig = getEnt( "t2", "targetname" );
	level.trap2 = getEnt("trap2", "targetname" );
	//Trap3

	level.trap3 = getEnt("trap3", "targetname" );
	level.trap3_trig = getEnt("t3", "targetname" );
	level.door = getEnt("end_door","targetname");
	level.doortrig = getEnt("end_door_trig","targetname");

	//Trap 4
	level.trap4 = getEnt("falle5","targetname");
	level.trap4_trig = getEnt("t4", "targetname" );
	addTriggerToList( "level.trap4_trig" );

	//kill Trap
	level.trap5 = getEnt("kill_trig","targetname");
	level.trap5_2 = getEnt("kill_trig2","targetname");
	level.trap5_trig = getEnt("t5", "targetname" );

	//Trap 6
	level.trap6_1 = getEnt("platte","targetname");
	level.trap6_trig = getEnt("t6", "targetname" );
	//mover
	level.mover1 = getEnt( "mover1","targetname" );
	//Trap 7
	level.trap7_1 = getEnt("trap_down","targetname");
	level.trap7_2 = getEnt("trap_down_kill","targetname");
	level.trap7_trig = getEnt("t7","targetname");
	//doors
	level.startdoors = getEnt("doors","targetname");
	level.startdoors_trig = getEnt("trig_doors","targetname");
	//Deactivate trap
	level.deactivater = getEnt("deactivate_trap_drill","targetname");
	//Firebells
	level.trap1_druck = getEnt("d1","targetname");
	level.trap2_druck = getEnt("d2","targetname");
	level.trap3_druck = getEnt("d3","targetname");
	level.trap4_druck = getEnt("d4","targetname");
	level.trap5_druck = getEnt("d5","targetname");
	level.trap6_druck = getEnt("d6","targetname");
	level.trap7_druck = getEnt("d7","targetname");
	
	entTransporter = getentarray("tp","targetname");
  	if(isdefined(entTransporter))
 	 {
  	 for(lp=0;lp<entTransporter.size;lp=lp+1)
     	 entTransporter[lp] thread Transporter();
  	 }
	//Init
	thread startdoors();
	//thread trap1();
	//thread mover();
	//thread mover2();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	thread enddoor();
	//thread mapperinfo();
	//ambientplay("short_end");
	//adding traps to no traps mode
	//thread addtrapstofreerun();

	thread sr\api\_map::createSpawn((-668, -324, 28), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-40.875, -655.857, 72.125), 50,170, "normal_0");  

	thread custom_tp();
}

Transporter()
{
  while(true)
  {
    self waittill("trigger",other);
    entTarget = getent(self.target, "targetname");

    wait(0.10);
    other setorigin(entTarget.origin);
    other setplayerangles(entTarget.angles);
    //other iprintlnbold ("You have been teleported !!!");
    wait(0.10);
  }
}

custom_tp()
{
	trig = spawn("trigger_radius",(117.977, 415.624, -31.875), 0, 70, 110);
	trig.radius = 70;
	
	ori_t = spawn("script_origin",(168,-440,28));
	ori_t.angles = (0,179,0);

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

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
addtrapstofreerun()
{
	addTriggerToList("t1");
	addTriggerToList("t2");
	addTriggerToList("t3");
	addTriggerToList("t4");
	addTriggerToList("t5");
	addTriggerToList("t6");
	addTriggerToList("t7");
}
startdoors()
{
level.startdoors_trig delete();
level.startdoors delete();
}
trap1()
{
level.trap1_trig waittill("trigger");
level.trap1_trig delete();
level.trap1_2 delete();
level.trap1 delete();
level.trap1_druck movez(-2,1);
}
trap7()
{
level.trap7_2 enablelinkto();
level.trap7_2 linkto(level.trap7_1);
level.trap7_trig waittill("trigger");
level.trap7_trig delete();
level.trap7_druck movez(-2,1);
level.trap7_1 movez(-268,1);
level.trap7_1 waittill("movedone");
level.trap7_1 movez(268,1);
level.trap7_1 waittill("movedone");
level.trap7_1 delete();
level.trap7_2 delete();
}
mover()
{
	while(1)
	{
		level.mover1 movey(-472, 2);
		level.mover1 waittill ("movedone");
		wait 1;
		level.mover1 movey(472, 2);
		level.mover1 waittill ("movedone");
		wait 1;
	}
}

trap2()
{
	level.trap2_trig waittill("trigger");
	level.trap2_trig delete();
	level.trap2_druck movez(-2,1);
	level.trap2 movex(-150,1);
	wait 3;
	level.trap2 movex(150,1);
}
mover2()
{
	while(1)
	{
		level.trap3 movez(160,2);
		level.trap3 waittill ("movedone");
		wait 2;
		level.trap3 movez(-160,2);
		level.trap3 waittill ("movedone");
		wait 2;
	}
}
mapperinfo()
{
while(1)
{
iprintln("^1Final Version of Short");
iprintln("^2map by ^1iNext._Mieep_v4^2 !!!");
wait 40;
}
}
trap3()
{	
	level.trap3_trig waittill("trigger");
	level.trap3_trig delete();
	level.trap3_druck movez(-2,1);
	while(1)
	{
	level.trap3 rotateyaw(1500,1);
	wait 1;
	}
}
trap4()
{
level.trap4_trig waittill("trigger");
level.trap4_trig delete();
level.trap4_druck movez(-2,1);
level.trap4 movez(-5000,1);
level.trap4 waittill("movedone");
wait 2;
level.trap4 movez(5000,1);
}
trap5()
{
level.trap5_2 enablelinkto();
level.trap5_2 linkto(level.trap5);
level.trap5_trig waittill("trigger");
level.trap5_trig delete();
level.trap5 movex(-358,3);
level.trap5 waittill("movedone");
level.trap5 movex(358,12);
level.trap5 waittill("movedone");
level.trap5_druck movez(-2,1);
}
trap6()
{
level.trap6_trig waittill("trigger");
level.trap6_trig delete();
level.trap6_druck movez(-2,1);
level.trap6_1 delete();
}
enddoor()
{
	level.door delete();
}