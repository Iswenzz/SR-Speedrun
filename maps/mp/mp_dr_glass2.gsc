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

	Scripts and map made by Rycoon!
|*************************************|
	Xfire: phaedrean
	
	Permission that I am allowed to make v2 of deathrun glass:
	
	AoD'Rycoon: hai m8
	iNext.Mr-X: hi
	AoD'Rycoon: could i have a lil permission from yu?
	iNext.Mr-X: ofc
	AoD'Rycoon: well, i would like to make glass2 
	AoD'Rycoon: for dr
	iNext.Mr-X: ofc
	iNext.Mr-X: u can
*/

main()
{
trigger = spawn("trigger_radius", (3492.48, 3184.86, 32.125), 0, 65, 75);
trigger.targetname = "endmap_trig";
trigger.radius = 65;
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar("compassmaxrange", "4200");
	
	level.bloodFX = LoadFX("deathrun/body_smash");
	level.huge_fanFX = LoadFX("deathrun/huge_fan");
	
	thread way_connect();
	// thread addTestClients();
	thread WatchGame();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

WatchGame()
{
	thread StartDoor();
	// thread GetTraps();
	thread GetBloodyTriggers();
	thread GetEndDoor();
}

GetBloodyTriggers()
{
	trig = getentarray("bloody_trigger", "targetname");
	for(i=0;i<trig.size;i++)
		trig[i] thread BloodyTrigger(1);
}

GetEndDoor()
{
	door = getEnt("end_door", "targetname");
	trig = getEnt("end_door_trig", "targetname");
	
	wait 0.05;
	
	door RotateYaw( 105, 2, 0.5, 0.5 );
}

StartDoor()
{
	trig = getent("trigger_startdoor", "targetname");
	
	wait 0.05;
	
	door = getent("startdoor", "targetname");
	door MoveZ( 134, 4, 0.5, 0.1 );
}

GetTraps()
{
	level.trapTriggers[0] = GetEnt("trigger_trap1", "targetname");
	level.trapTriggers[1] = GetEnt("trigger_trap2", "targetname");
	level.trapTriggers[2] = GetEnt("trigger_trap3", "targetname");
	level.trapTriggers[3] = GetEnt("trigger_trap4", "targetname");
	level.trapTriggers[4] = GetEnt("trigger_trap5", "targetname");
	level.trapTriggers[5] = GetEnt("trigger_trap6", "targetname");
	level.trapTriggers[6] = GetEnt("trigger_trap7", "targetname");
	level.trapTriggers[7] = GetEnt("trigger_trap8", "targetname");
	level.trapTriggers[8] = GetEnt("trigger_trap9", "targetname");
	level.trapTriggers[9] = GetEnt("trigger_trap11", "targetname");
	wait 0.1;
	if( level.freeRun )
	{
		for(i=0;i<level.trapTriggers.size;i++)
			level.trapTriggers[i] delete();
	}
	
	level.trapTriggers[0] thread DoTrap1();
	level.trapTriggers[1] thread DoTrap2();
	level.trapTriggers[2] thread DoTrap3();
	level.trapTriggers[3] thread DoTrap4();
	level.trapTriggers[4] thread DoTrap5();
	level.trapTriggers[5] thread DoTrap6();
	level.trapTriggers[6] thread DoTrap7();
	level.trapTriggers[7] thread DoTrap8();
	level.trapTriggers[8] thread DoTrap9();
	level.trapTriggers[9] thread DoTrap11();
}

DoTrap1()
{
	doora = getEnt("trap1_a", "targetname");
	doorb = getEnt("trap1_b", "targetname");
	
	self waittill("trigger");
	self delete();
	
	doora RotatePitch( 90, 0.5, 0.25, 0.25 );
	doorb RotatePitch( -90, 0.5, 0.25, 0.25 );
	
	wait 3;
	
	doora RotatePitch( -90, 0.5, 0.25, 0.25 );
	doorb RotatePitch( 90, 0.5, 0.25, 0.25 );
}

DoTrap2()
{
	spikes = getEnt("trap2_spikes", "targetname");
	smasher = getEnt("trap2_smasher", "targetname");
	
	spikes.oldpos = spikes.origin;
	spikes_trig = getEnt("trap2_spikes_trig", "targetname");
	spikes_trig EnableLinkTo();
	spikes_trig LinkTo( spikes );
	spikes_trig thread BloodyTrigger(1);
	smasher.oldpos = smasher.origin;
	smasher_trig = getEnt("trap2_smasher_trig", "targetname");
	smasher_trig EnableLinkTo();
	smasher_trig LinkTo( smasher );
	smasher_trig thread BloodyTrigger(2);
	
	self waittill("trigger");
	self delete();
	
	spikes MoveZ( 48, 0.5, 0.5, 0 );
	smasher MoveZ( -240, 0.5, 0.5, 0 );
	smasher PlayLoopSound("stonemove_fast");
	wait 0.5;
	smasher StopLoopSound();
	smasher PlaySound("ironimpact");
	
	wait 3;
	
	spikes MoveTo( spikes.oldpos, 1, 0.5, 0.5 );
	smasher MoveTo( smasher.oldpos, 2, 1, 1 );
}

DoTrap3()
{
	inside = getEnt("trap3_inside", "targetname");
	outside = getEnt("trap3_outside", "targetname");
	
	inside NotSolid();
	
	self waittill("trigger");
	self delete();
	
	inside Solid();
	outside NotSolid();
}

DoTrap4()
{
	platform1 = getEnt("trap4_platform1", "targetname");
	platform2 = getEnt("trap4_platform2", "targetname");
	platform3 = getEnt("trap4_platform3", "targetname");
	
	self waittill("trigger");
	self delete();
	
	platform1 thread MovePlatformRandom( -256 );
	platform2 thread MovePlatformRandom( 256 );
	platform3 thread MovePlatformRandom( -256 );
}

MovePlatformRandom( amount )
{
	self.oldpos = self.origin;
	wait 0.1;
	while(1)
	{
		time = 2+RandomInt(2);
		self MoveY( amount, time, 0, 0 );
		wait time;
		time = 2+RandomInt(2);
		self MoveTo( self.oldpos, time, 0, 0 );
		wait time;
	}
}

DoTrap5()
{
	hammer = getEnt("trap5_hammer", "targetname");
	
	self waittill("trigger");
	self delete();
	
	while(1)
	{
		hammer RotateRoll( 360, 3, 0, 0 );
		wait 3;
	}
}

DoTrap6()
{
	//392 y
	smasher = getEnt("trap6_smasher", "targetname");
	smasher.oldpos = smasher.origin;
	
	self waittill("trigger");
	self delete();
	
	smasher MoveY( 392, 1, 1, 0 );
	smasher PlayLoopSound("stonemove_fast");
	wait 1;
	smasher StopLoopSound();
	smasher PlaySound("stoneimpact");
	
	wait 2;
	
	smasher MoveTo( smasher.oldpos, 3, 1, 1 );
}

DoTrap7()
{
	//-36 z
	spikes = getEnt("trap7_spikes", "targetname");
	spikes.oldpos = spikes.origin;
	
	spikes_trig = getEnt("trap7_trig", "targetname");
	spikes_trig EnableLinkTo();
	spikes_trig LinkTo( spikes );
	spikes_trig thread BloodyTrigger(1);
	
	self waittill("trigger");
	self delete();
	
	spikes MoveZ( -36, 1, 0.5, 0 );
	wait 3;
	spikes MoveTo( spikes.oldpos, 1, 0.5, 0 );
}

DoTrap8()
{
	rotator = getEnt("trap8_rotator", "targetname");
	
	self waittill("trigger");
	self delete();
	
	while(1)
	{
		rotator RotateRoll( -360, 2.5, 0, 0 );
		wait 1.5;
	}
}

DoTrap9()
{
	block_up = getEntArray("trap9_blocker_up", "targetname");
	for(i=0;i<block_up.size;i++)
		block_up[i].up = true;
	block_down = getEntArray("trap9_blocker_down", "targetname");
	for(i=0;i<block_down.size;i++)
		block_down[i].up = false;
	
	self waittill("trigger");
	self delete();
	
	//z 136
	while(1)
	{
		x = RandomInt( block_up.size );
		if( block_up[x].up )
		{
			block_up[x] MoveZ( -136, 1, 0.5, 0.5 );
			block_up[x].up = false;
		}
		else
		{
			block_up[x] MoveZ( 136, 1, 0.5, 0.5 );
			block_up[x].up = true;
		}
		y = RandomInt( block_down.size );
		if( block_down[y].up )
		{
			block_down[y] MoveZ( -136, 1, 0.5, 0.5 );
			block_down[y].up = false;
		}
		else
		{
			block_down[y] MoveZ( 136, 1, 0.5, 0.5 );
			block_down[y].up = true;
		}
		wait 10+RandomInt(10);
	}
}

DoTrap11()
{
	pusher = getEnt("trap11_pusher", "targetname");
	fan = getEnt("trap11_fan", "targetname");
	fan.online = false;
	fan thread FanPush( pusher );
	fan LinkTo( pusher );
	
	self waittill("trigger");
	self delete();
	
	while(1)
	{
		if( !fan.online )
		{
			pusher RotateRoll( 4500, 10, 1, 1 );
			pusher PlaySound("huge_fan");
			PlayFX( level.huge_fanFX, pusher.origin );
			wait 1;
			fan.online = true;
		}
		else
			fan.online = false;
		wait 10;
	}
}

FanPush( pusher )
{
	while(1)
	{
		if( self.online )
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( pusher CheckPusherHit( players[i] ) )
				{
					players[i].health += 1000;
					players[i] FinishPlayerDamage( pusher, pusher, 1000, 0, "MOD_PROJECTILE", "bh_mp", pusher.origin, AnglesToForward( pusher.angles ), "none", 0 );
				}
			}
		}
		wait 0.1;
	}
}

CheckPusherHit( player )
{
	trace = BulletTrace( self.origin, player GetEye(), true, self);
	trace2 = BulletTrace( self.origin, player.origin, true, self);
	trace3 = BulletTrace( self.origin, player GetTagOrigin("j_spinelower"), true, self);
	
	if( ( isDefined( trace["entity"] ) && trace["entity"] == player ) || ( isDefined( trace2["entity"] ) && trace2["entity"] == player ) || ( isDefined( trace3["entity"] ) && trace3["entity"] == player ) )
		return true;
	else
		return false;
}

BloodyTrigger( count )
{
	self endon("stop_trig");
	
	if( !isDefined( count ) || count < 1 )
		count = 1;
	
	while( isDefined( self ) )
	{
		self waittill("trigger", player );
		for(i=0;i<count;i++)
			PlayFX( level.bloodFX, player GetTagOrigin("j_spinelower") );
		player suicide();
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