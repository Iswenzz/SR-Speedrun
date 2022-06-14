//////////////////////////////////////////////////
////////////| mp_deathrun_underworld |////////////
//////////////////////////////////////////////////
//////////////| map made by Icomar |//////////////
//////////////////////////////////////////////////
///////////////| xFire: icomar727 |///////////////
//////////////////////////////////////////////////
///////////////| Thanks to: Blade |///////////////
//////////////////////////////////////////////////



main()
{

	thread teleport_1();
	thread teleport_2();
	thread teleport_3();
	thread teleport_4();
	thread teleport_5();
	thread teleport_secret_1();
	thread teleport_secret_2();
	thread teleport_secret_3();
	thread teleport_secret_4();
	thread teleport_secret_5();
	thread teleport_secret_6();
	thread teleport_secret_7();
	thread teleport_secret_8();
	thread teleport_secret_9();
	thread teleport_backtomap();

}

teleport_1()
{
	trigger = getEnt ("teleport_trigger_1", "targetname");
	target = getEnt ("teleport_target_1", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_2()
{
	trigger = getEnt ("teleport_trigger_2", "targetname");
	target = getEnt ("teleport_target_2", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_3()
{
	trigger = getEnt ("teleport_trigger_3", "targetname");
	target = getEnt ("teleport_target_3", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_4()
{
	trigger = getEnt ("teleport_trigger_4", "targetname");
	target = getEnt ("teleport_target_4", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("You have been teleportet to the ^2secret room");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_5()
{
	trigger = getEnt ("teleport_trigger_5", "targetname");
	target = getEnt ("teleport_target_5", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed, try it again!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_1()
{
	trigger = getEnt ("teleport_trigger_secret_1", "targetname");
	target = getEnt ("teleport_target_secret_1", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_2()
{
	trigger = getEnt ("teleport_trigger_secret_2", "targetname");
	target = getEnt ("teleport_target_secret_2", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_3()
{
	trigger = getEnt ("teleport_trigger_secret_3", "targetname");
	target = getEnt ("teleport_target_secret_3", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_4()
{
	trigger = getEnt ("teleport_trigger_secret_4", "targetname");
	target = getEnt ("teleport_target_secret_4", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_5()
{
	trigger = getEnt ("teleport_trigger_secret_5", "targetname");
	target = getEnt ("teleport_target_secret_5", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_6()
{
	trigger = getEnt ("teleport_trigger_secret_6", "targetname");
	target = getEnt ("teleport_target_secret_6", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_7()
{
	trigger = getEnt ("teleport_trigger_secret_7", "targetname");
	target = getEnt ("teleport_target_secret_7", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_8()
{
	trigger = getEnt ("teleport_trigger_secret_8", "targetname");
	target = getEnt ("teleport_target_secret_8", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^1You failed!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

teleport_secret_9()
{
	trigger = getEnt ("teleport_trigger_secret_map", "targetname");
	target = getEnt ("teleport_target_secret_map", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^2You finished the secret room!");
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

teleport_backtomap()
{
	trigger = getEnt ("teleport_secret_backtomap", "targetname");
	target = getEnt ("teleport_target_backtomap", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		// player iprintlnbold ("^2You finished the secret room!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}