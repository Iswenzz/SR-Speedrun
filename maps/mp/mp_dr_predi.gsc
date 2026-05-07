main()
{
	maps\mp\_load::main();
	//ambientPlay("gorillaz");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	addTriggerToList( "trigger_spin1" );
    addTriggerToList( "trigger_spinner2" );
    addTriggerToList( "trigger_wall" );
	addTriggerToList( "trigger_move" );
	addtriggerTolist( "trigger_spinner3");

	thread sr\api\_map::createSpawn((145, 107, -436), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^3Medium Secret");
	thread sr\api\_speedrun::createWay((518.185, -347.649, -511.875), 95, 120, "green", "secret_0");
    thread sr\api\_speedrun::createEndMap((180.538, 5379.98, -319.875),165,120, "normal_0"); 
	
	thread sr_med_sec_enter();
	
	//thread spin1();
	//thread spinner2();	
	//thread finalFight();
	//thread printCredits();
	//thread move();
	thread easy_sec_finish(); 
	//thread secret();
	thread med_sec_finish();
	//thread wall();
	//thread spinner3();
	
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
sr_med_sec_enter()
{
	trig = spawn("trigger_radius",(51.7743, 243.268, -495.875), 0, 50, 120);
	trig.radius = 50;
	ori_t = getEnt("teleport_secret","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
	med_sec_finish()
	{
	trig = getEnt ("finish_trigger", "targetname");
	target = getEnt ("teleport_finish", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);		

		player thread sr\api\_speedrun::finishWay("secret_1");
	}
}
	
	secret()
	{
	trig = getEnt ("secret_trigger", "targetname");
	target = getEnt ("teleport_secret", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("Welcome to the Secret Room, Good Luck");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
	
	easy_sec_finish()
{
	trig = getEnt ("teleport_trigger", "targetname");
	target = getEnt ("teleport_target", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}



    printCredits()
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
                    self.logoText setText("^0---^1Map created by Elpredatore^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0--^1xf: elpredatore^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1Scripts by TwiYo^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1xf: 1buzzz^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
					self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1Special Thanks to Xenon^0---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1xf: abstrafer^0---");
					wait 3;
					self.logoText fadeOverTime(1);
					self.logoText.alpha = 0;
					wait 1;
					self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1Special Thanks to Neo^0---");
					wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^0---^1xf: gribmate^0---");
					wait 3;
					self.logoText fadeOverTime(1);
					self.logoText.alpha = 0;
					wait 1;
            }
    }


	
spin1()
 {
	trigger = getEnt ("trigger_spin1", "targetname");
	object = getEnt ("spin1", "targetname");
	
	trigger waittill ("trigger", Player);
	trigger delete();
	
	Player iPrintLnBold("^1Activated!");
	
	while (1)
	{
	
		object rotateroll (-360, 1.5);
		wait (2);
		
	}
	
}
	
 
spinner2()
 {
	trigger = getEnt ("trigger_spinner2", "targetname");
	object = getEnt ("spinner2", "targetname");
	
	trigger waittill ("trigger", Player);
	trigger delete();
	
	Player iPrintLnBold("^1Activated!");
	
	while (1)
	{
	
		object rotateroll (-360, 1.5);
		wait (2);
		
	}
	
}
	
spinner3()
{
		
	trigger = getEnt ("trigger_spinner3", "targetname");
	object = getEnt ("spinner3", "targetname");
	
	trigger waittill ("trigger", Player);
	trigger delete();
	
	Player iPrintLnBold("^1Activated!");
	
	while(1)
	{
		object rotateroll (360, 1.5);
		wait (2);
	}
}


	finalFight()
{
	music_changed = false;
    trig = getEnt( "final_trigger", "targetname" );
    tele_activator = getEnt( "final_activator_teleport", "targetname" );
    tele_jumper = getEnt( "final_jumper_teleport", "targetname" );
                
    level.finalJumper = undefined;
	
		
    while( 1 )
    {
        trig waittill( "trigger", player );
		
		if (!music_changed)
		{
			music_changed = true;
			thread endMusic();
		}

      
        if( level.freeRun || isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "remington700_mp", 100 );
        level.activ finalRoom( tele_activator, "remington700_mp", 100 );
		
		iPrintlnBold( " ^6" + player.name + " ^5 HAS ENTERED THE FINAL ROOM^1!" );
    }
   
}

endMusic()
{
	AmbientStop(1);
	wait 2;
	AmbientPlay("sail");
}


finalMonitor()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}

monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}

finalRoom( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
    
    self TakeAllWeapons(); 
    self GiveWeapon( weap );
    self GiveMaxAmmo( weap );
    self SwitchToWeapon( weap );
} 

		
move()
{
	trigger = getent("trigger_move","targetname");
	object = getent("move","targetname");
	trigger waittill ("trigger", player);
	trigger delete();
	
	Player iPrintLnBold("^1Activated!");
	
	while(1)
	{
		object movez(110, 2);
		object waittill("movedone");
		wait(2);
		object movez(-110, 3);
		object waittill("movedone");
		wait(1);
		}
}		
	
wall()
{	
	trigger = getent("trigger_wall","targetname");
	object = getent("wall","targetname");
	killtrigger = getent ("killtrig" , "targetname");
	trigger waittill ("trigger", player);
	trigger delete();
	
	Player iPrintLnBold("^1Activated!");
	
	
	{
		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object moveX(-330, 0.5);
		object waittill("movedone");
		wait(2);
		object moveX(330, 3);
		object waittill("movedone");
		wait(1);
		}
}
	
	
	
	
	
				
	
	
	
	
	
	
	
	
                 addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}