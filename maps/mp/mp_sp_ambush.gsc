main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_ambush_fx::main();

	setExpFog(2000, 5500, .462618, .478346, .455313, 0);
	VisionSetNaked( "ambush", 0 );

	thread sr\api\_map::createSpawn((-395, -83, 52), 315);
	thread sr\api\_speedrun::createNormalWays("Normal Way; Garbage Way");
	thread sr\api\_speedrun::createEndMap((-4750, -9320, 655), 60, 60, "normal_0");
	thread sr\api\_speedrun::createEndMap((1571.19, -3755.98, -1.12036), 90, 70, "normal_1");

	thread sr\api\_speedrun::createTeleporter((-297.797, 52.5412, -7.875), 60, 60, (-4060, -6969, -120), 180, "freeze", "blue", "normal_1");


	thread delEnts("targetname", "rear_blocker");
}

delEnts(property, value, modelFilter)
{
	ents = getEntArray(value, property);

	for (i = 0; i < ents.size; i++)
	{
		if (isDefined(modelFilter))
		{
			if (ents[i].model == modelFilter)
				ents[i] delete();
		}
		else
		{
			ents[i] delete();
		}
	}
}
