main()
{
maps\mp\_load::main(); 

end = getent("endmap_trig","targetname");
end delete();

	
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((1346, -1589, 84), 180);
	thread sr\api\_speedrun::createEndMap((1258.14, 1599.5, 0.124999), 140, 100);

	thread startdoor();


}

startdoor()
{
	startdoor = getEnt ("startdoorjumper", "targetname");
	
	startdoor delete();
}