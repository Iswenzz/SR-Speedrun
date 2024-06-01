main()
{
    maps\mp\_load::main();
    
    endmap = getent("endmap_trig","targetname");
    endmap delete();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-2005, -500, -271), 334);
    thread sr\api\_speedrun::createEndMap((-4124.62, -1422.87, 1505.15), 80, 100);
  
  
}
