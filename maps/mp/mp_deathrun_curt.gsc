//Map by CM'Death
//Discord:Death#7416
//Its my 1st map so scripts are quite easy. For beginners this scripts are very usefull. :)
//Sniper,knife and bounce room with activator and jumper secret.
//You cant trap camp people on 1st and 2nd trap because I added delay.
//Any cut you might try you can't.Why? Because I disabled all possible cuts huehue.
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_rank;
main()
{
thread sr\api\_map::createSpawnOrigin((25, -11, 17), 180);
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";

	setdvar( "r_specularcolorscale", "0" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

        thread sr\api\_speedrun::createNormalWays("Normal Way;");

	thread startdoor1();
	thread startdoor2();
    thread finishdoor();

	thread movingplatform();
	thread movingplatformb();

	//thread teleport1();
	//thread teleport2();
	thread teleport3();
	thread teleport4();

	//thread easysecret1();
	//thread easysecrettp();
    //thread secretgapfailload();
	//thread secretladder();
    //thread secretfailload();


}

startdoor1()
{
   door = getent("startdoor1","targetname");


   wait 0.1;
   door delete();
}

startdoor2()
{
   door = getent("startdoor2","targetname");


   wait 0.1;
   door delete();
}

movingplatform()
{

  movingplatform = getent("movingplatform", "targetname");


   movingplatform moveX (120,0.1);

}

movingplatformb()
{

   movingplatformb = getent("movingplatformb", "targetname");

   movingplatformb moveY (-520,0.1);
   wait 0.1;
   movingplatformb moveX (530,0.1);

}

finishdoor()
{
   finishdoor = getent("finishdoor", "targetname");

   wait 0.1;
   finishdoor delete();
}

teleport1()
{
   trig = getent("trigger_teleport1", "targetname");
   tele1 = getent ("origin_teleport1", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele1.origin);
      player setPlayerAngles(tele1.angles);
	  iPrintLnBold ("^5" + player.name + " ^7has entered in ^5Secret Room!");
    }
}

teleport2()
{
   trig = getent("trigger_teleport2", "targetname");
   tele2 = getent ("origin_teleport2", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele2.origin);
      player setPlayerAngles(tele2.angles);
	  player braxi\_rank::giveRankXP("", 5000);
	  iPrintLnBold ("^5" + player.name + " ^7has finished the ^5Secret Room!");
    }
}

teleport3()
{
   trig = getent("trigger_teleport3", "targetname");
   tele3 = getent ("origin_teleport3", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele3.origin);
      player setPlayerAngles(tele3.angles);
    }
}

teleport4()
{
   trig = getent("trigger_teleport4", "targetname");
   tele4 = getent ("origin_teleport4", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele4.origin);
      player setPlayerAngles(tele4.angles);
    }
}

easysecret1()
{
   trig = getent("trig_easysecret", "targetname");
   tele6 = getent ("origin_easysecret", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele6.origin);
      player setPlayerAngles(tele6.angles);
	  iPrintLnBold ("^5" + player.name + " ^7has  entered in ^5Gap Room!");
    }
}

easysecrettp()
{
   trig = getent("trig_eztp", "targetname");
   tele7 = getent ("origin_eztp", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele7.origin);
      player setPlayerAngles(tele7.angles);
	  player braxi\_rank::giveRankXP("", 3000);
	  iPrintLnBold ("^5" + player.name + " ^7has finished ^5Gap Room!");
    }
}

secretgapfailload()
{
   trig = getent("trig_gapsecfail", "targetname");
   tele1 = getent ("origin_gapsecfail", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele1.origin);
      player setPlayerAngles(tele1.angles);
      player iprintlnbold("^1Try again :/");
    }
}

secretladder()
{
    trig = getent("trig_secretladder", "targetname");
    caulk = getent("secretladder", "targetname");

for(;;)
{
 trig waittill("trigger", player);
iprintln("^4Secret opened.");
    caulk delete();
    trig delete();
wait 0.5;
}
}

secretfailload()
{
   trig = getent("trig_secretfail", "targetname");
   tele1 = getent ("origin_secretfail", "targetname");

   for(;;)
    {
      trig waittill("trigger", player);
	  player setOrigin(tele1.origin);
      player setPlayerAngles(tele1.angles);
      player iprintlnbold("^1Try again :/");
    }
}