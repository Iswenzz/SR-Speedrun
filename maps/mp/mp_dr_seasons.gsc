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
	setdvar("compassmaxrange","1500");
	setdvar("bg_fallDamageMinHeight","100000000");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((156, 44, 4), 270);
	

thread door();
thread trap7();
thread sr_tp();
thread secret_fail();
thread secret_end();
thread fix((-491.066, 39.1116, 1296.13));

}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 125, 145);
	trigger.targetname = "fix";
	trigger.radius = 125;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

door()
{
trig = getent("door_trig","targetname");
door = getent("door","targetname");

door delete();

}

trap7()
{
	trig = getent("trap7_trigger","targetname");
	a	= getent( "trap7_a", "targetname" );
	b	= getent( "trap7_b", "targetname" );
	
	a moveY (-150, 0.1);
	b moveY (150, 0.1);
	
}

sr_tp()
{
	trig = spawn("trigger_radius",(284.782, 43.9471, -55.8750), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("secretstart","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");  

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

secret_fail()
{
    trig = getEnt ("secretback", "targetname");
    end = getEnt ("secretstart", "targetname");

    
    for(;;)
    {
        trig waittill ("trigger", player);  

        player Suicide();
       
	}
}

secret_end()
{
    trig = getEnt ("secretend", "targetname");
    end = getEnt ("secretbol", "targetname");

    
    for(;;)
    {
        trig waittill ("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}
