//__/\\\\\\\\\\\\\\\______________________________/\\\_______________        
// _\/\\\///////////___________________________/\\\\\\\_______________       
//  _\/\\\_____________________________________\/////\\\_______________      
//  _\/\\\\\\\\\\\____/\\\\\\\\___/\\/\\\\\\_______\/\\\__/\\\____/\\\_     
//    _\/\\\///////___/\\\/////\\\_\/\\\////\\\______\/\\\_\///\\\/\\\/__    
//     _\/\\\_________/\\\\\\\\\\\__\/\\\__\//\\\_____\/\\\___\///\\\/____   
//      _\/\\\________\//\\///////___\/\\\___\/\\\_____\/\\\____/\\\/\\\___  
//       _\/\\\_________\//\\\\\\\\\\_\/\\\___\/\\\_____\/\\\__/\\\/\///\\\_ 
//        _\///___________\//////////__\///____\///______\///__\///____\///__
//

/*
  	 _   ________   ___  __        __   
 	| | / / ___( ) / _ )/ /__ ____/ /__ 
 	| |/ / /__ |/ / _  / / _ `/ _  / -_)
 	|___/\___/   /____/_/\_,_/\_,_/\__/ 

 	© VC' Blade

	Website: vistic-clan.net
*/

main()
{


	// spawn auto placement
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin,
			auto_spawn[int(auto_spawn.size / 2)].angles[1]);

	
thread sr\api\_map::create_normal_way("Normal Way;");

 maps\mp\_load::main();
 
 level.chosen=false;
 
 level._effect[ "prach" ] = loadfx( "treadfx/heli_dust_jeepride" );
 level.bubbles = loadFX("fenix/water_bubbles");
 level.exp_fx = LoadFx("explosions/vehicle_explosion_bmp");
 level.heli_fx = LoadFx("explosions/helicopter_explosion");
  
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
 /* [AUTO DELETE] ambientPlay("song1"); */
 
  setdvar( "r_specularcolorscale", "1" );
  setdvar( "r_glowbloomintensity0", ".25" );
  setdvar( "r_glowbloomintensity1", ".25" );
  setdvar( "r_glowskybleedintensity0", ".3" );
  setdvar( "compassmaxrange", "1800" );
  setDvar("bg_falldamagemaxheight", 20000 );
  setDvar("bg_falldamageminheight", 15000 );
  
  
  precacheItem( "ak74u_mp" );
  
   
	
	
  thread logo();
  thread logo1();
  thread logo2();
  thread bubble_fx();
  thread bubble_fx1();
  thread bubble_fx2();
  thread bubble_fx3();
  thread bubble_fx4();
  thread bubble_fx5();
  thread bubble_fx6();
  thread bubble_fx7();
  thread bubble_fx8();
  thread bubble_fx9();
  thread bubble_fx10();
  thread bubble_fx11();
  thread bubble_fx12();
  thread bubble_fx13();
  thread bubble_fx14();
  thread bubble_fx15();
  thread bubble_fx16();
  thread bubble_fx17();
  thread bubble_fx18();
  thread bubble_fx19();
  thread bubble_fx20();
  thread bubble_fx21();
  thread bubble_fx22();
  thread bubble_fx23();
  thread bubble_fx24();
  thread bubble_fx25();
  thread bubble_fx26();
  thread bubble_fx27();
  thread bubble_fx28();
  thread bubble_fx29();
  thread bubble_fx30();
  thread bubble_fx31();
  thread bubble_fx32();
  thread bubble_fx33();
  thread bubble_fx34();
  thread bubble_fx35();
  thread bubble_fx36();
  thread bubble_fx37();
  thread trap1();
  thread trap2();
  thread trap3();
  thread trap4();
  thread trap5();
  thread trap6();
  thread trap7();
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
  thread startdoor();
  // thread Messages();
  // thread endrooms();
  // thread jump_sniper();
  
  addTriggerToList( "trap1_trig" );
 addTriggerToList( "trap2_trig" );
 addTriggerToList( "trap3_trig" );
 addTriggerToList( "trap4_trig" );
 addTriggerToList( "trap5_trig" ); 
 addTriggerToList( "trap6_trig" ); 
 addTriggerToList( "trap7_trig" ); 
 
	

}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


endrooms()
{
	thread knife();
	thread sniper();
	thread jump();
}


knife()
{
	level.knife=getent("knife","targetname");
	acti=getent("a_knife","targetname");
	jump=getent("j_knife","targetname");

	while(1)
	{
		level.knife sethintstring("Press ^1&&1 ^7to enter the ^1Knife Room");
		level.knife waittill("trigger",player);
		if(!isdefined(level.knife))
			return;

		level.knife sethintstring("Wait your ^1Turn^7.");

		if(!level.chosen)
		{
			level.chosen=true;
			level.sniper delete();
			level.jump delete();
		}

		if(isdefined(level.activ))
		{
			player endroomsetup(jump,"knife_mp",undefined,100,1);
			level.activ endroomsetup(acti,"knife_mp",undefined,100,1);
			endroomannounce("Knife Room",level.activ.name+" vs "+player.name);
			wait 5;
			player freezecontrols(0);
			level.activ freezecontrols(0);
		}
		else 
		{
			player endroomsetup(jump,"knife_mp",undefined,100,1);
			wait 5;
			player freezecontrols(0);
		}

		while(isAlive(player)&&isDefined(player))
            wait 1;

        /* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7has been killed"); */
	}
}


sniper()
{
	level.sniper=getent("sniper","targetname");
	acti=getent("a_room","targetname");
	jump=getent("j_room","targetname");

	while(1)
	{
		level.sniper sethintstring("Press ^1&&1 ^7to enter the ^1Sniper Room");
		level.sniper waittill("trigger",player);
		if(!isdefined(level.sniper))
			return;

		level.sniper sethintstring("Wait your ^1Turn^7.");

		if(!level.chosen)
		{
			level.chosen=true;
			level.knife delete();
			level.jump delete();
		}

		if(isdefined(level.activ))
		{
			player endroomsetup(jump,"m40a3_mp","remington700_mp",100,1);
			level.activ endroomsetup(acti,"remington700_mp","m40a3_mp",100,1);
			endroomannounce("Sniper Room",level.activ.name+" vs "+player.name);
			wait 5;
			player freezecontrols(0);
			level.activ freezecontrols(0);
		}
		else 
		{
			player endroomsetup(jump,"m40a3_mp","remington700_mp",100,1);
			wait 5;
			player freezecontrols(0);
		}

		while(isAlive(player)&&isDefined(player))
            wait 1;

        /* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7has been killed"); */
	}
}


jump()
{
	level.jump=getent("jump","targetname");
	acti=getent("a_jump","targetname");
	jump=getent("j_jump","targetname");

	while(1)
	{
		level.jump sethintstring("Press ^1&&1 ^7to enter the ^1Jump Room");
		level.jump waittill("trigger",player);
		if(!isdefined(level.jump))
			return;

		level.jump sethintstring("Wait your ^1Turn^7.");

		if(!level.chosen)
		{
			level.chosen=true;
			level.knife delete();
			level.sniper delete();
		}

		if(isdefined(level.activ))
		{
			player endroomsetup(jump,"knife_mp",undefined,100,1);
			level.activ endroomsetup(acti,"knife_mp",undefined,100,1);
			endroomannounce("Jump Room",level.activ.name+" vs "+player.name);

			wait 5;
			player freezecontrols(0);
			level.activ freezecontrols(0);
			/* [AUTO DELETE] player iprintlnbold("^1Spinner ^7will start in ^13^7 Seconds"); */
			/* [AUTO DELETE] level.activ iprintlnbold("^1Spinner ^7will start in ^13^7 Seconds"); */
		}
		else 
		{
			player endroomsetup(jump,"knife_mp",undefined,100,1);
			wait 5;
			player freezecontrols(0);
		}

		while(isAlive(player)&&isDefined(player))
            wait 1;

        /* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7has been killed"); */
	}
}


endroomsetup(targ,weap,weap2,health,freeze)
{
	self setorigin(targ.origin);
	self setplayerangles(targ.angles);

	/* [AUTO DELETE] self takeallweapons(); */
	/* [AUTO DELETE] self giveweapon(weap); */
	/* [AUTO DELETE] self switchtoweapon(weap); */
	/* [AUTO DELETE] self givemaxammo(weap); */

	if(isdefined(weap2))
	{
		/* [AUTO DELETE] self giveweapon(weap2); */
		/* [AUTO DELETE] self givemaxammo(weap2); */
	}

	self freezecontrols(freeze);
	self.health=health;
}


endroomannounce(room,message)
{
	noti = SpawnStruct();
    noti.titleText = room;
    noti.notifyText = message;
    noti.duration = 6;
    if(isdefined(level.randomcolor))
    	noti.glowcolor=level.randomcolor;
    else 
    	noti.glowcolor=(0,1,1);
    players = getEntArray("player", "classname");
    for(i=0;i<players.size;i++)
        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
    wait 2;
}



startdoor()
{
   trigger = getEnt("startdoor_trig", "targetname");
   door = getEnt("startdoor", "targetname");
   
   trigger setHintString("^1Press ^7F ^1!");
   trigger waittill("trigger");
   
   /* [AUTO DELETE] iPrintLnBold("^1Startdoor ^7will open in ^15 ^7Seconds"); */
   trigger delete();
   wait (5);
   
   door movez(-484,1);
   wait 1;
   door delete();
   
  hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 5;
	hud_clock.glowcolor = (0.0,0.8,0.0);
	hud_clock.label = &"^7Map by ^1Fen1x!";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 3;
  }

  
Messages()
{
    wait 10;
	/* [AUTO DELETE] iPrintLnBold("Welcome to ^1"+getDvar("mapname")+"^7!"); */
	
    while(1)
    {
		/* [AUTO DELETE] iPrintLn("^1>>^7 Map created by ^1Fen1x!"); */
		wait 5;
		/* [AUTO DELETE] iPrintLn("^1>>^7 Special thanks to ^1VC' Blade ^1VC' ERIK ^1VC' Glen :D^7"); */
		wait 5;
		/* [AUTO DELETE] iPrintLn("^1>>^7 Thanks for playing ^1"+getDvar("mapname")); */
        wait 5;
        /* [AUTO DELETE] iPrintLn("^1>>^7 Visit: ^1vistic-clan.net"); */
        wait 5;
       
    }
}


trap1()
{
	level endon("trigger");
	trig = getent("trap1_trig", "targetname");
	heli = getent("trap1", "targetname");
	hurt = getent("helicopter_trig", "targetname");
	hurt enablelinkto();
	hurt linkto(heli);
	trig sethintstring("Press ^1F^7 To activate heli.");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	trig delete();
	heli movey(2600,3);
	wait 3;
	PlayFX( level.heli_fx, heli.origin );
	heli rotatePitch (70 , .1 );
	heli PlaySound("sound3");
	wait .1;
	heli rotateYaw(720,3);
	heli movez(-768,2);
	wait 2;
	PlayFX( level.exp_fx, heli.origin );
	heli delete();
	wait 2;
	hurt delete();
}


trap2()
{
	level endon("trigger");
	trig = getent("trap2_trig", "targetname");
	trap = getent("trap2", "targetname");
	hurt = getent("trap2_hurt", "targetname");
	hurt enablelinkto();
	hurt linkto(trap);
	trig sethintstring("Press ^1F^7 To raise the spikes.");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	while(1)
	{
		trap movez (88, 2 );
		wait 2;
		trap movez (-88, 2 );
		wait 2;
	}

}


trap3()
{
	level endon("trigger");
	trig = getent("trap3_trig", "targetname");
	trap = getent("trap3", "targetname");
	hurt = getent("trap3_hurt", "targetname");
	hurt enablelinkto();
	hurt linkto(trap);
	trig sethintstring("Press ^1F^7 To activate the spikes.");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	{
		trap movey (208, 2 );
		trap waittill("movedone");
		wait 0.5;
		trap movey (-208, 2 );
		trap waittill("movedone");
		wait 0.5;
	}

}


trap4()
{
	level endon("trigger");
	trig = getent("trap4_trig", "targetname");
	mover = getent("trap4_1", "targetname");
	mover1 = getent("trap4_2", "targetname");
	mover2 = getent("trap4_3", "targetname");
	trig sethintstring("Press ^1F^7 to activate trap.");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who );
	wait 0.1;
	mover rotateYaw(360, 2);
	wait 2;
	mover1 rotateYaw(-360, 2);
	wait 2;
	mover2 rotateYaw(360, 2);
	trig delete();
}


trap5()
{
	level endon("trigger");

trig = getEnt( "trap5_trig", "targetname" );
trap5 = getEnt( "trap5", "targetname" );
trig sethintstring("Press ^1F^7 to Activate those lasers.");
trig SetCursorHint("HINT_ACTIVATE");
hurt = getEnt ("trap5_hurt", "targetname"); 
hurt1 = getEnt ("trap5_hurt1", "targetname"); 
hurt2 = getEnt ("trap5_hurt2", "targetname"); 
trap5 hide();
trap5 notsolid();
hurt maps\mp\_utility::triggerOff();
hurt1 maps\mp\_utility::triggerOff();
hurt2 maps\mp\_utility::triggerOff();

 
trig waittill ("trigger");
trig delete();
 
{

    trap5 show();
    hurt maps\mp\_utility::triggerOn();
	hurt1 maps\mp\_utility::triggerOn();
	hurt2 maps\mp\_utility::triggerOn();
    trap5 solid();

    }
}


trap6()
{
	level endon("trigger");
	trig = getent("trap6_trig", "targetname");
	trap = getent("trap6", "targetname");
	trig sethintstring("Press ^1F^7 To activate trap.");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	{
		trap movez (-112, 2 );
		wait 2;
		trap movez (112, 2 );
		wait 2;
	}

}


trap7()
{
	level endon("trigger");
	trig = getent("trap7_trig", "targetname");
	trap = getent("trap7", "targetname");
	trig sethintstring("Press ^1F^7 To delete part of the bridge.");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	{
		trap delete(); 
	}

}




teleport1()
{

	target = getEnt( "teleport1_target", "targetname" );
	trig = getent("teleport1_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport2()
{

	target = getEnt( "teleport2_target", "targetname" );
	trig = getent("teleport2_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport3()
{

	target = getEnt( "teleport3_target", "targetname" );
	trig = getent("teleport3_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport4()
{

	target = getEnt( "teleport4_target", "targetname" );
	trig = getent("teleport4_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport5()
{

	target = getEnt( "teleport5_target", "targetname" );
	trig = getent("teleport5_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport6()
{

	target = getEnt( "teleport6_target", "targetname" );
	trig = getent("teleport6_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}



teleport7()
{

	target = getEnt( "teleport7_target", "targetname" );
	trig = getent("teleport7_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport8()
{

	target = getEnt( "teleport8_target", "targetname" );
	trig = getent("teleport8_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport9()
{

	target = getEnt( "teleport9_target", "targetname" );
	trig = getent("teleport9_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


teleport10()
{

	target = getEnt( "teleport10_target", "targetname" );
	trig = getent("teleport10_trigger", "targetname");
	
	while(1)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
}
}


jump_sniper()
{
    trig = getEnt( "jump_sniper_trigger", "targetname" );

    while(1)
    {
	trig waittill( "trigger", player );
	
	/* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
	/* [AUTO DELETE] player switchToWeapon( "remington700_mp" ); */
	/* [AUTO DELETE] player givemaxammo("remington700_mp"); */	
	wait 1;
}
}


logo()
{
	logo = getent("logo","targetname");
	logo notsolid();
	for(;;)
	{
		x = randomint(2);
		if(x == 1)
		{
			logo rotateyaw(180,2);
		}
		else{
			logo rotateyaw(-180,2);
		}
		wait 2;
	}
}


logo1()
{
	logo = getent("logo1","targetname");
	logo notsolid();
	for(;;)
	{
		x = randomint(2);
		if(x == 1)
		{
			logo rotateyaw(180,2);
		}
		else{
			logo rotateyaw(-180,2);
		}
		wait 2;
	}
}


logo2()
{
	logo = getent("logo2","targetname");
	logo notsolid();
	for(;;)
	{
		x = randomint(2);
		if(x == 1)
		{
			logo rotateyaw(180,2);
		}
		else{
			logo rotateyaw(-180,2);
		}
		wait 2;
	}
}


bubble_fx()
{
	bubbles=spawnfx(level.bubbles,(0,4096,-120));

	triggerfx(bubbles,-15);
}


bubble_fx1()
{
	bubbles=spawnfx(level.bubbles,(-680, 3776, -120));

	triggerfx(bubbles,-15);
}


bubble_fx2()
{
	bubbles=spawnfx(level.bubbles,(672, 3776, -120));

	triggerfx(bubbles,-15);
}


bubble_fx3()
{
	bubbles=spawnfx(level.bubbles,(672, 3776, -120));

	triggerfx(bubbles,-15);
}


bubble_fx4()
{
	bubbles=spawnfx(level.bubbles,(-2976, 5024, 112));

	triggerfx(bubbles,-15);
}


bubble_fx5()
{
	bubbles=spawnfx(level.bubbles,(-2976, 5536, 112));

	triggerfx(bubbles,-15);
}


bubble_fx6()
{
	bubbles=spawnfx(level.bubbles,(-2976, 6048, 112));

	triggerfx(bubbles,-15);
}


bubble_fx7() 
{
	bubbles=spawnfx(level.bubbles,(-2976, 6560, 112));

	triggerfx(bubbles,-15);
}


bubble_fx8() 
{
	bubbles=spawnfx(level.bubbles,(4192, -2272, -120));

	triggerfx(bubbles,-15);
}


bubble_fx9()
{
	bubbles=spawnfx(level.bubbles,(4192, -1504, -120));

	triggerfx(bubbles,-15);
}


bubble_fx10()
{
	bubbles=spawnfx(level.bubbles,(3680, -1376, -120));

	triggerfx(bubbles,-15);
}


bubble_fx11()
{
	bubbles=spawnfx(level.bubbles,(3680, -2272, -120));

	triggerfx(bubbles,-15);
}


bubble_fx12()
{
	bubbles=spawnfx(level.bubbles,(3168, -1376, -120));

	triggerfx(bubbles,-15);
}


bubble_fx13()
{
	bubbles=spawnfx(level.bubbles,(3168, -2272, -120));

	triggerfx(bubbles,-15);
}


bubble_fx14()
{
	bubbles=spawnfx(level.bubbles,(2784, -1856, -120));

	triggerfx(bubbles,-15);
}


bubble_fx15()
{
	bubbles=spawnfx(level.bubbles,(2656, -1376, -120));

	triggerfx(bubbles,-15);
}


bubble_fx16()
{
	bubbles=spawnfx(level.bubbles,(2656, -2272, -120));

	triggerfx(bubbles,-15);
}


bubble_fx17()
{
	bubbles=spawnfx(level.bubbles,(2144, -2304, -120));

	triggerfx(bubbles,-15);
}


bubble_fx18()
{
	bubbles=spawnfx(level.bubbles,(1760, -1888, -120));

	triggerfx(bubbles,-15);
}


bubble_fx19()
{
	bubbles=spawnfx(level.bubbles,(2144, -1376, -120));

	triggerfx(bubbles,-15);
}


bubble_fx20()
{
	bubbles=spawnfx(level.bubbles,(2016, -1184, -120));

	triggerfx(bubbles,-15);
}


bubble_fx21()
{
	bubbles=spawnfx(level.bubbles,(1760, -1376, -120));

	triggerfx(bubbles,-15);
}


bubble_fx22()
{
	bubbles=spawnfx(level.bubbles,(2016, -736, -120));

	triggerfx(bubbles,-15);
}


bubble_fx23()
{
	bubbles=spawnfx(level.bubbles,(1736, -192, -120));

	triggerfx(bubbles,-15);
}


bubble_fx24()
{
	bubbles=spawnfx(level.bubbles,(1984, 288, -120));

	triggerfx(bubbles,-15);
}


bubble_fx25()
{
	bubbles=spawnfx(level.bubbles,(2464, 320, -120));

	triggerfx(bubbles,-15);
}


bubble_fx26()
{
	bubbles=spawnfx(level.bubbles,(1688, 800, -120));

	triggerfx(bubbles,-15);
}


bubble_fx27()
{
	bubbles=spawnfx(level.bubbles,(2208, 800, -120));

	triggerfx(bubbles,-15);
}


bubble_fx28()
{
	bubbles=spawnfx(level.bubbles,(2720, 800, -120));

	triggerfx(bubbles,-15);
}


bubble_fx29()
{
	bubbles=spawnfx(level.bubbles,(3168, 696, -120));

	triggerfx(bubbles,-15);
}


bubble_fx30()
{
	bubbles=spawnfx(level.bubbles,(3616, 800, -120));

	triggerfx(bubbles,-15);
}


bubble_fx31()
{
	bubbles=spawnfx(level.bubbles,(3936, 352, -120));

	triggerfx(bubbles,-15);
}


bubble_fx32()
{
	bubbles=spawnfx(level.bubbles,(4128, 800, -120));

	triggerfx(bubbles,-15);
}


bubble_fx33()
{
	bubbles=spawnfx(level.bubbles,(4512, 608, -120));

	triggerfx(bubbles,-15);
}


bubble_fx34()
{
	bubbles=spawnfx(level.bubbles,(4928, 616, -120));

	triggerfx(bubbles,-15);
}


bubble_fx35()
{
	bubbles=spawnfx(level.bubbles,(4832, 96, -120));

	triggerfx(bubbles,-15);
}


bubble_fx36()
{
	bubbles=spawnfx(level.bubbles,(4864, -416, -120));

	triggerfx(bubbles,-15);
}


bubble_fx37()
{
	bubbles=spawnfx(level.bubbles,(4864, -928, -120));

	triggerfx(bubbles,-15);
}
