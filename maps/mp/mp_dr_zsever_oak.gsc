main()
{
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

thread speedrun\_way_name::create_spawn((-39,109,76),90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_tp((-3709.29, 411.21, 224.125), 65, 25, (-4843, 427, 284), 180, "freeze", "blue", "ns0");
thread speedrun\_way_name::create_tp((299.992, 598.276, 16.125), 70, 25, (-20106, 5042, 408), 180, "freeze", "red", "s0");

thread startdoor();
thread secfail();
thread secfinish();

}

startdoor()
{
	startdoor = getent("startdoor","targetname");
	
    wait 0.1;
	startdoor Delete();

}

secfail()
{
   trig = getent("trig_teleport3", "targetname");
   tele1 = getent ("origin_secret1", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    
    }
}

secfinish()
{
   trig = getent("trig_secret2", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
    player thread speedrun\_way_name::finish_way("s0");
    }
}