main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
	
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_spawn((-3019,-3243,28),180);
thread speedrun\_way_name::create_tp((5067.83, 2418.18, -11.875), 180, 95, (2176, 4576, 44), 0, "freeze","blue","ns0");
thread speedrun\_way_name::create_tp((2499.06, 8673.66, -11.875), 140, 110, (3581, 8642, 44), 360, "freeze","blue","ns0");

thread secret();
thread tele1();
thread tele2();
thread tele3();
thread tele4();
thread tele5();
thread tele6();
thread tele7();
thread tele8();
thread tele9();
thread tele10();
thread tele11();
thread tele12();
thread tele13();

}

secret()
{
acti = getent("secret_enter", "targetname");
platform = getent("npc_platform", "targetname");
box = getent("box_npc", "targetname");
	
wait 0.1;

acti enablelinkto ();
acti linkto (platform);
platform moveZ (136,0.1);
box delete();
}

tele1()
{    
     trig = getEnt("tele1", "targetname");
	 tele = getEnt("origin_tele1", "targetname");
	 
	 for(;;)
	 {
		trig waittill("trigger", player);
		 
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.1;
        player freezeControls(0);
	 }
}


tele2()
{    
     trig = getEnt("tele2", "targetname");
	 tele = getEnt("origin_tele2", "targetname");
	 
	 for(;;)
	 {
		trig waittill("trigger", player);
		 
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.1;
        player freezeControls(0);
	 }
}

tele3()
{    
     trig = getEnt("tele3", "targetname");
	 tele = getEnt("origin_tele3", "targetname");
	 
	 for(;;)
	 {
		trig waittill("trigger", player);
		 
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.1;
        player freezeControls(0);
	 }
}


tele4()
{    
     trig = getEnt("tele4", "targetname");
	 tele = getEnt("origin_tele4", "targetname");
	 
	 for(;;)
	 {
		trig waittill("trigger", player);
		 
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.1;
        player freezeControls(0);
	 }
}

tele5()
{    
     trig = getEnt("tele5", "targetname");
	 tele = getEnt("origin_tele5", "targetname");
	 
	 for(;;)
	 {
		trig waittill("trigger", player);
		 
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.1;
        player freezeControls(0);
	 }
}

tele6()
{    
     trig = getEnt("tele6", "targetname");
	 tele = getEnt("origin_tele6", "targetname");
	 
	 for(;;)
	 {
		trig waittill("trigger", player);
		 
		player setorigin(tele.origin);
		player setPlayerAngles (tele.angles);
		player freezeControls(1);
        wait 0.1;
        player freezeControls(0);
	 }
}

tele7()
{    
     trig = getEnt("tele7", "targetname");
	 tele = getEnt("origin_tele7", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}

tele8()
{    
     trig = getEnt("tele8", "targetname");
	 tele = getEnt("origin_tele8", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}


tele9()
{    
     trig = getEnt("tele9", "targetname");
	 tele = getEnt("origin_tele9", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}

tele10()
{    
     trig = getEnt("tele10", "targetname");
	 tele = getEnt("origin_tele10", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}

tele11()
{    
     trig = getEnt("tele11", "targetname");
	 tele = getEnt("origin_tele11", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}

tele12()
{    
     trig = getEnt("tele12", "targetname");
	 tele = getEnt("origin_tele12", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player thread speedrun\_way_name::finish_way("s0");
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}

tele13()
{    
     trig = getEnt("secret_enter", "targetname");
	 tele = getEnt("origin_secret", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player thread speedrun\_way_name::change_way("s0");
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.1;
         player freezeControls(0);
	 }
}