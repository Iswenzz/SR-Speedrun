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
	thread sr\api\_map::createSpawn((-692, 562, 92), 360);

	
	thread startdoor();

}


startdoor()
{
door1 = getent("door1","targetname");
door2 = getent("door2","targetname");
door3 = getent("bunker","targetname");
killtrigger1 = getent ("killtrig1" , "targetname");
killtrigger2 = getent ("killtrig2" , "targetname");

door1 delete();
door2 delete();
door3 delete();
killtrigger1 delete();
killtrigger2 delete();

} 
