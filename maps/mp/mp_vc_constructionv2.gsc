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
    thread sr\api\_map::createSpawn((-6184, 3757, 880), 360);


    thread rotator1();//rotate trap auto acti at start 
    thread rotator2();//second rotate trap at start
 

}

rotator1()
{
 rotator1 = getent("rotator1","targetname");
	                                  

  rotator1 rotateYaw (135,0.1);

 
      
}

rotator2()
{
   
 rotator2 = getent("rotator2","targetname");
	                                  
 
  rotator2 rotateYaw (90,0.1);
   
}

