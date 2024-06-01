main()
{
	maps\mp\_load::main();
		
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
		
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;^5Acti Secret;");
	thread sr\api\_map::createSpawn((74, 281, 76), 180);

    thread start();
	thread start_fail();
	thread easy_enter();
	thread easy_fail1();
	thread easy_fail2();
	thread easy_exit();
	thread hard_enter();
	thread hard_fail1();
	thread hard_fail2();
	thread hard_fail3();
	thread hard_fail4();
	thread hard_fail5();
	thread hard_exit();
	thread acti_enter();
	thread acti_fail1();
	thread acti_fail2();
	thread acti_exit();

	
}

start()
{
    door = getent("start_door","targetname");
	wall = getent("secret_wall","targetname");
	trap3 = getent("trap3","targetname");
	hurt = getent("trap3_hurt","targetname");
   
 
    door delete();
	wall delete();
	trap3 delete();
	hurt delete();
   
}

start_fail()
{
	trig = getEnt ("start_respawn", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

easy_enter()
{
	trig = getEnt ("easy_enter", "targetname");
	end = getEnt ("easy_target_1", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::changeWay("secret_0"); 

	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	player freezeControls(1);
	wait 0.1;
	player freezeControls(0);

	}

	
}

easy_exit()
{
	trig = getEnt ("easy_exit", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");      

	}

	
}

easy_fail1()
{
	trig = getEnt ("easy_respawn_1", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

easy_fail2()
{
	trig = getEnt ("easy_respawn_2", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

hard_enter()
{
	trig = getEnt ("hard_enter", "targetname");
	end = getEnt ("hard_target_1", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::changeWay("secret_1");  

	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	player freezeControls(1);
	wait 0.1;
	player freezeControls(0);

	}

	
}

hard_fail1()
{
	trig = getEnt ("hard_respawn_1", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

hard_fail2()
{
	trig = getEnt ("hard_respawn_2", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();
	
	}

	
}

hard_fail3()
{
	trig = getEnt ("hard_respawn_3", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

hard_fail4()
{
	trig = getEnt ("hard_respawn_4", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

hard_fail5()
{
	trig = getEnt ("hard_respawn_5", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

hard_exit()
{
	trig = getEnt ("hard_exit", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_1");      

	}

	
}

acti_enter()
{
	trig = spawn("trigger_radius",(74.8015, 427.208, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("acti_room_targ1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_2"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

acti_fail1()
{
	trig = getEnt ("acti_room_fail1", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

acti_fail2()
{
	trig = getEnt ("acti_room_fail2", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player Suicide();

	}

	
}

acti_exit()
{
	trig = getEnt ("acti_room_exit", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_2");      

	}

	
}