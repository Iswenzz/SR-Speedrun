main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "allies";
 game["defenders"] = "axis";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
	
 setdvar( "r_specularcolorscale", "1" );
 setDvar("r_glowbloomintensity0",".1");
 setDvar("r_glowbloomintensity1",".1");
 setDvar("r_glowskybleedintensity0",".1");
 setdvar("compassmaxrange","1800");

thread sr\api\_map::createSpawn((-40,-30,76),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createEndMap((1779.72, 7043.54, -15.875),105,60);

thread startdoor();
thread secret();
thread secretjumpfail1();
thread secretjumpfail2();
thread secretjumpfail3();
thread secretjumpfail4();
thread secretjumpfail5();
thread endsecret();

}

startdoor()
{
door = getent("startdoor","targetname");

door delete();

}

secret()
{
   level.secret_trigger = getent("trig_tp1","targetname");
   telejumporigin = getent("secret_jumper", "targetname");
   
   for(;;)
   {
   level.secret_trigger waittill( "trigger", player );
     
   player thread sr\api\_speedrun::changeWay("secret_0");
   player SetOrigin( telejumporigin.origin );
   player setplayerangles( telejumporigin.angles );
   
}
}

secretjumpfail1()
{
	secretjumper = getEnt("secret_trigger_respawn", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
	}
}

secretjumpfail2()
{
	secretjumper = getEnt("secret_trigger_respawn2", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret2", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
	}
}

secretjumpfail3()
{
	secretjumper = getEnt("secret_trigger_respawn3", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret2", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
	}
}

secretjumpfail4()
{
	secretjumper = getEnt("secret_trigger_respawn4", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret2", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
	}
}

secretjumpfail5()
{
	secretjumper = getEnt("secret_trigger_respawn5", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret3", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
	}
}

endsecret()
{
   level.endsecret_trigger = getent("trig_endsecret","targetname");
   telejumporigin2 = getent("jumper_secretend", "targetname");
   
   for(;;)
   {
    level.endsecret_trigger waittill( "trigger", player );
      
    player thread sr\api\_speedrun::finishWay("secret_0");
  
   
}
}