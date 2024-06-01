main()
{

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
    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998 );

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((1558, 16156, 76), 180);
    thread sr\api\_speedrun::createTeleporter((1552.52, 16303, 16.125), 60, 100, (4222, 1230, 1805), 0, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((1662.97, 14718.2, 16.125), 210, 100);

    thread start();
    thread fail_dead1();
    thread fail_dead2();
    thread fail_dead2a();
    thread fail_dead3();
    thread fail_dead4();
    thread fail_dead4a();
    thread fail_dead4b();
    thread fail_dead5();
    thread fail_dead5a();
    thread fail_dead6();
    thread fail_dead7();
    thread hard_end();

}

start()
{
    move = getent("passerelle_b","targetname");
    startdoor = getent("startdoor","targetname");
    
    startdoor delete();
    move movex(-270,0.1);
    move waittill ("movedone");
    move rotateYaw(90,0.1);
    

   
}

fail_dead1()
{
	trig = getEnt("triggerhardun", "targetname");
	orig = getEnt ("secrethardorigin", "targetname");

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

fail_dead2()
{
	trig = getEnt("triggerharddeuxtp", "targetname");
	orig = getEnt ("triggerharddeux", "targetname");

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

fail_dead2a()
{
	trig = getEnt("triggerharddeuxtpe", "targetname");
	orig = getEnt ("triggerharddeux", "targetname");

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

fail_dead3()
{
	trig = getEnt("triggerhardtroistp", "targetname");
	orig = getEnt ("triggerhardtrois", "targetname");

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

fail_dead4()
{
	trig = getEnt("triggerhardquatretp", "targetname");
	orig = getEnt ("triggerhardquatre", "targetname");

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

fail_dead4a()
{
	trig = getEnt("triggerhardquatretpb", "targetname");
	orig = getEnt ("triggerhardquatre", "targetname");

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

fail_dead4b()
{
	trig = getEnt("triggerhardquatretpc", "targetname");
	orig = getEnt ("triggerhardquatre", "targetname");

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

fail_dead5()
{
	trig = getEnt("triggerhardcinqtpa", "targetname");
	orig = getEnt ("triggerhardcinq", "targetname");

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

fail_dead5a()
{
	trig = getEnt("triggerhardcinqtpe", "targetname");
	orig = getEnt ("triggerhardcinq", "targetname");

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

fail_dead6()
{
	trig = getEnt("triggerhardsixxxb", "targetname");
	orig = getEnt ("triggerhardsix", "targetname");

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

fail_dead7()
{
	trig = getEnt("triggerhardsixxxc", "targetname");
	orig = getEnt ("triggerhardsix", "targetname");

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


hard_end()
{
	trig = getEnt("hardsecendtp", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);

			player thread sr\api\_speedrun::finishWay("secret_0");
			
		}
}