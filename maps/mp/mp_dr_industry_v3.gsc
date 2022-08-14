main()
{
	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	setdvar("bg_fallDamageMaxHeight","99999");
	setdvar("bg_fallDamageMinHeight","99998");

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_map::createSpawn((-257,143,76),90);
thread sr\api\_speedrun::createTeleporter((3256.86, 4029.11, -191.875), 55, 50, (4325, 4038, 380), 180, "freeze", "yellow");

	thread onroundstart();
	thread stair_plats();
	thread ele_plat();
	thread teleports();
	thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	//thread trap11();
	//thread trap12();

	for(i=1;i<13;i++)
		addTriggerToList("trap"+i+"trig");
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

onroundstart()
{
	startdoors = getentarray("startdoors","targetname");

	startdoors[0] delete();
	startdoors[1] delete();
}

stair_plats()
{
	plats = getEntarray("plats","targetname");
	trig = getent("plat_trig","targetname");
	dist = 16;
	
	wait 0.1;

	for(i=0;i<plats.size;i++)
		plats[i] movez(dist*(i+1),1);
}

ele_plat()
{
	plat = getent("ele_plat","targetname");
	
	plat movez(512,0.1);
	
}

teleports()
{       
 	entTransporter = getentarray( "telepor_trig", "targetname" );

	for( i = 0; i < entTransporter.size; i++ )
		entTransporter[i] thread transporter();
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

trap1()
{
	flame_org = getentarray("flame_org_trap1","targetname");
	trig = getEnt("trap1trig","targetname");
	dmg_trig = getEnt("trap1_dmgtrig","targetname");

	dmg_trig delete();
}

trap2()
{
	trig = getEnt("trap2trig","targetname");
	plats = getentarray("trap2plats","targetname");
	trig waittill("trigger",player);
	trig delete();

	for(i=0;i<plats.size;i++)
		plats[i] thread trap2moves();
}

trap2moves()
{
	x = randomint(3);
	for(;;)
	{
		self movey(-384,2);
		wait (x+1);
		self movey(384,2);
		wait (x+1);
	}
}

trap3()
{
	trig = getent("trap3trig","targetname");
	obj = getEnt("trap3obj","targetname");
	trig waittill("trigger",player);
	trig delete();

	obj hide();
	obj notsolid();
	wait randomint(5)+1;
	obj show();
	obj solid();
}

trap4()
{
	trig = getent("trap4trig","targetname");
	obj = getent("trap4bounce","targetname");

	trig waittill("trigger",player);
	trig delete();

	obj movex(-336,1);
	wait 3;
	obj movex(336,1);
}

trap5()
{
	trig = getent("trap5trig","targetname");
	obj = getentarray("pillars_trap5","targetname");

	trig waittill("trigger",player);
	trig delete();

	for(;;)
	{
		ang = randomintrange(-180,180);
		obj[0] rotateyaw(ang,1);
		obj[1] rotateyaw(ang-(ang*2),1);
		wait 3;
	}
}

trap6()
{
	trig = getent("trap6trig","targetname");
	obj_group1 = getentarray("pillars_trap6g1","targetname");
	obj_group2 = getentarray("pillars_trap6g2","targetname");

	trig waittill("trigger",player);
	trig delete();

	for(;;)
	{
		for(i=0;i<obj_group1.size;i++)
		{
			obj_group1[i] rotateyaw(-180,2);
			obj_group2[i] rotateyaw(180,2);
		}

		wait 4;

		for(i=0;i<obj_group1.size;i++)
		{
			obj_group1[i] rotateyaw(180,2);
			obj_group2[i] rotateyaw(-180,2);
		}

		wait 4;
	}
}

trap7()
{
	trig = getent("trap7trig","targetname");
	plats = getentarray("trap7plats","targetname");

	trig waittill("trigger",player);
	trig delete();

	for(i=0;i<plats.size;i++)
		plats[i] thread trap7action();
}

trap7action()
{
	for(;;)
	{
		ang = randomintrange(90,360);
		self rotateyaw(ang,1.5);
		wait 3;
	}
}

trap8()
{
	trig = getent("trap8trig","targetname");
	plat = getent("trap8plat","targetname");

	dmgtrig = getent("trap8plat_dmgtrig","targetname");
	dmgtrig enablelinkto();
	dmgtrig linkto(plat);

	trig waittill("trigger",player);
	trig delete();

	plat movez(144,0.5);
	wait 3;
	plat movez(-144,0.5);
}

trap9()
{
	trig = getent("trap9trig","targetname");
	plats = getentarray("trap9plats","targetname");

	trig waittill("trigger",player);
	trig delete();

	plats[0] movey(176,0.5);
	plats[1] movex(112,0.5);
	plats[2] movey(128,0.5);

	plats[0] waittill("movedone");

	for(;;)
	{
		plats[0] movey(-352,1);
		plats[1] movex(-224,1);
		plats[2] movey(-256,1);
		wait 1.5;
		plats[0] movey(352,1);
		plats[1] movex(224,1);
		plats[2] movey(256,1);
		wait 1.5;
	}
}

trap10()
{
	trig = getent("trap10trig","targetname");
	plats = getentarray("trap10plats","targetname");

	trig waittill("trigger",player);
	trig delete();

	for(;;)
	{
		ang = randomintrange(180,360);
		for(i=0;i<plats.size;i++)
			plats[i] rotateyaw(ang,1);

		wait 2.5;
	}
}

trap11()
{
	trig = getent("trap11trig","targetname");
	plat = getEnt("trap11plat","targetname");

	trig waittill("trigger",player);
	trig delete();

	plat hide();
	plat notsolid();

	wait randomintrange(1,4);

	plat show();
	plat solid();
}

trap12()
{
	trig = getent("trap12trig","targetname");
	plat = getEnt("trap12plat","targetname");
	killtrig = getEnt("trap12killtrig","targetname");
	plat notsolid();

	killtrig enablelinkto();
	killtrig linkto(plat);

	trig waittill("trigger",player);
	trig delete();

	plat movey(432,1);
	wait 4;
	plat movey(-432,1);
}
