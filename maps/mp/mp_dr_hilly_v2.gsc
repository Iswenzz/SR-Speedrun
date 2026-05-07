main()
{

	//level.fusrodah = loadfx( "fire/firelp_large_pm" );

	setDvar("bg_fallDamageMaxHeight","9999");
	setDvar("bg_fallDamageMinHeight","9998");

	thread sr\api\_map::createSpawn((-8, 612, 76), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((7661.76, 2575.93, 7.8534), 180,120, "normal_0");

	thread startwall();
	thread seconddoor();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	//thread weapon();
	//thread sniper();
	//thread knife();
	//thread addTestClients();
	//thread acti_tele1();
	//thread acti_tele2();
	//thread credit();

	addTriggerToList ("trap1_trig");
	addTriggerToList ("trap2_trig");
	addTriggerToList ("trap3_trig");
	addTriggerToList ("trap4_trig");
	addTriggerToList ("trap5_trig");
	addTriggerToList ("trap6_trig");

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


startwall()
{
	trig = getEnt("startdoor_trig","targetname");
	brush = getEnt("startdoor","targetname");

	brush delete();
}

seconddoor()
{
	trig = getEnt("seconddoor_trig","targetname");
	brush = getEnt("seconddoor","targetname");

	brush delete();
}

trap1()
{
	trig = getEnt("trap1_trig","targetname");
	door1 = getEnt("trap1_door1","targetname");
	brush = getEnt("trap1","targetname");
	hurt = getEnt("trap1_hurt","targetname");
	door2 = getEnt("trap1_door2","targetname");

	hurt enablelinkto();
	hurt linkto(brush);

	door1 moveZ (110,1);

	trig waittill("trigger");

}

trap2()
{
	trig = getEnt("trap2_trig","targetname");
	brush = getEnt("trap2","targetname");

	trig waittill("trigger");

}

trap3()
{
	trig = getEnt("trap3_trig","targetname");
	hurt = getEnt("trap3_hurt","targetname");
	brush = getEnt("trap3","targetname");

	hurt enablelinkto();
	hurt linkto(brush);

	trig waittill("trigger");

}

trap4()
{
	trig = getEnt("trap4_trig","targetname");
	brush = getEnt("trap4","targetname");
	hurt = getEnt("trap4_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(brush);

	trig waittill("trigger");

}

trap5()
{
	trig = getEnt("trap5_trig","targetname");
	brush = getEnt("trap5","targetname");

	trig waittill("trigger");

}

trap6()
{
	trig = getEnt("trap6_trig","targetname");
	hurt = getEnt("trap6_hurt","targetname");
	brush = getEnt("trap6","targetname");
	fx_origin = getEnt("fx_fusrodah","targetname");

	hurt enablelinkto();
	hurt linkto(brush);

	trig waittill("trigger", player);

}

weapon()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	gravity_trig = getEnt ("gravity_trig", "targetname");
	gravityj = getEnt ("gravityj", "targetname");
	sniper = getEnt("sniperoom","targetname");
	knife = getEnt("knife","targetname");

	gravity_trig waittill ("trigger", player);
	thread weapon_acti();

	sniper delete();
	knife delete();

	iprintlnbold (player.name + " has gone in the low gravity room!");

	player FreezeControls (1);
	player SetOrigin(gravityj.origin);
	player SetPlayerAngles( gravityj.angles );

	player TakeAllWeapons();
	player GiveWeapon("deserteagle_mp");
	wait 0.05;
	player SwitchToWeapon("deserteagle_mp");
	wait 2;
	player FreezeControls (0);

	player thread onDeath_weapon();
	wait 0.1;


    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_weapon()
{
	self endon("disconnect");

	self waittill("death");
	thread weapon();
}

weapon_acti()
{
	gravityacti = getEnt ("gravityacti", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(gravityacti.origin);
			players[i] SetPlayerAngles( gravityacti.angles );

			players[i] TakeAllWeapons();
			players[i] GiveWeapon("deserteagle_mp");
			wait 0.05;
			players[i] SwitchToWeapon("deserteagle_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

sniper()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	snipertrig = getEnt ("sniperoom", "targetname");
	sniperj = getEnt ("sniperj", "targetname");
	gravitytrig = getEnt("gravity_trig","targetname");
	knife = getEnt("knife","targetname");

	snipertrig waittill ("trigger", player);
	thread sniper_acti();

	gravitytrig delete();
	knife delete();

	iprintlnbold (player.name + " has gone in the sniper room!!");

	player FreezeControls (1);
	player SetOrigin(sniperj.origin);
	player SetPlayerAngles( sniperj.angles );

	player TakeAllWeapons();
	player GiveWeapon("m40a3_mp");
	wait 0.05;
	player SwitchToWeapon("m40a3_mp");
	wait 2;
	player FreezeControls (0);

	player thread onDeath_sniper();
	wait 0.1;


    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_sniper()
{
	self endon("disconnect");

	self waittill("death");
	thread sniper();
}

sniper_acti()
{
	sniperacti = getEnt ("sniperacti", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(sniperacti.origin);
			players[i] SetPlayerAngles( sniperacti.angles );

			players[i] TakeAllWeapons();
			players[i] GiveWeapon("m40a3_mp");
			wait 0.05;
			players[i] SwitchToWeapon("m40a3_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

knife()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	knife = getEnt ("knife", "targetname");
	knifej = getEnt ("knife_jumper", "targetname");
	gravitytrig = getEnt("gravity_trig","targetname");
	snipertrig = getEnt("sniperoom","targetname");

	knife waittill ("trigger", player);
	thread knife_acti();

	gravitytrig delete();
	snipertrig delete();

	iprintlnbold (player.name + " has gone in the knife room!!");

	player FreezeControls (1);
	player SetOrigin(knifej.origin);
	player SetPlayerAngles( knifej.angles );

	player TakeAllWeapons();
	player GiveWeapon("tomahawk_mp");
	wait 0.05;
	player SwitchToWeapon("tomahawk_mp");
	wait 2;
	player FreezeControls (0);

	player thread onDeath_knife();
	wait 0.1;


    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_knife()
{
	self endon("disconnect");

	self waittill("death");
	thread knife();
}

knife_acti()
{
	knife_acti = getEnt ("knife_acti", "targetname");


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (1);
			players[i] SetOrigin(knife_acti.origin);
			players[i] SetPlayerAngles( knife_acti.angles );

			players[i] TakeAllWeapons();
			players[i] GiveWeapon("tomahawk_mp");
			wait 0.05;
			players[i] SwitchToWeapon("tomahawk_mp");
			wait 2;
			players[i] FreezeControls (0);
		}
	}
}

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

acti_tele1()
{
	target = getEnt ("acti_tele1_target","targetname");
	trig = getEnt ("acti_tele1", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player iprintlnbold ("Teleport Successful.");
		player SetOrigin(target.origin);
	}
}

acti_tele2()
{
	target = getEnt ("acti_tele2_target","targetname");
	trig = getEnt ("acti_tele2", "targetname");

	for(;;)
	{
		trig waittill ("trigger", player);

		player iprintlnbold ("Teleport Successful.");
		player SetOrigin(target.origin);
	}
}

credit()
{
	wait 20;

	{
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.font = "objective";
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (1,0,0);
		hud_clock.label = &"Go to www.afterlifegaming.net";
		hud_clock SetPulseFX( 40, 5400, 200 );
		wait 6;
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.font = "objective";
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (2,0,0);
		hud_clock.label = &"Map and scripts made by iMtroll";
		hud_clock SetPulseFX( 40, 5400, 200 );
		wait 6;
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.font = "objective";
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (2,0,0);
		hud_clock.label = &"Amazing detail and restructure by JWofles <3 Thank you :*";
		hud_clock SetPulseFX( 40, 5400, 200 );
	}
}