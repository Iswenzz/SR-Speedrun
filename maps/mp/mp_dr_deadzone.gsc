main()
{

maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "allies";
game["defenders"] = "axis";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setdvar( "r_specularcolorscale", "1" );

level.elevatorDown = true;

thread way_connect();

//Prechacing guns
// precacheItem( "remington700_mp" );
// precacheItem( "m40a3_mp" );
// precacheItem( "rpg_mp" );
// precacheItem( "winchester1200_mp" );
// precacheItem( "ak47_mp" );
// precacheItem( "g36c_reflex_mp" );
// precacheItem( "m14_reflex_mp" );
// precacheItem( "m4_silencer_mp" );
// precacheItem( "m21_acog_mp" );
// precacheItem( "saw_mp" );
// precacheItem( "brick_blaster_mp" );

//Traps
// thread trap1();
// thread trap2();
// thread trap3();
// thread trap4();
// thread trap5();
// thread trap6();

// addTriggerToList( "trap1_trigger", (0,100,20) );
// addTriggerToList( "trap2_trigger", (0,100,20) );
// addTriggerToList( "trap3_trigger", (0,100,20) );
// addTriggerToList( "trap4_trigger", (0,100,20) );
// addTriggerToList( "trap5_trigger", (0,100,20) );
// addTriggerToList( "trap6_trigger", (0,100,20) );

//Rooms

// thread sniper();
// thread sniper_fail();
// thread rpg();
// thread pistol();
// thread old();
// thread jump();
// thread jump_fail_j();
// thread jump_fail_a();
// thread jump_finish_j();
// thread jump_finish_a();
// thread shotgun();
// thread knife();
// thread crazy();

//Other
thread elevator();
thread secret_tp();
thread secret_end();
thread secret_open();
thread secret_fail();
thread fail2();
// thread finish();
// thread song();

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


//Traps
trap1()
{

	trap1 = getEnt ("trap1", "targetname");
	trig = getEnt ("trap1_trigger", "targetname");
	
	trig setHintString("^1USE ^2T^0o ^3A^0ctivate^1!");
	trig waittill("trigger", player);
	trig setHintString("^8Activated^9!");
	trig delete();

		trap1 movez(-640,1);
}

trap2()
{

	trap2 = getEnt ("trap2", "targetname");
	trig = getEnt ("trap2_trigger", "targetname");
	
	trig setHintString("^1USE ^2T^0o ^3A^0ctivate^1!");
	trig waittill("trigger", player);
	trig setHintString("^8Activated^9!");
	trig delete();
	
	while(1)
	{
		trap2 rotateyaw(360,5);
		trap2 waittill("rotatedone");
	}
}

trap3()
{

	trap3 = getEnt ("trap3", "targetname");
	trig = getEnt ("trap3_trigger", "targetname");
	
	trig setHintString("^1USE ^2T^0o ^3A^0ctivate^1!");
	trig waittill("trigger", player);
	trig setHintString("^8Activated^9!");
	trig delete();
	
	while(1)
	{
		trap3 movez (64,0.5);
		trap3 waittill ("movedone");
		trap3 movez (-64,0.5);
		trap3 waittill ("movedone");
		wait 0.5;
	}
}

trap4()
{

	trap4 = getEnt ("trap4", "targetname");
	trig = getEnt ("trap4_trigger", "targetname");
	
	trig setHintString("^1USE ^2T^0o ^3A^0ctivate^1!");
	trig waittill("trigger", player);
	trig setHintString("^8Activated^9!");
	trig delete();

		trap4 movez (128,0.5);
		trap4 waittill ("movedone");
		wait 10;
		trap4 movez (-128,0.5);
		trap4 waittill ("movedone");
}

trap5()
{

	trap5 = getEnt ("trap5", "targetname");
	hurt = getEnt ("trap5_hurt", "targetname");	
	trig = getEnt ("trap5_trigger", "targetname");
	
	hurt enablelinkto(); 
	hurt linkto (trap5);	
	
	trig setHintString("^1USE ^2T^0o ^3A^0ctivate^1!");
	trig waittill("trigger", player);
	trig setHintString("^8Activated^9!");
	trig delete();

		trap5 movez (96,0.5);
		trap5 waittill ("movedone");
		wait 10;
		trap5 movez (-96,0.5);
		trap5 waittill ("movedone");
}

trap6()
{

	trap6 = getEnt ("trap6", "targetname");
	trig = getEnt ("trap6_trigger", "targetname");
	
	trig setHintString("^1USE ^2T^0o ^3A^0ctivate^1!");
	trig waittill("trigger", player);
	trig setHintString("^8Activated^9!");
	trig delete();
	
		trap6 delete();
}

addTriggerToList( name, positionOfIconAboveTrap )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

    if( !isDefined( level.icon_origins ) )
        level.icon_origins = [];
    level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
} 

//Rooms

sniper()
{

	level.final_sniper_trig = getEnt( "final_sniper_trig", "targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );
	level.final_sniper_trig setHintString("^0Sniper ^2Room!");
	

     while(1)
    {
        level.final_sniper_trig waittill( "trigger", player );
        if( !isDefined( level.final_sniper_trig ) )
            return;
        
		//level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		level.final_old_trig delete();
		level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		level.final_crazy_trig delete();
		
		
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" );
        level.activ GiveWeapon( "m40a3_mp" );         
        wait 0.05;
        player switchToWeapon( "remington700_mp" ); 
        level.activ SwitchToWeapon( "remington700_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Sniper Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (1,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

sniper_fail()
{
    trig = getEnt ("sniper_fail_trig", "targetname");
    end = getEnt ("sniper_fail_tp", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

rpg()
{

	level.final_rpg_trig = getEnt( "final_rpg_trig", "targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );
	level.final_rpg_trig setHintString("^0RPG ^2Room!");
	    
     while(1)
    {
		
        level.final_rpg_trig waittill( "trigger", player );
        if( !isDefined( level.final_rpg_trig ) )
            return;
        
		level.final_sniper_trig delete();
		//level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		level.final_old_trig delete();
		level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		level.final_crazy_trig delete();
      
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "rpg_mp" );
		player GiveWeapon( "rpg_mp" );  
		player giveMaxammo("rpg_mp");
		player giveMaxammo("rpg_mp");
		player thread infinite_ammo();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "rpg_mp" );
        level.activ GiveWeapon( "rpg_mp" ); 
		level.activ giveMaxammo("rpg_mp");
		level.activ giveMaxammo("rpg_mp");   
		level.activ thread infinite_ammo();
        wait 0.05;
        player switchToWeapon( "rpg_mp" ); 
        level.activ SwitchToWeapon( "rpg_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "RPG Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

pistol()
{

	level.final_pistol_trig = getEnt( "final_pistol_trig", "targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );
	level.final_pistol_trig setHintString("^0Pistol ^2Room!");
	    
     while(1)
    {
		
        level.final_pistol_trig waittill( "trigger", player );
        if( !isDefined( level.final_pistol_trig ) )
            return;
        
		level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		//level.final_pistol_trig delete();
		level.final_old_trig delete();
		level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		level.final_crazy_trig delete();
      
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "colt45_mp" );
		player GiveWeapon( "colt45_mp" );  
		player giveMaxammo("colt45_mp");
		player giveMaxammo("colt45_mp");		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "colt45_mp" );
        level.activ GiveWeapon( "colt45_mp" ); 
		level.activ giveMaxammo("colt45_mp");
		level.activ giveMaxammo("colt45_mp");        
        wait 0.05;
        player switchToWeapon( "colt45_mp" ); 
        level.activ SwitchToWeapon( "colt45_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Pistol Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

old()
{

	level.final_old_trig = getEnt( "final_old_trig", "targetname");
    jump = getEnt( "old_tp_j", "targetname" );
	acti = getEnt( "old_tp_a", "targetname" );
	level.final_old_trig setHintString("^0Old^2!");
	    
     while(1)
    {
		
        level.final_old_trig waittill( "trigger", player );
        if( !isDefined( level.final_old_trig ) )
            return;
        
		level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		//level.final_old_trig delete();
		level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		level.final_crazy_trig delete();
      
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );	
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Old";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

jump()
{

	level.final_jump_trig = getEnt( "final_jump_trig", "targetname");
    jump = getEnt( "jump_j", "targetname" );
	acti = getEnt( "jump_a", "targetname" );
	level.final_jump_trig setHintString("^0Jump ^2Room!");
	    
     while(1)
    {
		
        level.final_jump_trig waittill( "trigger", player );
        if( !isDefined( level.final_jump_trig ) )
            return;
        
		level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		level.final_old_trig delete();
		//level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		level.final_crazy_trig delete();
      
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );	
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Jump Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

jump_fail_j()
{
    trig = getEnt ("jump_fail_trig_j", "targetname");
    end = getEnt ("jump_j", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

jump_fail_a()
{
    trig = getEnt ("jump_fail_trig_a", "targetname");
    end = getEnt ("jump_a", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

jump_finish_j()
{
	trig = getEnt ("jump_finish_j", "targetname");
	end = getEnt ("sniper_j", "targetname");    
	while(1)
	{
		trig waittill ("trigger", player);
	
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		iprintlnbold("^1" + player.name + " ^2Has finished the ^3Jump Room!");
	}
}

jump_finish_a()
{
	trig = getEnt ("jump_finish_a", "targetname");
	end = getEnt ("sniper_a", "targetname");    
	while(1)
	{
		trig waittill ("trigger", player);
	
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		iprintlnbold("^1Activator ^2Has finished the ^3Jump Room!");
	}
}

shotgun()
{

	level.final_shotgun_trig = getEnt( "final_shotgun_trig", "targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );
	level.final_shotgun_trig setHintString("^0Shotgun ^2Room!");
	    
     while(1)
    {
		
        level.final_shotgun_trig waittill( "trigger", player );
        if( !isDefined( level.final_shotgun_trig ) )
            return;
        
		level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		level.final_old_trig delete();
		level.final_jump_trig delete();
		//level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		level.final_crazy_trig delete();
      
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "winchester1200_mp" );
		player GiveWeapon( "winchester1200_mp" );  
		player giveMaxammo("winchester1200_mp");
		player giveMaxammo("winchester1200_mp");		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "winchester1200_mp" );
        level.activ GiveWeapon( "winchester1200_mp" ); 
		level.activ giveMaxammo("winchester1200_mp");
		level.activ giveMaxammo("winchester1200_mp");        
        wait 0.05;
        player switchToWeapon( "winchester1200_mp" ); 
        level.activ SwitchToWeapon( "winchester1200_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Shotgun Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

knife()
{

	level.final_knife_trig = getEnt( "final_knife_trig", "targetname");
    jump = getEnt( "old_tp_j", "targetname" );
    acti = getEnt( "old_tp_a", "targetname" );
	level.final_knife_trig setHintString("^0Knife ^2Room!");
	    
     while(1)
    {
		
        level.final_knife_trig waittill( "trigger", player );
        if( !isDefined( level.final_knife_trig ) )
            return;
        
		level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		level.final_old_trig delete();
		level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		//level.final_knife_trig delete();
		level.final_crazy_trig delete();
      
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
		player GiveWeapon( "knife_mp" );  
		player giveMaxammo("knife_mp");
		player giveMaxammo("knife_mp");		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );
        level.activ GiveWeapon( "knife_mp" ); 
		level.activ giveMaxammo("knife_mp");
		level.activ giveMaxammo("knife_mp");        
        wait 0.05;
        player switchToWeapon( "knife_mp" ); 
        level.activ SwitchToWeapon( "knife_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Knife Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

crazy()
{

	level.final_crazy_trig = getEnt( "final_crazy_trig", "targetname");
    jump = getEnt( "crazy_j", "targetname" );
    acti = getEnt( "crazy_a", "targetname" );
	level.final_crazy_trig setHintString("^0CRAZY ^2Room!");
	    
     while(1)
    {
		
        level.final_crazy_trig waittill( "trigger", player );
        if( !isDefined( level.final_crazy_trig ) )
            return;
        
		level.final_sniper_trig delete();
		level.final_rpg_trig delete();
		level.final_pistol_trig delete();
		level.final_old_trig delete();
		level.final_jump_trig delete();
		level.final_shotgun_trig delete();
		level.final_knife_trig delete();
		//level.final_crazy_trig delete();
	  
         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		
		level.cgun = [];
		level.cgun[level.cgun.size] = "colt44_mp";
		level.cgun[level.cgun.size] = "remington700_mp";
		level.cgun[level.cgun.size] = "winchester1200_mp";
		level.cgun[level.cgun.size] = "m40a3_mp";
		level.cgun[level.cgun.size] = "colt45_mp";
		level.cgun[level.cgun.size] = "rpg_mp";
		level.cgun[level.cgun.size] = "deserteagle_mp";
		level.cgun[level.cgun.size] = "beretta_mp";
		level.cgun[level.cgun.size] = "ak47_mp";
		level.cgun[level.cgun.size] = "g36c_reflex_mp";
		level.cgun[level.cgun.size] = "m14_reflex_mp";
		level.cgun[level.cgun.size] = "m4_silencer_mp";
		level.cgun[level.cgun.size] = "m21_acog_mp";
		level.cgun[level.cgun.size] = "saw_mp";
		level.cgun[level.cgun.size] = "brick_blaster_mp";
		
		rz = randomint(level.cgun.size);
		weap = level.cgun[rz];
		
		player TakeAllWeapons();
		level.activ TakeAllWeapons();
		player GiveWeapon( weap );
		player GiveWeapon( weap );  
		player giveMaxammo(weap);
		player giveMaxammo(weap);	
		level.activ GiveWeapon( weap );
        level.activ GiveWeapon( weap ); 
		level.activ giveMaxammo(weap);
		level.activ giveMaxammo(weap);   
		
		player switchToWeapon( weap ); 
        level.activ SwitchToWeapon( weap );
		
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "CRAZY Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
			
    }

}

//Other
elevator()
{
	elevator = getent ("elevator", "targetname");
	speed = 0.5;
	height = 768;
	wait (3);
	if (level.elevatorDown)
	{
		// moves to top
		elevator moveZ (height, speed);
		elevator waittill ("movedone");
		level.elevatorDown = false;
		thread elevator();
	}
	else
	{
		// moves to bottom
		elevator moveZ (height - (height * 2), speed);
		elevator waittill ("movedone");
		level.elevatorDown = true;
		thread elevator();
	}
}

secret_tp()
{
    trig = getEnt ("tp_trig", "targetname");
    end = getEnt ("tp_end", "targetname");    
    while(1)
    {
        trig waittill ("trigger", player);     
	
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player sr\api\_speedrun::changeWay("secret_0");
		// iprintlnbold("^1" + player.name + " ^2Has Entered the ^0DEADZONE^3!");
    }
}

secret_end()
{
    trig = getEnt ("back_trig", "targetname");
    end = getEnt ("tp_re", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);          
		
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		// iprintlnbold("^1" + player.name + " ^2Has Finished the ^0DEADZONE^3!");
		player thread braxi\_mod::endTimer();
	}
}

secret_open()
{

	secretblock = getEnt ("secretdel", "targetname");
	trig = getEnt ("del_trig", "targetname");

	// trig waittill("trigger", player);
	
	// iPrintln ("^1The ^2Chicken ^3Is ^0MAD^3!");
	secretblock delete();
}

secret_fail()
{
    trig = getEnt ("fail_trig", "targetname");
    end = getEnt ("tp_fail", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

fail2()
{
    trig = getEnt ("fail2_trig", "targetname");
    end = getEnt ("fail2", "targetname");

    
    while(1)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

finish()
{

	trig = getEnt ("finish_trigger", "targetname");
	
	trig waittill("trigger", player);
	
	// iprintlnbold("^0" + player.name + " ^2Has Finished le Tower of DEAD at ^0FIRST ^2Place^3!");
	// ambientPlay("ambient3");
	trig delete();
}

infinite_ammo()
{
self endon ( "disconnect" );
self endon ( "death" );
while ( 1 )
{
currentWeapon = self getCurrentWeapon();
if ( currentWeapon != "none" )
{
self setWeaponAmmoClip( currentWeapon, 9999 );
self GiveMaxAmmo( currentWeapon );
}

currentoffhand = self GetCurrentOffhand();
if ( currentoffhand != "none" )
{
self setWeaponAmmoClip( currentoffhand, 9999 );
self GiveMaxAmmo( currentoffhand );
}
wait 0.05;
}
}

song()
{
song = [];
song[song.size] = "ambient1";
song[song.size] = "ambient2";
song[song.size] = "ambient4";

rz = randomint(song.size);
play = song[rz];

	ambientPlay(play);
}