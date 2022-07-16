/*
##########################################################
#\ \####/ /#| |#| |#\ \####/ /#|_|#| \####| |#|_|#|  _  |#
##\ \##/ /##| |#| |##\ \##/ /##   #|  \###| |#   #| |#| |#
###\ \/ /###| |#| |###\ \/ /###| |#| \ \##| |#| |#| |#| |#
####\  /####| |#| |####\  /####| |#| |\ \#| |#| |#| |#| |#
####/  \####| |#| |####/  \####| |#| |#\ \| |#| |#| |#| |#
###/ /\ \###| |#| |###/ /\ \###| |#| |##\ | |#| |#| |#| |#
##/ /##\ \##| |_| |##/ /##\ \##| |#| |###\  |#| |#| |_| |#
#/ /####\ \#|_____|#/ /####\ \#|_|#|_|####\_|#| |#|_____|#
##########################################################

	thks Rycoon! :)
|*************************************|
	Xfire: xuxinio
*/


main()
{
  	maps\mp\_load::main();
	maps\mp\mp_fnrp_monderland_fx::main();
	maps\createfx\mp_fnrp_monderland_fx::main();
	maps\mp\_compass::setupMiniMap ("compass_map_mp_fnrp_monderland");
	
	// ambientPlay("ambient_mp_fnrp_monderland");

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
	
	// thread MakeTriggers();
	thread onConnected();
	thread WatchGame();
	// thread AddTestClients();
	level.roll = 0;

	// iprintln("^1The game starts in ^7");
	
	// for(i=8;i>=0;i--)
	// {
		// iprintln("^1" + i + " ");
		// wait 1;
	// }

	abrir_puertas = getEnt("bigdoor", "targetname");
	abrir_puertas movez (-200,1,0,0.6);
	abrir_puertas waittill ("movedone");

	// iprintlnbold("^1Go!");

	
	// endtrig thread WatchEndTrigger();
	speedrun\_way_name::createWay("normal", "Normal Way", "1");
	
}

onConnected()
{
	while(1)
	{
		level waittill("connected", player );
		player.isSliding = false;
		player.glitching = false;
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
	level.trapTriggers[7] = getent("trigger8", "targetname");
	
	
	level.trapTriggers[0] thread trapN1();
	level.trapTriggers[1] thread trapN2();
	level.trapTriggers[2] thread trapN3();
	level.trapTriggers[3] thread trapN4();
	level.trapTriggers[4] thread trapN5();
	level.trapTriggers[5] thread trapN6();
	level.trapTriggers[6] thread trapN7();
	level.trapTriggers[7] thread trapN8();


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
trapN8()
{
	while(1)
	{
		self waittill("trigger", who );

		thread gotrap8();
		self delete();
		break;
	}
}



gotrap1()
{
	trabn1_obj= getentarray("trap1","targetname");
	if(isdefined(trabn1_obj))
	{
		for(i=0;i<trabn1_obj.size;i++)
 		{	
		trabn1_obj[i] thread movetrap1();	
		}	
	}

}
movetrap1()
{
	while(1)
	{
		self rotatePitch(360,0.5);
		self waittill("rotatedone");
		wait(RandomInt(4));
		
	}

}
gotrap2()
{
	trabn2_obj = getent("trap2","targetname");
	level.roll = 1;
	while(1)
	{
		trabn2_obj rotatePitch(-360,100);
		trabn2_obj waittill ("rotatedone"); 
	}	

}

gotrap3()
{
	trabn3_obj = getent("trap3","targetname");
	while(1)
	{
		trabn3_obj rotateYaw(360,10);
		trabn3_obj waittill ("rotatedone");
		wait(RandomInt(4)); 
	}		
}

gotrap4()
{
	trabn4_obj= getentarray("trap4","targetname");
	if(isdefined(trabn4_obj))
	{
		for(i=0;i<trabn4_obj.size;i++)
 		{	
		trabn4_obj[i] thread movetrap4();	
		}	
	}

}
movetrap4()
{
		
	self.nun = RandomInt(2);
	if (self.nun != 1)
	{
		self movez (-300,1,0,0.1);
		self waittill ("movedone");
	}

}

gotrap5()
{
	trabn5_obj = getent("trap5","targetname");
	
		trabn5_obj movez (-500,1,0,0.1);
		trabn5_obj waittill ("movedone");
		
		wait (4);
		
		trabn5_obj movez (500,2,0,0.6);
		trabn5_obj waittill ("movedone");
}


gotrap6()
{
	trabn6_obj = getent("trap6","targetname");
	
		trabn6_obj movex (-150,1,0,0.1);
		trabn6_obj waittill ("movedone");
		
		wait (4);
		
		trabn6_obj movex (150,2,0,0.6);
		trabn6_obj waittill ("movedone");
}

gotrap7()
{
	trabn7_obj1 = getent("trap71","targetname");
	trabn7_obj2 = getent("trap72","targetname");

	while(1)
	{
		trabn7_obj1 rotateRoll(-360,6);
		wait(RandomInt(2));
		trabn7_obj2 rotatePitch(360,6);
		trabn7_obj2 waittill ("rotatedone");
		wait(RandomInt(3));
	}	
}
gotrap8()
{
	trabn8_obj= getentarray("trap8","targetname");
	if(isdefined(trabn8_obj))
	{
		for(i=0;i<trabn8_obj.size;i++)
 		{	
		trabn8_obj[i] thread movetrap8();	
		}	
	}

}
movetrap8()
{
		
	self.nun = RandomInt(2);
	if (self.nun != 1)
	{
		self movey (-300,1,0,0.1);
		self waittill ("movedone");
	}

}



WatchGame()
{
	level.finalfight = false;
	
	while(1)
	{
		level waittill("activator", who );
		// thread GetGlitchTriggers();
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
	self FreezeControls(1);
	self iprintlnbold("^1HAHAHAHA! CAUGHT YOU GLITCHER! >:)");
	self PlayLocalSound("laughing");
	wait 4;
	self iprintlnbold("^3Wanna see something cool, hmm? >:)");
	self SetClientDvar("cg_thirdperson", 1 );
	wait 4;
	self iprintlnbold("^1BUUUUUUUUUUUUUUUUURN! HAHAHA!!!");
	wait 2;
	iprintlnbold("^1LOOK! ^7" + self.name + " ^1is BURNING due to glitching!");
	iprintlnbold("^1HUAHAHAHA!");
	self SetClientDvar("cg_thirdperson", 0 );
	wait 8;
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
	level.turn = 0;
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
			for(clturn=0;clturn<level.turn;clturn++)
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
				self.control = 1;
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
			level.acti_enemy = level.jumper_turn[0];
			iprintlnbold( who.name + " ^1reached as first the end hall!");
			iprintlnbold("^11 VS 1 Fight!");
			if(level.roll != 1)
				{
				thread gotrap2();
				}
			thread StartFinalFight();
			thread controljumper();	
		}
	}
}
controljumper()
{
	
	while(1)
	{
		
		if( isAlive(level.acti_enemy))
		{
			for(turn=0;turn<level.turn;turn++)
			{
				iprintln( turn + "^2 >" + level.jumper_turn[turn]+ " ");
				wait 2;
	   		}
			
		}
		else
		{
			for(turn=0;turn<level.turn;turn++)
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
	
	if( !level.freeRun ) 
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
 