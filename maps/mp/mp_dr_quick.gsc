main()
{
	thread sr\api\_defrag::weapons("");
thread sr\api\_map::createSpawnOrigin((-2, 15, 16), 90);
	maps\mp\mp_dr_quick_fx::main();
	maps\mp\_load::main();

		thread sr\api\_speedrun::createNormalWays("Normal Way;");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_FallDamageMaxHeight","99999");
	setDvar("bg_FallDamageMinHeight","99998");

	thread start();
	thread moveplat();
}

start()
{
door =getEntArray("start_door", "targetname");
trap0 =getEnt("trap_0_spinner_0", "targetname");
trap1 =getEnt("trap_0_spinner_1", "targetname");
hurt0 =getEnt("trap_0_hurt_0", "targetname");
hurt1 =getEnt("trap_0_hurt_1", "targetname");

wait 0.1;
door[0] delete();
door[1] delete();
trap0 delete();
trap1 delete();
hurt0 delete();
hurt1 delete();

}

moveplat()
{
plat =getEnt("trap_3_platform", "targetname");

plat moveY(-200,0.1);
wait 0.1;
plat rotateYaw(90,0.1);
}