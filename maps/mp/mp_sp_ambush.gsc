main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_ambush_fx::main();

	setExpFog(2000, 5500, .462618, .478346, .455313, 0);
	VisionSetNaked( "ambush", 0 );

	thread sr\api\_map::createSpawn((-395, -83, 52), 315);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-4750, -9320, 655), 60, 60, "normal_0");

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
