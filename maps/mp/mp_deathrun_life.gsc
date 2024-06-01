main()
{
	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "2" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 99999 );
	setDvar("bg_falldamageminheight", 99998 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((342, 1, 88), 360);

	thread teleporters();
	thread startdoors();
	thread breakdoor();
	thread plat();
	thread trap2();
	thread trap5();
	thread trap9();
	thread trap10();
	thread sec0_enter();
	thread exitsecret();
	thread setup();
	thread jumppad();

}

teleporters()
{       
 	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporters();
}
 
transporters()
{
	for(;;)
	{

		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

startdoors()
{
	door1 = getent("door1","targetname");
	door2 = getent("door2","targetname");
	window = getent("bwin","targetname");


	door1 delete();
	door2 delete();
}

breakdoor()
{
	bomb[0] = getent("bomb0","targetname");
	bomb[1] = getent("bomb1","targetname");
	bomb[2] = getent("bomb2","targetname");
	bomb[3] = getent("bomb3","targetname");
	doorpart = getent("breakdoor_part","targetname");
	
	bomb[0] delete();
	bomb[1] delete();
	bomb[2] delete();
	doorpart delete();
}

plat()
{
	brick = getent("mbrick","targetname");
	
	brick moveY(260,0.1);
		
}

trap2()
{
	trig = getent("trap2trig","targetname");
	obj1 = getent("trap2obj1","targetname");
	obj2 = getent("trap2obj2","targetname");
	kill1 = getent("kill1","targetname");
	kill2 = getent("kill2","targetname");

	kill1 delete();
	kill2 delete();
	obj1 delete();
	obj2 delete();
	
}

trap5()
{
	trig = getent("trap5trig","targetname");
	obj = getent("trap5spiner","targetname");
	killtrig = getent("killtrigtrap5","targetname");
	point1 = getent("point1","targetname");
	point2 = getent("point2","targetname");
	
	
	obj delete();
	killtrig delete();
	
	
}

trap9()
{
	trig = getent("trap9trig","targetname");
	obj = getent("trap9obj","targetname");
	killtrig9 = getent("killtrig9","targetname");
	killtrig9 = getent("killtrig9","targetname");
	
	
	killtrig9 delete();
	
}

trap10()
{
	trig = getent("trap10trig","targetname");
	ball1 = getent("trap10ball1","targetname");
	ball2 = getent("trap10ball2","targetname");
	ball1killtrig = getent("ball1killtrig","targetname");
	ball2killtrig = getent("ball2killtrig","targetname");

    ball1 delete();
	ball2 delete();
	ball1killtrig delete();
	ball2killtrig delete();
	
}

sec0_enter()
{
	trig = spawn("trigger_radius",(346.911, 143.779, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("startsecretpoint","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player setOrigin(ori_t.origin);
		player setPlayerangles(ori_t.angles);
		player.sc = 0;
		player.insec = true;
		player FreezeControls(1);
		wait .1;
		player FreezeControls(0);
	}
}


exitsecret()
{
	trig = getent("secretend_trig","targetname");
	spot = getent("secrettp_end","targetname");
	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	
		player.sc = 0;
		player.insec = false;
	
	}
}

setup()
{
	for(i=1;i<=6;i++)
	{
		thread loadtrigger(i);
		thread savetriggers(i);
	}
}

savetriggers(num)
{
	savetrig = getent("save_"+num,"targetname");
	for(;;)
	{
		savetrig waittill("trigger",player);
		if(player.sc >= num)
		{
			player.sc = player.sc;
		}
		if(player.sc != num || player.sc < num)
		{
			player.sc = num;
			player iprintln(">> Position: "+player.sc+" Saved");
		}
	}
}

loadtrigger(num)
{
	spot = getent("load_"+num,"targetname");
	trig = getent("loadtrigger","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		if(num == player.sc)
		{
		player iprintln(">> Position: "+player.sc+" Loaded");
		player setorigin(spot.origin);
		player setplayerangles(spot.angles);
		player FreezeControls(1);
		wait .1;
		player FreezeControls(0);
		}
	}
}

jumppad()
{
	trig = getent("jumppad_trig","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		player thread mover();
		wait .1;
	}
}

mover()
{
	pos1 = getent("moverpos1","targetname");
	pos2 = getent("moverpos2","targetname");
	orgmover = spawn("script_model",(0,0,0));

	self sr\api\_player::antiElevator(true);

	orgmover.origin = self.origin;
	orgmover.angles = self.angles;
	self linkto(orgmover);
	orgmover moveto(pos1.origin,0.5);
	wait .5;
	orgmover moveto(pos2.origin,1);
	wait 1.1;
	self sr\api\_player::antiElevator(false);
	self unlink();
	wait .1;
	orgmover delete();
}