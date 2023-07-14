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
    thread sr\api\_map::createSpawn((-499, 907, 77), 270);
    thread sr\api\_speedrun::createTeleporter((-829.792, -4071.92, 16.125), 105, 100, (-127, -4517, 508), 270, "freeze");
    thread sr\api\_speedrun::createTeleporter((-319.732, 886.41, 16.625), 60, 100, (2192, -10062, 588), 180, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((-2913.48, -7462.97, 336.125), 100, 100, "secret_0");
 
    thread pndm_startdoor();
    thread pndm_traps();
    
}

pndm_startdoor()
{
    door = getent("pndm_startdoor","targetname");
    clip = getent("pndm_startdoor_clip","targetname");
    clip2 = getent("pndm_trap_3","targetname");
    hurt = getent("pndm_trap_3hurt","targetname");
    trap = getent("pndm_trap_5","targetname");
 
    door delete();
    clip delete();
    clip2 delete();
    hurt delete();
    trap delete();
}

pndm_traps()
{
    thread trap3_move();
    thread trap7_move();
    
    
}

trap3_move()
{
    move1 = getent("pndm_move1","targetname");
    move2 = getent("pndm_move2","targetname");

    move2 movex(-615,0.1);
    

   
}

trap7_move()
{
    trapa = getent("pndm_trap_7a","targetname");
    trapb = getent("pndm_trap_7b","targetname");

    
        trapa movex(-336,0.1);
        trapb movex(336,0.1);
       
}