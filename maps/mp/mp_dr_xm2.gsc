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
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-454, 280, -948), 180);
	
	thread start();
	thread flor1();
	thread flor2();
	thread sec_enter();
	thread sec_exit();
	thread sec_fail();
	
}

flor1()
{
    flor1 = getent("flor1","targetname");
    flor2 = getent("flor2","targetname");
	


    flor1 moveY(950,0.1);
	flor1 waittill("movedone");
	flor1 movex(520,0.1);
   
       
}

flor2()
{
    flor2 = getent("flor2","targetname");
	

    flor2 moveY(600,0.1);
	flor2 waittill("movedone");
    flor2 movex(200,0.1);
  
       
}

start()
{
    up = getent("up","targetname");
    startele = getent("startele","targetname");
	trap4 = getent("trap4","targetname");
	hurt = getent("trap4_killtrig","targetname");

    up delete();
	startele delete();
	trap4 delete();
	hurt delete();
    
       
}

sec_enter()
{
	trig = spawn("trigger_radius",(-665.036, 135.629, -1007.88), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("auto164","targetname");

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

sec_exit()
{
	trig = getEnt ("exits", "targetname");

	for(;;)
    {
    trig waittill ("trigger", player);  

	player thread sr\api\_speedrun::finishWay("secret_0");        

	}
}


sec_fail()
{
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );

		player Suicide();
		
	}
}