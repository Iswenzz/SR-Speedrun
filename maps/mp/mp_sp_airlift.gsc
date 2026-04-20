main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_airlift_fx::main();
	
	setExpFog(400, 6500, 0.678352, 0.511225, 0.372533, 0);
	VisionSetNaked( "airlift", 0 );

	thread sr\api\_map::createSpawn((-948, -3807, 4), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	thread sr\api\_speedrun::createTeleporter((-753, -3176, -48), 70, 35, (-2639, -17920, -85), 270, "freeze", "blue", "normal_0");

	thread sr\api\_speedrun::createEndMap((-1778, -20896, 0), 70, 70, "normal_0");

	thread delEnts("targetname", "door_construction");
	thread delEnts("targetname", "door_smoketown_lz");
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