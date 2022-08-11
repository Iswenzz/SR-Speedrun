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
thread randomchoice ();
thread secret_hurt ();
thread secfinish ();

}	


startdoor()
{
sdoor = getent("startdoor","targetname");

sdoor delete();

}  

randomchoice()
{
trigger = getEnt ("trig_endfail", "targetname");
tele1 = getent ("orig_endfail", "targetname");
tele2 = getent ("orig_secfinish", "targetname");


for(;;)
{
    trigger waittill ("trigger", player);

    player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);

    player iprintlnBOld("^1I saved you from death, but not from long...");
    wait 1;
    player iprintlnBOld("^1Now,I will gamble your life so you might die :)"); 
    wait 4;

    randomtext = randomint(2);

    if (randomtext == 0 )
    {
        player iprintlnBOld("^2You are worthy to live."); 
        player setOrigin(tele2.origin);
        player setPlayerAngles(tele2.angles);    
    }
    if (randomtext == 1)
    {
       player iprintlnBOld("^1You are not worthy to live."); 
       wait 1;
       player suicide ();      
    }
    
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

