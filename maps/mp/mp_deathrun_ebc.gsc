main()
{

	maps\mp\_load::main();
	maps\mp\_teleport1::main();
	maps\mp\_teleport2::main();
	maps\mp\_teleport3::main();
	maps\mp\_teleport4::main();
	maps\mp\_teleport5::main();
	
	
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
	thread sr\api\_map::createSpawn((510, 598, -244), 270);
	thread sr\api\_speedrun::createTeleporter((719.044, 598.186, -303.875), 60, 100, (-2200, -2551, 188), 358, "freeze", "orange", "secret_0");
	thread sr\api\_speedrun::createEndMap((1533.84, 969.152, -15.875), 90, 105);
	thread sr\api\_speedrun::createEndMap((-2206.87, -2455.51, 544.125), 130, 100, "secret_0");


	thread startdoor();
	
}

startdoor()
{
object = getent("startdoor","targetname");

object delete();

}
