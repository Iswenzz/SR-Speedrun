/*
_____________________________________________
|_____/  ___/    __ /   ___/\ ______//  ___  \
|___ /  /__     /___   /____\\ ____//  /  /  /
|___/  ___/  __    /  ___/   \\ __//  /  /  /
|__/  /__   /_/   /	 /________\\_//  /__/  /
|__\____/________/_____/	   \\/________/
*/
main()
{
trigger = spawn("trigger_radius", (-10213, 2535.82, -1423.88), 0, 110, 120);
trigger.targetname = "endmap_trig";
trigger.radius = 110;
	level._effect["default_explosion"] = loadfx( "explosions/default_explosion" );
	level._effect["start"] = loadfx( "xm/start" );

	maps\mp\_load::main();

	precacheItem("ak47_mp");
	precacheItem("ak74u_mp");
	precacheItem("g3_mp");
	precacheItem("m21_mp");
	precacheItem("mp5_mp");
	precacheItem("p90_mp");
	precacheItem("rpg_mp");
	precacheItem("deserteagle_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	
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
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
	// ambientplay("xm");

	// thread msgs();
	thread way_connect();
	thread startele();
	thread spiner1();
	thread spiner2();
	// thread acti_tele1();
	// thread acti_tele2();
	// thread acti_tele3();
	thread player_tele1();
	//thread madeby();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();

	// thread sniperoom();
	// thread kniferoom();
	// thread weaponroom();
	// thread bounceroom();
	// thread jumperfail();
	// thread actifail();
	// thread bounceweapon();
	// thread bouncesnip_model();

	// thread secretopen();
	// thread secretfail1();
	// thread secretfail2();
	// thread secretend();
	//thread mapfinished();

	// thread CheckIPAdress();
	// thread initMusic();
	// thread musictrig();

	level.circ1 = getent("trap11_1","targetname");
	level.circ2 = getent("trap11_2","targetname");
	
	level.circ1 notsolid();
	level.circ1 hide();
	level.circ2 notsolid();
	level.circ2 hide();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

msgs()
{
	while(1)
	{
		wait 5;
		iprintln("^5Join our server ip = ^7gs1.gpanel.eu:27256");
		wait 10;
		iprintln("^5Map created for x^6M^5 server");
		wait 20;
	}
}

startele()
{
	object = getent("startele","targetname");
	object delete();
}

spiner1()
{
	object1 = getent("up","targetname");
	for(;;)
	{
		object1 moveZ(560,5);
		object1 waittill("movedone");
		wait .1;
		object1 moveZ(-560,5);
		object1 waittill("movedone");
		wait .1;
	}
}

spiner2()
{
	object2 = getent("down","targetname");
	while(1)
	{
		object2 moveZ(-560,5);
		object2 waittill("movedone");
		wait .1;
		object2 moveZ(560,5);
		object2 waittill("movedone");
		wait .1;
	}
}

somespeed()
{ 
trigger = getent("super_speed","targetname");  
while(1)
{
trigger waittill ("trigger",player);
while(player isOnGround())
{
   player SetMoveSpeedScale(10);
   wait(.05);
}
player SetMoveSpeedScale(1.1);
wait(0.1);
}
}

//////////////////////////////////////////////////////

madeby()
{
	hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 0;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "default";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (1.0, 1.0, 1.0);
	hud_clock.label = &"Hello and Welcome to ^5x^6M ^7Map!";
	hud_clock fadeovertime(2);
	hud_clock.alpha = 1;
	wait 15;
	hud_clock fadeovertime(2);
	hud_clock.alpha = 0;
	wait 2;
	hud_clock destroy();

	while(1)
	{

	hud_clock2 = NewHudElem();
	hud_clock2.alignX = "center";
	hud_clock2.alignY = "top";
	hud_clock2.horzalign = "center";
	hud_clock2.vertalign = "top";
	hud_clock2.alpha = 0;
	hud_clock2.x = 0;
	hud_clock2.y = 0;
	hud_clock2.font = "default";
	hud_clock2.fontscale = 2;
	hud_clock2.glowalpha = 1;
	hud_clock2.glowcolor = (1,0,0);
	hud_clock2.label = &"Map Creator eBc|Legend";
	hud_clock2 fadeovertime(2);
	hud_clock2.alpha = 1;
	wait 15;
	hud_clock2 fadeovertime(2);
	hud_clock2.alpha = 0;
	wait 2;
	hud_clock2 destroy();

	hud_clock3 = NewHudElem();
	hud_clock3.alignX = "center";
	hud_clock3.alignY = "top";
	hud_clock3.horzalign = "center";
	hud_clock3.vertalign = "top";
	hud_clock3.alpha = 0;
	hud_clock3.x = 0;
	hud_clock3.y = 0;
	hud_clock3.font = "default";
	hud_clock3.fontscale = 2;
	hud_clock3.glowalpha = 1;
	hud_clock3.glowcolor = (0.0, 1.0, 1.0);
	hud_clock3.label = &"Report bugs to eBc|Legend";
	hud_clock3 fadeovertime(2);
	hud_clock3.alpha = 1;
	wait 15;
	hud_clock3 fadeovertime(2);
	hud_clock3.alpha = 0;
	wait 2;
	hud_clock3 destroy();

	hud_clock4 = NewHudElem();
	hud_clock4.alignX = "center";
	hud_clock4.alignY = "top";
	hud_clock4.horzalign = "center";
	hud_clock4.vertalign = "top";
	hud_clock4.alpha = 0;
	hud_clock4.x = 0;
	hud_clock4.y = 0;
	hud_clock4.font = "default";
	hud_clock4.fontscale = 2;
	hud_clock4.glowalpha = 1;
	hud_clock4.glowcolor = (0.0, 0.8, 0.0);
	hud_clock4.label = &"Have fun and enjoy";
	hud_clock4 fadeovertime(2);
	hud_clock4.alpha = 1;
	wait 15;
	hud_clock4 fadeovertime(2);
	hud_clock4.alpha = 0;
	wait 2;
	hud_clock4 destroy();
	wait .5;
	}
}

//////////////////////////////////////////////////////

acti_tele1()
{
	trig = getent("acti_tele1","targetname");
	spot = getent("acti1_telespot","targetname");
	trig waittill("trigger", player );
	{
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		wait .1;
	}
}

acti_tele2()
{
	trig = getent("acti_tele2","targetname");
	spot = getent("acti2_telespot","targetname");
	trig waittill("trigger", player );
	{
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		wait .1;
	}
}

acti_tele3()
{
	trig = getent("acti_tele3","targetname");
	spot = getent("acti3_telespot","targetname");
	trig waittill("trigger", player );
	{
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		wait .1;
	}
}

player_tele1()
{
	trig = getent("player_tele1","targetname");
	spot = getent("player_telespot1","targetname");
	for(;;)
	{
		trig waittill("trigger", player );
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
	}
}

//////////////////////////////////////////////////////

trap1()
{
trigger = getent("trap1_trig","targetname");
trigger sethintstring("Press ^1[USE]^7 To Activate");
level.wallpush = getent("trap1","targetname");
killtrigger = getent ("trap1_killtrig" , "targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (level.wallpush);
level.wallpush moveY(-672, 3);
level.wallpush waittill("movedone");
level.wallpush delete();
killtrigger delete();
}
}

trap2()
{
	trig = getent("trap2_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	object = getent("trap2","targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		object notsolid();
		object hide();
		wait 3;
		object show();
		object solid();
		wait 1;
		object notsolid();
		object hide();
		wait 4;
		object show();
		object solid();
	}
}

trap3()
{
	trig = getent("trap3_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	object1 = getent("trap3_1","targetname");
	object2 = getent("trap3_2","targetname");
	object3 = getent("trap3_3","targetname");
	object4 = getent("trap3_4","targetname");
	trig waittill("trigger", user );
	trig delete();
	while(1)
	{
		object1 rotatePitch(360, 3);
		object2 rotatePitch(-360, 3);
		object3 rotatePitch(360, 3);
		object4 rotatePitch(-360, 3);
		wait .05;
	}
}

trap4()
{
	trig = getent("trap4_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	object = getent("trap4","targetname");
	killtrigger = getent ("trap4_killtrig" , "targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object rotateRoll(360, 4);
		wait 4.1;
		object rotateRoll(360, 4);
	}
}

trap5()
{
	trig = getent("trap5_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	object = getent("trap5","targetname");
	killtrigger = getent ("trap5_killtrig" , "targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object moveX(-656, 4);
		wait 5;
		object moveZ(-144, 2);
	}
}

trap6()
{
	trig = getent("trap6_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	object1 = getent("trap6_1","targetname");
	object2 = getent("trap6_2","targetname");
	trig waittill("trigger", user );
	trig delete();
	while(1)
	{
		object1 rotateRoll(120, 1, .5);
		object2 rotateRoll(-120, 1, .5);
		wait 1;
		object1 rotateRoll(-120, 1, .5);
		object2 rotateRoll(120, 1, .5);
		wait 1;
	}
}

trap7()
{
	part1 = getentarray ("trap7_1" ,"targetname");
	part2 = getentarray ("trap7_2" ,"targetname");
	part3 = getentarray ("trap7_3" ,"targetname");
	part4 = getentarray ("trap7_4" ,"targetname");
	trig = getent ("trap7_trig" , "targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(4);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] delete();
				part4[randomInt(part4.size)] delete();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] delete();
				part3[randomInt(part3.size)] delete();	
				break;

		case 2:
				part1[randomInt(part1.size)] delete();
				part3[randomInt(part3.size)] delete();
				break;
		case 3: 
				part2[randomInt(part2.size)] delete();
				part4[randomInt(part4.size)] delete();
				
		default: return;
	}
}

trap8()
{
	trig = getent("trap8_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	object = getent("trap8","targetname");
	killtrigger = getent ("trap8_killtrig" , "targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		killtrigger enablelinkto ();
		killtrigger linkto (object);
		object moveY(208, 1);
		wait 2;
		object moveY(-208, 2);
	}
}

trap9()
{
	trig = getent("trap9_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	c4_1_m = getent("c4_1","targetname");
	c4_2_m = getent("c4_2","targetname");
	c4_3_m = getent("c4_3","targetname");
	c4_4_m = getent("c4_4","targetname");
	trig waittill("trigger", player);

	x = randomint(10);

	if(x < 8 && x > 10)
	{
		RadiusDamage( c4_1_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_1_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2464, -766));
		c4_1_m playsound("mine");
		c4_1_m hide();
		trig waittill("trigger", player);
		RadiusDamage( c4_2_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_2_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2720, -766));
		c4_2_m playsound("mine");
		c4_2_m hide();
		trig delete();
	}
	else
		trig sethintstring("^1Trap isnt possible to activate!");

	if (x > 2)
	{
		RadiusDamage( c4_1_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_1_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2464, -766));
		c4_1_m playsound("mine");
		c4_1_m hide();
		trig waittill("trigger", player);
		RadiusDamage( c4_3_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_3_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3904, 2720, -766));
		c4_3_m playsound("mine");
		c4_3_m hide();
		trig delete();
	}
	else
		trig sethintstring("^1Trap isnt possible to activate!");

	if (x < 5)
	{
		RadiusDamage( c4_2_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_2_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2720, -766));
		c4_2_m playsound("mine");
		c4_2_m hide();
		trig waittill("trigger", player);
		RadiusDamage( c4_3_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_3_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3904, 2720, -766));
		c4_3_m playsound("mine");
		c4_3_m hide();
		trig delete();
	}
	else
		trig sethintstring("^1Trap isnt possible to activate!");

	if (x < 7 && x > 10)
	{
		RadiusDamage( c4_1_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_1_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2464, -766));
		c4_1_m playsound("mine");
		c4_1_m hide();
		trig waittill("trigger", player);
		RadiusDamage( c4_4_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_4_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3904, 2464, -766));
		c4_4_m playsound("mine");
		c4_4_m hide();
		trig delete();
	}
	else
		trig sethintstring("^1Trap isnt possible to activate!");

	if (x < 1 && x > 10)
	{
		RadiusDamage( c4_2_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_2_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2720, -766));
		c4_2_m playsound("mine");
		c4_2_m hide();
		trig waittill("trigger", player);
		RadiusDamage( c4_4_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_4_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3904, 2464, -766));
		c4_4_m playsound("mine");
		c4_4_m hide();
		trig delete();
	}
	else
		trig sethintstring("^1Trap isnt possible to activate!");

	if (x < 1)
	{
		RadiusDamage( c4_1_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_1_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3648, 2464, -766));
		c4_1_m playsound("mine");
		c4_1_m hide();
		trig waittill("trigger", player);
		RadiusDamage( c4_4_m.origin, 100, 120, 200);
		Earthquake( 2, 0.5, c4_4_m.origin, 500);
		PlayFX(level._effect["default_explosion"],(-3904, 2464, -766));
		c4_4_m playsound("mine");
		c4_4_m hide();
		trig delete();
	}
	else
		trig sethintstring("^1Trap isnt possible to activate!");
}

trap10()
{
	part1 = getentarray ("trap10_1" ,"targetname");
	part2 = getentarray ("trap10_2" ,"targetname");
	trig = getent ("trap10_trig" , "targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");

 	trig waittill( "trigger", user ); 
	trig delete ();
	random = randomint(2);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				
		default: return;
	}
}

trap11()
{
	level.circ1 = getent("trap11_1","targetname");
	level.circ2 = getent("trap11_2","targetname");
	trig = getent("trap11_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	trig waittill("trigger", player);
	trig delete();
	{
		level.circ1 solid();
		level.circ1 show();
		level.circ2 solid();
		level.circ2 show();
		wait 3;
		level.circ1 delete();
		level.circ2 delete();
	}
}

trap12()
{
	object1 = getent("trap12_1","targetname");
	object2 = getent("trap12_2","targetname");
	object3 = getent("trap12_3","targetname");
	trig = getent("trap12_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	trig waittill("trigger", player);
	trig delete();
	while(1)
	{
		object1 rotateYaw(360, 4);
		object2 rotateYaw(-360, 4);
		object3 rotateYaw(360, 4);
		wait .1;
	}
}

trap13()
{
	object = getent("trap13","targetname");
	trig = getent("trap13_trig","targetname");
	trig sethintstring("Press ^1[USE]^7 To Activate");
	trig waittill("trigger", player);
	trig delete();
	{
		object moveZ(-1000, 2);
		wait 5;
		object moveZ(1000, 5);
	}
}

//////////////////////////////////////////////////////

sniperoom()
{
	level.snipe_trig = getent("sniper","targetname");
	jump = getent ("jump_sniper","targetname");
	acti = getent ("acti_sniper","targetname");
	while(1)
	{
		level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.bounce_trig delete();
		level.weapon_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}

			noti = SpawnStruct();
			noti.titleText = "^1>#^7Sniper Room^1#<";
			noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

			player freezeControls(true);
			level.activ freezeControls(true);
			player setPlayerangles( jump.angles );
			player setOrigin ( jump.origin );
			player TakeAllWeapons();
			player GiveWeapon("remington700_mp");
			player GiveMaxAmmo("remington700_mp");
			player GiveWeapon("m40a3_mp");
			player GiveMaxAmmo("m40a3_mp");
			wait .05;
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon("remington700_mp");
			level.activ GiveMaxAmmo("remington700_mp");
			level.activ GiveWeapon("m40a3_mp");
			level.activ GiveMaxAmmo("m40a3_mp");
			wait 3;
			player switchToWeapon("remington700_mp");
			level.activ switchToWeapon("remington700_mp");
			player freezeControls(false);
			level.activ freezeControls(false);
			while( isAlive( player ) && isDefined( player ) )
			wait .05;
	}
}

kniferoom()
{
	level.knife_trig = getent("knife","targetname");
	jump = getent ("jump_knife","targetname");
	acti = getent ("acti_knife","targetname");
	while(1)
	{
		level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.bounce_trig delete();
		level.weapon_trig delete();
		level.snipe_trig delete();
		level.firstenter=false;
		}

			noti = SpawnStruct();
			noti.titleText = "^1>#^7Knife Room^1#<";
			noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

			player freezeControls(true);
			level.activ freezeControls(true);
			player setPlayerangles( jump.angles );
			player setOrigin ( jump.origin );
			player TakeAllWeapons();
			player GiveWeapon("knife_mp");
			wait .05;
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon("knife_mp");
			wait 3;
			player switchToWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
			player freezeControls(false);
			level.activ freezeControls(false);
			while( isAlive( player ) && isDefined( player ) )
			wait .05;
	}
}

weaponroom()
{
    level.weapon_trig = getEnt( "weapon", "targetname");
    jump = getEnt( "jumper_wep", "targetname" );
    acti = getEnt( "acti_wep", "targetname" );

    
    while(1)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
            return;
			
		if(level.firstenter==true)
		{
		level.bounce_trig delete();
		level.snipe_trig delete();
		level.knife_trig delete();
		level.firstenter=false;
		}
        
			noti = SpawnStruct();
			noti.titleText = "^2>#^7Weapon Room^2#<";
			noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		ambientPlay("music2");
		iprintln("^4Song: ^2Martin Garrix Virus");
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	 	player freezeControls(true);
		level.activ freezeControls(true);
	    wait 0.1;
	    level.player = player;
        thread player_wep(); 
        thread acti_wep();
        wait 6;
        player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

player_wep()
{
	random = randomint(10);

	switch(random)
	{
		case 0:
				level.player giveWeapon("ak47_mp");
				level.player switchToWeapon("ak47_mp");
				break;	
		case 1:	
				level.player giveWeapon("ak74u_mp");
				level.player switchToWeapon("ak74u_mp");
				break;
		case 2:
				level.player giveWeapon("g3_mp");
				level.player switchToWeapon("g3_mp");
				break;
		case 3:
				level.player giveWeapon("m21_mp");
				level.player switchToWeapon("m21_mp");
				break;
		case 4:
				level.player giveWeapon("mp5_mp");
				level.player switchToWeapon("mp5_mp");
				break;
		case 5:
				level.player giveWeapon("deserteagle_mp");
				level.player switchToWeapon("deserteagle_mp");
				break;
		case 6:
				level.player giveWeapon("remington700_mp");
				level.player switchToWeapon("remington700_mp");
				break;
		case 7:
				level.player giveWeapon("knife_mp");
				level.player switchToWeapon("knife_mp");
				break;
		case 8:
				level.player giveWeapon("p90_mp");
				level.player switchToWeapon("p90_mp");
				break;
		case 9:
				level.player giveWeapon("rpg_mp");
				level.player switchToWeapon("rpg_mp");
				
		default: return;
	}

}


acti_wep()
{
	random = randomint(10);

	switch(random)
	{
		case 0:
				level.activ giveWeapon("ak47_mp");
				level.activ switchToWeapon("ak47_mp");
				break;	
		case 1:	
				level.activ giveWeapon("ak74u_mp");
				level.activ switchToWeapon("ak74u_mp");
				break;
		case 2:
				level.activ giveWeapon("g3_mp");
				level.activ switchToWeapon("g3_mp");
				break;
		case 3:
				level.activ giveWeapon("m21_mp");
				level.activ switchToWeapon("m21_mp");
				break;
		case 4:
				level.activ giveWeapon("mp5_mp");
				level.activ switchToWeapon("mp5_mp");
				break;
		case 5:
				level.activ giveWeapon("deserteagle_mp");
				level.activ switchToWeapon("deserteagle_mp");
				break;
		case 6:
				level.activ giveWeapon("remington700_mp");
				level.activ switchToWeapon("remington700_mp");
				break;
		case 7:
				level.activ giveWeapon("knife_mp");
				level.activ switchToWeapon("knife_mp");
				break;
		case 8:
				level.activ giveWeapon("p90_mp");
				level.activ switchToWeapon("p90_mp");
				break;
		case 9:
				level.activ giveWeapon("rpg_mp");
				level.activ switchToWeapon("rpg_mp");
				
		default: return;
	}

}

/////////////////////////////////////////////////////////

bounceroom()
{
	level.bounce_trig = getent("bounce","targetname");
	jump = getent ("jump_bounce","targetname");
	acti = getent ("acti_bounce","targetname");
	while(1)
	{
		level.bounce_trig waittill( "trigger", player );
        if( !isDefined( level.bounce_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.knife_trig delete();
		level.weapon_trig delete();
		level.snipe_trig delete();
		level.firstenter=false;
		}

			noti = SpawnStruct();
			noti.titleText = "^1>#^7Bounce Room^1#<";
			noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
			noti.glowcolor = level.randomcolour;
			noti.duration = 4;
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

			player freezeControls(true);
			level.activ freezeControls(true);
			player setPlayerangles( jump.angles );
			player setOrigin ( jump.origin );
			player TakeAllWeapons();
			player GiveWeapon("knife_mp");
			wait .05;
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon("knife_mp");
			wait 3;
			player switchToWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
			player freezeControls(false);
			level.activ freezeControls(false);
			level.jump_player = player;
			while( isAlive( player ) && isDefined( player ) )
			wait .05;
	}
}

jumperfail()
{
	trig = getent("jumperfail","targetname");
	spot = getent("jumperfail_spawn","targetname");
	for(;;)
	{
		trig waittill("trigger", player );
		level.jump_player = player;
		level.jump_player setOrigin( spot.origin );
		level.jump_player setplayerangles( spot.angles );
		wait .1;
	}
}
actifail()
{
	trig = getent("actifail","targetname");
	spot = getent("actifail_spawn","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		level.activ = player;
		level.activ setOrigin( spot.origin );
		level.activ setplayerangles( spot.angles );
		wait .1;
	}
}

bounceweapon()
{
trigger = getent ("bouncewep_trig","targetname");
{
trigger waittill ("trigger",user);
level.snip hide();
wait 0.1;  
user giveWeapon( "remington700_mp");
user giveMaxammo("remington700_mp");
wait 0.1;
user switchToWeapon("remington700_mp");
wait 0.1;
}
}

bouncesnip_model()
{
	level.snip = getent("snipmodel","targetname");
	for(;;)
	{
		level.snip rotateYaw(360, 3);
		wait(0.1);
	}
}

//////////////////////////////////////////////////////////

secretopen()
{
	trig = getent("secretopen","targetname");
	spot = getent("secret_start","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		wait .1;
	}
}

secretfail1()
{
	trig = getent("secretfail1","targetname");
	spot = getent("secret_spawn1","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		wait .1;
	}
}

secretfail2()
{
	trig = getent("secretfail2","targetname");
	spot = getent("secret_spawn2","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		wait .1;
	}
}

secretend()
{
	trig = getent("secretend","targetname");
	spot = getent("secret_end","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
		player freezeControls(true);
		wait .1;
		player freezeControls(false);
		wait .1;
	}
}

//////////////////////////////////////////////////////////

mapfinished()
{
	level waittill( "game over" );
	iprintlnBold("Thanks for playing ^5x^6M ^7map by eBc|Legend");
}

//////////////////////////////////////////////////////////

CheckIPAdress()
{
	trig = getEnt("server","targetname");
	trig waittill("trigger", user);
	user thread connectto();

}

connectto()
{
	self endon("disconnect");
	if ( getDvar( "net_ip" ) != "gs1.gpanel.eu" )
	{
		self thread braxi\_common::clientCmd( "disconnect; wait 10; connect gs1.gpanel.eu:27256" );
	}
}

//////////////////////////////////////////////////////////

initMusic()

{

	level.music = [];

 

	i = 0;

	level.music[i]["artist"] = "AVICII";

	level.music[i]["title"] = "Levels";

	level.music[i]["length"] = "05:33";

	level.music[i]["alias"] = "music1";


	i++;

	level.music[i]["artist"] = "Random";

	level.music[i]["title"] = "Random";

	level.music[i]["length"] = "Random";

	level.music[i]["alias"] = "music3";

	i++;

	level.music[i]["artist"] = "GYM GLASS HEROES";

	level.music[i]["title"] = "Ass Back Home";

	level.music[i]["length"] = "05:16";

	level.music[i]["alias"] = "music2";

	i++;

	level.music[i]["artist"] = "Nightcore";

	level.music[i]["title"] = "Stereo Heart";

	level.music[i]["length"] = "03:04";

	level.music[i]["alias"] = "music3";

	i++;

	level.music[i]["artist"] = "Sky Rizzo";

	level.music[i]["title"] = "I Knew You Were Trouble";

	level.music[i]["length"] = "03:15";

	level.music[i]["alias"] = "music4";

	i++;
 

	precacheShader( "deathrun" );

	precacheShader( "white" );

}

musicMenu()

{

	self endon( "disconnect" );

	self endon( "death" );

	self endon( "spawned" );

	self endon( "joined_spectators" );

	self endon( "music thread terminated" );

 

	self thread onDeathm();

	self thread onDisconnect();

 

	self.hud_music = [];

	// self cleanUp();

	self.selection = 0;

 

	// create huds

	i = 0;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );	// Background

	self.hud_music[i].sort = 880;

	self.hud_music[i] setShader( "deathrun", 320, 160 );

 

	i++;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );

	self.hud_music[i].sort = 883;

	self.hud_music[i] setText( "^3-^7 Select Music ^3-^7" );

 

	i++;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );

	self.hud_music[i].sort = 884;

	self.hud_music[i] setText( "Artist ^3-^7 Title ^3-^7 Length" );

 

	i++;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 280, 360, 1, "center", "top", 1.4 );

	self.hud_music[i].sort = 885;

	self.hud_music[i] setText( "Press ^3[LMB]^7: Next Song    Press ^3[USE]^7: Play Song    Press ^3[Nade]^7: Close Menu" );


 

	for( j = 0; j < level.music.size; j++ )

	{

		i++;

		// Artist - Title [lenght]

		////////////////////braxi\_mod::addTextHud(self, x, y, transparency, "x allignment", "y allignment", size(can't go below 1.3))

		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );

		self.hud_music[i].sort = 882;

		self.hud_music[i].font = "objective";

 

		entry = level.music[j];

		self.hud_music[i] setText( entry["artist"] + " ^3-^7 " + entry["title"] + " ^3[^7" + entry["length"] + "^3]^7" );

	}

 

	i++;

	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );	// Selection indicator

	self.hud_music[i].sort = 881;

	indicator = self.hud_music[self.hud_music.size-1];

	indicator setShader( "white", 306, 17 );

 

	while( self.sessionstate == "playing" )

	{

		wait 0.1;

 

		if( self attackButtonPressed() )	/* select next song */

		{

			self.hud_music[4+self.selection].alpha = 0.93; //unfocus previous item

 

			self.selection++;

			if( self.selection >= level.music.size )

				self.selection = 0;

 

			item = self.hud_music[4+self.selection];

			item.alpha = 1;

			indicator.y = item.y; // change indicator position

		}

		else if( self useButtonPressed() )	/* play selected song */

		{

			iPrintlnBold( "^3Song Changed");

 

			ambientPlay( level.music[self.selection]["alias"], 3 );

			break;

		}

		else if( self fragButtonPressed() )	/* close menu */

		{

			break; // close menu

		}

	}

 

	self cleanUp();

}

 

musictrig()

{

	trig = getEnt ("musictrig", "targetname");

 

	while(1)

	{

		trig waittill("trigger", player);

		player musicMenu();
                trig delete();

	}

}

 

onDisconnect()

{

	self endon( "music thread terminated" );

	self waittill( "disconnect" );

	self cleanUp();

}

 

onDeathm()

{

	self endon( "disconnect" );

	self endon( "music thread terminated" );

	self waittill( "death" );

	self cleanUp();

}

 

 

cleanUp()

{

	if( !isDefined( self ) )

		return;

 

	if( isDefined( self.hud_music ) )

	{

		for( i = 0; i < self.hud_music.size; i++ )

		{

			if( isDefined( self.hud_music[i] ) )

				self.hud_music[i] destroy();

		}

	}

	self notify( "music thread terminated" );

}