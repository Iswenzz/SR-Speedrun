main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((762, 529, -196), 180);
	thread sr\api\_speedrun::createEndMap((502.185, 1784.52, -254.875), 270, 100);
	
	thread door();
	thread trap8();
	thread trap8_a();

}

door()
{
	door = getEnt ("door", "targetname");
	trap4 = getEnt ("trap4", "targetname"); 
	
	door delete();
	trap4 delete();
}

trap8() 
{ 
	trap8 = getEnt ("trap8", "targetname"); 

	
	trap8 moveX (-705,0.1); 
	
}

trap8_a() 
{ 
	trap8_a = getEnt ("trap8_a", "targetname"); 
	
	trap8_a moveX (-705,0.1); 
	
}