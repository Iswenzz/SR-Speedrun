main()
{
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


thread startdoor();

thread sr\api\_map::createSpawn((-421,0,-324),1);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

}

startdoor()
{
	start = getEnt("door","targetname");
  hint = getEnt("door_hint","targetname");
	
	start delete();
  hint delete();

}