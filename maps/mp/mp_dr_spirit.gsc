/*			  
  /\\  /\\  
  //\\_//\\     ____
  \_     _/    /   /
   / ^ ^ \    /^^^|
   \_\O/_/    |   |
    /   \_    |   /
    \     \_  /  /
    | | | /  \/ _/
    |_| | \__/_/               				  
	By VC' Fox.
	
	Quick map i made for fun
	
*/

main()
{

	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 3000000);
	setDvar("bg_falldamageminheight", 1280000);

	thread sr\api\_map::createSpawn((759, -32,60), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
	thread sr\api\_speedrun::createEndMap((928.731, 6265.23, 0.124997),95,120, "normal_0"); 

	thread custom_tp();
	thread sr_sec_enter();

	/*precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	precacheItem("rpg_mp");
	precacheItem("colt44_mp");
	precacheItem("colt45_silencer_mp");
	precacheItem("ak47_mp");
	precacheItem("g36c_reflex_mp");
	precacheItem("ak74u_mp");
	precacheItem("g3_mp");
	precacheItem("usp_mp");
	precacheItem("deserteagle_mp");
	precacheItem("uzi_silencer_mp");
	precacheItem("rpd_mp");
	precacheItem("saw_mp");
	precacheItem("winchester1200_mp");*/

	thread startdoor();
	//thread elevator();
	//thread spinner();
	//thread secret_enter();
	thread secret_leave();
	//thread acti_tp1();
	//thread acti_tp2();
	//thread platform_move1();
	//thread platform_move2();
	//thread xp_secret();
	//thread bounce_room_wep();
	//thread bounce_fail_1();
	//thread bounce_fail_2();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	//thread knife_room();
	//thread sniper_room();
	//thread bounce_room();
	//thread rwep_room();
	//thread addTestClients();
	
	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");

}
custom_tp()
{
	trig = spawn("trigger_radius",(756.073, 2609.1, 256.125), 0, 80, 120);
	trig.radius = 80;
	
	ori_t = spawn("script_origin",(765,3814,60));
	ori_t.angles = (0,90,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
sr_sec_enter()
{
	trig = spawn("trigger_radius",(927.258, -32.1701, 0.1255), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("here3","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
addTriggerToList( name ) 
{
    if( !isDefined(level.trapTriggers) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name , "targetname");
}

startdoor()
{
	door = getent("startdoor","targetname");

	wait 0.1;
	
	door delete();
	
}


elevator()
{
	elev = getEnt("elev", "targetname");
	
	for(;;)
	{
	wait 0.1;
	elev moveY (832, 2);
	wait 4;
	elev moveY (-832, 2);
	wait 4;
	}	
}

platform_move1()
{
	plat = getEnt("plat1", "targetname");
	trig = getEnt("trig_plat1", "targetname");
	
	trig waittill ("trigger",player);
	
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	plat moveY (832, 4);
	wait 6;
	plat moveY (-832, 4);
	wait 6;
	}	
}

platform_move2()
{
	plat = getEnt("plat2", "targetname");
	trig = getEnt("trig_plat2", "targetname");
	
	trig waittill ("trigger",player);
	
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	plat moveY (832, 4);
	wait 6;
	plat moveY (-832, 4);
	wait 6;
	}	
}

spinner()
{
	spin = getEnt("spinner", "targetname");
	
	for(;;)
	{
	wait 0.1;
	spin rotateYaw (180, 2);
	wait 3;
	spin rotateYaw (180, 2);
	wait 3;
	}	
}

secret_enter()
{
	trig = getEnt("sec_enter", "targetname");
	tele1 = getEnt("here3", "targetname");
	
	trig setHintString("Press [^4&&1^7] To Enter the Secret Way^4.");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

secret_leave()
{
	trig = getEnt("sec_leave", "targetname");
	tele1 = getEnt("here4", "targetname");
	
	trig setHintString("Press [^4&&1^7] To Leave the Secret Way^4.");


	for(;;)
		{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
}

acti_tp1()
{
	trig = getEnt("tp_acti1", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

acti_tp2()
{
	trig = getEnt("tp_acti2", "targetname");
	tele1 = getEnt("here2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

bounce_fail_1()
{
	trig = getEnt("bf_1", "targetname");
	tele1 = getEnt("br_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

bounce_fail_2()
{
	trig = getEnt("bf_2", "targetname");
	tele1 = getEnt("br_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}


xp_secret()
{
	trig = getEnt("trig_xp", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7For XP.");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 100 );
	iPrintLnBold("^4"+ player.name + " ^7Has Found Some ^4XP!");	
	trig delete();
}

/////////////////////////////////////////////////////////
////////////////////////Traps////////////////////////////
/////////////////////////////////////////////////////////

trap1()
{
	brush1 = getEnt("trap_1a", "targetname");
	brush2 = getEnt("trap_1b", "targetname");
	trig = getEnt("trig_trap1", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Activate.");
	
	trig waittill("trigger", player);
	
	
}

trap2()
{
	brush = getEnt("trap_2", "targetname");
	trig = getEnt("trig_trap2", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Activate.");
	
	trig waittill("trigger", player);
	
	
	
}


trap3()
{
	brush = getEnt("trap_3", "targetname");
	brush2 = getEnt("trap_3b", "targetname");
	trig = getEnt("trig_trap3", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Activate.");
	
	trig waittill("trigger", player);
	

}

trap4()
{
	brush1 = getEnt("trap_4a", "targetname");
	brush2 = getEnt("trap_4b", "targetname");
	trig = getEnt("trig_trap4", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Activate.");
	
	trig waittill("trigger", player);
	
	
}

trap5()
{
	brush = getEnt("trap_5", "targetname");
	trig = getEnt("trig_trap5", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Activate.");
	
	trig waittill("trigger", player);
	
}

trap6()
{
	brush = getEnt("trap_6", "targetname");
	trig = getEnt("trig_trap6", "targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Activate.");
	
	trig waittill("trigger", player);
	
}


bounce_room_wep()
{
	trig = getEnt("br_wep","targetname");
	
	trig setHintString("Press [^4&&1^7] ^7To Take Random Weapon.");
	
	while(1)
	{
	
	trig waittill("trigger", player);

	random_weapon = [];
	random_weapon[random_weapon.size] = "m40a3_mp";
	random_weapon[random_weapon.size] = "remington700_mp";
	random_weapon[random_weapon.size] = "ak47_mp";
		
	x = randomInt(random_weapon.size);
		
	wep = random_weapon[x];
		
	player takeAllWeapons();
	player giveWeapon(wep);
	player giveMaxAmmo(wep);	
	player switchToWeapon(wep);
	
	}
}


knife_room()
{
	while(1)
{
	level.trigknife = getEnt("trig_knife", "targetname");
	
	level.trigknife setHintString("^4Knife Room");
	
	jumporigin = getEnt("k_1", "targetname");
	actiorigin = getEnt("k_2", "targetname");
	
	level.trigknife waittill("trigger", player);

	
	level.trigsniper delete();
	level.trigbounce delete();
	level.trigrwep delete();
	
	iPrintLnBold("^4 " + player.name + " ^7Entered The ^4Knife ^7Room^4!");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");

	
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	wait 1;
	player iPrintLnBold("^7FIGHT^4!");
	level.activ iPrintLnBold("^7FIGHT^4!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	
	while( isAlive( player ) && isDefined( player ) )
    wait 1;

}	
}

bounce_room()
{
	while(1)
{
	level.trigbounce = getEnt("trig_bounce", "targetname");
	
	level.trigbounce setHintString("^4Bounce Room");
	
	jumporigin = getEnt("br_1", "targetname");
	actiorigin = getEnt("br_2", "targetname");
	
	level.trigbounce waittill("trigger", player);
	
	level.trigsniper delete();
	level.trigknife delete();
	level.trigrwep delete();
	
	iPrintLnBold("^4 " + player.name + " ^7Entered The ^4Bounce ^7Room^4!");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");

	
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	wait 1;
	player iPrintLnBold("^7FIGHT^4!");
	level.activ iPrintLnBold("^7FIGHT^4!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	
	while( isAlive( player ) && isDefined( player ) )
    wait 1;

}	
}


sniper_room()
{
	while(1)
{
	level.trigsniper = getEnt("trig_sniper", "targetname");
	
	level.trigsniper setHintString("^4sniper Room");
	
	jumporigin = getEnt("s_1", "targetname");
	actiorigin = getEnt("s_2", "targetname");
	
	level.trigsniper waittill("trigger", player);

	
	level.trigbounce delete();
	level.trigknife delete();
	level.trigrwep delete();
	
	iPrintLnBold("^4 " + player.name + " ^7Entered The ^4Sniper ^7Room^4!");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("m40a3_mp");
	level.activ giveWeapon("m40a3_mp");
	player giveWeapon("remington700_mp");
	player giveWeapon("remington700_mp");
	
	player giveMaxAmmo("m40a3_mp");
	player giveMaxAmmo("remington700_mp");
	
	level.activ giveMaxAmmo("m40a3_mp");
	level.activ giveMaxAmmo("remington700_mp");
	
	player switchToWeapon("m40a3_mp");
	level.activ switchToWeapon("m40a3_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	wait 1;
	player iPrintLnBold("^7FIGHT^4!");
	level.activ iPrintLnBold("^7FIGHT^4!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	
	while( isAlive( player ) && isDefined( player ) )
    wait 1;

}	
}



rwep_room()
{
	while(1)
{
	level.trigrwep = getEnt("trig_rwep", "targetname");
	
	level.trigrwep setHintString("^4Random Weapon Room");
	
	jumporigin = getEnt("w_1", "targetname");
	actiorigin = getEnt("w_2", "targetname");
	
	level.trigrwep waittill("trigger", player);
	
	level.trigbounce delete();
	level.trigknife delete();
	level.trigsniper delete();
	
	iPrintLnBold("^4 " + player.name + " ^7Entered The ^4Random Weapon ^7Room^4!");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	random_weapon = [];
	random_weapon[random_weapon.size] = "g36c_reflex_mp";
	random_weapon[random_weapon.size] = "m40a3_mp";
	random_weapon[random_weapon.size] = "colt45_silencer_mp";
	random_weapon[random_weapon.size] = "colt44_mp";
	random_weapon[random_weapon.size] = "usp_mp";
	random_weapon[random_weapon.size] = "deserteagle_mp";
	random_weapon[random_weapon.size] = "uzi_silencer_mp";
	random_weapon[random_weapon.size] = "ak74u_mp";
	random_weapon[random_weapon.size] = "rpd_mp";
	random_weapon[random_weapon.size] = "saw_mp";
	random_weapon[random_weapon.size] = "ak47_mp";
	random_weapon[random_weapon.size] = "g3_mp";
	random_weapon[random_weapon.size] = "rpg_mp";
	random_weapon[random_weapon.size] = "winchester1200_mp";
		
	x = randomInt(random_weapon.size);
		
	wep = random_weapon[x];
		
	player takeAllWeapons();
	player giveWeapon(wep);
	player giveMaxAmmo(wep);	
	player switchToWeapon(wep);
	
	level.activ takeAllWeapons();
	level.activ giveWeapon(wep);
	level.activ giveMaxAmmo(wep);
    level.activ switchToWeapon(wep);
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	wait 1;
	player iPrintLnBold("^7FIGHT^4!");
	level.activ iPrintLnBold("^7FIGHT^4!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	
	while( isAlive( player ) && isDefined( player ) )
    wait 1;

}	
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


addTestClients()
{
     setDvar("scr_testclients", "");
     wait 1;
     for(;;)
     {
         if(getdvarInt("scr_testclients") > 0)
             break;
         wait 1;
     }
     testclients = getdvarInt("scr_testclients");
     setDvar( "scr_testclients", 0 );
     for(i=0;i<testclients;i++)
     {
         ent[i] = addtestclient();

         if (!isdefined(ent[i]))
         {
             println("Could not add test client");
             wait 1;
             continue;
         }
         ent[i].pers["isBot"] = true;
         ent[i].pers["registered"] = 0;
         ent[i] thread TestClient("autoassign");
     }
     thread addTestClients();
}

TestClient(team)
{
     self endon( "disconnect" );

     while(!isdefined(self.pers["team"]))
         wait .05;
         
     self notify("menuresponse", game["menu_team"], team);
     wait 0.5;
}