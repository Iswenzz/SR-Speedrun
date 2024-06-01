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
    thread sr\api\_map::createSpawn((192, -224, 76), 270);
  
    thread start();
}

start()
{
	door = getent ("startdoor","targetname");
    plat = getent ("platform","targetname");
	
	door delete();	
    plat moveX(-150,0.1);

}