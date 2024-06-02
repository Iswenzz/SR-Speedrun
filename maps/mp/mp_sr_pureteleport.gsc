//Map by CM'death
//Discord:Death#7416
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";

   setdvar( "r_specularcolorscale", "1" );
   setdvar("r_glowbloomintensity0",".1");
   setdvar("r_glowbloomintensity1",".1");
   setdvar("r_glowskybleedintensity0",".1");
   setDvar("bg_falldamagemaxheight", 99999);
   setDvar("bg_falldamageminheight", 99998);

   thread sr\api\_speedrun::createNormalWays("Normal Way;");

   thread tp1();
   thread tp2();
   thread tp3();
   thread tp4();
   thread tp5();


}

tp1()
{
   trig = getent("trig_tp1", "targetname");
   tele1 = getent ("orig_tp1", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

tp2()
{
   trig = getent("trig_tp2", "targetname");
   tele1 = getent ("orig_tp2", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

tp3()
{
   trig = getent("trig_tp3", "targetname");
   tele1 = getent ("orig_tp3", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

tp4()
{
   trig = getent("trig_tp4", "targetname");
   tele1 = getent ("orig_tp4", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

tp5()
{
   trig = getent("trig_tp5", "targetname");
   tele1 = getent ("orig_tp5", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}