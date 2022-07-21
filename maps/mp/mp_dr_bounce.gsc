main()
{
thread sr\api\_map::createSpawnOrigin((-688, -2480, -319.875), 90);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");

	maps\mp\_load::main();

	trig = spawn("trigger_radius",(-706,6604,60),0,150,150);
	trig.radius = 150;
	trig.targetname = "endmap_trig";

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	PreCacheItem("deserteaglegold_mp");
	PreCacheItem("remington700_mp");
	PreCacheItem("winchester1200_grip_mp");

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1200");

	thread way_connect();
	thread king();
	// thread nothing();
	// thread messages();
	// thread hide_trigs();
	// thread show_trigs();
	// thread gun();
	thread first_door();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread trap15();
	// thread trap16();
	// thread trap17();
	// thread trap18();
	// thread trap19();
	// thread final();
	// thread jump4();
	// thread jump5();
	// thread jump6();
	// thread movers();
	// thread final();
	// thread games();
	// thread knife();
	// thread sniper();
	// thread shotgun();
	thread teleport();
	// thread xp();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Easy Way;");
    sr\api\_speedrun::createSecretWays("Hard Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

jump4()
{
	jumpx = getent ("jump4","targetname");
	glow = getent ("glow4","targetname");
	air1 = getent ("auto43","targetname");
	air2 = getent ("auto44","targetname");
	air3 = getent ("auto45","targetname");
	air4 = getent ("auto46","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, 1);
			wait 1;
			air moveto (air2.origin, 1);
			wait 1;
			air moveto (air3.origin, 1);
			wait 1;
			air moveto (air4.origin, 1);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

jump5()
{
	jumpx = getent ("jump5","targetname");
	glow = getent ("glow5","targetname");
	air1 = getent ("auto47","targetname");
	air2 = getent ("auto48","targetname");
	air3 = getent ("auto49","targetname");
	air4 = getent ("auto50","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, 1);
			wait 1;
			air moveto (air2.origin, 1);
			wait 1;
			air moveto (air3.origin, 1);
			wait 1;
			air moveto (air4.origin, 1);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

jump6()
{
	jumpx = getent ("jump6","targetname");
	glow = getent ("glow6","targetname");
	air1 = getent ("auto54","targetname");
	air2 = getent ("auto51","targetname");
	air3 = getent ("auto52","targetname");
	air4 = getent ("auto53","targetname");

	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, 1);
			wait 1;
			air moveto (air2.origin, 1);
			wait 1;
			air moveto (air3.origin, 1);
			wait 1;
			air moveto (air4.origin, 1);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

teleport()
{
	entTransporter = getentarray( "enter", "targetname" );

	level waittill("round_started");

	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
		{
			entTransporter[i] thread transporter(i);
			// if(i == 4)
			// {
			// 	thread sr\api\_map::createTriggerFx(entTransporter[4], "secret");
			// }
		}
	}
}

transporter(i)
{
	while(true)
	{
		self waittill( "trigger", player );

		// iprintlnbold(i);
		// iprintlnbold(self.target);

		// if(!isDefined(player.secret_1_endtrig) && self.target == "auto19")
		// {
		// 	player.secret_1_endtrig = true;

player thread sr\api\_speedrun::finishWay("secret_0");
		// }

		if(self.target == "auto16")
			player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste

		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

king()
{

	king = getEnt("king_rotate","targetname");
	games = getEnt("games_panel","targetname");
	while(1)
	{
		king RotateYaw(360,5);
		games RotateYaw(360,5);
		wait 5;
	}

}

nothing()
{

	wait 0.5;
	hide_trigs();

}

hide_trigs()
{

	switches = getentarray ("gold_take","targetname");

	for(i=0; i<switches.size; i++) switches[i] maps\mp\_utility::triggerOff();

}

show_trigs()
{

	switches = getentarray ("gold_take","targetname");

	for(i=0; i<switches.size; i++) switches[i] maps\mp\_utility::triggerOn();

}

messages()
{
    while(1)
	{
		wait 10;
		iprintlnbold ("^3Map created by ^2[BSF]Punk");
		wait 10;
		iprintlnbold ("^3Exclusively made for ^2LukServers");
		wait 10;
		iprintlnbold ("^1luk-servers.com:28967");
		wait 20;
		iprintlnbold ("^3Visit ^2luk-servers.com");
		wait 110;
    }
}

first_door()
{
	trig = getEnt("first_door_trig","targetname");
	brush = getEnt("first_door","targetname");
	button = getEnt("button_door","targetname");
	trig delete();
	brush delete();
	button delete();
}

gun()
{

	trig = getEnt("gun","targetname");
	button = getEnt("gun_button","targetname");
	gun = getEnt("auto5","targetname");

	trig waittill("trigger", user);
	trig delete();

	button delete();
	gun moveZ(14,4);
	wait 4;
	show_trigs();
	thread take_gun();

}

take_gun()
{

	trig = getEnt("gold_take","targetname");
	gun = getEnt("auto5","targetname");
	block = getEnt("block_gun","targetname");

	trig waittill("trigger", user);
	trig delete();
	gun delete();
	user GiveWeapon("deserteaglegold_mp");
	user GiveMaxAmmo("deserteaglegold_mp");
	wait 0.01;
	user SwitchToWeapon("deserteaglegold_mp");
	block moveZ(54,0.5);
	wait 0.5;
	iprintlnbold("^3Activator ^7got his ^3Gold Eagle!!!");

}

trap1()
{

	trig = getEnt("trigger1","targetname");
	left = getEnt("trap1_left","targetname");
	center = getEnt("trap1_center","targetname");
	right = getEnt("trap1_right","targetname");

	trig waittill("trigger", user);
	trig delete();

	left moveZ(100,1);
	center moveZ(100,1);
	right moveZ(100,1);
	wait 3;
	left moveZ(-100,1);
	center moveZ(-100,1);
	right moveZ(-100,1);

}

trap2()
{

	trig = getEnt("trigger2","targetname");
	left = getEnt("trap2_1","targetname");
	center = getEnt("trap2_2","targetname");
	right = getEnt("trap2_3","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	left delete();
				right delete();
				break;
		case 1:	center delete();
				break;
	}
}

trap3()
{

	trig = getEnt("trigger3","targetname");
	trap = getEnt("trap3","targetname");
	lift = getEnt("trap3_2","targetname");

	trig waittill("trigger");
	trig delete();

	trap moveX(416,1);
	lift moveX(-310,1);

}

trap4()
{

	trig = getEnt("trigger4","targetname");
	main = getEnt("trap4_main","targetname");
	sec = getEnt("trap4_sec","targetname");
	spikes1 = getEnt("trap5_1","targetname");
	spikes2 = getEnt("trap5_2","targetname");
	spikes3 = getEnt("trap5_3","targetname");
	trap = getEnt("trap5_4","targetname");
	hurt1 = getEnt("spikes1_hurt","targetname");
	hurt2 = getEnt("spikes2_hurt","targetname");
	hurt3 = getEnt("spikes3_hurt","targetname");
	part = getEnt("part","targetname");

	hurt1 enablelinkto();
	hurt1 linkto(spikes1);

	hurt2 enablelinkto();
	hurt2 linkto(spikes2);

	hurt3 enablelinkto();
	hurt3 linkto(spikes3);

	trig waittill("trigger");
	trig delete();

	main moveZ(304,1);
	sec moveZ(304,1);
	wait 1;
	main moveX(-128,1);
	sec moveX(128,1);
	wait 1;
	main RotateYaw(180,1);
	sec RotateYaw(180,1);
	wait 1;
	spikes1 moveZ(304,1);
	spikes2 moveZ(304,1);
	spikes3 moveZ(304,1);
	trap moveZ(256,1);
	part moveZ(304,1);

}

trap5()
{

	trig = getEnt("trigger5","targetname");
	spikes1 = getEnt("trap5_1","targetname");
	spikes2 = getEnt("trap5_2","targetname");
	spikes3 = getEnt("trap5_3","targetname");
	trap = getEnt("trap5_4","targetname");

	trig waittill("trigger");
	trig delete();

	spikes1 RotatePitch(180,2);
	spikes2 RotatePitch(180,2);
	spikes3 RotatePitch(180,2);
	wait 5;
	spikes1 RotatePitch(-180,2);
	spikes2 RotatePitch(-180,2);
	spikes3 RotatePitch(-180,2);
	wait 3;
	trap moveX(192,2);
	wait 2;
	trap moveX(-192,2);

}

trap6()
{
	trig = getEnt("trigger6","targetname");
	trap = getEnt("trap6","targetname");
	blocks = getEnt("trap6_blocks","targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap RotatePitch(360,2);
		wait 5;
	}
}

trap7()
{

	trig = getEnt("trigger7","targetname");
	trap = getEnt("trap7","targetname");
	hurt = getEnt("trap7_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(trap);

	trig waittill("trigger", user);
	trig delete();

	while(1)
	{
		trap RotatePitch(180,5);
		wait 5;
	}
}

movers()
{

	mover1 = getEnt("mover1","targetname");
	mover2 = getEnt("mover2","targetname");

	while(1)
	{
		mover1 moveY(704,3);
		mover2 moveY(-704,3);
		wait 5;
		mover1 moveY(-704,3);
		mover2 moveY(704,3);
		wait 5;
	}
}

trap8()
{

	trig = getEnt("trigger8","targetname");
	spikes = getEnt("trap8_spikes","targetname");
	hurt = getEnt("trap8_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(spikes);

	trig waittill("trigger");
	trig delete();

	spikes moveZ(228,2);
	wait 4;
	spikes moveZ(-300,2);
	spikes waittill("movedone");
	spikes delete();

}

trap9()
{

	trig = getEnt("trigger9","targetname");
	trap_1 = getEnt("trap9_1","targetname");
	trap_2 = getEnt("trap9_2","targetname");

	trig waittill("trigger");
	trig delete();

	trap_1 moveX(-448,1);
	wait 2;
	trap_1 moveX(448,1);
	wait 2;
	trap_2 moveX(-384,1);

}

trap10()
{

	trig = getEnt("trigger10","targetname");
	brush = getEnt("trap10","targetname");

	trig waittill("trigger");
	trig delete();

	brush moveX(256,1);
	wait 2;
	brush moveX(-256,1);

}

trap11()
{

	trig = getEnt("trigger11","targetname");
	spikes1 = getEnt("trap11_1","targetname");
	spikes2 = getEnt("trap11_2","targetname");
	spikes3 = getEnt("trap11_3","targetname");
	spikes4 = getEnt("trap11_4","targetname");
	hurt1 = getEnt("trap11_1_h","targetname");
	hurt2 = getEnt("trap11_2_h","targetname");
	hurt3 = getEnt("trap11_3_h","targetname");
	hurt4 = getEnt("trap11_4_h","targetname");

	hurt1 enablelinkto();
	hurt1 linkto(spikes1);

	hurt2 enablelinkto();
	hurt2 linkto(spikes2);

	hurt3 enablelinkto();
	hurt3 linkto(spikes3);

	hurt4 enablelinkto();
	hurt4 linkto(spikes4);

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	spikes1 moveZ(32,1);
				spikes4 moveZ(32,1);
				break;
		case 1:	spikes2 moveZ(32,1);
				spikes3 moveZ(32,1);
				break;
	}
}

trap12()
{

	trig = getEnt("trigger12","targetname");
	gone = getEnt("gone","targetname");
	gone2 = getEnt("gone2","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	gone notsolid();
				break;
		case 1:	gone2 notsolid();
				break;
	}
}

trap13()
{

	trig = getEnt("trigger13","targetname");
	trap = getEnt("trap13","targetname");

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap RotatePitch(360,6);
		wait 10;
	}
}

trap14()
{

	trig = getEnt("trigger14","targetname");
	brush = getEnt("trap14_1","targetname");
	brush2 = getEnt("trap14_2","targetname");
	brush3 = getEnt("trap14_3","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	brush2 delete();
				break;
		case 1:	brush delete();
				brush3 delete();
				break;
	}
}

trap15()
{

	trig = getEnt("trigger15","targetname");
	brush = getEnt("rotate_this_bitch","targetname");
	hurt = getEnt("trap15_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(brush);

	trig waittill("trigger");
	trig delete();

	while(1)
	{
		brush RotatePitch(180,3);
		wait 3;
	}
}

trap16()
{

	trig = getEnt("trigger16","targetname");
	brush = getEnt("circle_spikes1","targetname");
	brush2 = getEnt("circle_spikes2","targetname");
	brush3 = getEnt("circle_spikes3","targetname");
	hurt = getEnt("circle_spikes1_hurt","targetname");
	hurt2 = getEnt("circle_spikes2_hurt","targetname");
	hurt3 = getEnt("circle_spikes3_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(brush);

	hurt2 enablelinkto();
	hurt2 linkto(brush2);

	hurt3 enablelinkto();
	hurt3 linkto(brush3);

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	brush2 moveZ(88,1);
				break;
		case 1:	brush moveZ(88,1);
				brush3 moveZ(88,1);
				break;
	}
}

trap17()
{

	trig = getEnt("trigger17","targetname");
	brush = getEnt("trap17_1","targetname");
	brush2 = getEnt("trap17_2","targetname");

	trig waittill("trigger");
	trig delete();

	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	brush2 delete();
				break;
		case 1:	brush delete();
				break;
	}
}

trap18()
{

	trig = getEnt("trigger18","targetname");
	trap = getEnt("trap18","targetname");

	trig waittill("trigger");
	trig delete();

	trap moveX(880,1);
	trap waittill("movedone");
	trap delete();

}

trap19()
{

	trig = getEnt("trigger19","targetname");
	brush = getEnt("trap19","targetname");

	trig waittill("trigger");
	trig delete();

	brush moveZ(368,0.5);
	wait 3;
	brush moveZ(-368,3);

}

final()
{

	trig = getEnt("final_door_trig","targetname");
	brush = getEnt("final_door","targetname");
	games = getEnt("games","targetname");

	trig waittill("trigger", player);
	trig delete();
	games delete();

	brush moveZ(-128,2);
	brush waittill("movedone");
	brush delete();
	iprintlnbold("^3" + player.name +"^7 decided to go the old way");

	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "allies" )
			{
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("deserteaglegold_mp");
			players[i] GiveMaxAmmo("deserteaglegold_mp");
			wait 0.01;
			players[i] SwitchToWeapon("deserteaglegold_mp");
			}
		}
		return;
	}
}

games()
{
	trig = getEnt("games", "targetname");
	old = getEnt("final_door_trig","targetname");
	while (1)
	{
		if(isDefined(old))
			old delete();
		trig waittill("trigger", player);
		player SetOrigin((-704, 6464, -800));
		player SetPlayerAngles((0,90,0));
		player TakeAllWeapons();
		player AllowSprint(false);
		player onDeath();
		wait 0.1;
	}
}

sniper()
{
	trig = getEnt("sniper","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		iprintlnbold("^3" + player.name + "^7 decided to enter the sniper room");
		player SetOrigin((316, -5968, -2012));
		player SetPlayerAngles((0, 90, 0));
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		wait 0.01;
		player SwitchToWeapon("remington700_mp");
		player AllowSprint(true);

		if( GetTeamPlayersAlive("axis") >= 1)
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "axis" )
				{
					players[i] SetPlayerAngles((0,270,0));
					players[i] SetOrigin((444, -4048, -2012));
					players[i] TakeAllWeapons();
					players[i] GiveWeapon("remington700_mp");
					players[i] GiveMaxAmmo("remington700_mp");
					wait 0.01;
					players[i] SwitchToWeapon("remington700_mp");
				}
			}
			return;
		}
	}
}

knife()
{
	trig = getEnt("knife","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		iprintlnbold("^3" + player.name + "^7 decided to enter the knife room");
		player SetOrigin((-760, -3704, -2016));
		player SetPlayerAngles((0, 90, 0));
		player GiveWeapon("knife_mp");
		wait 0.01;
		player SwitchToWeapon("knife_mp");
		player AllowSprint(true);

		if( GetTeamPlayersAlive("axis") >= 1)
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "axis" )
				{
					players[i] SetPlayerAngles((0,270,0));
					players[i] SetOrigin((-760, -2824, -2016));
					players[i] TakeAllWeapons();
					players[i] GiveWeapon("knife_mp");
					wait 0.01;
					players[i] SwitchToWeapon("knife_mp");
				}
			}
			return;
		}
	}
}

shotgun()
{
	trig = getEnt("shotgun","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		iprintlnbold("^3" + player.name + "^7 decided to enter the shotgun room");
		player SetOrigin((-2204, -6032, -2084));
		player SetPlayerAngles((0, 90, 0));
		player GiveWeapon("winchester1200_grip_mp");
		player GiveMaxAmmo("winchester1200_grip_mp");
		wait 0.01;
		player SwitchToWeapon("winchester1200_grip_mp");
		player AllowSprint(true);

		if( GetTeamPlayersAlive("axis") >= 1)
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "axis" )
				{
					players[i] SetPlayerAngles((0,270,0));
					players[i] SetOrigin((-2532, -4072, -2124));
					players[i] TakeAllWeapons();
					players[i] GiveWeapon("winchester1200_grip_mp");
					players[i] GiveMaxAmmo("winchester1200_grip_mp");
					wait 0.01;
					players[i] SwitchToWeapon("winchester1200_grip_mp");
				}
			}
			return;
		}
	}
}

onDeath()
{
        self endon("disconnect");

        self waittill("death");

		iprintlnbold("^3" + self.name + "^1 died");

}

ammo()
{
	trig =  getEntArray("ammo","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		player GiveMaxAmmo( self.pers["weapon"] );
	}
}

xp()
{
	trig = getEnt("givexp","targetname");
	while(1)
	{
		trig waittill("trigger",player);
		player braxi\_rank::giveRankXP("kill",100);
		wait 10;
	}
}