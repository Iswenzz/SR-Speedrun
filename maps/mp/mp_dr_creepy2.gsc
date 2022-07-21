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

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createEndMap((-27776.7, -1681.9, -1558.88), 100, 10, "normal_0");
thread sr\api\_speedrun::createTeleporter((-20112.3, -1673.74, -2238.88), 435, 160, (-20065, -1679, -1499), 180, "freeze");

thread secretdoorinsta();
thread startdoor();
thread secretenter();
thread secretp1();
thread secretp2();
thread secretp3();
thread secretp4();
thread secretp5();
thread secretp6();
thread secretp7();
thread secretexit();
	
}

secretdoorinsta()
{
door = getEnt("secretdoor", "targetname");

door delete();
}

startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();

}	

secretenter()
{
	trig = getEnt("trig_secretenter", "targetname");
	out = getEnt("o_secretenter", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::changeWay("secret_0");          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		secret_stop = "secret_stop";
		player thread playerGone(secret_stop);
	}
}

secretp1()
{
	trig = getEnt("trig_secretp1", "targetname");
	out = getEnt("o_secretp1", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp2()
{
	trig = getEnt("trig_secretp2", "targetname");
	out = getEnt("o_secretp2", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp3()
{
	trig = getEnt("trig_secretp3", "targetname");
	out = getEnt("o_secretp3", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp4()
{
	trig = getEnt("trig_secretp4", "targetname");
	out = getEnt("o_secretp4", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	if (level.step4 == false)
	{
		exitLevel(true);
	}
		else {
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		}
	}
}

secretp5()
{
	trig = getEnt("trig_secretp5", "targetname");
	out = getEnt("o_secretp5", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp6()
{
	trig = getEnt("trig_secretp6", "targetname");
	out = getEnt("o_secretp6", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp7()
{
	trig = getEnt("trig_secretp7", "targetname");
	out = getEnt("o_secretp7", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretexit()
{
	trig = getEnt("trig_secretexit", "targetname");
	out = getEnt("o_secretexit", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		player notify("secret_stop");
	}
}

playerGone(noty)
{
    self playerOnDeath(noty);
    self playerOnDisconnect(noty);
    self playerOnSpawned(noty);
    self playerOnSpectators(noty);
    wait 0.5;
}
 
playerOnDeath(noty)
{
    self waittill("death");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnDisconnect(noty)
{
    self waittill("disconnect");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnSpawned(noty)
{
    self waittill("spawned");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnSpectators(noty)
{
    self waittill("joined_spectators");
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
}