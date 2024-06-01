main()
{
trigger =getent("end_t","targetname");
trigger.targetname = "endmap_trig";

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
    setDvar("bg_falldamagemaxheight", 20000 );
    setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-4608, 192, -147), 0);
	thread sr\api\_speedrun::createTeleporter((-4607.85, 375.039, -207.375), 60, 100, (-5320, 2510, 1264), 360, "freeze", "yellow", "secret_0");

    thread tp1();
	thread tp2();
	thread tp3();
	thread sec_end();
	thread tele2();
    
}

tp1()
{
      trig=getentArray("enter","targetname");
      targ=getent("gohere9","targetname");

      for(;;)
      {
      trig[6] waittill("trigger",player);

      player setorigin(targ.origin);
      player setplayerangles(targ.angles);
      player freezecontrols(1);
      wait 0.1;
      player freezecontrols(0);
      }
}

tp2()
{
      trig=getentArray("enter","targetname");
      targ=getent("gohere3","targetname");

      for(;;)
      {
      trig[2] waittill("trigger",player);

      player setorigin(targ.origin);
      player setplayerangles(targ.angles);
      player freezecontrols(1);
      wait 0.1;
      player freezecontrols(0);
      }
}

tp3()
{
      trig=getentArray("enter","targetname");
      targ=getent("gohere12","targetname");

      for(;;)
      {
      trig[9] waittill("trigger",player);

      player setorigin(targ.origin);
      player setplayerangles(targ.angles);
      player freezecontrols(1);
      wait 0.1;
      player freezecontrols(0);
      }
}


sec_end()
{
      trig=getent("sec_end","targetname");

      for(;;)
      {
      trig waittill("trigger",player);

      player thread sr\api\_speedrun::finishWay("secret_0");

      }
}

tele2()
{
	entTransporter = getentarray( "enter2", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter2();
}
 
transporter2()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );

		player Suicide();
		
	}
}
