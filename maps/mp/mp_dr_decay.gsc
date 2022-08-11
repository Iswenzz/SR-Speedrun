main() 
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "allies";
game["defenders"] = "axis";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((383,511,60),360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread start();
thread start2();
thread spikes();
thread trap1();

}

start() 
{
startdoor = getent("start_door", "targetname");  

wait 0.1;
startdoor delete();
}

start2() 
{
wall = getent("trap7_wall", "targetname"); 

wait 0.1;
wall moveZ(-200, 0.1);
}

spikes() 
{
spikes = getent("trap2_spikes", "targetname"); 
hurt = getent("trap2_hurt", "targetname");

wait 0.1;
spikes delete();
hurt delete();
}

trap1() 
{
hurt = getentArray("trap1_hurt", "targetname");  

wait 0.1;
hurt[0] delete();
hurt[1] delete();

}
