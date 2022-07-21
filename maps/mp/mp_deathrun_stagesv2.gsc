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
thread sr\api\_speedrun::createTeleporter((6308.63, 3197.7, -767.875), 45, 20, (9274, 3842, -692), 360, "freeze", "blue", "normal_0");

thread startdoors();
thread spinner();
thread teleporters();
thread wall_bouncer();
thread platform_bouncer();
thread trap7();
thread trap11();

}

teleporters()
{       
 	entTransporter = getentarray( "teleporters", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}
 
transporter()
{
	if(self.classname == "trigger_use_touch")
       self sethintstring(">> ^5Press ^1[^7&&1^1] ^5To Teleport ^7 <<");
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.01;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.01;
	}
}

startdoors()
{
door_b = getEnt("blue_door","targetname");
door_r = getEnt("red_door","targetname");
door_y = getEnt("yellow_door","targetname");
door_g = getEnt("green_door","targetname");
	
wait 0.1;	
door_b delete();
door_r delete();
door_y delete();
door_g delete();
}

wall_bouncer()
{
	trig = getEnt("wall_bouncer","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		for(i=0;i<5;i++)
		{
		player.health += 1000;
		player finishPlayerDamage(player, player, 1000, 0, "MOD_UNKNOWN", "bounce", player.origin, (0,1,0) , "none", 0);
		}

		while(player isTouching(trig))
			wait 0.01;

	}
}

platform_bouncer()
{
	trig = getEnt("platform_bouncer","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		for(i=0;i<9;i++)
		{
		player.health += 1000;
		player finishPlayerDamage(player, player, 1000, 0, "MOD_UNKNOWN", "bounce", player.origin, (0,0,90) , "none", 0);
		}

		while(player isTouching(trig))
			wait 0.01;

	}
}

spinner()
{
roter = getEnt("t5as","targetname");

wait 0.1;
roter delete();
		
}

trap7()
{
	spikes = getEnt("t7s","targetname");
	spikes notsolid();
	spikes hide();

	killtrig = getEnt("t7kt","targetname");
	killtrig maps\mp\_utility::triggerOff();

	trig = getEnt("trap7trig","targetname");
	trig waittill("trigger",player);
	trig delete();

	spikes show();
	killtrig maps\mp\_utility::triggerOn();

	wait 3;

	spikes hide();
	killtrig delete();
}

trap11()
{
wall = getEnt("trap11wall","targetname");
killtrig = getEnt("trap11killtrig","targetname");
killtrig enablelinkto();
killtrig linkto(wall);

wait 0.1;	
wall movez(-500,0.1);

}