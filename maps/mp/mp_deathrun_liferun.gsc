// Scripted by iNext.Mieep_v4
// Clear script! and optimized for cod4 deathrun with free run functions.
// Do not Change anything please if you want to change ask me before! xfire:wespatrick
main()
{

	//Cod4 Stuff
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	//Custom Stuff
	
	//Define Triggers
	level.trigger1 = getEnt("t1","targetname");//Trap 1 Remove brush
	level.trigger2 = getEnt("t2","targetname");//Trap 2 Remove brush
	level.trigger3 = getEnt("t3","targetname");//Trap 3 Rotator brush
	level.trigger4 = getEnt("t4","targetname");//Trap 4 brush from top to down
	level.trigger5 = getEnt("t5","targetname");//Trap 5 Spinning trap
	level.trigger6 = getEnt("t6","targetname");//Trap 6 little going down trap
	level.trigger7 = getEnt("t7","targetname");//Trap 7 Going down brush at end
	
	//Adding Triggers to Freerun
	attl("t1");
	attl("t2");
	attl("t3");
	attl("t4");
	attl("t5");
	attl("t6");
	attl("t7");
	
	//Set Hintstring to right one
	level.trigger1 sethintstring("Press [USE] to activate Trap");
	level.trigger2 sethintstring("Press [USE] to activate Trap");
	level.trigger3 sethintstring("Press [USE] to activate Trap");
	level.trigger4 sethintstring("Press [USE] to activate Trap");
	level.trigger5 sethintstring("Press [USE] to activate Trap");
	level.trigger6 sethintstring("Press [USE] to activate Trap");
	level.trigger7 sethintstring("Press [USE] to activate Trap");
	
	//Define Traps
	
	//Trap 1 Remove brush
	level.trap1 = getEnt("trap_remove_1","targetname");
	
	//Trap 2 Remove brush
	level.trap2 = getEnt("trap_remove_2","targetname");
	
	//Trap 3 Rotator brush
	level.trap3 = getEnt("rotator","targetname");
		
	//Trap 4 brush from top to down
	level.trap4 = getEnt("trap_4","targetname");
	level.trap4_2 = getEnt("trap4_hurt","targetname");
	
	//Trap 5 Spinning trap
	level.trap5 = getEnt("dreh_1","targetname");
	
	//Trap 6 little going down trap
	level.trap6 = getEnt("trap_7","targetname");
	
	//Trap 7 Going down brush at end
	level.trap7 = getEnt("trap_goingdown","targetname");

	//Define Others
	
	//First Mover
	level.mover_1 = getEnt("mover_1","targetname");
	
	//Starting Door
	level.startdoor_trig = getEnt("startingdoor_trig","targetname");
	level.startdoor = getEnt("startingdoor","targetname");
	
	//Ending Door
	level.enddoor_trig = getEnt("enddoor_trig","targetname");
	level.enddoor = getEnt("enddoor","targetname");
	level.enddoor2 = getEnt("enddoor_nodraw","targetname");

	thread way_connect();
	
	//Call functions
	thread startdoors();
	thread mover1();
	thread enddoor();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

startdoors()
{
level.startdoor_trig waittill("trigger");
level.startdoor_trig delete();
level.startdoor movez(-152,3);
level.startdoor waittill("movedone");
level.startdoor delete();
//ambientplay("liferun_ambient");
}
trap1()
{
trig = level.trigger1;
ent = level.trap1;

trig waittill("trigger");
trig delete();
ent movez(-480,1);
ent waittill("movedone");
ent movez(-8,2);
//Waiting for Free(against noob activators)
level waittill("traps_disabled");
ent movez(488,0.1);
}

trap2()
{
trig = level.trigger2;
ent = level.trap2;

trig waittill("trigger");
trig delete();
ent movez(-480,1);
ent waittill("movedone");
ent movez(-8,2);
//Waiting for Free(against noob activators)
level waittill("traps_disabled");
ent movez(488,0.1);
}

trap3()
{
trig = level.trigger3;
ent = level.trap3;

trig waittill("trigger");
trig delete();
while(1)
{
ent movez(-112,1);
ent waittill("movedone");
ent movez(112,1);
ent waittill("movedone");
}
}

trap4()
{
trig = level.trigger4;
ent = level.trap4;
ent2 = level.trap4_2;

trig waittill("trigger");
trig delete();
ent2 enablelinkto();
ent2 linkto(ent);
ent movez(-192,1);
ent waittill("movedone");
ent movez(192,1);
}

trap5()
{
trig = level.trigger5;
ent = level.trap5;

trig waittill("trigger");
trig delete();
while(1)
	{
	ent rotateyaw(360,5);
	ent waittill("rotatedone");
	}
}

trap6()
{
trig = level.trigger6;
ent = level.trap6;

trig waittill("trigger");
trig delete();
ent movez(-1000,10);
ent waittill("movedone");
ent movez(1000,10);
}

trap7()
{
trig = level.trigger7;
ent = level.trap7;

trig waittill("trigger");
trig delete();
ent movez(-1000,10);
ent waittill("movedone");
ent movez(1000,10);
}

mover1()
{
while(1)
{
level.mover_1 movez(168,2);
level.mover_1 waittill("movedone");
wait 2;
level.mover_1 movez(-168,2);
level.mover_1 waittill("movedone");
wait 2;
}
}

enddoor()
{
level.enddoor_trig waittill("trigger",user);
level.enddoor_trig delete();
iprintlnbold("^1>>^2GRATZ ^3" + user.name +" ^2finished ^1Liferun ^3at first!!!^1<<");
level.enddoor movez(-129,4);
level.enddoor waittill("movedone");
level.enddoor delete();
wait 1;
level.enddoor2 delete();
}


//Deathrun Stuff not by me!
attl( name )//old name:AddTriggerToList
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}