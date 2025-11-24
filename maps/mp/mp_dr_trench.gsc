/*            
  /\\  /\\  
  //\\_//\\     ____
  \_     _/    /   /
   / ^ ^ \    /^^^|
   \_\O/_/    |   |
    /   \_    |   /
    \     \_  /  /
    | | | /  \/ _/
    |_| | \__/_/                              
    By VC'Fox.

    ______________________________________________
    /   /  ___/    ___/   ___/  \     / /  ___  \
    /   /  /__     /___   /__/ /\ \   / /  /  /  /
    /   /  ___/  __    /  ___/ /  \ \ / /  /  /  /
    _/  /__   /_/   /  /__/ /    \ \ /  /__/  /
    ___\____/________/\____/_/      \_/________/

        ___    __  _       _______        
    | | / (_)__/ /_(_)___  / ___/ /__ ____ 
    | |/ / (_-< __/ / __/ / /__/ / _ `/ _ \
    |___/_/___|__/_/\__/  \___/_/\_,_/_//_/ 

    \\discord//
    legend9805
    fox.0614

    \\music//
    Frontliner - TBA 2 (One More Time) 
    Feint & Kate McGill - It's True
    Andromedik & Used - Take Me 
    Linkin Park - The Emptiness Machine  
    akiaura, LONOWN, STM — Sleepwalker

    map completed on 11/2025
*/

main()
{
    //level.trap1 = loadFX("explosions/grenadeExp_metal");    
    //level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
    //level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
    //level.musicfx = loadfx ("deathrun/embers_purple");
    //playLoopedFX(level.musicfx, 0.5, (-1519.14, 2062.79, -44.00));
    //playLoopedFX(level.musicfx, 0.5, (-1611.10, 2062.79, -44.00));

    maps\mp\_load::main();
    //maps\mp\_teleport::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
    setdvar("r_glowskybleedintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
    setdvar("r_glowskybleedintensity0",".1");
    setDvar("bg_falldamagemaxheight", "3000000");
    setDvar("bg_falldamageminheight", "1280000"); 

    precacheModel("vehicle_mig29_desert");
    precacheModel("vehicle_mi24p_hind_mp");

    precacheItem("m40a3_mp");
    precacheItem("remington700_mp");
    precacheItem("deserteagle_mp");
    precacheItem("rpd_mp");
    precacheItem("knife_mp");
    preCacheItem("deserteagle_mp");
    preCacheItem("ak47_mp");
    preCacheItem("g3_mp");
    preCacheItem("winchester1200_mp");

    addTriggerToList("trig_trap1"); 
    addTriggerToList("trig_trap2"); 
    addTriggerToList("trig_trap3"); 
    addTriggerToList("trig_trap4"); 
    addTriggerToList("trig_trap5"); 
    addTriggerToList("trig_trap7"); 

    thread sr\api\_map::createSpawn((-1583, 2352, -4), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way");

    thread sr_sec_enter();

    //thread onPConnected();
    //thread platform();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    thread trap4();
    //thread trap5();
    thread trap7();
    //thread roomselection_setup();
    //thread secret();
    thread secret_done();
    //thread ambMusic();

    //level waittill("round_started");
    thread startdoor();
    //thread jetspawn();
    //thread FlyingHelicopter();
    //thread messages();
}
sr_sec_enter()
{
	trig = spawn("trigger_radius",(-1704.08, 2486.74, -63.875), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("here1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

onPConnected() 
{
    level endon("game over");
    for(;;) 
    {
        level waittill("connected",player);
        player SetClientDvar("r_drawdecals", "1" );
    }
}

messages()
{
	for(;;)
	{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox & VC'Legend");
	wait 30;
	iPrintLn("Vistic-Clan ^6<3"); 
	wait 30;
    iPrintLn("^3> ^7mp_dr_trench / 2025"); 
    wait 20;
	}
}

ambMusic()
{
    music = [];
    music[0] = "andromedik";
    music[1] = "feint";
    music[2] = "frontliner";
    music[3] = "linkinpark";
    music[4] = "sleepwalker";

    trigger = getEnt("ambmusic_trigger","targetname");
    trigger setHintString("Press [^5&&1^7] To Play Music");
    trigger waittill("trigger",player);
    trigger delete();
    wait 1;
    ambientplay(music[RandomInt(music.size)]);
}

startdoor()
{

    door = getEnt("startdoor","targetname");
    {
    door delete();
    }
}

jetspawn()//ripped from mirrors edge
{
    start_org = GetEntArray("jetstart","targetname");
    end_org = GetEntArray("jetend","targetname");

    jet_mid = spawn("script_model",start_org[0].origin); 
    jet_mid.angles=start_org[0].angles;
    jet_mid setModel( "vehicle_mig29_desert" ); 
    jet_mid playloopsound("veh_mig29_dist_loop");
    jet_mid thread playPlaneFx();
    
    jet_left = spawn("script_model",start_org[1].origin); 
    jet_left.angles=start_org[1].angles;
    jet_left setModel( "vehicle_mig29_desert" ); 
    jet_left playloopsound("veh_mig29_dist_loop");
    jet_left thread playPlaneFx();
    
    jet_right = spawn("script_model",start_org[2].origin); 
    jet_right.angles=start_org[2].angles;
    jet_right setModel( "vehicle_mig29_desert" ); 
    jet_right playloopsound("veh_mig29_dist_loop");
    jet_right thread playPlaneFx();
    
    
    jet_mid moveTo(end_org[0].origin,9);
    jet_left moveTo(end_org[1].origin,9);
    jet_right moveTo(end_org[2].origin,9);
    jet_mid waittill("movedone");
    jet_mid delete();
    wait 0.5;
    jet_left delete();
    jet_right delete();
}

playPlaneFx()
{
    self endon ( "death" );
    while(1)
    {
    playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
    playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
    playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
    playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
    wait 1;
    }
}

FlyingHelicopter()//todo - ripped from backlot
{

    while(1)
    {
        players = getentarray("player", "classname");
        if( players.size > 0 )
            break;
        wait 1;
    }
    players = getentarray("player", "classname");
    player = players[RandomInt(players.size)];
    
    targets = getEntArray("choppa_path", "targetname");
    chopper = spawn_helicopter( player, (-904.00, 2440.00, 376.00), (0,180,0), "cobra_mp", "vehicle_mi24p_hind_mp" );
    chopper playLoopSound( "mp_cobra_helicopter" );
    chopper.owner = player;
    chopper.maxhealth = 1000;
    chopper.health = chopper.maxhealth;
    chopper setDamageStage( 3 );
    chopper setSpeed( 25, 15 );
    type = "hind";
    
    trigger = GetEntArray("heli_trigger","targetname");
    path = GetEntArray("heli_path","targetname");

    for(i=0;i<trigger.size;i++)
        thread heli_move(trigger[i], path[i], chopper);
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
    chopper = spawnHelicopter( owner, origin, angles, model, targetname );
    return chopper;
}

heli_move(trigger,point, chopper)
{
    trigger waittill("trigger",player);
    trigger delete();
    chopper setVehGoalPos( point.origin, true );
    //chopper waittill("goal");
    chopper setGoalYaw( RandomInt(361) );
}

platform()
{
    platform1 = getEnt("ele1","targetname");
    platform2 = getEnt("ele2","targetname");

    for(;;)
    {
        platform1 moveY(-480, 1.5);
        platform2 moveY(480, 1.5);
        wait 4;
        platform1 moveY(480, 1.5);
        platform2 moveY(-480, 1.5);
        wait 4;
    }

}

//////////////////////////////////////////////////

secret()
{
	trig = getEnt("trig_sec","targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
	{
        trig waittill("trigger", player);
        player setOrigin(tele1.origin);
        player freezeControls(1);
        player setPlayerAngles(tele1.angles);
        wait 0.5;
        player freezeControls(0);
        wait 0.1;
    }
}

secret_done()
{
	trig = getEnt("trig_sec_leave","targetname");
	tele1 = getEnt("here2", "targetname");

    for(;;)
	{
        trig waittill("trigger", player);
        
        player thread sr\api\_speedrun::finishWay("secret_0"); 
    }
}


trap1()
{
    trig = getEnt("trig_trap1", "targetname");
    barrels = GetEntArray("barrels","targetname");
    dmgorigin = getEnt("dmgorigin","targetname");
    trig setHintString("Press [^5&&1^7] To Activate");

    trig waittill("trigger", player);
    trig delete();

    for(i=0;i<barrels.size;i++)
    {
        barrels[i] playsound("grenade_explode_default");
        RadiusDamage( dmgorigin.origin, 200, 199, 200 );
        Earthquake( 0.3, 1.5, barrels[i].origin, 500 );
        playfx(level.trap1, (barrels[i].origin));
        barrels[i] hide();
        wait 0.5;
    }
}

trap2()
{
    trig = getEnt("trig_trap2", "targetname");
    platforms = GetEntArray("trap2plat","targetname");
    trig setHintString("Press [^5&&1^7] To Activate");

    trig waittill("trigger", player);
    trig delete();

    for(i=0;i<platforms.size;i++)
    {
        platforms[i] hide();
        platforms[i] notsolid();
    }

    wait RandomIntRange(3,5);


    for(i=0;i<platforms.size;i++)
    {
        platforms[i] show();
        platforms[i] solid();
    }
}

trap3()
{
    trig = getEnt("trig_trap3", "targetname");
    platform = GetEnt("trap3plat","targetname");
    trig setHintString("Press [^5&&1^7] To Activate");

    trig waittill("trigger", player);
    trig delete();

    platform movez(-100,0.5);

    wait RandomIntRange(3,5);

    platform movez(100,3);
}

trap4()
{
    trig = getEnt("trig_trap4", "targetname");
    wall = GetEnt("trap4wall","targetname");

    wall delete();
}

trap5()
{
    trig = getEnt("trig_trap5", "targetname");
    killtrig = getEnt("trap5killtrig","targetname");
    rotator = GetEnt("trap5rotator","targetname");

    trig setHintString("Press [^5&&1^7] To Activate");
    killtrig enablelinkto();
    killtrig linkto(rotator);

    trig waittill("trigger", player);
    trig delete();

    for(;;)
    {
        rotator rotateyaw(180, 1.5, 0.25, 1.25);
        wait RandomIntRange(3,7);
        rotator rotateyaw(-180, 1.5, 0.25, 1.25);
        wait RandomIntRange(3,7);
    }
}

trap7()
{
    trig = getEnt("trig_trap7", "targetname");
    killtrig = getEnt("trap7hurt","targetname");
    laser = getEnt("trap7","targetname");

    laser delete();
    killtrig delete();

}

roomselection_setup()
{
    trigger = GetEntArray("room_trigger","targetname");
    activator_origin = GetEntArray("room_activator_origin","targetname");
    jumper_origin = GetEntArray("room_jumper_origin","targetname");
    level.firstenter = false;

    for(i=0;i<trigger.size;i++)
        thread room_selection(trigger[i] , activator_origin[i], jumper_origin[i], trigger);
}

room_selection(trig, activator_origin, jumper_origin, room_triggers)
{

    id = trig.script_noteworthy;
    trig setHintString("Press [^5&&1^7] To Enter Room");
    for(;;)
    {
        trig waittill("trigger",player);

        if(level.firstenter == false)//delete other rooms
        {
            for(i=0;i<room_triggers.size;i++)
            {
                if(id != room_triggers[i].script_noteworthy && isDefined(room_triggers[i]))
                    room_triggers[i] delete();
            }
            level.firstenter = true;
        }

        if(isDefined(level.activ))
        {
            level.activ setorigin( activator_origin.origin );
            level.activ SetPlayerAngles( activator_origin.angles );
        }

        player setorigin( jumper_origin.origin );
        player SetPlayerAngles( jumper_origin.angles );

        switch(int(id))
        {
            case 0://shotgun
                if(isDefined(level.activ))
                    level.activ thread room_weapon("winchester1200_mp",undefined);
                player thread room_weapon("winchester1200_mp",undefined);
            break;

            case 1://knife
                if(isDefined(level.activ))
                    level.activ thread room_weapon("knife_mp",undefined);
                player thread room_weapon("knife_mp",undefined);
            break;

            case 2://sniper
                if(isDefined(level.activ))
                    level.activ thread room_weapon("remington700_mp","m40a3_mp");
                player thread room_weapon("remington700_mp","m40a3_mp");
            break;

        default: return;
        }

        thread countdown(5, level.activ, player);

        while(isAlive(player) && isDefined(player))
            wait 0.05;
    }
}

safe_delete(ent)
{
    wait 0.05; // Allow trigger callback to fully exit
    if (isDefined(ent))
        ent delete();
}

countdown(time, activator, player)
{
    if(isDefined(activator))
        activator freezeControls( true );
    player freezeControls( true );

    for(i=time;i>0;i--)
    {
        iPrintLnBold(i);
        wait 1;
    }

    if(isDefined(activator))
        activator freezeControls( false );
    player freezeControls( false );
}

room_weapon(item,item2)
{
    self TakeAllWeapons();

    if(isDefined(item))
    {
        self giveWeapon(item);

        if(item != "knife_mp")
            self GiveMaxAmmo(item);

        self SwitchToWeapon(item);
    }

    if(isDefined(item2))
    {
        self giveWeapon(item2);
        self GiveMaxAmmo(item2);
    }
}