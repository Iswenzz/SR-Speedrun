main()
{
maps\mp\_load::main();

game["allies"]="marines";
game["axis"]="opfor";
game["attackers"]="axis";
game["defenders"]="allies";
game["allies_soldiertype"]="desert";
game["axis_soldiertype"]="desert";

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_map::createSpawn((-44, 88, 76), 90);

thread spawndoor();
thread trap3();

}

spawnDoor()
{
door = getent("spawn_door","targetname");
door2 = getent("spawn_door2","targetname");
finish = getent("finish_door","targetname");
block = getentArray("part1_crouch","targetname");

door delete();
door2 delete();
finish delete();
block[0] delete();
block[1] delete();

}

trap3()
{
blocks = getentarray("trap3_blocks_actual","targetname");

{
	blocks[0] delete();
	blocks[1] delete();
	blocks[2] delete();
	blocks[3] delete();

}	

}
