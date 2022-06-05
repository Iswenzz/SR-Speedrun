/*
___________.__           .____    .__          _____          ____    __________.__           .__  .__        
\__    ___/|  |__   ____ |    |   |__|__  ____/ ____\____    /  _ \   \______   \  |__   ____ |  | |__|__  ___
  |    |   |  |  \_/ __ \|    |   |  \  \/  /\   __\/ __ \   >  _ </\  |     ___/  |  \_/ __ \|  | |  \  \/  /
  |    |   |   Y  \  ___/|    |___|  |>    <  |  | \  ___/  /  <_\ \/  |    |   |   Y  \  ___/|  |_|  |>    < 
  |____|   |___|  /\___  >_______ \__/__/\_ \ |__|  \___  > \_____\ \  |____|   |___|  /\___  >____/__/__/\_ \
                \/     \/        \/        \/           \/         \/                \/     \/              \/
.:: Map name: mp_dr_urban ::.
.:: Authors: TheLixfe & Phelix ::.
*/

main()
{
level.masterSpawn = spawn("script_origin", level.spawn["allies"][10].origin);
level.masterSpawn.angles = level.spawn["allies"][10].angles;
level.masterSpawn placeSpawnPoint();
	maps\mp\_load::main();	

	// Map dvars
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

	// Precaches
	// PreCacheItem("remington700_acog_mp");
	// PreCacheItem("urbangun_mp");
	// PreCacheItem("ak47_mp");
	// PreCacheItem("remington700_mp");
	// PreCacheItem("m40a3_mp");
	// PreCacheItem("deserteagle_mp");
	// PreCacheItem("deserteaglegold_mp");
	// PreCacheItem("knife_mp");
    // PreCacheItem("dragunov_mp");
    // PreCacheItem("p90_mp");
    // PreCacheItem("mp5_mp");
    // PreCacheItem("saw_mp");
    // PreCacheItem("uzi_mp");
    // PreCacheItem("ak74u_mp");
    // PreCacheItem("mp44_mp");

    // FX
    level.barrelplode = loadfx("explosions/default_explosion");
	level.groundplode = loadfx("explosions/urbangroundy");
	level.urbanfaller = loadfx("explosions/urbanfaller");

	// Trigger list
	level.deagle = getEnt("deagleroom_ent", "targetname");
    level.knife = getEnt("kniferoom_ent", "targetname");
    level.sniper = getEnt("sniproom_ent", "targetname");
    level.ak = getEnt("akroom_ent", "targetname");
    level.random = getEnt("randomroom_ent", "targetname");
    level.old = getEnt("oldroom_ent", "targetname");
    level.rooms = getEnt("end_door", "targetname");

    // level.triggerlist = [];
    // level.triggerlist[level.triggerlist.size] = level.deagle;
    // level.triggerlist[level.triggerlist.size] = level.knife;
    // level.triggerlist[level.triggerlist.size] = level.sniper;
    // level.triggerlist[level.triggerlist.size] = level.ak;
    // level.triggerlist[level.triggerlist.size] = level.random;
    // level.triggerlist[level.triggerlist.size] = level.old;
    // level.triggerlist[level.triggerlist.size] = level.rooms;

    // Random room array
    // level.weaponList = [];
    // level.weaponList[level.weaponList.size] = "dragunov_mp";
    // level.weaponList[level.weaponList.size] = "p90_mp";
    // level.weaponList[level.weaponList.size] = "mp5_mp";
    // level.weaponList[level.weaponList.size] = "saw_mp";
    // level.weaponList[level.weaponList.size] = "uzi_mp";
    // level.weaponList[level.weaponList.size] = "ak74u_mp";
    // level.weaponList[level.weaponList.size] = "mp44_mp";
    // level.random = randomInt(level.weaponList.size);

	// Map Threads
	thread way_connect();
	thread start();
	thread secret();
	thread urbanGun();
	// thread secretGun();
	// thread ele();
	// thread creators();
	// thread enterEndroom();
	// thread endrooms();
	// thread endroomOld();

	// Trap threads
	thread trapDrift();
	thread trapRotate();
	thread trapFloor();
	thread trapFaller();
	thread trapRoller();
	thread trapPlatformFall();
	thread trapLadders();
	thread trapBarrel();
	thread trapDropPlatform();
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

start()
{
	door = getEnt("startdoor", "targetname");
	clip = getEnt("start_clip", "targetname");

	// ambientPlay("urban");

	// wait 21.9;
	wait 1;

	clip delete();
	door rotateRoll(90, 1);
	door waittill("movedone"); // Put this here for secure purposes
}

secret()
{
	wall = getEnt("secret_wtf", "targetname");
	wall notSolid();
}

urbanGun()
{
	trigger = getEnt("trig_vc_urbangun", "targetname");
	weapon = getEnt("vc_urbangun", "targetname");

	trigger waittill("trigger", player);

	weapon delete();

	player giveWeapon("urbangun_mp");
	player giveMaxAmmo("urbangun_mp");
	player switchToWeapon("urbangun_mp");
	trigger setHintString("Someone has already taken the gun!");
}

secretGun()
{
	trigger = getEnt("ak_secret", "targetname");

	for(;;)
	{
		trigger waittill("trigger", player);
		player giveWeapon("ak74u_mp");
		player giveMaxAmmo("ak74u_mp");
		player switchToWeapon("ak74u_mp");
		player iPrintlnBold("You got ^6ak74u!");
		wait 1; // Added deley for spam prevention
	}
}

ele()
{
	trigger = getEnt("a_nothing", "targetname");
	end = getEnt("a_nothing_go", "targetname");

	for(;;)
	{
		trigger waittill("trigger", player);

		player freezeControls(true);
		player setOrigin(end.origin);
		player setPlayerAngles(end.angles);
		player iPrintlnBold("^1u tryin to be cheeky w this ele?");
		wait 1;
		player iPrintlnBold("^1too bad u gotta wait now and dats boring");
		wait 1;
		player iPrintlnBold("^11337");
		wait 1;

		for(i = 9; i >= 0; i--)
		{
			if(!i)
			{
				player iPrintlnBold("^1cunt ^5l2p");
				player freezeControls(false);
				player braxi\_rank::giveRankXP("", 1);
			}
			else
			{
				player iPrintlnBold("^1" + i);
				wait 1;
			}
		}
	}
}

creators()
{
	level waittill("round_started");
	for(i = 0; i <= 30; i++)
	{
		if(i == 15) iPrintlnBold("^7Map by ^3TheLixfe ^7and ^3Phelix");
		if(i == 30) iprintln("^7Map by ^5TheLixfe ^7and ^3Phelix");
	}
}

enterEndroom()
{
	jumperOrigin = getEnt("end_go", "targetname");

	while(1)
	{
		level.rooms waittill("trigger", player);

		if(!isDefined(level.rooms)) return;

		level.rooms setHintString("Waiting on Jumper");

		player setOrigin(jumperOrigin.origin);
		player setPlayerAngles(jumperOrigin.angles);

		while(isAlive(player)) wait 1;

		level.rooms setHintString("Press ^3[USE] ^7to enter Rooms-section");
	}

}

endrooms()
{
	thread endroomTemplate("deagleroom_ent", "2ndfloor_go", "2ndfloor_acti", "deserteagle_mp", "deserteaglegold_mp", "Deagle");
	thread endroomTemplate("kniferoom_ent", "2ndfloor_go", "2ndfloor_acti", "knife_mp", undefined, "Knife");
	thread endroomTemplate("sniproom_ent", "3rdfloor_go", "3rdfloor_acti", "remington700_mp", "m40a3_mp", "Sniper");
	thread endroomTemplate("akroom_ent", "3rdfloor_go", "3rdfloor_acti", "ak47_mp", undefined, "AK");
	thread endroomTemplate("randomroom_ent", "3rdfloor_go", "3rdfloor_acti", level.weaponList[level.random], undefined, "Random weapon");
}

endroomOld()
{
	cones1right = getEnt("old_doors1", "targetname");
	cones1left = getEnt("old_doors2", "targetname");
	cones2right = getEnt("old2_doors1", "targetname");
	cones2left = getEnt("old2_doors2", "targetname");
	plank1 = getEnt("old_plank", "targetname");
	plank2 = getEnt("old2_plank", "targetname");
	plank3 = getEnt("rotplank", "targetname");
	clip = getEnt("old_clip", "targetname");

	level.old waittill("trigger");

	for(i = 0; i < level.triggerlist.size; i ++) level.triggerlist[i] delete();

	cones1right moveY(-52, 2);
	cones1left moveY(52, 2);
	cones2right moveX(52, 2);
	cones2left moveX(-52, 2);
	plank1 moveX(-68, 2);
	plank2 delete();
	plank3 delete();
	clip delete();
}


endroomTemplate(trigger, jumperOrigin, actiOrigin, weapon, weapon2, roomName)
{
	trigger = getEnt(trigger, "targetname");
	jumper = getEnt(jumperOrigin, "targetname");
	acti = getEnt(actiOrigin, "targetname");

	while(1)
	{
		trigger waittill("trigger", player);

		if(isDefined(level.old)) level.old delete();

		ambientPlay("imlay");

		player setPlayerAngles(jumper.angles);
		player setOrigin(jumper.origin);
		if(isDefined(weapon) || isDefined(weapon2)) player takeAllWeapons(); // Added this for jumper purposes (should you want the jumper to keep his weapon on entry)
		if(isDefined(weapon)) player giveWeapon(weapon);
		if(isDefined(weapon2)) player giveWeapon(weapon2);
		if(isDefined(weapon)) player giveMaxAmmo(weapon);
		if(isDefined(weapon2)) player giveMaxAmmo(weapon2);
		if(isDefined(weapon)) player switchToWeapon(weapon);

		if(isDefined(level.activ))
		{
			level.activ setPlayerAngles(acti.angles);
			level.activ setOrigin(acti.origin);
			if(isDefined(weapon) || isDefined(weapon2)) level.activ takeAllWeapons();
			if(isDefined(weapon)) level.activ giveWeapon(weapon);
			if(isDefined(weapon2))level.activ giveWeapon(weapon2);
			if(isDefined(weapon)) level.activ giveMaxAmmo(weapon);
			if(isDefined(weapon2))level.activ giveMaxAmmo(weapon2);
			if(isDefined(weapon)) level.activ switchToWeapon(weapon);
		}

		iPrintlnBold(" ^7" + player.name + " Entered" + " ^1" + roomName + " ^7room.");
		wait 0.05;

		player freezeControls(true);
        if(isDefined(level.activv)) level.activv freezeControls(true);

		for(i = 3; i >= 0; i--)
		{
			if(!i) 
			{
				player iPrintlnBold("^1FIGHT^7!");
				player freezeControls(false);
				if(isDefined(level.activ))
				{
					level.activ iPrintlnBold("^1FIGHT^7!");
					level.activ freezeControls(false);
				}
			} 
			else 
			{
				player iPrintlnBold("^1" + i);
				if(isDefined(level.activ)) level.activ iPrintlnBold("^1" + i);
			}
			wait 1;
		}
	}
}

trapDrift()
{
	clip = getEnt("drift_clip", "targetname");
	trigger = getEnt("trig_drift", "targetname");
	car = getEnt("drift_model", "targetname");
	kill = getEnt("drift_kill", "targetname");
	sfx = getEnt("drift_sfx", "targetname");

	kill enableLinkTo();
	kill linkTo(clip);
	car linkTo(clip);
	kill maps\mp\_utility::triggerOff();

	
}

trapRotate()
{
	platform = getEnt("trap_rotate", "targetname");
	trigger = getEnt("trig_rotate", "targetname");

	
}

trapFloor()
{
	platform = getEnt("trap_floor1", "targetname");
	cracks = getEnt("floor1_cracks", "targetname");
	groundefx = getEnt("floor1_efx", "targetname");
	trigger = getEnt("trig_floor1", "targetname");

	cracks hide();

	
}

trapFaller()
{
	trigger = getEnt("trig_faller", "targetname");
	kill = getEnt("faller_kill", "targetname");
	efx = getEntArray("faller_efx", "targetname");
	platform = getEnt("trap_faller", "targetname");
	clip = getEnt("faller_clip", "targetname");

	clip notSolid();
	kill maps\mp\_utility::triggerOff();
	kill enableLinkTo();
	kill linkTo(platform);

	
}

trapRoller()
{
	platform = getEnt("trap_roller", "targetname");
	trigger = getEnt("trig_roller", "targetname");
	kill = getEnt("roller_kill", "targetname");

	kill maps\mp\_utility::triggerOff();
	kill enableLinkTo();
	kill linkTo(platform);

	
}

rollerDown()
{
	self moveZ(-212, 4);
	self waittill("movedone");
	self moveY(-629,3);
}

rollerRotate()
{
	self rotateYaw(270, 4);
	self waittill("rotatedone");
}

trapPlatformFall()
{
	platform = getEnt("trap_platfall", "targetname");
	trigger = getEnt("trig_platfall", "targetname");
	efx = getEnt("platfall_efx", "targetname");
	kill = getEnt("platfall_kill", "targetname");

	kill enableLinkTo();
	kill linkTo(platform);

	
}

trapLadders()
{
	ladders = getEnt("trap_ladders", "targetname");
	trigger = getEnt("trig_ladders", "targetname");

	
}

trapBarrel()
{
	barrel = getEnt("trap_barrel", "targetname");
	trigger = getEnt("trig_barrel", "targetname");
	kill = getEnt("barrel_kill", "targetname");
	clip = getEnt("barrel_clip", "targetname");
	efx = getEnt("barrel_efx", "targetname");

	kill maps\mp\_utility::triggerOff();

	
}

trapDropPlatform()
{
	platform = getEnt("trap_platdrop", "targetname");
	trigger = getEnt("trig_platdrop", "targetname");

	
}