main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    //GENERAL VARS
	level.inroom = false;
    level.barrier = false;
    level.selectedmusicid = 0;

	//DISABLING FALLDAMAGE
	setDvar("bg_falldamagemaxheight", 9999999 );
    setDvar("bg_falldamageminheight", 999999 );

    //PRECACHE
    precacheShader("crosslogo");
    preCacheItem("crosscode_mp");

    thread sr\api\_map::createSpawnOrigin((3584, -917, 32), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    
	//GENERAL THREADS
    thread opening();
    thread addTestClients();
    thread startteleporttrigger();
    thread endteleporttrigger();
	thread fx();
    thread water_moving();
    thread container_moving();

}

container_moving()
{
containers_1 = getEnt("trap6_1","targetname");
containers_2 = getEnt("trap6_2","targetname");


containers_1 moveZ(-100, 3, 1, 2);
containers_2 moveZ(-100, 3, 1, 2);

}

water_moving()
{
    hurt_trigger = getEnt("hurt_trigger","targetname");
    bounce_trigger = getEnt("bounce_fail_trig","targetname");
    water = getEnt("water_model","targetname");

    bounce_trigger enableLinkTo();
    hurt_trigger enableLinkTo();
    bounce_trigger linkTo(water);
    hurt_trigger linkTo(water);

   
    water moveZ(-100, 3, 1, 1);
  

}

opening()
{
    barrier = getEnt("start_barrier","targetname");

    barrier delete();
}

startteleporttrigger()
{
    trigger = getEnt("start_teleport","targetname");
    origin = getEnt("start_teleport_origin","targetname");
    dest = getEnt("start_teleport_dest","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
        player thread teleportplayer(origin,dest,false);
	}
}

endteleporttrigger()
{
    trigger = getEnt("endmap_trig","targetname");
    origin = getEnt("end_teleport_origin","targetname");
    dest = getEnt("end_teleport_dest","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
        player sr\api\_speedrun::finishWay("normal_0");
	}
}

teleportplayer(origin,dest,freeze)
{
    self freezeControls(1);

    self setOrigin( origin.origin );
	self setplayerangles( origin.angles );

    self setOrigin( dest.origin );
	self setplayerangles( dest.angles );

    if(!freeze)
        self freezeControls(0);

}

fx()
{
	level._effect[ "crosscode_teleport" ] = loadfx( "crosscode_teleport" );

	fxspawn1 = getEntArray("fx_teleport","targetname");

    for(i=0; i < fxspawn1.size; i++)
    {
        ent = maps\mp\_utility::createOneshotEffect( "crosscode_teleport" );
	    ent.v[ "origin" ] = fxspawn1[i].origin;
	    ent.v[ "angles" ] = ( -90, 0, 0 );
    }

}

addTestClients()
{
     setDvar("scr_testclients", "");
     wait 1;
     for(;;)
     {
         if(getdvarInt("scr_testclients") > 0)
             break;
         wait 1;
     }
     testclients = getdvarInt("scr_testclients");
     setDvar( "scr_testclients", 0 );
     for(i=0;i<testclients;i++)
     {
         ent[i] = addtestclient();

         if (!isdefined(ent[i]))
         {
             println("Could not add test client");
             wait 1;
             continue;
         }
         ent[i].pers["isBot"] = true;
         ent[i].pers["registered"] = 0;
         ent[i] thread TestClient("autoassign");
     }
     thread addTestClients();
}

TestClient(team)
{
     self endon( "disconnect" );

     while(!isdefined(self.pers["team"]))
         wait .05;

     self notify("menuresponse", game["menu_team"], team);
     wait 0.5;
}