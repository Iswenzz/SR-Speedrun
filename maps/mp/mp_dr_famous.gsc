main()
{
 
 game["allies"] = "marines"; 
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
   
 thread sr\api\_map::createSpawn((-126,4,444),360);
 thread sr\api\_speedrun::createNormalWays("^2Easy Way;^1Hard Way;");
 thread sr\api\_speedrun::createSecretWays("Secret Way;");
 thread sr\api\_speedrun::createTeleporter((1784.85, 2237.77, -2727.88), 80, 35, (6249, 2205, -2674), 1, "freeze", "blue");

 thread startdoor();
 thread tp1();
 thread tp2();
 thread hardtp();
 thread hardfinish();
 thread sectp();
 thread secfinish();

  setDvar("bg_falldamagemaxheight", 300000 );
  setDvar("bg_falldamageminheight", 128000 );
  setDvar("r_lightTweakSunColor", "1 0.921569 0.878431 1");
  setDvar("r_lightTweakSunDirection", "-50 136 1");
  setDvar("r_lightTweakSunLight", "1");
}

startdoor()
{
 door = getEnt("gate","targetname");
 trig = getEnt("gate_trig","targetname");
 
 door delete();
 trig delete();
}

tp1()
{
   trig = getent("enter2", "targetname");
   tele = getent ("gohere2", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

tp2()
{
   trig = getent("enter9", "targetname");
   tele = getent ("gohere9", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

hardtp()
{
   trig = getent("enter", "targetname");
   tele = getent ("gohere", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);

	 player thread sr\api\_speedrun::changeWay("normal_1");
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

hardfinish() 
{ 
trig = getEnt( "enter4", "targetname" ); 
 
 for(;;)
 { 
  trig waittill ("trigger",player );
  
  player thread sr\api\_speedrun::finishWay("normal_1");

 } 
}

sectp()
{
   trig = getent("enter3", "targetname");
   tele = getent ("secret", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);

	 player thread sr\api\_speedrun::changeWay("secret_0");
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

secfinish() 
{ 
 trig = getEnt( "secret_finish", "targetname" ); 
 
 for(;;)
 { 
  trig waittill ("trigger",player );

  player thread sr\api\_speedrun::finishWay("secret_0");
 
 } 
}