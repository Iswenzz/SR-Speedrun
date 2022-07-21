main()
{
thread sr\api\_map::createSpawnOrigin((1721, 2832, 120), 270);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (26.0624, 1312.15, 202.402), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.inAir = true;
trigger.radius = 96;

	//***************************//
	thread way_connect();
    maps\mp\_load::main();

	//***** script ******//
	maps\mp\mp_dr_terror\traps::main();
	//maps\mp\mp_dr_terror\mp_dr_terror::main();
	// thread SetTimeLimit( 4 );
	// thread RegisterTrapTrigger( "t1_" );
	// thread RegisterTrapTrigger( "t2_" );
	// thread RegisterTrapTrigger( "t3_" );
	// thread RegisterTrapTrigger( "t4_" );
	// thread RegisterTrapTrigger( "t5_" );
	// thread RegisterTrapTrigger( "t6_" );
	// thread RegisterTrapTrigger( "t7_" );
	// thread RegisterTrapTrigger( "t8_" );
	// thread RegisterTrapTrigger( "t9_" );
	// thread RegisterTrapTrigger( "t10_" );
	// thread RegisterTrapTrigger( "t11_" );
	// thread RegisterTrapTrigger( "t12_" );
	// thread RegisterTrapTrigger( "t13_" );
	// thread RegisterTrapTrigger( "t14_" );
	// thread RegisterTrapTrigger( "t15_" );
	// thread RegisterTrapTrigger( "t16_" );
	// thread RegisterTrapTrigger( "t17_" );
	// thread RegisterTrapTrigger( "t18_" );
	// thread RegisterTrapTrigger( "t19_" );
	// thread RegisterTrapTrigger( "t20_" );
	// thread RegisterTrapTrigger( "t21_" );
	// thread RegisterTrapTrigger( "t22_" );
	setdvar("compassmaxrange","1750");

	// AmbientPlay( "coldplay" );

	//***************************//

        game["allies"] = "sas";
        game["axis"] = "opfor";
        game["attackers"] = "axis";
        game["defenders"] = "allies";
        game["allies_soldiertype"] = "woodland";
        game["axis_soldiertype"] = "woodland";

	//setdvar( "r_specularcolorscale", "1" );

	//setdvar("r_glowbloomintensity0",".25");
	//setdvar("r_glowbloomintensity1",".25");
	//setdvar("r_glowskybleedintensity0",".3");
	//setdvar("compassmaxrange","1800");
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

SetTimeLimit( time )
{
    wait 0.05; //wait for game to load mod script
	if( level.dvar["time_limit"] <= time )
		level.dvar["time_limit"] = time;
}
RegisterTrapTrigger( targetname )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];

	ent = getEnt( targetname, "targetname" );

	if( isDefined( ent ) )
		level.trapTriggers[level.trapTriggers.size] = ent;
}