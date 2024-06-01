main()
{
	maps\mp\_load::main(); 

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setDvar("r_drawDecals","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","1800");
 	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((541, 2273, -180), 90);

	thread sr_tp();
    thread startdoor();
	thread sec_exit();
	thread jump_tp2();
	thread sec_fail1();
	thread sec_fail2();
	thread secret0_enter();



}

sr_tp()
{
	trig = spawn("trigger_radius",(604.76, 5263.59, 128.125), 0, 80, 100);
	trig.radius = 80;
	ori_t = getEnt("jump_here1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freezeControls(1);
		wait 0.1;
		player freezeControls(0);
	}
}

secret0_enter()
{
	trig = spawn("trigger_radius",(656.411, 2273.23, -239.875), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("sr_1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);
        
		player thread sr\api\_speedrun::changeWay("secret_0");   

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freezeControls(1);
		wait 0.1;
		player freezeControls(0);
	}
}


startdoor()
{
	door = getEnt("startdoor","targetname");
	
	door delete();
	
}

jump_tp2()
{
	trig = getEnt("jump_tp2", "targetname");
	tele1 = getEnt("jump_here2", "targetname");

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


sec_fail1()
{
	trig = getEnt("sf_1", "targetname");
	tele1 = getEnt("sr_1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player Suicide();
		}
}

sec_exit()
{
	
	trig = getEnt("sec_exit", "targetname");
	tele1 = getEnt("jump_here2", "targetname");

    for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_0");

		}
			
}


sec_fail2()
{
	trig = getEnt("sf_2", "targetname");
	tele1 = getEnt("sr_2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player Suicide();
		}
}