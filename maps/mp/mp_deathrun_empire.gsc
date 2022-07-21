main()
{
thread sr\api\_map::createSpawnOrigin((-44, -14, 0), 360);
trigger = spawn( "trigger_radius", (1295.09, 1986.1, -632.477), 0, 200, 20 );
trigger.targetname = "endmap_trig";
trigger.radius = 200;
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
	thread sr\api\_speedrun::createTeleporter((3837.89, -35.4303, 16.125), 55, 20, (5288, -1, 76), 360, "freeze", "blue");

    thread sr_tp();
	thread tp1();
	thread secfinish();
    thread startdoor();
	thread pusher();
	thread finish();
	thread trap15();

}

sr_tp()
{
	trig = spawn("trigger_radius",(868.903, 397.294, 16.125), 0, 60, 25);
	trig.radius = 60;
	ori_t = getEnt("gohere5","targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");
		player freezecontrols(1);
		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		wait 0.05;
		player freezecontrols(0);
	}
}

tp1()
{
   trig = getent("enter1", "targetname");
   tele = getent ("gohere1", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

secfinish()
{
   trig = getent("enter6", "targetname");
   tele = getent ("gohere6", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);

	 player thread sr\api\_speedrun::finishWay("secret_0");
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

startdoor()
{
door =getEnt("startdoor", "targetname");
enter5 =getEnt("enter5", "targetname");

wait 0.1;
door delete();
enter5 delete();

}

pusher()
{
	trigger = getEnt ( "pusher", "targetname" );

	while(1)
	{
    	trigger waittill ( "trigger", who );

	    oldpos = who.origin;
	    strenght = 6;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-30,0,0)), "none", 0);
	    }
	}
}

finish()
{
trigger = GetEnt( "finish", "targetname" );

    for(;;)
	{
	trigger waittill ("trigger", player);

    player thread sr\api\_speedrun::finishWay("normal_0");
	}
}

trap15()
{
object = getent("trap15","targetname");
killtrigger1 = getent ("killtrig_15_1" , "targetname");
killtrigger2 = getent ("killtrig_15_2" , "targetname");
killtrigger3 = getent ("killtrig_15_3" , "targetname");

wait 0.1;
killtrigger1 delete();
killtrigger2 delete();
killtrigger3 delete();
object delete();

}