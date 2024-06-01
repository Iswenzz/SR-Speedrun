main()
{
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

  thread sr\api\_speedrun::createNormalWays("Normal Way;");
  thread sr\api\_speedrun::createSecretWays("Secret Way;");
  thread sr\api\_map::createSpawn((-768, 2590, 76), 270);
  thread sr\api\_speedrun::createTeleporter((-3077.01, -1951.41, 128.125), 100, 100, (-2672, -2034, 732), 15, "freeze");
  thread sr\api\_speedrun::createTeleporter((-967.247, 2598.21, 18.125), 60, 100, (-2264, -744, 333), 180, "freeze", "orange", "secret_0");

thread anti_glitch();  
thread startgate();  
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
thread trap7();
thread teleport();
thread teleport2();
thread teleport5();
thread teleport6();

}

anti_glitch()
{
	trig = spawn("trigger_radius",(-3130.82, -64.464, 464.375), 0, 185, 100);
	trig.radius = 185;

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player Suicide();

	}
}

startgate()
{
  gate = getent("gate","targetname");
  
  gate delete();
}

trap2()
{
 trigger = getent("trap2_switch","targetname");
 
 ball3 = getent("ball3","targetname");
 statue2 = getent("statue2","targetname");
 killtrigger3 = getent("ball3_hurt","targetname");

 ball3 delete();
 killtrigger3 delete();

}

trap3()
{
 trigger = getent("trap3_switch","targetname");
 
 ball4 = getent("ball4","targetname");
 statue3 = getent("statue3","targetname");
 
 killtrigger4 = getent("ball4_hurt","targetname");

 ball4 delete();
 killtrigger4 delete();

}

trap4()
{
 
 trigger = getent("trap4_switch","targetname");
 
 ball5 = getent("ball5","targetname");
 ball6 = getent("ball6","targetname");
 ball7 = getent("ball7","targetname");
 ball8 = getent("ball8","targetname");
 statue4 = getent("statue4","targetname");
 platform = getent("platform","targetname");
 killtrigger5 = getent("ball5_hurt","targetname");
 killtrigger6 = getent("ball6_hurt","targetname");
 killtrigger7 = getent("ball7_hurt","targetname");
 killtrigger8 = getent("ball8_hurt","targetname");

 ball5 delete();
 ball6 delete();
 ball7 delete();
 ball8 delete();
 killtrigger5 delete();
 killtrigger6 delete();
 killtrigger7 delete();
 killtrigger8 delete();

}

teleport()
{

 trigger = getent("jumper_teleport1","targetname");
 jumper_teleport1_origin = getent("jumper_teleport1_origin","targetname");
 
 for(;;)
 {
	trigger waittill ("trigger", player );
  player setorigin(jumper_teleport1_origin.origin);
	player setPlayerAngles(jumper_teleport1_origin.angles );
  player FreezeControls(1);
  wait 0.1;
  player FreezeControls(0);

  }
}

teleport2()
{

 trigger = getent("jumper_teleport2","targetname");
 jumper_teleport2_origin = getent("jumper_teleport2_origin","targetname");
 
 for(;;)
  {
	trigger waittill ("trigger", player );
  player setorigin(jumper_teleport2_origin.origin);
	player setPlayerAngles(jumper_teleport2_origin.angles );
  player FreezeControls(1);
  wait 0.1;
  player FreezeControls(0);

  }
}

teleport5()
{
 
 trigger = getent("secret_teleport1_fall","targetname");
 secret_teleport1_fall_origin = getent("secret_teleport1_fall_origin","targetname");
 
 for(;;)
  {
	trigger waittill ("trigger", player );
  player Suicide();
					
  }
}
teleport6()
{
 
 trigger = getent("secret_teleport2","targetname");
 secret_teleport2_origin = getent("secret_teleport2_origin","targetname");
 
 for(;;)
{
	trigger waittill ("trigger", player );

  player thread sr\api\_speedrun::finishWay("secret_0");
           
}
}

trap5()
{
 trigger = getent("trap5_switch","targetname");
 
 ball10 = getent("ball10","targetname");
 ball11 = getent("ball11","targetname");
 ball12 = getent("ball12","targetname");
 ball13 = getent("ball13","targetname");
 statue5 = getent("statue5","targetname");
 killtrigger10 = getent("ball10_hurt","targetname");
 killtrigger11 = getent("ball11_hurt","targetname");
 killtrigger12 = getent("ball12_hurt","targetname");
 killtrigger13 = getent("ball13_hurt","targetname");

 ball10 delete();
 ball11 delete();
 ball12 delete();
 ball13 delete();
 killtrigger10 delete();
 killtrigger11 delete();
 killtrigger12 delete();
 killtrigger13 delete();

}

trap6()
{
 trigger = getent("trap6_switch","targetname");
 
 ball14 = getent("ball14","targetname");
 statue6 = getent("statue6","targetname");
 
 killtrigger14 = getent("ball14_hurt","targetname");

 ball14 delete();
 killtrigger14 delete();

}

trap7()
{
 trigger = getent("trap7_switch","targetname");
 
 ball15 = getent("ball15","targetname");
 ball16 = getent("ball16","targetname");
 ball17 = getent("ball17","targetname");
 ball18 = getent("ball18","targetname"); 
 statue7 = getent("statue7","targetname");
 killtrigger15 = getent("ball15_hurt","targetname");
 killtrigger16 = getent("ball16_hurt","targetname");
 killtrigger17 = getent("ball17_hurt","targetname");
 killtrigger18 = getent("ball18_hurt","targetname");

 ball15 delete();
 ball16 delete();
 ball17 delete();
 ball18 delete();
 killtrigger15 delete();
 killtrigger16 delete();
 killtrigger17 delete();
 killtrigger18 delete();

}
