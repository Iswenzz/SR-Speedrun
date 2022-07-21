//Map by ABprice

//#include braxi\_rank;

main()
{
thread sr\api\_map::createSpawn((7420, -8721, 264), 180);
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
	
	precacheItem("m40a3_mp");
	precacheItem("barrett_mp");
	precacheItem("remington700_mp");
	precacheItem("dragunov_mp");
	precacheItem("deserteagle_mp");
	precacheItem("p90_mp");
	precacheItem("ak47_mp");
	precacheItem("winchester1200_mp");
	precacheItem("m4_silencer_mp");
	precacheItem("m16_mp");
	precacheItem("g3_mp");
	precacheItem("g36c_silencer_mp");
	precacheItem("ak74u_mp");
	precacheItem("m60_acog_mp");
	precacheItem("skorpion_mp");
	precacheItem("rpd_mp");
	precacheItem("mp5_mp");
	precacheItem("k7_mp");
	precacheModel("fox_batgirl");
	precacheModel("Elysium_SC5");
	precacheModel("lara_croft_cod4");
	precacheModel("fox_chiller");
	precacheModel("playermodel_bo2_cordis_sniper");
	precacheModel("playermodel_bo1_reznov_rebirth");
	precacheModel("viewhands_mw2_ranger");
	
	//Misc
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
		thread sr\api\_speedrun::createTeleporter((6612.88, -8703.59, 288.125), 475, 215, (3286, -2682, 92), 90, "freeze"); 
	thread sr\api\_speedrun::createTeleporter((3280.37, 3450.04, 224.125), 265, 215, (-5526, -2722, 92), 90, "freeze");
    thread sr\api\_speedrun::createTeleporter((-5564.51, 5415.39, 352.125), 390, 385, (-31004, -2669, 7580), 90, "freeze");
    thread sr\api\_speedrun::createTeleporter((-31023.3, 12575.3, 784.125), 400, 390, (-31220, 37981, 18946), 90, "freeze");

	//thread ab();
	//thread vip_100();
	//thread kniferoom_updown();
	thread fnrp();
	thread jumptele1();
	thread jumptele2();
	//thread bottomtext();
	//thread suit_change();
	//thread addTestClients();
	//thread spawn1();
	//music
	thread musicBox();
	thread gate();
	//guns
	
	//thread jumproom_sniper();
	//thread ladderroom_sniper();
	//Traps
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	//thread trap11();
	//thread trap12();
	//thread trap13();
	//thread trap14();
	//thread trap15();
	//thread trap16();
	//elevators
	//thread ele1();
	//ropes
    //thread rope_script();
	//thread rope_script2();
	//secret
	thread secret_1();
	thread secret_3();
	thread secret_4();
	thread secret_5();
	thread secret_6();
	thread secret_7();
	thread secret_8();
	thread secret_9();
	thread secret_start();
	thread secret_hidehide();
	thread secret_platform();
	thread secret_end();
	//acti secret
	//thread acti_secret1();
	//thread acti_secret2();
	//thread acti_secret3();
	//thread acti_secret4();
	//thread acti_secret5();
	//thread acti_secretstart();
	//thread acti_secretend();
	//thread secret_platform2();
	//Stage Teleportars
	//thread stage1();
	//thread stage2();
	thread stage3();
	thread stage4();
	thread stage5();
	//Activator Stage Teleporters
	//thread acti_stage2();
	//thread acti_stage3();
	//thread acti_stage4();
	//thread acti_back_stage1();
	//thread acti_back_stage2();
	//thread acti_back_stage3();
	//End Room
	//thread room_selection();
	//Rooms
	//thread sniper_room();
	//thread bounce_room();
	//thread knife_room();
	//thread weapon_Room();
	//thread ladder_room();
	
	//addTriggerToList
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trig_trap9" );
	addTriggerToList( "trig_trap10" );
	addTriggerToList( "trig_trap11" );
	addTriggerToList( "trig_trap12" );
	addTriggerToList( "trig_trap13" );
	addTriggerToList( "trig_trap14" );
	addTriggerToList( "trig_trap15" );
	addTriggerToList( "trig_trap16" );
	
	//Music
	if(!isdefined(level.music))        
    level.music=[];
    level.music[0]["song"]    ="Boehm ft. Karra - Criminal";    
    level.music[0]["alias"]    ="song1";                        
    level.music[1]["song"]    ="Aero Chord - Shadows";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="Boehm - Outside Of The Lines";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    ="Bright Lights - Mr.Spaceman";
    level.music[3]["alias"]    ="song4";
    level.music[4]["song"]    ="Misha Sinal - Million Miles";
    level.music[4]["alias"]    ="song5";
    level.music[5]["song"]    ="Krewella - Runaway";
    level.music[5]["alias"]    ="song6";
    level.music[6]["song"]    ="Prismo - Stronger";
    level.music[6]["alias"]    ="song7";
	level.music[7]["song"]    ="CADE - Done With You";
    level.music[7]["alias"]    ="song8";
}

//Misc.

ab()
{
	level waittill("round_started");
	noti = SpawnStruct();
	wait 1.5;
		noti.titleText = "\n\n ^5 Welcome to mp_dr_zvr_dimensions ";
		noti.notifyText = "\n\n\n^3Map By ^2#Zsever#ABprice!";
		noti.duration = 7;
		noti.glowcolor = (1,0,0);
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

bottomtext()
{
	level waittill("round_started");
	while(1)
	{
	wait 10;
	iPrintLn("^1>>^2Welcome to ^3mp_dr_zvr_dimensions^2!^1<<");
	wait 10;
	iPrintLn("^1>>^2Map By ^3#Zsever#ABprice^1<<");
	wait 5;
	iPrintLn("^1>>^2Hope You Enjoy^1<<");
	wait 5;
	iPrintLn("^1>>^2Any Bug? Send Me Pm On Discord : ABprice#7183^1<<");
	wait 10;
	iPrintLn("^1>>^2There is ^11 ^5Secret ^2on this map!^1<<");
	wait 10;
	iPrintLn("^1>>^2Custom Weapons And Player Models By ^6VC' Fox^1<<");
	wait 10;
	iPrintLn("^1>>^2Thanks To ^3#FNRP#kLEIN ^2For Helping Me^1<<");
	wait 10;
	iPrintLn("^1>>^2Special Thanks To ^5 VC'Fox ^2, ^5VC' ERIK ^2, ^5FAMOUS NitroFire ^2, ^5VC' Blade ^2, ^5#Zsever#Rotola ^2, ^5CAR DarkSTEP ^2For Helping Me^1<<");
	wait 10;
	iPrintLn("^1>>^2Thanks To Testers ^5 #FNRP#Jazz :D ^2, ^5#FNRP#Hunter^1<<");
	wait 10;
	iPrintLn("^1>>^2Thanks To All ^3Zsever Members^1<<");
	wait 10;
	iPrintLn("^1>>^3zsever-gaming.es^1<<");
	}
	
}

suit_change()
{
	trig = getent("skinchange_trigger", "targetname");
	trig setHintString("^3Press ^5[F] ^3To Change you'r Outfit");
	while(true)
	{
	trig waittill("trigger", player);
    player detachAll();
    player setModel("fox_chiller");
	player iPrintlnBold( "^5You Changed Your Outfit!" );
    wait 0.1;
	}
	wait 0.5;
}

vip_100()
{
    trig = getent("vip_trigger", "targetname");
	while(true)
	{
    trig waittill("trigger", player);
	if (player isVip(player getGuid()) == "abprice" )
	{
	noti = SpawnStruct();
	noti.titleText = "\n\n^5Welcome!"; //upper text
    noti.notifyText = "\n\n\n^3^5#Zsever#ABprice";
	noti.glowcolor = (0,0.1,0.9);//outercolor
	noti.duration = 4; //time in screen
	players = getentarray("player", "classname"); //for all players
	for(i=0;i<players.size;i++) //all players
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	player giveWeapon("m60_acog_mp");
	player giveMaxAmmo("m60_acog_mp");
    player giveWeapon("k7_mp");
    player giveMaxAmmo("k7_mp");
    player switchToWeapon("m60_acog_mp");
    player detachAll(); //need this to prevent 128 bones error
    player setModel("Elysium_SC5");
	player iPrintlnBold( "^3You received Your Vip Kit!" );
	
	player braxi\_rank::giveRankXP("", 100);
    wait 0.1;
	}
	else if (player isVip(player getGuid()) == "fox")
	{
	player giveWeapon("m60_acog_mp");
	player giveMaxAmmo("m60_acog_mp");
    player giveWeapon("k7_mp");
    player giveMaxAmmo("k7_mp");
    player switchToWeapon("m60_acog_mp");
    player detachAll(); //need this to prevent 128 bones error
    player setModel("fox_batgirl");
	player iPrintlnBold( "^3You received Your Vip Kit!" );
//	player braxi\_rank::giveRankXP("", 100);
    wait 0.1;
	}
	else if (player isVip(player getGuid()) == "erik") 
	{
	player giveWeapon("ak47_mp");
	player giveMaxAmmo("ak47_mp");
    player giveWeapon("k7_mp");
    player giveMaxAmmo("k7_mp");
    player switchToWeapon("ak47_mp");
    player detachAll(); //need this to prevent 128 bones error
    player setModel("playermodel_bo1_reznov_rebirth");//
	player iPrintlnBold( "^3You received Your Vip Kit!" );
//	player braxi\_rank::giveRankXP("", 100);
    wait 0.1;
	}
	else if (
	player isVip(player getGuid()) == "jazz" ||
	player isVip(player getGuid()) == "enigrys" ||
	player isVip(player getGuid()) == "klein" ||
	player isVip(player getGuid()) == "lucifer" ||
	player isVip(player getGuid()) == "demon" ||
	player isVip(player getGuid()) == "hunter" ||
	player isVip(player getGuid()) == "nitrofire" ||
	player isVip(player getGuid()) == "rotola"
	)
	{
    player giveWeapon("k7_mp");
    player giveMaxAmmo("k7_mp");
    player switchToWeapon("k7_mp");
    player detachAll(); //need this to prevent 128 bones error
    player setModel("playermodel_bo2_cordis_sniper");
	player iPrintlnBold( "^3You received Your Vip Kit!" );
//	player braxi\_rank::giveRankXP("", 50);
    wait 0.1;
	}
	else if (player isVip(player getGuid()) == "false")
	{
	player iPrintlnBold( "^3VIP Only! Sorry ^3:(" ); 
	wait 0.1;
	}
	}
}

isVip(guid)
{
	gametag = self.name;
	if(self shortGuid(guid) == "93014291" || self shortGuid(guid) == "22300402" || self longGuid(guid) == "3e468dc6" || gametag == "VC' ERIK" )	//good
	  return "erik";
	else if ( self longGuid(guid) == "dd6115df" || self shortGuid(guid) == "89414715" || self longGuid(guid) == "3c59389d" )
        return "abprice";
	else if ( self longGuid(guid) == "c24aefdf" || self longGuid(guid) == "65c78edd" )
        return "jazz";
    else if ( self longGuid(guid) == "2b400c03" || self shortGuid(guid) == "46798366" )
        return "enigrys";
    else if ( self longGuid(guid) == "a3595553"  || self shortGuid(guid) == "77214248" )
        return "klein";
    else if ( self longGuid(guid) == "928dd1c2" )
        return "lucifer";
    else if ( self longGuid(guid) == "bf3cc697" )
        return "demon";
    else if ( self longGuid(guid) == "5051ee6e" )
        return "hunter";
    else if ( self shortGuid(guid) == "6541461" || self longGuid(guid) == "d05bc267" )
        return "nitrofire";
    else if ( self shortGuid(guid) == "34407089" || self longGuid(guid) == "ab61c6e4" )
        return "fox";
    else if ( self shortGuid(guid) == "25511810" || self longGuid(guid) == "2d0c6e0e" )
        return "rotola";
    else
        return "false";
}

longGuid(guid)
{
    return getSubstr(guid, 24, 32);
}

shortGuid(guid)
{
    return getSubstr(guid, 11, 19);
}

spawn1()
{
    for(;;)
    {
        level waittill("player_spawn", player );
        player setViewModel("viewhands_mw2_ranger");
    }
}

kniferoom_updown()
{
	platform = getEnt("kniferoom_updown","targetname");
	level waittill("round_started");
	
	for(;;)
	{
	wait 0.3;
	platform movez (4224,6);
	wait 8;
	platform movez (-4224,2);
	wait 2;
	}
}

fnrp()
{
	platform1 = getEnt("fnrplogo1","targetname");
	platform2 = getEnt("fnrplogo2","targetname");
	platform3 = getEnt("fnrplogo3","targetname");
	name1 = getEnt("fnrp1","targetname");
	name2 = getEnt("fnrp2","targetname");
	name3 = getEnt("fnrp3","targetname");
	
	platform1 hide();
	platform2 hide();
	platform3 hide();
	name1 hide();
	name2 hide();
	name3 hide();
	
	for(;;)
	{
	wait 0.1;
	name3 hide();
    platform1 show();
	wait 1.5;
	platform1 hide();
	name1 show();
	wait 1.5;
	name1 hide();
	platform2 show();
	wait 1.5;
	platform2 hide();
	name2 show();
	wait 1.5;
	name2 hide();
	platform3 show();
	wait 1.5;
	platform3 hide();
	name3 show();
	wait 1.4;
	}
}

jumptele1()
{    
     trig = getEnt("jump_tele_1", "targetname");
	 tele = getEnt("jump_origin_1", "targetname");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

jumptele2()
{    
     trig = getEnt("jump_tele_2", "targetname");
	 tele = getEnt("jump_origin_2", "targetname");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

gate()
{
	gate = getEnt("door", "targetname");
//	gate2 = getEnt("door2", "targetname");
	gate delete();
//	gate2 delete();
}

musicBox()
{
    trig = getEnt("trig_music","targetname");
    trig setHintString("Press ^2&&1^7 To Select Music");
    trig waittill("trigger",p);
    trig delete();
    
    p freezeControls(1);
    p musicMenu();
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
 
    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,0,0);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Mp_Dr_Zvr_Dimensions!");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(1,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("");
 
    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else 
            self.hud_music[i].glowcolor=(1,0,0);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(1,0,0);
 
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;
 
            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;
 
            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             iPrintLn("^2>> ^7Now playing: ^2"+level.music[self.selection]["song"]);
			 
            ambientPlay(level.music[self.selection]["alias"]);
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
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

//guns

jumproom_sniper()
{
    trigger = getEnt("trig_jumproom_sniper", "targetname");
    trigger setHintString("^7 Press ^3F ^7To Take ^5Sniper");

    for(;;) 
	{
        trigger waittill("trigger", player);

        player TakeAllWeapons();
        player giveWeapon("barrett_mp");
        player giveMaxAmmo("barrett_mp");
        player switchToWeapon("barrett_mp");
        wait 0.5;
    }
}

ladderroom_sniper()
{
    trigger = getEnt("trig_ladderroom_sniper", "targetname");
    trigger setHintString("^7 Press ^3F ^7To Take ^5Sniper");

    for(;;) 
	{
        trigger waittill("trigger", player);

        player TakeAllWeapons();
        player giveWeapon("dragunov_mp");
        player giveMaxAmmo("dragunov_mp");
        player switchToWeapon("dragunov_mp");
        wait 0.5;
    }
}

//Traps

trap1()
{
	p1 = GetEnt("trap1_1","targetname");
	p2 = GetEnt("trap1_2","targetname");
	trig = GetEnt("trig_trap1","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	trig delete();

	DisTrapDoes = RandomInt( 20 );
	if( DisTrapDoes < 10 )
	{
		p1 delete();
	}
	else
	{
		p2 delete();
	}
}

trap2()
{
	trig = getent("trig_trap2", "targetname");
	a = getent("trap2_1", "targetname");
	b = getent("trap2_2", "targetname");
	c = getent("trap2_3", "targetname");
    trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
	a rotateroll (360, 1);
	wait 2;
	b rotateroll (360, 1);
	wait 2;
	c rotateroll (360, 1);
	wait 2;
	}
	
}

trap3()
{
	trig = getent("trig_trap3", "targetname");
	b = getent("trap3_1", "targetname");
	a = getent("trap3_2", "targetname");
    trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	a movex (-548, 1);
	b movex (548, 1);
	wait 2;
	a delete();
	b delete();	
}

trap4()
{
    platform1 = getent("trap4", "targetname");
    trig = getent("trig_trap4", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	platform1 delete();
}

trap5()
{
    platform1 = getent("trap5", "targetname");
    trig = getent("trig_trap5", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
		platform1 moveZ (-328, 1);
		wait 3;
		platform1 moveZ (328, 1);
		wait 3;	
	}
}

trap6()
{
    platform1 = getent("trap6", "targetname");
    trig = getent("trig_trap6", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
		platform1 moveZ (-104, 3);
		wait 4;
		platform1 moveZ (104, 3);
		wait 4;	
	}
}

trap7()
{
    platform1 = getent("trap7", "targetname");
    trig = getent("trig_trap7", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	platform1 delete();
}

trap8()
{
    platform1 = getent("trap8_1", "targetname");
	platform2 = getent("trap8_2", "targetname");
    trig = getent("trig_trap8", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
		platform1 moveZ (-88, 2);
		platform2 moveZ (88, 2);
		wait 2;
		platform1 moveZ (88, 2);
		platform2 moveZ (-88, 2);
		wait 2;	
	}
}

trap9()
{
    platform1 = getent("trap9_1", "targetname");
	platform2 = getent("trap9_2", "targetname");
	platform3 = getent("trap9_3", "targetname");
	platform4 = getent("trap9_4", "targetname");
    trig = getent("trig_trap9", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
		wait 0.1;
		platform1 rotatePitch (360, 3);
		platform2 rotatePitch (360, 3);
		platform3 rotatePitch (360, 3);
		platform4 rotatePitch (360, 3);
	}
}

trap10()
{
    platform1 = getent("trap10_1", "targetname");
	platform2 = getent("trap10_2", "targetname");
	platform3 = getent("trap10_3", "targetname");
    trig = getent("trig_trap10", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
		platform1 rotateYaw (360, 2);
		platform2 rotateYaw (360, 2);
		platform3 rotateYaw (360, 2);
		wait 2;
	}
}

trap11()
{
    platform1 = getent("trap11_1", "targetname");
	platform2 = getent("trap11_2", "targetname");
	platform3 = getent("trap11_3", "targetname");
    trig = getent("trig_trap11", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
		platform1 rotatePitch (360, 1.5);
		wait 2;
		platform2 rotatePitch (360, 1.5);
		wait 2;
		platform3 rotatePitch (360, 1.5);
		wait 2;
	}
}

trap12()
{
    platform1 = getent("trap12", "targetname");
    trig = getent("trig_trap12", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	{
	platform1 movex(1440, 0.3);
	wait 2;
	platform1 delete();
	}
	
}

trap13()
{
	p1 = GetEnt("trap13_1","targetname");
	p2 = GetEnt("trap13_2","targetname");
	trig = GetEnt("trig_trap13","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	trig delete();

	DisTrapDoes = RandomInt( 20 );
	if( DisTrapDoes < 10 )
	{
		p1 NotSolid();
	}
	else
	{
		p2 NotSolid();
	}
}

trap14()
{
    platform1 = getent("trap14_1", "targetname");
	platform2 = getent("trap14_2", "targetname");
    trig = getent("trig_trap14", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	{
	platform1 NotSolid();
	platform2 NotSolid();
	platform1 rotateRoll(720, 2);
	platform2 rotatePitch(720, 2);
	wait 3;
	platform1 rotateRoll(-720, 2);
	platform2 rotatePitch(-720, 2);
	wait 0.1;
	platform1 Solid();
	platform2 Solid();
	}
	
}

trap15()
{
    platform1 = getent("trap15", "targetname");
    trig = getent("trig_trap15", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	{
	platform1 movex(-1064, 0.5);
	wait 0.5;
	platform1 rotateRoll(90, 0.5);
	wait 6;
	platform1 delete();
	
	}
	
}

trap16()
{
    platform1 = getent("trap16_1", "targetname");
	platform2 = getent("trap16_2", "targetname");
    trig = getent("trig_trap16", "targetname");
	trig SetHintString("^2Press ^5[F] ^2To Activate");
	trig waittill("trigger", player);
	trig delete();
	
	{
	platform1 movex(63, 0.2);
	platform2 movex(-63, 0.2);
	wait 5;
	platform1 delete();
	
	}
	
}

//Elevators

ele1()
{
	platform = getEnt("ele1","targetname");
	platform2 = getEnt("ele2","targetname");
    trig = getEnt("trig_ele1","targetname");
    trig waittill("trigger", player);
	trig delete();
	
	for(;;)
	{
	wait 1;
	platform movey (544,3);
    platform2 movey (-544,3);
	wait 3;
	platform movey (-544,3);
    platform2 movey (544,3);
	wait 2;
	}
}

//Ropes

rope_script()
{
    trig = getentarray ("ropetrigger", "targetname");
    {
    level waittill("round_started");
    
    for(i=0;i<trig.size;i++)
        {
        trig[i] thread rope_trigger();
        }
    wait 0.5;
    }
}

rope_trigger()
{
    self SetHintString("^0Press ^3[F] ^0To Activate");
    for(;;)
    {
    self waittill("trigger",player);
    player thread rope(self);
    wait 0.5;
    }
    wait 0.5;
}

rope(trig)
{
    air1 = getent(trig.target,"targetname");
    air2 = getent(air1.target,"targetname");

	time = trig.speed;
    air = spawn ("script_model",(0,0,0));
	air endon("death");
	air thread rope_end_ondc(self);
    air.origin = self.origin;
    air.angles = self.angles;
    self linkto (air);
    air moveto (air1.origin, 0.3);
    wait 0.3;
    air moveto (air2.origin, time);
    wait time;
	self unlink();
	air delete();
}

rope_end_ondc(who)
{
	self endon("death");

	who common_scripts\utility::waittill_any("death", "disconnect");

	self delete();
}

rope_script2()
{
    trig = getentarray ("ropetrigger2", "targetname");///ropetrigger2
    {
    level waittill("round_started");
    
    for(i=0;i<trig.size;i++)
        {
        trig[i] thread rope_trigger2();
        }
    wait 0.5;
    }
}

rope_trigger2()
{
    self SetHintString("^0Press ^3[F] ^0To Activate");
    for(;;)
    {
    self waittill("trigger",player);
    player thread rope2(self);
    wait 1;
    }
    wait 0.5;
}

rope2(trig)
{
    air1 = getent(trig.target,"targetname");
    air2 = getent(air1.target,"targetname");
    air3 = getent(air2.target,"targetname");//link origiin 2 to 3
    air4 = getent(air3.target,"targetname");//link origiin 3 to 4

    time = trig.speed;
    air = spawn ("script_model",(0,0,0));
	air endon("death");
	air thread rope_end_ondc(self);
    air.origin = self.origin;
    air.angles = self.angles;
    self linkto (air);
    air moveto (air1.origin, 0.3);
    wait 0.3;
    air moveto (air2.origin, 2);
    wait 2;
    air moveto (air3.origin, time);
    wait time;
    air moveto (air4.origin, 2);
    wait 2;
	self unlink();
	air delete();
}

//secret

secret_1()
{    
     trig = getEnt("trig_secret_tele1", "targetname");
	 tele = getEnt("secret_origin1", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_3()
{    
     trig = getEnt("trig_secret_tele2", "targetname");
	 tele = getEnt("secret_origin2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_4()
{    
     trig = getEnt("trig_secret_tele3", "targetname");
	 tele = getEnt("secret_origin3", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_5()
{    
     trig = getEnt("trig_secret_tele4", "targetname");
	 tele = getEnt("secret_origin4", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_6()
{    
     trig = getEnt("trig_secret_tele5", "targetname");
	 tele = getEnt("secret_origin5", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_7()
{    
     trig = getEnt("trig_secret_tele5_2", "targetname");
	 tele = getEnt("secret_origin5_2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_8()
{    
     trig = getEnt("trig_secret_tele6", "targetname");
	 tele = getEnt("secret_origin6", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_9()
{    
     trig = getEnt("trig_secret_tele7", "targetname");
	 tele = getEnt("secret_origin7", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

secret_start()
{    
     trig = getEnt("secret_trigger", "targetname");
	 tele = getEnt("teleport_origin1", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
         player thread sr\api\_speedrun::changeWay("secret_0");
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.01;
         player freezeControls(0);
	 }
}

secret_end()
{    
     trig = getEnt("secret_endtrigger", "targetname");
	 tele = getEnt("origin_secretend1", "targetname");
	 trig SetHintString("^2Press ^5[F] ^2To Finish");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
         player thread sr\api\_speedrun::finishWay("secret_0");
	 }
}

secret_hidehide()
{
    secretdmg1 = getent("secret_hide", "targetname");
	secretdmg2 = getent("hide_actisecret", "targetname");
	{
	 secretdmg1 hide();	
	 secretdmg1 NotSolid();
	 secretdmg2 hide();	
	 secretdmg2 NotSolid();
	}
}

secret_platform()
{
    secretdmg1 = getent("secret_hide", "targetname");
    trig = getEnt("secret_open", "targetname");
	secretdmg1 show();
	secretdmg1 Solid();
	trig delete();
}

//acti_secret

secret_platform2()
{
    secretdmg1 = getent("hide_actisecret", "targetname");
	head = getent("shoot_head", "targetname");
    trig = getEnt("secret_hideacti", "targetname");
	trig2 = getEnt("open_acti", "targetname");
	trig2 enablelinkto ();
	trig2 linkto (secretdmg1);
	trig waittill("trigger", player);
	{
	wait 0.2;
    player iPrintlnBold( "^3What? Its Just A Head :3" );
	secretdmg1 show();
	secretdmg1 Solid();
	secretdmg1 movez (-248,0.1);
	head hide();
	head NotSolid();
	}
	trig delete();
}

acti_secret1()
{    
     trig = getEnt("secret_acti_1", "targetname");
	 tele = getEnt("secret_origin_acti1", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_secret2()
{    
     trig = getEnt("secret_acti_2", "targetname");
	 tele = getEnt("secret_origin_acti2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_secret3()
{    
     trig = getEnt("secret_acti_3", "targetname");
	 tele = getEnt("secret_origin_acti3", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_secret4()
{    
     trig = getEnt("tostage2_acti", "targetname");
	 tele = getEnt("secretstage2_acti", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_secret5()
{    
     trig = getEnt("tostage3_acti", "targetname");
	 tele = getEnt("secretstage3_acti", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_secretstart()
{    
     trig = getEnt("open_acti", "targetname");
	 tele = getEnt("acti_secretorigin", "targetname");
     trig SetHintString("^0Press ^3[F] ^0To Enter");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
		 player iPrintlnBold( "^5 Welcome To The Secret!" );
	 }
}

acti_secretend()
{    
     trig = getEnt("trig_actiend", "targetname");
	 tele = getEnt("acti_end", "targetname");
	 trig SetHintString("^2Press ^5[F] ^2To Finish");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
         player braxi\_rank::giveRankXP("", 333);
		 iPrintlnBold( " ^3Activator ^5 Finished The Secret!" );
	 }
}

//Stage Teleportars

stage1()
{    
    trig = getEnt("tptostage1", "targetname");
	tele = getEnt("origin_stage1", "targetname");
	 
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.02;
        player freezeControls(0);
		noti = SpawnStruct();
		noti.titleText = "\n\n>>>^2Stage 1^7<<<"; //upper text
		noti.notifyText = "\n\n\nGo!"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		player thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	}
}

stage2()
{    
     trig = getEnt("tptostage2", "targetname");
	 tele = getEnt("origin_stage2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
		noti = SpawnStruct();
		noti.titleText = "\n\n>>>^1Stage 2^7<<<"; //upper text
		noti.notifyText = "\n\n\nKeep Runing!"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		player thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	 }
}

stage3()
{    
     trig = getEnt("tptostage3", "targetname");
	 tele = getEnt("origin_stage3", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
		noti = SpawnStruct();
		noti.titleText = "\n\n>>>^5Stage 3^7<<<"; //upper text
		noti.notifyText = "\n\n\nAlmost Done!"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		player thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	 }
}

stage4()
{    
     trig = getEnt("tptostage4", "targetname");
	 tele = getEnt("origin_stage4", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
		noti = SpawnStruct();
		noti.titleText = ">>>^3Stage 4^7<<<"; //upper text
		noti.notifyText = "Almost Done!"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		player thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	 }
}

stage5()
{    
     trig = getEnt("tptostage5", "targetname");
	 tele = getEnt("origin_stage5", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
		noti = SpawnStruct();
		noti.titleText = ">>>^1Stage 5^7<<<"; //upper text
		noti.notifyText = "You are At End Dont Fall Now!"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		player thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	 }
}

//Activator Stage Teleportars

acti_stage2()
{    
     trig = getEnt("trig_acti_stage2", "targetname");
	 tele = getEnt("origin_acti_stage2", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

/*
acti_stage3()
{    
     trig = getEnt("trig_acti_stage3", "targetname");
	 tele = getEnt("origin_acti_stage3", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}
*/

acti_stage4()
{    
     trig = getEnt("trig_acti_stage4", "targetname");
	 tele = getEnt("origin_acti_stage4", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_back_stage1()
{    
     trig = getEnt("trig_acti_back_stage1", "targetname");
	 tele = getEnt("origin_acti_back_stage1", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport Back");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_back_stage2()
{    
     trig = getEnt("trig_acti_back_stage2", "targetname");
	 tele = getEnt("origin_acti_back_stage2", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport Back");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

acti_back_stage3()
{    
     trig = getEnt("trig_acti_back_stage3", "targetname");
	 tele = getEnt("origin_acti_back_stage3", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport Back");
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

//End Room

room_selection()
{
    trig = getent("endroom_trigger", "targetname"); // Trigger to enter the Selection
    targ = getent("endroom_origin", "targetname"); // Script Origin to the Place you want them to teleport

    while(1)
    {
        trig sethintstring("^5Enter The Room Selection"); // Change Text to what you want
        trig waittill("trigger",player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^2" + player.name; //upper text
		noti.notifyText = "\n\n\n^2Enter The Room Selection"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
		
        player takeallweapons(); // Removes all weapons

        player setorigin(targ.origin); // Teleport
        player setplayerangles(targ.angles); // Teleport

        while(isAlive(player)&&isDefined(player))
            wait 1;

		noti = SpawnStruct();
		noti.titleText = "\n\n^2" + player.name + "Died!!!"; //upper text
		noti.notifyText = "\n\n\n^2Room Selection Opened"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
    }
}

//Rooms

sniper_room()
{
	level.trigsniper = getEnt("trig_sniperroom", "targetname");

	jumporigin = getEnt("sf_1", "targetname");
	actiorigin = getEnt("sf_2", "targetname");

	level.trigsniper sethintstring("^0Press ^3[F] ^0To Enter");

	while(1)
	{
		level.trigsniper waittill("trigger", player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^5Sniper ^5Room"; //upper text
		noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something

		player.health = player.maxhealth;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player giveWeapon("m40a3_mp");
		player giveWeapon("remington700_mp");
		player giveMaxAmmo("m40a3_mp");
		player giveMaxAmmo("remington700_mp");
		level.activ giveWeapon("m40a3_mp");
		level.activ giveWeapon("remington700_mp");
		level.activ giveMaxAmmo("m40a3_mp");
		level.activ giveMaxAmmo("remington700_mp");

		player switchToWeapon("m40a3_mp");
		level.activ switchToWeapon("m40a3_mp");

		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin (jumporigin.origin);
		player setPlayerAngles (jumporigin.angles);

		level.activ setOrigin (actiorigin.origin);
		level.activ setPlayerAngles (actiorigin.angles);
		wait 2;

		player iPrintLnBold("^13");
		level.activ iPrintLnBold("^13");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^21");
		level.activ iPrintLnBold("^21");
		wait 1;
		player iPrintLnBold("^5Shoot That Activator^2!");
		level.activ iPrintLnBold("^5Shoot That Jumper^2!");

		player freezeControls(0);
		level.activ freezeControls(0);

		if( !isDefined( level.activ ) )
			return;

		while( isDefined( player ) && isAlive( player ) && player.sessionstate == "playing" && player != level.activ )
			wait 0.15;
	}
}

bounce_room()
{
	level.trigjump = getEnt("trig_bounceroom", "targetname");

	jumporigin = getEnt("sf_3", "targetname");
	actiorigin = getEnt("sf_4", "targetname");

	level.trigjump sethintstring("^0Press ^3[F] ^0To Enter");

	while(1)
	{
		level.trigjump waittill("trigger", player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^5Bounce ^5Room"; //upper text
		noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something

		player.health = player.maxhealth;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player giveWeapon("knife_mp");
		player giveMaxAmmo("knife_mp");
		level.activ giveWeapon("knife_mp");
		level.activ giveMaxAmmo("knife_mp");

		player switchToWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin (jumporigin.origin);
		player setPlayerAngles (jumporigin.angles);

		level.activ setOrigin (actiorigin.origin);
		level.activ setPlayerAngles (actiorigin.angles);
		wait 2;

		player iPrintLnBold("^13");
		level.activ iPrintLnBold("^13");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^21");
		level.activ iPrintLnBold("^21");
		wait 1;
		player iPrintLnBold("^5Kill That Activator^2!");
		level.activ iPrintLnBold("^5Kill That Jumper^2!");

		player freezeControls(0);
		level.activ freezeControls(0);

		if( !isDefined( level.activ ) )
			return;

		while( isDefined( player ) && isAlive( player ) && player.sessionstate == "playing" && player != level.activ )
			wait 0.15;
	}
}

knife_room()
{
	level.trigknife = getEnt("trig_kniferoom", "targetname");

	jumporigin = getEnt("sf_5", "targetname");
	actiorigin = getEnt("sf_6", "targetname");

	level.trigknife sethintstring("^0Press ^3[F] ^0To Enter");

	while(1)
	{
		level.trigknife waittill("trigger", player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^5Knife ^5Room"; //upper text
		noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something

		player.health = player.maxhealth;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player giveWeapon("knife_mp");
		player giveMaxAmmo("knife_mp");
		level.activ giveWeapon("knife_mp");
		level.activ giveMaxAmmo("knife_mp");

		player switchToWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin (jumporigin.origin);
		player setPlayerAngles (jumporigin.angles);

		level.activ setOrigin (actiorigin.origin);
		level.activ setPlayerAngles (actiorigin.angles);
		wait 2;

		player iPrintLnBold("^13");
		level.activ iPrintLnBold("^13");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^21");
		level.activ iPrintLnBold("^21");
		wait 1;
		player iPrintLnBold("^5Kill That Activator^2!");
		level.activ iPrintLnBold("^5Kill That Jumper^2!");

		player freezeControls(0);
		level.activ freezeControls(0);

		if( !isDefined( level.activ ) )
			return;

		while( isDefined( player ) && isAlive( player ) && player.sessionstate == "playing" && player != level.activ )
			wait 0.15;
	}
}

weapon_Room()
{
	level.roomTrig = getEnt("trig_weproom", "targetname");

	jumporigin = getEnt("sf_7", "targetname");
	actiorigin = getEnt("sf_8", "targetname");

	level.roomTrig sethintstring("^0Press ^3[F] ^0To Enter");

	while(1)
	{
		level.roomTrig waittill("trigger", player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^5Weapon ^5Room"; //upper text
		noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something

		player.health = player.maxhealth;
		level.activ.health = level.activ.maxhealth;

		level.activ thread giveRandomWeapon();
		player thread giveRandomWeapon();

		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin (jumporigin.origin);
		player setPlayerAngles (jumporigin.angles);

		level.activ setOrigin (actiorigin.origin);
		level.activ setPlayerAngles (actiorigin.angles);
		wait 2;

		player iPrintLnBold("^13");
		level.activ iPrintLnBold("^13");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^21");
		level.activ iPrintLnBold("^21");
		wait 1;
		player iPrintLnBold("^5Kill That Activator^2!");
		level.activ iPrintLnBold("^5Kill That Jumper^2!");

		player freezeControls(0);
		level.activ freezeControls(0);

		if( !isDefined( level.activ ) )
			return;

		while( isDefined( player ) && isAlive( player ) && player.sessionstate == "playing" && player != level.activ )
			wait 0.15;
	}
}

giveRandomWeapon()
{
    weaponList = [];
    
    weaponList[0] = "winchester1200_mp";
    weaponList[1] = "m4_silencer_mp";
    weaponList[2] = "m16_mp";
    weaponList[3] = "ak47_mp";
    weaponList[4] = "g3_mp";
    weaponList[5] = "p90_mp";
    weaponList[6] = "barrett_mp";
    weaponList[7] = "m40a3_mp";
    weaponList[8] = "g36c_silencer_mp";
    weaponList[9] = "ak74u_mp";
	weaponList[10] = "skorpion_mp";
	weaponList[11] = "rpd_mp";
	weaponList[12] = "mp5_mp";
    
    randomWeaponChosen = randomInt(weaponList.size);
    
    self TakeAllWeapons();
    self GiveWeapon(weaponList[randomWeaponChosen]);
    wait 0.05;
    self SwitchToWeapon(weaponList[randomWeaponChosen]);
    self GiveMaxAmmo(weaponList[randomWeaponChosen]);
}

ladder_room()
{
	level.trigladder = getEnt("trig_ladderroom", "targetname");

	actiorigin = getEnt("ladder_1", "targetname");
	jumporigin = getEnt("ladder_2", "targetname");

	level.trigladder sethintstring("^0Press ^3[F] ^0To Enter");

	while(1)
	{
		level.trigladder waittill("trigger", player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^5Ladder ^5Room"; //upper text
		noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something

		player.health = player.maxhealth;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player giveWeapon("knife_mp");
		level.activ giveWeapon("knife_mp");	

		player switchToWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		player freezeControls(1);
		level.activ freezeControls(1);

		player show();
		level.activ show();

		player setOrigin (actiorigin.origin);
		player setPlayerAngles (actiorigin.angles);

		level.activ setOrigin (jumporigin.origin);
		level.activ setPlayerAngles (jumporigin.angles);
		wait 2; 

		player iPrintLnBold("^13");
		level.activ iPrintLnBold("^13");
		wait 1;
		player iPrintLnBold("^52");
		level.activ iPrintLnBold("^52");
		wait 1;
		player iPrintLnBold("^21");
		level.activ iPrintLnBold("^21");
		wait 1;
		player iPrintLnBold("^5Kill That Activator^2!");
		level.activ iPrintLnBold("^5Kill That Jumper^2!");

		player freezeControls(0);
		level.activ freezeControls(0);

		if( !isDefined( level.activ ) )
			return;

		while( isDefined( player ) && isAlive( player ) && player.sessionstate == "playing" && player != level.activ )
			wait 0.15;
	}
}

addTriggerToList( name, positionOfIconAboveTrap )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

    if( !isDefined( level.icon_origins ) )
        level.icon_origins = [];
    level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
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

secret_timer() 
{
}

secret_hud()
{
    self endon("secret_stop");
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    self.secretTimer=newclienthudelem(self);
    self.secretTimer.foreground = true;
    self.secretTimer.alignX = "center";
    self.secretTimer.alignY = "bottom";
    self.secretTimer.horzAlign = "center";
    self.secretTimer.vertAlign = "bottom";
    self.secretTimer.x = 0;
    self.secretTimer.y = -7;
    self.secretTimer.sort = 5;
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^5Time left: ^1&&1";
    self.secretTimer.glowColor=(0,.7,.9);
    time=180;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
}
 
playerGone(noty)
{
    self playerOnDeath(noty);
    self playerOnDisconnect(noty);
    self playerOnSpawned(noty);
    self playerOnSpectators(noty);
    wait 0.5;
}
 
playerOnDeath(noty)
{
    self waittill("death");
    if (isDefined(self.secretTimer))
    {
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
    }
}
 
playerOnDisconnect(noty)
{
    self waittill("disconnect");
    if (isDefined(self.secretTimer))
    {
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
    }
}
 
playerOnSpawned(noty)
{
    self waittill("spawned");
    if (isDefined(self.secretTimer))
    {
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
    }
}
 
playerOnSpectators(noty)
{
    self waittill("joined_spectators");
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
}
