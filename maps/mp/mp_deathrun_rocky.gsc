main()
{
 maps\mp\_load::main();
 
 precacheItem("knife_mp");
 PreCacheShellShock( "tankblast" );
 
 level.smokefx = LoadFX( "smoke/wall_explosion_smoke" );
 level.firefx = LoadFX( "fire/window_fire_large" );

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 setdvar( "r_specularcolorscale", "1" );
 setdvar("r_glowbloomintensity0",".25");
 setdvar("r_glowbloomintensity1",".25");
 setdvar("r_glowskybleedintensity0",".3");
 setdvar("compassmaxrange","1800");

 thread sr\api\_speedrun::createNormalWays("Normal Way;");
 thread sr\api\_speedrun::createSecretWays("Secret Way;");
 thread sr\api\_map::createSpawn((-1799, 99, 604), 360);
 thread sr\api\_speedrun::createTeleporter((-1805.97, -86.3005, 544.125), 60, 100, (-934, 2670, -602), 0, "freeze", "yellow", "secret_0");
 

thread fix((241.557, 2317.18, -661.875));
thread fix1((-155.481, 2175.3, -661.875));
thread secretfail();
thread secretfinish();
thread startdoor();
thread trap2();
thread trap3();
thread trap8();
thread trap9();
thread trap10();


}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 70, 300);
	trigger.targetname = "fix";
	trigger.radius = 70;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

fix1(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 150, 300);
	trigger.targetname = "fix1";
	trigger.radius = 150;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}


startdoor()
{
 brush = getent("startdoor", "targetname");
 
	
	brush delete();
	
}

trap2()
{

	thread ahammers();
	thread bhammers();

}

ahammers()
{
 brush = getEnt( "t2ahamrs", "targetname" );
 

	brush rotateroll( 90, 0.1);
	
}

bhammers()
{
 brush = getEnt( "t2bhamrs", "targetname" );
  
 
	brush rotateroll( -90, 0.1);
	

}

trap3()
{
 trig = getEnt( "t3acti", "targetname" );
 brush = getEnt( "t3smasher", "targetname" );
 hurt = getEnt( "smasherhurt", "targetname" );
 
	hurt delete();
	
}
trap8()
{
 trig = getEnt( "t8acti", "targetname" );
 brusha = getEnt( "t8s1", "targetname" );
 brushb = getEnt( "t8s2", "targetname" );
 hurta = getEnt( "t8hurt1", "targetname" );
 hurtb = getEnt( "t8hurt2", "targetname" );
 
    hurta delete();
    hurtb delete();
  
}

trap9()
{
 trig = getEnt( "t9acti", "targetname" );
 brusha = getEnt( "t9s1", "targetname" );
 brushb = getEnt( "t9s3", "targetname" );
 hurta = getEnt( "t9hurt1", "targetname" );
 hurtb = getEnt( "t9hurt3", "targetname" );
 
 hurta delete();
 hurtb delete();
}

trap10()
{
 trig = getEnt( "t10acti", "targetname" );
 brusha = getEnt( "t10s1", "targetname" );
 brushb = getEnt( "t10s2", "targetname" );
 hurta = getEnt( "t10hurt1", "targetname" );
 hurtb = getEnt( "t10hurt2", "targetname" );
 
    hurta delete();
    hurtb delete();
}

secretfail()
{
	trig = getent("secretfail", "targetname");
	fail = getent("unknown", "targetname");
	
	for(;;)
	{
		trig waittill ( "trigger", player );

		player Suicide();
	}
}	

secretfinish()
{
	trig = getent("endof", "targetname");
	finish = getent("secret", "targetname");
	
	for(;;)
	{
	trig waittill ( "trigger", player );

	player thread sr\api\_speedrun::finishWay("secret_0");

		
	}
}	