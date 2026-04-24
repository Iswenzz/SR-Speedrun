main()
{	
	maps\mp\_load::main();
	maps\mp\mp_sp_sniperescape_fx::main();

	setExpFog(6955.87, 14963.9, 0.253734, 0.413721, 0.410622, 0);
	VisionSetNaked( "sniperescape", 0 );

	thread sr\api\_map::createSpawn((563, -10708, 157), 350);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread sr\api\_speedrun::createEndMap((-3547.03, 314.055, 100.529), 75, 60, "normal_0");

	thread delEnts("targetname", "slow_door");
	thread delEnts("targetname", "blocking_fence");
	thread delEnts("targetname", "burnt_retreat_blocker");
	thread delEnts("targetname", "auto1105");
	thread delEnts("targetname", "wounding_sight_blocker");
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
