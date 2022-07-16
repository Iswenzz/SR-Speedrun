
main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    
    setDvar("r_gamma","1");
    setDvar("r_specularcolorscale", "1");
    setDvar("r_glowbloomintensity0","1");
    setDvar("r_glowbloomintensity1","1");
    setDvar("r_glowskybleedintensity0","1");
    setDvar("compassmaxrange","1800");
    setDvar("bg_fallDamageMaxHeight", "99999");
    setDvar("bg_fallDamageMinHeight", "99998");
    setDvar("r_specular", "0");

    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way");
	thread secret();
	thread secretend();
    thread onconnect();
	
}	


secret()
{
	trig = getEnt("secret_enter", "targetname");
	o = getEnt("origin_secret", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
	
	}
}


secretend()
{
	trig = getEnt("secret_endtrig", "targetname");
    for(;;)
    {    
	trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
    }

}

onconnect()
{
    level endon("game_ended");
    for(;;)
    {
    level waittill("connected", player);
    player setClientDvar("r_specular", "0");
    }
}

//klein was here ;)