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
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setDvar( "compassmaxrange", "1024" );

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((-372.974, 596.419, 16.125), 50, 15, (2780, -3424, 156), 180, "freeze", "yellow", "secret_0");

thread startdoor();
thread trap1();
thread teleport();
thread secfinish();

}

startdoor()
{
door = getent("startdoor","targetname");

wait 0.1;
door delete();
}

trap1()
{
hurt = getent("trap1","targetname");

wait 0.1;
hurt delete();
}

teleport()
{
trig = getent("laststage_trig", "targetname");
ori = spawn("script_origin",(2778,-2786,284));
	ori.angles = (0,180,0);

   for(;;)
    {   
    trig waittill("trigger", player);
	player thread sr_tp_safe(ori);
    }
}

sr_tp_safe(ori)
{
	self setOrigin(ori.origin);
	self SetPlayerAngles(ori.angles);
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}

secfinish()
{
trig = getent("secret_exit", "targetname");

    for(;;)
    {   
    trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
    }
    
}