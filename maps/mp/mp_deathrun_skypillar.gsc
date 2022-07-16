//exec deatehrun.cfg +set fs_game Mods/deathrun_updated +set scr_game_playerwaittime 0 +set scr_game_matchstarttime 0 +exec deathrun.cfg +developer 0 +devmap mp_deathrun_skypillar
main()
{
	maps\mp\_load::main();
	
	// ambientPlay("ambient1");
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2000");
	
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("ak74u_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("rpg_mp");
	// level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
	// level.flame = loadfx("fire/tank_fire_engine");
	
	swingarmparts = getentarray("swingarms","targetname");
	if(isdefined(swingarmparts))
	{
	for(i=0;i<swingarmparts.size;i++)
	{
	swingarmparts[i] thread swingarm();
	}
	}
	
	tolparts = getentarray("tol","targetname");
	if(isdefined(tolparts))
	{
	for(i=0;i<tolparts.size;i++)
	{
	tolparts[i] thread toltrap();
	}
	}
		
	floor = getentarray("rotate2bars","targetname");
	if(isdefined(floor))
	{
	for(i=0;i<floor.size;i++)
	{
	floor[i] thread rotate2bars();
	}
	}
	
	//threads
	thread way_connect();
	// thread creatorcredit();
	// thread trap_rotatefloor();
	thread platformlift();
	thread platformmove();
	thread liftsecond();
	// thread dropdownfloor();
	// thread lift1();
	// thread liftact2();
	// thread trap2solid();
	// thread dropdownblocktrap();
	// thread spinfloortrap();
	// thread activatorelevator3();
	// thread activatorelevator4();
	thread elevatorjump1();
	// thread trapmovers();
	// thread trapnotsolid();
	thread step1_move();
	thread secondoor();
	// thread teleportsniperroom();
	thread secretroom();
	thread BugFix();
	// thread jumptelegame();
	// thread addtriggers();
	// thread airtest();
	// thread lastonestandinggame();
	// thread dodvar();
	// thread discocheck( 1 );
	// thread finish();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	speedrun\_way_name::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

dodvar()
{
setDvar("player_meleeRange", 64);
}

BugFix()
{
	spawnpoint = (550, -2200, -5300);
	lamp = (7, 1376, -4450);
	spawnlamp = (27, 1366, -4131);
	falldingsbums = (-3130, 2559, -5282);
	station = (711, -6388, -5419);
	for(;;)
	{
		players = getentarray("player", "classname");
		for(i=0; i<players.size; i++)
		{
			if( isDefined(players[i]) && players[i].pers["team"] == "allies" && distance(spawnpoint, players[i].origin) >= 1010 && distance(falldingsbums, players[i].origin) >= 800 && distance(station, players[i].origin) >= 1500 && players[i].origin[2] <= -5270)
				players[i] suicide();
			if( isDefined(players[i]) && distance(lamp, players[i].origin) <= 100 )			
				players[i] setOrigin(spawnlamp);
		}
		wait .05;
	}
}

addtriggers()
{
    addTriggerToList("trigger_trap1");
    addTriggerToList("trigger_swingarm");
    addTriggerToList("trap3");
    addTriggerToList("trigger_dropdownblock");
    addTriggerToList("trigger_spinningfloor");
    addTriggerToList("trigger_tol");
    addTriggerToList("trigger_movers");
    addTriggerToList("trigger_notsolid");
	addTriggerToList("trigger_trap2");
	addTriggerToList("trigger_freefallfloor");
}

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

creatorcredit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "Skypillar" );
wait(4);
thread drawInformation( 800, 0.8, 1, "© Wingzor & Paradise" );
wait(4);
}

trap_rotatefloor()
{
floor=getent("rotatefloor","targetname");
if (!isdefined(floor.speed))
 floor.speed = 10;
if (!isdefined(floor.script_noteworthy))
 floor.script_noteworthy = "y";
trigger_rotatefloor=getent("trigger_trap1","targetname");
trigger_rotatefloor waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (floor.script_noteworthy == "z")
  floor rotateYaw(360,floor.speed);
 else if (floor.script_noteworthy == "x")
  floor rotateRoll(360,floor.speed);
 else if (floor.script_noteworthy == "y")
  floor rotatePitch(360,floor.speed);
 wait ((floor.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // floor waittill("rotatedone");
}
}
}

//liftertrigger
platformlift()
{
trigger =getent("liftertrigger","targetname");
lift=getent("platformlifter","targetname");
trigger waittill("trigger", player);
while(1)
{
wait(2);
lift movez(1609,3);
wait(6);
lift movez(-1609,2);
lift waittill ("movedone");
wait(1);
}
}

platformmove()
{
mover=getent("platformmover","targetname");
while(1)
{
mover movey(642,4);
mover waittill ("movedone");
wait(0.5);
mover movey(-642,4);
mover waittill ("movedone");
wait(0.5);
}
}

elevatorjump1()
{
trigger=getent("trigger_teleportlift","targetname");
teleport=getent("teleportlift_origin","targetname");
for(;;)
{
trigger waittill("trigger", player);
player SetOrigin( teleport.origin );
player setplayerangles(teleport.angles );
}
}

swingarm()
{

if (!isdefined(self.speed))
 self.speed = 1;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "y";
swingarmtrig =getent("trigger_swingarm","targetname");
swingarmtrig waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 wait(2);
}
}
}

//lift2
liftsecond()
{
lift=getent("lift2","targetname");
while(1)
{
lift movez(1325,3);
lift waittill ("movedone");
wait(1.5);
lift solid();
lift movez(-1325,1);
lift waittill ("movedone");
wait(2);
}
}

//dropfloor
//trigger_freefallfloor

dropdownfloor()
{
dropdownfloortrig =getent("trigger_freefallfloor","targetname");
floor=getent("dropfloor","targetname");
dropdownfloortrig waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
floor movez(-1816,1);
floor waittill ("movedone");
floor movez(1816,5);
floor waittill ("movedone");
wait(10);
}
}

lift1()
{
lift = getEnt("lift", "targetname");
trigger = getEnt("trigger_lift1", "targetname");
trigger waittill("trigger", player);
while(1)
{
lift movez (1408,3);
lift waittill ("movedone");
wait(5);
lift movez (-1408,3);
lift waittill ("movedone");
wait(5);
}
}

trap2solid()
{
trap2floor = getEnt("trap2brush", "targetname");
solidtrigger = getEnt("trigger_trap2", "targetname");
solidtrigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want

trap2floor notsolid();
wait(3);
trap2floor solid();
wait(1);
trap2floor solid();
}
}

rotate2bars()
{
if (!isdefined(self.speed))
 self.speed = 4;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "x";
trigger_rotatefloor=getent("trap3","targetname");
trigger_rotatefloor waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 wait(3);
}
}
}

dropdownblocktrap()
{
level.block = getEnt("dropdownblock", "targetname");
downtrigger = getEnt("trigger_dropdownblock", "targetname");
downtrigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
level.block movey(-1008,0.1);
level.block waittill("movedone");
wait(5);
level.block delete();
}
}

liftact2()
{
lift = getEnt("liftactivator2", "targetname");
trigger = getEnt("trigger_lift2", "targetname");
trigger waittill("trigger", player);
while(1)
{
lift movez (896,3);
lift waittill ("movedone");
wait(5);
lift movez (-896,3);
lift waittill ("movedone");
wait(5);
}
}

spinfloortrap()
{
//spinningfloor
//trigger_spinningfloor
spinner = getEnt("spinningfloor", "targetname");
if (!isdefined(spinner.speed))
 spinner.speed = 2;
if (!isdefined(spinner.script_noteworthy))
 spinner.script_noteworthy = "z";
spintrigger = getEnt("trigger_spinningfloor", "targetname");
spintrigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (spinner.script_noteworthy == "z")
  spinner rotateYaw(360,spinner.speed);
 else if (spinner.script_noteworthy == "x")
  spinner rotateRoll(360,spinner.speed);
 else if (spinner.script_noteworthy == "y")
  spinner rotatePitch(360,spinner.speed);
 wait ((spinner.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // spinner waittill("rotatedone");
}
}
}

activatorelevator3()
{
//activatorlift3
//trigger_activatorlift3
//movez 992
lift = getEnt("activatorlift3", "targetname");
trigger = getEnt("trigger_activatorlift3", "targetname");
trigger waittill("trigger", player);
while(1)
{
lift movez (992,3);
lift waittill ("movedone");
wait(5);
lift movez (-992,3);
lift waittill ("movedone");
wait(5);
}
}


activatorelevator4()
{

lift = getEnt("Activatorlift4", "targetname");
trigger = getEnt("trigger_Activatorlift4", "targetname");
trigger waittill("trigger", player);
while(1)
{
lift movez (1136,3);
lift waittill ("movedone");
wait(5);
lift movez (-1136,3);
lift waittill ("movedone");
wait(5);
}
}

finish()
{
level.actorigin = getEnt("finishactivator_origin", "targetname");
cagefightorigin = getEnt("jumperfinish_origin", "targetname");
level.finishtrigger = getEnt("trigger_finish", "targetname");
for(;;)
{
level.finishtrigger waittill("trigger", player);
level.snipertrigger delete();
level.jumptele delete();
iPrintLnBold(player.name+ " has entered ^1StationFight !"); //Change the message if you want
wait(0.05);
level.activ SetOrigin( level.actorigin.origin );
level.activ setplayerangles( level.actorigin.angles );
level.actorigin delete();
level.activ iPrintLnBold("Someone entered the ^1Fight !");
player SetOrigin( cagefightorigin.origin );
player setplayerangles(cagefightorigin.angles );
}
}

toltrap()
{

if (!isdefined(self.speed))
 self.speed = 1;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
toltrig =getent("trigger_tol","targetname");
toltrig waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(720,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(720,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(720,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 wait(2);
}
}
}

//trigger_movers
//part1
//part2
trapmovers()
{
partmover1 = getEnt("part1", "targetname");
partmover2 = getEnt("part2", "targetname");
movetrigger = getEnt("trigger_movers", "targetname");
movetrigger waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
while(1)
{
partmover1 movez (128,0.3);
partmover1 waittill ("movedone");
partmover1 movez (-128,0.3);
partmover1 waittill ("movedone");
partmover2 movez (256,0.3);
partmover2 waittill ("movedone");
partmover2 movez (-256,0.3);
partmover2 waittill ("movedone");
}
}
}

trapnotsolid()
{
platforms = getEntArray("notsolidparts", "targetname");
level.square = getEnt("trigger_notsolid", "targetname");
level.square waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
}
else
{
player iPrintLnBold("^1Activated !"); //Change the message if you want
for(i=0; i<4; i++)
{
wait(0.05);
platforms[randomInt(platforms.size)] notsolid();
}
}
}

step1()
{
    step1 = getentarray("step","targetname");
    for(i=0;i<step1.size;i++)
    step1[i] thread step1_move();
}

step1_move()
{
    org_end = (225.5,1023,-6);
    org_start = (224,-2144,-2016);
	org = self.origin;
	step1 = getentarray("step","targetname");
    while(1)
    {	
	for(i=0;i<step1.size;i++)
	{	
		step1[i] moveto ((org_start + (0,-100,16)), 0.1);
		wait(0.05);
		step1[i] moveto ((org_start + (0,-10,0)), 2);
		step1[i] waittill ("movedone");
		wait(1);
        step1[i] moveto (org_end, 2);
		wait(2);
		step1[i] waittill ("movedone");
		wait(3);
		step1[i] hide();
        step1[i] notsolid();
		wait(1);
		step1[i] moveto ((org_start + (0,-100,16)), 0.1);
		step1[i] show();
		step1[i] solid();
		        //if(self[i].origin == org_end)
         //   {
            //step1[i] hide();
            //step1[i] notsolid();
         //   step1[i] moveto(org_start, 0.1);
		//	step1[i] waittill ("movedone");
			//step1[i] show();
			//step1[i] solid();
        //    }
	}
    }
}

rotateend()
{

if (!isdefined(self.speed))
 self.speed = 3;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 wait(5);
}
}

//trigger_seconddoor
//seconddoor
secondoor()
{
partmover1 = getEnt("seconddoor", "targetname");
trigger = getEnt("trigger_seconddoor", "targetname");

wait 0.05;
trigger delete();

partmover1 movez (300,0.1);
}

//trigger_sniperroom
//sniperroom_jumperorigin
//sniperact
teleportsniperroom()
{
level.snipeactorigin = getEnt("sniperact", "targetname");
teleorigin = getEnt("sniperroom_jumperorigin", "targetname");
level.snipertrigger = getEnt("trigger_sniperroom", "targetname");
for(;;)
{
level.snipertrigger waittill("trigger", player);
level.finishtrigger delete();
level.jumptele delete();
setDvar("player_meleeRange", 0);
wait(0.05);
player SetOrigin( teleorigin.origin );
player setplayerangles( teleorigin.angles );
wait(0.05);
level.activ freezeControls( true );
wait(0.5);
iPrintLnBold(player.name+ "^1 has entered the sniper room"); //Change the message if you want
player takeallweapons();
player GiveWeapon("m40a3_mp");
player GiveWeapon("remington700_mp");
player SwitchToWeapon( "m40a3_mp" );
level.activ SetOrigin( level.snipeactorigin.origin );
level.activ setplayerangles( level.snipeactorigin.angles );
level.activ freezeControls( false );
wait(0.05);
level.activ takeallweapons();
level.activ GiveWeapon("m40a3_mp");
level.activ GiveWeapon("remington700_mp");
level.activ SwitchToWeapon( "m40a3_mp" );
level.snipeactorigin delete();
}
}

//secret
//secret_origin

//secretteleport_origin
//secretteleport_back
//secretteleporttrigger
//backtomap
secretroom()
{
level.secretenterorigin = getEnt("secretteleport_origin", "targetname");
telebackorigin = getEnt("backtomap", "targetname");
level.triggerback = getEnt("secretteleport_back", "targetname");
triggersecrettele = getEnt("secretteleporttrigger", "targetname");
thread secretroom_back();
for(;;)
{
triggersecrettele waittill("trigger", player);
player SetOrigin( level.secretenterorigin.origin );
player setplayerangles( level.secretenterorigin.angles );
player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
}
}

secretroom_back()
{
level.secretenterorigin = getEnt("secretteleport_origin", "targetname");
telebackorigin = getEnt("backtomap", "targetname");
level.triggerback = getEnt("secretteleport_back", "targetname");
triggersecrettele = getEnt("secretteleporttrigger", "targetname");
for(;;)
{
level.triggerback waittill("trigger", player);
player thread braxi\_mod::endTimer();
}
}

//jump_origin
//jump_teleportn
jumptelegame()
{
level.actjumperorigin = getEnt("actjump_origin", "targetname");
level.jumperorigin = getEnt("jump_origin", "targetname");
level.jumptele = getEnt("jump_teleport", "targetname");
for(;;)
{
level.jumptele waittill("trigger", player);
level.finishtrigger delete();
level.snipertrigger delete();
wait(0.05);
player SetOrigin( level.jumperorigin.origin );
player setplayerangles( level.jumperorigin.angles );
wait(0.05);
player iPrintLnBold("Welcome to the JumpGame !"); //Change the message if you want
level.activ freezeControls( true );
wait(0.5);
level.activ SetOrigin( level.actjumperorigin.origin );
level.activ setplayerangles( level.actjumperorigin.angles );
level.activ iPrintLnBold("Welcome to the JumpGame !"); //Change the message if you want
level.activ freezeControls( false );
}
}

//jumperfinish_origin
//jumperfinish



//trigger_aistrike
airtest()
{
xptrig = getEnt("trigger_aistrike", "targetname");
precacheItem("deserteaglegold_mp");	
enabled = true;
while(1)
{
xptrig waittill("trigger", player);

if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1What the ....!"); //Change the message if you want
enabled = false;
}

if(!isDefined(player.used))
{
player.used = false;
}

if(isDefined(player.used) && player.used == true)
{
player iPrintlnBold("that was enough dont u think ?");
}

if(isDefined(player.used) && player.used == false && enabled == true)
{
    randomMessages = []; // List of random messages when player has had a bottle recently, you can have as many of them as you want.
	randomMessages[0] = "^2Enjoy your Deagle :D";
	randomMessages[1] = "^1Careful! You got a powerfull weapon!";
	randomMessages[2] = "^3Oh no! You found one ";
	randomMessages[3] = "^4You're greedy ain't ya?";
	randomMessages[4] = "^5Have a nice day sir !";
	player iPrintlnBold(randomMessages[randomInt(randomMessages.size)]); // display one of the rather insulting messages to the player.
	player takeallweapons();
	player GiveWeapon("deserteaglegold_mp");
	player SwitchToWeapon( "deserteaglegold_mp" );
	player.used = true;
}
}
}



discocheck( requiredPlayersCount )
{
	for(;;)
	{
		wait 0.5;
		count = 0;
		players = getAllPlayers();
		for( i = 0; i < players.size; i++ )
			if( players[i] isPlaying() )
				count++;
 
		if( count == requiredPlayersCount )
		{
SetExpFog(1024, 2048, 1, 0, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 1, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 0, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 1, 0.8, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.8, 0, 0.6, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 1, 0.6, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 1, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 0, 0.8, 0); 
wait .1;  
SetExpFog(1024, 2048, 0.2, 1, 0.8, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 0.4, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 0, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 0.2, 0.2, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 1, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.6, 0, 0.4, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 0, 0.8, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 1, 0, 0);  
wait .1;   
SetExpFog(1024, 2048, 0.6, 1, 0.6, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 0, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 1, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 0, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 1, 0.8, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.8, 0, 0.6, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 1, 0.6, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 1, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 0, 0.8, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.2, 1, 0.8, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 0.4, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0, 0, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 0.2, 0.2, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.4, 1, 1, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.6, 0, 0.4, 0);  
wait .1;  
SetExpFog(1024, 2048, 1, 0, 0.8, 0); 
wait .1;  
SetExpFog(1024, 2048, 1, 1, 0, 0);  
wait .1;  
SetExpFog(1024, 2048, 0.6, 1, 0.6, 0); 
}
else
{
SetExpFog(2048, 4096, 0, 0, 0, 0); 
}	
}
}


getAllPlayers()
{
	return getEntArray( "player", "classname" );
}

isReallyAlive()
{
	return self.sessionstate == "playing";
}
 
isPlaying()
{
	return isReallyAlive();
}

//lastmanstanding
//lastonestandingjumperorigin
//lastonestandingactivatororigin
lastonestandinggame()
{
level.jumperlast = getEnt("lastonestandingjumperorigin", "targetname");
level.actorlast = getEnt("lastonestandingactivatororigin", "targetname");
lastmanstandingtrigger = getEnt("lastmanstanding", "targetname");
for(;;)
{
lastmanstandingtrigger waittill("trigger", player);
count = 0;
players = getAllPlayers();
for( i = 0; i < players.size; i++ )
if( players[i] isPlaying() )
count++;
if( count == 2 )
{
iPrintLnBold("last standing tele"); //Change the message if you want
player SetOrigin( level.jumperlast.origin );
player setplayerangles( level.jumperlast.angles );
level.activ SetOrigin( level.actorlast.origin );
level.activ setplayerangles( level.actorlast.angles );
level.actorlast delete();

player takeallweapons();
player GiveWeapon("rpg_mp");
player thread doAmmo();
player SwitchToWeapon( "rpg_mp" );
level.activ takeallweapons();
level.activ GiveWeapon("rpg_mp");
level.activ thread doAmmo();
level.activ SwitchToWeapon("rpg_mp" );
}
}
}

doAmmo()
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

//nukebulletstrigger
createnuke()
{
level.craftnukes = getEnt("nukebulletstrigger", "targetname");
for(i=0;i<1;i++)
{
level.craftnukes waittill("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("Want to burn your hands ?"); //Change the message if you want
}
else
{
player iprintlnbold("You ^1Evil ^7sorcerer !");
player iprintlnbold("You crafted nuke bullets !");
player thread killstreak3();
level.craftnukes delete();
}
}
}

killstreak3()
{
self endon("death");
while(1)
{
self waittill("weapon_fired");
my = self gettagorigin("j_head");
trace=bullettrace(my, my + anglestoforward(self getplayerangles())*100000,true,self)["position"];
playfx(level.expbullt,trace);
self playSound( "artillery_impact" );
dis=distance(self.origin, trace);
if(dis<101) RadiusDamage( trace, dis, 200, 50, self );
RadiusDamage( trace, 60, 250, 50, self );
RadiusDamage( trace, 100, 800, 50, self );
vec = anglestoforward(self getPlayerAngles());
end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
explode = loadfx( "fire/tank_fire_engine" );
playfx(explode, SPLOSIONlocation);
self thread DamageArea(SPLOSIONlocation,500,800,200,"artillery_mp",false);
}
}

DamageArea(Point,Radius,MaxDamage,MinDamage,Weapon,TeamKill)
{
KillMe = false;
Damage = MaxDamage;
for(i=0;i<level.players.size+1;i++){
DamageRadius = distance(Point,level.players[i].origin);
if(DamageRadius<Radius){
if(MinDamage<MaxDamage)
Damage = int(MinDamage+((MaxDamage-MinDamage)*(DamageRadius/Radius)));
if((level.players[i] != self) && ((TeamKill && level.teamBased) || ((self.pers["team"] != level.players[i].pers["team"]) && level.teamBased) || !level.teamBased))
level.players[i] FinishPlayerDamage(level.players[i],self,Damage,0,"MOD_PROJECTILE_SPLASH",Weapon,level.players[i].origin,level.players[i].origin,"none",0);
if(level.players[i] == self)
KillMe = true;
}
wait 0.01;
}
RadiusDamage(Point,Radius-(Radius*0.25),MaxDamage,MinDamage,self);
if(KillMe)
self FinishPlayerDamage(self,self,Damage,0,"MOD_PROJECTILE_SPLASH",Weapon,self.origin,self.origin,"none",0);
}
