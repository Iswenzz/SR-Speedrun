main()
{
thread sr\api\_map::createSpawn((-9, 227, 16), 90);
 maps\mp\_load::main();

 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";
       
///DVARS       
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((450.04, 291.923, 16.125), 60, 20, (2826, 2943, 2372), 90, "freeze", "yellow", "secret_0");

thread startdoor();
thread tp1();
thread tp2();
thread tp3();
thread movingplat();
thread secfail();
thread secfinish();

}

startdoor()
{
	startdoor = getent("startdoor","targetname");
	
    wait 0.1;
	startdoor Delete();

 	
}

tp1()
{
   trig = getent("telestage1", "targetname");
   tele1 = getent ("originstage1", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}


tp2()
{
   trig = getent("telestage2", "targetname");
   tele1 = getent ("originstage2", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

tp3()
{
   trig = getent("telestage3", "targetname");
   tele1 = getent ("originstage3", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

movingplat()
{
movingplata = getent("mover1","targetname");
movingplatb = getent("mover2","targetname");

wait 0.1;
movingplata moveY(180,0.1);
movingplatb moveX(-160,0.1);
wait 0.3;
movingplata moveX(-510,0.1);
movingplatb moveY(-190,0.1);

}

secfail()
{
   trig = getent("tp_secret", "targetname");
   tele1 = getent ("originsecretre", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

secfinish()
{
   trig = getent("trigger_complete", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}