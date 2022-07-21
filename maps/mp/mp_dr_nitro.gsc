/*

	Map by NitroFire
	[If you plan to use these scripts, make sure to give credit where it is due.]

*/
main() //Main Map Script
{
thread sr\api\_map::createSpawnOrigin((-21, 45, 16), 1);
game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 //Fixes and Visual Tweaks
  setDvar("bg_falldamagemaxheight", 300000 );
  setDvar("bg_falldamageminheight", 128000 );
  setDvar("r_lightTweakSunColor", "1 0.921569 0.878431 1");
  setDvar("r_lightTweakSunDirection", "-50 136 1");
  setDvar("r_lightTweakSunLight", "1");

  //Threads

  thread sr\api\_speedrun::createNormalWays("Normal Way;");
  thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((4583.6, -9.91388, 2112.13), 135, 65, (8, 3616, 4476), 0, "freeze");
  thread sr\api\_speedrun::createTeleporter((268.113, 295.171, 16.125), 70, 10, (-2567, -4871, 188), 270, "freeze", "blue", "secret_0");
  thread sr\api\_speedrun::createTeleporter((6139.73, -1237.58, 16.125), 70, 10, (50, -8, 2124), 360, "freeze");
  thread sr\api\_speedrun::createTeleporter((702.889, 5352.01, 4608.13), 120, 45, (-4372, 8978, 3136), 90, "freeze");
  thread sr\api\_speedrun::createEndMap((5812.93, -18072.6, -9759.88), 420, 385, "secret_0");

  // thread introtext();
  // thread bottomtext();
  thread startdoor();
  thread teleport();
  // thread traps();
  thread moving_platform();
  thread secret_rpgs();
  thread secretfinish();
  // thread music();
  // thread endrooms();

  //Free Run Trap Fixes
   addTriggerToList("laser_trig");
   addTriggerToList("bouncepath_trig");
   addTriggerToList("spin_pillar_trig");
   addTriggerToList("spin_bounce_trig");
   addTriggerToList("spin_plat_trig");
   addTriggerToList("plat_remove_trig");
   addTriggerToList("hammer_trig");
   addTriggerToList("plat_move2_trig");
}

introtext() //Intro Text
{
	level waittill("round_started");
	noti = SpawnStruct();
		noti.titleText = " ^5 Welcome to mp_dr_nitro by ^1NitroFire!";
		noti.notifyText = "===================================";
		noti.duration = 5;
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
	 IPrintLn("^3>>Welcome to mp_dr_nitro by NitroFire!<<");
	 	wait 10;
	 IPrintLn("^1>>^7Steam : ^1david1205red^7.^1<<");
	 	wait 10;
	 IPrintLn("^1>>^7There are ^12 ^7Secrets on this Map! Try and find them!^1<<");
	 	wait 10;
	 IPrintLn("^1>>^7Thanks to the Entire ^0FAM^9OUS ^7Team!^1<<");
	 	wait 10;
	 IPrintLn("^1>>^7Mapping and Scripting by ^1NitroFire^7!^1<<");
	}
}

startdoor()
{
	door = getEnt("start_door","targetname");
	trig = getEnt("start_trig","targetname");
    door moveZ(200, 5);

	trig delete();
}

traps()
{
  // thread laser();
  // thread bouncepath();
  // thread spinningpillars();
  // thread spinbounce();
  // thread spinningplatforms();
  // thread platremove();
  // thread hammers();
  // thread platmove2();
  // thread fastmove();
}

laser() //Laser Trap
{
	laser = getEnt("laser","targetname");
	 trig = getEnt("laser_trig","targetname");

			trig SetHintString("Press [^5USE^7] to Activate the Laser!");
	  	trig waittill("trigger", player );

	  		trig delete();

	  		while(1)
	  	{
	  			laser moveY(-980, 1);
	  		 	 laser waittill("movedone");

			  laser moveY(980, 1);
			 laser waittill("movedone");

				 wait 4;
	  	}

}

bouncepath() //Removes the path next to the bounce
{
	path = getEnt("bounce_path_remove","targetname");
	 trig = getEnt("bounce_path_trig","targetname");

	 trig SetHintString("Press [^5USE^7] to Remove the Path!");
	trig waittill("trigger", player );

	trig delete();

	 	path delete();
}

spinningpillars() //Spins the 3 Pillars
{
	pillar1 = getEnt("pillar1","targetname");
	 pillar2 = getEnt("pillar2","targetname");
	  pillar3 = getEnt("pillar3","targetname");
	   trig = getEnt("spin_pillar_trig","targetname");

	   trig SetHintString("Press [^5USE^7] to Spin the Pillars!");
	trig waittill("trigger", player );

	trig delete();

		while(1)
   {
	pillar1 rotateYaw(360, 1);
		wait 1;
	pillar2 rotateYaw(360, 1);
		wait 1;
	pillar3 rotateYaw(360, 1);
		wait 5;
   }
}

spinbounce() //Spins the bounce
{
	bounce = getEnt("spin_bounce","targetname");
	 trig = getEnt("spin_bounce_trig","targetname");

	trig SetHintString("Press [^5USE^7] to Spin the Bounce!");
	 trig waittill("trigger", player );

	 			trig delete();

	 		while(1)
	 	{
	 		bounce RotateYaw(720, 3);

	 			wait 5;
	 	}

}

spinningplatforms() //Rolls the Platforms
{
	plat1 = getEnt("spin_plat1","targetname");
	 plat2 = getEnt("spin_plat2","targetname");
	  plat3 = getEnt("spin_plat3","targetname");
	  trig = getEnt("spin_plat_trig","targetname");

	 trig SetHintString("Press [^5USE^7] to Spin the Platforms!");
	trig waittill("trigger", player );

	trig delete();

		while(1)
   {
	plat1 rotateRoll(360, 3);
		wait 1;
	plat2 rotateRoll(360, 3);
		wait 1;
	plat3 rotateRoll(360, 3);
		wait 5;
   }
}

platremove() //Removes the Red Path
{
	plat = getEnt("plat_remove","targetname");
		trig = getEnt("plat_remove_trig","targetname");

		trig setHintString("Press [^5USE^7] to Remove the Red Path!");

			trig waittill("trigger", player );

			trig delete();

		plat delete();
}

hammers()
{
	hammer = getEnt("hammer","targetname");
		trig = getEnt("hammer_trig","targetname");
			hammer_origin = getEnt("hammer_origin","targetname");

		trig SetHintString("Press [^5USE^7] to Swing the Hammers!");

		trig waittill("trigger", player );

		trig delete();

			while(1)
			{
				hammer rotateRoll(360, 1.5);

					wait 0.00125;
			}
}

platmove2()
{
	plat = getent("plat_move2","targetname");
		trig = getent("plat_move2_trig","targetname");

			trig setHintString("Press [^5USE^7] to Move the Platform!");

			trig waittill("trigger", player );

			trig delete();

				plat movey(800, 1);

					plat waittill("movedone");

				plat movey(-800, 2);
}

fastmove()
{
	plat = GetEnt("fastmove","targetname");
		trig = GetEnt("fastmove_trig","targetname");

		trig SetHintString("Press [^5USE^7] to Sweep the Players!");
			trig waittill("trigger", player );

				trig delete();

		plat MoveZ(32, .25);
			plat waittill("movedone");
		plat MoveY(-568, .75);
			plat waittill("movedone");
		plat MoveZ(-32, .5);
}

addTriggerToList( name ) //Free Run Trap Fix
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}

teleport() //Map Teleports
{
	entTransporter = getentarray( "door1_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "acti_door1_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "acti_door2_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_finish", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
		       entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_roof", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
			   entTransporter[i] thread transporter();


				entTransporter = getentarray( "secret_return1", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return2a", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return2b", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return2c", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return3a", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return3b", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return_4a", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return_4b", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return_5", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return_6a", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return_6b", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "secret_return_6c", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "door2_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "door3_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "knife_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "sniper_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "sniper_return_a", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "sniper_return_j", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "jump_trig", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();

				entTransporter = getentarray( "jump_return_a", "targetname" );
		if(isdefined(entTransporter))
			for( i = 0; i < entTransporter.size; i++ )
				entTransporter[i] thread transporter();
}

 transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );

	}
}

moving_platform() //Elevator
{
	plat = getEnt("moving_plat","targetname");
	 trig = getEnt("moving_plat_trig","targetname");

	trig waittill("trigger", player );
}


secret_rpgs()
{
	thread rpg1();
	thread rpg2();
}

rpg1()
{
	trig = getEnt("rpg_trig","targetname");

		trig SetHintString("Press [^5USE^7] to get an RPG!");

	trig waittill("trigger", player );

			for(;;)
		{
			trig waittill("trigger", who);
    			who giveWeapon("rpg_mp");
    				who giveMaxAmmo("rpg_mp");
     		 	who switchToWeapon("rpg_mp");
		}
}

rpg2()
{
trig = getEnt("rpg_trig2","targetname");

		trig SetHintString("Press [^5USE^7] to get an RPG!");

	trig waittill("trigger", player );

			for(;;)
		{
			trig waittill("trigger", who);
    			who giveWeapon("rpg_mp");
    				who giveMaxAmmo("rpg_mp");
     		 	who switchToWeapon("rpg_mp");
		}
}

secretfinish()
{
	thread normal();
	thread roof();
}

normal()
{
trig = getEnt( "secret_finish", "targetname" );

 while(true)
 {

  trig waittill ("trigger",player );

  	iPrintLnBold( "^1" + player.name + " ^7has Finished the ^1Secret ^7!");

  {

  		wait 0.25;

  }

 }

}

roof()
{
	trig = getEnt( "secret_roof", "targetname" );

 while(true)
 {

  trig waittill ("trigger",player );

  	iPrintLnBold( "^1" + player.name + " ^7has Landed on the ^1Secret Roof ^7!");

  {

  		wait 0.25;

  }

 }

}

music()
{
	// thread initmusic();
	// thread musictrig();
	// thread nitro();
}

initMusic()
{

		level.music = [];

        i = 0;
		level.music[i]["artist"] = "MrFijiWiji";
		level.music[i]["title"] = "Tomorrow";
		level.music[i]["alias"] = "music1";

		i++;
		level.music[i]["artist"] = "MrFijiWiji & CoMa";
		level.music[i]["title"] = "Apathy";
		level.music[i]["alias"] = "music2";

		i++;
		level.music[i]["artist"] = "XXXTentacion";
		level.music[i]["title"] = "Garrette's Revenge";
		level.music[i]["alias"] = "music3";

		i++;
		level.music[i]["artist"] = "MitiS";
		level.music[i]["title"] = "Hafan";
		level.music[i]["alias"] = "music4";

		i++;
		level.music[i]["artist"] = "Alan Walker";
		level.music[i]["title"] = "Sing Me to Sleep";
		level.music[i]["alias"] = "music5";

		precacheShader( "black" );
		precacheShader( "white" );
}

musicMenu()
{

    self endon( "death" );

    // self thread onDeath();
    // self thread onDisconnect();

    self.hud_music = [];
    self.selection = 0;

    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "black", 320, 160 );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
    self.hud_music[i].sort = 883;
    self.hud_music[i] setText( ">^5>^7> Music ^5Menu ^7<^5<^7<" );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText( ">^5>^7> ^7Select ^7a ^7Song ^5<^7<^5<" );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
    self.hud_music[i].sort = 885;
    self.hud_music[i] setText( "Press ^5[^7USE^5]^7: ^5Play ^7Song" );

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";

        entry = level.music[j];
        self.hud_music[i] setText( entry["artist"] + " ^2-^7 " + entry["title"] );
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );

    while( self.sessionstate == "playing" )
    {
        wait 0.1;

        if( self attackButtonPressed() )
        {
            self.hud_music[5+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[5+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if( self useButtonPressed() )
        {
            iPrintln( "^5Now playing: ^7" + level.music[self.selection]["artist"]+" - ^2" +level.music[self.selection]["title"] );

            ambientPlay( level.music[self.selection]["alias"], 3 );
            self freezeControls(0);
            level notify ( "song_picked" );
            self braxi\_rank::giveRankXp( "trap_activation" );
            break;
        }
        else if( self meleeButtonPressed() )
        {
            self freezeControls(0);
            break;
        }
    }

    self cleanUp();
}

musictrig()
{
    level.trigger = getEnt ( "musicmenu", "targetname" ); //musicmenu is the trigger to pick songs
    level.trigger setHintString( "Press ^5[^7USE^5]^7to ^5Choose ^7Music" );

   level.trigger waittill( "trigger", player );
    level.triggerr delete();
    level endon ( "song_picked" );
    player thread musicMenu();
    player freezeControls(1);
}

onDeath()
{
    self endon( "disconnect" );
    self endon( "music thread terminated" );
    self waittill( "death" );
    self cleanUp();
}

onDisconnect()
{
    self endon( "music thread terminated" );
    self waittill( "disconnect" );
    self cleanUp();
}

cleanUp()
{
    if( !isDefined( self ) )
        return;

    if( isDefined( self.hud_music ) )
    {
        for( i = 0; i < self.hud_music.size; i++ )
        {
            if( isDefined( self.hud_music[i] ) )
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

nitro()
{
	self cleanup();

	level.nitrotrig = getEnt("nitro","targetname");
		level.nitrotrig waittill("trigger", player );

			// ambientPlay("nitro");

	iPrintlnBold( player.name + "^7Turned on ^1NitroFire's ^7Secret Song!");
}

endrooms()
{
	// thread kniferoom();
	// thread sniperroom();
	// thread jumproom();
	// thread knife_move();
	// thread snipermusic();
	// thread jumpmusic();
	// thread knifemusic();
	// thread jumpweapon();
}

kniferoom()
{
	 level.knife_trig = getEnt( "knife_trig", "targetname");
    jump = getEnt( "knife_jumper", "targetname" );
    acti = getEnt( "knife_acti", "targetname" );

    	level.knife_trig SetHintString("Press [^5USE^7] to Enter the ^1Knife Room!");


     while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;

        level.sniper_trig delete();
        level.jump_trig delete();

         player.health = player.maxhealth;
         level.activ.health = level.activ.maxhealth;
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
        player FreezeControls(1);
        level.activ FreezeControls(1);
        noti = SpawnStruct();
                noti.titleText = "Knife Room";
                noti.notifyText = "^1" + level.activ.name + " ^3VS^1 " + player.name;
                noti.glowcolor = (1,0,0.9);
                noti.duration = 5;
                players = getentarray("player", "classname");
                for(i=0;i<players.size;i++)
                    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
                wait 5;
                player FreezeControls(0);
                level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }

}

sniperroom()
{
	 level.sniper_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "sniper_jumper", "targetname" );
    acti = getEnt( "sniper_acti", "targetname" );

    	level.sniper_trig SetHintString("Press [^5USE^7] to Enter the ^1Sniper Room!");


     while(1)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return;

        level.knife_trig delete();
        level.jump_trig delete();

         player.health = player.maxhealth;
         level.activ.health = level.activ.maxhealth;
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player GiveWeapon("m40a3_mp");
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" );
        level.activ GiveWeapon("m40a3_mp");
        wait 0.05;
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
        player FreezeControls(1);
        level.activ FreezeControls(1);
        noti = SpawnStruct();
                noti.titleText = "Sniper Room";
                noti.notifyText = "^1" + level.activ.name + " ^3VS^1 " + player.name;
                noti.glowcolor = (1,0,0.9);
                noti.duration = 5;
                players = getentarray("player", "classname");
                for(i=0;i<players.size;i++)
                    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
                wait 5;
                player FreezeControls(0);
                level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }

}

jumproom()
{
	 level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "jump_jumper", "targetname" );
    acti = getEnt( "jump_acti", "targetname" );

    	level.jump_trig SetHintString("Press [^5USE^7] to Enter the ^1Jump Room!");


     while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;

        level.knife_trig delete();
        level.sniper_trig delete();

         player.health = player.maxhealth;
         level.activ.health = level.activ.maxhealth;
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
        player FreezeControls(1);
        level.activ FreezeControls(1);
        noti = SpawnStruct();
                noti.titleText = "Jump Room";
                noti.notifyText = "^1" + level.activ.name + " ^3VS^1 " + player.name;
                noti.glowcolor = (1,0,0.9);
                noti.duration = 5;
                players = getentarray("player", "classname");
                for(i=0;i<players.size;i++)
                    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
                wait 5;
                player FreezeControls(0);
                level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }

}

knife_move()
{
	plat = getEnt("knife_move","targetname");
		trig = getEnt("knife_trig","targetname");

			trig waittill("trigger", player );

		while(1)
		{
			plat rotateYaw(360, 1.25);

				wait .005;
		}
}

snipermusic()
{
    self cleanup();
    level.snipermusictrig = getEnt("sniper_trig","targetname");
    level.snipermusictrig waittill("trigger", player );
    // ambientPlay("sniper_music");
}

jumpmusic()
{
    self cleanup();
    level.jumpmusictrig = getEnt("jump_trig","targetname");
    level.jumpmusictrig waittill("trigger", player );
    // ambientPlay("jump_music");
}

knifemusic()
{
    self cleanup();
    level.knifemusictrig = getEnt("knife_trig","targetname");
    level.knifemusictrig waittill("trigger", player );
    // ambientPlay("knife_music");
}

jumpweapon()
{
	    trig = getEnt("jumpweapon_trig","targetname");

	    	trig setHintString("Press [^5USE^7] to get a Sniper!");

    for(;;)
    {
        trig waittill("trigger", who);
        who giveWeapon("m40a3_mp");
        who giveweapon("remington700_mp");
        who giveMaxAmmo("m40a3_mp");
        who givemaxammo("remington700_mp");
        who switchToWeapon("m40a3_mp");
    }

}