main()
{
	maps\mp\_load::main();
	maps\mp\_teleport::main();
	maps\mp\_teleport1::main();
	maps\mp\_teleport2::main();
	maps\mp\_teleport3::main();
	maps\mp\_teleport4::main();
	maps\mp\_teleport5::main();
	maps\mp\_teleport6::main();
	maps\mp\_teleport7::main();
	maps\mp\_teleport8::main();
	
	
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
    thread sr\api\_map::createSpawn((-283, 5, 76), 1);
	thread sr\api\_speedrun::createEndMap((5634.66, -3875.51, -319.875), 175, 100, "normal_0");

	thread platforme();
	thread start_door();
	thread trap4();
	thread trap11();

}

platforme()
{
trigger = getent("trig_platforme","targetname");
object = getent("platforme","targetname");

object moveX(224, 0.1);
object waittill("movedone");
object rotateYaw(90,0.1);

}


start_door()
{
	door1 = getent("door1", "targetname"); 
	door2 = getent("door2", "targetname");
	
	door1 delete();
	door2 delete();
}

trap4()
{
	a = getent("t4a","targetname");
	b = getent("t4b","targetname");
	c = getent("t4c","targetname");
	d = getent("t4d","targetname");

	a delete();
	b delete();
	c delete();
	d delete();
	
	
}

trap11()
{
	a = getent("t11a","targetname");
	b = getent("t11b","targetname");
	c = getent("t11c","targetname");
	d = getent("t11d","targetname");
	e = getent("t11e","targetname");
	f = getent("t11f","targetname");
	
	a delete();
	b delete();
	c delete();
	d delete();
	e delete();
	f delete();
	
}