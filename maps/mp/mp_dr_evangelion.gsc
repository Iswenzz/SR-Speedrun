main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1.8" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((3, -100, 76), 270);
	thread sr\api\_speedrun::createTeleporter((-2776.82, 445.219, -975.375), 125, 100, (-2816, 3145, 380), 90, "freeze");
	thread sr\api\_speedrun::createTeleporter((145.035, -99.9968, 16.125), 60, 100, (3112, -1314, -484), 360, "freeze", "yellow", "secret_0");
    
	thread secret_0_finish();
	thread failtrig();
    thread ropeslide();
	thread startdoor();
	thread xpbox();
	thread doors();
	thread door1();

}

secret_0_finish()
{
	trig = getent("backtomap_trig","targetname");
	point = getent("backtomap_point","targetname");

	for(;;)
	{
	trig waittill("trigger",player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

failtrig()
{

	trig = getent("secret_fail_trig","targetname");
	for(;;)
	{
	trig waittill("trigger",player);

	player Suicide();

	}	
}

ropeslide()
{
	trig = getent("ropeslide","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		player thread slide();
		player DisableWeapons();
	}
}

slide()
{
	m1 = getent("m1","targetname");
	m2 = getent("m2","targetname");
	m3 = getent("m3","targetname");
	m4 = getent("m4","targetname");
	m5 = getent("m5","targetname");
	m6 = getent("m6","targetname");

	self sr\api\_player::antiElevator(true);
	ad = spawn("script_model",(0,0,0));
	ad.origin = self.origin;
	ad.angles = self.angles;
	self linkto(ad);
	ad moveto(m1.origin-(0,0,50),1);
	wait 1;
	ad moveto(m2.origin-(0,0,50),.9);
	wait .91;
	ad moveto(m3.origin-(0,0,50),.7);
	wait .71;
	ad moveto(m4.origin-(0,0,50),.5);
	wait .51;
	ad moveto(m5.origin-(0,0,50),.3);
	wait .31;
	ad moveto(m6.origin-(0,0,50),.1);
	wait .11;
	self sr\api\_player::antiElevator(false);
	self unlink();
	self EnableWeapons();
}

startdoor()
{
	door1 = getent("startdoor1","targetname");
	door2 = getent("startdoor2","targetname");
	
	door1 delete();
	door2 delete();
}

xpbox()
{
	xpbox1 = getent("xpbox_1","targetname");
	xpbox2 = getent("xpbox_2","targetname");
	xpbox3 = getent("xpbox_3","targetname");
	xpbox4 = getent("xpbox_4","targetname");
	xpbox5 = getent("xpbox_5","targetname");
	

	xpbox1 delete();
	xpbox2 delete();
	xpbox3 delete();
	xpbox4 delete();
	xpbox5 delete();


	

}


doors()
{
	door1 = getent("door2_1","targetname");
	door2 = getent("door2_2","targetname");
	
	door1 delete();
	door2 delete();
	
}

door1()
{
	door = getent("door3_1","targetname");
	
	door delete();
	
}