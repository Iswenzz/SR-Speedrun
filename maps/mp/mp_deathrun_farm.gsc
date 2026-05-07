//map made by Mieep_Mieep_v4
//contact xfire: Mieep_Mieep_v4=wespatrick
//mapname:mp_deathrun_farm

main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	//thread inittraps();
	//thread addtrapstofreerun();
	thread mover();

	thread sr\api\_map::createSpawn((2,-175, 68), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((2612.84, -2072.36, 8.125), 70,115, "normal_0");   
	}
addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
addtrapstofreerun()
{
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap5_trig");
}
inittraps()
{
//define level variables for the functions

//mover & trap 4
level.mover = getent("mover","targetname");
level.trap4_trig = getent("trap4_trig","targetname");

//trap 1
	level.trap1 = getent("trap1","targetname");
	level.trap1_2 = getent("trap1_2","targetname");
	level.trap1_trig = getent("trap1_trig","targetname");
//trap 2
	level.trap2 = getent("trap2","targetname");
	level.trap2_2 = getent("kill_trig_trap2","targetname");
	level.trap2_trig = getent("trap2_trig","targetname");

//trap 3
	level.trap3 = getent("trap3","targetname");
	level.trap3_trig = getent("trap3_trig","targetname");
	
//trap 5
	level.trap5 = getent("spiese","targetname");
	level.trap5_2 = getent("spiese_kill","targetname");
	level.trap5_trig = getent("trap5_trig","targetname");

//calling threads to start them
	thread mover();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
}
mover()
{
mover = getent("mover","targetname");

mover movex(150,0.1);

}

trap1()
{
level.trap1_trig waittill("trigger");
level.trap1_trig delete();
level.trap1_2 movex(-300,2);
level.trap1 movex(300,2);
wait 3;
level.trap1_2 movex(300,2);
level.trap1 movex(-300,2);
}


trap2()
{
level.trap2_trig waittill("trigger");
level.trap2_trig delete();
level.trap2_2 enablelinkto();
level.trap2_2 linkto(level.trap2);
level.trap2 movex(-608,1);
wait 2;
level.trap2 movex(608,3);
}

trap3()
{
level.trap3_trig waittill("trigger");
level.trap3_trig delete();
for( i = 0; i < 4; i++ )
	{
		level.trap3 rotatePitch( 180, 2 );
		wait 2;
	}
}

trap4()
{
level.trap4_trig waittill("trigger");
level.trap4_trig delete();
level.mover notsolid();
level.mover movez(-500,3);
wait 4;
level.mover solid();
level.mover movez(500,3);
}
trap5()
{
level.trap5_trig waittill("trigger");
level.trap5_trig delete();
level.trap5_2 enablelinkto();
level.trap5_2 linkto(level.trap5);
level.trap5 movez(160,1);
wait 2;
level.trap5 movez(-160,1);
}