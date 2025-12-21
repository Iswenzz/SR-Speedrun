//	/$$$$$$$$ /$$$$$$$  /$$$$$$ /$$   /$$
//	| $$_____/| $$__  $$|_  $$_/| $$  /$$/
//	| $$      | $$  \ $$  | $$  | $$ /$$/
//	| $$$$$   | $$$$$$$/  | $$  | $$$$$/
//	| $$__/   | $$__  $$  | $$  | $$  $$
//	| $$      | $$  \ $$  | $$  | $$\  $$
//	| $$$$$$$$| $$  | $$ /$$$$$$| $$ \  $$
//	|________/|__/  |__/|______/|__/  \__/

#include maps\mp\_utility;
#include common_scripts\utility;
//Credits: Clippy,Rednose,Iswenzz,ERYK
main()
{
	maps\mp\_load::main();

    SetExpFog(450, 1100, 0, 0, 0, 0);
    //AmbientPlay("ambient_citystreets_night");

    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    setdvar("r_specularcolorscale", "1");
    setdvar("r_glowskybleedintensity0", ".3");

	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");

	PreCacheItem("deserteaglegold_mp");
	PreCacheItem("remington700_mp");
	PreCacheItem("m40a3_mp");
	PreCacheItem("knife_mp");

	///TRAP TRIGGERS
    addTriggerToList("trigger_trap1");
    addTriggerToList("trigger_trap2");
    addTriggerToList("trigger_trap3");
    addTriggerToList("trigger_trap4");
    addTriggerToList("trigger_trap5");
    addTriggerToList("trigger_trap6");
    addTriggerToList("trigger_trap7");

    thread sr\api\_map::createSpawn((338,7,28), 359);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();

	thread start_door();
	//thread endmap();
	//thread elevator1();
	//thread elevator2();
	//thread teleporter_thread();
	//thread endRooms();
}


trap1()
{
brush1 = getEnt("trap1_brush1l", "targetname");
brush2 = getEnt("trap1_brush2l", "targetname");
brush3 = getEnt("trap1_brush1r", "targetname");
brush4 = getEnt("trap1_brush2r", "targetname");

//brush1 RotateTo ((0,0,0),.1);
brush2 RotateTo ((0,30,0),.1);
brush3 RotateTo ((0,60,0),.1);
brush4 RotateTo ((0,90,0),.1);

trig = getEnt("trap1_trigger", "targetname");
trig waittill ("trigger" , player );

}


trap2()
{
brushes = getEntArray("trap2_brush", "targetname");
trig = getEnt("trap2_trigger", "targetname");
trig waittill ("trigger" , player );
trig SetCursorHint("HINT_NOICON");
trig playsound("laugh");
for (i = 0; i < brushes.size; i++)
	{
	brushes[i] thread trap2_move();
	wait 1;
	}
}

trap2_move()
{
	while (true)
	{
	self moveX(-384,4,2,2);
	wait 5;
	self moveX(384,2,1,1);
	wait 3;
	}
}


trap3()
{
brush1 = getEntArray("trap3_brush1", "targetname");
brush2 = getEntArray("trap3_brush2", "targetname");
trig = getEnt("trap3_trigger", "targetname");
trig waittill ("trigger" , player );
trig SetCursorHint("HINT_NOICON");
trig playsound("laugh");
wait 0.5;

for (i = 0; i < brush1.size; i++)
	brush1[i] thread trap3_move1();

wait 0.5;

for (i = 0; i < brush2.size; i++)
	brush2[i] thread trap3_move2();
}

trap3_move1()
{
	while (true)
	{
	self moveX(192,4,2,2);
	wait 4;
	self moveX(-192,4,2,2);
	wait 4;
	}
}

trap3_move2()
{
	while (true)
	{
	self moveX(-192,4,2,2);
	wait 4;
	self moveX(192,4,2,2);
	wait 4;
	}
}

trap4()
{
brush1 = getent("trap4_brush1", "targetname");
brush2 = getent("trap4_brush2", "targetname");
brush1Target = getent(brush1.target, "targetname");
brush2Target = getent(brush2.target, "targetname");
trig = getEnt("trap4_trigger", "targetname");
trig waittill ("trigger" , player );
	trig SetCursorHint("HINT_NOICON");
trig playsound("laugh");
	brush1Target enableLinkTo();
	brush1Target linkTo(brush1);
	brush2Target enableLinkTo();
	brush2Target linkTo(brush2);
	wait 1;
	while (true)
	{
	brush1 moveZ(-192,4,2,2);
	brush2 moveZ(192,4,2,2);
	wait 4;
	brush1 moveZ(192,4,2,2);
	brush2 moveZ(-192,4,2,2);
	wait 4;
	}
}

trap5()
{
brush1 = getEnt("trap5_brush", "targetname");
trig = getEnt("trap5_trigger", "targetname");
trig waittill ("trigger" , player );
trig SetCursorHint("HINT_NOICON");
trig playsound("laugh");
	wait 1;
	brush1 moveZ(104,2,1,1);
}

trap6()
{
level endon("trap6");
in = getEnt("trap6_in","targetname");
out = getEnt("trap6_out","targetname");
trigger = getEnt("trap6_trigger","targetname");
trigger waittill("trigger",player);
trigger SetCursorHint("HINT_NOICON");
trigger playsound("laugh");
if(isdefined(player) && player.pers["team"] == "axis")
{
	level.activ.health = 9999999;
	player SetPlayerAngles( in.angles );
	player setOrigin( in.origin );
	player iprintlnbold("^915 Seconds left to Kill");
	thread trap6_sub();
	wait 15;
	player SetPlayerAngles( out.angles );
	player setOrigin( out.origin );
	level.activ.health = 100;
	level notify("trap6");
}
}

trap6_sub()
{
level endon("trap6");
out = getEnt("trap6_out","targetname");
trigger = getEnt("trap6_sub_trigger","targetname");
for(;;)
{
trigger waittill("trigger",player);
if(isdefined(player) && player.pers["team"] == "axis")
{
level.activ.health = 100;
player iprintlnbold("^9Kill Zone Left");
player SetPlayerAngles( out.angles );
player setOrigin( out.origin );
level notify("trap6");
}
wait 0.05;
}
}



trap7()
{
brush1 = getEnt("trap7_brush1", "targetname");
brush2 = getEnt("trap7_brush2", "targetname");
brush3 = getEnt("trap7_brush3", "targetname");
trig = getEnt("trap7_trigger", "targetname");
trig waittill ("trigger" , player );
	trig SetCursorHint("HINT_NOICON");
	brush2 moveZ(-700,10,5);
	brush3 delete();
	while (true)
	{
	brush1 rotateYaw(360,11);
	wait 7;
	}
}

start_door()
{
    blade1 = getEnt("blade1", "targetname");
    blade2 = getEnt("blade2", "targetname");
    brush1 = getEnt("start_door", "targetname");
    brush2 = getEnt("elevator1_brush", "targetname");
    brush3 = getEnt("elevator2_brush", "targetname");
    trig = getEnt("start_trig", "targetname");

	brush1 delete();
}

music()
{
    level.music = randomint(3);

    switch(level.music)
   {
      case 0:
     AmbientPlay( "music1" );
	 iPrintLN("Song name: YEAT - Playin gamës / Woo");
     break;

     case 1:
     AmbientPlay( "music2" );
	 iPrintln("Song name: Oesch's die Dritten - HEIMAT");
     break;

	  case 2:
     AmbientPlay( "music3" );
	 iPrintln("Song name: Ummet Ozcan - Bifrost");
     break;
   }

}

elevator1()
{
    brush = getEnt("elevator1_brush", "targetname");
    trig1 = getEnt("elevator1_trig_up", "targetname");
    trig2 = getEnt("elevator1_trig_down", "targetname");
	wait 1;
	trig1 SetCursorHint("HINT_ACTIVATE");
	trig2 SetCursorHint("HINT_NOICON");

	while (true)
	{
    trig1 waittill ("trigger" , player );
	trig1 SetCursorHint("HINT_NOICON");
	brush moveZ(-704,5,3,2);
    brush waittill("movedone");
	wait 1;
	trig2 SetCursorHint("HINT_ACTIVATE");
	wait 0.5;
    trig2 waittill ("trigger" , player );
	trig2 SetCursorHint("HINT_NOICON");
	brush moveZ(704,5,3,2);
    brush waittill("movedone");
	wait 1;
	trig1 SetCursorHint("HINT_ACTIVATE");
	}
}

elevator2()
{
    brush = getEnt("elevator2_brush", "targetname");
    trig1 = getEnt("elevator2_trig_up", "targetname");
    trig2 = getEnt("elevator2_trig_down", "targetname");
	wait 1;
	trig1 SetCursorHint("HINT_ACTIVATE");
	trig2 SetCursorHint("HINT_NOICON");

	while (true)
	{
    trig1 waittill ("trigger" , player );
	trig1 SetCursorHint("HINT_NOICON");
	brush moveZ(-640,5,3,2);
    brush waittill("movedone");
	wait 1;
	trig2 SetCursorHint("HINT_ACTIVATE");
	wait 0.5;
    trig2 waittill ("trigger" , player );
	trig2 SetCursorHint("HINT_NOICON");
	brush moveZ(640,5,3,2);
    brush waittill("movedone");
	wait 1;
	trig1 SetCursorHint("HINT_ACTIVATE");
	}
}

spin_blade()
{
while(true)
	{
	self rotatePitch(360,1.5);
	wait 1.5;
	}
}

endmap()
{
    trig = getEnt("endmap_trig", "targetname");
    trig waittill ("trigger" , player );
	thread endDoor();
    firstPlace = newHudElem();
    firstPlace.foreground = true;
    firstPlace.alpha = 1;
    firstPlace.alignX = "left";
    firstPlace.alignY = "middle";
    firstPlace.horzAlign = "left";
    firstPlace.vertAlign = "middle";
    firstPlace.x = -400;
    firstPlace.y = 0;
    firstPlace.sort = 0;
    firstPlace.font = "default";
    firstPlace.fontScale = 1.4;
    firstplace.hidewheninmenu = false;
    firstPlace.glowAlpha = 1;
    firstPlace.glowColor = (.3,.0,3);
    firstPlace settext("^5" + player.name + " ^7has finished ^5FIRST^7");
    firstPlace moveOverTime(2);
    firstPlace.x = 5;
    wait 5;
    firstPlace moveOverTime(2);
    firstPlace.x = -500;
    wait 7;
    firstPlace destroy();
}

endDoor()
{
    brush = getEnt("end_door", "targetname");
    trig = getEnt("enddoor_trig", "targetname");
    trig waittill ("trigger" , player );
	trig SetCursorHint("HINT_NOICON");
	brush moveZ(120,3,2,1);
	brush playsound("door");
}


teleporter_thread()
{

	entTransporter= getentarray("teleport","targetname");
	if(isdefined(entTransporter))

		{
			for(lp=0; lp<entTransporter.size;lp=lp+1)
			entTransporter [lp] thread teleporter();
		}
}

teleporter()
{
  while(true)
  {
    self waittill("trigger",other);
    entTarget = getent(self.target, "targetname");

    wait(0.10);
    other setorigin(entTarget.origin);
    other setplayerangles(entTarget.angles);
    wait(0.10);

   }
}



addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

endRooms()
{
    level.r_old = getEnt("old_trigger", "targetname");
    level.r_knife = getEnt("knife_trigger", "targetname");
    level.r_deagle = getEnt("deagle_trigger", "targetname");
    level.r_sniper = getEnt("sniper_trigger", "targetname");
	level.endRoom_acti = getEnt("endroom_acti", "targetname");
	level.endRoom_jumper = getEnt("endroom_jumper", "targetname");
	thread endroom_bounce();
	thread old_r();
	thread knife_r();
	thread deagle_r();
	thread sniper_r();
}



endroom_bounce()
{
trig = getEnt("endroom_bounce", "targetname");
}

old_r()
{
    brush = getEnt("old_brush", "targetname");
    trig = getEnt("old_trigger", "targetname");
    trig waittill ("trigger" , player );
    level.r_old delete();
    level.r_knife delete();
    level.r_deagle delete();
    level.r_sniper delete();
	brush delete();
}



knife_r()
{
	while(1)
	{
		level.r_knife setHintString("^3Knife Room");
		level.r_knife waittill("trigger", player);
	level.r_old delete();
    level.r_deagle delete();
    level.r_sniper delete();
		AmbientStop();
		AmbientPlay( "music_endroom" );

		noti = SpawnStruct();
		noti.titleText = "^3Knife Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player setOrigin (level.endRoom_jumper.origin);
		player setPlayerAngles (level.endRoom_jumper.angles);

		level.activ setOrigin (level.endRoom_acti.origin);
		level.activ setPlayerAngles (level.endRoom_acti.angles);

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

		wait 3;
		player iPrintLnBold("^7Fight!");
		level.activ iPrintLnBold("^7Fight!");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;

		wait 1;
		iPrintLn("^3[Room Selection Open]");
		player = undefined;
	}
}


deagle_r()
{
	while(1)
	{
		level.r_deagle setHintString("^3Deagle Room");
		level.r_deagle waittill("trigger", player);
    level.r_old delete();
    level.r_knife delete();
    level.r_sniper delete();
		AmbientStop();
		AmbientPlay( "music_endroom" );

		noti = SpawnStruct();
		noti.titleText = "^3Deagle Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player setOrigin (level.endRoom_jumper.origin);
		player setPlayerAngles (level.endRoom_jumper.angles);

		level.activ setOrigin (level.endRoom_acti.origin);
		level.activ setPlayerAngles (level.endRoom_acti.angles);

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player freezeControls(1);
		level.activ freezeControls(1);

		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		player giveWeapon("deserteaglegold_mp");
		player giveMaxAmmo("deserteaglegold_mp");
		player switchToWeapon("deserteaglegold_mp");

		level.activ takeAllWeapons();
		level.activ giveWeapon("deserteaglegold_mp");
		level.activ giveMaxAmmo("deserteaglegold_mp");
		level.activ switchToWeapon("deserteaglegold_mp");

		wait 3;
		player iPrintLnBold("^7Fight!");
		level.activ iPrintLnBold("^7Fight!");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;

		wait 1;
		iPrintLn("^3[Room Selection Open]");
		player = undefined;
	}
}


sniper_r()
{
	while(1)
	{
		level.r_sniper setHintString("^3Sniper Room");
		level.r_sniper waittill("trigger", player);
    level.r_old delete();
    level.r_knife delete();
    level.r_deagle delete();

		AmbientStop();
		AmbientPlay( "music_endroom" );

		noti = SpawnStruct();
		noti.titleText = "^3Sniper Room";
		noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
		noti.duration = 5;
		players = getEntArray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

		player setOrigin (level.endRoom_jumper.origin);
		player setPlayerAngles (level.endRoom_jumper.angles);

		level.activ setOrigin (level.endRoom_acti.origin);
		level.activ setPlayerAngles (level.endRoom_acti.angles);

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

		wait 3;
		player iPrintLnBold("^7Fight!");
		level.activ iPrintLnBold("^7Fight!");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;

		wait 1;
		iPrintLn("^3[Room Selection Open]");
		player = undefined;
	}
}

