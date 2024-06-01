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
	setdvar("compassmaxrange","1200");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_map::createSpawn((9,-40,76),90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;");
	thread sr\api\_speedrun::createTeleporter((-113.794, -39.9438, 16.125), 60, 100, (2668, 5032, 1372), 90, "freeze", "green", "secret_0");
	thread sr\api\_speedrun::createTeleporter((130.073, -39.953, 16.125), 60, 100, (-5321, -11334, -1780), 270, "freeze", "orange", "secret_1");
	thread sr\api\_speedrun::createEndMap((-2125.25, 3058.88, -463.875), 115, 100, "normal_0");
 
	thread startdoor();
	thread door1();
	thread door2_1();
	thread door2_2();
	thread enddoor1();
	thread enddoor2();	
	thread easysecretrespawn();
	thread hardsecretrespawn();
	thread hard_end();
	thread ez_end();	
}

startdoor()
{
	door = getent("startdoor", "targetname");
	
	door delete();
}
	
door1()
{
	door1 = getent("door1", "targetname");
	
	door1 delete();
}	

door2_1()
{
	door2_1 = getent("door2_1", "targetname");
	
	door2_1 delete();
}

door2_2()
{
	door2_2 = getent("door2_2", "targetname");

	door2_2 delete();
}

enddoor1()
{
	enddoor1 = getent("enddoor_1", "targetname");
	
	enddoor1 delete();
}

enddoor2()
{
	enddoor2 = getent("enddoor_2", "targetname");

	enddoor2 delete();
}

easysecretrespawn()
{
	easysecretrespawntrig = getent("trig_easysecretrespawn", "targetname");
	easysecretrespawnorigin = getent("origin_easysecretrespawn", "targetname");
	for(;;)
	{
		
easysecretrespawntrig waittill ("trigger", player);
player setOrigin(easysecretrespawnorigin.origin);
		
}
}

hard_end()
{
	hardsecretdonetrig = getent("trig_hardsecretdone", "targetname");
	hardsecretdoneorigin = getent("origin_hardsecretdone", "targetname");

	for(;;)
	{
	hardsecretdonetrig waittill ("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_1");
    }
}

hardsecretrespawn()
{
	hardsecretrespawntrig = getent("trig_hardsecretrespawn", "targetname");
	hardsecretrespawnorigin = getent("origin_hardsecretrespawn", "targetname");
	for(;;)
	{
		
hardsecretrespawntrig waittill ("trigger", player);
player setOrigin(hardsecretrespawnorigin.origin);
		
}
}

ez_end()
{
	teleport2trig = getent("trig_secret2end", "targetname");
	teleport2 = getent("origin_secret2end", "targetname");

	for(;;)
	{
	teleport2trig waittill ("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_0");
		
    }
}