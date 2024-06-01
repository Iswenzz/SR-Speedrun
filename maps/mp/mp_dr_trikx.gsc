main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","2200");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((392, 102, 76), 90);
	thread sr\api\_speedrun::createEndMap((1843.4, 1288.37, 16.125), 125, 100);


	thread startdoor();
	thread trap7();
	thread trap10();
	thread trap11();


}

startdoor()
{
door=getent("door","targetname");
brush = getEnt("rotate","targetname");
killtrigger1 = getent ("killtrig" , "targetname");
killtrigger2 = getent ("killtrig_3" , "targetname");
killtrigger3 = getent ("killtrig_2" , "targetname");

door delete();
brush delete();
killtrigger1 delete();
killtrigger2 delete();
killtrigger3 delete();

}

trap7()
{
object = getent("trap_7","targetname");

object rotateYaw(90,0.1);
object moveX(-200, 0.1);

}

trap10()
{
object = getent("trap_10","targetname");

object moveY(-100, 0.1);

}

trap11()
{
object = getent("trap_11","targetname");

object moveX(-600, 0.1);

}