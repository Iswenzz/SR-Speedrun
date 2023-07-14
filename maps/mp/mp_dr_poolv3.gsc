//Map by CM'Death
//Discord:Death#7416
main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";
 
	setdvar("g_speed" ,"210");
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((1005, -1532, 124),180);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^2Easy Way;^1Hard Way");
    thread sr\api\_speedrun::createTeleporter((740.709, -1383.3, 64.125), 70, 70, (-2984, -7976, 3900), 0, "freeze", "green", "secret_0");
    thread sr\api\_speedrun::createTeleporter((740.709, -1689.23, 64.125), 70, 70, (-2984, -7976, 3900), 0, "freeze", "red", "secret_1");
    thread sr\api\_speedrun::createEndMap((514.061, -1540.43, 1216.13), 180, 495);

    //thread something();
    thread somethingnoob();
    thread somethingpro();
	thread endele();
	//thread finishdoor();
	//thread endtpa();
	//thread endtpb();

	
}	

//SECRET ENTRANCE
something()
{
   trig = getent("trig_something", "targetname");
   tele1 = getent ("origin_something", "targetname");

  for(;;) 
    {   
     trig setHintString ("^5Give me the hand by pressing ^3[&&1]");
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
   }
}


//SECRET EXIT
somethingnoob()
{
   trig = getent("trig_ezfinish", "targetname");
   tele1 = getent ("origin_somethingfinishnoob", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    
    player thread sr\api\_speedrun::finishWay("secret_0");
	
    }
}

somethingpro()
{
   trig = getent("trig_somethingfinishpro", "targetname");
   tele1 = getent ("origin_somethingfinishpro", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_1");

    }
}

endele()
{

   movingplatform = getent("endele", "targetname");
   movingplatform_trigger = getent("trig_endele", "targetname");
   

   movingplatform delete();
   
}   

finishdoor()
{
   finishdoora = getent("finaldoora", "targetname");
   finishdoorb = getent("finaldoorb", "targetname");
   finishdoor_trigger = getent("trig_finaldoor", "targetname");
   
   finishdoora delete();
   finishdoorb delete();
   
}

endtpa()
{
   trig = getent("trig_endtpa", "targetname");
   tele1 = getent ("origin_end", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    }
}

endtpb()
{
   trig = getent("trig_endtpb", "targetname");
   tele1 = getent ("origin_end", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    }
}

