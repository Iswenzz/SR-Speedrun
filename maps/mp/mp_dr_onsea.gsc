main()
{	
       	maps\mp\_load::main();
    
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar("r_specularcolorscale","1");
    setdvar("r_glowbloomintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
    setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
   
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-1311, -861, -132), 360);
	thread sr\api\_speedrun::createTeleporter((-319.732, 886.41, 16.625), 60, 100, (477, 152, 92), 360, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((780.816, -4088.64, -399.875), 145, 100);

       
	  entTransporter2 = getentarray("goin","targetname"); 
  if(isdefined(entTransporter2)) 
  { 
    for(lp=0;lp<entTransporter2.size;lp=lp+1) 
      entTransporter2[lp] thread Transporter2(); 
  }  
	 
    
	thread secret0_enter();
	thread trap4();
	thread trap8();
    thread trap9();
	thread fail1();
	thread fail2();
	thread fail3();
	thread Transporter2();
	

}

secret0_enter()
{
	trig = spawn("trigger_radius",(-1309.54, -705.3, -191.875), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("spot1","targetname");

	
	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);
        
		player thread sr\api\_speedrun::changeWay("secret_0");   

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

 trap4() 
   {
    trigger = getent( "trap4_trigger", "targetname" );
    bounce = getEnt("bouncemove", "targetname");
	spike = getEnt("spikes", "targetname");
	hurt02 = getEnt("hurt2", "targetname");
	
	hurt02 delete();
	spike delete();
 
  }
  
  

trap8()
{
    trig = getEnt( "trap8_trigger", "targetname" );
	fall01 = getEnt( "fall1", "targetname" );
	hurt1 = getEnt ("fall01_hurt", "targetname");
	origin = getEnt ("fall_origin", "targetname");
	fall02 = getEnt( "fall2", "targetname" );
	hurt2 = getEnt ("fall02_hurt", "targetname");
	origin2 = getEnt ("fall2_origin", "targetname");
	fall03 = getEnt( "fall3", "targetname" );
	hurt3 = getEnt ("fall03_hurt", "targetname");
	origin3 = getEnt ("fall3_origin", "targetname");
	fall04 = getEnt( "fall4", "targetname" );
	hurt4 = getEnt ("fall04_hurt", "targetname");
	origin4 = getEnt ("fall4_origin", "targetname");
	
	fall01 delete();
	fall02 delete();
	fall03 delete();
	fall04 delete();
	hurt1 delete();
	hurt2 delete();
	hurt3 delete();
	hurt4 delete();
}

trap9()
{
    exp01 = getEnt("expl1","targetname");
	origin1 = getEnt ("exp1_origin","targetname");
	exp02 = getEnt ("exp2","targetname");
	origin2 = getEnt("exp2_origin","targetname");
	exp03 = getEnt("exp3","targetname");
	origin3 = getEnt ("exp3_origin","targetname");
	dmg1 = getEnt("damage1","targetname");
	dmg2 = getEnt("damage2","targetname");
	dmg3 = getEnt("damage3","targetname");
	
	dmg1 delete();
	dmg2 delete();
	dmg3 delete();
}	

fail1()
{
    trig = getEnt ("rf1_trigger", "targetname");
    rf01 = getEnt ("auto56", "targetname");

    
    for(;;)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(rf01.origin);
        player SetPlayerAngles( rf01.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

fail2()
{
    trig = getEnt ("rf2_trigger", "targetname");
    rf02 = getEnt ("auto57", "targetname");

    
    for(;;)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(rf02.origin);
        player SetPlayerAngles( rf02.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

fail3()
{
    trig = getEnt ("secretres_trig", "targetname");
    rf03 = getEnt ("auto58", "targetname");

    
    for(;;)
    {
        trig waittill ("trigger", player);  
        player SetOrigin(rf03.origin);
        player SetPlayerAngles( rf03.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

 Transporter2() 
{ 
  while(true) 
  { 
    self waittill("trigger",player); 
    entTarget = getent(self.target, "targetname"); 

    player thread sr\api\_speedrun::finishWay("secret_0");
  } 
} 

