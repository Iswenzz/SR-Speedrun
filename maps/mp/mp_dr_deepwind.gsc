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

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^1Hard Secret;^2Easy Secret;");
    thread sr\api\_map::createSpawn((-44, -171, 76), 90);
    thread sr\api\_speedrun::createTeleporter((1726.27, -4197.48, -449.875), 100, 100, (426, -4247, 235), 270, "freeze");
    thread sr\api\_speedrun::createTeleporter((246.684, -9168.08, 442.125), 145, 100, (253, -8905, 989), 90, "freeze");
    thread sr\api\_speedrun::createTeleporter((-39.5188, 163.898, 16.125), 60, 100, (-927, 4874, 1295), 0, "freeze", "yellow", "secret_1");

  thread startdoor();
  thread opensecret();
  thread secret();
  thread secretout();
  thread hard_secretout();
  thread entsecret_respawn();
  thread koling_mover();
  thread fix((2574.92, 7108.04, -755.397));
  thread fixv2((468.713, 5511.98, 129.619));
  thread fixv3((1541.74, 5587.7, 154.874));

}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 1500, 900);
	trigger.targetname = "fix";
	trigger.radius = 1500;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

fixv2(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 210, 550);
	trigger.targetname = "fixv2";
	trigger.radius = 210;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

fixv3(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 335, 1500);
	trigger.targetname = "fixv3";
	trigger.radius = 335;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

startdoor()
{
  door = getEnt("startdoor","targetname");


  door delete();
}

opensecret()
{
  trig = getEnt("trig_opensecret","targetname");
  stairs = getEnt("secret_stairs","targetname");
  ladder = getEnt("secret_ladder","targetname");

  stairs delete();
  ladder movex(3,0.1);


}

secret()
{
      trig=getent("trig_secret","targetname");
      targ=getent("secret","targetname");

      for(;;)
      {
      trig waittill("trigger",player);

      player thread sr\api\_speedrun::changeWay("secret_0");  

      player setorigin(targ.origin);
      player setplayerangles(targ.angles);
      player freezecontrols(1);
      wait 0.1;
      player freezecontrols(0);
      }
}

secretout()
{
      trig=getent("trig_secretout","targetname");
      targ=getent("secretout","targetname");

      for(;;)
      {
      trig waittill("trigger",player);

      player thread sr\api\_speedrun::finishWay("secret_1");

      }
}

hard_secretout()
{
        trig=getent("trig_hard_secretout","targetname");
        targ=getent("hard_secretout","targetname");

       for(;;)
        {
        trig waittill("trigger",player);

        player thread sr\api\_speedrun::finishWay("secret_0");

        }
    }

entsecret_respawn()
{
      trig=getent("trig_entsecret_respawn","targetname");
      targ=getent("entsecret_respawn","targetname");

      while(1)
      {
      trig waittill("trigger",player);

      player Suicide();
      }
}

koling_mover()
{
    mover = getent("mover","targetname");

    
    mover movey(-300,0.1);
    mover waittill("movedone");
    mover rotateYaw(90,0.1);
   
}
