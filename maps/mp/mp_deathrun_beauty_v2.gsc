main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 thread sr\api\_map::createSpawn((-152,-8,76),0);
 thread sr\api\_speedrun::createNormalWays("Normal Way;");
 thread sr\api\_speedrun::createSecretWays("Secret Way;");

 thread teleport1();
 thread teleport2();

}

 teleport1()
{
  trig = getEnt( "secretroom", "targetname"); 
  target = getEnt( "secret", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player thread sr\api\_speedrun::changeWay("secret_0"); 

     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles ); 
}
}

teleport2()
 
{
 
  trig = getEnt( "finishsecret", "targetname");
 
  target = getEnt( "finishsecretroom", "targetname");
 
  for(;;)
  {
  trig waittill ("trigger", player);

  player thread sr\api\_speedrun::finishWay("secret_0");
 
}
 
}
