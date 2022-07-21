/*
______           __  _____  _____ 
| ___ \         /  ||  _  ||  _  |
| |_/ /_____  __`| || |/' || |_| |
|    // _ \ \/ / | ||  /| |\____ |
| |\ \  __/>  < _| |\ |_/ /.___/ /
\_| \_\___/_/\_\\___/\___/ \____/ 

Welcome to mp_dr_undertale script. Feel free to take any piece of code, no need to credit me.

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
	

	if(!isdefined(level.music))
	level.music=[];
	level.music[0]["song"]    ="Toby Fox - Ruins";
	level.music[0]["alias"]    ="radio1";
	level.music[1]["song"]    ="Toby Fox - Waterfall";
	level.music[1]["alias"]    ="radio2";
	level.music[2]["song"]    ="Toby Fox - Bonetrousle";
	level.music[2]["alias"]    ="radio3";
	level.music[3]["song"]    ="Toby Fox - Asgore";
	level.music[3]["alias"]    ="radio4";
	
	//END MUSIC
	level.end_playing = false;
	
	//GENERAL THREADS
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    	//thread secret_act();
	//thread secret_end();
	//thread musicBox();
	thread opening();
	//thread fananim();
	//thread fantrigger();
	
	//ACTIVATOR THREADS
	//TELEPORTS
	//thread tpforward1();
	//thread tpforward2();
	//thread tpback1();
	//thread tpback2();
	//TRAPS
	addTriggerToList("trap1");
	addTriggerToList("trap2");
	addTriggerToList("trap3");
	addTriggerToList("trap4");
	addTriggerToList("trap5");
	addTriggerToList("trap6");
	addTriggerToList("trap7");
	addTriggerToList("trap8");
	
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	
	//BATTLE THREADS
	//thread knife();
	//thread sniper();
	//thread deagle();
	
}

/*
   ___                       _ 
  / __|___ _ _  ___ _ _ __ _| |
 | (_ / -_) ' \/ -_) '_/ _` | |
  \___\___|_||_\___|_| \__,_|_|
                               
*/

playSoundOnAllPlayers( soundAlias )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		players[i] playLocalSound( soundAlias );
	}
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

musicBox()
{
    trig=getent("musicbox","targetname");
    trig waittill("trigger",p);
    trig delete();
    
    p freezecontrols(1);
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
    self.hud_music[i] setText("Undertale musicbox");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(1,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
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
             iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
            ambientPlay(level.music[self.selection]["alias"]);
            self freezecontrols(0);
            break;
        }
        else if(self fragButtonPressed())
        {
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

secret_act()
{
	
	secret_activate = getEnt("secret_activate","targetname");
	secret_graphics = getEnt("secret_graphics","targetname");
	secret = getEnt("secret","targetname");
	secret_start = getEnt( "secret_start", "targetname" );
	secret enablelinkto();
	secret linkto(secret_graphics); 
	secret_activate waittill("trigger", player);
	secret_activate setHintString ("^1Good Luck!");
	player playSound("ee");
	secret_graphics movez (577,0.1,0,0);
	for(;;)
	{
	secret waittill("trigger", player);
	player playSound("ee");
	player setOrigin( secret_start.origin );
	player setplayerangles( secret_start.angles );
	}
	
}

secret_end()
{
	secret_finish = getEnt( "secret_finish", "targetname" );
	secret_destination = getEnt( "secret_destination", "targetname" );
	for(;;)
	{
	secret_finish waittill("trigger", player);
	player setOrigin( secret_destination.origin );
	player setplayerangles( secret_destination.angles );
	level thread playSoundOnAllPlayers("eef");
	iPrintlnBold( "^3" + player.name + " ^1has finished the secret" );
	}
}

opening()
{
	l_door = getEnt("l_door","targetname");
	r_door = getEnt("r_door","targetname");
	l_door delete();
	r_door delete();
}

fananim()
{
	fananim = getEnt("fananim","targetname");
	while(1)
	{
		wait(0.1);
		fananim rotateYaw (360,0.5);
	}
}

fantrigger()
{
	trigger = getEnt ( "fantrigger", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", player );
		eInflictor = player;
		eAttacker = player;
		iDamage = 100;
		iDFlags = 0;
		sMeansOfDeath = "MOD_PROJECTILE";
		sWeapon = "panzershreck_mp";
		vPoint = ( player.origin + (0,0,-1) );
		vDir = vectornormalize( player.origin - vPoint );
		sHitLoc = "none";
		psOffsetTime = 0;
		player.health = ( player.health + iDamage );

		player finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
}

/*
    _      _   _          _           
   /_\  __| |_(_)_ ____ _| |_ ___ _ _ 
  / _ \/ _|  _| \ V / _` |  _/ _ \ '_|
 /_/ \_\__|\__|_|\_/\__,_|\__\___/_|  
                                      
*/

tpforward1()
{
	tp = getEnt( "tpforward1", "targetname" );
	destination = getEnt( "destination_forward1", "targetname" );
	for(;;)
	{
	tp waittill("trigger", player);
	player setOrigin( destination.origin );
	player setplayerangles( destination.angles );
	}
}

tpforward2()
{
	tp = getEnt( "tpforward2", "targetname" );
	destination = getEnt( "destination_forward2", "targetname" );
	for(;;)
	{
	tp waittill("trigger", player);
	player setOrigin( destination.origin );
	player setplayerangles( destination.angles );
	}
}

tpback1()
{
	tp = getEnt( "tpback1", "targetname" );
	destination = getEnt( "destination_back1", "targetname" );
	for(;;)
	{
	tp waittill("trigger", player);
	player setOrigin( destination.origin );
	player setplayerangles( destination.angles );
	}
}

tpback2()
{
	tp = getEnt( "tpback2", "targetname" );
	destination = getEnt( "destination_back2", "targetname" );
	for(;;)
	{
	tp waittill("trigger", player);
	player setOrigin( destination.origin );
	player setplayerangles( destination.angles );
	}
}

trap1()
{
	trap1 = getEnt("trap1","targetname");
	trapact1_1 = getEnt("trapact1_1","targetname");
	trapact1_2 = getEnt("trapact1_2","targetname");
	trap1 waittill("trigger",player);
	trap1 setHintString ("^1Trap activated!");
	trapact1_1 movez (-112,0.5);
	trapact1_2 movez (112,0.5);
	wait(0.5);
	while(1)
	{
		trapact1_1 movez (224,1);
		trapact1_2 movez (-224,1);
		wait(1);
		trapact1_1 movez (-224,1);
		trapact1_2 movez (224,1);
		wait(1);
	}
}

trap2()
{
	trap2 = getEnt("trap2","targetname");
	trapact2 = getEnt("trapact2","targetname");
	trap2 waittill("trigger",player);
	trap2 setHintString ("^1Trap activated!");
	while(1)
	{
		trapact2 rotateYaw (1800,2.5);
		wait(4);
	}
}

trap3()
{
	trap3 = getEnt("trap3","targetname");
	trapact3 = getEnt("trapact3","targetname");
	trapact3_trigg = getEnt("trapact3_trigg","targetname");
	trapact3_trigg enablelinkto();
	trapact3_trigg linkto(trapact3);
	trap3 waittill("trigger",player);
	trap3 setHintString ("^1Trap activated!");
	while(1)
	{
		trapact3 movez (122,1);
		wait(3);
		trapact3 movez (-122,1);
		wait(3);
	}
}

trap4()
{
	trap4 = getEnt("trap4","targetname");
	trapact4_1 = getEnt("trapact4_1","targetname");
	trapact4_2 = getEnt("trapact4_2","targetname");
	trap4 waittill("trigger",player);
	trap4 setHintString ("^1Trap activated!");
	trapact4_1 movez (-112,0.5);
	trapact4_2 movez (112,0.5);
	wait(0.5);
	while(1)
	{
		trapact4_1 movez (224,1);
		trapact4_2 movez (-224,1);
		wait(1);
		trapact4_1 movez (-224,1);
		trapact4_2 movez (224,1);
		wait(1);
	}
}

trap5()
{
	trap5 = getEnt("trap5","targetname");
	trapact5 = getEnt("trapact5","targetname");
	trap5 waittill("trigger",player);
	trap5 setHintString ("^1Trap activated!");
	trapact5 movez (-968,3);
	wait(6);
	trapact5 movez (968,3);
}

trap6()
{
	trap6 = getEnt("trap6","targetname");
	trapact6 = getEnt("trapact6","targetname");
	trap6 waittill("trigger",player);
	trap6 setHintString ("^1Trap activated!");
	while(1)
	{
		trapact6 rotatePitch (1800,5);
		wait(7);
	}
}

trap7()
{
	trap7 = getEnt("trap7","targetname");
	trapact7 = getEnt("trapact7","targetname");
	trapact7_trigg = getEnt("trapact7_trigg","targetname");
	trapact7_trigg enablelinkto();
	trapact7_trigg linkto(trapact7);
	trap7 waittill("trigger",player);
	trap7 setHintString ("^1Trap activated!");
	while(1)
	{
		trapact7 movez (626,3);
		wait(6);
		trapact7 movez (-626,3);
		wait(10);
	}
}

trap8()
{
	trap8 = getEnt("trap8","targetname");
	trapact8 = getEnt("trapact8","targetname");
	trap8 waittill("trigger",player);
	trap8 setHintString ("^1Trap activated!");
	while(1)
	{
		trapact8 movex (-474,3);
		wait(6);
		trapact8 movex (474,3);
		wait(10);
	}
}

/*

  ___       _   _   _     
 | _ ) __ _| |_| |_| |___ 
 | _ \/ _` |  _|  _| / -_)
 |___/\__,_|\__|\__|_\___|
                          
*/

info(msg, submsg)
{
	players = getentarray("player", "classname");
	noti = SpawnStruct();
	noti.titleText = msg;
	noti.notifyText = submsg;
	noti.duration = 5;
	noti.glowcolor = (0,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

knife()
{
		for(;;)
		{
        level.knife_room = getEnt( "knife_room", "targetname");
        jump = getEnt( "battle_jumper", "targetname" );
        acti = getEnt( "battle_activator", "targetname" );
 
        while(1) 
{
                level.knife_room waittill( "trigger", player );
                if( !isDefined( level.knife_room ) ) 
                return;
            
				if (level.end_playing == false)
				{
					level.end_playing = true;
					ambientStop( 0 );
					ambientPlay("end");
				}
				
			level thread playSoundOnAllPlayers("battle");
			
              level.sniper_room delete();
			  level.deagle_room delete();
			  
			  wait (1);
			  
            level thread playSoundOnAllPlayers("sans");
			
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" ); 
            player switchToWeapon( "knife_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" ); 
               level.activ SwitchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
            info("Knife Room", player.name + " ^1VS ^7" + level.activ.name);
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
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
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
		}
}

sniper()
{
		for(;;)
		{
        level.sniper_room = getEnt( "sniper_room", "targetname");
        jump = getEnt( "battle_jumper", "targetname" );
        acti = getEnt( "battle_activator", "targetname" );
 
        while(1) 
{
                level.sniper_room waittill( "trigger", player );
                if( !isDefined( level.sniper_room ) ) 
                return;
            
				if (level.end_playing == false)
				{
					level.end_playing = true;
					ambientStop( 0 );
					ambientPlay("end");
				}
				
			level thread playSoundOnAllPlayers("battle");
			
              level.knife_room delete();
			  level.deagle_room delete();
			  
			  wait (1);
			  
            level thread playSoundOnAllPlayers("sans");
			
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "m40a3_mp" ); //Gives player weapon
                player giveMaxAmmo( "m40a3_mp" ); //Gives player ammo
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );   
            player switchToWeapon( "m40a3_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m40a3_mp" ); 
                    level.activ giveMaxAmmo( "m40a3_mp" ); 
                    level.activ GiveWeapon( "remington700_mp" );
                    level.activ giveMaxAmmo( "remington700_mp" );
               level.activ SwitchToWeapon( "m40a3_mp" );
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
            info("Sniper Room", player.name + " ^1VS ^7" + level.activ.name);
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
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
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
		}
}

deagle()
{
		for(;;)
		{
        level.deagle_room = getEnt( "deagle_room", "targetname");
        jump = getEnt( "battle_jumper", "targetname" );
        acti = getEnt( "battle_activator", "targetname" );
 
        while(1) 
{
                level.deagle_room waittill( "trigger", player );
                if( !isDefined( level.deagle_room ) ) 
                return;
            
				if (level.end_playing == false)
				{
					level.end_playing = true;
					ambientStop( 0 );
					ambientPlay("end");
				}
				
			level thread playSoundOnAllPlayers("battle");
			
              level.sniper_room delete();
			  level.knife_room delete();
			  
			  wait (1);
			  
            level thread playSoundOnAllPlayers("sans");
			
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "deserteaglegold_mp" ); 
                player giveMaxAmmo( "deserteaglegold_mp" );
            player switchToWeapon( "deserteaglegold_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "deserteaglegold_mp" ); 
					level.activ giveMaxAmmo( "deserteaglegold_mp" ); 
               level.activ SwitchToWeapon( "deserteaglegold_mp" );
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
            info("Deagle Room", player.name + " ^1VS ^7" + level.activ.name);
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
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
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
		}
}