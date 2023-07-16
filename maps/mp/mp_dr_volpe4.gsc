main() 
{
 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";
             
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);	
  
    thread sr\api\_map::createSpawn((-219,443,476),90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^3Easy Secret;^1Hard Secret;^2Acti Secret");
    thread sr\api\_speedrun::createTeleporter((-361.728, 443.065, 416.125), 55, 100, (2997, 139, 252), 178, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-41.9249, 442.982, 416.125), 55, 100, (2943, -1106, 252), 268, "freeze", "red", "secret_1");
    thread sr\api\_speedrun::createTeleporter((-328.764, 729.237, 416.125), 50, 100, (-1059, -1745, 476), 179, "freeze", "green", "secret_2");
    thread sr\api\_speedrun::createEndMap((2682.61, 2530.99, 256.125), 120, 100, "secret_0");
	thread sr\api\_speedrun::createEndMap((5641.73, -4371.12, -503.875), 140, 100, "secret_1");
    thread sr\api\_speedrun::createEndMap((-7028.21, -1941.96, 360.125), 105, 100, "secret_2");


    thread startdoor();
    thread teleport1();
    thread teleport2();
    

}

startdoor()
{
	start = getEnt("startdoor","targetname");
    trap2 = getEnt("trap2","targetname");
    hurt = getEntArray("trigger_hurt", "classname"); 

	start Delete();
    trap2 delete();
    hurt[4] delete();
    hurt[5] delete();
	
}

teleport1()
{
   trig = getent("trig_tp1", "targetname");
   tele = getent ("here1", "targetname");

   for(;;)
    {   
      trig waittill("trigger", player);
	  player setOrigin(tele.origin);
      player setPlayerAngles(tele.angles);
      player FreezeControls(1);
      wait 0.05;
      player FreezeControls(0);
	
    }
}

teleport2()
{
   trig = getent("trig_tp2", "targetname");
   tele = getent ("here2", "targetname");

   for(;;)
    {   
      trig waittill("trigger", player);
	  player setOrigin(tele.origin);
      player setPlayerAngles(tele.angles);
      player FreezeControls(1);
      wait 0.05;
      player FreezeControls(0);
	
    }
}