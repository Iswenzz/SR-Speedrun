main()
{
    maps\mp\_load::main(); 

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

	thread sr\api\_speedrun::createNormalWays("Easy Way;Hard Way;");
    thread sr\api\_map::createSpawn((224, 2816, 68), 90);
	thread sr\api\_speedrun::createTeleporter((65.1917, 2816.14, 8.125), 60, 100, (-1905,2812, -4), 180, "freeze", "yellow", "normal_1");


    //level.bworld = [];
    //level.bworld["red_light"] = loadfx("vistic/red_light");
    //level.bworld["explosion"] = loadfx("vistic/explosion");
    //level.bworld["room_choice"] = loadfx("vistic/bw_roomchoice");
    //level.bworld["vistic"] = loadfx("vistic/vc_fire");

	if(!isdefined(level.hidden_music))
		level.hidden_music = false;

	level.juggermode_guns = [];

	level.juggermode_guns[0] = "ak74u_mp";
	level.juggermode_guns[1] = "artillery_mp";
	level.juggermode_guns[2] = "ak47_mp";
	level.juggermode_guns[3] = "winchester1200_mp";
	level.juggermode_guns[4] = "uzi_mp";
	level.juggermode_guns[5] = "remington700_mp";

    VisionSetNaked("armada_ground");
    setdvar("r_specularcolorscale", "1");
    setdvar("r_drawDecals", "1");
    setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998");

	precachemodel("com_laptop_open_obj");
	precachemodel("com_laptop_open");
	precachemodel("playermodel_mw3_juggernaut");
	precachemodel("viewhands_mw3_jugger_ally");

	precacheitem("artillery_mp");
	precacheitem("m27_mp");
	precacheitem("ak74u_mp");
    precacheitem("ak47_mp");
    precacheitem("winchester1200_mp");
    precacheitem("uzi_mp");
    precacheitem("remington700_mp");
	precacheitem("smoke_grenade_mp");

    precacheshader("juggernaut_overlay");

    thread startdoor();
    //thread hidden_music();
    //thread hard_unlock();
    //thread jugger_box();
    //thread jugger_mode();

    //thread traps();
	thread trap6_mover();
    //thread end_rooms();
    //thread whatisthiskindofthread();
}

startdoor()
{
	door = getent("startdoor","targetname");
	trig = getent("startdoor_trig","targetname");
	block_1 = getent("secret_door","targetname");

	block_1 notsolid();
	door delete();

}

hidden_music()
{
	trig = getent("hidden_music_trig","targetname");
	targ = getent("hidden_music","targetname");

	fx1 = getent("hidden_fx1","targetname");
	fx2 = getent("hidden_fx2","targetname");
	fx3 = getent("hidden_fx3","targetname");
	fx4 = getent("hidden_fx4","targetname");
	fx5 = getent("hidden_fx5","targetname");
	fx6 = getent("hidden_fx6","targetname");
	fx7 = getent("hidden_fx7","targetname");
	fx8 = getent("hidden_fx8","targetname");

	red_light1 = spawnfx(level.bworld["red_light"],fx1.origin);
	red_light2 = spawnfx(level.bworld["red_light"],fx2.origin);
	red_light3 = spawnfx(level.bworld["red_light"],fx3.origin);
	red_light4 = spawnfx(level.bworld["red_light"],fx4.origin);
	red_light5 = spawnfx(level.bworld["red_light"],fx5.origin);
	red_light6 = spawnfx(level.bworld["red_light"],fx6.origin);
	red_light7 = spawnfx(level.bworld["red_light"],fx7.origin);
	red_light8 = spawnfx(level.bworld["red_light"],fx8.origin);

	trig sethintstring("Press [^5&&1^7] to turn on ^1Power");
	trig waittill("trigger");
	trig delete();

	wait 1;

	triggerfx(red_light1);
	triggerfx(red_light2);

	wait 1;

	triggerfx(red_light3);
	triggerfx(red_light4);

	wait 1;

	triggerfx(red_light5);
	triggerfx(red_light6);

	wait 1;

	triggerfx(red_light7);
	triggerfx(red_light8);

	wait 1;

	targ notsolid();

	wait 1;

	foxnblade = getent("foxnblade_music","targetname");
	foxnblade sethintstring("^5?^7?^1?");
	foxnblade waittill("trigger");
	foxnblade delete();

	level.hidden_music = true;

	vc = randomint(6);
	if(vc == 0 || vc == 3 || vc == 5)
	{
		ambientstop();
		ambientplay("blade");
		iprintln("^1Now playing^7: ^5absent ^7x ^6Saint Purple ^7- SCHEINEN");
	}
	else
	{
		ambientstop();
		ambientplay("fox");
		iprintln("^1Now playing^7: ^5Fake Static ^6Noise ^7- TopicFall");
	}
}

hard_unlock()
{
	trig_h = getent("trig_h","targetname");
	trig_a = getent("trig_a","targetname");
	trig_r = getent("trig_r","targetname");
	trig_d = getent("trig_d","targetname");
	block = getent("hard_block","targetname");

	trig_h waittill("trigger");
	iprintln("^1H");
	trig_a waittill("trigger");
	iprintln("^1A");
	trig_r waittill("trigger");
	iprintln("^1R");
	trig_d waittill("trigger",who);
	iprintln("^1D");

	wait 2;
	playfx(level.bworld["explosion"],(256,2632,64));
	block delete();

	iprintlnbold("^5"+who.name+"^7 has unlocked the ^1Hard Way");
	thread hard_rope();
}

hard_rope()
{
    level.rope_trig = getEnt ("rope_hard", "targetname");
    rop1 = getEnt ("rope1_targ1", "targetname");
    rop2 = getEnt ("rope1_targ2", "targetname");
    rop3 = getEnt ("rope1_targ3", "targetname");

    for(;;)
    {
        level.rope_trig sethintstring("Press [^5&&1^7] to enter ^1Hard Way");
        level.rope_trig waittill ("trigger",who);
        who thread rope_over();
    }
}

rope_over()
{
	rope1 = getent("rope1","targetname");
	rope2 = getent("rope2","targetname");
	rope3 = getent("rope3","targetname");
	rope4 = getent("rope4","targetname");
	rope5 = getent("rope5","targetname");

	if(self istouching(level.rope_trig))
    {
        rope_hard = spawn("script_model",(5,7,1));
        rope_hard.origin = self.origin;
        rope_hard.angles = self.angles;
        
        self disableweapons();
        wait 0.5;

        self linkto(rope_hard);
        rope_hard moveto(rope1.origin, 2.5, 1, 1);
        wait 1;
        rope_hard moveto(rope2.origin, 2.5, 1, 1 );
        wait 1;
        rope_hard moveto(rope3.origin, 2.5, 1, 1 );
        wait 1;
        rope_hard moveto(rope4.origin, 2.5, 1, 1 );
        wait 1;
        rope_hard moveto(rope5.origin, 2.5, 1, 1 );
        wait 2.7;
        self unlink();
        wait 0.2;
        self EnableWeapons();
        wait 0.1;
    }
}

jugger_mode()
{
	trig = getent("trig_jugg","targetname");
	block = getent("jugger_block","targetname");

	use_obj = spawn("script_model",(-512,3664,92));
	use_obj.angles = (0,90,0);
	use_obj setmodel("com_laptop_open_obj");

	trig sethintstring("Press ^7[^5&&1^7] to activate ^1Juggernaut Round^7!");
	trig waittill("trigger",who);

	use_obj setmodel("com_laptop_open");

	if(who.pers["rank"] < 20 || who.pers["team"] == "allies")
	{
		trig delete();
		who iprintlnbold("^1You're not strong enough to handle the Armor");
	}
	else
	{
		visionSetNaked( "bw_night", 4 );
		iprintlnbold("^5"+who.name+"^7 turned into a ^1Juggernaut");
		who thread juggernaut_equip();

		thread close_rooms();

		p = getentarray("player","classname");
		for(i=0;i<p.size;i++)
		{
			if(isdefined(p[i]) && isalive(p[i]))
			{
				p[i] iprintlnbold("Take these ^5Weapons^7 to fight him!");
				p[i] thread give_jugger_guns();
			}
			wait .05;
		}
		thread watch_jugger_respawn();
		thread create_ammo_box1();
		thread create_ammo_box2();

		targ = getent("anti_leave_org","targetname");
		while(isdefined(block))
		{
			block waittill("trigger",who);
			if(who.pers["team"] == "axis")
			{
				who iprintlnbold("^1You cant leave the Activator Area!");
				who setorigin(targ.origin);
			}
		}
	}
}

create_ammo_box1()
{
	trig = getent("ammo_box1","targetname");
	level.ammo_box1 setmodel("com_bomb_objective");

	for(;;)
	{
		trig sethintstring("Press [^5&&1^7] to refill your ^1Ammo^7!");
		trig waittill("trigger",who);

		who playlocalsound("weap_pickup");
		who givemaxammo(who getcurrentweapon());

		wait 1;
	}
}

create_ammo_box2()
{
	trig = getent("ammo_box2","targetname");
	level.ammo_box2 setmodel("com_bomb_objective");

	for(;;)
	{
		trig sethintstring("Press [^5&&1^7] to refill your ^1Ammo^7!");
		trig waittill("trigger",who);

		who playlocalsound("weap_pickup");
		who givemaxammo(who getcurrentweapon());

		wait 1;
	}
}

jugger_box()
{
	box1 = getent("jugger_box1","targetname");
	box2 = getent("jugger_box2","targetname");

	precachemodel("com_bomb_objective_d");
	precachemodel("com_bomb_objective");

	level.ammo_box1 = spawn("script_model",box1.origin - (0,0,10));
	level.ammo_box2 = spawn("script_model",box2.origin - (0,0,10));

	level.ammo_box1.angles = (0,90,0);
	level.ammo_box2.angles = (0,90,0);

	level.ammo_box1 setmodel("com_bomb_objective_d");
	level.ammo_box2 setmodel("com_bomb_objective_d");
}

watch_jugger_respawn()
{
	for(;;)
	{
		level waittill("player_spawn",who);
		wait 0.5;
		who.jugger_gun = undefined;
		who thread give_jugger_guns();
	}
}

give_jugger_guns()
{
	if(!isdefined(self) || self.pers["team"] != "allies")
		return;

	self.jugger_gun = level.juggermode_guns[randomint(level.juggermode_guns.size)];

	self takeallweapons();
	self giveweapon(self.jugger_gun);
	self givemaxammo(self.jugger_gun);
	self giveweapon("usp_mp");
	self givemaxammo("usp_mp");
	self switchtoweapon(self.jugger_gun);
}

juggernaut_equip()
{
	if(self.pers["team"] != "axis")
		return;

	self.maxhealth = 600;
	self.health = self.maxhealth;

	self detachall();
	self setmodel("playermodel_mw3_juggernaut");
	self setviewmodel("viewhands_mw3_jugger_ally");

	self SetMoveSpeedScale(0.4);
    self TakeAllWeapons();
	self GiveWeapon("usp_mp");
    self GiveMaxAmmo("usp_mp");
    self GiveWeapon("m27_mp");
    self GiveMaxAmmo("m27_mp");
    self SwitchToWeapon("m27_mp");
	self GiveWeapon("smoke_grenade_mp");

	self.overlay = NewClientHudElem(self);
	self.overlay.horzalign = "fullscreen";
	self.overlay.vertalign = "fullscreen";
	self.overlay SetShader("juggernaut_overlay", 640 , 480);
	self waittill("round_ended");
	self.overlay Destroy();
}


traps()
{
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();

	addTriggerToList("trig_trap1");
    addTriggerToList("trig_trap2");
    addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
    addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");
}

addTriggerToList(name)
{
    if(!isdefined(level.trapTriggers))
      level.trapTriggers=[];

    level.trapTriggers[level.trapTriggers.size]=getent(name,"targetname");
}

trap1()
{
	trig = getent("trap1_trig","targetname");
	trap = getent("trap1","targetname");

	trig sethintstring("Press [^5&&1^7] to active ^1Trap 1");
	trig waittill("trigger",who);
	trig delete();

	if(who.pers["team"] == "allies")
		return;

	while(isdefined(trap))
	{
		trap rotatepitch(360,4);
		wait 6;
	}
}

trap2()
{
	trig = getent("trap2_trig","targetname");
	trapa = getent("trap2_a","targetname");
	trapb = getent("trap2_b","targetname");
	trapc = getent("trap2_c","targetname");

	hurta = getent("trap2_hurta","targetname");
	hurtb = getent("trap2_hurtb","targetname");
	hurtc = getent("trap2_hurtc","targetname");

	hurta enablelinkto();
	hurtb enablelinkto();
	hurtc enablelinkto();

	hurta linkto(trapa);
	hurtb linkto(trapb);
	hurtc linkto(trapc);

	trig sethintstring("Press [^5&&1^7] to active ^1Trap 2");
	trig waittill("trigger",who);
	trig delete();

	if(who.pers["team"] == "allies")
		return;

	while(isdefined(trapa) && isdefined(trapb) && isdefined(trapc))
	{
		trapa movez(130,2);
		wait 2;
		trapa movez(-130,2);
		trapb movez(130,2);
		wait 2;
		trapb movez(-130,2);
		trapc movez(130,2);
		wait 2;
		trapc movez(-130,2);
		wait 2;
	}
}

trap3()
{
	trig = getent("trap3_trig","targetname");
	trapa = getent("trap3_a","targetname");
	trapb = getent("trap3_b","targetname");

	trig sethintstring("Press [^5&&1^7] to active ^1Trap 3");
	trig waittill("trigger",who);
	trig delete();

	if(who.pers["team"] == "allies")
		return;

	vc = randomint(6);
	if(vc == 2 || vc == 5)
		trapa delete();
	else 
		trapb delete();
}

trap4()
{
	trig = getent("trap4_trig","targetname");
	trapa = getent("trap4_a","targetname");
	trapb = getent("trap4_b","targetname");
	trapc = getent("trap4_c","targetname");
	trapd = getent("trap4_d","targetname");

	trig sethintstring("Press [^5&&1^7] to active ^1Trap 4");
	trig waittill("trigger",who);
	trig delete();

	if(who.pers["team"] == "allies")
		return;

	vc = randomint(4);
	if(vc == 0)
	{
		trapb movez(-370,1);
		trapd movez(-370,1);
		wait 1;
		trapa thread do_trap4_rotate("+");
		trapc thread do_trap4_rotate("-");
	}
	else if(vc == 1)
	{
		trapb movez(-370,1);
		trapc movez(-370,1);
		wait 1;
		trapa thread do_trap4_rotate("+");
		trapd thread do_trap4_rotate("-");
	}
	else if(vc == 2)
	{
		trapa movez(-370,1);
		trapc movez(-370,1);
		wait 1;
		trapb thread do_trap4_rotate("+");
		trapd thread do_trap4_rotate("-");
	}
	else if(vc == 3)
	{
		trapa movez(-370,1);
		trapd movez(-370,1);
		wait 1;
		trapb thread do_trap4_rotate("+");
		trapc thread do_trap4_rotate("-");
	}
}

do_trap4_rotate(way)
{
	while(isdefined(self))
	{
		if(way == "+")
			self rotateyaw(360,2);
		else if(way == "-")
			self rotateyaw(-360,2);
		wait 2;
	}
}

trap5()
{
	trig = getent("trap5_trig","targetname");
	trapa = getent("trap5_a","targetname");
	trapb = getent("trap5_b","targetname");

	trig sethintstring("Press [^5&&1^7] to active ^1Trap 5");
	trig waittill("trigger",who);
	trig delete();

	if(who.pers["team"] == "allies")
		return;

	vc = randomint(6);
	if(vc == 2 || vc == 5)
		trapa delete();
	else 
		trapb delete();
}

trap6()
{
	trig = getent("trap6_trig","targetname");
	trap = getent("trap6","targetname");
	hurt = getent("trap6_hurt","targetname");

	thread trap6_mover();

	trap hide();
	hurt maps\mp\_utility::triggerOff();

	trig sethintstring("Press [^5&&1^7] to active ^1Trap 6");
	trig waittill("trigger",who);
	trig delete();

	if(who.pers["team"] == "allies")
		return;

	hurt maps\mp\_utility::triggerOn();
	trap show();
	wait .05;
	hurt enablelinkto();
	hurt linkto(trap);
	wait .05;

	trap movex(-688,2);
	wait 2;
	trap delete();
	hurt delete();
}

trap6_mover()
{
	mover = getent("mover_trap6","targetname");

	mover movey(200,0.1);
	wait 0.1;
	mover rotateYaw(90,0.1);
	
}

end_rooms()
{
	level.room_fx = [];
	level.room_fx1 = spawnfx(level.bworld["room_choice"],(-320,9792,72)); // Water Room
	level.room_fx2 = spawnfx(level.bworld["room_choice"],(-512,9792,72)); // Sniper Room
	level.room_fx3 = spawnfx(level.bworld["room_choice"],(-704,9792,72)); // Bounce Room

	level.sniper_block = getent("sniper_block","targetname");
	level.bounce_block = getent("bounce_block","targetname");
	level.water_block = getent("water_block","targetname");

	level.sniper_block notsolid();
	level.sniper_block hide();

	level.bounce_block notsolid();
	level.bounce_block hide();

	level.water_block notsolid();
	level.water_block hide();

	triggerfx(level.room_fx1);
	triggerfx(level.room_fx2);
	triggerfx(level.room_fx3);

	thread rotate_bounce();
	thread rotate_sniper();
	thread rotate_rpg();

	thread old_room();
	thread bounce_room();
	thread sniper_room();
	thread water_room();
}

close_rooms()
{
	level.sniper_block solid();
	level.sniper_block show();

	level.bounce_block solid();
	level.bounce_block show();

	level.water_block solid();
	level.water_block show();
}

rotate_bounce()
{
	brush = getent("bounce_room_brush","targetname");
	brush notsolid();

	while(isdefined(brush))
	{
		brush rotateyaw(360,8);
		wait 8;
	}
}

rotate_sniper()
{
	brush = getent("sniper_room_brush","targetname");

	while(isdefined(brush))
	{
		brush rotateyaw(360,8);
		wait 8;
	}
}

rotate_rpg()
{
	brush = getent("rpg_room_brush","targetname");

	while(isdefined(brush))
	{
		brush rotateyaw(360,8);
		wait 8;
	}
}

old_room()
{
	while(1){
	level.old_room = getent("old_trig","targetname");
	door = getent("old_door","targetname");

	level.old_room sethintstring("Press [^5&&1^7] to open ^1Old");
	
	
		
	level.old_room waittill("trigger",who);
		
	
	level.old_room delete();

	thread close_rooms();

	iprintlnbold("^5"+who.name+"^7 opened ^1Old");
	door movez(-150,3);
	wait 3;
	door delete();

	block = getent("jugger_block","targetname");
	targ = getent("anti_leave_org","targetname");
	while(isdefined(block))
	{
		block waittill("trigger",who);
		if(who.pers["team"] == "axis")
		{
			who iprintlnbold("^1You cant leave the Activator Area!");
			who setorigin(targ.origin);
		}
	}
}
}

sniper_room()
{
	level.sniper_room = getent("sniper_trig","targetname");
	acti = getent("sniper_acti","targetname");
    jump = getent("sniper_jump","targetname");

    while(1)
    {
        level.sniper_room sethintstring("Press [^5&&1^7] to open ^1Sniper");
        level.sniper_room waittill("trigger",player);

		


        if(!isdefined(level.sniper_room))
            return;

        level.sniper_room sethintstring("^1Wait your Turn.");

        if(!isdefined(level.bworld_room))
        {
            level.bworld_room=true;

            level.bounce_block solid();
			level.bounce_block show();

			level.water_block solid();
			level.water_block show();

			level.old_room delete();

			thread sniper_failer();
        }

        if(isdefined(level.activ))
        {
            player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);
            level.activ room_setup(acti,"remington700_mp","m40a3_mp","yes",1);
            wait 5;
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player)&&isDefined(player))
            wait 1;

        iprintlnbold("^5"+player.name+" ^7has been killed");
    }
}

sniper_failer()
{
    trig = getent("sniper_fail","targetname");
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


water_room()
{
	level.water_room = getent("water_trig","targetname");
	acti = getent("knife_acti","targetname");
    jump = getent("knife_jump","targetname");

    while(1)
    {
        level.water_room sethintstring("Press [^5&&1^7] to open ^1Knife");
        level.water_room waittill("trigger",player);

	

        if(!isdefined(level.water_room))
            return;

        level.water_room sethintstring("^1Wait your Turn.");

        if(!isdefined(level.bworld_room))
        {
            level.bworld_room=true;

            level.bounce_block solid();
			level.bounce_block show();

			level.sniper_block solid();
			level.sniper_block show();

			level.old_room delete();
        }

        if(isdefined(level.activ))
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            level.activ room_setup(acti,"knife_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player)&&isDefined(player))
            wait 1;

        iprintlnbold("^5"+player.name+" ^7has been killed");
    }
}

bounce_room()
{
	level.bounce_room = getent("bounce_trig","targetname");
	acti = getent("bounce_acti","targetname");
    jump = getent("bounce_jump","targetname");

    while(1)
    {
        level.bounce_room sethintstring("Press [^5&&1^7] to open ^1Bounce");
        level.bounce_room waittill("trigger",player);

	

        if(!isdefined(level.bounce_room))
            return;

        level.bounce_room sethintstring("^1Wait your Turn.");

        if(!isdefined(level.bworld_room))
        {
            level.bworld_room=true;

            level.water_block solid();
			level.water_block show();

			level.sniper_block solid();
			level.sniper_block show();

			level.old_room delete();

			thread bounce_failer();
			thread bounce_weap();
        }

        if(isdefined(level.activ))
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            level.activ room_setup(acti,"knife_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else 
        {
            player room_setup(jump,"knife_mp",undefined,"yes",1);
            wait 5;
            player freezecontrols(0);
        }

        while(isAlive(player)&&isDefined(player))
            wait 1;

        iprintlnbold("^5"+player.name+" ^7has been killed");
    }
}

bounce_failer()
{
    trig = getent("bounce_fail","targetname");
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

bounce_weap()
{
    trig = getent("bounce_weap","targetname");

    wait 1;
    playfx(level.bworld["room_choice"],(4656,8704,314));
    thread rotate_remington();

    for(;;)
    {
        trig sethintstring("Press [^5&&1^7] to get a ^1Remington 700");
        trig waittill("trigger",who);

        if(who hasweapon("remington700_mp"))
            who givemaxammo("remington700_mp");
        else
        {
        	who giveweapon("remington700_mp");
        	who switchtoweapon("remington700_mp");
        	who givemaxammo("remington700_mp");
        }

        trig sethintstring("Charging.");
        wait 3;
    }
}

rotate_remington()
{
	brush = getent("bounce_remington","targetname");

	while(isdefined(brush))
	{
		brush rotateyaw(360,8);
		wait 8;
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

whatisthiskindofthread()
{
	trig = getent("treasure_island","targetname");
	targ = getent("treasure_island_org","targetname");

	thread treasure_island_out();

	for(;;)
	{
		trig waittill("trigger",who);
		who thread youfoundsomething(targ);
	}
}

youfoundsomething(loc)
{
	if(!isdefined(self) || !isdefined(loc))
		return;

	self iprintlnbold("^5You've ^7found ^1Treasure Island");

	self setorigin(loc.origin);
	self setplayerangles(loc.angles);

	self iprintlnbold("Be ^5careful^7 you only got ^11 Chance");
}

treasure_island_out()
{
	trig = getent("treasure_island_reward","targetname");
	targ = getent("treasure_island_out","targetname");

	for(;;)
	{
		trig sethintstring("Press [^5&&1^7] for your ^1Reward");
		trig waittill("trigger",who);
		who thread reward_n_out(targ);
	}
}

reward_n_out(loc)
{
	if(!isdefined(self) || !isdefined(loc))
		return;

	if(self hasweapon("artillery_mp"))
		self givemaxammo("artillery_mp");
	else 
	{
		self giveweapon("artillery_mp");
		self switchtoweapon("artillery_mp");
		self givemaxammo("artillery_mp");
	}

	vc = randomint(3);
	switch(vc)
	{
		case 0:
			self iprintlnbold("^5Fox ^1& ^5Blade^7 granted you ^1500 XP");
			self braxi\_rank::giverankxp(undefined,500);
			break;
		case 1:
			self iprintlnbold("^5Fox ^1& ^5Blade^7 granted you ^11000 XP");
			self braxi\_rank::giverankxp(undefined,1000);
			break;
		case 2:
			self iprintlnbold("^5Fox ^1& ^5Blade^7 granted you ^1750 XP");
			self braxi\_rank::giverankxp(undefined,750);
			break;
	}

	self setorigin(loc.origin);
	self setplayerangles(loc.angles);
}