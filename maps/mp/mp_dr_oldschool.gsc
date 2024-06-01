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
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_map::createSpawn((-467, 237, 76), 270);

thread spawn();

}

spawn()
{
	spawn = GetEnt("spawn_door","targetname");
	empujar = GetEnt("empujon","targetname");

	spawn delete();
	empujar delete();
}