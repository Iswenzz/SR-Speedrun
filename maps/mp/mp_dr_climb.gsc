main() 
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((-29,-3,76),180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((75.2477, 2.52273, 1088.13), 65, 30, (-79, -6, 1668), 180, "freeze", "blue");

	setDvar("bg_FallDamageMaxHeight","99999");
	setDvar("bg_FallDamageMinHeight","99998"); 

	thread startdoor();
	thread trap5();
}

startdoor() 
{
door = getEntArray("start_door", "targetname");

wait 0.1;
door[0] delete();
door[1] delete();
}

trap5() 
{
trap5a = getEnt("trap_5_mover", "targetname");
trap5b = getEnt("trap_5_spinner", "targetname");

wait 0.1;
trap5a moveX(-150,0.1);
trap5b moveX(-150,0.1);

}
