main()
{
level.masterSpawn = spawn("script_origin", (623,4,-259));
level.masterSpawn.angles = level.spawn["allies"][0].angles;
level.masterSpawn placeSpawnPoint();
trigger = spawn("trigger_radius", (473.171, 390.95, -288.875), 0, 80, 125);
trigger.targetname = "endmap_trig";
trigger.radius = 80;
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar( "compassmaxrange", "1024" );


	level.spark_fx = LoadFx("impacts/tank_round_spark");
	level.afterburn_fx = LoadFx("smoke/tribute");
	level.chicken_fx = LoadFx("explosions/default_explosion");
	level.water_fx = LoadFx("explosions/mortarExp_water");
	level.fire_fx = LoadFX("fire/firelp_barrel_pm");
	level.break_fx = LoadFX("break");

	precacheModel( "com_wall_fan" );
	precacheModel( "chicken" );
	precacheModel( "icbm_elevatorswitch" );

	precacheItem( "frag_grenade_mp");
	precacheItem( "uzi_mp");
	precacheItem( "deserteagle_mp");

	thread way_connect();

	//thread onPlayerConnect();
	//thread speed();
	//thread water();
	thread trap1();
	thread trap2();
	//thread trap3();
	//thread trap4();
	thread trap5();
	thread trap6();
	//thread trap7();
	thread trap8();
	//thread trap9();
	thread trap10();
	thread trap11();
	/*
	thread trap13();

	thread trap14();
	thread trap15();
	thread trap16();
	thread trap17();
	thread trap18();
	thread final();
	thread final_tele1();
	thread final_tele2();
	thread addTestClients();
	thread addtrapstofreerun();*/


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

bounce( pos, power )//This function doesnt require to thread it
{
	oldhp = self.health;
	self.health = self.health + power;
	self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
	self finishPlayerDamage( self, self, power, 0, "MOD_PROJECTILE", "bh_mp", undefined, pos, "none", 0 );
	self.health = oldhp;
	self thread bounce2();
}

bounce2()
{
	self endon( "disconnect" );
	wait .05;
	self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
}

onPlayerConnect()
{
	while(1)
	{
		level waittill("connected", player);
		player thread onDeath();
	}
}


onDeath()
{
}

water()
{
}

speed()
{
	trig = getent ("speed","targetname");
	while(1)
	{
	trig waittill ("trigger", who);
	who SetMoveSpeedScale( 1.5 );
	}
}

trap1()
{
	trig = getent("trap1_trig", "targetname");
	dmg = getent("trap1_dmg", "targetname");
	spark1 = getent("spark3", "targetname");
	spark2 = getent("spark4", "targetname");
	spark3 = getent("spark5", "targetname");
	spark4 = getent("spark7", "targetname");
	spark5 = getent("spark8", "targetname");
	spark6 = getent("spark1", "targetname");
	spark7 = getent("spark2", "targetname");
	spark8 = getent("spark6", "targetname");
	spark9 = getent("spark9", "targetname");
	spark10 = getent("spark10", "targetname");
	spark11 = getent("spark11", "targetname");
	spark12 = getent("spark12", "targetname");
	spark13 = getent("spark13", "targetname");
	spark14 = getent("spark14", "targetname");

	dmg delete();;


}

trap2()
{
	trap = getent("trap2", "targetname");
	trig = getent("trap2_trig", "targetname");

	trap delete();
}

trap3()
{
	
	trap = getent("trap3_push", "targetname");
	trig = getent("trap3_trig", "targetname");
	sound = getent("fan_sound", "targetname");

	trig waittill ("trigger");
	trig delete();
	
	sound PlayloopSound ("fan");
	sound PlayloopSound ("fan");
	sound PlayloopSound ("fan");
	
	timeElapsed = 0;
	seconds = 10;

	while( timeElapsed != seconds*10 )
	{
		players = getPlayers();

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( trap ) && players[i].sessionstate == "playing" )
			{		
			players[i] bounce( (-40,0,10), 60);
			//if ( players[i] GetStance() == "prone") )...				
			}
		}
		wait 0.06;
		timeElapsed++;
	}
	sound delete();
	trap delete();
}


getPlayers()
{
	return getEntArray( "player", "classname" );
}


trap4()  // Thx for BraXi
{
	activator = getEnt( "trap4_trig", "targetname" ); // trigger_use_touch
	area = getEnt( "trap4_check", "targetname" ); // trigger_multiple
	
	trafficLightRed = getEnt( "lamp_red2", "targetname" ); // script_model or script_brushmodel
	trafficLightYellow = getEnt( "lamp_yellow2", "targetname" ); // script_model or script_brushmodel
	trafficLightGreen = getEnt( "lamp_green2", "targetname" ); // script_model or script_brushmodel
	
	trafficLightRed hide();
	trafficLightYellow hide();

	activator waittill( "trigger" ); // wait for trigger

	trafficLightGreen hide();
	trafficLightRed show(); //red light now
	trafficLightRed PlaySound ("stuck");
	wait 0.2;

	timeElapsed = 0;
	seconds = 5; //ppl cant move for 5 seconds
	yellowTime = 4;

	while( timeElapsed != seconds*10 )
	{
		players = getPlayers();

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( area ) && players[i].sessionstate == "playing" )
			{
				if( !isDefined( players[i].safePosition ) )
					players[i].safePosition = players[i].origin;
				else
				{
					if( distance( players[i].safePosition, players[i].origin ) > 3 ) // then can move only 3 units
					{	
						//playFx( SomeNiceFx, players[i] getTagOrigin( "j_spine" ) );
						//players[i] playSound( "SomeNiceSound" );
						players[i] suicide();
						players[i].safePosition = undefined;
					}
				}
			}
		}
		wait 0.1;
		timeElapsed++;

		if( (timeElapsed/10) == yellowTime )
		{
			trafficLightRed hide();
			trafficLightYellow show();
			trafficLightRed PlaySound ("stuck");
		}
	}

	trafficLightRed delete();
	trafficLightYellow delete();
	trafficLightGreen show();
	trafficLightGreen PlaySound ("stuck");

	area delete();

}

trap5()
{
	trap = getent("trap5", "targetname");
	trig = getent("trap5_trig", "targetname");
	dmg = getent("trap5_dmg", "targetname");

	dmg delete();
	trap delete();
}

trap6()
{
	trap = getent("trap6", "targetname");
	dmg = getent("trap6_dmg", "targetname");
	trig = getent("trap6_trig", "targetname");

	dmg delete();
	trap delete();	
}

trap7()
{
	trig = getent("trap7_trig", "targetname");
	csirke = getent ("csirke", "targetname");

	trig waittill ("trigger");
	trig delete();
	csirke PlaySound ("csirke");

	wait 0.7;
	csirke PlaySound ("csirke2");
	PlayFX( level.chicken_fx, csirke.origin );
	RadiusDamage( csirke.origin, 135, 150, 70);
	Earthquake( 2, 1, csirke.origin, 250);
	csirke delete();
}

trap8()
{
	trig = getent("trap8_trig", "targetname");
	point = getent("smoke", "targetname");
	dmg = getent("trap8_dmg", "targetname");
	fxObj1 = SpawnFx( level.afterburn_fx, point.origin);

	dmg delete();
		
}

trap9()
{
	trap = getent("trap9", "targetname");
	trig = getent("trap9_trig", "targetname");

	trig waittill ("trigger");
	trig delete();
	trap PlaySound ("elevator_down");
	trap movex ( -221, 0.5);
	wait 4;
	trap PlaySound ("elevator_down");
	trap movex ( 221, 0.5);
}

trap10()
{
	trig = getent("trap10_trig", "targetname");
	dmg = getent("trap10_dmg", "targetname");
	trap = getent("trap10", "targetname");

	trap delete();
	dmg delete();
}

trap11()
{
	trig = getent("trap11_trig", "targetname");
	dmg = getent("trap11_dmg", "targetname");
	fire1 = getent("fire1", "targetname");
	fire2 = getent("fire2", "targetname");
	fire3 = getent("fire3", "targetname");
	fire4 = getent("fire4", "targetname");
	fire5 = getent("fire5", "targetname");
	fire6 = getent("fire6", "targetname");
	fire7 = getent("fire7", "targetname");
	fire8 = getent("fire8", "targetname");


	dmg delete();

}

trap13()
{
	trig =getent("trap13_trig", "targetname");
	trap =getent("plate", "targetname");
	tele =getent("upper_tele", "targetname");
	tele2 =getent("down_tele", "targetname");
	dmg =getent("plate_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto(trap);

	trig waittill ("trigger", who);
	trig delete();
	old = who.origin;
	who setorigin (tele.origin);
	who SetPlayerAngles ( (90, 270, 0) );
	//who setClientDvars ( "cg_drawGun", 0 );
	who AllowJump(false);
	who AllowSprint(false);
	wait 0.1;
	trap linkto(who);
	tele2 waittill ("trigger", who);
	trap unlink();
	who setorigin (old);
	who AllowJump(true);
	who AllowSprint(true);
	//who setClientDvars ( "cg_drawGun", 1 );
}

trap14()
{
	trig =getent("trap14_trig", "targetname");
	trap =getent("trap14", "targetname");
	lamp =getent("trap14_lamp", "targetname");

	lamp hide();

	trig waittill ("trigger");
	trig delete();

	trap PlaySound ("stuck");
	lamp show();
	trap notsolid();

	wait 5;
	trap PlaySound ("stuck");
	lamp hide();
	trap solid();
}

trap15()
{
	trig =getent("trap15_trig", "targetname");
	trap =getent("trap15", "targetname");

	trig waittill ("trigger");
	trig delete();
	trap notsolid();

	wait 5;
	trap solid();
}

trap16()
{
	trig = getent("trap16_trig", "targetname");
	trap = getent("trap16", "targetname");
	trap1 = getent("trap16_1", "targetname");

	trig waittill ("trigger");
	trig delete();

	trap1 notsolid();
	trap movex (-280,0.5);
	trap PlaySound ("th3");

	
	wait 5;
	trap1 solid();
	trap movex (280,0.5);
	trap PlaySound ("th3");

}

trap17()
{
	trap1 = getEnt( "trap17_1", "targetname" );
	trap2 = getEnt( "trap17_2", "targetname" );
	trig = getEnt( "trap17_trig", "targetname" );


	trig waittill( "trigger");
	trig delete();


	x = RandomInt(100);
		if( x < 50 )
		{
		trap1 PlaySound ("metal_break");
		PlayFX( level.break_fx, trap1.origin );
		wait 0.1;
		trap1 delete();
		}
		if( x > 49  )
		{
		trap2 PlaySound ("metal_break");
		PlayFX( level.break_fx, trap2.origin );
		wait 0.1;
		trap2 delete();
		}
}

trap18()
{
	trap = getEnt( "trap18", "targetname" );
	trig = getEnt( "trap18_trig", "targetname" );
	dmg =getent("trap18_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto(trap);
	
	trap PlaySound ("th1");
	trap movez (180,0.1);

	trig waittill ("trigger");
	trig delete();

	trap movez (-180, 0.2);
	wait 0.2;
	trap PlaySound ("glass");
	trap PlaySound ("th2");
	Earthquake( 2, 1, trap.origin, 250);
}

final()
{
	trig = getEnt( "final", "targetname" );
	door = getEnt( "finaldoor1", "targetname" );

	trig waittill ("trigger", who);
	iprintlnbold ("NICE" + ", " + "^2"+ who.name + "^7 FINISHED FIRST!");
	who GiveWeapon( "uzi_mp" );
	wait 0.01;
	who SwitchToWeapon( "uzi_mp" );
	trig delete();
	thread final_check();
	door playsound ("door_start");
	door movez ( -128,0.5);
	wait 0.5;
	door playsound ("door_close");
}

final_check()
{
	level endon ("check_stop");
	door = getent("finaldoor2","targetname");
	while(true)
	{
		if( getTeamPlayersAlive("allies") == 1 )
		{
		door playsound ("door_start");
		door movez ( -128,0.5);
		wait 0.5;
		door playsound ("door_close");
		level notify ("check_stop");
		}
		wait 5;
	}
}

final_tele1()
{
	trig = getent ("final_tele1","targetname");
	spawn = getent ("spawn","targetname");

	while (1)
	{
	trig waittill ("trigger",player);
	//player FreezeControls(1);
	player setorigin ( spawn.origin );
	player SetPlayerAngles ( (0,0,0) );
	player GiveWeapon("frag_grenade_mp");
	player GiveWeapon("tomahawk_mp");
	player SwitchToWeapon("tomahawk_mp");
	//wait 0.01;
	//player GiveMaxAmmo ("frag_grenade_mp");
	}
}

final_tele2()
{
	trig = getent ("final_tele2","targetname");
	trig waittill ("trigger");
	thread final_nade();
}

final_nade()
{
	acti = undefined;
	jumper = undefined;
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "axis" && isAlive(players[i]) )
		{
			acti = players[i];
			break;
		}
	}
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "allies" && isAlive(players[i]) )
		{
			jumper = players[i];
			break;
		}
	}
	
	startj = getent("final_jump", "targetname");
	starta = getent("final_acti", "targetname");
	
	jumper SetPlayerAngles( startj.angles );
	jumper SetOrigin( startj.origin );
	jumper SetMoveSpeedScale( 1 );
	jumper TakeAllWeapons();
	jumper GiveWeapon("deserteagle_mp");
	jumper SetSpawnWeapon("deserteagle_mp");
	acti SetPlayerAngles( starta.angles );
	acti SetOrigin( starta.origin );
	acti SetMoveSpeedScale( 1 );
	acti TakeAllWeapons();
	acti GiveWeapon("deserteagle_mp");
	acti SetSpawnWeapon("deserteagle_mp");

	wait 0.1;
	jumper FreezeControls(1);
	acti FreezeControls(1);

	
	wait 2;
	
	
	noti = SpawnStruct();
	noti.titleText = "^1!!!^7FINAL ^11VS1 ^7 GRENADE FIGHT^1!!!";
	noti.notifyText = acti.name + " ^1VS ^7" + jumper.name;
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	
	wait 5;
	jumper FreezeControls(0);
	acti FreezeControls(0);
	
	iprintlnbold("^1GOOD LUCK!");
}

//////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

addtrapstofreerun()
{
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap5_trig");
	addTriggerToList("trap6_trig");
	addTriggerToList("trap7_trig");
	addTriggerToList("trap8_trig");
	addTriggerToList("trap9_trig");
	addTriggerToList("trap10_trig");
	addTriggerToList("trap11_trig");
	addTriggerToList("trap12_trig");
	addTriggerToList("trap13_trig");
	addTriggerToList("trap14_trig");
	addTriggerToList("trap15_trig");
	addTriggerToList("trap16_trig");
	addTriggerToList("trap17_trig");
	addTriggerToList("trap18_trig");
}

//////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////////