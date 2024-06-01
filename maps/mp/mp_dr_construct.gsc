
//░█████╗░░█████╗░███╗░░██╗░██████╗████████╗██████╗░██╗░░░██╗░█████╗░████████╗
//██╔══██╗██╔══██╗████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░██║██╔══██╗╚══██╔══╝
//██║░░╚═╝██║░░██║██╔██╗██║╚█████╗░░░░██║░░░██████╔╝██║░░░██║██║░░╚═╝░░░██║░░░
//██║░░██╗██║░░██║██║╚████║░╚═══██╗░░░██║░░░██╔══██╗██║░░░██║██║░░██╗░░░██║░░░
//╚█████╔╝╚█████╔╝██║░╚███║██████╔╝░░░██║░░░██║░░██║╚██████╔╝╚█████╔╝░░░██║░░░
//░╚════╝░░╚════╝░╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░╚═════╝░░╚════╝░░░░╚═╝░░░

// Map by Mist
// Some scripting help from Jax & Rex109
// Thanks to liserd cause i stole his pure strafe script

// Discord: Mist#0001
// krispykrew.net/discord

main() {

	maps\mp\_load::main();

    // Lighting
	setdvar( "r_specularcolorscale", "1"  );
	setdvar( "r_glowbloomintensity0",".1" );
	setdvar( "r_glowbloomintensity1",".1" );
	setdvar( "r_glowskybleedintensity",".1" );


    // Fall Damage
	setdvar("bg_fallDamageMaxHeight","9999999");
    setdvar("bg_fallDamageMinHeight","9999998");

    // Song List
    if(!isdefined(level.music))
    level.music=[];
    level.music[0]["song"] ="soitchy - tolva";
    level.music[0]["alias"] ="song1";
    level.music[1]["song"] ="BigY - our fluctuating self esteem";
    level.music[1]["alias"] ="song2";
    level.music[2]["song"] ="polo g - rapstar";
    level.music[2]["alias"] ="song3";
    level.music[3]["song"] ="fantompower - blankets";
    level.music[3]["alias"] ="song4";
    level.music[4]["song"] ="juice wrld - pain (prod. last dude)";
    level.music[4]["alias"] ="song5";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-128, 0, 60), 0);

    // Old Teleports
    //thread acti_stage2_back();
    //thread acti_stage1_back();
    //thread acti_stage2_goto();
    //thread acti_stage3_goto();

    // Troll
    //thread stu();
    //thread nb();
    //thread liserd();
    //thread chicken1();

    // Secret
    thread secret_enter();
    //thread acti_secret_enter();
    //thread acti_secret_fail();
    thread secret_finish();
    //thread acti_secret_finish();
    //thread acti_secret_exit();

    // Stuff
    //thread musicBox();
    thread startdoor();
    thread finishmap();
    //thread credits();
    //thread vip();

    // Traps
    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap6();
    thread trap7();
    thread trap8();
    thread trap9();
    thread trap10();

    // Endrooms
    //thread old();
    //thread zombie();
    //thread purestrafe();
    //thread sniper();
    //thread bounce();

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
}

addTriggerToList( name ) {

   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

stu() {
    level waittill( "round_started" );
    trig = getEnt( "ele_trig", "targetname" );
    wait 5;

    while( 1 ) {
        trig waittill( "trigger", p );
        iPrintLnBold( p.name + " tried to ele lol" );
        p suicide();
    }
}

nb() {
    level waittill( "round_started" );
    trig = getEnt( "nb_trig", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p iPrintLnBold( "nigga balls" );
    }
}

liserd() {
    level waittill( "round_started" );
    trig = getEnt( "liserd_trig", "targetname" );
    chiken = getEnt( "chicken", "targetname" );
    clip = getEnt( "secret_clip", "targetname" );

    trig waittill( "trigger", p );
    trig delete();
    chiken delete();

    clip delete();
    iPrintLnBold( "ur mom" );
}

chicken1() {
    level waittill( "round_started" );
    trig = getEnt( "chicken1_trig", "targetname" );
    chicken = getEnt( "chicken1", "targetname" );

    trig waittill( "trigger", p );
    p iPrintLnBold( "you found the first chiken" );
    chicken delete();
    thread chicken2();
}

chicken2() {
    trig = getEnt( "chicken2_trig", "targetname" );
    chicken = getEnt( "chicken2", "targetname" );

    trig waittill( "trigger", p );
    p iPrintLnBold( "you found the second chiken" );
    chicken delete();
    thread chicken3();
}

chicken3() {
    trig = getEnt( "chicken3_trig", "targetname" );
    chicken = getEnt( "chicken3", "targetname" );

    trig waittill( "trigger", p );
    p iPrintLnBold( "you found the third chiken" );
    chicken delete();
    thread chicken4();
}

chicken4() {
    trig = getEnt( "chicken4_trig", "targetname" );
    chicken = getEnt( "chicken4", "targetname" );

    trig waittill( "trigger", p );
    p iPrintLnBold( "you found the fourth chiken" );
    chicken delete();
    thread chicken5();
}

chicken5() {
    trig = getEnt( "chicken5_trig", "targetname" );
    chicken = getEnt( "chicken5", "targetname" );

    trig waittill( "trigger", p );
    p iPrintLnBold( "you found the fifth chiken" );
    chicken delete();
    thread chicken6();
}

chicken6() {
    trig = getEnt( "chicken6_trig", "targetname" );
    chicken = getEnt( "chicken6", "targetname" );

    trig waittill( "trigger", p );
    p iPrintLnBold( "you found the sixth chiken" );
    chicken delete();
    thread chicken7();
}

chicken7() {
    trig = getEnt( "chicken7_trig", "targetname" );
    chicken = getEnt( "chicken7", "targetname" );

    trig waittill( "trigger", p );
    iPrintLnBold( p.name + " found the all chikens so everyone gets 1k xp" );
    braxi\_rank::giveRankXp(undefined, 1000);
    chicken delete();
}

secret_enter()
{
	trig = spawn("trigger_radius",(-127.949, 145.647, 0.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("secret_enter_org","targetname");
	ori.angles = (0,0,0);


	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}
acti_secret_enter() {
    trig = getEnt( "acti_secret_enter_trig", "targetname" );
    level.actigoto = getEnt( "acti_secret_enter_org", "targetname" );
    
    trig setHintString( "come here if your bored" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( level.actigoto.origin );
        p setPlayerAngles( level.actigoto.angles );
    }
}

acti_secret_exit() {
    trig = getEnt( "acti_secret_exit_trig", "targetname" );

    trig setHintString( "Press ^8&&1 to go back to spawn" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( level.actifinish.origin );
        p setPlayerAngles( level.actifinish.angles );
    }
}

acti_secret_fail() {
    trig = getEnt( "acti_secret_fail_trig", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( level.actigoto.origin );
        p setPlayerAngles( level.actigoto.angles );
    }
}

acti_secret_finish() {
    trig = getEnt( "acti_secret_finish_trig", "targetname" );
    level.actifinish = getEnt( "acti_secret_finish_org", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( level.actifinish.origin );
        p setPlayerAngles( level.actifinish.angles );
    }
}

secret_finish() {

    trig = getEnt("secret_finish_trig","targetname");
    finish = getEnt("secret_finish_org","targetname");

    for(;;) 
    {
     trig waittill( "trigger", player );
     player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

musicBox()
{
    trig=getent("music_trig","targetname");

    trig setHintString("Press &&1 to choose a track");
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
    self endon("disconnect");
    self endon("death");
    self endon("spawned");
    self endon("joined_spectators");
    self endon("music thread terminated");
 
    self.hud_music = [];
    self.selection = 0;

    i = 0;

    self.hud_music[i] = braxi\_mod::addTextHud(self, 320, 30, 0.93, "center", "top", 1.4);
    self.hud_music[i].sort = 884;
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud(self, 320, 360, 1, "center", "bottom", 1.4);
    self.hud_music[i].sort = 886;
    //self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7");
 
    for(j = 0; j < level.music.size; j++)
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud(self, 320, 230+(j*16), 0.93, "center", "top", 1.4);
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
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud(self, 320, 230, 0.4, "center", "top", 1.4);
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader("white", 550, 17);
    indicator.color=(0,0.7,1);
	
	wait 0.5;
 
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_music[2+self.selection].alpha = 0.93;
 
            self.selection++;
            if(self.selection >= level.music.size)
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

startdoor() {
    door = getEnt( "startdoor", "targetname" );


    door delete();
}

trap1() {
    trig = getEnt( "trap1_trig", "targetname" );
    drop = getEnt( "trap1_1", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap2() {
    trig = getEnt( "trap2_trig", "targetname" );
    drop1 = getEnt( "trap2_1", "targetname" );
    drop2 = getEnt( "trap2_2", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );
 
}

trap3() {
    trig = getEnt( "trap3_trig", "targetname" );
    plat1 = getEnt( "trap3_1", "targetname" );
    plat2 = getEnt( "trap3_2", "targetname" );
    plat3 = getEnt( "trap3_3", "targetname" );
    plat4 = getEnt( "trap3_4", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap4() {
    trig = getEnt( "trap4_trig", "targetname" );
    log1 = getEnt( "trap4_1", "targetname" );
    log2 = getEnt( "trap4_2", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap5() {
    trig = getEnt( "trap5_trig", "targetname" );
    container = getEnt( "trap5_container", "targetname" );
    clip = getEnt( "trap5_clip", "targetname" );
    hurt = getEnt( "trap5_hurt", "targetname" );

    clip LinkTo( container );

    hurt EnableLinkTo();
    hurt LinkTo( container );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );
 
}

trap6() {
    trig = getEnt( "trap6_trig", "targetname" );
    drop = getEnt( "trap6_1", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap7() {
    trig = getEnt( "trap7_trig", "targetname" );
    wall = getEnt( "trap7_1", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap8() {
    trig = getEnt( "trap8_trig", "targetname" );
    log1 = getEnt( "trap8_1", "targetname" );
    log2 = getEnt( "trap8_2", "targetname" );
    log3 = getEnt( "trap8_3", "targetname" );
    log4 = getEnt( "trap8_4", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap9() {
    trig = getEnt( "trap9_trig", "targetname" );
    onea = getEnt( "trap9_1a", "targetname" );
    oneb = getEnt( "trap9_1b", "targetname" );
    twoa = getEnt( "trap9_2a", "targetname" );
    twob = getEnt( "trap9_2b", "targetname" );
    threea = getEnt( "trap9_3a", "targetname" );
    threeb = getEnt( "trap9_3b", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

trap10() {
    trig = getEnt( "trap10_trig", "targetname" );
    one = getEnt( "trap10_1", "targetname" );
    two = getEnt( "trap10_2", "targetname" );

    trig setHintString( "Press ^8&&1 ^7To Activate" );
    trig waittill( "trigger", p );

}

finishmap() {
    trig = getEnt( "end_trig", "targetname" );
    goto = getEnt( "end_org", "targetname" );

    for(;;)
    {
    trig waittill( "trigger", p );
    p setOrigin( goto.origin );
    p setPlayerAngles( goto.angles );
    }
}

credits() {
    level waittill( "round_started" );
    wait 5;
    
    while( 1 ) {
        iPrintLn( "Mapped by ^8Mist ^7for ^8Krispy Krew");
        wait 7;
        iPrintLn( "visit ^8krispykrew.net/discord" );
        wait 7;
        iPrintLn( "Thanks to ^8Rex109 ^7for the sniper room" );
        wait 7;
        iPrintLn( "^8Jax ^7is here for no reason" );
        wait 7;
    }
}

vip()
{
    level waittill( "round_started" );
    wait 3;

    players = GetEntArray("player", "classname");
    for(i=0; i < players.size; i++)
    {
        guid = getSubStr( players[i] getGuid(), 11, 19 );
        if( players[i].pers["team"] == "allies" )
        {
            if((guid == "66225623") || (guid == "03512897") || (guid == "32152259") || (guid == "30421138") || (guid == "43388331") || (guid == "09210966"))
            {
                players[i] detachAll();
                players[i] iPrintlnBold( "^7Grats on ^8VIP " + players[i].name );
                players[i] setModel( "t6_zombie_body" );
                players[i] GiveWeapon( "m40a3_mp" );
                players[i] GiveMaxAmmo( "m40a3_mp" );
                players[i] SwitchToWeapon( "m40a3_mp" );
                self.headicon = "koopa_headicon";
            }
        }
    }
}

acti_stage2_back() {
    trig = getEnt( "acti_stage2_back_trig", "targetname" );
    goto = getEnt( "acti_stage2_back_org", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( goto.origin );
        p setPlayerAngles( goto.angles );
    }
}

acti_stage1_back() {
    trig = getEnt( "acti_stage1_back_trig", "targetname" );
    goto = getEnt( "acti_stage1_back_org", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( goto.origin );
        p setPlayerAngles( goto.angles );
    }
}

acti_stage2_goto() {
    trig = getEnt( "acti_stage2_goto_trig", "targetname" );
    goto = getEnt( "acti_stage2_goto_org", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( goto.origin );
        p setPlayerAngles( goto.angles );
    }
}

acti_stage3_goto() {
    trig = getEnt( "acti_stage3_goto_trig", "targetname" );
    goto = getEnt( "acti_stage3_goto_org", "targetname" );

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( goto.origin );
        p setPlayerAngles( goto.angles );
    }
}

old() {
    level.old = getEnt( "old_trig", "targetname" );
    level.old_tp_blue = getEnt( "old_tp_blue", "targetname" );
    level.old_tp_red = getEnt( "old_tp_red", "targetname" );
    door = getEnt( "old_door", "targetname" );

    level.old_tp_blue show();
    level.old_tp_red hide();

    level.old setHintString( "Press ^8&&1 ^7to choose ^8Old!" );
    level.old waittill( "trigger", p );
    iprintlnbold(  "^8" + p.name + " ^7chose the ^8old way!" );

    level.bounce_tp_red show();
    level.bounce_tp_blue hide();
    level.sniper_tp_red show();
    level.sniper_tp_blue hide();
    level.pure_tp_red show();
    level.pure_tp_blue hide();
    level.zombie_tp_red show();
    level.zombie_tp_blue hide();

    level.old delete();
    level.zombie delete();
    level.sniper delete();
    level.purestrafe delete();
    level.bounce delete();

    door moveZ( -130, 3, 1, 1 );
    thread old_go();
}

old_go() {

    trig = getEnt("old_go_trig","targetname");
    old = getEnt("old_go_org","targetname");

    while( 1 ) {
        trig waittill( "trigger", p );
        p setOrigin( old.origin );
        p setPlayerAngles( old.angles );
	}
}

zombie() {   
 
    level.zombie = getEnt( "zombie_trig", "targetname");
    level.zombie_tp_blue = getEnt( "zombie_tp_blue", "targetname" );
    level.zombie_tp_red = getEnt( "zombie_tp_red", "targetname" );
    jump = getEnt( "jump_zombie_org", "targetname" );
    acti = getEnt( "acti_zombie_org", "targetname" ); 

    level.zombie_tp_red hide();
    level.zombie_tp_blue show();

    while( 1 ) {

        level.inRoom = false;
        level.zombie setHintString( "Press ^8&&1 ^7to choose ^8Zombie!" );        
        level.zombie waittill( "trigger", p );
        level.zombie setHintString( "^8" + p.name + " ^7is in the zombie room with ^8" + level.activ.name + "^7!" );  // change to level.activ

            level.old_tp_red show();
            level.old_tp_blue hide();
            level.bounce_tp_red show();
            level.bounce_tp_blue hide();
            level.sniper_tp_red show();
            level.sniper_tp_blue hide();
            level.pure_tp_red show();
            level.pure_tp_blue hide();

            if( !level.inRoom ) {

            if( isDefined( level.zombie ) ) 
            level.inRoom = true;
            level.inKnife = true;

                level.old delete();
                level.sniper delete();    
                level.purestrafe delete();
                level.bounce delete();

                wait 0.05;
		        knife_hud = SpawnStruct();
	    	    knife_hud.titleText = "Zombie Room";
	    	    knife_hud.notifyText = p.name + " [^8VS^7] " + level.activ.name;
	    	    knife_hud.glowcolor = (.1725, .7373, .8);
	    	    knife_hud.duration = 5;
	    	    players = getEntArray( "player", "classname" );
	    	    for ( i = 0; i < players.size; i++ ) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( knife_hud );
	    	    }

                p SetPlayerAngles( jump.angles );
                p setOrigin( jump.origin );
                p TakeAllWeapons(); 
                p setModel( "t6_zombie_body" );
                p setViewModel( "t6_zombie_arms" );
                p GiveWeapon( "m40a3_mp" );
                p switchToWeapon( "m40a3_mp" );
                p.maxhealth = 100; 

                if( isDefined( level.activ ) && isAlive( level.activ ) ) {

                    level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons(); 
                    level.activ setModel( "t6_zombie_body" );
                    level.activ setViewModel( "t6_zombie_arms" );
                    level.activ GiveWeapon( "m40a3_mp" );
                    level.activ switchToWeapon( "m40a3_mp" ); 
                    level.activ.maxhealth = 100; 
                }

                level.activ freezeControls( true );
                p freezeControls( true );
                wait 3;
                p freezeControls( false );
                level.activ freezeControls( false );

	    	    p waittill( "death" );
	    	    level.inRoom = false;
        }
    }
}

purestrafe() {

    level.purestrafe = getEnt ("purestrafe_trig", "targetname");
    level.pure_tp_blue = getEnt( "pure_tp_blue", "targetname" );
    level.pure_tp_red = getEnt( "pure_tp_red", "targetname" );
    orig_jumper = getEnt ("jump_purestrafe_org", "targetname");
    orig_acti = getEnt ("acti_purestrafe_org", "targetname");

    level.pure_tp_red hide();
    level.pure_tp_blue show();

    while (1)
    {
        level.purestrafe setHintString( "Press ^8&&1 ^7to choose ^8Pure Strafe!" );     
        level.purestrafe waittill ("trigger", player);
        level.purestrafe setHintString( "^8" + player.name + " ^7is in the purestrafe room with ^8" + level.activ.name + "^7!" );  // change to level.activ

        level.old_tp_red show();
        level.old_tp_blue hide();
        level.bounce_tp_red show();
        level.bounce_tp_blue hide();
        level.sniper_tp_red show();
        level.sniper_tp_blue hide();
        level.zombie_tp_red show();
        level.zombie_tp_blue hide();

        level.old delete();
        level.sniper delete();    
        level.zombie delete();
        level.bounce delete();

        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player freezecontrols (1);
        player giveWeapon("knife_mp");
        player switchToWeapon ("knife_mp");
        player.maxhealth = 100;

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setPlayerAngles(orig_acti.angles);
            level.activ setOrigin(orig_acti.origin);
            level.activ takeAllWeapons();
            level.activ giveWeapon("knife_mp");
            level.activ switchToWeapon("knife_mp");
            level.activ.maxhealth = 100;
            level.activ freezecontrols(1);
        }
        strafe_hud = SpawnStruct();
	    strafe_hud.titleText = "Pure Strafe Room";
	    strafe_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    strafe_hud.glowcolor = (.1725, .7373, .8);
	    strafe_hud.duration = 5;
	    players = getEntArray("player", "classname");
	    for (i = 0; i < players.size; i++) {
	    	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(strafe_hud);
	    }
        wait 5;
        player freezecontrols (0);
        level.activ freezecontrols(0);
        thread purestrafe_finish(player, level.activ);

        while(isAlive(player) && isDefined(player))
            wait .05;

        level notify("strafeend");

        iPrintLnBold ("^8" + player.name + " ^7lost");
    }
}

purestrafe_finish(who, who2)
{
    level endon("strafeend");
    trig = getEnt ("purestrafe_finish_trig", "targetname");
    origWin = getEnt ("win_purestrafe_finish_org", "targetname");
    origLose = getEnt ("lose_purestrafe_finish_org", "targetname");

    while(1)
    {
        trig waittill("trigger", winner);
        winner iPrintLnBold("^8You won!");
        winner setOrigin (origWin.origin);
        winner setPlayerAngles (origWin.angles);
        winner takeAllWeapons();
        winner giveWeapon("saw_reflex_mp");
        winner giveMaxAmmo("saw_reflex_mp");
        winner switchToWeapon("saw_reflex_mp");

        if (winner == who)
            loser = who2;
        else
            loser = who;

        if (isDefined(loser))
        {
            loser setOrigin (origLose.origin);
            loser setPlayerAngles (origLose.angles);
            loser freezeControls (1);
            loser takeAllWeapons();
            loser iPrintLnBold("^8unlucky");
        }
    }
}

sniper() {
 
    level.sniper = getEnt( "sniper_trig", "targetname");
    level.sniper_tp_blue = getEnt( "sniper_tp_blue", "targetname"); 
    level.sniper_tp_red = getEnt( "sniper_tp_red", "targetname"); 
    
    level.sniper_tp_red hide();
    level.sniper_tp_blue show();

    jump = getEnt( "jump_sniper_org", "targetname" );
    acti = getEnt( "acti_sniper_org", "targetname" ); 

    while( 1 ) {

        level.inRoom = false;
        level.sniper setHintString( "Press ^8&&1 ^7to choose ^8Sniper!" );        
        level.sniper waittill( "trigger", player );
        level.sniper setHintString( "^8" + player.name + " ^7is in Sniper battling it out with ^8" + level.activ.name + "^7!" );

        level.old_tp_red show();
        level.old_tp_blue hide();
        level.bounce_tp_red show();
        level.bounce_tp_blue hide();
        level.zombie_tp_red show();
        level.zombie_tp_blue hide();
        level.pure_tp_red show();
        level.pure_tp_blue hide();

        if( !level.inRoom ) {
        
            if( isDefined( level.sniper ) ) 
            level.inRoom = true;
            level.inSniper = true;

            level.old delete();
            level.purestrafe delete();    
            level.zombie delete();
            level.bounce delete();

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
    level.bounce_tp_blue = getEnt( "bounce_tp_blue", "targetname" );
    level.bounce_tp_red = getEnt( "bounce_tp_red", "targetname" );
    jump = getEnt( "jump_bounce_org", "targetname" );
    acti = getEnt( "acti_bounce_org", "targetname" );

    level.bounce_tp_red hide();
    level.bounce_tp_blue show();

    while( 1 ) {
        
        level.inRoom = false;
        level.bounce setHintString( "Press ^8&&1 ^7to choose ^8Bounce!" );        
        level.bounce waittill( "trigger", player );
        level.bounce setHintString( "^8" + player.name + " ^7is in Bounce battling it out with ^8" + level.activ.name + "^7!" );

            level.old_tp_red show();
            level.old_tp_blue hide();
            level.sniper_tp_red show();
            level.sniper_tp_blue hide();
            level.zombie_tp_red show();
            level.zombie_tp_blue hide();
            level.pure_tp_red show();
            level.pure_tp_blue hide();

            if( !level.inRoom ) {
            
                if( isDefined( level.bounce ) ) 
                level.inRoom = true;
                level.inBounce = true;  

                level.old delete();
                level.purestrafe delete();    
                level.zombie delete();
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

                thread bounce_grab();
                thread bounce_fail();

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

bounce_grab() {

    weapon = getEnt( "bounce_grab_trig", "targetname" );
    weapon setHintString( "Press ^8&&1 ^7to grab a ^8Sniper!" ); 

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
    
    jump = getEnt( "jump_bounce_org", "targetname" );
    acti = getEnt( "acti_bounce_org", "targetname" );
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