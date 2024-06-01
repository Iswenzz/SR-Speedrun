main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((181, 4, 92), 0);
	thread sr\api\_speedrun::createEndMap((18.0812, -584.139, 16.125), 90, 100);

	thread mover2();
	

}

mover2()
{

	trig = getEnt ("trig_mover2", "targetname"); // trigger gets entity
	acti = getEnt ("mover_2", "targetname"); // brush get entity
	
	acti moveY (-140,0.1); 
	
}

