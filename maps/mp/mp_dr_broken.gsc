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
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((0, -180, 60), 270);
	
	thread c4();
	thread c4_sub();
	thread tp_patch_1();
	thread tp_patch_2();
	thread teleporter_thread();

	
}

c4()
{
	brush1 = getEnt ("c4_brush1","targetname");
	brush2 = getEnt ("c4_brush2","targetname");

	brush1 delete();

  
	
}

c4_sub()
{
	fx1 = getEnt ("c4_fx1","targetname");
	fx2 = getEnt ("c4_fx2","targetname");
	model1 = getEnt ("auto22","targetname");
	model2 = getEnt ("auto23","targetname");
    
	fx1 delete();
	fx2 delete();
	model1 delete();
	model2 delete();
	
}

tp_patch_1()
{
    trig = getent("move1_trigger", "targetname");

    ori = spawn("script_origin",(8,-2043,348));
	ori.angles = (0,270,0);

    thread sr\api\_map::createTriggerFx(trig, "blue");
   
   for(;;)
   {
    trig waittill("trigger",player);

    player setOrigin(ori.origin);
	player SetPlayerAngles(ori.angles);
	player FreezeControls(1);
	wait 0.05;
	player FreezeControls(0);
   
   }
}

tp_patch_2()
{
	trig = spawn("trigger_radius",(-1077.87, 3070.87, 160.125), 0, 85, 100);
	trig.radius = 85;

	ori = spawn("script_origin",(3065,-4212,1629));
	ori.angles = (0,270,0);


	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player FreezeControls(1);
		wait 0.05;
		player FreezeControls(0);
	}
}

teleporter_thread()
{

	entTransporter= getentarray("teleport","targetname");
	if(isdefined(entTransporter))
 
		{
			for(lp=0; lp<entTransporter.size;lp=lp+1)
			entTransporter [lp] thread teleporter();
		}
}

teleporter()
{
  while(true)
  {
    self waittill("trigger",other);
    entTarget = getent(self.target, "targetname");

    other setorigin(entTarget.origin);
    other setplayerangles(entTarget.angles);
    other FreezeControls(1);
	wait 0.05;
	other FreezeControls(0);

   }
}