main()
{
level.masterSpawn = spawn("script_origin", level.spawn["allies"][2].origin);
level.masterSpawn.angles = level.spawn["allies"][2].angles;
trigger = spawn("trigger_radius", (-2.43295, -301.38, 128.125), 0, 40, 120);
trigger.targetname = "endmap_trig";
trigger.radius = 40;
thread way_connect();
maps\mp\_load::main();

//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
// ambientPlay("ambient_middleeast_ext");
//VisionSetNaked( "mp_vacant" );

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
//setdvar("compassmaxrange","1500");

	// addTriggerToList( "trigger_gap" );
	// addTriggerToList( "trigger_lifter" );
	// addTriggerToList( "labyrinth_trig" );
	// addTriggerToList( "spinner_trig" );
	// addTriggerToList( "spinner_tube_trig" );
	// addTriggerToList( "arrow_trig" );

	// thread gaptrap_slider ();
	// thread liftertrap_slider ();
	// thread labyrinth_slider ();
	// thread spinnercone_slider ();
	// thread tube_slider ();
	// thread arrow_shot_slider ();
	// thread door_slider ();
	// thread maze_slider ();
	// thread brick_blaster_slider ();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( targetname )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( targetname, "targetname" );
}


gaptrap_slider() 
{ 
	gaptrap = getent( "gap_trap", "targetname" ); 
	gap_trig = getent( "trigger_gap", "targetname" );

		gap_trig waittill ("trigger"); 
		//wait 4; 
		gaptrap movez (-200,2,0,0.6); 
		gaptrap waittill ("movedone"); 
		wait 4;  
		gaptrap movez(200,4,0,0.6); 
		gaptrap waittill ("movedone");
}

liftertrap_slider() 
{ 
	lifter_left_trap = getent( "lifter_left", "targetname" );
	lifter_right_trap = getent( "lifter_right", "targetname" );
	lifter_trig = getent( "trigger_lifter", "targetname" );

		lifter_trig waittill ("trigger");
			//left lifter movement
		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");
}

labyrinth_slider()
{
	laby_trig = getent( "labyrinth_trig", "targetname" );
	laby_wall = getent( "labyrinth_wall", "targetname" );

		laby_trig waittill ("trigger");
		
		laby_wall movez (128,1,0,0);
		laby_wall waittill ("movedone");
		wait 20;
		laby_wall movez (-128,1,0,0);
}

spinnercone_slider()
{
	spin_trig = getent( "spinner_trig", "targetname" );
	spinner_cone = getent( "spinnercone", "targetname" );

		spin_trig waittill ("trigger");
		
		spinner_cone movez (64,1,0,0);
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		wait 5;
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");

		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone movez (-64,1,0,0);
		spinner_cone waittill ("rotatedone");
}

tube_slider()
{
	tube_trig = getent( "spinner_tube_trig", "targetname" );
	tube = getent( "spinner_tube", "targetname" );

		tube_trig waittill ("trigger");
		
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 0.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 0.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 1.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 1.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
}

arrow_shot_slider()
{
	arrw_trig = getent( "arrow_trig", "targetname" );
	arrw_top = getent( "arrow_top", "targetname" );
	arrw_bot = getent( "arrow_bot", "targetname" );

		arrw_trig waittill ("trigger");
		
		arrw_bot movex (-320,1,0,0);
		arrw_bot waittill ("movedone");
		wait 1;
		arrw_top movex (-320,1,0,0);
		arrw_bot movez (-200,1,0,0);
		arrw_top waittill ("movedone");
		
		arrw_top movez (-200,1,0,0);
}

door_slider()
{
	door_trig = getent( "door_trigger", "targetname" );
	door = getent( "door_open", "targetname" );

		door_trig waittill ("trigger");
		
		door movez (-200,5,0,0);
		door waittill ("movedone");

}

maze_slider()
{
	maze_trig = getent( "maze_trigger", "targetname" );
	maze_door = getent( "maze_bitch", "targetname" );

	while(true)
	{
		maze_trig waittill ("trigger");
		
		maze_door movez (-136,1,0,0);
		maze_door waittill ("movedone");
		wait 2.5;
		maze_door movez (136,1,0,0);
		maze_door waittill ("movedone");
		wait 4;
	}
}

//this trap is not a real trap, it is a secret. so dont put the disable on this.
brick_blaster_slider()
{
	wall = getent ( "brick_wall", "targetname" );
	alternate = getent ( "alternate_door", "targetname" );
	brick_trig = getent ( "brick_trigger", "targetname" );
	trig_1 = getent ( "point_1", "targetname" );
	trig_2 = getent ( "point_2", "targetname" );
	trig_3 = getent ( "point_3", "targetname" );
	trig_4 = getent ( "point_4", "targetname" );
	
	while(true)
	{
		brick_trig waittill ("trigger", user);
		
		if ((user.name == "LineX Brick") || (user.name == "LineX zuiN") || (user.name == "LineX Liner") || (user.name == "LineX Prankster") || (user.name == "tabs24x7") || (user.name == "LineX Valias") || (user.name == "Brick"))
		{
			wall notsolid();
		}
		else
		{
			wall solid();
		}
	}
	
	while(true)
	{
		trig_1 waittill ( "trigger" );
		trig_2 waittill ( "trigger" );
		trig_3 waittill ( "trigger" );
		trig_4 waittill ( "trigger" );
		alternate notsolid();
		wait 10;
		alternate solid();
	}
}