main()
{
	maps\mp\_load::main();

	thread sr\api\_speedrun::createNormalWays("Trap Way;Trance Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-3721, 1758, 570), -90);
	thread sr\api\_speedrun::createTeleporter((-1414.99, -6929.17, 496.125), 80, 10, (-1419, -7578, 556), 270, "freeze", "blue", "normal_0");
	thread sr\api\_speedrun::createTeleporter((-3712.56, -155.318, 496.125), 80, 10, (-3722, -1835, 556), 270, "freeze", "blue", "normal_1");
    thread sr\api\_speedrun::createEndMap((-2288.99, -8639.36, 496.125),70,40, "normal_0");
	thread sr\api\_speedrun::createEndMap((-3712.56, -155.318, 496.125),70,40, "normal_1");
	// ================ Game Settings ================ //
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	// ==================== Dvars ==================== //
	setdvar("bg_falldamagemaxheight", 20000 );
	setdvar("bg_falldamageminheight", 15000 );

  	setdvar( "r_specularcolorscale", "1" );
  	setdvar("r_glowbloomintensity0",".25");
  	setdvar("r_glowbloomintensity1",".25");
  	setdvar("r_glowskybleedintensity0",".3");
  	setDvar( "compassmaxrange", "1024" );

  	// ================== Precache =================== //
  	precachemodel("vistic_logo");

  	// =================== Scripts =================== //
  	thread doors();
  	thread tnt_secret();

  	//thread tnt_rooms();
  	//thread trap_traps();
  	//thread trance_traps();
}

doors()
{
	trap = getent("trap_door","targetname");
	trance = getent("trance_door","targetname");

	wait 0.1;
	trap delete();
	trance delete();
}

trap_traps()
{
	thread trap_trap1();
	thread trap_trap2();
	thread trap_trap3();
	thread trap_trap4();
	thread trap_trap5();
	thread trap_trap6();
	thread trap_trap7();

	addTriggerToList( "trap_trap1_trig" );
	addTriggerToList( "trap_trap2_trig" );
	addTriggerToList( "trap_trap3_trig" );
	addTriggerToList( "trap_trap4_trig" );
	addTriggerToList( "trap_trap5_trig" );
	addTriggerToList( "trap_trap6_trig" );
	addTriggerToList( "trap_trap7_trig" );
}

trap_trap1()
{
	trig = getEnt("trap_trap1_trig", "targetname");
	trap = getEnt("trap_trap1", "targetname");

	trig setHintString("Press [^5&&1^7] to activate ^5Trap 1");
	trig waittill("trigger");
	trig delete();

	while(isdefined(trap))
	{
		trap rotatePitch(-360, 14);
		wait 1;
	}
}

trap_trap2()
{
	trig = getEnt("trap_trap2_trig", "targetname");
	trapa = getEnt("trap_trap2a", "targetname");
	trapb = getEnt("trap_trap2b", "targetname");

	trig setHintString("Press [^5&&1^7] to activate ^5Trap 2");
	trig waittill("trigger");
	trig delete();

	trapa movez(70, 1.5);	
	trapb movez(-70,1.5);

	wait 1.5;

	while(isdefined(trapa) && isdefined(trapb))
	{
		trapa movez(-140, 1.5);
		trapb movez(140,1.5);
		wait 1.5;
		trapa movez(140, 1.5);
		trapb movez(-140, 1.5);
		wait 1.5;
	}
}

trap_trap3()
{
	trig = getEnt("trap_trap3_trig", "targetname");
	trapa = getEnt("trap_trap3a", "targetname");
	trapb = getent("trap_trap3b","targetname");

	trig setHintString("Press [^5&&1^7] to activate ^5Trap 3");
	trig waittill("trigger");
	trig delete();

	trapa thread rotate_pitch();

	while(isdefined(trapb))
	{
		trapb rotateYaw(360, 3);
		wait 3;
	}
}

rotate_pitch()
{
	while(isdefined(self))
	{
		self rotateroll(-360, 3);
		wait 3;
	}
}

trap_trap4()
{
  	trig = getEnt("trap_trap4_trig", "targetname");
  	trapa = getEnt("trap_trap4a", "targetname");
 	trapb = getEnt("trap_trap4b", "targetname");
  
  	trig setHintString("Press [^5&&1^7] to activate ^5Trap 4");
	trig waittill("trigger");
	trig delete();

  	while(isdefined(trapa) && isdefined(trapb))
  	{
    	trapa rotatePitch(360,1.5);
		trapb rotatePitch(-360,1.5);
    	wait 1.5;
  	}
}

trap_trap5()
{
	trig = getEnt("trap_trap5_trig", "targetname");
	help = getent("trap_trap5_help","targetname");
	trap = getentarray("trap_trap5","targetname");
	hurt = getentarray("trap_trap5_hurt","targetname");

	hfx = undefined;

	for(i=0;i<hurt.size;i++)
		hurt[i] maps\mp\_utility::triggeroff();

	help notsolid();

	trig setHintString("Press [^5&&1^7] to activate ^5Trap 5");
	trig waittill("trigger");
	trig delete();

	for(i=0;i<hurt.size;i++)
		hurt[i] maps\mp\_utility::triggeron();

	for(i=0;i<trap.size;i++)
	{
		hfx[i] = spawnfx(level.tnt_purple_fire,trap[i].origin);
		triggerfx(hfx[i]);
		wait .05;
	}

    wait 5+randomint(5);
    for(i=0;i<hurt.size;i++)
		hurt[i] maps\mp\_utility::triggeroff();

    for(i=0;i<trap.size;i++)
        hfx[i] delete();
}

trap_trap6()
{
	trig = getEnt("trap_trap6_trig", "targetname");
	trap = getEnt("trap_trap6", "targetname");

	trig setHintString("Press [^5&&1^7] to activate ^5Trap 6");
	trig waittill("trigger");
	trig delete();

	while(isdefined(trap))
	{
		trap rotateYaw(360, 2);
		wait 2;
	}
}

trap_trap7()
{
	trig = getEnt("trap_trap7_trig", "targetname");
	trap = getEnt("trap_trap7", "targetname");

	trap thread move_trap7();

	trig setHintString("Press [^5&&1^7] to activate ^5Trap 7");
	trig waittill("trigger");
	trig delete();

	if(isdefined(trap))
	{
		trap notsolid();
		wait 5;
		trap solid();
	}
}

move_trap7()
{
	while(isdefined(self))
	{
		self movey(-464,5);
		wait 5;
		self movey(464,5);
		wait 5;
	}
}


trance_traps()
{
	thread trance_trap1();
	thread trance_trap2();
	thread trance_trap3();
	thread trance_trap4();
	thread trance_trap5();
	thread trance_trap6();

	addTriggerToList( "trance_trap1_trig" );
	addTriggerToList( "trance_trap2_trig" );
	addTriggerToList( "trance_trap3_trig" );
	addTriggerToList( "trance_trap4_trig" );
	addTriggerToList( "trance_trap5_trig" );
	addTriggerToList( "trance_trap6_trig" );
}

trance_trap1()
{
	trig = getEnt("trance_trap1_trig", "targetname");
	trap = getEnt("trance_trap1", "targetname");

	trig setHintString("Press [^2&&1^7] to activate ^2Trap 1");
	trig waittill("trigger");
	trig delete();

	trap hide();
	trap notsolid();

	wait 5;

	trap show();
	trap solid();
}

trance_trap2()
{
	trig = getEnt("trance_trap2_trig", "targetname");
	move = getent("trance_trap2_move","targetname");
	trapa = getEnt("trance_trap2a", "targetname");
	trapb = getEnt("trance_trap2b", "targetname");

	move thread move_trap2();

	trig setHintString("Press [^2&&1^7] to activate ^2Trap 2");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa moveZ(-150, 0.5);
		trapb moveZ(150, 0.5);
		wait 1;
		trapa moveZ(150, 0.5);
		trapb moveZ(-150, 0.5);
		wait 1;
	}
}

move_trap2()
{
	while(isdefined(self))
	{
		self movey(-1440,5);
		wait 5;
		self movey(1440,5);
		wait 5;
	}
}

trance_trap3()
{
	trig = getEnt("trance_trap3_trig", "targetname");
	trapa = getEnt("trance_trap3a", "targetname");
	trapb = getEnt("trance_trap3b", "targetname");
	trapc = getEnt("trance_trap3c", "targetname");

	trig setHintString("Press [^2&&1^7] to activate ^2Trap 3");
	trig waittill("trigger");
	trig delete();

	trapb rotateYaw(90, 1);
	trapc rotateRoll(-30, 1);

	while(isdefined(trapa))
	{
		trapa moveZ(-200, 2);
		wait 2;
		trapa moveZ(200, 2);
		wait 2;
	}
}

trance_trap4()
{
	trig = getEnt("trance_trap4_trig", "targetname");
	trap = getEnt("trance_trap4", "targetname");

	trig setHintString("Press [^2&&1^7] to activate ^2Trap 4");
	trig waittill("trigger");
	trig delete();

	while(isdefined(trap))
	{
		trap moveZ(-256, 0.2);
		wait 3;
		trap moveZ(256, 1);
		wait 3;
	}
}

trance_trap5()
{
	trig = getEnt("trance_trap5_trig", "targetname");
	trap = getEnt("trance_trap5", "targetname");

	trig setHintString("Press [^2&&1^7] to activate ^2Trap 5");
	trig waittill("trigger");
	trig delete();

	while(isdefined(trap))
	{
		trap rotatePitch(360, 14);
		wait 1;
	}
}

trance_trap6()
{
	trig = getEnt("trance_trap6_trig", "targetname");
	trap = getEnt("trance_trap6", "targetname");

	trig setHintString("Press [^2&&1^7] to activate ^2Trap 6");
	trig waittill("trigger");
	trig delete();

	trap hide();
	trap notsolid();

	wait 5;

	trap show();
	trap solid();
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers = [];

    level.trapTriggers[level.trapTriggers.size] = getent(name,"targetname");
}

tnt_rooms()
{
	thread sniper_room();
	thread deagle_room();
	thread shotgun_room();
	thread knife_room();
	thread bounce_room();

	thread sniper_fail();
	thread bounce_fail();

	thread bounce_jump_weapon();
	thread bounce_acti_weapon();
}

sniper_room()
{
    level.sniper = getent("tnt_sniper_trig","targetname");
    jump = getent("sniper_jump","targetname");
    acti = getent("sniper_acti","targetname");

    level.sniper sethintstring("Press [^2&&1^7] to choose ^5Sniper ^7Endroom");

    while(1)
    {
        level.sniper waittill("trigger",player);

        if(!isdefined(level.sniper))
            return; 

        if(isdefined(level.activ))
        {
            player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);
            level.activ room_setup(acti,"remington700_mp","m40a3_mp","yes",1);

            noti = SpawnStruct();
            noti.titleText = "Sniper Room";
            noti.notifyText = "^7"+level.activ.name+" ^1vs ^7"+player.name;
            noti.duration = 6;
            noti.glowcolor = (0, 1, 1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
            wait 5;

            player iPrintLnBold("^1>> ^7Fight! ^1<<");
            level.activ iPrintLnBold("^1>> ^7Fight! ^1<<");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player) && isDefined(player))
            wait 1;
    }
}

deagle_room()
{
    level.deagle = getent("tnt_deagle_trig","targetname");
    jump = getent("deagle_jump","targetname");
    acti = getent("deagle_acti","targetname");

    level.deagle sethintstring("Press [^2&&1^7] to choose ^5Deagle ^7Endroom");

    while(1)
    {
        level.deagle waittill("trigger",player);

        if(!isdefined(level.deagle))
            return; 

        if(isdefined(level.activ))
        {
            player room_setup(jump,"deserteagle_mp",undefined,"yes",1);
            level.activ room_setup(acti,"deserteaglegold_mp",undefined,"yes",1);

            noti = SpawnStruct();
            noti.titleText = "Deagle Room";
            noti.notifyText = "^7"+level.activ.name+" ^1vs ^7"+player.name;
            noti.duration = 6;
            noti.glowcolor = (1, 0, 1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
            wait 5;

            player iPrintLnBold("^1>> ^7Fight! ^1<<");
            level.activ iPrintLnBold("^1>> ^7Fight! ^1<<");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"deserteagle_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player) && isDefined(player))
            wait 1;
    }
}

shotgun_room()
{
    level.shotgun = getent("tnt_shotgun_trig","targetname");
    jump = getent("shotgun_jump","targetname");
    acti = getent("shotgun_acti","targetname");

    level.shotgun sethintstring("Press [^2&&1^7] to choose ^5Shotgun ^7Endroom");

    while(1)
    {
        level.shotgun waittill("trigger",player);

        if(!isdefined(level.shotgun))
            return; 

        if(isdefined(level.activ))
        {
            player room_setup(jump,"winchester1200_mp",undefined,"yes",1);
            level.activ room_setup(acti,"winchester1200_mp",undefined,"yes",1);

            noti = SpawnStruct();
            noti.titleText = "Shotgun Room";
            noti.notifyText = "^7"+level.activ.name+" ^1vs ^7"+player.name;
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
            wait 5;

            player iPrintLnBold("^1>> ^7Fight! ^1<<");
            level.activ iPrintLnBold("^1>> ^7Fight! ^1<<");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"winchester1200_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player) && isDefined(player))
            wait 1;
    }
}

knife_room()
{
    level.knife = getent("tnt_knife_trig","targetname");
    jump = getent("deagle_jump","targetname");
    acti = getent("deagle_acti","targetname");

    level.knife sethintstring("Press [^2&&1^7] to choose ^5Knife ^7Endroom");

    while(1)
    {
        level.knife waittill("trigger",player);

        if(!isdefined(level.knife))
            return; 

        if(isdefined(level.activ))
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            level.activ room_setup(acti,"knife_mp",undefined,"yes",1);

            noti = SpawnStruct();
            noti.titleText = "Knife Room";
            noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (1, 0, 1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
            wait 5;

            player iPrintLnBold("^1>> ^7Fight! ^1<<");
            level.activ iPrintLnBold("^1>> ^7Fight! ^1<<");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player) && isDefined(player))
            wait 1;
    }
}

bounce_room()
{
    level.bounce = getent("tnt_bounce_trig","targetname");
    jump = getent("bounce_jump","targetname");
    acti = getent("bounce_acti","targetname");

    level.bounce sethintstring("Press [^2&&1^7] to choose ^5Bounce ^7Endroom");

    while(1)
    {
        level.bounce waittill("trigger",player);

        if(!isdefined(level.bounce))
            return; 

        if(isdefined(level.activ))
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            level.activ room_setup(acti,"knife_mp",undefined,"yes",1);

            noti = SpawnStruct();
            noti.titleText = "Bouce Room";
            noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (0.4, 0.4, 1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
            wait 5;

            player iPrintLnBold("^1>> ^7Fight! ^1<<");
            level.activ iPrintLnBold("^1>> ^7Fight! ^1<<");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player) && isDefined(player))
            wait 1;
    }
}

sniper_fail()
{
    trig = getent("tnt_sniper_fail","targetname");
    acti = getent("sniper_acti","targetname");
    jump = getent("sniper_jump","targetname");
    for(;;)
    {
        trig waittill("trigger",who);
        if(who.pers["team"] != "spectator")
        {
            if(who.pers["team"] == "allies")
            {
                who setorigin(jump.origin);
                who setplayerangles(jump.angles);
            }
            else 
            {
                who setorigin(acti.origin);
                who setplayerangles(acti.angles);
            }
        }
    }
}

bounce_fail()
{
    trig = getent("tnt_bounce_fail","targetname");
    acti = getent("bounce_acti","targetname");
    jump = getent("bounce_jump","targetname");
    for(;;)
    {
        trig waittill("trigger",who);
        if(who.pers["team"] != "spectator")
        {
            if(who.pers["team"] == "allies")
            {
                who setorigin(jump.origin);
                who setplayerangles(jump.angles);
            }
            else 
            {
                who setorigin(acti.origin);
                who setplayerangles(acti.angles);
            }
        }
    }
}

bounce_jump_weapon()
{
	trig = getent("bounce_jump_weap","targetname");
	logo = getent("bounce_jump_logo","targetname");

	playfx(level.tnt_red_light,(3568,288,-1000));

	for(;;)
	{
		trig sethintstring("Press [^2&&1^7] to equip ^5M40A3");
		trig waittill("trigger",who);

		who giveweapon("m40a3_mp");
		who switchtoweapon("m40a3_mp");
		who givemaxammo("m40a3_mp");

		trig sethintstring("... ^1pending^7 ...");
		wait 5;
	}
}

bounce_acti_weapon()
{
	trig = getent("bounce_acti_weap","targetname");
	logo = getent("bounce_acti_logo","targetname");

	playfx(level.tnt_red_light,(2464,-1824,-1000));

	for(;;)
	{
		trig sethintstring("Press [^2&&1^7] to equip ^5M40A3");
		trig waittill("trigger",who);

		who giveweapon("m40a3_mp");
		who switchtoweapon("m40a3_mp");
		who givemaxammo("m40a3_mp");

		trig sethintstring("... ^1pending^7 ...");
		wait 5;
	}
}

room_setup(targ,weap,weap2,health,freeze)
{
    self setorigin(targ.origin);
    self setplayerangles(targ.angles);

    self takeallweapons();
    self giveweapon(weap);
    self switchtoweapon(weap);
    self givemaxammo(weap);

    if(isdefined(weap2))
    {
        self giveweapon(weap2);
        self givemaxammo(weap2);
    }

    self freezecontrols(freeze);

    if( health == "yes")
    {
        if(self.health < self.maxhealth)
            self.health=self.maxhealth;
    }
}

tnt_secret()
{
    thread tnt_secret_open();
	thread tnt_secret_enter();
	thread tnt_secret_exit();
}

tnt_secret_open()
{
	logo = getent("tnt_secret_logo","targetname");

    wait 0.1;
	rot_logo = spawn("script_model",logo.origin);
	rot_logo setmodel("vistic_logo");
	rot_logo movez(-240,0.1);
	rot_logo thread rotate_logo();
}

rotate_logo()
{
	while(isdefined(self))
	{
		self rotateyaw(360,8);
		wait 8;
	}
}

tnt_secret_enter()
{
	trig = getent("tnt_secret_enter","targetname");
	targ = getent("tnt_secret_enter_targ","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player thread tnt_secret_tp(targ);
	}
}

tnt_secret_exit()
{
	trig = getent("tnt_secret_end","targetname");
	targ = getent("tnt_secret_endorigin","targetname");


	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr\api\_speedrun::finishWay("secret_0");
		player thread tnt_secret_tp(targ);
	}
}

tnt_secret_tp(orig)
{
	self freezecontrols(1);
	self setorigin(orig.origin);
	self setplayerangles(orig.angles);
	wait 0.05;
	self freezecontrols(0);
}