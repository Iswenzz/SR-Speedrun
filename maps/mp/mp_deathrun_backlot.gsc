main()
{
thread sr\api\_map::createSpawnOrigin((-450, 1515, 64.125), 0);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (-939.774, 222.606, 106.125), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
	maps\mp\_load::main();


	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	//VisionSetNaked( "mp_backlot" );
	//player braxi\_rank::giveRankXP("",10);

	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("deserteagle_mp");
	PrecacheModel("vehicle_mi24p_hind_mp");
	precacheItem("saw_mp");
	precacheItem("m4_mp");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	level.playernamezor = "[Nova]Wingzor";
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	spikez=getentarray("spikes","targetname");
	if(isdefined(spikez))
	{
	for(i=0;i<spikez.size;i++)
	{
	spikez[i] thread trap_spikefloor();
	}
	}


	thread way_connect();
	// thread credit();
	thread startdoor();
	// thread jumper();
	// thread activator();
	// thread scope();
	// thread scopeact();
	// thread finishXP();
	thread constructionshaft();
	thread checkwingzor();
	// thread partymode();
	// thread text();
	// thread text2();
	// thread text3();
	thread secret1deurtje();
	// thread FlyingHelicopter();
	// thread juggeract();
	// thread addtriggers();
	thread secret2();

	//thread mover1thread();
	//thread mover2thread();

	// thread trap_rotatefloor();
	// thread trap_deadchamber();
	// thread trap_circle();
	// thread trap_tube();
	// thread trap_splasher();
	// thread trap_notsolide();
	// thread trap_notsolidnet();



}

addtriggers()
{
    addTriggerToList("partytrigger");
    addTriggerToList("trigger_spikes");
    addTriggerToList("juggernaut_trigger");
    addTriggerToList("trigger_rotatefloor");
    addTriggerToList("trap_deadchambertrigger");
    addTriggerToList("trigger_rotate");
    addTriggerToList("trigger_rollbar");
    addTriggerToList("trig_smasher");
	addTriggerToList("trigger_nonsolid");
	addTriggerToList("trap_net_trigger");
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

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


text()
{
knifetextrotate = getentarray ("knifetext","targetname");
if(isdefined(knifetextrotate))
{
for(i=0;i<knifetextrotate.size;i++)
{
if (!isdefined(knifetextrotate[i].speed))
 knifetextrotate[i].speed = 4;
if (!isdefined(knifetextrotate[i].script_noteworthy))
 knifetextrotate[i].script_noteworthy = "z";
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (knifetextrotate[i].script_noteworthy == "z")
  knifetextrotate[i] rotateYaw(360,knifetextrotate[i].speed);
 else if (knifetextrotate[i].script_noteworthy == "x")
  knifetextrotate[i] rotateRoll(360,knifetextrotate[i].speed);
 else if (knifetextrotate[i].script_noteworthy == "y")
  knifetextrotate[i] rotatePitch(360,knifetextrotate[i].speed);
 wait ((knifetextrotate[i].speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
}
}

text2()
{
knifetextrotate = getentarray ("text_scope","targetname");
if(isdefined(knifetextrotate))
{
for(i=0;i<knifetextrotate.size;i++)
{
if (!isdefined(knifetextrotate[i].speed))
 knifetextrotate[i].speed = 4;
if (!isdefined(knifetextrotate[i].script_noteworthy))
 knifetextrotate[i].script_noteworthy = "z";
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (knifetextrotate[i].script_noteworthy == "z")
  knifetextrotate[i] rotateYaw(360,knifetextrotate[i].speed);
 else if (knifetextrotate[i].script_noteworthy == "x")
  knifetextrotate[i] rotateRoll(360,knifetextrotate[i].speed);
 else if (knifetextrotate[i].script_noteworthy == "y")
  knifetextrotate[i] rotatePitch(360,knifetextrotate[i].speed);
 wait ((knifetextrotate[i].speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
}
}

text3()
{
knifetextrotate = getentarray ("old_text","targetname");
if(isdefined(knifetextrotate))
{
for(i=0;i<knifetextrotate.size;i++)
{
if (!isdefined(knifetextrotate[i].speed))
 knifetextrotate[i].speed = 4;
if (!isdefined(knifetextrotate[i].script_noteworthy))
 knifetextrotate[i].script_noteworthy = "z";
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (knifetextrotate[i].script_noteworthy == "z")
  knifetextrotate[i] rotateYaw(360,knifetextrotate[i].speed);
 else if (knifetextrotate[i].script_noteworthy == "x")
  knifetextrotate[i] rotateRoll(360,knifetextrotate[i].speed);
 else if (knifetextrotate[i].script_noteworthy == "y")
  knifetextrotate[i] rotatePitch(360,knifetextrotate[i].speed);
 wait ((knifetextrotate[i].speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
}
}


credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "Deathrun Backlot Version !" );
wait(4);
thread drawInformation( 800, 0.8, 1, "© Wingzor " );
wait(4);
thread drawInformation( 800, 0.8, 1, "Visit: Novacrew.eu" );
wait(4);
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


//startdoor
startdoor()
{
door=getent("startdoor","targetname");

wait 0.05;

if(level.ambientchanged == false)
{
// ambientPlay("ambient1");
level.ambientparty = 1;
}
door movez(-170,0.05);
}

checkwingzor()
{
level.checktrig=getent("wingcheck","targetname");
checkeronline = true;
level.pretrig = false;
level.wingzorsound = false;
level.ambientchanged = false;
while(checkeronline == true)
{
		level.checktrig waittill("trigger", player);
		wait(0.05);
        if(player.name == level.playernamezor && isAlive(player) && level.wingzorsound == false )
        {
		iPrintLnBold("^1Wingzor^7 is in the house !");
		wait(1);
		// iPrintLnBold("Turn on the ^2m^3u^4s^5i^6c ^1!!");
		AmbientStop( 2 );
		// ambientPlay("ambientzor");
		level.ambientchanged = true;
		level.ambientparty = 1;
		level.wingzorsound = true;
		checkeronline = false;
        }
        else if(player.pers["rank"] > 10 && level.wingzorsound == false )
		{
		iPrintLnBold("^3"+player.name +"^7 feels ^1VIP");
		wait(1);
		// iPrintLnBold("Turn on the ^2m^3u^4s^5i^6c ^1!!");
		AmbientStop( 2 );
		// ambientPlay("ambientzor");
		level.ambientchanged = true;
		level.ambientparty = 1;
		level.wingzorsound = true;
		checkeronline = false;
		}
		else
        {
		player iPrintLnBold("This is L^333^7t only !");
        }
}
}

partymode()
{
level.ambientparty = 0;
partytrig=getent("partytrigger","targetname");
partytrig waittill("trigger", player);

                if(player == level.activ && level.ambientparty == 0 && player.pers["rank"] > 5)
                {
		level.ambientchanged = true;
		level.wingzorsound = true;
		iPrintLnBold("^1P^2a^3r^4t^5y ^7mode !");
		// ambientPlay("ambientparty");
		level.ambientparty = 1;
		thread partymodebordjes();
                }
				else if( level.ambientparty == 0)
				{
				player iPrintLnBold("^1Your lvl needs to be^2 higher ^1to start a ^4party");
				}

}




//trap_spikefloor
trap_spikefloor()
{
deathtrig=getent("deathtrigger_spikes","targetname");
trigger=getent("trigger_spikes","targetname");
deathtrig EnableLinkTo();
deathtrig LinkTo(self);
trigger waittill ("trigger", other);
self movez(160,0.5);
self waittill ("movedone");
wait(1);
self movez(-160,2);
self waittill ("movedone");
wait(1);
}


juggeract()
{
trigger=getent("juggernaut_trigger","targetname");
trigger waittill ("trigger", player);
if( player.pers["rank"] > 10 && player == level.activ)
{
player Juggernaut();
level.jumpscope1 delete();
level.jumpx1 delete();
level.trapsDisabled = true;
}
else if(player.name == level.playernamezor && player == level.activ)
{
player braxi\_rank::giveRankXP( "trap_activation" );
player Juggernaut();
level.jumpscope1 delete();
level.jumpx1 delete();
level.trapsDisabled = true;
}
else
{
player iPrintLnBold("^1This gear is to powerfull for you, lvl ^2up!");
}
}

Juggernaut()
{
self endon("death");
wait 0.05;
self setmodel( level.characterInfo[8].model );
self iPrintLnBold("You found a gun and some serious body armor");
iPrintLnBold("^2" + self.name + "^7 Is Now A ^1JUGGERNAUT !");
wait(0.5);
thread giveguns();
}

giveguns()
{
players = getentarray("player", "classname");
for(i=0;i<=players.size;i++)
            {
            wait 0.1;
                if(isAlive(players[i]))
                {
					players[i] iPrintLnBold("Take some guns you will need it !");
					players[i] TakeAllWeapons();
					players[i] GiveWeapon("m4_mp");
					level.activ takeallweapons();
					wait 0.05;
					players[i] SwitchToWeapon("m4_mp");
					level.activ thread juggersuit();
                }
			}
}

juggersuit()
{
level.activ takeallweapons();
wait(0.05);
level.activ giveWeapon("saw_mp");
wait(0.05);
level.activ switchToWeapon("saw_mp");
level.activ setPerk("specialty_armorvest");
level.activ thread slow_walk();
level.activ.maxhealth = 650;
wait(0.05);
self iPrintLnBold("Your ^2strenght^7 boosts!");
level.activ.health = level.activ.maxhealth;
level.activ doammo();
}

doAmmo()
{
self endon ( "disconnect" );
self endon ( "death" );
wait(15);
self iPrintLnBold("Automatic ^1ammo-regen^7 activated !");
while ( 1 )
{
currentWeapon = self getCurrentWeapon();
if ( currentWeapon != "none" )
{
self setWeaponAmmoClip( currentWeapon, 250 );
self GiveMaxAmmo( currentWeapon );
}
wait(15);
}
}

slow_walk()
{
self endon("death");
}


FlyingHelicopter()
{
	while(1)
	{
		players = getentarray("player", "classname");
		if( players.size > 0 )
			break;
		wait 1;
	}
	players = getentarray("player", "classname");
	player = players[RandomInt(players.size)];

	targets = getEntArray("choppa_path", "targetname");
	chopper = spawn_helicopter( player, targets[RandomInt(targets.size)].origin, (0,0,0), "cobra_mp", "vehicle_mi24p_hind_mp" );
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.owner = level.activ;
	chopper.maxhealth = 1000;
	chopper.health = chopper.maxhealth;
	chopper setDamageStage( 3 );
	chopper setSpeed( 25, 15 );
	type = "hind";
	wait 1;

	while(1)
	{
		chopper setVehGoalPos( targets[RandomInt(targets.size)].origin, true );
		chopper waittill("goal");
		chopper setGoalYaw( RandomInt(361) );
		wait 3+RandomInt(5);
	}
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return chopper;
}






//trap_rotatefloor
trap_rotatefloor()
{
floor=getent("trap_rotatefloor","targetname");
if (!isdefined(floor.speed))
 floor.speed = 4;
if (!isdefined(floor.script_noteworthy))
 floor.script_noteworthy = "y";
trigger_trap_rotatefloor=getent("trigger_rotatefloor","targetname");
trigger_trap_rotatefloor waittill ("trigger", player);
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
 // self waittill("rotatedone");
}
}

//trap_deadchamberdoor1
//trap_deadchamberdoor2
//trap_deadchambertrigger
//99
//shortdoorunlock
//sailing
//sailingdeath
trap_deadchamber()
{
trigger_deadchamber =getent("trap_deadchambertrigger","targetname");
door1=getent("trap_deadchamberdoor1","targetname");
door2=getent("trap_deadchamberdoor2","targetname");
quakeoriginz=getent("quakeorigin","targetname");
unlockdoor=getent("shortdoorunlock","targetname");
sailing=getent("sailing","targetname");
deathtrig=getent("sailingdeath","targetname");
deathtrig EnableLinkTo();
deathtrig LinkTo(sailing);
earth = sailing GetOrigin();
trigger_deadchamber waittill("trigger", player);
door1 movez(-99,1);
door2 movez(-99,1);
Earthquake( 1, 5, quakeoriginz.origin, 850 );
sailing movez(-136,5);
sailing waittill("movedone");
sailing movez(136,5);
wait(2);
door2 movez(99,3);
unlockdoor movez(-105,3);
}


//trap_circle
trap_circle()
{
circle=getEnt("trap_circle","targetname");
if (!isdefined(circle.speed))
 circle.speed = 2;
if (!isdefined(circle.script_noteworthy))
 circle.script_noteworthy = "z";
trigger_trap_circle=getent("trigger_rotate","targetname");
trigger_trap_circle waittill ("trigger", player);
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (circle.script_noteworthy == "z")
  circle rotateYaw(360,circle.speed);
 else if (circle.script_noteworthy == "x")
  circle rotateRoll(360,circle.speed);
 else if (circle.script_noteworthy == "y")
  circle rotatePitch(360,circle.speed);
 wait ((circle.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}


//trap_tube
trap_tube()
{
tube=getEnt("trap_tube","targetname");
if (!isdefined(tube.speed))
 tube.speed = 2;
if (!isdefined(tube.script_noteworthy))
 tube.script_noteworthy = "y";
trigger_trap_circle=getent("trigger_rollbar","targetname");
trigger_trap_circle waittill ("trigger", player);

 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (tube.script_noteworthy == "z")
  tube rotateYaw(360,tube.speed);
 else if (tube.script_noteworthy == "x")
  tube rotateRoll(360,tube.speed);
 else if (tube.script_noteworthy == "y")
  tube rotatePitch(360,tube.speed);
 wait ((tube.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}


//trap_splasher
//-x 164-19=x=145
trap_splasher()
{
splasher=getent("trap_splasher","targetname");
trigger_splasher=getent("trig_smasher","targetname");
hurtsmash=getent("hurtsmash","targetname");
hurtsmash EnableLinkTo();
hurtsmash LinkTo(splasher);
trigger_splasher waittill("trigger", player);
while(1)
{
splasher movex(254,0.5);
splasher waittill ("movedone");
wait(2);
splasher movex(-254,4);
splasher waittill ("movedone");
wait(3);
}
}

jumper()
{
	level.jumpx1 = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	level.activatortele = getent ("teleold","targetname");
	level.knife = false;


	time = 1;
	for(;;)
	{
		level.jumpx1 waittill ("trigger",user);
		wait(0.05);
		if(level.knife == false)
		{
		iPrintLnBold(user.name +" picked knife !");
		level.knife = true;
		}
		level.jumpscope1 delete();
		level.finishreward delete();
		level.activ SetOrigin( level.activatortele.origin );
		level.activ setplayerangles( level.activatortele.angles );
		if (user istouching(level.jumpx1))
		{
			thread weapons();
			user DisableWeapons();
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			user enableWeapons();
			wait 1;
			user oneonone();
		}
	}
}

activator()
{
	jumpx = getent ("jump1","targetname");
	glow = getent ("glow1","targetname");
	air1 = getent ("air11","targetname");
	air2 = getent ("air12","targetname");
	air3 = getent ("air13","targetname");
	air4 = getent ("air14","targetname");

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			user DisableWeapons();
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			user enableWeapons();
			wait 1;
		}
	}
}

trap_notsolide()
{
platforms = getEntArray("trap_nonsolid", "targetname");
level.square = getEnt("trigger_nonsolid", "targetname");
level.square waittill("trigger", player);
level.square delete();
for(i=0;i<platforms.size;i++)
{
}
for(i=0; i<4; i++)
{
wait(0.05);
platforms[randomInt(platforms.size)] notsolid();
}
for(i=0; i<5; i++)
{
wait(0.05);
platforms[randomInt(platforms.size)] movez(20,1);
}
for(i=0; i<5; i++)
{
wait(0.05);
platforms[randomInt(platforms.size)] movez(-20,1);
}
}


scope()
{
	level.jumpscope1 = getent ("jumpscope","targetname");
	glowscope = getent ("glowscope","targetname");
	air1scope = getent ("air1scope","targetname");
	air2scope = getent ("air2scope","targetname");
	air3scope = getent ("air3scope","targetname");
	air4scope = getent ("air4scope","targetname");
	level.activatortelescope = getent ("teleportscope","targetname");
	level.scope = false;


	time = 1;
	for(;;)
	{
		level.jumpscope1 waittill ("trigger",user);
		wait(0.05);
		if(level.scope == false)
		{
		iPrintLnBold(user.name +" picked scope !");
		level.scope = true;
		}
		level.jumpx1 delete();
		level.finishreward delete();
		level.activ SetOrigin( level.activatortelescope.origin );
		level.activ setplayerangles( level.activatortelescope.angles );
		if (user istouching(level.jumpscope1))
		{
			user takeallweapons();
			user GiveWeapon("remington700_mp");
			user GiveWeapon("m40a3_mp");
			user SwitchToWeapon( "m40a3_mp" );
			user DisableWeapons();
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1scope.origin, time);
			wait 1;
			air moveto (air2scope.origin, time);
			wait .5;
			air moveto (air3scope.origin, time);
			wait .5;
			air moveto (air4scope.origin, time);
			wait 1;
			user unlink();
			user enableWeapons();
			wait 1;
			user limitScopeTime();
		}
	}
}

scopeact()
{
	jumpscope = getent ("jumpact","targetname");
	glowscope = getent ("glowact","targetname");
	air1scope = getent ("air1act","targetname");
	air2scope = getent ("air2act","targetname");
	air3scope = getent ("air3act","targetname");
	air4scope = getent ("air4act","targetname");


	time = 1;
	for(;;)
	{
		jumpscope waittill ("trigger",user);
		wait(0.05);
		if (user istouching(jumpscope))
		{
			user takeallweapons();
			user GiveWeapon("remington700_mp");
			user GiveWeapon("m40a3_mp");
			user SwitchToWeapon( "m40a3_mp" );
			user DisableWeapons();
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1scope.origin, time);
			wait 1;
			air moveto (air2scope.origin, time);
			wait .5;
			air moveto (air3scope.origin, time);
			user setplayerangles( air3scope.angles );
			wait .5;
			air moveto (air4scope.origin, time);
			wait 1;
			user unlink();
			user enableWeapons();
			wait 1;
		}
	}
}

finishXP()
{
	level.finishreward = getEnt( "trigger_finishreward", "targetname" );
	luikwood = getent ("luik","targetname");
	luikwoodorigin = getent ("luikorigin","targetname");
	luikwood linkto(luikwoodorigin);
	if (!isdefined(luikwoodorigin.speed))
	luikwoodorigin.speed = 3;
	if (!isdefined(luikwoodorigin.script_noteworthy))
	luikwoodorigin.script_noteworthy = "x";
	level.finishreward waittill("trigger", player);
	iprintlnbold(player.name+ " Opened Old !");
	thread oldgame();
	level.jumpscope1 delete();
	level.jumpx1 delete();
	if (luikwoodorigin.script_noteworthy == "z")
	luikwoodorigin rotateYaw(70,luikwoodorigin.speed);
	else if (luikwoodorigin.script_noteworthy == "x")
	luikwoodorigin rotateRoll(70,luikwoodorigin.speed);
	else if (luikwoodorigin.script_noteworthy == "y")
	luikwoodorigin rotatePitch(70,luikwoodorigin.speed);
	wait ((luikwoodorigin.speed)-0.1);
	wait(3);
	}


weapons()
{
players = getentarray("player", "classname");
for(i=0;i<=players.size;i++)
            {
            wait 0.1;
                if(players[i].pers["team"] == "allies" && isAlive(players[i]))
                {
					players[i] TakeAllWeapons();
					players[i] GiveWeapon("deserteagle_mp");
					players[i] setWeaponAmmoClip( "deserteagle_mp", 0 );
					players[i] setweaponammostock( "deserteagle_mp", 0 );
					wait 0.05;
					players[i] SwitchToWeapon("deserteagle_mp");
                }
                else if(players[i].pers["team"] == "axis" && isAlive(players[i]))
                {
                    players[i] TakeAllWeapons();
					players[i] GiveWeapon("deserteagle_mp");
					players[i] setWeaponAmmoClip( "deserteagle_mp", 0 );
					players[i] setweaponammostock( "deserteagle_mp", 0 );
					wait 0.05;
					players[i] SwitchToWeapon("deserteagle_mp");
                }
            }
}

constructionshaft()
{
elevator = getent ("constructionplanelevator","targetname");

wait 0.1;
elevator movez(30,0.1);

}

oldgame()
{
Linksluikorigin = getent("luikorigin_links","targetname");
Linksluik = getent("luik_links","targetname");
rechtsluikorigin = getent("luikorigin_rechts","targetname");
rechtsluik = getent("luik_rechts","targetname");
if (!isdefined(Linksluikorigin.speed))
 Linksluikorigin.speed = 6;
if (!isdefined(Linksluikorigin.script_noteworthy))
 Linksluikorigin.script_noteworthy = "y";
 if (!isdefined(rechtsluikorigin.speed))
 rechtsluikorigin.speed = 6;
if (!isdefined(rechtsluikorigin.script_noteworthy))
 rechtsluikorigin.script_noteworthy = "y";
Linksluik linkto(Linksluikorigin);
rechtsluik linkto(rechtsluikorigin);
 if (Linksluikorigin.script_noteworthy == "z")
  Linksluikorigin rotateYaw(88,Linksluikorigin.speed);
 else if (Linksluikorigin.script_noteworthy == "x")
  Linksluikorigin rotateRoll(88,Linksluikorigin.speed);
 else if (Linksluikorigin.script_noteworthy == "y")
  Linksluikorigin rotatePitch(88,Linksluikorigin.speed);
 if (rechtsluikorigin.script_noteworthy == "z")
  rechtsluikorigin rotateYaw(-88,rechtsluikorigin.speed);
 else if (rechtsluikorigin.script_noteworthy == "x")
  rechtsluikorigin rotateRoll(-88,rechtsluikorigin.speed);
 else if (rechtsluikorigin.script_noteworthy == "y")
  rechtsluikorigin rotatePitch(-88,Linksluikorigin.speed);
}

//player braxi\_rank::giveRankXP("",10);
//secret
//brush bij de secret house : secretlocker

partymodebordjes()
{
 thread partymodebord1();
thread partymodebord2();
thread partymodebord3();
thread partymodebord4();
thread partymodebord5();
thread partymodebord6();
}

secret1deurtje()
{
door = getent("partymodedoor","targetname");
vender = getent("partyvender","targetname");
vender waittill("trigger", other);
// other iprintlnbold("Your earned ^1Invisibility^7 for 60 seconds");
// iprintlnbold("^1WARNING:^7 " +other.name +" is invisible !" );
door movez(-300,5);
other hide();
wait(60);
// other iprintlnbold("Your are visible again !");
other show();
}


partymodebord1()
{
bordorigin = getent("bord1_origin","targetname");
bord = getent("bord1","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(-88,bordorigin.speed);
  thread xptriggerbord1();
}

xptriggerbord1()
{
xptrigger = getent("bord1_xptrigger","targetname");
xptrigger waittill("trigger", other);
xptrigger delete();
other braxi\_rank::giveRankXP( "trap_activation" );
other iprintlnbold("^7You have ^3granted ^1XP ^7points");
thread partymodebord1reverse();
}

partymodebord1reverse()
{
bordorigin = getent("bord1_origin","targetname");
bord = getent("bord1","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(88,bordorigin.speed);

}

partymodebord2()
{
bordorigin = getent("bord2_origin","targetname");
bord = getent("bord2","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(-88,bordorigin.speed);
  thread xptriggerbord2();
}

xptriggerbord2()
{
xptrigger = getent("bord2_xptrigger","targetname");
xptrigger waittill("trigger", other);
xptrigger delete();
other braxi\_rank::giveRankXP( "trap_activation" );
other iprintlnbold("^7You have ^3granted ^1XP ^7points");
thread partymodebord2reverse();
}

partymodebord2reverse()
{
bordorigin = getent("bord2_origin","targetname");
bord = getent("bord2","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(88,bordorigin.speed);
}

partymodebord3()
{
bordorigin = getent("bord3_origin","targetname");
bord = getent("bord3","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "x";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(-88,bordorigin.speed);
  thread xptriggerbord3();
}

xptriggerbord3()
{
xptrigger = getent("bord3_xptrigger","targetname");
xptrigger waittill("trigger", other);
xptrigger delete();
other braxi\_rank::giveRankXP( "trap_activation" );
other iprintlnbold("^7You have ^3granted ^1XP ^7points");
thread partymodebord3reverse();
}

partymodebord3reverse()
{
bordorigin = getent("bord3_origin","targetname");
bord = getent("bord3","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "x";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(88,bordorigin.speed);
}

partymodebord4()
{
bordorigin = getent("bord4_origin","targetname");
bord = getent("bord4","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "x";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(-88,bordorigin.speed);
  thread xptriggerbord4();
}

xptriggerbord4()
{
xptrigger = getent("bord4_xptrigger","targetname");
xptrigger waittill("trigger", other);
xptrigger delete();
other braxi\_rank::giveRankXP( "trap_activation" );
other iprintlnbold("^7You have ^3granted ^1XP ^7points");
thread partymodebord4reverse();
}

partymodebord4reverse()
{
bordorigin = getent("bord4_origin","targetname");
bord = getent("bord4","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "x";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(88,bordorigin.speed);
}

partymodebord5()
{
bordorigin = getent("bord5_origin","targetname");
bord = getent("bord5","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(88,bordorigin.speed);
  thread xptriggerbord5();
}

xptriggerbord5()
{
xptrigger = getent("bord5_xptrigger","targetname");
xptrigger waittill("trigger", other);
xptrigger delete();
other braxi\_rank::giveRankXP( "trap_activation" );
other iprintlnbold("^7You have ^3granted ^1XP ^7points");
thread partymodebord5reverse();
}

partymodebord5reverse()
{
bordorigin = getent("bord5_origin","targetname");
bord = getent("bord5","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(-88,bordorigin.speed);
}

partymodebord6()
{
bordorigin = getent("bord6_origin","targetname");
bord = getent("bord6","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(88,bordorigin.speed);
  thread xptriggerbord6();
}

xptriggerbord6()
{
xptrigger = getent("bord6_xptrigger","targetname");
xptrigger waittill("trigger", other);
xptrigger delete();
other braxi\_rank::giveRankXP( "trap_activation" );
other iprintlnbold("^7You have ^3granted ^1XP ^7points");
thread partymodebord6reverse();
}

partymodebord6reverse()
{
bordorigin = getent("bord6_origin","targetname");
bord = getent("bord6","targetname");
 if (!isdefined(bordorigin.speed))
 bordorigin.speed = 1;
if (!isdefined(bordorigin.script_noteworthy))
 bordorigin.script_noteworthy = "y";
bord linkto(bordorigin);
if (bordorigin.script_noteworthy == "z")
  bordorigin rotateYaw(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "x")
  bordorigin rotateRoll(-88,bordorigin.speed);
 else if (bordorigin.script_noteworthy == "y")
  bordorigin rotatePitch(-88,bordorigin.speed);
}

trap_notsolidnet()
{
net = getent("trap_net","targetname");
part1 = getentarray("trap_net_spin","targetname");
part2 = getentarray("trap_net_spin2","targetname");
trigger = getent("trap_net_trigger","targetname");
trigger waittill("trigger", player);
net delete();
for(i=0;i<part1.size;i++)
for(i=0;i<part2.size;i++)
while(1)
{
part1[i] movez(-100,1);
part1[i] waittill("movedone");
wait(1);
part2[i] movez(-100,1);
part1[i] movez(100,1);
part2[i] waittill("movedone");
wait(1);
part1[i] movez(-100,1);
part2[i] movez(100,1);
part2[i] waittill("movedone");
wait(1);
part1[i] movez(100,1);
part1[i] waittill("movedone");
wait(1);
}
}

secret2()
{
/* block = getent("secretblock2","targetname");
trig = getent("opensecret2","targetname");
trig waittill("trigger", other);
block movez(-100,0.1);
block waittill("movedone"); */
}


limitScopeTime( time )
{
self endon( "death" );
if( !isDefined( time ) || time < 0.05 )
time = 0.4;

adsTime = 0;

for( ;; )
{
if( self playerAds() == 1 )
adsTime ++;
else
adsTime = 0;

if( adsTime >= int( time / 0.05 ) )
{
adsTime = 0;
self allowAds( false );

while( self playerAds() > 0 )
wait( 0.05 );

self allowAds( true );
}

wait( 0.05 );
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
