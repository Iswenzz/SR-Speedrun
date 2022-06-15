main()
{
level.masterSpawn = spawn("script_origin",(825,368,200));
level.masterSpawn.angles = (0,270,0);
	thread way_connect();
	maps\mp\_load::main();
	level.tweakfile = true;
	VisionSetNaked( "mp_dr_destiny", 0 );
	
	level.randomWeapon = strTok("skorpion_acog;beat_deagle;bo2_minigun;brick_blaster;g3;m21;g36c;g36c_silencer;g36c_reflex;skorpion_reflex;g36c_acog;beretta;dragunov;barrett;m40a3;remington700;remington700_acog;m4;m60e4;deserteagle;usp;colt45;colt44;deserteaglegold;uzi;mp44;mp5;p90;ak74u;rpd;saw;m1014;winchester1200;m16;skorpion;g3_silencer;m4_silencer;uzi_silencer;mp5_silencer;p90_silencer;ak74u_silencer;m16_silencer;g3_acog;m4_acog;m60e4_acog;uzi_acog;mp5_acog;p90_acog;ak74u_acog;rpd_acog;saw_acog;m16_acog;g3_reflex;m4_reflex;m60e4_reflex;uzi_reflex;mp5_reflex;p90_reflex;ak74u_reflex;rpd_reflex;saw_reflex;m16_reflex;",";");
	for(i = 0; i < level.randomWeapon.size; i++)
	thread braxi\_common::loadWeapon(level.randomWeapon[i]);
	
	PrecacheMenu( "musicmenu" );
	PreCacheShellShock( "frag_grenade_mp" );
	PrecacheModel( "playermodel_bo2_farmgirl" );
	PrecacheModel( "viewhands_farmgirl_bo2" );
	PrecacheModel( "playermodel_GTA_IV_NICO" );
	PrecacheModel( "playermodel_terminator" );
	
	brush = getEnt( "final_brush" , "targetname" );
	
	brush movez( -304, .05);   
	
	moon = getEnt( "moon" , "targetname" );
	smoke = getEnt( "smoke" , "targetname" );
	
	level.dayum = loadFx("fire/dayum");
	level.wall_explosion = LoadFX("explosions/wall_explosion_grnd");
	level.barrel_explosion = LoadFX("explosions/large_vehicle_explosion");
	
	level.beatfire = loadFX("fire/destiny_bluefire");
    level.fire2 = loadFX("fire/detiny_beat");
	level.beatfire2 = loadFx("fire/destiny_medblue");
	level.firetrap = loadFx("fire/fire_trap");
	level.beatfire3 = loadFx("fire/destiny_bigblue");
	level.beatfire4 = loadFx("fire/destiny_torch");
	
	level.fire_blue = loadFx("destiny/fire_blue");
	level.fire_blue2 = loadFx("destiny/fire_blue_2");
	level.laser_center = loadFx("destiny/laser_center");
	level.magic_orbs = loadFx("destiny/magic_orbs");
	level.orb_center = loadFx("destiny/orb_center");
	level.orb_explosion = loadFx("destiny/orb_explosion");
	
	level._effect[ "wood" ]	= loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]	= loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ] = loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "fx_fog_zombie_amb" ] = loadfx( "zombies/fx_fog_zombie_amb" );
	level._effect[ "fx_zombie_fog_coast_rolling_lg2" ] = loadfx( "zombies/fx_zombie_fog_coast_rolling_lg2" );
	level._effect[ "moon" ] = loadfx( "zombies/fx_zombie_moon_eclipse2" );
		
     	ent = maps\mp\_utility::createOneshotEffect( "moon" );
     	ent.v[ "origin" ] = ( 1117.5, 2717, 4146.5);
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "moon";
     	ent.v[ "delay" ] = -15;
		
		  ent = maps\mp\_utility::createOneshotEffect( "fx_zombie_fog_coast_rolling_lg2" );
     	ent.v[ "origin" ] = ( 832, -1808, 104 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "fx_zombie_fog_coast_rolling_lg2";
     	ent.v[ "delay" ] = -15;
 
     	ent = maps\mp\_utility::createOneshotEffect( "fx_zombie_fog_coast_rolling_lg2" );
     	ent.v[ "origin" ] = ( 3492, -2984, -439.5 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "fx_zombie_fog_coast_rolling_lg2";
     	ent.v[ "delay" ] = -15;
 
     	ent = maps\mp\_utility::createOneshotEffect( "fx_zombie_fog_coast_rolling_lg2" );
     	ent.v[ "origin" ] = ( 2456.5, -3879, -199.5 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "fx_zombie_fog_coast_rolling_lg2";
     	ent.v[ "delay" ] = -15;
 
     	ent = maps\mp\_utility::createOneshotEffect( "fx_zombie_fog_coast_rolling_lg2" );
     	ent.v[ "origin" ] = ( 429, -3856.5, -199.5 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "fx_zombie_fog_coast_rolling_lg2";
     	ent.v[ "delay" ] = -15;
 
     	ent = maps\mp\_utility::createOneshotEffect( "fx_zombie_fog_coast_rolling_lg2" );
     	ent.v[ "origin" ] = ( -1329, -3877.5, -929.5 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "fx_zombie_fog_coast_rolling_lg2";
     	ent.v[ "delay" ] = -15;
	
	thread elev();
	thread effects();
	thread bounce_brush();
	thread deagle_secret();
	// thread gravity();
	thread fail1();
	thread fail2();
	thread b_beat();
	// thread derpy();
	thread fail3();
	thread fail4();
	thread fail5();
	thread fail6();
	thread fail7();
	thread fail8();
	// thread finalfight();
	thread trap1();
	// thread ammo2();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap6();
	thread trap5();
	thread trap7();
	thread trap9();
	thread elev2();
	thread door();
	// thread mapmenu();
	// thread shortcut();
	// thread weapons();
	// thread snip();
	// thread knife();
	// thread finalend_main();
	// thread games();
	thread lazers();
	thread shell();
	thread beat_is_sexy();
	thread lossy_iz_a_kent();
	// thread classic();
	thread bouncerespawn();
	// thread deagle();
	// thread jump();
	// thread bounceweap();
	thread movegun();
	thread door2();
	thread sad_moon();
	thread trap10();
	// thread ranks();
	thread ammo();
	// addTriggerToList("trigger1");
    // addTriggerToList("trigger2");
    // addTriggerToList("trigger3");
	// addTriggerToList("trigger4");
	// addTriggerToList("trigger5");
	// addTriggerToList("trigger6");
	// addTriggerToList("trigger7");
    // addTriggerToList("trigger8");
    // addTriggerToList("trigger9");
	// addTriggerToList("trigger10");
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("r_distortion", " 1");
	
	setExpFog(1000, 1000, 0, 0, 0, 0.2);
	VisionSetNaked( "mp_dr_destiny", 0 );

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
	thread secret_1();
	
    for(;;) 
    {
        level waittill( "connected", player );
        
    }
}

secret_1()
{
	target = getEnt ("enter_secret", "targetname");
	trigger = spawn( "trigger_radius", (602.763, 288.455, 192.625), 0, 70, 90 );
	
	wait 1;
	trigger.inAir = true;
	trigger.radius = 70;
	thread sr\api\_map::createTriggerFx(trigger, "secret");
	
	while(1)
	{
		trigger waittill ("trigger", player);
	
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
		player sr\api\_speedrun::changeWay("secret_0");
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

ammo()
{
	trig = getEnt( "ammo_snip", "targetname" );
	
	while(1)
	{
		trig waittill( "trigger", player );
		
		player giveMaxAmmo( "m40a3_mp" );
		player giveMaxAmmo( "remington700_mp" );
		wait 0.05;
	}
}

ammo2()
{
	trig = getEnt( "ammo_grav", "targetname" );
	
	while(1)
	{
		trig waittill( "trigger", player );
		
		player giveMaxAmmo( "ak74u_mp" );
		player giveMaxAmmo( "deserteagle_mp" );
		wait 0.05;
	}
}

sad_moon()
{
	trig = getEnt ( "sad_moon", "targetname" );
	
	trig waittill( "trigger", player );
	
	player iPrintlnBold ( "^5You made ^2Mr.Moon ^5sad ^1:[ " );
	
	wait 2;
	
	// player sayall( "^5OUCH^1!!!" );
	
	for(i=50; i>=0; i--)
	{
		player braxi\_common::bounce( player.origin -(0,0,0.1), 80 );
		wait (0.05);
	}
}

shortcut()
{
	trig_start = getEnt ( "shortcut" , "targetname" );

	trig_start waittill( "trigger", player );
	iPrintlnBold( " ^2" + player.name + " ^5Found a Shortcut^1! " );         
}

bouncerespawn()
{
	trig = getent("bounce_tele", "targetname");
	jump = getEnt( "jump_bounce", "targetname" );
	acti = getEnt( "acti_bounce", "targetname" );

	for(;;)
	{
		trig waittill( "trigger", player );
		if(player.pers["team"] == "axis")
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
		}
		if(player.pers["team"] == "allies")
		{
			player setplayerangles( jump.angles, 3 );
			player setorigin( jump.origin, 3 );
		}
	}
}

effects()
{
	fire = getEntArray( "main_fire", "targetname" );
	sexy_fire = getEntArray( "sexy_fire", "targetname" );
	fx_knife = getEntArray( "knife_fx" , "targetname" );

	for(i=0;i<fire.size;i++)
    {
		playLoopedFX(level.beatfire4, 0.05, fire[i].origin);
	}
	for(i=0;i<sexy_fire.size;i++)
    {
		playLoopedFX(level.beatfire2, 0.05, sexy_fire[i].origin);
	}
	for(i=0;i<fx_knife.size;i++)
	{	
		playLoopedFX( level.fire_blue, 0.05, fx_knife[i].origin);
	}
}

ambientmenu()
{
        self endon( "disconnect" );
        self endon( "death" );
		
		self openmenu( "musicmenu" );
       
        friend = getSubStr(self getGuid(), 24, 32);
       
        level.sexy1 = "b5296a81";
		level.sexy2 = "abeb6251";
		level.sexy3 = "49103803";
        level.sexy4 = "fb93ac5f";
        level.sexy5 = "acb016f3";
        level.sexy6 = "7fd24f5f";
        level.sexy7 = "6547f97b";
        level.sexy8 = "0ad1c9af";
        level.sexy9 = "006d463d";
		level.sexy10 = "baffff10";
		level.sexy11 = "38f9bc76"; //triton
		level.sexy12 = "4de6257d"; //grezwal
        while(1)
        {
                self waittill("menuresponse",menu,response);
 
                switch(response)
                {
                        case "nosong":
								self PlayLocalSound( "nothing" );
								wait 0.05;
                                break;
                                       
                        case "song1":
                                self PlayLocalSound( "song1" );
                                wait 0.05;
                                break;
                                       
                        case "song2":
                                self PlayLocalSound( "song2" );
                                wait 0.05;
                                break;
                                       
                        case "song3":
                                self PlayLocalSound( "song3" );
                                wait 0.05;     
                                break;
                                       
                        case "nomodel":
						
								if((friend == level.sexy1) || (friend == level.sexy2) || (friend == level.sexy3) || (friend == level.sexy4) || (friend == level.sexy5) || (friend == level.sexy6) || (friend == level.sexy7) || (friend == level.sexy8) || (friend == level.sexy9) || (friend == level.sexy10) || (friend == level.sexy11) || (friend == level.sexy12))
								{
									id = self getStat( 980 );
									self detachAll();
									wait 0.05;
									self setModel( level.characterInfo[id]["model"] );
									self setViewModel( "viewmodel_hands_zombie" );
								}
								else
								{
									self iPrintlnBold( "^1You do not have access to this option!" );
								}
                                break;
                                       
                        case "model1":
								if((friend == level.sexy1) || (friend == level.sexy2) || (friend == level.sexy3) || (friend == level.sexy4) || (friend == level.sexy5) || (friend == level.sexy6) || (friend == level.sexy7) || (friend == level.sexy8) || (friend == level.sexy9) || (friend == level.sexy10) || (friend == level.sexy11) || (friend == level.sexy12))
								{
									self detachAll();
									wait 0.05;
									self setModel( "playermodel_GTA_IV_NICO" );
									self SetViewModel( "viewmodel_hands_zombie" );
								}
								else
								{
									self iPrintlnBold( "^1You do not have access to this option!" );
								}
                                break;
                                       
                        case "model2":
								if((friend == level.sexy1) || (friend == level.sexy2) || (friend == level.sexy3) || (friend == level.sexy4) || (friend == level.sexy5) || (friend == level.sexy6) || (friend == level.sexy7) || (friend == level.sexy8) || (friend == level.sexy9) || (friend == level.sexy10) || (friend == level.sexy11) || (friend == level.sexy12))
								{
									self detachAll();
									wait 0.05;
									self SetViewModel( "viewmodel_hands_zombie" );
									self SetModel( "playermodel_terminator" );
								}
								else
								{
									self iPrintlnBold( "^1You do not have access to this option!" );
								}
                                break;
                                       
                        case "model3":
								if((friend == level.sexy1) || (friend == level.sexy2) || (friend == level.sexy3) || (friend == level.sexy4) || (friend == level.sexy5) || (friend == level.sexy6) || (friend == level.sexy7) || (friend == level.sexy8) || (friend == level.sexy9) || (friend == level.sexy10) || (friend == level.sexy11) || (friend == level.sexy12))
								{
									self detachAll();
									wait 0.05;
									self SetViewModel( "viewhands_farmgirl_bo2" );
									self SetModel( "playermodel_bo2_farmgirl" );
								}
								else
								{
									self iPrintlnBold( "^1You do not have access to this option!" );
								}
                                break;
                }
        }
}

lossy_iz_a_kent()
{
	trig = getEnt ("end_secret", "targetname");
	target = getEnt ("end_secret_ori", "targetname");
	
	trig setHintString( "Press ^3[Use]^7 to teleport back to the map." );
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	 player thread sr\api\_speedrun::finishWay("secret_0");
	}
	wait .1;
}


beat_is_sexy()
{
	trig = getEnt ("entersecret", "targetname");
	target = getEnt ("enter_secret", "targetname");
	
	trig delete();
	wait .1;
}
	

getAllPlayers()
{
	return getEntArray( "player", "classname" );
}

isReallyAlive()
{
	return self.sessionstate == "playing";
}
 
isPlaying()
{
	return isReallyAlive();
}

finalfight()
{
	ori = getEnt( "fina_orithing" , "targetname" );
	brush = getEnt( "final_brush" , "targetname" );
	trig = getEnt( "finalend" , "targetname" );
	trig enablelinkto();
	trig linkTo(ori);
	
    while(1)
    {
		wait .05;
        if(GetTeamPlayersAlive("allies") != 1 || GetTeamPlayersAlive("axis") != 1)
        continue;
		iPrintln( "^5Final Fight Unlocked^1! " );
		brush movez( 304, 3.5);   
		ori movez( 304, 3.5);               
        break;
    }
}	

movegun()
{
	self endon( "bounce_gun" );
	model = getEnt ("minigun_model", "targetname");
	
	while(1)
	{
		model movez( -5 , .75);
		wait .75;
		model movez( 5, .75);
		wait .75;
	}
}

bounceweap()
{
	trig = getEnt( "peace_trig", "targetname" );
	peace_ori = getEnt( "peace_ori", "targetname" );
	model = getEnt( "minigun_model", "targetname" );
	
	trig setHintString( "Press ^3[Use] ^7to pick up the Minigun!" );
	
	trig waittill("trigger", player);
		
	player takeallweapons();	
	player GiveWeapon( "bo2_minigun_mp" );
	player GiveMaxAmmo( "bo2_minigun_mp" );
	wait 0.05;
	player switchToWeapon( "bo2_minigun_mp");
	iPrintlnBold( " ^2" + player.name + " ^5Picked up the Minigun^1!" );
	
	trig delete();
	model delete();
	peace_ori delete();
	
	self notify( "bounce_gun" );
}
mapmenu()
{
		menu = getent("musicmenu", "targetname");
       
        while(1)
        {
            menu waittill ( "trigger", player );
            player thread ambientmenu();
        }
}

deagle()
{
	level.deagle_trig = getent("deagle","targetname");
    jump = getEnt( "jump_deagle", "targetname" );
    acti = getEnt( "acti_deagle", "targetname" );
	while(1)
	{
		level.deagle_trig waittill("trigger", player);
		if( !isDefined( level.deagle_trig ))
        	return;
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );	
		player GiveMaxAmmo( "deserteagle_mp" );	
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );	
		level.activ GiveMaxAmmo( "deserteagle_mp" );           
        wait 0.05;
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Deagle Room^1!" );    
		wait 2;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^55" );
		level.activ iPrintlnBold( "^55" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^54" );
		level.activ iPrintlnBold( "^54" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 2;
		braxi\_common::cleanScreen();
	}
}

bounce_brush()
{
	brush = getEnt( "bounce_brush", "targetname" );
	while(1)
	{
		brush rotatePitch( 360, 4, 0, 0 );
		wait 4;
	}
}

jump()
{
	level.jump_trig = getent("jump","targetname");
    jump = getEnt( "jump_bounce", "targetname" );
    acti = getEnt( "acti_bounce", "targetname" );
	while(1)
	{
		level.jump_trig waittill("trigger", player);
		if( !isDefined( level.jump_trig ))
        	return;
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );	
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );	        
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Jump Room^1!" );    
		wait 2;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^55" );
		level.activ iPrintlnBold( "^55" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^54" );
		level.activ iPrintlnBold( "^54" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Jump^1!" );
		level.activ iPrintlnBold( "^5Jump^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 2;
		braxi\_common::cleanScreen();
	}
}

touching(ent)
{
	level endon("game_ended");
	while(1)
	{
		players = getEntArray("player","classname");	
		for(i = 0; i < players.size; i++)
		{
			if(players[i] isTouching(ent))
				players[i] suicide();
		}
		wait .05;
	}
}	

derpy()
{
	level.derp_trig = getent("trollroom","targetname");
    jump = getEnt( "troll_jump", "targetname" );
    acti = getEnt( "troll_acti", "targetname" );
	brush = getEnt( "thingy_retard", "targetname" );
	while(1)
	{
		level.derp_trig waittill("trigger", player);
		if( !isDefined( level.derp_trig ))
        	return;
			
		// player setGravity(5);
		// level.activ setGravity(5);
			
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "bo2_minigun_mp" );
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "bo2_minigun_mp" );
        wait 0.05;
		player freezecontrols(true); 
		level.activ freezecontrols(true);
        player switchToWeapon( "bo2_minigun_mp" );
        level.activ SwitchToWeapon( "bo2_minigun_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Confusing Minigun Room^1!" );  
		wait 2;
		braxi\_common::cleanScreen();
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		
		while(1)
		{
			brush rotateroll (360,2);
			brush waittill ("rotatedone");
		}
	}
}	

snip()
{
	level.snip_trig = getent("sniper","targetname");
    jump = getEnt( "jump_snip", "targetname" );
    acti = getEnt( "snip_acti", "targetname" );
	while(1)
	{
		level.snip_trig waittill("trigger", player);
		if( !isDefined( level.snip_trig ))
        	return;
			
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" );
		player GiveWeapon( "remington700_mp" );
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveWeapon( "remington700_mp" );		
        wait 0.05;
		player freezecontrols(true); 
		level.activ freezecontrols(true);
        player switchToWeapon( "m40a3_mp" );
        level.activ SwitchToWeapon( "m40a3_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Sniper Room^1!" );  
		wait 2;
		braxi\_common::cleanScreen();
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 2;
		braxi\_common::cleanScreen();
	}
}
classic()
{
	level.old_trig = getEnt ("oldway" , "targetname");
   	brush = getEnt ("old_door1" ,"targetname" );
	if( !isDefined( level.freeRun ) )
	wait 0.1;

	if( isDefined( level.freeRun ) && level.freeRun )
	{

		level.games_trig delete();
		level.old_trig delete();
		return;
	}
   	level.old_trig waittill ("trigger",player);
	level.old_trig delete();
	level.games_trig delete();

	iPrintlnBold( " ^2" + player.name + " ^5 has entered the Classic way^1!" );    
   
   	brush moveZ ( -600 , 4);
}

door2()
{
	trig = getEnt( "door2_trig" , "targetname" );
	brush = getEnt ("old_door2" ,"targetname" );

	wait 1;
	
	trig delete();
	
	wait 1.5;
	
	brush moveZ( -600, 4);
}
gravity()
{
	level.grav_trig = getent("gravity","targetname");
    jump = getEnt( "grav_jump", "targetname" );
    acti = getEnt( "grav_acti", "targetname" );
	while(1)
	{
		level.grav_trig waittill("trigger", player);
		if( !isDefined( level.grav_trig ))
        	return;
			
		// player setJumpHeight(500);
		// level.activ setJumpHeight(500);
		// player setGravity(300);
		// level.activ setGravity(300);
			
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "ak74u_mp" );
		player GiveWeapon( "deserteagle_mp" );
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "ak74u_mp" );
		level.activ GiveWeapon( "deserteagle_mp" );		
        wait 0.05;
		player freezecontrols(true); 
		level.activ freezecontrols(true);
        player switchToWeapon( "ak74u_mp" );
        level.activ SwitchToWeapon( "ak74u_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Low Gravity Room^1!" );  
		wait 2;
		braxi\_common::cleanScreen();
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 2;
		braxi\_common::cleanScreen();
	}
}

b_beat()
{
	trig = getEnt ( "acti_secret" , "targetname" );
	ori = getEnt ( "secret_ori_link" , "targetname" );
	secret = getEnt( "entersecret" , "targetname" );
	trig setHintString( "^5Watcha doin^1' ^5in here^1?!?" );
	
	secret enableLinkTo();
	secret LinkTo(ori);
	
	wait 1;
	// trig waittill("trigger", player);
	
	trig delete();
	
	// player iPrintln( "^5Go away^1!" );
	
	ori moveY( 80, 0.05 );
}
	
	
knife()
{
	level.knife_trig = getent("knife","targetname");
    jump = getEnt( "acti_knife", "targetname" );
    acti = getEnt( "jump_knife", "targetname" );
	fire_fx = getEnt( "knife_fire", "targetname" );
	
	while(1)
	{
		level.knife_trig waittill("trigger", player);
		if( !isDefined( level.knife_trig ) && isDefined( level.activ ) && isAlive( level.activ ) )
        	return;
			
		playLoopedFX( level.fire_blue2, 0.05, fire_fx.origin);
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );	
	
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );	             
        wait 0.05;
		player freezecontrols(true); 
		level.activ freezecontrols(true);
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Knife Room^1!" );  
		wait 2;
		braxi\_common::cleanScreen();
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 2;
		braxi\_common::cleanScreen();
	}
}

lazers()
{
	lazer1 = getEnt( "lazer1", "targetname" );
	lazer2 = getEnt( "lazer2", "targetname" );
	
	lazer1 notsolid();
	lazer2 notsolid();
	
	thread touching(lazer1);
	thread touching(lazer2);
	while(1)
	{
		lazer1 moveZ(74,.8,.2,.2);
		lazer2 moveZ(-74,.8,.2,.2);
		wait .9+randomFloat(1.1);
		lazer1 moveZ(-74,.8,.2,.2);
		lazer2 moveZ(74,.8,.2,.2);
		wait .9+randomFloat(1.1);
	}
}

weapons()
{
	level.gun_trig = getent("weapon","targetname");
    jump = getEnt( "weap_jump", "targetname" );
    acti = getEnt( "weap_acti", "targetname" );
	while(1)
	{
		level.gun_trig waittill("trigger", player);
		if( !isDefined( level.gun_trig ) && isDefined( level.activ ) && isAlive( level.activ ) )
        	return;
			
		randomgun = level.randomWeapon[randomInt(level.randomWeapon.size)]+"_mp";
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( randomgun );	
		player GiveMaxAmmo( randomgun );	
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( randomgun );	
		level.activ GiveMaxAmmo( randomgun );	           
        wait 0.05;
        player switchToWeapon( randomgun );
        level.activ SwitchToWeapon( randomgun );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Weapons Room^1!" );
		wait 2;
		braxi\_common::cleanScreen();
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		braxi\_common::cleanScreen();
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 2;
		braxi\_common::cleanScreen();
	}
}

ranks()
{
	rank_trig = getEnt("first", "targetname");

	rank_trig waittill("trigger", player);
	
	iPrintlnBold("^2 "+  player.name + "^5 has finished in first place^1!");
}

finalend_main()
{
	level.final_trig = getent("finalend","targetname");
    jump = getEnt( "final_jump", "targetname" );
    acti = getEnt( "final_acti", "targetname" );

	while(1)
	{
		level.final_trig waittill("trigger", player);
		if( !isDefined( level.final_trig ))
        	return;
			
		ambientplay( "final" );
		
		// player setJumpHeight(500);
		// level.activ setJumpHeight(500);
			
		player PlayLocalSound( "nothing" );
		level.activ PlayLocalSound( "nothing" );

		VisionSetNaked( "final_end", 4 );
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );	
		player GiveMaxAmmo( "deserteagle_mp" );
		level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );
		level.activ GiveMaxAmmo( "deserteagle_mp" );
		thread final_end();
        wait 0.05;
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Final End^1!" );    
		wait 4;
		braxi\_common::cleanScreen();
		wait 14;
		player takeallweapons();
		level.activ takeallweapons();
		wait 0.05;
		player freezecontrols(false); 
		level.activ freezecontrols(false);
		wait 4;
		player giveWeapon( "beat_deagle_mp" );
		level.activ giveWeapon( "beat_deagle_mp" );
		player giveMaxAmmo( "beat_deagle_mp" );
		level.activ giveMaxAmmo( "beat_deagle_mp" );
		player SetSpawnWeapon( "beat_deagle_mp" );
		level.activ SetSpawnWeapon( "beat_deagle_mp" );
	}
}

fail1()
{
	trig = getEnt ("fail1_trig", "targetname");
	target = getEnt ("fail1", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail2()
{
	trig = getEnt ("fail2_trig", "targetname");
	target = getEnt ("fail2", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail3()
{
	trig = getEnt ("fail3_trig", "targetname");
	target = getEnt ("fail3", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail4()
{
	trig = getEnt ("fail4_trig", "targetname");
	target = getEnt ("fail4", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail5()
{
	trig = getEnt ("fail5_trig", "targetname");
	target = getEnt ("fail5", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail6()
{
	trig = getEnt ("fail6_trig", "targetname");
	target = getEnt ("fail6", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail7()
{
	trig = getEnt ("fail7_trig", "targetname");
	target = getEnt ("fail7", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}
fail8()
{
	trig = getEnt ("fail8_trig", "targetname");
	target = getEnt ("fail8", "targetname");
	
	while(1)
	{
		trig waittill ("trigger", player);
		
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
	}
	wait .1;
}

final_end()
{
	fire_blue_ori = getEntArray( "fire_blue_final", "targetname");
	laser_center_ori = getEnt( "laser_center", "targetname" );
	orb_center_ori = getEnt( "orb_center", "targetname" );
	orb_explosion_ori = getEnt( "orb_explosion", "targetname" );
	magic_orbs_ori = getEntArray( "magic_orbs", "targetname" );
	door_1 = getEnt( "door_1", "targetname" );
	door_2 = getEnt( "door_2", "targetname" );
	full_clip = getEnt( "final_full", "targetname" );
	
	
	for(i=0;i<fire_blue_ori.size;i++)
    {
		playLoopedFX( level.fire_blue, 0.05, fire_blue_ori[i].origin);
	}
	
	wait 10;
	
	door_1 movex( 408 , 5);
	door_2 movex( -408 , 5);
	
	wait 1.5;
	
	FX_1 = spawnFX( level.laser_center, laser_center_ori.origin );
	TriggerFx( FX_1 );
	
	wait 2.3;
	
	FX_2 = spawnFX( level.orb_center, orb_explosion_ori.origin );
	TriggerFx( FX_2 );
	wait 4;
	FX_2 delete();
	
	FX_3 = spawnFX( level.orb_explosion, orb_explosion_ori.origin );
	TriggerFx( FX_3 );
	full_clip delete();
	
	wait 1;
	
	for(i=0;i<magic_orbs_ori.size;i++)
    {
		playLoopedFX( level.magic_orbs, 0.05, magic_orbs_ori[i].origin);
	}
}
	
games()
{
     	level.games_trig = getEnt( "minigames", "targetname");
		org = getent("ori_end1","targetname");
		org1 = getent("ori_end2","targetname");
     
     	while(1)
     	{
         	level.games_trig waittill( "trigger", player );
         	if( !isDefined( level.games_trig ) )
         	return;
			
		// player setJumpHeight(39);
		// level.activ setJumpHeight(39);
		// player setGravity(800);
		// level.activ setGravity(800);
			
		level.old_trig delete();

		level.games_trig SetHintstring ("^1Please wait!");
		
		origin = Spawn("script_origin", player.origin);
		
		player linkto(origin);
		
		origin moveto(org.origin, .5);
		
		origin waittill ("movedone");
		
		origin moveto(org1.origin, 1.5);
		
		origin waittill ("movedone");
		
		player unlink();
		
		origin delete();


	 	iPrintlnBold( " ^2" + player.name + " ^5 has entered the endgames section^1!" );
        player TakeAllWeapons();
	 	player died();
		wait 1;
	
	             
         	while( isAlive( player ) && isDefined( player ) )
             	wait 1;
     	}
}

deagle_secret()
{
	trig = getEnt( "deagle_secret" , "targetname" );
	
	trig waittill( "trigger", player );
	
	player giveWeapon( "beat_deagle_mp" );
	
	player giveMaxAmmo( "beat_deagle_mp" );
	
	iPrintlnBold( " ^2" + player.name + " ^5 got dat sexy deagle^1!" );
	
	wait 0.05;
	
	player switchtoWeapon( "beat_deagle_mp" );
}

died()
{
	self endon("disconnect");

	self waittill("death");
	iPrintlnBold("^2"+self.name+" ^5died^1!");
	iPrintlnBold("^5The Endgames Section is now open^1.");
	level.games_trig SetHintstring ("^5Endgames^1!");
}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

trap9()
{
	brush = getEnt ("trap9_oben" ,"targetname" );
	trig = getEnt ("trigger9" , "targetname");
	sound = getEnt( "trap9_sound" , "targetname" );

}

trap5()
{
    fire = getEntArray ("trap5_ori", "targetname");
    hurt = getEnt ("trap5_death", "targetname");
	link = getEnt ("linkto", "targetname");
    trigger = getEnt ("trigger5", "targetname");
	time = RandomIntRange( 1, 3 );
	
	FX = undefined;
	
	hurt enablelinkto();
	hurt linkto(link);
    
 
}

trap6()
{
	trig = getEnt("trigger6" , "targetname" );
	brush1 = getEnt("trap6_1" , "targetname" );
	brush2 = getEnt("trap6_2" , "targetname" );
	brush3 = getEnt("trap6_3" , "targetname" );
	brush4 = getEnt("trap6_4" , "targetname" );
	brush5 = getEnt("trap6_5" , "targetname" );
	brush6 = getEnt("trap6_6" , "targetname" );
	

}

trap1()
{

}	

trap2()
{
	brush = getEnt("trap2" , "targetname" );
	trig = getEnt("trigger2" , "targetname" );
	sound = getEnt( "trap2sound" , "targetname" );
	time = RandomIntRange( 2, 3 );
	brush hide();
	brush notsolid();
	

}

trap4()
{

}

trap7()
{
	trig = getEnt( "trigger7" , "targetname" );
	
	brush = getEnt("trap7_brush","targetname");
	brush notSolid();
	
	brush_origin = brush.origin;
	
}

trap10()
{
	trig = getEnt( "trigger10", "targetname" );
	expori = getEntArray( "trap10_exp", "targetname" );
	sound = getEnt( "trap10_sound", "targetname" );
	clip = getEnt( "barrel_clip", "targetname" );
	barrel = getEnt( "barrel1", "targetname" );
	barrel2 = getEnt( "barrel2", "targetname" );
	barrel3 = getEnt( "barrel3", "targetname" );
	barrel4 = getEnt( "barrel4", "targetname" );
	blah = getEnt( "trap10_death", "targetname" );
	
	barrel delete(); 
	barrel2 delete();
	barrel3 delete();
	barrel4 delete();
	clip delete();
	
	trig delete();
}
	
trap3()
{
	trig = getEnt("trigger3" , "targetname" );
	brush = getEnt("trap_1" , "targetname" );
	brush2 = getEnt("trap_2" , "targetname" );
	brush3 = getEnt("trap_3" , "targetname" );
	brush4 = getEnt("trap_4" , "targetname" );
	brush5 = getEnt("trap_5" , "targetname" );
	

}

dafire2(fire, hurt, link)
{
    fire = getEntArray (fire, "targetname");
    hurt = getEnt (hurt, "targetname");
	link = getEnt (link, "targetname");
	time = RandomIntRange( 2, 3 );
	
	FX = undefined;
	
	hurt enablelinkto();
	hurt linkto(link);
	
	for(i=0;i<fire.size;i++)
    {
		FX[i] = spawnFX( level.beatfire2, fire[i].origin );    
		TriggerFx( FX[i] );
    }
	link moveZ (58,.1);

    wait 2;
		
	link movez (-58,.1);
    for(i=0;i<fire.size;i++)
    {
		FX[i] delete();
    }
}

nr2()
{
    fire = getEntArray ("trap3_2ori", "targetname");
    hurt = getEnt ("trap3_2hurt", "targetname");
	link = getEnt ("linkto2", "targetname");
	
	FX = undefined;
	
	hurt enablelinkto();
	hurt linkto(link);
	
	for(i=0;i<fire.size;i++)
    {
		FX[i] = spawnFX( level.beatfire2, fire[i].origin );    
		TriggerFx( FX[i] );
    }
	link moveZ (58,.1);

    wait 2;
		
	link movez (-58,.1);
    for(i=0;i<fire.size;i++)
    {
		FX[i] delete();
    }
}

nr3()
{
    fire = getEntArray ("trap3_3ori", "targetname");
    hurt = getEnt ("trap3_3hurt", "targetname");
	link = getEnt ("linkto3", "targetname");
	
	FX = undefined;
	
	hurt enablelinkto();
	hurt linkto(link);
	
	for(i=0;i<fire.size;i++)
    {
		FX[i] = spawnFX( level.beatfire2, fire[i].origin );    
		TriggerFx( FX[i] );
    }
	link moveZ (58,.1);

    wait 2;
		
	link movez (-58,.1);
    for(i=0;i<fire.size;i++)
    {
		FX[i] delete();
    }
}


nr5()
{
    fire = getEntArray ("trap3_5ori", "targetname");
    hurt = getEnt ("trap3_5hurt", "targetname");
	link = getEnt ("linkto5", "targetname");
	
	FX = undefined;
	
	hurt enablelinkto();
	hurt linkto(link);
	
	for(i=0;i<fire.size;i++)
    {
		FX[i] = spawnFX( level.beatfire2, fire[i].origin );    
		TriggerFx( FX[i] );
    }
	link moveZ (58,.1);

    wait 2;
		
	link movez (-58,.1);
    for(i=0;i<fire.size;i++)
    {
		FX[i] delete();
    }
}


door()
{
	door = getEnt ("firstwall" , "targetname");
   	trigger = getEnt ("firstwall_trig" ,"targetname" );
	c4_ori = getEnt( "firstwall_ori", "targetname" );
	c4 = getEnt( "firstwall_c4", "targetname" );
	shell = getEnt( "shellshock" , "targetname" );
	obj = getEnt ( "shell_obj" , "targetname" );
	
	wait 1;
	c4 hide();
	// trigger waittill ("trigger",player);
	
	c4 show();
	
	// iPrintln("^5Detonation in^1: ^25");
	// wait 1;
	// iPrintln("^5Detonation in^1: ^24");
	// wait 1;
	// iPrintln("^5Detonation in^1: ^23");
	// wait 1;
	// iPrintln("^5Detonation in^1: ^22");
	// wait 1;
	// iPrintln("^5Detonation in^1: ^21");
	// wait 1;
	
	playFx( level.wall_explosion, c4_ori.origin );
	c4_ori PlaySound("exp_suitcase_bomb_stereo");
   
	door delete();
	trigger delete();
	c4 delete();
	
	shell enablelinkto();
	shell linkto(obj);
	
	obj moveZ( 104, 0.05 );
	wait .8;
	obj moveZ( -104, 0.05 );
}

shell()
{
	shell = getEnt( "shellshock" , "targetname" );
	
	while(1)
	{
		shell waittill ("trigger", player );
		player ShellShock( "frag_grenade_mp", 3 );
		wait 0.05;
	}
}

elev()
{
	brush = getEnt( "elev_1" , "targetname" );
	
	while(1)
	{
		brush moveX( -1392, 7 );
		wait 8;
		brush moveZ( -144, 2 );
		wait 2.5;
		brush moveX( 1392, 7 );
		wait 8;
		brush moveZ( 144, 2 );
		wait 2.5;
	}
}

elev2()
{
	brush = getEnt( "elev_3" , "targetname" );
	
	while(1)
	{
		brush moveX( 1392, 7 );
		wait 8;
		brush moveZ( 216, 2 );
		wait 2.5;
		brush moveX( -1392, 7 );
		wait 8;
		brush moveZ( -216, 2 );
		wait 2.5;
	}
}
		
