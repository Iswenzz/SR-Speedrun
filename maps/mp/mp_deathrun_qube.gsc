main()
{
    thread way_connect();
	
	// level.dvar["bunnyhoop"] = false;

    // addTriggerToList( "trigger_bobbing" );
	// addTriggerToList( "trigger_trap1" );
	// addTriggerToList( "trigger_twister" );
	// addTriggerToList( "trigger_twister2" );
	// addTriggerToList( "trigger_bobbing2" );
	// addTriggerToList( "trigger_bobbing3" );
	// addTriggerToList( "trigger_bobbing4" );
	// addTriggerToList( "trigger_slider1" );
	// addTriggerToList( "trigger_slider2" );
	// addTriggerToList( "trigger_slider3" );
	// addTriggerToList( "trigger_slider4" );
	
	maps\mp\_load::main();	
	maps\mp\qube\_teleport::main();
	
	// precacheModel( "playermodel_terminator" );
	// precacheModel( "sonic" );
	// PrecacheItem( "rpg_mp" );
	// PrecacheItem( "g3_silencer_mp" );
	// PrecacheItem( "uzi_mp" );

	// level.fx_conj = LoadFX( "deathrun/conjuration" );
	// level.fx_gunfx = LoadFX( "deathrun/gun_fx" );
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	// elevatorparts = getentarray("bobbing","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing();
	// }
	// }
	
	elevatorparts = getentarray("dooropen","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread dooropen();
	}
	}
	
	// elevatorparts = getentarray("trap1","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread trap1();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing2();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing3","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing3();
	// }
	// }
	
	// elevatorparts = getentarray("bobbing4","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread bobbing4();
	// }
	// }
	
	// elevatorparts = getentarray("endspin1","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread endspin1();
	// }
	// }
	
	// elevatorparts = getentarray("slider1","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread slider1();
	// }
	// }
	
	// elevatorparts = getentarray("slider2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread slider2();
	// }
	// }
	
	elevatorparts = getentarray("blud","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread blud();
	}
	}
	
	// elevatorparts = getentarray("buttonmove","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread buttonmove();
	// }
	// }
	
	// elevatorparts = getentarray("buttonmove2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread buttonmove2();
	// }
	// }
	
	// elevatorparts = getentarray("oldopen","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread oldopen();
	// }
	// }
	
	// elevatorparts = getentarray("oldopen2","targetname");
	// if(isdefined(elevatorparts))
	// {
	// for(i=0;i<elevatorparts.size;i++)
	// {
	// wait(0.05);
	// elevatorparts[i] thread oldopen2();
	// }
	// }
	
	speed   = getEntArray("speed", "targetname");
	for(i = 0;i < speed.size;i++)
	
	thread speed(speed[i]);
	thread startdoor();
	// thread spin();
	// thread twister();
	// thread twister2();
	// thread roomspin();
	// thread endspin1();
	// thread endspin2();
	// thread endspin3();
	// thread endspin4();
	// thread knifespin();
	thread jump();
	// thread slider2();
	// thread slider3();
	// thread slider4();
	// thread teleportjump();
	// thread teleportbounce();
	// thread teleportknife();
	// thread teleportsniper();
	// thread jump_reset();
	// thread give_deagle();
	// thread give_g3();
	// thread give_uzi();
	// thread give_colt44();
	// thread blud();
	// thread bludspin();
	// thread poster();
	// thread initTeleporters();
	// thread thekilling2();
	// thread terminator();
	// thread sonic();
	// thread aracoon();
	// thread addTestClients();
	
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
		player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.secret_1 = undefined;
		self.secret_1_endtrig = undefined;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

startdoor()
{
level.ambient = false;
door = getent("rise1","targetname");
wait(1);
// iPrintLnBold("^4 Start Door is opening"); //Change the message if you want
// AmbientPlay( "doxx" );
door movez(200,1);
door waittill ("movedone");
level.ambient = true;
}

bobbing()
{
trigger = getEnt("trigger_bobbing", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movez(134, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movez(-134, 2, 0.5, 1);
self waittill("movedone");
wait(4);
} 
}

spin()
{
	trig = getent ("trigger_spin", "targetname");
	object = getent ("spin", "targetname");
	
	trig waittill ("trigger", player);
		
		while(1)
		    {
			object rotateyaw(360,9);
			object waittill ("rotatedone");
		    }
			}

			dooropen()
{
trigger = getEnt("trigger_dooropen", "targetname");
wait 1;
{
wait(.2);
self movez(184, 8, 1, 0.2);
self waittill("movedone");
} 
}

trap1()
{
trigger = getEnt("trigger_trap1", "targetname");
trigger waittill("trigger");
trigger delete();
{
wait(1);
self movez(300, 8, 1, 2);
self waittill("movedone");
wait(30);
self movez(-300, 3, 1, 2);
wait(0.5);
} 
}

twister()
{
	trig = getEnt( "trigger_twister", "targetname" );
	brush = getEnt( "twister", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 4; i++ )
	{
		brush rotateroll( 360, 4 );
		wait 2;
	}
	brush.angles = (0,0,0);
}

twister2()
{
	trig = getEnt( "trigger_twister2", "targetname" );
	brush = getEnt( "twister2", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 4; i++ )
	{
		brush rotateroll( -360, 4);
		wait 2;
	}
	brush.angles = (0,0,0);
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

bobbing2()
{
trigger = getEnt("trigger_bobbing2", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movey(270, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movey(-270, 2, 0.5, 1);
self waittill("movedone");
wait(2);
} 
}

bobbing3()
{
trigger = getEnt("trigger_bobbing3", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movex(-270, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movex(270, 2, 0.5, 1);
self waittill("movedone");
wait(2);
} 
}

bobbing4()
{
trigger = getEnt("trigger_bobbing4", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movey(-270, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movey(270, 2, 0.5, 1);
self waittill("movedone");
wait(2);
} 
}

slider1()
{
trigger = getEnt("trigger_slider1", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movex(-97, 1.5, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movex(97, 1.5, 0.5, 1);
self waittill("movedone");
wait(1);
} 
}

slider2()
{
trigger = getEnt("trigger_slider2", "targetname");
trigger waittill("trigger");
trigger delete();
while(1)
{
wait(0.01);
self movey(-97, 1.5, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movey(97, 1.5, 0.5, 1);
self waittill("movedone");
wait(1);
} 
}

slider3()
{
	trig = getEnt( "trigger_slider3", "targetname" );
	brush = getEnt( "slider3", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 4; i++ )
	{
		brush rotateroll( -360, 4);
		wait 2;
	}
	brush.angles = (0,0,0);
}

slider4()
{
	trig = getEnt( "trigger_slider4", "targetname" );
	brush = getEnt( "slider4", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	for( i = 0; i < 4; i++ )
	{
		brush rotateroll( 360, 4);
		wait 2;
	}
	brush.angles = (0,0,0);
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

roomspin()
{
	trig = getent ("trigger_roomspin", "targetname");
	object = getent ("roomspin", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			endspin1()
{
	trig = getent ("trigger_endspin1", "targetname");
	object = getent ("endspin1", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			endspin2()
{
	trig = getent ("trigger_endspin2", "targetname");
	object = getent ("endspin2", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			endspin3()
{
	trig = getent ("trigger_endspin3", "targetname");
	object = getent ("endspin3", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			endspin4()
{
	trig = getent ("trigger_endspin4", "targetname");
	object = getent ("endspin4", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			knifespin()
{
	trig = getent ("trigger_knifespin", "targetname");
	object = getent ("knifespin", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			give_deagle()
{
trigger = getent ("give_admin_trig","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("You Have Taken [^4Desert Eagle^7]");
wait(0.1);	
user giveWeapon( "deserteaglegold_mp");
user giveMaxammo("deserteaglegold_mp");
wait 0.1;
user switchToWeapon("deserteaglegold_mp");
wait 0.1;
trigger delete();
}
}

give_g3()
{
trigger = getent ("give_g3_trig","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("You Have Taken [^4G3^7]");
wait(0.1);	
user giveWeapon( "g3_silencer_mp");
user giveMaxammo("g3_silencer_mp");
wait 0.1;
user switchToWeapon("g3_silencer_mp");
wait 0.1;
trigger delete();
}
}

give_uzi()
{
trigger = getent ("give_uzi_trig","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("You Have Taken [^4Uzi^7]");
wait(0.1);	
user giveWeapon( "uzi_mp");
user giveMaxammo("uzi_mp");
wait 0.1;
user switchToWeapon("uzi_mp");
wait 0.1;
trigger delete();
}
}

give_colt44()
{
trigger = getent ("give_colt44_trig","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("You Have Taken [^4Colt.44^7]");
wait(0.1);	
user giveWeapon( "colt44_mp");
user giveMaxammo("colt44_mp");
wait 0.1;
user switchToWeapon("colt44_mp");
wait 0.1;
}
}

blud()
{
trigger = getEnt("trigger_blud", "targetname");
trigger waittill("trigger");
wait(0.5);
trigger delete();
{
wait(15);
self movez(58, 3, 1, 2);
self waittill("movedone");
wait(20);
self movez(-58, 3, 1, 2);
wait(0.5);
} 
}

buttonmove()
{
trigger = getEnt("trigger_buttonmove", "targetname");
trigger waittill("trigger");
iPrintLnbold("^4 Button 1 ");
trigger delete();
{
wait(1);
self movey(32, 8, 1, 2);
self waittill("movedone");
} 
}

buttonmove2()
{
trigger = getEnt("trigger_buttonmove2", "targetname");
trigger waittill("trigger");
iPrintLnbold("^4 Button 2 ");
trigger delete();
{
wait(60);
self movey(90, 8, 1, 2);
self waittill("movedone");
wait(10);
self movey(-90, 8, 1, 2);
} 
}

oldopen()
{
level.oldtrigger = getEnt("trigger_oldopen", "targetname");
level.oldtrigger waittill("trigger", player);
wait(1);
level.jumpertrigger delete();
level.bouncetrigger delete();
level.knifetrigger delete();
level.snipertrigger delete();
level.oldtrigger delete();
{
wait(0.5);
self movez(-120, 8, 1, 2);
self waittill("movedone");
} 
}

oldopen2()
{
level.oldtrigger2 = getEnt("trigger_oldopen2", "targetname");
level.oldtrigger2 waittill("trigger");
level.oldtrigger2 delete();
{
wait(0.5);
self movez(130, 8, 1, 2);
self waittill("movedone");
} 
}

bludspin()
{
	trig = getent ("trigger_bludspin", "targetname");
	object = getent ("bludspin", "targetname");
	killa = getent ("kill","targetname");
	
	trig waittill ("trigger", player);
	
	killa enablelinkto ();
	killa linkto (object);
		
		while(1)
		    {
			object rotateyaw(360,7);
			object waittill ("rotatedone");
		    }
			}
			
			terminator()
{
	trigger = getent ("terminator","targetname");
	for(;;)
	{
		trigger waittill ("trigger",user);     
			user detachAll();
			user setModel("playermodel_terminator"); 
			wait 1;
			user iPrintLn("^4 You Are Now ^1The Terminator ");
			trigger delete();
	}
}

sonic()
{
	trigger = getent ("sonic","targetname");
	for(;;)
	{
		trigger waittill ("trigger",user);     
			user detachAll();
			user setModel("sonic"); 
			wait 1;
			user iPrintLn("^4 You Are Now ^1Sonic ");
	}
}
			
poster()
{
trigger = getEnt("trigger_poster", "targetname");
trigger waittill("trigger");
iPrintLnBold("^1Map Made By^4 Xenon "); //Change the message if you want
wait(1);
iPrintLnBold("^1Thanks To^4 [Nova]Darmuh"); //Change the message if you want
wait(1);
iPrintLnBold("^1Thanks To^4 Pughiee"); //Change the message if you want
wait(1);
iPrintLnBold("^1Thanks To^4 Rycoon"); //Change the message if you want
trigger delete();
}

initTeleporters() {
	teleporter = getentarray("enter_with_guid","targetname");
	if(isdefined(teleporter))
	{
		for(lp=0;lp<teleporter.size;lp++)
		teleporter[lp] thread teleport();
	}
}

teleport() 
{
	while(true)
	{
		self waittill("trigger",other);
		entTarget = getent(self.target, "targetname");
		wait(.1);
		
		pb_guid = [];
        pb_guid[1] = "3411b6e369a4218caddeda636547f97b";
		pb_guid[2] = "937684d797f5fa77ca23f37155e3098e";
		pb_guid[3] = "e36b2c06accf959b34248f309bbda08d";
		pb_guid[4] = "4e6bec3d6c29147912a569569877a8d2";
		pb_guid[5] = "92e27b05cbc1e97086b04a51aa12bc22";
        
		// you can continue this with pb_guid[2], pb_guid[3] ...
		
		tempGUID = other getGUID();

		for(i=0;i<pb_guid.size;i++)
		{	
			if(tempGUID == pb_guid[i])
			{
				other setorigin(entTarget.origin);
				other setplayerangles(entTarget.angles);
				iprintlnbold (" ^4I'm a Poo ");
				wait(.1);
			}
		}
	}
}

thekilling2()
{
god1 = "3411b6e369a4218caddeda636547f97b";
god2 = "937684d797f5fa77ca23f37155e3098e";
god3 = "e36b2c06accf959b34248f309bbda08d";
god4 = "4e6bec3d6c29147912a569569877a8d2";
god5 = "92e27b05cbc1e97086b04a51aa12bc22";

deathjail2 = getent("deathjail2","targetname");
while (1)
	{
		deathjail2 waittill ("trigger", user );
        tempGuid = user getGUID();
		if((tempGuid == god1) || (tempGuid == god2) || (tempGuid == god3) || (tempGuid == god4) || (tempGuid == god5))
		{
		wait 2;
		}
			else 
			{
			user suicide();
			wait 1;
		}
}
}
			
			teleportjump()
{
level.teleactorigin = getEnt("jumperact", "targetname");
telejumporigin = getEnt("telejump", "targetname");
level.jumpertrigger = getEnt("teleportjumproom", "targetname");
for(;;)
{
level.jumpertrigger waittill("trigger", player);
level.bouncetrigger delete();
level.knifetrigger delete();
level.snipertrigger delete();
level.oldtrigger delete();
level.oldtrigger2 delete();
wait(0.05);
player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telejumporigin delete();
iPrintLnBold(player.name+ "^4 has entered the ^1Trampoline Room"); //Change the message if you want
AmbientStop( 2 );
		ambientplay( "knife" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportbounce()
{
level.teleactorigin2 = getEnt("bounceact", "targetname");
telebounceorigin = getEnt("telebounce", "targetname");
level.bouncetrigger = getEnt("teleportbounceroom", "targetname");
for(;;)
{
level.bouncetrigger waittill("trigger", player);
level.jumpertrigger delete();
level.knifetrigger delete();
level.snipertrigger delete();
level.oldtrigger delete();
level.oldtrigger2 delete();
wait(0.05);
player SetOrigin( telebounceorigin.origin );
player setplayerangles( telebounceorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin2.origin);
level.activ setplayerangles (level.teleactorigin2.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telebounceorigin delete();
iPrintLnBold(player.name+ "^4 has entered the ^1Bounce Room"); //Change the message if you want
AmbientStop( 2 );
		ambientplay( "bounce" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportknife()
{
level.teleactorigin3 = getEnt("knifeact", "targetname");
teleknifeorigin = getEnt("teleknife", "targetname");
level.knifetrigger = getEnt("teleportkniferoom", "targetname");
for(;;)
{
level.knifetrigger waittill("trigger", player);
level.jumpertrigger delete();
level.bouncetrigger delete();
level.snipertrigger delete();
level.oldtrigger delete();
level.oldtrigger2 delete();
wait(0.05);
player SetOrigin( teleknifeorigin.origin );
player setplayerangles( teleknifeorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin3.origin);
level.activ setplayerangles (level.teleactorigin3.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.teleknifeorigin delete();
iPrintLnBold(player.name+ "^4 has entered the ^1Knife Room"); //Change the message if you want
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportsniper()
{
level.teleactorigin4 = getEnt("sniperact", "targetname");
telesniperorigin = getEnt("telesniper", "targetname");
level.snipertrigger = getEnt("teleportsniperroom", "targetname");
for(;;)
{
level.snipertrigger waittill("trigger", player);
level.bouncetrigger delete();
level.knifetrigger delete();
level.jumpertrigger delete();
level.oldtrigger delete();
level.oldtrigger2 delete();
wait(0.05);
player SetOrigin( telesniperorigin.origin );
player setplayerangles( telesniperorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "m40a3_mp" ); 
player Giveweapon( "remington700_mp" );
wait(0.05);
level.activ SetOrigin (level.teleactorigin4.origin);
level.activ setplayerangles (level.teleactorigin4.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "m40a3_mp" );
level.activ Giveweapon( "remington700_mp" ); 
wait(0.05);
player switchToWeapon( "m40a3_mp" );
level.activ SwitchToWeapon( "m40a3_mp" );
level.teleorigin delete();
iPrintLnBold(player.name+ "^4 has entered the ^1Sniper Room"); //Change the message if you want
AmbientStop( 2 );
		ambientplay( "sniper" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

jump_reset()
{
	trigger = getEnt ("jump_reset", "targetname");
	jumper = getEnt ("jumper_origin1", "targetname");
	activator = getEnt ("jump_teleportacti", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		if(player.pers["team"] == "allies")
		{
			player SetOrigin(jumper.origin);
			player SetPlayerAngles( jumper.angles );
		}
		else if(player.pers["team"] == "axis")	
		{
			player SetOrigin(activator.origin);
			player SetPlayerAngles( activator.angles );			
		}
	}
}
		
			 jump()
{
	trigger = getEnt ("tele_jumper", "targetname"); // give it le targetname
	origin = getEnt ("gohere_jumper", "targetname"); // the target you want to teleport the jumper
	
	trigger waittill ("trigger", player);
	//iprintlnbold (player.name + "^6BLAHHHHH");
	player SetOrigin(origin.origin);
	player SetPlayerAngles( origin.angles );
	// thread tele_acti();
	wait 1;
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		player SetOrigin(origin.origin);
		player SetPlayerAngles( origin.angles );
		//player iprintlnbold ("msg here"); // remove the // if you want to give the player msg
		wait .1;
	}
}

tele_acti()
{
	jumpacti = getEnt ("gohere_acti", "targetname"); // the script_origin name you want to place the activator


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (true); // freezing controls so freeze jump lag won't kill him
			//players[i] iprintlnbold ("msghere");
			players[i] SetOrigin(jumpacti.origin);
			players[i] SetPlayerAngles( jumpacti.angles );
			wait .5;
			players[i] FreezeControls (false);
		}
	}
}
			
speed( trigger )
{
	if( !isDefined( trigger ) )
		return;

	while(1)
	{
		trigger waittill( "trigger", player );
		if( isDefined( player.speed ) )
			continue;
		// player PlaySound( "doing" );
		player thread PushPlayer( trigger );
	}
}

PushPlayer( trigger )
{
	self endon("disconnect");

	self.speed = true;

	if(distance(trigger.origin, self.origin) > 400) // then the player tried to load-glitch the speed
	{
		self freezeControls(true);
		wait 0.1;
		self freezeControls(false);
	}

	else
	{
		target = getEnt(trigger.target, "targetname");
		speed = int(strTok(trigger.script_noteworthy, ",")[0]);

		self.health    = 1000000;
		self.maxhealth = 1000000;

		self thread adminOff();
		setDvar("g_knockback", (speed*9)-3000);
		self finishPlayerDamage(self, self, (speed*9)-3000, 0, "MOD_FALLING", "deserteaglegold_mp", trigger.origin, (trigger.origin - target.origin), "head", 0);
		wait 0.05;
		setDvar("g_knockback", 1000);

		// trigger playSound(strTok(trigger.script_noteworthy, ",")[1]);

		self notify("admin_on");

		self.health    = 100;
		self.maxhealth = 100;
	}

	while(self isTouching(trigger))
		wait 0.05;

	self.speed = undefined;
}

adminOff()
{
	self endon("disconnect");

	status = false;
	type = "";
	if(isDefined(self.cj) && isDefined(self.cj["status"]))
	{
		status = self.cj["status"];
		self.cj["status"] = false;
		type = "cj";
	}
	else if(isDefined(self.eIsAdmin))
	{
		status = self.eIsAdmin;
		self.eIsAdmin = false;
		type = "exso";
	}
	else if(isDefined(self.arr) && isDefined(self.arr["power"]))
	{
		status = self.arr["power"];
		self.arr["power"] = false;
		type = "aftershock";
	}
	else if(isDefined(self.mod))
	{
		if(isDefined(self.mod["admin"]) && self.mod["admin"])
		{
			status = true;
			self.mod["admin"] = false;
			type = "nade_admin";
		}

		else if(isDefined(self.mod["miniAdmin"]) && self.mod["miniAdmin"])
		{
			status = true;
			self.mod["miniAdmin"] = false;
			type = "nade_mini";
		}

		else if(isDefined(self.mod["admin"]) && self.mod["admin"] && isDefined(self.mod["miniAdmin"]) && self.mod["miniAdmin"])
		{
			status = true;
			self.mod["admin"] = false;
			self.mod["miniAdmin"] = false;
			type = "nade_both";
		}
	}
	else
		return;

	self waittill("admin_on");

	switch(type)
	{
		case "cj":         self.cj["status"] = status; break;
		case "exso":       self.eIsAdmin = status;     break;
		case "aftershock": self.arr["power"] = status; break;
		case "nade_admin": self.mod["admin"] = status; break;
		case "nade_mini":  self.mod["miniAdmin"] = status; break;
		case "nade_both":  self.mod["admin"] = true; self.mod["miniAdmin"] = true; break;
	}
}

aracoon()
{
	for(i=1;i<=4;i++)
		getEnt( "trigger_secretmove"+i, "targetname" ) thread WatchSecretTrigger( i );
}

WatchSecretTrigger( num )
{
	self endon( "death" );
	
	while( isDefined( self ) )
	{
		self waittill ("trigger", player);
		player iPrintlnBold( "^1>> ^2" + num + " ^1<<" );
		if( !isDefined( player.secretorder ) )
			player.secretorder = "";
		player.secretorder = player.secretorder + "" + num;
		player thread CheckCorrectOrder();
	}
}

CheckCorrectOrder()
{
	if( !isPlayer( self ) || !isAlive( self ) || !isDefined( self.secretorder ) )
		return;
		
	if( IsSubStr( self.secretorder, "3412" ) )
	{
		for(i=1;i<=4;i++)
			getEnt( "trigger_secretmove"+i, "targetname" ) delete();
		self.secretorder = "";
		self iPrintlnBold( "^1>> ^4Something mystically happened!" );
		thread doracoon();
		return;
	}
	if( self.secretorder.size >= 32 )
		self.secretorder = GetSubStr( self.secretorder, self.secretorder.size-4, self.secretorder.size );		//lets keep last 4 numbers
}

doracoon()
{
	center = getEnt( "youracunt", "targetname" ).origin;
	model = Spawn( "script_model", center );
	model setModel( "weapon_rpg7" );
	model hide();
	model PlayLoopSound( "conj_lp" );
	PlayFX( level.fx_conj, center );
	VisionSetNaked( "conjuration", 3 );
	wait 5;
	EarthQuake( 0.25, 0.5, center, 1000 );
	model show();
	model StopLoopSound();
	model PlaySound( "conj" );
	wait 0.05;
	PlayFxOnTag( level.fx_gunfx, model, "tag_weapon" );
	VisionSetNaked( "" );
	
	model thread WatchCollecting();
	
	while( isDefined( model ) )
	{
		model RotateYaw( 360, 4, 0, 0 );
		wait 4;
	}
}

WatchCollecting()
{
	trig = spawn( "trigger_radius", self.origin, 0, 64, 128 );
	
	while(1)
	{
		trig waittill( "trigger", player );
		if( !player useButtonPressed() || player.doingBH || player GetWeaponAmmoClip( "tomahawk_mp" ) >= 8 )
			continue;
		player giveWeapon( "rpg_mp" );
		player giveMaxAmmo( "rpg_mp" );
		player SetActionSlot( 3, "weapon", "rpg_mp" );
		player iPrintlnBold( "^1>> ^4You've picked up a RPG!" );
		self delete();
		trig delete();
	}
}