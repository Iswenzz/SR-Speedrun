main()
{
    maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");	
    setdvar("compassmaxrange","1400");
    setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((1781, -1233, -538), 180);
	thread sr\api\_speedrun::createTeleporter((1783.92, -1053.83, -597.875), 60, 100, (-1156, 803, -279), 180, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((538.004, 460.202, -591.875), 200, 100);

	thread firstdoor();
	thread lift();
	thread lifttp();
	thread salle2();
	thread secretezfail();
	thread ezfinish();
	thread mp1();
	thread mp2();
	thread fix((-2010.62, 282.67, -625.765));
	
}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 130, 345);
	trigger.targetname = "fix";
	trigger.radius = 130;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

firstdoor()
{
   trigger1 = getEnt( "trigger1", "targetname" );
   move_door = getent("move_door","targetname");
   brush = getentArray("brushrotate","targetname");
  
    move_door delete();
	brush[0] rotateYaw(90,0.1);
		
	
}


lift()
{
	movingbrush = getEnt("movingbrush","targetname");
	trigger2 = getEnt("trigger2","targetname");
	

    movingbrush MoveX( -365,0.1);
	movingbrush waittill ("movedone");
	movingbrush rotateYaw(90,0.1);
	trigger2 delete();
  
}


lifttp()
{
	plattrig1 = getEnt("plattrig1","targetname");
	plattrig_tp = getEnt("plattrig_tp","targetname");
	
    for(;;)
	{
		plattrig1 waittill("trigger", player);
		player setOrigin(plattrig_tp.origin);
		player setPlayerAngles(plattrig_tp.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}


salle2()
{
	teleportsalle2 = getEnt("teleportsalle2","targetname");
	trigtp2 = getEnt("trigtp2","targetname");
	
    for(;;)
	{
		teleportsalle2 waittill("trigger", player);
		player setOrigin(trigtp2.origin);
		player setPlayerAngles(trigtp2.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

secretezfail()
{
	spawneasysecret = getEnt("spawneasysecret", "targetname");
	easy_tp = getEnt("easy_tp", "targetname");
	
	for (;;)
	{
		spawneasysecret waittill("trigger", player);
		player setOrigin(easy_tp.origin);
		player setPlayerAngles(easy_tp.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}


ezfinish()
{
    ez_finish = getEnt("ez_finish","targetname");
	nextroom1 = getEnt("nextroom1","targetname");
	
    for(;;)
	{
		ez_finish waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

mp1()
{
    mapend = getEnt("mapend","targetname");
	nextroom1 = getEnt("nextroom1","targetname");
	
    for(;;)
	{
		mapend waittill("trigger", player);
		player setOrigin(nextroom1.origin);
		player setPlayerAngles(nextroom1.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

mp2()
{
    mapend1 = getEnt("mapend1","targetname");
	nextroom1 = getEnt("nextroom1","targetname");
	
    for(;;)
	{
		mapend1 waittill("trigger", player);
		player setOrigin(nextroom1.origin);
		player setPlayerAngles(nextroom1.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}
