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
thread sr\api\_map::createSpawn((109, -1, 76), 360);
thread sr\api\_speedrun::createEndMap((2352.11, 3095.05, -351.875), 200, 100);


thread trap9();

}

trap9()
{
brush = getEnt ("b9", "targetname");
  
brush moveX(-200,0.1);
	
}