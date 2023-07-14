main()
{
maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-910, 631, 60), 90);
	thread sr\api\_speedrun::createEndMap((-1083.3, 16195.9, -3439.88), 105, 100);
	
	thread spikes();
	thread vehicles();
	thread hammers();
	thread opendoor();
	
}


spikes()
{
	spikes1 = getent("spikes1", "targetname");
	spikes1_hurt = getent("spikes1_hurt", "targetname");
	spikes2 = getent("spikes2", "targetname");
	spikes2_hurt = getent("spikes2_hurt", "targetname");

	spikes1 delete();
	spikes2 delete();
	spikes1_hurt delete();
	spikes2_hurt delete();
}

vehicles()
{
	vehicle1 = getent("vehicle1", "targetname");
	vehicle2 = getent("vehicle2", "targetname");
	vehicle1_hurt = getent("vehicle1_hurt", "targetname");
	vehicle2_hurt = getent("vehicle2_hurt", "targetname");
	vehicle1_clip = getent("vehicle1_clip", "targetname");
	vehicle2_clip = getent("vehicle2_clip", "targetname");

	vehicle1 delete();
	vehicle2 delete();
	vehicle1_hurt delete();
	vehicle2_hurt delete();
	vehicle1_clip delete();
	vehicle2_clip delete();
}


hammers()
{
	hammer1 = getent("hammer1", "targetname");
	hammer2 = getent("hammer2", "targetname");
	hammer3 = getent("hammer3", "targetname");
	hammer1_hurt = getent("hammer1_hurt", "targetname");
	hammer2_hurt = getent("hammer2_hurt", "targetname");
	hammer3_hurt = getent("hammer3_hurt", "targetname");

	hammer1_hurt delete();
	hammer2_hurt delete();
	hammer3_hurt delete();

    hammer1 delete();
	hammer2 delete();
	hammer3 delete();
	
}

opendoor()
{

	door = getent("door", "targetname");
	pusher = getent("pusher", "targetname");
	
	door delete();
	pusher delete();

}
