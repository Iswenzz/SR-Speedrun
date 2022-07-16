main()
{
 maps\mp\_load::main();

 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";
            
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread speedrun\_way_name::create_spawn((6,0,68),90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_tp((-255.715, 537.858, 8.125), 65, 20, (-7494, 288, 60), 90, "freeze", "yellow", "s0");

thread startdoor();
thread tp1();
thread tp2();
thread tp3();
thread secfail1();
thread secfail2();
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
   trig = getent("jumper_tele1", "targetname");
   tele1 = getent ("jumper_origin", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

tp2()
{
   trig = getent("jumper_tele2", "targetname");
   tele1 = getent ("jumper_origin", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

tp3()
{
   trig = getent("jumper_tele3", "targetname");
   tele1 = getent ("jumper_origin", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

secfail1()
{
   trig = getent("jumprespawn1", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player suicide(); 
    }
}

secfail2()
{
   trig = getent("jumprespawn2", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    player suicide();  
    }
}

secfinish()
{
   trig = getent("jumpendtrigger", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    player thread speedrun\_way_name::finish_way("s0");
    }
}