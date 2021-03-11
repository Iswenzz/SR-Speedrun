//////////////////////////////////////////////////
////////////| mp_deathrun_underworld |////////////
//////////////////////////////////////////////////
//////////////| map made by Icomar |//////////////
//////////////////////////////////////////////////
///////////////| xFire: icomar727 |///////////////
//////////////////////////////////////////////////
///////////////| Thanks to: Blade |///////////////
//////////////////////////////////////////////////



main()
{

	thread sniper();
	thread knife();
	thread bounce();
	thread deagle();
    thread old();

}

sniper()
{
    level.activ = undefined;

	level.sniper_trigger = getEnt("sniper_room","targetname");
	actiorigin = getEnt("sniperspawn_acti","targetname");
	jumperorigin = getEnt("sniperspawn_jumper","targetname");
	protect = getEnt ("sniper_protect", "targetname");
	target_1 = getEnt ("sniper_effect_1", "targetname");
	target_2 = getEnt ("sniper_effect_2", "targetname");
	target_3 = getEnt ("sniper_effect_3", "targetname");
	
	while(1)
	{
        level.sniper_trigger waittill("trigger", player);
		
		level.knife_trigger delete();
	    level.bounce_trigger delete();
	    level.deagle_trigger delete();
	    level.old_trigger delete();
		
		player SetPlayerAngles( jumperorigin.angles );
		player SetOrigin( jumperorigin.origin );
		level.activ SetPlayerAngles( actiorigin.angles );
		level.activ  SetOrigin( actiorigin.origin );

		player FreezeControls(1);
		level.activ FreezeControls(1);

		wait 0.1;

		player takeallweapons();
		player GiveWeapon( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );
		player GiveMaxAmmo( "remington700_mp" );
		player GiveMaxAmmo( "m40a3_mp" );
        player SwitchtoWeapon( "remington700_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
		level.activ GiveMaxAmmo( "m40a3_mp" );
        level.activ SwitchtoWeapon( "remington700_mp" );

    	noti = SpawnStruct();
			noti.titleText = "^2<< ^3Sniper Room ^2>>";
			noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
			noti.glowcolor = (1.0,0.5,0.0);
			noti.duration = 5;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
				players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		wait 3;
		
		iPrintLnBold ("^2<< ^33 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^32 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^31 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^3Go! ^2>>");
		
		playFx ( level.water, target_1.origin );
		playFx ( level.water, target_2.origin );
		playFx ( level.water, target_3.origin );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);
		
		wait 0.5;
		protect hide();

		iPrintLn("^1>> ^7" + player.name + " choose Sniper");
		while(isAlive(player) && isDefined(player))
		{
			wait 0.1;
			level.sniper_trigger show();
		}
	level.sniper_trigger waittill("trigger", player);
	protect show();
	}
}

knife()
{
    level.activ = undefined;

	level.knife_trigger = getEnt("knife_room","targetname");
	actiorigin = getEnt("knifespawn_acti","targetname");
	jumperorigin = getEnt("knifespawn_jumper","targetname");
	target_1 = getEnt ("knife_effect", "targetname");
	
	while(1)
	{
        level.knife_trigger waittill("trigger", player);
		
		level.sniper_trigger delete();
	    level.bounce_trigger delete();
	    level.deagle_trigger delete();
	    level.old_trigger delete();
		
		player SetPlayerAngles( jumperorigin.angles );
		player SetOrigin( jumperorigin.origin );
		level.activ SetPlayerAngles( actiorigin.angles );
		level.activ  SetOrigin( actiorigin.origin );

		player FreezeControls(1);
		level.activ FreezeControls(1);

		wait 0.1;

		player takeallweapons();
		player GiveWeapon( "knife_mp" );
        player SwitchtoWeapon( "knife_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchtoWeapon( "knife_mp" );

    	noti = SpawnStruct();
			noti.titleText = "^2<< ^3Knife Room ^2>>";
			noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
			noti.glowcolor = (1.0,0.5,0.0);
			noti.duration = 5;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
				players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		wait 3;
		
		iPrintLnBold ("^2<< ^33 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^32 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^31 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^3Go! ^2>>");
		
		playFx ( level.water, target_1.origin );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);

		iPrintLn("^1>> ^7" + player.name + " choose knife");
		while(isAlive(player) && isDefined(player))
		{
			wait 0.1;
			level.knife_trigger show();
		}
	level.knife_trigger waittill("trigger", player);
	}
}

bounce()
{
    level.activ = undefined;

	level.bounce_trigger = getEnt("bounce_room","targetname");
	actiorigin = getEnt("bouncespawn_acti","targetname");
	jumperorigin = getEnt("bouncespawn_jumper","targetname");
	target_1 = getEnt ("bounce_effect_jumper_1", "targetname");
	target_2 = getEnt ("bounce_effect_jumper_2", "targetname");
	target_3 = getEnt ("bounce_effect_jumper_3", "targetname");
	target_4 = getEnt ("bounce_effect_acti_1", "targetname");
	target_5 = getEnt ("bounce_effect_acti_2", "targetname");
	target_6 = getEnt ("bounce_effect_acti_3", "targetname");
	
	while(1)
	{
        level.bounce_trigger waittill("trigger", player);
		
	    level.sniper_trigger delete();
	    level.bounce_trigger delete();
	    level.deagle_trigger delete();
	    level.old_trigger delete();
		
		player SetPlayerAngles( jumperorigin.angles );
		player SetOrigin( jumperorigin.origin );
		level.activ SetPlayerAngles( actiorigin.angles );
		level.activ  SetOrigin( actiorigin.origin );

		player FreezeControls(1);
		level.activ FreezeControls(1);

		wait 0.1;

		player takeallweapons();
		player GiveWeapon( "tomahawk_mp" );
        player SwitchtoWeapon( "tomahawk_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "tomahawk_mp" );
        level.activ SwitchtoWeapon( "tomahawk_mp" );

    	noti = SpawnStruct();
			noti.titleText = "^2<< ^3Bounce Room ^2>>";
			noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
			noti.glowcolor = (1.0,0.5,0.0);
			noti.duration = 5;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
				players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		wait 3;
		
		iPrintLnBold ("^2<< ^33 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^32 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^31 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^3Go! ^2>>");
		
		playFx ( level.water, target_1.origin );
		playFx ( level.water, target_2.origin );
		playFx ( level.water, target_3.origin );
		playFx ( level.water, target_4.origin );
		playFx ( level.water, target_5.origin );
		playFx ( level.water, target_6.origin );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);

		iPrintLn("^1>> ^7" + player.name + " choose bounce");
		while(isAlive(player) && isDefined(player))
		{
			wait 0.1;
			level.bounce_trigger show();
		}
	level.bounce_trigger waittill("trigger", player);
	}
}

deagle()
{
    level.activ = undefined;

	level.deagle_trigger = getEnt("deagle_room","targetname");
	actiorigin = getEnt("deagle_acti","targetname");
	jumperorigin = getEnt("deagle_jumper","targetname");
	target_1 = getEnt ("deagle_effect_1", "targetname");
	target_2 = getEnt ("deagle_effect_2", "targetname");
	target_3 = getEnt ("deagle_effect_3", "targetname");
	
	while(1)
	{
        level.deagle_trigger waittill("trigger", player);
		
		level.knife_trigger delete();
	    level.bounce_trigger delete();
	    level.sniper_trigger delete();
	    level.old_trigger delete();
		
		player SetPlayerAngles( jumperorigin.angles );
		player SetOrigin( jumperorigin.origin );
		level.activ SetPlayerAngles( actiorigin.angles );
		level.activ  SetOrigin( actiorigin.origin );

		player FreezeControls(1);
		level.activ FreezeControls(1);

		wait 0.1;

		player takeallweapons();
		player GiveWeapon( "deserteagle_mp" );
		player GiveWeapon( "deserteaglegold_mp" );
		player GiveMaxAmmo( "deserteagle_mp" );
		player GiveMaxAmmo( "deserteaglegold_mp" );
        player SwitchtoWeapon( "deserteagle_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "deserteagle_mp" );
		level.activ GiveWeapon( "deserteaglegold_mp" );
		level.activ GiveMaxAmmo( "deserteagle_mp" );
		level.activ GiveMaxAmmo( "deserteaglegold_mp" );
        level.activ SwitchtoWeapon( "deserteagle_mp" );

    	noti = SpawnStruct();
			noti.titleText = "^2<< ^3Deagle Room ^2>>";
			noti.notifyText = level.activ.name + " ^2VS^7 " + player.name;
			noti.glowcolor = (1.0,0.5,0.0);
			noti.duration = 5;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
				players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		wait 3;
		
		iPrintLnBold ("^2<< ^33 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^32 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^31 ^2>>");
		wait 1;
		iPrintLnBold ("^2<< ^3Go! ^2>>");
		
		playFx ( level.water, target_1.origin );
		playFx ( level.water, target_2.origin );
		playFx ( level.water, target_3.origin );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);

		iPrintLn("^1>> ^7" + player.name + " choose Deagle");
		iPrintLn("^1>> ^7Deagle room made by ^1Blade");
		while(isAlive(player) && isDefined(player))
		{
			wait 0.1;
			level.deagle_trigger show();
		}
	level.deagle_trigger waittill("trigger", player);
	}
}

old()
{
    level.activ = undefined;

	level.old_trigger = getEnt("old_way","targetname");
	actiorigin = getEnt("old_acti","targetname");
	door_1 = getEnt ("old_door_1", "targetname");
	door_2 = getEnt ("old_door_2", "targetname");
	door = getEnt ("old_door_3", "targetname");
	effect = getEnt ("old_effect", "targetname");
	
	level.old_trigger waittill("trigger", player);
	
	level.knife_trigger delete();
	level.bounce_trigger delete();
	level.deagle_trigger delete();
	level.sniper_trigger delete();
	level.old_trigger delete();
	
	door_1 moveY (-30, 0.5);
	door_2 moveY (-30, 0.5);
	wait 0.2;
	playFx ( level.explosion, effect.origin );
	door_1 moveX (60, 3);
	door_2 moveX (-60, 3);
	door moveZ (-260, 6);
	wait 6;
	door_1 delete();
	door_2 delete();
	door delete();
	wait 0.1;
        
	level.activ SetPlayerAngles( actiorigin.angles );
	level.activ  SetOrigin( actiorigin.origin );

	wait 0.1;

    noti = SpawnStruct();
		noti.titleText = "^2<< ^3Old ^2>>";
		noti.glowcolor = (1.0,0.5,0.0);
		noti.duration = 5;
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	wait 3;


	iPrintLn("^1>> ^7" + player.name + " choose old");
}