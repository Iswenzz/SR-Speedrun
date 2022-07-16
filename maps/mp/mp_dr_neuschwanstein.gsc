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
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");

thread speedrun\_way_name::create_spawn((-33,-184,60),90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_endmap((482.431, 5575.54, 912.125), 60, 15, "ns0");

thread porte();
thread secret();
thread secret2();
thread secret4();
thread secretjumpfail();
thread secretjumpfail2();
thread secretjumpfail3();
thread endsecret();

level.firstenter = true;

}

porte()
{
porte1 = getent("porte1","targetname");
porte2 = getent("porte2","targetname");
trigfin = getent("trig_finish","targetname");
	
wait 0.1;

porte1 delete();
porte2 delete();
trigfin delete();
	
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
    wait(0.05);
   }
   
}

secretjumpfail()
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

secret2()
{
   level.secret_trigger2 = getent("trig_tp4","targetname");
   telejumporigin2 = getent("secret_jumper2", "targetname");
   
   while(1)
   {
      level.secret_trigger2 waittill( "trigger", player );
      if( !isDefined( level.secret_trigger2 ) )
      return;
      if(level.firstenter==true)
      wait(0.05);

   player SetOrigin( telejumporigin2.origin );
   player setplayerangles( telejumporigin2.angles );
   wait(0.05);
   }
   
}

secretjumpfail2()
{
	secretjumper2 = getEnt("secret_trigger_respawn2", "targetname");
	origin_jumper_secret2 = getEnt("origin_jumper_secret2", "targetname");
	
	for (;;)
	{
		secretjumper2 waittill("trigger", player);
		player setOrigin(origin_jumper_secret2.origin);
		player setPlayerAngles(origin_jumper_secret2.angles);
		player iprintln("^3>>^1Respawned");
	}
}

secret4()
{
   level.secret_trigger3 = getent("trig_tp3","targetname");
   telejumporigin3 = getent("secret_jumper3", "targetname");
   
   while(1)
   {
      level.secret_trigger3 waittill( "trigger", player );
      if( !isDefined( level.secret_trigger3 ) )
      return;
      if(level.firstenter==true)
   wait(0.05);

   player SetOrigin( telejumporigin3.origin );
   player setplayerangles( telejumporigin3.angles );
   wait(0.05);
   }
   
}

secretjumpfail3()
{
	secretjumper3 = getEnt("secret_trigger_respawn3", "targetname");
	origin_jumper_secret3 = getEnt("origin_jumper_secret3", "targetname");
	
	for (;;)
	{
		secretjumper3 waittill("trigger", player);
		player setOrigin(origin_jumper_secret3.origin);
		player setPlayerAngles(origin_jumper_secret3.angles);
		player iprintln("^3>>^1Respawned");
	}
}

endsecret()
{
   level.secret_trigger4 = getent("trig_end_secret","targetname");
   telejumporigin4 = getent("origin_end_secret", "targetname");
   level.secret_trigger4 SetHintString("^5 [USE] ");
   
   while(1)
   {
      level.secret_trigger4 waittill( "trigger", player );
      if( !isDefined( level.secret_trigger4 ) )
      return;
      if(level.firstenter==true)
      wait(0.05);

   player thread speedrun\_way_name::finish_way("s0");
   player SetOrigin( telejumporigin4.origin );
   player setplayerangles( telejumporigin4.angles );
   wait(0.05);
   }
   
}