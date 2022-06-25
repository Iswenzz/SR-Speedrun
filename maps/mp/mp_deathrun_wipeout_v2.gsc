main()
/*
                                     __                     __     __                                                                                           __                        ___     
                                    /\ \                   /\ \__ /\ \                                                    __                                   /\ \__                   /'___`\   
        ___ ___    _____            \_\ \      __      __  \ \ ,_\\ \ \___    _ __   __  __    ___            __  __  __ /\_\   _____      __     ___    __  __\ \ ,_\          __  __ /\_\ /\ \  
      /' __` __`\ /\ '__`\          /'_` \   /'__`\  /'__`\ \ \ \/ \ \  _ `\ /\`'__\/\ \/\ \ /' _ `\         /\ \/\ \/\ \\/\ \ /\ '__`\  /'__`\  / __`\ /\ \/\ \\ \ \/         /\ \/\ \\/_/// /__ 
      /\ \/\ \/\ \\ \ \L\ \        /\ \L\ \ /\  __/ /\ \L\.\_\ \ \_ \ \ \ \ \\ \ \/ \ \ \_\ \/\ \/\ \        \ \ \_/ \_/ \\ \ \\ \ \L\ \/\  __/ /\ \L\ \\ \ \_\ \\ \ \_        \ \ \_/ |  // /_\ \
      \ \_\ \_\ \_\\ \ ,__/        \ \___,_\\ \____\\ \__/.\_\\ \__\ \ \_\ \_\\ \_\  \ \____/\ \_\ \_\        \ \___x___/' \ \_\\ \ ,__/\ \____\\ \____/ \ \____/ \ \__\        \ \___/  /\______/
       \/_/\/_/\/_/ \ \ \/   _______\/__,_ / \/____/ \/__/\/_/ \/__/  \/_/\/_/ \/_/   \/___/  \/_/\/_/  _______\/__//__/    \/_/ \ \ \/  \/____/ \/___/   \/___/   \/__/  _______\/__/   \/_____/ 
                     \ \_\  /\______\                                                                  /\______\                  \ \_\                                  /\______\                
                      \/_/  \/______/                                                                  \/______/                   \/_/                                  \/______/                
										                                                                                                                                               By Paradise*/
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
	level.spawn["axis"] = getEntArray("mp_activator_spawn", "classname");
	level.masterSpawn = spawn("script_origin", level.spawn["allies"][0].origin);
level.masterSpawn.angles = level.spawn["allies"][0].angles;
trigger = spawn("trigger_radius", (1687, 3765, 524), 0, 300, 300);
trigger.targetname = "endmap_trig";
trigger.radius = 300;	
	maps\mp\_load::main();
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	// AmbientPlay("zor");

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	
thread way_connect();
thread trap1a();
thread trap2ground();
thread trap3swings();
thread trap5_main();
// thread droppers();
thread finished();
thread pushers();
thread twister();
thread shufflers();
thread sweepert();
thread trap_4squares();
thread escalator();
thread deathtrigger();
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

deathtrigger()
{
trigger=getent("death_trigger","targetname");

	while(1)
	{
	trigger waittill("trigger",player);
	player thread diezor();
	}
}

diezor()
{
	// self PlaySoundToPlayer("die", self );
	self suicide();
}

escalator()
{
end=(-1032,3760,60);
start=(56,3760,435);
escalator1=getent("escalator1","targetname");
escalator2=getent("escalator2","targetname");
escalator3=getent("escalator3","targetname");
escalator4=getent("escalator4","targetname");
escalator1 notsolid();
escalator1 hide();
escalator2 notsolid();
escalator2 hide();
escalator3 notsolid();
escalator3 hide();
escalator4 notsolid();
escalator4 hide();
trigger=getent("act8","targetname");
trigger waittill("trigger", player);
thread escal1(end,start);
thread escal2(end,start);
thread escal3(end,start);
thread escal4(end,start);
}

escal1(end,start)
{
escalator1=getent("escalator1","targetname");
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

escal2(end,start)
{
escalator1=getent("escalator2","targetname");
wait 1;
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

escal3(end,start)
{
escalator1=getent("escalator3","targetname");
wait 2;
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

escal4(end,start)
{
escalator1=getent("escalator4","targetname");
wait 3;
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

trap_4squares()
{
wait 10;
platforms = getEntArray("4squares", "targetname");
level.square = getEnt("trigger_4squares", "targetname");
trigger=getent("act7","targetname");
trigger waittill("trigger", player);
wait(0.05);
platforms[randomInt(platforms.size)] movez(-200,4);
}

sweepert()
{
sweeper=getent("sweepert","targetname");
if (!isdefined(sweeper.speed))
 sweeper.speed = 8;
if (!isdefined(sweeper.script_noteworthy))
 sweeper.script_noteworthy = "z";
trigger=getent("act6","targetname");
trigger waittill("trigger", player);
while(true)
{
 if (sweeper.script_noteworthy == "z")
  sweeper rotateYaw(360,sweeper.speed);
 else if (sweeper.script_noteworthy == "x")
  sweeper rotateRoll(360,sweeper.speed);
 else if (sweeper.script_noteworthy == "y")
  sweeper rotatePitch(360,sweeper.speed);
 wait ((sweeper.speed)-0.1);
}
}

shufflers()
{
level.shuf1=(-3184,-448,624);
level.shuf2=(-1648,-448,624);
level.shuf3=(-1648,-448,336);
level.shuf4=(-3184,-448,336);
trigger=getent("act5","targetname");
trigger waittill("trigger", player);
thread shuffler1();
thread shuffler2();
thread shuffler3();
thread shuffler4();
thread shuffler5();
thread shuffler6();
thread shuffler7();
thread shuffler8();
}

shuffler1()
{
shuffle1=getent("shuffle1","targetname");
while(1)
{
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
}
}

shuffler2()
{
shuffle1=getent("shuffle2","targetname");
while(1)
{
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
}
}

shuffler3()
{
shuffle1=getent("shuffle3","targetname");
shuffle1 moveto(level.shuf2,2);
shuffle1 waittill("movedone");
while(1)
{
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
}
}

shuffler4()
{
shuffle1=getent("shuffle4","targetname");
shuffle1 moveto(level.shuf2,1);
shuffle1 waittill("movedone");
while(1)
{
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
}
}

shuffler5()
{
shuffle1=getent("shuffle5","targetname");
while(1)
{
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
}
}

shuffler6()
{
shuffle1=getent("shuffle6","targetname");
while(1)
{
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
}
}

shuffler7()
{
shuffle1=getent("shuffle7","targetname");
shuffle1 moveto(level.shuf4,2);
shuffle1 waittill("movedone");
while(1)
{
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
}
}

shuffler8()
{
shuffle1=getent("shuffle8","targetname");
shuffle1 moveto(level.shuf4,1);
shuffle1 waittill("movedone");
while(1)
{
shuffle1 moveto(level.shuf1,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf2,3);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf3,1);
shuffle1 waittill("movedone");
shuffle1 moveto(level.shuf4,3);
shuffle1 waittill("movedone");
}
}

twister()
{
twister=getent("twistpole","targetname");
if (!isdefined(twister.speed))
 twister.speed = 5;
if (!isdefined(twister.script_noteworthy))
 twister.script_noteworthy = "z";
trigger=getent("act4","targetname");
trigger waittill("trigger", player);
while(true)
{
 if (twister.script_noteworthy == "z")
  twister rotateYaw(360,twister.speed);
 else if (twister.script_noteworthy == "x")
  twister rotateRoll(360,twister.speed);
 else if (twister.script_noteworthy == "y")
  twister rotatePitch(360,twister.speed);
 wait ((twister.speed)-0.1);
}
}

pushers()
{
pushers = getEntArray("pusher", "targetname");
trigger=getent("act3","targetname");
trigger waittill("trigger", player);
for(i=0;i<pushers.size;i++)
{
}
while(1)
{
	wait(0.05);
	rand = RandomIntRange( 0, pushers.size );
	rand2 = RandomIntRange( 0, pushers.size );
	rand3 = RandomIntRange( 0, pushers.size );
	
	if(rand!=rand2 && rand!=rand3 && rand2!=rand3)
	{
	pushers[rand] movey(50,0.1);
	pushers[rand2] movey(50,0.1);
	pushers[rand3] movey(50,0.1);
	pushers[rand3] waittill("movedone");
	wait 0.1;
	pushers[rand] movey(-50,0.1);
	pushers[rand2] movey(-50,0.1);
	pushers[rand3] movey(-50,0.1);
	pushers[rand3] waittill("movedone");
	wait 0.1;
	}

}
}

droppers()
{
thread dropper1();
thread dropper2();
thread dropper3();
thread dropper4();
thread dropper5();
thread dropper6();
}
///////////
dropper1()
{
trigger=getent("dropper1","targetname");
dropperarm=getent("dropper1arm","targetname");
dropperturnpoint=getent("dropper1turn","targetname");
dropperarm linkto(dropperturnpoint);
if (!isdefined(dropperturnpoint.speed))
 dropperturnpoint.speed = 2;
if (!isdefined(dropperturnpoint.script_noteworthy))
 dropperturnpoint.script_noteworthy = "x";
	while(1)
		{
		trigger waittill("trigger");
		wait 1;
		dropperturnpoint rotateRoll(-90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		wait 0.5;
		dropperturnpoint rotateRoll(90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		
		}
}
///////////
dropper2()
{
trigger=getent("dropper2","targetname");
dropperarm=getent("dropper2arm","targetname");
dropperturnpoint=getent("dropper2turn","targetname");
dropperarm linkto(dropperturnpoint);
if (!isdefined(dropperturnpoint.speed))
 dropperturnpoint.speed = 2;
if (!isdefined(dropperturnpoint.script_noteworthy))
 dropperturnpoint.script_noteworthy = "x";
	while(1)
		{
		trigger waittill("trigger");
		wait 1;
		dropperturnpoint rotateRoll(-90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		wait 0.5;
		dropperturnpoint rotateRoll(90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		
		}
}
/////////////
dropper3()
{
trigger=getent("dropper3","targetname");
dropperarm=getent("dropper3arm","targetname");
dropperturnpoint=getent("dropper3turn","targetname");
dropperarm linkto(dropperturnpoint);
if (!isdefined(dropperturnpoint.speed))
 dropperturnpoint.speed = 2;
if (!isdefined(dropperturnpoint.script_noteworthy))
 dropperturnpoint.script_noteworthy = "x";
	while(1)
		{
		trigger waittill("trigger");
		wait 1;
		dropperturnpoint rotateRoll(-90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		wait 0.5;
		dropperturnpoint rotateRoll(90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		
		}
}
////////////
dropper4()
{
trigger=getent("dropper4","targetname");
dropperarm=getent("dropper4arm","targetname");
dropperturnpoint=getent("dropper4turn","targetname");
dropperarm linkto(dropperturnpoint);
if (!isdefined(dropperturnpoint.speed))
 dropperturnpoint.speed = 2;
if (!isdefined(dropperturnpoint.script_noteworthy))
 dropperturnpoint.script_noteworthy = "x";
	while(1)
		{
		trigger waittill("trigger");
		wait 1;
		dropperturnpoint rotateRoll(-90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		wait 0.5;
		dropperturnpoint rotateRoll(90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		
		}
}
///////////////
dropper5()
{
trigger=getent("dropper5","targetname");
dropperarm=getent("dropper5arm","targetname");
dropperturnpoint=getent("dropper5turn","targetname");
dropperarm linkto(dropperturnpoint);
if (!isdefined(dropperturnpoint.speed))
 dropperturnpoint.speed = 2;
if (!isdefined(dropperturnpoint.script_noteworthy))
 dropperturnpoint.script_noteworthy = "x";
	while(1)
		{
		trigger waittill("trigger");
		wait 1;
		dropperturnpoint rotateRoll(-90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		wait 0.5;
		dropperturnpoint rotateRoll(90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		
		}
}
/////////////
dropper6()
{
trigger=getent("dropper6","targetname");
dropperarm=getent("dropper6arm","targetname");
dropperturnpoint=getent("dropper6turn","targetname");
dropperarm linkto(dropperturnpoint);
if (!isdefined(dropperturnpoint.speed))
 dropperturnpoint.speed = 2;
if (!isdefined(dropperturnpoint.script_noteworthy))
 dropperturnpoint.script_noteworthy = "x";
	while(1)
		{
		trigger waittill("trigger");
		wait 1;
		dropperturnpoint rotateRoll(-90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		wait 0.5;
		dropperturnpoint rotateRoll(90,dropperturnpoint.speed);
		dropperturnpoint waittill("rotatedone");
		
		}
}





////////////endgame/////////////
finished()
{
level.survtrigger=getent("survivor_trigger","targetname");
		for(;;)
		{
			level.survtrigger waittill("trigger",player);
			player thread createSurvivor();
		}
}

watchrespawners()
{
	while(1)
	{
		level waittill("player_spawn",player);
		player.teleported=false;
	}
}

MonitorEndGame()
{
players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
			if(isDefined(players[i].survivor) && isAlive(players[i]) && players[i]!=level.activ)
				{
				level.ingame=0;
				AmbientStop(2);
				wait 1;
				AmbientPlay("endzor");
				}


while(1)
	{
		player=level.survivor[level.ingame];					
		//if(isAlive(player) && player.teleported)
		//	iprintln("someone is 1v1 with the activator");

		if(isAlive(player) && !player.teleported && !player.issliding)
		{
			iprintln("teleport the new jumper");
			player.teleported=true;
			thread newendgame(player);
		}
		
		if(isdefined(player) && !isAlive(player))
		{
			player.teleported=false; //due respawn i guess
			level.ingame=level.ingame+1;
		}
		
		//iprintlnbold(level.ingame);
		//player iprintlnbold("teleport is: " +player.teleported);
		
		wait 2;
	}
}

newendgame(jumper)
{
actiorg=getent("actiorg","targetname");
jumporg=getent("jumporg","targetname");

jumper freezeControls( true );
level.activ freezeControls( true );

jumper iprintlnbold("^2initializing endgame!");
level.activ iprintlnbold("^2initializing endgame!");
wait 1;

jumper SetOrigin(jumporg.origin);
jumper SetPlayerAngles(jumporg.angles);

level.activ SetOrigin(actiorg.origin);
level.activ SetPlayerAngles(actiorg.angles);

//create randomgame
level.activ takeallweapons();
jumper takeallweapons();

level.activ giveweapon("knife_mp");
level.activ SwitchToWeapon("knife_mp");
jumper giveweapon("knife_mp");
jumper SwitchToWeapon("knife_mp");

wait 1;

jumper iprintlnbold("^1FIGHT");
level.activ iprintlnbold("^1FIGHT");
jumper freezeControls( false );
level.activ freezeControls( false );


}

monitorsweeper()
{

while(level.lastmanstanding==false)
{
		players = getentarray("player", "classname");
		level.survivorsleft=0;
		for(i=0;i<players.size;i++)
			if(isDefined(players[i].atSweeper) && isAlive(players[i]) && players[i]!=level.activ)
				level.survivorsleft++;
			
		if(level.survivorsleft==1)
			{
				for(i=0;i<players.size;i++)
				if(isDefined(players[i].atSweeper) && isAlive(players[i]) && players[i]!=level.activ)
					{
					level.lastmanstanding=true;
					players[i] iprintlnbold("You are the last survivor !");
					//thread endfight(players[i]);
					}
			}
			wait 1;
}

}

createSurvivor()
{
// place=place+1;
// self iprintlnbold("finished: " +place);
self thread rope( (2296,3760,568), (3856,3760,220) );
}

endsweeper()
{
level.lastmanstanding=false;
pos1=getent("org1","targetname");
pos2=getent("org2","targetname");
pos3=getent("org3","targetname");
pos4=getent("org4","targetname");
pos5=getent("org5","targetname");
pos0=getent("org0","targetname");

level.spots = [];
	
	i = 0;
	while( isDefined( getEnt( "org" + i, "targetname" ) ) )
	{
		level.spots[ i ] = getEnt( "org" + i, "targetname" );		
		i++;
	}
players = getentarray("player", "classname");
for(i=0;i<players.size;i++)
				if(isDefined(players[i].survivor) && players[i].survivor && isAlive(players[i]) && players[i]!=level.activ)
				{
					players[i] iprintlnbold("^1You will battle in the sweeper game ! !");
					players[i] SetOrigin(level.spots[ i ].origin);
					players[i] SetPlayerAngles(level.spots[ i ].angles);
					players[i].atSweeper=true;
				}
iprintlnbold("^1Finalround Started");
if(level.lastmanstanding==false)
{
wait 1;
thread monitorsweeper();
iprintlnbold("3");
wait 1;
iprintlnbold("2");
wait 1;
iprintlnbold("1");
wait 1;
iprintlnbold("Go");
sweeper=getent("endsweeper","targetname");
if (!isdefined(sweeper.speed))
 sweeper.speed = 4;
if (!isdefined(sweeper.script_noteworthy))
 sweeper.script_noteworthy = "z";

	while(level.lastmanstanding==false)
	{
	if (sweeper.script_noteworthy == "z")
	sweeper rotateYaw(360,sweeper.speed);
	else if (sweeper.script_noteworthy == "x")
	sweeper rotateRoll(360,sweeper.speed);
	else if (sweeper.script_noteworthy == "y")
	sweeper rotatePitch(360,sweeper.speed);
	wait ((sweeper.speed)-0.1);
	if(sweeper.speed>0.2)
	sweeper.speed=sweeper.speed-0.1;
	}
}
}

rope( start, end )
{
	if( !isDefined( self.linker ) )
		self.linker = Spawn("script_origin", self GetEye()+(0,0,20) );
	
	self.isSliding = true;
	// self iprintlnbold("You can fight the activator once it is your turn !");
	self DisableWeapons();
	self LinkTo( self.linker );
	self.linker MoveTo( start, 1, 0.5, 0.5 );
	wait 1.2;
	self.linker MoveTo( end, 2, 2, 0 );
	wait 2;
	self UnLink();
	self.linker delete();
	self EnableWeapons();
	self.isSliding = false;
}

////////////////////////////////////

trap5_main()
{
main=getent("trap5_main","targetname");
if (!isdefined(main.speed))
 main.speed = 10;
if (!isdefined(main.script_noteworthy))
 main.script_noteworthy = "z";
	while(1)
		{
		if (main.script_noteworthy == "z")
		main rotateYaw(360,main.speed);
		else if (main.script_noteworthy == "x")
		main rotateRoll(360,main.speed);
		else if (main.script_noteworthy == "y")
		main rotatePitch(360,main.speed);
		wait ((main.speed)-0.1);
		}
}


trap3swings()
{
trap3_inner=getent("trap3_inner","targetname");
trap3_outer=getent("trap3_outer","targetname");
trigger=getent("act2","targetname");
trigger waittill("trigger", player);

if (!isdefined(trap3_outer.speed))
 trap3_outer.speed = 5;
if (!isdefined(trap3_outer.script_noteworthy))
 trap3_outer.script_noteworthy = "y";
 thread trap3innerswing();
	while(1)
		{
		
		rand = RandomIntRange( 3, 5 );
		trap3_outer.speed = rand;
		if (trap3_outer.script_noteworthy == "z")
		trap3_outer rotateYaw(360,trap3_outer.speed);
		else if (trap3_outer.script_noteworthy == "x")
		trap3_outer rotateRoll(360,trap3_outer.speed);
		else if (trap3_outer.script_noteworthy == "y")
		trap3_outer rotatePitch(360,trap3_outer.speed);
		wait ((trap3_outer.speed)-0.1);
		}
}

trap3innerswing()
{
trap3_inner=getent("trap3_inner","targetname");
if (!isdefined(trap3_inner.speed))
 trap3_inner.speed = 5;
if (!isdefined(trap3_inner.script_noteworthy))
 trap3_inner.script_noteworthy = "y";
 thread trap3lastswing();
	while(1)
		{
		
		rand = RandomIntRange( 3, 5 );
		trap3_inner.speed = rand;
		if (trap3_inner.script_noteworthy == "z")
		trap3_inner rotateYaw(-360,trap3_inner.speed);
		else if (trap3_inner.script_noteworthy == "x")
		trap3_inner rotateRoll(-360,trap3_inner.speed);
		else if (trap3_inner.script_noteworthy == "y")
		trap3_inner rotatePitch(-360,trap3_inner.speed);
		wait ((trap3_inner.speed)-0.1);
		}
}

trap3lastswing()
{
trap3_last=getent("trap3_last","targetname");
if (!isdefined(trap3_last.speed))
 trap3_last.speed = 5;
if (!isdefined(trap3_last.script_noteworthy))
 trap3_last.script_noteworthy = "y";
	while(1)
		{
		
		rand = RandomIntRange( 4, 6 );
		trap3_last.speed = rand;
		side = RandomIntRange( 1, 10 );
		if(side<=5)
			side=(360);
		else
		side=(-360);
		
		if (trap3_last.script_noteworthy == "z")
		trap3_last rotateYaw(side,trap3_last.speed);
		else if (trap3_last.script_noteworthy == "x")
		trap3_last rotateRoll(side,trap3_last.speed);
		else if (trap3_last.script_noteworthy == "y")
		trap3_last rotatePitch(side,trap3_last.speed);
		wait ((trap3_last.speed)-0.1);
		}
}

trap2ground()
{
trap2_0=getent("trap2_0","targetname");
trap2_1=getent("trap2_1","targetname");
trap2_2=getent("trap2_2","targetname");
trap2_3=getent("trap2_3","targetname");

trigger=getent("act1","targetname");
trigger waittill("trigger", player);

thread trap2movers();
	while(1)
	{
		trap2_0 movez(-100,1);
		trap2_0 waittill("movedone");
		trap2_1 movez(-100,1);
		trap2_1 waittill("movedone");
		trap2_0 movez(100,1);
		trap2_2 movez(-100,1);
		trap2_2 waittill("movedone");
		trap2_1 movez(100,1);
		trap2_3 movez(-100,1);
		trap2_3 waittill("movedone");
		trap2_2 movez(100,1);
		trap2_2 waittill("movedone");
		trap2_3 movez(100,1);
		trap2_3 waittill("movedone");
		wait 1;
	}
}

trap2movers()
{
trap2_mover1=getent("trap2_mover1","targetname");
trap2_mover2=getent("trap2_mover2","targetname");
trap2_mover3=getent("trap2_mover3","targetname");
rand=0;
while(1)
{
rand = RandomIntRange( 1, 4 );
	if(rand==1)
	{
		trap2_mover1 movex(200,1);
		trap2_mover1 waittill("movedone");
		trap2_mover1 movex(-200,1);
		trap2_mover1 waittill("movedone");
	}
	if(rand==2)
	{
		trap2_mover2 movex(200,1);
		trap2_mover2 waittill("movedone");
		trap2_mover2 movex(-200,1);
		trap2_mover2 waittill("movedone");
	}
	if(rand==3)
	{
		trap2_mover3 movex(200,1);
		trap2_mover3 waittill("movedone");
		trap2_mover3 movex(-200,1);
		trap2_mover3 waittill("movedone");
	}
}
}

trap1a()
{
arma=getent("trap1a","targetname");
if (!isdefined(arma.speed)) //arma.speed is hoeveel seconde per ronde
 arma.speed = 5;
if (!isdefined(arma.script_noteworthy))
 arma.script_noteworthy = "z";
//trigger_trap_rotatefloor=getent("Trap_Sweper_Floor","targetname");
//trigger_trap_rotatefloor waittill ("trigger", player);
thread trap1b();
while(true)
{
 if (arma.script_noteworthy == "z")
  arma rotateYaw(360,arma.speed);
 else if (arma.script_noteworthy == "x")
  arma rotateRoll(360,arma.speed);
 else if (arma.script_noteworthy == "y")
  arma rotatePitch(360,arma.speed);
 wait ((arma.speed)-0.1);
}
}

trap1b()
{
arma=getent("trap1b","targetname");
if (!isdefined(arma.speed)) //arma.speed is hoeveel seconde per ronde
 arma.speed = 5;
if (!isdefined(arma.script_noteworthy))
 arma.script_noteworthy = "z";
while(true)
{
 if (arma.script_noteworthy == "z")
  arma rotateYaw(-360,arma.speed);
 else if (arma.script_noteworthy == "x")
  arma rotateRoll(-360,arma.speed);
 else if (arma.script_noteworthy == "y")
  arma rotatePitch(-360,arma.speed);
 wait ((arma.speed)-0.1);
}
}
