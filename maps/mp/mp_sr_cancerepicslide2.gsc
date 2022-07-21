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

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("bg_fallDamageMaxHeight", "99999");
    setdvar("bg_FallDamageMinHeight","99998");

		thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Bounce Way;Stairs Way;");
    thread sr\api\_speedrun::createEndMap((10568.8, -23523.9, -2295.88), 220, 40, "secret_0");
	thread sr\api\_speedrun::createEndMap((-7901.41, 8498.06, -5223.88), 300, 30, "secret_1");

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
	player thread sr\api\_speedrun::changeWay("secret_1");
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
	 player thread sr\api\_speedrun::changeWay("secret_0");
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




