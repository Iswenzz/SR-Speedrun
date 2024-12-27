// __/\\\________/\\\_______________________________________________________________________/\\\\\\\\\__/\\\\\\_________________________________
//  _\/\\\_______\/\\\____________________________________________________________________/\\\////////__\////\\\_________________________________
//   _\//\\\______/\\\___/\\\__________________/\\\_______/\\\___________________________/\\\/______________\/\\\_________________________________
//   __\//\\\____/\\\___\///___/\\\\\\\\\\__/\\\\\\\\\\\_\///______/\\\\\\\\____________/\\\________________\/\\\_____/\\\\\\\\\_____/\\/\\\\\\___
//    ___\//\\\__/\\\_____/\\\_\/\\\//////__\////\\\////___/\\\___/\\\//////____________\/\\\________________\/\\\____\////////\\\___\/\\\////\\\__
//     ____\//\\\/\\\_____\/\\\_\/\\\\\\\\\\____\/\\\______\/\\\__/\\\___________________\//\\\_______________\/\\\______/\\\\\\\\\\__\/\\\__\//\\\_
//      _____\//\\\\\______\/\\\_\////////\\\____\/\\\_/\\__\/\\\_\//\\\___________________\///\\\_____________\/\\\_____/\\\/////\\\__\/\\\___\/\\\_
//       ______\//\\\_______\/\\\__/\\\\\\\\\\____\//\\\\\___\/\\\__\///\\\\\\\\______________\////\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_\/\\\___\/\\\_
//        _______\///________\///__\//////////______\/////____\///_____\////////__________________\/////////__\/////////___\////////\//__\///____\///__

/*
  _   ________   ____
 | | / / ___( ) / __/__ ___ _
 | |/ / /__ |/ _\ \/ _ `/  ' \
 |___/\___/   /___/\_,_/_/_/_/

 © VC' Sam

*/

main()
{
	maps\mp\_load::main();

	//ambientplay("sam");

	level.sam="d2d68587";
    level.blade="c409ae43";

    game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-3581, -249, 60), 270);

	//precache things
	precacheItem("ak74u_mp");
	precacheItem("knife_mp");
    precacheItem("remington700_mp");

	// Blade shiet
	level.mapsam="mp_vc_sam";
	level.mapper="^1Map by^7 VC' Sam";

	//stuff
	thread sr_sec_enter();
	//thread credits();
	//thread hud_mapper();
	//thread hud_room();
	//thread jumphelp();
	//thread jumphelp1();
	//thread creatorzor();
	//secrets
	//thread secret_wep();
	//thread secret_1();
	//thread secret_2();
	//thread entersecret();
	thread secret_end();
	//teles
	//thread spawnteleport();
	thread room1teleport();
	//thread actitele1();
	//thread actiroom2speed();
	thread endtele();
	//doors
	thread startdoor();
	//traps
	//thread trap1();
	//thread trap2();
	//thread trap3();
	thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	// Rooms
	//thread sniper();
	//thread knife();
	//thread bounce();
	//thread jumpfail();
	//thread jump_wep();

	addQueueTrigger("sniper");
	addQueueTrigger("knife");
	addQueueTrigger("bounce");


	// Freerun
	addtriggertolist("trap1_trig");
	addtriggertolist("trap2_trigger");
	addtriggertolist("trap3_trigger");
	addtriggertolist("trap4_trig");
	addtriggertolist("trap5_trig");
	addtriggertolist("trap6_trig");
	addtriggertolist("trap7_trig");
	addtriggertolist("trap8_trig");
}

// Freerun Delete just in case for AFK Activator
addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

//stuff
sr_sec_enter()
{
	trig = spawn("trigger_radius",(-3411.79, -249.257, 0.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("secret","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}
sr_tp_safe(ori)
{
	self endon("death");
	self endon("disconnect");

	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
credits()
{
	wait 30;
	iPrintLn ("^1Welcome to ^7"+level.mapsam);
	wait 8;
	iPrintLn (level.mapper);
	wait 8;
	iPrintLn ("^1www^7.^1vistic^7-^1clan^7.^1com");
	wait 8;
	iPrintLn ("^1Huge thanks to ^7VC' Blade^1!");
	wait 8;
	iPrintLn ("^1Made For ^7Vistic Clan^1!");
}

hud_mapper()
{
    info = newHudElem();
	info.x = 25;
	info.y = -200;
	info.horzAlign = "left";
	info.vertAlign = "middle";
	info.alignX = "left";
	info.alignY = "middle";
	info.font = "objective";
	info.sort = 102;
	info.alpha = 1;
	info.fontScale = 1.4;
	info.glowColor = (0.3, 0.6, 0.3);
	info.glowAlpha = 1;
	info settext(level.mapper);
}

hud_room()
{
	level.room = newHudElem();
	level.room.x = 25;
	level.room.y = -186;
	level.room.horzAlign = "left";
	level.room.vertAlign = "middle";
	level.room.alignX = "left";
	level.room.alignY = "middle";
	level.room.font = "objective";
	level.room.sort = 102;
	level.room.alpha = 0;
	level.room.fontScale = 1.4;
	level.room.glowColor = (0.3, 0.6, 0.3);
	level.room.glowAlpha = 1;
	level.room.label = &"^1Chosen Endgame:^7 ";
}

jumphelp()
{
	trig=getEnt("jumphelp","targetname");
	trig sethintstring("^1This Room ^7ONLY ^1Requires ^7125 FPS^1!");
}

jumphelp1()
{
	trig=getEnt("jumphelp1","targetname");
	trig sethintstring("^1This Room ^7ONLY ^1Requires ^7125 FPS^1!");
}

creatorzor()
{
level waittill( "connected", player );

vc = getSubStr(player getGuid(), 24, 32);

     if((vc==level.sam))
    {
        wait 3;
        //thread braxi\_slider::madebyduff( 800, 0.8, -1, "VC' Sam is online" );
        //thread braxi\_slider::madebyduff( 800, 0.8, 1, "VC' Sam is online" );
    }
     if((vc == level.blade))
    {
        wait 3;
       // thread braxi\_slider::madebyduff( 800, 0.8, -1, "VC' Blade is online" );
        //thread braxi\_slider::madebyduff( 800, 0.8, 1, "VC' Blade is online" );
    }
}

//secrets

secret_wep()
{
	trig=getEnt("secret_wep","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		player GiveWeapon("ak74u_mp");
		player GiveMaxAmmo("ak74u_mp");
		player iPrintln("^1Keep it quiet^1!");
	}
}

secret_1()
{
	step1=getEnt("ss1","targetname");
	trig=getEnt("secret_1","targetname");

	trig waittill("trigger",player);
	player iPrintln ("^1:^7troll^1:");

	step1 hide();
	step1 notsolid();
}

secret_2()
{
	step2=getEnt("ss2","targetname");
	trig=getEnt("secret_2","targetname");

	trig waittill("trigger",player);
	player iPrintln ("^1k^7.");

	step2 hide();
	step2 notsolid();
}

entersecret()
{
	trig=getEnt("secret_entry","targetname");
	secret=getEnt("secret","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles( secret.angles );
		player setOrigin(secret.origin);
		player iPrintlnBold ("^1Welcome To ^7Blade's ^1Secret!");
	}
}

secret_end()
{
	trig=getEnt("secret_end","targetname");
	endorigin=getEnt("endorigin","targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

//teles

spawnteleport()
{
	trig=getEnt("spawn_tele","targetname");
	spawnteleport=getEnt("spawn_origin","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(spawnteleport.origin);
	}
}

room1teleport()
{
	trig=getEnt("room1_tele","targetname");
	room1teleleport=getEnt("room2_origin","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(room1teleleport.origin);
		player SetPlayerAngles(room1teleleport.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

actitele1()
{
	trig=getEnt("actitele1","targetname");
    actiroom2=getEnt("actiroom2","targetname");
    trig sethintstring("^1Next Area^7!");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(actiroom2.origin);
	}
}

actiroom2speed()
{

}

endtele()
{
	trig=getEnt("endtrig","targetname");
	endorigin=getEnt("endorigin","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(endorigin.origin);
		player SetPlayerAngles(endorigin.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

//doors

startdoor()
{
	door=getEnt("startdoor","targetname");
	trig=getEnt("startdoor_trig","targetname");

	door delete();
}

//traps

trap1()
{
	trap1a=getEnt("trap1a","targetname");
	trap1b=getEnt("trap1b","targetname");
	trig=getEnt("trap1_trig","targetname");
	trig sethintstring("^1Trap 1^7!");
	trig waittill("trigger");
	trig delete();

	wait 1;

	h = randomint(2);
	if(h == 0)
	{
		trap1a hide();
		trap1a notsolid();
	}
	if(h == 1)
	{
		trap1b hide();
		trap1b notsolid();
	}

}

trap2()
{
	trap2top=getEnt("trap2_top","targetname");
	trap2bottom=getEnt("trap2_bottom","targetname");
	trig=getEnt("trap2_trigger","targetname");
	trig sethintstring("^1Trap 2^7!");
	trig waittill("trigger");
	trig delete();

	{
		trap2top movez(-192, 0.35);
		trap2bottom movez(192, 0.35);
	}
}

trap3()
{
	trap3=getEnt("trap3","targetname");
	trig=getEnt("trap3_trigger","targetname");
	trig sethintstring("^1Trap 3^7!");
	trig waittill("trigger");
	trig delete();

    while(1)
	{
		movh = floor(randomint(320));
		if(movh < 64)
			movh = 64;
		movt = floor(randomint(5));
		if(movt < 2)
			movt = 1.5;
		rott = floor(randomint(3));
		if(rott < 2)
			rott = 1.5;
		dir = floor(randomint(2));
		if(dir == 2)
			rotd = 360;
		else
			rotd = -360;

		trap3 rotateyaw(rotd, rott);
		if(movt > rott)
			wait(movt + 0.5);
		else
			wait(rott + 0.5);
		trap3 rotateyaw(rotd * -1, rott);
		if(movt > rott)
			wait(movt + 0.5);
		else
			wait(rott + 0.5);
	}
}

trap4()
{
	trap4=getEnt("trap4","targetname");
	trig=getEnt("trap4_trig","targetname");


	trap4 delete();

}

trap5()
{
	trap5=getEnt("trap5","targetname");
	trig=getEnt("trap5_trig","targetname");
	trig sethintstring("^1Trap 5^7!");
	trig waittill("trigger");
	trig delete();


	trap5 movez(80, 1);
	wait 1;
	trap5 movez(-160, 2);
	wait 2;
	trap5 delete();

}

trap6()
{
	trap6=getEnt("trap6","targetname");
	trig=getEnt("trap6_trig","targetname");
	trig sethintstring("^1Trap 6^7!");
	trig waittill("trigger");
	trig delete();

	trap6 movez (88, 1.5);
	wait 1.5;

	while(1)
	{
		trap6 movez(-120, 2.5);
		wait 2.5;
		trap6 movez(120, 1.5);
		wait 1.5;
	}

}

trap7()
{
	trap7a=getEnt("trap7a","targetname");
	trap7b=getEnt("trap7b","targetname");
	trig=getEnt("trap7_trig","targetname");
	trig sethintstring("^1Trap 7^7!");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap7a rotateyaw(360, 3);
		trap7b rotateyaw(-360, 3);
		wait 3;
	}
}

trap8()
{
	trap8a=getEnt("trap8a","targetname");
	trap8b=getEnt("trap8b","targetname");
	trig=getEnt("trap8_trig","targetname");
	trig sethintstring("^1Trap 8^7!");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap8a movey(608, 3);
		trap8b movey(-608, 3);
		wait 3;
		trap8a movey(-608, 2);
		trap8b movey(608, 2);
		wait 2;
	}
}

//rooms

sniper()
{
	level.sniper = getEnt("sniper","targetname");
	acti = getEnt("s_acti","targetname");
	jump = getEnt("s_jump","targetname");
	level.sniper sethintstring("^1Enter The ^7Sniper Room^1!");
	level.chosen = true;
	while(1)
	{
		level.sniper waittill("trigger",player);
		if(!isDefined(level.sniper))
			return;



		if(level.chosen==true)
		{
			level.room.alpha = 1;
			level.room settext("Sniper Room");
			level.knife delete();
			level.bounce delete();
		}

		if(isDefined(level.activ))
		{
			player FreezeControls(1);
			level.activ FreezeControls(1);

			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );

	        player takeallweapons();
	        level.activ takeallweapons();

	        wait 5;

	        player weaponsetup("remington700_mp");
	        level.activ weaponsetup("remington700_mp");

			player FreezeControls(0);
			level.activ FreezeControls(0);
		}
		else
		{
			player FreezeControls(1);
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player takeallweapons();
	        wait 5;
	        player weaponsetup("remington700_mp");
			player FreezeControls(0);
		}

        while(isAlive(player)&&isDefined(player))
            wait 1;
        iPrintlnBold( player.name+" ^1has been killed" );
	}
}

knife()
{
	level.knife = getEnt("knife","targetname");
	acti = getEnt("k_acti","targetname");
	jump = getEnt("k_jump","targetname");
	level.knife sethintstring("^1Enter The ^7Knife Room^1!");
	level.chosen = true;
	while(1)
	{
		level.knife waittill("trigger",player);
		if(!isDefined(level.knife))
			return;



		if(level.chosen==true)
		{
			level.room.alpha = 1;
			level.room settext("Knife Room");
			level.sniper delete();
			level.bounce delete();
		}

		if(isDefined(level.activ))
		{
			player FreezeControls(1);
			level.activ FreezeControls(1);

			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );

	        player takeallweapons();
	        level.activ takeallweapons();

	        wait 5;

	        player weaponsetup("knife_mp");
	        level.activ weaponsetup("knife_mp");

			player FreezeControls(0);
			level.activ FreezeControls(0);
		}
		else
		{
			player FreezeControls(1);
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player takeallweapons();
	        wait 5;
	        player weaponsetup("knife_mp");
			player FreezeControls(0);
		}

        while(isAlive(player)&&isDefined(player))
            wait 1;
        iPrintlnBold( player.name+" ^1has been killed" );
	}
}

bounce()
{
	level.bounce = getEnt("bounce","targetname");
	acti = getEnt("b_acti","targetname");
	jump = getEnt("b_jump","targetname");
	level.bounce sethintstring("^1Enter The ^7Bounce Room^1!");
	level.chosen = true;
	while(1)
	{
		level.bounce waittill("trigger",player);
		if(!isDefined(level.bounce))
			return;




		if(level.chosen==true)
		{
			level.room.alpha = 1;
			level.room settext("Bounce Room");
			level.sniper delete();
			level.knife delete();
		}

		if(isDefined(level.activ))
		{
			player FreezeControls(1);
			level.activ FreezeControls(1);

			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );

	        player takeallweapons();
	        level.activ takeallweapons();

	        wait 5;

	        player weaponsetup("knife_mp");
	        level.activ weaponsetup("knife_mp");

			player FreezeControls(0);
			level.activ FreezeControls(0);
		}
		else
		{
			player FreezeControls(1);
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player takeallweapons();
	        wait 5;
	        player weaponsetup("knife_mp");
			player FreezeControls(0);
		}

        while(isAlive(player)&&isDefined(player))
            wait 1;
        iPrintlnBold( player.name+" ^1has been killed" );
	}
}

jumpfail()
{
	trig = getEnt("jump_fail","targetname");
	acti = getEnt( "b_acti", "targetname" );
	jump = getEnt( "b_jump", "targetname" );
	for(;;)
	{
		trig waittill("trigger",player);

		if(player.pers["team"] != "spectator")
		{
			if(player.pers["team"] == "allies")
			{
				player SetPlayerAngles(jump.angles);
				player SetOrigin(jump.origin);
			}
			if(player.pers["team"] == "axis")
			{
				player SetPlayerAngles(acti.angles);
				player SetOrigin(acti.origin);
			}
		}
	}
}

jump_wep()
{
	trig = getEnt("jump_wep","targetname");
	trig sethintstring("^1Take A ^7Sniper^1!");
	while(1)
	{
		trig waittill("trigger",player);
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player SwitchToWeapon("remington700_mp");
	}
}

weaponsetup(weap)
{
	self takeallweapons();
	self giveweapon(weap);
	self switchtoweapon(weap);
}

	addQueueTrigger(name)
    {
        if(!isdefined(level.queue_triggers))
            level.queue_triggers = [];

        level.queue_triggers[level.queue_triggers.size] = getent(name,"targetname");
    }