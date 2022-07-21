main()
{
thread sr\api\_map::createSpawn((27, 124, 16), 90);
maps\mp\_load::main();
	
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
        thread sr\api\_speedrun::createTeleporter((303.32, 215.723, 16.125), 65, 80, (-539, 9578, 833), 270, "freeze", "blue", "secret_0");
    thread sr\api\_speedrun::createTeleporter((24.4772, 3026.37, 14.125), 60, 10, (-938, 3641, 74), 180, "freeze", "blue", "normal_0");
    thread sr\api\_speedrun::createTeleporter((-3722.37, 6103.69, 0.124997), 80, 10, (-3740, 6863, 73), 90, "freeze", "blue", "normal_0");
    thread sr\api\_speedrun::createTeleporter((-3735.82, 11057.2, 12.125), 80, 10, (-3706, 12026, 73), 90, "freeze", "blue", "normal_0");
    thread sr\api\_speedrun::createEndMap((97.1, 7709.61, 109.125), 175, 10, "secret_0");
    thread sr\api\_speedrun::createEndMap((-3728.05, 15220.4, 13.125), 130, 10, "normal_0");

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert"; 

    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");  

	thread startdoor();
	thread startdoor2();
	thread startdoor3();


}

startdoor()
{
door=getent("startdoor","targetname");

door movez(-250,5);
door delete();
}

startdoor2()
{
door=getent("startdoor2","targetname");

door movez(-260,5);
door delete();
}

startdoor3()
{
door=getent("startdoor3","targetname");

door movez(-400,5);
door delete();
}