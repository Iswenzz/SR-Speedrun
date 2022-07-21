main()
{
thread sr\api\_map::createSpawn((531.442, -511.610, 56.125), 180);
trigger = spawn( "trigger_radius", (2687, 2503, 92), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;	
	maps\mp\_load::main();	
	
	
	// ambientPlay("ambient100");
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	//arrays
	//kick , arm	
	sweeperarm=getentarray("Sweper_Trap","targetname");
	if(isdefined(sweeperarm))
	{
	for(i=0;i<sweeperarm.size;i++)
	{
	sweeperarm[i] thread trap_sweeperarm();
	}
	}
	
	kicker=getentarray("kicker","targetname");
	if(isdefined(kicker))
	{
	for(i=0;i<kicker.size;i++)
	{
	kicker[i] thread trap_kicker();
	}
	}
	
	
	
	finalsweeperarm=getentarray("Final_Sweper","targetname");
	if(isdefined(finalsweeperarm))
	{
	for(i=0;i<finalsweeperarm.size;i++)
	{
	finalsweeperarm[i] delete();
	}
	}
	
	thread way_connect();
	//startthreads
	// thread credit();
	thread Spinner_Floor();
	// thread secrettele();
	// thread secretteleback();
	thread sweeperunlock();
	// thread WatchEndTrigger();
	// thread wipezone();
	// thread addtriggers();
	
	//trapthreads
	// thread trap_sweeperfloor();
	// thread trap_rotating_platform();
	// thread trap_sinkers();
	// thread trap_pushers();
	// thread trap_Big_Red_Ball();
	// thread trap_paddz();
	// thread trap_kantelendeplatformen();
	// thread trap_jumppads();
	// thread trap_rotateingshit();
	// thread trap_roller();
	
	

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	
    for(;;) 
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


addtriggers()
{
addTriggerToList("Trap_Big_Red_Ball");
addTriggerToList("Trap_Sweper_Floor");
addTriggerToList("Trap_Sweper_Trap");
addTriggerToList("Trap_Rotating_Platforms");
addTriggerToList("Trap_Sinking_Platform");
addTriggerToList("Trap_Push_Wall");
addTriggerToList("Trap_Pads");
addTriggerToList("Trap_Platform");
addTriggerToList("Trap_Final_Rotator");
addTriggerToList("Trap_Jump_Pads");
addTriggerToList("Trap_Slide_Pusher");

}

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

credit()
{
wait(8);
thread drawInformation( 800, 0.8, 1, "Wipeout" );
wait(4);
thread drawInformation( 800, 0.8, 1, "Map by iNZER & Wingzor" );
}

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


trap_Big_Red_Ball()
{
bal1 = getEnt("Big_Red_Ball1", "targetname");
bal2status = false;
trigger = getEnt("Trap_Big_Red_Ball", "targetname");
trigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
player iPrintLnBold("Just Dont -_-");
}
else
{
while(1)
{
if(bal2status == false)
{
thread bal2();
bal2status = true;
}
bal1 movez(20,3);
bal1 waittill ("movedone");
bal1 movez(-10,2);
bal1 waittill ("movedone");
bal1 movez(2.5,2);
bal1 waittill ("movedone");
bal1 movez(-12.5,3);
bal1 waittill ("movedone");
}
}
}

bal2()
{
bal2 = getEnt("Big_Red_Ball2", "targetname");
bal3status = false;
while(1)
{
if(bal3status == false)
{
thread bal3();
bal3status = true;
}
bal2 movez(-20,3);
bal2 waittill ("movedone");
bal2 movez(10,2);
bal2 waittill ("movedone");
bal2 movez(-2.5,2);
bal2 waittill ("movedone");
bal2 movez(12.5,3);
bal2 waittill ("movedone");
}
}

bal3()
{
bal3 = getEnt("Big_Red_Ball3", "targetname");
while(1)
{
bal3 movez(20,3);
bal3 waittill ("movedone");
bal3 movez(-10,2);
bal3 waittill ("movedone");
bal3 movez(2.5,2);
bal3 waittill ("movedone");
bal3 movez(-12.5,3);
bal3 waittill ("movedone");
}
}


trap_sweeperfloor()
{
floor=getent("Sweper_Floor","targetname");
if (!isdefined(floor.speed)) //floor.speed is hoeveel seconde per ronde
 floor.speed = 6;
if (!isdefined(floor.script_noteworthy))
 floor.script_noteworthy = "z";
trigger_trap_rotatefloor=getent("Trap_Sweper_Floor","targetname");
trigger_trap_rotatefloor waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
player iPrintLnBold("Just Dont -_-"); //verander message als je wil dis bij act op free
}
else
{
while(true)
{
 if (floor.script_noteworthy == "z")
  floor rotateYaw(360,floor.speed);
 else if (floor.script_noteworthy == "x")
  floor rotateRoll(360,floor.speed);
 else if (floor.script_noteworthy == "y")
  floor rotatePitch(360,floor.speed);
 wait ((floor.speed)-0.1);
}
}
}

trap_sweeperarm()
{
if (!isdefined(self.speed))
 self.speed = 4;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
trigger_trap_rotatefloor=getent("Trap_Sweper_Trap","targetname");
trigger_trap_rotatefloor waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
player iPrintLnBold("Just Dont -_-"); //verander message als je wil dis bij act op free
}
else
{
while(true)
{
 if (self.script_noteworthy == "z")
  self rotateYaw(-360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1);
}
}
}

Spinner_Floor()
{
floor=getent("Spinner_Floor","targetname");
if (!isdefined(floor.speed))
 floor.speed = 2;
if (!isdefined(floor.script_noteworthy))
 floor.script_noteworthy = "z";
while(true)
{
 if (floor.script_noteworthy == "z")
  floor rotateYaw(360,floor.speed);
 else if (floor.script_noteworthy == "x")
  floor rotateRoll(360,floor.speed);
 else if (floor.script_noteworthy == "y")
  floor rotatePitch(360,floor.speed);
 wait ((floor.speed)-0.1);
}
}

trap_finalsweeperarm()
{
if (!isdefined(self.speed))
 self.speed = 5;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
while(true)
{
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1);
}
}


trap_rotating_platform()
{	
platform1 = getEnt("Rotating_Platform1", "targetname");	
triggerd = getEnt("Trap_Rotating_Platforms", "targetname");
if (!isdefined(platform1.speed))
 platform1.speed = 3;
if (!isdefined(platform1.script_noteworthy))
 platform1.script_noteworthy = "z";
triggerd waittill("trigger", player);
thread trap_rotating_platform2();
while(true)
{
 if (platform1.script_noteworthy == "z")
  platform1 rotateYaw(360,platform1.speed);
 else if (platform1.script_noteworthy == "x")
  platform1 rotateRoll(360,platform1.speed);
 else if (platform1.script_noteworthy == "y")
  platform1 rotatePitch(360,platform1.speed);
 wait ((platform1.speed)-0.1);
}
}

trap_rotating_platform2()
{
platform2 = getEnt("Rotating_Platform2", "targetname");	
if (!isdefined(platform2.speed))
 platform2.speed = 3;
if (!isdefined(platform2.script_noteworthy))
 platform2.script_noteworthy = "z";
while(true)
{
 if (platform2.script_noteworthy == "z")
  platform2 rotateYaw(-360,platform2.speed);
 else if (platform2.script_noteworthy == "x")
  platform2 rotateRoll(-360,platform2.speed);
 else if (platform2.script_noteworthy == "y")
  platform2 rotatePitch(-360,platform2.speed);
 wait ((platform2.speed)-0.1);
}
}

trap_sinkers()
{
platforms=getentarray("Sinking_Platform","targetname");
trigger = getEnt("Trap_Sinking_Platform", "targetname");
trigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1Stop being a low"); //Change the message if you want
}
else
{
for(i=0;i<platforms.size;i++)
{
}
for(i=0; i<1; i++)
{
wait(0.05);
platforms[randomInt(platforms.size)] movez(-200,1);
}
}
}

trap_pushers()
{
pusherlow=getent("pusherslow","targetname");
pusherhigh=getent("pushersheigh","targetname");
trigger = getEnt("Trap_Push_Wall", "targetname");
trigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1Stop being a low"); //Change the message if you want
}
else
{
while(1)
{
wait(0.05);
pusherlow movex(32,1);
pusherlow waittill("movedone");
pusherlow movex(-32,1);
wait(0.5);
pusherhigh movex(32,1);
pusherhigh waittill("movedone");
pusherhigh movex(-32,1);
}
}
}

trap_kicker()
{
snordmg = getEnt("snor", "targetname");
snordmgorigin = getEnt("snor_origin", "targetname");
snordmg.dmg = 0;
snordmg enablelinkto();
snordmg linkto(snordmgorigin);
trigger = getEnt("Kick_Trap", "targetname");
if (!isdefined(self.speed))
 self.speed = 2;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "x";
while(1)
{
trigger waittill("trigger", player);
wait(2);
if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait(0.5);
 snordmg.dmg = 10;
 snordmgorigin movez(32,0.2);
 wait(1);
 snordmg.dmg = 0;
 snordmgorigin movez(-32,0.2);
 wait(1);
}
}


secrettele()
{
triggertele = getEnt("secret", "targetname");
secretorigin = getEnt("secretspawn", "targetname");
triggertele waittill("trigger", player);
player SetOrigin( secretorigin.origin );
player setplayerangles(secretorigin.angles );
}

secretteleback()
{
triggertele = getEnt("endsecret", "targetname");
secretorigin = getEnt("endsecretspawn", "targetname");
triggertele waittill("trigger", player);
player SetOrigin( secretorigin.origin );
player setplayerangles(secretorigin.angles );
}

		
sweeperunlock()
{
	trigger = getEnt( "door", "targetname" );
	left = getent ("left_door","targetname");
	leftorigin = getent ("left_door_orgin","targetname");
	left linkto(leftorigin);
	if (!isdefined(leftorigin.speed))
	leftorigin.speed = 3;
	if (!isdefined(leftorigin.script_noteworthy))
	leftorigin.script_noteworthy = "z";
	trigger waittill("trigger", player);
	thread otherdoor();
	if (leftorigin.script_noteworthy == "z")
	leftorigin rotateYaw(88,leftorigin.speed);
	else if (leftorigin.script_noteworthy == "x")
	leftorigin rotateRoll(88,leftorigin.speed);
	else if (leftorigin.script_noteworthy == "y")
	leftorigin rotatePitch(88,leftorigin.speed);
	wait ((leftorigin.speed)-0.1);
	wait(3);
}

otherdoor()
{
	left = getent ("right_door","targetname");
	leftorigin = getent ("right_door_orgin","targetname");
	left linkto(leftorigin);
	if (!isdefined(leftorigin.speed))
	leftorigin.speed = 3;
	if (!isdefined(leftorigin.script_noteworthy))
	leftorigin.script_noteworthy = "z";
	if (leftorigin.script_noteworthy == "z")
	leftorigin rotateYaw(-88,leftorigin.speed);
	else if (leftorigin.script_noteworthy == "x")
	leftorigin rotateRoll(-88,leftorigin.speed);
	else if (leftorigin.script_noteworthy == "y")
	leftorigin rotatePitch(-88,leftorigin.speed);
	wait ((leftorigin.speed)-0.1);
	wait(3);
}

trap_paddz()
{
platform1 = getEnt("pad1", "targetname");
platform2 = getEnt("pad2", "targetname");
platform3 = getEnt("pad3", "targetname");
platform4 = getEnt("pad4", "targetname");
platform5 = getEnt("pad5", "targetname");
platform6 = getEnt("pad6", "targetname");
platform7 = getEnt("pad7", "targetname");
platform8 = getEnt("pad8", "targetname");
platform9 = getEnt("pad9", "targetname");
platform0 = getEnt("pad0", "targetname");
level.square = getEnt("Trap_Pads", "targetname");
level.square waittill("trigger", player);
level.square delete();
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1Stop being a low"); //Change the message if you want
}
else
{
while(1)
{
platform1 movez(10,1);
platform2 movez(-20,1);
platform3 movez(-100,1);
platform4 movez(43,1);
platform5 movez(-75,1);
platform6 movez(20,1);
platform7 movez(-30,1);
platform8 movez(50,1);
platform9 movez(100,1);
platform0 movez(5,1);
wait(1.1);
platform1 movez(-10,1);
platform2 movez(20,1);
platform3 movez(100,1);
platform4 movez(-43,1);
platform5 movez(75,1);
platform6 movez(-20,1);
platform7 movez(30,1);
platform8 movez(-50,1);
platform9 movez(-100,1);
platform0 movez(-5,1);
wait(1.1);
}
}
}


trap_kantelendeplatformen()
{
platform1 = getentarray ("Platform1","targetname");
trigger = getEnt("Trap_Platform", "targetname");
trigger waittill("trigger", player);
thread platform2();
if(isdefined(platform1))
{	
for(i=0;i<platform1.size;i++)
{
if (!isdefined(platform1[i].speed))
	platform1[i].speed = 3;
if (!isdefined(platform1[i].script_noteworthy))
	platform1[i].script_noteworthy = "y";
        if (platform1[i].script_noteworthy == "z")
	platform1[i] rotateYaw(-44,platform1[i].speed);
	else if (platform1[i].script_noteworthy == "x")
	platform1[i] rotateRoll(-44,platform1[i].speed);
	else if (platform1[i].script_noteworthy == "y")
	platform1[i] rotatePitch(-44,platform1[i].speed);
	wait ((platform1[i].speed)-0.1);
}
}
}

platform2()
{
platform1 = getentarray ("Platform2","targetname");
if(isdefined(platform1))
{	
for(i=0;i<platform1.size;i++)
{
if (!isdefined(platform1[i].speed))
	platform1[i].speed = 3;
if (!isdefined(platform1[i].script_noteworthy))
	platform1[i].script_noteworthy = "y";
        if (platform1[i].script_noteworthy == "z")
	platform1[i] rotateYaw(44,platform1[i].speed);
	else if (platform1[i].script_noteworthy == "x")
	platform1[i] rotateRoll(44,platform1[i].speed);
	else if (platform1[i].script_noteworthy == "y")
	platform1[i] rotatePitch(44,platform1[i].speed);
	wait ((platform1[i].speed)-0.1);
}
}
}


wipezone()
{
trigger = getEnt("wipeout_zone", "targetname");
trigger waittill("trigger", player);
iPrintLnBold( player.name + "reached the ^3wipeout^7-^3zone.");
}


trap_jumppads()
{
trigger = getEnt("Trap_Jump_Pads", "targetname");
pad1 = getEnt("jump_pad1", "targetname");
pad2 = getEnt("jump_pad2", "targetname");
trigger waittill("trigger", player);
pad1 movez(-400,2);
pad1 waittill("movedone");
pad2 movez(-400,2);
pad2 waittill("movedone");
pad1 movez(400,3);
pad1 waittill("movedone");
pad2 movez(400,3);
pad2 waittill("movedone");
}

trap_rotateingshit()
{
trigger = getEnt("Trap_Final_Rotator", "targetname");
rot1 = getEntarray("final_rotator1", "targetname");
trigger waittill("trigger", player);
thread rotater2();
if(isdefined(rot1))
{	
for(i=0;i<rot1.size;i++)
{
if (!isdefined(rot1[i].speed))
	rot1[i].speed = 3;
if (!isdefined(rot1[i].script_noteworthy))
	rot1[i].script_noteworthy = "z";
while(true)
{
        if (rot1[i].script_noteworthy == "z")
	rot1[i] rotateYaw(360,rot1[i].speed);
	else if (rot1[i].script_noteworthy == "x")
	rot1[i] rotateRoll(360,rot1[i].speed);
	else if (rot1[i].script_noteworthy == "y")
	rot1[i] rotatePitch(360,rot1[i].speed);
	wait ((rot1[i].speed)-0.1);
}
}
}
}


rotater2()
{
rot1 = getEntarray("final_rotator2", "targetname");
if(isdefined(rot1))
{	
for(i=0;i<rot1.size;i++)
{
if (!isdefined(rot1[i].speed))
	rot1[i].speed = 3;
if (!isdefined(rot1[i].script_noteworthy))
	rot1[i].script_noteworthy = "z";
	while(true)
	{
        if (rot1[i].script_noteworthy == "z")
	rot1[i] rotateYaw(360,rot1[i].speed);
	else if (rot1[i].script_noteworthy == "x")
	rot1[i] rotateRoll(360,rot1[i].speed);
	else if (rot1[i].script_noteworthy == "y")
	rot1[i] rotatePitch(360,rot1[i].speed);
	wait ((rot1[i].speed)-0.1);
	}
}
}
}

trap_roller()
{
trigger = getEnt("Trap_Slide_Pusher", "targetname");
tube = getEnt("rollerbar", "targetname");
if (!isdefined(tube.speed))
 tube.speed = 2;
if (!isdefined(tube.script_noteworthy))
 tube.script_noteworthy = "y";
trigger waittill("trigger", player);
if (tube.script_noteworthy == "z")
  tube rotateYaw(360,tube.speed);
 else if (tube.script_noteworthy == "x")
  tube rotateRoll(360,tube.speed);
 else if (tube.script_noteworthy == "y")
  tube rotatePitch(360,tube.speed);
 wait ((tube.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 }

 ////endroom
 
/*  finishmap()
{
triggertele = getEnt("finish_trig", "targetname");
spawnorigin = getEnt("finish", "targetname");
level.actspawnorigin = getEnt("actendroom", "targetname");
for(;;)
{
triggertele waittill("trigger", player);
player SetOrigin( spawnorigin.origin );
player setplayerangles(spawnorigin.angles );
wait(0.05);
level.activ SetOrigin( level.actspawnorigin.origin );
level.activ setplayerangles(level.actspawnorigin.angles );
level.actspawnorigin delete();
}
} */
 
 WatchEndTrigger()
{	
	triggertele = getEnt("finish_trig", "targetname");
	level.acti_enemy = undefined;
	level.turn = 1;
	level.jumper_turn = [];
	while(1)
	{
		triggertele waittill("trigger", player );
		if( getTeamPlayersAlive("axis") < 1 )
		{
			player iprintlnbold("^1You can't fight alone.");
			return;
		}
		
		if( isDefined( level.acti_enemy ) && level.acti_enemy != player )
		{
			self.control = 0;
			for(clturn=1;clturn<level.turn;clturn++)
			{
				if( level.jumper_turn[clturn] ==  player )
				{	self.control = 1;
				}
			}
			
			if( self.control != 1)
			{
				level.turn = level.turn + 1;
				player iprintlnbold("^3Finished " + level.turn );
				level.jumper_turn[level.turn] = player;
				wait 3;
			}
			else
			{
				player iprintlnbold("Wait your turn.");
				wait 3;
			}
			
				
		}
		if( !isDefined(level.acti_enemy))
		{
			level.jumper_turn[level.turn] = player;
			level.acti_enemy = level.jumper_turn[1];
			iprintlnbold( player.name + " finished first!");
			iprintlnbold("^11 VS 1 Fight!");
			thread StartFinalFight();
			thread controljumper();	
		}
	}
}
controljumper()
{
	
	while(1)
	{
		
		if(isAlive(level.acti_enemy))
		{
			for(turn=1;turn<level.turn;turn++)
			{
				iprintln( turn + "^2 >" + level.jumper_turn[turn]);
				wait 2;
	   		}
			
		}
		else
		{
			for(turn=1;turn<level.turn;turn++)
			{	
				if( isAlive(level.jumper_turn[turn]))
				{
					level.acti_enemy = level.jumper_turn[turn];
					thread StartFinalFight();
				}
			}	
		     }
	wait 3;
	}
}

StartFinalFight()
{
	

	acti = undefined;
	jumper = level.acti_enemy;

	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "axis" && isAlive(players[i]) )
		{
			acti = players[i];
			break;
		}
	}
	



	spawnorigin = getEnt("finish", "targetname");
	level.actspawnorigin = getEnt("actendroom", "targetname");
	
	acti SetPlayerAngles( level.actspawnorigin.angles );
	acti SetOrigin( level.actspawnorigin.origin );
	jumper SetPlayerAngles( spawnorigin.angles );
	jumper SetOrigin( spawnorigin.origin );


	acti FreezeControls(1);
	jumper FreezeControls(1);
	

	wait 2;

	noti = SpawnStruct();
	noti.titleText = "=|FINAL FIGHT|=";
	noti.notifyText = "1 VS 1 ";
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 2;
	
	noti = SpawnStruct();
	noti.titleText = acti.name + " ^3VS ^7" + jumper.name;
	noti.notifyText = "GET READY!";
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	
	wait 2;
	
	VisionSetNaked( "finalfight_mp", 2 );
	jumper FreezeControls(0);
	acti FreezeControls(0);
	
	iprintlnbold("^3F  I  G  H  T !");
}