main()
{
	//maps\mp\_load::main();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	// spawn auto placement
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawnOrigin(auto_spawn[int(auto_spawn.size / 2)].origin,
			90);
	
thread sr\api\_speedrun::createTeleporter((-107.477, 243.677, -1487.88), 50, 25, (-7256, 9127, -2276), 90, "freeze", "cyan", "secret_0");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	    setdvar( "r_specularcolorscale", "1" );
        setdvar("r_glowbloomintensity0",".25");
        setdvar("r_glowbloomintensity1",".25");
        setdvar("r_glowskybleedintensity0",".3");
		
/////////////		Teles etc..			\\\\\\\\\\\\\\\\\\

	// thread credits();
	// thread mapper();
	//thread actitele1();
	thread startdoor();
	thread actidoor();
	thread secretend();
	// thread music();
	// thread addTestClients();
	
////////////			Traps			\\\\\\\\\\\\\\\\\\\

	thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	
////////////			Rooms			\\\\\\\\\\\\\\\\\\\\

	// thread sniper();
	// thread knife();
	// thread old();
	
////////////		Triggerlist			\\\\\\\\\\\\\\\\\\\\

	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
	addTriggerToList( "trap6_trig" );


}


addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


credits()
{
     for(;;)
	 {
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Map By ^2Lifezor"); */
	 wait 12;
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Fixed version."); */
	 wait 12;
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Youtube ^2http://www.youtube.com/IH8LifesSucks"); */
	 wait 12;
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Song Name: ^2Adam Lambert - Runnin "); */
	 wait 12;
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Thanks for playing ^2mp_deathrun_boss"); */
	 wait 12;
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Steam: ^2Lifezor"); */
	 wait 12;
	 /* [AUTO DELETE] iPrintLn ("^3>>^1Thanks to ^2Sheep Wizard ^1For secret!"); */
	 wait 18;
	 }
}


mapper()
{
     wait 6;
     hud_clock = NewHudElem();
     hud_clock.alignX = "center";
     hud_clock.alignY = "bottom";
     hud_clock.horzalign = "center";
     hud_clock.vertalign = "bottom";
     hud_clock.alpha = 1;
     hud_clock.x = 0;
     hud_clock.y = 0;
     hud_clock.font = "objective";
     hud_clock.fontscale = 2;
     hud_clock.glowalpha = 5;
     hud_clock.glowcolor = (0.0,0.8,0.0);
     hud_clock.label = &"Map by Lifezor";
     hud_clock SetPulseFX( 40, 5400, 200 );
     wait 5;
}


actitele1()
{
    trig = getEnt("acti1tele_trig", "targetname");
    target = getEnt("acti1tele_origin", "targetname");
       
    while(1)
    {
        trig waittill("trigger", player);
                   
        {
            player setOrigin( target.origin );
            player setPlayerAngles( target.angles );
        }
    }
}


startdoor()
{
door=getent("spawndoor","targetname");
  
wait 0.1;
door delete();
}


actidoor()
{
door=getent("actidoor","targetname");

wait 0.1;
door delete();
}

trap1()
{
brush = getent("solid1", "targetname");

wait 0.1;
brush moveY(-2820,0.1);
wait 0.2;
brush moveZ(-97,0.1);
wait 0.6;
brush moveX(-30,0.1);

}


trap2()
{
	level endon("trigger");
	trig = getent("trap2_trig", "targetname");
	brush = getent("spinning1", "targetname");
	brush2 = getent("spinning2", "targetname");
	trig waittill("trigger", player);
	trig delete();
		for(;;)
		{
		brush rotatepitch(360, 3.5);
		wait 8;
		brush2 rotatepitch(-360, 3.5);
		wait 8;
		}
}


trap3()
{
	level endon("trigger");
	trig = getent("trap3_trig", "targetname");
	brush = getent("spinbounce1", "targetname");
	brush2 = getent("spinbounce2", "targetname");
	trig waittill("trigger", player);
	trig delete();
		for(;;)
		{
		brush rotateyaw(360, 3.5);
		wait 3;
		brush2 rotateyaw(-360, 3.5);
		wait 3;
		}
}


trap4()
{
	level endon("trigger");
	trig = getent("trap4_trig", "targetname");
	brush = getent("solid1", "targetname");
	brush2 = getent("solid2", "targetname");
	brush3 = getent("solid3", "targetname");
	brush4 = getent("solid4", "targetname");
	trig waittill("trigger", player);
	trig delete();
	x = randomInt(4);
		if(x == 0)
			brush notsolid();
		else if(x == 1)
			brush2 notsolid();
		else if(x == 2)
			brush3 notsolid();
		else if(x == 3)
			brush4 notsolid();
		{
		brush2 notsolid();
		brush4 notsolid();
		}
}


trap5()
{
	level endon("trigger");
	trig = getent("trap5_trig", "targetname");
	brush = getent("spinbrush1", "targetname");
	brush2 = getent("spinbrush2", "targetname");
	brush3 = getent("spinbrush3", "targetname");
	trig waittill("trigger", player);
	trig delete();
		for(;;)
		{
		brush rotateyaw(720, 1.5);
		wait 4;
		brush2 rotatepitch(-720, 1.5);
		wait 4;
		brush3 rotateroll(720, 1.5);
		wait 4;
		}
}

secretend()
{
	trig = getEnt("backtomap", "targetname");
	target = getEnt("backtomap_origin", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);
		 
	player thread sr\api\_speedrun::finishWay("secret_0");
	player setOrigin( target.origin );
	player setPlayerAngles( target.angles );
					
	}
}


sniper() //WINGZOOOOR :D:D:D:D:D:D:D:D:d:DDDD:D:D:D:D:D:D
{
     level.sniper_trig = getEnt( "sniper", "targetname");
     sjump = getEnt( "sniperplayer", "targetname" );
     sacti = getEnt( "sniperacti", "targetname" );
	 
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
		 level.old_trig delete();
		 level.firstenter=true;
		}
			level.activ freezeControls(1);
			player FreezeControls(1);
			
			player SetPlayerAngles( sjump.angles );
			player setOrigin( sjump.origin );
			level.activ setPlayerangles( sacti.angles );
			level.activ setOrigin( sacti.origin );
			/* [AUTO DELETE] level.activ TakeAllWeapons(); */
			/* [AUTO DELETE] player TakeAllWeapons(); */
			
			/* [AUTO DELETE] level.activ giveweapon( "m40a3_mp"); */
			/* [AUTO DELETE] player giveweapon( "m40a3_mp"); */
			/* [AUTO DELETE] player switchToWeapon( "m40a3_mp" ); */
			/* [AUTO DELETE] level.activ SwitchToWeapon( "m40a3_mp" ); */
			/* [AUTO DELETE] player giveMaxAmmo( "m40a3_mp" ); */
			/* [AUTO DELETE] level.activ giveMaxAmmo( "m40a3_mp" ); */
			
			/* [AUTO DELETE] level.activ giveweapon( "remington700_mp"); */
			/* [AUTO DELETE] player giveweapon( "remington700_mp"); */
			/* [AUTO DELETE] player switchToWeapon( "remington700_mp" ); */
			/* [AUTO DELETE] level.activ SwitchToWeapon( "remington700_mp" ); */
			/* [AUTO DELETE] player giveMaxAmmo( "remington700_mp" ); */
			/* [AUTO DELETE] level.activ giveMaxAmmo( "remington700_mp" ); */
			
			level.activ freezeControls(1);
			player FreezeControls(1);
			
					noti = SpawnStruct();
					noti.titleText = (player.name+"^3Has ^6Chosen ^5Sniper ^2Fight!");
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
     kjump = getEnt( "knifeplayer", "targetname" );
     kacti = getEnt( "knifeacti", "targetname" );
	 
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
		 level.old_trig delete();
		 level.firstenter=true;
		}
			level.activ freezeControls(1);
			player FreezeControls(1);
			
			player SetPlayerAngles( kjump.angles );
			player setOrigin( kjump.origin );
			level.activ setPlayerangles( kacti.angles );
			level.activ setOrigin( kacti.origin );
			/* [AUTO DELETE] level.activ TakeAllWeapons(); */
			/* [AUTO DELETE] player TakeAllWeapons(); */
			
			/* [AUTO DELETE] level.activ giveweapon( "knife_mp"); */
			/* [AUTO DELETE] player giveweapon( "knife_mp"); */
			/* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
			/* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
			
			level.activ freezeControls(1);
			player FreezeControls(1);
			
					noti = SpawnStruct();
					noti.titleText = (player.name+"^3Has ^6Chosen ^5Knife ^2Fight!");
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


old()
{
     level.old_trig = getEnt( "old", "targetname");
     ojump = getEnt( "playerold", "targetname" );
     oacti = getEnt( "actiold", "targetname" );
	 
	if( !isDefined( level.old_trig ) )
         return;
		 
	 while(1)
	 {
		level.old_trig waittill( "trigger", player );
		
		{
		 level.sniper_trig delete();
		 level.knife_trig delete();
		}
			level.activ freezeControls(0);
			player FreezeControls(0);
			
			player SetPlayerAngles( ojump.angles );
			player setOrigin( ojump.origin );
			level.activ setPlayerangles( oacti.angles );
			level.activ setOrigin( oacti.origin );
			/* [AUTO DELETE] level.activ TakeAllWeapons(); */
			/* [AUTO DELETE] player TakeAllWeapons(); */
			
			/* [AUTO DELETE] level.activ giveweapon( "deserteaglegold_mp"); */
			/* [AUTO DELETE] player giveweapon( "deserteaglegold_mp"); */
			/* [AUTO DELETE] player switchToWeapon( "deserteaglegold_mp" ); */
			/* [AUTO DELETE] level.activ SwitchToWeapon( "deserteaglegold_mp" ); */
			
			level.activ freezeControls(0);
			player FreezeControls(0);
			
					noti = SpawnStruct();
					noti.titleText = (player.name+"^3Has ^6Chosen ^5Old!");
					noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
					noti.duration = 6;
					noti.glowcolor = (0, 0, 1.0);
					
					players = getEntArray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					
			/* [AUTO DELETE] wait 2; */
			
			level.activ FreezeControls(0);
			player FreezeControls(0);
			
			/* [AUTO DELETE] wait 0.1; */

		}
}


trap6()
{
	level endon("trigger");
	trig = getent("trap6_trig", "targetname");
	trig waittill("trigger", player);
	trig delete();
	thread trap6a();
	thread trap6b();

}


trap6a()
{
	level endon("trigger");
	brush = getent("updown1", "targetname");
	brush movez (100,2);
	brush waittill("movedone");
		for(;;)
		{
		brush movez (-100,1);
		brush waittill("movedone");
		brush movez (100,1);
		brush waittill("movedone");
		}
}


trap6b()
{
	level endon("trigger");
	brush2 = getent("updown2", "targetname");
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

music()
{
    level waittill( "round_started" );
    
    wait 1;
    
    /* [AUTO DELETE] ambientPlay( "song1" ); */
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
             /* [AUTO DELETE] println("Could not add test client"); */
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
