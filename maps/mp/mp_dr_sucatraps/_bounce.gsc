main()
{
	

	  
	  level.knockback = getDvarInt("g_knockback");
	
	


	bounce   = getEntArray("odraz", "targetname");
	for(i = 0;i < bounce.size;i++)
		bounce[i] thread bounce();

	

		

	

}

bounce()
{
	for(;;)
	{
		self waittill("trigger", p);

		if(!isDefined(p.bouncing))
			p thread player_bounce(self);
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
	self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);

	wait 0.05;
	setDvar("g_knockback", level.knockback);

	self.health    = health;
	self.maxhealth = maxHealth;

	while(self isTouching(trigger))
		wait 0.05;

	self.bouncing = undefined;
}

