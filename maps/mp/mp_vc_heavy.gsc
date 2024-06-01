main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

  thread sr\api\_speedrun::createNormalWays("Normal Way;");
  thread sr\api\_speedrun::createSecretWays("Acti Secret;Jumper Secret;");
  thread sr\api\_map::createSpawn((-1009, -122, -4), 90);
  thread sr\api\_speedrun::createTeleporter((-850.968, -121.861, -63.875), 60, 100, (4483, 2287, -3), 90, "freeze", "cyan", "secret_0");
  thread sr\api\_speedrun::createTeleporter((-1134.22, -121.99, -63.875), 60, 100, (4365, 1049, -3), 360, "freeze", "green", "secret_1");

  thread startGate();
  thread trap3();
  thread trap4();
  thread tp1();
  thread tp2();
  thread acti_fail();
  thread sec_fail();
  thread acti_end();
  thread sec_end();

}

startGate()
{
 
  door = getEnt("start_gate", "targetname");

  door delete();


}

trap3()
{
  hurt = getEnt("hurt_trap3", "targetname");
 
  hurt delete();

 
}

trap4()
{

  hurts = GetEntArray("hurt_trap4", "targetname");


  hurts[0] delete();
  hurts[1] delete();
  hurts[2] delete();
  hurts[3] delete();
}

tp1()
{
	trig = getEnt("trig_mapTp1", "targetname");
	orig = getEnt ("targ_mapTp1", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);          
	  player SetOrigin(orig.origin);
    player SetPlayerAngles( orig.angles );
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
	}

}

tp2()
{
	trig = getEnt("trig_mapTp2", "targetname");
	orig = getEnt ("targ_mapTp2", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);          
	  player SetOrigin(orig.origin);
    player SetPlayerAngles( orig.angles );
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
	}

}

acti_fail()
{
	trig = getEnt("trig_actifail4", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	  player Suicide();
    
	}

}

sec_fail()
{
	trig = getEnt("trig_secFail", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);

	  player Suicide();
    
	}

}

acti_end()
{
	trig = getEnt("trig_actiSecFinish", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);   

    player thread sr\api\_speedrun::finishWay("secret_0");

	 
	}

}

sec_end()
{
	trig = getEnt("trig_SecFinish", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);   

    player thread sr\api\_speedrun::finishWay("secret_1");

	 
	}

}