main()
{
thread sr\api\_map::createSpawn((214, -468, -512), 90);
maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";
 
    setdvar( "r_specularcolorscale", "1" );
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
    setdvar( "compassmaxrange", "1800" );
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

   thread startdoor();
   thread bounce();
   thread endmap();
   thread bounce_scrt();
   thread secfinish();
   thread trap3();
   thread trap1();
   thread trap2();
   thread trap4();
   thread trap5();
   thread trap6();
   thread secret_wall1();
   thread secret_wall2();
   thread secret_wall3();
   thread secret_brick();
   thread endrotate();

      thread sr\api\_speedrun::createNormalWays("Normal Way;");
   thread sr\api\_speedrun::createSecretWays("Secret Way;");
   thread sr\api\_speedrun::createTeleporter((3175.11, 2667.03, -447.875), 70, 40, (3263, 2035, 284), 270, "freeze", "blue", "normal_0");
   thread sr\api\_speedrun::createTeleporter((-34.6931, -129.408, -511.875), 60, 40, (207,-426,-964), 180, "freeze", "yellow", "secret_0");


}

startdoor()
{
	target = getEnt("start_door", "targetname");
	
	level waittill("round_started");
	
	target delete();
	
}

bounce(player)
{
	trigger = getEnt( "trigger_bounce", "targetname" );
	multiplyer = 3;
	strenght = 180;
	
	while(1)
	{
    	trigger waittill ( "trigger", player );
		
		if (isalive(player) && isdefined(player))
		{
			oldpos = player.origin;
			playFx( level.fx_fire_up, player.origin );
			musicPlay ("jump_pad");
		
			for(i = 0; i < multiplyer; i++)
			{
				player.health += strenght;
				player finishPlayerDamage(player, level.jumpattacker, strenght, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
			}
		}
	}
}

endmap()
{
   trig = getent("endmap_trig", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("normal_0");
    }
}

bounce_scrt(player)
{
	trigger = getEnt( "trigger_bounce_scrt", "targetname" );
	multiplyer = 3;
	strenght = 200;
	
	while(1)
	{
    	trigger waittill ( "trigger", player );
		
		if (isalive(player) && isdefined(player))
		{
			oldpos = player.origin;
		
			for(i = 0; i < multiplyer; i++)
			{
				player.health += strenght;
				player finishPlayerDamage(player, level.jumpattacker, strenght, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
			}
		}
	}
}

secfinish()
{
   trig = getent("toilet_trigger", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}

trap3()
{
	spikes_01 = getEnt( "trap_03_spikes_01", "targetname" );
	spikes_02 = getEnt( "trap_03_spikes_02", "targetname" );
	spikes_01_hurt = getEnt( "trap_03_hurt_01", "targetname" );
	spikes_02_hurt = getEnt( "trap_03_hurt_02", "targetname" );
	
	level waittill("round_started");
	
	spikes_01 delete();
	spikes_02 delete();
	spikes_01_hurt delete();
	spikes_02_hurt delete();
	
}

trap1()
{
	floor = getEnt( "trap_01_obj_01", "targetname" );
	trigger = getEnt( "trap_01_trigger", "targetname" );
	floor moveZ( -16, 1);
	
	trigger sethintstring( "Press ^1[USE]^7 to activate" );
    trigger waittill ( "trigger", player );
	
	trigger sethintstring( "^1ACTIVATED" );
	
	floor moveZ(16, 1);
	wait 1;
	
	floor delete();
}

trap2()
{
	trigger = getEnt( "trap_02_trigger", "targetname" );
	
	fx_origin_01 = getEnt( "trap_02_origin_01", "targetname" );
	fx_origin_02 = getEnt( "trap_02_origin_02", "targetname" );
	
	trigger sethintstring( "Press ^1[USE]^7 to activate" );
    trigger waittill ( "trigger", player );
	
	trigger sethintstring( "^1ACTIVATED" );
	
	fx_origin_01 linkTo(level.obj_01);
	fx_origin_02 linkTo(level.obj_02);
	
	for(i = 0; i < 10; i++)
	{		
		level.obj_01 Hide();
		level.obj_02 Hide();
		level.obj_01 notSolid();
		level.obj_02 notSolid();
		
		wait randomInt(5) + 1;
		
		wait 2;
		
		level.obj_01 Show();
		level.obj_02 Show();
		level.obj_01 Solid();
		level.obj_02 Solid();
		wait randomInt(7) + 2 + i;
	}
}

trap4()
{
	trigger = getEnt( "trap_04_trigger", "targetname" );
	target =getEnt( "trap_04_target", "targetname" );
		
	trigger sethintstring( "Press ^1[USE]^7 to activate" );
    trigger waittill ( "trigger", player );
	
	trigger sethintstring( "^1ACTIVATED" );
	
	while(1)
	{
		target moveY(-352, 4, 1, 3);
		target waittill("movedone");
		target moveY(352, 4, 1, 3);
		target waittill("movedone");
	}
}

trap5()
{
	trigger = getEnt( "trap_05_trigger", "targetname" );
	down = getEnt( "trap_05_down_entity", "targetname" );
	top = getEnt( "trap_05_top_entity", "targetname" );
	
	top moveZ(48, 1);
	down moveZ(-136, 1);
	
	trigger sethintstring( "Press ^1[USE]^7 to activate" );
    trigger waittill ( "trigger", player );
	
	trigger sethintstring( "^1ACTIVATED" );
	
	top moveZ(-48, 3, 1, 2);
	down moveZ(136, 3, 1, 2);
	wait 3;
}

trap6()
{
	trigger = getEnt( "trap_06_trigger", "targetname" );
	pusher = getEnt( "trap_06_pusher", "targetname" );
	
	pusher moveX(272, 1);
	
	trigger sethintstring( "Press ^1[USE]^7 to activate" );
    trigger waittill ( "trigger", player );
	
	trigger sethintstring( "^1ACTIVATED" );
	
	while(1)
	{
		pusher moveX(-272, 3, 2, 1);
		pusher waittill("movedone");
		pusher moveX(272, 3, 1, 2);
		pusher waittill("movedone");
	}
}


secret_wall1()
{
	brick_01 = getEnt( "secret_brick_06", "targetname" );
	brick_02 = getEnt( "secret_brick_07", "targetname" );
	brick_03 = getEnt( "secret_brick_08", "targetname" );
	brick_04 = getEnt( "secret_brick_09", "targetname" );
	
	brick_01 moveY(32, 1);
	brick_02 moveY(16, 1);
	brick_03 moveY(32, 1);
	brick_04 moveY(-48, 1);
	
	
}

secret_wall2()
{
	brick_01 = getEnt( "secret_brick_01", "targetname" );
	brick_02 = getEnt( "secret_brick_02", "targetname" );
	brick_03 = getEnt( "secret_brick_03", "targetname" );
	brick_04 = getEnt( "secret_brick_04", "targetname" );
	brick_05 = getEnt( "secret_brick_05", "targetname" );
	
	brick_01 moveX(-48, 1);
	brick_02 moveX(64, 1);
	brick_03 moveX(-40, 1);
	brick_04 moveX(-48, 1);
	brick_05 moveY(-64, 1);
	
}

secret_wall3()
{
	brick = getEnt( "secret_brick_ac", "targetname" );
	
	brick moveY(16, 1);
	
}

secret_brick()
{
	bricks[0] = getEnt( "find_brick_01", "targetname" );
	bricks[1] = getEnt( "find_brick_02", "targetname" );
	bricks[2] = getEnt( "find_brick_03", "targetname" );
	bricks[3] = getEnt( "find_brick_04", "targetname" );
	bricks[4] = getEnt( "find_brick_05", "targetname" );
	bricks[5] = getEnt( "find_brick_06", "targetname" );
	bricks[6] = getEnt( "find_brick_07", "targetname" );
	bricks[7] = getEnt( "find_brick_08", "targetname" );
	
	bricks[0] moveY(16, 1);
	bricks[1] moveY(16, 1);
	bricks[2] moveX(16, 1);
	bricks[3] moveX(16, 1);
	bricks[4] moveY(-16, 1);
	bricks[5] moveY(-16, 1);
	bricks[6] moveX(-16, 1);
	bricks[7] moveX(-16, 1);
	
}

endrotate()
{
	target = getEnt( "end_rotate", "targetname" );
	
	while(1)
	{
		target rotateYaw(180, 5, 2, 3);
		wait 5.5;
		
		target rotateYaw(180, 5, 2, 3);
		wait 5.5;
	}
}