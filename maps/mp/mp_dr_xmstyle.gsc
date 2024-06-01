main()
{
	endmap = getEnt("endmap_trig","targetname");
	endmap delete(); 

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
	setDvar("bg_FallDamageMaxHeight","9999");
	setDvar("bg_FallDamageMinHeight","9999");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;^5Acti Secret;");
	thread sr\api\_map::createSpawn((-544, 666, 76), 90);
	thread sr\api\_speedrun::createEndMap((3585, 2563.57, 16.125), 130, 100, "normal_0");
	

	thread startdoor();
	thread tp_1();
	thread acti_sec_enter();
	thread acti_jump_fail();
	thread acti_jump_leave();
	thread secret_enter();
	thread secret_exit();
	thread secret_fail();
	thread hard_enter();
	thread hard_fail();
	thread hard_leave();

	
}

startdoor()
{
	door = getEnt("startdoor","targetname");
	platforms = getEnt("start1","targetname");
	kill_trig = getEnt("trig_kill", "targetname");
	brush = getEnt("sec_block", "targetname");
	trig = getEnt("trig_sec_open", "targetname");
	clip = getEnt("sec_clip", "targetname");
	
	platforms moveZ(512,0.1);
	door delete();
	kill_trig delete();
	trig delete();
	clip delete();
	brush delete();
	
}

secret_enter()
{
	trig = getEnt("trig_sec_enter", "targetname");
	tele1 = getEnt("here4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::changeWay("secret_0"); 

			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}


acti_jump_fail()
{
	trig = getEnt("acti_fail", "targetname");
	tele1 = getEnt("acti_jump", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}


acti_sec_enter()
{
	trig = spawn("trigger_radius",(-713.542, 860.362, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("acti_jump","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_2"); 

		player setOrigin(ori_t.origin);
		player setPlayerAngles(ori_t.angles);
		player freezeControls(1);
		wait 0.01;
		player freezeControls(0);
	}
}

acti_jump_leave()
{
	trig = getEnt("acti_leave", "targetname");
	tele1 = getEnt("acti_back", "targetname");

    for(;;)
		{
		trig waittill("trigger", player);
			
		player thread sr\api\_speedrun::finishWay("secret_2");

        }
}

hard_enter()
{
	trig = spawn("trigger_radius",(-713.606, 665.543, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("sec_hard","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player setOrigin(ori_t.origin);
		player setPlayerAngles(ori_t.angles);
		player freezeControls(1);
		wait 0.01;
		player freezeControls(0);
	}
}

hard_fail()
{
	trig = getEnt("hard_fail", "targetname");
	tele1 = getEnt("sec_hard", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

hard_leave()
{
	trig = getEnt("hard_leave", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_1");
			
			
		}
}

secret_exit()
{
	trig = getEnt("sec_exit", "targetname");
	tele1 = getEnt("here_easy", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_0");

			
		}
}

secret_fail()
{
	trig = getEnt("sec_fail", "targetname");
	tele1 = getEnt("here4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

tp_1()
{
	trig = getEnt("tp1", "targetname");
	tele1 = getEnt("here1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.1;
			player freezeControls(0);
		}
}

