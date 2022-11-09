main() 
{
maps\mp\_load::main();
maps\mp\_explosive_barrels::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

thread sr\api\_map::createSpawn((282,-1,-689),180);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread startdoor();
thread trap6();


}	

startdoor()
{
door1 = getEnt("password_game_door", "targetname");
door2 = getEnt("start_platform", "targetname");
door3 = getEnt("misc_1_door", "targetname");

door1 delete();
door2 delete();
door3 delete();

}	

trap6()
{
trap6 = getEnt("trap_6_platform", "targetname");

trap6 moveX(175,0.1);
wait 0.1;
trap6 RotateYaw(90,0.1);

}	