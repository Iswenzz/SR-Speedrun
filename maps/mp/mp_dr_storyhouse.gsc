main()
{
	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((1550, 3238, 700), 269);
	thread sr\api\_speedrun::createTeleporter((1770.96, 3164.84, 640.125), 100, 150, (-3448, -2461, 252), 90, "freeze", "blue", "secret_0");
	
	thread startdoor();
	thread secretstuff();
	thread secretend();
	thread trap3();

}

trap3()
{
	bar=getent("moving1", "targetname");
	
	bar delete();
	
	
}

secretstuff()
{
	thread secrettp1();
	thread secrettp2();
	thread secrettp3();
	thread secrettp4();
}

secrettp1()
{
	trig = getEnt("secrettp1", "targetname");
	target = getEnt("secrettporigin1", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player Suicide();
		}
	}
}

secrettp2()
{
	trig = getEnt("secrettp2", "targetname");
	target = getEnt("secrettporigin2", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player Suicide();
		}
	}
}

secrettp3()
{
	trig = getEnt("secrettp3", "targetname");
	target = getEnt("secrettporigin3", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player Suicide();
		}
	}
}

secrettp4()
{
	trig = getEnt("secrettp4", "targetname");
	target = getEnt("secrettporigin4", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player Suicide();
		}
	}
}

secretend()
{
	trig = getEnt("secretend", "targetname");
	target = getEnt("backtomap", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
	}
}

startdoor()
{
a1 = getEnt("startdoor1", "targetname");
a2 = getEnt("startdoor2", "targetname");
p1 = getEnt("pstartdoor1", "targetname");
p2 = getEnt("pstartdoor2", "targetname");

a1 delete();
a2 delete();
p1 delete();
p2 delete();

}

