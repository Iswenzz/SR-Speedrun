main()
{
 maps\mp\_load::main();

 endmap = getent("endmap_trig","targetname");
 endmap delete();

  game["allies"] = "marines";
  game["axis"] = "opfor";
  game["attackers"] = "axis";
  game["defenders"] = "allies";
  game["allies_soldiertype"] = "desert";
  game["axis_soldiertype"] = "desert";

   thread sr\api\_speedrun::createNormalWays("Strafe Way;Bounce Way;");
   thread sr\api\_map::createSpawn((13, 109, 60), 270);
   thread sr\api\_speedrun::createWay((1340.11, -5999.48, -524.128), 150, 145, "yellow", "normal_1");
   thread sr\api\_speedrun::createTeleporter((-10722.8, -5189.99, 272.125), 120, 100, (-10715, -4581, 344), 90, "freeze", "yellow", "normal_1");
   thread sr\api\_speedrun::createEndMap((-8159.41, -6849.47, -854.875), 175, 100, "normal_0");
   thread sr\api\_speedrun::createEndMap((-9212.37, -1021.38, -1143.37), 145, 100, "normal_1");

  thread door();
  thread jumperarea1();
  thread normal_1_finish();


}

door()
{
  door = getent("door","targetname");
  lift=getent("fencedoor","targetname");

  door delete();
  lift delete();
}


jumperarea1()
{
   trig = getent("trigger_jumperarea1", "targetname");
   tele1 = getent ("origin_jumperarea1", "targetname");
   trig setHintString ("Press [USE] for next stage!");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player FreezeControls(1);
     wait 0.1;
     player FreezeControls(0);
   }
}


normal_1_finish()//cornelia
{
   trig = getent("trigger_jumperarea2", "targetname");
   tele1 = getent ("origin_jumperarea2", "targetname");

   
   for (;;)
    {   
     trig waittill ("trigger", player);

	  player thread sr\api\_speedrun::finishWay("normal_1");
   }
}
