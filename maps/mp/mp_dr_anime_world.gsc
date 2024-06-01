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
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-268, 3411, 76), 90);
	thread sr\api\_speedrun::createTeleporter((-479.253, 3410.7, 16.125), 60, 100, (-1819, 17646, 252), 90, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((20025.9, 20157.5, -4559.88), 190, 100, "secret_0");

    thread sec_dead();
	thread stage2tp();
	thread rest();
	thread wallrun();
	thread bouncetrig();

}

sec_dead()
{
	trig = getent("secret_failtrig","targetname");
	for(;;)
	{
		trig waittill("trigger", player );

		player Suicide();
		
	}
}


stage2tp()
{
	trig = getent("player_stage2tp","targetname");
	spot = getent("player_stage2tp_spot","targetname");
	for(;;)
	{
		trig waittill("trigger", player);

		player setorigin( spot.origin );
		player setplayerangles( spot.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

rest()
{
	table3 = getent("table3","targetname");
	killtrig = getent("wallkilltrig","targetname");
	wall = getent("trap16","targetname");
	sword1 = getent("sword_1","targetname");
	sword2 = getent("sword_2","targetname");
	sword6 = getent("sword_6","targetname");

	table3 delete();
	killtrig delete();
	wall delete();
	sword1 delete();
	sword2 delete();
	sword6 delete();
	
}

wallrun()
{
	trig = getent("wallruntrig","targetname");
	angle = getent("angleorigin","targetname");
	lastorigin = getent("lastorigin","targetname");
	for(;;)
	{
		trig waittill("trigger", player );

		player sr\api\_player::antiElevator(false);
		
		player setplayerangles(angle.angles);
		air = spawn("script_model",(0,0,0));
		
		air.origin = player.origin;
		air.angles = player.angles;
		player linkto(air);
		air moveto((1576, 11976, 328), 1);
		air waittill("movedone");
		air moveto((1576, 11400, 488), 1);
		air waittill("movedone");
		air moveto(lastorigin.origin, 1);
		air rotateto(lastorigin.angles, 1);
		air waittill("movedone");
            
		player sr\api\_player::antiElevator(true);
		player unlink();
		
	}
}

bouncetrig()
{  
	level.knockback = getDvarInt("g_knockback");

	bounce   = getEntArray("bounce", "targetname");
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