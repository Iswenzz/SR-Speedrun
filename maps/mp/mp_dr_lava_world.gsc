main()
{
maps\mp\_load::main();
 
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setDvar( "r_specularcolorscale", "1" );
setDvar("r_glowbloomintensity0",".25");
setDvar("r_glowbloomintensity1",".25");
setDvar("r_glowskybleedintensity0",".3");
setDvar("bg_falldamagemaxheight", 20000 );
setDvar("bg_falldamageminheight", 15000 );
	
thread sr\api\_map::createSpawn((201,-29,76),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((12305.7, 2608.98, -1839.88), 50, 10, (12320, 1530, -1780), 270, "freeze", "blue", "normal_0");

thread startdoor();
thread secret();
thread secretstep1();
thread secretstep2();
thread trap4();
}	

startdoor()
{
door = getEnt("startdoor", "targetname");

wait 0.1;
door delete();
}

secretstep1()
{
wall = getEnt("secretostep1wall", "targetname");

wait 0.1;

wall delete();
}

secretstep2()
{
arab = getEnt("secretostep2arab", "targetname");
arablock = getEnt("secretostep2arablock", "targetname");
door = getEnt("secretosdoor", "targetname");

wait 0.1;

arab rotateYaw(-2160, 0.1);
arab moveZ(-1000, 0.1);
arablock moveZ(-1000, 0.1);
door delete();
}

secret()
{

thread secrets1();
thread secrets2();
thread secrets3();
thread secretsenter();
thread secretsexit();

}

secrets1()
{
	trig = getEnt("trig_secretos1", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		player Suicide();
		
	}
}

secrets2()
{
	trig = getEnt("trig_secretos2", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		player Suicide();
		
	}
}

secrets3()
{
	trig = getEnt("trig_secretos3", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		player Suicide();

	}
}

secretsenter()
{
	trig = getEnt("trig_secretosenter", "targetname");
	o = getEnt("o_secretosenter", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		secret_stop = "secret_stop";
		player thread playerGone(secret_stop);
	}
}

secretsexit()
{
	trig = getEnt("trig_secretosexit", "targetname");
	o = getEnt("o_secretosexit", "targetname");

	for (;;)
	{
	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");
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

trap4() 
{
killtriggera = getent ("trig_hurt4a", "targetname");
killtriggerb = getent ("trig_hurt4b", "targetname");
killtriggerc = getent ("trig_hurt4c", "targetname");
laser4a = getent("laser4a","targetname");
laser4b = getent("laser4b","targetname");
laser4c = getent("laser4c","targetname");
base = getent ("base4a", "targetname");
baseb = getent ("base4b", "targetname");
basec = getent ("base4c", "targetname");
	
wait 0.1;
killtriggera delete();
killtriggerb delete();
killtriggerc delete();
laser4a delete();
laser4b delete();
laser4c delete();
base delete();
baseb delete();
basec delete();

}