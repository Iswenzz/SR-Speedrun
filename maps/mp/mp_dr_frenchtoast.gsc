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
thread sr\api\_map::createSpawn((-404, -371, -356), 0);
thread sr\api\_speedrun::createEndMap((-274.233, -318.762, 416.125), 80, 100);
	
}