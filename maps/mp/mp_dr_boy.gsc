main()
{
	maps\mp\_load::main();

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0", ".25");
	setdvar("r_glowbloomintensity1", ".25");
	setdvar("r_glowskybleedintensity0", ".3");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-522, 3353, 76), 270);
    thread sr\api\_speedrun::createTeleporter((-501.755, -8039.14, 16.125), 155, 100, (-494, -10205, 76), 270, "freeze");

 
	thread startdoor();
    thread trap3();
    thread trap11();

	
}

startdoor()
{
	door = getEnt("startdoor", "targetname");
	
	door delete();

}

trap3()
{
    spinner1 = getEnt("trap3_spinner1", "targetname");
    spinner2 = getEnt("trap3_spinner2", "targetname");

    spinner1 delete();
    spinner2 delete();
}

trap11()
{
    left = getEnt("trap11_left", "targetname");
    right = getEnt("trap11_right", "targetname");


    left delete();
    right delete();
    
}
