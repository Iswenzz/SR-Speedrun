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
	setdvar("r_glowbloomintensity0", ".25");
	setdvar("r_glowbloomintensity1", ".25");
	setdvar("r_glowskybleedintensity0", ".3");
	setdvar("compassmaxrange","1800");

thread speedrun\_way_name::create_spawn((-262,259,76),360);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_endmap((9794.16, -5894.96, -4311.88), 165, 10, "ns0");
thread speedrun\_way_name::create_tp((5908.04, 2180.04, -3823.88), 115, 10, (7292, -1108, -3668), 270, "freeze", "blue", "ns0");
thread speedrun\_way_name::create_tp((-376.278, 446.709, 16.125), 50, 10, (78, -2777, -3380), 360, "freeze", "red", "s0");
thread speedrun\_way_name::create_tp((573.843, -3955.34, -3311.88), 75, 10, (1731, -3969, -3252), 360, "freeze", "red", "s0");

thread kickstart();
thread afterkick();
thread stage4();
thread secret();

////////////////Double Bounce
level.knockback = getDvarInt("g_knockback");	
bounce   = getEntArray("bounce", "targetname");    
for(i = 0;i < bounce.size;i++)
bounce[i] thread doublebounce();

} 

secret()
{
thread part2();
thread part3();
thread secret1_finish();
thread laser_secret();
}

part2()	{
	trigger = getent ("part2_trigger", "targetname");
	target = getent ("part2_target", "targetname");
	
	for (;;){
		trigger waittill ("trigger", player);
		player freezeControls(true);
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		wait 0.5;
		player freezeControls(false);
	}
}

part3()	
{
	trigger = getent ("part3_trigger", "targetname");
	target = getent ("part3_target", "targetname");
	
	for (;;){
		trigger waittill ("trigger", player);
		player freezeControls(true);
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		wait 0.5;
		player freezeControls(false);
	}
}

secret1_finish() 
{
	trigger = getent ("part4_trigger", "targetname");
	target = getent ("part4_target", "targetname");
	
	for (;;)
	{
		trigger waittill ("trigger", player);
		player thread speedrun\_way_name::finish_way("s0");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

laser_secret() 
{
laser1 = getent ("laser_secret_1", "targetname");
laser2 = getent ("laser_secret_2", "targetname");
laser3 = getent ("laser_secret_3", "targetname");
platform = getent ("secret_platform", "targetname");

wait 0.1;
laser1 notsolid();
laser1 hide();
laser2 notsolid();
laser2 hide();
laser3 notsolid();
laser3 hide();
platform moveX (250,0.1);
}

kickstart() 
{
object2 = getent ("ground_start", "targetname");

wait 0.1;
object2 notsolid();
object2 hide();
}

afterkick() 
{
object = getent ("notsolid_wall1", "targetname");
	
wait 0.1;	
object notsolid();
object hide();
}

////////////////////////// Double Bounce

doublebounce()	// script by  DanTheMan
{
    for(;;){
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
    self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);
    wait 0.05;
    setDvar("g_knockback", level.knockback);
    self.health    = health;
    self.maxhealth = maxHealth;
    while(self isTouching(trigger))
    wait 0.05;
    self.bouncing = undefined;
}	

stage4() 
{
	trigger = getent ("stage4_teleport", "targetname");
	target = getent ("stage4_target", "targetname");
	
	for(;;)	{
		trigger waittill ("trigger", player);
		player freezeControls(true);
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		wait 0.5;
		player freezeControls(false);
	}
}