main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1500");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-114, 40, 76), 90);

	thread auto2(); 
	thread auto6();
	thread teleporttoend();
	thread teleporttoend2();
}

auto2()
{
auto2 = getEnt ("auto2_a", "targetname");
door = getEnt ("opendoor", "targetname");

door delete();

}


auto6()
{
a = getEnt ("auto6_a", "targetname");
b = getEnt ("auto6_b", "targetname");
c = getEnt ("auto6_c", "targetname");
d = getEnt ("auto6_d", "targetname");

a delete();
b delete();
c delete();
d delete();
}


teleporttoend()
{
	trig = getEnt ("tp_toend", "targetname");
	target = getEnt ("endtp", "targetname");
	
	for(;;)
	{
	trig waittill ("trigger", player);
		
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles ); 
    }  		
}

teleporttoend2()
{
	trig = getEnt ("tp_toend2", "targetname");
	target = getEnt ("endtp2", "targetname");
	
	for(;;)
	{
	trig waittill ("trigger", player);
		
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles ); 
    }  		
}
