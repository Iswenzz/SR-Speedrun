main()
{
trigger = spawn( "trigger_radius", (-5484.02, -123.487, -12273.5), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	PreCacheItem("remington700_mp");
	PreCacheItem("winchester1200_grip_mp");
	
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1200");

thread sr\api\_map::createSpawn((2177,-145,-4020),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((-5856.9, -391.046, -12287.9), 175, 15, "normal_0");

thread death();
thread teleport();
thread door();
thread trap9();
thread trap14();
}

death()
{

	trig = getEnt ("death","targetname");
	while(true)
	{
		trig waittill("trigger", jumper);

		jumper PlaySound("death"+randomint(4));
	}
}

teleport()
{
	entTransporter = getentarray( "enter", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
	}
}
 
transporter()
{
	while(true)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

door()
{
brush = getEnt ("door","targetname");

wait 0.1;
brush delete();
	
}

trap9()
{
brush = getEnt ("trap9_1","targetname");
brush2 = getEnt ("trap9_2","targetname");

wait 0.2;
brush delete();
brush2 moveY(192,0.2);
	
}

trap14()
{
trap14_1 = getEnt ("trap14_1","targetname");
trap14_2 = getEnt ("trap14_2","targetname");

wait 0.5;
trap14_1 delete();
trap14_2 moveY(128,0.5);
	
}