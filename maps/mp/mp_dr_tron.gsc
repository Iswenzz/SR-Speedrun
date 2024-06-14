main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor"; 
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
  
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((515, -681, 76), 180);
	thread sr\api\_speedrun::createTeleporter((-3652.57, -686.943, 16.125), 145, 100, (-4684, -1389, 364), 270, "freeze", "yellow");
	thread sr\api\_speedrun::createTeleporter((-739.188, 511.28, 64.125), 100, 100, (714, 907, 236), 43, "freeze", "yellow");
	thread sr\api\_speedrun::createTeleporter((515.206, -841.486, 16.125), 60, 100, (718, 3662, -1092), 180, "freeze", "green", "secret_0");
    
	thread stage2();
	thread lazers1();
	thread lazers2();
	thread hardfail1();
	thread hardfail2();
	thread hardfail3();
	thread hardend();
}

stage2()
{
	trigger = getEnt ("stage2", "targetname");
	target = getEnt ("stage2_ori", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}


lazers1()
{
	lazer1 = getEnt ("trap11_1" , "targetname");
	
	lazer1 delete();
}

lazers2()
{
	lazer2 = getEnt ("lazer2" , "targetname");

	lazer2 delete();
}

hardfail1()
{
	trig = getEnt ("secret_tele1", "targetname");
	target1 = getEnt ("secret_fail1", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		player Suicide();
		
	}
}

hardfail2()
{
	trig = getEnt ("secret_tele2", "targetname");
	target1 = getEnt ("secret_fail2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		player Suicide();
	}
}

hardfail3()
{
	trig = getEnt ("secret_tele3", "targetname");
	target1 = getEnt ("secret_fail3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		player Suicide();
	}
}

hardend()
{
	trig = getEnt ("theend", "targetname");
	target1 = getEnt ("theend_ori", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
		
	}
}