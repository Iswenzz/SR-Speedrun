main()
{
	
	maps\mp\_load::main();


	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-283, 100, 76), 90);
	thread sr\api\_speedrun::createTeleporter((-420.896, 100.027, 16.125), 60, 100, (1357, 3859, -300), 90, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((-254.171, 10416.8, -783.875), 300, 100);
	
    thread house();
	thread trap6();
	thread basement();
	thread pendrek();
	thread trap9();
	thread secret_end();

	
}

house()
{
trigger = getent("open_door","targetname");
object1 = getent("door_1","targetname");
object2 = getent("door_2","targetname");
object3 = getent("door_3","targetname");
object4 = getent("door_4","targetname");

object1 delete();
object2 delete();
object3 delete();
object4 delete();

}

trap6()
{
trigger = getent("trig_trap6","targetname");
object1 = getent("trap6","targetname");
object2 = getent("trap6_1","targetname");
killtrigger = getent ("killtrig_6" , "targetname");

killtrigger delete();


}

basement()
{
trigger = getent("open_basement","targetname");
object1 = getent("basement_lever","targetname");
object2 = getent("basement_door1","targetname");
object3 = getent("basement_door2","targetname");

object2 delete();
object3 delete();

}

pendrek()
{
object = getent("pendrek","targetname");
object1 = getent("pustajplin","targetname");
trig = getent("pliin","targetname");

object moveY(200, 0.1);
trig delete();
object1 delete();


}

trap9()
{
    object1 = getent("trap9","targetname");
	part1 = getent ("trap9_1" ,"targetname");
	part2 = getentarray ("trap9_2" ,"targetname");
	part3 = getentarray ("trap9_3" ,"targetname");
	part4 = getentarray ("trap9_4" ,"targetname");

 
	part1 MoveY(1250, 0.1);
	part1 waittill("movedone");
	part1 moveX(150,0.1);
 
}

secret_end()
{
	trig = getent("enter2","targetname");

	for(;;)
	{
	trig waittill("trigger",player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}
}