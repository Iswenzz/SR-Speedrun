/*
______           __  _____  _____ 
| ___ \         /  ||  _  ||  _  |
| |_/ /_____  __`| || |/' || |_| |
|    // _ \ \/ / | ||  /| |\____ |
| |\ \  __/>  < _| |\ |_/ /.___/ /
\_| \_\___/_/\_\\___/\___/ \____/ 

Welcome to mp_dr_crosscode script. Feel free to take any piece of code, no need to credit me.

*/

main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    thread speedrun\_way_name::create_spawn((3584, -917, 92),90);
    thread speedrun\_way_name::create_normal_way("Normal Way;");

    if(!isdefined(level.music))
	level.music=[];
	level.music[0]["song"]    ="^5Crosscode OST - Autumn's Rise";
	level.music[0]["alias"]    ="radio1";
	level.music[1]["song"]    ="^5Crosscode OST - Rookie Harbor";
	level.music[1]["alias"]    ="radio2";
	level.music[2]["song"]    ="^5Crosscode OST - Maroon Valley";
	level.music[2]["alias"]    ="radio3";
	level.music[3]["song"]    ="^5Crosscode OST - Vermillion Wasteland";
	level.music[3]["alias"]    ="radio4";
	level.music[4]["song"]    ="^5Crosscode OST - Old Hideout";
	level.music[4]["alias"]    ="radio5";
	level.music[5]["song"]    ="D-Charged - Lullaby";
	level.music[5]["alias"]    ="radio6";
	level.music[6]["song"]    ="B2A & Anklebreaker - Chasing Stars";
	level.music[6]["alias"]    ="radio7";
	
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

	//GENERAL THREADS
    thread init_ee();
    thread ee_finish();
    thread await_strafe();
    thread opening();
    thread addTestClients();
    thread startteleporttrigger();
    thread endteleporttrigger();
    thread musicBox();
	thread fx();
    thread water_moving();
    thread container_moving();
    thread bounce_fail();
    thread bounce_snipers_models_anim();
    thread bounce_givesniper();

    //ACTIVATOR THREADS
    addTriggerToList("trap1_trig");
    addTriggerToList("trap2_trig");
    addTriggerToList("trap3_trig");
    addTriggerToList("trap4_trig");
    addTriggerToList("trap5_trig");
    addTriggerToList("trap6_trig");
    addTriggerToList("trap7_trig");

    thread traps_init();
    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap6();
    thread trap7();

    //BATTLE THREADS
	thread sniper();
    thread knife();
    thread deagle();
    thread bounce();
    thread strafe();
    thread sphero();
}

/*
   ___                       _ 
  / __|___ _ _  ___ _ _ __ _| |
 | (_ / -_) ' \/ -_) '_/ _` | |
  \___\___|_||_\___|_| \__,_|_|
                               
*/

init_ee()
{
    level.ee_xmodel1 = getEnt("ee_1_xmodel","targetname");
    level.ee_xmodel2 = getEnt("ee_2_xmodel","targetname");
    level.ee_xmodel3 = getEnt("ee_3_xmodel","targetname");
    level.ee_xmodel4 = getEnt("ee_4_xmodel","targetname");

    level.ee_xmodel1 hide();
    level.ee_xmodel2 hide();
    level.ee_xmodel3 hide();
    level.ee_xmodel4 hide();
}

ee_steps()
{
    trigg1 = getEnt("ee_1","targetname");
    trigg2 = getEnt("ee_2","targetname");
    trigg3 = getEnt("ee_3","targetname");
    trigg4 = getEnt("ee_4","targetname");

    dest = getEnt("ee_dest","targetname");

    level.ee_xmodel1 show();

    trigg1 waittill( "trigger", org_player );

    level.ee_xmodel1 hide();
    level.ee_xmodel2 showToPlayer(org_player);
    org_player playLocalSound("switch_activate");

    while(1)
    {
        trigg2 waittill( "trigger", player );
        if(player == org_player)
        break;
    }

    level.ee_xmodel2 hide();
    level.ee_xmodel3 showToPlayer(org_player);
    org_player playLocalSound("switch_activate");

    while(1)
    {
        trigg3 waittill( "trigger", player );
        if(player == org_player)
        break;
    }

    level.ee_xmodel3 hide();
    level.ee_xmodel4 showToPlayer(org_player);
    org_player playLocalSound("switch_activate");

    while(1)
    {
        trigg4 waittill( "trigger", player );
        if(player == org_player)
        break;
    }

    level.ee_xmodel4 hide();
    org_player thread teleportplayer(org_player.origin,dest,false);
}

ee_finish()
{
	trigger = getEnt("ee_finish","targetname");
    dest = getEnt("end_teleport_dest","targetname");
    
	while(1)
	{
		trigger waittill ( "trigger", player );

        player thread teleportplayer(player.origin,dest,false);
	}
}

bounce_givesniper()
{
	trigger = getEnt("bounce_givesniper","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
        if(!player.hassniper)
        {
            player TakeAllWeapons();
            player GiveWeapon( "m40a3_mp" );
            player giveMaxAmmo( "m40a3_mp" );
            player GiveWeapon( "remington700_mp" );
            player giveMaxAmmo( "remington700_mp" );
            player switchToWeapon( "m40a3_mp" );
            player.hassniper = true;
        }
	}
}

bounce_snipers_models_anim()
{
	xmdl1 = getEnt("sniper_bounce_model1","targetname");
	xmdl2 = getEnt("sniper_bounce_model2","targetname");
	while(1)
	{
		wait 2;
		xmdl1 movez (-10,2,1,1);
		xmdl2 movez (-10,2,1,1);
		wait 2;
		xmdl1 movez (10,2,1,1);
		xmdl2 movez (10,2,1,1);
	}
}

container_moving()
{
    containers_1 = getEnt("trap6_1","targetname");
    containers_2 = getEnt("trap6_2","targetname");

    level.missing_container = 0;

    while(1)
    {
        if(level.missing_container != 1)
        containers_1 moveZ(-100, 3, 1, 2);
        if(level.missing_container != 2)
        containers_2 moveZ(-100, 3, 1, 2);

        wait 3;

        if(level.missing_container != 1)
        containers_1 moveZ(100, 3, 2, 1);
        if(level.missing_container != 2)
        containers_2 moveZ(100, 3, 2, 1);

        wait 3;
    }
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

    while(1)
    {
        water moveZ(-100, 3, 1, 1);

        wait 3;

        water moveZ(100, 3, 1, 1);

        wait 3;
    }
    
}

opening()
{
    barrier = getEnt("start_barrier","targetname");

	wait 15;
	iPrintlnBold( "Opening the barrier in..." );
	iPrintlnBold( "^55" );
	wait 1;
	iPrintlnBold( "^54" );
	wait 1;
	iPrintlnBold( "^53" );
	wait 1;
	iPrintlnBold( "^52" );
	wait 1;
	iPrintlnBold( "^51" );
	wait 1;

    level thread playSoundOnAllPlayers("barrier_down");

	barrier movez (-208,0.25);
    barrier waittill ("movedone");
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
        player thread teleportplayer(origin,dest,false);
	}
}

teleportplayer(origin,dest,freeze)
{
    self freezeControls(1);
        
    self setOrigin( origin.origin );
	self setplayerangles( origin.angles );

    self playLocalSound("teleport");

    overlay = newClientHudElem( self );
    overlay.x = 0;
    overlay.y = 0;
    overlay setshader ("white", 640, 480); 
    overlay.alignX = "left";
    overlay.alignY = "top";
    overlay.horzAlign = "fullscreen";
    overlay.vertAlign = "fullscreen";
    overlay.alpha = 0;

    overlay fadeOverTime(0.5);

    overlay.alpha = 1;

    wait 1;
        
    self setOrigin( dest.origin );
	self setplayerangles( dest.angles );

    if(!freeze)
        self freezeControls(0);

    overlay fadeOverTime(0.5);

    overlay.alpha = 0;

    wait 0.5;
        
    overlay destroy();
}

musicBox()
{
    trig=getent("musicbox","targetname");
    trig waittill("trigger",p);
    trig delete();
    
    p freezecontrols(1);
	p thread musicfix();
    p musicMenu();
}

musicfix()
{
	self waittill( "death" );
	if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
}

musicMenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );
 
    self.hud_music = [];
    self.selection = 0;

    i = 0;

    self.hud_music[i] = braxi\_mod::addTextHud( self, 320, 30, 0.93, "center", "top", 1.4 );
    self.hud_music[i].sort = 884;
	self.hud_music[i] setShader( "crosslogo", 200, 200 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 320, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7");
 
    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 320, 230+(j*16), 0.93, "center", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else 
            self.hud_music[i].glowcolor=(1,0.5,0);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 320, 230, 0.4, "center", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 550, 17 );
    indicator.color=(0,0.7,1);
	
	wait 0.5;
 
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_music[2+self.selection].alpha = 0.93;
 
            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;
 
            item = self.hud_music[2+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
            iprintln("^6>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
            ambientPlay(level.music[self.selection]["alias"]);
            level.selectedmusicid = self.selection;
            self freezecontrols(0);

            if(self.selection == 3 && game["roundsplayed"] == 8)
                thread ee_steps();

            break;
        }
    }
    
    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

fx()
{
	level._effect[ "crosscode_teleport" ] = loadfx( "crosscode_teleport" );
    level._effect[ "crosscode_leafs" ] = loadfx( "crosscode_leafs" );

	fxspawn1 = getEntArray("fx_teleport","targetname");
    fxspawn2 = getEntArray("fx_leafs","targetname");

    for(i=0; i < fxspawn1.size; i++)
    {
        ent = maps\mp\_utility::createOneshotEffect( "crosscode_teleport" );
	    ent.v[ "origin" ] = fxspawn1[i].origin;
	    ent.v[ "angles" ] = ( -90, 0, 0 );
    }

    for(i=0; i < fxspawn2.size; i++)
    {
        ent = maps\mp\_utility::createOneshotEffect( "crosscode_leafs" );
	    ent.v[ "origin" ] = fxspawn2[i].origin;
	    ent.v[ "angles" ] = ( -90, 0, 0 );
    }
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

playSoundOnAllPlayers( soundAlias )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		players[i] playLocalSound( soundAlias );
	}
}

bounce_fail()
{
	dest_acti = getEnt( "bounce_activator_dest", "targetname" );
	dest_jumper = getEnt( "bounce_jumper_dest", "targetname" );

	trigger = getEnt ( "bounce_fail_trig", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		
		if( player.pers["team"] == "allies" )
		{
			player setOrigin( dest_jumper.origin );
			player setplayerangles( dest_jumper.angles );
		}
		
		if( player.pers["team"] == "axis" )
		{
			player setOrigin( dest_acti.origin );
			player setplayerangles( dest_acti.angles );
		}
	}
}

await_strafe()
{
    trigger = getEnt ( "strafe_end", "targetname" );
    
    while(1)
    {
        trigger waittill ( "trigger", player );

        player death_room();
    }
}

death_room()
{
	loser = getEnt( "loser_dest", "targetname" );
    winner = getEnt( "winner_dest", "targetname" );
	
	if( self.pers["team"] == "allies" )
		{
			if( isDefined( level.activ ))
			{
                level.activ TakeAllWeapons();	
                level.activ freezecontrols(1);
                level.activ setOrigin( loser.origin );
                level.activ setplayerangles( loser.angles );
			}
			
            if( isDefined( level.other ))
            {
                level.other TakeAllWeapons();
                level.other freezecontrols(1);
                level.other GiveWeapon( "knife_mp" );
                level.other switchToWeapon( "knife_mp" );
                level.other setOrigin( winner.origin );
                level.other setplayerangles( winner.angles );

                wait 1;

                level.other freezecontrols(0);
            }
		}
		
	if( self.pers["team"] == "axis" )
		{
            if( isDefined( level.other ))
            {
                level.other TakeAllWeapons();	
                level.other freezecontrols(1);
                level.other setOrigin( loser.origin );
                level.other setplayerangles( loser.angles );
            }
			
			if( isDefined( level.activ ))
			{
                level.activ TakeAllWeapons();
                level.activ freezecontrols(1);
                level.activ GiveWeapon( "knife_mp" );
                level.activ switchToWeapon( "knife_mp" );
                level.activ setOrigin( winner.origin );
                level.activ setplayerangles( winner.angles );

                wait 1;

                level.activ freezecontrols(0);
			}
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

/*
    _      _   _          _           
   /_\  __| |_(_)_ ____ _| |_ ___ _ _ 
  / _ \/ _|  _| \ V / _` |  _/ _ \ '_|
 /_/ \_\__|\__|_|\_/\__,_|\__\___/_|  
                                      
*/

traps_init()
{
    level.trap1_spinner = getEnt("trap1_spinner","targetname");
    level.trap1_spinner_activated = getEnt("trap1_spinner_activated","targetname");
    level.trap1_decal = getEnt("trap1_decal","targetname");
    level.trap1_decal_activated = getEnt("trap1_decal_activated","targetname");

    level.trap2_spinner = getEnt("trap2_spinner","targetname");
    level.trap2_spinner_activated = getEnt("trap2_spinner_activated","targetname");
    level.trap2_decal = getEnt("trap2_decal","targetname");
    level.trap2_decal_activated = getEnt("trap2_decal_activated","targetname");

    level.trap3_spinner = getEnt("trap3_spinner","targetname");
    level.trap3_spinner_activated = getEnt("trap3_spinner_activated","targetname");
    level.trap3_decal = getEnt("trap3_decal","targetname");
    level.trap3_decal_activated = getEnt("trap3_decal_activated","targetname");

    level.trap4_spinner = getEnt("trap4_spinner","targetname");
    level.trap4_spinner_activated = getEnt("trap4_spinner_activated","targetname");
    level.trap4_decal = getEnt("trap4_decal","targetname");
    level.trap4_decal_activated = getEnt("trap4_decal_activated","targetname");

    level.trap5_spinner = getEnt("trap5_spinner","targetname");
    level.trap5_spinner_activated = getEnt("trap5_spinner_activated","targetname");
    level.trap5_decal = getEnt("trap5_decal","targetname");
    level.trap5_decal_activated = getEnt("trap5_decal_activated","targetname");

    level.trap6_spinner = getEnt("trap6_spinner","targetname");
    level.trap6_spinner_activated = getEnt("trap6_spinner_activated","targetname");
    level.trap6_decal = getEnt("trap6_decal","targetname");
    level.trap6_decal_activated = getEnt("trap6_decal_activated","targetname");

    level.trap7_spinner = getEnt("trap7_spinner","targetname");
    level.trap7_spinner_activated = getEnt("trap7_spinner_activated","targetname");
    level.trap7_decal = getEnt("trap7_decal","targetname");
    level.trap7_decal_activated = getEnt("trap7_decal_activated","targetname");

    thread init_trap(level.trap1_spinner, level.trap1_decal, level.trap1_spinner_activated, level.trap1_decal_activated);
    thread init_trap(level.trap2_spinner, level.trap2_decal, level.trap2_spinner_activated, level.trap2_decal_activated);
    thread init_trap(level.trap3_spinner, level.trap3_decal, level.trap3_spinner_activated, level.trap3_decal_activated);
    thread init_trap(level.trap4_spinner, level.trap4_decal, level.trap4_spinner_activated, level.trap4_decal_activated);
    thread init_trap(level.trap5_spinner, level.trap5_decal, level.trap5_spinner_activated, level.trap5_decal_activated);
    thread init_trap(level.trap6_spinner, level.trap6_decal, level.trap6_spinner_activated, level.trap6_decal_activated);
    thread init_trap(level.trap7_spinner, level.trap7_decal, level.trap7_spinner_activated, level.trap7_decal_activated);
}

init_trap(spinner, decal, spinneract, decalact)
{
    spinner notSolid();
    spinneract notSolid();

    decal notSolid();
    decalact notSolid();

    spinneract hide();
    decalact hide();

    spinner thread slowspin();
    spinneract thread fastspin();
}

slowspin()
{
    while(isDefined(self))
    {
        self rotateYaw (360,4);
        wait 4;
    }
}

fastspin()
{
    self hide();

    while(isDefined(self))
    {
        self rotateYaw (360,0.5);
        wait 0.5;
    }
}

trap1()
{
	trap_1 = getEnt("trap1_1","targetname");
    trap_1_plants = getEntArray("trap1_1_plants","targetname");
    trap_2 = getEnt("trap1_2","targetname");
    trap_2_plants = getEntArray("trap1_2_plants","targetname");
    trap_3 = getEnt("trap1_3","targetname");
    trap_3_plants = getEntArray("trap1_3_plants","targetname");

	trap_trig = getEnt("trap1_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap1_decal delete();
    level.trap1_spinner delete();

    level.trap1_decal_activated show();
    level.trap1_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    trap_1_plants[0] enableLinkTo();
    trap_1_plants[1] enableLinkTo();
    trap_1_plants[2] enableLinkTo();

    trap_2_plants[0] enableLinkTo();
    trap_2_plants[1] enableLinkTo();

    trap_3_plants[0] enableLinkTo();
    trap_3_plants[1] enableLinkTo();
    trap_3_plants[2] enableLinkTo();
    
    trap_1_plants[0] linkTo(trap_1);
    trap_1_plants[1] linkTo(trap_1);
    trap_1_plants[2] linkTo(trap_1);

    trap_2_plants[0] linkTo(trap_2);
    trap_2_plants[1] linkTo(trap_2);

    trap_3_plants[0] linkTo(trap_3);
    trap_3_plants[1] linkTo(trap_3);
    trap_3_plants[2] linkTo(trap_3);

    trap_1 movez(-200, 1);
    trap_3 movez(-200, 1);

    wait 1;

    while(1)
    {
        trap_1 movez(200, 1);
        trap_2 movez(-200, 1);
        trap_3 movez(200, 1);
        wait 1;
        trap_1 movez(-200, 1);
        trap_2 movez(200, 1);
        trap_3 movez(-200, 1);
        wait 1;
    }
}

trap2()
{
	trap = getEnt("trap2","targetname");
	trap_trig = getEnt("trap2_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap2_decal delete();
    level.trap2_spinner delete();

    level.trap2_decal_activated show();
    level.trap2_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    while(1)
    {
        trap rotatePitch(1080, 3);
        trap waittill("rotatedone");
        wait 3;
    }
}

trap3()
{
	trap = getEnt("trap3","targetname");
    trap_plants = getEntArray("trap3_plants","targetname");
	trap_trig = getEnt("trap3_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap3_decal delete();
    level.trap3_spinner delete();

    level.trap3_decal_activated show();
    level.trap3_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    trap_plants[0] enableLinkTo();
    trap_plants[1] enableLinkTo();
    trap_plants[2] enableLinkTo();
    trap_plants[3] enableLinkTo();

    trap_plants[0] linkTo(trap);
    trap_plants[1] linkTo(trap);
    trap_plants[2] linkTo(trap);
    trap_plants[3] linkTo(trap);

    trap moveZ(-1000, 1);
    trap waittill("movedone");
    wait 3;
    trap moveZ(1000, 1);
}

trap4()
{
	trap = getEnt("trap4","targetname");
	trap_trig = getEnt("trap4_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap4_decal delete();
    level.trap4_spinner delete();

    level.trap4_decal_activated show();
    level.trap4_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    trap delete();
}

trap5()
{
	trap_1 = getEnt("trap5_1","targetname");
    trap_1_plants = getEntArray("trap5_1_plants","targetname");
    trap_2 = getEnt("trap5_2","targetname");
    trap_2_plants = getEnt("trap5_2_plants","targetname");
    trap_3 = getEnt("trap5_3","targetname");
    trap_3_plants = getEnt("trap5_3_plants","targetname");
    trap_4 = getEnt("trap5_4","targetname");
    trap_4_plants = getEnt("trap5_4_plants","targetname");
	trap_trig = getEnt("trap5_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap5_decal delete();
    level.trap5_spinner delete();

    level.trap5_decal_activated show();
    level.trap5_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    trap_1_plants[0] enableLinkTo();
    trap_1_plants[1] enableLinkTo();
    trap_2_plants enableLinkTo();
    trap_3_plants enableLinkTo();
    trap_4_plants enableLinkTo();

    trap_1_plants[0] linkTo(trap_1);
    trap_1_plants[1] linkTo(trap_1);
    trap_2_plants linkTo(trap_2);
    trap_3_plants linkTo(trap_3);
    trap_4_plants linkTo(trap_4);


    while(1)
    {
        trap_1 rotateYaw (1800,4);
        trap_4 rotateYaw (1800,4);
		trap_1 waittill("rotatedone");
        trap_2 rotateYaw (1800,4);
        trap_3 rotateYaw (1800,4);
        trap_2 waittill("rotatedone");
    }
}

trap6()
{
	trap_1 = getEnt("trap6_1","targetname");
    trap_2 = getEnt("trap6_2","targetname");
	trap_trig = getEnt("trap6_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap6_decal delete();
    level.trap6_spinner delete();

    level.trap6_decal_activated show();
    level.trap6_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    if(randomInt(2) == 0)
    {
        level.missing_container = 1;
        trap_1 moveto((trap_1.origin[0],trap_1.origin[1],-650),2);
    }
    else
    {
        level.missing_container = 2;
        trap_2 moveto((trap_2.origin[0],trap_2.origin[1],-650),2);
    }
}

trap7()
{
	trap_1 = getEnt("trap7_1","targetname");
    trap_2 = getEnt("trap7_2","targetname");
	trap_trig = getEnt("trap7_trig","targetname");
	
	trap_trig waittill("trigger",player);

    player playLocalSound("switch_activate");

    level.trap7_decal delete();
    level.trap7_spinner delete();

    level.trap7_decal_activated show();
    level.trap7_spinner_activated show();

	trap_trig setHintString ("[^4Trap activated!^7]");

    if(randomInt(2) == 0)
    {
        trap_1 moveZ(-1000,2);
        trap_1 waittill("movedone");
        trap_1 delete();
    }
    else
    {
        trap_2 moveZ(-1000,2);
        trap_2 waittill("movedone");
        trap_2 delete();
    }
}

/*

  ___       _   _   _     
 | _ ) __ _| |_| |_| |___ 
 | _ \/ _` |  _|  _| / -_)
 |___/\__,_|\__|\__|_\___|
                          
*/

skds_barrier()
{
    if(!level.barrier)
    {
        barrier = getEnt( "barrier_battle", "targetname");

        level thread playSoundOnAllPlayers("barrier_up");
	    barrier movez (256,0.25);
        level.barrier = true;
    }
}


info(msg, submsg)
{
	players = getentarray("player", "classname");
	noti = SpawnStruct();
	noti.titleText = msg;
	noti.notifyText = submsg;
	noti.duration = 5;
	noti.glowcolor = (1,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

sniper()
{
    room = getEnt( "sniper_room", "targetname");
    origin = getEnt( "sniper_origin", "targetname");
    jump = getEnt( "skds_jumper_dest", "targetname" );
    acti = getEnt( "skds_activator_dest", "targetname" );

    while(1)
    {
            room waittill( "trigger", player );
            
            if(!level.inroom)
            {
                ambientPlay("battle"+randomIntRange(1,4),2);

                level.inroom = true;

                player thread teleportplayer(origin,jump,true);
                player TakeAllWeapons(); 
                player GiveWeapon( "m40a3_mp" );
                player giveMaxAmmo( "m40a3_mp" );
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );
                player switchToWeapon( "m40a3_mp" );
                player.health = 100;
                
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
                {
                    level.activ thread teleportplayer(level.activ,acti,true);
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m40a3_mp" );
                    level.activ giveMaxAmmo( "m40a3_mp" );
                    level.activ GiveWeapon( "remington700_mp" );
                    level.activ giveMaxAmmo( "remington700_mp" );
                    level.activ switchToWeapon( "m40a3_mp" );
                    level.activ.health = 100;   
                }
                    
                wait 0.05;
                
                info("Sniper Room", player.name + " ^1VS ^7" + level.activ.name);
                wait 3;
                thread skds_barrier();
                player iPrintlnBold( "^13" );
                level.activ iPrintlnBold( "^13" );
                wait 1;
                player iPrintlnBold( "^32" );
                level.activ iPrintlnBold( "^32" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^2GO^7!" );
                level.activ iPrintlnBold( "^2GO^7!" );
                player freezecontrols(0);
                level.activ freezecontrols(0);
                
                while( isAlive( player ) && isDefined( player ) ) 
                    wait 0.05;

                ambientPlay(level.music[level.selectedmusicid]["alias"],2);
                iPrintlnBold( player.name + " ^5died during a sniper fight!" );
                iPrintlnBold( "^2Endroom is now free!" );
                level.inroom = false;
            }
        }
}

knife()
{
    room = getEnt( "knife_room", "targetname");
    origin = getEnt( "knife_origin", "targetname");
    jump = getEnt( "skds_jumper_dest", "targetname" );
    acti = getEnt( "skds_activator_dest", "targetname" );

    while(1)
    {
            room waittill( "trigger", player );
            
            if(!level.inroom)
            {
                ambientPlay("battle"+randomIntRange(1,4),2);

                level.inroom = true;

                player thread teleportplayer(origin,jump,true);
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player.health = 100;
                
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
                {
                    level.activ thread teleportplayer(level.activ,acti,true);
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ.health = 100;   
                }
                    
                wait 0.05;
                
                info("Knife Room", player.name + " ^1VS ^7" + level.activ.name);
                wait 3;
                thread skds_barrier();
                player iPrintlnBold( "^13" );
                level.activ iPrintlnBold( "^13" );
                wait 1;
                player iPrintlnBold( "^32" );
                level.activ iPrintlnBold( "^32" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^2GO^7!" );
                level.activ iPrintlnBold( "^2GO^7!" );
                player freezecontrols(0);
                level.activ freezecontrols(0);
                
                while( isAlive( player ) && isDefined( player ) ) 
                    wait 0.05;

                ambientPlay(level.music[level.selectedmusicid]["alias"],2);
                iPrintlnBold( player.name + " ^5died during a knife fight!" );
                iPrintlnBold( "^2Endroom is now free!" );
                level.inroom = false;
            }
        }
}

deagle()
{
    room = getEnt( "deagle_room", "targetname");
    origin = getEnt( "deagle_origin", "targetname");
    jump = getEnt( "skds_jumper_dest", "targetname" );
    acti = getEnt( "skds_activator_dest", "targetname" );

    while(1)
    {
            room waittill( "trigger", player );
            
            if(!level.inroom)
            {
                ambientPlay("battle"+randomIntRange(1,4),2);

                level.inroom = true;

                player thread teleportplayer(origin,jump,true);
                player TakeAllWeapons(); 
                player GiveWeapon( "deserteaglegold_mp" );
                player giveMaxAmmo( "deserteaglegold_mp" );
                player switchToWeapon( "deserteaglegold_mp" );
                player.health = 100;
                
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
                {
                    level.activ thread teleportplayer(level.activ,acti,true);
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "deserteaglegold_mp" );
                    level.activ giveMaxAmmo( "deserteaglegold_mp" );
                    level.activ switchToWeapon( "deserteaglegold_mp" );
                    level.activ.health = 100;   
                }
                    
                wait 0.05;
                
                info("Deagle Room", player.name + " ^1VS ^7" + level.activ.name);
                wait 3;
                thread skds_barrier();
                player iPrintlnBold( "^13" );
                level.activ iPrintlnBold( "^13" );
                wait 1;
                player iPrintlnBold( "^32" );
                level.activ iPrintlnBold( "^32" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^2GO^7!" );
                level.activ iPrintlnBold( "^2GO^7!" );
                player freezecontrols(0);
                level.activ freezecontrols(0);
                
                while( isAlive( player ) && isDefined( player ) ) 
                    wait 0.05;

                ambientPlay(level.music[level.selectedmusicid]["alias"],2);
                iPrintlnBold( player.name + " ^5died during a deagle fight!" );
                iPrintlnBold( "^2Endroom is now free!" );
                level.inroom = false;
            }
        }
}

bounce()
{
    room = getEnt( "bounce_room", "targetname");
    origin = getEnt( "bounce_origin", "targetname");
    jump = getEnt( "bounce_jumper_dest", "targetname" );
    acti = getEnt( "bounce_activator_dest", "targetname" );

    while(1)
    {
            room waittill( "trigger", player );
            
            if(!level.inroom)
            {
                ambientPlay("battle"+randomIntRange(1,4),2);
                
                level.inroom = true;

                player thread teleportplayer(origin,jump,true);
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player.health = 100;
                player.hassniper = false;
                
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
                {
                    level.activ thread teleportplayer(level.activ,acti,true);
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ.health = 100;   
                    level.activ.hassniper = false;
                }
                    
                wait 0.05;
                
                info("Bounce Room", player.name + " ^1VS ^7" + level.activ.name);
                wait 3;
                player iPrintlnBold( "^13" );
                level.activ iPrintlnBold( "^13" );
                wait 1;
                player iPrintlnBold( "^32" );
                level.activ iPrintlnBold( "^32" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^2GO^7!" );
                level.activ iPrintlnBold( "^2GO^7!" );
                player freezecontrols(0);
                level.activ freezecontrols(0);
                
                while( isAlive( player ) && isDefined( player ) ) 
                    wait 0.05;

                ambientPlay(level.music[level.selectedmusicid]["alias"],2);
                iPrintlnBold( player.name + " ^5died during a bounce fight!" );
                iPrintlnBold( "^2Endroom is now free!" );
                level.inroom = false;
            }
        }
}

strafe()
{
    room = getEnt( "strafe_room", "targetname");
    origin = getEnt( "strafe_origin", "targetname");
    jump = getEnt( "strafe_jumper_dest", "targetname" );
    acti = getEnt( "strafe_activator_dest", "targetname" );

    while(1)
    {
            room waittill( "trigger", player );
            
            if(!level.inroom)
            {
                level.other = player;

                ambientPlay("battle"+randomIntRange(1,4),2);
                
                level.inroom = true;

                player thread teleportplayer(origin,jump,true);
                player TakeAllWeapons(); 
                player GiveWeapon( "deserteaglegold_mp" );
                player giveMaxAmmo( "deserteaglegold_mp" );
                player switchToWeapon( "deserteaglegold_mp" );
                player.health = 100;
                player.hassniper = false;
                
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
                {
                    level.activ thread teleportplayer(level.activ,acti,true);
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "deserteaglegold_mp" );
                    level.activ giveMaxAmmo( "deserteaglegold_mp" );
                    level.activ switchToWeapon( "deserteaglegold_mp" );
                    level.activ.health = 100;   
                    level.activ.hassniper = false;
                }
                    
                wait 0.05;
                
                info("Pure Strafe Room", player.name + " ^1VS ^7" + level.activ.name);
                wait 3;
                player iPrintlnBold( "^13" );
                level.activ iPrintlnBold( "^13" );
                wait 1;
                player iPrintlnBold( "^32" );
                level.activ iPrintlnBold( "^32" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^2GO^7!" );
                level.activ iPrintlnBold( "^2GO^7!" );
                player freezecontrols(0);
                level.activ freezecontrols(0);
                
                while( isAlive( player ) && isDefined( player ) ) 
                    wait 0.05;

                level.other = undefined;
                ambientPlay(level.music[level.selectedmusicid]["alias"],2);
                iPrintlnBold( player.name + " ^5died during a strafe fight!" );
                iPrintlnBold( "^2Endroom is now free!" );
                level.inroom = false;
            }
        }
}

sphero()
{
    room = getEnt( "sphero_room", "targetname");
    origin = getEnt( "sphero_origin", "targetname");
    jump = getEnt( "skds_jumper_dest", "targetname" );
    acti = getEnt( "skds_activator_dest", "targetname" );

    while(1)
    {
            room waittill( "trigger", player );
            
            if(!level.inroom)
            {
                ambientPlay("battle"+randomIntRange(1,4),2);

                level.inroom = true;

                player thread teleportplayer(origin,jump,true);
                player TakeAllWeapons(); 
                player GiveWeapon( "crosscode_mp" );
                player giveMaxAmmo( "crosscode_mp" );
                player switchToWeapon( "crosscode_mp" );
                player.health = 100;
                
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
                {
                    level.activ thread teleportplayer(level.activ,acti,true);
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "crosscode_mp" );
                    level.activ giveMaxAmmo( "crosscode_mp" );
                    level.activ switchToWeapon( "crosscode_mp" );
                    level.activ.health = 100;   
                }
                    
                wait 0.05;
                
                info("Spheromancer Room", player.name + " ^1VS ^7" + level.activ.name);
                wait 3;
                thread skds_barrier();
                player iPrintlnBold( "^13" );
                level.activ iPrintlnBold( "^13" );
                wait 1;
                player iPrintlnBold( "^32" );
                level.activ iPrintlnBold( "^32" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^2GO^7!" );
                level.activ iPrintlnBold( "^2GO^7!" );
                player freezecontrols(0);
                level.activ freezecontrols(0);
                
                while( isAlive( player ) && isDefined( player ) ) 
                    wait 0.05;

                ambientPlay(level.music[level.selectedmusicid]["alias"],2);
                iPrintlnBold( player.name + " ^5died during a spheromancer fight!" );
                iPrintlnBold( "^2Endroom is now free!" );
                level.inroom = false;
            }
        }
}

/*

deflate me :)

eJzLKCkpKLbS189NTU/Uy6vST8vMSdX3Ssk2dE40j1J2CSuzKDB18goMLjZN9EgP8/MKTPEzLXcNt0h08wz2CC4s9svLcQzPDjS3AACKBRgP

*/