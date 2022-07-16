main()
{
maps\mp\_load::main();
 
game["allies"] = "sas";
game["axis"] = "opfor";
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

thread sr\api\_map::createSpawn((-733,455,-324),360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((-334.961, -382.781, -127.875), 120, 10, "normal_0");
thread sr\api\_speedrun::createTeleporter((2112.37, -745.093, -383.875), 70, 10, (2198, -2106, -68), 180, "freeze", "blue", "normal_0");

thread hurt();
thread waterdead();
}
 
hurt() 
{
hurts = getent("spikeshurt", "targetname"); 
hurta = getent("trap7_blade1_hurt", "targetname"); 
hurtb = getent("trap7_blade2_hurt", "targetname"); 
trap7a = getent("trap7_blade1", "targetname"); 
trap7b = getent("trap7_blade2", "targetname"); 

wait 0.1;
hurts delete();
hurta delete();
hurtb delete();
trap7a delete();
trap7b delete();
}

waterdead()
{
   trig = getent("water", "targetname");

for(;;)
    {   
    trig waittill("trigger", player);
    player suicide();
    }
    
}