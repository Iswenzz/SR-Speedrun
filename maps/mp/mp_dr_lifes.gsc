main()
{
	//maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-8, 0, 76), 270);

	thread stage2tele();
	thread startdoor();
	thread stage3tele();
	thread secret_enter();
	thread stp1();
	thread stp2();
	thread stp3();
	thread stp4();
	thread secret_finish();
	thread fix((316.391, -663.693, -79.875));


}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 110, 500);
	trigger.targetname = "fix";
	trigger.radius = 110;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}


stage2tele()
{
    trig = getEnt("stage2tele", "targetname");
    target = getEnt("stage2_origin", "targetname");
       
    while(1)
    {
        trig waittill("trigger", player);
                   
        {
        player setOrigin( target.origin );
        player setPlayerAngles( target.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
        }
    }
}

startdoor()
{
	startdoor = getent("startdoor","targetname");
	
	startdoor delete();
}

stage3tele()
{
    trig = getEnt("stage3tele", "targetname");
    target = getEnt("stage3tele_origin", "targetname");
       
    while(1)
    {
        trig waittill("trigger", player);
                   
        {
        player setOrigin( target.origin );
        player setPlayerAngles( target.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
        }
    }
}

secret_enter()
{
	trig = spawn("trigger_radius",(156.917, -0.0421789, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("secretorigin","targetname");

	
	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

stp1()
{
    trig = getEnt("secrettp1", "targetname");
    target = getEnt("secretorigin1", "targetname");
           
    for(;;)
    {
		trig waittill("trigger", player);
                   
            {
            player Suicide();

            }
    }
}

stp2()
{
    trig = getEnt("secrettp2", "targetname");
    target = getEnt("secretorigin2", "targetname");
           
    for(;;)
    {
		trig waittill("trigger", player);
                   
            {
            player Suicide();

            }
    }
}

stp3()
{
    trig = getEnt("secrettp3", "targetname");
    target = getEnt("secretorigin3", "targetname");
           
    for(;;)
    {
		trig waittill("trigger", player);
                   
            {
            player Suicide();

            }
    }
}

stp4()
{
    trig = getEnt("secrettp4", "targetname");
    target = getEnt("secretorigin4", "targetname");
           
    for(;;)
    {
		trig waittill("trigger", player);
                   
            {
            player Suicide();

            }
    }
}

secret_finish()
{
    trig = getEnt("secretfinish", "targetname");
    target = getEnt("secretfinish_orig", "targetname");
           
    while(1)
    {
		trig waittill("trigger", player);
                   
        player thread sr\api\_speedrun::finishWay("secret_0");  
            
    }
}
