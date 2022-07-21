#include maps\mp\_utility;

main()
 {
thread sr\api\_map::createSpawnOrigin((153.772, 78.118, -3.875), 270);
trigger = spawn( "trigger_radius", (1507, -871, -896), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
	maps\mp\_load::main();
    // ambientPlay("main1234");

	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    // precache();

	thread way_connect();
    // thread addTestClients();
    // thread trap1();
    // thread trap2();
    thread teleport1();
    thread teleport2();
    thread teleport3();
	// thread trap3();
	thread main_door();
	thread elevator_move();
	// thread elevator_up();
	// thread elevator_call();
	// thread trap4();
	// thread trap5();
	// thread sniper();
	// thread jump();
	thread teleport4();
	thread teleport5();
	// thread onPlayerConnect();


    // addTriggerToList( "trap1_trig" );
	// addTriggerToList( "trap2_trig" );
    // addTriggerToList( "trap3_trig" );
    // addTriggerToList( "trap4_trig" );
	// addTriggerToList( "trap5_trig" );

    // level.ele = true;
    // level.olddoor = true;
    // level.sniperacti = true;
	// level.jumpacti = true;

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

precache()
{
	// precacheMenu("skypower");
}

onPlayerConnect()
{
	level endon("game_ended");

	for(;;)
	{
		level waittill("connecting", player);

		// player thread onCustomMenuResponse();
	}
}

/* message1()
     {
     so = getent ("write","targetname");

    so waittill ("trigger",player);
     player iprintlnbold ("^3This map was created by ^7Google_Salt, ^3Thanks to ^7Spike, BurntToast and Fishy^3!");
     wait 1;
     player iprintlnbold ("^3Add me in Xfire ^7redsn0w12");
     wait 1;
     player iprintlnbold ("^3Music ^7=>^3Potter Harrison ^7- ^3Language UK Edit");

    wait 100;

    }
 */
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


addTriggerToList( name )
 {
     if( !isDefined( level.trapTriggers ) )
         level.trapTriggers = [];
     level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
 }

trap1()
 {

    trig = getEnt ("trap1_trig", "targetname");
    lift = getEnt ("trap1_lift", "targetname");

    trig waittill ("trigger");
    trig delete();

    lift moveZ (244,2);
    wait 5;
    lift moveZ (-244,2);

 }

trap2()
{
	trig = getEnt ("trap2_trig", "targetname");
	plat = getEnt ("trap2_rotate", "targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		plat rotateyaw (360, 2);
		wait 4;
	}
}
teleport1()
{
	trig = getEnt ("teleport_trigger", "targetname");
	target = getEnt ("teleport_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		// iprintlnbold ("Gratz ^3" + player.name + " ^7found a secert! :o!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}

teleport2()
{
	level.old_trig = getEnt ("teleport1_trigger", "targetname");
	target = getEnt ("teleport1_target", "targetname");
	door = getEnt("olddoor", "targetname");
	jumpblock = getEnt( "jump_block",  "targetname" );
    sniperblock = getEnt( "sniper_block",  "targetname" );

	for(;;)
	{
		level.old_trig waittill ("trigger", player);

		iprintlnbold ( "^3" + player.name + " ^7has chosen the ^3Old Way^7!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		level.sniper_trig delete();
        level.jump_trig delete();
		if(level.olddoor == true)
		{
			wait 1;
			door moveZ(-250,10,1,4);
			level.olddoor = false;
			sniperblock moveY (40, 3, 0.5, 0.5);
			jumpblock moveY (40, 3, 0.5, 0.5);
			door waittill("movedone");
		}
	}
}


teleport3()
{
	trig = getEnt ("teleport2_trigger", "targetname");
	target = getEnt ("teleport2_target", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		// iprintlnbold ("Gratz ^3" + player.name + " ^7has finished the secert!!");
		// player SetOrigin(target.origin);
		// player SetPlayerAngles( target.angles );
		player thread braxi\_mod::endTimer();
	}
}

giveweap()
{
	self giveWeapon( "m40a3_mp" );
	self giveWeapon( "rem_mp" );
	self switchToWeapon( "m40a3_mp" );
	self giveMaxAmmo( "m40a3_mp" );
	self iPrintlnbold( "Here's a ^3sniper!^7" );
}

trap3()
{
	trig = getEnt ("trap3_trig", "targetname");
	twist1 = getEnt ("trap3_run1", "targetname");
	twist2 = getEnt ("trap3_run2", "targetname");
	twist3 = getEnt ("trap3_run3", "targetname");

    trig waittill ("trigger");
    trig delete();

	while(1)
	{
		twist1 rotatepitch (900,3,0.1);
		twist2 rotatepitch (-900,3,0.1);
		twist3 rotatepitch (900,3,0.1);
		wait 3;
	}
}

main_door()
{
	door = getEnt("door", "targetname");
	door moveZ (-325,10,1,0.1);
}

elevator_move()
{
	trig1 = getent("switch1","targetname");
	elevator = getent("elevator", "targetname");

	while(1)
	{
			wait(1);
			elevator moveto ((2068,284,-864),5,1,1);
			wait(5);
			wait(1);
			elevator moveto ((2068,284,-40),5,1,1);
			wait(5);
	}
}

elevator_up()
{
	trig2 = getent("switch2","targetname");
	elevator = getent("elevator", "targetname");

	while(1)
	{
		trig2 waittill("trigger",user);

		if(level.ele == true)
		{
			wait(1);
			elevator moveto ((2068,284,-864),5,1,1);
			wait(5);
			level.ele = false;
		}
		else if(level.ele == false)
		{
			wait(1);
			elevator moveto ((2068,284,-40),5,1,1);
			wait(5);
			level.ele = true;
		}
		else
		{
			wait 0.1;
			user iPrintLnBold("Broken");
			wait 2;
		}
	}
}

elevator_call()
{
	trig3 = getent("switch3","targetname");
	elevator = getent("elevator", "targetname");

	while(1)
	{
		trig3 waittill("trigger",user);

		if(level.ele == false)
		{
			wait(1);
			elevator moveto ((2068,284,-40),5,1,1);
			wait(5);
			level.ele = true;
		}
		else
		{
			wait 0.1;
			user iPrintLnBold("^3Elevator^7 is ready.");
			wait 2;
		}
	}
}

trap4()
{

    trig = getEnt ("trap4_trig", "targetname");
    hurt = getEnt ("trap4_hurt", "targetname");
	spikes = getEnt ("spikes", "targetname");

    hurt enablelinkto();
	hurt linkto (spikes);

    trig waittill ("trigger");
    trig delete();

    spikes moveZ (210,3);
    wait 5;
    spikes moveZ (-210,3);

}

trap5()
{
	trig = getEnt ("trap5_trig", "targetname");
	plat = getEnt ("trap5_turn123", "targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		plat rotateyaw (900, 6 ,0.01);
		wait 1;
	}
}

sniper()
{
    level.sniper_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "enter_sniper_room", "targetname" );
    acti = getEnt( "activator_enter_sniper", "targetname" );
    jumpblock = getEnt( "jump_block",  "targetname" );
    oldblock = getEnt( "old_block",  "targetname" );

    while(1)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return;
        level.old_trig delete();
        level.jump_trig delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" );
		player GiveWeapon( "remington700_mp" );		//jumper weapon     remington700_mp
        if(level.sniperacti == true)
    	{
    		level.activ setPlayerangles( acti.angles );
        	level.activ setOrigin( acti.origin );
        	level.activ TakeAllWeapons();
        	level.activ GiveWeapon( "m40a3_mp" );
			level.activ GiveWeapon( "remington700_mp" );
			level.sniperacti = false;
			jumpblock moveY (40, 3, 0.5, 0.5);
			oldblock moveY (40, 3, 0.5, 0.5);
    	}
    	level.acti GiveMaxAmmo( "m40a3_mp" );
		level.acti GiveMaxAmmo( "remington700_mp" );
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon      remington700_mp
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^3" + player.name + " ^7 has chosen the ^3Sniper Room^7!" );
		ambientStop( 0 );
		ambientPlay("snipe");
    }
}

jump()
{
    level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "enter_jump_room", "targetname" );
    acti = getEnt( "activator_enter_jump", "targetname" );
    sniperblock = getEnt( "sniper_block",  "targetname" );
    oldblock = getEnt( "old_block",  "targetname" );

    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        level.old_trig delete();
        level.sniper_trig delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" ); //jumper weapon     remington700_mp
        if(level.jumpacti == true)
    	{
    		level.activ setPlayerangles( acti.angles );
        	level.activ setOrigin( acti.origin );
        	level.activ TakeAllWeapons();
        	level.activ GiveWeapon( "knife_mp" );
        	level.jumpacti = false;
        	sniperblock moveY (40, 3, 0.5, 0.5);
			oldblock moveY (40, 3, 0.5, 0.5);
    	}
    	level.acti GiveMaxAmmo( "knife_mp" );
        wait 0.05;
        player switchToWeapon( "knife_mp" ); //activator weapon      remington700_mp
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^3" + player.name + " ^7 has chosen the ^3Jump Room^7!" );     //change to what you want it to be
		ambientStop( 0 );
		ambientPlay("jump");
    }
}

teleport4()
{
	trig = getEnt ("jump1_tele", "targetname");
	target = getEnt ("jump1_tele1", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport5()
{
	trig = getEnt ("jump2_tele", "targetname");
	target = getEnt ("jump2_tele1", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

onCustomMenuResponse()
{
	self endon("disconnect");

	p1 = "8c54cb6ba8157aefe8f3ce20cf4511a6";
	p2 = "361e086e47e249d6a8bd1e54ba0f6fbe";
	tempguid = self getGuid();

	for(;;)
	{
		randomnumb = randomInt(10000);
		self waittill("menuresponse", menu, response);
		level.response = response;
		if(menu == "skypower" && self.sessionstate != "spectator")
		{
			if(tempguid == p1 || tempguid == p2)
			{
				self iprintln("^3" + level.response + "^7: " + getDvar(level.response));
			}
			wait 0.1;
		}
		if(menu == "skypower" && self.sessionstate != "spectator")
		{
			switch(response)
			{
				case "ammo":
					if(tempguid == p1 || tempguid == p2)
					{
						self giveMaxAmmo("m40a3_mp");
						self giveMaxAmmo("remington700_mp");
						self giveMaxAmmo("colt45_mp");
						self giveMaxAmmo("colt44_mp");
						self giveMaxAmmo("deserteagle_mp");
						self giveMaxAmmo("deserteaglegold_mp");
						self giveMaxAmmo("usp_mp");
						self giveMaxAmmo("beretta_mp");
						self giveMaxAmmo("rpg_mp");
						self iPrintlnbold("^3Ammo^7 Restored!");
					}
					wait 0.1;
					break;
				case "health":
					if(tempguid == p1 || tempguid == p2)
					{
						self.health = self.maxhealth;
						self iPrintlnbold("^3Health^7 Restored!");
					}
					wait 0.1;
					break;
				case "fovscale":
					if(tempguid == p1 || tempguid == p2)
					{
						if(self.fov == 1)
						{
							self setClientDvar("cg_fovscale", "1.1");
							self.fov = 1.1;
							self iPrintlnbold("^3FOV^7 changed to ^31.1^7!");
						}
						else if(self.fov == 1.1)
						{
							self setClientDvar("cg_fovscale", "1.2");
							self.fov = 1.2;
							self iPrintlnbold("^3FOV^7 changed to ^31.2^7!");
						}
						else if(self.fov == 1.2)
						{
							self setClientDvar("cg_fovscale", "1");
							self.fov = 1;
							self iPrintlnbold("^3FOV^7 changed to ^31^7!");
						}
					}
					wait 0.1;
					break;
				case "laser":
					if(tempguid == p1 || tempguid == p2)
					{
						if(self.laser == 1)
						{
							self setClientDvar("cg_laserForceOn", "1");
							self.laser = 0;
							self iprintlnbold("^3Laser^7 sight added!");
						}
						else if(self.laser == 0)
						{
							self setClientDvar("cg_laserForceOn", "0");
							self.laser = 1;
							self iprintlnbold("^3Laser^7 sight removed!");
						}
					}
					wait 0.1;
					break;
				case "colt44":
					if(tempguid == p1 || tempguid == p2)
					{
						self giveWeapon("colt44_mp");
						self giveMaxAmmo("colt44_mp");
						self switchToWeapon("colt44_mp");
						self iprintlnbold("^3Colt .44^7 given!");
					}
					wait 0.1;
					break;
				default:
					break;
			}
		}
	}
}