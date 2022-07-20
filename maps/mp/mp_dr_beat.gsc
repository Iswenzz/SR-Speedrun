main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
level.masterSpawn = spawn("script_origin", level.spawn["allies"][5].origin);
level.masterSpawn.angles = level.spawn["allies"][5].angles;
level.masterSpawn placeSpawnPoint();
	maps\mp\_load::main();	
 	// ambientPlay("ambient1");
	
	level.flary = loadFX("deathrun/flary"); 
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

////Trigger-List////

	// addTriggerToList( "trap1_trigger" );
	// addTriggerToList( "trap2_trigger" );
	// addTriggerToList( "trap3_trigger" );	
	// addTriggerToList( "trap4_trigger" );	
	// addTriggerToList( "trap5_trigger" );	
	// addTriggerToList( "trap6_trigger" );
	
	thread way_connect();
	thread erik();
	thread fx1();
	thread fx2();
	thread fx3();
	thread fx4();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread end();
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


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
} 

erik()
{
	brush = getent ("erik", "targetname");

	while(1)
{
	brush rotateyaw (360,1.5);
	wait 1.5;
	brush rotatepitch (360,2);
	wait 1.5;
	brush rotateyaw (360,2);
	brush rotatepitch (360,2);
	wait 2;
}
}

fx1()
{
	fx = getent( "fx1", "targetname" );
	trig = getent("fx1_trigger", "targetname");
{
	trig waittill ("trigger", player);
	
	trig delete();
	playFx(level.flary, fx.origin);
}
}

fx2()
{
	fx = getent( "fx2", "targetname" );
	trig = getent("fx2_trigger", "targetname");
{
	trig waittill ("trigger", player);
	
	trig delete();
	playFx(level.flary, fx.origin);
}
}

fx3()
{
	fx = getent( "fx3", "targetname" );
	trig = getent("fx3_trigger", "targetname");
{
	trig waittill ("trigger", player);
	
	trig delete();
	playFx(level.flary, fx.origin);
}
}

fx4()
{
	fx = getent( "fx4", "targetname" );
	trig = getent("fx4_trigger", "targetname");
{
	trig waittill ("trigger", player);
	
	trig delete();
	playFx(level.flary, fx.origin);
}
}

trap1()
{
	brush = getent ("trap1_brush", "targetname");
	trig = getent ("trap1_trigger", "targetname");
	
	trig waittill("trigger");
	while(1)
{
	trig SetHintString("^9Activated");
	brush rotatepitch (720,4);
	wait 5;
}
}

trap2()
{
	trig = getEnt( "trap2_trigger", "targetname" );
	brush = getEnt( "trap2_brush", "targetname" );

	trig waittill( "trigger" );
	
	while(1)
{
	trig SetHintString("^9Activated");
	brush rotateyaw (-720,3);
	wait 4;
	brush rotateyaw (720,3);
	wait 4;
}
}

trap3()
{
	trig = getEnt( "trap3_trigger", "targetname" );
	brush1 = getEnt( "trap3_brush1", "targetname" );
	brush2 = getEnt( "trap3_brush2", "targetname" );
	brush3 = getEnt( "trap3_brush3", "targetname" );
	brush4 = getEnt( "trap3_brush4", "targetname" );
	brush5 = getEnt( "trap3_brush5", "targetname" );
	brush6 = getEnt( "trap3_brush6", "targetname" );

	trig waittill( "trigger" );
	
	while(1)
{
	trig SetHintString("^9Activated");
	brush1 rotateyaw (1080,6);
	brush2 rotateyaw (1080,6);
	brush3 rotateyaw (1080,6);
	brush4 rotateyaw (-1080,6);
	brush5 rotateyaw (-1080,6);
	brush6 rotateyaw (-1080,6);
	wait 6;
	brush1 rotateyaw (-1080,6);
	brush2 rotateyaw (-1080,6);
	brush3 rotateyaw (-1080,6);
	brush4 rotateyaw (1080,6);
	brush5 rotateyaw (1080,6);
	brush6 rotateyaw (1080,6);
	wait 6;
}
}

trap4()
{
	trig = getEnt( "trap4_trigger", "targetname" );
	brush1 = getEnt( "trap4_brush1", "targetname" );
	brush2 = getEnt( "trap4_brush2", "targetname" );

	trig waittill( "trigger" );
	
	while(1)
{
	trig SetHintString("^9Activated");
	brush1 rotateyaw (-360,2);
	brush2 rotateyaw (360,2);
	wait 3.5;
	brush1 rotateyaw (360,2);
	brush2 rotateyaw (-360,2);
	wait 3.5;
}
}

trap5()
{
	trig = getEnt( "trap5_trigger", "targetname" );
	brush1 = getEnt( "trap5_brush1", "targetname" );
	brush2 = getEnt( "trap5_brush2", "targetname" );

	trig waittill( "trigger" );
	
	while(1)
	{
	trig delete();
	trig SetHintString("^9Activated");
	brush1 moveZ(50,1);
	brush2 moveZ(-50,1);
	brush1 waittill("movedone");
	brush1 moveZ(-100,1);
	brush2 moveZ(100,1);
	brush1 waittill("movedone");
	brush1 moveZ(100,1);
	brush2 moveZ(-100,1);
	brush1 waittill("movedone");
	brush1 moveZ(-50,1);
	brush2 moveZ(50,1);
	brush1 waittill("movedone");
}
}

trap6()
{
	trig = getEnt( "trap6_trigger", "targetname" );
	brush = getEnt( "trap6_brush", "targetname" );

	trig waittill( "trigger" );
	
	while(1)
{
	trig SetHintString("^9Activated");
	brush rotateyaw (-720,4);
	wait 4;
	brush rotateyaw (720,4);
	wait 4;
}
}


end()
{
	trig = getEnt ("end_trigger", "targetname");
	target = getEnt ("end_target", "targetname");
	
	for(;;)
	{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
}