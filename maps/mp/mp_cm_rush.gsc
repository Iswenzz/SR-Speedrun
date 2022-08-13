main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";
 
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((-6,-106,76),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((279.016, 117.702, 16.125), 70, 50, (-3919, 982, 60), 270, "freeze", "cyan", "secret_0");

thread startdoor ();
thread secret_hurt ();
thread secfinish ();

}	


startdoor()
{
sdoor = getent("startdoor","targetname");

sdoor delete();

}  

}

secret_hurt()
{
fail_trigger = getent("trig_fail","targetname");

    for(;;)
    {
    fail_trigger waittill("trigger",player);
    player Suicide();
    }
}

secfinish()
{
   trig = getent("trig_secfinish", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_0");
   
    }
}

