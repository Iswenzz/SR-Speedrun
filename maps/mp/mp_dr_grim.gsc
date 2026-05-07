#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
	/* 

Pixel is a fucking boss lmfao I am gay for him and he hates me because I am gay for him, I should probably shut up now - #FNRP#Ryan

Pixel forced me to add this. He didn't script shit ;D
	*/
	
	
	maps\mp\_load::main();

 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_map::createSpawn((0, 116, -192), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret");
	thread sr\api\_speedrun::createEndMap((7.15339, -17032.2, -1791.885), 175,120, "normal_0");

	thread custom_easy_sec_enter();
	thread custom_hard_sec_enter();
	
	setdvar( "r_specularcolorscale", "1" );
	
	//precacheItem("remington700_mp");
	//precacheItem("dragunov_mp");
	//precacheItem("winchester1200_mp");
	precacheItem("rpg_mp");
	
	thread startdoor();
	//thread maps\mp\_jukebox::main();
	thread teleport1();
	thread teleport2();
	thread teleport11();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	thread trap14();
	thread trap15();
	//thread jumper();
	//thread jumper1();
	//thread autobrush();
	//thread spinningknife();
	//thread sniper();
	//thread letter1();
	//thread letter2();
	//thread letter3();
	//thread letter4();
	//thread letter5();
	//thread letter6();
	//thread knife();
	//thread old();
	//thread bounce();
	//thread weapon();
	//thread bouncerespawn();
	//thread bounceweap();
	//thread secretentrance();
	thread secret1();
	thread secret2();
	thread secret3();
	thread secret4();
	thread secret5();
	thread secret6();
	thread secret7();
	thread secret8();
	thread secretexit();
	//thread ezsecretent();
	thread ezsecret1();
	thread ezsecret2();
	thread ezsecret3();
	thread ezsecret4();
	thread ezsecret5();
	thread ezsecret6();
	thread ezsecret7();
	thread ezsecret8();
	thread ezsecret9();
	thread ezsecretexit();
	thread fail();
	//thread speed();
	//thread text();
	//thread snipweapon();
	//thread credits();
	//thread end();
	//thread arrow();
	//thread door();
	//thread door1();
	//thread ammo1();
	//thread ammo2();
	//thread roomtele();
	thread secretweapon1();
	
	
	
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap5_trig");
	addTriggerToList("trap_trig");
	addTriggerToList("trap7_trig");
	addTriggerToList("trap8_trig");
	addTriggerToList("trap9_trig");
	addTriggerToList("trap10_trig");
	addTriggerToList("trap11_trig");
	addTriggerToList("trap12_trig");
	addTriggerToList("trap13_trig");
	addTriggerToList("trap14_trig");
	addTriggerToList("trap15_trig");
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
custom_easy_sec_enter()
{
	trig = spawn("trigger_radius",(-181.179, 116.078, -251.875), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("ez_enter_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}

custom_hard_sec_enter()
{
	trig = spawn("trigger_radius",(166.16, 116.078, -251.875), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secret_enter_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}
speed()
{
   trigger = getent("speed","targetname");  
   while(1)
   {
      trigger waittill ("trigger",player);
      i=12;
     
      while(i > 8 && player isOnGround())
      {
         player SetMoveSpeedScale(i);
         wait(.05);
      }
 
      player SetMoveSpeedScale(1.3);
      wait(2);
   }
}

addTriggerToList( name )
{
if( !isDefined( level.trapTriggers ) )
level.trapTriggers = [];
level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor()
{
	brush = getent("door","targetname");
	trigger = getent("door_trig","targetname");

	wait 0.1;

	
	brush delete();
}

teleport1()
{
	trig = getEnt("tele1_trig", "targetname");
	tele1 = getEnt("tele1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(tele1.origin);
		player SetPlayerAngles(tele1.angles);
		player freeze_on_tps(0.1);
	}
}

teleport2()
{
	trig = getEnt("tele2_trig", "targetname");
	tele1 = getEnt("tele2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(tele1.origin);
		player SetPlayerAngles(tele1.angles);
		player freeze_on_tps(0.1);
	}
}

teleport11()
{
	trig = getent("tele15_trig","targetname");
	tele1 = getent("tele15","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(tele1.origin);
		player SetPlayerAngles(tele1.angles);
		player freeze_on_tps(0.1);
	}
}


trap1()
{
	brush = getent("trap1","targetname");
	trigger = getent("trap1_trig","targetname");
	trigger waittill("trigger");
	
}

trap2()
{
	brush = getent("trap2","targetname");
	trigger = getent("trap2_trig","targetname");
	trigger waittill("trigger");
	
	
}

trap3()
{
	brush1 = getEnt("trap3","targetname");
	brush2 = getEnt("trap3.1","targetname");
	trigger = getEnt("trap3_trig","targetname");
	trigger waittill("trigger");
	
	
}

trap4()
{
	brush = getent("trap4","targetname");
	trigger = getent("trap4_trig","targetname");
	trigger waittill("trigger");
	
	
}

trap5()
{
	brush = getent("trap5","targetname");
	trigger = getent("trap5_trig","targetname");
	killtrigger = getent ("killtrig" , "targetname");
	trigger waittill ("trigger");
	
	
}

trap6() 
{ 
	square1 = getEnt("trap6", "targetname"); 
	square2 = getEnt("trap6.2", "targetname"); 
	trig = getEnt("trap_trig", "targetname"); 
	trig waittill("trigger", player); 
	
}

trap7()
{
	brush = getent("trap7","targetname");
	trigger = getent("trap7_trig","targetname");
	trigger waittill("trigger"); 

}

trap8()
{
	brush1 = getent("trap8","targetname");
	brush2 = getent("trap8.1","targetname");
	brush3 = getent("trap8.2","targetname");
	brush4 = getent("trap8.3","targetname");
	brush5 = getent("trap8.4","targetname");
	trigger = getent("trap8_trig","targetname");
	trigger waittill("trigger");  

}

trap9()
{
	brush = getent("trap9","targetname");
	trigger = getent("trap9_trig","targetname");
	trigger waittill("trigger"); 
	
	
}

trap10()
{
	brush = getent("trap10","targetname");
	trigger = getent("trap10_trig","targetname");
	trigger waittill("trigger"); 

}

trap11()
{

	brush1 = getent("trap11","targetname");
	brush2 = getent("trap11.1","targetname");
	brush3 = getent("trap11.2","targetname");
	brush4 = getent("trap11.3","targetname");
	trigger = getent("trap11_trig","targetname");
	trigger waittill("trigger");
	

}

trap12()
{
	brush1 = getent("trap12.1","targetname");
	brush2 = getent("trap12.2","targetname");
	trigger = getent("trap12_trig","targetname");
	trigger waittill("trigger");
	
	
}

trap13()
{
	brush = getent("trap13","targetname");
	trigger = getent("trap13_trig","targetname");
	trigger waittill("trigger");
	
	
}

trap14()
{
	brush = getent("trap14","targetname");
	trigger = getent("trap14_trig","targetname");
	trigger waittill("trigger");
	
	
}

trap15()
{
	brush1 = getent("trap15","targetname");
	brush2 = getent("trap15.1","targetname");
	trigger = getent("trap15_trig","targetname");
	trigger waittill("trigger");
	
	
}

jumper()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{  
			user.isOnRope = true;
			user sr\api\_player::antiElevator(false);
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			wait 1;
			user sr\api\_player::antiElevator(true);
			user.isOnRope = false;
		}
	}
}

jumper1()
{
	jumpx = getent ("jump1","targetname");
	glow = getent ("glow1","targetname");
	air1 = getent ("air5","targetname");
	air2 = getent ("air6","targetname");
	air3 = getent ("air7","targetname");
	air4 = getent ("air8","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{  
			user.isOnRope = true;
			user sr\api\_player::antiElevator(false);
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			wait 1;
			user sr\api\_player::antiElevator(true);
			user.isOnRope = false;
		}
	}
}

letter1()
{
	brush1 = getent("letter","targetname");
	brush2 = getent("letter0","targetname");
	
	while(1)
	{
		brush1 rotateYaw(360,10);
		brush2 rotateYaw(360,10);
		wait 1;
	}
}

letter2()
{
	brush = getent("letter1","targetname");
	
	while(1)
	{
		brush rotateYaw(360,10);
		wait 1;
	}
}

letter3()
{
	brush = getent("letter2","targetname");
	
	while(1)
	{
		brush rotateYaw(360,10);
		wait 1;
	}
}

letter4()
{
	brush = getent("letter3","targetname");
	
	while(1)
	{
		brush rotateYaw(360,10);
		wait 1;
	}
}

letter5()
{
	brush = getent("letter4","targetname");
	
	while(1)
	{
		brush rotateYaw(360,10);
		wait 1;
	}
}

letter6()
{
	brush = getent("letter5","targetname");
	
	while(1)
	{
		brush rotateYaw(360,10);
		wait 1;
	}
}
	
spinningknife()
{
        level.sknife_trig = getEnt( "spinning_knife", "targetname");
        jump = getEnt( "spinning_knife1", "targetname" );
        acti = getEnt( "spinning_knife2", "targetname" );
 
 
        while(1)
        {
                level.sknife_trig waittill( "trigger", player );
                if( !isDefined( level.sknife_trig ) )
                        return;
				
				level.sniper_trig delete();
				level.knife_trig delete();
				level.old_trig delete();
                
              
				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "tomahawk_mp" );  
                player switchToWeapon( "tomahawk_mp" );
				player setMoveSpeedScale(1.2);
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "tomahawk_mp" );
                        level.activ SwitchToWeapon( "tomahawk_mp" );
						level.activ setMoveSpeedScale(1.2);
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Spinning Knife ^7Room!" );
					player freezecontrols(true);
					level.activ freezecontrols(true);
					wait 1;
					player iPrintlnBold( "^13" );
					level.activ iPrintlnBold( "^13" );
					wait 1;
					player iPrintlnBold( "^32" );
					level.activ iPrintlnBold( "^32" );
					wait 1;
					player iPrintlnBold( "^51" );
					level.activ iPrintlnBold( "^51" );
					wait 1;
					player iPrintlnBold( "^6Fight^7!" );
					level.activ iPrintlnBold( "^6Fight^6!" );
					player freezecontrols(false);
					level.activ freezecontrols(false);
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

autobrush()
{
	brush = getent("autobrush","targetname");
	
	while(1)
	{
		brush rotateYaw(360,2);
		wait 1;
		brush rotateYaw(360,2);
		wait 1;
	}
}

sniper()
{
        level.sniper_trig = getEnt( "sniper_trig", "targetname"); 
        jump = getEnt( "sniper1", "targetname" ); 
        acti = getEnt( "sniper2", "targetname" ); 
 
        while(1) 
{
                level.sniper_trig waittill( "trigger", player ); 
                if( !isDefined( level.sniper_trig ) ) 
                return;  
				
				  level.knife_trig delete();
				  level.sknife_trig delete();
				  level.old_trig delete();
				  level.bounce_trig delete();
				  level.weapon_trig delete();
				
				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "m40a3_mp" );
                player giveMaxAmmo( "m40a3_mp" );
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );	
				player switchToWeapon( "m40a3_mp" );
				player setMoveSpeedScale(1.2);
                player.maxhealth = 100;
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m40a3_mp" );
                    level.activ giveMaxAmmo( "m40a3_mp" );
                    level.activ GiveWeapon( "remington700_mp" );
                    level.activ giveMaxAmmo( "remington700_mp" );
					level.activ SwitchToWeapon( "m40a3_mp" );
					level.activ setMoveSpeedScale(1.2);
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Sniper ^7Room!" ); 
				player freezecontrols(true);
				level.activ freezecontrols(true);
				wait 1;
				player iPrintlnBold( "^13" );
				level.activ iPrintlnBold( "^13" );
				wait 1;
				player iPrintlnBold( "^32" );
				level.activ iPrintlnBold( "^32" );
				wait 1;
				player iPrintlnBold( "^51" );
				level.activ iPrintlnBold( "^51" );
				wait 1;
				player iPrintlnBold( "^6Fight^7!" );
				level.activ iPrintlnBold( "^6Fight^6!" );
				player freezecontrols(false);
				level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
}

old()
{
        level.old_trig = getEnt( "old_trig", "targetname");
        jump = getEnt( "old1", "targetname" );
 
 
        while(1)
        {
                level.old_trig waittill( "trigger", player );
                if( !isDefined( level.old_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.knife_trig delete();
				level.sknife_trig delete();
				level.bounce_trig delete();
				level.weapon_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Old ^7Room!" );     
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

knife()
{
		
        level.knife_trig = getEnt( "knife_trig", "targetname");
        jump = getEnt( "knife1", "targetname" );
        acti = getEnt( "knife2", "targetname" );
		
 
 
        while(1)
        {
                level.knife_trig waittill( "trigger", player );
                if( !isDefined( level.knife_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.old_trig delete();
				level.sknife_trig delete();
				level.bounce_trig delete();
				level.weapon_trig delete();
				
				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "tomahawk_mp" );   
                player switchToWeapon( "tomahawk_mp" );
				player setMoveSpeedScale(1.2);
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "tomahawk_mp" );
                        level.activ SwitchToWeapon( "tomahawk_mp" );
						level.activ setMoveSpeedScale(1.2);
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Knife ^7Room!" ); 
					player freezecontrols(true);
					level.activ freezecontrols(true);
					wait 1;
					player iPrintlnBold( "^13" );
					level.activ iPrintlnBold( "^13" );
					wait 1;
					player iPrintlnBold( "^32" );
					level.activ iPrintlnBold( "^32" );
					wait 1;
					player iPrintlnBold( "^51" );
					level.activ iPrintlnBold( "^51" );
					wait 1;
					player iPrintlnBold( "^6Fight^7!" );
					level.activ iPrintlnBold( "^6Fight^6!" );
					player freezecontrols(false);
					level.activ freezecontrols(false);
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

bounce()
{
        level.bounce_trig = getEnt( "bounce_trig", "targetname");
        jump = getEnt( "bounce1", "targetname" );
        acti = getEnt( "bounce2", "targetname" );
 
 
        while(1)
        {
                level.bounce_trig waittill( "trigger", player );
                if( !isDefined( level.bounce_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.old_trig delete();
                level.knife_trig delete();
				level.sknife_trig delete();
				level.weapon_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); 
                player switchToWeapon( "knife_mp" );
				player setMoveSpeedScale(1.2);
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "knife_mp" );
                        level.activ SwitchToWeapon( "knife_mp" );
						level.activ setMoveSpeedScale(1.2);
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^4" + player.name + "  ^7has chosen ^4Bounce ^7Room!" ); 
				player freezecontrols(true);
				level.activ freezecontrols(true);
				wait 1;
				player iPrintlnBold( "^13" );
				level.activ iPrintlnBold( "^13" );
				wait 1;
				player iPrintlnBold( "^32" );
				level.activ iPrintlnBold( "^32" );
				wait 1;
				player iPrintlnBold( "^51" );
				level.activ iPrintlnBold( "^51" );
				wait 1;
				player iPrintlnBold( "^6Fight^7!" );
				level.activ iPrintlnBold( "^6Fight^6!" );
				player freezecontrols(false);
				level.activ freezecontrols(false);
				
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

weapon()
{
    level.weapon_trig = getEnt( "weapon_trig", "targetname");
    jump = getEnt( "weapon", "targetname" );
    acti = getEnt( "weapon1", "targetname" );
    
    while(1)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
            return;
        
        level.knife_trig delete();
		level.sniper_trig delete();
		level.old_trig delete();
		level.sknife_trig delete();
		level.bounce_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player takeallweapons();
		player giveweapon("winchester1200_mp");
		player givemaxammo("winchester1200_mp");
		player switchtoweapon("winchester1200_mp");
		level.acti takeallweapons();
		level.acti giveweapon("winchester1200_mp");
		level.acti givemaxammo("winchester1200_mp");
		level.acti switchtoweapon("winchester1200_mp");
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        wait 0.05;
		player setMoveSpeedScale(1.2);
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
		level.activ setMoveSpeedScale(1.2);
        iPrintlnBold( " ^4" + player.name + "  ^7has chosen ^4Weapon ^7Room!"  );     
		player freezecontrols(true);
        level.activ freezecontrols(true);
        wait 1;
        player iPrintlnBold( "^13" );
        level.activ iPrintlnBold( "^13" );
        wait 1;
        player iPrintlnBold( "^32" );
        level.activ iPrintlnBold( "^32" );
        wait 1;
        player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
        wait 1;
        player iPrintlnBold( "^6Fight^7!" );
        level.activ iPrintlnBold( "^6Fight^6!" );
        player freezecontrols(false);
        level.activ freezecontrols(false);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

bouncerespawn() 
{
	trigger = getEnt ("bounce_tele", "targetname"); 
    jumper = getEnt ("bounce_origin1", "targetname"); 
    activator = getEnt ("bounce_origin", "targetname"); 
   
    for(;;)
    {
        trigger waittill ("trigger", player);
        if(player.pers["team"] == "allies")
        {
            player SetOrigin(jumper.origin);
            player SetPlayerAngles( jumper.angles );
        }
        else if(player.pers["team"] == "axis")    
        {
            player SetOrigin(activator.origin);
            player SetPlayerAngles( activator.angles );            
        }
    }
}

secretentrance()
{
	trig = getEnt("secret_enter_trig", "targetname");
	tele1 = getEnt("secret_enter_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
		player thread countdown();
		player iPrintLnBold("^4You ^7Have ^4120 ^7Seconds ^4To ^7Complete!");
	}
}

countdown()
{
	self endon("death");
	self endon("finished");
	self.pers["time"] = 120;
	self thread timehud();
	for(;;)
	{
		wait 1;
		self.pers["time"] --;
		if(self.pers["time"]<1)
		self suicide();
	}
}

timehud()
{
	self endon ("death");
	self endon ("finished");
	self endon ("disconnect");
	self.time_hud = newClientHudElem(self);
	self.time_hud.x = 300;
	self.time_hud.y = 10;
	self.time_hud.alignX = "middle";
	self.time_hud.alignY = "center";
	self.time_hud.fontScale = 2.3;
	self.time_hud.color = (255, 0, 0);
	self.time_hud.font = "objective";
	self.time_hud.glowColor = (255, 0, 0);
	self.time_hud.glowAlpha = 1;
	self.time_hud.hideWhenInMenu = false;
	self.time_hud.owner = self;
	self.time_hud setText( self.pers["time"] );
	self.time_hud thread destroyondeath();
	self thread changetime();
	self thread destroyondeath();
	wait 120;
	self thread destroytimehud();
}

destroyondeath()
{
	self waittill_any("death", "disconnect");
	self destroytimehud();
}
changetime()
{
for(;;)
{
	self.time_hud setText( self.pers["time"] );
	wait 0.1;
	self.time_hud setText( self.pers["time"] );
	wait 0.1;
}
}

destroytimehud()
{
	if( isDefined( self.time_hud) )
	{
        self.time_hud destroy();
    }
}

secret1()
{
	trig = getEnt("secret1_trig", "targetname");
	tele1 = getEnt("secret1_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret2()
{
	trig = getEnt("secret2_trig", "targetname");
	tele1 = getEnt("secret2_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret3()
{
	trig = getEnt("secret3_trig", "targetname");
	tele1 = getEnt("secret3_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret4()
{
	trig = getEnt("secret4_trig", "targetname");
	tele1 = getEnt("secret4_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret5()
{
	trig = getEnt("secret5_trig", "targetname");
	tele1 = getEnt("secret5_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret6()
{
	trig = getEnt("secret6_trig", "targetname");
	tele1 = getEnt("secret6_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret7()
{
	trig = getEnt("secret7_trig", "targetname");
	tele1 = getEnt("secret7_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secret8()
{
	trig = getEnt("secret8_trig", "targetname");
	tele1 = getEnt("secret8_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

secretexit()
{
	trig = getEnt("secret_exit_trig", "targetname");
	tele1 = getEnt("secret_exit_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_1");
	}
		 	
}

ezsecretent()
{
	trig = getEnt("ez_enter_trig", "targetname");
	tele1 = getEnt("ez_enter_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
		player thread countdown();
		player iPrintLnBold("^4You ^7Have ^4120 ^7Seconds ^4To ^7Complete!");
	}
}

ezsecret1()
{
	trig = getEnt("ez_trig1", "targetname");
	tele1 = getEnt("ez_origin1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret2()
{
	trig = getEnt("ez_trig2", "targetname");
	tele1 = getEnt("ez_origin2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret3()
{
	trig = getEnt("ez_trig3", "targetname");
	tele1 = getEnt("ez_origin3", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret4()
{
	trig = getEnt("ez_trig4", "targetname");
	tele1 = getEnt("ez_origin4", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret5()
{
	trig = getEnt("ez_trig5", "targetname");
	tele1 = getEnt("ez_origin5", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret6()
{
	trig = getEnt("ez_trig6", "targetname");
	tele1 = getEnt("ez_origin6", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret7()
{
	trig = getEnt("ez_trig7", "targetname");
	tele1 = getEnt("ez_origin7", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret8()
{
	trig = getEnt("ez_trig8", "targetname");
	tele1 = getEnt("ez_origin8", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecret9()
{
	trig = getEnt("ez_trig9", "targetname");
	tele1 = getEnt("ez_origin9", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

ezsecretexit()
{
	trig = getEnt("ez_exit_trig", "targetname");
	tele1 = getEnt("ez_exit_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

fail()
{
	trig = getEnt("tryagain_trig", "targetname");
	tele1 = getEnt("tryagain_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
		//player iPrintLnBold("^2T^7ry ^2A^7gain ^2:P");
	}
}


bounceweap()
{
	trigger = getEnt("giveweapon","targetname");
	
	trigger waittill("trigger", player);
	
		iPrintLnBold(player.name +  " ^4Has ^7Grabbed ^4The ^7Sniper! ");
		wait(.10);
		player giveweapon( "remington700_mp" );
		player givemaxammo( "remington700_mp" );
		player switchtoweapon( "remington700_mp" );
	
}

text()
{
	while(1)
	{
		wait 15;
		iPrintLn("^1Special Thanks to: ^7Thee, ^7Flyyy, ^1and ^7Trucker!");
		wait 120;
	}
}

snipweapon()
{
	trigger = getEnt("snip_weap","targetname");
	trigger waittill("trigger", player);
	
	player giveweapon("dragunov_mp");
	player givemaxammo("dragunov_mp");
	player switchtoweapon("dragunov_mp");
	player iPrintLnBold("^7Aw ^4You ^7Fuck :D");
}


 
credits()
{
    if( isDefined( self.creditsText ) )
        self.creditsText destroy();
     
    self.creditsText = newHudElem();
    self.creditsText.y = 10;
    self.creditsText.alignX = "center";
    self.creditsText.alignY = "middle";
    self.creditsText.horzAlign = "center_safearea";
    self.creditsText.alpha = 0;
    self.creditsText.sort = -3;
    self.creditsText.fontScale = 1.6;
    self.creditsText.archieved = true;
     
    for(;;)
    {
        self.creditsText fadeOverTime(1);
        self.creditsText.alpha = 1;
        self.creditsText setText("^3Welcome to Grim!");
        wait 3;
        self.creditsText fadeOverTime(1);
        self.creditsText.alpha = 0;
        wait 1;
        self.creditsText fadeOverTime(1);
        self.creditsText.alpha = 1;
        self.creditsText setText("^3Map By: #FNRP#Ryan");
        wait 3;
        self.creditsText fadeOverTime(1);
        self.creditsText.alpha = 0;
        wait 1;
        self.creditsText fadeOverTime(1);
        self.creditsText.alpha = 1;
        self.creditsText setText("^3Xfire: ryanb1196");
        wait 3;
        self.creditsText fadeOverTime(1);
        self.creditsText.alpha = 0;
        wait 1;

	}
}

end()
{
	trigger = getEnt("end","targetname");
	trigger waittill("trigger", player);
	
	iPrintlnBold(player.name + " ^1Has ^7Finished ^1First!");
	
	trigger delete();
}

arrow()
{
	brush = getEnt("arrow","targetname");
	
	while(1)
	{
		brush moveZ(150,2);
		wait 1;
		brush moveZ(-150,2);
		wait 1;
	}
}

door()
{
	door = getent ("door1","targetname");
	trig = getent ("door1_trig","targetname");
		while (1)
		{
			trig waittill ("trigger");
			wait (2);
			door rotateyaw ( 90, 2, 1.5, 0.5);
			door waittill ("rotatedone");
			wait (6);
			door rotateyaw ( -90, 2.1, 1.5, 0.5);
			wait (1.9);
		}
}
	
door1()
{
	door = getent ("door2","targetname");
	trig = getent ("door2_trig","targetname");
		while (1)
		{
			trig waittill ("trigger");
			wait (2);
			door rotateyaw ( 90, 2, 1.5, 0.5);
			door waittill ("rotatedone");
			wait (6);
			door rotateyaw ( -90, 2.1, 1.5, 0.5);
			wait (1.9);
		}
}

ammo1()
{
	trigger = getent("ammo1","targetname");
	trigger waittill("trigger",player);
	player iPrintLnBold("^3Ammo Replenished");
	player givemaxammo("m40a3_mp");
	player givemaxammo("remington700_mp");
}

ammo2()
{ 
	trigger = getent("ammo2","targetname");
	trigger waittill("trigger",player);
	player iPrintLnBold("^3Ammo Replenished!");
	player givemaxammo("m40a3_mp");
	player givemaxammo("remington700_mp");
}

roomtele()
{
	trig = getEnt("room_tele", "targetname");
	tele1 = getEnt("room_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
		iPrintLnBold("^6" + player.name + " Failed!");
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 2;
		player freezecontrols(false);
		level.activ freezecontrols(false);
	}
}

secretweapon1()
{
	trigger = getEnt("secret_rpg_trig1","targetname");
	trigger waittill("trigger", player);
	
		player giveweapon("rpg_mp");
		player givemaxammo("rpg_mp");
		player switchtoweapon("rpg_mp");
}






















