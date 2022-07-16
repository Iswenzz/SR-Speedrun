/*			  
  /\\  /\\  
  //\\_//\\     ____
  \_     _/    /   /
   / ^ ^ \    /^^^|
   \_\O/_/    |   |
    /   \_    |   /
    \     \_  /  /
    | | | /  \/ _/
    |_| | \__/_/               				  
	By VC' Fox.
	
	Public release of this map i made private for Vistic
		___    __  _       _______        
	| | / (_)__/ /_(_)___  / ___/ /__ ____ 
	| |/ / (_-< __/ / __/ / /__/ / _ `/ _ \
	|___/_/___|__/_/\__/  \___/_/\_,_/_//_/ 

	Vistic Disord: https://discord.gg/JKwXV3h
*/

main()
{
	maps\mp\_load::main(); 
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

		thread speedrun\_way_name::create_normal_way("Normal Way;");

	level.snow = loadFX("deathrun/red_snow"); playLoopedFX(level.snow, 0.05, (576, 4096, 768)); 	level.snow1 = loadFX("deathrun/red_snow"); playLoopedFX(level.snow1, 0.05, (-704, 6656, 2048));	visionSetNaked("mp_vacant",3.0); 
	setDvar("r_drawDecals","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
 	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998");

	precacheItem("remington700_mp"); 
	precacheItem("m40a3_mp"); 
	precacheItem("knife_mp");
	precacheItem("deserteagle_mp");
	preCacheItem("ak74u_mp");
	precacheItem("m1garand_mp");
	precacheItem("artillery_mp");

  	thread startdoor();
    thread ele();
	thread messages();
	thread music();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread acti_tp1();
	thread acti_tp2();
	thread acti_tp3();
	thread end_map();
	thread sec_enter1();
	thread sec_enter2();
	thread bouncepad1();
	thread bouncepad2();
	thread bouncepad3();
	thread sec_finish1();
	thread sec_finish2();
	thread vip();
	thread el_sec();
	thread trigger_ammo();
	thread garand_room();
	thread sniper_room();
	thread knife_room();
	thread thompson_room();

	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
}



addTriggerToList( name ) 
{
    if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name , "targetname" );
}



music()

{

	

	switch(randomint(6))

	{

		case 0:

			ambientPlay("obscure");

			wait 2;

			break;

		case 1:

			ambientPlay("castles");

			wait 2;

			break;

		case 2:

			ambientPlay("lights");

			wait 2;

			break;

		case 3:

			ambientPlay("ment");

			wait 2;

			break;

		case 4:

			ambientPlay("chamber");

			wait 2;

			break;

		case 5:

			ambientPlay("follow");

			wait 2;

			break;

	}

}



trigger_ammo()

{

	trig = getEnt("trig_ammo", "targetname");



	trig setHintString("^3Refill Ammo");



	while(1)

		{

			trig waittill("trigger", player);

			weap = player GetCurrentWeapon();

			player giveMaxAmmo(weap);	

			player setWeaponAmmoClip(weap,150);

			player playSoundToPlayer("weap_pickup", player);

			player disableWeapons(); 

			wait 3;

			player enableWeapons();

			player switchToWeapon(weap);

		}

}



createhud(messages)

{

hud_start = NewHudElem();

hud_start.alignX = "center";

hud_start.alignY = "middle";

hud_start.horzalign = "center";

hud_start.vertalign = "middle";

hud_start.alpha = 1;

hud_start.x = 0;

hud_start.y = -150;

hud_start.font = "objective";

hud_start.fontscale = 1.6;

hud_start.glowalpha = 1;

hud_start.glowcolor = (0,0,0);

hud_start setText(messages);

hud_start SetPulseFX( 100, 4000, 500 );

wait 9;

	if(isdefined(hud_start))

	hud_start destroy();

}



messages()
{
	for(;;)
	{
	wait 0.1;
	iPrintLn("^7Map Made By: ^3VC'Fox");
	wait 30;
	iPrintLn("^7Discord: ^3VC'Fox#0001"); 
	wait 30;
    iPrintLn("^7Map Made By: ^3VC'Fox");
    wait 28;
	iPrintLn("^3Vistic-Clan");
	wait 20;
	}
}



startdoor()

{

	door = getEnt("startdoor","targetname");

	{

		wait 10;

		iPrintLnBold("^7Map Made By: ^3VC'Fox");

		wait 8;

		door moveZ(-200,4);

		thread createhud("Start Door Opened!");

		wait 4.1;

		door delete();

	}

}



end_map()

{

	trig = getEnt("trig_end","targetname");



	trig waittill("trigger",player);



	trig delete();

	iPrintLn("^3"+ player.name +" ^7Finished First!");	

	player braxi\_rank::giveRankXP( "", 50 );

}



el_sec()
{

	trig = getEnt("trig_el","targetname");

	while(1)
	{
		trig waittill("trigger",player);
		player giveWeapon("ak74u_mp");	
		player giveMaxAmmo("ak74u_mp");	
		player switchToWeapon("ak74u_mp");
		player freezeControls(0);
		player freezeControls(1);
		here = (759, 516, 60);
		player setOrigin(here);
		wait 0.5;
		player freezeControls(0);
		player braxi\_rank::giveRankXP( "", 50);
		player iPrintLnBold("^3ez elevator secret");
	}
}



vip()
{
	while(1)
	{
		trig = getEnt("trig_vip","targetname");
		trig setHintString("^3>> ^7Vistic Members Here ^3<<");
		trig waittill("trigger", player);
		player iPrintLnBold("^3Vistic Discord: ^7discord.gg/JKwXV3h");
		wait 0.1;
	}
}


ele()

{

    ele1 = getEnt("ele1","targetname");

    ele2 = getEnt("ele2","targetname");

    ele3 = getEnt("ele3","targetname");

	ele4 = getEnt("ele4","targetname");

	{

        for(;;)

        {

            ele1 moveX(-1088,3);

            ele2 moveX(1088,3);

            ele3 moveZ(512,3);

			ele4 moveZ(544,3);

            wait 5;

            ele1 moveX(1088,3);

            ele2 moveX(-1088,3);

            ele3 moveZ(-512,3);

			ele4 moveZ(-544,3);

            wait 5;



        }



	}

}



acti_tp1()

{

	trig = getEnt("acti_tp1", "targetname");

	tele1 = getEnt("here_1", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			player freezeControls(1);

			wait 0.01;

			player freezeControls(0);

		}

}



acti_tp2()

{

	trig = getEnt("acti_tp2", "targetname");

	tele1 = getEnt("here_2", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			player freezeControls(1);

			wait 0.01;

			player freezeControls(0);

		}

}



acti_tp3()

{

	trig = getEnt("acti_tp3", "targetname");

	tele1 = getEnt("here_3", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			player freezeControls(1);

			wait 0.01;

			player freezeControls(0);

		}

}



sec_enter1()

{

	trig = getEnt("trig_sec_tp", "targetname");

	tele1 = getEnt("here4", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			player freezeControls(1);

			wait 0.01;

			player freezeControls(0);

		}

}



sec_enter2()

{

	trig = getEnt("sec_enter2", "targetname");

	tele1 = getEnt("here6", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			player freezeControls(1);

			wait 0.01;

			player freezeControls(0);

		}

}







sec_finish1()

{

	trig = getEnt("sec_finish", "targetname");

	tele1 = getEnt("here5", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			rand = RandomIntRange(400, 700);

			player braxi\_rank::giveRankXP("", rand);

			thread createhud("^3"+ player.name +" ^7Finished ^1HARD ^7Secret!");	

			player freezeControls(1);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			wait 0.2;

			player freezeControls(0);

			wait 0.01;

		}

}



sec_finish2()

{

	trig = getEnt("sec_exit2", "targetname");

	tele1 = getEnt("here7", "targetname");



	for(;;)

		{

			trig waittill("trigger", player);

			rand = RandomIntRange(200, 400);

			player braxi\_rank::giveRankXP("", rand);

			thread createhud("^3"+ player.name +" ^7Finished ^5EASY ^7Secret!");	

			player freezeControls(1);

			player setOrigin(tele1.origin);

			player setPlayerAngles(tele1.angles);

			wait 0.2;

			player freezeControls(0);

			wait 0.01;

		}

}



bouncepad1()

{

	trig = getent("bouncepad1", "targetname");

	

	while(1)

	{

    	trig waittill ( "trigger", player );

    	 

	    player thread bounce2();

	}

}



bouncepad2()

{

	trig = getent("bouncepad2", "targetname");

	

	while(1)

	{

    	trig waittill ( "trigger", player );

    	 

	    player thread bounce2();

	}

}



bouncepad3()

{

	trig = getent("bouncepad3", "targetname");

	

	while(1)

	{

    	trig waittill ( "trigger", player );

    	 

	    player thread bounce2();

	}

}



bounce2()

{	

    for(i = 0; i < 4; i++)

	{

	    self.health += 160;

        self finishPlayerDamage(self, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", self.origin, AnglesToForward((-90,0,0)), "head", 0);

	}

}



trap1()

{

	brush = getEnt("trap1","targetname");

	trig = getEnt("trig_trap1","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	player braxi\_rank::giveRankXP( "", 25 );



	brush moveZ(-248,1);

	wait 3;

	brush moveZ(248,1);

	trig delete();

}



trap2()

{

	brush = getEnt("trap2","targetname"); 

	trig = getEnt("trig_trap2","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	trig delete();



	player braxi\_rank::giveRankXP( "", 25 );



	for(;;)

	{

		brush rotateYaw(-360,2);

		wait 5;

		brush rotateYaw(360,2);

		wait 5;

	}

}



trap3()

{

	brush = getEnt("trap3","targetname");

	trig = getEnt("trig_trap3","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	player braxi\_rank::giveRankXP( "", 25 );



	brush delete();

	trig delete();

}





trap4()

{

	brush = getEnt("trap4","targetname");

	trig = getEnt("trig_trap4","targetname");



	brush hide();

	brush notSolid();



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	player braxi\_rank::giveRankXP( "", 25 );



	brush show();

	brush solid();

	trig delete();

	wait 5;

	brush delete();

}



trap5()

{

	brush = getEnt("trap5","targetname");

	brush2 = getEnt("trap5a","targetname");

	trig = getEnt("trig_trap5","targetname");





	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	player braxi\_rank::giveRankXP( "", 25 );



	trig delete();



	brush moveX(-380,0.2);

	brush2 moveX(380,0.2);

	wait 3;

	brush moveX(380,2);

	brush2 moveX(-380,2);	

}





trap6()

{

	brush1 = getEnt("trap6_1","targetname"); 

	brush2 = getEnt("trap6_2","targetname"); 

	brush3 = getEnt("trap6_3","targetname"); 

	brush4 = getEnt("trap6_4","targetname"); 

	trig = getEnt("trig_trap6","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	trig delete();



	player braxi\_rank::giveRankXP( "", 25 );



	for(;;)

	{

		brush1 hide();

		brush1 notSolid();

		brush2 hide();

		brush2 notSolid();

		brush3 hide();

		brush3 notSolid();

		brush4 hide();

		brush4 notSolid();

		wait 2;

		brush1 show();

		brush1 solid();

		wait 2;

		brush2 show();

		brush2 solid();

		brush1 hide();

		brush1 notSolid();

		wait 2;

		brush3 show();

		brush3 solid();

		brush2 hide();

		brush2 notSolid();

		wait 2;

		brush4 show();

		brush4 solid();

		brush3 hide();

		brush3 notSolid();

		wait 2;

		brush4 hide();

		brush4 notSolid();

		wait 2;

		brush1 show();

		brush1 Solid();

		brush2 show();

		brush2 Solid();

		brush3 show();

		brush3 Solid();

		brush4 show();

		brush4 Solid();

		wait 4;

	}

}





trap7()

{

	brush = getEnt("trap7","targetname"); 

	brush2 = getEnt("trap7a","targetname"); 

	

	trig = getEnt("trig_trap7","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	trig delete();



	player braxi\_rank::giveRankXP( "", 25 );



	for(;;)

	{

		brush rotatePitch(-180,1.2);

		brush2 rotatePitch(180,1.2);

		wait 5;

		brush rotatePitch(180,1.2);

		brush2 rotatePitch(-180,1.2);

		wait 5;

		brush rotatePitch(-180,1.2);

		brush2 rotateYaw(180,1.2);

		wait 5;

	}

}





trap8()

{

	brush = getEnt("trap8","targetname"); 

	brush2 = getEnt("trap8a","targetname"); 

	

	trig = getEnt("trig_trap8","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	trig delete();



	player braxi\_rank::giveRankXP( "", 25 );



	for(;;)

	{

		brush moveX(160,0.5);

		brush2 moveX(-160,0.5);

		wait 2;

		brush hide();

		brush2 hide();

		brush moveX(-160,1);

		brush2 moveX(160,1);

		wait 1.2;

		brush show();

		brush2 show();

		wait 4;

	}

}





trap9()

{

	brush = getEnt("trap9","targetname"); 

	brush2 = getEnt("trap9a","targetname"); 

	

	trig = getEnt("trig_trap9","targetname");



	trig setHintString("Press [^5&&1^7] To Activate");



	trig waittill("trigger",player);



	trig delete();



	player braxi\_rank::giveRankXP( "", 25 );



	for(;;)

	{

		brush rotateYaw(-360,1);

		brush2 rotateYaw(360,1);

		wait 3;

		brush rotateYaw(360,1);

		brush2 rotateYaw(-360,1);

		wait 3;

	}

}





knife_room()

{

	while(1)

	{

		level.trigknife = getEnt("trig_knife","targetname");

		acti = getEnt("knife_acti","targetname");

		jump = getEnt("knife_jumper","targetname");

		

		level.trigknife setHintString("^5knife");

		

		level.trigknife waittill("trigger", player);



		noti = SpawnStruct();

		noti.titleText = "^5" + player.name + " ^7Enterd the ^5Knife Room";

		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;

		noti.duration = 5;

		players = getEntArray("player", "classname");

		for(i=0;i<players.size;i++)

		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );



		level.trigthomp delete();

		level.triggarand delete();

		level.trigsniper delete();

		

		player setOrigin (jump.origin);

		player setPlayerAngles (jump.angles);



		level.activ setOrigin (acti.origin);

		level.activ setPlayerAngles (acti.angles);

	

		player takeAllWeapons();

		level.activ takeAllWeapons();

		

		player freezeControls(1);

		level.activ freezeControls(1);

		

		player.maxhealth = 100;

		player.health = player.maxhealth;

		level.activ.maxhealth = 100;

		level.activ.health = level.activ.maxhealth;  

			

		player takeAllWeapons();

		player giveWeapon("knife_mp");

		player switchToWeapon("knife_mp");

		

		level.activ takeAllWeapons();

		level.activ giveWeapon("knife_mp");

		level.activ switchToWeapon("knife_mp");



		wait 5;

		player iPrintLnBold("^7FIGHT!");

		level.activ iPrintLnBold("^7FIGHT!");

		

		player freezeControls(0);

		level.activ freezeControls(0);

	

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )

		wait 0.5;

		

		iPrintLnBold("^5" + player.name + "^7 Has Died!");

		wait 1;

		iPrintLnBold("^7Knife Room Open!");

		player = undefined;

		

	}

}









garand_room()

{

	while(1)

	{

		level.triggarand = getEnt("trig_garand","targetname");

		acti = getEnt("g_acti","targetname");

		jump = getEnt("g_jumper","targetname");

		

		level.triggarand setHintString("^5M1Garand");

		

		level.triggarand waittill("trigger", player);

		

		level.trigthomp delete();

		level.trigknife delete();

		level.trigsniper delete();

		

		noti = SpawnStruct();

		noti.titleText = "^5" + player.name + " ^7Enterd the ^5M1Garand Room";

		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;

		noti.duration = 5;

		players = getEntArray("player", "classname");

		for(i=0;i<players.size;i++)

		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		

		player setOrigin (jump.origin);

		player setPlayerAngles (jump.angles);



		level.activ setOrigin (acti.origin);

		level.activ setPlayerAngles (acti.angles);

	

		player takeAllWeapons();

		level.activ takeAllWeapons();

		

		player freezeControls(1);

		level.activ freezeControls(1);

		

		player.maxhealth = 100;

		player.health = player.maxhealth;

		level.activ.maxhealth = 100;

		level.activ.health = level.activ.maxhealth;  

			

		player takeAllWeapons();

		player giveWeapon("m1garand_mp");

		player giveMaxAmmo("m1garand_mp");

		player switchToWeapon("m1garand_mp");

		

		level.activ takeAllWeapons();

		level.activ giveWeapon("m1garand_mp");

		level.activ giveMaxAmmo("m1garand_mp");

		level.activ switchToWeapon("m1garand_mp");



		wait 5;

		player iPrintLnBold("^7FIGHT!");

		level.activ iPrintLnBold("^7FIGHT!");

		

		player freezeControls(0);

		level.activ freezeControls(0);

	

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )

		wait 0.5;

		

		iPrintLnBold("^3" + player.name + "^5 Has Died!");

		wait 1;

		iPrintLnBold("^7M1Garand Room Open!");

		player = undefined;

	}

}



thompson_room()

{

	while(1)
	{

		level.trigthomp = getEnt("trig_thom","targetname");

		acti = getEnt("g_acti","targetname");

		jump = getEnt("g_jumper","targetname");

		

		level.trigthomp setHintString("^5Thompson");

		

		level.trigthomp waittill("trigger", player);

		

		level.trigknife delete();

		level.triggarand delete();

		level.trigsniper delete();

		

		noti = SpawnStruct();

		noti.titleText = "^5" + player.name + " ^7Enterd the ^5Thompson Room";

		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;

		noti.duration = 5;

		players = getEntArray("player", "classname");

		for(i=0;i<players.size;i++)

		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		

		player setOrigin (jump.origin);

		player setPlayerAngles (jump.angles);



		level.activ setOrigin (acti.origin);

		level.activ setPlayerAngles (acti.angles);

	

		player takeAllWeapons();

		level.activ takeAllWeapons();

		

		player freezeControls(1);

		level.activ freezeControls(1);

		

		player.maxhealth = 100;

		player.health = player.maxhealth;

		level.activ.maxhealth = 100;

		level.activ.health = level.activ.maxhealth;  

			

		player takeAllWeapons();

		player giveWeapon("artillery_mp");

		player giveMaxAmmo("artillery_mp");

		player switchToWeapon("artillery_mp");

		

		level.activ takeAllWeapons();

		level.activ giveWeapon("artillery_mp");

		level.activ giveMaxAmmo("artillery_mp");

		level.activ switchToWeapon("artillery_mp");



		wait 5;

		player iPrintLnBold("^7FIGHT!");

		level.activ iPrintLnBold("^7FIGHT!");

		

		player freezeControls(0);

		level.activ freezeControls(0);

	

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )

		wait 0.5;

		

		iPrintLnBold("^3" + player.name + "^5 Has Died!");

		wait 1;

		iPrintLnBold("^7Thompson Room Open!");

		player = undefined;

	}

}





sniper_room()

{

	while(1)

	{

		level.trigsniper = getEnt("trig_sniper","targetname");

		acti = getEnt("s_acti","targetname");

		jump = getEnt("s_jumper","targetname");

		

		level.trigsniper setHintString("^5Sniper");

		

		level.trigsniper waittill("trigger", player);

		

		level.trigthomp delete();

		level.trigknife delete();

		level.triggarand delete();

		

		noti = SpawnStruct();

		noti.titleText = "^5" + player.name + " ^7Enterd the ^5Sniper Room";

		noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;

		noti.duration = 5;

		players = getEntArray("player", "classname");

		for(i=0;i<players.size;i++)

		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		

		player setOrigin (jump.origin);

		player setPlayerAngles (jump.angles);



		level.activ setOrigin (acti.origin);

		level.activ setPlayerAngles (acti.angles);

	

		player takeAllWeapons();

		level.activ takeAllWeapons();

		

		player freezeControls(1);

		level.activ freezeControls(1);

		

		player.maxhealth = 100;

		player.health = player.maxhealth;

		level.activ.maxhealth = 100;

		level.activ.health = level.activ.maxhealth;  

			

		player takeAllWeapons();

		player giveWeapon("remington700_mp");

		player giveMaxAmmo("remington700_mp");

		player giveWeapon("m40a3_mp");

		player giveMaxAmmo("m40a3_mp");

		player switchToWeapon("m40a3_mp");

		

		level.activ takeAllWeapons();

		level.activ giveWeapon("remington700_mp");

		level.activ giveMaxAmmo("remington700_mp");

		level.activ giveWeapon("m40a3_mp");

		level.activ giveMaxAmmo("m40a3_mp");

		level.activ switchToWeapon("m40a3_mp");



		wait 5;

		player iPrintLnBold("^7FIGHT!");

		level.activ iPrintLnBold("^7FIGHT!");

		

		player freezeControls(0);

		level.activ freezeControls(0);

	

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )

		wait 0.5;

		

		iPrintLnBold("^3" + player.name + "^5 Has Died!");

		wait 1;

		iPrintLnBold("^7Sniper Room Open!");

		player = undefined;

		

	}

}

