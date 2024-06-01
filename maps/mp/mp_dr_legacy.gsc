main()
{
 maps\mp\_load::main();
 
 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";
            
	setdvar("r_specularcolorscale", "1");
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Jumper Secret;Acti Secret;");
    thread sr\api\_map::createSpawn((-160, -9, 76), 0);
    
	thread startdoor();
    thread acti_secret_enter();
    thread acti_secret_finish();
    thread acti_secret_fail();
    thread secret_ladder();
    thread secret_enter();
    thread secret_finish();
    thread dead_1();
    thread dead_2();


}

startdoor() 
{
	door = getent("legacy_start_door","targetname");

    door delete();

}

acti_secret_enter()
{
	trig = spawn("trigger_radius",(81.972, 267.521, 16.125), 0, 60, 200);
	trig.radius = 60;
	ori_t = getEnt("orig_acti_secret_enter","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}


acti_secret_finish()
{
   trig = getent("trig_acti_secret_finish", "targetname");
   tp = getent ("orig_acti_secret_finish", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_1");

    }
}

acti_secret_fail()
{
   trig = getent("trig_acti_secret_fail", "targetname");
   tp = getent ("orig_acti_secret_enter", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

    player Suicide();

    }
}

secret_ladder()
{
   ladder = getent("secret_ladder", "targetname");
   trig = getent("trig_secret_ladder", "targetname");

    ladder show();
    ladder solid();


} 

secret_enter()
    {
    trig = getEnt ("trig_secret_enter", "targetname");
    tele = getEnt ("orig_secret_enter", "targetname");

    
    for(;;)
    {   
     trig waittill("trigger", player);

	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);

     player thread sr\api\_speedrun::changeWay("secret_0"); 
    
    }
    }

secret_finish()
    {
    trig = getEnt ("trig_secret_finish", "targetname");
    tele = getEnt ("orig_secret_finish", "targetname");

    
    for(;;)
    {   
     trig waittill("trigger", player);

      player thread sr\api\_speedrun::finishWay("secret_1");

    }

    }


dead_1()
{
trig_1 = getent ("trig_bounce_2_off_fail", "targetname");


for(;;)
{
    trig_1 waittill ("trigger", player);

    player Suicide();
}

}

dead_2()
{
trig_2 = getent ("trig_fail", "targetname");


for(;;)
{
    trig_2 waittill ("trigger", player);

    player Suicide();
}

}
