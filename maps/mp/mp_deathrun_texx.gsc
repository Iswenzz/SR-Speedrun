main()
{   

    trigger = getEnt("enddoor_trig", "targetname");
	trigger.targetname = "endmap_trig";

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
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((446, 524, 84), 180);
	thread sr\api\_speedrun::createTeleporter((-3878.24, 1402.49, -580.125), 105, 100, (-4142, 1693, 21), 226, "freeze");
	
	thread startdoor();
	thread minefields();
	thread move1();
    thread move2();
    thread move3();
	thread fix((-4873.2, 1282.72, -415.128));
	
}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 80, 820);
	trigger.targetname = "fix";
	trigger.radius = 80;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

minefields()
{
	minefields = getentarray("minefield", "targetname");
	if (minefields.size > 0)
	
	
	for(i = 0; i < minefields.size; i++)
	{
		minefields[i] delete();
	}	
}

startdoor()
{
	brush = getEnt ("startdoor_brush", "targetname");
	brush1 = getEnt ("nosolid1", "targetname");
		   
		
    brush delete();
	brush1 delete();
	
}

move1()
{
	brush = getEnt( "move1", "targetname" );

	
	brush moveY( 435,0.1);
	
	
}

move2()
{
	brush = getEnt( "move2", "targetname" );

	brush moveY( 435,0.1);
}

move3()
{
	brush = getEnt( "move3", "targetname" );

	brush moveY( -435,0.1);
	
}


