main()
{
 maps\mp\_load::main();

 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";


	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

    thread sr\api\_map::createSpawnOrigin((672, -384, -491.757), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");

	thread startteleporter();
	thread teleporter1();
	thread teleporter2();
	thread teleporterglitch();
	thread teleport_shortcut();
	thread teleport_secretstart();
	thread teleport_secretend();
	thread teleport_secretfail();
	thread open_secret();
	thread move_1();
	thread move_2();
	thread trap3();

	thread fix((782.727, -259.907, -375.875));
	thread fix1((2204.88, -1950.62, -319.875));


}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 540, 500);
	trigger.targetname = "fix";
	trigger.radius = 540;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

fix1(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 7900, 500);
	trigger.targetname = "fix1";
	trigger.radius = 790;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

startteleporter()
{
	trig = getEnt("start_teleporter","targetname");
	target = getEnt("start_teleporter_end","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporter1()
{
	trig = getEnt("map_teleporter_1","targetname");
	target = getEnt("teleporter_1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporter2()
{
	trig = getEnt("map_teleporter_2","targetname");
	target = getEnt("teleporter_2","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporterglitch()
{
	trig = getEnt("map_teleporter_glitch","targetname");
	target = getEnt("teleporter_glitch","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		player suicide();
	}
}


teleport_shortcut()
{
	trig = getEnt("map_teleporter_shortcut","targetname");
	target = getEnt("teleporter_shortcut","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}


open_secret()
{
	trig = getEnt("secret_open","targetname");
	brush = getent("secret_brush","targetname");
	brush delete();
}

teleport_secretstart()
{
	trig = getEnt("map_teleporter_secretstart","targetname");
	target = getEnt("teleporter_secretstart","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}

teleport_secretend()
{
	trig = getEnt("map_teleporter_secretend","targetname");
	target = getEnt("teleporter_secretend","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}


teleport_secretfail()
{
	trig = getEnt("map_teleporter_secretfail","targetname");
	target = getEnt("teleporter_secretstart","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player Suicide();

	}
}

move_1()
{
    target = getEnt ("move_1", "targetname");


}

move_2()
{
    target = getEnt ("move_2", "targetname");


}

trap3()
{
wall = getent("trap3wall","targetname");
aspike = getent("trap3a","targetname");
b = getent("trap3b","targetname");
c = getent("trap3c","targetname");
d = getent("trap3d","targetname");
e = getent("trap3e","targetname");
f = getent("trap3f","targetname");
g = getent("trap3g","targetname");
h = getent("trap3h","targetname");
i = getent("trap3i","targetname");
j = getent("trap3j","targetname");
k = getent("trap3k","targetname");
l = getent("trap3l","targetname");
m = getent("trap3m","targetname");
n = getent("trap3n","targetname");
o = getent("trap3o","targetname");
up = getent("trap3up","targetname");
killer = getent("3killer","targetname");

	wall delete();
	aspike delete();
	b delete();
	c delete();
	d delete();
	e delete();
	f delete();
	g delete();
	h delete();
	i delete();
	j delete();
	k delete();
	l delete();
	m delete();
	n delete();
	o delete();
	up delete();

}