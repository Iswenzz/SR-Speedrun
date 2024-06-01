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
	
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-1083, -512, 92), 90);
	thread sr\api\_speedrun::createEndMap((-3.47791, -851.413, 32.125), 80, 100);
    
	thread rest();

}

rest()
{
	rocks1_obj = getent("rocks1","targetname");
	rocks2_obj = getent("rocks2","targetname");
	glift_obj = getentarray("espinas","targetname");
	glift2_obj = getentarray("slite","targetname");

	rocks1_obj delete();
	rocks2_obj delete();
	glift_obj[0] delete();
	glift_obj[1] delete();
	glift_obj[2] delete();
	glift2_obj[0] movey (140,0.1); 

}

