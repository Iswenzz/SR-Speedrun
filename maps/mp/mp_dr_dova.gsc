main()
{
	maps\mp\_load::main();	
	


	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setdvar("bg_fallDamageMaxHeight","9999");
	setdvar("bg_fallDamageMinHeight","9998");

	thread speedrun\_way_name::create_normal_way("Normal Way;");
    thread speedrun\_way_name::create_secret_way("Hard Secret;Easy;");
	thread speedrun\_way_name::create_spawn((-1182,15,76),359);
	thread speedrun\_way_name::create_tp((-952.513, 246.823, 16.125), 60, 80, (-3299, -4141, 2216), 178, "freeze", "darkred", "s0");
	thread speedrun\_way_name::create_tp((-1140.39, 239.501, 16.125), 60, 80, (-3685, 2352, 1901), 189, "freeze", "blue", "s1");
	// thread messages();
	thread startdoor();
	// thread tr1();
	// thread tr2();
	// thread tr3();
	// thread tr4();
	// thread tr5();
	// thread tr6();
	// thread tr7();
	// thread teleasy();
	// thread telhard();
	thread hardf();
	thread hardf2();
	thread hardf3();
	thread hardf4();
	thread easyf();
	thread easyf2();
	// thread actitp();
	// thread actitp2();
	// thread sniper();
	// thread jump();
	// thread weapon();
	// thread deagle();
	// thread jumpfail();
	// thread jumpfail2();
	// thread music();
	
	
	addTriggerToList( "trig1");
	addTriggerToList( "trig2");
	addTriggerToList( "trig3");
	addTriggerToList( "trig4");
	addTriggerToList( "trig5");
	addTriggerToList( "trig6");
	addTriggerToList( "trig7");
	
}

addTriggerToList ( name )
	{
		if( !isDefined( level.trapTriggers) )
			level.trapTriggers = [];
		level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname");
	}


messages()
{
wait 5;
iprintlnBold("^2mp_dr_dova^3 by ^5dova");
wait 6;
iprintln("Thanks to ^2Kris ^7and ^3Nuka ^7for help");
}
startdoor()
{
drzwi = getent("startdoor","targetname");
{

drzwi moveZ(-350, 5);

}
}
tr1()
{
	platform2 = getent("trap12", "targetname");
	platform1 = getent("trap11", "targetname");
	trig = getent("trig1", "targetname");
	trig SetHintString("^3Moving platforms");	
	trig waittill("trigger", player );
		
	trig delete();
	
	while(1)
	{
	platform2 moveZ(75, 1);
	platform1 moveZ(-75, 1);
	wait 1;
	platform2 moveZ(-75, 1);
	platform1 moveZ(75, 1);
	wait 1;
	}
	
}
tr2()
{
	plat1 = getent("trap21", "targetname");
	plat2 = getent("trap22", "targetname");
	plat3 = getent("trap23", "targetname");
	trig = getent("trig2", "targetname");
	trig SetHintString("^3Split it");
	trig waittill("trigger", player );
	
	trig delete();
	
	plat3 delete();
	
	wait 1;
	plat1 moveY(75, 2);
	wait 2;
	plat2 moveY(-75, 2);
	
}
tr3()
{
	plat = getent("trap3", "targetname");
	trig = getent("trig3", "targetname");
	trig SetHintString("^2 Slow them down");
	trig waittill("trigger", player );
	
	
	trig delete();
	
	plat moveZ(-40, 2);
}
tr4()
{
	platform = getent("trap4", "targetname");
	triger = getent("triger4", "targetname");
	triger SetHintString("^2 Make them bounce");	
	triger waittill("trigger", player );
	
	
	triger delete();
	
	platform delete();	
	
}
tr5()
{
	plat1 = getent("trap51", "targetname");
	plat2 = getent("trap52", "targetname");
	plat3 = getent("trap53", "targetname");
	plat4 = getent("trap54", "targetname");
	plat5 = getent("trap55", "targetname");
	plat6 = getent("trap56", "targetname");
	trig = getent("trig5", "targetname");
	trig SetHintString("^1Rotate platforms");
	trig waittill("trigger", player );
		
	trig delete();
	
	while(1)
	{
		plat1 rotateRoll(180, 0.5);
		wait 0.5;
		plat2 rotateRoll(180, 0.5);
		wait 0.5;
		plat3 rotateRoll(180, 0.5);
		wait 0.5;
		plat4 rotateRoll(180, 0.5);
		wait 0.5;
		plat5 rotateRoll(180, 0.5);
		wait 0.5;
		plat6 rotateRoll(180, 0.5);
		wait 0.5;		
		
	}
	
}
tr6()
{
	plat = getent("trap6", "targetname");
	trig = getent("trig6", "targetname");
	trig SetHintString("^1Push!");
	trig waittill("trigger", player );
		
	trig delete();
	
	plat moveY(-600,1);
	wait 1.25;
	plat moveY(600,1);
	
}
tr7()
{
	plat = getent("trap7", "targetname");
	trig = getent("trig7", "targetname");
	trig SetHintString("^1Rotate bounces");
	trig waittill("trigger", player );
	
	trig delete();
	
	while(1)
	{
	plat rotateYaw(360, 1);
	wait 4;
	}
}
teleasy()
{
	trig = getent("easy", "targetname");
	tele1 = getent("easytp", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
telhard()
{
	trig = getent("hard", "targetname");
	tele1 = getent("hardtp", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
hardf()
{
	trig = getent("hardfail1", "targetname");
	tele1 = getent("hardtp", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
hardf2()
{
	trig = getent("hardfail2", "targetname");
	tele1 = getent("hardfailtp1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
hardf3()
{
	trig = getent("hardfail3", "targetname");
	tele1 = getent("hardfailtp2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
hardf4()
{
	trig = getent("hardfinish", "targetname");
	tele1 = getent("hardtofinish", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	    player thread speedrun\_way_name::finish_way("s0");
		
	}
}
easyf()
{
	trig = getent("easyfail", "targetname");
	tele1 = getent("easytp", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
		
	}
}
easyf2()
{
	trig = getent("easytofinish", "targetname");
	tele1 = getent("easyfinish", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	    player thread speedrun\_way_name::finish_way("s1");
		
	}
}
actitp()
{
	trig = getent("actitp", "targetname");
	tele1 = getent("actitp2", "targetname");	
	trig SetHintString("^5Teleport to the next room");
	
	trig waittill("trigger", player);
	
	player setOrigin(tele1.origin);
		
}
actitp2()
{
	trig = getent("actitofun", "targetname");
	tele1 = getent("actifun", "targetname");	
	trig SetHintString("^5 What is it?");
	
	trig waittill("trigger", player);
	
	player setOrigin(tele1.origin);
	
	wait 1;
	level.activ iPrintLnBold( "uh?" );
	
		
}
sniper()
{
        level.sniper_trig = getEnt( "snipertrig", "targetname"); //trigger 
        jump = getEnt( "sniperjumper", "targetname" ); //jumper origin
        acti = getEnt( "sniperacti", "targetname" ); //acti origin
		level.deagle_trig = getEnt("deagletrig", "targetname");
		level.jump_trig = getEnt( "jumptrig", "targetname");
 
        while(1) 
{
                level.sniper_trig waittill( "trigger", player ); 
                if( !isDefined( level.sniper_trig ) ) 
                return;  
            
              level.deagle_trig delete();
			  level.jump_trig delete();	  //deletes all other rooms from being used.
			  level.weapon_trig delete();
			  
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "m40a3_mp" ); //Gives player weapon
                player giveMaxAmmo( "m40a3_mp" ); //Gives player ammo
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );   
            player switchToWeapon( "m40a3_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
                
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
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^5" + player.name + " ^7has chosen ^5Sniper ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^53" );
            level.activ iPrintlnBold( "^53" );
            wait 1;
            player iPrintlnBold( "^52" );
            level.activ iPrintlnBold( "^52" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^7Fight^5!" );
            level.activ iPrintlnBold( "^7Fight^5!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
}
jump()
{
        level.jump_trig = getEnt( "jumptrig", "targetname"); //trigger 
        jump = getEnt( "jumpjumper", "targetname" ); //jumper origin
        acti = getEnt( "jumpacti", "targetname" ); //acti origin
		level.deagle_trig = getEnt("deagletrig", "targetname");
		level.sniper_trig = getEnt( "snipertrig", "targetname");
		
        while(1) 
{
                level.jump_trig waittill( "trigger", player ); 
                if( !isDefined( level.jump_trig ) ) 
                return;  
            
              level.deagle_trig delete(); //deletes all other rooms from being used.
			  level.sniper_trig delete();
			  level.weapon_trig delete();
			  
			  
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" );
				player switchToWeapon( "knife_mp" );	
                player.maxhealth = 100;
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" );
					level.activ switchToWeapon( "knife_mp" );				
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^3" + player.name + " ^7has chosen ^3Jump ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^33" );
            level.activ iPrintlnBold( "^33" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^31" );
            level.activ iPrintlnBold( "^31" );
            wait 1;
            player iPrintlnBold( "^7Fight^3!" );
            level.activ iPrintlnBold( "^7Fight^3!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
}
weapon()
{
        level.weapon_trig = getEnt( "weapontrig", "targetname"); //trigger 
        jump = getEnt( "weaponjumper", "targetname" ); //jumper origin
        acti = getEnt( "weaponacti", "targetname" ); //acti origin
		level.deagle_trig = getEnt("deagletrig", "targetname");
		level.sniper_trig = getEnt( "snipertrig", "targetname");
		level.jump_trig = getEnt( "jumptrig", "targetname");
		
        while(1) 
{
                level.weapon_trig waittill( "trigger", player ); 
                if( !isDefined( level.weapon_trig ) ) 
                return;  
            
              level.deagle_trig delete(); //deletes all other rooms from being used.
			  level.sniper_trig delete();
			  level.jump_trig delete();
			  
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "knife_mp" );
				player switchToWeapon( "knife_mp" );
                player.maxhealth = 100;
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "knife_mp" );
					level.activ switchToWeapon( "knife_mp" );				
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^2" + player.name + " ^7has chosen ^2Knife ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^7Fight^2!" );
            level.activ iPrintlnBold( "^7Fight^2!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
}
deagle()
{
        level.deagle_trig = getEnt( "deagletrig", "targetname"); //trigger 
        jump = getEnt( "deaglejumper", "targetname" ); //jumper origin
        acti = getEnt( "deagleacti", "targetname" ); //acti origin
		level.weapon_trig = getEnt("weapontrig", "targetname");
		level.sniper_trig = getEnt( "snipertrig", "targetname");
		level.jump_trig = getEnt( "jumptrig", "targetname");
		
        while(1) 
{
                level.deagle_trig waittill( "trigger", player ); 
                if( !isDefined( level.deagle_trig ) ) 
                return;  
            
              level.weapon_trig delete(); //deletes all other rooms from being used.
			  level.sniper_trig delete();
			  level.jump_trig delete();
			  
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "deserteagle_mp" );
				player giveMaxAmmo( "deserteagle_mp" );
				player switchToWeapon( "deserteagle_mp" );
                player.maxhealth = 100;
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "deserteagle_mp" );
					level.activ giveMaxAmmo( "deserteagle_mp" );
					level.activ switchToWeapon( "deserteagle_mp" );				
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^6" + player.name + " ^7has chosen ^6Deagle ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^63" );
            level.activ iPrintlnBold( "^63" );
            wait 1;
            player iPrintlnBold( "^62" );
            level.activ iPrintlnBold( "^62" );
            wait 1;
            player iPrintlnBold( "^61" );
            level.activ iPrintlnBold( "^61" );
            wait 1;
            player iPrintlnBold( "^7Fight^6!" );
            level.activ iPrintlnBold( "^7Fight^6!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
}
jumpfail()
{
	trig = getent("jumperfail", "targetname");
	tele1 = getent("jumpjumper", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
jumpfail2()
{
	trig = getent("actifail", "targetname");
	tele1 = getent("jumpacti", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}
music()
{

	
    songs = [];
    songs[songs.size] = "song1";
    songs[songs.size] = "song2";
    songs[songs.size] = "song3";
	songs[songs.size] = "song4";
	songs[songs.size] = "song5";
	songs[songs.size] = "song6";
	songs[songs.size] = "song7";
	
    selected = songs[ Randomint( songs.size ) ];
    AmbientPlay( selected );
}