// Liserd is a smelly guy

// Map Scripted by Mist & Rex109

main() {

	maps\mp\_load::main();

	thread sr\api\_map::createSpawn((-536, 2602, 257), 90);

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

    setdvar("bg_fallDamageMaxHeight","9999999");
    setdvar("bg_fallDamageMinHeight","9999998");

    precacheshader("material,loadscreen_mp_dr_liserd");
    precacheshader("material,liserd_loadscreen");
    precacheshader("material,mtl_plr_carl_johnson_head");
    precacheshader("material,mtl_plr_carl_johnson_jeans");
    precacheshader("material,mtl_plr_carl_johnson_sneaker");
    precacheshader("material,mtl_plr_carl_johnson_torso");
    precacheModel("plr_carl_johnson");

    level.elec = false;
    level.elec2 = false;
    level.elec3 = false;

    if(!isdefined(level.music))
    level.music=[];
    level.music[0]["song"]    ="^8Bangzor ^7- ^8mp_dr_liserd";
    level.music[0]["alias"]    ="liserd";
    level.music[1]["song"]    ="^8Simon Servida ^7- ^8Kerosene";
    level.music[1]["alias"]    ="kerosene";
    level.music[2]["song"]    ="^8Assuming We Survive ^7- ^8Down";
    level.music[2]["alias"]    ="down";
    level.music[3]["song"]    ="^8Dizzee Rascal ^7- ^8Bassline Junkie";
    level.music[3]["alias"]    ="bassline";
    level.music[4]["song"]    ="^8Lil Xtra ^7- ^8Different";
    level.music[4]["alias"]    ="different";
    level.music[5]["song"]    ="^8Besomorph ^7- ^8Monster";
    level.music[5]["alias"]    ="monster";

    visionSetNaked("mp_dr_liserd");

    //General Threads
    //thread fx();
    //thread musicBox();

    // Secret
    thread frog();
    thread secret();

    // VIP
    //thread vip_char();
    ///thread vip_tele();

    // End Rooms
   // thread old();
    //thread knife();
    //thread sniper();
    //thread bounce();
   // thread bounce_fail();

    // Spawn
    //thread credits();
    thread startdoor();

    // Traps
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
   // thread trap7();
    //thread trap8();
   // thread trap9();
    //thread trap10();
  //  thread trap11();
   // thread trap12();
   // thread trap13();
   // thread trap14();
  //  thread trap15();
   // thread trap16();

   thread sr\api\_speedrun::createNormalWays("Normal Way");
   thread sr\api\_speedrun::createSecretWays("Secret Way");

    // Trigger List
    addTriggerToList( "trap1_trig" ); 
    addTriggerToList( "trap2_trig" ); 
    addTriggerToList( "trap3_trig" ); 
    addTriggerToList( "trap4_trig" ); 
    addTriggerToList( "trap5_trig" ); 
    addTriggerToList( "trap6_trig" ); 
    addTriggerToList( "trap7_trig" ); 
    addTriggerToList( "trap8_trig" );
    addTriggerToList( "trap9_trig" ); 
    addTriggerToList( "trap10_trig" ); 
    addTriggerToList( "trap11_trig" ); 
    addTriggerToList( "trap12_trig" );
    addTriggerToList( "trap13_trig" );
    addTriggerToList( "trap14_trig" );
    addTriggerToList( "trap15_trig" );
    addTriggerToList( "trap16_trig" );

}

vip_char() {
	level waittill( "round_started" );
	wait 3;
	players = GetEntArray("player", "classname");
	for(i=0;i<players.size;i++) {
		Guid = getSubStr(players[i] getGuid(),24,32);
		if( (Guid == "4021c83b" || Guid == "65586cbf") || (Guid == "b38b458c" || Guid == "fe6fea02") && players[i].pers["team"] == "allies" ) {
			wait .05;
			players[i] iPrintlnBold( "^7Grats on ^8VIP " + players[i].name );
			wait 1;
			players[i] endon( "disconnect" );
			players[i] detachAll();
         	players[i] setModel( "plr_carl_johnson" );
			players[i] iprintLnBold("^8You ^7are now ^8Carl Johnson");
		}
	}
}

vip_tele() {
	level waittill( "round_started" );
    button = getEnt( "vip_trig", "targetname" );
    org = getEnt( "vip_origin", "targetname" );

    button setHintString( "^8VIP ^7Check" );

	wait 3;
	players = GetEntArray("player", "classname");
	for(i=0;i<players.size;i++) {
		Guid = getSubStr(players[i] getGuid(),24,32);
		if( (Guid == "4021c83b" || Guid == "65586cbf") || (Guid == "b38b458c" || Guid == "fe6fea02") && players[i].pers["team"] == "allies" ) {
			wait .05;
            while( 1 ) {
                button waittill( "trigger", players );
                iPrintlnBold( players.name + " Has entered the ^8Secret^7, As a ^8VIP!" );
                players freezeControls( 1 );
                players setOrigin( org.origin );
                players setPlayerAngles( org.angles );
                players freezeControls( 0 );
                wait .05;
            }
		}
	}
}

fx() {
    level._effect[ "electric" ]        = loadFX( "mp_dr_liserd/electric" );
}

musicBox()
{
    trig=getent("jukebox_trig","targetname");

    trig setHintString( "^7Press ^8&&1 ^7to choose a ^8Song!" );
    trig waittill("trigger",p);
    trig delete();
    
    p freezecontrols(1);
	//p thread musicfix();
   // p musicMenu();
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

/*musicMenu()
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
	//self.hud_music[i] setShader( "crosslogo", 200, 200 );
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
            self freezecontrols(0);
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
*/

frog() {
    level waittill( "round_started" );
    trig = getEnt( "frog_trig", "targetname" );
    org = getEnt( "frog_origin", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );
        player thread sr\api\_speedrun::changeWay("secret_0");
        player freezeControls( 1 );
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

s_unlock() {
    trig = getEnt( "boot_trig", "targetname" );

    trig waittill( "trigger", player );
    trig delete();
    
    thread s_unlock2();
}

s_unlock2() {
    sign = getEnt( "secret_unlock_trig", "targetname" );
    dirt = getEnt( "secret_unlock", "targetname" );

    sign waittill( "trigger", player );

    wait 2;
    iPrintlnBold("^7something has unlocked..." );
    dirt notsolid();
    sign delete();
}

s_enter() {
    level waittill( "round_started" );
    trig = getEnt( "secret_trig", "targetname" );
    org = getEnt( "secret_origin", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );
        //iPrintlnBold( player.name + " has entered the ^8Secret!" );
        player freezeControls( 1 );
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        player freezeControls( 0 );
        wait .05;
    }
}

s_fail() {
	fail = GetEnt( "secret_fail_trig","targetname" );
	org = GetEnt( "secret_origin","targetname" );
	while(1) {
	    fail waittill("trigger", player);
        
	    player SetPlayerAngles( org.angles );
        player setOrigin( org.origin );
    }	
}

s_finish() {
    trig = getEnt( "secret_finish_trigger", "targetname" );
    org = getEnt( "secret_finish", "targetname" );

    while(1) {
        trig waittill( "trigger", player );
        player thread sr\api\_speedrun::finishWay("secret_0");
        player setOrigin( org.origin );
        player setPlayerAngles( org.angles );
        //iPrintlnBold( player.name + " has finished the ^8Secret!" );
        //player braxi\_rank::giveRankXp("trap_activation", 1000);
        //player braxi\_rank::giveRankXp("trap_activation", 1000);
        //player braxi\_rank::giveRankXp("trap_activation", 1000);
    }
}

secret() {
    thread s_unlock();
    thread s_enter();
    thread s_fail();
    thread s_finish();
}

addTriggerToList( name ) {

   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

credits() {
	while( 1 ) {
		wait 8;
		iPrintLn( "^7Mapped by ^8Liserd" );
		wait 8;
		iPrintLn( "^7Scripted by ^8Mist ^7& ^8Rex109" );
        wait 8;
	}
}

startdoor() {
    level waittill( "round_started" );
    door = getEnt( "startdoor", "targetname" );
    door moveZ( 300, 3, 1, 1 );
    door delete();
}

trap1() {
    trig = getEnt( "trap1_trig", "targetname" );
    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );
    fxspawn=getEntArray("electric_fx1","targetname");
    for(i=0;i<fxspawn.size;i++)
    {
        
        level.fxtrap1[i]=spawnfx(level._effect[ "electric"],fxspawn[i].origin);
        triggerfx(level.fxtrap1[i]);
    }
    level.elec = true;
    thread trap1_kill();
    wait 5;
    level.elec = false;
    for(i=0;i<level.fxtrap1.size;i++)
    {
        level.fxtrap1[i] delete();
    }
}

trap1_kill() {
    hurt = getEnt( "trap1_hurt", "targetname" );
    while( level.elec ) {
        hurt waittill( "trigger", player );
        if(level.elec)
        player suicide();
    
    }
}

trap2() {
    trig = getEnt( "trap2_trig", "targetname" );
    down = getEnt( "trap2", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    death  = getent("trap2_hurt","targetname"); //Death trigger
    death enablelinkto(); 
    death linkto(down);
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );

    down moveZ( -576, 1, 1 );
    wait 3;
    down moveZ( 576, 1, 1 );

}

trap3() {
    trig = getEnt( "trap3_trig", "targetname" );
    plat1 = getEnt( "trap3_1", "targetname" );
    plat2 = getEnt( "trap3_2", "targetname" );
    plat3 = getEnt( "trap3_3", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^7Activated" );

    while( 1 ) {
        plat1 moveZ( -800, 2, 1, 1 );
        wait .5;
        plat2 moveZ( -800, 2, 1, 1 );
        wait .5;
        plat3 moveZ( -800, 2, 1, 1 );
        wait 5;
        plat1 moveZ( 800, 2, 1, 1 );
        wait .5;
        plat2 moveZ( 800, 2, 1, 1 );
        wait .5;
        plat3 moveZ( 800, 2, 1, 1 );
        wait 5;
    }
}

trap4() {
    trig = getEnt( "trap4_trig", "targetname" );
    spin = getEnt( "trap4_spin", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^7Activated" );

    while( 1 ) {
        spin rotateRoll( 1080, 2, 1, 1 );
        wait 6;
        spin rotateRoll( -1080, 2, 1, 1 );
        wait 6;
    }
}

trap5() {
    trig = getEnt( "trap5_trig", "targetname" );
    spin1 = getEnt( "trap5_1", "targetname" );
    spin2 = getEnt( "trap5_2", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^7Activated" );

    while( 1 ) {
        spin1 rotateRoll( 1080, 4, 1, 1 );
        wait 5;
        spin2 rotateRoll( -1080, 4, 1, 1 );
        wait 5;
    }
}

trap6() {
    trig = getEnt( "trap6_trig", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );
    fxspawn=getEntArray("electric_fx2","targetname");
    for(i=0;i<fxspawn.size;i++)
    {
        
        level.fxtrap2[i]=spawnfx(level._effect[ "electric"],fxspawn[i].origin);
        triggerfx(level.fxtrap2[i]);
    }

    level.elec2 = true;
    thread trap6_kill();
    wait 5;
    level.elec2 = false;
     for(i=0;i<level.fxtrap2.size;i++)
    {
        level.fxtrap2[i] delete();
    }
}

trap6_kill() {
    hurt = getEnt( "trap6_hurt", "targetname" );
    while( level.elec2 ) {
        hurt waittill( "trigger", player );
        if(level.elec2)
        player suicide();
    
    }
}

trap7() {
    trig = getEnt( "trap7_trig", "targetname" );
    slant1 = getEnt( "trap7_1", "targetname" );
    slant2 = getEnt( "trap7_2", "targetname" );
    slant3 = getEnt( "trap7_3", "targetname" );
    slant4 = getEnt( "trap7_4", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );

    while( 1 ) {
        slant1 moveX( -500, 3, 1, 1 );
        wait 1;
        slant2 moveX( 500, 3, 1, 1 );
        wait 1;
        slant3 moveX( -500, 3, 1, 1 );
        wait 1;
        slant4 moveX( 500, 3, 1, 1 );
        wait 3;
        slant1 moveX( 500, 3, 1, 1 );
        wait 1;
        slant2 moveX( -500, 3, 1, 1 );
        wait 1;
        slant3 moveX( 500, 3, 1, 1 );
        wait 1;
        slant4 moveX( -500, 3, 1, 1 );
        wait 3;
    }
}

trap8() {
    trig = getEnt( "trap8_trig", "targetname" );
    spinny = getEnt( "trap8", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );

    spinny rotateYaw( 360, 4, 1, 1 );
    wait 5;
    spinny rotateYaw( -360, 4, 1, 1 );

}

trap9() {
    trig = getEnt( "trap9_trig", "targetname" );
    spinny1 = getEnt( "trap9_1", "targetname" );
    spinny2 = getEnt( "trap9_2", "targetname" );
    spinny3 = getEnt( "trap9_3", "targetname" );
    spinny4 = getEnt( "trap9_4", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );    

    while( 1 ) {
        spinny1 rotateYaw( 720, 3, 1, 1 );
        wait 1;
        spinny2 rotateYaw( 720, 3, 1, 1 );
        wait 1;
        spinny3 rotateYaw( 720, 3, 1, 1 );
        wait 1;
        spinny4 rotateYaw( 720, 3, 1, 1 );
        wait 3;
        spinny1 rotateYaw( -720, 3, 1, 1 );
        wait 1;
        spinny2 rotateYaw( -720, 3, 1, 1 );
        wait 1;
        spinny3 rotateYaw( -720, 3, 1, 1 );
        wait 1;
        spinny4 rotateYaw( -720, 3, 1, 1 );
        wait 3;
    }
}

trap10() {
    trig = getEnt( "trap10_trig", "targetname" );
    up = getEnt( "trap10_1", "targetname" );
    down = getEnt( "trap10_2", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );    

    while( 1 ) {
        up moveZ( 400, 3, 1, 1 );
        down moveZ( -400, 3, 1, 1 );
        wait 4;
        up moveZ( -400, 3, 1, 1 );
        down moveZ( 400, 3, 1, 1 );
        wait 4;
        up moveZ( 400, 3, 1, 1 );
        down moveZ( -400, 3, 1, 1 );
        wait 4;
        up moveZ( -400, 3, 1, 1 );
        down moveZ( 400, 3, 1, 1 );
        wait 4;
    }
}

trap11() {
    trig = getEnt( "trap11_trig", "targetname" );
    plat = getEnt( "trap11_1", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );   

    plat moveZ( -300, 1, 1 );
    wait 5;
    plat moveZ( 300, 1, 1 );
}

trap12() {
    trig = getEnt( "trap12_trig", "targetname" );
    spike1 = getEnt( "trap12_1", "targetname" );
    spike2 = getEnt( "trap12_2", "targetname" );
    hurt1 = getEnt( "trap12_1_hurt", "targetname" );
    hurt2 = getEnt( "trap12_2_hurt", "targetname" );

    hurt1 EnableLinkTo();
    hurt1 LinkTo( spike1 );

    hurt2 EnableLinkTo();
    hurt2 LinkTo( spike2 );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );  

    spike1 moveY( 295, 1, 1 );
    spike2 moveY( -295, 1, 1 );
    wait 3;
    spike1 moveY( -295, 1, 1 );
    spike2 moveY( 295, 1, 1 );
}

trap13() {
    trig = getEnt( "trap13_trig", "targetname" );
    ladder1 = getEnt( "trap13_1", "targetname" );
    ladder2 = getEnt( "trap13_2", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig setHintString( "^8Activated" );  

    randomPart = randomInt( 2 );
        switch( randomPart ) {
        case 0:
        for( i = 0; i < ladder1.size; i++ ) {
            ladder1 moveZ( -430, 3, 1, 1 );
            wait .05;
        }
        break;
        case 1:
        for( i = 0; i < ladder2.size; i++ ) {
            ladder2 moveZ( -430, 3, 1, 1 );
            wait .05;
        }
        break;
    }
}

trap14() {
    trig = getEnt( "trap14_trig", "targetname" );
    slide = getEnt( "trap14_1", "targetname" );

    trig setHintString("^7Press ^8&&1 ^7To Activate");
    trig waittill ("trigger");
    trig setHintString( "^8Activated" ); 

    slide moveZ( -200, 3, 1, 1 );
    wait 6;
    slide moveZ( 200, 3, 1, 1 );
}

trap15() {
    trig = getEnt( "trap15_trig", "targetname" );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );
    fxspawn=getEntArray("electric_fx3","targetname");
    for(i=0;i<fxspawn.size;i++)
    {
        
        level.fxtrap3[i]=spawnfx(level._effect[ "electric"],fxspawn[i].origin);
        triggerfx(level.fxtrap3[i]);
    }

    level.elec3 = true;
    thread trap15_kill();
    wait 5;
    level.elec3 = false;
    for(i=0;i<level.fxtrap3.size;i++)
    {
        level.fxtrap3[i] delete();
    }
}

trap15_kill() {
    hurt = getEnt( "trap15_hurt", "targetname" );
    while( level.elec3 ) {
        hurt waittill( "trigger", player );
        if(level.elec3)
        player suicide();
    }
}

trap16() {
    trig = getEnt( "trap16_trig", "targetname" );
    spike1 = getEnt( "trap16_1", "targetname" );
    spike2 = getEnt( "trap16_2", "targetname" );
    hurt1 = getEnt( "trap16_1_hurt", "targetname" );
    hurt2 = getEnt( "trap16_2_hurt", "targetname" );

    hurt1 EnableLinkTo();
    hurt1 LinkTo( spike1 );

    hurt2 EnableLinkTo();
    hurt2 LinkTo( spike2 );

    trig setHintString( "^7Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", player );
    trig setHintString( "^8Activated" );  

    spike1 moveX( -395, 1, 1 );
    spike2 moveX( 395, 1, 1 );
    wait 3;
    spike1 moveX( 395, 1, 1 );
    spike2 moveX( -395, 1, 1 );
}

old() {
    level.old = getEnt( "old_trig", "targetname" );
    door1 = getEnt( "old_door3", "targetname" );
    door2 = getEnt( "old_door2", "targetname" );

    level.old setHintString( "^7Press ^8&&1 ^7to go ^8Old^7!" );
    level.old waittill( "trigger", player );

    level.old delete();
    level.bounce delete();
    level.sniper delete();
    level.knife delete();

    door1 moveZ( -201, 3, 1, 1 );
    wait 3;
    door2 moveZ( -201, 3, 1, 1 );
    wait 3;

    door1 delete();
    door2 delete();
}

knife() {   
 
    level.knife = getEnt( "knife_trig", "targetname");
    jump = getEnt( "knife_jump_origin", "targetname" );
    acti = getEnt( "knife_acti_origin", "targetname" ); 

    while( 1 ) {

        level.inRoom = false;
        level.knife setHintString( "Press ^8&&1 to choose ^8Knife^7!" );        
        level.knife waittill( "trigger", player );
        level.knife setHintString( "^8" + player.name + " ^7is in knife with ^8" + level.activ.name + "^7!" );  // change to level.activ

            if( !level.inRoom ) {

            if( isDefined( level.knife ) ) 
            level.inRoom = true;
            level.inKnife = true;

                level.bounce delete();    
                level.sniper delete();
                level.old delete();

                wait 0.05;
		        knife_hud = SpawnStruct();
	    	    knife_hud.titleText = "Knife Room";
	    	    knife_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    knife_hud.glowcolor = (.1725, .7373, .8);
	    	    knife_hud.duration = 5;
	    	    players = getEntArray( "player", "classname" );
	    	    for ( i = 0; i < players.size; i++ ) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( knife_hud );
	    	    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player.maxhealth = 100; 

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" ); 
                    level.activ.maxhealth = 100; 
                }

                level.activ freezeControls( true );
                player freezeControls( true );
                wait 3;
                player freezeControls( false );
                level.activ freezeControls( false );

	    	    player waittill( "death" );
	    	    level.inRoom = false;
        }
    }
}

sniper() {
 
    level.sniper = getEnt( "sniper_trig", "targetname"); 
    jump = getEnt( "sniper_jump_origin", "targetname" );
    acti = getEnt( "sniper_acti_origin", "targetname" ); 

    while( 1 ) {

        level.inRoom = false;
        level.sniper setHintString( "Press ^8&&1 ^7to choose ^8Sniper!" );        
        level.sniper waittill( "trigger", player );
        level.sniper setHintString( "^8" + player.name + " ^7is in Sniper battling it out with ^8" + level.activ.name + "^7!" );

        if( !level.inRoom ) {
        
            if( isDefined( level.sniper ) ) 
            level.inRoom = true;
            level.inSniper = true;

            level.bounce delete();
            level.knife delete();
            level.old delete();

            wait 0.05;
		    sniper_hud = SpawnStruct();
		    sniper_hud.titleText = "Sniper Room";
		    sniper_hud.notifyText = player.name + " [^3VS^7] " + level.activ.name;     // change self.name to level.activ.name
		    sniper_hud.glowcolor = (.1725, .7373, .8);
		    sniper_hud.duration = 5;
		    
            players = getEntArray( "player", "classname" );
		    for ( i = 0; i < players.size; i++ ) {
		        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( sniper_hud );
		    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "m40a3_mp" );
                player giveMaxAmmo( "m40a3_mp" );
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );   
                player switchToWeapon( "remington700_mp" );
                player.maxhealth = 100;

            if( isDefined( level.activ ) && isAlive( level.activ ) ) {
    
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin ); 
                level.activ TakeAllWeapons(); 
                level.activ GiveWeapon( "m40a3_mp" ); 
                level.activ giveMaxAmmo( "m40a3_mp" ); 
                level.activ GiveWeapon( "remington700_mp" );
                level.activ giveMaxAmmo( "remington700_mp" );
                level.activ SwitchToWeapon( "remington700_mp" );
                level.activ.maxhealth = 100; 
            }           

            level.activ freezeControls( true );
            player freezeControls( true );
            wait 3;
            player freezeControls( false );
            level.activ freezeControls( false );

            player waittill( "death" );
	    	level.inRoom = false;
        }
    }
}

bounce() {
 
    level.bounce = getEnt( "bounce_trig", "targetname");
    jump = getEnt( "bounce_jump_origin", "targetname" );
    acti = getEnt( "bounce_acti_origin", "targetname" );

    while( 1 ) {
        
        level.inRoom = false;
        level.bounce setHintString( "Press ^8&&1 ^7to choose ^8Bounce!" );        
        level.bounce waittill( "trigger", player );
        level.bounce setHintString( "^8" + player.name + " ^7is in Bounce battling it out with ^8" + level.activ.name + "^7!" );
            
            if( !level.inRoom ) {
            
                if( isDefined( level.bounce ) ) 
                level.inRoom = true;
                level.inBounce = true;  

                level.old delete();
                level.knife delete();
                level.sniper delete();

                wait 0.05;
	    	    bounce_hud = SpawnStruct();
	    	    bounce_hud.titleText = "Bounce Room";
	    	    bounce_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;     // change self.name to level.activ.name
	    	    bounce_hud.glowcolor = (.1725, .7373, .8);
	    	    bounce_hud.duration = 5;
	    	    players = getEntArray( "player", "classname" );
	    	    for ( i = 0; i < players.size; i++ ) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( bounce_hud );
	    	    }

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player GiveWeapon( "knife_mp" );
                player switchToWeapon( "knife_mp" );
                player.maxhealth = 100;

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ switchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100;
                }

                thread bounce_weap();

                level.activ freezeControls( true );
                player freezeControls( true );
                wait 3;
                player freezeControls( false );
                level.activ freezeControls( false );
    
                player waittill( "death" );
	    	    level.inRoom = false;
        }
    }
}

bounce_weap() {
    weapon = getEnt( "bounce_weap_trig", "targetname" );
    weapon setHintString( "Press ^8&&1 ^7to get a ^8Sniper!" );   

    while( 1 ) { 
        weapon waittill( "trigger", player );
        player giveWeapon( "remington700_mp" );
        player giveMaxAmmo( "remington700_mp" );
        player switchToWeapon( "remington700_mp" );
        player giveWeapon( "m40a3_mp" );
        player giveMaxAmmo( "m40a3_mp" );
        player takeWeapon( "knife_mp" );
   }
}

bounce_fail() {
    
    jump = getEnt( "bounce_jump_origin", "targetname" );
    acti = getEnt( "bounce_acti_origin", "targetname" );
    trig = getEnt( "bounce_fail_trig", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", player );

        if( player.pers["team"] == "allies" ) {
            player freezeControls( 1 );
            player SetPlayerAngles( jump.angles );
            player SetOrigin( jump.origin );
            player freezeControls( 0 );
        }
        else if( player.pers["team"] == "axis" ) {
            level.activ freezeControls( 1 );
            level.activ setPlayerAngles ( acti.angles );
            level.activ setOrigin( acti.origin );
            level.activ freezeControls( 0 );
        }
    }
}