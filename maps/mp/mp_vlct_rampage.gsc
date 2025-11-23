//Map and Script by Seven
//Nothing that great in here, i found everything online tbh
//Death check the bottom - I knew you would be here :)


main() {
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");
	//setdvar("g_speed" ,"210");
    //setdvar("dr_jumpers_speed" ,"1.12");
	// setdvar("r_specular", "0");
	setdvar("r_specularcolorscale", "1");

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_map::createSpawn((16, 0, 1052), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;^2Flow Secret");

	thread sr_easy_sec_enter();
	thread sr_hard_sec_enter();
	thread sr_flow_sec_enter();

	//thread sign1();
	//thread teleport_secret();
	thread teleport_secretrespawn();
	thread teleport_secretrespawn2();
	thread teleport_secretend();
	//thread teleport_secret_entry();
	//thread teleport_hardsec();
	//thread teleport_flowentry();
	thread teleport_hardsecend();
	thread teleport_flowend();
	thread teleport_flowrespawn();
	thread sc1();
	thread sc2();
	thread sc3();
	thread sc4();
	thread secret_fail1();
	thread secret_fail2();
	//thread sniperroom();
	//thread sniperfail1();
	//thread sniperfail2();
	//thread music();

	precacheitem("iw8_butterflyknife_mp");
}

sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(214.291, 199.706, 992.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secretrespawn_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player.sc_pos = 0;
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(16.094, -183.846, 992.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("hardsec_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player.sc_pos = 0;
	    player.checkpointid = 0;
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sr_flow_sec_enter()
{
	trig = spawn("trigger_radius",(10.3813, 186.868, 992.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("flow_origin","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_2");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player.sc_pos = 0;
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

onPlayerSpawn()
{
    self endon("disconnect");

    while(1)
    {
        self waittill("spawned_player");
        self setclientdvar("r_specular",1);
        self setclientdvar("fx_enable",1);
        self setclientdvar("fx_draw",1);
        self setclientdvar("cg_errordecay",0);
        self setclientdvar("r_glowbloomintensity0",1);
        self setclientdvar("r_glowbloomintensity1",1);
        self setclientdvar("r_glowskybleedintensity0",1);
        self setclientdvar("r_specularcolorscale",5);
        self setclientdvar("sm_sunSampleSizeNear",3);
        wait 0.05;
    }

}
secret_timer()
{
	self endon("secret_done");
	self endon("death");
	self endon("round_ended");
	self thread destroyOnDeath();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer = newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
	self.secretTimer.vertAlign = "bottom";
	self.secretTimer.x = 0;
	self.secretTimer.y = -7;
	self.secretTimer.sort = 5;
	self.secretTimer.fontScale = 1.4;
	self.secretTimer.font = "default";
	self.secretTimer.glowAlpha = 0;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"^0Time left: ^5&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor = level.randomcolor;
	else
	self.secretTimer.glowColor = (1,0,0);

	time = 60;
	for(i=0;i<time;i++)
		{
			self.secretTimer setvalue(time-i);
			wait 1;
		}
		self.secretTimer setvalue(0);
		self suicide();

		if(isdefined(self.secretTimer))
		self.secretTimer destroy();
}
secret_timer2()
{
	self endon("secret_done");
	self endon("death");
	self endon("round_ended");
	self thread destroyOnDeath();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer = newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
	self.secretTimer.vertAlign = "bottom";
	self.secretTimer.x = 0;
	self.secretTimer.y = -7;
	self.secretTimer.sort = 5;
	self.secretTimer.fontScale = 1.4;
	self.secretTimer.font = "default";
	self.secretTimer.glowAlpha = 0;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"^0Time left: ^5&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor = level.randomcolor;
	else
	self.secretTimer.glowColor = (1,0,0);

	time = 160;
	for(i=0;i<time;i++)
		{
			self.secretTimer setvalue(time-i);
			wait 1;
		}
		self.secretTimer setvalue(0);
		self suicide();

		if(isdefined(self.secretTimer))
		self.secretTimer destroy();
}
destroyOnDeath()
{

	self waittill("death");

	if(isDefined(self.secretTimer))

	self.secretTimer destroy();
}
sign1()
{
   vlct = getent("logo_velocity","targetname");

	for(;;)
   {
   wait 0.1;
   vlct rotateYaw (360,6);
   wait 0.1;
   }

}
teleport_secret()
{
   trig = getent("secret_teleport", "targetname");
   tele1 = getEnt("secretrespawn_origin", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
     player thread secret_timer();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player iPrintLn("^5" + player.name + " is ^6sick af ^5and went WR way..");
	 player freezeControls(1);
	 wait 0.05;
	 player freezeControls(0);
    }
}
teleport_secretrespawn()
{
    trig = getEnt("secretrespawn", "targetname");
    tele1 = getEnt("secretrespawn_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
	    wait 0.05;
	    player freezeControls(0);
    }
}
teleport_secretrespawn2()
{
    trig = getEnt("secretrespawn2", "targetname");
    tele1 = getEnt("secretrespawn_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
		wait 0.05;
		player freezeControls(0);
    }
}
teleport_secretend()
{
    trig = getEnt("teleport_secretend", "targetname");
    tele1 = getEnt("secretend_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
teleport_secret_entry()
{
    trig = getEnt("secret_entry", "targetname");
    tele1 = getEnt("entry_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);
		player freezeControls(1);
		wait 0.05;
		player freezeControls(0);
    }
}
teleport_hardsec()
{
   trig = getent("hardsec_entry", "targetname");
   tele1 = getEnt("hardsec_origin", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
     player thread secret_timer2();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
	 player.checkpointid = 0;
     player iPrintLn("^5Good Luck ^0Nigga");
	 player freezeControls(1);
	 wait 0.05;
	 player freezeControls(0);
    }
}
teleport_hardsecend()
{
    trig = getEnt("hardsecend", "targetname");
    tele1 = getEnt("hardsecend_origin", "targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_1");
    }
}
teleport_flowentry()
{
   trig = getent("flow_entry", "targetname");
   tele1 = getEnt("flow_origin", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
     player thread secret_timer();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player iPrintLn("^5Good Luck ^0Nigga");
	 player freezeControls(1);
	 wait 0.05;
	 player freezeControls(0);
    }
}
teleport_flowrespawn()
{
   trig = getent("flow_respawn", "targetname");
   tele1 = getEnt("flow_origin", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
	 player freezeControls(1);
	 wait 0.05;
	 player freezeControls(0);
    }
}
teleport_flowend()
{
   trig = getent("flow_end", "targetname");
   tele1 = getEnt("secretend_origin", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player thread sr\api\_speedrun::finishWay("secret_2");
    }
}
sc1()
{
	trigger = getEnt("sc1","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 0)
		{
			player.checkpointid = 0;
		}
	}
}

sc2()
{
	trigger = getEnt("sc2","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 1)
		{
			player.checkpointid = 1;
			player iPrintln( "^5 Checkpoint reached" );
		}
	}
}

sc3()
{
	trigger = getEnt("sc3","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 2)
		{
			player.checkpointid = 2;
			player iPrintln( "^5 Checkpoint reached" );
		}
	}
}

sc4()
{
	trigger = getEnt("sc4","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 3)
		{
			player.checkpointid = 3;
			player iPrintln( "^5 Checkpoint reached - You're almost there!" );
		}
	}
}
secret_fail1()
{
	trigger = getEnt( "secret_fail1", "targetname" );
	dest = getEnt( "hardsec_origin", "targetname" );
	check1 = getEnt( "sc1_origin", "targetname" );
	check2 = getEnt( "sc2_origin", "targetname" );
	check3 = getEnt( "sc3_origin", "targetname" );


	while(1)
	{
		trigger waittill ( "trigger", player );
		if (isDefined(player.checkpointid))
		{
			if (player.checkpointid == 0)
			{
				player setOrigin( dest.origin );
				player setplayerangles( dest.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}
			if (player.checkpointid == 1)
			{
				player setOrigin( check1.origin );
				player setplayerangles( check1.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}
			if (player.checkpointid == 2)
			{
				player setOrigin( check2.origin );
				player setplayerangles( check2.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}
			if (player.checkpointid == 3)
			{
				player setOrigin( check3.origin );
				player setplayerangles( check3.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}

		}
	}
}
secret_fail2()
{
	trigger = getEnt( "secret_fail2", "targetname" );
	dest = getEnt( "hardsec_origin", "targetname" );
	check1 = getEnt( "sc1_origin", "targetname" );
	check2 = getEnt( "sc2_origin", "targetname" );
	check3 = getEnt( "sc3_origin", "targetname" );


	while(1)
	{
		trigger waittill ( "trigger", player );
		if (isDefined(player.checkpointid))
		{
			if (player.checkpointid == 0)
			{
				player setOrigin( dest.origin );
				player setplayerangles( dest.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}
			if (player.checkpointid == 1)
			{
				player setOrigin( check1.origin );
				player setplayerangles( check1.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}
			if (player.checkpointid == 2)
			{
				player setOrigin( check2.origin );
				player setplayerangles( check2.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}
			if (player.checkpointid == 3)
			{
				player setOrigin( check3.origin );
				player setplayerangles( check3.angles );
				player freezeControls(1);
				wait 0.05;
				player freezeControls(0);
			}

		}
	}
}
RoomCountDown(text, duration, extra)
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
    self.endTimerHUD = createHUD(0, 120, "center", "top", 1, "objective", 1.5);

    self freezeControls(1);
    wait extra;

    while (duration > 0)
    {
        self.endTimerHUD setText("^0" + duration);
        self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
        wait 1;
        duration--;
    }
    self.endTimerHUD setText(text);
    self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
    self freezeControls(0);
    wait 1;
    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
}
waitdead()
{
    activator = GetActivator();
    level.trigger_scope = getent("sniper_trig","targetname");
    level.trigger_scope thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    level.trigger_scope thread maps\mp\_utility::triggerOn();
}
GetActivator()
{
	players = getentarray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}

	return "Noactivator";
}

createHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 1;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
}

fightHUD(room, jumper, activ)
{
    self notify("newFhud");
    self endon("newFhud");

    if (!isDefined(room))
        room = "undefined";
    if (!isDefined(jumper))
        jumper = "undefined";
    else
        jumper = jumper.name;
    if (!isDefined(activ))
        activ = "undefined";
    else
        activ = activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^3" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^3" + jumper + " ^0VS^0 " + "^3" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}
sniperroom()
{
    level.trigger_scope = getEnt ("sniper_trig", "targetname");

    jumpersc = getEnt ("sniperjumper_origin", "targetname");
    actisc = getEnt ("sniperacti_origin", "targetname");

    for(;;)
    {
        level.trigger_scope setHintString ("^5Press ^0[&&1]^5 to enter Sniper Room");
        level.trigger_scope waittill ("trigger", player);

		activator = GetActivator();
        player thread waitdead();
        thread fightHUD("Sniper Room", player, activator);
		player thread RoomCountDown("^5Kill each other !", 3, 0);
        activator thread RoomCountDown("^5Kill each other !", 3, 0);
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);
        activator setOrigin (actisc.origin);
        activator setPlayerAngles (actisc.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("remington700_mp");
        activator giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        activator giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        activator giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        activator giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        activator switchToWeapon("m40a3_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;


        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " has died in ^0Sniper Room!");
    }
}
sniperfail1()
{
   trigb = getent("sniperactifail", "targetname");
   teleb = getent ("sniperactifail_origin", "targetname");

   for(;;)
    {
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

sniperfail2()
{
   triga = getent("sniperjumperfail", "targetname");
   telea = getent ("sniperjumperfail_origin", "targetname");

   for(;;)
    {
      triga waittill("trigger", player);
	  player setOrigin(telea.origin);
	  player setPlayerAngles (telea.angles);
    }
}
music()
{
    level.music = randomint(4);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
	        AmbientStop(2);
     AmbientPlay( "song1" );
     break;
      case 1:
	        AmbientStop(2);
     AmbientPlay( "song2" );
     break;
      case 2:
	        AmbientStop(2);
     AmbientPlay( "song3" );
     break;
      case 3:
	        AmbientStop(2);
     AmbientPlay( "song4" );
     break;
	}
}