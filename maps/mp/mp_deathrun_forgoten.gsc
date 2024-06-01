main()
{
	

trigger = getent("teleport4_trigger", "targetname");	
trigger.targetname = "endmap_trig";

 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
 
    setdvar( "r_specularcolorscale", "1" );
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
    setdvar( "compassmaxrange", "1800" );
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );
	

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-507, 4336, 204), 270);
	thread sr\api\_speedrun::createTeleporter((-330.998, 4328.79, 144.125), 60, 100, (-513, -2171, -476), 270, "freeze", "yellow", "secret_0");

	thread trap4();
	thread trap5();
	thread trap6();
	thread trap10();
	thread hard_way();
	thread hard_way1();
	thread hard_way2();
	thread hard_way3();
	thread hard_way4();
	thread hard_way5();
	thread hard_way6();
	thread hard_way7();
	thread hard_way8();
	thread hard_way9();
	thread hard_way10();
	thread hard_way11();
	thread teleport();
	thread sec_end();


}


hard_way()
{
trig = getEnt( "hard_trig", "targetname" );
laser1 = getent("hard_laser1", "targetname");
laser2 = getent("hard_laser2", "targetname");	

laser1 delete();
laser2 delete();
}

hard_way1()
{
trig = getEnt( "hard_trig", "targetname" );
laser3 = getent("hard_laser3", "targetname");
laser4 = getent("hard_laser4", "targetname");	

laser3 delete();
laser4 delete();

}

hard_way2()
{
trig = getEnt( "hard_trig", "targetname" );
laser5 = getent("hard_laser5", "targetname");
laser6 = getent("hard_laser6", "targetname");	

laser5 delete();
laser6 delete();

}

hard_way3()
{
trig = getEnt( "hard_trig", "targetname" );
laser7 = getent("hard_laser7", "targetname");
laser8 = getent("hard_laser8", "targetname");
hurt1 = getEnt ("trap7_hurt1", "targetname");
hurt2 = getEnt ("trap8_hurt2", "targetname");  

  
    laser7 delete();
    laser8 delete();
   
}

hard_way4()
{
trig = getEnt( "hard_trig", "targetname" );
laser9 = getent("hard_laser9", "targetname");
laser10 = getent("hard_laser10", "targetname");
hurt1 = getEnt ("trap9_hurt1", "targetname");
hurt2 = getEnt ("trap10_hurt2", "targetname");  


    laser9 delete();
    laser10 delete();

    
}

hard_way5()
{
trig = getEnt( "hard_trig", "targetname" );
laser11 = getent("hard_laser11", "targetname");
laser12 = getent("hard_laser12", "targetname");
hurt1 = getEnt ("trap11_hurt1", "targetname");
hurt2 = getEnt ("trap12_hurt2", "targetname");  


    laser11 delete();
    laser12 delete();
   
}



hard_way6()
{
trig = getEnt( "hard_trig", "targetname" );
spikes1 = getent("hard_spikes1", "targetname");
spikes2 = getent("hard_spikes2", "targetname");	

	spikes1 delete();
	spikes2 delete();
	
}

hard_way7()
{
trig = getEnt( "hard_trig", "targetname" );
spikes3 = getent("hard_spikes3", "targetname");
spikes4 = getent("hard_spikes4", "targetname");	

	spikes3 delete();
	spikes4 delete();
	
	
}

hard_way8()
{
trig = getEnt( "hard_trig", "targetname" );
spikes5 = getent("hard_spikes5", "targetname");
spikes6 = getent("hard_spikes6", "targetname");	

	spikes5 delete();
	spikes6 delete();
	
}

hard_way9()
{
 
trig = getEnt( "hard_trig", "targetname" );
left = getEnt( "hard_plat1", "targetname" );
right = getEnt( "hard_plat2", "targetname" );
 

}

hard_way10()
{
 
trig = getEnt( "hard_trig", "targetname" );
lasend1 = getEnt( "hard_lasers1_end", "targetname" );
lasend2 = getEnt( "hard_lasers2_end", "targetname" );
lasend3 = getEnt( "hard_lasers3_end", "targetname" );

lasend1 delete();
lasend2 delete();
lasend3 delete();

}

hard_way11()
{
trig = getEnt( "hard_trig", "targetname" );
lasend4 = getent("hard_lasers4_end", "targetname");
lasend5 = getent("hard_lasers5_end", "targetname");	

	lasend4 delete();
	lasend5 delete();
	
}


trap4()
{

trig = getEnt( "trap4_trig", "targetname" );
trap4_a = getEnt( "trap4_a", "targetname" );
trap4_b = getEnt( "trap4_b", "targetname" );
trap4_c = getEnt( "trap4_c", "targetname" );
hurt1 = getEnt ("trap4_hurt_a", "targetname"); 
hurt2 = getEnt ("trap4_hurt_b", "targetname"); 
hurt3 = getEnt ("trap4_hurt_c", "targetname"); 

 

    hurt1 delete();
    hurt2 delete();
    hurt3 delete();
  

}

trap5()
{

trig = getEnt( "trap5_trig", "targetname" );
trap5_a = getEnt( "trap5_a", "targetname" );
trap5_b = getEnt( "trap5_b", "targetname" );
trap5_c = getEnt( "trap5_c", "targetname" );
hurt4 = getEnt ("trap5_hurt_a", "targetname"); 
hurt5 = getEnt ("trap5_hurt_b", "targetname"); 
hurt6 = getEnt ("trap5_hurt_c", "targetname"); 


    hurt4 delete();
    hurt5 delete();
    hurt6 delete();
	

}

trap6()
{

trig = getEnt( "trap6_trig", "targetname" );
trap6 = getEnt( "trap6", "targetname" );
hurt = getEnt ("trap6_hurt", "targetname"); 
hurt1 = getEnt ("trap6_hurt_a", "targetname"); 
hurt2 = getEnt ("trap6_hurt_b", "targetname"); 
hurt3 = getEnt ("trap6_hurt_c", "targetname"); 
hurt4 = getEnt ("trap6_hurt_d", "targetname"); 
hurt5 = getEnt ("trap6_hurt_e", "targetname"); 

trap6 delete();
hurt delete();
hurt1 delete();
hurt2 delete();
hurt3 delete();
hurt4 delete();
hurt5 delete();

 

}	



trap10()
{

trig = getEnt( "trap10_trig", "targetname" );
trap10_a = getEnt( "trap10_a", "targetname" );
trap10_b = getEnt( "trap10_b", "targetname" );
hurt_a = getEnt ("trap10_hurt_a", "targetname"); 
hurt_b = getEnt ("trap10_hurt_b", "targetname"); 


    hurt_a delete();
    hurt_b delete();

}


teleport()
{

	target = getEnt( "teleport_target", "targetname" );
	trig = getent("teleport_trigger", "targetname");
	
	for(;;)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player FreezeControls(1);
	wait 0.1;
	player FreezeControls(0);
}
}


sec_end()
{
	trig = getent("teleport9_trigger", "targetname");
	
	for(;;)
{
	trig waittill ("trigger", player);
	
	player thread sr\api\_speedrun::finishWay("secret_0");
}
}
