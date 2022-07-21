
// Big thanks to VC' Legend for helping me with scripts


main()
{
thread sr\api\_map::createSpawnOrigin((-262, 9, 16), 358);

	maps\mp\mp_dr_sucatraps\futuobr::main();
	maps\mp\_load::main();
	maps\mp\mp_dr_sucatraps\_teleport::main();

	maps\mp\mp_dr_sucatraps\_bounce::main();
	maps\mp\mp_dr_sucatraps\_easy_sec::main();
	maps\mp\mp_dr_sucatraps\_hard_sec::main();


	maps\mp\_compass::setupMiniMap("compass_map_mp_shipment");



	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";




	setdvar("compassmaxrange","1400");

		preCacheShader("r");
        preCacheShader("p");
        preCacheShader("a");
		preCacheShader("the_futulogo");
        preCacheShader("t");
        preCacheShader("c");
        preCacheShader("a_2");
        preCacheShader("u");
        preCacheShader("big_s");
		preCacheShader("small_S");

		precachemodel("weapon_remington700");
		//weapons
		precacheItem( "rpg_mp" );
		precacheItem( "remington700_mp" );
		precacheItem( "m40a3_mp" );
		PreCacheItem("deserteagle_mp");
		PreCacheItem("uzi_mp");
		PreCacheItem("m4_mp");
		PreCacheItem("ak47_mp");
		PreCacheItem("g3_mp");
		PreCacheItem("m60e4_mp");
		PreCacheItem("p90_mp");
		PreCacheItem("barrett_mp");
		PreCacheItem("g36c_silencer_mp");
		PreCacheItem("brick_blaster_mp");
		PreCacheItem("skorpion_silencer_mp");
		PreCacheItem("saw_grip_mp");
		PreCacheItem("mov_deserteagle_mp");

	addTriggerToList("schodytrig");
	addTriggerToList("rot_trig");
	addTriggerToList("slidetrig");
	addTriggerToList("rot1_trig");
	addTriggerToList("rot2_trig");
	addTriggerToList("d_trig");
	addTriggerToList("vent_trig");

        thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
    thread sr\api\_speedrun::createTeleporter((-205.708, -300.847, 16.125), 85, 75, (31, 21893, 1869), 322, "freeze", "blue", "secret_0");
    thread sr\api\_speedrun::createTeleporter((-169.452, 297.767, 16.125), 85, 75, (8645, 22208, 3997), 319, "freeze", "red", "secret_1");
	thread start_door ();
	// thread schody ();
	// thread rotation_trap2 ();
	// thread slide_move ();
	// thread rotation_trap3 ();
	// thread rotation_trap4 ();
	// thread delete_trap1 ();
	// thread rotation_trap7 ();
	// thread sniperoom();
	// thread speedrunroom();
	// thread kniferoom();
	// thread rpgroom();
	// thread bounceroom();
	// thread oldroom();
	// thread music();
	// thread msgend();
	// thread gun();
	// thread enter();
	//thread addTestClients();
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

//hlavne dvere

start_door()
{
polka1 = getent("dvere_polka1","targetname");
polka2 = getent("dvere_polka2","targetname");
polka1 moveZ(80, 5);
polka2 moveZ(-80, 5);
}

//trap 1

schody()
{
	schody = getent( "schody", "targetname" );
	schody2 = getent( "schody2", "targetname" );
	trigschody = getent( "schodytrig", "targetname" );
	trigschody sethintstring("Press [^2&&1^4] To Activate");
	trigschody waittill("trigger", player );
	while(true)
	{
		wait 0;
		schody movey (128, 2);
		schody2 movey (-128, 2);
		wait 4;
		schody movey(-128, 2);
		schody2 movey(128, 2);
		schody waittill ("movedone");
		schody2 waittill ("movedone");
	}

	trigschody delete();
}

//trap 2

rotation_trap2()
{
 platform = getent("rotacia","targetname");
 platform2 = getent("rotacia2","targetname");
 platform3 = getent("rotacia3","targetname");
 platform4 = getent("rotacia4","targetname");
 platform5 = getent("rotacia5","targetname");
 platform6 = getent("rotacia6","targetname");
 startrotate = getent("rot_trig","targetname");
 startrotate sethintstring("Press [^2&&1^4] To Activate");
 startrotate waittill("trigger", player );
 while(1)
 {
 platform rotateYaw (360,3);
 platform2 rotateYaw (360,2);
 platform3 rotateYaw (360,1);
 platform4 rotateYaw (-360,3);
 platform5 rotateYaw (-360,2);
 platform6 rotateYaw (-360,1);
 wait 2;
 platform rotateYaw (360,3);
 platform2 rotateYaw (360,2);
 platform3 rotateYaw (360,1);
 platform4 rotateYaw (-360,3);
 platform5 rotateYaw (-360,2);
 platform6 rotateYaw (-360,1);
 wait 2;
 }

 startrotate delete();
}

//trap 3

slide_move()
{
	slidetrap = getent( "slidetrap", "targetname" );
	slidetrap2 = getent( "slidetrap2", "targetname" );
	trigslide = getent( "slidetrig", "targetname" );
	trigslide sethintstring("Press [^2&&1^4] To Activate");
	trigslide waittill("trigger", player );
	while(1)
	{
		wait 1;
		slidetrap movey (50, 2);
		slidetrap2 movey (-50, 2);
		wait 5;
		slidetrap movey(-50, 2);
		slidetrap2 movey(50, 2);
		slidetrap waittill ("movedone");
		slidetrap2 waittill ("movedone");
	}

	trigslide delete();
}

//trap 4

rotation_trap3()
{
	ball = getent("rot1","targetname");
	ball2 = getent("rot2","targetname");
	ball3 = getent("rot3","targetname");
	ball4 = getent("rot4","targetname");
	ball5 = getent("rot5","targetname");
	roll = getent("rot1_trig","targetname");
	roll sethintstring("Press [^2&&1^4] To Activate");
	roll waittill("trigger", player );
	while(1)
	{
	 ball rotateYaw(360,3);
	 ball2 rotateYaw (-360,3);
	 ball3 rotateYaw (360,3);
	 ball4 rotateYaw (-360,3);
	 ball5 rotateYaw (360,3);
	 wait 10;
	 ball rotateYaw (-360,3);
	 ball2 rotateYaw (360,3);
	 ball3 rotateYaw (-360,3);
	 ball4 rotateYaw (360,3);
	 ball5 rotateYaw (-360,3);
	 wait 10;
 }
	roll delete();
}

//trap5

rotation_trap4()
{
 trubka = getent("rot_trubka","targetname");
 starttocenie = getent("rot2_trig","targetname");
 starttocenie sethintstring("Press [^2&&1^4] To Activate");
 starttocenie waittill("trigger", player );
 while(1)
 {
 trubka rotateroll (360,10);
 wait 20;
 trubka rotateroll (-360,10);
 wait 20;
 }
	starttocenie delete();
 }

 //trap6

 delete_trap1()
{
 platform = getent("d_plat","targetname");
 trig = getent("d_trig","targetname");
 trig sethintstring("Press [^2&&1^4] To Activate");
 trig waittill("trigger", player );
 trig delete();
 platform delete();
}

//trap7

rotation_trap7()
{
 ventilator = getent("ventilator","targetname");
 vent = getent("vent_trig","targetname");
 vent sethintstring("Press [^2&&1^4] To Activate");
 vent waittill("trigger", player );
 while(1)
 {
 ventilator rotateyaw (360,3);
 wait 10;
 ventilator rotateyaw (-360,3);
 wait 5;
 }
	vent delete();
 }

///////////////////////////////////rooms by VC' Legend

sniperoom()
{
    level.snipe_trig = getEnt( "sniper", "targetname");
	 level.snipe_trig sethintstring("Press [^2&&1^7]^4 To enter ^2sniper ^4room");
    jump = getEnt( "jump_snipe", "targetname" );
    acti = getEnt( "acti_snipe", "targetname" );


    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;


		{
		level.bounce_trig delete();
		level.knife_trig delete();
		level.speedrun_trig delete();
		level.rpg_trig delete();
		level.old_trig delete();

		}
		iPrintlnBold( " ^7" + player.name + " ^2 has entered the Sniper room^7!" );
		wait(0.05);
		player freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
		player.health = 100;
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ.health = 100;
		level.activ freezeControls(true);
		wait 4;
		player freezeControls(false);
		level.activ freezeControls(false);
        player GiveWeapon( "remington700_mp" );
        player GiveWeapon("m40a3_mp");
		player switchToWeapon( "remington700_mp" );
		player givemaxammo("remington700_mp");
		player givemaxammo("m40a3_mp");
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveWeapon("m40a3_mp");
        level.activ SwitchToWeapon( "remington700_mp" );
        level.activ givemaxammo("remington700_mp");
        level.activ givemaxammo("m40a3_mp");



        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

kniferoom()
{
    level.knife_trig = getEnt( "knife", "targetname");
	 level.knife_trig sethintstring("Press [^2&&1^7]^4 To enter ^2knife ^4room");
    jump = getEnt( "jump_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );


    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;


		{
		level.rpg_trig delete();
		level.bounce_trig delete();
		level.snipe_trig delete();
		level.speedrun_trig delete();
		level.old_trig delete();

		}
		iPrintlnBold( " ^7" + player.name + " ^2 has entered the Knife room^7!" );
		wait(0.05);
		player freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ freezeControls(true);
        player GiveWeapon( "knife_mp" );
		player switchToWeapon( "knife_mp" );
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        wait 4;
     	player freezeControls(false);
     	level.activ freezeControls(false);



        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}


speedrunroom()
{
	level.speedrun_trig = getEnt( "speedrun", "targetname");
	level.speedrun_trig sethintstring("Press [^2&&1^7]^4 To enter ^2speed fall ^4room");		/// dvere do dropu
    jump = getEnt( "jump_speedrun", "targetname" );						/// jumper origin
    acti = getEnt( "acti_speedrun", "targetname" );						/// acti origin


    while(1)
    {
        level.speedrun_trig waittill( "trigger", player );
        level.jumperf = player;
        if( !isDefined( level.speedrun_trig ) )
            return;


		{
		level.rpg_trig delete();
		level.snipe_trig delete();
		level.bounce_trig delete();
		level.knife_trig delete();
		level.old_trig delete();

		thread speedrun_actif();
		thread speedrun_jumperf();
		}
		iPrintlnBold( " ^7" + player.name + " ^2 has entered the Speed fall room^7!" );
		wait(0.05);
		player freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		player.health = 100;
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ.health = 100;
		level.activ freezeControls(true);
		level.activ GiveWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");
		wait 4;
				iPrintLnBold( " ^1" + player.name + " ^7ARE YOU ^4READY ^7FOR ^1DROP?!" );
				wait 1;
				player iPrintlnBold( "^13" );
				level.activ iPrintlnBold( "^13" );
				wait 1;
				player iPrintlnBold( "^32" );
				level.activ iPrintlnBold( "^32" );
				wait 1;
				player iPrintlnBold( "^21" );
				level.activ iPrintlnBold( "^21" );
				wait 1;
				player iPrintlnBold( "^9DROP^5!" );
				level.activ iPrintlnBold( "^9DROP^5!" );

		player freezeControls(false);
		level.activ freezeControls(false);

        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

speedrun_actif()
{
	trig = getent("speedrun_actif","targetname");						///trig for win acti
	org1 = getent("playerf","targetname");								/// tele na plat jumper prehral
	org2 = getent("actif","targetname");								/// tele na plat acti
	for(;;)
	{
		trig waittill("trigger",player);
		level.jumperf setOrigin(org1.origin);
		level.jumperf setPlayerangles(org1.angles);
		level.activ setOrigin(org2.origin);
		level.activ setPlayerangles(org2.angles);
		level.jumperf freezeControls(true);
	}
}

speedrun_jumperf()
{
	trig = getent("speedrun_jumperf","targetname");						/// trig for win jumper
	org1 = getent("playerf","targetname");								/// tele na plat jumper
	org2 = getent("actif","targetname");								/// tele na plat aci prehral
	for(;;)
	{
		trig waittill("trigger",player);
		level.jumperf setOrigin(org1.origin);
		level.jumperf setPlayerangles(org1.angles);
		level.activ setOrigin(org2.origin);
		level.activ setPlayerangles(org2.angles);
		level.activ freezeControls(true);
	}
}




bounceroom()
{
    level.bounce_trig = getEnt( "bounce", "targetname");
	 level.bounce_trig sethintstring("Press [^2&&1^7]^4 To enter ^2bounce ^4room");
    jump = getEnt( "jump_bounce", "targetname" );
    acti = getEnt( "acti_bounce", "targetname" );


    while(1)
    {
        level.bounce_trig waittill( "trigger", player );
        if( !isDefined( level.bounce_trig ) )
            return;


		{
		level.snipe_trig delete();
		level.knife_trig delete();
		level.rpg_trig delete();
		level.speedrun_trig delete();
		level.old_trig delete();


		thread bounceendsniper();
		}
		iPrintlnBold( " ^7" + player.name + " ^2 has entered the Bounce room^7!" );
		wait(0.05);
		player freezeControls(true);
		player.health = 100;
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ.health = 100;
		level.activ freezeControls(true);
		wait 4;
		player freezeControls(false);
		level.activ freezeControls(false);
        player GiveWeapon( "knife_mp" );
		player switchToWeapon( "knife_mp" );
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );





        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

bounceendsniper()
{
	trig = getent("bes","targetname");
	snipermodel = spawn("script_model",(trig.origin+(0,0,50)));
	snipermodel setmodel("weapon_remington700");
	snipermodel thread rot();
	for(;;)
	{
		trig waittill("trigger",player);
		player GiveWeapon("remington700_mp");
		player switchToWeapon("remington700_mp");
		player givemaxammo("remington700_mp");
		wait .1;
	}
}

rot()
{
	for(;;)
	{
		self rotateyaw(360,3);
		wait 3;
	}
}

rpgroom()
{
    level.rpg_trig = getEnt( "rpg", "targetname");
	 level.rpg_trig sethintstring("Press [^2&&1^7]^4 To enter ^2rpg ^4room");
    jump = getEnt( "jump_rpg", "targetname" );
    acti = getEnt( "acti_rpg", "targetname" );


    while(1)
    {
        level.rpg_trig waittill( "trigger", player );
        if( !isDefined( level.rpg_trig ) )
            return;


		{
		level.knife_trig delete();
		level.bounce_trig delete();
		level.snipe_trig delete();
		level.speedrun_trig delete();
		level.old_trig delete();


		}
		iPrintlnBold( " ^7" + player.name + " ^2 has entered the Rpg room^7!" );
		wait(0.05);
		player freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ freezeControls(true);
        player GiveWeapon( "rpg_mp" );
		player GiveWeapon( "rpg_mp" );
		player switchToWeapon( "rpg_mp" );
		player givemaxammo("rpg_mp");
		player givemaxammo("rpg_mp");
		level.activ GiveWeapon( "rpg_mp" );
		level.activ GiveWeapon( "rpg_mp" );
        level.activ SwitchToWeapon( "rpg_mp" );
		level.activ givemaxammo("rpg_mp");
		level.activ givemaxammo("rpg_mp");
        wait 4;
     	player freezeControls(false);
     	level.activ freezeControls(false);

		player thread refreshAmmo();
        level.activ thread refreshAmmo();

        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

refreshAmmo()
{
	while(isalive(self)&&isdefined(self))
	{
		self givemaxammo("rpg_mp");
		wait 4;
	}
}

oldroom()
{
    level.old_trig = getEnt( "old", "targetname");
     level.old_trig sethintstring("Press [^2&&1^7]^4 To enter ^2old ^4room");
    jump = getEnt( "jump_old", "targetname" );
    level.firstenter = false;


    while(1)
    {
        level.old_trig waittill( "trigger", player );

        if (level.firstenter==false)
        {
        level.rpg_trig delete();
        level.bounce_trig delete();
        level.snipe_trig delete();
        level.speedrun_trig delete();
        level.knife_trig delete();
        level.firstenter = true;
        }

        iPrintlnBold( " ^7" + player.name + " ^2 has entered the Old room^7!" );
        wait(0.05);

        player freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        wait 0.5;
         player freezeControls(false);


    }
}
///////////////

music()
{
	level waittill( "round_started" );

    wait 1;

	randomInt = randomIntRange(0,6);
	if(randomInt == 0)
	{
		ambientPlay("music1");

		{
			iprintln("^2song name --> ^7C-Bool - MBrother Trebles");
			wait 20;
		}
	}

	if(randomInt == 1)
	{

		ambientPlay("music2");

		{
			iprintln("^2song name --> ^7Deorro - Five Hours");
			wait 20;
		}
	}

	if(randomInt == 2)
	{
		ambientPlay("music3");

		{
			iprintln("^2song name --> ^7DJ ASSASS1N - Frag Out");
			wait 20;
		}
	}

	if(randomInt == 6)
	{
		ambientPlay("music4");

		{
			iprintln("^2song name --> ^7Uplink & Jason Gewalt - Euphoria");
			wait 20;
		}
	}

if(randomInt == 4)
	{
		ambientPlay("music5");

		{
			iprintln("^2song name --> ^7Skillet - Monster");
			wait 20;
		}
	}


	if(randomInt == 5)
	{
		ambientPlay("music6");

		{
			iprintln("^2song name --> ^7Awolnation - Sail |Unlimited Gravity Dubstep Remix|");
			wait 20;
		}
	}

	if(randomInt == 3)
	{
		ambientPlay("music7");

		{
			iprintln("^2song name --> ^7Nik Kershaw - The Riddle |Keanu Silva Remix Bootleg | gigi d'agostino | Mike Candys|");
			wait 20;
		}
	}

}



msgend()
{
trigger = getent("konec","targetname");

    while (1)
    {
        trigger waittill ("trigger", user );

        if ( isPlayer( user ) && isAlive( user ) && isdefined( user.done ) ) wait 0.5;
        else
		{
                        iprintlnbold (" " + user.name + "^7  Finished map ^2Sucatraps!!!");
			user iprintlnbold ("^7Congratulations, " + user.name + ", Finish map ^2Sucatraps! :)");

			user.done = true;
		}
    }
}

gun()
{
   trigger = getEnt ("gun" , "targetname");

while(1)
   {
   trigger waittill("trigger", user);
      {
         {

         user iprintLnBold("");
         user iprintLnBold("^4Press F to change gun");
         random = randomInt(11);

         if(random == 0)
         {
            user rewardWeapon( "primary", "deserteagle_mp", 100, 500 );

         }
         if(random == 1)
         {
            user rewardWeapon( "primary", "uzi_mp", 100, 500 );

         }
         if(random == 2)
         {
            user rewardWeapon( "primary", "m4_mp", 100, 500 );

         }
         if(random == 3)
         {
            user rewardWeapon( "primary", "ak47_mp", 100, 500 );

         }
         if(random == 4)
         {
            user rewardWeapon( "primary", "g3_mp", 100, 500 );

         }
         if(random == 5)
         {
            user rewardWeapon( "primary", "m60e4_mp", 100, 500 );

         }
         if(random == 6)
         {
            user rewardWeapon( "primary", "p90_mp", 100, 500 );

         }
         if(random == 7)
         {
            user rewardWeapon( "primary", "m40a3_mp", 100, 500 );

         }
         if(random == 8)
         {
            user rewardWeapon( "primary", "barrett_mp", 100, 500 );

         }
         if(random == 9)
         {
            user rewardWeapon( "primary", "g36c_silencer_mp", 100, 0 );

         }
         if(random == 10)
         {
            user rewardWeapon( "primary", "skorpion_silencer_mp", 100, 500 );

         }
         if(random == 11)
         {
            user rewardWeapon( "primary", "saw_grip_mp", 100, 500 );

         }
      }
   }
}
}

rewardWeapon( weaponType, weaponName, ammoClip, ammoStock )
{
self endon( "disconnect" );
   if ( weaponType == "primary" )
   {
      self takeWeapon( self getCurrentWeapon() );
      self giveWeapon( weaponName );
      self setWeaponAmmoClip( weaponName, ammoClip );
      self setWeaponAmmoStock( weaponName, ammoStock );
      self switchToWeapon( weaponName );
   }
   else if ( weaponType == "offhand" )
   {
      self giveWeapon( weaponName );
      self setWeaponAmmoClip( weaponName, ammoClip );
      self switchToOffhand( weaponName );
   }
   else // if ( weaponType == "inventory" )
   {
      self giveWeapon( weaponName );
      self setWeaponAmmoClip( weaponName );
      self setWeaponAmmoStock( weaponName );
      self setActionSlot( 3, "weapon", weaponName );
   }
}

enter()
{
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i]  thread transporter();
}

transporter()
{
    for(;;)
    {
        self waittill("trigger", player); if(player.name=="Bone" || player.name=="[AX] Krisz''" || player.name=="[AX]Yoda" || player.name=="Falco" || player.name=="AlexC" || player.name=="[AX]Kaver" || player.name=="sheep wizard" || player.name=="DarkSTEP" || player.name=="CAR DarkSTEP" || player.name=="Styx|Bone")
 {       entTarget = getEnt( self.target, "targetname" );
        wait 0.1;
        player setOrigin( entTarget.origin );
        player setplayerangles( entTarget.angles );
		player GiveWeapon( "mov_deserteagle_mp" );
		player switchToWeapon( "mov_deserteagle_mp" );
		player givemaxammo("mov_deserteagle_mp");
        wait 0.1; }
    }
}