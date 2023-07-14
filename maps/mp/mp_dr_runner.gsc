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
 thread sr\api\_map::createSpawn((42, -771, 60), 360);
 thread sr\api\_speedrun::createTeleporter((1091.12, -5051.38, 0.125), 80, 100, (-1284, -4845, 60), 90, "freeze");
 thread sr\api\_speedrun::createEndMap((-1279.45, -529.076, 0.124998), 140, 100);

 thread startingfence();
 thread teleport1();

}

startingfence()
{
fence = getent ("startdoor","targetname");

fence delete();

}

teleport1()
{
	trig = getEnt("trigger_teleport1", "targetname");
	tele1 = getEnt("origin_teleport1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

