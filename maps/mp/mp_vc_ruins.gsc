main()
{
    maps\mp\_load::main();

   

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((341,815,317),1);


    thread vclogos();


}

vclogos()
{
 vc = getent("vistic1","targetname");      
 vc2 = getent("vistic2","targetname");     
  vc3 = getent("vistic3","targetname");                   
  for(;;) 
  {
     vc rotateyaw (360, 5);
     vc2 rotateyaw (360, 5);
     vc3 rotateyaw (360, 5);
     vc moveZ (200, 5);
     vc2 moveZ (200, 5);
     vc3 moveZ (200, 5);
     wait 5;
     vc rotateyaw (360, 5);
     vc2 rotateyaw (360, 5);
     vc3 rotateyaw (360, 5);
     vc moveZ (-200, 5);
     vc2 moveZ (-200, 5);
     vc3 moveZ (-200, 5);
     wait 5;
  }
      
}