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
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
    setdvar( "compassmaxrange", "1800" );
	setDvar("bg_falldamagemaxheight", 1500 );
	setDvar("bg_falldamageminheight", 1000 );

	thread sr\api\_map::createSpawn((-170, 3, -436), 360);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((-117.957, -2266.99, 32.125), 140, 50, (-170, 3, -436), 360, "unfreeze");
	thread sr\api\_speedrun::createTeleporter((-102.002, -290.225, -495.875), 70, 100, (3630, -7853, 516), 179, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((1510.54, -3673.37, 416.125), 80, 60, "secret_0");

	thread start();
	thread hurt();
	thread shortcut();
	thread hallway();
	thread scr1();
	thread scr2();
	thread scr3();
	thread scr4();
	thread trap2();
	thread trap3();

}

start()
{
door = getEnt("startdoor", "targetname");
platform = getEnt("platform", "targetname");

door delete();
platform delete();

}

hurt()
{

thread hurt1();
thread hurt2();
thread hurt3();
thread hurt4();
thread hurt5();
thread hurt6();
thread hurt7();
thread hurt8();

}

hurt1()
{
hurt = getEnt("death_trigger1", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

hurt2()
{
hurt = getEnt("death_trigger2", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

hurt3()
{
hurt = getEnt("death_trigger3", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}


}

hurt4()
{
hurt = getEnt("death_trigger4", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

hurt5()
{
hurt = getEnt("death_trigger5", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

hurt6()
{
hurt = getEnt("death_trigger6", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

hurt7()
{
hurt = getEnt("death_trigger7", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

hurt8()
{
hurt = getEnt("death_trigger8", "targetname");

for(;;)
{

hurt waittill("trigger", player);

player Suicide();

}

}

shortcut()
{
trigger = getEnt("trigger_shortcut", "targetname");
shortcut = getEnt("shortcut_object", "targetname");
	
trigger delete();
shortcut delete();
}

hallway()
{
door1 = getEnt("hallway_door1", "targetname");
door2 = getEnt("hallway_door2", "targetname");
	
door1 delete();
door2 delete();
}

scr1()
{
	trigger = getEnt("trigger_scr_respawn1", "targetname");
	
	for(;;)
	{

	trigger waittill("trigger", player);

	player Suicide();

	}
}

scr2()
{
	trigger = getEnt("trigger_scr_respawn2", "targetname");
	
	for(;;)
	{

	trigger waittill("trigger", player);

	player Suicide();

	}
}
scr3()
{
	trigger = getEnt("trigger_scr_respawn3", "targetname");
	
	for(;;)
	{

	trigger waittill("trigger", player);

	player Suicide();

	}
}
scr4()
{
	trigger = getEnt("trigger_scr_respawn4", "targetname");
	
	for(;;)
	{

	trigger waittill("trigger", player);

	player Suicide();

	}
}

trap2()
{
spikes = getEnt("trap2_target", "targetname");
hurt = getEnt("trap2_hurt_trigger", "targetname");
	
spikes delete();
hurt delete();

}

trap3()
{
pusher = getEnt("trap3_target", "targetname");
	
pusher moveY(-304, 0.1);
pusher waittill("movedone");
pusher moveZ(-300, 0.1);
pusher waittill("movedone");
pusher rotateYaw(90,0.1);
pusher waittill("movedone");

}