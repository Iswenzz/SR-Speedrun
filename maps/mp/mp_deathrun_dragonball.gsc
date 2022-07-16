/* 
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MI             O     M      M    8MM.      MMM        MMM.     MMM         7MMMM
MI             O     M      M    8M        MMM        MM        MM          MMMM
MMM.  N    M OMMM   MMM~    .M7 MM8   +M+  MMM 8M    MMM   IM    MM.  MMM   MMMM
MMM   ..   . MMMM   MMM=     NI MM   .MMMMMMMM OD   .MM=   MM8  .MM.  MM8   MMMM
MMM$         MMMM   MMM= M    I MM   .M......MMM    MMM.   MMM   MM.       MMMMM
MMMM        ,MMMM   MMM= M.   I MM    M      MMO    Z=I    MMM  .MM.        MMMM
MMMM    D   MMMMM   MMM= MN     MM.   MM   MMMM,   MI ~N   NM:  .MM.  MMI   7MMM
MMMM,  ZM   MMMO     M. ..7     MMM        MMM+    .. ~M        ?M..  . M    MMM
MMMMM  MM   MMM8     M    7M    MMM~       MMM.       ~MM       MM      M   .MMM
MMMMM  MMN MMMM8     M    7M    MMMMM.  M  MM.        ~MMM.   7MMM      M.  =MMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM 
*/
main()
{
trigger = spawn( "trigger_radius", (-19136.2, 13545.1, 256.125), 0, 325, 110 );
trigger.targetname = "endmap_trig";
trigger.radius = 325;
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	maps\mp\_load::main();	
	thread sr\api\_map::createSpawn((1572, 99, -4),180);
	thread sr\api\_speedrun::createTeleporter((-16829, 13474, -355), 100, 150, 
		(-16800, 13170, 124), 270, "freeze");

	spot=getent("secretspot","targetname");
	thread sr\api\_speedrun::createTeleporter((1402, 404, -4), 100, 150,
		spot.origin, 360, "freeze", "blue", "secret_0");

	SetDvar( "player_meleerange", "100" );

	level.fixedgrav = true;

	setDvar("jump_height","48");
	setDvar("g_gravity","700");
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	//thread expandTimeLimit( 2 );
	
	/* [AUTO DELETE] ambientPlay("zor"); */
	precacheItem("m40a3_mp");
	precacheItem("ak74u_mp");
	precacheitem("deserteagle_mp");
	PrecacheShellShock("death");
	
	level.abovehuman["fireball_idle"] = LoadFX("dball/kishot");
	level.abovehuman["fireball_explosion"] = LoadFX("dball/kishotimpact");
	level.abovehuman["fireball_idlebig"] = LoadFX("dball/kishotbig");
	level.abovehuman["fireball_explosionbig"] = LoadFX("dball/kishotimpactbig");
	level.abovehuman["ssjspawn"] = LoadFX("dball/ssjspawn");
	precacheModel( "viewmodel_hands_zombie" );

	setdvar( "r_specularcolorscale", "1" );
	setdvar( "dr_jumpers_speed", "1.2" );
	setdvar( "dr_activators_speed", "1.2" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	/* [AUTO DELETE] level.dvar["time_limit"] = 6; */
	
	
	level.hurtrig =getent("hurt_meteor","targetname");
	level.hurtrig.dmg = 0;
	
	Dhider= getent("dragonhider","targetname");
	Dhider.angles = (0,180,0);
	level.fx_nukeflash["explosions/nuke_flash"] = loadFx("explosions/nuke_flash");
	//PlayLoopedFX( level.fx_nukeflash,Dhider );
	//playLoopedFx(level.fx_nukeflash["explosions/nuke_flash"], 2, dhider.origin, 0, anglestoforward ((0,0,0)), anglestoup((0,0,0)));
		
	// rocks_1=getentarray("rock1","targetname");
	// if(isdefined(rocks_1))
	// {
	// for(i=0;i<rocks_1.size;i++)
	// {
	// rocks_1[i] thread rock_move();
	// rocks_1[i] thread trap3();
	// }
	// }
	
	
	// trap_rotatefloor=getentarray("trap_1","targetname");
	// if(isdefined(trap_rotatefloor))
	// {
	// for(i=0;i<trap_rotatefloor.size;i++)
	// {
	// trap_rotatefloor[i] thread trap_1_rotatefloorz();
	// }
	// }
	
	
	// thread clientdvar();
	// thread credit();
	// thread dballs();
	// thread rotators_1();
	// thread declare();
	// thread trap_moveplat();
	// thread spikedodgepath();
	// thread activatorufoflight();
	// thread dragonballmidblock();
	// thread dragonballsfound();
	// thread hud();
	/* [AUTO DELETE] thread weapon(); */
	// thread lastelevator();
	// thread senzubeanrestore();
	/* [AUTO DELETE] thread secretteleport(); */
	/* [AUTO DELETE] thread secretteleportback(); */
	// thread jumpgamerespawn();
	// thread checkactivatorafk();
	// thread antilagg();
	
	//transmissions
	thread transmissions();

	//traps
	// thread trap1();
	// thread trap2();
	// thread trap4();
	// thread  [AUTO DELETE] trap_bounce(); 
	// thread boomeye();
	// thread trap_crouchpush();
	// thread trap_rotator();
	
	
	//level.playernamezor="wingz";
	//level.burn_fx = LoadFX("dball/playerburst");
	level.burn_fx = LoadFX("dball/ssjglow");
	level.glow = LoadFX("dball/playerburst");
	//thread findburner();
	level.firsttime=true;
	// thread pickroom();
	// thread addtriggers();
	
	/* [AUTO DELETE] level.dvar["time_limit"] = 6; */
	// level.dvar["dr_timelimit"]=6;
	/* [AUTO DELETE] //level.dvar["time_limit"] += 2; */

	thread secretteleportback();
}

secretteleportback()
{
trigger=getent("secretback","targetname");
spot=getent("spotbacksecret","targetname");
while(1)
{
trigger waittill("trigger", player);
// player PlaySoundToPlayer( "tele", player );
// wait(0.05);
// player SetOrigin( spot.origin );
// player setplayerangles(spot.angles );
// iPrintLnBold(player.name+ " has finished the secret !"); //Change the message if you want
// player GiveWeapon("ak74u_mp");
// player SwitchToWeapon( "ak74u_mp" );
player thread sr\api\_speedrun::finishWay("secret_0");
}
}

transmissions()
{
	thread instanttransmissions();
	thread instanttransmissions1();
	thread instanttransmissions2();
	thread instanttransmissions3();	
	
}


instanttransmissions()
{
trigger=getent("trigger_transmission0","targetname");
spot=getent("transmissionplace0","targetname");
while(1)
{
trigger waittill("trigger", player);
player PlaySoundToPlayer( "tele", player );
wait(0.05);
player SetOrigin( spot.origin );
player setplayerangles(spot.angles );
}
}

instanttransmissions1()
{
trigger=getent("trigger_transmission1","targetname");
spot=getent("transmissionplace1","targetname");
while(1)
{
trigger waittill("trigger", player);
player PlaySoundToPlayer( "tele", player );
wait(0.05);
player SetOrigin( spot.origin );
player setplayerangles(spot.angles );
}
}

instanttransmissions2()
{
trigger=getent("trigger_transmission2","targetname");
spot=getent("transmissionplace2","targetname");
while(1)
{
trigger waittill("trigger", player);
player PlaySoundToPlayer( "tele", player );
wait(0.05);
player SetOrigin( (-13720, 3191, 524) );
player setplayerangles(270 );
}
}

instanttransmissions3()
{
trigger=getent("trigger_transmission3","targetname");
spot=getent("transmissionplace3","targetname");
while(1)
{
trigger waittill("trigger", player);
player PlaySoundToPlayer( "tele", player );
wait(0.05);
player SetOrigin( spot.origin );
player setplayerangles(spot.angles );
}
}


addtriggers()
{
    addTriggerToList("trigger_trap1_rotate");
addTriggerToList("trigger_trap2_fireballs");
addTriggerToList("trigger_trap_rock");
addTriggerToList("trigger_pushtrap");
addTriggerToList("trigger_boomeye");
addTriggerToList("trigger_crouchpusher");
addTriggerToList("trigger_brush_rotator");
addTriggerToList("trap_createabounce");

}


addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


trap_rotator()
{
	level endon("trigger");
platform=getent("brush_rotator","targetname");
trigger=getent("trigger_brush_rotator","targetname");

if (!isdefined(platform.speed))
 platform.speed = 8;
if (!isdefined(platform.script_noteworthy))
 platform.script_noteworthy = "z";
 
trigger waittill("trigger", player);
 while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (platform.script_noteworthy == "z")
  platform rotateYaw(-360,platform.speed);
 else if (platform.script_noteworthy == "x")
  platform rotateRoll(-360,platform.speed);
 else if (platform.script_noteworthy == "y")
  platform rotatePitch(-360,platform.speed);
 wait ((platform.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}


antilagg()
{
triggerdeath=getent("antilaggbind","targetname");
while(1)
{
triggerdeath waittill("trigger", player);
player thread antilaggbinder();
}
}


antilaggbinder()
{
	self endon( "death" );
	self ShellShock( "death", 5 );
	self PlaySoundToPlayer("laggbinderz", self );
	wait (1);
	self ShellShock( "death", 5 );
	wait (3);
	self suicide();
}



checkactivatorafk()
{
level.roomdeclaredbyacti = false;
trigger=getent("roomdeclared","targetname");
trigger waittill("trigger", player);
if(level.roomdeclaredbyacti == false)
{
/* [AUTO DELETE] iPrintLnBold("Activator hasnt picked anyroom"); */
/* [AUTO DELETE] iPrintLnBold("^1Knife room open !"); */
level.knife delete();
level.power delete();
level.roomdeclaredbyacti = true;
thread kniferoom();
}
}


pickroom()
{
level.power=getent("trigger_pickpower","targetname");
level.jump=getent("trigger_pickjump","targetname");
level.knife=getent("trigger_pickknife","targetname");
// thread powerpick();
// thread jumppick();
// thread knifepick();
}


powerpick()
{
level.power waittill("trigger", player);
iPrintLnBold("Activator has picked : ^1PowerGame"); //Change the message if you want
level.knife delete();
level.jump delete();
level.roomdeclaredbyacti = true;
// thread fightpowertesting();
}


jumppick()
{
level.jump waittill("trigger", player);
iPrintLnBold("Activator has picked : ^1JumpGame"); //Change the message if you want
level.power delete();
level.jump delete();
level.roomdeclaredbyacti = true;
// thread jumpergame();
}


knifepick()
{
level.knife waittill("trigger", player);
iPrintLnBold("Activator has picked : ^1KnifeGame"); //Change the message if you want
level.power delete();
level.jump delete();
level.roomdeclaredbyacti = true;
thread kniferoom();
}



//kniferoomtrigger
//kniferoomtrigger_jumperteleport
//kniferoomtrigger_activatorteleport
//kniferoomdoors
kniferoom()
{
level.doors=getent("kniferoomdoors","targetname");
level.kniferoom=getent("kniferoomtrigger","targetname");
activatorspot=getent("kniferoomtrigger_activatorteleport","targetname");
jumperspot=getent("kniferoomtrigger_jumperteleport","targetname");
level.firstteleportknife = false;
while(1)
{
level.kniferoom waittill("trigger", player);
wait(0.05);
if(level.firstteleportknife == false)
{
player FreezeControls(true);
level.activ FreezeControls(true);
player PlaySoundToPlayer( "tele", player );
wait(0.05);
player SetOrigin( jumperspot.origin );
player setplayerangles(jumperspot.angles );
// player thread findburner();
iPrintLnBold(player.name+ " has entered ^1Knife room ! !"); //Change the message if you want
level.activ PlaySoundToPlayer( "tele", level.activ );
wait(0.05);
level.activ SetOrigin( activatorspot.origin );
level.activ setplayerangles(activatorspot.angles );
wait(0.05);
// level.activ thread findburner();
AmbientStop();
/* [AUTO DELETE] ambientPlay("endzor"); */
thread kniferoomdeadcounter();
// player thread countdown();
// level.activ thread countdown();
player oneonone();
}
else
{
player FreezeControls(true);
level.activ FreezeControls(true);
player PlaySoundToPlayer( "tele", player );
wait(0.05);
player SetOrigin( jumperspot.origin );
player setplayerangles(jumperspot.angles );
// player thread findburner();
iPrintLnBold(player.name+ " has entered ^1Knife room ! !"); //Change the message if you want
level.activ PlaySoundToPlayer( "tele", level.activ );
wait(0.05);
level.activ SetOrigin( activatorspot.origin );
level.activ setplayerangles(activatorspot.angles );
wait(0.05);
AmbientStop();
/* [AUTO DELETE] ambientPlay("endzor"); */
thread kniferoomdeadcounter();
// player thread countdown();
player thread tillstayalive();
// level.activ thread countdown();
}
level.firstteleportknife = true;
wait(3);
}
}


oneonone()
{
self endon( "death" );
for(;;)
{
wait(3);
}
}


tillstayalive()
{
self endon( "death" );
for(;;)
{
wait(2);
}
}


grantxp()
{
players = getentarray("player", "classname");
for(i=0;i<=players.size;i++)
            {
            wait 0.1;
                if(isAlive(players[i]))
                {
		wait(0.05);
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "activator" ); */
}
}
}


kniferoomdeadcounter()
{
trigger=getent("kniferoomdead","targetname");
while(1)
{
trigger waittill("trigger", other);
	if(other == level.activ)
	{
		other suicide();
	}
	else
	{
		other suicide();
		if(isAlive(level.activ))
		{
		/* [AUTO DELETE] level.activ braxi\_rank::giveRankXP( "melee" ); */
		}
	}
	}
}
