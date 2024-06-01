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

	
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((40, -74, 76), 90);
	
	thread teleport();
	thread movera();
	thread moverb();
	thread sec_tele();
	thread sec_entry();
	thread trap4();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap9_a();
	
}

teleport()
{
    trig = getEnt ("teleport_1", "targetname");
	org = getEnt ("teleport1", "targetname");
		
	for(;;)
	{
	trig waittill ("trigger", player);
        
    player SetPlayerAngles( org.angles );
	player setOrigin( org.origin );

    }
	
}
		  	  
	 
movera()
{
  m1 = getEnt ("move_trap3a", "targetname");
  
  
	m1 moveY (200,0.1);
	wait 0.1;
	m1 moveX (180,0.1);
	
	
}

moverb()
{
  m2 = getEnt ("move_trap3b", "targetname");
  
  
	m2 moveY (-100,0.1);
	wait 0.1;
	m2 moveX (-200,0.1);
	
	
}
sec_tele()
{
   trig = getEnt ("tele_sec_easy", "targetname");
   tele = getEnt ("tele_sec_easy_org", "targetname");
   
   for(;;)
     {
	    trig waittill ("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");	
	
    }
}
sec_entry()
{
    trig = getEnt ("secret_easy", "targetname");
	tele = getEnt ("secret_easy_orgin", "targetname");
	 
	for(;;)
	  {
	    trig waittill ("trigger", player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetPlayerAngles( tele.angles );
	    player setOrigin( tele.origin );
		player FreezeControls(1);
	    wait 0.1;
	    player FreezeControls(0);

	  }
}

trap4()
{
   trig = getEnt ("trap4_trig", "targetname");
   push = getEnt ("trap4_push", "targetname");
   hurt = getEnt ("trap4_hurt", "targetname");
   
   push delete();
   hurt delete();
}

hard_respawn()
{
  push = getEnt ("Hard_pushers", "targetname");
  hurt = getEnt ("Hard_pushers_hurt", "targetname");
  
 hurt delete();
 push delete();
	
}

trap7()
{

  close1 = getEnt ("Closer_1", "targetname");
  close2 = getEnt ("Closer_2", "targetname");
  laser1 = getEnt ("trap7_laser1", "targetname");
  laser2 = getEnt ("trap7_laser2", "targetname");
  hurt1 = getEnt ("laser_1_hurt", "targetname");
  hurt2 = getEnt ("laser_2_hurt", "targetname");
  
  close1 delete();
  close2 delete();
  laser1 delete();
  laser2 delete();
  hurt1 delete();
  hurt2 delete();
  
}

trap8()
{
    poster = getEnt ("trap8_killer", "targetname");
	trig = getEnt ("jb_trig", "targetname");
	hurt = getEnt ("jb_hurt", "targetname");
	
    poster delete();
	hurt delete();
}

trap9()
{
  
  trig   = getEnt ("trap_last_trig", "targetname");
  spikes = getEnt ("trap_turn_spikes", "targetname");
  spikes2 = getEnt ("trap_turn_spikes2", "targetname");
  
  plat = getEnt ("trap_turn_platform", "targetname");
  plat2 = getEnt ("trap_turn_platform2", "targetname");
  
  hurt = getEnt ("trap_turn_hurt", "targetname");
  hurt2 = getEnt ("trap_turn_hurt2", "targetname");
  
  
 spikes delete();
 spikes2 delete();
 plat delete();
 hurt delete();

  
}


trap9_a()
{
   mover = getEnt ("trap_movers_transporters", "targetname");

    mover moveX (-304,0.1);
	mover rotateYaw (90,0.1);
	wait 0.3;
	mover rotateRoll (20,0.1);
	
}


  