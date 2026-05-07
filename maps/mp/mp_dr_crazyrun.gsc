main()
{
  	maps\mp\_load::main();
	//maps\mp\mp_dr_crazyrun_fx::main();
	//maps\createfx\mp_dr_crazyrun_fx::main();
	//maps\mp\_compass::setupMiniMap ("compass_map_mp_dr_crazyrun");
	
	//ambientPlay("ambient_mp_dr_crazyrun");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");

	thread sr\api\_map::createSpawn((-1685, 276, 92), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((5588.86, 637.577, -959.875), 80,150, "normal_0"); 
	
	//thread MakeTriggers();
	//thread onConnected();
	//thread WatchGame();
	//thread AddTestClients();
	thread teleport1();
	thread teleport2();
	//thread ascensor();

	endtrig = getEnt("finaldoor", "targetname");
	//endtrig thread WatchEndTrigger();
	
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
	trabn1_obj1 = getEnt("trap11","targetname");
	trabn1_hurt1 = getEnt ("trap11hurt", "targetname");
	trabn1_hurt1 enablelinkto();
    	trabn1_hurt1 linkto (trabn1_obj1);

	trabn1_obj2 = getEnt("trap12","targetname");
	trabn1_hurt2 = getEnt ("trap12hurt", "targetname");
	trabn1_hurt2 enablelinkto();
    	trabn1_hurt2 linkto (trabn1_obj2);
	
	
	trabn1_obj1 rotateYaw(-180,3);
	trabn1_obj1 waittill("rotatedone");
	
	wait(RandomInt(4));
	
	trabn1_obj2 rotateYaw(-180,3);
	trabn1_obj2 waittill("rotatedone");

}

gotrap2()
{
	trabn2_obj = getent("trap2","targetname");
	
		trabn2_obj movez (-100,1,0,0.1);
		trabn2_obj waittill ("movedone");
		
		wait (5);
		
		trabn2_obj movez (100,2,0,0.6);
		trabn2_obj waittill ("movedone");
}

gotrap3()
{
	trabn3_obj1= getentarray("trap3_dx","targetname");
	if(isdefined(trabn3_obj1))
	{
		for(i=0;i<trabn3_obj1.size;i++)
 		{	
		trabn3_obj1[i] thread movetrap31();	
		}	
	}

	trabn3_obj2= getentarray("trap3_sx","targetname");
	if(isdefined(trabn3_obj2))
	{
		for(i=0;i<trabn3_obj2.size;i++)
 		{	
		trabn3_obj2[i] thread movetrap32();	
		}	
	}

}
movetrap31()
{
		
	self.nun = RandomInt(2);
	if (self.nun != 1)
	{
		self rotatePitch(360,20);
		self waittill ("rotatedone");
	}

}
movetrap32()
{
		
	self.nun = RandomInt(2);
	if (self.nun != 1)
	{
		self rotatePitch(-360,20);
		self waittill ("rotatedone");
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
	wait(RandomInt(6));
		self movey (-200,0.5);
		self waittill ("movedone");
			
	wait(RandomInt(6));
		self movey (200,1);
		self waittill ("movedone");	
	
}

gotrap5()
{
	trabn5_obj = getent("trap5","targetname");
	trabn5_hurt = getEnt ("trap5hurt", "targetname");
	
	trabn5_hurt enablelinkto();
    	trabn5_hurt linkto (trabn5_obj);

	while(1)
	{
		trabn5_obj rotateroll(360,0.5);
		trabn5_obj waittill("rotatedone");
		wait(RandomInt(3));
	}
		
		
}



gotrap6()
{
	trabn6_obj = getent("trap6","targetname");
	
	trabn6_obj movez (-200,1,0,0.1);
	trabn6_obj waittill ("movedone");
	
	wait(5);
	
	trabn6_obj movez (200,1,0,0.1);
	trabn6_obj waittill ("movedone");
}

gotrap7()
{
	trabn7_obj1 = getent("trap71","targetname");
	trabn7_obj2 = getent("trap72","targetname");
	trabn7_hurt2 = getEnt ("trap72hurt", "targetname");
	
	trabn7_hurt2 enablelinkto();
    	trabn7_hurt2 linkto (trabn7_obj2);

	trabn7_obj2 movez (-180,1,0,0.1);
	trabn7_obj2 waittill ("movedone");
	
	wait (5);
	
	trabn7_obj2 movez (180,1,0,0.1);
	trabn7_obj2 waittill ("movedone");
}

teleport1()
{
	telini1 = getent("teleport1","targetname");
	telend1 = getent("scroon1", "targetname");

	for(;;)
	{
		telini1 waittill( "trigger", player );
		player SetPlayerAngles( telend1.angles );
		player SetOrigin( telend1.origin );
		wait 1;
	}
}

teleport2()
{
	telini2 = getent("teleport2","targetname");
	telend2 = getent("scroon2", "targetname");

	for(;;)
	{
		telini2 waittill( "trigger", player );
		player SetPlayerAngles( telend2.angles );
		player SetOrigin( telend2.origin );
		wait 1;
	}
}

ascensor()
{
	acsensor_obj = getent("baja","targetname");
	acs_tig = getent("usar_baja","targetname");

while(1)
	{
	acs_tig waittill( "trigger" );
	acsensor_obj movez (-990,5);
	acsensor_obj waittill ("movedone");
	
	wait(2);
	
	acs_tig waittill( "trigger" );
	acsensor_obj movez (990,5);
	acsensor_obj waittill ("movedone");
	}	

}



WatchGame()
{
	level.finalfight = false;
	
	while(1)
	{
		level waittill("activator", who );
		thread GetGlitchTriggers();
		who thread AntiFreeTraps();
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
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "axis" && isAlive(players[i]) )
		{
			acti = players[i];
			break;
		}
	}
	

	start1 = getent("ffight_activator", "targetname");
	start2 = getent("ffight_jumper", "targetname");
	
	acti SetPlayerAngles( start1.angles );
	acti SetOrigin( start1.origin );
	
	jumper SetPlayerAngles( start2.angles );
	jumper SetOrigin( start2.origin );
	
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
 