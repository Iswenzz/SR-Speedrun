main()
{
thread sr\api\_map::createSpawnOrigin((-176, 48, -111.875), 0);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
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


	thread way_connect();

	thread startdoor();
	thread platforms();
	thread secenter();
	thread secfail1();
	thread secfail2();
	thread secfail3();
	thread secfail4();
	thread secfail5();
	thread secfail6();
	thread secfail7();
	thread secfinish();
	thread secretd();
	

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

startdoor()
{
	door=getent("sd","targetname");

	door delete();

}

platforms()
{
	trig = getent("trig_plat", "targetname");
	plt = getent("plat", "targetname");
	plt2 = getent("plat2", "targetname");

	trig waittill("trigger");
	trig delete();

	wait 1;
	plt thread platf();
	plt2 delete();
}

platf()
{
	while(isdefined(self))
	{
		self moveX (-1824, 2);
		wait 2;
		self rotateyaw (-180, 2);
		wait 2;
		self moveX (304, 1);
		wait 2;
		self moveZ (-240, 2);
		wait 2;
		self moveX (-304, 1);
		wait 1;
		self rotateyaw (180, 2);
		wait 2;
		self moveX (1824, 2);
		wait 2;
		self moveZ (240, 2);
		wait 2;
	}
}

secenter()
{
	level.secenter_trigger = getEnt("trig_secenter", "targetname");
		telejumporigin = getEnt("secret_fail1", "targetname");

		while(1)
		{
		level.secenter_trigger waittill( "trigger", player );
		 player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail1()
{
	level.secfail1_trigger = getEnt("trig_secret_fail1", "targetname");
		telejumporigin = getEnt("secret_fail1", "targetname");

		while(1)
		{
		level.secfail1_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}
secfail2()
{
	level.secfail2_trigger = getEnt("trig_secret_fail2", "targetname");
		telejumporigin = getEnt("secret_fail2", "targetname");

		while(1)
		{
		level.secfail2_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail3()
{
	level.secfail3_trigger = getEnt("trig_secret_fail3", "targetname");
		telejumporigin = getEnt("secret_fail3", "targetname");

		while(1)
		{
		level.secfail3_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail4()
{
	level.secfail4_trigger = getEnt("trig_secret_fail4", "targetname");
		telejumporigin = getEnt("secret_fail4", "targetname");

		while(1)
		{
		level.secfail4_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail5()
{
	level.secfail5_trigger = getEnt("trig_secret_fail5", "targetname");
		telejumporigin = getEnt("secret_fail5", "targetname");

		while(1)
		{
		level.secfail5_trigger waittill( "trigger", player );


		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail6()
{
	level.secfail6_trigger = getEnt("trig_secret_fail6", "targetname");
		telejumporigin = getEnt("secret_fail6", "targetname");

		while(1)
		{
		level.secfail6_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail7()
{
	level.secfail7_trigger = getEnt("trig_secret_fail7", "targetname");
		telejumporigin = getEnt("secret_fail7", "targetname");

		while(1)
		{
		level.secfail7_trigger waittill( "trigger", player );


		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfinish()
{
	level.secfinish_trigger = getEnt("trig_secfin", "targetname");
		telejumporigin = getEnt("secfin", "targetname");

		while(1)
		{
		level.secfinish_trigger waittill( "trigger", player );


		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		level.PlayerInRoom = false;

		}
}

secretd()
{
	secdoor = getent("secretdoor", "targetname");
	level.secretdoor_trigger = getent("trig_secretdoor", "targetname");
	step1 = getent("thx", "targetname");

		wait 1;
		secdoor delete();

}
