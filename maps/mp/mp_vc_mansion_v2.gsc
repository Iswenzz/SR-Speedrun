main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((383, 19, 92), 360);

    thread startdoor();
    thread patch();


}


startdoor()
{
 startdoor = getent("startdoor", "targetname");

 startdoor delete();

 
}

patch()
{
	trig = spawn("trigger_radius",(2957.24, 826.202, 198.787), 0, 110, 90);
	trig.radius = 110;

	for(;;)
	{
		trig waittill("trigger",player);

		player Suicide();

	}
}