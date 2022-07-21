main()
{
thread sr\api\_map::createSpawn((-199, -34, 32), 90);
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


	thread sr\api\_map::deleteUnsupportedWeapons();
		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((-33.3952, 189.139, 32.125), 50, 30, (-451, -6001, 124), 270, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((-2561.67, -9688.04, 64.125),190,95,"secret_0");

	thread startdoor();
	thread block();
	thread moveplat();
	thread secmoveplat();
	thread tp1();
	thread tp2();
	thread ele();

}



startdoor()
{
door1 =getEnt("jumpers_door1", "targetname");
door2 =getEnt("jumpers_door2", "targetname");
cjump =getEnt("crouchjump", "targetname");

wait 0.1;
door1 delete();
door2 delete();
cjump delete();

}

block()
{
blocka =getEnt("block1", "targetname");
blockb =getEnt("block4", "targetname");
blockc =getEnt("block2", "targetname");
blockd =getEnt("block3", "targetname");

wait 0.1;

blocka moveX(150,0.1);
blockb moveX(150,0.1);
blockc moveX(-150,0.1);
blockd moveX(-150,0.1);
wait 0.4;
blocka moveY(100,0.1);
blockc moveY(100,0.1);

}

moveplat()
{
blocka =getEnt("moving_thing1", "targetname");
blockb =getEnt("moving_thing2", "targetname");

wait 0.1;

blocka moveX(150,0.1);
blockb moveX(-140,0.1);
wait 0.4;
blocka moveY(100,0.1);
blockb moveY(-100,0.1);

}

secmoveplat()
{
blocka =getEnt("secret_moving1", "targetname");
blockb =getEnt("secret_moving2", "targetname");
blockc =getEnt("secret_moving3", "targetname");

blocka moveY(-220,0.1);
blockc moveY(95,0.1);
blockb moveY(385,0.1);
wait 0.3;
blockc moveX(40,0.1);

}

tp1()
{
   trig = getent("teleportjumpers", "targetname");
   tele = getent ("gojumpers", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

tp2()
{
   trig = getent("tel_back_to_part_2", "targetname");
   tele = getent ("f16_trig", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

ele()
{
door1=getEnt("elevator_door1","targetname");
part1=getEnt("elevator_part1","targetname");
button1=getEnt("elevator_button1","targetname");
rest1=getEnt("elevator_rest1","targetname");
ele1=getEnt("ele1_antiglitch_1","targetname");
door2=getEnt("elevator_door2","targetname");
part2=getEnt("elevator_part2","targetname");
button2=getEnt("elevator_button2","targetname");
rest2=getEnt("elevator_rest2","targetname");
ele2=getEnt("ele2_antiglitch_1","targetname");

wait 0.1;
door1 delete();
part1 delete();
button1 delete();
rest1 delete();
ele1 delete();
door2 delete();
part2 delete();
button2 delete();
rest2 delete();
ele2 delete();

}