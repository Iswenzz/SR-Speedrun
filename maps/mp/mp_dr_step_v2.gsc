main()
{

trigger = getEnt( "trig_end", "targetname");
trigger.targetname = "endmap_trig";

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

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-50, -25, 556), 90);
    thread sr\api\_speedrun::createTeleporter((-3997.52, 3453.56, 576.125), 155, 100, (-4135, 3475, 1276), 180, "freeze");

 
    thread startdoor();
	thread tp1();
	thread tp2();

}	
	
	
startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();

}	

tp1()
{
	trig = getEnt("trig_tp1", "targetname");
	out = getEnt("o_tp1", "targetname");

	for(;;)
    {
        trig waittill ("trigger", player); 

		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);

	}
}

tp2()
{
	trig = getEnt("trig_tp2", "targetname");
	out = getEnt("o_tp2", "targetname");

	for(;;)
    {
        trig waittill ("trigger", player);  

		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);

	}
}

