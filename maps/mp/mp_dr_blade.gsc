main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);


	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-435, 1229, 524), 180);
	

	thread start();
	
	
}


start()
{   
   door = getent("door", "targetname");
   doora = getEnt ("door3", "targetname");
   killtrigger = getent ("killtrig" , "targetname");
  
   
   door delete();
   doora delete();
   killtrigger delete();
	
}


	
	
	
	
	
	
	
	
	
	