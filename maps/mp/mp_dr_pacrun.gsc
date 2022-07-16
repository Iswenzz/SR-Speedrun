main()
{

    maps\mp\_load::main();

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

thread sr\api\_map::createSpawn((386,-164,60),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((-1843.51, 775.788, 0.124999), 85, 10, "normal_0");

thread startdoor();
thread exp();
	
}

startdoor()
{
door = getEnt ("pac_door", "targetname");
trig = getEnt ("pac_door_trig", "targetname");
	
wait 0.1;
door delete();
trig delete();

}

exp()
{
exp = getEnt( "secret_exp", "targetname");
exp1 = getEnt( "secret_exp2", "targetname");
exp2 = getEnt( "morg_exp", "targetname");
exp3 = getEnt( "morg_exp2", "targetname");
exp4 = getEnt( "xp_brush", "targetname");
exp5 = getEnt( "xp2_brush", "targetname");
exp6 = getEnt( "xp3_brush", "targetname");
exp7 = getEnt( "xp4_brush", "targetname");
exp8 = getEnt( "xp5_brush", "targetname");
exp9 = getEnt( "big_coin", "targetname");
exp10 = getEnt( "big_coin2", "targetname");
	
wait 0.1;
exp delete();
exp1 delete();
exp2 delete();
exp3 delete();
exp4 delete();
exp5 delete();
exp6 delete();
exp7 delete();
exp8 delete();
exp9 delete();
exp10 delete();

}
