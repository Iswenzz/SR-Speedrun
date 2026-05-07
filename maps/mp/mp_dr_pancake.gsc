main()
{
    thread sr\api\_map::createSpawn((-406, 973, 92), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((280.921, 943.159, 768.125), 85,120, "normal_0"); 
// Traps \\
	//thread trap1();
	//thread trap2();
	//thread rotate1();
	//thread rotate2();
	//thread rotate3();
	//thread rotate4();
	//thread move();
	//thread acti_xp();
	
// Door \\
	//thread door1();
	
// Music \\
	//thread ambient();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("compassmaxrange","1600");
	
}	
ambient()
{
AmbientPlay ( "sound1" );
wait 5;
iprintln("^2>>>  Now Playing: ^2Peanut Butter Jelly Time ^7- ^4Remix<<<");
}
trap1()
{
	rotate_obj = getentarray("trap1","targetname");	
	if(isdefined(rotate_obj))
		for(i=0;i<rotate_obj.size;i++)
			rotate_obj[i] thread ra_rotate1();
}
ra_rotate1()
{
	if (!isdefined(self.speed))
		self.speed = 10;
	if (!isdefined(self.script_noteworthy))
		self.script_noteworthy = "y";
 
	for(;;)
	{
		while(1)
		{
			// rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
			if (self.script_noteworthy == "z")
				self rotateYaw(360,self.speed);
			else if (self.script_noteworthy == "x")
				self rotateRoll(360,self.speed);
			else if (self.script_noteworthy == "y")
				self rotatePitch(360,self.speed);
			wait (self.speed-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
			// self waittill("rotatedone");
		}
	}
}
trap2()
{
	rotate_obj = getentarray("trap2","targetname");	
	if(isdefined(rotate_obj))
		for(i=0;i<rotate_obj.size;i++)
			rotate_obj[i] thread ra_rotate12();
}
ra_rotate12()
{
	if (!isdefined(self.speed))
		self.speed = 10;
	if (!isdefined(self.script_noteworthy))
		self.script_noteworthy = "z";
 
	for(;;)
	{
		while(1)
		{
			// rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
			if (self.script_noteworthy == "z")
				self rotateYaw(360,self.speed);
			else if (self.script_noteworthy == "x")
				self rotateRoll(360,self.speed);
			else if (self.script_noteworthy == "y")
				self rotatePitch(360,self.speed);
			wait (self.speed-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
			// self waittill("rotatedone");
		}
	}
}
rotate1()
{
	rotate_obj = getentarray("rotate1","targetname");	
	if(isdefined(rotate_obj))
		for(i=0;i<rotate_obj.size;i++)
			rotate_obj[i] thread ra_rotate2();
}
ra_rotate2()
{
	if (!isdefined(self.speed))
		self.speed = 10;
	if (!isdefined(self.script_noteworthy))
		self.script_noteworthy = "z";
 
	for(;;)
	{
		while(1)
		{
			// rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
			if (self.script_noteworthy == "z")
				self rotateYaw(360,self.speed);
			else if (self.script_noteworthy == "x")
				self rotateRoll(360,self.speed);
			else if (self.script_noteworthy == "y")
				self rotatePitch(360,self.speed);
			wait (self.speed-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
			// self waittill("rotatedone");
		}
	}
}
rotate2()
{
	rotate_obj = getentarray("rotate2","targetname");	
	if(isdefined(rotate_obj))
		for(i=0;i<rotate_obj.size;i++)
			rotate_obj[i] thread ra_rotate3();
}
ra_rotate3()
{
	if (!isdefined(self.speed))
		self.speed = 10;
	if (!isdefined(self.script_noteworthy))
		self.script_noteworthy = "z";
 
	for(;;)
	{
		while(1)
		{
			// rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
			if (self.script_noteworthy == "z")
				self rotateYaw(360,self.speed);
			else if (self.script_noteworthy == "x")
				self rotateRoll(360,self.speed);
			else if (self.script_noteworthy == "y")
				self rotatePitch(360,self.speed);
			wait (self.speed-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
			// self waittill("rotatedone");
		}
	}
}
rotate3()
{
	rotate_obj = getentarray("rotate3","targetname");	
	if(isdefined(rotate_obj))
		for(i=0;i<rotate_obj.size;i++)
			rotate_obj[i] thread ra_rotate4();
}
ra_rotate4()
{
	if (!isdefined(self.speed))
		self.speed = 10;
	if (!isdefined(self.script_noteworthy))
		self.script_noteworthy = "z";
 
	for(;;)
	{
		while(1)
		{
			// rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
			if (self.script_noteworthy == "z")
				self rotateYaw(360,self.speed);
			else if (self.script_noteworthy == "x")
				self rotateRoll(360,self.speed);
			else if (self.script_noteworthy == "y")
				self rotatePitch(360,self.speed);
			wait (self.speed-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
			// self waittill("rotatedone");
		}
	}
}
rotate4()
{
	rotate_obj = getentarray("rotate4","targetname");	
	if(isdefined(rotate_obj))
		for(i=0;i<rotate_obj.size;i++)
			rotate_obj[i] thread ra_rotate5();
}
ra_rotate5()
{
	if (!isdefined(self.speed))
		self.speed = 10;
	if (!isdefined(self.script_noteworthy))
		self.script_noteworthy = "z";
 
	for(;;)
	{
		while(1)
		{
			// rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
			if (self.script_noteworthy == "z")
				self rotateYaw(360,self.speed);
			else if (self.script_noteworthy == "x")
				self rotateRoll(360,self.speed);
			else if (self.script_noteworthy == "y")
				self rotatePitch(360,self.speed);
			wait (self.speed-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
			// self waittill("rotatedone");
		}
	}
}
door1()
{
	door = getEnt ("door1","targetname");
	t = getEnt ("old_open","targetname");
	t sethintstring ("Press ^1[^7USE^1]^7 to enter the old way.");
		t waittill ("trigger",player);
		t delete();
	wait 0.1;
	door delete();
	iprintlnbold ("^1" + player.name + " ^7has finished the map!");
}
move()
{
	m = getEnt ("move1","targetname");
	while(1)
	{
		m moveY (112,3);
		m waittill ("movedone");
		wait 3;
		m moveY (-112,3);
		m waittill ("movedone");
		wait 1;
	}
}
acti_xp()
{
	t = getEnt ("t1_s","targetname");
		t waittill ("trigger", player);
			t delete();
	wait 0.1;
	player braxi\_rank::giveRankXP("", 500);
}