//Map made by |BH's|Kri26<3

// Discord : Krista26<3#2595

//Special Thanks CM'Nobody for help 

//Thanks Ohh Rexy<3 for help

//Thanks #Zsever#Moddedgolem for help

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_rank;

main()
{
thread sr\api\_map::createSpawn((76.125, 120, 32.125), 270);
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    
    setDvar("r_gamma","1");
    setDvar("r_specularcolorscale", "1");
    setDvar("r_glowbloomintensity0","1");
    setDvar("r_glowbloomintensity1","1");
    setDvar("r_glowskybleedintensity0","1");
    setDvar("compassmaxrange","1800");
    setDvar("bg_fallDamageMaxHeight", "99999");
    setDvar("bg_fallDamageMinHeight", "99998");

    precacheItem("m40a3_mp");
    precacheItem("remington700_mp");
    precacheItem("rpg_mp");
    precacheItem("deserteagle_mp");

	addTriggerToList("trig_trap1");
    addTriggerToList("trig_trap2");
    addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
    addtriggerTolist("trig_trap5");
    addtriggerTolist("trig_trap6");
    addtriggerTolist("trig_trap7");
	addtriggerTolist("trig_trap8");
	
	
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread prints();
	thread prints2();
	thread welcomemessage();
	thread secret_msg();
	thread random_ambient();
	thread bounce_sniper();
	thread teleport_1();
	thread teleport_2();
	thread teleport_3();
	thread teleport_acti1();
	thread teleport_acti3();
	thread sniper_room();
	thread bounce_room();
	thread rpg_room();
	thread pistol_room();
	thread knife_room();
    thread selectionroom();
    thread sr\api\_speedrun::createNormalWays("NOOB way");

}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}
prints()
{
    level waittill("round_started");

    msg_list = strtok("Welcome to ^5mp_dr_noob;Map by ^5|BH's|Kri26<3;Discord: ^5Krista26<3#2595; ^5Magik is noob",";");
    while(1)
    {
        for(i=0;i<msg_list.size;i++)
        {
            iprintln("^1>>^7 "+msg_list[i]);
            wait 10;
        }
        wait .1;
    }
}
prints2()
{
    level waittill("round_started");

    msg_list = strtok("Special Thanks To CM'Nobody ;Thanks Ooh Rexy<3 #Zsever#Golem:; Report any bugs",";");
    while(1)
    {
        for(i=0;i<msg_list.size;i++)
        {
            iprintln("^1>>^7 "+msg_list[i]);
            wait 10;
        }
        wait .1;
    }
}
welcomemessage()
{
    level waittill("round_started");
    wait 3;
    iprintlnbold("^0Map made by Krista26 mp_dr_noob for noobs");
}
secret_msg()
{
	trigger = getent ("secret", "targetname");
    trigger waittill("trigger", player);
    player iprintlnbold("^4Pure strafe secret RUN RUN!!");
}
random_ambient()
{
    level waittill("round_started");
    wait 2;
    random_ambient = randomint(6);
    if (random_ambient == 0)
    {
        title = "Pendulum_-_Propane_Nightmares";
        iPrintLn("^3>> ^7Now playing: ^3" + title + " ^3<<");
        AmbientPlay("sound1");
    }
    if (random_ambient == 1)
    {
        title = "NAV_-_Myself_Official_Music_Video_1";
        iPrintLn("^3>> ^7Now playing: ^3" + title + " ^3<<");
        AmbientPlay("sound2");
    }
    if (random_ambient == 2)
    {
        title = "Atmozfears, Code Black & Toneshifterz - All or Nothing";
        iPrintLn("^3>> ^7Now playing: ^3" + title + " ^3<<");
        AmbientPlay("sound3");
    }
    if (random_ambient == 3)
    {
        title = "Darren_Styles_-_Us_Against_The_World_Da_Tweekaz_Remix";
        iPrintLn("^3>> ^7Now playing: ^3" + title + " ^3<<");
        AmbientPlay("sound4");
    }
	if (random_ambient == 4)
	{
        title = "Dababy_-_Suge_Yea_Yea_Official_Music_Video";
        iPrintLn("^3>> ^7Now playing: ^3" + title + " ^3<<");
        AmbientPlay("sound5");
    }
	if (random_ambient == 5)
	{
        title = "Central_Cee_-_Loading_Music_Video_GRM_Daily";
        iPrintLn("^3>> ^7Now playing: ^3" + title + " ^3<<");
        AmbientPlay("sound6");
    }
}
bounce_sniper()
{
	trigger = getEnt("bounce_sniper","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player TakeAllWeapons();
		player GiveWeapon( "m40a3_mp" );
        player giveMaxAmmo( "m40a3_mp" );
        player GiveWeapon( "remington700_mp" );
        player giveMaxAmmo( "remington700_mp" );
		player switchToWeapon( "m40a3_mp" );
	}
	
}
teleport_acti1() {
	trigger = getent ("acti", "targetname");
	target = getent ("orig_acti", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}
teleport_1() {
	trigger = getent ("secret", "targetname");
	target = getent ("secret_jumper", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
	}
}
teleport_2() {
	trigger = getent ("secret_end", "targetname");
	target = getent ("secret_jumper_end", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}
teleport_3() {
	trigger = getent ("trig_bounce", "targetname");
	target = getent ("bounceroomactivator", "targetname");
	target = getent ("bounceroomjumper", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}
teleport_acti2() {
	trigger = getent ("acti2", "targetname");
	target = getent ("orig_acti2", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}
teleport_acti3() {
	trigger = getent ("acti_fail", "targetname");
	target = getent ("acti_fail_spawn", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}
trap1()
{
	trig = getent ("trig_trap1", "targetname");
    trap = getent ("trap_1", "targetname");
    trig setHintString ("^3Press [&&1] to activate");
	     
	while(1) 
    {
        trig waittill("trigger", player);
        trig delete();
		
		trap hide();
		trap notSolid();
		wait 3;
		trap show();
		trap solid();
	}
}
trap2()
{
    trig = getent ("trig_trap2", "targetname");
    trap1 = getent ("trap_2_1", "targetname");
    trap2 = getent ("trap_2_2", "targetname");
    trig setHintString ("^3Press [&&1] to activate");

      while(1) 
    {
          trig waittill("trigger", player);
        trig delete();

        trap1 moveZ(50, 1);
        trap2 moveZ(-25, 1);
		trap1 waittill("movedone");
        for(;;)
        {
            trap1 moveZ(-50, 1);
            trap2 moveZ(50, 1);
            trap1 waittill("movedone");
            trap1 moveZ(50, 1);
            trap2 moveZ(-50, 1);
            trap1 waittill("movedone");
        }
    }
}
trap3()
{
    trig = getent ("trig_trap3", "targetname");
    trap1 = getent ("trap_3_1", "targetname");
	trap2 = getent ("trap_3_2", "targetname");
    trig setHintString ("^3Press [&&1] to activate");

	trap2 enablelinkto();
	trap2 linkto(trap1);
      while(1) 
    {
          trig waittill("trigger", player);
        trig delete();

        {
            trap1 moveY(70, 3);
            wait 3;
			trap2 moveY(-70, 3);
            wait 3;
			trap2 moveY(70, 3);
            wait 0.1;
            trap1 moveY(-70, 3); 
            wait 100;
        }
    }
}
trap4()
{
    trig = getent ("trig_trap4", "targetname");
    trap = getent ("trap_4", "targetname");
    trig setHintString ("^3Press [&&1] to to activate");

     while(1) 
    {
        trig waittill("trigger", player);
        trig delete();
		
		for(;;)
		{
			trap rotateYaw(-360, 1.5);	
			wait 1.51;
			trap rotateYaw(-360, 1.5);	
			wait 1.51;
			trap rotateYaw(-360, 1.5);	
			wait 1.51;

			wait 5;
		}
    }
}
trap5()
{
	trig = getent ("trig_trap5", "targetname");
    trap = getent ("trap_5", "targetname");
    trig setHintString ("^3Press [&&1] to activate");
	     
	while(1) 
    {
        trig waittill("trigger", player);
        trig delete();
		
		trap hide();
		wait 10;
		trap show();
	}
}
trap6()
{
	trig = getent ("trig_trap6", "targetname");
    trap = getent ("trap_6", "targetname");
    trig setHintString ("^3Press [&&1] to activate");
	     
	while(1) 
    {
        trig waittill("trigger", player);
        trig delete();
		
		trap hide();
		trap notSolid();
		wait 3;
		trap show();
		trap solid();
	}
}
trap7()
{
	trig = getent ("trig_trap7", "targetname");
    trap = getent ("trap_7", "targetname");
    trig setHintString ("^3Press [&&1] to to activate");
	     
	 while(1) 
    {
        trig waittill("trigger", player);
        trig delete();
		
		trap notSolid();
	}
}
trap8()
{
	trig = getent ("trig_trap8", "targetname");
    trap = getent ("trap_8", "targetname");
    trig setHintString ("^3Press [&&1] to to activate");
	     
	 while(1) 
    {
        trig waittill("trigger", player);
        trig delete();
		
		trap notSolid();
	}
}
sniper_room()
{
    level.sniper = getEnt ("trigger_sniper", "targetname");

    orig_jumper = getEnt ("sniperroomjumper", "targetname");
    orig_acti = getEnt ("sniperroomactivator", "targetname");

    while (1)
    {
        level.sniper setHintString ("Press [&&1] to enter sniper room");
        level.sniper waittill ("trigger", player);

        iprintlnbold("" + player.name + " entered sniper room");
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player freezeControls(1);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
            level.activ giveWeapon("remington700_mp");
            level.activ giveMaxAmmo("remington700_mp");
            level.activ giveWeapon("m40a3_mp");
            level.activ giveMaxAmmo("m40a3_mp");
            level.activ switchToWeapon("m40a3_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ freezeControls(1);
        }

        wait 3;
        player freezeControls(0);
        level.activ freezeControls(0);
        player iprintlnbold("FIGHT!");
        level.activ iprintlnbold("FIGHT!");
    }
}
bounce_room()
{
    level.bounce = getEnt ("trigger_bounce", "targetname");

    orig_jumper = getEnt ("bounceroomjumper", "targetname");
    orig_acti = getEnt ("bounceroomactivator", "targetname");

    while (1)
    {
        level.bounce setHintString ("Press [&&1] to enter bounce room");
        level.bounce waittill ("trigger", player);

        iprintlnbold("" + player.name + " entered bounce room");
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player freezeControls(1);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
			level.activ giveWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ freezeControls(1);
        }

        wait 3;
        player freezeControls(0);
        level.activ freezeControls(0);
        player iprintlnbold("FIGHT!");
        level.activ iprintlnbold("FIGHT!");
    }
}
knife_room()
{
    level.knife = getEnt ("trigger_knife", "targetname");

    orig_jumper = getEnt ("kniferoomjumper", "targetname");
    orig_acti = getEnt ("kniferoomactivator", "targetname");

    while (1)
    {
        level.knife setHintString ("Press [&&1] to enter knife room");
        level.knife waittill ("trigger", player);

        iprintlnbold("" + player.name + " entered knife room");
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player freezeControls(1);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
			level.activ giveWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ freezeControls(1);
        }

        wait 3;
        player freezeControls(0);
        level.activ freezeControls(0);
        player iprintlnbold("FIGHT!");
        level.activ iprintlnbold("FIGHT!");
    }
}
rpg_room()
{
    level.rpg = getEnt ("trigger_rpg", "targetname");

    orig_jumper = getEnt ("weaponroomjumper", "targetname");
    orig_acti = getEnt ("weaponroomactivator", "targetname");

    while (1)
    {
        level.rpg setHintString ("Press [&&1] to enter rpg room");
        level.rpg waittill ("trigger", player);

        iprintlnbold("" + player.name + " entered rpg room");
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
		player giveWeapon("rpg_mp");
		player switchToWeapon("rpg_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player freezeControls(1);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
			level.activ giveWeapon("rpg_mp");
			level.activ switchToWeapon("rpg_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ freezeControls(1);
        }

        wait 3;
        player freezeControls(0);
        level.activ freezeControls(0);

        player thread rpg_ammo();
        level.activ thread rpg_ammo();

        player iprintlnbold("FIGHT!");
        level.activ iprintlnbold("FIGHT!");
    }
}
pistol_room()
{
    level.pistol = getEnt ("trigger_pistol", "targetname");

    orig_jumper = getEnt ("weaponroomjumper", "targetname");
    orig_acti = getEnt ("weaponroomactivator", "targetname");

    while (1)
    {
        level.pistol setHintString ("Press [&&1] to enter pistol room");
        level.pistol waittill ("trigger", player);

        iprintlnbold("" + player.name + " entered pistol room");
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
		player giveWeapon("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player freezeControls(1);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
			level.activ giveWeapon("deserteagle_mp");
			level.activ switchToWeapon("deserteagle_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ freezeControls(1);
        }

        wait 3;
        player freezeControls(0);
        level.activ freezeControls(0);
        player iprintlnbold("FIGHT!");
        level.activ iprintlnbold("FIGHT!");
    }
}
rpg_ammo()
{
    self endon("disconnect");
    self endon("death");

    for (;;)
    {
        if (self getCurrentWeapon() == "rpg_mp")
            self giveMaxAmmo("rpg_mp");

        wait 5;
    }
}
selectionroom()
{
    trig = getEnt ("selectionroom_trigger", "targetname");
    orig = getEnt ("selectionroom_origin", "targetname");

    while (1)
    {
        trig waittill ("trigger", player);
        player takeAllWeapons();
        player setOrigin (orig.origin);
        player setPlayerAngles(orig.angles);
        while (isDefined(player) && isAlive(player))
        wait .05;
    }
}

