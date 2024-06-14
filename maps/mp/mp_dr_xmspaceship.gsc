main()
{
  trigger = getEnt("trig_end","targetname");
  trigger.targetname = "endmap_trig";

    maps\mp\_load::main();
         
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
    
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;");
    thread sr\api\_map::createSpawn((-2, -96, 76), 90);
   
   thread start();
   thread easy_enter();
   thread easy_fail();
   thread easy_exit();
   thread hard_enter();
   thread hard_fail();
   thread hard_exit();
    
}

start()
{
    plat = getent("mover","targetname");
    door = getent("startdoor","targetname");
    trap = getent("trap_7","targetname");
  
    door delete();
    trap delete();
    plat moveY(250,0.1);
    plat waittill("movedone");
    plat rotateYaw(90,0.1);
   
   
}

easy_enter()
{
	trig = spawn("trigger_radius",(128.302, -96.0461, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("easy_enter_targ","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

easy_fail()
{
	trig = getEnt ("easy_fail_trig", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	  player Suicide();

	}

	
}

easy_exit()
{
	trig = getEnt ("trig_easyend", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");      

	}

	
}

hard_enter()
{
	trig = spawn("trigger_radius",(-142.466, -95.9434, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("hard_enter_targ","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

hard_fail()
{
	trig = getEnt ("hard_fail_trig", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	  player Suicide();

	}

	
}

hard_exit()
{
	trig = getEnt ("trig_hardend", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_1");      

	}

	
}