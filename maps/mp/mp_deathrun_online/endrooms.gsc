main()
{

	thread jump_weapon();
	thread secret();
	thread jump_1();
	thread jump_2();
	thread jump_3();
	thread jump_4();
	thread jump_5();
	thread jump_6();
	thread letters_rotate();
	thread endroom_jump();
	thread jump_respawn();
	thread endroom_snipe();
	thread endroom_knife();
	thread endroom_old();
}

brunnen()
{
	brunnen = getEnt ( "brunnen_1", "targetname" );
	
	playFx ( level.brunnen, brunnen.origin );
}

bouncer(who)
{
	oldpos = who.origin;
    playFx ( level.bounce, who.origin );
	strenght = 3;
	for(i=0;i<strenght;i++)
	{
	    who.health += 170;
        who finishPlayerDamage(who, level.jumpattacker, 170, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	}
}

bouncer_2(who)
{
	oldpos = who.origin;
	strenght = 1;
	for(i=0;i<strenght;i++)
	{
	    who.health += 100;
        who finishPlayerDamage(who, level.jumpattacker, 100, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	}
}

tree()
{
	target = getEnt ( "sniper_tree", "targetname" );
	
	while(1)
	{
		target rotateRoll ( 1, 7);
		wait 7;
		target rotateRoll ( -1, 7);
		wait 7;
	}
}

jump_weapon()
{
	level.jump_trigger = getEnt ( "jump_weapon", "targetname" );
	level.jump_clip = getEnt ( "jump_weapon_clip", "targetname" );
	
	level.jump_trigger enableLinkTo();
	level.jump_trigger LinkTo ( level.jump_clip );
	
	level.Jump_clip moveZ ( 300, 1);
	
	while(1)
	{
		level.jump_trigger waittill ( "trigger", player );
		
		level.Jump_clip moveZ ( 300, 0.5);
	
		player TakeAllWeapons();
		wait 0.05;
	
		if ( RandomIntRange ( 1, 101) > 50 )
		{
			for ( i = 1; i < 5; i++ )
			{
				player giveWeapon ( "remington700_mp" );
				player giveWeapon ( "deserteaglegold_mp" );
				player giveMaxAmmo ( "remington700_mp" );
				player giveMaxAmmo ( "deserteaglegold_mp" );
				player switchToWeapon ( "remington700_mp" );
				wait 0.5;
			}
		}
		else
		{
			for ( i = 5; i < 9; i++ )
			{
				player giveWeapon( "ak47_acog_mp" );
				player giveMaxAmmo( "ak47_acog_mp" );
				player switchToWeapon ( "ak47_acog_mp" );
				wait 0.5;
			}
		}
		wait 0.05;
	}
}

secret()
{
	trigger = getEnt ( "secret_bouncer", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer_2(who);
	}
}

jump_1()
{
	trigger = getEnt ( "jump_1", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer(who);
	}
}

jump_2()
{
	trigger = getEnt ( "jump_2", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer(who);
	}
}

jump_3()
{
	trigger = getEnt ( "jump_3", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer(who);
	}
}

jump_4()
{
	trigger = getEnt ( "jump_4", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer(who);
	}
}

jump_5()
{
	trigger = getEnt ( "jump_5", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer(who);
	}
}

jump_6()
{
	trigger = getEnt ( "jump_6", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", who );
		thread bouncer(who);
	}
}

letters_rotate()
{
	k = getEnt ( "endroom_k", "targetname" );
	s = getEnt ( "endroom_s", "targetname" );
	j = getEnt ( "endroom_j", "targetname" );
	
	while(1)
	{
		k rotateYaw ( 360, 6);
		s rotateYaw ( 360, 6);
		j rotateYaw ( 360, 6);
		wait 6;
	}
}

endroom_jump()
{
    level.jump = getent ( "endroom_jump_trigger", "targetname" );
	level.acti_respawn = getent ("jump_acti_respawn","targetname");
	level.jumper_respawn = getent ("jump_jumper_respawn","targetname");
	
	while( 1 )
    {
        level.jump waittill( "trigger", player );
        if( !isDefined( level.jump ) )
            return;
			
		level.old delete();
		level.snipe delete();
		level.knife delete();
			
		player freezeControls(1);
		level.activ freezeControls(1);
			
		iPrintlnBold( " ^2" + player.name + " ^7 has choosen the jump room" );
		level.Jump_clip moveZ ( -300, 1);
        
        player setOrigin( level.jumper_respawn.origin );
		player setPlayerangles( level.jumper_respawn.angles );
		
		player TakeAllWeapons();
		wait 0.05;
		player GiveWeapon( "knife_mp" );
		
		level.activ setOrigin( level.acti_respawn.origin );
		level.activ setPlayerangles( level.acti_respawn.angles );	
		
		level.activ TakeAllWeapons();
		wait 0.05;
		level.activ GiveWeapon( "knife_mp" );
		
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ switchToWeapon( "knife_mp" );
		
		wait 0.05;
		player iPrintlnBold( " ^2[^73^2]" );
		wait 1.5;
		player iPrintlnBold( " ^2[^72^2]" );
		wait 1.5;
		player iPrintlnBold( " ^2[^71^2]" );
		wait 2;
		player iPrintlnBold( " ^2[^7GO !!!^2]" );
		
		player freezeControls(0);
		level.activ freezeControls(0);
		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
    }
    wait 0.05;
}

jump_respawn()
{
	trigger = getent ( "jump_respawn", "targetname" );
	for(;;)
	{
		trigger waittill ( "trigger", player );
	
		if( player.pers[ "team" ] != "spectator" )
		{
			if( player.pers[ "team" ] == "allies" )
			{
				player SetPlayerAngles ( level.pj.angles );
				player SetOrigin ( level.jumper_respawn.origin );
			}
			if( player.pers[ "team" ] == "axis" )
			{
				player SetPlayerAngles ( level.aj.angles );
				player SetOrigin ( level.acti_respawn.origin );
			}
		}
	}
}

endroom_snipe()
{
    level.snipe = getent ( "endroom_snipe_trigger", "targetname" );
	level.snipe_acti_respawn = getent ("snipe_acti_respawn","targetname");
	level.snipe_jumper_respawn = getent ("snipe_jumper_respawn","targetname");
	
	while( 1 )
    {
        level.snipe waittill( "trigger", player );
        if( !isDefined( level.snipe ) )
            return;
			
		level.jump delete();
		level.old delete();
		level.knife delete();
		
		player freezeControls(1);
		level.activ freezeControls(1);
		wait 0.5;
		iPrintlnBold( " ^2" + player.name + " ^7 has choosen the snipe room" );
		
		while(1)
		{
			thread tree();
				break;
		}
        
        player setOrigin( level.snipe_jumper_respawn.origin );
		player setPlayerangles( level.snipe_jumper_respawn.angles );
		
		player TakeAllWeapons();
		wait 0.05;
		player GiveWeapon( "m40a3_mp" );
		player GiveWeapon( "remington700_mp" );
		player GiveMaxAmmo( "m40a3_mp" );
		player GiveMaxAmmo( "remington700_mp" );
		
		level.activ setOrigin( level.snipe_acti_respawn.origin );
		level.activ setPlayerangles( level.snipe_acti_respawn.angles );	
		
		level.activ TakeAllWeapons();
		wait 0.05;
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo( "m40a3_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
		
		wait 0.05;
		player switchToWeapon( "m40a3_mp" );
		level.activ switchToWeapon( "m40a3_mp" );
		
		wait 0.05;
		player iPrintlnBold( " ^2[^73^2]" );
		wait 1.5;
		player iPrintlnBold( " ^2[^72^2]" );
		wait 1.5;
		player iPrintlnBold( " ^2[^71^2]" );
		wait 2;
		player iPrintlnBold( " ^2[^7GO !!!^2]" );
		
		player freezeControls(0);
		level.activ freezeControls(0);
		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
    }
    wait 0.05;
}

endroom_knife()
{
    level.knife = getent ( "endroom_knife_trigger", "targetname" );
	level.knife_acti_respawn = getent ("knife_acti_respawn","targetname");
	level.knife_jumper_respawn = getent ("knife_jumper_respawn","targetname");
	
	while( 1 )
    {
        level.knife waittill( "trigger", player );
        if( !isDefined( level.knife ) )
            return;
			
		level.jump delete();
		level.snipe delete();
		level.old delete();
			
		player freezeControls(1);
		level.activ freezeControls(1);
		
		while(1)
		{
			thread brunnen();
				break;
		}
			
		iPrintlnBold( " ^2" + player.name + " ^7 has choosen the knife room" );
        
        player setOrigin( level.knife_jumper_respawn.origin );
		player setPlayerangles( level.knife_jumper_respawn.angles );
		
		player TakeAllWeapons();
		wait 0.05;
		player GiveWeapon( "knife_mp" );
		
		level.activ setOrigin( level.knife_acti_respawn.origin );
		level.activ setPlayerangles( level.knife_acti_respawn.angles );	
		
		level.activ TakeAllWeapons();
		wait 0.05;
		level.activ GiveWeapon( "knife_mp" );
		
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ switchToWeapon( "knife_mp" );
		
		wait 0.05;
		player iPrintlnBold( " ^2[^73^2]" );
		wait 1.5;
		player iPrintlnBold( " ^2[^72^2]" );
		wait 1.5;
		player iPrintlnBold( " ^2[^71^2]" );
		wait 2;
		player iPrintlnBold( " ^2[^7GO !!!^2]" );
		
		player freezeControls(0);
		level.activ freezeControls(0);
		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
    }
    wait 0.05;
}

endroom_old()
{
	level.old = getEnt ( "endroom_old_trigger", "targetname" );
	target_1 = getEnt ( "endroom_old_door_1", "targetname" );
	blocker = getEnt ( "endroom_old_blocker", "targetname" );
	
	level.old waittill ( "trigger", player );
	level.old delete();
	
	level.jump delete();
	level.snipe delete();
	level.knife delete();
	
	iPrintlnBold( " ^2" + player.name + " ^7 has choosen the old way" );
	
	blocker delete();
	target_1 moveZ ( -100, 4, 2, 0.5);
	wait 0.5;
	thread endroom_old_ground();
	wait 3.5;
}

endroom_old_ground()
{
	target = getEnt ( "endroom_old_ground", "targetname" );
	target_1 = getEnt ( "endroom_old_door_2", "targetname" );
	
	target moveZ ( -144, 4);
	target_1 moveZ ( -100, 4, 2, 0.5);
	wait 4;
}