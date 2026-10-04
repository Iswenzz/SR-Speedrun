main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("bg_bobmax" , "0");
	setdvar("jump_slowdownenable" , "0");
	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");
	setdvar("r_specular" , "1");
	setdvar("r_drawDecals" , "1");

    //hard secret
	thread hard_secret_fail_1();
	thread hard_secret_fail_2();
	thread hard_secret_fail_3();
	thread hard_secret_fail_4();
	thread hard_secret_fail_5();
	thread hard_secret_fail_6();
	thread hard_secret_end_top();
	thread hard_secret_end_mid();
	thread hard_secret_end_bottom();

    //inter secret
    thread inter_secret_check_1();
	thread inter_secret_check_2();
	thread inter_secret_check_3();
    thread inter_secret_fail();
    thread inter_secret_end();

    precacheitem("codol_tacknife_mp");

	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Inter Secret; Hard Secret");

	inter_sec = getEnt("inter_secret_origin", "targetname");
	hard_sec = getEnt("hard_secret_origin", "targetname");

	thread sr\api\_speedrun::createTeleporter((9800, -513, -590), 70, 100, inter_sec.origin, 180, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createTeleporter((9800, -95, -590), 70, 100, hard_sec.origin, 135, "freeze", "red", "secret_1");

}

freeze_on_tps(time) {
    self freezecontrols(true);
    self thread dddasdasddd(time);
}
dddasdasddd(time) {
    wait time;
    self freezecontrols(false);
}

hard_secret_fail_1()
{
	trig = getEnt("hard_secret_fail_1", "targetname");
	tele = getEnt("hard_secret_fail_origin_1", "targetname");

	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setplayerAngles(tele.angles);
		player freeze_on_tps(0.1);
	}
}
hard_secret_fail_2()
{
	trig = getEnt("hard_secret_fail_2", "targetname");
	tele = getEnt("hard_secret_fail_origin_2", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setplayerAngles(tele.angles);
		player freeze_on_tps(0.1);
	}
}
hard_secret_fail_3()
{
	trig = getEnt("hard_secret_fail_3", "targetname");
	tele = getEnt("hard_secret_fail_origin_3", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setplayerAngles(tele.angles);
		player freeze_on_tps(0.1);
	}
}
hard_secret_fail_4()
{
	trig = getEnt("hard_secret_fail_4", "targetname");
	tele = getEnt("hard_secret_fail_origin_4", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setplayerAngles(tele.angles);
		player freeze_on_tps(0.1);
	}
}
hard_secret_fail_5()
{
	trig = getEnt("hard_secret_fail_5", "targetname");
	tele = getEnt("hard_secret_fail_origin_5", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setplayerAngles(tele.angles);
		player freeze_on_tps(0.1);
	}
}
hard_secret_fail_6()
{
	trig = getEnt("hard_secret_fail_6", "targetname");
	tele = getEnt("hard_secret_fail_origin_6", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tele.origin);
		player setplayerAngles(tele.angles);
		player freeze_on_tps(0.1);
	}
}

hard_secret_end_top()
{
	trig = getEnt("hard_secret_end_top", "targetname");
	tele = getEnt("hard_secret_end_top_origin", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_1");

	}
}
hard_secret_end_mid()
{
	trig = getEnt("hard_secret_end_mid", "targetname");
	tele = getEnt("hard_secret_end_mid_origin", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_1");

	}
}
hard_secret_end_bottom()
{
	trig = getEnt("hard_secret_end_bottom", "targetname");
	tele = getEnt("hard_secret_end_bottom_origin", "targetname");
	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_1");

	}
}

inter_secret_fail()
{
	trig = getEnt( "inter_secret_fail", "targetname" );
	dest = getEnt( "inter_secret_teleport", "targetname" );
	check1 = getEnt( "inter_secret_check_1_tp", "targetname" );
	check2 = getEnt( "inter_secret_check_2_tp", "targetname" );
	check3 = getEnt( "inter_secret_check_3_tp", "targetname" );
	check4 = getEnt( "inter_secret_check_4_tp", "targetname" );
    if(!isDefined(trig) || !isDefined(dest) || !isDefined(check1) || !isDefined(check2) || !isDefined(check3))
		return;
    while(1)
	{
		trig waittill ( "trigger", player );
		if (isDefined(player.checkpointid))
		{
			if (player.checkpointid == 0)
			{
				player setOrigin( dest.origin );
				player setplayerangles( dest.angles );
                player freeze_on_tps(0.1);
			}
			if (player.checkpointid == 1)
			{
				player setOrigin( check1.origin );
				player setplayerangles( check1.angles );
                player freeze_on_tps(0.1);
			}
			if (player.checkpointid == 2)
			{
				player setOrigin( check2.origin );
				player setplayerangles( check2.angles );
                player freeze_on_tps(0.1);
			}
			if (player.checkpointid == 3)
			{
				player setOrigin( check3.origin );
				player setplayerangles( check3.angles );
                player freeze_on_tps(0.1);
			}
        }
    }
}
inter_secret_check_1()
{
	trig = getEnt("inter_secret_check_1","targetname");

	if(!isDefined(trig))
		return;
	while(1)
	{
		trig waittill ( "trigger", player );
		if (!isDefined(player.checkpointid))
			continue;
		if (player.checkpointid < 1)
		{
			player.checkpointid = 1;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

inter_secret_check_2()
{
	trig = getEnt("inter_secret_check_2","targetname");

	if(!isDefined(trig))
		return;
	while(1)
	{
		trig waittill ( "trigger", player );
		if (!isDefined(player.checkpointid))
			continue;
		if (player.checkpointid < 2)
		{
			player.checkpointid = 2;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

inter_secret_check_3()
{
	trig = getEnt("inter_secret_check_3","targetname");

	if(!isDefined(trig))
		return;
	while(1)
	{
		trig waittill ( "trigger", player );
		if (!isDefined(player.checkpointid))
			continue;
		if (player.checkpointid < 3)
		{
			player.checkpointid = 3;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

inter_secret_end()
{
	trig = getEnt("inter_secret_end", "targetname");
	tele = getEnt("inter_secret_end_origin", "targetname");

	if(!isDefined(trig) || !isDefined(tele))
		return;
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}
