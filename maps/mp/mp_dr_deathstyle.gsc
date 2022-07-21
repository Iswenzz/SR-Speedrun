//Map by CM'Death
//Discord:Death#7416
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
thread sr\api\_map::createSpawnOrigin((6661, 5774, 4880), 270);
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
   thread sr\api\_speedrun::createSecretWays("Secret Way;");
   thread sr\api\_speedrun::createTeleporter((6969.92, 5819.27, 4880.13), 55, 10, (15502, 5041, 3276), 270, "freeze", "red", "secret_0");
   thread sr\api\_speedrun::createEndMap((19962.4, 636.908, 3528.13), 505, 15, "secret_0");

   thread letterend();
   thread startfence();

}

letterend()
{
   block1 = getent("letterE","targetname");
   block2 = getent("letterN","targetname");
   block3 = getent("letterD","targetname");

	for(;;)
   {
   wait 0.1;
   block1 rotatepitch (-360,5);
   block2 rotatepitch (360,5);
   block3 rotatepitch (-360,5);
   wait 0.1;
   }

}

startfence()
{
fences = getent("fence","targetname");

wait 0.1;

fences delete();

}