main()
{
thread sr\api\_map::createSpawnOrigin((4160, -192, -1551.875), 90);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (948.234, 2095.15, -2159.88), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
	maps\mp\_load::main();
 	// ambientPlay("ambient1");

	level.fire = loadFX("fire/firelp_barrel_pm");
	level.java = loadFX("explosions/belltower_explosion");
	level.flare = loadFX("deathrun/flare");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	// level.dvar["time_limit"]=4.5;
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	SetDvar( "env_fog", "1" );
	SetDvar( "env_fog_start_distance", "200" );
	SetDvar( "env_fog_half_distance", "480" );
	setdvar("compassmaxrange","1800");

	setExpFog(100, 1000, 0.2, 0.25, 0.5, 0.0);

	thread way_connect();
	thread secret_door();
	thread secret_teleport1();
	thread secret_teleport2();
	// thread music();
	thread begin();
	// thread music2();
	// thread music3();
	thread teleport1();
	thread teleport2();
	thread teleport3();
	thread teleport4();
	thread teleport5();
	thread teleport6();
	thread teleport7();
	thread teleport8();
	thread teleport9();
	thread teleport10();
	thread teleport11();

	// thread trap1();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();

	thread umbrella();

	// thread old();
	// thread old2();
	// thread sniper();
	// thread knife();
	// thread bounce();
	thread end_fly();
	// thread jumproom();
	// thread addTestClients();


////Trigger-List////

	// addTriggerToList( "trap1_trigger" );
	// addTriggerToList( "trap3_trigger" );
	// addTriggerToList( "trap4_trigger" );
	// addTriggerToList( "trap5_trigger" );
	// addTriggerToList( "trap6_trigger" );
	// addTriggerToList( "trap7_trigger" );
	// addTriggerToList( "trap8_trigger" );
	// addTriggerToList( "trap9_trigger" );
	// addTriggerToList( "trap10_trigger" );
	// addTriggerToList( "trap11_trigger" );
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


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


	secret_door()
{
	trig = getEnt ("trigger_door", "targetname");
	dor = getEnt ("door_brush", "targetname");
{
	wait 0.5;
	dor moveZ ( 114, 0.5 );
}
}
	secret_teleport1()
{
	trig = getEnt ("trigger_secret", "targetname");
	target = getEnt ("target_secret", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
}
}


	secret_teleport2()
{
	trig = getEnt ("trigger_out", "targetname");
	target = getEnt ("target_out", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}

	music()
{
	trig = getEnt ("trigger_music1", "targetname");
{
	trig waittill ("trigger", player );

	AmbientStop( 2 );

	wait 1 ;

	AmbientPlay( "ambient2" );
	trig delete();
}
}

	music2()
{
	trig = getEnt ("trigger_music2", "targetname");
{
	trig waittill ("trigger", player );

	AmbientStop( 2 );
	player GiveWeapon( "m40a3_mp" );
	wait 1 ;
	player switchToWeapon( "m40a3_mp" );
	AmbientPlay( "ambient3" );
	trig delete();
}
}

	music3()
{
	trig = getEnt ("music3_trigger", "targetname");
{
	trig waittill ("trigger", player );

	AmbientStop( 2 );

	wait 1 ;

	AmbientPlay( "ambient5" );
	trig delete();
}
}


begin()
{
	door = getEnt ("begin_door", "targetname");
	fx = getEnt ("begin_flare", "targetname");

{
	wait 0.1 ;
	playFx(level.flare, fx.origin);
	door moveZ ( -160, 0.1 );
}
}

teleport1()
{
	trig = getEnt ("teleport1_trigger", "targetname");
	target = getEnt ("teleport1_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}


teleport2()
{
	trig = getEnt ("teleport2_trigger", "targetname");
	target = getEnt ("teleport2_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport3()
{
	trig = getEnt ("teleport3_trigger", "targetname");
	target = getEnt ("teleport3_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}


teleport4()
{
	trig = getEnt ("teleport4_trigger", "targetname");
	target = getEnt ("teleport1_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}


teleport5()
{
	trig = getEnt ("teleport5_trigger", "targetname");
	target = getEnt ("teleport4_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}

teleport6()
{
	trig = getEnt ("teleport6_trigger", "targetname");
	target = getEnt ("teleport2_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}

teleport7()
{
	trig = getEnt ("teleport7_trigger", "targetname");
	target = getEnt ("teleport7_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}


teleport8()
{
	trig = getEnt ("teleport8_trigger", "targetname");
	target = getEnt ("teleport8_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}

teleport9()
{
	trig = getEnt ("teleport9_trigger", "targetname");
	target = getEnt ("teleport9_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}

teleport10()
{
	trig = getEnt ("teleport10_trigger", "targetname");
	target = getEnt ("teleport7_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}

teleport11()
{
	trig = getEnt ("teleport11_trigger", "targetname");
	target = getEnt ("teleport3_target", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	}
	}


umbrella()
{
	trig = getEnt ("umbrella_trigger", "targetname");
	door = getEnt ("umbrella_door", "targetname");
{
	trig waittill ("trigger", player );

	door moveZ ( 100, 5 );

}
}


	trap1()
{
    trig = getEnt( "trap1_trigger", "targetname" );
    brush = getEnt( "trap1_brush", "targetname" );
{
	trig waittill ("trigger", player );

	brush delete();

	trig delete();
}
}

trap3()
{
    trig = getEnt( "trap3_trigger", "targetname" );
    brush = getEnt( "trap3_brush", "targetname" );

	trig waittill ("trigger", player );
{
	trig delete();

	brush rotatepitch (360,2);
}
}


trap4()
{
    trig = getEnt( "trap4_trigger", "targetname" );
    brush = getEnt( "trap4_brush", "targetname" );
{
	trig waittill ("trigger", player );

	trig delete();

	brush moveY( 384, 3 );

	brush waittill("movedone");

	brush moveZ( -600, 3 );

	brush waittill("movedone");

	brush delete();
}
}

trap5()
{
    trig = getEnt( "trap5_trigger", "targetname" );
    brush = getEnt( "trap5_brush", "targetname" );

	trig waittill( "trigger" );

	while(1)
{
	trig delete();

	brush moveZ( 64, 2 );

	wait 2;

	brush moveZ( -64, 2 );

	wait 2;
}
}

	trap6()
{
    trig = getEnt( "trap6_trigger", "targetname" );
	brush1 = getEnt( "tarp6_brush1", "targetname" );
	brush2 = getEnt( "tarp6_brush2", "targetname" );
	brush3 = getEnt( "tarp6_brush3", "targetname" );
	brush4 = getEnt( "tarp6_brush4", "targetname" );

	fx1 = getEnt( "trap6_origin1", "targetname" );
	fx2 = getEnt( "trap6_origin2", "targetname" );
	fx3 = getEnt( "trap6_origin3", "targetname" );
	fx4 = getEnt( "trap6_origin4", "targetname" );
{
	trig waittill ("trigger", player );
	trig delete();
	brush1 delete();
	fx1 playsound("explo");
	playFx(level.java, fx1.origin);
	wait 1.5;
	brush2 delete();
	fx2 playsound("explo");
	playFx(level.java, fx2.origin);
	wait 1.5;
	brush3 delete();
	fx3 playsound("explo");
	playFx(level.java, fx3.origin);
	wait 1.5;
	brush4 delete();
	fx4 playsound("explo");
	playFx(level.java, fx4.origin);
	wait 1.5;
}
}

trap7()
{
    trig = getEnt( "trap7_trigger", "targetname" );
    brush = getEnt( "trap7_brush", "targetname" );

	trig waittill( "trigger" );

	while(1)
{
	trig delete();
	brush rotateyaw (720,3);
	brush waittill ("rotatedone");
	wait 4 ;
}
}

trap8()
{
    trig = getEnt( "trap8_trigger", "targetname" );
    brush = getEnt( "trap8_brush", "targetname" );
{
	trig waittill ("trigger", player );

	trig delete();

	brush movey( -20, 2 );

	wait 6;

	brush movey( 20, 2 );
}
}

trap9()
{
    trig = getEnt( "trap9_trigger", "targetname" );
    brush1 = getEnt( "trap9_brush1", "targetname" );
    brush2 = getEnt( "trap9_brush2", "targetname" );
    brush3 = getEnt( "trap9_brush3", "targetname" );

	trig waittill ("trigger", player );
	while(1)
	{
	trig delete();

	brush1 rotateyaw (720,4);
	brush2 rotateyaw (720,4);
	brush3 rotateyaw (720,4);
	brush1 waittill ("rotatedone");
	brush1 rotateyaw (-720,4);
	brush2 rotateyaw (-720,4);
	brush3 rotateyaw (-720,4);
	brush1 waittill ("rotatedone");

}
}

trap10()
{
	brush = getent ("trap10_brush1", "targetname");
	trig = getent ("trap10_trigger", "targetname");

	trig waittill("trigger");
	while(1)
{
	trig SetHintString("^9Activated");
	brush rotatepitch (720,4);
	wait 0.5;
}
}

trap11()
{
	brush = getent ("trap11_brush1", "targetname");
	trig = getent ("trap11_trigger", "targetname");

	trig waittill("trigger");
	while(1)
{
	trig SetHintString("^9Activated");
	brush rotatepitch (720,4);
	wait 0.5;
}
}

old()
{
    trig = getEnt( "old_jumper_trigger2", "targetname" );
	target = getEnt ("teleport8_target", "targetname");

	trig waittill ("trigger", player);
{
	iPrintlnBold( " ^5" + player.name + " ^5 Picked Old^9!" );
	level.activ SetOrigin(target.origin);
	level.activ SetPlayerAngles( target.angles );
	AmbientPlay( "ambient5" );
	trig delete();
}
}

old2()
{
    trig = getEnt( "old_jumper_trigger", "targetname" );
	target = getEnt ("teleport4_target", "targetname");

	del1 = getEnt ("teleport9_trigger", "targetname");
	del2 = getEnt ("teleport5_trigger", "targetname");

	while(1)
{
	trig waittill ("trigger", player);

	del1 delete();
	del2 delete();

    level.knife delete();
    level.bounce delete();
    level.sniper delete();

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}



sniper()
{
level.sniper = getent( "sniper_trigger", "targetname");
level.jsnipe = getEnt( "jumper_sniper_target", "targetname" );
level.asnipe = getEnt( "acti_sniper_target", "targetname" );

level.sniper waittill("trigger");
{
players = getentarray("player", "classname");

for(i=0;i<players.size;i++)
{
if(players[i]==level.acti)
{

    level.knife delete();
    level.bounce delete();
    level.old delete();

	AmbientStop( 4 );
	AmbientPlay( "ambient4" );

	level.snipe_trig delete();
    players[i] SetPlayerAngles( level.jsnipe.angles );
    players[i] setOrigin( level.jsnipe.origin );
    level.activ setPlayerangles( level.asnipe.angles );
    level.activ setOrigin( level.asnipe.origin );

    players[i] TakeAllWeapons();
	level.activ TakeAllWeapons();
    players[i] GiveWeapon( "m40a3_mp" );
	players[i] giveweapon( "remington700_mp");
	players[i] SetWeaponAmmoStock( "m40a3_mp", 9999 );
	players[i] SetWeaponAmmoStock( "remington700_mp", 9999 );
    level.activ GiveWeapon( "m40a3_mp" );
	level.activ giveweapon( "remington700_mp");
	level.activ SetWeaponAmmoStock( "m40a3_mp", 9999 );
	level.activ SetWeaponAmmoStock( "remington700_mp", 9999 );
	players[i] switchToWeapon( "m40a3_mp" );
    level.activ SwitchToWeapon( "m40a3_mp" );
	iPrintlnBold( "^9J^3umper ^9A^3ttack^9!!!" );
}
}
}
}

knife()
{
	level.knife = getEnt( "knife_trigger", "targetname");
    jump = getEnt ("jumper_knife_target", "targetname");
    acti = getEnt ("acti_knife_target", "targetname");

     while(1)
    {
        level.knife waittill( "trigger", player );
        if( !isDefined( level.knife ) )
            return;

        level.sniper delete();
        level.old delete();
        level.bounce delete();

		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

		wait 0.5;
        ambientStop( 1.5 );
        ambientPlay("ambient3");

		player takeallweapons();
		player GiveWeapon( "knife_mp" );
        player SwitchtoWeapon( "knife_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchtoWeapon( "knife_mp" );

        player FreezeControls(1);
		level.activ FreezeControls(1);

		noti = SpawnStruct();
            noti.titleText = "Knife Room";
            noti.notifyText = level.activ.name + " ^9V^3S^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (1.0, 0, 0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
            wait 2;

        wait 5;

        iPrintLnBold("^9F^3ight");

        wait 2;

		player FreezeControls(0);
		level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }
}

bounce()
{
    level.bounce = getEnt( "jump_trigger", "targetname");
    jump = getEnt ("jumper_jump_target", "targetname");
    acti = getEnt ("acti_jump_target", "targetname");

     while(1)
    {
        level.bounce waittill( "trigger", player );
        if( !isDefined( level.bounce ) )
            return;

        level.sniper delete();
        level.old delete();
        level.knife delete();

        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

        wait 0.5;
        ambientStop( 1.5 );
        ambientPlay("ambient7");

        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
        player SwitchtoWeapon( "knife_mp" );

        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchtoWeapon( "knife_mp" );

        player FreezeControls(1);
        level.activ FreezeControls(1);

        noti = SpawnStruct();
            noti.titleText = "Jump Room";
            noti.notifyText = level.activ.name + " ^9V^3S^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (1.0, 0.4, 1.0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
            wait 2;

        iPrintLnBold("^9F^3ight");

        wait 2;

        player FreezeControls(0);
        level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }
}

jumproom()
{
	brush1 = getent ("jumproom_brush3", "targetname");
	brush2 = getent ("jumproom_brush4", "targetname");

	while(1)
	{
	brush1 moveZ(80,3);
	wait 3;
	brush1 moveZ(-80,3);
	brush2 moveZ(80,3);
	wait 3;
	brush2 moveZ(-80,3);
}
}

end_fly()
{
	jumpx = getent ("jump_trig","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		user thread fly();
	}
}

fly()
{
	air1 = getent ("nub1","targetname");
	air2 = getent ("nub2","targetname");
	air3 = getent ("nub3","targetname");
	air4 = getent ("nub4","targetname");
	time = 1;
	//throw = self.origin + (100, 100, 0);
	air = spawn ("script_model",(0,0,0));
	air.origin = self.origin;
	air.angles = self.angles;
	self linkto (air);
	air moveto (air1.origin, time);
	wait 0.5;
	air moveto (air2.origin, time);
	wait 0.5;
	air moveto (air4.origin, time);
	wait 0.5;
	self unlink();
	wait 1;
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