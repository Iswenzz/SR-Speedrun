 main()
{
thread sr\api\_map::createSpawnOrigin((-5203, -334, 8123), 359);


/////////////////////////////////////////////////

 maps\mp\_load::main();
 //maps\mp\teleports::main();


 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 setDvar("bg_falldamagemaxheight", 30000000000 );
 setDvar("bg_falldamageminheight", 12800000000 );
 setdvar( "r_specularcolorscale", "9" );

 setdvar("r_glowbloomintensity0",".25");
 setdvar("r_glowbloomintensity1",".25");
 setdvar("r_glowskybleedintensity0",".3");
 setdvar("compassmaxrange","1800");

 thread sr\api\_speedrun::createNormalWays("Easy Way;");
 thread sr\api\_speedrun::createSecretWays("Hard Way;Inter Way;");
  thread sr\api\_speedrun::createTeleporter((-4396.42, -781.285, 8123.13), 105, 90, (28729, -12322, -36991), "freeze", "darkred", "secret_0");
 thread sr\api\_speedrun::createTeleporter((-4385.6, -369.701, 8123.13), 105, 95, (-22770, 70526, 27368), "freeze", "green");
 thread sr\api\_speedrun::createTeleporter((-4364, 232.183, 8123.13), 105, 105, (1634, 49957, 62424), 293, "freeze", "purple", "secret_1");
 thread sr\api\_speedrun::createEndMap((37512, -40887.9, -57368.4), 700, 220, "secret_0");
 thread sr\api\_speedrun::createEndMap((-24999.6, 49074, 15847.6), 500, 200, "normal_0");
 thread sr\api\_speedrun::createEndMap((11813.7, 16993.4, 41830.1), 600, 250, "secret_1");
 //thread msginter();
 //thread msginterroof();
 //thread msgfinishedeasy();
 //thread msgeasyroof();
 //thread msghardfinish();
//thread msghardroof();
// thread msgwelcome();
// thread msgthanks1();
// thread msgthanks2();
 //thread msgpro();
 //thread msgfatdick();
}


///////////////////////////////////////////////////////
msgwelcome()
{
trigger = getent("msgwelcome","targetname");

 while (1)
 {
  trigger waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.welcome ) ))
     {
   wait 6;
    user iprintlnbold ("Welcome to ^5mp_Palm");
 user iprintlnbold ("Map created by ^1Furi");

   user.welcome = true;
     }

 wait .05;
 }
}
/////////////////////////////////////////////////////////////////////////////////////////////
msginter()
{
trigger = getent("msginter","targetname");

 while (1)
 {
  trigger waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.interfinish ) ))
     {
   user iprintlnbold ("" + user.name + " you finished ^4Inter Way!");
user iprintlnbold ("Map created by ^1Furi");
   user.interfinish = true;
     }

 wait .05;
 }
}
/////////////////////////////////////////////////////////////////////////////////////////////
msginterroof()
{
trigger = getent("msginterroof","targetname");

}
/////////////////////////////////////////////////////////////////////////////////////////////
msgfinishedeasy()
{
trigger = getent("msgfinishedeasy","targetname");

}
/////////////////////////////////////////////////////////////////////////////////////////////
msgeasyroof()
{
trigger = getent("msgeasyroof","targetname");

}
/////////////////////////////////////////////////////////////////////////////////////////////
msghardfinish()
{
trigger = getent("msghardfinish","targetname");

}
/////////////////////////////////////////////////////////////////////////////////////////////
msghardroof()
{
trigger = getent("msghardroof","targetname");

}
/////////////////////////////////////////////////////////////////////////////////////////////
msgthanks1()
{
trigger = getent("msgthanks1","targetname");

 while (1)
 {
  trigger waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.thanks ) ))
     {
   iprintlnbold ("Thanks to ^1Chusteen ^7and ^4Kev ^7for testing!");
   user.thanks = true;
     }

 wait .05;
 }
}
/////////////////////////////////////////////////////////////////////////////////////////////
msgthanks2()
{
trigger = getent("msgthanks2","targetname");

 while (1)
 {
  trigger waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.thanks1 ) ))
     {
   iprintlnbold ("Thanks to ^1Chusteen ^7for all his mapping help!");
   user.thanks1 = true;
     }

 wait .05;
 }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
msgpro()
{
trigger = getent("msgpro","targetname");

 while (1)
 {
  trigger waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.pro ) ))
     {
   iprintlnbold ("" + user.name + " is ^4Pro^7!");
   user.pro = true;
     }

 wait .05;
 }
}
/////////////////////////////////////////////////////////////////////////////////////////////
msgfatdick()
{
trigger = getent("msgfatdick","targetname");

 while (1)
 {
  trigger waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.dick ) ))
     {
   iprintlnbold ("" + user.name + " loves fat ^6Dick^7!");
   user.dick = true;
     }

 wait .05;
 }
}
/////////////////////////////////////////////////////////////////////////////////////////////


