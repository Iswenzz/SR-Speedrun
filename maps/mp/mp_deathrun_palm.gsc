main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawnOrigin(auto_spawn[int(auto_spawn.size / 3)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);
	
        thread smrt ();

	thread sr\api\_map::createSpawn((-491, -302, 444), 90);

        maps\mp\_load::main();
	
	// maps\mp\mp_deathrun_palm_script1::main();
	// maps\mp\mp_deathrun_palm_script2::main();
        /* [AUTO DELETE] ambientPlay("ambient_backlot_ext"); */
	
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

        level.trapTriggers = [];
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t1", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t2", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t3", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t4", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t5", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t6", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t7", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t8", "targetname" );

        thread start();

        kyvadlo1 = getent( "kyvadlo1" , "targetname" );
        kyvadlo1 delete();
kyvadlo2 = getent( "kyvadlo2" , "targetname" );
   kyvadlo2 delete();

}

start()
{
start = getent( "start" , "targetname" );
brzda = getent( "brzda" , "targetname" );

brzda delete ();
start movey ( 960, 30, 0.4, 0.4);
}

smrt()
{
	smrt1 = getentarray("smrt", "targetname");
	if (smrt1.size > 0)
	                 
	for(i = 0; i < smrt1.size; i++)
	{
		smrt1[i] thread smrt_think();
	}	
}


smrt_think()
{
	while (1)
	{
		self waittill ("trigger",other);
		
		if(isPlayer(other))
			other thread smrt_kill(self);
	}
}


smrt_kill(trigger)
{
	if(isDefined(self.smrt))
		return;
		
	self.smrt = true;

	if(isdefined(self) && self istouching(trigger))
	{
		origin = self getorigin();
		range = 300;
		maxdamage = 2000;
		mindamage = 50;

		radiusDamage(origin, range, maxdamage, mindamage);
	}
	
	self.smrt = undefined;
}
