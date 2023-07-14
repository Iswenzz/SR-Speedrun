main()
{
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
	thread sr\api\_map::createSpawn((-0, -256, 76), 90);
	thread sr\api\_speedrun::createTeleporter((1.7471, 1637.72, 0.124999), 100, 100, (-47, 2005, 508), 359, "freeze");

	thread startdoor();
	thread plat2();
	thread edits();

}

startdoor()
{
	door = getent("startdoor","targetname");

	door delete();
}

plat2()
{
	plat = getent("plat2","targetname");
	
	plat movey(150,0.1);
	wait 0.1;
	plat rotateYaw(90,0.1);
		
}

edits()
{
	roter = getent("trap3roter","targetname");
	obj = getent("trap4pusher","targetname");
	killtrig = getent("trap3killtrig","targetname");

	killtrig delete();
	roter movey(200,0.1);
	obj MoveY(250,0.1);
	wait 0.1;
	obj MoveZ(-250,0.1);
	wait 0.1;
	obj rotateYaw(-90,0.1);
	obj MoveX(150,0.1);


}
