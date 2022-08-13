main()
{
	maps\mp\_load::main();
	endmap_trig();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((-812,-58,76),90);
	thread sr\api\_speedrun::createNormalWays("First Way;Second Way;Third Way;Fourth Way;Fifth Way;");
	thread sr\api\_speedrun::createWay((-1313.44, 990.343, 16.125), 105, 80, "orange", "normal_1");
	thread sr\api\_speedrun::createWay((-799.691, 997.213, 16.125), 100, 80, "blue", "normal_2");
	thread sr\api\_speedrun::createWay((-285.09, 999.401, 16.125), 100, 80, "red", "normal_3");
	thread sr\api\_speedrun::createWay((225.086, 1001.78, 16.125), 100, 80, "cyan", "normal_4");
	thread sr\api\_speedrun::createTeleporter((-798.974, 4252.97, 496.125), 75, 50, (-802, 5675, 556), 90, "freeze", "blue", "normal_2");
	thread sr\api\_speedrun::createEndMap((-1818.34, 8980.29, -239.875), 125, 50, "normal_0");
	thread sr\api\_speedrun::createEndMap((-1311.76, 7260.67, 144.125), 160, 50, "normal_1");
	thread sr\api\_speedrun::createEndMap((-794.132, 8745.92, 496.125), 120, 50, "normal_2");
	thread sr\api\_speedrun::createEndMap((-294.295, 10066.3, 16.125), 100, 50, "normal_3");
	thread sr\api\_speedrun::createEndMap((225.375, 9829.36, 352.125), 150, 50, "normal_4");

   thread doors();
   thread avoidbug();
   thread trap1();
   thread trap4();
   thread trap5();
   thread trap9();
   thread trap10();
   thread trap11();
   thread trap14();
   thread rotate();
   thread trap26();
   thread trap27();
   thread trap30();
   thread trap32();
   thread trap33();
   thread trap37();
   thread trap42();

}

endmap_trig()
{
trig = getEnt("endmap_trig", "targetname");

trig delete();

}

doors()
{
door[0] = getEnt( "door1", "targetname" );
door[1] = getEnt( "door2", "targetname" );
door[2] = getEnt( "door3", "targetname" );
door[3] = getEnt( "door4", "targetname" );
door[4] = getEnt( "door5", "targetname" );

door[0] delete();
door[1] delete();
door[2] delete();
door[3] delete();
door[4] delete();

}

avoidbug()
{
brush1 = getEnt( "avoidbug1", "targetname" );
brush2 = getEnt( "avoidbug2", "targetname" );
brush3 = getEnt( "avoidbug3", "targetname" );
brush4 = getEnt( "avoidbug4", "targetname" );
brush5 = getEnt( "avoidbug5", "targetname" );

brush1 delete();
brush2 delete();
brush3 delete();
brush4 delete();
brush5 delete();

}

//Room1//

trap1()
{
dmg = getent ("trap1_dmg","targetname");
c41 = getEnt( "c41", "targetname" );
c42 = getEnt( "c42", "targetname" );
c43 = getEnt( "c43", "targetname" );
c44 = getEnt( "c44", "targetname" );
c45 = getEnt( "c45", "targetname" );
c46 = getEnt( "c46", "targetname" );

c41 delete();
c42 delete();
c43 delete();
c44 delete();
c45 delete();
c46 delete();
dmg delete();

}

trap4()
{
slid1 =getent("slid1","targetname");
slid2 =getent("slid2","targetname");

slid1 movex(-125,0.1);
slid2 movex(128,0.1);
}

trap5()
{
dmg = getent ("trap05_dmg","targetname");

dmg delete();

}

trap9()
{
movingdown = getent("movingdown","targetname");
dmg = getent ("trap9_dmg","targetname");

dmg delete();
movingdown delete();

}

trap10()
{
dmg = getent ("trap10_dmg","targetname");
clips = getEnt( "clips", "targetname" );
be1 = getEnt( "be1", "targetname" );
be2 = getEnt( "be2", "targetname" );
be3 = getEnt( "be3", "targetname" );
be4 = getEnt( "be4", "targetname" );
be5 = getEnt( "be5", "targetname" );
be6 = getEnt( "be6", "targetname" );
be7 = getEnt( "be7", "targetname" );
be8 = getEnt( "be8", "targetname" );
be9 = getEnt( "be9", "targetname" );
be10 = getEnt( "be10", "targetname" );
be11 = getEnt( "be11", "targetname" );
be12 = getEnt( "be12", "targetname" );
be13 = getEnt( "be13", "targetname" );
be14 = getEnt( "be14", "targetname" );
be15 = getEnt( "be15", "targetname" );
be16 = getEnt( "be16", "targetname" );
be17 = getEnt( "be17", "targetname" );

be1 delete();
be2 delete();
be3 delete();
be4 delete();
be5 delete();
be6 delete();
be7 delete();
be8 delete();
be9 delete();
be10 delete();
be11 delete();
be12 delete();
be13 delete();
be14 delete();
be15 delete();
be16 delete();
be17 delete();
clips delete();
dmg delete();

}

//Room2//

trap11()
{
slid1_1 =getent("slid1_1","targetname");

slid1_1 movey(142,0.1);

}

trap14()
{
dmg = getent ("trap14_dmg","targetname");
help1 = getEnt( "help1", "targetname" );
help2 = getEnt( "help2", "targetname" );

dmg delete();
help1 movez(242,0.1);
help2 movez(242,0.1);

}

rotate()
{
rotate = getEnt("rotateme", "targetname");

rotate delete();

}

//Room4//
trap26()
{
brush1 =getent("brushyt1","targetname");
brush2 =getent("brushyt2","targetname");
brush3 =getent("brushyt3","targetname");
brush4 =getent("brushyt4","targetname");

brush1 delete();
brush2 movex(230,0.1);
brush3 delete();
brush4 movex(225,0.1);

}

trap27()
{
brush1 =getent("brushz1","targetname");
brush2 =getent("brushz2","targetname");

brush1 movex(257,0.1);
brush2 movex(-257,0.1);

}

trap30()
{
blocklooping = getent ("blocklooping","targetname");
dmg = getent ("trigger_dmg_30","targetname");

dmg delete();

}

trap32()
{
dmg = getent ("trigger_dmg_32","targetname");

dmg delete();
}

trap33()
{
brush = getent ("smasher33","targetname");
dmg = getent ("trigger_dmg_33","targetname");

dmg delete();

}

//Room5//
trap37()
{
brush = getent("rotaspikes","targetname");
dmg = getent ("dmg_sikes","targetname");

brush delete();
dmg delete();
}

trap42()
{
brush = getEnt("trap42", "targetname");
dmg1 = getent ("trap42_dmg_1","targetname");
dmg2 = getent ("trap42_dmg_2","targetname");
dmg3 = getent ("trap42_dmg_3","targetname");
dmg4 = getent ("trap42_dmg_4","targetname");

brush delete();
dmg1 delete();
dmg2 delete();
dmg3 delete();
dmg4 delete();

}