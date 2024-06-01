 main()
{
 maps\mp\_load::main();
 
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

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((416, -635, 76), 270);
	
	thread startdoor();
	thread mover1();


 
}

startdoor()
{
lootje = getent("startdoor","targetname");

lootje delete();


}

mover1() 
{ 
	mover = getent( "mover1", "targetname" ); 
	
	mover moveX(300,0.1); 
	mover waittill("movedone");
	mover rotateYaw(90,0.1);
	
}
