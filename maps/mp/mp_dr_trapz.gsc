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

   thread sr\api\_map::createSpawn((-832,-1360,76),360);
   thread sr\api\_speedrun::createNormalWays("Normal Way;");
   thread sr\api\_speedrun::createSecretWays("Secret Way;");
   thread sr\api\_speedrun::createEndMap((-1026.3, 346.454, 32.125), 115, 100, "normal_0");

	thread porte1();
	thread secretjumpfail();
	thread endsecret();
	thread secret();
	
}

porte1()
{
   block = getent("porte1","targetname");
   trig = getent("trig_porte1","targetname");
   
   block delete();
   
}

secret()
{
   secret_trigger = getent("trig_tp1","targetname");
   telejumporigin = getent("secret_jumper", "targetname");
   
  for(;;)
   {
   secret_trigger waittill( "trigger", player );

   player thread sr\api\_speedrun::changeWay("secret_0");  
      
   player SetOrigin( telejumporigin.origin );
   player setplayerangles( telejumporigin.angles );
   player FreezeControls(1);
   wait 0.1;
   player FreezeControls(0);
   
}
}

endsecret()
{
endsecret_trigger = getent("trig_tp2","targetname");
telejumporigin2 = getent("jumper_secretend", "targetname");
   
for (;;)
{
endsecret_trigger waittill( "trigger", player );

player thread sr\api\_speedrun::finishWay("secret_0");
      
   
}
}

secretjumpfail()
{
	secretjumper = getEnt("secret_jumper_respawn", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
		player iprintln("^3>>^1Respawned^3<<");
	}
}
