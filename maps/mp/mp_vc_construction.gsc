main()
{
    maps\mp\_load::main();
    
    clip0 = getent ("ioivoaidi1238938dxzvbb", "targetname");
    clip1 = getent ("iiaoduaisdvcaxczb44", "targetname");
    clip2 = getent ("88ifiadsdovzx", "targetname");
    clip3 = getent ("99vxasdiklllzodi", "targetname");
    clip4 = getent ("98cmvmnzvistic", "targetname");
    clip5 = getent ("998f9asd9vzxcvistic22", "targetname");
    clip6 = getent ("vistic9999481", "targetname");
    clip7 = getent ("vistic99131asdx", "targetname");
    clip8 = getent ("998visticaiksdkasdvc", "targetname");
    clip9 = getent ("visticllkvasd991d", "targetname");
    clip10 = getent ("vvvvistic999913c", "targetname");
    clip11 = getent ("oo99a99dsd", "targetname");

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
    thread sr\api\_map::createSpawn((-336,356,35),0);

    thread vistic();
    thread startdoor();
    thread elevatorupndown();

  
    
}

vistic()
{
 vc = getent("vishtick","targetname");
	                                  
  for(;;) 
  {
  vc rotateYaw (360,7);
  wait 1;
  }
      
}

startdoor()
{
  door = getent("porta","targetname");

  door delete();
}

elevatorupndown()
{
    trig = getent("trigger_elevator1", "targetname");

    ori = spawn("script_origin",(7575,920,1309));
	ori.angles = (0,7,0);

    thread sr\api\_map::createTriggerFx(trig, "blue");
   
   for(;;)
   {
    trig waittill("trigger",player);

    player setOrigin(ori.origin);
	player SetPlayerAngles(ori.angles);
	player FreezeControls(1);
	wait 0.05;
	player FreezeControls(0);
   
   }
}
