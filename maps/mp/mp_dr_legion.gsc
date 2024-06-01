main()
{
maps\mp\_teleport::main();
maps\mp\_load::main();	
	
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";


setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setdvar("compassmaxrange","1800");

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_map::createSpawn((14838, 12138, -15733), 90);
 
thread move_plat_2();


}

move_plat_2()
{
object = getent( "platplat" , "targetname" );	
	
object movey(-320, 0.1);
object rotateYaw(90,0.1);

}
