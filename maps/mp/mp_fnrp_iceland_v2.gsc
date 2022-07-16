/*
##############################################################################
##|       |##\  \####/  /##|        |##|        |##|        |##|   \####|  |##
##|   _   |###\  \##/  /###|  ______|##|   __   |##|   __   |##|    \###|  |##
##|  |_|  |####\  \/  /####|  |########|  |  |  |##|  |  |  |##|  \  \##|  |##
##|       |#####\    /#####|  |########|  |  |  |##|  |  |  |##|  |\  \#|  |##
##|       |######|  |######|  |########|  |  |  |##|  |  |  |##|  |#\  \|  |##
##|  |\  \#######|  |######|  |########|  |__|  |##|  |__|  |##|  |##\  |  |##
##|  |#\  \######|  |######|        |##|        |##|        |##|  |###\    |##
##|__|##\__\#####|__|######|________|##|________|##|________|##|__|####\___|##
##############################################################################

	thks Rycoon! :)
|*************************************|
	Xfire: phaedrean
*/


main()
{
trig = getEnt("finaldoor", "targetname");
level.mapHasTimeTrigger = true;
wait 1;
thread speedrun\_triggerfx::createTrigFx(trig, "endtrig");
while(1)
{
trig waittill("trigger", player);
player thread braxi\_mod::endTimer();
}
  	maps\mp\_load::main();
	maps\mp\mp_fnrp_iceland_fx::main();
	maps\createfx\mp_fnrp_iceland_fx::main();
	maps\mp\mp_fnrp_iceland_navegar::main();
	maps\mp\_compass::setupMiniMap ("compass_map_mp_fnrp_iceland");
	
	// ambientPlay("ambient_mp_fnrp_iceland");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");
	
	thread way_connect();
	thread bigjumper();
	thread jumper();
	// thread MakeTriggers();
	thread onConnected();
	thread WatchGame();
	// thread AddTestClients();

	wait 1;
	door1_obj = getent("startdoor","targetname");
	door1_obj movez (-250,2,0,0.6);
	door1_obj waittill ("movedone");

	endtrig = getEnt("finaldoor", "targetname");
	// endtrig thread WatchEndTrigger();
	
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	
    for(;;) 
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

onConnected()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.isSliding = false;
		self.glitching = false;
	}
}

MakeTriggers()
{
	wait 0.5;
	level.trapTriggers[0] = getent("trigger1", "targetname");
	level.trapTriggers[1] = getent("trigger2", "targetname");
	level.trapTriggers[2] = getent("trigger3", "targetname");
	level.trapTriggers[3] = getent("trigger4", "targetname");
	level.trapTriggers[4] = getent("trigger5", "targetname");
	level.trapTriggers[5] = getent("trigger6", "targetname");
	level.trapTriggers[6] = getent("trigger7", "targetname");
	
	level.trapTriggers[0] thread trapN1();
	level.trapTriggers[1] thread trapN2();
	level.trapTriggers[2] thread trapN3();
	level.trapTriggers[3] thread trapN4();
	level.trapTriggers[4] thread trapN5();
	level.trapTriggers[5] thread trapN6();
	level.trapTriggers[6] thread trapN7();

}

trapN1()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap1();
		self delete();
		break;
	}
	
}
trapN2()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap2();
		self delete();
		break;
	}	
}
trapN3()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap3();
		self delete();
		break;
	}
}

trapN4()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap4();
		self delete();
		break;
	}
}

trapN5()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap5();
		self delete();
		break;
	}	
}

trapN6()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap6();
		self delete();
		break;
	}
}
trapN7()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap7();
		self delete();
		break;
	}
}

gotrap1()
{
	trabn1_obj1 = getent("trap11","targetname");
	trabn1_obj2 = getent("trap12","targetname");
	flag1 = getent("flag1","targetname");
	flag2 = getent("flag2","targetname");
	
	self.nun = RandomInt(2);
		
	if (self.nun != 1)
	{
		trabn1_obj1 movez (-100,3,0,0.6);
		flag1 movez (40,3,0,0.6);
		trabn1_obj1 waittill ("movedone");
		

		 
		
 	}else{
		trabn1_obj2 movez (-100,3,0,0.6);
		flag1 movez (40,3,0,0.6);
		trabn1_obj2 waittill ("movedone");
		} 

	

}
gotrap2()
{
	trabn2_obj1 = getent("trap21","targetname");
	trabn2_obj2 = getent("trap22","targetname");
	
		trabn2_obj1 movez (-106,2,0,0.6);
		trabn2_obj1 waittill ("movedone"); 
		wait (1);
 		
		trabn2_obj1 movez (106,2,0,0.6);
		trabn2_obj1 waittill ("movedone"); 
		wait (1); 

		trabn2_obj2 movez (-106,2,0,0.6);  
		trabn2_obj2 waittill ("movedone"); 
		wait (1); 
		
		trabn2_obj2 movez (106,2,0,0.6);
		trabn2_obj2 waittill ("movedone"); 

}


gotrap3()
{
	trabn3_obj = [];
	trabn3_obj[0] = getent("trap3","targetname");
	trabn3_obj[1] = getent("trap32","targetname");
	trabn3_obj[2] = getent("trap33","targetname");
	trabn3_obj[3] = getent("trap34","targetname");
	trabn3_obj[4] = getent("trap35","targetname");
	trabn3_obj[5] = getent("trap36","targetname");
	trabn3_obj[6] = getent("trap37","targetname");
	trabn3_obj[7] = getent("trap38","targetname");

	for(i=0;i<7;i++)
 	{
	trabn3_obj[i] rotatePitch(360,6);
	wait (0.5);
	}
	trabn3_obj[7] waittill ("rotatedone");	
}

gotrap4()
{

	trabn4_obj = [];
	trabn4_obj[0] = getent("trap41","targetname");
	trabn4_obj[1] = getent("trap42","targetname");
	trabn4_obj[2] = getent("trap43","targetname");
	trabn4_obj[3] = getent("trap44","targetname");
	trabn4_obj[4] = getent("trap45","targetname");
	trabn4_obj[5] = getent("trap46","targetname");
	trabn4_obj[6] = getent("trap47","targetname");
	trabn4_obj[7] = getent("trap48","targetname");
	trabn4_obj[8] = getent("trap49","targetname");
	trabn4_obj[9] = getent("trap410","targetname");
	trabn4_obj[10] = getent("trap411","targetname");
	trabn4_obj[11] = getent("trap412","targetname");
	trabn4_obj[12] = getent("trap413","targetname");
	
	for(i=0;i<12;i++)
 	{
  	trabn4_obj[i] rotateRoll(360,0.5);
	wait (0.1);
 	}
	trabn4_obj[11] waittill ("rotatedone");
}

gotrap5()
{
	trabn5_obj = getent("trap5","targetname");
	
		trabn5_obj movez (-390,11,0,0.1);
		trabn5_obj waittill ("movedone");
		wait (1);
 		
		trabn5_obj movez (390,11,0,0.1);
		trabn5_obj waittill ("movedone"); 
 
}

gotrap6()
{
	
	trabn6_obj = getent("trap6","targetname");
	
		trabn6_obj rotatePitch(360,0.5);
		trabn6_obj waittill ("rotatedone");
		
}

gotrap7()
{
	rool1_obj = getent ("rool1","targetname");
	rool2_obj = getent ("rool2","targetname");

	while(1)
	{
		rool1_obj rotateRoll(360,0.5);
		rool1_obj waittill ("rotatedone");
		wait (RandomInt(3));
		rool2_obj rotateRoll(360,0.5);
		rool2_obj waittill ("rotatedone");
		wait (RandomInt(3));
	} 
	 		
}

jumper()
{
jumpx = getent ("jump","targetname");
glow = getent ("glow","targetname");
air1 = getent ("air1","targetname");
air2 = getent ("air2","targetname");
air3 = getent ("air3","targetname");
air4 = getent ("air4","targetname");


	


	for(;;)
	{
	jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			user thread jumper_ng(user);
		}
	}
}

jumper_ng(user)
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	air = spawn ("script_model",(0,0,0));

		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		time = .1;
			air moveto (air1.origin, 1);
		wait .1;
			air moveto (air2.origin, 1);
		wait .1;
			air moveto (air3.origin, 1);
		wait .1;
			air moveto (air4.origin, 1);
		wait 1;
		user unlink();
		wait 1;
}

bigjumper()
{
jump1 = getent ("jump1","targetname");

big_air1 = getent ("big_air_1","targetname");
big_air2 = getent ("big_air_2","targetname");
big_air3 = getent ("big_air_3","targetname");
big_air4 = getent ("big_air_4","targetname");
big_air5 = getent ("big_air_5","targetname");

	for(;;)
	{
		jump1 waittill ("trigger",user);
		
		if(user istouching(jump1))
		{
			user thread bigjumper_ng(user);
		}
	}
}

bigjumper_ng(user)
{
	jump1 = getent ("jump1","targetname");
	big_air1 = getent ("big_air_1","targetname");
	big_air2 = getent ("big_air_2","targetname");
	big_air3 = getent ("big_air_3","targetname");
	big_air4 = getent ("big_air_4","targetname");
	big_air5 = getent ("big_air_5","targetname");
	airbig = spawn ("script_model",(0,0,0));

		airbig.origin = user.origin;
		airbig.angles = user.angles;
		user linkto (airbig);
		time = .1;
			airbig moveto (big_air1.origin, 1);
		wait .1;
			airbig moveto (big_air2.origin, 1);
		wait .1;
			airbig moveto (big_air3.origin, 1);
		wait .1;
			airbig moveto (big_air4.origin, 1);
		wait 1;
			airbig moveto (big_air5.origin, 1);
		wait 1;
		user unlink();
		wait 1;
}

WatchGame()
{
	level.finalfight = false;
	
	while(1)
	{
		level waittill("activator", who );
		thread GetGlitchTriggers();
		// who thread AntiFreeTraps();
	}
}

AntiFreeTraps()
{
	if( getDvarInt("scr_activator_freerun") != 1 )
		return;
	
	self FreezeControls(1);
	wait getDvarInt("scr_activator_freerun_wait");
	self FreezeControls(0);
}

GetGlitchTriggers()
{
	triggers = getentarray("glitch_trigger", "targetname");
	for(i=0;i<triggers.size;i++)
		triggers[i] thread WatchGlitchTrigger();
}

WatchGlitchTrigger()
{
	while(1)
	{
		self waittill("trigger", who );
		if( !level.freeRun && !who.glitching )
			who thread DoAntiGlitcher();
	}
}

DoAntiGlitcher()
{
	self.glitching = true;
	self suicide();
	self.glitching = false;
}


WatchIfAllDead()
{
	while(1)
	{
		if( getTeamPlayersAlive("allies") < 1 || getTeamPlayersAlive("axis") < 1 )
		{
			//AmbientStop(1);
			break;
		}
		wait 0.2;
	}
}


WatchEndTrigger()
{
	level.acti_enemy = undefined;
	level.turn = 1;
	level.jumper_turn = [];
	while(1)
	{
		self waittill("trigger", who );
		if( getTeamPlayersAlive("axis") < 1 )
		{
			who iprintlnbold("^1wait! ^2what's Activator??");
			return;
		}
		
		if( isDefined( level.acti_enemy ) && level.acti_enemy != who )
		{
			self.control = 0;
			for(clturn=1;clturn<level.turn;clturn++)
			{
				if( level.jumper_turn[clturn] ==  who )
				{	self.control = 1;
				}
			}
			
			if( self.control != 1)
			{
				level.turn = level.turn + 1;
				who iprintlnbold("^1wait your turn" + level.turn );
				level.jumper_turn[level.turn] = who;
				wait 3;
			}
			else
			{
				who iprintlnbold("^4wait your turn :)");
				wait 3;
			}
			
				
		}
		if( !isDefined(level.acti_enemy))
		{
			level.jumper_turn[level.turn] = who;
			level.acti_enemy = level.jumper_turn[1];
			iprintlnbold( who.name + " ^1reached as first the end hall!");
			iprintlnbold("^11 VS 1 Fight!");
			thread StartFinalFight();
			thread controljumper();	
		}
	}
}
controljumper()
{
	
	while(1)
	{
		
		if(isAlive(level.acti_enemy))
		{
			for(turn=1;turn<level.turn;turn++)
			{
				iprintln( turn + "^2 >" + level.jumper_turn[turn]);
				wait 2;
	   		}
			
		}
		else
		{
			for(turn=1;turn<level.turn;turn++)
			{	
				if( isAlive(level.jumper_turn[turn]))
				{
					level.acti_enemy = level.jumper_turn[turn];
					thread StartFinalFight();
				}
			}	
		     }
	wait 3;
	}
}

StartFinalFight()
{
	

	acti = undefined;
	jumper = level.acti_enemy;
	self.armo = "knife_mp";

	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "axis" && isAlive(players[i]) )
		{
			acti = players[i];
			break;
		}
	}
	
	if( getDvarInt("scr_activator_freerun") != 1 ) 
		{
			self.armo = "colt45_mp";
		}



	start1 = getent("ffight_activator", "targetname");
	start2 = getent("ffight_jumper", "targetname");
	
	acti SetPlayerAngles( start1.angles );
	acti SetOrigin( start1.origin );
	acti TakeAllWeapons();
	acti GiveWeapon(self.armo);
	acti SetSpawnWeapon(self.armo);
	
	jumper SetPlayerAngles( start2.angles );
	jumper SetOrigin( start2.origin );
	jumper TakeAllWeapons();
	jumper GiveWeapon(self.armo);
	jumper SetSpawnWeapon(self.armo);


	acti FreezeControls(1);
	jumper FreezeControls(1);
	
	VisionSetNaked( "finalfight_intro_mp", 2 );
	wait 2;

	noti = SpawnStruct();
	noti.titleText = "=|FINAL FIGHT|=";
	noti.notifyText = "1 VS 1 " + self.armo ;
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 2;
	
	noti = SpawnStruct();
	noti.titleText = acti.name + " ^1VS ^7" + jumper.name;
	noti.notifyText = "GET READY!";
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 2;
	
	VisionSetNaked( "finalfight_mp", 2 );
	jumper FreezeControls(0);
	acti FreezeControls(0);
	
	iprintlnbold("^1F  I  G  H  T !");
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
 
 