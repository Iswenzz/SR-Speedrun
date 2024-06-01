main()
{
    maps\mp\_load::main();

     clip0 = getent ("vistic9938183218931", "targetname");
     clip1 = getent ("91348caiaivistic", "targetname"); 
     clip2 = getent ("9991288fivvvvistic", "targetname"); 
     clip3 = getent ("visticclan33123vv", "targetname"); 
     clip4 = getent ("vvvisticccclan133", "targetname"); 
     clip5 = getent ("vvvvistic3999clan", "targetname"); 
     clip6 = getent ("999vistic66iicclan", "targetname"); 
     clip7 = getent ("vistic991ccccclanckkad", "targetname"); 
     clip8 = getent ("visticmyvistic999123", "targetname"); 
     clip9 = getent ("7secvistic9096", "targetname"); 
     clip10 = getent ("visticfan99383", "targetname"); 
     clip11 = getent ("ouloulouloulou9991", "targetname");

     clip0 delete();
     clip1 delete();
     clip2 delete();
     clip3 delete();
     clip4 delete();
     clip5 delete();
     clip6 delete();
     clip7 delete();
     clip8 delete();
     clip9 delete();
     clip10 delete();
     clip11 delete();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-15302, -8133, 772), 360);


    thread vclogos();
   
}

vclogos()
{
 vc = getent("vc5","targetname");   
 vc1 = getent("vc2","targetname");   
 vc2 = getent("vc7","targetname");                            
  for(;;) 
  {
     vc rotateyaw (360, 7);
     vc1 rotateyaw (360, 7);
     vc2 rotateyaw (360, 7);
     vc moveZ (200, 7);
     vc1 moveZ (200, 7);
     vc2 moveZ (200, 7);
     wait 7;
     vc rotateyaw (360, 7);
     vc1 rotateyaw (360, 7);
     vc2 rotateyaw (360, 7);
     vc moveZ (-200, 7);
     vc1 moveZ (-200, 7);
     vc2 moveZ (-200, 7);
     wait 7;
  }
      
}
