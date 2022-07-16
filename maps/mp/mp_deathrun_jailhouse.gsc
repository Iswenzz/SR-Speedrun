// Scripted by iNext.Mieep_v4
// Clear script! and optimized for cod4 deathrun with free run functions.
// Do not Change anything please if you want to change ask me before! xfire:wespatrick
main()
{
level.masterSpawn = spawn("script_origin", level.spawn["allies"][0].origin - (0,49,0));
level.masterSpawn.angles = (0,180,0);
trigger = spawn( "trigger_radius", (-4908.72, 447.658, 218.524), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.inAir = true;
trigger.radius = 96;
	//Cod4 Stuff
	thread way_connect();
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	//Custom Scripts

	// Call functions
	thread defineentities();
	thread startingdoor();
	// thread hintstrings();
	thread mover1();
	thread mover2();
	thread endingdoor();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	thread trap6();
	// thread trap7();
	// thread trap8();
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

defineentities()
{
	//Define Triggers
	
	level.trigger1 = getent("t1","targetname");// Trap 1 Remove 2 brushes
	level.trigger2 = getent("t2","targetname");// Trap 2 Remove 2 brushes
	level.trigger3 = getent("t3","targetname");// Trap 3 Remove Ground + oil
	level.trigger4 = getent("t4","targetname");// Trap 4 Kill Triggers from top and ground
	level.trigger5 = getent("t5","targetname");// Trap 5 Kill Triggers from top and ground
	level.trigger6 = getent("t6","targetname");// Trap 6 Pushers
	level.trigger7 = getent("t7","targetname");// Trap 7 Rolls
	level.trigger8 = getent("t8","targetname");// Trap 8 Kill Triggers from top and ground
	
	
	
	//Define Traps
	
	// Trap 1
	level.trap1_1 = getEntArray("trap1_1","targetname");
	level.trap1_2 = getEntArray("trap1_2","targetname");
	
	// Trap 2
	level.trap2_1 = getEntArray("trap2_1","targetname");
	level.trap2_2 = getEntArray("trap2_2","targetname");
	
	// Trap 3
	level.trap3 = getent("trap3","targetname");
	level.trap3_oil = getent("trap3_oil","targetname");
	
	// Trap 4
	level.trap4 = getent("trap4","targetname");
	level.trap4_kill = getent("trap4_kill","targetname");
	level.trap4_2 = getent("trap4_2","targetname");
	level.trap4_2_kill = getent("trap4_2_kill","targetname");
	
	// Trap 5
	level.trap5 = getent("trap5","targetname");
	level.trap5_2 = getent("trap5_2","targetname");
	level.trap5_kill = getent("trap5_kill","targetname");
	level.trap5_2_kill = getent("trap5_2_kill","targetname");
	
	// Trap 6
	level.trap6 = getent("trap6_1","targetname");
	level.trap6_1 = getent("trap6_2","targetname");
	
	// Trap 7
	level.trap7_1 = getent("trap7_1","targetname");
	level.trap7_2 = getent("trap7_2","targetname");
	
	// Trap 8
	level.trap8 = getent("trap8","targetname");
	level.trap8_kill = getent("trap8_kill","targetname");
	level.trap8_2 = getent("trap8_2","targetname");
	level.trap8_2_kill = getent("trap8_2_kill","targetname");
	
	// Define Others
	
	// Startingdoor
	level.startdoor = getent("door_start","targetname");//Door
	level.startdoor_trig = getent ("tstart","targetname");//Trigger_Door
	
	// Endingdoor
	level.endingdoor = getent("endingdoor","targetname"); //Enddoor
	level.endingdoor_trig = getent("tend","targetname"); //Trigger_Enddoor
	
	// Mover 1
	level.mover1 = getent("mover","targetname");
	level.mover_blood = getent("mover_blood","targetname");
	
	// Mover 2
	level.mover2 = getent("mover2","targetname");
	

}
hintstrings()
{
trig[1] = level.trigger1;
trig[2] = level.trigger2;
trig[3] = level.trigger3;
trig[4] = level.trigger4;
trig[5] = level.trigger5;
trig[6] = level.trigger6;
trig[7] = level.trigger7;
trig[8] = level.trigger8;
trig[9] = level.trigger8;
for( i = 1; i < trig.size; i++ )
	{
	trig[i] sethintstring("Press [USE] to Activate");
	trig[i] SetCursorHint("HINT_ACTIVATE");
	attl(trig[i].targetname);
	}
}
// Define Functions

// Traps Functions

trap1()
{
ent = level.trap1_1;
ent2 = level.trap1_2;
trig = level.trigger1;
trig waittill("trigger");
trig delete();
ent[randomInt(ent.size)] notsolid();
ent2[randomInt(ent2.size)] notsolid();
level waittill("traps_disabled");
wait 1;
ent[randomInt(ent.size)] solid();
ent2[randomInt(ent2.size)] solid();
}

trap2()
{
ent = level.trap2_1;
ent2 = level.trap2_2;
trig = level.trigger2;
trig waittill("trigger");
trig delete();
ent[randomInt(ent.size)] notsolid();
ent2[randomInt(ent2.size)] notsolid();
level waittill("traps_disabled");
wait 1;
ent[randomInt(ent.size)] solid();
ent2[randomInt(ent2.size)] solid();
}

trap3()
{
ent = level.trap3;
ent1 = level.trap3_oil;
trig = level.trigger3;
trig waittill("trigger");
trig delete();
ent hide();
ent notsolid ();
ent1 hide();
ent1 notsolid();

}

trap4()
{
ent_1 = level.trap4;
ent_1_2 = level.trap4_kill;
ent_2 = level.trap4_2;
ent_2_2 = level.trap4_2_kill;
trig = level.trigger4;
ent_1_2 enablelinkto();
ent_2_2 enablelinkto();
ent_1_2 linkto(ent_1);
ent_2_2 linkto(ent_2);
trig waittill("trigger");
trig delete();
ent_1 movez(-250,1);
ent_2 movez(234,1);
wait 2;
ent_2 movez(-234,1);
ent_1 movez(250,1);
}

trap5()
{
ent_1 = level.trap5;
ent_1_2 = level.trap5_kill;
ent_2 = level.trap5_2;
ent_2_2 = level.trap5_2_kill;
trig = level.trigger5;
ent_1_2 enablelinkto();
ent_2_2 enablelinkto();
ent_1_2 linkto(ent_1);
ent_2_2 linkto(ent_2);
trig waittill("trigger");
trig delete();
ent_1 movez(-250,1);
ent_2 movez(234,1);
wait 2;
ent_2 movez(-234,1);
ent_1 movez(250,1);
}

trap6()
{
ent_1 = level.trap6;
ent_2 = level.trap6_1;
trig = level.trigger6;

trig delete();
	ent_1 rotateroll (30 ,0.4);
	ent_2 rotateroll (-30 ,0.4);

}

trap7()
{
ent = level.trap7_1;
ent2 = level.trap7_2;
trig = level.trigger7;
trig waittill("trigger");
trig delete();
ent rotateroll (3600 ,10);
ent2 rotateroll (3600 ,10);
ent2 waittill("rotatedone");
wait randomInt(10);
ent rotateroll (3600 ,10);
ent2 rotateroll (3600 ,10);
ent2 waittill("rotatedone");
wait randomInt(10);
ent rotateroll (3600 ,10);
ent2 rotateroll (3600 ,10);
ent2 waittill("rotatedone");
wait randomInt(10);
ent rotateroll (3600 ,10);
ent2 rotateroll (3600 ,10);
}

trap8()
{
ent_1 = level.trap8;
ent_1_2 = level.trap8_kill;
ent_2 = level.trap8_2;
ent_2_2 = level.trap8_2_kill;
trig = level.trigger8;
ent_1_2 enablelinkto();
ent_2_2 enablelinkto();
ent_1_2 linkto(ent_1);
ent_2_2 linkto(ent_2);
trig waittill("trigger");
trig delete();
ent_1 movez(-250,1);
ent_2 movez(250,1);
wait 2;
ent_2 movez(-250,1);
ent_1 movez(250,1);
}

mover1()
{
ent = level.mover1;
ent2 = level.mover_blood;
ent2 linkto(ent);
while(1)
{
ent movex(-400,2);
ent waittill("movedone");
wait 1;
ent movex(400,2);
ent waittill("movedone");
wait 1;
}
}

mover2()
{
ent = level.mover2;
while(1)
{
ent movex(-350,2);
ent waittill("movedone");
wait 1;
ent movex(350,2);
ent waittill("movedone");
wait 1;
}
}

startingdoor()
{
ent = level.startdoor;
trig = level.startdoor_trig;
// trig waittill("trigger", user);
wait 1;
ent movez(192,1);
ent waittill("movedone");
ent delete();
}

endingdoor()
{
ent = level.endingdoor;
trig = level.endingdoor_trig;
wait 1;
// trig waittill("trigger",user);
// iprintlnbold("^6The whole ^4of the Lion is ^9opened. ");
// iprintlnbold("Will ^1" + user.name + " ^2kill the ^3Lion???");
ent movex(-108,1);
ent waittill ("movedone");
ent delete();
}

attl( name )//old name:AddTriggerToList
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
Secrets()
{
	entTransporter = getentarray("tp","targetname");
  	if(isdefined(entTransporter))
 	 {
  	 for(lp=0;lp<entTransporter.size;lp=lp+1)
     	 entTransporter[lp] thread Transporter();
  	 }

}

Transporter()
{
  while(1)
  {
    self waittill("trigger",other);
    entTarget = getent(self.target, "targetname");
	other.tempguid = other getguid();
	if ((other.tempguid == "dc907ae71f12491c4f77f25e378cac70") || (other.tempguid == "0e9ba693de5cbd4737562cdff807bff2"))
		{
    wait(0.10);
    other setorigin(entTarget.origin);
    other setplayerangles(entTarget.angles);
    iprintlnbold ("The Secret has been found !!! ");
	iprintln("Tip: Be careful and watch behind you!!!");
	}
	else{
    wait(0.10);
	}
  }
}	