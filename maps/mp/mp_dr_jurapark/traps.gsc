main()
{
	level._effect[ "blesk" ] = loadfx( "misc/blesky2" );

	// thread onplayerconnected();
	// thread trap1();
	thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	thread trap14();
	// thread trap15();
}

onplayerconnected()
{
	while(1)
	{
		level waittill("connected", player);
		player.electric = false;
	}
}

onactivetrap()
{
	
}

trap1()
{
	active = getent("t3_","targetname");
	trig = getent("t3","targetname");
	
	active onactivetrap();
	
	trig thread trap1_kill();
	wait 20; //cas do deaktivacie
	trig notify("kill");
}

trap1_kill()
{
	self endon("kill");

	while(1)
	{
		self waittill("trigger", player);
		
		if(!player.electric)
		{
			player.electric = true;
			self thread trap1_player_init(player);
		}	
	}
}

trap1_player_init(player)
{
	self trap1_player(player);
	
	wait 3; //cas do dalsieho zmrazenia
	
	if(isdefined(player))
	{
		player.electric = false;
		player FreezeControls(false);
	}	
}

trap1_player(player)
{
	self endon("kill");
	player endon("death");
	player endon("disconnect");
	
	player FreezeControls(true);
	RadiusDamage( player.origin, 5, 30, 30); //posledne 2 udaje su damage
	fx = PlayFX( level._effect[ "blesk" ], player geteye());
	
	wait 2; //cas zmrazenia hraca
}

trap2()
{
	active = getent("t1_","targetname");
	door = getent("t1","targetname");
	
	active onactivetrap();
	door movez(-105, 3);//rychlost pohybu dveri-druhy udaj
}

trap3()
{
	active = getent("t4_","targetname");
	rotate = getent("t4","targetname");
	
	x = 2; //rychlost otacania
	
	active onactivetrap();

	for(i = 0;i < 3;i++)
	{
		rotate rotateyaw(360,x); 
		wait x;
	}
	wait 5;
	for(i = 0;i < 3;i++)
	{
		rotate rotateyaw(-360,x); 
		wait x;
	}	
}

trap4()
{
	active = getent("t5_","targetname");
	rotate = getentarray("t5","targetname");

	//thread debugonspawn("velkost pola: "+rotate.size);
	
	active onactivetrap();
	for(i = 0;i<rotate.size;i++)
		rotate[i] thread trap4_rotate();
}

trap4_rotate()
{
	x = 4; //rychlost otacania - max
	y = 2; //rychlost otacania - min
	xr = 4; //cas medzi otacanim - max
	yr = 2; //cas medzi otacanim - min	
	
	while(1)
	{
		r = RandomFloatRange(y,x);
		//-/*
		r1 = randomFloatRange(yr,xr);
		r2 = randomint(2);
		
		if(r2)
			wait r1;
		//*/
		for(o = 0;o < 3;o++) //cyklus otacania
		{
			self rotateyaw(360,r);
			wait r;
		}
	}
}

trap5()
{
	active = getent("t6_","targetname");
	rotate = getent("t6","targetname");
	x = 5; //rychlost otacania
	
	active onactivetrap();
	
	while(1)
	{
		rotate rotatepitch(360,x);
		wait x;
	}
}

trap6()
{
	active = getent("t7_","targetname");

	active onactivetrap();
	
	for(i = 1;i < 34;i++)
	{
		r = randomint(2);
		if(r == 1)
		{
			lav = getent("lav"+i,"targetname");
			lav delete();
		}
	}
}

trap7()
{
	active = getent("t8_","targetname");
	rotate = getent("t8","targetname");

	active onactivetrap();	
	
	c = 2;
	v = 3;

	rotate rotatepitch(360, v);
	wait v;
	rotate rotatepitch(-360, c);
	wait c;
	rotate rotatepitch(360, v);
	wait v;
	rotate rotatepitch(-360, c);
	wait c;
}

trap8()
{
	active = getent("t9_","targetname");
	model = getent("t9","targetname");	
	trig = getent("t9k","targetname");
	target_point = getEnt( model.target, "targetname" );
	
	dist = distance2d(model.origin, target_point.origin);
	
	active onactivetrap();
	
	trig enablelinkto();
	trig linkto(model);
	trig thread on_touch();
	
	Earthquake( 1, 3, trig.origin, 300 ); //<scale>, <duration>, <source>, <radius>-
	
	model movey(int(dist),2);
	model waittill("movedone");

	trig notify("kill");
	trig unlink();
	trig delete();
	model delete();
}

on_touch()
{
	self endon("kill");

	while(1)
	{
		self waittill("trigger", player);
		player.health += 90;
		player FinishPlayerDamage(player, player, 100, 0, "MOD_PROJECTILE", "rpg_mp", self.origin, vectornormalize(player.origin - self.origin), "none", 0);
	}
}

trap9()
{
	active = getent("t10_","targetname");
	model = [];
	trig = [];
	target_point = [];
	
	for(i = 1;i < 7;i++)
	{
		model[i] = getent("t10"+i , "targetname");
		target_point[i] = getent(model[i].target , "targetname");
		trig[i] = getent("t10k"+i , "targetname");
	}	
	
	active onactivetrap();
	model[1] PlaySound("raptor");
	
	for(i = 1;i < 7;i++)
		model[i] thread move_raptor(target_point[i],trig[i]); 
}

move_raptor(target_point,trig)
{
	wait RandomFloatRange(0.1,5); //cas do vybehnutia(od - do)

	trig enablelinkto();
	trig linkto(self);
	
	self moveto(target_point.origin,2); //druhy udaj rychlost
	self waittill("movedone");

	trig unlink();
	trig delete();
	self delete();
}

trap10()
{
	active = getent("t11_","targetname");
	trig = getentarray("t11k","targetname");
	model = getentarray("t11","targetname");
	
	target_dis = [];
	target_dis[0] = getent(model[0].target,"targetname");
	target_dis[1] = getent(model[1].target,"targetname");
	
	startorig = [];
	endorig = [];
	
	for(i = 0;i < 2;i++)
	{
		startorig[i] = model[i].origin;
		endorig[i] = (target_dis[i].origin[0], target_dis[i].origin[1], model[i].origin[2]);
	}
	
	active onactivetrap();
	
	for(i = 0;i < 2;i++)
	{
		trig[i] enablelinkto();
		trig[i] linkto(model[i]);
		
		model[i] moveto(endorig[i], 1);
		
		model[i] waittill("movedone");
		wait 1;
		
		model[i] moveto(startorig[i], 2);
		model[i] waittill("movedone");
		
		trig[i] unlink();
		trig[i] delete();
	}
}

trap11()
{
	active = getent("t12_","targetname");
	a = getent("t12a","targetname");
	b = getent("t12b","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movey(-153,2);
		b movey(-153,2);
		wait 2;
		a movey(153,2);
		b movey(153,2);		
		wait 2;
	}
}

trap12()
{
	active = getent("t13_","targetname");
	brush = getentarray("t13", "targetname");
	
	active onactivetrap();
	
	for(i = 0;i < 2;i++)
	{
		r = randomint(brush.size);
		if(isdefined(brush[r]))
			brush[r] delete();
	}
}

trap13()
{
	active = getent("t14_","targetname");
	brush = getent("t14", "targetname");
	
	active onactivetrap();
	
	while(1)
	{
		for(i = 0;i < 5;i++)
		{
			brush rotateyaw(360,2);
			wait 2;
		}	
		for(i = 0;i < 5;i++)
		{
			brush rotateyaw(-360,2);
			wait 2;
		}	
	}
}

trap14()
{
	active = getent("t15_","targetname");
	brush = getent("t15", "targetname");
	
	brush movex(-262 , 0.5);
	active onactivetrap();

}

trap15()
{
	active = getent("t16_","targetname");
	/*brush_a = getent("t16a","targetname");
	brush_b = getent("t16b","targetname");
	trig_a = getent("t16a1","targetname");
	trig_b = getent("t16b1","targetname");*/
	
	active onactivetrap();
	
	r = randomint(2);
	p = "a";
	
	if(r)
		p = "a";
	else
		p = "b";
		
	brush = getent("t16"+p,"targetname");	
	trig = getent("t16"+p+"1","targetname");
	
	trig waittill("trigger");
	brush notsolid();
}

debugonspawn(text)
{	
	level waittill("connected", player);
	player waittill("spawned_player");
	
	player iprintln("DEBUG: "+text);
}