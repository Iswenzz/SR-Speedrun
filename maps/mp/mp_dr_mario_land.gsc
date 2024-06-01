main()
{
  	maps\mp\_load::main();


	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");

	thread sr\api\_speedrun::createNormalWays("Normal Way;Short Way;");
    thread sr\api\_map::createSpawn((-1727, 167, 76), 0);
	thread sr\api\_speedrun::createTeleporter((5707.01, 319.582, 72.125), 60, 100, (6733, 313, 764), 90, "freeze", "green", "normal_1");
	thread sr\api\_speedrun::createEndMap((4408.72, 1643.53, 32.125), 165, 100);
	
	thread disableHurt();
	thread fix((1533.42, 215.532, -87.875));
    thread fix((5474.2, 303.106, -87.875));
	thread fix((5646.39, 1659.84, -87.875));
	thread fix((-1216.87, 170.983, -87.875));
	thread fixv2((6101.21, 1522, 204.125));
	thread traps_fixes();
	

}

disableHurt()
{
    triggers = getEntArray("trigger_hurt", "classname");
    for (i = 0; i < triggers.size; i++)
        triggers[i] delete();
}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 1500, 30);
	trigger.targetname = "fix";
	trigger.radius = 1500;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

fixv2(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 150, 1000);
	trigger.targetname = "fixv2";
	trigger.radius = 150;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

traps_fixes()
{
	trab_n9a= getent("trap_9a","targetname"); 
	trab_n9b= getent("trap_9b","targetname"); 
	trab_n3a= getent("trap_3a","targetname");
	
	
	trab_n9a delete();
	trab_n9b delete();
	trab_n3a delete();
		
		
}