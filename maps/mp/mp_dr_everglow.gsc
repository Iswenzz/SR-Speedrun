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
    thread sr\api\_map::createSpawn((0,-32,76),90);
    thread sr\api\_speedrun::createTeleporter((-76.5681, 9553.52, -548.636), 130, 150, (5118, 114, 76), 90, "freeze");
    
    thread rest();
    
}

rest()
{
  trap6a = getent("trap_6_1","targetname");
  trap6b = getent("trap_6_2","targetname");
  move1 = getent("move1","targetname");
  door = getent("startdoor","targetname");
  
  door delete();
  trap6a delete();
  trap6b delete();
  move1 RotateYaw(90, 0.1);
  move1 moveY(440, 0.1);
  move1 waittill("movedone");
  move1 moveX(200, 0.1);

}
