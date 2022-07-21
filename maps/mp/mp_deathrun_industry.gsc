main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	
 level._effect["fire_trap"] = loadfx( "custome/fire_trap" );
	
    thread end();

    thread sr\api\_speedrun::createTeleporter((235, -23, 76), 50, 15, (-4376, -5640, 573), 0, "freeze", "blue", "secret_0");
    thread sr\api\_speedrun::createEndMap((-574, -3435, 269), 150, 15, "secret_0");


	addTriggerToList( "trigger_t_" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trigger_t4_" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trigger_t8_" );
	addTriggerToList( "trigger_t9_" );
	addTriggerToList( "trig_trap10" );
	addTriggerToList( "trig_trap11" );
	addTriggerToList( "trig_trap12" );
	addTriggerToList( "trig_trap13" );
	addTriggerToList( "weapon_trig" );

	maps\mp\_load::main();
	maps\mp\mp_deathrun_industry\_teleport1::main();
	maps\mp\mp_deathrun_industry\_teleport2::main();
	maps\mp\mp_deathrun_industry\_teleport3::main();
	maps\mp\mp_deathrun_industry\_teleport4::main();
	maps\mp\mp_deathrun_industry\_teleport5::main();
	maps\mp\mp_deathrun_industry\_teleport6::main();
	maps\mp\mp_deathrun_industry\_teleport7::main();
	// maps\mp\mp_deathrun_industry\_teleport8::main();
	maps\mp\mp_deathrun_industry\_teleport9::main();
	maps\mp\mp_deathrun_industry\_teleport10::main();
	maps\mp\mp_deathrun_industry\_rotate::main();
	
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
	setdvar("compassmaxrange","1800");
	
	thread startdoor();
	thread plat();
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
	/* [AUTO DELETE] thread kniferoom(); */
	thread jumproom();
	/* [AUTO DELETE] thread sniperoom(); */
	/* [AUTO DELETE] thread old(); */
	// thread  [AUTO DELETE] jump_weapon(); 
	// thread map_by();


}


startdoor()
{
object = getEnt ("startdoor","targetname");
trig = getEnt ("trig_startdoor","targetname");
trig waittill ("trigger" , player );
{
object moveZ(-160, 3);
wait 1;
}
}


plat()
{
object = getEnt ("plat","targetname");
trigger = getEnt ("trig_plat","targetname");
// trigger waittill ("trigger" , player );
// while(1)
// {
// object moveX(448, 3);
// wait(4);
// object moveX(-448,3);
// wait(4);
// }
}


trap1()
{
	level endon("trigger");
    trigger = getent("trigger_t_","targetname");
	object = getent("t1_","targetname");
    trigger waittill ("trigger" , player );
    trigger delete();
	a = getent("t1a","targetname");
	b = getent("t1b","targetname");
	
	while(1)
	{
		a moveZ(56,0.5);
		b moveZ(-56,0.5);
		wait 0.5;
		a moveZ(-56,0.5);
		b moveZ(56,0.5);
		wait 0.5;
		a moveZ(56,0.5);
		b moveZ(-56,0.5);
		wait 0.5;
		a moveZ(-56,0.5);
		b moveZ(56,0.5);
        wait 0.5;		
	}
}


trap2()
{
	level endon("trigger");
trigger = getent("trig_trap2","targetname");
object = getent("trap2","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object movez(-112, 0.01);
object waittill("movedone");
wait 2;
object movez(112, 3);
object waittill("movedone");
wait 1;
}
}


trap3()
{
	level endon("trigger");
trigger = getent("trig_trap3","targetname");
object = getent("trap3_1","targetname");
object2 = getent("trap3_2","targetname");
killtrigger = getent ("killtrig_3" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
killtrigger linkto (object2);
object moveY(192, 1);
object2 moveY(-192, 1);
wait 2;
object moveY(-192, 3);
object2 moveY(192, 3);
wait 1;
}
}


trap4()
{
	level endon("trigger");
    trigger = getent("trigger_t4_","targetname");
	object = getent("t4_","targetname");
    trigger waittill ("trigger" , player );
    trigger delete();
	a = getent("t4a","targetname");
	b = getent("t4b","targetname");
	
	while(1)
	{
		a notsolid();
		a hide();
		wait 2;
		a solid();
		a show();
		b notsolid();
		b hide();
		wait 2;	
        b solid();
        b show();
        a notsolid();
        a hide();
        wait 2;
        a solid();
        a show();	
        wait 2;		
	}
}


trap5()
{
	level endon("trigger");
trigger = getent("trig_trap5","targetname");
object = getent("trap5","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object moveX(592, 1.5);
object waittill("movedone");
wait 2;
object moveX(-592, 1.5);
object waittill("movedone");
wait 1;
}
}


trap6()
{
	level endon("trigger");
trigger = getent("trig_trap6","targetname");
object = getent("trap6","targetname");
killtrigger = getent ("killtrig_6" , "targetname");
killtrigger = getent ("killtrig_7" , "targetname");
killtrigger = getent ("killtrig_8" , "targetname");
killtrigger = getent ("killtrig_9" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveZ(64, 0.1);
PlayFX(level._effect["fire_trap"],(4752, 2728, -1495));
PlayFX(level._effect["fire_trap"],(4752, 2824, -1495));
PlayFX(level._effect["fire_trap"],(4864, 2824, -1495));
PlayFX(level._effect["fire_trap"],(4864, 2728, -1495));
PlayFX(level._effect["fire_trap"],(4976, 2824, -1495));
PlayFX(level._effect["fire_trap"],(4976, 2728, -1495));
PlayFX(level._effect["fire_trap"],(5088, 2824, -1495));
PlayFX(level._effect["fire_trap"],(5088, 2728, -1495));
wait 2;
object moveZ(-64, 0.1);
wait 1;
}
}


trap7()
{
	level endon("trigger");
                      trig = GetEnt("trig_trap7","targetname");
                      brush = GetEnt("trap7","targetname");
					  trig waittill ("trigger" , player );
					  trig delete();
                      while(1)
                     {
                              brush rotateYaw(-360,2.5);
                              wait 0.1;
                     }
}


trap8()
{
	level endon("trigger");
    trigger = getent("trigger_t8_","targetname");
	object = getent("t8_","targetname");
    trigger waittill ("trigger" , player );
    trigger delete();
	a = getent("t8a","targetname");
	b = getent("t8b","targetname");
	
	while(1)
	{
		a moveX(32,0.5);
		b moveX(-32,0.5);
		wait 0.5;
		a moveX(-32,0.5);
		b moveX(32,0.5);
		wait 0.5;		
     	a moveX(32,0.5);
		b moveX(-32,0.5);
		wait 0.5;
		a moveX(-32,0.5);
		b moveX(32,0.5);
		wait 0.5;
	}
}


trap9()
{
	level endon("trigger");
    trigger = getent("trigger_t9_","targetname");
	object = getent("t9_","targetname");
    trigger waittill ("trigger" , player );
    trigger delete();
	a = getent("t9a","targetname");
	b = getent("t9b","targetname");
	
	{
		a moveX(-256,2.5);
		b moveX(256,2.5);
		wait 4;
		a moveX(256,2.5);
		b moveX(-256,2.5);
		wait 4;		
	}
}


trap10()
{
	level endon("trigger");
trigger = getent("trig_trap10","targetname");
object = getent("trap10","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object moveZ(-176, 3);
object waittill("movedone");
wait 4;
object moveZ(176, 3);
object waittill("movedone");
wait 4;
}
}



trap11()
{
	level endon("trigger");
                      trig = GetEnt("trig_trap11","targetname");
                      brush = GetEnt("trap11","targetname");
			          trig waittill ("trigger" , player );
					  trig delete();

                     {
                              brush rotatePitch(-360,5);
                              wait 1;
                     }
}


trap12()
{
	level endon("trigger");
	part1 = getentarray ("trap12_1" ,"targetname");
	part2 = getentarray ("trap12_2" ,"targetname");
	part3 = getentarray ("trap12_3" ,"targetname");
	part4 = getentarray ("trap12_4" ,"targetname");
	trig = getent ("trig_trap12" , "targetname");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(4);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] moveZ (-192, 1);
				part4[randomInt(part4.size)] moveZ (-192, 1);
				break;
				
		case 1:	
				part3[randomInt(part3.size)] moveZ (-192, 1);
				part2[randomInt(part2.size)] moveZ (-192, 1);
				break;
				
		case 2:	
				part1[randomInt(part1.size)] moveZ (-192, 1);
				part3[randomInt(part3.size)] moveZ (-192, 1);
				break;
				
		case 3:	
				part2[randomInt(part2.size)] moveZ (-192, 1);
				part4[randomInt(part4.size)] moveZ (-192, 1);
				
		default: return;
	}
}



trap13()
{
	level endon("trigger");
trigger = getent("trig_trap13","targetname");
object = getent("trap13","targetname");
killtrigger = getent ("killtrig_13" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveY(-576, 1);
object waittill("movedone");
wait 2;
}
}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


kniferoom()
{
    level.knife_trig = getEnt( "knife", "targetname");
    jump = getEnt( "jumper_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.gun_trig delete();
        level.snipe_trig delete();
        level.old_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        /* [AUTO DELETE] player TakeAllWeapons(); */
        /* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */       
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        /* [AUTO DELETE] level.activ TakeAllWeapons(); */
        /* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */        
        wait 0.05;
        /* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
        /* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
        /* [AUTO DELETE] iPrintlnBold( " ^4" + player.name + " picked ^1KNIFE!" ); */
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}


jumproom()
{
    level.jump_trig = getEnt( "jump", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if(level.firstenter==true)
		{        
	    level.snipe_trig delete();
        level.old_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        /* [AUTO DELETE] player TakeAllWeapons(); */
        /* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */       
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        /* [AUTO DELETE] level.activ TakeAllWeapons(); */
        /* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */        
        /* [AUTO DELETE] wait 0.05; */
        /* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
        /* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
        /* [AUTO DELETE] iPrintlnBold( " ^4" + player.name + " picked ^1JUMP!" ); */
		/* [AUTO DELETE] wait 0.1; */
        // while( isAlive( player ) && isDefined( player ) )
        //     /* [AUTO DELETE] wait 1; */
    }
}


sniperoom()
{
    level.snipe_trig = getEnt( "sniper", "targetname");
    jump = getEnt( "jump_snipe", "targetname" );
    acti = getEnt( "acti_snipe", "targetname" );

    
    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;
			
		if(level.firstenter==true)
		{
                level.old_trig delete();
		level.jump_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
        /* [AUTO DELETE] iPrintlnBold( " ^4" + player.name + " picked ^1SNIPER!" ); */
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        /* [AUTO DELETE] player TakeAllWeapons(); */
	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	wait 0.1;
        /* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
        /* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */
	wait 0.1;
	/* [AUTO DELETE] player GiveWeapon( "M40A3_mp" ); */
	/* [AUTO DELETE] level.activ GiveWeapon( "M40A3_mp" ); */
	wait 0.1;;
	/* [AUTO DELETE] player switchToWeapon( "remington700_mp" ); */
        /* [AUTO DELETE] level.activ SwitchToWeapon( "remington700_mp" ); */
        // while( isAlive( player ) && isDefined( player ) )
        //     wait 1;
    }
}


old()
{
    level.old_trig = getEnt( "old", "targetname");
    jump = getEnt( "jumper_old", "targetname" );
    acti = getEnt( "acti_old", "targetname" );
    
    while(1)
    {
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
        if(level.firstenter==true)
		{
                level.snipe_trig delete();
                level.knife_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );      
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        /* [AUTO DELETE] level.activ TakeAllWeapons(); */
        /* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */        
        /* [AUTO DELETE] wait 0.05; */
        /* [AUTO DELETE] level.activ SwitchToWeapon( "knife_mp" ); */
        /* [AUTO DELETE] iPrintlnBold( " ^4" + player.name + " picked ^1OLD!" ); */
        // while( isAlive( player ) && isDefined( player ) )
        //     /* [AUTO DELETE] wait 1; */
    }
}


jump_weapon()
{
trigger = getent ("weapon_trig","targetname");
{
trigger waittill ("trigger",user);
wait(0.2);    
/* [AUTO DELETE] user giveWeapon( "remington700_mp"); */
/* [AUTO DELETE] user giveMaxammo("remington700_mp"); */
wait 0.1;
/* [AUTO DELETE] user switchToWeapon("remington700_mp"); */
wait 0.1;
}
}


end()
{
trigger = GetEnt( "end", "targetname" );
trigger.targetname = "endmap_trig";
	// {
	// trigger waittill ("trigger", user);
	// trigger delete();
	// 	{
	// 	 [AUTO DELETE] iprintlnbold( "^7" + user.name + " ^1Finished ^41st"); 
	// 	wait 4;
	// 	}
	// }
}



map_by()
{
	hud_creator = newHudElem();
	hud_creator.x = 550;
	hud_creator.y = 400;
	hud_creator.alignX = "center";
	hud_creator.alignY = "middle";
	hud_creator.fontScale = 1.4;
   	hud_creator.color = (.0, .1, 1);
   	hud_creator.font = "objective";
   	hud_creator.glowColor = (.0, .1, 1);
   	hud_creator.glowAlpha = 1;
   	hud_creator.hideWhenInMenu = true;	
	hud_creator setText("Map By eBc|Legend");
}
