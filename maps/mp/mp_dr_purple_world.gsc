main()
{
    maps\mp\_load::main();
 
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";
	
	
	setDvar("bg_falldamagemaxheight", 99999 );
	setDvar("bg_falldamageminheight", 99998 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-592, 816, 76), 90);
    thread sr\api\_speedrun::createTeleporter((-3744.08, -1392.11, 16.125), 110, 100, (-1718, -1389, 76), 360, "freeze");
	
 
	thread Startdoor();
	thread Trap9();

	
}
 
 
Startdoor()
{
	trig = getEnt("trig_startdoor", "targetname");
	door = getEnt("startdoor", "targetname");
	button1 = getEnt("doorbutton1", "targetname");
	button2	= getEnt("doorbutton2", "targetname");
	
	trig delete();
	button1 delete();
	button2 delete();
	door delete();
	
}

Trap9()
{
	trig = getEnt("trig_trap9", "targetname");
	hurt = getEnt("hurt_bird", "targetname");
	spike = getEnt("birdspike", "targetname");
	
	spike delete();
	hurt delete();
	
}
