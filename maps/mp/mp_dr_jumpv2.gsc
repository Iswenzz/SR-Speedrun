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

thread speedrun\_way_name::create_spawn((-40,-30,76),90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_endmap((1779.72, 7043.54, -15.875),105,60,"ns0");

thread startdoor();
thread jumpersecret();

}

startdoor()
{
door = getent("startdoor","targetname");

door delete();

}

jumpersecret()
{

thread secret();
thread secretjumpfail1();
thread secretjumpfail2();
thread secretjumpfail3();
thread secretjumpfail4();
thread secretjumpfail5();
thread endsecret();

}

secret()
{
   level.secret_trigger = getent("trig_tp1","targetname");
   telejumporigin = getent("secret_jumper", "targetname");
   
   while(1)
   {
      level.secret_trigger waittill( "trigger", player );
      if( !isDefined( level.secret_trigger ) )
      return;
      if(level.firstenter==true)
   wait(0.05);
    
   player thread speedrun\_way_name::change_way("s0");
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
		player iprintln("^3>>^1Respawned");
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
		player iprintln("^3>>^1Respawned");
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
		player iprintln("^3>>^1Respawned");
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
		player iprintln("^3>>^1Respawned");
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
		player iprintln("^3>>^1Respawned");
	}
}

endsecret()
{
   level.endsecret_trigger = getent("trig_endsecret","targetname");
   telejumporigin2 = getent("jumper_secretend", "targetname");
   
   while(1)
   {
      level.endsecret_trigger waittill( "trigger", player );
      if( !isDefined( level.endsecret_trigger ) )
      return;
      if(level.firstenter==true)
   wait(0.05);
   
   player thread speedrun\_way_name::finish_way("s0");
   player SetOrigin( telejumporigin2.origin );
   player setplayerangles( telejumporigin2.angles );
  
   
}
}