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

thread startdoor();
thread sr\api\_map::createSpawn((77, 333, 32), 179);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

}

startdoor()
{
startdoor = getent("startdoor", "targetname");

startdoor delete();
}
