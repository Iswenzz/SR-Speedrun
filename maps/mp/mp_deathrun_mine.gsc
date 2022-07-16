main()
{

maps\mp\drown::main();
maps\mp\_load::main();
maps\mp\_teleport::main();

precacheModel( "mc_char" );
PrecacheItem( "rpg_mp" );

level.fx_explosion = LoadFX( "deathrun/explosion" );

ambientplay( "minecraft" );	
	
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

    // addTriggerToList( "trigger_bridge1" );
	// addTriggerToList( "trigger_trap2" );
	// addTriggerToList( "trigger_trap3" );
	// addTriggerToList( "trigger_floor" );
	// addTriggerToList( "trigger_floor2" );
	// addTriggerToList( "trigger_walk1" );
	// addTriggerToList( "trigger_walk2" );
	// addTriggerToList( "trigger_walk3" );
	// addTriggerToList( "trigger_fall" );
	// addTriggerToList( "trigger_lava" );
	// addTriggerToList( "trigger_squish" );

/*
elevatorparts = getentarray("trap2","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread trap2();
	}
	}
	
	elevatorparts = getentarray("trap3","targetname");
	if(isdefined(elevatorparts))
	{
	for(i=0;i<elevatorparts.size;i++)
	{
	wait(0.05);
	elevatorparts[i] thread trap3();
	}
	}
	*/

thread way_connect();
thread onPlayerSpawn();
thread bridge();
// thread rainbow();
// thread rainbow2();
// thread rainbow3();
// thread rainbow4();
// thread rainbow5();
// thread rainbow6();
// thread rainbow7();
// thread rainbow8();
// thread rainbow9();
// thread rainbow10();
// thread tnt();
// thread tntnew();
// thread tntthree();
// thread tntfour();
// thread tntfive();
// thread addTestClients();
// thread jukebox();
// thread jukebox2();
thread floor();
thread floor2();
thread walk1();
thread walk2();
thread walk3();
thread fall();
// thread block();
// thread block2();
// thread block3();
// thread block4();
// thread block5();
// thread block6();
thread lava();
thread squish();
thread teleportknife();
thread teleportsniper();
thread teleportjump();
thread oldopen();
thread give_rpg();
thread printCredits();
thread lol();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

onPlayerSpawn()
{
	while(1)
	{
		level waittill( "player_spawn", player );
		player detachAll();
		player setModel( "mc_char" );
		player setViewModel( "viewmodel_hands_zombie" );
		
	}
}


bridge()
{
bridge = getent("bridge1", "targetname");
trigger = getent("trigger_bridge1", "targetname");
org2 = getent("click", "targetname");
{
		trigger waittill ("trigger" , player );
		org2 PlaySound( "click" );
		trigger delete();
		wait 0.5 ;
		bridge delete();
		}
		}
		
		rainbow()
{
rainbow = getent("rainbow1", "targetname");
trigger = getent("trigger_rainbow1", "targetname");
org = getent("stone", "targetname");
{
		trigger waittill ("trigger" , player );
		org PlaySound( "stone" );
		trigger delete();
		rainbow delete();
		player iprintlnbold ("^5DIAMONDS !!!!");
		player braxi\_rank::giveRankXP("", 20);
		}
		}
		
		rainbow2()
{
rainbow2 = getent("rainbow2", "targetname");
trigger = getent("trigger_rainbow2", "targetname");
org1 = getent("stone1", "targetname");
{
		trigger waittill ("trigger" , player );
		org1 PlaySound( "stone" );
		trigger delete();
		rainbow2 delete();
		wait 0.5 ;
		player iprintlnbold ("^5DIAMONDS !!!!");
		player braxi\_rank::giveRankXP("", 20);
		}
		}
		
		rainbow3()
{
rainbow3 = getent("rainbow3", "targetname");
trigger = getent("trigger_rainbow3", "targetname");
org10 = getent("stone2", "targetname");
{
		trigger waittill ("trigger" , player );
		org10 PlaySound( "stone" );
		trigger delete();
		rainbow3 delete();
		wait 0.5 ;
		}
		}
		
		rainbow4()
{
rainbow4 = getent("rainbow4", "targetname");
trigger = getent("trigger_rainbow4", "targetname");
org16 = getent("stone3", "targetname");
{
		trigger waittill ("trigger" , player );
		org16 PlaySound( "stone" );
		trigger delete();
		rainbow4 delete();
		wait 0.5 ;
		}
		}
		
		rainbow5()
{
rainbow5 = getent("rainbow5", "targetname");
trigger = getent("trigger_rainbow5", "targetname");
org17 = getent("stone4", "targetname");
{
		trigger waittill ("trigger" , player );
		org17 PlaySound( "stone" );
		trigger delete();
		rainbow5 delete();
		wait 0.5 ;
		player iprintlnbold ("^5DIAMONDS !!!!");
		player braxi\_rank::giveRankXP("", 20);
		}
		}

		rainbow6()
{
rainbow6 = getent("rainbow6", "targetname");
trigger = getent("trigger_rainbow6", "targetname");
org20 = getent("stone5", "targetname");
{
		trigger waittill ("trigger" , player );
		org20 PlaySound( "stone" );
		trigger delete();
		rainbow6 delete();
		wait 0.5 ;
		}
		}
		
		rainbow7()
{
rainbow7 = getent("rainbow7", "targetname");
trigger = getent("trigger_rainbow7", "targetname");
org21 = getent("stone6", "targetname");
{
		trigger waittill ("trigger" , player );
		org21 PlaySound( "stone" );
		trigger delete();
		rainbow7 delete();
		wait 0.5 ;
		}
		}
		
		rainbow8()
{
rainbow8 = getent("rainbow8", "targetname");
trigger = getent("trigger_rainbow8", "targetname");
org22 = getent("stone7", "targetname");
{
		trigger waittill ("trigger" , player );
		org22 PlaySound( "stone" );
		trigger delete();
		rainbow8 delete();
		wait 0.5 ;
		player iprintlnbold ("^5DIAMONDS !!!!");
		player braxi\_rank::giveRankXP("", 20);
		}
		}
		
rainbow9()
{
rainbow9 = getent("rainbow9", "targetname");
trigger = getent("trigger_rainbow9", "targetname");

trigger delete();
rainbow9 delete();


}
		
		rainbow10()
{
rainbow10 = getent("secretunlock", "targetname");
trigger = getent("trigger_secretunlock", "targetname");

trigger delete();
rainbow10 delete();

}
		
		
		tnt()
{

		}
		
		tntnew()
{

		}
		
		tntthree()
{

		}
		
		tntfour()
{

		}
		
		tntfive()
{

		}
		
	
		
		trap2()
{
trigger = getEnt("trigger_trap2", "targetname");
org3 = getent("click2", "targetname");
trigger waittill("trigger");
org3 PlaySound( "click" );
trigger delete();
while(1)
{
wait(0.01);
self movez(-40, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movez(40, 2, 0.5, 1);
self waittill("movedone");
wait(4);
} 
}

trap3()
{
trigger = getEnt("trigger_trap3", "targetname");
org4 = getent("click3", "targetname");
trigger waittill("trigger");
org4 PlaySound( "click" );
trigger delete();
while(1)
{
wait(0.01);
self movez(40, 2, 0.5, 1);
self waittill("movedone");
wait(0.5);
self movez(-40, 2, 0.5, 1);
self waittill("movedone");
wait(4);
} 
}

floor()
{

}
		
floor2()
{

}
		
		walk1()
{

		}
		
		walk2()
{

		}

		walk3()
{

		}
		
		fall()
{

}

block()
{
trigger = getEnt("trigger_block", "targetname");
object = getEnt("block", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
object movez(80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
} 
}
		
block2()
{
trigger = getEnt("trigger_block2", "targetname");
object = getEnt("block2", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-80 , 3, 1, 2);
object waittill("movedone");
wait(0.5);
object movez(80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
} 
}		
	
block3()
{
trigger = getEnt("trigger_block3", "targetname");
object = getEnt("block3", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
object movez(80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
} 
}

block4()
{
trigger = getEnt("trigger_block4", "targetname");
object = getEnt("block4", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
object movez(80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
} 
}

block5()
{
trigger = getEnt("trigger_block5", "targetname");
object = getEnt("block5", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
object movez(80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
} 
}

block6()
{
trigger = getEnt("trigger_block6", "targetname");
object = getEnt("block6", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
object movez(80, 3, 1, 2);
object waittill("movedone");
wait(0.5);
} 
}

lava()
	  {
	  
	  }
	  
squish()
	  {
	  
	  }
	  
	  give_rpg()
{
trigger = getent ("give_rpg_trig","targetname");
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("You Have Taken [^4rpg^7]");
wait(0.1);	
user giveWeapon( "rpg_mp");
user giveMaxammo("rpg_mp");
user SetActionSlot( 3, "weapon", "rpg_mp" );
wait 0.1;
user switchToWeapon("rpg_mp");
wait 0.1;
trigger delete();
}
}

lol()
{
	model[0] = getEnt("steve1","targetname");
	model[1] = getEnt("steve2","targetname");
	model[2] = getEnt("steve3","targetname");
	model[3] = getEnt("steve4","targetname");
	model[4] = getEnt("steve5","targetname");
	model[5] = getEnt("steve6","targetname");
	model[6] = getEnt("steve7","targetname");
	model[7] = getEnt("steve8","targetname");
	model[8] = getEnt("steve9","targetname");
	model[9] = getEnt("steve10","targetname");
	trigger = getEnt ("dontshootme","targetname");
	earthy = getEnt( "jew", "targetname" );
	killtrigger1 = getent ("movetrig4" , "targetname");
	killtrigger2 = getent ("movetrig6" , "targetname");
	killtrigger3 = getent ("movetrig8" , "targetname");
	killtrigger4 = getent ("movetrig9" , "targetname");
	killtrigger5 = getent ("movetrig1" , "targetname");
	killtrigger6 = getent ("movetrig7" , "targetname");
	killtrigger7 = getent ("movetrig2" , "targetname");
	killtrigger8 = getent ("movetrig3" , "targetname");
	killtrigger1 enablelinkto ();
	killtrigger1 linkto (model[4]);
	killtrigger2 enablelinkto ();
	killtrigger2 linkto (model[6]);
	killtrigger3 enablelinkto ();
	killtrigger3 linkto (model[9]);
	killtrigger4 enablelinkto ();
	killtrigger4 linkto (model[5]);
	killtrigger5 enablelinkto ();
	killtrigger5 linkto (model[0]);
	killtrigger6 enablelinkto ();
	killtrigger6 linkto (model[3]);
	killtrigger7 enablelinkto ();
	killtrigger7 linkto (model[2]);
	killtrigger8 enablelinkto ();
	killtrigger8 linkto (model[1]);
	for(i=0;i<model.size;i++)
		model[i] MoveZ(-1000,.05);
		
	trigger waittill ("trigger" , player );
	level.jumpertrigger delete();
    level.bouncetrigger delete();
    level.snipertrigger delete();
	level.trigger delete();
	level.trigger2 delete();
	iPrintLnBold("^1That Can't Be Good ....");
	wait 2 ;
	player braxi\_rank::giveRankXP("", 200);
	visionsetnaked("conjuration", 1 );
	earthquake( 2, 5, earthy.origin, 20000 );
	musicplay( "boom" );
	for(i=0;i<model.size;i++)
		model[i] MoveZ(1000,.05);
		wait 5 ;
		AmbientStop( 2 );
		ambientplay( "13" );
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
		self.logoText setText("^2---^1Map Made By Xenon^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2---^1Thanks To Lossy^2,^1Rednose^2,^1Duffman^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2---^1Xfire^2=^1abstrafer^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}
	  
	
jukebox()
{

		}	
		
		jukebox2()
{

		}	
		
		addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
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

oldopen()
{
level.oldtrigger = getEnt("trigger_oldopen", "targetname");
level.oldtrigger waittill("trigger", player);
object = getEnt("oldopen", "targetname");
object2 = getEnt("oldopen2", "targetname");
object delete();
object2 delete();

}

teleportknife()
{

}

teleportsniper()
{

}

teleportjump()
{

}

	  
