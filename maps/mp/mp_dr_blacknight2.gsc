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
    thread sr\api\_map::createSpawn((-533, 617, 68), 271);

    thread startdoor();
    thread lift();
   
}			
		
startdoor()
{
    door = getent("bn2_start_door","targetname");
   
    door delete();

}

lift()
{

    door = getent("bn2_ele_door","targetname");
    lift = getent("bn2_ele","targetname");

  
    door delete();
    lift movez(-656,0.1);
     
}
