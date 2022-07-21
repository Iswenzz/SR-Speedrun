///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////																									///////
///////																									///////
///////		//			//	////////////	//////////	  /////////		//////////	/////////////		///////
///////		//			//	//				//					//		//		//	/		   //		///////
///////		//			//	//				//			 	   // 		//		//	////////////		///////
///////		//			//	////////////	//////////		  //		//		//	//	  //			///////
///////		//			//	//				//				 //			//		//	//	   //			///////
///////		//			//	//				//			    //			//		//	//		//			///////
///////		/////////	//	//				///////////	   /////////	//////////	//		 //			///////
///////																									///////
///////																									///////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Map by Lifezor
//mp_dr_420
//idea by: b1tchzR
//Started: 30.12.2016
//Finished: ???

///////////TO-DO LIST\\\\\\\\\\\
//-Make secret finish give xp. [DONE]
//-Find nicer texture to surround the weed texture. [DONE]
//-Fix the redness.
//-Re-design map..[DONE]
//-More traps..?
//-Third HARD secret.
//-More rooms..
//-Fix the respawn on secrets.
//-Better Textures
//-Make the dizzy script.

//fps for secret bounces: 1st: 1-3 2nd: 2-3 3rd: 1 4th(Strafe):

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
////////////////			*START OF MAIN*			\\\\\\\\\\\\\\\\\\
	
	//maps\mp\_load::main();
	setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("bg_fallDamageMaxHeight","9999");
	setdvar("bg_fallDamageMinHeight","9998");
	
		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Hard Secret;Easy Secret;");
	thread sr\api\_speedrun::createTeleporter((821, 1528, 76), 60, 80, (14935, 10821, 1756), 179, "freeze", "red", "secret_0");
	
////////////////		caches			\\\\\\\\\\\\\\\\\\\\\\	

	preCacheItem("rpg_mp");
	preCacheItem("deserteagle_mp");
	preCacheItem("deserteaglegold_mp");
	preCacheItem("knife_mp");
	preCacheItem("winchester1200_mp");
/////////////// 		FX 				\\\\\\\\\\\\\\\\\\\
	
	level.weedsmoke = loadFX("customfx2/bongsmoke2");
	level.bobmarleysmoke = loadFX("smoke/icbm_smoke_add");
	
/////////////// 		Char 			\\\\\\\\\\\\\\\\\\\\	
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
///////////////Teles, doors, random threads\\\\\\\\\\\\\\\\\\\\
	
//	thread credits();
//	thread mapinfo();
	thread secret();
	thread area1player();
//	thread area1acti();
	thread secrethard();
	thread giverpgsh();
	thread secrethardend();
	thread hardsecrettps();
	thread easysecretend();
	thread secreteasyrespawn();
//	thread addTestClients();
//	thread bouncetps();
//	thread bouncewep();
	thread startdoor();
//	thread weedsmoking();
//	thread songtrig();
//	thread songlist();
//	thread cleanup();
//	thread givedesertspawn();
//	thread mapshortcut();
//	thread shortcutking();
	
///////////////				Traps			\\\\\\\\\\\\\\\\\\\\

//	thread trap1();
//	thread trap2();
//	thread trap3();
//	thread trap4();
//	thread trap5();
//	thread trap6();
	
///////////////				Rooms			\\\\\\\\\\\\\\\\\\\\\

//	thread endroom();
//	thread sniper();
//	thread knife();
//	thread bounce();
//	thread old();

///////////////			Triggerlist			\\\\\\\\\\\\\\\\\\\\\\

	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
	addTriggerToList( "trap6_trig" );

///////////////			   Fx List			\\\\\\\\\\\\\\\\\\\\\\\

	playLoopedFX(level.weedsmoke, 0.05, (3600,512,-184));
	playLoopedFX(level.weedsmoke, 0.05, (4864,512,-160));
	playLoopedFX(level.weedsmoke, 0.05, (7632,512,144));
	playLoopedFX(level.weedsmoke, 0.05, (-4816,472,-160));
	playLoopedFX(level.weedsmoke, 0.05, (14248,232,144));
	playLoopedFX(level.weedsmoke, 0.05, (11184,520,144));
	playLoopedFX(level.bobmarleysmoke, 0.05, (3008,1536,400));
	playLoopedFX(level.bobmarleysmoke, 0.05, (3008,512,400));
	playLoopedFX(level.bobmarleysmoke, 0.05, (3008,-512,400));
	
//////////////			*END OF MAIN*		\\\\\\\\\\\\\\\\\\\\\\\\

}

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
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

credits()
{
     for(;;)
	 {
	 iPrintLn ("^3>>^1Map By ^2Lifezor");
	 wait 30;
	 iPrintLn ("^3>>^1Idea by: ^2b1tchzR, developed by Lifezor");
	 wait 30;
	 iPrintLn ("^3>>^1Youtube ^2http://www.youtube.com/IH8LifesSucks");
	 wait 30;
	 iPrintLn ("^3>>^1Thanks for playing ^2mp_dr_420");
	 wait 30;
	 }
}

secret()
{
    trig = getEnt("secrettrig", "targetname");
    target = getEnt("secretorigin", "targetname");
       
    while(1)
    {
        trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_1");
                   
        {
            player setOrigin( target.origin );
            player setPlayerAngles( target.angles );
        }
    }
}

area1player()
{
    trig = getEnt("teleport1", "targetname");
    target = getEnt("teleport1_origin", "targetname");
       
    while(1)
    {
        trig waittill("trigger", player);
                   
        {
            player setOrigin( target.origin );
            player setPlayerAngles( target.angles );
        }
    }
}

area1acti()
{
    trig = getEnt("actiteleport1", "targetname");
    target = getEnt("actiteleport1_origin", "targetname");
       
    while(1)
    {
        trig waittill("trigger", player);
                   
        {
            player setOrigin( target.origin );
            player setPlayerAngles( target.angles );
        }
    }
}

endroom()
{
	level.games_trig = getEnt( "roomselect", "targetname");
	games = getEnt( "roomselect_origin", "targetname" );

	while(1)
	{
		level.games_trig waittill( "trigger", player );
		if( !isDefined( level.games_trig ) )
		return;

		player SetPlayerAngles( games.angles );
		player setOrigin( games.origin );
		player TakeAllWeapons();
		player antiglitch();


		while( isAlive( player ) && isDefined( player ) )
		if( isDefined( level.activ ) && isAlive( level.activ ) )
		wait 1;
	}
}

antiglitch()
{ 
	self common_scripts\utility::waittill_any("death","disconnect");
	iPrintlnBold("^2"+self.name+" ^7Dead."); 
	iPrintlnBold("Endroom is now open."); 
}

secrethard()
{
	spawn = getEnt("hardsecret_origin","targetname");
	trig1 = getEnt("secrethit1","targetname");
	trig2 = getEnt("secrethit2","targetname");
	trig3 = getEnt("secrethit3", "targetname");
	{
	trig1 waittill("trigger", player);
	trig2 waittill("trigger", player);
	}
	while(1)
	{
	trig3 waittill("trigger",player);
		{
		player iPrintLnBold ("^4Welcome to ^6Hard ^5Secret.");
		player setplayerangles(spawn.angles);
		player setorigin(spawn.origin);
		}
	}

	
}

sniper() //WINGZOOOOR :D:D:D:D:D:D:D:D:d:DDDD:D:D:D:D:D:D
{
     level.sniper_trig = getEnt( "sniper", "targetname");
     sjump = getEnt( "playersniper", "targetname" );
     sacti = getEnt( "actisniper", "targetname" );
	 
	 if( !isDefined( level.sniper_trig ) )
         return;
		 
	 while(1)
	 {
		level.sniper_trig waittill( "trigger", player );
		
		if(!isdefined(level.firstenter))
			level.firstenter=false;
			
		if(level.firstenter==false)
		{
		 level.knife_trig delete();
		 level.bounce_trig delete();
		 level.old_trig delete();
		 level.firstenter=true;
		}
			level.activ freezeControls(1);
			player FreezeControls(1);
			
			player SetPlayerAngles( sjump.angles );
			player setOrigin( sjump.origin );
			level.activ setPlayerangles( sacti.angles );
			level.activ setOrigin( sacti.origin );
			level.activ TakeAllWeapons();
			player TakeAllWeapons();
			
			level.activ giveweapon( "m40a3_mp");
			player giveweapon( "m40a3_mp");
			player switchToWeapon( "m40a3_mp" );
			level.activ SwitchToWeapon( "m40a3_mp" );
			player giveMaxAmmo( "m40a3_mp" );
			level.activ giveMaxAmmo( "m40a3_mp" );
			
			level.activ giveweapon( "remington700_mp");
			player giveweapon( "remington700_mp");
			player switchToWeapon( "remington700_mp" );
			level.activ SwitchToWeapon( "remington700_mp" );
			player giveMaxAmmo( "remington700_mp" );
			level.activ giveMaxAmmo( "remington700_mp" );
			
			level.activ freezeControls(1);
			player FreezeControls(1);
			
					noti = SpawnStruct();
					noti.titleText = (player.name + "^3Entered^5Sniper ^2Fight!");
					noti.notifyText = level.activ.name + " ^1VS^5 " + player.name;
					noti.duration = 6;
					noti.glowcolor = (0, 0, 1.0);
					
					players = getEntArray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					
			wait 2;
			
			level.activ FreezeControls(0);
			player FreezeControls(0);
			
			wait 0.1;
                     
			while(isAlive(player))
				wait 1;

		}
}

knife() //WINGZOOOOR :D:D:D:D:D:D:D:D:D:D:D:D:D:D:DDDD:D:
{
     level.knife_trig = getEnt( "knife", "targetname");
     kjump = getEnt( "jumpk", "targetname" );
     kacti = getEnt( "actik", "targetname" );
	 
	if( !isDefined( level.knife_trig ) )
         return;
		 
	 while(1)
	 {
		level.knife_trig waittill( "trigger", player );
		
		if(!isdefined(level.firstenter))
			level.firstenter=false;
			
		if(level.firstenter==false)
		{
		 level.sniper_trig delete();
		 level.bounce_trig delete();
		 level.old_trig delete();
		 level.firstenter=true;
		}
			level.activ freezeControls(1);
			player FreezeControls(1);
			
			player SetPlayerAngles( kjump.angles );
			player setOrigin( kjump.origin );
			level.activ setPlayerangles( kacti.angles );
			level.activ setOrigin( kacti.origin );
			level.activ TakeAllWeapons();
			player TakeAllWeapons();
			
			level.activ giveweapon( "knife_mp");
			player giveweapon( "knife_mp");
			player switchToWeapon( "knife_mp" );
			level.activ SwitchToWeapon( "knife_mp" );
			
			level.activ freezeControls(1);
			player FreezeControls(1);
			
					noti = SpawnStruct();
					noti.titleText = (player.name + "^3Entered ^5Knife ^2Fight.");
					noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
					noti.duration = 6;
					noti.glowcolor = (0, 0, 1.0);
					
					players = getEntArray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					
			wait 2;
			
			level.activ FreezeControls(0);
			player FreezeControls(0);
			
			wait 0.1;
                     
			while(isAlive(player))
				wait 1;

		}
}

giverpgsh()
{
	trig = getEnt("giverpg", "targetname");
	
	while(1)
	{	
		trig waittill("trigger", player);
	
		{
			player giveweapon( "rpg_mp");
			player giveMaxAmmo( "rpg_mp");
			player switchToWeapon( "rpg_mp");
		}
	}
}

secrethardend()
{
    trig = getEnt("secrethardend", "targetname");
    target = getEnt("secrethardend_origin", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );
				player thread sr\api\_speedrun::finishWay("secret_0");
	
            }
    }
}

hardsecrettps()
{
		thread tp1();
		thread tp2();
		thread tp3();
		thread tp4();
		thread tp5();
		thread tp6();
}

tp1()
{
    trig = getEnt("secrethardtp1", "targetname");
    target = getEnt("secrethardtp1_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

tp2()
{
    trig = getEnt("secrethardtp2", "targetname");
    target = getEnt("secrethardtp2_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

tp3()
{
    trig = getEnt("secrethardtp3", "targetname");
    target = getEnt("secrethardtp3_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

tp4()
{
    trig = getEnt("secrethardtp4", "targetname");
    target = getEnt("secrethardtp4_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

tp5()
{
    trig = getEnt("secrethardtp5", "targetname");
    target = getEnt("secrethardtp5_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

tp6()
{
    trig = getEnt("secrethardtp6", "targetname");
    target = getEnt("secrethardtp6_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

easysecretend()
{
    trig = getEnt("secreteasytp", "targetname");
    target = getEnt("secreteasyback_origin", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_1");
                   
            {
				iPrintLnBold (player.name + "Finished ^5Easy ^7Secret.");
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );
            }
    }
}

secreteasyrespawn()
{
    trig = getEnt("secreteasyrespawn", "targetname");
    target = getEnt("secreteasyrespawn_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

trap1()
{
	trig = getent("trap1_trig", "targetname");
	brush = getent("notsolid1", "targetname");
	brush2 = getent("notsolid2", "targetname");
	trig waittill("trigger", player);
	trig delete();
	x = randomInt(2);
		if(x == 0)
			brush notsolid();
		else if(x == 1)
			brush2 notsolid();
		else
		{
		brush notsolid();
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

    bounce()
    {
         level.bounce_trig = getEnt( "bounceroom_trig", "targetname");
         bjumper = getEnt( "jumpb", "targetname" );
         bacti = getEnt( "actib", "targetname" );
             
            if( !isDefined( level.bounce_trig ) )
             return;
                     
             while(1)
             {
                    level.bounce_trig waittill( "trigger", player );
                   
                            if(!isdefined(level.firstenter))
                            level.firstenter=false;
                           
                    if(level.firstenter==false)
                    {
                     level.sniper_trig delete();
                     level.knife_trig delete();
					 level.old_trig delete();
                     level.firstenter=true;
                    }
                            level.activ freezeControls(1);
                            player FreezeControls(1);
                           
                            player SetPlayerAngles( bjumper.angles );
                            player setOrigin( bjumper.origin );
                            level.activ setPlayerangles( bacti.angles );
                            level.activ setOrigin( bacti.origin );
							
							                    player takeallweapons();
                    player GiveWeapon( "knife_mp" );
            player SwitchtoWeapon( "knife_mp" );
            level.activ takeallweapons();
                    level.activ GiveWeapon( "knife_mp" );
            level.activ SwitchtoWeapon( "knife_mp" );
                           
                           
                            level.activ freezeControls(1);
                            player FreezeControls(1);
                           
                                            noti = SpawnStruct();
                                            noti.titleText = (player.name + "Has Chosen Bounce Room!");
                                            noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
                                            noti.duration = 6;
                                            noti.glowcolor = (0, 0, 1.0);
                                           
                                            players = getEntArray("player", "classname");
                                            for(i=0;i<players.size;i++)
                                                    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
                                           
                            wait 2;
                           
                            level.activ FreezeControls(0);
                            player FreezeControls(0);
                           
                            wait 0.1;
                         
                            while(isAlive(player))
                                    wait 1;
     
                    }
    }
	
bouncetps()
{
	thread bounceactitp();
	thread bounceplayertp();
}

bounceactitp()
{
	trig = getEnt("bounceactiside", "targetname");
	target = getEnt("bounceactiside_orig", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
		}
	}
}

bounceplayertp()
{
	trig = getEnt("bounceplayerside", "targetname");
	target = getEnt("bounceplayerside_orig", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
		}
	}
}

bouncewep()
{
	trig = getEnt("givewep", "targetname");
	
	while(1)
	{	
		trig waittill("trigger", player);
	
		{
			player takeallweapons();
			player giveweapon( "m40a3_mp");
			player giveMaxAmmo( "m40a3_mp");
			player switchToWeapon( "m40a3_mp");
			player giveweapon( "deserteaglegold_mp");
			player giveMaxAmmo( "deserteaglegold_mp");
		}
	}
}

startdoor()
{
	startdoor = getent("startdoor","targetname");
	level waittill("round_started");
	startdoor delete();
}

trap2()
{
	trig = getent("trap2_trig", "targetname");
	trig waittill("trigger", player);
	trig delete();
	thread trap2a();
	thread trap2b();
}

trap2a()
{
	brush = getent("updown1", "targetname");
	brush movez (100,2);
	brush waittill("movedone");
		for(;;)
		{
		brush movez (-200,0.6);
		brush waittill("movedone");
		brush movez (200,0.6);
		brush waittill("movedone");
		}
}

trap2b()
{
	brush2 = getent("updown2", "targetname");
	brush2 movez (-100,2);
	brush2 waittill("movedone");
		for(;;)
		{
		brush2 movez (200,0.6);
		brush2 waittill("movedone");
		brush2 movez (-200,0.6);
		brush2 waittill("movedone");
		}
}

trap3()
{     
	 trig = getent("trap3_trig", "targetname");
	 brush = getent("flip1", "targetname");
	 brush2 = getent("flip2", "targetname");
	 brush3 = getent("flip3", "targetname");
	 trig waittill("trigger");
	 trig delete();
	 for (;;)
		{
		brush rotatepitch(360, 2.5);
		wait 4;
		brush2 rotatepitch(360, 2.5);
		wait 4;
		brush3 rotatepitch(360, 2.5);
		wait 4;
		}
	 
}

trap4()
{     
	 trig = getent("trap4_trig", "targetname");
	 brush = getent("flip4", "targetname");
	 brush2 = getent("flip5", "targetname");
	 brush3 = getent("flip6", "targetname");
	 brush4 = getent("flip7", "targetname");
	 brush5 = getent("flip8", "targetname");
	 brush6 = getent("flip9", "targetname");
	 trig waittill("trigger");
	 trig delete();
	 for (;;)
		{
		brush rotatepitch(360, 3);
		wait 3;
		brush2 rotatepitch(360, 3);
		wait 3;
		brush3 rotatepitch(360, 3);
		wait 3;
		brush4 rotatepitch(360, 3);
		wait 3;
		brush5 rotatepitch(360, 3);
		wait 3;
		brush6 rotatepitch(360, 3);
		wait 3;
		}
	 
}

trap5()
{
	trig = getent("trap5_trig", "targetname");
	trig waittill("trigger", player);
	trig delete();
	thread trap5a();
	thread trap5b();
	thread trap5c();
	thread trap5d();
	thread trap5f();
	thread trap5g();
	thread trap5h();
	thread trap5i();
	thread trap5j();
}

trap5a()
{
	brush = getent("updown3", "targetname");
	brush movez (50,2);
	brush waittill("movedone");
		for(;;)
		{
		brush movez (-100,1);
		brush waittill("movedone");
		brush movez (100,1);
		brush waittill("movedone");
		}
}

trap5b()
{
	brush2 = getent("updown4", "targetname");
	brush2 movez (-50,2);
	brush2 waittill("movedone");
		for(;;)
		{
		brush2 movez (100,1);
		brush2 waittill("movedone");
		brush2 movez (-100,1);
		brush2 waittill("movedone");
		}
}

trap5c()
{
	brush3 = getent("updown5", "targetname");
	brush3 movez (50,2);
	brush3 waittill("movedone");
		for(;;)
		{
		brush3 movez (-100,1);
		brush3 waittill("movedone");
		brush3 movez (100,1);
		brush3 waittill("movedone");
		}
}

trap5d()
{
	brush4 = getent("updown6", "targetname");
	brush4 movez (-50,2);
	brush4 waittill("movedone");
		for(;;)
		{
		brush4 movez (100,1);
		brush4 waittill("movedone");
		brush4 movez (-100,1);
		brush4 waittill("movedone");
		}
}

trap5f()
{
	brush6 = getent("updown7", "targetname");
	brush6 movez (50,2);
	brush6 waittill("movedone");
		for(;;)
		{
		brush6 movez (-100,1);
		brush6 waittill("movedone");
		brush6 movez (100,1);
		brush6 waittill("movedone");
		}
}

trap5g()
{
	brush7 = getent("updown8", "targetname");
	brush7 movez (-50,2);
	brush7 waittill("movedone");
		for(;;)
		{
		brush7 movez (100,1);
		brush7 waittill("movedone");
		brush7 movez (-100,1);
		brush7 waittill("movedone");
		}
}

trap5h()
{
	brush8 = getent("updown9", "targetname");
	brush8 movez (50,2);
	brush8 waittill("movedone");
		for(;;)
		{
		brush8 movez (-100,1);
		brush8 waittill("movedone");
		brush8 movez (100,1);
		brush8 waittill("movedone");
		}
}

trap5i()
{
	brush9 = getent("updown10", "targetname");
	brush9 movez (-50,2);
	brush9 waittill("movedone");
		for(;;)
		{
		brush9 movez (100,1);
		brush9 waittill("movedone");
		brush9 movez (-100,1);
		brush9 waittill("movedone");
		}
}

trap5j()
{
	brush10 = getent("solid1", "targetname");
	brush11 = getent("solid2", "targetname");
	brush12 = getent("solid3", "targetname");
	brush13 = getent("solid4", "targetname");
	x = randomInt(2);
		if(x == 0)
			brush10 notsolid();
		else if(x == 1)
			brush11 notsolid();
		else if (x == 2)
			brush12 notsolid();
		else if (x == 3)
			brush13 notsolid();
		else
		{
		brush10 notsolid();
		brush13 notsolid();
		}
}

old()
{
     level.old_trig = getEnt( "old", "targetname");
     ojump = getEnt( "oldjump", "targetname" );
     oacti = getEnt( "oldacti", "targetname" );
	 
	if( !isDefined( level.old_trig ) )
         return;
		 
	 while(1)
	 {
		level.old_trig waittill( "trigger", player );
		
		{
		 level.sniper_trig delete();
		 level.knife_trig delete();
		 level.bounce_trig delete();
		}
			level.activ freezeControls(0);
			player FreezeControls(0);
			
			player SetPlayerAngles( ojump.angles );
			player setOrigin( ojump.origin );
			level.activ setPlayerangles( oacti.angles );
			level.activ setOrigin( oacti.origin );
			level.activ TakeAllWeapons();
			player TakeAllWeapons();
			
			level.activ giveweapon( "deserteagle_mp");
			player giveweapon( "deserteagle_mp");
			player switchToWeapon( "deserteagle_mp" );
			level.activ SwitchToWeapon( "deserteagle_mp" );
			
			level.activ freezeControls(0);
			player FreezeControls(0);
			
					noti = SpawnStruct();
					noti.titleText = (player.name + "^3Has ^6Chosen ^5Old!");
					noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
					noti.duration = 6;
					noti.glowcolor = (0, 0, 1.0);
					
					players = getEntArray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					
			wait 2;
			
			level.activ FreezeControls(0);
			player FreezeControls(0);
			
			wait 0.1;
                     
			while(isAlive(player))
				wait 1;

		}
}

weedsmoking()
{
trig = getent ("bobmarley", "targetname");
trig waittill ("trigger", player);
iprintlnbold("Smoked some weed..");
wait 10;
darkhole=(-528,-1536,-5104);
range=600;

while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, darkhole ) <= range && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread darkhole_sux(darkhole);
		}
		wait 0.05;
		//playFx( level.glow , darkhole );
	}
}

darkhole_sux(darkhole)
{
self.iscaught=true;
		iprintlnbold("Decided to smoke too much weed..");
		self.mover = spawn( "script_origin", self.origin );
		self.mover.angles = self.angles;
		self linkto (self.mover);
		self.islinkedmover = true;
		self.mover moveto( darkhole, 7 );
		self.mover waittill("movedone");
		wait 30;
		self suicide();
}

trap6()
{
	trig = getent("trap6_trig", "targetname");
	brush = getent("rotating1", "targetname");
	brush2 = getent("rotating2", "targetname");
	trig waittill("trigger", player);
	trig delete();
		for(;;)
		{
		brush rotateyaw(1080, 2);
		wait 5;
		brush2 rotateyaw(-1080, 2);
		wait 5;
		}
}

mapinfo()
{
	if( isDefined( self.logoText ) )
		self.logoText destroy();

	self.logoText = newHudElem();
	self.logoText.y = 10;
	self.logoText.alignX = "center";
	self.logoText.alignY = "middle";
	self.logoText.horzAlign = "center_safearea";

	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.6;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5->^4Map Made By Lifezor^5<-");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5->^4Steam:/id/LfezR^5<-");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}

songtrig()
{
	trigger = getEnt ( "songtrig", "targetname" );
	trigger waittill( "trigger", player );
	trigger delete();
	level endon ( "song_picked" );
	player thread songmenu();
	player freezeControls(1);
}

songmenu() //thanks to someone..
{
	
	self endon( "death" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
	self.hud_music[i].sort = 883;
	self.hud_music[i] setText( "Music Menu" );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText( "Select a Song" );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i] setText( "Press [USE] To Play The Song" );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText( "^8Lifezor" );
 
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
			iPrintln( "^5Now playing: " + level.music[self.selection]["artist"]+" - " +level.music[self.selection]["title"] );
 
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

songlist()
{
		level.music = [];
 
        i = 0;
		level.music[i]["artist"] = "Afroman";
		level.music[i]["title"] = "Because I Got High";
		level.music[i]["alias"] = "song1";
		
		i++;
		level.music[i]["artist"] = "Alfons";
		level.music[i]["title"] = "Ganjaman";
		level.music[i]["alias"] = "song2";
		
		i++;
		level.music[i]["artist"] = "Snoop Dogg";
		level.music[i]["title"] = "Smoke Weed Everyday (Remix)";
		level.music[i]["alias"] = "song3";
		
		i++;
		level.music[i]["artist"] = "Bob Marley";
		level.music[i]["title"] = "Three Little Birds";
		level.music[i]["alias"] = "song4";
		
		i++;
		level.music[i]["artist"] = "Bob Marley";
		level.music[i]["title"] = "Don't Worry, Be Happy";
		level.music[i]["alias"] = "song5";
		

		precacheShader( "black" );
		precacheShader( "white" );
}

onDeath() //Music Term.
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}

onDisconnect() //Music Term.
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}

givedesertspawn()
{
	trig = getEnt("givedeaglespawn", "targetname");
	
	while(1)
	{	
		trig waittill("trigger", player);
	
		{
			player takeallweapons();
			player giveweapon( "deserteaglegold_mp");
			player giveMaxAmmo( "deserteaglegold_mp");
			player switchToWeapon( "deserteaglegold_mp");
			player iprintlnbold ( "You got a deagle..");
		}
	}
}
	
mapshortcut()
{
	trig = getent("superfast" ,"targetname");
	trig waittill("trigger", player);
	iPrintLnBold (player.name + "Is quick");
	player braxi\_rank::giveRankXP("", 5);
	trig delete();
}

shortcutking()
{
	trig = getent("firstbounceking" ,"targetname");
	trig2 = getent ("firstbouncekingland", "targetname");
	trig waittill ("trigger" , player);
	trig delete();
	while(1)
	{
	trig2 waittill ("trigger", player);
	iPrintLnBold (player . name + "Is good.");
	player braxi\_rank::giveRankXP("", 5);
	trig2 delete();
	}
}
