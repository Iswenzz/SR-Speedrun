/*			  
  /\\  /\\  
  //\\_//\\     ____
  \_     _/    /   /
   / ^ ^ \    /^^^|
   \_\O/_/    |   |
    /   \_    |   /
    \     \_  /  /
    | | | /  \/ _/
    |_| | \__/_/               				  
	By VC'Fox.
		___    __  _       _______        
	| | / (_)__/ /_(_)___  / ___/ /__ ____ 
	| |/ / (_-< __/ / __/ / /__/ / _ `/ _ \
	|___/_/___|__/_/\__/  \___/_/\_,_/_//_/ 

	Thanks to VC'Blade for his Secret Timer Script and the original idea for this map.
*/


main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^3Easy Secret;^1Hard Secret;^5Acti Secret;");
	thread sr\api\_speedrun::createTeleporter((-666.903, 228.034, 16.125), 95, 80, (5237, 7869, -194), 357, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-948.754, 264.133, 16.125), 90, 80, (-4812, 5197, -194), 91, "freeze", "red", "secret_1");
	thread sr\api\_speedrun::createTeleporter((-934.759, -214.842, 16.125), 90, 80, (-5682, -505, -194), 270, "freeze", "cyan", "secret_2");
	thread sr\api\_speedrun::createTeleporter((2656.36, -3940.81, 30.125), 120, 85, (2638, -5010, 70), 272,"unfreeze");
	thread sr\api\_speedrun::createTeleporter((13098.3, -5810.7, -255.875), 95, 85, (13878, -5821, -196), 358,"freeze");


	setdvar("r_specularcolorscale", "1");
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
 	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_FallDamageMinHeight","99998"); 

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread startdoor();
	thread secret_respawn();
	thread secret_leave();
	thread secret_respawn_hard();
	thread hard_secret_leave();
	thread acti_reset();
	thread acti_leave();
	thread setresp();
	thread jumper_tp1();


	addTriggerToList("trig_trap1"); 
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
	addTriggerToList("trig_trap10");
	addTriggerToList("trig_trap11");

}
jumper_tp1()
{
	trig = getEnt("trig_tp1","targetname");
	here = getEnt("here1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
	}
}
setresp() 
{
    trig1 = spawn( "trigger_radius", (-836.12, 37.6445, 16.125), 0, 140, 60 );

	trig1 thread setting();

}
setting()
{
   while(1)
    {
    	self waittill("trigger", player);
		player.checkpoint = 0;
		player.hard_checkpoint = 0;

    }
   
}
addTriggerToList(name) 
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name , "targetname");
}


startdoor()
{
	door = getEnt("startdoor","targetname");
	door delete();
}



trap1()
{
	level endon("triggerqsq");
	brush = getEnt("trap1","targetname");
	trig = getEnt("trig_trap1","targetname");

	trig waittill("triggerqsq",player);

	trig delete();

	while(1)
	{
		brush rotateRoll(-360,2);
		wait 5;
		brush rotateRoll(360,2);
		wait 5;
		brush rotateRoll(-720,2);
		wait 5;
	}
}

trap2()
{
	level endon("triggervnn");
	brush = getEnt("trap2","targetname");
	trig = getEnt("trig_trap2","targetname");


	trig waittill("triggervnn",player);

	trig delete();

	brush delete();
}

trap3()
{
	level endon("triggerhjyj");
	brush = getEnt("trap3","targetname");
	trig = getEnt("trig_trap3","targetname");
	kill = getEnt("trap3_kill","targetname");

	kill maps\mp\_utility::triggerOff();

	kill enableLinkTo();
	kill linkTo(brush);

	brush hide();


	trig waittill("triggerhjyj",player);


	kill maps\mp\_utility::triggerOn();

	brush show();
	brush MoveY(1024, 1);
	brush waittill("movedone");
	brush delete();
	kill delete();
	trig delete();
}

trap4()
{
	level endon("triggeraxqqxvb");
	brush = getEnt("trap4","targetname");
	trig = getEnt("trig_trap4","targetname");


	trig waittill("triggeraxqqxvb",player);


	brush MoveZ(-400, 0.5);
	brush waittill("movedone");
	wait 2;
	brush MoveZ(400, 2);
	trig delete();
}

trap5()
{
	level endon("triggeraadqsda");
	brush = getEnt("trap5","targetname");
	brush2 = getEnt("trap5a","targetname");
	trig = getEnt("trig_trap5","targetname");


	trig waittill("triggeraadqsda",player);

	trig delete();

	while(1)
	{
		brush rotatePitch(180, 1);
		brush2 rotatePitch(-180, 1);
		wait 3;
		brush rotatePitch(-180, 1);
		brush2 rotatePitch(180, 1);
		wait 3;
		brush rotatePitch(360, 2);
		brush2 rotatePitch(360, 2);
		wait 4;
		brush rotatePitch(-360, 2);
		brush2 rotatePitch(-360, 2);
		wait 5;
	}
}

trap6()
{
	level endon("triggerazrtty");
	brush = getEnt("trap6","targetname");
	trig = getEnt("trig_trap6","targetname");


	trig waittill("triggerazrtty",player);


	brush moveZ(100, 1);
	brush waittill("movedone");
	wait 2;
	brush moveZ(-100, 2);
	trig delete();
}

trap7()
{
	level endon("triggerahthth");
	brush = getEnt("trap7","targetname");
	brush2 = getEnt("trap7a","targetname");
	brush3 = getEnt("trap7b","targetname");
	trig = getEnt("trig_trap7","targetname");


	trig waittill("triggerahthth",player);


	trig delete();
	while(1)
	{
		brush rotateRoll(360, 2);
		wait 0.2;
		brush2 rotateRoll(360, 2);
		wait 0.2;
		brush3 rotateRoll(360, 2);
		wait 5;
	}
}

trap8()
{
	level endon("triggeravvv");
	c4 = getEnt("trap8_c4","targetname");
	c41 = getEnt("trap8_c41","targetname");
	trig = getEnt("trig_trap8","targetname");
	kill = getEnt("trap8_kill","targetname");

	kill maps\mp\_utility::triggerOff();

	trig waittill("triggeravvv",player);


	kill maps\mp\_utility::triggerOn();


	wait 0.2;

	kill delete();
	trig delete();
	c4 delete();
	c41 delete();
	c4 = undefined;
}



trap9()
{
	level endon("triggeraaqx");
	sentry = getEnt("trap9_sentry","targetname");
	sentry_obj = getEnt("trap9_sentry_obj","targetname");
	sentry_des = getEnt("sentry_des","targetname");
	trig = getEnt("trig_trap9","targetname");
	kill = getEnt("trap9_kill","targetname");

	kill maps\mp\_utility::triggerOff();

	sentry hide();
	sentry_des hide();


	trig waittill("triggeraaqx",player);

	sentry show();
	sentry_obj delete();


	kill maps\mp\_utility::triggerOn();

	kill delete();
	trig delete();
	sentry delete(); 
	sentry = undefined;
	sentry_des show();
}



trap10()
{
	level endon("triggeraqdqc");
	brush = getEnt("trap10","targetname");
	kill = getEnt("trap10_kill","targetname");
	trig = getEnt("trig_trap10","targetname");

	brush hide();
	brush notSolid();

	kill maps\mp\_utility::triggerOff();


	trig waittill("triggeraqdqc",player);


	kill maps\mp\_utility::triggerOn();


	trig delete();

	brush show();
	brush solid();

	wait 5;

	brush delete();
	kill delete();
}

trap11()
{
	level endon("triggerzffz");
	brush = getEnt("trap11","targetname");
	kill = getEnt("trap11_kill","targetname");
	trig = getEnt("trig_trap11","targetname");

	brush hide();
	brush notSolid();

	kill maps\mp\_utility::triggerOff();


	trig waittill("triggerzffz",player);

	kill maps\mp\_utility::triggerOn();


	kill enableLinkTo();
	kill linkTo(brush);

	trig delete();

	brush show();
	brush solid();

	brush MoveZ(-192, 0.2);

	wait 4;

	brush delete();
	kill delete();
}

acti_reset()
{
	trig = getEnt("acti_sec_fail","targetname");
	here = getEnt("acti_sec","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(here.origin);
		player setPlayerAngles(here.angles);
	}
}
secret_respawn()
{
	secret_fail = getent("trig_fail", "targetname");
	secret_reset_origin0 = getent("easy_here", "targetname");

	secret_reset_trig1 = getent("trig_reset1", "targetname");
	secret_reset_origin1 = getent("reset_1", "targetname");

	secret_reset_trig2 = getent("trig_reset2", "targetname");
	secret_reset_origin2 = getent("reset2", "targetname");

	secret_reset_trig3 = getent("trig_reset3", "targetname");
	secret_reset_origin3 = getent("reset3", "targetname");

	secret_reset_trig4 = getent("trig_reset4", "targetname");
	secret_reset_origin4 = getent("reset4", "targetname");

	secret_reset_trig1 thread reset1_check();
	secret_reset_trig2 thread reset2_check();
	secret_reset_trig3 thread reset3_check();
	secret_reset_trig4 thread reset4_check();

	while(1)
	{
		secret_fail waittill ("trigger", player);	
		if(player.checkpoint == 0)
		{
			player SetPlayerAngles(secret_reset_origin0.angles);
			player SetOrigin(secret_reset_origin0.origin);
			wait 0.2;
		}
		else if(player.checkpoint == 1)
		{
			player SetPlayerAngles(secret_reset_origin1.angles);
			player SetOrigin(secret_reset_origin1.origin);
			wait 0.2;
		}
		else if(player.checkpoint == 2)
		{
			player SetPlayerAngles(secret_reset_origin2.angles);
			player SetOrigin(secret_reset_origin2.origin);
			wait 0.2;
		}
		else if(player.checkpoint == 3)
		{
			player SetPlayerAngles(secret_reset_origin3.angles);
			player SetOrigin(secret_reset_origin3.origin);
			wait 0.2;
		}
		else if(player.checkpoint == 4)
		{
			player SetPlayerAngles(secret_reset_origin4.angles);
			player SetOrigin(secret_reset_origin4.origin);
			wait 0.2;
		}
	}
}

reset1_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 1;	
		wait 0.2;
	}
}

reset2_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 2;	
		wait 0.2;
	}
}

reset3_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 3;	
		wait 0.2;
	}
}

reset4_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 4;	
		wait 0.2;
	}
}

secret_respawn_hard()
{
	hard_secret_fail = getent("trig_hard_fail", "targetname");
	hard_secret_reset_origin0 = getent("hard_here", "targetname");

	hard_secret_reset_trig1 = getent("trig_hard_reset1", "targetname");
	hard_secret_reset_origin1 = getent("hard_reset1", "targetname");

	hard_secret_reset_trig2 = getent("trig_hard_reset2", "targetname");
	hard_secret_reset_origin2 = getent("hard_reset2", "targetname");

	hard_secret_reset_trig3 = getent("trig_hard_reset3", "targetname");
	hard_secret_reset_origin3 = getent("hard_reset3", "targetname");

	hard_secret_reset_trig1 thread hard_reset1_check();
	hard_secret_reset_trig2 thread hard_reset2_check();
	hard_secret_reset_trig3 thread hard_reset3_check();


	while(true)
	{
		hard_secret_fail waittill ("trigger", player);	
		if(player.hard_checkpoint == 0)
		{
			player SetPlayerAngles(hard_secret_reset_origin0.angles);
			player SetOrigin(hard_secret_reset_origin0.origin);
			wait 0.2;
		}
		if(player.hard_checkpoint == 1)
		{
			player SetPlayerAngles(hard_secret_reset_origin1.angles);
			player SetOrigin(hard_secret_reset_origin1.origin);
			wait 0.2;
		}
		if(player.hard_checkpoint == 2)
		{
			player SetPlayerAngles(hard_secret_reset_origin2.angles);
			player SetOrigin(hard_secret_reset_origin2.origin);
			wait 0.2;
		}
		if(player.hard_checkpoint == 3)
		{
			player SetPlayerAngles(hard_secret_reset_origin3.angles);
			player SetOrigin(hard_secret_reset_origin3.origin);
			wait 0.2;
		}
	}
}

hard_reset1_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.hard_checkpoint = 1;	
		wait 0.2;
	}
}

hard_reset2_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.hard_checkpoint = 2;	
		wait 0.2;
	}
}

hard_reset3_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.hard_checkpoint = 3;	
		wait 0.2;
	}
}

acti_leave()
{
	trig = getEnt("acti_leave","targetname");
	here = getEnt("here7","targetname");
	
	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr\api\_speedrun::finishWay("secret_2");
		player.checkpoint = 0;
		player.hard_checkpoint = 0;
	}

}

secret_leave()
{
	trig = getEnt("trig_sec_leave","targetname");
	here = getEnt("here1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr\api\_speedrun::finishWay("secret_0");
		player.checkpoint = 0;
		player.hard_checkpoint = 0;
	}
}

hard_secret_leave()
{
	trig = getEnt("trig_hard_leave","targetname");
	here = getEnt("hard_leave","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr\api\_speedrun::finishWay("secret_1");
		player.checkpoint = 0;
		player.hard_checkpoint = 0;
	}
}


