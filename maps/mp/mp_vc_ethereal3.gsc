main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";


  thread sr\api\_speedrun::createNormalWays("Normal Way;");
  thread sr\api\_map::createSpawn((11920, 1182, 281), 90);
         

}
