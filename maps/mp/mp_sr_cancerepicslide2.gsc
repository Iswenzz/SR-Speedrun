main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 

 
	setdvar("g_speed" ,"190");
	setdvar("dr_jumpers_speed" ,"1.05");
	
	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("bg_fallDamageMaxHeight", "99999"); 
    setdvar("bg_FallDamageMinHeight","99998");
 
	thread speedrun\_way_name::create_spawn((-208,-40,60),90);
	thread speedrun\_way_name::create_normal_way("Normal Way");
	 thread speedrun\_way_name::create_endmap((10542.3, -23567.5, -2295.88), 315, 10,"s1");
	 thread speedrun\_way_name::create_endmap((-7884.32, 8498.37, -5223.88), 380, 10,"s0");
	  thread speedrun\_way_name::create_secret_way("Cancer1;Cancer2;");
    	
 level.knockback = getDvarInt("g_knockback");
	bounce   = getEntArray("bounce", "targetname");    
    for(i = 0;i < bounce.size;i++)
    bounce[i] thread doublebounce();
	
 thread slide();
 thread slide1();
	thread qube();
	thread stairs();
	thread stairsslide();
	thread gay();
	
	
}

doublebounce()
{
    for(;;)
    {
    self waittill("trigger", player);
    
    if(!isDefined(player.bouncing))
    player thread player_bounce(self);
    }
}
player_bounce(trigger)
{
    self.bouncing = true;
    vel = self getVelocity();
    temp0 = (((vel[0] < 350 && vel[0] > 0) || (vel[0] > -350 && vel[0] < 0)));
    temp1 = (((vel[1] < 350 && vel[1] > 0) || (vel[1] > -350 && vel[1] < 0)));

    if((!temp0 && !temp1) || vel[2] > -350)
    {
        wait 1;
        self.bouncing = undefined;
        return;
    }

    health    = self.health;
    maxHealth = self.maxHealth;
    self.health    = 1000000;
    self.maxhealth = 1000000;
    setDvar("g_knockback", (vel[2]*-9)-500);
	self.oldO = self.origin;
	//self iPrintLnBold("Bounce "+self.bouncecount);
    self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);
    wait 0.05;
    setDvar("g_knockback", level.knockback);
    self.health    = health;
    self.maxhealth = maxHealth;
    while(self isTouching(trigger))
    wait 0.05;
	distance = distance2d( self.oldO, self.origin );
	if (distance > 6)
    self.bouncing = undefined;
	wait 0.1;
}

slide()
{
    slide = getEnt("xd", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);
	
}

slide1()
{
    slide = getEnt("xd1", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);
	
}

qube()
{
    sign = getEnt("qube", "targetname");
	
	for(;;)
	{
	sign rotateyaw (-360,7);
	sign rotateRoll((2 * 360 + 3 * randomFloat(500)) * -1, 5, 0, 0);
	wait 0.1;
	}
}

stairs()
{
    trig = getent ("stairs","targetname");
    target = getent ("stairs_spawn","targetname");
    while(true)
    {
    trig waittill("trigger",player);
	player thread speedrun\_way_name::change_way("s1");
	player freezeControls(true);
    player setPlayerangles( target.angles );
    player setOrigin( target.origin );
	wait 0.1;
	player freezeControls(false);
	
    }
   
}


gay()
{
    trig = getent ("gay","targetname");
    target = getent ("gay_spawn","targetname");
    while(true)
    {
    trig waittill("trigger",player);
	 player thread speedrun\_way_name::change_way("s0");
	player freezeControls(true);
    player setPlayerangles( target.angles );
    player setOrigin( target.origin );
	wait 0.1;
	player freezeControls(false);
	
    }
   
}


stairsslide()
{
    slide = getEnt("stairs_slide", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);
	
}




